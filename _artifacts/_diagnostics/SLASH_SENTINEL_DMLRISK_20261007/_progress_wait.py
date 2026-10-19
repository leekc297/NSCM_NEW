"""스캔 진행률(행수 기준)이 지정 % 를 넘으면 한 줄 출력하고 끝난다 — 중간 보고용"""
import sys, json, time, pathlib
H = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(H)); import s1_data_scan as s
th = float(sys.argv[1])
tabs = sorted({c["table"] for c in s.population()})
nr = {r["table"]: (r["num_rows"] or 0) for r in json.loads((H / "_scan_stats.json").read_text(encoding="utf-8"))["rows"] if r["inpop"]}
tabs = [t for t in tabs if t not in s.SKIP]
tot = sum(nr.get(t, 0) for t in tabs)
while True:
    try: done = json.loads((H / "_scan_counts.json").read_text(encoding="utf-8"))
    except Exception: time.sleep(5); continue
    dn = sum(nr.get(t, 0) for t in tabs if f"SCM_MGR.{t}" in done); pct = dn / tot * 100
    sec = sum(e.get("sec", 0) for e in done.values()); err = sum(1 for e in done.values() if "error" in e)
    if pct >= th or len(done) >= len(tabs):
        print(f"테이블 {len(done)}/{len(tabs)} · 행수 {pct:.1f}% · 누적 {sec/60:.0f}분 · 오류 {err} · 예상 잔여 {(tot-dn)/(dn/sec)/60 if dn else 0:.0f}분"); break
    time.sleep(30)
