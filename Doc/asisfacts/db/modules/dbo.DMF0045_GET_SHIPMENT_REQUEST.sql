---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*

EXEC DMF0045_GET_SHIPMENT_REQUEST
  @p_sheet_name     = 'Pack Biz',
  @p_division_id    = '82',
  @p_team_id        = '',
  @p_customer       = '',
  @p_scm_site_id    = '',
  @p_plant_site_id  = '',
  @p_project_code   = '',
  @p_item_id        = 'EH048126P3S1', -- 'AMRSAB100-A4', -- AMDAU0134A
  @p_from_yyyymmdd  = '20200327',
  @p_to_yyyymmdd    = '20200521',
  @p_created_by		= 'hwi1993',
  @debug_mode       ='T'


  isnull 처리

*/


/*
 * Program ID   : DMF0045_GET_SHIPMENT_REQUEST
 * Description  : 출하요청 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.08.20   jsyoun         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2019.09.27   hwi1993		   없는 것들을 Plan 에 Insert 해서 하단에서 집계하는 방식이 아니라, 있는 것만 넣어놓고 마지막에 Measure 테이블하고 JOIN 하는 방식으로 변경함.
 * 2019.10.08   hwi1993		   SiteMove, Intl Move 만 있는 것들도 모든 메저 표시
 * 2019.10.25   hwi1993		   확정구간 수정
 * 2019.10.29   hwi1993		   DEPT_NAME_KO 수정
 * 2019.10.30   hwi1993		   Cell Biz 에대해 BOH 에 LocationCode ( 'FORMATION_CHECK_PACKAGING' ) 추가
 * 2019.11.08   hwi1993		   Item 에서 FromSite 로 BOH기준 변경
 * 2019.12.23	hwi1993		   SITE_MOVE 에서 Ship Req 가져오는 로직 변경
 * 2020.01.29	hwi1993		   [CSR 요청번호:C20200121-000352] ESS Pack_FP 로직 변경
 * 2020.02.19	hwi1993		   하단 메저 중복오류 수정 ( FROM Site 가 없는 건들은 삭제함 ), 82 DIVSION 에 대해 FCST_TYPE 가져오는 로직 변경
 * 2020.02.25	hwi1993		   '82' 일 경우 SCP_SHIP_PLAN 을 SHIP_REQ 로 복사기능 추가
 * 2020.03.19	hwi1993		   'ShIP_PLAN' 메저의 FCST_TYPE 변경, SSP_ANL_SHIP_CONFIRM 과 JOIN 시 SiteType = 'Sales' 조건 제거 
 * 2020.03.27	hwi1993		   CREATED_BY 가 SYSTEM 일 경우 그대로 표시되도록 REQUESTOR 표시부분 수정
 * 2020.04.09	hwi1993		   [c20200403-000258]shipment request 화면 ess(82)기준 measure 명 및 data 자동생성 통일화 작업
 * 2020.04.27	hwi1993		   [C20200424-000357] SCP PLAN 과 82 PACK FP 를 가져올 때 FN 버전만 가져오도록 변경 & 영문일 경우 부서명이 길어서 임시테이블의 부서명 필드 길이 수정
 * 2020.06.11   KIMYONGHO	   [C20200603-000047] GSCM Shipment Request 상 MKT FCST Type 오류 건   로직 변경
 * 2020.07.10   KIMYONGHO      [C20200701-000388] [자동차/ESS] Shipment Request 화면의 FCST type 생성 Logic 변경 요청
 * 2021.05.20   SSP Pjt.       성능개선(SCM_DNM_PLAN_FROZEN_V -> SSP_DNM_FP_PLAN_FROZEN, scm_dnm_stock_v -> SSP_DNM_STOCK_C)
 * 2021.09.01   SSP Pjt.       SCP_MST_BOD_N_V 적용
 */
CREATE PROCEDURE [dbo].[DMF0045_GET_SHIPMENT_REQUEST]
  @p_sheet_name     NVARCHAR(10),
  @p_division_id    NVARCHAR(30),
  @p_team_id        NVARCHAR(MAX),
  @p_customer       NVARCHAR(MAX),
  @p_scm_site_id    NVARCHAR(MAX),
  @p_plant_site_id  NVARCHAR(MAX),
  @p_project_code   NVARCHAR(MAX),
  @p_item_id        NVARCHAR(4000),
  @p_from_yyyymmdd  NVARCHAR(8),
  @p_to_yyyymmdd    NVARCHAR(8),
  @p_created_by		NVARCHAR(50),
  @debug_mode       NVARCHAR(1)='F'
--WITH RECOMPILE
AS  
  
BEGIN
	SET NOCOUNT ON;

	DECLARE @v_program_id		NVARCHAR(8);
    DECLARE @v_stock_yyyymmdd	NVARCHAR(8);
	DECLARE @v_cutoff_date		NVARCHAR(8);
	
    DECLARE @v_user_mea_cnt      AS INT;
    DECLARE @v_biz_type			NVARCHAR(8);
	DECLARE @v_lang				NVARCHAR(200);

	DECLARE @v_sheet_name     NVARCHAR(10)
	DECLARE @v_division_id    NVARCHAR(30)
	DECLARE @v_team_id        NVARCHAR(MAX)
	DECLARE @v_customer       NVARCHAR(MAX)
	DECLARE @v_scm_site_id    NVARCHAR(MAX)
	DECLARE @v_plant_site_id  NVARCHAR(MAX)
	DECLARE @v_project_code   NVARCHAR(MAX)
	DECLARE @v_item_id        NVARCHAR(4000)
	DECLARE @v_from_yyyymmdd  NVARCHAR(8)
	DECLARE @v_to_yyyymmdd    NVARCHAR(8)
	DECLARE @v_created_by	  NVARCHAR(50)


	SET @v_sheet_name		=  @p_sheet_name;     
	SET @v_division_id  	=  @p_division_id;   
	SET @v_team_id      	=  @p_team_id;        
	SET @v_customer     	=  @p_customer;       
	SET @v_scm_site_id  	=  @p_scm_site_id;    
	SET @v_plant_site_id	=  @p_plant_site_id;  
	SET @v_project_code 	=  @p_project_code;   
	SET @v_item_id      	=  @p_item_id;        
	SET @v_from_yyyymmdd	=  @p_from_yyyymmdd;  
	SET @v_to_yyyymmdd  	=  @p_to_yyyymmdd;    
	SET @v_created_by		=  @p_created_by;		


    SET @v_program_id = 'DMF0045';
    SET @v_stock_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -3, CONVERT(VARCHAR, @p_from_yyyymmdd, 121)), 112); --FROM -3일
    SET @v_user_mea_cnt = 0;

	SELECT @v_lang = Language
	FROM dbo.TB_FX_User
	WHERE UserID = @p_created_by

	


     /********************************************************************************
    * 임시테이블만들기
    ********************************************************************************/
    -- SCP Plan용
	IF OBJECT_ID('tempdb..#TblDynamic_PLAN') IS NOT NULL
		DROP TABLE #TblDynamic_PLAN;

	-- SHIP Req용
	IF OBJECT_ID('tempdb..#TblDynamic_SHIP_REQ') IS NOT NULL
		DROP TABLE #TblDynamic_SHIP_REQ;

	-- PIVOT 용
	IF OBJECT_ID('tempdb..#TblDynamic_SHIP_PIVOT') IS NOT NULL
		DROP TABLE #TblDynamic_SHIP_PIVOT;

	-- ROW DATA 용
	IF OBJECT_ID('tempdb..#TblDynamic_SHIP_ROW') IS NOT NULL
		DROP TABLE #TblDynamic_SHIP_ROW;

	-- Requestor
	IF OBJECT_ID('tempdb..#TblDynamic_REQUESTOR') IS NOT NULL
		DROP TABLE #TblDynamic_REQUESTOR;

	-- Measure
	--IF OBJECT_ID('tempdb..#TblDynamic_MEASURE') IS NOT NULL
	--    DROP TABLE #TblDynamic_MEASURE
		
	-- BOH 계산용
	IF OBJECT_ID('tempdb..#TblDynamic_CAL_QTY') IS NOT NULL	
		DROP TABLE #TblDynamic_CAL_QTY;
		
	-- MEASURE JOIN 처리용
	IF OBJECT_ID('tempdb..#TblDynamic_MEASURE') IS NOT NULL	
		DROP TABLE #TblDynamic_MEASURE;

	-- MEASURE JOIN 처리용
	IF OBJECT_ID('tempdb..#Tbl_boh') IS NOT NULL	
		DROP TABLE #Tbl_boh;

	
	IF OBJECT_ID('tempdb..#Tbl_Loc') IS NOT NULL	
		DROP TABLE #Tbl_Loc;

	
	CREATE TABLE #tbl_Loc (
	ShtName NVARCHAR(10)
	, Division_Id NVARCHAR(30)
	, Loc_Code NVARCHAR(50)
	)


    IF @v_sheet_name = 'Pack Biz'
	BEGIN
        SELECT @v_biz_type = 'P'
		INSERT INTO #tbl_Loc VALUES ( @v_sheet_name, @v_division_id, 'PACK_OWMS')
		INSERT INTO #tbl_Loc VALUES ( @v_sheet_name, @v_division_id, 'CMA_BMA')

	END
    ELSE
	BEGIN
		SELECT  @v_biz_type = 'A'
		INSERT INTO #tbl_Loc VALUES ( @v_sheet_name, @v_division_id, 'CELL_OWMS')
		INSERT INTO #tbl_Loc VALUES ( @v_sheet_name, @v_division_id, 'FORMATION_CHECK_PACKAGING')
	END


	-- Measure 세팅
    CREATE TABLE #TblDynamic_MEASURE (
		   MEASURE			NVARCHAR(200)
		 , MEASURE_LABEL	NVARCHAR(150)
		 , BIZ_TYPE			CHAR(1)
		 , SUM_CHECK		CHAR(1)
		 , MEASURE_COLOR	NVARCHAR(20)
		 , DEL_FLAG			CHAR(1)
         , SEQ				INT
    );

	IF @v_biz_type = 'P'
	BEGIN
		INSERT INTO #TBLDYNAMIC_MEASURE ( MEASURE, MEASURE_LABEL, BIZ_TYPE, SUM_CHECK, MEASURE_COLOR, DEL_FLAG, SEQ ) VALUES (N'RTF_SCP', N'RTF_System[R+P]', N'P', N'N', '219,229,241', 'Y', 1)

		--[CSR 요청번호:C20200121-000352][c20200403-000258]
		INSERT INTO #TBLDYNAMIC_MEASURE ( MEASURE, MEASURE_LABEL, BIZ_TYPE, SUM_CHECK, MEASURE_COLOR, DEL_FLAG, SEQ )VALUES (N'SCP_SHIP_PLAN', N'SCP Ship Plan', N'P', N'A', '252,213,180', 'Y', 2)
		INSERT INTO #TBLDYNAMIC_MEASURE ( MEASURE, MEASURE_LABEL, BIZ_TYPE, SUM_CHECK, MEASURE_COLOR, DEL_FLAG, SEQ )VALUES (N'SHIP_REQ', N'Ship Req', N'P', N'N', '215,227,188', 'Y', 3)
		INSERT INTO #TBLDYNAMIC_MEASURE ( MEASURE, MEASURE_LABEL, BIZ_TYPE, SUM_CHECK, MEASURE_COLOR, DEL_FLAG, SEQ )VALUES (N'SHIP_PLAN', N'Ship Plan', N'P', N'N', '255,255,255', 'Y', 4)
		INSERT INTO #TBLDYNAMIC_MEASURE ( MEASURE, MEASURE_LABEL, BIZ_TYPE, SUM_CHECK, MEASURE_COLOR, DEL_FLAG, SEQ )VALUES (N'PACK_FP', N'Pack FP', N'P', N'Y', '219,229,241', 'Y', 5)
		INSERT INTO #TBLDYNAMIC_MEASURE ( MEASURE, MEASURE_LABEL, BIZ_TYPE, SUM_CHECK, MEASURE_COLOR, DEL_FLAG, SEQ )VALUES (N'TOTAL_PLAN', N'Total(Plan)', N'P', N'Y', '219,229,241', 'Y', 6)
		INSERT INTO #TBLDYNAMIC_MEASURE ( MEASURE, MEASURE_LABEL, BIZ_TYPE, SUM_CHECK, MEASURE_COLOR, DEL_FLAG, SEQ )VALUES (N'TOTAL_REQ', N'Total(Req)', N'P', N'Y', '219,229,241', 'Y', 7)
		INSERT INTO #TBLDYNAMIC_MEASURE ( MEASURE, MEASURE_LABEL, BIZ_TYPE, SUM_CHECK, MEASURE_COLOR, DEL_FLAG, SEQ )VALUES (N'WH_BOH_PLAN', N'W/H BOH(Plan)', N'P', N'Y', '219,229,241', 'Y', 8)
		INSERT INTO #TBLDYNAMIC_MEASURE ( MEASURE, MEASURE_LABEL, BIZ_TYPE, SUM_CHECK, MEASURE_COLOR, DEL_FLAG, SEQ )VALUES (N'WH_BOH_REQ', N'W/H BOH(Req)', N'P', N'Y', '219,229,241', 'Y', 9)
	END
	ELSE
	BEGIN
		INSERT INTO #TBLDYNAMIC_MEASURE ( MEASURE, MEASURE_LABEL, BIZ_TYPE, SUM_CHECK, MEASURE_COLOR, DEL_FLAG, SEQ )VALUES (N'RTF_SCP', N'RTF_System[R+P]', N'A', N'N', '219,229,241', 'Y', 1)

		--[CSR 요청번호:C20200121-000352][c20200403-000258]
		INSERT INTO #TBLDYNAMIC_MEASURE ( MEASURE, MEASURE_LABEL, BIZ_TYPE, SUM_CHECK, MEASURE_COLOR, DEL_FLAG, SEQ )VALUES (N'SCP_SHIP_PLAN', N'SCP Ship Plan', N'A', N'A', '252,213,180', 'Y', 2)
		INSERT INTO #TBLDYNAMIC_MEASURE ( MEASURE, MEASURE_LABEL, BIZ_TYPE, SUM_CHECK, MEASURE_COLOR, DEL_FLAG, SEQ )VALUES (N'SHIP_REQ', N'Ship Req', N'A', N'N', '215,227,188', 'Y', 3)
		INSERT INTO #TBLDYNAMIC_MEASURE ( MEASURE, MEASURE_LABEL, BIZ_TYPE, SUM_CHECK, MEASURE_COLOR, DEL_FLAG, SEQ )VALUES (N'SHIP_PLAN', N'Ship Plan', N'A', N'N', '255,255,255', 'Y', 4)
		INSERT INTO #TBLDYNAMIC_MEASURE ( MEASURE, MEASURE_LABEL, BIZ_TYPE, SUM_CHECK, MEASURE_COLOR, DEL_FLAG, SEQ )VALUES (N'SITE_MOVE', N'Site-Move Plan', N'A', N'Y', '219,229,241', 'Y', 5)
		INSERT INTO #TBLDYNAMIC_MEASURE ( MEASURE, MEASURE_LABEL, BIZ_TYPE, SUM_CHECK, MEASURE_COLOR, DEL_FLAG, SEQ )VALUES (N'INTN_MOVEMENT', N'Internal movement', N'A', N'Y', '219,229,241', 'Y', 6)
		INSERT INTO #TBLDYNAMIC_MEASURE ( MEASURE, MEASURE_LABEL, BIZ_TYPE, SUM_CHECK, MEASURE_COLOR, DEL_FLAG, SEQ )VALUES (N'INSP_PLAN', N'Inspection plan', N'A', N'Y', '219,229,241', 'Y', 7)
		INSERT INTO #TBLDYNAMIC_MEASURE ( MEASURE, MEASURE_LABEL, BIZ_TYPE, SUM_CHECK, MEASURE_COLOR, DEL_FLAG, SEQ )VALUES (N'TOTAL_PLAN', N'Total(Plan)', N'A', N'Y', '219,229,241', 'Y', 8)
		INSERT INTO #TBLDYNAMIC_MEASURE ( MEASURE, MEASURE_LABEL, BIZ_TYPE, SUM_CHECK, MEASURE_COLOR, DEL_FLAG, SEQ )VALUES (N'TOTAL_REQ', N'Total(Req)', N'A', N'Y', '219,229,241', 'Y', 9)
		INSERT INTO #TBLDYNAMIC_MEASURE ( MEASURE, MEASURE_LABEL, BIZ_TYPE, SUM_CHECK, MEASURE_COLOR, DEL_FLAG, SEQ )VALUES (N'WH_BOH_PLAN', N'W/H BOH(Plan)', N'A', N'Y', '219,229,241', 'Y', 10)
		INSERT INTO #TBLDYNAMIC_MEASURE ( MEASURE, MEASURE_LABEL, BIZ_TYPE, SUM_CHECK, MEASURE_COLOR, DEL_FLAG, SEQ )VALUES (N'WH_BOH_REQ', N'W/H BOH(Req)', N'A', N'Y', '219,229,241', 'Y', 11)
	END

	-- 사용자메저 처리
	SELECT @V_USER_MEA_CNT = COUNT(*)
	  FROM [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
	 WHERE U.PROGRAM_ID				= @v_program_id
       AND U.SHEET_NAME				= @v_sheet_name
	   AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
       AND U.USER_ID				= @v_created_by;


	IF @V_USER_MEA_CNT = 0
	BEGIN	    

		INSERT INTO [dbo].[SCM_MST_TITLESET_USER] (
		       USER_ID
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
		SELECT @v_created_by
		     , C.PROGRAM_ID
			 , C.SHEET_NAME
			 , 'M'
			 , C.COLUMN_NAME
			 , C.SORT_ORDER_NO
			 , 'N'
			 , ''
			 , @v_created_by
			 , CONVERT(varchar(19), GETDATE(), 121)
			 , @v_created_by
			 , CONVERT(varchar(19), GETDATE(), 121)
		  FROM [dbo].[SCM_MST_SHEET_MEASURE] C WITH(NOLOCK)
		 WHERE 1 = 1
		   AND C.PROGRAM_ID  = @v_program_id
		   AND C.SHEET_NAME  = @v_sheet_name
		   AND C.DEFAULT_FLAG = 'Y'
		   AND C.VALID_YN     = 'Y'	;			
	END;
	
	
	UPDATE A
	   SET DEL_FLAG			= 'N'
	  FROM #TBLDYNAMIC_MEASURE A
	       JOIN SCM_MST_TITLESET_USER B 
		ON A.MEASURE		= B.COLUMN_NAME 
	   AND B.PROGRAM_ID		= @v_program_id 
	   AND B.SHEET_NAME		= @v_sheet_name 
	   AND B.USER_ID		= @v_created_by 
	   AND B.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
	
    CREATE TABLE #TblDynamic_SHIP_REQ (
           DIVISION_ID		NVARCHAR(30)
         , ITEM_ID			NVARCHAR(50)
         , FROM_SITE		NVARCHAR(30)
         , TO_SITE			NVARCHAR(30)
         , DEPT				NVARCHAR(250)
         , END_CUSTOMER		NVARCHAR(50)
         , PROJECT_CODE		NVARCHAR(50)
         , INCOTERMS		NVARCHAR(10)
         , FCST_TYPE		NVARCHAR(10)
         , TR_MODE			NVARCHAR(50)
         , BOD_ID			NVARCHAR(50)
         , MEASURE			NVARCHAR(50)
         , YYYYMMDD			NVARCHAR(8)
         , CREATED_BY		NVARCHAR(30)
         , QTY				NUMERIC(20,10)
         , SEQ				INT
		 , RN				INT
    );

	CREATE TABLE #TblDynamic_PLAN (
           DIVISION_ID		NVARCHAR(30)
         , ITEM_ID			NVARCHAR(50)
		 , FROM_SITE		NVARCHAR(30)
         , TO_SITE			NVARCHAR(30)
         , DEPT				NVARCHAR(250)
         , END_CUSTOMER		NVARCHAR(50)
		 , PROJECT_CODE		NVARCHAR(50)
         , INCOTERMS		NVARCHAR(10)
         , FCST_TYPE		NVARCHAR(10)
         , TR_MODE			NVARCHAR(50)
         , BOD_ID			NVARCHAR(50)
         , MEASURE			NVARCHAR(50)
         , YYYYMMDD			NVARCHAR(8)
         , QTY				NUMERIC(20,10)
         , SEQ				INT
	);


    CREATE TABLE #TblDynamic_SHIP_ROW (
		   DIVISION_ID		NVARCHAR(30)
		 , ITEM_ID			NVARCHAR(50)
		 , NICK_NAME		NVARCHAR(500)
		 , FROM_SITE		NVARCHAR(30)
		 , TO_SITE			NVARCHAR(30)
		 , DEPT				NVARCHAR(250)
		 , END_CUSTOMER		NVARCHAR(50)
		 , PROJECT_CODE		NVARCHAR(50)
		 , INCOTERMS		NVARCHAR(10)
		 , FCST_TYPE		NVARCHAR(10)
		 , TR_MODE			NVARCHAR(50)
		 , BOD_ID			NVARCHAR(50)
		 , MEASURE			NVARCHAR(50)
		 , YYYYMMDD			NVARCHAR(8)
		 , QTY				NUMERIC(20,10)
		 , SEQ				INT
    );

	
	CREATE TABLE #TblDynamic_CAL_QTY (
		   DIVISION_ID		NVARCHAR(30)	
		 , ITEM_ID			NVARCHAR(50)
		 , NICK_NAME		NVARCHAR(500)
		 , FROM_SITE		NVARCHAR(30)
		 , YYYYMMDD			NVARCHAR(8)
		 , PLAN_QTY			NUMERIC(20,10)
		 , REQ_QTY			NUMERIC(20,10)
	);


    PRINT '-------------START!--------------: ' +  CONVERT(CHAR(23), getdate(), 21)

    -----------------------------------------------
    -- 3. Ship Req : 출하 요청(Sales향 Ship Req)
    --               DM_PLN_SHIPMENT_REQ / MEASURE = 'SHIP_REQ'
   -----------------------------------------------
    INSERT INTO #TblDynamic_SHIP_REQ
    SELECT R.DIVISION_ID
         , R.ITEM_ID
         , R.PLANT_SITE_ID			AS FROM_SITE
         , R.SCM_SITE_ID			AS TO_SITE
         , CASE @v_lang WHEN 'EN' THEN DP.DEPT_NAME_EN
						WHEN 'CN' THEN DP.DEPT_NAME_CN
						ELSE DP.DEPT_NAME_KO
		   END						AS DEPT
         , TS.END_CUSTOMER
         , R.PROJECT_CODE
         , R.INCOTERMS
         , CASE WHEN R.FCST_TYPE = '-' THEN '' ELSE R.FCST_TYPE END
         , R.TRANSPORT_MODE       AS TR_MODE
         , R.BOD_ID
         , 'SHIP_REQ'             AS MEASURE
         , R.YYYYMMDD
         , R.LAST_UPDATED_BY      AS CREATED_BY
         , R.QTY
         , 3                     AS SEQ
         , RANK() OVER(PARTITION BY R.DIVISION_ID, R.ITEM_ID, R.PLANT_SITE_ID, R.SCM_SITE_ID, R.PROJECT_CODE, R.FCST_TYPE
                                  , R.INCOTERMS, R.TRANSPORT_MODE ORDER BY R.LAST_UPDATE_DATE DESC) AS RN
      FROM DM_PLN_SHIPMENT_REQ AS R WITH(NOLOCK)
           INNER JOIN SCM_MST_SITE AS TS WITH(NOLOCK)  
		ON R.DIVISION_ID = TS.DIVISION_ID
	   AND R.SCM_SITE_ID = TS.SCM_SITE_ID
       AND TS.VALID_YN   = 'Y'
           INNER JOIN (SELECT DISTINCT DIVISION_ID, ITEM_ID, SCP_OPERATION_GROUP
                         FROM SCM_MST_ITEM_SN WITH (NOLOCK)
                        WHERE DIVISION_ID = @v_division_id
						AND ACTIVE_FLAG = 'Y'
						AND SCP_OPERATION_GROUP = @v_biz_type  -- CELL/PACK 구분
                      ) IT 
		ON R.DIVISION_ID = IT.DIVISION_ID 
	   AND R.ITEM_ID = IT.ITEM_ID
		   LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO AS DP WITH(NOLOCK) 
		ON TS.DEPT_ID = DP.DEPT_ID
     WHERE 1 = 1
	   AND R.DIVISION_ID      = @v_division_id -- 변수
	   AND R.MEASURE          = 'SHIP_REQ' 
	   AND R.YYYYMMDD        >= @v_from_yyyymmdd
	   AND R.YYYYMMDD        <= @v_to_yyyymmdd
	   AND R.QTY             >  0
	   AND R.SITE_TYPE        = 'SALES'
	   --AND ( ( @v_division_id IS NULL OR @v_division_id ='' ) OR R.DIVISION_ID IN (SELECT token FROM dbo.String_Split(@v_division_id,',')) )
	   AND ( ( @v_team_id IS NULL OR  @v_team_id     ='' ) OR TS.DEPT_ID   IN (SELECT token FROM dbo.String_Split(@v_team_id    ,',')) )
		--AND ( ( @v_customer IS NULL OR  @v_customer ='' ) OR TS.END_CUSTOMER   IN (SELECT token FROM dbo.String_Split(@v_customer    ,',')) )
		--AND ( ( @v_scm_site_id IS NULL OR  @v_scm_site_id     ='' ) OR R.SCM_SITE_ID   IN (SELECT token FROM dbo.String_Split(@v_scm_site_id    ,',')) )
		AND ( ( @v_plant_site_id IS NULL OR  @v_plant_site_id     ='' ) OR R.PLANT_SITE_ID   IN (SELECT token FROM dbo.String_Split(@v_plant_site_id  ,',')) )
		--AND ( ( @v_project_code IS NULL OR  @v_project_code     ='' ) OR R.PROJECT_CODE   IN (SELECT token FROM dbo.String_Split(@v_project_code    ,',')) )
		AND ( ( @v_item_id IS NULL OR @v_item_id ='' )  OR R.ITEM_ID IN (SELECT token FROM dbo.String_Split(@v_item_id,',')) )
		AND R.SCM_SITE_ID NOT IN (	
		                         SELECT SEGMENT1 
		                           FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
								  WHERE LOOKUP_TYPE		= 'AS_SITE_PLANT'
								    AND VALID_YN			= 'Y'
									AND SEGMENT3 = @v_division_id
								 )
		;
		--SELECT * fROM #TblDynamic_SHIP_REQ;

    PRINT '-------------SHIP REQ------------: ' +  CONVERT(CHAR(23), getdate(), 21)



   -----------------------------------------------
    -- 1. RTF 
    -----------------------------------------------
	-- FromSite 를 Global PSI 에서 Div, Item_Id, To_Site, Incoterms 기준으로 찾아와서 사용한다. ( MKT FCST 의 FromSite 는 의미가 없다고 함 )
	-- 과거 구간을 포함할 경우( 과거가 지나치게 길 경우 ) Global PSI 의 MaxVersion 선택시 문제가 있음.


	-- SCP FINAL PLAN INFO
	DECLARE @v_scp_plan_start_yyyymmdd    NVARCHAR(8);
	DECLARE @v_scp_plan_type              NVARCHAR(10); 
	DECLARE @v_scp_seq                    INTEGER ;    


	SELECT TOP 1 
		   @v_scp_plan_start_yyyymmdd = A.PLAN_START_YYYYMMDD 
	,      @v_scp_plan_type           = A.PLAN_TYPE 
	,      @v_scp_seq                 = A.PLAN_SEQ   
	FROM   SCP_PLAN_VERSION_V A WITH(NOLOCK) 
	WHERE  1=1 
	AND    A.DIVISION_ID = @v_division_id
	AND    A.PLAN_CYCLE  = 'WEEKLY'
	AND    A.PLAN_TYPE   = 'FN'
	ORDER BY PLAN_START_YYYYMMDD DESC , PLAN_TYPE_ORDER DESC , PLAN_SEQ DESC 
    ; 


    PRINT '-------------RTF-----------------: ' +  CONVERT(CHAR(23), getdate(), 21)

	--[C20200701-000388]
	-- SCP_ANL_SHIPMENT_PLAN_FG에는 없는 FCST_TYPE 추출을 위해 
	-- SCP_ANL_SHIPMENT_PLAN_FG의 원천인SCP_PLN_SHIPMENT_PLAN_PEGGING + SCP_PLN_SHIPMENT_PLAN 으로 생성     
	IF OBJECT_ID('tempdb..#TMP_SCP_PLN_SHIPMENT_PLAN_FG') IS NOT NULL
		DROP TABLE #TMP_SCP_ANL_SHIPMENT_PLAN_FG

	SELECT DIVISION_ID                        
		  ,PLAN_START_YYYYMMDD                        
		  ,PLAN_TYPE                 
		  ,SEQ                        
		  ,MAX(OPERATION_GROUP)     AS BIZ_TYPE                   
		  ,ISNULL(PROJECT_CODE,'-') AS PROJECT_CODE                
		  ,FCST_TYPE
		  ,ITEM_ID                        
		  ,TO_SITE                        
		  ,INCOTERMS                        
		  ,FROM_SITE                        
		  ,BOD_ID                        
		  ,TRANSPORT_MODE                        
		  ,MEASURE                        
		  ,YYYYMMDD                         
		  ,SUM(QTY) AS QTY                      -- sum                        
	  INTO #TMP_SCP_ANL_SHIPMENT_PLAN_FG
	  FROM (                        
		   SELECT        
				  B.DIVISION_ID                        
				 ,B.PLAN_START_YYYYMMDD                      -- plan주의 월요일  ,dbo.FN_GET_BUCKET_YYYYMMDD(0)                         
				 ,B.PLAN_TYPE                        
				 ,B.SEQ                          
				 ,B.OPERATION_GROUP                        
				 ,A.PROJECT_CODE 
				 ,A.FCST_TYPE                        
				 ,B.ITEM_ID                        
				 ,B.TO_SITE                    
				 ,(SELECT TOP 1 X.SSP_INCOTERMS                      
				 		FROM SCP_MST_BOD_N_V X WITH(NOLOCK)                        
				 	WHERE X.DIVISION_ID  = B.DIVISION_ID                        
				 		AND X.BOD_ID       = B.BOD_ID )  AS INCOTERMS 
				 ,B.FROM_SITE                        
				 ,B.BOD_ID                         
				 ,B.TRANSPORT_MODE                        
				 ,B.MEASURE                 
				 ,B.YYYYMMDD                        
				 ,A.ALLOCATION_QTY         AS QTY   
			 FROM DBO.SCP_PLN_SHIPMENT_PLAN_PEGGING A WITH (NOLOCK)                         
			      LEFT OUTER JOIN  SCP_PLN_SHIPMENT_PLAN B WITH (NOLOCK,index(IX04_SCP_PLN_SHIPMENT_PLAN))                    
			   ON 1 = 1      
			  AND A.MASTER_ID             = B.MASTER_ID
			  AND A.PLAN_ID               = B.PLAN_ID
			  AND A.OUT_VERSION_ID        = B.OUT_VERSION_ID		
		      AND A.DIVISION_ID           = B.DIVISION_ID                        
			  AND A.PLAN_START_YYYYMMDD   = B.PLAN_START_YYYYMMDD                
			  AND A.PLAN_TYPE             = B.PLAN_TYPE                          
			  AND A.SEQ                   = B.SEQ                               
			  AND A.ORDER_ID              = B.ORDER_ID                 
			  AND A.DIVISION_ID           = @v_division_id               
			  AND A.PLAN_START_YYYYMMDD   = @v_scp_plan_start_yyyymmdd                    
			  AND A.PLAN_TYPE             = @v_scp_plan_type                  
			  AND A.SEQ                   = @v_scp_seq                      
			  AND B.MEASURE               = 'SHIP_PLAN'                
			  AND B.SEMI_YN               = 'N'                      
			  --AND A.ENG_DEMAND_ID        <> 'UNPEGGING' 
			WHERE 1 = 1                        
			  AND A.DIVISION_ID         = @v_division_id                  
			  AND A.PLAN_START_YYYYMMDD = @v_scp_plan_start_yyyymmdd                          
			  AND A.PLAN_TYPE           = @v_scp_plan_type                        
			  AND A.SEQ                 = @v_scp_seq                            
			  AND B.DIVISION_ID         is not null           
			  --AND A.ENG_DEMAND_ID        <> 'UNPEGGING' 
			  AND B.YYYYMMDD >= @v_from_yyyymmdd
			  AND B.YYYYMMDD <= @v_to_yyyymmdd
			  AND B.OPERATION_GROUP = @V_BIZ_TYPE
			  AND B.TO_SITE NOT IN (	
		                         SELECT SEGMENT1 
		                           FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
								  WHERE LOOKUP_TYPE		= 'AS_SITE_PLANT'
								    AND VALID_YN			= 'Y'
									AND SEGMENT3 = @v_division_id
								 )

	       ) X                        
	   GROUP BY                        
			 DIVISION_ID                        
		    ,PLAN_START_YYYYMMDD                        
		    ,PLAN_TYPE                
		    ,SEQ                        
		    ,ISNULL(PROJECT_CODE,'-')    
		    ,FCST_TYPE              
		    ,ITEM_ID                        
		    ,TO_SITE                        
		    ,INCOTERMS                        
		    ,FROM_SITE                        
		    ,TRANSPORT_MODE                        
		    ,BOD_ID                        
		    ,MEASURE                        
		    ,YYYYMMDD      
		;

    PRINT '-------------SCP_SHIP_PLAN_FG----: ' +  CONVERT(CHAR(23), getdate(), 21)   
	
	-- 82 일 경우 RTF 대신 SCP_Ship_plan 추가
	--[CSR 요청번호:C20200121-000352]
	--[c20200403-000258]
		INSERT INTO #TblDynamic_PLAN 
		SELECT A.DIVISION_ID												
			 , A.ITEM_ID													
			 , A.FROM_SITE 
			 , A.TO_SITE
			 , CASE @v_lang WHEN 'EN' THEN DP.DEPT_NAME_EN
			 	            WHEN 'CN' THEN DP.DEPT_NAME_CN
			 	            ELSE DP.DEPT_NAME_KO
			   END			AS DEPT
			 , C.END_CUSTOMER AS END_CUSTOMER
			 , A.PROJECT_CODE
			 , A.INCOTERMS
			 , ISNULL(A.FCST_TYPE,'') AS FCST_TYPE
			 , A.TRANSPORT_MODE AS TR_MODE
			 , A.BOD_ID
			 , 'SCP_SHIP_PLAN' AS MEASURE
			 , A.YYYYMMDD
			 , A.QTY
			 , 2 AS SEQ
		  FROM #TMP_SCP_ANL_SHIPMENT_PLAN_FG A WITH(NOLOCK) 	-- [C20200701-000388]			 
		       INNER JOIN SCM_SYS_CALENDAR_M o WITH(NOLOCK)  
			ON A.yyyymmdd = o.basis_yyyymmdd
		       JOIN SCM_MST_SITE C WITH(NOLOCK)  
			ON A.TO_SITE = C.SCM_SITE_ID 
		   AND A.DIVISION_ID = C.DIVISION_ID
		       LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO AS DP WITH(NOLOCK) 
			ON C.DEPT_ID = DP.DEPT_ID				
		 WHERE A.DIVISION_ID			= @v_division_id			
		   AND A.MEASURE				= 'SHIP_PLAN'                         
		   AND A.YYYYMMDD >= @v_from_yyyymmdd
		   AND A.YYYYMMDD <= @v_to_yyyymmdd
		   AND A.BIZ_TYPE = @V_BIZ_TYPE
		   AND ( ( @v_team_id IS NULL OR  @v_team_id     ='' ) OR C.DEPT_ID   IN (SELECT token FROM dbo.String_Split(@v_team_id    ,',')) )
		   --AND ( ( @v_customer IS NULL OR  @v_customer     ='' ) OR C.END_CUSTOMER   IN (SELECT token FROM dbo.String_Split(@v_customer    ,',')) )
		   AND ( ( @v_item_id IS NULL OR @v_item_id ='' )  OR A.ITEM_ID IN (SELECT token FROM dbo.String_Split(@v_item_id,',')) )
		   AND ( ( @v_division_id IS NULL OR @v_division_id ='' ) OR A.DIVISION_ID IN (SELECT token FROM dbo.String_Split(@v_division_id,',')) )
		   --AND ( ( @v_scm_site_id IS NULL OR  @v_scm_site_id     ='' ) OR A.TO_SITE   IN (SELECT token FROM dbo.String_Split(@v_scm_site_id    ,',')) )
		   AND ( ( @v_plant_site_id IS NULL OR  @v_plant_site_id     ='' ) OR A.FROM_SITE IN (SELECT token FROM dbo.String_Split(@v_plant_site_id    ,',')) )
		   --AND ( ( @v_project_code IS NULL OR  @v_project_code     ='' ) OR A.PROJECT_CODE IN (SELECT token FROM dbo.String_Split(@v_project_code    ,',')) )

        --AS 고객향 DM MKT_FCST 적용
		INSERT INTO #TblDynamic_PLAN 
        SELECT r.DIVISION_ID, r.item_id, r.FROM_SITE, r.TO_SITE, r.DEPT, r.END_CUSTOMER, r.PROJECT_CODE, r.INCOTERMS, r.FCST_TYPE, r.transport_mode, r.BOD_ID, r.MEASURE, r.YYYYMMDD, r.QTY, r.SEQ
          FROM (
			   SELECT Y.DIVISION_ID
				    , Y.ITEM_ID
				    , Y.PLANT_SITE_ID AS FROM_SITE
				    , Y.SCM_SITE_ID AS TO_SITE
                    , Y.DEPT
			        , Y.END_CUSTOMER AS END_CUSTOMER
				    , Y.PROJECT_CODE
				    , ISNULL(Z.SSP_INCOTERMS, Z.INCOTERMS) AS INCOTERMS
				    , Y.FCST_TYPE
				    , Z.TRANSPORT_MODE
				    , Z.BOD_ID
				    , 'SCP_SHIP_PLAN'							AS MEASURE
				    , [dbo].[FN_GET_SSP_ETD_DATE](Y.DIVISION_ID, Z.BOD_ID, Y.DM_YYYYMMDD) AS YYYYMMDD
				    , Y.QTY
				    , 2 AS SEQ
				 FROM (
				      SELECT DM.DIVISION_ID
						   , DM.PROJECT_CODE
						   , DM.SCM_SITE_ID		
						   , DM.ITEM_ID
						   , DM.FCST_TYPE
						   , DM.INCOTERMS
						   , (SELECT TOP 1 BOD_ID 
						   	    FROM SCP_MST_BOD_V --현재일 기준으로
						   	   WHERE DIVISION_ID	= DM.DIVISION_ID
						   	     AND FROM_SITE		= DM.ATTRIBUTE10
						   	     AND TO_SITE		= DM.SCM_SITE_ID
						   	     AND INCOTERMS		= DM.INCOTERMS
						   	     AND BOD_VALID_YN	= 'Y'
						   	   ORDER BY
						   		     PRIORITY
						     )	AS BOD_ID
						   , DM.ATTRIBUTE10		AS PLANT_SITE_ID
						   , DM.YYYYMMDD           AS DM_YYYYMMDD
						   , DM.QTY
						   , FS.SHIP_FROZEN
						   , TS.END_CUSTOMER
						   , CASE @v_lang WHEN 'EN' THEN DP.DEPT_NAME_EN
			 	                          WHEN 'CN' THEN DP.DEPT_NAME_CN
			 	                          ELSE DP.DEPT_NAME_KO
			 	             END	AS DEPT
						FROM DM_PLN_MKT_FCST DM WITH(NOLOCK)
							 INNER JOIN SCM_MST_SITE FS WITH(NOLOCK)
						  ON DM.DIVISION_ID		= FS.DIVISION_ID
						 AND DM.ATTRIBUTE10		= FS.SCM_SITE_ID
						 AND FS.SITE_TYPE			= 'PLANT'  
						 AND FS.OPERATION_GROUP	= CASE WHEN @V_BIZ_TYPE = 'P' THEN 'W' ELSE 'Z' END
						 AND FS.VALID_YN			= 'Y'
							 INNER JOIN SCM_MST_SITE TS WITH(NOLOCK)
						  ON DM.DIVISION_ID		= TS.DIVISION_ID
						 AND DM.SCM_SITE_ID		= TS.SCM_SITE_ID
						 AND TS.SITE_TYPE			= 'SALES'  
						 AND TS.VALID_YN			= 'Y'
							 LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO AS DP WITH(NOLOCK) 
						  ON TS.DEPT_ID = DP.DEPT_ID
						 --    INNER JOIN SCM_MST_SITE PS WITH(NOLOCK)
						 -- ON DM.DIVISION_ID		= PS.DIVISION_ID
						 --AND DM.PLANT_SITE_ID	= PS.SCM_SITE_ID
						 --AND PS.SITE_TYPE			= 'PLANT'  
						 --AND PS.OPERATION_GROUP	= @V_BIZ_TYPE
						 --AND PS.VALID_YN			= 'Y'
					  WHERE 1 = 1
						AND DM.MEASURE        = 'MKT_FCST' 
						AND ISNULL(TS.ATTRIBUTE2, 'N') = 'Y'  --자동 생성 여부
						AND DM.QTY            > 0
						AND DM.DIVISION_ID	= @v_division_id
		                AND ( ( @v_team_id IS NULL OR  @v_team_id     ='' ) OR TS.DEPT_ID   IN (SELECT token FROM dbo.String_Split(@v_team_id    ,',')) )
		                --AND ( ( @v_customer IS NULL OR  @v_customer     ='' ) OR TS.END_CUSTOMER   IN (SELECT token FROM dbo.String_Split(@v_customer    ,',')) )
		                AND ( ( @v_item_id IS NULL OR @v_item_id ='' )  OR DM.ITEM_ID IN (SELECT token FROM dbo.String_Split(@v_item_id,',')) )
		                AND ( ( @v_division_id IS NULL OR @v_division_id ='' ) OR DM.DIVISION_ID IN (SELECT token FROM dbo.String_Split(@v_division_id,',')) )
		                --AND ( ( @v_scm_site_id IS NULL OR  @v_scm_site_id     ='' ) OR DM.SCM_SITE_ID   IN (SELECT token FROM dbo.String_Split(@v_scm_site_id    ,',')) )
		                AND ( ( @v_plant_site_id IS NULL OR  @v_plant_site_id     ='' ) OR DM.ATTRIBUTE10 IN (SELECT token FROM dbo.String_Split(@v_plant_site_id    ,',')) )
		                --AND ( ( @v_project_code IS NULL OR  @v_project_code     ='' ) OR DM.PROJECT_CODE IN (SELECT token FROM dbo.String_Split(@v_project_code    ,',')) )
				      ) AS Y
						INNER JOIN SCP_MST_BOD_N_V AS Z
					 ON Y.BOD_ID = Z.BOD_ID	
			   ) AS R
 		 WHERE 1 = 1
		   AND R.YYYYMMDD		>= @v_from_yyyymmdd
		   AND R.YYYYMMDD		<= @v_to_yyyymmdd
				   

    IF @v_biz_type = 'A'
    BEGIN
        -----------------------------------------------
		-- 2019.12.23 정리
		-- 확정구간 내에서는 Ship Plan 만 가져온다.
		-- 확정구간 밖에서는 Ship Plan + Ship Req 를 가져온다.
		--> 합하면 Ship Plan 은 모두 가져오고, Ship Req는 확정구간 바깥 데이터만 가져온다. 
		-- Shipment Request SEMI 화면로직 : 확정구간 내에서는 Ship Plan 과 Req 가 별개임. 확정구간 밖에서는 Ship Plan  + Ship Req 임
		
		-- SCP Plan 을 가져오던 것을 Ship Plan 을 가져오도록 변경함 ( 2019.10.07 )
		INSERT INTO #TblDynamic_PLAN
		SELECT SSP.DIVISION_ID
			 , SSP.ITEM_ID
			 , SSP.FROM_SITE        AS FROM_SITE
			 , ''					AS TO_SITE
			 , ''					AS DEPT
			 , ''					AS END_CUSTOMER
			 , ''					AS PROJECT_CODE
			 , ''					AS INCOTERMS
			 , ''					AS FCST_TYPE
			 , ''					AS TR_MODE
			 , ''					AS BOD_ID
			 , 'SITE_MOVE'          AS MEASURE
			 , SSP.YYYYMMDD
			 , SSP.QTY
			 , 2                     AS SEQ
		  FROM SSP_ANL_SHIP_CONFIRM AS SSP WITH (NOLOCK)
			   INNER JOIN SCP_MST_BOD_N_V AS BOD WITH(NOLOCK)	
		    ON SSP.DIVISION_ID = BOD.DIVISION_ID
		   AND SSP.BOD_ID      = BOD.BOD_ID
			   INNER JOIN SCM_MST_SITE AS TS WITH(NOLOCK)	
		    ON SSP.DIVISION_ID = TS.DIVISION_ID
		   AND SSP.TO_SITE     = TS.SCM_SITE_ID
		   AND TS.SITE_TYPE    = 'PLANT'  
		   AND TS.VALID_YN     = 'Y'
			   INNER JOIN SCM_MST_SITE AS FS WITH(NOLOCK)	
			ON SSP.DIVISION_ID = FS.DIVISION_ID
		   AND SSP.FROM_SITE     = FS.SCM_SITE_ID
		   AND FS.VALID_YN     = 'Y'
		 WHERE 1 = 1
		   AND TS.PLANT_ID <> FS.PLANT_ID
		   AND SSP.division_id  = @v_division_id -- 변수  
		   AND SSP.qty         >  0
		   AND SSP.yyyymmdd    >= @v_from_yyyymmdd
		   AND SSP.yyyymmdd    <= @v_to_yyyymmdd
		   AND SSP.BIZ_TYPE		= @v_biz_type
		   AND ( ( @v_scm_site_id IS NULL OR @v_scm_site_id     ='' ) OR ssp.from_site  IN (SELECT token FROM dbo.String_Split(@v_scm_site_id    ,',')) )
		   AND ( ( @v_item_id IS NULL OR     @v_item_id         ='' ) OR ssp.item_id    IN (SELECT token FROM dbo.String_Split(@v_item_id    ,',')) )
		   AND SSP.change_type  = 'C' 
		   AND SSP.DIVISION_ID  = @v_division_id


		-- 2019.10.7 scp에서 ship_plan 이 컨펌된 수량 + Req 수량이라 req도 추가함
		INSERT INTO #TblDynamic_PLAN
		SELECT r.DIVISION_ID
			 , r.ITEM_ID
			 , r.PLANT_SITE_ID        AS FROM_SITE
			 , ''                     AS TO_SITE
			 , '' AS DEPT
			 , ''                     AS END_CUSTOMER
			 , ''                     AS PROJECT_CODE
			 , ''                     AS INCOTERMS
			 , ''					  AS FCST_TYPE
			 , ''                     AS TR_MODE
			 , ''                     AS BOD_ID
			 , 'SITE_MOVE'            AS MEASURE
			 -- , CONVERT(CHAR(8), DATEADD(DD, isnull(fs.ship_frozen,0), CONVERT(VARCHAR, R.YYYYMMDD, 121)), 112) frozen_yyyymmdd
			 , R.YYYYMMDD
			 , r.QTY
			 , 2              AS SEQ
		  FROM dm_pln_shipment_req AS r WITH(NOLOCK)
			   INNER JOIN scm_mst_site AS fs WITH(NOLOCK)	
			ON r.division_id      = fs.division_id
		   AND r.plant_site_id    = fs.scm_site_id
		   AND fs.site_type       = 'PLANT'  
		   AND fs.operation_group = @v_biz_type --'A'
		   AND fs.osp_yn          = 'N'
		   AND fs.valid_yn        = 'Y'	   
			   INNER JOIN scm_mst_site AS ts WITH(NOLOCK)	
		    ON r.division_id = ts.division_id
		   AND r.scm_site_id = ts.scm_site_id
		   AND ts.site_type  = 'PLANT'  
		   AND ts.valid_yn   = 'Y'
		 WHERE 1 = 1
		   AND r.division_id      = @v_division_id -- 변수
		   AND r.measure          = 'SHIP_REQ' -- 확정 후 수정할 것
		   AND r.yyyymmdd >= @v_from_yyyymmdd
		   AND r.yyyymmdd        <= @v_to_yyyymmdd
		   AND r.qty             >  0
		   AND ( ( @v_scm_site_id IS NULL OR         @v_scm_site_id         ='' ) OR r.plant_site_id         IN (SELECT token FROM dbo.String_Split(@v_scm_site_id    ,',')) )
		   AND ( ( @v_item_id IS NULL OR    @v_item_id         ='' )	OR r.item_id         IN (SELECT token FROM dbo.String_Split(@v_item_id    ,',')) )
		   AND r.yyyymmdd		>= CONVERT(CHAR(8), DATEADD(DD, isnull(fs.ship_frozen,0), GETDATE()), 112)		-- 2019.12.23


        PRINT '-------------SITE_MOVE SCP Plan -: ' +  CONVERT(CHAR(23), getdate(), 21)

        -----------------------------------------------
        -- 5. Internal movement
        -----------------------------------------------
        INSERT INTO #TblDynamic_PLAN
        SELECT P.DIVISION_ID
             , P.ITEM_ID
             , FS.SCM_SITE_ID					AS FROM_SITE
             , ''								AS TO_SITE
             , ''                               AS DEPT
             , ''                               AS END_CUSTOMER
             , ''                               AS PROJECT_CODE
             , ''                               AS INCOTERMS
             , ''                               AS FCST_TYPE
             , ''                               AS TR_MODE
             , ''                               AS BOD_ID
             , 'INTN_MOVEMENT' AS MEASURE
             , CONVERT(VARCHAR(8), P.PLAN_DATE, 112) AS YYYYMMDD
             --, P.INSERT_ID     AS CREATED_BY
             , P.QTY
             , 5                                    AS SEQ
          FROM SCM_DNM_CELL_INHOUSE_PLAN_SN AS P WITH(NOLOCK)
               INNER JOIN SCM_MST_SITE AS FS WITH(NOLOCK) 
			ON P.DIVISION_ID      = FS.DIVISION_ID
		   AND P.PLANT_ID         = FS.PLANT_ID
		   AND FS.SITE_TYPE       = 'PLANT'
		   AND FS.OSP_YN          = 'N'
		   AND FS.VALID_YN        = 'Y'
		   AND FS.OPERATION_GROUP = @v_biz_type
         WHERE 1 = 1
		   AND P.DIVISION_ID      = @v_division_id
		   AND P.CATEGORY         = 'MOVING'
		   AND P.PLAN_DATE      >= @v_from_yyyymmdd
		   AND P.PLAN_DATE       <= @v_to_yyyymmdd
		   AND ( ( @v_plant_site_id IS NULL OR    @v_plant_site_id         ='' ) OR FS.SCM_SITE_ID     IN (SELECT token FROM dbo.String_Split(@v_plant_site_id    ,',')) )
		   AND ( ( @v_item_id IS NULL OR         @v_item_id         ='' )  OR P.ITEM_ID         IN (SELECT token FROM dbo.String_Split(@v_item_id    ,',')) )
		   AND P.QTY             >  0

    END
	--------------------------------- CELL Biz 끝 -------------------------------------------------------------

    PRINT '-------------INTN_MOVEMENT ------: ' +  CONVERT(CHAR(23), getdate(), 21)

	

	-----------------------------------------------
    -- 2. Ship Plan : SSP(Daily) Sales향 Shipment Plan
    -----------------------------------------------
    INSERT INTO #TblDynamic_PLAN
    SELECT SSP.DIVISION_ID
         , SSP.ITEM_ID
         , SSP.FROM_SITE
         , SSP.TO_SITE
         , CASE @v_lang WHEN 'EN' THEN DP.DEPT_NAME_EN
						WHEN 'CN' THEN DP.DEPT_NAME_CN
						ELSE DP.DEPT_NAME_KO
						END	AS DEPT
         , TS.END_CUSTOMER
         , SSP.PROJECT_CODE
         , BOD.SSP_INCOTERMS          AS INCOTERMS
         , SSP.FCST_TYPE
         , BOD.TRANSPORT_MODE     AS TR_MODE
         , BOD.BOD_ID
         , 'SHIP_PLAN'            AS MEASURE
         , SSP.YYYYMMDD
         --, SSP.LAST_UPDATED_BY    AS CREATED_BY
         , SSP.QTY
         , 2                     AS SEQ
      FROM SSP_ANL_SHIP_CONFIRM SSP WITH (NOLOCK)
           INNER JOIN SCP_MST_BOD_N_V BOD WITH(NOLOCK)    
		ON SSP.DIVISION_ID = BOD.DIVISION_ID
       AND SSP.BOD_ID      = BOD.BOD_ID
           INNER JOIN SCM_MST_SITE TS WITH (NOLOCK)     
		ON SSP.DIVISION_ID = TS.DIVISION_ID
       AND SSP.TO_SITE     = TS.SCM_SITE_ID
	   AND ( TS.SITE_TYPE ='SALES' OR ( TS.SITE_TYPE ='PLANT' AND TS.OSP_YN = 'Y'))
       AND TS.VALID_YN     = 'Y'
           INNER JOIN (SELECT DISTINCT DIVISION_ID, ITEM_ID, SCP_OPERATION_GROUP
                         FROM SCM_MST_ITEM_SN WITH (NOLOCK)
						WHERE DIVISION_ID = @v_division_id
							AND SCP_OPERATION_GROUP = @v_biz_type  -- CELL/PACK 구분
							AND ACTIVE_FLAG = 'Y'
                      ) IT 
	    ON SSP.DIVISION_ID = IT.DIVISION_ID 
	   AND SSP.ITEM_ID = IT.ITEM_ID
		   LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO AS DP WITH(NOLOCK) 
		ON TS.DEPT_ID = DP.DEPT_ID
     WHERE SSP.DIVISION_ID  = @v_division_id -- 변수
	   AND SSP.QTY         >  0
	   AND SSP.YYYYMMDD    >= @v_from_yyyymmdd
	   AND SSP.YYYYMMDD    <= @v_to_yyyymmdd
	   AND SSP.CHANGE_TYPE  = 'C'
	   --AND ( ( @v_team_id IS NULL OR  @v_team_id     ='' ) OR TS.DEPT_ID   IN (SELECT token FROM dbo.String_Split(@v_team_id    ,',')) )
	   --AND ( ( @v_customer IS NULL OR  @v_customer     ='' ) OR TS.END_CUSTOMER   IN (SELECT token FROM dbo.String_Split(@v_customer    ,',')) )
	   AND ( ( @v_plant_site_id IS NULL OR    @v_plant_site_id         ='' ) OR SSP.FROM_SITE     IN (SELECT token FROM dbo.String_Split(@v_plant_site_id    ,',')) )
	   AND ( ( @v_item_id IS NULL OR         @v_item_id         ='' )  OR SSP.ITEM_ID         IN (SELECT token FROM dbo.String_Split(@v_item_id    ,',')) )
	   --AND ISNULL(SR.DIVISION_ID, SP.DIVISION_ID) IS NOT NULL
	   AND SSP.TO_SITE NOT IN (	
		                         SELECT SEGMENT1 
		                           FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
								  WHERE LOOKUP_TYPE		= 'AS_SITE_PLANT'
								    AND VALID_YN			= 'Y'
									AND SEGMENT3 = @v_division_id
								 )


     UNION ALL

    SELECT P.DIVISION_ID
		 , P.ITEM_ID
		 , P.FROM_SITE
		 , P.TO_SITE
		 , P.DEPT
		 , P.END_CUSTOMER
		 , P.PROJECT_CODE
		 , P.INCOTERMS
		 , P.FCST_TYPE
		 , P.TR_MODE
		 , P.BOD_ID
		 , 'SHIP_PLAN' AS MEASURE
		 , P.YYYYMMDD
		 , P.QTY
		 , 2           AS SEQ
      FROM #TblDynamic_SHIP_REQ P
	       LEFT OUTER JOIN SCM_MST_SITE FZ WITH(NOLOCK) 
		ON P.DIVISION_ID = FZ.DIVISION_ID 
	   AND P.FROM_SITE = FZ.SCM_SITE_ID 
	   AND FZ.VALID_YN = 'Y'
     WHERE P.YYYYMMDD >= CONVERT(NVARCHAR(8), DATEADD(DD,ISNULL(FZ.SHIP_FROZEN,0),GETDATE()),112) -- 확정구간의 다음날짜가 나오므로 >= 로 처리함

    PRINT '-------------SHIP Plan ----------: ' +  CONVERT(CHAR(23), getdate(), 21)

    -----------------------------------------------
    -- 6. TOTOAL(PLAN)
    -----------------------------------------------
    INSERT INTO #TblDynamic_PLAN
	SELECT DIVISION_ID
		 , ITEM_ID
		 , FROM_SITE      AS FROM_SITE
		 , ''             AS TO_SITE
		 , ''             AS DEPT
		 , ''             AS END_CUSTOMER
		 , ''             AS PROJECT_CODE
		 , ''             AS INCOTERMS
		 , ''             AS FCST_TYPE
		 , ''             AS TR_MODE
		 , ''             AS BOD_ID
		 , 'TOTAL_PLAN'   AS MEASURE
		 , YYYYMMDD
		 , SUM(QTY)
		 , 6					AS SEQ
	  FROM (
		   SELECT A.DIVISION_ID
			    , A.ITEM_ID
			    , FROM_SITE      AS FROM_SITE
			    , ''             AS TO_SITE
			    , ''             AS DEPT
			    , ''             AS END_CUSTOMER
			    , ''             AS PROJECT_CODE
			    , ''             AS INCOTERMS
			    , ''             AS FCST_TYPE
			    , ''             AS TR_MODE
			    , ''             AS BOD_ID
			    , 'TOTAL_PLAN'   AS MEASURE
			    , A.YYYYMMDD
			    , SUM(CASE WHEN A.MEASURE IN ( 'SHIP_PLAN', 'SITE_MOVE', 'INTN_MOVEMENT' ) THEN A.QTY ELSE 0 END)     AS QTY
			    , 6              AS SEQ
		     FROM #TblDynamic_PLAN A WITH (NOLOCK)
		    GROUP BY 
			      A.DIVISION_ID
			    , A.ITEM_ID
			    , A.YYYYMMDD
			    , A.FROM_SITE
			    , A.FROM_SITE
		   ) X
	   GROUP BY 
			 DIVISION_ID, ITEM_ID, YYYYMMDD, FROM_SITE
    ;

    PRINT '-------------TOTAL_PLAN ---------: ' +  CONVERT(CHAR(23), getdate(), 21)

    -----------------------------------------------
    -- 7. TOTOAL(REQ)
    -----------------------------------------------
    INSERT INTO #TblDynamic_PLAN
	SELECT A.DIVISION_ID
         , A.ITEM_ID
         , FROM_SITE      AS FROM_SITE
         , ''             AS TO_SITE
         , ''             AS DEPT
         , ''             AS END_CUSTOMER
         , ''             AS PROJECT_CODE
         , ''             AS INCOTERMS
         , ''             AS FCST_TYPE
         , ''             AS TR_MODE
         , ''       AS BOD_ID
         , 'TOTAL_REQ'    AS MEASURE
         , A.YYYYMMDD
         , SUM(A.QTY)     AS QTY
         , 7              AS SEQ
	FROM (
		 SELECT A.DIVISION_ID
		 	 , A.ITEM_ID
		 	 , A.FROM_SITE    AS FROM_SITE
		 	 , ''             AS TO_SITE
		 	 , ''			  AS DEPT
		 	 , ''       AS END_CUSTOMER
		 	 , ''			  AS PROJECT_CODE
		    , ''               AS INCOTERMS
		 	 , ''             AS FCST_TYPE
		 	 , ''             AS TR_MODE
		 	 , ''             AS BOD_ID
		 	 , A.MEASURE
		 	 , A.YYYYMMDD
		 	 , SUM(CASE WHEN A.MEASURE IN ( 'SHIP_REQ', 'SITE_MOVE', 'INTN_MOVEMENT' ) THEN A.QTY ELSE 0 END)     AS QTY
		 	 , 7              AS SEQ
		   FROM #TblDynamic_SHIP_REQ A WITH (NOLOCK)
		  GROUP BY A.DIVISION_ID
		 	  , A.ITEM_ID
		 	  , A.YYYYMMDD
		 	  , A.MEASURE
		 	  , A.FROM_SITE
		  UNION ALL
		 SELECT A.DIVISION_ID
		 	  , A.ITEM_ID
		 	  , A.FROM_SITE    AS FROM_SITE
		 	  , ''             AS TO_SITE
		 	  , ''             AS DEPT
		 	  , ''             AS END_CUSTOMER
		 	  , ''             AS PROJECT_CODE
		      , ''             AS INCOTERMS
		 	  , ''             AS FCST_TYPE
		 	  , ''             AS TR_MODE
		 	  , ''             AS BOD_ID
		 	  , A.MEASURE
		 	  , A.YYYYMMDD
		 	  , SUM(CASE WHEN A.MEASURE IN ( 'SHIP_REQ', 'SITE_MOVE', 'INTN_MOVEMENT' ) THEN A.QTY ELSE 0 END)     AS QTY
		 	  , 7              AS SEQ
		   FROM #TblDynamic_PLAN A WITH (NOLOCK)
		  GROUP BY 
		        A.DIVISION_ID
		 	  , A.ITEM_ID
		 	  , A.YYYYMMDD
		 	  , A.MEASURE
		 	  , A.FROM_SITE
		 ) A
	 GROUP BY 
	       A.DIVISION_ID, A.ITEM_ID, A.YYYYMMDD, A.FROM_SITE
    ; 

    PRINT '-------------TOTAL_REQ ----------: ' +  CONVERT(CHAR(23), getdate(), 21);

    IF @v_biz_type = 'P'
    BEGIN
		IF @v_division_id = '81'
        BEGIN
            -----------------------------------------------
            -- 6. PACK_FP
            -----------------------------------------------
            INSERT INTO #TblDynamic_PLAN
            SELECT FP.DIVISION_ID
				 , FP.ITEM_ID
				 , FP.SCM_SITE_ID							AS FROM_SITE
				 , ''										AS TO_SITE
				 , ''										AS DEPT
				 , ''										AS END_CUSTOMER
				 , ''										AS PROJECT_CODE
				 , ''										AS INCOTERMS
				 , ''										AS FCST_TYPE
				 , ''										AS TR_MODE
				 , ''										AS BOD_ID
				 , 'PACK_FP'									AS MEASURE
				 --, CONVERT(VARCHAR(8), FP.PLAN_DATE, 112)	AS YYYYMMDD
				 , FP.PLAN_DATE	AS YYYYMMDD
				 , FP.PLAN_QTY								AS QTY
				 , 8											AS SEQ
              FROM SSP_DNM_FP_PLAN_FROZEN FP WITH(NOLOCK)
                   INNER JOIN SCM_MST_SITE FS  
				ON FP.DIVISION_ID      = FS.DIVISION_ID
			   AND FP.SCM_SITE_ID      = FS.SCM_SITE_ID
			   AND FS.SITE_TYPE       = 'PLANT'
               AND FS.OSP_YN          = 'N'
               AND FS.VALID_YN        = 'Y'
             WHERE FP.DIVISION_ID  = @v_division_id
			   AND FP.PLAN_DATE   >= @v_from_yyyymmdd
			   AND FP.PLAN_DATE   <= @v_to_yyyymmdd
				--AND    FP.PLAN_QTY > 0
				--AND    FP.PLAN_IN_QTY  > 0
			   AND FP.OPERATION_ID IN ( SELECT B.SEGMENT4
										  FROM SCM_ADM_LOOKUP_MASTER_DETAIL A WITH(NOLOCK)
											   INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) 
										    ON  A.SEGMENT1    = B.SEGMENT1
										   AND A.LOOKUP_TYPE = 'LOCATION_GROUP'
										   AND A.SEGMENT3    = 'P' -- PACK 공정  
										   AND A.SEGMENT4    = 'Y' -- CAPA 공정 여부 
										   AND A.SEGMENT5    = 'Y' -- LINE 별 CAPA 적용 공정
										   AND A.VALID_YN    = 'Y'
										   AND B.LOOKUP_TYPE = 'LOCATION_GROUP_ROUTE'
										   AND B.VALID_YN    = 'Y'
										   AND B.SEGMENT3    = 'Y' -- CAPA 세부 공정 여부 
									  )

			   AND ( ( @v_plant_site_id IS NULL OR         @v_plant_site_id         ='' ) OR fp.scm_site_id         IN (SELECT token FROM dbo.String_Split(@v_plant_site_id    ,',')) )
			   AND ( ( @v_item_id IS NULL OR         @v_item_id         ='' )  OR fp.item_id         IN (SELECT token FROM dbo.String_Split(@v_item_id    ,',')) )
            -- A/S PLANT ETA 기준
			 UNION ALL
 			SELECT C.DIVISION_ID                            AS DIVISION_ID
				 , C.ITEM_ID                                AS ITEM_ID
				 , C.TO_SITE                                AS FROM_SITE
				 , ''										AS TO_SITE
				 , ''										AS DEPT
				 , ''										AS END_CUSTOMER
				 , ''										AS PROJECT_CODE
				 , ''										AS INCOTERMS
				 , ''										AS FCST_TYPE
				 , ''										AS TR_MODE
				 , ''										AS BOD_ID
				 , 'PACK_FP'			                    AS MEASURE  
				 , C.ETA_DATE                               AS YYYYMMDD
				 , C.QTY                                    AS QTY
				 , 8						                AS SEQ
			  FROM SSP_ANL_SHIP_CONFIRM AS C WITH(NOLOCK)
				   JOIN SCM_MST_SITE AS TS WITH(NOLOCK)
				ON C.DIVISION_ID = TS.DIVISION_ID
			   AND C.TO_SITE = TS.SCM_SITE_ID
			   AND TS.OPERATION_GROUP = 'W'
			   AND TS.SITE_TYPE = 'PLANT'
			   AND TS.VALID_YN = 'Y'
			 WHERE C.DIVISION_ID = @v_division_id
				--AND C.TO_SITE_COMPANY_ID = @p_company_id   
				AND C.QTY		> 0
				AND C.ETA_DATE >= @v_from_yyyymmdd
				AND C.ETA_DATE <=  @v_to_yyyymmdd
				AND ((@v_plant_site_id IS NULL OR @v_plant_site_id ='') OR C.TO_SITE IN (SELECT token FROM dbo.String_Split(@v_plant_site_id    ,',')))
				AND ((@v_item_id IS NULL OR @v_item_id ='')	OR C.ITEM_ID  IN (SELECT token FROM dbo.String_Split(@v_item_id    ,',')))     
				
            PRINT '-------------PACK_FP ------------: ' +  CONVERT(CHAR(23), getdate(), 21)
        END

        ELSE IF @v_division_id = '82'
		/* 해당 쿼리는 최근 2주간 실행된 SCP Plan중 가장 최신의 Plan 수량을 가져오는 쿼리로 보입니다. (Pack 대상)
			개발서버는 필요시마다 Plan을 실행하는데 82는 현재 2주 내 실행한 Plan이 없습니다. */
        BEGIN
            INSERT INTO #TblDynamic_PLAN
			SELECT SP.DIVISION_ID
				 , SP.ITEM_ID
				 , SP.SCM_SITE_ID            AS FROM_SITE
				 , ''						AS TO_SITE
				 , ''						AS DEPT
				 , ''						AS END_CUSTOMER
				 , ''						AS PROJECT_CODE
				 , ''						AS INCOTERMS
				 , ''						AS FCST_TYPE
				 , ''						AS TR_MODE
				 , ''						AS BOD_ID
				 , 'PACK_FP'       AS MEASURE    --SCP PROD Plan
				 , SP.YYYYMMDD
				 , SP.QTY
				 , 8               AS SEQ
              FROM SCP_ANL_PRODUCTION_PLAN AS SP WITH(NOLOCK)
                   INNER JOIN (SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ, PLAN_ID, MODELING_ID
									, ROW_NUMBER() OVER (ORDER BY PLAN_START_YYYYMMDD DESC, PLAN_SEQ DESC ) ROW_NUM 
								 FROM (	
								      SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ, PLAN_ID, MODELING_ID
										FROM SCP_PLAN_VERSION_V WITH(NOLOCK)
									   WHERE 1 = 1
									     AND DIVISION_ID          = @v_division_id --'82' -- 변수
									     AND PLAN_CYCLE           = 'WEEKLY'
									     AND PLAN_TYPE			= 'FN'
									     AND PLAN_START_YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -14, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
                                     ) A
							  ) PV
			    ON SP.DIVISION_ID         = PV.DIVISION_ID
			   AND SP.PLAN_START_YYYYMMDD = PV.PLAN_START_YYYYMMDD
			   AND SP.PLAN_TYPE          = PV.PLAN_TYPE
			   AND SP.SEQ                 = PV.PLAN_SEQ
			   AND PV.ROW_NUM             = 1
			   AND SP.MEASURE       = 'PROD_PLAN_AMEND'
			   AND SP.QTY                 > 0
			   AND SP.YYYYMMDD            >= @v_from_yyyymmdd
			   AND SP.YYYYMMDD            <= @v_to_yyyymmdd
                   INNER JOIN SCM_MST_SITE AS FS WITH(NOLOCK)
				ON SP.DIVISION_ID     = FS.DIVISION_ID
			   AND SP.SCM_SITE_ID     = FS.SCM_SITE_ID
			   AND FS.SITE_TYPE       = 'PLANT'  
			   AND FS.OPERATION_GROUP = 'P'
			   AND FS.VALID_YN        = 'Y'   
             WHERE SP.DIVISION_ID  = @v_division_id
				AND ( ( @v_plant_site_id IS NULL OR         @v_plant_site_id         ='' ) OR sp.scm_site_id         IN (SELECT token FROM dbo.String_Split(@v_plant_site_id    ,',')) )
				AND ( ( @v_item_id IS NULL OR         @v_item_id         ='' )  OR sp.item_id         IN (SELECT token FROM dbo.String_Split(@v_item_id    ,',')) )
            -- A/S PLANT ETA 기준
			 UNION ALL
 			SELECT C.DIVISION_ID                            AS DIVISION_ID
				 , C.ITEM_ID                                AS ITEM_ID
				 , C.TO_SITE                                AS FROM_SITE
				 , ''										AS TO_SITE
				 , ''										AS DEPT
				 , ''										AS END_CUSTOMER
				 , ''										AS PROJECT_CODE
				 , ''										AS INCOTERMS
				 , ''										AS FCST_TYPE
				 , ''										AS TR_MODE
				 , ''										AS BOD_ID
				 , 'PACK_FP'			                    AS MEASURE  
				 , C.ETA_DATE                               AS YYYYMMDD
				 , C.QTY                                    AS QTY
				 , 8						                AS SEQ
			  FROM SSP_ANL_SHIP_CONFIRM AS C WITH(NOLOCK)
				   JOIN SCM_MST_SITE AS TS WITH(NOLOCK)
				ON C.DIVISION_ID = TS.DIVISION_ID
			   AND C.TO_SITE = TS.SCM_SITE_ID
			   AND TS.OPERATION_GROUP = 'W'
			   AND TS.SITE_TYPE = 'PLANT'
			   AND TS.VALID_YN = 'Y'
			 WHERE C.DIVISION_ID = @v_division_id
				--AND C.TO_SITE_COMPANY_ID = @p_company_id   
				AND C.QTY		> 0
				AND C.ETA_DATE >= @v_from_yyyymmdd
				AND C.ETA_DATE <=  @v_to_yyyymmdd
				AND ((@v_plant_site_id IS NULL OR @v_plant_site_id ='') OR C.TO_SITE IN (SELECT token FROM dbo.String_Split(@v_plant_site_id    ,',')))
				AND ((@v_item_id IS NULL OR @v_item_id ='')	OR C.ITEM_ID  IN (SELECT token FROM dbo.String_Split(@v_item_id    ,',')))  

        END
    END


    IF @v_biz_type = 'A'
    BEGIN
        -----------------------------------------------
        -- 7. Inspection plan : FP 특성계획
        -----------------------------------------------
		INSERT INTO #TblDynamic_PLAN
		SELECT FP.DIVISION_ID
			 , FP.ITEM_ID
			 , FP.SCM_SITE_ID                                AS FROM_SITE
			 , ''                                AS TO_SITE
			 , ''                     AS DEPT
			 , ''                                AS END_CUSTOMER
			 , ''                                AS PROJECT_CODE
			 , ''                                AS INCOTERMS
			 , ''           AS FCST_TYPE
			 , ''                                AS TR_MODE
			 , ''                                AS BOD_ID
			 , 'INSP_PLAN'                       AS MEASURE
			 --, CONVERT(VARCHAR(8), FP.PLAN_DATE, 112) AS YYYYMMDD
			 , FP.PLAN_DATE AS YYYYMMDD
			 --, ''                                AS CREATED_BY
			 , FP.PLAN_QTY                       AS QTY
			 , 8    AS SEQ
		  FROM SSP_DNM_FP_PLAN_FROZEN FP WITH(NOLOCK)
		       INNER JOIN SCM_MST_SITE FS  
			ON FP.DIVISION_ID      = FS.DIVISION_ID
		   AND FP.SCM_SITE_ID      = FS.SCM_SITE_ID
		   AND FS.SITE_TYPE       = 'PLANT'
		   AND FS.OSP_YN          = 'N'
		   AND FS.VALID_YN        = 'Y'
		 WHERE FP.DIVISION_ID  = @v_division_id
		   AND FP.PLAN_DATE   >= @v_from_yyyymmdd
		   AND FP.PLAN_DATE   <= @v_to_yyyymmdd
		   --AND    FP.PLAN_QTY     > 0
		   --AND    FP.PLAN_IN_QTY  > 0
		   --  (참고) division_id <> '40' 일때는 'F6000' 데이터만 존재하므로 operation_id 조건에'F5300', 'F5500', 'F5600' 도 포함시켜도 상관없음
		   AND FP.OPERATION_ID IN (SELECT SEGMENT1 AS OPERATION_ID
		                             FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK)
		                            WHERE LOOKUP_TYPE = 'OPERATION_CHAR'
		                              AND VALID_YN = 'Y'
		                          )
		   AND ( 
		       EXISTS (SELECT 1
		                   FROM #TblDynamic_SHIP_REQ SR 
		                  WHERE SR.DIVISION_ID = FP.DIVISION_ID
		                    AND SR.ITEM_ID = FP.ITEM_ID
		              )
		       OR 
			   EXISTS (SELECT 1
		                 FROM #TblDynamic_PLAN SR 
		                WHERE SR.DIVISION_ID = FP.DIVISION_ID
		                  AND SR.ITEM_ID = FP.ITEM_ID
		              )
		       )
		   AND ( ( @v_plant_site_id IS NULL OR         @v_plant_site_id         ='' ) OR fp.scm_site_id         IN (SELECT token FROM dbo.String_Split(@v_plant_site_id    ,',')) )
		   --AND ( ( @v_item_id IS NULL OR         @v_item_id         ='' )  OR fp.item_id         IN (SELECT token FROM dbo.String_Split(@v_item_id    ,',')) )

		
		PRINT '-------------INSP_PLAN ----------: ' +  CONVERT(CHAR(23), getdate(), 21)

    END

    --SELECT DISTINCT MEASURE FROM #TblDynamic_PLAN;
    -- ROW DATA 생성
    INSERT INTO #TblDynamic_SHIP_ROW
    SELECT TOT.DIVISION_ID
         , TOT.ITEM_ID
         , MAX(ISNULL(I.NICK_NAME, ''))  AS NICK_NAME
         , TOT.FROM_SITE
         , TOT.TO_SITE
         , TOT.DEPT
         , TOT.END_CUSTOMER
         , TOT.PROJECT_CODE
         , TOT.INCOTERMS
         , TOT.FCST_TYPE
         , TOT.TR_MODE
         , NULL AS BOD_ID
         , TOT.MEASURE
         , TOT.YYYYMMDD
         , SUM(TOT.QTY)                  AS QTY
         , TOT.SEQ
      FROM (
           -- 1.RTF, 2.SHIP_PLAN, 4.TOTOAL(PLAN), 5.TOTOAL(REQ), 6.PACK FP
           SELECT DIVISION_ID
                , ITEM_ID
                , FROM_SITE
                , TO_SITE
                , DEPT
                , END_CUSTOMER
                , PROJECT_CODE
                , INCOTERMS
                , FCST_TYPE
                , TR_MODE
                , BOD_ID  
                , MEASURE
                , YYYYMMDD
                , QTY
                , SEQ
           FROM #TblDynamic_PLAN WITH(NOLOCK)
		   
           UNION ALL
		   
           -- 3.SHIP REQ 추가
           SELECT DIVISION_ID
		   	    , ITEM_ID
                , FROM_SITE
                , TO_SITE
                , DEPT
                , END_CUSTOMER
                , PROJECT_CODE
                , INCOTERMS
                , FCST_TYPE
                , TR_MODE
                , BOD_ID
                , MEASURE
                , YYYYMMDD
                , QTY
                , 3                     AS seq
             FROM #TblDynamic_SHIP_REQ WITH(NOLOCK)
           ) TOT
           LEFT JOIN (
		             SELECT DIVISION_ID, ITEM_ID, MAX(ISNULL(NICK_NAME,'')) AS NICK_NAME
                       FROM DBO.SCM_MST_ITEM_SN WITH(NOLOCK)
				      WHERE NICK_NAME IS NOT NULL
					    AND DIVISION_ID = @v_division_id
					    AND ACTIVE_FLAG = 'Y'
				      GROUP BY 
					        DIVISION_ID, ITEM_ID
                     ) I 
		ON TOT.ITEM_ID = I.ITEM_ID
       AND TOT.DIVISION_ID = I.DIVISION_ID
     GROUP BY 
	       TOT.DIVISION_ID, TOT.ITEM_ID, TOT.FROM_SITE, TOT.TO_SITE, TOT.DEPT, TOT.END_CUSTOMER, TOT.PROJECT_CODE
         , TOT.INCOTERMS, TOT.FCST_TYPE, TOT.TR_MODE, TOT.MEASURE, TOT.YYYYMMDD, TOT.SEQ
    ORDER BY 
	      TOT.DIVISION_ID, TOT.ITEM_ID, TOT.SEQ, TOT.FROM_SITE, TOT.TO_SITE DESC, TOT.TR_MODE, TOT.INCOTERMS
    ;



    PRINT '-------------Row Data -----------: ' +  CONVERT(CHAR(23), getdate(), 21);
    --SELECT * FROM #TblDynamic_SHIP_ROW WHERE MEASURE IN ('SHIP_REQ','TOTAL_REQ');

    -----------------------------------------------
    -- 8. W/H BOH(Plan) : Cell Plant의 Cell 재고 ==> 기준 확정 필요함 : Cell 특성완료 이후 창고
    --                    일자별 BOH 계산  : BOH(D+1) = BOH(D) - Ship Req(D) - Customer Req(D) - Internal movement(D) + Inspection Plan(D)
    -----------------------------------------------

	SELECT @v_cutoff_date = convert(nvarchar, max(CUTOFF_DATE), 112)
	  FROM [dbo].[SSP_DNM_STOCK_C] (nolock)
	 WHERE DIVISION_ID  = @v_division_id
	   AND CUTOFF_DATE >  @v_stock_yyyymmdd -- 현재일 - 3
	   AND CUTOFF_DATE <= @v_from_yyyymmdd -- 변수 : 현재일
	   AND STOCK_TYPE IN ('INVENTORY', 'WIP')

	DECLARE @TAB_STOCK   TABLE 
	(
		[DIVISION_ID]			[nvarchar](30) NOT NULL INDEX VIX_TAB_STOCK_01(DIVISION_ID, SCM_SITE_ID, STORAGE_ID, ITEM_ID),
		[SCM_SITE_ID]			[nvarchar](30) NOT NULL,
		[STORAGE_ID]            [nvarchar](30) NOT NULL,
		[ITEM_ID]				[nvarchar](150) NOT NULL,
		[SSP_QTY]				[numeric](28, 10) NULL,
		[YYYYMMDD]              [nvarchar](8) NULL
	)

	INSERT INTO @TAB_STOCK (
	       [DIVISION_ID]	
	      ,[SCM_SITE_ID]	
	      ,[STORAGE_ID]    
	      ,[ITEM_ID]		
	      ,[SSP_QTY]		
	      ,[YYYYMMDD]      
		  )
	SELECT 
           INV.DIVISION_ID
          ,INV.SCM_SITE_ID 
          ,INV.STORAGE_ID 
          ,INV.ITEM_ID
          ,INV.SSP_QTY     
          ,INV.CUTOFF_DATE		AS YYYYMMDD
      FROM [DBO].[SSP_DNM_STOCK_C]	INV WITH (NOLOCK)
     WHERE INV.DIVISION_ID  = @V_DIVISION_ID
       AND INV.CUTOFF_DATE  = @V_CUTOFF_DATE
	   AND INV.STOCK_TYPE IN ('INVENTORY', 'WIP')
     ;

	WITH Z AS (
		 SELECT DISTINCT DIVISION_ID
			   ,ITEM_ID
			   ,NICK_NAME
			   ,FROM_SITE
			   ,o.basis_yyyymmdd AS YYYYMMDD
		   FROM scm_sys_calendar_m AS o WITH(NOLOCK) 
			    CROSS APPLY (  
				            SELECT DISTINCT DIVISION_ID
								  ,ITEM_ID
								  ,NICK_NAME
								  ,FROM_SITE
							  FROM #TblDynamic_SHIP_ROW  WITH(NOLOCK) 
						    )  R
		  WHERE o.basis_yyyymmdd >= @v_from_yyyymmdd
		    AND o.basis_yyyymmdd <= @v_to_yyyymmdd
		 ),
	     BOH AS (   
		 /* select null as division_id, null as item_id, null as from_site, null as yyymmdd, null as qty  */
		 
		 SELECT
		 	    V.DIVISION_ID
		 	  , ITEM_ID
		 	  , FROM_SITE
		 	  , YYYYMMDD
		 	  , SUM(QTY) AS QTY
		   FROM (
		 	    SELECT inv.division_id
    	 			 , inv.item_id
   		 			 , inv.scm_site_id       AS from_site
  		 			 , @v_from_yyyymmdd		AS yyyymmdd
  		 			 , inv.ssp_qty           AS qty --SSP용
		 	      FROM @TAB_STOCK	inv
		 	           INNER JOIN (  
					              SELECT division_id, scm_site_id, operation_group, site_type
		 					        FROM scm_mst_site WITH (NOLOCK)
		 					       WHERE division_id     = @v_division_id
		 					         AND site_type       = 'PLANT' 
		 					         AND operation_group IN (@v_biz_type, 'W')
		 					         AND valid_yn        = 'Y'
		 			              ) b		
				    ON inv.division_id = b.division_id 
		 		   AND inv.scm_site_id = b.scm_site_id
		 	           INNER JOIN ( 
					              SELECT DISTINCT
		 						         a.storage_id
		 						       , a.location_code
		 						       , a.scm_site_id
		 						       , a.division_id
		 				            FROM scm_mst_location a WITH (NOLOCK)
		 						         INNER JOIN (  
										            SELECT scm_site_id  
		 										      FROM scm_mst_site
		 										     WHERE division_id     = @v_division_id
		 										       AND valid_yn        = 'Y'
		 										       AND operation_group = @v_biz_type		-- Cell Plant Site
		 									        ) b		
									  ON a.scm_site_id = b.scm_site_id 
		 						         INNER JOIN #tbl_Loc c 
									  on a.DIVISION_ID = c.Division_Id 
									 and a.LOCATION_CODE = c.Loc_Code 
									 and c.ShtName = @v_sheet_name
		 					       WHERE a.division_id = @v_division_id
		 					         AND a.valid_yn    = 'Y'
		 					         AND (storage_id IS NOT NULL AND storage_id <> '')
									 union all
									SELECT DISTINCT
										   tt0.SEGMENT4 AS STORAGE_ID
										  ,'AS' AS LOCATION_CODE
										  ,tt0.SEGMENT2 AS SCM_SITE_ID
										  ,tt0.SEGMENT1 AS DIVISION_ID
									  FROM SCM_ADM_LOOKUP_MASTER_DETAIL tt0 WITH(NOLOCK)
										   INNER JOIN SCM_MST_SITE tt1 WITH(NOLOCK)
										ON tt0.SEGMENT1 = tt1.DIVISION_ID	
									   AND tt0.SEGMENT2 = tt1.SCM_SITE_ID
									   AND tt0.SEGMENT3 = tt1.PLANT_ID
									   and tt0.LOOKUP_TYPE = 'SSP_AS_DIV_SLOC'
									   and tt0.VALID_YN = 'Y'
									   AND tt1.VALID_YN = 'Y'					
									   AND tt1.site_type = 'PLANT' 
									 WHERE 1 = 1
									   AND tt0.VALID_YN ='Y'
									   AND tt0.SEGMENT1   = @v_division_id
		 			              )  c -- 셀 storage_id 별 사용대상 조회
		 			ON inv.division_id = c.division_id 
		 		   AND inv.scm_site_id = c.scm_site_id  
		 		   AND inv.storage_id  = c.storage_id  
		 	           INNER JOIN scp_mst_final_item fi WITH (NOLOCK)	
					ON inv.division_id    = fi.division_id 
		 		   AND inv.item_id        = fi.item_id
		 		   AND fi.operation_group IN (@v_biz_type, 'W')
		 	     WHERE 1 = 1
		 	       AND @v_division_id = '81'
		 	       AND ( ( @v_scm_site_id IS NULL OR         @v_scm_site_id         ='' ) OR inv.scm_site_id         IN (SELECT token FROM dbo.String_Split(@v_scm_site_id    ,',')) )
		 	       AND ( ( @v_item_id IS NULL OR    @v_item_id     ='' )	OR inv.item_id         IN (SELECT token FROM dbo.String_Split(@v_item_id    ,',')) )
			    ) V 
		  WHERE 1 = 1
		    AND @v_division_id = '81'
		  GROUP BY 
		        DIVISION_ID, ITEM_ID, FROM_SITE, YYYYMMDD
		 --[CSR 요청번호:C20200121-000352]
		  UNION ALL
		 SELECT
		 	    V.DIVISION_ID
		 	  , ITEM_ID
		 	  , FROM_SITE
		 	  , YYYYMMDD
		 	  , SUM(QTY) AS QTY
		   FROM (
		 	    SELECT inv.division_id
    	 			 , inv.item_id
   		 			 , inv.scm_site_id       AS from_site
  		 			 , @v_from_yyyymmdd		AS yyyymmdd
  		 			 , inv.ssp_qty           AS qty --SSP용
		 	      FROM SSP_DNM_ESS_PACKER_STOCK_V AS inv WITH (NOLOCK)  
		 	           INNER JOIN (  
					              SELECT division_id, site_id, max(cutoff_date) max_cutoff_date
		 					        FROM SSP_DNM_ESS_PACKER_STOCK_V WITH (NOLOCK)
		 					       WHERE division_id  = @v_division_id
		 					         AND cutoff_date >  @V_stock_yyyymmdd -- 현재일 - 3
		 					         AND cutoff_date <= @v_from_yyyymmdd -- 변수 : 현재일
		 					       GROUP BY 
								         division_id, site_id
		 				          ) ms	
					ON inv.division_id = ms.division_id 
		 		   AND inv.site_id     = ms.site_id
		 		   AND inv.cutoff_date >  @V_stock_yyyymmdd
		 		   AND inv.cutoff_date = ms.max_cutoff_date
		 	           INNER JOIN (  
					              SELECT division_id, scm_site_id, operation_group, site_type
		 					        FROM scm_mst_site WITH(NOLOCK)
		 					       WHERE division_id     = @v_division_id
		 					         AND site_type       = 'PLANT' 
		 					         AND operation_group IN (@v_biz_type, 'W')
		 					         AND valid_yn        = 'Y'
		 				          ) b		
				    ON inv.division_id = b.division_id 
		 		   AND inv.scm_site_id = b.scm_site_id
		 	           INNER JOIN scp_mst_final_item AS fi WITH (NOLOCK)	
				    ON inv.division_id    = fi.division_id 
		 	       AND inv.item_id        = fi.item_id
		 	       AND fi.operation_group IN (@v_biz_type, 'W')
		 	     WHERE 1 = 1
		 	       AND @v_division_id = '82'
		 	       AND ( ( @v_scm_site_id IS NULL OR         @v_scm_site_id         ='' ) OR inv.scm_site_id         IN (SELECT token FROM dbo.String_Split(@v_scm_site_id    ,',')) )
		 	       AND ( ( @v_item_id IS NULL OR         @v_item_id     ='' )	OR inv.item_id         IN (SELECT token FROM dbo.String_Split(@v_item_id    ,',')) )
		        ) V 
		    WHERE 1 = 1
		      AND @v_division_id = '82'
		    GROUP BY 
			      DIVISION_ID, ITEM_ID, FROM_SITE, YYYYMMDD
	)

    INSERT INTO #TblDynamic_SHIP_ROW
	SELECT Z.DIVISION_ID
         , Z.ITEM_ID
         , Z.NICK_NAME
         , Z.FROM_SITE  AS FROM_SITE
         , ''  AS TO_SITE
         , ''  AS DEPT
         , ''  AS END_CUSTOMER
         , ''  AS PROJECT_CODE
         , ''  AS INCOTERMS
         , ''  AS FCST_TYPE
         , ''  AS TR_MODE
         , ''  AS BOD_ID
         , 'WH_BOH_PLAN' AS MEASURE
         , Z.YYYYMMDD
         , SUM(CASE WHEN X.MEASURE = 'TOTAL_PLAN' AND X.YYYYMMDD > @v_from_yyyymmdd THEN -1 * ISNULL(X.QTY,0)
				WHEN X.MEASURE <> 'TOTAL_PLAN' AND X.YYYYMMDD < Z.YYYYMMDD THEN ISNULL(X.QTY, 0)
				ELSE 0 END) + ISNULL(BOH.QTY, 0) AS QTY
         , 9 AS SEQ
      FROM Z WITH(NOLOCK)
           LEFT OUTER JOIN BOH WITH(NOLOCK)
        ON Z.DIVISION_ID       = BOH.DIVISION_ID
	   AND Z.ITEM_ID           = BOH.ITEM_ID
	   and Z.FROM_SITE			= BOH.FROM_SITE
		   LEFT OUTER JOIN #TblDynamic_PLAN X 
		ON X.DIVISION_ID = Z.DIVISION_ID 
	   AND X.FROM_SITE = Z.FROM_SITE 
	   AND X.ITEM_ID = Z.ITEM_ID 
	   AND X.YYYYMMDD <= Z.YYYYMMDD --AND X.FROM_SITE = Z.FROM_SITE
	   AND X.MEASURE IN ( 'TOTAL_PLAN' ,'PACK_FP', 'INSP_PLAN' )
     GROUP BY Z.DIVISION_ID, Z.ITEM_ID, Z.NICK_NAME,Z.YYYYMMDD, BOH.QTY, Z.FROM_SITE
	 UNION ALL
	SELECT Z.DIVISION_ID
         , Z.ITEM_ID
         , Z.NICK_NAME
         , Z.FROM_SITE  AS FROM_SITE
         , ''  AS TO_SITE
         , ''  AS DEPT
         , ''  AS END_CUSTOMER
         , ''  AS PROJECT_CODE
         , ''  AS INCOTERMS
         , ''  AS FCST_TYPE
         , ''  AS TR_MODE
         , ''  AS BOD_ID
         , 'WH_BOH_REQ' AS MEASURE
         , Z.YYYYMMDD
         , SUM( CASE WHEN X.MEASURE = 'TOTAL_REQ' AND X.YYYYMMDD > @v_from_yyyymmdd THEN -1 * ISNULL(X.QTY,0)
				WHEN X.MEASURE <> 'TOTAL_REQ' AND X.YYYYMMDD < Z.YYYYMMDD THEN ISNULL(X.QTY, 0)
				ELSE 0 END )  + ISNULL(BOH.QTY, 0) AS QTY
         , 9 AS SEQ
      FROM Z WITH(NOLOCK)
           LEFT OUTER JOIN BOH WITH(NOLOCK)
        ON Z.DIVISION_ID       = BOH.DIVISION_ID
	   AND Z.ITEM_ID           = BOH.ITEM_ID
	   and Z.FROM_SITE			= BOH.FROM_SITE
		   LEFT OUTER JOIN #TblDynamic_PLAN X 
	    ON  X.DIVISION_ID = Z.DIVISION_ID 
	   AND X.FROM_SITE = Z.FROM_SITE 
	   AND X.ITEM_ID = Z.ITEM_ID 
	   AND X.YYYYMMDD <= Z.YYYYMMDD  --AND X.FROM_SITE = Z.FROM_SITE
	   AND X.MEASURE IN ( 'TOTAL_REQ' ,'PACK_FP', 'INSP_PLAN' )
     GROUP BY 
	       Z.DIVISION_ID, Z.ITEM_ID, Z.NICK_NAME,Z.YYYYMMDD, BOH.QTY, Z.FROM_SITE


    PRINT '-------------BOH ----------------: ' +  CONVERT(CHAR(23), getdate(), 21);

--'SCP_SHIP_PLAN', 'SHIP_REQ', 'SHIP_PLAN' 메저 없는것 제거
delete a
from #TblDynamic_SHIP_ROW as a
where not exists
      (select x.DIVISION_ID, x.from_site, x.item_id from #TblDynamic_SHIP_ROW as x where x.measure in ('SCP_SHIP_PLAN', 'SHIP_REQ', 'SHIP_PLAN') 
	  and a.DIVISION_ID = x.DIVISION_ID
	  and a.FROM_SITE = x.FROM_SITE
	  and a.ITEM_ID = x.ITEM_ID
	  ) 
	  
    -----------------------------------------------
    -- 10. Requestor
    -----------------------------------------------
	SELECT DIVISION_ID
		 , ITEM_ID
         , FROM_SITE
         , TO_SITE
         , TR_MODE
         , INCOTERMS
	     , FCST_TYPE
         , MEASURE
         , CREATED_BY
      INTO #TblDynamic_REQUESTOR
	  FROM (
		   SELECT DIVISION_ID
			    , ITEM_ID
			    , FROM_SITE
			    , TO_SITE
			    , TR_MODE
			    , INCOTERMS
			    , FCST_TYPE
			    , MEASURE
			    , CREATED_BY
			    , ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, TR_MODE, INCOTERMS, FCST_TYPE, MEASURE ORDER BY RN ) AS RN2
		     FROM #TblDynamic_SHIP_REQ WITH(NOLOCK)
		--WHERE CREATED_BY <> 'SYSTEM'
		   ) X
	 WHERE RN2 = 1

    PRINT '-------------REQUESTOR ----------: ' +  CONVERT(CHAR(23), getdate(), 21);


    -- PIVOT용 Data정리
    SELECT A.DIVISION_ID
         , A.ITEM_ID
         , A.NICK_NAME
		 , A.FROM_SITE
         , A.TO_SITE
		 , A.DEPT
         , A.END_CUSTOMER
         , A.PROJECT_CODE
         , A.INCOTERMS
         , A.FCST_TYPE
         , A.TR_MODE
         , A.BOD_ID
         , A.MEASURE
         , 'D_'+A.YYYYMMDD AS YYYYMMDD
         , O.BASIS_YYYYMM AS YYYYMM
         , RIGHT(O.BASIS_YYYYMM,4)+O.ISO_WEEK AS ISO_WEEK
         , A.QTY
         , A.SEQ
      INTO #TblDynamic_SHIP_PIVOT
      FROM #TblDynamic_SHIP_ROW A WITH(NOLOCK)
           INNER JOIN SCM_SYS_CALENDAR_M AS O WITH(NOLOCK) 
		ON A.YYYYMMDD = O.BASIS_YYYYMMDD

	--20210304 KIMYONGHO 임시조치
	--조회 FILTER 조건 부정확으로 PIVOT 직전 FILTER 다시 설정
	 WHERE A. ITEM_ID IN (
	                     SELECT DISTINCT ITEM_ID 
	                       FROM #TblDynamic_SHIP_ROW TMP
	                    	    INNER JOIN SCM_MST_SITE C WITH(NOLOCK)  ON TMP.TO_SITE = C.SCM_SITE_ID AND TMP.DIVISION_ID = C.DIVISION_ID
	                      WHERE 1 = 1 
	                    	AND TMP.MEASURE IN ('SCP_SHIP_PLAN','SHIP_PLAN','SHIP_REQ')
	                    	AND ( ( @v_team_id IS NULL OR  @v_team_id     ='' ) OR C.DEPT_ID   IN (SELECT token FROM dbo.String_Split(@v_team_id    ,',')) )
	                    	AND ( ( @v_customer IS NULL OR  @v_customer     ='' ) OR TMP.END_CUSTOMER   IN (SELECT token FROM dbo.String_Split(@v_customer    ,',')) )
	                    	AND ( ( @v_item_id IS NULL OR @v_item_id ='' )  OR TMP.ITEM_ID IN (SELECT token FROM dbo.String_Split(@v_item_id,',')) )
	                    	AND ( ( @v_division_id IS NULL OR @v_division_id ='' ) OR TMP.DIVISION_ID IN (SELECT token FROM dbo.String_Split(@v_division_id,',')) )
	                    	AND ( ( @v_scm_site_id IS NULL OR  @v_scm_site_id     ='' ) OR TMP.TO_SITE   IN (SELECT token FROM dbo.String_Split(@v_scm_site_id    ,',')) )
	                    	AND ( ( @v_plant_site_id IS NULL OR  @v_plant_site_id     ='' ) OR TMP.FROM_SITE IN (SELECT token FROM dbo.String_Split(@v_plant_site_id    ,',')) )
	                    	AND ( ( @v_project_code IS NULL OR  @v_project_code     ='' ) OR TMP.PROJECT_CODE IN (SELECT token FROM dbo.String_Split(@v_project_code    ,',')) )
	                    
	                    )



	------■■■■■■■■■■■■■■■■■■■■■■■■■■  빠져있는 메저 추가 ------■■■■■■■■■■■■■■■■■■■■■■■■■

	-- SHIP_REQ, RTF, RTF_SCP 중 하나의 MEASURE 라도 있으면 아래와 같이 모든 메저를 채워준다.
	-- 개별은 TO_SITE 까지를 개별로 보고, 공통은 FROM_SITE 까지를 공통으로 본다.
	-- 공통/개별 : SHIP_REQ, RTF, RTF_SCP, SHIP_PLAN
	-- PACK/합계 : PACK_FP
	-- CELL/합계 : SITE_MOVE, INTN_MOVEMENT, INSP_PLAN
	-- 공통/합계 : TOTAL_PLAN, TOTAL_REQ, WH_BOH_PLAN, WH_BOH_REQ


	-- 개별 처리 -- 개별로 들어가야 할 MEASURE 중에 없는 것이 있으면 추가한다.
	INSERT INTO #TblDynamic_SHIP_PIVOT ( DIVISION_ID, ITEM_ID, NICK_NAME, FROM_SITE, TO_SITE, DEPT, END_CUSTOMER, PROJECT_CODE, INCOTERMS, FCST_TYPE, TR_MODE, MEASURE, YYYYMMDD, YYYYMM, ISO_WEEK, QTY, SEQ )
	SELECT P.DIVISION_ID, P.ITEM_ID, '', P.FROM_SITE, P.TO_SITE, P.DEPT, P.END_CUSTOMER, P.PROJECT_CODE, P.INCOTERMS, P.FCST_TYPE, P.TR_MODE, M.MEASURE, P.YYYYMMDD, P.YYYYMM, P.ISO_WEEK, 0, 0
	  FROM (
		   SELECT A.DIVISION_ID, A.ITEM_ID, A.FROM_SITE, A.TO_SITE, DEPT, END_CUSTOMER, PROJECT_CODE, INCOTERMS, FCST_TYPE, TR_MODE, YYYYMMDD, YYYYMM, ISO_WEEK
		     FROM #TblDynamic_SHIP_PIVOT AS A
		    WHERE ISNULL(A.FROM_SITE,'') <> ''
		    GROUP BY A.DIVISION_ID, A.ITEM_ID, A.FROM_SITE, A.TO_SITE, A.DEPT, A.END_CUSTOMER, A.PROJECT_CODE, A.INCOTERMS, A.FCST_TYPE, A.TR_MODE, YYYYMMDD, YYYYMM, ISO_WEEK
		   ) P 
	       JOIN #TblDynamic_MEASURE AS M 
		ON M.BIZ_TYPE = @v_biz_type 
	   AND M.SUM_CHECK = 'N'
	 WHERE NOT EXISTS ( 
	                  SELECT 1
						FROM #TblDynamic_SHIP_PIVOT S
					   WHERE P.DIVISION_ID = S.DIVISION_ID
						 AND P.ITEM_ID = S.ITEM_ID
						 AND P.FROM_SITE = S.FROM_SITE
						 AND P.TO_SITE = S.TO_SITE
						 AND M.MEASURE = S.MEASURE
						 AND P.YYYYMMDD = S.YYYYMMDD
						 AND P.YYYYMM = S.YYYYMM
						 AND P.ISO_WEEK = S.ISO_WEEK
						 AND ISNULL(P.DEPT,'') = ISNULL(S.DEPT, '')
						 AND ISNULL(P.END_CUSTOMER, '') = ISNULL(S.END_CUSTOMER, '')
						 AND ISNULL(P.PROJECT_CODE, '') = ISNULL(S.PROJECT_CODE, '')
						 AND ISNULL(P.INCOTERMS, '') = ISNULL(S.INCOTERMS, '')
						 AND ISNULL(P.FCST_TYPE, '') = ISNULL(S.FCST_TYPE, '')
						 AND ISNULL(P.TR_MODE, '') = ISNULL(S.TR_MODE, '')
						 --AND ISNULL(P.BOD_ID, '') = ISNULL(S.BOD_ID, '')
					  )
	   AND P.TO_SITE <> ''

	--[CSR 요청번호:C20200121-000352]

	-- 20200618  수정 KIMYONGHO 
	-- 81 사업부 조회 시 SCP SHIP PLAN Measure 미표시 문제로  변경
	-- 82 조건 제외 
	--IF @v_division_id = '82'	 
	--BEGIN

		-- FROM Site 가 없는 건들은 지운다.
		DELETE A
		FROM #TblDynamic_SHIP_PIVOT A
		WHERE ISNULL(FROM_SITE,'') = ''

		INSERT INTO #TblDynamic_SHIP_PIVOT ( 
		       DIVISION_ID, ITEM_ID, NICK_NAME, FROM_SITE, TO_SITE, DEPT, END_CUSTOMER, PROJECT_CODE, INCOTERMS, FCST_TYPE, TR_MODE, MEASURE, YYYYMMDD, YYYYMM, ISO_WEEK, QTY, SEQ )
		SELECT P.DIVISION_ID, P.ITEM_ID, '', P.FROM_SITE, P.TO_SITE, P.DEPT, P.END_CUSTOMER, P.PROJECT_CODE, P.INCOTERMS, P.FCST_TYPE, P.TR_MODE, M.MEASURE, P.YYYYMMDD, P.YYYYMM, P.ISO_WEEK, 0, 0
		  FROM (
			   SELECT A.DIVISION_ID, A.ITEM_ID, A.FROM_SITE, A.TO_SITE, DEPT, END_CUSTOMER, PROJECT_CODE, INCOTERMS, FCST_TYPE, TR_MODE, YYYYMMDD, YYYYMM, ISO_WEEK
			     FROM #TblDynamic_SHIP_PIVOT A
			    WHERE ISNULL(A.FROM_SITE,'') <> ''
			    GROUP BY 
				      A.DIVISION_ID, A.ITEM_ID, A.FROM_SITE, A.TO_SITE, A.DEPT, A.END_CUSTOMER, A.PROJECT_CODE, A.INCOTERMS, A.FCST_TYPE, A.TR_MODE, YYYYMMDD, YYYYMM, ISO_WEEK
			   ) P 
		       JOIN #TblDynamic_MEASURE M 
			ON M.BIZ_TYPE = @v_biz_type 
		   AND M.SUM_CHECK = 'A'
		 WHERE NOT EXISTS ( 
		                  SELECT 1
							FROM #TblDynamic_SHIP_PIVOT S
						   WHERE P.DIVISION_ID = S.DIVISION_ID
							 AND P.ITEM_ID = S.ITEM_ID
							 AND P.FROM_SITE = S.FROM_SITE
							 AND P.TO_SITE = S.TO_SITE
							 AND M.MEASURE = S.MEASURE
							 AND P.YYYYMMDD = S.YYYYMMDD
							 AND P.YYYYMM = S.YYYYMM
							 AND P.ISO_WEEK = S.ISO_WEEK
							 AND ISNULL(P.DEPT,'') = ISNULL(S.DEPT, '')
							 AND ISNULL(P.END_CUSTOMER, '') = ISNULL(S.END_CUSTOMER, '')
							 --AND ISNULL(P.PROJECT_CODE, '') = ISNULL(S.PROJECT_CODE, '')
							 AND ISNULL(P.INCOTERMS, '') = ISNULL(S.INCOTERMS, '')
							 --AND ISNULL(P.FCST_TYPE, '') = ISNULL(S.FCST_TYPE, '')
							 AND ISNULL(P.TR_MODE, '') = ISNULL(S.TR_MODE, '')
							 --AND ISNULL(P.BOD_ID, '') = ISNULL(S.BOD_ID, '')
						)
		   AND P.TO_SITE <> ''


	--END


	-- 공통 처리 -- 공통으로 들어가야 할 MEASURE 중에 없는 것이 있으면 추가한다.
	INSERT INTO #TblDynamic_SHIP_PIVOT ( 
	       DIVISION_ID, ITEM_ID, NICK_NAME, FROM_SITE, TO_SITE, DEPT, END_CUSTOMER, PROJECT_CODE, INCOTERMS, FCST_TYPE, TR_MODE, BOD_ID, MEASURE, YYYYMMDD, YYYYMM, ISO_WEEK, QTY, SEQ )
	SELECT P.DIVISION_ID, P.ITEM_ID, '', FROM_SITE, '', '', '', '', '', '', '', '', M.MEASURE, P.YYYYMMDD, P.YYYYMM, P.ISO_WEEK, 0, 0
	  FROM #TblDynamic_MEASURE M 
	       LEFT OUTER JOIN (
		                   SELECT A.DIVISION_ID, A.ITEM_ID, FROM_SITE, YYYYMMDD, YYYYMM, ISO_WEEK
		                     FROM #TblDynamic_SHIP_PIVOT A
		                    GROUP BY A.DIVISION_ID, A.ITEM_ID, FROM_SITE, YYYYMMDD, YYYYMM, ISO_WEEK
		                   ) P 
	    ON M.BIZ_TYPE = @v_biz_type 
	   AND M.SUM_CHECK = 'Y'
	 WHERE NOT EXISTS ( 
	                  SELECT 1
						FROM #TblDynamic_SHIP_PIVOT S
					   WHERE P.DIVISION_ID = S.DIVISION_ID
					     AND P.ITEM_ID = S.ITEM_ID
					     AND P.YYYYMMDD = S.YYYYMMDD
					     AND P.YYYYMM = S.YYYYMM
					     AND P.ISO_WEEK = S.ISO_WEEK
					     AND M.Measure = S.Measure
					     AND P.FROM_SITE = S.FROM_SITE
					  )


		--[CSR 요청번호:C20200121-000352]
		-- 82번일 경우 RTF 관련 메저 삭제
		--[c20200403-000258]
		-- 81 번도 삭제
		DELETE A
		  FROM #TblDynamic_SHIP_PIVOT AS A
		       JOIN #TblDynamic_MEASURE AS B 
			ON A.MEASURE = B.MEASURE
		 WHERE A.MEASURE LIKE '%RTF%'


	UPDATE TOT
	   SET BOD_ID = BOD.BOD_ID
		 , NICK_NAME = ISNULL(I.NICK_NAME,'')
	  FROM #TblDynamic_SHIP_PIVOT TOT
           LEFT JOIN SCP_MST_BOD_V BOD WITH(NOLOCK) 
		ON TOT.DIVISION_ID = BOD.DIVISION_ID
       AND TOT.FROM_SITE   = BOD.FROM_SITE
       AND TOT.TO_SITE     = BOD.TO_SITE
       AND TOT.INCOTERMS   = BOD.INCOTERMS
       AND TOT.TR_MODE     = BOD.TRANSPORT_MODE
	       LEFT OUTER JOIN (
		                   SELECT DIVISION_ID, ITEM_ID, MAX(ISNULL(NICK_NAME,'')) AS NICK_NAME
						     FROM DBO.SCM_MST_ITEM_SN WITH(NOLOCK)
						    WHERE NICK_NAME IS NOT NULL
							  and DIVISION_ID = @v_division_id
							  and ACTIVE_FLAG = 'Y'
						    GROUP BY 
							      DIVISION_ID, ITEM_ID
						   ) AS I 
	   ON TOT.ITEM_ID = I.ITEM_ID
	  AND TOT.DIVISION_ID = I.DIVISION_ID

------■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■


    PRINT '-------------PIVOT TABLE --------: ' +  CONVERT(CHAR(23), getdate(), 21);
    --SELECT * FROM #TblDynamic_SHIP_PIVOT;

    /********************************************************************************
    * PIVOIT처리
    ********************************************************************************/
    BEGIN
		DECLARE @mQry_sum NVARCHAR(MAX);
        DECLARE @mEXEC NVARCHAR(MAX);
        DECLARE @mDAY_QTY NVARCHAR(MAX);

        -- PIVOIT 대상 날짜문자열 생성
		SET @mQry_sum = '';

        SELECT @mQry_sum = @mQry_sum+','
			 + CASE WHEN CHARINDEX('M_', yyyymmdd) =1 THEN ' IIF(SUM(IIF( yyyymm = RIGHT('''+yyyymmdd+'''	,6)	, QTY, 0)) = 0 AND P.MEASURE NOT LIKE ''WH%'', NULL, SUM(IIF( yyyymm = RIGHT('''+yyyymmdd+''',6),		QTY, 0))) AS ' + yyyymmdd
                    WHEN CHARINDEX('W_', yyyymmdd) =1 THEN ' IIF(SUM(IIF( iso_week = RIGHT('''+yyyymmdd+'''	,6)	, QTY, 0)) = 0 AND P.MEASURE NOT LIKE ''WH%'', NULL, SUM(IIF( iso_week = RIGHT('''+yyyymmdd+''',6),	QTY, 0))) AS ' + yyyymmdd
                    WHEN CHARINDEX('D_', yyyymmdd) =1 THEN ' IIF(SUM(IIF( yyyymmdd = '''+yyyymmdd+'''			, QTY, 0)) = 0 AND P.MEASURE NOT LIKE ''WH%'', NULL, SUM(IIF( yyyymmdd = '''+yyyymmdd+''',				QTY, 0))) AS ' + yyyymmdd
			   END +''+CHAR(10)
          FROM (
               SELECT 'W_'+a.basis_yyyymm + a.iso_week AS yyyymmdd
                    , a.basis_start_date + CONVERT(CHAR(2), 21) AS sort_order_no
                 FROM [dbo].[scm_sys_calendar_m] a
                WHERE a.basis_yyyymmdd  BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd
                GROUP BY 
				      a.basis_yyyymm, a.iso_week, a.basis_start_date
                UNION ALL

               SELECT 'M_'+a.basis_yyyymm  AS yyyymmdd
                     ,MIN(a.basis_start_date) + CONVERT(CHAR(2), '01') AS sort_order_no
				 FROM [dbo].[scm_sys_calendar_m] a
                WHERE a.basis_yyyymmdd  BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd
                GROUP BY 
				      a.basis_yyyymm, a.month_name

                UNION ALL

               SELECT 'D_'+a.basis_yyyymmdd   AS yyyymmdd
                     , a.basis_yyyymmdd + CONVERT(CHAR(2), 31) AS sort_order_no
                 FROM [dbo].[scm_sys_calendar_m] a
                WHERE a.basis_yyyymmdd  BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd
                GROUP BY 
				      a.basis_yyyymmdd

               ) AS A
         ORDER BY 
		       sort_order_no  ;

        SET @mEXEC = '';
        SET @mEXEC = @mEXEC+'       SELECT                                        '+CHAR(10);
        SET @mEXEC = @mEXEC+'            P.DIVISION_ID                                              '+CHAR(10);
        SET @mEXEC = @mEXEC+'           ,P.ITEM_ID                              '+CHAR(10);
        SET @mEXEC = @mEXEC+'           ,CASE WHEN ISNULL(MAX(P.NICK_NAME),'''') = '''' THEN ''-'' ELSE MAX(P.NICK_NAME)	END AS NICK_NAME						'+CHAR(10);
		SET @mEXEC = @mEXEC+'           ,CASE WHEN P.FROM_SITE		= '''' THEN ''-'' ELSE P.FROM_SITE				END AS FROM_SITE					'+CHAR(10);
        SET @mEXEC = @mEXEC+'           ,CASE WHEN P.TO_SITE		= '''' THEN ''-'' ELSE P.TO_SITE				END AS TO_SITE						'+CHAR(10);
        SET @mEXEC = @mEXEC+'           ,CASE WHEN P.DEPT			= '''' THEN ''-'' ELSE P.DEPT					END AS TEAM_NAME_KO 				'+CHAR(10);
        SET @mEXEC = @mEXEC+'           ,CASE WHEN P.END_CUSTOMER	= '''' THEN ''-'' ELSE P.END_CUSTOMER			END AS END_CUSTOMER					'+CHAR(10);
        SET @mEXEC = @mEXEC+'    ,CASE WHEN P.PROJECT_CODE	= '''' THEN ''-'' ELSE P.PROJECT_CODE			END AS PROJECT_CODE					'+CHAR(10);
        SET @mEXEC = @mEXEC+'           ,CASE WHEN P.INCOTERMS		= '''' THEN ''-'' ELSE P.INCOTERMS				END AS INCOTERMS					'+CHAR(10);
        SET @mEXEC = @mEXEC+'  ,CASE WHEN P.FCST_TYPE		= '''' THEN ''-'' ELSE P.FCST_TYPE				END AS FCST_TYPE					'+CHAR(10);
        SET @mEXEC = @mEXEC+'           ,CASE WHEN P.TR_MODE		= '''' THEN ''-'' ELSE P.TR_MODE				END AS TR_MODE						'+CHAR(10);
        SET @mEXEC = @mEXEC+'           ,MAX(P.BOD_ID) AS BOD_ID						'+CHAR(10);
		SET @mEXEC = @mEXEC+'           , CASE WHEN ISNULL(C.USERNAME,'''') <> '''' THEN C.USERNAME + ''('' + R.CREATED_BY + '')'' ELSE R.CREATED_BY END AS LAST_UPDATED_BY			'+CHAR(10);
        SET @mEXEC = @mEXEC+'           ,M.MEASURE_COLOR AS MEASURE_COLOR                              '+CHAR(10);
        SET @mEXEC = @mEXEC+'           ,M.MEASURE_LABEL AS MEASURE_LABEL        '+CHAR(10);
        SET @mEXEC = @mEXEC+'           ,P.MEASURE                                                  '+CHAR(10);
		SET @mEXEC = @mEXEC+'           ,ISNULL(FZ.SHIP_FROZEN,0) AS SHIP_FROZEN											'+CHAR(10);
        SET @mEXEC = @mEXEC+'           '+@mQry_sum+CHAR(10);
        SET @mEXEC = @mEXEC+'       FROM #TblDynamic_SHIP_PIVOT P WITH(NOLOCK)                              '+CHAR(10);
		SET @mEXEC = @mEXEC+'       LEFT JOIN  #TblDynamic_REQUESTOR R	ON R.DIVISION_ID = P.DIVISION_ID	'+CHAR(10);
		SET @mEXEC = @mEXEC+'											AND R.ITEM_ID = P.ITEM_ID			'+CHAR(10);
		SET @mEXEC = @mEXEC+'											AND R.FROM_SITE = P.FROM_SITE		'+CHAR(10);
		SET @mEXEC = @mEXEC+'											AND R.TO_SITE = P.TO_SITE			'+CHAR(10);
		SET @mEXEC = @mEXEC+'											AND R.TR_MODE = P.TR_MODE			'+CHAR(10);
		SET @mEXEC = @mEXEC+'											AND R.INCOTERMS = P.INCOTERMS		'+CHAR(10);
		SET @mEXEC = @mEXEC+'											AND R.FCST_TYPE = P.FCST_TYPE		'+CHAR(10);
		SET @mEXEC = @mEXEC+'											AND R.MEASURE = P.MEASURE			'+CHAR(10);
        SET @mEXEC = @mEXEC+'       LEFT JOIN (SELECT UserID, UserName FROM TB_FX_User WITH(NOLOCK)) C     '+CHAR(10);
        SET @mEXEC = @mEXEC+'                                           ON R.CREATED_BY = C.UserID     '+CHAR(10);
        SET @mEXEC = @mEXEC+'       INNER JOIN  #TblDynamic_MEASURE M   WITH(NOLOCK) ON	M.MEASURE = P.MEASURE AND M.BIZ_TYPE = ''' + @v_biz_type + '''      '+CHAR(10);
		SET @mEXEC = @mEXEC+'       LEFT OUTER JOIN SCM_MST_SITE FZ WITH(NOLOCK) ON P.DIVISION_ID = FZ.DIVISION_ID AND P.FROM_SITE = FZ.SCM_SITE_ID AND FZ.VALID_YN = ''Y''' + CHAR(10);
        SET @mEXEC = @mEXEC+'       WHERE  '+CHAR(10);
        SET @mEXEC = @mEXEC+'             EXISTS (SELECT 1											'+CHAR(10);
        SET @mEXEC = @mEXEC+'                       FROM ( SELECT DIVISION_ID, ITEM_ID 				'+CHAR(10);
        SET @mEXEC = @mEXEC+'								FROM #TblDynamic_SHIP_REQ				'+CHAR(10);
        SET @mEXEC = @mEXEC+'								UNION									'+CHAR(10);
        SET @mEXEC = @mEXEC+'								SELECT DIVISION_ID, ITEM_ID 			'+CHAR(10);
        SET @mEXEC = @mEXEC+'								FROM #TblDynamic_PLAN   				'+CHAR(10);
        SET @mEXEC = @mEXEC+'								) SR									'+CHAR(10);
        SET @mEXEC = @mEXEC+'						WHERE P.DIVISION_ID      = SR.DIVISION_ID		'+CHAR(10);
        SET @mEXEC = @mEXEC+'                        AND P.ITEM_ID          = SR.ITEM_ID)			'+CHAR(10);
        SET @mEXEC = @mEXEC+'       GROUP BY  P.DIVISION_ID, P.ITEM_ID, P.FROM_SITE, P.TO_SITE, P.DEPT, P.END_CUSTOMER '+CHAR(10);
        SET @mEXEC = @mEXEC+'    , P.PROJECT_CODE, P.INCOTERMS, P.FCST_TYPE, P.TR_MODE, ISNULL(FZ.SHIP_FROZEN,0) '+CHAR(10);
        SET @mEXEC = @mEXEC+'   , P.MEASURE, R.CREATED_BY, C.USERNAME, M.MEASURE_COLOR, M.MEASURE_LABEL, M.SEQ		 '+CHAR(10);
        SET @mEXEC = @mEXEC+'       ORDER BY  P.DIVISION_ID, P.ITEM_ID, P.FROM_SITE DESC, P.TO_SITE DESC, P.PROJECT_CODE DESC, P.FCST_TYPE DESC, P.TR_MODE DESC , P.INCOTERMS DESC, M.SEQ '+CHAR(10);

        -----------------------------------------------------------
        -- DEBUG QRY 출력
        -----------------------------------------------------------
        IF( @debug_mode ='T')
  BEGIN
                DECLARE @POS INT =1;
                DECLARE @LEN INT =LEN(@mEXEC);
                WHILE @POS <= @LEN
                    BEGIN
                        PRINT SUBSTRING(@mEXEC,@POS,4000);
                        SET @POS = @POS+4000;
                    END;
            END;
        -----------------------------------------------------------
		-- select @mEXEC;

        EXEC (@mEXEC);

        PRINT '-------------PIVOT COMPLETE! ----: ' +  CONVERT(CHAR(23), getdate(), 21);

    END;

	ClearTbl:

-- 임시테이블 삭제
    IF OBJECT_ID('tempdb..#TblDynamic_PLAN') IS NOT NULL
        DROP TABLE #TblDynamic_PLAN;

    IF OBJECT_ID('tempdb..#TblDynamic_SHIP_REQ') IS NOT NULL
        DROP TABLE #TblDynamic_SHIP_REQ;

    IF OBJECT_ID('tempdb..#TblDynamic_SHIP_PIVOT') IS NOT NULL
        DROP TABLE #TblDynamic_SHIP_PIVOT;

    IF OBJECT_ID('tempdb..#TblDynamic_SHIP_ROW') IS NOT NULL
        DROP TABLE #TblDynamic_SHIP_ROW;

    IF OBJECT_ID('tempdb..#TblDynamic_REQUESTOR') IS NOT NULL
        DROP TABLE #TblDynamic_REQUESTOR;
		
    IF OBJECT_ID('tempdb..#TblDynamic_RTF_ADJ') IS NOT NULL
        DROP TABLE #TblDynamic_RTF_ADJ;

    IF OBJECT_ID('tempdb..#TblDynamic_MEASURE') IS NOT NULL
        DROP TABLE #TblDynamic_MEASURE;
	
	IF OBJECT_ID('tempdb..#tbl_Loc') IS NOT NULL
		DROP TABLE #tbl_Loc;



END
