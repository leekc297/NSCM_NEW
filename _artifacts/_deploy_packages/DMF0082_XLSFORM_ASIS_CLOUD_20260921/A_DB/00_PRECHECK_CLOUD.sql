-- ============================================================================
-- [DMF0082 XLSFORM-ASIS 2026-09-21] 00 — PRECHECK (클라우드 선판정 · READ-ONLY)
--
--   목적 : 적용 전에 **클라우드 현재 상태**를 실측해 어느 스크립트가 필요한지, 충돌이 없는지 판정.
--          (hook deploy-package-completeness §1.0-B B1/B2 — "사내 실측만 믿고 적용 금지")
--   성격 : 조회 전용. 이 파일은 아무것도 바꾸지 않는다.
--   판정 : 각 블록의 EXPECT 를 읽고, 불일치 시 README §5 "적용 중단 조건" 에 따라 처리.
-- ============================================================================
SET LINESIZE 300
SET PAGESIZE 200

PROMPT ============================================================
PROMPT [A] 대상 패키지 / 시그니처 — SPEC 무변경 전제 확인
PROMPT     EXPECT : PKG_DMF0082 PACKAGE + PACKAGE BODY 둘 다 존재(STATUS 무관)
PROMPT              두 SP 가 SPEC 에 선언돼 있고 인자 수가 아래와 같아야 한다.
PROMPT              P_DMF0082_GET_EXCEL_FORM_DATA = IN 17 + OUT 2
PROMPT              P_DMF0082_EXCEL_UPLOAD        = IN 4  + OUT 1
PROMPT     불일치 시 : 클라우드 PKG 세대가 다르다 -> 적용 중단, 세대 대조 먼저.
PROMPT ============================================================
SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') AS LAST_DDL
  FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' ORDER BY OBJECT_TYPE;

SELECT PROCEDURE_NAME
     , SUM(CASE WHEN IN_OUT = 'IN'  THEN 1 ELSE 0 END) AS IN_CNT
     , SUM(CASE WHEN IN_OUT = 'OUT' THEN 1 ELSE 0 END) AS OUT_CNT
  FROM ALL_ARGUMENTS
 WHERE OWNER = 'SCM_MGR' AND PACKAGE_NAME = 'PKG_DMF0082'
   AND OBJECT_NAME IN ('P_DMF0082_GET_EXCEL_FORM_DATA','P_DMF0082_EXCEL_UPLOAD')
 GROUP BY PROCEDURE_NAME ORDER BY 1;

PROMPT ============================================================
PROMPT [B] 배선 — SCM_ADM_MNU_BTN_MPG_M / SCM_ADM_API_M (재배선 불필요 확인)
PROMPT     EXPECT : FORM_DATA -> PKG_DMF0082.P_DMF0082_GET_EXCEL_FORM_DATA
PROMPT              UPLOAD / UPLOAD_SAVE -> PKG_DMF0082.P_DMF0082_EXCEL_UPLOAD
PROMPT     0행이면 : 배선 자체가 없다 -> 이 패키지 범위 밖(배선 패키지 선행 필요).
PROMPT ============================================================
SELECT B.SHT_NM, B.MNU_BTN_CD, B.API_ID, B.USE_YN, A.API_URL
  FROM SCM_ADM_MNU_BTN_MPG_M B
  LEFT JOIN SCM_ADM_API_M A ON A.API_ID = B.API_ID
 WHERE B.MNU_ID = 'DMF0082'
   AND B.MNU_BTN_CD IN ('FORM_DATA','UPLOAD','UPLOAD_SAVE','UPLOAD_DATA')
 ORDER BY B.SHT_NM, B.MNU_BTN_CD;

PROMPT ============================================================
PROMPT [C] PREREQ GTT — GT_F020_* 6종 (AS-IS 업로드 이식 의존)
PROMPT     EXPECT : 6행. 6 미만이면 04_PREREQ_GTT_F020.sql 이 채운다(그대로 진행).
PROMPT     ⚠ 6행이어도 컬럼 정의 드리프트는 이 쿼리로 안 잡힌다 —
PROMPT        05 적용 후 컴파일 에러(ORA-00904)가 나면 해당 GTT REBUILD 필요.
PROMPT ============================================================
SELECT TABLE_NAME, TEMPORARY, DURATION
  FROM USER_TABLES
 WHERE TABLE_NAME IN ('GT_F020_EXCEL_UPLOAD','GT_F020_UPLOAD_MASTER_STEP1'
                     ,'GT_F020_UPLOAD_MASTER_STEP2','GT_F020_UPLOAD_MASTER_WITH_ITEM'
                     ,'GT_F020_UPLOAD_MASTER_FINAL','GT_F020_EXCH')
 ORDER BY 1;

PROMPT ============================================================
PROMPT [D] 양식 데이터 원천 테이블 — AS-IS 행 원천(매출계획) 존재 확인
PROMPT     EXPECT : 4행 전부 존재. 하나라도 없으면 조회가 ORA-00942 로 실패한다.
PROMPT ============================================================
SELECT T.NM, CASE WHEN O.OBJECT_NAME IS NULL THEN '*** MISSING ***' ELSE O.OBJECT_TYPE END AS STAT
  FROM (SELECT 'DM_PLN_SALES_PLAN_C' NM FROM DUAL
        UNION ALL SELECT 'DM_PLN_SALES_PLAN_RESULT_C' FROM DUAL
        UNION ALL SELECT 'SCM_ADM_USER_MNU_EDIT_AUTH_V' FROM DUAL
        UNION ALL SELECT 'SCM_MST_SSO_DEPT_INFO' FROM DUAL) T
  LEFT JOIN ALL_OBJECTS O ON O.OWNER='SCM_MGR' AND O.OBJECT_NAME = T.NM
 ORDER BY 1;

PROMPT ============================================================
PROMPT [E] FN_NEXT_DAY 시그니처 — NLS 암묵 형변환 교정 전제
PROMPT     EXPECT : (P_DATEVAL DATE, P_WEEK VARCHAR2) RETURN DATE
PROMPT     이식본은 TO_DATE(...,'YYYYMMDD') 명시 변환을 쓰므로 세션 NLS 에 의존하지 않는다.
PROMPT ============================================================
SELECT ARGUMENT_NAME, DATA_TYPE, IN_OUT, POSITION
  FROM ALL_ARGUMENTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='FN_NEXT_DAY' ORDER BY POSITION;

PROMPT ============================================================
PROMPT [F] 현재 메타 — 적용 전 스냅샷 (롤백 기준값)
PROMPT     EXPECT(적용 전) : HEADER_CONTENT 가 구 23토큰
PROMPT                       'Div|Project Code|Sales Site|Model|Incoterms|FCST Type|...'
PROMPT                       SHEET_COLUMNS 'Sales Price Template' = 0행
PROMPT     이미 19토큰/19행이면 : 이 패키지가 이미 적용된 것 -> 중복 적용 불필요(멱등이라 무해).
PROMPT ============================================================
SELECT PROGRAM_ID, SHEET_NAME, OPTION_ATTRIBUTE_COLUMN_NUMBER AS OAC
     , REGEXP_COUNT(HEADER_CONTENT,'\|') + 1 AS TOKEN_CNT
     , HEADER_CONTENT
  FROM SCM_ADM_EXCEL_COLUMNS WHERE PROGRAM_ID = 'DMF0082';

SELECT COUNT(*) AS TEMPLATE_META_ROWS
  FROM SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'DMF0082' AND SHEET_NAME = 'Sales Price Template';

PROMPT ============================================================
PROMPT [G] 신규 채번 충돌 점검 (hook §1.0-B B2)
PROMPT     이 회차는 MSG / LBL / MNU / BTN **신규 채번 0건**이다.
PROMPT     기존 재사용 키 = MSG01014(81 외 division 가드), MSG01023(0건), LBL00674(No).
PROMPT     EXPECT : 아래 3키가 클라우드에 이미 존재(재사용). 없으면 README §6 참조.
PROMPT ============================================================
SELECT MSG_ID, COUNT(*) AS CNT
  FROM SCM_ADM_MSG_M WHERE MSG_ID IN ('MSG01014','MSG01023','LBL00674')
 GROUP BY MSG_ID ORDER BY 1;

PROMPT ============================================================
PROMPT [H] 81 계열 division — 기능 대상 범위 확인 (AS-IS 도 81 전용)
PROMPT     EXPECT : 81 계열 division 이 1개 이상. 0이면 양식이 항상 빈 결과가 된다.
PROMPT ============================================================
SELECT DIVISION_ID, COUNT(*) AS VER_CNT
  FROM DM_MST_VERSION WHERE DIVISION_ID LIKE '81%' AND VERSION_TYPE = 'SP_W'
 GROUP BY DIVISION_ID ORDER BY 1;
