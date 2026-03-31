#Requires AutoHotkey v2.0

global isLocked := false

; 注册会话通知（必须，否则收不到 WM_WTSSESSION_CHANGE）
NOTIFY_FOR_THIS_SESSION := 0
hWnd := A_ScriptHwnd
DllCall("Wtsapi32.dll\WTSRegisterSessionNotification", "Ptr", hWnd, "UInt", NOTIFY_FOR_THIS_SESSION)

; 脚本退出时注销
OnExit((*) => DllCall("Wtsapi32.dll\WTSUnRegisterSessionNotification", "Ptr", A_ScriptHwnd))

OnMessage(0x02B1, OnSessionChange)

OnSessionChange(wParam, lParam, msg, hwnd) {
    if (wParam = 0x7) {        ; WTS_SESSION_LOCK
        global isLocked := true
    } else if (wParam = 0x8) { ; WTS_SESSION_UNLOCK
        global isLocked := false
    }
}

Loop {
    if !isLocked {
        MouseGetPos &xpos, &ypos
        MouseMove xpos + 1, ypos + 1
        MouseMove xpos, ypos
    }
    Sleep 60000
}