-- ============================================================================
-- DMF0082_CLOUD_20260814 / 00_PRECHECK_CLOUD.sql  (READ-ONLY — 적용 전 선판정)
--   hook deploy-package-completeness §1.0-B(B1/B2/B3) + §1.0-C(값 단언 3종)
--   ⚠ 아무것도 변경하지 않는다. 결과를 보고 적용 여부를 판단한다.
-- ============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 200

PROMPT ===== [A] 기준선 확인 — 08-12 패키지가 적용된 DB 인가 =====
PROMPT   기대: EXCEL_UPLOAD 5-arg 존재(=08-12 적용됨). 0 이면 08-12 패키지 먼저 적용할 것.
SELECT COUNT(*) AS EXCEL_UPLOAD_5ARG
  FROM ALL_ARGUMENTS
 WHERE OWNER='SCM_MGR' AND PACKAGE_NAME='PKG_DMF0082'
   AND OBJECT_NAME='P_DMF0082_EXCEL_UPLOAD' AND ARGUMENT_NAME IS NOT NULL;

PROMPT
PROMPT ===== [B-1] CTRL 화이트리스트 단언 (기대 0행) =====
PROMPT   FE CELL_CONTROL_TYPE(FP* 14종) 밖의 값이 있으면 적용 중단.
SELECT SHEET_NAME, COLUMN_NAME, CELL_CONTROL_OBJECT_TYPE_CODE
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID='DMF0082'
   AND CELL_CONTROL_OBJECT_TYPE_CODE IS NOT NULL
   AND TRIM(CELL_CONTROL_OBJECT_TYPE_CODE) IS NOT NULL
   AND CELL_CONTROL_OBJECT_TYPE_CODE NOT IN
       ('FPModal','FPComboBox','FPButton','FPDate','FPDateMonth','FPDateTime','FPDateText',
        'FPCheckBox','FPNumberText','FPTextBox','FPPercent','FPText','FPNumber','FPMultiLineTextBox');

PROMPT
PROMPT ===== [B-2] INPUT_TP_CD 분포 대사 =====
PROMPT   사내 기대(2026-08-14 실측): FcstNPrice = IO 9 / S 나머지, 'Sales Price Save All' = S 25.
PROMPT   전면 'IM' 이 나오면 오등록 — 적용 중단.
SELECT SHEET_NAME, INPUT_TP_CD, COUNT(*) CNT
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0082'
 GROUP BY SHEET_NAME, INPUT_TP_CD ORDER BY 1,2;

PROMPT
PROMPT ===== [B-3] measure 편집권한 룩업 현황 (적용 전) =====
PROMPT   사내 기대: 116행 (40:15 / 81계열 각 14~15 / 82:11). 클라우드가 28행이면 08-14 미적용 상태.
SELECT SEGMENT3 DIV, COUNT(*) CNT FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
 WHERE LOOKUP_TYPE='GET_ADMIN_GROUP_MEASURE' AND SEGMENT2='DMF0082'
 GROUP BY SEGMENT3 ORDER BY 1;

PROMPT
PROMPT ===== [C] 신규 채번 충돌 점검 (§1.0-B B2) =====
PROMPT   본 패키지는 **MSG/LBL 신규 채번 없음**(MSG00703/00705 = 기존 코드 재적용).
PROMPT   기대: 아래 2건이 이미 있거나(=재적용 무해) 없거나(=신규 등록) 둘 다 정상.
SELECT MSG_ID, COUNT(*) LANG_CNT FROM SCM_MGR.SCM_ADM_MSG_M
 WHERE MSG_ID IN ('MSG00703','MSG00705') GROUP BY MSG_ID ORDER BY 1;

PROMPT
PROMPT ===== [D] 신규 콤보 3종 존재 여부 =====
PROMPT   FcstTypeEditDMF0082 / EndCustomerByDivisionDMF0082 = 08-14 신설. 0 이면 신규 등록됨.
SELECT SQL_ID, USE_YN FROM SCM_MGR.SCM_ADM_CMBO_SQL_M
 WHERE SQL_ID IN ('FcstTypeByUserGroupDMF0082','FcstTypeEditDMF0082',
                  'EndCustomerByDivisionDMF0082','TeambyDivision') ORDER BY 1;

PROMPT
PROMPT ===== [E] Excel Form SP/API (08-13 신설) 존재 여부 =====
SELECT COUNT(*) PROC_ROWS FROM SCM_MGR.SCM_ADM_PROC_M
 WHERE PROC_NM='PKG_DMF0082.P_DMF0082_GET_EXCEL_FORM_DATA';
SELECT COUNT(*) API_ROWS FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID='DMF0082_GET_EXCEL_FORM';
