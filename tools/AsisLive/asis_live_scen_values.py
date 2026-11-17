# -*- coding: utf-8 -*-
"""분기 조건식에서 전제 값(Division, 그룹) 도출 → 실행 계획 → 실행 (2026-11-13, 플랜 P6-3)

  python tools/AsisLive/asis_live_scen_values.py <ID> [ID ...] [--run]     (ID 생략 = scenarios_cov.csv 가 있는 전 화면, 계획만)
입력  Doc/asislive/<ID>/scenarios_cov.csv(분기 조건식 guard, 축 axes) · run_*_acts*/acts.json(이미 실행한 Division, 그룹)
      Doc/asislive/_groups.json(런처 계정이 가진 그룹, asis_live_scen_run.py --groups-list) · run_*/dump_find.json(화면의 Division 목록)
방법  Division 축 분기: 조건식에서 division, div 가 든 마디의 따옴표 값 중 Division 코드 모양(숫자 2자리, 숫자 2자리_영문 2자리)만 뽑는다.
        화면의 Division 목록을 알면 그 목록에 있는 값만 실행 대상으로 둔다. "else of (…)" 마디는 적힌 값이 아닌 Division 이 필요하므로 목록의 다른 값 1개를 고른다.
      그룹 축 분기: GroupID, NowGroup, Auth, Role 이 든 마디의 따옴표 값 중 계정이 가진 그룹 이름과 같은 것만 실행 대상으로 둔다. 계정에 없는 그룹은 실행할 수 없다고 적는다.
      값이 조건식에 글자로 없으면(변수, 메타 조회 결과로 정해짐) 도출하지 않는다.
산출  Doc/asislive/<ID>/scenario_values.csv   분기별 axis, 조건식의 값, 실행 대상 값, 이미 실행한 값, 상태
      Doc/asislive/<ID>/scenario_values_plan.json   {"divisions": [...], "groups": [...], "todo_divisions": [...], "todo_groups": [...]}
      --run 이면 todo 를 실행한다: asis_live_scen_run.py <ID> --division a,b  그리고 그룹마다 asis_live_scen_run.py <ID> --group <그룹>
상태  실행함(그 값으로 버튼 분기 실행 기록 있음) / 실행 대상(값 도출, 아직 실행 안 함) / 계정에 없는 그룹 / 화면 목록에 없는 Division / 값 미도출
      조회 조건 축 분기(11-14): 조건식에서 조건 컨트롤(cbo, cmb, chk, clb, rdo 로 시작하는 이름)의 값 비교를 찾는다. Division 컨트롤은 Division 축이 다루므로 뺀다.
        체크 상자 = 켬, 끔 둘 다. 콤보 = 화면 덤프의 항목마다 1회(조건식의 상수 이름이 어느 항목인지 소스만으로는 알 수 없어 항목 전부를 실행하고, 실행 때 읽은 값을 적는다).
        체크 목록 = 항목마다 그 항목만 체크. 항목이 8개를 넘으면 앞 8개까지만 실행 대상으로 두고 나머지는 '상한 밖'으로 적는다(--all-values 로 전부).
        조건식에 따옴표 값이 있고 실행 기록에서 그 값이 나온 항목을 알면 그 항목 실행 여부로 상태를 정한다. 입력 상자(txt), 날짜는 값을 정하지 못해 값 미도출.
한계  그 값으로 화면을 실행했다는 뜻이다. 그 분기가 탔는지는 분기 실행 현황과 분기별 대조가 따로 본다. 조회 조건, 데이터 상태, 화면 상태 축의 값은 다루지 않는다.
"""
import csv, glob, json, os, re, subprocess, sys, collections

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
P = lambda *a: os.path.join(ROOT, *a)
csv.field_size_limit(10 ** 8)
for _s in (sys.stdout, sys.stderr):
    try: _s.reconfigure(encoding="utf-8", errors="replace")
    except Exception: pass
DIVSEG = re.compile(r"division|\bdiv\b|sDiv", re.I)
DIVCODE = re.compile(r"^\d{2}(_[A-Z]{2})?$")
GRPSEG = re.compile(r"GroupID|NowGroup|Auth|Role", re.I)


def rd(p):
    if not os.path.exists(p): return []
    with open(p, encoding="utf-8-sig", newline="") as f: return list(csv.DictReader(f))


def screen_divisions(mid):
    """화면의 Division 목록(코드) — 버튼 실행 기록의 division_control, 없으면 조회 덤프의 Division 콤보"""
    for f in sorted(glob.glob(P("Doc", "asislive", mid, "run_*_acts*", "acts.json")), reverse=True):
        try: it = (json.load(open(f, encoding="utf-8")).get("division_control") or {}).get("items")
        except Exception: it = None
        if it: return [x for x in it if x]
    for f in sorted(glob.glob(P("Doc", "asislive", mid, "run_*", "dump_find.json")), reverse=True):
        try: d = json.load(open(f, encoding="utf-8")); d = d.get("data", d)
        except Exception: continue
        for c in d.get("controls") or []:
            if re.search(r"division", c.get("name") or "", re.I) and c.get("items") and isinstance(c["items"][0], str):
                return [str(x).strip().split(" ")[0] for x in c["items"]]
    return []


def executed(mid):
    dv, gp = set(), set()
    for f in glob.glob(P("Doc", "asislive", mid, "run_*_acts*", "acts.json")):
        if os.path.exists(os.path.join(os.path.dirname(f), "overlap.json")): continue      # 11-14: 겹친 실행은 다시 실행 대상
        try: j = json.load(open(f, encoding="utf-8"))
        except Exception: continue
        if not j.get("acts"): continue
        if j.get("division"): dv.add(str(j["division"]))
        if j.get("group"): gp.add(str(j["group"]))
    return dv, gp


CONDREF = re.compile(r"(?<![\w.])((?:cbo|cmb|chk|clb|rdo|rb|opt|lue|txt|dtp|dte)\w*)\.(ControlValues?|SelectedValue|SelectedIndex|SelectedItem|Checked|CheckState|CheckedItems|Items|Text|EditValue|Value)\b", re.I)
CAP = 8


def screen_controls(mid):
    """화면 덤프(조회 뒤)의 컨트롤 — {이름 소문자: {"name","t","items":[글자],"checked","selected_index","value"}}"""
    for f in sorted(glob.glob(P("Doc", "asislive", mid, "run_*", "dump_find.json")), reverse=True):
        try: d = json.load(open(f, encoding="utf-8")); d = d.get("data", d)
        except Exception: continue
        out = {}
        for c in d.get("controls") or []:
            n = str(c.get("name") or "")
            if not n or n.lower() in out: continue
            t = str(c.get("type") or "").split(".")[-1]; it = c.get("items") or []
            if t.startswith("UsrCheckedList"):                    # 항목은 안쪽 목록 상자에 있다
                inner = next((x for x in d.get("controls") or [] if ("/" + n + "/") in str(x.get("path") or "") and str(x.get("type") or "").endswith("CheckedListBox")), None)
                it = [str(x.get("text")) if isinstance(x, dict) else str(x) for x in (inner or {}).get("items") or []]
            out[n.lower()] = {"name": n, "t": t, "items": [str(x.get("text")) if isinstance(x, dict) else str(x) for x in it] if not t.startswith("UsrCheckedList") else it,
                              "checked": c.get("checked"), "selected_index": c.get("selected_index"), "value": str(c.get("control_values") or ""), "visible": c.get("visible")}
        if out: return out
    return {}


def executed_presets(mid):
    """조건 값을 정해 실행한 기록 — {토큰: {"value","text"}}"""
    out = {}
    for f in glob.glob(P("Doc", "asislive", mid, "run_*_acts*", "acts.json")):
        if os.path.exists(os.path.join(os.path.dirname(f), "overlap.json")): continue      # 11-14: 겹친 실행은 다시 실행 대상
        try: j = json.load(open(f, encoding="utf-8"))
        except Exception: continue
        pz = j.get("preset") or {}
        if pz.get("ok") and j.get("acts"): out[str(pz.get("name")).lower() + "=" + str(pz.get("token")).split("=", 1)[-1].lower()] = {"value": pz.get("value"), "text": pz.get("text")}
    return out


def cond_rows(mid, sc, all_values=False):
    """조회 조건 축 분기의 값 도출 — (행 목록, 실행할 토큰 목록, 남은 토큰 목록)"""
    ctl = screen_controls(mid); done = executed_presets(mid); rows = []; want = []
    for r in sc:
        if "COND" not in (r.get("axes") or "").split("+"): continue
        g = r.get("guard") or ""; refs = {}
        for m in CONDREF.finditer(g):
            n = m.group(1)
            if DIVSEG.search(n): continue
            lits = re.findall(r'%s\.%s\s*(?:==|!=)\s*"([^"]{0,40})"' % (re.escape(n), re.escape(m.group(2))), g) + re.findall(r'%s\.%s\.Equals\(\s*"([^"]{0,40})"' % (re.escape(n), re.escape(m.group(2))), g)
            d = refs.setdefault(n.lower(), {"name": n, "props": [], "lits": []}); d["props"] += [m.group(2)] if m.group(2) not in d["props"] else []; d["lits"] += [x for x in lits if x not in d["lits"]]
        if not refs:
            rows.append({"scenario_id": r["scenario_id"], "axis": "COND", "guard_values": "", "run_values": "", "executed": "", "status": "값 미도출", "guard": g[:240], "note": "조건식에 조건 컨트롤 값 비교가 없음(변수·메서드 결과로 정해짐)"}); continue
        for k, d in refs.items():
            c = ctl.get(k); toks = []; over = 0; note = ""
            if not c: st = "화면에 없는 컨트롤"; note = "화면 덤프에 %s 없음(팝업 안·다른 폼이거나 덤프 없음)" % d["name"]
            elif str(c.get("visible")) == "False": st = "화면에 없는 컨트롤"; note = "%s 가 숨김 상태" % c["name"]
            elif c["t"] in ("UsrCheckBox", "CheckBox", "CheckEdit"): toks = [c["name"] + "=cT", c["name"] + "=cF"]
            elif c["t"] == "UsrCombo" or c["t"].endswith("ComboBox"):
                n = len(c["items"]); toks = [c["name"] + "=i%d" % i for i in range(n)]
                if n < 2: note = "콤보 항목 %d개" % n
            elif c["t"].startswith("UsrCheckedList"): toks = [c["name"] + "=k%d" % i for i in range(len(c["items"]))]
            else: note = "값을 고르는 규칙이 없는 컨트롤 형식(%s)" % c["t"]
            if toks and not all_values and len(toks) > CAP: over = len(toks) - CAP; toks = toks[:CAP]
            if c and toks:
                ex = [t for t in toks if t.lower() in done]; seen = {str(done[t.lower()].get("value")): t for t in ex}
                if d["lits"] and all(l in seen for l in d["lits"]): st = "실행함"                       # 조건식의 값이 나온 항목을 실행했다
                elif len(ex) == len(toks) and not over: st = "실행함"
                else: st = "실행 대상"
                want += [t for t in toks if t not in want]
                if over: note = "항목 %d개 중 %d개는 상한 밖(--all-values)" % (len(toks) + over, over)
            elif c and not toks: st = "값 미도출"; ex = []
            else: ex = []
            rows.append({"scenario_id": r["scenario_id"], "axis": "COND", "guard_values": "%s.%s%s" % (d["name"], "/".join(d["props"]), (" = " + ",".join(d["lits"])) if d["lits"] else ""), "run_values": " ".join(toks),
                         "executed": " ".join(ex), "status": st, "guard": g[:240], "note": note})
    return rows, want, [t for t in want if t.lower() not in done]


def one(mid, groups, all_values=False):
    sc = rd(P("Doc", "asislive", mid, "scenarios_cov.csv")) or rd(P("Doc", "asislive", mid, "scenarios_src.csv"))
    if not sc: return None
    dlist = screen_divisions(mid); ex_d, ex_g = executed(mid); rows = []; want_d, want_g = [], []
    for r in sc:
        ax = (r.get("axes") or "").split("+"); g = r.get("guard") or ""; segs = [x.strip() for x in g.split("▸") if x.strip()]
        if "DIVISION" in ax:
            lits, other = [], False
            for s in segs:
                if not DIVSEG.search(s): continue
                v = [x for x in re.findall(r'"([^"]{1,12})"', s) if DIVCODE.match(x)]
                if s.startswith("else of") and v: other = True
                lits += [x for x in v if x not in lits]
            run = [x for x in lits if not dlist or x in dlist]
            if other and dlist:
                o = next((x for x in dlist if x not in lits), None)
                if o and o not in run: run.append(o)
            st = ("값 미도출" if not lits else "화면 목록에 없는 Division" if not run else "실행함" if all(x in ex_d for x in run) else "실행 대상")
            rows.append({"scenario_id": r["scenario_id"], "axis": "DIVISION", "guard_values": ",".join(lits) + (" (그 밖 값 필요)" if other else ""), "run_values": ",".join(run), "executed": ",".join(x for x in run if x in ex_d), "status": st, "guard": g[:240]})
            want_d += [x for x in run if x not in want_d]
        if "AUTH" in ax:
            lits = []
            for s in segs:
                if GRPSEG.search(s): lits += [x for x in re.findall(r'"([^"]{1,30})"', s) if x not in lits and x not in ("NowGroupID", "Y", "N", "PgmAuthId")]
            run = [x for x in lits if x in groups]; miss = [x for x in lits if x not in groups and re.search(r"admin|planner|viewer|tester", x, re.I)]
            st = ("값 미도출" if not (run or miss) else "계정에 없는 그룹" if not run else "실행함" if all(x in ex_g for x in run) else "실행 대상")
            rows.append({"scenario_id": r["scenario_id"], "axis": "AUTH", "guard_values": ",".join(run + miss), "run_values": ",".join(run), "executed": ",".join(x for x in run if x in ex_g), "status": st, "guard": g[:240]})
            want_g += [x for x in run if x not in want_g]
    for x in rows: x.setdefault("note", "")
    crow, want_c, todo_c = cond_rows(mid, sc, all_values); rows += crow
    plan = {"id": mid, "screen_divisions": dlist, "divisions": want_d, "groups": want_g, "todo_divisions": [x for x in want_d if x not in ex_d], "todo_groups": [x for x in want_g if x not in ex_g],
            "conds": want_c, "todo_conds": todo_c, "account_groups_known": bool(groups)}
    if rows:
        with open(P("Doc", "asislive", mid, "scenario_values.csv"), "w", encoding="utf-8-sig", newline="") as f:
            w = csv.DictWriter(f, fieldnames=list(rows[0].keys())); w.writeheader(); w.writerows(rows)
    with open(P("Doc", "asislive", mid, "scenario_values_plan.json"), "w", encoding="utf-8") as f: json.dump(plan, f, ensure_ascii=False, indent=1)
    c = collections.Counter((x["axis"], x["status"]) for x in rows)
    return dict(plan, rows=len(rows), counts={"%s %s" % k: v for k, v in sorted(c.items())})


def main():
    av = sys.argv[1:]; ids = [a.upper() for a in av if not a.startswith("-")]; run = "--run" in av; ALL = not ids; allv = "--all-values" in av
    if not ids: ids = sorted(os.path.basename(os.path.dirname(f)) for f in glob.glob(P("Doc", "asislive", "*", "scenarios_cov.csv")))
    try: groups = [x.get("code") for x in json.load(open(P("Doc", "asislive", "_groups.json"), encoding="utf-8")).get("items") or []]
    except Exception: groups = []
    tot = collections.Counter(); rc = 0
    for mid in ids:
        s = one(mid, groups, allv)
        if not s: continue
        for k, v in s["counts"].items(): tot[k] += v
        if not ALL:
            print("[%s] Division·그룹·조회 조건 축 분기 %d = %s" % (mid, s["rows"], ", ".join("%s %d" % kv for kv in s["counts"].items()) or "없음"))
            print("   조회 조건 실행 대상 %d(남은 것 %d)%s" % (len(s["conds"]), len(s["todo_conds"]), (": " + " ".join(s["todo_conds"][:12])) if s["todo_conds"] else ""))
            print("   화면 Division 목록 %s / 실행 대상 Division %s(남은 것 %s) / 실행 대상 그룹 %s(남은 것 %s)" % (",".join(s["screen_divisions"]) or "미확인", ",".join(s["divisions"]) or "없음", ",".join(s["todo_divisions"]) or "없음",
                                                                                              ",".join(s["groups"]) or "없음", ",".join(s["todo_groups"]) or "없음"))
        if run and not ALL and (s["todo_divisions"] or s["todo_groups"] or s["todo_conds"]):
            sys.path.insert(0, os.path.dirname(os.path.abspath(__file__))); import asis_live_screen as SCR      # 11-14: 화면 묶음과 같은 화면 잠금(PID 기준)으로 런처 동시 실행을 막는다
            if not SCR.lock(mid): print("   [ERROR] 다른 화면의 AS-IS 실측이 60분 안에 끝나지 않음 — 실행 안 함(미실행)"); rc = max(rc, 3); continue
        if run and not ALL:
            T = os.path.join("tools", "AsisLive", "asis_live_scen_run.py")
            if s["todo_divisions"]:
                print("   실행: Division %s" % ",".join(s["todo_divisions"]), flush=True)
                rc = max(rc, subprocess.call([sys.executable, T, mid, "--division", ",".join(s["todo_divisions"])], cwd=ROOT))
            for g in s["todo_groups"]:
                print("   실행: 그룹 %s" % g, flush=True)
                rc = max(rc, subprocess.call([sys.executable, T, mid, "--group"] + g.split(" "), cwd=ROOT))
            if s["todo_conds"]:
                print("   실행: 조회 조건 값 %d개" % len(s["todo_conds"]), flush=True)
                rc = max(rc, subprocess.call([sys.executable, T, mid, "--preset", ";".join(s["todo_conds"])], cwd=ROOT))
            if s["todo_divisions"] or s["todo_groups"] or s["todo_conds"]:
                SCR.unlock()
                s2 = one(mid, groups, allv); print("   실행 뒤: %s" % ", ".join("%s %d" % kv for kv in s2["counts"].items()))
    if ALL:
        print("화면 %d, Division·그룹·조회 조건 축 분기 상태: %s" % (len(ids), ", ".join("%s %d" % kv for kv in sorted(tot.items()))))
        if not groups: print("계정 그룹 목록(Doc/asislive/_groups.json) 없음. asis_live_scen_run.py --groups-list 를 먼저 실행")
    return rc


if __name__ == "__main__":
    sys.exit(main())
