
#Import "<libc>"
#Import "<std>"

#Import "libclang_extern.monkey2"

Using libc..
Using std..

Using libclang..

Global tab:String
Global buf:=New StringStack

Global enumType:=""
Global superType:=""
Global paramDecls:=New Stack<CXCursor>

Global LongType:="Long"
Global ULongType:="ULong"
Global LongLongType:="Long"
Global ULongLongType:="ULong"

Struct CXString Extension
	Method To:String()
		Return ToString( Self )
	End
End

Function ToString:String( str:CXString )
	Local cstr:=clang_getCString( str )
	clang_disposeString( str )
	Return cstr
End

Function ToCString:const_char_t Ptr( str:String )
	Local n:=str.Length+1
	Local buf:=Cast<Byte Ptr>( malloc( n ) )
	str.ToCString( buf,n )
	Return Cast<const_char_t Ptr>( buf )
End

Function Emit( str:String )
	If str.StartsWith( "}" ) tab=tab.Slice( 0,-1 ) ; str=str.Slice( 1 )
	If str.EndsWith( "{" )
		buf.Push( tab+str.Slice( 0,-1 ) )
		tab+="~t"
	Else
		buf.Push( tab+str )
	Endif
End

Function Err( cursor:CXCursor )

	Local srcloc:=clang_getCursorLocation( cursor )
	
	Local err:="Error translating '"+String( clang_getCursorDisplayName( cursor ) )+"' : cursor.kind="+Int(cursor.kind)
	
	Emit( "'"+err )
End

Function TransType:String( type:CXType )

	If clang_isConstQualifiedType( type ) Return ""
	
	Select type.kind
	
	Case CXType_Void Return "Void"
	
	Case CXType_SChar Return "Byte"
	
	Case CXType_UChar Return "UByte"
	
	Case CXType_Bool Return "Bool"
	
	Case CXType_Short Return "Short"
	
	Case CXType_UShort Return "UShort"
	
	Case CXType_Int Return "Int"
	
	Case CXType_UInt Return "UInt"
	
	Case CXType_Float Return "Float"
	
	Case CXType_Double Return "Double"
	
	Case CXType_Long Return LongType
	
	Case CXType_ULong Return ULongType
	
	Case CXType_LongLong Return LongLongType
	
	Case CXType_ULongLong Return ULongLongType
	
	Case CXType_Pointer 
	
		Local ptype:=TransType( clang_getPointeeType( type ) )
		If ptype Return ptype+" Ptr"
		
	Case CXType_ConstantArray
	
		Local ptype:=TransType( clang_getElementType( type ) )
		If ptype Return ptype+" Ptr"
	
	Case CXType_IncompleteArray 

		Local ptype:=TransType( clang_getElementType( type ) )
		If ptype Return ptype+" Ptr"
	
	Case CXType_Record
	
		Return clang_getTypeSpelling( type )
		
	Case CXType_Elaborated
	
		Return TransType( clang_Type_getNamedType( type ) )

	Case CXType_Typedef
	
		Return clang_getTypeSpelling( type )
		
	End
	
	Return "Bad("+Int(type.kind)+")"
End

Function TransType:String( cursor:CXCursor )

	Return TransType( clang_getCursorType( cursor ) )
End

Function TransIdent:String( cursor:CXCursor )

	Local id:=String( clang_getCursorSpelling( cursor ) )
	
	Return id

End

Function EmitTypedefDecl:Bool( cursor:CXCursor )

	If cursor.kind<>CXCursor_TypedefDecl Return False
	
	Local id:=TransIdent( cursor )
	If Not id Return False
	
	Local type:=TransType( clang_getTypedefDeclUnderlyingType( cursor ) )
	If Not type Return False
	
	If id=type Return True
	
	Emit( "Alias "+id+":"+type )
	
	Return True
End

Function EmitEnumDecl:Bool( cursor:CXCursor )

	If cursor.kind<>CXCursor_EnumDecl Return False
	
	Local id:=TransIdent( cursor )
	If Not id Return False
	
	Emit( "Enum "+id )
	Emit( "End" )
	
	enumType=id
	clang_visitChildren( cursor,VisitEnumDecl,Null )

	Return True	
End

Function EmitTypeDecl:Bool( cursor:CXCursor )

	Local kind:=""
	Select cursor.kind
	Case CXCursor_ClassDecl
		kind="Class"
	Case CXCursor_StructDecl,CXCursor_UnionDecl
		kind="Struct"
	Default
		Return False
	End

	Local id:=TransIdent( cursor )
	If Not id Return False
	
	If Not clang_isCursorDefinition( cursor ) Return True

	Local pos:=buf.Length
	Emit( kind+" "+id+"{" )
	
	superType=""
	clang_visitChildren( cursor,VisitTypeDecl,Null )
	
	If kind="Class"
		If superType
			buf[pos]+=" Extends "+superType
		Else
			buf[pos]+=" Extends Void"
		End
	Endif
	
	Emit( "}End" )
	
	Return True
End

Function EmitFuncDecl:Bool( cursor:CXCursor )

	Local kind:="",id:=""
	Select cursor.kind
	Case CXCursor_FunctionDecl
		kind="Function"
	Case CXCursor_CXXMethod
		kind="Method"
	Case CXCursor_Constructor
		kind="Method"
		id="New"
	Default
		Return False
	End

	If Not id 
		id=TransIdent( cursor )
		If Not id Return False
	Endif
	
	Local ftype:=clang_getCursorType( cursor )
	
	Local retType:=TransType( clang_getResultType( ftype ) )
	If Not retType Return False
	
	paramDecls.Clear()
	clang_visitChildren( cursor,VisitFuncDecl,Null )
	
	Local argTypes:=New Stack<String>
	
	For Local param:=Eachin paramDecls
	
		Local id:=TransIdent( param )
		If Not id Return False
	
		Local type:=TransType( param )
		If Not type Return False
		
		argTypes.Push( id+":"+type )
	Next
	
	local mods:=""
	If kind="Method" And clang_CXXMethod_isVirtual( cursor ) mods=" Virtual"
	
	Emit( kind+" "+id+":"+retType+"("+argTypes.Join( "," )+")"+mods )
	
	Return True
End

Function EmitVarDecl:Bool( cursor:CXCursor )

	Local kind:=""
	Select cursor.kind
	Case CXCursor_VarDecl
		kind=clang_isConstQualifiedType( clang_getCursorType( cursor ) ) ? "Const" Else "Global"
	Case CXCursor_FieldDecl
		kind="Field"
	Default
		Return False
	End

	Local id:=TransIdent( cursor )
	If Not id Return False
		
	Local type:=TransType( cursor )
	If Not type Return False
	
	Emit( kind+" "+id+":"+type )
	
	Return True
End

Function VisitEnumDecl:CXChildVisitResult( cursor:CXCursor,parent:CXCursor,client_data:CXClientData )

	Select cursor.kind
	
	Case CXCursor_EnumConstantDecl
	
		Emit( "Const "+TransIdent( cursor )+":"+enumType )
	
	Default
	
		Err( cursor )
	End
	
	Return CXChildVisit_Continue
End

Function VisitTypeDecl:CXChildVisitResult( cursor:CXCursor,parent:CXCursor,client_data:CXClientData )
	
	If clang_getCXXAccessSpecifier( cursor )=CX_CXXPrivate Return CXChildVisit_Continue

	Select cursor.kind
	
	Case CXCursor_CXXBaseSpecifier
	
		superType=TransType( cursor )
	
	Case CXCursor_FieldDecl
	
		If Not EmitVarDecl( cursor ) Err( cursor )
		
	Case CXCursor_CXXMethod,CXCursor_Constructor
	
		If Not EmitFuncDecl( cursor ) Err( cursor )
		
	Case CXCursor_CXXAccessSpecifier
	
	Default
	
		Err( cursor )
	End
	
	Return CXChildVisit_Continue
End

Function VisitFuncDecl:CXChildVisitResult( cursor:CXCursor,parent:CXCursor,client_data:CXClientData )

	Select cursor.kind

	Case CXCursor_ParmDecl
	
		paramDecls.Push( cursor )
	
	Default
	
		Err( cursor )
	End
	
	Return CXChildVisit_Continue
End

Function VisitTransUnit:CXChildVisitResult( cursor:CXCursor,parent:CXCursor,client_data:CXClientData )

	Local srcloc:=clang_getCursorLocation( cursor )
	If clang_Location_isInSystemHeader( srcloc ) Return CXChildVisit_Continue

	Select cursor.kind
	
	Case CXCursor_TypedefDecl
	
		If Not EmitTypedefDecl( cursor ) Err( cursor )
		
	Case CXCursor_EnumDecl
	
		If Not EmitEnumDecl( cursor ) Err( cursor )
	
	Case CXCursor_StructDecl,CXCursor_ClassDecl
	
		If Not EmitTypeDecl( cursor ) Err( cursor )
		
	Case CXCursor_FunctionDecl
	
		If Not EmitFuncDecl( cursor ) Err( cursor )

	Case CXCursor_VarDecl
	
		If Not EmitVarDecl( cursor ) Err( cursor )
		
	Default
	
		Err( cursor )
	
	End
	
	Return CXChildVisit_Continue

End

Function VisitDebug:CXChildVisitResult( cursor:CXCursor,parent:CXCursor,client_data:CXClientData )

	Local ctype:=clang_getCursorType( cursor )

	Print tab+clang_getCursorSpelling( cursor )+":"+clang_getTypeSpelling( ctype )+", cursor kind="+Int( cursor.kind )+", type kind="+Int( ctype.kind )
	
	tab+="~t"
	clang_visitChildren( cursor,VisitDebug,Null )
	tab=tab.Slice( 0,-1 )

	Return CXChildVisit_Continue
End

Function Main()

	Local path:=RequestFile( "Select c2mx2.json file...","Json files:json" )
	If Not path Return
	
	Local config:=JsonObject.Load( path )
	If Not config
		Print "C2mx2: Failed to load JSON object from "+path
		Return
	Endif

	If Not config.Contains( "clangArgs" )
		Print "C2mx2: No clangArgs specified"
		Return
	Endif
	
	If Not config.Contains( "inputFile" )
		Print "C2mx2: No inputFile specified"
		Return
	Endif
	
	If Not config.Contains( "outputFile" )
		Print "C2mx2: No outputFile specified"
		Return
	Endif

	'change to working dir
	ChangeDir( ExtractDir( path ) )
	
	If config.Contains( "workingDir" ) 
		ChangeDir( config.GetString( "workingDir" ) )
	Endif
	
	'clang args
	Local cargs:=config.GetArray( "clangArgs" )
	Local args:=New const_char_t Ptr[cargs.Length]
	For Local i:=0 Until args.Length
		args[i]=ToCString( cargs[i].ToString() )
	Next
	
	'input file
	Local inputFile:=config.GetString( "inputFile" )
	
	'outfile file
	Local outputFile:=config.GetString( "outputFile" )

	'start clang	
	Local clangIndex:=clang_createIndex( 1,1 )
	
	'create trans unit
	Local transUnit:=clang_createTranslationUnitFromSourceFile( clangIndex,inputFile,args.Length,args.Data,0,Null )
	Assert( transUnit,"Failed to create translation unit from source file" )
	
	Local cursor:=clang_getTranslationUnitCursor( transUnit )
	
	clang_visitChildren( cursor,VisitTransUnit,Null )
'	clang_visitChildren( cursor,VisitDebug,Null )
	
	Print buf.Join( "~n" )

End
