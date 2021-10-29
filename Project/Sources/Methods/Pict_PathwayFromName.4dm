//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project Method: Pict_PathwayFromName (Picture Name) --> Text

// Because the Picture Library no longer works in Project
//   Mode we need to translate from the picture Name to a path
//   in the resources folder

// Access: Shared

// Parameters: 
//   $1 : Text : The Picture Name in the Picture Library

// Returns: 
//   $0 : Text : A path to the picture in the resources folder

// Created by Wayne Stewart (2021-06-03T14:00:00Z)
//     wayne@4dsupport.guru
// ----------------------------------------------------


#DECLARE($PictureName_t : Text)->$Pathway_t : Text

var $Pathway_t;$FileName_t : Text

PICT_Init  // Make certain the Storage object is initialised


$Pathway_t:=Get 4D folder:C485(Current resources folder:K5:16)+"Images"+Folder separator:K24:12
$FileName_t:=Storage:C1525.pictureLookup[$PictureName_t]  // Useing square brackets in case of a space in picture name
$Pathway_t:=$Pathway_t+$FileName_t

