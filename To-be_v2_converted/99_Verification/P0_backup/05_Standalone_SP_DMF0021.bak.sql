/*=============================================================================================
 * File         : 05_Standalone_SP_DMF0021.sql
 * Description  : Standalone Procedures — DMF0021 화면 (5개)
 *              : 향후 PKG_DMF0021로 통합 권장 (사내 표준 §6 UI별 패키지 그룹화)
 * Author       : 마리소프트 이규철
 * Created      : 2026-05-13
 *
 * 실행 순서   : 07_Standalone_SP 단계
 * 실행 계정   : SCM_MGR
 *===========================================================================================*/


CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0021_GET_DM_PLN_SALES_PLAN_DATAEx
(
	  p_division_id				VARCHAR2
	, p_dept_id					VARCHAR2
	, p_end_customer				VARCHAR2
	, p_scm_site_id				VARCHAR2
	, p_project_code				VARCHAR2
	, p_item_id					VARCHAR2
	, p_item_type					VARCHAR2
	, p_from_yyyymmdd				VARCHAR2
	, p_now_yyyymmdd				VARCHAR2
	, p_to_yyyymmdd				VARCHAR2
	, p_created_by					VARCHAR2
	, p_plant_site_id				VARCHAR2
	, p_biztype					VARCHAR2
	, p_owner						VARCHAR2
	, p_internal_yn				VARCHAR2
	, p_userinfo					VARCHAR2
	, p_bucket						VARCHAR2	-- 20211026 SALES PLAN 속도 개선
	, p_user_dept_id				VARCHAR2	-- JV Planner 일때 USER 부서정보로 SALES SITE ID 정보를 얻기 위해추가
)
AS

/*
 * ========================================
 * [변환검증] 2026-03-02 20:37:16
 * 파일: dbo.DMF0021_GET_DM_PLN_SALES_PLAN_DATAEx.sql
 * ----------------------------------------
 * ⚠ IF: IF:35  END IF:32  차이:+3
 * ----------------------------------------
 * BEGIN 위치: L119, L902, L983, L1076, L1086, L1501, L1561, L1754
 * END;  위치: L572, L573, L597, L631, L657, L1084, L1166, L1212, L1231, L1272 ...
 * ----------------------------------------
 * 힌트: END가 12개 더 많음 → 고아 END; 확인 필요
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */



    V_Prod VARCHAR2(4000 CHAR);
    V_ColList VARCHAR2(4000 CHAR);
    V_OrderList VARCHAR2(4000 CHAR);
    v_nsql VARCHAR2(4000 CHAR);
    v_nsql2 VARCHAR2(4000 CHAR);
    p_program_id VARCHAR2(50) := 'DMF0021';
    p_sheet_name VARCHAR2(50) := 'Sales Plan';
    v_dept_list VARCHAR2(4000) := NULL;
    v_group_id VARCHAR2(50) := NULL;
    V_MEASURE INTEGER := 0;
    i_count INTEGER := 0;
    v_user_mea_cnt INTEGER := 0;
    v_start_yyyymmdd VARCHAR2(8 CHAR);
    v_EDIT_AUTH_SalesAmt_LOC VARCHAR2(1) := '';
    v_EDIT_AUTH_RTF_SYS_RP VARCHAR2(1) := '';
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
    v_SHIP_DIVISION_ID VARCHAR2(30 CHAR);
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
    v_cnt_10  INTEGER := 0;
    v_cnt_11  INTEGER := 0;
    v_cnt_12  INTEGER := 0;
    v_cnt_13  INTEGER := 0;
    v_cnt_14  INTEGER := 0;
    v_cnt_15  INTEGER := 0;
    v_cnt_16  INTEGER := 0;
    v_cnt_17  INTEGER := 0;
BEGIN
		--			--=================================================================================================================================
	-- 사용 변수 선언 (START)
	--=================================================================================================================================









	V_ColList := NULL;
	V_OrderList := NULL;
	V_Prod := NULL;


	-- 20200316 KHSONG C20200224-000109 (START)
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- 20200316 KHSONG C20200224-000109 (END)
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- 20200306 KHSONG 조회시작기간이 START DATE가 아닌경우 PRICE값을 가져오지 못하여 변수추가사용

	SELECT BASIS_START_DATE INTO v_start_yyyymmdd FROM SCM_SYS_CALENDAR_M  WHERE BASIS_YYYYMMDD = p_from_yyyymmdd;
	--=================================================================================================================================
	-- 사용 변수 선언 (END)
	--=================================================================================================================================

DBMS_OUTPUT.PUT_LINE(p_program_id  || ' : A001--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	--=================================================================================================================================
	-- Temp Table 존재 여부 체크 (START)
	--=================================================================================================================================
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- [E20240920-000300]_SCM.DM 화면 조회 속도 개선 START
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- [E20240920-000300]_SCM.DM 화면 조회 속도 개선 속도개선 END
	-- --------------------------------------------------------------------------------------------------------------------------------
	--=================================================================================================================================
	-- Temp Table 존재 여부 체크 (END)
	--=================================================================================================================================
DBMS_OUTPUT.PUT_LINE(p_program_id  || ' : A002--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	--=================================================================================================================================
	-- 권한 관리 (START)
	--=================================================================================================================================
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- 20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (START)
	-- --------------------------------------------------------------------------------------------------------------------------------
	SELECT COUNT(1)
	INTO v_cnt_1
	FROM SCM_ADM_LOOKUP_MASTER_DETAIL
	WHERE LOOKUP_TYPE	= 'GET_ADMIN_GROUP'
	AND VALID_YN		= 'Y'
	AND SEGMENT1		= p_userinfo
	AND SEGMENT2		= 'ALL';
	IF v_cnt_1 > 0 THEN
		v_group_id := 'ADMIN';
	END IF;
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- 20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- [PJ2025-50188] 그룹 + 화면 + 사업부 + MEASURE 별로 권한추가 (신규 Lookup - GET_ADMIN_GROUP_MEASURE) 추가 (START)
	-- --------------------------------------------------------------------------------------------------------------------------------
	--Measure 별로 다른 권한을 부여해달라는 요청으로 인하여 GET_ADMIN_GROUP_MEASURE 룩업을 만들었음.



	SELECT COUNT(1)
	INTO v_cnt_2
	FROM SCM_ADM_LOOKUP_MASTER_DETAIL
	WHERE LOOKUP_TYPE	= 'GET_ADMIN_GROUP_MEASURE'
	AND VALID_YN		= 'Y'
	AND SEGMENT1		= p_userinfo --ADMIN , SCM PI Admin , DM ADMIN , DM Planner , SCP Planner
	AND SEGMENT2		= p_program_id
	AND SEGMENT3		= SUBSTR(p_division_id, 1, 2)
	AND SEGMENT4		= 'SalesAmt_LOC';
	IF v_cnt_2 > 0 THEN
		v_EDIT_AUTH_SalesAmt_LOC := 'Y';
	END IF;

	SELECT COUNT(1)
	INTO v_cnt_3
	FROM SCM_ADM_LOOKUP_MASTER_DETAIL
	WHERE LOOKUP_TYPE	= 'GET_ADMIN_GROUP_MEASURE'
	AND VALID_YN		= 'Y'
	AND SEGMENT1		= p_userinfo --ADMIN , SCM PI Admin , DM ADMIN , DM Planner , SCP Planner
	AND SEGMENT2		= p_program_id
	AND SEGMENT3		= SUBSTR(p_division_id, 1, 2)
	AND SEGMENT4		= 'RTF_SYS_RP';
	IF v_cnt_3 > 0 THEN
		v_EDIT_AUTH_RTF_SYS_RP := 'Y';
	END IF;
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- [PJ2025-50188] 그룹+화면+사업부+MEASURE 별로 권한추가 (신규 Lookup - GET_ADMIN_GROUP_MEASURE) 추가 (END)
	-- --------------------------------------------------------------------------------------------------------------------------------
DBMS_OUTPUT.PUT_LINE(p_program_id  || ' : A003--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- 사용자의 팀정보 & 권한 - [C20210504-000057] SalesPlan 권한은 있으나 편집안되는 현상 수정 2021/05/13 SJHan (START)
	-- --------------------------------------------------------------------------------------------------------------------------------
	SELECT DISTINCT STUFF((	SELECT ','  ||  D.SEGMENT3  INTO v_dept_list
													FROM (	SELECT LOOK.SEGMENT1, LOOK.SEGMENT3
															FROM   TB_FX_User USR
															INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LOOK
																	ON USR.DEPT_ID		= LOOK.SEGMENT1
																   AND LOOK.LOOKUP_TYPE = 'PM_TEAM_MAPPING'
																   AND LOOK.VALID_YN	= 'Y'
															WHERE LOOK.VALID_YN	= 'Y'
															AND USR.USERID		= p_created_by
															UNION
															-- 매핑이 없는 경우 자기 부서
															SELECT DEPT_ID AS SEGMENT1, DEPT_ID AS SEGMENT3
															FROM TB_FX_User
															WHERE USERID = p_created_by
															) AS D
													WHERE D.SEGMENT1 = A.SEGMENT1;
													FOR XML PATH('')), 1, 1, '') AS SEGMENT
							FROM (	SELECT LOOK.SEGMENT1, LOOK.SEGMENT3
									FROM   TB_FX_User USR
									INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LOOK
											ON USR.DEPT_ID		= LOOK.SEGMENT1
										   AND LOOK.LOOKUP_TYPE = 'PM_TEAM_MAPPING'
										   AND LOOK.VALID_YN	= 'Y'
									WHERE LOOK.VALID_YN = 'Y' AND USR.USERID = p_created_by
									UNION
									SELECT DEPT_ID AS SEGMENT1, DEPT_ID AS SEGMENT3
									FROM TB_FX_User
									WHERE USERID = p_created_by ) A
							WHERE A.SEGMENT1 = ( SELECT DEPT_ID FROM TB_FX_User  WHERE UserID = p_created_by);

	-- DAILY 일 경우 EDIT 불가
	--IF P_BUCKET = 'DAILY'
	--BEGIN
	--	SELECT v_group_id = '', v_dept_list = ''
	--END
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- 사용자의 팀정보 & 권한 - [C20210504-000057] SalesPlan 권한은 있으나 편집안되는 현상 수정 2021/05/13 SJHan (END)
	-- --------------------------------------------------------------------------------------------------------------------------------
	--=================================================================================================================================
	-- 권한 관리 (END)
	--=================================================================================================================================
DBMS_OUTPUT.PUT_LINE(p_program_id  || ' : A004--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

/* 미래 구간에 대해서는 SITE-ITEM에 있는것만 포함되어야 함. ( ETC 포함 )
   과거 구간은 전체 Data가 포함되어야 함.
   단가는 조회조건에 있는 key 기준으로 포함이 되어야 함. 단가는 Weekly로 되어 있기 때문에 Daily로 변경되어야 함.
   단위 환산이 되어야 함.*/

	--=================================================================================================================================
	-- 메져정보 셋팅 (START)
	--=================================================================================================================================
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- 20200316 KHSONG C20200224-000109 (START)
	-- --------------------------------------------------------------------------------------------------------------------------------
	SELECT COUNT(*)
  INTO v_user_mea_cnt
	FROM   SCM_MST_TITLESET_USER U
	WHERE  1 = 1
	AND    U.PROGRAM_ID						= p_program_id
	AND    U.SHEET_NAME						= p_sheet_name
	AND    U.USER_INQUIRY_COLUMN_TYPE_CODE	= 'M'
	AND    U.USER_ID						= p_created_by;

	IF v_user_mea_cnt = 0 THEN
		INSERT INTO SCM_MST_TITLESET_USER
		( USER_ID
		, PROGRAM_ID
		, SHEET_NAME
		, USER_INQUIRY_COLUMN_TYPE_CODE
		, COLUMN_NAME
		, SORT_ORDER_NO
		, SUB_TOTAL_FLAG
		, DATA_SORT_METHOD_CODE
		, CREATED_BY
		, CREATION_DATE
		, LAST_UPDATED_BY
		, LAST_UPDATE_DATE
		)
		SELECT p_created_by
		     , C.PROGRAM_ID
			 , C.SHEET_NAME
			 , 'M'
			 , C.COLUMN_NAME
			 , C.SORT_ORDER_NO
			 , ''
			 , ''
			 , p_created_by
			 , TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3')
			 , p_created_by
			 , TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3')
		FROM   SCM_MST_SHEET_MEASURE C
		WHERE  1 = 1
		AND    C.PROGRAM_ID  = p_program_id
		AND    C.SHEET_NAME  = p_sheet_name
		AND    C.DEFAULT_FLAG = 'Y'
		AND    C.VALID_YN     = 'Y'	;
	END IF;
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- 20200316 KHSONG C20200224-000109 (END)
	-- --------------------------------------------------------------------------------------------------------------------------------
DBMS_OUTPUT.PUT_LINE(p_program_id  || ' : A005--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- [E20250520-000574]_사업부와 사용여부에 따라서 데이터를 가지고 올수있도록 수정 (START)
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
	SELECT DISTINCT	U.COLUMN_NAME AS MEASURE, U.SORT_ORDER_NO, '' AS SYSTEM_ADD
	-- 20191025 KHSONG 쿼리조건오류 수정반영 & WITH TEMP 조건 용량초과 오류로 일반 TEMP테이블 생성으로 구조 변경함
	FROM SCM_MST_TITLESET_USER U
	LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL T
		   ON U.USER_ID		= T.SEGMENT4	-- 20200309 KHSONG TMM MEASURE 권한추가
		  AND p_created_by	= T.SEGMENT4	-- USER_ID
		  AND T.LOOKUP_TYPE	= 'TMM_MEASURE_ADMIN'
		  AND T.VALID_YN	= 'Y'			-- VALID_YN 여부
	WHERE 1 = 1
	AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
	AND U.PROGRAM_ID   = p_program_id
	AND U.USER_ID      = p_created_by
	AND U.USER_ID = CASE WHEN U.COLUMN_NAME = 'TMM_FCST' THEN T.SEGMENT4 ELSE p_created_by	END; -- 20200309 KHSONG TMM MEASURE 권한추가 */

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

DBMS_OUTPUT.PUT_LINE(p_program_id  || ' : A006--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- 하단에서 실적구간의 Price 를 구하기 위해서 RTF_SYS_RP 와 SalesAmt_KRW, LOC 를 추가해준다.
	-- --------------------------------------------------------------------------------------------------------------------------------
	SELECT COUNT(1)
	INTO v_cnt_4
	FROM GT_DMF0_SELECT_MEASURE WHERE MEASURE IN ( 'LOC', 'KRW' );
	IF v_cnt_4 > 0 THEN
		INSERT INTO GT_DMF0_SELECT_MEASURE ( MEASURE, SYSTEM_ADD )
		SELECT A.MEASURE, 'Y'
		FROM (	SELECT 'RTF_SYS_RP' AS MEASURE
				UNION ALL
				SELECT 'SALESAMT_KRW' AS MEASURE
				UNION ALL
				SELECT 'SALESAMT_LOC' AS MEASURE ) A
		LEFT OUTER JOIN GT_DMF0_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
		WHERE B.MEASURE IS NULL
				FROM DUAL;
	END IF;

	SELECT COUNT(1)
	INTO v_cnt_5
	FROM GT_DMF0_SELECT_MEASURE WHERE MEASURE IN ( 'MKT_FCST_RP' );
	IF v_cnt_5 > 0 THEN
		INSERT INTO GT_DMF0_SELECT_MEASURE ( MEASURE, SYSTEM_ADD )
		SELECT A.MEASURE, 'Y'
		FROM (	SELECT 'MKT_FCST' AS MEASURE
				UNION ALL
				SELECT 'RTF_SYS_RP' AS MEASURE	) A
		LEFT OUTER JOIN GT_DMF0_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
		WHERE B.MEASURE IS NULL
				FROM DUAL;
	END IF;

	-- --------------------------------------------------------------------------------------------------------------------------------
	-- [PJ2025-50017] Sales Plan 화면에서 RTF_PR 조회 시 실적구간은  RTF_SYS_RP 가져오도록 요청
	-- 사용자가 UI에서 조회 할 MEASURE를 RTF_PR만 했을 경우 계산을 위해서 RTF_SYS_RP를 내부적으로 넣는 것이다. 실제로 표시는 안함.
	-- --------------------------------------------------------------------------------------------------------------------------------
	SELECT COUNT(1)
	INTO v_cnt_6
	FROM GT_DMF0_SELECT_MEASURE WHERE MEASURE IN ( 'RTF_PR' );
	IF v_cnt_6 > 0 THEN
		INSERT INTO GT_DMF0_SELECT_MEASURE ( MEASURE, SYSTEM_ADD )
		SELECT A.MEASURE, 'Y'
		FROM (	SELECT 'RTF_SYS_RP' AS MEASURE ) A
		LEFT OUTER JOIN GT_DMF0_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
		WHERE B.MEASURE IS NULL;
	END IF;

	-- --------------------------------------------------------------------------------------------------------------------------------
	-- [PJ2025-50017] RTF_BALANCE 추가 요청
	-- 사용자가 UI에서 조회 할 MEASURE를 RTF_BALANCE만 했을 경우 계산을 위해서 RTF_SYS_RP,RTF_RP를 내부적으로 넣는 것이다. 실제로 표시는 안함.
	-- --------------------------------------------------------------------------------------------------------------------------------
	SELECT COUNT(1)
	INTO v_cnt_7
	FROM GT_DMF0_SELECT_MEASURE WHERE MEASURE IN ( 'RTF_BALANCE' );
	IF v_cnt_7 > 0 THEN
		INSERT INTO GT_DMF0_SELECT_MEASURE ( MEASURE, SYSTEM_ADD )
		SELECT A.MEASURE, 'Y'
		FROM (	SELECT 'RTF_SYS_RP' AS MEASURE
				UNION ALL
				SELECT 'RTF_PR' AS MEASURE	) A
		LEFT OUTER JOIN GT_DMF0_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
		WHERE B.MEASURE IS NULL
				FROM DUAL;
	END IF;

	-- --------------------------------------------------------------------------------------------------------------------------------
	-- [PJ2025-50188] 소형 매출계획 동기화 개선 고도화 : SCM_FCST 실적 추가 요청
	-- SCM_FCST 메저의 실적구간은 RTF_SYS_RP 를 가져와 보여주도록 한다.
	-- --------------------------------------------------------------------------------------------------------------------------------
	SELECT COUNT(1)
	INTO v_cnt_8
	FROM GT_DMF0_SELECT_MEASURE WHERE MEASURE IN ( 'SCM_FCST' );
	IF v_cnt_8 > 0 THEN
		INSERT INTO GT_DMF0_SELECT_MEASURE ( MEASURE, SYSTEM_ADD )
		SELECT A.MEASURE, 'Y'
		FROM (	SELECT 'RTF_SYS_RP' AS MEASURE) A
		LEFT OUTER JOIN GT_DMF0_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
		WHERE B.MEASURE IS NULL;
	END IF;

DBMS_OUTPUT.PUT_LINE(p_program_id  || ' : A007--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

	EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_RAW_DATA';

	EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_SHIPMENT_SITE';
DBMS_OUTPUT.PUT_LINE(p_program_id  || ' : A008--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- (1) DM_PLN_SALES_PLAN + (4) DM_PLN_SALES_PLAN (MEASURE = 'MKT_FCST')
	-- --------------------------------------------------------------------------------------------------------------------------------
	INSERT INTO GT_DMF0_RAW_DATA
	( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
	, PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
	, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
	, QTY, PLAN_RESULT, CELL_PROD_SITE_ID ) --[PJ2025-50017] CELL_PROD_SITE_ID 추가
	SELECT 'CURRENT' AS VERSION_NO, NULL AS CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
		 , A.PLANT_SITE_ID, A.ITEM_ID, NVL(A.ATTRIBUTE9, NULL) AS TEXT, A.INCOTERMS, A.DOM_EXP
		 , A.FCST_TYPE, A.CURRENCY, NULL AS COMPANY_ID, A.MEASURE, A.YYYYMMDD
		 , A.QTY, 'P' AS PLAN_RESULT
		 --, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		 , CASE WHEN A.DIVISION_ID = '40' THEN A.CELL_PROD_SITE_ID ELSE '-' END -- [PJ2025-50188] 소형 매출계획 동기화 개선 고도화 : (HSJ20250528) 소형 외 사업부 CELL_PROD_SITE_ID 치환 로직 추가
	FROM DM_PLN_SALES_PLAN A
	JOIN GT_DMF0_SELECT_MEASURE B
	  ON A.MEASURE = B.MEASURE
	JOIN SCM_MST_SITE C
	  ON A.DIVISION_ID	= C.DIVISION_ID
	 AND A.SCM_SITE_ID	= C.SCM_SITE_ID
	 AND C.VALID_YN		= 'Y'
	--LEFT OUTER JOIN GT_DMF0_SCM_MST_SITE_ITEM D ON A.DIVISION_ID = D.DIVISION_ID AND A.PROJECT_CODE = D.PROJECT_CODE AND A.SCM_SITE_ID = D.SCM_SITE_ID AND A.ITEM_ID = D.ITEM_ID AND D.VALID_YN = 'Y'
	WHERE A.YYYYMMDD >= p_now_yyyymmdd AND A.YYYYMMDD <= p_to_yyyymmdd
	AND	  A.DIVISION_ID =p_division_id
	AND (( A.MEASURE <> 'RTF_SYS_RP' AND A.QTY <> 0 ) OR ( A.MEASURE = 'RTF_SYS_RP' )) --[PJ2025-50017] Sales Plan 화면에서 RTF[R+P]가 0인 대상도 조회 가능하도록 로직 수정
	--마이그레이션 된 데이터 지우면 조건삭제
	AND	  A.FCST_TYPE NOT IN ( SELECT DISTINCT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
							   WHERE LOOKUP_TYPE	= 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'
							   AND VALID_YN			= 'Y'
							   AND SEGMENT1			= A.DIVISION_ID )
	AND	  A.ITEM_ID NOT IN ( SELECT DISTINCT SEGMENT3 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
							 WHERE LOOKUP_TYPE	= 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'
							 AND VALID_YN		= 'Y'
							 AND SEGMENT1		= A.DIVISION_ID )
	AND	  A.MEASURE NOT IN ( SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
							 WHERE LOOKUP_TYPE	= 'SALES_PLAN_CATCHUP'
							 AND VALID_YN		= 'Y' )
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- [PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 신규 테이블 추가 (START)
	-- --------------------------------------------------------------------------------------------------------------------------------
	UNION ALL
	SELECT 'CURRENT' AS VERSION_NO, NULL AS CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
		 , PLANT_SITE_ID, A.ITEM_ID, A.REMARK_TEXT, A.INCOTERMS, A.DOM_EXP
		 , A.FCST_TYPE, A.CURRENCY, NULL AS COMPANY_ID, A.MEASURE, A.YYYYMMDD
		 , A.QTY, 'P' AS PLAN_RESULT, '-' AS CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
	FROM DM_PLN_SALES_ETC_PLAN A
	JOIN GT_DMF0_SELECT_MEASURE B
	  ON A.MEASURE = B.MEASURE
	JOIN SCM_MST_SITE C
	  ON A.DIVISION_ID	= C.DIVISION_ID
	 AND A.SCM_SITE_ID	= C.SCM_SITE_ID
	 AND C.VALID_YN		= 'Y'
	WHERE A.YYYYMMDD >= p_now_yyyymmdd AND A.YYYYMMDD <= p_to_yyyymmdd
	AND	  A.DIVISION_ID = p_division_id
	AND   A.QTY	<> 0
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- [PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 신규 테이블 추가 (END)
	-- --------------------------------------------------------------------------------------------------------------------------------
	UNION ALL
	SELECT 'CURRENT' AS VERSION_NO, NULL AS CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
		 , PLANT_SITE_ID, A.ITEM_ID, NVL(A.ATTRIBUTE9, NULL) AS TEXT, A.INCOTERMS, A.DOM_EXP
		 , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.MEASURE, A.YYYYMMDD
		 , A.QTY  ||  CASE WHEN p_internal_yn = 'Y' AND P_DIVISION_ID = '82' AND ISNUMERIC(A.ATTRIBUTE2) > 0 THEN CAST(A.ATTRIBUTE2 AS NUMERIC(30,10)) ELSE 0 END AS QTY
		 , 'R' AS PLAN_RESULT
		 --, '-' AS CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		 , CELL_PROD_SITE_ID		--[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
	FROM DM_PLN_SALES_PLAN_RESULT A
	JOIN GT_DMF0_SELECT_MEASURE B
	  ON A.MEASURE = B.MEASURE
	WHERE A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < p_now_yyyymmdd
	AND	  A.DIVISION_ID = p_division_id
	AND (( A.MEASURE <> 'RTF_SYS_RP' AND A.QTY <> 0 ) OR ( A.MEASURE = 'RTF_SYS_RP' )) --[PJ2025-50017]Sales Plan 화면에서 RTF[R+P]가 0인 대상도 조회 가능하도록 로직 수정
	AND   A.MEASURE NOT IN ('RTF_PR'); --[PJ2025-50017] Sales Plan 화면에서 RTF_PR 조회 시 실적구간은  RTF_SYS_RP 가져오도록 요청

DBMS_OUTPUT.PUT_LINE(p_program_id  || ' : A009--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

	SELECT COUNT(1)
	INTO v_cnt_9
	FROM GT_DMF0_SELECT_MEASURE WHERE MEASURE = 'MKT_FCST_RP';
	IF v_cnt_9 > 0 THEN
		INSERT INTO GT_DMF0_RAW_DATA
		( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID,PROJECT_CODE, SCM_SITE_ID
		, PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
		, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
		, QTY, PLAN_RESULT, CELL_PROD_SITE_ID ) --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		SELECT VERSION_NO, A.CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE
			 , SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
			 , FCST_TYPE, CURRENCY, COMPANY_ID, 'MKT_FCST_RP' AS MEASURE, YYYYMMDD
			 , QTY, A.PLAN_RESULT, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		FROM GT_DMF0_RAW_DATA A
		WHERE A.MEASURE = 'MKT_FCST'
		AND A.YYYYMMDD >= CASE WHEN VERSION_NO = 'CURRENT' THEN p_now_yyyymmdd
							   ELSE TO_CHAR(FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON') + (-7), 'YYYYMMDD')
						  END IF;
		AND A.YYYYMMDD <= p_to_yyyymmdd;

		INSERT INTO GT_DMF0_RAW_DATA
		( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
		, PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
		, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
		, QTY, PLAN_RESULT, CELL_PROD_SITE_ID ) --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		SELECT VERSION_NO, A.CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
			 , PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
			 , FCST_TYPE, CURRENCY, COMPANY_ID, 'MKT_FCST_RP' AS MEASURE, YYYYMMDD
			 , QTY, PLAN_RESULT, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		FROM GT_DMF0_RAW_DATA A
		WHERE MEASURE = 'RTF_SYS_RP'
		AND A.YYYYMMDD >= p_from_yyyymmdd
		AND A.YYYYMMDD < CASE WHEN VERSION_NO = 'CURRENT' THEN p_now_yyyymmdd
							  ELSE TO_CHAR(FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON') + (-7), 'YYYYMMDD')
						 END;
	END;
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- [PJ2025-50017] Sales Plan 화면에서 RTF_PR 조회 시 실적구간은  RTF_SYS_RP 가져오도록 요청 (START)
	-- 사용자가 UI에서 조회 할 MEASURE를 RTF_PR만 했을 경우 계산을 위해서 RTF_SYS_RP를 내부적으로 넣는 것이다. 실제로 표시는 안함.
	-- --------------------------------------------------------------------------------------------------------------------------------
	SELECT COUNT(1)
	INTO v_cnt_10
	FROM GT_DMF0_SELECT_MEASURE WHERE MEASURE = 'RTF_PR';
	IF v_cnt_10 > 0 THEN
		INSERT INTO GT_DMF0_RAW_DATA
		( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
		, PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
		, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
		, QTY, PLAN_RESULT, CELL_PROD_SITE_ID ) --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		SELECT VERSION_NO, A.CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE ,SCM_SITE_ID
			 , PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
			 , FCST_TYPE, CURRENCY, COMPANY_ID,'RTF_PR' AS MEASURE, YYYYMMDD
			 , QTY, 'R' AS PLAN_RESULT, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		FROM GT_DMF0_RAW_DATA A
		WHERE MEASURE = 'RTF_SYS_RP'
		AND A.YYYYMMDD >= p_from_yyyymmdd
		AND A.YYYYMMDD < CASE WHEN VERSION_NO = 'CURRENT' THEN p_now_yyyymmdd
							  ELSE TO_CHAR(FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON') + (-7), 'YYYYMMDD')
						 END IF;
	END;
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- [PJ2025-50017] Sales Plan 화면에서 RTF_PR 조회 시 실적구간은  RTF_SYS_RP 가져오도록 요청 (END)
	-- --------------------------------------------------------------------------------------------------------------------------------
DBMS_OUTPUT.PUT_LINE(p_program_id  || ' : A010--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- [PJ2025-50017] RTF_BALANCE 추가 요청 (START)
	-- --------------------------------------------------------------------------------------------------------------------------------
	SELECT COUNT(1)
	INTO v_cnt_11
	FROM GT_DMF0_SELECT_MEASURE WHERE MEASURE = 'RTF_BALANCE';
	IF v_cnt_11 > 0 THEN
		INSERT INTO GT_DMF0_RAW_DATA
		( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
		, PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
		, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
		, QTY
		, PLAN_RESULT, CELL_PROD_SITE_ID) --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		-- P : PLAN(계획) 구간
		SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
			 , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
			 , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, 'RTF_BALANCE' AS MEASURE, A.YYYYMMDD
			 , (SUM(CASE WHEN MEASURE = 'RTF_SYS_RP' THEN A.QTY ELSE 0 END) - SUM(CASE WHEN MEASURE = 'RTF_PR' THEN A.QTY ELSE 0 END)) AS QTY
			 , 'P' AS PLAN_RESULT, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			FROM GT_DMF0_RAW_DATA A
			WHERE A.MEASURE IN('RTF_SYS_RP','RTF_PR')
			AND A.YYYYMMDD >= CASE WHEN VERSION_NO = 'CURRENT' THEN p_now_yyyymmdd
								   ELSE TO_CHAR(FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON') + (-7), 'YYYYMMDD')
							  END IF;
			AND A.YYYYMMDD <= p_to_yyyymmdd
			AND A.QTY > 0
			GROUP BY A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
				   , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
				   , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
	END;
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- [PJ2025-50017] RTF_BALANCE 추가 요청 (END)
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- [PJ2025-50188] 소형 매출계획 동기화 개선 고도화 : SCM_FCST 실적 추가 요청 (START)
	-- --------------------------------------------------------------------------------------------------------------------------------
	SELECT COUNT(1)
	INTO v_cnt_12
	FROM GT_DMF0_SELECT_MEASURE WHERE MEASURE = 'SCM_FCST';
	IF v_cnt_12 > 0 THEN
		INSERT INTO GT_DMF0_RAW_DATA
		( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
		, PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
		, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
		, QTY, PLAN_RESULT, CELL_PROD_SITE_ID ) --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		SELECT VERSION_NO, A.CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE ,SCM_SITE_ID
			 , PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
			 , FCST_TYPE, CURRENCY, COMPANY_ID,'SCM_FCST' AS MEASURE, YYYYMMDD
			 , QTY, 'R' AS PLAN_RESULT, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		FROM GT_DMF0_RAW_DATA A
		WHERE MEASURE = 'RTF_SYS_RP'
		AND A.YYYYMMDD >= p_from_yyyymmdd
		AND A.YYYYMMDD < CASE WHEN VERSION_NO = 'CURRENT' THEN p_now_yyyymmdd
							  ELSE TO_CHAR(FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON') + (-7), 'YYYYMMDD')
						 END IF;
	END;
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- [PJ2025-50188] 소형 매출계획 동기화 개선 고도화 : SCM_FCST 실적 추가 요청 (END)
	-- --------------------------------------------------------------------------------------------------------------------------------
DBMS_OUTPUT.PUT_LINE(p_program_id  || ' : A011--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	--=================================================================================================================================
	-- 메져정보 셋팅 (END)
	--=================================================================================================================================
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- 아래서부터는 CURRENCY를 사용해야 하므로 여기서 UPDATE 한다.
	-- --------------------------------------------------------------------------------------------------------------------------------
	UPDATE A
	SET CURRENCY = B.CURRENCY
	FROM GT_DMF0_RAW_DATA A
	JOIN SCM_MST_SITE_ITEM B
	  ON A.DIVISION_ID	= B.DIVISION_ID
	 AND A.PROJECT_CODE	= B.PROJECT_CODE
	 AND A.SCM_SITE_ID	= B.SCM_SITE_ID
	 AND A.ITEM_ID		= B.ITEM_ID
	WHERE NVL(A.CURRENCY, NULL) IS NULL;

	IF ( p_internal_yn <> 'Y') THEN
		DELETE FROM GT_DMF0_RAW_DATA
		WHERE SCM_SITE_ID IN ( SELECT COMPANY_ID FROM SCM_MST_COMPANY_SN );
	END IF;
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- 20191002 KHSONG 조회시 DB Lock 현상으로 로직수정 START
	-- --------------------------------------------------------------------------------------------------------------------------------
	/* 20230918_[E20230912-000426]_소형사업부- Sales Plan 화면 'Module' Biz Type 표기 룩업
	-- 차후 걷어내야 하므로, 원소스 주석처리함.
	/* TODO:GTT:GT_DMF0_DM_MST_ITEM_SINGLE_V-->GT_DMF0_DM_MST_ITEM_SINGLE_V */
	INSERT INTO GT_DMF0_DM_MST_ITEM_SINGLE_V
	SELECT DISTINCT A.DIVISION_ID, A.ITEM_ID, ITEM_CLASS
			, ITEM_NAME, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MIN_CAPACITY
			, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_PRODUCT_GROUP
			, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
			, ENERGE, CELL_QUANTITY
			, MDM_PROJECT_NAME, CELL_TYPE
		FROM DM_MST_ITEM_SINGLE_V A
		join ( select distinct division_id, item_id from GT_DMF0_RAW_DATA ) b on a.division_id = b.division_id and a.item_id = b.item_id
	WHERE A.DIVISION_ID = p_division_id;
	*/
	/* 2024-04-04   KCW3408     Sales Plan 관련 자동사업부 기타 매출 추가(속도개선) */

	--[E20240920-000300]_SCM.DM 화면 조회 속도 개선 START
	--원소스 주석처리
	/*
	/* TODO:GTT:GT_DMF0_DM_MST_ITEM_SINGLE_V-->GT_DMF0_DM_MST_ITEM_SINGLE_V */
	INSERT INTO GT_DMF0_DM_MST_ITEM_SINGLE_V
	SELECT DISTINCT A.DIVISION_ID, A.ITEM_ID, ITEM_CLASS
			, ITEM_NAME, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MIN_CAPACITY
			, CASE WHEN A.ITEM_ID = LOOKA.MODEL THEN LOOKA.BIZ_TYPE ELSE A.FORECAST_INFO_BIZ_TYPE END AS FORECAST_INFO_BIZ_TYPE
			, CASE WHEN A.ITEM_ID = LOOKA.MODEL THEN LOOKA.CELL_PACK_COUNT ELSE A.FORECAST_INFO_CELL_PACK_COUNT END AS FORECAST_INFO_CELL_PACK_COUNT
			, FORECAST_INFO_PRODUCT_GROUP
			, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
				--[E20240731-000852]_ENERGE 컬럼 아래에서 처리할 예정이므로, 원래 사용했던 부분은 주석처리
				--, ENERGE
			, CELL_QUANTITY
			, MDM_PROJECT_NAME, CELL_TYPE
			--[E20240731-000852]_[공급 SCM PI팀] 소형사업부 용량(Wh) 관련 칼럼/메저 추가 82은 KWH, 40은 WH를 사용하므로 두 종류 모두 추가함 START
			, ENERGE AS ENERGE_WH
			, CASE WHEN ISNUMERIC(ENERGE) > 0 THEN (TO_NUMBER(ROUND((TO_NUMBER(ENERGE))/1000, 7))) ELSE NULL END AS ENERGE
			--[E20240731-000852]_[공급 SCM PI팀] 소형사업부 용량(Wh) 관련 칼럼/메저 추가 82은 KWH, 40은 WH를 사용하므로 두 종류 모두 추가함 END
		--FROM DM_MST_ITEM_SINGLE_V A
		FROM
            (
			SELECT	T1.DIVISION_ID,
					T1.ITEM_ID,
					MAX(T1.ITEM_NAME)					AS ITEM_NAME,				--해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
					MAX(T1.ITEM_CLASS)					AS ITEM_CLASS,				--해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
					MAX(T1.ITEM_CLASS_NAME)					AS ITEM_CLASS_NAME,		--해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일
					MAX(T1.NICK_NAME)						AS NICK_NAME,			--닉네임이 NULL인 경우가 있으므로 하나로 통일
					case  min( case when T1.item_type = 'P' then 1					--타입이 사이트와 사업부, 법인에 따라 다양하게 존재 하므로 하나로 통일
									when T1.item_type = 'H' then 2					--또한 가장 완성된 상태의 자재 타입을 판매한다고 가정, 해당 자재타입을 사용함
									when T1.item_type = 'Q' then 3
									else 4 end )
													when 1 then 'P'
													when 2 then 'H'
													when 3 then 'Q'
													else 'R' end	AS ITEM_TYPE,
					MAX(T1.MATERIAL_CLASS_NAME				)		AS MATERIAL_CLASS_NAME,
					MAX(T1.ITEM_UOM							)		AS ITEM_UOM,
					MAX(T1.SPEC								)		AS SPEC,
					MAX(T1.MDM_PROJECT_NAME					)		AS MDM_PROJECT_NAME,
					MAX(T1.MIN_CAPACITY						)		AS MIN_CAPACITY,
					MAX(T2.FORECAST_INFO_BIZ_TYPE			)		AS FORECAST_INFO_BIZ_TYPE,
					MAX(T2.FORECAST_INFO_PRODUCT_GROUP		)		AS FORECAST_INFO_PRODUCT_GROUP,
					MAX(T2.FORECAST_INFO_CELL_MODEL			)		AS FORECAST_INFO_CELL_MODEL,
					MAX(T2.FORECAST_INFO_CELL_PACK_COUNT	)		AS FORECAST_INFO_CELL_PACK_COUNT,
					MAX(T2.FORECAST_INFO_SPEC				)		AS FORECAST_INFO_SPEC,
					MAX(T2.FORECAST_INFOR_VERSION			)		AS FORECAST_INFOR_VERSION,
					MAX(T1.ACTIVE_FLAG						)		AS ACTIVE_FLAG,  -- 20180720 ADD 'Y'대상중 1건 추출
					MAX(T2.CELL_TYPE						)		AS CELL_TYPE,  -- 20180911 ADD cell_type
					MAX(T1.ENERGE							)  	    AS ENERGE,			-- 20200116 khsong ADD ENERGE
					MAX(T1.CELL_QUANTITY					)	    AS CELL_QUANTITY,	-- 20200116 khsong ADD CELL_QUANTITY
					MAX(T1.SCP_EXTRA_SPEC)						  AS SCP_EXTRA_SPEC		-- [20210428 SJHAN / CSR ID:C20210323-000420]
				FROM SCM_MST_ITEM_SN T1
				INNER JOIN ( SELECT DIVISION_ID, SUBSTR(ITEM_ID, 1, 12) AS ITEM_ID
								, MAX(FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE
								, MAX(FORECAST_INFO_PRODUCT_GROUP) AS FORECAST_INFO_PRODUCT_GROUP
								, MAX(FORECAST_INFO_CELL_MODEL) AS FORECAST_INFO_CELL_MODEL
								, MAX(FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
								, MAX(FORECAST_INFO_SPEC) AS FORECAST_INFO_SPEC
								, MAX(FORECAST_INFOR_VERSION) AS FORECAST_INFOR_VERSION
								, MAX(CELL_TYPE) AS CELL_TYPE
							FROM  SCM_MST_ITEM_SN T2
							WHERE  DIVISION_ID =  p_division_id
							GROUP BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12)
						) T2 ON T1.DIVISION_ID = T2.DIVISION_ID
					AND SUBSTR(T1.ITEM_ID,1,12) = T2.ITEM_ID
				where 1=1
				AND		T1.DIVISION_ID = p_division_id
				--AND		T1.ACTIVE_FLAG = 'Y'  --이걸 막아야 건수가 동일해짐 수정전/후 count
				--WHERE ACTIVE_FLAG = 'Y'  -- 20180720 ADD 'Y'대상만
				--LGCE_FPDEV_TR.SCM_ITEM_M T1
				group by T1.DIVISION_ID, T1.ITEM_ID
        ) A;
		LEFT JOIN (
						SELECT A.MODEL
								, A.BIZ_TYPE
								, A.CELL_PACK_COUNT
								, A.MODEL_RANK
						FROM
						(
							SELECT SEGMENT2  AS MODEL
									, SEGMENT3  AS BIZ_TYPE
									, SEGMENT4  AS CELL_PACK_COUNT
									, RANK () OVER (
													PARTITION BY SEGMENT2
													ORDER BY DISPLAY_SEQ DESC
												) MODEL_RANK;
							FROM SCM_ADM_LOOKUP_MASTER_DETAIL
							WHERE LOOKUP_TYPE = 'DM_BIZ_TYPE_40'
							AND SEGMENT1 = '40'
						) A;
						WHERE MODEL_RANK = '1'
					) LOOKA;
				ON LOOKA.MODEL = A.ITEM_ID
		join ( select distinct division_id, item_id from GT_DMF0_RAW_DATA ) b
			on a.division_id = b.division_id and a.item_id = b.item_id
	WHERE A.DIVISION_ID = p_division_id;
	*/
DBMS_OUTPUT.PUT_LINE(p_program_id  || ' : A012--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

	--=================================================================================================================================
	-- MDM -> FP테이블 LGCE_SCMDPROD 동의어 SCM_MST_ITEM_SN 셋팅 VIEW 테이블을 사용하니, 화면이 느려져서 TEMP에 담는작업함 (START)
	--=================================================================================================================================
	-- --------------------------------------------------------------------------------------------------------------------------------
	--> SCM_MST_ITEM_SN 테이블을 TEMP로 넣는다.
	-- --------------------------------------------------------------------------------------------------------------------------------
	/* TODO:GTT:GT_DMF0_DM_MST_ITEM_SINGLE_ORI-->GT_DMF0_DM_MST_ITEM_SINGLE_ORI */
	INSERT INTO GT_DMF0_DM_MST_ITEM_SINGLE_ORI
	SELECT *
	FROM SCM_MST_ITEM_SN
	WHERE DIVISION_ID = p_division_id;

	-- --------------------------------------------------------------------------------------------------------------------------------
	--멈춤 현상이 발생하므로, 아예 모두 나눠서 INSERT INTO 한다.
	-- --------------------------------------------------------------------------------------------------------------------------------
	/* TODO:GTT:GT_DMF0_DM_MST_ITEM_SINGLE_A_V-->GT_DMF0_DM_MST_ITEM_SINGLE_A_V */
	INSERT INTO GT_DMF0_DM_MST_ITEM_SINGLE_A_V
	SELECT T1.DIVISION_ID
		 , T1.ITEM_ID
		 , MAX(T1.ITEM_NAME)						AS ITEM_NAME
		 , MAX(T1.ITEM_CLASS)						AS ITEM_CLASS
		 , MAX(T1.ITEM_CLASS_NAME)					AS ITEM_CLASS_NAME
		 , MAX(T1.NICK_NAME)						AS NICK_NAME
		 , CASE MIN( CASE WHEN T1.ITEM_TYPE = 'P' THEN 1
						  WHEN T1.ITEM_TYPE = 'H' THEN 2
						  WHEN T1.ITEM_TYPE = 'Q' THEN 3
					 ELSE 4 END )
									WHEN 1 THEN 'P'
									WHEN 2 THEN 'H'
									WHEN 3 THEN 'Q'
									ELSE 'R' END	AS ITEM_TYPE
		 , MAX(T1.MATERIAL_CLASS_NAME)				AS MATERIAL_CLASS_NAME
		 , MAX(T1.ITEM_UOM)							AS ITEM_UOM
		 , MAX(T1.SPEC)								AS SPEC
		 , MAX(T1.MDM_PROJECT_NAME)					AS MDM_PROJECT_NAME
		 , MAX(T1.MIN_CAPACITY)						AS MIN_CAPACITY
		 , MAX(T1.ACTIVE_FLAG)						AS ACTIVE_FLAG
		 , MAX(T1.ENERGE)							AS ENERGE
		 , MAX(T1.CELL_QUANTITY)					AS CELL_QUANTITY
		 , MAX(T1.SCP_EXTRA_SPEC)					AS SCP_EXTRA_SPEC
	FROM GT_DMF0_DM_MST_ITEM_SINGLE_ORI T1
	WHERE 1=1
	GROUP BY T1.DIVISION_ID, T1.ITEM_ID;

	-- --------------------------------------------------------------------------------------------------------------------------------
	--멈춤 현상이 발생하므로, 아예 모두 나눠서 INSERT INTO 한다.
	-- --------------------------------------------------------------------------------------------------------------------------------
	/* TODO:GTT:GT_DMF0_DM_MST_ITEM_SINGLE_B_V-->GT_DMF0_DM_MST_ITEM_SINGLE_B_V */
	INSERT INTO GT_DMF0_DM_MST_ITEM_SINGLE_B_V
	SELECT DIVISION_ID, SUBSTR(ITEM_ID, 1, 12) AS ITEM_ID
		 , MAX(FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE
		 , MAX(FORECAST_INFO_PRODUCT_GROUP) AS FORECAST_INFO_PRODUCT_GROUP
		 , MAX(FORECAST_INFO_CELL_MODEL) AS FORECAST_INFO_CELL_MODEL
		 , MAX(FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
		 , MAX(FORECAST_INFO_SPEC) AS FORECAST_INFO_SPEC
		 , MAX(FORECAST_INFOR_VERSION) AS FORECAST_INFOR_VERSION
		 , MAX(CELL_TYPE) AS CELL_TYPE
	FROM GT_DMF0_DM_MST_ITEM_SINGLE_ORI T2
	GROUP BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12);

	/* TODO:GTT:GT_DMF0_DM_MST_ITEM_SINGLE_V-->GT_DMF0_DM_MST_ITEM_SINGLE_V */
	INSERT INTO GT_DMF0_DM_MST_ITEM_SINGLE_V
	SELECT DISTINCT A.DIVISION_ID, A.ITEM_ID, ITEM_CLASS, ITEM_NAME, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MIN_CAPACITY
		 , CASE WHEN A.ITEM_ID = LOOKA.MODEL THEN LOOKA.BIZ_TYPE ELSE A.FORECAST_INFO_BIZ_TYPE END AS FORECAST_INFO_BIZ_TYPE
		 , CASE WHEN A.ITEM_ID = LOOKA.MODEL THEN LOOKA.CELL_PACK_COUNT ELSE A.FORECAST_INFO_CELL_PACK_COUNT END AS FORECAST_INFO_CELL_PACK_COUNT
		 , FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_QUANTITY, MDM_PROJECT_NAME, CELL_TYPE
		 -- --------------------------------------------------------------------------------------------------------------------------------
		 -- [E20240731-000852]_[공급 SCM PI팀] 소형사업부 용량(Wh) 관련 칼럼/메저 추가 82은 KWH, 40은 WH를 사용하므로 두 종류 모두 추가함 START
		 -- --------------------------------------------------------------------------------------------------------------------------------
		 , ENERGE AS ENERGE_WH
		 , CASE WHEN ISNUMERIC(ENERGE) > 0 THEN (TO_NUMBER(ROUND((TO_NUMBER(ENERGE))/1000, 7))) ELSE NULL END AS ENERGE
		 -- --------------------------------------------------------------------------------------------------------------------------------
		 -- [E20240731-000852]_[공급 SCM PI팀] 소형사업부 용량(Wh) 관련 칼럼/메저 추가 82은 KWH, 40은 WH를 사용하므로 두 종류 모두 추가함 END
		 -- --------------------------------------------------------------------------------------------------------------------------------
	FROM (	SELECT T1.DIVISION_ID, T1.ITEM_ID, T1.ITEM_NAME, T1.ITEM_CLASS, T1.ITEM_CLASS_NAME, T1.NICK_NAME, T1.ITEM_TYPE, T1.MATERIAL_CLASS_NAME
				 , T1.ITEM_UOM, T1.SPEC, T1.MDM_PROJECT_NAME, T1.MIN_CAPACITY, T2.FORECAST_INFO_BIZ_TYPE, T2.FORECAST_INFO_PRODUCT_GROUP
				 , T2.FORECAST_INFO_CELL_MODEL, T2.FORECAST_INFO_CELL_PACK_COUNT, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION, T1.ACTIVE_FLAG
				 , T2.CELL_TYPE, T1.ENERGE, T1.CELL_QUANTITY, T1.SCP_EXTRA_SPEC
			FROM GT_DMF0_DM_MST_ITEM_SINGLE_A_V T1
			INNER JOIN GT_DMF0_DM_MST_ITEM_SINGLE_B_V T2 ON T1.DIVISION_ID = T2.DIVISION_ID AND SUBSTR(T1.ITEM_ID, 1, 12) = T2.ITEM_ID
			WHERE 1=1 ) A
	LEFT JOIN (	SELECT A.MODEL, A.BIZ_TYPE, A.CELL_PACK_COUNT, A.MODEL_RANK
				FROM (	SELECT SEGMENT2  AS MODEL, SEGMENT3  AS BIZ_TYPE, SEGMENT4  AS CELL_PACK_COUNT
							 , RANK () OVER ( PARTITION BY SEGMENT2 ORDER BY DISPLAY_SEQ DESC ) AS MODEL_RANK
						FROM SCM_ADM_LOOKUP_MASTER_DETAIL 	WHERE LOOKUP_TYPE = 'DM_BIZ_TYPE_40' AND SEGMENT1 = '40') A
				WHERE MODEL_RANK = '1' ) LOOKA ON LOOKA.MODEL = A.ITEM_ID
	JOIN ( SELECT DISTINCT DIVISION_ID, ITEM_ID FROM GT_DMF0_RAW_DATA ) B ON  A.DIVISION_ID = B.DIVISION_ID AND  A.ITEM_ID = B.ITEM_ID
	WHERE A.DIVISION_ID = p_division_id;
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- [E20240920-000300]_SCM.DM 화면 조회 속도 개선 END
	-- --------------------------------------------------------------------------------------------------------------------------------
	CREATE CLUSTERED INDEX IDX1_TEMP_DM_MST_ITEM_SINGLE_V ON GT_DMF0_DM_MST_ITEM_SINGLE_V
	( DIVISION_ID ASC, ITEM_ID ASC) WITH
	( PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON PRIMARY

	--=================================================================================================================================
	-- MDM -> FP테이블 LGCE_SCMDPROD 동의어 SCM_MST_ITEM_SN 셋팅 VIEW 테이블을 사용하니, 화면이 느려져서 TEMP에 담는작업함 (END)
	--=================================================================================================================================
	/* [E20240731-000852]_MDM에서 DM으로 ENERGE I/F 단위는 WH인데, 82사업부는 KW기준
							40번 사업부는 WH기준으로 보여주길 원하므로 82사업부인 경우에만 KWH로 나오도록 조건 추가
	IF ( P_DIVISION_ID = '82' )
	BEGIN
		--[E20240731-000856]_[공급 SCM PI팀] Wh --> KWh 환산 로직개선 START
		--해당 테이블의 데이터를 쓰므로, 데이터 완료된 후 KWH로 변경한다.
		UPDATE GT_DMF0_DM_MST_ITEM_SINGLE_V
		SET ENERGE = CASE WHEN ISNUMERIC(ENERGE) > 0 THEN ROUND((TO_NUMBER(ENERGE))/1000, 4) ELSE NULL END
		FROM GT_DMF0_DM_MST_ITEM_SINGLE_V
		WHERE DIVISION_ID = '82';
		--[E20240731-000856]_[공급 SCM PI팀] Wh --> KWh 환산 로직개선 END
	*/
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- 20191002 KHSONG 조회시 DB Lock 현상으로 로직수정 (END)
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- 20190326 속도개선 ITEM_SINGLE_V TEMP TABLE 사용 (END)
	-- --------------------------------------------------------------------------------------------------------------------------------
DBMS_OUTPUT.PUT_LINE(p_program_id  || ' : A013--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	--=================================================================================================================================
	-- 20190326 오류개선 STUFF시 정렬오류로 멀티OWNER가 분리되는 오류발생으로 TEMP사용 (START)
	--=================================================================================================================================
	/* TODO:GTT:GT_DMF0_SCM_MST_SITE_ITEM-->GT_DMF0_SCM_MST_SITE_ITEM */
	INSERT INTO GT_DMF0_SCM_MST_SITE_ITEM
	SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, APPLICATION, CUST_GROUP, ROUTE, CUST_GROUP_DTL, CELL_PER_CAR, CELL_PER_MODULE
		 , CURRENCY, SALES_COMPANY, SALES_PLANT, SALES_PLAN_ADJUST_YN, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE5, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9
		 , REPORT_GROUP6, A.OWNER, FN_GET_DM_MKT_OWNER_NAME( A.OWNER, ',', 'EN' ) AS OWNER_NAME
		 , FN_GET_DM_MKT_OWNER_NAME( A.OWNER, ',', 'KO' ) AS OWNER_NAME_KO
		 , ( SELECT SU.DEPT_ID FROM SCM_MST_SSO_USER_INFO SU
			 WHERE SU.USER_ID = (SELECTtoken FROM TABLE(fn_string_split(a.owner, ',')))) AS DEPT_ID, VALID_YN
	FROM SCM_MST_SITE_ITEM A
	JOIN ( SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID FROM GT_DMF0_RAW_DATA ) B
	  ON A.DIVISION_ID	= B.DIVISION_ID
	 AND A.SCM_SITE_ID	= B.SCM_SITE_ID
	 AND A.PROJECT_CODE = B.PROJECT_CODE
	 AND A.ITEM_ID		= B.ITEM_ID
	WHERE A.DIVISION_ID = p_division_id;
	--=================================================================================================================================
	-- 20190326 오류개선 STUFF시 정렬오류로 멀티OWNER가 분리되는 오류발생으로 TEMP사용 (END)
	--=================================================================================================================================
	--DELETE A
	--FROM GT_DMF0_RAW_DATA A
	--LEFT OUTER JOIN GT_DMF0_SCM_MST_SITE_ITEM B ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
	--WHERE A.PLAN_RESULT = 'P'
	--	AND A.ITEM_ID NOT IN ('ETC', 'ED_D','TOOLING','MDF')
	--	AND NVL(B.VALID_YN, NULL) <> 'Y'
	--  AND A.VERSION_NO = 'CURRENT'	( 수정 전 로직이 버전구분 없이 처리 )

DBMS_OUTPUT.PUT_LINE(p_program_id  || ' : A014--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
FETCH FIRST 1 ROWS ONLY;
	--=================================================================================================================================
	-- [PJ2024-50611] 화면에서 저장한 dept_id 업데이트 (START)
	-- 화면에서 병합되어야 하므로 RESULT에도 동일한 값이 필요함
	--=================================================================================================================================
	UPDATE A
	SET ATTRIBUTE1 = B.ATTRIBUTE1
	FROM GT_DMF0_RAW_DATA A
	JOIN ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
				, ATTRIBUTE1, REMARK_TEXT --[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 필드추가
				, '-' AS CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			--FROM DM_PLN_SALES_PLAN
			FROM DM_PLN_SALES_ETC_PLAN --[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 테이블 변경
			WHERE DIVISION_ID	= '40'
			AND   FCST_TYPE		= 'ETC'
			AND   YYYYMMDD		>= p_now_yyyymmdd AND YYYYMMDD <= p_to_yyyymmdd
			AND   QTY <> 0 ) B
	  ON A.DIVISION_ID			= B.DIVISION_ID
	 AND A.PROJECT_CODE			= B.PROJECT_CODE
	 AND A.SCM_SITE_ID			= B.SCM_SITE_ID
	 AND A.ITEM_ID				= B.ITEM_ID
	 AND A.DOM_EXP				= B.DOM_EXP
	 AND A.FCST_TYPE			= B.FCST_TYPE
	 AND A.INCOTERMS			= B.INCOTERMS
	 AND A.PLANT_SITE_ID		= B.PLANT_SITE_ID
	 AND A.YYYYMMDD				= B.YYYYMMDD
	 AND A.TEXT					= B.REMARK_TEXT--[PJ2024-50611] 기타매출, Catch Up 테이블 분리 : 조인추가
	 AND A.CELL_PROD_SITE_ID	= B.CELL_PROD_SITE_ID; --[PJ2025-50017] CELL_PROD_SITE_ID 추가
	--=================================================================================================================================
	-- [PJ2024-50611] 화면에서 저장한 dept_id 처리 (END)
	--=================================================================================================================================
DBMS_OUTPUT.PUT_LINE(p_program_id  || ' : A015--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	--=================================================================================================================================
	-- 조회조건에 따른 필터링 처리 ( PRICE 계산시 부하문제로 필터링은 여기서 하고, 필요없는 메저는 PRICE 끝난 후 제거 ) (START)
	--=================================================================================================================================
	BEGIN
		IF ( p_project_code IS NOT NULL) THEN
			DELETE A
			FROM GT_DMF0_RAW_DATA A
			JOIN SCM_MST_PROJECT B
			  ON A.DIVISION_ID = B.DIVISION_ID
			 AND A.PROJECT_CODE = B.PROJECT_CODE
			LEFT OUTER JOIN ( SELECT DISTINCT token FROM TABLE(fn_string_split(p_project_code,','))) C
						 ON B.PROJECT_CODE LIKE '%'  ||  C.TOKEN  ||  '%'
			LEFT OUTER JOIN ( SELECT DISTINCT token FROM TABLE(fn_string_split(p_project_code,','))) D
						 ON B.PROJECT_NAME LIKE '%'  ||  D.TOKEN  ||  '%'
			WHERE C.TOKEN IS NULL
			AND   D.TOKEN IS NULL;
		END IF;

		IF ( p_item_id IS NOT NULL) THEN
			DELETE A
			FROM GT_DMF0_RAW_DATA A
			LEFT OUTER JOIN GT_DMF0_DM_MST_ITEM_SINGLE_V B ON A.ITEM_ID = B.ITEM_ID
			LEFT OUTER JOIN ( SELECT DISTINCT token FROM TABLE(fn_string_split(p_item_id,','))) C
						 ON A.ITEM_ID LIKE '%'  ||  C.TOKEN  ||  '%'
			LEFT OUTER JOIN ( SELECT DISTINCT token	FROM TABLE(fn_string_split(p_item_id,','))) D
						 ON B.NICK_NAME LIKE '%'  ||  D.TOKEN  ||  '%'
			WHERE C.TOKEN IS NULL
			AND   D.TOKEN IS NULL;
		END IF;

		IF ( p_owner IS NOT NULL) THEN
			DELETE A
			FROM GT_DMF0_RAW_DATA A
			LEFT OUTER JOIN GT_DMF0_SCM_MST_SITE_ITEM B
						 ON A.ITEM_ID		= B.ITEM_ID
						AND A.SCM_SITE_ID	= B.SCM_SITE_ID
						AND A.PROJECT_CODE	= B.PROJECT_CODE
			LEFT OUTER JOIN ( SELECT DISTINCT token FROM TABLE(fn_string_split(p_owner,','))) C
						 ON B.OWNER LIKE '%'  ||  C.TOKEN  ||  '%'
			LEFT OUTER JOIN ( SELECT DISTINCT token FROM TABLE(fn_string_split(p_owner,','))) D
						 ON B.OWNER_NAME LIKE '%'  ||  D.TOKEN  ||  '%'
			LEFT OUTER JOIN ( SELECT DISTINCT token FROM TABLE(fn_string_split(p_owner,','))) E
						 ON B.OWNER_NAME_KO LIKE '%'  ||  E.TOKEN  ||  '%'
			WHERE C.TOKEN IS NULL
			AND   D.TOKEN IS NULL
			AND   E.TOKEN IS NULL;
		END IF;
DBMS_OUTPUT.PUT_LINE(p_program_id  || ' : A016--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
		IF ( p_dept_id <> 'ALL') THEN
			-- --------------------------------------------------------------------------------------------------------------------------------
			-- [PJ2024-50461] Team Mapping (START)
			-- 기타매출은 기존 SALE SITE 정보를 이용하므로 검색시도 구분해야함
			-- --------------------------------------------------------------------------------------------------------------------------------
			-- --------------------------------------------------------------------------------------------------------------------------------
			--기타매출 이외
			-- --------------------------------------------------------------------------------------------------------------------------------
			DELETE A
			FROM GT_DMF0_RAW_DATA A
			LEFT OUTER JOIN GT_DMF0_SCM_MST_SITE_ITEM B
						 ON A.ITEM_ID		= B.ITEM_ID
						AND A.SCM_SITE_ID	= B.SCM_SITE_ID
						AND A.PROJECT_CODE	= B.PROJECT_CODE
			LEFT OUTER JOIN ( SELECT DISTINCT token FROM TABLE(fn_string_split(p_dept_id,','))) C
						 ON B.DEPT_ID = C.TOKEN
			WHERE C.TOKEN IS NULL
			AND   A.FCST_TYPE <> 'ETC';

			-- --------------------------------------------------------------------------------------------------------------------------------
			--기타매출(40 이외 사업부)
			-- --------------------------------------------------------------------------------------------------------------------------------
			DELETE A
			FROM GT_DMF0_RAW_DATA A
			LEFT OUTER JOIN SCM_MST_SITE B
						 ON A.SCM_SITE_ID = B.SCM_SITE_ID
						AND B.DIVISION_ID = P_DIVISION_ID
			LEFT OUTER JOIN ( SELECT DISTINCT token FROM TABLE(fn_string_split(p_dept_id,','))) C
						 ON B.DEPT_ID = C.TOKEN
			WHERE C.TOKEN IS NULL
			AND   A.FCST_TYPE = 'ETC'
			AND A.DIVISION_ID <> '40'; --[PJ2024-50611] 40 이외 사업부는 기타일 경우 SCM_MST_SITE 에서 가져옴

			-- --------------------------------------------------------------------------------------------------------------------------------
			-- [PJ2024-50611]_기타매출(40사업부) (START)
			-- --------------------------------------------------------------------------------------------------------------------------------
			DELETE A
			FROM GT_DMF0_RAW_DATA A
			LEFT OUTER JOIN ( SELECT DISTINCT token FROM TABLE(fn_string_split(p_dept_id,','))) C
						 ON A.ATTRIBUTE1 = C.TOKEN --[PJ2024-50611] 40사업부 기타매출은 ATTRIBUTE1 에 부서코드 있음
			WHERE C.TOKEN IS NULL
			AND   A.FCST_TYPE	= 'ETC'
			AND   A.DIVISION_ID = '40';
			-- --------------------------------------------------------------------------------------------------------------------------------
			-- [PJ2024-50611]기타매출(40사업부) (END)
			-- --------------------------------------------------------------------------------------------------------------------------------
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
					LEFT OUTER JOIN SCM_MST_SITE B  ON A.SCM_SITE_ID = B.SCM_SITE_ID AND B.DIVISION_ID = P_DIVISION_ID
					LEFT OUTER JOIN (	SELECT DISTINCT token
										FROM TABLE(fn_string_split(p_dept_id,','))
									) C	ON B.DEPT_ID = C.TOKEN
					WHERE C.TOKEN IS NULL;
				*/
			-- --------------------------------------------------------------------------------------------------------------------------------
			--[PJ2024-50461] Team Mapping end
			-- --------------------------------------------------------------------------------------------------------------------------------
		END IF;
DBMS_OUTPUT.PUT_LINE(p_program_id  || ' : A017--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

		IF ( p_end_customer <> 'ALL') THEN
			IF ( P_DIVISION_ID = '40') THEN
				DELETE A
				FROM GT_DMF0_RAW_DATA A
				LEFT OUTER JOIN ( SELECT DISTINCT token FROM TABLE(fn_string_split(p_end_customer,','))) C
							 ON A.PROJECT_CODE = C.TOKEN
				WHERE C.TOKEN IS NULL;
			ELSE
				DELETE A
				FROM GT_DMF0_RAW_DATA A
				LEFT OUTER JOIN SCM_MST_SITE B
							 ON A.SCM_SITE_ID = B.SCM_SITE_ID
							AND B.DIVISION_ID = P_DIVISION_ID
				LEFT OUTER JOIN ( SELECT DISTINCT token FROM TABLE(fn_string_split(p_end_customer,','))) C
							 ON B.END_CUSTOMER = C.TOKEN
				WHERE C.TOKEN IS NULL;
			END IF;
DBMS_OUTPUT.PUT_LINE(p_program_id  || ' : A018--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

		IF ( p_scm_site_id <> 'ALL') THEN
			DELETE A
			FROM GT_DMF0_RAW_DATA A
			LEFT OUTER JOIN (	SELECT DISTINCT token FROM TABLE(fn_string_split(p_scm_site_id,','))) C
						 ON A.SCM_SITE_ID = C.TOKEN
			WHERE C.TOKEN IS NULL;
		END IF;

		IF ( p_plant_site_id <> 'ALL') THEN
			DELETE A
			FROM GT_DMF0_RAW_DATA A
			LEFT OUTER JOIN ( SELECT DISTINCT token	FROM TABLE(fn_string_split(p_plant_site_id,','))) C
						 ON A.PLANT_SITE_ID = C.TOKEN
			WHERE C.TOKEN IS NULL;
		END IF;
DBMS_OUTPUT.PUT_LINE(p_program_id  || ' : A019--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

		IF ( p_item_type <> 'ALL') THEN
			DELETE A
			FROM GT_DMF0_RAW_DATA A
			LEFT OUTER JOIN GT_DMF0_DM_MST_ITEM_SINGLE_V B
						 ON A.ITEM_ID = B.ITEM_ID
			LEFT OUTER JOIN ( SELECT DISTINCT token	FROM TABLE(fn_string_split(p_item_type,','))) C
						 ON B.ITEM_TYPE = C.TOKEN
			WHERE C.TOKEN IS NULL;
		END IF;

		IF ( p_biztype <> 'ALL') THEN
			IF( P_DIVISION_ID = '40' ) THEN
				DELETE A
				FROM GT_DMF0_RAW_DATA A
				LEFT OUTER JOIN GT_DMF0_DM_MST_ITEM_SINGLE_V B
							 ON A.ITEM_ID = B.ITEM_ID
				LEFT OUTER JOIN ( SELECT DISTINCT token FROM TABLE(fn_string_split(p_biztype,','))) C
							 ON B.FORECAST_INFO_BIZ_TYPE = C.TOKEN
				WHERE C.TOKEN IS NULL;
			ELSE
				DELETE A
				FROM GT_DMF0_RAW_DATA A
				JOIN SCM_MST_PROJECT B
				  ON A.DIVISION_ID	= B.DIVISION_ID
				 AND A.PROJECT_CODE = B.PROJECT_CODE
				LEFT OUTER JOIN ( SELECT DISTINCT token	FROM TABLE(fn_string_split(p_biztype,','))) C
							 ON B.BIZ_TYPE LIKE '%'  ||  C.TOKEN  ||  '%'
				WHERE C.TOKEN IS NULL;
			END IF;
	END;
	--=================================================================================================================================
	-- 조회조건에 따른 필터링 처리 ( PRICE 계산시 부하문제로 필터링은 여기서 하고, 필요없는 메저는 PRICE 끝난 후 제거 ) (END)
	--=================================================================================================================================
DBMS_OUTPUT.PUT_LINE(p_program_id  || ' : A020--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	--=================================================================================================================================
	-- 실적구간 PRICE 처리 (START)
	--=================================================================================================================================
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- LOC 메져 생성
	-- --------------------------------------------------------------------------------------------------------------------------------
	SELECT COUNT(1)
	INTO v_cnt_13
	FROM GT_DMF0_SELECT_MEASURE WHERE MEASURE = 'LOC';
	IF v_cnt_13 > 0 THEN
		INSERT INTO GT_DMF0_RAW_DATA
		( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
		, PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
		, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
		, QTY, PLAN_RESULT, CELL_PROD_SITE_ID) --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
			 , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
			 , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, 'LOC' AS MEASURE, A.YYYYMMDD
			 , CASE WHEN A.QTY <> 0 THEN B.QTY/A.QTY ELSE 0 END AS QTY, 'R' AS PLAN_RESULT, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		FROM ( SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
					, A.PLANT_SITE_ID, A.ITEM_ID ,A.TEXT, A.INCOTERMS, A.DOM_EXP
					, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, SUM(A.QTY) AS QTY
					, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			   FROM GT_DMF0_RAW_DATA A
			   WHERE YYYYMMDD >= v_start_yyyymmdd
			   AND YYYYMMDD < CASE WHEN VERSION_NO = 'CURRENT' THEN p_now_yyyymmdd
								   ELSE TO_CHAR(FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON') + (-7), 'YYYYMMDD')
							  END IF;
			   AND A.MEASURE = 'RTF_SYS_RP'
			   GROUP BY A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
					  , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
					  , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			 ) A;
		JOIN ( SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
		  			, A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
					, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, SUM(A.QTY) AS QTY
					, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			   FROM GT_DMF0_RAW_DATA A
			   WHERE YYYYMMDD >= v_start_yyyymmdd
			   AND YYYYMMDD < CASE WHEN VERSION_NO = 'CURRENT' THEN p_now_yyyymmdd
								   ELSE TO_CHAR(FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON') + (-7), 'YYYYMMDD')
							  END;
			   AND A.MEASURE = 'SalesAmt_LOC'
			   GROUP BY A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
					  , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT,A.INCOTERMS, A.DOM_EXP
					  , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
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
DBMS_OUTPUT.PUT_LINE(p_program_id  || ' : A021--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- KRW 메져 생성
	-- --------------------------------------------------------------------------------------------------------------------------------
	SELECT COUNT(1)
	INTO v_cnt_14
	FROM GT_DMF0_SELECT_MEASURE WHERE MEASURE = 'KRW';
	IF v_cnt_14 > 0 THEN
		INSERT INTO GT_DMF0_RAW_DATA
		( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
		, PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
		, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
		, QTY, PLAN_RESULT, CELL_PROD_SITE_ID ) --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
			 , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
			 , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, 'KRW' AS MEASURE, A.YYYYMMDD
			 , CASE WHEN A.QTY <> 0 THEN B.QTY/A.QTY ELSE 0 END AS QTY, 'R' AS PLAN_RESULT, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		FROM ( SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
					, A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
					, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, SUM(A.QTY) AS QTY
					,A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
				FROM GT_DMF0_RAW_DATA A
				WHERE YYYYMMDD >= v_start_yyyymmdd
				AND   YYYYMMDD < CASE WHEN VERSION_NO = 'CURRENT' THEN p_now_yyyymmdd
									  ELSE TO_CHAR(FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON') + (-7), 'YYYYMMDD')
								 END IF;
				AND	  A.MEASURE = 'RTF_SYS_RP'
				GROUP BY A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
					   , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
					   , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD
					   , A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			 ) A;
		JOIN ( SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
		  			, A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
					, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, SUM(A.QTY) AS QTY
					, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
				FROM GT_DMF0_RAW_DATA A
				WHERE YYYYMMDD >= v_start_yyyymmdd
				AND YYYYMMDD < CASE WHEN VERSION_NO = 'CURRENT' THEN p_now_yyyymmdd
									ELSE TO_CHAR(FN_NEXT_DAY( CUTOFF_YYYYMMDD, 'MON') + (-7), 'YYYYMMDD')
							   END;
				AND A.MEASURE = 'SalesAmt_KRW'
				GROUP BY A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
					   , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
					   , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
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
	--=================================================================================================================================
	-- 실적구간 PRICE 처리 (END)
	--=================================================================================================================================
DBMS_OUTPUT.PUT_LINE(p_program_id  || ' : A022--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	--=================================================================================================================================
	-- 계획구간 PRICE 처리 (START)
	--=================================================================================================================================
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- 'KRW', 'LOC', 'USD' 메져 생성
	-- 40사업부 PRICE: DM_PLN_CFM_SELLING_PRICE 테이블 사용, 타 사업부 PRICE: SCM_MST_FUTURE_PRICE
	-- --------------------------------------------------------------------------------------------------------------------------------
	SELECT COUNT(1)
	INTO v_cnt_15
	FROM GT_DMF0_SELECT_MEASURE WHERE MEASURE IN ( 'KRW', 'LOC', 'USD');
	IF v_cnt_15 > 0 THEN
		IF ( P_DIVISION_ID = '40') THEN
			INSERT INTO GT_DMF0_RAW_DATA
			( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
			, PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
			, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
			, QTY, PLAN_RESULT, CELL_PROD_SITE_ID ) --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
				 , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
				 , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, C.MEASURE, A.YYYYMMDD
				 , C.PRICE, 'P' AS PLAN_RESULT, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			FROM ( SELECT DISTINCT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
						, A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
						, A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
				   FROM GT_DMF0_RAW_DATA A
				   WHERE A.YYYYMMDD >= p_now_yyyymmdd AND A.YYYYMMDD <= p_to_yyyymmdd
				   AND   A.MEASURE IN ( 'RTF_SYS_RP', 'MKT_FCST_RP', 'MKT_FCST', 'RTF_SCP', 'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW','Catch_Up' )--[PJ2024-50611] Catch_Up 추가
				  ) A;
			JOIN SCM_SYS_CALENDAR_M B
			  ON A.YYYYMMDD				= B.BASIS_YYYYMMDD
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
			 AND B.BASIS_START_DATE		= C.YYYYMMDD
			 AND C.YYYYMMDD				<= p_to_yyyymmdd
			JOIN GT_DMF0_SELECT_MEASURE D
			  ON C.MEASURE				= D.MEASURE
		ELSE  -- ( P_DIVISION_ID <> '40')
			INSERT INTO GT_DMF0_RAW_DATA
			( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
			, PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
			, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
			, QTY, PLAN_RESULT, CELL_PROD_SITE_ID ) --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
				 , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
				 , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, C.MEASURE, A.YYYYMMDD
				 , C.PRICE, 'P' AS PLAN_RESULT, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
			FROM ( SELECT DISTINCT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
						 , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
						 , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
				   FROM GT_DMF0_RAW_DATA A
				   WHERE A.YYYYMMDD >= p_now_yyyymmdd AND A.YYYYMMDD <= p_to_yyyymmdd
				   AND   A.MEASURE IN ( 'RTF_SYS_RP', 'MKT_FCST_RP', 'MKT_FCST', 'RTF_SCP', 'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW','Catch_Up' )--[PJ2024-50611] Catch_Up 추가
				 ) A;
			JOIN SCM_SYS_CALENDAR_M B
			  ON A.YYYYMMDD			= B.BASIS_YYYYMMDD
			JOIN SCM_MST_FUTURE_PRICE C
			  ON A.DIVISION_ID		= C.DIVISION_ID
			 AND A.PROJECT_CODE		= C.PROJECT_CODE
			 AND A.SCM_SITE_ID		= C.SCM_SITE_ID
			 AND A.PLANT_SITE_ID	= C.PLANT_SITE_ID
			 AND A.ITEM_ID			= C.ITEM_ID
			 AND A.INCOTERMS		= C.INCOTERMS
			 AND A.DOM_EXP			= C.DOM_EXP
			 AND A.FCST_TYPE		= C.FCST_TYPE
			 AND B.basis_start_date	= C.YYYYMMDD
			 AND C.YYYYMMDD			<= p_to_yyyymmdd
			JOIN GT_DMF0_SELECT_MEASURE D
			  ON C.MEASURE = D.MEASURE
		END IF;
	--=================================================================================================================================
	-- 계획구간 PRICE 처리 (END)
	--=================================================================================================================================
DBMS_OUTPUT.PUT_LINE(p_program_id  || ' : A023--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

	--=================================================================================================================================
	-- 필요없는 메저 삭제 (START) -> 사용자가 선택한 메져가 아니라, 메져를 만들기 위해 임의로 추가한 메져를 삭제한다.
	--=================================================================================================================================
	DELETE A
	FROM GT_DMF0_RAW_DATA A
	JOIN GT_DMF0_SELECT_MEASURE B
	  ON A.MEASURE = B.MEASURE
	WHERE B.SYSTEM_ADD = 'Y'
	--=================================================================================================================================
	-- 필요없는 메저 삭제 (END)
	--=================================================================================================================================
	--=================================================================================================================================
	-- 물리적으로 생성하지 않는 메져의 경우 하단에서 생성해준다 (START)
	-- MEASURE: 'MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL', 'RTF_SYS_RP_CAR', 'RTF_SYS_RP_CELL', 'RTF_ENERGY', 'MKT_FCST_ENERGY'
	-- 화면: MKT FCST[R+P] CAR, MKT FCST[R+P] CELL, RTF[R+P] CAR, RTF[R+P] CELL, RTF[R+P] Energy(MWH), MKT FCST[R+P] Energy(MWH)
	--=================================================================================================================================
	SELECT COUNT(1)
	INTO v_cnt_16
	FROM GT_DMF0_SELECT_MEASURE WHERE MEASURE IN ( 'MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL', 'RTF_SYS_RP_CAR', 'RTF_SYS_RP_CELL', 'RTF_ENERGY', 'MKT_FCST_ENERGY');
	IF v_cnt_16 > 0 THEN
		INSERT INTO GT_DMF0_RAW_DATA
		( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
		, PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
		, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
		, QTY, PLAN_RESULT, CELL_PROD_SITE_ID  ) --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
			 , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
			 , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, B.MEASURE_CALC, A.YYYYMMDD
			 , CASE	WHEN B.MEASURE_CALC IN ('MKT_FCST_RP_CAR','RTF_RP_CAR','RTF_SYS_RP_CAR')
					THEN CASE WHEN INSTR(C.ITEM_CLASS_NAME, 'Cell') > 0 AND D.CELL_PER_CAR > 0 THEN QTY / D.CELL_PER_CAR
							  WHEN  INSTR(C.ITEM_CLASS_NAME, 'Module') > 0  AND D.CELL_PER_CAR > 0 AND D.CELL_PER_MODULE > 0 THEN QTY/ ( D.CELL_PER_CAR/ D.CELL_PER_MODULE )
							  WHEN  INSTR(C.ITEM_CLASS_NAME, 'Pack') > 0  THEN A.QTY
							  ELSE 0
						 END IF;
					WHEN B.MEASURE_CALC IN ('MKT_FCST_RP_CELL','RTF_RP_CELL','RTF_SYS_RP_CELL') AND A.DIVISION_ID LIKE '81%'
					THEN CASE WHEN INSTR(C.ITEM_CLASS_NAME, 'Cell') > 0 AND D.CELL_PER_CAR > 0 THEN A.QTY
							  WHEN ( INSTR(C.ITEM_CLASS_NAME, 'Module') > 0 OR INSTR(C.ITEM_CLASS_NAME, 'Pack') > 0 ) AND D.CELL_PER_MODULE > 0 THEN A.QTY * D.CELL_PER_MODULE
							  ELSE 0
						 END;
					WHEN B.MEASURE_CALC IN ('MKT_FCST_RP_CELL','RTF_RP_CELL','RTF_SYS_RP_CELL') AND A.DIVISION_ID = '82' THEN A.QTY * C.CELL_QUANTITY
					-- --------------------------------------------------------------------------------------------------------------------------------
					-- 20211119 ROSIA27 [C20211103-000146] ESS영업관리팀 GSCM 용량 Measure 값 생성 요청의 건
					-- --------------------------------------------------------------------------------------------------------------------------------
					WHEN B.MEASURE_CALC = 'RTF_ENERGY'
					THEN CASE WHEN ISNUMERIC(C.ENERGE) > 0 THEN (A.QTY * C.ENERGE)/1000	END
					-- --------------------------------------------------------------------------------------------------------------------------------
					-- 20221214 ROSIA27 [C20221207-000080] ESS영업관리팀 GSCM 내 Measrue값 추가 요청  MKT FCST[R+P] Energy
					-- --------------------------------------------------------------------------------------------------------------------------------
					WHEN B.MEASURE_CALC = 'MKT_FCST_ENERGY' AND B.MEASURE_ORI = 'RTF_SYS_RP' AND A.PLAN_RESULT = 'R'
					THEN CASE WHEN ISNUMERIC(C.ENERGE) > 0 THEN (A.QTY * C.ENERGE)/1000	END
					ELSE 0
				END;
			 , A.PLAN_RESULT
			 , A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		FROM GT_DMF0_RAW_DATA A
		JOIN ( SELECT CASE WHEN A.MEASURE LIKE 'MKT_FCST_RP%' THEN 'MKT_FCST_RP'
						   ELSE 'RTF_SYS_RP'
					  END AS MEASURE_ORI
					, A.MEASURE AS MEASURE_CALC
				FROM GT_DMF0_SELECT_MEASURE A
				WHERE MEASURE IN ( 'MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL', 'RTF_SYS_RP_CAR', 'RTF_SYS_RP_CELL', 'RTF_ENERGY', 'MKT_FCST_ENERGY')
			  ) B;
		  ON A.MEASURE		= B.MEASURE_ORI
		JOIN GT_DMF0_DM_MST_ITEM_SINGLE_V C
		  ON A.ITEM_ID		= C.ITEM_ID
		 AND A.DIVISION_ID	= C.DIVISION_ID
		LEFT OUTER JOIN GT_DMF0_SCM_MST_SITE_ITEM D
					 ON A.DIVISION_ID	= D.DIVISION_ID
					AND A.SCM_SITE_ID	= D.SCM_SITE_ID
					AND A.PROJECT_CODE	= D.PROJECT_CODE
					AND A.ITEM_ID		= D.ITEM_ID
		WHERE A.MEASURE IN ( 'MKT_FCST_RP', 'RTF_SYS_RP' );
	END;
	--=================================================================================================================================
	-- 물리적으로 생성하지 않는 메져의 경우 하단에서 생성해준다 (END)
	--=================================================================================================================================
DBMS_OUTPUT.PUT_LINE(p_program_id  || ' : A024--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	--=================================================================================================================================
	-- 20221214 ROSIA27 [C20221207-000080] ESS영업관리팀 GSCM 내 Measrue값 추가 요청  MKT FCST[R+P] Energy (START)
	--=================================================================================================================================
	SELECT COUNT(1)
	INTO v_cnt_17
	FROM GT_DMF0_SELECT_MEASURE WHERE MEASURE IN ('MKT_FCST_ENERGY');
	IF v_cnt_17 > 0 THEN
		INSERT INTO GT_DMF0_RAW_DATA
		( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
		, PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
		, FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
		, QTY, PLAN_RESULT, CELL_PROD_SITE_ID ) --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
			 , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
			 , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, B.MEASURE_CALC, A.YYYYMMDD
			 , CASE	WHEN B.MEASURE_CALC = 'MKT_FCST_ENERGY' AND B.MEASURE_ORI = 'MKT_FCST_RP' AND A.PLAN_RESULT = 'P'
					THEN CASE WHEN ISNUMERIC(C.ENERGE) > 0 THEN (A.QTY * C.ENERGE)/1000	END
					ELSE 0
			   END IF;
			 , A.PLAN_RESULT, A.CELL_PROD_SITE_ID --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		FROM GT_DMF0_RAW_DATA A
		JOIN ( SELECT 'MKT_FCST_RP' AS MEASURE_ORI, A.MEASURE AS MEASURE_CALC
		   	   FROM GT_DMF0_SELECT_MEASURE A
			   WHERE MEASURE IN ('MKT_FCST_ENERGY')
			  ) B;
		  ON A.MEASURE		= B.MEASURE_ORI
		JOIN GT_DMF0_DM_MST_ITEM_SINGLE_V C
		  ON A.ITEM_ID		= C.ITEM_ID
		 AND A.DIVISION_ID	= C.DIVISION_ID
		LEFT OUTER JOIN GT_DMF0_SCM_MST_SITE_ITEM D
					 ON A.DIVISION_ID	= D.DIVISION_ID
					AND A.SCM_SITE_ID	= D.SCM_SITE_ID
					AND A.PROJECT_CODE	= D.PROJECT_CODE
					AND A.ITEM_ID		= D.ITEM_ID
		WHERE A.MEASURE IN ( 'MKT_FCST_RP');
	END;
	--=================================================================================================================================
	-- 20221214 ROSIA27 [C20221207-000080] ESS영업관리팀 GSCM 내 Measrue값 추가 요청  MKT FCST[R+P] Energy (END)
	--=================================================================================================================================
DBMS_OUTPUT.PUT_LINE(p_program_id  || ' : A025--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	--=================================================================================================================================
	-- 컬럼리스트 생성 (START)
	--=================================================================================================================================
	-- --------------------------------------------------------------------------------------------------------------------------------
	-- 컬럼리스트 만들고, MKT FCST 와 비슷한 방식으로, CTE 로 데이터를 만들고, CTE SELECT 문에 컬럼리스트 삽입한다.
	-- --------------------------------------------------------------------------------------------------------------------------------
	BEGIN















		--날짜컬럼
		-- --------------------------------------------------------------------------------------------------------------------------------
		SELECT '',
    ''
  INTO V_PV_LIST, V_PV_COL_LIST
		FROM  SCM_SYS_CALENDAR_M A
		WHERE A.BASIS_YYYYMMDD >= p_from_yyyymmdd -- '20171101'  TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
		AND   A.BASIS_YYYYMMDD <= p_to_yyyymmdd   --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
		AND	  P_BUCKET = 'DAILY'
		UNION ALL
		SELECT '[W_'  ||  A.BASIS_YYYYMM  ||  A.ISO_WEEK  ||  '] AS W_'  ||  A.BASIS_YYYYMM  ||  A.ISO_WEEK AS COLUMN_NAME
				, '[W_'  ||  A.BASIS_YYYYMM  ||  A.ISO_WEEK  ||  ']' AS PV_NAME
				, A.BASIS_START_DATE  ||  '_'  ||  TO_CHAR(21) AS SORT_ORDER_NO
		FROM  SCM_SYS_CALENDAR_M A
		WHERE A.BASIS_YYYYMMDD >= p_from_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
		AND   A.BASIS_YYYYMMDD <= p_to_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
		GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
		UNION ALL
		SELECT '[M_'  ||  A.BASIS_YYYYMM  ||  '] AS M_'  ||  A.BASIS_YYYYMM AS COLUMN_NAME
				, '[M_'  ||  A.BASIS_YYYYMM  ||  ']' AS PV_NAME
				, MIN(A.BASIS_START_DATE)  ||  '_'  ||  TO_CHAR(1) AS SORT_ORDER_NO
		FROM   SCM_SYS_CALENDAR_M A
		WHERE  A.BASIS_YYYYMMDD >= p_from_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
		AND    A.BASIS_YYYYMMDD <= p_to_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
		GROUP BY A.BASIS_YYYYMM
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

DBMS_OUTPUT.PUT_LINE(p_program_id  || ' : A026--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

		-- --------------------------------------------------------------------------------------------------------------------------------
        /* 20240518 KCW3408 속도개선_템프사용 */
		-- --------------------------------------------------------------------------------------------------------------------------------
		BEGIN
			/* TODO:GTT:GT_DMF0_SCM_MST_SITE-->GT_DMF0_SCM_MST_SITE */
			INSERT INTO GT_DMF0_SCM_MST_SITE
			SELECT B.SCM_SITE_ID, B.DIVISION_ID, B.DEPT_ID, K.SOLDTO_CODE, B.VMI_YN
				 , B.END_CUSTOMER, H.CITY_NAME, J.COUNTRY_NAME, L.SHIPTO_DESCRIPTION, L.SOLDTO_DESCRIPTION
				 , B.ATTRIBUTE3  --20240913 SM 임시작업 존재하지 않는 경우 화면 오류 발생으로 임의로 지정함
			FROM SCM_MST_SITE B
			LEFT OUTER JOIN SCM_MST_SITE_CUSTOMER K
					     ON B.DIVISION_ID	= K.DIVISION_ID
					    AND B.SCM_SITE_ID	= K.SCM_SITE_ID
					    AND K.REP_YN		= 'Y'
			LEFT OUTER JOIN SCM_MST_CITY H
						 ON B.CITY = H.CITY
			LEFT OUTER JOIN SCM_MST_COUNTRY J
						 ON B.COUNTRY = J.COUNTRY
			LEFT OUTER JOIN SCM_MST_CUSTOMER L
						 ON K.DIVISION_ID = L.DIVISION_ID
						AND K.SHIPTO_CODE = L.SHIPTO_CODE
						AND K.SOLDTO_CODE = L.SOLDTO_CODE;
		END;

		-- --------------------------------------------------------------------------------------------------------------------------------
		-- 일반 컬럼
		-- --------------------------------------------------------------------------------------------------------------------------------
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

DBMS_OUTPUT.PUT_LINE(p_program_id  || ' : A027--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
		IF i_Count = 0 THEN
			SELECT V_ColList		= V_ColList  ||  '['  ||  COLUMN_NAME  ||  '],'
				 , V_OrderList	= V_OrderList  ||  '['  ||  COLUMN_NAME  ||  '] '  ||  DATA_SORT_METHOD_CODE  ||  ','
			FROM
			(-- ★★ ORDER BY 가능하려면 컬럼정의 100개 넘지 않아야함
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
			FROM
			( -- ★★ ORDER BY 가능하려면 컬럼정의 100개 넘지 않아야함
				SELECT --TOP 100
						U.SORT_ORDER_NO, C.COLUMN_NAME, U.DATA_SORT_METHOD_CODE
				FROM SCM_MST_TITLESET_USER U
				INNER JOIN SCM_MST_SHEET_COLUMNS C
						ON U.PROGRAM_ID		= C.PROGRAM_ID
					   AND U.SHEET_NAME		= C.SHEET_NAME
					   AND U.COLUMN_NAME	= C.COLUMN_NAME
					   AND U.PROGRAM_ID		= p_Program_Id
					   AND U.SHEET_NAME		= p_sheet_name
					   AND U.USER_ID		= p_created_by
					   AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
					 --AND    p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )	-- 20190125 일단 주석처리 KHSONG
				-- ------
				UNION ALL
				-- --------------------------------------------------------------------------------------------------------------------------------
				/* 2024/05/17 kcw3408 이동계획 판가 매출GROUP_ID( Item은 Group 기준으로 정렬) 추가) */
				-- --------------------------------------------------------------------------------------------------------------------------------
				SELECTCASE WHEN C.COLUMN_NAME = 'GROUP_ID' THEN  NVL(U.SORT_ORDER_NO,85) - 0.5
						 -- [PJ2024-50611] Catch Up 입력가능 : 수정여부 필드(순서 400)가 MEASURE(순서 500) 앞에서 정렬되어 메저 순서가 제대로 표시되지 않으므로 MEASURE 뒤로 돌림(510으로 만듬) --START
						 WHEN C.COLUMN_NAME = 'SALES_PLAN_ADJUST_YN' THEN NVL(C.SORT_ORDER_NO,400) || 110
						 -- [PJ2024-50611] Catch Up 입력가능 : 수정여부 필드(순서 400)가 MEASURE(순서 500) 앞에서 정렬되어 메저 순서가 제대로 표시되지 않으므로 MEASURE 뒤로 돌림(510으로 만듬) --END
						 ELSE C.SORT_ORDER_NO END AS SORT_ORDER_NO
					, C.COLUMN_NAME, C.DATA_SORT_METHOD_CODE
				FROM SCM_MST_SHEET_COLUMNS C
				LEFT OUTER JOIN SCM_MST_TITLESET_USER U
						     ON U.PROGRAM_ID	= C.PROGRAM_ID
							AND U.SHEET_NAME	= C.SHEET_NAME
							AND U.USER_INQUIRY_COLUMN_TYPE_CODE	= 'C'
							AND U.COLUMN_NAME IN ('ITEM_ID')
							AND U.USER_ID		= p_created_by
				WHERE  1 = 1
				AND C.PROGRAM_ID	= p_Program_Id
				AND C.SHEET_NAME	= p_sheet_name
				AND C.VISIBLE_FLAG	= ''
				AND C.DEFAULT_FLAG	IS NULL
				AND C.VALID_YN		= 'Y'
				--AND    p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )	 -- 20190125 일단 주석처리 KHSONG
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
	--=================================================================================================================================
	-- 컬럼리스트 생성 (END)
	--=================================================================================================================================/
DBMS_OUTPUT.PUT_LINE(p_program_id +' : A028--' + TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	--=================================================================================================================================
	-- SHIPMENT 컬럼 (START)
	--=================================================================================================================================
	--PJ20200138 Shipment Site 임시테이블 추가

		  , v_SHIP_PLAN_START_YYYYMMDD		VARCHAR2(8 CHAR)
		  , v_SHIP_PLAN_TYPE				VARCHAR2(50 CHAR)
		  , v_SHIP_PPLAN_SEQ				INTEGER
		  , v_SHIP_PPLAN_ID				VARCHAR2(30 CHAR)
		  , v_SHIP_PMODELING_ID			VARCHAR2(30 CHAR)

	IF V_ColList LIKE '%SHIPMENT_SITE%' AND P_DIVISION_ID = '82' THEN
		SELECT DIVISION_ID,
    PLAN_START_YYYYMMDD,
    PLAN_TYPE,
    PLAN_SEQ,
    PLAN_ID,
    MODELING_ID
  INTO v_SHIP_DIVISION_ID, v_SHIP_PLAN_START_YYYYMMDD, v_SHIP_PLAN_TYPE, v_SHIP_PPLAN_SEQ, v_SHIP_PPLAN_ID, v_SHIP_PMODELING_ID
		FROM (  SELECT *
				FROM ( SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ, PLAN_ID, MODELING_ID
							, ROW_NUMBER() OVER ( ORDER BY PLAN_START_YYYYMMDD DESC, PLAN_SEQ DESC ) ROW_NUM
					   FROM   SCP_PLAN_VERSION_V
					   WHERE  1=1
					   AND    DIVISION_ID	= '82'
					   AND    PLAN_CYCLE   = 'WEEKLY'
					   AND    PLAN_TYPE	= 'FN'
					   AND    PLAN_START_YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-60), 'YYYYMMDD')) A
			  ) PV;
		WHERE PV.ROW_NUM = 1;

		-- 2020.11.26 hwi1993	FROM_SITE 를 MAX 값으로 변경 ( 안그러면 모델의 생산지를 변경할 경우 중복오류남 )
		/* TODO:GTT:GT_DMF0_SHIPMENT_SITE_ROW-->GT_DMF0_SHIPMENT_SITE_ROW */
		INSERT INTO GT_DMF0_SHIPMENT_SITE_ROW
		SELECT A.DIVISION_ID, A.PROJECT_CODE, A.ITEM_ID, A.TO_SITE AS SCM_SITE_ID, A.INCOTERMS, FC.FCST_TYPE, A.FROM_SITE
		--[C20201202-000394]ESS Shipment Site(생산지) 중복 콤마(,) 처리
		FROM SCP_ANL_SHIPMENT_PLAN_FG A
		INNER JOIN SCM_SYS_CALENDAR_M O
				ON A.YYYYMMDD = O.basis_yyyymmdd
		LEFT OUTER JOIN ( SELECT DIVISION_ID, PLAN_START_YYYYMMDD, ITEM_ID, FROM_SITE, TO_SITE
							   , MAX(REPLACE(SUBSTR(ENG_DEMAND_ID, INSTR(ENG_DEMAND_ID, CHARINDEX('::', ENG_DEMAND_ID, CHARINDEX('::', ENG_DEMAND_ID, CHARINDEX('::', ENG_DEMAND_ID, '::') || 1) || 1) || 1) || 2, 3), ':', '')) AS FCST_TYPE
						  FROM   SCP_ANL_PROBLEM_REPORT_PEGGING
						  WHERE  DIVISION_ID			= v_SHIP_DIVISION_ID
						  AND    PLAN_START_YYYYMMDD	= v_SHIP_PLAN_START_YYYYMMDD
						  AND    PLAN_TYPE				= v_SHIP_PLAN_TYPE
						  AND    SEQ					= v_SHIP_PPLAN_SEQ
						  AND    PEGGING_OPERATION_CODE IN ( 'CSHIP', 'PSHIP' )
						  GROUP BY DIVISION_ID, PLAN_START_YYYYMMDD, ITEM_ID, FROM_SITE, TO_SITE ) FC
					 ON  A.ITEM_ID		= FC.ITEM_ID
					 AND A.FROM_SITE	= FC.FROM_SITE
					 AND A.TO_SITE		= FC.TO_SITE
		WHERE A.DIVISION_ID			= v_SHIP_DIVISION_ID
		AND   A.PLAN_START_YYYYMMDD	= v_SHIP_PLAN_START_YYYYMMDD
		AND   A.PLAN_TYPE			= v_SHIP_PLAN_TYPE
		AND   A.SEQ					= v_SHIP_PPLAN_SEQ
		AND   A.MEASURE				= 'SHIP_PLAN'
		AND   A.QTY					> 0
		GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.ITEM_ID, A.TO_SITE, A.INCOTERMS, FC.FCST_TYPE, A.FROM_SITE;

		--[C20201202-000394]ESS Shipment Site(생산지) 중복 중복 콤마(,) 처리
		INSERT INTO GT_DMF0_SHIPMENT_SITE
		( DIVISION_ID, PROJECT_CODE, ITEM_ID, SCM_SITE_ID, INCOTERMS, FCST_TYPE, SHIPMENT_SITE )
		SELECT DIVISION_ID, PROJECT_CODE, ITEM_ID, SCM_SITE_ID, INCOTERMS, FCST_TYPE
			 , NVL(1, NULL)
				 ||  CASE WHEN 2 IS NULL THEN '' ELSE ','  ||  2 END
				 ||  CASE WHEN 3 IS NULL THEN '' ELSE ','  ||  3 END
				 ||  CASE WHEN 4 IS NULL THEN '' ELSE ','  ||  4 END
				 ||  CASE WHEN 5 IS NULL THEN '' ELSE ','  ||  5 END AS SHIPMENT_SITE
		FROM (  SELECT A.DIVISION_ID, A.PROJECT_CODE, A.ITEM_ID, A.SCM_SITE_ID, A.INCOTERMS
					 , A.FCST_TYPE, A.FROM_SITE
					 , ROW_NUMBER() OVER ( PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.ITEM_ID, A.SCM_SITE_ID, A.INCOTERMS, A.FCST_TYPE ORDER BY A.FROM_SITE) AS ROW_NUM
				FROM GT_DMF0_SHIPMENT_SITE_ROW A	) A;
		PIVOT (	MAX(FROM_SITE) FOR ROW_NUM IN ( 1, 2, 3, 4, 5 )) AS PVT
	END IF;
DBMS_OUTPUT.PUT_LINE(p_program_id  || ' : A030--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
	--=================================================================================================================================
	-- SHIPMENT 컬럼 (END)
	--=================================================================================================================================
	-- --------------------------------------------------------------------------------------------------------------------------------
	/* 2024/05/17 kcw3408 이동계획 판가 매출GROUP_ID( Item은 Group 기준으로 정렬) 추가)
	UI Category Setup 에 등록(GROUP_ID) ORDER BY 필요, GROUP_ID 추가함 */
	-- --------------------------------------------------------------------------------------------------------------------------------
	BEGIN	-- CTE 에서 사용할 SELECT COLUMN 정리


					DROP TABLE GT_DMF0_COLUMN_SETUP;

		EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_COLUMN_SETUP';

 		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'A', 'VERSION_NO', 'A.VERSION_NO', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'A', 'DIVISION_ID', 'A.DIVISION_ID', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'A', 'PROJECT_CODE', 'A.PROJECT_CODE', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'A', 'SCM_SITE_ID', 'A.SCM_SITE_ID', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'A', 'PLANT_SITE_ID', 'A.PLANT_SITE_ID', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'A', 'GROUP_ID', 'NVL(I.GROUP_ID,'' '') AS GROUP_ID', 1);

		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'A', 'ITEM_ID', 'A.ITEM_ID', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'A', 'TEXT','CASE WHEN LENGTH(A.TEXT) = 0   THEN '' '' ELSE A.TEXT END  AS TEXT' , 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'A', 'TEXT4082','CASE WHEN LENGTH(A.TEXT) = 0   THEN '' '' ELSE A.TEXT END  AS TEXT4082' , 1); --[PJ2024-50611]40, 82용 text 컬럼 추가
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'A', 'INCOTERMS', 'A.INCOTERMS', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'A', 'DOM_EXP', 'A.DOM_EXP', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'A', 'FCST_TYPE', 'A.FCST_TYPE', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'A', 'MEASURE', 'A.MEASURE', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'A', 'END_CUSTOMER40', 'A.PROJECT_CODE AS END_CUSTOMER40', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'A', 'INTERNAL_YN', 'CASE WHEN LENGTH(A.SCM_SITE_ID) > 2 AND LENGTH(A.SCM_SITE_ID) < 6  THEN ''Y'' ELSE '''' END AS INTERNAL_YN', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'A', 'YYYYMMDD', 'A.YYYYMMDD', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'A', 'QTY', 'A.QTY', 1);
		--INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'A', 'QTY', 'TO_CHAR(A.QTY,''#,#GT_DMF0_0.##########'')', 1)

		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'A', 'VERSION_SORT', 'CASE WHEN A.VERSION_NO = ''CURRENT'' THEN ''ZZZZZZZZZZZZZZZ'' ELSE A.VERSION_NO END AS VERSION_SORT', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'B', 'VMI_YN', 'B.VMI_YN', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'B', 'END_CUSTOMER', 'NVL(B.END_CUSTOMER,'' '') AS END_CUSTOMER', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'AC', 'CURRENCY', 'CASE WHEN A.CURRENCY <> '''' THEN A.CURRENCY ELSE C.CURRENCY END AS CURRENCY', 1);

		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'A', 'CELL_PROD_SITE_ID', 'A.CELL_PROD_SITE_ID', 1); --[PJ2025-50017] CELL_PROD_SITE_ID 추가
		-- --------------------------------------------------------------------------------------------------------------------------------
		--[PJ2024-50461] 기타매출은 모델이 없으므로 부서코드를 기존의 Site 의 팀으로 조회 (START)
		-- --------------------------------------------------------------------------------------------------------------------------------
		--INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'ABC', 'DEPT_ID', 'CASE WHEN A.DIVISION_ID = ''40'' THEN C.DEPT_ID ELSE B.DEPT_ID END AS DEPT_ID', 1)
		--INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'ABC', 'DEPT_ID', 'C.DEPT_ID', 1)
		--INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'ABC', 'DEPT_ID', 'CASE WHEN A.FCST_TYPE = ''ETC'' THEN B.DEPT_ID ELSE C.DEPT_ID END AS DEPT_ID', 1)----[PJ2024-50461]
		-- --------------------------------------------------------------------------------------------------------------------------------
		--[PJ2024-50461] 기타매출은 모델이 없으므로 부서코드를 기존의 Site 의 팀으로 조회 (END)
		-- --------------------------------------------------------------------------------------------------------------------------------
		-- --------------------------------------------------------------------------------------------------------------------------------
		--[PJ2024-50611] 소형사업부는 Site에서 부서관리 안하므로 화면에서 입력한 부서코드를 사용함(attribute1)) (START)
		-- --------------------------------------------------------------------------------------------------------------------------------
		--기존 case에서 한번 더 분기
		/*	1.40사업부
				- FCST_TYPE = ETC
				=> ATTRIBUTE1
				- ELSE
				=>SCM_MST_SITE_ITEM : 기존 그대로

			2.그 외 사업부
				- FCST_TYPE = 'ETC'
				=> SCM_MST_SITE : 기존 그대로
				- ELSE
				=>SCM_MST_SITE_ITEM : 기존 그대로	*/
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'ABC', 'DEPT_ID', 'CASE WHEN A.FCST_TYPE = ''ETC'' THEN CASE WHEN A.DIVISION_ID = ''40'' THEN A.ATTRIBUTE1 ELSE B.DEPT_ID END ELSE C.DEPT_ID END AS DEPT_ID', 1);
		-- --------------------------------------------------------------------------------------------------------------------------------
		--[PJ2024-50611] 소형사업부는 Site에서 부서관리 안하므로 화면에서 입력한 부서코드를 사용함(attribute1)) (END)
		-- --------------------------------------------------------------------------------------------------------------------------------
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
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'C', 'CELL_MODEL', 'C.ATTRIBUTE5 AS CELL_MODEL', 1); --[C20211112-000213]GSCM의 Cell Model 컬럼 관련 요청의 건
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'C', 'PRIORITY', 'C.ATTRIBUTE7 AS PRIORITY', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'C', 'KWH_CELL', 'C.ATTRIBUTE8 AS KWH_CELL', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'C', 'CELL_MODEL_INFO', 'NVL(C.REPORT_GROUP6,'''') AS CELL_MODEL_INFO', 1); --[C20211112-000213]GSCM의 Cell Model 컬럼 관련 요청의 건
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'AC', 'KWH_MODULE', 'CASE WHEN A.DIVISION_ID LIKE ''81%'' AND C.CELL_PER_MODULE > 0 AND NVL(C.ATTRIBUTE8, '''') <> '''' THEN TO_NUMBER((C.CELL_PER_MODULE * C.ATTRIBUTE8)) ELSE NULL END AS KWH_MODULE', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'AC', 'KWH_PACK', 'CASE WHEN A.DIVISION_ID LIKE ''81%'' AND C.CELL_PER_CAR > 0 AND NVL(C.ATTRIBUTE8, '''') <> '''' THEN TO_NUMBER((C.CELL_PER_CAR * C.ATTRIBUTE8)) ELSE NULL END AS KWH_PACK', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'D', 'FORECAST_INFO_CELL_PACK_COUNT', 'D.FORECAST_INFO_CELL_PACK_COUNT', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'D', 'BIZ_TYPE_NAME40', 'D.FORECAST_INFO_BIZ_TYPE AS BIZ_TYPE_NAME40', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'D', 'FORECAST_INFO_PRODUCT_GROUP', 'D.FORECAST_INFO_PRODUCT_GROUP', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'D', 'ENERGE', 'D.ENERGE', 1);

		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'D', 'ENERGE_WH', 'D.ENERGE_WH', 1); --[E20240731-000852]_40 사업부 용 ENERGE 컬럼 추가
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
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'E', 'CELL_TYPE', 'E.SEGMENT2 AS CELL_TYPE', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'F', 'CELL_MODEL_NICK_NAME', 'NVL(F.NICK_NAME,'''') AS CELL_MODEL_NICK_NAME', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'G', 'BIZ_TYPE_NAME', 'G.BIZ_TYPE AS BIZ_TYPE_NAME', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'G', 'PROJECT_NAME', 'G.PROJECT_NAME', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'G', 'PROJECT_OWNER', 'G.PROJECT_OWNER', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'G', 'PROJECT_STATUS', 'G.PROJECT_STATUS', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'G', 'PRODUCT_GROUP_NAME', 'G.PRODUCT_GROUP_NAME', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'B', 'CITY_NAME', 'B.CITY_NAME', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'B', 'COUNTRY_NAME', 'B.COUNTRY_NAME', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'B', 'SHIPTO_DESCRIPTION', 'B.SHIPTO_DESCRIPTION', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'M', 'SORT_ORDER_NO', 'M.SORT_ORDER_NO', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'C', 'CELL_NAME', 'C.ATTRIBUTE9 AS CELL_NAME', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'C', 'DISTRIBUTION_CHANNEL', 'B.ATTRIBUTE3 AS DISTRIBUTION_CHANNEL', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'C', 'SALES_COMPANY', 'C.SALES_COMPANY', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'C', 'SALES_PLANT', 'C.SALES_PLANT', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( '', 'SHIPMENT_SITE', 'N.SHIPMENT_SITE', 1);
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'O', 'SEGMENT3', 'NVL(O.SEGMENT3, ''DEFAULT'') AS NOTATION', 1); --[E20231128-000738]해당컬럼으로 숫자표기형태를 구분하려고 하니, 해당 컬럼을 추출할수있도록 추가
		-- --------------------------------------------------------------------------------------------------------------------------------
		--[E20250423-000842]_[공급생산 SCM PI팀] Sales Plan 화면 'SCP Use' 칼럼 추가 (START)
		-- --------------------------------------------------------------------------------------------------------------------------------
		INSERT INTO GT_DMF0_COLUMN_SETUP VALUES ( 'A','SCP_USE_YN', 'CASE  WHEN A.DIVISION_ID IN (''40'') AND B.VMI_YN = ''Y'' AND A.MEASURE IN ( ''VMI_In_Req'', ''VMI_In_Plan'')  THEN ''Y'';
																		WHEN A.DIVISION_ID IN (''40'') AND B.VMI_YN = '''' AND A.MEASURE IN ( ''RTF_PR'',''MKT_FCST_RP'',''MKT_FCST'', ''RTF'',''RTF_SCP'',''RTF_SYS_RP'' ) THEN ''Y''
																    ELSE '''' END AS SCP_USE_YN', 1)
		-- --------------------------------------------------------------------------------------------------------------------------------
		--[E20250423-000842]_[공급생산 SCM PI팀] Sales Plan 화면 'SCP Use' 칼럼 추가 (END)
		-- --------------------------------------------------------------------------------------------------------------------------------
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
														  ELSE COLUMN_STRING END
			FROM GT_DMF0_
			WHERE SEQ = V_I

			SET V_I  || = 1
		END LOOP;
	END;
	----- [E20230619-000151] ss
	IF p_division_id = '82' THEN
		v_qty_div := 'TO_NUMBER(TO_CHAR(A.QTY,''#GT_DMF0_0.##########''))';
		--v_qty_div := 'A.QTY';
		v_sum_qty := 'SUM(QTY)';
		v_avg_qty := 'AVG(QTY)';
	ELSE
		v_qty_div := 'A.QTY';
		v_sum_qty := 'SUM(QTY)';
		v_avg_qty := 'AVG(QTY)';
	END IF;
	---- [E20230619-000151] ee
	-- --------------------------------------------------------------------------------------------------------------------------------
	--[E20231128-000738]숫자표기형태를 구분하려고 하니, 해당 컬럼을 추출할수있도록 룩업테이블 추가
	-- --------------------------------------------------------------------------------------------------------------------------------
	v_sql_text := ';
	/* TODO:GTT:GT_DMF0_WF-->GT_DMF0_WF */
	INSERT INTO GT_DMF0_WF
	SELECT
		'  ||  v_qty_div  ||    ' AS QTY
		, CASE WHEN '''  ||  P_BUCKET  ||  ''' = ''DAILY'' THEN A.YYYYMMDD ELSE '''' END AS YYYYMMDD
		, M.SORT_ORDER_NO
		, CASE WHEN D.ITEM_ID IS NULL THEN ''N_''
				--[PJ2024-50611]소형사업부는 원래대로 ETC만 수정 가능하게 처리 : 잘못 추가된 로직 제거 start
				--WHEN A.DIVISION_ID = ''40'' THEN ''N_''  --[PJ2024-50611] 소형사업부는 무조건 수정가능하게 N처리함
				--[PJ2024-50611]소형사업부는 원래대로 ETC만 수정 가능하게 처리 : 잘못 추가된 로직 제거 end
				WHEN A.DIVISION_ID = ''40'' AND A.MEASURE = ''Catch_Up'' THEN ''N_''  --소형사업부는 Catch Up도 수정 가능하게 처리
				WHEN A.DIVISION_ID = ''40'' AND A.MEASURE = ''RTF_SYS_RP'' THEN ''N_''  --소형사업부는 RTF_SYS_RP도 수정 가능하게 처리
				WHEN NVL(C.SALES_PLAN_ADJUST_YN,'''')='''' THEN ''N_''
				ELSE  ''Y_''
				END;
		--[PJ2024-50461] 기타매출은 모델이 없으므로 부서코드를 기존의 Site 의 팀으로 조회 --start
		--+  CASE	WHEN '''  ||  v_dept_list  ||  ''' LIKE ''%''+ B.DEPT_ID +''%'' THEN ''Y''
		--+  CASE	WHEN '''  ||  v_dept_list  ||  ''' LIKE ''%''+ CASE WHEN A.FCST_TYPE = ''ETC'' THEN B.DEPT_ID ELSE C.DEPT_ID END +''%'' THEN ''Y''
		--[PJ2024-50461] 기타매출은 모델이 없으므로 부서코드를 기존의 Site 의 팀으로 조회 --end
		--[PJ2024-50611] 소형사업부는 Site에서 부서관리 안하므로 화면에서 입력한 부서코드를 사용함(attribute1)) start
		+  CASE	WHEN '''  ||  v_dept_list  ||  ''' LIKE ''%''+ CASE WHEN A.FCST_TYPE = ''ETC'' THEN CASE WHEN A.DIVISION_ID = ''40'' THEN A.ATTRIBUTE1 ELSE B.DEPT_ID END ELSE C.DEPT_ID END +''%'' THEN ''Y''
		--[PJ2024-50611] 소형사업부는 Site에서 부서관리 안하므로 화면에서 입력한 부서코드를 사용함(attribute1)) end
				WHEN '''  ||  v_group_id  ||  ''' =''ADMIN'' THEN ''Y''
			ELSE ''''
			END as SALES_PLAN_ADJUST_YN
		, CAL.BASIS_YYYYMM, CAL.ISO_WEEK
		, NVL(O.SEGMENT3, ''DEFAULT'') AS NOTATION
		, V_SQL_SELECT
	FROM GT_DMF0_RAW_DATA A
    LEFT OUTER JOIN GT_DMF0_SCM_MST_SITE B   ON A.SCM_SITE_ID = B.SCM_SITE_ID AND A.DIVISION_ID = B.DIVISION_ID
	LEFT OUTER JOIN GT_DMF0_SCM_MST_SITE_ITEM		C (NOLOCK) ON  A.DIVISION_ID = C.DIVISION_ID	AND A.PROJECT_CODE = C.PROJECT_CODE AND A.SCM_SITE_ID = C.SCM_SITE_ID AND A.ITEM_ID = C.ITEM_ID
	LEFT OUTER JOIN GT_DMF0_DM_MST_ITEM_SINGLE_V	D (NOLOCK) ON A.DIVISION_ID = D.DIVISION_ID AND A.ITEM_ID = D.ITEM_ID
	LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL E (NOLOCK) ON D.CELL_TYPE = E.SEGMENT1 AND E.LOOKUP_TYPE = ''CELL_TYPE''
	LEFT OUTER JOIN GT_DMF0_DM_MST_ITEM_SINGLE_V	F (NOLOCK) ON D.DIVISION_ID = F.DIVISION_ID AND NVL(D.FORECAST_INFO_CELL_MODEL,'''') = F.ITEM_ID
	LEFT OUTER JOIN SCM_MST_PROJECT				G (NOLOCK) ON A.DIVISION_ID = G.DIVISION_ID AND A.PROJECT_CODE = G.PROJECT_CODE
	LEFT OUTER JOIN SCP_MST_ITEM_GROUP_DETAIL	I (NOLOCK) ON A.DIVISION_ID = I.DIVISION_ID	AND A.PROJECT_CODE = I.PROJECT_CODE AND A.ITEM_ID = I.ITEM_ID
	JOIN GT_DMF0_SELECT_MEASURE						M ON A.MEASURE = M.MEASURE
	LEFT OUTER JOIN GT_DMF0_SHIPMENT_SITE			N ON A.DIVISION_ID = N.DIVISION_ID AND A.PROJECT_CODE = N.PROJECT_CODE AND A.SCM_SITE_ID = N.SCM_SITE_ID
														AND A.ITEM_ID = N.ITEM_ID AND A.FCST_TYPE = N.FCST_TYPE AND A.INCOTERMS = N.INCOTERMS
	LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL O (NOLOCK) ON O.LOOKUP_TYPE = ''DM_MEASURE_POSITIONAL_NOTATION'' AND A.MEASURE = O.SEGMENT2 AND A.DIVISION_ID = O.SEGMENT1
	JOIN SCM_SYS_CALENDAR_M						CAL ON A.YYYYMMDD = CAL.BASIS_YYYYMMDD AND CAL.BASIS_DATE BETWEEN TO_DATE('''  ||  p_from_yyyymmdd  ||  ''') AND TO_DATE('''  ||  p_TO_yyyymmdd  ||  ''') + (1)


			SELECT V_COLUMN
					, SORT_ORDER_NO
					, V_PV_COL_LIST
			FROM ( ';

	IF P_BUCKET = 'DAILY' THEN
		v_sql_text := v_sql_text  ||  '
							SELECT V_COLUMN, F.SORT_ORDER_NO, ''D_'' + F.YYYYMMDD AS YYYYMMDD, F.QTY
							FROM GT_DMF0_WF F
							--WHERE QTY <> 0
							WHERE 1=1
							--[PJ2025-50017] Sales Plan 화면에서 RTF[R+P]가 0인 대상도 조회 가능하도록 로직 수정 START
							AND (
									(F.MEASURE <> ''RTF_SYS_RP'' AND F.QTY <> 0)
									OR
									(F.MEASURE = ''RTF_SYS_RP'')
								)
							--[PJ2025-50017] Sales Plan 화면에서 RTF[R+P]가 0인 대상도 조회 가능하도록 로직 수정 END
							UNION ALL '
	END IF;
	-- 1274,1280 라인의 AVG,SUM의 QTY 부분 포맷수정 -- 20230621  이전소스 1274: THEN AVG(QTY)  ELSE SUM(QTY) END as QTY / 1280:THEN AVG(QTY)  ELSE SUM(QTY)
	v_sql_text := v_sql_text  ||  '
				SELECT V_COLUMN, F.SORT_ORDER_NO, ''W_'' + F.BASIS_YYYYMM || F.ISO_WEEK AS YYYYMMDD, CASE WHEN MEASURE IN ( ''KRW'', ''USD'', ''LOC'') THEN ' || v_avg_qty || '  ELSE ' || v_sum_qty || ' END as QTY --PJ20209642R Sales Price 는 Sum 대신 Avg로 계산
				FROM GT_DMF0_WF F
				--WHERE QTY <> 0
				WHERE 1=1
				--[PJ2025-50017] Sales Plan 화면에서 RTF[R+P]가 0인 대상도 조회 가능하도록 로직 수정 START
				AND (
						(F.MEASURE <> ''RTF_SYS_RP'' AND F.QTY <> 0)
						OR
						(F.MEASURE = ''RTF_SYS_RP'')
					)
				--[PJ2025-50017] Sales Plan 화면에서 RTF[R+P]가 0인 대상도 조회 가능하도록 로직 수정 END
				GROUP BY V_COLUMN, F.SORT_ORDER_NO, F.BASIS_YYYYMM, F.ISO_WEEK

				UNION ALL
				SELECT V_COLUMN, F.SORT_ORDER_NO, ''M_'' + F.BASIS_YYYYMM AS YYYYMMDD, CASE WHEN MEASURE IN ( ''KRW'', ''USD'', ''LOC'') THEN ' || v_avg_qty || '  ELSE ' || v_sum_qty || ' END --PJ20209642R Sales Price 는 Sum 대신 Avg로 계산

				FROM GT_DMF0_WF F
				--JOIN SCM_SYS_CALENDAR_M B ON F.YYYYMMDD = B.BASIS_YYYYMMDD
				--WHERE QTY <> 0
				WHERE 1=1
				--[PJ2025-50017] Sales Plan 화면에서 RTF[R+P]가 0인 대상도 조회 가능하도록 로직 수정 START
				AND (
						(F.MEASURE <> ''RTF_SYS_RP'' AND F.QTY <> 0)
						OR
						(F.MEASURE = ''RTF_SYS_RP'')
					)
				--[PJ2025-50017] Sales Plan 화면에서 RTF[R+P]가 0인 대상도 조회 가능하도록 로직 수정 END
				GROUP BY V_COLUMN, F.SORT_ORDER_NO, F.BASIS_YYYYMM

				) F;
			PIVOT (
				SUM(QTY) FOR YYYYMMDD IN ( V_PV_LIST )
				) AS PVT
			ORDER BY v_orderby;
				';

DBMS_OUTPUT.PUT_LINE(p_program_id  || ' : A033--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

	--SELECT v_sql_text;
	v_sql_text := REPLACE(v_sql_text,'v_PV_COL_LIST'    , v_PV_LIST    );
	v_sql_text := REPLACE(v_sql_text,'v_PV_LIST'		, v_PV_LIST    );
	v_sql_text := REPLACE(v_sql_text,'v_column'			, V_ColList       );
	v_sql_text := REPLACE(v_sql_text,'v_orderby'		, V_OrderList      );
	v_sql_text := REPLACE(v_sql_text,'V_SQL_SELECT'		, V_SQL_SELECT      );
	v_sql_text := REPLACE(v_sql_text,'V_SQL_GROUPBY'		, V_SQL_GROUPBY      );

  --PRINT v_PV_LIST
  --select V_ColList, V_SQL_SELECT
  --select v_sql_text

	-- 개발중에는 텍스트만 확인하고 실행은 안한다.
	/*
	SELECT CAST(v_sql_text AS TEXT)
	FOR XML PATH('')--,ROOT('x')
	*/
	--SELECT 'v_sql_text 길이',LENGTH(v_sql_text)

	SP_EXECUTESQL v_sql_text;

	--PRINT SUBSTR(v_sql_text, 1, 2000) + SUBSTR(v_sql_text, 1999, 4000)

	/* --기존 쿼리
	SELECT 'M_' + A.BASIS_YYYYMM AS THIS_YYYYMM, 'W_' + A.BASIS_YYYYMM || A.ISO_WEEK AS THIS_YYYYMMWW, A.BASIS_DATE
		, 'M_' + B.BASIS_YYYYMM AS PRE_YYYYMM, 'W_' + B.BASIS_YYYYMM || B.ISO_WEEK AS PRE_YYYYMMWW
		, A.BASIS_YYYYMM, A.ISO_WEEK
	FROM (
		SELECT BASIS_YYYYMM, ISO_WEEK, BASIS_DATE
		FROM SCM_SYS_CALENDAR_M
		WHERE BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD')
		) A;
	JOIN (
		SELECT BASIS_YYYYMM, ISO_WEEK, BASIS_DATE
		FROM SCM_SYS_CALENDAR_M
		WHERE BASIS_YYYYMMDD = TO_CHAR(SYSDATE || (-7), 'YYYYMMDD')
		) B ON 1=1 */
	-- --------------------------------------------------------------------------------------------------------------------------------
	--[PJ2025-50017] 예를들어서 BASIS_YYYYMMDD 가 20250331,20250401 2개는 같은 주차지만 A랑 B로 나눠져있다. 4월 첫주 일 때 0331도 수정 가능하게 변경
	-- --------------------------------------------------------------------------------------------------------------------------------
	SELECT 'M_'  ||  A.BASIS_YYYYMM AS THIS_YYYYMM, 'W_'  ||  A.BASIS_YYYYMM  ||  A.ISO_WEEK AS THIS_YYYYMMWW, A.BASIS_DATE
		, 'M_'  ||  B.BASIS_YYYYMM AS PRE_YYYYMM, 'W_'  ||  B.BASIS_YYYYMM  ||  B.ISO_WEEK AS PRE_YYYYMMWW
		, A.BASIS_YYYYMM, A.ISO_WEEK
	FROM (	-----------------------------------------------------------------------------------------------------------------------------------
			--[E20250520-000605]_주차 기준으로 데이터를 조회하는 경우 주차는 MIN이 맞으나, 월기준은 MAX로 조회해야함. 원소스 주석처리
			-- --------------------------------------------------------------------------------------------------------------------------------
			--SELECT MIN(BASIS_YYYYMM) AS BASIS_YYYYMM, MIN(ISO_WEEK) AS ISO_WEEK, MIN(BASIS_DATE) AS BASIS_DATE
			SELECT MAX(BASIS_YYYYMM) AS BASIS_YYYYMM, MIN(ISO_WEEK) AS ISO_WEEK, MIN(BASIS_DATE) AS BASIS_DATE
			FROM SCM_SYS_CALENDAR_M
			--[E20251120-001430]_파셔주차인 경우, 걸쳐있는 데이터일때 달이 더 큰걸 가지고와 데이터 혼동 발생 데이터 구하는 조건 START
			WHERE BASIS_YYYYMM = (	SELECT BASIS_YYYYMM
									FROM SCM_SYS_CALENDAR_M
									WHERE BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD')
								)
			--[E20251120-001430]_파셔주차인 경우, 걸쳐있는 데이터일때 달이 더 큰걸 가지고와 데이터 혼동 발생 데이터 구하는 조건 END
			AND ISO_YYYYWW = (
								SELECT ISO_YYYYWW
								FROM SCM_SYS_CALENDAR_M
								WHERE BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD')
								)
		) A;
	JOIN (
		SELECT BASIS_YYYYMM, ISO_WEEK, BASIS_DATE
		FROM SCM_SYS_CALENDAR_M
		WHERE BASIS_YYYYMMDD = TO_CHAR(SYSDATE  ||  (-7), 'YYYYMMDD')
		) B ON 1=1

	-- --------------------------------------------------------------------------------------------------------------------------------
	-- [PJ2025-50017] 그룹 + 화면 + 사업부 + MEASURE 별로 권한추가 (신규 Lookup - GET_ADMIN_GROUP_MEASURE) 추가
	-- --------------------------------------------------------------------------------------------------------------------------------
									--SalesAmt_LOC								  --RTF_SYS_RP
	SELECT v_EDIT_AUTH_SalesAmt_LOC AS EDIT_AUTH_SalesAmt_LOC , v_EDIT_AUTH_RTF_SYS_RP AS EDIT_AUTH_RTF_SYS_RP

	-- xml확인할경우
	--SELECT CAST(v_sql_text AS TEXT)
	--FOR XML PATH('')--,ROOT('x')

	--=================================================================================================================================
	-- Temp Table 존재 여부 체크 (START)
	--=================================================================================================================================
	-- --------------------------------------------------------------------------------------------------------------------------------
	--[E20240920-000300]_SCM.DM 화면 조회 속도 개선 START
	-- --------------------------------------------------------------------------------------------------------------------------------
			DROP TABLE GT_DMF0_COLUMN_SETUP;



	-- --------------------------------------------------------------------------------------------------------------------------------
	--[E20240920-000300]_SCM.DM 화면 조회 속도 개선 END
	-- --------------------------------------------------------------------------------------------------------------------------------
	--=================================================================================================================================
	-- Temp Table 존재 여부 체크 (END)
	--=================================================================================================================================

DBMS_OUTPUT.PUT_LINE(p_program_id  || ' : A034--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));

END;
/

CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0021_GET_SALES_PLAN_MEASUREINFO
(
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0021_GET_SALES_PLAN_MEASUREINFO     
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/04/15	JYE         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2024.11.15	KJJ			[PJ2024-50611] 소형사업부 Sales Plan 기타매출 입력 추가
							룩업에 등록된 메저 가져옴(DM_SALES_PLAN_MEASURE)
 * 2026.03.17  jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
 EXEC DMF0021_GET_SALES_PLAN_MEASUREINFO
 */
AS

    V_PROC_INPUT     VARCHAR2(4000 CHAR);
    V_BACKTRACE      VARCHAR2(4000 CHAR);
    V_SQL_CODE       VARCHAR2(100 CHAR);
    V_SQL_ERRMSG     VARCHAR2(1000 CHAR);
    V_LOG_TYPE       VARCHAR2(100 CHAR);
    V_LOG_MESSAGE    VARCHAR2(4000 CHAR);
    V_DESCRIPTION    VARCHAR2(4000 CHAR);
    N_LOG_COUNT      PLS_INTEGER := 0;
    D_EVENT_DATE     DATE        := SYSDATE;

BEGIN

    OPEN O_RC1 FOR
    SELECT SEGMENT1    AS CODE
         , SEGMENT2    AS NAME
         , DISPLAY_SEQ
    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL
    WHERE  LOOKUP_TYPE = 'DM_SALES_PLAN_MEASURE'
    AND    VALID_YN    = 'Y'
    ORDER BY DISPLAY_SEQ;
    --[PJ2024-50611]기존 쿼리 주석처리
    /*
    SELECT  COLUMN_NAME AS CODE, COLUMN_LABEL_NAME AS NAME, SORT_ORDER_NO AS DISPLAY_SEQ
    FROM     SCM_MST_SHEET_MEASURE
    WHERE  
    PROGRAM_ID = 'DMF1007' AND SHEET_NAME = 'Sales Plan'
    */

    --=============================================================================================================================
    -- 결과코드 0 성공, -1 오류. 조회에서는 건수 없음. NULL로 회신
    --=============================================================================================================================
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        D_EVENT_DATE  := SYSDATE;
        V_DESCRIPTION := '';
        V_PROC_INPUT  := JSON_OBJECT('NO_PARAM' VALUE 'N/A');
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END DMF0021_GET_SALES_PLAN_MEASUREINFO;
/

CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0021_GET_SALES_PLAN_MEASUREINFO2
(
    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn

    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0021_GET_SALES_PLAN_MEASUREINFO2
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/04/15  JYE         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026.03.17  jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
 */
AS

    V_PROC_INPUT     VARCHAR2(4000 CHAR);
    V_BACKTRACE      VARCHAR2(4000 CHAR);
    V_SQL_CODE       VARCHAR2(100 CHAR);
    V_SQL_ERRMSG     VARCHAR2(1000 CHAR);
    V_LOG_TYPE       VARCHAR2(100 CHAR);
    V_LOG_MESSAGE    VARCHAR2(4000 CHAR);
    V_DESCRIPTION    VARCHAR2(4000 CHAR);
    N_LOG_COUNT      PLS_INTEGER := 0;
    D_EVENT_DATE     DATE        := SYSDATE;

BEGIN

    OPEN O_RC1 FOR
    SELECT COLUMN_NAME      AS CODE
         , COLUMN_LABEL_NAME AS NAME
         , SORT_ORDER_NO    AS DISPLAY_SEQ
         , NVL(T2.EDIT_YN,'') AS EDIT_YN
    FROM   SCM_MST_SHEET_MEASURE T1
        INNER JOIN (SELECT * -- EDIT_YN 
                     FROM SCM_ADM_USER_MNU_EDIT_AUTH_V 
                     WHERE USER_ID = P_USER_ID 
                     AND MNU_ID = P_MNU_ID 
                     AND UNIT_TP_CD = 'D') T2
         ON T2.UNIT_ID in (
             SELECT TRIM(REGEXP_SUBSTR(T1.DIVISION_ID, '[^,]+', 1, LEVEL))
             FROM   DUAL
             CONNECT BY REGEXP_SUBSTR(T1.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
         )
    WHERE  PROGRAM_ID  = 'DMF1007'
    AND    SHEET_NAME  = 'Sales Plan'
    AND    COLUMN_NAME LIKE 'SalesAmt%'
    ORDER BY SORT_ORDER_NO;

    --=============================================================================================================================
    -- 결과코드 0 성공, -1 오류. 조회에서는 건수 없음. NULL로 회신
    --=============================================================================================================================
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        D_EVENT_DATE  := SYSDATE;
        V_DESCRIPTION := '';
        V_PROC_INPUT  := JSON_OBJECT(
            'P_USER_ID'   VALUE P_USER_ID,
            'P_MNU_ID'   VALUE P_MNU_ID
        );
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END DMF0021_GET_SALES_PLAN_MEASUREINFO2;
/

CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0021_GET_SPREAD_TITLE
(
    P_START_YYYYMMDD  IN VARCHAR2,
    P_END_YYYYMMDD    IN VARCHAR2,
    P_CREATED_BY      IN VARCHAR2,
    P_DIVISION_ID     IN VARCHAR2,   -- 20180604 division 추가
    P_BUCKET          IN VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/****************************************************************************************************/
/* Program ID  : DM0021_GET_SPREAD_TITLE                                                             */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/03/12  SeungJae.Hwnag       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 2018/06/04     JYE				Div별로 연동                                                            */
/* 2018/10/26     JYE				스프레드 해더 칼럼 통합(일반 데이터 + 날짜데이터)                       */
/* 2021/10/12	rosia27				Sales Plan 속도 개선											        */
/* 2024.03.29   kcw3408             USER_INQUIRY_COLUMN_TYPE_CODE = 'C' 추가					            */
/* 2026.03.17  jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발                                   */
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
AS

    v_user_col_cnt   PLS_INTEGER := 0;
    v_program_id     VARCHAR2(4000 CHAR);
    v_sheet_name     VARCHAR2(4000 CHAR);

    V_PROC_INPUT     VARCHAR2(4000 CHAR);
    V_BACKTRACE      VARCHAR2(4000 CHAR);
    V_SQL_CODE       VARCHAR2(100 CHAR);
    V_SQL_ERRMSG     VARCHAR2(1000 CHAR);
    V_LOG_TYPE       VARCHAR2(100 CHAR);
    V_LOG_MESSAGE    VARCHAR2(4000 CHAR);
    V_DESCRIPTION    VARCHAR2(4000 CHAR);
    N_LOG_COUNT      PLS_INTEGER := 0;
    D_EVENT_DATE     DATE        := SYSDATE;

BEGIN

    v_program_id   := 'DMF0021';
    v_sheet_name   := 'Sales Plan';
    v_user_col_cnt := 0;

    SELECT COUNT(*)
    INTO   v_user_col_cnt
    FROM   SCM_MST_TITLESET_USER U
    WHERE  1 = 1
    AND    U.PROGRAM_ID = v_program_id
    AND    U.SHEET_NAME = v_sheet_name
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'    /* 2024.03.29   kcw3408  추가 */
    AND    U.USER_ID    = P_CREATED_BY;

    IF v_user_col_cnt > 0 THEN

        OPEN O_RC1 FOR
        SELECT U.PROGRAM_ID
             , U.SHEET_NAME
             , U.COLUMN_NAME
             , C.COLUMN_LABEL_NAME
             , U.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
             , U.DATA_SORT_METHOD_CODE
             , C.SMALL_CLASS_LABEL_NAME
             , C.LARGE_CLASS_LABEL_NAME
             , ''                     AS DAY_CODE
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
        AND    U.USER_ID     = P_CREATED_BY
        AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
        AND    P_DIVISION_ID IN (                                              -- 20180620 division 추가
                   SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                   FROM   DUAL
                   CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
               )
        UNION ALL
        SELECT C.PROGRAM_ID
             , C.SHEET_NAME
             , C.COLUMN_NAME
             , C.COLUMN_LABEL_NAME
             , C.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
             , C.DATA_SORT_METHOD_CODE
             , C.SMALL_CLASS_LABEL_NAME
             , C.LARGE_CLASS_LABEL_NAME
             , ''                     AS DAY_CODE
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
        AND    C.PROGRAM_ID   = v_program_id
        AND    C.SHEET_NAME   = v_sheet_name
        AND    C.VISIBLE_FLAG = ''
        AND    (C.DEFAULT_FLAG IS NULL OR C.DEFAULT_FLAG = '-' OR C.DEFAULT_FLAG = ' ')   -- MSSQL '' = Oracle NULL
        AND    C.VALID_YN     = 'Y'
        AND    P_DIVISION_ID IN (                                              -- 20180620 division 추가
                   SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                   FROM   DUAL
                   CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
               )
        UNION ALL
        SELECT v_program_id            AS PROGRAM_ID
             , v_sheet_name            AS SHEET_NAME
             , T.COLUMN_NAME
             , T.COLUMN_LABEL_NAME
             , TO_NUMBER(T.SORT_ORDER_NO) AS SORT_ORDER_NO    -- ORA-01790 방지
             , ''                      AS DATA_SORT_METHOD_CODE
             , T.SMALL_CLASS_LABEL_NAME
             , T.LARGE_CLASS_LABEL_NAME
             , T.DAY_CODE
             , ''                      AS FIXED_FLAG
             , 50                      AS COLUMN_WIDTH
             , T.CELL_CONTROL_OBJECT_TYPE_CODE   --'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
             , ''                      AS CELL_COMBO_DATA_TYPE
             , 3                       AS DATA_SCALE_NUMBER    -- ORA-01790 방지: NUMBER 리터럴
             , TO_NUMBER(NULL)         AS DATA_MAX_LENGTH      -- ORA-01790 방지: NUMBER NULL
             , 'R'                     AS HORIZONTAL_ALIGN_CODE
             , 'Y'                     AS UPPERCASE_APPLY_FLAG
             , 'Y'                     AS VISIBLE_FLAG
             , ''                      AS DEFAULT_FLAG
             , ''                      AS USER_SELECTABLE_FLAG
             , ''                      AS VALID_YN
             , ''                      AS DIVISION_ID
        FROM (
                SELECT 'D_' || A.BASIS_YYYYMMDD                AS COLUMN_NAME
                     , A.CALENDAR_DAY                          AS COLUMN_LABEL_NAME
                     , A.WEEK_NAME                             AS SMALL_CLASS_LABEL_NAME
                     , A.MONTH_NAME                            AS LARGE_CLASS_LABEL_NAME
                     , A.DAYOFWEEK                             AS DAY_CODE
                     , A.BASIS_YYYYMMDD || TO_CHAR(31, 'FM00') AS SORT_ORDER_NO
                     , 'FPNumber'                              AS CELL_CONTROL_OBJECT_TYPE_CODE
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD   --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
                AND    1 = CASE WHEN P_BUCKET = 'DAILY' THEN 1 ELSE 2 END
                --UNION ALL
                --SELECT 'DB_' || A.BASIS_YYYYMMDD ...
                UNION ALL
                SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK   AS COLUMN_NAME
                     , A.WEEK_NAME                             AS COLUMN_LABEL_NAME
                     , A.WEEK_NAME                             AS SMALL_CLASS_LABEL_NAME
                     , A.MONTH_NAME                            AS LARGE_CLASS_LABEL_NAME
                     , ''                                      AS DAY_CODE
                     , A.BASIS_START_DATE || TO_CHAR(21, 'FM00') AS SORT_ORDER_NO
                     , 'FPNumber'                              AS CELL_CONTROL_OBJECT_TYPE_CODE
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD   --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
                GROUP BY A.BASIS_YYYYMM
                       , A.ISO_WEEK
                       , A.WEEK_NAME
                       , A.MONTH_NAME
                       , A.BASIS_START_DATE
                --UNION ALL
                --SELECT 'WB_' || A.BASIS_YYYYMM || A.ISO_WEEK ...
                UNION ALL
                SELECT 'M_' || A.BASIS_YYYYMM                 AS COLUMN_NAME
                     , A.MONTH_NAME                            AS COLUMN_LABEL_NAME
                     , A.MONTH_NAME                            AS SMALL_CLASS_LABEL_NAME
                     , A.MONTH_NAME                            AS LARGE_CLASS_LABEL_NAME
                     , ''                                      AS DAY_CODE
                     , MIN(A.BASIS_START_DATE) || '01'         AS SORT_ORDER_NO
                     , 'FPNumber'                              AS CELL_CONTROL_OBJECT_TYPE_CODE
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD   --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
                GROUP BY A.BASIS_YYYYMM
                       , A.MONTH_NAME
                --UNION ALL
                --SELECT 'MB_' || A.BASIS_YYYYMM ...
             ) T
        ORDER BY SORT_ORDER_NO;

    ELSE

        OPEN O_RC1 FOR
        SELECT C.PROGRAM_ID
             , C.SHEET_NAME
             , C.COLUMN_NAME
             , C.COLUMN_LABEL_NAME
             , C.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
             , C.DATA_SORT_METHOD_CODE
             , C.SMALL_CLASS_LABEL_NAME
             , C.LARGE_CLASS_LABEL_NAME
             , ''                     AS DAY_CODE
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
        AND    C.PROGRAM_ID   = v_program_id
        AND    C.SHEET_NAME   = v_sheet_name
        AND    C.DEFAULT_FLAG = 'Y'
        AND    C.VALID_YN     = 'Y'
        AND    P_DIVISION_ID IN (                                              -- 20180620 division 추가
                   SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                   FROM   DUAL
                   CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
               )
        UNION ALL
        SELECT C.PROGRAM_ID
             , C.SHEET_NAME
             , C.COLUMN_NAME
             , C.COLUMN_LABEL_NAME
             , C.SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
             , C.DATA_SORT_METHOD_CODE
             , C.SMALL_CLASS_LABEL_NAME
             , C.LARGE_CLASS_LABEL_NAME
             , ''                     AS DAY_CODE
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
        AND    C.PROGRAM_ID   = v_program_id
        AND    C.SHEET_NAME   = v_sheet_name
        AND    C.VISIBLE_FLAG = ''
        AND    (C.DEFAULT_FLAG IS NULL OR C.DEFAULT_FLAG = '-' OR C.DEFAULT_FLAG = ' ')   -- MSSQL '' = Oracle NULL
        AND    C.VALID_YN     = 'Y'
        AND    P_DIVISION_ID IN (                                              -- 20180620 division 추가
                   SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                   FROM   DUAL
                   CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
               )
        UNION ALL
        SELECT v_program_id            AS PROGRAM_ID
             , v_sheet_name            AS SHEET_NAME
             , T.COLUMN_NAME
             , T.COLUMN_LABEL_NAME
             , TO_NUMBER(T.SORT_ORDER_NO) AS SORT_ORDER_NO    -- ORA-01790 방지
             , ''                      AS DATA_SORT_METHOD_CODE
             , T.SMALL_CLASS_LABEL_NAME
             , T.LARGE_CLASS_LABEL_NAME
             , T.DAY_CODE
             , ''                      AS FIXED_FLAG
             , 50                      AS COLUMN_WIDTH
             , 'FPNumber'              AS CELL_CONTROL_OBJECT_TYPE_CODE
             , ''                      AS CELL_COMBO_DATA_TYPE
             , 3                       AS DATA_SCALE_NUMBER    -- ORA-01790 방지: NUMBER 리터럴
             , TO_NUMBER(NULL)         AS DATA_MAX_LENGTH      -- ORA-01790 방지: NUMBER NULL
             , 'R'                     AS HORIZONTAL_ALIGN_CODE
             , 'Y'                     AS UPPERCASE_APPLY_FLAG
             , 'Y'                     AS VISIBLE_FLAG
             , ''                      AS DEFAULT_FLAG
             , ''                      AS USER_SELECTABLE_FLAG
             , ''                      AS VALID_YN
             , ''                      AS DIVISION_ID
        FROM (
                SELECT 'D_' || A.BASIS_YYYYMMDD                AS COLUMN_NAME
                     , A.CALENDAR_DAY                          AS COLUMN_LABEL_NAME
                     , A.WEEK_NAME                             AS SMALL_CLASS_LABEL_NAME
                     , A.MONTH_NAME                            AS LARGE_CLASS_LABEL_NAME
                     , A.DAYOFWEEK                             AS DAY_CODE
                     , A.BASIS_YYYYMMDD || TO_CHAR(31, 'FM00') AS SORT_ORDER_NO
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD   --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
                AND    1 = CASE WHEN P_BUCKET = 'DAILY' THEN 1 ELSE 2 END
                --UNION ALL
                --SELECT 'DB_' || A.BASIS_YYYYMMDD ...
                UNION ALL
                SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK   AS COLUMN_NAME
                     , A.WEEK_NAME                             AS COLUMN_LABEL_NAME
                     , A.WEEK_NAME                             AS SMALL_CLASS_LABEL_NAME
                     , A.MONTH_NAME                            AS LARGE_CLASS_LABEL_NAME
                     , ''                                      AS DAY_CODE
                     , A.BASIS_START_DATE || TO_CHAR(21, 'FM00') AS SORT_ORDER_NO
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD   --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
                GROUP BY A.BASIS_YYYYMM
                       , A.ISO_WEEK
                       , A.WEEK_NAME
                       , A.MONTH_NAME
                       , A.BASIS_START_DATE
                --UNION ALL
                --SELECT 'WB_' || A.BASIS_YYYYMM || A.ISO_WEEK ...
                UNION ALL
                SELECT 'M_' || A.BASIS_YYYYMM                 AS COLUMN_NAME
                     , A.MONTH_NAME                            AS COLUMN_LABEL_NAME
                     , A.MONTH_NAME                            AS SMALL_CLASS_LABEL_NAME
                     , A.MONTH_NAME                            AS LARGE_CLASS_LABEL_NAME
                     , ''                                      AS DAY_CODE
                     , MIN(A.BASIS_START_DATE) || '01'         AS SORT_ORDER_NO
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD   --CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
                GROUP BY A.BASIS_YYYYMM
                       , A.MONTH_NAME
                --UNION ALL
                --SELECT 'MB_' || A.BASIS_YYYYMM ...
             ) T
        ORDER BY SORT_ORDER_NO;

    END IF;

    --=============================================================================================================================
    -- 결과코드 0 성공, -1 오류. 조회에서는 건수 없음. NULL로 회신
    --=============================================================================================================================
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        D_EVENT_DATE  := SYSDATE;
        V_DESCRIPTION := '';
        V_PROC_INPUT  :=
            JSON_OBJECT(
                'P_START_YYYYMMDD' VALUE P_START_YYYYMMDD,
                'P_END_YYYYMMDD'   VALUE P_END_YYYYMMDD,
                'P_CREATED_BY'     VALUE P_CREATED_BY,
                'P_DIVISION_ID'    VALUE P_DIVISION_ID,
                'P_BUCKET'         VALUE P_BUCKET
            );
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END DMF0021_GET_SPREAD_TITLE;
/

CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL
(
    P_ACTIVE_FLAG         IN VARCHAR2,
    P_DIVISION_ID         IN VARCHAR2,
    P_PROJECT_CODE        IN VARCHAR2,
    P_SCM_SITE_ID         IN VARCHAR2,
    P_PLANT_SITE_ID       IN VARCHAR2,
    P_ITEM_ID             IN VARCHAR2,
    P_DOM_EXP             IN VARCHAR2,
    P_FCST_TYPE           IN VARCHAR2,
    P_INCOTERMS           IN VARCHAR2,
    P_MEASURE             IN VARCHAR2,
    P_YYYYMMDD            IN VARCHAR2,
    P_QTY                 IN VARCHAR2,
    P_CURRENCY            IN VARCHAR2,
    P_CREATED_BY          IN VARCHAR2,
    P_LAST_UPDATED_BY     IN VARCHAR2,
    P_TEXT                IN VARCHAR2,
    P_DEPT_ID             IN VARCHAR2,  --[PJ2024-50611] 부서ID추가
    P_CELL_PROD_SITE_ID   IN VARCHAR2,  --[PJ2025-50017] CELL_PROD_SITE_ID 추가
    O_RESULT_CURSOR       OUT SYS_REFCURSOR
)
/*========================================================================================================================
 * Program ID   : DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL
 * Description  : SALES PLAN SAVE 버튼 클릭시 실행 프로시져 ('DM_PLN_SALES_PLAN' TABLE INSERT/UPDATE/DELETE)
 * Program History
 *========================================================================================================================
 *   Date       In Charge      Description
 *========================================================================================================================
 * 2018.03.12   KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.06.14	KHSOMG		40 DIVISION 조건 추가
 * 2021.05.13	P.C.I		[PJ20209642R] DM_MST_EXCHANGE_RATE_C에 CURRENCY = 'KRW' 조건 추가
 * 2021.08.31	hwi1993		[C20210830-000508] [ESS영업관리팀] GSCM Sales Plan창 입력 가능 최대값 수정 요청의 건
 * 2021.11.03	ROSIA27		[PJ20209643] SALES PLAN속도 개선
 * 2021.11.03	ROSIA27		[PJ20209643] SALES PLAN속도 개선. 323라인 DELETE 구문 변경
 * 2021.12.22	rosia27		[C20211220-000276]Sales Plan, Sales Monitoring - 색상 수정 필요
 * 2024.04.04   KCW3408     Sales Plan 관련 자동사업부 기타 매출 추가(속도개선)
 * 2024.04.16   KCW3408     이동계획 기타매출 추가 요건(TEXT추가)
 * 2024.11.05	KJJ			[PJ2024-50611] 소형사업부 Sales Plan 기타매출 입력 추가
 * 2024.11.27	KJJ			[PJ2024-50611] 소형사업부 Sales Plan Catch Up 입력 추가
 * 2024.12.12	KJJ			[PJ2024-50611] 기타매출, Catch Up 테이블 분리
 * 2025.02.13	JSSBAE		[E20250211-000653]_[Sales Plan] ETC 매출 입력 에러 확인 요청
 * 2025.03.12   dsiol		[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : CELL_PROD_SITE_ID 추가, 주요 테이블 변경
 * 2025.04.04   JSSBAE		[E20250401-000548] SMS 선감지 대상 정리
 * 2025.05.07   dsiol	    [PJ2025-50017] 프로젝트와 관련한 각종 주석 추가 작성 및 임시테이블 명칭 변경
 * 2025.05.20   JSSBAE	    [E20250520-000572]_Sales Plan 데이터 Validation 로직 변경
 * 2025.06.02   KANG.H.J	[PJ2025-50188] SALES_PLAN 추가 및 수정시 ATTRIBUTE2(FROM_SITE_ID) 데이터 생성
 * 2025.06.12   KANG.H.J	[PJ2025-50188] 임시테이블 FROM_SITE_ID 추가 관리
 * 2025.06.20   JSSBAE	    [E20250520-000605]_[영업.마케팅PI] Sales Plan - ETC Data 'Monthly' 입력 Bucket 기능 수정 요청
 * 2025.10.03	JSSBAE		[E20250919-001699]_N-ERP 3차 Roll-in 관련 DM Incoterms 전환 대응 건
 * 2025.11.17	JSSBAE		[E20251027-000091]_Sales Plan UI RTF 간편조정 시 RTF_SYS_RP, RTF_SCP 데이터 동기화
 * 2026.03.17   jcnam       [PJ20264226] NextSCM Pilot 설계 및 개발
 ========================================================================================================================*/
AS

    --=============================================================================================================
    -- 스플릿관련 변수
    --=============================================================================================================
    v_active_flag         VARCHAR2(4000 CHAR);
    v_division_id_val     VARCHAR2(4000 CHAR);
    v_project_code_val    VARCHAR2(4000 CHAR);
    v_scm_site_id_val     VARCHAR2(4000 CHAR);
    v_plant_site_id_val   VARCHAR2(4000 CHAR);
    v_item_id_val         VARCHAR2(4000 CHAR);
    v_dom_exp_val         VARCHAR2(4000 CHAR);
    v_fcst_type_val       VARCHAR2(4000 CHAR);
    v_incoterms_val       VARCHAR2(4000 CHAR);
    v_measure_val         VARCHAR2(4000 CHAR);
    v_wyyyymmdd           VARCHAR2(4000 CHAR);
    v_yyyymmdd_val        VARCHAR2(8 CHAR);
    v_currency_val        VARCHAR2(4000 CHAR);
    v_qty_val             NUMBER(30,10);
    v_created_by_val      VARCHAR2(4000 CHAR);
    v_last_updated_by_val VARCHAR2(4000 CHAR);
    v_text_val            VARCHAR2(4000 CHAR);
    v_dept_id_val         VARCHAR2(4000 CHAR);
    v_cell_prod_val       VARCHAR2(4000 CHAR);
    v_bucket_val          VARCHAR2(10 CHAR);
    v_weeknumber          VARCHAR2(2 CHAR);
    v_yyyy                VARCHAR2(4 CHAR);
    v_yyyymm              VARCHAR2(6 CHAR);
    v_max_cnt             PLS_INTEGER := 0;

    -- FCST_TYPE 룩업
    T_FCST_TYPE           T_STR_TAB := T_STR_TAB();

    --=============================================================================================================
    -- LOG 용 변수 설정
    --=============================================================================================================
    v_log_type            VARCHAR2(30 CHAR);
    n_log_count           PLS_INTEGER := 0;
    v_log_message         VARCHAR2(1000 CHAR);
    v_description         VARCHAR2(4000 CHAR);
    d_event_date          DATE;
    n_del_count           PLS_INTEGER := 0;
    n_insert_count        PLS_INTEGER := 0;
    n_event_count         PLS_INTEGER := 0;

    --=============================================================================================================
    -- VALIDATION 변수
    --=============================================================================================================
    V_S_VALIDATION        VARCHAR2(4000 CHAR) := NULL;
    V_S_CODE              VARCHAR2(50 CHAR)   := NULL;

    --=============================================================================================================
    -- VERSION 변수
    --=============================================================================================================
    v_max_mf_w_version    VARCHAR2(100 CHAR);
    v_max_mf_w_yyyymmdd   VARCHAR2(8 CHAR);
    v_max_sf_w_version    VARCHAR2(100 CHAR);
    v_max_sf_w_yyyymmdd   VARCHAR2(8 CHAR);
    v_cutoff_start        VARCHAR2(8 CHAR);
    v_cutoff_end          VARCHAR2(8 CHAR);

    --=============================================================================================================
    -- EXCEPTION 변수
    --=============================================================================================================
    V_PROC_INPUT          VARCHAR2(4000 CHAR);
    V_BACKTRACE           VARCHAR2(4000 CHAR);
    V_SQL_CODE            VARCHAR2(100 CHAR);
    V_SQL_ERRMSG          VARCHAR2(1000 CHAR);
    
    V_CNT                 NUMBER;
BEGIN

    --=============================================================================================================
    -- GTT TRUNCATE
    --=============================================================================================================
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_F021_SALES_PLAN';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_F021_SALES_PLAN_LOC';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_F021_SALES_PLAN_RTF';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_F021_DATA_DUP';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_F021_PRICE_RTF_SYS_RP';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE SCM_MGR.GT_F021_SALES_PLAN_INSERT';

    -- 당주 월요일 관련 날짜 미리 계산
    v_cutoff_start := TO_CHAR(TRUNC(SYSDATE, 'IW') - 7, 'YYYYMMDD');
    v_cutoff_end   := TO_CHAR(TRUNC(SYSDATE, 'IW'), 'YYYYMMDD');

    --=============================================================================================================
    -- 시작 LOG
    --=============================================================================================================
    v_log_type    := 'START';
    v_log_message := '########## Start of procedure ##########';
    v_description := '';
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

    --=============================================================================================================
    -- '^' 구분자 파싱 → GT_F021_SALES_PLAN INSERT (PL/SQL FOR LOOP)
    -- MSSQL WHILE 루프 내부에 날짜변환(M_bucket→월말일/01일, W_bucket→IIF+CALENDAR조회) 로직이 있어
    -- 단순 REGEXP INSERT 불가 → 행별 루프 처리
    --=============================================================================================================
    v_max_cnt := REGEXP_COUNT(P_DIVISION_ID, '\^') + 1;

    FOR i IN 1..v_max_cnt LOOP

        v_active_flag         := TRIM(REGEXP_SUBSTR(P_ACTIVE_FLAG,       '[^\^]+', 1, i));
        v_division_id_val     := TRIM(REGEXP_SUBSTR(P_DIVISION_ID,       '[^\^]+', 1, i));
        v_project_code_val    := TRIM(REGEXP_SUBSTR(P_PROJECT_CODE,      '[^\^]+', 1, i));
        v_scm_site_id_val     := TRIM(REGEXP_SUBSTR(P_SCM_SITE_ID,      '[^\^]+', 1, i));
        v_plant_site_id_val   := TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,    '[^\^]+', 1, i));
        v_item_id_val         := TRIM(REGEXP_SUBSTR(P_ITEM_ID,          '[^\^]+', 1, i));
        v_dom_exp_val         := TRIM(REGEXP_SUBSTR(P_DOM_EXP,          '[^\^]+', 1, i));
        v_fcst_type_val       := TRIM(REGEXP_SUBSTR(P_FCST_TYPE,        '[^\^]+', 1, i));
        v_incoterms_val       := TRIM(REGEXP_SUBSTR(P_INCOTERMS,        '[^\^]+', 1, i));
        v_measure_val         := TRIM(REGEXP_SUBSTR(P_MEASURE,          '[^\^]+', 1, i));
        v_wyyyymmdd           := TRIM(REGEXP_SUBSTR(P_YYYYMMDD,         '[^\^]+', 1, i));
        v_currency_val        := TRIM(REGEXP_SUBSTR(P_CURRENCY,         '[^\^]+', 1, i));
        v_qty_val             := TO_NUMBER(TRIM(REGEXP_SUBSTR(P_QTY,    '[^\^]+', 1, i)));
        v_created_by_val      := TRIM(REGEXP_SUBSTR(P_CREATED_BY,       '[^\^]+', 1, i));
        v_last_updated_by_val := TRIM(REGEXP_SUBSTR(P_LAST_UPDATED_BY,  '[^\^]+', 1, i));
        v_text_val            := TRIM(REGEXP_SUBSTR(P_TEXT,              '[^\^]+', 1, i));
        v_dept_id_val         := TRIM(REGEXP_SUBSTR(P_DEPT_ID,          '[^\^]+', 1, i));
        v_cell_prod_val       := TRIM(REGEXP_SUBSTR(P_CELL_PROD_SITE_ID,'[^\^]+', 1, i));

        -- Bucket 구분: 첫글자
        v_bucket_val := SUBSTR(v_wyyyymmdd, 1, 1);
        v_weeknumber := SUBSTR(v_wyyyymmdd, -2);
        v_yyyy       := SUBSTR(v_wyyyymmdd, 3, 4);
        v_yyyymm     := SUBSTR(v_wyyyymmdd, 3, 6);

        -- 날짜 변환 로직
        IF v_bucket_val = 'M' THEN
            --[E20250520-000605]_40사업부 + ETC → 달의 마지막 날
            IF v_division_id_val = '40' AND v_fcst_type_val = 'ETC' THEN
                SELECT v_yyyymm || MAX(CALENDAR_DAY)
                INTO   v_yyyymmdd_val
                FROM   SCM_SYS_CALENDAR_M
                WHERE  BASIS_YYYYMM = v_yyyymm;
            ELSE
                v_yyyymmdd_val := v_yyyymm || '01';
            END IF;
        ELSE
            IF SUBSTR(v_yyyymm, 5, 2) <> '12' THEN
                SELECT CASE WHEN MIN(A.BASIS_YYYYMM) = MAX(A.BASIS_YYYYMM) THEN MIN(A.BASIS_YYYYMMDD)
                            WHEN v_yyyymm = MIN(A.BASIS_YYYYMM) THEN MIN(A.BASIS_YYYYMMDD)
                            ELSE MAX(A.BASIS_YYYYMM) || '01'
                       END
                INTO   v_yyyymmdd_val
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  A.CALENDAR_YYYY = v_yyyy
                AND    A.ISO_WEEK      = v_weeknumber;
            ELSE
                SELECT CASE WHEN MIN(A.BASIS_YYYYMM) = MAX(A.BASIS_YYYYMM) THEN MIN(A.BASIS_YYYYMMDD)
                            WHEN v_yyyymm = MIN(A.BASIS_YYYYMM) THEN MIN(A.BASIS_YYYYMMDD)
                            ELSE MAX(A.BASIS_YYYYMM) || '01'
                       END
                INTO   v_yyyymmdd_val
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  A.CALENDAR_YYYY = v_yyyy
                AND    A.ISO_WEEK      = v_weeknumber
                AND    A.BASIS_YYYYMM  = v_yyyymm;
            END IF;
        END IF;

        INSERT INTO GT_F021_SALES_PLAN
        (V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID,
         V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE,
         V_YYYYMMDD, V_CURRENCY, V_QTY, V_CREATED_BY, V_LAST_UPDATED_BY,
         V_TEXT, V_DEPT_ID, V_BUCKET, V_CELL_PROD_SITE_ID)
        VALUES
        (v_active_flag, v_division_id_val, v_project_code_val, v_scm_site_id_val, v_plant_site_id_val,
         v_item_id_val, v_dom_exp_val, v_fcst_type_val, v_incoterms_val, v_measure_val,
         v_yyyymmdd_val, v_currency_val, v_qty_val, v_created_by_val, v_last_updated_by_val,
         v_text_val, v_dept_id_val, v_bucket_val, v_cell_prod_val);

    END LOOP;

    --COMMIT;

    --=============================================================================================================
    -- [PJ2025-50188] FROM_SITE_ID 업데이트
    --=============================================================================================================
    MERGE INTO GT_F021_SALES_PLAN A
    USING (
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
             , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID
             , MAX(ATTRIBUTE2) AS FROM_SITE_ID
        FROM   DM_PLN_SALES_PLAN
        WHERE  DIVISION_ID = v_division_id_val
        AND    MEASURE     = 'RTF_SYS_RP'
        AND    YYYYMMDD   >= v_cutoff_start
        AND    ATTRIBUTE2 IS NOT NULL
        GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
               , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID
    ) B
    ON (    A.V_DIVISION_ID      = B.DIVISION_ID
        AND A.V_PROJECT_CODE     = B.PROJECT_CODE
        AND A.V_SCM_SITE_ID      = B.SCM_SITE_ID
        AND A.V_PLANT_SITE_ID    = B.PLANT_SITE_ID
        AND A.V_ITEM_ID          = B.ITEM_ID
        AND A.V_DOM_EXP          = B.DOM_EXP
        AND A.V_FCST_TYPE        = B.FCST_TYPE
        AND A.V_INCOTERMS        = B.INCOTERMS
        AND A.V_MEASURE          = B.MEASURE
        AND A.V_CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
    )
    WHEN MATCHED THEN UPDATE SET A.V_FROM_SITE_ID = B.FROM_SITE_ID;

    --COMMIT;

    --=============================================================================================================
    -- GTT 통계 수집
    --=============================================================================================================
    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_F021_SALES_PLAN',
        ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE, METHOD_OPT => 'FOR ALL COLUMNS SIZE 1', NO_INVALIDATE => FALSE);

    --=============================================================================================================
    -- 저장 데이터 유형 별로 GTT 분리
    --=============================================================================================================
    INSERT INTO GT_F021_SALES_PLAN_LOC SELECT * FROM GT_F021_SALES_PLAN WHERE V_MEASURE = 'SalesAmt_LOC';

    INSERT INTO GT_F021_SALES_PLAN_RTF SELECT * FROM GT_F021_SALES_PLAN WHERE V_MEASURE = 'RTF_SYS_RP';

    --[E20251027-000091]_RTF_SYS_RP 메져로 RTF_SCP, RTF 생성
    INSERT INTO GT_F021_SALES_PLAN_RTF
    SELECT A.V_ACTIVE_FLAG, A.V_DIVISION_ID, A.V_PROJECT_CODE, A.V_SCM_SITE_ID, A.V_PLANT_SITE_ID
         , A.V_ITEM_ID, A.V_DOM_EXP, A.V_FCST_TYPE, A.V_INCOTERMS, B.MEASURE
         , A.V_YYYYMMDD, A.V_CURRENCY, A.V_QTY, A.V_CREATED_BY, A.V_LAST_UPDATED_BY
         , A.V_TEXT, A.V_DEPT_ID, A.V_BUCKET, A.V_CELL_PROD_SITE_ID, A.V_FROM_SITE_ID
    FROM GT_F021_SALES_PLAN_RTF A
    CROSS JOIN (SELECT 'RTF' AS MEASURE FROM DUAL UNION ALL SELECT 'RTF_SCP' FROM DUAL) B
    WHERE A.V_MEASURE = 'RTF_SYS_RP';

    --COMMIT;

    --=============================================================================================================
    -- VALIDATION (START)
    --=============================================================================================================

    -- [E20250919-001699]_Incoterms 데이터 처리 VALID 처리
    BEGIN
        SELECT 1 INTO v_max_cnt FROM DUAL
        WHERE EXISTS (
            SELECT 1 FROM GT_F021_SALES_PLAN R
            WHERE R.V_INCOTERMS IN (
                SELECT OLD_VALUE1 FROM NERP_CONV_MASTER WHERE CODETYPE = 'INCOTERMS_ID' GROUP BY OLD_VALUE1
            )
        );
        v_log_type    := 'INVALID';
        V_S_CODE      := 'MSG00467';
        V_S_VALIDATION := ' ';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
    END;

    -- PROJECT_CODE 유효성 (40사업부 제외)
    BEGIN
        SELECT V_PROJECT_CODE INTO V_S_VALIDATION
        FROM (
            SELECT A.V_PROJECT_CODE
            FROM   GT_F021_SALES_PLAN A
            LEFT OUTER JOIN SCM_MST_PROJECT B
                ON A.V_DIVISION_ID  = B.DIVISION_ID
                AND A.V_PROJECT_CODE = B.PROJECT_CODE
            WHERE A.V_PROJECT_CODE <> ''
            AND   A.V_DIVISION_ID  <> '40'
            AND   B.PROJECT_CODE IS NULL
        )
        WHERE ROWNUM = 1;

        v_log_type := 'INVALID';
        V_S_CODE   := 'MSG00457';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN V_S_VALIDATION := NULL;
    END;

    --[E20250520-000572]_INVALID2, INVALID4 VALIDATION 통합
    INSERT INTO GT_F021_DATA_DUP
    (V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_DOM_EXP,
     V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_PLANT_SITE_ID, V_YYYYMMDD, V_CELL_PROD_SITE_ID)
    SELECT LOC.V_DIVISION_ID, LOC.V_PROJECT_CODE, LOC.V_SCM_SITE_ID, LOC.V_ITEM_ID, LOC.V_DOM_EXP
         , LOC.V_FCST_TYPE, LOC.V_INCOTERMS, LOC.V_MEASURE, LOC.V_PLANT_SITE_ID, LOC.V_YYYYMMDD
         , LOC.V_CELL_PROD_SITE_ID
    FROM   GT_F021_SALES_PLAN_LOC LOC
    INNER JOIN DM_PLN_SALES_ETC_PLAN P
        ON  LOC.V_DIVISION_ID   = P.DIVISION_ID
        AND LOC.V_PROJECT_CODE  = P.PROJECT_CODE
        AND LOC.V_SCM_SITE_ID   = P.SCM_SITE_ID
        AND LOC.V_ITEM_ID       = P.ITEM_ID
        AND LOC.V_DOM_EXP       = P.DOM_EXP
        AND LOC.V_FCST_TYPE     = P.FCST_TYPE
        AND LOC.V_INCOTERMS     = P.INCOTERMS
        AND LOC.V_MEASURE       = P.MEASURE
        AND LOC.V_PLANT_SITE_ID = P.PLANT_SITE_ID
        AND LOC.V_YYYYMMDD      = P.YYYYMMDD
        AND LOC.V_TEXT           = P.REMARK_TEXT
    WHERE LOC.V_ACTIVE_FLAG = 'I'
    UNION ALL
    SELECT RTF.V_DIVISION_ID, RTF.V_PROJECT_CODE, RTF.V_SCM_SITE_ID, RTF.V_ITEM_ID, RTF.V_DOM_EXP
         , RTF.V_FCST_TYPE, RTF.V_INCOTERMS, RTF.V_MEASURE, RTF.V_PLANT_SITE_ID, RTF.V_YYYYMMDD
         , RTF.V_CELL_PROD_SITE_ID
    FROM   GT_F021_SALES_PLAN_RTF RTF
    INNER JOIN DM_PLN_SALES_PLAN P
        ON  RTF.V_DIVISION_ID       = P.DIVISION_ID
        AND RTF.V_PROJECT_CODE      = P.PROJECT_CODE
        AND RTF.V_SCM_SITE_ID       = P.SCM_SITE_ID
        AND RTF.V_ITEM_ID           = P.ITEM_ID
        AND RTF.V_DOM_EXP           = P.DOM_EXP
        AND RTF.V_FCST_TYPE         = P.FCST_TYPE
        AND RTF.V_INCOTERMS         = P.INCOTERMS
        AND RTF.V_MEASURE           = P.MEASURE
        AND RTF.V_PLANT_SITE_ID     = P.PLANT_SITE_ID
        AND RTF.V_YYYYMMDD          = P.YYYYMMDD
        AND RTF.V_CELL_PROD_SITE_ID = P.CELL_PROD_SITE_ID
    WHERE RTF.V_ACTIVE_FLAG = 'I';

    BEGIN
        SELECT CHR(10) || '*Div : ' || NVL(V_DIVISION_ID,'')
             || CHR(10) || CASE WHEN V_DIVISION_ID = '40' THEN '*End Customer : ' ELSE '*Project Code : ' END || NVL(V_PROJECT_CODE,'')
             || CHR(10) || '*Sales Site : '          || NVL(V_SCM_SITE_ID,'')
             || CHR(10) || '*Model : '               || NVL(V_ITEM_ID,'')
             || CHR(10) || '*Customer Handbook : '   || NVL(V_DOM_EXP,'')
             || CHR(10) || '*FCST Type : '           || NVL(V_FCST_TYPE,'')
             || CHR(10) || '*INCOTERMS : '           || NVL(V_INCOTERMS,'')
             || CHR(10) || '*Measure : '             || NVL(V_MEASURE,'')
             || CHR(10) || '*Plant Site : '          || NVL(V_PLANT_SITE_ID,'')
             || CHR(10) || '*YYYYMMDD : '            || NVL(V_YYYYMMDD,'')
             || CHR(10) || '*Cell Prod Site ID : '   || NVL(V_CELL_PROD_SITE_ID,'')
        INTO V_S_VALIDATION
        FROM (SELECT * FROM GT_F021_DATA_DUP ORDER BY V_YYYYMMDD)
        WHERE ROWNUM = 1;

        v_log_type := 'INVALID';
        V_S_CODE   := 'MSG00428';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN V_S_VALIDATION := NULL;
    END;

    -- Catch_Up 모델 유효성
    BEGIN
        SELECT A.V_ITEM_ID INTO V_S_VALIDATION
        FROM (
            SELECT A.V_ITEM_ID
            FROM   GT_F021_SALES_PLAN A
            LEFT OUTER JOIN SCM_MST_SITE_ITEM B
                ON  A.V_DIVISION_ID  = B.DIVISION_ID
                AND A.V_PROJECT_CODE = B.PROJECT_CODE
                AND A.V_SCM_SITE_ID  = B.SCM_SITE_ID
                AND A.V_ITEM_ID      = B.ITEM_ID
            WHERE A.V_DIVISION_ID = '40'
            AND   A.V_MEASURE     = 'Catch_Up'
            AND   B.ITEM_ID IS NULL
        ) A
        WHERE ROWNUM = 1;

        v_log_type := 'INVALID';
        V_S_CODE   := 'MSG00458';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN V_S_VALIDATION := NULL;
    END;

    -- Catch_Up 판가 유효성 체크
    SELECT SEGMENT2
    BULK COLLECT INTO T_FCST_TYPE
    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL MST
    WHERE  MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
    AND    MST.SEGMENT1    = 'FCST_TYPE'
    AND    VALID_YN        = 'Y';

    BEGIN
        SELECT 1 INTO v_max_cnt FROM DUAL
        WHERE EXISTS (
            SELECT 1 FROM GT_F021_SALES_PLAN TMP
            WHERE TMP.V_DIVISION_ID = '40'
            AND   TMP.V_MEASURE     = 'Catch_Up'
            AND   TMP.V_FCST_TYPE NOT IN (SELECT COLUMN_VALUE FROM TABLE(T_FCST_TYPE))
            AND   NOT EXISTS (
                SELECT 1 FROM DM_PLN_CFM_SELLING_PRICE FP
                WHERE FP.DIVISION_ID               = TMP.V_DIVISION_ID
                AND   FP.PROJECT_CODE              = TMP.V_PROJECT_CODE
                AND   FP.SCM_SITE_ID               = TMP.V_SCM_SITE_ID
                AND   FP.PLANT_SITE_ID             = TMP.V_PLANT_SITE_ID
                AND   FP.ITEM_ID                   = TMP.V_ITEM_ID
                AND   SUBSTR(FP.YYYYMMDD,1,6)      = SUBSTR(TMP.V_YYYYMMDD,1,6)
                AND   FP.MEASURE                   = 'LOC'
                AND   FP.DOM_EXP                   = TMP.V_DOM_EXP
                AND   FP.FCST_TYPE                 = TMP.V_FCST_TYPE
                AND   FP.INCOTERMS                 = TMP.V_INCOTERMS
                AND   FP.CELL_PROD_SITE_ID         = TMP.V_CELL_PROD_SITE_ID
            )
        );
        v_log_type     := 'INVALID';
        V_S_CODE       := 'MSG00328';
        V_S_VALIDATION := ' ';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
    END;

    -- RMA 음수값 확인
    BEGIN
        SELECT 1 INTO v_max_cnt FROM DUAL
        WHERE EXISTS (
            SELECT 1 FROM GT_F021_SALES_PLAN
            WHERE V_FCST_TYPE = 'RMA' AND V_MEASURE = 'RTF_SYS_RP' AND NVL(V_QTY, 0) > 0
        );
        v_log_type := 'INVALID'; V_S_CODE := 'MSG00459'; V_S_VALIDATION := ' ';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
    END;

    -- RMA 이외 정수값 확인
    BEGIN
        SELECT 1 INTO v_max_cnt FROM DUAL
        WHERE EXISTS (
            SELECT 1 FROM GT_F021_SALES_PLAN
            WHERE V_FCST_TYPE <> 'RMA' AND V_MEASURE = 'RTF_SYS_RP' AND NVL(V_QTY, 0) < 0
        );
        v_log_type := 'INVALID'; V_S_CODE := 'MSG00460'; V_S_VALIDATION := ' ';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
    END;

    -- RTF Price 존재 체크
    INSERT INTO GT_F021_PRICE_RTF_SYS_RP
    (V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_PLANT_SITE_ID, V_CELL_PROD_SITE_ID, WEEK_NAME)
    SELECT A.V_PROJECT_CODE, A.V_SCM_SITE_ID, A.V_ITEM_ID, A.V_DOM_EXP, A.V_FCST_TYPE
         , A.V_INCOTERMS, A.V_PLANT_SITE_ID, A.V_CELL_PROD_SITE_ID, A.WEEK_NAME
    FROM (
        SELECT AA.V_YYYYMMDD, AA.V_DIVISION_ID, AA.V_PROJECT_CODE, AA.V_SCM_SITE_ID, AA.V_PLANT_SITE_ID
             , AA.V_CELL_PROD_SITE_ID, AA.V_ITEM_ID, AA.V_DOM_EXP, AA.V_FCST_TYPE, AA.V_INCOTERMS
             , AA.V_MEASURE, M.BASIS_START_DATE, AA.V_QTY, M.WEEK_NAME
        FROM   GT_F021_SALES_PLAN_RTF AA
        JOIN   SCM_SYS_CALENDAR_M M ON AA.V_YYYYMMDD = M.BASIS_YYYYMMDD
        WHERE  AA.V_MEASURE = 'RTF_SYS_RP'
    ) A
    LEFT JOIN (
        SELECT BB.YYYYMMDD, BB.DIVISION_ID, BB.PROJECT_CODE, BB.SCM_SITE_ID, BB.PLANT_SITE_ID
             , BB.CELL_PROD_SITE_ID, BB.ITEM_ID, BB.DOM_EXP, BB.FCST_TYPE, BB.INCOTERMS
             , BB.MEASURE, M.BASIS_START_DATE, BB.END_CUSTOMER
        FROM   DM_PLN_CFM_SELLING_PRICE BB
        JOIN   SCM_SYS_CALENDAR_M M ON BB.YYYYMMDD = M.BASIS_YYYYMMDD
        WHERE  BB.MEASURE = 'LOC'
    ) B
        ON  A.V_DIVISION_ID      = B.DIVISION_ID
        AND A.V_PROJECT_CODE     = B.PROJECT_CODE
        AND A.V_PROJECT_CODE     = B.END_CUSTOMER
        AND A.V_SCM_SITE_ID      = B.SCM_SITE_ID
        AND A.V_PLANT_SITE_ID    = B.PLANT_SITE_ID
        AND A.V_CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
        AND A.V_ITEM_ID          = B.ITEM_ID
        AND A.V_DOM_EXP          = B.DOM_EXP
        AND A.V_FCST_TYPE        = B.FCST_TYPE
        AND A.V_INCOTERMS        = B.INCOTERMS
        AND A.BASIS_START_DATE   = B.BASIS_START_DATE
    WHERE B.BASIS_START_DATE IS NULL
    AND   A.V_FCST_TYPE <> 'ETC'
    AND   NVL(A.V_QTY, 0) <> 0;

    BEGIN
        SELECT CHR(10) || 'Project Code________ : '      || NVL(V_PROJECT_CODE,'')
             || CHR(10) || 'Sales site_____________ : '  || NVL(V_SCM_SITE_ID,'')
             || CHR(10) || 'Model________________ : '    || NVL(V_ITEM_ID,'')
             || CHR(10) || 'Customs Handbook__ : '       || NVL(V_DOM_EXP,'')
             || CHR(10) || 'Fcst Type_____________ : '   || NVL((SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST WHERE MST.LOOKUP_TYPE = 'SALES_TYPE_CODE' AND MST.SEGMENT1 = V_FCST_TYPE AND ROWNUM = 1), '')
             || CHR(10) || 'Incoterms____________ : '    || NVL(V_INCOTERMS,'')
             || CHR(10) || 'Plant Site___________ : '    || NVL(V_PLANT_SITE_ID,'')
             || CHR(10) || 'Cell Prod Site___________ : ' || NVL(V_CELL_PROD_SITE_ID,'')
             || CHR(10) || 'Week_________ : '            || NVL(WEEK_NAME,'')
        INTO V_S_VALIDATION
        FROM GT_F021_PRICE_RTF_SYS_RP WHERE ROWNUM = 1;

        v_log_type := 'INVALID';
        V_S_CODE   := 'MSG00462';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN V_S_VALIDATION := NULL;
    END;

    -- [E20250401-000548] 동일일자 CURRENCY 중복 체크
    BEGIN
        SELECT CHR(10) || 'Div: '            || NVL(V_DIVISION_ID,'')
             || CHR(10) || 'Project Code: '  || NVL(V_PROJECT_CODE,'')
             || CHR(10) || 'Scm Site Id: '   || NVL(V_SCM_SITE_ID,'')
             || CHR(10) || 'Model: '         || NVL(V_ITEM_ID,'')
             || CHR(10) || 'Currency : '     || NVL(V_CURRENCY,'')
        INTO V_S_VALIDATION
        FROM (
            SELECT V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_TEXT, V_YYYYMMDD
                 , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_CURRENCY, V_PLANT_SITE_ID
            FROM   GT_F021_SALES_PLAN_LOC
            GROUP BY V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_TEXT, V_YYYYMMDD
                   , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_CURRENCY, V_PLANT_SITE_ID
            HAVING COUNT(*) > 1
        )
        WHERE ROWNUM = 1;

        v_log_type := 'INVALID';
        V_S_CODE   := 'MSG00461';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN V_S_VALIDATION := NULL;
    END;

    --=============================================================================================================
    -- VALIDATION (END)
    --=============================================================================================================

    --=============================================================================================================
    -- DELETE SECTION
    --=============================================================================================================

    -- [E20250211-000653] Monthly / Weekly 분기
    SELECT COUNT(1) INTO V_CNT FROM GT_F021_SALES_PLAN WHERE V_BUCKET = 'M';
    IF V_CNT > 0 THEN

        -- Monthly: DM_PLN_SALES_ETC_PLAN (SalesAmt_LOC)
        DELETE FROM DM_PLN_SALES_ETC_PLAN A
        WHERE EXISTS (
            SELECT 1
            FROM   GT_F021_SALES_PLAN TMP
            JOIN   SCM_SYS_CALENDAR_M C1 ON TMP.V_YYYYMMDD = C1.BASIS_YYYYMMDD
            JOIN   SCM_SYS_CALENDAR_M C2 ON A.YYYYMMDD     = C2.BASIS_YYYYMMDD
            WHERE  TMP.V_MEASURE       = 'SalesAmt_LOC'
            AND    A.DIVISION_ID       = TMP.V_DIVISION_ID
            AND    A.PROJECT_CODE      = TMP.V_PROJECT_CODE
            AND    A.SCM_SITE_ID       = TMP.V_SCM_SITE_ID
            AND    A.PLANT_SITE_ID     = TMP.V_PLANT_SITE_ID
            AND    A.ITEM_ID           = TMP.V_ITEM_ID
            AND    A.DOM_EXP           = TMP.V_DOM_EXP
            AND    A.FCST_TYPE         = TMP.V_FCST_TYPE
            AND    A.INCOTERMS         = TMP.V_INCOTERMS
            AND    A.REMARK_TEXT       = TMP.V_TEXT
            AND    C2.BASIS_YYYYMM     = C1.BASIS_YYYYMM
        )
        AND A.MEASURE NOT IN ('MKT_FCST','RTF','CATCH_UP','LOC_Catch_Up','SalesAmt_KRW_Catch_Up','SalesAmt_LOC_Catch_Up','SalesAmt_USD_Catch_Up','RTF_SYS_RP');
        
        n_del_count := n_del_count + SQL%ROWCOUNT;
        
        -- Monthly: DM_PLN_SALES_PLAN (RTF_SYS_RP)
        DELETE FROM DM_PLN_SALES_PLAN A
        WHERE EXISTS (
            SELECT 1
            FROM   GT_F021_SALES_PLAN TMP
            JOIN   SCM_SYS_CALENDAR_M C1 ON TMP.V_YYYYMMDD = C1.BASIS_YYYYMMDD
            JOIN   SCM_SYS_CALENDAR_M C2 ON A.YYYYMMDD     = C2.BASIS_YYYYMMDD
            WHERE  TMP.V_MEASURE           = 'RTF_SYS_RP'
            AND    A.DIVISION_ID           = TMP.V_DIVISION_ID
            AND    A.PROJECT_CODE          = TMP.V_PROJECT_CODE
            AND    A.SCM_SITE_ID           = TMP.V_SCM_SITE_ID
            AND    A.PLANT_SITE_ID         = TMP.V_PLANT_SITE_ID
            AND    A.ITEM_ID               = TMP.V_ITEM_ID
            AND    A.DOM_EXP               = TMP.V_DOM_EXP
            AND    A.FCST_TYPE             = TMP.V_FCST_TYPE
            AND    A.INCOTERMS             = TMP.V_INCOTERMS
            AND    C2.BASIS_YYYYMM         = C1.BASIS_YYYYMM
            AND    A.CELL_PROD_SITE_ID     = TMP.V_CELL_PROD_SITE_ID
        )
        AND A.DIVISION_ID = '40'
        AND A.MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD');

        n_del_count := n_del_count + SQL%ROWCOUNT;

    ELSE
        -- Weekly: DM_PLN_SALES_ETC_PLAN (SalesAmt_LOC)
        DELETE FROM DM_PLN_SALES_ETC_PLAN A
        WHERE EXISTS (
            SELECT 1
            FROM   GT_F021_SALES_PLAN TMP
            JOIN   SCM_SYS_CALENDAR_M C1 ON TMP.V_YYYYMMDD = C1.BASIS_YYYYMMDD
            JOIN   SCM_SYS_CALENDAR_M C2 ON A.YYYYMMDD     = C2.BASIS_YYYYMMDD
            WHERE  TMP.V_MEASURE       = 'SalesAmt_LOC'
            AND    A.DIVISION_ID       = TMP.V_DIVISION_ID
            AND    A.PROJECT_CODE      = TMP.V_PROJECT_CODE
            AND    A.SCM_SITE_ID       = TMP.V_SCM_SITE_ID
            AND    A.PLANT_SITE_ID     = TMP.V_PLANT_SITE_ID
            AND    A.ITEM_ID           = TMP.V_ITEM_ID
            AND    A.DOM_EXP           = TMP.V_DOM_EXP
            AND    A.FCST_TYPE         = TMP.V_FCST_TYPE
            AND    A.INCOTERMS         = TMP.V_INCOTERMS
            AND    A.REMARK_TEXT       = TMP.V_TEXT
            AND    C2.BASIS_YYYYMM     = C1.BASIS_YYYYMM
            AND    C2.ISO_YYYYWW       = C1.ISO_YYYYWW
        )
        AND A.MEASURE NOT IN ('MKT_FCST','RTF','CATCH_UP','LOC_Catch_Up','SalesAmt_KRW_Catch_Up','SalesAmt_LOC_Catch_Up','SalesAmt_USD_Catch_Up','RTF_SYS_RP');

        n_del_count := n_del_count + SQL%ROWCOUNT;

        -- Weekly: DM_PLN_SALES_PLAN (RTF_SYS_RP)
        DELETE FROM DM_PLN_SALES_PLAN A
        WHERE EXISTS (
            SELECT 1
            FROM   GT_F021_SALES_PLAN TMP
            JOIN   SCM_SYS_CALENDAR_M C1 ON TMP.V_YYYYMMDD = C1.BASIS_YYYYMMDD
            JOIN   SCM_SYS_CALENDAR_M C2 ON A.YYYYMMDD     = C2.BASIS_YYYYMMDD
            WHERE  TMP.V_MEASURE           = 'RTF_SYS_RP'
            AND    A.DIVISION_ID           = TMP.V_DIVISION_ID
            AND    A.PROJECT_CODE          = TMP.V_PROJECT_CODE
            AND    A.SCM_SITE_ID           = TMP.V_SCM_SITE_ID
            AND    A.PLANT_SITE_ID         = TMP.V_PLANT_SITE_ID
            AND    A.ITEM_ID               = TMP.V_ITEM_ID
            AND    A.DOM_EXP               = TMP.V_DOM_EXP
            AND    A.FCST_TYPE             = TMP.V_FCST_TYPE
            AND    A.INCOTERMS             = TMP.V_INCOTERMS
            AND    C2.BASIS_YYYYMM         = C1.BASIS_YYYYMM
            AND    C2.ISO_YYYYWW           = C1.ISO_YYYYWW
            AND    A.CELL_PROD_SITE_ID     = TMP.V_CELL_PROD_SITE_ID
        )
        AND A.DIVISION_ID = '40'
        AND A.MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD');

        n_del_count := n_del_count + SQL%ROWCOUNT;

    END IF;

    -- SalesAmt_LOC/CATCH_UP/RTF_SYS_RP delete
    DELETE FROM DM_PLN_SALES_ETC_PLAN A
    WHERE EXISTS (
        SELECT 1 FROM GT_F021_SALES_PLAN TMP
        JOIN SCM_SYS_CALENDAR_M C1 ON TMP.V_YYYYMMDD = C1.BASIS_YYYYMMDD
        JOIN SCM_SYS_CALENDAR_M C2 ON A.YYYYMMDD     = C2.BASIS_YYYYMMDD
        WHERE TMP.V_MEASURE    = 'SalesAmt_LOC'
        AND   A.DIVISION_ID   = TMP.V_DIVISION_ID
        AND   A.PROJECT_CODE  = TMP.V_PROJECT_CODE
        AND   A.SCM_SITE_ID   = TMP.V_SCM_SITE_ID
        AND   A.PLANT_SITE_ID = TMP.V_PLANT_SITE_ID
        AND   A.ITEM_ID       = TMP.V_ITEM_ID
        AND   A.DOM_EXP       = TMP.V_DOM_EXP
        AND   A.FCST_TYPE     = TMP.V_FCST_TYPE
        AND   A.INCOTERMS     = TMP.V_INCOTERMS
        AND   A.REMARK_TEXT   = TMP.V_TEXT
        AND   C2.BASIS_YYYYMM = C1.BASIS_YYYYMM
        AND   C2.ISO_YYYYWW   = C1.ISO_YYYYWW
    )
    AND A.MEASURE NOT IN ('MKT_FCST','RTF','CATCH_UP','LOC_Catch_Up','SalesAmt_KRW_Catch_Up','SalesAmt_LOC_Catch_Up','SalesAmt_USD_Catch_Up','RTF_SYS_RP');

    n_del_count := n_del_count + SQL%ROWCOUNT;

    -- CATCH_UP delete
    DELETE FROM DM_PLN_SALES_ETC_PLAN A
    WHERE EXISTS (
        SELECT 1 FROM GT_F021_SALES_PLAN TMP
        JOIN SCM_SYS_CALENDAR_M C1 ON TMP.V_YYYYMMDD = C1.BASIS_YYYYMMDD
        JOIN SCM_SYS_CALENDAR_M C2 ON A.YYYYMMDD     = C2.BASIS_YYYYMMDD
        WHERE TMP.V_MEASURE    = 'CATCH_UP'
        AND   A.DIVISION_ID   = TMP.V_DIVISION_ID
        AND   A.PROJECT_CODE  = TMP.V_PROJECT_CODE
        AND   A.SCM_SITE_ID   = TMP.V_SCM_SITE_ID
        AND   A.PLANT_SITE_ID = TMP.V_PLANT_SITE_ID
        AND   A.ITEM_ID       = TMP.V_ITEM_ID
        AND   A.DOM_EXP       = TMP.V_DOM_EXP
        AND   A.FCST_TYPE     = TMP.V_FCST_TYPE
        AND   A.INCOTERMS     = TMP.V_INCOTERMS
        AND   A.REMARK_TEXT   = TMP.V_TEXT
        AND   C2.BASIS_YYYYMM = C1.BASIS_YYYYMM
        AND   C2.ISO_YYYYWW   = C1.ISO_YYYYWW
    )
    AND A.MEASURE IN ('CATCH_UP','LOC_Catch_Up','SalesAmt_KRW_Catch_Up','SalesAmt_LOC_Catch_Up','SalesAmt_USD_Catch_Up','RTF_SYS_RP');

    n_del_count := n_del_count + SQL%ROWCOUNT;

    -- RTF_SYS_RP delete from DM_PLN_SALES_PLAN
    DELETE FROM DM_PLN_SALES_PLAN A
    WHERE EXISTS (
        SELECT 1 FROM GT_F021_SALES_PLAN TMP
        JOIN SCM_SYS_CALENDAR_M C1 ON TMP.V_YYYYMMDD = C1.BASIS_YYYYMMDD
        JOIN SCM_SYS_CALENDAR_M C2 ON A.YYYYMMDD     = C2.BASIS_YYYYMMDD
        WHERE TMP.V_MEASURE           = 'RTF_SYS_RP'
        AND   A.DIVISION_ID          = TMP.V_DIVISION_ID
        AND   A.PROJECT_CODE         = TMP.V_PROJECT_CODE
        AND   A.SCM_SITE_ID          = TMP.V_SCM_SITE_ID
        AND   A.PLANT_SITE_ID        = TMP.V_PLANT_SITE_ID
        AND   A.ITEM_ID              = TMP.V_ITEM_ID
        AND   A.DOM_EXP              = TMP.V_DOM_EXP
        AND   A.FCST_TYPE            = TMP.V_FCST_TYPE
        AND   A.INCOTERMS            = TMP.V_INCOTERMS
        AND   C2.BASIS_YYYYMM        = C1.BASIS_YYYYMM
        AND   C2.ISO_YYYYWW          = C1.ISO_YYYYWW
        AND   A.CELL_PROD_SITE_ID    = TMP.V_CELL_PROD_SITE_ID
    )
    AND A.DIVISION_ID = '40'
    AND A.MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD');

    n_del_count := n_del_count + SQL%ROWCOUNT;

    --=============================================================================================================
    -- KRW INSERT (SalesAmt_LOC → SalesAmt_KRW 파생)
    --=============================================================================================================
    INSERT INTO GT_F021_SALES_PLAN_LOC
    (V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID,
     V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE,
     V_YYYYMMDD, V_CURRENCY, V_QTY, V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID,
     V_CELL_PROD_SITE_ID, V_FROM_SITE_ID)
    SELECT V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID
         , V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, 'SalesAmt_KRW'
         , V_YYYYMMDD, V_CURRENCY
         , CASE WHEN tmp.V_CURRENCY = 'KRW' THEN tmp.V_QTY
                WHEN tmp.V_CURRENCY = 'USD' THEN NVL(tmp.V_QTY * (
                    SELECT EXCHANGE_PRICE FROM DM_MST_EXCHANGE_RATE
                    WHERE DIVISION_ID = tmp.V_DIVISION_ID AND YYYYMMDD = SUBSTR(tmp.V_YYYYMMDD,1,6) || '01'
                    AND UNIT_CURRENCY = 'USD' AND CURRENCY = 'KRW' GROUP BY EXCHANGE_PRICE), 0)
                ELSE NVL(tmp.V_QTY * (
                    SELECT EXCHANGE_PRICE FROM DM_MST_EXCHANGE_RATE
                    WHERE DIVISION_ID = tmp.V_DIVISION_ID AND YYYYMMDD = SUBSTR(tmp.V_YYYYMMDD,1,6) || '01'
                    AND UNIT_CURRENCY = tmp.V_CURRENCY AND CURRENCY = 'KRW' GROUP BY EXCHANGE_PRICE), 0)
           END
         , V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID, V_FROM_SITE_ID
    FROM   GT_F021_SALES_PLAN_LOC tmp
    WHERE  tmp.V_MEASURE     = 'SalesAmt_LOC'
    AND    V_ACTIVE_FLAG    <> 'D';

    --=============================================================================================================
    -- USD INSERT (SalesAmt_LOC → SalesAmt_USD 파생)
    --=============================================================================================================
    INSERT INTO GT_F021_SALES_PLAN_LOC
    (V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID,
     V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE,
     V_YYYYMMDD, V_CURRENCY, V_QTY, V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID,
     V_CELL_PROD_SITE_ID, V_FROM_SITE_ID)
    SELECT V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID
         , V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, 'SalesAmt_USD'
         , V_YYYYMMDD, V_CURRENCY
         , CASE WHEN tmp.V_CURRENCY = 'KRW' THEN NVL(tmp.V_QTY / (
                    SELECT EXCHANGE_PRICE FROM DM_MST_EXCHANGE_RATE
                    WHERE DIVISION_ID = tmp.V_DIVISION_ID AND YYYYMMDD = SUBSTR(tmp.V_YYYYMMDD,1,6) || '01'
                    AND UNIT_CURRENCY = 'USD' AND CURRENCY = 'KRW' GROUP BY EXCHANGE_PRICE), 0)
                WHEN tmp.V_CURRENCY = 'USD' THEN tmp.V_QTY
                ELSE NVL(tmp.V_QTY * (
                    SELECT EXCHANGE_PRICE FROM DM_MST_EXCHANGE_RATE
                    WHERE DIVISION_ID = tmp.V_DIVISION_ID AND YYYYMMDD = SUBSTR(tmp.V_YYYYMMDD,1,6) || '01'
                    AND UNIT_CURRENCY = tmp.V_CURRENCY AND CURRENCY = 'KRW' GROUP BY EXCHANGE_PRICE)
                    / (SELECT EXCHANGE_PRICE FROM DM_MST_EXCHANGE_RATE
                       WHERE DIVISION_ID = tmp.V_DIVISION_ID AND YYYYMMDD = SUBSTR(tmp.V_YYYYMMDD,1,6) || '01'
                       AND UNIT_CURRENCY = 'USD' AND CURRENCY = 'KRW' GROUP BY EXCHANGE_PRICE), 0)
           END
         , V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID, V_FROM_SITE_ID
    FROM   GT_F021_SALES_PLAN_LOC tmp
    WHERE  tmp.V_MEASURE     = 'SalesAmt_LOC'
    AND    V_ACTIVE_FLAG    <> 'D';

    --=============================================================================================================
    -- Catch_Up 관련 메저 추가 (SalesAmt_KRW_Catch_Up, SalesAmt_LOC_Catch_Up, SalesAmt_USD_Catch_Up)
    --=============================================================================================================
    -- 1) SalesAmt_KRW_Catch_Up
    INSERT INTO GT_F021_SALES_PLAN
    (V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID,
     V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_YYYYMMDD, V_CURRENCY,
     V_QTY, V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID)
    SELECT V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID
         , V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, 'SalesAmt_KRW_Catch_Up', V_YYYYMMDD, V_CURRENCY
         , NVL(tmp.V_QTY * (SELECT FP.PRICE FROM DM_PLN_CFM_SELLING_PRICE FP
                             JOIN SCM_SYS_CALENDAR_M CAL ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
                             WHERE FP.DIVISION_ID = tmp.V_DIVISION_ID AND FP.PROJECT_CODE = tmp.V_PROJECT_CODE
                             AND FP.SCM_SITE_ID = tmp.V_SCM_SITE_ID AND FP.PLANT_SITE_ID = tmp.V_PLANT_SITE_ID
                             AND FP.ITEM_ID = tmp.V_ITEM_ID AND FP.DOM_EXP = tmp.V_DOM_EXP
                             AND FP.FCST_TYPE = tmp.V_FCST_TYPE AND FP.INCOTERMS = tmp.V_INCOTERMS
                             AND FP.MEASURE = 'KRW' AND CAL.BASIS_START_DATE = tmp.V_YYYYMMDD
                             AND FP.CELL_PROD_SITE_ID = tmp.V_CELL_PROD_SITE_ID AND ROWNUM = 1), 0)
         , V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID
    FROM   GT_F021_SALES_PLAN tmp
    WHERE  tmp.V_MEASURE = 'Catch_Up' AND V_ACTIVE_FLAG <> 'D';
   
    -- 2) SalesAmt_LOC_Catch_Up
    INSERT INTO GT_F021_SALES_PLAN
    (V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID,
     V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_YYYYMMDD, V_CURRENCY,
     V_QTY, V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID)
    SELECT V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID
         , V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, 'SalesAmt_LOC_Catch_Up', V_YYYYMMDD, V_CURRENCY
         , NVL(tmp.V_QTY * (SELECT FP.PRICE FROM DM_PLN_CFM_SELLING_PRICE FP
                             JOIN SCM_SYS_CALENDAR_M CAL ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
                             WHERE FP.DIVISION_ID = tmp.V_DIVISION_ID AND FP.PROJECT_CODE = tmp.V_PROJECT_CODE
                             AND FP.SCM_SITE_ID = tmp.V_SCM_SITE_ID AND FP.PLANT_SITE_ID = tmp.V_PLANT_SITE_ID
                             AND FP.ITEM_ID = tmp.V_ITEM_ID AND FP.DOM_EXP = tmp.V_DOM_EXP
                             AND FP.FCST_TYPE = tmp.V_FCST_TYPE AND FP.INCOTERMS = tmp.V_INCOTERMS
                             AND FP.MEASURE = 'LOC' AND CAL.BASIS_START_DATE = tmp.V_YYYYMMDD
                             AND FP.CELL_PROD_SITE_ID = tmp.V_CELL_PROD_SITE_ID AND ROWNUM = 1), 0)
         , V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID
    FROM   GT_F021_SALES_PLAN tmp
    WHERE  tmp.V_MEASURE = 'Catch_Up' AND V_ACTIVE_FLAG <> 'D';
    
    -- 3) SalesAmt_USD_Catch_Up
    INSERT INTO GT_F021_SALES_PLAN
    (V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID,
     V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_YYYYMMDD, V_CURRENCY,
     V_QTY, V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID)
    SELECT V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID
         , V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, 'SalesAmt_USD_Catch_Up', V_YYYYMMDD, V_CURRENCY
         , NVL(tmp.V_QTY * (SELECT FP.PRICE FROM DM_PLN_CFM_SELLING_PRICE FP
                             JOIN SCM_SYS_CALENDAR_M CAL ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
                             WHERE FP.DIVISION_ID = tmp.V_DIVISION_ID AND FP.PROJECT_CODE = tmp.V_PROJECT_CODE
                             AND FP.SCM_SITE_ID = tmp.V_SCM_SITE_ID AND FP.PLANT_SITE_ID = tmp.V_PLANT_SITE_ID
                             AND FP.ITEM_ID = tmp.V_ITEM_ID AND FP.DOM_EXP = tmp.V_DOM_EXP
                             AND FP.FCST_TYPE = tmp.V_FCST_TYPE AND FP.INCOTERMS = tmp.V_INCOTERMS
                             AND FP.MEASURE = 'USD' AND CAL.BASIS_START_DATE = tmp.V_YYYYMMDD
                             AND FP.CELL_PROD_SITE_ID = tmp.V_CELL_PROD_SITE_ID AND ROWNUM = 1), 0)
         , V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID
    FROM   GT_F021_SALES_PLAN tmp
    WHERE  tmp.V_MEASURE = 'Catch_Up' AND V_ACTIVE_FLAG <> 'D';

    --=============================================================================================================
    -- DM_PLN_SALES_ETC_PLAN INSERT
    --=============================================================================================================
    -- SELECT COUNT(1) INTO n_insert_count FROM GT_F021_SALES_PLAN WHERE V_MEASURE IN ('SalesAmt_LOC','Catch_Up');

    INSERT INTO DM_PLN_SALES_ETC_PLAN
    (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, REMARK_TEXT,
     DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, CURRENCY, QTY,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1,
     ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
    SELECT V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID, V_ITEM_ID, V_TEXT,
           V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_YYYYMMDD, V_CURRENCY, V_QTY,
           V_CREATED_BY, SYSDATE, V_LAST_UPDATED_BY, SYSDATE, V_DEPT_ID,
           NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
    FROM   GT_F021_SALES_PLAN_LOC
    WHERE  V_ACTIVE_FLAG <> 'D';

    n_insert_count := n_insert_count + SQL%ROWCOUNT;

    
    
    -- HISTORY INSERT
    INSERT INTO DM_PLN_SALES_ETC_PLAN_H
    (DIVISION_ID, HISTORY_SEQ, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, REMARK_TEXT,
     DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, CURRENCY, QTY,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1,
     ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
    SELECT V_DIVISION_ID, 
    SEQ1_DM_PLN_SALES_PLAN_H.NEXTVAL,
    V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID, V_ITEM_ID, V_TEXT,
           V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_YYYYMMDD, V_CURRENCY, V_QTY,
           V_CREATED_BY, SYSDATE, V_LAST_UPDATED_BY, SYSDATE, V_DEPT_ID,
           NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, V_ACTIVE_FLAG
    FROM   GT_F021_SALES_PLAN_LOC;

    n_insert_count := n_insert_count + SQL%ROWCOUNT;
    --DBMS_OUTPUT.PUT_LINE('DM_PLN_SALES_ETC_PLAN_H: '||n_insert_count);
    
    --=============================================================================================================
    -- RTF_SYS_RP 기반 SalesAmt_KRW/LOC/USD 파생 INSERT into GT_F021_SALES_PLAN_RTF
    -- (판가 조회: SCM_MST_FUTURE_PRICE 또는 DM_PLN_CFM_SELLING_PRICE - 사업부별 분기)
    --=============================================================================================================
    -- 1) RTF_SYS_RP → SalesAmt_KRW
    INSERT INTO GT_F021_SALES_PLAN_RTF
    (V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID,
     V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_YYYYMMDD, V_CURRENCY,
     V_QTY, V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID, V_FROM_SITE_ID)
    SELECT V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID
         , V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, 'SalesAmt_KRW', V_YYYYMMDD, V_CURRENCY
         , NVL(tmp.V_QTY * (
              SELECT PRICE FROM (
                  SELECT 'SCM_MST_FUTURE_PRICE' AS TBL, FP.PRICE, FP.DIVISION_ID
                  FROM SCM_MST_FUTURE_PRICE FP JOIN SCM_SYS_CALENDAR_M CAL ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
                  WHERE FP.DIVISION_ID = tmp.V_DIVISION_ID AND FP.PROJECT_CODE = tmp.V_PROJECT_CODE
                  AND FP.SCM_SITE_ID = tmp.V_SCM_SITE_ID AND FP.PLANT_SITE_ID = tmp.V_PLANT_SITE_ID
                  AND FP.ITEM_ID = tmp.V_ITEM_ID AND FP.DOM_EXP = tmp.V_DOM_EXP
                  AND FP.FCST_TYPE = tmp.V_FCST_TYPE AND FP.INCOTERMS = tmp.V_INCOTERMS
                  AND FP.MEASURE = 'KRW' AND CAL.BASIS_START_DATE = tmp.V_YYYYMMDD AND ROWNUM = 1
                  UNION ALL
                  SELECT 'DM_PLN_CFM_SELLING_PRICE' AS TBL, FP.PRICE, FP.DIVISION_ID
                  FROM DM_PLN_CFM_SELLING_PRICE FP JOIN SCM_SYS_CALENDAR_M CAL ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
                  WHERE FP.DIVISION_ID = tmp.V_DIVISION_ID AND FP.PROJECT_CODE = tmp.V_PROJECT_CODE
                  AND FP.SCM_SITE_ID = tmp.V_SCM_SITE_ID AND FP.PLANT_SITE_ID = tmp.V_PLANT_SITE_ID
                  AND FP.ITEM_ID = tmp.V_ITEM_ID AND FP.DOM_EXP = tmp.V_DOM_EXP
                  AND FP.FCST_TYPE = tmp.V_FCST_TYPE AND FP.INCOTERMS = tmp.V_INCOTERMS
                  AND FP.MEASURE = 'KRW' AND FP.CELL_PROD_SITE_ID = tmp.V_CELL_PROD_SITE_ID
                  AND CAL.BASIS_START_DATE = tmp.V_YYYYMMDD AND ROWNUM = 1
              ) AA WHERE AA.TBL = CASE WHEN AA.DIVISION_ID = '40' THEN 'DM_PLN_CFM_SELLING_PRICE' ELSE 'SCM_MST_FUTURE_PRICE' END
           ), 0)
         , V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID, V_FROM_SITE_ID
    FROM   GT_F021_SALES_PLAN_RTF tmp
    WHERE  tmp.V_MEASURE = 'RTF_SYS_RP' AND V_ACTIVE_FLAG <> 'D';

    -- 2) RTF_SYS_RP → SalesAmt_LOC (동일 패턴, MEASURE='LOC')
    INSERT INTO GT_F021_SALES_PLAN_RTF
    (V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID,
     V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_YYYYMMDD, V_CURRENCY,
     V_QTY, V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID, V_FROM_SITE_ID)
    SELECT V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID
         , V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, 'SalesAmt_LOC', V_YYYYMMDD, V_CURRENCY
         , NVL(tmp.V_QTY * (
              SELECT PRICE FROM (
                  SELECT 'SCM_MST_FUTURE_PRICE' AS TBL, FP.PRICE, FP.DIVISION_ID
                  FROM SCM_MST_FUTURE_PRICE FP JOIN SCM_SYS_CALENDAR_M CAL ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
                  WHERE FP.DIVISION_ID = tmp.V_DIVISION_ID AND FP.PROJECT_CODE = tmp.V_PROJECT_CODE
                  AND FP.SCM_SITE_ID = tmp.V_SCM_SITE_ID AND FP.PLANT_SITE_ID = tmp.V_PLANT_SITE_ID
                  AND FP.ITEM_ID = tmp.V_ITEM_ID AND FP.DOM_EXP = tmp.V_DOM_EXP
                  AND FP.FCST_TYPE = tmp.V_FCST_TYPE AND FP.INCOTERMS = tmp.V_INCOTERMS
                  AND FP.MEASURE = 'LOC' AND CAL.BASIS_START_DATE = tmp.V_YYYYMMDD AND ROWNUM = 1
                  UNION ALL
                  SELECT 'DM_PLN_CFM_SELLING_PRICE' AS TBL, FP.PRICE, FP.DIVISION_ID
                  FROM DM_PLN_CFM_SELLING_PRICE FP JOIN SCM_SYS_CALENDAR_M CAL ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
                  WHERE FP.DIVISION_ID = tmp.V_DIVISION_ID AND FP.PROJECT_CODE = tmp.V_PROJECT_CODE
                  AND FP.SCM_SITE_ID = tmp.V_SCM_SITE_ID AND FP.PLANT_SITE_ID = tmp.V_PLANT_SITE_ID
                  AND FP.ITEM_ID = tmp.V_ITEM_ID AND FP.DOM_EXP = tmp.V_DOM_EXP
                  AND FP.FCST_TYPE = tmp.V_FCST_TYPE AND FP.INCOTERMS = tmp.V_INCOTERMS
                  AND FP.MEASURE = 'LOC' AND FP.CELL_PROD_SITE_ID = tmp.V_CELL_PROD_SITE_ID
                  AND CAL.BASIS_START_DATE = tmp.V_YYYYMMDD AND ROWNUM = 1
              ) AA WHERE AA.TBL = CASE WHEN AA.DIVISION_ID = '40' THEN 'DM_PLN_CFM_SELLING_PRICE' ELSE 'SCM_MST_FUTURE_PRICE' END
           ), 0)
         , V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID, V_FROM_SITE_ID
    FROM   GT_F021_SALES_PLAN_RTF tmp
    WHERE  tmp.V_MEASURE = 'RTF_SYS_RP' AND V_ACTIVE_FLAG <> 'D';

    -- 3) RTF_SYS_RP → SalesAmt_USD (동일 패턴, MEASURE='USD')
    INSERT INTO GT_F021_SALES_PLAN_RTF
    (V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID,
     V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_YYYYMMDD, V_CURRENCY,
     V_QTY, V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID, V_FROM_SITE_ID)
    SELECT V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID
         , V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, 'SalesAmt_USD', V_YYYYMMDD, V_CURRENCY
         , NVL(tmp.V_QTY * (
              SELECT PRICE FROM (
                  SELECT 'SCM_MST_FUTURE_PRICE' AS TBL, FP.PRICE, FP.DIVISION_ID
                  FROM SCM_MST_FUTURE_PRICE FP JOIN SCM_SYS_CALENDAR_M CAL ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
                  WHERE FP.DIVISION_ID = tmp.V_DIVISION_ID AND FP.PROJECT_CODE = tmp.V_PROJECT_CODE
                  AND FP.SCM_SITE_ID = tmp.V_SCM_SITE_ID AND FP.PLANT_SITE_ID = tmp.V_PLANT_SITE_ID
                  AND FP.ITEM_ID = tmp.V_ITEM_ID AND FP.DOM_EXP = tmp.V_DOM_EXP
                  AND FP.FCST_TYPE = tmp.V_FCST_TYPE AND FP.INCOTERMS = tmp.V_INCOTERMS
                  AND FP.MEASURE = 'USD' AND CAL.BASIS_START_DATE = tmp.V_YYYYMMDD AND ROWNUM = 1
                  UNION ALL
                  SELECT 'DM_PLN_CFM_SELLING_PRICE' AS TBL, FP.PRICE, FP.DIVISION_ID
                  FROM DM_PLN_CFM_SELLING_PRICE FP JOIN SCM_SYS_CALENDAR_M CAL ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
                  WHERE FP.DIVISION_ID = tmp.V_DIVISION_ID AND FP.PROJECT_CODE = tmp.V_PROJECT_CODE
                  AND FP.SCM_SITE_ID = tmp.V_SCM_SITE_ID AND FP.PLANT_SITE_ID = tmp.V_PLANT_SITE_ID
                  AND FP.ITEM_ID = tmp.V_ITEM_ID AND FP.DOM_EXP = tmp.V_DOM_EXP
                  AND FP.FCST_TYPE = tmp.V_FCST_TYPE AND FP.INCOTERMS = tmp.V_INCOTERMS
                  AND FP.MEASURE = 'USD' AND FP.CELL_PROD_SITE_ID = tmp.V_CELL_PROD_SITE_ID
                  AND CAL.BASIS_START_DATE = tmp.V_YYYYMMDD AND ROWNUM = 1
              ) AA WHERE AA.TBL = CASE WHEN AA.DIVISION_ID = '40' THEN 'DM_PLN_CFM_SELLING_PRICE' ELSE 'SCM_MST_FUTURE_PRICE' END
           ), 0)
         , V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID, V_FROM_SITE_ID
    FROM   GT_F021_SALES_PLAN tmp
    WHERE  tmp.V_MEASURE = 'RTF_SYS_RP' AND V_ACTIVE_FLAG <> 'D';

    --=============================================================================================================
    -- DM_PLN_SALES_PLAN INSERT (RTF_SYS_RP 계열)
    --=============================================================================================================
    INSERT INTO DM_PLN_SALES_PLAN
    (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
     DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, CURRENCY, QTY,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
     ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10,
     CELL_PROD_SITE_ID)
    SELECT V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID, V_ITEM_ID
         , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_YYYYMMDD, V_CURRENCY, V_QTY
         , V_CREATED_BY, SYSDATE, V_LAST_UPDATED_BY, SYSDATE
         , V_DEPT_ID, V_FROM_SITE_ID, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
         , V_CELL_PROD_SITE_ID
    FROM   GT_F021_SALES_PLAN_RTF
    WHERE  V_MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD')
    AND    V_ACTIVE_FLAG <> 'D';

    n_insert_count := n_insert_count + SQL%ROWCOUNT;
    
    -- HISTORY INSERT
    INSERT INTO DM_PLN_SALES_PLAN_H
    (DIVISION_ID, HISTORY_SEQ, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
     DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, CURRENCY, QTY,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
     ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10,
     CELL_PROD_SITE_ID)
    SELECT V_DIVISION_ID, SEQ1_DM_PLN_SALES_PLAN_H.NEXTVAL, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID, V_ITEM_ID
         , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_YYYYMMDD, V_CURRENCY, V_QTY
         , V_CREATED_BY, SYSDATE, V_LAST_UPDATED_BY, SYSDATE
         , V_DEPT_ID, V_FROM_SITE_ID, NULL, NULL, NULL, NULL, NULL, NULL, NULL, V_ACTIVE_FLAG
         , V_CELL_PROD_SITE_ID
    FROM   GT_F021_SALES_PLAN_RTF
    WHERE  V_MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD');

    n_insert_count := n_insert_count + SQL%ROWCOUNT;
    
    --=============================================================================================================
    -- [PJ2025-50017] CFM_MKT_DEMAND_PLAN / MKT_FCST 동기화
    --=============================================================================================================
    INSERT INTO GT_F021_SALES_PLAN_INSERT
    (V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID, V_ITEM_ID,
     V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_LAST_UPDATED_BY,
     V_CELL_PROD_SITE_ID, V_YYYYMM, V_FROM_SITE_ID)
    SELECT DISTINCT V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID, V_ITEM_ID
         , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_LAST_UPDATED_BY
         , V_CELL_PROD_SITE_ID, SUBSTR(V_YYYYMMDD,1,6), V_FROM_SITE_ID
    FROM   GT_F021_SALES_PLAN_RTF;

    --COMMIT;

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_F021_SALES_PLAN_INSERT',
        ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE, METHOD_OPT => 'FOR ALL COLUMNS SIZE 1', NO_INVALIDATE => FALSE);

    -- DELETE CFM_MKT_DEMAND_PLAN
    DELETE FROM DM_PLN_CFM_MKT_DEMAND_PLAN
    WHERE DIVISION_ID = v_division_id_val
    AND   MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_LOC','SalesAmt_USD','SalesAmt_KRW')
    AND   EXISTS (
        SELECT 1 FROM GT_F021_SALES_PLAN_INSERT Z
        WHERE Z.V_DIVISION_ID      = DM_PLN_CFM_MKT_DEMAND_PLAN.DIVISION_ID
        AND   Z.V_PROJECT_CODE     = DM_PLN_CFM_MKT_DEMAND_PLAN.PROJECT_CODE
        AND   Z.V_SCM_SITE_ID      = DM_PLN_CFM_MKT_DEMAND_PLAN.SCM_SITE_ID
        AND   Z.V_ITEM_ID          = DM_PLN_CFM_MKT_DEMAND_PLAN.ITEM_ID
        AND   Z.V_DOM_EXP          = DM_PLN_CFM_MKT_DEMAND_PLAN.DOM_EXP
        AND   Z.V_FCST_TYPE        = DM_PLN_CFM_MKT_DEMAND_PLAN.FCST_TYPE
        AND   Z.V_INCOTERMS        = DM_PLN_CFM_MKT_DEMAND_PLAN.INCOTERMS
        AND   Z.V_MEASURE          = DM_PLN_CFM_MKT_DEMAND_PLAN.MEASURE
        AND   Z.V_PLANT_SITE_ID    = DM_PLN_CFM_MKT_DEMAND_PLAN.PLANT_SITE_ID
        AND   Z.V_CELL_PROD_SITE_ID = DM_PLN_CFM_MKT_DEMAND_PLAN.CELL_PROD_SITE_ID
        AND   Z.V_YYYYMM           = SUBSTR(DM_PLN_CFM_MKT_DEMAND_PLAN.YYYYMMDD, 1, 6)
    );

    n_del_count := n_del_count + SQL%ROWCOUNT;
    
    -- INSERT CFM_MKT_DEMAND_PLAN
    INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN
    (DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS,
     MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE,
     LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5,
     ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
         , A.MEASURE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD, A.QTY, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE
         , A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, NULL, Z.V_FROM_SITE_ID, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
    FROM   DM_PLN_SALES_PLAN A
    JOIN   GT_F021_SALES_PLAN_INSERT Z
        ON  A.DIVISION_ID          = Z.V_DIVISION_ID
        AND A.PROJECT_CODE         = Z.V_PROJECT_CODE
        AND A.SCM_SITE_ID          = Z.V_SCM_SITE_ID
        AND A.ITEM_ID              = Z.V_ITEM_ID
        AND A.DOM_EXP              = Z.V_DOM_EXP
        AND A.FCST_TYPE            = Z.V_FCST_TYPE
        AND A.INCOTERMS            = Z.V_INCOTERMS
        AND A.MEASURE              = Z.V_MEASURE
        AND A.PLANT_SITE_ID        = Z.V_PLANT_SITE_ID
        AND A.CELL_PROD_SITE_ID    = Z.V_CELL_PROD_SITE_ID
        AND SUBSTR(A.YYYYMMDD,1,6) = Z.V_YYYYMM
    WHERE  A.DIVISION_ID = v_division_id_val
    AND    A.MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_LOC','SalesAmt_USD','SalesAmt_KRW');

    n_insert_count := n_insert_count + SQL%ROWCOUNT;
    
    -- DELETE/INSERT DM_PLN_MKT_FCST
    DELETE FROM DM_PLN_MKT_FCST
    WHERE DIVISION_ID = v_division_id_val
    AND   MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP')
    AND   EXISTS (
        SELECT 1 FROM GT_F021_SALES_PLAN_INSERT Z
        WHERE Z.V_DIVISION_ID   = DM_PLN_MKT_FCST.DIVISION_ID
        AND   Z.V_PROJECT_CODE  = DM_PLN_MKT_FCST.PROJECT_CODE
        AND   Z.V_SCM_SITE_ID   = DM_PLN_MKT_FCST.SCM_SITE_ID
        AND   Z.V_ITEM_ID       = DM_PLN_MKT_FCST.ITEM_ID
        AND   Z.V_DOM_EXP       = DM_PLN_MKT_FCST.DOM_EXP
        AND   Z.V_FCST_TYPE     = DM_PLN_MKT_FCST.FCST_TYPE
        AND   Z.V_INCOTERMS     = DM_PLN_MKT_FCST.INCOTERMS
        AND   Z.V_MEASURE       = DM_PLN_MKT_FCST.MEASURE
        AND   Z.V_PLANT_SITE_ID = DM_PLN_MKT_FCST.PLANT_SITE_ID
        AND   Z.V_YYYYMM        = SUBSTR(DM_PLN_MKT_FCST.YYYYMMDD, 1, 6)
    );

    n_del_count := n_del_count + SQL%ROWCOUNT;

    
    INSERT INTO DM_PLN_MKT_FCST
    (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS,
     MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
         , A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, SUM(A.QTY), MAX(A.LAST_UPDATED_BY), MAX(A.LAST_UPDATE_DATE)
         , MAX(A.LAST_UPDATED_BY), MAX(A.LAST_UPDATE_DATE)
    FROM   DM_PLN_SALES_PLAN A
    JOIN   GT_F021_SALES_PLAN_INSERT Z
        ON  A.DIVISION_ID          = Z.V_DIVISION_ID
        AND A.PROJECT_CODE         = Z.V_PROJECT_CODE
        AND A.SCM_SITE_ID          = Z.V_SCM_SITE_ID
        AND A.ITEM_ID              = Z.V_ITEM_ID
        AND A.DOM_EXP              = Z.V_DOM_EXP
        AND A.FCST_TYPE            = Z.V_FCST_TYPE
        AND A.INCOTERMS            = Z.V_INCOTERMS
        AND A.MEASURE              = Z.V_MEASURE
        AND A.PLANT_SITE_ID        = Z.V_PLANT_SITE_ID
        AND A.CELL_PROD_SITE_ID    = Z.V_CELL_PROD_SITE_ID
        AND SUBSTR(A.YYYYMMDD,1,6) = Z.V_YYYYMM
    WHERE  A.DIVISION_ID = v_division_id_val
    AND    A.MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP')
    GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
           , A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD;

    n_insert_count := n_insert_count + SQL%ROWCOUNT;
    
    --=============================================================================================================
    -- VERSION 기반 _C 테이블 동기화 (MF_W, SF_W)
    --=============================================================================================================
    -- MF_W VERSION
    SELECT MAX(VERSION_NO) INTO v_max_mf_w_version
    FROM   DM_MST_VERSION
    WHERE  DIVISION_ID  = v_division_id_val
    AND    VERSION_TYPE = 'MF_W'
    AND    YYYYMMDD    >= v_cutoff_start
    AND    YYYYMMDD     < v_cutoff_end;

    
    IF v_max_mf_w_version IS NOT NULL THEN
        SELECT YYYYMMDD INTO v_max_mf_w_yyyymmdd
        FROM   DM_MST_VERSION
        WHERE  DIVISION_ID  = v_division_id_val
        AND    VERSION_NO   = v_max_mf_w_version
        AND    VERSION_TYPE = 'MF_W';

        -- DELETE/INSERT DM_PLN_CFM_MKT_DEMAND_PLAN_C (MF_W)
        DELETE FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C
        WHERE DIVISION_ID = v_division_id_val AND VERSION_NO = v_max_mf_w_version AND CUTOFF_TYPE = 'MF_W'
        AND MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_LOC','SalesAmt_USD','SalesAmt_KRW')
        AND EXISTS (SELECT 1 FROM GT_F021_SALES_PLAN_INSERT Z WHERE Z.V_DIVISION_ID = DM_PLN_CFM_MKT_DEMAND_PLAN_C.DIVISION_ID AND Z.V_PROJECT_CODE = DM_PLN_CFM_MKT_DEMAND_PLAN_C.PROJECT_CODE AND Z.V_SCM_SITE_ID = DM_PLN_CFM_MKT_DEMAND_PLAN_C.SCM_SITE_ID AND Z.V_ITEM_ID = DM_PLN_CFM_MKT_DEMAND_PLAN_C.ITEM_ID AND Z.V_DOM_EXP = DM_PLN_CFM_MKT_DEMAND_PLAN_C.DOM_EXP AND Z.V_FCST_TYPE = DM_PLN_CFM_MKT_DEMAND_PLAN_C.FCST_TYPE AND Z.V_INCOTERMS = DM_PLN_CFM_MKT_DEMAND_PLAN_C.INCOTERMS AND Z.V_MEASURE = DM_PLN_CFM_MKT_DEMAND_PLAN_C.MEASURE AND Z.V_PLANT_SITE_ID = DM_PLN_CFM_MKT_DEMAND_PLAN_C.PLANT_SITE_ID AND Z.V_CELL_PROD_SITE_ID = DM_PLN_CFM_MKT_DEMAND_PLAN_C.CELL_PROD_SITE_ID AND Z.V_YYYYMM = SUBSTR(DM_PLN_CFM_MKT_DEMAND_PLAN_C.YYYYMMDD,1,6));
        
        n_del_count := n_del_count + SQL%ROWCOUNT;
        
        INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN_C
        (DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
        SELECT A.DIVISION_ID, v_max_mf_w_version, 'MF_W', v_max_mf_w_yyyymmdd, A.PROJECT_CODE, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD, A.QTY, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, NULL, Z.V_FROM_SITE_ID, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
        FROM DM_PLN_SALES_PLAN A JOIN GT_F021_SALES_PLAN_INSERT Z ON A.DIVISION_ID = Z.V_DIVISION_ID AND A.PROJECT_CODE = Z.V_PROJECT_CODE AND A.SCM_SITE_ID = Z.V_SCM_SITE_ID AND A.ITEM_ID = Z.V_ITEM_ID AND A.DOM_EXP = Z.V_DOM_EXP AND A.FCST_TYPE = Z.V_FCST_TYPE AND A.INCOTERMS = Z.V_INCOTERMS AND A.MEASURE = Z.V_MEASURE AND A.PLANT_SITE_ID = Z.V_PLANT_SITE_ID AND A.CELL_PROD_SITE_ID = Z.V_CELL_PROD_SITE_ID AND SUBSTR(A.YYYYMMDD,1,6) = Z.V_YYYYMM
        WHERE A.DIVISION_ID = v_division_id_val AND A.MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_LOC','SalesAmt_USD','SalesAmt_KRW');
        
        n_insert_count := n_insert_count + SQL%ROWCOUNT;
        
        -- DELETE/INSERT DM_PLN_MKT_FCST_C (MF_W)
        DELETE FROM DM_PLN_MKT_FCST_C WHERE DIVISION_ID = v_division_id_val AND VERSION_NO = v_max_mf_w_version AND CUTOFF_TYPE = 'MF_W' AND MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP') AND EXISTS (SELECT 1 FROM GT_F021_SALES_PLAN_INSERT Z WHERE Z.V_DIVISION_ID = DM_PLN_MKT_FCST_C.DIVISION_ID AND Z.V_PROJECT_CODE = DM_PLN_MKT_FCST_C.PROJECT_CODE AND Z.V_SCM_SITE_ID = DM_PLN_MKT_FCST_C.SCM_SITE_ID AND Z.V_ITEM_ID = DM_PLN_MKT_FCST_C.ITEM_ID AND Z.V_DOM_EXP = DM_PLN_MKT_FCST_C.DOM_EXP AND Z.V_FCST_TYPE = DM_PLN_MKT_FCST_C.FCST_TYPE AND Z.V_INCOTERMS = DM_PLN_MKT_FCST_C.INCOTERMS AND Z.V_MEASURE = DM_PLN_MKT_FCST_C.MEASURE AND Z.V_PLANT_SITE_ID = DM_PLN_MKT_FCST_C.PLANT_SITE_ID AND Z.V_YYYYMM = SUBSTR(DM_PLN_MKT_FCST_C.YYYYMMDD,1,6));

        n_del_count := n_del_count + SQL%ROWCOUNT;
        
        INSERT INTO DM_PLN_MKT_FCST_C
        (DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        SELECT A.DIVISION_ID, v_max_mf_w_version, 'MF_W', v_max_mf_w_yyyymmdd, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, SUM(A.QTY), MAX(A.LAST_UPDATED_BY), MAX(A.LAST_UPDATE_DATE), MAX(A.LAST_UPDATED_BY), MAX(A.LAST_UPDATE_DATE)
        FROM DM_PLN_SALES_PLAN A JOIN GT_F021_SALES_PLAN_INSERT Z ON A.DIVISION_ID = Z.V_DIVISION_ID AND A.PROJECT_CODE = Z.V_PROJECT_CODE AND A.SCM_SITE_ID = Z.V_SCM_SITE_ID AND A.ITEM_ID = Z.V_ITEM_ID AND A.DOM_EXP = Z.V_DOM_EXP AND A.FCST_TYPE = Z.V_FCST_TYPE AND A.INCOTERMS = Z.V_INCOTERMS AND A.MEASURE = Z.V_MEASURE AND A.PLANT_SITE_ID = Z.V_PLANT_SITE_ID AND A.CELL_PROD_SITE_ID = Z.V_CELL_PROD_SITE_ID AND SUBSTR(A.YYYYMMDD,1,6) = Z.V_YYYYMM
        WHERE A.DIVISION_ID = v_division_id_val AND A.MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP')
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD;
        
        n_insert_count := n_insert_count + SQL%ROWCOUNT;
        
    END IF;

    -- SF_W VERSION (동일 패턴)
    SELECT MAX(VERSION_NO) INTO v_max_sf_w_version
    FROM   DM_MST_VERSION
    WHERE  DIVISION_ID  = v_division_id_val
    AND    VERSION_TYPE = 'SF_W'
    AND    YYYYMMDD    >= v_cutoff_start
    AND    YYYYMMDD     < v_cutoff_end;

    
    IF v_max_sf_w_version IS NOT NULL THEN
        SELECT YYYYMMDD INTO v_max_sf_w_yyyymmdd
        FROM   DM_MST_VERSION
        WHERE  DIVISION_ID  = v_division_id_val AND VERSION_NO = v_max_sf_w_version AND VERSION_TYPE = 'SF_W';

        DELETE FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C WHERE DIVISION_ID = v_division_id_val AND VERSION_NO = v_max_sf_w_version AND CUTOFF_TYPE = 'SF_W' AND MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_LOC','SalesAmt_USD','SalesAmt_KRW') AND EXISTS (SELECT 1 FROM GT_F021_SALES_PLAN_INSERT Z WHERE Z.V_DIVISION_ID = DM_PLN_CFM_MKT_DEMAND_PLAN_C.DIVISION_ID AND Z.V_PROJECT_CODE = DM_PLN_CFM_MKT_DEMAND_PLAN_C.PROJECT_CODE AND Z.V_SCM_SITE_ID = DM_PLN_CFM_MKT_DEMAND_PLAN_C.SCM_SITE_ID AND Z.V_ITEM_ID = DM_PLN_CFM_MKT_DEMAND_PLAN_C.ITEM_ID AND Z.V_DOM_EXP = DM_PLN_CFM_MKT_DEMAND_PLAN_C.DOM_EXP AND Z.V_FCST_TYPE = DM_PLN_CFM_MKT_DEMAND_PLAN_C.FCST_TYPE AND Z.V_INCOTERMS = DM_PLN_CFM_MKT_DEMAND_PLAN_C.INCOTERMS AND Z.V_MEASURE = DM_PLN_CFM_MKT_DEMAND_PLAN_C.MEASURE AND Z.V_PLANT_SITE_ID = DM_PLN_CFM_MKT_DEMAND_PLAN_C.PLANT_SITE_ID AND Z.V_CELL_PROD_SITE_ID = DM_PLN_CFM_MKT_DEMAND_PLAN_C.CELL_PROD_SITE_ID AND Z.V_YYYYMM = SUBSTR(DM_PLN_CFM_MKT_DEMAND_PLAN_C.YYYYMMDD,1,6));

        INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN_C
        (DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
        SELECT A.DIVISION_ID, v_max_sf_w_version, 'SF_W', v_max_sf_w_yyyymmdd, A.PROJECT_CODE, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD, A.QTY, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, NULL, Z.V_FROM_SITE_ID, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
        FROM DM_PLN_SALES_PLAN A JOIN GT_F021_SALES_PLAN_INSERT Z ON A.DIVISION_ID = Z.V_DIVISION_ID AND A.PROJECT_CODE = Z.V_PROJECT_CODE AND A.SCM_SITE_ID = Z.V_SCM_SITE_ID AND A.ITEM_ID = Z.V_ITEM_ID AND A.DOM_EXP = Z.V_DOM_EXP AND A.FCST_TYPE = Z.V_FCST_TYPE AND A.INCOTERMS = Z.V_INCOTERMS AND A.MEASURE = Z.V_MEASURE AND A.PLANT_SITE_ID = Z.V_PLANT_SITE_ID AND A.CELL_PROD_SITE_ID = Z.V_CELL_PROD_SITE_ID AND SUBSTR(A.YYYYMMDD,1,6) = Z.V_YYYYMM
        WHERE A.DIVISION_ID = v_division_id_val AND A.MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_LOC','SalesAmt_USD','SalesAmt_KRW');
        
        n_insert_count := n_insert_count + SQL%ROWCOUNT;
        
        DELETE FROM DM_PLN_MKT_FCST_C WHERE DIVISION_ID = v_division_id_val AND VERSION_NO = v_max_sf_w_version AND CUTOFF_TYPE = 'SF_W' AND MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP') AND EXISTS (SELECT 1 FROM GT_F021_SALES_PLAN_INSERT Z WHERE Z.V_DIVISION_ID = DM_PLN_MKT_FCST_C.DIVISION_ID AND Z.V_PROJECT_CODE = DM_PLN_MKT_FCST_C.PROJECT_CODE AND Z.V_SCM_SITE_ID = DM_PLN_MKT_FCST_C.SCM_SITE_ID AND Z.V_ITEM_ID = DM_PLN_MKT_FCST_C.ITEM_ID AND Z.V_DOM_EXP = DM_PLN_MKT_FCST_C.DOM_EXP AND Z.V_FCST_TYPE = DM_PLN_MKT_FCST_C.FCST_TYPE AND Z.V_INCOTERMS = DM_PLN_MKT_FCST_C.INCOTERMS AND Z.V_MEASURE = DM_PLN_MKT_FCST_C.MEASURE AND Z.V_PLANT_SITE_ID = DM_PLN_MKT_FCST_C.PLANT_SITE_ID AND Z.V_YYYYMM = SUBSTR(DM_PLN_MKT_FCST_C.YYYYMMDD,1,6));

        n_del_count := n_del_count + SQL%ROWCOUNT;

        INSERT INTO DM_PLN_MKT_FCST_C
        (DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        SELECT A.DIVISION_ID, v_max_sf_w_version, 'SF_W', v_max_sf_w_yyyymmdd, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, SUM(A.QTY), MAX(A.LAST_UPDATED_BY), MAX(A.LAST_UPDATE_DATE), MAX(A.LAST_UPDATED_BY), MAX(A.LAST_UPDATE_DATE)
        FROM DM_PLN_SALES_PLAN A JOIN GT_F021_SALES_PLAN_INSERT Z ON A.DIVISION_ID = Z.V_DIVISION_ID AND A.PROJECT_CODE = Z.V_PROJECT_CODE AND A.SCM_SITE_ID = Z.V_SCM_SITE_ID AND A.ITEM_ID = Z.V_ITEM_ID AND A.DOM_EXP = Z.V_DOM_EXP AND A.FCST_TYPE = Z.V_FCST_TYPE AND A.INCOTERMS = Z.V_INCOTERMS AND A.MEASURE = Z.V_MEASURE AND A.PLANT_SITE_ID = Z.V_PLANT_SITE_ID AND A.CELL_PROD_SITE_ID = Z.V_CELL_PROD_SITE_ID AND SUBSTR(A.YYYYMMDD,1,6) = Z.V_YYYYMM
        WHERE A.DIVISION_ID = v_division_id_val AND A.MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP')
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, 
        A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, 
        v_max_sf_w_version, 'SF_W', v_max_sf_w_yyyymmdd;

        n_insert_count := n_insert_count + SQL%ROWCOUNT;

    END IF;
    
    COMMIT;

    -- 종료 LOG
    v_log_type    := 'END';
    v_log_message := '########## END of procedure ##########';
    v_description := 'delete_count= ' || TO_CHAR(n_del_count) || ' / insert_count= ' || TO_CHAR(n_insert_count);
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;


    IF P_ACTIVE_FLAG = 'I' THEN
        n_event_count := n_insert_count;
    ELSIF P_ACTIVE_FLAG = 'D' THEN
        n_event_count := n_del_count; 
    END IF;

    OPEN O_RESULT_CURSOR FOR 
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(n_event_count) AS EVENT FROM DUAL;


    RETURN;

    --=============================================================================================================
    -- VALIDATION FAIL 처리
    --=============================================================================================================
    <<VALIDATION_FAIL>>
    ROLLBACK;
    v_log_message := V_S_CODE;
    v_description := V_S_CODE || '^' || V_S_VALIDATION;
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

    v_log_type    := 'END';
    v_log_message := '########## END of procedure ##########';
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;
        

    OPEN O_RESULT_CURSOR FOR
    SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_S_CODE || '^' || V_S_VALIDATION AS EVENT FROM DUAL;
    RETURN;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_DIVISION_ID' VALUE SUBSTR(P_DIVISION_ID,1,500),
            'P_CREATED_BY'  VALUE P_CREATED_BY
        );
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, 'ERROR', n_log_count, 'EXCEPTION',
                '', SYSDATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL;
/
