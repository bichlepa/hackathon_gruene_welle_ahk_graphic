#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

lat1:=48.47937 * 0.0174533
lon1:=7.92174 * 0.0174533
lat2:=48.4786 * 0.0174533
lon2:=7.92166 * 0.0174533

;~ dist := 6378.388 * acos( sin(latDyn) * sin(latStat) + cos(latDyn) * cos(latStat) * cos(lonStat - lonDyn) )
dist:=6378.388 * acos(sin(lat1) * sin(lat2) + cos(lat1) * cos(lat2) * cos(lon2 - lon1))

MsgBox % dist