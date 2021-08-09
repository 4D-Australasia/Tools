//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project Method: File_Name (path) --> Text

// Returns the file name from the full pathname.

// Access Type: Shared

// Parameters: 
//   $1 : Text : A full pathname

// Returns: 
//   $0 : Text : The file name at the end of the pathname (without the extension)

// Created by Wayne Stewart (2021-08-09)
//     wayne@4dsupport.guru
// ----------------------------------------------------

C_TEXT:C284($0;$1)
C_OBJECT:C1216($File_o)

$File_o:=File:C1566($1)
$0:=Substring:C12($File_o.name;(PositionR("/";$File_o.name)+1))
