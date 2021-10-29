//%attributes = {"invisible":true,"shared":true}

// ----------------------------------------------------
// Project Method: WRITE DOCUMENTATION {(Method Name or prefix; Write Tooltip)}

// This method will create documentation comments
//   it is based on the assumption that you format your
//   method header comments in the same manner as Foundation
// The first parameter:
//       (a) "" - All methods (or don't pass any parameters)
//       (b) "Prefix" - Only methods which match a prefix (Eg. Fnd_Art)
//       (c) "Specific method name" - write comments for that method
//  The second parameter - True: generate a tooltip

// Access: Shared

// Parameters:
//   $1 : Text : Method Name, Prefix of empty (all methods)
//   $2 : Boolean : Write in the summary section (for the Tooltip)

// Created by Wayne Stewart
// ----------------------------------------------------

C_TEXT:C284($1)
C_BOOLEAN:C305($2)

If (False:C215)
	C_TEXT:C284(ZNA_WriteDocumentation;$1)
	C_BOOLEAN:C305(ZNA_WriteDocumentation;$2)
End if 


C_TEXT:C284($Attributes_t;$callSyntax_t;$CR;$FirstChars_t;$lastChar_t;$MethodCode_t;$MethodName_t;\
$nextline_t;$parameterBlock_t;$parameterline_t;\
$processName_t;$Space)
C_BOOLEAN:C305($ToolTip_b)
C_LONGINT:C283($CurrentMethod_i;$line_i;$lineEnd_i;$nextLine_i;$numberofLines_i;$NumberOfMethods_i;\
$parameterBlock_i;$Position_i;$ProcessID_i;$returns_i;$StackSize_i)
C_OBJECT:C1216($Attributes_o)

ARRAY TEXT:C222($MethodCode_at;0)
ARRAY TEXT:C222($methodLines_at;0)
ARRAY TEXT:C222($MethodNames_at;0)

$processName_t:="$WriteDocumentation"
$StackSize_i:=0

If (Current process name:C1392=$processName_t)
	
	$CR:=Char:C90(Carriage return:K15:38)
	$Space:=" "
	
	METHOD GET PATHS:C1163(Path project method:K72:1;$MethodNames_at)
	
	$MethodName_t:=$1
	
	If (Length:C16($MethodName_t)>0)  //  A method name or prefix has been specified
		
		$NumberOfMethods_i:=Count in array:C907($MethodNames_at;$MethodName_t)
		
		If ($NumberOfMethods_i=1)  // exactly one match (use this specific method)
			ARRAY TEXT:C222($MethodNames_at;0)  // Empty the array
			APPEND TO ARRAY:C911($MethodNames_at;$MethodName_t)
		Else 
			
			$NumberOfMethods_i:=Size of array:C274($MethodNames_at)
			For ($CurrentMethod_i;$NumberOfMethods_i;1;-1)  // Go Backwards
				If ($MethodNames_at{$CurrentMethod_i}=($MethodName_t+"@"))
				Else 
					DELETE FROM ARRAY:C228($MethodNames_at;$CurrentMethod_i)
				End if 
				
			End for 
			
		End if 
		
	End if 
	
	$NumberOfMethods_i:=Size of array:C274($MethodNames_at)
	
	METHOD GET CODE:C1190($MethodNames_at;$MethodCode_at)
	
	ARRAY TEXT:C222($MethodComments_at;$NumberOfMethods_i)
	
	For ($CurrentMethod_i;1;$NumberOfMethods_i)
		
		$MethodName_t:=$MethodNames_at{$CurrentMethod_i}
		
		$MethodCode_t:=$MethodCode_at{$CurrentMethod_i}
		
		TEXT TO ARRAY:C1149($MethodCode_t;$methodLines_at;MAXTEXTLENBEFOREV11:K35:3;"Courier";9)
		
		// Delete the first line of code
		DELETE FROM ARRAY:C228($methodLines_at;1;1)  // attributes line
		$Position_i:=Position:C15("comment added and reserved by 4D.\r";$MethodCode_t)
		$MethodCode_t:=Substring:C12($MethodCode_t;$Position_i+Length:C16("comment added and reserved by 4D.\r"))
		
		// Delete the actual code
		$Position_i:=Position:C15("Created by";$MethodCode_t)
		$MethodCode_t:=Substring:C12($MethodCode_t;1;($Position_i-3))
		$line_i:=Find in array:C230($methodLines_at;"@Created by@")
		If ($line_i>0)
			DELETE FROM ARRAY:C228($methodLines_at;$line_i;MAXTEXTLENBEFOREV11:K35:3)  // Get rid of the code section
		End if 
		
		// Delete block lines
		$MethodCode_t:=Replace string:C233($MethodCode_t;"  // ----------------------------------------------------\r";"")
		$MethodCode_t:=Replace string:C233($MethodCode_t;"// ----------------------------------------------------\r";"")
		
		// Check for Parameter Block
		$parameterBlock_i:=Position:C15("Parameters:";$MethodCode_t)
		If ($parameterBlock_i>0)
			If (Position:C15("Parameters: None";$MethodCode_t)>0)
				$parameterBlock_i:=0
			End if 
		End if 
		
		// Check for Returns
		$returns_i:=Position:C15("Returns:";$MethodCode_t)
		If ($returns_i>0)
			If (Position:C15("Returns: Nothing";$MethodCode_t)>0)
				$returns_i:=0
			End if 
		End if 
		
		$parameterBlock_t:="Parameters|Type|Description"+$CR+"----------|----|-----------"+$CR
		
		$numberofLines_i:=Size of array:C274($methodLines_at)
		Case of 
			: ($parameterBlock_i>0) & ($returns_i>0)
				$parameterBlock_i:=Find in array:C230($methodLines_at;"@Parameters:@")+1
				$parameterline_t:=$methodLines_at{$parameterBlock_i}
				
				Repeat 
					$parameterline_t:=Replace string:C233($parameterline_t;"//    $";"$")  // Get rid of the spaces before the $
					$parameterline_t:=Replace string:C233($parameterline_t;"//   $";"$")  // Get rid of the spaces before the $
					$parameterline_t:=Replace string:C233($parameterline_t;"//  $";"$")  // Get rid of the spaces before the $
					$parameterline_t:=Replace string:C233($parameterline_t;"// $";"$")  // Get rid of the spaces before the $
					$parameterline_t:=Replace string:C233($parameterline_t;" : ";"|")  // Get rid of the spaces
					
					$parameterBlock_t:=$parameterBlock_t+$parameterline_t+$CR
					
					$parameterBlock_i:=$parameterBlock_i+1
					$parameterline_t:=$methodLines_at{$parameterBlock_i}  // We don't need to compare to end of method as we know there's a return section
				Until ($parameterline_t="@Returns@")
				
			: ($parameterBlock_i>0)
				$parameterBlock_i:=Find in array:C230($methodLines_at;"@Parameters:@")+1
				$parameterline_t:=$methodLines_at{$parameterBlock_i}
				
				Repeat 
					$parameterline_t:=Replace string:C233($parameterline_t;"//    $";"$")  // Get rid of the spaces before the $
					$parameterline_t:=Replace string:C233($parameterline_t;"//   $";"$")  // Get rid of the spaces before the $
					$parameterline_t:=Replace string:C233($parameterline_t;"//  $";"$")  // Get rid of the spaces before the $
					$parameterline_t:=Replace string:C233($parameterline_t;"// $";"$")  // Get rid of the spaces before the $
					$parameterline_t:=Replace string:C233($parameterline_t;" : ";"|")  // Get rid of the spaces
					
					$parameterBlock_t:=$parameterBlock_t+$parameterline_t+$CR
					$parameterBlock_i:=$parameterBlock_i+1
					
					// This has a more complicated end condition because we may get an out of range error
					If ($parameterBlock_i<=$numberofLines_i)
						$parameterline_t:=$methodLines_at{$parameterBlock_i}
					Else 
						$parameterline_t:=""
					End if 
					
					$nextLine_i:=$parameterBlock_i+1
					If ($nextLine_i<=$numberofLines_i)
						$nextline_t:=$methodLines_at{$nextLine_i}
					Else 
						$nextline_t:=""
					End if 
					
/* Exit loop if
1. Run out of lines
2. Two blank lines in a row
3. Hmmm…
*/
				Until ($parameterBlock_i>$numberofLines_i)\
					 | (($parameterline_t="") & ($nextline_t=""))
				
				
			: ($returns_i>0)
				// Don't do anything yet
				
			Else 
				$parameterBlock_t:=""
				
		End case 
		
		$parameterBlock_t:=Replace string:C233($parameterBlock_t;$CR+$CR;$CR)
		
		If ($returns_i>0)
			$parameterline_t:=$methodLines_at{$parameterBlock_i}
			
			Repeat 
				$parameterline_t:=Replace string:C233($parameterline_t;"//    $";"$")  // Get rid of the spaces before the $
				$parameterline_t:=Replace string:C233($parameterline_t;"//   $";"$")  // Get rid of the spaces before the $
				$parameterline_t:=Replace string:C233($parameterline_t;"//  $";"$")  // Get rid of the spaces before the $
				$parameterline_t:=Replace string:C233($parameterline_t;"// $";"$")  // Get rid of the spaces before the $
				$parameterline_t:=Replace string:C233($parameterline_t;" : ";"|")  // Get rid of the spaces
				
				$parameterBlock_t:=$parameterBlock_t+$parameterline_t+$CR
				$parameterBlock_i:=$parameterBlock_i+1
				
				// This has a more complicated end condition because we may get an out of range error
				If ($parameterBlock_i<=$numberofLines_i)
					$parameterline_t:=$methodLines_at{$parameterBlock_i}
				Else 
					$parameterline_t:=""
				End if 
				
				$nextLine_i:=$parameterBlock_i+1
				If ($nextLine_i<=$numberofLines_i)
					$nextline_t:=$methodLines_at{$nextLine_i}
				Else 
					$nextline_t:=""
				End if 
				
/* Exit loop if
1. Run out of lines
2. Two blank lines in a row
3. Hmmm…
*/
			Until ($parameterBlock_i>$numberofLines_i)\
				 | (($parameterline_t="") & ($nextline_t=""))
			
			//$parameterBlock_i:=Find in array($methodLines_at; "@Returns@")+1
			//$parameterline_t:=$methodLines_at{$parameterBlock_i}
			//$parameterline_t:=Replace string($parameterline_t; "//    $"; "$")  // Get rid of the spaces before the $
			//$parameterline_t:=Replace string($parameterline_t; "//   $"; "$")  // Get rid of the spaces before the $
			//$parameterline_t:=Replace string($parameterline_t; "//  $"; "$")  // Get rid of the spaces before the $
			//$parameterline_t:=Replace string($parameterline_t; "// $"; "$")  // Get rid of the spaces before the $
			//$parameterline_t:=Replace string($parameterline_t; " : "; "|")  // Get rid of the spaces
			//$parameterBlock_t:=$parameterBlock_t+$parameterline_t+$CR
		End if 
		
		$parameterBlock_t:=Replace string:C233($parameterBlock_t;$CR+$CR;$CR)  // Get rid of any blank lines
		
		// Now remove everything below the Parameter Block
		$parameterBlock_i:=Position:C15("// Parameters:";$MethodCode_t)
		$returns_i:=Position:C15("// Returns:";$MethodCode_t)
		
		If ($parameterBlock_i>0)
			$MethodCode_t:=Substring:C12($MethodCode_t;1;$parameterBlock_i)
		Else 
			If ($returns_i>0)
				$MethodCode_t:=Substring:C12($MethodCode_t;1;$returns_i)
			End if 
		End if 
		
		//  Threadsafe?
		METHOD GET ATTRIBUTES:C1334($MethodName_t;$Attributes_o)
		
		$Attributes_t:="Attributes: "
		
		If ($Attributes_o.shared)
			$Attributes_t:=$Attributes_t+"Shared, "
		End if 
		
		If ($Attributes_o.executedOnServer)
			$Attributes_t:=$Attributes_t+"Server, "
		End if 
		
		If ($Attributes_o.invisible)
			$Attributes_t:=$Attributes_t+"Invisible, "
		End if 
		
/* Compatibility note: The published4DMobile property is deprecated as for 4D v18.
If ($Attributes_o.published4DMobile#Null)
$Attributes_t:=$Attributes_t+"4D Mobile, "
End if
*/
		
		Case of 
			: ($Attributes_o.preemptive="capable")
				$Attributes_t:=$Attributes_t+"Preemptive capable, "
				
			: ($Attributes_o.preemptive="incapable")
				$Attributes_t:=$Attributes_t+"Preemptive incapable, "
				
			: ($Attributes_o.preemptive="indifferent")
				$Attributes_t:=$Attributes_t+"Preemptive indifferent, "
				
		End case 
		
		If ($Attributes_o.publishedSoap)
			$Attributes_t:=$Attributes_t+"Soap, "
		End if 
		
		If ($Attributes_o.publishedSql)
			$Attributes_t:=$Attributes_t+"SQL, "
		End if 
		
		If ($Attributes_o.publishedWeb)
			$Attributes_t:=$Attributes_t+"Web, "
		End if 
		
		If ($Attributes_o.publishedWsdl)
			$Attributes_t:=$Attributes_t+"WSDL, "
		End if 
		
		If (Length:C16($Attributes_t)>1)
			$Attributes_t:=Substring:C12($Attributes_t;1;Length:C16($Attributes_t)-2)+$CR+$CR
		End if 
		
		$Position_i:=Position:C15("Project Method: ";$MethodCode_t)
		$Position_i:=$Position_i+15  // length("Project Method:")
		$LineEnd_i:=Position:C15($CR;$MethodCode_t;$Position_i)
		
		$callSyntax_t:=Substring:C12($MethodCode_t;$Position_i;$LineEnd_i-$Position_i)
		
		While (Substring:C12($callSyntax_t;1;1)=$Space)  //  Get rid of a variable number of spaces
			$callSyntax_t:=Substring:C12($callSyntax_t;2)
		End while 
		
		$callSyntax_t:=Replace string:C233($callSyntax_t;"-->";"->")  // --> is a symbol used in MD
		
		$MethodCode_t:=Replace string:C233($MethodCode_t;"\r// Access: Shared\r";$CR+$Attributes_t)
		$MethodCode_t:=Replace string:C233($MethodCode_t;"\r// Access: Private\r";$CR+$Attributes_t)
		
		//  End Threadsafe section
		
		$MethodCode_t:=Replace string:C233($MethodCode_t;"  // Project Method: ";"")
		$MethodCode_t:=Replace string:C233($MethodCode_t;"// Project Method: ";"")
		
		$MethodCode_t:=Replace string:C233($MethodCode_t;"  // ";"")
		$MethodCode_t:=Replace string:C233($MethodCode_t;"// ";"")
		
		//  Now we need to match the carriage returns that the designer has added to their comments
		
		TEXT TO ARRAY:C1149($MethodCode_t;$methodLines_at;MAXTEXTLENBEFOREV11:K35:3;"Courier";9)
		
		$MethodCode_t:=""
		
		$numberofLines_i:=Size of array:C274($methodLines_at)
		
		For ($line_i;1;$numberofLines_i)
			$MethodCode_t:=$MethodCode_t+$methodLines_at{$line_i}+$CR
		End for 
		
		$MethodCode_t:=$MethodCode_t+$CR+$parameterBlock_t
		
		$FirstChars_t:=Substring:C12($MethodCode_t;1;2)
		While ($FirstChars_t="\r\r")
			$MethodCode_t:=Substring:C12($MethodCode_t;2)
			$FirstChars_t:=Substring:C12($MethodCode_t;1;2)
		End while 
		
		$lastChar_t:=Substring:C12($MethodCode_t;Length:C16($MethodCode_t);1)
		While ($lastChar_t=$CR)\
			 | ($lastChar_t=$Space)
			$MethodCode_t:=Substring:C12($MethodCode_t;1;Length:C16($MethodCode_t)-1)
			$lastChar_t:=Substring:C12($MethodCode_t;Length:C16($MethodCode_t);1)
		End while 
		
		$MethodCode_t:="<!-- "+$callSyntax_t+" -->"+$CR+"## "+$MethodName_t+$CR+$MethodCode_t
		
		$MethodCode_t:=Replace string:C233($MethodCode_t;$CR+"//";$CR)
		$MethodCode_t:=Replace string:C233($MethodCode_t;$CR+"/";$CR)
		
		$MethodCode_t:=Replace string:C233($MethodCode_t;"Returns:";"**Returns**")
		$MethodComments_at{$CurrentMethod_i}:=$MethodCode_t
		
	End for 
	
	
	
	METHOD SET COMMENTS:C1193($MethodNames_at;$MethodComments_at)
	
Else 
	
	$MethodName_t:=""
	$ToolTip_b:=True:C214
	
	Case of 
		: (Count parameters:C259=1)
			$MethodName_t:=$1
			
		: (Count parameters:C259=2)
			$MethodName_t:=$1
			$ToolTip_b:=$2
	End case 
	
	// This version allows for any number of processes
	// $ProcessID_i:=New Process(Current method name;$StackSize_i;Current method name;0)
	
	// On the other hand, this version allows for one unique process
	$ProcessID_i:=New process:C317(Current method name:C684;$StackSize_i;$processName_t;$MethodName_t;$ToolTip_b;*)
	
	RESUME PROCESS:C320($ProcessID_i)
	SHOW PROCESS:C325($ProcessID_i)
	BRING TO FRONT:C326($ProcessID_i)
End if 