
#rem

See README.TXT

#end

#Import "<libc>"
#Import "<std>"

#Import "libclang_extern.monkey2"

Using libc..
Using std..

Using libclang..

Global tab:String
Global buf:=New StringStack

Global params:String
Global enumid:String

Global CurrentFile:String

Global Kludges:=New StringMap<String>

Global AnonEnumType:="Int"
Global LongType:="Long"
Global ULongType:="ULong"
Global LongLongType:="Long"
Global ULongLongType:="ULong"

Global IncludeFiles:StringMap<Bool>
Global ExcludeFiles:StringMap<Bool>

Global ext_structs:=New StringMap<Bool>
Global def_structs:=New StringMap<Bool>
Global cstring_types:=New StringMap<Bool>

Global Keywords:StringMap<String>

Function InitKeywords()
	If Keywords Return 
	
	Keywords=New StringMap<String>
	
	Local kws:=""

	kws+="Namespace;Using;Import;Extern;"
	kws+="Public;Private;Protected;Friend;"
	kws+="Void;Bool;Byte;UByte;Short;UShort;Int;UInt;Long;ULong;Float;Double;String;Object;Continue;Exit;"
	kws+="New;Self;Super;Eachin;True;False;Null;Where;"
	kws+="Alias;Const;Local;Global;Field;Method;Function;Property;Getter;Setter;Operator;Lambda;"
	kws+="Enum;Class;Interface;Struct;Protocol;Extends;Implements;Virtual;Override;Abstract;Final;Inline;"
	kws+="Var;Varptr;Ptr;"
	kws+="Not;Mod;And;Or;Shl;Shr;End;"
	kws+="If;Then;Else;Elseif;Endif;"
	kws+="While;Wend;"
	kws+="Repeat;Until;Forever;"
	kws+="For;To;Step;Next;"
	kws+="Select;Case;Default;"
	kws+="Try;Catch;Throw;Throwable;"
	kws+="Return;Print;Static;Cast;Extension"
	
	For Local kw:=Eachin kws.Split( ";" )
		Keywords[kw.ToLower()]=kw
	Next
End

Function SetFile( file:String )
	If file=CurrentFile Return
	CurrentFile=file
	buf.Push( "~n'***** File: "+CurrentFile+" *****~n" )
	Print "Processing:"+file
End

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

Function ErrInfo:String( cursor:CXCursor )
	Local srcloc:=clang_getCursorLocation( cursor )
	Local file:CXFile,line:UInt
	clang_getFileLocation( srcloc,Varptr file,Varptr line,Null,Null )
	Local str:=clang_getFileName( file )
	Return String( str )+" ["+line+"]"
End

Function Err( err:String,cursor:CXCursor )
	Print ErrInfo( cursor )+" : "+err+"~n"+GetSource( cursor )
End

Function GetSource:String( cursor:CXCursor )

	Local range:=clang_getCursorExtent( cursor )

	Local file0:CXFile,line0:UInt,column0:UInt,offset0:UInt
	Local loc0:=clang_getRangeStart( range )
	clang_getFileLocation( loc0,Varptr file0,Varptr line0,Varptr column0,Varptr offset0 )
	Local path0:=String( clang_getFileName( file0 ) )
	
	Local file1:CXFile,line1:UInt,column1:UInt,offset1:UInt
	Local loc1:=clang_getRangeEnd( range )
	clang_getFileLocation( loc1,Varptr file1,Varptr line1,Varptr column1,Varptr offset1 )
	Local path1:=String( clang_getFileName( file1 ) )
	
	If path0<>path1 Or offset1<=offset0 Return ""
	
	Global _src:String,_path:String
	
	If path0<>_path
		_path=path0
		_src=LoadString( _path )
	Endif
	
	Return _src.Slice( offset0,offset1 )
End


Function CursorSpelling:String( cursor:CXCursor )

	Local id:=String( clang_getCursorSpelling( cursor ) )
	
	If Keywords.Contains( id ) id+="_"
	
	Return id
End

Function TypeSpelling:String( type:CXType )

	Local id:=String( clang_getTypeSpelling( type ) )
	
	If id.Contains( "(anonymous" ) Return ""
	
	If id.StartsWith( "const " ) id=id.Slice( 6 )
	
	If id.StartsWith( "struct " )
		id=id.Slice( 7 )
	Else If id.StartsWith( "union " )
		id=id.Slice( 6 )
	Else If id.StartsWith( "enum " )
		id=id.Slice( 5 )
	Endif

	If Keywords.Contains( id ) id+="_"
	
	Select id
	Case "size_t","int8_t","uint8_t","int16_t","uint16_t","int32_t","uint32_t","int64_t","uint64_t","intptr_t","uintptr_t"
		Return "libc."+id
	End
	
	Return id
End

Function IsCStringType:Bool( type:CXType )

	Local ptype:CXType
	
	Select type.kind
	Case CXType_Pointer
		ptype=clang_getPointeeType( type )
	Case CXType_ConstantArray,CXType_IncompleteArray 
		ptype=clang_getElementType( type )
	Default
		Return False
	End
	
	If clang_isConstQualifiedType( ptype )
		Select ptype.kind
		Case CXType_Char_S,CXType_Char_U 
			Return cstring_types["const char *"]
		Case CXType_SChar
			Return cstring_types["const signed char *"]
		Case CXType_UChar
			Return cstring_types["const unsigned char *"]
		End
	Else
		Select ptype.kind
		Case CXType_Char_S,CXType_Char_U 
			Return cstring_types["char *"]
		Case CXType_SChar
			Return cstring_types["signed char *"]
		Case CXType_UChar
			Return cstring_types["unsigned char *"]
		End
	Endif
	
	Return False
End

Function TransType:String( type:CXType,scope:String="" )

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
	
	Case CXType_Typedef Return TypeSpelling( type )

	Case CXType_Enum Return TypeSpelling( type )
	
	Case CXType_Record Return TypeSpelling( type )
	
	Case CXType_Elaborated Return TransType( clang_Type_getNamedType( type ) )
	
	Case CXType_Char_S,CXType_Char_U 
	
		Return clang_isConstQualifiedType( type ) ? "libc.const_char_t" Else "libc.char_t"
	
	Case CXType_Pointer
	
		If scope And IsCStringType( type ) Return "CString"
		
		'can't return const pointers...
		If clang_isConstQualifiedType( type )
			If scope="return" Return ""
		Endif
	
		Local ptype:=clang_getPointeeType( type )
		
		'function pointer?
		If ptype.kind=CXType_Unexposed And clang_getCanonicalType( ptype ).kind=CXType_FunctionProto
		
			Local retType:=TransType( clang_getResultType( ptype ),"return" )
			If Not retType Return ""
			
			Local n:=clang_getNumArgTypes( ptype ),args:=""
		
			For Local i:=0 Until n
			
				Local type:=clang_getArgType( ptype,i )
				
				If type.kind=CXType_Pointer
				
					'isConstQualifiedType not working here?!?
					If String( clang_getTypeSpelling( type ) ).StartsWith( "const " )
						Print "***** Warning - function pointer type has const* parameters *****"
						Print clang_getTypeSpelling( ptype )
					Endif
				Endif
				
				Local arg:=TransType( type,"param" )
				If Not arg Return ""
				If i args+=", "
				args+=arg
			Next
					
			Return retType+"( "+args+" )"
		Endif

		Local r:=TransType( ptype )
		If r Return r+" Ptr"
		Return ""
	
	Case CXType_ConstantArray	'naughty!
	
		If scope And IsCStringType( type ) Return "CString"
	
		Local ptype:=TransType( clang_getElementType( type ) )
		If ptype Return ptype+" Ptr"
	
	Case CXType_IncompleteArray 

		If scope And IsCStringType( type ) Return "CString"
	
		Local ptype:=TransType( clang_getElementType( type ) )
		If ptype Return ptype+" Ptr"

	End
	
	Return ""
End

Function TransType:String( cursor:CXCursor,scope:String="" )

	Return TransType( clang_getCursorType( cursor ),scope )
End

Function VisitFunc:CXChildVisitResult( cursor:CXCursor,parent:CXCursor,client_data:CXClientData )

	Select clang_getCursorKind( cursor )

	Case CXCursor_ParmDecl

		Local id:=CursorSpelling( cursor )

		Local type:=TransType( cursor,"param" )

		If Not type
			params="?"
			Return CXChildVisit_Break
		Endif

		If params params+=", "
		
		If id params+=id+":"+type Else params+=type
	End
	
	Return CXChildVisit_Continue
End

Function VisitStruct:CXChildVisitResult( cursor:CXCursor,parent:CXCursor,client_data:CXClientData )

	Select cursor.kind

	Case CXCursor_FieldDecl

		Local id:=CursorSpelling( cursor )
		
		Local type:=TransType( cursor,"var" )
		
		If type
			buf.Push( tab+"Field "+id+":"+type )
		Else
			Err( "Failed to convert type of field: "+id,cursor )
		Endif
	End

	Return CXChildVisit_Continue
End

Function VisitEnum:CXChildVisitResult( cursor:CXCursor,parent:CXCursor,client_data:CXClientData )

	Select cursor.kind

	Case CXCursor_EnumConstantDecl
	
		buf.Push( tab+"Const "+CursorSpelling( cursor )+":"+enumid )
	End
	
	Return CXChildVisit_Continue
End

Function VisitUnit:CXChildVisitResult( cursor:CXCursor,parent:CXCursor,client_data:CXClientData )

	Local srcloc:=clang_getCursorLocation( cursor )
	
'	If cursor.kind<>CXCursor_TypedefDecl And 
	If clang_Location_isInSystemHeader( srcloc ) Return CXChildVisit_Continue
	
	Local cfile:CXFile,line:UInt
	clang_getFileLocation( srcloc,Varptr cfile,Varptr line,Null,Null )
	Local file:=String( clang_getFileName( cfile ) )
	
	If IncludeFiles
		If Not IncludeFiles.Contains( StripDir( file ) ) Return CXChildVisit_Continue
	Else If ExcludeFiles
		If ExcludeFiles.Contains( StripDir( file ) ) Return CXChildVisit_Continue
	Endif
	
	Select clang_getCursorKind( cursor )
	
	Case CXCursor_EnumDecl

		Local id:=TransType( cursor )
		
		If id
			SetFile( file )
			buf.Push( tab+"Enum "+id+"~nEnd" )
			enumid=id
		Else
			enumid=AnonEnumType
		Endif
			
		clang_visitChildren( cursor,VisitEnum,Null )
		enumid=""
				
	Case CXCursor_StructDecl
	
		Local id:=TransType( cursor )
		
		If id
			If clang_isCursorDefinition( cursor )

				Local sym:=Kludges[id]
				If sym sym="=~q"+sym+"~q"

				SetFile( file )
				buf.Push( tab+"Struct "+id+sym )
			
				tab+="~t"
				clang_visitChildren( cursor,VisitStruct,Null )
				tab=tab.Slice( 0,-1 )
					
				buf.Push( tab+"End" )
			
				def_structs[id]=True
			Else
				ext_structs[id]=True
			Endif
		Else
			Err( "Ignoring anonymous struct",cursor )
		Endif
	
	Case CXCursor_UnionDecl

		Local id:=TransType( cursor )
			
		If id
			If clang_isCursorDefinition( cursor )
			
				SetFile( file )
				buf.Push( tab+"Struct "+id )
				buf.Push( tab+"End" )
				
				Err( "***** Union "+id+" converted to empty struct *****",cursor )

				def_structs[id]=True
			Else
				ext_structs[id]=True
			Endif
		Else
			Err( "Ignoring anonymous union",cursor )
		Endif
	
	Case CXCursor_TypedefDecl
	
		Local id:=CursorSpelling( cursor )

		Local cxtype:=clang_getTypedefDeclUnderlyingType( cursor )
		
		Local type:=TransType( cxtype )
		
		If type 
			If type<>id

				SetFile( file )
				buf.Push( tab+"Alias "+id+":"+type )

			Endif
		Else
			Err( "Failed to convert typedef type: ",cursor )
		Endif
	
	Case CXCursor_FunctionDecl

		Local id:=CursorSpelling( cursor )
	
		Local ftype:=clang_getCursorType( cursor )
		
		Local retType:=TransType( clang_getResultType( ftype ),"return" )
		
		If retType

			params=""		
			clang_visitChildren( cursor,VisitFunc,Null )
			
			If params<>"?"
			
				Local sym:=Kludges[id]
				If sym sym="=~q"+sym+"~q"
			
				SetFile( file )
				buf.Push( tab+"Function "+id+":"+retType+"( "+params+" )"+sym )
			Else
				Err( "Failed to convert params for function: "+id,cursor )
			Endif
		Else
			Err( "Failed to convert return type for function: "+id,cursor )
		Endif
		
	Case CXCursor_VarDecl
	
		Local id:=CursorSpelling( cursor )
		
		Local type:=clang_getCursorType( cursor )
		
		Local ptype:=TransType( type,"global" )
		
		If ptype

			Local sym:=Kludges[id]
			If sym sym="=~q"+sym+"~q"
		
			SetFile( file )
			
			If clang_isConstQualifiedType( type )
				buf.Push( "Const "+id+":"+ptype+sym )
			Else
				buf.Push( "Global "+id+":"+ptype+sym )
			Endif
		Else
			Err( "Failed to convert type for var: "+id,cursor )
		Endif
		
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

	If Not config.Contains( "inputFile" )
		Print "C2mx2: No inputFile specified"
		Return
	Endif
	
	If Not config.Contains( "outputFile" )
		Print "C2mx2: No outputFile specified"
		Return
	Endif

	If Not config.Contains( "clangArgs" )
		Print "C2mx2: No clangArgs specified"
		Return
	Endif
	
	'change to working dir
	ChangeDir( ExtractDir( path ) )
	
	If config.Contains( "workingDir" ) 
		ChangeDir( config.GetString( "workingDir" ) )
	Endif
	
	'input file
	Local input:=config.GetString( "inputFile" )
	
	'outfile file
	Local output:=config.GetString( "outputFile" )

	'clang args
	Local cargs:=config.GetArray( "clangArgs" )
	Local args:=New const_char_t Ptr[cargs.Length]
	For Local i:=0 Until args.Length
		args[i]=ToCString( cargs[i].ToString() )
	Next
	
	'include/exclude files
	If config.Contains( "includeFiles" )
		IncludeFiles=New StringMap<Bool>
		For Local file:=Eachin config.GetArray( "includeFiles" )
			IncludeFiles[file.ToString()]=True
		Next
	Else If config.Contains( "excludeFiles" )
		ExcludeFiles=New StringMap<Bool>
		For Local file:=Eachin config.GetArray( "excludeFiles" )
			ExcludeFiles[file.ToString()]=True
		Next
	Endif

	'extern structs
	If config.Contains( "externStructs" )
		For Local it:=Eachin config.GetArray( "externStructs" )
			ext_structs[it.ToString()]=True
		Next
	Endif
	
	'CString compatible types
	If config.Contains( "cstringTypes" )
		For Local it:=Eachin config.GetArray( "cstringTypes" )
			cstring_types[it.ToString()]=True
		Next
	Else
		cstring_types["const char *"]=True
	Endif
	
	'anonymous enum type
	If config.Contains( "anonEnumType" )
		AnonEnumType=config.GetString( "anonEnumType" )
	Endif
	
	'kludges
	If config.Contains( "kludges" )
		For Local it:=Eachin config.GetArray( "kludges" )
			Local name:=it.ToString()
			Kludges[name]="bb_"+name
		Next
	Endif

	'start clang	
	Local index:=clang_createIndex( 1,1 )
	
	Local tu:=clang_createTranslationUnitFromSourceFile( index,input,args.Length,args.Data,0,Null )
	Assert( tu,"Failed to create translation unit from source file" )
	
	'emit header
	If config.Contains( "header" )
		Local header:=config.GetArray( "header" )
		For Local line:=Eachin header
			buf.Push( line.ToString() )
		Next
	Endif
	
	'Let's GO!
	InitKeywords()
	
	Local cursor:=clang_getTranslationUnitCursor( tu )
	
	clang_visitChildren( cursor,VisitUnit,Null )

	'emit extern structs	
	buf.Push( "~n'***** Extern Structs *****~n" )
	For Local id:=Eachin ext_structs.Keys
		If def_structs[id] Continue
		
		buf.Push( "Struct "+id )
		buf.Push( "End" )
	Next
	
	'emit footer
	If config.Contains( "footer" )
		Local footer:=config.GetArray( "footer" )
		For Local line:=Eachin footer
			buf.Push( line.ToString() )
		Next
	Endif

	'Done!
	buf.Push( "" )	
	
	'emit output
	If SaveString( buf.Join( "~n" ),output )
		Print "~nc2mx2: **** Success ***** - output saved to "+output
	Else
		Print "~nc2mx2: Error saving output to "+output
	Endif

End
