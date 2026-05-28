-- ============================================================================
-- ARCHIVED: 다음 SP들은 PKG_DMF0022 에 이미 등록되어 있어 standalone에서 제거됨
--          PKG 호출 권장: SCM_MGR.PKG_DMF0022.P_{SP_NAME}
-- ============================================================================


-- DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL → PKG_DMF0022.P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL
(
	  p_division_id		VARCHAR2
	, p_dept_id            VARCHAR2
	, p_end_customer       VARCHAR2
	, p_scm_site_id        VARCHAR2
	, p_project_code       VARCHAR2
	, p_item_id            VARCHAR2
	, p_item_type          VARCHAR2
	, p_from_yyyymmdd      VARCHAR2
	, p_now_yyyymmdd       VARCHAR2
	, p_to_yyyymmdd        VARCHAR2
	, p_created_by         VARCHAR2
	, p_plant_site_id      VARCHAR2
	, p_biztype            VARCHAR2
	, p_owner				VARCHAR2
	, p_internal_yn        VARCHAR2
	, p_cell_yn			VARCHAR2
	, p_version_type       VARCHAR2
	, p_bucket				VARCHAR2 -- 20211110 SALES PLAN WATERFALL 속도 개선
	, p_user_dept_id		VARCHAR2 -- JV Planner 일때 USER 부서정보로 SALES SITE ID 정보를 얻기 위해추가
	, p_group_id			VARCHAR2 -- JV Planner 일지 확인하기 위해 추가
)
AS

/*
 * ========================================
 * [변환검증] 2026-03-02 20:37:19
 * 파일: dbo.DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL.sql
 * ----------------------------------------
 * ⚠ IF: IF:32  END IF:28  차이:+4
 * ----------------------------------------
 * BEGIN 위치: L168, L312, L333, L353, L369, L627, L661, L685, L872, L951 ...
 * END;  위치: L324, L343, L359, L639, L654, L655, L674, L676, L698, L699 ...
 * ----------------------------------------
 * 힌트: END가 10개 더 많음 → 고아 END; 확인 필요
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */


    V_ColList VARCHAR2(4000 CHAR);
    V_OrderList VARCHAR2(4000 CHAR);
    v_nsql VARCHAR2(4000 CHAR);
    v_nsql2 VARCHAR2(4000 CHAR);
    p_program_id VARCHAR2(50) := 'DMF0022';
    p_sheet_name VARCHAR2(50) := 'Sales Plan Waterfall';
    V_MEASURE INTEGER := 0;
    i_count INTEGER := 0;
    v_user_mea_cnt INTEGER := 0;
    v_start_yyyymmdd VARCHAR2(8 CHAR);
    v_sql_text VARCHAR2(4000 CHAR);
    V_PV_LIST VARCHAR2(4000 CHAR);
    V_PV_COL_LIST VARCHAR2(4000 CHAR);
    v_column_name VARCHAR2(100 CHAR);
    v_column VARCHAR2(1000 CHAR);
    v_orderby VARCHAR2(1000 CHAR);
    v_column_text VARCHAR2(1000 CHAR);
    v_PV_column_name VARCHAR2(100 CHAR);
    v_PV_NAME VARCHAR2(50 CHAR);
    v_column_type VARCHAR2(50 CHAR);
    v_column_value VARCHAR2(50 CHAR);
    v_sort_order_no VARCHAR2(50 CHAR);
    v_sum_qty VARCHAR2(1000 CHAR);
    v_qty_div VARCHAR2(1000 CHAR);
    v_avg_qty VARCHAR2(1000 CHAR);
    V_SQL_SELECT VARCHAR2(4000 CHAR);
    V_SQL_GROUPBY VARCHAR2(4000 CHAR);
    v_cnt_1  INTEGER := 0;
    v_cnt_2  INTEGER := 0;
    v_cnt_3  INTEGER := 0;
    v_cnt_4  INTEGER := 0;
    v_cnt_5  INTEGER := 0;
    v_cnt_6  INTEGER := 0;
    v_cnt_7  INTEGER := 0;
    v_cnt_8  INTEGER := 0;
    v_cnt_9  INTEGER := 0;
BEGIN
		--			    V_Prod VARCHAR2(4000 CHAR);







	V_ColList := NULL;
	V_OrderList := NULL;
	V_Prod := NULL;




	-- --------------------------------------------------------------------------------------------------------------------------------
	-- 20200306 KHSONG 조회시작기간이 START DATE가 아닌경우 PRICE값을 가져오지 못하여 변수추가사용
	-- --------------------------------------------------------------------------------------------------------------------------------
	SELECT BASIS_START_DATE INTO v_start_yyyymmdd FROM SCM_SYS_CALENDAR_M  WHERE BASIS_YYYYMMDD = p_from_yyyymmdd;

	-- --------------------------------------------------------------------------------------------------------------------------------
	--[E20250529-001488]_화면에서 버전을 넘길때 주차까지 넘겨주기때문에, 아예 버전만 변수로 테이블에 받아서 생성한다. START
	-- --------------------------------------------------------------------------------------------------------------------------------
	EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_V_VERSION_NO';

	INSERT INTO GT_DMF0_V_VERSION_NO
	SELECT SUBSTR(token, 1, CASE WHEN INSTR(token, '(') = 0 THEN LENGTH(token) ELSE INSTR(token, '(')-1 END) AS VERSION_NO, NULL AS TOBE_VERSION_NO
	FROM TABLE(fn_string_split(p_version_type ,','));
	-- --------------------------------------------------------------------------------------------------------------------------------
	--[E20250529-001488]_화면에서 버전을 넘길때 주차까지 넘겨주기때문에, 아예 버전만 변수로 테이블에 받아서 생성한다. END
	-- --------------------------------------------------------------------------------------------------------------------------------
DBMS_OUTPUT.PUT_LINE(p_program_id  ||  ' : A001-- :'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3') );
 	-- --------------------------------------------------------------------------------------------------------------------------------
	-- Temp Table 존재 여부 체크 START
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- --------------------------------------------------------------------------------------------------------------------------------
  	--[E20240920-000300]_SCM.DM 화면 조회 속도 개선 START
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- --------------------------------------------------------------------------------------------------------------------------------
	--[E20240920-000300]_SCM.DM 화면 조회 속도 개선 END
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- Temp Table 존재 여부 체크 END
	-- --------------------------------------------------------------------------------------------------------------------------------
DBMS_OUTPUT.PUT_LINE(p_program_id  ||  ' : A002--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

	/* 미래 구간에 대해서는 SITE-ITEM에 있는것만 포함되어야 함. ( ETC 포함 ). 과거 구간은 전체 Data가 포함되어야 함.
	   단가는 조회조건에 있는 key 기준으로 포함이 되어야 함. 단가는 Weekly로 되어 있기 때문에 Daily로 변경되어야 함. 단위 환산이 되어야 함 */
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- 20200316 KHSONG C20200224-000109 START
	-- --------------------------------------------------------------------------------------------------------------------------------
	SELECT COUNT(*)
  INTO v_user_mea_cnt
	FROM   SCM_MST_TITLESET_USER U
	WHERE  1 = 1
	AND    U.PROGRAM_ID		= p_program_id
	AND    U.SHEET_NAME		= p_sheet_name
	AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
	AND    U.USER_ID		= p_created_by;

	IF v_user_mea_cnt = 0 THEN
		INSERT INTO SCM_MST_TITLESET_USER
		( USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE, COLUMN_NAME, SORT_ORDER_NO, SUB_TOTAL_FLAG
		, DATA_SORT_METHOD_CODE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
		SELECT p_created_by AS USER_ID, C.PROGRAM_ID AS PROGRAM_ID, C.SHEET_NAME, 'M' AS USER_INQUIRY_COLUMN_TYPE_CODE, C.COLUMN_NAME, C.SORT_ORDER_NO, '' AS SUB_TOTAL_FLAG
		, '' AS DATA_SORT_METHOD_CODE, p_created_by AS CREATED_BY, TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3') AS CREATION_DATE, p_created_by AS LAST_UPDATED_BY, TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3') AS LAST_UPDATE_DATE
		FROM   SCM_MST_SHEET_MEASURE C
		WHERE  1 = 1
		AND    C.PROGRAM_ID		= p_program_id
		AND    C.SHEET_NAME		= p_sheet_name
		AND    C.DEFAULT_FLAG	= 'Y'
		AND    C.VALID_YN		= 'Y';
	END IF;
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- 20200316 KHSONG C20200224-000109 END
	-- --------------------------------------------------------------------------------------------------------------------------------
DBMS_OUTPUT.PUT_LINE(p_program_id  ||  ' : A003--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
  	-- --------------------------------------------------------------------------------------------------------------------------------
	-- [E20250520-000574]_사업부와 사용여부에 따라서 데이터를 가지고 올수있도록 수정 START
	-- RTF_PR은 40 사업부만 사용하나, 생성은 모든 사업부에서 진행하게 되면서, 모든 사업부에 메져가 노출됨.
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- USER TITLE 정보와 MEASURE MASTER 정보를 JOIN하여 사업부별 정보를 보관한다.
	/* TODO:GTT:GT_DMF0_SCM_MST_SHEET_MEASURE-->GT_DMF0_SCM_MST_SHEET_MEASURE */
	INSERT INTO GT_DMF0_SCM_MST_SHEET_MEASURE
	SELECT T.USER_ID, T.MEASURE, T.SORT_ORDER_NO, T.SYSTEM_ADD, T.DIVISION_ID
	FROM (	SELECT A.USER_ID, A.MEASURE, A.SORT_ORDER_NO, A.SYSTEM_ADD, TOKEN AS DIVISION_ID
			FROM (	SELECT U.USER_ID, U.COLUMN_NAME AS MEASURE, U.SORT_ORDER_NO, B.DIVISION_ID, '' AS SYSTEM_ADD
					FROM SCM_MST_TITLESET_USER U
					INNER JOIN SCM_MST_SHEET_MEASURE B
							ON U.PROGRAM_ID		= B.PROGRAM_ID
						   AND U.SHEET_NAME		= B.SHEET_NAME
						   AND U.COLUMN_NAME	= B.COLUMN_NAME
					WHERE	1 = 1
					AND		U.PROGRAM_ID					= p_program_id
					AND		U.SHEET_NAME					= p_sheet_name
					AND		U.USER_INQUIRY_COLUMN_TYPE_CODE	= 'M'
					AND		U.USER_ID						= p_created_by
					AND		B.VALID_YN						= 'Y' ) A
			CROSS JOIN TABLE(fn_string_split(A.DIVISION_ID, ',' ))) T
	WHERE T.DIVISION_ID = p_division_id;

	/* 과거 쿼리는 주석처리 한다.
	/* TODO:GTT:GT_DMF0_SELECT_MEASURE-->GT_DMF0_SELECT_MEASURE */
	INSERT INTO GT_DMF0_SELECT_MEASURE
	SELECT DISTINCT U.COLUMN_NAME AS MEASURE, U.SORT_ORDER_NO, '' AS SYSTEM_ADD
	-- 20191025 KHSONG 쿼리조건오류 수정반영 & WITH TEMP 조건 용량초과 오류로 일반 TEMP테이블 생성으로 구조 변경함
	FROM SCM_MST_TITLESET_USER U
	LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL T
			ON U.USER_ID		= T.SEGMENT4	-- 20200309 KHSONG TMM MEASURE 권한추가
			AND p_created_by = T.SEGMENT4	-- USER_ID
			AND T.LOOKUP_TYPE = 'TMM_MEASURE_ADMIN'
			AND T.VALID_YN	= 'Y'			-- VALID_YN 여부
	WHERE 1 = 1
	AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
	AND U.PROGRAM_ID   = p_program_id
	AND U.USER_ID      = p_created_by
	and U.USER_ID = CASE WHEN U.COLUMN_NAME = 'TMM_FCST' THEN T.SEGMENT4 ELSE p_created_by END; -- 20200309 KHSONG TMM MEASURE 권한추가  */

	/* TODO:GTT:GT_DMF0_SELECT_MEASURE-->GT_DMF0_SELECT_MEASURE */
	INSERT INTO GT_DMF0_SELECT_MEASURE
	SELECT DISTINCT U.MEASURE, U.SORT_ORDER_NO, U.SYSTEM_ADD
	FROM GT_DMF0_SCM_MST_SHEET_MEASURE U
	LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL T
		   ON U.USER_ID		= T.SEGMENT4	-- 20200309 KHSONG TMM MEASURE 권한추가
		  AND p_created_by	= T.SEGMENT4	-- USER_ID
		  AND T.LOOKUP_TYPE	= 'TMM_MEASURE_ADMIN'
		  AND T.VALID_YN	= 'Y'			-- VALID_YN 여부
	WHERE 1 = 1
	AND U.USER_ID = CASE WHEN U.MEASURE = 'TMM_FCST' THEN T.SEGMENT4 ELSE p_created_by	END;
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- [E20250520-000574]_사업부와 사용여부에 따라서 데이터를 가지고 올수있도록 수정 END
	-- --------------------------------------------------------------------------------------------------------------------------------
DBMS_OUTPUT.PUT_LINE(p_program_id  ||  ' : A004--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

	-- --------------------------------------------------------------------------------------------------------------------------------
	--[E20250529-001488]_MEASURE 추가할때마다 하드코딩으로 메져 추가하는 작업을 방지하기 위해 룩업으로 변경 원소스 주석처리 START
	-- --------------------------------------------------------------------------------------------------------------------------------
	/*
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- 하단에서 실적구간의 Price 를 구하기 위해서 RTF_SYS_RP 와 SalesAmt_KRW, LOC 를 추가해준다.  START
	-- --------------------------------------------------------------------------------------------------------------------------------
	IF (SELECT COUNT(1) FROM GT_DMF0_SELECT_MEASURE WHERE MEASURE IN ( 'LOC', 'KRW' )
) > 0
	BEGIN
		INSERT INTO GT_DMF0_SELECT_MEASURE
		( MEASURE, SYSTEM_ADD )
		SELECT A.MEASURE, 'Y'
		FROM (	SELECT 'RTF_SYS_RP' AS MEASURE
				UNION ALL
				SELECT 'SALESAMT_KRW' AS MEASURE
				UNION ALL
				SELECT 'SALESAMT_LOC' AS MEASURE ) A
		LEFT OUTER JOIN GT_DMF0_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
		WHERE B.MEASURE IS NULL
				FROM DUAL;
	END
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- 하단에서 실적구간의 Price 를 구하기 위해서 RTF_SYS_RP 와 SalesAmt_KRW, LOC 를 추가해준다.  END
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- MKT_FCST, RTF_SYS_RP로 MKT_FCST_RP를 만들기 위해 추가해준다.  START
	-- --------------------------------------------------------------------------------------------------------------------------------
	IF (SELECT COUNT(1) FROM GT_DMF0_SELECT_MEASURE WHERE MEASURE IN ( 'MKT_FCST_RP' )
) > 0
	BEGIN
		INSERT INTO GT_DMF0_SELECT_MEASURE
		( MEASURE, SYSTEM_ADD )
		SELECT A.MEASURE, 'Y'
		FROM (  SELECT 'MKT_FCST' AS MEASURE
				UNION ALL
				SELECT 'RTF_SYS_RP' AS MEASURE ) A
		LEFT OUTER JOIN GT_DMF0_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
		WHERE B.MEASURE IS NULL
				FROM DUAL;
	END
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- MKT_FCST, RTF_SYS_RP로 MKT_FCST_RP를 만들기 위해 추가해준다.  END
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- --------------------------------------------------------------------------------------------------------------------------------
	--[PJ2025-50017] Sales Plan 화면에서 RTF_PR 조회 시 실적구간은  RTF_SYS_RP 가져오도록 요청 START
	-- 하단에서 실적구간의 RTF_PR 를 구하기 위해서 RTF_SYS_RP 를 추가해준다.
	-- --------------------------------------------------------------------------------------------------------------------------------
	IF (SELECT COUNT(1) FROM GT_DMF0_SELECT_MEASURE WHERE MEASURE = 'RTF_PR'
) > 0
	BEGIN
		INSERT INTO GT_DMF0_SELECT_MEASURE ( MEASURE, SYSTEM_ADD )
		SELECT A.MEASURE, 'Y'
		FROM ( SELECT 'RTF_SYS_RP' AS MEASURE ) A
		LEFT OUTER JOIN GT_DMF0_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
		WHERE B.MEASURE IS NULL;
	END
	-- --------------------------------------------------------------------------------------------------------------------------------
	--[PJ2025-50017] Sales Plan 화면에서 RTF_PR 조회 시 실적구간은  RTF_SYS_RP 가져오도록 요청 END
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- [PJ2025-50188] 소형 매출계획 동기화 개선 고도화 : SCM_FCST 실적 추가 요청
	-- SCM_FCST 메저의 실적구간은 RTF_SYS_RP 를 가져와 보여주도록 한다.
	-- --------------------------------------------------------------------------------------------------------------------------------
	IF (SELECT COUNT(1) FROM GT_DMF0_SELECT_MEASURE WHERE MEASURE IN ( 'SCM_FCST' )
) > 0
	BEGIN
		INSERT INTO GT_DMF0_SELECT_MEASURE ( MEASURE, SYSTEM_ADD )
		SELECT A.MEASURE, 'Y'
		FROM (	SELECT 'RTF_SYS_RP' AS MEASURE) A
		LEFT OUTER JOIN GT_DMF0_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
		WHERE B.MEASURE IS NULL;
	*/

	/* TODO:GTT:GT_DMF0_PROGRAM_ADD_MEASURE-->GT_DMF0_PROGRAM_ADD_MEASURE */
	INSERT INTO GT_DMF0_PROGRAM_ADD_MEASURE
	SELECT T.UI_MEASURE, T.DB_MEASURE, T.PLAN_RESULT, 'Y' AS SYSTEM_ADD
	FROM
	(	SELECT A.COLUMN_NAME AS UI_MEASURE, TOKEN AS DB_MEASURE, PLAN_RESULT
		FROM (	SELECT COLUMN_NAME, NVL(REPLACE(ATTRIBUTE5, ' ', ''), '') AS ATTRIBUTE5
					 , CASE WHEN NVL(REPLACE(ATTRIBUTE5, ' ', ''), '') IS NOT NULL AND ATTRIBUTE7 = 'Y' THEN 'R'
							ELSE '' END AS PLAN_RESULT
				FROM SCM_MST_SHEET_MEASURE
				WHERE PROGRAM_ID	= p_program_id
				AND SHEET_NAME		= p_sheet_name
				AND VALID_YN		= 'Y'
				AND NVL(REPLACE(ATTRIBUTE5, ' ', ''), '') IS NOT NULL) A
		CROSS JOIN TABLE(fn_string_split(A.ATTRIBUTE5, ',' ))
		UNION ALL
		SELECT A.COLUMN_NAME AS UI_MEASURE, TOKEN AS DB_MEASURE, PLAN_RESULT
		FROM (	SELECT COLUMN_NAME, NVL(REPLACE(ATTRIBUTE6, ' ', ''), '') AS ATTRIBUTE6
					 , CASE WHEN NVL(REPLACE(ATTRIBUTE6, ' ', ''), '') IS NOT NULL AND ATTRIBUTE7 = 'Y' THEN 'P'
							ELSE '' END AS PLAN_RESULT
				FROM SCM_MST_SHEET_MEASURE
				WHERE PROGRAM_ID	= p_program_id
				AND SHEET_NAME		= p_sheet_name
				AND VALID_YN		= 'Y'
				AND NVL(REPLACE(ATTRIBUTE6, ' ', ''), '') IS NOT NULL) A
		CROSS JOIN TABLE(fn_string_split(A.ATTRIBUTE6, ',' ))
	) T;

	SELECT COUNT(1)
	INTO v_cnt_1
	FROM GT_DMF0_SELECT_MEASURE WHERE MEASURE IN ( SELECT UI_MEASURE FROM GT_DMF0_PROGRAM_ADD_MEASURE);
	IF v_cnt_1 > 0 THEN
		INSERT INTO GT_DMF0_SELECT_MEASURE
		( MEASURE, SYSTEM_ADD )
		SELECT A.DB_MEASURE AS MEASURE, A.SYSTEM_ADD
		FROM GT_DMF0_PROGRAM_ADD_MEASURE A
		LEFT OUTER JOIN GT_DMF0_SELECT_MEASURE B ON A.DB_MEASURE = B.MEASURE
		WHERE B.MEASURE IS NULL
		GROUP BY A.DB_MEASURE, A.SYSTEM_ADD;
	END IF;

	-- --------------------------------------------------------------------------------------------------------------------------------
	-- [E20250529-001488]_MEASURE 추가할때마다 하드코딩으로 메져 추가하는 작업을 방지하기 위해 룩업으로 변경 원소스 주석처리 END
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- [PJ2025-50188] 소형 매출계획 동기화 개선 고도화 : SCM_FCST 실적 추가 요청 END
	-- --------------------------------------------------------------------------------------------------------------------------------
DBMS_OUTPUT.PUT_LINE(p_program_id  ||  ' : A005--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

	EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_RAW_DATA';

 	-- --------------------------------------------------------------------------------------------------------------------------------
	-- CURRENT
	-- 계획구간: [FCST_TYPE: ETC외] DM_PLN_SALES_PLAN / [FCST_TYPE: ETC] DM_PLN_SALES_ETC_PLAN / 실적구간: DM_PLN_SALES_PLAN_RESULT
	-- --------------------------------------------------------------------------------------------------------------------------------
	IF ( p_version_type LIKE '%CURRENT%' ) THEN
		INSERT INTO GT_DMF0_RAW_DATA
		( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
		, TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE
		, YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID )  --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		SELECT 'CURRENT' AS VERSION_NO, NULL AS CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, PLANT_SITE_ID, A.ITEM_ID
			 , NVL(A.ATTRIBUTE9, NULL) AS TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, NULL AS COMPANY_ID, A.MEASURE
			 , A.YYYYMMDD, A.QTY, 'P' AS PLAN_RESULT
			--, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			 , CASE WHEN A.DIVISION_ID = '40' THEN A.CELL_PROD_SITE_ID ELSE '-' END -- [PJ2025-50188] 소형 매출계획 동기화 개선 고도화 : (HSJ20250528) 소형 외 사업부 CELL_PROD_SITE_ID 치환 로직 추가
		FROM DM_PLN_SALES_PLAN A
		JOIN GT_DMF0_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
		JOIN SCM_MST_SITE C
		  ON A.DIVISION_ID	= C.DIVISION_ID
		 AND A.SCM_SITE_ID	= C.SCM_SITE_ID
		 AND C.VALID_YN		= 'Y'
		--LEFT OUTER JOIN GT_DMF0_scm_mst_site_item D ON A.DIVISION_ID = D.DIVISION_ID AND A.PROJECT_CODE = D.PROJECT_CODE AND A.SCM_SITE_ID = D.SCM_SITE_ID AND A.ITEM_ID = D.ITEM_ID AND D.VALID_YN = 'Y'
		WHERE A.YYYYMMDD	>= p_now_yyyymmdd AND A.YYYYMMDD <= p_to_yyyymmdd
		AND   A.DIVISION_ID = p_division_id
		AND   A.QTY <> 0
		--마이그레이션 된 데이터 지우면 조건삭제
		AND	  A.FCST_TYPE	NOT IN ( SELECT DISTINCT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
									 WHERE LOOKUP_TYPE	= 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'
									 AND VALID_YN		= 'Y'
									 AND SEGMENT1		= A.DIVISION_ID )
		AND   A.ITEM_ID		NOT IN ( SELECT DISTINCT SEGMENT3 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
									 WHERE LOOKUP_TYPE	= 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'
									 AND VALID_YN		= 'Y'
									 AND SEGMENT1		= A.DIVISION_ID )
		AND	  A.MEASURE		NOT IN ( SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
									 WHERE LOOKUP_TYPE	= 'SALES_PLAN_CATCHUP'
									 AND VALID_YN		= 'Y' )
		-- --------------------------------------------------------------------------------------------------------------------------------
		-- [PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 신규 테이블 추가 START
		-- --------------------------------------------------------------------------------------------------------------------------------
		UNION ALL
		SELECT 'CURRENT' AS VERSION_NO, NULL AS CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, PLANT_SITE_ID, A.ITEM_ID
			 , A.REMARK_TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, NULL AS COMPANY_ID, A.MEASURE
			 , A.YYYYMMDD, A.QTY, 'P' AS PLAN_RESULT
			 , '-' AS CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		FROM DM_PLN_SALES_ETC_PLAN A
		JOIN GT_DMF0_SELECT_MEASURE B ON A.MEASURE	= B.MEASURE
		JOIN SCM_MST_SITE C
		  ON A.DIVISION_ID	= C.DIVISION_ID
		 AND A.SCM_SITE_ID	= C.SCM_SITE_ID
		 AND C.VALID_YN		= 'Y'
		--LEFT OUTER JOIN GT_DMF0_scm_mst_site_item D ON A.DIVISION_ID = D.DIVISION_ID AND A.PROJECT_CODE = D.PROJECT_CODE AND A.SCM_SITE_ID = D.SCM_SITE_ID AND A.ITEM_ID = D.ITEM_ID AND D.VALID_YN = 'Y'
		WHERE A.YYYYMMDD	>= p_now_yyyymmdd AND A.YYYYMMDD <= p_to_yyyymmdd
		AND   A.DIVISION_ID	= p_division_id
		AND   A.QTY <> 0
		-- --------------------------------------------------------------------------------------------------------------------------------
		-- [PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 신규 테이블 추가 END
		-- --------------------------------------------------------------------------------------------------------------------------------
		UNION ALL
		SELECT 'CURRENT' AS VERSION_NO, NULL AS CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, PLANT_SITE_ID, A.ITEM_ID
			 , NVL(A.ATTRIBUTE9, NULL) AS TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.MEASURE
			 , A.YYYYMMDD, A.QTY  ||  CASE WHEN p_internal_yn = 'Y' AND P_DIVISION_ID = '82' AND ISNUMERIC(A.ATTRIBUTE2) > 0 THEN CAST(A.ATTRIBUTE2 AS NUMERIC(30,10)) ELSE 0 END AS QTY, 'R' AS PLAN_RESULT
			 --, '-' AS CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			 , A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
		FROM DM_PLN_SALES_PLAN_RESULT A
		JOIN GT_DMF0_SELECT_MEASURE B  ON A.MEASURE = B.MEASURE
		WHERE A.YYYYMMDD	>= p_from_yyyymmdd AND A.YYYYMMDD < p_now_yyyymmdd
		AND   A.DIVISION_ID = p_division_id
		AND ( A.QTY <> 0 OR ISNUMERIC(NVL(A.ATTRIBUTE2, NULL))> 0) -- [C20200928-000147]
		AND   A.MEASURE NOT IN ('RTF_PR'); --[PJ2025-50017] Sales Plan 화면에서 RTF_PR 조회 시 실적구간은  RTF_SYS_RP 가져오도록 요청
	END IF;

DBMS_OUTPUT.PUT_LINE(p_program_id  ||  ' : A006--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
 	-- --------------------------------------------------------------------------------------------------------------------------------
	-- CUTOFF 데이터
	-- 계획구간: [FCST_TYPE: ETC외] DM_PLN_SALES_PLAN_C / [FCST_TYPE: ETC] DM_PLN_SALES_ETC_PLAN_C / 실적구간: DM_PLN_SALES_PLAN_RESULT_C
	-- --------------------------------------------------------------------------------------------------------------------------------
	IF ( p_version_type LIKE '%SP_%' ) THEN
		INSERT INTO GT_DMF0_RAW_DATA
		( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
		, TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE
		, YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID )   --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		--[E20250529-001488]_버전은 테이블에서 가지고온 순수 데이터로 조회한다 START
		/*SELECT CASE WHEN p_division_id ='82' AND E.DM_RTF_YN = '' THEN (A.VERSION_NO || '(' || D.WEEK_NAME || ') (NO PLAN)')
					WHEN p_division_id ='82' THEN (A.VERSION_NO || '(' || D.WEEK_NAME || ')')
					ELSE A.VERSION_NO END AS  VERSION_NO  -- [E20230130-000233] */
		SELECT  A.VERSION_NO
		--[E20250529-001488]_버전은 테이블에서 가지고온 순수 데이터로 조회한다 END
			 , A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
			 , NVL(A.ATTRIBUTE9, NULL) AS TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, NULL AS COMPANY_ID, A.MEASURE
			 , A.YYYYMMDD, A.QTY, 'P' AS PLAN_RESULT
		   --, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		  , CASE WHEN A.DIVISION_ID = '40' THEN A.CELL_PROD_SITE_ID ELSE '-' END -- [PJ2025-50188] 소형 매출계획 동기화 개선 고도화 : (HSJ20250528) 소형 외 사업부 CELL_PROD_SITE_ID 치환 로직 추가
		FROM DM_PLN_SALES_PLAN_C A
		JOIN GT_DMF0_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
		--[E20250529-001488]_버전은 위에서 만들어온 테이블에서 사용한 버전을 사용한다.
		JOIN GT_DMF0_V_VERSION_NO D ON A.VERSION_NO = D.VERSION_NO
		JOIN SCM_MST_SITE C
		  ON A.DIVISION_ID = C.DIVISION_ID
		 AND A.SCM_SITE_ID = C.SCM_SITE_ID
		 AND C.VALID_YN = 'Y'
		--LEFT OUTER JOIN GT_DMF0_scm_mst_site_item D ON A.DIVISION_ID = D.DIVISION_ID AND A.PROJECT_CODE = D.PROJECT_CODE AND A.SCM_SITE_ID = D.SCM_SITE_ID AND A.ITEM_ID = D.ITEM_ID AND D.VALID_YN = 'Y'
		--[E20250529-001488]_버전을 가공하지 않을것이므로, 하단의 내용은 필요하지 않으므로 주석처리 한다 START
		/* INNER JOIN SCM_SYS_CALENDAR_M D  ON A.CUTOFF_YYYYMMDD = D.BASIS_YYYYMMDD  --[E20230130-000233] --[E20240115-000325]  처리
		LEFT JOIN SCP_PLN_INTERFACE_YN E
			   ON A.DIVISION_ID			= E.DIVISION_ID
			  AND D.BASIS_START_DATE	= E.PLAN_START_YYYYMMDD --[E20230130-000233]  */
		--[E20250529-001488]_버전을 가공하지 않을것이므로, 하단의 내용은 필요하지 않으므로 주석처리 한다 END
		WHERE A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD <= p_to_yyyymmdd
		AND A.DIVISION_ID = p_division_id
		AND A.QTY <> 0
		--[E20250529-001488]_버전은 위에서 만들어온 테이블에서 사용한 버전을 사용한다.
		--AND A.VERSION_NO IN (SELECT SUBSTR(token, 1, CASE WHEN INSTR(token, '(') = 0 THEN LENGTH(token) ELSE INSTR(token, '(')-1 END) FROM TABLE(fn_string_split(p_version_type ,',')))
		--마이그레이션 된 데이터 지우면 조건삭제
		AND A.FCST_TYPE NOT IN ( SELECT DISTINCT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
								 WHERE LOOKUP_TYPE = 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'
								 AND VALID_YN = 'Y'
								 AND SEGMENT1 = A.DIVISION_ID )
		AND A.ITEM_ID NOT IN  ( SELECT DISTINCT SEGMENT3 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
								WHERE LOOKUP_TYPE = 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'
								AND VALID_YN = 'Y'
								AND SEGMENT1 = A.DIVISION_ID )
		AND A.MEASURE NOT IN (  SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
								WHERE LOOKUP_TYPE = 'SALES_PLAN_CATCHUP'
								AND VALID_YN = 'Y' )
		-- --------------------------------------------------------------------------------------------------------------------------------
		--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 신규 테이블 추가 START
		-- --------------------------------------------------------------------------------------------------------------------------------
		UNION ALL
		--[E20250529-001488]_버전은 테이블에서 가지고온 순수 데이터로 조회한다 START
		/*SELECT CASE WHEN p_division_id ='82' AND  E.DM_RTF_YN = ''  THEN (A.VERSION_NO || '(' || D.WEEK_NAME || ') (NO PLAN)')
					WHEN p_division_id ='82' THEN (A.VERSION_NO || '(' || D.WEEK_NAME || ')')
					ELSE A.VERSION_NO END AS  VERSION_NO  -- [E20230130-000233]  */
		SELECT  A.VERSION_NO
		--[E20250529-001488]_버전은 테이블에서 가지고온 순수 데이터로 조회한다 END
			 , A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
			 , A.REMARK_TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, NULL AS COMPANY_ID, A.MEASURE
			 , A.YYYYMMDD, A.QTY, 'P' AS PLAN_RESULT
			 , '-' AS CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		FROM DM_PLN_SALES_ETC_PLAN_C A
		JOIN GT_DMF0_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
		--[E20250529-001488]_버전은 위에서 만들어온 테이블에서 사용한 버전을 사용한다.
		JOIN GT_DMF0_V_VERSION_NO D ON A.VERSION_NO = D.VERSION_NO
		JOIN SCM_MST_SITE C
		  ON A.DIVISION_ID = C.DIVISION_ID
		 AND A.SCM_SITE_ID = C.SCM_SITE_ID
		 AND C.VALID_YN = 'Y'
		--LEFT OUTER JOIN GT_DMF0_scm_mst_site_item D ON A.DIVISION_ID = D.DIVISION_ID AND A.PROJECT_CODE = D.PROJECT_CODE AND A.SCM_SITE_ID = D.SCM_SITE_ID AND A.ITEM_ID = D.ITEM_ID AND D.VALID_YN = 'Y'
		--[E20250529-001488]_버전을 가공하지 않을것이므로, 하단의 내용은 필요하지 않으므로 주석처리 한다 START
		/* INNER JOIN SCM_SYS_CALENDAR_M D  ON A.CUTOFF_YYYYMMDD = D.BASIS_YYYYMMDD  --[E20230130-000233] --[E20240115-000325]  처리
		LEFT JOIN SCP_PLN_INTERFACE_YN E
			   ON A.DIVISION_ID			= E.DIVISION_ID
			  AND D.BASIS_START_DATE	= E.PLAN_START_YYYYMMDD --[E20230130-000233] */
		--[E20250529-001488]_버전을 가공하지 않을것이므로, 하단의 내용은 필요하지 않으므로 주석처리 한다 END
		WHERE A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD <= p_to_yyyymmdd
		AND A.DIVISION_ID = p_division_id
		AND A.QTY <> 0
		--[E20250529-001488]_버전은 위에서 만들어온 테이블에서 사용한 버전을 사용한다.
		--AND A.VERSION_NO IN (SELECT SUBSTR(token, 1, CASE WHEN INSTR(token, '(') = 0 THEN LENGTH(token) ELSE INSTR(token, '(')-1 END) FROM TABLE(fn_string_split(p_version_type ,',')))
		-- --------------------------------------------------------------------------------------------------------------------------------
		--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 신규 테이블 추가 END
		-- --------------------------------------------------------------------------------------------------------------------------------
		UNION ALL
		--[E20250529-001488]_버전은 테이블에서 가지고온 순수 데이터로 조회한다 START
		/*SELECT CASE WHEN p_division_id ='82' AND  E.DM_RTF_YN = ''  THEN (A.VERSION_NO || '(' || D.WEEK_NAME || ') (NO PLAN)')
					WHEN p_division_id ='82' THEN (A.VERSION_NO || '(' || D.WEEK_NAME || ')')
					ELSE A.VERSION_NO END AS  VERSION_NO  --[E20230130-000233]  */
		SELECT  A.VERSION_NO
		--[E20250529-001488]_버전은 테이블에서 가지고온 순수 데이터로 조회한다 END
			 , A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
			 , NVL(A.ATTRIBUTE9, NULL) AS TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.MEASURE
			 , A.YYYYMMDD, A.QTY  ||  CASE WHEN p_internal_yn = 'Y' AND P_DIVISION_ID = '82' AND ISNUMERIC(A.ATTRIBUTE2) > 0 THEN CAST(A.ATTRIBUTE2 AS NUMERIC(30,10)) ELSE 0 END AS QTY
			 , 'R' AS PLAN_RESULT
	  		 --,'-' AS CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			 , A.CELL_PROD_SITE_ID			--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
		FROM DM_PLN_SALES_PLAN_RESULT_C A
		JOIN GT_DMF0_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
		--[E20250529-001488]_버전은 위에서 만들어온 테이블에서 사용한 버전을 사용한다.
		JOIN GT_DMF0_V_VERSION_NO D ON A.VERSION_NO = D.VERSION_NO
		-- [C20220304-000114] Sales Plan Waterfall 조회 시 Unit Price 누락 건 조치 요청
		--[E20250529-001488]_버전을 가공하지 않을것이므로, 하단의 내용은 필요하지 않으므로 주석처리 한다 START
		/* INNER JOIN SCM_SYS_CALENDAR_M D  ON A.CUTOFF_YYYYMMDD = D.BASIS_YYYYMMDD  --[E20230130-000233]  [E20240115-000325]  처리
		LEFT JOIN SCP_PLN_INTERFACE_YN E
			   ON A.DIVISION_ID			= E.DIVISION_ID
			  AND D.BASIS_START_DATE	= E.PLAN_START_YYYYMMDD --[E20230130-000233] */
		--[E20250529-001488]_버전을 가공하지 않을것이므로, 하단의 내용은 필요하지 않으므로 주석처리 한다 END
		WHERE A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < TO_CHAR(FN_NEXT_DAY( A.CUTOFF_YYYYMMDD, 'MON') + (-7), 'YYYYMMDD')
		AND A.DIVISION_ID = p_division_id
		AND ( A.QTY <> 0 OR ISNUMERIC(NVL(A.ATTRIBUTE2, NULL))> 0) -- [C20200928-000147]
		--[E20250529-001488]_버전은 위에서 만들어온 테이블에서 사용한 버전을 사용한다. 원소스는 주석처리 한다
		--AND A.VERSION_NO IN (SELECT SUBSTR(token, 1, CASE WHEN INSTR(token, '(') = 0 THEN LENGTH(token) ELSE INSTR(token, '(')-1 END) FROM TABLE(fn_string_split(p_version_type ,',')))
		AND A.MEASURE NOT IN ('RTF_PR'); --[PJ2025-50017] Sales Plan 화면에서 RTF_PR 조회 시 실적구간은  RTF_SYS_RP 가져오도록 요청
	END IF;

DBMS_OUTPUT.PUT_LINE(p_program_id  ||  ' : A007--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	-- --------------------------------------------------------------------------------------------------------------------------------
	--[E20250529-001488]_신규로 생성한 메져 사용하기 여러 분기쳐서 동일한 쿼리를 사용할 필요가 없는 것으로 확인되어 기존 소스 주석처리하고 해당 부분으로 변경 START
	-- --------------------------------------------------------------------------------------------------------------------------------
	/*
	IF (SELECT COUNT(1) FROM GT_DMF0_SELECT_MEASURE WHERE MEASURE = 'MKT_FCST_RP'
) > 0
	BEGIN
		INSERT INTO GT_DMF0_RAW_DATA
		( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
		, TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE
		, YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID )   --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
			 , A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, 'MKT_FCST_RP' AS MEASURE
			 , A.YYYYMMDD, A.QTY, A.PLAN_RESULT, A.CELL_PROD_SITE_ID  --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		FROM GT_DMF0_RAW_DATA A
		WHERE A.MEASURE = 'MKT_FCST'
		AND A.YYYYMMDD >=  CASE WHEN VERSION_NO = 'CURRENT' THEN p_now_yyyymmdd
								ELSE TO_CHAR(FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON') + (-7), 'YYYYMMDD')
								END -- [C20200521-000202] Version cutoff 기준으로 MKT_FCST 조회
		AND A.YYYYMMDD <= p_to_yyyymmdd;

		INSERT INTO GT_DMF0_RAW_DATA
		( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
		, TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE
		, YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID )   --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
			 , A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, 'MKT_FCST_RP' AS MEASURE
			 , A.YYYYMMDD, A.QTY, A.PLAN_RESULT, A.CELL_PROD_SITE_ID   --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		FROM GT_DMF0_RAW_DATA A
		WHERE MEASURE = 'RTF_SYS_RP'
		AND A.YYYYMMDD >= p_from_yyyymmdd
		AND A.YYYYMMDD <   CASE WHEN VERSION_NO = 'CURRENT' THEN p_now_yyyymmdd
								ELSE TO_CHAR(FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON') + (-7), 'YYYYMMDD')
						   END -- [C20200521-000202] Version cutoff 기준으로 RTF 조회
	END
	-- --------------------------------------------------------------------------------------------------------------------------------
	--[PJ2025-50017] Sales Plan 화면에서 RTF_PR 조회 시 실적구간은  RTF_SYS_RP 가져오도록 요청 START
	-- --------------------------------------------------------------------------------------------------------------------------------
	IF (SELECT COUNT(1) FROM GT_DMF0_SELECT_MEASURE WHERE MEASURE = 'RTF_PR'
) > 0
	BEGIN
		INSERT INTO GT_DMF0_RAW_DATA
		( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
		, TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE
		, YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID )  --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		SELECT VERSION_NO, A.CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
			 , TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, 'RTF_PR' AS MEASURE
			 , YYYYMMDD, QTY, PLAN_RESULT, A.CELL_PROD_SITE_ID   --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		FROM GT_DMF0_RAW_DATA A
		WHERE MEASURE = 'RTF_SYS_RP'
		AND A.YYYYMMDD >= p_from_yyyymmdd
		AND A.YYYYMMDD <	CASE WHEN VERSION_NO = 'CURRENT' THEN p_now_yyyymmdd
								 ELSE TO_CHAR(FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON') + (-7), 'YYYYMMDD')
							END -- [C20200521-000202] Version cutoff 기준으로 RTF 조회

	END
	-- --------------------------------------------------------------------------------------------------------------------------------
	--[PJ2025-50017] Sales Plan 화면에서 RTF_PR 조회 시 실적구간은  RTF_SYS_RP 가져오도록 요청 END
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- [PJ2025-50188] 소형 매출계획 동기화 개선 고도화 : SCM_FCST 실적 추가 요청 START
	-- --------------------------------------------------------------------------------------------------------------------------------
	IF (SELECT COUNT(1) FROM GT_DMF0_SELECT_MEASURE WHERE MEASURE = 'SCM_FCST'
) > 0
	BEGIN
		INSERT INTO GT_DMF0_RAW_DATA
		( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
		, TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE
		, YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID )   --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		SELECT VERSION_NO, A.CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
			 , TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, 'SCM_FCST' AS MEASURE
			 , YYYYMMDD, QTY, PLAN_RESULT, A.CELL_PROD_SITE_ID   --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		FROM GT_DMF0_RAW_DATA A
		WHERE MEASURE = 'RTF_SYS_RP'
		AND A.YYYYMMDD >= p_from_yyyymmdd
		AND A.YYYYMMDD < CASE WHEN VERSION_NO = 'CURRENT' THEN p_now_yyyymmdd
							  ELSE TO_CHAR(FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON') + (-7), 'YYYYMMDD')
						 END -- [C20200521-000202] Version cutoff 기준으로 RTF 조회
	END
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- [PJ2025-50188] 소형 매출계획 동기화 개선 고도화 : SCM_FCST 실적 추가 요청 END
	-- --------------------------------------------------------------------------------------------------------------------------------
	*/
	SELECT COUNT(1)
	INTO v_cnt_2
	FROM GT_DMF0_PROGRAM_ADD_MEASURE A
	INNER JOIN GT_DMF0_SELECT_MEASURE B ON A.UI_MEASURE = B.MEASURE
	WHERE PLAN_RESULT = 'P';
	IF v_cnt_2 > 0 THEN
		INSERT INTO GT_DMF0_RAW_DATA
		( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
		, TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE
		, YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID )   --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
			 , A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, B.UI_MEASURE AS MEASURE
			 , A.YYYYMMDD, A.QTY, A.PLAN_RESULT, A.CELL_PROD_SITE_ID  --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		FROM GT_DMF0_RAW_DATA A
		INNER JOIN ( SELECT A.UI_MEASURE, A.DB_MEASURE FROM GT_DMF0_PROGRAM_ADD_MEASURE A
					 INNER JOIN GT_DMF0_SELECT_MEASURE B ON A.UI_MEASURE = B.MEASURE
					 WHERE PLAN_RESULT = 'P' ) B
				ON A.MEASURE = B.DB_MEASURE
		AND A.YYYYMMDD >=  CASE WHEN VERSION_NO = 'CURRENT' THEN p_now_yyyymmdd
								ELSE TO_CHAR(FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON') + (-7), 'YYYYMMDD')
								END IF;
		AND A.YYYYMMDD <= p_to_yyyymmdd;
	END;

	SELECT COUNT(1)
	INTO v_cnt_3
	FROM GT_DMF0_PROGRAM_ADD_MEASURE A
	INNER JOIN GT_DMF0_SELECT_MEASURE B ON A.UI_MEASURE = B.MEASURE
	WHERE PLAN_RESULT = 'R';
	IF v_cnt_3 > 0 THEN
		INSERT INTO GT_DMF0_RAW_DATA
		( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
		, TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE
		, YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID )
		SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
			 , A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, B.UI_MEASURE AS MEASURE
			 , A.YYYYMMDD, A.QTY, A.PLAN_RESULT, A.CELL_PROD_SITE_ID   --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		FROM GT_DMF0_RAW_DATA A
		INNER JOIN ( SELECT A.UI_MEASURE, A.DB_MEASURE FROM GT_DMF0_PROGRAM_ADD_MEASURE A
					 INNER JOIN GT_DMF0_SELECT_MEASURE B ON A.UI_MEASURE = B.MEASURE
					 WHERE PLAN_RESULT = 'R' ) B
				ON A.MEASURE = B.DB_MEASURE
		AND A.YYYYMMDD >= p_from_yyyymmdd
		AND A.YYYYMMDD <   CASE WHEN VERSION_NO = 'CURRENT' THEN p_now_yyyymmdd
								ELSE TO_CHAR(FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON') + (-7), 'YYYYMMDD')
						   END IF;
	END;
	-- --------------------------------------------------------------------------------------------------------------------------------
	--[E20250529-001488]_신규로 생성한 메져 사용하기 여러 분기쳐서 동일한 쿼리를 사용할 필요가 없는 것으로 확인되어 기존 소스 주석처리하고 해당 부분으로 변경 END
	-- --------------------------------------------------------------------------------------------------------------------------------
DBMS_OUTPUT.PUT_LINE(p_program_id  ||  ' : A008--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

  /* 20240308 kcw3408 index 추가 */
  --/* [E20240731-000852]_MDM에서 DM으로 ENERGE I/F 단위는 WH인데, 82사업부는 KW기준
						40번 사업부는 WH기준으로 보여주길 원하므로 82사업부인 경우에만 KWH로 나오도록 조건 추가
--[E20240731-000856]_[공급 SCM PI팀] Wh --> KWh 환산 로직개선 START
--해당 테이블의 데이터를 쓰므로, 데이터 완료된 후 KWH로 변경한다.
UPDATE GT_DMF0_DM_MST_ITEM_SINGLE_V
SET ENERGE = CASE WHEN ISNUMERIC(ENERGE) > 0 THEN ROUND((TO_NUMBER(ENERGE))/1000, 4) ELSE NULL END
FROM GT_DMF0_DM_MST_ITEM_SINGLE_V;
--[E20240731-000856]_[공급 SCM PI팀] Wh --> KWh 환산 로직개선 */

------------------------------------------------------------------------END
--[E20240115-000325] ▼ 주석처리
-- ----------------------------------------------------------------------------------------
----                               20191002 KHSONG 조회시 DB Lock 현상으로 로직수정 (BEGIN)
-- ----------------------------------------------------------------------------------------
--SELECT DISTINCT A.DIVISION_ID, A.ITEM_ID, ITEM_CLASS
--  , ITEM_NAME, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MIN_CAPACITY
--  , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_PRODUCT_GROUP
--  , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
--  , ENERGE, CELL_QUANTITY
--  , MDM_PROJECT_NAME, CELL_TYPE
-- INTO GT_DMF0_DM_MST_ITEM_SINGLE_V
-- FROM DM_MST_ITEM_SINGLE_V A    --[E20240115-000325]  처리
-- join ( select distinct division_id, item_id from GT_DMF0_RAW_DATA ) b on a.division_id = b.division_id and a.item_id = b.item_id
--WHERE A.DIVISION_ID = p_division_id

-- ----------------------------------------------------------------------------------------
----                               20191002 KHSONG 조회시 DB Lock 현상으로 로직수정 (END)
-- ----------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------
--                                 20190326 속도개선 ITEM_SINGLE_V TEMP TABLE 사용 (END)
-- ---------------------------------------------------------------------------------------
DBMS_OUTPUT.PUT_LINE(p_program_id  ||  ' : A010--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

	-- --------------------------------------------------------------------------------------------------------------------------------
	-- 20190326 오류개선 STUFF시 정렬오류로 멀티OWNER가 분리되는 오류발생으로 TEMP사용 (START)
	-- --------------------------------------------------------------------------------------------------------------------------------
	/* TODO:GTT:GT_DMF0_scm_mst_site_item-->GT_DMF0_scm_mst_site_item */
	INSERT INTO GT_DMF0_scm_mst_site_item
	SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, APPLICATION
		, CUST_GROUP, ROUTE, CUST_GROUP_DTL, CELL_PER_CAR, CELL_PER_MODULE
		, SALES_COMPANY, CURRENCY, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE5
		, ATTRIBUTE7, ATTRIBUTE8, REPORT_GROUP6, A.OWNER
		, FN_GET_DM_MKT_OWNER_NAME (a.OWNER, ',', 'EN' )                AS OWNER_NAME
		, FN_GET_DM_MKT_OWNER_NAME (a.OWNER, ',', 'KO' )                AS OWNER_NAME_KO
		,( SELECT SU.DEPT_ID FROM SCM_MST_SSO_USER_INFO SU
		   WHERE SU.USER_ID = (SELECTtoken FROM TABLE(fn_string_split(a.owner, ',')))) AS DEPT_ID
		, VALID_YN
	FROM SCM_MST_SITE_ITEM A
	JOIN ( SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID FROM GT_DMF0_RAW_DATA ) B
	  ON A.DIVISION_ID	= B.DIVISION_ID
	 AND A.SCM_SITE_ID	= B.SCM_SITE_ID
	 AND A.PROJECT_CODE = B.PROJECT_CODE
	 AND A.ITEM_ID		= B.ITEM_ID
	WHERE A.DIVISION_ID = p_division_id;
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- 20190326 오류개선 STUFF시 정렬오류로 멀티OWNER가 분리되는 오류발생으로 TEMP사용 (END)
	-- --------------------------------------------------------------------------------------------------------------------------------
DBMS_OUTPUT.PUT_LINE(p_program_id  ||  ' : A011--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
FETCH FIRST 1 ROWS ONLY;

	DELETE A
	FROM GT_DMF0_RAW_DATA A
	LEFT OUTER JOIN GT_DMF0_scm_mst_site_item B
				 ON A.DIVISION_ID	= B.DIVISION_ID
				AND A.PROJECT_CODE	= B.PROJECT_CODE
				AND A.SCM_SITE_ID	= B.SCM_SITE_ID
				AND A.ITEM_ID		= B.ITEM_ID
	WHERE A.PLAN_RESULT = 'P'
	--AND A.ITEM_ID NOT IN ('ETC', 'ED_D','TOOLING','MDF','Sample','SI','물동보상금')  --[PJ2024-50611] FCST_type을 하드코딩이 아니라 룩업에서 가져옴
	-- --------------------------------------------------------------------------------------------------------------------------------
	--[PJ2024-50611] FCST_type을 하드코딩이 아니라 룩업에서 가져옴 START
	-- --------------------------------------------------------------------------------------------------------------------------------
	AND A.ITEM_ID NOT IN ( SELECT SEGMENT3 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
						   WHERE LOOKUP_TYPE = 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'
						   AND SEGMENT1		 = A.DIVISION_ID )
	-- --------------------------------------------------------------------------------------------------------------------------------
	--[PJ2024-50611] FCST_type을 하드코딩이 아니라 룩업에서 가져옴 END
	-- --------------------------------------------------------------------------------------------------------------------------------
	AND NVL(B.VALID_YN, NULL) <> 'Y';
	--AND A.VERSION_NO = 'CURRENT' ( 수정 전 로직이 버전구분 없이 처리 )

DBMS_OUTPUT.PUT_LINE(p_program_id  ||  ' : A012--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

	-- --------------------------------------------------------------------------------------------------------------------------------
	--[PJ2024-50611] 화면에서 저장한 dept_id 업데이트 START
	-- --------------------------------------------------------------------------------------------------------------------------------
	UPDATE A
	SET ATTRIBUTE1 = B.ATTRIBUTE1
	FROM GT_DMF0_RAW_DATA A
	JOIN (	SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
				 , ATTRIBUTE1, REMARK_TEXT--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 필드추가
				 , '-' AS CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			--FROM DM_PLN_SALES_PLAN
			FROM DM_PLN_SALES_ETC_PLAN --[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 테이블 변경
			WHERE DIVISION_ID	= '40'
			AND	  FCST_TYPE		= 'ETC'
			AND   YYYYMMDD		>= p_now_yyyymmdd AND YYYYMMDD <= p_to_yyyymmdd
			AND   QTY			<> 0 ) B
	  ON  A.DIVISION_ID		= B.DIVISION_ID
	  AND A.PROJECT_CODE	= B.PROJECT_CODE
	  AND A.SCM_SITE_ID		= B.SCM_SITE_ID
	  AND A.ITEM_ID			= B.ITEM_ID
	  AND A.DOM_EXP			= B.DOM_EXP
	  AND A.FCST_TYPE		= B.FCST_TYPE
	  AND A.INCOTERMS		= B.INCOTERMS
	  AND A.PLANT_SITE_ID	= B.PLANT_SITE_ID
	  AND A.YYYYMMDD		= B.YYYYMMDD
	  AND A.TEXT			= B.REMARK_TEXT; --[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 조인추가
	-- --------------------------------------------------------------------------------------------------------------------------------
	--[PJ2024-50611] 화면에서 저장한 dept_id 처리 END
	-- --------------------------------------------------------------------------------------------------------------------------------
DBMS_OUTPUT.PUT_LINE(p_program_id  ||  ' : A013--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- 조회조건에 따른 필터링 처리 ( PRICE 계산시 부하문제로 필터링은 여기서 하고, 필요없는 메저는 PRICE 끝난 후 제거 ) START
	-- --------------------------------------------------------------------------------------------------------------------------------
	BEGIN -- 필터링 시작
		IF ( p_project_code IS NOT NULL) THEN
			DELETE A
			FROM GT_DMF0_RAW_DATA A
			JOIN SCM_MST_PROJECT B
			  ON A.DIVISION_ID	= B.DIVISION_ID
			 AND A.PROJECT_CODE = B.PROJECT_CODE
			LEFT OUTER JOIN ( SELECT DISTINCT token FROM TABLE(fn_string_split(p_project_code,','))) C ON B.PROJECT_CODE LIKE '%'  ||  C.TOKEN  ||  '%'
			LEFT OUTER JOIN ( SELECT DISTINCT token FROM TABLE(fn_string_split(p_project_code,','))) D ON B.PROJECT_NAME LIKE '%'  ||  D.TOKEN  ||  '%'
			WHERE C.TOKEN IS NULL AND D.TOKEN IS NULL;
		END IF;

		IF ( p_item_id IS NOT NULL) THEN
			DELETE A
			FROM GT_DMF0_RAW_DATA A
			LEFT OUTER JOIN GT_DMF0_DM_MST_ITEM_SINGLE_V B  ON A.ITEM_ID = B.ITEM_ID
			LEFT OUTER JOIN ( SELECT DISTINCT token FROM TABLE(fn_string_split(p_item_id,','))) C ON A.ITEM_ID LIKE '%'  ||  C.TOKEN  ||  '%'
			LEFT OUTER JOIN ( SELECT DISTINCT token FROM TABLE(fn_string_split(p_item_id,','))) D ON B.NICK_NAME LIKE '%'  ||  D.TOKEN  ||  '%'
			WHERE C.TOKEN IS NULL  AND D.TOKEN IS NULL;
		END IF;

		IF ( p_owner IS NOT NULL) THEN
			DELETE A
			FROM GT_DMF0_RAW_DATA A
			LEFT OUTER JOIN GT_DMF0_scm_mst_site_item B
						 ON A.ITEM_ID		= B.ITEM_ID
						AND A.SCM_SITE_ID	= B.SCM_SITE_ID
						AND A.PROJECT_CODE	= B.PROJECT_CODE
			LEFT OUTER JOIN ( SELECT DISTINCT token FROM TABLE(fn_string_split(p_owner,','))) C ON B.OWNER LIKE '%'  ||  C.TOKEN  ||  '%'
			LEFT OUTER JOIN ( SELECT DISTINCT token FROM TABLE(fn_string_split(p_owner,','))) D ON B.OWNER_NAME LIKE '%'  ||  D.TOKEN  ||  '%'
			LEFT OUTER JOIN ( SELECT DISTINCT token FROM TABLE(fn_string_split(p_owner,','))) E ON B.OWNER_NAME_KO LIKE '%'  ||  E.TOKEN  ||  '%'
			WHERE C.TOKEN IS NULL  AND D.TOKEN IS NULL  AND E.TOKEN IS NULL;
		END IF;

		IF ( p_dept_id <> 'ALL') THEN
			-- --------------------------------------------------------------------------------------------------------------------------------
			--[PJ2024-50461] Team Mapping
			-- --------------------------------------------------------------------------------------------------------------------------------
			--기타매출은 기존 SALE SITE 정보를 이용하므로 검색시도 구분해야함
			-- --------------------------------------------------------------------------------------------------------------------------------
			--기타매출 이외
			-- --------------------------------------------------------------------------------------------------------------------------------
			DELETE A
			FROM GT_DMF0_RAW_DATA A
			LEFT OUTER JOIN GT_DMF0_scm_mst_site_item B
						 ON A.ITEM_ID		= B.ITEM_ID
						AND A.SCM_SITE_ID	= B.SCM_SITE_ID
						AND A.PROJECT_CODE	= B.PROJECT_CODE
			LEFT OUTER JOIN ( SELECT DISTINCT token FROM TABLE(fn_string_split(p_dept_id,','))) C ON B.DEPT_ID = C.TOKEN
			WHERE C.TOKEN IS NULL
			AND A.FCST_TYPE <> 'ETC';

			-- --------------------------------------------------------------------------------------------------------------------------------
			--기타매출(40 이외 사업부)
			-- --------------------------------------------------------------------------------------------------------------------------------
			DELETE A
			FROM GT_DMF0_RAW_DATA A
			LEFT OUTER JOIN SCM_MST_SITE B  ON A.SCM_SITE_ID = B.SCM_SITE_ID AND B.DIVISION_ID = P_DIVISION_ID
			LEFT OUTER JOIN ( SELECT DISTINCT token FROM TABLE(fn_string_split(p_dept_id,','))) C ON B.DEPT_ID = C.TOKEN
			WHERE C.TOKEN IS NULL
			AND A.FCST_TYPE = 'ETC'
			AND A.DIVISION_ID <> '40'; --[PJ2024-50611] 40 이외 사업부는 기타일 경우 SCM_MST_SITE 에서 가져옴

			-- --------------------------------------------------------------------------------------------------------------------------------
			--[PJ2024-50611]_기타매출(40사업부) START
			-- --------------------------------------------------------------------------------------------------------------------------------
			DELETE A
			FROM GT_DMF0_RAW_DATA A
			LEFT OUTER JOIN ( SELECT DISTINCT token FROM TABLE(fn_string_split(p_dept_id,','))) C ON A.ATTRIBUTE1 = C.TOKEN --[PJ2024-50611] 40사업부 기타매출은 ATTRIBUTE1 에 부서코드 있음
			WHERE C.TOKEN IS NULL
			AND A.FCST_TYPE = 'ETC'
			AND A.DIVISION_ID = '40';
			-- --------------------------------------------------------------------------------------------------------------------------------
			--[PJ2024-50611]기타매출(40사업부) END
			-- --------------------------------------------------------------------------------------------------------------------------------
		END IF;

	/*
     IF ( P_DIVISION_ID = '40')
     BEGIN
      DELETE A
      FROM GT_DMF0_RAW_DATA A
      LEFT OUTER JOIN GT_DMF0_scm_mst_site_item B
	       ON A.ITEM_ID = B.ITEM_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.PROJECT_CODE = B.PROJECT_CODE
      LEFT OUTER JOIN ( SELECT DISTINCT token
           FROM TABLE(fn_string_split(p_dept_id,','))
          ) C ON B.DEPT_ID = C.TOKEN
      WHERE C.TOKEN IS NULL;
     END
     ELSE
     BEGIN
      DELETE A
      FROM GT_DMF0_RAW_DATA A
      LEFT OUTER JOIN SCM_MST_SITE B
	       ON A.SCM_SITE_ID = B.SCM_SITE_ID AND B.DIVISION_ID = P_DIVISION_ID
      LEFT OUTER JOIN ( SELECT DISTINCT token
           FROM TABLE(fn_string_split(p_dept_id,','))
          ) C ON B.DEPT_ID = C.TOKEN
      WHERE C.TOKEN IS NULL;
     */

		IF ( p_end_customer <> 'ALL') THEN
			IF ( P_DIVISION_ID = '40') THEN
				DELETE A
				FROM GT_DMF0_RAW_DATA A
				LEFT OUTER JOIN ( SELECT DISTINCT token FROM TABLE(fn_string_split(p_end_customer,','))) C ON A.PROJECT_CODE = C.TOKEN
				WHERE C.TOKEN IS NULL;
			ELSE
				DELETE A
				FROM GT_DMF0_RAW_DATA A
				LEFT OUTER JOIN SCM_MST_SITE B  ON A.SCM_SITE_ID = B.SCM_SITE_ID AND B.DIVISION_ID = P_DIVISION_ID
				LEFT OUTER JOIN ( SELECT DISTINCT token FROM TABLE(fn_string_split(p_end_customer,','))) C ON B.END_CUSTOMER = C.TOKEN
				WHERE C.TOKEN IS NULL;
			END IF;

		IF ( p_scm_site_id <> 'ALL') THEN
			DELETE A
			FROM GT_DMF0_RAW_DATA A
			LEFT OUTER JOIN ( SELECT DISTINCT token FROM TABLE(fn_string_split(p_scm_site_id,','))) C ON A.SCM_SITE_ID = C.TOKEN
			WHERE C.TOKEN IS NULL;
		END IF;

		IF ( p_plant_site_id <> 'ALL') THEN
			DELETE A
			FROM GT_DMF0_RAW_DATA A
			LEFT OUTER JOIN ( SELECT DISTINCT token FROM TABLE(fn_string_split(p_plant_site_id,','))) C ON A.PLANT_SITE_ID = C.TOKEN
			WHERE C.TOKEN IS NULL;
		END IF;

		IF ( p_item_type <> 'ALL') THEN
			DELETE A
			FROM GT_DMF0_RAW_DATA A
			LEFT OUTER JOIN GT_DMF0_DM_MST_ITEM_SINGLE_V B  ON A.ITEM_ID = B.ITEM_ID
			LEFT OUTER JOIN ( SELECT DISTINCT token FROM TABLE(fn_string_split(p_item_type,','))) C ON B.ITEM_TYPE = C.TOKEN
			WHERE C.TOKEN IS NULL;
		END IF;

		IF ( p_biztype <> 'ALL') THEN
			IF( P_DIVISION_ID = '40' ) THEN
				DELETE A
				FROM GT_DMF0_RAW_DATA A
				LEFT OUTER JOIN GT_DMF0_DM_MST_ITEM_SINGLE_V B  ON A.ITEM_ID = B.ITEM_ID
				LEFT OUTER JOIN ( SELECT DISTINCT token FROM TABLE(fn_string_split(p_biztype,','))) C ON B.FORECAST_INFO_BIZ_TYPE = C.TOKEN
				WHERE C.TOKEN IS NULL;
			ELSE
				DELETE A
				FROM GT_DMF0_RAW_DATA A
				JOIN SCM_MST_PROJECT B  ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE
				LEFT OUTER JOIN ( SELECT DISTINCT token FROM TABLE(fn_string_split(p_biztype,','))) C ON B.BIZ_TYPE LIKE '%'  ||  C.TOKEN  ||  '%'
				WHERE C.TOKEN IS NULL;
			END IF;
	END;
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- 조회조건에 따른 필터링 처리 ( PRICE 계산시 부하문제로 필터링은 여기서 하고, 필요없는 메저는 PRICE 끝난 후 제거 ) END
	-- --------------------------------------------------------------------------------------------------------------------------------
DBMS_OUTPUT.PUT_LINE(p_program_id  ||  ' : A014--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

	-- --------------------------------------------------------------------------------------------------------------------------------
	-- 실적구간 PRICE 처리
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- 실적구간 LOC 메져 데이터 처리 (DM SALES PRICE를 가지고 계산하는 부분이 아니라, ERP에서 가지고 온 데이터를 가지고 계산하는 부분임)
	-- --------------------------------------------------------------------------------------------------------------------------------
	SELECT COUNT(1)
	INTO v_cnt_4
	FROM GT_DMF0_SELECT_MEASURE WHERE MEASURE = 'LOC';
	IF v_cnt_4 > 0 THEN
		INSERT INTO GT_DMF0_RAW_DATA
		( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
		, TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE
		, YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID ) --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
			 , '' AS TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, 'LOC' AS MEASURE
			 , A.YYYYMMDD, CASE WHEN A.QTY <> 0 THEN B.QTY/A.QTY ELSE 0 END AS QTY, 'R' AS PLAN_RESULT, A.CELL_PROD_SITE_ID   --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		FROM ( SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
					, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, SUM(A.QTY) AS QTY
					, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
				FROM GT_DMF0_RAW_DATA A
				WHERE YYYYMMDD >= v_start_yyyymmdd
				AND YYYYMMDD <	CASE WHEN VERSION_NO = 'CURRENT' THEN p_now_yyyymmdd
									 ELSE TO_CHAR(FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON') + (-7), 'YYYYMMDD')
								END IF;
				AND A.MEASURE = 'RTF_SYS_RP'
				GROUP BY A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
					   , A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID  --[PJ2025-50017] CELL_PROD_SITE_ID 추가
				) A;
		JOIN (	SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
					 , A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, SUM(A.QTY) AS QTY, A.CELL_PROD_SITE_ID   --[PJ2025-50017] CELL_PROD_SITE_ID 추가3
				FROM GT_DMF0_RAW_DATA A
				WHERE YYYYMMDD >= v_start_yyyymmdd
				AND YYYYMMDD < CASE WHEN VERSION_NO = 'CURRENT' THEN p_now_yyyymmdd
									ELSE TO_CHAR(FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON') + (-7), 'YYYYMMDD')
								END;
				AND A.MEASURE = 'SalesAmt_LOC'
				GROUP BY A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.INCOTERMS
					   , A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID  --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			 ) B;
		  ON A.VERSION_NO				= B.VERSION_NO
		 AND A.DIVISION_ID				= B.DIVISION_ID
		 AND A.PROJECT_CODE				= B.PROJECT_CODE
		 AND A.SCM_SITE_ID				= B.SCM_SITE_ID
		 AND A.PLANT_SITE_ID			= B.PLANT_SITE_ID
		 AND A.ITEM_ID					= B.ITEM_ID
		 AND A.INCOTERMS				= B.INCOTERMS
		 AND A.DOM_EXP					= B.DOM_EXP
		 AND A.FCST_TYPE				= B.FCST_TYPE
		 AND A.CURRENCY					= B.CURRENCY
		 AND A.YYYYMMDD					= B.YYYYMMDD
		 AND NVL(A.COMPANY_ID, NULL)	= NVL(B.COMPANY_ID, NULL)
		 AND A.CELL_PROD_SITE_ID		= B.CELL_PROD_SITE_ID; --[PJ2025-50017] CELL_PROD_SITE_ID 추가
	END;

DBMS_OUTPUT.PUT_LINE(p_program_id  ||  ' : A015--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

	-- --------------------------------------------------------------------------------------------------------------------------------
	-- 실적구간 KRW 메져 데이터 처리 (DM SALES PRICE를 가지고 계산하는 부분이 아니라, ERP에서 가지고 온 데이터를 가지고 계산하는 부분임)
	-- --------------------------------------------------------------------------------------------------------------------------------
	SELECT COUNT(1)
	INTO v_cnt_5
	FROM GT_DMF0_SELECT_MEASURE WHERE MEASURE = 'KRW';
	IF v_cnt_5 > 0 THEN
		INSERT INTO GT_DMF0_RAW_DATA
		( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
		, TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE
		, YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID )   --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
			, '' AS TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, 'KRW' AS MEASURE
			, A.YYYYMMDD, CASE WHEN A.QTY <> 0 THEN B.QTY/A.QTY ELSE 0 END AS QTY, 'R', A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		FROM (	SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
					, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, SUM(A.QTY) AS QTY
					, A.CELL_PROD_SITE_ID   --[PJ2025-50017] CELL_PROD_SITE_ID 추가
				FROM GT_DMF0_RAW_DATA A
				WHERE YYYYMMDD >= v_start_yyyymmdd
				AND	  YYYYMMDD < CASE WHEN VERSION_NO = 'CURRENT' THEN p_now_yyyymmdd
									  ELSE TO_CHAR(FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON') + (-7), 'YYYYMMDD')
								 END IF;
				AND A.MEASURE = 'RTF_SYS_RP'
				GROUP BY A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
					   , A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID  --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			 ) A;
		JOIN (	SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
		   			 , A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, SUM(A.QTY) AS QTY
					 , A.CELL_PROD_SITE_ID   --[PJ2025-50017] CELL_PROD_SITE_ID 추가
				FROM GT_DMF0_RAW_DATA A
				WHERE YYYYMMDD >= v_start_yyyymmdd
				AND YYYYMMDD < CASE WHEN VERSION_NO = 'CURRENT' THEN p_now_yyyymmdd
									ELSE TO_CHAR(FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON') + (-7), 'YYYYMMDD')
								END;
				AND A.MEASURE = 'SalesAmt_KRW'
				GROUP BY A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
					   , A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID  --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			) B;
		  ON A.VERSION_NO				= B.VERSION_NO
		 AND A.DIVISION_ID				= B.DIVISION_ID
		 AND A.PROJECT_CODE				= B.PROJECT_CODE
		 AND A.SCM_SITE_ID				= B.SCM_SITE_ID
		 AND A.PLANT_SITE_ID			= B.PLANT_SITE_ID
		 AND A.ITEM_ID					= B.ITEM_ID
		 AND A.INCOTERMS				= B.INCOTERMS
		 AND A.DOM_EXP					= B.DOM_EXP
		 AND A.FCST_TYPE				= B.FCST_TYPE
		 AND A.CURRENCY					= B.CURRENCY
		 AND A.YYYYMMDD					= B.YYYYMMDD
		 AND NVL(A.COMPANY_ID, NULL)	= NVL(B.COMPANY_ID, NULL)
		 AND A.CELL_PROD_SITE_ID		= B.CELL_PROD_SITE_ID; --[PJ2025-50017] CELL_PROD_SITE_ID 추가
	END;
DBMS_OUTPUT.PUT_LINE(p_program_id  ||  ' : A016--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- 계획구간 PRICE 처리
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- 계획구간 CURRENT 'KRW', 'LOC', 'USD' 메져 데이터 처리
	-- 40사업부만 PRICE를 별도화면에서 저장하여 관리한다 40사업부 Demand > Demand Plan > FcstPrice MGMT / 타사업부 Master > Demand Master > Sales Price
	-- 40 사업부의 경우: DM_PLN_CFM_SELLING_PRICE, 타 사업부는 기존: SCM_MST_FUTURE_PRICE 사용
	-- --------------------------------------------------------------------------------------------------------------------------------
	SELECT COUNT(1)
	INTO v_cnt_6
	FROM GT_DMF0_SELECT_MEASURE WHERE MEASURE IN ( 'KRW', 'LOC', 'USD' );
	IF v_cnt_6 > 0 THEN
		IF ( P_DIVISION_ID = '40') THEN
			INSERT INTO GT_DMF0_RAW_DATA
			( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
			, TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE
			, YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID )   --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
				 , A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, C.MEASURE
				 , A.YYYYMMDD, C.PRICE, 'P' AS PLAN_RESULT, A.CELL_PROD_SITE_ID   --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			FROM (	SELECT DISTINCT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
								  , A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD
								  , B.BASIS_START_DATE, A.CELL_PROD_SITE_ID  --[PJ2025-50017] CELL_PROD_SITE_ID 추가
					FROM GT_DMF0_RAW_DATA A
					JOIN SCM_SYS_CALENDAR_M B  ON A.YYYYMMDD = B.BASIS_YYYYMMDD
					WHERE A.YYYYMMDD >= p_now_yyyymmdd AND A.YYYYMMDD <= p_to_yyyymmdd
					AND A.MEASURE IN ( 'RTF_SYS_RP', 'MKT_FCST_RP', 'MKT_FCST', 'RTF_SCP', 'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW','Catch_Up', 'SCM_FCST' ) --[PJ2025-50188] SCM_FCST - MEASURE 추가
					--[PJ2024-50611] Catch Up만 등록 되었을 경우 UNIT PRICE 보이게 수정
				  ) A;
			JOIN DM_PLN_CFM_SELLING_PRICE C
			  ON A.DIVISION_ID			= C.DIVISION_ID
			 AND A.PROJECT_CODE			= C.PROJECT_CODE
			 AND A.SCM_SITE_ID			= C.SCM_SITE_ID
			 AND A.CELL_PROD_SITE_ID	= C.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			 AND A.PLANT_SITE_ID		= C.PLANT_SITE_ID
			 AND A.ITEM_ID				= C.ITEM_ID
			 AND A.INCOTERMS			= C.INCOTERMS
			 AND A.DOM_EXP				= C.DOM_EXP
			 AND A.FCST_TYPE			= C.FCST_TYPE
			 AND A.BASIS_START_DATE		= C.YYYYMMDD
			 AND C.YYYYMMDD			   <= p_to_yyyymmdd
			JOIN GT_DMF0_SELECT_MEASURE D ON C.MEASURE = D.MEASURE
		ELSE  -- ( P_DIVISION_ID <> '40')
			INSERT INTO GT_DMF0_RAW_DATA
			( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
			, TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE
			, YYYYMMDD, QTY, PLAN_RESULT, CELL_PROD_SITE_ID )   --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
				 , A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, C.MEASURE
				 , A.YYYYMMDD, C.PRICE, 'P' AS PLAN_RESULT, A.CELL_PROD_SITE_ID     --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			FROM (	SELECT DISTINCT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
								  , A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD
								  , B.BASIS_START_DATE, A.CELL_PROD_SITE_ID    --[PJ2025-50017] CELL_PROD_SITE_ID 추가
					FROM GT_DMF0_RAW_DATA A
					JOIN SCM_SYS_CALENDAR_M B  ON A.YYYYMMDD = B.BASIS_YYYYMMDD
					WHERE A.YYYYMMDD >= p_now_yyyymmdd and A.YYYYMMDD <= p_to_yyyymmdd
					AND A.MEASURE IN ( 'RTF_SYS_RP', 'MKT_FCST_RP', 'MKT_FCST', 'RTF_SCP', 'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW','Catch_Up', 'SCM_FCST' )  --[PJ2025-50188] SCM_FCST - MEASURE 추가
					--[PJ2024-50611] Catch Up만 등록 되었을 경우 UNIT PRICE 보이게 수정
				  ) A;
			JOIN SCM_MST_FUTURE_PRICE C
			  ON A.DIVISION_ID		= C.DIVISION_ID
			 AND A.PROJECT_CODE		= C.PROJECT_CODE
			 AND A.SCM_SITE_ID		= C.SCM_SITE_ID
			 AND A.PLANT_SITE_ID	= C.PLANT_SITE_ID
			 AND A.ITEM_ID			= C.ITEM_ID
			 AND A.INCOTERMS		= C.INCOTERMS
			 AND A.DOM_EXP			= C.DOM_EXP
			 AND A.FCST_TYPE		= C.FCST_TYPE
			 AND A.BASIS_START_DATE = C.YYYYMMDD
			 AND C.YYYYMMDD			<= p_to_yyyymmdd
			JOIN GT_DMF0_SELECT_MEASURE D ON C.MEASURE = D.MEASURE
		END IF;

DBMS_OUTPUT.PUT_LINE(p_program_id  ||  ' : A017--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- 계획구간 CUTOFF 'KRW', 'LOC', 'USD' 메져 데이터 처리
	-- 40 사업부의 경우: DM_PLN_CFM_SELLING_PRICE_C, 타 사업부는 기존: SCM_MST_FUTURE_PRICE_C 사용
	-- --------------------------------------------------------------------------------------------------------------------------------
	SELECT COUNT(1)
	INTO v_cnt_7
	FROM GT_DMF0_SELECT_MEASURE WHERE MEASURE IN ( 'KRW', 'LOC', 'USD' );
	IF v_cnt_7 > 0 THEN
		 EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_PRICE';

		IF ( P_DIVISION_ID = '40') THEN
			INSERT INTO GT_DMF0_PRICE
			( DIVISION_ID, VERSION_NO, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD
			, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE, CELL_PROD_SITE_ID )   --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			SELECT A.DIVISION_ID, A.VERSION_NO, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.YYYYMMDD
				 , A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PRICE, A.CELL_PROD_SITE_ID   --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			FROM DM_PLN_CFM_SELLING_PRICE_C A
			JOIN GT_DMF0_SELECT_MEASURE C  ON A.MEASURE = C.MEASURE
			--[E20250529-001488]_버전은 위에서 테이블로 가져왔고, IN으로 하면 속도가 너무 안나기때문에 JOIN한다
			JOIN GT_DMF0_V_VERSION_NO D ON A.VERSION_NO = D.VERSION_NO
			JOIN (	SELECT DISTINCT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.INCOTERMS, A.DOM_EXP
			   					 , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID   --[PJ2025-50017] CELL_PROD_SITE_ID 추가
					FROM GT_DMF0_RAW_DATA A
					WHERE A.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY( A.CUTOFF_YYYYMMDD, 'MON') + (-7), 'YYYYMMDD') AND A.YYYYMMDD <= p_to_yyyymmdd
					AND A.MEASURE IN ( 'RTF_SYS_RP', 'MKT_FCST_RP', 'MKT_FCST', 'RTF_SCP', 'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW', 'SCM_FCST' ) --[PJ2025-50188] SCM_FCST - MEASURE 추가
				  ) B;
			  ON A.DIVISION_ID			= B.DIVISION_ID
			 AND A.PROJECT_CODE			= B.PROJECT_CODE
			 AND A.SCM_SITE_ID			= B.SCM_SITE_ID
			 AND A.PLANT_SITE_ID		= B.PLANT_SITE_ID
			 AND A.CELL_PROD_SITE_ID	= B.CELL_PROD_SITE_ID
			 AND A.ITEM_ID				= B.ITEM_ID
			 AND A.INCOTERMS			= B.INCOTERMS
			 AND A.DOM_EXP				= B.DOM_EXP
			 AND A.FCST_TYPE			= B.FCST_TYPE
			WHERE A.DIVISION_ID			= P_DIVISION_ID
			--[E20250529-001488]_버전은 위에서 테이블로 가져왔고, IN으로 하면 속도가 너무 안나기때문에 JOIN한다 기존소스 주석처리
			--AND A.VERSION_NO IN (SELECT SUBSTR(token, 1, CASE WHEN INSTR(token, '(') = 0 THEN LENGTH(token) ELSE INSTR(token, '(')-1 END) FROM TABLE(fn_string_split(p_version_type ,',')))
			AND A.YYYYMMDD				<= p_to_yyyymmdd;
		ELSE  -- ( P_DIVISION_ID <> '40')
			INSERT INTO GT_DMF0_PRICE
			( DIVISION_ID, VERSION_NO, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD
			, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE, CELL_PROD_SITE_ID )
			SELECT A.DIVISION_ID, A.VERSION_NO, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID , A.YYYYMMDD
				 , A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PRICE, '-' AS CELL_PROD_SITE_ID  --SCM_MST_FUTURE_PRICE_C 테이블에서는 CELL_PROD_SITE_ID를 안쓰기 때문에 의미는 없음.
			FROM SCM_MST_FUTURE_PRICE_C A  --[E20240115-000325] 처리
			JOIN GT_DMF0_SELECT_MEASURE C  ON A.MEASURE = C.MEASURE
			--[E20250529-001488]_버전은 위에서 테이블로 가져왔고, IN으로 하면 속도가 너무 안나기때문에 JOIN한다
			JOIN GT_DMF0_V_VERSION_NO D ON A.VERSION_NO = D.VERSION_NO
			JOIN (	SELECT DISTINCT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.INCOTERMS, A.DOM_EXP
		   						 , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD
					FROM GT_DMF0_RAW_DATA A
					-- [C20220304-000114] Sales Plan Waterfall 조회 시 Unit Price 누락 건 조치 요청
					WHERE A.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY( A.CUTOFF_YYYYMMDD, 'MON') + (-7), 'YYYYMMDD') AND A.YYYYMMDD <= p_to_yyyymmdd
					AND A.MEASURE IN ( 'RTF_SYS_RP', 'MKT_FCST_RP', 'MKT_FCST', 'RTF_SCP', 'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW', 'SCM_FCST' )  --[PJ2025-50188] SCM_FCST - MEASURE 추가
				 ) B;
			  ON A.DIVISION_ID		= B.DIVISION_ID
			 AND A.PROJECT_CODE		= B.PROJECT_CODE
			 AND A.SCM_SITE_ID		= B.SCM_SITE_ID
			 AND A.PLANT_SITE_ID	= B.PLANT_SITE_ID
			 AND A.ITEM_ID			= B.ITEM_ID
			 AND A.INCOTERMS		= B.INCOTERMS
			 AND A.DOM_EXP			= B.DOM_EXP
			 AND A.FCST_TYPE		= B.FCST_TYPE
			WHERE A.DIVISION_ID		= P_DIVISION_ID
			--[E20250529-001488]_버전은 위에서 테이블로 가져왔고, IN으로 하면 속도가 너무 안나기때문에 JOIN한다 기존소스 주석처리
			--AND A.VERSION_NO IN (SELECT SUBSTR(token, 1, CASE WHEN INSTR(token, '(') = 0 THEN LENGTH(token) ELSE INSTR(token, '(')-1 END) FROM TABLE(fn_string_split(p_version_type ,',')))
			AND A.YYYYMMDD			<= p_to_yyyymmdd;
		END IF;
DBMS_OUTPUT.PUT_LINE(p_program_id  ||  ' : A018--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
		-- --------------------------------------------------------------------------------------------------------------------------------
		--[E20250529-001488]_같은소스를 사업부별로 나누어서 돌리는 이상한 구조의 상태로 확인되어, 분기친내용 주석처리하고 하나만 돌리도록 수정 원소스 주석 START
		-- 실제로 필요한 내용은 하단에 작성
		-- --------------------------------------------------------------------------------------------------------------------------------
		/*
		IF p_division_id <> '82' AND p_division_id <> '40'
		BEGIN
			INSERT INTO GT_DMF0_RAW_DATA
			( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
			, TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
			, QTY, PLAN_RESULT, CELL_PROD_SITE_ID )
			SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
				 , A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, C.MEASURE, A.YYYYMMDD
				 , C.PRICE, 'P' AS PLAN_RESULT, A.CELL_PROD_SITE_ID
			FROM ( SELECT DISTINCT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
								 , A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD
								 , B.BASIS_START_DATE, A.CELL_PROD_SITE_ID
					FROM GT_DMF0_RAW_DATA A
					JOIN SCM_SYS_CALENDAR_M B  ON A.YYYYMMDD = B.BASIS_YYYYMMDD  /* 20240228 KCW3408 속도개선 */
					-- [C20220304-000114] Sales Plan Waterfall 조회 시 Unit Price 누락 건 조치 요청
					WHERE A.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON') + (-7), 'YYYYMMDD') AND A.YYYYMMDD <= p_to_yyyymmdd
					AND A.MEASURE IN ( 'RTF_SYS_RP', 'MKT_FCST_RP', 'MKT_FCST', 'RTF_SCP', 'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW', 'SCM_FCST' )  --[PJ2025-50188] SCM_FCST - MEASURE 추가
				 ) A;
			-- JOIN SCM_SYS_CALENDAR_M B  ON A.YYYYMMDD = B.BASIS_YYYYMMDD    /* 20240228 KCW3408 속도개선 */
			JOIN GT_DMF0_PRICE C
			  ON A.DIVISION_ID		= C.DIVISION_ID
			 AND A.PROJECT_CODE		= C.PROJECT_CODE
			 AND A.SCM_SITE_ID		= C.SCM_SITE_ID
			 AND A.PLANT_SITE_ID	= C.PLANT_SITE_ID
			 AND A.ITEM_ID			= C.ITEM_ID
			 AND A.INCOTERMS		= C.INCOTERMS
			 AND A.DOM_EXP			= C.DOM_EXP
			 AND A.FCST_TYPE		= C.FCST_TYPE
			 AND A.BASIS_START_DATE = C.YYYYMMDD
			 AND A.VERSION_NO		= C.VERSION_NO;
			--  JOIN GT_DMF0_SELECT_MEASURE D   ON C.MEASURE = D.MEASURE
		ELSIF p_division_id = '82' THEN
			INSERT INTO GT_DMF0_RAW_DATA
			( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
			, TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
			, QTY, PLAN_RESULT, CELL_PROD_SITE_ID  )
			SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
				 , A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, C.MEASURE, A.YYYYMMDD
				 , C.PRICE, 'P' AS PLAN_RESULT, A.CELL_PROD_SITE_ID
			FROM ( SELECT DISTINCT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
								 , A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD
								 , B.BASIS_START_DATE, A.CELL_PROD_SITE_ID
					FROM GT_DMF0_RAW_DATA A
					JOIN SCM_SYS_CALENDAR_M B  ON A.YYYYMMDD = B.BASIS_YYYYMMDD   /* 20240228 KCW3408 속도개선 */
					-- [C20220304-000114] Sales Plan Waterfall 조회 시 Unit Price 누락 건 조치 요청
					WHERE A.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON') + (-7), 'YYYYMMDD') AND A.YYYYMMDD <= p_to_yyyymmdd
					AND A.MEASURE IN ( 'RTF_SYS_RP', 'MKT_FCST_RP', 'MKT_FCST', 'RTF_SCP', 'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW', 'SCM_FCST' )  --[PJ2025-50188] SCM_FCST - MEASURE 추가
				  ) A;
			--JOIN SCM_SYS_CALENDAR_M B (NOLOCK) ON A.YYYYMMDD = B.BASIS_YYYYMMDD  /* 20240228 KCW3408 속도개선 */
			JOIN GT_DMF0_PRICE C
			  ON A.DIVISION_ID		= C.DIVISION_ID
			AND A.PROJECT_CODE		= C.PROJECT_CODE
			AND A.SCM_SITE_ID		= C.SCM_SITE_ID
			AND A.PLANT_SITE_ID		= C.PLANT_SITE_ID
			AND A.ITEM_ID			= C.ITEM_ID
			AND A.INCOTERMS			= C.INCOTERMS
			AND A.DOM_EXP			= C.DOM_EXP
			AND A.FCST_TYPE			= C.FCST_TYPE
			AND A.BASIS_START_DATE	= C.YYYYMMDD
			--[E20250529-001488]_순수 데이터로 JOIN한다 원소스 주석처리
			--AND SUBSTR(A.VERSION_NO, 0, INSTR(A.VERSION_NO, '(')) = C.VERSION_NO --[E20230130-000233]
			AND A.VERSION_NO		= C.VERSION_NO;
			/*AND CASE WHEN A.VERSION_NO LIKE '%(%' THEN SUBSTR(A.VERSION_NO, 0, INSTR(A.VERSION_NO, '('))
				   ELSE A.VERSION_NO  END = C.VERSION_NO --[E20230130-000233]해당 CSR로 반영한 것으로 정상 매핑되지 않는건 확인되어 20250522 SM 반영 */
			-- JOIN GT_DMF0_SELECT_MEASURE D ON C.MEASURE = D.MEASURE
		ELSIF p_division_id = '40' THEN
			INSERT INTO GT_DMF0_RAW_DATA
			( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
			, TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
			, QTY, PLAN_RESULT, CELL_PROD_SITE_ID )
			SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
				 , A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, C.MEASURE, A.YYYYMMDD
				 , C.PRICE, 'P' AS PLAN_RESULT, A.CELL_PROD_SITE_ID
			FROM (	SELECT DISTINCT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
								  , A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD
								  , B.BASIS_START_DATE, A.CELL_PROD_SITE_ID
					FROM GT_DMF0_RAW_DATA A
					JOIN SCM_SYS_CALENDAR_M B  ON A.YYYYMMDD = B.BASIS_YYYYMMDD   /* 20240228 KCW3408 속도개선 */
					-- [C20220304-000114] Sales Plan Waterfall 조회 시 Unit Price 누락 건 조치 요청
					WHERE A.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON') + (-7), 'YYYYMMDD') AND A.YYYYMMDD <= p_to_yyyymmdd
					AND A.MEASURE IN ( 'RTF_SYS_RP', 'MKT_FCST_RP', 'MKT_FCST', 'RTF_SCP', 'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW', 'SCM_FCST' ) --[PJ2025-50188] SCM_FCST - MEASURE 추가
				 ) A;
			--JOIN SCM_SYS_CALENDAR_M B (NOLOCK) ON A.YYYYMMDD = B.BASIS_YYYYMMDD  /* 20240228 KCW3408 속도개선 */
			JOIN GT_DMF0_PRICE C
			  ON A.DIVISION_ID		= C.DIVISION_ID
			 AND A.PROJECT_CODE		= C.PROJECT_CODE
			 AND A.SCM_SITE_ID		= C.SCM_SITE_ID
			 AND A.PLANT_SITE_ID	= C.PLANT_SITE_ID
			 AND A.ITEM_ID			= C.ITEM_ID
			 AND A.INCOTERMS		= C.INCOTERMS
			 AND A.DOM_EXP			= C.DOM_EXP
			 AND A.FCST_TYPE		= C.FCST_TYPE
			 AND A.BASIS_START_DATE	= C.YYYYMMDD
			 --[E20250529-001488]_순수 데이터로 JOIN한다 원소스 주석처리
			 --AND SUBSTR(A.VERSION_NO, 0, INSTR(A.VERSION_NO, '('))	= C.VERSION_NO --[E20230130-000233]
			 AND A.VERSION_NO		= C.VERSION_NO;
			 /*AND CASE WHEN A.VERSION_NO LIKE '%(%' THEN SUBSTR(A.VERSION_NO, 0, INSTR(A.VERSION_NO, '('))
			          ELSE A.VERSION_NO  END = C.VERSION_NO --[E20230130-000233]해당 CSR로 반영한 것으로 정상 매핑되지 않는건 확인되어 20250522 SM 반영*/
			 AND A.CELL_PROD_SITE_ID= C.CELL_PROD_SITE_ID;
			-- JOIN GT_DMF0_SELECT_MEASURE D ON C.MEASURE = D.MEASURE
		END IF;
		*/

		INSERT INTO GT_DMF0_RAW_DATA
		( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
		, TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
		, QTY, PLAN_RESULT, CELL_PROD_SITE_ID )
		SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
				, A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, C.MEASURE, A.YYYYMMDD
				, C.PRICE, 'P' AS PLAN_RESULT, A.CELL_PROD_SITE_ID
		FROM ( SELECT DISTINCT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
								, A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD
								, B.BASIS_START_DATE, A.CELL_PROD_SITE_ID
				FROM GT_DMF0_RAW_DATA A
				JOIN SCM_SYS_CALENDAR_M B  ON A.YYYYMMDD = B.BASIS_YYYYMMDD  /* 20240228 KCW3408 속도개선 */
				-- [C20220304-000114] Sales Plan Waterfall 조회 시 Unit Price 누락 건 조치 요청
				WHERE A.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON') + (-7), 'YYYYMMDD') AND A.YYYYMMDD <= p_to_yyyymmdd
				AND A.MEASURE IN ( 'RTF_SYS_RP', 'MKT_FCST_RP', 'MKT_FCST', 'RTF_SCP', 'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW', 'SCM_FCST' )  --[PJ2025-50188] SCM_FCST - MEASURE 추가
				) A;
		-- JOIN SCM_SYS_CALENDAR_M B  ON A.YYYYMMDD = B.BASIS_YYYYMMDD    /* 20240228 KCW3408 속도개선 */
		JOIN GT_DMF0_PRICE C
		  ON A.DIVISION_ID		= C.DIVISION_ID
		 AND A.PROJECT_CODE		= C.PROJECT_CODE
		 AND A.SCM_SITE_ID		= C.SCM_SITE_ID
		 AND A.PLANT_SITE_ID	= C.PLANT_SITE_ID
		 AND A.ITEM_ID			= C.ITEM_ID
		 AND A.INCOTERMS		= C.INCOTERMS
		 AND A.DOM_EXP			= C.DOM_EXP
		 AND A.FCST_TYPE		= C.FCST_TYPE
		 AND A.BASIS_START_DATE = C.YYYYMMDD
		 AND A.VERSION_NO		= C.VERSION_NO;
		--  JOIN GT_DMF0_SELECT_MEASURE D   ON C.MEASURE = D.MEASURE
		-- --------------------------------------------------------------------------------------------------------------------------------
		--[E20250529-001488]_같은소스를 사업부별로 나누어서 돌리는 이상한 구조의 상태로 확인되어, 분기친내용 주석처리하고 하나만 돌리도록 수정 원소스 주석 END
		-- 실제로 필요한 내용은 하단에 작성
		-- --------------------------------------------------------------------------------------------------------------------------------
	END;
DBMS_OUTPUT.PUT_LINE(p_program_id  ||  ' : A019--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

	-- ---------------------------------------------------------------------------------------
	-- 필요없는 메저 삭제
	-- ---------------------------------------------------------------------------------------
	DELETE A
	FROM GT_DMF0_RAW_DATA A
	JOIN GT_DMF0_SELECT_MEASURE B  ON A.MEASURE = B.MEASURE
	WHERE B.SYSTEM_ADD = 'Y'

	SELECT COUNT(1)
	INTO v_cnt_8
	FROM GT_DMF0_SELECT_MEASURE WHERE MEASURE IN ( 'MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL', 'RTF_SYS_RP_CAR', 'RTF_SYS_RP_CELL', 'RTF_ENERGY', 'MKT_FCST_ENERGY');
	IF v_cnt_8 > 0 THEN
		INSERT INTO GT_DMF0_RAW_DATA
		( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
		, TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
		, QTY
		, PLAN_RESULT, CELL_PROD_SITE_ID  )
		SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
		, A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, B.MEASURE_CALC, A.YYYYMMDD
		, CASE WHEN B.MEASURE_CALC IN ('MKT_FCST_RP_CAR','RTF_RP_CAR','RTF_SYS_RP_CAR') THEN
				CASE WHEN INSTR(C.ITEM_CLASS_NAME, 'Cell') > 0 AND D.CELL_PER_CAR > 0 THEN QTY / D.CELL_PER_CAR
					 WHEN INSTR(C.ITEM_CLASS_NAME, 'Module') > 0  AND D.CELL_PER_CAR > 0 AND D.CELL_PER_MODULE > 0 THEN QTY/ ( D.CELL_PER_CAR/ D.CELL_PER_MODULE )
					 WHEN INSTR(C.ITEM_CLASS_NAME, 'Pack') > 0  THEN A.QTY
				ELSE 0 END
			   WHEN B.MEASURE_CALC IN ('MKT_FCST_RP_CELL','RTF_RP_CELL','RTF_SYS_RP_CELL') AND A.DIVISION_ID LIKE '81%' THEN
				CASE WHEN INSTR(C.ITEM_CLASS_NAME, 'Cell') > 0 AND D.CELL_PER_CAR > 0 THEN A.QTY
					 WHEN ( INSTR(C.ITEM_CLASS_NAME, 'Module') > 0 OR INSTR(C.ITEM_CLASS_NAME, 'Pack') > 0 ) AND D.CELL_PER_MODULE > 0 THEN A.QTY * D.CELL_PER_MODULE
				ELSE 0 END
			   WHEN B.MEASURE_CALC IN ('MKT_FCST_RP_CELL','RTF_RP_CELL','RTF_SYS_RP_CELL') AND A.DIVISION_ID = '82' THEN A.QTY * C.CELL_QUANTITY
			   -- 20211119 ROSIA27 [C20211103-000146] ESS영업관리팀 GSCM 용량 Measure 값 생성 요청의 건
			   WHEN B.MEASURE_CALC = 'RTF_ENERGY' THEN
				CASE WHEN ISNUMERIC(C.ENERGE) > 0 THEN (A.QTY * C.ENERGE)/1000 END
				-- 20221214 rosia27 [C20221207-000080] ESS영업관리팀 GSCM 내 Measrue값 추가 요청  MKT FCST[R+P] Energy
			   WHEN B.MEASURE_CALC = 'MKT_FCST_ENERGY' AND B.MEASURE_ORI = 'RTF_SYS_RP' AND A.PLAN_RESULT = 'R' THEN
				CASE WHEN ISNUMERIC(C.ENERGE) > 0 THEN (C.ENERGE * A.QTY)/1000 END
			   ELSE 0
		  END IF;
		, A.PLAN_RESULT, A.CELL_PROD_SITE_ID
		FROM GT_DMF0_RAW_DATA A
		JOIN ( SELECT CASE WHEN A.MEASURE LIKE 'MKT_FCST_RP%' THEN 'MKT_FCST_RP'
		   				   ELSE 'RTF_SYS_RP' END AS MEASURE_ORI
					, A.MEASURE AS MEASURE_CALC
			   FROM GT_DMF0_SELECT_MEASURE A
			   WHERE MEASURE IN ( 'MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL', 'RTF_SYS_RP_CAR', 'RTF_SYS_RP_CELL', 'RTF_ENERGY', 'MKT_FCST_ENERGY')) B
		  ON A.MEASURE = B.MEASURE_ORI
		JOIN GT_DMF0_DM_MST_ITEM_SINGLE_V C ON A.ITEM_ID = C.ITEM_ID AND A.DIVISION_ID = C.DIVISION_ID
		LEFT OUTER JOIN GT_DMF0_scm_mst_site_item D
					 ON A.DIVISION_ID	= D.DIVISION_ID
					AND A.SCM_SITE_ID	= D.SCM_SITE_ID
					AND A.PROJECT_CODE	= D.PROJECT_CODE
					AND A.ITEM_ID		= D.ITEM_ID
		WHERE A.MEASURE IN ( 'MKT_FCST_RP', 'RTF_SYS_RP' );
	END;
DBMS_OUTPUT.PUT_LINE(p_program_id  ||  ' : A020--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

	-- ---------------------------------------------------------------------------------------
	-- 20221214 rosia27 [C20221207-000080] ESS영업관리팀 GSCM 내 Measrue값 추가 요청  MKT FCST[R+P] Energy
	-- ---------------------------------------------------------------------------------------
	SELECT COUNT(1)
	INTO v_cnt_9
	FROM GT_DMF0_SELECT_MEASURE WHERE MEASURE IN ( 'MKT_FCST_ENERGY');
	IF v_cnt_9 > 0 THEN
		INSERT INTO GT_DMF0_RAW_DATA
		( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
		, TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE
		, YYYYMMDD
		, QTY
		, PLAN_RESULT, CELL_PROD_SITE_ID )
		SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
		, A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, B.MEASURE_CALC
		, A.YYYYMMDD
		, CASE WHEN B.MEASURE_CALC = 'MKT_FCST_ENERGY' AND A.PLAN_RESULT = 'P' THEN
			CASE WHEN ISNUMERIC(C.ENERGE) > 0 THEN (C.ENERGE * A.QTY)/1000 END
			   ELSE 0
		  END IF;
		, A.PLAN_RESULT, A.CELL_PROD_SITE_ID
		FROM GT_DMF0_RAW_DATA A
		JOIN ( SELECT 'MKT_FCST_RP' AS MEASURE_ORI, A.MEASURE AS MEASURE_CALC FROM GT_DMF0_SELECT_MEASURE A   WHERE MEASURE IN ('MKT_FCST_ENERGY')) B
		  ON A.MEASURE = B.MEASURE_ORI
		JOIN GT_DMF0_DM_MST_ITEM_SINGLE_V C ON A.ITEM_ID = C.ITEM_ID AND A.DIVISION_ID = C.DIVISION_ID
		WHERE A.MEASURE IN ( 'MKT_FCST_RP');
	END;

DBMS_OUTPUT.PUT_LINE(p_program_id  ||  ' : A021--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	-- ---------------------------------------------------------------------------------------
	-- 컬럼리스트 만들고, MKT FCST 와 비슷한 방식으로, CTE 로 데이터를 만들고, CTE SELECT 문에 컬럼리스트 삽입한다.
	-- 컬럼리스트 생성 START
	-- ---------------------------------------------------------------------------------------
	BEGIN
















		-- ---------------------------------------------------------------------------------------
		-- 날짜컬럼 생성 START
		-- ---------------------------------------------------------------------------------------
		SELECT '',
    ''
  INTO V_PV_LIST, V_PV_COL_LIST
		FROM   SCM_SYS_CALENDAR_M A
		WHERE  A.BASIS_YYYYMMDD >= p_from_yyyymmdd -- '20171101'  TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
		AND    A.BASIS_YYYYMMDD <= p_to_yyyymmdd   --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
		AND    p_bucket = 'DAILY'
		UNION ALL
		SELECT '[W_'  ||  A.BASIS_YYYYMM  ||  A.ISO_WEEK  ||  '] AS W_'  ||  A.BASIS_YYYYMM  ||  A.ISO_WEEK AS COLUMN_NAME
			  ,'[W_'  ||  A.BASIS_YYYYMM  ||  A.ISO_WEEK  ||  ']' AS PV_name
			  , A.BASIS_START_DATE  ||  '_'  ||  TO_CHAR(21) AS SORT_ORDER_NO
		FROM   SCM_SYS_CALENDAR_M A
		WHERE  A.BASIS_YYYYMMDD >= p_from_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
		AND    A.BASIS_YYYYMMDD <= p_to_yyyymmdd	--TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
		AND    p_bucket != 'ONLY_WEEKLY'
		GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
		UNION ALL
		SELECT '[M_'  ||  A.BASIS_YYYYMM  ||  '] AS M_'  ||  A.BASIS_YYYYMM AS COLUMN_NAME
			 , '[M_'  ||  A.BASIS_YYYYMM  ||  ']' AS PV_name
			 , MIN(A.BASIS_START_DATE)  ||  '_'  ||  TO_CHAR(1) AS SORT_ORDER_NO
		FROM   SCM_SYS_CALENDAR_M A
		WHERE  A.BASIS_YYYYMMDD >= p_from_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
		AND    A.BASIS_YYYYMMDD <= p_to_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
		AND    p_bucket != 'ONLY_WEEKLY'
		GROUP BY A.BASIS_YYYYMM
		-- [C20220620-000567]GSCM DM 시스템의 수작업 LOSS 및 분석 용이하기 위한 기능 개선 ( Partail week의 경우 week만 표시)
		UNION ALL
		SELECT '[W_'  ||  SUBSTR(MAX(BASIS_YYYYMMDD), 1, 6)  ||  ISO_WEEK  ||  '] AS W_'  ||  SUBSTR(MAX(BASIS_YYYYMMDD), 1, 6)  ||  A.ISO_WEEK AS COLUMN_NAME
			 , '[W_'  ||  SUBSTR(MAX(BASIS_YYYYMMDD), 1, 6)  ||  ISO_WEEK  ||  ']' AS PV_NAME
			 , MAX(BASIS_YYYYMMDD)  ||  '_'  ||  TO_CHAR(21) AS SORT_ORDER_NO
		FROM   SCM_SYS_CALENDAR_M A
		WHERE  A.BASIS_YYYYMMDD >= p_from_yyyymmdd
		AND    A.BASIS_YYYYMMDD <= p_to_yyyymmdd
		AND    p_bucket = 'ONLY_WEEKLY'
		GROUP BY ISO_YYYYWW, ISO_WEEK, WEEK_NAME
		ORDER BY SORT_ORDER_NO;

		OPEN c_bucket;
		FETCH c_bucket INTO v_PV_column_name, v_PV_name, v_sort_order_no;
		WHILE v_fetch_status = 0 LOOP
			SELECT V_PV_COL_LIST  ||  CASE WHEN V_PV_COL_LIST IS NOT NULL THEN ',
    V_PV_LIST || CASE WHEN V_PV_LIST IS NOT NULL THEN '
  INTO V_PV_COL_LIST, V_PV_LIST
		FETCH c_Bucket INTO v_PV_column_name, v_PV_name, v_sort_order_no;
		END LOOP;

		CLOSE c_bucket;
		DEALLOCATE c_bucket;
		-- ---------------------------------------------------------------------------------------
		-- 날짜컬럼 생성 END
		-- ---------------------------------------------------------------------------------------
		-- ---------------------------------------------------------------------------------------
		-- 20240228 KCW3408 속도개선_템프사용 START
		-- ---------------------------------------------------------------------------------------
		/* TODO:GTT:GT_DMF0_SCM_MST_SITE-->GT_DMF0_SCM_MST_SITE */
		INSERT INTO GT_DMF0_SCM_MST_SITE
		SELECT B.SCM_SITE_ID, B.DIVISION_ID, B.DEPT_ID, K.SOLDTO_CODE, B.VMI_YN, B.END_CUSTOMER
			 , H.CITY_NAME, J.COUNTRY_NAME, L.SHIPTO_DESCRIPTION, L.SOLDTO_DESCRIPTION
		FROM SCM_MST_SITE B
		LEFT OUTER JOIN SCM_MST_SITE_CUSTOMER K
					 ON B.DIVISION_ID	= K.DIVISION_ID
					AND B.SCM_SITE_ID	= K.SCM_SITE_ID
					AND K.REP_YN		= 'Y'
		LEFT OUTER JOIN SCM_MST_CITY H  ON B.CITY = H.CITY
		LEFT OUTER JOIN SCM_MST_COUNTRY J  ON B.COUNTRY = J.COUNTRY
		LEFT OUTER JOIN SCM_MST_CUSTOMER L
					 ON K.DIVISION_ID = L.DIVISION_ID
					AND K.SHIPTO_CODE = L.SHIPTO_CODE
					AND K.SOLDTO_CODE = L.SOLDTO_CODE;
		-- ---------------------------------------------------------------------------------------
		-- 20240228 KCW3408 속도개선_템프사용 END
		-- ---------------------------------------------------------------------------------------
		/* TODO:GTT:GT_DMF0_DM_MST_ITEM_SINGLE_V_T-->GT_DMF0_DM_MST_ITEM_SINGLE_V_T */
		INSERT INTO GT_DMF0_DM_MST_ITEM_SINGLE_V_T
		SELECT D.*, E.SEGMENT2, NVL(F.NICK_NAME, NULL) AS CELL_MODEL_NICK_NAME
		FROM GT_DMF0_DM_MST_ITEM_SINGLE_V D
		LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL E
					 ON D.CELL_TYPE = E.SEGMENT1
					AND E.LOOKUP_TYPE = 'CELL_TYPE'
		LEFT OUTER JOIN GT_DMF0_DM_MST_ITEM_SINGLE_V F
					 ON D.DIVISION_ID = F.DIVISION_ID
					AND NVL(D.FORECAST_INFO_CELL_MODEL, NULL) = F.ITEM_ID;

		CREATE CLUSTERED INDEX IDX1_TEMP_DM_MST_ITEM_SINGLE_V_T ON GT_DMF0_DM_MST_ITEM_SINGLE_V_T
		( DIVISION_ID ASC, ITEM_ID ASC )
		WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON PRIMARY

		-- ---------------------------------------------------------------------------------------
		-- 일반 컬럼 생성 START
		-- ---------------------------------------------------------------------------------------
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

		-- print i_Count
		IF i_Count = 0 THEN
			SELECT V_ColList		= V_ColList  ||  '['  ||  COLUMN_NAME  ||  '],'
				 , V_OrderList	= V_OrderList  ||  '['  ||  COLUMN_NAME  ||  '] '  ||  DATA_SORT_METHOD_CODE  ||  ','
			FROM ( -- ★★ ORDER BY 가능하려면 컬럼정의 100개 넘지 않아야함
					SELECT --TOP 100
						  C.SORT_ORDER_NO, C.COLUMN_NAME, C.DATA_SORT_METHOD_CODE
					FROM SCM_MST_SHEET_COLUMNS C
					WHERE 1 = 1
					AND   C.PROGRAM_ID  = p_Program_Id
					AND   C.SHEET_NAME  = p_sheet_name
					AND ( C.DEFAULT_FLAG = 'Y' OR ( C.VISIBLE_FLAG = '' AND C.DEFAULT_FLAG IS NULL AND C.VALID_YN = 'Y' ))
				 ) tbColList;
			ORDER BY SORT_ORDER_NO;
		ELSE
			SELECT V_ColList		= V_ColList  ||  '['  ||  COLUMN_NAME  ||  '],'
				 , V_OrderList	= V_OrderList  ||  '['  ||  COLUMN_NAME  ||  '] '  ||  DATA_SORT_METHOD_CODE  ||  ','
			FROM (; -- ★★ ORDER BY 가능하려면 컬럼정의 100개 넘지 않아야함
				   /* kjj 수정(2024.6.24)
					- GROUP_ID 화면표시 위해 SCM_MST_TITLESET_USER 조인 추가
					- ITEM_ID의 정렬보다 무조건 바로 앞에 GROUP_ID가 위치하게 */
					SELECT --TOP 100
					--U.SORT_ORDER_NO
						CASE WHEN C.COLUMN_NAME = 'GROUP_ID' THEN  NVL(TU.SORT_ORDER_NO,95) - 0.5 ELSE U.SORT_ORDER_NO END AS SORT_ORDER_NO--kjj 수정(2024.6.24)
					  , C.COLUMN_NAME, U.DATA_SORT_METHOD_CODE
					FROM SCM_MST_TITLESET_USER U
					INNER JOIN SCM_MST_SHEET_COLUMNS C
							ON U.PROGRAM_ID  = C.PROGRAM_ID
						   AND U.SHEET_NAME  = C.SHEET_NAME
						   AND U.COLUMN_NAME = C.COLUMN_NAME
						   AND U.PROGRAM_ID  = p_Program_Id
						   AND U.SHEET_NAME  = p_sheet_name
						   AND U.USER_ID     = p_created_by
						   AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
					LEFT OUTER JOIN SCM_MST_TITLESET_USER TU
								 ON TU.PROGRAM_ID	= C.PROGRAM_ID
								AND TU.SHEET_NAME	= C.SHEET_NAME
								AND TU.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
								AND	TU.COLUMN_NAME IN ('ITEM_ID')
								AND TU.USER_ID		= p_created_by
								--AND    p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) ) -- 20190125 일단 주석처리 KHSONG
					UNION ALL
					/* 2024/05/17   kcw3408		이동계획 판가 매출GROUP_ID( Item은 Group 기준으로 정렬) 추가) */
					/* kjj 수정(2024.6.24)
						UI 카테고리에서 GROUP_ID 표시되게 하였으므로 불필요한 조인 제거	*/
					SELECT--CASE WHEN C.COLUMN_NAME = 'GROUP_ID' THEN  NVL(U.SORT_ORDER_NO,95) - 0.5 ELSE C.SORT_ORDER_NO END AS SORT_ORDER_NO
						   C.SORT_ORDER_NO, C.COLUMN_NAME, C.DATA_SORT_METHOD_CODE
					FROM SCM_MST_SHEET_COLUMNS C
					/*LEFT OUTER JOIN SCM_MST_TITLESET_USER U
					ON     U.PROGRAM_ID  = C.PROGRAM_ID
					AND    U.SHEET_NAME  = C.SHEET_NAME
					AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
					AND	   U.COLUMN_NAME IN ('ITEM_ID')
					AND    U.USER_ID = p_created_by*/
					WHERE 1 = 1
					AND   C.PROGRAM_ID		= p_Program_Id
					AND   C.SHEET_NAME		= p_sheet_name
					AND   C.VISIBLE_FLAG	= ''
					AND   C.DEFAULT_FLAG	IS NULL
					AND   C.VALID_YN		= 'Y'
					--AND    p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )  -- 20190125 일단 주석처리 KHSONG
					) tbColList;
			ORDER BY SORT_ORDER_NO
FETCH FIRST 100 ROWS ONLY
		END IF;

		SELECT SUBSTR(V_ColList, 1, LENGTH(V_ColList)-1),
    SUBSTR(V_OrderList, 1, LENGTH(V_OrderList)-1),
    V_ColList  ||  ',
    REPLACE(V_ColList,'VERSION_NO','VERSION_SORT,VERSION_NO'),
    REPLACE(V_OrderList,'VERSION_NO','VERSION_SORT DESC,VERSION_NO'),
    REPLACE(V_OrderList,'MEASURE','SORT_ORDER_NO,MEASURE')
  INTO V_ColList, V_OrderList, V_ColList, V_ColList, V_OrderList, V_OrderList
	END;
	-- ---------------------------------------------------------------------------------------
	-- 컬럼리스트 생성 END
	-- ---------------------------------------------------------------------------------------
	/* 2024/05/17   kcw3408		이동계획 판가 매출GROUP_ID( Item은 Group 기준으로 정렬) 추가)
	   UI Category Setup 에 등록(GROUP_ID) ORDER BY 필요, GROUP_ID 추가함 */

DBMS_OUTPUT.PUT_LINE(p_program_id + ' : A022--' + TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

	BEGIN -- CTE 에서 사용할 SELECT COLUMN 정리


		EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_COLUMN_SETUP';

		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'A', 'VERSION_NO', 'A.VERSION_NO', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'A', 'DIVISION_ID', 'A.DIVISION_ID', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'A', 'PROJECT_CODE', 'A.PROJECT_CODE', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'A', 'SCM_SITE_ID', 'A.SCM_SITE_ID', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'A', 'PLANT_SITE_ID', 'A.PLANT_SITE_ID', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'A', 'GROUP_ID', 'NVL(I.GROUP_ID,'' '') AS GROUP_ID', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'A', 'ITEM_ID', 'A.ITEM_ID', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'A', 'TEXT','CASE WHEN LENGTH(A.TEXT) = 0   THEN '' '' ELSE A.TEXT END  AS TEXT' , 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'A', 'INCOTERMS', 'A.INCOTERMS', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'A', 'DOM_EXP', 'A.DOM_EXP', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'A', 'FCST_TYPE', 'A.FCST_TYPE', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'A', 'MEASURE', 'A.MEASURE', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'A', 'END_CUSTOMER40', 'A.PROJECT_CODE AS END_CUSTOMER40', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'A', 'INTERNAL_YN', 'CASE WHEN LENGTH(A.SCM_SITE_ID) > 2 AND LENGTH(A.SCM_SITE_ID) < 6  THEN ''Y'' ELSE '''' END AS INTERNAL_YN', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'A', 'YYYYMMDD', 'A.YYYYMMDD', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'A', 'QTY', 'A.QTY', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'A', 'VERSION_SORT', 'CASE WHEN A.VERSION_NO = ''CURRENT'' THEN ''ZZZZZZZZZZZZZZZ'' ELSE A.VERSION_NO END AS VERSION_SORT', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'B', 'VMI_YN', 'B.VMI_YN', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'B', 'END_CUSTOMER', 'B.END_CUSTOMER', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'AC', 'CURRENCY', 'CASE WHEN A.CURRENCY <> '''' THEN A.CURRENCY ELSE C.CURRENCY END AS CURRENCY', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'A', 'CELL_PROD_SITE_ID', 'A.CELL_PROD_SITE_ID', 1); --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		--[PJ2024-50461] Team Mapping------------------------------------
		--INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'ABC', 'DEPT_ID', 'CASE WHEN A.DIVISION_ID = ''40'' THEN C.DEPT_ID ELSE B.DEPT_ID END AS DEPT_ID', 1)
		--INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'ABC', 'DEPT_ID', 'C.DEPT_ID', 1)
		--기타매출은 모델이 없으므로 기존의 Site 의 팀으로 조회
		--INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'ABC', 'DEPT_ID', 'CASE WHEN A.FCST_TYPE = ''ETC'' THEN B.DEPT_ID ELSE C.DEPT_ID END AS DEPT_ID', 1)
		--[PJ2024-50611] 소형사업부는 Site에서 부서관리 안하므로 화면에서 입력한 부서코드를 사용함(attribute1))
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'ABC', 'DEPT_ID', 'CASE WHEN A.FCST_TYPE = ''ETC'' THEN CASE WHEN A.DIVISION_ID = ''40'' THEN A.ATTRIBUTE1 ELSE B.DEPT_ID END ELSE C.DEPT_ID END AS DEPT_ID', 1);
		--[PJ2024-50611] 소형사업부는 Site에서 부서관리 안하므로 화면에서 입력한 부서코드를 사용함(attribute1))
		--[PJ2024-50461] Team Mapping------------------------------------
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'C', 'APPLICATION', 'C.APPLICATION', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'C', 'CUST_GROUP', 'C.CUST_GROUP', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'C', 'OWNER', 'C.OWNER_NAME AS OWNER', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'C', 'ROUTE', 'C.ROUTE', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'C', 'CUST_GROUP_DTL', 'C.CUST_GROUP_DTL', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'C', 'CELL_PER_CAR', 'C.CELL_PER_CAR', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'C', 'CELL_PER_MODULE', 'C.CELL_PER_MODULE', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'AC', 'COMPANY_ID', 'CASE WHEN NVL(A.COMPANY_ID, '''') = '''' THEN C.SALES_COMPANY ELSE A.COMPANY_ID END AS COMPANY_ID', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'C', 'MODULE_PER_CAR', 'CASE WHEN C.CELL_PER_MODULE  <> 0 THEN C.CELL_PER_CAR / C.CELL_PER_MODULE ELSE 0 END AS MODULE_PER_CAR', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'C', 'DMS_SALES', 'NVL(C.ATTRIBUTE1,'''') AS DMS_SALES', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'C', 'DMS_CUSTOMER', 'NVL(C.ATTRIBUTE2,'''') AS DMS_CUSTOMER', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'C', 'FORECAST_INFO_CELL_MODEL', 'C.ATTRIBUTE5 AS FORECAST_INFO_CELL_MODEL', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'C', 'PRIORITY', 'C.ATTRIBUTE7 AS PRIORITY', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'C', 'KWH_CELL', 'C.ATTRIBUTE8 AS KWH_CELL', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'C', 'REPORT_GROUP6', 'NVL(C.REPORT_GROUP6,'''') AS REPORT_GROUP6', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'AC', 'KWH_MODULE', 'CASE WHEN A.DIVISION_ID LIKE ''81%'' AND C.CELL_PER_MODULE > 0 AND NVL(C.ATTRIBUTE8, '''') <> '''' THEN TO_NUMBER((C.CELL_PER_MODULE * C.ATTRIBUTE8)) ELSE NULL END AS KWH_MODULE', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'AC', 'KWH_PACK', 'CASE WHEN A.DIVISION_ID LIKE ''81%'' AND C.CELL_PER_CAR > 0 AND NVL(C.ATTRIBUTE8, '''') <> '''' THEN TO_NUMBER((C.CELL_PER_CAR * C.ATTRIBUTE8)) ELSE NULL END AS KWH_PACK', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'D', 'FORECAST_INFO_CELL_PACK_COUNT', 'D.FORECAST_INFO_CELL_PACK_COUNT', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'D', 'BIZ_TYPE_NAME40', 'D.FORECAST_INFO_BIZ_TYPE AS BIZ_TYPE_NAME40', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'D', 'FORECAST_INFO_PRODUCT_GROUP', 'D.FORECAST_INFO_PRODUCT_GROUP', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'D', 'ENERGE', 'D.ENERGE', 1);
		-- ---------------------------------------------------------------------------------------
		--[E20240731-000852]_40 사업부 용 ENERGE 컬럼 추가 START
		-- ---------------------------------------------------------------------------------------
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'D', 'ENERGE_WH', 'D.ENERGE_WH', 1);
		-- ---------------------------------------------------------------------------------------
		--[E20240731-000852]_40 사업부 용 ENERGE 컬럼 추가 END
		-- ---------------------------------------------------------------------------------------
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'D', 'CELL_QUANTITY', 'D.CELL_QUANTITY', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'D', 'ITEM_CLASS_NAME', 'NVL(D.ITEM_CLASS_NAME, '''') AS ITEM_CLASS_NAME', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'D', 'ITEM_NAME', 'NVL(D.ITEM_NAME, '''') AS ITEM_NAME', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'D', 'ITEM_TYPE', 'NVL(D.ITEM_TYPE, '''') AS ITEM_TYPE', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'D', 'NICK_NAME', 'NVL(D.NICK_NAME, '''') AS NICK_NAME', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'D', 'MIN_CAPACITY', 'D.MIN_CAPACITY', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'D', 'FORECAST_INFO_ALL', 'D.FORECAST_INFO_SPEC + D.FORECAST_INFOR_VERSION AS FORECAST_INFO_ALL', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'D', 'FORECAST_INFO_SPEC', 'D.FORECAST_INFO_SPEC', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'D', 'FORECAST_INFOR_VERSION', 'D.FORECAST_INFOR_VERSION', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'D', 'MDM_PROJECT_NAME', 'D.MDM_PROJECT_NAME', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'D', 'CELL_TYPE', 'D.SEGMENT2 AS CELL_TYPE', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'D', 'CELL_MODEL_NICK_NAME', 'D.CELL_MODEL_NICK_NAME', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'G', 'BIZ_TYPE_NAME', 'G.BIZ_TYPE AS BIZ_TYPE_NAME', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'G', 'PROJECT_NAME', 'G.PROJECT_NAME', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'G', 'PROJECT_OWNER', 'G.PROJECT_OWNER', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'G', 'PROJECT_STATUS', 'G.PROJECT_STATUS', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'G', 'PRODUCT_GROUP_NAME', 'G.PRODUCT_GROUP_NAME', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'B', 'CITY_NAME', 'B.CITY_NAME', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'B', 'COUNTRY_NAME', 'B.COUNTRY_NAME', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'B', 'SHIPTO_DESCRIPTION', 'B.SHIPTO_DESCRIPTION', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'M', 'SORT_ORDER_NO', 'M.SORT_ORDER_NO', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'C', 'SALES_COMPANY', 'C.SALES_COMPANY', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'B', 'SOLDTO_CODE', 'B.SOLDTO_CODE', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'B', 'SOLDTO_DESCRIPTION', 'B.SOLDTO_DESCRIPTION', 1); --[E20230410-000032] 20230420추가
		-- ---------------------------------------------------------------------------------------
		--[E20231128-000738]마케팅PI 82번 사업부 SCM.DM 메져별 숫자표기 방식 변경 - Sales Plan, Sales Plan Waterfall START
		-- ---------------------------------------------------------------------------------------
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'O', 'SEGMENT3', 'NVL(O.SEGMENT3, ''DEFAULT'') AS NOTATION', 1);
		-- ---------------------------------------------------------------------------------------
		--[E20231128-000738]마케팅PI 82번 사업부 SCM.DM 메져별 숫자표기 방식 변경 - Sales Plan, Sales Plan Waterfall END
		-- ---------------------------------------------------------------------------------------
		-- ---------------------------------------------------------------------------------------
		--[E20250423-000842]_[공급생산 SCM PI팀] Sales Plan 화면 'SCP Use' 칼럼 추가 START
		-- ---------------------------------------------------------------------------------------
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'A','SCP_USE_YN', 'CASE WHEN A.DIVISION_ID IN (''40'') AND B.VMI_YN = ''Y'' AND A.MEASURE IN ( ''VMI_In_Req'', ''VMI_In_Plan'')  THEN ''Y'';
																		WHEN A.DIVISION_ID IN (''40'') AND B.VMI_YN = '''' AND A.MEASURE IN ( ''MKT_FCST_RP'',''MKT_FCST'', ''RTF'',''RTF_SCP'',''RTF_SYS_RP'',''RTF_PR'') THEN ''Y''
																	ELSE '''' END AS SCP_USE_YN', 1)
		-- ---------------------------------------------------------------------------------------
		--[E20250423-000842]_[공급생산 SCM PI팀] Sales Plan 화면 'SCP Use' 칼럼 추가 END
		-- ---------------------------------------------------------------------------------------
DBMS_OUTPUT.PUT_LINE(p_program_id  ||  ' : A023--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

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
			SELECT V_SQL_SELECT	= V_SQL_SELECT   ||  CASE WHEN V_I = 1 THEN '' ELSE ',' END  ||  COLUMN_STRING
				 , V_SQL_GROUPBY	= V_SQL_GROUPBY  ||  CASE WHEN V_I = 1 THEN '' ELSE ',' END
									   ||  CASE WHEN PATINDEX('% AS %', COLUMN_STRING) > 0 THEN SUBSTR(COLUMN_STRING, 1, PATINDEX('% AS %', COLUMN_STRING) -1)
										     ELSE COLUMN_STRING END
			FROM GT_DMF0_
			WHERE SEQ = V_I

		SET V_I  || = 1
		END LOOP;
	END;

DBMS_OUTPUT.PUT_LINE(p_program_id  ||  ' : A024--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	-- ---------------------------------------------------------------------------------------
	-- [PJ2024-50611] 소형 매출 프로세스 개선
	-- ---------------------------------------------------------------------------------------
	IF p_division_id = '40' THEN
		-- ---------------------------------------------------------------------------------------
		-- 1) GT_DMF0_RAW_DATA_FINAL 의 Measure = 'RTF_SYS_RP / RTF_SCP'가 있는 것은 삭제한다. 단, 계획구간에서만
		-- ---------------------------------------------------------------------------------------
		/* TODO:GTT:GT_DMF0_RAW_DATA_TEMP40-->GT_DMF0_RAW_DATA_TEMP40 */
		INSERT INTO GT_DMF0_RAW_DATA_TEMP40
		SELECT VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
			 , TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE
			 , YYYYMMDD, QTY, VALID_YN, PLAN_RESULT, CELL_PROD_SITE_ID
		FROM GT_DMF0_RAW_DATA
		WHERE DIVISION_ID = p_division_id
		AND   MEASURE IN ('RTF_SYS_RP','RTF_SCP','VMI_IN_PLAN','AS_IN_PLAN','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD', 'SCM_FCST') --[PJ2025-50188] SCM_FCST - MEASURE 추가
		AND   YYYYMMDD	>= p_now_yyyymmdd;

		/* TODO:GTT:GT_DMF0_RAW_DATA_TEMP40_KEY-->GT_DMF0_RAW_DATA_TEMP40_KEY */
		INSERT INTO GT_DMF0_RAW_DATA_TEMP40_KEY
		SELECT VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
			 , TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE
			 , VALID_YN, PLAN_RESULT, CELL_PROD_SITE_ID
		FROM GT_DMF0_RAW_DATA_TEMP40
		GROUP BY VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, TEXT
			   , INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, VALID_YN, PLAN_RESULT, CELL_PROD_SITE_ID
		-- ---------------------------------------------------------------------------------------
		-- 기타매출은 제외하고 삭제함. (기타매출은 RTF에 없기 때문에 기존 SalesPlan 데이터 유지
		-- ---------------------------------------------------------------------------------------
		DELETE GT_DMF0_RAW_DATA
		WHERE DIVISION_ID = p_division_id
		AND   MEASURE IN ('RTF_SYS_RP','RTF_SCP','VMI_IN_PLAN','AS_IN_PLAN','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD', 'SCM_FCST') --[PJ2025-50188] SCM_FCST - MEASURE 추가
		AND   YYYYMMDD	 >= p_now_yyyymmdd
		-- ---------------------------------------------------------------------------------------
		-- 기타매출은 제외하고 삭제
		-- ---------------------------------------------------------------------------------------
		AND   ITEM_ID NOT IN (	SELECT DISTINCT ITEM_ID
								--FROM DM_PLN_SALES_PLAN Z
								FROM DM_PLN_SALES_ETC_PLAN Z --[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 테이블 변경
								WHERE Z.DIVISION_ID = p_division_id
								AND   Z.FCST_TYPE = 'ETC'
								AND   Z.YYYYMMDD >= p_now_yyyymmdd
								AND   Z.ITEM_ID NOT IN ( SELECT ITEM_ID
														 FROM SCP_MST_FINAL_ITEM
														 WHERE DIVISION_ID = p_division_id	));

		IF ( p_version_type LIKE '%CURRENT%' ) THEN
			-- ---------------------------------------------------------------------------------------
			-- 2-1) GT_DMF0_RAW_DATA_FINAL 에 DM_PLN_SALES_PLAN 기반으로 PLAN_SITE_ID 및 YYYYMMDD/QTY를 입력한다.
			--[PJ2025-50017] CELL_PROD_SITE_ID 컬럼이 추가된 테이블 변경
			--DM_PLN_RTF_ALLOCATION   -> DM_PLN_SALES_PLAN
			--DM_PLN_RTF_ALLOCATION_C -> DM_PLN_SALES_PLAN_C
			-- ---------------------------------------------------------------------------------------
			INSERT INTO GT_DMF0_RAW_DATA
			( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
			, TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE
			, YYYYMMDD, QTY, VALID_YN, PLAN_RESULT, CELL_PROD_SITE_ID)
			SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, B.PLANT_SITE_ID, A.ITEM_ID
				 , A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.MEASURE
				 , B.YYYYMMDD, B.QTY, A.VALID_YN, A.PLAN_RESULT, A.CELL_PROD_SITE_ID
			FROM GT_DMF0_RAW_DATA_TEMP40_KEY A
			INNER JOIN DM_PLN_SALES_PLAN B
					ON 1=1
				   AND A.DIVISION_ID	  = B.DIVISION_ID
				   AND A.PROJECT_CODE	  = B.PROJECT_CODE
				   AND A.SCM_SITE_ID	  = B.SCM_SITE_ID
				   AND A.ITEM_ID		  = B.ITEM_ID
				   AND A.INCOTERMS		  = B.INCOTERMS
				   AND A.DOM_EXP		  = B.DOM_EXP
				   AND A.FCST_TYPE		  = B.FCST_TYPE
				   AND A.MEASURE		  = B.MEASURE
				   AND B.YYYYMMDD		  >= p_now_yyyymmdd
				   AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID;

			--UPDATE A
			--SET   A.PLANT_SITE_ID = B.PLANT_SITE_ID
			--	, A.FROM_SITE_ID  = B.FROM_SITE_ID
			--FROM GT_DMF0_RAW_DATA A
			--INNER JOIN DM_PLN_RTF_ALLOCATION B
			--ON 1=1
			-- AND  A.DIVISION_ID		= B.DIVISION_ID
			-- AND  A.PROJECT_CODE	= B.PROJECT_CODE
			-- AND  A.SCM_SITE_ID		= B.SCM_SITE_ID
			-- AND  A.ITEM_ID			= B.ITEM_ID
			-- AND  A.INCOTERMS		= B.INCOTERMS
			-- AND  A.DOM_EXP			= B.DOM_EXP
			-- AND  A.FCST_TYPE		= B.FCST_TYPE
			-- AND  A.MEASURE			= 'RTF_ENERGY'
			-- AND  B.MEASURE			= 'RTF_SCP'
			-- AND  A.YYYYMMDD		= B.YYYYMMDD
			-- AND  A.YYYYMMDD		>= p_now_yyyymmdd
			-- AND  B.YYYYMMDD		>= p_now_yyyymmdd
			--;

			/* TODO:GTT:GT_DMF0_RTF_ENERGY-->GT_DMF0_RTF_ENERGY */
			INSERT INTO GT_DMF0_RTF_ENERGY
			SELECT *
			FROM GT_DMF0_RAW_DATA A
			WHERE A.DIVISION_ID = p_division_id
			AND   A.MEASURE		= 'RTF_ENERGY';

			DELETE GT_DMF0_RAW_DATA
			WHERE DIVISION_ID = p_division_id
			AND   MEASURE	= 'RTF_ENERGY';

			-- ---------------------------------------------------------------------------------------
			--[PJ2025-50017] CELL_PROD_SITE_ID 컬럼이 추가된 테이블 변경
			--DM_PLN_RTF_ALLOCATION   -> DM_PLN_SALES_PLAN
			--DM_PLN_RTF_ALLOCATION_C -> DM_PLN_SALES_PLAN_C
			-- ---------------------------------------------------------------------------------------
			INSERT INTO GT_DMF0_RAW_DATA
			( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS
			, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD, QTY
			, VALID_YN, PLAN_RESULT, CELL_PROD_SITE_ID )
			SELECT DISTINCT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, B.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS
						  , A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.MEASURE, B.YYYYMMDD, A.QTY
						  , A.VALID_YN, A.PLAN_RESULT, A.CELL_PROD_SITE_ID
			FROM GT_DMF0_RTF_ENERGY A
			INNER JOIN DM_PLN_SALES_PLAN B
					ON 1=1
				   AND A.PROJECT_CODE		= B.PROJECT_CODE
				   AND A.DIVISION_ID		= B.DIVISION_ID
				   AND A.SCM_SITE_ID		= B.SCM_SITE_ID
				   AND A.PLANT_SITE_ID		= B.PLANT_SITE_ID
				   AND A.ITEM_ID			= B.ITEM_ID
				   AND A.INCOTERMS			= B.INCOTERMS
				   AND A.DOM_EXP			= B.DOM_EXP
				   AND A.FCST_TYPE			= B.FCST_TYPE
				   AND A.YYYYMMDD			= B.YYYYMMDD
				   AND A.MEASURE			= 'RTF_ENERGY'
				   AND B.MEASURE			= 'RTF_SYS_RP'
				   AND B.YYYYMMDD		  >= p_now_yyyymmdd
				   AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID;

			MERGE INTO GT_DMF0_RAW_DATA A;
			USING (	SELECT DISTINCT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.INCOTERMS, A.DOM_EXP
								  , A.FCST_TYPE, A.YYYYMMDD, A.QTY, B.SUM_QTY, A.CELL_PROD_SITE_ID
				   	FROM GT_DMF0_RAW_DATA A
					INNER JOIN (	SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, YYYYMMDD, SUM(QTY) AS SUM_QTY, CELL_PROD_SITE_ID
									FROM GT_DMF0_RAW_DATA
									WHERE DIVISION_ID	= p_division_id
									AND   VERSION_NO	= p_version_type
									AND   MEASURE		= 'RTF_SYS_RP'
									AND   YYYYMMDD	   >= p_now_yyyymmdd
									GROUP BY DIVISION_ID, VERSION_NO, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, YYYYMMDD, CELL_PROD_SITE_ID ) B
							ON 1=1
						   AND A.DIVISION_ID		= B.DIVISION_ID
						   AND A.PROJECT_CODE		= B.PROJECT_CODE
						   AND A.SCM_SITE_ID		= B.SCM_SITE_ID
						   AND A.PLANT_SITE_ID		= B.PLANT_SITE_ID
						   AND A.ITEM_ID			= B.ITEM_ID
						   AND A.INCOTERMS			= B.INCOTERMS
						   AND A.DOM_EXP			= B.DOM_EXP
						   AND A.FCST_TYPE			= B.FCST_TYPE
						   AND A.YYYYMMDD			= B.YYYYMMDD
					WHERE A.DIVISION_ID       = p_division_id
					AND   A.VERSION_NO        = p_version_type
					AND   A.MEASURE           = 'RTF_SYS_RP'
					AND   A.YYYYMMDD         >= p_now_yyyymmdd
					AND   A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
				   ) B;
				ON ( 1 = 1
			   AND A.DIVISION_ID		= B.DIVISION_ID
			   AND A.PROJECT_CODE		= B.PROJECT_CODE
			   AND A.SCM_SITE_ID		= B.SCM_SITE_ID
			   AND A.PLANT_SITE_ID		= B.PLANT_SITE_ID
			   AND A.ITEM_ID			= B.ITEM_ID
			   AND A.INCOTERMS			= B.INCOTERMS
			   AND A.DOM_EXP			= B.DOM_EXP
			   AND A.FCST_TYPE			= B.FCST_TYPE
			   AND A.YYYYMMDD			= B.YYYYMMDD
			   AND A.MEASURE			= 'RTF_ENERGY'
			   AND A.CELL_PROD_SITE_ID	= B.CELL_PROD_SITE_ID );
			WHEN MATCHED THEN
			UPDATE SET A.QTY = A.QTY * (B.QTY/B.SUM_QTY);
		ELSIF ( p_version_type LIKE '%SP%') THEN
			-- ---------------------------------------------------------------------------------------
			-- 2-2) GT_DMF0_RAW_DATA_FINAL 에 DM_PLN_SALES_PLAN_C 기반으로 PLAN_SITE_ID 및 YYYYMMDD/QTY를 입력한다.
			--[PJ2025-50017] CELL_PROD_SITE_ID 컬럼이 추가된 테이블 변경
			--DM_PLN_RTF_ALLOCATION   -> DM_PLN_SALES_PLAN
			--DM_PLN_RTF_ALLOCATION_C -> DM_PLN_SALES_PLAN_C
			-- ---------------------------------------------------------------------------------------
			INSERT INTO GT_DMF0_RAW_DATA
			( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
			, TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE
			, YYYYMMDD, QTY, VALID_YN, PLAN_RESULT, CELL_PROD_SITE_ID)
			SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, B.PLANT_SITE_ID, A.ITEM_ID
				 , A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.MEASURE
				 , B.YYYYMMDD, B.QTY, A.VALID_YN, A.PLAN_RESULT, A.CELL_PROD_SITE_ID
			FROM GT_DMF0_RAW_DATA_TEMP40_KEY A
			INNER JOIN DM_PLN_SALES_PLAN_C B
					ON 1=1
				   AND  A.DIVISION_ID			= B.DIVISION_ID
				   AND  A.VERSION_NO			= B.VERSION_NO
				   AND  A.CUTOFF_YYYYMMDD		= B.CUTOFF_YYYYMMDD
				   AND  A.PROJECT_CODE			= B.PROJECT_CODE
				   AND  A.SCM_SITE_ID			= B.SCM_SITE_ID
				   AND  A.ITEM_ID				= B.ITEM_ID
				   AND  A.INCOTERMS				= B.INCOTERMS
				   AND  A.DOM_EXP				= B.DOM_EXP
				   AND  A.FCST_TYPE				= B.FCST_TYPE
				   AND  A.MEASURE				= B.MEASURE
				   AND  B.YYYYMMDD			   >= p_now_yyyymmdd
				   AND  A.CELL_PROD_SITE_ID		= B.CELL_PROD_SITE_ID;

			--UPDATE A
			--SET   A.PLANT_SITE_ID = B.PLANT_SITE_ID
			--	, A.FROM_SITE_ID  = B.FROM_SITE_ID
			--FROM GT_DMF0_RAW_DATA A
			--INNER JOIN DM_PLN_RTF_ALLOCATION_C B
			--ON 1=1
			-- AND  A.VERSION_NO		= B.VERSION_NO
			-- AND  A.CUTOFF_YYYYMMDD = B.CUTOFF_YYYYMMDD
			-- AND  A.DIVISION_ID		= B.DIVISION_ID
			-- AND  A.PROJECT_CODE	= B.PROJECT_CODE
			-- AND  A.SCM_SITE_ID		= B.SCM_SITE_ID
			-- AND  A.ITEM_ID			= B.ITEM_ID
			-- AND  A.INCOTERMS		= B.INCOTERMS
			-- AND  A.DOM_EXP			= B.DOM_EXP
			-- AND  A.FCST_TYPE		= B.FCST_TYPE
			-- AND  A.MEASURE			= 'RTF_ENERGY'
			-- AND  B.MEASURE			= 'RTF_SCP'
			-- AND  A.YYYYMMDD		= B.YYYYMMDD
			-- AND  A.YYYYMMDD		>= p_now_yyyymmdd
			-- AND  B.YYYYMMDD		>= p_now_yyyymmdd
			--;

			/* TODO:GTT:GT_DMF0_RTF_ENERGY_C-->GT_DMF0_RTF_ENERGY_C */
			INSERT INTO GT_DMF0_RTF_ENERGY_C
			SELECT *
			FROM GT_DMF0_RAW_DATA A
			WHERE A.DIVISION_ID = p_division_id
			AND   A.MEASURE		= 'RTF_ENERGY';

			DELETE GT_DMF0_RAW_DATA
			WHERE DIVISION_ID = p_division_id
			AND   MEASURE	= 'RTF_ENERGY';

			-- ---------------------------------------------------------------------------------------
			--[PJ2025-50017] CELL_PROD_SITE_ID 컬럼이 추가된 테이블 변경
			--DM_PLN_RTF_ALLOCATION   -> DM_PLN_SALES_PLAN
			--DM_PLN_RTF_ALLOCATION_C -> DM_PLN_SALES_PLAN_C
			-- ---------------------------------------------------------------------------------------
			INSERT INTO GT_DMF0_RAW_DATA
			( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
			, TEXT, INCOTERMS, DOM_EXP, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE
			, YYYYMMDD, QTY, VALID_YN, PLAN_RESULT, CELL_PROD_SITE_ID)
			SELECT DISTINCT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, B.PLANT_SITE_ID, A.ITEM_ID
						  , A.TEXT, A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.MEASURE
						  , B.YYYYMMDD, A.QTY, A.VALID_YN, A.PLAN_RESULT, A.CELL_PROD_SITE_ID
			FROM GT_DMF0_RTF_ENERGY_C A
			INNER JOIN DM_PLN_SALES_PLAN_C B
					ON 1=1
				   AND A.DIVISION_ID		= B.DIVISION_ID
				   AND A.VERSION_NO			= B.VERSION_NO
				   AND A.CUTOFF_YYYYMMDD	= B.CUTOFF_YYYYMMDD
				   AND A.PROJECT_CODE		= B.PROJECT_CODE
				   AND A.SCM_SITE_ID		= B.SCM_SITE_ID
				   AND A.PLANT_SITE_ID		= B.PLANT_SITE_ID
				   AND A.ITEM_ID			= B.ITEM_ID
				   AND A.INCOTERMS			= B.INCOTERMS
				   AND A.DOM_EXP			= B.DOM_EXP
				   AND A.FCST_TYPE			= B.FCST_TYPE
				   AND A.YYYYMMDD			= B.YYYYMMDD
				   AND A.MEASURE			= 'RTF_ENERGY'
				   AND B.MEASURE			= 'RTF_SYS_RP'
				   AND B.YYYYMMDD		  >= p_now_yyyymmdd
				   AND A.CELL_PROD_SITE_ID	= B.CELL_PROD_SITE_ID;

			MERGE INTO GT_DMF0_RAW_DATA A;
			USING (	SELECT DISTINCT A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID
					              , A.INCOTERMS, A.DOM_EXP, A.FCST_TYPE, A.YYYYMMDD, A.QTY, B.SUM_QTY
								  , ROUND(CASE WHEN B.SUM_QTY  <> 0 THEN A.QTY / B.SUM_QTY ELSE 0 END , 9) AS RATIO -- 2025.01.23 0 나누기 오류 수정
								  --, ROUND(A.QTY/B.SUM_QTY, 9) AS RATIO
								  , A.CELL_PROD_SITE_ID
					FROM GT_DMF0_RAW_DATA A
					INNER JOIN (	SELECT DIVISION_ID, VERSION_NO, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, YYYYMMDD, SUM(QTY) AS SUM_QTY, CELL_PROD_SITE_ID
									FROM GT_DMF0_RAW_DATA
									WHERE DIVISION_ID = p_division_id
									AND   MEASURE = 'RTF_SYS_RP'
									AND   YYYYMMDD >= p_now_yyyymmdd
									GROUP BY  DIVISION_ID, VERSION_NO, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, INCOTERMS, DOM_EXP, FCST_TYPE, YYYYMMDD, CELL_PROD_SITE_ID ) B
							ON 1=1
						   AND  A.DIVISION_ID		= B.DIVISION_ID
						   AND  A.VERSION_NO		= B.VERSION_NO
						   AND  A.CUTOFF_YYYYMMDD	= B.CUTOFF_YYYYMMDD
						   AND  A.PROJECT_CODE		= B.PROJECT_CODE
						   AND  A.SCM_SITE_ID		= B.SCM_SITE_ID
						   AND  A.PLANT_SITE_ID		= B.PLANT_SITE_ID
						   AND  A.ITEM_ID			= B.ITEM_ID
						   AND  A.INCOTERMS			= B.INCOTERMS
						   AND  A.DOM_EXP			= B.DOM_EXP
						   AND  A.FCST_TYPE			= B.FCST_TYPE
						   AND  A.YYYYMMDD			= B.YYYYMMDD
					WHERE A.DIVISION_ID       = p_division_id
					AND   A.MEASURE           = 'RTF_SYS_RP'
					AND   A.YYYYMMDD         >= p_now_yyyymmdd
					AND   A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
				 ) B;
				 ON ( 1=1
				AND A.DIVISION_ID			= B.DIVISION_ID
				AND A.VERSION_NO			= B.VERSION_NO
				AND A.CUTOFF_YYYYMMDD		= B.CUTOFF_YYYYMMDD
				AND A.PROJECT_CODE			= B.PROJECT_CODE
				AND A.SCM_SITE_ID			= B.SCM_SITE_ID
				AND A.PLANT_SITE_ID			= B.PLANT_SITE_ID
				AND A.ITEM_ID				= B.ITEM_ID
				AND A.INCOTERMS				= B.INCOTERMS
				AND A.DOM_EXP				= B.DOM_EXP
				AND A.FCST_TYPE				= B.FCST_TYPE
				AND A.YYYYMMDD				= B.YYYYMMDD
				AND A.MEASURE				= 'RTF_ENERGY'
				AND A.CELL_PROD_SITE_ID		= B.CELL_PROD_SITE_ID	);
			WHEN MATCHED THEN
			UPDATE	SET A.QTY = A.QTY * B.RATIO; --(B.QTY / B.SUM_QTY)-- 2025.01.23 0 나누기 오류 수정
		END IF;
	-- ---------------------------------------------------------------------------------------
	--[E20250529-001488]_버전작업은 마지막에서 해주는것으로 변경한다 (82 사업부만 해당한다) START
	-- ---------------------------------------------------------------------------------------
	IF (p_division_id= '82') THEN
		UPDATE A
		SET A.TOBE_VERSION_NO = CASE WHEN C.DM_RTF_YN = '' THEN (A.VERSION_NO || '(' || B.WEEK_NAME || ') (NO PLAN)')
								ELSE (A.VERSION_NO || '(' || B.WEEK_NAME || ')') END
		FROM GT_DMF0_V_VERSION_NO A
		INNER JOIN SCM_SYS_CALENDAR_M B  ON SUBSTR(A.VERSION_NO, 6, 8) = B.BASIS_YYYYMMDD
		LEFT JOIN SCP_PLN_INTERFACE_YN C
			   ON C.DIVISION_ID			= p_division_id
			  AND B.BASIS_START_DATE	= C.PLAN_START_YYYYMMDD;

		UPDATE A
		SET A.VERSION_NO = B.TOBE_VERSION_NO
		FROM GT_DMF0_RAW_DATA A
		INNER JOIN GT_DMF0_V_VERSION_NO B ON A.VERSION_NO = B.VERSION_NO
	END IF;
	-- ---------------------------------------------------------------------------------------
	--[E20250529-001488]_버전작업은 마지막에서 해주는것으로 변경한다 (82 사업부만 해당한다) END
	-- ---------------------------------------------------------------------------------------
DBMS_OUTPUT.PUT_LINE(p_program_id  ||  ' : A025--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    /* TODO:GTT:GT_DMF0_CALENDAR-->GT_DMF0_CALENDAR */
    INSERT INTO GT_DMF0_CALENDAR
    SELECT A.BASIS_YYYYMMWW, A.ISO_YYYYWW, A.ISO_WEEK, B.BASIS_YYYYMMDD, B.END_FLAG, B.BASIS_YYYYMM
    FROM (	SELECT SUBSTR(MAX(BASIS_YYYYMMDD),1,6)  ||  ISO_WEEK AS BASIS_YYYYMMWW, ISO_YYYYWW,  ISO_WEEK
			FROM SCM_SYS_CALENDAR_M
			WHERE BASIS_YYYYMMDD >=  p_from_yyyymmdd
			AND   BASIS_YYYYMMDD <=  p_TO_yyyymmdd
			GROUP BY  ISO_YYYYWW, ISO_WEEK
		 ) A;
    JOIN SCM_SYS_CALENDAR_M B
	  ON A.ISO_YYYYWW	= B.ISO_YYYYWW
     AND A.ISO_WEEK		= B.ISO_WEEK;

DBMS_OUTPUT.PUT_LINE(p_program_id  ||  ' : A026--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    v_sql_text := ' SELECT ';

    IF p_cell_yn = 'Y' THEN
		v_sql_text := v_sql_text  ||  ' FN_GET_DM_SALES_PLAN_WATERFALL_QTY2(;
		A.MEASURE, NVL(D.ITEM_CLASS_NAME,'''')
		, NVL(A.QTY,0)
		, NVL(C.CELL_PER_CAR,0)
		, NVL(C.CELL_PER_MODULE,0)
		, ''Y''
		, NVL(D.FORECAST_INFO_CELL_PACK_COUNT, 0)
		, '''  ||  P_DIVISION_ID  ||  ''', NVL(D.FORECAST_INFO_BIZ_TYPE, '''')
		) AS QTY '

	----- [E20230619-000151] ss
	ELSIF p_division_id = '82' THEN
		v_sql_text := v_sql_text  ||  ' TO_NUMBER(TO_CHAR(A.QTY,''#GT_DMF0_0.##########'')) AS QTY ';
	------ [E20230619-000151] ee
	ELSE
		-- v_sql_text := v_sql_text + ' A.QTY AS QTY ' --이전버전[E20230619-000151]
		v_sql_text := v_sql_text  ||  ' A.QTY AS QTY '; --수정후[E20230619-000151]
	END IF;

    v_sql_text := v_sql_text  ||  '
		, CASE WHEN '''  ||  P_BUCKET  ||  ''' = ''DAILY'' THEN A.YYYYMMDD ELSE '''' END AS YYYYMMDD
		, CAL.BASIS_YYYYMM, CAL.ISO_WEEK, CAL.BASIS_YYYYMMWW
		, M.SORT_ORDER_NO
		, CAL.END_FLAG
		, NVL(O.SEGMENT3, ''DEFAULT'') AS NOTATION
		, V_SQL_SELECT
		into GT_DMF0_WF
		FROM GT_DMF0_RAW_DATA A
		JOIN GT_DMF0_SELECT_MEASURE      M  ON A.MEASURE = M.MEASURE
		JOIN GT_DMF0_CALENDAR        CAL   ON A.YYYYMMDD = CAL.BASIS_YYYYMMDD
		LEFT OUTER JOIN GT_DMF0_SCM_MST_SITE B   ON A.SCM_SITE_ID = B.SCM_SITE_ID AND A.DIVISION_ID = B.DIVISION_ID
		LEFT OUTER JOIN GT_DMF0_scm_mst_site_item  C  ON  A.DIVISION_ID = C.DIVISION_ID AND A.PROJECT_CODE = C.PROJECT_CODE AND A.SCM_SITE_ID = C.SCM_SITE_ID AND A.ITEM_ID = C.ITEM_ID
		LEFT OUTER JOIN GT_DMF0_DM_MST_ITEM_SINGLE_V_T D  ON A.DIVISION_ID = D.DIVISION_ID AND A.ITEM_ID = D.ITEM_ID
		LEFT OUTER JOIN SCM_MST_PROJECT    G  ON A.DIVISION_ID = G.DIVISION_ID AND A.PROJECT_CODE = G.PROJECT_CODE
		LEFT OUTER JOIN SCP_MST_ITEM_GROUP_DETAIL	I (NOLOCK) ON A.DIVISION_ID = I.DIVISION_ID	AND A.PROJECT_CODE = I.PROJECT_CODE AND A.ITEM_ID = I.ITEM_ID
		LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL O  ON O.LOOKUP_TYPE = ''DM_MEASURE_POSITIONAL_NOTATION'' AND A.MEASURE = O.SEGMENT2 AND A.DIVISION_ID = O.SEGMENT1

		SELECT V_COLUMN
			 , SORT_ORDER_NO
			 , V_PV_COL_LIST
		FROM ( ';

		IF p_bucket = 'DAILY' THEN
			v_sql_text := v_sql_text  ||  '
				SELECT V_COLUMN, F.SORT_ORDER_NO, ''D_'' + F.YYYYMMDD AS YYYYMMDD, F.QTY
				FROM GT_DMF0_WF F
				WHERE F.QTY <> 0
				UNION ALL'
			END IF;

		IF p_bucket != 'ONLY_WEEKLY' THEN
			v_sql_text := v_sql_text  ||  '
					SELECT V_COLUMN, F.SORT_ORDER_NO, ''W_'' + F.BASIS_YYYYMM || F.ISO_WEEK AS YYYYMMDD
						, CASE WHEN F.MEASURE IN ( ''KRW'', ''USD'', ''LOC'') THEN AVG(F.QTY) ELSE SUM(F.QTY) END AS QTY
					FROM GT_DMF0_WF F
					WHERE F.QTY <> 0
					GROUP BY V_COLUMN, F.SORT_ORDER_NO, F.BASIS_YYYYMM, F.ISO_WEEK
					UNION ALL
					SELECT V_COLUMN, F.SORT_ORDER_NO, ''M_'' + F.BASIS_YYYYMM AS YYYYMMDD
					, CASE WHEN F.MEASURE IN ( ''KRW'', ''USD'', ''LOC'') THEN AVG(F.QTY) ELSE SUM(F.QTY) END AS QTY
					FROM GT_DMF0_WF F
					WHERE F.QTY <> 0
					GROUP BY V_COLUMN, F.SORT_ORDER_NO, F.BASIS_YYYYMM ) F
				PIVOT ( SUM(F.QTY) FOR YYYYMMDD IN ( V_PV_LIST )) AS PVT
				ORDER BY v_orderby;
				';
		ELSIF p_bucket = 'ONLY_WEEKLY' THEN
	   -- [C20220620-000567]GSCM DM 시스템의 수작업 LOSS 및 분석 용이하기 위한 기능 개선 ( Partail week의 경우 week만 표시)
	   /* PJ20209642R Sales Price 는 Sum 대신 Avg로 계산 */
			v_sql_text := v_sql_text  ||  '
					SELECT V_COLUMN, F.SORT_ORDER_NO, ''W_'' + F.BASIS_YYYYMMWW  AS YYYYMMDD
						, CASE WHEN F.MEASURE IN ( ''KRW'', ''USD'', ''LOC'') THEN AVG(F.QTY) ELSE SUM(F.QTY) END AS QTY
					FROM GT_DMF0_WF F
					WHERE F.QTY <> 0
					GROUP BY V_COLUMN, F.SORT_ORDER_NO, F.BASIS_YYYYMMWW, F.ISO_WEEK	) F
				PIVOT ( SUM(F.QTY) FOR YYYYMMDD IN ( V_PV_LIST )) AS PVT
				ORDER BY v_orderby;
				';
		END IF;
DBMS_OUTPUT.PUT_LINE(p_program_id  ||  ' : A027--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

	-- SELECT v_sql_text;
	v_sql_text := REPLACE(v_sql_text,'v_PV_COL_LIST'    , v_PV_LIST    );
	v_sql_text := REPLACE(v_sql_text,'v_PV_LIST'  , v_PV_LIST    );
	v_sql_text := REPLACE(v_sql_text,'v_column'   , V_ColList       );
	v_sql_text := REPLACE(v_sql_text,'v_orderby'  , V_OrderList      );
	v_sql_text := REPLACE(v_sql_text,'V_SQL_SELECT'  , V_SQL_SELECT      );
	v_sql_text := REPLACE(v_sql_text,'V_SQL_GROUPBY'  , V_SQL_GROUPBY      );

  --SELECT v_sql_text;
  --select V_ColList, V_SQL_SELECT
/*
SELECT CAST(v_sql_text AS TEXT)
FOR XML PATH('')--,ROOT('x')
SELECT LENGTH(v_sql_text)
*/
	SP_EXECUTESQL v_sql_text;

	SELECT ISO_WEEK, BASIS_DATE
	FROM SCM_SYS_CALENDAR_M  --[E20240115-000325]  처리
	WHERE BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD');


  -- xml확인할경우
  --SELECT CAST(v_sql_text AS TEXT)
  --FOR XML PATH('')--,ROOT('x')

--SELECT COUNT(*) FROM GT_DMF0_RAW_DATA
--SELECT * FROM GT_DMF0_RAW_DATA


--execute SP_executesql V_NSQL2

DBMS_OUTPUT.PUT_LINE(p_program_id  ||  ' : A028--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	-- --------------------------------------------------------------------------------------------------------------------------------
	--Temp Table 존재 여부 체크 (BEGIN)
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- --------------------------------------------------------------------------------------------------------------------------------
	--Temp Table 존재 여부 체크 (END)
	-- --------------------------------------------------------------------------------------------------------------------------------
DBMS_OUTPUT.PUT_LINE(p_program_id  ||  ' : A029--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

END;
/

-- DMF0022_GET_SPREAD_TITLE → PKG_DMF0022.P_DMF0022_GET_SPREAD_TITLE에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0022_GET_SPREAD_TITLE
(
    p_start_yyyymmdd	VARCHAR2,
    p_end_yyyymmdd		VARCHAR2,
	p_created_by			VARCHAR2,
	p_division_id			VARCHAR2,
	p_bucket				VARCHAR2
)
AS

    i_Count INTEGER := 0;
    v_program_id VARCHAR2(50 CHAR) := 'DMF0022';
    v_sheet_name VARCHAR2(50 CHAR) := 'Sales Plan Waterfall';
BEGIN




    SELECT  Count(*)
  INTO i_Count
    FROM   SCM_MST_TITLESET_USER U
    --     , SCM_MST_SHEET_COLUMNS C
    WHERE  1 = 1
    --AND    U.PROGRAM_ID  = C.PROGRAM_ID
    --AND    U.SHEET_NAME  = C.SHEET_NAME
    --AND    U.COLUMN_NAME = C.COLUMN_NAME
    AND    U.PROGRAM_ID  = v_program_id
    AND    U.SHEET_NAME  = v_sheet_name
    AND    U.USER_ID     = p_created_by
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C';



	IF i_Count > 0 THEN
		SELECT U.PROGRAM_ID
				, U.SHEET_NAME
				, U.COLUMN_NAME
				, C.COLUMN_LABEL_NAME
				, U.SORT_ORDER_NO        --TO_CHAR(U.SORT_ORDER_NO) AS SORT_ORDER_NO
				, U.DATA_SORT_METHOD_CODE
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
		FROM   SCM_MST_TITLESET_USER U
				, SCM_MST_SHEET_COLUMNS C
		WHERE  1 = 1
		AND    U.PROGRAM_ID  = C.PROGRAM_ID
		AND    U.SHEET_NAME  = C.SHEET_NAME
		AND    U.COLUMN_NAME = C.COLUMN_NAME
		AND    U.PROGRAM_ID  = v_program_id
		AND    U.SHEET_NAME  = v_sheet_name
		AND    U.USER_ID     = p_created_by
		AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
		AND	 p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )		-- 20180620 division 추가
		UNION ALL
		SELECT C.PROGRAM_ID
				, C.SHEET_NAME
				, C.COLUMN_NAME
				, C.COLUMN_LABEL_NAME
				, C.SORT_ORDER_NO        --TO_CHAR(U.SORT_ORDER_NO) AS SORT_ORDER_NO
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
		FROM   SCM_MST_SHEET_COLUMNS C
		WHERE  1 = 1
		AND    C.PROGRAM_ID  = v_program_id
		AND    C.SHEET_NAME  = v_sheet_name
		AND    C.VISIBLE_FLAG = ''
		AND    C.DEFAULT_FLAG IS NULL
		AND    C.VALID_YN     = 'Y'
		AND	 p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )		-- 20180620 division 추가

		UNION ALL

		SELECT v_program_id   AS PROGRAM_ID
				, v_sheet_name AS SHEET_NAME
				, T.COLUMN_NAME
				, T.COLUMN_LABEL_NAME
				, T.SORT_ORDER_NO
				, ''         AS DATA_SORT_METHOD_CODE
				, T.SMALL_CLASS_LABEL_NAME
				, T.LARGE_CLASS_LABEL_NAME
				, T.DAY_CODE
				, ''         AS FIXED_FLAG
				, CASE	WHEN p_bucket = 'ONLY_WEEKLY' THEN 100
						ELSE	50 END	AS COLUMN_WIDTH
				, T.CELL_CONTROL_OBJECT_TYPE_CODE   --'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
				, ''         AS CELL_COMBO_DATA_TYPE
				, '3'         AS DATA_SCALE_NUMBER
				, ''         AS DATA_MAX_LENGTH
				, 'R'        AS HORIZONTAL_ALIGN_CODE
				, 'Y'        AS UPPERCASE_APPLY_FLAG
				, 'Y'        AS VISIBLE_FLAG
				, ''         AS DEFAULT_FLAG
				, ''         AS USER_SELECTABLE_FLAG
				, ''         AS VALID_YN
				, ''			AS DIVISION_ID
		FROM  (
				SELECT 'D_'  ||  A.BASIS_YYYYMMDD   AS COLUMN_NAME
					, A.CALENDAR_DAY            AS COLUMN_LABEL_NAME
					, A.WEEK_NAME               AS SMALL_CLASS_LABEL_NAME
					, A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME
					, A.DAYOFWEEK               AS DAY_CODE
					, A.BASIS_YYYYMMDD  ||  TO_CHAR(31) AS SORT_ORDER_NO
					, 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
				FROM   SCM_SYS_CALENDAR_M A
				WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
				AND    A.basis_yyyymmdd <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
				AND    1 = CASE WHEN p_bucket = 'DAILY' THEN '1' ELSE '2' END
				/*UNION ALL
				SELECT 'DB_' + A.BASIS_YYYYMMDD  AS COLUMN_NAME
					, A.CALENDAR_DAY            AS COLUMN_LABEL_NAME
					, A.WEEK_NAME               AS SMALL_CLASS_LABEL_NAME
					, A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME
					, ''                        AS DAY_CODE
					, A.BASIS_YYYYMMDD || TO_CHAR(32) AS SORT_ORDER_NO
					, 'FPText' AS CELL_CONTROL_OBJECT_TYPE_CODE
				FROM   SCM_SYS_CALENDAR_M A
				WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
				AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')*/
				UNION ALL
				SELECT 'W_'  ||  A.BASIS_YYYYMM  ||  A.ISO_WEEK   AS COLUMN_NAME
					, A.WEEK_NAME          AS COLUMN_LABEL_NAME
					, A.WEEK_NAME          AS SMALL_CLASS_LABEL_NAME
					, A.MONTH_NAME         AS LARGE_CLASS_LABEL_NAME
					, ''                   AS DAY_CODE
					, A.BASIS_START_DATE  ||  TO_CHAR(21) AS SORT_ORDER_NO
					, 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
				FROM   SCM_SYS_CALENDAR_M A
				WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
				AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
				AND    1 = CASE WHEN p_bucket != 'ONLY_WEEKLY' THEN '1' ELSE '2' END
				GROUP BY A.BASIS_YYYYMM
						, A.ISO_WEEK
						, A.WEEK_NAME
						, A.MONTH_NAME
						, A.BASIS_START_DATE
				/*UNION ALL
				SELECT 'WB_' + A.BASIS_YYYYMM || A.ISO_WEEK   AS COLUMN_NAME
					, A.WEEK_NAME           AS COLUMN_LABEL_NAME
					, A.WEEK_NAME           AS SMALL_CLASS_LABEL_NAME
					, A.MONTH_NAME       AS LARGE_CLASS_LABEL_NAME
					, ''                    AS DAY_CODE
					, A.BASIS_START_DATE || TO_CHAR(22) AS SORT_ORDER_NO
					, 'FPText' AS CELL_CONTROL_OBJECT_TYPE_CODE
				FROM   SCM_SYS_CALENDAR_M A
				WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
				AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
				GROUP BY A.BASIS_YYYYMM
						, A.ISO_WEEK
						, A.WEEK_NAME
						, A.MONTH_NAME
						, A.BASIS_START_DATE*/
				UNION ALL
				SELECT 'M_'  ||  A.BASIS_YYYYMM  AS COLUMN_NAME
						, A.MONTH_NAME          AS COLUMN_LABEL_NAME
						, A.MONTH_NAME          AS SMALL_CLASS_LABEL_NAME
						, A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
						, ''                    AS DAY_CODE
						, MIN(A.BASIS_START_DATE)  ||  TO_CHAR('01') AS SORT_ORDER_NO
						, 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
				FROM    SCM_SYS_CALENDAR_M A
				WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
				AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
				AND    1 = CASE WHEN p_bucket != 'ONLY_WEEKLY' THEN '1' ELSE '2' END
				GROUP BY A.BASIS_YYYYMM
						, A.MONTH_NAME
				/*UNION ALL
				SELECT 'MB_' + A.BASIS_YYYYMM  AS COLUMN_NAME
						, A.MONTH_NAME           AS COLUMN_LABEL
						, A.MONTH_NAME           AS SMALL_LABEL_NAME
						, A.MONTH_NAME           AS LARGE_LABEL_NAME
						, ''                     AS DAY_CODE
						, MIN(A.BASIS_START_DATE) || TO_CHAR(11) AS SORT_ORDER_NO
						, 'FPText' AS CELL_CONTROL_OBJECT_TYPE_CODE
				FROM    SCM_SYS_CALENDAR_M A
				WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
				AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
				GROUP BY A.BASIS_YYYYMM
						, A.MONTH_NAME	 */
				--ORDER BY sort_order_no
				-- 2022.07.19	kdw2819		[C20220620-000567]GSCM DM 시스템의 수작업 LOSS 및 분석 용이하기 위한 기능 개선 ( Partail week의 경우 week만 표시)
				UNION ALL
				SELECT 'W_'  ||  SUBSTR(MAX(BASIS_YYYYMMDD), 1, 6) || ISO_WEEK
					, WEEK_NAME as COLUMN_LABEL_NAME
					, WEEK_NAME as SMALL_CLASS_LABEL_NAME
					, SUBSTR(MIN(BASIS_YYYYMMDD), 5, 2)  ||  '.'  ||  SUBSTR(MIN(BASIS_YYYYMMDD), 7, 2)
						 ||  ' ~ '  ||  SUBSTR(MAX(BASIS_YYYYMMDD), 5, 2)  ||  '.'  ||  SUBSTR(MAX(BASIS_YYYYMMDD), 7, 2)
						, ''                   AS DAY_CODE
					, MAX(BASIS_YYYYMMDD) ||  TO_CHAR(21) AS SORT_ORDER_NO
					, 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
				FROM   SCM_SYS_CALENDAR_M A
				WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd
				AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd
				AND    1 = CASE WHEN p_bucket = 'ONLY_WEEKLY' THEN '1' ELSE '2' END
				GROUP BY ISO_YYYYWW, ISO_WEEK, WEEK_NAME

			) T;
		  ORDER BY SORT_ORDER_NO   ;
		  DBMS_OUTPUT.PUT_LINE('-------------' ||  p_bucket);
	  ELSE
			SELECT C.PROGRAM_ID
					, C.SHEET_NAME
					, C.COLUMN_NAME
					, C.COLUMN_LABEL_NAME
					, C.SORT_ORDER_NO        --TO_CHAR(U.SORT_ORDER_NO) AS SORT_ORDER_NO
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
			FROM   SCM_MST_SHEET_COLUMNS C
			WHERE  1 = 1
			AND    C.PROGRAM_ID  = v_program_id
			AND    C.SHEET_NAME  = v_sheet_name
			AND    C.DEFAULT_FLAG = 'Y'
			AND    C.VALID_YN     = 'Y'
			AND	 p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )		-- 20180620 division 추가

			UNION ALL

			SELECT C.PROGRAM_ID
					, C.SHEET_NAME
					, C.COLUMN_NAME
					, C.COLUMN_LABEL_NAME
					, C.SORT_ORDER_NO        --TO_CHAR(U.SORT_ORDER_NO) AS SORT_ORDER_NO
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
			FROM   SCM_MST_SHEET_COLUMNS C
			WHERE  1 = 1
			AND    C.PROGRAM_ID  = v_program_id
			AND    C.SHEET_NAME  = v_sheet_name
			AND    C.VISIBLE_FLAG = ''
			AND    C.DEFAULT_FLAG IS NULL
			AND    C.VALID_YN     = 'Y'
			AND	 p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )		-- 20180620 division 추가

			UNION ALL

			SELECT v_program_id   AS PROGRAM_ID
					, v_sheet_name AS SHEET_NAME
					, T.COLUMN_NAME
					, T.COLUMN_LABEL_NAME
					, T.SORT_ORDER_NO
					, ''         AS DATA_SORT_METHOD_CODE
					, T.SMALL_CLASS_LABEL_NAME
					, T.LARGE_CLASS_LABEL_NAME
					, T.DAY_CODE
					, ''         AS FIXED_FLAG
					, CASE	WHEN p_bucket = 'ONLY_WEEKLY' THEN 100
							ELSE	50 END	AS COLUMN_WIDTH
					, 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
					, ''         AS CELL_COMBO_DATA_TYPE
					, '3'         AS DATA_SCALE_NUMBER
					, ''         AS DATA_MAX_LENGTH
					, 'R'        AS HORIZONTAL_ALIGN_CODE
					, 'Y'        AS UPPERCASE_APPLY_FLAG
					, 'Y'        AS VISIBLE_FLAG
					, ''         AS DEFAULT_FLAG
					, ''         AS USER_SELECTABLE_FLAG
					, ''         AS VALID_YN
					, ''			AS DIVISION_ID
			FROM  (
					SELECT 'D_'  ||  A.BASIS_YYYYMMDD   AS COLUMN_NAME
						, A.CALENDAR_DAY            AS COLUMN_LABEL_NAME
						, A.WEEK_NAME               AS SMALL_CLASS_LABEL_NAME
						, A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME
						, A.DAYOFWEEK               AS DAY_CODE
						, A.BASIS_YYYYMMDD  ||  TO_CHAR(31) AS SORT_ORDER_NO
					FROM   SCM_SYS_CALENDAR_M A
					WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
					AND    A.basis_yyyymmdd <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
					AND    1 = CASE WHEN p_bucket = 'DAILY' THEN '1' ELSE '2' END
					/*UNION ALL
					SELECT 'DB_' + A.BASIS_YYYYMMDD  AS COLUMN_NAME
						, A.CALENDAR_DAY            AS COLUMN_LABEL_NAME
						, A.WEEK_NAME               AS SMALL_CLASS_LABEL_NAME
						, A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME
						, ''                        AS DAY_CODE
						, A.BASIS_YYYYMMDD || TO_CHAR(32) AS SORT_ORDER_NO
					FROM   SCM_SYS_CALENDAR_M A
					WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
					AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')  */
					UNION ALL
					SELECT 'W_'  ||  A.BASIS_YYYYMM  ||  A.ISO_WEEK   AS COLUMN_NAME
						, A.WEEK_NAME          AS COLUMN_LABEL_NAME
						, A.WEEK_NAME          AS SMALL_CLASS_LABEL_NAME
						, A.MONTH_NAME         AS LARGE_CLASS_LABEL_NAME
						, ''                   AS DAY_CODE
						, A.BASIS_START_DATE  ||  TO_CHAR(21) AS SORT_ORDER_NO
					FROM   SCM_SYS_CALENDAR_M A
					WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
					AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
					AND    1 = CASE WHEN p_bucket != 'ONLY_WEEKLY' THEN '1' ELSE '2' END
					GROUP BY A.BASIS_YYYYMM
							, A.ISO_WEEK
							, A.WEEK_NAME
							, A.MONTH_NAME
							, A.BASIS_START_DATE
					/*UNION ALL
					SELECT 'WB_' + A.BASIS_YYYYMM || A.ISO_WEEK   AS COLUMN_NAME
						, A.WEEK_NAME           AS COLUMN_LABEL_NAME
						, A.WEEK_NAME           AS SMALL_CLASS_LABEL_NAME
						, A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
						, ''                    AS DAY_CODE
						, A.BASIS_START_DATE || TO_CHAR(22) AS SORT_ORDER_NO
					FROM   SCM_SYS_CALENDAR_M A
					WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
					AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
					GROUP BY A.BASIS_YYYYMM
							, A.ISO_WEEK
							, A.WEEK_NAME
							, A.MONTH_NAME
							, A.BASIS_START_DATE*/
					UNION ALL
					SELECT 'M_'  ||  A.BASIS_YYYYMM  AS COLUMN_NAME
							, A.MONTH_NAME          AS COLUMN_LABEL_NAME
							, A.MONTH_NAME          AS SMALL_CLASS_LABEL_NAME
							, A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
							, ''                    AS DAY_CODE
							, MIN(A.BASIS_START_DATE)  ||  TO_CHAR('01') AS SORT_ORDER_NO
					FROM    SCM_SYS_CALENDAR_M A
					WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
					AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
					AND    1 = CASE WHEN p_bucket != 'ONLY_WEEKLY' THEN '1' ELSE '2' END
					GROUP BY A.BASIS_YYYYMM
							, A.MONTH_NAME
					/*UNION ALL
					SELECT 'MB_' + A.BASIS_YYYYMM  AS COLUMN_NAME
							, A.MONTH_NAME           AS COLUMN_LABEL
							, A.MONTH_NAME           AS SMALL_LABEL_NAME
							, A.MONTH_NAME           AS LARGE_LABEL_NAME
							, ''                     AS DAY_CODE
							, MIN(A.BASIS_START_DATE) || TO_CHAR(11) AS SORT_ORDER_NO
					FROM    SCM_SYS_CALENDAR_M A
					WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
					AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
					GROUP BY A.BASIS_YYYYMM
							, A.MONTH_NAME	 */
					--ORDER BY sort_order_no
					-- 2022.07.19	kdw2819		[C20220620-000567]GSCM DM 시스템의 수작업 LOSS 및 분석 용이하기 위한 기능 개선 ( Partail week의 경우 week만 표시)
					UNION ALL
					SELECT 'W_'  ||  SUBSTR(MAX(BASIS_YYYYMMDD), 1, 6) || ISO_WEEK
						, WEEK_NAME as COLUMN_LABEL_NAME
						, WEEK_NAME as SMALL_CLASS_LABEL_NAME
						, SUBSTR(MIN(BASIS_YYYYMMDD), 5, 2)  ||  '.'  ||  SUBSTR(MIN(BASIS_YYYYMMDD), 7, 2)
							 ||  ' ~ '  ||  SUBSTR(MAX(BASIS_YYYYMMDD), 5, 2)  ||  '.'  ||  SUBSTR(MAX(BASIS_YYYYMMDD), 7, 2)
							, ''                   AS DAY_CODE
						, MAX(BASIS_YYYYMMDD) ||  TO_CHAR(21) AS SORT_ORDER_NO
						-- , 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
					FROM   SCM_SYS_CALENDAR_M A
					WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd
					AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd
					AND    1 = CASE WHEN p_bucket = 'ONLY_WEEKLY' THEN '1' ELSE '2' END
					GROUP BY ISO_YYYYWW, ISO_WEEK, WEEK_NAME
				) T;
			  ORDER BY SORT_ORDER_NO   ;
		  END IF;

END;
/
