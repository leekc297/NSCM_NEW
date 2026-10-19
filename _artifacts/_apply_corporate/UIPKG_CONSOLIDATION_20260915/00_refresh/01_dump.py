"""01_dump.py (2026-09-15 재실행본 — 스케줄러 3종 추가) — UI별 PKG 전환대상 조사용 사내(ZIOUI1) 읽기 전용 덤프. 2026-09-14"""
import csv, pathlib, oracledb, datetime
OUT = pathlib.Path(__file__).resolve().parent
con = oracledb.connect(user="SCM_MGR", password="zionex1!", dsn="175.211.29.206:2521/ZIOUI1")
cur = con.cursor()
cur.execute("ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS'")
Q = {
 "mnu_m": "SELECT MNU_ID, UPPR_MNU_ID, MNU_URL, MNU_MSG_ID, MNU_DESC, MNU_TP_CD, USE_YN, N10_ATR_CTN ROUTE FROM SCM_ADM_MNU_M",
 "btn_mpg": "SELECT * FROM SCM_ADM_MNU_BTN_MPG_M",
 "api_m": "SELECT API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN, LAST_UPDATE_DATE FROM SCM_ADM_API_M",
 "proc_m": "SELECT PROC_NM, COUNT(*) CNT FROM SCM_ADM_PROC_M GROUP BY PROC_NM",
 "excel_columns": "SELECT PROGRAM_ID, SHEET_NAME, STORAGE_SQL_ID, VALID_YN FROM SCM_ADM_EXCEL_COLUMNS",
 "cmbo_sql": "SELECT SQL_ID, DBMS_LOB.SUBSTR(TO_CLOB(SQL_DTL_CTN), 4000, 1) SQL_TEXT FROM SCM_ADM_CMBO_SQL_M",
 "objects": """SELECT OWNER, OBJECT_NAME, OBJECT_TYPE, STATUS, CREATED, LAST_DDL_TIME FROM ALL_OBJECTS
               WHERE OWNER IN ('SCM_MGR','SCMP_APP') AND OBJECT_TYPE IN ('PROCEDURE','PACKAGE','PACKAGE BODY','FUNCTION','SYNONYM')""",
 "pkg_members": """SELECT OWNER, OBJECT_NAME PACKAGE_NAME, PROCEDURE_NAME, SUBPROGRAM_ID FROM ALL_PROCEDURES
                   WHERE OWNER='SCM_MGR' AND OBJECT_TYPE='PACKAGE' AND PROCEDURE_NAME IS NOT NULL""",
 "synonyms": "SELECT OWNER, SYNONYM_NAME, TABLE_OWNER, TABLE_NAME FROM ALL_SYNONYMS WHERE OWNER IN ('SCMP_APP','PUBLIC') AND TABLE_OWNER='SCM_MGR'",
 "dependencies": """SELECT OWNER, NAME, TYPE, REFERENCED_OWNER, REFERENCED_NAME, REFERENCED_TYPE FROM ALL_DEPENDENCIES
                    WHERE OWNER='SCM_MGR' AND REFERENCED_OWNER='SCM_MGR' AND REFERENCED_TYPE IN ('PROCEDURE','PACKAGE','FUNCTION')
                      AND TYPE IN ('PROCEDURE','PACKAGE','PACKAGE BODY','FUNCTION') AND NOT (NAME = REFERENCED_NAME)""",
 "sql_log_calls": """SELECT UPPER(REGEXP_SUBSTR(DBMS_LOB.SUBSTR(SQL_TEXT, 1300, 1), '\\{\\s*call\\s+([A-Za-z0-9_$#.]+)', 1, 1, 'i', 1)) PROC,
                            REGEXP_SUBSTR(DBMS_LOB.SUBSTR(PARAMS, 1300, 1), '"mnuId"\\s*:\\s*"([^"]*)"', 1, 1, NULL, 1) MNU_ID,
                            COUNT(*) CNT, MAX(EXECUTE_TIME) LAST_EXEC
                       FROM SCM_COM_SQL_LOG
                      WHERE REGEXP_LIKE(DBMS_LOB.SUBSTR(SQL_TEXT, 1300, 1), '\\{\\s*call\\s', 'i')
                      GROUP BY UPPER(REGEXP_SUBSTR(DBMS_LOB.SUBSTR(SQL_TEXT, 1300, 1), '\\{\\s*call\\s+([A-Za-z0-9_$#.]+)', 1, 1, 'i', 1)),
                               REGEXP_SUBSTR(DBMS_LOB.SUBSTR(PARAMS, 1300, 1), '"mnuId"\\s*:\\s*"([^"]*)"', 1, 1, NULL, 1)""",
 "sched_jobs": "SELECT OWNER, JOB_NAME, JOB_TYPE, JOB_ACTION, PROGRAM_OWNER, PROGRAM_NAME, ENABLED, STATE, LAST_START_DATE FROM ALL_SCHEDULER_JOBS",
 "sched_programs": "SELECT OWNER, PROGRAM_NAME, PROGRAM_TYPE, PROGRAM_ACTION, ENABLED FROM ALL_SCHEDULER_PROGRAMS WHERE OWNER NOT IN ('SYS','ORACLE_OCM','EXFSYS')",
 "dbms_jobs": "SELECT JOB, SCHEMA_USER, WHAT, BROKEN, LAST_DATE, NEXT_DATE FROM ALL_JOBS",
}
for name, sql in Q.items():
    t = datetime.datetime.now()
    try:
        cur.execute(sql)
    except Exception as e:
        print("FAIL", name, e); continue
    cols = [c[0] for c in cur.description]
    rows = cur.fetchall()
    with (OUT / f"{name}.csv").open("w", encoding="utf-8-sig", newline="") as f:
        w = csv.writer(f); w.writerow(cols)
        for r in rows: w.writerow(["" if v is None else (v.read() if hasattr(v, "read") else v) for v in r])
    print(f"{name:14} rows={len(rows):7} {(datetime.datetime.now()-t).total_seconds():.1f}s")
print("snapshot", cur.execute("SELECT SYSDATE FROM DUAL").fetchone()[0])
