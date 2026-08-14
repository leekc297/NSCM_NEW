-- 91_DIAG_DMF0049_SAVE2_CLOUD.sql — DMF0049 저장 오류 2차 진단 (v2 적용 후에도 오류 — 2026-08-12)
SET DEFINE OFF

-- [1] 정정본(v2) 적용 확인 — 기대: FCSTNULL 1 / VALID
SELECT COUNT(*) AS FCSTNULL_FIX FROM ALL_SOURCE
 WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0049' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%E20260812-FCSTNULL%';
SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'MM-DD HH24:MI') FROM ALL_OBJECTS
 WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0049' ORDER BY 1;

-- [2] 최신 저장 오류 원문 — SQLERRM 라인이 같은 ORA-00001/L1081 인지, 다른 오류인지가 관건
--     (테이블명 정정 2026-08-12: SCM_COM_SYS_LOG — 사용자 확인)
SELECT SYS_LOG_ID, CREATION_DATE, SUBSTR(EXCT_MSG_CTN, 1, 600) AS ERR_HEAD
  FROM SCM_MGR.SCM_COM_SYS_LOG
 WHERE MNU_ID='DMF0049' AND MNU_BTN_CD='SAVE' AND EXCT_MSG_CTN IS NOT NULL
 ORDER BY CREATION_DATE DESC
 FETCH FIRST 3 ROWS ONLY;

-- [3] ⭐ 원장 유령 행 검사 (hook #131 계보) — 같은 조회 그룹 축(VERSION,DIV,DATA_SEQ,MEASURE,월)에
--     부속 컬럼이 상이한 행 = 화면에 같은 행이 2개 표시 → 저장 payload 에 같은 PK 2세트 → INSERT 자체 충돌
--     기대: 0행. 있으면 그 DATA_SEQ 목록이 원인 행.
SELECT VERSION_NO, DATA_SEQ, MEASURE, SUBSTR(YYYYMMDD,1,6) AS YM,
       COUNT(DISTINCT NVL(NICK_NAME,'~') || '|' || NVL(FORECAST_INFO_SPEC,'~') || '|' ||
                      NVL(DEPT_NAME,'~') || '|' || NVL(DEPARTMENT_NAME,'~') || '|' ||
                      NVL(OWNER_NAME,'~') || '|' || NVL(COMPANY_NAME,'~') || '|' ||
                      NVL(PRODUCT_DETAILS,'~') || '|' || NVL(CELL_MODEL_INFO,'~')) AS VARIANT_CNT
  FROM SCM_MGR.DM_PLN_SALES_ETC_REPORT_C
 WHERE DIVISION_ID='40'
 GROUP BY VERSION_NO, DATA_SEQ, MEASURE, SUBSTR(YYYYMMDD,1,6)
HAVING COUNT(DISTINCT NVL(NICK_NAME,'~') || '|' || NVL(FORECAST_INFO_SPEC,'~') || '|' ||
                      NVL(DEPT_NAME,'~') || '|' || NVL(DEPARTMENT_NAME,'~') || '|' ||
                      NVL(OWNER_NAME,'~') || '|' || NVL(COMPANY_NAME,'~') || '|' ||
                      NVL(PRODUCT_DETAILS,'~') || '|' || NVL(CELL_MODEL_INFO,'~')) > 1
 ORDER BY VERSION_NO, DATA_SEQ
 FETCH FIRST 30 ROWS ONLY;

-- [4] 최신 오류의 payload 중복 검사용 — [2] 의 SYS_LOG_ID 를 아래에 넣어 전체 PARAMS 를 회신
--     (p_data_seq / p_measure / p_yyyymmdd 배열에 같은 조합이 2회 있으면 payload 자체 중복 확정)
-- SELECT EXCT_MSG_CTN FROM SCM_MGR.SCM_COM_SYS_LOG WHERE SYS_LOG_ID = '<위 [2] 의 SYS_LOG_ID>';
