/*=============================================================================================
 * File         : 99_verify_compile.sql
 * Description  : To-be_v2_converted 적재 후 컴파일 결과 검증 (SCM_MGR 접속)
 * Run as       : SCM_MGR / !SCMroqkf2026 @ FREEPDB1
 *
 * 실행 방법    :
 *   docker exec -i nscm-oracle sqlplus -L SCM_MGR/'!SCMroqkf2026'@//localhost:1521/FREEPDB1 \
 *     @/artifacts/99_verify_compile.sql
 *
 * 기대 결과 (이번 페이즈 합의된 한계):
 *   - 대부분 DM 도메인 PKG/PROC = VALID
 *   - Admin/Menu/SSO 테이블 의존 PKG (PKG_NSCM_UI_COM_USER, PKG_NSCM_UI_COM_MENU 등) = INVALID
 *     → As-Is 변환 안 된 SCM_ADM_*, SCM_MST_SSO_USER_INFO 테이블 부재 때문
 *===========================================================================================*/

SET ECHO ON
SET PAGESIZE 200
SET LINESIZE 200
SET SERVEROUTPUT ON SIZE UNLIMITED

PROMPT === 1) 객체 종류별 상태 카운트 ===
COLUMN object_type FORMAT A20
COLUMN status      FORMAT A10
SELECT object_type, status, COUNT(*) AS cnt
  FROM user_objects
 GROUP BY object_type, status
 ORDER BY object_type, status;

PROMPT === 2) INVALID 객체 목록 (Admin 의존 PKG 가 다수 예상) ===
COLUMN object_name FORMAT A40
SELECT object_name, object_type, status, last_ddl_time
  FROM user_objects
 WHERE status = 'INVALID'
 ORDER BY object_type, object_name;

PROMPT === 3) user_errors — 컴파일 오류 상위 200건 (Admin 의존성 외 진짜 오류 식별용) ===
COLUMN name FORMAT A40
COLUMN type FORMAT A20
COLUMN text FORMAT A100
SELECT name, type, line, position, text
  FROM user_errors
 ORDER BY type, name, sequence
 FETCH FIRST 200 ROWS ONLY;

PROMPT === 4) Admin 의존 PKG 식별 (이번 페이즈에서 INVALID 허용 대상) ===
SELECT object_name, status FROM user_objects
 WHERE object_type IN ('PACKAGE','PACKAGE BODY')
   AND object_name IN (
       'PKG_NSCM_UI_COM_USER',
       'PKG_NSCM_UI_COM_MENU',
       'PKG_NSCM_UI_COM_AUTH',
       'PKG_SCM0000',
       'PKG_SCM_USER_MNU'
   )
 ORDER BY object_name, object_type;

PROMPT === 5) 종합 요약 (PASS/EXPECTED-INVALID/UNEXPECTED-INVALID) ===
WITH stats AS (
    SELECT
        SUM(CASE WHEN status = 'VALID'   THEN 1 ELSE 0 END) AS valid_cnt,
        SUM(CASE WHEN status = 'INVALID' THEN 1 ELSE 0 END) AS invalid_cnt
      FROM user_objects
)
SELECT 'TOTAL VALID'   AS metric, TO_CHAR(valid_cnt)   AS value FROM stats
UNION ALL
SELECT 'TOTAL INVALID', TO_CHAR(invalid_cnt)             FROM stats
UNION ALL
SELECT 'NOTE',          'INVALID PKGs depending on SCM_ADM_*/SSO tables are EXPECTED' FROM dual;

PROMPT === DONE: 99_verify_compile.sql ===
EXIT
