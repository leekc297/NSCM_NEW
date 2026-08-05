#!/usr/bin/env python3
"""
01_dump_meta.py — TO-BE UI DB 객체 전수 취합: 사내 Oracle 메타 read-only 덤프
출력: 본 폴더 *.csv (utf-8-sig)
접속: ora.py conn_info() 재사용 (.env.asis TOBE_DB_*)
"""
import csv, sys, pathlib

HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent))  # _diagnostics (ora.py)
from ora import conn_info

import oracledb
oracledb.defaults.fetch_lobs = False  # CLOB -> str

OWNERS = "('SCM_MGR','SCMD_APP','SCMC','FP_MGR','INF_MGR','ENG_SCP','OPT_MGR')"

DUMPS = {
    # 1) UI/배선 메타 (전 컬럼)
    "mnu_m":        "SELECT * FROM SCM_ADM_MNU_M",
    "api_m":        "SELECT * FROM SCM_ADM_API_M",
    "proc_m":       "SELECT * FROM SCM_ADM_PROC_M",
    "btn_mpg":      "SELECT * FROM SCM_ADM_MNU_BTN_MPG_M",
    "excel_columns":"SELECT * FROM SCM_ADM_EXCEL_COLUMNS",
    "cmbo_sql":     "SELECT * FROM SCM_ADM_CMBO_SQL_M",
    "sheet_columns_combo": (
        "SELECT PROGRAM_ID, SHEET_NAME, COLUMN_NAME, CELL_CONTROL_OBJECT_TYPE_CODE, "
        "       CELL_COMBO_DATA_TYPE, VALID_YN, DIVISION_ID "
        "FROM SCM_MST_SHEET_COLUMNS WHERE CELL_COMBO_DATA_TYPE IS NOT NULL"),
    "dq_list": "SELECT * FROM SCM_ADM_DQ_LIST",
    # 2) 객체 카탈로그
    "all_objects":  f"SELECT OWNER, OBJECT_NAME, OBJECT_TYPE, STATUS, OBJECT_ID FROM ALL_OBJECTS WHERE OWNER IN {OWNERS}",
    "all_tables":   f"SELECT OWNER, TABLE_NAME, TEMPORARY, DURATION FROM ALL_TABLES WHERE OWNER IN {OWNERS}",
    "all_synonyms": (f"SELECT OWNER, SYNONYM_NAME, TABLE_OWNER, TABLE_NAME FROM ALL_SYNONYMS "
                     f"WHERE OWNER IN {OWNERS} OR (OWNER='PUBLIC' AND TABLE_OWNER IN {OWNERS})"),
    "all_triggers": f"SELECT OWNER, TRIGGER_NAME, TABLE_OWNER, TABLE_NAME, STATUS FROM ALL_TRIGGERS WHERE OWNER IN {OWNERS}",
    # 3) 의존성 그래프 (폐포는 로컬 계산)
    "all_dependencies": (f"SELECT OWNER, NAME, TYPE, REFERENCED_OWNER, REFERENCED_NAME, REFERENCED_TYPE "
                         f"FROM ALL_DEPENDENCIES WHERE OWNER IN {OWNERS}"),
    # 4) 동적 SQL 실측 — V$ (커서별 실접근 객체 + 발행 PL/SQL 유닛 귀속)
    "vsql_plan_objects": (
        "SELECT DISTINCT s.SQL_ID, s.PARSING_SCHEMA_NAME, s.MODULE, s.PROGRAM_ID, s.PROGRAM_LINE# PROGRAM_LINE, "
        "       p.OBJECT_OWNER, p.OBJECT_NAME, p.OBJECT_TYPE, s.SQL_TEXT "
        "FROM V$SQL s JOIN V$SQL_PLAN p ON s.SQL_ID = p.SQL_ID AND s.CHILD_NUMBER = p.CHILD_NUMBER "
        "WHERE s.PARSING_SCHEMA_NAME IN ('SCM_MGR','SCMD_APP') AND p.OBJECT_NAME IS NOT NULL"),
    # 5) 동적 SQL 이력 — AWR plan 상 객체 (owner 필터)
    "awr_plan_objects": (
        f"SELECT DISTINCT SQL_ID, OBJECT_OWNER, OBJECT_NAME, OBJECT_TYPE "
        f"FROM DBA_HIST_SQL_PLAN WHERE OBJECT_OWNER IN {OWNERS} AND OBJECT_NAME IS NOT NULL"),
    # 5b) AWR ASH — SQL_ID → 발행 PL/SQL 유닛 귀속 (PLSQL_ENTRY_OBJECT_ID)
    "awr_ash_attribution": (
        "SELECT DISTINCT SQL_ID, PLSQL_ENTRY_OBJECT_ID, PLSQL_OBJECT_ID "
        "FROM DBA_HIST_ACTIVE_SESS_HISTORY WHERE SQL_ID IS NOT NULL AND PLSQL_ENTRY_OBJECT_ID IS NOT NULL"),
    # 6) BE 실행로그 — 동적 실행문 원문 (distinct, 4000자 절단 명시)
    "sql_log_distinct": (
        "SELECT SQL_ID, SQL_TYPE, DBMS_LOB.SUBSTR(SQL_TEXT, 1000, 1) SQL_TEXT_1000, COUNT(*) EXEC_CNT "
        "FROM SCM_COM_SQL_LOG GROUP BY SQL_ID, SQL_TYPE, DBMS_LOB.SUBSTR(SQL_TEXT, 1000, 1)"),
}

def dump(cur, name, sql):
    cur.execute(sql)
    cols = [c[0] for c in cur.description]
    out = HERE / f"{name}.csv"
    n = 0
    with out.open("w", newline="", encoding="utf-8-sig") as f:
        w = csv.writer(f)
        w.writerow(cols)
        while True:
            rows = cur.fetchmany(2000)
            if not rows:
                break
            for r in rows:
                w.writerow(["" if v is None else v for v in r])
                n += 1
    print(f"{name}.csv : {n} rows")
    return n

def main():
    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.arraysize = 2000
        only = sys.argv[1:] or list(DUMPS)
        for name in only:
            try:
                dump(cur, name, DUMPS[name])
            except Exception as e:
                print(f"{name} : FAIL {e}")

if __name__ == "__main__":
    main()
