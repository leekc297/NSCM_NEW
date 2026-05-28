/*=============================================================================================
 * File         : 05_Standalone_SP_DMF0035.sql
 * Description  : Standalone Procedures — DMF0035 화면 (2개)
 *              : 향후 PKG_DMF0035로 통합 권장 (사내 표준 §6 UI별 패키지 그룹화)
 * Author       : 마리소프트 이규철
 * Created      : 2026-05-13
 *
 * 실행 순서   : 07_Standalone_SP 단계
 * 실행 계정   : SCM_MGR
 *===========================================================================================*/


CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0035_GET_MKT_FCST_WATERFALL
(
      p_division_id			VARCHAR2
	, p_dept_id				VARCHAR2
    , p_end_customer			VARCHAR2
	, p_scm_site_id			VARCHAR2
    , p_project_code			VARCHAR2
	, p_item_id				VARCHAR2
	, p_item_type				VARCHAR2
	, p_from_yyyymmdd			VARCHAR2
	, p_to_yyyymmdd			VARCHAR2
	, p_created_by				VARCHAR2
	, p_plant_site_id			VARCHAR2
	, p_biz_type				VARCHAR2
	, p_owner					VARCHAR2
    , p_version_no				VARCHAR2
	, p_bucket					VARCHAR2	-- 20211103 MKT FCST WATERFALL 속도 개선
	, p_user_dept_id			VARCHAR2	-- JV Planner 일때 USER 부서정보로 SALES SITE ID 정보를 얻기 위해추가
	, p_group_id				VARCHAR2	-- JV Planner 일지 확인하기 위해 추가
	, p_cell_yn				VARCHAR2
	, p_sender_code			VARCHAR2	-- SENDER_CODE 추가

)
AS

/*
 * ========================================
 * [변환검증] 2026-03-02 20:37:20
 * 파일: dbo.DMF0035_GET_MKT_FCST_WATERFALL.sql
 * ----------------------------------------
 * ⚠ IF: IF:28  END IF:27  차이:+1
 * ⚠ BEGIN: BEGIN:9  END:8  차이:+1
 * ----------------------------------------
 * BEGIN 위치: L59, L582, L598, L677, L710, L742, L775, L838, L896, L906 ...
 * END;  위치: L591, L668, L699, L764, L904, L991, L1065, L1071, L1090, L1123 ...
 * ----------------------------------------
 * 힌트: END가 3개 더 많음 → 고아 END; 확인 필요
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */


    V_ColList VARCHAR2(4000 CHAR);
    V_OrderList VARCHAR2(4000 CHAR);
    v_nsql VARCHAR2(4000 CHAR);
    v_nsql2 VARCHAR2(4000 CHAR);
    p_program_id VARCHAR2(50) := 'DMF0035';
    p_sheet_name VARCHAR2(50) := 'MKT FCST Waterfall';
    V_MEASURE INTEGER := 0;
    i_count INTEGER := 0;
    v_user_mea_cnt INTEGER := 0;
    v_start_yyyymmdd VARCHAR2(8 CHAR);
    v_sql_text VARCHAR2(4000 CHAR);
    V_PV_LIST VARCHAR2(4000 CHAR);
    V_PV_COL_LIST VARCHAR2(4000 CHAR);
    V_PV_COL VARCHAR2(4000 CHAR);
    v_column_name VARCHAR2(100 CHAR);
    v_column VARCHAR2(1000 CHAR);
    v_orderby VARCHAR2(1000 CHAR);
    v_column_text VARCHAR2(1000 CHAR);
    v_PV_column_name VARCHAR2(100 CHAR);
    v_PV_NAME VARCHAR2(50 CHAR);
    v_column_type VARCHAR2(50 CHAR);
    v_column_value VARCHAR2(50 CHAR);
    v_sort_order_no VARCHAR2(50 CHAR);
    V_SQL_SELECT VARCHAR2(4000 CHAR);
    V_SQL_GROUPBY VARCHAR2(4000 CHAR);
    V_ORDER VARCHAR2(4000 CHAR) := NULL;
    v_cnt_1  INTEGER := 0;
    v_cnt_2  INTEGER := 0;
    v_cnt_3  INTEGER := 0;
    v_cnt_4  INTEGER := 0;
    v_cnt_5  INTEGER := 0;
    v_cnt_6  INTEGER := 0;
    v_cnt_7  INTEGER := 0;
BEGIN
 --       p_division_id VARCHAR2(30 CHAR) := '82';;
 --       p_dept_id VARCHAR2(4000 CHAR) := 'ALL';;
 --       p_end_customer VARCHAR2(4000 CHAR) := 'ALL';;
 --       p_scm_site_id VARCHAR2(4000 CHAR) := 'ALL';;
 --       p_project_code VARCHAR2(4000 CHAR) := '';;
 --       p_item_id VARCHAR2(4000 CHAR) := '';;
 --       p_item_type VARCHAR2(4000 CHAR) := 'ALL';;
 --   --    p_from_yyyymmdd VARCHAR2(8 CHAR) := '20220516';;
 --   --    p_to_yyyymmdd VARCHAR2(8 CHAR) := '20220522';;
 --       p_from_yyyymmdd VARCHAR2(8 CHAR) := '20220516';;
 --       p_to_yyyymmdd VARCHAR2(8 CHAR) := '20220522';;
 --       p_created_by VARCHAR2(4000 CHAR) := 'iamarock';;
 --       p_plant_site_id VARCHAR2(4000 CHAR) := 'ALL';;
 --       p_biz_type VARCHAR2(4000 CHAR) := 'ALL';;
 --       p_owner VARCHAR2(4000 CHAR) := '';;
 --   --    p_version_no VARCHAR2(4000 CHAR) := 'MF_W_20220517_V001';;
 --       p_version_no VARCHAR2(4000 CHAR) := 'CURRENT';;
 --       p_user_dept_id VARCHAR2(50 CHAR) := 'ICO';;
 --       p_group_id VARCHAR2(50 CHAR) := 'ADMIN';;
	--    p_bucket VARCHAR2(10 CHAR) := 'WEEK';;

		--			    V_Prod VARCHAR2(4000 CHAR);






	    v_now_yyyymmdd NCHAR(8);


DBMS_OUTPUT.PUT_LINE(p_program_id  ||  ' : A001-- :'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3') );

	V_NOW_YYYYMMDD := TO_CHAR(FN_NEXT_DAY( SYSDATE, 'MON') + (-7), 'YYYYMMDD');
	V_ColList := NULL;
	V_OrderList := NULL;
	V_Prod := NULL;
	--=================================================================================================================
	-- 20200316 KHSONG C20200224-000109 (START)
	--=================================================================================================================

	-- 20200316 KHSONG C20200224-000109 (END)
	--=================================================================================================================

	--=================================================================================================================
	-- 20200306 KHSONG 조회시작기간이 START DATE가 아닌경우 PRICE값을 가져오지 못하여 변수추가사용
	--=================================================================================================================

	SELECT BASIS_START_DATE INTO v_start_yyyymmdd FROM SCM_SYS_CALENDAR_M  WHERE BASIS_YYYYMMDD = p_from_yyyymmdd;

	--=================================================================================================================
	-- Temp Table 존재 여부 체크 (START)
	--=================================================================================================================
	-- ----------------------------------------------------------------------------------------------------------------
	--[E20231017-000634] (START)
	-- ----------------------------------------------------------------------------------------------------------------
	-- ----------------------------------------------------------------------------------------------------------------
	--[E20231017-000634] (END)
	-- ----------------------------------------------------------------------------------------------------------------
			DROP TABLE GT_DMF0_DM_PLN_MKT_FCST;
	-- ----------------------------------------------------------------------------------------------------------------
	--[E20240920-000300]_SCM.DM 화면 조회 속도 개선 (START)
	-- ----------------------------------------------------------------------------------------------------------------
	-- ----------------------------------------------------------------------------------------------------------------
	--[E20240920-000300]_SCM.DM 화면 조회 속도 개선 (END)

	--[E20260123-001715]_소스원복으로 원요청내역 주석처리 START
	/*
	-- ----------------------------------------------------------------------------------------------------------------
	--[E20241015-000415]_MKT FCST, MKT FCST Waterfall 화면 신규 환산자 컬럼 추가 요청 건 (START)
	-- ----------------------------------------------------------------------------------------------------------------
	-- ----------------------------------------------------------------------------------------------------------------
	--[E20241015-000415]_MKT FCST, MKT FCST Waterfall 화면 신규 환산자 컬럼 추가 요청 건 (END)
	-- ----------------------------------------------------------------------------------------------------------------
	*/
	--[E20260123-001715]_소스원복으로 원요청내역 주석처리 START
	--=================================================================================================================
	-- Temp Table 존재 여부 체크 (END)
	--=================================================================================================================
DBMS_OUTPUT.PUT_LINE(p_program_id  ||  ' : A002-- :'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3') );

	--=================================================================================================================
	-- Temp Table 생성 (START)
	--=================================================================================================================

	EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_VERSION';

	EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_RAW_DATA';

	--[E20231017-000634]
	EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_RAW_DATA_FINAL';

	-- ----------------------------------------------------------------------------------------------------------------
	--[E20231017-000634] SCP 정보수집용 TABLE 생성 (START)
	-- ----------------------------------------------------------------------------------------------------------------
	EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_SCP_ITEM_INFO';
	-- ----------------------------------------------------------------------------------------------------------------
	--[E20231017-000634] SCP 정보수집용 TABLE 생성 (END)
	-- ----------------------------------------------------------------------------------------------------------------
	EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_LAST_DATA_SETUP';

	EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_LAST_DATA_SETUP_C';

	--=================================================================================================================
	-- Temp Table 생성 (END)
	--=================================================================================================================

	IF p_version_no LIKE '%MF%' OR p_version_no LIKE '%ME%' OR p_version_no LIKE '%SF%' THEN
		INSERT INTO GT_DMF0_VERSION ( VERSION_NO, VERSION_NO_W, NOW_YYYYMMDD )
		SELECT A.TOKEN
			 , CASE WHEN D.DM_RTF_YN = ''
			        THEN (A.TOKEN || '(' || C.WEEK_NAME || ') (NO PLAN)')
					ELSE (A.TOKEN || '(' || C.WEEK_NAME || ')') END
			 , TO_CHAR(FN_NEXT_DAY( B.YYYYMMDD, 'MON') + (-7), 'YYYYMMDD')
		FROM (SELECT  SUBSTR(token, 1, CASE WHEN INSTR(token, '(') = 0 THEN LENGTH(token) ELSE INSTR(token, '(')-1 END) AS  TOKEN
		FROM TABLE(fn_string_split(p_version_no ,',')))  AS A
		JOIN DM_MST_VERSION B  ON A.TOKEN = B.VERSION_NO AND B.DIVISION_ID = p_division_id
		INNER JOIN SCM_SYS_CALENDAR_M C  ON B.YYYYMMDD = C.BASIS_YYYYMMDD
		LEFT JOIN SCP_PLN_INTERFACE_YN D
			   ON B.DIVISION_ID			= D.DIVISION_ID
			  AND C.BASIS_START_DATE	= D.PLAN_START_YYYYMMDD;
	END IF;

	-- ---------------------------------------------------------------------------------------
	-- 20190326 오류개선 STUFF시 정렬오류로 멀티OWNER가 분리되는 오류발생으로 TEMP사용 (END)
	-- ---------------------------------------------------------------------------------------
DBMS_OUTPUT.PUT_LINE(p_program_id  ||  ' : A003-- :'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3') );

/* 미래 구간에 대해서는 SITE-ITEM에 있는것만 포함되어야 함. ( ETC 포함 )
   과거 구간은 전체 Data가 포함되어야 함.
   단가는 조회조건에 있는 key 기준으로 포함이 되어야 함. 단가는 Weekly로 되어 있기 때문에 Daily로 변경되어야 함.
   단위 환산이 되어야 함.*/

	--=================================================================================================================
	-- 20200316 KHSONG C20200224-000109 (START)
	--=================================================================================================================
	SELECT COUNT(*)
  INTO v_user_mea_cnt
	FROM SCM_MST_TITLESET_USER U
	WHERE  1 = 1
	AND    U.PROGRAM_ID						= p_program_id
	AND    U.SHEET_NAME						= p_sheet_name
	AND    U.USER_INQUIRY_COLUMN_TYPE_CODE	= 'M'
	AND    U.USER_ID						= p_created_by;

	IF v_user_mea_cnt = 0 THEN
		INSERT INTO SCM_MST_TITLESET_USER
		( USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE, COLUMN_NAME
		, SORT_ORDER_NO, SUB_TOTAL_FLAG, DATA_SORT_METHOD_CODE, CREATED_BY, CREATION_DATE
		, LAST_UPDATED_BY, LAST_UPDATE_DATE	)
		SELECT p_created_by, C.PROGRAM_ID, C.SHEET_NAME, 'M', C.COLUMN_NAME
			  , C.SORT_ORDER_NO, '', '', p_created_by, TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3')
			  , p_created_by, TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3')
		FROM   SCM_MST_SHEET_MEASURE C
		WHERE  1 = 1
		AND    C.PROGRAM_ID		= p_program_id
		AND    C.SHEET_NAME		= p_sheet_name
		AND    C.DEFAULT_FLAG	= 'Y'
		AND    C.VALID_YN		= 'Y';
	END IF;

	--=================================================================================================================
	-- [E20250807-001418]_사업부와 사용여부에 따라서 데이터를 가지고 올수있도록 수정 START
	-- SCM_FCST은 40 사업부만 사용하나, 하단에서 생성하는 경우에 사업부에서 진행하게 되면서, 모든 사업부에 메져가 노출됨.
	--=================================================================================================================
	-- 원소스 주석처리함
	/*
	-- ----------------------------------------------------------------------
	-- 20200316 KHSONG C20200224-000109 (END)
	-- ----------------------------------------------------------------------
	/* TODO:GTT:GT_DMF0_SELECT_MEASURE-->GT_DMF0_SELECT_MEASURE */
	INSERT INTO GT_DMF0_SELECT_MEASURE
	SELECT DISTINCT
		NVL(U.PROGRAM_ID, 'DMF0035') AS PROGRAM_ID
		,U.SHEET_NAME
		,U.USER_ID
		,CASE  WHEN U.COLUMN_NAME IN ( 'CUST_INV_I','CUST_PRODUCT_S','CUST_WHIN_P','CUST_DIO'  )  THEN 'CUST. PSI'
				WHEN U.COLUMN_NAME IN ( 'MKT_INV_I' ,'MKT_PRODUCT_S' ,'MKT_WHIN_P' ,'MKT_DIO'   )  THEN 'MKT PSI'
				ELSE U.COLUMN_NAME
			END AS MEASURE_GROUP
		,U.COLUMN_NAME AS MEASURE
		, CASE WHEN U.COLUMN_NAME IN ( 'CUST_FCST','CUST_FCST_EDI','CUST_FCST_ORG','CUST_FCST_EDI_ORG' )  THEN SMSM.SORT_ORDER_NO  -- 20231212 kcw3408 4_고객수요 Measure 통합
				ELSE U.SORT_ORDER_NO END AS SORT_ORDER_NO
		,'' AS SYSTEM_ADD
	FROM SCM_MST_TITLESET_USER U
			JOIN SCM_MST_SHEET_MEASURE SMSM
		    ON U.PROGRAM_ID = SMSM.PROGRAM_ID
			AND U.SHEET_NAME = SMSM.SHEET_NAME
			AND U.COLUMN_NAME = SMSM.COLUMN_NAME
			AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
			AND SMSM.VALID_YN     = 'Y'
	LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL T  ON (U.USER_ID = T.SEGMENT4)  -- 20200309 KHSONG TMM MEASURE 권한추가
				AND p_created_by	= T.SEGMENT4  -- USER_ID
				AND T.LOOKUP_TYPE	= 'TMM_MEASURE_ADMIN'
				AND T.VALID_YN		= 'Y'       -- VALID_YN 여부
	WHERE 1 = 1
	AND U.USER_INQUIRY_COLUMN_TYPE_CODE	= 'M'
	AND U.PROGRAM_ID						= 'DMF0035'
	AND U.SHEET_NAME						= 'Mkt Fcst Waterfall'
	AND U.USER_ID						= p_created_by
	and U.USER_ID = CASE WHEN U.COLUMN_NAME = 'TMM_FCST' THEN T.SEGMENT4 ELSE p_created_by	END;
	*/

	-- USER TITLE 정보와 MEASURE MASTER 정보를 JOIN하여 사업부별 정보를 보관한다.
	/* TODO:GTT:GT_DMF0_SELECT_MEASURE-->GT_DMF0_SELECT_MEASURE */
	INSERT INTO GT_DMF0_SELECT_MEASURE
	SELECT DISTINCT NVL(U.PROGRAM_ID, 'DMF0035') AS PROGRAM_ID, U.SHEET_NAME, U.USER_ID
		 , CASE WHEN U.COLUMN_NAME IN ( 'CUST_INV_I','CUST_PRODUCT_S','CUST_WHIN_P','CUST_DIO'  )  THEN 'CUST. PSI'
				WHEN U.COLUMN_NAME IN ( 'MKT_INV_I' ,'MKT_PRODUCT_S' ,'MKT_WHIN_P' ,'MKT_DIO'   )  THEN 'MKT PSI'
				ELSE U.COLUMN_NAME
			END AS MEASURE_GROUP
		, U.COLUMN_NAME AS MEASURE
		, CASE WHEN U.COLUMN_NAME IN ( 'CUST_FCST','CUST_FCST_EDI','CUST_FCST_ORG','CUST_FCST_EDI_ORG' )  THEN SMSM.SORT_ORDER_NO  -- 20231212 kcw3408 4_고객수요 Measure 통합
				ELSE U.SORT_ORDER_NO END AS SORT_ORDER_NO
		, '' AS SYSTEM_ADD
	FROM (	SELECT A.PROGRAM_ID, A.USER_ID, A.COLUMN_NAME, A.SORT_ORDER_NO, A.SYSTEM_ADD, A.USER_INQUIRY_COLUMN_TYPE_CODE, A.SHEET_NAME, TOKEN AS DIVISION_ID
			FROM (	SELECT U.PROGRAM_ID, U.USER_ID, U.COLUMN_NAME, U.SORT_ORDER_NO, B.DIVISION_ID, U.USER_INQUIRY_COLUMN_TYPE_CODE, U.SHEET_NAME, '' AS SYSTEM_ADD
					FROM SCM_MST_TITLESET_USER U
					INNER JOIN SCM_MST_SHEET_MEASURE B
							ON U.PROGRAM_ID		= B.PROGRAM_ID
							AND U.SHEET_NAME	= B.SHEET_NAME
							AND U.COLUMN_NAME	= B.COLUMN_NAME
					WHERE	1 = 1
					AND		U.PROGRAM_ID					= p_program_id
					AND		U.SHEET_NAME					= p_sheet_name
					AND		U.USER_INQUIRY_COLUMN_TYPE_CODE	= 'M'
					AND		U.USER_ID						= p_created_by
					AND		B.VALID_YN						= 'Y' ) A
			CROSS JOIN TABLE(fn_string_split(A.DIVISION_ID, ',' ))) U
	JOIN SCM_MST_SHEET_MEASURE SMSM
	  ON  U.PROGRAM_ID	= SMSM.PROGRAM_ID
	 AND U.SHEET_NAME	= SMSM.SHEET_NAME
	 AND U.COLUMN_NAME	= SMSM.COLUMN_NAME
	 AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
	 AND SMSM.VALID_YN	= 'Y'
	LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL T
		   ON (U.USER_ID	= T.SEGMENT4)  -- 20200309 KHSONG TMM MEASURE 권한추가
		  AND p_created_by	= T.SEGMENT4  -- USER_ID
		  AND T.LOOKUP_TYPE	= 'TMM_MEASURE_ADMIN'
		  AND T.VALID_YN	= 'Y'       -- VALID_YN 여부
	WHERE 1 = 1
	AND U.USER_INQUIRY_COLUMN_TYPE_CODE		= 'M'
	AND U.PROGRAM_ID						= p_program_id
	AND U.SHEET_NAME						= p_sheet_name
	AND U.USER_ID							= p_created_by
	AND U.USER_ID = CASE WHEN U.COLUMN_NAME = 'TMM_FCST' THEN T.SEGMENT4 ELSE p_created_by END
	AND U.DIVISION_ID = p_division_id
  	-- --------------------------------------------------------------------------------------------------------------------------------
	-- [E20250807-001418]_사업부와 사용여부에 따라서 데이터를 가지고 올수있도록 수정 END
	-- --------------------------------------------------------------------------------------------------------------------------------
		UNION ALL
		SELECT NVL(A.PROGRAM_ID, 'DMF0035') AS PROGRAM_ID
			,A.SHEET_NAME,A.USER_ID,A.MEASURE_GROUP,B.MEASURE,A.SORT_ORDER_NO  ||  B.SORT_ORDER_NO
			,'' AS SYSTEM_ADD
		FROM
				(SELECT U.PROGRAM_ID
						, U.SHEET_NAME
						, U.USER_ID
						--[E20241126-000426]_Cust.FCST(P+P) Measure 로직 수정 START
						--, 'CUST_FCST_EDI' MEASURE_GROUP  -- Ui Caterory Setup 의 Small Label 에 설정된 그룹명칭
						, 'CUST_FCST' MEASURE_GROUP  -- Ui Caterory Setup 의 Small Label 에 설정된 그룹명칭
						--[E20241126-000426]_Cust.FCST(P+P) Measure 로직 수정 END
						, SMSM.SORT_ORDER_NO            -- 20231212 kcw3408 4_고객수요 Measure 통합
					FROM SCM_MST_TITLESET_USER U  WITH(NOLOCK,INDEX (PK_SCM_MST_TITLESET_USER))
			             JOIN SCM_MST_SHEET_MEASURE SMSM
				           ON U.PROGRAM_ID = SMSM.PROGRAM_ID
			              AND U.SHEET_NAME = SMSM.SHEET_NAME
				          AND U.COLUMN_NAME = SMSM.COLUMN_NAME
				          AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
				          AND SMSM.VALID_YN     = 'Y'
					WHERE 1 = 1
					AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
					AND U.PROGRAM_ID   = 'DMF0035'
					AND U.SHEET_NAME   = 'Mkt Fcst Waterfall'
					AND U.USER_ID      = p_created_by
					--[E20241126-000426]_Cust.FCST(P+P) Measure 로직 수정 START
					--AND U.COLUMN_NAME  = 'CUST_FCST_EDI'  -- Ui Caterory Setup 의 Column_Name 에 설정된 그룹명칭
					AND U.COLUMN_NAME  = 'CUST_FCST'  -- Ui Caterory Setup 의 Column_Name 에 설정된 그룹명칭
					--[E20241126-000426]_Cust.FCST(P+P) Measure 로직 수정 END
					) A;
					,
					(
						 --[E20241126-000426]_CUST_FCST_EDI 추가 및 순서 변경 START
						 --SELECT 'Immidiate' MEASURE,0.14 AS SORT_ORDER_NO
						 SELECT 'Immidiate' MEASURE,0.15 AS SORT_ORDER_NO
						 UNION ALL
						 --SELECT 'Planning_Forecast' MEASURE,0.17 AS SORT_ORDER_NO
						 SELECT 'Planning_Forecast' MEASURE,0.18 AS SORT_ORDER_NO
						 UNION ALL
						 --SELECT 'Commercial_Agreement' MEASURE,0.12 AS SORT_ORDER_NO
						 SELECT 'Commercial_Agreement' MEASURE,0.13 AS SORT_ORDER_NO
						 UNION ALL
						 --SELECT 'Firm_Temp' MEASURE,0.13 AS SORT_ORDER_NO
						 SELECT 'Firm_Temp' MEASURE,0.14 AS SORT_ORDER_NO
						 UNION ALL
						 --SELECT 'Manumacturing_Material_Temp' MEASURE,0.15 AS SORT_ORDER_NO
						 SELECT 'Manumacturing_Material_Temp' MEASURE,0.16 AS SORT_ORDER_NO
						 UNION ALL
						 --SELECT 'Material_Temp' MEASURE,0.16 AS SORT_ORDER_NO
						 SELECT 'Material_Temp' MEASURE,0.17 AS SORT_ORDER_NO
						 UNION ALL
						 --SELECT 'Backorder' MEASURE,0.11 AS SORT_ORDER_NO
						 SELECT 'Backorder' MEASURE,0.12 AS SORT_ORDER_NO
						 UNION ALL
						 SELECT 'CUST_FCST_EDI' MEASURE,0.11 AS SORT_ORDER_NO	--[E20241126-000426]_신규 추가
						 --[E20241126-000426]_CUST_FCST_EDI 추가 및 순서 변경 END
					) B;
		WHERE 1=1
		GROUP BY A.PROGRAM_ID,A.SHEET_NAME,A.USER_ID,A.MEASURE_GROUP,B.MEASURE,A.SORT_ORDER_NO  ||  B.SORT_ORDER_NO
		--[E20241126-000426]_ORG 데이터는 더이상 보이지 않도록 하였으므로 주석처리한다. START
		/*
		UNION ALL
		SELECT NVL(A.PROGRAM_ID, 'DMF0035') AS PROGRAM_ID
			,A.SHEET_NAME,A.USER_ID,A.MEASURE_GROUP,B.MEASURE,A.SORT_ORDER_NO || B.SORT_ORDER_NO
			,'' AS SYSTEM_ADD
		FROM
				(SELECT U.PROGRAM_ID
						, U.SHEET_NAME
						, U.USER_ID
						,'CUST_FCST_EDI_ORG' MEASURE_GROUP  -- Ui Caterory Setup 의 Small Label 에 설정된 그룹명칭
						, SMSM.SORT_ORDER_NO                -- 20231212 kcw3408 4_고객수요 Measure 통합
					FROM SCM_MST_TITLESET_USER U  WITH(NOLOCK,INDEX (PK_SCM_MST_TITLESET_USER))
			             JOIN SCM_MST_SHEET_MEASURE SMSM
				           ON U.PROGRAM_ID = SMSM.PROGRAM_ID
			              AND U.SHEET_NAME = SMSM.SHEET_NAME
				          AND U.COLUMN_NAME = SMSM.COLUMN_NAME
				          AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
				          AND SMSM.VALID_YN     = 'Y'
					WHERE 1 = 1
					AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
					AND U.PROGRAM_ID   = 'DMF0035'
					AND U.SHEET_NAME   = 'Mkt Fcst Waterfall'
					AND U.USER_ID      = p_created_by
					AND U.COLUMN_NAME  = 'CUST_FCST_EDI_ORG'  -- Ui Caterory Setup 의 Column_Name 에 설정된 그룹명칭
					) A;
					,
					(
						 SELECT 'Immidiate[Org.]' MEASURE,0.14 AS SORT_ORDER_NO
						 UNION ALL
						 SELECT 'Planning_Forecast[Org.]' MEASURE,0.17 AS SORT_ORDER_NO
						 UNION ALL
						 SELECT 'Commercial_Agreement[Org.]' MEASURE,0.12 AS SORT_ORDER_NO
						 UNION ALL
						 SELECT 'Firm_Temp[Org.]' MEASURE,0.13 AS SORT_ORDER_NO
						 UNION ALL
						 SELECT 'Manumacturing_Material_Temp[Org.]' MEASURE,0.15 AS SORT_ORDER_NO
						 UNION ALL
						 SELECT 'Material_Temp[Org.]' MEASURE,0.16 AS SORT_ORDER_NO
						 UNION ALL
						 SELECT 'Backorder[Org.]' MEASURE,0.11 AS SORT_ORDER_NO
					) B;
		WHERE 1=1
		GROUP BY A.PROGRAM_ID,A.SHEET_NAME,A.USER_ID,A.MEASURE_GROUP,B.MEASURE,A.SORT_ORDER_NO || B.SORT_ORDER_NO;
		*/
		--[E20241126-000426]_ORG 데이터는 더이상 보이지 않도록 하였으므로 주석처리한다. END

		UNION ALL
		SELECT DISTINCT
			'DMF0035'					AS PROGRAM_ID
			, 'Mkt Fcst Waterfall'		AS SHEET_NAME
			, p_created_by			AS USER_ID
			, 'CUST_FCST'				AS MEASURE_GROUP
			, C.MEASURE					AS MEASURE
			, (SELECT SMSM.SORT_ORDER_NO       -- 20231212 kcw3408 4_고객수요 Measure 통합
				FROM SCM_MST_TITLESET_USER U WITH(NOLOCK,INDEX (PK_SCM_MST_TITLESET_USER))
			             JOIN SCM_MST_SHEET_MEASURE SMSM
				           ON U.PROGRAM_ID = SMSM.PROGRAM_ID
			              AND U.SHEET_NAME = SMSM.SHEET_NAME
				          AND U.COLUMN_NAME = SMSM.COLUMN_NAME
				          AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
				          AND SMSM.VALID_YN     = 'Y'
				WHERE 1 = 1
				AND U.USER_INQUIRY_COLUMN_TYPE_CODE	= 'M'
				AND U.PROGRAM_ID						= 'DMF0035'
				AND U.SHEET_NAME						= 'Mkt Fcst Waterfall'
				AND U.USER_ID							= p_created_by
				AND U.COLUMN_NAME						= 'CUST_FCST') || 0.1  AS SORT_ORDER_NO
			,'' AS SYSTEM_ADD
        FROM DM_MST_CUSTOMER_FCST C  WITH(NOLOCK,INDEX (PK_DM_MST_CUSTOMER_FCST))
		WHERE 1 = 1
			AND C.MEASURE_GROUP = 'CUST_FCST'
			AND C.MEASURE      IS NOT NULL
			AND C.VALID_YN   = 'Y'
			AND EXISTS (SELECT *
						FROM SCM_MST_TITLESET_USER X WITH(NOLOCK,INDEX (PK_SCM_MST_TITLESET_USER))
						WHERE  1 = 1
							AND X.USER_INQUIRY_COLUMN_TYPE_CODE	= 'M'
							AND X.PROGRAM_ID					= 'DMF0035'
							AND X.SHEET_NAME					= 'Mkt Fcst Waterfall'
							AND X.USER_ID						= p_created_by
							AND X.COLUMN_NAME					= 'CUST_FCST'
							AND X.COLUMN_NAME					= C.MEASURE_GROUP)

		UNION ALL
		SELECT DISTINCT
			'DMF0035'					AS PROGRAM_ID
			, 'Mkt Fcst Waterfall'		AS SHEET_NAME
			, p_created_by			AS USER_ID
			, 'CUST_FCST_ORG'			AS MEASURE_GROUP
			, 'Customer Fcst[Org.]'		AS MEASURE
			, (SELECT SMSM.SORT_ORDER_NO         -- 20231212 kcw3408 4_고객수요 Measure 통합
				FROM SCM_MST_TITLESET_USER U WITH(NOLOCK,INDEX (PK_SCM_MST_TITLESET_USER))
			             JOIN SCM_MST_SHEET_MEASURE SMSM
				           ON U.PROGRAM_ID = SMSM.PROGRAM_ID
			              AND U.SHEET_NAME = SMSM.SHEET_NAME
				          AND U.COLUMN_NAME = SMSM.COLUMN_NAME
				          AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
				          AND SMSM.VALID_YN     = 'Y'
				WHERE 1 = 1
				AND U.USER_INQUIRY_COLUMN_TYPE_CODE	= 'M'
				AND U.PROGRAM_ID									= 'DMF0035'
				AND U.SHEET_NAME									= 'Mkt Fcst Waterfall'
				AND USER_ID											= p_created_by
				AND U.COLUMN_NAME								= 'CUST_FCST_ORG') || 0.1  AS SORT_ORDER_NO
			,'' AS SYSTEM_ADD
        FROM DM_MST_CUSTOMER_FCST C  WITH(NOLOCK,INDEX (PK_DM_MST_CUSTOMER_FCST))
		WHERE 1 = 1
			AND C.MEASURE_GROUP = 'CUST_FCST'
			AND C.MEASURE      IS NOT NULL
			AND C.VALID_YN   = 'Y'
			AND EXISTS (SELECT *
						FROM SCM_MST_TITLESET_USER X WITH(NOLOCK,INDEX (PK_SCM_MST_TITLESET_USER))
						WHERE  1 = 1
							AND X.USER_INQUIRY_COLUMN_TYPE_CODE	= 'M'
							AND X.PROGRAM_ID					= 'DMF0035'
							AND X.SHEET_NAME					= 'Mkt Fcst Waterfall'
							AND X.USER_ID						= p_created_by
							AND X.COLUMN_NAME					= 'CUST_FCST_ORG'
							--AND X.COLUMN_NAME					= C.MEASURE_GROUP
							)

--select * from GT_DMF0_SELECT_MEASURE;return;

			--SELECT DISTINCT
			--	CASE  WHEN U.COLUMN_NAME IN ( 'CUST_INV_I','CUST_PRODUCT_S','CUST_WHIN_P','CUST_DIO'  )  THEN 'CUST. PSI'
			--			WHEN U.COLUMN_NAME IN ( 'MKT_INV_I' ,'MKT_PRODUCT_S' ,'MKT_WHIN_P' ,'MKT_DIO'   )  THEN 'MKT PSI'
			--			ELSE U.COLUMN_NAME
			--		END AS MEASURE_GROUP
			--	 , U.COLUMN_NAME AS MEASURE
			--	 , U.SORT_ORDER_NO
			--	 , '' AS SYSTEM_ADD
			--INTO GT_DMF0_SELECT_MEASURE   -- 20191025 KHSONG 쿼리조건오류 수정반영 & WITH TEMP 조건 용량초과 오류로 일반 TEMP테이블 생성으로 구조 변경함
			--FROM SCM_MST_TITLESET_USER U
			--WHERE 1 = 1
			--	AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
			--	AND U.PROGRAM_ID   = p_program_id
			--	AND U.USER_ID      = p_created_by

			-- ---------------------------------------------------------------------------------------------------------------
			-- 변환 또는 환산이 필요할 경우 해당 본 메저도 추가해준다.
			-- ---------------------------------------------------------------------------------------------------------------
			SELECT COUNT(1)
			INTO v_cnt_1
			FROM GT_DMF0_SELECT_MEASURE WHERE MEASURE LIKE 'MKT_FCST_RP%';
			IF v_cnt_1 > 0 THEN
				INSERT INTO GT_DMF0_SELECT_MEASURE ( PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE_GROUP, MEASURE, SYSTEM_ADD )
				SELECT 'DMF0035', 'Mkt Fcst Waterfall', p_created_by, A.MEASURE_GROUP, A.MEASURE, 'Y'
				FROM (
					SELECT 'RTF_SYS_RP' AS MEASURE_GROUP, 'RTF_SYS_RP' AS MEASURE
					UNION ALL
					SELECT 'MKT_FCST' AS MEASURE_GROUP, 'MKT_FCST' AS MEASURE
					) A;
				LEFT OUTER JOIN GT_DMF0_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
				WHERE B.MEASURE IS NULL
					FROM DUAL;
			END IF;

			SELECT COUNT(1)
			INTO v_cnt_2
			FROM GT_DMF0_SELECT_MEASURE WHERE MEASURE LIKE 'RTF_SYS_RP%';
			IF v_cnt_2 > 0 THEN
				INSERT INTO GT_DMF0_SELECT_MEASURE ( PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE_GROUP, MEASURE, SYSTEM_ADD )
				SELECT 'DMF0035', 'Mkt Fcst Waterfall', p_created_by, A.MEASURE_GROUP, A.MEASURE, 'Y'
				FROM (
					SELECT 'RTF_SYS_RP' AS MEASURE_GROUP, 'RTF_SYS_RP' AS MEASURE
					) A;
				LEFT OUTER JOIN GT_DMF0_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
				WHERE B.MEASURE IS NULL
					FROM DUAL;
			END IF;

			SELECT COUNT(1)
			INTO v_cnt_3
			FROM GT_DMF0_SELECT_MEASURE WHERE MEASURE = 'LOC';
			IF v_cnt_3 > 0 THEN
				INSERT INTO GT_DMF0_SELECT_MEASURE ( PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE_GROUP, MEASURE, SYSTEM_ADD )
				SELECT 'DMF0035', 'Mkt Fcst Waterfall', p_created_by, A.MEASURE_GROUP, A.MEASURE, 'Y'
				FROM (
					SELECT 'RTF_SYS_RP' AS MEASURE_GROUP, 'RTF_SYS_RP' AS MEASURE
					UNION ALL
					SELECT 'SALESAMT' AS MEASURE_GROUP,'SalesAmt_LOC' AS MEASURE
					) A;
				LEFT OUTER JOIN GT_DMF0_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
				WHERE B.MEASURE IS NULL
					FROM DUAL;
			END IF;

			-- --------------------------------------------------------------------------------------------------------------------------------
			-- [PJ2025-50188] 소형 매출계획 동기화 개선 고도화 : SCM_FCST 실적 추가 요청
			-- SCM_FCST 메저의 실적구간은 RTF_SYS_RP 를 가져와 보여주도록 한다.
			-- --------------------------------------------------------------------------------------------------------------------------------
			SELECT COUNT(1)
			INTO v_cnt_4
			FROM GT_DMF0_SELECT_MEASURE WHERE MEASURE IN ( 'SCM_FCST' );
			IF v_cnt_4 > 0 THEN
				INSERT INTO GT_DMF0_SELECT_MEASURE ( PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE_GROUP, MEASURE, SYSTEM_ADD )
				SELECT 'DMF0035', 'Mkt Fcst Waterfall', p_created_by, A.MEASURE_GROUP, A.MEASURE, 'Y'
				FROM (
					SELECT 'RTF_SYS_RP' AS MEASURE_GROUP, 'RTF_SYS_RP' AS MEASURE
					) A;
				LEFT OUTER JOIN GT_DMF0_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
				WHERE B.MEASURE IS NULL
					FROM DUAL;
			END IF;

DBMS_OUTPUT.PUT_LINE('D--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

			-- 테이블중복제거
			-- 임시확인용테이블 중복제거
			--GT_DMF0_EDI_SENDER
			EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_EDI_SENDER';

			BEGIN
				INSERT INTO GT_DMF0_EDI_SENDER ( SCM_SITE_ID, SENDER_CODE, SENDER_NAME )
				SELECT A.SCM_SITE_ID, B.ATTRIBUTE5, B.ATTRIBUTE6
				FROM SCM_MST_SITE A
				JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B
				ON A.END_CUSTOMER = B.SEGMENT2
				AND A.DIVISION_ID = B.SEGMENT1
				AND B.LOOKUP_TYPE = 'EDI_END_CUSTOMER'
				GROUP BY A.SCM_SITE_ID, B.ATTRIBUTE5, B.ATTRIBUTE6;
			END;

			-- -----------------------------------------------
			-- (1) DM_PLN_SALES_PLAN + (4) DM_PLN_SALES_PLAN (MEASURE = 'MKT_FCST')
			-- -----------------------------------------------
			IF ( p_version_no LIKE '%CURRENT%' ) THEN

				BEGIN
					INSERT INTO GT_DMF0_LAST_DATA_SETUP
					SELECT X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS, X.MEASURE
							 , MAX(X.LAST_UPDATE_DATE), MAX(X.LAST_UPDATED_BY)
					FROM (
							  SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
										--[E20241126-000426]_CUST_FCST Measure 추가 START
	 								    --, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'
										--									    , 'CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]') THEN
	 								   , (CASE WHEN A.MEASURE IN ('CUST_FCST', 'CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'
																				--[E20241126-000426]_ORG 데이터는 더이상 보이지 않도록 하였으므로 주석처리한다. START
																			    /*, 'CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]'*/
																				--[E20241126-000426]_ORG 데이터는 더이상 보이지 않도록 하였으므로 주석처리한다. END
																				) THEN
										--[E20241126-000426]_CUST_FCST Measure 추가 START
														   (CASE WHEN NVL(MAX(A.ATTRIBUTE9), NULL) IS NULL THEN
																			  MAX(TO_CHAR(A.LAST_UPDATE_DATE, 'YYYYMMDD'))
																	ELSE MAX(A.ATTRIBUTE9) END)
												 ELSE MAX(TO_CHAR(A.LAST_UPDATE_DATE, 'YYYYMMDD')) END) AS LAST_UPDATE_DATE
	 								   , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
							  --FROM DM_PLN_MKT_FCST A
							  FROM (
									SELECT F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY, F.ATTRIBUTE10, '-' AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
									,F.ATTRIBUTE9,F.LAST_UPDATE_DATE,F.LAST_UPDATED_BY
									FROM DM_PLN_MKT_FCST F  WHERE (CASE WHEN p_division_id = '40' THEN 1 ELSE 2 END) = 2
									UNION ALL
									SELECT F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY, F.ATTRIBUTE10, F.CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
									,F.ATTRIBUTE9,F.LAST_UPDATE_DATE,F.LAST_UPDATED_BY
									FROM DM_PLN_CFM_MKT_DEMAND_PLAN F  WHERE (CASE WHEN p_division_id = '40' THEN 1 ELSE 2 END) = 1
								   ) AS A
							  JOIN GT_DMF0_SELECT_MEASURE B
							  ON A.MEASURE = (CASE WHEN B.MEASURE = 'CUST_FCST_ORG' THEN 'CUST_FCST'
																 WHEN B.MEASURE = 'Customer Fcst[Org.]' THEN 'Customer FCST'
																 WHEN B.MEASURE IN ('MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL') THEN 'MKT_FCST'
																 WHEN B.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL', 'RTF_ENERGY') THEN 'RTF'
																 ELSE B.MEASURE END)
							  WHERE A.DIVISION_ID = p_division_id
							  AND A.YYYYMMDD >= TO_CHAR(ADD_MONTHS(p_from_yyyymmdd, (-1)*12), 'YYYYMMDD')
							  AND A.YYYYMMDD <= p_to_yyyymmdd
							  AND A.QTY <> 0
							  GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
							  UNION ALL
							  SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
										--[E20241126-000426]_CUST_FCST Measure 추가 START
	 								    --, (CASE WHEN A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'
	 								    , (CASE WHEN A.MEASURE IN ('CUST_FCST', 'CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'
									    --[E20241126-000426]_CUST_FCST Measure 추가 END
																			    , 'CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]') THEN
														   (CASE WHEN NVL(MAX(A.ATTRIBUTE9), NULL) IS NULL THEN
																			  MAX(TO_CHAR(A.LAST_UPDATE_DATE, 'YYYYMMDD'))
																	ELSE MAX(A.ATTRIBUTE9) END)
												 ELSE MAX(TO_CHAR(A.LAST_UPDATE_DATE, 'YYYYMMDD')) END) AS LAST_UPDATE_DATE
	 								   , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
							  FROM DM_PLN_MKT_FCST_RESULT A
							  JOIN GT_DMF0_SELECT_MEASURE B
							  ON A.MEASURE = (CASE WHEN B.MEASURE = 'CUST_FCST_ORG' THEN 'CUST_FCST'
																 WHEN B.MEASURE = 'Customer Fcst[Org.]' THEN 'Customer FCST'
																 WHEN B.MEASURE IN ('MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL') THEN 'MKT_FCST'
																 WHEN B.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL', 'RTF_ENERGY') THEN 'RTF'
																 ELSE B.MEASURE END)
							  WHERE A.DIVISION_ID = p_division_id
							  AND A.YYYYMMDD >= TO_CHAR(ADD_MONTHS(p_from_yyyymmdd, (-1)*12), 'YYYYMMDD')
							  AND A.YYYYMMDD <= p_to_yyyymmdd
							  AND A.QTY <> 0
							  GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
						      ) X;
					WHERE NVL(X.PROJECT_CODE, NULL) IS NOT NULL
					AND NVL(X.SCM_SITE_ID, NULL) IS NOT NULL
					AND NVL(X.ITEM_ID, NULL) IS NOT NULL
					GROUP BY X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS, X.MEASURE;
				END;

				-- EDI LOOKUP 기간
				-- 테이블중복제거
				-- 임시확인용테이블 중복제거
				--GT_DMF0_EDI_END_CUSTOMER
				EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_EDI_END_CUSTOMER';

				--EDI END_CUSTOMER별 기간 설정
				BEGIN

					INSERT INTO GT_DMF0_EDI_END_CUSTOMER ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, FROM_WEEK, FROM_DAY, TO_WEEK, TO_DAY, ACTIVE )
					SELECT A.DIVISION_ID AS DIVISION_ID
							 , A.END_CUSTOMER AS END_CUSTOMER
							 , NVL(B.SEGMENT4, '-') AS SCM_SITE_ID
							 , (CASE WHEN NVL(B.SEGMENT5, 'On') = 'On' THEN
												  NVL(B.ATTRIBUTE1, '-1')
										ELSE '-52' END) AS FROM_WEEK
							 , NVL(B.ATTRIBUTE2, 'TUE') AS FROM_DAY
							 , NVL(B.ATTRIBUTE3, '0') AS TO_WEEK
							 , NVL(B.ATTRIBUTE4, 'MON') AS TO_DAY
							 , NVL(B.SEGMENT5, 'On') AS ACTIVE
					FROM SCM_MST_SITE A
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B
					ON B.LOOKUP_TYPE = 'EDI_END_CUSTOMER'
						AND A.DIVISION_ID = B.SEGMENT1
						AND A.END_CUSTOMER = B.SEGMENT2
						AND B.VALID_YN = 'Y'
					WHERE NVL(A.END_CUSTOMER, NULL) IS NOT NULL
					GROUP BY A.DIVISION_ID, A.END_CUSTOMER, B.SEGMENT4, B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3, B.ATTRIBUTE4, B.SEGMENT5;

				END;

				--[E20241126-000426]_ORG 데이터는 더이상 보이지 않도록 하였으므로 주석처리한다. START
				/*
				-- EDI[Org.] LOOKUP 기간
				-- 테이블중복제거
				-- 임시확인용테이블 중복제거
				--GT_DMF0_EDI_END_CUSTOMER_ORG
				EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_EDI_END_CUSTOMER_ORG';

				--EDI END_CUSTOMER_ORG별 기간 설정
				BEGIN

					INSERT INTO GT_DMF0_EDI_END_CUSTOMER_ORG ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, FROM_WEEK, FROM_DAY, TO_WEEK, TO_DAY, ACTIVE )
					SELECT A.DIVISION_ID AS DIVISION_ID
							 , A.END_CUSTOMER AS END_CUSTOMER
							 , NVL(B.SEGMENT4, '-') AS SCM_SITE_ID
							 , (CASE WHEN NVL(B.SEGMENT5, 'On') = 'On' THEN
										 NVL(B.ATTRIBUTE1, '-1')
							   ELSE '-52' END) AS FROM_WEEK
							 , NVL(B.ATTRIBUTE2, 'TUE') AS FROM_DAY
							 , NVL(B.ATTRIBUTE3, '0') AS TO_WEEK
							 , NVL(B.ATTRIBUTE4, 'MON') AS TO_DAY
							 , NVL(B.SEGMENT5, 'On') AS ACTIVE
					FROM SCM_MST_SITE A
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B
					ON B.LOOKUP_TYPE = 'EDI_END_CUSTOMER_ORG'
						AND A.DIVISION_ID = B.SEGMENT1
						AND A.END_CUSTOMER = B.SEGMENT2
						AND B.VALID_YN = 'Y'
					WHERE NVL(A.END_CUSTOMER, NULL) IS NOT NULL
					GROUP BY A.DIVISION_ID, A.END_CUSTOMER, B.SEGMENT4, B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3, B.ATTRIBUTE4, B.SEGMENT5;

				*/
				--[E20241126-000426]_ORG 데이터는 더이상 보이지 않도록 하였으므로 주석처리한다. END

				-- RPA LOOKUP 기간
				-- 테이블중복제거
				-- 임시확인용테이블 중복제거
				--GT_DMF0_EDI_END_CUSTOMER
				EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_RPA_END_CUSTOMER';

				--RPA END_CUSTOMER별 기간 설정
				BEGIN

					INSERT INTO GT_DMF0_RPA_END_CUSTOMER ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, FROM_WEEK, FROM_DAY, TO_WEEK, TO_DAY, ACTIVE )
					SELECT A.DIVISION_ID AS DIVISION_ID
							 , A.END_CUSTOMER AS END_CUSTOMER
							 , NVL(B.SEGMENT4, '-') AS SCM_SITE_ID
							 , (CASE WHEN NVL(B.SEGMENT5, 'On') = 'On' THEN
												  NVL(B.ATTRIBUTE1, '-1')
										ELSE '-52' END) AS FROM_WEEK
							 , NVL(B.ATTRIBUTE2, 'TUE') AS FROM_DAY
							 , NVL(B.ATTRIBUTE3, '0') AS TO_WEEK
							 , NVL(B.ATTRIBUTE4, 'MON') AS TO_DAY
							 , NVL(B.SEGMENT5, 'On') AS ACTIVE
					FROM SCM_MST_SITE A
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B
					ON B.LOOKUP_TYPE = 'RPA_END_CUSTOMER'
						AND A.DIVISION_ID = B.SEGMENT1
						AND A.END_CUSTOMER = B.SEGMENT2
						AND B.VALID_YN = 'Y'
					WHERE NVL(A.END_CUSTOMER, NULL) IS NOT NULL
					GROUP BY A.DIVISION_ID, A.END_CUSTOMER, B.SEGMENT4, B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3, B.ATTRIBUTE4, B.SEGMENT5;

				END;

				--[E20241126-000426]_ORG 데이터는 더이상 보이지 않도록 하였으므로 주석처리한다. START
				/*
				-- RPA[Org.] LOOKUP 기간
				-- 테이블중복제거
				-- 임시확인용테이블 중복제거
				--GT_DMF0_EDI_END_CUSTOMER_ORG
				EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_RPA_END_CUSTOMER_ORG';

				--RPA END_CUSTOMER_ORG별 기간 설정
				BEGIN

					INSERT INTO GT_DMF0_RPA_END_CUSTOMER_ORG ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, FROM_WEEK, FROM_DAY, TO_WEEK, TO_DAY, ACTIVE )
					SELECT A.DIVISION_ID AS DIVISION_ID
							 , A.END_CUSTOMER AS END_CUSTOMER
							 , NVL(B.SEGMENT4, '-') AS SCM_SITE_ID
							 , (CASE WHEN NVL(B.SEGMENT5, 'On') = 'On' THEN
										 NVL(B.ATTRIBUTE1, '-1')
							   ELSE '-52' END) AS FROM_WEEK
							 , NVL(B.ATTRIBUTE2, 'TUE') AS FROM_DAY
							 , NVL(B.ATTRIBUTE3, '0') AS TO_WEEK
							 , NVL(B.ATTRIBUTE4, 'MON') AS TO_DAY
							 , NVL(B.SEGMENT5, 'On') AS ACTIVE
					FROM SCM_MST_SITE A
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B
					ON B.LOOKUP_TYPE = 'RPA_END_CUSTOMER_ORG'
						AND A.DIVISION_ID = B.SEGMENT1
						AND A.END_CUSTOMER = B.SEGMENT2
						AND B.VALID_YN = 'Y'
					WHERE NVL(A.END_CUSTOMER, NULL) IS NOT NULL
					GROUP BY A.DIVISION_ID, A.END_CUSTOMER, B.SEGMENT4, B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3, B.ATTRIBUTE4, B.SEGMENT5;

				*/
				--[E20241126-000426]_ORG 데이터는 더이상 보이지 않도록 하였으므로 주석처리한다. END
-- 20240312 start

 				/* TODO:GTT:GT_DMF0_DM_PLN_MKT_FCST-->GT_DMF0_DM_PLN_MKT_FCST */
 				INSERT INTO GT_DMF0_DM_PLN_MKT_FCST
 				SELECT A.*, CASE WHEN A.DIVISION_ID = '40' AND B.MEASURE_GROUP IS NULL THEN 'MKT_FCST_RP'
							  WHEN A.DIVISION_ID = '40' THEN B.MEASURE_GROUP
							  ELSE '' END AS MEASURE_GROUP
				--FROM DM_PLN_MKT_FCST A
				FROM (
					  SELECT F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY, F.ATTRIBUTE10, '-' AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					  ,F.LAST_UPDATED_BY,F.ATTRIBUTE4,F.ATTRIBUTE5
					  FROM DM_PLN_MKT_FCST F  WHERE (CASE WHEN p_division_id = '40' THEN 1 ELSE 2 END) = 2
					  UNION ALL
					  SELECT F.DIVISION_ID, F.PROJECT_CODE , F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.YYYYMMDD, F.QTY, F.ATTRIBUTE10, F.CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					  ,F.LAST_UPDATED_BY,F.ATTRIBUTE4,F.ATTRIBUTE5
					  FROM DM_PLN_CFM_MKT_DEMAND_PLAN F  WHERE (CASE WHEN p_division_id = '40' THEN 1 ELSE 2 END) = 1
					 ) AS A
				JOIN GT_DMF0_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
				JOIN SCM_MST_SITE C (NOLOCK) ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID AND C.VALID_YN = 'Y'
				WHERE A.YYYYMMDD >= v_now_yyyymmdd and A.YYYYMMDD <= p_to_yyyymmdd
					AND A.DIVISION_ID =p_division_id
					AND A.MEASURE NOT IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder'
												   	   --[E20241126-000426]_ORG 데이터는 더이상 보이지 않도록 하였으므로 주석처리한다. START
													   /*
													   , 'CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]'
													   , 'Material_Temp[Org.]', 'Backorder[Org.]'
													   */
													   --[E20241126-000426]_ORG 데이터는 더이상 보이지 않도록 하였으므로 주석처리한다. END
													   , 'CUST_FCST', 'Customer FCST')
					AND A.QTY <> 0;


				return;

DBMS_OUTPUT.PUT_LINE('E5--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

			-- -----------------------------------------------------------------------------------------------------------------------------------------
			-- 조회조건에 따른 필터링 처리 ( PRICE 계산시 부하문제로 필터링은 여기서 하고, 필요없는 메저는 PRICE 끝난 후 제거 )
			-- -----------------------------------------------------------------------------------------------------------------------------------------
			BEGIN -- 필터링 시작

				IF ( p_project_code IS NOT NULL) THEN
					DELETE A
					FROM GT_DMF0_RAW_DATA A
					JOIN SCM_MST_PROJECT B ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE
					LEFT OUTER JOIN (	SELECT DISTINCT token
										FROM TABLE(fn_string_split(p_project_code,','))
									) C	ON B.PROJECT_CODE LIKE '%'  ||  C.TOKEN  ||  '%'
					LEFT OUTER JOIN (	SELECT DISTINCT token
										FROM TABLE(fn_string_split(p_project_code,','))
									) D	ON B.PROJECT_NAME LIKE '%'  ||  D.TOKEN  ||  '%'

					WHERE C.TOKEN IS NULL AND D.TOKEN IS NULL;
				END IF;

--select * from GT_DMF0_RAW_DATA;return;
				IF ( p_item_id IS NOT NULL) THEN
					DELETE A
					FROM GT_DMF0_RAW_DATA A
					LEFT OUTER JOIN GT_DMF0_DM_MST_ITEM_SINGLE_V B ON A.ITEM_ID = B.ITEM_ID
					LEFT OUTER JOIN (	SELECT DISTINCT token
										FROM TABLE(fn_string_split(p_item_id,','))
									) C	ON A.ITEM_ID LIKE '%'  ||  C.TOKEN  ||  '%'
					LEFT OUTER JOIN (	SELECT DISTINCT token
										FROM TABLE(fn_string_split(p_item_id,','))
									) D	ON B.NICK_NAME LIKE '%'  ||  D.TOKEN  ||  '%'
					WHERE C.TOKEN IS NULL  AND D.TOKEN IS NULL;
				END IF;

--select * from GT_DMF0_RAW_DATA;return;
				IF ( p_owner IS NOT NULL) THEN
					DELETE A
					FROM GT_DMF0_RAW_DATA A
					LEFT OUTER JOIN GT_DMF0_SCM_MST_SITE_ITEM B ON A.ITEM_ID = B.ITEM_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.PROJECT_CODE = B.PROJECT_CODE
					LEFT OUTER JOIN (	SELECT DISTINCT token
										FROM TABLE(fn_string_split(p_owner,','))
									) C	ON B.OWNER LIKE '%'  ||  C.TOKEN  ||  '%'
					LEFT OUTER JOIN (	SELECT DISTINCT token
										FROM TABLE(fn_string_split(p_owner,','))
									) D	ON B.OWNER_NAME LIKE '%'  ||  D.TOKEN  ||  '%'
					LEFT OUTER JOIN (	SELECT DISTINCT token
										FROM TABLE(fn_string_split(p_owner,','))
									) E	ON B.OWNER_NAME_KO LIKE '%'  ||  E.TOKEN  ||  '%'
					WHERE C.TOKEN IS NULL  AND D.TOKEN IS NULL  AND E.TOKEN IS NULL;
				END IF;

				IF ( p_dept_id <> 'ALL') THEN
				--[PJ2024-50461] Team Mapping------------------------------------
						DELETE A
						FROM GT_DMF0_RAW_DATA A
						LEFT OUTER JOIN GT_DMF0_SCM_MST_SITE_ITEM B ON A.ITEM_ID = B.ITEM_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.PROJECT_CODE = B.PROJECT_CODE
						LEFT OUTER JOIN (	SELECT DISTINCT token
											FROM TABLE(fn_string_split(p_dept_id,','))
										) C	ON B.DEPT_ID = C.TOKEN
						WHERE C.TOKEN IS NULL;
					/*
					IF ( P_DIVISION_ID = '40')
					BEGIN
						DELETE A
						FROM GT_DMF0_RAW_DATA A
						LEFT OUTER JOIN GT_DMF0_SCM_MST_SITE_ITEM B ON A.ITEM_ID = B.ITEM_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.PROJECT_CODE = B.PROJECT_CODE
						LEFT OUTER JOIN (	SELECT DISTINCT token
											FROM TABLE(fn_string_split(p_dept_id,','))
										) C	ON B.DEPT_ID = C.TOKEN
						WHERE C.TOKEN IS NULL;
					END
					ELSE
					BEGIN
						DELETE A
						FROM GT_DMF0_RAW_DATA A
						LEFT OUTER JOIN SCM_MST_SITE B ON A.SCM_SITE_ID = B.SCM_SITE_ID AND B.DIVISION_ID = P_DIVISION_ID
						LEFT OUTER JOIN (	SELECT DISTINCT token
											FROM TABLE(fn_string_split(p_dept_id,','))
										) C	ON B.DEPT_ID = C.TOKEN
						WHERE C.TOKEN IS NULL;
					*/
				END IF;

				IF ( p_end_customer <> 'ALL') THEN
					IF ( P_DIVISION_ID = '40') THEN
						DELETE A
						FROM GT_DMF0_RAW_DATA A
						LEFT OUTER JOIN (	SELECT DISTINCT token
											FROM TABLE(fn_string_split(p_end_customer,','))
										) C	ON A.PROJECT_CODE = C.TOKEN
						WHERE C.TOKEN IS NULL;
					ELSE
						DELETE A
						FROM GT_DMF0_RAW_DATA A
						LEFT OUTER JOIN SCM_MST_SITE B ON A.SCM_SITE_ID = B.SCM_SITE_ID AND B.DIVISION_ID = P_DIVISION_ID
						LEFT OUTER JOIN (	SELECT DISTINCT token
											FROM TABLE(fn_string_split(p_end_customer,','))
										) C	ON B.END_CUSTOMER = C.TOKEN
						WHERE C.TOKEN IS NULL;
					END IF;

				IF ( p_scm_site_id <> 'ALL') THEN
					DELETE A
					FROM GT_DMF0_RAW_DATA A
					LEFT OUTER JOIN (	SELECT DISTINCT token
										FROM TABLE(fn_string_split(p_scm_site_id,','))
									) C	ON A.SCM_SITE_ID = C.TOKEN
					WHERE C.TOKEN IS NULL;
				END IF;

				IF ( p_plant_site_id <> 'ALL') THEN
					DELETE A
					FROM GT_DMF0_RAW_DATA A
					LEFT OUTER JOIN (	SELECT DISTINCT token
										FROM TABLE(fn_string_split(p_plant_site_id,','))
									) C	ON A.PLANT_SITE_ID = C.TOKEN
					WHERE C.TOKEN IS NULL;
				END IF;

				IF ( p_item_type <> 'ALL') THEN
					DELETE A
					FROM GT_DMF0_RAW_DATA A
					LEFT OUTER JOIN GT_DMF0_DM_MST_ITEM_SINGLE_V B ON A.ITEM_ID = B.ITEM_ID
					LEFT OUTER JOIN (	SELECT DISTINCT token
										FROM TABLE(fn_string_split(p_item_type,','))
									) C	ON B.ITEM_TYPE = C.TOKEN
					WHERE C.TOKEN IS NULL;
				END IF;

				IF ( p_biz_type <> 'ALL') THEN
					IF( P_DIVISION_ID = '40' ) THEN
						DELETE A
						FROM GT_DMF0_RAW_DATA A
						LEFT OUTER JOIN GT_DMF0_DM_MST_ITEM_SINGLE_V B ON A.ITEM_ID = B.ITEM_ID
						LEFT OUTER JOIN (	SELECT DISTINCT token
											FROM TABLE(fn_string_split(p_biz_type,','))
										) C	ON B.FORECAST_INFO_BIZ_TYPE = C.TOKEN
						WHERE C.TOKEN IS NULL;
					ELSE
						DELETE A
						FROM GT_DMF0_RAW_DATA A
						JOIN SCM_MST_PROJECT B ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE
						LEFT OUTER JOIN (	SELECT DISTINCT token
											FROM TABLE(fn_string_split(p_biz_type,','))
										) C	ON B.BIZ_TYPE LIKE '%'  ||  C.TOKEN  ||  '%'
						WHERE C.TOKEN IS NULL;
					END IF;

				IF ( p_sender_code <> 'ALL') THEN
				  DELETE A
				  FROM GT_DMF0_RAW_DATA A
				  LEFT OUTER JOIN (SELECT DISTINCT token
						FROM TABLE(fn_string_split(p_sender_code,','))
						) C ON A.SENDER_CODE = C.TOKEN
				  WHERE C.TOKEN IS NULL;
				END IF;

			END;
--select * from GT_DMF0_RAW_DATA;return;

DBMS_OUTPUT.PUT_LINE('E6--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

			-- 계획구간 PRICE 처리
			SELECT COUNT(1)
			INTO v_cnt_5
			FROM GT_DMF0_SELECT_MEASURE WHERE MEASURE = 'LOC';
			IF v_cnt_5 > 0 THEN
				INSERT INTO GT_DMF0_RAW_DATA
						( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE
						, MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, PLAN_RESULT, GUBUN, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME )
				SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
								,A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, C.MEASURE, 'MKT_FCST_RP' AS MEASURE_GROUP, A.YYYYMMDD, C.PRICE, 'P', 9
								, A.CREATE_DATE, A.LAST_UPDATED_BY, A.SENDER_CODE, A.SENDER_NAME
				FROM (
						SELECT   DISTINCT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
								,A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.YYYYMMDD, A.CREATE_DATE, A.LAST_UPDATED_BY, A.SENDER_CODE, A.SENDER_NAME
						FROM GT_DMF0_RAW_DATA A
						WHERE   A.YYYYMMDD >= CASE WHEN VERSION_NO = 'CURRENT' THEN V_NOW_YYYYMMDD
										      ELSE TO_CHAR(FN_NEXT_DAY( A.CUTOFF_YYYYMMDD, 'MON') + (-7), 'YYYYMMDD')
										      END  and A.YYYYMMDD <= p_to_yyyymmdd
								AND A.MEASURE IN ( 'RTF_SYS_RP', 'MKT_FCST_RP', 'MKT_FCST', 'RTF_SCP')
						) A;
				JOIN SCM_SYS_CALENDAR_M B (NOLOCK) ON A.YYYYMMDD = B.BASIS_YYYYMMDD
				JOIN SCM_MST_FUTURE_PRICE C (NOLOCK) ON A.DIVISION_ID		= C.DIVISION_ID
														AND A.PROJECT_CODE		= C.PROJECT_CODE
														AND A.SCM_SITE_ID		= C.SCM_SITE_ID
														AND A.PLANT_SITE_ID		= C.PLANT_SITE_ID
														AND A.ITEM_ID			= C.ITEM_ID
														AND A.INCOTERMS			= C.INCOTERMS
														AND A.DOM_EXP			= C.DOM_EXP
														AND A.FCST_TYPE			= C.FCST_TYPE
														AND B.basis_start_date	= C.YYYYMMDD
														AND C.YYYYMMDD			<= p_to_yyyymmdd
				JOIN GT_DMF0_SELECT_MEASURE D ON C.MEASURE = D.MEASURE

			END IF;
--select * from GT_DMF0_RAW_DATA;return;

DBMS_OUTPUT.PUT_LINE('F--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

		-- ---------------------------------------------------------------------------------------
		--	필요없는 메저 삭제
		-- ---------------------------------------------------------------------------------------
		SELECT COUNT(1)
		INTO v_cnt_6
		FROM GT_DMF0_SELECT_MEASURE WHERE MEASURE IN ( 'MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL', 'RTF_SYS_RP_CAR', 'RTF_SYS_RP_CELL', 'RTF_ENERGY', 'MKT_FCST_ENERGY');
		IF v_cnt_6 > 0 THEN

			INSERT INTO GT_DMF0_RAW_DATA
					(VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE
					, MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, PLAN_RESULT, GUBUN, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME
					, CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					)
			SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
					,A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, B.MEASURE_CALC, A.MEASURE_GROUP, A.YYYYMMDD
					,CASE	WHEN B.MEASURE_CALC IN ('MKT_FCST_RP_CAR','RTF_RP_CAR','RTF_SYS_RP_CAR') THEN
								CASE WHEN INSTR(C.ITEM_CLASS_NAME, 'Cell') > 0 AND D.CELL_PER_CAR > 0 THEN QTY / D.CELL_PER_CAR
									WHEN  INSTR(C.ITEM_CLASS_NAME, 'Module') > 0  AND D.CELL_PER_CAR > 0 AND D.CELL_PER_MODULE > 0 THEN QTY/ ( D.CELL_PER_CAR/ D.CELL_PER_MODULE )
									WHEN  INSTR(C.ITEM_CLASS_NAME, 'Pack') > 0  THEN A.QTY
									ELSE 0
								END IF;
							WHEN B.MEASURE_CALC IN ('MKT_FCST_RP_CELL','RTF_RP_CELL','RTF_SYS_RP_CELL') AND A.DIVISION_ID LIKE '81%' THEN
								CASE WHEN INSTR(C.ITEM_CLASS_NAME, 'Cell') > 0 AND D.CELL_PER_CAR > 0 THEN A.QTY
									WHEN ( INSTR(C.ITEM_CLASS_NAME, 'Module') > 0 OR INSTR(C.ITEM_CLASS_NAME, 'Pack') > 0 ) AND D.CELL_PER_MODULE > 0 THEN A.QTY * D.CELL_PER_MODULE
									ELSE 0
								END IF;
							WHEN B.MEASURE_CALC IN ('MKT_FCST_RP_CELL','RTF_RP_CELL','RTF_SYS_RP_CELL') AND A.DIVISION_ID = '82' THEN A.QTY * C.CELL_QUANTITY
							-- 20211119 ROSIA27 [C20211103-000146] ESS영업관리팀 GSCM 용량 Measure 값 생성 요청의 건
							WHEN B.MEASURE_CALC = 'RTF_ENERGY' THEN
								CASE WHEN ISNUMERIC(C.ENERGE) > 0
									THEN (C.ENERGE * A.QTY)/1000
								END;
							-- 20221214 rosia27 [C20221207-000080] ESS영업관리팀 GSCM 내 Measrue값 추가 요청  MKT FCST[R+P] Energy
							WHEN B.MEASURE_CALC = 'MKT_FCST_ENERGY' AND B.MEASURE_ORI = 'RTF_SYS_RP' AND A.PLAN_RESULT = 'R' THEN
								CASE WHEN ISNUMERIC(C.ENERGE) > 0
									THEN (C.ENERGE * A.QTY)/1000
							ELSE 0
					END;
					, A.PLAN_RESULT, 7
					, A.CREATE_DATE
					, A.LAST_UPDATED_BY
					, A.SENDER_CODE
					, A.SENDER_NAME
					, A.CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
			FROM GT_DMF0_RAW_DATA A
			JOIN ( SELECT CASE WHEN A.MEASURE LIKE 'MKT_FCST_RP%' THEN 'MKT_FCST_RP'
								ELSE 'RTF_SYS_RP'
								END AS MEASURE_ORI
						, A.MEASURE AS MEASURE_CALC
					FROM GT_DMF0_SELECT_MEASURE A
					WHERE MEASURE IN ( 'MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL', 'RTF_SYS_RP_CAR', 'RTF_SYS_RP_CELL', 'RTF_ENERGY', 'MKT_FCST_ENERGY')
					) B ON A.MEASURE = B.MEASURE_ORI
			JOIN GT_DMF0_DM_MST_ITEM_SINGLE_V C ON A.ITEM_ID = C.ITEM_ID AND A.DIVISION_ID = C.DIVISION_ID
			LEFT OUTER JOIN GT_DMF0_SCM_MST_SITE_ITEM D ON A.DIVISION_ID = D.DIVISION_ID AND A.SCM_SITE_ID = D.SCM_SITE_ID AND A.PROJECT_CODE = D.PROJECT_CODE AND A.ITEM_ID = D.ITEM_ID
			WHERE A.MEASURE IN ( 'MKT_FCST_RP', 'RTF_SYS_RP' );

		END;

		-- 20221214 rosia27 [C20221207-000080] ESS영업관리팀 GSCM 내 Measrue값 추가 요청  MKT FCST[R+P] Energy
		SELECT COUNT(1)
		INTO v_cnt_7
		FROM GT_DMF0_SELECT_MEASURE WHERE MEASURE IN ( 'MKT_FCST_ENERGY');
		IF v_cnt_7 > 0 THEN
			INSERT INTO GT_DMF0_RAW_DATA
					(VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE
					, MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, PLAN_RESULT, GUBUN, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME
					, CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					)
			SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
					,A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, B.MEASURE_CALC, A.MEASURE_GROUP, A.YYYYMMDD
					,CASE   WHEN B.MEASURE_CALC = 'MKT_FCST_ENERGY' AND A.PLAN_RESULT = 'P' THEN
								CASE WHEN ISNUMERIC(C.ENERGE) > 0
									THEN (C.ENERGE * A.QTY)/1000
							ELSE 0
					END IF;
					, A.PLAN_RESULT, 8
					, A.CREATE_DATE
					, A.LAST_UPDATED_BY
					, A.SENDER_CODE
					, A.SENDER_NAME
					, A.CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
			FROM GT_DMF0_RAW_DATA A
			JOIN ( SELECT  'MKT_FCST_RP' AS MEASURE_ORI
						, A.MEASURE AS MEASURE_CALC
					FROM GT_DMF0_SELECT_MEASURE A
					WHERE MEASURE IN ('MKT_FCST_ENERGY')
					) B ON A.MEASURE = B.MEASURE_ORI
			JOIN GT_DMF0_DM_MST_ITEM_SINGLE_V C ON A.ITEM_ID = C.ITEM_ID AND A.DIVISION_ID = C.DIVISION_ID
			WHERE A.MEASURE IN ( 'MKT_FCST_RP');
		END;

		DELETE A
		FROM GT_DMF0_RAW_DATA A
		JOIN GT_DMF0_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
		WHERE B.SYSTEM_ADD = 'Y';

--select * from GT_DMF0_RAW_DATA;return;

DBMS_OUTPUT.PUT_LINE('G--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));


		-- ---------------------------------------------------------------------------------------
		--	 개발요청 수요분석시스템_4_고객수요 Measure 통합(Cust. Fcst[Org.]에 CUST_FCST_EDI[Org.]를 추가) 20231207
		-- ---------------------------------------------------------------------------------------
			--[E20241030-000923]_CUST_FCST 데이터를 생성하기 때문에, 만들어 줄 필요가 없음. START
			/*
			IF (SELECT COUNT(1)
						FROM GT_DMF0_RAW_DATA
						WHERE MEASURE IN ('CUST_FCST_EDI','CUST_FCST_EDI_ORG')
) > 0
			BEGIN
				INSERT INTO GT_DMF0_RAW_DATA
						 ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
						 , INCOTERMS, DOM_EXP, FCST_TYPE, MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, PLAN_RESULT, GUBUN, CREATE_DATE
						 , LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME
						 , AS_FROM_SITE
						)
				SELECT    DISTINCT
						  A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
						, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE
						, CASE WHEN A.MEASURE IN ('CUST_FCST_EDI')  THEN 'CUST_FCST'  ELSE  'CUST_FCST_ORG'  END AS MEASURE
						, CASE WHEN A.MEASURE IN ('CUST_FCST_EDI')  THEN 'CUST_FCST'  ELSE  'CUST_FCST_ORG'  END AS MEASURE_GROUP
						, A.YYYYMMDD, A.QTY, A.PLAN_RESULT, A.GUBUN, A.CREATE_DATE
						, A.LAST_UPDATED_BY, A.SENDER_CODE, A.SENDER_NAME
						, A.AS_FROM_SITE
				FROM GT_DMF0_RAW_DATA A
				WHERE A.MEASURE IN ('CUST_FCST_EDI','CUST_FCST_EDI_ORG');
			*/
			--[E20241030-000923]_CUST_FCST 데이터를 생성하기 때문에, 만들어 줄 필요가 없음. END
		-- ---------------------------------------------------------------------------------------
		--	컬럼리스트 만들고, MKT FCST 와 비슷한 방식으로, CTE 로 데이터를 만들고, CTE SELECT 문에 컬럼리스트 삽입한다.
		-- ---------------------------------------------------------------------------------------
		-- 컬럼리스트 생성
		BEGIN













			SELECT '',
    '',
    ''
  INTO V_PV_LIST, V_PV_COL_LIST, V_PV_COL
				FROM   SCM_SYS_CALENDAR_M a
				WHERE  a.basis_yyyymmdd >= p_from_yyyymmdd -- '20171101'  TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
				AND    a.basis_yyyymmdd <= p_to_yyyymmdd   --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
				AND	   p_bucket = 'DAILY'
				UNION ALL
				SELECT '[W_'  ||  A.BASIS_YYYYMM  ||  A.ISO_WEEK  ||  '] AS W_'  ||  a.basis_yyyymm  ||  a.iso_week  AS column_name
					 ,'[W_'  ||  A.BASIS_YYYYMM  ||  A.ISO_WEEK  ||  ']' AS PV_name
					 , a.basis_start_date  ||  '_'  ||  TO_CHAR(21) AS sort_order_no
				FROM   SCM_SYS_CALENDAR_M a
				WHERE  a.basis_yyyymmdd >= p_from_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
				AND    a.basis_yyyymmdd <= p_to_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
				AND	   p_bucket != 'ONLY_WEEKLY'
				GROUP BY a.basis_yyyymm
					   , a.iso_week
					   , a.basis_start_date
				UNION ALL
				SELECT '[M_'  ||  A.BASIS_YYYYMM  ||  '] AS M_'  ||  a.basis_yyyymm  AS column_name
					  , '[M_'  ||  A.BASIS_YYYYMM  ||  ']' AS PV_name
					  , MIN(a.basis_start_date)  ||  '_'  ||  TO_CHAR(1) AS sort_order_no
				FROM    SCM_SYS_CALENDAR_M a
				WHERE  a.basis_yyyymmdd >= p_from_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
				AND    a.basis_yyyymmdd <= p_to_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
				AND	   p_bucket != 'ONLY_WEEKLY'
				GROUP BY a.basis_yyyymm
				-- [C20220620-000567]GSCM DM 시스템의 수작업 LOSS 및 분석 용이하기 위한 기능 개선 ( Partail week의 경우 week만 표시)
				UNION ALL
				SELECT '[W_'  ||  SUBSTR(MAX(BASIS_YYYYMMDD), 1, 6) || ISO_WEEK  ||  '] AS W_'  ||  SUBSTR(MAX(BASIS_YYYYMMDD), 1, 6)  ||  A.ISO_WEEK  AS COLUMN_NAME
					, '[W_'  ||  SUBSTR(MAX(BASIS_YYYYMMDD), 1, 6) || ISO_WEEK  ||  ']' AS PV_NAME
					, MAX(BASIS_YYYYMMDD) ||  '_'  || TO_CHAR(21) AS SORT_ORDER_NO
				FROM   SCM_SYS_CALENDAR_M A
				WHERE  A.BASIS_YYYYMMDD >= p_from_yyyymmdd
				AND    A.BASIS_YYYYMMDD <= p_to_yyyymmdd
				AND	   p_bucket = 'ONLY_WEEKLY'
				GROUP BY ISO_YYYYWW, ISO_WEEK, WEEK_NAME
				ORDER BY sort_order_no;

			OPEN c_bucket;
			FETCH c_bucket INTO v_PV_column_name, v_PV_name, v_sort_order_no;
										WHILE v_fetch_status = 0 LOOP
				SELECT V_PV_COL_LIST  ||  CASE WHEN V_PV_COL_LIST IS NOT NULL THEN ',
    V_PV_LIST || CASE WHEN V_PV_LIST IS NOT NULL THEN ',
    V_PV_COL  ||  CASE WHEN V_PV_COL IS NOT NULL THEN '
  INTO V_PV_COL_LIST, V_PV_LIST, V_PV_COL
				FETCH c_Bucket INTO v_PV_column_name, v_PV_name, v_sort_order_no;
			END LOOP;

			CLOSE c_bucket;
			DEALLOCATE c_bucket;



    /* 20240518 KCW3408 속도개선_템프사용 */
    /* TODO:GTT:GT_DMF0_SCM_MST_SITE-->GT_DMF0_SCM_MST_SITE */
    INSERT INTO GT_DMF0_SCM_MST_SITE
    SELECT B.SCM_SITE_ID
	     , B.DIVISION_ID
	     , B.DEPT_ID
		 , K.SOLDTO_CODE
		 , B.VMI_YN
		 , B.END_CUSTOMER
		 , B.SOLDTO_CUSTOMER
		 , H.CITY_NAME
		 , J.COUNTRY_NAME
		 , L.SHIPTO_DESCRIPTION
		 , L.SOLDTO_DESCRIPTION
      FROM SCM_MST_SITE  B
      LEFT OUTER JOIN
	       SCM_MST_SITE_CUSTOMER(K);
		   ON B.DIVISION_ID = K.DIVISION_ID
		  AND B.SCM_SITE_ID = K.SCM_SITE_ID
		  AND K.REP_YN = 'Y'
      LEFT OUTER JOIN
	       SCM_MST_CITY(H);
		   ON B.CITY = H.CITY
      LEFT OUTER JOIN
           SCM_MST_COUNTRY(J);
		   ON B.COUNTRY = J.COUNTRY
      LEFT OUTER JOIN
	       SCM_MST_CUSTOMER(L);
		   ON K.DIVISION_ID = L.DIVISION_ID AND K.SHIPTO_CODE = L.SHIPTO_CODE AND K.SOLDTO_CODE = L.SOLDTO_CODE

			-----	일반 컬럼 -----------------------------------------------------------------------------------------------------------
			v_column_name := NULL;
			v_column := NULL;
			v_orderby := NULL;

			SELECT  Count(*)
  INTO i_Count
			FROM   SCM_MST_TITLESET_USER U
			WHERE  1 = 1
			AND    U.PROGRAM_ID  = p_Program_Id
			AND    U.SHEET_NAME  = p_sheet_name
			AND    U.USER_ID     = p_created_by
			AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C';


			IF i_Count = 0 THEN
				SELECT V_ColList = V_ColList + '[' + COLUMN_NAME + '],'
					   , V_OrderList = V_OrderList + '[' + COLUMN_NAME + '] ' + DATA_SORT_METHOD_CODE + ','
				FROM
				(
					-- ★★ ORDER BY 가능하려면 컬럼정의 100개 넘지 않아야함
					SELECT --TOP 100
						C.SORT_ORDER_NO,
						C.COLUMN_NAME, C.DATA_SORT_METHOD_CODE
					FROM SCM_MST_SHEET_COLUMNS C
					WHERE 1 = 1
						AND    C.PROGRAM_ID  = p_Program_Id
						AND    C.SHEET_NAME  = p_sheet_name
						AND    ( C.DEFAULT_FLAG = 'Y' OR
							(    C.VISIBLE_FLAG = ''
							AND    C.DEFAULT_FLAG IS NULL
							AND    C.VALID_YN     = 'Y'
							)
							)
				) tbColList;
				ORDER BY SORT_ORDER_NO;
			ELSE
				SELECT V_ColList = V_ColList + '[' + COLUMN_NAME + '],'
					   , V_OrderList = V_OrderList + '[' + COLUMN_NAME + '] ' + DATA_SORT_METHOD_CODE + ','
				FROM
				(
					-- ★★ ORDER BY 가능하려면 컬럼정의 100개 넘지 않아야함
					 /*
					 kjj 수정(2024.6.24)
					 - GROUP_ID 화면표시 위해 SCM_MST_TITLESET_USER 조인 추가
					 - ITEM_ID의 정렬보다 무조건 바로 앞에 GROUP_ID가 위치하게
					 */
				SELECT --TOP 100
					--U.SORT_ORDER_NO
					CASE WHEN C.COLUMN_NAME = 'GROUP_ID' THEN  NVL(TU.SORT_ORDER_NO,95) - 0.5 ELSE U.SORT_ORDER_NO END AS SORT_ORDER_NO--kjj 수정(2024.6.24)
					, C.COLUMN_NAME, U.DATA_SORT_METHOD_CODE
				FROM   SCM_MST_TITLESET_USER U
					INNER JOIN SCM_MST_SHEET_COLUMNS C
						ON     U.PROGRAM_ID  = C.PROGRAM_ID
						AND    U.SHEET_NAME  = C.SHEET_NAME
						AND    U.COLUMN_NAME = C.COLUMN_NAME
						AND    U.PROGRAM_ID  = p_Program_Id
						AND    U.SHEET_NAME  = p_sheet_name
						AND    U.USER_ID = p_created_by
						AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
						AND	   U.COLUMN_NAME NOT IN ( 'MEASURE','VERSION_NO')
						LEFT OUTER JOIN SCM_MST_TITLESET_USER TU
						ON     TU.PROGRAM_ID  = C.PROGRAM_ID
						AND    TU.SHEET_NAME  = C.SHEET_NAME
						AND    TU.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
						AND	   TU.COLUMN_NAME IN ('ITEM_ID')
						AND    TU.USER_ID = p_created_by
						--AND    p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )	-- 20190125 일단 주석처리 KHSONG
				-- ------
				UNION ALL
				-- ------
				/* 2024/05/17   kcw3408		이동계획 판가 매출GROUP_ID( Item은 Group 기준으로 정렬) 추가) */
				/* kjj 수정(2024.6.24)
					UI 카테고리에서 GROUP_ID 표시되게 하였으므로 불필요한 조인 제거
				*/
				SELECT--CASE WHEN C.COLUMN_NAME = 'GROUP_ID' THEN  NVL(U.SORT_ORDER_NO,135) - 0.5 ELSE C.SORT_ORDER_NO END AS SORT_ORDER_NO
						C.SORT_ORDER_NO
					 , C.COLUMN_NAME, C.DATA_SORT_METHOD_CODE
				FROM   SCM_MST_SHEET_COLUMNS C
				       /*LEFT OUTER JOIN SCM_MST_TITLESET_USER U
						ON     U.PROGRAM_ID  = C.PROGRAM_ID
						AND    U.SHEET_NAME  = C.SHEET_NAME
						AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
						AND	   U.COLUMN_NAME IN ('ITEM_ID')
						AND    U.USER_ID = p_created_by*/
				WHERE  1 = 1
						AND    C.PROGRAM_ID  = p_Program_Id
						AND    C.SHEET_NAME  = p_sheet_name
						AND    C.VISIBLE_FLAG = ''
						AND    C.DEFAULT_FLAG IS NULL
						AND    C.VALID_YN     = 'Y'
						--AND    p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )	 -- 20190125 일단 주석처리 KHSONG
				) tbColList;
				ORDER BY SORT_ORDER_NO
FETCH FIRST 100 ROWS ONLY
			END IF;
			SELECT SUBSTR(V_ColList, 1, LENGTH(V_ColList)-1),
    SUBSTR(V_OrderList, 1, LENGTH(V_OrderList)-1),
    V_ColList + ',
    REPLACE(V_ColList,'VERSION_NO','VERSION_SORT,VERSION_NO'),
    REPLACE(V_ColList,'MEASURE','MEASURE_GROUP,MEASURE,SORT_ORDER_NO'),
    REPLACE(V_OrderList,'VERSION_NO','VERSION_SORT DESC,VERSION_NO'),
    REPLACE(V_OrderList,'MEASURE','SORT_ORDER_NO')
  INTO V_ColList, V_OrderList, V_ColList, V_ColList, V_ColList, V_OrderList, V_OrderList
		END;

--SELECT * FROM GT_DMF0_SELECT_MEASURE
--SELECT V_ORDERlIST

  --select V_PV_COL_LIST,   V_PV_LIST,   v_orderby,   v_orderby
/*
			, FN_GET_DM_SALES_PLAN_WATERFALL_QTY2(A.MEASURE, NVL(D.ITEM_CLASS_NAME,''''), NVL(A.QTY,0), NVL(C.CELL_PER_CAR,0), NVL(C.CELL_PER_MODULE,0)
						, ''' + p_cell_yn + ''', NVL(D.FORECAST_INFO_CELL_PACK_COUNT, 0), ''' + P_DIVISION_ID + ''', NVL(D.FORECAST_INFO_BIZ_TYPE, '''')) AS QTY
*/

--select * from GT_DMF0_RAW_DATA where item_id = 'AMFMCC727-A1'
--	and division_id = '81'
--	--and scm_site_id = 'Ford_MX_TPZ'
--	--and project_code = 'A15FD5002'
--	and yyyymmdd = '20210831'
  /*
  2024/05/17   kcw3408		이동계획 판가 매출GROUP_ID( Item은 Group 기준으로 정렬) 추가)
    UI Category Setup 에 등록(GROUP_ID) ORDER BY 필요, GROUP_ID 추가함
  */

		BEGIN	-- CTE 에서 사용할 SELECT COLUMN 정리



			EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_COLUMN_SETUP';

				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'DIVISION_ID', 'A.DIVISION_ID');
				--[PJ2024-50461] Team Mapping------------------------------------
				--INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'DEPT_ID', 'CASE WHEN A.DIVISION_ID = ''40'' THEN C.DEPT_ID ELSE B.DEPT_ID END AS DEPT_ID')
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'DEPT_ID', 'C.DEPT_ID');
				--[PJ2024-50461] Team Mapping------------------------------------
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'END_CUSTOMER40', 'CASE WHEN A.DIVISION_ID = ''40'' THEN A.PROJECT_CODE ELSE '' '' END AS END_CUSTOMER40');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'END_CUSTOMER', 'NVL(B.END_CUSTOMER,'' '') AS END_CUSTOMER');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'BIZ_TYPE_NAME', 'G.BIZ_TYPE AS BIZ_TYPE_NAME');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'COUNTRY_NAME', 'B.COUNTRY_NAME');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CITY_NAME', 'B.CITY_NAME');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SCM_SITE_ID', 'A.SCM_SITE_ID');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'PROJECT_CODE', 'A.PROJECT_CODE');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'PROJECT_NAME', 'G.PROJECT_NAME');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'PROJECT_STATUS', 'G.PROJECT_STATUS');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'PROJECT_OWNER', 'G.PROJECT_OWNER');
			    INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'GROUP_ID', 'NVL(I.GROUP_ID,'' '') AS GROUP_ID');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'ITEM_ID', 'A.ITEM_ID');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'ITEM_ID40', 'A.ITEM_ID AS ITEM_ID40');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'ITEM_NAME', 'NVL(D.ITEM_NAME, '''') AS ITEM_NAME');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'NICK_NAME', 'NVL(D.NICK_NAME, '''') AS NICK_NAME');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'INCOTERMS', 'A.INCOTERMS');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'ITEM_TYPE', 'NVL(D.ITEM_TYPE, '''') AS ITEM_TYPE');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FCST_TYPE', 'A.FCST_TYPE');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'DOM_EXP', 'A.DOM_EXP');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'PLANT_SITE_ID', 'A.PLANT_SITE_ID');
				--INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FROM_SITE_ID', 'A.FROM_SITE_ID')		-- [PJ2024-50611] 소형 매출 프로세스 개선
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'VERSION_NO', 'A.VERSION_NO');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CUST_GROUP', 'C.CUST_GROUP');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CUST_GROUP_DTL', 'C.CUST_GROUP_DTL');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'OWNER', 'C.OWNER_NAME AS OWNER');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'APPLICATION', 'C.APPLICATION');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'ROUTE', 'C.ROUTE');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'MDM_PROJECT_NAME', 'D.MDM_PROJECT_NAME');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'MIN_CAPACITY', 'D.MIN_CAPACITY');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'BIZ_TYPE_NAME40', 'D.FORECAST_INFO_BIZ_TYPE AS BIZ_TYPE_NAME40');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FORECAST_INFO_PRODUCT_GROUP', 'D.FORECAST_INFO_PRODUCT_GROUP');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FORECAST_INFO_CELL_MODEL', 'C.ATTRIBUTE5 AS FORECAST_INFO_CELL_MODEL');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FORECAST_INFO_CELL_PACK_COUNT', 'D.FORECAST_INFO_CELL_PACK_COUNT');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FORECAST_INFO_ALL', 'D.FORECAST_INFO_SPEC + D.FORECAST_INFOR_VERSION AS FORECAST_INFO_ALL');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FORECAST_INFO_SPEC', 'D.FORECAST_INFO_SPEC');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FORECAST_INFOR_VERSION', 'D.FORECAST_INFOR_VERSION');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CELL_MODEL_NICK_NAME', 'NVL(F.NICK_NAME,'''') AS CELL_MODEL_NICK_NAME');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'VMI_YN', 'B.VMI_YN');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CELL_TYPE', 'E.SEGMENT2 AS CELL_TYPE');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CELL_PER_CAR', 'C.CELL_PER_CAR');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CELL_PER_MODULE', 'C.CELL_PER_MODULE');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'MODULE_PER_CAR', 'CASE WHEN C.CELL_PER_MODULE  <> 0 THEN C.CELL_PER_CAR / C.CELL_PER_MODULE ELSE 0 END AS MODULE_PER_CAR');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'ENERGE', 'D.ENERGE');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CELL_QUANTITY', 'D.CELL_QUANTITY');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'PRIORITY', 'C.ATTRIBUTE7 AS PRIORITY');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'MEASURE', 'CASE WHEN A.MEASURE = ''Customer FCST'' THEN
																																										(CASE WHEN A.LAST_UPDATED_BY LIKE ''%robot%'' THEN ''Cust.FCST_RPA[P || P]''
																																												 ELSE ''Cust.FCST_EXCEL[P || P]'' END)
																																							  WHEN A.MEASURE = ''Customer FCST[Org.]'' THEN
																																										(CASE WHEN A.LAST_UPDATED_BY LIKE ''%robot%'' THEN ''Cust.FCST_RPA[Org.]''
																																												 ELSE ''Cust.FCST_EXCEL[Org.]'' END)
																																							  ELSE A.MEASURE END AS MEASURE')
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'MEASURE_GROUP', 'M.MEASURE_GROUP');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'DMS_SALES', 'NVL(C.ATTRIBUTE1,'''') AS DMS_SALES');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'DMS_CUSTOMER', 'NVL(C.ATTRIBUTE2,'''') AS DMS_CUSTOMER');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'REPORT_GROUP6', 'C.REPORT_GROUP6');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'TEAM_NAME_KO', 'N.DEPT_NAME_KO AS TEAM_NAME_KO');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'DEPT_NAME_KO', 'O.DEPT_NAME_KO');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FORECAST_INFO_BIZ_TYPE', 'D.FORECAST_INFO_BIZ_TYPE');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'BIZ_TYPE', 'G.BIZ_TYPE');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SOLDTO_CUSTOMER', 'B.SOLDTO_CUSTOMER');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SCM_SITE_ID40', 'CASE WHEN A.DIVISION_ID = ''40'' THEN A.SCM_SITE_ID ELSE '''' END AS SCM_SITE_ID40');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SCP_USE_YN', 'CASE  WHEN A.DIVISION_ID IN (''40'') AND B.VMI_YN = ''Y'' AND A.MEASURE = ''VMI_In_Req''  THEN ''Y'';
																																									WHEN A.DIVISION_ID IN (''40'') AND B.VMI_YN = '''' AND A.MEASURE IN ( ''MKT_FCST_RP'',''MKT_FCST'' ) THEN ''Y''
																																									WHEN A.DIVISION_ID IN (''40'') AND B.VMI_YN = ''Y'' AND A.MEASURE = ''VMI_In_Plan'' THEN ''Y''
																																									WHEN A.DIVISION_ID IN (''40'') AND B.VMI_YN = '''' AND A.MEASURE in (''RTF'',''RTF_SCP'',''RTF_SYS_RP'') THEN ''Y''
																																									ELSE '''' END AS SCP_USE_YN')
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'VERSION_SORT', 'CASE WHEN A.VERSION_NO = ''CURRENT'' THEN ''ZZZZZZZZZZZZZZZ'' ELSE A.VERSION_NO END AS VERSION_SORT');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SCP_EXTRA_SPEC', 'D.SCP_EXTRA_SPEC');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SALES_COMPANY', 'C.SALES_COMPANY');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SOLDTO_CODE', 'B.SOLDTO_CODE');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'KWH_CELL', 'C.ATTRIBUTE8 AS KWH_CELL');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'KWH_MODULE', 'CASE WHEN A.DIVISION_ID LIKE ''81%'' AND C.CELL_PER_MODULE > 0 AND NVL(C.ATTRIBUTE8, '''') <> '''' THEN TO_NUMBER((C.CELL_PER_MODULE * C.ATTRIBUTE8))
																									ELSE NULL END
																									AS KWH_MODULE')
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'KWH_PACK', 'CASE WHEN A.DIVISION_ID LIKE ''81%'' AND C.CELL_PER_CAR > 0 AND NVL(C.ATTRIBUTE8, '''') <> '''' THEN TO_NUMBER((C.CELL_PER_CAR * C.ATTRIBUTE8))
																									ELSE NULL END
																									AS KWH_PACK')
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'LAST_UPDATE_DATE', 'A.CREATE_DATE AS LAST_UPDATE_DATE');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'LAST_UPDATED_BY', 'A.LAST_UPDATED_BY AS LAST_UPDATED_BY');
				--[E20241030-000923]_CUST_FCST 메져 추가
				--INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SENDER_CODE', 'CASE WHEN A.MEASURE IN (''CUST_FCST_EDI'', ''Immidiate'', ''Planning_Forecast'', ''Commercial_Agreement'', ''Firm_Temp'', ''Manumacturing_Material_Temp'', ''Material_Temp'', ''Backorder''
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SENDER_CODE', 'CASE WHEN A.MEASURE IN (''CUST_FCST'', ''CUST_FCST_EDI'', ''Immidiate'', ''Planning_Forecast'', ''Commercial_Agreement'', ''Firm_Temp'', ''Manumacturing_Material_Temp'', ''Material_Temp'', ''Backorder''
																																																   , ''CUST_FCST_EDI_ORG'', ''Immidiate[Org.]'', ''Planning_Forecast[Org.]'', ''Commercial_Agreement[Org.]'', ''Firm_Temp[Org.]'', ''Manumacturing_Material_Temp[Org.]'', ''Material_Temp[Org.]'', ''Backorder[Org.]'') THEN A.SENDER_CODE ELSE '' '' END AS SENDER_CODE')
				--[E20241030-000923]_CUST_FCST 메져 추가
				--INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SENDER_NAME', 'CASE WHEN A.MEASURE IN (''CUST_FCST_EDI'', ''Immidiate'', ''Planning_Forecast'', ''Commercial_Agreement'', ''Firm_Temp'', ''Manumacturing_Material_Temp'', ''Material_Temp'', ''Backorder''
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SENDER_NAME', 'CASE WHEN A.MEASURE IN (''CUST_FCST'', ''CUST_FCST_EDI'', ''Immidiate'', ''Planning_Forecast'', ''Commercial_Agreement'', ''Firm_Temp'', ''Manumacturing_Material_Temp'', ''Material_Temp'', ''Backorder''
																																																   , ''CUST_FCST_EDI_ORG'', ''Immidiate[Org.]'', ''Planning_Forecast[Org.]'', ''Commercial_Agreement[Org.]'', ''Firm_Temp[Org.]'', ''Manumacturing_Material_Temp[Org.]'', ''Material_Temp[Org.]'', ''Backorder[Org.]'') THEN A.SENDER_NAME ELSE '' '' END AS SENDER_NAME')
				--INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'AS_FROM_SITE', 'CASE WHEN A.DIVISION_ID = ''81'' THEN ''1'' ELSE '''' END AS_FROM_SITE') --20230825
				--[E20231121-000493] 82번사업부_MKT FCST Waterfall 화면 내 AS From Site 추가 요청
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'AS_FROM_SITE', 'CASE WHEN A.DIVISION_ID IN ( ''81'', ''82'') THEN A.AS_FROM_SITE ELSE '''' END AS_FROM_SITE'); --20230825

				--[E20231017-000634]
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CELL_NICKNAME',  'A.CELL_NICKNAME  AS CELL_NICKNAME');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'PRODUCT_LEVEL1', 'A.PRODUCT_LEVEL1 AS PRODUCT_LEVEL1');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'PRODUCT_LEVEL2', 'A.PRODUCT_LEVEL2 AS PRODUCT_LEVEL2');
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'PRODUCT_LEVEL3', 'A.PRODUCT_LEVEL3 AS PRODUCT_LEVEL3');
				--[E20231128-000738]해당컬럼으로 숫자표기형태를 구분하려고 하니, 해당 컬럼을 추출할수있도록 추가
				INSERT INTO GT_DMF0_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'NOTATION', 'A.NOTATION AS NOTATION');

			/* TODO:GTT:GT_DMF0_-->GT_DMF0_ */
			INSERT INTO GT_DMF0_
			SELECT B.COLUMN_STRING, ROW_NUMBER() OVER ( ORDER BY B.SORT_KEY ) AS SEQ
			FROM  UF_FX_String_Split(V_ColList, ',') A
			JOIN GT_DMF0_COLUMN_SETUP B ON replace(replace(A.TOKEN, '[', ''), ']','') = B.COLUMN_NAME

			DECLARE V_I INTEGER, V_CNT INTEGER

			SELECT 1,
    COUNT(*),
    '',
    ''
  INTO V_I, V_CNT, V_SQL_SELECT, V_SQL_GROUPBY
			FROM GT_DMF0_;

			WHILE ( V_I <= V_CNT ) LOOP
				SELECT V_SQL_SELECT = V_SQL_SELECT  ||  CASE WHEN V_I = 1 THEN '' ELSE ',' END  ||  COLUMN_STRING
					, V_SQL_GROUPBY = V_SQL_GROUPBY  ||  CASE WHEN V_I = 1 THEN '' ELSE ',' END
													 ||  CASE WHEN PATINDEX('% AS %', COLUMN_STRING) > 0
																	THEN SUBSTR(COLUMN_STRING, 1, PATINDEX('% AS %', COLUMN_STRING) -1)
														ELSE COLUMN_STRING
														END LOOP;
				FROM GT_DMF0_
				WHERE SEQ = V_I

				SET V_I  || = 1

			END;
		END;

--select * from GT_DMF0_RAW_DATA; return;

		--[E20231017-000634] SCP정보수집
		INSERT INTO GT_DMF0_SCP_ITEM_INFO (DIVISION_ID, ITEM_ID,	  CELL_NICKNAME, BASIC_NICKNAME_CELL40, NICKNAME_40
								  , GROUP_CODE1, GROUP_CODE4, GROUP_CODE5,	 GROUP_CODE6, GROUP_CODE7
								  , CELL_TYPE_GROUP_NAME)
		SELECT *
		FROM (
			SELECT  SCP_P.DIVISION_ID
				  , SCP_P.ITEM_ID
				  , SCP_P.CELL_NICKNAME
				  , SCP_P.BASIC_NICKNAME_CELL40
				  , SCP_P.NICKNAME_40
				  , SCP_P.GROUP_CODE1
				  , SCP_P.GROUP_CODE4
				  , SCP_P.GROUP_CODE5
				  , SCP_P.GROUP_CODE6
				  , SCP_P.GROUP_CODE7
				  , CASE WHEN SCP_P.LEVEL_EXCEPT = 'EC' THEN 'POUCH'
						 WHEN SCP_P.LEVEL_EXCEPT = 'AM' THEN 'CYLINDRICAL'
						 WHEN SUBSTR(SCP_P.ITEM_ID, 3, 1) = 'M' AND SCP_P.OPERATION_ID = 'P9500' THEN 'POUCH'
					ELSE SCP_G.CELL_TYPE_GROUP_NAME END AS CELL_TYPE_GROUP_NAME
			FROM (/* GT_DMF0_DYNAMICPIVOT_SCP0017_P */
					SELECT DIVISION_ID
						, FLOW_ID                       AS OPERATION_ID
						, ITEM_ID
						, SUBSTR(A.ITEM_ID, 3, 1)    AS CELL_TYPE_CODE
						, SUBSTR(A.ITEM_ID, 1, 2)    AS LEVEL_EXCEPT -- 예외적용
						, CASE WHEN SUBSTR(A.DIVISION_ID, 1, 2) = '81'  THEN GROUP_CODE1
								WHEN A.DIVISION_ID = '82'                  THEN LEVEL2_CODE
							ELSE '' END AS CELL_NICKNAME
						, CASE WHEN SUBSTR(A.ITEM_ID, 1, 2) = 'EC' THEN 'ESS'
							   WHEN SUBSTR(A.ITEM_ID, 1, 2) = 'AM' THEN 'M50L'
						  ELSE CASE WHEN A.OPERATION_GROUP = 'P' THEN (SELECT NICK_NAME FROM SCP_MST_FINAL_ITEM B
																	   WHERE B.DIVISION_ID = A.DIVISION_ID
																		--[E20240920-000300]_SCM.DM 화면 조회 속도 개선 원소스 주석처리
																		--AND B.ITEM_ID = (SELECTDOE FROM SCM_MST_ITEM_SN B
																		AND B.ITEM_ID = (SELECT /*__FETCH_1__*/DOE FROM GT_DMF0_DM_MST_ITEM_SINGLE_ORI B
																						WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ATTRIBUTE1 AND B.DOE IS NOT NULL));
									ELSE (SELECT NICK_NAME FROM SCP_MST_FINAL_ITEM B
										  WHERE B.DIVISION_ID = A.DIVISION_ID
										  --[E20240920-000300]_SCM.DM 화면 조회 속도 개선 원소스 주석처리
										  --AND B.ITEM_ID = (SELECT /*__FETCH_1__*/DOE FROM SCM_MST_ITEM_SN B
										  AND B.ITEM_ID = (SELECT /*__FETCH_1__*/DOE FROM GT_DMF0_DM_MST_ITEM_SINGLE_ORI B
										  WHERE B.DIVISION_ID = A.DIVISION_ID AND B.ITEM_ID = A.ITEM_ID AND B.DOE IS NOT NULL)) END
FETCH FIRST 1 ROWS ONLY
						  END  AS BASIC_NICKNAME_CELL40
						, A.NICK_NAME  AS NICKNAME_40
						, A.GROUP_CODE4
						, A.GROUP_CODE5
						, A.GROUP_CODE6
						, A.GROUP_CODE7
						, A.GROUP_CODE1
						, CASE WHEN A.FLOW_ID IN ('A3000', 'A9000') THEN 'C' ELSE 'E' END  AS FLOW_TYPE
					FROM    SCP_MST_FINAL_ITEM A
					WHERE   1=1
					  AND (SUBSTR(A.ATTRIBUTE8, 1, 2) <> 'CA' OR A.ATTRIBUTE8 IS NULL OR A.ATTRIBUTE8 IS NULL) --활성화코드 분리
					  AND A.DIVISION_ID = p_division_id
					  AND (( p_item_id IS NULL OR p_item_id IS NULL) OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(fn_string_split(p_item_id , ','))))
					  --AND (( P_OPERATION_GROUP	IS NULL OR P_OPERATION_GROUP IS NULL) OR A.OPERATION_GROUP	IN (SELECT TOKEN FROM TABLE(fn_string_split(P_OPERATION_GROUP, ','))))
			) SCP_P;
			LEFT OUTER JOIN (
							/* GT_DMF0_DYNAMICPIVOT_SCP0017_C */
							SELECT  A.CODE                    AS CELL_TYPE_CODE
								, SUBSTR(A.NAME, 1, 1)   AS FLOW_TYPE
								, A.GROUP_CODE              AS CELL_TYPE_GROUP_CODE
								, G.NAME                    AS CELL_TYPE_GROUP_NAME
								, A.DISPLAY_SEQ
							FROM
							(
								SELECT    B.SEGMENT1 CODE
										, B.SEGMENT2 NAME
										, B.SEGMENT3 GROUP_CODE
										, B.DISPLAY_SEQ
								FROM    SCM_ADM_LOOKUP_MASTER A
								JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B  ON A.LOOKUP_TYPE = B.LOOKUP_TYPE
								AND B.VALID_YN = 'Y'
								WHERE   1=1
								 AND A.LOOKUP_TYPE   = 'CELL_TYPE_ITEM_CODE'
								 AND A.VALID_YN      = 'Y'
							) A;
							JOIN
							(
								SELECT    B.SEGMENT1 CODE
										, B.SEGMENT2 NAME
								FROM    SCM_ADM_LOOKUP_MASTER A
								JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B  ON A.LOOKUP_TYPE = B.LOOKUP_TYPE  AND B.VALID_YN = 'Y'
								WHERE   1=1
									AND A.LOOKUP_TYPE   = 'CELL_TYPE_ITEM_GROUP'
									AND A.VALID_YN      = 'Y'
							) G ON A.GROUP_CODE = G.CODE
			) SCP_G ON SCP_G.FLOW_TYPE = SCP_P.FLOW_TYPE AND SCP_G.CELL_TYPE_CODE  = SCP_P.CELL_TYPE_CODE
		)  T;

		/* (DM || SCP) */
		INSERT INTO  GT_DMF0_RAW_DATA_FINAL (;
						  VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
						, PLANT_SITE_ID
						--, FROM_SITE_ID
						, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, MEASURE, MEASURE_GROUP
						, YYYYMMDD, QTY, VALID_YN, PLAN_RESULT, GUBUN
						, CREATE_DATE, LAST_UPDATED_BY
						, SENDER_CODE, SENDER_NAME, AS_FROM_SITE, CELL_NICKNAME
						, PRODUCT_LEVEL1, PRODUCT_LEVEL2, PRODUCT_LEVEL3, NOTATION
						, CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
		)
		SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
			  , A.PLANT_SITE_ID
			  --, '-' AS FROM_SITE_ID				--[PJ2024-50611] 소형 매출 프로세스 개선
			  , A.ITEM_ID, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.MEASURE, A.MEASURE_GROUP
			  , A.YYYYMMDD, A.QTY, A.VALID_YN, A.PLAN_RESULT, A.GUBUN
			  , A.CREATE_DATE, A.LAST_UPDATED_BY
			  , A.SENDER_CODE, A.SENDER_NAME, A.AS_FROM_SITE
			  , B.CELL_NICKNAME  /* SUBSTR(A.DIVISION_ID, 1,2) = '81' (GROUP_CODE1) 82 ESS (LEVEL2_CODE)  40 소형 ('') */
			  , CASE WHEN SUBSTR(A.DIVISION_ID, 1,2) = '81' OR A.DIVISION_ID = '82' THEN GROUP_CODE6
					 ELSE B.CELL_TYPE_GROUP_NAME END PRODUCT_LEVEL1
			  , CASE WHEN SUBSTR(A.DIVISION_ID, 1,2) = '81' OR A.DIVISION_ID = '82' THEN GROUP_CODE7
					 ELSE B.BASIC_NICKNAME_CELL40 END PRODUCT_LEVEL2
			  , CASE WHEN SUBSTR(A.DIVISION_ID, 1,2) = '81' THEN GROUP_CODE5
					 WHEN A.DIVISION_ID = '82'				  THEN GROUP_CODE4
					 ELSE B.NICKNAME_40 END PRODUCT_LEVEL3
			  , NVL(C.SEGMENT3, 'DEFAULT') AS NOTATION
			  , A.CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
		FROM GT_DMF0_RAW_DATA A
		--LEFT OUTER JOIN SCP_MST_FINAL_ITEM  B   ON A.DIVISION_ID = B.DIVISION_ID AND A.ITEM_ID = B.ITEM_ID
		LEFT OUTER JOIN GT_DMF0_SCP_ITEM_INFO B   ON A.DIVISION_ID = B.DIVISION_ID AND A.ITEM_ID = B.ITEM_ID
		LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C (NOLOCK) ON C.LOOKUP_TYPE = 'DM_MEASURE_POSITIONAL_NOTATION' AND A.MEASURE = C.SEGMENT2 AND A.DIVISION_ID = C.SEGMENT1
		WHERE 1=1;


	--[E20240102-000545]_마케팅PI 82번 사업부 - VMI표기 로직 개선  START
	-- ----------------------------------------------------------------------------------------------------------------------
	/*
	CSR번호: [E20240102-000545]_마케팅PI 82번 사업부 - VMI표기 로직 개선
	요청자: 오윤종
	작업이유: VMI_INV 메져의 데이터가 필요하다는 요청에 따라, 데이터를 생성하지는 않고,
			조회하는 기간 내에는 마지막 VMI_INV를 뿌려달라는 요청에 따라 해당 부분작업을 생성한다.
	대상데이터: VMI_INV는 MKT_FCST 데이터에 영향을 받으므로,
			  VMI_INV 메져가 생성된 날짜 이후에 MKT_FCST메져의 QTY가 0이 아닌 VMI_INV 메져를 대상으로 데이터를 추출한다.
	*/
	-- ----------------------------------------------------------------------------------------------------------------------
	--82번 사업부만 작업요청 대상
	DBMS_OUTPUT.PUT_LINE('VMIINV--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

	IF p_division_id = '82' THEN

		EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_VmiInv';

		IF ( p_version_no LIKE '%CURRENT%' ) THEN
			--1). 해당 PERIOD 기간내의 VMI_INV, MKT_FCST, VMI_In_Plan, VMI_In_Req가 존재하는 데이터를 우선 구해서 TEMP에 넣어둔다.

			INSERT INTO GT_DMF0_VmiInv
			( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
			 ,CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
			)
			SELECT B.DIVISION_ID, B.PROJECT_CODE, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE, B.YYYYMMDD, B.PLANT_SITE_ID, B.QTY
			,B.CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
			FROM
			(
				SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
					 , RANK() OVER ( PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, MEASURE, CELL_PROD_SITE_ID ORDER BY YYYYMMDD DESC) AS SEQ -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					 , CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
				FROM
				(
					SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
					,'-' AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					FROM DM_PLN_MKT_FCST
					WHERE DIVISION_ID = p_division_id
					AND MEASURE IN ('VMI_INV', 'MKT_FCST', 'VMI_In_Plan', 'VMI_In_Req')
					AND QTY <> 0
					AND YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
					UNION ALL
					SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
					--,'-' AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					, CELL_PROD_SITE_ID		-- [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
					FROM DM_PLN_MKT_FCST_RESULT
					WHERE DIVISION_ID = p_division_id
					AND MEASURE IN ('VMI_INV', 'MKT_FCST', 'VMI_In_Plan', 'VMI_In_Req')
					AND QTY <> 0
					AND YYYYMMDD >= p_from_yyyymmdd
					AND YYYYMMDD < TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD') --RESULT 데이터를 참고하는 경우에는 당주 월요일 이전 데이터를 가져와야된다.
				) A;
			) B;
			WHERE SEQ = '1';
		ELSE
			INSERT INTO GT_DMF0_VmiInv
			( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
			 ,CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
			)
			SELECT B.DIVISION_ID, B.PROJECT_CODE, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE, B.YYYYMMDD, B.PLANT_SITE_ID, B.QTY
			,B.CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
			FROM
			(
				SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
					 , RANK() OVER ( PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, MEASURE ORDER BY YYYYMMDD DESC) AS SEQ
					 , CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
				FROM
				(
					SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
					,'-' AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					FROM DM_PLN_MKT_FCST_C
					WHERE DIVISION_ID = p_division_id
					AND MEASURE IN ('VMI_INV', 'MKT_FCST', 'VMI_In_Plan', 'VMI_In_Req')
					AND QTY <> 0
					AND YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
					UNION ALL
					SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
					,'-' AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					FROM DM_PLN_MKT_FCST_RESULT_C
					WHERE DIVISION_ID = p_division_id
					AND MEASURE IN ('VMI_INV', 'MKT_FCST', 'VMI_In_Plan', 'VMI_In_Req')
					AND QTY <> 0
					AND YYYYMMDD >= p_from_yyyymmdd
					AND YYYYMMDD < TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD') --RESULT 데이터를 참고하는 경우에는 당주 월요일 이전 데이터를 가져와야된다.
				) A;
			) B;
			WHERE SEQ = '1';
		END IF;

		--2). 아이템둘 중, 'VMI_INV'메져의 YYYYMMDD보다 'MKT_FCST', 'VMI_In_Plan', 'VMI_In_Req'메져는 대상정보에서 삭제한다.
		DELETE C
		FROM GT_DMF0_VmiInv C
		JOIN
		(
			SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
			FROM
				(
					SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
					, CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					FROM GT_DMF0_VmiInv
					WHERE MEASURE = 'VMI_INV'
				) A;
			JOIN (
					SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY
					, CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					FROM GT_DMF0_VmiInv
					WHERE MEASURE IN ('MKT_FCST', 'VMI_In_Plan', 'VMI_In_Req')
				 ) B;
			  ON A.DIVISION_ID		= B.DIVISION_ID
			 AND A.PROJECT_CODE		= B.PROJECT_CODE
			 AND A.SCM_SITE_ID		= B.SCM_SITE_ID
			 AND A.ITEM_ID			= B.ITEM_ID
			 AND A.DOM_EXP			= B.DOM_EXP
			 AND A.FCST_TYPE		= B.FCST_TYPE
			 AND A.INCOTERMS		= B.INCOTERMS
			 AND A.PLANT_SITE_ID	= B.PLANT_SITE_ID
			 AND B.YYYYMMDD		   >= A.YYYYMMDD || 1
			 AND A.CELL_PROD_SITE_ID= B.CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
		) T;
		ON C.DIVISION_ID		= T.DIVISION_ID
		AND C.PROJECT_CODE		= T.PROJECT_CODE
		AND C.SCM_SITE_ID		= T.SCM_SITE_ID
		AND C.ITEM_ID			= T.ITEM_ID
		AND C.DOM_EXP			= T.DOM_EXP
		AND C.FCST_TYPE			= T.FCST_TYPE
		AND C.INCOTERMS			= T.INCOTERMS
		AND C.PLANT_SITE_ID		= T.PLANT_SITE_ID
		AND C.CELL_PROD_SITE_ID	= T.CELL_PROD_SITE_ID; -- [PJ2025-50017] CELL_PROD_SITE_ID 추가

		--3). 'VMI_INV' 메져 외의 타 데이터는 모두 삭제한다.
		DELETE
		FROM GT_DMF0_VmiInv
		WHERE MEASURE IN ('MKT_FCST', 'VMI_In_Plan', 'VMI_In_Req');

		--4). 들어가있는 데이터와 형식을 동일하게 맞추기위해서, 데이터 형식을 맞춰주는 작업을 진행한다.
		/* TODO:GTT:GT_DMF0_VmiInvResult-->GT_DMF0_VmiInvResult */
		INSERT INTO GT_DMF0_VmiInvResult
		SELECT B.VERSION_NO, B.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.MEASURE
			 , B.MEASURE_GROUP, A.YYYYMMDD, A.QTY, B.VALID_YN, B.PLAN_RESULT, B.GUBUN, B.CREATE_DATE, B.LAST_UPDATED_BY, B.SENDER_CODE, B.SENDER_NAME, B.AS_FROM_SITE
			 , B.CELL_NICKNAME, B.PRODUCT_LEVEL1, B.PRODUCT_LEVEL2, B.PRODUCT_LEVEL3, B.NOTATION
			 , B.CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
		FROM GT_DMF0_VmiInv A
		JOIN GT_DMF0_RAW_DATA_FINAL B
		  ON A.DIVISION_ID		= B.DIVISION_ID
		 AND A.PROJECT_CODE		= B.PROJECT_CODE
		 AND A.SCM_SITE_ID		= B.SCM_SITE_ID
		 AND A.ITEM_ID			= B.ITEM_ID
		 AND A.DOM_EXP			= B.DOM_EXP
		 AND A.FCST_TYPE		= B.FCST_TYPE
		 AND A.INCOTERMS		= B.INCOTERMS
		 AND A.MEASURE			= B.MEASURE
		 AND A.PLANT_SITE_ID	= B.PLANT_SITE_ID
		 AND A.YYYYMMDD			= B.YYYYMMDD
		 AND A.CELL_PROD_SITE_ID= B.CELL_PROD_SITE_ID; -- [PJ2025-50017] CELL_PROD_SITE_ID 추가

		--5). PERIOD 기간만큼 데이터를 생성한다.
		INSERT INTO GT_DMF0_VmiInvResult
		( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE
		, MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, VALID_YN, PLAN_RESULT, GUBUN, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE
		, SENDER_NAME, AS_FROM_SITE, CELL_NICKNAME, PRODUCT_LEVEL1, PRODUCT_LEVEL2, PRODUCT_LEVEL3, NOTATION
		, CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
		)
		SELECT DISTINCT	B.VERSION_NO, B.CUTOFF_YYYYMMDD, B.DIVISION_ID, B.PROJECT_CODE, B.SCM_SITE_ID, B.PLANT_SITE_ID, B.ITEM_ID, B.INCOTERMS, B.DOM_EXP, B.FCST_TYPE, B.MEASURE
			 , B.MEASURE_GROUP, A.BASIS_YYYYMMDD, B.QTY, B.VALID_YN, B.PLAN_RESULT, B.GUBUN, B.CREATE_DATE, B.LAST_UPDATED_BY, B.SENDER_CODE, B.SENDER_NAME, B.AS_FROM_SITE
			 , B.CELL_NICKNAME, B.PRODUCT_LEVEL1, B.PRODUCT_LEVEL2, B.PRODUCT_LEVEL3, B.NOTATION
			 , B.CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
		FROM SCM_SYS_CALENDAR_M A
		LEFT OUTER JOIN GT_DMF0_VmiInvResult B
					 ON A.BASIS_YYYYMMDD	> B.YYYYMMDD
		WHERE A.BASIS_YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
		AND A.BASIS_YYYYMMDD > B.YYYYMMDD;

		--모수로 잡았던 데이터는 삭제한다.
		DELETE A
		FROM GT_DMF0_VmiInvResult A
		WHERE DIVISION_ID = '82'
		AND MEASURE = 'VMI_INV'
		AND EXISTS ( SELECT division_id
					 FROM GT_DMF0_VmiInv Z
					 WHERE 1=1
  					 AND A.division_id    = Z.division_id
  					 AND A.project_code   = Z.project_code
					 AND A.scm_site_id    = Z.scm_site_id
					 AND A.item_id        = Z.item_id
					 AND A.dom_exp        = Z.dom_exp
					 AND A.fcst_type      = Z.fcst_type
					 AND A.incoterms      = Z.incoterms
					 AND A.plant_site_id  = Z.plant_site_id
					 AND A.YYYYMMDD		  = Z.YYYYMMDD
					 AND A.CELL_PROD_SITE_ID = Z.CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
					 );

		--6). 임시로 만든 데이터를, 주 임시테이블에 INSERT INTO 한다.
		INSERT INTO GT_DMF0_RAW_DATA_FINAL
		(  VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE
		 , MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, VALID_YN, PLAN_RESULT, GUBUN, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE
		 , SENDER_NAME, AS_FROM_SITE, CELL_NICKNAME, PRODUCT_LEVEL1, PRODUCT_LEVEL2, PRODUCT_LEVEL3, NOTATION
		 , CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
		 )
		SELECT VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE
			 , MEASURE, MEASURE_GROUP, YYYYMMDD, QTY, VALID_YN, PLAN_RESULT, GUBUN, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE
	  		 , SENDER_NAME, AS_FROM_SITE, CELL_NICKNAME, PRODUCT_LEVEL1, PRODUCT_LEVEL2, PRODUCT_LEVEL3, NOTATION
			 , CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
		FROM GT_DMF0_VmiInvResult;
	END IF;


	/* [PJ2024-50611] 소형 매출 프로세스 개선*/

	--IF p_division_id = '40'
	--BEGIN
	--	-- 1) GT_DMF0_RAW_DATA_FINAL 의 Measure = 'RTF_SYS_RP / RTF_SCP'가 있는 것은 삭제한다. 단, 계획구간에서만

	--	SELECT *
	--	INTO GT_DMF0_RAW_DATA_FINAL_TEMP40
	--	FROM GT_DMF0_RAW_DATA_FINAL
	--	WHERE DIVISION_ID = p_division_id
	--	AND   MEASURE IN ('RTF_SYS_RP','RTF_SCP','VMI_IN_PLAN','AS_IN_PLAN')
	--	AND   YYYYMMDD >= V_NOW_YYYYMMDD
	--	;

	--	SELECT  VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE
	--			, MEASURE, MEASURE_GROUP
	--			, VALID_YN, PLAN_RESULT, GUBUN, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME
	--			, AS_FROM_SITE, CELL_NICKNAME, PRODUCT_LEVEL1, PRODUCT_LEVEL2, PRODUCT_LEVEL3, NOTATION
	--			, CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가
	--	INTO GT_DMF0_RAW_DATA_FINAL_TEMP40_
	--	FROM GT_DMF0_RAW_DATA_FINAL_TEMP40
	--	GROUP BY VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, MEASURE, MEASURE_GROUP
	--			, VALID_YN, PLAN_RESULT, GUBUN, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME
	--			, AS_FROM_SITE, CELL_NICKNAME, PRODUCT_LEVEL1, PRODUCT_LEVEL2, PRODUCT_LEVEL3, NOTATION
	--			, CELL_PROD_SITE_ID-- [PJ2025-50017] CELL_PROD_SITE_ID 추가

	--	DELETE GT_DMF0_RAW_DATA_FINAL
	--	WHERE DIVISION_ID = p_division_id
	--	AND   MEASURE IN ('RTF_SYS_RP','RTF_SCP','VMI_IN_PLAN','AS_IN_PLAN')
	--	AND   YYYYMMDD >= V_NOW_YYYYMMDD
	--	;

	--	--[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
	--	--DM_PLN_RTF_ALLOCATION 관련 구문 삭제

	--	--IF ( p_version_no LIKE '%CURRENT%' )
	--	--BEGIN

	--	--	-- 2-1) GT_DMF0_RAW_DATA_FINAL 에 DM_PLN_RTF_ALLOCATION 기반으로 PLAN_SITE_ID 및 YYYYMMDD/QTY를 입력한다.

	--	--	INSERT INTO GT_DMF0_RAW_DATA_FINAL
	--	--	SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
	--	--		, B.PLANT_SITE_ID
	--	--		, B.FROM_SITE_ID
	--	--		, A.ITEM_ID, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.MEASURE, A.MEASURE_GROUP
	--	--		, B.YYYYMMDD, B.QTY
	--	--		, A.VALID_YN, A.PLAN_RESULT, A.GUBUN, A.CREATE_DATE, A.LAST_UPDATED_BY, A.SENDER_CODE, A.SENDER_NAME
	--	--		, A.AS_FROM_SITE, A.CELL_NICKNAME, A.PRODUCT_LEVEL1, A.PRODUCT_LEVEL2, A.PRODUCT_LEVEL3, A.NOTATION
	--	--	FROM GT_DMF0_RAW_DATA_FINAL_TEMP40_ A
	--	--	INNER JOIN DM_PLN_RTF_ALLOCATION B
	--	--	ON 1=1
	--	--	 AND  A.DIVISION_ID		= B.DIVISION_ID
	--	--	 AND  A.PROJECT_CODE	= B.PROJECT_CODE
	--	--	 AND  A.SCM_SITE_ID		= B.SCM_SITE_ID
	--	--	 AND  A.ITEM_ID			= B.ITEM_ID
	--	--	 AND  A.INCOTERMS		= B.INCOTERMS
	--	--	 AND  A.DOM_EXP			= B.DOM_EXP
	--	--	 AND  A.FCST_TYPE		= B.FCST_TYPE
	--	--	 AND  A.MEASURE			= B.MEASURE
	--	--	 AND  B.YYYYMMDD		>= V_NOW_YYYYMMDD
	--	--;

	--	--END
	--	--ELSE IF ( p_version_no LIKE '%MF%' OR p_version_no LIKE '%ME%')
	--	--BEGIN

	--	--	-- 2-2) GT_DMF0_RAW_DATA_FINAL 에 DM_PLN_RTF_ALLOCATION_C 기반으로 PLAN_SITE_ID 및 YYYYMMDD/QTY를 입력한다.

	--	--	INSERT INTO GT_DMF0_RAW_DATA_FINAL
	--	--	SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
	--	--		, B.PLANT_SITE_ID
	--	--		, B.FROM_SITE_ID
	--	--		, A.ITEM_ID, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.MEASURE, A.MEASURE_GROUP
	--	--		, B.YYYYMMDD, B.QTY
	--	--		, A.VALID_YN, A.PLAN_RESULT, A.GUBUN, A.CREATE_DATE, A.LAST_UPDATED_BY, A.SENDER_CODE, A.SENDER_NAME
	--	--		, A.AS_FROM_SITE, A.CELL_NICKNAME, A.PRODUCT_LEVEL1, A.PRODUCT_LEVEL2, A.PRODUCT_LEVEL3, A.NOTATION
	--	--	FROM GT_DMF0_RAW_DATA_FINAL_TEMP40_ A
	--	--	INNER JOIN DM_PLN_RTF_ALLOCATION_C B
	--	--	ON 1=1
	--	--	 AND  A.VERSION_NO		= B.VERSION_NO
	--	--	 AND  A.CUTOFF_YYYYMMDD = B.CUTOFF_YYYYMMDD
	--	--	 AND  A.DIVISION_ID		= B.DIVISION_ID
	--	--	 AND  A.PROJECT_CODE	= B.PROJECT_CODE
	--	--	 AND  A.SCM_SITE_ID		= B.SCM_SITE_ID
	--	--	 AND  A.ITEM_ID			= B.ITEM_ID
	--	--	 AND  A.INCOTERMS		= B.INCOTERMS
	--	--	 AND  A.DOM_EXP			= B.DOM_EXP
	--	--	 AND  A.FCST_TYPE		= B.FCST_TYPE
	--	--	 AND  A.MEASURE			= B.MEASURE
	--	--	 AND  B.YYYYMMDD		>= V_NOW_YYYYMMDD
	--	--;


	--	--END
	--END

	/* v_sql_text 안쪽데이타 빼냄 */
	BEGIN
		/* TODO:GTT:GT_DMF0_CALENDAR-->GT_DMF0_CALENDAR */
		INSERT INTO GT_DMF0_CALENDAR
		SELECT A.BASIS_YYYYMMWW, A.ISO_YYYYWW, A.ISO_WEEK, B.BASIS_YYYYMMDD, B.END_FLAG, B.BASIS_YYYYMM
		FROM (
			SELECT SUBSTR(MAX(BASIS_YYYYMMDD),1,6)  ||  ISO_WEEK AS BASIS_YYYYMMWW, ISO_YYYYWW,  ISO_WEEK
			FROM SCM_SYS_CALENDAR_M
			WHERE BASIS_YYYYMMDD >=  P_FROM_YYYYMMDD
			AND	  BASIS_YYYYMMDD <=  P_TO_YYYYMMDD
			GROUP BY  ISO_YYYYWW, ISO_WEEK
		) AS A
		JOIN SCM_SYS_CALENDAR_M B
		ON A.ISO_YYYYWW = B.ISO_YYYYWW
		AND A.ISO_WEEK = B.ISO_WEEK;

		/* TODO:GTT:GT_DMF0_CAL_MONTH_END_DATE-->GT_DMF0_CAL_MONTH_END_DATE */
		INSERT INTO GT_DMF0_CAL_MONTH_END_DATE
		SELECT MAX(BASIS_YYYYMMDD) AS MONTH_END_DATE
          FROM SCM_SYS_CALENDAR_M
         WHERE BASIS_YYYYMMDD BETWEEN  P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
         GROUP BY BASIS_YYYYMM;

		/* TODO:GTT:GT_DMF0_CAL_WEEK_END_DATE-->GT_DMF0_CAL_WEEK_END_DATE */
		INSERT INTO GT_DMF0_CAL_WEEK_END_DATE
		SELECT MAX(BASIS_YYYYMMDD) AS WEEK_END_DATE
          FROM SCM_SYS_CALENDAR_M
         WHERE BASIS_YYYYMMDD BETWEEN  P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
         GROUP BY ISO_YYYYWW || PARTIAL_WEEK_NAME;
	END;

--[E20240102-000545]_마케팅PI 82번 사업부 - VMI표기 로직 개선  END
-- ----------------------------------------------------------------------------------------------------------------------
		--[E20230906-000992]ENERGY MEASURE에 한해 표기형식변경 (MKT FCST 화면값과 일치화)
		--SELECT cast(CASE WHEN ''Y'' = ''V_CellQtyYN'' AND A.MEASURE_GROUP NOT in ( ''SFA'',''VMI_DIO'',''OVER_FCST'',''LESS_FCST'',''CFA'',''CFCR'' ) and NVL(D.FORECAST_INFO_CELL_PACK_COUNT,1) <> 1  THEN A.QTY * D.FORECAST_INFO_CELL_PACK_COUNT ELSE A.QTY END as INTEGER) AS QTY

		v_sql_text := '
		SELECT CASE WHEN A.MEASURE  IN (''RTF_ENERGY'' ,''MKT_FCST_ENERGY'') THEN
					cast(CASE WHEN ''Y'' = ''V_CellQtyYN'' AND A.MEASURE_GROUP NOT in ( ''SFA'',''VMI_DIO'',''OVER_FCST'',''LESS_FCST'',''CFA'',''CFCR'' ) and NVL(D.FORECAST_INFO_CELL_PACK_COUNT,1) <> 1  THEN A.QTY * D.FORECAST_INFO_CELL_PACK_COUNT ELSE A.QTY END as NUMERIC(30,10))
		       ELSE
		            cast(CASE WHEN ''Y'' = ''V_CellQtyYN'' AND A.MEASURE_GROUP NOT in ( ''SFA'',''VMI_DIO'',''OVER_FCST'',''LESS_FCST'',''CFA'',''CFCR'' ) and NVL(D.FORECAST_INFO_CELL_PACK_COUNT,1) <> 1  THEN A.QTY * D.FORECAST_INFO_CELL_PACK_COUNT ELSE A.QTY END as INTEGER)
			   END AS QTY
			 , CASE WHEN '''  ||  P_BUCKET  ||  ''' = ''DAILY'' THEN A.YYYYMMDD ELSE '''' END AS YYYYMMDD
			 , CAL.BASIS_YYYYMM, CAL.ISO_WEEK, CAL.BASIS_YYYYMMWW
			 , M.SORT_ORDER_NO
			 , CASE WHEN C2.MONTH_END_DATE IS NOT NULL THEN ''Y'' ELSE '''' END AS MONTH_END_YN
             , CASE WHEN C3.WEEK_END_DATE IS NOT NULL THEN ''Y'' ELSE '''' END AS WEEK_END_YN
			 , C.PROJECT_S_OP_REPORT	--[E20241030-000923]_MKT FCST, MKT FCST Waterfall 화면 신규 컬럼 추가 요청 건
		 	 , CASE WHEN LENGTH(NVL(EE.ATTRIBUTE1,'''')) = 0 THEN ''Common'' ELSE EE.ATTRIBUTE1 END AS CELL_PROD_SITE_ID -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
            , V_SQL_SELECT
		INTO GT_DMF0_WF
		--FROM GT_DMF0_RAW_DATA A
		FROM GT_DMF0_RAW_DATA_FINAL A
        LEFT OUTER JOIN GT_DMF0_SCM_MST_SITE B   ON A.SCM_SITE_ID = B.SCM_SITE_ID AND A.DIVISION_ID = B.DIVISION_ID
		LEFT OUTER JOIN GT_DMF0_SCM_MST_SITE_ITEM C  ON  A.DIVISION_ID = C.DIVISION_ID	AND A.PROJECT_CODE = C.PROJECT_CODE AND A.SCM_SITE_ID = C.SCM_SITE_ID AND A.ITEM_ID = C.ITEM_ID
		LEFT OUTER JOIN GT_DMF0_DM_MST_ITEM_SINGLE_V D  ON A.DIVISION_ID = D.DIVISION_ID AND A.ITEM_ID = D.ITEM_ID
		LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL E  ON D.CELL_TYPE = E.SEGMENT1 AND E.LOOKUP_TYPE = ''CELL_TYPE''
		LEFT OUTER JOIN GT_DMF0_DM_MST_ITEM_SINGLE_V F  ON D.DIVISION_ID = F.DIVISION_ID AND NVL(D.FORECAST_INFO_CELL_MODEL,'''') = F.ITEM_ID
		LEFT OUTER JOIN SCM_MST_PROJECT G  ON A.DIVISION_ID = G.DIVISION_ID AND A.PROJECT_CODE = G.PROJECT_CODE
		LEFT OUTER JOIN SCP_MST_ITEM_GROUP_DETAIL I  ON A.DIVISION_ID = I.DIVISION_ID	AND A.PROJECT_CODE = I.PROJECT_CODE AND A.ITEM_ID = I.ITEM_ID
		JOIN GT_DMF0_SELECT_MEASURE M ON A.MEASURE = M.MEASURE

		--[PJ2024-50461] Team Mapping------------------------------------
		--LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO N  ON CASE WHEN A.DIVISION_ID = ''40'' THEN C.DEPT_ID ELSE B.DEPT_ID END = N.DEPT_ID
		LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO N  ON C.DEPT_ID = N.DEPT_ID
		--[PJ2024-50461] Team Mapping------------------------------------

		LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO O  ON N.UPPER_DEPT_ID = O.DEPT_ID
		JOIN GT_DMF0_CALENDAR						CAL ON A.YYYYMMDD = CAL.BASIS_YYYYMMDD
		LEFT OUTER JOIN GT_DMF0_CAL_MONTH_END_DATE C2 ON A.YYYYMMDD = C2.MONTH_END_DATE
        LEFT OUTER JOIN GT_DMF0_CAL_WEEK_END_DATE C3 ON A.yyyymmdd = C3.WEEK_END_DATE
		LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL EE
		ON  EE.LOOKUP_TYPE = ''SP_CELL_PROD_SITE''
		AND EE.SEGMENT1 = CASE WHEN LENGTH(NVL(A.CELL_PROD_SITE_ID,'''')) = 0 THEN ''-'' ELSE A.CELL_PROD_SITE_ID END -- [PJ2025-50017] CELL_PROD_SITE_ID 추가
		AND EE.SEGMENT2 = ''-''
		AND EE.SEGMENT3 = ''-''
		AND EE.SEGMENT4 = ''-''
		AND EE.SEGMENT5 = ''-''
		AND EE.VALID_YN = ''Y'';
		DBMS_OUTPUT.PUT_LINE(''H_p--'' + TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3') ');

		IF p_division_id = '40' THEN
			v_sql_text := v_sql_text  ||  '
								SELECT V_COLUMN
										, '  ||  V_PV_COL  ||  '
								FROM ( ';
		ELSE
			v_sql_text := v_sql_text  ||  '
								SELECT V_COLUMN
										, V_PV_COL_LIST
								FROM ( ';
		END IF;

		IF p_bucket = 'DAILY' THEN
			v_sql_text := v_sql_text  ||  '
								SELECT V_COLUMN, ''D_'' + F.YYYYMMDD AS YYYYMMDD, F.QTY
								FROM GT_DMF0_WF F
								WHERE F.QTY <> 0

								UNION ALL '
		END IF;

		IF p_bucket != 'ONLY_WEEKLY' THEN
			v_sql_text := v_sql_text  ||  '
						SELECT V_COLUMN, ''W_'' + F.BASIS_YYYYMM || F.ISO_WEEK AS YYYYMMDD
								, CASE WHEN F.MEASURE IN (''BALANCE'', ''VMI_Inv'', ''AS_Inv'', ''SS_LVL'', ''SS_GAP'' )
											THEN	CASE WHEN F.WEEK_END_YN = ''Y'' THEN SUM (F.QTY)
														ELSE 0
													END IF;
										WHEN F.MEASURE = ''LOC''
											THEN AVG(F.QTY)
										ELSE SUM(F.QTY)
									END AS QTY
						FROM GT_DMF0_WF F
						WHERE F.QTY <> 0
						GROUP BY V_COLUMN, F.BASIS_YYYYMM, F.ISO_WEEK, F.WEEK_END_YN

						UNION ALL
						SELECT V_COLUMN, ''M_'' + F.BASIS_YYYYMM AS YYYYMMDD
							, CASE WHEN F.MEASURE IN (''BALANCE'', ''VMI_Inv'', ''AS_Inv'', ''SS_LVL'', ''SS_GAP'' )
											THEN	CASE WHEN F.MONTH_END_YN = ''Y'' THEN SUM (F.QTY)
														ELSE 0
													END;
										WHEN F.MEASURE = ''LOC''
											THEN AVG(F.QTY)
										ELSE SUM(F.QTY)
									END AS QTY
						FROM GT_DMF0_WF F
						WHERE F.QTY <> 0
						GROUP BY V_COLUMN, F.BASIS_YYYYMM, F.MONTH_END_YN

						) F;
					PIVOT (
						SUM(QTY) FOR YYYYMMDD IN ( V_PV_LIST )
						) AS PVT
					ORDER BY V_ORDERBY;

					';
		ELSIF p_bucket = 'ONLY_WEEKLY' THEN
			v_sql_text := v_sql_text  ||  '
						SELECT V_COLUMN, ''W_'' + F.BASIS_YYYYMMWW AS YYYYMMDD
								, CASE WHEN F.MEASURE IN (''BALANCE'', ''VMI_Inv'', ''AS_Inv'', ''SS_LVL'', ''SS_GAP'' )
											THEN	CASE WHEN F.WEEK_END_YN = ''Y'' THEN SUM (F.QTY)
														ELSE 0
													END IF;
										WHEN F.MEASURE = ''LOC''
											THEN AVG(F.QTY)
										ELSE SUM(F.QTY)
									END AS QTY
						FROM GT_DMF0_WF F
						WHERE F.QTY <> 0
						GROUP BY V_COLUMN, F.BASIS_YYYYMMWW, F.ISO_WEEK, F.WEEK_END_YN
						) F;
					PIVOT (
						SUM(QTY) FOR YYYYMMDD IN ( V_PV_LIST )
						) AS PVT
					ORDER BY V_ORDERBY;

					';
		END;


DBMS_OUTPUT.PUT_LINE('H--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

	  --SELECT v_sql_text;
		v_sql_text := REPLACE(v_sql_text,'v_PV_COL_LIST'    , v_PV_LIST    );
		v_sql_text := REPLACE(v_sql_text,'v_PV_LIST'		, v_PV_LIST    );
		v_sql_text := REPLACE(v_sql_text,'v_column'			, V_ColList       );
		v_sql_text := REPLACE(v_sql_text,'v_orderby'		, V_OrderList      );
		v_sql_text := REPLACE(v_sql_text,'V_SQL_SELECT'		, V_SQL_SELECT      );
		v_sql_text := REPLACE(v_sql_text,'V_SQL_GROUPBY'		, V_SQL_GROUPBY      );
		v_sql_text := REPLACE(v_sql_text,'V_CellQtyYN'      , p_cell_yn);

		SP_EXECUTESQL v_sql_text;
--		print v_sql_text;

		SELECT ISO_WEEK, BASIS_DATE
		FROM SCM_SYS_CALENDAR_M
		WHERE BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD')

		-- 테스트용 코드
		--SELECT ISO_WEEK, BASIS_DATE
		--FROM SCM_SYS_CALENDAR_M
		--WHERE BASIS_YYYYMMDD = '20220725'


		-- 20190711 정열 관련 추가
		 /*

		SELECT V_ORDER || T1.COLUMN_NAME + ' ' + T1.DATA_SORT_METHOD_CODE + '
  INTO V_ORDER
		FROM   (
				SELECT U.COLUMN_NAME,U.DATA_SORT_METHOD_CODE
				--,SORT_ORDER_NO
				,CASE WHEN U.COLUMN_NAME = 'GROUP_ID' THEN  NVL(TU.SORT_ORDER_NO,95) - 0.5 ELSE U.SORT_ORDER_NO END AS SORT_ORDER_NO--kjj 수정(2024.6.24)
				FROM   SCM_MST_TITLESET_USER U  WITH(NOLOCK,INDEX (PK_SCM_MST_TITLESET_USER))
				       LEFT OUTER JOIN SCM_MST_TITLESET_USER TU
						ON     TU.PROGRAM_ID  = U.PROGRAM_ID
						AND    TU.SHEET_NAME  = U.SHEET_NAME
						AND    TU.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
						AND	   TU.COLUMN_NAME IN ('ITEM_ID')
						AND    TU.USER_ID = p_created_by

				WHERE  1 = 1
				AND    U.USER_INQUIRY_COLUMN_TYPE_CODE	= 'C'
				AND    U.PROGRAM_ID						= 'DMF0035'
				AND    U.SHEET_NAME						= 'Mkt Fcst Waterfall'
				AND    U.USER_ID						= p_created_by;

				/* kjj 수정(2024.6.24)
					UI 카테고리에서 GROUP_ID 표시되게 하였으므로 불필요한 UNION 제거
				*/
				/*
				UNION ALL
				SELECT  C.COLUMN_NAME, C.DATA_SORT_METHOD_CODE
				      , CASE WHEN C.COLUMN_NAME = 'GROUP_ID' THEN  NVL(U.SORT_ORDER_NO,135) - 0.5 ELSE C.SORT_ORDER_NO END AS SORT_ORDER_NO
				FROM   SCM_MST_SHEET_COLUMNS C
				       LEFT OUTER JOIN SCM_MST_TITLESET_USER U
						ON     U.PROGRAM_ID  = C.PROGRAM_ID
						AND    U.SHEET_NAME  = C.SHEET_NAME
						AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
						AND	   U.COLUMN_NAME IN ('ITEM_ID')
						AND    U.USER_ID = p_created_by
				WHERE  1 = 1
						AND    C.PROGRAM_ID  = 'DMF0035'
						AND    C.SHEET_NAME  = 'Mkt Fcst Waterfall'
						AND    C.COLUMN_NAME = 'GROUP_ID'
						AND    C.VISIBLE_FLAG = ''
						AND    C.DEFAULT_FLAG IS NULL
						AND    C.VALID_YN     = 'Y';
						*/
				) T1;
		ORDER BY T1.SORT_ORDER_NO; --20200508 KHSONG 팀이 그룹별 합산이 안되서 추가함
		--SELECT SUBSTR(V_ORDER, 1, LENGTH(V_ORDER) - 1) AS DATA_ORDER
		--SELECT V_ORDER + 'VERSION_SORT DESC, SORT_ORDER_NO' AS DATA_ORDER
		*/




		/* 2024/05/17   kcw3408		이동계획 판가 매출GROUP_ID( Item은 Group 기준으로 정렬) 추가) */
		 /*
		 kjj 수정(2024.6.24)
		 - GROUP_ID 화면표시 위해 SCM_MST_TITLESET_USER 조인 추가
		 - ITEM_ID의 정렬보다 무조건 바로 앞에 GROUP_ID가 위치하게
		 =>2024.06.25. 불필요한 정렬이므로 위의 정렬 값 그대로 리턴..추후 화면에서도 제거해야 함
		 */
		V_OrderList := REPLACE(V_OrderList,'['		, ''      );
		V_OrderList := REPLACE(V_OrderList,']'		, ''    );
		SELECT V_OrderList   AS DATA_ORDER


		--select * from GT_DMF0_SELECT_MEASURE

		-- xml확인할경우
		--SELECT CAST(v_sql_text AS TEXT)
		--FOR XML PATH('')--,ROOT('x')



--SELECT COUNT(*) FROM GT_DMF0_RAW_DATA




--execute SP_executesql V_NSQL2

DBMS_OUTPUT.PUT_LINE('I--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));


	-- ---------------------------------------------------------------------------------------
	--                                                       Temp Table 존재 여부 체크 (BEGIN)
	-- ---------------------------------------------------------------------------------------
	-- ---------------------------------------------------------------------------------------
	--                                                       Temp Table 존재 여부 체크 (END)
	-- ---------------------------------------------------------------------------------------
DBMS_OUTPUT.PUT_LINE('J--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

END;
/

CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0035_GET_SPREAD_TITLE
(
    P_START_YYYYMMDD  IN VARCHAR2,
    P_END_YYYYMMDD    IN VARCHAR2,
    P_CREATED_BY      IN VARCHAR2,
    P_DIVISION_ID     IN VARCHAR2,
    P_BUCKET          IN VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/****************************************************************************************************/
/* Program ID  : DM0035_GET_SPREAD_TITLE                                                             */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/02/05  pjs       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 2019/02/01	JYE		42, 44 추가                          */
/* 2021/11/03	rosia27		MKT FCST WATERFALL 속도개선												*/
/*
 * 2022/07/19	kdw2819		[C20220620-000567]GSCM DM 시스템의 수작업 LOSS 및 분석 용이하기 하귀 위한 기능 개선 ( Partail week의 경우 week만 표시)
 */
/* 2026.03.18   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발                                  */ 
/****************************************************************************************************/
/*****************************************************************************************************
 ※ 작성 Rule 
   1. 대문자, 소문자
      - 테이블, 컬럼, 변수는 소문자로 작성하고, 그 이외는 대문자로 통일
   2. Naming Rule - Prefix
      - 파라메터 : @p_
      - 변수 : 데이타 타입에 따라 @v_(문자), @n_(숫자), @d_(날짜)
   3. 들여쓰기 : 2 space
   4. 기타
      - SQL 수직 배치 : SQL 구문의 세로줄(왼쪽)로 맞춤, 컬럼이나 변수도 KEYWORD 이후 왼쪽 정렬
      - 콤마로 분리된 ID 가 여러 줄에 걸쳐 나올 때, 콤마를 라인의 처음에 위치
******************************************************************************************************/
IS

    V_USER_COL_CNT    PLS_INTEGER := 0;
    V_PROGRAM_ID      VARCHAR2(50 CHAR) := 'DMF0035';
    V_SHEET_NAME      VARCHAR2(50 CHAR) := 'Mkt Fcst Waterfall';

    /* ── EXCEPTION 블록 필수 변수 ── */
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100 CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
    D_EVENT_DATE    DATE := SYSDATE;

BEGIN

    /* ── 시작 로그 ── */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    /* ── 사용자 컬럼 설정 건수 조회 (Case 28/29: EXISTS 패턴) ── */
    BEGIN
        SELECT 1
        INTO   V_USER_COL_CNT
        FROM   DUAL
        WHERE  EXISTS (
            SELECT 1
            FROM   SCM_MST_TITLESET_USER U
            WHERE  1 = 1
            AND    U.PROGRAM_ID = V_PROGRAM_ID
            AND    U.SHEET_NAME = V_SHEET_NAME
            AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
            AND    U.USER_ID    = P_CREATED_BY
        );
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_USER_COL_CNT := 0;
    END;

    /* ── 메인 조회 결과 반환 (O_RC1) ── */
    IF V_USER_COL_CNT > 0 THEN

        OPEN O_RC1 FOR
        SELECT * FROM (
            /* ── 사용자 설정 컬럼 ── */
            SELECT U.PROGRAM_ID
                 , U.SHEET_NAME
                 , U.COLUMN_NAME
                 , C.COLUMN_LABEL_NAME
                 , TO_CHAR(U.SORT_ORDER_NO) AS SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
                 , U.DATA_SORT_METHOD_CODE
                 , C.SMALL_CLASS_LABEL_NAME
                 , C.LARGE_CLASS_LABEL_NAME
                 , '' AS DAY_CODE
                 , C.FIXED_FLAG
                 , C.COLUMN_WIDTH
                 , C.CELL_CONTROL_OBJECT_TYPE_CODE
                 , C.CELL_COMBO_DATA_TYPE
                 , TO_CHAR(C.DATA_SCALE_NUMBER) AS DATA_SCALE_NUMBER
                 , TO_CHAR(C.DATA_MAX_LENGTH) AS DATA_MAX_LENGTH
                 , C.HORIZONTAL_ALIGN_CODE
                 , C.UPPERCASE_APPLY_FLAG
                 , C.VISIBLE_FLAG
                 , C.DEFAULT_FLAG
                 , C.USER_SELECTABLE_FLAG
                 , C.VALID_YN
                 , C.DIVISION_ID
            FROM   SCM_MST_TITLESET_USER U
                 , SCM_MST_SHEET_COLUMNS C
            WHERE  1 = 1
            AND    U.PROGRAM_ID  = C.PROGRAM_ID
            AND    U.SHEET_NAME  = C.SHEET_NAME
            AND    U.COLUMN_NAME = C.COLUMN_NAME
            AND    U.PROGRAM_ID  = V_PROGRAM_ID
            AND    U.SHEET_NAME  = V_SHEET_NAME
            AND    U.USER_ID     = P_CREATED_BY
            AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
            AND    INSTR(',' || C.DIVISION_ID || ',', ',' || P_DIVISION_ID || ',') > 0

            UNION ALL

            /* ── 비노출 기본 컬럼 ── */
            SELECT C.PROGRAM_ID
                 , C.SHEET_NAME
                 , C.COLUMN_NAME
                 , C.COLUMN_LABEL_NAME
                 , TO_CHAR(C.SORT_ORDER_NO) AS SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
                 , C.DATA_SORT_METHOD_CODE
                 , C.SMALL_CLASS_LABEL_NAME
                 , C.LARGE_CLASS_LABEL_NAME
                 , '' AS DAY_CODE
                 , C.FIXED_FLAG
                 , C.COLUMN_WIDTH
                 , C.CELL_CONTROL_OBJECT_TYPE_CODE
                 , C.CELL_COMBO_DATA_TYPE
                 , TO_CHAR(C.DATA_SCALE_NUMBER) AS DATA_SCALE_NUMBER
                 , TO_CHAR(C.DATA_MAX_LENGTH) AS DATA_MAX_LENGTH
                 , C.HORIZONTAL_ALIGN_CODE
                 , C.UPPERCASE_APPLY_FLAG
                 , C.VISIBLE_FLAG
                 , C.DEFAULT_FLAG
                 , C.USER_SELECTABLE_FLAG
                 , C.VALID_YN
                 , C.DIVISION_ID
            FROM   SCM_MST_SHEET_COLUMNS C
            WHERE  1 = 1
            AND    C.PROGRAM_ID  = V_PROGRAM_ID
            AND    C.SHEET_NAME  = V_SHEET_NAME
            AND    C.VISIBLE_FLAG = ''
            AND    C.DEFAULT_FLAG = ''
            AND    C.VALID_YN     = 'Y'
            AND    INSTR(',' || C.DIVISION_ID || ',', ',' || P_DIVISION_ID || ',') > 0

            UNION ALL

            /* ── 캘린더 동적 컬럼 ── */
            SELECT V_PROGRAM_ID   AS PROGRAM_ID
                 , V_SHEET_NAME AS SHEET_NAME
                 , T.COLUMN_NAME
                 , T.COLUMN_LABEL_NAME
                 , T.SORT_ORDER_NO
                 , ''         AS DATA_SORT_METHOD_CODE
                 , T.SMALL_CLASS_LABEL_NAME
                 , T.LARGE_CLASS_LABEL_NAME
                 , T.DAY_CODE
                 , ''         AS FIXED_FLAG
                 , CASE WHEN P_BUCKET = 'ONLY_WEEKLY' THEN 100
                        ELSE 50 END AS COLUMN_WIDTH
                 , 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
                 , ''         AS CELL_COMBO_DATA_TYPE
                 , ''         AS DATA_SCALE_NUMBER
                 , ''         AS DATA_MAX_LENGTH
                 , 'R'        AS HORIZONTAL_ALIGN_CODE
                 , 'Y'        AS UPPERCASE_APPLY_FLAG
                 , 'Y'        AS VISIBLE_FLAG
                 , ''         AS DEFAULT_FLAG
                 , ''         AS USER_SELECTABLE_FLAG
                 , ''         AS VALID_YN
                 --, CASE WHEN CHARINDEX('81', @p_divisIon_id) > 0 OR CHARINDEX('82', @p_divisIon_id) > 0 THEN
                    --  CASE WHEN CHARINDEX('40', @p_divisIon_id) > 0 THEN '40,81,82'
                    --       ELSE '81,82' END
                 --  ELSE
                    --  '40'
                 --  END AS DIVISION_ID
                 , P_DIVISION_ID AS DIVISION_ID      -- 20190201
            FROM  (
                   SELECT 'D_' || A.BASIS_YYYYMMDD   AS COLUMN_NAME
                        , A.CALENDAR_DAY            AS COLUMN_LABEL_NAME
                        , A.WEEK_NAME               AS SMALL_CLASS_LABEL_NAME
                        , A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME
                        , A.DAYOFWEEK               AS DAY_CODE
                        , A.BASIS_YYYYMMDD || TO_CHAR(31) AS SORT_ORDER_NO
                   FROM   SCM_SYS_CALENDAR_M A
                   WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                   AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
                   AND    1 = CASE WHEN P_BUCKET = 'DAILY' THEN 1 ELSE 2 END
                   UNION ALL
                   SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK   AS COLUMN_NAME
                        , A.WEEK_NAME          AS COLUMN_LABEL_NAME
                        , A.WEEK_NAME          AS SMALL_CLASS_LABEL_NAME
                        , A.MONTH_NAME         AS LARGE_CLASS_LABEL_NAME
                        , ''                   AS DAY_CODE
                        , A.BASIS_START_DATE || TO_CHAR(21) AS SORT_ORDER_NO
                   FROM   SCM_SYS_CALENDAR_M A
                   WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                   AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
                   AND    1 = CASE WHEN P_BUCKET != 'ONLY_WEEKLY' THEN 1 ELSE 2 END
                   GROUP BY A.BASIS_YYYYMM
                          , A.ISO_WEEK
                          , A.WEEK_NAME
                          , A.MONTH_NAME
                          , A.BASIS_START_DATE
                   UNION ALL
                   SELECT 'M_' || A.BASIS_YYYYMM  AS COLUMN_NAME
                         , A.MONTH_NAME          AS COLUMN_LABEL_NAME
                         , A.MONTH_NAME          AS SMALL_CLASS_LABEL_NAME
                         , A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
                         , ''                    AS DAY_CODE
                         , MIN(A.BASIS_START_DATE) || '01' AS SORT_ORDER_NO
                   FROM    SCM_SYS_CALENDAR_M A
                   WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                   AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
                   AND    1 = CASE WHEN P_BUCKET != 'ONLY_WEEKLY' THEN 1 ELSE 2 END
                   GROUP BY A.BASIS_YYYYMM
                          , A.MONTH_NAME
                   -- [C20220620-000567]GSCM DM 시스템의 수작업 LOSS 및 분석 용이하기 하귀 위한 기능 개선 ( Partail week의 경우 week만 표시)
                   UNION ALL
                   SELECT 'W_' || SUBSTR(MAX(BASIS_YYYYMMDD), 1, 6) || ISO_WEEK AS COLUMN_NAME
                         , WEEK_NAME AS COLUMN_LABEL_NAME
                         , WEEK_NAME AS SMALL_CLASS_LABEL_NAME
                         , SUBSTR(MIN(BASIS_YYYYMMDD), 5, 2) || '.' || SUBSTR(MIN(BASIS_YYYYMMDD), 7, 2)
                         || ' ~ ' || SUBSTR(MAX(BASIS_YYYYMMDD), 5, 2) || '.' || SUBSTR(MAX(BASIS_YYYYMMDD), 7, 2)  AS LARGE_CLASS_LABEL_NAME
                         , ''                   AS DAY_CODE
                         , MAX(BASIS_YYYYMMDD) || TO_CHAR(21) AS SORT_ORDER_NO
                   FROM   SCM_SYS_CALENDAR_M A
                   WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
                   AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
                   AND    1 = CASE WHEN P_BUCKET = 'ONLY_WEEKLY' THEN 1 ELSE 2 END
                   GROUP BY ISO_YYYYWW, ISO_WEEK, WEEK_NAME
              ) T
        ) A
        WHERE INSTR(',' || A.DIVISION_ID || ',', ',' || P_DIVISION_ID || ',') > 0
        ORDER BY SORT_ORDER_NO;

    ELSE
        /* ── V_USER_COL_CNT = 0 : 기본 컬럼 설정 ── */
        OPEN O_RC1 FOR
        SELECT C.PROGRAM_ID
             , C.SHEET_NAME
             , C.COLUMN_NAME
             , C.COLUMN_LABEL_NAME
             , TO_CHAR(C.SORT_ORDER_NO) AS SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
             , C.DATA_SORT_METHOD_CODE
             , C.SMALL_CLASS_LABEL_NAME
             , C.LARGE_CLASS_LABEL_NAME
             , '' AS DAY_CODE
             , C.FIXED_FLAG
             , C.COLUMN_WIDTH
             , C.CELL_CONTROL_OBJECT_TYPE_CODE
             , C.CELL_COMBO_DATA_TYPE
             , TO_CHAR(C.DATA_SCALE_NUMBER) AS DATA_SCALE_NUMBER
             , TO_CHAR(C.DATA_MAX_LENGTH) AS DATA_MAX_LENGTH
             , C.HORIZONTAL_ALIGN_CODE
             , C.UPPERCASE_APPLY_FLAG
             , C.VISIBLE_FLAG
             , C.DEFAULT_FLAG
             , C.USER_SELECTABLE_FLAG
             , C.VALID_YN
             , C.DIVISION_ID
        FROM   SCM_MST_SHEET_COLUMNS C
        WHERE  1 = 1
        AND    C.PROGRAM_ID  = V_PROGRAM_ID
        AND    C.SHEET_NAME  = V_SHEET_NAME
        AND    C.DEFAULT_FLAG = 'Y'
        AND    C.VALID_YN     = 'Y'
        AND    INSTR(',' || C.DIVISION_ID || ',', ',' || P_DIVISION_ID || ',') > 0

        UNION ALL

        SELECT * FROM (
            /* ── 비노출 기본 컬럼 ── */
            SELECT C.PROGRAM_ID
                 , C.SHEET_NAME
                 , C.COLUMN_NAME
                 , C.COLUMN_LABEL_NAME
                 , TO_CHAR(C.SORT_ORDER_NO) AS SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
                 , C.DATA_SORT_METHOD_CODE
                 , C.SMALL_CLASS_LABEL_NAME
                 , C.LARGE_CLASS_LABEL_NAME
                 , '' AS DAY_CODE
                 , C.FIXED_FLAG
                 , C.COLUMN_WIDTH
                 , C.CELL_CONTROL_OBJECT_TYPE_CODE
                 , C.CELL_COMBO_DATA_TYPE
                 , TO_CHAR(C.DATA_SCALE_NUMBER) AS DATA_SCALE_NUMBER
                 , TO_CHAR(C.DATA_MAX_LENGTH) AS DATA_MAX_LENGTH
                 , C.HORIZONTAL_ALIGN_CODE
                 , C.UPPERCASE_APPLY_FLAG
                 , C.VISIBLE_FLAG
                 , C.DEFAULT_FLAG
                 , C.USER_SELECTABLE_FLAG
                 , C.VALID_YN
                 , C.DIVISION_ID
            FROM   SCM_MST_SHEET_COLUMNS C
            WHERE  1 = 1
            AND    C.PROGRAM_ID  = V_PROGRAM_ID
            AND    C.SHEET_NAME  = V_SHEET_NAME
            AND    C.VISIBLE_FLAG = ''
            AND    C.DEFAULT_FLAG = ''
            AND    C.VALID_YN     = 'Y'
            AND    INSTR(',' || C.DIVISION_ID || ',', ',' || P_DIVISION_ID || ',') > 0

            UNION ALL

            /* ── 캘린더 동적 컬럼 ── */
            SELECT V_PROGRAM_ID   AS PROGRAM_ID
                 , V_SHEET_NAME AS SHEET_NAME
                 , T.COLUMN_NAME
                 , T.COLUMN_LABEL_NAME
                 , T.SORT_ORDER_NO
                 , ''         AS DATA_SORT_METHOD_CODE
                 , T.SMALL_CLASS_LABEL_NAME
                 , T.LARGE_CLASS_LABEL_NAME
                 , T.DAY_CODE
                 , ''         AS FIXED_FLAG
                 , CASE WHEN P_BUCKET = 'ONLY_WEEKLY' THEN 100
                        ELSE 50 END AS COLUMN_WIDTH
                 , 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
                 , ''         AS CELL_COMBO_DATA_TYPE
                 , ''         AS DATA_SCALE_NUMBER
                 , ''         AS DATA_MAX_LENGTH
                 , 'R'        AS HORIZONTAL_ALIGN_CODE
                 , 'Y'        AS UPPERCASE_APPLY_FLAG
                 , 'Y'        AS VISIBLE_FLAG
                 , ''         AS DEFAULT_FLAG
                 , ''         AS USER_SELECTABLE_FLAG
                 , ''         AS VALID_YN
                 --, CASE WHEN CHARINDEX('81', @p_divisIon_id) > 0 OR CHARINDEX('82', @p_divisIon_id) > 0 THEN
                    --  CASE WHEN CHARINDEX('40', @p_divisIon_id) > 0 THEN '40,81,82'
                    --       ELSE '81,82' END
                 --  ELSE
                    --  '40'
                 --  END AS DIVISION_ID
                 , P_DIVISION_ID AS DIVISION_ID      -- 20190201
            FROM  (
                   SELECT 'D_' || A.BASIS_YYYYMMDD   AS COLUMN_NAME
                        , A.CALENDAR_DAY            AS COLUMN_LABEL_NAME
                        , A.WEEK_NAME               AS SMALL_CLASS_LABEL_NAME
                        , A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME
                        , A.DAYOFWEEK               AS DAY_CODE
                        , A.BASIS_YYYYMMDD || TO_CHAR(31) AS SORT_ORDER_NO
                   FROM   SCM_SYS_CALENDAR_M A
                   WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                   AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
                   AND    1 = CASE WHEN P_BUCKET = 'DAILY' THEN 1 ELSE 2 END
                   UNION ALL
                   SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK   AS COLUMN_NAME
                        , A.WEEK_NAME          AS COLUMN_LABEL_NAME
                        , A.WEEK_NAME          AS SMALL_CLASS_LABEL_NAME
                        , A.MONTH_NAME         AS LARGE_CLASS_LABEL_NAME
                        , ''                   AS DAY_CODE
                        , A.BASIS_START_DATE || TO_CHAR(21) AS SORT_ORDER_NO
                   FROM   SCM_SYS_CALENDAR_M A
                   WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                   AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
                   AND    1 = CASE WHEN P_BUCKET != 'ONLY_WEEKLY' THEN 1 ELSE 2 END
                   GROUP BY A.BASIS_YYYYMM
                          , A.ISO_WEEK
                          , A.WEEK_NAME
                          , A.MONTH_NAME
                          , A.BASIS_START_DATE
                   UNION ALL
                   SELECT 'M_' || A.BASIS_YYYYMM  AS COLUMN_NAME
                         , A.MONTH_NAME          AS COLUMN_LABEL_NAME
                         , A.MONTH_NAME          AS SMALL_CLASS_LABEL_NAME
                         , A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
                         , ''                    AS DAY_CODE
                         , MIN(A.BASIS_START_DATE) || '01' AS SORT_ORDER_NO
                   FROM    SCM_SYS_CALENDAR_M A
                   WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                   AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
                   AND    1 = CASE WHEN P_BUCKET != 'ONLY_WEEKLY' THEN 1 ELSE 2 END
                   GROUP BY A.BASIS_YYYYMM
                          , A.MONTH_NAME
                   -- [C20220620-000567]GSCM DM 시스템의 수작업 LOSS 및 분석 용이하기 하귀 위한 기능 개선 ( Partail week의 경우 week만 표시)
                   UNION ALL
                   SELECT 'W_' || SUBSTR(MAX(BASIS_YYYYMMDD), 1, 6) || ISO_WEEK  AS COLUMN_NAME
                         , WEEK_NAME AS COLUMN_LABEL_NAME
                         , WEEK_NAME AS SMALL_CLASS_LABEL_NAME
                         , SUBSTR(MIN(BASIS_YYYYMMDD), 5, 2) || '.' || SUBSTR(MIN(BASIS_YYYYMMDD), 7, 2)
                         || ' ~ ' || SUBSTR(MAX(BASIS_YYYYMMDD), 5, 2) || '.' || SUBSTR(MAX(BASIS_YYYYMMDD), 7, 2)  AS LARGE_CLASS_LABEL_NAME
                         , ''                   AS DAY_CODE
                         , MAX(BASIS_YYYYMMDD) || TO_CHAR(21) AS SORT_ORDER_NO
                   -- , 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
                   FROM   SCM_SYS_CALENDAR_M A
                   WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
                   AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
                   AND    1 = CASE WHEN P_BUCKET = 'ONLY_WEEKLY' THEN 1 ELSE 2 END
                   GROUP BY ISO_YYYYWW, ISO_WEEK, WEEK_NAME
                ) T
            ) A
            WHERE INSTR(',' || A.DIVISION_ID || ',', ',' || P_DIVISION_ID || ',') > 0
          ORDER BY SORT_ORDER_NO;

    END IF;

    /* ── 프로시저 처리 결과 반환 (O_RESULT_CURSOR) — 조회 성공 ── */
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

    /* ── 종료 로그 ── */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        -- 1) 트랜잭션이 있으면 ROLLBACK
        ROLLBACK;

        -- 2) 에러 정보 캡처
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_START_YYYYMMDD' VALUE P_START_YYYYMMDD,
            'P_END_YYYYMMDD'   VALUE P_END_YYYYMMDD,
            'P_CREATED_BY'     VALUE P_CREATED_BY,
            'P_DIVISION_ID'    VALUE P_DIVISION_ID,
            'P_BUCKET'         VALUE P_BUCKET
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        -- 3) 에러 로그 기록
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        -- 4) 에러 전파 (O_RESULT_CURSOR 미오픈)
        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;
END DMF0035_GET_SPREAD_TITLE;
/
