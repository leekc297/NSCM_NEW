#!/usr/bin/env python3
"""
DMF0008_GET_EDI_MST_SUMMARY 의 PROC_M 메타가 SP signature 와 불일치.

SP 실제 signature (8 args):
  1 P_FROM_YYYYMMDD  IN
  2 P_TO_YYYYMMDD    IN
  3 P_DIVISION_ID    IN
  4 P_USER_ID        IN
  5 P_MENU_ID        IN
  6 O_RC1            OUT
  7 O_RC3            OUT
  8 O_RESULT_CURSOR  OUT

현재 PROC_M (6 args, 잘못됨):
  1 divisionId, 2 sesUserId, 3 menuId, 4 o_rc1, 5 O_RESULT_cURSOR, 8 O_RESULT_CURSOR

→ ORA-06550 PLS-00306 호출 시 인수 갯수 불일치

Fix:
  - DELETE 기존 6 row
  - INSERT 8 row 정합

COL_NM 표준 (BE 자동 채움 키 + 일반 IN):
  fromYyyymmdd, toYyyymmdd, divisionId, sesUserId, menuId, o_rc1, o_rc3, O_RESULT_CURSOR
"""
import oracledb

CONN = dict(user="SCM_MGR", password="!SCMroqkf2026",
            dsn=oracledb.makedsn(host="121.162.245.167", port=2521, sid="ESSCMD"))
SP = "DMF0008_GET_EDI_MST_SUMMARY"


def main():
    conn = oracledb.connect(**CONN)
    try:
        cur = conn.cursor()
        # PROC_M PK 확인
        cur.execute("""
            SELECT COLUMN_NAME FROM USER_CONS_COLUMNS
             WHERE CONSTRAINT_NAME = (
               SELECT CONSTRAINT_NAME FROM USER_CONSTRAINTS
                WHERE TABLE_NAME='SCM_ADM_PROC_M' AND CONSTRAINT_TYPE='P')
             ORDER BY POSITION
        """)
        pk = [r[0] for r in cur.fetchall()]
        print(f"PROC_M PK: {pk}")

        # DELETE 기존
        cur.execute("DELETE FROM SCM_ADM_PROC_M WHERE PROC_NM=:p", p=SP)
        del_n = cur.rowcount
        print(f"DELETE old PROC_M: {del_n} row")

        # INSERT 8 row — DATA_TP_CD 표준 (REPAIR PROC_M 참조):
        #   IN  → VARCHAR
        #   OUT cursor (data) → CURSOR
        #   OUT O_RESULT_CURSOR (BE auto) → PROC_RESULT
        rows = [
            ("fromYyyymmdd",    "IN",  "VARCHAR",     1),
            ("toYyyymmdd",      "IN",  "VARCHAR",     2),
            ("divisionId",      "IN",  "VARCHAR",     3),
            ("sesUserId",       "IN",  "VARCHAR",     4),
            ("menuId",          "IN",  "VARCHAR",     5),
            ("o_rc1",           "OUT", "CURSOR",      6),
            ("o_rc3",           "OUT", "CURSOR",      7),
            ("O_RESULT_CURSOR", "OUT", "PROC_RESULT", 8),
        ]
        for col_nm, col_tp, data_tp, sort_ord in rows:
            cur.execute(
                """INSERT INTO SCM_ADM_PROC_M
                   (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
                   VALUES (:p, :c, :d, :t, :s, 'admin', SYSDATE, 'admin', SYSDATE)""",
                p=SP, c=col_nm, d=data_tp, t=col_tp, s=sort_ord,
            )
        print(f"INSERT new PROC_M: {len(rows)} row")
        conn.commit()
        cur.close()

        # 검증
        cur = conn.cursor()
        cur.execute("SELECT COL_NM, COL_TP_CD, SORT_ORD FROM SCM_ADM_PROC_M WHERE PROC_NM=:p ORDER BY SORT_ORD", p=SP)
        print("Final PROC_M:")
        for r in cur.fetchall():
            print(f"  {r[2]} {r[0]:20} {r[1]}")
        cur.close()
        return 0
    finally:
        conn.close()


if __name__ == "__main__":
    import sys
    sys.exit(main())
