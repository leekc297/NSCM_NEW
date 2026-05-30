-- ============================================================================================
-- File         : 99_verify_compile_Diagnose.sql
-- Description  : DBeaver Diagnose — INVALID 객체 원인 추적용
-- Connection   : SCM_MGR @ FREEPDB1
-- ============================================================================================

-- 1) 특정 INVALID PKG 의 컴파일 오류 텍스트
-- (object_name 자리에 분석할 PKG 이름을 넣고 Ctrl+Enter)
SELECT line, position, attribute, text
  FROM user_errors
 WHERE name = 'PKG_NSCM_UI_COM_USER'
 ORDER BY sequence;

-- 2) 특정 PKG 가 참조하는 테이블/객체 (REFERENCED_NAME = SCM_ADM_USER_M 같은 게 부재일 것)
SELECT referenced_owner, referenced_type, referenced_name, dependency_type
  FROM user_dependencies
 WHERE name = 'PKG_NSCM_UI_COM_USER'
 ORDER BY referenced_type, referenced_name;

-- 3) PKG 가 참조하는 테이블 중 실제로 존재하지 않는 것 (Admin 미적재 확인)
SELECT DISTINCT d.referenced_name AS missing_table
  FROM user_dependencies d
 WHERE d.name = 'PKG_NSCM_UI_COM_USER'
   AND d.referenced_type = 'TABLE'
   AND NOT EXISTS (
       SELECT 1 FROM user_tables t WHERE t.table_name = d.referenced_name
   );

-- 4) 강제 재컴파일 시도 (실패해도 INVALID 가 남는 객체가 진짜 오류)
-- BEGIN DBMS_UTILITY.COMPILE_SCHEMA(schema => 'SCM_MGR', compile_all => FALSE); END;

-- 5) 가장 많은 INVALID 객체를 만들어내는 referenced_name TOP 20 (부재 의존성)
SELECT referenced_name AS missing_obj, COUNT(DISTINCT name) AS dependent_invalid_cnt
  FROM user_dependencies
 WHERE name IN (SELECT object_name FROM user_objects WHERE status = 'INVALID')
   AND referenced_owner IN ('SCM_MGR','PUBLIC')
   AND NOT EXISTS (
       SELECT 1 FROM user_objects o
        WHERE o.object_name = user_dependencies.referenced_name
   )
 GROUP BY referenced_name
 ORDER BY dependent_invalid_cnt DESC
 FETCH FIRST 20 ROWS ONLY;
