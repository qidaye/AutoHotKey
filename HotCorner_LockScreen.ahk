#Requires AutoHotkey v2.0

; ============================================================
; HotCorner_LockScreen.ahk
; 触发角锁屏 - 左下角（Deskflow 多屏环境）
; 鼠标移到左下角停留 300ms 后自动锁定 Windows
;
; 覆盖三套坐标系：
;   1. Deskflow 连接未点击：虚拟坐标，左下角约 (-1339, 202)
;   2. Windows 点击后本机坐标：左下角约 (0, 59)
;   3. 切换后本机偏移坐标：左下角约 (2, 1201)
; 如屏幕布局变动，需重新测量后修改 IsInCorner 中的坐标值
; ============================================================

DWELL_TIME := 300   ; 停留触发时间（毫秒）

inCorner  := false  ; 鼠标当前是否在角落内
enterTime := 0      ; 鼠标进入角落的时间戳
triggered := false  ; 已触发锁屏，等待鼠标离开角落后才能再次触发

SetTimer CheckCorner, 100

IsInCorner(mx, my) {
    ; 状态1：Deskflow 连接未点击，虚拟坐标
    deskflow := (mx <= -1299 && my >= 162)

    ; 状态2：Windows 点击后本机坐标
    native1  := (mx <= 10 && my <= 70)

    ; 状态3：切换后本机偏移坐标
    native2  := (mx <= 12 && my >= 1160)

    return (deskflow || native1 || native2)
}

CheckCorner() {
    global inCorner, enterTime, triggered, DWELL_TIME

    MouseGetPos &mx, &my

    if (IsInCorner(mx, my)) {
        if (triggered)
            return
        if (!inCorner) {
            inCorner  := true
            enterTime := A_TickCount
        } else if (A_TickCount - enterTime >= DWELL_TIME) {
            triggered := true
            inCorner  := false
            enterTime := 0
            DllCall("LockWorkStation")
        }
    } else {
        inCorner  := false
        enterTime := 0
        triggered := false
    }
}