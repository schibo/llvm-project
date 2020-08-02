; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=-popcnt | FileCheck %s --check-prefix=X86-NOPOPCNT
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=-popcnt | FileCheck %s --check-prefix=X64-NOPOPCNT
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+popcnt | FileCheck %s --check-prefix=X86-POPCNT
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+popcnt | FileCheck %s --check-prefix=X64-POPCNT

define i32 @parity_32(i32 %x) {
; X86-NOPOPCNT-LABEL: parity_32:
; X86-NOPOPCNT:       # %bb.0:
; X86-NOPOPCNT-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NOPOPCNT-NEXT:    movl %eax, %ecx
; X86-NOPOPCNT-NEXT:    shrl $16, %ecx
; X86-NOPOPCNT-NEXT:    xorl %eax, %ecx
; X86-NOPOPCNT-NEXT:    xorl %eax, %eax
; X86-NOPOPCNT-NEXT:    xorb %ch, %cl
; X86-NOPOPCNT-NEXT:    setnp %al
; X86-NOPOPCNT-NEXT:    retl
;
; X64-NOPOPCNT-LABEL: parity_32:
; X64-NOPOPCNT:       # %bb.0:
; X64-NOPOPCNT-NEXT:    movl %edi, %ecx
; X64-NOPOPCNT-NEXT:    shrl $16, %ecx
; X64-NOPOPCNT-NEXT:    xorl %edi, %ecx
; X64-NOPOPCNT-NEXT:    movl %ecx, %edx
; X64-NOPOPCNT-NEXT:    shrl $8, %edx
; X64-NOPOPCNT-NEXT:    xorl %eax, %eax
; X64-NOPOPCNT-NEXT:    xorb %cl, %dl
; X64-NOPOPCNT-NEXT:    setnp %al
; X64-NOPOPCNT-NEXT:    retq
;
; X86-POPCNT-LABEL: parity_32:
; X86-POPCNT:       # %bb.0:
; X86-POPCNT-NEXT:    popcntl {{[0-9]+}}(%esp), %eax
; X86-POPCNT-NEXT:    andl $1, %eax
; X86-POPCNT-NEXT:    retl
;
; X64-POPCNT-LABEL: parity_32:
; X64-POPCNT:       # %bb.0:
; X64-POPCNT-NEXT:    popcntl %edi, %eax
; X64-POPCNT-NEXT:    andl $1, %eax
; X64-POPCNT-NEXT:    retq
  %1 = tail call i32 @llvm.ctpop.i32(i32 %x)
  %2 = and i32 %1, 1
  ret i32 %2
}

define i64 @parity_64(i64 %x) {
; X86-NOPOPCNT-LABEL: parity_64:
; X86-NOPOPCNT:       # %bb.0:
; X86-NOPOPCNT-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NOPOPCNT-NEXT:    xorl {{[0-9]+}}(%esp), %eax
; X86-NOPOPCNT-NEXT:    movl %eax, %ecx
; X86-NOPOPCNT-NEXT:    shrl $16, %ecx
; X86-NOPOPCNT-NEXT:    xorl %eax, %ecx
; X86-NOPOPCNT-NEXT:    xorl %eax, %eax
; X86-NOPOPCNT-NEXT:    xorb %ch, %cl
; X86-NOPOPCNT-NEXT:    setnp %al
; X86-NOPOPCNT-NEXT:    xorl %edx, %edx
; X86-NOPOPCNT-NEXT:    retl
;
; X64-NOPOPCNT-LABEL: parity_64:
; X64-NOPOPCNT:       # %bb.0:
; X64-NOPOPCNT-NEXT:    movq %rdi, %rax
; X64-NOPOPCNT-NEXT:    shrq $32, %rax
; X64-NOPOPCNT-NEXT:    xorl %edi, %eax
; X64-NOPOPCNT-NEXT:    movl %eax, %ecx
; X64-NOPOPCNT-NEXT:    shrl $16, %ecx
; X64-NOPOPCNT-NEXT:    xorl %eax, %ecx
; X64-NOPOPCNT-NEXT:    movl %ecx, %edx
; X64-NOPOPCNT-NEXT:    shrl $8, %edx
; X64-NOPOPCNT-NEXT:    xorl %eax, %eax
; X64-NOPOPCNT-NEXT:    xorb %cl, %dl
; X64-NOPOPCNT-NEXT:    setnp %al
; X64-NOPOPCNT-NEXT:    retq
;
; X86-POPCNT-LABEL: parity_64:
; X86-POPCNT:       # %bb.0:
; X86-POPCNT-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-POPCNT-NEXT:    xorl {{[0-9]+}}(%esp), %eax
; X86-POPCNT-NEXT:    popcntl %eax, %eax
; X86-POPCNT-NEXT:    andl $1, %eax
; X86-POPCNT-NEXT:    xorl %edx, %edx
; X86-POPCNT-NEXT:    retl
;
; X64-POPCNT-LABEL: parity_64:
; X64-POPCNT:       # %bb.0:
; X64-POPCNT-NEXT:    popcntq %rdi, %rax
; X64-POPCNT-NEXT:    andl $1, %eax
; X64-POPCNT-NEXT:    retq
  %1 = tail call i64 @llvm.ctpop.i64(i64 %x)
  %2 = and i64 %1, 1
  ret i64 %2
}

define i32 @parity_64_trunc(i64 %x) {
; X86-NOPOPCNT-LABEL: parity_64_trunc:
; X86-NOPOPCNT:       # %bb.0:
; X86-NOPOPCNT-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NOPOPCNT-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NOPOPCNT-NEXT:    movl %ecx, %edx
; X86-NOPOPCNT-NEXT:    shrl %edx
; X86-NOPOPCNT-NEXT:    andl $1431655765, %edx # imm = 0x55555555
; X86-NOPOPCNT-NEXT:    subl %edx, %ecx
; X86-NOPOPCNT-NEXT:    movl %ecx, %edx
; X86-NOPOPCNT-NEXT:    andl $858993459, %edx # imm = 0x33333333
; X86-NOPOPCNT-NEXT:    shrl $2, %ecx
; X86-NOPOPCNT-NEXT:    andl $858993459, %ecx # imm = 0x33333333
; X86-NOPOPCNT-NEXT:    addl %edx, %ecx
; X86-NOPOPCNT-NEXT:    movl %ecx, %edx
; X86-NOPOPCNT-NEXT:    shrl $4, %edx
; X86-NOPOPCNT-NEXT:    addl %ecx, %edx
; X86-NOPOPCNT-NEXT:    andl $17764111, %edx # imm = 0x10F0F0F
; X86-NOPOPCNT-NEXT:    imull $16843009, %edx, %ecx # imm = 0x1010101
; X86-NOPOPCNT-NEXT:    shrl $24, %ecx
; X86-NOPOPCNT-NEXT:    movl %eax, %edx
; X86-NOPOPCNT-NEXT:    shrl %edx
; X86-NOPOPCNT-NEXT:    andl $1431655765, %edx # imm = 0x55555555
; X86-NOPOPCNT-NEXT:    subl %edx, %eax
; X86-NOPOPCNT-NEXT:    movl %eax, %edx
; X86-NOPOPCNT-NEXT:    andl $858993459, %edx # imm = 0x33333333
; X86-NOPOPCNT-NEXT:    shrl $2, %eax
; X86-NOPOPCNT-NEXT:    andl $858993459, %eax # imm = 0x33333333
; X86-NOPOPCNT-NEXT:    addl %edx, %eax
; X86-NOPOPCNT-NEXT:    movl %eax, %edx
; X86-NOPOPCNT-NEXT:    shrl $4, %edx
; X86-NOPOPCNT-NEXT:    addl %eax, %edx
; X86-NOPOPCNT-NEXT:    andl $17764111, %edx # imm = 0x10F0F0F
; X86-NOPOPCNT-NEXT:    imull $16843009, %edx, %eax # imm = 0x1010101
; X86-NOPOPCNT-NEXT:    shrl $24, %eax
; X86-NOPOPCNT-NEXT:    addl %ecx, %eax
; X86-NOPOPCNT-NEXT:    andl $1, %eax
; X86-NOPOPCNT-NEXT:    retl
;
; X64-NOPOPCNT-LABEL: parity_64_trunc:
; X64-NOPOPCNT:       # %bb.0:
; X64-NOPOPCNT-NEXT:    movq %rdi, %rax
; X64-NOPOPCNT-NEXT:    shrq %rax
; X64-NOPOPCNT-NEXT:    movabsq $6148914691236517205, %rcx # imm = 0x5555555555555555
; X64-NOPOPCNT-NEXT:    andq %rax, %rcx
; X64-NOPOPCNT-NEXT:    subq %rcx, %rdi
; X64-NOPOPCNT-NEXT:    movabsq $3689348814741910323, %rax # imm = 0x3333333333333333
; X64-NOPOPCNT-NEXT:    movq %rdi, %rcx
; X64-NOPOPCNT-NEXT:    andq %rax, %rcx
; X64-NOPOPCNT-NEXT:    shrq $2, %rdi
; X64-NOPOPCNT-NEXT:    andq %rax, %rdi
; X64-NOPOPCNT-NEXT:    addq %rcx, %rdi
; X64-NOPOPCNT-NEXT:    movq %rdi, %rax
; X64-NOPOPCNT-NEXT:    shrq $4, %rax
; X64-NOPOPCNT-NEXT:    addq %rdi, %rax
; X64-NOPOPCNT-NEXT:    movabsq $76296276040158991, %rcx # imm = 0x10F0F0F0F0F0F0F
; X64-NOPOPCNT-NEXT:    andq %rax, %rcx
; X64-NOPOPCNT-NEXT:    movabsq $72340172838076673, %rax # imm = 0x101010101010101
; X64-NOPOPCNT-NEXT:    imulq %rcx, %rax
; X64-NOPOPCNT-NEXT:    shrq $56, %rax
; X64-NOPOPCNT-NEXT:    andl $1, %eax
; X64-NOPOPCNT-NEXT:    # kill: def $eax killed $eax killed $rax
; X64-NOPOPCNT-NEXT:    retq
;
; X86-POPCNT-LABEL: parity_64_trunc:
; X86-POPCNT:       # %bb.0:
; X86-POPCNT-NEXT:    popcntl {{[0-9]+}}(%esp), %ecx
; X86-POPCNT-NEXT:    popcntl {{[0-9]+}}(%esp), %eax
; X86-POPCNT-NEXT:    addl %ecx, %eax
; X86-POPCNT-NEXT:    andl $1, %eax
; X86-POPCNT-NEXT:    retl
;
; X64-POPCNT-LABEL: parity_64_trunc:
; X64-POPCNT:       # %bb.0:
; X64-POPCNT-NEXT:    popcntq %rdi, %rax
; X64-POPCNT-NEXT:    andl $1, %eax
; X64-POPCNT-NEXT:    # kill: def $eax killed $eax killed $rax
; X64-POPCNT-NEXT:    retq
  %1 = tail call i64 @llvm.ctpop.i64(i64 %x)
  %2 = trunc i64 %1 to i32
  %3 = and i32 %2, 1
  ret i32 %3
}

define i8 @parity_32_trunc(i32 %x) {
; X86-NOPOPCNT-LABEL: parity_32_trunc:
; X86-NOPOPCNT:       # %bb.0:
; X86-NOPOPCNT-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NOPOPCNT-NEXT:    movl %eax, %ecx
; X86-NOPOPCNT-NEXT:    shrl %ecx
; X86-NOPOPCNT-NEXT:    andl $1431655765, %ecx # imm = 0x55555555
; X86-NOPOPCNT-NEXT:    subl %ecx, %eax
; X86-NOPOPCNT-NEXT:    movl %eax, %ecx
; X86-NOPOPCNT-NEXT:    andl $858993459, %ecx # imm = 0x33333333
; X86-NOPOPCNT-NEXT:    shrl $2, %eax
; X86-NOPOPCNT-NEXT:    andl $858993459, %eax # imm = 0x33333333
; X86-NOPOPCNT-NEXT:    addl %ecx, %eax
; X86-NOPOPCNT-NEXT:    movl %eax, %ecx
; X86-NOPOPCNT-NEXT:    shrl $4, %ecx
; X86-NOPOPCNT-NEXT:    addl %eax, %ecx
; X86-NOPOPCNT-NEXT:    andl $17764111, %ecx # imm = 0x10F0F0F
; X86-NOPOPCNT-NEXT:    imull $16843009, %ecx, %eax # imm = 0x1010101
; X86-NOPOPCNT-NEXT:    shrl $24, %eax
; X86-NOPOPCNT-NEXT:    andb $1, %al
; X86-NOPOPCNT-NEXT:    # kill: def $al killed $al killed $eax
; X86-NOPOPCNT-NEXT:    retl
;
; X64-NOPOPCNT-LABEL: parity_32_trunc:
; X64-NOPOPCNT:       # %bb.0:
; X64-NOPOPCNT-NEXT:    movl %edi, %eax
; X64-NOPOPCNT-NEXT:    shrl %eax
; X64-NOPOPCNT-NEXT:    andl $1431655765, %eax # imm = 0x55555555
; X64-NOPOPCNT-NEXT:    subl %eax, %edi
; X64-NOPOPCNT-NEXT:    movl %edi, %eax
; X64-NOPOPCNT-NEXT:    andl $858993459, %eax # imm = 0x33333333
; X64-NOPOPCNT-NEXT:    shrl $2, %edi
; X64-NOPOPCNT-NEXT:    andl $858993459, %edi # imm = 0x33333333
; X64-NOPOPCNT-NEXT:    addl %eax, %edi
; X64-NOPOPCNT-NEXT:    movl %edi, %eax
; X64-NOPOPCNT-NEXT:    shrl $4, %eax
; X64-NOPOPCNT-NEXT:    addl %edi, %eax
; X64-NOPOPCNT-NEXT:    andl $17764111, %eax # imm = 0x10F0F0F
; X64-NOPOPCNT-NEXT:    imull $16843009, %eax, %eax # imm = 0x1010101
; X64-NOPOPCNT-NEXT:    shrl $24, %eax
; X64-NOPOPCNT-NEXT:    andb $1, %al
; X64-NOPOPCNT-NEXT:    # kill: def $al killed $al killed $eax
; X64-NOPOPCNT-NEXT:    retq
;
; X86-POPCNT-LABEL: parity_32_trunc:
; X86-POPCNT:       # %bb.0:
; X86-POPCNT-NEXT:    popcntl {{[0-9]+}}(%esp), %eax
; X86-POPCNT-NEXT:    andb $1, %al
; X86-POPCNT-NEXT:    # kill: def $al killed $al killed $eax
; X86-POPCNT-NEXT:    retl
;
; X64-POPCNT-LABEL: parity_32_trunc:
; X64-POPCNT:       # %bb.0:
; X64-POPCNT-NEXT:    popcntl %edi, %eax
; X64-POPCNT-NEXT:    andb $1, %al
; X64-POPCNT-NEXT:    # kill: def $al killed $al killed $eax
; X64-POPCNT-NEXT:    retq
  %1 = tail call i32 @llvm.ctpop.i32(i32 %x)
  %2 = trunc i32 %1 to i8
  %3 = and i8 %2, 1
  ret i8 %3
}

declare i32 @llvm.ctpop.i32(i32 %x)
declare i64 @llvm.ctpop.i64(i64 %x)
