//%attributes = {}
C_TEXT:C284($CurrentPath_t;$Result_t;$Filepath_t)
C_OBJECT:C1216($Object_o;$trimmed_o;$message_o)
C_COLLECTION:C1488($messages_c;$trimmed_c)

C_TEXT:C284($JSONString_t)
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
		
		$JSONString_t:=Document to text:C1236($Filepath_t)
		
		If ($JSONString_t[[1]]="[")
			$JSONString_t:="{\"OBJ\":"+$JSONString_t+"}"
		End if 
		
		$Object_o:=JSON Parse:C1218($JSONString_t)
		
	End if 
	
	$messages_c:=$Object_o.messages
	
	$trimmed_c:=New collection:C1472()
	
	For each ($message_o;$messages_c)
		If ($message_o.message="Listbox property@") | ($message_o.message="Connecting")
			$trimmed_o:=OB Copy:C1225($message_o)
			$trimmed_o.message:=Replace string:C233(" not supported.";"")
			OB REMOVE:C1226($trimmed_o;"severity")
			$trimmed_c.push($trimmed_o)
		End if 
		
	End for each 
	
	
	
	
End if 