//%attributes = {}
C_TEXT:C284($CurrentPath_t;$Result_t;$Filepath_t)
C_OBJECT:C1216($Object_o)
C_COLLECTION:C1488($messages_c)
C_LONGINT:C283($i;$size_i)
ARRAY TEXT:C222($messages_at;0)
ARRAY TEXT:C222($paths_at;0)
ARRAY TEXT:C222($severity_at;0)
ARRAY TEXT:C222($Distinct_at;0)
ARRAY LONGINT:C221($Count_ai;0)
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
	
	COLLECTION TO ARRAY:C1562($messages_c;\
		$severity_at;"severity";\
		$messages_at;"message")
	
	$size_i:=Size of array:C274($severity_at)
	For ($i;$size_i;1;-1)
		If ($severity_at{$i}="warning") | ($severity_at{$i}="info")  // You might want to remove the second criteria
			DELETE FROM ARRAY:C228($severity_at;$i)
			DELETE FROM ARRAY:C228($messages_at;$i)
		Else 
			If (Find in array:C230($Distinct_at;$messages_at{$i})=-1)
				APPEND TO ARRAY:C911($Distinct_at;$messages_at{$i})
			End if 
		End if 
	End for 
	
	$size_i:=Size of array:C274($Distinct_at)
	ARRAY LONGINT:C221($Count_ai;$size_i)
	
	For ($i;1;$size_i)
		$Count_ai{$i}:=Count in array:C907($messages_at;$Distinct_at{$i})
	End for 
	
	SORT ARRAY:C229($Count_ai;$Distinct_at;<)
	
	
	$Result_t:="ERROR MESSAGES"
	For ($i;1;$size_i)
		$Result_t:=$Result_t+Char:C90(13)
		$Result_t:=$Result_t+String:C10($Count_ai{$i})+Char:C90(9)+$Distinct_at{$i}
	End for 
	
	SET TEXT TO PASTEBOARD:C523($Result_t)
	
	ALERT:C41("Done"+)
	
End if 