-- SOURCE-FRESH: SCM_MGR.DMF0043_GET_CONT_VIEW_VERSIONPOPUP PROCEDURE LAST_DDL=2026-09-11 16:56:52 FETCHED=2026-09-15 18:50 DB=ZIOUI1
-- STEP 1 BACKUP (원복용 원문 · STATUS=VALID)
SET DEFINE OFF
CREATE OR REPLACE PROCEDURE SCM_MGR."DMF0043_GET_CONT_VIEW_VERSIONPOPUP" 
(
    p_start_yyyymmdd  VARCHAR2,
    p_end_yyyymmdd    VARCHAR2,
	--p_created_by	   VARCHAR2,
	p_division_id	   VARCHAR2,
	p_version_type	   VARCHAR2,
	--p_version_no	   VARCHAR2,
	p_description	   VARCHAR2
    , p_user_id VARCHAR2
    , p_menu_id VARCHAR2
    , O_RC1  OUT  SYS_REFCURSOR
)
/***************************************************************************************************
 Program ID  : DMF0043_GET_CONT_VIEW_VERSIONPOPUP
 Description : Procedure 작성 가이드
 Usage       : Procedure 작성 시 참조하세요!
 Parameter   :

-- -----------------------------------------------------------------------------------------------
 Date	     In Charge	  Description
-- -----------------------------------------------------------------------------------------------
 2019/08/19  JYE       Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 2020/01/28  P.C.I     [CSR ID:prepare] Report Plan List 조회로 변경
 2020/06/12  HWI1993	[C20200605-000077] GSCM 해외법인 기여율 매출 버전 리스트 정리 요청의 건
 2021/07/03	HWI1993		하반기과제 속도개선 - 데이터 이동보관 처리
**************************************************************************************************/
AS
    v_in_para_data VARCHAR2(4000);
    V_LOG_TYPE	  VARCHAR2(20) := NULL;
    N_LOG_COUNT   NUMBER := 0;
    V_LOG_MESSAGE VARCHAR2(4000 CHAR) := NULL;
    V_DESCRIPTION VARCHAR2(4000 CHAR) := NULL;
    D_EVENT_DATE  DATE := SYSDATE;
    V_PROC_INPUT  CLOB := NULL;
    V_SQL_CODE	  VARCHAR2(100) := NULL;
    V_SQL_ERRMSG  VARCHAR2(4000 CHAR) := NULL;
    V_BACKTRACE   VARCHAR2(4000 CHAR) := NULL;
BEGIN

    v_in_para_data := JSON_OBJECT(
	    'p_start_yyyymmdd' VALUE p_start_yyyymmdd,
	    'p_end_yyyymmdd' VALUE p_end_yyyymmdd,
	    /*'p_created_by' VALUE p_created_by,*/
	    'p_division_id' VALUE p_division_id,
	    'p_version_type' VALUE p_version_type,
	    /*'p_version_no' VALUE p_version_no,*/
	    'p_description' VALUE p_description
	  );

	/*
	   OPEN O_RC1 FOR
	   SELECT VERSION_NO AS CODE, VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, VER_CRE_SEQ, YYYYMMDD, MAX(CREATED_BY), MAX(CREATION_DATE)
		 FROM DM_MST_VERSION
	   WHERE (YYYYMMDD >= p_start_yyyymmdd and YYYYMMDD <= p_end_yyyymmdd)
		  AND DIVISION_ID IN (SELECT token FROM TABLE(fn_string_split(p_division_id	,',')))
		  AND VERSION_TYPE IN (SELECT token FROM TABLE(fn_string_split(p_version_type	,',')))
		  AND Exists (Select * from TABLE(fn_string_split(p_version_no,',')) P Where VERSION_NO LIKE P.token ||'%')
	   GROUP BY VERSION_NO , VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, VER_CRE_SEQ, YYYYMMDD
	   ORDER BY CODE DESC, VERSION_NO DESC*/
		OPEN O_RC1 FOR
		SELECT VERSION_NO AS CODE, VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, VER_CRE_SEQ, YYYYMMDD, MAX(CREATED_BY), MAX(CREATION_DATE)
		     , tei.EDIT_YN
		FROM DM_MDF_VERSION A
		INNER JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(p_user_id, p_menu_id)) tei
		   ON tei.UNIT_ID = A.DIVISION_ID
		WHERE
			A.DIVISION_ID = p_division_id
			AND A.YYYYMMDD BETWEEN p_start_yyyymmdd AND p_end_yyyymmdd
			AND A.VERSION_TYPE = p_version_type
			AND UPPER(A.VERSION_DESCRIPTION) LIKE '%'  ||  UPPER(p_description)  ||  '%'
			AND A.SEND_YN <> 'D'
			AND NVL(A.ATTRIBUTE1, NULL) <> 'MOVE'
	   GROUP BY VERSION_NO , VERSION_NO, A.VERSION_DESCRIPTION, A.VERSION_TYPE, A.VER_CRE_SEQ, A.YYYYMMDD, tei.EDIT_YN
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
