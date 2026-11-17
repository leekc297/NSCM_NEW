# -*- coding: utf-8 -*-
"""TO-BE 조건 시나리오 반복 실행 (2026-11-13 · 플랜 P5)

  python tools/AsisLive/asis_live_scen_loop.py [ID ...] [--rounds 3] [--fresh]
순서  (--fresh) 대상 화면을 기본 조건으로 다시 측정 → 대표 조건 다시 고정(--repin) → 시나리오 초기화
      반복: 조건 대조 → 시나리오 생성(앞 회차 값 누적) → 시나리오가 바뀐 화면만 재측정
      값을 넣으면 딸린 목록(Version 등)이 바뀌어 새 차이가 생기므로, 시나리오가 더 바뀌지 않을 때까지(최대 rounds) 되풀이한다.
대상  ID 생략 = _cond_summary.csv 의 "조건 다름" 화면
산출  Doc/asislive/_scen_loop.csv (회차별 화면 상태)
"""
import csv, hashlib, json, os, subprocess, sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
P = lambda *a: os.path.join(ROOT, *a)
PY = sys.executable
for _s in (sys.stdout, sys.stderr):
    try: _s.reconfigure(encoding="utf-8", errors="replace")
    except Exception: pass


def run(args, show=True):
    p = subprocess.run([PY] + args, cwd=ROOT, capture_output=True, text=True, encoding="utf-8", errors="replace")
    if show:
        for ln in (p.stdout or "").splitlines():
            if ln.startswith("[") or ln.startswith("요약") or ln.startswith("합계") or ln.startswith("일괄"): print("   " + ln[:260], flush=True)
    return p.returncode


def sig(mid):
    try: sc = json.load(open(P("Doc", "asislive", mid, "scenario_tobe.json"), encoding="utf-8"))
    except Exception: return "", 0
    sets = [(s.get("name"), s.get("prop"), s.get("value")) for s in sc.get("set") or []]
    return hashlib.md5(json.dumps(sets, ensure_ascii=False).encode("utf-8")).hexdigest(), len(sets)


def cond_rows():
    p = P("Doc", "asislive", "_cond_summary.csv")
    if not os.path.exists(p): return {}
    with open(p, encoding="utf-8-sig", newline="") as f: return {r["id"]: r for r in csv.DictReader(f)}


def main():
    av = sys.argv[1:]; ids = [a.upper() for a in av if not a.startswith("-") and not a.isdigit()]
    rounds = int(av[av.index("--rounds") + 1]) if "--rounds" in av else 3
    fresh = "--fresh" in av
    if not ids:
        ids = [i for i, r in cond_rows().items() if r["cond"] == "조건 다름"]
    print("대상 %d개: %s" % (len(ids), ",".join(ids)), flush=True)
    batch = [os.path.join("tools", "AsisLive", "asis_live_batch.py"), "--fill", "recent", "--find-timeout", "1900"]
    cond = [os.path.join("tools", "AsisLive", "asis_live_cond.py")]
    scen = [os.path.join("tools", "AsisLive", "asis_live_scen.py")]
    log = []
    if fresh:
        print("[0] 기본 조건으로 재측정", flush=True); run(batch + ["--only", ",".join(ids)])
        run(cond + ["--repin"], show=False); run(scen + ids + ["--reset"], show=False)
    else:
        run(cond, show=False); run(scen + ids, show=False)
    prev = {i: "" for i in ids}
    for rnd in range(1, rounds + 1):
        cur = {i: sig(i) for i in ids}
        todo = [i for i in ids if cur[i][1] > 0 and cur[i][0] != prev[i]]
        cr = cond_rows()
        for i in ids:
            log.append({"round": rnd - 1, "id": i, "cond": (cr.get(i) or {}).get("cond"), "diff": (cr.get(i) or {}).get("diff"), "sets": cur[i][1], "rerun": "Y" if i in todo else ""})
        print("[%d회차] 시나리오가 바뀐 화면 %d개: %s" % (rnd, len(todo), ",".join(todo)), flush=True)
        if not todo: break
        for i in todo: prev[i] = cur[i][0]
        run(batch + ["--scenario-tobe", "--only", ",".join(todo)])
        run(cond, show=False); run(scen + ids, show=False)
    cr = cond_rows()
    for i in ids:
        log.append({"round": "끝", "id": i, "cond": (cr.get(i) or {}).get("cond"), "diff": (cr.get(i) or {}).get("diff"), "sets": sig(i)[1], "rerun": ""})
        print("[끝] %s %s · 다른 인자 %s · 넣은 값 %s · %s" % (i, (cr.get(i) or {}).get("cond"), (cr.get(i) or {}).get("diff"), sig(i)[1], ((cr.get(i) or {}).get("diff_params") or "")[:200]), flush=True)
    with open(P("Doc", "asislive", "_scen_loop.csv"), "w", encoding="utf-8-sig", newline="") as f:
        w = csv.DictWriter(f, fieldnames=["round", "id", "cond", "diff", "sets", "rerun"]); w.writeheader(); w.writerows(log)
    run(cond)


if __name__ == "__main__":
    main()
