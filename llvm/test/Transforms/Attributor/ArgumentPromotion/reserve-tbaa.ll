; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes --check-attributes
; RUN: opt -attributor -enable-new-pm=0 -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=3 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=3 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -enable-new-pm=0 -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM

; PR17906
; When we promote two arguments in a single function with different types,
; before the fix, we used the same tag for the newly-created two loads.
; This testing case makes sure that we correctly transfer the tbaa tags from the
; original loads to the newly-created loads when promoting pointer arguments.

@a = global i32* null, align 8
@e = global i32** @a, align 8
@g = global i32 0, align 4
@c = global i64 0, align 8
@d = global i8 0, align 1

define internal fastcc void @fn(i32* nocapture readonly %p1, i64* nocapture readonly %p2) {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@fn
; IS__TUNIT____-SAME: (i32* nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[P1:%.*]])
; IS__TUNIT____-NEXT:  entry:
; IS__TUNIT____-NEXT:    [[TMP0:%.*]] = load i32, i32* @g, align 4, [[TBAA0:!tbaa !.*]]
; IS__TUNIT____-NEXT:    [[CONV1:%.*]] = trunc i32 [[TMP0]] to i8
; IS__TUNIT____-NEXT:    store i8 [[CONV1]], i8* @d, align 1, [[TBAA4:!tbaa !.*]]
; IS__TUNIT____-NEXT:    ret void
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@fn()
; IS__CGSCC____-NEXT:  entry:
; IS__CGSCC____-NEXT:    [[TMP0:%.*]] = load i32, i32* @g, align 4, [[TBAA0:!tbaa !.*]]
; IS__CGSCC____-NEXT:    [[CONV1:%.*]] = trunc i32 [[TMP0]] to i8
; IS__CGSCC____-NEXT:    store i8 [[CONV1]], i8* @d, align 1, [[TBAA4:!tbaa !.*]]
; IS__CGSCC____-NEXT:    ret void
;
entry:
  %0 = load i64, i64* %p2, align 8, !tbaa !1
  %conv = trunc i64 %0 to i32
  %1 = load i32, i32* %p1, align 4, !tbaa !5
  %conv1 = trunc i32 %1 to i8
  store i8 %conv1, i8* @d, align 1, !tbaa !7
  ret void
}

define i32 @main() {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@main()
; IS__TUNIT____-NEXT:  entry:
; IS__TUNIT____-NEXT:    [[TMP0:%.*]] = load i32**, i32*** @e, align 8, [[TBAA5:!tbaa !.*]]
; IS__TUNIT____-NEXT:    store i32* @g, i32** [[TMP0]], align 8, [[TBAA5]]
; IS__TUNIT____-NEXT:    [[TMP1:%.*]] = load i32*, i32** @a, align 8, [[TBAA5]]
; IS__TUNIT____-NEXT:    store i32 1, i32* [[TMP1]], align 4, [[TBAA0]]
; IS__TUNIT____-NEXT:    call fastcc void @fn(i32* nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) @g)
; IS__TUNIT____-NEXT:    ret i32 0
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@main()
; IS__CGSCC____-NEXT:  entry:
; IS__CGSCC____-NEXT:    [[TMP0:%.*]] = load i32**, i32*** @e, align 8, [[TBAA5:!tbaa !.*]]
; IS__CGSCC____-NEXT:    store i32* @g, i32** [[TMP0]], align 8, [[TBAA5]]
; IS__CGSCC____-NEXT:    [[TMP1:%.*]] = load i32*, i32** @a, align 8, [[TBAA5]]
; IS__CGSCC____-NEXT:    store i32 1, i32* [[TMP1]], align 4, [[TBAA0]]
; IS__CGSCC____-NEXT:    call fastcc void @fn()
; IS__CGSCC____-NEXT:    ret i32 0
;
entry:
  %0 = load i32**, i32*** @e, align 8, !tbaa !8
  store i32* @g, i32** %0, align 8, !tbaa !8
  %1 = load i32*, i32** @a, align 8, !tbaa !8
  store i32 1, i32* %1, align 4, !tbaa !5
  call fastcc void @fn(i32* @g, i64* @c)

  ret i32 0
}

!1 = !{!2, !2, i64 0}
!2 = !{!"long", !3, i64 0}
!3 = !{!"omnipotent char", !4, i64 0}
!4 = !{!"Simple C/C++ TBAA"}
!5 = !{!6, !6, i64 0}
!6 = !{!"int", !3, i64 0}
!7 = !{!3, !3, i64 0}
!8 = !{!9, !9, i64 0}
!9 = !{!"any pointer", !3, i64 0}

