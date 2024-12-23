version = Arturos PTCGP Bot v2.4
#SingleInstance, force
CoordMode, Mouse, Screen
SetDefaultMouseSpeed, 0

global Instances, adbPorts

; Create the main GUI for selecting number of instances
    IniRead, Name, Settings.ini, UserSettings, Name, Arturo
    IniRead, Delay, Settings.ini, UserSettings, Delay, 250
    IniRead, folderPath, Settings.ini, UserSettings, folderPath, C:\Program Files\Netease
    IniRead, changeDate, Settings.ini, UserSettings, ChangeDate, 0100
    IniRead, Columns, Settings.ini, UserSettings, Columns, 5
    IniRead, openPack, Settings.ini, UserSettings, openPack, Mew
    IniRead, Instances, Settings.ini, UserSettings, Instances, 10
    ; IniRead, defaultLanguage, Settings.ini, UserSettings, defaultLanguage, English
	
yPos := 10
controlHeight := 20  ; Increased control height for better visibility
controlSpacing := 10  ; Increased spacing between controls

; Set starting position for the GUI elements
yInstancesText := yPos
yInstancesEdit := yInstancesText + controlHeight

yPackText := yInstancesEdit + controlHeight + controlSpacing
yPackEdit := yPackText + controlHeight

yDelayText := yPackEdit + controlHeight + controlSpacing
yDelayEdit := yDelayText + controlHeight

yChangeDateText := yDelayEdit + controlHeight + controlSpacing
yChangeDateEdit := yChangeDateText + controlHeight

yNameText := yChangeDateEdit + controlHeight + controlSpacing
yNameEdit := yNameText + controlHeight

yColumnsText := yNameEdit + controlHeight + controlSpacing
yColumnsEdit := yColumnsText + controlHeight

yVariationText := yColumnsEdit + controlHeight + controlSpacing
yVariationEdit := yVariationText + controlHeight

yLangText := yVariationEdit + controlHeight + controlSpacing
yLangEdit := yLangText + controlHeight

yNextPage := yLangEdit + controlHeight + controlSpacing 

Gui, Add, Text, x20 y%yInstancesText%, Instances #:
Gui, Add, Edit, vInstances x60 y%yInstancesEdit% w100, %Instances%

if (openPack = "Mewtwo") {
    defaultPack := 1
} else if (openPack = "Pikachu") {
    defaultPack := 2
} else if (openPack = "Charizard") {
    defaultPack := 3
} else if (openPack = "Mew") {
    defaultPack := 4
}

Gui, Add, Text, x20 y%yPackText%, Pack:
Gui, Add, DropDownList, x60 y%yPackEdit% w100 vopenPack choose%defaultPack%, Mewtwo|Pikachu|Charizard|Mew

Gui, Add, Text, x20 y%yDelayText%, Delay:
Gui, Add, Edit, vDelay x60 y%yDelayEdit% w100, %Delay%

Gui, Add, Text, x20 y%yChangeDateText%, Time Zone:
Gui, Add, Edit, vChangeDate x60 y%yChangeDateEdit% w100, %ChangeDate%

Gui, Add, Text, x20 y%yNameText%, Name:
Gui, Add, Edit, vName x60 y%yNameEdit% w100, %Name%

Gui, Add, Text, x20 y%yColumnsText%, Instances per row:
Gui, Add, Edit, vColumns x60 y%yColumnsEdit% w100, %Columns%

Gui, Add, Text, x20 y%yVariationText%, Netease Path:
Gui, Add, Edit, vfolderPath x60 y%yVariationEdit% w100, %folderPath%

; if (defaultLanguage = "English") {
    ; defaultLang := 1
; } else if (defaultLanguage = "Korean")
    ; defaultLang := 2

; Gui, Add, Text, x20 y%yLangText%, Pack:
; Gui, Add, DropDownList, x60 y%yLangEdit% w100 vdefaultLanguage choose%defaultLang%, English|Korean

Gui, Add, Button, gStart x60 y%yNextPage% w100 h30, Start
Gui, Show, , Arturos PTCGPB Setup
Return

Start:
Gui, Submit  ; Collect the input values from the first page
Instances := Instances  ; Directly reference the "Instances" variable

; Validate if instances is a valid number
If (Instances < 1) or (Instances > 20)
{
    MsgBox, Please enter a number between 1 and 20.
    Return
}

; Create the second page dynamically based on the number of instances
Gui, Destroy ; Close the first page

findAdbPorts(folderPath)

IniWrite, %Name%, Settings.ini, UserSettings, Name
IniWrite, %Delay%, Settings.ini, UserSettings, Delay
IniWrite, %folderPath%, Settings.ini, UserSettings, folderPath
IniWrite, %ChangeDate%, Settings.ini, UserSettings, ChangeDate
IniWrite, %Columns%, Settings.ini, UserSettings, Columns
IniWrite, %openPack%, Settings.ini, UserSettings, openPack
IniWrite, %Instances%, Settings.ini, UserSettings, Instances
; IniWrite, %defaultLanguage%, Settings.ini, UserSettings, defaultLanguage

; Loop to process each instance
Loop, %Instances%
{
	SourceFile := "Scripts\1.ahk" ; Path to the source .ahk file
	TargetFolder := "Scripts\" ; Path to the target folder
	TargetFile := TargetFolder . "\" . A_Index . ".ahk" ; Generate target file path
	if !FileExist(TargetFile) ; Check if the file doesn't exist
    {
        FileCopy, %SourceFile%, %TargetFile%, 1 ; Copy source file to target
        if (ErrorLevel)
            MsgBox, Failed to create %TargetFile%. Ensure permissions and paths are correct.
    }
    ; Create a command line to run the pre-existing script and pass the variables
	adbPort := adbPorts[A_Index]
	
    IniWrite, %adbPort%, Settings.ini, UserSettings, adbPort%A_Index%
	
    FileName := "Scripts\"A_Index ".ahk"
    Command := FileName
	
    Run, % Command
}

Gui, Destroy ; Close the second page after starting instances
Return

GuiClose:
ExitApp


findAdbPorts(baseFolder := "C:\Program Files\Netease") {
global adbPorts
; Initialize variables
adbPorts := {}  ; Create an empty associative array for adbPorts
baseFolder = %baseFolder%\MuMuPlayerGlobal-12.0\vms\*
; Loop through all directories in the base folder
Loop, Files, %baseFolder%, D  ; D flag to include directories only
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
            instanceName := playerName1  ; Capture the player name (instance name)
            
            ; Store the adbPort in the object, using instanceName as the key
            adbPorts[instanceName] := adbPort
        }
    }
}

; Example of how to retrieve the adbPort by instanceName
}

~F7::ExitApp
