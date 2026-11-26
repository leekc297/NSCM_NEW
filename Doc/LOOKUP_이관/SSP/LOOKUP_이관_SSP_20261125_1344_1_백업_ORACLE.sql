-- ==============================================================================================================
-- LOOKUP 이관 1/4 · Oracle(클라우드 QA) LOOKUP 테이블 백업
-- 단위 : SSP · 작성 2026-11-25 13:44
-- 대상 : 그룹 = SSP
-- 대상 : LOOKUP_TYPE = 조건 없음
-- 대상 : 상세 제외 유형 = IF_STOCK_CHECK
-- 순서 : [B1] · [B2] 백업 테이블 생성 → [B3] 건수 확인 → 2/4 파일(MSSQL) 실행
-- 백업 범위 : 두 테이블 전체 행. 4/4 복원 파일은 이 백업에서 이번 대상 유형만 되돌림
-- 주의 : CREATE TABLE 은 실행하면 바로 반영됨. 같은 이름 테이블이 있으면 ORA-00955 로 멈춤. 그때는 [B3] 로 건수만 확인하고 진행
-- 백업 테이블 : SCM_ADM_LOOKUP_MASTER_BK20261125, SCM_ADM_LOOKUP_MASTER_DETAIL_BK20261125
-- ==============================================================================================================

-- ==============================================================================================================
-- [B1] 마스터 백업
-- ==============================================================================================================
CREATE TABLE SCM_ADM_LOOKUP_MASTER_BK20261125 AS
SELECT *
  FROM SCM_ADM_LOOKUP_MASTER;

-- ==============================================================================================================
-- [B2] 상세 백업
-- ==============================================================================================================
CREATE TABLE SCM_ADM_LOOKUP_MASTER_DETAIL_BK20261125 AS
SELECT *
  FROM SCM_ADM_LOOKUP_MASTER_DETAIL;

-- ==============================================================================================================
-- [B3] 백업 건수 확인
-- 확인 : MASTER_CNT = MASTER_BK_CNT, DETAIL_CNT = DETAIL_BK_CNT. SCOPE_* = 이번 대상의 백업 건수
-- ==============================================================================================================
SELECT (SELECT COUNT(*) FROM SCM_ADM_LOOKUP_MASTER) AS MASTER_CNT
     , (SELECT COUNT(*) FROM SCM_ADM_LOOKUP_MASTER_BK20261125) AS MASTER_BK_CNT
     , (SELECT COUNT(*) FROM SCM_ADM_LOOKUP_MASTER_DETAIL) AS DETAIL_CNT
     , (SELECT COUNT(*) FROM SCM_ADM_LOOKUP_MASTER_DETAIL_BK20261125) AS DETAIL_BK_CNT
     , (SELECT COUNT(*) FROM SCM_ADM_LOOKUP_MASTER_BK20261125 M WHERE M.LOOKUP_GROUP IN ('SSP')) AS SCOPE_MASTER_BK_CNT
     , (SELECT COUNT(*) FROM SCM_ADM_LOOKUP_MASTER_DETAIL_BK20261125 D WHERE D.LOOKUP_TYPE IN (SELECT M.LOOKUP_TYPE FROM SCM_ADM_LOOKUP_MASTER_BK20261125 M WHERE M.LOOKUP_GROUP IN ('SSP'))
   AND D.LOOKUP_TYPE NOT IN ('IF_STOCK_CHECK')) AS SCOPE_DETAIL_BK_CNT
  FROM DUAL;
