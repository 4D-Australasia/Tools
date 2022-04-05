// ----------------------------------------------------
// Project Method: ZNA_WriteDocumentation {(Method Name or prefix; Write Tooltip; Exclude Private Methods)}

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
//   $3 : Boolean : Exclude Private methods

// Created by Wayne Stewart
// Mod by Wayne Stewart, (2021-08-11) - Tooltip will now show the parameters
// ----------------------------------------------------

C_TEXT($1)
C_BOOLEAN($2)

If (False)
	C_TEXT(ZNA_WriteDocumentation;$1)
	C_BOOLEAN(ZNA_WriteDocumentation;$2;$3)
End if 


C_TEXT($Attributes_t;$callSyntax_t;$CR;$FirstChars_t;$lastChar_t;$MethodCode_t;$MethodName_t;\
$nextline_t;$parameterBlock_t;$parameterline_t;\
$processName_t;$Space;$callSyntaxParameters_t;$documentationPath_t)
C_BOOLEAN($ToolTip_b;$excludePrivate_b)
C_LONGINT($CurrentMethod_i;$line_i;$lineEnd_i;$nextLine_i;$numberofLines_i;$NumberOfMethods_i;\
$parameterBlock_i;$Position_i;$ProcessID_i;$returns_i;$StackSize_i)
C_OBJECT($Attributes_o)

ARRAY TEXT($MethodCode_at;0)
ARRAY TEXT($methodLines_at;0)
ARRAY TEXT($MethodNames_at;0)

$processName_t:="$WriteDocumentation"
$StackSize_i:=0

If (Current process name=$processName_t)
	
	$CR:=Char(Carriage return)
	$Space:=" "
	
	METHOD GET PATHS(Path project method;$MethodNames_at)
	
	$MethodName_t:=$1
	$ToolTip_b:=$2
	$excludePrivate_b:=$3
	
	If (Length($MethodName_t)>0)  //  A method name or prefix has been specified
		
		$NumberOfMethods_i:=Count in array($MethodNames_at;$MethodName_t)
		
		If ($NumberOfMethods_i=1)  // exactly one match (use this specific method)
			ARRAY TEXT($MethodNames_at;0)  // Empty the array
			APPEND TO ARRAY($MethodNames_at;$MethodName_t)
		Else 
			
			$NumberOfMethods_i:=Size of array($MethodNames_at)
			For ($CurrentMethod_i;$NumberOfMethods_i;1;-1)  // Go Backwards
				If ($MethodNames_at{$CurrentMethod_i}=($MethodName_t+"@"))
				Else 
					DELETE FROM ARRAY($MethodNames_at;$CurrentMethod_i)
				End if 
				
			End for 
			
		End if 
		
	End if 
	
	$NumberOfMethods_i:=Size of array($MethodNames_at)
	
	METHOD GET CODE($MethodNames_at;$MethodCode_at)
	
	ARRAY TEXT($MethodComments_at;$NumberOfMethods_i)
	
	For ($CurrentMethod_i;1;$NumberOfMethods_i)
		
		$MethodName_t:=$MethodNames_at{$CurrentMethod_i}
		
		$MethodCode_t:=$MethodCode_at{$CurrentMethod_i}
		
		TEXT TO ARRAY($MethodCode_t;$methodLines_at;MAXTEXTLENBEFOREV11;"Courier";9)
		
		// Delete the first line of code
		DELETE FROM ARRAY($methodLines_at;1;1)  // attributes line
		$Position_i:=Position("comment added and reserved by 4D.\r";$MethodCode_t)
		$MethodCode_t:=Substring($MethodCode_t;$Position_i+Length("comment added and reserved by 4D.\r"))
		
		// Delete the actual code
		$Position_i:=Position("Created by";$MethodCode_t)
		$MethodCode_t:=Substring($MethodCode_t;1;($Position_i-3))
		$line_i:=Find in array($methodLines_at;"@Created by@")
		If ($line_i>0)
			DELETE FROM ARRAY($methodLines_at;$line_i;MAXTEXTLENBEFOREV11)  // Get rid of the code section
		End if 
		
		// Delete block lines
		$MethodCode_t:=Replace string($MethodCode_t;"  // ----------------------------------------------------\r";"")
		$MethodCode_t:=Replace string($MethodCode_t;"// ----------------------------------------------------\r";"")
		
		// Check for Parameter Block
		$parameterBlock_i:=Position("Parameters:";$MethodCode_t)
		If ($parameterBlock_i>0)
			If (Position("Parameters: None";$MethodCode_t)>0)
				$parameterBlock_i:=0
			End if 
		End if 
		
		// Check for Returns
		$returns_i:=Position("Returns:";$MethodCode_t)
		If ($returns_i>0)
			If (Position("Returns: Nothing";$MethodCode_t)>0)
				$returns_i:=0
			End if 
		End if 
		
		$parameterBlock_t:="Parameters|Type|Description"+$CR+"----------|----|-----------"+$CR
		
		$numberofLines_i:=Size of array($methodLines_at)
		Case of 
			: ($parameterBlock_i>0) & ($returns_i>0)
				$parameterBlock_i:=Find in array($methodLines_at;"@Parameters:@")+1
				$parameterline_t:=$methodLines_at{$parameterBlock_i}
				
				Repeat 
					$parameterline_t:=Replace string($parameterline_t;"//    $";"$")  // Get rid of the spaces before the $
					$parameterline_t:=Replace string($parameterline_t;"//   $";"$")  // Get rid of the spaces before the $
					$parameterline_t:=Replace string($parameterline_t;"//  $";"$")  // Get rid of the spaces before the $
					$parameterline_t:=Replace string($parameterline_t;"// $";"$")  // Get rid of the spaces before the $
					$parameterline_t:=Replace string($parameterline_t;" : ";"|")  // Get rid of the spaces
					
					$parameterBlock_t:=$parameterBlock_t+$parameterline_t+$CR
					
					$parameterBlock_i:=$parameterBlock_i+1
					$parameterline_t:=$methodLines_at{$parameterBlock_i}  // We don't need to compare to end of method as we know there's a return section
				Until ($parameterline_t="@Returns@")
				
			: ($parameterBlock_i>0)
				$parameterBlock_i:=Find in array($methodLines_at;"@Parameters:@")+1
				$parameterline_t:=$methodLines_at{$parameterBlock_i}
				
				Repeat 
					$parameterline_t:=Replace string($parameterline_t;"//    $";"$")  // Get rid of the spaces before the $
					$parameterline_t:=Replace string($parameterline_t;"//   $";"$")  // Get rid of the spaces before the $
					$parameterline_t:=Replace string($parameterline_t;"//  $";"$")  // Get rid of the spaces before the $
					$parameterline_t:=Replace string($parameterline_t;"// $";"$")  // Get rid of the spaces before the $
					$parameterline_t:=Replace string($parameterline_t;" : ";"|")  // Get rid of the spaces
					
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
				 | (($parameterline_t="") & ($nextline_t=""))\
				 | ($parameterline_t="@Returns@")
				
			: ($returns_i>0)
				// Don't do anything yet
				
			Else 
				$parameterBlock_t:=""
				
		End case 
		
		$parameterBlock_t:=Replace string($parameterBlock_t;$CR+$CR;$CR)
		
		If ($returns_i>0)
			$parameterBlock_i:=Find in array($methodLines_at;"@Returns@";$parameterBlock_i)
			
			$parameterline_t:=$methodLines_at{$parameterBlock_i}
			
			Repeat 
				$parameterline_t:=Replace string($parameterline_t;"//    $";"$")  // Get rid of the spaces before the $
				$parameterline_t:=Replace string($parameterline_t;"//   $";"$")  // Get rid of the spaces before the $
				$parameterline_t:=Replace string($parameterline_t;"//  $";"$")  // Get rid of the spaces before the $
				$parameterline_t:=Replace string($parameterline_t;"// $";"$")  // Get rid of the spaces before the $
				$parameterline_t:=Replace string($parameterline_t;" : ";"|")  // Get rid of the spaces
				
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
			
			
		End if 
		
		$parameterBlock_t:=Replace string($parameterBlock_t;$CR+$CR;$CR)  // Get rid of any blank lines
		
		// Now remove everything below the Parameter Block
		$parameterBlock_i:=Position("// Parameters:";$MethodCode_t)
		$returns_i:=Position("// Returns:";$MethodCode_t)
		
		If ($parameterBlock_i>0)
			$MethodCode_t:=Substring($MethodCode_t;1;$parameterBlock_i)
		Else 
			If ($returns_i>0)
				$MethodCode_t:=Substring($MethodCode_t;1;$returns_i)
			End if 
		End if 
		
		//  Threadsafe?
		METHOD GET ATTRIBUTES($MethodName_t;$Attributes_o)
		
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
		
		If (Length($Attributes_t)>1)
			$Attributes_t:=Substring($Attributes_t;1;Length($Attributes_t)-2)+$CR+$CR
		End if 
		
		$Position_i:=Position("Project Method: ";$MethodCode_t)
		$Position_i:=$Position_i+15  // length("Project Method:")
		$LineEnd_i:=Position($CR;$MethodCode_t;$Position_i)
		
		$callSyntax_t:=Substring($MethodCode_t;$Position_i;$LineEnd_i-$Position_i)
		
		While (Substring($callSyntax_t;1;1)=$Space)  //  Get rid of a variable number of spaces
			$callSyntax_t:=Substring($callSyntax_t;2)
		End while 
		
		$callSyntax_t:=Replace string($callSyntax_t;"-->";"->")  // --> is a symbol used in MD
		
		$callSyntaxParameters_t:=$parameterBlock_t
		
		$callSyntaxParameters_t:=Replace string($callSyntaxParameters_t;"----------|----|-----------";"")
		$callSyntaxParameters_t:=Replace string($callSyntaxParameters_t;"|";" : ")
		//$callSyntaxParameters_t:=Replace string($callSyntaxParameters_t;"\r";$CR)
		
		$callSyntax_t:=$callSyntax_t+$CR+$callSyntaxParameters_t
		
		$callSyntax_t:=Replace string($callSyntax_t;"Parameters : Type : Description";"")
		$callSyntax_t:=Replace string($callSyntax_t;"// Returns:";"")
		$callSyntax_t:=Replace string($callSyntax_t;$CR+$CR;$CR)
		$callSyntax_t:=Substring($callSyntax_t;1;Length($callSyntax_t)-1)
		
		$FirstChars_t:=Substring($callSyntax_t;1;1)
		While ($FirstChars_t=" ")
			$callSyntax_t:=Substring($callSyntax_t;2)
			$FirstChars_t:=Substring($callSyntax_t;1;1)
		End while 
		
		$MethodCode_t:=Replace string($MethodCode_t;"\r// Access: Shared\r";$CR+$Attributes_t)
		$MethodCode_t:=Replace string($MethodCode_t;"\r// Access: Private\r";$CR+$Attributes_t)
		
		//  End Threadsafe section
		
		$MethodCode_t:=Replace string($MethodCode_t;"  // Project Method: ";"")
		$MethodCode_t:=Replace string($MethodCode_t;"// Project Method: ";"")
		
		$MethodCode_t:=Replace string($MethodCode_t;"  // ";"")
		$MethodCode_t:=Replace string($MethodCode_t;"// ";"")
		
		// This will make certain that hard returns in the comments section will be carried into the MD format
		$MethodCode_t:=Replace string($MethodCode_t;"\r\r";"slartibartfast123456-Ford-Prefect")
		$MethodCode_t:=Replace string($MethodCode_t;"\r";"<br>")
		$MethodCode_t:=Replace string($MethodCode_t;"slartibartfast123456-Ford-Prefect";"\r\r")
		
		$MethodCode_t:=$MethodCode_t+$CR+$parameterBlock_t
		
		$FirstChars_t:=Substring($MethodCode_t;1;2)
		While ($FirstChars_t="\r\r")
			$MethodCode_t:=Substring($MethodCode_t;2)
			$FirstChars_t:=Substring($MethodCode_t;1;2)
		End while 
		
		$lastChar_t:=Substring($MethodCode_t;Length($MethodCode_t);1)
		While ($lastChar_t=$CR)\
			 | ($lastChar_t=$Space)
			$MethodCode_t:=Substring($MethodCode_t;1;Length($MethodCode_t)-1)
			$lastChar_t:=Substring($MethodCode_t;Length($MethodCode_t);1)
		End while 
		
		$MethodCode_t:=Replace string($MethodCode_t;"Returns:";"**Returns**")
		
		$MethodCode_t:="<!--"+$callSyntax_t+"-->"+$CR+"## "+$MethodName_t+$CR+$MethodCode_t
		
		$MethodCode_t:=Replace string($MethodCode_t;$CR+"//";$CR)
		$MethodCode_t:=Replace string($MethodCode_t;$CR+"/";$CR)
		
		If ($excludePrivate_b) & (Not($Attributes_o.shared))
			$MethodCode_t:=""  // Clear all that work we just did!
		End if 
		
		
		$MethodComments_at{$CurrentMethod_i}:=$MethodCode_t
		
	End for 
	
	$NumberOfMethods_i:=Size of array($MethodComments_at)
	For ($CurrentMethod_i;$NumberOfMethods_i;1;-1)  // Go Backwards
		If (Length($MethodComments_at{$CurrentMethod_i})>0)
		Else 
			DELETE FROM ARRAY($MethodNames_at;$CurrentMethod_i)
			DELETE FROM ARRAY($MethodComments_at;$CurrentMethod_i)
		End if 
		
	End for 
	
	METHOD SET COMMENTS($MethodNames_at;$MethodComments_at)
	
	//ALERT("Finished")
	
Else 
	
	$MethodName_t:=""
	$ToolTip_b:=True
	$excludePrivate_b:=False
	
	Case of 
		: (Count parameters=1)
			$MethodName_t:=$1
			
		: (Count parameters=2)
			$MethodName_t:=$1
			$ToolTip_b:=$2
			
		: (Count parameters=3)
			$MethodName_t:=$1
			$ToolTip_b:=$2
			$excludePrivate_b:=$3
			
	End case 
	
	If ($excludePrivate_b)  // Delete the existing documentation folder
		$documentationPath_t:=Get 4D folder(Database folder)+"Documentation"+Folder separator+"Methods"+Folder separator
		If (Test path name($documentationPath_t)=Is a folder)
			DELETE FOLDER($documentationPath_t;Delete with contents)
		End if 
		CREATE FOLDER($documentationPath_t)
	End if 
	
	
	// This version allows for any number of processes
	// $ProcessID_i:=New Process(Current method name;$StackSize_i;Current method name;0)
	
	// On the other hand, this version allows for one unique process
	$ProcessID_i:=New process(Current method name;$StackSize_i;$processName_t;$MethodName_t;$ToolTip_b;$excludePrivate_b;*)
	
	RESUME PROCESS($ProcessID_i)
	SHOW PROCESS($ProcessID_i)
	BRING TO FRONT($ProcessID_i)
End if 
