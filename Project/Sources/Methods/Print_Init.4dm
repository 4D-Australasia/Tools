//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project Method: Print_Init

// Initialises the 4D Australasia Print Routines

// Created by Wayne Stewart (2021-08-24T14:00:00Z)

//     wayne@4dsupport.guru
// ----------------------------------------------------
If (False:C215)
	Print_Init
End if 

If (Storage:C1525.Print4DANZ=Null:C1517)
	Use (Storage:C1525)
		Storage:C1525.Print4DANZ:=New shared object:C1526(\
			"printPrefsFolder";Get 4D folder:C485(Active 4D Folder:K5:10)+File_Name(Structure file:C489(*))+Folder separator:K24:12)
		
	End use 
End if 