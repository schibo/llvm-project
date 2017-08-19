//===- ClangDiff.cpp - compare source files by AST nodes ------*- C++ -*- -===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file implements a tool for syntax tree based comparison using
// Tooling/ASTDiff.
//
//===----------------------------------------------------------------------===//

#include "clang/Tooling/ASTDiff/ASTDiff.h"
#include "clang/Tooling/CommonOptionsParser.h"
#include "clang/Tooling/Tooling.h"
#include "llvm/Support/CommandLine.h"

using namespace llvm;
using namespace clang;
using namespace clang::tooling;

static cl::OptionCategory ClangDiffCategory("clang-diff options");

static cl::opt<bool>
    ASTDump("ast-dump",
            cl::desc("Print the internal representation of the AST."),
            cl::init(false), cl::cat(ClangDiffCategory));

static cl::opt<bool> ASTDumpJson(
    "ast-dump-json",
    cl::desc("Print the internal representation of the AST as JSON."),
    cl::init(false), cl::cat(ClangDiffCategory));

static cl::opt<std::string> SourcePath(cl::Positional, cl::desc("<source>"),
                                       cl::Required,
                                       cl::cat(ClangDiffCategory));

static cl::opt<std::string> DestinationPath(cl::Positional,
                                            cl::desc("<destination>"),
                                            cl::Optional,
                                            cl::cat(ClangDiffCategory));

static cl::opt<int> MaxSize("s", cl::desc("<maxsize>"), cl::Optional,
                            cl::init(-1), cl::cat(ClangDiffCategory));

static cl::opt<std::string> BuildPath("p", cl::desc("Build path"), cl::init(""),
                                      cl::Optional, cl::cat(ClangDiffCategory));

static cl::list<std::string> ArgsAfter(
    "extra-arg",
    cl::desc("Additional argument to append to the compiler command line"),
    cl::cat(ClangDiffCategory));

static cl::list<std::string> ArgsBefore(
    "extra-arg-before",
    cl::desc("Additional argument to prepend to the compiler command line"),
    cl::cat(ClangDiffCategory));

static void addExtraArgs(std::unique_ptr<CompilationDatabase> &Compilations) {
  if (!Compilations)
    return;
  auto AdjustingCompilations =
      llvm::make_unique<ArgumentsAdjustingCompilations>(
          std::move(Compilations));
  AdjustingCompilations->appendArgumentsAdjuster(
      getInsertArgumentAdjuster(ArgsBefore, ArgumentInsertPosition::BEGIN));
  AdjustingCompilations->appendArgumentsAdjuster(
      getInsertArgumentAdjuster(ArgsAfter, ArgumentInsertPosition::END));
  Compilations = std::move(AdjustingCompilations);
}

static std::unique_ptr<ASTUnit>
getAST(const std::unique_ptr<CompilationDatabase> &CommonCompilations,
       const StringRef Filename) {
  std::string ErrorMessage;
  std::unique_ptr<CompilationDatabase> Compilations;
  if (!CommonCompilations) {
    Compilations = CompilationDatabase::autoDetectFromSource(
        BuildPath.empty() ? Filename : BuildPath, ErrorMessage);
    if (!Compilations) {
      llvm::errs()
          << "Error while trying to load a compilation database, running "
             "without flags.\n"
          << ErrorMessage;
      Compilations =
          llvm::make_unique<clang::tooling::FixedCompilationDatabase>(
              ".", std::vector<std::string>());
    }
  }
  addExtraArgs(Compilations);
  std::array<std::string, 1> Files = {{Filename}};
  ClangTool Tool(Compilations ? *Compilations : *CommonCompilations, Files);
  std::vector<std::unique_ptr<ASTUnit>> ASTs;
  Tool.buildASTs(ASTs);
  if (ASTs.size() != Files.size())
    return nullptr;
  return std::move(ASTs[0]);
}

static char hexdigit(int N) { return N &= 0xf, N + (N < 10 ? '0' : 'a' - 10); }

static void printJsonString(raw_ostream &OS, const StringRef Str) {
  for (char C : Str) {
    switch (C) {
    case '"':
      OS << R"(\")";
      break;
    case '\\':
      OS << R"(\\)";
      break;
    case '\n':
      OS << R"(\n)";
      break;
    case '\t':
      OS << R"(\t)";
      break;
    default:
      if ('\x00' <= C && C <= '\x1f') {
        OS << R"(\u00)" << hexdigit(C >> 4) << hexdigit(C);
      } else {
        OS << C;
      }
    }
  }
}

static void printNodeAttributes(raw_ostream &OS, diff::SyntaxTree &Tree,
                                diff::NodeId Id) {
  const diff::Node &N = Tree.getNode(Id);
  OS << R"("id":)" << int(Id);
  OS << R"(,"type":")" << N.getTypeLabel() << '"';
  auto Offsets = Tree.getSourceRangeOffsets(N);
  OS << R"(,"begin":)" << Offsets.first;
  OS << R"(,"end":)" << Offsets.second;
  std::string Value = Tree.getNodeValue(N);
  if (!Value.empty()) {
    OS << R"(,"value":")";
    printJsonString(OS, Value);
    OS << '"';
  }
}

static void printNodeAsJson(raw_ostream &OS, diff::SyntaxTree &Tree,
                            diff::NodeId Id) {
  const diff::Node &N = Tree.getNode(Id);
  OS << "{";
  printNodeAttributes(OS, Tree, Id);
  OS << R"(,"children":[)";
  if (N.Children.size() > 0) {
    printNodeAsJson(OS, Tree, N.Children[0]);
    for (size_t I = 1, E = N.Children.size(); I < E; ++I) {
      OS << ",";
      printNodeAsJson(OS, Tree, N.Children[I]);
    }
  }
  OS << "]}";
}

static void printNode(raw_ostream &OS, diff::SyntaxTree &Tree,
                      diff::NodeId Id) {
  if (Id.isInvalid()) {
    OS << "None";
    return;
  }
  OS << Tree.getNode(Id).getTypeLabel();
  std::string Value = Tree.getNodeValue(Id);
  if (!Value.empty())
    OS << ": " << Value;
  OS << "(" << Id << ")";
}

static void printTree(raw_ostream &OS, diff::SyntaxTree &Tree) {
  for (diff::NodeId Id : Tree) {
    for (int I = 0; I < Tree.getNode(Id).Depth; ++I)
      OS << " ";
    printNode(OS, Tree, Id);
    OS << "\n";
  }
}

static void printDstChange(raw_ostream &OS, diff::ASTDiff &Diff,
                           diff::SyntaxTree &SrcTree, diff::SyntaxTree &DstTree,
                           diff::NodeId Dst) {
  const diff::Node &DstNode = DstTree.getNode(Dst);
  diff::NodeId Src = Diff.getMapped(DstTree, Dst);
  switch (DstNode.Change) {
  case diff::None:
    break;
  case diff::Delete:
    llvm_unreachable("The destination tree can't have deletions.");
  case diff::Update:
    OS << "Update ";
    printNode(OS, SrcTree, Src);
    OS << " to " << DstTree.getNodeValue(Dst) << "\n";
    break;
  case diff::Insert:
  case diff::Move:
  case diff::UpdateMove:
    if (DstNode.Change == diff::Insert)
      OS << "Insert";
    else if (DstNode.Change == diff::Move)
      OS << "Move";
    else if (DstNode.Change == diff::UpdateMove)
      OS << "Update and Move";
    OS << " ";
    printNode(OS, DstTree, Dst);
    OS << " into ";
    printNode(OS, DstTree, DstNode.Parent);
    OS << " at " << DstTree.findPositionInParent(Dst) << "\n";
    break;
  }
}

int main(int argc, const char **argv) {
  std::string ErrorMessage;
  std::unique_ptr<CompilationDatabase> CommonCompilations =
      FixedCompilationDatabase::loadFromCommandLine(argc, argv, ErrorMessage);
  if (!CommonCompilations && !ErrorMessage.empty())
    llvm::errs() << ErrorMessage;
  cl::HideUnrelatedOptions(ClangDiffCategory);
  if (!cl::ParseCommandLineOptions(argc, argv)) {
    cl::PrintOptionValues();
    return 1;
  }

  addExtraArgs(CommonCompilations);

  if (ASTDump || ASTDumpJson) {
    if (!DestinationPath.empty()) {
      llvm::errs() << "Error: Please specify exactly one filename.\n";
      return 1;
    }
    std::unique_ptr<ASTUnit> AST = getAST(CommonCompilations, SourcePath);
    if (!AST)
      return 1;
    diff::SyntaxTree Tree(AST->getASTContext());
    if (ASTDump) {
      printTree(llvm::outs(), Tree);
      return 0;
    }
    llvm::outs() << R"({"filename":")";
    printJsonString(llvm::outs(), SourcePath);
    llvm::outs() << R"(","root":)";
    printNodeAsJson(llvm::outs(), Tree, Tree.getRootId());
    llvm::outs() << "}\n";
    return 0;
  }

  if (DestinationPath.empty()) {
    llvm::errs() << "Error: Exactly two paths are required.\n";
    return 1;
  }

  std::unique_ptr<ASTUnit> Src = getAST(CommonCompilations, SourcePath);
  std::unique_ptr<ASTUnit> Dst = getAST(CommonCompilations, DestinationPath);
  if (!Src || !Dst)
    return 1;

  diff::ComparisonOptions Options;
  if (MaxSize != -1)
    Options.MaxSize = MaxSize;
  diff::SyntaxTree SrcTree(Src->getASTContext());
  diff::SyntaxTree DstTree(Dst->getASTContext());
  diff::ASTDiff Diff(SrcTree, DstTree, Options);

  for (diff::NodeId Dst : DstTree) {
    diff::NodeId Src = Diff.getMapped(DstTree, Dst);
    if (Src.isValid()) {
      llvm::outs() << "Match ";
      printNode(llvm::outs(), SrcTree, Src);
      llvm::outs() << " to ";
      printNode(llvm::outs(), DstTree, Dst);
      llvm::outs() << "\n";
    }
    printDstChange(llvm::outs(), Diff, SrcTree, DstTree, Dst);
  }
  for (diff::NodeId Src : SrcTree) {
    if (Diff.getMapped(SrcTree, Src).isInvalid()) {
      llvm::outs() << "Delete ";
      printNode(llvm::outs(), SrcTree, Src);
      llvm::outs() << "\n";
    }
  }

  return 0;
}
