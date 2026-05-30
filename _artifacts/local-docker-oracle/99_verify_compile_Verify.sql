-- ============================================================================================
-- File         : 99_verify_compile_Verify.sql
-- Description  : DBeaver Verify — 단일 SELECT (UNION ALL). 적재 직후 한눈 점검.
-- Connection   : SCM_MGR @ FREEPDB1
-- ============================================================================================

SELECT 'tables (incl. GTT) count'  AS check_name,
       TO_CHAR(COUNT(*))            AS value
  FROM user_objects WHERE object_type = 'TABLE'
UNION ALL
SELECT 'views count',
       TO_CHAR(COUNT(*))            FROM user_objects WHERE object_type = 'VIEW'
UNION ALL
SELECT 'packages count',
       TO_CHAR(COUNT(*))            FROM user_objects WHERE object_type = 'PACKAGE'
UNION ALL
SELECT 'package bodies count',
       TO_CHAR(COUNT(*))            FROM user_objects WHERE object_type = 'PACKAGE BODY'
UNION ALL
SELECT 'procedures count',
       TO_CHAR(COUNT(*))            FROM user_objects WHERE object_type = 'PROCEDURE'
UNION ALL
SELECT 'functions count',
       TO_CHAR(COUNT(*))            FROM user_objects WHERE object_type = 'FUNCTION'
UNION ALL
SELECT 'sequences count',
       TO_CHAR(COUNT(*))            FROM user_objects WHERE object_type = 'SEQUENCE'
UNION ALL
SELECT 'TOTAL VALID',
       TO_CHAR(COUNT(*))            FROM user_objects WHERE status = 'VALID'
UNION ALL
SELECT 'TOTAL INVALID (expected: PKGs depending on SCM_ADM_*)',
       TO_CHAR(COUNT(*))            FROM user_objects WHERE status = 'INVALID'
ORDER BY 1
