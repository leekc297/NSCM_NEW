-- =====================================================================================
-- DMF0020 main API_URL fix — standalone SP 호출 (PKG_DMF0020 prefix 제거)
-- 오류: ORA-06550 PLS-00302 (PACKAGE 안 procedure 가 아닌 standalone)
-- =====================================================================================
WHENEVER SQLERROR CONTINUE;
SET DEFINE OFF;

UPDATE SCM_ADM_API_M
   SET API_URL = 'P_DMF0020_GET_SCM_MST_FUTURE_PRICE_M',
       LAST_UPDATED_BY = 'minyonglee1',
       LAST_UPDATE_DATE = SYSDATE
 WHERE API_ID = 'DMF0020_futurePrice_SEARCH'
   AND API_URL <> 'P_DMF0020_GET_SCM_MST_FUTURE_PRICE_M';

-- PROC_M PROC_NM 도 일치하게 갱신 (기존 'PKG_DMF0020.P_..._M' 18 rows → 'P_..._M')
UPDATE SCM_ADM_PROC_M
   SET PROC_NM = 'P_DMF0020_GET_SCM_MST_FUTURE_PRICE_M',
       LAST_UPDATED_BY = 'minyonglee1',
       LAST_UPDATE_DATE = SYSDATE
 WHERE PROC_NM = 'PKG_DMF0020.P_DMF0020_GET_SCM_MST_FUTURE_PRICE_M';

COMMIT;

SELECT API_URL FROM SCM_ADM_API_M WHERE API_ID = 'DMF0020_futurePrice_SEARCH';
SELECT COL_TP_CD, COUNT(*) AS CNT FROM SCM_ADM_PROC_M
 WHERE PROC_NM = 'P_DMF0020_GET_SCM_MST_FUTURE_PRICE_M' GROUP BY COL_TP_CD ORDER BY 1;
EXIT;
