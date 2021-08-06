//%attributes = {"invisible":true,"shared":true}
// ----------------------------------------------------
// Project Method: BUG ALERT (Bug Details in Object or Method with error {; More Details {; Line number {; Display Alert}}})

// Use this method to report on an unexpected event in your code
//  (Missing parameter etc) 
//  You may either
//  1. Pass four simple parameters - Method Name, Error Description, Line number, and Display Alert
//  OR
//  2. Pass an object with those parameters embedded

// A planned enhancement but not written yet would be to log the error

// Access: Shared

// Parameters: 
//   $1 : Variant : Text (The method with the error) or Object
//   $1.methodName : Text : The method with the error
//   $1.errorDetails : Text : A description of the error
//   $1.lineNumber : Number : The line number
//   $1.displayAlert : Boolean : Display alert
//   $1.logError : Object : Not implemented

//   $2 : Text : A description of the error (optional)
//   $3 : Longint : Line Number (optional)
//   $4 : Boolean : Display Alert (optional)

// Created by Wayne Stewart (2021-08-05T14:00:00Z)

//     wayne@4dsupport.guru
// ----------------------------------------------------

If (False:C215)
	C_VARIANT:C1683(BUG ALERT;$1)
	C_TEXT:C284(BUG ALERT;$2)
	C_LONGINT:C283(BUG ALERT;$3)
	C_BOOLEAN:C305(BUG ALERT;$4)
End if 

C_TEXT:C284($lineNumber_t;$details_t;$errorMethod_t;$Alert_t)
C_BOOLEAN:C305($displayAlert_b)

$displayAlert_b:=True:C214

Case of 
	: (Count parameters:C259=4)
		$displayAlert_b:=$4
		$lineNumber_t:=String:C10($3)
		$details_t:=$2
		$errorMethod_t:=$1
		
	: (Count parameters:C259=3)
		$lineNumber_t:=String:C10($3)
		$details_t:=$2
		$errorMethod_t:=$1
		
	: (Count parameters:C259=2)  // This is probably the most often called version
		$details_t:=$2
		$errorMethod_t:=$1
		
	: (Value type:C1509($1)=Is text:K8:3)
		$errorMethod_t:=$1
		
	: (Value type:C1509($1)=Is object:K8:27)
		$errorMethod_t:=$1.methodName
		$details_t:=$1.errorDetails
		If ($1.lineNumber#Null:C1517)
			$lineNumber_t:=String:C10($1.lineNumber)
		End if 
		
End case 

$Alert_t:="ERROR IN METHOD: "+$errorMethod_t
If (Length:C16($lineNumber_t)#0)
	$Alert_t:=$Alert_t+Char:C90(13)+"Line: "+$lineNumber_t
End if 

If (Length:C16($details_t)#0)
	$Alert_t:=$Alert_t+Char:C90(13)+"Description: "+$details_t
End if 

If ($displayAlert_b)
	ALERT:C41($Alert_t)
End if 

// You may want to comment out this
TRACE:C157

