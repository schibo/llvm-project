; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=ALL --check-prefix=AVX --check-prefix=AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=ALL --check-prefix=AVX --check-prefix=AVX2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512vpopcntdq | FileCheck %s --check-prefix=ALL --check-prefix=AVX --check-prefix=AVX512VPOPCNTDQ
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512bitalg | FileCheck %s --check-prefix=ALL --check-prefix=AVX --check-prefix=BITALG_NOVLX
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512bitalg,+avx512vl | FileCheck %s --check-prefix=ALL --check-prefix=BITALG

define <4 x i64> @testv4i64(<4 x i64> %in) nounwind {
; AVX1-LABEL: testv4i64:
; AVX1:       # BB#0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm2 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
; AVX1-NEXT:    vpand %xmm2, %xmm1, %xmm3
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm4 = [0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4]
; AVX1-NEXT:    vpshufb %xmm3, %xmm4, %xmm3
; AVX1-NEXT:    vpsrlw $4, %xmm1, %xmm1
; AVX1-NEXT:    vpand %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vpshufb %xmm1, %xmm4, %xmm1
; AVX1-NEXT:    vpaddb %xmm3, %xmm1, %xmm1
; AVX1-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX1-NEXT:    vpsadbw %xmm3, %xmm1, %xmm1
; AVX1-NEXT:    vpand %xmm2, %xmm0, %xmm5
; AVX1-NEXT:    vpshufb %xmm5, %xmm4, %xmm5
; AVX1-NEXT:    vpsrlw $4, %xmm0, %xmm0
; AVX1-NEXT:    vpand %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vpshufb %xmm0, %xmm4, %xmm0
; AVX1-NEXT:    vpaddb %xmm5, %xmm0, %xmm0
; AVX1-NEXT:    vpsadbw %xmm3, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: testv4i64:
; AVX2:       # BB#0:
; AVX2-NEXT:    vmovdqa {{.*#+}} ymm1 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
; AVX2-NEXT:    vpand %ymm1, %ymm0, %ymm2
; AVX2-NEXT:    vmovdqa {{.*#+}} ymm3 = [0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4]
; AVX2-NEXT:    vpshufb %ymm2, %ymm3, %ymm2
; AVX2-NEXT:    vpsrlw $4, %ymm0, %ymm0
; AVX2-NEXT:    vpand %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpshufb %ymm0, %ymm3, %ymm0
; AVX2-NEXT:    vpaddb %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX2-NEXT:    vpsadbw %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512VPOPCNTDQ-LABEL: testv4i64:
; AVX512VPOPCNTDQ:       # BB#0:
; AVX512VPOPCNTDQ-NEXT:    # kill: %YMM0<def> %YMM0<kill> %ZMM0<def>
; AVX512VPOPCNTDQ-NEXT:    vpopcntq %zmm0, %zmm0
; AVX512VPOPCNTDQ-NEXT:    # kill: %YMM0<def> %YMM0<kill> %ZMM0<kill>
; AVX512VPOPCNTDQ-NEXT:    retq
  %out = call <4 x i64> @llvm.ctpop.v4i64(<4 x i64> %in)
  ret <4 x i64> %out
}

define <8 x i32> @testv8i32(<8 x i32> %in) nounwind {
; AVX1-LABEL: testv8i32:
; AVX1:       # BB#0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm2 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
; AVX1-NEXT:    vpand %xmm2, %xmm1, %xmm3
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm4 = [0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4]
; AVX1-NEXT:    vpshufb %xmm3, %xmm4, %xmm3
; AVX1-NEXT:    vpsrlw $4, %xmm1, %xmm1
; AVX1-NEXT:    vpand %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vpshufb %xmm1, %xmm4, %xmm1
; AVX1-NEXT:    vpaddb %xmm3, %xmm1, %xmm1
; AVX1-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX1-NEXT:    vpunpckhdq {{.*#+}} xmm5 = xmm1[2],xmm3[2],xmm1[3],xmm3[3]
; AVX1-NEXT:    vpsadbw %xmm3, %xmm5, %xmm5
; AVX1-NEXT:    vpmovzxdq {{.*#+}} xmm1 = xmm1[0],zero,xmm1[1],zero
; AVX1-NEXT:    vpsadbw %xmm3, %xmm1, %xmm1
; AVX1-NEXT:    vpackuswb %xmm5, %xmm1, %xmm1
; AVX1-NEXT:    vpand %xmm2, %xmm0, %xmm5
; AVX1-NEXT:    vpshufb %xmm5, %xmm4, %xmm5
; AVX1-NEXT:    vpsrlw $4, %xmm0, %xmm0
; AVX1-NEXT:    vpand %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vpshufb %xmm0, %xmm4, %xmm0
; AVX1-NEXT:    vpaddb %xmm5, %xmm0, %xmm0
; AVX1-NEXT:    vpunpckhdq {{.*#+}} xmm2 = xmm0[2],xmm3[2],xmm0[3],xmm3[3]
; AVX1-NEXT:    vpsadbw %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vpmovzxdq {{.*#+}} xmm0 = xmm0[0],zero,xmm0[1],zero
; AVX1-NEXT:    vpsadbw %xmm3, %xmm0, %xmm0
; AVX1-NEXT:    vpackuswb %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: testv8i32:
; AVX2:       # BB#0:
; AVX2-NEXT:    vmovdqa {{.*#+}} ymm1 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
; AVX2-NEXT:    vpand %ymm1, %ymm0, %ymm2
; AVX2-NEXT:    vmovdqa {{.*#+}} ymm3 = [0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4]
; AVX2-NEXT:    vpshufb %ymm2, %ymm3, %ymm2
; AVX2-NEXT:    vpsrlw $4, %ymm0, %ymm0
; AVX2-NEXT:    vpand %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpshufb %ymm0, %ymm3, %ymm0
; AVX2-NEXT:    vpaddb %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX2-NEXT:    vpunpckhdq {{.*#+}} ymm2 = ymm0[2],ymm1[2],ymm0[3],ymm1[3],ymm0[6],ymm1[6],ymm0[7],ymm1[7]
; AVX2-NEXT:    vpsadbw %ymm1, %ymm2, %ymm2
; AVX2-NEXT:    vpunpckldq {{.*#+}} ymm0 = ymm0[0],ymm1[0],ymm0[1],ymm1[1],ymm0[4],ymm1[4],ymm0[5],ymm1[5]
; AVX2-NEXT:    vpsadbw %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpackuswb %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512VPOPCNTDQ-LABEL: testv8i32:
; AVX512VPOPCNTDQ:       # BB#0:
; AVX512VPOPCNTDQ-NEXT:    # kill: %YMM0<def> %YMM0<kill> %ZMM0<def>
; AVX512VPOPCNTDQ-NEXT:    vpopcntd %zmm0, %zmm0
; AVX512VPOPCNTDQ-NEXT:    # kill: %YMM0<def> %YMM0<kill> %ZMM0<kill>
; AVX512VPOPCNTDQ-NEXT:    retq
  %out = call <8 x i32> @llvm.ctpop.v8i32(<8 x i32> %in)
  ret <8 x i32> %out
}

define <16 x i16> @testv16i16(<16 x i16> %in) nounwind {
; AVX1-LABEL: testv16i16:
; AVX1:       # BB#0:
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm1 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
; AVX1-NEXT:    vpand %xmm1, %xmm0, %xmm2
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm3 = [0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4]
; AVX1-NEXT:    vpshufb %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpsrlw $4, %xmm0, %xmm4
; AVX1-NEXT:    vpand %xmm1, %xmm4, %xmm4
; AVX1-NEXT:    vpshufb %xmm4, %xmm3, %xmm4
; AVX1-NEXT:    vpaddb %xmm2, %xmm4, %xmm2
; AVX1-NEXT:    vpsllw $8, %xmm2, %xmm4
; AVX1-NEXT:    vpaddb %xmm2, %xmm4, %xmm2
; AVX1-NEXT:    vpsrlw $8, %xmm2, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    vpand %xmm1, %xmm0, %xmm4
; AVX1-NEXT:    vpshufb %xmm4, %xmm3, %xmm4
; AVX1-NEXT:    vpsrlw $4, %xmm0, %xmm0
; AVX1-NEXT:    vpand %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vpshufb %xmm0, %xmm3, %xmm0
; AVX1-NEXT:    vpaddb %xmm4, %xmm0, %xmm0
; AVX1-NEXT:    vpsllw $8, %xmm0, %xmm1
; AVX1-NEXT:    vpaddb %xmm0, %xmm1, %xmm0
; AVX1-NEXT:    vpsrlw $8, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm2, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: testv16i16:
; AVX2:       # BB#0:
; AVX2-NEXT:    vmovdqa {{.*#+}} ymm1 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
; AVX2-NEXT:    vpand %ymm1, %ymm0, %ymm2
; AVX2-NEXT:    vmovdqa {{.*#+}} ymm3 = [0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4]
; AVX2-NEXT:    vpshufb %ymm2, %ymm3, %ymm2
; AVX2-NEXT:    vpsrlw $4, %ymm0, %ymm0
; AVX2-NEXT:    vpand %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpshufb %ymm0, %ymm3, %ymm0
; AVX2-NEXT:    vpaddb %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    vpsllw $8, %ymm0, %ymm1
; AVX2-NEXT:    vpaddb %ymm0, %ymm1, %ymm0
; AVX2-NEXT:    vpsrlw $8, %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512VPOPCNTDQ-LABEL: testv16i16:
; AVX512VPOPCNTDQ:       # BB#0:
; AVX512VPOPCNTDQ-NEXT:    vpmovzxwd {{.*#+}} zmm0 = ymm0[0],zero,ymm0[1],zero,ymm0[2],zero,ymm0[3],zero,ymm0[4],zero,ymm0[5],zero,ymm0[6],zero,ymm0[7],zero,ymm0[8],zero,ymm0[9],zero,ymm0[10],zero,ymm0[11],zero,ymm0[12],zero,ymm0[13],zero,ymm0[14],zero,ymm0[15],zero
; AVX512VPOPCNTDQ-NEXT:    vpopcntd %zmm0, %zmm0
; AVX512VPOPCNTDQ-NEXT:    vpmovdw %zmm0, %ymm0
; AVX512VPOPCNTDQ-NEXT:    retq
;
; BITALG_NOVLX-LABEL: testv16i16:
; BITALG_NOVLX:       # BB#0:
; BITALG_NOVLX-NEXT:    # kill: %YMM0<def> %YMM0<kill> %ZMM0<def>
; BITALG_NOVLX-NEXT:    vpopcntw %zmm0, %zmm0
; BITALG_NOVLX-NEXT:    # kill: %YMM0<def> %YMM0<kill> %ZMM0<kill>
; BITALG_NOVLX-NEXT:    retq
;
; BITALG-LABEL: testv16i16:
; BITALG:       # BB#0:
; BITALG-NEXT:    vpopcntw %ymm0, %ymm0
; BITALG-NEXT:    retq
  %out = call <16 x i16> @llvm.ctpop.v16i16(<16 x i16> %in)
  ret <16 x i16> %out
}

define <32 x i8> @testv32i8(<32 x i8> %in) nounwind {
; AVX1-LABEL: testv32i8:
; AVX1:       # BB#0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm2 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
; AVX1-NEXT:    vpand %xmm2, %xmm1, %xmm3
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm4 = [0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4]
; AVX1-NEXT:    vpshufb %xmm3, %xmm4, %xmm3
; AVX1-NEXT:    vpsrlw $4, %xmm1, %xmm1
; AVX1-NEXT:    vpand %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vpshufb %xmm1, %xmm4, %xmm1
; AVX1-NEXT:    vpaddb %xmm3, %xmm1, %xmm1
; AVX1-NEXT:    vpand %xmm2, %xmm0, %xmm3
; AVX1-NEXT:    vpshufb %xmm3, %xmm4, %xmm3
; AVX1-NEXT:    vpsrlw $4, %xmm0, %xmm0
; AVX1-NEXT:    vpand %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vpshufb %xmm0, %xmm4, %xmm0
; AVX1-NEXT:    vpaddb %xmm3, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: testv32i8:
; AVX2:       # BB#0:
; AVX2-NEXT:    vmovdqa {{.*#+}} ymm1 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
; AVX2-NEXT:    vpand %ymm1, %ymm0, %ymm2
; AVX2-NEXT:    vmovdqa {{.*#+}} ymm3 = [0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4]
; AVX2-NEXT:    vpshufb %ymm2, %ymm3, %ymm2
; AVX2-NEXT:    vpsrlw $4, %ymm0, %ymm0
; AVX2-NEXT:    vpand %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpshufb %ymm0, %ymm3, %ymm0
; AVX2-NEXT:    vpaddb %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512VPOPCNTDQ-LABEL: testv32i8:
; AVX512VPOPCNTDQ:       # BB#0:
; AVX512VPOPCNTDQ-NEXT:    vmovdqa {{.*#+}} ymm1 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
; AVX512VPOPCNTDQ-NEXT:    vpand %ymm1, %ymm0, %ymm2
; AVX512VPOPCNTDQ-NEXT:    vmovdqa {{.*#+}} ymm3 = [0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4]
; AVX512VPOPCNTDQ-NEXT:    vpshufb %ymm2, %ymm3, %ymm2
; AVX512VPOPCNTDQ-NEXT:    vpsrlw $4, %ymm0, %ymm0
; AVX512VPOPCNTDQ-NEXT:    vpand %ymm1, %ymm0, %ymm0
; AVX512VPOPCNTDQ-NEXT:    vpshufb %ymm0, %ymm3, %ymm0
; AVX512VPOPCNTDQ-NEXT:    vpaddb %ymm2, %ymm0, %ymm0
; AVX512VPOPCNTDQ-NEXT:    retq
;
; BITALG_NOVLX-LABEL: testv32i8:
; BITALG_NOVLX:       # BB#0:
; BITALG_NOVLX-NEXT:    # kill: %YMM0<def> %YMM0<kill> %ZMM0<def>
; BITALG_NOVLX-NEXT:    vpopcntb %zmm0, %zmm0
; BITALG_NOVLX-NEXT:    # kill: %YMM0<def> %YMM0<kill> %ZMM0<kill>
; BITALG_NOVLX-NEXT:    retq
;
; BITALG-LABEL: testv32i8:
; BITALG:       # BB#0:
; BITALG-NEXT:    vpopcntb %ymm0, %ymm0
; BITALG-NEXT:    retq
  %out = call <32 x i8> @llvm.ctpop.v32i8(<32 x i8> %in)
  ret <32 x i8> %out
}

define <4 x i64> @foldv4i64() nounwind {
; ALL-LABEL: foldv4i64:
; ALL:       # BB#0:
; ALL-NEXT:    vmovaps {{.*#+}} ymm0 = [1,64,0,8]
; ALL-NEXT:    retq
  %out = call <4 x i64> @llvm.ctpop.v4i64(<4 x i64> <i64 256, i64 -1, i64 0, i64 255>)
  ret <4 x i64> %out
}

define <8 x i32> @foldv8i32() nounwind {
; ALL-LABEL: foldv8i32:
; ALL:       # BB#0:
; ALL-NEXT:    vmovaps {{.*#+}} ymm0 = [1,32,0,8,16,3,2,3]
; ALL-NEXT:    retq
  %out = call <8 x i32> @llvm.ctpop.v8i32(<8 x i32> <i32 256, i32 -1, i32 0, i32 255, i32 -65536, i32 7, i32 24, i32 88>)
  ret <8 x i32> %out
}

define <16 x i16> @foldv16i16() nounwind {
; ALL-LABEL: foldv16i16:
; ALL:       # BB#0:
; ALL-NEXT:    vmovaps {{.*#+}} ymm0 = [1,16,0,8,0,3,2,3,15,7,1,1,1,1,1,1]
; ALL-NEXT:    retq
  %out = call <16 x i16> @llvm.ctpop.v16i16(<16 x i16> <i16 256, i16 -1, i16 0, i16 255, i16 -65536, i16 7, i16 24, i16 88, i16 -2, i16 254, i16 1, i16 2, i16 4, i16 8, i16 16, i16 32>)
  ret <16 x i16> %out
}

define <32 x i8> @foldv32i8() nounwind {
; ALL-LABEL: foldv32i8:
; ALL:       # BB#0:
; ALL-NEXT:    vmovaps {{.*#+}} ymm0 = [0,8,0,8,0,3,2,3,7,7,1,1,1,1,1,1,1,1,0,0,1,2,3,4,5,6,7,8,2,2,3,7]
; ALL-NEXT:    retq
  %out = call <32 x i8> @llvm.ctpop.v32i8(<32 x i8> <i8 256, i8 -1, i8 0, i8 255, i8 -65536, i8 7, i8 24, i8 88, i8 -2, i8 254, i8 1, i8 2, i8 4, i8 8, i8 16, i8 32, i8 64, i8 128, i8 256, i8 -256, i8 -128, i8 -64, i8 -32, i8 -16, i8 -8, i8 -4, i8 -2, i8 -1, i8 3, i8 5, i8 7, i8 127>)
  ret <32 x i8> %out
}

declare <4 x i64> @llvm.ctpop.v4i64(<4 x i64>)
declare <8 x i32> @llvm.ctpop.v8i32(<8 x i32>)
declare <16 x i16> @llvm.ctpop.v16i16(<16 x i16>)
declare <32 x i8> @llvm.ctpop.v32i8(<32 x i8>)
