2026-03-26 14:38:45

/*
 * Program ID   : DMF0053_GET_CUST_FCST_WATERFALL
 * Description  : CUST Fcst Waterfall 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023.03.27	chano0612		
   2023/12/05		kjj			PJ20230691R  LGES SCM 역량 강화 위한 개선과제 이행 - 예외처리 항목 추가 작업중
 * 2023.12.07    kcw3408       [개발요청] 수요분석시스템_4_고객수요 Measure 통합 
 * 2023.12.20    hmin          [E20231124-001795] Customer FCST Waterfall 화면 조회 시 조건 적용 불완전함 개선
 * 2024.03.06    kcw3408       DM 프로시저 속도개선  
 * 2024.04.23    kcw3408       SENDER_NAME 30--> 200 으로 수정
 * 2024/08/28	 KJJ			[PJ2024-50461] Team Mapping
 **************************************************************************************************
 */
 
CREATE PROCEDURE [dbo].[DMF0053_GET_CUST_FCST_WATERFALL]
     @p_division_id				NVARCHAR(30)
	,@p_dept_id					NVARCHAR(4000)
    ,@p_end_customer			NVARCHAR(4000)
	,@p_scm_site_id				NVARCHAR(4000)
    ,@p_project_code				NVARCHAR(4000)
	,@p_item_id					NVARCHAR(4000)
	,@p_item_type					NVARCHAR(4000)
	,@p_from_yyyymmdd		NVARCHAR(8)
	,@p_to_yyyymmdd			NVARCHAR(8)
	,@p_created_by				NVARCHAR(4000)
	,@p_plant_site_id				NVARCHAR(4000)
	,@p_biz_type					NVARCHAR(4000)
	,@p_owner						NVARCHAR(4000)
	,@p_bucket						NVARCHAR(20)	
	,@p_user_dept_id				NVARCHAR(50)	
	,@p_group_id					NVARCHAR(50)
	,@p_version_no				NVARCHAR(50)
	,@p_from_createdate		NVARCHAR(8)
	,@p_to_createdate			NVARCHAR(8)

AS  
BEGIN

  SET NOCOUNT ON;
  --SET ANSI_WARNINGS OFF; 
  SET ANSI_NULLS ON
  SET ANSI_WARNINGS ON; 

print 'A--' + convert(varchar(30), getdate(), 121)

  DECLARE @ColList					NVARCHAR(MAX);
  DECLARE @OrderList				NVARCHAR(MAX);
  DECLARE @nsql					NVARCHAR(MAX);
  DECLARE @nsql2					NVARCHAR(MAX);
  DECLARE @p_program_id		VARCHAR(50) = 'DMF0053'
  DECLARE @p_sheet_name		VARCHAR(50) = 'CUST Fcst Waterfall'
  
  SET		@ColList		= '';
  SET		@OrderList		= '';
    
  DECLARE	@i_count	int	= 0;
  DECLARE @v_user_mea_cnt int =0;
  
	------------------------------------------------------------------------------------------
	--                                                       Temp Table 존재 여부 체크 (BEGIN)
	------------------------------------------------------------------------------------------
	IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_V', N'U') IS NOT NULL 
		DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_V	;

	IF OBJECT_ID (N'tempdb..#SELECT_MEASURE', N'U') IS NOT NULL 
		DROP TABLE #SELECT_MEASURE;	
		
	IF OBJECT_ID (N'tempdb..#RAW_DATA', N'U') IS NOT NULL 
		DROP TABLE #RAW_DATA;

	IF OBJECT_ID (N'tempdb..#TEMP_SCM_MST_SITE_ITEM', N'U') IS NOT NULL 
		DROP TABLE #TEMP_SCM_MST_SITE_ITEM;
		
	IF OBJECT_ID (N'tempdb..#TEMP_SCM_MST_SITE', N'U') IS NOT NULL 
		DROP TABLE #TEMP_SCM_MST_SITE;

	IF OBJECT_ID (N'tempdb..#T_COLUMN_SETUP', N'U') IS NOT NULL 
		DROP TABLE #T_COLUMN_SETUP;
	
	IF OBJECT_ID (N'tempdb..#CALENDAR', N'U') IS NOT NULL 
		DROP TABLE #CALENDAR;

	IF OBJECT_ID (N'tempdb..#T', N'U') IS NOT NULL 
		DROP TABLE #T;	
		
	IF OBJECT_ID (N'tempdb..#WF', N'U') IS NOT NULL 
		DROP TABLE #WF;			
			 
	IF OBJECT_ID (N'tempdb..#TEMP_DM_DNM_EDI_CALLOFF_ITEM', N'U') IS NOT NULL 
		DROP TABLE #TEMP_DM_DNM_EDI_CALLOFF_ITEM;
		

print 'B--' + convert(varchar(30), getdate(), 121)
 
    /* 2024.03.06    kcw3408       DM 프로시저 속도개선: 불필요 컬러 삭제 */
	CREATE TABLE #RAW_DATA (
			  DIVISION_ID						NVARCHAR(30)
			, PROJECT_CODE					NVARCHAR(50)
			, SCM_SITE_ID						NVARCHAR(30)
			, ITEM_ID							NVARCHAR(50)
			, YYYYMMDD						CHAR(8)
			--, OWNER							NVARCHAR(100)
			--, SOLDTO_CODE					NVARCHAR(30)
			, CUST_ITEM_ID					NVARCHAR(130)
			--, DEPT_NAME_KO				NVARCHAR(130)
			--, END_CUSTOMER				NVARCHAR(30)
			--, BIZ_TYPE							NVARCHAR(30)
			, COUNTRY							NVARCHAR(130)
			, CITY									NVARCHAR(130)
			, FCST_TYPE						NVARCHAR(20)
			, DOM_EXP							NVARCHAR(3)
			--, CUST_GROUP					NVARCHAR(50)
			--, CUST_GROUP_DTL				NVARCHAR(50)
			--, APPLICATION					NVARCHAR(50)
			--, CELL_MODEL_NICK_NAME	NVARCHAR(50)
			--, PRODUCT_GROUP				NVARCHAR(50)
			--, ENERGE							NVARCHAR(50)
			--, CELL_QUANTITY					NVARCHAR(50)
			--, SENDER_CODE					NVARCHAR(30)
			, SENDER_NAME					NVARCHAR(200)
			--, PROJECT_NAME					NVARCHAR(150)
			--, PROJECT_OWNER				NVARCHAR(50)
			--, PROJECT_STATUS				NVARCHAR(50)
			, PLANT_SITE_ID					NVARCHAR(30)
			--, ITEM_NAME						NVARCHAR(50)
			--, NICK_NAME						NVARCHAR(50)
			--, ITEM_TYPE						NVARCHAR(50)
			--, MIN_CAPACITY					NVARCHAR(50)
			, INCOTERMS						NVARCHAR(10)
			, UNLOADING_POINT			NVARCHAR(30)
			--, TEAM_NAME_KO				NVARCHAR(30)
			--, SOLDTO_CUSTOMER			NVARCHAR(50)
			, MEASURE							NVARCHAR(50)
			--, MDM_PROJECT_NAME		NVARCHAR(150)
			--, ROUTE								NVARCHAR(50)
			--, CELL_PER_CAR					NVARCHAR(50)
			--, CELL_PER_MODULE			NVARCHAR(50)
			--, MODULE_PER_CAR				NVARCHAR(50)
			--, KWH_CELL						NVARCHAR(50)
			--, KWH_MODULE					NVARCHAR(50)
			--, KWH_PACK						NVARCHAR(50)
			--, SALES_COMPANY				NVARCHAR(50) 
			, MEASURE_GROUP				NVARCHAR(50)
			, QTY									NUMERIC(30,10)
			--, VALID_YN							CHAR(1)
			--, VMI_YN							CHAR(1)
			--, PLAN_RESULT					CHAR(1)
			--, GUBUN							TINYINT
			, CREATE_DATE					NVARCHAR(20)
			, LAST_UPDATED_BY				NVARCHAR(150)
			, LAST_UPDATE_DATE			NVARCHAR(20)
			, EDI_IF_SEQ						NVARCHAR(20)
			, CUSTOMER_PLANT				NVARCHAR(20)
			, EXCEPTION_FLAG				NVARCHAR(1)
			, EXCEPTION_DATE				NVARCHAR(150)
			)

	
print 'C1--' + convert(varchar(30), getdate(), 121)

	SELECT @v_user_mea_cnt = COUNT(*)
	FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
	WHERE  1 = 1
	AND U.PROGRAM_ID				= @p_program_id
	AND U.SHEET_NAME				= @p_sheet_name
	AND U.USER_INQUIRY_COLUMN_TYPE_CODE	= 'M'
	AND U.USER_ID						= @p_created_by;

	IF @v_user_mea_cnt = 0
		BEGIN	    
			INSERT INTO [dbo].[SCM_MST_TITLESET_USER]
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
			SELECT @p_created_by
					, C.PROGRAM_ID
					, C.SHEET_NAME
					, 'M'
					, C.COLUMN_NAME
					, C.SORT_ORDER_NO
					, 'N'
					, ''
					, @p_created_by
					, CONVERT(VARCHAR(19), GETDATE(), 121)
					, @p_created_by
					, CONVERT(VARCHAR(19), GETDATE(), 121)
			FROM  [dbo].[SCM_MST_SHEET_MEASURE] C WITH(NOLOCK)
			WHERE 1 = 1
			AND C.PROGRAM_ID	= @p_program_id
			AND C.SHEET_NAME	= @p_sheet_name
			AND C.DEFAULT_FLAG	= 'Y'
			AND C.VALID_YN			= 'Y'	;
		END;

	SELECT DISTINCT ISNULL(U.PROGRAM_ID, 'DMF0053') AS PROGRAM_ID
			 , U.SHEET_NAME
			 , U.USER_ID
			 , U.COLUMN_NAME AS MEASURE_GROUP
			 , U.COLUMN_NAME AS MEASURE
		     , SMSM.SORT_ORDER_NO      -- 20231212 kcw3408 4_고객수요 Measure 통합
			 , 'N' AS SYSTEM_ADD
	INTO #SELECT_MEASURE 
	FROM SCM_MST_TITLESET_USER U WITH(NOLOCK)
	JOIN [dbo].[SCM_MST_SHEET_MEASURE] SMSM WITH(NOLOCK)
		ON U.PROGRAM_ID = SMSM.PROGRAM_ID
		AND U.SHEET_NAME = SMSM.SHEET_NAME
		AND U.COLUMN_NAME = SMSM.COLUMN_NAME
		AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
		AND SMSM.VALID_YN     = 'Y'	
	LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL T WITH(NOLOCK) 
	ON (U.USER_ID = T.SEGMENT4)
		AND @p_created_by = T.SEGMENT4  -- USER_ID
		AND T.LOOKUP_TYPE = 'TMM_MEASURE_ADMIN'
		AND T.VALID_YN = 'Y'
	WHERE 1 = 1
	AND U.USER_INQUIRY_COLUMN_TYPE_CODE	= 'M'
	AND U.PROGRAM_ID = 'DMF0053'
	AND U.SHEET_NAME = 'CUST Fcst Waterfall'
	AND U.USER_ID = @p_created_by
	AND U.USER_ID = CASE WHEN U.COLUMN_NAME = 'TMM_FCST' THEN T.SEGMENT4 ELSE @p_created_by END

	UNION ALL
	SELECT ISNULL(A.PROGRAM_ID, 'DMF0053') AS PROGRAM_ID
			 , A.SHEET_NAME,A.USER_ID,A.MEASURE_GROUP,B.MEASURE,A.SORT_ORDER_NO + B.SORT_ORDER_NO  
			 , 'N' AS SYSTEM_ADD
	FROM 
			(SELECT U.PROGRAM_ID
						, U.SHEET_NAME
						, U.USER_ID
						, 'CUST_FCST_EDI' AS MEASURE_GROUP  -- Ui Caterory Setup 의 Small Label 에 설정된 그룹명칭
						, SMSM.SORT_ORDER_NO                -- 20231212 kcw3408 4_고객수요 Measure 통합
			FROM [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK,INDEX (PK_SCM_MST_TITLESET_USER))
			    JOIN [dbo].[SCM_MST_SHEET_MEASURE] SMSM WITH(NOLOCK)
				ON U.PROGRAM_ID = SMSM.PROGRAM_ID
			    AND U.SHEET_NAME = SMSM.SHEET_NAME
				AND U.COLUMN_NAME = SMSM.COLUMN_NAME
				AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
				AND SMSM.VALID_YN     = 'Y'	
			WHERE 1 = 1
			AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
			AND U.PROGRAM_ID = 'DMF0053'
			AND U.SHEET_NAME = 'CUST Fcst Waterfall'
			AND U.USER_ID = @p_created_by
			AND U.COLUMN_NAME = 'CUST_FCST_EDI'  -- Ui Caterory Setup 의 Column_Name 에 설정된 그룹명칭
			) A,
			( 
				SELECT 'Immidiate' MEASURE,0.14 AS SORT_ORDER_NO
				UNION ALL									
				SELECT 'Planning_Forecast' MEASURE,0.17 AS SORT_ORDER_NO
				UNION ALL
				SELECT 'Commercial_Agreement' MEASURE,0.12 AS SORT_ORDER_NO
				UNION ALL
				SELECT 'Firm_Temp' MEASURE,0.13 AS SORT_ORDER_NO
				UNION ALL
				SELECT 'Manumacturing_Material_Temp' MEASURE,0.15 AS SORT_ORDER_NO
				UNION ALL
				SELECT 'Material_Temp' MEASURE,0.16 AS SORT_ORDER_NO
				UNION ALL
				SELECT 'Backorder' MEASURE,0.11 AS SORT_ORDER_NO
			) B
	WHERE 1=1
	GROUP BY A.PROGRAM_ID, A.SHEET_NAME, A.USER_ID, A.MEASURE_GROUP, B.MEASURE, A.SORT_ORDER_NO + B.SORT_ORDER_NO 

	UNION ALL
	SELECT DISTINCT 'DMF0053' AS PROGRAM_ID
				, 'CUST Fcst Waterfall' AS SHEET_NAME     
				, @p_created_by	AS USER_ID
				, 'CUST_FCST'	AS MEASURE_GROUP
				, C.MEASURE	AS MEASURE
				, (SELECT SMSM.SORT_ORDER_NO      -- 20231212 kcw3408 4_고객수요 Measure 통합
				FROM [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK,INDEX (PK_SCM_MST_TITLESET_USER))
			    JOIN [dbo].[SCM_MST_SHEET_MEASURE] SMSM WITH(NOLOCK)
				ON U.PROGRAM_ID = SMSM.PROGRAM_ID
			    AND U.SHEET_NAME = SMSM.SHEET_NAME
				AND U.COLUMN_NAME = SMSM.COLUMN_NAME
				AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
				AND SMSM.VALID_YN     = 'Y'	
				WHERE 1 = 1
				AND U.USER_INQUIRY_COLUMN_TYPE_CODE	= 'M'
				AND U.PROGRAM_ID	= 'DMF0053'
				AND U.SHEET_NAME	= 'CUST Fcst Waterfall'
				AND U.USER_ID	= @p_created_by
				AND U.COLUMN_NAME	= 'CUST_FCST') + 0.1  AS SORT_ORDER_NO
				,'N' AS SYSTEM_ADD
    FROM [dbo].[DM_MST_CUSTOMER_FCST] C WITH(NOLOCK,INDEX (PK_DM_MST_CUSTOMER_FCST))
	WHERE 1 = 1
    AND C.MEASURE_GROUP = 'CUST_FCST'
    AND C.MEASURE <> ''
    AND C.VALID_YN = 'Y'
    AND EXISTS (SELECT * FROM [dbo].[SCM_MST_TITLESET_USER] X WITH(NOLOCK,INDEX (PK_SCM_MST_TITLESET_USER))
						WHERE  1 = 1
						AND X.USER_INQUIRY_COLUMN_TYPE_CODE	= 'M'
						AND X.PROGRAM_ID					= 'DMF0053'
						AND X.SHEET_NAME					= 'CUST Fcst Waterfall'
						AND X.USER_ID						= @p_created_by
						AND X.COLUMN_NAME					= 'CUST_FCST'
						AND X.COLUMN_NAME					= C.MEASURE_GROUP
						)


print 'C2--' + convert(varchar(30), getdate(), 121)


    /* 2024.03.06    kcw3408       DM 프로시저 속도개선: DM_DNM_EDI_CALLOFF_ITEM 템프사용 */ 
	SELECT DIVISION_ID
		, SENDER_CODE
		, UNLOADING_POINT
		, CUST_MATERIAL_CODE
		, MAX(EXCEPTION_FLAG) AS EXCEPTION_FLAG
		, MAX(CONVERT(VARCHAR, EXCEPTION_DATE, 112)) AS EXCEPTION_DATE
	INTO #TEMP_DM_DNM_EDI_CALLOFF_ITEM
	FROM DM_DNM_EDI_CALLOFF_ITEM WITH(NOLOCK)
	WHERE DIVISION_ID =@p_division_id
	GROUP BY DIVISION_ID
		, SENDER_CODE
		, UNLOADING_POINT
		, CUST_MATERIAL_CODE
		 
print 'D1--' + convert(varchar(30), getdate(), 121)
 
    /* 2024.03.06    kcw3408       DM 프로시저 속도개선: 불필요 컬럼 삭제 */ 
	BEGIN 
		INSERT INTO #RAW_DATA 
				( DIVISION_ID,PROJECT_CODE, SCM_SITE_ID,ITEM_ID,YYYYMMDD
				, CUST_ITEM_ID, COUNTRY, CITY , FCST_TYPE, DOM_EXP,SENDER_NAME
				, PLANT_SITE_ID, INCOTERMS, UNLOADING_POINT, MEASURE, MEASURE_GROUP
				, QTY, CREATE_DATE
				, LAST_UPDATED_BY
				, LAST_UPDATE_DATE
				, EDI_IF_SEQ
				, CUSTOMER_PLANT
				, EXCEPTION_FLAG
				, EXCEPTION_DATE
				)
				 /*SENDER_CODE, OWNER, SOLDTO_CODE
				, PROJECT_NAME, PROJECT_OWNER, PROJECT_STATUS
				, ITEM_NAME, NICK_NAME, ITEM_TYPE, MIN_CAPACITY, ENERGE
				, APPLICATION, CELL_MODEL_NICK_NAME
				, CUST_GROUP, CUST_GROUP_DTL, ROUTE, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, KWH_CELL, KWH_MODULE, KWH_PACK
				, MDM_PROJECT_NAME
				, SALES_COMPANY, END_CUSTOMER, BIZ_TYPE, VMI_YN
				, DEPT_NAME_KO
				, TEAM_NAME_KO
				, SOLDTO_CUSTOMER
				, PLAN_RESULT, GUBUN */
		SELECT DISTINCT 
				  A.DIVISION_ID,A.PROJECT_CODE,A.SCM_SITE_ID,A.ITEM_ID,A.YYYYMMDD
				, A.CUST_MATERIAL_CODE, A.COUNTRY,A.CITY,A.FCST_TYPE,A.DOM_EXP,A.SENDER_NAME
				, A.PLANT_SITE_ID,A.INCOTERMS,A.UNLOADING_POINT,A.MEASURE
				, (CASE WHEN A.DIVISION_ID = '40' AND E.MEASURE_GROUP IS NULL THEN ''
						WHEN A.DIVISION_ID = '40' THEN E.MEASURE_GROUP
					    ELSE '' END) AS MEASURE_GROUP				
				, A.QTY
				, REPLACE(CONVERT(VARCHAR(19), A.CREATE_DATE, 112), '-', '') AS CREATE_DATE
				, A.LAST_UPDATED_BY
				, REPLACE(CONVERT(VARCHAR(19), A.LAST_UPDATE_DATE, 112), '-', '') AS LAST_UPDATE_DATE
				, A.EDI_IF_SEQ
				, A.CUSTOMER_PLANT				
				, CITM.EXCEPTION_FLAG
				, CITM.EXCEPTION_DATE
						
				/*
				A.SENDER_CODE,A.OWNER, A.SOLDTO_CODE
				, A.PROJECT_NAME, A.PROJECT_OWNER, A.PROJECT_STATUS
				, D.ITEM_NAME, D.NICK_NAME, D.ITEM_TYPE,D.MIN_CAPACITY, D.ENERGE
				, B.APPLICATION
				,(CASE WHEN A.DIVISION_ID = '81' THEN D.NICK_NAME
					   ELSE [dbo].[FN_GET_ITEM_NICKNAME](A.DIVISION_ID, A.ITEM_ID) END) AS CELL_MODEL_NICK_NAME   
				, B.CUST_GROUP,  B.CUST_GROUP_DTL, B.ROUTE, A.CELL_PER_CAR, A.CELL_PER_MODULE, A.MODULE_PER_CAR, A.KWH_PER_CELL, A.KWH_PER_MODULE, A.KWH_PER_PACK
				, D.MDM_PROJECT_NAME
				, B.SALES_COMPANY, C.END_CUSTOMER, A.BIZ_TYPE, A.VMI_YN
				, X.DEPT_NAME_KO AS DEPT_NAME_KO
				, X.DEPT_NAME_KO AS TEAM_NAME_KO
				, A.SOLDTO_CUSTOMER
				, 'P', 1
				 
				,(
					SELECT TOP 1 EXCEPTION_FLAG 
					FROM SCM_ADM_LOOKUP_MASTER_DETAIL LUP WITH(NOLOCK)	
					WHERE LUP.LOOKUP_TYPE = 'DM_DNM_EDI_CALLOFF_ITEM_EXCLUDE'	
					AND LUP.SEGMENT1  = A.DIVISION_ID
					AND LUP.SEGMENT2  = A.SENDER_CODE
					AND LUP.SEGMENT3  = A.UNLOADING_POINT
					AND LUP.SEGMENT4 = A.CUST_MATERIAL_CODE
					--AND LUP.VALID_YN = 'Y'
					--AND (A.YYYYMMDD BETWEEN LUP.ATTRIBUTE2 AND LUP.ATTRIBUTE3)
				) EXCEPTION_FLAG
				,(
					SELECT TOP 1 EXCEPTION_DATE 
					FROM SCM_ADM_LOOKUP_MASTER_DETAIL LUP WITH(NOLOCK)	
					WHERE LUP.LOOKUP_TYPE = 'DM_DNM_EDI_CALLOFF_ITEM_EXCLUDE'	
					AND LUP.SEGMENT1  = A.DIVISION_ID
					AND LUP.SEGMENT2  = A.SENDER_CODE
					AND LUP.SEGMENT3  = A.UNLOADING_POINT
					AND LUP.SEGMENT4 = A.CUST_MATERIAL_CODE
					--AND LUP.VALID_YN = 'Y'
					--AND (A.YYYYMMDD BETWEEN LUP.ATTRIBUTE2 AND LUP.ATTRIBUTE3)
				) EXCEPTION_DATE	
				,(
					SELECT MAX(EXCEPTION_FLAG)
					FROM DM_DNM_EDI_CALLOFF_ITEM CITM
					WHERE CITM.DIVISION_ID = A.DIVISION_ID
						AND CITM.SENDER_CODE = A.SENDER_CODE
						AND CITM.UNLOADING_POINT = A.UNLOADING_POINT
						AND CITM.CUST_MATERIAL_CODE = A.CUST_MATERIAL_CODE
				) EXCEPTION_FLAG
				,(
					SELECT MAX(CONVERT(VARCHAR, EXCEPTION_DATE, 112))
					FROM DM_DNM_EDI_CALLOFF_ITEM CITM
					WHERE CITM.DIVISION_ID = A.DIVISION_ID
						AND CITM.SENDER_CODE = A.SENDER_CODE
						AND CITM.UNLOADING_POINT = A.UNLOADING_POINT
						AND CITM.CUST_MATERIAL_CODE = A.CUST_MATERIAL_CODE
				) EXCEPTION_DATE				
				*/  
				
		FROM DM_PLN_CUST_FCST_H A WITH(NOLOCK)
		JOIN #SELECT_MEASURE E WITH(NOLOCK)
		ON A.MEASURE = E.MEASURE
		--LEFT OUTER JOIN #TEMP_SCM_MST_SITE_ITEM_T B WITH(NOLOCK)
		--ON A.DIVISION_ID = B.DIVISION_ID 
		--	AND A.SCM_SITE_ID = B.SCM_SITE_ID 
		--	AND A.PROJECT_CODE = B.PROJECT_CODE 
		--	AND A.ITEM_ID = B.ITEM_ID
		--LEFT OUTER JOIN #TEMP_SCM_MST_SITE C  WITH(NOLOCK)
		--ON A.DIVISION_ID = C.DIVISION_ID 
		--	AND A.SCM_SITE_ID = C.SCM_SITE_ID
		--LEFT OUTER JOIN #TEMP_DM_MST_ITEM_SINGLE_V D  WITH(NOLOCK)
		--ON A.DIVISION_ID = D.DIVISION_ID 
		--	AND A.ITEM_ID = D.ITEM_ID
		--JOIN #CALENDAR CAL WITH(NOLOCK)
		--ON A.YYYYMMDD = CAL.BASIS_YYYYMMDD 
		
		 LEFT OUTER JOIN 
		 #TEMP_DM_DNM_EDI_CALLOFF_ITEM CITM  WITH(NOLOCK)
		     ON CITM.DIVISION_ID = A.DIVISION_ID
			AND CITM.SENDER_CODE = A.SENDER_CODE
			AND CITM.UNLOADING_POINT = A.UNLOADING_POINT
			AND CITM.CUST_MATERIAL_CODE = A.CUST_MATERIAL_CODE
			 
		/*예외처리 조인 추가===================================*/
		--이 방식으로 조인하니 PK가 제외되어 풀스캔 탐. 시간이 너무 걸려서 서브쿼리로 빼기로 함
		/*LEFT OUTER JOIN DM_DNM_EDI_CALLOFF_ITEM CITM WITH(NOLOCK)
		ON CITM.DIVISION_ID = A.DIVISION_ID
			AND CITM.SENDER_CODE = A.SENDER_CODE
			AND CITM.UNLOADING_POINT = A.UNLOADING_POINT
			AND CITM.CUST_MATERIAL_CODE = A.CUST_MATERIAL_CODE
			*/
		--========================================================= 

		WHERE A.DIVISION_ID =@p_division_id
		AND A.YYYYMMDD >= @p_from_yyyymmdd 
		AND A.YYYYMMDD <= @p_to_yyyymmdd 
		AND A.CREATE_DATE >= @p_from_createdate 
		AND A.CREATE_DATE <= @p_to_createdate

	END

	 
print 'E1--' + convert(varchar(30), getdate(), 121)
	
	CREATE CLUSTERED INDEX idx_t1 ON #RAW_DATA (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, MEASURE )
	
print 'E2--' + convert(varchar(30), getdate(), 121)
	 
	 
    /* 2024.03.06    kcw3408       DM 프로시저 속도개선: #TEMP_DM_MST_ITEM_SINGLE_V 테이블 변경 */  
 SELECT DISTINCT A.DIVISION_ID, A.ITEM_ID, ITEM_CLASS  
   , ITEM_NAME, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MIN_CAPACITY  
   , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_PRODUCT_GROUP  
   , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION  
   , ENERGE, CELL_QUANTITY  
   , MDM_PROJECT_NAME, CELL_TYPE, SCP_EXTRA_SPEC  
  INTO #TEMP_DM_MST_ITEM_SINGLE_V  
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
				MAX(T1.SCP_EXTRA_SPEC)						  AS SCP_EXTRA_SPEC    -- [20210428 SJHAN / CSR ID:C20210323-000420] 
			FROM SCM_MST_ITEM_SN T1 WITH(NOLOCK)					
			INNER JOIN ( SELECT DIVISION_ID, LEFT(ITEM_ID, 12) AS ITEM_ID
							, MAX(FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE
							, MAX(FORECAST_INFO_PRODUCT_GROUP) AS FORECAST_INFO_PRODUCT_GROUP
							, MAX(FORECAST_INFO_CELL_MODEL) AS FORECAST_INFO_CELL_MODEL
							, MAX(FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
							, MAX(FORECAST_INFO_SPEC) AS FORECAST_INFO_SPEC
							, MAX(FORECAST_INFOR_VERSION) AS FORECAST_INFOR_VERSION
							, MAX(CELL_TYPE) AS CELL_TYPE
						FROM  SCM_MST_ITEM_SN T2 WITH(NOLOCK) 
					   WHERE  DIVISION_ID =  @p_division_id
						GROUP BY DIVISION_ID, LEFT(ITEM_ID, 12)
					) T2 ON T1.DIVISION_ID = T2.DIVISION_ID
				AND SUBSTRING(T1.ITEM_ID,1,12) = T2.ITEM_ID
			where 1=1
			AND		T1.DIVISION_ID = @p_division_id 
			group by T1.DIVISION_ID, T1.ITEM_ID
  )  A
  join ( select distinct division_id, item_id from #RAW_DATA) b 
       on a.division_id = b.division_id and a.item_id = b.item_id  
  WHERE A.DIVISION_ID = @p_division_id

  
CREATE CLUSTERED INDEX [IDX1_TEMP_DM_MST_ITEM_SINGLE_V] ON [#TEMP_DM_MST_ITEM_SINGLE_V]
(division_id   ASC
,item_id       ASC
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
;


  /*
	SELECT DIVISION_ID, ITEM_ID, ITEM_CLASS
			 , ITEM_NAME, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MIN_CAPACITY
			 , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_PRODUCT_GROUP
			 , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
			 , ENERGE, CELL_QUANTITY
			 , MDM_PROJECT_NAME, CELL_TYPE, SCP_EXTRA_SPEC
	INTO  #TEMP_DM_MST_ITEM_SINGLE_V
	FROM DM_MST_ITEM_SINGLE_V A WITH(NOLOCK)
	WHERE A.DIVISION_ID = @p_division_id
*/


print 'E3--' + convert(varchar(30), getdate(), 121)

	--#CALENDAR
	SELECT A.BASIS_YYYYMMWW
			 , A.ISO_YYYYWW
			 , A.ISO_WEEK
			 , B.BASIS_YYYYMMDD
			 , B.END_FLAG, B.BASIS_YYYYMM
	INTO  #CALENDAR
	FROM (
				SELECT SUBSTRING(MAX(BASIS_YYYYMMDD),1,6) + ISO_WEEK AS BASIS_YYYYMMWW
						 , ISO_YYYYWW
						 ,  ISO_WEEK
				FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK)
				WHERE BASIS_YYYYMMDD >= @p_from_yyyymmdd 
				AND BASIS_YYYYMMDD <= @p_to_yyyymmdd
				GROUP BY ISO_YYYYWW, ISO_WEEK
			  ) AS A
	JOIN SCM_SYS_CALENDAR_M AS B WITH(NOLOCK)
	ON A.ISO_YYYYWW = B.ISO_YYYYWW
		AND A.ISO_WEEK = B.ISO_WEEK		

	--#TEMP_SCM_MST_SITE_ITEM
	SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
	         , A.APPLICATION, A.CUST_GROUP, A.ROUTE, A.CUST_GROUP_DTL
	         , A.CELL_PER_CAR, A.CELL_PER_MODULE, A.SALES_COMPANY
	         , A.ATTRIBUTE1
			 , A.ATTRIBUTE2
	         , A.ATTRIBUTE5
	         , A.ATTRIBUTE7
	         , A.ATTRIBUTE8
	         , A.REPORT_GROUP6
	         , A.OWNER
	         , DBO.FN_GET_DM_MKT_OWNER_NAME (A.OWNER, ',', 'EN' ) AS OWNER_NAME
	         , DBO.FN_GET_DM_MKT_OWNER_NAME (A.OWNER, ',', 'KO' ) AS OWNER_NAME_KO
	         , ( SELECT SU.DEPT_ID FROM SCM_MST_SSO_USER_INFO SU WITH (NOLOCK)
				 WHERE SU.USER_ID = (SELECT TOP 1 token FROM [dbo].[String_Split](A.owner, ',')) ) AS DEPT_ID
	         , A.VALID_YN
	INTO #TEMP_SCM_MST_SITE_ITEM
	FROM SCM_MST_SITE_ITEM A WITH(NOLOCK)
	JOIN ( SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID FROM #RAW_DATA ) B 
	ON A.DIVISION_ID = B.DIVISION_ID 
		AND A.SCM_SITE_ID = B.SCM_SITE_ID 
		AND A.PROJECT_CODE = B.PROJECT_CODE 
		AND A.ITEM_ID = B.ITEM_ID
	WHERE A.DIVISION_ID = @p_division_id

	
print 'E4--' + convert(varchar(30), getdate(), 121)		
 
	--------------------------------------------------------------------------------------------------------------------------------------------
	-- 조회조건에 따른 필터링 처리 ( PRICE 계산시 부하문제로 필터링은 여기서 하고, 필요없는 메저는 PRICE 끝난 후 제거 )
	--------------------------------------------------------------------------------------------------------------------------------------------
	BEGIN -- 필터링 시작

		IF ( @p_project_code <> '' ) -- 소형은 UI 에서 PROJECT DISABLE 됨
			BEGIN

				--[E20231124-001795] Customer FCST Waterfall 화면 조회 시 조건 적용 불완전함 개선===
				DELETE FROM #RAW_DATA WHERE ISNULL(PROJECT_CODE, '') = '';
				--===============================================================================

				DELETE A 
				FROM #RAW_DATA A
				JOIN SCM_MST_PROJECT B WITH(NOLOCK)
				ON A.DIVISION_ID = B.DIVISION_ID 
					AND A.PROJECT_CODE = B.PROJECT_CODE
				LEFT OUTER JOIN ( SELECT DISTINCT token FROM dbo.String_Split(@p_project_code, ',')) C	
				ON B.PROJECT_CODE LIKE '%' + C.TOKEN + '%'
				LEFT OUTER JOIN ( SELECT DISTINCT token FROM dbo.String_Split(@p_project_code, ',')) D	
				ON B.PROJECT_NAME LIKE '%' + D.TOKEN + '%'
				WHERE C.TOKEN IS NULL AND D.TOKEN IS NULL
			END

		IF ( @p_item_id <> '' )
			BEGIN
				DELETE A
				FROM #RAW_DATA A
				LEFT OUTER JOIN #TEMP_DM_MST_ITEM_SINGLE_V B 
				ON A.ITEM_ID = B.ITEM_ID
				LEFT OUTER JOIN ( SELECT DISTINCT token FROM dbo.String_Split(@p_item_id, ',')) C	
				ON A.ITEM_ID LIKE '%' + C.TOKEN + '%'
				LEFT OUTER JOIN ( SELECT DISTINCT token FROM dbo.String_Split(@p_item_id, ',')) D	
				ON B.NICK_NAME LIKE '%' + D.TOKEN + '%'
				WHERE C.TOKEN IS NULL  
				AND D.TOKEN IS NULL
			END

		IF ( @p_owner <> '' )
			BEGIN
				DELETE A
				FROM #RAW_DATA A
				LEFT OUTER JOIN #TEMP_SCM_MST_SITE_ITEM B 
				ON A.ITEM_ID = B.ITEM_ID 
					AND A.SCM_SITE_ID = B.SCM_SITE_ID 
					AND A.PROJECT_CODE = B.PROJECT_CODE
				LEFT OUTER JOIN ( SELECT DISTINCT token FROM dbo.String_Split(@p_owner, ',')) C	
				ON B.OWNER LIKE '%' + C.TOKEN + '%'
				LEFT OUTER JOIN ( SELECT DISTINCT token FROM dbo.String_Split(@p_owner, ',')) D	
				ON B.OWNER_NAME LIKE '%' + D.TOKEN + '%'
				LEFT OUTER JOIN ( SELECT DISTINCT token FROM dbo.String_Split(@p_owner, ',')) E	
				ON B.OWNER_NAME_KO LIKE '%' + E.TOKEN + '%'
				WHERE C.TOKEN IS NULL  
				AND D.TOKEN IS NULL  
				AND E.TOKEN IS NULL
			END
				
		IF ( @p_dept_id <> 'ALL' )
			BEGIN
			--[PJ2024-50461] Team Mapping------------------------------------
				DELETE A
				FROM #RAW_DATA A
				LEFT OUTER JOIN #TEMP_SCM_MST_SITE_ITEM B 
				ON A.ITEM_ID = B.ITEM_ID 
					AND A.SCM_SITE_ID = B.SCM_SITE_ID 
					AND A.PROJECT_CODE = B.PROJECT_CODE
				LEFT OUTER JOIN ( SELECT DISTINCT token FROM dbo.String_Split(@p_dept_id, ',')) C	
				ON B.DEPT_ID = C.TOKEN
				WHERE C.TOKEN IS NULL
			/*
				IF ( @P_DIVISION_ID = '40' )
					BEGIN
						DELETE A
						FROM #RAW_DATA A
						LEFT OUTER JOIN #TEMP_SCM_MST_SITE_ITEM B 
						ON A.ITEM_ID = B.ITEM_ID 
							AND A.SCM_SITE_ID = B.SCM_SITE_ID 
							AND A.PROJECT_CODE = B.PROJECT_CODE
						LEFT OUTER JOIN ( SELECT DISTINCT token FROM dbo.String_Split(@p_dept_id, ',')) C	
						ON B.DEPT_ID = C.TOKEN
						WHERE C.TOKEN IS NULL
					END

				ELSE
					BEGIN
						DELETE A
						FROM #RAW_DATA A
						LEFT OUTER JOIN SCM_MST_SITE B WITH(NOLOCK)
						ON A.SCM_SITE_ID = B.SCM_SITE_ID 
							AND B.DIVISION_ID = @P_DIVISION_ID
						LEFT OUTER JOIN ( SELECT DISTINCT token FROM dbo.String_Split(@p_dept_id, ',')) C
						ON B.DEPT_ID = C.TOKEN
						WHERE C.TOKEN IS NULL
					END
					*/
				END
				
		IF ( @p_end_customer <> 'ALL' )
			BEGIN
				IF ( @P_DIVISION_ID = '40')
					BEGIN
						DELETE A
						FROM #RAW_DATA A
						LEFT OUTER JOIN ( SELECT DISTINCT token FROM dbo.String_Split(@p_end_customer, ',')) C	
						ON A.PROJECT_CODE = C.TOKEN
						WHERE C.TOKEN IS NULL
					END

				ELSE
					BEGIN
						DELETE A
						FROM #RAW_DATA A
						LEFT OUTER JOIN SCM_MST_SITE B WITH(NOLOCK)
						ON A.SCM_SITE_ID = B.SCM_SITE_ID 
							AND B.DIVISION_ID = @P_DIVISION_ID
						LEFT OUTER JOIN ( SELECT DISTINCT token FROM dbo.String_Split(@p_end_customer, ',')) C	
						ON B.END_CUSTOMER = C.TOKEN
						WHERE C.TOKEN IS NULL
					END
				END
				
		IF ( @p_scm_site_id <> 'ALL' )
			BEGIN
				DELETE A
				FROM #RAW_DATA A
				LEFT OUTER JOIN ( SELECT DISTINCT token FROM dbo.String_Split(@p_scm_site_id, ',')) C	
				ON A.SCM_SITE_ID = C.TOKEN
				WHERE C.TOKEN IS NULL
			END
				
		IF ( @p_plant_site_id <> 'ALL' )
			BEGIN
				DELETE A
				FROM #RAW_DATA A
				LEFT OUTER JOIN ( SELECT DISTINCT token FROM dbo.String_Split(@p_plant_site_id, ',')) C	
				ON A.PLANT_SITE_ID = C.TOKEN
				WHERE C.TOKEN IS NULL
			END

		IF ( @p_item_type <> 'ALL' )
			BEGIN
				DELETE A
				FROM #RAW_DATA A
				LEFT OUTER JOIN #TEMP_DM_MST_ITEM_SINGLE_V B 
				ON A.ITEM_ID = B.ITEM_ID
				LEFT OUTER JOIN ( SELECT DISTINCT token FROM dbo.String_Split(@p_item_type, ',')) C	
				ON B.ITEM_TYPE = C.TOKEN
					WHERE C.TOKEN IS NULL
			END

		IF ( @p_biz_type <> 'ALL' )
			BEGIN
				IF( @P_DIVISION_ID = '40' )
					BEGIN
						DELETE A
						FROM #RAW_DATA A
						LEFT OUTER JOIN #TEMP_DM_MST_ITEM_SINGLE_V B 
						ON A.ITEM_ID = B.ITEM_ID
						LEFT OUTER JOIN ( SELECT DISTINCT token FROM dbo.String_Split(@p_biz_type, ',')) C	
						ON B.FORECAST_INFO_BIZ_TYPE = C.TOKEN
						WHERE C.TOKEN IS NULL
					END

				ELSE
					BEGIN
						DELETE A
						FROM #RAW_DATA A
						JOIN SCM_MST_PROJECT B 
						ON A.DIVISION_ID = B.DIVISION_ID 
							AND A.PROJECT_CODE = B.PROJECT_CODE
						LEFT OUTER JOIN ( SELECT DISTINCT token FROM dbo.String_Split(@p_biz_type, ',')) C	
						ON B.BIZ_TYPE LIKE '%' + C.TOKEN + '%'
						WHERE C.TOKEN IS NULL
					END
				END

	END -- 필터링 끝


print 'F--' + convert(varchar(30), getdate(), 121)
		------------------------------------------------------------------------------------------
		--	 [개발요청] 수요분석시스템_4_고객수요 Measure 통합(Cust. Fcst에 CUST_FCST_EDI를 추가) 20231207
		------------------------------------------------------------------------------------------
		
    /* 2024.03.06    kcw3408       DM 프로시저 속도개선: 불 필요 컬럼 삭제 */  
	BEGIN 
		INSERT INTO #RAW_DATA 
				( DIVISION_ID,PROJECT_CODE, SCM_SITE_ID,ITEM_ID,YYYYMMDD
				, CUST_ITEM_ID, COUNTRY, CITY , FCST_TYPE, DOM_EXP,SENDER_NAME
				, PLANT_SITE_ID, INCOTERMS, UNLOADING_POINT, MEASURE, MEASURE_GROUP
				, QTY, CREATE_DATE
				, LAST_UPDATED_BY
				, LAST_UPDATE_DATE
				, EDI_IF_SEQ
				, CUSTOMER_PLANT
				, EXCEPTION_FLAG
				, EXCEPTION_DATE
				) 
		SELECT    DISTINCT 
				  DIVISION_ID,PROJECT_CODE, SCM_SITE_ID,ITEM_ID,YYYYMMDD
				, CUST_ITEM_ID, COUNTRY, CITY , FCST_TYPE, DOM_EXP,SENDER_NAME
				, PLANT_SITE_ID, INCOTERMS, UNLOADING_POINT 
				, 'CUST_FCST' AS MEASURE, 'CUST_FCST' AS MEASURE_GROUP
				, QTY, CREATE_DATE
				, LAST_UPDATED_BY
				, LAST_UPDATE_DATE
				, EDI_IF_SEQ
				, CUSTOMER_PLANT
				, EXCEPTION_FLAG
				, EXCEPTION_DATE  
		FROM #RAW_DATA A WITH(NOLOCK) 
		WHERE A.MEASURE = 'CUST_FCST_EDI'
		 
	END

	print 'F_1--' + convert(varchar(30), getdate(), 121)
		------------------------------------------------------------------------------------------
		--	컬럼리스트 만들고, MKT FCST 와 비슷한 방식으로, CTE 로 데이터를 만들고, CTE SELECT 문에 컬럼리스트 삽입한다.
		------------------------------------------------------------------------------------------

		-- 컬럼리스트 생성
		BEGIN
			DECLARE @v_sql_text          AS NVARCHAR(MAX);
			DECLARE @V_PV_LIST			 AS NVARCHAR(MAX);
			DECLARE @V_PV_COL_LIST		 AS NVARCHAR(MAX);
			DECLARE @V_PV_COL			 AS NVARCHAR(MAX);
			DECLARE @v_column_name		 AS NVARCHAR(100)
			DECLARE @v_column            AS NVARCHAR(1000);
			DECLARE @v_orderby           AS NVARCHAR(1000);
			DECLARE @v_column_text       AS NVARCHAR(1000);
			DECLARE @v_PV_column_name    AS NVARCHAR(100);
			DECLARE @v_PV_NAME			 AS NVARCHAR(50);
			DECLARE @v_column_type       AS NVARCHAR(50);
			DECLARE @v_column_value      AS NVARCHAR(50);
			DECLARE @v_sort_order_no    AS NVARCHAR(50);
    
			-----	날짜컬럼 -----------------------------------------------------------------------------------------------------------
			SELECT @V_PV_LIST = '', @V_PV_COL_LIST = '', @V_PV_COL = ''
			DECLARE c_bucket CURSOR FAST_FORWARD FOR 
				SELECT 
					 '[D_' + a.basis_yyyymmdd + '] AS D_' + A.BASIS_YYYYMMDD  AS column_name
					 ,'[D_' + a.basis_yyyymmdd + ']' AS PV_name
					 , a.basis_yyyymmdd + '_' + CONVERT(CHAR(2), 31) AS sort_order_no
				FROM   [dbo].[SCM_SYS_CALENDAR_M] a WITH(NOLOCK)	
				WHERE  a.basis_yyyymmdd >= @p_from_yyyymmdd
				AND    a.basis_yyyymmdd <= @p_to_yyyymmdd
				AND	   @p_bucket = 'DAILY'
				UNION ALL
				SELECT '[W_' + A.BASIS_YYYYMM + A.ISO_WEEK + '] AS W_' + a.basis_yyyymm + a.iso_week  AS column_name
					 ,'[W_' + A.BASIS_YYYYMM + A.ISO_WEEK + ']' AS PV_name
					 , a.basis_start_date + '_' + CONVERT(CHAR(2), 21) AS sort_order_no
				FROM   [dbo].[SCM_SYS_CALENDAR_M] a WITH(NOLOCK)	
				WHERE  a.basis_yyyymmdd >= @p_from_yyyymmdd
				AND    a.basis_yyyymmdd <= @p_to_yyyymmdd
				AND	   @p_bucket != 'ONLY_WEEKLY'
				GROUP BY a.basis_yyyymm
					   , a.iso_week    
					   , a.basis_start_date
				UNION ALL
				SELECT '[M_' + A.BASIS_YYYYMM + '] AS M_' + a.basis_yyyymm  AS column_name
					  , '[M_' + A.BASIS_YYYYMM + ']' AS PV_name
					  , MIN(a.basis_start_date) + '_' + CONVERT(CHAR(2), 1) AS sort_order_no
				FROM    [dbo].[SCM_SYS_CALENDAR_M] a WITH(NOLOCK)	
				WHERE  a.basis_yyyymmdd >= @p_from_yyyymmdd
				AND    a.basis_yyyymmdd <= @p_to_yyyymmdd
				AND	   @p_bucket != 'ONLY_WEEKLY'
				GROUP BY a.basis_yyyymm
				
				UNION ALL
				SELECT '[W_' + SUBSTRING(MAX(BASIS_YYYYMMDD), 1, 6)+ISO_WEEK + '] AS W_' + SUBSTRING(MAX(BASIS_YYYYMMDD), 1, 6) + A.ISO_WEEK  AS COLUMN_NAME
					, '[W_' + SUBSTRING(MAX(BASIS_YYYYMMDD), 1, 6)+ISO_WEEK + ']' AS PV_NAME 
					, MAX(BASIS_YYYYMMDD)+ '_' +CONVERT(CHAR(2), 21) AS SORT_ORDER_NO
				FROM   [DBO].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
				WHERE  A.BASIS_YYYYMMDD >= @p_from_yyyymmdd 
				AND    A.BASIS_YYYYMMDD <= @p_to_yyyymmdd
				AND	   @p_bucket = 'ONLY_WEEKLY'
				GROUP BY ISO_YYYYWW, ISO_WEEK, WEEK_NAME
				ORDER BY sort_order_no  
				;

			OPEN c_bucket;
			FETCH NEXT FROM c_bucket INTO @v_PV_column_name, @v_PV_name, @v_sort_order_no
										WHILE @@FETCH_STATUS = 0   
			BEGIN  
				SELECT @V_PV_COL_LIST	= @V_PV_COL_LIST + CASE WHEN @V_PV_COL_LIST <> '' THEN ',' ELSE '' END + @v_PV_column_name
					   , @V_PV_LIST		= @V_PV_LIST + CASE WHEN @V_PV_LIST <> '' THEN ',' ELSE '' END + @v_PV_name
					   , @V_PV_COL		= @V_PV_COL + CASE WHEN @V_PV_COL <> '' THEN ',' ELSE '' END + 'ISNULL(' +@v_PV_name+', 0) AS ' + @v_PV_name
    
				FETCH NEXT FROM c_Bucket INTO @v_PV_column_name, @v_PV_name, @v_sort_order_no
			END;

			CLOSE c_bucket;  
			DEALLOCATE c_bucket;

			
    /* 20240306 KCW3408 속도개선_템프사용 */
	
	IF OBJECT_ID (N'tempdb..#TEMP_SCM_MST_SITE', N'U') IS NOT NULL 
		DROP TABLE #TEMP_SCM_MST_SITE

    SELECT B.SCM_SITE_ID
	     , B.DIVISION_ID
	     , B.DEPT_ID
		 , K.SOLDTO_CODE
		 , B.VMI_YN
		 , B.END_CUSTOMER
		 , B.SOLDTO_CUSTOMER
		 , H.CITY_NAME 
		 , J.COUNTRY_NAME 
      INTO #TEMP_SCM_MST_SITE      
      FROM SCM_MST_SITE  B WITH(NOLOCK)  
      LEFT OUTER JOIN 
	       SCM_MST_SITE_CUSTOMER  K WITH(NOLOCK)
		   ON B.DIVISION_ID = K.DIVISION_ID 
		  AND B.SCM_SITE_ID = K.SCM_SITE_ID 
		  AND K.REP_YN = 'Y'    
      LEFT OUTER JOIN 
	       SCM_MST_CITY    H WITH(NOLOCK)
		   ON B.CITY = H.CITY     
      LEFT OUTER JOIN 
           SCM_MST_COUNTRY    J WITH(NOLOCK) 
		   ON B.COUNTRY = J.COUNTRY 

	IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_V_T', N'U') IS NOT NULL 
		DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_V_T

    SELECT D.*
	     , E.SEGMENT2
		 , ISNULL(F.NICK_NAME,'') AS CELL_MODEL_NICK_NAME
      INTO #TEMP_DM_MST_ITEM_SINGLE_V_T      
      FROM #TEMP_DM_MST_ITEM_SINGLE_V D WITH(NOLOCK)
      LEFT OUTER JOIN 
	       SCM_ADM_LOOKUP_MASTER_DETAIL E WITH(NOLOCK)
		   ON D.CELL_TYPE = E.SEGMENT1 
		  AND E.LOOKUP_TYPE = 'CELL_TYPE'    
      LEFT OUTER JOIN 
	       #TEMP_DM_MST_ITEM_SINGLE_V F WITH(NOLOCK)
		   ON D.DIVISION_ID = F.DIVISION_ID 
		  AND ISNULL(D.FORECAST_INFO_CELL_MODEL,'') = F.ITEM_ID

			-----	일반 컬럼 -----------------------------------------------------------------------------------------------------------
			SET @v_column_name = '';
			SET @v_column = '';
			SET @v_orderby = '';
			
			SELECT  @i_Count = Count(*)
			FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
			WHERE  1 = 1
			AND    U.PROGRAM_ID  = @p_Program_Id
			AND    U.SHEET_NAME  = @p_sheet_name
			AND    U.USER_ID     = @p_created_by
			AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
	
			IF @i_Count = 0 
			BEGIN
				SELECT @ColList = @ColList + '[' + COLUMN_NAME + '],'
					   , @OrderList = @OrderList + '[' + COLUMN_NAME + '] ' + DATA_SORT_METHOD_CODE + ','
				FROM 
				(
					-- ★★ ORDER BY 가능하려면 컬럼정의 100개 넘지 않아야함
					SELECT --TOP 100 
						C.SORT_ORDER_NO, 
						C.COLUMN_NAME, C.DATA_SORT_METHOD_CODE   
					FROM [SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
					WHERE 1 = 1
						AND    C.PROGRAM_ID  = @p_Program_Id
						AND    C.SHEET_NAME  = @p_sheet_name
						AND    ( C.DEFAULT_FLAG = 'Y' OR 
							(    C.VISIBLE_FLAG = 'N'
							AND    C.DEFAULT_FLAG = ''
							AND    C.VALID_YN     = 'Y'
							)
							)  
				) tbColList	
				ORDER BY SORT_ORDER_NO
			END
			ELSE 
			BEGIN
				SELECT @ColList = @ColList + '[' + COLUMN_NAME + '],'
					   , @OrderList = @OrderList + '[' + COLUMN_NAME + '] ' + DATA_SORT_METHOD_CODE + ','
				FROM 
				(
					-- ★★ ORDER BY 가능하려면 컬럼정의 100개 넘지 않아야함
				SELECT --TOP 100 
					U.SORT_ORDER_NO, C.COLUMN_NAME, U.DATA_SORT_METHOD_CODE  
				FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
					INNER JOIN [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
						ON     U.PROGRAM_ID  = C.PROGRAM_ID
						AND    U.SHEET_NAME  = C.SHEET_NAME
						AND    U.COLUMN_NAME = C.COLUMN_NAME
						AND    U.PROGRAM_ID  = @p_Program_Id
						AND    U.SHEET_NAME  = @p_sheet_name
						AND    U.USER_ID = @p_created_by
						AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C' 
						AND	   U.COLUMN_NAME NOT IN ( 'MEASURE') 
						--AND    @p_division_id IN (SELECT token FROM dbo.String_Split(C.DIVISION_ID ,',') )	-- 20190125 일단 주석처리 KHSONG
				---------
				UNION ALL
				---------
				SELECT TOP 100 
					C.SORT_ORDER_NO, C.COLUMN_NAME, C.DATA_SORT_METHOD_CODE   
				FROM   [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
				WHERE  1 = 1
						AND    C.PROGRAM_ID  = @p_Program_Id
						AND    C.SHEET_NAME  = @p_sheet_name
						AND    C.VISIBLE_FLAG = 'N'
						AND    C.DEFAULT_FLAG = ''
						AND    C.VALID_YN     = 'Y'						
				) tbColList	
				ORDER BY SORT_ORDER_NO
			END

			SELECT @ColList = LEFT(@ColList, LEN(@ColList)-1)	
			SELECT @OrderList = LEFT(@OrderList, LEN(@OrderList)-1)								
			SELECT @ColList = REPLACE(@ColList,'[MEASURE]','[MEASURE_GROUP],[MEASURE],[SORT_ORDER_NO]')
			
			IF(@p_division_id = '81')
			BEGIN
				SELECT @OrderList = REPLACE(@OrderList,',[EDI_IF_SEQ] ASC,[CREATE_DATE] ASC','')
			END
			ELSE IF(@p_division_id = '40')
			BEGIN
				SELECT @OrderList = REPLACE(@OrderList,',[CREATE_DATE] ASC','')
			END

			SELECT @OrderList = REPLACE(@OrderList,'[MEASURE]','[SORT_ORDER_NO]')

		END	--	컬럼생성 끝	---------------------------------------------------------------------------------------------------------------------
  

		BEGIN	-- CTE 에서 사용할 SELECT COLUMN 정리
			
			DECLARE @V_SQL_SELECT		NVARCHAR(4000)
			DECLARE @V_SQL_GROUPBY	NVARCHAR(4000)

			CREATE TABLE #T_COLUMN_SETUP (
				TBL_ALIAS						NVARCHAR(10)
				, COLUMN_NAME			NVARCHAR(100)
				, COLUMN_STRING			NVARCHAR(2000)
				, SORT_KEY						INT
				)
				 
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'DIVISION_ID', N'A.DIVISION_ID')

				--[PJ2024-50461] Team Mapping------------------------------------
				--INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'DEPT_ID', N'CASE WHEN A.DIVISION_ID = ''40'' THEN C.DEPT_ID ELSE B.DEPT_ID END AS DEPT_ID')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'DEPT_ID', N'C.DEPT_ID')
				--[PJ2024-50461] Team Mapping------------------------------------

				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'END_CUSTOMER40', N'CASE WHEN A.DIVISION_ID = ''40'' THEN A.PROJECT_CODE ELSE '''' END AS END_CUSTOMER40')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'END_CUSTOMER', N'ISNULL(B.END_CUSTOMER, '' '') AS END_CUSTOMER')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'BIZ_TYPE_NAME', N'G.BIZ_TYPE AS BIZ_TYPE_NAME')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'COUNTRY_NAME', N'B.COUNTRY_NAME')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CITY_NAME', N'B.CITY_NAME')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SCM_SITE_ID', N'A.SCM_SITE_ID')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'PROJECT_CODE', N'A.PROJECT_CODE')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'PROJECT_NAME', N'G.PROJECT_NAME')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'PROJECT_STATUS', N'G.PROJECT_STATUS')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'PROJECT_OWNER', N'G.PROJECT_OWNER')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'ITEM_ID', N'A.ITEM_ID')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'ITEM_ID40', N'A.ITEM_ID AS ITEM_ID40')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'ITEM_NAME', N'ISNULL(D.ITEM_NAME, '''') AS ITEM_NAME')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'NICK_NAME', N'ISNULL(D.NICK_NAME, '''') AS NICK_NAME')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'INCOTERMS', N'A.INCOTERMS')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'ITEM_TYPE', N'ISNULL(D.ITEM_TYPE, '''') AS ITEM_TYPE')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FCST_TYPE', N'A.FCST_TYPE')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'DOM_EXP', N'A.DOM_EXP')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'PLANT_SITE_ID', N'A.PLANT_SITE_ID')				
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CUST_GROUP', N'C.CUST_GROUP')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CUST_GROUP_DTL', N'C.CUST_GROUP_DTL')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'OWNER', N'C.OWNER_NAME AS OWNER')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'APPLICATION', N'C.APPLICATION')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'ROUTE', N'C.ROUTE')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'MDM_PROJECT_NAME', N'D.MDM_PROJECT_NAME')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'MIN_CAPACITY', N'D.MIN_CAPACITY')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'BIZ_TYPE_NAME40', N'D.FORECAST_INFO_BIZ_TYPE AS BIZ_TYPE_NAME40')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FORECAST_INFO_PRODUCT_GROUP', N'D.FORECAST_INFO_PRODUCT_GROUP')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FORECAST_INFO_CELL_MODEL', N'C.ATTRIBUTE5 AS FORECAST_INFO_CELL_MODEL')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FORECAST_INFO_CELL_PACK_COUNT', N'D.FORECAST_INFO_CELL_PACK_COUNT')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FORECAST_INFO_ALL', N'D.FORECAST_INFO_SPEC + D.FORECAST_INFOR_VERSION AS FORECAST_INFO_ALL')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FORECAST_INFO_SPEC', N'D.FORECAST_INFO_SPEC')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FORECAST_INFOR_VERSION', N'D.FORECAST_INFOR_VERSION')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CELL_MODEL_NICK_NAME', N'ISNULL(D.NICK_NAME,'''') AS CELL_MODEL_NICK_NAME')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'VMI_YN', N'B.VMI_YN')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CELL_TYPE', N'D.SEGMENT2 AS CELL_TYPE')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CELL_PER_CAR', N'C.CELL_PER_CAR')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CELL_PER_MODULE', N'C.CELL_PER_MODULE')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'MODULE_PER_CAR', N'CASE WHEN C.CELL_PER_MODULE  <> 0 THEN C.CELL_PER_CAR / C.CELL_PER_MODULE ELSE 0 END AS MODULE_PER_CAR')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'ENERGE', N'D.ENERGE')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CELL_QUANTITY', N'D.CELL_QUANTITY')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'PRIORITY', N'C.ATTRIBUTE7 AS PRIORITY')				
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'MEASURE', N'CASE WHEN A.MEASURE = ''Customer FCST'' THEN 
																																										(CASE WHEN A.LAST_UPDATED_BY LIKE ''%robot%'' THEN ''Cust.FCST_RPA'' 
																																												 ELSE ''Cust.FCST_EXCEL'' END)
																																							  ELSE A.MEASURE END AS MEASURE') 
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'MEASURE_GROUP', N'M.MEASURE_GROUP')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'DMS_SALES', N'ISNULL(C.ATTRIBUTE1,'''') AS DMS_SALES')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'DMS_CUSTOMER', N'ISNULL(C.ATTRIBUTE2,'''') AS DMS_CUSTOMER')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'REPORT_GROUP6', N'C.REPORT_GROUP6')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'TEAM_NAME_KO', N'N.DEPT_NAME_KO AS TEAM_NAME_KO')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'DEPT_NAME_KO', N'O.DEPT_NAME_KO')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'FORECAST_INFO_BIZ_TYPE', N'D.FORECAST_INFO_BIZ_TYPE')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'BIZ_TYPE', N'G.BIZ_TYPE')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SOLDTO_CUSTOMER', N'B.SOLDTO_CUSTOMER')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SCM_SITE_ID40', N'CASE WHEN A.DIVISION_ID = ''40'' THEN A.SCM_SITE_ID ELSE '''' END AS SCM_SITE_ID40')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SCP_USE_YN', N'CASE  WHEN A.DIVISION_ID IN (''40'') AND B.VMI_YN = ''Y'' AND A.MEASURE = ''VMI_In_Req''  THEN ''Y''							
						WHEN A.DIVISION_ID IN (''40'') AND B.VMI_YN = ''N'' AND A.MEASURE IN ( ''MKT_FCST_RP'',''MKT_FCST'' ) THEN ''Y''
				WHEN A.DIVISION_ID IN (''40'') AND B.VMI_YN = ''Y'' AND A.MEASURE = ''VMI_In_Plan'' THEN ''Y''																							
				WHEN A.DIVISION_ID IN (''40'') AND B.VMI_YN = ''N'' AND A.MEASURE in (''RTF'',''RTF_SCP'',''RTF_SYS_RP'') THEN ''Y''																	
				ELSE ''N'' END AS SCP_USE_YN')				
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SCP_EXTRA_SPEC', N'D.SCP_EXTRA_SPEC')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SALES_COMPANY', N'C.SALES_COMPANY')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SOLDTO_CODE', N'B.SOLDTO_CODE')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'KWH_CELL', N'C.ATTRIBUTE8 AS KWH_CELL')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'KWH_MODULE', N'CASE WHEN A.DIVISION_ID LIKE ''81%'' AND C.CELL_PER_MODULE > 0 AND ISNULL(C.ATTRIBUTE8, '''') <> '''' THEN CONVERT(FLOAT,(C.CELL_PER_MODULE * C.ATTRIBUTE8)) 
																									ELSE NULL END 
																									AS KWH_MODULE')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'KWH_PACK', N'CASE WHEN A.DIVISION_ID LIKE ''81%'' AND C.CELL_PER_CAR > 0 AND ISNULL(C.ATTRIBUTE8, '''') <> '''' THEN CONVERT(FLOAT,(C.CELL_PER_CAR * C.ATTRIBUTE8)) 
																									ELSE NULL END 
																									AS KWH_PACK')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CUST_ITEM_ID', N'A.CUST_ITEM_ID')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'SENDER_NAME', N'A.SENDER_NAME')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'UNLOADING_POINT', N'A.UNLOADING_POINT')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CREATE_DATE', N'A.CREATE_DATE')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'LAST_UPDATE_DATE', N'A.LAST_UPDATE_DATE')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'LAST_UPDATED_BY', N'A.LAST_UPDATED_BY')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CITY', N'A.CITY')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'COUNTRY', N'A.COUNTRY')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'EDI_IF_SEQ', N'A.EDI_IF_SEQ')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'CUSTOMER_PLANT', N'A.CUSTOMER_PLANT')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'EXCEPTION_FLAG', N'A.EXCEPTION_FLAG')
				INSERT INTO #T_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING ) VALUES ( 'EXCEPTION_DATE', N'A.EXCEPTION_DATE')

			SELECT B.COLUMN_STRING, ROW_NUMBER() OVER ( ORDER BY B.SORT_KEY ) AS SEQ
			INTO #T
			FROM  DBO.UF_FX_String_Split(@ColList, ',') A
			JOIN #T_COLUMN_SETUP B ON replace(replace(A.TOKEN, '[', ''), ']','') = B.COLUMN_NAME
			 
			DECLARE @I INT, @CNT INT

			SELECT @I = 1, @CNT = COUNT(*), @V_SQL_SELECT = '', @V_SQL_GROUPBY = ''
			FROM #T
			
			WHILE ( @I <= @CNT )
			BEGIN
				SELECT @V_SQL_SELECT = @V_SQL_SELECT + CASE WHEN @I = 1 THEN '' ELSE ',' END + COLUMN_STRING
					, @V_SQL_GROUPBY = @V_SQL_GROUPBY + CASE WHEN @I = 1 THEN '' ELSE ',' END 
													+ CASE WHEN PATINDEX(N'% AS %', COLUMN_STRING) > 0
																	THEN LEFT(COLUMN_STRING, PATINDEX(N'% AS %', COLUMN_STRING) -1)
														ELSE COLUMN_STRING 
														END
				FROM #T 
				WHERE SEQ = @I

				SET @I += 1

			END

		END

		print 'F_2--' + convert(varchar(30), getdate(), 121)
		
        /* 2024.03.06    kcw3408       DM 프로시저 속도개선: 템프 사용 변경 */  
		BEGIN
			SET @v_sql_text = N'
		
			SELECT A.BASIS_YYYYMMWW, A.ISO_YYYYWW, A.ISO_WEEK, B.BASIS_YYYYMMDD, B.END_FLAG, B.BASIS_YYYYMM
			INTO #CALENDAR
			FROM (
				SELECT SUBSTRING(MAX(BASIS_YYYYMMDD),1,6) + ISO_WEEK AS BASIS_YYYYMMWW, ISO_YYYYWW,  ISO_WEEK
				FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
				WHERE BASIS_YYYYMMDD >= '''+@p_from_yyyymmdd +'''
				AND	  BASIS_YYYYMMDD <= '''+@p_TO_yyyymmdd +'''
				GROUP BY  ISO_YYYYWW, ISO_WEEK
			) AS A
			JOIN SCM_SYS_CALENDAR_M AS B WITH(NOLOCK)
			ON A.ISO_YYYYWW = B.ISO_YYYYWW
			AND A.ISO_WEEK = B.ISO_WEEK

			SELECT CAST(CASE WHEN ''Y'' = N''[@CellQtyYN]'' AND A.MEASURE_GROUP NOT in ( ''SFA'',''VMI_DIO'',''OVER_FCST'',''LESS_FCST'',''CFA'',''CFCR'' ) and isnull(D.FORECAST_INFO_CELL_PACK_COUNT,1) <> 1  THEN A.QTY * D.FORECAST_INFO_CELL_PACK_COUNT ELSE A.QTY END as int) AS QTY
				 , CASE WHEN ''' + @P_BUCKET + ''' = ''DAILY'' THEN A.YYYYMMDD ELSE '''' END AS YYYYMMDD
				 , CAL.BASIS_YYYYMM, CAL.ISO_WEEK, CAL.BASIS_YYYYMMWW
				 , M.SORT_ORDER_NO
				 , CASE WHEN C2.MONTH_END_DATE IS NOT NULL THEN ''Y'' ELSE ''N'' END AS MONTH_END_YN
				 , CASE WHEN C3.WEEK_END_DATE IS NOT NULL THEN ''Y'' ELSE ''N'' END AS WEEK_END_YN
				, [@SQL_SELECT]
			INTO #WF
			FROM #RAW_DATA A WITH(NOLOCK)
			LEFT OUTER JOIN #TEMP_SCM_MST_SITE B WITH(NOLOCK) ON A.SCM_SITE_ID = B.SCM_SITE_ID AND A.DIVISION_ID = B.DIVISION_ID
			LEFT OUTER JOIN #TEMP_SCM_MST_SITE_ITEM C WITH(NOLOCK) ON  A.DIVISION_ID = C.DIVISION_ID	AND A.PROJECT_CODE = C.PROJECT_CODE AND A.SCM_SITE_ID = C.SCM_SITE_ID AND A.ITEM_ID = C.ITEM_ID
			LEFT OUTER JOIN #TEMP_DM_MST_ITEM_SINGLE_V_T D WITH(NOLOCK) ON A.DIVISION_ID = D.DIVISION_ID AND A.ITEM_ID = D.ITEM_ID 
			LEFT OUTER JOIN SCM_MST_PROJECT G WITH(NOLOCK) ON A.DIVISION_ID = G.DIVISION_ID AND A.PROJECT_CODE = G.PROJECT_CODE
			JOIN #SELECT_MEASURE M WITH(NOLOCK) ON A.MEASURE = M.MEASURE

			--[PJ2024-50461] Team Mapping------------------------------------
			--LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO N WITH(NOLOCK) ON CASE WHEN A.DIVISION_ID = ''40'' THEN C.DEPT_ID ELSE B.DEPT_ID END = N.DEPT_ID 
			LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO N WITH(NOLOCK) ON C.DEPT_ID= N.DEPT_ID 
			--[PJ2024-50461] Team Mapping------------------------------------

			LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO O WITH(NOLOCK) ON N.UPPER_DEPT_ID = O.DEPT_ID
			JOIN #CALENDAR						CAL WITH(NOLOCK) ON A.YYYYMMDD = CAL.BASIS_YYYYMMDD 
			LEFT OUTER JOIN (   SELECT MAX(BASIS_YYYYMMDD) AS MONTH_END_DATE
								FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
								WHERE BASIS_YYYYMMDD BETWEEN ''' + @P_FROM_YYYYMMDD + N''' AND ''' + @P_TO_YYYYMMDD + N''' 
								GROUP BY BASIS_YYYYMM ) C2 ON A.YYYYMMDD = C2.MONTH_END_DATE
			LEFT OUTER JOIN (   SELECT MAX(BASIS_YYYYMMDD) AS WEEK_END_DATE
								FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
								WHERE BASIS_YYYYMMDD BETWEEN ''' + @P_FROM_YYYYMMDD + N'''  AND ''' + @P_TO_YYYYMMDD + N''' 
								GROUP BY ISO_YYYYWW+PARTIAL_WEEK_NAME ) C3 ON A.yyyymmdd = C3.WEEK_END_DATE


			option (hash join)
			
			print ''F_3--'' + convert(varchar(30), getdate(), 121)
			
			'
		END
		

		IF @p_division_id = '40'
		BEGIN
			SET @v_sql_text = @v_sql_text + N'
								SELECT [@V_COLUMN]
										, ' + @V_PV_COL + '    
								FROM ( '
		END
		ELSE
		BEGIN
			SET @v_sql_text = @v_sql_text + N'
								SELECT [@V_COLUMN]
										, [@V_PV_COL_LIST]    
								FROM ( '
		END
		
		IF @p_bucket = 'DAILY'
		BEGIN
			SET @v_sql_text = @v_sql_text + N'
								SELECT [@V_COLUMN], ''D_'' + F.YYYYMMDD AS YYYYMMDD, F.QTY
								FROM   #WF F WITH(NOLOCK)
								--WHERE F.QTY <> 0 **20230422
								WHERE F.QTY <> (CASE WHEN MEASURE IN (''CUST_FCST'',''CUST_FCST_EDI'', ''Immidiate'', ''Planning_Forecast'', ''Commercial_Agreement'', ''Firm_Temp'', ''Manumacturing_Material_Temp'', ''Material_Temp'', ''Backorder'') THEN
																		-9999999999
															   ELSE 0 END)					

								UNION ALL '
		END 

		IF @p_bucket != 'ONLY_WEEKLY'
		BEGIN
			SET @v_sql_text = @v_sql_text + N'
						SELECT [@V_COLUMN], ''W_'' + F.BASIS_YYYYMM + F.ISO_WEEK AS YYYYMMDD 
								, CASE WHEN F.MEASURE IN (''BALANCE'', ''VMI_Inv'', ''AS_Inv'', ''SS_LVL'', ''SS_GAP'' ) 
											THEN	CASE WHEN F.WEEK_END_YN = ''Y'' THEN SUM (F.QTY)   
														ELSE 0 
													END 
										WHEN F.MEASURE = ''LOC'' 
											THEN AVG(F.QTY) 
										ELSE SUM(F.QTY) 
									END AS QTY
						FROM #WF F WITH(NOLOCK)
						--WHERE F.QTY <> 0 **20230422
						WHERE F.QTY <> (CASE WHEN MEASURE IN (''CUST_FCST'',''CUST_FCST_EDI'', ''Immidiate'', ''Planning_Forecast'', ''Commercial_Agreement'', ''Firm_Temp'', ''Manumacturing_Material_Temp'', ''Material_Temp'', ''Backorder'') THEN
																-9999999999
														   ELSE 0 END)

						GROUP BY [@V_COLUMN], F.BASIS_YYYYMM, F.ISO_WEEK, F.WEEK_END_YN
					
						UNION ALL
						SELECT [@V_COLUMN], ''M_'' + F.BASIS_YYYYMM AS YYYYMMDD
							, CASE WHEN F.MEASURE IN (''BALANCE'', ''VMI_Inv'', ''AS_Inv'', ''SS_LVL'', ''SS_GAP'' )
											THEN	CASE WHEN F.MONTH_END_YN = ''Y'' THEN SUM (F.QTY)  
														ELSE 0 
													END
										WHEN F.MEASURE = ''LOC''
											THEN AVG(F.QTY) 
										ELSE SUM(F.QTY) 
									END AS QTY
						FROM #WF F WITH(NOLOCK)
						--WHERE F.QTY <> 0  **20230422
						WHERE F.QTY <> (CASE WHEN MEASURE IN (''CUST_FCST'',''CUST_FCST_EDI'', ''Immidiate'', ''Planning_Forecast'', ''Commercial_Agreement'', ''Firm_Temp'', ''Manumacturing_Material_Temp'', ''Material_Temp'', ''Backorder'') THEN
																-9999999999
														   ELSE 0 END) 
						GROUP BY [@V_COLUMN], F.BASIS_YYYYMM, F.MONTH_END_YN
					
						) F
					PIVOT (
						SUM(QTY) FOR YYYYMMDD IN ( [@V_PV_LIST] )
						) AS PVTV_P_PROGRAM_ID
					ORDER BY [@V_ORDERBY]

					option ( order group ) 
					  '; 
		END
		ELSE IF @p_bucket = 'ONLY_WEEKLY'
		BEGIN
			SET @v_sql_text = @v_sql_text + N'
						SELECT [@V_COLUMN], ''W_'' + F.BASIS_YYYYMMWW AS YYYYMMDD 
								, CASE WHEN F.MEASURE IN (''BALANCE'', ''VMI_Inv'', ''AS_Inv'', ''SS_LVL'', ''SS_GAP'' ) 
											THEN	CASE WHEN F.WEEK_END_YN = ''Y'' THEN SUM (F.QTY)   
														ELSE 0 
													END 
										WHEN F.MEASURE = ''LOC'' 
											THEN AVG(F.QTY) 
										ELSE SUM(F.QTY) 
									END AS QTY
						FROM #WF F WITH(NOLOCK)
						--WHERE F.QTY <> 0 **20230422
						WHERE F.QTY <> (CASE WHEN MEASURE IN (''CUST_FCST'',''CUST_FCST_EDI'', ''Immidiate'', ''Planning_Forecast'', ''Commercial_Agreement'', ''Firm_Temp'', ''Manumacturing_Material_Temp'', ''Material_Temp'', ''Backorder'') THEN
																-9999999999
													   ELSE 0 END)
						GROUP BY [@V_COLUMN], F.BASIS_YYYYMMWW, F.ISO_WEEK, F.WEEK_END_YN
						) F
					PIVOT (
						SUM(QTY) FOR YYYYMMDD IN ( [@V_PV_LIST] )
						) AS PVT
					ORDER BY [@V_ORDERBY]

					option ( order group ) 
					  '; 
		END


print 'G--' + convert(varchar(30), getdate(), 121)

	  --SELECT @v_sql_text;
		SET @v_sql_text = REPLACE(@v_sql_text,'[@v_PV_COL_LIST]'    , @v_PV_LIST    );
		SET @v_sql_text = REPLACE(@v_sql_text,'[@v_PV_LIST]'		, @v_PV_LIST    );
		SET @v_sql_text = REPLACE(@v_sql_text,'[@v_column]'			, @ColList       );
		SET @v_sql_text = REPLACE(@v_sql_text,'[@v_orderby]'		, @OrderList      );
		SET @v_sql_text = REPLACE(@v_sql_text,'[@SQL_SELECT]'		, @V_SQL_SELECT      );
		SET @v_sql_text = REPLACE(@v_sql_text,'[@SQL_GROUPBY]'		, @V_SQL_GROUPBY      );
		--SET @v_sql_text = REPLACE(@v_sql_text,'[@CellQtyYN]'      , @p_cell_yn);

		--PRINT @ColList
		--PRINT @V_SQL_SELECT
		--PRINT @V_SQL_GROUPBY
		--PRINT @OrderList
		--PRINT @ColList

		--PRINT SUBSTRING(@v_sql_text, 1, 3000)
		--PRINT SUBSTRING(@v_sql_text, 3001, 6000)
		--PRINT SUBSTRING(@v_sql_text, 6001, 9000)

		--PRINT @v_sql_text

		EXEC SP_EXECUTESQL @v_sql_text; 

/*
EXEC DMF0053_GET_CUST_FCST_WATERFALL @p_division_id='81', @p_scm_site_id='ALL', @p_plant_site_id='ALL', @p_dept_id='ALL', 
	@p_end_customer='ALL', @p_biz_type='ALL', @p_project_code='', @p_item_id='', @p_from_yyyymmdd='20230301', @p_to_yyyymmdd='20230831', 
	@p_created_by='kdmcc14', @p_item_type='ALL', @p_owner='', @p_bucket='WEEKLY', @p_user_dept_id='HD', @p_group_id='ADMIN', 
	@p_version_no = '', @p_from_createdate='20230407', @p_to_createdate='20230407'

EXEC DMF0053_GET_CUST_FCST_WATERFALL @p_division_id='81', @p_scm_site_id='ALL', @p_plant_site_id='ALL', @p_dept_id='ALL', 
	@p_end_customer='HKMC', @p_biz_type='ALL', @p_project_code='A15HC2001', @p_item_id='ACLN1007I-A1', @p_from_yyyymmdd='20230403', @p_to_yyyymmdd='20230403', 
	@p_created_by='kdmcc14', @p_item_type='ALL', @p_owner='', @p_bucket='WEEKLY', @p_user_dept_id='HD', @p_group_id='ADMIN', 
	@p_version_no = '', @p_from_createdate='20230407', @p_to_createdate='20230407'
*/

		SELECT ISO_WEEK, BASIS_DATE 
		FROM [dbo].[SCM_SYS_CALENDAR_M] WITH(NOLOCK)
		WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR(8),GETDATE(), 112) 

		-- 테스트용 코드
		--SELECT ISO_WEEK, BASIS_DATE 
		--FROM [dbo].[SCM_SYS_CALENDAR_M] 
		--WHERE BASIS_YYYYMMDD = '20220725'


		-- 20190711 정열 관련 추가
		DECLARE @ORDER NVARCHAR(MAX)=''
		SELECT @ORDER = @ORDER + COLUMN_NAME + ' ' + DATA_SORT_METHOD_CODE + ','
		FROM   [dbo].[SCM_MST_TITLESET_USER] U  WITH(NOLOCK,INDEX (PK_SCM_MST_TITLESET_USER))
		WHERE  1 = 1
		AND    U.USER_INQUIRY_COLUMN_TYPE_CODE	= 'C'
		AND    U.PROGRAM_ID						= 'DMF0053'
		AND    U.SHEET_NAME						= 'CUST Fcst Waterfall'
		AND    U.USER_ID						= @p_created_by
		ORDER BY SORT_ORDER_NO
		
		/* 20231212 kcw3408 EDI_IF_SEQ DESC 삭제(컬럼선택시 하지 않으면 오류 발생)
		SELECT @ORDER + 'CREATE_DATE DESC, ' + 'EDI_IF_SEQ DESC, ' + 'SORT_ORDER_NO' AS DATA_ORDER
		*/
		SELECT @ORDER + 'CREATE_DATE DESC, ' + 'SORT_ORDER_NO' AS DATA_ORDER
		
		-- xml확인할경우
		--SELECT CONVERT(TEXT, @v_sql_text)
		--FOR XML PATH('')--,ROOT('x') 

		--execute dbo.SP_executesql @NSQL2 

print 'H--' + convert(varchar(30), getdate(), 121)


	------------------------------------------------------------------------------------------
	--                                                       Temp Table 존재 여부 체크 (BEGIN)
	------------------------------------------------------------------------------------------
	IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_V', N'U') IS NOT NULL 
		DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_V;

	IF OBJECT_ID (N'tempdb..#SELECT_MEASURE', N'U') IS NOT NULL 
		DROP TABLE #SELECT_MEASURE;

	IF OBJECT_ID (N'tempdb..#RAW_DATA', N'U') IS NOT NULL 
		DROP TABLE #RAW_DATA;

	IF OBJECT_ID (N'tempdb..#TEMP_SCM_MST_SITE_ITEM', N'U') IS NOT NULL 
		DROP TABLE #TEMP_SCM_MST_SITE_ITEM;

	------------------------------------------------------------------------------------------
	--                                                       Temp Table 존재 여부 체크 (END)
	------------------------------------------------------------------------------------------

print 'I--' + convert(varchar(30), getdate(), 121)

END

