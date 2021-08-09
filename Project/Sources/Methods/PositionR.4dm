//%attributes = {}
// ----------------------------------------------------
// Project Method: PositionR --> ReturnType

// Just like 4D's Position function, but work backwards.

// Access Type: Shared

// Parameters: 
//   $1 : Text : The string
//   $2 : Text : What to find

// Returns: 
//   $0 : Longint : The position of the first character

// Created by Wayne Stewart (2021-08-09)
//     wayne@4dsupport.guru
// ----------------------------------------------------

C_LONGINT:C283($0;$posLast_i;$posNext_i)
C_TEXT:C284($1;$2;$find_t;$string_t;$marker_t)

$find_t:=$1
$string_t:=$2

$marker_t:=Char:C90(1)*Length:C16($find_t)
If ($find_t=$marker_t)
	$marker_t:=Char:C90(2)*Length:C16($find_t)
End if 

$posLast_i:=0
Repeat 
	$posNext_i:=Position:C15($find_t;$string_t)
	If ($posNext_i>0)
		$posLast_i:=$posNext_i
		$string_t:=Replace string:C233($string_t;$find_t;$marker_t;1)
	End if 
Until ($posNext_i=0)

$0:=$posLast_i