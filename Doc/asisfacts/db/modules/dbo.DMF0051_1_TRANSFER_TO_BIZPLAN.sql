/*
 * Program ID   : DMF0051_1_TRANSFER_TO_BIZPLAN
 * Description  : BIZPLAN 데이터 생성
 *                INPUT:DM_PLN_MKT_FCST_C(81,82),DM_PLN_BP_FCST_C(40),DM_MST_METAL_PRICE(METAL 판가)
 *                OUPUT:DM_PLN_BIZPLAN(MEASURE:Business_Plan,BizPlanPrice_Cur,BizPlanPrice_KRW,SalesAmt_CUR,SalesAmt_KRW)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023.08.19	chano0612		Initial Release 
 * 2023.09.23	chano0612		사업계획3차 수정[Cell Code칼럼에는 Cell Code만 지정] 40, 81, 82 사업부 SCP_MST_FINAL_ITEM , Cell Model
 * 2023.09.23	chano0612		사업계획3차 수정[Cell환산자 데이터 출처 변경] 40, 81, 82 사업부 SCP_MST_FINAL_ITEM ==>  40번 사업부 컬럼명 Cell Pack Count ATTRIBUTE8 에 적용, 81, 82번 사업부 컬럼명 CELL PER PACK 에 적용
 * 2023.09.23	chano0612		사업계획3차 수정[Application Gr.] 40 사업부 SCM_MST_SITE_ITEM REPORT_GROUP1 ==> ATTRIBUTE5 추가
 * 2023.09.24	chano0612		사업계획3차 수정[Product Gr.(Report)] 40 사업부 SCM_MST_SITE_ITEM REPORT_GROUP3 ==> ATTRIBUTE6 추가
 * 2023.09.24	chano0612		사업계획3차 수정[Product Details.(Report)] 40 사업부 SCM_MST_SITE_ITEM REPORT_GROUP4 ==> ATTRIBUTE7 추가
 * 2023.09.24	chano0612		사업계획3차 수정[Cell/Pack Biz 정보 누락] BIZ_TYPE
 * 2023.09.28	chano0612		사업계획3차 수정[BASE/METAL/OTHERS 가 NULL일때] 40 사업부 BP_FCST_C 의 LOC 값을 BASE, TOTAL에 적용
 * 2023.09.28	chano0612		사업계획3차 수정[BASE/METAL/OTHERS 가 NULL일때] 40 사업부 BP_FCST_C 의 LOC 값과 TOTAL_PRICE_CUR 값이 다른경우 차이를 절대값으로 OHTER_PRICE에 적용
 * 2023.10.03	chano0612		사업계획3차 수정[판가MEASURE 변경]
 * 2024.01.25	KCW3408   		사업계획수정[날짜 하드코딩을 수정,METAL_LINK_YN:자동차, ESS 사업부: Biz Plan Price(Master)의 'Metal Link'칼럼 값 → METAL_LINK_YN에 동일 반영
 *                                                                              소형 사업부: Default = N, Biz Plan Price(Master)의 'Metal Link'칼럼 값 있는 경우 → METAL_LINK_YN에 동일 반영
 * 2024/08/29	KJJ				[PJ2024-50461] Team Mapping
 **************************************************************************************************
 */
 
-- EXEC DMF0051_1_TRANSFER_TO_BIZPLAN '81', 'MF_W_20230912_V001', '', '', 'ALL', 'ALL', 'ALL', 'ALL', ''
-- EXEC DMF0051_1_TRANSFER_TO_BIZPLAN '81_UC', 'MF_W_20230912_V001', '', '', 'ALL', 'ALL', 'ALL', 'ALL', ''
-- EXEC DMF0051_1_TRANSFER_TO_BIZPLAN '81_HM', 'MF_W_20230912_V001', '', '', 'ALL', 'ALL', 'ALL', 'ALL', ''
-- EXEC DMF0051_1_TRANSFER_TO_BIZPLAN '82', 'MF_W_20230912_V001', '', '', 'ALL', 'ALL', 'ALL', 'ALL', ''
-- EXEC DMF0051_1_TRANSFER_TO_BIZPLAN '40', 'BP_M_20231006_V001', '', '', 'ALL', 'ALL', 'ALL', 'ALL', ''

CREATE PROCEDURE [dbo].[DMF0051_1_TRANSFER_TO_BIZPLAN]
     @p_division_id              NVARCHAR(30),
	 @p_version_id				 NVARCHAR(30),
	 @p_item_id					 NVARCHAR(30),
	 @p_project_code			 NVARCHAR(30),
	 @p_scm_site_id				 NVARCHAR(30),
	 @p_customer				 NVARCHAR(30),
	 @p_item_type				 NVARCHAR(30),
	 @p_biz_type				 NVARCHAR(30),
	 @p_owner					 NVARCHAR(30)
AS
  
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
	        
    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DMF0051_1_TRANSFER_TO_BIZPLAN';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date DATETIME;
    DECLARE @n_del_count    INTEGER = 0;
    DECLARE @n_insert_count    INTEGER = 0;
	DECLARE @v_from_yyyymmdd NVARCHAR(08);
	DECLARE @v_to_yyyymmdd   NVARCHAR(08);
	DECLARE @v_yyyymmdd      NVARCHAR(08);

	DECLARE @i INT
	DECLARE @s INT
	DECLARE @CNT INT

	DECLARE @v_BP_CUTOFF_VERSION NVARCHAR(30);
    -- SEQUENCE
    DECLARE @n_history_seq      INTEGER;

	IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_V', N'U') IS NOT NULL 	DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_V
	IF OBJECT_ID (N'tempdb..#TEMP_SITE_ITEMAll', N'U') IS NOT NULL 		    DROP TABLE #TEMP_SITE_ITEMAll
	IF OBJECT_ID (N'tempdb..#TEMP_SITE_ITEM', N'U') IS NOT NULL 			DROP TABLE #TEMP_SITE_ITEM
		
	IF OBJECT_ID (N'tempdb..#TMP_PLN_BIZPLAN', N'U') IS NOT NULL			DROP TABLE #TMP_PLN_BIZPLAN
	IF OBJECT_ID (N'tempdb..#TMP_DM_PLN_BIZPLAN', N'U') IS NOT NULL			DROP TABLE #TMP_DM_PLN_BIZPLAN

	IF OBJECT_ID (N'tempdb..#TMP_PLN_BIZPLAN_40', N'U') IS NOT NULL			DROP TABLE #TMP_PLN_BIZPLAN_40
	IF OBJECT_ID (N'tempdb..#TMP_DM_PLN_BIZPLAN_40', N'U') IS NOT NULL		DROP TABLE #TMP_DM_PLN_BIZPLAN_40

	IF OBJECT_ID (N'tempdb..#TMP_PRICE', N'U') IS NOT NULL 			DROP TABLE #TMP_PRICE
	IF OBJECT_ID (N'tempdb..#TMP_PRICE_S', N'U') IS NOT NULL 			DROP TABLE #TMP_PRICE_S
	
	CREATE TABLE #TEMP_SITE_ITEMAll
	(
	DIVISION_ID nvarchar(10)
	, project_code nvarchar(100)
	, scm_site_id nvarchar(100)
	, item_id nvarchar(100)
	, nick_name nvarchar(100)
	, project_name nvarchar(100)
	, CELL_CODE nvarchar(100)
	, BIZ_TYPE nvarchar(100)
	, END_CUSTOMER nvarchar(100)
	, SOLDTO_CUSTOMER nvarchar(100)
	, COUNTRY nvarchar(100)
	, COUNTRY_NAME nvarchar(100)
	, CITY nvarchar(100)
	, CITY_NAME nvarchar(100)
	, OWNER nvarchar(100)
	, PROJECT_OWNER nvarchar(100)
	, USER_ID nvarchar(100)
	, ITEM_NAME nvarchar(100)
	, ITEM_TYPE nvarchar(100)
	, PROJECT_STATUS nvarchar(100)
	, CUST_GROUP nvarchar(100)
	, CUST_GROUP_DTL nvarchar(100)
	, APPLICATION nvarchar(100)
	, ROUTE nvarchar(100)
	, MDM_PROJECT_NAME nvarchar(100)
	, MIN_CAPACITY nvarchar(100)
	, FORECAST_INFO_BIZ_TYPE nvarchar(100)
	, FORECAST_INFO_PRODUCT_GROUP nvarchar(100)
	, CELL_TYPE nvarchar(100)
	, FORECAST_INFO_CELL_PACK_COUNT numeric(20,10)  --[C20200702-000136] FORECAST_INFO_CELL_PACK_COUNT 은 numeric type
	, FORECAST_INFO_ALL nvarchar(100)
	, FORECAST_INFO_SPEC nvarchar(100)
	, FORECAST_INFOR_VERSION nvarchar(100)
	, CELL_MODEL_NICK_NAME nvarchar(100)
	, VMI_YN nvarchar(100)
	, DMS_SALES nvarchar(100)
	, DMS_CUSTOMER nvarchar(100)
	, DEPT_ID nvarchar(100)
	, DEPT_NAME_KO nvarchar(100)
	, CELL_PER_CAR numeric
	, CELL_PER_MODULE numeric
	, MODULE_PER_CAR numeric
	, ITEM_CLASS_NAME nvarchar(100)
	, ENERGE nvarchar(100)
	, CELL_QUANTITY nvarchar(100)
	, ITEM_VALID_YN		NVARCHAR(1)
	, PRODUCT_GROUP_CODE NVARCHAR(100)
	, PRODUCT_GROUP_NAME NVARCHAR(100)
	, REPORT_GROUP1 NVARCHAR(100)
	, REPORT_GROUP2 NVARCHAR(100)
	, REPORT_GROUP3 NVARCHAR(100)
	, REPORT_GROUP4 NVARCHAR(100)
	)

	CREATE TABLE #TMP_DM_PLN_BIZPLAN
		(
		SEQ         INT,
		DIVISION_ID NVARCHAR(30),
		DEPT_ID NVARCHAR(20),
		PROJECT_CODE NVARCHAR(50),
		SCM_SITE_ID NVARCHAR(30),
		ITEM_ID NVARCHAR(50),
		END_CUSTOMER NVARCHAR(50),
		BIZ_TYPE NVARCHAR(30),
		PLANT_SITE_ID NVARCHAR(50),
		FCST_TYPE NVARCHAR(20),
		DOM_EXP NVARCHAR(2),
		INCOTERMS NVARCHAR(4),
		ITEM_USE NVARCHAR(10),
		UNIT_ENERGY NUMERIC(30, 10),
		CURRENCY NVARCHAR(10),
		MEASURE NVARCHAR(50),
		YYYYMM NVARCHAR(6),
		QTY NUMERIC(30, 10),
		PROJECT_NAME NVARCHAR(50),
		CELL_PROD_SITE NVARCHAR(30),
		EE_CORP_ID NVARCHAR(30),
		CELL_CORP_ID NVARCHAR(30),
		PACK_CORP_ID NVARCHAR(30),
		EXT_INT NVARCHAR(6),
		PRODUCT_GROUP NVARCHAR(30),
		ALT_SIM_YN NVARCHAR(1),
		CELL_CODE NVARCHAR(50),
		CELL_PER_MODULE NUMERIC(20, 10),
		MODULE_PER_PACK NUMERIC(30, 10),
		CELL_PER_PACK NUMERIC(30, 10),
		PERIOD_YYMM NVARCHAR(6),
		SCENARIO_TYPE NVARCHAR(4),
		BASE_PRICE NUMERIC(30, 10),
		METAL_LINK_PRICE NUMERIC(30, 10),
		METAL_LINK_YN NVARCHAR(1),
		WORK_YYYYMMDD NVARCHAR(8),
		OSP_YN NVARCHAR(1),
		CREATED_BY NVARCHAR(150),
		CREATION_DATE DATETIME,
		LAST_UPDATED_BY NVARCHAR(150),
		LAST_UPDATE_DATE DATETIME
	)


	CREATE TABLE #TMP_DM_PLN_BIZPLAN_40
		(
		SEQ         INT,
		DIVISION_ID NVARCHAR(30),
		DEPT_ID NVARCHAR(20),
		PROJECT_CODE NVARCHAR(50),
		SCM_SITE_ID NVARCHAR(30),
		ITEM_ID NVARCHAR(50),
		END_CUSTOMER NVARCHAR(50),
		BIZ_TYPE NVARCHAR(30),
		PLANT_SITE_ID NVARCHAR(50),
		FCST_TYPE NVARCHAR(20),
		DOM_EXP NVARCHAR(2),
		INCOTERMS NVARCHAR(4),
		ITEM_USE NVARCHAR(10),
		UNIT_ENERGY NUMERIC(30, 10),
		CURRENCY NVARCHAR(10),
		MEASURE NVARCHAR(50),
		YYYYMM NVARCHAR(6),
		QTY NUMERIC(30, 10),
		PROJECT_NAME NVARCHAR(50),
		CELL_PROD_SITE NVARCHAR(30),
		EE_CORP_ID NVARCHAR(30),
		CELL_CORP_ID NVARCHAR(30),
		PACK_CORP_ID NVARCHAR(30),
		EXT_INT NVARCHAR(6),
		PRODUCT_GROUP NVARCHAR(30),
		ALT_SIM_YN NVARCHAR(1),
		CELL_CODE NVARCHAR(50),
		CELL_PER_MODULE NUMERIC(20, 10),
		MODULE_PER_PACK NUMERIC(30, 10),
		CELL_PER_PACK NUMERIC(30, 10),
		PERIOD_YYMM NVARCHAR(6),
		SCENARIO_TYPE NVARCHAR(4),
		BASE_PRICE NUMERIC(30, 10),
		METAL_LINK_PRICE NUMERIC(30, 10),
		METAL_LINK_YN NVARCHAR(1),
		WORK_YYYYMMDD NVARCHAR(8),
		OSP_YN NVARCHAR(1),
		CREATED_BY NVARCHAR(150),
		CREATION_DATE DATETIME,
		LAST_UPDATED_BY NVARCHAR(150),
		LAST_UPDATE_DATE DATETIME
	)

	CREATE TABLE #TMP_PRICE_S
	(
		DIVISION_ID NVARCHAR(30),
		PROJECT_CODE NVARCHAR(30),
		SCM_SITE_ID NVARCHAR(30),
		ITEM_ID NVARCHAR(30),
		CELL_PROD_SITE NVARCHAR(30),
		YYYYMM NVARCHAR(30),
		CURRENCY NVARCHAR(30),
		BASE_PRICE  NUMERIC(30,10),
		METAL_LINK_PRICE  NUMERIC(30,10),
		OTHER_PRICE  NUMERIC(30,10),
		TOTAL_PRICE  NUMERIC(30,10)
	)

	CREATE TABLE #TMP_PRICE
	(
		DIVISION_ID NVARCHAR(30),
		PROJECT_CODE NVARCHAR(30),
		SCM_SITE_ID NVARCHAR(30),
		ITEM_ID NVARCHAR(30),
		CELL_PROD_SITE NVARCHAR(30),
		YYYYMM NVARCHAR(30),
		CURRENCY NVARCHAR(30),
		BASE_PRICE  NUMERIC(30,10),
		METAL_LINK_PRICE  NUMERIC(30,10),
		OTHER_PRICE  NUMERIC(30,10),
		TOTAL_PRICE  NUMERIC(30,10)
	)
	   
    -- 시작 LOG  (START)
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_division_id;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
    -- 시작 LOG  (END)

    -- 트랜잭션 (START)
    BEGIN TRANSACTION SAVE_DM_PLN_BP_FCST;

    BEGIN TRY
	
	/* 2024.01.25	KCW3408   		사업계획수정[날짜 하드코딩을 수정] */
	BEGIN 
	    -- 테이블중복제거
    	IF OBJECT_ID(N'tempdb..#TEMP_SCM_SYS_CALENDAR_M', N'U') IS NOT NULL
	    	DROP TABLE #TEMP_SCM_SYS_CALENDAR_M

     	-- 임시확인용테이블 중복제거
    	IF OBJECT_ID(N'dbo.#TEMP_SCM_SYS_CALENDAR_M', N'U') IS NOT NULL
		   DROP TABLE #TEMP_SCM_SYS_CALENDAR_M

		SET @v_yyyymmdd = CONVERT(CHAR(8), SUBSTRING(@p_version_id, 6, 8) ,  112)   
		SET @v_from_yyyymmdd = CONVERT(CHAR(8), SUBSTRING(CONVERT(NVARCHAR,DATEADD(YY, 1, @v_yyyymmdd), 112), 1, 4) + '0101',  112)
		SET @v_to_yyyymmdd = CONVERT(CHAR(8), SUBSTRING(CONVERT(NVARCHAR,DATEADD(YY, 1, @v_yyyymmdd), 112), 1, 4) + '1231',  112)
	 
		SELECT DISTINCT BASIS_YYYYMM 
		INTO #TEMP_SCM_SYS_CALENDAR_M
		FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
		WHERE  A.basis_yyyymmdd >= @v_from_yyyymmdd
		AND    A.basis_yyyymmdd <= @v_to_yyyymmdd  
		
	END
	
	
	-- 자재정보를 취합하기 위해 임시테이블 #TEMP_DM_MST_ITEM_SINGLE_V에 저장한다.
	SELECT DIVISION_ID,ITEM_ID,ITEM_NAME,ITEM_CLASS,ITEM_CLASS_NAME,NICK_NAME,ITEM_TYPE,MDM_PROJECT_NAME,MIN_CAPACITY,FORECAST_INFO_BIZ_TYPE,FORECAST_INFO_PRODUCT_GROUP
		,FORECAST_INFO_CELL_MODEL,FORECAST_INFO_CELL_PACK_COUNT,FORECAST_INFO_SPEC,FORECAST_INFOR_VERSION,CELL_TYPE,ENERGE, CELL_QUANTITY 
	INTO #TEMP_DM_MST_ITEM_SINGLE_V
	FROM DM_MST_ITEM_SINGLE_V T2 WITH(NOLOCK)
	INNER JOIN ( SELECT DISTINCT '%'+token+'%' tst FROM dbo.String_Split(@p_item_id,',') ) b
							ON	T2.ITEM_ID		like  b.tst 
							OR	T2.NICK_NAME	like  b.tst 					
	WHERE DIVISION_ID = @p_division_id					
	GROUP BY DIVISION_ID,ITEM_ID,ITEM_NAME,ITEM_CLASS,ITEM_CLASS_NAME,NICK_NAME,ITEM_TYPE,MDM_PROJECT_NAME,MIN_CAPACITY,FORECAST_INFO_BIZ_TYPE,FORECAST_INFO_PRODUCT_GROUP
			,FORECAST_INFO_CELL_MODEL,FORECAST_INFO_CELL_PACK_COUNT,FORECAST_INFO_SPEC,FORECAST_INFOR_VERSION,CELL_TYPE,ENERGE, CELL_QUANTITY
	 
				  

	-- 사업부별로 고객사(SITE), 자재 정보를 취합하기 위해 임시테이블 #TEMP_SITE_ITEMAll에 저장한다.
	IF (@p_division_id LIKE '81%')
	BEGIN
		INSERT INTO #TEMP_SITE_ITEMAll
				SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.ITEM_ID, T2.NICK_NAME, T3.PROJECT_NAME
						--사업계획3차 수정[Cell Code칼럼에는 Cell Code만 지정] 81, 82 사업부 SCP_MST_FINAL_ITEM [START]
						--, F.ATTRIBUTE5 CELL_CODE 
						, ISNULL(T5.ATTRIBUTE1, '') CELL_CODE 
						--사업계획3차 수정[Cell Code칼럼에는 Cell Code만 지정] 81, 82 사업부 SCP_MST_FINAL_ITEM [END]
						--사업계획3차 수정[Cell/Pack Biz 정보 누락] [START]
						, T3.BIZ_TYPE
						--, CASE WHEN SUBSTRING(F.ITEM_ID, 1, 2) = 'AB' THEN 'BMS' 
						--  WHEN SUBSTRING(F.ITEM_ID, 1, 2) = 'AC' THEN 'Cell' 
						--  WHEN SUBSTRING(F.ITEM_ID, 1, 2) = 'AM' THEN 'Module'
						--  WHEN SUBSTRING(F.ITEM_ID, 1, 2) = 'AP' THEN 'Pack'
						--  ELSE 'ETC'
						--  END BIZ_TYPE
						--사업계획3차 수정[Cell/Pack Biz 정보 누락] [END]
						, S.END_CUSTOMER
						, S.SOLDTO_CUSTOMER
						, i.COUNTRY	
						, i.COUNTRY_NAME	  
						, h.CITY
						, h.CITY_NAME	  
						--20180809 ytchoi modify(s)
						-- modify by ytchoi 180913
						,( SELECT distinct  STUFF(( SELECT ',' + user_name_en FROM (select za.user_name_en  from SCM_MST_SSO_USER_INFO za WITH(NOLOCK)   ,( SELECT token FROM dbo.String_Split(F.OWNER,',') ) zb where za.user_id = zb.token ) xb  FOR XML PATH('') ),1,1,'') AS NAME FROM (select za.user_name_en  from SCM_MST_SSO_USER_INFO za  WITH(NOLOCK) ,( SELECT token FROM dbo.String_Split(F.OWNER,',') ) zb where za.user_id = zb.token) xa ) AS OWNER
						, CASE WHEN F.division_id NOT IN ('40') THEN T3.PROJECT_OWNER ELSE j.USER_NAME_EN end AS PROJECT_OWNER -- 20180705  --20190123 KHSONG 전지재료DIV설정
						, J.USER_ID
						--20180809 ytchoi modify(e)
						, T2.ITEM_NAME       
						, T2.ITEM_TYPE 
						, T3.PROJECT_STATUS 
						, F.CUST_GROUP
						, F.CUST_GROUP_DTL
						, F.APPLICATION
						, F.ROUTE
						, T2.MDM_PROJECT_NAME  
						, T2.MIN_CAPACITY
						, T2.FORECAST_INFO_BIZ_TYPE
	  					, T2.FORECAST_INFO_PRODUCT_GROUP
						, LOOK.NAME AS CELL_TYPE --20180911 LookUp ??? ???? CELL_TYPE ??
						, T2.FORECAST_INFO_CELL_PACK_COUNT
						, T2.FORECAST_INFO_SPEC+T2.FORECAST_INFOR_VERSION	as FORECAST_INFO_ALL
						, T2.FORECAST_INFO_SPEC								as FORECAST_INFO_SPEC
						, T2.FORECAST_INFOR_VERSION							as FORECAST_INFOR_VERSION
						, ISNULL(T4.NICK_NAME,'') AS CELL_MODEL_NICK_NAME  --20190419 KHSONG [CSR ID:3969101] GSCM Cell Model컬럼에 대한 Cell Model Nickname 컬럼 추가
						, S.VMI_YN  -- 20180719
						, ISNULL(F.attribute1,'') DMS_SALES     -- 20190213 KHSONG [CSR ID:3912438] 고객군, 판매처 컬럼 정규화 요청의 건 --20190322 KHSONG 고객군, 판매처 컬럼 NULL처리조건 추가
						, ISNULL(F.attribute2,'') DMS_CUSTOMER  -- 20190213 KHSONG [CSR ID:3912438] 고객군, 판매처 컬럼 정규화 요청의 건 --20190322 KHSONG 고객군, 판매처 컬럼 NULL처리조건 추가

						--[PJ2024-50461] Team Mapping------------------------------------
						--, CASE WHEN F.DIVISION_ID IN ('40') THEN TEAM.DEPT_ID ELSE k.DEPT_ID END AS DEPT_ID		-- 20180809  --20190123 KHSONG 전지재료DIV설정
						--, CASE WHEN F.DIVISION_ID IN ('40') THEN TEAM.DEPT_NAME_KO ELSE k.DEPT_NAME_KO END AS DEPT_NAME_KO	-- 20180809  --20190123 KHSONG 전지재료DIV설정
						, TEAM.DEPT_ID
						, TEAM.DEPT_NAME_KO
						--[PJ2024-50461] Team Mapping------------------------------------


						--사업계획3차 수정[Cell환산자 데이터 출처 변경] 40, 81, 82 사업부 SCP_MST_FINAL_ITEM [START]
						--, F.CELL_PER_CAR
						, T5.CELL_CF
						--사업계획3차 수정[Cell환산자 데이터 출처 변경] 40, 81, 82 사업부 SCP_MST_FINAL_ITEM [END]
						, F.CELL_PER_MODULE
						, F.CELL_PER_CAR / IIF(ISNULL(F.CELL_PER_MODULE, 0) = 0, 1, F.CELL_PER_MODULE) AS MODULE_PER_CAR  -- 20190705 KHSONG [CSR ID:4023158]
						,T2.ITEM_CLASS_NAME  -- 20190705 KHSONG [CSR ID:4023158] measure추가를 위한 컬럼추가
						,T2.ENERGE
						,T2.CELL_QUANTITY
						,F.VALID_YN
						,T3.PRODUCT_GROUP_CODE
						,T3.PRODUCT_GROUP_NAME
						,F.REPORT_GROUP1
						,F.REPORT_GROUP2
						,F.REPORT_GROUP3
						,F.REPORT_GROUP4
					FROM SCM_MST_SITE_ITEM F WITH(NOLOCK)
					INNER JOIN 	#TEMP_DM_MST_ITEM_SINGLE_V	T2  WITH(NOLOCK)
							ON	F.DIVISION_ID    = T2.DIVISION_ID
							AND	F.ITEM_ID        = T2.ITEM_ID
					INNER JOIN 	SCM_MST_PROJECT	T3  WITH(NOLOCK)
							ON	F.DIVISION_ID    = T3.DIVISION_ID
							AND	F.PROJECT_CODE   = T3.PROJECT_CODE						
					INNER JOIN ( SELECT DISTINCT '%'+token+'%' tst FROM dbo.String_Split(@p_item_id,',') ) b  -- 20190118 KHSONG 중복제거위한 DISTINCT추가
							ON      F.ITEM_ID  like  b.tst 
							OR      T2.NICK_NAME  like  b.tst 
					INNER JOIN ( SELECT DISTINCT '%'+token+'%' tst FROM dbo.String_Split(@p_project_code,',') ) c  -- 20190118 KHSONG 중복제거위한 DISTINCT추가
							ON      F.project_code  like  c.tst 
							OR      T3.project_name like  c.tst 
					--20180809 ytchoi added
					INNER JOIN 	SCM_MST_SITE	s  WITH(NOLOCK)
							ON	F.DIVISION_ID    = s.DIVISION_ID
							AND	F.SCM_SITE_ID    = s.SCM_SITE_ID
							AND S.SITE_TYPE		= 'SALES'
							--AND S.VALID_YN		= 'Y'
					INNER JOIN [dbo].SCM_MST_CITY h WITH(NOLOCK)
							ON  S.CITY           = h.CITY
					INNER JOIN [dbo].[SCM_MST_COUNTRY] i WITH(NOLOCK)
							ON  S.COUNTRY        = i.COUNTRY

					-- 20180809 ADDED  -----------------
					LEFT JOIN (
								SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO 
									FROM [SCM_MST_SSO_USER_INFO] AS B WITH(NOLOCK)
										INNER JOIN SCM_MST_SSO_DEPT_INFO AS C WITH(NOLOCK)
											ON B.DEPT_ID = C.DEPT_ID
							) AS TEAM

							ON  TEAM.USER_ID   IN (SELECT top 1 token FROM [dbo].[String_Split](F.owner, ','))
					-- 20180809 ADDED  -----------------
 
					LEFT JOIN [dbo].[SCM_MST_SSO_USER_INFO] j WITH(NOLOCK)
							ON  substring( F.OWNER, 0, case when charindex(',',F.OWNER) = 0 then len(F.OWNER)+1 else charindex(',',F.OWNER) end ) = j.USER_ID -- 20180816 modified by ytchoi
					LEFT JOIN [dbo].[SCM_MST_SSO_DEPT_INFO] k WITH(NOLOCK)
					--[PJ2024-50461] Team Mapping------------------------------------
							--ON  CASE WHEN T3.DIVISION_ID IN ('40') THEN j.DEPT_ID ELSE S.DEPT_ID END  = k.DEPT_ID  --20190123 KHSONG 전지재료DIV설정
							ON  j.DEPT_ID = k.DEPT_ID
					--[PJ2024-50461] Team Mapping------------------------------------
					LEFT JOIN ( --20180911 LookUp TABLE JOIN
							SELECT SEGMENT1  AS CODE       
									, SEGMENT2  AS NAME
							FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
							WHERE LOOKUP_TYPE = 'CELL_TYPE' 
							) LOOK
						ON LOOK.CODE = T2.CELL_TYPE
					--20180809 ytchoi added

					--20190419 KHSONG [CSR ID:3969101] GSCM Cell Model컬럼에 대한 Cell Model Nickname 컬럼 추가
					LEFT JOIN 	#TEMP_DM_MST_ITEM_SINGLE_V	T4  WITH(NOLOCK)
							ON	T2.DIVISION_ID    = T4.DIVISION_ID
							AND	ISNULL(T2.FORECAST_INFO_CELL_MODEL,'')        = T4.ITEM_ID
					--사업계획3차 수정 81, 82 사업부 SCP_MST_FINAL_ITEM [START]
					LEFT JOIN SCP_MST_FINAL_ITEM T5 WITH(NOLOCK)
							ON F.DIVISION_ID = T5.DIVISION_ID
							AND F.ITEM_ID = T5.ITEM_ID
					--사업계획3차 수정 81, 82 사업부 SCP_MST_FINAL_ITEM [END]
					
 				where f.division_id <> '40' -- hard coding  --20190123 KHSONG 전지재료DIV설정
				AND    CASE WHEN @p_scm_site_id = 'ALL' THEN @p_scm_site_id			
							ELSE f.scm_site_id
 						END  IN ( SELECT token FROM dbo.String_Split(@p_scm_site_id,',') )
				AND    CASE WHEN @p_customer = 'ALL' THEN @p_customer			
							ELSE S.END_CUSTOMER
 						END  IN ( SELECT token FROM dbo.String_Split(@p_customer,',') )
				AND    CASE WHEN @p_item_type = 'ALL' THEN @p_item_type			
							ELSE T2.ITEM_TYPE
 						END  IN ( SELECT token FROM dbo.String_Split(@p_item_type,',') )
				AND    CASE WHEN @p_biz_type = 'ALL' THEN @p_biz_type			
							ELSE T3.BIZ_TYPE
 						END  IN ( SELECT token FROM dbo.String_Split(@p_biz_type,',') )
				AND    CASE WHEN @p_owner = '' THEN @p_owner			
							ELSE F.OWNER
 						END  IN ( SELECT token FROM dbo.String_Split(@p_owner,',') )
 				   
	END
	ELSE IF (@p_division_id = '82')-- 82번 사업부
	BEGIN
		INSERT INTO #TEMP_SITE_ITEMAll
				SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.ITEM_ID, T2.NICK_NAME, T3.PROJECT_NAME
						--사업계획3차 수정[Cell Code칼럼에는 Cell Code만 지정] 81, 82 사업부 SCP_MST_FINAL_ITEM [START]
						--, F.ATTRIBUTE5 CELL_CODE 
						, ISNULL(T5.ATTRIBUTE1, '') CELL_CODE 
						--사업계획3차 수정[Cell Code칼럼에는 Cell Code만 지정] 81, 82 사업부 SCP_MST_FINAL_ITEM [END]
						, T3.BIZ_TYPE
						--, CASE WHEN SUBSTRING(F.ITEM_ID, 1, 2) = 'EB' THEN 'BMS' 
						--  WHEN SUBSTRING(F.ITEM_ID, 1, 2) = 'EC' OR SUBSTRING(F.ITEM_ID, 1, 2) = 'ES' THEN 'Cell' 
						--  WHEN SUBSTRING(F.ITEM_ID, 1, 2) = 'EM' THEN 'Module'
						--  WHEN SUBSTRING(F.ITEM_ID, 1, 2) = 'EP' THEN 'Pack'
						--  WHEN SUBSTRING(F.ITEM_ID, 1, 2) = 'ER' THEN 'Rack'
						--  WHEN SUBSTRING(F.ITEM_ID, 1, 2) = 'EH' THEN 'House'
						--  WHEN SUBSTRING(F.ITEM_ID, 1, 2) = 'EU' THEN 'BCU'
						--  WHEN SUBSTRING(F.ITEM_ID, 1, 2) = 'ET' THEN 'Total Solution'
						--  ELSE 'ETC'
						--  END BIZ_TYPE
						--사업계획3차 수정[Cell/Pack Biz 정보 누락] [END]
						, S.END_CUSTOMER
						, S.SOLDTO_CUSTOMER
						, i.COUNTRY	
						, i.COUNTRY_NAME	  
						, h.CITY
						, h.CITY_NAME	  
						--20180809 ytchoi modify(s)
						-- modify by ytchoi 180913
						,( SELECT distinct  STUFF(( SELECT ',' + user_name_en FROM (select za.user_name_en  from SCM_MST_SSO_USER_INFO za WITH(NOLOCK)   ,( SELECT token FROM dbo.String_Split(F.OWNER,',') ) zb where za.user_id = zb.token ) xb  FOR XML PATH('') ),1,1,'') AS NAME FROM (select za.user_name_en  from SCM_MST_SSO_USER_INFO za  WITH(NOLOCK) ,( SELECT token FROM dbo.String_Split(F.OWNER,',') ) zb where za.user_id = zb.token) xa ) AS OWNER
						, CASE WHEN F.division_id NOT IN ('40') THEN T3.PROJECT_OWNER ELSE j.USER_NAME_EN end AS PROJECT_OWNER -- 20180705  --20190123 KHSONG 전지재료DIV설정
						, J.USER_ID
						--20180809 ytchoi modify(e)
						, T2.ITEM_NAME       
						, T2.ITEM_TYPE 
						, T3.PROJECT_STATUS 
						, F.CUST_GROUP
						, F.CUST_GROUP_DTL
						, F.APPLICATION
						, F.ROUTE
						, T2.MDM_PROJECT_NAME  
						, T2.MIN_CAPACITY
						, T2.FORECAST_INFO_BIZ_TYPE
	  					, T2.FORECAST_INFO_PRODUCT_GROUP
						, LOOK.NAME AS CELL_TYPE --20180911 LookUp ??? ???? CELL_TYPE ??
						, T2.FORECAST_INFO_CELL_PACK_COUNT
						, T2.FORECAST_INFO_SPEC+T2.FORECAST_INFOR_VERSION	as FORECAST_INFO_ALL
						, T2.FORECAST_INFO_SPEC								as FORECAST_INFO_SPEC
						, T2.FORECAST_INFOR_VERSION							as FORECAST_INFOR_VERSION
						, ISNULL(T4.NICK_NAME,'') AS CELL_MODEL_NICK_NAME  --20190419 KHSONG [CSR ID:3969101] GSCM Cell Model컬럼에 대한 Cell Model Nickname 컬럼 추가
						, S.VMI_YN  -- 20180719
						, ISNULL(F.attribute1,'') DMS_SALES     -- 20190213 KHSONG [CSR ID:3912438] 고객군, 판매처 컬럼 정규화 요청의 건 --20190322 KHSONG 고객군, 판매처 컬럼 NULL처리조건 추가
						, ISNULL(F.attribute2,'') DMS_CUSTOMER  -- 20190213 KHSONG [CSR ID:3912438] 고객군, 판매처 컬럼 정규화 요청의 건 --20190322 KHSONG 고객군, 판매처 컬럼 NULL처리조건 추가

						--[PJ2024-50461] Team Mapping------------------------------------
						--, CASE WHEN F.DIVISION_ID IN ('40') THEN TEAM.DEPT_ID ELSE k.DEPT_ID END AS DEPT_ID		-- 20180809  --20190123 KHSONG 전지재료DIV설정
						--, CASE WHEN F.DIVISION_ID IN ('40') THEN TEAM.DEPT_NAME_KO ELSE k.DEPT_NAME_KO END AS DEPT_NAME_KO	-- 20180809  --20190123 KHSONG 전지재료DIV설정
						, TEAM.DEPT_ID
						, TEAM.DEPT_NAME_KO
						--[PJ2024-50461] Team Mapping------------------------------------

						--사업계획3차 수정[Cell환산자 데이터 출처 변경] 40, 81, 82 사업부 SCP_MST_FINAL_ITEM [START]
						--, F.CELL_PER_CAR
						, T5.CELL_CF
						--사업계획3차 수정[Cell환산자 데이터 출처 변경] 40, 81, 82 사업부 SCP_MST_FINAL_ITEM [END]
						, F.CELL_PER_MODULE
						, F.CELL_PER_CAR / IIF(ISNULL(F.CELL_PER_MODULE, 0) = 0, 1, F.CELL_PER_MODULE) AS MODULE_PER_CAR  -- 20190705 KHSONG [CSR ID:4023158]
						,T2.ITEM_CLASS_NAME  -- 20190705 KHSONG [CSR ID:4023158] measure추가를 위한 컬럼추가
						,T2.ENERGE
						,T2.CELL_QUANTITY
						,F.VALID_YN
						,T3.PRODUCT_GROUP_CODE
						,T3.PRODUCT_GROUP_NAME
						,F.REPORT_GROUP1
						,F.REPORT_GROUP2
						,F.REPORT_GROUP3
						,F.REPORT_GROUP4
					FROM SCM_MST_SITE_ITEM F WITH(NOLOCK)
					INNER JOIN 	#TEMP_DM_MST_ITEM_SINGLE_V	T2  WITH(NOLOCK)
							ON	F.DIVISION_ID    = T2.DIVISION_ID
							AND	F.ITEM_ID        = T2.ITEM_ID
					INNER JOIN 	SCM_MST_PROJECT	T3  WITH(NOLOCK)
							ON	F.DIVISION_ID    = T3.DIVISION_ID
							AND	F.PROJECT_CODE   = T3.PROJECT_CODE						
					INNER JOIN ( SELECT DISTINCT '%'+token+'%' tst FROM dbo.String_Split(@p_item_id,',') ) b  -- 20190118 KHSONG 중복제거위한 DISTINCT추가
							ON      F.ITEM_ID  like  b.tst 
							OR      T2.NICK_NAME  like  b.tst 
					INNER JOIN ( SELECT DISTINCT '%'+token+'%' tst FROM dbo.String_Split(@p_project_code,',') ) c  -- 20190118 KHSONG 중복제거위한 DISTINCT추가
							ON      F.project_code  like  c.tst 
							OR      T3.project_name like  c.tst 
					--20180809 ytchoi added
					INNER JOIN 	SCM_MST_SITE	s  WITH(NOLOCK)
							ON	F.DIVISION_ID    = s.DIVISION_ID
							AND	F.SCM_SITE_ID    = s.SCM_SITE_ID
							AND S.SITE_TYPE		= 'SALES'
							--AND S.VALID_YN		= 'Y'
					INNER JOIN [dbo].SCM_MST_CITY h WITH(NOLOCK)
							ON  S.CITY           = h.CITY
					INNER JOIN [dbo].[SCM_MST_COUNTRY] i WITH(NOLOCK)
							ON  S.COUNTRY        = i.COUNTRY

					-- 20180809 ADDED  -----------------
					LEFT JOIN (
								SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO 
									FROM [SCM_MST_SSO_USER_INFO] AS B WITH(NOLOCK)
										INNER JOIN SCM_MST_SSO_DEPT_INFO AS C WITH(NOLOCK)
											ON B.DEPT_ID = C.DEPT_ID
							) AS TEAM

							ON  TEAM.USER_ID   IN (SELECT top 1 token FROM [dbo].[String_Split](F.owner, ','))
					-- 20180809 ADDED  -----------------
 
					LEFT JOIN [dbo].[SCM_MST_SSO_USER_INFO] j WITH(NOLOCK)
							ON  substring( F.OWNER, 0, case when charindex(',',F.OWNER) = 0 then len(F.OWNER)+1 else charindex(',',F.OWNER) end ) = j.USER_ID -- 20180816 modified by ytchoi
					LEFT JOIN [dbo].[SCM_MST_SSO_DEPT_INFO] k WITH(NOLOCK)
					--[PJ2024-50461] Team Mapping------------------------------------
							--ON  CASE WHEN T3.DIVISION_ID IN ('40') THEN j.DEPT_ID ELSE S.DEPT_ID END  = k.DEPT_ID  --20190123 KHSONG 전지재료DIV설정
							ON  j.DEPT_ID = k.DEPT_ID
					--[PJ2024-50461] Team Mapping------------------------------------
					LEFT JOIN ( --20180911 LookUp TABLE JOIN
							SELECT SEGMENT1  AS CODE       
									, SEGMENT2  AS NAME
							FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
							WHERE LOOKUP_TYPE = 'CELL_TYPE' 
							) LOOK
						ON LOOK.CODE = T2.CELL_TYPE
					--20180809 ytchoi added

					--20190419 KHSONG [CSR ID:3969101] GSCM Cell Model컬럼에 대한 Cell Model Nickname 컬럼 추가
					LEFT JOIN 	#TEMP_DM_MST_ITEM_SINGLE_V	T4  WITH(NOLOCK)
							ON	T2.DIVISION_ID    = T4.DIVISION_ID
							AND	ISNULL(T2.FORECAST_INFO_CELL_MODEL,'')        = T4.ITEM_ID
					--사업계획3차 수정 40, 81, 82 사업부 SCP_MST_FINAL_ITEM [START]
					LEFT JOIN SCP_MST_FINAL_ITEM T5 WITH(NOLOCK)
							ON F.DIVISION_ID = T5.DIVISION_ID
							AND F.ITEM_ID = T5.ITEM_ID
					--사업계획3차 수정 40, 81, 82 사업부 SCP_MST_FINAL_ITEM [END]
					
				where f.division_id <> '40' -- hard coding  --20190123 KHSONG 전지재료DIV설정
				AND    CASE WHEN @p_scm_site_id = 'ALL' THEN @p_scm_site_id			
							ELSE f.scm_site_id
 						END  IN ( SELECT token FROM dbo.String_Split(@p_scm_site_id,',') )
				AND    CASE WHEN @p_customer = 'ALL' THEN @p_customer			
							ELSE S.END_CUSTOMER
 						END  IN ( SELECT token FROM dbo.String_Split(@p_customer,',') )
				AND    CASE WHEN @p_item_type = 'ALL' THEN @p_item_type			
							ELSE T2.ITEM_TYPE
 						END  IN ( SELECT token FROM dbo.String_Split(@p_item_type,',') )
				AND    CASE WHEN @p_biz_type = 'ALL' THEN @p_biz_type			
							ELSE T3.BIZ_TYPE
 						END  IN ( SELECT token FROM dbo.String_Split(@p_biz_type,',') )
				AND    CASE WHEN @p_owner = '' THEN @p_owner			
							ELSE F.OWNER
 						END  IN ( SELECT token FROM dbo.String_Split(@p_owner,',') )

	END
	ELSE IF (@p_division_id = '40')-- 40번 사업부
	BEGIN
		INSERT INTO #TEMP_SITE_ITEMAll
				SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.ITEM_ID, T2.NICK_NAME, F.PROJECT_CODE
					--20180809 ytchoi added
						--,F.ATTRIBUTE5 AS CELL_CODE  -- 20180810 ytchoi 조회속도개선 SCM_MST_MODEL_FINAL_ITEM_BOM_V.CHILD_ITEM_ID -> SCM_MST_SITE.attribute5 컬럼사용
						--사업계획3차 수정[Cell Code칼럼에는 Cell Code만 지정] 81, 82 사업부 SCP_MST_FINAL_ITEM [START]
						--, F.ATTRIBUTE5 CELL_CODE 
						, ISNULL(T5.ATTRIBUTE1, '') CELL_CODE 
						--사업계획3차 수정[Cell Code칼럼에는 Cell Code만 지정] 81, 82 사업부 SCP_MST_FINAL_ITEM [END]
						
						, ''     AS BIZ_TYPE
						--, CASE WHEN SUBSTRING(F.ITEM_ID, 1, 2) = 'MB' THEN 'BMS' 
						--  WHEN SUBSTRING(F.ITEM_ID, 1, 2) = 'MC' OR SUBSTRING(F.ITEM_ID, 1, 2) = 'MT' OR SUBSTRING(F.ITEM_ID, 1, 2) = 'MI'  OR SUBSTRING(F.ITEM_ID, 1, 2) = 'MD' THEN 'Cell' 
						--  WHEN SUBSTRING(F.ITEM_ID, 1, 2) = 'MP' THEN 'Pack'
						--  ELSE 'ETC'
						--  END BIZ_TYPE
						--사업계획3차 수정[Cell/Pack Biz 정보 누락] [END]
						, S.END_CUSTOMER
						, S.SOLDTO_CUSTOMER
						, i.COUNTRY	
						, i.COUNTRY_NAME	  
						, h.CITY
						, h.CITY_NAME	  
						--20180723, CASE WHEN a.division_id NOT IN ('40') THEN f.PROJECT_OWNER ELSE j.USER_NAME_EN end AS OWNER  --20190123 KHSONG 전지재료DIV설정
						--20180809 ytchoi modify(s)
						-- modify by ytchoi 180913
						,( SELECT distinct  STUFF(( SELECT ',' + user_name_en FROM (select za.user_name_en  from SCM_MST_SSO_USER_INFO za WITH(NOLOCK)  ,( SELECT token FROM dbo.String_Split(F.OWNER,',') ) zb where za.user_id = zb.token ) xb  FOR XML PATH('') ),1,1,'') AS NAME FROM (select za.user_name_en  from SCM_MST_SSO_USER_INFO za WITH(NOLOCK)  ,( SELECT token FROM dbo.String_Split(F.OWNER,',') ) zb where za.user_id = zb.token) xa ) AS OWNER
						, j.USER_NAME_EN AS PROJECT_OWNER -- 20180705
						, J.USER_ID
						--20180809 ytchoi modify(e)
						, T2.ITEM_NAME       
						, T2.ITEM_TYPE 
						, '' AS PROJECT_STATUS 
						, F.CUST_GROUP
						, F.CUST_GROUP_DTL
						, F.APPLICATION
						, F.ROUTE
						-- 20180711 ??
						, T2.MDM_PROJECT_NAME  
						, T2.MIN_CAPACITY
						, T2.FORECAST_INFO_BIZ_TYPE
	  					, T2.FORECAST_INFO_PRODUCT_GROUP
						, LOOK.NAME AS CELL_TYPE --20180911 LookUp ??? ???? CELL_TYPE ??
						--사업계획3차 수정[Cell환산자 데이터 출처 변경] 40, 81, 82 사업부 SCP_MST_FINAL_ITEM [START]
						--, T2.FORECAST_INFO_CELL_PACK_COUNT
						, T5.CELL_CF
						--사업계획3차 수정[Cell환산자 데이터 출처 변경] 40, 81, 82 사업부 SCP_MST_FINAL_ITEM [END]
						, T2.FORECAST_INFO_SPEC+T2.FORECAST_INFOR_VERSION	as FORECAST_INFO_ALL
						, T2.FORECAST_INFO_SPEC								as FORECAST_INFO_SPEC
						, T2.FORECAST_INFOR_VERSION							as FORECAST_INFOR_VERSION
						, ISNULL(T4.NICK_NAME,'') AS CELL_MODEL_NICK_NAME  --20190419 KHSONG [CSR ID:3969101] GSCM Cell Model컬럼에 대한 Cell Model Nickname 컬럼 추가
						, S.VMI_YN  -- 20180719
						, ISNULL(F.attribute1,'') DMS_SALES     -- 20190213 KHSONG [CSR ID:3912438] 고객군, 판매처 컬럼 정규화 요청의 건 --20190322 KHSONG 고객군, 판매처 컬럼 NULL처리조건 추가
						, ISNULL(F.attribute2,'') DMS_CUSTOMER  -- 20190213 KHSONG [CSR ID:3912438] 고객군, 판매처 컬럼 정규화 요청의 건 --20190322 KHSONG 고객군, 판매처 컬럼 NULL처리조건 추가
						, CASE WHEN F.DIVISION_ID IN ('40') THEN TEAM.DEPT_ID ELSE k.DEPT_ID END AS DEPT_ID		-- 20180809  --20190123 KHSONG 전지재료DIV설정
						, CASE WHEN F.DIVISION_ID IN ('40') THEN TEAM.DEPT_NAME_KO ELSE k.DEPT_NAME_KO END AS DEPT_NAME_KO	-- 20180809  --20190123 KHSONG 전지재료DIV설정
						, F.CELL_PER_CAR, F.CELL_PER_MODULE,F.CELL_PER_CAR / IIF(ISNULL(F.CELL_PER_MODULE, 0) = 0, 1, F.CELL_PER_MODULE) AS MODULE_PER_CAR  -- 20190705 KHSONG [CSR ID:4023158]

						,T2.ITEM_CLASS_NAME  -- 20190705 KHSONG [CSR ID:4023158] measure추가를 위한 컬럼추가

						-- 20200130 KHSONG [C20200114-000201]
						,T2.ENERGE
						,T2.CELL_QUANTITY
						-- 20200130 KHSONG [C20200114-000201]
						,F.VALID_YN
						,'' PRODUCT_GROUP_CODE
						,'' PRODUCT_GROUP_NAME
						,F.REPORT_GROUP1
						,F.REPORT_GROUP2
						,F.REPORT_GROUP3
						,F.REPORT_GROUP4
					from SCM_MST_SITE_ITEM F WITH(NOLOCK)
					INNER JOIN 	#TEMP_DM_MST_ITEM_SINGLE_V	T2  WITH(NOLOCK)
							ON	F.DIVISION_ID    = T2.DIVISION_ID
							AND	F.ITEM_ID        = T2.ITEM_ID						
					INNER JOIN ( SELECT DISTINCT '%'+token+'%' tst FROM dbo.String_Split(@p_item_id,',') ) b  -- 20190118 KHSONG 중복제거위한 DISTINCT추가
							ON      F.ITEM_ID  like  b.tst 
							OR      T2.NICK_NAME  like  b.tst 
					INNER JOIN ( SELECT DISTINCT '%'+token+'%' tst FROM dbo.String_Split(@p_project_code,',') ) c  -- 20190118 KHSONG 중복제거위한 DISTINCT추가
							ON      F.project_code  like  c.tst 
					--20180809 ytchoi added
					INNER JOIN 	SCM_MST_SITE	s  WITH(NOLOCK)
							ON	F.DIVISION_ID    = s.DIVISION_ID
							AND	F.SCM_SITE_ID    = s.SCM_SITE_ID
							AND S.SITE_TYPE = 'SALES'
					INNER JOIN [dbo].SCM_MST_CITY h WITH(NOLOCK)
							ON  S.CITY           = h.CITY
					INNER JOIN [dbo].[SCM_MST_COUNTRY] i WITH(NOLOCK)
							ON  S.COUNTRY        = i.COUNTRY

					-- 20180809 ADDED  -----------------
					LEFT JOIN (
								SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO 
									FROM [SCM_MST_SSO_USER_INFO] AS B WITH(NOLOCK)
										INNER JOIN SCM_MST_SSO_DEPT_INFO AS C WITH(NOLOCK)
											ON B.DEPT_ID = C.DEPT_ID
								) AS TEAM

							ON  TEAM.USER_ID   IN (SELECT top 1 token FROM [dbo].[String_Split](F.owner, ','))
					-- 20180809 ADDED  -----------------
 
					LEFT JOIN [dbo].[SCM_MST_SSO_USER_INFO] j WITH(NOLOCK)
							ON  substring( F.OWNER, 0, case when charindex(',',F.OWNER) = 0 then len(F.OWNER)+1 else charindex(',',F.OWNER) end ) = j.USER_ID -- 20180816 modified by ytchoi
					LEFT JOIN [dbo].[SCM_MST_SSO_DEPT_INFO] k WITH(NOLOCK)
							ON  CASE WHEN F.DIVISION_ID IN ('40') THEN j.DEPT_ID ELSE S.DEPT_ID END  = k.DEPT_ID  --20190123 KHSONG 전지재료DIV설정
					LEFT JOIN ( --20180911 LookUp ??? ??
								SELECT SEGMENT1  AS CODE       
										, SEGMENT2  AS NAME
									FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
									WHERE LOOKUP_TYPE = 'CELL_TYPE' 
								) LOOK
							ON LOOK.CODE = T2.CELL_TYPE
					--20190419 KHSONG [CSR ID:3969101] GSCM Cell Model컬럼에 대한 Cell Model Nickname 컬럼 추가
					LEFT JOIN 	#TEMP_DM_MST_ITEM_SINGLE_V	T4  WITH(NOLOCK)
							ON	T2.DIVISION_ID    = T4.DIVISION_ID
							AND	ISNULL(T2.FORECAST_INFO_CELL_MODEL,'')        = T4.ITEM_ID
					--사업계획3차 수정 40, 81, 82 사업부 SCP_MST_FINAL_ITEM [START]
					LEFT JOIN SCP_MST_FINAL_ITEM T5 WITH(NOLOCK)
							ON F.DIVISION_ID = T5.DIVISION_ID
							AND F.ITEM_ID = T5.ITEM_ID
					--사업계획3차 수정 40, 81, 82 사업부 SCP_MST_FINAL_ITEM [END]
								
					--20180809 ytchoi added
				where f.division_id = '40' -- hard coding  --20190123 KHSONG 전지재료DIV설정					
				AND    CASE WHEN @p_scm_site_id = 'ALL' THEN @p_scm_site_id			
							ELSE f.scm_site_id
 						END  IN ( SELECT token FROM dbo.String_Split(@p_scm_site_id,',') )
				AND    CASE WHEN @p_customer = 'ALL' THEN @p_customer			
							ELSE f.project_code
 						END  IN ( SELECT token FROM dbo.String_Split(@p_customer,',') )
				AND    CASE WHEN @p_item_type = 'ALL' THEN @p_item_type			
							ELSE T2.ITEM_TYPE
 						END  IN ( SELECT token FROM dbo.String_Split(@p_item_type,',') )
				AND    CASE WHEN @p_biz_type = 'ALL' THEN @p_biz_type			
							ELSE T2.FORECAST_INFO_BIZ_TYPE
 						END  IN ( SELECT token FROM dbo.String_Split(@p_biz_type,',') )   
				AND    CASE WHEN @p_owner = '' THEN @p_owner			
							ELSE F.OWNER
 						END  IN ( SELECT token FROM dbo.String_Split(@p_owner,',') )
   
	END

	
	--select *
	--from #TEMP_SITE_ITEMAll

	-- 최종적으로  #TEMP_SITE_ITEMAll에 정보를 #TEMP_SITE_ITEM 에 저장한다.
	BEGIN
		SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID,ITEM_ID,NICK_NAME,PROJECT_NAME
				,MAX(CELL_CODE                   )   CELL_CODE                   
				,MAX(BIZ_TYPE                     )   BIZ_TYPE                     
				,MAX(END_CUSTOMER                 )   END_CUSTOMER                 
				,MAX(SOLDTO_CUSTOMER              )   SOLDTO_CUSTOMER              
				,MAX(COUNTRY                      )   COUNTRY     
				,MAX(COUNTRY_NAME                 )   COUNTRY_NAME                 
				,MAX(CITY                         )   CITY                         
				,MAX(CITY_NAME                    )   CITY_NAME                    
				,MAX(OWNER                        )   OWNER                        
				,MAX(PROJECT_OWNER                )   PROJECT_OWNER                
				,MAX(USER_ID                      )   USER_ID                      
				,MAX(ITEM_NAME                    )   ITEM_NAME                    
				,MAX(ITEM_TYPE                    )   ITEM_TYPE                    
				,MAX(PROJECT_STATUS               )   PROJECT_STATUS               
				,MAX(CUST_GROUP                   )   CUST_GROUP                   
				,MAX(CUST_GROUP_DTL               )   CUST_GROUP_DTL               
				,MAX(APPLICATION                  )   APPLICATION                  
				,MAX(ROUTE                        )   ROUTE                        
				,MAX(MDM_PROJECT_NAME             )   MDM_PROJECT_NAME             
				,MAX(MIN_CAPACITY                 )   MIN_CAPACITY                 
				,MAX(FORECAST_INFO_BIZ_TYPE       )   FORECAST_INFO_BIZ_TYPE       
				,MAX(FORECAST_INFO_PRODUCT_GROUP  )   FORECAST_INFO_PRODUCT_GROUP  
				,MAX(CELL_TYPE                    )   CELL_TYPE                    
				,MAX(FORECAST_INFO_CELL_PACK_COUNT)   FORECAST_INFO_CELL_PACK_COUNT
				,MAX(FORECAST_INFO_ALL            )   FORECAST_INFO_ALL            
				,MAX(FORECAST_INFO_SPEC           )   FORECAST_INFO_SPEC           
				,MAX(FORECAST_INFOR_VERSION       )   FORECAST_INFOR_VERSION       
				,MAX(CELL_MODEL_NICK_NAME         )   CELL_MODEL_NICK_NAME         
				,MAX(VMI_YN                       )   VMI_YN                       
				,MAX(DMS_SALES                    )   DMS_SALES                    
				,MAX(DMS_CUSTOMER                 )   DMS_CUSTOMER                 
				,MAX(DEPT_ID                      )   DEPT_ID                      
				,MAX(DEPT_NAME_KO                 )   DEPT_NAME_KO                 

				-- 20190705 KHSONG [CSR ID:4023158] (BEGIN)
				,MAX(CELL_PER_CAR                 )   CELL_PER_CAR                 
				,MAX(CELL_PER_MODULE              )   CELL_PER_MODULE                 
				,MAX(MODULE_PER_CAR               )   MODULE_PER_CAR                 
				-- 20190705 KHSONG [CSR ID:4023158] (END)

				,MAX(ITEM_CLASS_NAME              )   ITEM_CLASS_NAME  -- 20190705 KHSONG [CSR ID:4023158] measure추가를 위한 컬럼추가

				-- 20200130 KHSONG [C20200114-000201]
				,MAX(ENERGE							)	ENERGE
				,MAX(CELL_QUANTITY					)	CELL_QUANTITY
				-- 20200130 KHSONG [C20200114-000201]
				,MAX(ITEM_VALID_YN)						ITEM_VALID_YN	
				,MAX(PRODUCT_GROUP_CODE)				PRODUCT_GROUP	
				,MAX(PRODUCT_GROUP_NAME)				PRODUCT_GROUP_NAME	
				,MAX(REPORT_GROUP1)				        REPORT_GROUP1	
				,MAX(REPORT_GROUP2)				        REPORT_GROUP2	
				,MAX(REPORT_GROUP3)				        REPORT_GROUP3	
				,MAX(REPORT_GROUP4)				        REPORT_GROUP4	
			into #TEMP_SITE_ITEM
			FROM #TEMP_SITE_ITEMAll  WITH(NOLOCK)
		GROUP BY DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,NICK_NAME,PROJECT_NAME
	END


--SELECT * FROM #TEMP_SITE_ITEM WHERE item_id = 'AMVCCCMAE-A1-000'

	-- BIZ PLAN 이관 프로세스 시작
	IF @p_division_id LIKE '81%' OR @p_division_id = '82' 
	BEGIN
		BEGIN
			DELETE FROM DM_PLN_BIZPLAN WHERE DIVISION_ID = @p_division_id
            SET @n_del_count = @@ROWCOUNT;    
		END

PRINT N'판가데이터 생성 ==================================================================================================================================================='
		-- 판가 임시테이블 생성
		/* 81%
		BASE_PRICE:Base Price(Cur),Base Price - Metal A/P(Cur),Base Price Change- CR(Cur),Base Price Change- Others (Cur)
        METAL_PRICE:Metal Index Gap(Cur)
        OTHER_PRICE:Others(Cur)
        TOTAL_PRICE:Total Price(Cur)
		*/
		IF @p_division_id LIKE '81%'
		BEGIN
			INSERT INTO #TMP_PRICE (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, CURRENCY, YYYYMM, BASE_PRICE, METAL_LINK_PRICE, OTHER_PRICE, TOTAL_PRICE)
				SELECT TT.DIVISION_ID, TT.PROJECT_CODE, TT.SCM_SITE_ID, TT.ITEM_ID, TT.CELL_PROD_SITE, TT.CURRENCY
					   , TT.STND_YM YYYYMM, ISNULL(PR.BASE_PRICE, 0) BASE_PRICE, ISNULL(PR.METAL_LINK_PRICE, 0) METAL_LINK_PRICE
					   , ISNULL(PR.OTHER_PRICE, 0) OTHER_PRICE, ISNULL(PR.TOTAL_PRICE, 0) TOTAL_PRICE--, QTY = ISNULL(PR.TOTAL_PRICE, 0)
				  FROM (
				                    /* 2024.01.25	KCW3408   		사업계획수정[날짜 하드코딩을 수정] */
									SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, CURRENCY
										, b.BASIS_YYYYMM AS STND_YM
									   ,0 BASE_PRICE,0 METAL_LINK_PRICE,0 OTHER_PRICE,0 TOTAL_PRICE
									FROM DM_MST_METAL_PRICE a WITH(NOLOCK) 
									JOIN  #TEMP_SCM_SYS_CALENDAR_M b
									      ON 1 = 1
									WHERE DIVISION_ID = @p_division_id AND MEASURE IN ('TotalPriceCur') 
									GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, CURRENCY, b.BASIS_YYYYMM
						) tt
						LEFT JOIN (
							SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, CURRENCY, STND_YM
								 , SUM(BASE_PRICE) BASE_PRICE, SUM(METAL_LINK_PRICE) METAL_LINK_PRICE, SUM(OTHER_PRICE) OTHER_PRICE, SUM(TOTAL_PRICE)  TOTAL_PRICE
							FROM(
									SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, CURRENCY, STND_YM, SUM(PRICE) BASE_PRICE,0 METAL_LINK_PRICE,0 OTHER_PRICE,0 TOTAL_PRICE
									FROM DM_MST_METAL_PRICE WITH(NOLOCK) 
									WHERE DIVISION_ID = @p_division_id AND MEASURE IN ('BasePriceCur', 'BasePriceMetalAPCur', 'BasePriceChangeCur', 'BasePriceOthersCur')
									GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, STND_YM, CURRENCY
									UNION ALL
									SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, CURRENCY, STND_YM, 0 BASE_PRICE, SUM(PRICE) METAL_LINK_PRICE, 0 OTHER_PRICE,0 TOTAL_PRICE
									FROM DM_MST_METAL_PRICE WITH(NOLOCK) 
									WHERE DIVISION_ID = @p_division_id AND MEASURE IN ('MetalIndexCur')
									GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, STND_YM, CURRENCY
									UNION ALL
									SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, CURRENCY, STND_YM, 0 BASE_PRICE,0 METAL_LINK_PRICE, SUM(PRICE) OTHER_PRICE,0 TOTAL_PRICE
									FROM DM_MST_METAL_PRICE WITH(NOLOCK) 
								    WHERE DIVISION_ID = @p_division_id AND MEASURE IN ('OtherPriceCur')
									GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, STND_YM, CURRENCY
									UNION ALL
									SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, CURRENCY, STND_YM, 0 BASE_PRICE,0 METAL_LINK_PRICE,0 OTHER_PRICE, SUM(PRICE) TOTAL_PRICE
									FROM DM_MST_METAL_PRICE WITH(NOLOCK) 
								    WHERE DIVISION_ID = @p_division_id AND MEASURE IN ('TotalPriceCur')
								    GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, STND_YM, CURRENCY
								) A 
							GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, STND_YM, CURRENCY
						) PR
				ON  TT. DIVISION_ID   = PR.DIVISION_ID
				AND TT.PROJECT_CODE   = PR.PROJECT_CODE
				AND TT.SCM_SITE_ID    = PR.SCM_SITE_ID
				AND TT.ITEM_ID        = PR.ITEM_ID
				AND TT.CELL_PROD_SITE = PR.CELL_PROD_SITE
				AND TT.CURRENCY = PR.CURRENCY
				AND TT.STND_YM = PR.STND_YM
		END
		/* 82
		BASE_PRICE:Base Price(Cur),Base Price Change- CR(Cur),Base Price Change- Others (Cur)
        METAL_PRICE:Metal Index Gap(Cur)
        OTHER_PRICE:Others(Cur)
        TOTAL_PRICE:Total Price(Cur)
		*/
		ELSE IF @p_division_id = '82'
		BEGIN
			INSERT INTO #TMP_PRICE (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, CURRENCY, YYYYMM, BASE_PRICE, METAL_LINK_PRICE, OTHER_PRICE, TOTAL_PRICE)
				SELECT TT.DIVISION_ID, TT.PROJECT_CODE, TT.SCM_SITE_ID, TT.ITEM_ID, TT.CELL_PROD_SITE, TT.CURRENCY
					   , TT.STND_YM YYYYMM, ISNULL(PR.BASE_PRICE, 0) BASE_PRICE, ISNULL(PR.METAL_LINK_PRICE, 0) METAL_LINK_PRICE
					   , ISNULL(PR.OTHER_PRICE, 0) OTHER_PRICE, ISNULL(PR.TOTAL_PRICE, 0) TOTAL_PRICE--, QTY = ISNULL(PR.TOTAL_PRICE, 0)
				  FROM (
				                    /* 2024.01.25	KCW3408   		사업계획수정[날짜 하드코딩을 수정] */
									SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, CURRENCY
										, b.BASIS_YYYYMM AS STND_YM
									   ,0 BASE_PRICE,0 METAL_LINK_PRICE,0 OTHER_PRICE,0 TOTAL_PRICE
									FROM DM_MST_METAL_PRICE a WITH(NOLOCK) 
									JOIN  #TEMP_SCM_SYS_CALENDAR_M b
									      ON 1 = 1 
									WHERE DIVISION_ID = @p_division_id AND MEASURE IN ('TotalPriceCur') 
									GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, CURRENCY, b.BASIS_YYYYMM
						) tt
						LEFT JOIN (
							SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, CURRENCY, STND_YM
								 , SUM(BASE_PRICE) BASE_PRICE, SUM(METAL_LINK_PRICE) METAL_LINK_PRICE, SUM(OTHER_PRICE) OTHER_PRICE, SUM(TOTAL_PRICE)  TOTAL_PRICE
							FROM(
									SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, CURRENCY, STND_YM, SUM(PRICE) BASE_PRICE,0 METAL_LINK_PRICE,0 OTHER_PRICE,0 TOTAL_PRICE                --BASE_PRICE 사업계획3차 수정[판가MEASURE 변경] BasePriceMetalAPCur 배제
									FROM DM_MST_METAL_PRICE WITH(NOLOCK) 
									WHERE DIVISION_ID = @p_division_id AND MEASURE IN ('BasePriceCur', 'BasePriceChangeCur', 'BasePriceOthersCur')                            
									GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, STND_YM, CURRENCY
									UNION ALL
									SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, CURRENCY, STND_YM, 0 BASE_PRICE, SUM(PRICE) METAL_LINK_PRICE, 0 OTHER_PRICE,0 TOTAL_PRICE              --METAL_LINK_PRICE
									FROM DM_MST_METAL_PRICE WITH(NOLOCK) 
									WHERE DIVISION_ID = @p_division_id AND MEASURE IN ('MetalIndexCur')
									GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, STND_YM, CURRENCY
									UNION ALL
									SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, CURRENCY, STND_YM, 0 BASE_PRICE,0 METAL_LINK_PRICE, SUM(PRICE) OTHER_PRICE,0 TOTAL_PRICE               --OTHER_PRICE
									FROM DM_MST_METAL_PRICE WITH(NOLOCK) 
									WHERE DIVISION_ID = @p_division_id AND MEASURE IN ('OtherPriceCur')
									GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, STND_YM, CURRENCY
									UNION ALL
									SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, CURRENCY, STND_YM, 0 BASE_PRICE,0 METAL_LINK_PRICE,0 OTHER_PRICE, SUM(PRICE) TOTAL_PRICE               --TOTAL_PRICE
									FROM DM_MST_METAL_PRICE WITH(NOLOCK) 
									WHERE DIVISION_ID = @p_division_id AND MEASURE IN ('TotalPriceCur')
									GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, STND_YM, CURRENCY
								) A 
							GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, STND_YM, CURRENCY
						) PR
				ON  TT. DIVISION_ID   = PR.DIVISION_ID
				AND TT.PROJECT_CODE   = PR.PROJECT_CODE
				AND TT.SCM_SITE_ID    = PR.SCM_SITE_ID
				AND TT.ITEM_ID        = PR.ITEM_ID
				AND TT.CELL_PROD_SITE = PR.CELL_PROD_SITE
				AND TT.CURRENCY = PR.CURRENCY
				AND TT.STND_YM = PR.STND_YM

		END

--SELECT * FROM #TEMP_SITE_ITEM WHERE item_id = 'AMVCCCMAE-A1-000'
--SELECT * FROM #TMP_PRICE WHERE item_id = 'AMVCCCMAE-A1-000'

PRINT N'Business_Plan MEASURE 데이터 생성 81, 82 ==================================================================================================================================================='
		-- Business_Plan MEASURE 데이터 생성
		/*  2024.01.25	KCW3408   		사업계획수정[METAL_LINK_YN:자동차, ESS 사업부: Biz Plan Price(Master)의 'Metal Link'칼럼 값 → METAL_LINK_YN에 동일 반영 */ 

		BEGIN --OTHERS, TOTAL PRICE 추가
			INSERT INTO DM_PLN_BIZPLAN (SEQ, DIVISION_ID,DEPT_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,ITEM_ID,END_CUSTOMER,BIZ_TYPE,PLANT_SITE_ID,FCST_TYPE,DOM_EXP,INCOTERMS
			,ITEM_USE,UNIT_ENERGY,CURRENCY,MEASURE,YYYYMM,QTY,CELL_CODE, CELL_PER_PACK, CELL_PER_MODULE, MODULE_PER_PACK, CELL_PROD_SITE, PRODUCT_GROUP
			, EE_CORP_ID, CELL_CORP_ID, PACK_CORP_ID, ALT_SIM_YN, PERIOD_YYMM, SCENARIO_TYPE, BASE_PRICE, METAL_LINK_PRICE, METAL_LINK_YN, WORK_YYYYMMDD, OSP_YN, EXT_INT
			--사업계획3차 수정[Application Gr.] 40 사업부 SCM_MST_SITE_ITEM ATTRIBUTE5 추가 [START]
			,ATTRIBUTE5
			--사업계획3차 수정[Application Gr.] 40 사업부 SCM_MST_SITE_ITEM ATTRIBUTE5 추가 [END]	
					
			, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
			SELECT 1 SEQ, A.DIVISION_ID,isnull(B.DEPT_ID,' '), A.PROJECT_CODE,B.PROJECT_NAME,A.SCM_SITE_ID,A.ITEM_ID,B.END_CUSTOMER,B.BIZ_TYPE,A.PLANT_SITE_ID,A.FCST_TYPE,A.DOM_EXP,A.INCOTERMS
			,'' ITEM_USE, 0.00 UNIT_ENERGY,'' CURRENCY,'Business_Plan' MEASURE,SUBSTRING(A.YYYYMMDD, 1, 6) YYYYMM,CONVERT(NUMERIC(30,10), SUM(A.QTY)) QTY,B.CELL_CODE
			,B.CELL_PER_CAR, B.CELL_PER_MODULE, B.MODULE_PER_CAR, '-' CELL_PROD_SITE, PRODUCT_GROUP
			,'' EE_CORP_ID,'' CELL_CORP_ID,'' PACK_CORP_ID, 'N' ALT_SIM_YN,SUBSTRING(CONVERT(VARCHAR, GETDATE(), 112), 1, 6) PERIOD_YYMM,'BP' SCENARIO_TYPE,0 BASE_PRICE,0 METAL_LINK_PRICE
			,CASE WHEN A.DIVISION_ID = '82' THEN M1.METAL_LINK_YN  ELSE M.METAL_LINK_YN END AS METAL_LINK_YN
			,'' WORK_YYYYMMDD,'' OSP_YN, 'I' EXT_INT
			--사업계획3차 수정[Application Gr.] 40 사업부 SCM_MST_SITE_ITEM ATTRIBUTE5 추가 [START]
			,ISNULL(REPORT_GROUP1, '')
			--사업계획3차 수정[Application Gr.] 40 사업부 SCM_MST_SITE_ITEM ATTRIBUTE5 추가 [END]				
		
			, 'SYSTEM', GETDATE(), 'SYSTEM', GETDATE()
			FROM DM_PLN_MKT_FCST_C A WITH(NOLOCK) INNER JOIN #TEMP_SITE_ITEM B  WITH(NOLOCK)
			ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
			 LEFT  JOIN DM_MST_METAL_PRICE_RULE M WITH (NOLOCK)         -- METAL_LINK_YN:자동차 
			         ON A.DIVISION_ID  = M.DIVISION_ID
					AND A.PROJECT_CODE = M.PROJECT_CODE
					AND A.SCM_SITE_ID  = M.SCM_SITE_ID
					AND A.ITEM_ID	   = M.ITEM_ID
			 LEFT  JOIN DM_MST_ESS_METAL_PRICE_RULE M1 WITH (NOLOCK)    --METAL_LINK_YN:ESS 사업부 '82'
			         ON A.DIVISION_ID  = M1.DIVISION_ID
					AND A.PROJECT_CODE = M1.PROJECT_CODE
					AND A.SCM_SITE_ID  = M1.SCM_SITE_ID
					AND A.ITEM_ID	   = M1.ITEM_ID
			WHERE 1=1 AND A.DIVISION_ID = @p_division_id AND VERSION_NO = @p_version_id AND A.MEASURE = 'MKT_FCST' 
				      AND YYYYMMDD BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd 
					  AND A.QTY > 0 
			GROUP BY A.DIVISION_ID,B.DEPT_ID, B.DEPT_NAME_KO, A.PROJECT_CODE,B.PROJECT_NAME,A.SCM_SITE_ID,A.ITEM_ID,B.END_CUSTOMER,B.BIZ_TYPE,A.PLANT_SITE_ID,A.FCST_TYPE,A.DOM_EXP,A.INCOTERMS,A.MEASURE,SUBSTRING(A.YYYYMMDD, 1, 6)
			,B.CELL_CODE,B.CELL_PER_CAR, B.CELL_PER_MODULE, B.MODULE_PER_CAR, B.PRODUCT_GROUP, B.REPORT_GROUP1,CASE WHEN A.DIVISION_ID = '82' THEN M1.METAL_LINK_YN  ELSE M.METAL_LINK_YN END
		END 

		--SELECT * FROM #TEMP_SITE_ITEM

		BEGIN -- Business_Plan MEASURE 데이터에 0 값 데이터 생성

			-- 0 데이터 생성시 중복 방지
			BEGIN
				DELETE FROM DM_PLN_BIZPLAN WHERE QTY = 0 AND DIVISION_ID = @p_division_id
			END

			-- 가지고올 데이터를 모두 0으로 저장한다.
			BEGIN
				BEGIN
					SELECT ROW_NUMBER() OVER(ORDER BY PROJECT_CODE, SCM_SITE_ID, ITEM_ID) SEQ
					,DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, END_CUSTOMER, BIZ_TYPE, PLANT_SITE_ID, FCST_TYPE, DOM_EXP, INCOTERMS, CURRENCY, MEASURE
					,MAX(DEPT_ID) DEPT_ID
					,MAX(PROJECT_NAME) PROJECT_NAME
					,MAX(CELL_PROD_SITE) CELL_PROD_SITE -- KEY
					,MAX(EE_CORP_ID) EE_CORP_ID
					,MAX(CELL_CORP_ID) CELL_CORP_ID
					,MAX(PACK_CORP_ID) PACK_CORP_ID
					,MAX(EXT_INT) EXT_INT
					,MAX(PRODUCT_GROUP) PRODUCT_GROUP
					,MAX(ALT_SIM_YN) ALT_SIM_YN
					,MAX(CELL_CODE) CELL_CODE
					,MAX(CELL_PER_MODULE) CELL_PER_MODULE
					,MAX(MODULE_PER_PACK) MODULE_PER_PACK
					,MAX(CELL_PER_PACK) CELL_PER_PACK
					,MAX(PERIOD_YYMM) PERIOD_YYMM
					,MAX(SCENARIO_TYPE) SCENARIO_TYPE
					,MAX(BASE_PRICE) BASE_PRICE
					,MAX(METAL_LINK_PRICE) METAL_LINK_PRICE
					,MAX(METAL_LINK_YN) METAL_LINK_YN
					,MAX(WORK_YYYYMMDD) WORK_YYYYMMDD
					,MAX(OSP_YN) OSP_YN
					,MAX(ITEM_USE) ITEM_USE
					,MAX(UNIT_ENERGY) UNIT_ENERGY
					INTO #TMP_PLN_BIZPLAN 
					FROM DM_PLN_BIZPLAN WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id --AND QTY <> 0  -- QTY가 0이 아닌 데이터를 추출한다.
					GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, END_CUSTOMER, BIZ_TYPE, PLANT_SITE_ID, FCST_TYPE, DOM_EXP, INCOTERMS, CURRENCY, MEASURE
					 
					 /* 2024.01.25	KCW3408   		사업계획수정[날짜 하드코딩을 수정] */
					BEGIN
						INSERT INTO #TMP_DM_PLN_BIZPLAN(
						DIVISION_ID,DEPT_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,END_CUSTOMER,BIZ_TYPE
						,PLANT_SITE_ID,FCST_TYPE,DOM_EXP,INCOTERMS,ITEM_USE,UNIT_ENERGY,CURRENCY, MEASURE
						,YYYYMM,QTY,PROJECT_NAME,CELL_PROD_SITE,EE_CORP_ID,CELL_CORP_ID,PACK_CORP_ID
						,EXT_INT,PRODUCT_GROUP,ALT_SIM_YN,CELL_CODE,CELL_PER_MODULE,MODULE_PER_PACK
						,CELL_PER_PACK,PERIOD_YYMM,SCENARIO_TYPE,BASE_PRICE,METAL_LINK_PRICE,METAL_LINK_YN,WORK_YYYYMMDD,OSP_YN,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE)
	  					SELECT DIVISION_ID,DEPT_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,END_CUSTOMER,BIZ_TYPE
						,PLANT_SITE_ID,FCST_TYPE,DOM_EXP,INCOTERMS,ITEM_USE,UNIT_ENERGY,CURRENCY,'Business_Plan' MEASURE
						,B.BASIS_YYYYMM AS YYYYMM, 0 QTY,PROJECT_NAME,CELL_PROD_SITE,EE_CORP_ID,CELL_CORP_ID,PACK_CORP_ID
						,EXT_INT,PRODUCT_GROUP,ALT_SIM_YN,CELL_CODE,CELL_PER_MODULE,MODULE_PER_PACK
						,CELL_PER_PACK,PERIOD_YYMM,SCENARIO_TYPE,BASE_PRICE,METAL_LINK_PRICE,METAL_LINK_YN,WORK_YYYYMMDD,OSP_YN, 'SYSTEM', GETDATE(), 'SYSTEM', GETDATE()
						FROM #TMP_PLN_BIZPLAN A WITH(NOLOCK)
						JOIN #TEMP_SCM_SYS_CALENDAR_M b
							 ON 1 = 1 
					END		 
					   
				END

			END

			-- 중복방지를 위해 DM_PLN_BIZPLAN 과 동일한 데이터를 삭제
			BEGIN
				DELETE FROM #TMP_DM_PLN_BIZPLAN FROM #TMP_DM_PLN_BIZPLAN A INNER JOIN DM_PLN_BIZPLAN B
				ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID AND A.DOM_EXP = B.DOM_EXP AND  A.FCST_TYPE = B.FCST_TYPE 
				AND A.END_CUSTOMER = B.END_CUSTOMER AND A.BIZ_TYPE = B.BIZ_TYPE AND A.INCOTERMS = B.INCOTERMS AND A.PLANT_SITE_ID = B.PLANT_SITE_ID AND A.MEASURE = B.MEASURE AND A.YYYYMM = B.YYYYMM 
				WHERE B.QTY > 0 AND B.DIVISION_ID = @p_division_id
			END

PRINT N'0  데이터 생성 ==================================================================================================================================================='
			-- 모든 일자를 0으로 만든 데이터를 DM_PLN_BIZPLAN에 저장한다.
			BEGIN
				INSERT INTO DM_PLN_BIZPLAN(
				 SEQ, DIVISION_ID,DEPT_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,END_CUSTOMER,BIZ_TYPE
				,PLANT_SITE_ID,FCST_TYPE,DOM_EXP,INCOTERMS,ITEM_USE,UNIT_ENERGY,CURRENCY,MEASURE
				,YYYYMM,QTY,PROJECT_NAME,CELL_PROD_SITE,EE_CORP_ID,CELL_CORP_ID,PACK_CORP_ID
				,EXT_INT,PRODUCT_GROUP,ALT_SIM_YN,CELL_CODE,CELL_PER_MODULE,MODULE_PER_PACK
				,CELL_PER_PACK,PERIOD_YYMM,SCENARIO_TYPE,BASE_PRICE,METAL_LINK_PRICE,METAL_LINK_YN,WORK_YYYYMMDD,OSP_YN,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE)
				SELECT 1 SEQ, DIVISION_ID,DEPT_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,END_CUSTOMER,BIZ_TYPE
				,PLANT_SITE_ID,FCST_TYPE,DOM_EXP,INCOTERMS,ITEM_USE,UNIT_ENERGY,CURRENCY,MEASURE
				,YYYYMM,QTY,PROJECT_NAME,CELL_PROD_SITE,EE_CORP_ID,CELL_CORP_ID,PACK_CORP_ID
				,EXT_INT,PRODUCT_GROUP,ALT_SIM_YN,CELL_CODE,CELL_PER_MODULE,MODULE_PER_PACK
				,CELL_PER_PACK,PERIOD_YYMM,SCENARIO_TYPE,BASE_PRICE,METAL_LINK_PRICE,METAL_LINK_YN,WORK_YYYYMMDD,OSP_YN,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE 
				  FROM #TMP_DM_PLN_BIZPLAN WITH(NOLOCK)
			END

		END

PRINT N'판가업데이트 ==================================================================================================================================================='
-- 판가 업데이트
		BEGIN
			UPDATE DM_PLN_BIZPLAN 
			SET --BASE_PRICE = A.BASE_PRICE, METAL_LINK_PRICE = A.METAL_LINK_PRICE, OTHER_PRICE = A.OTHER_PRICE, TOTAL_PRICE = A.TOTAL_PRICE
			    CURRENCY = A.CURRENCY
			  , LAST_UPDATED_BY = 'SYSTEMR_P', LAST_UPDATE_DATE = GETDATE()  
			FROM #TMP_PRICE A
			 WHERE DM_PLN_BIZPLAN.DIVISION_ID       = A.DIVISION_ID 
			   AND DM_PLN_BIZPLAN.PROJECT_CODE      = A.PROJECT_CODE
			   AND DM_PLN_BIZPLAN.SCM_SITE_ID       = A.SCM_SITE_ID
			   AND DM_PLN_BIZPLAN.ITEM_ID           = A.ITEM_ID
			   AND DM_PLN_BIZPLAN.CELL_PROD_SITE    = A.CELL_PROD_SITE
			   AND DM_PLN_BIZPLAN.YYYYMM            = A.YYYYMM
			   AND DM_PLN_BIZPLAN.MEASURE           IN ('Business_Plan')

            SET @n_insert_count = @@ROWCOUNT;
		END

PRINT N'BizPlanPrice_Cur MEASURE 데이터 생성 ==================================================================================================================================================='
--SELECT * FROM DM_PLN_BIZPLAN
--SELECT * FROM #TMP_PRICE
		BEGIN
			INSERT INTO DM_PLN_BIZPLAN (SEQ, DIVISION_ID,DEPT_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,ITEM_ID,END_CUSTOMER,BIZ_TYPE,PLANT_SITE_ID,FCST_TYPE,DOM_EXP,INCOTERMS
			,ITEM_USE,UNIT_ENERGY,CURRENCY,MEASURE,YYYYMM
			,QTY
			,CELL_CODE, CELL_PER_PACK, CELL_PER_MODULE, MODULE_PER_PACK, CELL_PROD_SITE, PRODUCT_GROUP
			, EE_CORP_ID, CELL_CORP_ID, PACK_CORP_ID, ALT_SIM_YN, PERIOD_YYMM, SCENARIO_TYPE, BASE_PRICE, METAL_LINK_PRICE, OTHER_PRICE, TOTAL_PRICE, METAL_LINK_YN, WORK_YYYYMMDD, OSP_YN, EXT_INT
			,CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
			SELECT 1 SEQ, A.DIVISION_ID,A.DEPT_ID, A.PROJECT_CODE,A.PROJECT_NAME,A.SCM_SITE_ID,A.ITEM_ID,A.END_CUSTOMER,A.BIZ_TYPE,A.PLANT_SITE_ID,A.FCST_TYPE,A.DOM_EXP,A.INCOTERMS
			,ITEM_USE, 0.00 UNIT_ENERGY,B.CURRENCY,'BizPlanPrice_Cur' MEASURE,A.YYYYMM
			, B.TOTAL_PRICE
			, A.CELL_CODE,CELL_PER_PACK, A.CELL_PER_MODULE, A.MODULE_PER_PACK,A.CELL_PROD_SITE, PRODUCT_GROUP
			,EE_CORP_ID,CELL_CORP_ID,PACK_CORP_ID, ALT_SIM_YN, PERIOD_YYMM,SCENARIO_TYPE,B.BASE_PRICE, B.METAL_LINK_PRICE, B.OTHER_PRICE, B.TOTAL_PRICE, METAL_LINK_YN,WORK_YYYYMMDD,OSP_YN, EXT_INT
			, 'SYSTEM', GETDATE(), 'SYSTEM', GETDATE()
			FROM DM_PLN_BIZPLAN A WITH(NOLOCK) INNER JOIN #TMP_PRICE B WITH(NOLOCK)
			ON A.DIVISION_ID       = B.DIVISION_ID 
			   AND A.PROJECT_CODE      = B.PROJECT_CODE
			   AND A.SCM_SITE_ID       = B.SCM_SITE_ID
			   AND A.ITEM_ID           = B.ITEM_ID
			   AND A.CELL_PROD_SITE    = B.CELL_PROD_SITE
			   AND A.YYYYMM            = B.YYYYMM
			   AND A.MEASURE           = 'Business_Plan'
			   --AND A.DIVISION_ID       = @p_division_id
		END

PRINT N'BizPlanPrice_KRW MEASURE 데이터 생성 ==================================================================================================================================================='

		BEGIN
			INSERT INTO DM_PLN_BIZPLAN (SEQ, DIVISION_ID,DEPT_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,ITEM_ID,END_CUSTOMER,BIZ_TYPE,PLANT_SITE_ID,FCST_TYPE,DOM_EXP,INCOTERMS
			,ITEM_USE,UNIT_ENERGY,CURRENCY,MEASURE,YYYYMM,QTY,CELL_CODE
			, CELL_PER_PACK, CELL_PER_MODULE, MODULE_PER_PACK, CELL_PROD_SITE, PRODUCT_GROUP
			, EE_CORP_ID, CELL_CORP_ID, PACK_CORP_ID, ALT_SIM_YN, PERIOD_YYMM, SCENARIO_TYPE, BASE_PRICE, METAL_LINK_PRICE, OTHER_PRICE, TOTAL_PRICE, METAL_LINK_YN, WORK_YYYYMMDD, OSP_YN, EXT_INT
			,CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
			SELECT ROW_NUMBER() OVER(ORDER BY PROJECT_CODE, SCM_SITE_ID, ITEM_ID) SEQ, A.DIVISION_ID,A.DEPT_ID, A.PROJECT_CODE,A.PROJECT_NAME,A.SCM_SITE_ID,A.ITEM_ID,A.END_CUSTOMER,A.BIZ_TYPE,A.PLANT_SITE_ID,A.FCST_TYPE,A.DOM_EXP,A.INCOTERMS
			,A.ITEM_USE, 0.00 UNIT_ENERGY,A.CURRENCY,'BizPlanPrice_KRW' MEASURE,A.YYYYMM, A.QTY * ISNULL(B.STND_PRICE, 1), A.CELL_CODE
			,A.CELL_PER_PACK, A.CELL_PER_MODULE, A.MODULE_PER_PACK,'-' CELL_PROD_SITE, A.PRODUCT_GROUP
			,A.EE_CORP_ID,A.CELL_CORP_ID,A.PACK_CORP_ID, A.ALT_SIM_YN, A.PERIOD_YYMM,A.SCENARIO_TYPE,A.BASE_PRICE, A.METAL_LINK_PRICE, A.OTHER_PRICE, A.TOTAL_PRICE, A.METAL_LINK_YN,A.WORK_YYYYMMDD,A.OSP_YN, A.EXT_INT
			, 'SYSTEM', GETDATE(), 'SYSTEM', GETDATE()
			FROM (SELECT *  
			      FROM DM_PLN_BIZPLAN A WITH(NOLOCK) 
			      WHERE A.MEASURE         = 'BizPlanPrice_Cur'
			      AND A.DIVISION_ID       = @p_division_id				  
				 ) A
				 LEFT JOIN DM_MST_METAL_CURRENCY_PRICE B WITH(NOLOCK) 
			ON A.DIVISION_ID       = B.DIVISION_ID 
			   AND A.YYYYMM            = B.STND_YM
			   AND A.CURRENCY          = B.METAL_CURRENCY
			   AND A.YYYYMM            = B.STND_YM

			/*
			SELECT ROW_NUMBER() OVER(ORDER BY PROJECT_CODE, SCM_SITE_ID, ITEM_ID) SEQ, A.DIVISION_ID,A.DEPT_ID, A.PROJECT_CODE,A.PROJECT_NAME,A.SCM_SITE_ID,A.ITEM_ID,A.END_CUSTOMER,A.BIZ_TYPE,A.PLANT_SITE_ID,A.FCST_TYPE,A.DOM_EXP,A.INCOTERMS
			,A.ITEM_USE, 0.00 UNIT_ENERGY,A.CURRENCY,'BizPlanPrice_KRW' MEASURE,A.YYYYMM, A.QTY * B.STND_PRICE, A.CELL_CODE
			,A.CELL_PER_PACK, A.CELL_PER_MODULE, A.MODULE_PER_PACK,'-' CELL_PROD_SITE, A.PRODUCT_GROUP
			,A.EE_CORP_ID,A.CELL_CORP_ID,A.PACK_CORP_ID, A.ALT_SIM_YN, A.PERIOD_YYMM,A.SCENARIO_TYPE,A.BASE_PRICE, A.METAL_LINK_PRICE, A.OTHER_PRICE, A.TOTAL_PRICE, A.METAL_LINK_YN,A.WORK_YYYYMMDD,A.OSP_YN, A.EXT_INT
			, 'SYSTEM', GETDATE(), 'SYSTEM', GETDATE()
			FROM DM_PLN_BIZPLAN A WITH(NOLOCK) INNER JOIN DM_MST_METAL_CURRENCY_PRICE B WITH(NOLOCK) 
			ON A.DIVISION_ID       = B.DIVISION_ID 
			   AND A.YYYYMM            = B.STND_YM
			   AND A.CURRENCY          = B.METAL_CURRENCY
			   AND A.YYYYMM            = B.STND_YM
			   AND A.MEASURE           = 'BizPlanPrice_Cur'
			   AND A.DIVISION_ID       = @p_division_id
			   */
		END

PRINT N'SalesAmt_CUR MEASURE 데이터 생성 ==================================================================================================================================================='


		BEGIN
			INSERT INTO DM_PLN_BIZPLAN (SEQ, DIVISION_ID,DEPT_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,ITEM_ID,END_CUSTOMER,BIZ_TYPE,PLANT_SITE_ID,FCST_TYPE,DOM_EXP,INCOTERMS
			,ITEM_USE,UNIT_ENERGY,CURRENCY,MEASURE,YYYYMM,QTY,CELL_CODE, CELL_PER_PACK, CELL_PER_MODULE, MODULE_PER_PACK,CELL_PROD_SITE, PRODUCT_GROUP
			, EE_CORP_ID, CELL_CORP_ID, PACK_CORP_ID, ALT_SIM_YN, PERIOD_YYMM, SCENARIO_TYPE, BASE_PRICE, METAL_LINK_PRICE, OTHER_PRICE, TOTAL_PRICE,METAL_LINK_YN, WORK_YYYYMMDD, OSP_YN, EXT_INT
			,CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
			SELECT 
			ROW_NUMBER() OVER(ORDER BY A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID) SEQ, A.DIVISION_ID,B.DEPT_ID, A.PROJECT_CODE,B.PROJECT_NAME,A.SCM_SITE_ID,A.ITEM_ID,B.END_CUSTOMER,B.BIZ_TYPE,A.PLANT_SITE_ID,A.FCST_TYPE,A.DOM_EXP,A.INCOTERMS
			,A.ITEM_USE, A.UNIT_ENERGY,B.CURRENCY,'SalesAmt_CUR' MEASURE, A.YYYYMM, A.QTY * B.QTY 
			,B.CELL_CODE
			, A.CELL_PER_PACK, A.CELL_PER_MODULE, A.MODULE_PER_PACK,'' CELL_PROD_SITE, A.PRODUCT_GROUP
			, A.EE_CORP_ID,A.CELL_CORP_ID,A.PACK_CORP_ID, A.ALT_SIM_YN, A.PERIOD_YYMM, A.SCENARIO_TYPE,A.BASE_PRICE,A.METAL_LINK_PRICE,A.OTHER_PRICE,A.TOTAL_PRICE,A.METAL_LINK_YN,A.WORK_YYYYMMDD,A.OSP_YN, A.EXT_INT
			, 'SYSTEM', GETDATE(), 'SYSTEM', GETDATE()
			FROM DM_PLN_BIZPLAN A WITH(NOLOCK)
			INNER JOIN DM_PLN_BIZPLAN B WITH(NOLOCK) 
			ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID AND A.BIZ_TYPE = B.BIZ_TYPE 
			AND A.PLANT_SITE_ID = B.PLANT_SITE_ID AND A.FCST_TYPE = B.FCST_TYPE AND A.DOM_EXP = B.DOM_EXP AND A.INCOTERMS = B.INCOTERMS AND A.CURRENCY = B.CURRENCY AND A.YYYYMM = B.YYYYMM AND A.CELL_PROD_SITE = B.CELL_PROD_SITE
			--INNER JOIN XIF_GSC_MOVE_EXCHANGE_RATE_SN C  WITH(NOLOCK) 
			--ON A.CURRENCY = C.CURRENCY_CD
			--AND A.YYYYMM = C.PLN_YYYYMM
			WHERE 1=1 
			AND A.DIVISION_ID = @p_division_id
			AND A.MEASURE = 'Business_Plan'
			AND B.MEASURE = 'BizPlanPrice_Cur'
			AND A.DIVISION_ID = B.DIVISION_ID
			--AND C.PLN_PERIOD_YYYYMM = '202309' -- 하드코딩 ??
		END


PRINT N'SalesAmt_KRW MEASURE 데이터 생성 ==================================================================================================================================================='
		
		BEGIN
			INSERT INTO DM_PLN_BIZPLAN (SEQ, DIVISION_ID,DEPT_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,ITEM_ID,END_CUSTOMER,BIZ_TYPE,PLANT_SITE_ID,FCST_TYPE,DOM_EXP,INCOTERMS
			,ITEM_USE,UNIT_ENERGY,CURRENCY,MEASURE,YYYYMM,QTY,CELL_CODE, CELL_PER_PACK, CELL_PER_MODULE, MODULE_PER_PACK,CELL_PROD_SITE, PRODUCT_GROUP
			, EE_CORP_ID, CELL_CORP_ID, PACK_CORP_ID, ALT_SIM_YN, PERIOD_YYMM, SCENARIO_TYPE, BASE_PRICE, METAL_LINK_PRICE, OTHER_PRICE, TOTAL_PRICE,METAL_LINK_YN, WORK_YYYYMMDD, OSP_YN, EXT_INT
			,CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
			SELECT 
			ROW_NUMBER() OVER(ORDER BY A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID) SEQ, A.DIVISION_ID,B.DEPT_ID, A.PROJECT_CODE,B.PROJECT_NAME,A.SCM_SITE_ID,A.ITEM_ID,B.END_CUSTOMER,B.BIZ_TYPE,A.PLANT_SITE_ID,A.FCST_TYPE,A.DOM_EXP,A.INCOTERMS
			,'' ITEM_USE, 0.00 UNIT_ENERGY,B.CURRENCY,'SalesAmt_KRW' MEASURE, A.YYYYMM, A.QTY * B.QTY 
			,B.CELL_CODE
			, A.CELL_PER_PACK, A.CELL_PER_MODULE, A.MODULE_PER_PACK,A.CELL_PROD_SITE, A.PRODUCT_GROUP
			, A.EE_CORP_ID,A.CELL_CORP_ID,A.PACK_CORP_ID, A.ALT_SIM_YN, A.PERIOD_YYMM, A.SCENARIO_TYPE,A.BASE_PRICE,A.METAL_LINK_PRICE,A.OTHER_PRICE,A.TOTAL_PRICE,A.METAL_LINK_YN,A.WORK_YYYYMMDD,A.OSP_YN, A.EXT_INT
			, 'SYSTEM', GETDATE(), 'SYSTEM', GETDATE()
			FROM DM_PLN_BIZPLAN A  WITH(NOLOCK)
			INNER JOIN DM_PLN_BIZPLAN B  WITH(NOLOCK)
			ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID AND A.BIZ_TYPE = B.BIZ_TYPE 
			AND A.PLANT_SITE_ID = B.PLANT_SITE_ID AND A.FCST_TYPE = B.FCST_TYPE AND A.DOM_EXP = B.DOM_EXP AND A.INCOTERMS = B.INCOTERMS AND A.CURRENCY = B.CURRENCY AND A.YYYYMM = B.YYYYMM AND A.CELL_PROD_SITE = B.CELL_PROD_SITE
			WHERE 1=1 
			AND A.DIVISION_ID = @p_division_id
			AND A.MEASURE = 'Business_Plan'
			AND B.MEASURE = 'BizPlanPrice_KRW'
			AND A.DIVISION_ID = B.DIVISION_ID
		END

			   
PRINT N'판가업데이트 ==================================================================================================================================================='
-- 판가 업데이트
		BEGIN
			UPDATE DM_PLN_BIZPLAN SET BASE_PRICE = A.BASE_PRICE, METAL_LINK_PRICE = A.METAL_LINK_PRICE, OTHER_PRICE = A.OTHER_PRICE, TOTAL_PRICE = A.TOTAL_PRICE
			                        , CURRENCY = A.CURRENCY
			                        , LAST_UPDATED_BY = 'SYSTEMR_P', LAST_UPDATE_DATE = GETDATE()  
			FROM #TMP_PRICE A
			 WHERE DM_PLN_BIZPLAN.DIVISION_ID       = A.DIVISION_ID 
			   AND DM_PLN_BIZPLAN.PROJECT_CODE      = A.PROJECT_CODE
			   AND DM_PLN_BIZPLAN.SCM_SITE_ID       = A.SCM_SITE_ID
			   AND DM_PLN_BIZPLAN.ITEM_ID           = A.ITEM_ID
			   AND DM_PLN_BIZPLAN.CELL_PROD_SITE    = A.CELL_PROD_SITE
			   AND DM_PLN_BIZPLAN.YYYYMM            = A.YYYYMM
			   AND DM_PLN_BIZPLAN.MEASURE           IN ('Business_Plan', 'BizPlanPrice_Cur', 'BizPlanPrice_KRW', 'SalesAmt_CUR', 'SalesAmt_KRW')

            SET @n_insert_count = @@ROWCOUNT;
		END

	END
	ELSE IF @p_division_id = '40' -- 40번 사업부 분기 ======================================================================================================================================================================
	BEGIN
		BEGIN
			DELETE FROM DM_PLN_BIZPLAN WHERE DIVISION_ID = @p_division_id
            SET @n_del_count = @@ROWCOUNT;
		END

		--SET @v_BP_CUTOFF_VERSION = 'BP_M_20230821_V001'
		SET @v_BP_CUTOFF_VERSION = @p_version_id
		

PRINT N'판가데이터 생성 ==================================================================================================================================================='
		-- 판가 임시테이블 생성
		BEGIN
			INSERT INTO #TMP_PRICE_S (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, CURRENCY, YYYYMM, BASE_PRICE, METAL_LINK_PRICE, OTHER_PRICE, TOTAL_PRICE)

			--사업계획3차 수정[BASE/METAL/OTHERS 가 NULL일때] 40 사업부 BP_FCST_C 의 LOC 값을 BASE, TOTAL에 적용 [START]

			--기존 쿼리
			--SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE,  CURRENCY, STND_YM
			--		, 0 BASE_PRICE,0 METAL_LINK_PRICE,0 OTHER_PRICE, SUM(TOTAL_PRICE) TOTAL_PRICE
			--		FROM(
			--		SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, CASE WHEN CURRENCY = 'RMB' THEN 'CNY' ELSE CURRENCY END CURRENCY, YYYYMM AS STND_YM, 0 BASE_PRICE,0 METAL_LINK_PRICE,0 OTHER_PRICE, SUM(QTY) TOTAL_PRICE
			--		FROM DM_PLN_BP_FCST_C WITH(NOLOCK) 
			--		WHERE DIVISION_ID = @p_division_id 
			--		AND   MEASURE IN ('LOC')
			--		AND   VERSION_NO = @v_BP_CUTOFF_VERSION  
			--		AND  QTY > 0 -- 20230918 추가
			--		GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, YYYYMM, CURRENCY
			--) A GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, STND_YM,CURRENCY

			--신규 쿼리

			
           /*  2024.01.25	KCW3408   		RIGHT OUTER JOIN AA.  ==>  BB. 수정 */
			SELECT 
					BB.DIVISION_ID,BB.PROJECT_CODE,BB.SCM_SITE_ID,BB.ITEM_ID,BB.CELL_PROD_SITE,BB.CURRENCY,BB.YYYYMM
					--, AA.BASE_PRICE
					, CASE WHEN AA.BASE_PRICE IS NULL AND AA.METAL_LINK_PRICE IS NULL  AND AA.OTHER_PRICE IS NULL  THEN ISNULL(BB.TOTAL_PRICE ,0) ELSE ISNULL(AA.BASE_PRICE, 0) END BASE_PRICE
					, ISNULL(AA.METAL_LINK_PRICE,0) 
					--사업계획3차 수정[BASE/METAL/OTHERS 가 NULL일때] 40 사업부 BP_FCST_C 의 LOC 값과 TOTAL_PRICE_CUR 값이 다른경우 차이를  OHTER_PRICE에 적용 [START]
					--, CASE WHEN AA.TOTAL_PRICE IS NOT NULL AND ISNULL(AA.TOTAL_PRICE, 0) - ISNULL(BB.TOTAL_PRICE ,0) != 0 THEN ISNULL(BB.TOTAL_PRICE, 0) - ISNULL(AA.TOTAL_PRICE, 0) + AA.OTHER_PRICE 
					--  ELSE AA.OTHER_PRICE END OTHER_PRICE 
					--사업계획3차 수정[BASE/METAL/OTHERS 가 NULL일때] 40 사업부 BP_FCST_C 의 LOC 값과 TOTAL_PRICE_CUR 값이 다른경우 차이를  OHTER_PRICE에 적용 [END]

					--사업계획3차 수정[BASE/METAL/OTHERS 가 NULL일때] 40 사업부 BP_FCST_C 의 LOC 값과 TOTAL_PRICE_CUR 값이 다른경우 차이를  OHTER_PRICE에 적용 [START] 2023-10-12 이지수 선임 요청 [LOC 값과 BASE PRICE + METAL LINK 값이 동일하게]
					, CASE WHEN AA.TOTAL_PRICE IS NOT NULL AND ISNULL(AA.TOTAL_PRICE, 0) - ISNULL(BB.TOTAL_PRICE ,0) != 0 THEN ISNULL(BB.TOTAL_PRICE ,0) - (ISNULL(AA.BASE_PRICE, 0) + ISNULL(AA.METAL_LINK_PRICE, 0))
					  ELSE ISNULL(AA.OTHER_PRICE,0) END OTHER_PRICE 
					--사업계획3차 수정[BASE/METAL/OTHERS 가 NULL일때] 40 사업부 BP_FCST_C 의 LOC 값과 TOTAL_PRICE_CUR 값이 다른경우 차이를  OHTER_PRICE에 적용 [END] 2023-10-12 이지수 선임 요청 [LOC 값과 BASE PRICE + METAL LINK 값이 동일하게]

					--, AA.TOTAL_PRICE
					,  ISNULL(BB.TOTAL_PRICE ,0) TOTAL_PRICE
					--,BB.YYYYMM,BB.TOTAL_PRICE
			FROM (
					SELECT TT.DIVISION_ID, TT.PROJECT_CODE, TT.SCM_SITE_ID, TT.ITEM_ID, TT.CELL_PROD_SITE, TT.CURRENCY
							, TT.STND_YM YYYYMM, PR.BASE_PRICE, PR.METAL_LINK_PRICE
							, PR.OTHER_PRICE, PR.TOTAL_PRICE
						FROM (
								/* 2024.01.25	KCW3408   		사업계획수정[날짜 하드코딩을 수정] */
								SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, CURRENCY
									, b.BASIS_YYYYMM AS STND_YM
									,0 BASE_PRICE,0 METAL_LINK_PRICE,0 OTHER_PRICE,0 TOTAL_PRICE
								FROM DM_MST_METAL_PRICE a WITH(NOLOCK) 
								JOIN  #TEMP_SCM_SYS_CALENDAR_M b
										ON 1 = 1 
								WHERE DIVISION_ID = '40' AND MEASURE IN ('TotalPriceCur') 
								GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, CURRENCY, b.BASIS_YYYYMM  
							) TT
							LEFT JOIN (
								SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, CURRENCY, STND_YM
										, SUM(BASE_PRICE) BASE_PRICE, SUM(METAL_LINK_PRICE) METAL_LINK_PRICE, SUM(OTHER_PRICE) OTHER_PRICE, SUM(TOTAL_PRICE)  TOTAL_PRICE
								FROM(
										SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, CURRENCY, STND_YM, SUM(PRICE) BASE_PRICE,0 METAL_LINK_PRICE,0 OTHER_PRICE,0 TOTAL_PRICE     -- BASE_PRICE 사업계획3차 수정[판가MEASURE 변경] BasePriceMetalAPCur 배제
										FROM DM_MST_METAL_PRICE WITH(NOLOCK) WHERE DIVISION_ID = '40' AND MEASURE IN ('BasePriceCur', 'BasePriceChangeCur', 'BasePriceOthersCur')
										GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, STND_YM, CURRENCY
										UNION ALL
										SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, CURRENCY, STND_YM, 0 BASE_PRICE, SUM(PRICE) METAL_LINK_PRICE, 0 OTHER_PRICE,0 TOTAL_PRICE   -- METAL_LINK_PRICE 사업계획3차 수정[판가MEASURE 변경] LiDedicatedCur 추가
										FROM DM_MST_METAL_PRICE WITH(NOLOCK) WHERE DIVISION_ID = '40' AND MEASURE IN ('MetalIndexCur', 'LiDedicatedCur')
										GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, STND_YM, CURRENCY
										UNION ALL
										SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, CURRENCY, STND_YM, 0 BASE_PRICE,0 METAL_LINK_PRICE, SUM(PRICE) OTHER_PRICE,0 TOTAL_PRICE    -- OTHER_PRICE 사업계획3차 수정[판가MEASURE 변경] MdfCur, NonMetalIndexCur 추가
										FROM DM_MST_METAL_PRICE WITH(NOLOCK) WHERE DIVISION_ID = '40' AND MEASURE IN ('OtherPriceCur', 'MdfCur', 'NonMetalIndexCur')
										GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, STND_YM, CURRENCY
										UNION ALL
										SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, CURRENCY, STND_YM, 0 BASE_PRICE,0 METAL_LINK_PRICE,0 OTHER_PRICE, SUM(PRICE) TOTAL_PRICE    -- TOTAL_PRICE
										FROM DM_MST_METAL_PRICE WITH(NOLOCK) WHERE DIVISION_ID = '40' AND MEASURE IN ('TotalPriceCur')
										GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, STND_YM, CURRENCY
									) A 
								GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, STND_YM, CURRENCY
							) PR
					ON  TT. DIVISION_ID   = PR.DIVISION_ID
					AND TT.PROJECT_CODE   = PR.PROJECT_CODE
					AND TT.SCM_SITE_ID    = PR.SCM_SITE_ID
					AND TT.ITEM_ID        = PR.ITEM_ID
					AND TT.CELL_PROD_SITE = PR.CELL_PROD_SITE
					AND TT.CURRENCY = PR.CURRENCY
					AND TT.STND_YM = PR.STND_YM
			) AA RIGHT OUTER JOIN
			(
				SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, CASE WHEN CURRENCY = 'RMB' THEN 'CNY' ELSE CURRENCY END CURRENCY, YYYYMM, 0 BASE_PRICE,0 METAL_LINK_PRICE,0 OTHER_PRICE, SUM(QTY) TOTAL_PRICE
				FROM DM_PLN_BP_FCST_C WITH(NOLOCK) 
				WHERE DIVISION_ID = '40' 
				AND   MEASURE IN ('LOC')
				AND   VERSION_NO = @v_BP_CUTOFF_VERSION
				AND   QTY > 0 -- 20230918 추가
			    AND   YYYYMM BETWEEN SUBSTRING(@v_from_yyyymmdd, 1, 6) AND SUBSTRING(@v_to_yyyymmdd, 1, 6)  
				GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, YYYYMM, CURRENCY
			) BB ON AA.DIVISION_ID = BB.DIVISION_ID AND AA.PROJECT_CODE = BB.PROJECT_CODE AND AA.SCM_SITE_ID = BB.SCM_SITE_ID AND AA.ITEM_ID = BB.ITEM_ID 
			AND AA.CELL_PROD_SITE = BB.CELL_PROD_SITE AND AA.CURRENCY = BB.CURRENCY AND AA.YYYYMM = BB.YYYYMM
			ORDER BY 1,2,3,4,5,6,7
					   			 
			PRINT @v_BP_CUTOFF_VERSION

			INSERT INTO #TMP_PRICE (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, CURRENCY, YYYYMM, BASE_PRICE, METAL_LINK_PRICE, OTHER_PRICE, TOTAL_PRICE)
			SELECT A.DIVISION_ID,A.PROJECT_CODE,A.SCM_SITE_ID, A.ITEM_ID,A.CELL_PROD_SITE,A.CURRENCY,A.YYYYMM
			, B.BASE_PRICE, B.METAL_LINK_PRICE, B.OTHER_PRICE, A.TOTAL_PRICE 
			  FROM (
					SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, CASE WHEN CURRENCY = 'RMB' THEN 'CNY' ELSE CURRENCY END CURRENCY, YYYYMM, 0 BASE_PRICE,0 METAL_LINK_PRICE,0 OTHER_PRICE, SUM(QTY) TOTAL_PRICE
					FROM DM_PLN_BP_FCST_C WITH(NOLOCK) 
					WHERE DIVISION_ID = '40' 
					AND   MEASURE IN ('LOC')
					AND   VERSION_NO = @v_BP_CUTOFF_VERSION
					AND  QTY > 0 -- 20230918 추가
					AND  YYYYMM BETWEEN SUBSTRING(@v_from_yyyymmdd, 1, 6) AND SUBSTRING(@v_to_yyyymmdd, 1, 6)  
					GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CELL_PROD_SITE, YYYYMM, CURRENCY
					) A LEFT JOIN #TMP_PRICE_S B 
					ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID 
					AND A.CELL_PROD_SITE = B.CELL_PROD_SITE AND A.CURRENCY = B.CURRENCY AND A.YYYYMM = B.YYYYMM


			--사업계획3차 수정[BASE/METAL/OTHERS 가 NULL일때] 40 사업부 BP_FCST_C 의 LOC 값을 BASE, TOTAL에 적용 [END]


		END

SELECT * FROM #TMP_PRICE --WHERE DIVISION_ID IS NOT NULL AND SCM_SITE_ID = 'NT_CN_SZX' AND ITEM_ID = 'MDP2684B9A12'

PRINT N'Business_Plan MEASURE 데이터 생성 40==================================================================================================================================================='
        /*  2024.01.25	KCW3408   		사업계획수정[METAL_LINK_YN:소형 사업부: Default = N, Biz Plan Price(Master)의 'Metal Link'칼럼 값 있는 경우 → METAL_LINK_YN에 동일 반영 */

--SELECT * FROM #TEMP_SITE_ITEM WHERE 1=1 AND DIVISION_ID = @p_division_id AND PROJECT_CODE = 'Baicheng' AND ITEM_ID = 'MCCH129520B1' ORDER BY PROJECT_CODE, item_id
--SELECT * FROM DM_PLN_BP_FCST_C WHERE 1=1 AND DIVISION_ID = @p_division_id AND VERSION_NO = @v_BP_CUTOFF_VERSION AND MEASURE = 'Business_Plan' AND PROJECT_CODE = 'Baicheng' AND ITEM_ID = 'MCCH129520B1'
		-- Business_Plan MEASURE 데이터 생성
		INSERT INTO DM_PLN_BIZPLAN (SEQ, DIVISION_ID,DEPT_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,ITEM_ID,END_CUSTOMER,BIZ_TYPE,PLANT_SITE_ID,FCST_TYPE,DOM_EXP,INCOTERMS
		,ITEM_USE,UNIT_ENERGY,CURRENCY,MEASURE,YYYYMM,QTY,CELL_CODE, CELL_PER_PACK, CELL_PER_MODULE, MODULE_PER_PACK, CELL_PROD_SITE, PRODUCT_GROUP
		, EE_CORP_ID, CELL_CORP_ID, PACK_CORP_ID, ALT_SIM_YN, PERIOD_YYMM, SCENARIO_TYPE, BASE_PRICE, METAL_LINK_PRICE, METAL_LINK_YN, WORK_YYYYMMDD, OSP_YN, EXT_INT
		----사업계획3차 수정[Application Gr.] 40 사업부 SCM_MST_SITE_ITEM ATTRIBUTE5 추가 [START]
		--,ATTRIBUTE5
		----사업계획3차 수정[Application Gr.] 40 사업부 SCM_MST_SITE_ITEM ATTRIBUTE5 추가 [END]
		----사업계획3차 수정[Product Gr.(Report)] 40 사업부 SCM_MST_SITE_ITEM ATTRIBUTE6 추가 [START]
		--,ATTRIBUTE6
		----사업계획3차 수정[Product Gr.(Report)] 40 사업부 SCM_MST_SITE_ITEM ATTRIBUTE6 추가 [END]	
		----사업계획3차 수정[Product Details.(Report)] 40 사업부 SCM_MST_SITE_ITEM ATTRIBUTE7 추가 [START]
		--,ATTRIBUTE7
		----사업계획3차 수정[Product Details.(Report)] 40 사업부 SCM_MST_SITE_ITEM ATTRIBUTE7 추가 [END]	
		, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
		SELECT A.SEQ_NO, A.DIVISION_ID,ISNULL(B.DEPT_ID, ''), A.PROJECT_CODE,B.PROJECT_NAME,A.SCM_SITE_ID,A.ITEM_ID,ISNULL(B.END_CUSTOMER, ''),ISNULL(B.BIZ_TYPE, ''),ISNULL(A.PLANT_SITE_ID, ''), ISNULL(A.FCST_TYPE, ''), 'E' DOM_EXP,A.INCOTERMS
		,'' ITEM_USE, 0.00 UNIT_ENERGY,CASE WHEN A.CURRENCY = 'RMB' THEN 'CNY' ELSE A.CURRENCY END CURRENCY,'Business_Plan' MEASURE,A.YYYYMM,CONVERT(NUMERIC(30,10), SUM(A.QTY)) QTY,B.CELL_CODE
		,B.CELL_PER_CAR, B.CELL_PER_MODULE, B.MODULE_PER_CAR, A.CELL_PROD_SITE, PRODUCT_GROUP
		,'' EE_CORP_ID,'' CELL_CORP_ID,'' PACK_CORP_ID, 'N' ALT_SIM_YN,SUBSTRING(CONVERT(VARCHAR, GETDATE(), 112), 1, 6) PERIOD_YYMM,'BP' SCENARIO_TYPE,0 BASE_PRICE,0 METAL_LINK_PRICE,ISNULL(M.METAL_LINK_YN,'N') METAL_LINK_YN,'' WORK_YYYYMMDD,'' OSP_YN, 'I' EXT_INT
		----사업계획3차 수정[Application Gr.] 40 사업부 SCM_MST_SITE_ITEM ATTRIBUTE5 추가 [START]
		--,ISNULL(B.REPORT_GROUP1, '')
		----사업계획3차 수정[Application Gr.] 40 사업부 SCM_MST_SITE_ITEM ATTRIBUTE5 추가 [END]		
		----사업계획3차 수정[Product Gr.(Report)] 40 사업부 SCM_MST_SITE_ITEM ATTRIBUTE6 추가 [START]
		--,ISNULL(B.REPORT_GROUP3, '')
		----사업계획3차 수정[Product Gr.(Report)] 40 사업부 SCM_MST_SITE_ITEM ATTRIBUTE6 추가 [END]	
		----사업계획3차 수정[Product Details.(Report)] 40 사업부 SCM_MST_SITE_ITEM ATTRIBUTE7 추가 [START]
		--,ISNULL(B.REPORT_GROUP4, '')
		----사업계획3차 수정[Product Details.(Report)] 40 사업부 SCM_MST_SITE_ITEM ATTRIBUTE7 추가 [END]	


		, 'SYSTEM', GETDATE(), 'SYSTEM', GETDATE()
		FROM DM_PLN_BP_FCST_C A WITH(NOLOCK) INNER JOIN #TEMP_SITE_ITEM B  WITH(NOLOCK)
		ON A.DIVISION_ID = B.DIVISION_ID  AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID AND A.PROJECT_CODE = B.PROJECT_CODE		
		LEFT  JOIN DM_MST_METAL_PRICE_RULE M WITH (NOLOCK)
			       ON A.DIVISION_ID  = M.DIVISION_ID
			      AND A.PROJECT_CODE = M.PROJECT_CODE
			      AND A.SCM_SITE_ID  = M.SCM_SITE_ID
			      AND A.ITEM_ID	     = M.ITEM_ID
			      AND A.CELL_PROD_SITE = M.CELL_PROD_SITE
		WHERE 1=1 AND A.DIVISION_ID = @p_division_id AND VERSION_NO = @v_BP_CUTOFF_VERSION AND MEASURE = 'Business_Plan' 
		AND YYYYMM BETWEEN SUBSTRING(@v_from_yyyymmdd, 1, 6) AND SUBSTRING(@v_to_yyyymmdd, 1, 6)  
		GROUP BY A.DIVISION_ID,B.DEPT_ID, B.DEPT_NAME_KO, A.PROJECT_CODE,B.PROJECT_NAME,A.SCM_SITE_ID,A.ITEM_ID,B.END_CUSTOMER,B.BIZ_TYPE,A.PLANT_SITE_ID,A.FCST_TYPE,A.DOM_EXP,A.INCOTERMS,A.MEASURE,A.YYYYMM
		,B.CELL_CODE,B.CELL_PER_CAR, B.CELL_PER_MODULE, B.MODULE_PER_CAR, B.PRODUCT_GROUP, A.SEQ_NO, A.CURRENCY, A.CELL_PROD_SITE, B.REPORT_GROUP1, B.FORECAST_INFO_CELL_PACK_COUNT,M.METAL_LINK_YN


		BEGIN -- Business_Plan MEASURE 데이터에 0 값 데이터 생성

			-- 0 데이터 생성시 중복 방지
			BEGIN
				DELETE FROM DM_PLN_BIZPLAN WHERE QTY = 0 AND DIVISION_ID = @p_division_id
			END

			-- 가지고올 데이터를 모두 0으로 저장한다.
			BEGIN
				SET @i = 1
				SET @s = 1

				BEGIN
					SELECT ROW_NUMBER() OVER(ORDER BY PROJECT_CODE, SCM_SITE_ID, ITEM_ID) SEQ
					,DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, END_CUSTOMER, BIZ_TYPE, PLANT_SITE_ID, FCST_TYPE, DOM_EXP, INCOTERMS
					, CASE WHEN CURRENCY = 'RMB' THEN 'CNY' ELSE CURRENCY END CURRENCY, MEASURE, CELL_PROD_SITE
					,MAX(DEPT_ID) DEPT_ID
					,MAX(PROJECT_NAME) PROJECT_NAME
					--,MAX(CELL_PROD_SITE) CELL_PROD_SITE -- KEY
					,MAX(EE_CORP_ID) EE_CORP_ID
					,MAX(CELL_CORP_ID) CELL_CORP_ID
					,MAX(PACK_CORP_ID) PACK_CORP_ID
					,MAX(EXT_INT) EXT_INT
					,MAX(PRODUCT_GROUP) PRODUCT_GROUP
					,MAX(ALT_SIM_YN) ALT_SIM_YN
					,MAX(CELL_CODE) CELL_CODE
					,MAX(CELL_PER_MODULE) CELL_PER_MODULE
					,MAX(MODULE_PER_PACK) MODULE_PER_PACK
					,MAX(CELL_PER_PACK) CELL_PER_PACK
					,MAX(PERIOD_YYMM) PERIOD_YYMM
					,MAX(SCENARIO_TYPE) SCENARIO_TYPE
					,MAX(BASE_PRICE) BASE_PRICE
					,MAX(METAL_LINK_PRICE) METAL_LINK_PRICE
					,MAX(METAL_LINK_YN) METAL_LINK_YN
					,MAX(WORK_YYYYMMDD) WORK_YYYYMMDD
					,MAX(OSP_YN) OSP_YN
					,MAX(ITEM_USE) ITEM_USE
					,MAX(UNIT_ENERGY) UNIT_ENERGY
					INTO #TMP_PLN_BIZPLAN_40 
					FROM DM_PLN_BIZPLAN WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id --AND QTY <> 0  -- QTY가 0이 아닌 데이터를 추출한다.
					GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, END_CUSTOMER, BIZ_TYPE, PLANT_SITE_ID, FCST_TYPE, DOM_EXP, INCOTERMS, CURRENCY, MEASURE, CELL_PROD_SITE

					/*
					SELECT @CNT = COUNT(*) FROM #TMP_PLN_BIZPLAN_40

--SELECT * FROM #TMP_PLN_BIZPLAN_40

					WHILE @s <= @CNT
					BEGIN
						SET @i = 0
						WHILE @i <= 11
						BEGIN
							--PRINT CONVERT(NVARCHAR, @s) + '/' + CONVERT(NVARCHAR, @i)
							BEGIN
								INSERT INTO #TMP_DM_PLN_BIZPLAN_40(
								 SEQ, DIVISION_ID,DEPT_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,END_CUSTOMER,BIZ_TYPE
								,PLANT_SITE_ID,FCST_TYPE,DOM_EXP,INCOTERMS,ITEM_USE,UNIT_ENERGY,CURRENCY, MEASURE
								,YYYYMM,QTY,PROJECT_NAME,CELL_PROD_SITE,EE_CORP_ID,CELL_CORP_ID,PACK_CORP_ID
								,EXT_INT,PRODUCT_GROUP,ALT_SIM_YN,CELL_CODE,CELL_PER_MODULE,MODULE_PER_PACK
								,CELL_PER_PACK,PERIOD_YYMM,SCENARIO_TYPE,BASE_PRICE,METAL_LINK_PRICE,METAL_LINK_YN,WORK_YYYYMMDD,OSP_YN,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE)
	  							SELECT SEQ, DIVISION_ID,DEPT_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,END_CUSTOMER,BIZ_TYPE
								,PLANT_SITE_ID,FCST_TYPE,'E' DOM_EXP,INCOTERMS,ITEM_USE,UNIT_ENERGY,CASE WHEN CURRENCY = 'RMB' THEN 'CNY' ELSE CURRENCY END CURRENCY,'Business_Plan' MEASURE
								,SUBSTRING(CONVERT(NVARCHAR, DATEADD(MONTH, @i, '202401' + '01'), 112), 1, 6) YYYYMM, 0 QTY,PROJECT_NAME,CELL_PROD_SITE,EE_CORP_ID,CELL_CORP_ID,PACK_CORP_ID
								,EXT_INT,PRODUCT_GROUP,ALT_SIM_YN,CELL_CODE,CELL_PER_MODULE,MODULE_PER_PACK
								,CELL_PER_PACK,PERIOD_YYMM,SCENARIO_TYPE,BASE_PRICE,METAL_LINK_PRICE,METAL_LINK_YN,WORK_YYYYMMDD,OSP_YN, 'SYSTEM', GETDATE(), 'SYSTEM', GETDATE()
								FROM #TMP_PLN_BIZPLAN_40 WITH(NOLOCK)
								WHERE SEQ = @s
							END

							SET @i = @i + 1
						END

						SET @s = @s + 1
					END
					*/
					/* 2024.01.25	KCW3408   		사업계획수정[날짜 하드코딩을 수정] */
					BEGIN
						INSERT INTO #TMP_DM_PLN_BIZPLAN_40(
						 SEQ, DIVISION_ID,DEPT_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,END_CUSTOMER,BIZ_TYPE
						,PLANT_SITE_ID,FCST_TYPE,DOM_EXP,INCOTERMS,ITEM_USE,UNIT_ENERGY,CURRENCY, MEASURE
						,YYYYMM,QTY,PROJECT_NAME,CELL_PROD_SITE,EE_CORP_ID,CELL_CORP_ID,PACK_CORP_ID
						,EXT_INT,PRODUCT_GROUP,ALT_SIM_YN,CELL_CODE,CELL_PER_MODULE,MODULE_PER_PACK
						,CELL_PER_PACK,PERIOD_YYMM,SCENARIO_TYPE,BASE_PRICE,METAL_LINK_PRICE,METAL_LINK_YN,WORK_YYYYMMDD,OSP_YN,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE)
	  					SELECT SEQ, DIVISION_ID,DEPT_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,END_CUSTOMER,BIZ_TYPE
						,PLANT_SITE_ID,FCST_TYPE,'E' DOM_EXP,INCOTERMS,ITEM_USE,UNIT_ENERGY,CASE WHEN CURRENCY = 'RMB' THEN 'CNY' ELSE CURRENCY END CURRENCY,'Business_Plan' MEASURE
						,B.BASIS_YYYYMM AS YYYYMM, 0 QTY,PROJECT_NAME,CELL_PROD_SITE,EE_CORP_ID,CELL_CORP_ID,PACK_CORP_ID
						,EXT_INT,PRODUCT_GROUP,ALT_SIM_YN,CELL_CODE,CELL_PER_MODULE,MODULE_PER_PACK
						,CELL_PER_PACK,PERIOD_YYMM,SCENARIO_TYPE,BASE_PRICE,METAL_LINK_PRICE,METAL_LINK_YN,WORK_YYYYMMDD,OSP_YN, 'SYSTEM', GETDATE(), 'SYSTEM', GETDATE()
						FROM #TMP_PLN_BIZPLAN_40  A WITH(NOLOCK)
						JOIN #TEMP_SCM_SYS_CALENDAR_M b
							 ON 1 = 1 
					END 
					   
				END

			END

			-- 중복방지를 위해 DM_PLN_BIZPLAN 과 동일한 데이터를 삭제
			BEGIN
				DELETE FROM #TMP_DM_PLN_BIZPLAN_40 FROM #TMP_DM_PLN_BIZPLAN_40 A INNER JOIN DM_PLN_BIZPLAN B
				ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID AND A.DOM_EXP = B.DOM_EXP AND  A.FCST_TYPE = B.FCST_TYPE 
				AND A.END_CUSTOMER = B.END_CUSTOMER AND A.BIZ_TYPE = B.BIZ_TYPE AND A.INCOTERMS = B.INCOTERMS AND A.PLANT_SITE_ID = B.PLANT_SITE_ID AND A.MEASURE = B.MEASURE AND A.YYYYMM = B.YYYYMM AND A.CELL_PROD_SITE = B.CELL_PROD_SITE
				WHERE B.QTY > 0 AND B.DIVISION_ID = @p_division_id AND A.CURRENCY = B.CURRENCY
			END

--SELECT * FROM #TMP_DM_PLN_BIZPLAN_40

PRINT N'0  데이터 생성40 ==================================================================================================================================================='
			-- 모든 일자를 0으로 만든 데이터를 DM_PLN_BIZPLAN에 저장한다.
			BEGIN
				INSERT INTO DM_PLN_BIZPLAN(
				 SEQ, DIVISION_ID,DEPT_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,END_CUSTOMER,BIZ_TYPE
				,PLANT_SITE_ID,FCST_TYPE,DOM_EXP,INCOTERMS,ITEM_USE,UNIT_ENERGY,CURRENCY,MEASURE
				,YYYYMM,QTY,PROJECT_NAME,CELL_PROD_SITE,EE_CORP_ID,CELL_CORP_ID,PACK_CORP_ID
				,EXT_INT,PRODUCT_GROUP,ALT_SIM_YN,CELL_CODE,CELL_PER_MODULE,MODULE_PER_PACK
				,CELL_PER_PACK,PERIOD_YYMM,SCENARIO_TYPE,BASE_PRICE,METAL_LINK_PRICE,METAL_LINK_YN,WORK_YYYYMMDD,OSP_YN,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE)
				SELECT SEQ, DIVISION_ID,DEPT_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,END_CUSTOMER,BIZ_TYPE
				,PLANT_SITE_ID,FCST_TYPE,'E' DOM_EXP,INCOTERMS,ITEM_USE,UNIT_ENERGY,CASE WHEN CURRENCY = 'RMB' THEN 'CNY' ELSE CURRENCY END CURRENCY,MEASURE
				,YYYYMM,QTY,PROJECT_NAME,CELL_PROD_SITE,EE_CORP_ID,CELL_CORP_ID,PACK_CORP_ID
				,EXT_INT,PRODUCT_GROUP,ALT_SIM_YN,CELL_CODE,CELL_PER_MODULE,MODULE_PER_PACK
				,CELL_PER_PACK,PERIOD_YYMM,SCENARIO_TYPE,BASE_PRICE,METAL_LINK_PRICE,METAL_LINK_YN,WORK_YYYYMMDD,OSP_YN,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE 
				 FROM #TMP_DM_PLN_BIZPLAN_40 WITH(NOLOCK)
			END

		END


-- 판가 업데이트


	--SELECT * FROM #TMP_PRICE 

		--BEGIN
		--	UPDATE DM_PLN_BIZPLAN SET 
		--	                         CURRENCY = A.CURRENCY
		--	                        , LAST_UPDATED_BY = 'SYSTEMR_P', LAST_UPDATE_DATE = GETDATE()  
		--	FROM #TMP_PRICE A
		--	 WHERE DM_PLN_BIZPLAN.DIVISION_ID       = A.DIVISION_ID 
		--	   AND DM_PLN_BIZPLAN.PROJECT_CODE      = A.PROJECT_CODE
		--	   AND DM_PLN_BIZPLAN.SCM_SITE_ID       = A.SCM_SITE_ID
		--	   AND DM_PLN_BIZPLAN.ITEM_ID           = A.ITEM_ID
		--	   AND DM_PLN_BIZPLAN.CELL_PROD_SITE    = A.CELL_PROD_SITE
		--	   AND DM_PLN_BIZPLAN.YYYYMM            = A.YYYYMM
		--	   AND DM_PLN_BIZPLAN.MEASURE           IN ('Business_Plan')

  --          SET @n_insert_count = @@ROWCOUNT;
		--END

--SELECT * FROM DM_PLN_BIZPLAN WHERE DIVISION_ID = '40'

PRINT N'BizPlanPrice_Cur MEASURE 데이터 생성 40==================================================================================================================================================='
		BEGIN
			INSERT INTO DM_PLN_BIZPLAN (SEQ, DIVISION_ID,DEPT_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,ITEM_ID,END_CUSTOMER,BIZ_TYPE,PLANT_SITE_ID,FCST_TYPE,DOM_EXP,INCOTERMS
			,ITEM_USE,UNIT_ENERGY,CURRENCY,MEASURE,YYYYMM
			,QTY
			,CELL_CODE, CELL_PER_PACK, CELL_PER_MODULE, MODULE_PER_PACK, CELL_PROD_SITE, PRODUCT_GROUP
			, EE_CORP_ID, CELL_CORP_ID, PACK_CORP_ID, ALT_SIM_YN, PERIOD_YYMM, SCENARIO_TYPE, BASE_PRICE, METAL_LINK_PRICE, OTHER_PRICE, TOTAL_PRICE, METAL_LINK_YN, WORK_YYYYMMDD, OSP_YN, EXT_INT
			,CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
			SELECT SEQ, A.DIVISION_ID,A.DEPT_ID, A.PROJECT_CODE,A.PROJECT_NAME,A.SCM_SITE_ID,A.ITEM_ID,A.END_CUSTOMER,A.BIZ_TYPE,A.PLANT_SITE_ID,A.FCST_TYPE,A.DOM_EXP,A.INCOTERMS
			,ITEM_USE, 0.00 UNIT_ENERGY, CURRENCY,'BizPlanPrice_Cur' MEASURE,A.YYYYMM
			, 0 TOTAL_PRICE
			, A.CELL_CODE,CELL_PER_PACK, A.CELL_PER_MODULE, A.MODULE_PER_PACK,A.CELL_PROD_SITE, PRODUCT_GROUP
			,EE_CORP_ID,CELL_CORP_ID,PACK_CORP_ID, ALT_SIM_YN, PERIOD_YYMM,SCENARIO_TYPE,ISNULL(A.BASE_PRICE, 0), ISNULL(A.METAL_LINK_PRICE,0), ISNULL(A.OTHER_PRICE,0), ISNULL(A.TOTAL_PRICE,0), METAL_LINK_YN,WORK_YYYYMMDD,OSP_YN, EXT_INT
			, 'SYSTEM', GETDATE(), 'SYSTEM', GETDATE()
			FROM DM_PLN_BIZPLAN A WITH(NOLOCK) --INNER JOIN #TMP_PRICE B WITH(NOLOCK)
			WHERE A.MEASURE           = 'Business_Plan'
			      AND A.DIVISION_ID       = '40'


			BEGIN
				UPDATE DM_PLN_BIZPLAN SET QTY = A.TOTAL_PRICE, TOTAL_PRICE = A.TOTAL_PRICE, LAST_UPDATED_BY = 'SYSTEMR_P', LAST_UPDATE_DATE = GETDATE()  
				  FROM #TMP_PRICE A
				 WHERE DM_PLN_BIZPLAN.DIVISION_ID       = A.DIVISION_ID 
				   AND DM_PLN_BIZPLAN.PROJECT_CODE      = A.PROJECT_CODE
				   AND DM_PLN_BIZPLAN.SCM_SITE_ID       = A.SCM_SITE_ID
				   AND DM_PLN_BIZPLAN.ITEM_ID           = A.ITEM_ID
				   AND DM_PLN_BIZPLAN.CELL_PROD_SITE    = A.CELL_PROD_SITE
				   AND DM_PLN_BIZPLAN.YYYYMM            = A.YYYYMM
				   AND DM_PLN_BIZPLAN.CURRENCY          = A.CURRENCY
				   AND DM_PLN_BIZPLAN.MEASURE           IN ('BizPlanPrice_Cur')
				   AND DM_PLN_BIZPLAN.DIVISION_ID       = @p_division_id
			END

		END

PRINT N'BizPlanPrice_KRW MEASURE 데이터 생성 40==================================================================================================================================================='


--SELECT * FROM DM_PLN_BIZPLAN WHERE DIVISION_ID = '40' AND MEASURE = 'BizPlanPrice_Cur'

			INSERT INTO DM_PLN_BIZPLAN (SEQ, DIVISION_ID,DEPT_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,ITEM_ID,END_CUSTOMER,BIZ_TYPE,PLANT_SITE_ID,FCST_TYPE,DOM_EXP,INCOTERMS
			,ITEM_USE,UNIT_ENERGY,CURRENCY,MEASURE,YYYYMM,QTY,CELL_CODE
			, CELL_PER_PACK, CELL_PER_MODULE, MODULE_PER_PACK, CELL_PROD_SITE, PRODUCT_GROUP
			, EE_CORP_ID, CELL_CORP_ID, PACK_CORP_ID, ALT_SIM_YN, PERIOD_YYMM, SCENARIO_TYPE, BASE_PRICE, METAL_LINK_PRICE, OTHER_PRICE, TOTAL_PRICE, METAL_LINK_YN, WORK_YYYYMMDD, OSP_YN, EXT_INT
			,CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
			SELECT ROW_NUMBER() OVER(ORDER BY PROJECT_CODE, SCM_SITE_ID, ITEM_ID) SEQ, A.DIVISION_ID,A.DEPT_ID, A.PROJECT_CODE,A.PROJECT_NAME,A.SCM_SITE_ID,A.ITEM_ID,A.END_CUSTOMER,A.BIZ_TYPE,A.PLANT_SITE_ID,A.FCST_TYPE,A.DOM_EXP,A.INCOTERMS
			,A.ITEM_USE, 0.00 UNIT_ENERGY,A.CURRENCY,'BizPlanPrice_KRW' MEASURE,A.YYYYMM, A.QTY * ISNULL(B.STND_PRICE, 1), A.CELL_CODE
			,A.CELL_PER_PACK, A.CELL_PER_MODULE, A.MODULE_PER_PACK,A.CELL_PROD_SITE, A.PRODUCT_GROUP
			,A.EE_CORP_ID,A.CELL_CORP_ID,A.PACK_CORP_ID, A.ALT_SIM_YN, A.PERIOD_YYMM,A.SCENARIO_TYPE,A.BASE_PRICE, A.METAL_LINK_PRICE, A.OTHER_PRICE, A.TOTAL_PRICE, A.METAL_LINK_YN,A.WORK_YYYYMMDD,A.OSP_YN, A.EXT_INT
			, 'SYSTEM', GETDATE(), 'SYSTEM', GETDATE()
			FROM (SELECT *  
			      FROM DM_PLN_BIZPLAN A WITH(NOLOCK) 
			      WHERE A.MEASURE         = 'BizPlanPrice_Cur'
			      AND A.DIVISION_ID       = @p_division_id				  
				 ) A
				 LEFT JOIN DM_MST_METAL_CURRENCY_PRICE B WITH(NOLOCK) 
			ON A.DIVISION_ID           = B.DIVISION_ID 
			   AND A.CURRENCY          = B.METAL_CURRENCY
			   AND A.YYYYMM            = B.STND_YM
		/*   
			SELECT ROW_NUMBER() OVER(ORDER BY PROJECT_CODE, SCM_SITE_ID, ITEM_ID) SEQ, A.DIVISION_ID,A.DEPT_ID, A.PROJECT_CODE,A.PROJECT_NAME,A.SCM_SITE_ID,A.ITEM_ID,A.END_CUSTOMER,A.BIZ_TYPE,A.PLANT_SITE_ID,A.FCST_TYPE,A.DOM_EXP,A.INCOTERMS
			,A.ITEM_USE, 0.00 UNIT_ENERGY,A.CURRENCY,'BizPlanPrice_KRW' MEASURE,A.YYYYMM, A.QTY * B.STND_PRICE, A.CELL_CODE
			,A.CELL_PER_PACK, A.CELL_PER_MODULE, A.MODULE_PER_PACK,A.CELL_PROD_SITE, A.PRODUCT_GROUP
			,A.EE_CORP_ID,A.CELL_CORP_ID,A.PACK_CORP_ID, A.ALT_SIM_YN, A.PERIOD_YYMM,A.SCENARIO_TYPE,A.BASE_PRICE, A.METAL_LINK_PRICE, A.OTHER_PRICE, A.TOTAL_PRICE, A.METAL_LINK_YN,A.WORK_YYYYMMDD,A.OSP_YN, A.EXT_INT
			, 'SYSTEM', GETDATE(), 'SYSTEM', GETDATE()
			FROM DM_PLN_BIZPLAN A WITH(NOLOCK) INNER JOIN DM_MST_METAL_CURRENCY_PRICE B WITH(NOLOCK)
			ON A.DIVISION_ID           = B.DIVISION_ID 
			   AND A.CURRENCY          = B.METAL_CURRENCY
			   AND A.YYYYMM            = B.STND_YM
			   AND A.MEASURE           = 'BizPlanPrice_Cur'
			   AND A.DIVISION_ID       = @p_division_id
			*/


PRINT N'SalesAmt_CUR MEASURE 데이터 생성 40==================================================================================================================================================='


		BEGIN
			INSERT INTO DM_PLN_BIZPLAN (SEQ, DIVISION_ID,DEPT_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,ITEM_ID,END_CUSTOMER,BIZ_TYPE,PLANT_SITE_ID,FCST_TYPE,DOM_EXP,INCOTERMS
			,ITEM_USE,UNIT_ENERGY,CURRENCY,MEASURE,YYYYMM,QTY,CELL_CODE, CELL_PER_PACK, CELL_PER_MODULE, MODULE_PER_PACK,CELL_PROD_SITE, PRODUCT_GROUP
			, EE_CORP_ID, CELL_CORP_ID, PACK_CORP_ID, ALT_SIM_YN, PERIOD_YYMM, SCENARIO_TYPE, BASE_PRICE, METAL_LINK_PRICE, OTHER_PRICE, TOTAL_PRICE,METAL_LINK_YN, WORK_YYYYMMDD, OSP_YN, EXT_INT
			,CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
			SELECT 
			 ROW_NUMBER() OVER(ORDER BY A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID) SEQ, A.DIVISION_ID,B.DEPT_ID, A.PROJECT_CODE,B.PROJECT_NAME,A.SCM_SITE_ID,A.ITEM_ID,B.END_CUSTOMER,B.BIZ_TYPE,A.PLANT_SITE_ID,A.FCST_TYPE,A.DOM_EXP,A.INCOTERMS
			,A.ITEM_USE, A.UNIT_ENERGY,B.CURRENCY,'SalesAmt_CUR' MEASURE, A.YYYYMM, A.QTY * B.QTY 
			,B.CELL_CODE
			, A.CELL_PER_PACK, A.CELL_PER_MODULE, A.MODULE_PER_PACK,A.CELL_PROD_SITE, A.PRODUCT_GROUP
			, A.EE_CORP_ID,A.CELL_CORP_ID,A.PACK_CORP_ID, A.ALT_SIM_YN, A.PERIOD_YYMM, A.SCENARIO_TYPE,A.BASE_PRICE,A.METAL_LINK_PRICE,A.OTHER_PRICE,A.TOTAL_PRICE,A.METAL_LINK_YN,A.WORK_YYYYMMDD,A.OSP_YN, 'I' EXT_INT
			, 'SYSTEM', GETDATE(), 'SYSTEM', GETDATE()
			FROM DM_PLN_BIZPLAN A  WITH(NOLOCK)
			INNER JOIN DM_PLN_BIZPLAN B  WITH(NOLOCK)
			ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.PROJECT_NAME = B.PROJECT_NAME AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID AND A.END_CUSTOMER = B.END_CUSTOMER
			AND A.FCST_TYPE = B.FCST_TYPE AND A.DOM_EXP = B.DOM_EXP AND A.INCOTERMS = B.INCOTERMS AND A.CURRENCY = B.CURRENCY AND A.YYYYMM = B.YYYYMM AND A.CELL_PROD_SITE = B.CELL_PROD_SITE
			
			WHERE 1=1 
			AND A.DIVISION_ID = @p_division_id
			AND A.MEASURE = 'Business_Plan'
			AND B.MEASURE = 'BizPlanPrice_Cur'
			AND A.DIVISION_ID = B.DIVISION_ID

		END


PRINT N'SalesAmt_KRW MEASURE 데이터 생성 ==================================================================================================================================================='

		BEGIN
			INSERT INTO DM_PLN_BIZPLAN (SEQ, DIVISION_ID,DEPT_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,ITEM_ID,END_CUSTOMER,BIZ_TYPE,PLANT_SITE_ID,FCST_TYPE,DOM_EXP,INCOTERMS
			,ITEM_USE,UNIT_ENERGY,CURRENCY,MEASURE,YYYYMM,QTY,CELL_CODE, CELL_PER_PACK, CELL_PER_MODULE, MODULE_PER_PACK,CELL_PROD_SITE, PRODUCT_GROUP
			, EE_CORP_ID, CELL_CORP_ID, PACK_CORP_ID, ALT_SIM_YN, PERIOD_YYMM, SCENARIO_TYPE, BASE_PRICE, METAL_LINK_PRICE, OTHER_PRICE, TOTAL_PRICE,METAL_LINK_YN, WORK_YYYYMMDD, OSP_YN, EXT_INT
			,CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
			SELECT 
			ROW_NUMBER() OVER(ORDER BY A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID) SEQ, A.DIVISION_ID,B.DEPT_ID, A.PROJECT_CODE,B.PROJECT_NAME,A.SCM_SITE_ID,A.ITEM_ID,B.END_CUSTOMER,B.BIZ_TYPE,A.PLANT_SITE_ID,A.FCST_TYPE,A.DOM_EXP,A.INCOTERMS
			,A.ITEM_USE, A.UNIT_ENERGY,A.CURRENCY,'SalesAmt_KRW' MEASURE, A.YYYYMM, A.QTY * B.QTY 
			,B.CELL_CODE
			, A.CELL_PER_PACK, A.CELL_PER_MODULE, A.MODULE_PER_PACK,A.CELL_PROD_SITE, A.PRODUCT_GROUP
			, A.EE_CORP_ID,A.CELL_CORP_ID,A.PACK_CORP_ID, A.ALT_SIM_YN, A.PERIOD_YYMM, A.SCENARIO_TYPE,A.BASE_PRICE,A.METAL_LINK_PRICE,A.OTHER_PRICE,A.TOTAL_PRICE,A.METAL_LINK_YN,A.WORK_YYYYMMDD,A.OSP_YN, 'I' EXT_INT
			, 'SYSTEM', GETDATE(), 'SYSTEM', GETDATE()
			FROM DM_PLN_BIZPLAN A  WITH(NOLOCK)
			INNER JOIN DM_PLN_BIZPLAN B  WITH(NOLOCK)
			ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.PROJECT_NAME = B.PROJECT_NAME AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID AND A.END_CUSTOMER = B.END_CUSTOMER
			AND A.FCST_TYPE = B.FCST_TYPE AND A.DOM_EXP = B.DOM_EXP AND A.INCOTERMS = B.INCOTERMS AND A.CURRENCY = B.CURRENCY AND A.YYYYMM = B.YYYYMM AND A.CELL_PROD_SITE = B.CELL_PROD_SITE
			WHERE 1=1 
			AND A.DIVISION_ID = @p_division_id
			AND A.MEASURE = 'Business_Plan'
			AND B.MEASURE = 'BizPlanPrice_KRW'
			AND A.CURRENCY = B.CURRENCY
			AND A.DIVISION_ID = B.DIVISION_ID
		END

PRINT N'Application Gr, Product Gr.(Report), Product Details.(Report) 업데이트 ========================================================================================='
		--사업계획3차 수정[Application Gr.] 40 사업부 SCM_MST_SITE_ITEM ATTRIBUTE5 추가 [START]
		UPDATE DM_PLN_BIZPLAN SET ATTRIBUTE5 = ISNULL(B.REPORT_GROUP1, ''), ATTRIBUTE6 = ISNULL(B.REPORT_GROUP3, ''), ATTRIBUTE7 = ISNULL(B.REPORT_GROUP4, '')
		, CELL_PER_PACK = ISNULL(CONVERT(NVARCHAR, B.FORECAST_INFO_CELL_PACK_COUNT), 0) --[Cell환산자 데이터 출처 변경 ] 소형사업부 CELL_PACK_COUNT 컬럼에서 CELL_PER_PACK 변경
		--, ATTRIBUTE8 = ISNULL(CONVERT(NVARCHAR, B.FORECAST_INFO_CELL_PACK_COUNT), '')
		FROM #TEMP_SITE_ITEM B  WITH(NOLOCK)
		WHERE DM_PLN_BIZPLAN.DIVISION_ID = B.DIVISION_ID 
		AND DM_PLN_BIZPLAN.SCM_SITE_ID = B.SCM_SITE_ID 
		AND DM_PLN_BIZPLAN.ITEM_ID = B.ITEM_ID 
		AND DM_PLN_BIZPLAN.PROJECT_CODE = B.PROJECT_CODE
		--사업계획3차 수정[Application Gr.] 40 사업부 SCM_MST_SITE_ITEM ATTRIBUTE5 추가 [END]

PRINT N'판가업데이트 ==================================================================================================================================================='
			   
PRINT N'판가업데이트 ==================================================================================================================================================='
-- 판가 업데이트



		BEGIN
			UPDATE DM_PLN_BIZPLAN SET BASE_PRICE = A.BASE_PRICE, METAL_LINK_PRICE = A.METAL_LINK_PRICE, OTHER_PRICE = A.OTHER_PRICE, TOTAL_PRICE = A.TOTAL_PRICE, LAST_UPDATED_BY = 'SYSTEMR_P', LAST_UPDATE_DATE = GETDATE()  
			FROM #TMP_PRICE A
			 WHERE DM_PLN_BIZPLAN.DIVISION_ID       = A.DIVISION_ID 
			   AND DM_PLN_BIZPLAN.PROJECT_CODE      = A.PROJECT_CODE
			   AND DM_PLN_BIZPLAN.SCM_SITE_ID       = A.SCM_SITE_ID
			   AND DM_PLN_BIZPLAN.ITEM_ID           = A.ITEM_ID
			   AND DM_PLN_BIZPLAN.CELL_PROD_SITE    = A.CELL_PROD_SITE
			   AND DM_PLN_BIZPLAN.YYYYMM            = A.YYYYMM
			   AND DM_PLN_BIZPLAN.CURRENCY          = A.CURRENCY
			   --AND DM_PLN_BIZPLAN.MEASURE           IN ('Business_Plan', 'BizPlanPrice_KRW', 'SalesAmt_CUR', 'SalesAmt_KRW')
			   AND DM_PLN_BIZPLAN.MEASURE           IN ('Business_Plan', 'BizPlanPrice_KRW', 'SalesAmt_CUR', 'SalesAmt_KRW')
			   AND DM_PLN_BIZPLAN.DIVISION_ID       = @p_division_id

            SET @n_insert_count = @@ROWCOUNT;
		END
			   		 	  	  	   
	END



	
	END_PKUPDATE:

	-- 트랜잭션 (COMMIT)
	COMMIT WORK;
	END TRY


    --------------------------------------------------------------
    BEGIN CATCH
    --------------------------------------------------------------
    -- ROLLBACK
    -- 트랜잭션 (END)
    ROLLBACK TRANSACTION SAVE_DM_PLN_BP_FCST;
    -- ERROR LOG VALUE SAVE
    SET @v_log_type = 'ERROR';
    SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
    SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
    SET @d_event_date = SYSDATETIME();
    SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


    --------------------------------------------------------------
    END CATCH;
    --------------------------------------------------------------

    -- 수행결과 성공여부 DISPLAY
    IF @v_log_message IS NULL
	SELECT 'success'
	
    ;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = @p_division_id + ' : delete_count= ' + Convert(NVARCHAR(10), @n_del_count) + ' / insert_count= ' + Convert(NVARCHAR(10), @n_insert_count)  ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;


  -- 트랜잭션 (END)
  ERR_RTN:
  IF @v_log_type = 'INVALID'
   BEGIN
       ROLLBACK TRANSACTION;
       SET @v_description = @p_division_id + ' : delete_count= ' + Convert(NVARCHAR(10), @n_del_count) +  ' / insert_count= ' + Convert(NVARCHAR(10), @n_insert_count)  ;
	SET @d_event_date = SYSDATETIME();
       EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	   
    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = @p_division_id + ' : delete_count= ' + Convert(NVARCHAR(10), @n_del_count) + ' / insert_count= ' + Convert(NVARCHAR(10), @n_insert_count)  ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
  END
