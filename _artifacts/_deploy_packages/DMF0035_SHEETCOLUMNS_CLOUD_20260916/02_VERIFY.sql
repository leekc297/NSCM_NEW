-- DMF0035 SCM_MST_SHEET_COLUMNS 이관 검증 — 01 실행 후 전 항목 통과 의무

-- V1. 행수 (기대: 198 이상 — 비파괴이므로 클라우드 전용 행이 있으면 더 클 수 있다)
SELECT COUNT(*) TOTAL FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0035';

-- V2. 시트별 분포 (기대: Mkt Fcst Waterfall 71 / Sales Plan Waterfall 66 / Biz Plan Waterfall 61)
SELECT SHEET_NAME, COUNT(*) CNT,
       SUM(CASE WHEN VISIBLE_FLAG='Y' THEN 1 ELSE 0 END) VIS_Y,
       SUM(CASE WHEN DEFAULT_FLAG='Y' THEN 1 ELSE 0 END) DEF_Y,
       SUM(CASE WHEN TRIM(DIVISION_ID) IS NULL THEN 1 ELSE 0 END) DIV_BLANK
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0035'
 GROUP BY SHEET_NAME ORDER BY 1;
-- 기대 (v2 — 로컬 UI Category Setup 변경 + [E20260916-DIVBLANK] 2회차 반영 후 사내 실측):
--       Biz Plan Waterfall   61 / 42 / 17 / 16
--       Mkt Fcst Waterfall   71 / 61 / 17 /  9
--       Sales Plan Waterfall 66 / 61 / 19 /  5
--       (DIV_BLANK 합계 30 — v1 시점 11에서 증가)

-- V3. 요청 규칙 충족 — DIVISION 공백 행은 전부 VISIBLE='N' AND DEFAULT='N' (기대: 0)
SELECT COUNT(*) VIOLATION
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID='DMF0035' AND TRIM(DIVISION_ID) IS NULL
   AND (VISIBLE_FLAG <> 'N' OR DEFAULT_FLAG <> 'N');

-- V4. 멱등 — 01_SHEET_COLUMNS_DMF0035_MERGE.sql 을 **한 번 더** 실행했을 때 0행이어야 한다.
--     (MERGE 의 WHEN MATCHED ... WHERE 가 업무 29컬럼의 실제 차이만 보고, 감사컬럼은 비교에서 제외한다)

-- V5. MERGE 키 안전성 — 이 표에는 PK/UNIQUE 제약이 없다. 키 중복이 생기면 MERGE 가 ORA-30926 로 실패한다.
--     (기대: 0)
SELECT COUNT(*) DUP_GROUPS FROM (
  SELECT PROGRAM_ID, SHEET_NAME, COLUMN_NAME
    FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0035'
   GROUP BY PROGRAM_ID, SHEET_NAME, COLUMN_NAME HAVING COUNT(*)>1);

-- V6. 비파괴 확인 — 사내에 없고 클라우드에만 있는 DMF0035 행 목록.
--     MERGE 는 DELETE 를 하지 않으므로 이 행들은 그대로 남는다. 결과가 나오면 **사람이 판단**할 것
--     (사내에서 삭제된 컬럼인지, 클라우드 전용인지). 자동 삭제 금지.
SELECT SHEET_NAME, COLUMN_NAME, SORT_ORDER_NO, VISIBLE_FLAG, DEFAULT_FLAG, DIVISION_ID
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID='DMF0035'
   AND (SHEET_NAME, COLUMN_NAME) NOT IN (
        -- 01 SQL 의 USING 절과 동일한 198 키. 간이 확인은 시트별 건수(V2)로 대체 가능.
        SELECT SHEET_NAME, COLUMN_NAME FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
         WHERE PROGRAM_ID='DMF0035' AND 1=0)
 ORDER BY SHEET_NAME, SORT_ORDER_NO;
-- ※ V6 는 사내 키 목록을 별도로 올린 뒤 대조하는 용도의 뼈대다. 간이 판정은 V2 시트별 건수로 한다.

-- V7. 화면 런타임 — DMF0035 3 TYPE(MKT FCST / Sales Plan / Business Plan) 조회가 정상이고,
--     MKT FCST 그리드 VERSION 열에 값이 채워질 것(별건 패키지 DMF0035_VERCOL_CLOUD_20260916 선행 필요).

-- V8. 숨은컬럼 arm 진입 점검 — VIS='N' + DEFAULT 공백/'-' 조합은 SP 컬럼목록에
--     **보이지 않는 GROUP BY 축**으로 주입된다. DMF0035 에서 정당한 진입은 Biz Plan Waterfall/VERSION_NO 1건뿐.
SELECT SHEET_NAME, COLUMN_NAME, '['||DEFAULT_FLAG||']' DEF
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID='DMF0035' AND VISIBLE_FLAG='N'
   AND RTRIM(DEFAULT_FLAG,' -') IS NULL AND VALID_YN='Y'
 ORDER BY 1,2;
-- 기대: 1행 (Biz Plan Waterfall | VERSION_NO). 그 외가 나오면 DIVISION 공백 행의 DEFAULT_FLAG 를 'N' 으로 정정할 것.
