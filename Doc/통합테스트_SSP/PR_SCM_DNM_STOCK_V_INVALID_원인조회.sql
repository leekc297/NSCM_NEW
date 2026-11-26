-- PR_SCM_DNM_STOCK_V INVALID 원인 조회(클라우드 QA) · DBeaver 에서 쿼리 하나씩 실행(커서를 쿼리 안에 두고 Ctrl+Enter)
-- 맨 위 WITH PRM 줄의 소유 스키마 · 프로그램 이름만 바꾸면 다른 프로그램에도 쓸 수 있음
-- 조회만 수행. 변경은 Q7 한 문장뿐
-- Q4 에서 뷰 SCM_DNM_STOCK_V 가 INVALID 또는 없음이면, P_NAME 을 'SCM_DNM_STOCK_V' 로 바꿔 Q2 · Q4 · Q5 를 다시 실행(뷰가 읽는 객체 확인)
-- 사내 DB(ZIOUI1) 2026-11-25 09:30 실행 결과 : Q1 INVALID · Q2 0행 · Q4 참조 3개 모두 VALID · Q6 뷰 SCM_DNM_STOCK_V 가 2026-11-23 22:24 변경(프로그램 컴파일 2026-11-17 보다 나중)

-- [Q1] 프로그램 상태 · 최종 변경 일시
-- 확인 : STATUS = INVALID 인지, LAST_DDL_TIME(마지막 컴파일 · 변경 시각) 확인
WITH PRM AS (SELECT 'SCM_MGR' AS P_OWNER, 'PR_SCM_DNM_STOCK_V' AS P_NAME FROM DUAL)   /* 소유 스키마 · 프로그램 이름. 이 줄의 값만 바꿔 실행 */
SELECT O.OWNER
     , O.OBJECT_NAME
     , O.OBJECT_TYPE
     , O.STATUS
     , O.CREATED
     , O.LAST_DDL_TIME
     , O.TIMESTAMP
  FROM ALL_OBJECTS O
     , PRM
 WHERE O.OWNER = PRM.P_OWNER
   AND O.OBJECT_NAME = PRM.P_NAME;

-- [Q2] 컴파일 오류 내용
-- 확인 : 행이 있으면 그 줄 · 문구가 원인. 0행이면 컴파일 오류가 아니라 참조 객체 변경으로 무효 표시만 된 상태(Q7 재컴파일로 해소)
WITH PRM AS (SELECT 'SCM_MGR' AS P_OWNER, 'PR_SCM_DNM_STOCK_V' AS P_NAME FROM DUAL)   /* 소유 스키마 · 프로그램 이름. 이 줄의 값만 바꿔 실행 */
SELECT E.NAME
     , E.TYPE
     , E.SEQUENCE
     , E.LINE
     , E.POSITION
     , E.ATTRIBUTE                   /* ERROR 오류, WARNING 경고 */
     , E.TEXT
  FROM ALL_ERRORS E
     , PRM
 WHERE E.OWNER = PRM.P_OWNER
   AND E.NAME = PRM.P_NAME
 ORDER BY E.SEQUENCE;

-- [Q3] 오류 줄의 원문
-- 확인 : Q2 의 LINE 에 해당하는 소스 줄. 어떤 테이블 · 컬럼 · 프로그램을 못 찾는지 확인
WITH PRM AS (SELECT 'SCM_MGR' AS P_OWNER, 'PR_SCM_DNM_STOCK_V' AS P_NAME FROM DUAL)   /* 소유 스키마 · 프로그램 이름. 이 줄의 값만 바꿔 실행 */
SELECT S.LINE
     , S.TEXT
  FROM ALL_SOURCE S
     , PRM
 WHERE S.OWNER = PRM.P_OWNER
   AND S.NAME = PRM.P_NAME
   AND S.LINE IN (SELECT E.LINE
                    FROM ALL_ERRORS E
                   WHERE E.OWNER = PRM.P_OWNER
                     AND E.NAME = PRM.P_NAME)
 ORDER BY S.LINE;

-- [Q4] 참조 객체 상태(없는 객체 · INVALID 객체)
-- 확인 : REF_STATUS 가 없음 또는 INVALID 인 행이 원인 후보. 모두 VALID 면 Q7 재컴파일
WITH PRM AS (SELECT 'SCM_MGR' AS P_OWNER, 'PR_SCM_DNM_STOCK_V' AS P_NAME FROM DUAL)   /* 소유 스키마 · 프로그램 이름. 이 줄의 값만 바꿔 실행 */
SELECT D.REFERENCED_OWNER
     , D.REFERENCED_NAME
     , D.REFERENCED_TYPE
     , NVL(O.STATUS, '없음') AS REF_STATUS          /* 없음 = 객체가 없거나 조회 권한 없음 */
     , O.LAST_DDL_TIME AS REF_LAST_DDL_TIME
  FROM ALL_DEPENDENCIES D
     , ALL_OBJECTS O
     , PRM
 WHERE O.OWNER(+) = D.REFERENCED_OWNER
   AND O.OBJECT_NAME(+) = D.REFERENCED_NAME
   AND O.OBJECT_TYPE(+) = D.REFERENCED_TYPE
   AND D.OWNER = PRM.P_OWNER
   AND D.NAME = PRM.P_NAME
   AND D.REFERENCED_OWNER NOT IN ('SYS', 'PUBLIC')
 ORDER BY CASE WHEN O.STATUS = 'VALID' THEN 1 ELSE 0 END
        , D.REFERENCED_TYPE
        , D.REFERENCED_NAME;

-- [Q5] 참조 시노님이 가리키는 대상 존재 여부
-- 확인 : TARGET_STATUS 가 없음이면 시노님이 가리키는 테이블 · 프로그램이 클라우드에 없음(다른 스키마 객체 미이관 또는 권한 없음)
WITH PRM AS (SELECT 'SCM_MGR' AS P_OWNER, 'PR_SCM_DNM_STOCK_V' AS P_NAME FROM DUAL)   /* 소유 스키마 · 프로그램 이름. 이 줄의 값만 바꿔 실행 */
SELECT S.OWNER AS SYNONYM_OWNER
     , S.SYNONYM_NAME
     , S.TABLE_OWNER AS TARGET_OWNER
     , S.TABLE_NAME AS TARGET_NAME
     , S.DB_LINK
     , NVL(MAX(O.STATUS), '없음') AS TARGET_STATUS
     , MAX(O.OBJECT_TYPE) AS TARGET_TYPE
  FROM ALL_SYNONYMS S
     , ALL_OBJECTS O
     , PRM
 WHERE O.OWNER(+) = S.TABLE_OWNER
   AND O.OBJECT_NAME(+) = S.TABLE_NAME
   AND (S.OWNER, S.SYNONYM_NAME) IN (SELECT D.REFERENCED_OWNER
                                          , D.REFERENCED_NAME
                                       FROM ALL_DEPENDENCIES D
                                      WHERE D.OWNER = PRM.P_OWNER
                                        AND D.NAME = PRM.P_NAME
                                        AND D.REFERENCED_TYPE = 'SYNONYM')
 GROUP BY S.OWNER
        , S.SYNONYM_NAME
        , S.TABLE_OWNER
        , S.TABLE_NAME
        , S.DB_LINK
 ORDER BY 6
        , 2;

-- [Q6] 참조 테이블 · 뷰 중 최근 7일 안에 구조가 바뀐 것
-- 확인 : 프로그램 LAST_DDL_TIME 보다 나중에 바뀐 참조 객체가 무효 표시를 만든 원인
WITH PRM AS (SELECT 'SCM_MGR' AS P_OWNER, 'PR_SCM_DNM_STOCK_V' AS P_NAME FROM DUAL)   /* 소유 스키마 · 프로그램 이름. 이 줄의 값만 바꿔 실행 */
SELECT D.REFERENCED_OWNER
     , D.REFERENCED_NAME
     , D.REFERENCED_TYPE
     , O.STATUS
     , O.LAST_DDL_TIME
  FROM ALL_DEPENDENCIES D
     , ALL_OBJECTS O
     , PRM
 WHERE O.OWNER = D.REFERENCED_OWNER
   AND O.OBJECT_NAME = D.REFERENCED_NAME
   AND O.OBJECT_TYPE = D.REFERENCED_TYPE
   AND D.OWNER = PRM.P_OWNER
   AND D.NAME = PRM.P_NAME
   AND D.REFERENCED_OWNER NOT IN ('SYS', 'PUBLIC')
   AND O.LAST_DDL_TIME >= SYSDATE - 7
 ORDER BY O.LAST_DDL_TIME DESC;

-- [Q7] 재컴파일(변경 문장) : Q2 가 0행이고 Q4 · Q5 에 없음 · INVALID 가 없을 때 실행. 실행 뒤 Q1 · Q2 다시 조회
ALTER PROCEDURE SCM_MGR.PR_SCM_DNM_STOCK_V COMPILE;

-- [Q8] 같은 원인으로 함께 INVALID 가 된 SSP · 재고 프로그램
-- 확인 : 이 프로그램 하나만의 문제인지, 공통 참조 객체 변경으로 여러 개가 함께 무효가 됐는지 확인
WITH PRM AS (SELECT 'SCM_MGR' AS P_OWNER FROM DUAL)   /* 소유 스키마. 이 줄의 값만 바꿔 실행 */
SELECT O.OBJECT_NAME
     , O.OBJECT_TYPE
     , O.STATUS
     , O.LAST_DDL_TIME
     , (SELECT COUNT(*)
          FROM ALL_ERRORS E
         WHERE E.OWNER = O.OWNER
           AND E.NAME = O.OBJECT_NAME
           AND E.TYPE = O.OBJECT_TYPE
           AND E.ATTRIBUTE = 'ERROR') AS ERROR_CNT      /* 0 = 무효 표시만, 1 이상 = 컴파일 오류 */
  FROM ALL_OBJECTS O
     , PRM
 WHERE O.OWNER = PRM.P_OWNER
   AND O.STATUS = 'INVALID'
   AND O.OBJECT_TYPE IN ('PROCEDURE', 'FUNCTION', 'PACKAGE', 'PACKAGE BODY', 'VIEW')
   AND (   O.OBJECT_NAME LIKE 'PR_SSP%'
        OR O.OBJECT_NAME LIKE 'PKG_SSP%'
        OR O.OBJECT_NAME LIKE 'FN_GET_SSP%'
        OR O.OBJECT_NAME LIKE 'PR_SCM_DNM%'
        OR O.OBJECT_NAME LIKE 'SCM_DNM_STOCK%')
 ORDER BY O.OBJECT_NAME;
