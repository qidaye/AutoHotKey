#Requires AutoHotkey v2.0

Loop {
    MouseGetPos &xpos, &ypos
    MouseMove xpos + 1, ypos + 1
    MouseMove xpos, ypos
    Sleep 60000
}