
Namespace std.zipfile

Using miniz

#rem monkeydoc @hidden
#end
Class ZipFile

	Property Files:String[]()
		Return _files
	End
	
	Method Close()
		If Not _data Return
		libc.free( _zip )
		_data.Discard()
		_data=Null
	End
	
	Method FindFile:Int( file:String )

		For Local i:=0 Until _files.Length
			If file=_files[i] Return i
		Next
		
		Return -1
	End
	
	Method Extract:Bool( dir:String,prefix:String="" )
	
		If Not dir.EndsWith( "/" ) dir+="/"
		
		Local result:=True
	
		For Local i:=0 Until _files.Length
		
			Local name:=_files[i]
			If Not name Continue
			
			If prefix And Not name.StartsWith( prefix ) Continue
			
			Local size:=_sizes[i]

			Local buf:=New DataBuffer( size )
		
			If mz_zip_reader_extract_to_mem( _zip,i,buf.Data,size,0 ) 
			
				Local path:=dir+name
				
				filesystem.CreateDir( ExtractDir( path ) )
				
				buf.Save( path )
			Else
				result=False
			Endif
			
			buf.Discard()
		Next
		
		Return result
	End
	
	Function Open:ZipFile( path:String )
	
		Local data:=DataBuffer.Load( path )
		If Not data Return Null
		
		Local zip:mz_zip_archive Ptr
		
		zip=Cast<mz_zip_archive Ptr>( libc.malloc( sizeof( zip[0] ) ) )
		memset( zip,0,sizeof( zip[0] ) )

		If Not mz_zip_reader_init_mem( zip,data.Data,data.Length,0 )
			free( zip )
			data.Discard()
			Return Null
		Endif
		
		Return New ZipFile( data,zip )
	End

	Private

	Field _data:DataBuffer
	Field _zip:mz_zip_archive Ptr
	
	Field _files:String[]
	Field _sizes:Int[]
	
	Method New( data:DataBuffer,zip:mz_zip_archive Ptr )
	
		_data=data
		_zip=zip
		
		Local nfiles:=mz_zip_reader_get_num_files( _zip )
		
		_files=New String[nfiles]
		_sizes=New Int[nfiles]
		
		For Local i:=0 Until nfiles
		
			Local stat:mz_zip_archive_file_stat
			If Not mz_zip_reader_file_stat( zip,i,Varptr stat ) Continue
			
			_files[i]=String.FromCString( stat.m_filename )
			_sizes[i]=stat.m_uncomp_size
		Next
	End

End

#rem monkeydoc Extracts a zip file to a directory.

@param zipFile File path of zipfile to extract.

@param dstDir Directory to extract zip file to.

@return True if successful.

#end
Function ExtractZip:Bool( zipFile:String,dstDir:String )

	Return ExtractZip( zipFile,dstDir )
End

#rem monkeydoc @hidden
#end
Function ExtractZip:Bool( zipFile:String,dstDir:String,prefix:String )

	Local zip:=ZipFile.Open( zipFile )
	If Not zip Return False
	
	Local result:=zip.Extract( dstDir,prefix )
	
	zip.Close()
	
	Return result
End
