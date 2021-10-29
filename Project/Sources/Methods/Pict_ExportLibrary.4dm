//%attributes = {}
ARRAY LONGINT:C221($picRef_ai;0)
ARRAY TEXT:C222($picName_at;0)

C_LONGINT:C283($count_i;$numRemoved_i)
C_TEXT:C284($FileName_t;$path_t)
C_OBJECT:C1216($thePictureLibrary_o)

$thePictureLibrary_o:=JSON Parse:C1218("{}")  // Needed in older versions of 4D

$path_t:=Get 4D folder:C485(Current resources folder:K5:16)+"Images"+Folder separator:K24:12

// Create the folder
CREATE FOLDER:C475($path_t;*)

// Export the pictures to the Images folder
PICTURE LIBRARY LIST:C564($picRef_ai;$picName_at)

For ($count_i;1;Size of array:C274($picName_at))
	GET PICTURE FROM LIBRARY:C565($picRef_ai{$count_i};$picture_pic)
	If (OK=1)
		CONVERT PICTURE:C1002($picture_pic;".png")  // conversion to png
		TRANSFORM PICTURE:C988($picture_pic;Transparency:K61:11;0x00FFFFFF)  // Make the white areas transparent
		$FileName_t:=$picName_at{$count_i}+".png"
		// Get rid of folder separators
		$FileName_t:=Replace string:C233($FileName_t;"\\";"-")
		$FileName_t:=Replace string:C233($FileName_t;":";"-")
		$FileName_t:=Replace string:C233($FileName_t;".png.png";".png")
		WRITE PICTURE FILE:C680($path_t+$FileName_t;$picture_pic;".png")
		OB SET:C1220($thePictureLibrary_o;String:C10($picRef_ai{$count_i});$FileName_t)  // Look up via number
		OB SET:C1220($thePictureLibrary_o;$picName_at{$count_i};$FileName_t)  // Look up via name
	End if 
End for 

$Lookup_t:=JSON Stringify:C1217($thePictureLibrary_o;*)

TEXT TO DOCUMENT:C1237($path_t+"Lookup.json";$Lookup_t;"UTF-8")


ALERT:C41(String:C10($count_i))

