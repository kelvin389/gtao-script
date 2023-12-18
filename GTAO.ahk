SetWorkingDir %A_ScriptDir%
#MaxThreadsPerHotkey 2
#SingleInstance force
#NoEnv

; GUI
gui, add, button, x125 y10 h50 w100 gExit, Exit Script
gui, add, button, x125 y70 h30 w100 gSuspend, Pause
gui, add, button, x15 y10 h50 w100 gCeoMcToggle, Toggle CEO/MC Status
gui, font, s10,
gui, Add, Text,vCEOMCText w100 h15,CEO/MC: No
gui, Add, Text,vSuspendText h20 w100,(Running)
gui, -SysMenu
gui, show, , GTA Online Script

#IfWinActive ahk_class grcWindow ; Scripts only active if GTA 5 is open

InCEOorMC := FALSE
suspended := FALSE

SettingsChanged := FALSE

; Create settings.ini with default binds if it doesnt exist
	if (!FileExist("settings.ini")) {
		MsgBox, settings.ini not found, creating file.
		
		IniWrite, INS, settings.ini, Binds, SuspendKey
		
		IniWrite, 50, settings.ini, Delay Settings, MenuSleep
		IniWrite, 25, settings.ini, Delay Settings, KeySendDelay
		IniWrite, 5, settings.ini, Delay Settings, KeyPressDuration
		
		IniWrite, F2, settings.ini, Binds, ToggleCEOMCKey
		IniWrite, ``, settings.ini, Binds, NoScopeKey
		IniWrite, F5, settings.ini, Binds, AFKKey
		IniWrite, XButton2, settings.ini, Binds, SnackMenuKey
		IniWrite, F1, settings.ini, Binds, ResetSnackBindsKey
		IniWrite, XButton1, settings.ini, Binds, QuickArmorKey
	}

; Keybindings set from ini file
	IniRead, SuspendKey, settings.ini, Bind, SuspendKey
	IniRead, MenuSleep, settings.ini, Delay Settings, MenuSleep
	IniRead, KeySendDelay, settings.ini, Delay Settings, KeySendDelay
	IniRead, KeyPressDuration, settings.ini, Delay Settings, KeyPressDuration
	
	IniRead, ToggleCEOMCKey, settings.ini, Binds, ToggleCEOMCKey
	IniRead, NoScopeKey, settings.ini, Binds, NoScopeKey
	IniRead, AFKKey, settings.ini, Binds, AFKKey
	IniRead, SnackMenuKey, settings.ini, Binds, SnackMenuKey
	IniRead, ResetSnackBindsKey, settings.ini, Binds, ResetSnackBindsKey
	IniRead, QuickArmorKey, settings.ini, Binds, QuickArmorKey
	
	if (SuspendKey = "ERROR" ) {
		IniWrite, INS, settings.ini, Binds, SuspendKey
		SettingsChanged := TRUE
	}
	if (MenuSleep = "ERROR" ) {
		IniWrite, 50, settings.ini, Binds, MenuSleep
		SettingsChanged := TRUE
	}
	if (KeySendDelay = "ERROR" ) {
		IniWrite, 25, settings.ini, Binds, KeySendDelay
		SettingsChanged := TRUE
	}
	if (KeyPressDuration = "ERROR" ) {
		IniWrite, 5, settings.ini, Binds, KeyPressDuration
		SettingsChanged := TRUE
	}
	if (ToggleCEOMCKey = "ERROR" ) {
		IniWrite, F2, settings.ini, Binds, ToggleCEOMCKey
		SettingsChanged := TRUE
	}
	if (NoScopeKey = "ERROR" ) {
		IniWrite, ``, settings.ini, Binds, NoScopeKey
		SettingsChanged := TRUE
	}
	if (AFKKey = "ERROR" ) {
		IniWrite, F5, settings.ini, Binds, AFKKey
		SettingsChanged := TRUE
	}
	if (SnackMenuKey = "ERROR") {
		IniWrite, XButton2, settings.ini, Binds, SnackMenuKey
		SettingsChanged := TRUE
	}
	if (ResetSnackBindsKey = "ERROR") {
		IniWrite, F1, settings.ini, Binds, ResetSnackBindsKey
		SettingsChanged := TRUE
	}
	if (QuickArmorKey = "ERROR") {
		IniWrite, XButton1, settings.ini, Binds, QuickArmorKey
		SettingsChanged := TRUE
	}
	if (SettingsChanged = TRUE) { ;Re-Read settings if settings were changed by program
		IniRead, SuspendKey, settings.ini, Binds, SuspendKey
		IniRead, ToggleCEOMCKey, settings.ini, Binds, ToggleCEOMCKey
		IniRead, NoScopeKey, settings.ini, Binds, NoScopeKey
		IniRead, AFKKey, settings.ini, Binds, AFKKey
		IniRead, SnackMenuKey, settings.ini, Binds, SnackMenuKey
		IniRead, ResetSnackBindsKey, settings.ini, Binds, ResetSnackBindsKey
		IniRead, QuickArmorKey, settings.ini, Binds, QuickArmorKey
	}
	
	; Initialize Delays
	SetKeyDelay, KeySendDelay, KeyPressDuration
	
	; Assign hotkeys as per above
	Hotkey, *LButton, Off ; toggle for LMB and RMB snack navigation
	Hotkey, *RButton, Off ; above
	Hotkey, *Escape, Off ; Escape closes snack menu fully and resets binds
	
	Hotkey, *%SuspendKey%, Suspend
	
	Hotkey, *%ToggleCEOMCKey%, CeoMcToggle
	Hotkey, *%NoScopeKey%, NoScope
	Hotkey, *%AFKKey%, AFK
	Hotkey, *%SnackMenuKey%, SnackMenu
	Hotkey, *%ResetSnackBindsKey%, ResetSnackBinds
	Hotkey, *%QuickArmorKey%, QuickArmor
Return

; Scripts
		
	Suspend:
		Suspend
		if (suspended = TRUE) {
			suspended := FALSE
			GuiControl, , SuspendText,(Running)
		} else {
			suspended := TRUE
			GuiControl, , SuspendText,(Paused)
		}
	return
	
	; No-Scope glitch (Revolver rapid fire)
	NoScope:
		SetKeyDelay, 0, 0
		Click Down Right
		Sleep, 32
		Send, {Space Down}
		Sleep, 103
		Send, {Space Up}
		Sleep, 1043
		Click Down Left
		Sleep, 69
		Click Up Right
		Sleep, 12
		Click Up Left
		SetKeyDelay, KeySendDelay, KeyPressDuration
	Return
	
	; Holds down S and D to walk in circles preventing AFK kick
	AFK:
		Send, {S Down}
		Send, {D Down}
		Send, {C Down}
		Sleep, 50
		Send, {C Up}
		Sleep, 250
		Send, {Shift Down}
		Sleep, 500
		Send, {Shift Up}
	Return
	
	; Opens snack menu
	SnackMenu:
		Hotkey, *LButton, Toggle ; Enable LMB and RMB to navigate snack menu
		Hotkey, *RButton, Toggle ; above
		Hotkey, *Escape, Toggle ; Escape closes snack menu fully and resets binds
		
		Send, {m}
		Sleep, %MenuSleep%
		Send, {Down}
		if (InCEOorMC = TRUE) {
			Send, {Down}
		}
		Send, {Enter}
		Send, {Down}
		Send, {Down}
		Send, {Enter}
	Return
	
	; Temporary bind to allow LMB to control snack menu
	*LButton::
		Send, {Enter}
	Return
	
	; Temporary bind to allow RMB to control snack menu	
	*RButton::
		Send, {m}
		Hotkey, *LButton, Toggle ; Disable LMB and RMB to navigate snack menu
		Hotkey, *RButton, Toggle ; above
		Hotkey, *Escape, Toggle ; Escape closes snack menu fully and resets binds
	Return
	
	; Temporary bind to allow Escape to close snack menu
	*Escape::
		Send, {m}
		Hotkey, *LButton, Toggle ; Disable LMB and RMB to navigate snack menu
		Hotkey, *RButton, Toggle ; above
		Hotkey, *Escape, Toggle ; Escape closes snack menu fully and resets binds
	Return
	
	; Restore LMB RMB and Escape to their default functions in case interaction menu is closed externally
	ResetSnackBinds:
		Hotkey, *LButton, Off
		Hotkey, *RButton, Off
		Hotkey, *Escape, Off
	Return
	
	; Equips a Super Heavy Armor
	QuickArmor:
		Send, {m}
		Sleep, %MenuSleep%
		Send, {Down}
		if (InCEOorMC = TRUE) {
			Send, {Down}
		}
		Send, {Enter}
		Send, {Down}
		Send, {Enter}
		Send, {Down}
		Send, {Down}
		Send, {Down}
		Send, {Down}
		Send, {Enter}
		Send, {m}
	Return
	
	; Close GUI script
	GuiClose:
		Exit:
			ExitApp
	Return
	
	; Toggle in CEO or MC
	CeoMcToggle:
	{
		if (InCEOorMC = TRUE) {
			InCEOorMC := FALSE
			GuiControl,,CEOMCText,CEO/MC: No
		} else {
			InCEOorMC := TRUE
			GuiControl,,CEOMCText,CEO/MC: Yes
		}
	}
	Return
	