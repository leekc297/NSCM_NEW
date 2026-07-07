--==============================================================================
-- A2_dmf0003_sendercode_titleset_meta.sql  (SQL*Plus 본체)
--
-- 목적 (DMF0003 전체점검 2026-07-02 — 진단 A1 확정 원인 2건 fix):
--   B-C1. 조회조건 Sender Code 콤보 미표시
--         → SCM_ADM_CMBO_SQL_M 에 SQL_ID='SenderCode' 등록 자체가 없음 (전수검색 0행).
--           AS-IS 소스 = DM.UP_FX_GetCommonDataList_DM CODE='EDI_SENDER_CODE' (.cs L5908)
--           = To-Be lookup SCM_ADM_LOOKUP_MASTER_DETAIL LOOKUP_TYPE='EDI_SENDER_CODE'
--           (클라우드 실측 29행, VALID_YN='Y' 15행, SEGMENT1=division / SEGMENT2=code).
--   B-C2. Grid Model Name(ITEM_NAME) 데이터 누락
--         → GET SP V_COLUMN 은 사용자 TITLESET_USER('C') ∪ DEFAULT_FLAG('-',' ','') 로 구성
--           (019 SP L396~445). ITEM_NAME 은 DEFAULT_FLAG='N' + minyonglee1 titleset 에 부재
--           → SELECT 목록에서 제외 → 데이터 빈칸. minyonglee1 titleset 에 ITEM_NAME 행 추가.
--           (타 사용자는 개인화 설정 존중 — 동일 증상 시 개별 적용. 근본은 TitleSet popup
--            저장 배선(Phase 후속) 으로 사용자가 직접 관리.)
--
-- 영향 테이블:
--   B1  SCM_ADM_CMBO_SQL_M     : 1 행 (SenderCode)
--   B2  SCM_MST_TITLESET_USER  : 1 행 (minyonglee1 / DMF0003 / Mkt Fcst / C / ITEM_NAME)
--
-- NOT NULL 정책 실측(2026-07-02): CMBO_SQL_M = SQL_ID/MDU_DIVS_CD('ALL' def)/SQL_DTL_CTN/
--   USE_YN('Y' def)/CREATED_BY/CREATION_DATE(SYSDATE def)/LAST_UPDATED_BY/LAST_UPDATE_DATE.
--   TITLESET_USER = USER_ID/PROGRAM_ID/SHEET_NAME/USER_INQUIRY_COLUMN_TYPE_CODE/COLUMN_NAME/
--   SUB_TOTAL_FLAG/CREATED_BY/CREATION_DATE/LAST_UPDATED_BY/LAST_UPDATE_DATE — 전수 명시.
--
-- 멱등성: NOT EXISTS 가드 — 재실행 시 0 행 영향.
-- 실행: SCM_MGR 세션. 사내(클라우드) Oracle 121.162.245.167 / OCGSCMD_P01
-- 작성: 2026-07-02
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
SET LINESIZE 200
WHENEVER SQLERROR EXIT FAILURE

PROMPT === BLOCK 1 : SCM_ADM_CMBO_SQL_M (SenderCode 1 행) ===

INSERT INTO SCM_MGR.SCM_ADM_CMBO_SQL_M
    (SQL_ID, MDU_DIVS_CD, SQL_NM, SQL_DTL_CTN, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'SenderCode', 'CM', 'EDI Sender Code (by division)',
       'SELECT SEGMENT1 AS DIVISION_ID, SEGMENT2 AS CODE, SEGMENT2 AS NAME FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = ''EDI_SENDER_CODE'' AND VALID_YN = ''Y'' ORDER BY SEGMENT1, SEGMENT2',
       'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM DUAL
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_CMBO_SQL_M X WHERE X.SQL_ID = 'SenderCode'
 );

PROMPT === BLOCK 2 : SCM_MST_TITLESET_USER (minyonglee1 ITEM_NAME 1 행) ===

INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER
    (USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE, COLUMN_NAME,
     SORT_ORDER_NO, SUB_TOTAL_FLAG, DATA_SORT_METHOD_CODE,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'minyonglee1', 'DMF0003', 'Mkt Fcst', 'C', 'ITEM_NAME',
       150, 'N', NULL,
       'minyonglee1', SYSDATE, 'minyonglee1', SYSDATE
  FROM DUAL
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_MST_TITLESET_USER X
    WHERE X.USER_ID='minyonglee1' AND X.PROGRAM_ID='DMF0003' AND X.SHEET_NAME='Mkt Fcst'
      AND X.USER_INQUIRY_COLUMN_TYPE_CODE='C' AND X.COLUMN_NAME='ITEM_NAME'
 );

PROMPT === BLOCK 3 : 사후 카운트 ===

SELECT 'POST: CMBO SenderCode (1)' AS K, COUNT(*) AS V
  FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID='SenderCode'
UNION ALL
SELECT 'POST: TITLESET ITEM_NAME (1)', COUNT(*)
  FROM SCM_MGR.SCM_MST_TITLESET_USER
 WHERE USER_ID='minyonglee1' AND PROGRAM_ID='DMF0003' AND SHEET_NAME='Mkt Fcst'
   AND USER_INQUIRY_COLUMN_TYPE_CODE='C' AND COLUMN_NAME='ITEM_NAME';

COMMIT;

PROMPT === COMPLETE ===
EXIT;
