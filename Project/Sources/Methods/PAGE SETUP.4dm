//%attributes = {"invisible":true,"shared":true}
// ----------------------------------------------------
// Project Method: PAGE SETUP( Pointer to Table; Form Name )

// This is a replacement to the old PAGE SETUP command
// It doesn't do exactly the same thing so some experimentation may be required

// Parameters: 
//   $1 : Pointer : Pointer to a table (or nil pointer potentially)
//   $2 : Text : Form Name 

// Created by Wayne Stewart (2021-08-09)

//     wayne@4dsupport.guru
// ----------------------------------------------------

C_POINTER:C301($table_ptr;$1)
C_TEXT:C284($formName_t;$2;$preferenceName_t)

$table_ptr:=$1
$formName_t:=$2
If ($table_ptr#Null:C1517)
	$preferenceName_t:=Table name:C256($table_ptr)+"-"+$formName_t
Else 
	$preferenceName_t:=$formName_t
End if 

If (Print_LoadSettings($preferenceName_t))  // Use the saved settings
Else 
	Case of 
			//: ($table_ptr=(->[PrintLabels])) & ($formName_t="Dymo Label")  // A DYMO label
			//// This will need special handling 
			//// the easiest way is to display the print settings dialog
			//// and let the user select the paper options they want 
			//// and save them below
			//PRINT SETTINGS(Page setup dialog)
			//If (OK=1)
			//Print_SaveSettings($preferenceName_t)
			//End if 
			
			//: (($table_ptr=(->[Arrays])) & ($formName_t="Aged Balances"))\
				 | (($table_ptr=(->[Trns])) & ($formName_t="Day Report"))  // You can list them case by case or just lump them like this
			//Print_SetOptions(New object(\
				"paperSize";"A4";\
				"paperOrientation";2))  // 1 = Portrait, 2 = Landscape
			
			
		Else 
			// Most will be this format, so it's the default 
			Print_SetOptions(New object:C1471(\
				"paperSize";"A4";\
				"paperOrientation";1))  // 1 = Portrait, 2 = Landscape
			
	End case 
	
End if 

// Optionally you might want to save the current settings
Print_SaveSettings($preferenceName_t)
