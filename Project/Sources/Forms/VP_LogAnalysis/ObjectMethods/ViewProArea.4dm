If (Form event code:C388=On VP Ready:K2:59)
	OBJECT SET ENABLED:C1123(*;"importxlsx";True:C214)
	OBJECT SET ENABLED:C1123(*;"exportxlsx";True:C214)
	
	VP IMPORT DOCUMENT("ViewProArea";Get 4D folder:C485(Current resources folder:K5:16)+"Reports"+Folder separator:K24:12+"Template.xlsx")
	VP SET ROW COUNT("ViewProArea";1)
	
End if 