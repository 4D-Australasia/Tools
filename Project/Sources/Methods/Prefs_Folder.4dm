//%attributes = {}
// ----------------------------------------------------
// Project Method: Prefs_Folder --> Text

// Returns the location where prefs ae store in the local file system (external to 4D)

// Access: Shared

// Returns: 
//   $0 : Text : Path to folder

// Created by Wayne Stewart (2021-08-08T14:00:00Z)
//     wayne@4dsupport.guru
// ----------------------------------------------------


$0:=Get 4D folder:C485(Active 4D Folder:K5:10)+File_Name(Structure file:C489(*))+Folder separator:K24:12