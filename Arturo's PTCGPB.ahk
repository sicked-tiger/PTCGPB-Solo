version = Arturos PTCGP Bot
#SingleInstance, force
CoordMode, Mouse, Screen
SetTitleMatchMode, 3

global Instances, adbPorts, jsonFileName, PacksText

totalFile := A_ScriptDir . "\json\total.json"
totalContent := "{""total_sum"": " sum "}"
FileDelete, %totalFile%
InitializeJsonFile() ; Create or open the JSON file

; Create the main GUI for selecting number of instances
    IniRead, Name, Settings.ini, UserSettings, Name, player1
    IniRead, Delay, Settings.ini, UserSettings, Delay, 250
    IniRead, folderPath, Settings.ini, UserSettings, folderPath, C:\Program Files\Netease
    IniRead, changeDate, Settings.ini, UserSettings, ChangeDate, 0100
    IniRead, Columns, Settings.ini, UserSettings, Columns, 5
    IniRead, openPack, Settings.ini, UserSettings, openPack, Mew
    IniRead, Instances, Settings.ini, UserSettings, Instances, 10
	IniRead, setSpeed, Settings.ini, UserSettings, setSpeed, 2x
    IniRead, defaultLanguage, Settings.ini, UserSettings, defaultLanguage, English

; Main GUI setup
; Add the link text at the bottom of the GUI

Gui, Show, w500 h500, Arturos PTCGPB Bot Setup ; Ensure the GUI size is appropriate

Gui, Color, White  ; Set the background color to white
Gui, Font, s10 Bold , Segoe UI 
; Add the button image on top of the GUI
;Gui, Add, Picture, gStart x196 y196 w108 h108 vImageButton  +BackgroundTrans, %normalImage%
Gui, Add, Button, gArrangeWindows x215 y208 w70 h32, Arrange Windows
Gui, Add, Button, gStart x227 y258 w46 h32 vArrangeWindows, Start

Gui, Add, Text, x0 y464 w500 h30 vLinkText gOpenLink cBlue Center +BackgroundTrans
Gui, Font, s15 Bold , Segoe UI
; Add the background image to the GUI
Gui, Add, Picture, x0 y0 w500 h500, %A_ScriptDir%\Scripts\GUI\GUI.png

; Add input controls
Gui, Add, Edit, vName x80 y95 w145 Center, %Name%
Gui, Add, Edit, vInstances x275 y95 w145 Center, %Instances%

; Pack selection logic
if (openPack = "Mewtwo") {
    defaultPack := 1
} else if (openPack = "Pikachu") {
    defaultPack := 2
} else if (openPack = "Charizard") {
    defaultPack := 3
} else if (openPack = "Mew") {
    defaultPack := 4
} else if (openPack = "Random") {
    defaultPack := 5
}

Gui, Add, DropDownList, x80 y166 w145 vopenPack choose%defaultPack% Center, Mewtwo|Pikachu|Charizard|Mew|Random
Gui, Add, Edit, vColumns x275 y166 w145 Center, %Columns%

if (defaultLanguage = "English") {
    defaultLang := 1
} else if (defaultLanguage = "Japanese") {
    defaultLang := 2
} else if (defaultLanguage = "French") {
    defaultLang := 3
}

Gui, Add, DropDownList, x80 y245 w145 vdefaultLanguage choose%defaultLang%, English|Japanese|French

Gui, Add, Edit, vDelay x80 y332 w145 Center, %Delay%
Gui, Add, Edit, vChangeDate x275 y332 w145 Center, %ChangeDate%

Gui, Font, s10 Bold, Segoe UI 
Gui, Add, Edit, vfolderPath x80 y404 w145 h35 Center, %folderPath%

; Speed selection logic
if (setSpeed = "2x") {
    defaultSpeed := 1
} else if (setSpeed = "1x/2x") {
    defaultSpeed := 2
} else if (setSpeed = "1x/3x") {
    defaultSpeed := 3
}
Gui, Font, s15 Bold, Segoe UI 
Gui, Add, DropDownList, x275 y404 w145 vsetSpeed choose%defaultSpeed% Center, 2x|1x/2x|1x/3x

; Show the GUI
Gui, Show
return

ArrangeWindows:
	GuiControlGet, Instances,, Instances
	Loop %Instances% {
		resetWindows(A_Index)
		sleep, 10
	}
return

; Handle the link click
OpenLink:
    Run, https://buymeacoffee.com/aarturoo
return

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
IniWrite, %setSpeed%, Settings.ini, UserSettings, setSpeed
IniWrite, %defaultLanguage%, Settings.ini, UserSettings, defaultLanguage

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
	
    Run, %Command%
}

Loop {
	; Sum all variable values and write to total.json
	total := SumVariablesInJsonFile()
	CreateStatusMessage("Packs: " . total, 200, 533)
	Sleep, 10000
}
Return

GuiClose:
ExitApp

resetWindows(Title){
	global Columns
	if !WinExist(Title)
		Msgbox, Window titled: %Title% does not exist
	CreateStatusMessage("Arranging window positions and sizes")
	rowHeight := 533  ; Adjust the height of each row
	currentRow := Floor((Title - 1) / Columns)
	y := currentRow * rowHeight	
	x := Mod((Title - 1), Columns) * 277
	
	WinMove, %Title%, , 0 + x, 0 + y, 277, 537
	return true
}

CreateStatusMessage(Message, X := 0, Y := 60) {
	global PacksText
	GuiName := 22
	PacksText := 22
	
	; Create a new GUI with the given name, position, and message
	Gui, %GuiName%:New, +AlwaysOnTop +ToolWindow -Caption 
	Gui, %GuiName%:Default
	Gui, %GuiName%:Margin, 2, 2  ; Set margin for the GUI
	Gui, %GuiName%:Font, s8  ; Set the font size to 8 (adjust as needed)
	Gui, %GuiName%:Add, Text, vPacksText, %Message%
	Gui,%GuiName%:Show,NoActivate x%X% y%Y% AutoSize,NoActivate %GuiName%
	
}


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

; Global variable to track the current JSON file
global jsonFileName := ""

; Function to create or select the JSON file
InitializeJsonFile() {
    global jsonFileName
	fileName := A_ScriptDir . "\json\Packs.json"
	if FileExist(fileName)
		FileDelete, %fileName%
	if !FileExist(fileName) {
		; Create a new file with an empty JSON array
		FileAppend, [], %fileName%  ; Write an empty JSON array
		jsonFileName := fileName
		return
	}
}

; Function to append a time and variable pair to the JSON file
AppendToJsonFile(variableValue) {
    global jsonFileName
    if (jsonFileName = "") {
        MsgBox, JSON file not initialized. Call InitializeJsonFile() first.
        return
    }

    ; Read the current content of the JSON file
    FileRead, jsonContent, %jsonFileName%
    if (jsonContent = "") {
        jsonContent := "[]"
    }

    ; Parse and modify the JSON content
    jsonContent := SubStr(jsonContent, 1, StrLen(jsonContent) - 1) ; Remove trailing bracket
    if (jsonContent != "[")
        jsonContent .= ","
    jsonContent .= "{""time"": """ A_Now """, ""variable"": " variableValue "}]"

    ; Write the updated JSON back to the file
    FileDelete, %jsonFileName%
    FileAppend, %jsonContent%, %jsonFileName%
}

; Function to sum all variable values in the JSON file
SumVariablesInJsonFile() {
    global jsonFileName
    if (jsonFileName = "") {
        MsgBox, JSON file not initialized. Call InitializeJsonFile() first.
        return 0
    }

    ; Read the file content
    FileRead, jsonContent, %jsonFileName%
    if (jsonContent = "") {
        MsgBox, The JSON file is empty.
        return 0
    }

    ; Parse the JSON and calculate the sum
    sum := 0
    ; Clean and parse JSON content
    jsonContent := StrReplace(jsonContent, "[", "") ; Remove starting bracket
    jsonContent := StrReplace(jsonContent, "]", "") ; Remove ending bracket
    Loop, Parse, jsonContent, {, }
    {
        ; Match each variable value
        if (RegExMatch(A_LoopField, """variable"":\s*(-?\d+)", match)) {
            sum += match1
        }
    }

    ; Write the total sum to a file called "total.json"
    totalFile := A_ScriptDir . "\json\total.json"
    totalContent := "{""total_sum"": " sum "}"
    FileDelete, %totalFile%
    FileAppend, %totalContent%, %totalFile%

    return sum
}

~F7::ExitApp
