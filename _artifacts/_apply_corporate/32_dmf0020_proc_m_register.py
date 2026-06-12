#!/usr/bin/env python3
"""
DMF0020 standalone SP 4종의 PROC_M 신규 등록.

진단:
  - API_M 가 PKG_DMF0020.P_DMF0020_GET_SCM_MST_FUTURE_PRICE (미존재) 호출 → PLS-00302
  - script 32 가 API_URL → standalone (DMF0020_GET_SCM_MST_FUTURE_PRICE) 정정
  - 그러나 standalone PROC_M=0 → BE 0-arg 호출 → PLS-00306

Fix: 4 SP 각각 PROC_M 등록 (FE 전송 fields 매핑 + 미전송 args NULL)

SP signatures + FE 매핑:
  DMF0020_GET_SCM_MST_FUTURE_PRICE (20)               main_SEARCH
  DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL (19)          main_SAVE
  DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP (18) priceBatchInput_SEARCH
  DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP (17)         priceBatchInput_SAVE
"""
import oracledb

CONN = dict(user="SCM_MGR", password="!SCMroqkf2026",
            dsn=oracledb.makedsn(host="121.162.245.167", port=2521, sid="ESSCMD"))


def proc_m_rows(sp_name):
    """SP signature 기반 PROC_M row 생성 — 표준 명명 규칙 적용."""
    if sp_name == "DMF0020_GET_SCM_MST_FUTURE_PRICE":
        # 20 args
        return [
            ("divisionId",          "IN",  "VARCHAR",      1),  # P_DIVISION_ID
            ("deptId",              "IN",  "VARCHAR",      2),  # P_DEPT_ID
            ("endCustomer",         "IN",  "VARCHAR",      3),  # P_END_CUSTOMER
            ("scmSiteId",           "IN",  "VARCHAR",      4),  # P_SCM_SITE_ID
            ("plantSiteId",         "IN",  "VARCHAR",      5),  # P_PLANT_SITE_ID
            ("projectCode",         "IN",  "VARCHAR",      6),  # P_PROJECT_CODE
            ("itemId",              "IN",  "VARCHAR",      7),  # P_ITEM_ID
            ("customerProjectCode", "IN",  "VARCHAR",      8),  # P_CUSTOMER_PROJECT_CODE (FE 미전송)
            ("customerModel",       "IN",  "VARCHAR",      9),  # P_CUSTOMER_MODEL (FE 미전송)
            ("fromYyyymmdd",        "IN",  "VARCHAR",     10),  # P_FROM_YYYYMMDD
            ("toYyyymmdd",          "IN",  "VARCHAR",     11),  # P_TO_YYYYMMDD
            ("biztype",             "IN",  "VARCHAR",     12),  # P_BIZTYPE
            ("sesUserId",           "IN",  "VARCHAR",     13),  # P_CREATED_BY (BE auto-fill)
            ("userInfo",            "IN",  "VARCHAR",     14),  # P_USERINFO (FE 미전송)
            ("owner",               "IN",  "VARCHAR",     15),  # P_OWNER
            ("overRange",           "IN",  "VARCHAR",     16),  # P_OVER_RANGE
            ("invalidExec",         "IN",  "VARCHAR",     17),  # P_INVALID_EXEC
            ("versionType",         "IN",  "VARCHAR",     18),  # P_VERSION_TYPE
            ("o_rc1",               "OUT", "CURSOR",      19),  # O_RC1
            ("O_RESULT_CURSOR",     "OUT", "PROC_RESULT", 20),  # O_RESULT_CURSOR
        ]
    return None


def main():
    conn = oracledb.connect(**CONN)
    try:
        cur = conn.cursor()

        sp = "DMF0020_GET_SCM_MST_FUTURE_PRICE"
        rows = proc_m_rows(sp)
        cur.execute("DELETE FROM SCM_ADM_PROC_M WHERE PROC_NM=:p", p=sp)
        del_n = cur.rowcount
        for col_nm, col_tp, data_tp, sort_ord in rows:
            cur.execute(
                """INSERT INTO SCM_ADM_PROC_M
                   (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
                   VALUES (:p, :c, :d, :t, :s, 'admin', SYSDATE, 'admin', SYSDATE)""",
                p=sp, c=col_nm, d=data_tp, t=col_tp, s=sort_ord,
            )
        conn.commit()
        print(f"[OK] {sp}: DELETE {del_n} → INSERT {len(rows)}")

        # 검증
        cur.execute("""
            SELECT a.OBJECT_NAME, a.arg_cnt sig, NVL(p.proc_m_cnt,0) proc
              FROM (SELECT OBJECT_NAME, COUNT(*) arg_cnt FROM USER_ARGUMENTS
                     WHERE OBJECT_NAME=:n AND PACKAGE_NAME IS NULL GROUP BY OBJECT_NAME) a
              LEFT JOIN (SELECT PROC_NM, COUNT(*) proc_m_cnt FROM SCM_ADM_PROC_M
                          WHERE PROC_NM=:n GROUP BY PROC_NM) p ON a.OBJECT_NAME = p.PROC_NM
        """, n=sp)
        for r in cur.fetchall():
            print(f"  {'✓' if r[1]==r[2] else '✗'} {r[0]} SP={r[1]} PROC_M={r[2]}")
        cur.close()
        return 0
    finally:
        conn.close()


if __name__ == "__main__":
    import sys
    sys.exit(main())
