#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#MaxHotkeysPerInterval 140 ;default is 70 per 2000 ms
;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
;SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;#KeyHistory 1
;		====================Key shortcuts for Able Brown=================================

; F1::
; WinGet windows, List
; Loop %windows%
; {
	; id := windows%A_Index%
	; WinGetTitle wt, ahk_id %id%
	; r .= wt . "`n"
; }
; MsgBox %r%
; return
; F1::
; a := -33.33
; var1 := Floor(a)
; var2 := Ceil(a)
; MsgBox %var1% %var2%
; return
;========================================================= path variables

ChromePath = C:\Program Files (x86)\Google\Chrome\Application\chrome.exe
; FirefoxPath = C:\Program Files\Mozilla Firefox\firefox.exe
FirefoxPath = C:\Program Files\Pale Moon\palemoon.exe


;========================================================= reload script when script file is changed

;STARTOFSCRIPT
SetTimer,UPDATEDSCRIPT,1000

UPDATEDSCRIPT:
FileGetAttrib,attribs,%A_ScriptFullPath%
IfInString,attribs,A
{
FileSetAttrib,-A,%A_ScriptFullPath%
; SplashTextOn,,,Updated script,
ToolTip, reloaded
SetTimer, CloseToolTip, -500
Sleep,500
Reload
}
Return
;ENDOFSCRIPT  




;========================================================= mouse gestures, F15/F20 [[

F20:: ; ring click
F20 Up::
F15:: 		;g14
F15 Up::
;G10 = F21

	GetKeyState,F20state,F20,P
	GetKeyState,F15state,F15,P

	if !MouseControl
	{
		CoordMode Mouse, Screen     ; absolute coordinates
		SetMouseDelay -1            ; fastest action
		MouseGetPos x0, y0          ; get initial mouse pointer location
		SetTimer WatchMouse, 1      ; run the subroutine fast (10..16ms)
		MouseControl = 1
		SetTimer HotkeyRestore, off
		Hotkey, LButton, DoNothing, On
		Hotkey, RButton, DoNothing, On
		Hotkey, MButton, DoNothing, On
		Hotkey, PgUp, DoNothing, On
		Hotkey, F21, DoNothing, On

		Hotkey, WheelUp, WheelVolumeUp, On
		Hotkey, WheelDown, WheelVolumeDown, On
	}

	if (F20state = "U" && F15state = "U")
	{
		SetTimer WatchMouse, off
		MouseControl = 0
		Hotkey, LButton, Off
		Hotkey, MButton, Off
		Hotkey, PgUp, Off
		Hotkey, WheelUp, Off
		Hotkey, WheelDown, Off
		SetTimer HotkeyRestore, -500 ;750

		SoundChanged := 0
	}

Return

WatchMouse:

	GetKeyState,F15state,F15,P
	GetKeyState,F20state,F20,P

	GetKeyState,F21state,F21,P
	GetKeyState,RBstate,RButton,P
	GetKeyState,LBstate,LButton,P
	GetKeyState,MBstate,MButton,P

	GetKeyState,PgDnstate,PgDn,P
	GetKeyState,PgUpstate,PgUp,P

	SetMouseDelay -1            ; fastest action								Mouse gesture section
	CoordMode Mouse, Screen     ; absolute coordinates
	MouseGetPos x, y         ; get current mouse position

	Delta_x := abs(x-x0)
	Delta_y := abs(y-y0)

	if (Delta_x > Delta_y) { ; to prevent 'double inputs',
		if (x > x0)
			R := 1
		else R := 0
		if (x < x0)
			L := 1
		else L := 0
	}
	else {
		L := 0
		R := 0
	}

	if (Delta_y > Delta_x) {
		if (y > y0)
			D := 1
		else D := 0
		if (y < y0)
			U := 1
		else U := 0
	}
	else {
		D := 0
		U := 0
	}

	;========================================= F15, scrolling


	if (F15state = "D" && F20state = "U") {

		;if (F21state = "D") ; hold down F21 and F15 to scroll horizontally
		;{
			if (R && Delta_x > 1) {			; right
				send {WheelRight 1}
			}
			if (L && Delta_x > 1) {			; left
				send {WheelLeft 1}
			}
		;}

		if (D && Delta_y > 1) {			; down
			if (PgUpstate = "D")
				send {WheelDown 5}
			else
				send {WheelDown 1}
		}
		if (U && Delta_y > 1) {			; up
			if (PgUpstate = "D")
				send {WheelUp 5}
			else
				send {WheelUp 1}
		}

	}

	;========================================= tab control

	if (F15state = "U") {


		if (RBstate = "D" && !Lockout) {
			LockoutTime := 150
			if  (R && Delta_x > 2) {  ; next tab
				Send ^{Tab}
				Lockout := 1
				SetTimer Lockout_lab, -%LockoutTime%
			}
			else if  (L && Delta_x > 2) {  ; previous tab
				Send ^+{Tab}
				Lockout := 1
				SetTimer Lockout_lab, -%LockoutTime%
			}
			else if  (U && Delta_y > 5) {  ; refresh tab
				Send, ^+r
				Lockout := 1
				SetTimer Lockout_lab, -%LockoutTime%
			}
			else if  (D && Delta_y > 5) {  ; close tab
				Send, ^w
				Lockout := 1
				SetTimer Lockout_lab, -%LockoutTime%
			}
		}

		;========================================= LBstate
		if (LBstate = "D") {
			if  (R && Delta_x > 10) {
				Run, C:\Users\user0\Desktop\downloads
				SetTimer WatchMouse, off
			}
			else if  (L && Delta_x > 10) { ; search
				GuiDelay := 50
				Send, ^c
				Sleep, GuiDelay
				Send, ^t
				Sleep, GuiDelay
				Send, ^v
				Sleep, GuiDelay
				SendInput {Enter}
				; Send, ^c
				; Sleep, 50
				; Run, %FirefoxPath% ?%clipboard%

				SetTimer WatchMouse, off
			}
			else if  (U && Delta_y > 10) {
				Send, ^+t
				SetTimer WatchMouse, off
			}
			else if  (D && Delta_y > 10) {
				; MouseMove x0, y0, 0
				; Send {RButton} ;save image firefox
				; Sleep, 100
				; Send, v
				Run, explorer.exe /n`, ;open my computer
				SetTimer WatchMouse, off
			}
		}
		;========================================= F21state (forward)

		if (F21state = "D") {
			if (!Lockout) {
				if  (R && Delta_y > 1) {
					Send {End}
					SetTimer Lockout_lab, -150
					Lockout := 1

				}
				else if  (L && Delta_y > 1) {
					Send {Home}
					SetTimer Lockout_lab, -150
					Lockout := 1
				}
				else if  (U && Delta_x > 1) {
					WinMaximize, A
					SetTimer Lockout_lab, -150
					Lockout := 1
					SetTimer WatchMouse, off
				}
				else if  (D && Delta_x > 1) { ;close window
					;Send, !{F4}
					SetTimer Lockout_lab, -150
					Lockout := 1
					SetTimer WatchMouse, off
				}
			}
		}
	}
	MouseMove x0, y0, 0         ; set mouse to original location

	; if (SoundChanged) { ;update volume level tooltip
		; SoundGet, master_volume
		; master_volume := Round(master_volume)
		; tooltip, %master_volume%
		; SoundChanged := 0
	; }

	if SoundChanged ;update volume level tooltip
		Goto, CheckSound

Return

;========================================================= gesture labels ]] [[

Lockout_lab:
	Lockout:=0
return

HotkeyRestore:
	Hotkey, RButton, Off
	Hotkey, F21, Off
	tooltip,
return

DoNothing:
return

WheelVolumeUp:
	GetKeyState,RBstate,RButton,P
	GetKeyState,LBstate,LButton,P
	if (RBstate = "D") {
		SoundSet +8
	}
	else if (LBstate = "D")
		Send, {PgUp}
	else {
		SoundSet +1
		SoundGet, master_volume
		if  (master_volume > 6) {
			SoundSet +3
		}
	}
	Goto, CheckSound
return
WheelVolumeDown:
	GetKeyState,RBstate,RButton,P
	GetKeyState,LBstate,LButton,P
	if (RBstate = "D")
		SoundSet -2
	else if (LBstate = "D")
		Send, {PgDn}
	else
		SoundSet -1
		SoundGet, master_volume
		if  (master_volume > 6) {
			SoundSet -3
		}
	Goto, CheckSound
return

CheckSound: ;sound level tooltip
~Volume_Down Up::
~Volume_Up Up::
	SoundGet, master_volume
	master_volume := Round(master_volume)
	tooltip, %master_volume%
	SetTimer, CloseToolTip, -500
return

; ]]

;========================================================F13 Layer [[

F13::
F13tap = 1
SetTimer, F13TapTimeout, -125
KeyWait, F13
if (F13tap) {
	Send, {Enter}
}
return

F13TapTimeout:
F13tap = 0
return

#If (GetKeyState("F13"))


	1::
	Send ^{-}
	return
	2::
	Send ^{=}
	return
	3::
	Send ^{0}
	return	
	
	4::
	Send {PgUp}
	return
	5::
	Send {PgDn}
	return
	
	w::Up
	a::Left
	s::Down
	d::Right

	
	e:: ;previous tab
		Send ^+{Tab}
	return
	r:: ;next tab
		Send ^{Tab}
	return
	f::
		Send ^{w}
	return

	space::Backspace
	q::Delete

	; m:: ;capture mouse coordinates
		; CoordMode, Mouse, Screen
		; MouseGetPos, xpos, ypos
		; Msgbox, The cursor is at X%xpos% Y%ypos%.
		; FileAppend,`n%xpos%,C:\Users\user0\Desktop\documents\clip3.jpg
		; FileAppend,`n%ypos%,C:\Users\user0\Desktop\documents\clip3.jpg

	; return

	c::
	Run, explorer.exe /n`, ;open My Computer in explorer.exe
	return

	m:: ;shrink taskbar
		CoordMode, Mouse, Screen
		; Send, #d
		; sleep, 100
		MouseClickDrag Left , 52, 183, 35, 182, 10
	return

	esc::capslock

	t::
		Send, user
		sleep,100
		Send, {tab}
		sleep,100
		Send, pass
		sleep,100
		Send, {Enter}
	return

	z::
		Send, {(}
	return

	x::
		Send, {)}
	return

#If (GetKeyState("F13"))
; ]]


;========================================================F14 Layer [[

; F14::
; F14tap = 1
; SetTimer, F14TapTimeout, -125
; KeyWait, F14
; if (F14tap) {
	; Send, #d
; }
; return

; F14TapTimeout:
; F14tap = 0
; return



#If (GetKeyState("F14"))

	;	Internet Shortcuts:




	3::
	Run, %FirefoxPath% http://www.wolframalpha.com/
	return

	4::
	Run, %ChromePath% https://www.usaa.com/inet/ent_logon/Logon
	return

	5::
	Run, %FirefoxPath% http://www.amazon.com/
	return

	6::
		Run, %ChromePath% https://mail.google.com/
	return

	7::
	Shutdown, 0 ; log off
	return

	8::
	Shutdown, 2 ; restart
	return

	9::
	Shutdown, 1 ;normal shutdown
	return

	0::
	Shutdown, 12 ;force
	return


	;	Folder Shortcuts:
	
	z::
	Run, explorer.exe /n`, ;open My Computer in explorer.exe
	return


	j::
		Run, C:\Users\user0\Desktop\downloads
	return

	;	Application Launch

	*a::
	GetKeyState, mstate, LAlt
	if mstate = D
	{
		Run, C:\Program Files\Notepad++\notepad++.exe C:\Users\user0\Desktop\documents\autohotkey\able_black.ahk
		Return
	}
	;Run, C:\Shortcuts\SystemExplorer.lnk
	Run, C:\Windows\System32\taskmgr.exe
	return

	c:: ;open current page in chrome
	Send, ^l
	Sleep, 100
	Send, ^c
	Sleep, 100
	Run, %ChromePath% %clipboard%
	return
	f::
		if (FullWidth) {
			FullWidth := 0
			tooltip, FullWidth mode off
			SetTimer, CloseToolTip, -500
			return
		}
		FullWidth := 1 ;initiate FullWidth mode
		tooltip, FullWidth mode on
		SetTimer, CloseToolTip, -500
		Return

	w:: ;open in firefox
	Send, ^l
	Sleep, 100
	Send, ^c
	Sleep, 100
	Run, %FirefoxPath% %clipboard%
	return

	*r::
		GetKeyState, mstate, LAlt
		if (mstate = "D")
			Send, ^s
		tooltip, reloaded
		sleep, 250
		Reload
	Return

	*s::
	if GetKeyState("Ctrl")
	{
		UIDelay = 150 					;save images from tabs
		Random, rand, 1, 100
		tooltip, saving from tabs
		SetTimer, CloseToolTip, -1500
		i=2
			while GetKeyState("F14")
			{

				Send, {RButton}
				Sleep, UIDelay
				Send, {v}
				Sleep, UIDelay
				Send, {enter}
				Sleep, 100
				Send, {enter}
				Sleep, 500
				Send ^{w}
				Sleep, UIDelay
			}
	}
	else
		;Run, S:\documents\Software\windows\misc
	return


	;	Misc:

	Backspace::
		tooltip, Exiting
		SetTimer ExitScript, -500
	return

	Space::
		Send {LWin}
	return

	;========================================================= clipboard manager

	; ~^c::
	; sleep, 100
	; if clipboard = ""
	; {
		; return
	; }
	; if clipboard = %clpb1%
	; {
	; }
	; else
	; {
		; clpb1 := clipboard
		;new content
		; FileAppend,`n%clpb1%,S:\Documents\AHK Clipboard.jpg
		; tooltip, saved %clpb1%
		; SetTimer CloseToolTip, 500

	; }
	; return

	^v::
		Run, C:\Program Files\Notepad++\notepad++.exe C:\Users\user0\Desktop\documents\clip2.jpg
	return



	t:: ; switch to and run keil code
		sleep, 200
		Send, {F7}
		sleep, 1000
		Send ^{F5}
		sleep, 300
		Send {Enter}
		sleep,300
		Send {F5 10}
	return


#If


GuiClose: ;pressed the x button
GuiEscape: ;pressed escape while gui was open
Gui Destroy ;destroy the gui and release all variables
return

ExitScript:
	ExitApp
return

; ]]

 ~^c::

	GetKeyState, F14state, F14
	Send, ^c
	sleep, 100
	if (clipboard = "") {
		;;it's a picture, file etc.
		return
	}
	; else if (clipboard = clpb1) {
		;already exists, ignore it
	; }
	if (F14state = "D") {
		clpb1 := clipboard
		FileAppend,`n%clpb1%,C:\Users\user0\Desktop\documents\clip2.jpg
		tooltip, saved %clpb1% to clip2
		SetTimer CloseToolTip, 500
		return
	}
	else {
		clpb1 := clipboard
		FileAppend,`n%clpb1%,C:\Users\user0\Desktop\documents\clip1.jpg
	}
	return


;=====================================================misc and labels [[

 

F22::
  Send ^+{Tab}
return ;g600 mouse wheel left, mouse back button
F23::
  Send, ^{tab} ;g600 mouse wheel right, mouse forward button  
Return

~RCtrl::
KeyWait, RCtrl, T0.2
If (!ErrorLevel) { ;if tapped
	Send #d
}					;you could add a second condition if it was held for longer
KeyWait, RCtrl
return

; ~LShift::
; KeyWait, LShift, T0.2
; If (!ErrorLevel) { ;if tapped
	; Send {esc}
; }					;you could add a second condition if it was held for longer
; KeyWait, LShift
; return

; ~RShift::
; KeyWait, RShift, T0.2
; If (!ErrorLevel) { ;if tapped
	; Send !{Tab}
; }					;you could add a second condition if it was held for longer
; KeyWait, RShift
; return


; tap_count := 0

; ~RCtrl:: ; multitap
; start_tap:
; KeyWait, RCtrl, T0.5 ;wait for key to be released before proceeding with thread, however if take too long, proceed anyway and set errorlevel=1
; If (!ErrorLevel) { ;if tapped
	; ++tap_count
	; goto, start_tap
; }					;you could add a second condition if it was held for longer
; KeyWait, RCtrl
; goto, tap_execute
; return

; tap_execute:
	; if (tap_count=1) {
		; tooltip, 1
	; }
	; if (tap_count=2) {
		; tooltip, 2
	; }
	; if (tap_count=3) {
		; tooltip, 3
	; }
	; tap_count := 0
; return


F16::
	Send, #d
return


; RAlt::
	; Send, {MButton}
; return

*RAlt::
	Send {MButton Down} ;Press left mouse button

	KeyWait RAlt ;wait for release of "a"

	Send {MButton Up} ;release Left Mouse button
return


CloseToolTip:
tooltip,
return


#Hotstring C * ? ;greek input hotstring replace
:://alpha::α
:://beta::β
:://gamma::γ
:://delta::δ
:://Delta::Δ
:://epsilon::ε
:://zeta::ζ
:://eta::η
:://theta::θ
:://kappa::κ
:://lambda::λ
:://mu::μ
:://xi::ξ
:://sigma::σ
:://Sigma::Σ
:://pi::π
:://rho::ρ
:://tau::τ
:://phi::φ
:://Phi::Φ
:://chi::χ
:://psi::ψ
:://Psi::Ψ
:://omega::ω
:://Omega::Ω
:://ohm::Ω
:://deg::°

#Hotstring *0 ?0 C0


;=====================================================FullWidth mode [[
#If (FullWidth)
	+a::Send {Ａ} ; Alpha
	+b::Send {Ｂ} ; Beta
	+c::Send {Ｃ} ; Gamma
	+d::Send {Ｄ} ; Delta
	+e::Send {Ｅ} ; Epislon
	+f::Send {Ｆ} ; Phi
	+g::Send {Ｇ} ; Gamma
	+h::Send {Ｈ} ; Eta
	+i::Send {Ｉ} ; Iota
	+j::Send {Ｊ} ; Theta
	+k::Send {Ｋ} ; Kappa
	+l::Send {Ｌ} ; Lambda
	+m::Send {Ｍ} ; Mu
	+n::Send {Ｎ} ; Nu
	+o::Send {Ｏ} ; Omicron
	+p::Send {Ｐ} ; Pi
	+q::Send {Ｑ} ; Xi
	+r::Send {Ｒ} ; Rho
	+s::Send {Ｓ} ; Sigma
	+t::Send {Ｔ} ; Tau
	+u::Send {Ｕ} ; Upsilon
	+v::Send {Ｖ} ; Omega
	+w::Send {Ｗ} ; Omega
	+x::Send {Ｘ} ; Chi
	+y::Send {Ｙ} ; Psi
	+z::Send {Ｚ} ; Zeta
	a::Send {ａ} ; alpha
	b::Send {ｂ} ; beta
	c::Send {ｃ} ; gamma
	d::Send {ｄ} ; delta
	e::Send {ｅ} ; epislon
	f::Send {ｆ} ; phi
	g::Send {ｇ} ; gamma
	h::Send {ｈ} ; eta
	i::Send {ｉ} ; iota
	j::Send {ｊ} ; theta
	k::Send {ｋ} ; kappa
	l::Send {ｌ} ; lambda
	m::Send {ｍ} ; mu
	n::Send {ｎ} ; nu
	o::Send {ｏ} ; omicron
	p::Send {ｐ} ; pi
	q::Send {ｑ} ; xi
	r::Send {ｒ} ; rho
	s::Send {ｓ} ; sigma
	t::Send {ｔ} ; tau
	u::Send {ｕ} ; upsilon
	v::Send {ｖ}
	w::Send {ｗ} ; omega
	x::Send {ｘ} ; chi
	y::Send {ｙ} ; psi
	z::Send {ｚ} ; zeta
#If



/*

ahk's cryptic modifier shorthand

# win
! alt
^ ctrl
+ shift
<+ left shift

https://autohotkey.com/docs/Hotkeys.htm#AltTabDetail

to assign extended function keys eg F13 to logitech software
comment out SendMode Input at the top

use F1::F16

 */
