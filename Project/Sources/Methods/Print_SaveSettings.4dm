//%attributes = {"invisible":true,"shared":true}
// ----------------------------------------------------
// Project Method: Print_SaveSettings (Print Job Name)

// Description

// Access: Shared

// Parameters: 
//   $1 : Text : The name of the print settings blob

// Created by Wayne Stewart (2021-05-02T14:00:00Z)

//     wayne@4dsupport.guru
// ----------------------------------------------------


var $1;$Label_t;$Path_t : Text
var $PrnSettings_x : Blob
var $ErrCode_i : Integer

$Path_t:=Prefs_Folder+"PrintSettings"+Folder separator:K24:12

CREATE FOLDER:C475($Path_t;*)  // Verify it exists

$Label_t:=$1+".D4SP"
$Path_t:=$Path_t+$Label_t

$ErrCode_i:=Print settings to BLOB:C1433($PrnSettings_x)
Case of 
	: ($ErrCode_i=1)
		BLOB TO DOCUMENT:C526($Path_t;$PrnSettings_x)  //everything is OK
	Else 
		ALERT:C41("No selected printer")
End case 