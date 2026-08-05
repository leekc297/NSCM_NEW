-- =============================================================================
-- C4_PKG_SYS0014.sql — 클라우드 추출 원문 (2026-07-29, DBMS_METADATA.GET_DDL)
-- 원천: 클라우드 Oracle SCM_MGR (SPEC+BODY 모두 VALID) — 02_EXTRACT_DDL_sqlplus.sql 산출
-- ⚠️ CREATE 문 본문 무수정 원칙 — 아래 헤더 주석 외 1바이트 변경 금지
-- 사내 적용 순서: SPEC → BODY → SCMD_APP GRANT EXECUTE + SYNONYM → VALID 확인
-- =============================================================================

  CREATE OR REPLACE EDITIONABLE PACKAGE "SCM_MGR"."PKG_SYS0014"
AS
	PROCEDURE P_SYS0014_GET_DIVISION_DATA (
		P_TEXT     IN      VARCHAR2
	    , O_CURSOR        OUT SYS_REFCURSOR
    	, O_RESULT_CURSOR OUT SYS_REFCURSOR
	);
END PKG_SYS0014;
/

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SCM_MGR"."PKG_SYS0014"
AS
	PROCEDURE P_SYS0014_GET_DIVISION_DATA (
		P_TEXT     IN      VARCHAR2
	    , O_CURSOR        OUT SYS_REFCURSOR
    	, O_RESULT_CURSOR OUT SYS_REFCURSOR
	) IS

/*
 * Program ID   : P_SYS0014_GET_DIVISION_DATA
 * Description  : P_SYS0014_GET_DIVISION_DATA
 */

	BEGIN
    OPEN O_CURSOR FOR
	    SELECT DIVISION_ID AS CODE, DIVISION_NAME AS NAME
	    FROM SCM_MST_DIVISION
	    WHERE VALID_YN = 'Y'
	    AND (
	    	P_TEXT IS NULL
	    	OR
	    	DIVISION_ID LIKE '%' || P_TEXT || '%'
	    	OR
	    	DIVISION_NAME LIKE '%' || P_TEXT || '%'
	    )
	    ORDER BY DIVISION_ID;

    OPEN O_RESULT_CURSOR FOR
      SELECT '0' AS CODE, 'SUCCESS' AS MSG, '0' AS EVENT FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || TO_CHAR(SQLCODE) ||
            ' / SQLERRM=' || SQLERRM ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || '-' );

	END P_SYS0014_GET_DIVISION_DATA;
END PKG_SYS0014;
/
