-- ============================================================================================
-- File         : 99_verify_compile_DBeaver.sql
-- Description  : DBeaver 호환판. SCM_MGR 로 FREEPDB1 접속 후 각 SELECT 개별 Ctrl+Enter 실행.
-- Connection   : SCM_MGR / !SCMroqkf2026 @ jdbc:oracle:thin:@//localhost:1521/FREEPDB1
-- ============================================================================================

-- 1) 객체 종류별 상태 카운트
SELECT object_type, status, COUNT(*) AS cnt
  FROM user_objects
 GROUP BY object_type, status
 ORDER BY object_type, status;

-- 2) INVALID 객체 목록
SELECT object_name, object_type, status, last_ddl_time
  FROM user_objects
 WHERE status = 'INVALID'
 ORDER BY object_type, object_name;

-- 3) user_errors — 컴파일 오류 상위 200건
SELECT name, type, line, position, text
  FROM user_errors
 ORDER BY type, name, sequence
 FETCH FIRST 200 ROWS ONLY;

-- 4) Admin 의존 PKG 식별
SELECT object_name, object_type, status
  FROM user_objects
 WHERE object_type IN ('PACKAGE','PACKAGE BODY')
   AND object_name IN (
       'PKG_NSCM_UI_COM_USER',
       'PKG_NSCM_UI_COM_MENU',
       'PKG_NSCM_UI_COM_AUTH',
       'PKG_SCM0000',
       'PKG_SCM_USER_MNU'
   )
 ORDER BY object_name, object_type;
