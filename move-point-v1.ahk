; AutoHotkey v1

isLocked := false

DllCall("Wtsapi32.dll\WTSRegisterSessionNotification", "Ptr", A_ScriptHwnd, "UInt", 0)
OnExit, Cleanup
OnMessage(0x02B1, "OnSessionChange")

OnSessionChange(wParam, lParam, msg, hwnd) {
    global isLocked
    if (wParam = 0x7)
        isLocked := true
    else if (wParam = 0x8)
        isLocked := false
}

Loop {
    if !isLocked {
        MouseGetPos, xpos, ypos
        MouseMove, xpos + 1, ypos + 1
        MouseMove, xpos, ypos
    }
    Sleep, 60000
}

Cleanup:
    DllCall("Wtsapi32.dll\WTSUnRegisterSessionNotification", "Ptr", A_ScriptHwnd)
ExitApp