#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.12.0
 Author:         DevonWC
 Version:        0.3b

 Script Function:
	Always running checker for network availability and network stabilizer.

#ce ----------------------------------------------------------------------------

#pragma compile(FileVersion, 0.5.2.2, 0.5.2.2)
#include <File.au3>

;Configurations
Local $hFile = FileOpen(@ScriptDir & "\data.log", 1)
Local $warnings[2] = ["Network instability detected! restarting...", "Network Sucessfully Restarted!"]
Local $var[5] = ["google.com"]
;End Configurations


;This sets up the connection to be checked every T minutes, just multiply the number of seconds by 1000(ms)
Adlibregister("Stabilize", 15000)

;Loop to keep program running
While 1
    Sleep(250)
 Wend
 
 

Func checkPing($times, $address)

Local $netCounter = 0 ;counter the amount of ping errors.

For $i = 1 To $times Step 1
$var2 = Ping($address,500) ;call for ping
   If @error Then ;add value to counter if host doesn't respond
	  $netCounter = $netCounter + 1
   Else
	  ExitLoop
	  $netCounter = 0 ;restarts counter if host responds
   EndIf
Next

   Return $netCounter ;function returns counter

EndFunc

Func Stabilize()
$varp = checkPing(5, $var[0])
If $varp > 4 Then;Check for third ping on google.com, security layer 4
   MsgBox(64, "Network", $warnings[0], 2)
   _FileWriteLog($hFile, $warnings[0]) ;
   RunWait(@SystemDir & '\netsh interface set interface name="Local Area Connection" admin=DISABLED') ;DISABLES THE CONNECTION
   Sleep(2000)
   RunWait(@SystemDir & '\netsh.exe interface set interface name="Local Area Connection" admin=ENABLED') ;ENABLES THE CONNECTION
   MsgBox(64, "Network", $warnings[1], 2)
   _FileWriteLog($hFile, $warnings[1])

	  Else
		 ;MsgBox(64, "Network", "Connection Stable.", 1)
		 ;Use if needed to add comentary if connection is stable.
Endif

EndFunc
