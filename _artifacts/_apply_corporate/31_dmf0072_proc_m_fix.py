#!/usr/bin/env python3
"""
DMF0072 PROC_M signature 정합 fix.

진단:
  DMF0072_GET_NNMASTER_MAPPING_WRAPPER : SP=10 args / PROC_M=2 → diff +8
  → BE 호출 시 ORA-06550 PLS-00306 (인수 갯수 불일치)
  → 사용자 "SQL error" 신고

추가 mismatch (SAVE 는 별도 — bulk JSON 패턴이라 PROC_M 불필요):
  DMF0072_SAVE_NNMASTER_MAPPING        : SP=24 / PROC_M=0
  DMF0072_GET_NNMASTER_MAPPING         : SP=8  / PROC_M=0   (WRAPPER 가 호출하는 내부 SP — BE 직접 호출 X)
"""
import oracledb

CONN = dict(user="SCM_MGR", password="!SCMroqkf2026",
            dsn=oracledb.makedsn(host="121.162.245.167", port=2521, sid="ESSCMD"))

# WRAPPER SP signature (10 args):
#   P_DATA_TYPE_CODE / P_DIVISION_ID / P_DEPT_ID / P_END_CUSTOMER /
#   P_SCM_SITE_ID / P_PROJECT_CODE / P_ITEM_ID / P_USER_ID / P_MENU_ID / O_RC1
ROWS = [
    ("dataTypeCode",  "IN",  "VARCHAR",     1),
    ("divisionId",    "IN",  "VARCHAR",     2),
    ("deptId",        "IN",  "VARCHAR",     3),
    ("endCustomer",   "IN",  "VARCHAR",     4),
    ("scmSiteId",     "IN",  "VARCHAR",     5),
    ("projectCode",   "IN",  "VARCHAR",     6),
    ("itemId",        "IN",  "VARCHAR",     7),
    ("sesUserId",     "IN",  "VARCHAR",     8),
    ("mnuId",         "IN",  "VARCHAR",     9),
    ("o_rc1",         "OUT", "CURSOR",     10),
]
SP = "DMF0072_GET_NNMASTER_MAPPING_WRAPPER"


def main():
    conn = oracledb.connect(**CONN)
    try:
        cur = conn.cursor()
        cur.execute("DELETE FROM SCM_ADM_PROC_M WHERE PROC_NM=:p", p=SP)
        del_n = cur.rowcount
        for col_nm, col_tp, data_tp, sort_ord in ROWS:
            cur.execute(
                """INSERT INTO SCM_ADM_PROC_M
                   (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
                   VALUES (:p, :c, :d, :t, :s, 'admin', SYSDATE, 'admin', SYSDATE)""",
                p=SP, c=col_nm, d=data_tp, t=col_tp, s=sort_ord,
            )
        conn.commit()
        print(f"[OK] {SP}: DELETE {del_n} → INSERT {len(ROWS)}")

        # 검증
        cur.execute("""
            SELECT a.OBJECT_NAME, a.arg_cnt, NVL(p.proc_m_cnt,0)
              FROM (SELECT OBJECT_NAME, COUNT(*) arg_cnt FROM USER_ARGUMENTS
                     WHERE OBJECT_NAME LIKE 'DMF0072%' AND PACKAGE_NAME IS NULL
                     GROUP BY OBJECT_NAME) a
              LEFT JOIN (SELECT PROC_NM, COUNT(*) proc_m_cnt FROM SCM_ADM_PROC_M
                          WHERE PROC_NM LIKE 'DMF0072%'
                          GROUP BY PROC_NM) p ON a.OBJECT_NAME = p.PROC_NM
             WHERE a.OBJECT_NAME LIKE '%GET%' AND a.OBJECT_NAME LIKE '%WRAPPER%' OR a.OBJECT_NAME='DMF0072_GET_NNMASTER_MAPPING'
             ORDER BY a.OBJECT_NAME
        """)
        print("Verification:")
        for r in cur.fetchall():
            status = "✓" if r[1] == r[2] else "✗"
            print(f"  {status} {r[0]:42} SP={r[1]} PROC_M={r[2]}")
        cur.close()
        return 0
    finally:
        conn.close()


if __name__ == "__main__":
    import sys
    sys.exit(main())
