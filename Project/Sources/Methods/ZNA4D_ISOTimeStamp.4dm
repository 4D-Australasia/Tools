//%attributes = {"invisible":true}
// ----------------------------------------------------
// Project Method: ZNA4D_ISOTimeStamp (date{; time}) --> Text

// Returns an ISO 8601 formatted date or date-time value.
// If only a date is supplied, a calendar date is returned: YYYY-MM-DD
// If both date and time are supplied, a date-time value is returned: YYYY-MM-DDThh:mm:ss
// If both are passed but the date is !00/00/00! then only the time is returned: hh:mm:ss

// For more information:
//   <http://www.iso.org/iso/en/prods-services/popstds/datesandtime.html>

// Access: Shared

// Parameters: 
//   $1 : Date : A date
//   $2 : Time : A time (optional)

// Returns: 
//   $0 : Text : The date-time stamp

// ----------------------------------------------------

C_TEXT:C284($0;$dateTimeStamp_t)
C_DATE:C307($1;$date_d)
C_TIME:C306($2)
C_TEXT:C284($time_t;$hours_t;$minutes_t;$seconds_t)

Case of 
	: (Count parameters:C259=0)
		$date_d:=Current date:C33
		$Now_h:=Current time:C178
		
	: (Count parameters:C259=1)
		$date_d:=$1
		$Now_h:=Current time:C178
		
	: (Count parameters:C259=2)
		$date_d:=$1
		$Now_h:=$2
		
End case 

$date_d:=$1

$dateTimeStamp_t:=String:C10(Year of:C25($date_d);"0000")
$dateTimeStamp_t:=$dateTimeStamp_t+"-"+String:C10(Month of:C24($date_d);"00")  //month
$dateTimeStamp_t:=$dateTimeStamp_t+"-"+String:C10(Day of:C23($date_d);"00")  //day

If (Count parameters:C259#1)  // 0 or 2 parameters
	If ($date_d=!00-00-00!)
		$dateTimeStamp_t:=""
	Else 
		$dateTimeStamp_t:=$dateTimeStamp_t+"T"
	End if 
	
	$time_t:=String:C10($Now_h;HH MM SS:K7:1)  // $Now_h will be set regardless
	$hours_t:=Substring:C12($time_t;1;2)
	$minutes_t:=Substring:C12($time_t;4;2)
	$seconds_t:=Substring:C12($time_t;7;2)
	$dateTimeStamp_t:=$dateTimeStamp_t+$hours_t+":"+$minutes_t+":"+$seconds_t
End if 


$0:=$dateTimeStamp_t