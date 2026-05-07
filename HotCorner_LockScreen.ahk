#Requires AutoHotkey v2.0

; ============================================================
; HotCorner_LockScreen.ahk
; 触发角锁屏 - 左下角（Deskflow 多屏环境）
; 鼠标移到左下角停留 300ms 后自动锁定 Windows
;
; 需要覆盖两套坐标系：
;   1. Deskflow 连接时：Windows 屏幕在 Ubuntu 左侧，坐标为负数
;   2. Deskflow 断开时（锁屏/重连期间）：回落到 Windows 本机坐标
; ============================================================

DWELL_TIME := 300   ; 停留触发时间（毫秒）

inCorner  := false  ; 鼠标当前是否在角落内
enterTime := 0      ; 鼠标进入角落的时间戳
triggered := false  ; 已触发锁屏，等待鼠标离开角落后才能再次触发

SetTimer CheckCorner, 100

; 判断鼠标是否在左下角触发区域内
IsInCorner(mx, my) {
    ; Deskflow 连接时的坐标系
    ; 极限坐标实测：mx=-1299, my=202，留 40px 余量
    ; 屏幕布局变动后需重新测量
    deskflow := (mx <= -1259 && my >= 162)

    ; Windows 本机坐标系（Deskflow 断开后）
    ; 极限坐标实测：mx=-264, my=923
    native := (mx >= -300 && mx <= -230 && my >= 880)

    return (deskflow || native)
}

CheckCorner() {
    global inCorner, enterTime, triggered, DWELL_TIME

    MouseGetPos &mx, &my

    if (IsInCorner(mx, my)) {
        if (triggered)
            return
        if (!inCorner) {
            ; 首次进入角落，记录时间
            inCorner  := true
            enterTime := A_TickCount
        } else if (A_TickCount - enterTime >= DWELL_TIME) {
            ; 停留超过 DWELL_TIME，触发锁屏
            triggered := true
            inCorner  := false
            enterTime := 0
            DllCall("LockWorkStation")
        }
    } else {
        ; 鼠标离开角落，重置所有状态
        inCorner  := false
        enterTime := 0
        triggered := false
    }
}