//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project Method: PICT_Init

// Initialises the Picture routines

// Created by Wayne Stewart (2021-08-23T14:00:00Z)

//     wayne@4dsupport.guru
// ----------------------------------------------------

If (False:C215)
	PICT_Init
End if 

var $Pathway_t;$JSONString_t : Text
var $Count_i;$key_i : Integer
var $Temp_o : Object

ARRAY TEXT:C222($keys_at;0)

If (Storage:C1525.pictureLookup=Null:C1517)  // Only do this once each time you run database
	$Pathway_t:=Get 4D folder:C485(Current resources folder:K5:16)+"Images"+Folder separator:K24:12+"Lookup.json"
	If (Test path name:C476($Pathway_t)=Is a document:K24:1)  // If the lookup file exists
		$JSONString_t:=Document to text:C1236($Pathway_t)
		$Temp_o:=JSON Parse:C1218($JSONString_t)
		OB GET PROPERTY NAMES:C1232($Temp_o;$keys_at)
		$Count_i:=Size of array:C274($keys_at)
		
		Use (Storage:C1525)
			Storage:C1525.pictureLookup:=New shared object:C1526
		End use 
		
		Use (Storage:C1525.pictureLookup)
			For ($key_i;1;$Count_i)
				Storage:C1525.pictureLookup[$keys_at{$key_i}]:=$Temp_o[$keys_at{$key_i}]
			End for 
		End use 
		
	End if 
End if 