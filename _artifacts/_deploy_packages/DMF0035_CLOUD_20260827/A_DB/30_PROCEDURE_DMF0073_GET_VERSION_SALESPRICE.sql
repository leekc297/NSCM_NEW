-- 30_PROCEDURE_DMF0073_GET_VERSION_SALESPRICE.sql — API_M 배선 standalone PROCEDURE (VALID, LAST_DDL 2026-07-21 16:39) — 클라우드 부재/구판이면 적용
-- 의존: ['TABLE:DM_MST_VERSION', 'TABLE:SCM_SYS_CALENDAR_M', 'TABLE:SCP_PLN_INTERFACE_YN', 'FUNCTION:FN_STRING_SPLIT', 'PROCEDURE:PR_SCM_SYS_LOG_BATCH', 'PACKAGE:PKG_SCM_USER_MNU']
CREATE OR REPLACE PROCEDURE           "DMF0073_GET_VERSION_SALESPRICE"
(
    p_start_yyyymmdd  VARCHAR2,
    p_end_yyyymmdd    VARCHAR2,
	p_created_by	   VARCHAR2,
	p_division_id	   VARCHAR2,
	p_version_type	   VARCHAR2,
	p_description	   VARCHAR2

	-- DMF0073_GET_VERSION_SALESPRICE(p_start_yyyymmdd DEFAULT '20240401', p_end_yyyymmdd DEFAULT '20240601', p_created_by DEFAULT '20140001', p_division_id DEFAULT '82', p_version_type DEFAULT 'SP_W', p_description DEFAULT '');

    , p_user_id VARCHAR2
    , p_menu_id VARCHAR2
    , O_RC1  OUT  SYS_REFCURSOR
)
/************************************************************************************************
 Program ID  : DMF0073_GET_VERSION_SALESPRICE
 Description : Procedure 작성 가이드
 Usage       : Procedure 작성 시 참조하세요!
 Parameter   :

-- ----------------------------------------------------------------------------------------------
 Date        In Charge    Description
-- ----------------------------------------------------------------------------------------------
 2024/05/13  KJJ       신규생성
 * 2025.01.01	P.C.I			PJ20228272 NERP 대응. No Plan 날짜 Start_date를 ISO_YYYYWW 기준으로 변경
 * 2026/03/15	김준규	[PJ20264226] NextSCM Pilot 설계 및 개발

******************************************************************************************************/
AS
    v_in_para_data VARCHAR2(4000);
    V_LOG_TYPE    VARCHAR2(20) := NULL;
    N_LOG_COUNT   NUMBER := 0;
    V_LOG_MESSAGE VARCHAR2(4000 CHAR) := NULL;
    V_DESCRIPTION VARCHAR2(4000 CHAR) := NULL;
    D_EVENT_DATE  DATE := SYSDATE;
    V_PROC_INPUT  CLOB := NULL;
    V_SQL_CODE    VARCHAR2(100) := NULL;
    V_SQL_ERRMSG  VARCHAR2(4000 CHAR) := NULL;
    V_BACKTRACE   VARCHAR2(4000 CHAR) := NULL;
BEGIN

    v_in_para_data := JSON_OBJECT(
            'p_start_yyyymmdd' VALUE p_start_yyyymmdd,
            'p_end_yyyymmdd' VALUE p_end_yyyymmdd,
            'p_created_by' VALUE p_created_by,
            'p_division_id' VALUE p_division_id,
            'p_version_type' VALUE p_version_type,
            'p_description' VALUE p_description,
            'p_start_yyyymmdd' VALUE p_start_yyyymmdd,
            'p_end_yyyymmdd' VALUE p_end_yyyymmdd,
            'p_created_by' VALUE p_created_by,
            'p_division_id' VALUE p_division_id,
            'p_version_type' VALUE p_version_type,
            'P_W' VALUE p_version_type,
            'p_description' VALUE p_description
          );

	OPEN O_RC1 FOR
	SELECT 'SP_Z_CURRENT' AS CODE, 'Current' AS VERSION_NO, 'Current' VERSION_DESCRIPTION, TO_CHAR(NULL) VERSION_TYPE
			, TO_CHAR(NULL) EDI_APPLY, TO_NUMBER(NULL) VER_CRE_SEQ, TO_CHAR(NULL) YYYYMMDD, TO_CHAR(NULL) CREATED_BY, SYSDATE CREATION_DATE
			, TO_CHAR(NULL) MONTHLY_ROLLING_FCST , 'N' EDITABLE
			, 'N' AS EDIT_YN
	FROM DUAL
	UNION ALL
	SELECT VERSION_NO AS CODE
		, CASE WHEN C.DM_RTF_YN = 'N'
				THEN (VERSION_NO || '(' || B.WEEK_NAME || ') (NO PLAN)')
				ELSE (VERSION_NO || '(' || B.WEEK_NAME || ')')
				END AS VERSION_NO
		, VERSION_DESCRIPTION, VERSION_TYPE
		, (CASE WHEN VERSION_TYPE = 'ME_S' THEN 'Y'
					ELSE 'N' END) EDI_APPLY
		, VER_CRE_SEQ, YYYYMMDD, MAX(CREATED_BY), MAX(CREATION_DATE)
		, NVL(A.ATTRIBUTE7, 'N') MONTHLY_ROLLING_FCST
		, CASE WHEN B.ISO_WEEK = TO_NUMBER(TO_CHAR(SYSDATE, 'IW')) THEN 'Y' ELSE 'N' END EDITABLE --현재 주차만 수정가능
		, tei.EDIT_YN
		FROM DM_MST_VERSION A
	INNER JOIN SCM_SYS_CALENDAR_M B
		ON A.YYYYMMDD = B.BASIS_YYYYMMDD
	INNER JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(p_user_id, p_menu_id)) tei
		ON tei.UNIT_ID = A.DIVISION_ID
	LEFT JOIN SCP_PLN_INTERFACE_YN C
		ON A.DIVISION_ID = C.DIVISION_ID
		--AND B.BASIS_START_DATE = C.PLAN_START_YYYYMMDD --PJ20228272 NERP 대응. No Plan 날짜 Start_date를 ISO_YYYYWW 기준으로 변경
		AND ( SELECT MIN(BASIS_YYYYMMDD) FROM SCM_SYS_CALENDAR_M  WHERE  ISO_YYYYWW = B.ISO_YYYYWW) = C.PLAN_START_YYYYMMDD
	WHERE (YYYYMMDD >= p_start_yyyymmdd and YYYYMMDD <= p_end_yyyymmdd)
		AND A.DIVISION_ID IN (SELECT token FROM TABLE(fn_string_split(p_division_id	,',')))
		AND VERSION_TYPE IN (SELECT token FROM TABLE(fn_string_split(p_version_type	,',')))
		--AND Exists (Select * from TABLE(fn_string_split(p_version_no,',')) P Where VERSION_NO LIKE P.token ||'%')
		AND VERSION_DESCRIPTION LIKE '%'  ||  p_description  ||  '%'
		AND NVL(ATTRIBUTE1, '-') <> 'MOVE'
	GROUP BY VERSION_NO , VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, VER_CRE_SEQ, YYYYMMDD, B.WEEK_NAME, C.DM_RTF_YN,NVL(A.ATTRIBUTE7, 'N'), B.ISO_WEEK, tei.EDIT_YN
	ORDER BY CODE DESC, VERSION_NO DESC;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE   := 'ERROR';
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT,
                            V_LOG_TYPE,
                            N_LOG_COUNT,
                            V_LOG_MESSAGE,
                            V_DESCRIPTION,
                            D_EVENT_DATE,
                            V_PROC_INPUT,
                            V_SQL_CODE,
                            V_SQL_ERRMSG,
                            V_BACKTRACE
                            );
    RAISE_APPLICATION_ERROR(-20001,
        '[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE ||
        ' / SQLERRM=' || SQLERRM ||
        ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
        ' / PARAMS=' || v_in_para_data
    );
END;
/
