# -*- coding: utf-8 -*-
"""AS-IS 실측 호출 목록 다시 채우기 (2026-11-12)
DbProfile 폴더가 빠져 있던 실행분(FP.Common = C:/repo/Log/GSCM.FP_Common)을 같은 시간 구간으로 다시 잘라 calls.json·summary.md·run.json·_summary.csv 를 고친다.
화면을 다시 실행하지 않는다(로그 재해석만). 상태(OK/FAIL/ERROR)는 바꾸지 않는다.
  사용: python tools/AsisLive/backfill_calls.py [--prefix FP]
"""
import argparse, csv, json, os, sys, datetime as dt
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import asis_live_run as R
import asis_live_batch as B

def main():
    ap = argparse.ArgumentParser(); ap.add_argument("--prefix", default=""); a0 = ap.parse_args()
    rows = B.load_summary(); n = chg = 0
    for pid in sorted(rows):
        r = rows[pid]
        if not r.get("run_dir") or (a0.prefix and not pid.startswith(a0.prefix)): continue
        run_dir = os.path.join(R.ROOT, r["run_dir"]); pj = os.path.join(run_dir, "run.json"); cj = os.path.join(run_dir, "calls.json")
        if not (os.path.isfile(pj) and os.path.isfile(cj)): continue
        run = json.load(open(pj, encoding="utf-8")); old = json.load(open(cj, encoding="utf-8"))
        t0, t1 = (dt.datetime.strptime(x, "%Y-%m-%d %H:%M:%S.%f") for x in old["window"])
        a = argparse.Namespace(no_find=False, rows=50)
        code, status, why = run.get("exit"), run.get("status"), run.get("why") or ""
        before = len(old["calls"])
        c2, s2, w2 = R.collect(pid, run_dir, run, t0, t1, a, code, status, why)
        run["calls_backfilled"] = R.ts()[:19]
        R.save_run(pid, run_dir, run, code, status, why, links=False)      # 상태는 원래 값 유지
        calls = json.load(open(cj, encoding="utf-8"))["calls"]
        own = len({x["sp"] for x in calls if x.get("phase") == "find" and not x["sp"].upper().startswith(("UP_FX_", "SCM_SYS_GET_SPREAD_TITLE", "SCP0009_GET_SHEET_CALENDAR", "INSERT INTO [DBO].[TH_UIS_SQL_LOG]", "PR_UI_SQL_LOG"))})
        r["calls_load"] = sum(1 for x in calls if x.get("phase") == "load"); r["calls_find"] = (run.get("counts") or {}).get("calls_find"); r["own_sp_find"] = own
        n += 1; chg += 1 if len(calls) != before else 0
        if (c2, s2) != (code, status): print("[WARN] %s 재판정이 달라짐(원래 %s 유지): %s %s" % (pid, status, s2, w2[:80]))
    B.save_summary(rows)
    print("다시 채움 %d개 · 호출 수가 달라진 실행 %d개" % (n, chg))

if __name__ == "__main__":
    sys.exit(main())
