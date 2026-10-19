"""[조회 전용] 유니크 키 중복 시뮬레이션 — 변환 대상 키 컬럼의 '-'·공백만 값을 '/' 로 본 뒤 키가 겹치는 그룹 수 (상한: 실제 변환은 AS-IS 빈값 유래 행만)
대상 = _risk.json B_unique 중 need_check (공백만 값 보유 또는 '-'·'/' 공존) — 1억 행 초과 테이블은 제외
결과 = _dupcheck.json
"""
import sys, json, time, pathlib
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE)); import s1_data_scan as s
R = json.loads((HERE / "_risk.json").read_text(encoding="utf-8"))
OUT = HERE / "_dupcheck.json"
done = json.loads(OUT.read_text(encoding="utf-8")) if OUT.exists() else {}
con = s.connect(); cur = con.cursor()
cur.execute("SELECT sys_context('userenv','db_name'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM dual"); print("DB", cur.fetchone(), flush=True)
jobs = [b for b in R["B_unique"] if b["need_check"] and b["table"] not in s.SKIP]
print("대상", len(jobs), flush=True)
for n, b in enumerate(jobs, 1):
    key = f'{b["table"]}|{b["name"]}'
    if key in done and "error" not in done[key]: continue
    conv = set(b["conv_cols"])
    exprs = [(f"""CASE WHEN "{c}" = '-' OR TRIM("{c}") IS NULL THEN '/' ELSE "{c}" END""" if c in conv else f'"{c}"') for c in b["cols"]]
    sql = f"""SELECT COUNT(*), NVL(SUM(C), 0) FROM (SELECT {", ".join(e + f" K{i}" for i, e in enumerate(exprs))}, COUNT(*) C FROM SCM_MGR."{b["table"]}" GROUP BY {", ".join(exprs)} HAVING COUNT(*) > 1)"""
    cur_sql = f"""SELECT COUNT(*) FROM SCM_MGR."{b["table"]}" WHERE """ + " OR ".join(f"""("{c}" = '-' OR TRIM("{c}") IS NULL)""" for c in conv)
    ent = dict(table=b["table"], key=b["name"], type=b["type"], cols=b["cols"], conv_cols=b["conv_cols"], rows=b["rows"])
    t0 = time.time()
    try:
        cur.execute(cur_sql); ent["affected_rows_upper"] = cur.fetchone()[0]
        cur.execute(sql); g, c = cur.fetchone(); ent["dup_groups"] = g; ent["dup_rows"] = c
    except Exception as e:
        ent["error"] = str(e)[:300]
        try: con.ping()
        except Exception: con = s.connect(); cur = con.cursor()
    ent["sec"] = round(time.time() - t0, 1); done[key] = ent
    OUT.write_text(json.dumps(done, ensure_ascii=False, indent=1), encoding="utf-8")
    print(f"[{n}/{len(jobs)}] {key} affected≤{ent.get('affected_rows_upper')} dup_groups={ent.get('dup_groups')} dup_rows={ent.get('dup_rows')} {ent.get('error','')} ({ent['sec']}s)", flush=True)
print("done", flush=True)
