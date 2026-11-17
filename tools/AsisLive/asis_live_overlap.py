# -*- coding: utf-8 -*-
"""asis_live_overlap.py — 런처 실행이 서로 겹친 실행 폴더 찾기 (2026-11-14 잠금 결함 사후 점검)

사고  asis_live_scen_run.py 가 잠금(_run.lock) 시각을 갱신하지 않아, 15분 넘게 도는 실행 중에 다른 실행(CheckList 묶음)이
      잠금을 죽은 것으로 보고 지우고 런처를 하나 더 띄웠다. 두 실행이 겹친 구간의 호출 기록(DbProfile 로그를 시간 구간으로 자름)은
      다른 화면 호출이 섞였을 수 있다. 수정 = asis_live_run.Host.send 가 60초마다 잠금 시각 갱신(백업 .bak_20261114_lock).
판정  실행 폴더의 호출 시각 구간(calls.json 의 at 최소~최대). 폴더 수정 시각은 뒤처리가 다시 써서 쓰지 않는다. 다른 화면 실행 폴더와 구간이 겹치면 '겹침'.
      같은 화면끼리는 같은 실행 프로세스의 연속 단계라 겹침으로 보지 않는다.
출력  Doc/asislive/_overlap_runs.csv (run_dir, menu_id, start, end, overlap_with) · 겹친 폴더에 overlap.json(겹친 상대 목록)을 남긴다.
      overlap.json 이 있는 폴더의 calls.json 은 다른 화면 호출이 섞였을 수 있어 증거로 쓰지 않는다(asis_live_scen_cov.py 가 읽어 뺌).
  python tools/AsisLive/asis_live_overlap.py [--since 20261114]
"""
import csv, datetime as dt, glob, json, os, re, sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
try: sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception: pass


def runs(since):
    """실행 폴더마다 호출 시각 구간(calls.json 의 at 최소~최대)과 다른 화면 인자(p_program_id 등) 호출 수"""
    out = []
    for d in glob.glob(os.path.join(ROOT, "Doc", "asislive", "*", "run_*")):
        if not os.path.isdir(d): continue
        m = re.match(r"run_(\d{8})_(\d{6})", os.path.basename(d))
        if not m or m.group(1) < since: continue
        mid = os.path.basename(os.path.dirname(d)); cs = []
        try: cs = (json.load(open(os.path.join(d, "calls.json"), encoding="utf-8")) or {}).get("calls") or []
        except Exception: pass
        ats = sorted(str(c.get("at") or "")[:19] for c in cs if c.get("at"))
        if not ats: continue
        foreign = 0
        for c in cs:
            pz = c.get("params") or {}
            v = str(pz.get("p_program_id") or pz.get("p_menu_id") or pz.get("p_prg_id") or "").upper()
            if re.match(r"^[A-Z]{2,4}\d{4}", v) and not v.startswith(mid.upper()[:7]): foreign += 1
        out.append({"dir": d, "id": mid, "st": dt.datetime.strptime(ats[0], "%Y-%m-%d %H:%M:%S"), "en": dt.datetime.strptime(ats[-1], "%Y-%m-%d %H:%M:%S"), "foreign": foreign})
    return sorted(out, key=lambda r: r["st"])


def main():
    av = sys.argv[1:]; since = av[av.index("--since") + 1] if "--since" in av else "20261112"
    rs = runs(since); hit = {}
    for i, a in enumerate(rs):
        for b in rs[i + 1:]:
            if b["st"] >= a["en"]: break                       # 같은 초에 끝나고 시작한 것은 차례 실행
            if a["id"] == b["id"]: continue
            hit.setdefault(a["dir"], []).append(b); hit.setdefault(b["dir"], []).append(a)
    p = os.path.join(ROOT, "Doc", "asislive", "_overlap_runs.csv")
    with open(p, "w", encoding="utf-8-sig", newline="") as f:
        w = csv.writer(f); w.writerow(["run_dir", "menu_id", "start", "end", "foreign_calls", "overlap_with"])
        for r in rs:
            o = hit.get(r["dir"])
            if not o: continue
            rel = os.path.relpath(r["dir"], ROOT).replace("\\", "/")
            w.writerow([rel, r["id"], r["st"].strftime("%Y-%m-%d %H:%M:%S"), r["en"].strftime("%Y-%m-%d %H:%M:%S"), r["foreign"],
                        " ".join(sorted({os.path.relpath(x["dir"], ROOT).replace("\\", "/") for x in o}))])
            json.dump({"overlap_with": sorted({os.path.relpath(x["dir"], ROOT).replace("\\", "/") for x in o}),
                       "note": "다른 화면 런처 실행과 시간이 겹침. calls.json 은 다른 화면 호출이 섞였을 수 있어 증거로 쓰지 않음"},
                      open(os.path.join(r["dir"], "overlap.json"), "w", encoding="utf-8"), ensure_ascii=False, indent=1)
    ids = sorted({os.path.basename(os.path.dirname(d)) for d in hit})
    print("[실측 %s] 실행 폴더 %d(%s 이후) 중 겹침 %d, 화면 %d: %s" % (dt.datetime.now().strftime("%Y-%m-%d %H:%M"), len(rs), since, len(hit), len(ids), " ".join(ids)))
    print("@@LINK 📄 겹친 실행 목록|%s" % p)
    return 0


if __name__ == "__main__":
    sys.exit(main())
