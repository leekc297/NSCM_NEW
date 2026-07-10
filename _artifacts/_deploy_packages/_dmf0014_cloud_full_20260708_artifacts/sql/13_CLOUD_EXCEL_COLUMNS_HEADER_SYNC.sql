-- ============================================================================
-- DMF0014 클라우드 Excel Upload "Invalid Measure Upload Bucket" fix
--   근본 원인(클라우드 스테이징 실측 2026-07-08): 일자행/데이터행의 ATTRIBUTE14~ 가 전부 빈값
--   → BE 스테이징이 SCM_ADM_EXCEL_COLUMNS.HEADER_CONTENT 의 파이프 수만큼만 컬럼 매핑.
--   → 사내 = 18컬럼(...|Model|W27~W31) / 클라우드 = 구버전(13컬럼) → 기간 컬럼 5개 탈락
--   → SP 가 일자 간격으로 bucket 계산 불가(빈 IN) → 전 행 'Invalid Measure Upload Bucket.'
--   실행: 클라우드 DB, SCM_MGR 접속.
-- ============================================================================

-- STEP 1. 진단 — 현재 클라우드 값 확인 (파이프 수 13개면 원인 확정)
SELECT PROGRAM_ID, SHEET_NAME,
       REGEXP_COUNT(HEADER_CONTENT, '\|') + 1 AS COL_CNT,
       HEADER_CONTENT
  FROM SCM_MGR.SCM_ADM_EXCEL_COLUMNS
 WHERE PROGRAM_ID = 'DMF0014' AND SHEET_NAME = 'FCST Upload';
-- 사내 정상값: COL_CNT=18

-- STEP 2. 조치 — 사내 정상값과 동일하게 동기화 (멱등)
UPDATE SCM_MGR.SCM_ADM_EXCEL_COLUMNS
   SET HEADER_CONTENT = 'Division*|Sales Site*|Plant Site*|Customer Project*|Customer Model*|Incoterms*|FCST Type*|Customs Handbook*|Measure Group*|Measure*|Upload UOM*|Project|Model|W27|W28|W29|W30|W31',
       LAST_UPDATED_BY = 'minyonglee1',
       LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID = 'DMF0014' AND SHEET_NAME = 'FCST Upload';
COMMIT;

-- STEP 3. 재검증
SELECT REGEXP_COUNT(HEADER_CONTENT, '\|') + 1 AS COL_CNT
  FROM SCM_MGR.SCM_ADM_EXCEL_COLUMNS
 WHERE PROGRAM_ID = 'DMF0014' AND SHEET_NAME = 'FCST Upload';
-- 기대: 18

-- ⚠️ 알려진 한계 (사내 동일): 파이프 수(18) = 고정 13 + 기간 5 주차.
--   조회 기간을 늘려 기간 컬럼이 5개를 초과하는 파일은 초과분이 스테이징에서 잘림.
--   기간 확장 필요 시 HEADER_CONTENT 의 기간 슬롯을 그만큼 늘려야 함(최대 ATTRIBUTE150 한도 내,
--   OPTION_ATTRIBUTE_COLUMN_NUMBER=70). 사내·클라우드 동시 갱신 의무.
