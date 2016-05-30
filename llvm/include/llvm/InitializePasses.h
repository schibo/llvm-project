//===- llvm/InitializePasses.h -------- Initialize All Passes ---*- C++ -*-===//
//
//                      The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file contains the declarations for the pass initialization routines
// for the entire LLVM project.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_INITIALIZEPASSES_H
#define LLVM_INITIALIZEPASSES_H

namespace llvm {

class PassRegistry;

/// initializeCore - Initialize all passes linked into the
/// TransformUtils library.
void initializeCore(PassRegistry&);

/// initializeTransformUtils - Initialize all passes linked into the
/// TransformUtils library.
void initializeTransformUtils(PassRegistry&);

/// initializeScalarOpts - Initialize all passes linked into the
/// ScalarOpts library.
void initializeScalarOpts(PassRegistry&);

/// initializeObjCARCOpts - Initialize all passes linked into the ObjCARCOpts
/// library.
void initializeObjCARCOpts(PassRegistry&);

/// initializeVectorization - Initialize all passes linked into the
/// Vectorize library.
void initializeVectorization(PassRegistry&);

/// initializeInstCombine - Initialize all passes linked into the
/// InstCombine library.
void initializeInstCombine(PassRegistry&);

/// initializeIPO - Initialize all passes linked into the IPO library.
void initializeIPO(PassRegistry&);

/// initializeInstrumentation - Initialize all passes linked into the
/// Instrumentation library.
void initializeInstrumentation(PassRegistry&);

/// initializeAnalysis - Initialize all passes linked into the Analysis library.
void initializeAnalysis(PassRegistry&);

/// initializeCodeGen - Initialize all passes linked into the CodeGen library.
void initializeCodeGen(PassRegistry&);

/// Initialize all passes linked into the GlobalISel library.
void initializeGlobalISel(PassRegistry &Registry);

/// initializeCodeGen - Initialize all passes linked into the CodeGen library.
void initializeTarget(PassRegistry&);

void initializeAAEvalLegacyPassPass(PassRegistry&);
void initializeAddDiscriminatorsPass(PassRegistry&);
void initializeADCELegacyPassPass(PassRegistry&);
void initializeBDCELegacyPassPass(PassRegistry &);
void initializeAliasSetPrinterPass(PassRegistry&);
void initializeAlwaysInlinerPass(PassRegistry&);
void initializeArgPromotionPass(PassRegistry&);
void initializeAtomicExpandPass(PassRegistry&);
void initializeSampleProfileLoaderLegacyPassPass(PassRegistry&);
void initializeAlignmentFromAssumptionsPass(PassRegistry&);
void initializeBarrierNoopPass(PassRegistry&);
void initializeBasicAAWrapperPassPass(PassRegistry&);
void initializeCallGraphWrapperPassPass(PassRegistry &);
void initializeBlockExtractorPassPass(PassRegistry&);
void initializeBlockFrequencyInfoWrapperPassPass(PassRegistry&);
void initializeBoundsCheckingPass(PassRegistry&);
void initializeBranchFolderPassPass(PassRegistry&);
void initializeBranchProbabilityInfoWrapperPassPass(PassRegistry&);
void initializeBreakCriticalEdgesPass(PassRegistry&);
void initializeCallGraphDOTPrinterPass(PassRegistry&);
void initializeCallGraphPrinterLegacyPassPass(PassRegistry&);
void initializeCallGraphViewerPass(PassRegistry&);
void initializeCFGOnlyPrinterPass(PassRegistry&);
void initializeCFGOnlyViewerPass(PassRegistry&);
void initializeCFGPrinterPass(PassRegistry&);
void initializeCFGSimplifyPassPass(PassRegistry&);
void initializeCFLAAWrapperPassPass(PassRegistry&);
void initializeExternalAAWrapperPassPass(PassRegistry&);
void initializeForwardControlFlowIntegrityPass(PassRegistry&);
void initializeFlattenCFGPassPass(PassRegistry&);
void initializeStructurizeCFGPass(PassRegistry&);
void initializeCFGViewerPass(PassRegistry&);
void initializeConstantHoistingPass(PassRegistry&);
void initializeCodeGenPreparePass(PassRegistry&);
void initializeConstantMergeLegacyPassPass(PassRegistry &);
void initializeConstantPropagationPass(PassRegistry&);
void initializeMachineCopyPropagationPass(PassRegistry&);
void initializeCostModelAnalysisPass(PassRegistry&);
void initializeCorrelatedValuePropagationPass(PassRegistry&);
void initializeCrossDSOCFIPass(PassRegistry&);
void initializeDAEPass(PassRegistry&);
void initializeDAHPass(PassRegistry&);
void initializeDCELegacyPassPass(PassRegistry&);
void initializeDSELegacyPassPass(PassRegistry&);
void initializeDeadInstEliminationPass(PassRegistry&);
void initializeDeadMachineInstructionElimPass(PassRegistry&);
void initializeDelinearizationPass(PassRegistry &);
void initializeDependenceAnalysisPass(PassRegistry&);
void initializeDetectDeadLanesPass(PassRegistry&);
void initializeDependenceAnalysisWrapperPassPass(PassRegistry&);
void initializeDivergenceAnalysisPass(PassRegistry&);
void initializeDomOnlyPrinterPass(PassRegistry&);
void initializeDomOnlyViewerPass(PassRegistry&);
void initializeDomPrinterPass(PassRegistry&);
void initializeDomViewerPass(PassRegistry&);
void initializeDominanceFrontierWrapperPassPass(PassRegistry&);
void initializeDominatorTreeWrapperPassPass(PassRegistry&);
void initializeEarlyIfConverterPass(PassRegistry&);
void initializeEdgeBundlesPass(PassRegistry&);
void initializeExpandPostRAPass(PassRegistry&);
void initializeAAResultsWrapperPassPass(PassRegistry &);
void initializeGCOVProfilerPass(PassRegistry&);
void initializePGOInstrumentationGenLegacyPassPass(PassRegistry&);
void initializePGOInstrumentationUseLegacyPassPass(PassRegistry&);
void initializePGOIndirectCallPromotionLegacyPassPass(PassRegistry&);
void initializeInstrProfilingLegacyPassPass(PassRegistry &);
void initializeAddressSanitizerPass(PassRegistry&);
void initializeAddressSanitizerModulePass(PassRegistry&);
void initializeMemorySanitizerPass(PassRegistry&);
void initializeThreadSanitizerPass(PassRegistry&);
void initializeSanitizerCoverageModulePass(PassRegistry&);
void initializeDataFlowSanitizerPass(PassRegistry&);
void initializeEfficiencySanitizerPass(PassRegistry&);
void initializeScalarizerPass(PassRegistry&);
void initializeEarlyCSELegacyPassPass(PassRegistry &);
void initializeEliminateAvailableExternallyLegacyPassPass(PassRegistry &);
void initializeExpandISelPseudosPass(PassRegistry&);
void initializeForceFunctionAttrsLegacyPassPass(PassRegistry&);
void initializeGCMachineCodeAnalysisPass(PassRegistry&);
void initializeGCModuleInfoPass(PassRegistry&);
void initializeGuardWideningLegacyPassPass(PassRegistry&);
void initializeGVNLegacyPassPass(PassRegistry&);
void initializeGlobalDCELegacyPassPass(PassRegistry&);
void initializeGlobalOptLegacyPassPass(PassRegistry&);
void initializeGlobalsAAWrapperPassPass(PassRegistry&);
void initializeIPCPPass(PassRegistry&);
void initializeIPSCCPLegacyPassPass(PassRegistry &);
void initializeIVUsersPass(PassRegistry&);
void initializeIfConverterPass(PassRegistry&);
void initializeInductiveRangeCheckEliminationPass(PassRegistry&);
void initializeIndVarSimplifyLegacyPassPass(PassRegistry&);
void initializeInferFunctionAttrsLegacyPassPass(PassRegistry&);
void initializeInlineCostAnalysisPass(PassRegistry&);
void initializeInstructionCombiningPassPass(PassRegistry&);
void initializeInstCountPass(PassRegistry&);
void initializeInstNamerPass(PassRegistry&);
void initializeInterleavedAccessPass(PassRegistry &);
void initializeInternalizeLegacyPassPass(PassRegistry&);
void initializeIntervalPartitionPass(PassRegistry&);
void initializeIRTranslatorPass(PassRegistry &);
void initializeJumpThreadingPass(PassRegistry&);
void initializeLCSSAPass(PassRegistry&);
void initializeLICMPass(PassRegistry&);
void initializeLazyValueInfoPass(PassRegistry&);
void initializeLintPass(PassRegistry&);
void initializeLiveDebugVariablesPass(PassRegistry&);
void initializeLiveIntervalsPass(PassRegistry&);
void initializeLiveRegMatrixPass(PassRegistry&);
void initializeLiveStacksPass(PassRegistry&);
void initializeLiveVariablesPass(PassRegistry&);
void initializeLoaderPassPass(PassRegistry&);
void initializeLocalStackSlotPassPass(PassRegistry&);
void initializeLoopDataPrefetchPass(PassRegistry&);
void initializeLoopPassPass(PassRegistry&);
void initializeLoopDeletionPass(PassRegistry&);
void initializeLoopExtractorPass(PassRegistry&);
void initializeLoopInfoWrapperPassPass(PassRegistry&);
void initializeLoopInterchangePass(PassRegistry &);
void initializeLoopInstSimplifyPass(PassRegistry&);
void initializeLoopRotateLegacyPassPass(PassRegistry&);
void initializeLoopSimplifyPass(PassRegistry&);
void initializeLoopSimplifyCFGLegacyPassPass(PassRegistry&);
void initializeLoopStrengthReducePass(PassRegistry&);
void initializeGlobalMergePass(PassRegistry&);
void initializeLoopRerollPass(PassRegistry&);
void initializeLoopUnrollPass(PassRegistry&);
void initializeLoopUnswitchPass(PassRegistry&);
void initializeLoopVersioningLICMPass(PassRegistry&);
void initializeLoopIdiomRecognizePass(PassRegistry&);
void initializeLowerAtomicLegacyPassPass(PassRegistry &);
void initializeLowerBitSetsPass(PassRegistry&);
void initializeLowerExpectIntrinsicPass(PassRegistry&);
void initializeLowerGuardIntrinsicPass(PassRegistry&);
void initializeLowerIntrinsicsPass(PassRegistry&);
void initializeLowerInvokePass(PassRegistry&);
void initializeLowerSwitchPass(PassRegistry&);
void initializeLowerEmuTLSPass(PassRegistry&);
void initializeMachineBlockFrequencyInfoPass(PassRegistry&);
void initializeMachineBlockPlacementPass(PassRegistry&);
void initializeMachineBlockPlacementStatsPass(PassRegistry&);
void initializeMachineBranchProbabilityInfoPass(PassRegistry&);
void initializeMachineCSEPass(PassRegistry&);
void initializeModuleSummaryIndexWrapperPassPass(PassRegistry &);
void initializeImplicitNullChecksPass(PassRegistry&);
void initializeMachineDominatorTreePass(PassRegistry&);
void initializeMachineDominanceFrontierPass(PassRegistry&);
void initializeMachinePostDominatorTreePass(PassRegistry&);
void initializeMachineLICMPass(PassRegistry&);
void initializeMachineLoopInfoPass(PassRegistry&);
void initializeMachineModuleInfoPass(PassRegistry&);
void initializeMachineRegionInfoPassPass(PassRegistry&);
void initializeMachineSchedulerPass(PassRegistry&);
void initializeMachineSinkingPass(PassRegistry&);
void initializeMachineTraceMetricsPass(PassRegistry&);
void initializeMachineVerifierPassPass(PassRegistry&);
void initializeMemCpyOptPass(PassRegistry&);
void initializeMemDepPrinterPass(PassRegistry&);
void initializeMemDerefPrinterPass(PassRegistry&);
void initializeMemoryDependenceWrapperPassPass(PassRegistry&);
void initializeMemorySSALazyPass(PassRegistry&);
void initializeMemorySSAPrinterPassPass(PassRegistry&);
void initializeMergedLoadStoreMotionPass(PassRegistry &);
void initializeMetaRenamerPass(PassRegistry&);
void initializeMergeFunctionsPass(PassRegistry&);
void initializeModuleDebugInfoPrinterPass(PassRegistry&);
void initializeNameAnonFunctionPass(PassRegistry &);
void initializeNaryReassociatePass(PassRegistry&);
void initializeNoAAPass(PassRegistry&);
void initializeObjCARCAAWrapperPassPass(PassRegistry&);
void initializeObjCARCAPElimPass(PassRegistry&);
void initializeObjCARCExpandPass(PassRegistry&);
void initializeObjCARCContractPass(PassRegistry&);
void initializeObjCARCOptPass(PassRegistry&);
void initializePAEvalPass(PassRegistry &);
void initializeOptimizePHIsPass(PassRegistry&);
void initializePartiallyInlineLibCallsLegacyPassPass(PassRegistry &);
void initializePEIPass(PassRegistry&);
void initializePHIEliminationPass(PassRegistry&);
void initializePartialInlinerPass(PassRegistry&);
void initializePeepholeOptimizerPass(PassRegistry&);
void initializePostDomOnlyPrinterPass(PassRegistry&);
void initializePostDomOnlyViewerPass(PassRegistry&);
void initializePostDomPrinterPass(PassRegistry&);
void initializePostDomViewerPass(PassRegistry&);
void initializePostDominatorTreeWrapperPassPass(PassRegistry&);
void initializePostOrderFunctionAttrsLegacyPassPass(PassRegistry&);
void initializePostRAHazardRecognizerPass(PassRegistry&);
void initializePostRASchedulerPass(PassRegistry&);
void initializePostMachineSchedulerPass(PassRegistry&);
void initializePreISelIntrinsicLoweringPass(PassRegistry&);
void initializePrintFunctionPassWrapperPass(PassRegistry&);
void initializePrintModulePassWrapperPass(PassRegistry&);
void initializePrintBasicBlockPassPass(PassRegistry&);
void initializeProcessImplicitDefsPass(PassRegistry&);
void initializePromotePassPass(PassRegistry&);
void initializePruneEHPass(PassRegistry&);
void initializeReassociateLegacyPassPass(PassRegistry&);
void initializeRegBankSelectPass(PassRegistry &);
void initializeRegToMemPass(PassRegistry&);
void initializeRegionInfoPassPass(PassRegistry&);
void initializeRegionOnlyPrinterPass(PassRegistry&);
void initializeRegionOnlyViewerPass(PassRegistry&);
void initializeRegionPrinterPass(PassRegistry&);
void initializeRegionViewerPass(PassRegistry&);
void initializeReversePostOrderFunctionAttrsPass(PassRegistry&);
void initializeRewriteStatepointsForGCPass(PassRegistry&);
void initializeSafeStackPass(PassRegistry&);
void initializeSCCPLegacyPassPass(PassRegistry &);
void initializeSROALegacyPassPass(PassRegistry&);
void initializeSROA_DTPass(PassRegistry&);
void initializeSROA_SSAUpPass(PassRegistry&);
void initializeSCEVAAWrapperPassPass(PassRegistry&);
void initializeScalarEvolutionWrapperPassPass(PassRegistry&);
void initializeShrinkWrapPass(PassRegistry &);
void initializeSimpleInlinerPass(PassRegistry&);
void initializeShadowStackGCLoweringPass(PassRegistry&);
void initializeRegisterCoalescerPass(PassRegistry&);
void initializeSingleLoopExtractorPass(PassRegistry&);
void initializeSinkingLegacyPassPass(PassRegistry&);
void initializeSeparateConstOffsetFromGEPPass(PassRegistry &);
void initializeSlotIndexesPass(PassRegistry&);
void initializeSpillPlacementPass(PassRegistry&);
void initializeSpeculativeExecutionPass(PassRegistry&);
void initializeStackProtectorPass(PassRegistry&);
void initializeStackColoringPass(PassRegistry&);
void initializeStackSlotColoringPass(PassRegistry&);
void initializeStraightLineStrengthReducePass(PassRegistry &);
void initializeStripDeadDebugInfoPass(PassRegistry&);
void initializeStripDeadPrototypesLegacyPassPass(PassRegistry&);
void initializeStripDebugDeclarePass(PassRegistry&);
void initializeStripNonDebugSymbolsPass(PassRegistry&);
void initializeStripSymbolsPass(PassRegistry&);
void initializeTailCallElimPass(PassRegistry&);
void initializeTailDuplicatePassPass(PassRegistry&);
void initializeTargetPassConfigPass(PassRegistry&);
void initializeTargetTransformInfoWrapperPassPass(PassRegistry &);
void initializeTargetLibraryInfoWrapperPassPass(PassRegistry &);
void initializeAssumptionCacheTrackerPass(PassRegistry &);
void initializeTwoAddressInstructionPassPass(PassRegistry&);
void initializeTypeBasedAAWrapperPassPass(PassRegistry&);
void initializeScopedNoAliasAAWrapperPassPass(PassRegistry&);
void initializeUnifyFunctionExitNodesPass(PassRegistry&);
void initializeUnreachableBlockElimPass(PassRegistry&);
void initializeUnreachableMachineBlockElimPass(PassRegistry&);
void initializeVerifierLegacyPassPass(PassRegistry&);
void initializeVirtRegMapPass(PassRegistry&);
void initializeVirtRegRewriterPass(PassRegistry&);
void initializeInstSimplifierPass(PassRegistry&);
void initializeUnpackMachineBundlesPass(PassRegistry&);
void initializeFinalizeMachineBundlesPass(PassRegistry&);
void initializeLoopAccessAnalysisPass(PassRegistry&);
void initializeLoopVectorizePass(PassRegistry&);
void initializeSLPVectorizerPass(PassRegistry&);
void initializeBBVectorizePass(PassRegistry&);
void initializeMachineFunctionPrinterPassPass(PassRegistry&);
void initializeMIRPrintingPassPass(PassRegistry&);
void initializeStackMapLivenessPass(PassRegistry&);
void initializeLiveDebugValuesPass(PassRegistry&);
void initializeMachineCombinerPass(PassRegistry &);
void initializeLoadCombinePass(PassRegistry&);
void initializeRewriteSymbolsPass(PassRegistry&);
void initializeWinEHPreparePass(PassRegistry&);
void initializeWriteBitcodePassPass(PassRegistry &);
void initializePlaceBackedgeSafepointsImplPass(PassRegistry&);
void initializePlaceSafepointsPass(PassRegistry&);
void initializeDwarfEHPreparePass(PassRegistry&);
void initializeFloat2IntPass(PassRegistry&);
void initializeLoopDistributePass(PassRegistry&);
void initializeSjLjEHPreparePass(PassRegistry&);
void initializeDemandedBitsWrapperPassPass(PassRegistry&);
void initializeFuncletLayoutPass(PassRegistry &);
void initializeLoopLoadEliminationPass(PassRegistry&);
void initializeFunctionImportPassPass(PassRegistry &);
void initializeLoopVersioningPassPass(PassRegistry &);
void initializeWholeProgramDevirtPass(PassRegistry &);
void initializePatchableFunctionPass(PassRegistry &);
}

#endif
