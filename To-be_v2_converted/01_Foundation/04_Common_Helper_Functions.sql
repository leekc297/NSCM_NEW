/*=============================================================================================
 * File         : 04_Common_Helper_Functions.sql
 * Description  : MSSQL → Oracle 변환 — 공통 헬퍼 함수
 *              : MSSQL의 자주 쓰이는 패턴을 Oracle 함수로 표준화
 * Author       : 마리소프트 이규철
 * Created      : 2026-05-13
 *
 * 실행 순서   : Foundation 네번째 (TYPE + 로그 SP 이후)
 * 실행 계정   : SCM_MGR
 *
 * Program History
 *=============================================================================================
 *   Date         In Charge      Description
 *=============================================================================================
 * 2026-05-13     이규철          최초 작성
 *===========================================================================================*/

-- =============================================================================================
-- 1. FN_SPLIT_STR / FN_STRING_SPLIT — 문자열을 구분자 기준으로 분리 (PIPELINED)
--    용도: MSSQL STRING_SPLIT 대체
--    두 가지 사용 패턴 모두 지원:
--      (a) SELECT column_value FROM TABLE(FN_SPLIT_STR('A,B,C', ','));   -- T_STR_TAB 반환
--      (b) SELECT token FROM TABLE(FN_STRING_SPLIT('A,B,C', ','));        -- TOKEN 컬럼 OBJECT 반환
-- =============================================================================================

-- (a) 단순 VARCHAR2 컬렉션 반환 — TABLE(...) 호출 시 column_value 자동 매핑
CREATE OR REPLACE FUNCTION SCM_MGR.FN_SPLIT_STR
(
    p_str        IN VARCHAR2,
    p_delimiter  IN VARCHAR2 DEFAULT ','
)
/*=============================================================================================
 * Program ID   : FN_SPLIT_STR
 * Description  : 구분자로 분리된 문자열을 행으로 반환 (Pipelined)
 * Returns      : SCM_MGR.T_STR_TAB (VARCHAR2(4000 CHAR) 컬렉션 → COLUMN_VALUE)
 *===========================================================================================*/
RETURN SCM_MGR.T_STR_TAB PIPELINED
IS
BEGIN
    IF p_str IS NULL THEN
        RETURN;
    END IF;

    FOR r IN (
        SELECT TRIM(REGEXP_SUBSTR(p_str, '[^' || p_delimiter || ']+', 1, LEVEL)) AS token
        FROM   dual
        CONNECT BY REGEXP_SUBSTR(p_str, '[^' || p_delimiter || ']+', 1, LEVEL) IS NOT NULL
    ) LOOP
        IF r.token IS NOT NULL THEN
            PIPE ROW (r.token);
        END IF;
    END LOOP;

    RETURN;
END FN_SPLIT_STR;
/

-- (b) OBJECT 컬렉션 반환 — TABLE(...) 호출 시 TOKEN 컬럼명으로 접근 가능 (사내 표준)
CREATE OR REPLACE FUNCTION SCM_MGR.FN_STRING_SPLIT
(
    p_str        IN VARCHAR2,
    p_delimiter  IN VARCHAR2 DEFAULT ','
)
/*=============================================================================================
 * Program ID   : FN_STRING_SPLIT
 * Description  : 구분자로 분리된 문자열을 STP_T_TOKEN_OBJ(TOKEN) 컬렉션으로 반환 (Pipelined)
 *              : 사내 표준 명명 — SELECT token FROM TABLE(FN_STRING_SPLIT(...)) 형태로 사용
 * Returns      : SCM_MGR.STP_T_TOKEN (STP_T_TOKEN_OBJ 컬렉션, TOKEN 컬럼 보유)
 *===========================================================================================*/
RETURN SCM_MGR.STP_T_TOKEN PIPELINED
IS
BEGIN
    IF p_str IS NULL THEN
        RETURN;
    END IF;

    FOR r IN (
        SELECT TRIM(REGEXP_SUBSTR(p_str, '[^' || p_delimiter || ']+', 1, LEVEL)) AS token
        FROM   dual
        CONNECT BY REGEXP_SUBSTR(p_str, '[^' || p_delimiter || ']+', 1, LEVEL) IS NOT NULL
    ) LOOP
        IF r.token IS NOT NULL THEN
            PIPE ROW (SCM_MGR.STP_T_TOKEN_OBJ(r.token));
        END IF;
    END LOOP;

    RETURN;
END FN_STRING_SPLIT;
/

-- =============================================================================================
-- 2. FN_ISNUMERIC — MSSQL ISNUMERIC() 대체
--    Returns NUMBER(1): 1 = numeric, 0 = not
-- =============================================================================================
CREATE OR REPLACE FUNCTION SCM_MGR.FN_ISNUMERIC
(
    p_str IN VARCHAR2
)
/*=============================================================================================
 * Program ID   : FN_ISNUMERIC
 * Description  : 문자열의 숫자 여부 검사 (MSSQL ISNUMERIC 대체)
 *===========================================================================================*/
RETURN NUMBER
IS
BEGIN
    IF p_str IS NULL THEN
        RETURN 0;
    END IF;

    IF REGEXP_LIKE(p_str, '^-?[0-9]+(\.[0-9]+)?$') THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
END FN_ISNUMERIC;
/

-- =============================================================================================
-- 3. FN_ISDATE — MSSQL ISDATE() 대체
--    Returns NUMBER(1): 1 = valid date, 0 = invalid
-- =============================================================================================
CREATE OR REPLACE FUNCTION SCM_MGR.FN_ISDATE
(
    p_str    IN VARCHAR2,
    p_format IN VARCHAR2 DEFAULT 'YYYYMMDD'
)
/*=============================================================================================
 * Program ID   : FN_ISDATE
 * Description  : 문자열의 유효 날짜 여부 검사 (MSSQL ISDATE 대체)
 *===========================================================================================*/
RETURN NUMBER
IS
    v_date DATE;
BEGIN
    IF p_str IS NULL THEN
        RETURN 0;
    END IF;

    v_date := TO_DATE(p_str, p_format);
    RETURN 1;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;
END FN_ISDATE;
/

-- =============================================================================================
-- 4. FN_NVL_NUM — 빈 문자열·null 모두 0으로 (MSSQL ISNULL(col, 0) 대체)
-- =============================================================================================
CREATE OR REPLACE FUNCTION SCM_MGR.FN_NVL_NUM
(
    p_value   IN VARCHAR2,
    p_default IN NUMBER DEFAULT 0
)
/*=============================================================================================
 * Program ID   : FN_NVL_NUM
 * Description  : NULL/빈문자/숫자아님 모두 default로 치환
 *===========================================================================================*/
RETURN NUMBER
IS
BEGIN
    IF p_value IS NULL OR TRIM(p_value) IS NULL THEN
        RETURN p_default;
    END IF;
    IF NOT REGEXP_LIKE(p_value, '^-?[0-9]+(\.[0-9]+)?$') THEN
        RETURN p_default;
    END IF;
    RETURN TO_NUMBER(p_value);
EXCEPTION
    WHEN OTHERS THEN
        RETURN p_default;
END FN_NVL_NUM;
/

-- =============================================================================================
-- 5. FN_YYYYMMDD_TO_DATE — 'YYYYMMDD' 문자열 → DATE 안전 변환
-- =============================================================================================
CREATE OR REPLACE FUNCTION SCM_MGR.FN_YYYYMMDD_TO_DATE
(
    p_yyyymmdd IN VARCHAR2
)
/*=============================================================================================
 * Program ID   : FN_YYYYMMDD_TO_DATE
 * Description  : 'YYYYMMDD' 8자리 문자열을 DATE로 변환. 잘못된 형식은 NULL 반환
 *===========================================================================================*/
RETURN DATE
IS
BEGIN
    IF p_yyyymmdd IS NULL OR LENGTH(p_yyyymmdd) <> 8 THEN
        RETURN NULL;
    END IF;
    RETURN TO_DATE(p_yyyymmdd, 'YYYYMMDD');
EXCEPTION
    WHEN OTHERS THEN
        RETURN NULL;
END FN_YYYYMMDD_TO_DATE;
/

-- =============================================================================================
-- 6. FN_ZERO_LPAD — As-Is 호환 (실은 LPAD(s, n, '0')와 동일하지만 레거시 호환용)
--    @deprecated: 신규 코드는 LPAD(s, n, '0') 직접 사용 권장
-- =============================================================================================
CREATE OR REPLACE FUNCTION SCM_MGR.FN_ZERO_LPAD
(
    p_str    IN VARCHAR2,
    p_length IN NUMBER
)
/*=============================================================================================
 * Program ID   : FN_ZERO_LPAD
 * Description  : As-Is 호환용 — 신규 코드는 LPAD(s, n, '0') 직접 사용 권장
 *===========================================================================================*/
RETURN VARCHAR2
IS
BEGIN
    IF p_str IS NULL THEN
        RETURN NULL;
    END IF;
    RETURN LPAD(p_str, p_length, '0');
END FN_ZERO_LPAD;
/

-- =============================================================================================
-- 권한 부여 및 Synonym
-- =============================================================================================
GRANT EXECUTE ON SCM_MGR.FN_SPLIT_STR          TO SCMD_APP;
GRANT EXECUTE ON SCM_MGR.FN_SPLIT_STR          TO RL_SCM_DML;
GRANT EXECUTE ON SCM_MGR.FN_STRING_SPLIT       TO SCMD_APP;
GRANT EXECUTE ON SCM_MGR.FN_STRING_SPLIT       TO RL_SCM_DML;
GRANT EXECUTE ON SCM_MGR.FN_ISNUMERIC          TO SCMD_APP;
GRANT EXECUTE ON SCM_MGR.FN_ISNUMERIC          TO RL_SCM_DML;
GRANT EXECUTE ON SCM_MGR.FN_ISDATE             TO SCMD_APP;
GRANT EXECUTE ON SCM_MGR.FN_ISDATE             TO RL_SCM_DML;
GRANT EXECUTE ON SCM_MGR.FN_NVL_NUM            TO SCMD_APP;
GRANT EXECUTE ON SCM_MGR.FN_NVL_NUM            TO RL_SCM_DML;
GRANT EXECUTE ON SCM_MGR.FN_YYYYMMDD_TO_DATE   TO SCMD_APP;
GRANT EXECUTE ON SCM_MGR.FN_YYYYMMDD_TO_DATE   TO RL_SCM_DML;
GRANT EXECUTE ON SCM_MGR.FN_ZERO_LPAD          TO SCMD_APP;
GRANT EXECUTE ON SCM_MGR.FN_ZERO_LPAD          TO RL_SCM_DML;

CREATE OR REPLACE PUBLIC SYNONYM FN_SPLIT_STR          FOR SCM_MGR.FN_SPLIT_STR;
CREATE OR REPLACE PUBLIC SYNONYM FN_STRING_SPLIT       FOR SCM_MGR.FN_STRING_SPLIT;
CREATE OR REPLACE PUBLIC SYNONYM fn_string_split       FOR SCM_MGR.FN_STRING_SPLIT;
CREATE OR REPLACE PUBLIC SYNONYM FN_ISNUMERIC          FOR SCM_MGR.FN_ISNUMERIC;
CREATE OR REPLACE PUBLIC SYNONYM FN_ISDATE             FOR SCM_MGR.FN_ISDATE;
CREATE OR REPLACE PUBLIC SYNONYM FN_NVL_NUM            FOR SCM_MGR.FN_NVL_NUM;
CREATE OR REPLACE PUBLIC SYNONYM FN_YYYYMMDD_TO_DATE   FOR SCM_MGR.FN_YYYYMMDD_TO_DATE;
CREATE OR REPLACE PUBLIC SYNONYM FN_ZERO_LPAD          FOR SCM_MGR.FN_ZERO_LPAD;

-- =============================================================================================
-- 검증 쿼리
-- =============================================================================================
-- SELECT * FROM TABLE(SCM_MGR.FN_SPLIT_STR('A,B,C,D', ','));   -- 4 rows
-- SELECT SCM_MGR.FN_ISNUMERIC('123.45') FROM dual;             -- 1
-- SELECT SCM_MGR.FN_ISNUMERIC('ABC')    FROM dual;             -- 0
-- SELECT SCM_MGR.FN_ISDATE('20260513')  FROM dual;             -- 1
-- SELECT SCM_MGR.FN_ISDATE('20260230')  FROM dual;             -- 0
-- SELECT SCM_MGR.FN_NVL_NUM('', 99)     FROM dual;             -- 99
-- SELECT SCM_MGR.FN_YYYYMMDD_TO_DATE('20260513') FROM dual;
-- SELECT SCM_MGR.FN_ZERO_LPAD('123', 5) FROM dual;             -- 00123
