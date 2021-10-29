//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project Method: Pict_PathwayFromID (Picture ID) --> Text

// Because the Picture Library no longer works in Project
//   Mode we need to translate from the picture ID to a path
//   in the resources folder

// Access: Shared

// Parameters: 
//   $1 : Longint : The ID number in the Picture Library

// Returns: 
//   $0 : Text : A path to the picture in the resources folder

// Created by Wayne Stewart (2021-06-03T14:00:00Z)
//     wayne@4dsupport.guru
// ----------------------------------------------------

If (False:C215)
	C_LONGINT:C283(Pict_PathwayFromID;$1)
	C_TEXT:C284(Pict_PathwayFromID;$0)
End if 

C_LONGINT:C283($PictureID_i;$1)
C_TEXT:C284($0;$Pathway_t;$FileName_t)

PICT_Init

$PictureID_i:=$1
$Pathway_t:=Get 4D folder:C485(Current resources folder:K5:16)+"Images"+Folder separator:K24:12
$FileName_t:=Storage:C1525.pictureLookup[String:C10($PictureID_i)]
$Pathway_t:=$Pathway_t+$FileName_t

$0:=$Pathway_t