# -*- coding: utf-8 -*-
"""AS-IS 저장 인자 ↔ TO-BE 저장 인자 대조 (2026-11-13 · 플랜 P6-4 저장)

  python tools/AsisLive/asis_live_save_cmp.py <ID> [ID ...]     (ID 생략 = 저장 시범 기록 run_*_save/save.json 이 있는 화면)
입력  AS-IS  Doc/asislive/<ID>/run_*_save/save.json 의 save_call (런처에서 저장 버튼을 눌렀을 때 저장 SP 로 실제 넘어간 인자 · asis_live_save.py)
      TO-BE  Doc/verify/<ID>/sqllog_calls.json 의 kind=SAVE 호출(E2E 가 TO-BE 화면에서 저장했을 때 사내 호출 로그에 남은 인자 · sqllog_calls.py)
방법  인자 이름을 맞춘다(TO-BE camelCase → snake · AS-IS p_ 접두 제거). AS-IS 저장 1건마다 TO-BE 저장 호출 중 **값이 가장 많이 같은 것**을 짝으로 고른다
      (같은 행·같은 조작을 한 호출을 찾기 위함 — TO-BE 가 그 행을 저장한 적이 없으면 값이 많이 다르게 나온다).
      인자별: SAME 값 같음 · DIFF 값 다름 · ASIS_ONLY/TOBE_ONLY 한쪽에만 있음 · USER 사용자 ID(계정이 달라 비교 제외)
산출  Doc/asislive/<ID>/save_compare.csv · 화면별 한 줄 요약 출력
판정  인자 구성 같음 = 한쪽에만 있는 인자 0 / 값 차이는 조작이 같은 호출끼리일 때만 의미가 있다(짝의 같은 값 비율을 함께 적는다).
      디버그 플래그 같은 운영과 무관한 인자 차이도 그대로 적는다 — 오류 판정은 하지 않는다(판정 행·원장 미생성).
"""
import csv, glob, json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
P = lambda *a: os.path.join(ROOT, *a)
for _s in (sys.stdout, sys.stderr):
    try: _s.reconfigure(encoding="utf-8", errors="replace")
    except Exception: pass
USERKEY = re.compile(r"(^|_)(user_id|created_by|updated_by|login_id)$|^user$")


def snake(k):
    k = re.sub(r"([a-z0-9])([A-Z])", r"\1_\2", str(k)).lower()
    return re.sub(r"^p_", "", k)


def norm(d):
    return {snake(k): ("" if v is None else str(v)) for k, v in (d or {}).items()}


def one(mid):
    asis = []
    for f in sorted(glob.glob(P("Doc", "asislive", mid, "run_*_save*", "save.json"))):
        try: j = json.load(open(f, encoding="utf-8"))
        except Exception: continue
        for c in j.get("save_call") or []:
            asis.append({"run": os.path.basename(os.path.dirname(f)), "sp": c.get("sp"), "params": norm(c.get("params")), "status": j.get("status")})
    if not asis: return None
    try: tj = json.load(open(P("Doc", "verify", mid, "sqllog_calls.json"), encoding="utf-8"))
    except Exception: tj = {}
    tobe = [{"proc": c.get("proc"), "at": c.get("at"), "by": c.get("by"), "params": norm(c.get("fe"))} for c in tj.get("calls") or [] if c.get("kind") == "SAVE"]
    rows = []; summ = []
    for a in asis:
        ap = a["params"]
        if not tobe:
            for k in sorted(ap): rows.append({"asis_run": a["run"], "asis_sp": a["sp"], "tobe_proc": "", "tobe_at": "", "param": k, "asis": ap[k], "tobe": "", "verdict": "TOBE_NO_SAVE_CALL"})
            summ.append({"run": a["run"], "sp": a["sp"], "pair": "TO-BE 저장 호출 기록 없음", "same": 0, "diff": 0, "only": len(ap)}); continue
        def score(t):
            ks = [k for k in set(ap) & set(t["params"]) if not USERKEY.search(k)]
            return (sum(1 for k in ks if ap[k] == t["params"][k]), t["at"] or "")
        t = max(tobe, key=score); tp = t["params"]; same = diff = only = 0
        for k in sorted(set(ap) | set(tp)):
            x, y = ap.get(k), tp.get(k)
            if USERKEY.search(k): v = "USER(비교 제외)"
            elif x is None: v = "TOBE_ONLY"; only += 1
            elif y is None: v = "ASIS_ONLY"; only += 1
            elif x == y: v = "SAME"; same += 1
            else: v = "DIFF"; diff += 1
            rows.append({"asis_run": a["run"], "asis_sp": a["sp"], "tobe_proc": t["proc"], "tobe_at": t["at"], "param": k, "asis": x, "tobe": y, "verdict": v})
        summ.append({"run": a["run"], "sp": a["sp"], "pair": "%s @%s" % (t["proc"], t["at"]), "same": same, "diff": diff, "only": only,
                     "diffs": "; ".join("%s: %s↔%s" % (r["param"], r["asis"], r["tobe"]) for r in rows if r["asis_run"] == a["run"] and r["verdict"] in ("DIFF", "ASIS_ONLY", "TOBE_ONLY"))})
    with open(P("Doc", "asislive", mid, "save_compare.csv"), "w", encoding="utf-8-sig", newline="") as f:
        w = csv.DictWriter(f, fieldnames=list(rows[0].keys())); w.writeheader(); w.writerows(rows)
    return {"id": mid, "asis_saves": len(asis), "tobe_saves": len(tobe), "pairs": summ}


def main():
    ids = [a.upper() for a in sys.argv[1:] if not a.startswith("-")]
    if not ids: ids = sorted({os.path.basename(os.path.dirname(os.path.dirname(f))) for f in glob.glob(P("Doc", "asislive", "*", "run_*_save*", "save.json"))})
    for mid in ids:
        s = one(mid)
        if not s: print("[%s] AS-IS 저장 시범 기록 없음(asis_live_save.py 를 먼저 실행)" % mid); continue
        print("[%s] AS-IS 저장 %d건 · TO-BE 저장 호출 %d건" % (mid, s["asis_saves"], s["tobe_saves"]))
        for p in s["pairs"]:
            print("   %s %s ↔ %s · 같음 %d · 다름 %d · 한쪽에만 %d%s" % (p["run"], p["sp"], p["pair"], p["same"], p["diff"], p["only"], (" · " + p["diffs"][:200]) if p.get("diffs") else ""))
        print("@@LINK 📄 저장 인자 대조|Doc/asislive/%s/save_compare.csv" % mid)
    return 0


if __name__ == "__main__":
    sys.exit(main())
