#!/usr/bin/env python3
"""
DMF0003_SAVE_MKT_FCST 의 SCM_ADM_PROC_M 신규 등록 (Phase 2d handoff).

진단 (2026-06-28, ora.py 실측):
  - SP DMF0003_SAVE_MKT_FCST 존재 (standalone, 15 IN + 2 OUT). ALL_ARGUMENTS 17행.
  - API_M DMF0003_main_SAVE.API_URL = 'DMF0003_SAVE_MKT_FCST' (PROC) — 라우트 정상.
  - SCM_ADM_PROC_M WHERE PROC_NM='DMF0003_SAVE_MKT_FCST' = 0 행.
    → BE GeneralServiceImpl.callProc → makeProcedure 가 PROC_M(=PR_GET_PROC_INFO_LIST)
      0행이면 인자 없이 {call DMF0003_SAVE_MKT_FCST} 호출 → PLS-00306 / false success.
  - DMF0003_main_DELETE.API_URL 도 'DMF0003_SAVE_MKT_FCST' (동일 SP, ACTIVE_FLAG='D' 분기) → 동일 메타 사용.

createdBy 충돌 분석 (feedback_save_sp_dual_cursor_and_measure_group):
  - call-proc 경로 = BaseService.selectList(String,Map) → getRetrieveParam (createdBy 미주입).
    createdBy 를 단일 세션값으로 덮는 곳은 NDaoInterface._selectList(List paramList) 경로(별개)뿐.
  - 따라서 call-proc(단일 Map) 경로에서는 createdBy ^delim 다건이 붕괴되지 않음 → COL_NM='createdBy' 안전.
  - SP body 실측: P_CREATED_BY 를 '^' split 하여 row 별 V_CREATED_BY 사용 → ^delim 다건 필수.

SP signature (positional) → FE payload camelCase COL_NM 매핑:
   1 P_ACTIVE_FLAG   -> activeFlag    (행별 'M'/'I'/'D' ^delim)
   2 P_DIVISION_ID   -> divisionId
   3 P_PROJECT_CODE  -> projectCode   (Div 40 = Customer40 키, 81/82 = Project 키)
   4 P_SCM_SITE_ID   -> scmSiteId     (Div 40 = ScmSiteId40)
   5 P_ITEM_ID       -> itemId        (Div 40 = ItemId40)
   6 P_DOM_EXP       -> domExp
   7 P_FCST_TYPE     -> fcstType
   8 P_INCOTERMS     -> incoterms
   9 P_MEASURE       -> measure
  10 P_PLANT_SITE_ID -> plantSiteId
  11 P_YYYYMMDD      -> yyyymmdd       (D_/W_/M_ 컬럼명에서 prefix 제거한 일자)
  12 P_QTY           -> qty
  13 P_CREATED_BY    -> createdBy      (행별 세션 userId ^delim)
  14 P_AS_FROM_SITE  -> asFromSite
  15 P_BUCKET        -> bucket         (조회조건 Bucket 단일값 — 행마다 동일)
  16 O_RC1           -> o_rc1          (SSP 동기화 내역 cursor)
  17 O_RESULT_CURSOR -> O_RESULT_CURSOR(CODE/MSG/EVENT 결과 cursor)

reference: 32_dmf0020_proc_m_register.py 동일 패턴 (DELETE→INSERT 멱등 + SP/PROC_M 카운트 검증).
"""
import oracledb

CONN = dict(user="SCM_MGR", password="!SCMroqkf2026",
            dsn="121.162.245.167:2521/OCGSCMD_P01")

SP = "DMF0003_SAVE_MKT_FCST"

# (COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD)
PROC_M_ROWS = [
    ("activeFlag",      "IN",  "VARCHAR",      1),   # P_ACTIVE_FLAG
    ("divisionId",      "IN",  "VARCHAR",      2),   # P_DIVISION_ID
    ("projectCode",     "IN",  "VARCHAR",      3),   # P_PROJECT_CODE
    ("scmSiteId",       "IN",  "VARCHAR",      4),   # P_SCM_SITE_ID
    ("itemId",          "IN",  "VARCHAR",      5),   # P_ITEM_ID
    ("domExp",          "IN",  "VARCHAR",      6),   # P_DOM_EXP
    ("fcstType",        "IN",  "VARCHAR",      7),   # P_FCST_TYPE
    ("incoterms",       "IN",  "VARCHAR",      8),   # P_INCOTERMS
    ("measure",         "IN",  "VARCHAR",      9),   # P_MEASURE
    ("plantSiteId",     "IN",  "VARCHAR",     10),   # P_PLANT_SITE_ID
    ("yyyymmdd",        "IN",  "VARCHAR",     11),   # P_YYYYMMDD
    ("qty",             "IN",  "VARCHAR",     12),   # P_QTY
    ("createdBy",       "IN",  "VARCHAR",     13),   # P_CREATED_BY
    ("asFromSite",      "IN",  "VARCHAR",     14),   # P_AS_FROM_SITE
    ("bucket",          "IN",  "VARCHAR",     15),   # P_BUCKET
    ("o_rc1",           "OUT", "CURSOR",      16),   # O_RC1
    ("O_RESULT_CURSOR", "OUT", "PROC_RESULT", 17),   # O_RESULT_CURSOR
]


def main():
    conn = oracledb.connect(**CONN)
    try:
        cur = conn.cursor()

        cur.execute("DELETE FROM SCM_ADM_PROC_M WHERE PROC_NM=:p", p=SP)
        del_n = cur.rowcount
        for col_nm, col_tp, data_tp, sort_ord in PROC_M_ROWS:
            cur.execute(
                """INSERT INTO SCM_ADM_PROC_M
                   (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD,
                    CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
                   VALUES (:p, :c, :d, :t, :s, 'admin', SYSDATE, 'admin', SYSDATE)""",
                p=SP, c=col_nm, d=data_tp, t=col_tp, s=sort_ord,
            )
        conn.commit()
        print(f"[OK] {SP}: DELETE {del_n} -> INSERT {len(PROC_M_ROWS)}")

        # 검증: SP ALL_ARGUMENTS 카운트 == PROC_M 카운트 (proc-meta-signature-match)
        cur.execute("""
            SELECT a.OBJECT_NAME, a.arg_cnt sig, NVL(p.proc_m_cnt,0) proc
              FROM (SELECT OBJECT_NAME, COUNT(*) arg_cnt FROM USER_ARGUMENTS
                     WHERE OBJECT_NAME=:n AND PACKAGE_NAME IS NULL GROUP BY OBJECT_NAME) a
              LEFT JOIN (SELECT PROC_NM, COUNT(*) proc_m_cnt FROM SCM_ADM_PROC_M
                          WHERE PROC_NM=:n GROUP BY PROC_NM) p ON a.OBJECT_NAME = p.PROC_NM
        """, n=SP)
        for r in cur.fetchall():
            print(f"  {'OK' if r[1] == r[2] else 'MISMATCH'} {r[0]} SP={r[1]} PROC_M={r[2]}")
        cur.close()
        return 0
    finally:
        conn.close()


if __name__ == "__main__":
    import sys
    sys.exit(main())
