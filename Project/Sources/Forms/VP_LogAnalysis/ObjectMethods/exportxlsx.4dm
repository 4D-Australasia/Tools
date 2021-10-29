
C_OBJECT:C1216($params)
C_TEXT:C284($d)

// Selection of the file
$d:=Select document:C905(System folder:C487(Desktop:K41:16); ".xlsx"; "Save excel file"; Use sheet window:K24:11+File name entry:K24:17)

If (Bool:C1537(ok))
	$params:=New object:C1471
	// creation of formula executed after the export
	//$params.formula:=Formula(AfterExport)
	
	// export of the 4D View Pro area in excel format
	VP EXPORT DOCUMENT("ViewProArea"; document; $params)
	
	//ACCEPT
	
End if 