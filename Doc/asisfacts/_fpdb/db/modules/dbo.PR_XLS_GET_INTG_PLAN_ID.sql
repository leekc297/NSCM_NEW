

/*
 * Program ID   : [PR_XLS_GET_INTG_PLAN_ID]
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 
 * 
 * 
 ex) 
 exec PR_XLS_GET_INTG_PLAN_ID 'UC2'
 */
--DECLARE
--    @p_apl_code         NVARCHAR(MAX)  = 'UC1' ,
--	@p_days				integer	 = 60
CREATE PROCEDURE [dbo].[PR_XLS_GET_INTG_PLAN_ID]
		@p_apl_code         NVARCHAR(MAX)  = 'UC1', 
		@p_days				integer	 = 60		--	KSK, 250630(디버그용)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE	@v_apl_code				NVARCHAR(MAX)
	set @v_apl_code					= ISNULL(@p_apl_code, 'XXX')

	
    BEGIN TRY

	    SELECT SFPH.INTG_PLAN_ID 
		 FROM (
              SELECT N'선택' AS  INTG_PLAN_ID
               UNION   ALL
        	  
              --SELECT INTG_PLAN_ID
              --  FROM SCM_FP_PLAN_H WITH(NOLOCK)
              -- WHERE INSTANCE_ID = 'UC_CELL_A'
              --   AND SUBSTRING(INTG_PLAN_ID, 5,8) >= DATEADD(DAY, -31, GETDATE())  --7 : 테스트기간중에는 31

              SELECT DISTINCT INTG_PLAN_ID
                FROM SCM_FP_PLAN_H WITH(NOLOCK)
               WHERE INTG_PLAN_ID LIKE @v_apl_code + '%'
				-- 테스트용 날짜 조절 31 => 60
                 AND SUBSTRING(INTG_PLAN_ID, 5,8) >= DATEADD(DAY, -  @p_days, GETDATE())  --7 : 테스트기간중에는 31
              ) AS SFPH
        ORDER BY 
		      SFPH.INTG_PLAN_ID DESC;

    END TRY

	BEGIN CATCH
	    PRINT ERROR_MESSAGE()


	END CATCH

END



