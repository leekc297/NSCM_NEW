"""[조회 전용] DML 실효성 — 변환 대상 컬럼 중 TO-BE '-' 보유 여부가 아직 불명(통계 없음·판정 불가)이거나 공존 컬럼인데 미실측인 것만 추가 실측
(통계 '-' 없음 = DML 생략 후보 · 통계 '-' 있음 = DML 유효 → 추가 실측 불필요)
1억 행 초과(s1.SKIP) 및 3천만 행 초과 테이블은 실측하지 않고 통계로 둔다 — 사용자 지시(전체 불필요)
결과 = _scan_counts.json 에 이어쓰기(테이블 단위, 필요한 컬럼만)
"""
import sys, json, time, pathlib, collections
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE)); import s1_data_scan as s
ST = {(r["table"], r["column"]): r for r in json.loads((HERE / "_scan_stats.json").read_text(encoding="utf-8"))["rows"]}
EX = json.loads((HERE / "_pop_extra.json").read_text(encoding="utf-8"))["rows"]
pop = [c for c in s.population() if not c["held"] and c["table"] != "SCM_ADM_LOOKUP_MASTER_DETAIL"] + [dict(table=e["table"], column=e["column"], cls="추가분") for e in EX if e.get("kind") != "new_table"]
CN = json.loads(s.COUNTS.read_text(encoding="utf-8"))
measured = {(k.split(".", 1)[1], c) for k, e in CN.items() for c in e.get("cols", {})}
need = collections.defaultdict(set)
for c in pop:
    k = (c["table"], c["column"])
    if k in measured or c["table"] in s.SKIP: continue
    f = ST.get(k, {}).get("flag"); nr = ST.get(k, {}).get("num_rows") or 0
    if nr > 30_000_000: continue
    if f in (None, "nostat", "unknown(low<'-')") or str(c["cls"]).startswith("공존") or str(c["cls"]).startswith("추가분"):
        need[c["table"]].add(c["column"])
print("실측 테이블", len(need), "컬럼", sum(len(v) for v in need.values()), "행수 합", f"{sum((ST.get((t, next(iter(cs))), {}).get('num_rows') or 0) for t, cs in need.items()):,}", flush=True)
con = s.connect(); cur = con.cursor()
cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM dual"); print("DB", cur.fetchone(), flush=True)
for n, (t, cs) in enumerate(sorted(need.items(), key=lambda x: ST.get((x[0], next(iter(x[1]))), {}).get("num_rows") or 0), 1):
    cs = sorted(cs); parts = []
    for c in cs:
        q = f'"{c}"'
        parts += [f"SUM(CASE WHEN {q} = '-' THEN 1 ELSE 0 END)", f"SUM(CASE WHEN {q} = '/' THEN 1 ELSE 0 END)", f"SUM(CASE WHEN {q} = '--' THEN 1 ELSE 0 END)", f"SUM(CASE WHEN {q} IS NOT NULL AND TRIM({q}) IS NULL THEN 1 ELSE 0 END)"]
    t0 = time.time(); key = f"SCM_MGR.{t}"; ent = CN.get(key) or {"missing_or_nonchar": [], "cols": {}}
    try:
        cur.execute(f'SELECT COUNT(*), {", ".join(parts)} FROM SCM_MGR."{t}"'); r = cur.fetchone()
        ent["rows"] = r[0]; ent["sec"] = round(time.time() - t0, 1); ent.pop("error", None)
        for i, c in enumerate(cs):
            v = r[1 + i * 4: 5 + i * 4]
            ent["cols"][c] = dict(dash=v[0] or 0, slash=v[1] or 0, ddash=v[2] or 0, blank=v[3] or 0, held=False, cls="s12 추가 실측")
    except Exception as e:
        ent["error"] = str(e)[:300]
        try: con.ping()
        except Exception: con = s.connect(); cur = con.cursor()
    CN[key] = ent; s.COUNTS.write_text(json.dumps(CN, ensure_ascii=False), encoding="utf-8")
    print(f"[{n}/{len(need)}] {t} rows={ent.get('rows')} {ent.get('error','')} ({round(time.time()-t0,1)}s)", flush=True)
print("done", flush=True)
