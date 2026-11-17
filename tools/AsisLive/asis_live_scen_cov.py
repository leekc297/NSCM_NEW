# -*- coding: utf-8 -*-
"""소스 분기 시나리오 ↔ 런처 실측 실행 여부 (2026-11-13 · 플랜 P6)

  python tools/AsisLive/asis_live_scen_cov.py [ID ...]     (ID 생략 = scenarios_src.csv 가 있는 전 화면)
입력  Doc/asislive/<ID>/scenarios_src.csv (asis_live_scen_src.py) · Doc/asislive/<ID>/run_*/calls.json·run.json (지금까지의 모든 실측)
판정  서버 호출을 관찰점으로 가진 분기만 지금 판정할 수 있다(런처가 남기는 증거가 호출 기록뿐이므로).
        EXECUTED        그 분기의 서버 호출이 실측에 있고, 그 호출을 관찰점으로 가진 분기가 화면에 하나뿐 → 이 분기가 실행된 것
        EXECUTED_AMBIG  호출은 실측에 있으나 같은 호출을 가진 분기가 여럿 → 어느 분기였는지는 특정 못 함
        NOT_EXECUTED    서버 호출 관찰점이 있는데 실측에 그 호출이 없음 → 아직 실행 안 한 분기(시나리오 실행 필요)
        NO_CALL_EVIDENCE 서버 호출이 없는 분기(메시지·잠금·표시·그리드 구성 등) → 호출 기록으로는 판정 불가(화면 덤프·조작 기능 필요)
        UNREACHED       도달 경로 없음(도출 단계에서 넘어온 상태)
산출  Doc/asislive/<ID>/scenarios_cov.csv · Doc/asislive/_scenarios_cov_summary.csv
한계  "실행됨"은 호출이 있었다는 뜻이지 결과가 맞다는 뜻이 아니다. 조건·권한·Division 을 바꾼 실행은 아직 일부 화면뿐이다.
"""
import csv, glob, json, os, re, sys, collections

ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
P = lambda *a: os.path.join(ROOT, *a)
for _s in (sys.stdout, sys.stderr):
    try: _s.reconfigure(encoding="utf-8", errors="replace")
    except Exception: pass


def rd(p):
    if not os.path.exists(p): return []
    with open(p, encoding="utf-8-sig", newline="") as f: return list(csv.DictReader(f))


def norm(s):
    return (s or "").strip().split(".")[-1].strip("[]").upper()


def live_calls(mid):
    """지금까지 모든 실측에서 불린 SP → {구간 집합, 실행 수, 그룹 집합}"""
    out = {}; runs = 0
    for d in sorted(glob.glob(P("Doc", "asislive", mid, "run_*"))):
        if os.path.exists(os.path.join(d, "overlap.json")): continue      # 11-14: 다른 화면 런처 실행과 겹친 기록(호출 섞임 가능)은 증거에서 뺀다(asis_live_overlap.py)
        try: cs = json.load(open(os.path.join(d, "calls.json"), encoding="utf-8"))
        except Exception: continue
        cs = cs.get("calls", cs) if isinstance(cs, dict) else cs
        try: grp = (json.load(open(os.path.join(d, "run.json"), encoding="utf-8")) or {}).get("group") or ""
        except Exception: grp = ""
        runs += 1
        for c in cs:
            k = norm(str(c.get("sp") or ""))
            if not k or " " in k: continue
            e = out.setdefault(k, {"phases": set(), "runs": set(), "groups": set()})
            e["phases"].add(c.get("phase") or ""); e["runs"].add(os.path.basename(d)); e["groups"].add(grp)
    return out, runs


def one(mid):
    sc = rd(P("Doc", "asislive", mid, "scenarios_src.csv"))
    if not sc: return None
    lc, runs = live_calls(mid)
    owners = collections.Counter()
    for r in sc:
        for e in filter(None, (r.get("endpoints") or "").split(";")): owners[norm(e)] += 1
    rows = []
    for r in sc:
        eps = [norm(e) for e in (r.get("endpoints") or "").split(";") if e.strip()]
        hit = [e for e in eps if e in lc]
        if r["status"] == "UNREACHED": v = "UNREACHED"
        elif not eps: v = "NO_CALL_EVIDENCE"
        elif not hit: v = "NOT_EXECUTED"
        elif all(owners[e] == 1 for e in hit): v = "EXECUTED"
        else: v = "EXECUTED_AMBIG"
        rows.append(dict(r, cov=v, live_calls=";".join(hit), live_phases=";".join(sorted({p for e in hit for p in lc[e]["phases"]})), live_runs=len({x for e in hit for x in lc[e]["runs"]})))
    with open(P("Doc", "asislive", mid, "scenarios_cov.csv"), "w", encoding="utf-8-sig", newline="") as f:
        w = csv.DictWriter(f, fieldnames=list(rows[0].keys())); w.writeheader(); w.writerows(rows)
    c = collections.Counter(r["cov"] for r in rows)
    byt = collections.Counter((r["type"], r["cov"]) for r in rows)
    return {"id": mid, "runs": runs, "scenarios": len(rows), "EXECUTED": c["EXECUTED"], "EXECUTED_AMBIG": c["EXECUTED_AMBIG"], "NOT_EXECUTED": c["NOT_EXECUTED"],
            "NO_CALL_EVIDENCE": c["NO_CALL_EVIDENCE"], "UNREACHED": c["UNREACHED"],
            "조회_실행": byt[("조회", "EXECUTED")] + byt[("조회", "EXECUTED_AMBIG")], "조회_미실행": byt[("조회", "NOT_EXECUTED")],
            "저장_실행": byt[("저장", "EXECUTED")] + byt[("저장", "EXECUTED_AMBIG")], "저장_미실행": byt[("저장", "NOT_EXECUTED")]}


def main():
    ids = [a.upper() for a in sys.argv[1:] if not a.startswith("-")]; ALL = not ids
    if not ids: ids = sorted(os.path.basename(os.path.dirname(f)) for f in glob.glob(P("Doc", "asislive", "*", "scenarios_src.csv")))
    out = [s for s in (one(i) for i in ids) if s]
    if not ALL:
        for s in out: print(s)
    if ALL and out:
        with open(P("Doc", "asislive", "_scenarios_cov_summary.csv"), "w", encoding="utf-8-sig", newline="") as f:
            w = csv.DictWriter(f, fieldnames=list(out[0].keys())); w.writeheader(); w.writerows(out)
        t = collections.Counter()
        for s in out:
            for k, v in s.items():
                if k != "id": t[k] += v
        print("화면 %d · 분기 시나리오 %d · 실행됨 %d · 실행됨(분기 미특정) %d · 미실행(호출 있는 분기) %d · 호출 기록으로 판정 불가 %d · 도달 경로 없음 %d" % (
            len(out), t["scenarios"], t["EXECUTED"], t["EXECUTED_AMBIG"], t["NOT_EXECUTED"], t["NO_CALL_EVIDENCE"], t["UNREACHED"]))
        print("조회 분기(호출 있음): 실행 %d · 미실행 %d  |  저장 분기(호출 있음): 실행 %d · 미실행 %d" % (t["조회_실행"], t["조회_미실행"], t["저장_실행"], t["저장_미실행"]))
        print("@@LINK 📄 분기 시나리오 실행 현황|Doc/asislive/_scenarios_cov_summary.csv")


if __name__ == "__main__":
    main()
