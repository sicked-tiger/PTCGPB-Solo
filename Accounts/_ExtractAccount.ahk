#SingleInstance on
;SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
;SetWinDelay, -1
;SetControlDelay, -1
SetBatchLines, -1
SetTitleMatchMode, 3

global adbShell, adbPath, adbPorts, winTitle, folderPath

Gui, Add, Text,, This tool is to EXTRACT the account from the instance.`nMake sure the file name does not match any current account!`nIt will OVERWRITE any file named the same!
Gui, Add, Text,, Instance Name:
Gui, Add, Edit, vwinTitle, %winTitle%
Gui, Add, Text,, File Name (without spaces and without .xml):
Gui, Add, Edit, vfileName, %fileName%
Gui, Add, Text,, MuMu Folder same as main script (C:\Program Files\Netease)
Gui, Add, Edit, vfolderPath, %folderPath%
Gui, Add, Button, gSaveSettings, Submit
Gui, Add, Button, gLoadDefaults, Load Defaults
Gui, Show, , Arturo's Account Extraction Tool ;'
Return

LoadDefaults:
	IniRead, winTitle, ExtractAccount.ini, UserSettings, winTitle, 1
	IniRead, fileName, ExtractAccount.ini, UserSettings, fileName, name
	IniRead, folderPath, ExtractAccount.ini, UserSettings, folderPath, C:\Program Files\Netease
    GuiControl,, winTitle, %winTitle%
    GuiControl,, fileName, %fileName%
    GuiControl,, folderPath, %folderPath%
    MsgBox, Default values loaded!
Return

SaveSettings:
    Gui, Submit, NoHide
	Gui, Destroy
    IniWrite, %winTitle%, ExtractAccount.ini, UserSettings, winTitle
	IniWrite, %fileName%, ExtractAccount.ini, UserSettings, fileName
	IniWrite, %folderPath%, ExtractAccount.ini, UserSettings, folderPath
    MsgBox, Settings submitted! Extracting Account...
	
adbPath := folderPath . "\MuMuPlayerGlobal-12.0\shell\adb.exe"
findAdbPorts(folderPath)

if(!WinExist(winTitle)) {
	Msgbox, Can't find instance: %winTitle% ;'
	ExitApp
}

if !FileExist(adbPath) ;if international mumu file path isn't found look for chinese domestic path
	adbPath := folderPath . "\MuMu Player 12\shell\adb.exe"

if !FileExist(adbPath) {
	MsgBox Double check your folder path! It should be the one that contains the MuMuPlayer 12 folder! `nDefault is just C:\Program Files\Netease
	ExitApp
}

if(!adbPorts) {
	Msgbox, Invalid port... Check the common issues section in the readme/github guide.
	ExitApp
}

RunWait, %adbPath% connect 127.0.0.1:%adbPorts%,, Hide

MaxRetries := 10
	RetryCount := 0
	Loop {
		try {
			if (!adbShell) {
				adbShell := ComObjCreate("WScript.Shell").Exec(adbPath . " -s 127.0.0.1:" . adbPorts . " shell")
				; Extract the Process ID
				processID := adbShell.ProcessID

				; Wait for the console window to open using the process ID
				WinWait, ahk_pid %processID%

				; Minimize the window using the process ID
				WinMinimize, ahk_pid %processID%
				
				adbShell.StdIn.WriteLine("su")
			}
			else if (adbShell.Status != 0) {
				Sleep, 1000
			}
			else {
				Sleep, 1000
				break
			}
		}
		catch {
			RetryCount++
			if(RetryCount > MaxRetries) {
				Pause
			}
		}
		Sleep, 1000
	}
	
	saveAccount()
	
	MsgBox Extracted account xml file from instance named '%winTitle%' and placed it in the Accounts folder as %fileName%.xml	
	
	ExitApp
return
	

findAdbPorts(baseFolder := "C:\Program Files\Netease") {
	global adbPorts, winTitle
	; Initialize variables
	adbPorts := 0  ; Create an empty associative array for adbPorts
	mumuFolder = %baseFolder%\MuMuPlayerGlobal-12.0\vms\*
	if !FileExist(mumuFolder)
		mumuFolder = %baseFolder%\MuMu Player 12\vms\*
		
	if !FileExist(mumuFolder){
		MsgBox Double check your folder path! It should be the one that contains the MuMuPlayer 12 folder! `nDefault is just C:\Program Files\Netease
		ExitApp
	}
	; Loop through all directories in the base folder
	Loop, Files, %mumuFolder%, D  ; D flag to include directories only
	{
		folder := A_LoopFileFullPath
		configFolder := folder "\configs"  ; The config folder inside each directory

		; Check if config folder exists
		IfExist, %configFolder%
		{
			; Define paths to vm_config.json and extra_config.json
			vmConfigFile := configFolder "\vm_config.json"
			extraConfigFile := configFolder "\extra_config.json"
			
			; Check if vm_config.json exists and read adb host port
			IfExist, %vmConfigFile%
			{
				FileRead, vmConfigContent, %vmConfigFile%
				; Parse the JSON for adb host port
				RegExMatch(vmConfigContent, """host_port"":\s*""(\d+)""", adbHostPort)
				adbPort := adbHostPort1  ; Capture the adb host port value
			}
			
			; Check if extra_config.json exists and read playerName
			IfExist, %extraConfigFile%
			{
				FileRead, extraConfigContent, %extraConfigFile%
				; Parse the JSON for playerName
				RegExMatch(extraConfigContent, """playerName"":\s*""(.*?)""", playerName)
				if(playerName1 = winTitle) {
					adbPorts := adbPort
				}
			}
		}
	}
}

saveAccount() {
	global adbShell, adbPath, adbPorts, fileName
	if (!adbShell) {
		adbShell := ComObjCreate("WScript.Shell").Exec(adbPath . " -s 127.0.0.1:" . adbPorts . " shell")
		; Extract the Process ID
		processID := adbShell.ProcessID

		; Wait for the console window to open using the process ID
		WinWait, ahk_pid %processID%

		; Minimize the window using the process ID
		WinMinimize, ahk_pid %processID%
	}
	
	saveDir := A_ScriptDir "\" . fileName
	
	adbShell.StdIn.WriteLine("cp /data/data/jp.pokemon.pokemontcgp/shared_prefs/deviceAccount:.xml /sdcard/deviceAccount.xml")
	
	RunWait, % adbPath . " -s 127.0.0.1:" . adbPorts . " pull /sdcard/deviceAccount.xml """ . saveDir . ".xml""",, Hide
	
	adbShell.StdIn.WriteLine("rm /sdcard/deviceAccount.xml")
}
