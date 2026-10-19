"""[조회 전용] 변환 대상 컬럼과 조인·비교되지만 변환 목록(모집단)에 없는 컬럼 — AS-IS(개발 DB) 와 TO-BE(사내) 의 값 실태
대상 = _risk.json 의 A_join 상대 컬럼(모집단 밖) + H 의 모집단 밖 컬럼
AS-IS: NULL / '' / 공백만 / '-' / 전체   (MSSQL 은 ''=' ' 라 DATALENGTH 로 가른다)
TO-BE: NULL / '-' / '/' / 전체
결과 = _partner_scan.json (테이블 단위 이어쓰기)
"""
import sys, json, re, time, pathlib, importlib.util, collections
HERE = pathlib.Path(__file__).resolve().parent
RAW = pathlib.Path(r"C:\Projects\NSCM\Doc\_analysis\asis_delta_20261002\_raw")
sys.path.insert(0, str(RAW)); sys.path.insert(0, str(HERE))
spec = importlib.util.spec_from_file_location("snap", RAW / "01_snapshot.py"); snap = importlib.util.module_from_spec(spec); spec.loader.exec_module(snap)
from common3 import env
import s1_data_scan as s

R = json.loads((HERE / "_risk.json").read_text(encoding="utf-8"))
cols = collections.defaultdict(set)
for x in R["A_join"]:
    if x["other_kind"].startswith("모집단 밖"): cols[x["other_table"]].add(x["other_col"])
for x in R["H_code_to_slash_data_stays"]:
    for m in re.finditer(r"([A-Z_][\w$#]*)\.([A-Z_][\w$#]*) \[모집단 밖", x["cols"]): cols[m.group(1)].add(m.group(2))
OUT = HERE / "_partner_scan.json"
done = json.loads(OUT.read_text(encoding="utf-8")) if OUT.exists() else {}
print("대상 테이블", len(cols), "컬럼", sum(len(v) for v in cols.values()), flush=True)

a = snap.asis_conn(env()).cursor()
a.execute("SELECT DB_NAME(), CONVERT(varchar(19), GETDATE(), 120)"); print("AS-IS", tuple(a.fetchone()), flush=True)
a.execute("SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, IS_NULLABLE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA='dbo'")
acols = {(t.upper(), c.upper()): (dt, nu) for t, c, dt, nu in a.fetchall()}
o = s.connect().cursor()
o.execute("SELECT TABLE_NAME, COLUMN_NAME, NULLABLE FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR'")
ocols = {(t, c): n for t, c, n in o}

for n, (t, cs) in enumerate(sorted(cols.items()), 1):
    if t in done and "error" not in json.dumps(done[t]): continue
    ent = {"asis": {}, "tobe": {}}
    cs = sorted(cs)
    # AS-IS
    ac = [c for c in cs if (t, c) in acols and acols[(t, c)][0] in ("varchar", "nvarchar", "char", "nchar")]
    if ac:
        parts = []
        for c in ac:
            parts += [f"SUM(CASE WHEN [{c}] IS NULL THEN 1 ELSE 0 END)", f"SUM(CASE WHEN DATALENGTH([{c}]) = 0 THEN 1 ELSE 0 END)",
                      f"SUM(CASE WHEN DATALENGTH([{c}]) > 0 AND LTRIM(RTRIM([{c}])) = '' THEN 1 ELSE 0 END)", f"SUM(CASE WHEN RTRIM([{c}]) = '-' THEN 1 ELSE 0 END)"]
        t0 = time.time()
        try:
            a.execute(f"SELECT COUNT_BIG(*), {', '.join(parts)} FROM dbo.[{t}] WITH (NOLOCK)"); r = a.fetchone()
            ent["asis_rows"] = int(r[0]); ent["asis_sec"] = round(time.time() - t0, 1)
            for i, c in enumerate(ac):
                v = r[1 + i * 4: 5 + i * 4]
                ent["asis"][c] = dict(null=int(v[0] or 0), empty=int(v[1] or 0), space=int(v[2] or 0), dash=int(v[3] or 0), nullable=acols[(t, c)][1])
        except Exception as e:
            ent["asis_error"] = str(e)[:200]
    for c in cs:
        if c not in ent["asis"]: ent["asis"].setdefault(c, {"missing": "AS-IS 에 테이블·컬럼 없음" if (t, c) not in acols else "문자형 아님"})
    # TO-BE
    oc = [c for c in cs if (t, c) in ocols]
    if oc:
        parts = []
        for c in oc:
            q = '"%s"' % c
            parts += [f"SUM(CASE WHEN {q} IS NULL THEN 1 ELSE 0 END)", f"SUM(CASE WHEN {q} = '-' THEN 1 ELSE 0 END)", f"SUM(CASE WHEN {q} = '/' THEN 1 ELSE 0 END)"]
        t0 = time.time()
        try:
            o.execute(f'SELECT COUNT(*), {", ".join(parts)} FROM SCM_MGR."{t}"'); r = o.fetchone()
            ent["tobe_rows"] = r[0]; ent["tobe_sec"] = round(time.time() - t0, 1)
            for i, c in enumerate(oc):
                v = r[1 + i * 3: 4 + i * 3]
                ent["tobe"][c] = dict(null=v[0] or 0, dash=v[1] or 0, slash=v[2] or 0, nullable=ocols[(t, c)])
        except Exception as e:
            ent["tobe_error"] = str(e)[:200]
    done[t] = ent
    OUT.write_text(json.dumps(done, ensure_ascii=False), encoding="utf-8")
    print(f"[{n}/{len(cols)}] {t} asis={ent.get('asis_rows')}({ent.get('asis_sec')}s) tobe={ent.get('tobe_rows')}({ent.get('tobe_sec')}s) {ent.get('asis_error','')} {ent.get('tobe_error','')}", flush=True)
print("done", flush=True)
