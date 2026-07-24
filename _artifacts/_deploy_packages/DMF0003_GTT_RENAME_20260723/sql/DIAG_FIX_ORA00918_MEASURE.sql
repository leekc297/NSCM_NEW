-- =====================================================================
-- [DMF0003] ORA-00918 (MEASURE ambiguously specified) 진단·정정 — GTT 리네임과 별개 이슈
-- 원인: 동적 PIVOT SELECT 목록 V_COLUMN 이 아래 2갈래 UNION ALL 로 조립되는데(PKG line ~5467)
--   branch① titleset user(TYPE='C') ∩ SHEET_COLUMNS
--   branch② SHEET_COLUMNS 중 DEFAULT_FLAG IN ('-',' ','')  (고정 컬럼)
-- 동일 컬럼이 양쪽에 잡히면 SELECT 목록에 2회 → 인라인뷰 MEASURE 중복 → ORA-00918.
-- =====================================================================

-- ① [진단] 중복 유발 행 (이 결과가 나오면 원인 확정)
SELECT U.USER_ID, U.COLUMN_NAME, U.SORT_ORDER_NO
  FROM SCM_MGR.SCM_MST_TITLESET_USER U
 WHERE U.PROGRAM_ID='DMF0003' AND U.SHEET_NAME='Mkt Fcst'
   AND U.USER_INQUIRY_COLUMN_TYPE_CODE='C'
   AND U.COLUMN_NAME IN (
       SELECT COLUMN_NAME FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
        WHERE PROGRAM_ID='DMF0003' AND SHEET_NAME='Mkt Fcst'
          AND (DEFAULT_FLAG='-' OR DEFAULT_FLAG=' ' OR DEFAULT_FLAG='') AND VALID_YN='Y');

-- ② [대조] SHEET_COLUMNS DEFAULT_FLAG 상태 (사내 정본 분포: ' '=10 / 'N'=40 / 'Y'=17, MEASURE=' ')
SELECT COLUMN_NAME, DEFAULT_FLAG, VALID_YN, SORT_ORDER_NO
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID='DMF0003' AND SHEET_NAME='Mkt Fcst'
 ORDER BY TO_NUMBER(SORT_ORDER_NO);

-- ③ [정정] ①에서 나온 중복 titleset 행 삭제 (사용자별 캐시 — 다음 조회 시 DEFAULT_FLAG='Y' 기준 자동 재생성됨)
--    ※ 실행 전 ① 결과 확인 필수. 전 사용자 일괄.
-- DELETE FROM SCM_MGR.SCM_MST_TITLESET_USER U
--  WHERE U.PROGRAM_ID='DMF0003' AND U.SHEET_NAME='Mkt Fcst'
--    AND U.USER_INQUIRY_COLUMN_TYPE_CODE='C'
--    AND U.COLUMN_NAME IN (
--        SELECT COLUMN_NAME FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
--         WHERE PROGRAM_ID='DMF0003' AND SHEET_NAME='Mkt Fcst'
--           AND (DEFAULT_FLAG='-' OR DEFAULT_FLAG=' ' OR DEFAULT_FLAG='') AND VALID_YN='Y');
-- COMMIT;
