-- =====================================================================
-- [DMF0003] ORA-00918 (MEASURE ambiguously specified) 근본원인 진단
--   클라우드에서 조회 시 발생 / 로컬(사내)에서는 미발생 → 코드 아닌 '메타 데이터 분기'
--
-- 배경(코드 구조): P_DMF0003_GET_MKT_FCST_DATA 는 동적 PIVOT SELECT 목록(V_COLUMN)을
--   아래 2갈래 UNION ALL 로 조립(PKG line ~5469 FOR LOOP):
--     branch① : titleset 사용자컬럼 SCM_MST_TITLESET_USER(TYPE='C') ∩ SCM_MST_SHEET_COLUMNS
--     branch② : SCM_MST_SHEET_COLUMNS 중 DEFAULT_FLAG IN ('-',' ','') AND VALID_YN='Y' (고정컬럼)
--   같은 COLUMN_NAME 이 2회 유입되면 인라인뷰 컬럼 ambiguous → ORA-00918.
--   ⚠ MEASURE 는 PIVOT '축' 이라 고정컬럼(branch②)에만 있어야 정상. branch① 에도 나오면 중복.
--
-- ★ 사내(정상) 기준값: 모든 Q = "없음/정상", MEASURE(Mkt Fcst)=DEFAULT_FLAG ' '(공백)/VALID_YN 'Y'/1행, titleset(C)에 MEASURE 없음.
-- ★ 사용법: 아래를 클라우드에서 그대로 실행. 사내와 달라지는 지점이 근본원인.
--   (바인드) :USER = 조회 사용자 ID (예 'minyonglee1')
-- =====================================================================
DEFINE USERID = 'minyonglee1'

-- ── Q1. [핵심] V_COLUMN 조립 union 에서 실제로 중복되는 COLUMN_NAME ──────────────
--     결과에 MEASURE 가 나오면 그게 ORA-00918 의 직접 원인. (사내=0행)
SELECT COLUMN_NAME, COUNT(*) AS CNT FROM (
    SELECT U.COLUMN_NAME
      FROM SCM_MGR.SCM_MST_TITLESET_USER U, SCM_MGR.SCM_MST_SHEET_COLUMNS C
     WHERE U.PROGRAM_ID=C.PROGRAM_ID AND U.SHEET_NAME=C.SHEET_NAME AND U.COLUMN_NAME=C.COLUMN_NAME
       AND U.PROGRAM_ID='DMF0003' AND U.SHEET_NAME='Mkt Fcst'
       AND U.USER_ID='&USERID' AND U.USER_INQUIRY_COLUMN_TYPE_CODE='C'
    UNION ALL
    SELECT C.COLUMN_NAME FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
     WHERE C.PROGRAM_ID='DMF0003' AND C.SHEET_NAME='Mkt Fcst'
       AND (C.DEFAULT_FLAG='-' OR C.DEFAULT_FLAG=' ' OR C.DEFAULT_FLAG='') AND C.VALID_YN='Y'
) GROUP BY COLUMN_NAME HAVING COUNT(*) > 1 ORDER BY CNT DESC, COLUMN_NAME;

-- ── Q2-A. 원천① : SHEET_COLUMNS 자체 중복행 (동일 PROGRAM+SHEET+COLUMN 2행↑) ──────
--     여기에 MEASURE 가 나오면 → 클라우드 SHEET_COLUMNS 에 MEASURE 행이 2개 (branch② 단독 중복). (사내=0행)
SELECT COLUMN_NAME, COUNT(*) AS ROW_CNT FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID='DMF0003' AND SHEET_NAME='Mkt Fcst'
 GROUP BY COLUMN_NAME HAVING COUNT(*) > 1 ORDER BY 2 DESC;

-- ── Q2-B. 원천② : titleset 'C' 에 고정컬럼(branch②)이 섞여 들어감 ────────────────
--     여기에 MEASURE 가 나오면 → 사용자 컬럼설정 캐시에 MEASURE 가 잘못 등록됨 (cross-branch 중복). (사내=0행)
SELECT U.COLUMN_NAME
  FROM SCM_MGR.SCM_MST_TITLESET_USER U
 WHERE U.PROGRAM_ID='DMF0003' AND U.SHEET_NAME='Mkt Fcst'
   AND U.USER_ID='&USERID' AND U.USER_INQUIRY_COLUMN_TYPE_CODE='C'
   AND U.COLUMN_NAME IN (
       SELECT COLUMN_NAME FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
        WHERE PROGRAM_ID='DMF0003' AND SHEET_NAME='Mkt Fcst'
          AND (DEFAULT_FLAG='-' OR DEFAULT_FLAG=' ' OR DEFAULT_FLAG='') AND VALID_YN='Y');

-- ── Q2-C. 원천③ : titleset 'C' 자체 중복행 ──────────────────────────────────────
SELECT COLUMN_NAME, COUNT(*) AS ROW_CNT FROM SCM_MGR.SCM_MST_TITLESET_USER
 WHERE PROGRAM_ID='DMF0003' AND SHEET_NAME='Mkt Fcst'
   AND USER_ID='&USERID' AND USER_INQUIRY_COLUMN_TYPE_CODE='C'
 GROUP BY COLUMN_NAME HAVING COUNT(*) > 1;

-- ── Q3. MEASURE 행 상태 (SHEET_COLUMNS) — 사내: (Mkt Fcst,' ','Y',1행) ────────────
SELECT SHEET_NAME, COLUMN_NAME, DEFAULT_FLAG, VALID_YN,
       COUNT(*) OVER (PARTITION BY SHEET_NAME, COLUMN_NAME) AS DUP_CNT
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID='DMF0003' AND COLUMN_NAME='MEASURE';

-- ── Q4. MEASURE / MEASURE_GROUP 가 titleset 'C' 에 있나 (사내=없음) ───────────────
SELECT USER_ID, COLUMN_NAME, SORT_ORDER_NO
  FROM SCM_MGR.SCM_MST_TITLESET_USER
 WHERE PROGRAM_ID='DMF0003' AND SHEET_NAME='Mkt Fcst'
   AND USER_ID='&USERID' AND USER_INQUIRY_COLUMN_TYPE_CODE='C'
   AND COLUMN_NAME IN ('MEASURE','MEASURE_GROUP');

-- =====================================================================
-- 결과 해석 → 원천별 정정 (Q1 에서 MEASURE 확인 후 어느 Q 가 걸렸는지로 분기)
--  · Q2-A 적중(SHEET_COLUMNS 중복행): 잘못된 중복 행 DELETE (VALID_YN/DEFAULT_FLAG 대조 후 1행만 유지)
--  · Q2-B 적중(titleset C 에 MEASURE): 아래로 사용자 캐시에서 제거 → 다음 조회 시 DEFAULT_FLAG='Y' 기준 재생성
--       DELETE FROM SCM_MGR.SCM_MST_TITLESET_USER
--        WHERE PROGRAM_ID='DMF0003' AND SHEET_NAME='Mkt Fcst' AND USER_INQUIRY_COLUMN_TYPE_CODE='C'
--          AND COLUMN_NAME IN (SELECT COLUMN_NAME FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
--                               WHERE PROGRAM_ID='DMF0003' AND SHEET_NAME='Mkt Fcst'
--                                 AND (DEFAULT_FLAG='-' OR DEFAULT_FLAG=' ' OR DEFAULT_FLAG='') AND VALID_YN='Y');
--       COMMIT;   -- (전 사용자 대상이면 USER_ID 조건 제거)
--  · Q3 에서 MEASURE.DEFAULT_FLAG 가 사내(' ')와 다르면 SHEET_COLUMNS 메타를 사내값으로 UPDATE.
-- =====================================================================
