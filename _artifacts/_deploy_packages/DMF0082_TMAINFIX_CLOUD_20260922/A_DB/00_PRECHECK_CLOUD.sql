-- ============================================================================
-- [DMF0082 TMAINFIX 2026-09-22] 00 — PRECHECK (클라우드 선판정 · READ-ONLY)
--
--   목적 : 적용 전에 클라우드 현재 상태를 실측해 ①PKG 세대 ②의존 객체 ③standalone 삭제 안전성을 판정.
--          (hook deploy-package-completeness §1.0-B B1 — "사내 실측만 믿고 적용 금지")
--   성격 : 조회 전용. 이 파일은 아무것도 바꾸지 않는다.
--   판정 : 각 블록 EXPECT 와 대조, 불일치 시 README §5 "적용 중단 조건" 에 따라 처리.
-- ============================================================================
SET LINESIZE 300
SET PAGESIZE 200

PROMPT ============================================================
PROMPT [A] PKG_DMF0082 세대 — 09-21 XLSFORM 적용본 위에 올리는 패치인지 확인
PROMPT     EXPECT : PACKAGE / PACKAGE BODY 존재
PROMPT              XLSFORMASIS 마커 >= 4 (09-21 적용본 표식)
PROMPT              TMAINFIX 마커 = 0 (미적용) / 10 이면 이미 적용됨 (01 재실행 무해)
PROMPT              OLD_GTT_REF = 5 (P_PR_DM_PLN_CFM_TO_MKT_FCST 의 GT_PRDM_T_MAIN 참조)
PROMPT     XLSFORMASIS = 0 이면 : 클라우드 BODY 세대가 다름 -> 중단, 세대 대조 먼저
PROMPT ============================================================
SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') AS LAST_DDL
  FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' ORDER BY OBJECT_TYPE;

SELECT SUM(CASE WHEN TEXT LIKE '%XLSFORMASIS%'        THEN 1 ELSE 0 END) AS XLSFORMASIS
     , SUM(CASE WHEN TEXT LIKE '%E20260922-TMAINFIX%' THEN 1 ELSE 0 END) AS TMAINFIX
     , SUM(CASE WHEN TEXT LIKE '%GT_PRDM_T_MAIN%' AND TEXT NOT LIKE '%--%GT_PRDM_T_MAIN%' THEN 1 ELSE 0 END) AS OLD_GTT_REF
     , COUNT(*) AS BODY_LINES
  FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY';

PROMPT ============================================================
PROMPT [B] 의존 GTT — 컬럼 동일성 (GT_PRDM_T_MAIN vs GT_PRDM1_T_MAIN)
PROMPT     EXPECT : 두 GTT 모두 존재, 28 컬럼 전부 T0=T1 (DIFF 행 0)
PROMPT     GT_PRDM1_T_MAIN 없음 : 현 BODY 의 SAVE 자체가 INVALID 일 것 -> 중단
PROMPT ============================================================
SELECT TABLE_NAME, TEMPORARY, DURATION FROM USER_TABLES
 WHERE TABLE_NAME IN ('GT_PRDM_T_MAIN','GT_PRDM1_T_MAIN','GT_PRDM_TEMP_MKT_DEMAND_PLAN'
                     ,'GT_PRDM_TEMP_SELLING_PRICE','GT_PRDM_SEND_TARGET_DATA','GT_PRDM_RESULTS')
 ORDER BY 1;

SELECT COLUMN_NAME, T0, T1, CASE WHEN NVL(T0,'#') = NVL(T1,'#') THEN 'SAME' ELSE '*** DIFF ***' END AS VERDICT
  FROM (SELECT COLUMN_NAME
             , MAX(DECODE(TABLE_NAME,'GT_PRDM_T_MAIN' ,DATA_TYPE||'('||DATA_LENGTH||')')) T0
             , MAX(DECODE(TABLE_NAME,'GT_PRDM1_T_MAIN',DATA_TYPE||'('||DATA_LENGTH||')')) T1
          FROM USER_TAB_COLUMNS WHERE TABLE_NAME IN ('GT_PRDM_T_MAIN','GT_PRDM1_T_MAIN')
         GROUP BY COLUMN_NAME)
 ORDER BY CASE WHEN NVL(T0,'#') = NVL(T1,'#') THEN 1 ELSE 0 END, COLUMN_NAME;

PROMPT ============================================================
PROMPT [C] PR 하위 호출 객체 — 이제 실제로 실행되므로 존재·VALID 확인
PROMPT     EXPECT : 3행 전부 VALID
PROMPT ============================================================
SELECT T.NM, NVL(O.STATUS, '*** MISSING ***') AS STAT
  FROM (SELECT 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE' NM FROM DUAL
        UNION ALL SELECT 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE' FROM DUAL
        UNION ALL SELECT 'FN_NEXT_DAY' FROM DUAL) T
  LEFT JOIN USER_OBJECTS O ON O.OBJECT_NAME = T.NM AND O.OBJECT_TYPE IN ('PROCEDURE','FUNCTION')
 ORDER BY 1;

PROMPT ============================================================
PROMPT [D] VMI 메저 표기 — 'VMI_In_Req' 정정 근거 (40 사업부)
PROMPT     EXPECT : VMI_In_Req 존재 / 'VMI_IN_REQ'(대문자) 0건
PROMPT     대문자 행이 있으면 : 클라우드 데이터 표기가 사내와 다름 -> 중단, 사용자 확인
PROMPT ============================================================
SELECT 'DM_PLN_MKT_FCST' AS TBL, MEASURE, COUNT(*) AS CNT
  FROM DM_PLN_MKT_FCST WHERE DIVISION_ID = '40' AND UPPER(MEASURE) = 'VMI_IN_REQ' GROUP BY MEASURE
UNION ALL
SELECT 'DM_PLN_CFM_MKT_DEMAND_PLAN', MEASURE, COUNT(*)
  FROM DM_PLN_CFM_MKT_DEMAND_PLAN WHERE DIVISION_ID = '40' AND UPPER(MEASURE) = 'VMI_IN_REQ' GROUP BY MEASURE
 ORDER BY 1, 2;

PROMPT ============================================================
PROMPT [E] standalone PR_DM_PLN_CFM_TO_MKT_FCST 삭제 안전성
PROMPT     EXPECT : E1 = 1행(PROCEDURE) 또는 0행(이미 삭제 -> 02 재실행 무해)
PROMPT              E2 의존자 0행
PROMPT              E3 소스 참조 = PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE 주석 1건(L299 부근)만
PROMPT              E4 JOB 0행 (JOB 은 PR_DM_PLN_CFM_TO_MKT_FCST_ALL 을 호출 — 별개 객체)
PROMPT              E5 PROC_M 0행
PROMPT     E2/E4/E5 가 0이 아니거나 E3 에 주석 외 호출이 있으면 : 02 적용 중단
PROMPT ============================================================
PROMPT --- E1 객체
SELECT OWNER, OBJECT_NAME, OBJECT_TYPE, STATUS FROM ALL_OBJECTS
 WHERE OBJECT_NAME = 'PR_DM_PLN_CFM_TO_MKT_FCST' ORDER BY OWNER, OBJECT_TYPE;

PROMPT --- E2 정적 의존자 (자기 자신 제외)
SELECT OWNER, NAME, TYPE FROM ALL_DEPENDENCIES
 WHERE REFERENCED_NAME = 'PR_DM_PLN_CFM_TO_MKT_FCST' AND NAME <> 'PR_DM_PLN_CFM_TO_MKT_FCST'
 ORDER BY 1, 2;

PROMPT --- E3 소스 텍스트 참조 (동적 호출 포함, _ALL 제외)
SELECT OWNER, NAME, TYPE, LINE, SUBSTR(TRIM(TEXT), 1, 150) AS TEXT
  FROM ALL_SOURCE
 WHERE UPPER(TEXT) LIKE '%PR_DM_PLN_CFM_TO_MKT_FCST%'
   AND UPPER(TEXT) NOT LIKE '%PR_DM_PLN_CFM_TO_MKT_FCST_ALL%'
   AND NAME NOT IN ('PKG_DMF0082', 'PR_DM_PLN_CFM_TO_MKT_FCST')
 ORDER BY 1, 2, 4;

PROMPT --- E4 스케줄러 JOB (standalone 직접 호출 — _ALL 제외)
SELECT OWNER, JOB_NAME FROM ALL_SCHEDULER_JOBS
 WHERE REGEXP_LIKE(UPPER(JOB_ACTION), 'PR_DM_PLN_CFM_TO_MKT_FCST([^_]|$)');

PROMPT --- E5 SCM_ADM_PROC_M 등록
SELECT PROC_NM, COUNT(*) AS CNT FROM SCM_ADM_PROC_M
 WHERE UPPER(PROC_NM) LIKE '%PR_DM_PLN_CFM_TO_MKT_FCST' GROUP BY PROC_NM;

PROMPT --- E6 시노님 / 권한 (롤백 기준값 — 99_ROLLBACK_STANDALONE_PR.sql 의 GRANT/SYNONYM 과 대조)
SELECT OWNER, SYNONYM_NAME, TABLE_OWNER FROM ALL_SYNONYMS
 WHERE TABLE_NAME = 'PR_DM_PLN_CFM_TO_MKT_FCST' ORDER BY 1;
SELECT GRANTEE, PRIVILEGE FROM USER_TAB_PRIVS
 WHERE TABLE_NAME = 'PR_DM_PLN_CFM_TO_MKT_FCST' ORDER BY 1, 2;

PROMPT ============================================================
PROMPT [F] 신규 채번 충돌 점검 (hook §1.0-B B2)
PROMPT     이 회차는 MSG / LBL / MNU / BTN 신규 채번 0건 — 점검 대상 없음.
PROMPT ============================================================
