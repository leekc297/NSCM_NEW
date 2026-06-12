#!/usr/bin/env python3
"""
DMF0008 query SP 전체 PROC_M ↔ SP signature 정합 fix.

진단 (V$SP_ARGS vs PROC_M):
  DMF0008_GET_EDI_MST_SUMMARY   : SP=8 / PROC_M=8  ✓ (이미 fix)
  DMF0008_GET_EDI_MST_REPAIR    : SP=9 / PROC_M=7  → +2 (fromYyyymmdd/toYyyymmdd)
  DMF0008_GET_SALES_SITE        : SP=5 / PROC_M=8  → -3 (sesUserId/menuId/o_rc1 제거)
  DMF0008_GET_SALES_SITE_PROJECT_MODEL : SP=7 / PROC_M=7 ✓
  DMF0008_GET_UPDATE_HISTORY    : SP=3 / PROC_M=3 ✓

SAVE SP 는 별도 (bulk JSON 패턴):
  DMF0008_SAVE_SALES_SITE_EDI_REPAIR / DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR
  → 23/17 args 의 SP signature 와 PROC_M=3 의 불일치는 MyBatis 가 BULK call 처리 (별도 mapper)
"""
import oracledb

CONN = dict(user="SCM_MGR", password="!SCMroqkf2026",
            dsn=oracledb.makedsn(host="121.162.245.167", port=2521, sid="ESSCMD"))

# (PROC_NM, 정확한 8-tuple list — SP signature 1:1 매핑)
FIXES = {
    "DMF0008_GET_EDI_MST_REPAIR": [
        # SP sig: P_DIVISION_ID, P_FROM_YYYYMMDD, P_TO_YYYYMMDD, P_SENDER_NAME, P_FLAG, P_USER_ID, P_MENU_ID, O_RC1, O_RESULT_CURSOR
        ("divisionId",      "IN",  "VARCHAR",     1),
        ("fromYyyymmdd",    "IN",  "VARCHAR",     2),
        ("toYyyymmdd",      "IN",  "VARCHAR",     3),
        ("senderName",      "IN",  "VARCHAR",     4),
        ("flag",            "IN",  "VARCHAR",     5),
        ("sesUserId",       "IN",  "VARCHAR",     6),
        ("menuId",          "IN",  "VARCHAR",     7),
        ("o_rc1",           "OUT", "CURSOR",      8),
        ("O_RESULT_CURSOR", "OUT", "PROC_RESULT", 9),
    ],
    "DMF0008_GET_SALES_SITE": [
        # SP sig: P_DIVISION_ID, P_SOLDTO, P_SHIPTO, P_SCM_SITE_ID, O_RESULT_CURSOR
        ("divisionId",      "IN",  "VARCHAR",     1),
        ("soldTo",          "IN",  "VARCHAR",     2),
        ("shipTo",          "IN",  "VARCHAR",     3),
        ("scmSiteId",       "IN",  "VARCHAR",     4),
        ("O_RESULT_CURSOR", "OUT", "PROC_RESULT", 5),
    ],
}


def main():
    conn = oracledb.connect(**CONN)
    try:
        for proc_nm, rows in FIXES.items():
            cur = conn.cursor()
            cur.execute("DELETE FROM SCM_ADM_PROC_M WHERE PROC_NM=:p", p=proc_nm)
            del_n = cur.rowcount
            for col_nm, col_tp, data_tp, sort_ord in rows:
                cur.execute(
                    """INSERT INTO SCM_ADM_PROC_M
                       (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
                       VALUES (:p, :c, :d, :t, :s, 'admin', SYSDATE, 'admin', SYSDATE)""",
                    p=proc_nm, c=col_nm, d=data_tp, t=col_tp, s=sort_ord,
                )
            conn.commit()
            print(f"[OK] {proc_nm}: DELETE {del_n} → INSERT {len(rows)}")
            cur.close()

        # 검증 — 모든 DMF0008 query SP 의 sig vs PROC_M
        cur = conn.cursor()
        cur.execute("""
            SELECT a.OBJECT_NAME, a.arg_cnt sig_args, NVL(p.proc_m_cnt,0) proc_m_args
              FROM (SELECT OBJECT_NAME, COUNT(*) arg_cnt FROM USER_ARGUMENTS
                     WHERE OBJECT_NAME LIKE 'DMF0008%' AND PACKAGE_NAME IS NULL
                     GROUP BY OBJECT_NAME) a
              LEFT JOIN (SELECT PROC_NM, COUNT(*) proc_m_cnt FROM SCM_ADM_PROC_M
                          WHERE PROC_NM LIKE 'DMF0008%'
                          GROUP BY PROC_NM) p ON a.OBJECT_NAME = p.PROC_NM
             WHERE a.OBJECT_NAME LIKE '%GET%'
             ORDER BY a.OBJECT_NAME
        """)
        print("\n=== GET SP 정합 검증 ===")
        for r in cur.fetchall():
            status = "✓" if r[1] == r[2] else "✗"
            print(f"  {status} {r[0]:50} SP={r[1]} PROC_M={r[2]}")
        cur.close()
        return 0
    finally:
        conn.close()


if __name__ == "__main__":
    import sys
    sys.exit(main())
