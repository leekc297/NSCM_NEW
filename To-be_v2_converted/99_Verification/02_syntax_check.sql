/*=============================================================================================
 * File         : 02_syntax_check.sql
 * Description  : 변환 후 Syntax / Status 검증
 *              : 모든 객체 컴파일 후 INVALID 상태 확인
 * Author       : 마리소프트 이규철
 * Created      : 2026-05-13
 *
 * 실행 방법    : SQL*Plus에서 01_compile_order.sql 실행 후 본 파일 실행
 *===========================================================================================*/

SET LINESIZE 200
SET PAGESIZE 1000
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT ========================================================
PROMPT  1. 모든 객체 상태 요약
PROMPT ========================================================

SELECT object_type,
       SUM(CASE WHEN status = 'VALID'   THEN 1 ELSE 0 END) AS valid_cnt,
       SUM(CASE WHEN status = 'INVALID' THEN 1 ELSE 0 END) AS invalid_cnt,
       COUNT(*) AS total
FROM   user_objects
WHERE  object_type IN (
    'TABLE','VIEW','INDEX','SEQUENCE','SYNONYM','TYPE','TYPE BODY',
    'PACKAGE','PACKAGE BODY','PROCEDURE','FUNCTION'
)
GROUP BY object_type
ORDER BY object_type;

PROMPT ========================================================
PROMPT  2. INVALID 객체 목록
PROMPT ========================================================

SELECT object_type,
       object_name,
       status,
       created,
       last_ddl_time
FROM   user_objects
WHERE  status = 'INVALID'
ORDER BY object_type, object_name;

PROMPT ========================================================
PROMPT  3. 컴파일 에러 상세 (최대 100건)
PROMPT ========================================================

SELECT type,
       name,
       sequence,
       line,
       position,
       SUBSTR(text, 1, 150) AS error_text
FROM   user_errors
ORDER BY type, name, sequence
FETCH FIRST 100 ROWS ONLY;

PROMPT ========================================================
PROMPT  4. Foundation Layer 객체 검증
PROMPT ========================================================

SELECT object_type, object_name, status
FROM   user_objects
WHERE  (object_name LIKE 'T\_%' ESCAPE '\'
        OR object_name LIKE 'STP\_T\_%' ESCAPE '\'
        OR object_name LIKE 'FN\_%' ESCAPE '\'
        OR object_name LIKE 'PR\_%LOG\_BATCH' ESCAPE '\'
        OR object_name IN ('SCM_SYS_LOG','DM_SYS_LOG','SEQ_SCM_SYS_LOG','SEQ_DM_SYS_LOG'))
ORDER BY object_type, object_name;

PROMPT ========================================================
PROMPT  5. Package + Procedure 상태
PROMPT ========================================================

SELECT object_type, object_name, status
FROM   user_objects
WHERE  object_type IN ('PACKAGE','PACKAGE BODY','PROCEDURE','FUNCTION')
ORDER BY object_type, object_name;

PROMPT ========================================================
PROMPT  6. GTT 카운트 (그룹별)
PROMPT ========================================================

SELECT CASE
           WHEN object_name LIKE 'GT_DMF%'    THEN 'GT_DMF_*'
           WHEN object_name LIKE 'GT_DM%'     THEN 'GT_DM_*'
           WHEN object_name LIKE 'GT_SCM%'    THEN 'GT_SCM_*'
           WHEN object_name LIKE 'GT_LEGACY%' THEN 'GT_LEGACY_*'
           WHEN object_name LIKE 'GT_%'       THEN 'GT_*'
           WHEN object_name LIKE 'GTT_%'      THEN 'GTT_* (구식, 잔존 시 위반)'
           ELSE 'OTHER'
       END AS group_pattern,
       COUNT(*) AS cnt
FROM   user_objects
WHERE  object_type = 'TABLE'
  AND  EXISTS (SELECT 1 FROM user_tables ut
               WHERE  ut.table_name = user_objects.object_name
                 AND  ut.temporary = 'Y')
GROUP BY CASE
             WHEN object_name LIKE 'GT_DMF%'    THEN 'GT_DMF_*'
             WHEN object_name LIKE 'GT_DM%'     THEN 'GT_DM_*'
             WHEN object_name LIKE 'GT_SCM%'    THEN 'GT_SCM_*'
             WHEN object_name LIKE 'GT_LEGACY%' THEN 'GT_LEGACY_*'
             WHEN object_name LIKE 'GT_%'       THEN 'GT_*'
             WHEN object_name LIKE 'GTT_%'      THEN 'GTT_* (구식, 잔존 시 위반)'
             ELSE 'OTHER'
         END
ORDER BY group_pattern;

PROMPT ========================================================
PROMPT  7. INVALID 객체 자동 재컴파일 시도
PROMPT ========================================================

BEGIN
    FOR rec IN (SELECT object_type, object_name
                FROM   user_objects
                WHERE  status = 'INVALID'
                ORDER BY object_type, object_name) LOOP
        BEGIN
            IF rec.object_type = 'PACKAGE BODY' THEN
                EXECUTE IMMEDIATE 'ALTER PACKAGE "' || rec.object_name || '" COMPILE BODY';
            ELSE
                EXECUTE IMMEDIATE 'ALTER ' || rec.object_type || ' "' || rec.object_name || '" COMPILE';
            END IF;
            DBMS_OUTPUT.PUT_LINE('재컴파일 OK: ' || rec.object_type || ' ' || rec.object_name);
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('재컴파일 실패: ' || rec.object_type || ' ' || rec.object_name || ' — ' || SQLERRM);
        END;
    END LOOP;
END;
/

PROMPT ========================================================
PROMPT  8. 재컴파일 후 잔여 INVALID 객체
PROMPT ========================================================

SELECT object_type, object_name
FROM   user_objects
WHERE  status = 'INVALID'
ORDER BY object_type, object_name;
