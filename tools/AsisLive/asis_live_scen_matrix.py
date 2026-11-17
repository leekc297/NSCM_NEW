# -*- coding: utf-8 -*-
"""버튼 분기 실행 결과를 그룹(권한)·Division 별로 맞대는 표 (2026-11-13 · 플랜 P6-3)

  python tools/AsisLive/asis_live_scen_matrix.py <ID> [ID ...]     (ID 생략 = 버튼 실행 기록이 있는 전 화면)
입력  Doc/asislive/<ID>/run_*_acts*/acts.json·calls.json  (asis_live_scen_run.py — 기본 · --group · --division · --edit)
방법  실행 조건 = (그룹, Division, 수정 모드). 같은 조건의 실행이 여러 번이면 가장 최근 것만 쓴다.
      버튼마다 조건별 관찰(실행 여부 · 팝업 이름과 행 수 · 메시지 · 서버 호출과 건수 · 시간 초과 · 그리드 변화 셀 수)을 나란히 놓고,
      조건 사이에 **모양이 다른지**(팝업 종류 · 메시지 문구 · 호출 SP 목록 · 실행 성공 여부)를 표시한다. 건수 차이는 Division·권한의 데이터 차이라 모양 차이로 세지 않는다.
산출  Doc/asislive/<ID>/scenario_matrix.csv   (버튼 × 조건 한 줄씩 + varies 열)
한계  조건을 바꿔 실행한 화면만 비교가 된다(조건이 1개뿐이면 varies = 비교 대상 없음). Division 은 조회 조건을 바꾼 것이고, 소스의 Division 분기 값 전부를 돌았다는 뜻은 아니다.
"""
import csv, glob, json, os, sys, collections

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
P = lambda *a: os.path.join(ROOT, *a)
for _s in (sys.stdout, sys.stderr):
    try: _s.reconfigure(encoding="utf-8", errors="replace")
    except Exception: pass
FRAME = ("UP_FX_", "PR_UI_SQL_LOG", "SCM_SYS_GET_SPREAD_TITLE")


def one(mid):
    runs = {}
    for d in sorted(glob.glob(P("Doc", "asislive", mid, "run_*_acts*"))):
        try: j = json.load(open(os.path.join(d, "acts.json"), encoding="utf-8"))
        except Exception: continue
        if not j.get("acts") or j.get("cond") or j.get("cellrun"): continue                     # 조건 값 변경 기록은 버튼 비교표에 넣지 않는다
        try: cs = json.load(open(os.path.join(d, "calls.json"), encoding="utf-8")).get("calls") or []
        except Exception: cs = []
        key = (j.get("group") or "", j.get("division") or "(기본)", "수정" if j.get("edit") else "")
        runs[key] = (os.path.basename(d), j, cs)                       # 같은 조건은 최근 실행이 덮어쓴다
    if not runs: return None
    rows = []; ctrls = sorted({a["control"] for _n, j, _c in runs.values() for a in j["acts"]})
    for c in ctrls:
        per = []
        for key in sorted(runs):
            name, j, cs = runs[key]
            a = next((x for x in j["acts"] if x["control"] == c), None)
            if a is None: continue
            calls = [(str(x.get("sp")), x.get("rows")) for x in cs if x.get("phase") == ("find" if c == "(조회)" else "action:" + c) and not str(x.get("sp")).startswith(FRAME) and " " not in str(x.get("sp"))]
            pops = [(p.get("form"), p.get("grid_rows")) for p in a.get("popups") or [] if p.get("form") != "ProgressForm"]
            dl = [(x.get("text") or "").replace("\n", " ")[:100] for x in a.get("dialogs") or []]
            shape = (bool(a.get("ok")), tuple(sorted(p[0] or "" for p in pops)), tuple(dl), tuple(sorted({s for s, _r in calls})), bool(a.get("asis_timeout")))
            per.append((key, name, a, calls, pops, dl, shape))
        shapes = {x[6] for x in per}
        varies = "비교 대상 없음(조건 1개)" if len(per) < 2 else ("조건에 따라 다름" if len(shapes) > 1 else "같음")
        for key, name, a, calls, pops, dl, shape in per:
            rows.append({"control": c, "group": key[0], "division": key[1], "mode": key[2], "ok": "실행" if a.get("ok") else "실패: " + str(a.get("error") or "")[:80],
                         "popups": " ; ".join("%s(행 %s)" % p for p in pops), "dialogs": " / ".join(dl), "calls": " ; ".join("%s=%s" % x for x in calls)[:400],
                         "asis_timeout": ",".join(a.get("asis_timeout") or []), "grid_cells": sum(len(g.get("cells") or []) + (g.get("more") or 0) for g in a.get("grid_changes") or [] if "cells" in g) or "",
                         "varies": varies, "run": name})
    with open(P("Doc", "asislive", mid, "scenario_matrix.csv"), "w", encoding="utf-8-sig", newline="") as f:
        w = csv.DictWriter(f, fieldnames=list(rows[0].keys())); w.writeheader(); w.writerows(rows)
    v = collections.Counter(r["varies"] for r in {r["control"]: r for r in rows}.values())
    return {"id": mid, "conditions": len(runs), "buttons": len(ctrls), "same": v.get("같음", 0), "varies": v.get("조건에 따라 다름", 0), "single": v.get("비교 대상 없음(조건 1개)", 0),
            "conds": " | ".join("%s·%s%s" % (k[0], k[1], "·" + k[2] if k[2] else "") for k in sorted(runs))}


def main():
    ids = [a.upper() for a in sys.argv[1:] if not a.startswith("-")]
    if not ids: ids = sorted({os.path.basename(os.path.dirname(os.path.dirname(f))) for f in glob.glob(P("Doc", "asislive", "*", "run_*_acts*", "acts.json"))})
    for mid in ids:
        s = one(mid)
        if not s: print("[%s] 버튼 실행 기록 없음" % mid); continue
        print("[%s] 조건 %d개(%s) · 버튼 %d · 같음 %d · 조건에 따라 다름 %d · 비교 대상 없음 %d" % (s["id"], s["conditions"], s["conds"], s["buttons"], s["same"], s["varies"], s["single"]))
        if len(ids) <= 5: print("@@LINK 📄 그룹·Division 별 비교|Doc/asislive/%s/scenario_matrix.csv" % mid)
    return 0


if __name__ == "__main__":
    sys.exit(main())
