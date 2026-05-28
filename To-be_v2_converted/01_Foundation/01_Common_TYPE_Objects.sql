/*=============================================================================================
 * File         : 01_Common_TYPE_Objects.sql
 * Description  : MSSQL → Oracle 변환 — 공통 TYPE 객체 (Foundation Layer)
 *              : 모든 SP/PKG가 의존하는 기본 TYPE
 * Author       : 마리소프트 이규철
 * Created      : 2026-05-13
 * Source Rule  : Doc/_analysis/db_migration/01_MSSQL_to_Oracle_Conversion_Rules.md §10.1
 *
 * 실행 순서   : 최우선 (다른 모든 객체 생성 이전)
 * 실행 계정   : SCM_MGR (Object Owner)
 *
 * Program History
 *=============================================================================================
 *   Date         In Charge      Description
 *=============================================================================================
 * 2026-05-13     이규철          최초 작성 — MSSQL_프로시저_전환가이드.xlsx §케이스 7,9 반영
 *===========================================================================================*/

-- =============================================================================================
-- 1. 문자열 테이블 TYPE — VARCHAR2 컬렉션 (BULK COLLECT, IN-LIST 대체용)
--    용도: STRING_SPLIT 결과 저장, 콤마 구분 토큰 컬렉션
-- =============================================================================================
CREATE OR REPLACE TYPE SCM_MGR.T_STR_TAB
AS TABLE OF VARCHAR2(4000 CHAR);
/

-- =============================================================================================
-- 2. 숫자 테이블 TYPE — NUMBER 컬렉션
-- =============================================================================================
CREATE OR REPLACE TYPE SCM_MGR.T_NUM_TAB
AS TABLE OF NUMBER;
/

-- =============================================================================================
-- 3. 날짜 테이블 TYPE — DATE 컬렉션
-- =============================================================================================
CREATE OR REPLACE TYPE SCM_MGR.T_DATE_TAB
AS TABLE OF DATE;
/

-- =============================================================================================
-- 4. 년월일 테이블 TYPE — VARCHAR2(8 CHAR) 'YYYYMMDD' 형식
--    용도: 날짜 키 목록 (YYYYMMDD 문자열 형태)
-- =============================================================================================
CREATE OR REPLACE TYPE SCM_MGR.T_YYYYMMDD_TAB
AS TABLE OF VARCHAR2(8 CHAR);
/

-- =============================================================================================
-- 5. 년월 테이블 TYPE — VARCHAR2(6 CHAR) 'YYYYMM' 형식
-- =============================================================================================
CREATE OR REPLACE TYPE SCM_MGR.T_YYYYMM_TAB
AS TABLE OF VARCHAR2(6 CHAR);
/

-- =============================================================================================
-- 6. 토큰 객체 TYPE — BULK COLLECT INTO 용
--    용도: STRING_SPLIT 결과를 OBJECT 컬렉션으로 저장 (TABLE 함수 변환 대체)
-- =============================================================================================
CREATE OR REPLACE TYPE SCM_MGR.STP_T_TOKEN_OBJ
AS OBJECT (
    TOKEN VARCHAR2(4000 CHAR)
);
/

CREATE OR REPLACE TYPE SCM_MGR.STP_T_TOKEN
AS TABLE OF SCM_MGR.STP_T_TOKEN_OBJ;
/

-- =============================================================================================
-- 7. 키-값 쌍 TYPE — 키워드 인자 전달용
-- =============================================================================================
CREATE OR REPLACE TYPE SCM_MGR.T_KEY_VALUE_OBJ
AS OBJECT (
    KEY_NM  VARCHAR2(200 CHAR),
    VALUE_TXT VARCHAR2(4000 CHAR)
);
/

CREATE OR REPLACE TYPE SCM_MGR.T_KEY_VALUE_TAB
AS TABLE OF SCM_MGR.T_KEY_VALUE_OBJ;
/

-- =============================================================================================
-- 권한 부여 (AP 계정 + Role)
-- =============================================================================================
GRANT EXECUTE ON SCM_MGR.T_STR_TAB         TO SCMD_APP;
GRANT EXECUTE ON SCM_MGR.T_NUM_TAB         TO SCMD_APP;
GRANT EXECUTE ON SCM_MGR.T_DATE_TAB        TO SCMD_APP;
GRANT EXECUTE ON SCM_MGR.T_YYYYMMDD_TAB    TO SCMD_APP;
GRANT EXECUTE ON SCM_MGR.T_YYYYMM_TAB      TO SCMD_APP;
GRANT EXECUTE ON SCM_MGR.STP_T_TOKEN_OBJ   TO SCMD_APP;
GRANT EXECUTE ON SCM_MGR.STP_T_TOKEN       TO SCMD_APP;
GRANT EXECUTE ON SCM_MGR.T_KEY_VALUE_OBJ   TO SCMD_APP;
GRANT EXECUTE ON SCM_MGR.T_KEY_VALUE_TAB   TO SCMD_APP;

GRANT EXECUTE ON SCM_MGR.T_STR_TAB         TO RL_SCM_DML;
GRANT EXECUTE ON SCM_MGR.T_NUM_TAB         TO RL_SCM_DML;
GRANT EXECUTE ON SCM_MGR.T_DATE_TAB        TO RL_SCM_DML;
GRANT EXECUTE ON SCM_MGR.T_YYYYMMDD_TAB    TO RL_SCM_DML;
GRANT EXECUTE ON SCM_MGR.T_YYYYMM_TAB      TO RL_SCM_DML;
GRANT EXECUTE ON SCM_MGR.STP_T_TOKEN_OBJ   TO RL_SCM_DML;
GRANT EXECUTE ON SCM_MGR.STP_T_TOKEN       TO RL_SCM_DML;

-- =============================================================================================
-- Public Synonym (Optional — SCMD_APP에서 SCM_MGR. prefix 없이 접근)
-- =============================================================================================
CREATE OR REPLACE PUBLIC SYNONYM T_STR_TAB         FOR SCM_MGR.T_STR_TAB;
CREATE OR REPLACE PUBLIC SYNONYM T_NUM_TAB         FOR SCM_MGR.T_NUM_TAB;
CREATE OR REPLACE PUBLIC SYNONYM T_DATE_TAB        FOR SCM_MGR.T_DATE_TAB;
CREATE OR REPLACE PUBLIC SYNONYM T_YYYYMMDD_TAB    FOR SCM_MGR.T_YYYYMMDD_TAB;
CREATE OR REPLACE PUBLIC SYNONYM T_YYYYMM_TAB      FOR SCM_MGR.T_YYYYMM_TAB;
CREATE OR REPLACE PUBLIC SYNONYM STP_T_TOKEN_OBJ   FOR SCM_MGR.STP_T_TOKEN_OBJ;
CREATE OR REPLACE PUBLIC SYNONYM STP_T_TOKEN       FOR SCM_MGR.STP_T_TOKEN;
CREATE OR REPLACE PUBLIC SYNONYM T_KEY_VALUE_OBJ   FOR SCM_MGR.T_KEY_VALUE_OBJ;
CREATE OR REPLACE PUBLIC SYNONYM T_KEY_VALUE_TAB   FOR SCM_MGR.T_KEY_VALUE_TAB;

-- =============================================================================================
-- 검증 쿼리 (실행 후 결과 확인용)
-- =============================================================================================
-- SELECT type_name, typecode FROM all_types WHERE owner = 'SCM_MGR' ORDER BY type_name;
