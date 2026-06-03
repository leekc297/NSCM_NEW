-- =====================================================================================
-- priceBatch SP routing fix — Exchange Rate SP (잘못된) → 메인 SP P_DMF0020_GET_SCM_MST_FUTURE_PRICE_M (17 IN)
-- BE 가 PROC_M COL_NM camelCase 인자 (divisionId/deptId/.../sesUserId/mnuId) 그대로 사용
-- =====================================================================================
WHENEVER SQLERROR CONTINUE;
SET DEFINE OFF;

-- 1. API_M URL 변경 (priceBatch SEARCH)
UPDATE SCM_ADM_API_M
   SET API_URL = 'P_DMF0020_GET_SCM_MST_FUTURE_PRICE_M',
       LAST_UPDATED_BY = 'minyonglee1',
       LAST_UPDATE_DATE = SYSDATE
 WHERE API_ID = 'DMF0020_priceBatch_SEARCH';

-- 2. PROC_M 기존 (6 IN) 삭제 + 새 17 IN entries — 메인 SP 와 동일
DELETE FROM SCM_ADM_PROC_M WHERE PROC_NM IN (
  'PKG_DMF0020.P_DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP',
  'P_DMF0020_GET_SCM_MST_FUTURE_PRICE_M_priceBatch'
);

-- 메인 SP PROC_M 이 이미 등록되어 있음 (P_DMF0020_GET_SCM_MST_FUTURE_PRICE_M) → 그대로 재사용
-- (BE 가 API_URL → PROC_NM 으로 lookup 시 PROC_NM = API_URL 일치하면 동일 PROC_M 사용)

COMMIT;

SELECT API_URL FROM SCM_ADM_API_M WHERE API_ID = 'DMF0020_priceBatch_SEARCH';
SELECT COL_TP_CD, COUNT(*) AS CNT FROM SCM_ADM_PROC_M WHERE PROC_NM = 'P_DMF0020_GET_SCM_MST_FUTURE_PRICE_M' GROUP BY COL_TP_CD ORDER BY 1;
EXIT;
