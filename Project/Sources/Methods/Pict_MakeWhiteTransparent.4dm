//%attributes = {}
C_VARIANT:C1683($1)

var $continue_b : Boolean
var $pathType_i;$currFile_i;$numFiles_i : Integer
var $thePicture_pic;$blank_pic : Picture

ARRAY PICTURE:C279($thePictures_apic;0)
ARRAY TEXT:C222($paths_at;0)

$continue_b:=True:C214
Case of 
	: (Value type:C1509($1)=Is picture:K8:10)
		APPEND TO ARRAY:C911($thePictures_apic;$1)
		
	: (Value type:C1509($1)=Is text:K8:3)
		$pathType_i:=Test path name:C476($1)
		
		Case of 
			: ($pathType_i=Is a document:K24:1)
				READ PICTURE FILE:C678($1;$thePicture_pic)
				If (OK=1)
					APPEND TO ARRAY:C911($thePictures_apic;$thePicture_pic)
					APPEND TO ARRAY:C911($paths_at;$1)
				Else 
					$continue_b:=False:C215
				End if 
				
			: ($pathType_i=Is a folder:K24:2)
				DOCUMENT LIST:C474($1;$paths_at;Absolute path:K24:14)
				$numFiles_i:=Size of array:C274($paths_at)
				For ($currFile_i;1;$numFiles_i)
					If (Is picture file:C1113($paths_at{$currFile_i}))
						READ PICTURE FILE:C678($paths_at{$currFile_i};$thePicture_pic)
						If (OK=1)
							APPEND TO ARRAY:C911($thePictures_apic;$thePicture_pic)
						Else 
							APPEND TO ARRAY:C911($thePictures_apic;$blank_pic)
						End if 
					Else 
						APPEND TO ARRAY:C911($thePictures_apic;$blank_pic)
					End if 
				End for 
				
			Else 
				$continue_b:=False:C215
		End case 
		
		
	Else 
		$continue_b:=False:C215
		
End case 

$numFiles_i:=Size of array:C274($thePictures_apic)

If ($continue_b)
	For ($currFile_i;1;$numFiles_i)
		If (Picture size:C356($thePictures_apic{$currFile_i})>0)
			TRANSFORM PICTURE:C988($thePictures_apic{$currFile_i};Transparency:K61:11;0x00FFFFFF)  // Make the white areas transparent
			WRITE PICTURE FILE:C680($paths_at{$currFile_i};$thePictures_apic{$currFile_i};".png")
		End if 
	End for 
End if 