/*=============================================================================================
 * File         : 010_Object_Status_Verify.sql
 * Description  : DMF0003 SP/PKG 객체 컴파일 상태 검증
 *              :   - archive standalone 8 SP + PKG_DMF0003 22 procedures = 30 SP
 *              :   - 모두 STATUS='VALID' 이어야 정상
 *===========================================================================================*/

SELECT OBJECT_NAME, OBJECT_TYPE, STATUS, LAST_DDL_TIME
FROM ALL_OBJECTS
WHERE OWNER = 'SCM_MGR'
  AND (
      OBJECT_NAME LIKE 'DMF0003%'
      OR OBJECT_NAME = 'PKG_DMF0003'
  )
ORDER BY OBJECT_TYPE, OBJECT_NAME;

-- INVALID 발견 시 컴파일 오류 조회
SELECT NAME, TYPE, LINE, POSITION, TEXT
FROM USER_ERRORS
WHERE NAME LIKE 'DMF0003%' OR NAME = 'PKG_DMF0003'
ORDER BY NAME, SEQUENCE;
