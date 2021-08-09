//%attributes = {"invisible":true,"shared":true}
// ----------------------------------------------------
// Project Method: Print_LoadSettings (Print Job Name)

// Description

// Access: Shared

// Parameters: 
//   $1 : Text : The name of the print settings blob

// Returns
//   $0 : Boolean : Successfully restored

// Created by Wayne Stewart (2021-05-03)

//     wayne@4dsupport.guru
// ----------------------------------------------------

var $1;$Label_t;$Path_t : Text
var $0 : Boolean
var $PrnSettings_x : Blob
var $ErrCode_i : Integer

$0:=False:C215  // Initialise a negative response

$Path_t:=Prefs_Folder+"PrintSettings"+Folder separator:K24:12

$Label_t:=$1+".D4SP"  // 4D Print Settings: if you open the BLOB this is the first four characters, so it's as good an extenion as any other
$Path_t:=$Path_t+$Label_t


If (Test path name:C476($Path_t)=Is a document:K24:1)
	DOCUMENT TO BLOB:C525($Path_t;$PrnSettings_x)
	$ErrCode_i:=BLOB to print settings:C1434($PrnSettings_x)
	
	Case of 
		: ($ErrCode_i=1)  //everything is OK
			$0:=True:C214
			
		: ($ErrCode_i=2)
			CONFIRM:C162("Printer has changed!\n\nCheck the print settings?")
			If (OK=1)
				PRINT SETTINGS:C106
			End if 
			
		: ($ErrCode_i=0)
			ALERT:C41("There is no current printer.")
			
		: ($ErrCode_i=-1)
			ALERT:C41("Invalid settings file.")
			DELETE DOCUMENT:C159($Path_t)
			
	End case 
End if 

