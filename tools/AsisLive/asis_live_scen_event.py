# -*- coding: utf-8 -*-
"""스크롤 · 키 입력 · 붙여넣기 분기 실행 (2026-11-14, 플랜 P6-2)

  python tools/AsisLive/asis_live_scen_event.py <ID> [ID ...] [--scroll] [--key] [--paste]     (셋 다 생략 = 셋 다)
대상  Doc/asislive/<ID>/scenarios_cov.csv 의 진입점
        스크롤     event:<그리드>.TopChange | LeftChange
        키 입력    event:<그리드·입력 상자>.KeyDown | KeyUp | KeyPress
        붙여넣기   event:<그리드>.ClipboardPasted | ClipboardPasting
방법  스크롤     조회 뒤 그리드의 보이는 첫 행을 옮기고(act scroll) 되돌린다. 속성 변경으로 이벤트가 나는지는 런처가 알려 주지 않으므로 TopChange 처리기도 직접 부른다(act raise).
      키 입력    컨트롤의 On<이벤트>(인자) 를 불러 화면이 건 처리기를 실행한다. 키 = 분기 조건식에 적힌 Keys.<이름>(e.Control 이 함께 적혔으면 Control+키), 없으면 숫자 1.
                 KeyPress 글자 = '1', 'a', 조건식에 Keys.Back 이 있으면 백스페이스. 그리드는 수정 모드 첫 행, 조건식에 이름이 나온 열(없으면 첫 보이는 열)을 활성 셀로 둔다.
      붙여넣기   수정 모드 첫 행에서 열마다 ClipboardPasted 처리기를 직접 부른다(범위 = 그 셀 1칸). 셀 값은 조회된 값 그대로다. 사용자 클립보드는 읽지도 쓰지도 않는다.
                 열 = 조건식에 이름이 나온 열, 없으면 앞쪽 보이는 열 4개까지.
      끝나면 저장하지 않고 닫는다(닫기 확인 = 저장 안 함).
안전  저장 버튼을 누르지 않는다. 대상 분기에 서버 호출이 저장 계열 이름인 분기가 있는 화면은 그 종류를 실행하지 않는다. 실행 뒤 저장 계열 호출이 기록되면 [WARN].
산출  Doc/asislive/<ID>/run_<시각>_acts_event/acts.json   (분기별 대조 asis_live_scen_cmp.py 가 읽는다 · "cellrun" 형식)
한계  처리기를 직접 부른다. 컨트롤 자체의 기본 동작(글자 입력, 셀 지우기, 실제 붙여넣기)은 일어나지 않는다. 이벤트 인자는 지정한 행·열·키 말고는 0, 빈 값이다.
      그 처리기를 불렀다는 뜻이고 어느 분기를 탔는지는 관찰(메시지·호출·그리드 변화)로만 본다. 주 그리드가 아닌 그리드는 활성 시트 첫 행만 다룬다.
"""
import csv, json, os, re, sys, time

HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
import asis_live_run as R
import asis_live_excel as X
import asis_live_scen_run as SR
import asis_live_scen_input as I
P = lambda *a: os.path.join(ROOT, *a)
csv.field_size_limit(10 ** 8)
EVT = re.compile(r"^event:(?:this\.)?([\w.]+?)[._](TopChange|LeftChange|KeyDown|KeyUp|KeyPress|ClipboardPasted|ClipboardPasting)$")
KIND = {"TopChange": "scroll", "LeftChange": "scroll", "KeyDown": "key", "KeyUp": "key", "KeyPress": "key", "ClipboardPasted": "paste", "ClipboardPasting": "paste"}
KN = {"scroll": "스크롤", "key": "키 입력", "paste": "붙여넣기"}


def targets(mid):
    """{"scroll"|"key"|"paste": {(컨트롤, 이벤트): [{"id","text"}]}, "save_like": {종류: [시나리오 ID]}}"""
    sc = SR.rd(P("Doc", "asislive", mid, "scenarios_cov.csv")) or SR.rd(P("Doc", "asislive", mid, "scenarios_src.csv"))
    out = {"scroll": {}, "key": {}, "paste": {}, "save_like": {}}
    for r in sc:
        for e in [x.strip() for x in (r.get("entry") or "").split("|") if x.strip()]:
            m = EVT.match(e)
            if not m: continue
            k = KIND[m.group(2)]; txt = " ".join(str(r.get(c) or "") for c in ("guard", "observe", "precond"))
            ctl = m.group(1).split(".")[0]; ctl = next((c for (c, _e) in out[k] if c.lower() == ctl.lower()), ctl)      # 이름 대소문자만 다른 것은 같은 컨트롤
            lst = out[k].setdefault((ctl, m.group(2)), [])
            if r["scenario_id"] not in [x["id"] for x in lst]: lst.append({"id": r["scenario_id"], "text": txt})
            if any(I.SAVE.search(x.split(".")[-1]) for x in (r.get("endpoints") or "").split(";") if x.strip()) and r["scenario_id"] not in out["save_like"].setdefault(k, []): out["save_like"][k].append(r["scenario_id"])
    return out


def keys_of(items):
    """조건식에서 키 이름을 뽑는다 — Keys.X · 같은 마디에 e.Control 이 있으면 Control+X"""
    ks = []
    for it in items:
        for seg in re.split(r"▸", it["text"]):
            for m in re.finditer(r"Keys\.(\w+)", seg):
                k = m.group(1)
                if k in ("Control", "Shift", "Alt", "None"): continue
                full = ("Control+" + k) if re.search(r"e\.Control\b(?!\s*==\s*false)", seg) and not re.search(r"!\s*e\.Control", seg) else k
                if full not in ks: ks.append(full)
    return ks


def grid_of(d, name):
    """화면 덤프에서 그 이름의 그리드와 활성 시트 — (그리드 이름, 시트) · 없으면 (None, None)"""
    for g in d.get("grids") or []:
        if str(g.get("name") or "").lower() == name.lower():
            shs = g.get("sheets") or []
            try: cur = int(g.get("active_sheet_index") or 0)
            except Exception: cur = 0
            sh = next((s for s in shs if str(s.get("index", "")) == str(cur)), shs[0] if shs else None)
            return g.get("name"), sh
    return None, None


def col_pick(sheet, items, limit):
    """조건식에 이름이 나온 보이는 열 먼저, 그다음 앞쪽 보이는 열 — [(열 번호, Tag)]"""
    cols = sheet.get("columns") or []; tag = lambda c: (c.get("tag") or c.get("data_field") or c.get("label") or str(c.get("index")))
    vis = [c for c in cols if str(c.get("visible")) == "True" and float(c.get("width") or 0) > 1 and int(c.get("index") or 0) > 0]
    words = set()
    for it in items: words |= {w.upper() for w in re.findall(r"[A-Za-z_][A-Za-z0-9_]{2,}", it["text"])}
    named = [c for c in vis if tag(c).upper() in words]
    return [(int(c.get("index")), tag(c)) for c in (named + [c for c in vis if c not in named])[:max(limit, len(named[:8]))]], [tag(c) for c in named]


def run_events(host, mid, group, tg, kinds):
    out = {"id": mid, "group": group, "cellrun": True, "eventrun": True, "acts": [], "skipped": [], "at": time.strftime("%Y-%m-%d %H:%M:%S")}; calls = []
    d = I.open_find(host, mid, out)
    if d is None: return out, calls
    xb = X.snap(); ctl_names = {str(c.get("name") or "").lower(): c.get("name") for c in d.get("controls") or []}

    def do(name, label, ids, **kw):
        if "raise_" in kw: kw["raise"] = kw.pop("raise_")
        g0 = SR.grid_snap(host, rows=60); t1 = R.now(); d0 = len((host.send("dialogs", timeout=30).get("dialogs") or []))
        rr = host.send("act", timeout=120, wait=3, **kw); ob, n = I.observe(host, out, name, t1, d0, g0, xb, rr, calls)
        out["acts"].append(dict(ob, control=kw.get("target") or "", kind="event", change=label + ((" · " + str(rr.get("raised"))) if rr.get("raised") else ""), ok=bool(rr.get("ok")), error=rr.get("error"), scenarios=ids))
        print("   %s · %s · %s · 메시지 %s · 호출 %d · 바뀐 셀 %d" % (kw.get("target"), label, "실행" if rr.get("ok") else "실패(%s)" % str(rr.get("error"))[:80], [x["text"][:40] for x in ob["dialogs"]], n,
              sum(len(g.get("cells") or []) for g in ob["grid_changes"] if "cells" in g)), flush=True)
        return rr

    # ① 스크롤(수정 모드 전)
    if "scroll" in kinds:
        for (ctl, ev), items in sorted(tg["scroll"].items()):
            ids = [x["id"] for x in items]; gn, sh = grid_of(d, ctl)
            if not gn: out["skipped"].append({"control": ctl, "why": "화면 덤프에 그 이름의 그리드가 없음", "scenarios": ids}); print("   %s · 건너뜀(그리드 없음)" % ctl, flush=True); continue
            nrow = int((sh or {}).get("row_count") or len((sh or {}).get("data") or []) or 0)
            if ev == "TopChange" and nrow > 1:
                do("scroll:%s" % gn, "보이는 첫 행을 %d 로 옮김" % min(5, nrow - 1), ids, scroll=str(min(5, nrow - 1)), target=gn)
                if out.get("restart"): break
                do("scroll:%s:0" % gn, "보이는 첫 행을 0 으로 되돌림", ids, scroll="0", target=gn)
                if out.get("restart"): break
            do("raise:%s.%s" % (gn, ev), "%s 처리기 직접 호출(행 %d개)" % (ev, nrow), ids, raise_=ev, target=gn, new="1")
            if out.get("restart"): break
    # ② 키 입력 · 붙여넣기(수정 모드)
    need_edit = ("key" in kinds and tg["key"]) or ("paste" in kinds and tg["paste"])
    if need_edit and not out.get("restart"):
        host.send("policy", timeout=30, dialogs="no")
        er = host.send("act", timeout=120, method="OnClickEditButton", wait=5); SR.sweep(host, out, "OnClickEditButton"); out["edit_mode"] = er.get("edit_mode")
        print("   수정 모드 %s" % ("켜짐" if er.get("edit_mode") else "켜지지 않음(조회 전용 화면이거나 권한 없음) — 그대로 진행"), flush=True)
        if "key" in kinds:
            for (ctl, ev), items in sorted(tg["key"].items()):
                ids = [x["id"] for x in items]; gn, sh = grid_of(d, ctl); kw = {}
                if gn:
                    if not (sh and (sh.get("data") or [])): out["skipped"].append({"control": gn, "why": "조회 결과 행이 없어 활성 셀을 둘 수 없음", "scenarios": ids}); continue
                    pick, named = col_pick(sh, items, 1); kw = {"row": "0", "col": str(pick[0][0])} if pick else {}; tname = gn; where = " · 활성 셀 첫 행 %s" % (pick[0][1] if pick else "")
                else:
                    tname = ctl_names.get(ctl.lower())
                    if not tname: out["skipped"].append({"control": ctl, "why": "화면 덤프에 그 이름의 컨트롤이 없음", "scenarios": ids}); print("   %s · 건너뜀(컨트롤 없음)" % ctl, flush=True); continue
                    where = ""
                if ev == "KeyPress":
                    chars = [("1", "'1'"), ("a", "'a'")] + ([("08", "백스페이스")] if any("Keys.Back" in x["text"] for x in items) else [])
                    for ch, nm in chars:
                        do("raise:%s.%s:%s" % (tname, ev, ch), "%s 처리기 직접 호출 · 글자 %s%s" % (ev, nm, where), ids, raise_=ev, target=tname, char=ch, **kw)
                        if out.get("restart"): break
                else:
                    for k in (keys_of(items) or ["D1"])[:6]:
                        do("raise:%s.%s:%s" % (tname, ev, k), "%s 처리기 직접 호출 · 키 %s%s" % (ev, k, where), ids, raise_=ev, target=tname, key=k, **kw)
                        if out.get("restart"): break
                if out.get("restart"): break
        if "paste" in kinds and not out.get("restart"):
            for (ctl, ev), items in sorted(tg["paste"].items()):
                ids = [x["id"] for x in items]; gn, sh = grid_of(d, ctl)
                if not gn: out["skipped"].append({"control": ctl, "why": "화면 덤프에 그 이름의 그리드가 없음", "scenarios": ids}); print("   %s · 건너뜀(그리드 없음)" % ctl, flush=True); continue
                if not (sh and (sh.get("data") or [])): out["skipped"].append({"control": gn, "why": "조회 결과 행이 없어 붙여넣을 셀이 없음", "scenarios": ids}); print("   %s · 건너뜀(행 없음)" % gn, flush=True); continue
                pick, named = col_pick(sh, items, 4)
                for ix, tg_ in pick:
                    do("raise:%s.%s:%s" % (gn, ev, tg_), "%s 처리기 직접 호출 · 범위 첫 행 %s 1칸(값은 조회된 값 그대로)" % (ev, tg_), ids, raise_=ev, target=gn, row="0", col=str(ix))
                    if out.get("restart"): break
                if out.get("restart"): break
    if not out["acts"] and not out.get("note"): out["note"] = "실행한 조작 없음"
    I.close_nosave(host, out)
    return out, calls


def main():
    av = sys.argv[1:]; ids = [a.upper() for a in av if not a.startswith("-")]
    kinds = [k for k in ("scroll", "key", "paste") if ("--" + k) in av] or ["scroll", "key", "paste"]
    if not ids: print(__doc__); return 2
    plan = {}; work = []
    for m in ids:
        t = targets(m); ks = []
        for k in kinds:
            if not t[k]: continue
            if t["save_like"].get(k): print("[%s] %s 분기에 저장 계열 호출이 있는 분기 %d개 — 실행하지 않음" % (m, KN[k], len(t["save_like"][k]))); continue
            ks.append(k)
        if ks: plan[m] = (t, ks); work.append(m)
        else: print("[%s] 스크롤·키 입력·붙여넣기 분기 없음 — 런처를 띄우지 않음" % m)
    if not work: return 0
    if not R.acquire_lock("scen_event"): print("[ERROR] 다른 AS-IS 실측이 끝나지 않음"); return 3
    host, info, why = R.start_session(P("Doc", "asislive", "_cmd_event_" + time.strftime("%H%M%S")))
    if host is None: print("[ERROR] 런처 세션 시작 실패: %s" % why); return 3
    rc = 0
    try:
        grp = (host.send("group", timeout=60).get("current") or "")
        for m in work:
            t, ks = plan[m]
            print("[%s] 그룹 %s · %s 분기(%s)" % (m, grp, ", ".join(KN[k] for k in ks), ", ".join("%s %d" % (KN[k], sum(len(v) for v in t[k].values())) for k in ks)), flush=True)
            out, calls = run_events(host, m, grp, t, ks)
            d = P("Doc", "asislive", m, "run_%s_acts_event" % time.strftime("%Y%m%d_%H%M%S")); os.makedirs(d, exist_ok=True)
            json.dump(out, open(os.path.join(d, "acts.json"), "w", encoding="utf-8"), ensure_ascii=False, indent=1, default=str)
            json.dump({"calls": calls}, open(os.path.join(d, "calls.json"), "w", encoding="utf-8"), ensure_ascii=False, indent=1, default=str)
            json.dump({"id": m, "group": grp, "kind": "acts_event", "acts": len(out["acts"]), "skipped": len(out["skipped"])}, open(os.path.join(d, "run.json"), "w", encoding="utf-8"), ensure_ascii=False, indent=1)
            print("   → 실행 %d · 실패 %d · 건너뜀 %d%s · %s" % (len(out["acts"]), sum(1 for a in out["acts"] if not a.get("ok")), len(out["skipped"]), (" · " + out["note"]) if out.get("note") else "", R.rel(d)), flush=True)
            if out.get("error"): rc = max(rc, 3)
            if out.get("restart"):
                try: host.send("quit", timeout=30)
                except Exception: pass
                time.sleep(3); os.system("taskkill /F /IM AsisLive.Host.exe >nul 2>&1"); time.sleep(3)
                host, info, why = R.start_session(P("Doc", "asislive", "_cmd_event_" + time.strftime("%H%M%S")))
                if host is None: print("[ERROR] 런처 다시 시작 실패: %s" % why); return 3
    finally:
        try: host.send("policy", timeout=30, dialogs="close"); SR.sweep(host, {}, None); host.send("quit", timeout=30)
        except Exception: pass
    return rc


if __name__ == "__main__":
    sys.exit(main())
