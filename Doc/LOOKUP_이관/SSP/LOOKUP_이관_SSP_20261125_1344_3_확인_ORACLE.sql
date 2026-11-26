-- ==============================================================================================================
-- LOOKUP 이관 3/4 · Oracle(클라우드 QA) 확인 쿼리 · 조회 문장
-- 단위 : SSP · 작성 2026-11-25 13:44
-- 대상 : 그룹 = SSP
-- 대상 : LOOKUP_TYPE = 조건 없음
-- 대상 : 상세 제외 유형 = IF_STOCK_CHECK
-- 순서 : [O1] 실행 전 건수 기록 → 2/4 파일 [M2] 결과(MERGE 문장) 실행 → [O1] · [O2] · [O3] 다시 실행 → 맞으면 COMMIT
-- DBeaver 자동 커밋이 켜져 있으면 MERGE 문장마다 바로 반영됨. 확인 뒤 반영하려면 수동 커밋으로 바꾸고 실행
-- ==============================================================================================================

-- ==============================================================================================================
-- [O1] 대상 건수
-- 확인 : MERGE 뒤 MASTER_CNT ≥ 2/4 파일 [M1] MASTER_CNT, DETAIL_CNT ≥ [M1] DETAIL_CNT. Oracle 에만 있는 행은 지우지 않으므로 같거나 많음
-- ==============================================================================================================
SELECT (SELECT COUNT(*) FROM SCM_ADM_LOOKUP_MASTER M WHERE M.LOOKUP_GROUP IN ('SSP')) AS MASTER_CNT
     , (SELECT COUNT(*) FROM SCM_ADM_LOOKUP_MASTER_DETAIL D WHERE D.LOOKUP_TYPE IN (SELECT M.LOOKUP_TYPE FROM SCM_ADM_LOOKUP_MASTER M WHERE M.LOOKUP_GROUP IN ('SSP'))
   AND D.LOOKUP_TYPE NOT IN ('IF_STOCK_CHECK')) AS DETAIL_CNT
  FROM DUAL;

-- ==============================================================================================================
-- [O2] 유형별 상세 건수
-- 확인 : 2/4 파일 [M3] 와 유형별 비교. MSSQL 에 있는 유형은 DETAIL_CNT 가 같거나 많음
-- ==============================================================================================================
SELECT M.LOOKUP_TYPE
     , M.LOOKUP_GROUP
     , M.VALID_YN
     , (SELECT COUNT(*)
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL D
         WHERE D.LOOKUP_TYPE = M.LOOKUP_TYPE
   AND D.LOOKUP_TYPE NOT IN ('IF_STOCK_CHECK')) AS DETAIL_CNT
     , (SELECT MAX(D.LAST_UPDATE_DATE)
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL D
         WHERE D.LOOKUP_TYPE = M.LOOKUP_TYPE) AS LAST_UPDATE_DATE
  FROM SCM_ADM_LOOKUP_MASTER M
 WHERE M.LOOKUP_GROUP IN ('SSP')
 ORDER BY M.LOOKUP_TYPE;

-- ==============================================================================================================
-- [O3] 상세 VALID_YN 값
-- 확인 : Y, N, / 만 나옴(소문자 y 없음)
-- ==============================================================================================================
SELECT D.VALID_YN
     , COUNT(*) AS CNT
  FROM SCM_ADM_LOOKUP_MASTER_DETAIL D
 WHERE D.LOOKUP_TYPE IN (SELECT M.LOOKUP_TYPE FROM SCM_ADM_LOOKUP_MASTER M WHERE M.LOOKUP_GROUP IN ('SSP'))
   AND D.LOOKUP_TYPE NOT IN ('IF_STOCK_CHECK')
 GROUP BY D.VALID_YN
 ORDER BY D.VALID_YN;

-- ==============================================================================================================
-- [O4] 반영 : 위 결과가 맞으면 아래 COMMIT 실행. 맞지 않으면 ROLLBACK 실행 후 결과 회신
-- COMMIT 뒤 되돌릴 때는 4/4 복원 파일 실행
-- ==============================================================================================================
-- COMMIT;
