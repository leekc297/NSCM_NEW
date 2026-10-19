



/*
 * Program ID   : FN_DQ_FP_PLAN_81                                                              
 * Description  : DQ 용 Prod Plan-81
 * 실행 예제    : SELECT * FROM dbo.FN_DQ_FP_PLAN_81('20230731', '81,82', 'A041', 'E78')
 *                당주 이전 실적 + 계획
 * Program History  
 *===================================================================================================  
 *   Date       In Charge		Description  
 *===================================================================================================  
 * 2023.12.05	KHJ			[PJ20230692] LGES SCM 역량 강화 위한 SCP 개선과제 이행 Phase2 : DQ 용 FP Prod Plan 정보
 */
 
CREATE FUNCTION [dbo].[FN_DQ_FP_PLAN_81]
(	
      @p_plan_start_yyyymmdd NVARCHAR(8)
    , @p_division_id         NVARCHAR(1000)
    , @p_plant_id            NVARCHAR(1000)
    , @p_cell_nickname       NVARCHAR(1000)
)
RETURNS @FP_PLAN TABLE
(
	 DIVISION_ID	  NVARCHAR(30)
    ,SITE_ID          NVARCHAR(30)
    ,PLANT_ID         NVARCHAR(30)
    ,PLANT_NAME       NVARCHAR(100)
    ,SCM_PLANT        NVARCHAR(100)
    ,OPERATION_ID     NVARCHAR(30)
    ,FACTORY_ID       NVARCHAR(30)
    ,LINE_ID          NVARCHAR(30)
    ,LINE_NAME        NVARCHAR(100)
    ,CELL_ITEM_ID     NVARCHAR(30)
    ,ITEM_ID          NVARCHAR(30)
    ,CELL_MODEL       NVARCHAR(100)
    ,PRODUCTION_TYPE  NVARCHAR(30)
    ,TYPE             NVARCHAR(30)
    ,CATEGORY         NVARCHAR(30)
    ,PLAN_DATE        NVARCHAR(30)
    ,YYYYPW           NVARCHAR(30)
	,QTY              NUMERIC(30,3) -- KCell 단위로 소스점 3자리까지 표시 요청
)AS

BEGIN

   /*********************************************************
    -- @v_selec_yyyymmdd(= @p_plan_start_yyyymmdd) ~ 전주 일요일 : 실적
    -- @v_start_yyyymmdd(당주 월요일) ~ 8/12주 : 계획
    -- @p_plan_start_yyyymmdd 가 미래인 경우 : 계획만
    **********************************************************/
	DECLARE @v_selec_yyyymmdd  nvarchar(8) = @p_plan_start_yyyymmdd;  --조회 기준일	
	DECLARE @v_start_yyyymmdd  nvarchar(8) ; -- 조회 시점 당주 월요일
	DECLARE @v_end_yyyymmdd    nvarchar(8) ; -- End Date

	-- 당주 월요일
	SELECT @v_start_yyyymmdd =  CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
	                                             
	-- 계획 구간 : 조회 주 포함 8주
	SELECT @v_end_yyyymmdd = CONVERT(CHAR(8), DATEADD(D, 7*8-1, CONVERT(DATETIME, @v_start_yyyymmdd)), 112)

	iNSERT INTO @FP_PLAN
	SELECT DIVISION_ID, SITE_ID, PLANT_ID, PLANT_NAME, SCM_PLANT, OPERATION_ID, FACTORY_ID, LINE_ID, LINE_NAME
		 , CELL_ITEM_ID, ITEM_ID, CELL_MODEL, PRODUCTION_TYPE, TYPE, CATEGORY, PLAN_DATE, YYYYPW, QTY
	FROM (
		SELECT    A.DIVISION_ID 
				, A.SITE_ID
				, A.PLANT_ID
				, B.PLANT_NAME
				, B.DESCRIPTION AS SCM_PLANT
				, A.OPERATION_ID 
				, A.FACTORY_ID
				, A.LINE_ID
				, C.LINE_NAME
				, CASE WHEN F.OPERATION_GROUP = 'A' THEN A.ITEM_ID
						WHEN F.OPERATION_GROUP = 'P' THEN F.ATTRIBUTE1
						ELSE ''
					END AS CELL_ITEM_ID
				, A.ITEM_ID
				, CASE WHEN F.OPERATION_GROUP = 'A' THEN F.GROUP_CODE1
						WHEN F.OPERATION_GROUP = 'P' THEN (SELECT GROUP_CODE1 FROM SCP_MST_FINAL_ITEM B WITH(NOLOCK) WHERE B.DIVISION_ID = F.DIVISION_ID AND B.ITEM_ID = F.ATTRIBUTE1)
						ELSE ''
					END AS CELL_MODEL
				, A.PRODUCTION_TYPE
				, CASE WHEN D.APPLIED_MODEL LIKE N'A%' THEN 'AUTOMOTIVE'
					   WHEN D.APPLIED_MODEL LIKE N'E%' THEN 'ESS'
					   ELSE D.CELL_TYPE END AS TYPE 
				, A.CATEGORY
				, A.PLAN_DATE 
				, SUBSTRING(E.yyyypw, 3,2) + '_W' + SUBSTRING(E.yyyypw, 5,2) 
				+ CASE WHEN ISNULL(SUBSTRING(E.yyyypw, 7,1), '') = '' THEN ''
					   ELSE '_' + SUBSTRING(E.yyyypw, 7,1) 
				  END AS YYYYPW
				, (A.CELL_OUT_QTY / 1000.0) AS QTY -- K Cell 단위
		FROM (
				SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
						, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID
						, A.PLAN_DATE, A.ITEM_ID, A.PRODUCTION_TYPE , A.CATEGORY
						, SUM(A.CELL_OUT_QTY) AS CELL_OUT_QTY
				FROM	(   -- 실적
							SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
									, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID
									, CONVERT(CHAR(8), A.PLAN_DATE, 112) AS PLAN_DATE, A.TOP_ITEM_ID, A.ITEM_ID
									, A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE, A.MARKET, 'RESULT' AS PLAN_TYPE
									, A.CELL_OUT_QTY AS CELL_OUT_QTY
									,'PLAN RESULT(OUT)' AS CATEGORY
							--FROM	SCM_DNM_PRODUCT_RESULT_V A WITH(NOLOCK)
							FROM	SCM_DNM_DAILY_PRODUCT_RESULT_SN A WITH(NOLOCK)
							WHERE	1=1
							AND     A.division_id IN (SELECT token FROM [dbo].[String_Split](@p_division_id, ','))
							AND     A.PLANT_ID IN (SELECT token FROM [dbo].[String_Split](@p_plant_id, ','))
							AND     A.PLAN_DATE BETWEEN CONVERT(datetime, @v_selec_yyyymmdd) AND CONVERT(datetime, @v_start_yyyymmdd ) -1
						
							AND		A.OPERATION_ID IN ('A9000', 'P5500', 'P9500', 'F6000') 
							AND     A.FP_PRODUCTION_TYPE IN (N'C-MASS',N'MASS')  -- _SN 사용 시 조건 추가, _V 사용 시 주석 처리
							--AND     A.PRODUCTION_TYPE     NOT IN ('REWORK', 'PILOT') -- _SN 사용 시 조건 추가, _V 사용 시 주석 처리
							AND		A.CELL_OUT_QTY > 0

							-- 계획
							UNION ALL
							SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
									, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID
									, CONVERT(CHAR(8), A.PLAN_DATE, 112) AS PLAN_DATE, A.ITEM_ID AS TOP_ITEM_ID, A.ITEM_ID
									, A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE, A.MARKET, A.PLAN_TYPE
									, A.CELL_OUT_QTY AS CELL_OUT_QTY
									, 'PLAN(OUT)' AS CATEGORY
							FROM	SCM_DNM_DAILY_PRODUCT_PLAN_SN A WITH(NOLOCK)
							WHERE	1=1
							AND     A.division_id IN (SELECT token FROM [dbo].[String_Split](@p_division_id, ','))
							AND     A.PLANT_ID IN (SELECT token FROM [dbo].[String_Split](@p_plant_id, ','))
							AND     A.PLAN_DATE BETWEEN CONVERT(datetime, @v_start_yyyymmdd) AND CONVERT(datetime, @v_end_yyyymmdd ) 
						
							AND		A.PLAN_TYPE = 'RELEASE'
							AND		A.OPERATION_ID IN ('A9000', 'P5500', 'P9500', 'F6000') 
							AND     A.FP_PRODUCTION_TYPE IN (N'C-MASS',N'MASS') 
							AND		A.CELL_OUT_QTY > 0
				
						) A
					WHERE 1=1
					GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
							  , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID
							  , A.PLAN_DATE, A.ITEM_ID, A.PRODUCTION_TYPE , A.CATEGORY
			) A
			INNER JOIN SCM_MST_PLANT_SN B WITH(NOLOCK)
			ON 1=1
			AND A.COMPANY_ID = B.COMPANY_ID
			AND A.DIVISION_ID = B.DIVISION_ID
			AND A.SITE_ID = B.SITE_ID
			AND A.PLANT_ID = B.PLANT_ID

			INNER JOIN SCM_MST_LINE_SN C WITH(NOLOCK)
			ON 1=1
			AND A.COMPANY_ID = C.COMPANY_ID
			AND A.DIVISION_ID = C.DIVISION_ID
			AND A.SITE_ID = C.SITE_ID
			AND A.PLANT_ID = C.PLANT_ID
			AND A.FACTORY_ID = C.FACTORY_ID
			AND A.OPERATION_ID = C.OPERATION_ID
			AND A.LINE_ID = C.LINE_ID
			AND A.ELECTRODE_TYPE = C.ELECTRODE_TYPE

			INNER JOIN SCM_MST_ITEM_SN D WITH(NOLOCK)
			ON 1=1
			AND A.COMPANY_ID = D.COMPANY_ID
			AND A.DIVISION_ID = D.DIVISION_ID
			AND A.SITE_ID = D.SITE_ID
			AND A.ITEM_ID = D.ITEM_ID
	
			INNER JOIN SCM_MST_BUCKET E WITH(NOLOCK)
			ON A.PLAN_DATE             = E.yyyymmdd

			LEFT JOIN SCP_MST_FINAL_ITEM F WITH(NOLOCK)
			ON  A.DIVISION_ID = F.DIVISION_ID
			AND A.ITEM_ID     = F.ITEM_ID
		WHERE 1=1
		--AND	  A.CATEGORY = 'PLAN(OUT)'
	) A
	WHERE  1=1
	AND    A.CELL_MODEL IN (SELECT token FROM [dbo].[String_Split](@p_cell_nickname, ',')) 
	ORDER BY DIVISION_ID, SITE_ID, PLANT_ID, YYYYPW, OPERATION_ID, FACTORY_ID, LINE_ID, LINE_NAME
			, CELL_ITEM_ID, ITEM_ID, CELL_MODEL, PRODUCTION_TYPE, TYPE, CATEGORY, PLAN_DATE,  QTY

RETURN;

END;

