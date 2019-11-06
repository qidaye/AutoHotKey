While(True)
{
	MouseGetPos, xpos, ypos 
	MouseMove, xpos + 1, ypos + 1
	MouseMove, xpos, ypos
	Sleep 60000
}
