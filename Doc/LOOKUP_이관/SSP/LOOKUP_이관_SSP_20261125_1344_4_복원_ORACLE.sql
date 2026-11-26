-- ==============================================================================================================
-- LOOKUP 이관 4/4 · Oracle(클라우드 QA) 복원 · 이관 결과를 되돌릴 때만 실행
-- 단위 : SSP · 작성 2026-11-25 13:44
-- 대상 : 그룹 = SSP
-- 대상 : LOOKUP_TYPE = 조건 없음
-- 대상 : 상세 제외 유형 = IF_STOCK_CHECK
-- 범위 : 지금 대상 조건에 맞는 유형 + 백업 때 대상 조건에 맞던 유형. 다른 유형은 건드리지 않음
-- 순서 : [R1] → [R2] → [R3] → [R4] → [R5] 확인 → COMMIT(맞지 않으면 ROLLBACK)
-- 결과 : 이관으로 새로 생긴 유형과 행은 지워지고, 백업 때 행이 돌아옴. 상세 제외 유형은 지금 값 그대로 둠
-- 백업 테이블 : SCM_ADM_LOOKUP_MASTER_BK20261125, SCM_ADM_LOOKUP_MASTER_DETAIL_BK20261125
-- ==============================================================================================================

-- ==============================================================================================================
-- [R1] 상세 삭제(변경 문장)
-- ==============================================================================================================
DELETE FROM SCM_ADM_LOOKUP_MASTER_DETAIL D
 WHERE D.LOOKUP_TYPE IN (SELECT M.LOOKUP_TYPE FROM SCM_ADM_LOOKUP_MASTER M WHERE M.LOOKUP_GROUP IN ('SSP')
                          UNION
                         SELECT M.LOOKUP_TYPE FROM SCM_ADM_LOOKUP_MASTER_BK20261125 M WHERE M.LOOKUP_GROUP IN ('SSP'))
   AND D.LOOKUP_TYPE NOT IN ('IF_STOCK_CHECK');

-- ==============================================================================================================
-- [R2] 상세 복원(변경 문장) : [R1] 과 같은 범위의 백업 행
-- ==============================================================================================================
INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
SELECT B.*
  FROM SCM_ADM_LOOKUP_MASTER_DETAIL_BK20261125 B
 WHERE B.LOOKUP_TYPE IN (SELECT M.LOOKUP_TYPE FROM SCM_ADM_LOOKUP_MASTER M WHERE M.LOOKUP_GROUP IN ('SSP')
                          UNION
                         SELECT M.LOOKUP_TYPE FROM SCM_ADM_LOOKUP_MASTER_BK20261125 M WHERE M.LOOKUP_GROUP IN ('SSP'))
   AND B.LOOKUP_TYPE NOT IN ('IF_STOCK_CHECK');

-- ==============================================================================================================
-- [R3] 마스터 삭제(변경 문장) : 백업에 없는 유형만
-- ==============================================================================================================
DELETE FROM SCM_ADM_LOOKUP_MASTER T
 WHERE T.LOOKUP_TYPE IN (SELECT M.LOOKUP_TYPE FROM SCM_ADM_LOOKUP_MASTER M WHERE M.LOOKUP_GROUP IN ('SSP')
                          UNION
                         SELECT M.LOOKUP_TYPE FROM SCM_ADM_LOOKUP_MASTER_BK20261125 M WHERE M.LOOKUP_GROUP IN ('SSP'))
   AND NOT EXISTS (SELECT 1
                     FROM SCM_ADM_LOOKUP_MASTER_BK20261125 B
                    WHERE B.LOOKUP_TYPE = T.LOOKUP_TYPE);

-- ==============================================================================================================
-- [R4] 마스터 복원(변경 문장) : 백업 값으로 덮어씀
-- ==============================================================================================================
MERGE INTO SCM_ADM_LOOKUP_MASTER T
USING (SELECT B.*
         FROM SCM_ADM_LOOKUP_MASTER_BK20261125 B
        WHERE B.LOOKUP_TYPE IN (SELECT M.LOOKUP_TYPE FROM SCM_ADM_LOOKUP_MASTER M WHERE M.LOOKUP_GROUP IN ('SSP')
                          UNION
                         SELECT M.LOOKUP_TYPE FROM SCM_ADM_LOOKUP_MASTER_BK20261125 M WHERE M.LOOKUP_GROUP IN ('SSP'))) S
   ON (T.LOOKUP_TYPE = S.LOOKUP_TYPE)
 WHEN MATCHED THEN UPDATE SET T.DESCRIPTION = S.DESCRIPTION
                          , T.LOOKUP_GROUP = S.LOOKUP_GROUP
                          , T.VALID_YN = S.VALID_YN
                          , T.SEGMENT1 = S.SEGMENT1
                          , T.SEGMENT2 = S.SEGMENT2
                          , T.SEGMENT3 = S.SEGMENT3
                          , T.SEGMENT4 = S.SEGMENT4
                          , T.SEGMENT5 = S.SEGMENT5
                          , T.CREATED_BY = S.CREATED_BY
                          , T.CREATION_DATE = S.CREATION_DATE
                          , T.LAST_UPDATED_BY = S.LAST_UPDATED_BY
                          , T.LAST_UPDATE_DATE = S.LAST_UPDATE_DATE
                          , T.ATTRIBUTE1 = S.ATTRIBUTE1
                          , T.ATTRIBUTE2 = S.ATTRIBUTE2
                          , T.ATTRIBUTE3 = S.ATTRIBUTE3
                          , T.ATTRIBUTE4 = S.ATTRIBUTE4
                          , T.ATTRIBUTE5 = S.ATTRIBUTE5
                          , T.ATTRIBUTE6 = S.ATTRIBUTE6
                          , T.ATTRIBUTE7 = S.ATTRIBUTE7
                          , T.ATTRIBUTE8 = S.ATTRIBUTE8
                          , T.ATTRIBUTE9 = S.ATTRIBUTE9
                          , T.ATTRIBUTE10 = S.ATTRIBUTE10
                          , T.ATTRIBUTE11 = S.ATTRIBUTE11
                          , T.ATTRIBUTE12 = S.ATTRIBUTE12
                          , T.ATTRIBUTE13 = S.ATTRIBUTE13
                          , T.ATTRIBUTE14 = S.ATTRIBUTE14
                          , T.ATTRIBUTE15 = S.ATTRIBUTE15
 WHEN NOT MATCHED THEN INSERT (LOOKUP_TYPE, DESCRIPTION, LOOKUP_GROUP, VALID_YN, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15)
 VALUES (S.LOOKUP_TYPE, S.DESCRIPTION, S.LOOKUP_GROUP, S.VALID_YN, S.SEGMENT1, S.SEGMENT2, S.SEGMENT3, S.SEGMENT4, S.SEGMENT5, S.CREATED_BY, S.CREATION_DATE, S.LAST_UPDATED_BY, S.LAST_UPDATE_DATE, S.ATTRIBUTE1, S.ATTRIBUTE2, S.ATTRIBUTE3, S.ATTRIBUTE4, S.ATTRIBUTE5, S.ATTRIBUTE6, S.ATTRIBUTE7, S.ATTRIBUTE8, S.ATTRIBUTE9, S.ATTRIBUTE10, S.ATTRIBUTE11, S.ATTRIBUTE12, S.ATTRIBUTE13, S.ATTRIBUTE14, S.ATTRIBUTE15);

-- ==============================================================================================================
-- [R5] 복원 확인
-- 확인 : 네 값이 모두 0
-- ==============================================================================================================
SELECT (SELECT COUNT(*)
          FROM (SELECT X.* FROM SCM_ADM_LOOKUP_MASTER X WHERE X.LOOKUP_TYPE IN (SELECT M.LOOKUP_TYPE FROM SCM_ADM_LOOKUP_MASTER M WHERE M.LOOKUP_GROUP IN ('SSP')
                          UNION
                         SELECT M.LOOKUP_TYPE FROM SCM_ADM_LOOKUP_MASTER_BK20261125 M WHERE M.LOOKUP_GROUP IN ('SSP'))
                MINUS
                SELECT X.* FROM SCM_ADM_LOOKUP_MASTER_BK20261125 X WHERE X.LOOKUP_TYPE IN (SELECT M.LOOKUP_TYPE FROM SCM_ADM_LOOKUP_MASTER M WHERE M.LOOKUP_GROUP IN ('SSP')
                          UNION
                         SELECT M.LOOKUP_TYPE FROM SCM_ADM_LOOKUP_MASTER_BK20261125 M WHERE M.LOOKUP_GROUP IN ('SSP')))) AS MASTER_ONLY_NOW
     , (SELECT COUNT(*)
          FROM (SELECT X.* FROM SCM_ADM_LOOKUP_MASTER_BK20261125 X WHERE X.LOOKUP_TYPE IN (SELECT M.LOOKUP_TYPE FROM SCM_ADM_LOOKUP_MASTER M WHERE M.LOOKUP_GROUP IN ('SSP')
                          UNION
                         SELECT M.LOOKUP_TYPE FROM SCM_ADM_LOOKUP_MASTER_BK20261125 M WHERE M.LOOKUP_GROUP IN ('SSP'))
                MINUS
                SELECT X.* FROM SCM_ADM_LOOKUP_MASTER X WHERE X.LOOKUP_TYPE IN (SELECT M.LOOKUP_TYPE FROM SCM_ADM_LOOKUP_MASTER M WHERE M.LOOKUP_GROUP IN ('SSP')
                          UNION
                         SELECT M.LOOKUP_TYPE FROM SCM_ADM_LOOKUP_MASTER_BK20261125 M WHERE M.LOOKUP_GROUP IN ('SSP')))) AS MASTER_ONLY_BK
     , (SELECT COUNT(*)
          FROM (SELECT X.* FROM SCM_ADM_LOOKUP_MASTER_DETAIL X WHERE X.LOOKUP_TYPE IN (SELECT M.LOOKUP_TYPE FROM SCM_ADM_LOOKUP_MASTER M WHERE M.LOOKUP_GROUP IN ('SSP')
                          UNION
                         SELECT M.LOOKUP_TYPE FROM SCM_ADM_LOOKUP_MASTER_BK20261125 M WHERE M.LOOKUP_GROUP IN ('SSP')) AND X.LOOKUP_TYPE NOT IN ('IF_STOCK_CHECK')
                MINUS
                SELECT X.* FROM SCM_ADM_LOOKUP_MASTER_DETAIL_BK20261125 X WHERE X.LOOKUP_TYPE IN (SELECT M.LOOKUP_TYPE FROM SCM_ADM_LOOKUP_MASTER M WHERE M.LOOKUP_GROUP IN ('SSP')
                          UNION
                         SELECT M.LOOKUP_TYPE FROM SCM_ADM_LOOKUP_MASTER_BK20261125 M WHERE M.LOOKUP_GROUP IN ('SSP')) AND X.LOOKUP_TYPE NOT IN ('IF_STOCK_CHECK'))) AS DETAIL_ONLY_NOW
     , (SELECT COUNT(*)
          FROM (SELECT X.* FROM SCM_ADM_LOOKUP_MASTER_DETAIL_BK20261125 X WHERE X.LOOKUP_TYPE IN (SELECT M.LOOKUP_TYPE FROM SCM_ADM_LOOKUP_MASTER M WHERE M.LOOKUP_GROUP IN ('SSP')
                          UNION
                         SELECT M.LOOKUP_TYPE FROM SCM_ADM_LOOKUP_MASTER_BK20261125 M WHERE M.LOOKUP_GROUP IN ('SSP')) AND X.LOOKUP_TYPE NOT IN ('IF_STOCK_CHECK')
                MINUS
                SELECT X.* FROM SCM_ADM_LOOKUP_MASTER_DETAIL X WHERE X.LOOKUP_TYPE IN (SELECT M.LOOKUP_TYPE FROM SCM_ADM_LOOKUP_MASTER M WHERE M.LOOKUP_GROUP IN ('SSP')
                          UNION
                         SELECT M.LOOKUP_TYPE FROM SCM_ADM_LOOKUP_MASTER_BK20261125 M WHERE M.LOOKUP_GROUP IN ('SSP')) AND X.LOOKUP_TYPE NOT IN ('IF_STOCK_CHECK'))) AS DETAIL_ONLY_BK
  FROM DUAL;

-- ==============================================================================================================
-- [R6] 반영 : [R5] 가 모두 0 이면 아래 COMMIT 실행
-- ==============================================================================================================
-- COMMIT;
