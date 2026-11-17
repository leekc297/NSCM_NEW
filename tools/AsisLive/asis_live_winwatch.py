# -*- coding: utf-8 -*-
"""자동화 런처(AsisLive.Host)의 보이는 창 수를 30초마다 기록 — 창 쌓임 재발 감시. 인자: 로그 경로 · 감시할 python PID 파일"""
import ctypes, subprocess, sys, time
from ctypes import wintypes

u = ctypes.windll.user32
PROC = ctypes.WINFUNCTYPE(wintypes.BOOL, wintypes.HWND, wintypes.LPARAM)


def host_pids():
    o = subprocess.run(["tasklist", "/FI", "IMAGENAME eq AsisLive.Host.exe", "/FO", "CSV", "/NH"], capture_output=True, text=True, errors="replace").stdout
    return [int(l.split('","')[1]) for l in o.splitlines() if l.startswith('"AsisLive')]


def windows(pid):
    out = []

    def cb(h, l):
        p = wintypes.DWORD(); u.GetWindowThreadProcessId(h, ctypes.byref(p))
        if p.value == pid and u.IsWindowVisible(h):
            b = ctypes.create_unicode_buffer(200); u.GetWindowTextW(h, b, 200); out.append(b.value)
        return True
    u.EnumWindows(PROC(cb), 0)
    return out


def main():
    log = sys.argv[1]; idle = 0; mx = 0
    while idle < 20:                                  # 호스트가 10분 동안 없으면 끝
        ps = host_pids()
        if not ps: idle += 1
        else:
            idle = 0
            for p in ps:
                w = windows(p); mx = max(mx, len(w))
                with open(log, "a", encoding="utf-8") as f:
                    f.write("%s pid %d 창 %d 최대 %d : %s\n" % (time.strftime("%H:%M:%S"), p, len(w), mx, " / ".join(sorted(set(x for x in w if x)))[:300]))
        time.sleep(30)


if __name__ == "__main__":
    main()
