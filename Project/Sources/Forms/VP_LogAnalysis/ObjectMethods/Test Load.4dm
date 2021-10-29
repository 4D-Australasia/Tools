
var $values_c;$messages_c : Collection
var $Range_o;$Object_o;$message_o : Object
var $CurrentPath_t;$Result_t;$Filepath_t;$JSONString_t : Text

$values_c:=New collection:C1472
$Range_o:=New object:C1471

// VP Cells ( vpAreaName ; column ; row ; columnCount ; rowCount)
$Range_o:=VP Cells("ViewProArea";0;0;5;1)

$CurrentPath_t:=System folder:C487(Desktop:K41:16)
$Result_t:=Select document:C905($CurrentPath_t;"json";\
"Please select the conversion log…";Package open:K24:8+Package selection:K24:9;$paths_at)
If (Bool:C1537(OK))
	
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
	
	
	For each ($message_o;$messages_c)
		If ($message_o.message="Listbox property@") | ($message_o.message="Connecting@")
			$message_o.message:=Replace string:C233($message_o.message;"Listbox property 'Scrollable area compatibility mode' not supported.";"Scrollable area compatibility mode")
			$message_o.message:=Replace string:C233($message_o.message;"Connecting listboxes is not supported.";"Connecting listbox")
			
			$Row_c:=New collection:C1472
			$Row_c.push($message_o.message)  // The Error Message
			$Row_c.push($message_o.table)  // The table number
			$Row_c.push($message_o.tableName)  // The table name
			$Row_c.push($message_o.form)  // The form name
			$Row_c.push($message_o.object)  // The form object
			
			$values_c.push($Row_c)
			
		End if 
		
	End for each 
	
	$values_c:=$values_c.orderBy("message asc")
	
	VP SET ROW COUNT("ViewProArea";$values_c.length+1)
	
	// Write all values in the document
	VP SET VALUES(VP Cell("ViewProArea";0;1);$values_c)
	
	
End if 
