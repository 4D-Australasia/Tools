//%attributes = {"invisible":true}

C_TEXT($CurrentPath_t;$Result_t;$JSON_t)
C_OBJECT($TheObject_o)
C_COLLECTION($messages_c)
C_LONGINT($i;$size_i)
ARRAY TEXT($messages_at;0)
ARRAY TEXT($paths_at;0)
ARRAY TEXT($severity_at;0)

ARRAY TEXT($Distinct_at;0)
ARRAY LONGINT($Count_ai;0)


$CurrentPath_t:=Get 4D folder(Database folder)+"Logs"+Folder separator
$Result_t:=Select document($CurrentPath_t;"json";\
"Please select the conversion log…";Package open+Package selection;$paths_at)

If (ok=1)
	$CurrentPath_t:=$paths_at{1}
	$JSON_t:=Document to text($CurrentPath_t)
	$TheObject_o:=JSON Parse($JSON_t)
End if 

$messages_c:=$TheObject_o.messages

COLLECTION TO ARRAY($messages_c;\
$severity_at;"severity";\
$messages_at;"message")

$size_i:=Size of array($severity_at)
For ($i;$size_i;1;-1)
	If ($severity_at{$i}="warning")
		DELETE FROM ARRAY($severity_at;$i)
		DELETE FROM ARRAY($messages_at;$i)
	Else 
		If (Find in array($Distinct_at;$messages_at{$i})=-1)
			APPEND TO ARRAY($Distinct_at;$messages_at{$i})
		End if 
	End if 
End for 

$size_i:=Size of array($Distinct_at)
ARRAY LONGINT($Count_ai;$size_i)

For ($i;1;$size_i)
	$Count_ai{$i}:=Count in array($messages_at;$Distinct_at{$i})
End for 

SORT ARRAY($Count_ai;$Distinct_at;<)


$Result_t:="ERROR MESSAGES"
For ($i;1;$size_i)
	$Result_t:=$Result_t+Char(13)
	$Result_t:=$Result_t+String($Count_ai{$i})+Char(9)+$Distinct_at{$i}
End for 

SET TEXT TO PASTEBOARD($Result_t)

ALERT("Finished")