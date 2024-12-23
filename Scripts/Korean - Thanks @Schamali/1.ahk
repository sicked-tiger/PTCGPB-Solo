#SingleInstance on
;SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
;SetWinDelay, -1
;SetControlDelay, -1
SetBatchLines, -1
SetTitleMatchMode, 3
CoordMode, Pixel, Screen

global winTitle, changeDate, failSafe, openPack, GodPack, Delay, failSafeTime, StartSkipTime, Columns, failSafe, adbPort, scriptName, adbShell, adbPath, GPTest, StatusText
	
	adbPath := A_ScriptDir . "\adb\platform-tools\adb.exe"  ; Example path, adjust if necessary
	deleteAccount := false
	scriptName := StrReplace(A_ScriptName, ".ahk")
	winTitle := scriptName
	
	IniRead, adbPort, %A_ScriptDir%\..\Settings.ini, UserSettings, adbPort%scriptName%, 11111
    IniRead, Name, %A_ScriptDir%\..\Settings.ini, UserSettings, Name, Arturo
    IniRead, Delay, %A_ScriptDir%\..\Settings.ini, UserSettings, Delay, 250
    IniRead, Variation, %A_ScriptDir%\..\Settings.ini, UserSettings, Variation, 40
    IniRead, changeDate, %A_ScriptDir%\..\Settings.ini, UserSettings, ChangeDate, 0100
    IniRead, Columns, %A_ScriptDir%\..\Settings.ini, UserSettings, Columns, 5
    IniRead, openPack, %A_ScriptDir%\..\Settings.ini, UserSettings, openPack, 4
	
	if(!adbPort) {
		Msgbox, Invalid port. Stopping...
		ExitApp
	}
	
	; connect adb
	instanceSleep := A_ScriptDir * 1000
	Sleep, %instanceSleep%
	RunWait, %adbPath% connect 127.0.0.1:%adbPort%,, Hide
	
	resetWindows()
	
	WinGetPos, x, y, Width, Height, %winTitle%
	sleep, 2000
	
	; Now, re-create the GUI with the Pause, Resume, and Stop buttons after initialization
		x4 := x + 5
		y4 := y + 25
		
	
	    Gui, New, +AlwaysOnTop +ToolWindow -Caption 
        Gui, Default
        Gui, Margin, 4, 4  ; Set margin for the GUI
		Gui, Font, s5 cGray Norm Bold, Segoe UI  ; Normal font for input labels
		Gui, Add, Button, x0 y0 w30 h25 gReloadScript, Reload  (F5)
		Gui, Add, Button, x30 y0 w30 h25 gPauseScript, Pause (F6)
		Gui, Add, Button, x60 y0 w40 h25 gResumeScript, Resume (F6)
		Gui, Add, Button, x100 y0 w30 h25 gStopScript, Stop (F7)
		Gui, Add, Button, x130 y0 w40 h25 gTestScript, GP Test  (F8)
        Gui, Show, NoActivate x%x4% y%y4% AutoSize, NoActivate
		
	if (!openPack)
		openPack = 1
	else if (openPack = "Mewtwo")
		openPack = 1
	else if (openPack = "Pikachu")
		openPack = 2
	else if (openPack = "Charizard")
		openPack = 3
	else if (openPack = "Mew")
		openPack = 4

	rerollTime := A_TickCount	

	adbShell := ComObjCreate("WScript.Shell").Exec(adbPath . " -s 127.0.0.1:" . adbPort . " shell")

	; Extract the Process ID
	processID := adbShell.ProcessID

	; Wait for the console window to open using the process ID
	WinWait, ahk_pid %processID%

	; Minimize the window using the process ID
	WinMinimize, ahk_pid %processID%

Loop {

if(Variation > 80) {
	Msgbox, Image search variation is far too high!
	break
}

	FormatTime, CurrentTime,, HHmm

    StartTime := changeDate - 45 ; 12:55 AM2355
    EndTime := changeDate + 5 ; 1:01 AM

    ; Adjust for crossing midnight
    if (StartTime < 0)
        StartTime += 2400
    if (EndTime >= 2400)
        EndTime -= 2400
		
	While(((CurrentTime - StartTime >= 0) && (CurrentTime - StartTime <= 5)) || ((EndTime - CurrentTime >= 0) && (EndTime - CurrentTime <= 5)))
	{
		CreateStatusMessage("I need a break... Sleeping until " . changeDate + 5 . " to avoid being kicked out from the date change")
		FormatTime, CurrentTime,, HHmm ; Update the current time after sleep
		Sleep, 5000
	}
	
KeepSync(77, 144, 169, 175, , "Country", 143, 370) ;select month and year and click

adbClick(80, 400)
Sleep, %Delay%
adbClick(80, 400)
Sleep, %Delay%
failSafe := A_TickCount
failSafeTime := 0

Loop
{
	Sleep, %Delay%
	if(KeepSync(100, 386, 138, 416, , "Month", , , , 1, failSafeTime))
		break
	Sleep, %Delay%
adbClick(142, 159)
	Sleep, %Delay%
adbClick(80, 400)
	Sleep, %Delay%
adbClick(80, 400)
	failSafeTime := (A_TickCount - failSafe) // 1000
	CreateStatusMessage("In failsafe for Month. It's been: " . failSafeTime "s ")
	LogToFile("In failsafe for Month. It's been: " . failSafeTime "s ")
} ;select month and year and click

adbClick(200, 400)
Sleep, %Delay%
adbClick(200, 400)
Sleep, %Delay%
failSafe := A_TickCount
failSafeTime := 0
Loop ;select month and year and click
{
	Sleep, %Delay%
	if(KeepSync(148, 384, 256, 419, , "Year", , , , 1, failSafeTime))
		break
	Sleep, %Delay%
	adbClick(142, 159)
	Sleep, %Delay%
	adbClick(142, 159)
	Sleep, %Delay%
	adbClick(200, 400)
	Sleep, %Delay%
	adbClick(200, 400)
	Sleep, %Delay%
	adbClick(142, 159)
	Sleep, %Delay%
	failSafeTime := (A_TickCount - failSafe) // 1000
	CreateStatusMessage("In failsafe for Year. It's been: " . failSafeTime "s ")
	LogToFile("In failsafe for Year. It's been: " . failSafeTime "s ")
} ;select month and year and click
imagePath := A_ScriptDir . "\Game\CountrySelect.png"
failSafe := A_TickCount
failSafeTime := 0
Loop {
	ImageSearch, , , 93, 471, 122, 485, *40 %imagePath%
	if(ErrorLevel = 0) {
		sleep, 1000
		adbClick(144, 226)
		sleep, 2000
		adbClick(144, 226)
	}
	else
		break
	sleep, 10
	failSafeTime := (A_TickCount - failSafe) // 1000
	CreateStatusMessage("In failsafe for country select. It's been: " . failSafeTime "s ")
	LogToFile("In failsafe for country select. It's been: " . failSafeTime "s ")
}

KeepSync(67, 286, 217, 319, , "Birth", 140, 474, 1000) ;wait date confirmation screen while clicking ok

KeepSync(97, 285, 185, 315, , "TosScreen", 203, 371, 1000) ;wait to be at the tos screen while confirming birth

KeepSync(81, 68, 204, 94, , "Tos", 139, 299, 1000) ;wait for tos whle clicking it

KeepSync(97, 285, 185, 315, , "TosScreen", 142, 486, 1000) ;wait to be at the tos screen and click x

KeepSync(82, 71, 146, 95, , "Privacy", 142, 339, 1000) ;wait to be at the tos screen

KeepSync(97, 285, 185, 315, , "TosScreen", 142, 486, 1000) ;wait to be at the tos screen, click X

Sleep, %Delay%
adbClick(261, 374)

Sleep, %Delay%
adbClick(261, 406)

Sleep, %Delay%
adbClick(145, 484)

failSafe := A_TickCount
failSafeTime := 0
Loop {
	if(KeepSync(78, 334, 216, 363, , "Save", 145, 484, , 2, failSafeTime)) ;wait to be at create save data screen while clicking
		break
	Sleep, %Delay%
adbClick(261, 406)
	if(KeepSync(78, 334, 216, 363, , "Save", 145, 484, , 2, failSafeTime)) ;wait to be at create save data screen while clicking
		break
	Sleep, %Delay%
adbClick(261, 374)
	failSafeTime := (A_TickCount - failSafe) // 1000
	CreateStatusMessage("In failsafe for Save. It's been: " . failSafeTime "s ")
	LogToFile("In failsafe for Save. It's been: " . failSafeTime "s ")
}

Sleep, %Delay%

adbClick(143, 348)

Sleep, %Delay%

KeepSync(51, 335, 107, 359, , "Link") ;wait for link account screen%

KeepSync(48, 277, 142, 319, , "Confirm", 140, 460, 1000) ;wait for confirm download screen

KeepSync(69, 248, 207, 270, , "Complete", 203, 364, 1000) ;wait for complete download screen

Sleep, %Delay%

adbClick(143, 369)

Sleep, %Delay%

KeepSync(60, 206, 226, 248, , "Welcome", 253, 506, 110) ;click through cutscene until welcome page

KeepSync(190, 241, 225, 270, , "Name", 189, 438) ;wait for name input screen

KeepSync(75, 498, 230, 537, , "OK", 139, 257) ;wait for name input screen

Loop {
	adbName()
	Sleep, %Delay%
	if(KeepSync(121, 490, 161, 520, , "Return", 185, 372, , 5)) ;click through until return button on open pack
		break
		
	adbClick(90, 370)
	Sleep, %Delay%
	adbClick(139, 254) ; 139 254 194 372
	Sleep, %Delay%
	adbClick(139, 254)
	Sleep, %Delay%
	length := StrLen(Name) ; in case it lags and misses inputting name
	Loop %length% {
		;Run, %adbPath% -s 127.0.0.1:%adbPort% shell input keyevent 67, , Hide
		adbShell.StdIn.WriteLine("input keyevent 67")	
		Sleep, 10
	}
}

Sleep, %Delay%

adbClick(140, 424)

KeepSync(104, 269, 177, 296, , "Trace", 140, 424) ;wait for pack to be ready  to trace

failSafe := A_TickCount
failSafeTime := 0
Loop {
	adbSwipe()
	Sleep, 10
	if (CheckInstances(104, 199, 169, 268, , "Bulba", 0, failSafeTime))
		break
	failSafeTime := (A_TickCount - failSafe) // 1000
	CreateStatusMessage("In failsafe for Trace. It's been: " . failSafeTime "s ")
	LogToFile("In failsafe for Trace. It's been: " . failSafeTime "s ")
}

KeepSync(34, 99, 74, 131, , "Swipe", 140, 375) ;click through cards until needing to swipe up

failSafe := A_TickCount
failSafeTime := 0
Loop {
	adbSwipeUp()
	Sleep, 10
	if (CheckInstances(113, 108, 175, 135, , "SwipeUp", 0, failSafeTime))
		break
	failSafeTime := (A_TickCount - failSafe) // 1000
	CreateStatusMessage("In failsafe for swipe up. It's been: " . failSafeTime "s ")
}

KeepSync(70, 80, 133, 109, , "Move", 134, 375) ; click through until move

KeepSync(105, 242, 173, 277, , "Proceed", 141, 483) ;wait for menu to proceed then click ok
Sleep, %Delay%
adbClick(204, 371)

KeepSync(46, 368, 103, 411, , "Gray") ;wait for for missions to be clickable

Sleep, %Delay%
adbClick(247, 472)

KeepSync(115, 97, 174, 150, , "Pokeball", 247, 472, 5000) ; click through missions until missions is open

Sleep, %Delay%
adbClick(141, 294)
Sleep, %Delay%
adbClick(141, 294)
Sleep, %Delay%
KeepSync(124, 168, 162, 207, , "Register", 141, 294, 1000) ; wait for register screen
Sleep, %Delay%
Sleep, %Delay%
Sleep, %Delay%
Sleep, %Delay%
Sleep, %Delay%
Sleep, %Delay%
adbClick(140, 500)

KeepSync(115, 255, 176, 308, , "Mission") ; wait for mission complete screen

KeepSync(184, 308, 213, 339, , "Half", 143, 360) ;click until packs are clickable

KeepSync(120, 176, 162, 210, , "Booster", 145, 194) ;click on packs. stop at booster pack tutorial

Sleep, %Delay%
Sleep, %Delay%
Sleep, %Delay%
adbClick(142, 436)
Sleep, %Delay%
Sleep, %Delay%
Sleep, %Delay%
adbClick(142, 436)
Sleep, %Delay%
Sleep, %Delay%
Sleep, %Delay%
adbClick(142, 436)
Sleep, %Delay%
Sleep, %Delay%
Sleep, %Delay%
adbClick(142, 436)

KeepSync(104, 269, 177, 296, , "Trace", 239, 497) ;wait for pack to be ready  to Trace


failSafe := A_TickCount
failSafeTime := 0
Loop {
	adbSwipe()
	Sleep, 10
	if (CheckInstances(230, 486, 272, 526, , "Skip3", 0, failSafeTime))
		break
	failSafeTime := (A_TickCount - failSafe) // 1000
	CreateStatusMessage("In failsafe for skip. It's been: " . failSafeTime "s ")
	LogToFile("In failsafe for Trace. It's been: " . failSafeTime "s ")
}

KeepSync(76, 66, 149, 92, , "Opening", 239, 497) ;skip through cards until results opening screen

checkBorder() ;check card border to find godpacks	

KeepSync(233, 486, 272, 519, , "Skip", 146, 496) ;click on next until skip button appears

KeepSync(53, 281, 86, 310, , "Wonder", 239, 497) ;stop at start of wonder tutorial

Sleep, %Delay%
Sleep, %Delay%
Sleep, %Delay%

adbClick(140, 358)

KeepSync(194, 421, 220, 433, , "Shop", 146, 444) ;click until at main menu

KeepSync(87, 232, 131, 266, , "Wonder2", 79, 411) ; click until wonder pick tutorial screen

KeepSync(116, 412, 167, 433, , "Wonder3", 190, 437) ; click through tutorial

Sleep, %Delay%
Sleep, %Delay%

KeepSync(155, 281, 192, 315, , "Wonder4", 202, 347, 500) ; confirm wonder pick selection 

KeepSync(103, 101, 177, 121, , "Pick", 208, 461, 350) ;stop at pick a card

sleep, %Delay%
adbClick(187, 345)

KeepSync(39, 102, 68, 130, , "Swipe2", 143, 492, , 7) ;click through cards until needing to swipe up

failSafe := A_TickCount
failSafeTime := 0
Loop {
	if(KeepSync(0, 0, 224, 246, , "End", 239, 497, , 2, failSafeTime)) ;click through to end of tut screen
		break
	sleep, %Delay%
adbClick(143, 492)
	sleep, %Delay%
adbClick(143, 492)
	sleep, %Delay%
adbClick(66, 446)
	sleep, %Delay%
adbClick(66, 446)
	sleep, %Delay%
adbClick(66, 446)
	sleep, %Delay%
adbClick(187, 345)
	failSafeTime := (A_TickCount - failSafe) // 1000
	CreateStatusMessage("In failsafe for End. It's been: " . failSafeTime "s ")
	LogToFile("In failsafe for End. It's been: " . failSafeTime "s ")
}


KeepSync(125, 330, 162, 348, , "Main", 192, 449) ;click until at main menu
Loop {
	if(!GPTest) {
		break
	}
	deleteAccount := true
	CreateStatusMessage("GP Test mode. Press button again to delete.")
	sleep, 1000
}

if(deleteAccount = false) {	
	if(openPack = 4) { ; MEW
		KeepSync(233, 400, 264, 428, , "Points", 80, 196) ;Mew	
		KeepSync(233, 486, 272, 519, , "Skip2", 146, 439) ;click on next until skip button appears
	}
	else if(openPack = 1) { ;MEWTWO
		KeepSync(233, 400, 264, 428, , "Points", 200, 196) ;Genetic apex
		KeepSync(233, 486, 272, 519, , "Skip2", 146, 439) ;click on next until skip button appears
	}
	else if(openPack = 2) { ;pikachu
		KeepSync(233, 400, 264, 428, , "Points", 200, 196) ;Genetic apex
		Sleep, %Delay%
		Sleep, %Delay%
		KeepSync(233, 400, 264, 428, , "Points") ;Genetic apex
	adbClick(222, 268)
		Sleep, %Delay%
		Sleep, %Delay%
		Sleep, %Delay%
		Sleep, %Delay%
		KeepSync(233, 486, 272, 519, , "Skip2", 146, 439) ;click on next until skip button appears
	}
	else if(openPack = 3) { ;charizard
		
		KeepSync(233, 400, 264, 428, , "Points", 200, 196) ;Genetic apex
		Sleep, %Delay%
		Sleep, %Delay%
		KeepSync(233, 400, 264, 428, , "Points") ;Genetic apex
	adbClick(56, 268)
		Sleep, %Delay%
		Sleep, %Delay%
		Sleep, %Delay%
		Sleep, %Delay%
		KeepSync(233, 486, 272, 519, , "Skip2", 146, 439) ;click on next until skip button appears
	}
		
	Loop {
		if(KeepSync(104, 269, 174, 294, , "Trace", 239, 497, , 2))
			break ;wait for pack to be ready to Trace and click skip
		sleep, %Delay%
	adbClick(146, 439)
	}

	failSafe := A_TickCount
	failSafeTime := 0
	Loop {
		adbSwipe()	
		Sleep, 10
		if (CheckInstances(230, 486, 272, 526, , "Skip3", 0, failSafeTime))
			break
		failSafeTime := (A_TickCount - failSafe) // 1000
		CreateStatusMessage("In failsafe for Trace. It's been: " . failSafeTime "s ")
		LogToFile("In failsafe for Trace. It's been: " . failSafeTime "s ")
	}
		
	KeepSync(76, 66, 149, 92, , "Opening", 239, 497) ;skip through cards until results opening screen

	checkBorder() ;check card border to find godpacks	

	KeepSync(233, 486, 272, 519, , "Skip", 146, 494) ;click on next until skip button appears

	KeepSync(20, 500, 55, 530, , "Home", 244, 496) ;click skip until pack is ready to open

	Sleep, %Delay%
	Sleep, %Delay%
	Sleep, %Delay%
	adbClick(142, 429)

	Loop {
		if(KeepSync(104, 269, 174, 294, , "Trace", 239, 497, , 2))
			break ;wait for pack to be ready to Trace and click skip
		sleep, %Delay%
	adbClick(142, 429)
	}

	failSafe := A_TickCount
	failSafeTime := 0
	Loop {
		adbSwipe()
		Sleep, 10
		if (CheckInstances(230, 486, 272, 526, , "Skip3", 0, failSafeTime))
			break
		failSafeTime := (A_TickCount - failSafe) // 1000
		CreateStatusMessage("In failsafe for Trace. It's been: " . failSafeTime "s ")
		LogToFile("In failsafe for Trace. It's been: " . failSafeTime "s ")
	}

	KeepSync(76, 66, 149, 92, , "Opening", 239, 497) ;skip through cards until results opening screen

	checkBorder() ;check card border to find godpacks	
			
	KeepSync(233, 486, 272, 519, , "Skip", 146, 494) ;click on next until skip button appears


	Loop {
		if(KeepSync(178, 193, 251, 282, , "Hourglass", 239, 497, , 2)) ;click on next until skip button appearsstop at hourglasses tutorial
			break
		adbClick(146, 494) ;146 494
		Sleep, %Delay%
	}
	Sleep, %Delay%
	Sleep, %Delay%
	Sleep, %Delay%
	adbClick(146, 441) ; 146 440
	Sleep, %Delay%
	Sleep, %Delay%
	Sleep, %Delay%
	adbClick(146, 441)
	Sleep, %Delay%
	Sleep, %Delay%
	Sleep, %Delay%
	adbClick(146, 441)
	Sleep, %Delay%
	Sleep, %Delay%
	Sleep, %Delay%

	KeepSync(98, 184, 151, 224, , "Hourglass1", 148, 438, 500, 5) ;stop at hourglasses tutorial 2
	Sleep, %Delay%

	adbClick(203, 436) ; 203 436

	KeepSync(147, 231, 220, 249, , "Hourglass2", 180, 436, 500) ;stop at hourglasses tutorial 2 180 to 203?

	Sleep, %Delay%
	adbClick(210, 464) ; 210 464
	Sleep, %Delay%
	adbClick(210, 464) ; 210 464

	Loop {

		if(KeepSync(104, 269, 174, 294, , "Trace", 239, 497, , 2)) ;wait for pack to be ready to Trace and click skip
			break 
		Sleep, %Delay%
		adbClick(210, 464) ; 210 464
	}


	failSafe := A_TickCount
	failSafeTime := 0
	Loop {
		adbSwipe()
		Sleep, 10
		if (CheckInstances(230, 486, 272, 526, , "Skip3", 0, failSafeTime))
			break
		failSafeTime := (A_TickCount - failSafe) // 1000
		CreateStatusMessage("In failsafe for Trace. It's been: " . failSafeTime "s ")
		LogToFile("In failsafe for Trace. It's been: " . failSafeTime "s ")
	}

	KeepSync(76, 66, 149, 92, , "Opening", 239, 497) ;skip through cards until results opening screen

	checkBorder() ;check card border to find godpacks	

	KeepSync(233, 486, 272, 519, , "Skip", 146, 494) ;click on next until skip button appears
	sleep, %Delay%
	
	KeepSync(20, 500, 55, 530, , "Home", 244, 496) ;click skip until pack is ready to open
}

sleep, %Delay%
failSafe := A_TickCount
failSafeTime := 0
Loop
{
	sleep, %Delay%
	sleep, %Delay%
	adbClick(245, 518)
	if(KeepSync(98, 434, 123, 452, , "Settings", , , , 3, failSafeTime)) ;wait for settings menu
		break
	sleep, %Delay%
	sleep, %Delay%
	adbClick(50, 75)
	failSafeTime := (A_TickCount - failSafe) // 1000
	CreateStatusMessage("In failsafe for Settings. It's been: " . failSafeTime "s ")
	LogToFile("In failsafe for Settings. It's been: " . failSafeTime "s ")
}

KeepSync(24, 158, 57, 189, , "Account", 140, 440, 2000) ;wait for other menu

KeepSync(56, 312, 108, 334, , "Account2", 79, 256, 2000) ;wait for account menu

KeepSync(86, 111, 200, 140, , "Delete", 145, 446, 2000) ;wait for delete save data confirmation

KeepSync(84, 191, 200, 210, , "Delete2", 201, 447, 2000) ;wait for second delete save data confirmation

KeepSync(82, 265, 173, 286, , "Delete3", 201, 369, 2000) ;wait for second 

adbClick(143, 370)

if(deleteAccount := true)
	deleteAccount := false
	
rerolls++
packs += 4
totalSeconds := Round((A_TickCount - rerollTime) / 1000) ; Total time in seconds
avgtotalSeconds := Round(totalSeconds / rerolls) ; Total time in seconds
minutes := Floor(avgtotalSeconds / 60) ; Total minutes
seconds := Mod(avgtotalSeconds, 60) ; Remaining seconds within the minute
mminutes := Floor(totalSeconds / 60) ; Total minutes
sseconds := Mod(totalSeconds, 60) ; Remaining seconds within the minute
CreateStatusMessage("Time: " . mminutes . "m Avg: " . minutes . "m " . seconds . "s Cycles: " . rerolls . " Packs: " . packs, 25, 0, 533)
LogToFile("Total time: " . mminutes . "m " . sseconds . "s Avg: " . minutes . "m " . seconds . "s Cycles: " . rerolls . " Packs: " . packs)

}
return

CheckInstances(x1, y1, x2, y2, searchVariation := "", imageName := "DEFAULT", EL := 1, safeTime := 0) {
	global winTitle, Variation, failSafe
	if(searchVariation = "")
		searchVariation := Variation
	imagePath := A_ScriptDir . "\Game\" . imageName
	x := 0
    y := 0
	confirmed := false
	
	CreateStatusMessage(imageName ".png")
	x := 0
	y := 0
	
	WinGetPos, x, y, Width, Height, %winTitle%
	; ImageSearch within the region
	ImageSearch, , , % x1 + x, % y1 + y, % x2 + x, % y2 + y, *%searchVariation% %imagePath%.png
	if (!confirmed && ErrorLevel = EL) {
		confirmed := true
	}
	if (safeTime >= 90) {
		CreateStatusMessage("Instance " . scriptName . " has been stuck " . imageName . " for 90s. EL: " . EL . " sT: " . safeTime . " Killing it...")
		restartGameInstance("Instance " . scriptName . " has been stuck " . imageName)
		safeTime := safeTime/2
		failSafe := A_TickCount
	}

	
	return (confirmed)
}

KeepSync(x1, y1, x2, y2, searchVariation := "", imageName := "DEFAULT", clickx := 0, clicky := 0, sleepTime := "", skip := false, safeTime := 0) {
	global winTitle, Variation, failSafe, confirmed
	if(searchVariation = "")
		searchVariation := Variation
	if (sleepTime = "") {
		global Delay
        sleepTime := Delay
	}
	imagePath := A_ScriptDir . "\Game\"
	click := false
	if(clickx > 0 and clicky > 0)
		click := true
	x := 0
    y := 0
	StartSkipTime := A_TickCount
	
	confirmed := false
		
	if(click) {
		adbClick(clickx, clicky)
		clickTime := A_TickCount
	}
	CreateStatusMessage(imageName ".png (" (click ? clickx ", " clicky ")": "no click)"))

	
    Loop { ; Main loop
		Sleep, 10
		x := 0
		y := 0
		if(click) {
			ElapsedClickTime := A_TickCount - clickTime
			if(ElapsedClickTime > sleepTime) {
				adbClick(clickx, clicky)
				clickTime := A_TickCount
			}
		}
		
		if (confirmed = true) {
			continue
		}
		WinGetPos, x, y, Width, Height, %winTitle%

		ImageSearch, , , % 15 + x, % 155 + y, % 270 + x, % 420 + y, *%searchVariation% %imagePath%Error1.png
		if (ErrorLevel = 0) {
			CreateStatusMessage("Error message in " scriptName " Clicking retry..." )
			LogToFile("Error message in " scriptName " Clicking retry..." )
			adbClick(82, 389)
			Sleep, %Delay%
			adbClick(139, 386)
			Sleep, 1000
		}
		ImageSearch, , , % 15 + x, % 155 + y, % 270 + x, % 420 + y, *%searchVariation% %imagePath%App.png
		if (ErrorLevel = 0) {
			CreateStatusMessage("Crashed? " scriptName " Restarting..." )
			restartGameInstance("Crashed at " imageName)
		}
		; ImageSearch within the region
		ImageSearch, , , % x1 + x, % y1 + y, % x2 + x, % y2 + y, *%searchVariation% %imagePath%%imageName%.png
		if (!confirmed && ErrorLevel = 0) {
			confirmed := true
		}
		else if(ErrorLevel = 2) {
			MsgBox, Cannot find source image %imageName% make sure the Game folder is in the same folder as the ahk or exe.
			Reload
		} else {
			if(imageName = "Skip3") {
				Sleep, 1000
			adbClick(259, 79)
			}
			ElapsedTime := (A_TickCount - StartSkipTime) // 1000
			if (ElapsedTime >= 90 || safeTime >= 90) {
				CreateStatusMessage("Instance " . scriptName . " has been stuck for 90s. Killing it...")
				restartGameInstance("Instance " . scriptName . " has been stuck at " . imageName) ; change to reset the instance and delete data then reload script
				StartSkipTime := A_TickCount
				failSafe := A_TickCount
			}
		}
		
		if(skip) {
			ElapsedTime := (A_TickCount - StartSkipTime) // 1000
			if (ElapsedTime >= skip) {
				return false
				ElapsedTime := ElapsedTime/2
				break
			}
		}
		if (confirmed = true) {
            break
        }		
		
    }
	return confirmed
}


resetWindows(){
	global Columns, winTitle
	CreateStatusMessage("Resetting window positions and sizes")
	Title := winTitle
	rowHeight := 533  ; Adjust the height of each row
	currentRow := Floor((winTitle - 1) / Columns)
	y := currentRow * rowHeight	
	x := Mod((winTitle - 1), Columns) * 277
	
	WinMove, %Title%, , 0 + x, 0 + y, 277, 537
	return true
}

killGodPackInstance(){
	global winTitle
	CreateStatusMessage("Pausing script. Found GP.")
	LogToFile("Paused God Pack instance.")
	Sleep, 10
	Pause, On 
	WinClose, %winTitle% ;in case you resume and miss that you got a god pack.
}

restartGameInstance(reason){
	global Delay, scriptName
	CreateStatusMessage("Restarting game. " reason)
	LogToFile("Restarted game for instance " scriptName " Reason: " reason, Restarted)
	adbShell.StdIn.WriteLine("am force-stop jp.pokemon.pokemontcgp")
	sleep, 1000
	adbShell.StdIn.WriteLine("am start -n jp.pokemon.pokemontcgp/com.unity3d.player.UnityPlayerActivity")
	
	Sleep, 1000
	
	if(KeepSync(0, 0, 500, 500, 40, "Restart", 140, 300, 5000, 30)) {
		Sleep, 1000
		
		adbClick(255, 83)
		
		Sleep, 1000
		
		KeepSync(123, 79, 160, 97, , "Menu")
		
		Sleep, 1000

		KeepSync(56, 312, 108, 334, , "Account2", 79, 267, 2000) ;wait for account menu
		
		Sleep, 1000

		KeepSync(86, 111, 200, 140, , "Delete", 145, 446, 2000) ;wait for delete save data confirmation
		
		Sleep, 1000

		KeepSync(84, 191, 200, 210, , "Delete2", 201, 447, 2000) ;wait for second delete save data confirmation
		
		Sleep, 1000

		KeepSync(82, 265, 173, 286, , "Delete3", 201, 369, 2000) ;wait for second 
		
		Sleep, %Delay%
		
		adbClick(143, 370)
	}
	
	Reload
}

LogToFile(message, logFile := "") {
	global scriptName
	if(logFile = "")
		logFile := A_ScriptDir . "\..\Logs\Logs" . scriptName . ".txt"
	else
		logFile := A_ScriptDir . "\..\Logs\" . logFile
	FormatTime, readableTime, %A_Now%, MMMM dd, yyyy HH:mm:ss
    FileAppend, % "[" readableTime "] " message "`n", %logFile%
}

CreateStatusMessage(Message, GuiName := 50, X := 0, Y := 60) {
	global scriptName, winTitle
	GuiName := GuiName+scriptName
	WinGetPos, xpos, ypos, Width, Height, %winTitle%
	X := X + xpos + 5
	Y := Y + ypos
	
	; Create a new GUI with the given name, position, and message
	Gui, %GuiName%:New, +AlwaysOnTop +ToolWindow -Caption 
	Gui, %GuiName%:Default
	Gui, %GuiName%:Margin, 2, 2  ; Set margin for the GUI
	Gui, %GuiName%:Font, s8  ; Set the font size to 8 (adjust as needed)
	Gui, %GuiName%:Add, Text, vStatusText, %Message%
	Gui, %GuiName%:Show, NoActivate x%X% y%Y% AutoSize, NoActivate %GuiName%
}

checkBorder() {
	global winTitle, Variation
	WinGetPos, x, y, Width, Height, %winTitle%
	ImageSearch, testx, testy, 23 + x, 282 + y, 96 + x, 284 + y, *80 %A_ScriptDir%\Game\Border.png ;first card
	if (ErrorLevel = 0) {
		CreateStatusMessage("Not a God Pack ")
		;msgbox, 1 %testx%, %testy%
	}
	else {
		ImageSearch, testx, testy, 107 + x, 282 + y, 180 + x, 284 + y, *80 %A_ScriptDir%\Game\Border.png ; second card
		if (ErrorLevel = 0) {
			CreateStatusMessage("Not a God Pack ")
			LogToFile("Second card checked. Not a God Pack ")
		}
		else {
			CreateStatusMessage("God Pack Found!!! In instance: " . scriptName . " if it's a good hit and live DM aarturoo! :)")
			godPackLog = GPlog.txt
			LogToFile("Congrats! I'd appreciate a DM on discord (aarturoo) if it's a 5/5 pack and live :) Found in instance: " . scriptName, godPackLog)
			Screenshot()
			killGodPackInstance()
		}
	}
}

adbClick(X, Y) {
	global adbShell
	X := Round(X / 277 * 540)
    Y := Round((Y - 44) / 489 * 960) 
	adbShell.StdIn.WriteLine("input tap " X " " Y)
}

ControlClick(X, Y) {
	global winTitle
	ControlClick, x%X% y%Y%, %winTitle%
}

adbName() {
	global Name, adbShell
	adbShell.StdIn.WriteLine("input text " Name )
}

adbSwipeUp() {
	global adbShell
	adbShell.StdIn.WriteLine("input swipe 309 816 309 355 60")	
	;adbShell.StdIn.WriteLine("input swipe 309 816 309 555 30")	
	Sleep, 150
}

adbSwipe() {
	global adbShell
	X1 := 35
	Y1 := 327
	X2 := 267
	Y2 := 327
	X1 := Round(X1 / 277 * 540)
    Y1 := Round((Y1 - 44) / 489 * 960) 
	X2 := Round(X2 / 277 * 540)
    Y2 := Round((Y2 - 44) / 489 * 960)
	adbShell.StdIn.WriteLine("input swipe " . X1 . " " . Y1 . " " . X2 . " " . Y2 . " 600")
	Sleep, 750
}

Screenshot() {
	global adbShell, adbPath
	SetWorkingDir %A_ScriptDir%  ; Ensures the working directory is the script's directory

	; Define folder and file paths
	screenshotsDir := A_ScriptDir "\..\Screenshots"
	if !FileExist(screenshotsDir)
		FileCreateDir, %screenshotsDir%
		
	; File path for saving the screenshot locally
	screenshotFile := screenshotsDir "\" A_Now ".png"
	
	; Capture the screenshot on the emulator
	adbShell.StdIn.WriteLine("screencap /sdcard/screenshot.png")
	Sleep, 1000  ; Wait for the screenshot command to complete

	; Pull the screenshot to the local folder
	RunWait, % adbPath . " -s 127.0.0.1:" . adbPort . " pull /sdcard/screenshot.png """ . screenshotFile . """",, Hide
	Sleep, 500  ; Wait for the pull command to complete

	; Delete the screenshot from the emulator
	adbShell.StdIn.WriteLine("rm /sdcard/screenshot.png")
	Sleep, 500  ; Shorter wait for cleanup
}



	; Pause Script
	PauseScript:
		Pause, On
	return

	; Resume Script
	ResumeScript:
		Pause, Off
		StartSkipTime := A_TickCount ;reset stuck timers
		failSafe := A_TickCount
	return

	; Stop Script
	StopScript:
		ExitApp
	return
	
	ReloadScript:
		Reload
	return
	
	TestScript:
		if(!GPTest) {
			GPTest := true
			CreateStatusMessage("Instance " . %scriptName% . " in GP Test mode.")
		}
		else {
			GPTest := false
		}
	return
	
^e::
	adbSwipe()
return
