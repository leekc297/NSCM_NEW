# -*- coding: utf-8 -*-
"""TO-BE 검증 조건 → AS-IS 조건 시나리오 (2026-11-13 · 플랜 P5 조건 시나리오 2단계)

  python tools/AsisLive/asis_live_scen.py [ID ...]     (ID 생략 = _cond_summary.csv 의 "조건 다름" 화면)
입력  Doc/asislive/<ID>/cond_compare.csv (asis_live_cond.py) · 최근 실측의 controls.json
방법  값이 다른 인자(DIFF)마다, AS-IS 실측 때 그 인자 값과 **같은 값을 가진 조회조건 컨트롤**을 찾는다(값으로 찾는다 — 화면별 이름 고정 없음).
        · 컨트롤 1개가 정확히 같은 값  → 그 컨트롤의 ControlValues 를 TO-BE 값으로
        · from_/to_ 쌍이 기간 컨트롤 값 "a:b" 와 같음 → "TO-BE from:TO-BE to"
        · 같은 값 컨트롤이 없거나 2개 이상 → 미해결(시나리오에 넣지 않는다 · 추측 금지)
      넣지 않는 차이(분류만 한다)
        · EQUIV     값의 집합이 같고 순서만 다름
        · ALL_FORM  한쪽이 빈값/ALL 이고 다른 쪽이 빈값/ALL/목록 — "전체"의 표현 차이 후보(같은 조건인지 미확정)
        · USER      사용자 ID 계열
산출  Doc/asislive/<ID>/scenario_tobe.json  {"set":[{name, prop, value, param, from}], "unresolved":[...], "skipped":[...]}
      Doc/asislive/_scen_summary.csv
"""
import csv, glob, json, os, re, sys, collections

ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
P = lambda *a: os.path.join(ROOT, *a)
for _s in (sys.stdout, sys.stderr):
    try: _s.reconfigure(encoding="utf-8", errors="replace")
    except Exception: pass
ALLV = {"", "ALL"}


def rd(p):
    if not os.path.exists(p): return []
    with open(p, encoding="utf-8-sig", newline="") as f: return list(csv.DictReader(f))


def controls(mid):
    """최근 실측의 보이는 조회조건 컨트롤 [(name, type, control_values)]"""
    try: run_dir = json.load(open(P("Doc", "asislive", mid, "latest.json"), encoding="utf-8")).get("run_dir")
    except Exception: return []
    rdir = run_dir if os.path.isabs(run_dir) else P(run_dir)
    try: c = json.load(open(os.path.join(rdir, "controls.json"), encoding="utf-8"))
    except Exception: return []
    found = {}

    def walk(o):
        if isinstance(o, dict):
            t = (o.get("type") or "") if isinstance(o.get("type"), str) else ""
            if o.get("name") and t.split(".")[-1].startswith("Usr") and o.get("visible") and "control_values" in o:
                found[o["name"]] = (o["name"], t.split(".")[-1], "" if o.get("control_values") is None else str(o.get("control_values")))   # 뒤(조회 후) 덤프가 덮어쓴다
            for v in o.values(): walk(v)
        elif isinstance(o, list):
            for v in o: walk(v)
    walk(c)
    return [v for v in found.values() if not re.search(r"Button|Label|Layout|Panel|Spread", v[1])]


def classify(a, t):
    sa, st = [x.strip() for x in a.split(",") if x.strip()], [x.strip() for x in t.split(",") if x.strip()]
    if sa and st and sorted(sa) == sorted(st): return "EQUIV"
    if a.strip().upper() in ALLV or t.strip().upper() in ALLV: return "ALL_FORM"
    return "DIFF"


def build(mid):
    rows = [r for r in rd(P("Doc", "asislive", mid, "cond_compare.csv")) if r["verdict"] == "DIFF"]
    cs = controls(mid); sets = []; unres = []; skipped = []; used = set()
    by = collections.OrderedDict()
    for r in rows: by.setdefault((r["sheet"], r["asis_sp"]), {})[r["param"]] = (r["asis"], r["tobe"])
    handled = set()                                           # 같은 인자·같은 값 차이는 한 번만 다룬다(시트가 여럿이어도 조건 컨트롤은 하나)
    for (sheet, sp), ps in by.items():
        done = {k for k in ps if (k, ps[k]) in handled}
        handled |= {(k, v) for k, v in ps.items()}
        # 기간 쌍
        for k in list(ps):
            m = re.match(r"^(from|start)(_.*)$", k)
            if not m or k in done: continue
            k2 = next((x for x in ps if x in ("to" + m.group(2), "end" + m.group(2))), None)
            if not k2: continue
            av = ps[k][0] + ":" + ps[k2][0]
            hit = [c for c in cs if c[2] == av]
            if len(hit) == 1 and hit[0][0] not in used:
                sets.append({"name": hit[0][0], "prop": "InitValue", "value": ps[k][1] + ":" + ps[k2][1], "param": k + "+" + k2, "from": av, "sheet": sheet}); used.add(hit[0][0]); done |= {k, k2}
        for k, (a, t) in ps.items():
            if k in done: continue
            if re.search(r"user_id$|^user$|created_by", k): skipped.append({"param": k, "asis": a, "tobe": t, "why": "USER"}); continue
            cl = classify(a, t)
            if cl != "DIFF": skipped.append({"param": k, "asis": a[:120], "tobe": t[:120], "why": cl}); continue
            hit = [c for c in cs if c[2] == a and c[0] not in used]
            if len(hit) == 1:
                sets.append({"name": hit[0][0], "prop": ("DateTime" if hit[0][1].endswith("DatePicker2") else "Value" if "DatePicker" in hit[0][1] else "ControlValues"), "value": t, "param": k, "from": a, "sheet": sheet}); used.add(hit[0][0])
            else:
                unres.append({"param": k, "asis": a[:120], "tobe": t[:120], "why": "같은 값을 가진 컨트롤 %d개" % len(hit), "candidates": [h[0] for h in hit][:6]})
    # 앞 회차에 넣은 값은 유지한다(넣은 뒤에는 그 인자가 같아져 차이 목록에서 빠지므로, 빼면 다음 실행에서 기본값으로 돌아간다) · --reset 이면 버림
    if "--reset" not in sys.argv:
        try: old = json.load(open(P("Doc", "asislive", mid, "scenario_tobe.json"), encoding="utf-8")).get("set") or []
        except Exception: old = []
        names = {s["name"] for s in sets}
        sets = [dict(o, kept=True) for o in old if o.get("name") not in names] + sets
    sc = {"id": mid, "rule": "tobe", "set": sets, "unresolved": unres, "skipped": skipped}
    with open(P("Doc", "asislive", mid, "scenario_tobe.json"), "w", encoding="utf-8") as f: json.dump(sc, f, ensure_ascii=False, indent=1)
    return sc


def main():
    ids = [a.upper() for a in sys.argv[1:] if not a.startswith("-")]
    if not ids: ids = [r["id"] for r in rd(P("Doc", "asislive", "_cond_summary.csv")) if r["cond"] == "조건 다름"]
    out = []
    for mid in ids:
        sc = build(mid); why = collections.Counter(s["why"] for s in sc["skipped"])
        out.append({"id": mid, "set": len(sc["set"]), "unresolved": len(sc["unresolved"]), "equiv": why.get("EQUIV", 0), "all_form": why.get("ALL_FORM", 0), "user": why.get("USER", 0),
                    "set_detail": " ; ".join("%s←%s(%s)" % (s["name"], s["value"][:40], s["param"]) for s in sc["set"])[:400],
                    "unresolved_detail": " ; ".join("%s: %s→%s (%s)" % (u["param"], u["asis"][:30], u["tobe"][:30], u["why"]) for u in sc["unresolved"])[:400]})
        o = out[-1]; print("[%s] 넣을 값 %s · 미해결 %s · 순서만 다름 %s · 전체 표현 차이 %s · 사용자 %s | %s | %s" % (mid, o["set"], o["unresolved"], o["equiv"], o["all_form"], o["user"], o["set_detail"][:160], o["unresolved_detail"][:160]))
    if out:
        with open(P("Doc", "asislive", "_scen_summary.csv"), "w", encoding="utf-8-sig", newline="") as f:
            w = csv.DictWriter(f, fieldnames=list(out[0].keys())); w.writeheader(); w.writerows(out)
        print("합계 넣을 값 %d · 미해결 %d · 순서만 다름 %d · 전체 표현 차이 %d" % (sum(o["set"] for o in out), sum(o["unresolved"] for o in out), sum(o["equiv"] for o in out), sum(o["all_form"] for o in out)))


if __name__ == "__main__":
    main()
