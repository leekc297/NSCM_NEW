
/*
 **************************************************************************************************
 * Program ID  : [DMF0042_3_Get_BizPlan]
 * Description : DMF0042_3_BizPlan(매출계획) 화면 저장                                                       
 * Usage       :                                                   
 * Parameter   :                                                                                    
 *                                                                                                  
 *--------------------------------------------------------------------------------------------------
 * Date        In Charge    Description                                                             
 *--------------------------------------------------------------------------------------------------
 * 2023/08/21  ilovu1    Initial Release(DM_PLN_BP_FCST --> DM_PLN_BIZPLAN)
 **************************************************************************************************
*/
/*
exec DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA @p_division_id=N'81'
                                          ,@p_dept_id=N'ALL'
										  ,@p_end_customer=N'ALL'
										  ,@p_scm_site_id=N'ALL'
										  ,@p_project_code=N''
										  ,@p_item_id=N''
										  ,@p_item_type=N'ALL'
										  ,@p_from_yyyymmdd=N'20230801'
										  ,@p_now_yyyymmdd=N'20230821'
										  ,@p_to_yyyymmdd=N'20240229'
										  ,@p_created_by=N'ilovu1'
										  ,@p_plant_site_id=N'ALL'
										  ,@p_biztype=N'ALL'
										  ,@p_userinfo=N'ADMIN'
										  ,@p_owner=N''
										  ,@p_qty_yn=N'N';
*/
CREATE PROCEDURE [dbo].[DMF0042_3_Get_BizPlan]
      @p_division_id              NVARCHAR(30)
	, @p_dept_id                  NVARCHAR(4000)
    , @p_end_customer             NVARCHAR(4000)
	, @p_scm_site_id              NVARCHAR(4000)
    , @p_project_code             NVARCHAR(4000)
	, @p_item_id                  NVARCHAR(4000)
	, @p_item_type                NVARCHAR(4000)
	, @p_from_yyyymmdd            NVARCHAR(8)
	, @p_now_yyyymmdd             NVARCHAR(8)
	, @p_to_yyyymmdd              NVARCHAR(8)
	, @p_created_by               NVARCHAR(50)
	, @p_plant_site_id            NVARCHAR(4000)
	, @p_biztype                  NVARCHAR(4000)
	, @p_userinfo                 NVARCHAR(50)
	, @p_owner					  NVARCHAR(4000)
	, @p_qty_yn					  NVARCHAR(1)
AS  
BEGIN
	SET NOCOUNT ON;

	DECLARE @Prod			VARCHAR(MAX);
	DECLARE @ColList		VARCHAR(MAX);
	DECLARE @GroupList		VARCHAR(MAX);
	DECLARE @nsql			NVARCHAR(MAX);
	DECLARE @nsql2			NVARCHAR(MAX);
	DECLARE @p_program_id	NVARCHAR(50) = 'DMF0042_3';

	SET  @Prod		= '';
    SET  @ColList	= '';
    SET  @GroupList	= '';
    
    DECLARE @MEASURE INT =0;
    DECLARE @i_count INT =0;

    DECLARE @v_dept_id	nvarchar(50)='';
	DECLARE @v_group_id nvarchar(50)='';

	SET @p_from_yyyymmdd = SUBSTRING(@p_from_yyyymmdd, 1,6)
	SET @p_to_yyyymmdd = SUBSTRING(@p_to_yyyymmdd, 1,6)

	-- 사용자의 팀정보 & 권한
	SELECT @v_dept_id = ISNULL((SELECT TOP 1 SEGMENT3
								  FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK)
								 WHERE LOOKUP_TYPE  = 'PM_TEAM_MAPPING'
								   AND VALID_YN     = 'Y'
								   AND SEGMENT1     = U.DEPT_ID 
							   ), U.DEPT_ID 
							  )
	  FROM [dbo].[TB_FX_User] U WITH (NOLOCK)
	 WHERE U.UserID = @p_created_by;
	---------------------------------------------------------------------------------
	-- 20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리
	---------------------------------------------------------------------------------
	IF ISNULL((SELECT COUNT(1) 
	             FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK)
				WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP' 
				  AND VALID_YN = 'Y'
				  AND SEGMENT2 = 'ALL'  -- 'ALL'인경우 기본값(특정화면에서 추가된 그룹을 제외)
				  AND SEGMENT1 = @p_userinfo
			  ),0) > 0
	BEGIN
		SET @v_group_id = 'ADMIN'
	END
	---------------------------------------------------------------------------------

	------------------------------------------------------------------------------------------
	-- Temp Table 존재 여부 체크
	------------------------------------------------------------------------------------------
	IF OBJECT_ID (N'tempdb..#tmpPlanData', N'U') IS NOT NULL 
		DROP TABLE #tmpPlanData;		
	IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_V', N'U') IS NOT NULL 
		DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_V;		
	IF OBJECT_ID (N'tempdb..#SELECT_MEASURE', N'U') IS NOT NULL 
		DROP TABLE #SELECT_MEASURE;		
	IF OBJECT_ID (N'tempdb..#RAW_DATA', N'U') IS NOT NULL 
		DROP TABLE #RAW_DATA;		
	IF OBJECT_ID (N'tempdb..#RAW_DATA_SUM', N'U') IS NOT NULL 
		DROP TABLE #RAW_DATA_SUM;		
	IF OBJECT_ID (N'tempdb..#TEMP_SCM_MST_SSO_USER_INFO', N'U') IS NOT NULL 
		DROP TABLE #TEMP_SCM_MST_SSO_USER_INFO;		
	IF OBJECT_ID (N'tempdb..#TEMP_SCM_MST_SITE_ITEM', N'U') IS NOT NULL 
		DROP TABLE #TEMP_SCM_MST_SITE_ITEM;		
	------------------------------------------------------------------------------------------

    CREATE TABLE #RAW_DATA (
         DIVISION_ID						NVARCHAR(30)
        ,PROJECT_CODE						NVARCHAR(50)
        ,END_CUSTOMER40						NVARCHAR(50)
        ,PLANT_SITE_ID						NVARCHAR(30)
        ,ITEM_ID							NVARCHAR(100)
        ,INCOTERMS							NVARCHAR(100)
        --,INCOTERMS82						NVARCHAR(100) -- [PJ20200138] Incoterms 삭제
        --,DOM_EXP							NVARCHAR(100)
        ,FCST_TYPE							NVARCHAR(100)
        ,MEASURE							NVARCHAR(100)
		,CELL_PROD_SITE						NVARCHAR(100) --[C20220513-000327]GSCM Business Plan 신규 키컬럼 추가 및 체크박스 옵션 추가 요청의 건
        ,COLNAME							NVARCHAR(100)
        ,SORT_ORDER_NO						NVARCHAR(100)
        ,CALENDAR_YYYYQQ					NVARCHAR(100)
        ,CALENDAR_YYYY						NVARCHAR(100)
        ,YYYYMM								NVARCHAR(6)
        ,QTY								NUMERIC(30,10)
        ,CURRENCY							NVARCHAR(100)
        ,FORECAST_INFO_CELL_PACK_COUNT      NVARCHAR(100)
        ,BIZ_TYPE_NAME40					NVARCHAR(100)
        ,CELL_TYPE							NVARCHAR(100)
        ,ITEM_CLASS_NAME					NVARCHAR(100)
        ,ITEM_NAME							NVARCHAR(100)
        ,ITEM_TYPE							NVARCHAR(100)
        ,NICK_NAME							NVARCHAR(100)
        ,MIN_CAPACITY						NVARCHAR(100)
        ,EDIT_FLAG							NVARCHAR(100)
        ,APPLICATION						NVARCHAR(100)
        ,CUST_GROUP							NVARCHAR(100)
        ,FORECAST_INFO_CELL_MODEL			NVARCHAR(150)
        ,OWNER								NVARCHAR(100)
        ,DEPT_ID							NVARCHAR(100)
        ,VMI_YN								NVARCHAR(100)
        ,ROUTE								NVARCHAR(100)
        ,FORECAST_INFO_PRODUCT_GROUP		NVARCHAR(100)
        ,FORECAST_INFO_ALL					NVARCHAR(100)
        ,FORECAST_INFO_SPEC					NVARCHAR(100)
        ,FORECAST_INFOR_VERSION				NVARCHAR(100)
        ,MDM_PROJECT_NAME					NVARCHAR(100)
        ,CUST_GROUP_DTL						NVARCHAR(100)
        ,DMS_SALES							NVARCHAR(100)
		,DMS_CUSTOMER						NVARCHAR(100)
        ,PROJECT_NAME						NVARCHAR(100)
        ,PROJECT_OWNER						NVARCHAR(100)
        ,PROJECT_STATUS						NVARCHAR(100)
        ,END_CUSTOMER						NVARCHAR(100)
        ,CITY_NAME							NVARCHAR(100)
        ,COUNTRY_NAME						NVARCHAR(100)
        --,INCOTERMS40						NVARCHAR(100) -- [PJ20200138] Incoterms 삭제
        ,FCST_TYPE40						NVARCHAR(100)
        --,DOM_EXP40							NVARCHAR(100)
        ,REPORT_GROUP1						NVARCHAR(100)
        ,REPORT_GROUP2						NVARCHAR(100)
        ,REPORT_GROUP3						NVARCHAR(100)
        ,REPORT_GROUP4						NVARCHAR(100)
        ,REPORT_GROUP5						NVARCHAR(100)
        ,REPORT_GROUP6						NVARCHAR(100)
        ,REPORT_GROUP7						NVARCHAR(100)
        ,REPORT_GROUP8						NVARCHAR(100)
        ,BIZ_TYPE_NAME81					NVARCHAR(100)
        ,PROJECT_CODE82						NVARCHAR(100)
        ,BIZ_TYPE_NAME82					NVARCHAR(100)
        ,ITEM_ID40							NVARCHAR(100)
        ,SCM_SITE_ID40						NVARCHAR(100)
        ,SCM_SITE_ID81						NVARCHAR(100)
        ,SCM_SITE_ID82						NVARCHAR(100)
        --,CELL_PER_PACK						NVARCHAR(100)
        --,CELL_PER_MODULE					NVARCHAR(100)
        --,MODULE_PER_PACK					NVARCHAR(100)
        ,DEPT_ID40							NVARCHAR(100)
		,PRODUCT_GROUP_NAME					NVARCHAR(100)
        ,ITEM_USE							NVARCHAR(100) -- [PJ20200138] item_use, unit_energy 추가
        ,UNIT_ENERGY						NVARCHAR(100)
        ,CELL_PER_CAR						NVARCHAR(100)
        ,MODULE_PER_CAR 					NVARCHAR(100)
		--추가 컬럼
		,ALT_SIM_YN                         NVARCHAR(1)	  --대체/유사모델 여부
		,KWH								NVARCHAR(150) --KWh/Cell	
	
		,CELL_PER_MODULE					NUMERIC(20,10)--Cell/Module (자동차사업부)(ESS사업부)
		,CELL_PER_PACK						NUMERIC(20,10)--Cell/Pack(ESS사업부), Cell/Car(자동차사업부)  					
		,MODULE_PER_PACK					NUMERIC(20,10)--Module/Car  (자동차사업부)

		,BIZ_TYPE							NVARCHAR(30)  --PK: 모델구분(셀/팩/모듈)
		,DOM_EXP							NVARCHAR(2)   --PK: 내수/수출
		,EXT_INT							NVARCHAR(6)   --외주여부(External/Internal)
		,OSP_YN								NVARCHAR(1)   --OSP Flag

		,CELL_CODE							NVARCHAR(50)  --Cell Code
		,CELL_NAME							NVARCHAR(100) --Cell Name
    ); /*
alter table #RAW_DATA
	add constraint PK_#RAW_DATA
	primary key (
				  DIVISION_ID
				, PROJECT_CODE
				, SCM_SITE_ID40
				, SCM_SITE_ID81
				, SCM_SITE_ID82
				, ITEM_ID
				, ITEM_ID40
				, END_CUSTOMER
				, BIZ_TYPE_NAME81
				, BIZ_TYPE_NAME82
				, BIZ_TYPE_NAME40
				, BIZ_TYPE
				, PLANT_SITE_ID
				, FCST_TYPE40
				, FCST_TYPE
				, DOM_EXP
				, INCOTERMS
				, CURRENCY
				, MEASURE
				, YYYYMM
				);*/
	-----------------------------------------------------------------------------------------
	--                               20191002 KHSONG 조회시 DB Lock 현상으로 로직수정
	-----------------------------------------------------------------------------------------
	SELECT DIVISION_ID
	     , ITEM_ID
		 , ITEM_NAME
		 , ITEM_CLASS
		 , ITEM_CLASS_NAME
		 , NICK_NAME
		 , ITEM_TYPE
		 , MATERIAL_CLASS_NAME
		 , ITEM_UOM
		 , SPEC
		 , MDM_PROJECT_NAME
		 , MIN_CAPACITY
		 , FORECAST_INFO_BIZ_TYPE
		 , FORECAST_INFO_PRODUCT_GROUP
		 , FORECAST_INFO_CELL_MODEL
		 , FORECAST_INFO_CELL_PACK_COUNT
		 , FORECAST_INFO_SPEC
		 , FORECAST_INFOR_VERSION
		 , ACTIVE_FLAG
		 , CELL_TYPE
	  INTO #TEMP_DM_MST_ITEM_SINGLE_V
	  FROM (SELECT *			
			  FROM DM_MST_ITEM_SINGLE_V T2 WITH (NOLOCK)
				   INNER JOIN (SELECT DISTINCT '%'+token+'%' tst FROM dbo.String_Split(@p_item_id,',')) b
						   ON T2.ITEM_ID	like  b.tst 
						   OR T2.NICK_NAME	like  b.tst 						
			 WHERE DIVISION_ID = @p_division_id
		   ) G
	 GROUP BY 
	       DIVISION_ID
		 , ITEM_ID
		 , ITEM_NAME
		 , ITEM_CLASS
		 , ITEM_CLASS_NAME
		 , NICK_NAME
		 , ITEM_TYPE
		 , MATERIAL_CLASS_NAME
		 , ITEM_UOM
		 , SPEC
		 , MDM_PROJECT_NAME
		 , MIN_CAPACITY
		 , FORECAST_INFO_BIZ_TYPE
		 , FORECAST_INFO_PRODUCT_GROUP
		 , FORECAST_INFO_CELL_MODEL
		 , FORECAST_INFO_CELL_PACK_COUNT
		 , FORECAST_INFO_SPEC
		 , FORECAST_INFOR_VERSION
		 , ACTIVE_FLAG
		 , CELL_TYPE;
	CREATE CLUSTERED INDEX [IDX1_TEMP_DM_MST_ITEM_SINGLE_V] ON #TEMP_DM_MST_ITEM_SINGLE_V(DIVISION_ID ASC, ITEM_ID ASC)
		WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY];
	-----------------------------------------------------------------------------------------

	------------------------------------------------------------------------------------------
	-- 20190326 오류개선 STUFF시 정렬오류로 멀티OWNER가 분리되는 오류발생으로 TEMP사용
	------------------------------------------------------------------------------------------
	SELECT *
	 INTO #TEMP_SCM_MST_SSO_USER_INFO
	FROM SCM_MST_SSO_USER_INFO WITH (NOLOCK)
	  ORDER BY USER_ID;

	-- 2020.4.23 속도문제로 쿼리 변경
	SELECT *
		 , DBO.FN_GET_DM_MKT_OWNER_NAME (SMSI.OWNER, ',', 'EN' ) AS OWNER_NAME
		 , DBO.FN_GET_DM_MKT_OWNER_NAME (SMSI.OWNER, ',', 'KO' ) AS OWNER_NAME_KO
		 ,(SELECT SU.DEPT_ID  
		     FROM #TEMP_SCM_MST_SSO_USER_INFO SU WITH (NOLOCK) 
		    WHERE SU.USER_ID = (SELECT top 1 token 
			                      FROM [dbo].[String_Split](SMSI.owner, ',')
							   ) 
		  ) DEPT_ID
		 , SMSI.SALES_PLAN_ADJUST_YN AS EDIT_FLAG
	  INTO #TEMP_SCM_MST_SITE_ITEM
	  FROM SCM_MST_SITE_ITEM SMSI WITH (NOLOCK)
     WHERE SMSI.DIVISION_ID = @p_division_id;
	------------------------------------------------------------------------------------------
	
/* 미래 구간에 대해서는 SITE-ITEM에 있는것만 포함되어야 함. ( ETC 포함 )
   과거 구간은 전체 Data가 포함되어야 함.
   단가는 조회조건에 있는 key 기준으로 포함이 되어야 함. 단가는 Weekly로 되어 있기 때문에 Daily로 변경되어야 함.
   단위 환산이 되어야 함.
*/

	SELECT U.PROGRAM_ID
		 , U.SHEET_NAME
		 , U.COLUMN_NAME AS MEASURE
		 , U.SORT_ORDER_NO
	  INTO #SELECT_MEASURE
	  FROM [dbo].[SCM_MST_SHEET_MEASURE] U  WITH (NOLOCK)
	 WHERE 1 = 1
	   AND U.PROGRAM_ID   = @p_program_id
	   AND U.DIVISION_ID LIKE '%' + @p_division_id + '%';

	--------------------------------------------------
	-- (1) DM_PLN_BIZPLAN
	--------------------------------------------------
    IF @p_division_id = '40'
    BEGIN
		INSERT 
		  INTO #RAW_DATA
		SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.PROJECT_CODE AS END_CUSTOMER40
             , PLANT_SITE_ID
             , A.ITEM_ID
             , A.INCOTERMS
             , A.FCST_TYPE
             , A.MEASURE
             , LK1.ATTRIBUTE1 AS CELL_PROD_SITE
             , 'M_' + YYYYMM AS COLNAME
             , SM.SORT_ORDER_NO
             , CAL.CALENDAR_YYYYQQ AS CALENDAR_YYYYQQ
             , CAL.CALENDAR_YYYY AS CALENDAR_YYYY
             , A.YYYYMM ,A.QTY
             , CASE WHEN A.CURRENCY = '' THEN SI.CURRENCY ELSE ISNULL(A.CURRENCY, SI.CURRENCY) END AS CURRENCY 
             , ISV.FORECAST_INFO_CELL_PACK_COUNT
             , ISV.FORECAST_INFO_BIZ_TYPE AS BIZ_TYPE_NAME40
             , (SELECT LMD.SEGMENT2  AS NAME FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] LMD WITH (NOLOCK) WHERE LOOKUP_TYPE = 'CELL_TYPE' AND ISV.CELL_TYPE = LMD.SEGMENT1 ) AS CELL_TYPE
             , isnull(ISV.ITEM_CLASS_NAME,'')AS ITEM_CLASS_NAME
             , isnull(ISV.ITEM_NAME,'')AS ITEM_NAME
             , isnull(ISV.ITEM_TYPE,'')AS ITEM_TYPE
             , isnull(ISV.NICK_NAME,'')AS NICK_NAME
             , ISV.MIN_CAPACITY
             , CASE 
					WHEN ( 
						  CASE 
						  		WHEN A.DIVISION_ID = '40' THEN SI.DEPT_ID 
						  		ELSE A.DEPT_ID 
						  END
						 ) = @v_dept_id THEN 'Y'
					WHEN @v_group_id ='ADMIN' THEN 'Y' 
					ELSE 'N' 
			   END AS EDIT_FLAG				
             , SI.APPLICATION
             , SI.CUST_GROUP
             , SI.ATTRIBUTE5 AS FORECAST_INFO_CELL_MODEL
             , SI.OWNER_NAME OWNER
             , A.DEPT_ID  AS DEPT_ID
             , S.VMI_YN 
             , SI.ROUTE
             , ISV.FORECAST_INFO_PRODUCT_GROUP
             , ISV.FORECAST_INFO_SPEC+ISV.FORECAST_INFOR_VERSION AS FORECAST_INFO_ALL
             , ISV.FORECAST_INFO_SPEC
             , ISV.FORECAST_INFOR_VERSION
             , ISV.MDM_PROJECT_NAME 
             , SI.CUST_GROUP_DTL
             , ISNULL(SI.attribute1,'') DMS_SALES
             , ISNULL(SI.attribute2,'') DMS_CUSTOMER
             , A.PROJECT_NAME   AS PROJECT_NAME
             , ''               AS PROJECT_OWNER
             , ''               AS PROJECT_STATUS
             , A.END_CUSTOMER
             , S.CITY_NAME
             , S.COUNTRY_NAME
             , A.FCST_TYPE AS FCST_TYPE40
             , SI.REPORT_GROUP1
             , SI.REPORT_GROUP2
             , SI.REPORT_GROUP3
             , SI.REPORT_GROUP4
             , SI.REPORT_GROUP5
             , SI.REPORT_GROUP6
             , SI.REPORT_GROUP7
             , SI.REPORT_GROUP8
             , A.BIZ_TYPE as BIZ_TYPE_NAME81
             , A.PROJECT_CODE AS PROJECT_CODE82
             , A.BIZ_TYPE AS BIZ_TYPE_NAME82
             , A.ITEM_ID AS ITEM_ID40
             , A.SCM_SITE_ID AS SCM_SITE_ID40
             , A.SCM_SITE_ID AS SCM_SITE_ID81
             , A.SCM_SITE_ID AS SCM_SITE_ID82
             , SI.DEPT_ID AS DEPT_ID40
             , '' AS PRODUCT_GROUP_NAME
             , A.ITEM_USE
             , A.UNIT_ENERGY
             , 0   AS CELL_PER_CAR
             , 0   AS MODULE_PER_CAR
			 --추가 컬럼
			 , S2.ALT_SIM_YN				--대체/유사모델 여부
			 , NULL KWH						--KWh/Cell
			 , NULL CELL_PER_MODULE			--Cell/Module (자동차사업부)(ESS사업부)
			 , NULL CELL_PER_PACK			--Cell/Pack(ESS사업부), Cell/Car(자동차사업부)
			 , NULL MODULE_PER_PACK			--Module/Car  (자동차사업부)
			 , A.BIZ_TYPE                   --PK: 모델구분(셀/팩/모듈)
			 , A.DOM_EXP                    --PK: 내수/수출
			 , A.EXT_INT                    --외주여부(External/Internal)
			 , A.OSP_YN	                    --OSP Flag
			 , ISNULL(A.CELL_CODE, S2.ATTRIBUTE5) CELL_CODE--Cell Code
			 , S2.REPORT_GROUP6	CELL_NAME	--Cell Name
		  FROM DM_PLN_BIZPLAN A WITH (NOLOCK)
		       INNER JOIN #SELECT_MEASURE AS SM WITH (NOLOCK)
				        ON SM.MEASURE = A.MEASURE
			   INNER JOIN SCM_MST_SITE S1 WITH (NOLOCK)
					   ON A.DIVISION_ID		= S1.DIVISION_ID
					  AND A.SCM_SITE_ID		= S1.SCM_SITE_ID
			   INNER JOIN SCM_MST_SITE_ITEM S2 WITH (NOLOCK)
					   ON A.DIVISION_ID		= S2.DIVISION_ID
					  AND A.PROJECT_CODE	= S2.PROJECT_CODE
					  AND A.SCM_SITE_ID		= S2.SCM_SITE_ID
					  AND A.ITEM_ID			= S2.ITEM_ID
				INNER JOIN #TEMP_DM_MST_ITEM_SINGLE_V ISV WITH (NOLOCK)
					    ON A.DIVISION_ID	= ISV.DIVISION_ID
					   AND A.ITEM_ID		= ISV.ITEM_ID
				LEFT  JOIN #TEMP_SCM_MST_SITE_ITEM SI WITH (NOLOCK)
					    ON A.DIVISION_ID		= SI.DIVISION_ID
					   AND A.SCM_SITE_ID		= SI.SCM_SITE_ID
					   AND A.PROJECT_CODE		= SI.PROJECT_CODE
					   AND A.iTEM_ID			= SI.ITEM_ID
				LEFT  JOIN (SELECT X.DIVISION_ID
							     , X.SOLDTO_CUSTOMER
								 , X.END_CUSTOMER
								 , X.DEPT_ID
								 , X.SCM_SITE_ID
								 , X.VMI_YN
								 , X.VALID_YN
								 , Y.CITY_NAME
								 , Z.COUNTRY_NAME 
							  FROM SCM_MST_SITE X WITH (NOLOCK)
							     , SCM_MST_CITY Y WITH (NOLOCK)
								 , SCM_MST_COUNTRY z WITH (NOLOCK)
							 WHERE x.city = y.city  
							   and x.country = z.country
						   ) S 
					    ON A.DIVISION_ID		= S.DIVISION_ID
					   AND A.SCM_SITE_ID		= S.SCM_SITE_ID
				LEFT  JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK1 
				        ON A.CELL_PROD_SITE = LK1.SEGMENT1 
					   AND LK1.LOOKUP_TYPE = 'DM_CELL_PROD_SITE'
				-------------------------- Project 조건 ------------------------------------------------------
				INNER JOIN (SELECT DISTINCT '%'+token+'%' tst 
				              FROM dbo.String_Split(@p_project_code,',') 
						   ) b1
				        ON CASE 
								WHEN @p_project_code = '' THEN @p_project_code			
	    						ELSE A.PROJECT_CODE  
						   END like b1.tst 
					    OR CASE 
								WHEN @p_project_code = '' THEN @p_project_code			
								ELSE A.PROJECT_NAME  
						   END like b1.tst 
				-----------------------------------------------------------------------------------------------
				-------------------------- Model 조건 ---------------------------------------------------------
				INNER JOIN (SELECT DISTINCT '%'+token+'%' tst 
				              FROM dbo.String_Split(@p_item_id,',') 
						   ) b2
				        ON CASE 
								WHEN @p_item_id = '' THEN @p_item_id			
								ELSE A.ITEM_ID  
						   END like b2.tst 
					    OR CASE 
								WHEN @p_item_id = '' THEN @p_item_id			
								ELSE ISV.NICK_NAME  
						   END like b2.tst 
				-----------------------------------------------------------------------------------------------
				-------------------------- Owner 조건 ---------------------------------------------------------
				INNER JOIN (SELECT '%'+token+'%' tst 
				              FROM dbo.String_Split(@p_owner,',') 
						   ) b3
				        ON CASE 
								WHEN @p_owner = '' THEN @p_owner			
								ELSE SI.OWNER         
						   END like b3.tst 
					    OR CASE 
								WHEN @p_owner = '' THEN @p_owner			
								ELSE SI.OWNER_NAME    
						   END like b3.tst 
					    OR CASE 
								WHEN @p_owner = '' THEN @p_owner			
								ELSE SI.OWNER_NAME_KO 
						   END like b3.tst 
				-----------------------------------------------------------------------------------------------
				
				INNER JOIN (SELECT CALENDAR_YYYY
				                 , CALENDAR_YYYYQQ
								 , BASIS_YYYYMM 
					          FROM SCM_SYS_CALENDAR_M WITH (NOLOCK)
					         WHERE BASIS_YYYYMM >= @p_from_yyyymmdd 
							   AND BASIS_YYYYMM <= @p_to_yyyymmdd
					         GROUP BY 
							       CALENDAR_YYYY
								 , CALENDAR_YYYYQQ
								 , BASIS_YYYYMM
						   ) AS CAL
				        ON CAL.BASIS_YYYYMM = A.YYYYMM
			WHERE 1=1
			  AND CASE 
						WHEN @p_dept_id = 'ALL' THEN 'ALL'
						ELSE 
							CASE 
								WHEN A.DIVISION_ID = '40' THEN SI.DEPT_ID 
								ELSE A.DEPT_ID 
							END
				  END IN (SELECT *
						    FROM dbo.UF_FX_String_SplitForIN(@p_dept_id,',') as P 
						   WHERE (CASE
										WHEN @p_dept_id = 'ALL' THEN 'ALL' 
										ELSE 
											CASE 
												WHEN A.DIVISION_ID = '40' THEN SI.DEPT_ID 
												ELSE A.DEPT_ID 
											END
								  END) = P.data
						 )
			  AND CASE 
						WHEN @p_end_customer = 'ALL' THEN 'ALL'
		   				ELSE isnull(CASE 
										WHEN @p_division_id = '40' THEN A.PROJECT_CODE 
										ELSE A.END_CUSTOMER 
									END, ''
							       )
				  END IN (SELECT *
							FROM dbo.UF_FX_String_SplitForIN(@p_end_customer, ',') as P 
						   WHERE (CASE  
										WHEN @p_end_customer = 'ALL' THEN 'ALL' 
										ELSE isnull(
													CASE 
														WHEN @p_division_id = '40' THEN A.PROJECT_CODE 
														ELSE A.END_CUSTOMER 
													END, ''
												   )
							      END) = P.data
						 )						   
			  AND CASE 
						WHEN @p_scm_site_id = 'ALL' THEN 'ALL'
		   				ELSE A.SCM_SITE_ID			
				  END IN (SELECT *
							FROM dbo.UF_FX_String_SplitForIN(@p_scm_site_id,',') as P 
						   WHERE (CASE 
										WHEN @p_scm_site_id = 'ALL' THEN 'ALL' 
										ELSE A.SCM_SITE_ID 
								  END) = P.data
						 )
			  AND CASE 
						WHEN @p_plant_site_id = 'ALL' THEN 'ALL'
		   				ELSE A.PLANT_SITE_ID			
				  END IN (SELECT *
						    FROM dbo.UF_FX_String_SplitForIN(@p_plant_site_id,',') as P 
						   WHERE (CASE
										WHEN @p_plant_site_id = 'ALL' THEN 'ALL' 
										ELSE A.PLANT_SITE_ID 
								  END) = P.data
						 )
			  AND CASE 
						WHEN @p_item_type = 'ALL' THEN 'ALL'
		   				ELSE ISV.ITEM_TYPE			
				  END IN (SELECT *
							FROM dbo.UF_FX_String_SplitForIN(@p_item_type,',') as P 
						   WHERE (CASE
										WHEN @p_item_type = 'ALL' THEN 'ALL' 
										ELSE ISV.ITEM_TYPE 
								  END) = P.data
						 )
			  AND CASE 
						WHEN @p_biztype = 'ALL' THEN 'ALL'
		   				ELSE
							CASE 
							WHEN @p_division_id = '40' THEN ISV.FORECAST_INFO_BIZ_TYPE 
							ELSE A.BIZ_TYPE 
						END
					END IN (SELECT *
							  FROM dbo.UF_FX_String_SplitForIN(@p_biztype,',') as P 
							 WHERE (CASE
										WHEN @p_biztype = 'ALL' THEN 'ALL' 
										ELSE 
											CASE 
												WHEN @p_division_id = '40' THEN ISV.FORECAST_INFO_BIZ_TYPE
												ELSE A.BIZ_TYPE 
											END
							        END) = P.data
						   )
			  AND A.YYYYMM      >= @p_from_yyyymmdd 
			  AND A.YYYYMM      <= @p_to_yyyymmdd
			  AND A.DIVISION_ID =  @p_division_id;
    END
    ELSE
    BEGIN
		INSERT 
		  INTO #RAW_DATA
			 ( DIVISION_ID
			 , PROJECT_CODE
			 , END_CUSTOMER40
			 , PLANT_SITE_ID
			 , ITEM_ID
			 , INCOTERMS
			 , FCST_TYPE
			 , MEASURE
			 , CELL_PROD_SITE
			 , COLNAME
			 , SORT_ORDER_NO
			 , CALENDAR_YYYYQQ
			 , CALENDAR_YYYY
			 , YYYYMM, QTY
			 , CURRENCY
			 , FORECAST_INFO_CELL_PACK_COUNT
			 , BIZ_TYPE_NAME40
			 , CELL_TYPE
			 , ITEM_CLASS_NAME
			 , ITEM_NAME
			 , ITEM_TYPE
			 , NICK_NAME
			 , MIN_CAPACITY
			 , EDIT_FLAG
			 , APPLICATION
			 , CUST_GROUP
			 , FORECAST_INFO_CELL_MODEL
			 , OWNER
			 , DEPT_ID
			 , VMI_YN
			 , ROUTE
			 , FORECAST_INFO_PRODUCT_GROUP
			 , FORECAST_INFO_ALL
			 , FORECAST_INFO_SPEC
			 , FORECAST_INFOR_VERSION
			 , MDM_PROJECT_NAME
			 , CUST_GROUP_DTL
			 , DMS_SALES
			 , DMS_CUSTOMER
			 , PROJECT_NAME
			 , PROJECT_OWNER
			 , PROJECT_STATUS
			 , END_CUSTOMER
			 , CITY_NAME
			 , COUNTRY_NAME
			 , FCST_TYPE40
			 , REPORT_GROUP1
			 , REPORT_GROUP2				 
			 , REPORT_GROUP3
			 , REPORT_GROUP4
			 , REPORT_GROUP5
			 , REPORT_GROUP6
			 , REPORT_GROUP7
			 , REPORT_GROUP8
			 , BIZ_TYPE_NAME81
			 , PROJECT_CODE82
			 , BIZ_TYPE_NAME82
			 , ITEM_ID40
			 , SCM_SITE_ID40
			 , SCM_SITE_ID81
			 , SCM_SITE_ID82
			 , DEPT_ID40
			 , PRODUCT_GROUP_NAME
			 , ITEM_USE
			 , UNIT_ENERGY
			 , CELL_PER_CAR
			 , MODULE_PER_CAR 
			 --추가 컬럼
			 , ALT_SIM_YN		--대체/유사모델 여부
			 , KWH				--KWh/Cell
			 , CELL_PER_MODULE	--Cell/Module (자동차사업부)(ESS사업부)
			 , CELL_PER_PACK	--Cell/Pack(ESS사업부), Cell/Car(자동차사업부)
			 , MODULE_PER_PACK	--Module/Car  (자동차사업부)
		     , BIZ_TYPE			--모델구분(셀/팩/모듈)
		     , DOM_EXP			--내수/수출
		     , EXT_INT			--외주여부(External/Internal)
		     , OSP_YN			--OSP Flag
			 , CELL_CODE		--Cell Code
			 , CELL_NAME		--Cell Name
			 )
   		SELECT A.DIVISION_ID				
             , A.PROJECT_CODE
             , A.PROJECT_CODE AS END_CUSTOMER40
             , PLANT_SITE_ID
             , A.ITEM_ID
             , A.INCOTERMS
             , A.FCST_TYPE
             , A.MEASURE
             , A.CELL_PROD_SITE
             , 'M_' + YYYYMM AS COLNAME
             , SM.SORT_ORDER_NO
             , CAL.CALENDAR_YYYYQQ AS CALENDAR_YYYYQQ
             , CAL.CALENDAR_YYYY AS CALENDAR_YYYY
             , A.YYYYMM ,A.QTY
             , CASE WHEN A.CURRENCY = '' THEN SI.CURRENCY ELSE ISNULL(A.CURRENCY, SI.CURRENCY) END AS CURRENCY 
             , ISV.FORECAST_INFO_CELL_PACK_COUNT
             , ISV.FORECAST_INFO_BIZ_TYPE AS BIZ_TYPE_NAME40 
             , (SELECT LMD.SEGMENT2  AS NAME FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] LMD WITH (NOLOCK) WHERE LOOKUP_TYPE = 'CELL_TYPE' AND ISV.CELL_TYPE = LMD.SEGMENT1 ) AS CELL_TYPE
             , isnull(ISV.ITEM_CLASS_NAME,'')AS ITEM_CLASS_NAME
             , isnull(ISV.ITEM_NAME,'')AS ITEM_NAME
             , isnull(ISV.ITEM_TYPE,'')AS ITEM_TYPE
             , isnull(ISV.NICK_NAME,'')AS NICK_NAME
             , ISV.MIN_CAPACITY
             , CASE WHEN ( CASE WHEN A.DIVISION_ID = '40' THEN SI.DEPT_ID ELSE A.DEPT_ID END ) = @v_dept_id THEN 'Y'
						WHEN @v_group_id ='ADMIN' THEN 'Y' ELSE 'N' END AS EDIT_FLAG				
             , SI.APPLICATION
             , SI.CUST_GROUP
             , SI.ATTRIBUTE5 AS FORECAST_INFO_CELL_MODEL
             , LEFT(SI.OWNER_NAME, 100) AS OWNER
             , A.DEPT_ID  AS DEPT_ID
             , S.VMI_YN 
             , SI.ROUTE
             , ISV.FORECAST_INFO_PRODUCT_GROUP
             , ISV.FORECAST_INFO_SPEC+ISV.FORECAST_INFOR_VERSION AS FORECAST_INFO_ALL
             , ISV.FORECAST_INFO_SPEC
             , ISV.FORECAST_INFOR_VERSION
             , ISV.MDM_PROJECT_NAME 
             , SI.CUST_GROUP_DTL
             , ISNULL(SI.attribute1,'') DMS_SALES
             , ISNULL(SI.attribute2,'') DMS_CUSTOMER
             , CASE WHEN MP.PROJECT_NAME = '' OR MP.PROJECT_NAME IS NULL THEN A.PROJECT_NAME ELSE MP.PROJECT_NAME END PROJECT_NAME
             , MP.PROJECT_OWNER
             , MP.PROJECT_STATUS
             , A.END_CUSTOMER
             , S.CITY_NAME
             , S.COUNTRY_NAME
             , A.FCST_TYPE AS FCST_TYPE40
             , SI.REPORT_GROUP1
             , SI.REPORT_GROUP2
             , SI.REPORT_GROUP3
             , SI.REPORT_GROUP4
             , SI.REPORT_GROUP5
             , SI.REPORT_GROUP6
             , SI.REPORT_GROUP7
             , SI.REPORT_GROUP8
             , A.BIZ_TYPE as BIZ_TYPE_NAME81
             , A.PROJECT_CODE AS PROJECT_CODE82
             , A.BIZ_TYPE AS BIZ_TYPE_NAME82
             , A.ITEM_ID AS ITEM_ID40
             , A.SCM_SITE_ID AS SCM_SITE_ID40
             , A.SCM_SITE_ID AS SCM_SITE_ID81
             , A.SCM_SITE_ID AS SCM_SITE_ID82
             , SI.DEPT_ID AS DEPT_ID40
             , MP.PRODUCT_GROUP_NAME
             , A.ITEM_USE
             , A.UNIT_ENERGY
             , ISNULL(S2.CELL_PER_CAR, 0) AS CELL_PER_CAR
             , ISNULL(S2.CELL_PER_CAR / S2.CELL_PER_MODULE, 0) AS MODULE_PER_CAR
			 --추가 컬럼
			 , S2.ALT_SIM_YN			--대체/유사모델 여부
			 , S2.ATTRIBUTE8 KWH		--KWh/Cell

			 , CASE 
					WHEN A.DIVISION_ID LIKE '81%' THEN
						ISNULL(A.CELL_PER_MODULE, S2.CELL_PER_MODULE)
					WHEN A.DIVISION_ID =    '82'  THEN
						A.CELL_PER_MODULE
			   END CELL_PER_MODULE		--Cell/Module (자동차사업부)(ESS사업부)
			, CASE 
					WHEN A.DIVISION_ID LIKE '81%' THEN
						ISNULL(A.CELL_PER_PACK, S2.CELL_PER_CAR)
					WHEN A.DIVISION_ID =    '82'  THEN
						A.CELL_PER_PACK
			   END CELL_PER_PACK		--Cell/Pack(ESS사업부), Cell/Car(자동차사업부)
			, CASE 
					WHEN A.DIVISION_ID LIKE '81%' THEN
						ISNULL(A.MODULE_PER_PACK, CASE WHEN ISNULL(S2.CELL_PER_MODULE, 0) = 0 THEN  NULL  ELSE  S2.CELL_PER_CAR / S2.CELL_PER_MODULE  END)
					WHEN A.DIVISION_ID =    '82'  THEN
						A.MODULE_PER_PACK
			   END MODULE_PER_PACK		--Module/Car  (자동차사업부)
		      , A.BIZ_TYPE				--PK: 모델구분(셀/팩/모듈)
		      , A.DOM_EXP				--PK: 내수/수출
		      , A.EXT_INT				--외주여부(External/Internal)
		      , A.OSP_YN				--OSP Flag
			  , null CELL_CODE			--Cell Code
			  , null CELL_NAME			--Cell Name
		  FROM DM_PLN_BIZPLAN A WITH (NOLOCK)
			   LEFT  JOIN SCM_MST_SITE S1 WITH (NOLOCK)
					   ON A.DIVISION_ID		= S1.DIVISION_ID
					  AND A.SCM_SITE_ID		= S1.SCM_SITE_ID
			   LEFT  JOIN SCM_MST_SITE_ITEM S2 WITH (NOLOCK)
					   ON A.DIVISION_ID		= S2.DIVISION_ID
					  AND A.PROJECT_CODE		= S2.PROJECT_CODE
					  AND A.SCM_SITE_ID		= S2.SCM_SITE_ID
					  AND A.ITEM_ID			= S2.ITEM_ID
			   LEFT  JOIN #TEMP_DM_MST_ITEM_SINGLE_V ISV WITH (NOLOCK)
					   ON A.DIVISION_ID		= ISV.DIVISION_ID
					  AND A.ITEM_ID			= ISV.ITEM_ID
			   LEFT  JOIN #TEMP_SCM_MST_SITE_ITEM SI WITH (NOLOCK)
					   ON A.DIVISION_ID		= SI.DIVISION_ID
					  AND A.SCM_SITE_ID		= SI.SCM_SITE_ID
					  AND A.PROJECT_CODE	= SI.PROJECT_CODE
					  AND A.iTEM_ID			= SI.ITEM_ID
			   LEFT  JOIN SCM_MST_PROJECT MP WITH (NOLOCK)
					   ON A.DIVISION_ID		= MP.DIVISION_ID
					  AND A.PROJECT_CODE	= MP.PROJECT_CODE
			   LEFT  JOIN (SELECT X.DIVISION_ID,X.SOLDTO_CUSTOMER
							    , X.END_CUSTOMER
								, X.DEPT_ID
								, X.SCM_SITE_ID
								, X.VMI_YN
								, X.VALID_YN
								, Y.CITY_NAME
								, Z.COUNTRY_NAME 
							 FROM SCM_MST_SITE X WITH (NOLOCK)
							    , SCM_MST_CITY Y WITH (NOLOCK)
								, SCM_MST_COUNTRY z WITH (NOLOCK)
							WHERE x.city    = y.city  
							  AND x.country = z.country
						  ) S 
					   ON A.DIVISION_ID		= S.DIVISION_ID
					  AND A.SCM_SITE_ID		= S.SCM_SITE_ID
			   -------------------------- Project 조건 ------------------------------------------------------
			   INNER JOIN (SELECT DISTINCT '%'+token+'%' tst 
			                 FROM dbo.String_Split(@p_project_code,',') 
						  ) b1
				       ON CASE 
								WHEN @p_project_code = '' THEN @p_project_code			
	    						ELSE A.PROJECT_CODE  
						  END like b1.tst 
					   OR CASE 
								WHEN @p_project_code = '' THEN @p_project_code			
								ELSE A.PROJECT_NAME  
						  END like b1.tst 
			   -----------------------------------------------------------------------------------------------
			   -------------------------- Model 조건 ---------------------------------------------------------
			   INNER JOIN (SELECT DISTINCT '%'+token+'%' tst 
			                 FROM dbo.String_Split(@p_item_id,',') 
						  ) b2
				       ON CASE 
								WHEN @p_item_id = '' THEN @p_item_id			
								ELSE A.ITEM_ID  
						  END like b2.tst 
					   OR CASE 
								WHEN @p_item_id = '' THEN @p_item_id			
								ELSE ISV.NICK_NAME  
						  END like b2.tst 
			   -----------------------------------------------------------------------------------------------
			   -------------------------- Owner 조건 ---------------------------------------------------------
			   INNER JOIN (SELECT '%'+token+'%' tst 
			                 FROM dbo.String_Split(@p_owner,',') 
						  ) b3
				       ON CASE 
								WHEN @p_owner = '' THEN @p_owner			
								ELSE SI.OWNER         
						  END like b3.tst 
					   OR CASE 
								WHEN @p_owner = '' THEN @p_owner			
								ELSE SI.OWNER_NAME    
						  END like b3.tst 
					   OR CASE 
								WHEN @p_owner = '' THEN @p_owner			
								ELSE SI.OWNER_NAME_KO 
						  END like b3.tst 
			   -----------------------------------------------------------------------------------------------
			   INNER JOIN #SELECT_MEASURE SM WITH (NOLOCK)
				       ON SM.MEASURE = A.MEASURE
			   INNER JOIN (SELECT CALENDAR_YYYY
			                    , CALENDAR_YYYYQQ
								, BASIS_YYYYMM 
					         FROM SCM_SYS_CALENDAR_M WITH (NOLOCK)
					        WHERE BASIS_YYYYMM >= @p_from_yyyymmdd 
							  AND BASIS_YYYYMM <= @p_to_yyyymmdd
					        GROUP BY 
							      CALENDAR_YYYY
								, CALENDAR_YYYYQQ
								, BASIS_YYYYMM
						  ) AS CAL
				       ON CAL.BASIS_YYYYMM = A.YYYYMM
		 WHERE 1=1
		   AND CASE 
					WHEN @p_dept_id = 'ALL' THEN 'ALL'
					ELSE CASE 
							WHEN A.DIVISION_ID = '40' THEN SI.DEPT_ID 
							ELSE A.DEPT_ID 
						 END
			   END IN (SELECT *
						 FROM dbo.UF_FX_String_SplitForIN(@p_dept_id,',') as P 
						WHERE (CASE 
									WHEN @p_dept_id = 'ALL' THEN 'ALL' 
									ELSE CASE 
											WHEN A.DIVISION_ID = '40' THEN SI.DEPT_ID 
											ELSE A.DEPT_ID 
										 END
							   END) = P.data
				      )
		   AND CASE 
					WHEN @p_end_customer = 'ALL' THEN 'ALL'
		   			ELSE isnull(CASE 
									WHEN @p_division_id = '40' THEN A.PROJECT_CODE 
									ELSE A.END_CUSTOMER 
								END, ''
							   )							
			   END IN (SELECT *
						 FROM dbo.UF_FX_String_SplitForIN (@p_end_customer,',') as P 
						WHERE (CASE 
									WHEN @p_end_customer = 'ALL' THEN 'ALL' 
									ELSE isnull(CASE 
													WHEN @p_division_id = '40' THEN A.PROJECT_CODE 
													ELSE A.END_CUSTOMER 
												END, '')
							   END) = P.data
					  )						   
		   AND CASE 
					WHEN @p_scm_site_id = 'ALL' THEN 'ALL'
		   			ELSE A.SCM_SITE_ID			
			   END IN (SELECT *
						 FROM dbo.UF_FX_String_SplitForIN (@p_scm_site_id,',') as P 
						WHERE (CASE 
									WHEN @p_scm_site_id = 'ALL' THEN 'ALL' 
									ELSE A.SCM_SITE_ID 
							   END) = P.data
					  )
		   AND CASE 
					WHEN @p_plant_site_id = 'ALL' THEN 'ALL'
		   			ELSE A.PLANT_SITE_ID			
			   END IN (SELECT * 
						 FROM dbo.UF_FX_String_SplitForIN (@p_plant_site_id,',') as P 
						WHERE (CASE 
									WHEN @p_plant_site_id = 'ALL' THEN 'ALL' 
									ELSE A.PLANT_SITE_ID 
							   END) = P.data
					  )
		   AND CASE 
					WHEN @p_item_type = 'ALL' THEN 'ALL'
		   			ELSE ISV.ITEM_TYPE			
			   END IN (SELECT *
						 FROM dbo.UF_FX_String_SplitForIN(@p_item_type,',') as P 
						WHERE (CASE 
									WHEN @p_item_type = 'ALL' THEN 'ALL' 
									ELSE ISV.ITEM_TYPE 
							   END) = P.data
					  )
		   AND CASE 
					WHEN @p_biztype = 'ALL' THEN 'ALL'
		   			ELSE CASE 
							WHEN @p_division_id = '40' THEN ISV.FORECAST_INFO_BIZ_TYPE 
							ELSE A.BIZ_TYPE 
						 END
			   END IN (SELECT *
						 FROM dbo.UF_FX_String_SplitForIN(@p_biztype,',') as P 
						WHERE (CASE 
									WHEN @p_biztype = 'ALL' THEN 'ALL' 
									ELSE CASE 
											WHEN @p_division_id = '40' THEN ISV.FORECAST_INFO_BIZ_TYPE
											ELSE A.BIZ_TYPE 
										 END
							   END) = P.data
					  )
		   AND A.YYYYMM      >= @p_from_yyyymmdd 
		   AND A.YYYYMM      <= @p_to_yyyymmdd
		   AND A.DIVISION_ID =  @p_division_id
		   AND ( ( @p_item_id IS NULL OR  @p_item_id = '' ) OR A.ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id ,',')) );
    END

	IF @p_qty_yn = 'Y'
	BEGIN
		IF OBJECT_ID (N'tempdb..#DLT_ITEM_ID', N'U') IS NOT NULL 
			DROP TABLE #DLT_ITEM_ID;

		SELECT 
               A.DIVISION_ID
             , A.PROJECT_CODE
             , A.PROJECT_CODE82
             , A.SCM_SITE_ID40
             , A.SCM_SITE_ID81
             , A.SCM_SITE_ID82                               
             , A.ITEM_ID
             , A.ITEM_ID40
             , A.DEPT_ID40
             , A.END_CUSTOMER
             , A.END_CUSTOMER40
             , A.BIZ_TYPE
             , A.PLANT_SITE_ID
             , A.FCST_TYPE
             , A.FCST_TYPE40
             , A.DOM_EXP
             , A.INCOTERMS
             , A.CURRENCY
             , A.MEASURE
		  INTO #DLT_ITEM_ID 
		  FROM #RAW_DATA AS A
		       INNER JOIN (SELECT 
							      DIVISION_ID
								, PROJECT_CODE
								, PROJECT_CODE82
								, SCM_SITE_ID40
								, SCM_SITE_ID81
								, SCM_SITE_ID82								
								, ITEM_ID
								, ITEM_ID40
								, DEPT_ID40
								, END_CUSTOMER
								, END_CUSTOMER40
								, BIZ_TYPE
								, PLANT_SITE_ID
								, FCST_TYPE
								, FCST_TYPE40
								, DOM_EXP
								, INCOTERMS
								, CURRENCY
								, MEASURE
			                 FROM #RAW_DATA
			                WHERE MEASURE = 'Business_Plan'
			                GROUP BY 
							      DIVISION_ID
								, PROJECT_CODE
								, PROJECT_CODE82
								, SCM_SITE_ID40
								, SCM_SITE_ID81
								, SCM_SITE_ID82								
								, ITEM_ID
								, ITEM_ID40
								, DEPT_ID40
								, END_CUSTOMER
								, END_CUSTOMER40
								, BIZ_TYPE
								, PLANT_SITE_ID
								, FCST_TYPE
								, FCST_TYPE40
								, DOM_EXP
								, INCOTERMS
								, CURRENCY
								, MEASURE
			               HAVING SUM(QTY) = 0
						  ) AS B
					   on
                          A.DIVISION_ID    = B.DIVISION_ID                                                                      
                      and A.PROJECT_CODE   = B.PROJECT_CODE                                                                      
                      and A.PROJECT_CODE82 = B.PROJECT_CODE82                                                                      
                      and A.SCM_SITE_ID40  = B.SCM_SITE_ID40                                                                      
                      and A.SCM_SITE_ID81  = B.SCM_SITE_ID81                                                                      
                      and A.SCM_SITE_ID82  = B.SCM_SITE_ID82                                                                      
                      and A.ITEM_ID        = B.ITEM_ID                                                                      
                      and A.ITEM_ID40      = B.ITEM_ID40                                                                      
                      and A.DEPT_ID40      = B.DEPT_ID40                                                                      
                      and A.END_CUSTOMER   = B.END_CUSTOMER                                                                      
                      and A.END_CUSTOMER40 = B.END_CUSTOMER40                                                                      
                      and A.BIZ_TYPE       = B.BIZ_TYPE                                                                      
                      and A.PLANT_SITE_ID  = B.PLANT_SITE_ID                                                                      
                      and A.FCST_TYPE      = B.FCST_TYPE                                                                      
                      and A.FCST_TYPE40    = B.FCST_TYPE40                                                                      
                      and A.DOM_EXP        = B.DOM_EXP                                                                      
                      and A.INCOTERMS      = B.INCOTERMS                                                                      
                      and A.CURRENCY       = B.CURRENCY                                                                      
                      and A.MEASURE        = B.MEASURE ;

		DELETE A 
		  FROM #RAW_DATA A
		       INNER JOIN #DLT_ITEM_ID B
				       ON 
                          A.DIVISION_ID    = B.DIVISION_ID                                                                      
                      and A.PROJECT_CODE   = B.PROJECT_CODE                                                                      
                      and A.PROJECT_CODE82 = B.PROJECT_CODE82                                                                      
                      and A.SCM_SITE_ID40  = B.SCM_SITE_ID40                                                                      
                      and A.SCM_SITE_ID81  = B.SCM_SITE_ID81                                                                      
                      and A.SCM_SITE_ID82  = B.SCM_SITE_ID82                                                                      
                      and A.ITEM_ID        = B.ITEM_ID                                                                      
                      and A.ITEM_ID40      = B.ITEM_ID40                                                                      
                      and A.DEPT_ID40      = B.DEPT_ID40                                                                      
                      and A.END_CUSTOMER   = B.END_CUSTOMER                                                                      
                      and A.END_CUSTOMER40 = B.END_CUSTOMER40                                                                      
                      and A.BIZ_TYPE       = B.BIZ_TYPE                                                                      
                      and A.PLANT_SITE_ID  = B.PLANT_SITE_ID                                                                      
                      and A.FCST_TYPE      = B.FCST_TYPE                                                                      
                      and A.FCST_TYPE40    = B.FCST_TYPE40                                                                      
                      and A.DOM_EXP        = B.DOM_EXP                                                                      
                      and A.INCOTERMS      = B.INCOTERMS                                                                      
                      and A.CURRENCY       = B.CURRENCY                                                                      
                      and A.MEASURE        = B.MEASURE ;
	END
	
    PRINT '------------- -1! : ' +  CONVERT(CHAR(23), getdate(), 21);
	
	SELECT X.DIVISION_ID		
         , X.PROJECT_CODE
         , X.END_CUSTOMER40
         , X.PLANT_SITE_ID
         , X.ITEM_ID
         , X.INCOTERMS
         , X.FCST_TYPE
         , X.MEASURE
         , MAX(X.CELL_PROD_SITE) CELL_PROD_SITE
         , 'Q_' + REPLACE(CALENDAR_YYYYQQ, 'Q', '_') AS COLNAME
         , X.SORT_ORDER_NO
         , X.CALENDAR_YYYYQQ AS CALENDAR_YYYYQQ		
         , X.CALENDAR_YYYY		
         , X.CALENDAR_YYYYQQ AS YYYYMM
         , CASE 
				WHEN MEASURE = 'SalesAmt_KRW' OR MEASURE = 'SalesAmt_LOC' OR MEASURE = 'SalesAmt_USD' OR MEASURE = 'Business_Plan'
				THEN SUM(QTY)
				ELSE MAX(QTY) 
		   END QTY
         , X.CURRENCY
         , MAX(X.FORECAST_INFO_CELL_PACK_COUNT) FORECAST_INFO_CELL_PACK_COUNT 
         , MAX(X.BIZ_TYPE_NAME40) BIZ_TYPE_NAME40
         , MAX(X.CELL_TYPE) CELL_TYPE
         , MAX(X.ITEM_CLASS_NAME) ITEM_CLASS_NAME
         , MAX(X.ITEM_NAME) ITEM_NAME
         , MAX(X.ITEM_TYPE) ITEM_TYPE
         , MAX(X.NICK_NAME) NICK_NAME
         , MAX(X.MIN_CAPACITY) MIN_CAPACITY
         , MAX(X.EDIT_FLAG) EDIT_FLAG
         , MAX(X.APPLICATION) APPLICATION
         , MAX(X.CUST_GROUP) CUST_GROUP
         , MAX(X.FORECAST_INFO_CELL_MODEL) FORECAST_INFO_CELL_MODEL
         , MAX(X.OWNER) OWNER
         , MAX(X.DEPT_ID) AS DEPT_ID
         , MAX(X.VMI_YN) VMI_YN
         , MAX(X.ROUTE) ROUTE
         , MAX(X.FORECAST_INFO_PRODUCT_GROUP) FORECAST_INFO_PRODUCT_GROUP
         , MAX(X.FORECAST_INFO_ALL) FORECAST_INFO_ALL
         , MAX(X.FORECAST_INFO_SPEC) FORECAST_INFO_SPEC
         , MAX(X.FORECAST_INFOR_VERSION) FORECAST_INFOR_VERSION
         , MAX(X.MDM_PROJECT_NAME) MDM_PROJECT_NAME
         , MAX(X.CUST_GROUP_DTL) CUST_GROUP_DTL
         , MAX(X.DMS_SALES) DMS_SALES
         , MAX(X.DMS_CUSTOMER) DMS_CUSTOMER
         , MAX(X.PROJECT_NAME) PROJECT_NAME
         , MAX(X.PROJECT_OWNER) PROJECT_OWNER
         , MAX(X.PROJECT_STATUS) PROJECT_STATUS
         , MAX(X.END_CUSTOMER) END_CUSTOMER
         , MAX(X.CITY_NAME) CITY_NAME
         , MAX(X.COUNTRY_NAME) COUNTRY_NAME
         , MAX(X.FCST_TYPE40)	FCST_TYPE40
         , MAX(X.REPORT_GROUP1) AS REPORT_GROUP1
         , MAX(X.REPORT_GROUP2) AS REPORT_GROUP2
         , MAX(X.REPORT_GROUP3) AS REPORT_GROUP3
         , MAX(X.REPORT_GROUP4) AS REPORT_GROUP4
         , MAX(X.REPORT_GROUP5) AS REPORT_GROUP5
         , MAX(X.REPORT_GROUP6) AS REPORT_GROUP6
         , MAX(X.REPORT_GROUP7) AS REPORT_GROUP7
         , MAX(X.REPORT_GROUP8) AS REPORT_GROUP8
		
         , MAX(X.BIZ_TYPE_NAME81) AS BIZ_TYPE_NAME81
         , MAX(X.PROJECT_CODE82) AS PROJECT_CODE82
         , MAX(X.BIZ_TYPE_NAME82) AS BIZ_TYPE_NAME82
         , MAX(X.ITEM_ID40) AS ITEM_ID40
         , MAX(X.SCM_SITE_ID40) AS SCM_SITE_ID40
         , MAX(X.SCM_SITE_ID81) AS SCM_SITE_ID81
         , MAX(X.SCM_SITE_ID82) AS SCM_SITE_ID82
         , MAX(X.DEPT_ID40) AS DEPT_ID40
         , MAX(X.PRODUCT_GROUP_NAME) PRODUCT_GROUP_NAME
         , MAX(X.ITEM_USE) ITEM_USE
         , MAX(X.UNIT_ENERGY) UNIT_ENERGY
         , MAX(ISNULL(X.CELL_PER_CAR,0)) AS CELL_PER_CAR
         , MAX(ISNULL(X.MODULE_PER_CAR,0)) AS MODULE_PER_CAR
		 --추가 컬럼
		 , MAX(X.ALT_SIM_YN) AS ALT_SIM_YN				--대체/유사모델 여부
		 , MAX(X.KWH) AS KWH							--KWh/Cell
		 , MAX(X.CELL_PER_MODULE) AS CELL_PER_MODULE	--Cell/Module (자동차사업부)(ESS사업부)
		 , MAX(X.CELL_PER_PACK)   AS CELL_PER_PACK		--Cell/Pack(ESS사업부), Cell/Car(자동차사업부)
		 , MAX(X.MODULE_PER_PACK) AS MODULE_PER_PACK	--Module/Car  (자동차사업부)
		 , X.BIZ_TYPE									--모델구분(셀/팩/모듈)
		 , X.DOM_EXP									--내수/수출
		 , MAX(X.EXT_INT) EXT_INT						--외주여부(External/Internal)
		 , MAX(X.OSP_YN)  OSP_YN						--OSP Flag
		 , MAX(CELL_CODE) CELL_CODE						--Cell Code
		 , MAX(CELL_NAME) CELL_NAME						--Cell Name
	  INTO #RAW_DATA_SUM
	  FROM #RAW_DATA X WITH (NOLOCK)
	 GROUP BY 
		   X.DIVISION_ID
         , X.PROJECT_CODE
         , X.PROJECT_NAME
		 , X.SCM_SITE_ID40
         , X.SCM_SITE_ID81
         , X.SCM_SITE_ID82
		 , X.ITEM_ID
         , X.ITEM_ID40
         , X.END_CUSTOMER
         , X.END_CUSTOMER40
		 , X.BIZ_TYPE							--PK: 모델구분(셀/팩/모듈)        
         , X.PLANT_SITE_ID
         , X.FCST_TYPE
		 , X.DOM_EXP							--PK: 내수/수출
		 , X.INCOTERMS
		 , X.CURRENCY
         , X.MEASURE
		 , X.SORT_ORDER_NO

         --, X.DEPT_ID         
         --, X.BIZ_TYPE_NAME40
         --, X.BIZ_TYPE_NAME81
         --, X.BIZ_TYPE_NAME82
         , X.CALENDAR_YYYY
         , X.CALENDAR_YYYYQQ
         --, X.PRODUCT_GROUP_NAME
         --, X.ITEM_USE
         --, X.UNIT_ENERGY
         --, X.CELL_PROD_SITE
		 
		 
		 
		 ;
PRINT '-------------0! : ' +  CONVERT(CHAR(23), getdate(), 21);
	INSERT 
	  INTO #RAW_DATA_SUM
	SELECT X.DIVISION_ID		
         , X.PROJECT_CODE
         , X.END_CUSTOMER40
         , X.PLANT_SITE_ID
         , X.ITEM_ID
         , X.INCOTERMS
         , X.FCST_TYPE
         , X.MEASURE
         , MAX(X.CELL_PROD_SITE) CELL_PROD_SITE
         , 'Y_' + X.CALENDAR_YYYY AS COLNAME
         , X.SORT_ORDER_NO
         , X.CALENDAR_YYYY AS CALENDAR_YYYYQQ		
         , X.CALENDAR_YYYY		
         , X.CALENDAR_YYYY AS YYYYMM
         , CASE 
				WHEN MEASURE = 'SalesAmt_KRW' OR MEASURE = 'SalesAmt_LOC' OR MEASURE = 'SalesAmt_USD' OR MEASURE = 'Business_Plan'
				THEN SUM(QTY)
				ELSE MAX(QTY) 
		   END QTY
         , X.CURRENCY
         , MAX(X.FORECAST_INFO_CELL_PACK_COUNT) FORECAST_INFO_CELL_PACK_COUNT 
         , MAX(X.BIZ_TYPE_NAME40) BIZ_TYPE_NAME40
         , MAX(X.CELL_TYPE) CELL_TYPE
         , MAX(X.ITEM_CLASS_NAME) ITEM_CLASS_NAME
         , MAX(X.ITEM_NAME) ITEM_NAME
         , MAX(X.ITEM_TYPE) ITEM_TYPE
         , MAX(X.NICK_NAME) NICK_NAME
         , MAX(X.MIN_CAPACITY) MIN_CAPACITY
         , MAX(X.EDIT_FLAG) EDIT_FLAG
         , MAX(X.APPLICATION) APPLICATION
         , MAX(X.CUST_GROUP) CUST_GROUP
         , MAX(X.FORECAST_INFO_CELL_MODEL) FORECAST_INFO_CELL_MODEL
         , MAX(X.OWNER) OWNER
         , MAX(X.DEPT_ID) AS DEPT_ID
         , MAX(X.VMI_YN) VMI_YN
         , MAX(X.ROUTE) ROUTE
         , MAX(X.FORECAST_INFO_PRODUCT_GROUP) FORECAST_INFO_PRODUCT_GROUP
         , MAX(X.FORECAST_INFO_ALL) FORECAST_INFO_ALL
         , MAX(X.FORECAST_INFO_SPEC) FORECAST_INFO_SPEC
         , MAX(X.FORECAST_INFOR_VERSION) FORECAST_INFOR_VERSION
         , MAX(X.MDM_PROJECT_NAME) MDM_PROJECT_NAME
         , MAX(X.CUST_GROUP_DTL) CUST_GROUP_DTL
         , MAX(X.DMS_SALES) DMS_SALES
         , MAX(X.DMS_CUSTOMER) DMS_CUSTOMER
         , MAX(X.PROJECT_NAME) PROJECT_NAME
         , MAX(X.PROJECT_OWNER) PROJECT_OWNER
         , MAX(X.PROJECT_STATUS) PROJECT_STATUS
         , MAX(X.END_CUSTOMER) END_CUSTOMER
         , MAX(X.CITY_NAME) CITY_NAME
         , MAX(X.COUNTRY_NAME) COUNTRY_NAME
         , MAX(X.FCST_TYPE40)	FCST_TYPE40
         , MAX(X.REPORT_GROUP1) AS REPORT_GROUP1
         , MAX(X.REPORT_GROUP2) AS REPORT_GROUP2
         , MAX(X.REPORT_GROUP3) AS REPORT_GROUP3
         , MAX(X.REPORT_GROUP4) AS REPORT_GROUP4
         , MAX(X.REPORT_GROUP5) AS REPORT_GROUP5
         , MAX(X.REPORT_GROUP6) AS REPORT_GROUP6
         , MAX(X.REPORT_GROUP7) AS REPORT_GROUP7
         , MAX(X.REPORT_GROUP8) AS REPORT_GROUP8
         , MAX(X.BIZ_TYPE_NAME81) AS BIZ_TYPE_NAME81
         , MAX(X.PROJECT_CODE82) AS PROJECT_CODE82
         , MAX(X.BIZ_TYPE_NAME82) AS BIZ_TYPE_NAME82
         , MAX(X.ITEM_ID40) AS ITEM_ID40
         , MAX(X.SCM_SITE_ID40) AS SCM_SITE_ID40
         , MAX(X.SCM_SITE_ID81) AS SCM_SITE_ID81
         , MAX(X.SCM_SITE_ID82) AS SCM_SITE_ID82
         , MAX(X.DEPT_ID40) AS DEPT_ID40
         , MAX(X.PRODUCT_GROUP_NAME) PRODUCT_GROUP_NAME
         , MAX(X.ITEM_USE) ITEM_USE
         , MAX(X.UNIT_ENERGY) UNIT_ENERGY
         , MAX(ISNULL(X.CELL_PER_CAR,0)) AS CELL_PER_CAR
         , MAX(ISNULL(X.MODULE_PER_CAR,0)) AS MODULE_PER_CAR
		 --추가 컬럼
		 , MAX(X.ALT_SIM_YN) AS ALT_SIM_YN				--대체/유사모델 여부
		 , MAX(X.KWH) AS KWH							--KWh/Cell
		 , MAX(X.CELL_PER_MODULE) AS CELL_PER_MODULE	--Cell/Module (자동차사업부)(ESS사업부)
		 , MAX(X.CELL_PER_PACK)   AS CELL_PER_PACK		--Cell/Pack(ESS사업부), Cell/Car(자동차사업부)
		 , MAX(X.MODULE_PER_PACK) AS MODULE_PER_PACK	--Module/Car  (자동차사업부)
		 , X.BIZ_TYPE									--모델구분(셀/팩/모듈)
		 , X.DOM_EXP									--내수/수출
		 , MAX(X.EXT_INT) EXT_INT						--외주여부(External/Internal)
		 , MAX(X.OSP_YN)  OSP_YN						--OSP Flag
		 , MAX(CELL_CODE) CELL_CODE						--Cell Code
		 , MAX(CELL_NAME) CELL_NAME						--Cell Name
	  FROM #RAW_DATA X WITH (NOLOCK)
	 GROUP BY 
		   X.DIVISION_ID
         , X.PROJECT_CODE
         , X.PROJECT_NAME
		 , X.SCM_SITE_ID40
         , X.SCM_SITE_ID81
         , X.SCM_SITE_ID82
		 , X.ITEM_ID
         , X.ITEM_ID40
         , X.END_CUSTOMER
         , X.END_CUSTOMER40
		 , X.BIZ_TYPE							--PK: 모델구분(셀/팩/모듈)        
         , X.PLANT_SITE_ID
         , X.FCST_TYPE
		 , X.DOM_EXP							--PK: 내수/수출
		 , X.INCOTERMS
		 , X.CURRENCY
         , X.MEASURE
		 , X.SORT_ORDER_NO

		 , X.CALENDAR_YYYY
         , X.CALENDAR_YYYYQQ	
		 ;
		 --  X.DIVISION_ID
         --, X.PROJECT_CODE
         --, X.PROJECT_NAME
         --, X.END_CUSTOMER
         --, X.END_CUSTOMER40
         --, X.SCM_SITE_ID40
         --, X.SCM_SITE_ID81
         --, X.SCM_SITE_ID82
         --, X.PLANT_SITE_ID
         --, X.ITEM_ID
         --, X.ITEM_ID40
         --, X.DEPT_ID
         --, X.INCOTERMS
         --, X.FCST_TYPE
         --, X.SORT_ORDER_NO
         --, X.BIZ_TYPE_NAME40
         --, X.BIZ_TYPE_NAME81
         --, X.BIZ_TYPE_NAME82
         --, X.CALENDAR_YYYY
         --, X.CALENDAR_YYYYQQ	
         --, X.CURRENCY
         --, X.MEASURE
         --, X.PRODUCT_GROUP_NAME
         --, X.ITEM_USE
         --, X.UNIT_ENERGY
         --, X.CELL_PROD_SITE
		 ----추가 컬럼
		 --, X.BIZ_TYPE							--PK: 모델구분(셀/팩/모듈)
		 --, X.DOM_EXP							--PK: 내수/수출		 
		 --;
	-- ################ #RAW_DATA and Quarter&Year Sum ###########################

	INSERT 
	  INTO #RAW_DATA
	SELECT * 
	  FROM #RAW_DATA_SUM WITH (NOLOCK);

    PRINT '-------------1! : ' +  CONVERT(CHAR(23), getdate(), 21);
	BEGIN
		SELECT @i_Count = Count(*)
		  FROM [dbo].[SCM_MST_TITLESET_USER] U WITH (NOLOCK)
		 WHERE 1 = 1
		   AND U.PROGRAM_ID  = @p_Program_Id
		   AND U.SHEET_NAME  = 'Biz Plan'    
		   AND U.USER_ID     = @p_created_by
		   AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C';

		IF @i_Count = 0 
		BEGIN
			SELECT @ColList = @ColList + '[' + COLUMN_NAME + '],'
				 , @GroupList = @GroupList + '[' + COLUMN_NAME + '] ' + DATA_SORT_METHOD_CODE + ','
			  FROM (
					-- ★★ ORDER BY 가능하려면 컬럼정의 100개 넘지 않아야함
					SELECT C.SORT_ORDER_NO
						 , C.COLUMN_NAME
						 , C.DATA_SORT_METHOD_CODE   
					  FROM [SCM_MST_SHEET_COLUMNS] C WITH (NOLOCK)
					 WHERE 1 = 1
					   AND C.PROGRAM_ID  = @p_Program_Id
					   AND C.SHEET_NAME  = 'Biz Plan'  
					   AND C.COLUMN_NAME<> 'TOTAL'
					   AND (   C.DEFAULT_FLAG = 'Y' 
							OR (    C.VISIBLE_FLAG = 'N'							   
								AND C.DEFAULT_FLAG = ''
								AND C.VALID_YN     = 'Y'
							   )
						   )
				   ) tbColList	
			 ORDER BY SORT_ORDER_NO;
		END
		ELSE
		BEGIN
			SELECT @ColList = @ColList + '[' + COLUMN_NAME + '],'
				 , @GroupList = @GroupList + '[' + COLUMN_NAME + '] ' + DATA_SORT_METHOD_CODE + ','
			  FROM (-- ★★ ORDER BY 가능하려면 컬럼정의 100개 넘지 않아야함
					SELECT U.SORT_ORDER_NO
					     , C.COLUMN_NAME
						 , U.DATA_SORT_METHOD_CODE						
					  FROM [dbo].[SCM_MST_TITLESET_USER] U WITH (NOLOCK)
						 , [dbo].[SCM_MST_SHEET_COLUMNS] C WITH (NOLOCK)
					 WHERE 1 = 1
					   AND U.PROGRAM_ID  = C.PROGRAM_ID
					   AND U.SHEET_NAME  = C.SHEET_NAME
					   AND U.COLUMN_NAME = C.COLUMN_NAME
					   AND U.PROGRAM_ID  = @p_Program_Id
					   AND U.SHEET_NAME  = 'Biz Plan'
					   AND U.USER_ID     = @p_created_by
					   AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'   
					   AND @p_division_id IN (SELECT token FROM dbo.String_Split(C.DIVISION_ID ,','))
					 UNION ALL
					SELECT TOP 100 
						   C.SORT_ORDER_NO
						 , C.COLUMN_NAME
						 , C.DATA_SORT_METHOD_CODE   
					  FROM [dbo].[SCM_MST_SHEET_COLUMNS] C WITH (NOLOCK)
					 WHERE  1 = 1
					   AND C.PROGRAM_ID   = @p_Program_Id
					   AND C.SHEET_NAME   = 'Biz Plan'
					   AND C.VISIBLE_FLAG = 'N'
					   AND C.DEFAULT_FLAG = ''
					   AND C.VALID_YN     = 'Y'
					   AND C.COLUMN_NAME  <> 'TOTAL'
					   AND @p_division_id IN (SELECT token FROM dbo.String_Split(C.DIVISION_ID ,','))	
				   ) tbColList	
			 ORDER BY SORT_ORDER_NO;
		END
	END

	SELECT @ColList   = LEFT(@ColList, LEN(@ColList)-1);
	SELECT @GroupList = LEFT(@GroupList, LEN(@GroupList)-1);    

    PRINT '-------------2! : ' +  CONVERT(CHAR(23), getdate(), 21);
-- 5. 피벗 결과 내기위한 날짜 리스트.
	SELECT @Prod = @Prod + '[' + A.COLNAME + '],'
	  FROM (SELECT DISTINCT COLNAME FROM #RAW_DATA WITH (NOLOCK)) A				
	 ORDER BY COLNAME;

	IF @Prod = '' 
	BEGIN
		SET @Prod = 'D_99999999';
	END
	ELSE
	BEGIN
		SELECT @Prod = LEFT(@Prod, LEN(@Prod)-1);
	END
    PRINT '-------------3! : ' +  CONVERT(CHAR(23), getdate(), 21);

-- 6. 최종 피벗 내기.
-- MEASURE에 따른 앞에 SORT_ORDER_NO 위한 삽입
	SELECT @ColList   = REPLACE(@ColList,'[MEASURE]','[SORT_ORDER_NO],[MEASURE]');
	SELECT @GroupList = REPLACE(@GroupList,'[MEASURE]','[SORT_ORDER_NO],[MEASURE]');
	SELECT @GroupList = REPLACE(@GroupList,'[CELL_PER_CAR] ASC,[MODULE_PER_CAR] ASC,', '');
print @ColList;
PRINT '-------------4! : ' +  CONVERT(CHAR(23), getdate(), 21);

	SET  @nsql2 = '
			SELECT  
				 ' + @ColList + '
				,' + @Prod + '
			--INTO TEMP_SKH_0326_SALES_PLAN_TOBE
			  FROM (
			--SELECT COLNAME, SUM(QTY) AS QTY, ' + @ColList + '
			        SELECT COLNAME
					     , CASE 
								WHEN MEASURE in (''LOC'',''USD'',''KRW'') THEN MAX(QTY) 
								ELSE SUM(QTY) 
						   END AS QTY, ' + @ColList + '  --Unit Price 인경우는 SUM하지 않고 AVG로 표기함
			          FROM #RAW_DATA WITH (NOLOCK)
			         GROUP BY COLNAME, ' + @ColList + '
			       ) T
		     PIVOT (MAX(QTY) FOR COLNAME IN (' + @prod + ')) AS PVT
		     ORDER BY 
				 ' + @GroupList + '			
		';
	execute dbo.SP_executesql @NSQL2;
	PRINT @prod;
	print @nsql2;
	--중장기 계획 관련 날짜 취득
	DECLARE @FROM_YYYYMM NCHAR(6), @TO_YYYYMM NCHAR(6), @VALID_YN NCHAR(1);

	SELECT @FROM_YYYYMM = ATTRIBUTE1
		 , @TO_YYYYMM = ATTRIBUTE2
		 , @VALID_YN = VALID_YN
	  FROM SCM_ADM_LOOKUP_MASTER_DETAIL AS A
	 WHERE A.LOOKUP_TYPE = 'DM_LONG_PLAN'
	   AND A.SEGMENT1    = @p_division_id
	   AND A.SEGMENT2    = 'Biz Plan'
	   AND A.VALID_YN    = 'Y';

	SELECT @VALID_YN AS VALID_YN 
		 , @FROM_YYYYMM AS START_YYYYMM
		 , @TO_YYYYMM AS END_YYYYMM
		 , MIN(A.START_YYYYQQ) AS START_YYYYQQ
		 , MAX(A.END_YYYYQQ) AS END_YYYYQQ
		 , MIN(A.START_YYYY) AS START_YYYY
		 , MAX(A.END_YYYY) AS END_YYYY
	  FROM (SELECT MIN(REPLACE(A.CALENDAR_YYYYQQ, 'Q', '')) AS START_YYYYQQ			  
			     , MAX(REPLACE(A.CALENDAR_YYYYQQ, 'Q', '')) AS END_YYYYQQ
			     , NULL                                     AS START_YYYY
			     , NULL                                     AS END_YYYY
		      FROM SCM_SYS_CALENDAR_M A
		           LEFT  JOIN (SELECT DISTINCT CALENDAR_YYYYQQ				
				                 FROM SCM_SYS_CALENDAR_M A
				                WHERE BASIS_YYYYMM <  @FROM_YYYYMM
					               OR BASIS_YYYYMM > @TO_YYYYMM
					          ) B 
					       ON A.CALENDAR_YYYYQQ = B.CALENDAR_YYYYQQ
		     WHERE A.BASIS_YYYYMM BETWEEN @FROM_YYYYMM AND @TO_YYYYMM
			   AND B.CALENDAR_YYYYQQ IS NULL
		     UNION ALL
		    SELECT 
			       NULL AS START_YYYYMM
			     , NULL AS END_YYYYMM
			     , MIN(A.CALENDAR_YYYY) AS START_YYYY
			     , MAX(A.CALENDAR_YYYY) AS END_YYYY
		      FROM SCM_SYS_CALENDAR_M A
		           LEFT  JOIN (SELECT DISTINCT CALENDAR_YYYY				
				                 FROM SCM_SYS_CALENDAR_M A
				                WHERE BASIS_YYYYMM < @FROM_YYYYMM
					               OR BASIS_YYYYMM > @TO_YYYYMM
					          ) B 
						   ON A.CALENDAR_YYYY = B.CALENDAR_YYYY
		     WHERE A.BASIS_YYYYMM BETWEEN @FROM_YYYYMM AND @TO_YYYYMM
			   AND B.CALENDAR_YYYY IS NULL
		   ) A;
END;
