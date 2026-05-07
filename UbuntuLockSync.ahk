#Requires AutoHotkey v2.0

; ============================================================
; UbuntuLockSync.ahk
; 监听 Ubuntu 锁屏状态，联动锁定 Windows
; 每 2 秒通过 scp 轮询一次 Ubuntu 的锁屏状态文件
; ============================================================

wasUbuntuLocked := false

SetTimer PollUbuntuLock, 2000

PollUbuntuLock() {
    global wasUbuntuLocked

    tmpFile := A_Temp . "\lock_status.txt"
    cmd     := 'scp -q ubuntu:~/.lock_status "' . tmpFile . '"'

    RunWait cmd,, "Hide"

    if !FileExist(tmpFile)
        return

    output   := Trim(FileRead(tmpFile))
    isLocked := (output = "1")

    if (isLocked && !wasUbuntuLocked) {
        ; Ubuntu 刚锁屏，Windows 跟着锁
        wasUbuntuLocked := true
        DllCall("LockWorkStation")
    } else if (!isLocked) {
        ; Ubuntu 已解锁，重置状态
        wasUbuntuLocked := false
    }
}