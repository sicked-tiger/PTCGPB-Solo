;Arturo's PTCGP Bot
;special thanks to pandaporo. for bringing adb inputs to my attention for v2.0
;thanks to Bonney, malloc, RONSLOW, ivanoski, Let, robinesch, azureWOX and everyone else who helped test and contributed.
;changelog
;v2.5
; - Added a check for country since it isn't selected for some people.
; - Moved statuses down a bit
; - Added the m back to the total time
; - Created restartGameInstance function that will restart your instance if it gets stuck and it cant fix itself or if it detects a crash
; - Finds adb ports from mumu installation folders. thanks pandporo. for the tip
; - added a log file for when it restarts an instance
;v2.4
; - abdClick now uses window coordinates instead of emulator coordinates to more easily edit the script
; - fixed the screenshots folder path
; - removed unnecessary loops, clicks, delays, variables left over from when the bot had to keep instances in sync. There's a lot more optimization that can be done here
; - Thanks to azureWOX for suggesting to check the card borders on the opening screen for god packs.
; - God packs are now checked at opening screen by checking card borders. If a common border is found once then it can't be a god pack. If no common borders are found in top 3 cards then it's a god pack.
; - Changed the swipe up coordinates to what @CJ was using since they seem better.
;v2.3
; - Creates necessary .ahk script files based on the amount of instances you want to run.
; - Fixed settings not being read correctly by scripts
; - Readded universal pause/resume/stop buttons
; - Added 1 second delay in between launching each instance.
; - Reload/Pause/Resume/Stop/GP Test can now be done on all instances with F keys.
;v2.2
; - It pauses now on god packs instead of reloading so it keeps your run stats up
; - Screenshots god packs through adb commands and saves them in a folder named screenshot in the bot folder.
; - New gui launcher to set your settings and launch all of your instances
;v2.1
; - Pausing now stops the timer it uses to check if it's stuck
; - Added GP test button to get instances to stop before deleting account to test god packs
;v2.0
; - I didn't keep track of all of the changes
; - Mainly changed it to use adb commands to send all clicks, swipes, and texts. AHK no longer directly does any inputs.
; - had to change all the controlclicks and readjust the x and y positions to be relative to the emulator's screen position
; - the status and the run time/avg is now individual to the instancce
; - added pause, resume, stop and reload buttons to each instance rather than using f keys
; - Godpacks no longer close, but rather stops the .ahk script so it stays open and you can see it at a glance
; - no longer screenshots god packs since when running at max capacity it doesnt seem to be able to
; - added a new separate "GPlog" file to write to if you find a god pack so you can quickly find it rather than searching through the regular logs
; - each instance no creates their own log file to more easily see what happened
; - removed a few things that were unnecessary since we're now running each instance individually
; - still need to remove a lot of logic that was used to keep instances in sync, however, functionally it should really be no different since it now keeps it in sync with a single instance
; - the instances setting in the gui now corresponds to the adb port of your instance found by clicking the adb button in the mumu multi instances window
; - All swipe options call the same function. I have to get rid of it. May need to add a timing variable if swipes are still inconsistent across systems.
; - You now need to run a separate .ahk file per instance. named just like your instances
; - no longer need mumu's syncronization
; - blockinput is no longer needed
; - can use your pc without issues as long as you're not running your max amount of instances possible
; - including adb folder
; - removed readme
;v1.9.1
; - Fixed an issue where it wasn't saving Mew as your default option.
;v1.9
; - Updated to work with the new pack.
;v1.8
; - @malloc created an AHK swipe function that we believe works for most people. If it works it is MUCH better than using the macro swipe option! Please try it and let us know in https://discord.com/channels/1310093045726969977/1317454711401746543 if it works.
; - Improved logging to be able to decipher a bit more what happens.
;v1.7.3
; - Added another in-game error message fail safe
;v1.7.2
; - Removed screenshotting just 2 stars that I was using to gather some images.
;v1.7.1
; - @Bonney added the screenshot option to the GUI and added more image sources!
;v1.7
; - GUI makeover thanks to @Bonney!
; - God Packs now close at the opening results card page.
; - Added an option to take a screenshot at the opening results before closing if a godpack is found. Screenshots are saved to your default folder. Usually C:\Users\{USER}\Pictures\Screenshots
; - Temporary screenshot option added
; - Fixed a bug where it wouldn't activate the correct window when swiping with AHK.
; - Fixed a bug where it would confuse the status bars as instance 1 and 2 when closing or resetting the windows.
; - Implemented a delay after the first click in the keepsync function at wonder4 to prevent wonderpick from freezing. Thanks @KINGCON
; - Added a failsafe after opening packs to continue at skip3.
; - Removed tooltip when blocking input and replaced with better status messages because the tooltip could cause lag.
; - Added a failsafe after pack opening if skip button is unable to be found.
; - Opening.png now part of the checkrarity function
; - Fixed a bug where it would sometimes not move onto the next card if the first one was a star leading to false positive god pack detection. 
; - Reverted some coordinates on the AHK swipe since it made it worse for people that are using it.
; - Finally(?) fixed the script from enjoying the movie too much if an immersive is opened as a first card. I don't even know anymore :(
; - If your date change time is at midnight it should now properly sleep 5 mins before and after.
; - Fixed a bug with come failsafes where it would start closing instances in numerical order even if they weren't stuck.
;v1.6.1
; - Reverted a failsafe for swiping since it broke the macro swipes. I'll rewrite that part in in a future version
; - Fixed a bug that would cause it to swipe in another window if you were actively using your pc and clicked/typed at the same time it takes control
; - Fixed an issue that made it so that it couldn't select the mumu swipe macros.
;v1.6
; - GOD PACK RELATED BUG FIX: Fixed a bug where it was killing the wrong god pack instance if there was an instance killed earlier that was a lower number. 1, 2, 3, 4 = closing correctly. 1, 3, 4 if 4 had a gp it would close 3. Thanks to @Bendy for the report.
; - Actually fixed the first card immersive bug.
; - Crowns should now be skipped if within the first 3 cards.
; - God packs are now counted in the status bar
; - Windows now resize and rearrange after pressing ok
; - Added a failsafe when swiping if the macro window isn't found
; - Fixed incorrect status message when swiping a pack.
; - Added where an instance gets stuck to the logs.
; - Made the status bar click through so it wouldn't affect resyncing when closing down the lead instance
; - Removed the Open.png step and added a failsafe to the  next one in the sequence
; - Added a failsafe for missing the wonder pick card
; - Added warning and info on submitting settings
; - Fixed a bug where it was possible for it to not close a god pack if it get stuck on other instances while going through cards.
; - Added a warning message that it can delete other accounts in other mumu instances if left unattended.
; - Added message to not DM or @ me for help.
; - Added tooltip while blocking inputs to remind users that ctrl+alt+del unblocks input
; - Fixed incorrect logging of "not a god pack only x stars" from logging before know what the 3rd card was to determine correctly that it's not a god pack.
; - Added an error message if attempting to set the image variation too high.
; - Increased the time for the date change sleep. It will now stop for 5 minutes before to 5 minutes afterwards.
;v1.5.5
; - Rogue letter replaced some functions..
;v1.5.4
; - Major bug fix: god packs in the second row were not being detected. It was checking the first row X number of times and would close all instances below a god pack found in the first row.
; - Bug fix: Fixed all instances closing if it detected one was stuck. (Please lmk if it still happens or if something else does)
; - Run stats are now logged in logs.txt
; - Added syncWindows() which automatically synchronizes all the windows if the "lead" window closes due to a godpack or if it gets stuck
; - Modified a failsafe at "Open.png"
; - Replaced/added some images. You need to download the full folder for this update to work.
; - Added some addition logs when you find 2 stars
; - Status now displays god packs found
;v1.5.3
; - Had some code commented out so it wasn't going to work.
;v1.5.2
; - Fixed the default options in the settings
;v1.5.1
; - Removed some text from GUI so people on 1920x1080 resolution can click ok.
; v1.5
; - LWin is now longer needed to unblock the script if blocks your screen and gets stuck while running as admin. You can now use left alt or ctrl alt del to get control back
; - Your settings are now saved in Settings%scriptName%.ini
; - Fixed multiple instances closing if a godpack was found.
; v1.4
; - Added total time running alongside the average
; - Hopefully fixed it getting stuck play/pausing the video of an immersive if it is the first card.. Again..
; - Fixed an issue where some were getting stuck at opening
; - added a failsafe to attempt to input the account name if it fails
; - You can now set the amount of instances you want per row
; - Added a tooltip over your mouse to show when your inputs are being blocked
; - fixed an issue where if you ran more than 9 instances it would confuse instances named 10+ as window 1.
; - fixed a bug causing it to get stuck sometimes after opening a pack
; - added a failsafe while swiping and tracing to close an instance if it isn't successful in 90s.
;v1.3.2
; - fixed the godpackkiller function so now it should continue even after it finds a godpack on one instance or if one instance gets killed if it freezes or gets stuck
;v1.3.1
; - fixed a type in one of the coordinates
;v1.2/v1.3
; - Updated the version number in the gui.
; - Updated the gui to make it clear F7 is for pause/resume
; - Added a check for making sure you've pressed ok at the settings.
; - Fixed some status message names
; - Added a failsafe at the first hourglass2
; - Added a check for the game's "an error has occurred" message to click retry and continue.
; - Hopefully fixed an infinite loop after finding a god pack that caused it not to continue with other instances.
; - Hopefully fixed it getting stuck play/pausing the video of an immersive if it is the first card.
; - Fixed some of the failsafes weren't working
; - Made inputting name more consistent
;v1.1
; - Fixed the failsafes at Month and end
; - If it gets stuck for 90s it should close that instance and continue now even if it's in a failsafe.
;v1.0
; - Added delay between wonder 3 and 4. removed delay between 2 and 4.
;v0.9.8
; - Fixed the sleeping to prevent getting kicked by the change date time
; - Changed where block input starts so it blocks until it successfully swipes and doesn't allow you to interrupt its attempts
; - Added delay between wonder 2 and wonder 3 to prevent the game from freezing
;v0.9.7
; - Added multiple failsafes. 1. when selecting month/year 2. after wonderpicking 3. clicking the menu to delete the Account 4. before the last pack 5. agree to tos/privacy 6. before each pack opening
; - Tracks your mouse positon and active window in the sections that reqiuire mouse/keyboard control so that it puts you back where you were if you are actively using your pc.
; - If you run as admin input is blocked for the sections that require mouse/keyboard ControlClick. Press the left windows key or ctrl+alt+del if it gets stuck and your inputs are still blocked.
; - Added option to swipe with AHK which works really well for me, but may not work for others.
; - Added a sleep between 12:55 am and 1:01 am to avoid being kicked out and out of sync when the date change happens. This is configurable for whatever time it changes for you.
; - Fixed getting stuck play/pausing the video of an immersive if it showed up in the first card.
;v0.9.6
; - Added another click to the name and some delay
;v0.9.5
; - The "god pack checking" function should now work correctly
; - Added an option to increase most delays when starting the script
; - Added an option to change variance if there's an issue matching certain ImageSearch
; - Changed the sequence of clicks and image searches to hopefully be more consistent for more people
; - Changed some delays
; - If an instance gets stuck it will be killed and continue without it.
; - Updated the average time per cycle to be in minutes and seconds
; - Continuing with the GP reroller script name and updated version #.
;v0.9.3
; - fixed some other coords i somehow erased
; - added error checking for not finding the image folder
; - change the s/s for the country to country/region instead of united states
;v0.9.2
; - fixed another pair of coordinates
;v0.9.1
; - fixed coordinates for checking rarity
;v0.9 Test version

version = PTCGP Bot v2.4

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

yNextPage := yVariationEdit + controlHeight + controlSpacing 

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

F5:: ;reload
blockinput on
MouseGetPos, originalX, originalY
Loop %Instances% {
	rowHeight := 533  ; Adjust the height of each row
	currentRow := Floor((A_Index - 1) / Columns)
	y := 41 + currentRow * rowHeight	
	x := 22 + Mod((A_Index - 1), Columns) * 277
	MouseClick, left, %x%, %y%
}
MouseMove, %originalX%, %originalY%
blockinput off
Return

F6:: ;pause/resume
blockinput on
MouseGetPos, originalX, originalY
Loop %Instances% {
	rowHeight := 533  ; Adjust the height of each row
	currentRow := Floor((A_Index - 1) / Columns)
	y := 41 + currentRow * rowHeight	
	
	if(!Paused)
		x := 59 + Mod((A_Index - 1), Columns) * 277
	else
		x := 106 + Mod((A_Index - 1), Columns) * 277
		
	MouseClick, left, %x%, %y%
}
MouseMove, %originalX%, %originalY%
blockinput off
if(!Paused)
	Paused := true
else
	Paused := false
Return

F7:: ;stop
blockinput on
MouseGetPos, originalX, originalY
Loop %Instances% {
	rowHeight := 533  ; Adjust the height of each row
	currentRow := Floor((A_Index - 1) / Columns)
	y := 41 + currentRow * rowHeight	
	x := 150 + Mod((A_Index - 1), Columns) * 277
	
	MouseClick, left, %x%, %y%
}
MouseMove, %originalX%, %originalY%
blockinput off
Return

F8:: ;gp test
blockinput on
MouseGetPos, originalX, originalY
Loop %Instances% {
	rowHeight := 533  ; Adjust the height of each row
	currentRow := Floor((A_Index - 1) / Columns)
	y := 41 + currentRow * rowHeight	
	x := 193 + Mod((A_Index - 1), Columns) * 277
	
	MouseClick, left, %x%, %y%
}
MouseMove, %originalX%, %originalY%
blockinput off
Return

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