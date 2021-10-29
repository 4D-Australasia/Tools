//%attributes = {}
C_TEXT:C284($CurrentPath_t;$Result_t;$Filepath_t;$preferredButtonStyle_t)
C_OBJECT:C1216($Object_o)
C_COLLECTION:C1488($messages_c)
C_LONGINT:C283($i;$size_i)
ARRAY TEXT:C222($messages_at;0)
ARRAY TEXT:C222($paths_at;0)
ARRAY TEXT:C222($severity_at;0)
ARRAY TEXT:C222($Distinct_at;0)
ARRAY LONGINT:C221($Count_ai;0)
C_TEXT:C284($JSONString_t)

  // Choose the button style you prefer
$preferredButtonStyle_t:="raised"
  //$preferredButtonStyle_t:="double"

  // Get the path to the Conversion log
If (Storage:C1525.Paths.conversionLog=Null:C1517)
	$CurrentPath_t:=System folder:C487(Desktop:K41:16)
	$Result_t:=Select document:C905($CurrentPath_t;"json";\
		"Please select the conversion log…";Package open:K24:8+Package selection:K24:9;$paths_at)
	If (ok=1)
		$Filepath_t:=$paths_at{1}
		
		If (Test path name:C476($Filepath_t)=Is a document:K24:1)
			If (Storage:C1525.Paths=Null:C1517)
				Use (Storage:C1525)
					Storage:C1525.Paths:=New shared object:C1526("conversionLog";$Filepath_t)
				End use 
			End if 
		End if 
	End if 
	
Else 
	$Filepath_t:=Storage:C1525.Paths.conversionLog
	
End if 



If (Test path name:C476($Filepath_t)=Is a document:K24:1)
	$JSONString_t:=Document to text:C1236($Filepath_t)
	
	$JSONString_t:=Replace string:C233($JSONString_t;"'Background offset' 3D button style is not supported.";"backGroundOffset")
	
	If ($JSONString_t[[1]]="[")
		$JSONString_t:="{\"OBJ\":"+$JSONString_t+"}"
	End if 
	
	$Object_o:=JSON Parse:C1218($JSONString_t)
	
	
	$messages_c:=$Object_o.messages
	$buttons_c:=New collection:C1472
	
	For each ($message_o;$messages_c)
		If ($message_o.message="backGroundOffset")
			$buttons_c.push($message_o)
		End if 
		
	End for each 
	
	$Log_o:=Path to object:C1547($Filepath_t)
	
	$LogsFolder_t:=$Log_o.parentFolder  //logs folder
	
	$dbFolder_t:=Path to object:C1547($LogsFolder_t).parentFolder
	$tableFormsFolder_t:=$dbFolder_t+"Project"+Folder separator:K24:12+"Sources"+Folder separator:K24:12+"TableForms"+Folder separator:K24:12
	$projectFormsFolder:=$dbFolder_t+"Project"+Folder separator:K24:12+"Sources"+Folder separator:K24:12+"Forms"+Folder separator:K24:12
	
	For each ($FormDetails_o;$buttons_c)
		If ($FormDetails_o.table#Null:C1517)
			$FormPath_t:=$tableFormsFolder_t+String:C10($FormDetails_o.table)+Folder separator:K24:12
			$FormPath_t:=$FormPath_t+$FormDetails_o.form+Folder separator:K24:12
			$FormPath_t:=$FormPath_t+"form.4DForm"
		Else 
			$FormPath_t:=$projectFormsFolder+$FormDetails_o.form+Folder separator:K24:12
			$FormPath_t:=$FormPath_t+"form.4DForm"
		End if 
		
		$formJSON_t:=Document to text:C1236($FormPath_t)
		
		$FormDefinition_o:=JSON Parse:C1218($formJSON_t)
		
		$Pages_c:=$FormDefinition_o.pages
		
		
		
		For each ($page_o;$Pages_c)
			
			If ($page_o#Null:C1517)  // There may not be a page 0
				
				$buttonDefinition_o:=$page_o.objects[$FormDetails_o.object]
				
				If ($buttonDefinition_o#Null:C1517)  // Convert to correct button style
					$buttonDefinition_o.style:="custom"
					$buttonDefinition_o.borderStyle:=$preferredButtonStyle_t
					$buttonDefinition_o.text:=""
					
					
				End if 
				
				
			End if 
			
		End for each 
		
		$formJSON_t:=JSON Stringify:C1217($FormDefinition_o;*)
		TEXT TO DOCUMENT:C1237($FormPath_t;$formJSON_t)
		
		
		
	End for each 
	
End if 

