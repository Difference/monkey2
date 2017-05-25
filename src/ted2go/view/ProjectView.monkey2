
Namespace ted2go


Class ProjectView Extends ScrollView

	Field openProject:Action
	
	Field ProjectOpened:Void( dir:String )
	Field ProjectClosed:Void( dir:String )

	Method New( docs:DocumentManager,builder:IModuleBuilder )
	
		_docs=docs
		_builder=builder
		
		_docker=New DockingView
		
		ContentView=_docker
		
		_docker.ContentView=New TreeViewExt
		
		openProject=New Action( "Open project" )
		openProject.HotKey=Key.O
		openProject.HotKeyModifiers=Modifier.Menu|Modifier.Shift
		openProject.Triggered=OnOpenProject
	End
	
	Property OpenProjects:String[]()
	
		Local projs:=New StringStack
		For Local proj:=Eachin _projects.Keys
			projs.Add( proj )
		Next
		
		Return projs.ToArray()
	End
	
	Method OpenProject:Bool( dir:String )
	
		dir=StripSlashes( dir )
		
		If _projects[dir] Return False
		
		If GetFileType( dir )<>FileType.Directory Return False
	
		Local browser:=New ProjectBrowserView( dir )
		
		browser.FileClicked+=Lambda( path:String )
		
			'OnOpenDocument( path )
			
		End
		
		browser.FileDoubleClicked+=Lambda( path:String )
		
			OnOpenDocument( path )
		
		End
		
		browser.FileRightClicked+=Lambda( path:String )
		
			Local menu:=New Menu
		
			Select GetFileType( path )
			Case FileType.Directory
			
				menu.AddAction( "Open on Desktop" ).Triggered=Lambda()
				
					requesters.OpenUrl( path )
				End
				
				menu.AddSeparator()
				
				menu.AddAction( "New file" ).Triggered=Lambda()
				
					Local file:=RequestString( "New file name:" )
					If Not file Return
					
					If ExtractExt(file)="" Then file+=".monkey2"
					
					Local tpath:=path+"/"+file
					
					If GetFileType( tpath )<>FileType.None
						Alert( "A file or directory already exists at '"+tpath+"'" )
						Return
					End
					
					If Not CreateFile( tpath )
						Alert( "Failed to create file '"+file+"'" )
					Endif
					
					browser.Refresh()
					Return
				End
		
				menu.AddAction( "New folder" ).Triggered=Lambda()
				
					Local dir:=RequestString( "New folder name:" )
					If Not dir Return
					
					Local tpath:=path+"/"+dir
					
					If GetFileType( tpath )<>FileType.None
						Alert( "A file or directory already exists at '"+tpath+"'" )
						Return
					End
					
					If Not CreateDir( tpath )
						Alert( "Failed to create folder '"+dir+"'" )
						Return
					Endif
					
					browser.Refresh()
					Return
				End
				
				menu.AddAction( "Delete" ).Triggered=Lambda()

					If Not RequestOkay( "Really delete folder '"+path+"'?" ) Return
					
					If DeleteDir( path,True )
						browser.Refresh()
						Return
					Endif
					
					Alert( "Failed to delete folder '"+path+"'" )
				End
				
				menu.AddSeparator()
				
				If path = browser.RootPath ' root node
					
					menu.AddAction( "Close project" ).Triggered=Lambda()
					
						CloseProject( path )
					End
					
					menu.AddAction( "Clean (delete .buildv)" ).Triggered=Lambda()
						
						If Not RequestOkay( "Really delete all '.buildv' folders?" ) Return
						
						Local changes:=CleanProject( path )
						If changes Then browser.Refresh()
					End
				Else
					
					menu.AddAction( "Open as a project" ).Triggered=Lambda()
					
						OpenProject( path )
					End
				Endif
				
				' update / rebuild module
				path=path.Replace( "\","/" )
				Local name := path.Slice( path.FindLast( "/")+1 )
				Local file:=path+"/module.json"
				
				If path.Contains( "/modules/") And GetFileType( file )=FileType.File
					
					menu.AddSeparator()
					
					menu.AddAction( "Update module" ).Triggered=Lambda()
						
						_builder.BuildModules( False,name )
					End
					
					menu.AddAction( "Rebuild module" ).Triggered=Lambda()
				
						_builder.BuildModules( True,name )
					End
				
				Endif
				
			Case FileType.File
			
				menu.AddAction( "Open on Desktop" ).Triggered=Lambda()
				
					requesters.OpenUrl( path )
				End
				
				menu.AddSeparator()
			
				menu.AddAction( "Rename" ).Triggered=Lambda()
				
					Local oldName:=StripDir( path )
					Local name:=RequestString( "Enter new name:","Ranaming '"+oldName+"'" )
					If name=oldName Return
					
					Local newPath:=ExtractDir( path )+name
					If CopyFile( path,newPath )
					
						DeleteFile( path )
					
						browser.Refresh()
						Return
					Endif
					
					Alert( "Failed to rename file: '"+path+"'" )
				End
			
				menu.AddSeparator()
			
				menu.AddAction( "Delete" ).Triggered=Lambda()
				
					If Not RequestOkay( "Really delete file '"+path+"'?" ) return
				
					If DeleteFile( path )
					
						Local doc:=_docs.FindDocument( path )
						
						If doc doc.Close()
					
						browser.Refresh()
						Return
					Endif
					
					Alert( "Failed to delete file: '"+path+"'" )
				End
				
			Default
			
				Return
			End
			
			menu.Open()
		End
		
		_docker.AddView( browser,"top" )
		
		_projects[dir]=browser
		
		browser.Refresh()
		
		ProjectOpened( dir )

		Return True
	End
	
	Method CloseProject( dir:String )

		dir=StripSlashes( dir )
		
		Local view:=_projects[dir]
		If Not view Return
		
		_docker.RemoveView( view )
		
		_projects.Remove( dir )
		
		ProjectClosed( dir )
	End
	
	Method SaveState( jobj:JsonObject )
	
		Local jarr:=New JsonArray
		For Local it:=Eachin _projects
			jarr.Add( New JsonString( it.Key ) )
		Next
		jobj["openProjects"]=jarr
	End
	
	Method LoadState( jobj:JsonObject )
	
		If jobj.Contains( "openProjects" )
			local arr:=jobj["openProjects"].ToArray()
			For Local dir:=Eachin arr
				OpenProject( dir.ToString() )
			Next
		Endif
		
	End
	
	
	Protected
	
	Method OnMouseEvent( event:MouseEvent ) Override
	
		Select event.Type
		Case EventType.MouseWheel ' little faster
			
			Scroll-=New Vec2i( 0,ContentView.RenderStyle.Font.Height*event.Wheel.Y*3 )
			Return
	
		End
	
		Super.OnMouseEvent( event )
	End
	
	
	Private
	
	Field _docs:DocumentManager
	Field _docker:=New DockingView
	Field _projects:=New StringMap<FileBrowser>
	Field _builder:IModuleBuilder

	Method OnOpenProject()
	
		Local dir:=MainWindow.RequestDir( "Select Project Directory...","" )
		If Not dir Return
		
		OpenProject( dir )
	End
	
	Method OnOpenDocument( path:String )
		
		If GetFileType( path )=FileType.File
		
			New Fiber( Lambda()
				_docs.OpenDocument( path,True )
			End )
		
		Endif
	End
	
	' Return True if there is an actual folder deletion
	Method CleanProject:Bool( dir:String )
	
		Local succ:=0,err:=0
		Local items:=LoadDir( dir )
		For Local i:=Eachin items
			i=dir+"/"+i
			If GetFileType(i)=FileType.Directory
				If i.Contains( ".buildv" )
					Local ok:=DeleteDir( i,True )
					If ok Then succ+=1 Else err+=1
				Endif
			Endif
		Next
	
		Local s:= err=0 ? "Project was successfully cleaned." Else "Clean project error! Some files are busy or you have no privileges."
		MainWindow.ShowStatusBarText( s )
		
		Return succ>0
	End
	
End