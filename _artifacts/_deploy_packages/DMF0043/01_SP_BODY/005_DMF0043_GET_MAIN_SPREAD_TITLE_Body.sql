--==============================================================================
-- 005_DMF0043_GET_MAIN_SPREAD_TITLE_Body.sql
--
-- 목적: caller (DMF0043_GET_CONTRIBUTE_MAIN_DATA) 가 호출하는 핵심 종속 SP body.
--       110_65 (010_DMF0043_main_SP_bodies.sql) 의 9 SP 안에 포함되어 있지 않음.
--       fresh cloud 적용 시 본 SP body 가 먼저 컴파일되어야 015/018/020 patch 가능.
--
-- 본 SP 의 처리:
--   - SCM_MST_SHEET_COLUMNS 의 PROGRAM_ID=DMF0043 / SHEET_NAME=ContributeMain 컬럼 22+1개 SELECT
--   - O_RC1 : default 22 컬럼 titleset (사용자 커스텀 없는 경우)
--   - O_RC2 : 사용자 SAM 매핑 컬럼 (있는 경우)
--   - O_RC3 : 다른 cursor용
--
-- 출처: To-be_v2_converted/07_Standalone_SP/_archive_duplicate_in_PKG/05_Standalone_SP_DMF0043.sql line 256-480
-- 후속 patch 적용 (실행 순서):
--   015_22Col_Fallback         : v_user_col_cnt=0 분기 fallback 보강
--   018_EditYnColRemove        : 23번째 EDIT_YN 컬럼 제거 (caller 22-var fetch 정합)
--   020_OpenRC1_RootFix        : default 분기 OPEN O_RC3 → OPEN O_RC1
--   030_OpenRC1_RegexpFix      : 020 fail 시 fallback (whitespace-safe)
--
-- 작성: 2026-06-04
-- 실행: SCM_MGR 세션. SQL*Plus / DBeaver 호환
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON

PROMPT === BLOCK 1 : DMF0043_GET_MAIN_SPREAD_TITLE 본체 컴파일 (raw, OpenRC3 상태) ===

-- DMF0043_GET_MAIN_SPREAD_TITLE → PKG_DMF0043.P_DMF0043_GET_MAIN_SPREAD_TITLE에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0043_GET_MAIN_SPREAD_TITLE
(
    p_division_id		VARCHAR2,
	p_yyyy				VARCHAR2,
	p_created_by		VARCHAR2
    , p_user_id VARCHAR2
    , p_menu_id VARCHAR2
    , O_RC1  OUT  SYS_REFCURSOR
    , O_RC2  OUT  SYS_REFCURSOR
    , O_RC3  OUT  SYS_REFCURSOR
)
/****************************************************************************************************/
/* Program ID  : DMF0043_GET_SPREAD_TITLE                                                             */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2019/06/20     JYE		기여율 해더                    */
/****************************************************************************************************/
AS

    v_program_id VARCHAR2(4000 CHAR) := 'DMF0043';
    v_sheet_name VARCHAR2(4000 CHAR) := 'ContributeMain';
    V_CODEList VARCHAR2(1000 CHAR) := NULL;
    V_NAMEList VARCHAR2(1000 CHAR) := NULL;
    v_nsql VARCHAR2(4000 CHAR) := NULL;
    v_i INTEGER := 0;
    v_user_col_cnt INTEGER := 0;
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
            'p_division_id' VALUE p_division_id,
            'p_yyyy' VALUE p_yyyy,
            'p_created_by' VALUE p_created_by
          );

	/* TODO:GTT:GT_GMST_TEMP_2-->GT_GMST_TEMP_2 */
	INSERT INTO GT_GMST_TEMP_2
	SELECT
		L.SEGMENT1  AS CODE
		, L.SEGMENT2 NAME
		, DISPLAY_SEQ DISPLAY_SEQ
	FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
	WHERE  1 = 1
	AND    L.LOOKUP_TYPE = 'DM_OS_CORP_CD'
	AND    L.VALID_YN    = 'Y'
	AND    L.SEGMENT4 = ''
	ORDER BY DISPLAY_SEQ;

	--INSERT INTO GT_GMST_TEMP_2 VALUES ('RBU_0099', '구분', 99)
	/* TODO:GTT:GT_GMST_TEMP2_2-->GT_GMST_TEMP2_2 */
	INSERT INTO GT_GMST_TEMP2_2
	SELECT -- 연도만
		p_yyyy ||  '  ' AS YYYYMM, 'Y' AS FLAG, CODE, NAME, DISPLAY_SEQ
	FROM GT_GMST_TEMP_2;

	--ORDER BY DISPLAY_SEQ;
	WHILE (v_i < 12) LOOP
		v_i := v_i + 1;
		IF (LENGTH(TO_CHAR(v_i)) >= 2) THEN
			INSERT INTO GT_GMST_TEMP2_2
			--SELECT p_yyyy || '-' || CAST(v_i AS VARCHAR) YYYYMM, 'M' AS FLAG, CODE, NAME, DISPLAY_SEQ
			SELECT p_yyyy  ||  TO_CHAR(v_i) YYYYMM, 'M' AS FLAG, CODE, NAME, DISPLAY_SEQ
			FROM GT_GMST_TEMP_2;
		ELSE
			INSERT INTO GT_GMST_TEMP2_2
			SELECT p_yyyy  ||  '0'  ||  TO_CHAR(v_i) YYYYMM, 'M' AS FLAG, CODE, NAME, DISPLAY_SEQ
			FROM GT_GMST_TEMP_2;
		END IF;
	END LOOP;

	-- ############### OS_CORP 반복 end ###############
	SELECT COUNT(*)
  INTO v_user_col_cnt
	FROM   SCM_MST_TITLESET_USER U
	WHERE  1 = 1
	AND    U.PROGRAM_ID = v_program_id
    AND    U.SHEET_NAME = v_sheet_name
    AND    U.USER_ID    = p_created_by;

	--select v_user_col_cnt
	IF v_user_col_cnt = 0 THEN
		OPEN O_RC3 FOR
		SELECT C.PROGRAM_ID
				, C.SHEET_NAME
				, C.COLUMN_NAME
				, C.COLUMN_LABEL_NAME
				, C.SORT_ORDER_NO
				, C.DATA_SORT_METHOD_CODE
				, C.SMALL_CLASS_LABEL_NAME
				, C.LARGE_CLASS_LABEL_NAME
				, '' AS DAY_CODE
				, C.FIXED_FLAG
				, C.COLUMN_WIDTH
				, C.CELL_CONTROL_OBJECT_TYPE_CODE
				, C.CELL_COMBO_DATA_TYPE
				, C.DATA_SCALE_NUMBER
				, C.DATA_MAX_LENGTH
				, C.HORIZONTAL_ALIGN_CODE
				, C.UPPERCASE_APPLY_FLAG
				, C.VISIBLE_FLAG
				, C.DEFAULT_FLAG
				, C.USER_SELECTABLE_FLAG
				, C.VALID_YN
				, C.DIVISION_ID
				, tei.EDIT_YN
		FROM   SCM_MST_SHEET_COLUMNS C
		INNER JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(p_user_id, p_menu_id)) tei
		   ON tei.UNIT_ID = C.DIVISION_ID
		WHERE  1 = 1
		AND    C.PROGRAM_ID  = v_program_id
		AND    C.SHEET_NAME  = v_sheet_name
		AND    C.DEFAULT_FLAG = 'Y'
		AND    C.VALID_YN     = 'Y'
		AND	 p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )

		UNION ALL

		SELECT C.PROGRAM_ID
				, C.SHEET_NAME
				, C.COLUMN_NAME
				, C.COLUMN_LABEL_NAME
				, C.SORT_ORDER_NO
				, C.DATA_SORT_METHOD_CODE
				, C.SMALL_CLASS_LABEL_NAME
				, C.LARGE_CLASS_LABEL_NAME
				, '' AS DAY_CODE
				, C.FIXED_FLAG
				, C.COLUMN_WIDTH
				, C.CELL_CONTROL_OBJECT_TYPE_CODE
				, C.CELL_COMBO_DATA_TYPE
				, C.DATA_SCALE_NUMBER
				, C.DATA_MAX_LENGTH
				, C.HORIZONTAL_ALIGN_CODE
				, C.UPPERCASE_APPLY_FLAG
				, C.VISIBLE_FLAG
				, C.DEFAULT_FLAG
				, C.USER_SELECTABLE_FLAG
				, C.VALID_YN
				, C.DIVISION_ID
				, '' AS EDIT_YN
		FROM   SCM_MST_SHEET_COLUMNS C
		WHERE  1 = 1
		AND    C.PROGRAM_ID  = v_program_id
		AND    C.SHEET_NAME  = v_sheet_name
		AND    C.VISIBLE_FLAG = ''
		AND    C.DEFAULT_FLAG IS NULL
		AND    C.VALID_YN     = 'Y'
		AND	 p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )

		UNION ALL

		SELECT v_program_id   AS PROGRAM_ID
					, v_sheet_name SHEET_NAME
					, T.FLAG  ||  '#'  ||  T.YYYYMM  ||  '#'  ||  CODE AS COLUMN_NAME
					, T.NAME COLUMN_LABEL_NAME
					, TO_NUMBER(DISPLAY_SEQ) SORT_ORDER_NO
					, '' AS DATA_SORT_METHOD_CODE
					--, T.YYYYMM SMALL_CLASS_LABEL_NAME
					, T.NAME SMALL_CLASS_LABEL_NAME
					, CASE WHEN LENGTH(T.YYYYMM) = 4 THEN T.YYYYMM ELSE
						SUBSTR(T.YYYYMM, 1, 4)  ||  '-'  ||  SUBSTR(T.YYYYMM, 5, 2) END AS LARGE_CLASS_LABEL_NAME
					--, p_yyyy LARGE_CLASS_LABEL_NAME
					, '' AS DAY_CODE
					, ''         AS FIXED_FLAG
					, 80 COLUMN_WIDTH
					, '' AS CELL_CONTROL_OBJECT_TYPE_CODE
					, ''         AS CELL_COMBO_DATA_TYPE
					, 2         AS DATA_SCALE_NUMBER
					, NULL         AS DATA_MAX_LENGTH
					, 'R'        AS HORIZONTAL_ALIGN_CODE
					, 'Y'        AS UPPERCASE_APPLY_FLAG
					, 'Y'        AS VISIBLE_FLAG
					, ''         AS DEFAULT_FLAG
					, ''         AS USER_SELECTABLE_FLAG
					, ''         AS VALID_YN
					, ''			AS DIVISION_ID
					, '' AS EDIT_YN
			FROM  (
				SELECT
					REPLACE(YYYYMM, ' ', '') YYYYMM, FLAG, CODE, NAME,
					TO_CHAR(REPLACE(REPLACE(YYYYMM, ' ', ''), '-', ''))  ||  TO_CHAR(DISPLAY_SEQ) DISPLAY_SEQ
				FROM GT_GMST_TEMP2_2
			) T
			ORDER BY SORT_ORDER_NO  ;
	END IF;

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


PROMPT === BLOCK 2 : 컴파일 STATUS 확인 ===
SELECT object_name, object_type, status, TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') AS last_ddl
  FROM user_objects
 WHERE object_name = 'DMF0043_GET_MAIN_SPREAD_TITLE';

PROMPT === BLOCK 3 : INVALID 시 컴파일 오류 ===
SELECT line, position, text
  FROM user_errors
 WHERE name = 'DMF0043_GET_MAIN_SPREAD_TITLE'
   AND type = 'PROCEDURE'
 ORDER BY sequence;

PROMPT === 다음 단계: 010 (main SP 9개) → 015 (22Col fallback) → 018 (EditYnColRemove) → 020/030 (OpenRC1 patch) ===
