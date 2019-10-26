#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
CoordMode,tooltip,screen

global _share
_share:=[]
DEG_IN_RAD := 0.0174533

#include gui.ahk
#include draw.ahk
#include <gdip>

gui_play_init()
gdip_Init()

FileRead,coordinateslink, coordinateslink.txt
rootcoordinate1lat:=48.4795867
rootcoordinate1lon:=7.921582
rootcoordinate2lat:=48.4790187
rootcoordinate2lon:=7.921641

rootcoordinate1x:=793 * 100 * rootcoordinate1lon
rootcoordinate1y:=1112 * 100  * rootcoordinate1lat
rootcoordinate2x:=793 * 100 * rootcoordinate2lon
rootcoordinate2y:=1112 * 100  * rootcoordinate2lat

distRoots := dist(rootcoordinate1lon, rootcoordinate1lat, rootcoordinate2lon, rootcoordinate2lat)

log("rootcoordinate1lon " rootcoordinate1lon " rootcoordinate1lat " rootcoordinate1lat " rootcoordinate2lon " rootcoordinate2lon " rootcoordinate2lat " rootcoordinate2lat)
log("rootcoordinate1y " rootcoordinate1y " rootcoordinate1x " rootcoordinate1x " rootcoordinate2x " rootcoordinate2x " rootcoordinate2y " rootcoordinate2y)

root1x:=0
root1y:=0
root2xUnrotated:= (rootcoordinate2x - rootcoordinate1x)
root2yUnrotated:= (rootcoordinate2y - rootcoordinate1y)

log("root1x " root1x " root1y " root1y " root2xUnrotated " root2xUnrotated " root2yUnrotated " root2yUnrotated)

angle:=atan(root2xUnrotated / root2yUnrotated)

log("angle " angle)

root2x:=root2xUnrotated * cos(angle) - root2yUnrotated * sin(angle)
root2y:=root2xUnrotated * sin(angle) - root2yUnrotated * cos(angle)

log("root1x " root1x " root1y " root1y " root2x " root2x " root2y " root2y)

Loop
{
	sleep 300
	URLDownloadToFile,% coordinateslink, coordinates.txt
	FileRead, coordinates, coordinates.txt
	if not coordinates
	{
		sleep 1000
		continue
	}
	if (coordinates != oldcoordinates)
	{
		
	
		oldcoordinates := coordinates
		
		StringSplit,coordinates,coordinates,% ","
		coordinateLat:=coordinates1
		coordinateLon:=coordinates2
		
		
		log("coordinateLon " coordinateLon " coordinateLat " coordinateLat)

		coordinatex:=793 * 100 * coordinateLon
		coordinatey:=1112 * 100 * coordinateLat
		
		log("coordinatex " coordinatex " coordinatey " coordinatey)
		
		coordinatex:=coordinatex - rootcoordinate1x
		coordinatey:=coordinatey - rootcoordinate1y
		
		log("diff coordinatex " coordinatex " coordinatey " coordinatey)
		
		pos1x:= coordinatex * cos(angle) - coordinatey * sin(angle)
		pos1y:= coordinatex * sin(angle) - coordinatey * cos(angle)
		
		log("pos1x " pos1x " pos1y " pos1y)
		
		pos1x := pos1x / root2y
		pos1y := pos1y / root2y
		
		log("normalized pos1x " pos1x " pos1y " pos1y)
		;~ ToolTip,% pos1x " " pos1y , 10, 10
		
		;~ distToRoot1 := dist(rootcoordinate1lon, rootcoordinate1lat, coordinateLon, coordinateLat)
		;~ distToRoot2 := dist(rootcoordinate2lon, rootcoordinate2lat, coordinateLon, coordinateLat)
		
		;~ relDist:=distRoots / (distToRoot1 - distToRoot2)
		;MsgBox,,a,% relDist, 2
	}
	IfWinActive,% "ahk_id " _share.MainGuiHWND
	{
		WinGetPos,winx, winy,,,% "ahk_id " _share.MainGuiHWND
		tooltiptext:="posCar2 : " coordinateLat ", " coordinateLon "`n"
		tooltiptext.="posLights1 : " rootcoordinate1lat ", " rootcoordinate1lon "`n"
		tooltiptext.="distLights1 : " dist(rootcoordinate1lat, rootcoordinate1lon, coordinateLat, coordinateLon) " m`n"
		tooltiptext.="posLights2 : " rootcoordinate2lat ", " rootcoordinate2lon "`n"
		tooltiptext.="distLights2 : " dist(rootcoordinate2lat, rootcoordinate2lon, coordinateLat, coordinateLon) " m`n"
		ToolTip,% tooltiptext, % winx+10,% winy+30
	}
	else
	{
		ToolTip,
	}
	draw(pos1x, pos1y)
}


dist(lat1, lon1, lat2, lon2)
{
	global DEG_IN_RAD
	lat1 *= DEG_IN_RAD
	lon1 *= DEG_IN_RAD
	lat2 *= DEG_IN_RAD
	lon2 *= DEG_IN_RAD
	dist := 6378.388 * acos(sin(lat1) * sin(lat2) + cos(lat1) * cos(lat2) * cos(lon2 - lon1)) * 1000
	return dist
}


log(text)
{
	global
	if not logfilename
	{
		logfilename=%a_scriptdir%\Log.txt
		FileDelete, % logfilename
	}
	
	FileAppend,% text "`n",% logfilename
	if errorlevel
	{
		FileAppend,% text "`n",% logfilename
		;MsgBox Kann Logdatei nicht schreiben nach %logfilename%
	}
	
	guiLog:=text "`n" guiLog
	guicontrol,,guiLog,% guiLog
	
}