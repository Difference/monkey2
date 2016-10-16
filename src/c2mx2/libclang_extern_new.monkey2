Namespace libclang
#Import "<libc>"
#Import "LLVM/bin/libclang.dll"
#Import "LLVM/lib/libclang.lib"
#Import "LLVM/include/*.h"
#Import "<clang-c/Index.h>"
Extern

'***** File: LLVM/include\clang-c/CXErrorCode.h *****

Enum CXErrorCode
End
Const CXError_Success:CXErrorCode
Const CXError_Failure:CXErrorCode
Const CXError_Crashed:CXErrorCode
Const CXError_InvalidArguments:CXErrorCode
Const CXError_ASTReadError:CXErrorCode

'***** File: LLVM/include\clang-c/CXString.h *****

Struct CXString
	Field data:Void Ptr
	Field private_flags:UInt
End
Struct CXStringSet
	Field Strings:CXString Ptr
	Field Count:UInt
End
Function clang_getCString:libc.const_char_t Ptr( string_:CXString )
Function clang_disposeString:Void( string_:CXString )
Function clang_disposeStringSet:Void( set:CXStringSet Ptr )

'***** File: LLVM/include\clang-c/BuildSystem.h *****

Function clang_getBuildSessionTimestamp:ULong(  )
Alias CXVirtualFileOverlay:CXVirtualFileOverlayImpl Ptr
Function clang_VirtualFileOverlay_create:CXVirtualFileOverlay( options:UInt )
Function clang_VirtualFileOverlay_addFileMapping:CXErrorCode( CXVirtualFileOverlay, virtualPath:CString, realPath:CString )
Function clang_VirtualFileOverlay_setCaseSensitivity:CXErrorCode( CXVirtualFileOverlay, caseSensitive:Int )
Function clang_VirtualFileOverlay_writeToBuffer:CXErrorCode( CXVirtualFileOverlay, options:UInt, out_buffer_ptr:libc.char_t Ptr Ptr, out_buffer_size:UInt Ptr )
Function clang_free:Void( buffer:Void Ptr )
Function clang_VirtualFileOverlay_dispose:Void( CXVirtualFileOverlay )
Alias CXModuleMapDescriptor:CXModuleMapDescriptorImpl Ptr
Function clang_ModuleMapDescriptor_create:CXModuleMapDescriptor( options:UInt )
Function clang_ModuleMapDescriptor_setFrameworkModuleName:CXErrorCode( CXModuleMapDescriptor, name:CString )
Function clang_ModuleMapDescriptor_setUmbrellaHeader:CXErrorCode( CXModuleMapDescriptor, name:CString )
Function clang_ModuleMapDescriptor_writeToBuffer:CXErrorCode( CXModuleMapDescriptor, options:UInt, out_buffer_ptr:libc.char_t Ptr Ptr, out_buffer_size:UInt Ptr )
Function clang_ModuleMapDescriptor_dispose:Void( CXModuleMapDescriptor )

'***** File: LLVM/include/clang-c/Index.h *****

Alias CXIndex:Void Ptr
Alias CXTranslationUnit:CXTranslationUnitImpl Ptr
Alias CXClientData:Void Ptr
Struct CXUnsavedFile
	Field Filename:libc.const_char_t Ptr
	Field Contents:libc.const_char_t Ptr
	Field Length:ULong
End
Enum CXAvailabilityKind
End
Const CXAvailability_Available:CXAvailabilityKind
Const CXAvailability_Deprecated:CXAvailabilityKind
Const CXAvailability_NotAvailable:CXAvailabilityKind
Const CXAvailability_NotAccessible:CXAvailabilityKind
Struct CXVersion
	Field Major:Int
	Field Minor:Int
	Field Subminor:Int
End
Function clang_createIndex:CXIndex( excludeDeclarationsFromPCH:Int, displayDiagnostics:Int )
Function clang_disposeIndex:Void( index:CXIndex )
Enum CXGlobalOptFlags
End
Const CXGlobalOpt_None:CXGlobalOptFlags
Const CXGlobalOpt_ThreadBackgroundPriorityForIndexing:CXGlobalOptFlags
Const CXGlobalOpt_ThreadBackgroundPriorityForEditing:CXGlobalOptFlags
Const CXGlobalOpt_ThreadBackgroundPriorityForAll:CXGlobalOptFlags
Function clang_CXIndex_setGlobalOptions:Void( CXIndex, options:UInt )
Function clang_CXIndex_getGlobalOptions:UInt( CXIndex )
Alias CXFile:Void Ptr
Function clang_getFileName:CXString( SFile:CXFile )
Function clang_getFileTime:Int(  )
Struct CXFileUniqueID
	Field data:ULong Ptr
End
Function clang_getFileUniqueID:Int( file:CXFile, outID:CXFileUniqueID Ptr )
Function clang_isFileMultipleIncludeGuarded:UInt( tu:CXTranslationUnit, file:CXFile )
Function clang_getFile:CXFile( tu:CXTranslationUnit, file_name:CString )
Function clang_File_isEqual:Int( file1:CXFile, file2:CXFile )
Struct CXSourceLocation
	Field ptr_data:Void Ptr Ptr
	Field int_data:UInt
End
Struct CXSourceRange
	Field ptr_data:Void Ptr Ptr
	Field begin_int_data:UInt
	Field end_int_data:UInt
End
Function clang_getNullLocation:CXSourceLocation(  )
Function clang_equalLocations:UInt( loc1:CXSourceLocation, loc2:CXSourceLocation )
Function clang_getLocation:CXSourceLocation( tu:CXTranslationUnit, file:CXFile, line:UInt, column:UInt )
Function clang_getLocationForOffset:CXSourceLocation( tu:CXTranslationUnit, file:CXFile, offset:UInt )
Function clang_Location_isInSystemHeader:Int( location:CXSourceLocation )
Function clang_Location_isFromMainFile:Int( location:CXSourceLocation )
Function clang_getNullRange:CXSourceRange(  )
Function clang_getRange:CXSourceRange( begin:CXSourceLocation, end_:CXSourceLocation )
Function clang_equalRanges:UInt( range1:CXSourceRange, range2:CXSourceRange )
Function clang_Range_isNull:Int( range:CXSourceRange )
Function clang_getExpansionLocation:Void( location:CXSourceLocation, file:CXFile Ptr, line:UInt Ptr, column:UInt Ptr, offset:UInt Ptr )
Function clang_getPresumedLocation:Void( location:CXSourceLocation, filename:CXString Ptr, line:UInt Ptr, column:UInt Ptr )
Function clang_getInstantiationLocation:Void( location:CXSourceLocation, file:CXFile Ptr, line:UInt Ptr, column:UInt Ptr, offset:UInt Ptr )
Function clang_getSpellingLocation:Void( location:CXSourceLocation, file:CXFile Ptr, line:UInt Ptr, column:UInt Ptr, offset:UInt Ptr )
Function clang_getFileLocation:Void( location:CXSourceLocation, file:CXFile Ptr, line:UInt Ptr, column:UInt Ptr, offset:UInt Ptr )
Function clang_getRangeStart:CXSourceLocation( range:CXSourceRange )
Function clang_getRangeEnd:CXSourceLocation( range:CXSourceRange )
Struct CXSourceRangeList
	Field count:UInt
	Field ranges:CXSourceRange Ptr
End
Function clang_getSkippedRanges:CXSourceRangeList Ptr( tu:CXTranslationUnit, file:CXFile )
Function clang_disposeSourceRangeList:Void( ranges:CXSourceRangeList Ptr )
Enum CXDiagnosticSeverity
End
Const CXDiagnostic_Ignored:CXDiagnosticSeverity
Const CXDiagnostic_Note:CXDiagnosticSeverity
Const CXDiagnostic_Warning:CXDiagnosticSeverity
Const CXDiagnostic_Error:CXDiagnosticSeverity
Const CXDiagnostic_Fatal:CXDiagnosticSeverity
Alias CXDiagnostic:Void Ptr
Alias CXDiagnosticSet:Void Ptr
Function clang_getNumDiagnosticsInSet:UInt( Diags:CXDiagnosticSet )
Function clang_getDiagnosticInSet:CXDiagnostic( Diags:CXDiagnosticSet, Index:UInt )
Enum CXLoadDiag_Error
End
Const CXLoadDiag_None:CXLoadDiag_Error
Const CXLoadDiag_Unknown:CXLoadDiag_Error
Const CXLoadDiag_CannotLoad:CXLoadDiag_Error
Const CXLoadDiag_InvalidFile:CXLoadDiag_Error
Function clang_loadDiagnostics:CXDiagnosticSet( file:CString, error:CXLoadDiag_Error Ptr, errorString:CXString Ptr )
Function clang_disposeDiagnosticSet:Void( Diags:CXDiagnosticSet )
Function clang_getChildDiagnostics:CXDiagnosticSet( D:CXDiagnostic )
Function clang_getNumDiagnostics:UInt( Unit:CXTranslationUnit )
Function clang_getDiagnostic:CXDiagnostic( Unit:CXTranslationUnit, Index:UInt )
Function clang_getDiagnosticSetFromTU:CXDiagnosticSet( Unit:CXTranslationUnit )
Function clang_disposeDiagnostic:Void( Diagnostic:CXDiagnostic )
Enum CXDiagnosticDisplayOptions
End
Const CXDiagnostic_DisplaySourceLocation:CXDiagnosticDisplayOptions
Const CXDiagnostic_DisplayColumn:CXDiagnosticDisplayOptions
Const CXDiagnostic_DisplaySourceRanges:CXDiagnosticDisplayOptions
Const CXDiagnostic_DisplayOption:CXDiagnosticDisplayOptions
Const CXDiagnostic_DisplayCategoryId:CXDiagnosticDisplayOptions
Const CXDiagnostic_DisplayCategoryName:CXDiagnosticDisplayOptions
Function clang_formatDiagnostic:CXString( Diagnostic:CXDiagnostic, Options:UInt )
Function clang_defaultDiagnosticDisplayOptions:UInt(  )
Function clang_getDiagnosticSeverity:CXDiagnosticSeverity( CXDiagnostic )
Function clang_getDiagnosticLocation:CXSourceLocation( CXDiagnostic )
Function clang_getDiagnosticSpelling:CXString( CXDiagnostic )
Function clang_getDiagnosticOption:CXString( Diag:CXDiagnostic, Disable:CXString Ptr )
Function clang_getDiagnosticCategory:UInt( CXDiagnostic )
Function clang_getDiagnosticCategoryName:CXString( Category:UInt )
Function clang_getDiagnosticCategoryText:CXString( CXDiagnostic )
Function clang_getDiagnosticNumRanges:UInt( CXDiagnostic )
Function clang_getDiagnosticRange:CXSourceRange( Diagnostic:CXDiagnostic, Range:UInt )
Function clang_getDiagnosticNumFixIts:UInt( Diagnostic:CXDiagnostic )
Function clang_getDiagnosticFixIt:CXString( Diagnostic:CXDiagnostic, FixIt:UInt, ReplacementRange:CXSourceRange Ptr )
Function clang_getTranslationUnitSpelling:CXString( CTUnit:CXTranslationUnit )
Function clang_createTranslationUnitFromSourceFile:CXTranslationUnit( CIdx:CXIndex, source_filename:CString, num_clang_command_line_args:Int, clang_command_line_args:libc.const_char_t Ptr Ptr, num_unsaved_files:UInt, unsaved_files:CXUnsavedFile Ptr )
Function clang_createTranslationUnit:CXTranslationUnit( CIdx:CXIndex, ast_filename:CString )
Function clang_createTranslationUnit2:CXErrorCode( CIdx:CXIndex, ast_filename:CString, out_TU:CXTranslationUnit Ptr )
Enum CXTranslationUnit_Flags
End
Const CXTranslationUnit_None:CXTranslationUnit_Flags
Const CXTranslationUnit_DetailedPreprocessingRecord:CXTranslationUnit_Flags
Const CXTranslationUnit_Incomplete:CXTranslationUnit_Flags
Const CXTranslationUnit_PrecompiledPreamble:CXTranslationUnit_Flags
Const CXTranslationUnit_CacheCompletionResults:CXTranslationUnit_Flags
Const CXTranslationUnit_ForSerialization:CXTranslationUnit_Flags
Const CXTranslationUnit_CXXChainedPCH:CXTranslationUnit_Flags
Const CXTranslationUnit_SkipFunctionBodies:CXTranslationUnit_Flags
Const CXTranslationUnit_IncludeBriefCommentsInCodeCompletion:CXTranslationUnit_Flags
Const CXTranslationUnit_CreatePreambleOnFirstParse:CXTranslationUnit_Flags
Const CXTranslationUnit_KeepGoing:CXTranslationUnit_Flags
Function clang_defaultEditingTranslationUnitOptions:UInt(  )
Function clang_parseTranslationUnit:CXTranslationUnit( CIdx:CXIndex, source_filename:CString, command_line_args:libc.const_char_t Ptr Ptr, num_command_line_args:Int, unsaved_files:CXUnsavedFile Ptr, num_unsaved_files:UInt, options:UInt )
Function clang_parseTranslationUnit2:CXErrorCode( CIdx:CXIndex, source_filename:CString, command_line_args:libc.const_char_t Ptr Ptr, num_command_line_args:Int, unsaved_files:CXUnsavedFile Ptr, num_unsaved_files:UInt, options:UInt, out_TU:CXTranslationUnit Ptr )
Function clang_parseTranslationUnit2FullArgv:CXErrorCode( CIdx:CXIndex, source_filename:CString, command_line_args:libc.const_char_t Ptr Ptr, num_command_line_args:Int, unsaved_files:CXUnsavedFile Ptr, num_unsaved_files:UInt, options:UInt, out_TU:CXTranslationUnit Ptr )
Enum CXSaveTranslationUnit_Flags
End
Const CXSaveTranslationUnit_None:CXSaveTranslationUnit_Flags
Function clang_defaultSaveOptions:UInt( TU:CXTranslationUnit )
Enum CXSaveError
End
Const CXSaveError_None:CXSaveError
Const CXSaveError_Unknown:CXSaveError
Const CXSaveError_TranslationErrors:CXSaveError
Const CXSaveError_InvalidTU:CXSaveError
Function clang_saveTranslationUnit:Int( TU:CXTranslationUnit, FileName:CString, options:UInt )
Function clang_disposeTranslationUnit:Void( CXTranslationUnit )
Enum CXReparse_Flags
End
Const CXReparse_None:CXReparse_Flags
Function clang_defaultReparseOptions:UInt( TU:CXTranslationUnit )
Function clang_reparseTranslationUnit:Int( TU:CXTranslationUnit, num_unsaved_files:UInt, unsaved_files:CXUnsavedFile Ptr, options:UInt )
Enum CXTUResourceUsageKind
End
Const CXTUResourceUsage_AST:CXTUResourceUsageKind
Const CXTUResourceUsage_Identifiers:CXTUResourceUsageKind
Const CXTUResourceUsage_Selectors:CXTUResourceUsageKind
Const CXTUResourceUsage_GlobalCompletionResults:CXTUResourceUsageKind
Const CXTUResourceUsage_SourceManagerContentCache:CXTUResourceUsageKind
Const CXTUResourceUsage_AST_SideTables:CXTUResourceUsageKind
Const CXTUResourceUsage_SourceManager_Membuffer_Malloc:CXTUResourceUsageKind
Const CXTUResourceUsage_SourceManager_Membuffer_MMap:CXTUResourceUsageKind
Const CXTUResourceUsage_ExternalASTSource_Membuffer_Malloc:CXTUResourceUsageKind
Const CXTUResourceUsage_ExternalASTSource_Membuffer_MMap:CXTUResourceUsageKind
Const CXTUResourceUsage_Preprocessor:CXTUResourceUsageKind
Const CXTUResourceUsage_PreprocessingRecord:CXTUResourceUsageKind
Const CXTUResourceUsage_SourceManager_DataStructures:CXTUResourceUsageKind
Const CXTUResourceUsage_Preprocessor_HeaderSearch:CXTUResourceUsageKind
Const CXTUResourceUsage_MEMORY_IN_BYTES_BEGIN:CXTUResourceUsageKind
Const CXTUResourceUsage_MEMORY_IN_BYTES_END:CXTUResourceUsageKind
Const CXTUResourceUsage_First:CXTUResourceUsageKind
Const CXTUResourceUsage_Last:CXTUResourceUsageKind
Function clang_getTUResourceUsageName:libc.const_char_t Ptr( kind:CXTUResourceUsageKind )
Struct CXTUResourceUsageEntry
	Field kind:CXTUResourceUsageKind
	Field amount:ULong
End
Struct CXTUResourceUsage
	Field data:Void Ptr
	Field numEntries:UInt
	Field entries:CXTUResourceUsageEntry Ptr
End
Function clang_getCXTUResourceUsage:CXTUResourceUsage( TU:CXTranslationUnit )
Function clang_disposeCXTUResourceUsage:Void( usage:CXTUResourceUsage )
Enum CXCursorKind
End
Const CXCursor_UnexposedDecl:CXCursorKind
Const CXCursor_StructDecl:CXCursorKind
Const CXCursor_UnionDecl:CXCursorKind
Const CXCursor_ClassDecl:CXCursorKind
Const CXCursor_EnumDecl:CXCursorKind
Const CXCursor_FieldDecl:CXCursorKind
Const CXCursor_EnumConstantDecl:CXCursorKind
Const CXCursor_FunctionDecl:CXCursorKind
Const CXCursor_VarDecl:CXCursorKind
Const CXCursor_ParmDecl:CXCursorKind
Const CXCursor_ObjCInterfaceDecl:CXCursorKind
Const CXCursor_ObjCCategoryDecl:CXCursorKind
Const CXCursor_ObjCProtocolDecl:CXCursorKind
Const CXCursor_ObjCPropertyDecl:CXCursorKind
Const CXCursor_ObjCIvarDecl:CXCursorKind
Const CXCursor_ObjCInstanceMethodDecl:CXCursorKind
Const CXCursor_ObjCClassMethodDecl:CXCursorKind
Const CXCursor_ObjCImplementationDecl:CXCursorKind
Const CXCursor_ObjCCategoryImplDecl:CXCursorKind
Const CXCursor_TypedefDecl:CXCursorKind
Const CXCursor_CXXMethod:CXCursorKind
Const CXCursor_Namespace:CXCursorKind
Const CXCursor_LinkageSpec:CXCursorKind
Const CXCursor_Constructor:CXCursorKind
Const CXCursor_Destructor:CXCursorKind
Const CXCursor_ConversionFunction:CXCursorKind
Const CXCursor_TemplateTypeParameter:CXCursorKind
Const CXCursor_NonTypeTemplateParameter:CXCursorKind
Const CXCursor_TemplateTemplateParameter:CXCursorKind
Const CXCursor_FunctionTemplate:CXCursorKind
Const CXCursor_ClassTemplate:CXCursorKind
Const CXCursor_ClassTemplatePartialSpecialization:CXCursorKind
Const CXCursor_NamespaceAlias:CXCursorKind
Const CXCursor_UsingDirective:CXCursorKind
Const CXCursor_UsingDeclaration:CXCursorKind
Const CXCursor_TypeAliasDecl:CXCursorKind
Const CXCursor_ObjCSynthesizeDecl:CXCursorKind
Const CXCursor_ObjCDynamicDecl:CXCursorKind
Const CXCursor_CXXAccessSpecifier:CXCursorKind
Const CXCursor_FirstDecl:CXCursorKind
Const CXCursor_LastDecl:CXCursorKind
Const CXCursor_FirstRef:CXCursorKind
Const CXCursor_ObjCSuperClassRef:CXCursorKind
Const CXCursor_ObjCProtocolRef:CXCursorKind
Const CXCursor_ObjCClassRef:CXCursorKind
Const CXCursor_TypeRef:CXCursorKind
Const CXCursor_CXXBaseSpecifier:CXCursorKind
Const CXCursor_TemplateRef:CXCursorKind
Const CXCursor_NamespaceRef:CXCursorKind
Const CXCursor_MemberRef:CXCursorKind
Const CXCursor_LabelRef:CXCursorKind
Const CXCursor_OverloadedDeclRef:CXCursorKind
Const CXCursor_VariableRef:CXCursorKind
Const CXCursor_LastRef:CXCursorKind
Const CXCursor_FirstInvalid:CXCursorKind
Const CXCursor_InvalidFile:CXCursorKind
Const CXCursor_NoDeclFound:CXCursorKind
Const CXCursor_NotImplemented:CXCursorKind
Const CXCursor_InvalidCode:CXCursorKind
Const CXCursor_LastInvalid:CXCursorKind
Const CXCursor_FirstExpr:CXCursorKind
Const CXCursor_UnexposedExpr:CXCursorKind
Const CXCursor_DeclRefExpr:CXCursorKind
Const CXCursor_MemberRefExpr:CXCursorKind
Const CXCursor_CallExpr:CXCursorKind
Const CXCursor_ObjCMessageExpr:CXCursorKind
Const CXCursor_BlockExpr:CXCursorKind
Const CXCursor_IntegerLiteral:CXCursorKind
Const CXCursor_FloatingLiteral:CXCursorKind
Const CXCursor_ImaginaryLiteral:CXCursorKind
Const CXCursor_StringLiteral:CXCursorKind
Const CXCursor_CharacterLiteral:CXCursorKind
Const CXCursor_ParenExpr:CXCursorKind
Const CXCursor_UnaryOperator:CXCursorKind
Const CXCursor_ArraySubscriptExpr:CXCursorKind
Const CXCursor_BinaryOperator:CXCursorKind
Const CXCursor_CompoundAssignOperator:CXCursorKind
Const CXCursor_ConditionalOperator:CXCursorKind
Const CXCursor_CStyleCastExpr:CXCursorKind
Const CXCursor_CompoundLiteralExpr:CXCursorKind
Const CXCursor_InitListExpr:CXCursorKind
Const CXCursor_AddrLabelExpr:CXCursorKind
Const CXCursor_StmtExpr:CXCursorKind
Const CXCursor_GenericSelectionExpr:CXCursorKind
Const CXCursor_GNUNullExpr:CXCursorKind
Const CXCursor_CXXStaticCastExpr:CXCursorKind
Const CXCursor_CXXDynamicCastExpr:CXCursorKind
Const CXCursor_CXXReinterpretCastExpr:CXCursorKind
Const CXCursor_CXXConstCastExpr:CXCursorKind
Const CXCursor_CXXFunctionalCastExpr:CXCursorKind
Const CXCursor_CXXTypeidExpr:CXCursorKind
Const CXCursor_CXXBoolLiteralExpr:CXCursorKind
Const CXCursor_CXXNullPtrLiteralExpr:CXCursorKind
Const CXCursor_CXXThisExpr:CXCursorKind
Const CXCursor_CXXThrowExpr:CXCursorKind
Const CXCursor_CXXNewExpr:CXCursorKind
Const CXCursor_CXXDeleteExpr:CXCursorKind
Const CXCursor_UnaryExpr:CXCursorKind
Const CXCursor_ObjCStringLiteral:CXCursorKind
Const CXCursor_ObjCEncodeExpr:CXCursorKind
Const CXCursor_ObjCSelectorExpr:CXCursorKind
Const CXCursor_ObjCProtocolExpr:CXCursorKind
Const CXCursor_ObjCBridgedCastExpr:CXCursorKind
Const CXCursor_PackExpansionExpr:CXCursorKind
Const CXCursor_SizeOfPackExpr:CXCursorKind
Const CXCursor_LambdaExpr:CXCursorKind
Const CXCursor_ObjCBoolLiteralExpr:CXCursorKind
Const CXCursor_ObjCSelfExpr:CXCursorKind
Const CXCursor_OMPArraySectionExpr:CXCursorKind
Const CXCursor_ObjCAvailabilityCheckExpr:CXCursorKind
Const CXCursor_LastExpr:CXCursorKind
Const CXCursor_FirstStmt:CXCursorKind
Const CXCursor_UnexposedStmt:CXCursorKind
Const CXCursor_LabelStmt:CXCursorKind
Const CXCursor_CompoundStmt:CXCursorKind
Const CXCursor_CaseStmt:CXCursorKind
Const CXCursor_DefaultStmt:CXCursorKind
Const CXCursor_IfStmt:CXCursorKind
Const CXCursor_SwitchStmt:CXCursorKind
Const CXCursor_WhileStmt:CXCursorKind
Const CXCursor_DoStmt:CXCursorKind
Const CXCursor_ForStmt:CXCursorKind
Const CXCursor_GotoStmt:CXCursorKind
Const CXCursor_IndirectGotoStmt:CXCursorKind
Const CXCursor_ContinueStmt:CXCursorKind
Const CXCursor_BreakStmt:CXCursorKind
Const CXCursor_ReturnStmt:CXCursorKind
Const CXCursor_GCCAsmStmt:CXCursorKind
Const CXCursor_AsmStmt:CXCursorKind
Const CXCursor_ObjCAtTryStmt:CXCursorKind
Const CXCursor_ObjCAtCatchStmt:CXCursorKind
Const CXCursor_ObjCAtFinallyStmt:CXCursorKind
Const CXCursor_ObjCAtThrowStmt:CXCursorKind
Const CXCursor_ObjCAtSynchronizedStmt:CXCursorKind
Const CXCursor_ObjCAutoreleasePoolStmt:CXCursorKind
Const CXCursor_ObjCForCollectionStmt:CXCursorKind
Const CXCursor_CXXCatchStmt:CXCursorKind
Const CXCursor_CXXTryStmt:CXCursorKind
Const CXCursor_CXXForRangeStmt:CXCursorKind
Const CXCursor_SEHTryStmt:CXCursorKind
Const CXCursor_SEHExceptStmt:CXCursorKind
Const CXCursor_SEHFinallyStmt:CXCursorKind
Const CXCursor_MSAsmStmt:CXCursorKind
Const CXCursor_NullStmt:CXCursorKind
Const CXCursor_DeclStmt:CXCursorKind
Const CXCursor_OMPParallelDirective:CXCursorKind
Const CXCursor_OMPSimdDirective:CXCursorKind
Const CXCursor_OMPForDirective:CXCursorKind
Const CXCursor_OMPSectionsDirective:CXCursorKind
Const CXCursor_OMPSectionDirective:CXCursorKind
Const CXCursor_OMPSingleDirective:CXCursorKind
Const CXCursor_OMPParallelForDirective:CXCursorKind
Const CXCursor_OMPParallelSectionsDirective:CXCursorKind
Const CXCursor_OMPTaskDirective:CXCursorKind
Const CXCursor_OMPMasterDirective:CXCursorKind
Const CXCursor_OMPCriticalDirective:CXCursorKind
Const CXCursor_OMPTaskyieldDirective:CXCursorKind
Const CXCursor_OMPBarrierDirective:CXCursorKind
Const CXCursor_OMPTaskwaitDirective:CXCursorKind
Const CXCursor_OMPFlushDirective:CXCursorKind
Const CXCursor_SEHLeaveStmt:CXCursorKind
Const CXCursor_OMPOrderedDirective:CXCursorKind
Const CXCursor_OMPAtomicDirective:CXCursorKind
Const CXCursor_OMPForSimdDirective:CXCursorKind
Const CXCursor_OMPParallelForSimdDirective:CXCursorKind
Const CXCursor_OMPTargetDirective:CXCursorKind
Const CXCursor_OMPTeamsDirective:CXCursorKind
Const CXCursor_OMPTaskgroupDirective:CXCursorKind
Const CXCursor_OMPCancellationPointDirective:CXCursorKind
Const CXCursor_OMPCancelDirective:CXCursorKind
Const CXCursor_OMPTargetDataDirective:CXCursorKind
Const CXCursor_OMPTaskLoopDirective:CXCursorKind
Const CXCursor_OMPTaskLoopSimdDirective:CXCursorKind
Const CXCursor_OMPDistributeDirective:CXCursorKind
Const CXCursor_OMPTargetEnterDataDirective:CXCursorKind
Const CXCursor_OMPTargetExitDataDirective:CXCursorKind
Const CXCursor_OMPTargetParallelDirective:CXCursorKind
Const CXCursor_OMPTargetParallelForDirective:CXCursorKind
Const CXCursor_OMPTargetUpdateDirective:CXCursorKind
Const CXCursor_OMPDistributeParallelForDirective:CXCursorKind
Const CXCursor_OMPDistributeParallelForSimdDirective:CXCursorKind
Const CXCursor_OMPDistributeSimdDirective:CXCursorKind
Const CXCursor_OMPTargetParallelForSimdDirective:CXCursorKind
Const CXCursor_LastStmt:CXCursorKind
Const CXCursor_TranslationUnit:CXCursorKind
Const CXCursor_FirstAttr:CXCursorKind
Const CXCursor_UnexposedAttr:CXCursorKind
Const CXCursor_IBActionAttr:CXCursorKind
Const CXCursor_IBOutletAttr:CXCursorKind
Const CXCursor_IBOutletCollectionAttr:CXCursorKind
Const CXCursor_CXXFinalAttr:CXCursorKind
Const CXCursor_CXXOverrideAttr:CXCursorKind
Const CXCursor_AnnotateAttr:CXCursorKind
Const CXCursor_AsmLabelAttr:CXCursorKind
Const CXCursor_PackedAttr:CXCursorKind
Const CXCursor_PureAttr:CXCursorKind
Const CXCursor_ConstAttr:CXCursorKind
Const CXCursor_NoDuplicateAttr:CXCursorKind
Const CXCursor_CUDAConstantAttr:CXCursorKind
Const CXCursor_CUDADeviceAttr:CXCursorKind
Const CXCursor_CUDAGlobalAttr:CXCursorKind
Const CXCursor_CUDAHostAttr:CXCursorKind
Const CXCursor_CUDASharedAttr:CXCursorKind
Const CXCursor_VisibilityAttr:CXCursorKind
Const CXCursor_DLLExport:CXCursorKind
Const CXCursor_DLLImport:CXCursorKind
Const CXCursor_LastAttr:CXCursorKind
Const CXCursor_PreprocessingDirective:CXCursorKind
Const CXCursor_MacroDefinition:CXCursorKind
Const CXCursor_MacroExpansion:CXCursorKind
Const CXCursor_MacroInstantiation:CXCursorKind
Const CXCursor_InclusionDirective:CXCursorKind
Const CXCursor_FirstPreprocessing:CXCursorKind
Const CXCursor_LastPreprocessing:CXCursorKind
Const CXCursor_ModuleImportDecl:CXCursorKind
Const CXCursor_TypeAliasTemplateDecl:CXCursorKind
Const CXCursor_StaticAssert:CXCursorKind
Const CXCursor_FirstExtraDecl:CXCursorKind
Const CXCursor_LastExtraDecl:CXCursorKind
Const CXCursor_OverloadCandidate:CXCursorKind
Struct CXCursor
	Field kind:CXCursorKind
	Field xdata:Int
	Field data:Void Ptr Ptr
End
Function clang_getNullCursor:CXCursor(  )
Function clang_getTranslationUnitCursor:CXCursor( CXTranslationUnit )
Function clang_equalCursors:UInt( CXCursor, CXCursor )
Function clang_Cursor_isNull:Int( cursor:CXCursor )
Function clang_hashCursor:UInt( CXCursor )
Function clang_getCursorKind:CXCursorKind( CXCursor )
Function clang_isDeclaration:UInt( CXCursorKind )
Function clang_isReference:UInt( CXCursorKind )
Function clang_isExpression:UInt( CXCursorKind )
Function clang_isStatement:UInt( CXCursorKind )
Function clang_isAttribute:UInt( CXCursorKind )
Function clang_Cursor_hasAttrs:UInt( C:CXCursor )
Function clang_isInvalid:UInt( CXCursorKind )
Function clang_isTranslationUnit:UInt( CXCursorKind )
Function clang_isPreprocessing:UInt( CXCursorKind )
Function clang_isUnexposed:UInt( CXCursorKind )
Enum CXLinkageKind
End
Const CXLinkage_Invalid:CXLinkageKind
Const CXLinkage_NoLinkage:CXLinkageKind
Const CXLinkage_Internal:CXLinkageKind
Const CXLinkage_UniqueExternal:CXLinkageKind
Const CXLinkage_External:CXLinkageKind
Function clang_getCursorLinkage:CXLinkageKind( cursor:CXCursor )
Enum CXVisibilityKind
End
Const CXVisibility_Invalid:CXVisibilityKind
Const CXVisibility_Hidden:CXVisibilityKind
Const CXVisibility_Protected:CXVisibilityKind
Const CXVisibility_Default:CXVisibilityKind
Function clang_getCursorVisibility:CXVisibilityKind( cursor:CXCursor )
Function clang_getCursorAvailability:CXAvailabilityKind( cursor:CXCursor )
Struct CXPlatformAvailability
	Field Platform:CXString
	Field Introduced:CXVersion
	Field Deprecated:CXVersion
	Field Obsoleted:CXVersion
	Field Unavailable:Int
	Field Message:CXString
End
Function clang_getCursorPlatformAvailability:Int( cursor:CXCursor, always_deprecated:Int Ptr, deprecated_message:CXString Ptr, always_unavailable:Int Ptr, unavailable_message:CXString Ptr, availability:CXPlatformAvailability Ptr, availability_size:Int )
Function clang_disposeCXPlatformAvailability:Void( availability:CXPlatformAvailability Ptr )
Enum CXLanguageKind
End
Const CXLanguage_Invalid:CXLanguageKind
Const CXLanguage_C:CXLanguageKind
Const CXLanguage_ObjC:CXLanguageKind
Const CXLanguage_CPlusPlus:CXLanguageKind
Function clang_getCursorLanguage:CXLanguageKind( cursor:CXCursor )
Function clang_Cursor_getTranslationUnit:CXTranslationUnit( CXCursor )
Alias CXCursorSet:CXCursorSetImpl Ptr
Function clang_createCXCursorSet:CXCursorSet(  )
Function clang_disposeCXCursorSet:Void( cset:CXCursorSet )
Function clang_CXCursorSet_contains:UInt( cset:CXCursorSet, cursor:CXCursor )
Function clang_CXCursorSet_insert:UInt( cset:CXCursorSet, cursor:CXCursor )
Function clang_getCursorSemanticParent:CXCursor( cursor:CXCursor )
Function clang_getCursorLexicalParent:CXCursor( cursor:CXCursor )
Function clang_getOverriddenCursors:Void( cursor:CXCursor, overridden:CXCursor Ptr Ptr, num_overridden:UInt Ptr )
Function clang_disposeOverriddenCursors:Void( overridden:CXCursor Ptr )
Function clang_getIncludedFile:CXFile( cursor:CXCursor )
Function clang_getCursor:CXCursor( CXTranslationUnit, CXSourceLocation )
Function clang_getCursorLocation:CXSourceLocation( CXCursor )
Function clang_getCursorExtent:CXSourceRange( CXCursor )
Enum CXTypeKind
End
Const CXType_Invalid:CXTypeKind
Const CXType_Unexposed:CXTypeKind
Const CXType_Void:CXTypeKind
Const CXType_Bool:CXTypeKind
Const CXType_Char_U:CXTypeKind
Const CXType_UChar:CXTypeKind
Const CXType_Char16:CXTypeKind
Const CXType_Char32:CXTypeKind
Const CXType_UShort:CXTypeKind
Const CXType_UInt:CXTypeKind
Const CXType_ULong:CXTypeKind
Const CXType_ULongLong:CXTypeKind
Const CXType_UInt128:CXTypeKind
Const CXType_Char_S:CXTypeKind
Const CXType_SChar:CXTypeKind
Const CXType_WChar:CXTypeKind
Const CXType_Short:CXTypeKind
Const CXType_Int:CXTypeKind
Const CXType_Long:CXTypeKind
Const CXType_LongLong:CXTypeKind
Const CXType_Int128:CXTypeKind
Const CXType_Float:CXTypeKind
Const CXType_Double:CXTypeKind
Const CXType_LongDouble:CXTypeKind
Const CXType_NullPtr:CXTypeKind
Const CXType_Overload:CXTypeKind
Const CXType_Dependent:CXTypeKind
Const CXType_ObjCId:CXTypeKind
Const CXType_ObjCClass:CXTypeKind
Const CXType_ObjCSel:CXTypeKind
Const CXType_Float128:CXTypeKind
Const CXType_FirstBuiltin:CXTypeKind
Const CXType_LastBuiltin:CXTypeKind
Const CXType_Complex:CXTypeKind
Const CXType_Pointer:CXTypeKind
Const CXType_BlockPointer:CXTypeKind
Const CXType_LValueReference:CXTypeKind
Const CXType_RValueReference:CXTypeKind
Const CXType_Record:CXTypeKind
Const CXType_Enum:CXTypeKind
Const CXType_Typedef:CXTypeKind
Const CXType_ObjCInterface:CXTypeKind
Const CXType_ObjCObjectPointer:CXTypeKind
Const CXType_FunctionNoProto:CXTypeKind
Const CXType_FunctionProto:CXTypeKind
Const CXType_ConstantArray:CXTypeKind
Const CXType_Vector:CXTypeKind
Const CXType_IncompleteArray:CXTypeKind
Const CXType_VariableArray:CXTypeKind
Const CXType_DependentSizedArray:CXTypeKind
Const CXType_MemberPointer:CXTypeKind
Const CXType_Auto:CXTypeKind
Const CXType_Elaborated:CXTypeKind
Enum CXCallingConv
End
Const CXCallingConv_Default:CXCallingConv
Const CXCallingConv_C:CXCallingConv
Const CXCallingConv_X86StdCall:CXCallingConv
Const CXCallingConv_X86FastCall:CXCallingConv
Const CXCallingConv_X86ThisCall:CXCallingConv
Const CXCallingConv_X86Pascal:CXCallingConv
Const CXCallingConv_AAPCS:CXCallingConv
Const CXCallingConv_AAPCS_VFP:CXCallingConv
Const CXCallingConv_IntelOclBicc:CXCallingConv
Const CXCallingConv_X86_64Win64:CXCallingConv
Const CXCallingConv_X86_64SysV:CXCallingConv
Const CXCallingConv_X86VectorCall:CXCallingConv
Const CXCallingConv_Swift:CXCallingConv
Const CXCallingConv_PreserveMost:CXCallingConv
Const CXCallingConv_PreserveAll:CXCallingConv
Const CXCallingConv_Invalid:CXCallingConv
Const CXCallingConv_Unexposed:CXCallingConv
Struct CXType
	Field kind:CXTypeKind
	Field data:Void Ptr Ptr
End
Function clang_getCursorType:CXType( C:CXCursor )
Function clang_getTypeSpelling:CXString( CT:CXType )
Function clang_getTypedefDeclUnderlyingType:CXType( C:CXCursor )
Function clang_getEnumDeclIntegerType:CXType( C:CXCursor )
Function clang_getEnumConstantDeclValue:Long( C:CXCursor )
Function clang_getEnumConstantDeclUnsignedValue:ULong( C:CXCursor )
Function clang_getFieldDeclBitWidth:Int( C:CXCursor )
Function clang_Cursor_getNumArguments:Int( C:CXCursor )
Function clang_Cursor_getArgument:CXCursor( C:CXCursor, i:UInt )
Enum CXTemplateArgumentKind
End
Const CXTemplateArgumentKind_Null:CXTemplateArgumentKind
Const CXTemplateArgumentKind_Type:CXTemplateArgumentKind
Const CXTemplateArgumentKind_Declaration:CXTemplateArgumentKind
Const CXTemplateArgumentKind_NullPtr:CXTemplateArgumentKind
Const CXTemplateArgumentKind_Integral:CXTemplateArgumentKind
Const CXTemplateArgumentKind_Template:CXTemplateArgumentKind
Const CXTemplateArgumentKind_TemplateExpansion:CXTemplateArgumentKind
Const CXTemplateArgumentKind_Expression:CXTemplateArgumentKind
Const CXTemplateArgumentKind_Pack:CXTemplateArgumentKind
Const CXTemplateArgumentKind_Invalid:CXTemplateArgumentKind
Function clang_Cursor_getNumTemplateArguments:Int( C:CXCursor )
Function clang_Cursor_getTemplateArgumentKind:CXTemplateArgumentKind( C:CXCursor, I:UInt )
Function clang_Cursor_getTemplateArgumentType:CXType( C:CXCursor, I:UInt )
Function clang_Cursor_getTemplateArgumentValue:Long( C:CXCursor, I:UInt )
Function clang_Cursor_getTemplateArgumentUnsignedValue:ULong( C:CXCursor, I:UInt )
Function clang_equalTypes:UInt( A:CXType, B:CXType )
Function clang_getCanonicalType:CXType( T:CXType )
Function clang_isConstQualifiedType:UInt( T:CXType )
Function clang_Cursor_isMacroFunctionLike:UInt( C:CXCursor )
Function clang_Cursor_isMacroBuiltin:UInt( C:CXCursor )
Function clang_Cursor_isFunctionInlined:UInt( C:CXCursor )
Function clang_isVolatileQualifiedType:UInt( T:CXType )
Function clang_isRestrictQualifiedType:UInt( T:CXType )
Function clang_getPointeeType:CXType( T:CXType )
Function clang_getTypeDeclaration:CXCursor( T:CXType )
Function clang_getDeclObjCTypeEncoding:CXString( C:CXCursor )
Function clang_Type_getObjCEncoding:CXString( type:CXType )
Function clang_getTypeKindSpelling:CXString( K:CXTypeKind )
Function clang_getFunctionTypeCallingConv:CXCallingConv( T:CXType )
Function clang_getResultType:CXType( T:CXType )
Function clang_getNumArgTypes:Int( T:CXType )
Function clang_getArgType:CXType( T:CXType, i:UInt )
Function clang_isFunctionTypeVariadic:UInt( T:CXType )
Function clang_getCursorResultType:CXType( C:CXCursor )
Function clang_isPODType:UInt( T:CXType )
Function clang_getElementType:CXType( T:CXType )
Function clang_getNumElements:Long( T:CXType )
Function clang_getArrayElementType:CXType( T:CXType )
Function clang_getArraySize:Long( T:CXType )
Function clang_Type_getNamedType:CXType( T:CXType )
Enum CXTypeLayoutError
End
Const CXTypeLayoutError_Invalid:CXTypeLayoutError
Const CXTypeLayoutError_Incomplete:CXTypeLayoutError
Const CXTypeLayoutError_Dependent:CXTypeLayoutError
Const CXTypeLayoutError_NotConstantSize:CXTypeLayoutError
Const CXTypeLayoutError_InvalidFieldName:CXTypeLayoutError
Function clang_Type_getAlignOf:Long( T:CXType )
Function clang_Type_getClassType:CXType( T:CXType )
Function clang_Type_getSizeOf:Long( T:CXType )
Function clang_Type_getOffsetOf:Long( T:CXType, S:CString )
Function clang_Cursor_getOffsetOfField:Long( C:CXCursor )
Function clang_Cursor_isAnonymous:UInt( C:CXCursor )
Enum CXRefQualifierKind
End
Const CXRefQualifier_None:CXRefQualifierKind
Const CXRefQualifier_LValue:CXRefQualifierKind
Const CXRefQualifier_RValue:CXRefQualifierKind
Function clang_Type_getNumTemplateArguments:Int( T:CXType )
Function clang_Type_getTemplateArgumentAsType:CXType( T:CXType, i:UInt )
Function clang_Type_getCXXRefQualifier:CXRefQualifierKind( T:CXType )
Function clang_Cursor_isBitField:UInt( C:CXCursor )
Function clang_isVirtualBase:UInt( CXCursor )
Enum CX_CXXAccessSpecifier
End
Const CX_CXXInvalidAccessSpecifier:CX_CXXAccessSpecifier
Const CX_CXXPublic:CX_CXXAccessSpecifier
Const CX_CXXProtected:CX_CXXAccessSpecifier
Const CX_CXXPrivate:CX_CXXAccessSpecifier
Function clang_getCXXAccessSpecifier:CX_CXXAccessSpecifier( CXCursor )
Enum CX_StorageClass
End
Const CX_SC_Invalid:CX_StorageClass
Const CX_SC_None:CX_StorageClass
Const CX_SC_Extern:CX_StorageClass
Const CX_SC_Static:CX_StorageClass
Const CX_SC_PrivateExtern:CX_StorageClass
Const CX_SC_OpenCLWorkGroupLocal:CX_StorageClass
Const CX_SC_Auto:CX_StorageClass
Const CX_SC_Register:CX_StorageClass
Function clang_Cursor_getStorageClass:CX_StorageClass( CXCursor )
Function clang_getNumOverloadedDecls:UInt( cursor:CXCursor )
Function clang_getOverloadedDecl:CXCursor( cursor:CXCursor, index:UInt )
Function clang_getIBOutletCollectionType:CXType( CXCursor )
Enum CXChildVisitResult
End
Const CXChildVisit_Break:CXChildVisitResult
Const CXChildVisit_Continue:CXChildVisitResult
Const CXChildVisit_Recurse:CXChildVisitResult
Alias CXCursorVisitor:CXChildVisitResult( CXCursor, CXCursor, CXClientData ) 
Function clang_visitChildren:UInt( parent:CXCursor, visitor:CXCursorVisitor, client_data:CXClientData )
Function clang_getCursorUSR:CXString( CXCursor )
Function clang_constructUSR_ObjCClass:CXString( class_name:CString )
Function clang_constructUSR_ObjCCategory:CXString( class_name:CString, category_name:CString )
Function clang_constructUSR_ObjCProtocol:CXString( protocol_name:CString )
Function clang_constructUSR_ObjCIvar:CXString( name:CString, classUSR:CXString )
Function clang_constructUSR_ObjCMethod:CXString( name:CString, isInstanceMethod:UInt, classUSR:CXString )
Function clang_constructUSR_ObjCProperty:CXString( property_:CString, classUSR:CXString )
Function clang_getCursorSpelling:CXString( CXCursor )
Function clang_Cursor_getSpellingNameRange:CXSourceRange( CXCursor, pieceIndex:UInt, options:UInt )
Function clang_getCursorDisplayName:CXString( CXCursor )
Function clang_getCursorReferenced:CXCursor( CXCursor )
Function clang_getCursorDefinition:CXCursor( CXCursor )
Function clang_isCursorDefinition:UInt( CXCursor )
Function clang_getCanonicalCursor:CXCursor( CXCursor )
Function clang_Cursor_getObjCSelectorIndex:Int( CXCursor )
Function clang_Cursor_isDynamicCall:Int( C:CXCursor )
Function clang_Cursor_getReceiverType:CXType( C:CXCursor )
Enum CXObjCPropertyAttrKind
End
Const CXObjCPropertyAttr_noattr:CXObjCPropertyAttrKind
Const CXObjCPropertyAttr_readonly:CXObjCPropertyAttrKind
Const CXObjCPropertyAttr_getter:CXObjCPropertyAttrKind
Const CXObjCPropertyAttr_assign:CXObjCPropertyAttrKind
Const CXObjCPropertyAttr_readwrite:CXObjCPropertyAttrKind
Const CXObjCPropertyAttr_retain:CXObjCPropertyAttrKind
Const CXObjCPropertyAttr_copy:CXObjCPropertyAttrKind
Const CXObjCPropertyAttr_nonatomic:CXObjCPropertyAttrKind
Const CXObjCPropertyAttr_setter:CXObjCPropertyAttrKind
Const CXObjCPropertyAttr_atomic:CXObjCPropertyAttrKind
Const CXObjCPropertyAttr_weak:CXObjCPropertyAttrKind
Const CXObjCPropertyAttr_strong:CXObjCPropertyAttrKind
Const CXObjCPropertyAttr_unsafe_unretained:CXObjCPropertyAttrKind
Const CXObjCPropertyAttr_class:CXObjCPropertyAttrKind
Function clang_Cursor_getObjCPropertyAttributes:UInt( C:CXCursor, reserved:UInt )
Enum CXObjCDeclQualifierKind
End
Const CXObjCDeclQualifier_None:CXObjCDeclQualifierKind
Const CXObjCDeclQualifier_In:CXObjCDeclQualifierKind
Const CXObjCDeclQualifier_Inout:CXObjCDeclQualifierKind
Const CXObjCDeclQualifier_Out:CXObjCDeclQualifierKind
Const CXObjCDeclQualifier_Bycopy:CXObjCDeclQualifierKind
Const CXObjCDeclQualifier_Byref:CXObjCDeclQualifierKind
Const CXObjCDeclQualifier_Oneway:CXObjCDeclQualifierKind
Function clang_Cursor_getObjCDeclQualifiers:UInt( C:CXCursor )
Function clang_Cursor_isObjCOptional:UInt( C:CXCursor )
Function clang_Cursor_isVariadic:UInt( C:CXCursor )
Function clang_Cursor_getCommentRange:CXSourceRange( C:CXCursor )
Function clang_Cursor_getRawCommentText:CXString( C:CXCursor )
Function clang_Cursor_getBriefCommentText:CXString( C:CXCursor )
Function clang_Cursor_getMangling:CXString( CXCursor )
Function clang_Cursor_getCXXManglings:CXStringSet Ptr( CXCursor )
Alias CXModule:Void Ptr
Function clang_Cursor_getModule:CXModule( C:CXCursor )
Function clang_getModuleForFile:CXModule( CXTranslationUnit, CXFile )
Function clang_Module_getASTFile:CXFile( Module:CXModule )
Function clang_Module_getParent:CXModule( Module:CXModule )
Function clang_Module_getName:CXString( Module:CXModule )
Function clang_Module_getFullName:CXString( Module:CXModule )
Function clang_Module_isSystem:Int( Module:CXModule )
Function clang_Module_getNumTopLevelHeaders:UInt( CXTranslationUnit, Module:CXModule )
Function clang_Module_getTopLevelHeader:CXFile( CXTranslationUnit, Module:CXModule, Index:UInt )
Function clang_CXXConstructor_isConvertingConstructor:UInt( C:CXCursor )
Function clang_CXXConstructor_isCopyConstructor:UInt( C:CXCursor )
Function clang_CXXConstructor_isDefaultConstructor:UInt( C:CXCursor )
Function clang_CXXConstructor_isMoveConstructor:UInt( C:CXCursor )
Function clang_CXXField_isMutable:UInt( C:CXCursor )
Function clang_CXXMethod_isDefaulted:UInt( C:CXCursor )
Function clang_CXXMethod_isPureVirtual:UInt( C:CXCursor )
Function clang_CXXMethod_isStatic:UInt( C:CXCursor )
Function clang_CXXMethod_isVirtual:UInt( C:CXCursor )
Function clang_CXXMethod_isConst:UInt( C:CXCursor )
Function clang_getTemplateCursorKind:CXCursorKind( C:CXCursor )
Function clang_getSpecializedCursorTemplate:CXCursor( C:CXCursor )
Function clang_getCursorReferenceNameRange:CXSourceRange( C:CXCursor, NameFlags:UInt, PieceIndex:UInt )
Enum CXNameRefFlags
End
Const CXNameRange_WantQualifier:CXNameRefFlags
Const CXNameRange_WantTemplateArgs:CXNameRefFlags
Const CXNameRange_WantSinglePiece:CXNameRefFlags
Enum CXTokenKind
End
Const CXToken_Punctuation:CXTokenKind
Const CXToken_Keyword:CXTokenKind
Const CXToken_Identifier:CXTokenKind
Const CXToken_Literal:CXTokenKind
Const CXToken_Comment:CXTokenKind
Struct CXToken
	Field int_data:UInt Ptr
	Field ptr_data:Void Ptr
End
Function clang_getTokenKind:CXTokenKind( CXToken )
Function clang_getTokenSpelling:CXString( CXTranslationUnit, CXToken )
Function clang_getTokenLocation:CXSourceLocation( CXTranslationUnit, CXToken )
Function clang_getTokenExtent:CXSourceRange( CXTranslationUnit, CXToken )
Function clang_tokenize:Void( TU:CXTranslationUnit, Range:CXSourceRange, Tokens:CXToken Ptr Ptr, NumTokens:UInt Ptr )
Function clang_annotateTokens:Void( TU:CXTranslationUnit, Tokens:CXToken Ptr, NumTokens:UInt, Cursors:CXCursor Ptr )
Function clang_disposeTokens:Void( TU:CXTranslationUnit, Tokens:CXToken Ptr, NumTokens:UInt )
Function clang_getCursorKindSpelling:CXString( Kind:CXCursorKind )
Function clang_getDefinitionSpellingAndExtent:Void( CXCursor, startBuf:libc.const_char_t Ptr Ptr, endBuf:libc.const_char_t Ptr Ptr, startLine:UInt Ptr, startColumn:UInt Ptr, endLine:UInt Ptr, endColumn:UInt Ptr )
Function clang_enableStackTraces:Void(  )
Function clang_executeOnThread:Void( fn:Void( Void Ptr ) , user_data:Void Ptr, stack_size:UInt )
Alias CXCompletionString:Void Ptr
Struct CXCompletionResult
	Field CursorKind:CXCursorKind
	Field CompletionString:CXCompletionString
End
Enum CXCompletionChunkKind
End
Const CXCompletionChunk_Optional:CXCompletionChunkKind
Const CXCompletionChunk_TypedText:CXCompletionChunkKind
Const CXCompletionChunk_Text:CXCompletionChunkKind
Const CXCompletionChunk_Placeholder:CXCompletionChunkKind
Const CXCompletionChunk_Informative:CXCompletionChunkKind
Const CXCompletionChunk_CurrentParameter:CXCompletionChunkKind
Const CXCompletionChunk_LeftParen:CXCompletionChunkKind
Const CXCompletionChunk_RightParen:CXCompletionChunkKind
Const CXCompletionChunk_LeftBracket:CXCompletionChunkKind
Const CXCompletionChunk_RightBracket:CXCompletionChunkKind
Const CXCompletionChunk_LeftBrace:CXCompletionChunkKind
Const CXCompletionChunk_RightBrace:CXCompletionChunkKind
Const CXCompletionChunk_LeftAngle:CXCompletionChunkKind
Const CXCompletionChunk_RightAngle:CXCompletionChunkKind
Const CXCompletionChunk_Comma:CXCompletionChunkKind
Const CXCompletionChunk_ResultType:CXCompletionChunkKind
Const CXCompletionChunk_Colon:CXCompletionChunkKind
Const CXCompletionChunk_SemiColon:CXCompletionChunkKind
Const CXCompletionChunk_Equal:CXCompletionChunkKind
Const CXCompletionChunk_HorizontalSpace:CXCompletionChunkKind
Const CXCompletionChunk_VerticalSpace:CXCompletionChunkKind
Function clang_getCompletionChunkKind:CXCompletionChunkKind( completion_string:CXCompletionString, chunk_number:UInt )
Function clang_getCompletionChunkText:CXString( completion_string:CXCompletionString, chunk_number:UInt )
Function clang_getCompletionChunkCompletionString:CXCompletionString( completion_string:CXCompletionString, chunk_number:UInt )
Function clang_getNumCompletionChunks:UInt( completion_string:CXCompletionString )
Function clang_getCompletionPriority:UInt( completion_string:CXCompletionString )
Function clang_getCompletionAvailability:CXAvailabilityKind( completion_string:CXCompletionString )
Function clang_getCompletionNumAnnotations:UInt( completion_string:CXCompletionString )
Function clang_getCompletionAnnotation:CXString( completion_string:CXCompletionString, annotation_number:UInt )
Function clang_getCompletionParent:CXString( completion_string:CXCompletionString, kind:CXCursorKind Ptr )
Function clang_getCompletionBriefComment:CXString( completion_string:CXCompletionString )
Function clang_getCursorCompletionString:CXCompletionString( cursor:CXCursor )
Struct CXCodeCompleteResults
	Field Results:CXCompletionResult Ptr
	Field NumResults:UInt
End
Enum CXCodeComplete_Flags
End
Const CXCodeComplete_IncludeMacros:CXCodeComplete_Flags
Const CXCodeComplete_IncludeCodePatterns:CXCodeComplete_Flags
Const CXCodeComplete_IncludeBriefComments:CXCodeComplete_Flags
Enum CXCompletionContext
End
Const CXCompletionContext_Unexposed:CXCompletionContext
Const CXCompletionContext_AnyType:CXCompletionContext
Const CXCompletionContext_AnyValue:CXCompletionContext
Const CXCompletionContext_ObjCObjectValue:CXCompletionContext
Const CXCompletionContext_ObjCSelectorValue:CXCompletionContext
Const CXCompletionContext_CXXClassTypeValue:CXCompletionContext
Const CXCompletionContext_DotMemberAccess:CXCompletionContext
Const CXCompletionContext_ArrowMemberAccess:CXCompletionContext
Const CXCompletionContext_ObjCPropertyAccess:CXCompletionContext
Const CXCompletionContext_EnumTag:CXCompletionContext
Const CXCompletionContext_UnionTag:CXCompletionContext
Const CXCompletionContext_StructTag:CXCompletionContext
Const CXCompletionContext_ClassTag:CXCompletionContext
Const CXCompletionContext_Namespace:CXCompletionContext
Const CXCompletionContext_NestedNameSpecifier:CXCompletionContext
Const CXCompletionContext_ObjCInterface:CXCompletionContext
Const CXCompletionContext_ObjCProtocol:CXCompletionContext
Const CXCompletionContext_ObjCCategory:CXCompletionContext
Const CXCompletionContext_ObjCInstanceMessage:CXCompletionContext
Const CXCompletionContext_ObjCClassMessage:CXCompletionContext
Const CXCompletionContext_ObjCSelectorName:CXCompletionContext
Const CXCompletionContext_MacroName:CXCompletionContext
Const CXCompletionContext_NaturalLanguage:CXCompletionContext
Const CXCompletionContext_Unknown:CXCompletionContext
Function clang_defaultCodeCompleteOptions:UInt(  )
Function clang_codeCompleteAt:CXCodeCompleteResults Ptr( TU:CXTranslationUnit, complete_filename:CString, complete_line:UInt, complete_column:UInt, unsaved_files:CXUnsavedFile Ptr, num_unsaved_files:UInt, options:UInt )
Function clang_sortCodeCompletionResults:Void( Results:CXCompletionResult Ptr, NumResults:UInt )
Function clang_disposeCodeCompleteResults:Void( Results:CXCodeCompleteResults Ptr )
Function clang_codeCompleteGetNumDiagnostics:UInt( Results:CXCodeCompleteResults Ptr )
Function clang_codeCompleteGetDiagnostic:CXDiagnostic( Results:CXCodeCompleteResults Ptr, Index:UInt )
Function clang_codeCompleteGetContexts:ULong( Results:CXCodeCompleteResults Ptr )
Function clang_codeCompleteGetContainerKind:CXCursorKind( Results:CXCodeCompleteResults Ptr, IsIncomplete:UInt Ptr )
Function clang_codeCompleteGetContainerUSR:CXString( Results:CXCodeCompleteResults Ptr )
Function clang_codeCompleteGetObjCSelector:CXString( Results:CXCodeCompleteResults Ptr )
Function clang_getClangVersion:CXString(  )
Function clang_toggleCrashRecovery:Void( isEnabled:UInt )
Alias CXInclusionVisitor:Void( CXFile, CXSourceLocation Ptr, UInt, CXClientData ) 
Function clang_getInclusions:Void( tu:CXTranslationUnit, visitor:CXInclusionVisitor, client_data:CXClientData )
Enum CXEvalResultKind
End
Const CXEval_Int:CXEvalResultKind
Const CXEval_Float:CXEvalResultKind
Const CXEval_ObjCStrLiteral:CXEvalResultKind
Const CXEval_StrLiteral:CXEvalResultKind
Const CXEval_CFStr:CXEvalResultKind
Const CXEval_Other:CXEvalResultKind
Const CXEval_UnExposed:CXEvalResultKind
Alias CXEvalResult:Void Ptr
Function clang_Cursor_Evaluate:CXEvalResult( C:CXCursor )
Function clang_EvalResult_getKind:CXEvalResultKind( E:CXEvalResult )
Function clang_EvalResult_getAsInt:Int( E:CXEvalResult )
Function clang_EvalResult_getAsDouble:Double( E:CXEvalResult )
Function clang_EvalResult_getAsStr:libc.const_char_t Ptr( E:CXEvalResult )
Function clang_EvalResult_dispose:Void( E:CXEvalResult )
Alias CXRemapping:Void Ptr
Function clang_getRemappings:CXRemapping( path:CString )
Function clang_getRemappingsFromFileList:CXRemapping( filePaths:libc.const_char_t Ptr Ptr, numFiles:UInt )
Function clang_remap_getNumFiles:UInt( CXRemapping )
Function clang_remap_getFilenames:Void( CXRemapping, index:UInt, original:CXString Ptr, transformed:CXString Ptr )
Function clang_remap_dispose:Void( CXRemapping )
Enum CXVisitorResult
End
Const CXVisit_Break:CXVisitorResult
Const CXVisit_Continue:CXVisitorResult
Struct CXCursorAndRangeVisitor
	Field context:Void Ptr
	Field visit:CXVisitorResult( Void Ptr, CXCursor, CXSourceRange ) 
End
Enum CXResult
End
Const CXResult_Success:CXResult
Const CXResult_Invalid:CXResult
Const CXResult_VisitBreak:CXResult
Function clang_findReferencesInFile:CXResult( cursor:CXCursor, file:CXFile, visitor:CXCursorAndRangeVisitor )
Function clang_findIncludesInFile:CXResult( TU:CXTranslationUnit, file:CXFile, visitor:CXCursorAndRangeVisitor )
Alias CXIdxClientFile:Void Ptr
Alias CXIdxClientEntity:Void Ptr
Alias CXIdxClientContainer:Void Ptr
Alias CXIdxClientASTFile:Void Ptr
Struct CXIdxLoc
	Field ptr_data:Void Ptr Ptr
	Field int_data:UInt
End
Struct CXIdxIncludedFileInfo
	Field hashLoc:CXIdxLoc
	Field filename:libc.const_char_t Ptr
	Field file:CXFile
	Field isImport:Int
	Field isAngled:Int
	Field isModuleImport:Int
End
Struct CXIdxImportedASTFileInfo
	Field file:CXFile
	Field module:CXModule
	Field loc:CXIdxLoc
	Field isImplicit:Int
End
Enum CXIdxEntityKind
End
Const CXIdxEntity_Unexposed:CXIdxEntityKind
Const CXIdxEntity_Typedef:CXIdxEntityKind
Const CXIdxEntity_Function:CXIdxEntityKind
Const CXIdxEntity_Variable:CXIdxEntityKind
Const CXIdxEntity_Field:CXIdxEntityKind
Const CXIdxEntity_EnumConstant:CXIdxEntityKind
Const CXIdxEntity_ObjCClass:CXIdxEntityKind
Const CXIdxEntity_ObjCProtocol:CXIdxEntityKind
Const CXIdxEntity_ObjCCategory:CXIdxEntityKind
Const CXIdxEntity_ObjCInstanceMethod:CXIdxEntityKind
Const CXIdxEntity_ObjCClassMethod:CXIdxEntityKind
Const CXIdxEntity_ObjCProperty:CXIdxEntityKind
Const CXIdxEntity_ObjCIvar:CXIdxEntityKind
Const CXIdxEntity_Enum:CXIdxEntityKind
Const CXIdxEntity_Struct:CXIdxEntityKind
Const CXIdxEntity_Union:CXIdxEntityKind
Const CXIdxEntity_CXXClass:CXIdxEntityKind
Const CXIdxEntity_CXXNamespace:CXIdxEntityKind
Const CXIdxEntity_CXXNamespaceAlias:CXIdxEntityKind
Const CXIdxEntity_CXXStaticVariable:CXIdxEntityKind
Const CXIdxEntity_CXXStaticMethod:CXIdxEntityKind
Const CXIdxEntity_CXXInstanceMethod:CXIdxEntityKind
Const CXIdxEntity_CXXConstructor:CXIdxEntityKind
Const CXIdxEntity_CXXDestructor:CXIdxEntityKind
Const CXIdxEntity_CXXConversionFunction:CXIdxEntityKind
Const CXIdxEntity_CXXTypeAlias:CXIdxEntityKind
Const CXIdxEntity_CXXInterface:CXIdxEntityKind
Enum CXIdxEntityLanguage
End
Const CXIdxEntityLang_None:CXIdxEntityLanguage
Const CXIdxEntityLang_C:CXIdxEntityLanguage
Const CXIdxEntityLang_ObjC:CXIdxEntityLanguage
Const CXIdxEntityLang_CXX:CXIdxEntityLanguage
Enum CXIdxEntityCXXTemplateKind
End
Const CXIdxEntity_NonTemplate:CXIdxEntityCXXTemplateKind
Const CXIdxEntity_Template:CXIdxEntityCXXTemplateKind
Const CXIdxEntity_TemplatePartialSpecialization:CXIdxEntityCXXTemplateKind
Const CXIdxEntity_TemplateSpecialization:CXIdxEntityCXXTemplateKind
Enum CXIdxAttrKind
End
Const CXIdxAttr_Unexposed:CXIdxAttrKind
Const CXIdxAttr_IBAction:CXIdxAttrKind
Const CXIdxAttr_IBOutlet:CXIdxAttrKind
Const CXIdxAttr_IBOutletCollection:CXIdxAttrKind
Struct CXIdxAttrInfo
	Field kind:CXIdxAttrKind
	Field cursor:CXCursor
	Field loc:CXIdxLoc
End
Struct CXIdxEntityInfo
	Field kind:CXIdxEntityKind
	Field templateKind:CXIdxEntityCXXTemplateKind
	Field lang:CXIdxEntityLanguage
	Field name:libc.const_char_t Ptr
	Field USR:libc.const_char_t Ptr
	Field cursor:CXCursor
	Field attributes:CXIdxAttrInfo Ptr Ptr
	Field numAttributes:UInt
End
Struct CXIdxContainerInfo
	Field cursor:CXCursor
End
Struct CXIdxIBOutletCollectionAttrInfo
	Field attrInfo:CXIdxAttrInfo Ptr
	Field objcClass:CXIdxEntityInfo Ptr
	Field classCursor:CXCursor
	Field classLoc:CXIdxLoc
End
Enum CXIdxDeclInfoFlags
End
Const CXIdxDeclFlag_Skipped:CXIdxDeclInfoFlags
Struct CXIdxDeclInfo
	Field entityInfo:CXIdxEntityInfo Ptr
	Field cursor:CXCursor
	Field loc:CXIdxLoc
	Field semanticContainer:CXIdxContainerInfo Ptr
	Field lexicalContainer:CXIdxContainerInfo Ptr
	Field isRedeclaration:Int
	Field isDefinition:Int
	Field isContainer:Int
	Field declAsContainer:CXIdxContainerInfo Ptr
	Field isImplicit:Int
	Field attributes:CXIdxAttrInfo Ptr Ptr
	Field numAttributes:UInt
	Field flags:UInt
End
Enum CXIdxObjCContainerKind
End
Const CXIdxObjCContainer_ForwardRef:CXIdxObjCContainerKind
Const CXIdxObjCContainer_Interface:CXIdxObjCContainerKind
Const CXIdxObjCContainer_Implementation:CXIdxObjCContainerKind
Struct CXIdxObjCContainerDeclInfo
	Field declInfo:CXIdxDeclInfo Ptr
	Field kind:CXIdxObjCContainerKind
End
Struct CXIdxBaseClassInfo
	Field base:CXIdxEntityInfo Ptr
	Field cursor:CXCursor
	Field loc:CXIdxLoc
End
Struct CXIdxObjCProtocolRefInfo
	Field protocol_:CXIdxEntityInfo Ptr
	Field cursor:CXCursor
	Field loc:CXIdxLoc
End
Struct CXIdxObjCProtocolRefListInfo
	Field protocols:CXIdxObjCProtocolRefInfo Ptr Ptr
	Field numProtocols:UInt
End
Struct CXIdxObjCInterfaceDeclInfo
	Field containerInfo:CXIdxObjCContainerDeclInfo Ptr
	Field superInfo:CXIdxBaseClassInfo Ptr
	Field protocols:CXIdxObjCProtocolRefListInfo Ptr
End
Struct CXIdxObjCCategoryDeclInfo
	Field containerInfo:CXIdxObjCContainerDeclInfo Ptr
	Field objcClass:CXIdxEntityInfo Ptr
	Field classCursor:CXCursor
	Field classLoc:CXIdxLoc
	Field protocols:CXIdxObjCProtocolRefListInfo Ptr
End
Struct CXIdxObjCPropertyDeclInfo
	Field declInfo:CXIdxDeclInfo Ptr
	Field getter_:CXIdxEntityInfo Ptr
	Field setter_:CXIdxEntityInfo Ptr
End
Struct CXIdxCXXClassDeclInfo
	Field declInfo:CXIdxDeclInfo Ptr
	Field bases:CXIdxBaseClassInfo Ptr Ptr
	Field numBases:UInt
End
Enum CXIdxEntityRefKind
End
Const CXIdxEntityRef_Direct:CXIdxEntityRefKind
Const CXIdxEntityRef_Implicit:CXIdxEntityRefKind
Struct CXIdxEntityRefInfo
	Field kind:CXIdxEntityRefKind
	Field cursor:CXCursor
	Field loc:CXIdxLoc
	Field referencedEntity:CXIdxEntityInfo Ptr
	Field parentEntity:CXIdxEntityInfo Ptr
	Field container:CXIdxContainerInfo Ptr
End
Struct IndexerCallbacks
	Field abortQuery:Int( CXClientData, Void Ptr ) 
	Field diagnostic:Void( CXClientData, CXDiagnosticSet, Void Ptr ) 
	Field enteredMainFile:Void Ptr( CXClientData, CXFile, Void Ptr ) 
	Field ppIncludedFile:Void Ptr( CXClientData, CXIdxIncludedFileInfo Ptr ) 
	Field importedASTFile:Void Ptr( CXClientData, CXIdxImportedASTFileInfo Ptr ) 
	Field startedTranslationUnit:Void Ptr( CXClientData, Void Ptr ) 
	Field indexDeclaration:Void( CXClientData, CXIdxDeclInfo Ptr ) 
	Field indexEntityReference:Void( CXClientData, CXIdxEntityRefInfo Ptr ) 
End
Function clang_index_isEntityObjCContainerKind:Int( CXIdxEntityKind )
Function clang_index_getObjCContainerDeclInfo:CXIdxObjCContainerDeclInfo Ptr( CXIdxDeclInfo Ptr )
Function clang_index_getObjCInterfaceDeclInfo:CXIdxObjCInterfaceDeclInfo Ptr( CXIdxDeclInfo Ptr )
Function clang_index_getObjCCategoryDeclInfo:CXIdxObjCCategoryDeclInfo Ptr( CXIdxDeclInfo Ptr )
Function clang_index_getObjCProtocolRefListInfo:CXIdxObjCProtocolRefListInfo Ptr( CXIdxDeclInfo Ptr )
Function clang_index_getObjCPropertyDeclInfo:CXIdxObjCPropertyDeclInfo Ptr( CXIdxDeclInfo Ptr )
Function clang_index_getIBOutletCollectionAttrInfo:CXIdxIBOutletCollectionAttrInfo Ptr( CXIdxAttrInfo Ptr )
Function clang_index_getCXXClassDeclInfo:CXIdxCXXClassDeclInfo Ptr( CXIdxDeclInfo Ptr )
Function clang_index_getClientContainer:CXIdxClientContainer( CXIdxContainerInfo Ptr )
Function clang_index_setClientContainer:Void( CXIdxContainerInfo Ptr, CXIdxClientContainer )
Function clang_index_getClientEntity:CXIdxClientEntity( CXIdxEntityInfo Ptr )
Function clang_index_setClientEntity:Void( CXIdxEntityInfo Ptr, CXIdxClientEntity )
Alias CXIndexAction:Void Ptr
Function clang_IndexAction_create:CXIndexAction( CIdx:CXIndex )
Function clang_IndexAction_dispose:Void( CXIndexAction )
Enum CXIndexOptFlags
End
Const CXIndexOpt_None:CXIndexOptFlags
Const CXIndexOpt_SuppressRedundantRefs:CXIndexOptFlags
Const CXIndexOpt_IndexFunctionLocalSymbols:CXIndexOptFlags
Const CXIndexOpt_IndexImplicitTemplateInstantiations:CXIndexOptFlags
Const CXIndexOpt_SuppressWarnings:CXIndexOptFlags
Const CXIndexOpt_SkipParsedBodiesInSession:CXIndexOptFlags
Function clang_indexSourceFile:Int( CXIndexAction, client_data:CXClientData, index_callbacks:IndexerCallbacks Ptr, index_callbacks_size:UInt, index_options:UInt, source_filename:CString, command_line_args:libc.const_char_t Ptr Ptr, num_command_line_args:Int, unsaved_files:CXUnsavedFile Ptr, num_unsaved_files:UInt, out_TU:CXTranslationUnit Ptr, TU_options:UInt )
Function clang_indexSourceFileFullArgv:Int( CXIndexAction, client_data:CXClientData, index_callbacks:IndexerCallbacks Ptr, index_callbacks_size:UInt, index_options:UInt, source_filename:CString, command_line_args:libc.const_char_t Ptr Ptr, num_command_line_args:Int, unsaved_files:CXUnsavedFile Ptr, num_unsaved_files:UInt, out_TU:CXTranslationUnit Ptr, TU_options:UInt )
Function clang_indexTranslationUnit:Int( CXIndexAction, client_data:CXClientData, index_callbacks:IndexerCallbacks Ptr, index_callbacks_size:UInt, index_options:UInt, CXTranslationUnit )
Function clang_indexLoc_getFileLocation:Void( loc:CXIdxLoc, indexFile:CXIdxClientFile Ptr, file:CXFile Ptr, line:UInt Ptr, column:UInt Ptr, offset:UInt Ptr )
Function clang_indexLoc_getCXSourceLocation:CXSourceLocation( loc:CXIdxLoc )
Alias CXFieldVisitor:CXVisitorResult( CXCursor, CXClientData ) 
Function clang_Type_visitFields:UInt( T:CXType, visitor:CXFieldVisitor, client_data:CXClientData )

'***** Extern Structs *****

Struct CXCursorSetImpl
End
Struct CXModuleMapDescriptorImpl
End
Struct CXTranslationUnitImpl
End
Struct CXVirtualFileOverlayImpl
End
Public