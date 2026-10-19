


/*
 * Program ID   : SSP0202_GET_SCS_CONFIRM_ID_CHECK
 * Description  : Check CONFIRM_ID in SCM_DNM_SCS_SHIP_RESULT
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/11/12   SHINMYUNGSU    최초 작성
 * 2021/11/18   KIMYONGHO      재고 수신 여부 체크 로직 추가
 */

CREATE PROCEDURE [dbo].[SSP0202_GET_SCS_CONFIRM_ID_CHECK]
	 @p_confirm_id			NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @mDQry						NVARCHAR(MAX)='';
	DECLARE @mDQry2						NVARCHAR(MAX)='';			-- 재고 수신 여부 체크용

	DECLARE @v_confirm_id				NVARCHAR(MAX);

	DECLARE @v_valid_cnt				INT = 0;	
	DECLARE @v_plan_start_yyyymmdd		NVARCHAR(MAX)='';
	DECLARE @v_cutoff_date				NVARCHAR(MAX)='';	
	DECLARE @v_plan_cutoff_datetime		datetime;


	SELECT @v_plan_start_yyyymmdd = CONVERT(VARCHAR, DATEADD(D, 1, CONVERT(DATETIME, ATTRIBUTE1 ,112)) ,112)
	  FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
	 WHERE LOOKUP_TYPE		= 'SSP_ANL_SHIP_PLAN_P'
	   AND SEGMENT1			= '40'
	   AND VALID_YN			= 'Y'
	;

	SET @v_cutoff_date			 = CONVERT(VARCHAR, DATEADD(D, -2, CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)) ,112) ;
	--SET @@v_plan_cutoff_datetime = CONVERT(DATETIME, CONVERT(VARCHAR, DATEADD(D, -1, CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)) ,112) + ' 07:15:00')	 


	if  (datepart(DW, convert(date, CONVERT(VARCHAR, DATEADD(D, 0, CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)) ,112))) = 2)
	   	SET @v_plan_cutoff_datetime = CONVERT(DATETIME, CONVERT(VARCHAR, DATEADD(D, 0, CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)) ,112) + ' 15:30:00')
	else
	    SET @v_plan_cutoff_datetime = CONVERT(DATETIME, CONVERT(VARCHAR, DATEADD(D, 0, CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)) ,112) + ' 07:15:00')


	SET @v_confirm_id = [dbo].FN_GET_IN_STR(@p_confirm_id);


	SET @mDQry = @mDQry + ' SELECT COUNT(*) CNT																	' + char(10);
	SET @mDQry = @mDQry + '	  FROM SCM_DNM_SCS_SHIP_RESULT (NOLOCK) 											' + char(10);
	SET @mDQry = @mDQry + '	 WHERE ATTRIBUTE5 IN ('+ @v_confirm_id   +')										' + char(10);

	EXEC (@mDQry);


	-- 2022-02-15 KIMYONGHO 재고 체크 임시 제외
	SELECT 0 AS CNT																			
	
	--SELECT COUNT (*) CNT																			
	--FROM																							
	--(																								
	--	SELECT CASE WHEN B.STOCK_QTY > 0 THEN 'Y' ELSE 'N' END EDIT_FLAG , A.* 					
	--	FROM SSP_ANL_SHIP_CONFIRM A WITH(NOLOCK)																	
	--	LEFT OUTER JOIN SCM_DNM_SCS_STOCK B 	WITH(NOLOCK)															
	--		ON A.DIVISION_ID		 = B.DIVISION_ID													
	--		AND A.FROM_SITE			 = B.SCM_SITE_ID
	--		AND A.ITEM_ID			 = B.ITEM_ID																						
	--	WHERE  1 = 1	
	--	AND B.DIVISION_ID		 = '40'															
	--	AND B.CUTOFF_DATE		 =  @v_cutoff_date 												
	--	AND B.LAST_UPDATE_DATE  <= @v_plan_cutoff_datetime										
	--	AND B.CELL_PACK			 = 'P'								
	--	AND ( ( @p_confirm_id   IS NULL OR @p_confirm_id ='')  OR A.CONFIRM_ID IN (SELECT token FROM dbo.String_Split(@p_confirm_id,',')) )
	--) A																																															
	--WHERE A.EDIT_FLAG = 'N'																		
	--;


END
