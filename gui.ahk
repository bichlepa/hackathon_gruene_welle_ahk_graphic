
gui_play_init()
{
	global
	gui,MainGUI:default
	gui,-dpiscale
	;~ gui,add,picture,vPicFlow hwndPicFlowHWND x0 y0 0xE hidden gclickOnPicture ;No picture needed anymore
	;~ gui,add,StatusBar,hwndStatusbarHWND
	;~ _share.hwnds["editGUIStatusbar" FlowID] := StatusbarHWND
	;~ _share.hwnds["editGUIStatusbar" Global_ThisThreadID] := StatusbarHWND
	;~ gui,add,hotkey,hidden hwndEditControlHWND ;To avoid error sound when user presses keys while this window is open
	;~ _share.hwnds["editGUIEditControl" FlowID] := EditControlHWND
	;~ _share.hwnds["editGUIEditControl" Global_ThisThreadID] := EditControlHWND
	gui +resize

	;This is needed by GDI+
	gui +lastfound
	gui,+HwndMainGuiHWND
	
	widthofguipic:=0.3*A_ScreenWidth
	heightofguipic:=0.9*A_ScreenHeight
	gui,show, w%widthofguipic% h%heightofguipic%
	
	_share.MainGuiHWND := MainGuiHWND
	_share.widthofguipic := widthofguipic
	_share.heightofguipic := heightofguipic
	return
	MainGUIGUIClose:
	ExitApp
	return
	
}

MainGUIGuiSize(GuiHwnd, EventInfo, Width, Height)
{
	
	_share.widthofguipic := Width
	_share.heightofguipic := Height
	
}

gui_play_show()
{
	global
	static firstcall := true
	if firstcall
	{
		gui,MainGUI:show, % "w" _share.widthofguipic+1 " h" _share.heightofguipic
		gui,MainGUI:show, % "w" _share.widthofguipic " h" _share.heightofguipic,% _field.name
		firstcall:=false
	}
	else
	{
		gui,MainGUI:show, ,% "PABI Logical - "_field.name
	}
	
}

gui_play_hide()
{
	global
	gui,MainGUI:hide
}