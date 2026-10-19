CREATE FUNCTION [dbo].[FN_GET_ROUTE_INFO]
(     
	 @p_PLAN_RESULT       NVARCHAR(400)
	,@p_DIVISION_ID       NVARCHAR(400)
	,@p_PROJECT_CODE      NVARCHAR(400)
	,@p_SALES_SITE_ID     NVARCHAR(400)
	,@p_ITEM_ID           NVARCHAR(400)
	,@p_FCST_TYPE         NVARCHAR(400)
	,@p_INCOTERMS         NVARCHAR(400)
	,@p_CURRENCY          NVARCHAR(400)
	,@p_from_yyyymmdd     NVARCHAR(8)
	,@p_now_yyyymmdd      NVARCHAR(8)
	,@p_to_yyyymmdd       NVARCHAR(8)
)

RETURNS NVARCHAR(400)
AS
/*
 * Program ID   : FN_GET_ROUTE_INFO
 * Description  : SSPM, ERP ROUTE 정보 가져오기위한 함수 
*        
 * Program History
 *=============================================================================================================
 *   Date       In Charge      Description
 *=============================================================================================================
 * 2023.06.29  GSCM 실적 Route 컬럼값 ERP 연동 요청의 건
              "Sales Monitoring" 화면 Route 열 산출 로직추가 (ERP ROUTE 정보 추가)
 * 2023.07.11  [E20230630-001379] 구분값에 따른 ERP_ROUTE(DM_DNM_SALES_RESULT_IF) OR  SSPM_ROUTE(SCM_MST_SITE_ITEM) 조회 분리
 */
BEGIN

DECLARE @v_yyyymmdd_from NVARCHAR(8);  
DECLARE @v_yyyymmdd_to   NVARCHAR(8); 
	
	DECLARE @v_route NVARCHAR(MAX)=''
	
	SET @v_yyyymmdd_from = substring(CONVERT(CHAR(8), dateadd(month, CASE WHEN (SELECT SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 0, GETDATE()), 112),7,2)) = '01' THEN -2 ELSE -1 END	,getdate()), 112),1,6) + '01'	-- 전월1일/1일은 전전월1일 (yyyymmdd)
	SET @v_yyyymmdd_to   = CONVERT(NVARCHAR(8), GETDATE(), 112)
	
	
	BEGIN
		IF @p_PLAN_RESULT  = 'R'
			BEGIN 
				SELECT @v_route =  STUFF((SELECT ',' +  ISNULL(LGS_ROUTE_NAME ,'') 
				FROM DM_DNM_SALES_RESULT_IF WITH(NOLOCK)
				WHERE 1=1						
				AND DIVISION_ID			= @p_DIVISION_ID
				AND PROJECT_CODE		= @p_PROJECT_CODE
				AND SALES_SITE_ID		= @p_SALES_SITE_ID
				AND ITEM_ID				= @p_ITEM_ID	
				/* DM_PLN_SALE_PLAN_RESULT 매핑추가 */
				AND FCST_TYPE           = @p_FCST_TYPE
				AND INCOTERMS           = @p_INCOTERMS
				AND CURRENCY            = @p_CURRENCY
				/* 일자 */
				AND SALES_POSTING_DATE >= @p_from_yyyymmdd
				AND SALES_POSTING_DATE  < @p_to_yyyymmdd
				/*  테스트 샘플
				AND DIVISION_ID = '40'	 AND SALES_POSTING_DATE >= '20220601'					
				AND PROJECT_CODE = 'All Good Energy'
				AND SALES_SITE_ID = 'All Good Energy_TW_TYN'
				AND ITEM_ID = 'MCCM348014A2'
				 */
				GROUP BY   DIVISION_ID, PROJECT_CODE, SALES_SITE_ID, ITEM_ID , FCST_TYPE, INCOTERMS, LGS_ROUTE_NAME 
				FOR XML PATH('')),1,1,'')
			
			END
		ELSE
			BEGIN
				SELECT @v_route = ROUTE
				FROM SCM_MST_SITE_ITEM WITH(NOLOCK)
				WHERE 1=1					
				AND DIVISION_ID			= @p_DIVISION_ID
				AND PROJECT_CODE		= @p_PROJECT_CODE
				AND SCM_SITE_ID  		= @p_SALES_SITE_ID
				AND ITEM_ID				= @p_ITEM_ID			
				GROUP BY   DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID , ROUTE
			END 
	END


  --IF @v_route IS NULL 
  IF ISNULL(@v_route, '')   = ''
    SET @v_route = '-';	
	
  RETURN @v_route;

END
;
