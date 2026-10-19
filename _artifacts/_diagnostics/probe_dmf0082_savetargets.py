"""P_DMF0082_SAVE_MAIN_DATA 가 쓰는 테이블 (사내 ALL_SOURCE 최신 원문)"""
import sys, re
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import ora, oracledb
u, p, d = ora.conn_info()
with oracledb.connect(user=u, password=p, dsn=d) as c:
    cur = c.cursor()
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE BODY'")
    print("LAST_DDL", cur.fetchone())
    cur.execute("SELECT LINE, TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' ORDER BY LINE")
    src = cur.fetchall()
    start = next(l for l, t in src if re.match(r"\s*PROCEDURE\s+P_DMF0082_SAVE_MAIN_DATA\b", t, re.I))
    end = next((l for l, t in src if l > start and re.match(r"\s*PROCEDURE\s+P_DMF0082_", t, re.I)), src[-1][0])
    print("range", start, end)
    hits = {}
    for l, t in src:
        if start <= l < end and not t.strip().startswith("--"):
            for m in re.finditer(r"(?:INSERT\s+(?:/\*.*?\*/\s*)?INTO|MERGE\s+(?:/\*.*?\*/\s*)?INTO|UPDATE|DELETE\s+(?:FROM)?)\s+(?:SCM_MGR\.)?([A-Z0-9_]+)", t, re.I):
                hits.setdefault(m.group(1).upper(), []).append(l)
            for m in re.finditer(r"\b(PR_[A-Z0-9_]+|PKG_[A-Z0-9_]+\.[A-Z0-9_]+)\s*\(", t, re.I):
                hits.setdefault("CALL " + m.group(1).upper(), []).append(l)
    for k, v in sorted(hits.items()):
        if not k.startswith("GT_"):
            print(k, len(v), v[:5])
