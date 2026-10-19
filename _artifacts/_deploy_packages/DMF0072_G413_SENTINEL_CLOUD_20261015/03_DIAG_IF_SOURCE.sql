-- =====================================================================================
-- 03_DIAG_IF_SOURCE.sql  클라우드 PR_DM_CUST_MODEL_MAPPING_IF 원문 확인 (조회 전용, 전체 F5 안전)
-- 01_APPLY 에서 대상 라인 0건(ORA-20413) → 클라우드 원문이 사내(LAST_DDL 10-09)와 다름.
-- 결과 2개(객체 정보 / 전체 원문)를 그대로 복사해 회신해 주세요. 그 원문 기준으로 _IF 전용 패치를 만듭니다.
-- =====================================================================================
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') AS LAST_DDL,
       (SELECT COUNT(*) FROM ALL_SOURCE S WHERE S.OWNER='SCM_MGR' AND S.NAME=O.OBJECT_NAME AND S.TYPE=O.OBJECT_TYPE) AS LINE_CNT
  FROM ALL_OBJECTS O
 WHERE O.OWNER = 'SCM_MGR' AND O.OBJECT_NAME = 'PR_DM_CUST_MODEL_MAPPING_IF';

SELECT LINE, RTRIM(TEXT, CHR(10)) AS TEXT
  FROM ALL_SOURCE
 WHERE OWNER = 'SCM_MGR' AND NAME = 'PR_DM_CUST_MODEL_MAPPING_IF' AND TYPE = 'PROCEDURE'
 ORDER BY LINE;
