







/*
 * Program ID   : SSP0002_GET_NERP_CODE
 * Description  : Div, From Site, To Site 에 해당되는 BOD(Trans mode, Incoterms) 유효성 체크
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2024/06/10   KHJ			   NERP_SSP UI하드코딩 변환

 ex) 
 */

CREATE PROCEDURE [dbo].[SSP0002_GET_NERP_CODE]
	  @P_PROCEDURE_KEY   	NVARCHAR(200) 
	 ,@P_SEQUENCE   NVARCHAR(200) 
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
    DECLARE @V_PROCEDURE_KEY    NVARCHAR(200) = @P_PROCEDURE_KEY;
	DECLARE @V_SEQUENCE NVARCHAR(200) = @P_SEQUENCE;
    DECLARE @d_event_date   DATETIME;
	DECLARE @n_log_count    INTEGER = 0;	

	SELECT SEGMENT2 
	FROM   DBO.SCM_CODE_LOOKUP_VALUE WITH(NOLOCK)
	WHERE  LOOKUP_TYPE_CODE = @V_PROCEDURE_KEY
	AND    SEGMENT1         = @V_SEQUENCE
	AND    ACTIVE_FLAG      = 'Y'



      --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =N'SSP0002_GET_NERP_CODE'
      --                          ,@p_log_type      =@V_PROCEDURE_KEY
      --                          ,@p_log_count     = @n_log_count
      --                          ,@p_log_message   =@V_SEQUENCE 
      --                          ,@p_description   =@V_SEQUENCE 
      --                          ,@p_event_date    =@d_event_date 
      --                          ,@p_user_id       ='hjkang.lges'
                                ;


END


