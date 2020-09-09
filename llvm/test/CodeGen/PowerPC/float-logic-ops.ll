; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mcpu=pwr8 -mtriple=powerpc64le-unknown-unknown \
; RUN:   -ppc-asm-full-reg-names -verify-machineinstrs -O2 < %s | FileCheck %s

define float @absf(float %a) {
; CHECK-LABEL: absf:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xsabsdp f1, f1
; CHECK-NEXT:    blr
entry:
  %conv = bitcast float %a to i32
  %and = and i32 %conv, 2147483647
  %conv1 = bitcast i32 %and to float
  ret float %conv1
}

define double @absd(double %a) {
; CHECK-LABEL: absd:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xsabsdp f1, f1
; CHECK-NEXT:    blr
entry:
  %conv = bitcast double %a to i64
  %and = and i64 %conv, 9223372036854775807
  %conv1 = bitcast i64 %and to double
  ret double %conv1
}

define <4 x float> @absv4f32(<4 x float> %a) {
; CHECK-LABEL: absv4f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvabssp vs34, vs34
; CHECK-NEXT:    blr
entry:
  %conv = bitcast <4 x float> %a to <4 x i32>
  %and = and <4 x i32> %conv, <i32 2147483647, i32 2147483647, i32 2147483647, i32 2147483647>
  %conv1 = bitcast <4 x i32> %and to <4 x float>
  ret <4 x float> %conv1
}

define <4 x float> @absv4f32_wundef(<4 x float> %a) {
; CHECK-LABEL: absv4f32_wundef:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvabssp vs34, vs34
; CHECK-NEXT:    blr
entry:
  %conv = bitcast <4 x float> %a to <4 x i32>
  %and = and <4 x i32> %conv, <i32 2147483647, i32 undef, i32 undef, i32 2147483647>
  %conv1 = bitcast <4 x i32> %and to <4 x float>
  ret <4 x float> %conv1
}

define <4 x float> @absv4f32_invalid(<4 x float> %a) {
; CHECK-LABEL: absv4f32_invalid:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addis r3, r2, .LCPI4_0@toc@ha
; CHECK-NEXT:    addi r3, r3, .LCPI4_0@toc@l
; CHECK-NEXT:    lvx v3, 0, r3
; CHECK-NEXT:    xxland vs34, vs34, vs35
; CHECK-NEXT:    blr
entry:
  %conv = bitcast <4 x float> %a to <4 x i32>
  %and = and <4 x i32> %conv, <i32 2147483646, i32 2147483647, i32 2147483647, i32 2147483647>
  %conv1 = bitcast <4 x i32> %and to <4 x float>
  ret <4 x float> %conv1
}

define <2 x double> @absv2f64(<2 x double> %a) {
; CHECK-LABEL: absv2f64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvabsdp vs34, vs34
; CHECK-NEXT:    blr
entry:
  %conv = bitcast <2 x double> %a to <2 x i64>
  %and = and <2 x i64> %conv, <i64 9223372036854775807, i64 9223372036854775807>
  %conv1 = bitcast <2 x i64> %and to <2 x double>
  ret <2 x double> %conv1
}

define float @negf(float %a) {
; CHECK-LABEL: negf:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xsnegdp f1, f1
; CHECK-NEXT:    blr
entry:
  %conv = bitcast float %a to i32
  %and = xor i32 %conv, -2147483648
  %conv1 = bitcast i32 %and to float
  ret float %conv1
}

define double @negd(double %a) {
; CHECK-LABEL: negd:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xsnegdp f1, f1
; CHECK-NEXT:    blr
entry:
  %conv = bitcast double %a to i64
  %and = xor i64 %conv, -9223372036854775808
  %conv1 = bitcast i64 %and to double
  ret double %conv1
}

define <4 x float> @negv4f32(<4 x float> %a) {
; CHECK-LABEL: negv4f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvnegsp vs34, vs34
; CHECK-NEXT:    blr
entry:
  %conv = bitcast <4 x float> %a to <4 x i32>
  %and = xor <4 x i32> %conv, <i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648>
  %conv1 = bitcast <4 x i32> %and to <4 x float>
  ret <4 x float> %conv1
}

define <2 x double> @negv2d64(<2 x double> %a) {
; CHECK-LABEL: negv2d64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvnegdp vs34, vs34
; CHECK-NEXT:    blr
entry:
  %conv = bitcast <2 x double> %a to <2 x i64>
  %and = xor <2 x i64> %conv, <i64 -9223372036854775808, i64 -9223372036854775808>
  %conv1 = bitcast <2 x i64> %and to <2 x double>
  ret <2 x double> %conv1
}
define float @nabsf(float %a) {
; CHECK-LABEL: nabsf:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xsnabsdp f1, f1
; CHECK-NEXT:    blr
entry:
  %conv = bitcast float %a to i32
  %and = or i32 %conv, -2147483648
  %conv1 = bitcast i32 %and to float
  ret float %conv1
}

define double @nabsd(double %a) {
; CHECK-LABEL: nabsd:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xsnabsdp f1, f1
; CHECK-NEXT:    blr
entry:
  %conv = bitcast double %a to i64
  %and = or i64 %conv, -9223372036854775808
  %conv1 = bitcast i64 %and to double
  ret double %conv1
}

define <4 x float> @nabsv4f32(<4 x float> %a) {
; CHECK-LABEL: nabsv4f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvnabssp vs34, vs34
; CHECK-NEXT:    blr
entry:
  %conv = bitcast <4 x float> %a to <4 x i32>
  %and = or <4 x i32> %conv, <i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648>
  %conv1 = bitcast <4 x i32> %and to <4 x float>
  ret <4 x float> %conv1
}

define <2 x double> @nabsv2d64(<2 x double> %a) {
; CHECK-LABEL: nabsv2d64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xvnabsdp vs34, vs34
; CHECK-NEXT:    blr
entry:
  %conv = bitcast <2 x double> %a to <2 x i64>
  %and = or <2 x i64> %conv, <i64 -9223372036854775808, i64 -9223372036854775808>
  %conv1 = bitcast <2 x i64> %and to <2 x double>
  ret <2 x double> %conv1
}

