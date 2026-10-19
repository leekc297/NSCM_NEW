"""[조회 전용] AS-IS(개발 DB) 에서 '-' 값 행의 생성 시점 — 2026-09-01 이전 vs 이후 (사용자 지적 10-07: 9월 이후 AS-IS 행은 사내 오라클에서 넘어간 것일 수 있음)
대상 = DEFAULT 대상 컬럼 중 AS-IS '-' 행 > 0 인 컬럼 (--col PLANT_SITE_ID 로 컬럼명 한정 가능)
컬럼별: '-' 전체 / 9월 이전 생성 / 9월 이후 생성 / 생성일 없음 / 최소·최대 생성일 / '-' 행 CREATED_BY 상위
결과 = _asis_dash_bydate.json
"""
import sys, json, pathlib, importlib.util, collections, time, shutil, re
import openpyxl
HERE = pathlib.Path(__file__).resolve().parent
RAW = pathlib.Path(r"C:\Projects\NSCM\Doc\_analysis\asis_delta_20261002\_raw")
sys.path.insert(0, str(RAW)); sys.path.insert(0, str(HERE))
spec = importlib.util.spec_from_file_location("snap", RAW / "01_snapshot.py"); snap = importlib.util.module_from_spec(spec); spec.loader.exec_module(snap)
from common3 import env
import s1_data_scan as s
only = None
if "--col" in sys.argv: only = sys.argv[sys.argv.index("--col") + 1].upper()
PS = json.loads((HERE / "_partner_scan.json").read_text(encoding="utf-8"))
EX = json.loads((HERE / "_pop_extra.json").read_text(encoding="utf-8"))["rows"]
tmp = HERE / "_src_copy.xlsx"; shutil.copy2(s.SRC, tmp)
r1 = list(openpyxl.load_workbook(tmp, read_only=True, data_only=True)["1_컬럼판정"].iter_rows(values_only=True)); h1 = [str(c) for c in r1[0]]
def num(v):
    try: return int(str(v).replace(",", ""))
    except Exception: return None
ASIS = {}
for r in r1[1:]:
    if r and r[1]: ASIS[(r[1], r[2])] = num(r[h1.index("AS-IS '-' 행수(10-01)")])
for t, e in PS.items():
    for c, a in e.get("asis", {}).items():
        if a and "missing" not in a and (t, c) not in ASIS: ASIS[(t, c)] = a["dash"]
targets = [(c["table"], c["column"]) for c in s.population()] + [(e["table"], e["column"]) for e in EX if e.get("kind") != "new_table"]
need = collections.defaultdict(set)
unknown_mode = "--unknown" in sys.argv   # AS-IS 실측이 없는 대상 컬럼(추가분·AS-IS 없는 테이블)만
for t, c in targets:
    if unknown_mode:
        if ASIS.get((t, c)) is None: need[t].add(c)   # xlsx 에 행은 있으나 실측값이 비어 있는 컬럼 포함
    elif (ASIS.get((t, c)) or 0) > 0 and (only is None or c == only): need[t].add(c)
OUT = HERE / ("_asis_dash_bydate_UNKNOWN.json" if unknown_mode else ("_asis_dash_bydate.json" if only is None else f"_asis_dash_bydate_{only}.json"))
done = json.loads(OUT.read_text(encoding="utf-8")) if OUT.exists() else {}
a = snap.asis_conn(env()).cursor()
a.execute("SELECT DB_NAME(), CONVERT(varchar(19), GETDATE(), 120)"); print("AS-IS", tuple(a.fetchone()), "테이블", len(need), "컬럼", sum(len(v) for v in need.values()), flush=True)
a.execute("SELECT TABLE_NAME, COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA='dbo' AND COLUMN_NAME IN ('CREATION_DATE','CREATED_BY','LAST_UPDATE_DATE')")
has = collections.defaultdict(set)
for t, c in a.fetchall(): has[t.upper()].add(c.upper())
for n, (t, cs) in enumerate(sorted(need.items()), 1):
    if t in done and "error" not in json.dumps(done[t]): continue
    ent = {}
    cd = "CREATION_DATE" in has.get(t, set()); cb = "CREATED_BY" in has.get(t, set())
    for c in sorted(cs):
        t0 = time.time(); e = {}
        try:
            if cd:
                a.execute(f"""SELECT COUNT_BIG(*), SUM(CASE WHEN CREATION_DATE < '2026-09-01' THEN 1 ELSE 0 END), SUM(CASE WHEN CREATION_DATE >= '2026-09-01' THEN 1 ELSE 0 END),
                                     SUM(CASE WHEN CREATION_DATE IS NULL THEN 1 ELSE 0 END), CONVERT(varchar(19), MIN(CREATION_DATE), 120), CONVERT(varchar(19), MAX(CREATION_DATE), 120)
                                FROM dbo.[{t}] WITH (NOLOCK) WHERE RTRIM([{c}]) = '-'""")
                r = a.fetchone(); e = dict(dash=int(r[0]), before_sep=int(r[1] or 0), after_sep=int(r[2] or 0), no_date=int(r[3] or 0), min_date=r[4], max_date=r[5])
                if cb:
                    a.execute(f"""SELECT TOP 6 CREATED_BY, COUNT_BIG(*), SUM(CASE WHEN CREATION_DATE >= '2026-09-01' THEN 1 ELSE 0 END) FROM dbo.[{t}] WITH (NOLOCK) WHERE RTRIM([{c}]) = '-' GROUP BY CREATED_BY ORDER BY 2 DESC""")
                    e["created_by"] = [(x, int(y), int(z or 0)) for x, y, z in a.fetchall()]
            else:
                a.execute(f"SELECT COUNT_BIG(*) FROM dbo.[{t}] WITH (NOLOCK) WHERE RTRIM([{c}]) = '-'"); e = dict(dash=int(a.fetchone()[0]), note="CREATION_DATE 없음")
        except Exception as ex:
            msg = str(ex)
            e = dict(dash=0, before_sep=0, after_sep=0, no_date=0, note="AS-IS 에 테이블·컬럼 없음") if ("Invalid object name" in msg or "Invalid column name" in msg) else dict(error=msg[:200])
        e["sec"] = round(time.time() - t0, 1); ent[c] = e
        print(f"[{n}/{len(need)}] {t}.{c} {json.dumps(e, ensure_ascii=False)[:230]}", flush=True)
    done[t] = ent; OUT.write_text(json.dumps(done, ensure_ascii=False, indent=1), encoding="utf-8")
print("done", flush=True)
