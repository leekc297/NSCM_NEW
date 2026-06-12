#!/usr/bin/env python3
"""
DMF0043_GET_CONTRIBUTE_MAIN_DATA 의 EXCEPTION block 에 v_Query dump 추가
→ 재호출 → DBMS_OUTPUT 캡쳐 → 정확 ORA fail 위치
→ 원본 복원
"""
import datetime
from pathlib import Path
import oracledb

CONN_PARAMS = dict(
    user="SCM_MGR",
    password="!SCMroqkf2026",
    dsn=oracledb.makedsn(host="121.162.245.167", port=2521, sid="ESSCMD"),
)
SP_NAME = "DMF0043_GET_CONTRIBUTE_MAIN_DATA"


def fetch_source(conn, name):
    cur = conn.cursor()
    cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME=:n AND TYPE='PROCEDURE' ORDER BY LINE", n=name)
    s = "".join((r[0] or "") for r in cur.fetchall())
    cur.close()
    return s


def main():
    conn = oracledb.connect(**CONN_PARAMS)
    src = fetch_source(conn, SP_NAME)
    print(f"Source: {len(src)} chars")

    # EXCEPTION block 의 RAISE_APPLICATION_ERROR 앞에 DBMS_OUTPUT 추가
    target = "RAISE_APPLICATION_ERROR(-20001, $$PLSQL_UNIT || ' Error: ' || SQLERRM);"
    dump = (
        "DBMS_OUTPUT.PUT_LINE('[ERR] '||SQLERRM||CHR(10)||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);\n"
        "    DBMS_OUTPUT.PUT_LINE('[v_Query LEN] '||NVL(TO_CHAR(LENGTH(v_Query)),'NULL'));\n"
        "    DBMS_OUTPUT.PUT_LINE('[v_Query H1] '||SUBSTR(NVL(v_Query,'<NULL>'),1,3500));\n"
        "    DBMS_OUTPUT.PUT_LINE('[v_Query H2] '||SUBSTR(NVL(v_Query,'<NULL>'),3501,3500));\n"
        "    DBMS_OUTPUT.PUT_LINE('[v_Query H3] '||SUBSTR(NVL(v_Query,'<NULL>'),7001,3500));\n"
        "    DBMS_OUTPUT.PUT_LINE('[v_Query H4] '||SUBSTR(NVL(v_Query,'<NULL>'),10501,3500));\n"
        "    DBMS_OUTPUT.PUT_LINE('[v_Query H5] '||SUBSTR(NVL(v_Query,'<NULL>'),14001,3500));\n"
        "    "
    )
    if target not in src:
        print("[FAIL] RAISE target not found")
        return 1

    patched = src.replace(target, dump + target, 1)
    print(f"Patched: {len(patched)} chars (delta {len(patched)-len(src)})")

    cur = conn.cursor()
    try:
        cur.execute("CREATE OR REPLACE " + patched)
        conn.commit()
        print("[OK] CREATE OR REPLACE (dump 추가)")
    except oracledb.DatabaseError as e:
        print(f"[ERR] {e}")
        return 2
    cur.close()

    # 재호출 + DBMS_OUTPUT 캡쳐
    print("\n=== 재호출 ===")
    cur = conn.cursor()
    cur.callproc("DBMS_OUTPUT.ENABLE", [None])
    rc = cur.var(oracledb.CURSOR)
    try:
        cur.callproc(SP_NAME, ["2024", "12", "ALL", "N", "minyonglee1", "", rc])
        print("[OK] callproc (no exception)")
    except oracledb.DatabaseError as e:
        print(f"[RAISED] {e}")

    # capture DBMS_OUTPUT
    line_var = cur.var(str)
    st_var = cur.var(int)
    captured = []
    while True:
        cur.callproc("DBMS_OUTPUT.GET_LINE", [line_var, st_var])
        if st_var.getvalue() != 0:
            break
        v = line_var.getvalue()
        if v is not None:
            captured.append(v)
    print(f"\n--- DBMS_OUTPUT ({len(captured)} lines) ---")
    for ln in captured:
        print(ln[:500])
    cur.close()

    # 원본 복원
    print("\n=== 원본 복원 ===")
    cur = conn.cursor()
    try:
        cur.execute("CREATE OR REPLACE " + src)
        conn.commit()
        print("[OK] 복원")
    except oracledb.DatabaseError as e:
        print(f"[ERR] {e}")
    cur.close()
    conn.close()


if __name__ == "__main__":
    main()
