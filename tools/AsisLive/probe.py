# -*- coding: utf-8 -*-
"""AS-IS 실측 탐침 — 화면을 열고 조건 설정 명령을 차례로 보낸 뒤 조건 컨트롤 상태를 찍는다(규칙 설계·확인용).
  사용: python tools/AsisLive/probe.py <ID> '<JSON 목록>'   예) '[{"set":{"name":"sCalendar_planday","prop":"DateTime","value":"20260919"}},{"show":["cbo_fpplanid"]}]'
"""
import json, os, sys, time
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import asis_live_run as R

def show(host, names):
    d = host.send("dump", timeout=120, rows=-1).get("data") or {}
    for c in d.get("controls") or []:
        if not names or c.get("name") in names:
            if not names and not (c.get("type", "").split(".")[-1].startswith("Usr")): continue
            print("   ", c.get("name"), c.get("type", "").split(".")[-1], "| text=%r idx=%s sel=%r val=%r cv=%r items=%s %s" % (
                (c.get("text") or "")[:30], c.get("selected_index"), c.get("selected_text"), c.get("selected_value"), c.get("control_values"), c.get("item_count"),
                [(i if isinstance(i, str) else i.get("text")) for i in (c.get("items") or [])[:6]]), flush=True)

def main():
    sid = sys.argv[1]; ops = json.loads(sys.argv[2]) if len(sys.argv) > 2 else []
    c0, w0, base = R.env_ready()
    if c0: print("[ERROR] " + w0); return c0
    if not R.acquire_lock("probe"): print("[ERROR] lock"); return 3
    host, info, why = R.start_session(os.path.join(R.ROOT, "Doc", "asislive", "_probe_cmd_" + R.now().strftime("%H%M%S")))
    if not host: print("[ERROR] " + why); return 3
    try:
        t = R.now(); r = host.send("open", timeout=180, id=sid); print("open", r.get("ok"), r.get("error")); R.wait_quiet(t, 3, 60)
        for op in ops:
            R.touch_lock(); t = R.now()
            if "set" in op:
                r = host.send("set", timeout=90, **op["set"]); print("set", op["set"], "->", r.get("ok"), r.get("applied"), r.get("error"), flush=True); R.wait_quiet(t, 2, 40)
            elif "show" in op: show(host, op["show"])
            elif "find" in op:
                d1 = host.send("ping", timeout=20).get("dialog_count") or 0
                host.send("find", timeout=60); f = R.wait_find(host, t, d1, 120); print("find", f, flush=True)
                print("   dialogs", [x.get("text") for x in host.send("dialogs", timeout=20, **{"from": d1}).get("dialogs", [])])
                cs = [c for c in R.parse_dbprofile(t, R.now()) if not c["sp"].upper().startswith(("UP_FX_", "INSERT INTO", "PR_UI_SQL_LOG"))]
                print("   calls", [(c["sp"][:50], c["rows"]) for c in cs][:12])
            elif "calls" in op:
                pass
        host.send("close_screen", timeout=60)
    finally:
        host.stop()
        try: os.remove(os.path.join(R.ROOT, "Doc", "asislive", "_run.lock"))
        except OSError: pass

if __name__ == "__main__":
    sys.exit(main())
