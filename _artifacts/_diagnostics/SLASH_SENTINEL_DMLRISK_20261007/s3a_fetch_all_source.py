"""[조회 전용] TO-BE 전 프로그램·뷰 원문 수집 (다른 세션 캐시는 '-' 가 있는 298 객체만 담고 있어 조인 추출에 부족)
결과 = _all_src.json.gz  {"at":..., "objs": {"OWNER|TYPE|NAME": "text"}}"""
import sys, json, gzip, pathlib, datetime
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
import s1_data_scan as s
HERE = pathlib.Path(__file__).resolve().parent
OWN = ("SCM_MGR", "FP_MGR", "INF_MGR", "OPT_MGR", "ENG_SCP")
con = s.connect(); cur = con.cursor(); cur.arraysize = 5000
inown = ",".join("'%s'" % o for o in OWN)
cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM dual"); at = cur.fetchone()[0]
objs = {}
cur.execute(f"""SELECT OWNER, TYPE, NAME, LINE, TEXT FROM ALL_SOURCE
                 WHERE OWNER IN ({inown}) AND TYPE IN ('PROCEDURE','FUNCTION','PACKAGE BODY','TRIGGER') ORDER BY OWNER, TYPE, NAME, LINE""")
buf = {}
for o, t, n, ln, tx in cur:
    buf.setdefault(f"{o}|{t}|{n}", []).append(tx or "\n")
for k, v in buf.items(): objs[k] = "".join(x if x.endswith("\n") else x + "\n" for x in v)
con.outputtypehandler = lambda c, m: c.var(oracledb.DB_TYPE_LONG, arraysize=c.arraysize) if False else None
import oracledb
cur = con.cursor()
cur.execute(f"SELECT OWNER, VIEW_NAME, TEXT FROM ALL_VIEWS WHERE OWNER IN ({inown})")
nv = 0
for o, n, tx in cur:
    objs[f"{o}|VIEW|{n}"] = str(tx or ""); nv += 1
with gzip.open(HERE / "_all_src.json.gz", "wt", encoding="utf-8") as f:
    json.dump({"at": at, "objs": objs}, f, ensure_ascii=False)
import collections
print(at, "객체", len(objs), collections.Counter(k.split("|")[1] for k in objs), "문자수", sum(len(v) for v in objs.values()))
