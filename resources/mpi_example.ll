; ModuleID = 'mpi_example.c'
source_filename = "mpi_example.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.ompi_predefined_communicator_t = type opaque

@ompi_mpi_comm_world = external global %struct.ompi_predefined_communicator_t, align 1

; Function Attrs: nounwind uwtable
define dso_local i32 @main(i32 noundef %0, ptr noundef %1) local_unnamed_addr #0 !dbg !15 {
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  call void @llvm.dbg.value(metadata i32 %0, metadata !23, metadata !DIExpression()), !dbg !26
  store i32 %0, ptr %3, align 4, !tbaa !27
  call void @llvm.dbg.value(metadata ptr %1, metadata !24, metadata !DIExpression()), !dbg !26
  store ptr %1, ptr %4, align 8, !tbaa !31
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %5) #4, !dbg !33
  call void @llvm.dbg.value(metadata ptr %3, metadata !23, metadata !DIExpression(DW_OP_deref)), !dbg !26
  call void @llvm.dbg.value(metadata ptr %4, metadata !24, metadata !DIExpression(DW_OP_deref)), !dbg !26
  %6 = call i32 @MPI_Init(ptr noundef nonnull %3, ptr noundef nonnull %4) #4, !dbg !34
  call void @llvm.dbg.value(metadata ptr %5, metadata !25, metadata !DIExpression(DW_OP_deref)), !dbg !26
  %7 = call i32 @MPI_Comm_rank(ptr noundef nonnull @ompi_mpi_comm_world, ptr noundef nonnull %5) #4, !dbg !35
  %8 = load i32, ptr %5, align 4, !dbg !36, !tbaa !27
  call void @llvm.dbg.value(metadata i32 %8, metadata !25, metadata !DIExpression()), !dbg !26
  %9 = and i32 %8, 1, !dbg !38
  %10 = icmp eq i32 %9, 0, !dbg !38
  br i1 %10, label %13, label %11, !dbg !39

11:                                               ; preds = %2
  %12 = add nsw i32 %8, 1, !dbg !40
  call void @llvm.dbg.value(metadata i32 %12, metadata !25, metadata !DIExpression()), !dbg !26
  store i32 %12, ptr %5, align 4, !dbg !40, !tbaa !27
  br label %15, !dbg !42

13:                                               ; preds = %2
  %14 = call i32 @MPI_Barrier(ptr noundef nonnull @ompi_mpi_comm_world) #4, !dbg !43
  br label %15

15:                                               ; preds = %13, %11
  %16 = call i32 @MPI_Finalize() #4, !dbg !45
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %5) #4, !dbg !46
  ret i32 0, !dbg !47
}

; Function Attrs: argmemonly mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1

declare !dbg !48 i32 @MPI_Init(ptr noundef, ptr noundef) local_unnamed_addr #2

declare !dbg !54 i32 @MPI_Comm_rank(ptr noundef, ptr noundef) local_unnamed_addr #2

declare !dbg !57 i32 @MPI_Barrier(ptr noundef) local_unnamed_addr #2

declare !dbg !60 i32 @MPI_Finalize() local_unnamed_addr #2

; Function Attrs: argmemonly mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #3

attributes #0 = { nounwind uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { argmemonly mustprogress nocallback nofree nosync nounwind willreturn }
attributes #2 = { "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nocallback nofree nosync nounwind readnone speculatable willreturn }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!8, !9, !10, !11, !12, !13}
!llvm.ident = !{!14}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Debian clang version 15.0.4", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "mpi_example.c", directory: "/home/fifi/dev/parcoach/build", checksumkind: CSK_MD5, checksum: "c222bea1a1abb06b09fc767f36c8ce48")
!2 = !{!3, !7}
!3 = !DIDerivedType(tag: DW_TAG_typedef, name: "MPI_Comm", file: !4, line: 419, baseType: !5)
!4 = !DIFile(filename: "/usr/lib/x86_64-linux-gnu/openmpi/include/mpi.h", directory: "", checksumkind: CSK_MD5, checksum: "18ea94113a9892f1cf9b8c57c42f0ffc")
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!6 = !DICompositeType(tag: DW_TAG_structure_type, name: "ompi_communicator_t", file: !4, line: 419, flags: DIFlagFwdDecl)
!7 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!8 = !{i32 7, !"Dwarf Version", i32 5}
!9 = !{i32 2, !"Debug Info Version", i32 3}
!10 = !{i32 1, !"wchar_size", i32 4}
!11 = !{i32 7, !"PIC Level", i32 2}
!12 = !{i32 7, !"PIE Level", i32 2}
!13 = !{i32 7, !"uwtable", i32 2}
!14 = !{!"Debian clang version 15.0.4"}
!15 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 3, type: !16, scopeLine: 3, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !22)
!16 = !DISubroutineType(types: !17)
!17 = !{!18, !18, !19}
!18 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!19 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !20, size: 64)
!20 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !21, size: 64)
!21 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!22 = !{!23, !24, !25}
!23 = !DILocalVariable(name: "argc", arg: 1, scope: !15, file: !1, line: 3, type: !18)
!24 = !DILocalVariable(name: "argv", arg: 2, scope: !15, file: !1, line: 3, type: !19)
!25 = !DILocalVariable(name: "r", scope: !15, file: !1, line: 4, type: !18)
!26 = !DILocation(line: 0, scope: !15)
!27 = !{!28, !28, i64 0}
!28 = !{!"int", !29, i64 0}
!29 = !{!"omnipotent char", !30, i64 0}
!30 = !{!"Simple C/C++ TBAA"}
!31 = !{!32, !32, i64 0}
!32 = !{!"any pointer", !29, i64 0}
!33 = !DILocation(line: 4, column: 3, scope: !15)
!34 = !DILocation(line: 5, column: 3, scope: !15)
!35 = !DILocation(line: 6, column: 3, scope: !15)
!36 = !DILocation(line: 8, column: 7, scope: !37)
!37 = distinct !DILexicalBlock(scope: !15, file: !1, line: 8, column: 7)
!38 = !DILocation(line: 8, column: 9, scope: !37)
!39 = !DILocation(line: 8, column: 7, scope: !15)
!40 = !DILocation(line: 9, column: 6, scope: !41)
!41 = distinct !DILexicalBlock(scope: !37, file: !1, line: 8, column: 14)
!42 = !DILocation(line: 10, column: 3, scope: !41)
!43 = !DILocation(line: 11, column: 5, scope: !44)
!44 = distinct !DILexicalBlock(scope: !37, file: !1, line: 10, column: 10)
!45 = !DILocation(line: 14, column: 3, scope: !15)
!46 = !DILocation(line: 17, column: 1, scope: !15)
!47 = !DILocation(line: 16, column: 3, scope: !15)
!48 = !DISubprogram(name: "MPI_Init", scope: !4, file: !4, line: 1637, type: !49, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized, retainedNodes: !53)
!49 = !DISubroutineType(types: !50)
!50 = !{!18, !51, !52}
!51 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !18, size: 64)
!52 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !19, size: 64)
!53 = !{}
!54 = !DISubprogram(name: "MPI_Comm_rank", scope: !4, file: !4, line: 1421, type: !55, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized, retainedNodes: !53)
!55 = !DISubroutineType(types: !56)
!56 = !{!18, !3, !51}
!57 = !DISubprogram(name: "MPI_Barrier", scope: !4, file: !4, line: 1343, type: !58, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized, retainedNodes: !53)
!58 = !DISubroutineType(types: !59)
!59 = !{!18, !3}
!60 = !DISubprogram(name: "MPI_Finalize", scope: !4, file: !4, line: 1550, type: !61, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized, retainedNodes: !53)
!61 = !DISubroutineType(types: !62)
!62 = !{!18}
