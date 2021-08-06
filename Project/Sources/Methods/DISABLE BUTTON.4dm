//%attributes = {"invisible":true,"shared":true}
// ----------------------------------------------------
// Project Method: DISABLE BUTTON (Button Name or Pointer)

// Replacement of old 4D DISABLE BUTTON command

// Parameters: 
//   $1 : Variant : This will accept a string or a pointer to a form variable

// Created by Wayne Stewart (2021-04-22T14:00:00Z)

//     wayne@4dsupport.guru
// ----------------------------------------------------
If (False:C215)
	C_VARIANT:C1683(DISABLE BUTTON;$1)
End if 

/*  USAGE NOTES

_O_DISABLE BUTTON(MyButton_i)
_O_DISABLE BUTTON(*;"OK Button")

To implement convert to v13 plus
Create this method and then do a global find and replace on the following:

Search for (do this search first):
_O_DISABLE BUTTON(*;
Replace with:
DISABLE BUTTON(

Then search for:
_O_DISABLE BUTTON(
Replace with:
DISABLE BUTTON(->

If using BBEdit or some other text editor to do the find and replace outside of 4D
you can use the follwoing search patterns:

_O_DISABLE BUTTON:C193(*;
_O_DISABLE BUTTON:C193(

The text substitution is the same.

*/


C_VARIANT:C1683($1)  // The button
C_LONGINT:C283($Type_i)
$Type_i:=Value type:C1509($1)

Case of 
	: ($Type_i=Is text:K8:3)
		OBJECT SET ENABLED:C1123(*;$1;False:C215)
		
	: ($Type_i=Is pointer:K8:14)
		OBJECT SET ENABLED:C1123($1->;False:C215)
		
	Else 
		BUG ALERT(Current method name:C684;"Unexpected parameter type: "+String:C10($Type_i);58)
		
End case 

