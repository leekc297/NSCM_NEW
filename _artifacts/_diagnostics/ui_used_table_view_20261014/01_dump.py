"""01_dump.py — SYSTEM·ADMIN·DM UI 사용 TABLE/VIEW 조사용 사내오라클(ZIOUI1) 읽기 전용 덤프 (2026-10-14)

#152 FRESH: 이 덤프가 유일한 기준본. SELECT 만 수행한다(DDL/DML 0).
출력: meta/*.csv, dict/*.csv, source/all_source.jsonl, SNAPSHOT.txt
"""
import csv, json, pathlib, sys, datetime
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

OUT = pathlib.Path(__file__).resolve().parent
OWNERS = ("SCM_MGR", "FP_MGR", "INF_MGR", "OPT_MGR", "ENG_SCP", "VECSYS")
OWN = ",".join(f"'{o}'" for o in OWNERS)

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS'")
host, dbn, snap = cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), SYS_CONTEXT('USERENV','DB_NAME'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL").fetchone()

META = {
    "mnu_m": "SELECT * FROM SCM_MGR.SCM_ADM_MNU_M",
    "btn_mpg": "SELECT * FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M",
    "api_m": "SELECT * FROM SCM_MGR.SCM_ADM_API_M",
    "proc_m": "SELECT * FROM SCM_MGR.SCM_ADM_PROC_M",
    "cmbo_sql": "SELECT * FROM SCM_MGR.SCM_ADM_CMBO_SQL_M",
    "excel_columns": "SELECT PROGRAM_ID, SHEET_NAME, STORAGE_SQL_ID, VALID_YN, LAST_UPDATE_DATE FROM SCM_MGR.SCM_ADM_EXCEL_COLUMNS",
    "sheet_columns": """SELECT PROGRAM_ID, SHEET_NAME, COLUMN_NAME, CELL_CONTROL_OBJECT_TYPE_CODE, CELL_COMBO_DATA_TYPE,
                               ATTRIBUTE1, ATTRIBUTE9, VALID_YN, VISIBLE_FLAG, DIVISION_ID FROM SCM_MGR.SCM_MST_SHEET_COLUMNS""",
    "lookup_master": "SELECT LOOKUP_TYPE, LOOKUP_GROUP, VALID_YN FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER",
    "sql_log_calls": r"""SELECT UPPER(REGEXP_SUBSTR(DBMS_LOB.SUBSTR(SQL_TEXT, 1300, 1), '\{\s*call\s+([A-Za-z0-9_$#.]+)', 1, 1, 'i', 1)) PROC,
                               REGEXP_SUBSTR(DBMS_LOB.SUBSTR(PARAMS, 2000, 1), '"mnuId"\s*:\s*"([^"]*)"', 1, 1, NULL, 1) MNU_ID,
                               COUNT(*) CNT, MIN(EXECUTE_TIME) FIRST_EXEC, MAX(EXECUTE_TIME) LAST_EXEC
                          FROM SCM_MGR.SCM_COM_SQL_LOG
                         WHERE REGEXP_LIKE(DBMS_LOB.SUBSTR(SQL_TEXT, 1300, 1), '\{\s*call\s', 'i')
                         GROUP BY UPPER(REGEXP_SUBSTR(DBMS_LOB.SUBSTR(SQL_TEXT, 1300, 1), '\{\s*call\s+([A-Za-z0-9_$#.]+)', 1, 1, 'i', 1)),
                                  REGEXP_SUBSTR(DBMS_LOB.SUBSTR(PARAMS, 2000, 1), '"mnuId"\s*:\s*"([^"]*)"', 1, 1, NULL, 1)""",
    "sql_log_range": "SELECT MIN(EXECUTE_TIME) MIN_T, MAX(EXECUTE_TIME) MAX_T, COUNT(*) CNT FROM SCM_MGR.SCM_COM_SQL_LOG",
}
DICT = {
    "objects": f"SELECT OWNER, OBJECT_NAME, OBJECT_TYPE, STATUS, TEMPORARY, LAST_DDL_TIME FROM ALL_OBJECTS WHERE OWNER IN ({OWN})",
    "synonyms": f"SELECT OWNER, SYNONYM_NAME, TABLE_OWNER, TABLE_NAME, DB_LINK FROM ALL_SYNONYMS WHERE OWNER IN ({OWN},'PUBLIC','SCMP_APP','SCMD_APP') AND (TABLE_OWNER IN ({OWN}) OR DB_LINK IS NOT NULL)",
    "dependencies": f"SELECT OWNER, NAME, TYPE, REFERENCED_OWNER, REFERENCED_NAME, REFERENCED_TYPE, REFERENCED_LINK_NAME, DEPENDENCY_TYPE FROM ALL_DEPENDENCIES WHERE OWNER IN ({OWN})",
    "procedures": f"SELECT OWNER, OBJECT_NAME, PROCEDURE_NAME, OBJECT_TYPE, SUBPROGRAM_ID, OVERLOAD FROM ALL_PROCEDURES WHERE OWNER IN ({OWN})",
    "tables": f"SELECT OWNER, TABLE_NAME, TEMPORARY, DURATION, IOT_TYPE, PARTITIONED FROM ALL_TABLES WHERE OWNER IN ({OWN})",
    "mviews": f"SELECT OWNER, MVIEW_NAME FROM ALL_MVIEWS WHERE OWNER IN ({OWN})",
    "views": f"SELECT OWNER, VIEW_NAME, TEXT_LENGTH FROM ALL_VIEWS WHERE OWNER IN ({OWN})",
    "db_links": "SELECT OWNER, DB_LINK, USERNAME, HOST FROM ALL_DB_LINKS",
    "triggers": f"SELECT OWNER, TRIGGER_NAME, TRIGGER_TYPE, TRIGGERING_EVENT, TABLE_OWNER, TABLE_NAME, STATUS FROM ALL_TRIGGERS WHERE OWNER IN ({OWN}) OR TABLE_OWNER IN ({OWN})",
}

def dump(sub, name, sql):
    t = datetime.datetime.now()
    cur.execute(sql)
    cols = [c[0] for c in cur.description]
    rows = cur.fetchall()
    (OUT / sub).mkdir(exist_ok=True)
    with (OUT / sub / f"{name}.csv").open("w", encoding="utf-8-sig", newline="") as f:
        w = csv.writer(f); w.writerow(cols)
        for r in rows:
            w.writerow(["" if v is None else (v.read() if hasattr(v, "read") else v) for v in r])
    print(f"{sub}/{name:16} rows={len(rows):8} {(datetime.datetime.now()-t).total_seconds():.1f}s")

for n, s in META.items(): dump("meta", n, s)
for n, s in DICT.items(): dump("dict", n, s)

# VIEW 본문 (LONG) — 행 단위 fetch
cur.execute(f"SELECT OWNER, VIEW_NAME, TEXT FROM ALL_VIEWS WHERE OWNER IN ({OWN})")
(OUT / "source").mkdir(exist_ok=True)
with (OUT / "source" / "views.jsonl").open("w", encoding="utf-8") as f:
    nv = 0
    for o, v, txt in cur:
        f.write(json.dumps({"OWNER": o, "NAME": v, "TYPE": "VIEW", "TEXT": txt or ""}, ensure_ascii=False) + "\n"); nv += 1
print("source/views.jsonl", nv)

# ALL_SOURCE 전체 (PL/SQL 객체)
cur.arraysize = 5000
cur.execute(f"""SELECT OWNER, NAME, TYPE, LINE, TEXT FROM ALL_SOURCE
                 WHERE OWNER IN ({OWN}) AND TYPE IN ('PACKAGE','PACKAGE BODY','PROCEDURE','FUNCTION','TRIGGER','TYPE','TYPE BODY')
                 ORDER BY OWNER, NAME, TYPE, LINE""")
objs, cur_key, buf = 0, None, []
with (OUT / "source" / "all_source.jsonl").open("w", encoding="utf-8") as f:
    def flush():
        global objs
        if cur_key:
            f.write(json.dumps({"OWNER": cur_key[0], "NAME": cur_key[1], "TYPE": cur_key[2], "TEXT": "".join(buf)}, ensure_ascii=False) + "\n"); objs += 1
    for o, n, t, ln, tx in cur:
        k = (o, n, t)
        if k != cur_key:
            flush(); cur_key, buf = k, []
        buf.append(tx or "")
    flush()
print("source/all_source.jsonl objects", objs)

end = cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL").fetchone()[0]
(OUT / "SNAPSHOT.txt").write_text(f"SOURCE-FRESH: ZIOUI1 SERVER_HOST={host} DB={dbn} DSN={d} USER={u} FETCHED={snap} ~ {end}\nOWNERS={OWNERS}\n", encoding="utf-8")
print("snapshot", snap, "~", end)
