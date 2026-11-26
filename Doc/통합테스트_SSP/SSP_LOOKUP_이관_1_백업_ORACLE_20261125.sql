-- ==============================================================================================================
-- SSP LOOKUP 이관 1/4 · Oracle(클라우드 QA) LOOKUP 테이블 백업
-- 순서 : [B1] · [B2] 백업 테이블 생성 → [B3] 건수 확인 → 2/4 파일(MSSQL) 실행
-- 백업 범위 : 두 테이블 전체 행(모든 LOOKUP_GROUP). 4/4 복원 파일은 이 백업에서 SSP 그룹만 되돌림
-- 실행 : DBeaver 에서 문장 하나씩(커서를 문장 안에 두고 Ctrl+Enter) 또는 파일 전체 Alt+X
-- 주의 : CREATE TABLE 은 실행하면 바로 반영됨(ROLLBACK 대상 아님). 같은 이름 테이블이 있으면 ORA-00955 로 멈춤
--        → 그때는 이미 백업이 있는 것이므로 [B3] 로 건수만 확인하고 진행
-- 로컬 시험(2026-11-25 ZIOUI1, 시험용 이름으로 생성 후 삭제) : 오류 0
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
-- 확인 : MASTER_CNT = MASTER_BK_CNT, DETAIL_CNT = DETAIL_BK_CNT. SSP 그룹 건수도 같은지 확인
-- ==============================================================================================================
SELECT (SELECT COUNT(*)
          FROM SCM_ADM_LOOKUP_MASTER) AS MASTER_CNT
     , (SELECT COUNT(*)
          FROM SCM_ADM_LOOKUP_MASTER_BK20261125) AS MASTER_BK_CNT
     , (SELECT COUNT(*)
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL) AS DETAIL_CNT
     , (SELECT COUNT(*)
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL_BK20261125) AS DETAIL_BK_CNT
     , (SELECT COUNT(*)
          FROM SCM_ADM_LOOKUP_MASTER_BK20261125 B
         WHERE B.LOOKUP_GROUP = 'SSP') AS SSP_MASTER_BK_CNT
     , (SELECT COUNT(*)
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL_BK20261125 D
         WHERE D.LOOKUP_TYPE IN (SELECT B.LOOKUP_TYPE
                                   FROM SCM_ADM_LOOKUP_MASTER_BK20261125 B
                                  WHERE B.LOOKUP_GROUP = 'SSP')) AS SSP_DETAIL_BK_CNT
  FROM DUAL;
