-- ============================================================================================
-- [클라우드에서 실행 #3] DMF0020 배선 메타 스냅샷 — 사내와 대조용 (read-only)
-- ============================================================================================

PROMPT ===== W1. API_M =====
SELECT API_ID, API_TP_CD, API_URL, USE_YN, TO_CHAR(LAST_UPDATE_DATE,'YYYY-MM-DD') LUD
FROM   SCM_ADM_API_M WHERE API_ID LIKE '%DMF0020%' ORDER BY API_ID;
-- 사내 12행

PROMPT ===== W2. MNU_BTN_MPG_M =====
SELECT MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN
FROM   SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID LIKE 'DMF0020%' ORDER BY SHT_NM, MNU_BTN_CD;
-- 사내 14행

PROMPT ===== W3. PROC_M 파라미터 계약 (개수만 — 다르면 시그니처가 달라진 것) =====
SELECT PROC_NM, COUNT(*) PARAM_CNT
FROM   SCM_ADM_PROC_M WHERE PROC_NM LIKE '%DMF0020%' GROUP BY PROC_NM ORDER BY 1;
-- 사내 63행 / 4 PROC_NM

PROMPT ===== W4. 실인자 대조 (소스를 바꿔도 인자수가 다르면 PLS-00306 이 난다) =====
SELECT NVL(PACKAGE_NAME,'(standalone)') PKG, OBJECT_NAME, COUNT(*) ARG_CNT
FROM   ALL_ARGUMENTS
WHERE  OWNER='SCM_MGR'
AND    (OBJECT_NAME LIKE '%DMF0020%' OR PACKAGE_NAME='PKG_DMF0020')
GROUP  BY PACKAGE_NAME, OBJECT_NAME ORDER BY 1,2;
