#!/usr/bin/env python3
"""
SCM_COM_SYS_LOG + SCM_COM_SQL_LOG TRUNCATE — USERS tablespace 확보.

⚠️ TRUNCATE 는 rollback 불가. 사용자 명시 요청 후 진행 (2026-06-11).

Phase 1: BEFORE 상태 (tablespace + row count + log segment size)
Phase 2: TRUNCATE SCM_COM_SYS_LOG + SCM_COM_SQL_LOG
Phase 3: AFTER 상태
"""
import oracledb

CONN_PARAMS = dict(
    user="SCM_MGR",
    password="!SCMroqkf2026",
    dsn=oracledb.makedsn(host="121.162.245.167", port=2521, sid="ESSCMD"),
)


def fetch(cur, sql):
    cur.execute(sql)
    return cur.fetchall()


def main():
    conn = oracledb.connect(**CONN_PARAMS)
    cur = conn.cursor()

    print("=== Phase 1: BEFORE ===")
    try:
        rows = fetch(cur, "SELECT TABLESPACE_NAME, ROUND(USED_SPACE * 8192 / 1024 / 1024 / 1024, 2) AS USED_GB, ROUND(TABLESPACE_SIZE * 8192 / 1024 / 1024 / 1024, 2) AS SIZE_GB, ROUND(USED_PERCENT, 2) AS PCT FROM DBA_TABLESPACE_USAGE_METRICS WHERE TABLESPACE_NAME='USERS'")
        for r in rows:
            print(f"  USERS tablespace: USED={r[1]} GB / SIZE={r[2]} GB / PCT={r[3]}%")
    except oracledb.DatabaseError as e:
        print(f"  [WARN DBA_TABLESPACE_USAGE_METRICS] {e}")

    for tbl in ("SCM_COM_SYS_LOG", "SCM_COM_SQL_LOG"):
        try:
            rows = fetch(cur, f"SELECT COUNT(*) FROM {tbl}")
            print(f"  {tbl} rows: {rows[0][0]:,}")
        except oracledb.DatabaseError as e:
            print(f"  [ERR {tbl}] {e}")

    try:
        rows = fetch(cur, "SELECT SEGMENT_NAME, SEGMENT_TYPE, ROUND(BYTES/1024/1024,2) AS MB FROM USER_SEGMENTS WHERE TABLESPACE_NAME='USERS' AND SEGMENT_NAME IN ('SCM_COM_SYS_LOG','SCM_COM_SQL_LOG') ORDER BY BYTES DESC")
        print("  Log segments:")
        for r in rows:
            print(f"    {r[0]} ({r[1]}) = {r[2]} MB")
    except oracledb.DatabaseError as e:
        print(f"  [WARN segments] {e}")

    print("\n=== Phase 2: TRUNCATE ===")
    for tbl in ("SCM_COM_SYS_LOG", "SCM_COM_SQL_LOG"):
        try:
            cur.execute(f"TRUNCATE TABLE {tbl}")
            print(f"  [OK] TRUNCATE {tbl}")
        except oracledb.DatabaseError as e:
            print(f"  [ERR] TRUNCATE {tbl}: {e}")

    print("\n=== Phase 3: AFTER ===")
    try:
        rows = fetch(cur, "SELECT TABLESPACE_NAME, ROUND(USED_SPACE * 8192 / 1024 / 1024 / 1024, 2) AS USED_GB, ROUND(TABLESPACE_SIZE * 8192 / 1024 / 1024 / 1024, 2) AS SIZE_GB, ROUND(USED_PERCENT, 2) AS PCT FROM DBA_TABLESPACE_USAGE_METRICS WHERE TABLESPACE_NAME='USERS'")
        for r in rows:
            print(f"  USERS tablespace: USED={r[1]} GB / SIZE={r[2]} GB / PCT={r[3]}%")
    except oracledb.DatabaseError as e:
        print(f"  [WARN] {e}")

    for tbl in ("SCM_COM_SYS_LOG", "SCM_COM_SQL_LOG"):
        try:
            rows = fetch(cur, f"SELECT COUNT(*) FROM {tbl}")
            print(f"  {tbl} rows: {rows[0][0]}")
        except oracledb.DatabaseError as e:
            print(f"  [ERR {tbl}] {e}")

    cur.close()
    conn.close()


if __name__ == "__main__":
    main()
