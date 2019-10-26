gdip_Init()
{
	global
	
	; Thanks to tic (Tariq Porter) for his GDI+ Library
	; http://www.autohotkey.com/forum/viewtopic.php?t=32238
	; Start gdi+
	If !pToken := Gdip_Startup()
	{
		MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
		ExitApp
	}
	
	; Create some brushes
	pPenBlack := Gdip_CreatePen("0xff000000",2) ;Black pen
	brushs:=Object()
	brushs["background"] := Gdip_BrushCreateSolid("0x44eaf0ea") ;Almost white brush for background
	
	bitmaps:=[]
	bitmaps["road"] := Gdip_CreateBitmapFromFile("road.png")
	bitmaps["car"] := Gdip_CreateBitmapFromFile("car.png")

	
	_share.MainGuiDC := GetDC(_share.MainGuiHWND)
	
	
}



draw(posx, posy)
{
	global bitmaps, brushs, brushs
	global g_background_G, g_background_hbm, g_background_hdc, g_background_obm
	global g_foreground_G, g_foreground_hbm, g_foreground_hdc, g_foreground_obm
	global hbm, hdc, obm, G
	static oldGUI_W
	static oldGUI_H
	static oldIterationTimer
	
	
	if (oldGUI_W!=_share.widthofguipic or oldGUI_H!=_share.heightofguipic)
	{
		oldGUI_W:=_share.widthofguipic
		oldGUI_H:=_share.heightofguipic
		needToRedrawEverything:=true
		
		;delete old bitmaps	
		if (g_foreground_G)
		{
			DeleteObject(g_foreground_hbm)
			DeleteDC(g_foreground_hdc)
			Gdip_DeleteGraphics(g_foreground_G)
			g_foreground_G:=""
		}
	}
	
	
	if not g_foreground_G
	{
		g_foreground_hbm := CreateDIBSection(_share.widthofguipic, _share.heightofguipic)
		g_foreground_hdc := CreateCompatibleDC()
		g_foreground_obm := SelectObject(g_foreground_hdc, g_foreground_hbm)
		g_foreground_G := Gdip_GraphicsFromHDC(g_foreground_hdc)
		Gdip_SetSmoothingMode(g_foreground_G, 4) ;We will also set the smoothing mode of the graphics to 4 (Antialias) to make the shapes we use smooth
	}

	carw = 70 ; automatisch
	carh = 100
	cary1:=_share.heightofguipic * 1300 / 3340
	cary2:=_share.heightofguipic * 2818 / 3340
	cary:=(cary2-cary1)*posy + cary1 - carh/2
	carx := _share.widthofguipic / 2 + _share.widthofguipic * posx * 0.1 - carw /2 
	
	Gdip_FillRectangle(g_foreground_G, brushs["background"], 0, 0, _share.widthofguipic,_share.heightofguipic)
	Gdip_DrawImage(g_foreground_G, bitmaps["road"], 0, 0, _share.widthofguipic,_share.heightofguipic)
	Gdip_DrawImage(g_foreground_G, bitmaps["car"], carx, cary, carw, carh)
	
;~ ;Show the image
	BitBlt(_share.MainGuiDC, 0, 0, _share.widthofguipic, _share.heightofguipic, g_foreground_hdc, 0, 0)

	
}