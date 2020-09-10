# SWIFT_ENABLE_TENSORFLOW
function(add_tensorflow_compiler_flags target)
  # TODO: Handle Mac. Not urgent because lldb is built with Xcode by default on Mac.
  if("${CMAKE_SYSTEM_NAME}" STREQUAL "Linux")
    # If INSTALL_PATH is already defined, append a path separater ":".
    get_property(old_rpath TARGET "${target}" PROPERTY INSTALL_RPATH)
    if(old_rpath)
      set_property(TARGET "${target}" APPEND_STRING PROPERTY INSTALL_RPATH ":")
    endif()
    # FIXME: This is a hack: adding rpaths with many `..` that jump across
    # frameworks is bad practice. It would be cleaner/more robust to copy
    # the TensorFlow libraries to the lldb build subdirectory.
    set(swift_lib_dir "../../swift-${HOST_VARIANT}-${HOST_VARIANT_ARCH}")
    set(rpath_lldb_binary "${swift_lib_dir}/lib/swift/${HOST_VARIANT}")
    set(rpath_toolchain_lldb_binary "../lib/swift/${HOST_VARIANT}")
    set(rpath_lldb_python_lib "../../../${rpath_lldb_binary}")
    set(rpath_toolchain_lldb_python_lib "../../../${rpath_lldb_binary}")
    set_property(TARGET "${target}" APPEND_STRING PROPERTY
      INSTALL_RPATH "$ORIGIN/${rpath_lldb_binary}:$ORIGIN/${rpath_toolchain_lldb_binary}:$ORIGIN/${rpath_lldb_python_lib}:$ORIGIN/${rpath_toolchain_lldb_python_lib}")
  endif()
endfunction()
function(lldb_tablegen)
  # Syntax:
  # lldb_tablegen output-file [tablegen-arg ...] SOURCE source-file
  # [[TARGET cmake-target-name] [DEPENDS extra-dependency ...]]
  #
  # Generates a custom command for invoking tblgen as
  #
  # tblgen source-file -o=output-file tablegen-arg ...
  #
  # and, if cmake-target-name is provided, creates a custom target for
  # executing the custom command depending on output-file. It is
  # possible to list more files to depend after DEPENDS.

  cmake_parse_arguments(LTG "" "SOURCE;TARGET" "" ${ARGN})

  if(NOT LTG_SOURCE)
    message(FATAL_ERROR "SOURCE source-file required by lldb_tablegen")
  endif()

  set(LLVM_TARGET_DEFINITIONS ${LTG_SOURCE})
  tablegen(LLDB ${LTG_UNPARSED_ARGUMENTS})

  if(LTG_TARGET)
    add_public_tablegen_target(${LTG_TARGET})
    set_target_properties( ${LTG_TARGET} PROPERTIES FOLDER "LLDB tablegenning")
    set_property(GLOBAL APPEND PROPERTY LLDB_TABLEGEN_TARGETS ${LTG_TARGET})
  endif()
endfunction(lldb_tablegen)

function(add_lldb_library name)
  include_directories(BEFORE
    ${CMAKE_CURRENT_BINARY_DIR}
)

  # only supported parameters to this macro are the optional
  # MODULE;SHARED;STATIC library type and source files
  cmake_parse_arguments(PARAM
    "MODULE;SHARED;STATIC;OBJECT;PLUGIN;FRAMEWORK"
    "INSTALL_PREFIX;ENTITLEMENTS"
    "EXTRA_CXXFLAGS;DEPENDS;LINK_LIBS;LINK_COMPONENTS;CLANG_LIBS"
    ${ARGN})
  llvm_process_sources(srcs ${PARAM_UNPARSED_ARGUMENTS})
  list(APPEND LLVM_LINK_COMPONENTS ${PARAM_LINK_COMPONENTS})

  if(PARAM_PLUGIN)
    set_property(GLOBAL APPEND PROPERTY LLDB_PLUGINS ${name})
  endif()

  if (MSVC_IDE OR XCODE)
    string(REGEX MATCHALL "/[^/]+" split_path ${CMAKE_CURRENT_SOURCE_DIR})
    list(GET split_path -1 dir)
    file(GLOB_RECURSE headers
      ../../include/lldb${dir}/*.h)
    set(srcs ${srcs} ${headers})
  endif()
  if (PARAM_MODULE)
    set(libkind MODULE)
  elseif (PARAM_SHARED)
    set(libkind SHARED)
  elseif (PARAM_OBJECT)
    set(libkind OBJECT)
  else ()
    # PARAM_STATIC or library type unspecified. BUILD_SHARED_LIBS
    # does not control the kind of libraries created for LLDB,
    # only whether or not they link to shared/static LLVM/Clang
    # libraries.
    set(libkind STATIC)
  endif()

  #PIC not needed on Win
  # FIXME: Setting CMAKE_CXX_FLAGS here is a no-op, use target_compile_options
  # or omit this logic instead.
  if (NOT WIN32)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC")
  endif()

  if (PARAM_OBJECT)
    add_library(${name} ${libkind} ${srcs})
  else()
    if(PARAM_ENTITLEMENTS)
      set(pass_ENTITLEMENTS ENTITLEMENTS ${PARAM_ENTITLEMENTS})
    endif()

    if(LLDB_NO_INSTALL_DEFAULT_RPATH)
      set(pass_NO_INSTALL_RPATH NO_INSTALL_RPATH)
    endif()

    llvm_add_library(${name} ${libkind} ${srcs}
      LINK_LIBS ${PARAM_LINK_LIBS}
      DEPENDS ${PARAM_DEPENDS}
      ${pass_ENTITLEMENTS}
      ${pass_NO_INSTALL_RPATH}
    )

    if(CLANG_LINK_CLANG_DYLIB)
      target_link_libraries(${name} PRIVATE clang-cpp)
    else()
      target_link_libraries(${name} PRIVATE ${PARAM_CLANG_LIBS})
    endif()
  endif()

  # A target cannot be changed to a FRAMEWORK after calling install() because
  # this may result in the wrong install DESTINATION. The FRAMEWORK property
  # must be set earlier.
  if(PARAM_FRAMEWORK)
    set_target_properties(liblldb PROPERTIES FRAMEWORK ON)
  endif()

  if(PARAM_SHARED)
    set(install_dest lib${LLVM_LIBDIR_SUFFIX})
    if(PARAM_INSTALL_PREFIX)
      set(install_dest ${PARAM_INSTALL_PREFIX})
    endif()
    # RUNTIME is relevant for DLL platforms, FRAMEWORK for macOS
    install(TARGETS ${name} COMPONENT ${name}
      RUNTIME DESTINATION bin
      LIBRARY DESTINATION ${install_dest}
      ARCHIVE DESTINATION ${install_dest}
      FRAMEWORK DESTINATION ${install_dest})
    if (NOT CMAKE_CONFIGURATION_TYPES)
      add_llvm_install_targets(install-${name}
                              DEPENDS ${name}
                              COMPONENT ${name})
    endif()
  endif()

  # Hack: only some LLDB libraries depend on the clang autogenerated headers,
  # but it is simple enough to make all of LLDB depend on some of those
  # headers without negatively impacting much of anything.
  if(NOT LLDB_BUILT_STANDALONE)
    add_dependencies(${name} clang-tablegen-targets)

    # BEGIN Swift Mods
	if(swift IN_LIST LLVM_EXTERNAL_PROJECTS)
      add_dependencies(${name} swift-syntax-generated-headers)
    endif()
    # END Swift Mods
  endif()

  # Add in any extra C++ compilation flags for this library.
  target_compile_options(${name} PRIVATE ${PARAM_EXTRA_CXXFLAGS})

  if(PARAM_PLUGIN)
    get_property(parent_dir DIRECTORY PROPERTY PARENT_DIRECTORY)
    if(EXISTS ${parent_dir})
      get_filename_component(category ${parent_dir} NAME)
      set_target_properties(${name} PROPERTIES FOLDER "lldb plugins/${category}")
    endif()
  else()
    set_target_properties(${name} PROPERTIES FOLDER "lldb libraries")
  endif()

  # SWIFT_ENABLE_TENSORFLOW
  if(SWIFT_ENABLE_TENSORFLOW)
    add_tensorflow_compiler_flags(${name})
  endif()
endfunction(add_lldb_library)

function(add_lldb_executable name)
  cmake_parse_arguments(ARG
    "GENERATE_INSTALL"
    "INSTALL_PREFIX;ENTITLEMENTS"
    "LINK_LIBS;CLANG_LIBS;LINK_COMPONENTS;BUILD_RPATH;INSTALL_RPATH"
    ${ARGN}
    )

  if(ARG_ENTITLEMENTS)
    set(pass_ENTITLEMENTS ENTITLEMENTS ${ARG_ENTITLEMENTS})
  endif()

  if(LLDB_NO_INSTALL_DEFAULT_RPATH)
    set(pass_NO_INSTALL_RPATH NO_INSTALL_RPATH)
  endif()

  list(APPEND LLVM_LINK_COMPONENTS ${ARG_LINK_COMPONENTS})
  add_llvm_executable(${name}
    ${pass_ENTITLEMENTS}
    ${pass_NO_INSTALL_RPATH}
    ${ARG_UNPARSED_ARGUMENTS}
  )

  target_link_libraries(${name} PRIVATE ${ARG_LINK_LIBS})
  if(CLANG_LINK_CLANG_DYLIB)
    target_link_libraries(${name} PRIVATE clang-cpp)
  else()
    target_link_libraries(${name} PRIVATE ${ARG_CLANG_LIBS})
  endif()
  set_target_properties(${name} PROPERTIES FOLDER "lldb executables")

  if (ARG_BUILD_RPATH)
    set_target_properties(${name} PROPERTIES BUILD_RPATH "${ARG_BUILD_RPATH}")
  endif()

  if (ARG_INSTALL_RPATH)
    set_target_properties(${name} PROPERTIES
      BUILD_WITH_INSTALL_RPATH OFF
      INSTALL_RPATH "${ARG_INSTALL_RPATH}")
  endif()

  if(ARG_GENERATE_INSTALL)
    set(install_dest bin)
    if(ARG_INSTALL_PREFIX)
      set(install_dest ${ARG_INSTALL_PREFIX})
    endif()
    install(TARGETS ${name} COMPONENT ${name}
            RUNTIME DESTINATION ${install_dest}
            LIBRARY DESTINATION ${install_dest}
            BUNDLE DESTINATION ${install_dest}
            FRAMEWORK DESTINATION ${install_dest})
    if (NOT CMAKE_CONFIGURATION_TYPES)
      add_llvm_install_targets(install-${name}
                               DEPENDS ${name}
                               COMPONENT ${name})
    endif()
    if(APPLE AND ARG_INSTALL_PREFIX)
      lldb_add_post_install_steps_darwin(${name} ${ARG_INSTALL_PREFIX})
    endif()
  endif()
  # SWIFT_ENABLE_TENSORFLOW
  if(SWIFT_ENABLE_TENSORFLOW)
    add_tensorflow_compiler_flags(${name})
  endif()
endfunction()


macro(add_lldb_tool_subdirectory name)
  add_llvm_subdirectory(LLDB TOOL ${name})
endmacro()

function(add_lldb_tool name)
  cmake_parse_arguments(ARG "ADD_TO_FRAMEWORK" "" "" ${ARGN})
  if(LLDB_BUILD_FRAMEWORK AND ARG_ADD_TO_FRAMEWORK)
    set(subdir LLDB.framework/Versions/${LLDB_FRAMEWORK_VERSION}/Resources)
    add_lldb_executable(${name}
      GENERATE_INSTALL
      INSTALL_PREFIX ${LLDB_FRAMEWORK_INSTALL_DIR}/${subdir}
      ${ARG_UNPARSED_ARGUMENTS}
    )
    lldb_add_to_buildtree_lldb_framework(${name} ${subdir})
    return()
  endif()

  add_lldb_executable(${name} GENERATE_INSTALL ${ARG_UNPARSED_ARGUMENTS})
endfunction()

# The test suite relies on finding LLDB.framework binary resources in the
# build-tree. Remove them before installing to avoid collisions with their
# own install targets.
function(lldb_add_to_buildtree_lldb_framework name subdir)
  # Destination for the copy in the build-tree. While the framework target may
  # not exist yet, it will exist when the generator expression gets expanded.
  set(copy_dest "${LLDB_FRAMEWORK_ABSOLUTE_BUILD_DIR}/${subdir}/$<TARGET_FILE_NAME:${name}>")

  # Copy into the given subdirectory for testing.
  add_custom_command(TARGET ${name} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:${name}> ${copy_dest}
    COMMENT "Copy ${name} to ${copy_dest}"
  )
endfunction()

# Add extra install steps for dSYM creation and stripping for the given target.
function(lldb_add_post_install_steps_darwin name install_prefix)
  if(NOT APPLE)
    message(WARNING "Darwin-specific functionality; not currently available on non-Apple platforms.")
    return()
  endif()

  get_target_property(output_name ${name} OUTPUT_NAME)
  if(NOT output_name)
    set(output_name ${name})
  endif()

  get_target_property(is_framework ${name} FRAMEWORK)
  if(is_framework)
    get_target_property(buildtree_dir ${name} LIBRARY_OUTPUT_DIRECTORY)
    if(buildtree_dir)
      set(bundle_subdir ${output_name}.framework/Versions/${LLDB_FRAMEWORK_VERSION}/)
    else()
      message(SEND_ERROR "Framework target ${name} missing property for output directory. Cannot generate post-install steps.")
      return()
    endif()
  else()
    get_target_property(target_type ${name} TYPE)
    if(target_type STREQUAL "EXECUTABLE")
      set(buildtree_dir ${LLVM_RUNTIME_OUTPUT_INTDIR})
    else()
      # Only ever install shared libraries.
      set(output_name "lib${output_name}.dylib")
      set(buildtree_dir ${LLVM_LIBRARY_OUTPUT_INTDIR})
    endif()
  endif()

  # Generate dSYM
  # TODO: Add an option to skip dSYM creation
  if(NOT ${name} STREQUAL "repl_swift")
    set(dsym_name ${output_name}.dSYM)
    if(is_framework)
      set(dsym_name ${output_name}.framework.dSYM)
    endif()
    if(LLDB_DEBUGINFO_INSTALL_PREFIX)
      # This makes the path absolute, so we must respect DESTDIR.
      set(dsym_name "\$ENV\{DESTDIR\}${LLDB_DEBUGINFO_INSTALL_PREFIX}/${dsym_name}")
    endif()

    set(buildtree_name ${buildtree_dir}/${bundle_subdir}${output_name})
    install(CODE "message(STATUS \"Externalize debuginfo: ${dsym_name}\")" COMPONENT ${name})
    install(CODE "execute_process(COMMAND xcrun dsymutil -o=${dsym_name} ${buildtree_name})"
            COMPONENT ${name})
  endif()

  if(NOT LLDB_SKIP_STRIP)
    # Strip distribution binary with -ST (removing debug symbol table entries and
    # Swift symbols). Avoid CMAKE_INSTALL_DO_STRIP and llvm_externalize_debuginfo()
    # as they can't be configured sufficiently.
    set(installtree_name "\$ENV\{DESTDIR\}${install_prefix}/${bundle_subdir}${output_name}")
    install(CODE "message(STATUS \"Stripping: ${installtree_name}\")" COMPONENT ${name})
    install(CODE "execute_process(COMMAND xcrun strip -ST ${installtree_name})"
            COMPONENT ${name})
  endif()
endfunction()

# CMake's set_target_properties() doesn't allow to pass lists for RPATH
# properties directly (error: "called with incorrect number of arguments").
# Instead of defining two list variables each time, use this helper function.
function(lldb_setup_rpaths name)
  cmake_parse_arguments(LIST "" "" "BUILD_RPATH;INSTALL_RPATH" ${ARGN})
  set_target_properties(${name} PROPERTIES
    BUILD_WITH_INSTALL_RPATH OFF
    BUILD_RPATH "${LIST_BUILD_RPATH}"
    INSTALL_RPATH "${LIST_INSTALL_RPATH}"
  )
endfunction()

function(lldb_find_system_debugserver path)
  execute_process(COMMAND xcode-select -p
                  RESULT_VARIABLE exit_code
                  OUTPUT_VARIABLE xcode_dev_dir
                  ERROR_VARIABLE error_msg
                  OUTPUT_STRIP_TRAILING_WHITESPACE)
  if(exit_code)
    message(WARNING "`xcode-select -p` failed:\n${error_msg}")
  else()
    set(subpath "LLDB.framework/Resources/debugserver")
    set(path_shared "${xcode_dev_dir}/../SharedFrameworks/${subpath}")
    set(path_private "${xcode_dev_dir}/Library/PrivateFrameworks/${subpath}")

    if(EXISTS ${path_shared})
      set(${path} ${path_shared} PARENT_SCOPE)
    elseif(EXISTS ${path_private})
      set(${path} ${path_private} PARENT_SCOPE)
    else()
      message(WARNING "System debugserver requested, but not found. "
                      "Candidates don't exist: ${path_shared}\n${path_private}")
    endif()
  endif()
endfunction()

# Removes all module flags from the current CMAKE_CXX_FLAGS. Used for
# the Objective-C++ code in lldb which we don't want to build with modules.
# Reasons for this are that modules with Objective-C++ would require that
# all LLVM/Clang modules are Objective-C++ compatible (which they are likely
# not) and we would have rebuild a second set of modules just for the few
# Objective-C++ files in lldb (which slows down the build process).
macro(remove_module_flags)
  string(REGEX REPLACE "-fmodules-cache-path=[^ ]+" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
  string(REGEX REPLACE "-fmodules-local-submodule-visibility" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
  string(REGEX REPLACE "-fmodules" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
  string(REGEX REPLACE "-gmodules" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
  string(REGEX REPLACE "-fcxx-modules" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
endmacro()
