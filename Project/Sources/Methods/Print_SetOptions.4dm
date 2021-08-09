//%attributes = {"invisible":true,"shared":true}
// ----------------------------------------------------
// Project Method: Print_SetOptions (object)

// Description

// Access: Shared

// Parameters: 
//   $1.paperSize : Text : Page Size
//   $1.paperOrientation : Integer : 1 = Portrait, 2 = Landscape

// Created by Wayne Stewart (2021-05-02T14:00:00Z)

//     wayne@4dsupport.guru
// ----------------------------------------------------

If (False:C215)
	C_OBJECT:C1216(Print_SetOptions;$1)
End if 

var $1;$parameters_o : Object
var $paper_i : Integer
ARRAY TEXT:C222($Names_at;0)

If (Count parameters:C259=1)
	$parameters_o:=$1
	If ($parameters_o.paperSize=Null:C1517)
		$parameters_o.paperSize:="A4"
	End if 
	If ($parameters_o.paperOrientation=Null:C1517)
		$parameters_o.paperOrientation:="1"
	End if 
	
Else 
	$parameters_o:=New object:C1471("paperSize";"A4";"paperOrientation";1)
End if 

PRINT OPTION VALUES:C785(Paper option:K47:1;$Names_at)  //; $Info_1_ai; $info_2_ai)
C_LONGINT:C283($paper_i)

$paper_i:=Find in array:C230($Names_at;$parameters_o.paperSize)
If ($paper_i>-1)
	SET PRINT OPTION:C733(Paper option:K47:1;$Names_at{$paper_i})
End if 

SET PRINT OPTION:C733(Orientation option:K47:2;$parameters_o.paperOrientation)  // 1 = Portrait, 2 = Landscape

SET PRINT OPTION:C733(Number of copies option:K47:4;1)
