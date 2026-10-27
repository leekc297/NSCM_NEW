

/*
 * Program ID   : [PR_XLS_OPT_GET_PLAN_ID]
 * Description  : 통합플랜아이디의 날짜와 일치하는 조립그룹, 전극그룹의 플랜아이디를 추출
 * Program History
 *===================================================================================================
 *   Date         In Charge	   Description
 *===================================================================================================
 * 2025-09-16  shineuiho7  [PJ2025-50540] SCP/FP 통합 계획 수립을 위한 시뮬레이터Tool 구축 및 UI 개선 : 신규 작성
 *                                     
 * 
 * 
 ex) 
 exec PR_XLS_OPT_GET_PLAN_ID '20250818', 'GM1_A'  --조립
 exec PR_XLS_OPT_GET_PLAN_ID '20250818', 'GM1_E'  --전극
 
 */

CREATE PROCEDURE [dbo].[PR_XLS_OPT_GET_PLAN_ID]
        @p_plan_date        NVARCHAR(MAX)  = '20250818', 
		@p_plan_type_code   NVARCHAR(MAX)  = 'GM1_A', 
		@p_days				integer	 = 60		
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE	@v_plan_date			     	NVARCHAR(MAX)
	DECLARE	@v_plan_type_code				NVARCHAR(MAX)
	set @v_plan_type_code					= ISNULL(@p_plan_type_code, 'XXXXX')
	set @v_plan_date				    	= @p_plan_date

	
    BEGIN TRY
		
	    SELECT SFPH.PLAN_ID 
		 FROM (
				SELECT N'선택' AS  PLAN_ID
				UNION   ALL
        	  
                SELECT	 PLAN_ID			
				FROM(				
						

						SELECT PM.OPMZ_PLAN_ID			AS PLAN_ID	
						FROM     SCP_OPMZ_PLAN_M_SN PM WITH(NOLOCK)				
							INNER JOIN SCP_OPMZ_PLAN_GR_M_SN PGM WITH(NOLOCK)				
								ON PM.OPMZ_PLAN_GR_ID = PGM.OPMZ_PLAN_GR_ID				
						WHERE   1 = 1 
						AND PM.OPMZ_PLAN_ID LIKE '%' +  @v_plan_type_code + '%'     
						AND SUBSTRING(PM.OPMZ_PLAN_ID, 1, 8) = @v_plan_date
						UNION				
						SELECT  PLAN_ID				 AS PLAN_ID
						FROM    SCP_OPT_ENG_SCP_PLAN_ID_M_SN WITH(NOLOCK)				
						WHERE   1=1				
						AND     PLAN_TYPE_CODE LIKE '%' + @v_plan_type_code + '%'
						AND SUBSTRING(PLAN_ID, 1, 8) = @v_plan_date

				 ) PLN			
              ) AS SFPH
        ORDER BY 
		      SFPH.PLAN_ID DESC;

			  
    END TRY

	BEGIN CATCH
	    PRINT ERROR_MESSAGE()

-- exec PR_XLS_OPT_GET_PLAN_ID '20250818', 'GM1_A'  --조립
-- exec PR_XLS_OPT_GET_PLAN_ID '20250818', 'GM1_E'  --전극

	END CATCH

END



