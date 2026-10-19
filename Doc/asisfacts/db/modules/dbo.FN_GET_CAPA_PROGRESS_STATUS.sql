
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : FN_GET_CAPA_PROGRESS_STATUS
 * Description  : CAPA 버전의 진행상태 (0 : Current, 1: 1`st Cutoff, 2: 2`nd Cutoff)
 * Program History
 *================================================================================================================================================
 * Date         In Charge                          Description
 *================================================================================================================================================
 * 2024/03/04   chaan        V1.1.1                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial Release
 */

--CREATE FUNCTION [dbo].[FN_GET_CAPA_PROGRESS_STATUS]
CREATE FUNCTION [dbo].[FN_GET_CAPA_PROGRESS_STATUS]
(
	  @p_version				NVARCHAR(10)
	, @p_version_seq			NVARCHAR(2)
	, @p_division_id			NVARCHAR(30)
)
RETURNS NVARCHAR(2)
    WITH EXEC AS CALLER
AS
BEGIN
    DECLARE @v_progress_status      NVARCHAR(2)     = NULL;


    SELECT  TOP 1
            @v_progress_status = PROG_STAT
    FROM    [dbo].[SCP_MST_CAPA_VERSION] A WITH(NOLOCK)
    WHERE   1=1
		AND	A.VER_ID		= @p_version
		AND	A.VER_SEQ	    = @p_version_seq
        AND A.DIVISION_ID  	= @p_division_id;
		    
    RETURN  ISNULL(@v_progress_status, '');
END

