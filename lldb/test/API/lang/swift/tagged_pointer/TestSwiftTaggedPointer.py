# TestSwiftTaggedPointer.py
#
# This source file is part of the Swift.org open source project
#
# Copyright (c) 2014 - 2016 Apple Inc. and the Swift project authors
# Licensed under Apache License v2.0 with Runtime Library Exception
#
# See https://swift.org/LICENSE.txt for license information
# See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
#
# ------------------------------------------------------------------------------
import lldbsuite.test.lldbinline as lldbinline
from lldbsuite.test.decorators import *

# This test depends on NSObject, so it is not available on non-Darwin
# platforms.
lldbinline.MakeInlineTest(__file__, globals(),
                          decorators=[swiftTest,skipUnlessDarwin,
                                      skipIf(bugnumber="rdar://problem/66842937")])
