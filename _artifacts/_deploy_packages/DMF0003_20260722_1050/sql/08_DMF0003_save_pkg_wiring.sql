-- =====================================================================
-- DMF0003 저장 SP → PKG 병합에 따른 배선 전환 (2026-07-20)
--   ① PROC_M 에 PKG 한정명(PKG_DMF0003.P_DMF0003_SAVE_MKT_FCST) 시그니처 등록
--      (standalone DMF0003_SAVE_MKT_FCST 행을 그대로 복제 — positional 동일)
--   ② API_M DMF0003_main_SAVE.API_URL 을 standalone → PKG 한정명으로 전환
--   규약: 메인 조회(PKG_DMF0003.P_DMF0003_GET_MKT_FCST_DATA) 병합 선례 동일.
--   멱등. 감사 'admin'. standalone 은 미삭제(unused 잔존 — 별도 정리 대상).
-- =====================================================================

-- ① PROC_M PKG 한정명 등록 (기존 standalone 행 복제)
MERGE INTO SCM_MGR.SCM_ADM_PROC_M t
USING (
  SELECT 'PKG_DMF0003.P_DMF0003_SAVE_MKT_FCST' AS PROC_NM,
         COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD
    FROM SCM_MGR.SCM_ADM_PROC_M
   WHERE PROC_NM = 'DMF0003_SAVE_MKT_FCST'
) s
ON (t.PROC_NM = s.PROC_NM AND t.COL_NM = s.COL_NM)
WHEN MATCHED THEN UPDATE SET t.DATA_TP_CD = s.DATA_TP_CD, t.COL_TP_CD = s.COL_TP_CD, t.SORT_ORD = s.SORT_ORD,
  t.LAST_UPDATED_BY = 'admin', t.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD,
  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES (s.PROC_NM, s.COL_NM, s.DATA_TP_CD, s.COL_TP_CD, s.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);

-- ② API_M 배선 전환 (standalone → PKG 한정명)
UPDATE SCM_MGR.SCM_ADM_API_M
   SET API_URL = 'PKG_DMF0003.P_DMF0003_SAVE_MKT_FCST',
       LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
 WHERE API_ID = 'DMF0003_main_SAVE'
   AND API_URL = 'DMF0003_SAVE_MKT_FCST';

COMMIT;
