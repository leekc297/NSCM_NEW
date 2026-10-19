

/*
 * Program ID   : PR_SSP_BI_SSP_RESULT_H
 * Description  : 출하 계획/실적 비교 분석 
 * Execute      : EXEC PR_SSP_BI_SSP_RESULT_H
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022.07.01   SSP Pjt.       Create.
 * 2022.08.09   SSP Pjt.       1 구간 데이터 보관주기 plan_week 기준 -52주부터
 * 2024.01.11   jilee          81_% 사업부 반영
 * 2024.10.01   KHJ            NERP_SSP
 */

CREATE PROCEDURE [dbo].[PR_SSP_BI_SSP_RESULT_H]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'ssp_batch';  
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SSP_BI_SSP_RESULT_H';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N'SCP_BI_SSP_RESULT_H'; -- ▶ 테이블 필수
    DECLARE @d_event_date   DATETIME;

	-- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SCP_BI_SSP_RESULT_H INSERT LOGIC';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;
    -- 임시 실행시간 확인용
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';

	DECLARE @v_basis_yyyymmdd    nvarchar(8) = '';

	DECLARE @v_plan_week				nvarchar(50);
	DECLARE @v_plan_start_yyyymmdd		nvarchar(50);
	DECLARE @v_from_yyyymmdd			nvarchar(50);
	DECLARE @v_to_yyyymmdd				nvarchar(50);
	DECLARE @v_mid_yyyymmdd				nvarchar(50);
	DECLARE @v_plan_week_53				nvarchar(50);

	-- NERP 매핑코드
    DECLARE @v_G388 NVARCHAR(20);
	SET @v_G388 = dbo.FN_GET_LOOKUP_VALUE('PR_SSP_BI_SSP_RESULT_H'  ,'G388' )

	SET @v_basis_yyyymmdd = convert(nvarchar, getdate(), 112);

	PRINT '-------------Start : ' +  CONVERT(CHAR(23), getdate(), 21)

    BEGIN TRY
		BEGIN
		------------------------------------------------------------------------------------------------------------- 
		-- 0. 백업 및 삭제 
		--    과거 52주차 Plan week 및 실적 적재(202201부터 적재 개시)
		--    즉 202302이후는 202201부터 차례로 데이터 삭제됨
		------------------------------------------------------------------------------------------------------------- 
		SELECT @v_plan_week_53 = ISO_YYYYWW
		  FROM SCM_SYS_CALENDAR_M with(nolock)
		 WHERE BASIS_YYYYMMDD = CONVERT(nvarchar, DATEADD(WEEK, -53, getdate()), 112)
		 ;

		INSERT INTO [dbo].[SCP_BI_SSP_RESULT_H_COM]
				   ([DIVISION_ID]
				   ,[COMPANY_ID]
				   ,[TYPE]
				   ,[ERP_SO_NO]
				   ,[CONFIRM_ID]
				   ,[ITEM_ID]
				   ,[NICK_NAME]
				   ,[FROM_SITE]
				   ,[TO_SITE]
				   ,[END_CUSTOMER]
				   ,[YYYYMMDD]
				   ,[TARGET_WEEK]
				   ,[TARGET_MONTH]
				   ,[KPI_MONTH]
				   ,[TARGET_ST_DATE]
				   ,[PARTIAL_START_DATE]
				   ,[ORIGIN_QTY]
				   ,[TRANSPORT_MODE]
				   ,[INCOTERMS]
				   ,[ETD_DATE]
				   ,[ETA_DATE]
				   ,[SHIP_TYPE]
				   ,[BOD_ID]
				   ,[ROUTE_ID]
				   ,[PLAN_WEEK]
				   ,[PLAN_ST_DATE]
				   ,[MODEL]
				   ,[GROUP_CODE]
				   ,[ELECTRODE_TYPE]
				   ,[CONVERT_QTY_CELL]
				   ,[QTY]
				   ,[OPERATION_GROUP]
				   ,[OUTSOURCING_FROM_SITE]
				   ,[OUTSOURCING_TO_SITE]
				   ,[LOGISTIC_PLANT]
				   ,[FROM_COUNTRY]
				   ,[FROM_CITY]
				   ,[TRANSPORT_MODE_B]
				   ,[D_COUNTRY]
				   ,[D_PORT_CODE]
				   ,[D_PORT_NAME]
				   ,[A_COUNTRY]
				   ,[A_PORT_CODE]
				   ,[A_PORT_NAME]
				   ,[TO_COUNTRY]
				   ,[TO_CITY]
				   ,[ENERGY_KWH]
				   ,[EXTRA_SPEC]
				   ,[ITEM_CLASS_NAME]
				   ,[ITEM_TYPE]
				   ,[ATTRIBUTE1]
				   ,[ATTRIBUTE2]
				   ,[ATTRIBUTE3]
				   ,[ATTRIBUTE4]
				   ,[ATTRIBUTE5]
				   ,[ATTRIBUTE6]
				   ,[ATTRIBUTE7]
				   ,[ATTRIBUTE8]
				   ,[ATTRIBUTE9]
				   ,[ATTRIBUTE10]
				   ,[CREATED_BY]
				   ,[CREATION_DATE]
				   ,[LAST_UPDATED_BY]
				   ,[LAST_UPDATE_DATE])
		     SELECT [DIVISION_ID]
				   ,[COMPANY_ID]
				   ,[TYPE]
				   ,[ERP_SO_NO]
				   ,[CONFIRM_ID]
				   ,[ITEM_ID]
				   ,[NICK_NAME]
				   ,[FROM_SITE]
				   ,[TO_SITE]
				   ,[END_CUSTOMER]
				   ,[YYYYMMDD]
				   ,[TARGET_WEEK]
				   ,[TARGET_MONTH]
				   ,[KPI_MONTH]
				   ,[TARGET_ST_DATE]
				   ,[PARTIAL_START_DATE]
				   ,[ORIGIN_QTY]
				   ,[TRANSPORT_MODE]
				   ,[INCOTERMS]
				   ,[ETD_DATE]
				   ,[ETA_DATE]
				   ,[SHIP_TYPE]
				   ,[BOD_ID]
				   ,[ROUTE_ID]
				   ,[PLAN_WEEK]
				   ,[PLAN_ST_DATE]
				   ,[MODEL]
				   ,[GROUP_CODE]
				   ,[ELECTRODE_TYPE]
				   ,[CONVERT_QTY_CELL]
				   ,[QTY]
				   ,[OPERATION_GROUP]
				   ,[OUTSOURCING_FROM_SITE]
				   ,[OUTSOURCING_TO_SITE]
				   ,[LOGISTIC_PLANT]
				   ,[FROM_COUNTRY]
				   ,[FROM_CITY]
				   ,[TRANSPORT_MODE_B]
				   ,[D_COUNTRY]
				   ,[D_PORT_CODE]
				   ,[D_PORT_NAME]
				   ,[A_COUNTRY]
				   ,[A_PORT_CODE]
				   ,[A_PORT_NAME]
				   ,[TO_COUNTRY]
				   ,[TO_CITY]
				   ,[ENERGY_KWH]
				   ,[EXTRA_SPEC]
				   ,[ITEM_CLASS_NAME]
				   ,[ITEM_TYPE]
				   ,[ATTRIBUTE1]
				   ,[ATTRIBUTE2]
				   ,[ATTRIBUTE3]
				   ,[ATTRIBUTE4]
				   ,[ATTRIBUTE5]
				   ,[ATTRIBUTE6]
				   ,[ATTRIBUTE7]
				   ,[ATTRIBUTE8]
				   ,[ATTRIBUTE9]
				   ,[ATTRIBUTE10]
				   ,[CREATED_BY]
				   ,[CREATION_DATE]
				   ,[LAST_UPDATED_BY]
				   ,[LAST_UPDATE_DATE]
			   FROM [dbo].[SCP_BI_SSP_RESULT_H] with(nolock)
		      WHERE PLAN_WEEK = @v_plan_week_53
			  ;


		DELETE FROM [dbo].[SCP_BI_SSP_RESULT_H]
		WHERE PLAN_WEEK = @v_plan_week_53
		;

		------------------------------------------------------------------------------------------------------------- 
		-- 1. 구간 
		--    
		--    
		------------------------------------------------------------------------------------------------------------- 

		SELECT @v_plan_week				= C.ISO_YYYYWW -- PLAN_WEEK
			 , @v_plan_start_yyyymmdd	= (SELECT MIN(BASIS_START_DATE) from  SCM_SYS_CALENDAR_M with(nolock) where ISO_YYYYWW = C.ISO_YYYYWW) -- PLAN_START_YYYYMMDD
			 , @v_from_yyyymmdd			= convert(nvarchar, convert(datetime, C.BASIS_START_DATE) - 56,112) -- FROM_YYYYMMDD
			 , @v_to_yyyymmdd			= convert(nvarchar, convert(datetime, C.BASIS_START_DATE) + 365,112)  -- TO_YYYYMMDD
		  FROM SCM_SYS_CALENDAR_M AS C with(nolock)
		 WHERE C.BASIS_YYYYMMDD = @v_basis_yyyymmdd 
		 ;

		DELETE FROM [dbo].[SCP_BI_SSP_RESULT_H]
		 WHERE PLAN_WEEK = @v_plan_week
		;

		PRINT '-------------Step 1 Deleted : ' +  CONVERT(CHAR(23), getdate(), 21);

		WITH PLAN_INFO AS
		(
			SELECT	@v_plan_week	AS PLAN_WEEK,
					@v_plan_start_yyyymmdd	AS PLAN_START_YYYYMMDD
		),	
		PLAN_DAY_INFO AS
		( 
			SELECT	@v_from_yyyymmdd AS BF_DATE,			-- 당주 포함 과거 7주	
					@v_to_yyyymmdd AS AT_DATE			-- 당주 포함 미래 1년
		),	
		PLAN_INFO_DET AS
		(
			SELECT	A.*, DATE_FULL_NAME AS PLAN_ST_DATE
			FROM	PLAN_INFO A, DBO.SCM_SYS_CALENDAR_M B
			WHERE	1=1
			AND		A.PLAN_START_YYYYMMDD = B.BASIS_YYYYMMDD
		),
		PLAN_DATE_INFO AS 
		(
			SELECT	C.PLAN_ST_DATE, A.MONTH_NAME, A.ISO_YYYYWW, CONCAT(CONCAT(A.MONTH_NAME,'-'), SUBSTRING(A.BASIS_START_DATE,7,2)) AS PARTIAL_START_DATE, B.BASIS_DATE AS TARGET_ST_DATE, CONCAT(D.KPI_MONTH,'-01') AS KPI_MONTH
			FROM	DBO.SCM_SYS_CALENDAR_M A
					LEFT OUTER JOIN (
									SELECT	ISO_YYYYWW, CONVERT(CHAR(10), BASIS_DATE, 23) AS BASIS_DATE
									FROM	DBO.SCM_SYS_CALENDAR_M  with(nolock)
									WHERE	1=1
									AND		DAYOFWEEK = 'MON'				
									) B ON A.ISO_YYYYWW = B.ISO_YYYYWW
					LEFT OUTER JOIN (
									SELECT	ISO_YYYYWW, CALENDAR_YYYY+'-'+CALENDAR_MONTH AS KPI_MONTH
									FROM	DBO.SCM_SYS_CALENDAR_M  with(nolock)
									WHERE	1=1
									AND		DAYOFWEEK = 'THU'					
									) D ON A.ISO_YYYYWW = D.ISO_YYYYWW
					, PLAN_INFO_DET C
			WHERE	1=1
			AND		A.END_FLAG = 'Y'
		),
		PLAN_SEQ_INFO AS
		(
			SELECT	DISTINCT 
					DIVISION_ID,					-- DIVISION_ID
					PLAN_TYPE,						-- PLAN_TYPE
					MAX(SEQ) AS SEQ					-- 버전 별 최종 SEQ
			FROM	SCP_ANL_SHIPMENT_PLAN_FG A  with(nolock), PLAN_INFO B  with(nolock)
			WHERE	1=1
			AND		A.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD
			AND		(DIVISION_ID IN ('81','82','40','EE') OR DIVISION_ID LIKE '81_%')
			AND		PLAN_TYPE = 'FN'
			GROUP	BY DIVISION_ID, PLAN_TYPE	
		),
		LT AS
		(
			--SELECT	BOD_ID, A.ROUTE_ID, TRANSPORT_MODE, (LT_DEPARTURE_INLAND + LT_WAIT_SHIPPING + LT_VOYAGE + LT_LAY_OFF_CLEARANCE + LT_ARRIVAL_INLAND) AS LT
			SELECT	BOD_ID, A.ROUTE_ID, (LT_DEPARTURE_INLAND + LT_WAIT_SHIPPING + LT_VOYAGE + LT_LAY_OFF_CLEARANCE + LT_ARRIVAL_INLAND) AS LT, 
					B.FROM_COUNTRY, B.FROM_CITY, B.TRANSPORT_MODE, B.D_COUNTRY, B.D_PORT_CODE, B.D_PORT_NAME, B.A_COUNTRY, B.A_PORT_CODE, B.A_PORT_NAME, B.TO_COUNTRY, B.TO_CITY
			FROM	SCP_MST_BOD A  with(nolock), SCP_MST_DISTRIBUTION_ROUTE B  with(nolock)
			WHERE	1=1
			AND		A.ROUTE_ID = B.ROUTE_ID
		),
		-- ■ 마스터 데이터 집계 시작
		MODEL_TYPE AS
		(
			-- 자동차 MODEL_TYPE LIST
			SELECT	C.*,
					CASE WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND CHARINDEX('Cell', C.ITEM_CLASS_NAME) > 0) THEN 'Cell'
							WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND CHARINDEX('Module', C.ITEM_CLASS_NAME) > 0) THEN 'Module'
							WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND  CHARINDEX('Pack'  , C.ITEM_CLASS_NAME) > 0) THEN 'Pack'
					ELSE C.FORECAST_INFO_BIZ_TYPE END AS MODEL_TYPE,
					CASE WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND CHARINDEX('Cell', C.ITEM_CLASS_NAME) > 0) THEN 'Cell'
							WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND CHARINDEX('Module', C.ITEM_CLASS_NAME) > 0) THEN 'Module'
							WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND  CHARINDEX('Pack'  , C.ITEM_CLASS_NAME) > 0) THEN 'Pack'
					ELSE C.FORECAST_INFO_BIZ_TYPE END AS ORI_MODEL_TYPE
			FROM	DM_MST_ITEM_SINGLE_V C
			WHERE	1=1
			AND		(DIVISION_ID = '81' OR DIVISION_ID LIKE '81_%')
			--AND		ITEM_TYPE = 'P'
			AND		ACTIVE_FLAG = 'Y'		
			AND		SUBSTRING(ITEM_ID,1,2) IN ('AC','AM','AP')	-- 자동차 완제품 기준
			UNION ALL
			-- ESS MODEL_TYPE LIST
			SELECT	C.*, 
					CASE WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND CHARINDEX('Cell', C.ITEM_CLASS_NAME) > 0) THEN 'Cell'
								WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND CHARINDEX('Module', C.ITEM_CLASS_NAME) > 0) THEN 'Module'
								WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND  CHARINDEX('House'  , C.ITEM_CLASS_NAME) > 0) THEN 'Pack'
								WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND  CHARINDEX('Rack'  , C.ITEM_CLASS_NAME) > 0) THEN 'Pack'
						ELSE C.FORECAST_INFO_BIZ_TYPE END AS MODEL_TYPE,
					CASE WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND CHARINDEX('Cell', C.ITEM_CLASS_NAME) > 0) THEN 'CELL'
								WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND CHARINDEX('Module', C.ITEM_CLASS_NAME) > 0) THEN 'Module'
								WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND  CHARINDEX('House'  , C.ITEM_CLASS_NAME) > 0) THEN 'House'
								WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND  CHARINDEX('Rack'  , C.ITEM_CLASS_NAME) > 0) THEN 'Rack'
						ELSE C.FORECAST_INFO_BIZ_TYPE END AS ORI_MODEL_TYPE
			FROM	DM_MST_ITEM_SINGLE_V C
			WHERE	1=1
			AND		DIVISION_ID = '82'
			--AND		ITEM_TYPE = 'P'
			AND		ACTIVE_FLAG = 'Y'
			AND		SUBSTRING(ITEM_ID,1,1) IN ('E','M','A') -- ESS 완제품 기준
			UNION ALL
			-- 소형 MODEL_TYPE LIST
			SELECT	C.*, 
					CASE WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND CHARINDEX('Cell', C.ITEM_CLASS_NAME) > 0) THEN 'Cell'
							WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND CHARINDEX('Module', C.ITEM_CLASS_NAME) > 0) THEN 'Module'
							WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND  CHARINDEX('Pack'  , C.ITEM_CLASS_NAME) > 0) THEN 'Pack'
					ELSE C.FORECAST_INFO_BIZ_TYPE END AS MODEL_TYPE, 
					CASE WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND CHARINDEX('Cell', C.ITEM_CLASS_NAME) > 0) THEN 'Cell'
							WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND CHARINDEX('Module', C.ITEM_CLASS_NAME) > 0) THEN 'Module'
							WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND  CHARINDEX('Pack'  , C.ITEM_CLASS_NAME) > 0) THEN 'Pack'
					ELSE C.FORECAST_INFO_BIZ_TYPE END AS ORI_MODEL_TYPE
			FROM	DM_MST_ITEM_SINGLE_V C
			WHERE	1=1
			AND		DIVISION_ID = '40'
			--AND		ITEM_TYPE = 'P'
			AND		ACTIVE_FLAG = 'Y'
			AND		SUBSTRING(ITEM_ID,1,1) IN ('M','E','A') -- 소형 완제품 기준	
		),
		MODEL_BOM AS
		(
			SELECT	DIVISION_ID, MODEL_ID, OPERATION_GROUP_ID, ROUND(AVG(ACCUMULATED_CHILD_QTY),1) AS ACCUMULATED_CHILD_QTY
			FROM	DBO.SCM_MST_MODEL_FINAL_ITEM_BOM_V A WITH (NOLOCK),
					(
					SELECT	DISTINCT ITEM_ID
					FROM	SCP_MST_FINAL_ITEM  with(nolock)
					WHERE	1=1
					AND		OPERATION_GROUP = 'A'
					) B
			WHERE	1=1
			AND		A.OPERATION_GROUP_ID = 'A'	
			AND		A.CHILD_ITEM_ID = B.ITEM_ID
			GROUP	BY DIVISION_ID, MODEL_ID, OPERATION_GROUP_ID
		),
		SCP_MST_FINAL_ITEM_VIEW AS
		(
			SELECT	A.*, B.SEGMENT2 
			FROM	SCP_MST_FINAL_ITEM A
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B  with(nolock)
					ON A.CELL_TYPE_GROUP_CODE = B.SEGMENT1 AND B.LOOKUP_TYPE = 'CELL_TYPE_GROUP_CODE' AND B.VALID_YN = 'Y'
			WHERE	1=1
		),
		END_CUSTOMER AS
		(
			-- 고객사 Logic : 1) SITE, PROJECT 둘다 매핑되는 고객사 셋팅 2) 1에서 NULL 나오는 CASE는 SITE만 있으면 매핑 3) 그래도 매핑 안되는 case는 'NULL_Site' 정보 제공
			SELECT	DISTINCT 
					A.DIVISION_ID, 
					A.PROJECT_CODE, 
					A.SCM_SITE_ID, 
					A.ITEM_ID, 
					A.CELL_PER_CAR,
					A.CELL_PER_MODULE,
					-- 40에서 APPLICATION으로 CATEGORY 구분함(EX> 노트북 등..)
					A.CUST_GROUP, 
					A.CUST_GROUP_DTL, 
					A.APPLICATION,
					A.CELL_MODEL, 
					A.PRODUCT_GROUP,
					CASE WHEN A.DIVISION_ID = '40' THEN D.DEPT_NAME_KO
							ELSE C.DEPT_NAME_KO END AS DEPT_NAME_KO,
					A.VMI_YN,
					-- 40은 PROJECT_CODE가 END_CUSTOMER임.
					CASE WHEN A.DIVISION_ID = '40' THEN A.PROJECT_CODE 
							ELSE (CASE WHEN A.END_CUSTOMER IS NULL THEN B.END_CUSTOMER ELSE A.END_CUSTOMER END) END AS END_CUSTOMER
					---CASE WHEN A.END_CUSTOMER IS NULL THEN B.END_CUSTOMER ELSE A.END_CUSTOMER END AS END_CUSTOMER
			FROM	(
					SELECT	DISTINCT A.DIVISION_ID, 
							A.PROJECT_CODE, 
							A.SCM_SITE_ID, 
							A.ITEM_ID, 
							B.END_CUSTOMER, 
							A.CELL_PER_CAR, 
							A.CELL_PER_MODULE, 
							A.CUST_GROUP, 
							A.CUST_GROUP_DTL, 
							A.APPLICATION, 
							A.ATTRIBUTE5 AS CELL_MODEL, 
							A.REPORT_GROUP3 AS PRODUCT_GROUP,
							B.VMI_YN,
							-- 81, 82의 경우 DEPT_ID는 PROJECT 정보를(SCM_MST_SITE에서) 참조하나, 40인 경우에는 OWNER의 부서정보를 참조함(공용화모델 CASE로 중복 발생 때문)
							B.DEPT_ID AS DEPT_ID,	-- 81, 82
						(	SELECT SU.DEPT_ID  
							FROM SCM_MST_SSO_USER_INFO SU WITH (NOLOCK)
							WHERE SU.USER_ID = (SELECT top 1 token FROM [dbo].[String_Split](A.owner, ',')) ) DEPT_ID_SMALL  -- 40
					FROM	SCM_MST_SITE_ITEM A  with(nolock), SCM_MST_SITE B  with(nolock)
					WHERE	1=1
					AND		A.DIVISION_ID = B.DIVISION_ID
					AND		A.SCM_SITE_ID = B.SCM_SITE_ID
					-- 주석 처리한 이유 : 과거 계획/실적을 조회할 수 있으므로...
					--AND		A.VALID_YN = 'Y'
					--AND		B.VALID_YN = 'Y'	
					) A 
					LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO C  with(nolock) ON A.DEPT_ID = C.DEPT_ID
					LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO D  with(nolock) ON A.DEPT_ID_SMALL = D.DEPT_ID
					, SCM_MST_SITE B
			WHERE	1=1
			AND		A.SCM_SITE_ID = B.SCM_SITE_ID
			AND		A.DIVISION_ID = B.DIVISION_ID
			--AND		B.VALID_YN = 'Y'
		),
		END_CUSTOMER_2 AS
		(
			SELECT	DISTINCT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, END_CUSTOMER
			FROM	END_CUSTOMER  with(nolock)
			WHERE	1=1
			AND		(DIVISION_ID IN ('40','81','82') OR DIVISION_ID LIKE '81_%')
		),
		GROUP_CODE AS
		(
			SELECT	DISTINCT DIVISION_ID, ITEM_ID, DOE, MAX(SCP_EXTRA_SPEC) AS EXTRA_SPEC
			FROM	[dbo].[SCM_MST_ITEM_SN]  with(nolock)
			WHERE	1=1
			AND		ITEM_TYPE = 'P'	
			GROUP	BY DIVISION_ID, ITEM_ID, DOE
		),
		ELEC_CONVERT_QTY_CELL AS
		(
		SELECT	DISTINCT A.DIVISION_ID, A.ITEM_ID, A.OPERATION_GROUP, A.CELL_ITEM_ID, 
				CASE WHEN A.DIVISION_ID NOT IN ('40') THEN 'Pouch' ELSE B.SEGMENT2 END AS ELECTRODE_TYPE, A.CONVERT_QTY_CELL
		FROM	SCP_MST_FINAL_ITEM A  with(nolock)
				LEFT OUTER JOIN 
				(
				SELECT	DISTINCT DIVISION_ID, ITEM_ID, B.SEGMENT2
				FROM	SCP_MST_FINAL_ITEM A  with(nolock)
						LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B  with(nolock) 
						ON A.CELL_TYPE_GROUP_CODE = B.SEGMENT1 AND B.LOOKUP_TYPE = 'CELL_TYPE_GROUP_CODE' AND B.VALID_YN = 'Y'
				WHERE	1=1
				AND		OPERATION_GROUP <> 'E'		
				) B ON A.DIVISION_ID = B.DIVISION_ID AND A.CELL_ITEM_ID = B.ITEM_ID
		WHERE	1=1
		AND		OPERATION_GROUP = 'E'
		),
		-- SCP SHIPMENT PLAN 시작
		SCP_RESULT AS
		(
			SELECT	DISTINCT A.*, 
					C.ISO_YYYYWW, CONCAT(C.MONTH_NAME,'-01') AS BASIS_YYYYMM, D.COMPANY_ID, TRANSPORT_MODE, D.SITE_DESCRIPTION, E.ROUTE_ID,
					CASE WHEN (A.DIVISION_ID = '81' OR A.DIVISION_ID LIKE '81_%') THEN F.END_CUSTOMER
							WHEN A.DIVISION_ID = '40' THEN A.PROJECT_CODE
							WHEN A.DIVISION_ID = '82' THEN F.END_CUSTOMER
					ELSE NULL END AS END_CUSTOMER
			FROM	SCP_ANL_SHIPMENT_PLAN_FG A  with(nolock)
					LEFT OUTER JOIN END_CUSTOMER_2 F  with(nolock) ON A.TO_SITE = F.SCM_SITE_ID AND A.DIVISION_ID = F.DIVISION_ID
					, PLAN_INFO B, SCM_SYS_CALENDAR_M C  with(nolock), SCM_MST_SITE D  with(nolock), LT E, PLAN_SEQ_INFO G, PLAN_DAY_INFO H
			WHERE	1=1
			AND		(A.DIVISION_ID IN ('40','81','82') OR A.DIVISION_ID LIKE '81_%')
			AND		A.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD
			AND		A.PLAN_TYPE = 'FN'
			AND		A.MEASURE = 'SHIP_PLAN_AMEND'
			AND		A.YYYYMMDD = C.BASIS_YYYYMMDD
			AND		A.QTY <> 0
			AND     A.YYYYMMDD BETWEEN H.BF_DATE AND H.AT_DATE
			AND		A.FROM_SITE = D.SCM_SITE_ID
			AND		A.BOD_ID = E.BOD_ID
			AND		A.DIVISION_ID = G.DIVISION_ID
			AND		A.PLAN_TYPE = G.PLAN_TYPE
			AND		A.SEQ = G.SEQ
		),						
		SCP_RESULT_SEMI AS						
		(					
			SELECT	DISTINCT A.*, C.ISO_YYYYWW, CONCAT(C.MONTH_NAME,'-01') AS BASIS_YYYYMM, D.COMPANY_ID, TRANSPORT_MODE, D.SITE_DESCRIPTION, D.COMPANY_ID AS FROM_SITE_COMPANY, H.COMPANY_ID AS TO_SITE_COMPANY, H.SITE_DESCRIPTION AS TO_SITE_DESCRIPTION, E.ROUTE_ID,
					CASE WHEN (A.DIVISION_ID = '81' OR A.DIVISION_ID LIKE '81_%') THEN F.END_CUSTOMER
							WHEN A.DIVISION_ID = '40' THEN ''
							WHEN A.DIVISION_ID = '82' THEN F.END_CUSTOMER
					ELSE NULL END AS END_CUSTOMER,
					-- 같은 Plant 이동은 제외 (1. 동일 Plant, 2. ESMI → HZP, 3. 자사 → 외주)
					CASE WHEN D.COMPANY_ID <> H.COMPANY_ID THEN 'Y'
--							ELSE (CASE WHEN (H.OSP_YN = 'Y' OR H.PLANT_ID = 'G388') THEN 'Y' ELSE 'N' END) END AS FLAG
							ELSE (CASE WHEN (H.OSP_YN = 'Y' OR H.PLANT_ID = @v_G388) THEN 'Y' ELSE 'N' END) END AS FLAG
			FROM	HIST_SCP_ANL_SHIPMENT_PLAN_SEMI A	 with(nolock)			
					LEFT OUTER JOIN END_CUSTOMER_2 F  with(nolock) ON A.TO_SITE = F.SCM_SITE_ID AND A.DIVISION_ID = F.DIVISION_ID			
					, PLAN_INFO B, SCM_SYS_CALENDAR_M C  with(nolock), SCM_MST_SITE D  with(nolock), LT E, PLAN_SEQ_INFO G, SCM_MST_SITE H  with(nolock), PLAN_DAY_INFO I
			WHERE	1=1				
			AND		(A.DIVISION_ID IN ('40','81','82','EE') OR A.DIVISION_ID LIKE '81_%')
			AND		A.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD			
			AND		A.PLAN_TYPE = 'FN'			
			AND		A.MEASURE = 'SHIP_PLAN_AMEND'			
			AND		A.YYYYMMDD = C.BASIS_YYYYMMDD			
			AND		A.QTY <> 0	
			AND     A.YYYYMMDD BETWEEN I.BF_DATE AND I.AT_DATE
			AND		A.FROM_SITE = D.SCM_SITE_ID			
			AND		A.BOD_ID = E.BOD_ID	
			-- SEMI의 SEQ나 PLAN의 SEQ나 PLAN별 집계횟수는 동일함.
			AND		A.DIVISION_ID = G.DIVISION_ID
			AND		A.PLAN_TYPE = G.PLAN_TYPE 
			AND		A.SEQ = G.SEQ 
			AND		A.TO_SITE = H.SCM_SITE_ID	
		),
		SCP_FINAL_SEMI AS
		(
			SELECT	DIVISION_ID, 
					COMPANY_ID,
					'SCP_Plan' AS TYPE,
					'' AS ERP_SO_NO,
					'' AS CONFIRM_ID,
					ITEM_ID,
					'' AS NICK_NAME,
					SITE_DESCRIPTION AS FROM_SITE,
					TO_SITE,
					END_CUSTOMER,
					QTY,
					CONVERT(varchar(10), CONVERT(date, CONVERT(varchar(8), YYYYMMDD))) as YYYYMMDD,
					TRANSPORT_MODE,
					INCOTERMS,
					'' AS ETD_DATE,
					'' AS ETA_DATE,
					'' AS SHIP_TYPE,
					A.ISO_YYYYWW AS TARGET_WEEK,
					A.BASIS_YYYYMM AS TARGET_MONTH,
					A.BOD_ID,
					A.ROUTE_ID
			FROM	SCP_RESULT A
			WHERE	1=1
			UNION ALL
			SELECT	CASE WHEN DIVISION_ID = 'EE' THEN ORIGIN_FROM_DIVISION_ID ELSE DIVISION_ID END AS DIVISION_ID, 				
					COMPANY_ID,			
					'SCP_Plan' AS TYPE,			
					'' AS ERP_SO_NO,			
					'' AS CONFIRM_ID,			
					ITEM_ID,			
					'' AS NICK_NAME,			
					SITE_DESCRIPTION AS FROM_SITE,			
					TO_SITE_DESCRIPTION AS TO_SITE,			
					'In-House' AS END_CUSTOMER,			
					QTY,			
					CONVERT(varchar(10), CONVERT(date, CONVERT(varchar(8), YYYYMMDD))) as YYYYMMDD,			
					TRANSPORT_MODE,			
					'In-House' AS INCOTERMS,			
					'' AS ETD_DATE,			
					'' AS ETA_DATE,			
					CASE WHEN SUBSTRING(FROM_SITE,1,4) = SUBSTRING(TO_SITE,1,4) THEN 'PLANT' ELSE '' END AS SHIP_TYPE,			
					A.ISO_YYYYWW AS TARGET_WEEK,
					A.BASIS_YYYYMM AS TARGET_MONTH,
					A.BOD_ID,
					A.ROUTE_ID
			FROM	SCP_RESULT_SEMI A					
			WHERE	1=1	
			AND		FLAG = 'Y'
		),
		SCP_FINAL AS
		(
		SELECT	DIVISION_ID,
				COMPANY_ID, 
				TYPE, 
				ERP_SO_NO, 
				CONFIRM_ID, 
				ITEM_ID, 
				NICK_NAME, 
				FROM_SITE, 
				TO_SITE, 
				END_CUSTOMER, 
				TARGET_WEEK, 
				TARGET_MONTH,
				YYYYMMDD, 
				--SUM(QTY) AS QTY, 			
				QTY, 			
				TRANSPORT_MODE, 
				INCOTERMS, 
				ETD_DATE, 
				ETA_DATE, 
				SHIP_TYPE, 
				BOD_ID, 
				ROUTE_ID
		FROM	SCP_FINAL_SEMI
		),
		---- SSP + 출하실적 시작
		RESULT_ERP_C_EXIST AS 
		(
			-- ERP 출하실적에서 CONFIRM_ID 존재, SSP_TYPE 대상 
			SELECT  E.DIVISION_ID             AS DIVISION_ID
			,       E.CONFIRM_ID              AS CONFIRM_ID
			,       E.ORDER_NO				  AS ERP_SO_NO 
			,       E.EXFACTORY_DATE          AS YYYYMMDD
			,       E.TRANSPORT_MODE		  AS TRANSPORT_MODE
			,       E.INCOTERMS				  AS INCOTERMS
			,		E.ETA_DATE				  AS ETA_DATE
			,		E.ETD_DATE				  AS ETD_DATE
			,		E.FROM_SCM_SITE_ID		  AS FROM_SITE
			,		E.TO_SCM_SITE_ID		  AS TO_SITE
			,		E.ITEM_ID				  AS ITEM_ID
			,       SUM(E.EXFACTORY_QTY )     AS RESULT_QTY 
			FROM [DBO].[SCM_DNM_EXFACTORY_RESULT] E WITH(NOLOCK)
				JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
					ON L.LOOKUP_TYPE = 'ERP_SSP_TYPE' -- LOOKUP에 등록된 공정만 
				AND L.VALID_YN = 'Y'
				AND L.SEGMENT1    = E.SSP_TYPE
			JOIN SCM_MST_SITE AS S WITH(NOLOCK)					 
				ON E.FROM_SCM_SITE_ID	= S.SCM_SITE_ID				 
				AND E.DIVISION_ID	= S.DIVISION_ID				 
				AND S.SITE_TYPE		= 'PLANT'					 				 
			JOIN SCM_MST_ITEM_SN AS T WITH(NOLOCK)				 
				ON E.ITEM_ID		= T.ITEM_ID					 
				AND E.DIVISION_ID	= T.DIVISION_ID				 
				AND S.COMPANY_ID		= T.COMPANY_ID				 
				AND T.ITEM_TYPE		NOT IN ('Q','R')
				, PLAN_DAY_INFO A
			WHERE 1=1
			AND   ISNULL(E.EXFACTORY_STATUS,'D90') NOT IN ('D90' ,'D10') -- D90: DO삭제 , D10:DO생성 
			AND   E.CONFIRM_ID LIKE 'C%'
			--AND   E.EXFACTORY_DATE BETWEEN '20220101'  AND '20220131' 
			AND   E.EXFACTORY_DATE BETWEEN A.BF_DATE  AND A.AT_DATE
		
				
			GROUP BY E.DIVISION_ID 
			,        E.CONFIRM_ID
			,        E.ORDER_NO
			,        E.EXFACTORY_DATE
			,        E.TRANSPORT_MODE
			,        E.INCOTERMS		
			,		 E.ETA_DATE		
			,		 E.ETD_DATE
			,		 E.FROM_SCM_SITE_ID	
			,		 E.TO_SCM_SITE_ID	
			,		 E.ITEM_ID
			)
		, RESULT_ERP_C_NON AS 
		(
			-- ERP 출하실적에서 CONFIRM_ID 없는 실적 
			SELECT  E.DIVISION_ID             AS DIVISION_ID
			,       '-'                       AS CONFIRM_ID
			,       E.ORDER_NO				  AS ERP_SO_NO 
			,       E.FROM_SCM_SITE_ID        AS FROM_SITE                                                                    
			,       ISNULL(L3.SEGMENT4, E.TO_SCM_SITE_ID)     AS TO_SITE   
			,       E.ITEM_ID                 AS ITEM_ID
			,       E.EXFACTORY_DATE          AS YYYYMMDD
			,       E.TRANSPORT_MODE		  AS TRANSPORT_MODE
			,       E.INCOTERMS				  AS INCOTERMS
			,		E.ETA_DATE				  AS ETA_DATE
			,		E.ETD_DATE				  AS ETD_DATE
			,       SUM(E.EXFACTORY_QTY )     AS QTY  
			FROM [DBO].[SCM_DNM_EXFACTORY_RESULT] E WITH(NOLOCK)
			JOIN SCM_MST_SITE AS S WITH(NOLOCK)					 
				ON E.FROM_SCM_SITE_ID	= S.SCM_SITE_ID				 
				AND E.DIVISION_ID	= S.DIVISION_ID				 
				AND S.SITE_TYPE		= 'PLANT'					 				 
			JOIN SCM_MST_ITEM_SN AS T WITH(NOLOCK)				 
				ON E.ITEM_ID		= T.ITEM_ID					 
				AND E.DIVISION_ID	= T.DIVISION_ID				 
				AND S.COMPANY_ID		= T.COMPANY_ID				 
				AND T.ITEM_TYPE		NOT IN ('Q','R')
			JOIN  SCP_MST_FINAL_ITEM F WITH(NOLOCK) -- SCP 대상 ITEM만 
				ON F.ITEM_ID = E.ITEM_ID 
				AND F.DIVISION_ID = E.DIVISION_ID
			JOIN   SCM_MST_SITE FS WITH(NOLOCK)
				ON FS.SCM_SITE_ID = E.FROM_SCM_SITE_ID 
				AND FS.DIVISION_ID = E.DIVISION_ID 
				-- AND ISNULL(FS.OSP_YN,'N') <> 'Y' --- [C20200121-000352]-2 : FROM_SITE PACKER포함(OSP_YN <> 'Y' 조건제외)
			-- 2020.09.18 김광희 책임 요청으로 주석처리
			-- 2021.04.15 김광희 책임 요청으로 주석해제
			JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
				ON L.LOOKUP_TYPE = 'ERP_ORDER_TYPE' -- LOOKUP에 등록된 ORDER_TYPE만 대상으로 함 
			AND L.VALID_YN = 'Y'
			AND L.SEGMENT1    = E.ORDER_TYPE_CODE 	
			LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L3 WITH(NOLOCK)
					ON L3.LOOKUP_TYPE = 'SHIP_RESULT_TO_SITE_MAPPING' --SOLDTO, SHIPTO 과 MAPPING되는 TO_SITE 
				AND L3.SEGMENT1    = E.DIVISION_ID 
				AND L3.SEGMENT2    = E.SOLDTO_CODE
				AND L3.SEGMENT3    = E.SHIPTO_CODE	
				, PLAN_DAY_INFO A				    
			WHERE 1=1
			AND   ISNULL(E.EXFACTORY_STATUS,'D90') NOT IN ('D90' ,'D10') -- D90: DO삭제 , D10:DO생성 
			AND   ISNULL(E.CONFIRM_ID,'') NOT LIKE  'C%'
			--AND   E.EXFACTORY_DATE BETWEEN  '20220101'  AND '20220131' 
			AND   E.EXFACTORY_DATE BETWEEN A.BF_DATE  AND A.AT_DATE
		
			--[C20210330-000402]
			--AND   E.FROM_SCM_SITE_ID IS NOT NULL 
			--AND   E.TO_SCM_SITE_ID IS NOT NULL 
			AND   E.STORAGE_ID NOT IN ('6000' ,'799A') --상품창고제외 
			--[C20200403-000062]
			AND   E.STORAGE_ID NOT IN (SELECT SEGMENT1 
									FROM SCM_ADM_LOOKUP_MASTER_DETAIL  with(nolock)
									WHERE LOOKUP_TYPE = 'SSP_SHIP_RESULT_EXCEPT_STORAGE'
										AND VALID_YN = 'Y'
									)	-- 사외 창고 제외 LOOKUP 관리
			--AND   E.ORDER_TYPE_CODE  IN ('ZEF','ZEFC','ZEML','ZEMM','ZEX','ZFD','ZFR','ZKB','ZMM','ZOR','ZFDC','ZKM') -- 해당 ORDER_TYPE만 대상으로 함 

			GROUP BY E.DIVISION_ID
			,        E.ORDER_NO
			,        E.FROM_SCM_SITE_ID                                                                           
			,        ISNULL(L3.SEGMENT4, E.TO_SCM_SITE_ID) 
			,        E.ITEM_ID
			,        E.EXFACTORY_DATE
			,        E.TRANSPORT_MODE
			,        E.INCOTERMS		
			,		 E.ETA_DATE		
			,		 E.ETD_DATE
			,		 E.FROM_SCM_SITE_ID	
			,		 E.TO_SCM_SITE_ID	
		)
		, PLAN_SSP AS  
		(   -- SSP출하계획 ( confirm된 계획) - Current Version
			SELECT C.DIVISION_ID    AS DIVISION_ID
			,      C.ERP_SO_NO      AS ERP_SO_NO
			,      C.CONFIRM_ID     AS CONFIRM_ID 
			,      C.ITEM_ID        AS ITEM_ID 
			,      C.FROM_SITE      AS FROM_SITE 
			,      C.TO_SITE        AS TO_SITE 
			,      CASE WHEN C.DIVISION_ID= '4O' THEN ISNULL(SI.PROJECT_CODE,'-')    
						ELSE ISNULL(TS.END_CUSTOMER,'-')  END         AS END_CUSTOMER  
			,      C.QTY            AS QTY 
			,      C.YYYYMMDD       AS YYYYMMDD 
			,      C.TRANSPORT_MODE AS TRANSPORT_MODE
			,      C.INCOTERMS      AS INCOTERMS
			,      C.ETD_DATE       AS ETD_DATE
			,      C.ETA_DATE       AS ETA_DATE
			,	   NULL				AS SHIP_TYPE
			,	   C.BOD_ID         AS BOD_ID		
			,	   C.ROUTE_ID       AS ROUTE_ID
			FROM [DBO].[SSP_ANL_SHIP_CONFIRM] C WITH(NOLOCK)	--SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK) 
			JOIN SCM_MST_SITE AS S WITH(NOLOCK)					 
				ON C.FROM_SITE		= S.SCM_SITE_ID				 
				AND C.DIVISION_ID	= S.DIVISION_ID				 
				AND S.SITE_TYPE		= 'PLANT'					 				 
			JOIN SCM_MST_ITEM_SN AS T WITH(NOLOCK)				 
				ON C.ITEM_ID		= T.ITEM_ID					 
				AND C.DIVISION_ID	= T.DIVISION_ID				 
				AND S.COMPANY_ID		= T.COMPANY_ID				 
				AND T.ITEM_TYPE		NOT IN ('Q','R')
			LEFT OUTER JOIN [dbo].[SCM_MST_SITE_ITEM] SI WITH(NOLOCK)	--SCM_MST_SITE_ITEM SI WITH(NOLOCK) 
						ON SI.DIVISION_ID = C.DIVISION_ID
						AND SI.ITEM_ID     = C.ITEM_ID 
						AND SI.SCM_SITE_ID = C.TO_SITE
						AND SI.PROJECT_CODE = C.PROJECT_CODE 
 			LEFT OUTER JOIN [dbo].[SCM_MST_SITE] TS WITH(NOLOCK)	--SCM_MST_SITE TS WITH(NOLOCK) 
						ON TS.DIVISION_ID = C.DIVISION_ID
						AND TS.SCM_SITE_ID = C.TO_SITE 
			WHERE CHANGE_TYPE = 'C'
			AND   QTY > 0 

			UNION ALL
			SELECT C.DIVISION_ID    AS DIVISION_ID
			,      ''				AS ERP_SO_NO
			,      ''				AS CONFIRM_ID 
			,      C.ITEM_ID        AS ITEM_ID 
			,      C.PLANT_SITE_ID      AS FROM_SITE 
			,      C.SCM_SITE_ID        AS TO_SITE 
			,      CASE WHEN C.DIVISION_ID= '4O' THEN ISNULL(SI.PROJECT_CODE,'-')    
						ELSE ISNULL(TS.END_CUSTOMER,'-')  END         AS END_CUSTOMER  
			,      C.QTY            AS QTY 
			,      C.YYYYMMDD       AS YYYYMMDD 
			,      C.TRANSPORT_MODE AS TRANSPORT_MODE
			,      C.INCOTERMS      AS INCOTERMS
			,      C.YYYYMMDD       AS ETD_DATE
			,      CONVERT(VARCHAR(8),CONVERT(DATETIME,[dbo].[FN_GET_SSP_ETA_DATE](C.DIVISION_ID, C.BOD_ID, C.YYYYMMDD) ,112), 112) AS ETA_DATE     
			,	   NULL				AS SHIP_TYPE
			,	   C.BOD_ID         AS BOD_ID		
			,	   ''       AS ROUTE_ID
			FROM [DBO].[DM_PLN_SHIPMENT_REQ] C WITH(NOLOCK)	--SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK) 
			JOIN SCM_MST_SITE AS S WITH(NOLOCK)					 
				ON C.PLANT_SITE_ID		= S.SCM_SITE_ID				 
				AND C.DIVISION_ID	= S.DIVISION_ID				 
				AND S.SITE_TYPE		= 'PLANT'					 				 
			JOIN SCM_MST_ITEM_SN AS T WITH(NOLOCK)				 
				ON C.ITEM_ID		= T.ITEM_ID					 
				AND C.DIVISION_ID	= T.DIVISION_ID				 
				AND S.COMPANY_ID		= T.COMPANY_ID				 
				AND T.ITEM_TYPE		NOT IN ('Q','R')
			LEFT OUTER JOIN [dbo].[SCM_MST_SITE_ITEM] SI WITH(NOLOCK)	--SCM_MST_SITE_ITEM SI WITH(NOLOCK) 
						ON SI.DIVISION_ID = C.DIVISION_ID
						AND SI.ITEM_ID     = C.ITEM_ID 
						AND SI.SCM_SITE_ID = C.SCM_SITE_ID
						AND SI.PROJECT_CODE = C.PROJECT_CODE 
			LEFT OUTER JOIN [dbo].[SCM_MST_SITE] TS WITH(NOLOCK)	--SCM_MST_SITE TS WITH(NOLOCK) 
						ON TS.DIVISION_ID = C.DIVISION_ID
						AND TS.SCM_SITE_ID = C.SCM_SITE_ID 
			WHERE 1=1
			AND   QTY > 0 
			AND	  C.YYYYMMDD >= CASE WHEN isnull(S.ship_frozen,0) > 0 THEN CONVERT(CHAR(8), DATEADD(DD, isnull(S.ship_frozen,0), CONVERT(VARCHAR, '' + CONVERT(CHAR(8), GETDATE(), 112) + '', 121)), 112) ELSE '' + CONVERT(CHAR(8), GETDATE(), 112) + '' END
		)
		, RESULT_OWMS AS
		(
			-- owms 출하실적
			SELECT A.DIVISION_ID       AS DIVISION_ID 
			,      A.ITEM_ID           AS ITEM_ID 
			,      A.FROM_SITE         AS FROM_SITE
			,      CASE WHEN A.TO_SITE ='-' THEN A.CUSTOMER_CODE ELSE  A.TO_SITE END          AS TO_SITE
			,      SUM(A.LOT_QTY)            AS QTY 
			,      A.PLANT_ISSUE_DATE  AS YYYYMMDD
			,	   A.SHIP_TYPE AS SHIP_TYPE
			FROM SSP_DNM_SHIP_RESULT_OWMS A WITH(NOLOCK), PLAN_DAY_INFO C
			WHERE 1=1
			AND		A.PLANT_ISSUE_DATE BETWEEN C.BF_DATE  AND C.AT_DATE
			--A.PLANT_ISSUE_DATE BETWEEN  @p_from_yyyymmdd  AND @p_to_yyyymmdd 
			GROUP BY A.DIVISION_ID        
			,        A.ITEM_ID      
			,        A.FROM_SITE   
			,        CASE WHEN A.TO_SITE ='-' THEN A.CUSTOMER_CODE ELSE A.TO_SITE  END  
			,        A.PLANT_ISSUE_DATE  
			,		 A.SHIP_TYPE
		)

		, RETURN_OWMS AS
		(
			-- owms 출하 반품
			SELECT B.DIVISION_ID      AS DIVISION_ID 
			,      B.ITEM_ID          AS ITEM_ID 
			,      B.FROM_SITE        AS FROM_SITE
			,      '*'                AS TO_SITE 
			,      SUM(B.RECIEPT_QTY) AS QTY 
			,      B.RECIEPT_DATE     AS YYYYMMDD 
			,	   NULL AS SHIP_TYPE
			FROM SSP_DNM_SHIP_RETURN_OWMS B WITH(NOLOCK), PLAN_DAY_INFO C
			WHERE 1=1
			AND		B.RECIEPT_DATE BETWEEN C.BF_DATE  AND C.AT_DATE
			GROUP BY B.DIVISION_ID        
			,        B.ITEM_ID      
			,        B.FROM_SITE   
			,        B.RECIEPT_DATE 
		
		)
		, SSP_PLAN_RESULT AS
		(
			SELECT X.DIVISION_ID
			,      MS.COMPANY_ID AS COMPANY_ID
			,      L.SEGMENT2  AS TYPE 
			,	   X.ERP_SO_NO
			,      X.CONFIRM_ID 
			,      X.ITEM_ID 
			,      DBO.FN_GET_ITEM_NICKNAME(X.DIVISION_ID, X.ITEM_ID) AS NICK_NAME
			--,      X.FROM_SITE 
			--,      X.TO_SITE
			,      ISNULL(dbo.FN_GET_SCM_SITE_DESCRIPTION(X.DIVISION_ID,X.FROM_SITE),X.FROM_SITE)   AS FROM_SITE 
			,      ISNULL(dbo.FN_GET_SCM_SITE_DESCRIPTION(X.DIVISION_ID,X.TO_SITE),X.TO_SITE)       AS TO_SITE 
			,      X.END_CUSTOMER  
			,      X.QTY 
			,      CONVERT(VARCHAR(10),   CONVERT(DATETIME, X.YYYYMMDD,112), 23) AS YYYYMMDD 
			,      X.TRANSPORT_MODE
			,      X.INCOTERMS
			,      CONVERT(VARCHAR(10),   CONVERT(DATETIME, X.ETD_DATE,112), 23) AS ETD_DATE
			,      CONVERT(VARCHAR(10),   CONVERT(DATETIME, X.ETA_DATE,112), 23) AS ETA_DATE
			,	   X.SHIP_TYPE
			,	   X.BOD_ID
			,	   X.ROUTE_ID
			FROM (
				--CONFIRM_ID ,날짜동일한 기준으로 계획정보의 FROM, TO SITE기준으로 실적 집계 
				SELECT R.DIVISION_ID     AS DIVISION_ID
				,     'E'				 AS TYPE 
				,      R.ERP_SO_NO       AS ERP_SO_NO
				,      R.CONFIRM_ID      AS CONFIRM_ID 
				,      R.ITEM_ID         AS ITEM_ID 
				,      R.FROM_SITE       AS FROM_SITE 
				,      R.TO_SITE         AS TO_SITE 
				,      NULL              AS END_CUSTOMER
				,      SUM(R.RESULT_QTY) AS QTY 
				,      R.YYYYMMDD        AS YYYYMMDD
				,      R.TRANSPORT_MODE  AS TRANSPORT_MODE
				,      R.INCOTERMS       AS INCOTERMS
				,      R.ETD_DATE        AS ETD_DATE
				,      R.ETA_DATE        AS ETA_DATE
				,      NULL				 AS SHIP_TYPE
				,	   ''				 AS BOD_ID	
				,	   ''				 AS ROUTE_ID
				FROM  RESULT_ERP_C_EXIST R 
	
				GROUP BY R.DIVISION_ID
				,		 R.ERP_SO_NO
				,        R.FROM_SITE                                                                           
				,        R.TO_SITE 
				,        R.ITEM_ID
				,		 R.TRANSPORT_MODE			   
				,		 R.INCOTERMS
				,		 R.ETD_DATE
				,		 R.ETA_DATE		   
				,        R.YYYYMMDD 
				,        R.CONFIRM_ID

			UNION ALL 

				--CONFIRM_ID 없는 실적 
				SELECT R.DIVISION_ID     AS DIVISION_ID
				,     'E'                AS TYPE 
				,      R.ERP_SO_NO       AS ERP_SO_NO
				,      NULL              AS CONFIRM_ID 
				,      R.ITEM_ID         AS ITEM_ID 
				,      R.FROM_SITE       AS FROM_SITE 
				,      R.TO_SITE         AS TO_SITE 
				,      NULL              AS END_CUSTOMER
				,      R.QTY             AS QTY 
				,      R.YYYYMMDD        AS YYYYMMDD 
				,      R.TRANSPORT_MODE  AS TRANSPORT_MODE
				,      R.INCOTERMS       AS INCOTERMS
				,      R.ETD_DATE        AS ETD_DATE
				,      R.ETA_DATE        AS ETA_DATE
				,      NULL              AS SHIP_TYPE
				,	   ''				 AS BOD_ID	
				,	   ''				 AS ROUTE_ID
				FROM  RESULT_ERP_C_NON R 

			UNION ALL
  
				SELECT P.DIVISION_ID     AS DIVISION_ID
				,     'P'                AS TYPE 
				,      P.ERP_SO_NO       AS ERP_SO_NO
				,      P.CONFIRM_ID      AS CONFIRM_ID 
				,      P.ITEM_ID         AS ITEM_ID 
				,      P.FROM_SITE       AS FROM_SITE 
				,      P.TO_SITE         AS TO_SITE 
				,      P.END_CUSTOMER    AS END_CUSTOMER
				,      P.QTY             AS QTY 
				,      P.YYYYMMDD        AS YYYYMMDD 
				,      P.TRANSPORT_MODE  AS TRANSPORT_MODE
				,      P.INCOTERMS       AS INCOTERMS
				,      P.ETD_DATE        AS ETD_DATE
				,      P.ETA_DATE        AS ETA_DATE
				,      NULL              AS SHIP_TYPE
				,	   P.BOD_ID			 AS BOD_ID	
				,	   P.ROUTE_ID		 AS ROUTE_ID
				FROM  PLAN_SSP P, PLAN_DAY_INFO A
				WHERE 1=1
				--AND	  P.YYYYMMDD BETWEEN  '20220101'  AND '20220131' 
				AND   P.YYYYMMDD BETWEEN A.BF_DATE  AND A.AT_DATE	


			UNION ALL 
				-- OWMS 실적 
				SELECT R.DIVISION_ID     AS DIVISION_ID
				,     'O'                AS TYPE 
				,      NULL              AS ERP_SO_NO
				,      NULL              AS CONFIRM_ID 
				,      R.ITEM_ID         AS ITEM_ID 
				,      R.FROM_SITE       AS FROM_SITE 
				,      R.TO_SITE         AS TO_SITE 
				,      NULL              AS END_CUSTOMER
				,      R.QTY             AS QTY 
				,      R.YYYYMMDD        AS YYYYMMDD 
				,      NULL              AS TRANSPORT_MODE
				,      NULL              AS INCOTERMS
				,      NULL              AS ETD_DATE
				,      NULL              AS ETA_DATE
				,      R.SHIP_TYPE       AS SHIP_TYPE
				,	   ''				 AS BOD_ID
				,	   ''				 AS ROUTE_ID
				FROM  RESULT_OWMS R
		
			UNION ALL
				-- OWMS 반품실적 
				SELECT R.DIVISION_ID     AS DIVISION_ID
				,      'R'		         AS TYPE 
				,      NULL              AS ERP_SO_NO
				,      NULL              AS CONFIRM_ID 
				,      R.ITEM_ID         AS ITEM_ID 
				,      R.FROM_SITE       AS FROM_SITE 
				,      R.TO_SITE         AS TO_SITE 
				,      NULL              AS END_CUSTOMER
				,      R.QTY             AS QTY 
				,      R.YYYYMMDD        AS YYYYMMDD 
				,      NULL              AS TRANSPORT_MODE
				,      NULL              AS INCOTERMS
				,      NULL              AS ETD_DATE
				,      NULL              AS ETA_DATE
				,      R.SHIP_TYPE       AS SHIP_TYPE
				,	   ''				 AS BOD_ID
				,	   ''				 AS ROUTE_ID
				FROM  RETURN_OWMS R
			) X
				JOIN SCM_MST_SITE MS WITH(NOLOCK) 
					ON MS.DIVISION_ID = X.DIVISION_ID 
					AND MS.SCM_SITE_ID = X.FROM_SITE  
					--AND MS.OPERATION_GROUP = 'E'
				JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
   					ON L.LOOKUP_TYPE = 'SSP_SHIPMENT_RESULT_TYPE' -- LOOKUP에 등록된 공정만 
					AND L.SEGMENT1 = X.TYPE 
					AND L.VALID_YN = 'Y'
				LEFT OUTER JOIN SSP_MST_MODEL_USER M WITH(NOLOCK) 
							ON  M.DIVISION_ID = X.DIVISION_ID 
							and M.FROM_SITE = X.FROM_SITE 
							and M.ITEM_ID = X.ITEM_ID 
							and M.VALID_YN = 'Y'
		),
		SSP_SEMI_FINAL AS
		(
			SELECT	DIVISION_ID, 
					COMPANY_ID, 
					CASE WHEN TYPE = 'Plan' THEN 'SSP_Plan' ELSE TYPE END AS TYPE, 
					ERP_SO_NO, 
					CONFIRM_ID, 
					ITEM_ID, 
					NICK_NAME, 
					FROM_SITE, 
					TO_SITE, 
					END_CUSTOMER, 
					QTY, YYYYMMDD, 
					TRANSPORT_MODE, 
					INCOTERMS, 
					ETD_DATE, 
					ETA_DATE, 
					SHIP_TYPE, 
					ISO_YYYYWW AS TARGET_WEEK,	
					CONCAT(MONTH_NAME,'-01') AS TARGET_MONTH,	
					BOD_ID,
					ROUTE_ID,
					C.PLAN_WEEK
			FROM	SSP_PLAN_RESULT A
					LEFT OUTER JOIN SCM_SYS_CALENDAR_M B ON A.YYYYMMDD = B.DATE_FULL_NAME
					, PLAN_INFO C	
		),
		SSP_FINAL AS
		(
		SELECT	DIVISION_ID,
				COMPANY_ID,
				TYPE,
				ERP_SO_NO,
				CONFIRM_ID,
				ITEM_ID,
				NICK_NAME,
				FROM_SITE,
				TO_SITE,
				END_CUSTOMER,
				TARGET_WEEK,
				TARGET_MONTH,
				YYYYMMDD, 
				--SUM(QTY) AS QTY,
				QTY,
				TRANSPORT_MODE,
				INCOTERMS,
				ETD_DATE,
				ETA_DATE,
				SHIP_TYPE,
				BOD_ID,
				ROUTE_ID,
				PLAN_WEEK
		FROM	SSP_SEMI_FINAL
		),
		FINAL AS
		(
			SELECT	A.*
			FROM	SSP_FINAL A
			UNION ALL
			SELECT	A.*, C.PLAN_WEEK
			FROM	SCP_FINAL A, PLAN_INFO C
		)


		INSERT INTO [dbo].[SCP_BI_SSP_RESULT_H]
					([DIVISION_ID]
					,[COMPANY_ID]
					,[TYPE]
					,[ERP_SO_NO]
					,[CONFIRM_ID]
					,[ITEM_ID]
					,[NICK_NAME]
					,[FROM_SITE]
					,[TO_SITE]
					,[END_CUSTOMER]
					,[YYYYMMDD]
					,[TARGET_WEEK]
					,[TARGET_MONTH]
					,[KPI_MONTH]
					,[TARGET_ST_DATE]
					,[PARTIAL_START_DATE]
					,[ORIGIN_QTY]
					,[TRANSPORT_MODE]
					,[INCOTERMS]
					,[ETD_DATE]
					,[ETA_DATE]
					,[SHIP_TYPE]
					,[BOD_ID]
					,[ROUTE_ID]
					,[PLAN_WEEK]
					,[PLAN_ST_DATE]
					,[MODEL]
					,[GROUP_CODE]
					,[ELECTRODE_TYPE]
					,[CONVERT_QTY_CELL]
					,[QTY]
					,[OPERATION_GROUP]
					,[OUTSOURCING_FROM_SITE]
					,[OUTSOURCING_TO_SITE]
					,[LOGISTIC_PLANT]
					,[FROM_COUNTRY]
					,[FROM_CITY]
					,[TRANSPORT_MODE_B]
					,[D_COUNTRY]
					,[D_PORT_CODE]
					,[D_PORT_NAME]
					,[A_COUNTRY]
					,[A_PORT_CODE]
					,[A_PORT_NAME]
					,[TO_COUNTRY]
					,[TO_CITY]
					,ENERGY_KWH
					,EXTRA_SPEC
					,ITEM_CLASS_NAME 
					,ITEM_TYPE		
					,[CREATED_BY]
					,[CREATION_DATE]
					,[LAST_UPDATED_BY]
					,[LAST_UPDATE_DATE])
			SELECT	A.DIVISION_ID,
					A.COMPANY_ID,
					TYPE,
					ERP_SO_NO,
					CONFIRM_ID,
					A.ITEM_ID,
					CASE WHEN (A.NICK_NAME IS NULL OR A.NICK_NAME = '') THEN J.NICK_NAME ELSE A.NICK_NAME END AS NICK_NAME,
					A.FROM_SITE,
					TO_SITE,
					A.END_CUSTOMER,
					A.YYYYMMDD, 
					TARGET_WEEK,
					TARGET_MONTH,
					KPI_MONTH,
					TARGET_ST_DATE,
					PARTIAL_START_DATE,
					QTY AS ORIGIN_QTY,
					A.TRANSPORT_MODE,
					INCOTERMS,
					ETD_DATE,
					ETA_DATE,
					SHIP_TYPE,
					A.BOD_ID,
					A.ROUTE_ID,
					PLAN_WEEK, 
					PLAN_ST_DATE,
					CASE WHEN A.DIVISION_ID IN ('40') THEN ISNULL(F.NICK_NAME, A.ITEM_ID)
							WHEN (A.DIVISION_ID IN ('81') OR A.DIVISION_ID LIKE '81_%') THEN ISNULL(F.GROUP_CODE2, A.ITEM_ID)
							WHEN A.DIVISION_ID IN ('82') THEN A.ITEM_ID
							ELSE A.ITEM_ID 
					END AS MODEL,
					E.DOE AS GROUP_CODE, 
					G.ELECTRODE_TYPE, 
					ISNULL(G.CONVERT_QTY_CELL, K.ACCUMULATED_CHILD_QTY) AS CONVERT_QTY_CELL,
					CASE WHEN G.ELECTRODE_TYPE = 'Pouch' THEN A.QTY * G.CONVERT_QTY_CELL
							ELSE A.QTY END AS QTY,
					CASE WHEN C.OPERATION_GROUP = 'P' THEN 'Pack' 
							WHEN C.OPERATION_GROUP = 'A' THEN 'Cell' 
							WHEN C.OPERATION_GROUP = 'E' THEN 'Electrode' 
							WHEN C.OPERATION_GROUP = 'W' THEN 'Warranty' 
							ELSE C.OPERATION_GROUP END AS OPERATION_GROUP, 
					C.OSP_YN AS OUTSOURCING_FROM_SITE, 
					ISNULL(H.OSP_YN,'N') AS OUTSOURCING_TO_SITE, 
					D.PLANT_NAME AS LOGISTIC_PLANT,
					B.FROM_COUNTRY, 
					B.FROM_CITY, 
					B.TRANSPORT_MODE AS TRANSPORT_MODE_B, 
					B.D_COUNTRY, 
					B.D_PORT_CODE, 
					B.D_PORT_NAME, 
					B.A_COUNTRY, 
					B.A_PORT_CODE, 
					B.A_PORT_NAME, 
					B.TO_COUNTRY, 
					B.TO_CITY,
					J.ENERGE AS ENERGY_KWH, 
					E.EXTRA_SPEC,
					J.ITEM_CLASS_NAME, 
					CASE WHEN J.ITEM_TYPE = 'P' THEN 'Product' 
							WHEN J.ITEM_TYPE = 'H' THEN 'Semi Product' 
							WHEN J.ITEM_TYPE = 'Q' THEN 'Purchase' 
							WHEN J.ITEM_TYPE = 'R' THEN 'Material' 
							ELSE J.ITEM_TYPE
					END AS ITEM_TYPE,
					@v_batch_user,
					getdate(),
					@v_batch_user,
					getdate()
			FROM	FINAL A
					LEFT OUTER JOIN LT B ON A.BOD_ID = B.BOD_ID AND A.ROUTE_ID = B.ROUTE_ID
					LEFT OUTER JOIN SCM_MST_SITE C  with(nolock) ON A.FROM_SITE = C.SITE_DESCRIPTION AND A.DIVISION_ID = C.DIVISION_ID AND C.SITE_TYPE = 'PLANT' AND C.VALID_YN = 'Y'
					LEFT OUTER JOIN SCM_MST_SITE H  with(nolock) ON A.TO_SITE = H.SITE_DESCRIPTION AND A.DIVISION_ID = H.DIVISION_ID AND H.SITE_TYPE = 'PLANT' AND H.VALID_YN = 'Y'
					LEFT OUTER JOIN SCM_MST_PLANT_SN D  with(nolock) ON C.LOGISTIC_PLANT_ID = D.PLANT_ID AND C.DIVISION_ID = D.DIVISION_ID
					LEFT OUTER JOIN GROUP_CODE E ON A.DIVISION_ID = E.DIVISION_ID AND A.ITEM_ID = E.ITEM_ID
					LEFT OUTER JOIN SCP_MST_FINAL_ITEM_VIEW F ON A.DIVISION_ID = F.DIVISION_ID AND A.ITEM_ID = F.ITEM_ID
					LEFT OUTER JOIN ELEC_CONVERT_QTY_CELL G ON A.DIVISION_ID = G.DIVISION_ID AND A.ITEM_ID = G.ITEM_ID 
					LEFT OUTER JOIN PLAN_DATE_INFO I ON A.TARGET_WEEK = I.ISO_YYYYWW AND A.TARGET_MONTH = CONCAT(I.MONTH_NAME,'-01')
					LEFT OUTER JOIN MODEL_TYPE J ON A.DIVISION_ID = J.DIVISION_ID AND A.ITEM_ID = J.ITEM_ID
					LEFT OUTER JOIN MODEL_BOM K ON A.DIVISION_ID = K.DIVISION_ID AND A.ITEM_ID = K.MODEL_ID 
			WHERE	1=1
	

		PRINT '-------------Step 1 Inserted : ' +  CONVERT(CHAR(23), getdate(), 21)

		------------------------------------------------------------------------------------------------------------- 
		-- 2. 구간 
		-- 
		-- 
		------------------------------------------------------------------------------------------------------------- 
		SET @v_from_yyyymmdd		= convert(nvarchar, convert(INT, substring(@v_basis_yyyymmdd,1,4)) -1) + '0101';
		SET @v_mid_yyyymmdd         = convert(nvarchar, convert(datetime, @v_basis_yyyymmdd) - 90,112);
		SET @v_to_yyyymmdd			= @v_basis_yyyymmdd;

		DELETE FROM [dbo].[SCP_BI_SSP_RESULT_H]
		WHERE plan_week = '999952'
		AND (yyyymmdd < @v_from_yyyymmdd OR yyyymmdd >= @v_mid_yyyymmdd)
		;
		PRINT '-------------Step 2 Deleted : ' +  CONVERT(CHAR(23), getdate(), 21) ;

		WITH PLAN_INFO AS
		(
			SELECT	'999952'	AS PLAN_WEEK,				-- 하드코딩
					'99991231'	AS PLAN_START_YYYYMMDD,		-- 하드코딩
					'9999-12-31'AS PLAN_ST_DATE				-- 하드코딩
		),	
		PLAN_DAY_INFO AS
		( 
			SELECT	@v_mid_yyyymmdd		AS BF_DATE,			-- 당일 기준 작년 1월 부터 -> 성능 이슈로 90일 전 부터 (그 이전 데이터는 보존)
					@v_to_yyyymmdd		AS AT_DATE			-- 당일 
		),
		PLAN_DATE_INFO AS 
		(
			SELECT	C.PLAN_ST_DATE, A.MONTH_NAME, A.ISO_YYYYWW, CONCAT(CONCAT(A.MONTH_NAME,'-'), SUBSTRING(A.BASIS_START_DATE,7,2)) AS PARTIAL_START_DATE, B.BASIS_DATE AS TARGET_ST_DATE, CONCAT(D.KPI_MONTH,'-01') AS KPI_MONTH
			FROM	DBO.SCM_SYS_CALENDAR_M A
					LEFT OUTER JOIN (
									SELECT	ISO_YYYYWW, CONVERT(CHAR(10), BASIS_DATE, 23) AS BASIS_DATE
									FROM	DBO.SCM_SYS_CALENDAR_M  with(nolock)
									WHERE	1=1
									AND		DAYOFWEEK = 'MON'				
									) B ON A.ISO_YYYYWW = B.ISO_YYYYWW
					LEFT OUTER JOIN (
									SELECT	ISO_YYYYWW, CALENDAR_YYYY+'-'+CALENDAR_MONTH AS KPI_MONTH
									FROM	DBO.SCM_SYS_CALENDAR_M  with(nolock)
									WHERE	1=1
									AND		DAYOFWEEK = 'THU'					
									) D ON A.ISO_YYYYWW = D.ISO_YYYYWW
					, PLAN_INFO C
			WHERE	1=1
			AND		A.END_FLAG = 'Y'
		),
		PLAN_SEQ_INFO AS
		(
			SELECT	DISTINCT 
					DIVISION_ID,					-- DIVISION_ID
					PLAN_TYPE,						-- PLAN_TYPE
					MAX(SEQ) AS SEQ					-- 버전 별 최종 SEQ
			FROM	SCP_ANL_SHIPMENT_PLAN_FG A  with(nolock), PLAN_INFO B
			WHERE	1=1
			AND		A.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD
			AND		(DIVISION_ID IN ('81','82','40','EE') OR DIVISION_ID LIKE '81_%')
			AND		PLAN_TYPE = 'FN'
			GROUP	BY DIVISION_ID, PLAN_TYPE	
		),
		LT AS
		(
			--SELECT	BOD_ID, A.ROUTE_ID, TRANSPORT_MODE, (LT_DEPARTURE_INLAND + LT_WAIT_SHIPPING + LT_VOYAGE + LT_LAY_OFF_CLEARANCE + LT_ARRIVAL_INLAND) AS LT
			SELECT	BOD_ID, A.ROUTE_ID, (LT_DEPARTURE_INLAND + LT_WAIT_SHIPPING + LT_VOYAGE + LT_LAY_OFF_CLEARANCE + LT_ARRIVAL_INLAND) AS LT, 
					B.FROM_COUNTRY, B.FROM_CITY, B.TRANSPORT_MODE, B.D_COUNTRY, B.D_PORT_CODE, B.D_PORT_NAME, B.A_COUNTRY, B.A_PORT_CODE, B.A_PORT_NAME, B.TO_COUNTRY, B.TO_CITY
			FROM	SCP_MST_BOD A  with(nolock), SCP_MST_DISTRIBUTION_ROUTE B  with(nolock)
			WHERE	1=1
			AND		A.ROUTE_ID = B.ROUTE_ID
		),
		-- ■ 마스터 데이터 집계 시작
		MODEL_TYPE AS
		(
			-- 자동차 MODEL_TYPE LIST
			SELECT	C.*,
					CASE WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND CHARINDEX('Cell', C.ITEM_CLASS_NAME) > 0) THEN 'Cell'
							WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND CHARINDEX('Module', C.ITEM_CLASS_NAME) > 0) THEN 'Module'
							WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND  CHARINDEX('Pack'  , C.ITEM_CLASS_NAME) > 0) THEN 'Pack'
					ELSE C.FORECAST_INFO_BIZ_TYPE END AS MODEL_TYPE,
					CASE WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND CHARINDEX('Cell', C.ITEM_CLASS_NAME) > 0) THEN 'Cell'
							WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND CHARINDEX('Module', C.ITEM_CLASS_NAME) > 0) THEN 'Module'
							WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND  CHARINDEX('Pack'  , C.ITEM_CLASS_NAME) > 0) THEN 'Pack'
					ELSE C.FORECAST_INFO_BIZ_TYPE END AS ORI_MODEL_TYPE
			FROM	DM_MST_ITEM_SINGLE_V C
			WHERE	1=1
			AND		(DIVISION_ID = '81' OR DIVISION_ID LIKE '81_%')
			--AND		ITEM_TYPE = 'P'
			AND		ACTIVE_FLAG = 'Y'		
			AND		SUBSTRING(ITEM_ID,1,2) IN ('AC','AM','AP')	-- 자동차 완제품 기준
			UNION ALL
			-- ESS MODEL_TYPE LIST
			SELECT	C.*, 
					CASE WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND CHARINDEX('Cell', C.ITEM_CLASS_NAME) > 0) THEN 'Cell'
								WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND CHARINDEX('Module', C.ITEM_CLASS_NAME) > 0) THEN 'Module'
								WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND  CHARINDEX('House'  , C.ITEM_CLASS_NAME) > 0) THEN 'Pack'
								WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND  CHARINDEX('Rack'  , C.ITEM_CLASS_NAME) > 0) THEN 'Pack'
						ELSE C.FORECAST_INFO_BIZ_TYPE END AS MODEL_TYPE,
					CASE WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND CHARINDEX('Cell', C.ITEM_CLASS_NAME) > 0) THEN 'CELL'
								WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND CHARINDEX('Module', C.ITEM_CLASS_NAME) > 0) THEN 'Module'
								WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND  CHARINDEX('House'  , C.ITEM_CLASS_NAME) > 0) THEN 'House'
								WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND  CHARINDEX('Rack'  , C.ITEM_CLASS_NAME) > 0) THEN 'Rack'
						ELSE C.FORECAST_INFO_BIZ_TYPE END AS ORI_MODEL_TYPE
			FROM	DM_MST_ITEM_SINGLE_V C
			WHERE	1=1
			AND		DIVISION_ID = '82'
			--AND		ITEM_TYPE = 'P'
			AND		ACTIVE_FLAG = 'Y'
			AND		SUBSTRING(ITEM_ID,1,1) IN ('E','M','A') -- ESS 완제품 기준
			UNION ALL
			-- 소형 MODEL_TYPE LIST
			SELECT	C.*, 
					CASE WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND CHARINDEX('Cell', C.ITEM_CLASS_NAME) > 0) THEN 'Cell'
							WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND CHARINDEX('Module', C.ITEM_CLASS_NAME) > 0) THEN 'Module'
							WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND  CHARINDEX('Pack'  , C.ITEM_CLASS_NAME) > 0) THEN 'Pack'
					ELSE C.FORECAST_INFO_BIZ_TYPE END AS MODEL_TYPE, 
					CASE WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND CHARINDEX('Cell', C.ITEM_CLASS_NAME) > 0) THEN 'Cell'
							WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND CHARINDEX('Module', C.ITEM_CLASS_NAME) > 0) THEN 'Module'
							WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND  CHARINDEX('Pack'  , C.ITEM_CLASS_NAME) > 0) THEN 'Pack'
					ELSE C.FORECAST_INFO_BIZ_TYPE END AS ORI_MODEL_TYPE
			FROM	DM_MST_ITEM_SINGLE_V C
			WHERE	1=1
			AND		DIVISION_ID = '40'
			--AND		ITEM_TYPE = 'P'
			AND		ACTIVE_FLAG = 'Y'
			AND		SUBSTRING(ITEM_ID,1,1) IN ('M','E','A') -- 소형 완제품 기준	
		),
		MODEL_BOM AS
		(
			SELECT	DIVISION_ID, MODEL_ID, OPERATION_GROUP_ID, ROUND(AVG(ACCUMULATED_CHILD_QTY),1) AS ACCUMULATED_CHILD_QTY
			FROM	DBO.SCM_MST_MODEL_FINAL_ITEM_BOM_V A WITH (NOLOCK),
					(
					SELECT	DISTINCT ITEM_ID
					FROM	SCP_MST_FINAL_ITEM  with(nolock)
					WHERE	1=1
					AND		OPERATION_GROUP = 'A'
					) B
			WHERE	1=1
			AND		A.OPERATION_GROUP_ID = 'A'	
			AND		A.CHILD_ITEM_ID = B.ITEM_ID
			GROUP	BY DIVISION_ID, MODEL_ID, OPERATION_GROUP_ID
		),
		SCP_MST_FINAL_ITEM_VIEW AS
		(
			SELECT	A.*, B.SEGMENT2 
			FROM	SCP_MST_FINAL_ITEM A  with(nolock)
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B  with(nolock)
					ON A.CELL_TYPE_GROUP_CODE = B.SEGMENT1 AND B.LOOKUP_TYPE = 'CELL_TYPE_GROUP_CODE' AND B.VALID_YN = 'Y'
			WHERE	1=1
		),
		END_CUSTOMER AS
		(
			-- 고객사 Logic : 1) SITE, PROJECT 둘다 매핑되는 고객사 셋팅 2) 1에서 NULL 나오는 CASE는 SITE만 있으면 매핑 3) 그래도 매핑 안되는 case는 'NULL_Site' 정보 제공
			SELECT	DISTINCT 
					A.DIVISION_ID, 
					A.PROJECT_CODE, 
					A.SCM_SITE_ID, 
					A.ITEM_ID, 
					A.CELL_PER_CAR,
					A.CELL_PER_MODULE,
					-- 40에서 APPLICATION으로 CATEGORY 구분함(EX> 노트북 등..)
					A.CUST_GROUP, 
					A.CUST_GROUP_DTL, 
					A.APPLICATION,
					A.CELL_MODEL, 
					A.PRODUCT_GROUP,
					CASE WHEN A.DIVISION_ID = '40' THEN D.DEPT_NAME_KO
							ELSE C.DEPT_NAME_KO END AS DEPT_NAME_KO,
					A.VMI_YN,
					-- 40은 PROJECT_CODE가 END_CUSTOMER임.
					CASE WHEN A.DIVISION_ID = '40' THEN A.PROJECT_CODE 
							ELSE (CASE WHEN A.END_CUSTOMER IS NULL THEN B.END_CUSTOMER ELSE A.END_CUSTOMER END) END AS END_CUSTOMER
					---CASE WHEN A.END_CUSTOMER IS NULL THEN B.END_CUSTOMER ELSE A.END_CUSTOMER END AS END_CUSTOMER
			FROM	(
					SELECT	DISTINCT A.DIVISION_ID, 
							A.PROJECT_CODE, 
							A.SCM_SITE_ID, 
							A.ITEM_ID, 
							B.END_CUSTOMER, 
							A.CELL_PER_CAR, 
							A.CELL_PER_MODULE, 
							A.CUST_GROUP, 
							A.CUST_GROUP_DTL, 
							A.APPLICATION, 
							A.ATTRIBUTE5 AS CELL_MODEL, 
							A.REPORT_GROUP3 AS PRODUCT_GROUP,
							B.VMI_YN,
							-- 81, 82의 경우 DEPT_ID는 PROJECT 정보를(SCM_MST_SITE에서) 참조하나, 40인 경우에는 OWNER의 부서정보를 참조함(공용화모델 CASE로 중복 발생 때문)
							B.DEPT_ID AS DEPT_ID,	-- 81, 82
						(	SELECT SU.DEPT_ID  
							FROM SCM_MST_SSO_USER_INFO SU WITH (NOLOCK)
							WHERE SU.USER_ID = (SELECT top 1 token FROM [dbo].[String_Split](A.owner, ',')) ) DEPT_ID_SMALL  -- 40
					FROM	SCM_MST_SITE_ITEM A  with(nolock), SCM_MST_SITE B  with(nolock)
					WHERE	1=1
					AND		A.DIVISION_ID = B.DIVISION_ID
					AND		A.SCM_SITE_ID = B.SCM_SITE_ID
					-- 주석 처리한 이유 : 과거 계획/실적을 조회할 수 있으므로...
					--AND		A.VALID_YN = 'Y'
					--AND		B.VALID_YN = 'Y'	
					) A 
					LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO C  with(nolock) ON A.DEPT_ID = C.DEPT_ID
					LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO D  with(nolock) ON A.DEPT_ID_SMALL = D.DEPT_ID
					, SCM_MST_SITE B
			WHERE	1=1
			AND		A.SCM_SITE_ID = B.SCM_SITE_ID
			AND		A.DIVISION_ID = B.DIVISION_ID
			--AND		B.VALID_YN = 'Y'
		),
		END_CUSTOMER_2 AS
		(
			SELECT	DISTINCT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, END_CUSTOMER
			FROM	END_CUSTOMER 
			WHERE	1=1
			AND		(DIVISION_ID IN ('40','81','82') OR DIVISION_ID LIKE '81_%')
		),
		GROUP_CODE AS
		(
			SELECT	DISTINCT DIVISION_ID, ITEM_ID, DOE, MAX(SCP_EXTRA_SPEC) AS EXTRA_SPEC
			FROM	[dbo].[SCM_MST_ITEM_SN]  with(nolock)
			WHERE	1=1
			AND		ITEM_TYPE = 'P'	
			GROUP	BY DIVISION_ID, ITEM_ID, DOE
		),
		ELEC_CONVERT_QTY_CELL AS
		(
		SELECT	DISTINCT A.DIVISION_ID, A.ITEM_ID, A.OPERATION_GROUP, A.CELL_ITEM_ID, 
				CASE WHEN A.DIVISION_ID NOT IN ('40') THEN 'Pouch' ELSE B.SEGMENT2 END AS ELECTRODE_TYPE, A.CONVERT_QTY_CELL
		FROM	SCP_MST_FINAL_ITEM A  with(nolock)
				LEFT OUTER JOIN 
				(
				SELECT	DISTINCT DIVISION_ID, ITEM_ID, B.SEGMENT2
				FROM	SCP_MST_FINAL_ITEM A  with(nolock)
						LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B  with(nolock) ON A.CELL_TYPE_GROUP_CODE = B.SEGMENT1 AND B.LOOKUP_TYPE = 'CELL_TYPE_GROUP_CODE' AND B.VALID_YN = 'Y'
				WHERE	1=1
				AND		OPERATION_GROUP <> 'E'		
				) B ON A.DIVISION_ID = B.DIVISION_ID AND A.CELL_ITEM_ID = B.ITEM_ID
		WHERE	1=1
		AND		OPERATION_GROUP = 'E'
		),

		---- SSP + 출하실적 시작
		RESULT_ERP_C_EXIST AS 
		(
			-- ERP 출하실적에서 CONFIRM_ID 존재, SSP_TYPE 대상 
			SELECT  E.DIVISION_ID             AS DIVISION_ID
			,       E.CONFIRM_ID              AS CONFIRM_ID
			,       E.ORDER_NO				  AS ERP_SO_NO 
			,       E.EXFACTORY_DATE          AS YYYYMMDD
			,       E.TRANSPORT_MODE		  AS TRANSPORT_MODE
			,       E.INCOTERMS				  AS INCOTERMS
			,		E.ETA_DATE				  AS ETA_DATE
			,		E.ETD_DATE				  AS ETD_DATE
			,		E.FROM_SCM_SITE_ID		  AS FROM_SITE
			,		E.TO_SCM_SITE_ID		  AS TO_SITE
			,		E.ITEM_ID				  AS ITEM_ID
			,       SUM(E.EXFACTORY_QTY )     AS RESULT_QTY 
			FROM [DBO].[SCM_DNM_EXFACTORY_RESULT] E WITH(NOLOCK)
				JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
					ON L.LOOKUP_TYPE = 'ERP_SSP_TYPE' -- LOOKUP에 등록된 공정만 
				AND L.VALID_YN = 'Y'
				AND L.SEGMENT1    = E.SSP_TYPE
			JOIN SCM_MST_SITE AS S WITH(NOLOCK)					 
				ON E.FROM_SCM_SITE_ID	= S.SCM_SITE_ID				 
			   AND E.DIVISION_ID	= S.DIVISION_ID				 
			   AND S.SITE_TYPE		= 'PLANT'					 				 
			JOIN SCM_MST_ITEM_SN AS T WITH(NOLOCK)				 
				ON E.ITEM_ID		= T.ITEM_ID					 
			   AND E.DIVISION_ID	= T.DIVISION_ID				 
			   AND S.COMPANY_ID		= T.COMPANY_ID				 
			   AND T.ITEM_TYPE		NOT IN ('Q','R')
				, PLAN_DAY_INFO A
			WHERE 1=1
			AND   ISNULL(E.EXFACTORY_STATUS,'D90') NOT IN ('D90' ,'D10') -- D90: DO삭제 , D10:DO생성 
			AND   E.CONFIRM_ID LIKE 'C%'
			--AND   E.EXFACTORY_DATE BETWEEN '20220101'  AND '20220131' 
			AND   E.EXFACTORY_DATE BETWEEN A.BF_DATE  AND A.AT_DATE
		
				
			GROUP BY E.DIVISION_ID 
			,        E.CONFIRM_ID
			,        E.ORDER_NO
			,        E.EXFACTORY_DATE
			,        E.TRANSPORT_MODE
			,        E.INCOTERMS		
			,		 E.ETA_DATE		
			,		 E.ETD_DATE
			,		 E.FROM_SCM_SITE_ID	
			,		 E.TO_SCM_SITE_ID	
			,		 E.ITEM_ID
			)
		, RESULT_ERP_C_NON AS 
		(
			-- ERP 출하실적에서 CONFIRM_ID 없는 실적 
			SELECT  E.DIVISION_ID             AS DIVISION_ID
			,       '-'                       AS CONFIRM_ID
			,       E.ORDER_NO				  AS ERP_SO_NO 
			,       E.FROM_SCM_SITE_ID        AS FROM_SITE                                                                    
			,       ISNULL(L3.SEGMENT4, E.TO_SCM_SITE_ID)     AS TO_SITE   
			,       E.ITEM_ID                 AS ITEM_ID
			,       E.EXFACTORY_DATE          AS YYYYMMDD
			,       E.TRANSPORT_MODE		  AS TRANSPORT_MODE
			,       E.INCOTERMS				  AS INCOTERMS
			,		E.ETA_DATE				  AS ETA_DATE
			,		E.ETD_DATE				  AS ETD_DATE
			,       SUM(E.EXFACTORY_QTY )     AS QTY  
			FROM [DBO].[SCM_DNM_EXFACTORY_RESULT] E WITH(NOLOCK)
			JOIN SCM_MST_SITE AS S WITH(NOLOCK)					 
				ON E.FROM_SCM_SITE_ID	= S.SCM_SITE_ID				 
			   AND E.DIVISION_ID	= S.DIVISION_ID				 
			   AND S.SITE_TYPE		= 'PLANT'					 				 
			JOIN SCM_MST_ITEM_SN AS T WITH(NOLOCK)				 
				ON E.ITEM_ID		= T.ITEM_ID					 
			   AND E.DIVISION_ID	= T.DIVISION_ID				 
			   AND S.COMPANY_ID		= T.COMPANY_ID				 
			   AND T.ITEM_TYPE		NOT IN ('Q','R')
			JOIN  SCP_MST_FINAL_ITEM F WITH(NOLOCK) -- SCP 대상 ITEM만 
				ON F.ITEM_ID = E.ITEM_ID 
				AND F.DIVISION_ID = E.DIVISION_ID
			JOIN   SCM_MST_SITE FS WITH(NOLOCK)
				ON FS.SCM_SITE_ID = E.FROM_SCM_SITE_ID 
				AND FS.DIVISION_ID = E.DIVISION_ID 
				-- AND ISNULL(FS.OSP_YN,'N') <> 'Y' --- [C20200121-000352]-2 : FROM_SITE PACKER포함(OSP_YN <> 'Y' 조건제외)
			-- 2020.09.18 김광희 책임 요청으로 주석처리
			-- 2021.04.15 김광희 책임 요청으로 주석해제
			JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
				ON L.LOOKUP_TYPE = 'ERP_ORDER_TYPE' -- LOOKUP에 등록된 ORDER_TYPE만 대상으로 함 
			AND L.VALID_YN = 'Y'
			AND L.SEGMENT1    = E.ORDER_TYPE_CODE 	
			LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L3 WITH(NOLOCK)
					ON L3.LOOKUP_TYPE = 'SHIP_RESULT_TO_SITE_MAPPING' --SOLDTO, SHIPTO 과 MAPPING되는 TO_SITE 
				AND L3.SEGMENT1    = E.DIVISION_ID 
				AND L3.SEGMENT2    = E.SOLDTO_CODE
				AND L3.SEGMENT3    = E.SHIPTO_CODE	
				, PLAN_DAY_INFO A				    
			WHERE 1=1
			AND   ISNULL(E.EXFACTORY_STATUS,'D90') NOT IN ('D90' ,'D10') -- D90: DO삭제 , D10:DO생성 
			AND   ISNULL(E.CONFIRM_ID,'') NOT LIKE  'C%'
			--AND   E.EXFACTORY_DATE BETWEEN  '20220101'  AND '20220131' 
			AND   E.EXFACTORY_DATE BETWEEN A.BF_DATE  AND A.AT_DATE
		
			--[C20210330-000402]
			--AND   E.FROM_SCM_SITE_ID IS NOT NULL 
			--AND   E.TO_SCM_SITE_ID IS NOT NULL 
			AND   E.STORAGE_ID NOT IN ('6000' ,'799A') --상품창고제외 
			--[C20200403-000062]
			AND   E.STORAGE_ID NOT IN (SELECT SEGMENT1 
									FROM SCM_ADM_LOOKUP_MASTER_DETAIL 
									WHERE LOOKUP_TYPE = 'SSP_SHIP_RESULT_EXCEPT_STORAGE'
										AND VALID_YN = 'Y'
									)	-- 사외 창고 제외 LOOKUP 관리
			--AND   E.ORDER_TYPE_CODE  IN ('ZEF','ZEFC','ZEML','ZEMM','ZEX','ZFD','ZFR','ZKB','ZMM','ZOR','ZFDC','ZKM') -- 해당 ORDER_TYPE만 대상으로 함 

			GROUP BY E.DIVISION_ID
			,        E.ORDER_NO
			,        E.FROM_SCM_SITE_ID                                                                           
			,        ISNULL(L3.SEGMENT4, E.TO_SCM_SITE_ID) 
			,        E.ITEM_ID
			,        E.EXFACTORY_DATE
			,        E.TRANSPORT_MODE
			,        E.INCOTERMS		
			,		 E.ETA_DATE		
			,		 E.ETD_DATE
			,		 E.FROM_SCM_SITE_ID	
			,		 E.TO_SCM_SITE_ID	
		)
		, PLAN_SSP AS  
		(   -- SSP출하계획 ( confirm된 계획) - Current Version
			SELECT C.DIVISION_ID    AS DIVISION_ID
			,      C.ERP_SO_NO      AS ERP_SO_NO
			,      C.CONFIRM_ID     AS CONFIRM_ID 
			,      C.ITEM_ID        AS ITEM_ID 
			,      C.FROM_SITE      AS FROM_SITE 
			,      C.TO_SITE        AS TO_SITE 
			,      CASE WHEN C.DIVISION_ID= '4O' THEN ISNULL(SI.PROJECT_CODE,'-')    
						ELSE ISNULL(TS.END_CUSTOMER,'-')  END         AS END_CUSTOMER  
			,      C.QTY            AS QTY 
			,      C.YYYYMMDD       AS YYYYMMDD 
			,      C.TRANSPORT_MODE AS TRANSPORT_MODE
			,      C.INCOTERMS      AS INCOTERMS
			,      C.ETD_DATE       AS ETD_DATE
			,      C.ETA_DATE       AS ETA_DATE
			,	   NULL				AS SHIP_TYPE
			,	   C.BOD_ID         AS BOD_ID		
			,	   C.ROUTE_ID       AS ROUTE_ID
			FROM [DBO].[SSP_ANL_SHIP_CONFIRM] C WITH(NOLOCK)	--SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK) 
			JOIN SCM_MST_SITE AS S WITH(NOLOCK)					 
				ON C.FROM_SITE		= S.SCM_SITE_ID				 
			   AND C.DIVISION_ID	= S.DIVISION_ID				 
			   AND S.SITE_TYPE		= 'PLANT'					 				 
			JOIN SCM_MST_ITEM_SN AS T WITH(NOLOCK)				 
				ON C.ITEM_ID		= T.ITEM_ID					 
				AND C.DIVISION_ID	= T.DIVISION_ID				 
				AND S.COMPANY_ID		= T.COMPANY_ID				 
				AND T.ITEM_TYPE		NOT IN ('Q','R')
			LEFT OUTER JOIN [dbo].[SCM_MST_SITE_ITEM] SI WITH(NOLOCK)	--SCM_MST_SITE_ITEM SI WITH(NOLOCK) 
						ON SI.DIVISION_ID = C.DIVISION_ID
						AND SI.ITEM_ID     = C.ITEM_ID 
						AND SI.SCM_SITE_ID = C.TO_SITE
						AND SI.PROJECT_CODE = C.PROJECT_CODE 
 			LEFT OUTER JOIN [dbo].[SCM_MST_SITE] TS WITH(NOLOCK)	--SCM_MST_SITE TS WITH(NOLOCK) 
						ON TS.DIVISION_ID = C.DIVISION_ID
						AND TS.SCM_SITE_ID = C.TO_SITE 
			WHERE CHANGE_TYPE = 'C'
			AND   QTY > 0 

			UNION ALL
			SELECT C.DIVISION_ID    AS DIVISION_ID
			,      ''				AS ERP_SO_NO
			,      ''				AS CONFIRM_ID 
			,      C.ITEM_ID        AS ITEM_ID 
			,      C.PLANT_SITE_ID      AS FROM_SITE 
			,      C.SCM_SITE_ID        AS TO_SITE 
			,      CASE WHEN C.DIVISION_ID= '4O' THEN ISNULL(SI.PROJECT_CODE,'-')    
						ELSE ISNULL(TS.END_CUSTOMER,'-')  END         AS END_CUSTOMER  
			,      C.QTY            AS QTY 
			,      C.YYYYMMDD       AS YYYYMMDD 
			,      C.TRANSPORT_MODE AS TRANSPORT_MODE
			,      C.INCOTERMS      AS INCOTERMS
			,      C.YYYYMMDD       AS ETD_DATE
			,      CONVERT(VARCHAR(8),CONVERT(DATETIME,[dbo].[FN_GET_SSP_ETA_DATE](C.DIVISION_ID, C.BOD_ID, C.YYYYMMDD) ,112), 112) AS ETA_DATE     
			,	   NULL				AS SHIP_TYPE
			,	   C.BOD_ID         AS BOD_ID		
			,	   ''       AS ROUTE_ID
			FROM [DBO].[DM_PLN_SHIPMENT_REQ] C WITH(NOLOCK)	--SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK) 
			JOIN SCM_MST_SITE AS S WITH(NOLOCK)					 
				ON C.PLANT_SITE_ID		= S.SCM_SITE_ID				 
				AND C.DIVISION_ID	= S.DIVISION_ID				 
				AND S.SITE_TYPE		= 'PLANT'					 				 
			JOIN SCM_MST_ITEM_SN AS T WITH(NOLOCK)				 
				ON C.ITEM_ID		= T.ITEM_ID					 
				AND C.DIVISION_ID	= T.DIVISION_ID				 
				AND S.COMPANY_ID		= T.COMPANY_ID				 
				AND T.ITEM_TYPE		NOT IN ('Q','R')
			LEFT OUTER JOIN [dbo].[SCM_MST_SITE_ITEM] SI WITH(NOLOCK)	--SCM_MST_SITE_ITEM SI WITH(NOLOCK) 
						ON SI.DIVISION_ID = C.DIVISION_ID
						AND SI.ITEM_ID     = C.ITEM_ID 
						AND SI.SCM_SITE_ID = C.SCM_SITE_ID
						AND SI.PROJECT_CODE = C.PROJECT_CODE 
			LEFT OUTER JOIN [dbo].[SCM_MST_SITE] TS WITH(NOLOCK)	--SCM_MST_SITE TS WITH(NOLOCK) 
						ON TS.DIVISION_ID = C.DIVISION_ID
						AND TS.SCM_SITE_ID = C.SCM_SITE_ID 
			WHERE 1=1
			AND   QTY > 0 
			AND	  C.YYYYMMDD >= CASE WHEN isnull(S.ship_frozen,0) > 0 THEN CONVERT(CHAR(8), DATEADD(DD, isnull(S.ship_frozen,0), CONVERT(VARCHAR, '' + CONVERT(CHAR(8), GETDATE(), 112) + '', 121)), 112) ELSE '' + CONVERT(CHAR(8), GETDATE(), 112) + '' END
		)
		, RESULT_OWMS AS
		(
			-- owms 출하실적
			SELECT A.DIVISION_ID       AS DIVISION_ID 
			,      A.ITEM_ID           AS ITEM_ID 
			,      A.FROM_SITE         AS FROM_SITE
			,      CASE WHEN A.TO_SITE ='-' THEN A.CUSTOMER_CODE ELSE  A.TO_SITE END          AS TO_SITE
			,      SUM(A.LOT_QTY)            AS QTY 
			,      A.PLANT_ISSUE_DATE  AS YYYYMMDD
			,	   A.SHIP_TYPE AS SHIP_TYPE
			FROM SSP_DNM_SHIP_RESULT_OWMS A WITH(NOLOCK), PLAN_DAY_INFO C
			WHERE 1=1
			AND		A.PLANT_ISSUE_DATE BETWEEN C.BF_DATE  AND C.AT_DATE
			--A.PLANT_ISSUE_DATE BETWEEN  @p_from_yyyymmdd  AND @p_to_yyyymmdd 
			GROUP BY A.DIVISION_ID        
			,        A.ITEM_ID      
			,        A.FROM_SITE   
			,        CASE WHEN A.TO_SITE ='-' THEN A.CUSTOMER_CODE ELSE A.TO_SITE  END  
			,        A.PLANT_ISSUE_DATE  
			,		 A.SHIP_TYPE
		)

		, RETURN_OWMS AS
		(
			-- owms 출하 반품
			SELECT B.DIVISION_ID      AS DIVISION_ID 
			,      B.ITEM_ID          AS ITEM_ID 
			,      B.FROM_SITE        AS FROM_SITE
			,      '*'                AS TO_SITE 
			,      SUM(B.RECIEPT_QTY) AS QTY 
			,      B.RECIEPT_DATE     AS YYYYMMDD 
			,	   NULL AS SHIP_TYPE
			FROM SSP_DNM_SHIP_RETURN_OWMS B WITH(NOLOCK), PLAN_DAY_INFO C
			WHERE 1=1
			AND		B.RECIEPT_DATE BETWEEN C.BF_DATE  AND C.AT_DATE
			GROUP BY B.DIVISION_ID        
			,        B.ITEM_ID      
			,        B.FROM_SITE   
			,        B.RECIEPT_DATE 
		
		)
		, SSP_PLAN_RESULT AS
		(
			SELECT X.DIVISION_ID
			,      MS.COMPANY_ID AS COMPANY_ID
			,      L.SEGMENT2  AS TYPE 
			,	   X.ERP_SO_NO
			,      X.CONFIRM_ID 
			,      X.ITEM_ID 
			,      DBO.FN_GET_ITEM_NICKNAME(X.DIVISION_ID, X.ITEM_ID) AS NICK_NAME
			--,      X.FROM_SITE 
			--,      X.TO_SITE
			,      ISNULL(dbo.FN_GET_SCM_SITE_DESCRIPTION(X.DIVISION_ID,X.FROM_SITE),X.FROM_SITE)   AS FROM_SITE 
			,      ISNULL(dbo.FN_GET_SCM_SITE_DESCRIPTION(X.DIVISION_ID,X.TO_SITE),X.TO_SITE)       AS TO_SITE 
			,      X.END_CUSTOMER  
			,      X.QTY 
			,      CONVERT(VARCHAR(10),   CONVERT(DATETIME, X.YYYYMMDD,112), 23) AS YYYYMMDD 
			,      X.TRANSPORT_MODE
			,      X.INCOTERMS
			,      CONVERT(VARCHAR(10),   CONVERT(DATETIME, X.ETD_DATE,112), 23) AS ETD_DATE
			,      CONVERT(VARCHAR(10),   CONVERT(DATETIME, X.ETA_DATE,112), 23) AS ETA_DATE
			,	   X.SHIP_TYPE
			,	   X.BOD_ID
			,	   X.ROUTE_ID
			FROM (
				--CONFIRM_ID ,날짜동일한 기준으로 계획정보의 FROM, TO SITE기준으로 실적 집계 
				SELECT R.DIVISION_ID     AS DIVISION_ID
				,     'E'				 AS TYPE 
				,      R.ERP_SO_NO       AS ERP_SO_NO
				,      R.CONFIRM_ID      AS CONFIRM_ID 
				,      R.ITEM_ID         AS ITEM_ID 
				,      R.FROM_SITE       AS FROM_SITE 
				,      R.TO_SITE         AS TO_SITE 
				,      NULL              AS END_CUSTOMER
				,      SUM(R.RESULT_QTY) AS QTY 
				,      R.YYYYMMDD        AS YYYYMMDD
				,      R.TRANSPORT_MODE  AS TRANSPORT_MODE
				,      R.INCOTERMS       AS INCOTERMS
				,      R.ETD_DATE        AS ETD_DATE
				,      R.ETA_DATE        AS ETA_DATE
				,      NULL				 AS SHIP_TYPE
				,	   ''				 AS BOD_ID	
				,	   ''				 AS ROUTE_ID
				FROM  RESULT_ERP_C_EXIST R 
	
				GROUP BY R.DIVISION_ID
				,		 R.ERP_SO_NO
				,        R.FROM_SITE                                                                           
				,        R.TO_SITE 
				,        R.ITEM_ID
				,		 R.TRANSPORT_MODE			   
				,		 R.INCOTERMS
				,		 R.ETD_DATE
				,		 R.ETA_DATE		   
				,        R.YYYYMMDD 
				,        R.CONFIRM_ID

			UNION ALL 

				--CONFIRM_ID 없는 실적 
				SELECT R.DIVISION_ID     AS DIVISION_ID
				,     'E'                AS TYPE 
				,      R.ERP_SO_NO       AS ERP_SO_NO
				,      NULL              AS CONFIRM_ID 
				,      R.ITEM_ID         AS ITEM_ID 
				,      R.FROM_SITE       AS FROM_SITE 
				,      R.TO_SITE         AS TO_SITE 
				,      NULL              AS END_CUSTOMER
				,      R.QTY             AS QTY 
				,      R.YYYYMMDD        AS YYYYMMDD 
				,      R.TRANSPORT_MODE  AS TRANSPORT_MODE
				,      R.INCOTERMS       AS INCOTERMS
				,      R.ETD_DATE        AS ETD_DATE
				,      R.ETA_DATE        AS ETA_DATE
				,      NULL              AS SHIP_TYPE
				,	   ''				 AS BOD_ID	
				,	   ''				 AS ROUTE_ID
				FROM  RESULT_ERP_C_NON R 

			UNION ALL

				-- OWMS 실적 
				SELECT R.DIVISION_ID     AS DIVISION_ID
				,     'O'                AS TYPE 
				,      NULL              AS ERP_SO_NO
				,      NULL              AS CONFIRM_ID 
				,      R.ITEM_ID         AS ITEM_ID 
				,      R.FROM_SITE       AS FROM_SITE 
				,      R.TO_SITE         AS TO_SITE 
				,      NULL              AS END_CUSTOMER
				,      R.QTY             AS QTY 
				,      R.YYYYMMDD        AS YYYYMMDD 
				,      NULL              AS TRANSPORT_MODE
				,      NULL              AS INCOTERMS
				,      NULL              AS ETD_DATE
				,      NULL              AS ETA_DATE
				,      R.SHIP_TYPE       AS SHIP_TYPE
				,	   ''				 AS BOD_ID
				,	   ''				 AS ROUTE_ID
				FROM  RESULT_OWMS R
		
			UNION ALL
				-- OWMS 반품실적 
				SELECT R.DIVISION_ID     AS DIVISION_ID
				,      'R'		         AS TYPE 
				,      NULL              AS ERP_SO_NO
				,      NULL              AS CONFIRM_ID 
				,      R.ITEM_ID         AS ITEM_ID 
				,      R.FROM_SITE       AS FROM_SITE 
				,      R.TO_SITE         AS TO_SITE 
				,      NULL              AS END_CUSTOMER
				,      R.QTY             AS QTY 
				,      R.YYYYMMDD        AS YYYYMMDD 
				,      NULL              AS TRANSPORT_MODE
				,      NULL              AS INCOTERMS
				,      NULL              AS ETD_DATE
				,      NULL              AS ETA_DATE
				,      R.SHIP_TYPE       AS SHIP_TYPE
				,	   ''				 AS BOD_ID
				,	   ''				 AS ROUTE_ID
				FROM  RETURN_OWMS R
			) X
				JOIN SCM_MST_SITE MS WITH(NOLOCK) 
				  ON MS.DIVISION_ID = X.DIVISION_ID 
				 AND MS.SCM_SITE_ID = X.FROM_SITE  
				 --AND MS.OPERATION_GROUP = 'E'
				JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
   				  ON L.LOOKUP_TYPE = 'SSP_SHIPMENT_RESULT_TYPE' -- LOOKUP에 등록된 공정만 
				 AND L.SEGMENT1 = X.TYPE 
				 AND L.VALID_YN = 'Y'
				LEFT OUTER JOIN SSP_MST_MODEL_USER M WITH(NOLOCK) 
						  ON  M.DIVISION_ID = X.DIVISION_ID 
							and M.FROM_SITE = X.FROM_SITE 
							and M.ITEM_ID = X.ITEM_ID 
							and M.VALID_YN = 'Y'
		),
		SSP_SEMI_FINAL AS
		(
			SELECT	DIVISION_ID, 
					COMPANY_ID, 
					CASE WHEN TYPE = 'Plan' THEN 'SSP_Plan' ELSE TYPE END AS TYPE, 
					ERP_SO_NO, 
					CONFIRM_ID, 
					ITEM_ID, 
					NICK_NAME, 
					FROM_SITE, 
					TO_SITE, 
					END_CUSTOMER, 
					QTY, YYYYMMDD, 
					TRANSPORT_MODE, 
					INCOTERMS, 
					ETD_DATE, 
					ETA_DATE, 
					SHIP_TYPE, 
					ISO_YYYYWW AS TARGET_WEEK,	
					CONCAT(MONTH_NAME,'-01') AS TARGET_MONTH,	
					BOD_ID,
					ROUTE_ID,
					C.PLAN_WEEK
			FROM	SSP_PLAN_RESULT A
					LEFT OUTER JOIN SCM_SYS_CALENDAR_M B  with(nolock)
					ON A.YYYYMMDD = B.DATE_FULL_NAME
					, PLAN_INFO C	
		),
		SSP_FINAL AS
		(
		SELECT	DIVISION_ID,
				COMPANY_ID,
				TYPE,
				ERP_SO_NO,
				CONFIRM_ID,
				ITEM_ID,
				NICK_NAME,
				FROM_SITE,
				TO_SITE,
				END_CUSTOMER,
				TARGET_WEEK,
				TARGET_MONTH,
				YYYYMMDD, 
				--SUM(QTY) AS QTY,
				QTY,
				TRANSPORT_MODE,
				INCOTERMS,
				ETD_DATE,
				ETA_DATE,
				SHIP_TYPE,
				BOD_ID,
				ROUTE_ID,
				PLAN_WEEK
		FROM	SSP_SEMI_FINAL
		),
		FINAL AS
		(
			SELECT	A.*
			FROM	SSP_FINAL A
			/*
			UNION ALL
			SELECT	A.*, C.PLAN_WEEK
			FROM	SCP_FINAL A, PLAN_INFO C
			*/
		)

		INSERT INTO [dbo].[SCP_BI_SSP_RESULT_H]
					([DIVISION_ID]
					,[COMPANY_ID]
					,[TYPE]
					,[ERP_SO_NO]
					,[CONFIRM_ID]
					,[ITEM_ID]
					,[NICK_NAME]
					,[FROM_SITE]
					,[TO_SITE]
					,[END_CUSTOMER]
					,[YYYYMMDD]
					,[TARGET_WEEK]
					,[TARGET_MONTH]
					,[KPI_MONTH]
					,[TARGET_ST_DATE]
					,[PARTIAL_START_DATE]
					,[ORIGIN_QTY]
					,[TRANSPORT_MODE]
					,[INCOTERMS]
					,[ETD_DATE]
					,[ETA_DATE]
					,[SHIP_TYPE]
					,[BOD_ID]
					,[ROUTE_ID]
					,[PLAN_WEEK]
					,[PLAN_ST_DATE]
					,[MODEL]
					,[GROUP_CODE]
					,[ELECTRODE_TYPE]
					,[CONVERT_QTY_CELL]
					,[QTY]
					,[OPERATION_GROUP]
					,[OUTSOURCING_FROM_SITE]
					,[OUTSOURCING_TO_SITE]
					,[LOGISTIC_PLANT]
					,[FROM_COUNTRY]
					,[FROM_CITY]
					,[TRANSPORT_MODE_B]
					,[D_COUNTRY]
					,[D_PORT_CODE]
					,[D_PORT_NAME]
					,[A_COUNTRY]
					,[A_PORT_CODE]
					,[A_PORT_NAME]
					,[TO_COUNTRY]
					,[TO_CITY]
					,ENERGY_KWH
					,EXTRA_SPEC
					,ITEM_CLASS_NAME 
					,ITEM_TYPE		
					,[CREATED_BY]
					,[CREATION_DATE]
					,[LAST_UPDATED_BY]
					,[LAST_UPDATE_DATE])
			SELECT	A.DIVISION_ID,
					A.COMPANY_ID,
					TYPE,
					ERP_SO_NO,
					CONFIRM_ID,
					A.ITEM_ID,
					CASE WHEN (A.NICK_NAME IS NULL OR A.NICK_NAME = '') THEN J.NICK_NAME ELSE A.NICK_NAME END AS NICK_NAME,
					A.FROM_SITE,
					TO_SITE,
					A.END_CUSTOMER,
					A.YYYYMMDD, 
					TARGET_WEEK,
					TARGET_MONTH,
					KPI_MONTH,
					TARGET_ST_DATE,
					PARTIAL_START_DATE,
					QTY AS ORIGIN_QTY,
					A.TRANSPORT_MODE,
					INCOTERMS,
					ETD_DATE,
					ETA_DATE,
					SHIP_TYPE,
					A.BOD_ID,
					A.ROUTE_ID,
					PLAN_WEEK, 
					PLAN_ST_DATE,
					CASE WHEN A.DIVISION_ID IN ('40') THEN ISNULL(F.NICK_NAME, A.ITEM_ID)
						 WHEN (A.DIVISION_ID IN ('81') OR A.DIVISION_ID LIKE '81_%') THEN ISNULL(F.GROUP_CODE2, A.ITEM_ID)
						 WHEN A.DIVISION_ID IN ('82') THEN A.ITEM_ID
						 ELSE A.ITEM_ID 
					END AS MODEL,
					E.DOE AS GROUP_CODE, 
					G.ELECTRODE_TYPE, 
					ISNULL(G.CONVERT_QTY_CELL, K.ACCUMULATED_CHILD_QTY) AS CONVERT_QTY_CELL,
					CASE WHEN G.ELECTRODE_TYPE = 'Pouch' THEN A.QTY * G.CONVERT_QTY_CELL
						 ELSE A.QTY END AS QTY,
					CASE WHEN C.OPERATION_GROUP = 'P' THEN 'Pack' 
						 WHEN C.OPERATION_GROUP = 'A' THEN 'Cell' 
						 WHEN C.OPERATION_GROUP = 'E' THEN 'Electrode' 
						 WHEN C.OPERATION_GROUP = 'W' THEN 'Warranty' 
						 ELSE C.OPERATION_GROUP END AS OPERATION_GROUP, 
					C.OSP_YN AS OUTSOURCING_FROM_SITE, 
					ISNULL(H.OSP_YN,'N') AS OUTSOURCING_TO_SITE, 
					D.PLANT_NAME AS LOGISTIC_PLANT,
					B.FROM_COUNTRY, 
					B.FROM_CITY, 
					B.TRANSPORT_MODE AS TRANSPORT_MODE_B, 
					B.D_COUNTRY, 
					B.D_PORT_CODE, 
					B.D_PORT_NAME, 
					B.A_COUNTRY, 
					B.A_PORT_CODE, 
					B.A_PORT_NAME, 
					B.TO_COUNTRY, 
					B.TO_CITY,
					J.ENERGE AS ENERGY_KWH, 
					E.EXTRA_SPEC,
					J.ITEM_CLASS_NAME, 
					CASE WHEN J.ITEM_TYPE = 'P' THEN 'Product' 
						 WHEN J.ITEM_TYPE = 'H' THEN 'Semi Product' 
						 WHEN J.ITEM_TYPE = 'Q' THEN 'Purchase' 
						 WHEN J.ITEM_TYPE = 'R' THEN 'Material' 
						 ELSE J.ITEM_TYPE
					END AS ITEM_TYPE,
						@v_batch_user,
						getdate(),
						@v_batch_user,
						getdate()
			FROM	FINAL A
					LEFT OUTER JOIN LT B ON A.BOD_ID = B.BOD_ID AND A.ROUTE_ID = B.ROUTE_ID
					LEFT OUTER JOIN SCM_MST_SITE C  with(nolock) ON A.FROM_SITE = C.SITE_DESCRIPTION AND A.DIVISION_ID = C.DIVISION_ID AND C.SITE_TYPE = 'PLANT' AND C.VALID_YN = 'Y'
					LEFT OUTER JOIN SCM_MST_SITE H  with(nolock) ON A.TO_SITE = H.SITE_DESCRIPTION AND A.DIVISION_ID = H.DIVISION_ID AND H.SITE_TYPE = 'PLANT' AND H.VALID_YN = 'Y'
					LEFT OUTER JOIN SCM_MST_PLANT_SN D  with(nolock) ON C.LOGISTIC_PLANT_ID = D.PLANT_ID AND C.DIVISION_ID = D.DIVISION_ID
					LEFT OUTER JOIN GROUP_CODE E ON A.DIVISION_ID = E.DIVISION_ID AND A.ITEM_ID = E.ITEM_ID
					LEFT OUTER JOIN SCP_MST_FINAL_ITEM_VIEW F ON A.DIVISION_ID = F.DIVISION_ID AND A.ITEM_ID = F.ITEM_ID
					LEFT OUTER JOIN ELEC_CONVERT_QTY_CELL G ON A.DIVISION_ID = G.DIVISION_ID AND A.ITEM_ID = G.ITEM_ID 
					LEFT OUTER JOIN PLAN_DATE_INFO I ON A.TARGET_WEEK = I.ISO_YYYYWW AND A.TARGET_MONTH = CONCAT(I.MONTH_NAME,'-01')
					LEFT OUTER JOIN MODEL_TYPE J ON A.DIVISION_ID = J.DIVISION_ID AND A.ITEM_ID = J.ITEM_ID
					LEFT OUTER JOIN MODEL_BOM K ON A.DIVISION_ID = K.DIVISION_ID AND A.ITEM_ID = K.MODEL_ID 
			WHERE	1=1

		PRINT '-------------Step 2 Inserted : ' +  CONVERT(CHAR(23), getdate(), 21) ;

        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------
        --IF @@TRANCOUNT > 0
        --  BEGIN
        --    COMMIT TRAN TX_SH;
        --  END;       


        -- TXN LOG
        SET @v_log_type = N'TXN';    -- ▶ 로그타입
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = N'INSERT INTO '+@v_table_id;
        SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
        SET @d_event_date =  SYSDATETIME();

        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                  ,@p_log_type      =@v_log_type
                                  ,@p_log_count     =@n_log_count 
                                  ,@p_log_message   =@v_log_message 
                                  ,@p_description   =@v_description 
                                  ,@p_event_date    =@d_event_date 
                                  ,@p_user_id       =@v_batch_user
                                  ;      

    END
    END TRY

    BEGIN CATCH
      --IF @@TRANCOUNT > 0
      --  BEGIN
      --    ROLLBACK TRAN TX_SH


      --  END;
      
      -- ERROR LOG
      SET @v_log_type = N'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = @v_program_name + N'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                ,@p_log_type      =@v_log_type
                                ,@p_log_count     =@n_log_count 
                                ,@p_log_message   =@v_log_message 
                                ,@p_description   =@v_description 
                                ,@p_event_date    =@d_event_date 
                                ,@p_user_id       =@v_batch_user
                                ;
--      PRINT @@ERROR
      return -1
    END CATCH;

     --임시 운영반영시에 주석처리 할것.
     SET @v_exec_time  =  REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' + 
                          REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) 


    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description = N'['++'][' + @v_exec_time + ']';  
    SET @d_event_date = SYSDATETIME()  ;
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;
   
    return 1  

  END; 
