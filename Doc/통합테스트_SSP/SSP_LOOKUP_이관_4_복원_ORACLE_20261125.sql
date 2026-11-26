-- ==============================================================================================================
-- SSP LOOKUP 이관 4/4 · Oracle(클라우드 QA) 복원 · 이관 결과를 되돌릴 때만 실행
-- 범위 : 지금 SSP 그룹인 유형 + 백업 때 SSP 그룹이던 유형. 다른 그룹 유형은 건드리지 않음
-- 순서 : [R1] → [R2] → [R3] → [R4] 차례로 실행 → [R5] 확인 → COMMIT(맞지 않으면 ROLLBACK)
--        [R3] 이 SSP 그룹 마스터를 지우기 때문에 [R1] · [R2] 를 먼저 실행해야 함
-- 실행 : DBeaver 에서 문장 하나씩 Ctrl+Enter([R1]~[R4] 순서) 또는 [R1]~[R5] 를 골라 Alt+X. 자동 커밋을 끄고 실행
-- 결과 : 이관으로 새로 생긴 유형 · 행은 지워지고, 백업 때 행이 그대로 돌아옴
-- 로컬 시험(2026-11-25 ZIOUI1) : MERGE 실행 → [R1] ~ [R4] → 백업과 대조 차이 0 → ROLLBACK
-- ==============================================================================================================

-- ==============================================================================================================
-- [R1] 상세 삭제(변경 문장)
-- ==============================================================================================================
DELETE FROM SCM_ADM_LOOKUP_MASTER_DETAIL D
 WHERE D.LOOKUP_TYPE IN (SELECT M.LOOKUP_TYPE
                           FROM SCM_ADM_LOOKUP_MASTER M
                          WHERE M.LOOKUP_GROUP = 'SSP'
                          UNION
                         SELECT B.LOOKUP_TYPE
                           FROM SCM_ADM_LOOKUP_MASTER_BK20261125 B
                          WHERE B.LOOKUP_GROUP = 'SSP');

-- ==============================================================================================================
-- [R2] 상세 복원(변경 문장) : [R1] 과 같은 유형 범위의 백업 행
-- ==============================================================================================================
INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
SELECT D.*
  FROM SCM_ADM_LOOKUP_MASTER_DETAIL_BK20261125 D
 WHERE D.LOOKUP_TYPE IN (SELECT M.LOOKUP_TYPE
                           FROM SCM_ADM_LOOKUP_MASTER M
                          WHERE M.LOOKUP_GROUP = 'SSP'
                          UNION
                         SELECT B.LOOKUP_TYPE
                           FROM SCM_ADM_LOOKUP_MASTER_BK20261125 B
                          WHERE B.LOOKUP_GROUP = 'SSP');

-- ==============================================================================================================
-- [R3] 마스터 삭제(변경 문장)
-- ==============================================================================================================
DELETE FROM SCM_ADM_LOOKUP_MASTER M
 WHERE M.LOOKUP_GROUP = 'SSP'
    OR M.LOOKUP_TYPE IN (SELECT B.LOOKUP_TYPE
                           FROM SCM_ADM_LOOKUP_MASTER_BK20261125 B
                          WHERE B.LOOKUP_GROUP = 'SSP');

-- ==============================================================================================================
-- [R4] 마스터 복원(변경 문장) : 백업에 있고 지금 없는 유형
-- ==============================================================================================================
INSERT INTO SCM_ADM_LOOKUP_MASTER
SELECT B.*
  FROM SCM_ADM_LOOKUP_MASTER_BK20261125 B
 WHERE NOT EXISTS (SELECT 1
                     FROM SCM_ADM_LOOKUP_MASTER M
                    WHERE M.LOOKUP_TYPE = B.LOOKUP_TYPE);

-- ==============================================================================================================
-- [R5] 복원 확인(SSP 그룹 범위)
-- 확인 : 네 값이 모두 0
-- ==============================================================================================================
SELECT (SELECT COUNT(*)
          FROM (SELECT * FROM SCM_ADM_LOOKUP_MASTER WHERE LOOKUP_GROUP = 'SSP'
                MINUS
                SELECT * FROM SCM_ADM_LOOKUP_MASTER_BK20261125 WHERE LOOKUP_GROUP = 'SSP')) AS MASTER_ONLY_NOW
     , (SELECT COUNT(*)
          FROM (SELECT * FROM SCM_ADM_LOOKUP_MASTER_BK20261125 WHERE LOOKUP_GROUP = 'SSP'
                MINUS
                SELECT * FROM SCM_ADM_LOOKUP_MASTER WHERE LOOKUP_GROUP = 'SSP')) AS MASTER_ONLY_BK
     , (SELECT COUNT(*)
          FROM (SELECT * FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                 WHERE LOOKUP_TYPE IN (SELECT LOOKUP_TYPE FROM SCM_ADM_LOOKUP_MASTER WHERE LOOKUP_GROUP = 'SSP')
                MINUS
                SELECT * FROM SCM_ADM_LOOKUP_MASTER_DETAIL_BK20261125
                 WHERE LOOKUP_TYPE IN (SELECT LOOKUP_TYPE FROM SCM_ADM_LOOKUP_MASTER_BK20261125 WHERE LOOKUP_GROUP = 'SSP'))) AS DETAIL_ONLY_NOW
     , (SELECT COUNT(*)
          FROM (SELECT * FROM SCM_ADM_LOOKUP_MASTER_DETAIL_BK20261125
                 WHERE LOOKUP_TYPE IN (SELECT LOOKUP_TYPE FROM SCM_ADM_LOOKUP_MASTER_BK20261125 WHERE LOOKUP_GROUP = 'SSP')
                MINUS
                SELECT * FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                 WHERE LOOKUP_TYPE IN (SELECT LOOKUP_TYPE FROM SCM_ADM_LOOKUP_MASTER WHERE LOOKUP_GROUP = 'SSP'))) AS DETAIL_ONLY_BK
  FROM DUAL;

-- ==============================================================================================================
-- [R6] 반영 : [R5] 가 모두 0 이면 아래 COMMIT 실행
-- ==============================================================================================================
-- COMMIT;
