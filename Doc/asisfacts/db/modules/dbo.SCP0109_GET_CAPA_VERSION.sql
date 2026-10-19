
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : SCP0109_GET_CAPA_VERSION
 * Description  : CAPA Version Master
 * Program History
 *================================================================================================================================================
 * Date         In Charge                          Description
 *================================================================================================================================================
 * 2024/04/25   chaan        V1.1.1                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial Release
 */

--CREATE PROCEDURE [dbo].[SCP0109_GET_CAPA_VERSION]
CREATE PROCEDURE [dbo].[SCP0109_GET_CAPA_VERSION]
	  @p_division_id		NVARCHAR(30)
	, @p_from_yyyymm		NVARCHAR(6)
	, @p_to_yyyymm			NVARCHAR(6)
	, @p_program_id			NVARCHAR(100)
	, @p_sheet_name			NVARCHAR(100)
	, @p_user_id			NVARCHAR(30)
	, @debug_mode			NVARCHAR(1)
AS
BEGIN
    SET NOCOUNT ON;

	--DECLARE @p_division_id		    NVARCHAR(30)		= N'81';
	--DECLARE @p_from_yyyymm			NVARCHAR(6)			= N'202401';
	--DECLARE @p_to_yyyymm			NVARCHAR(6)			= N'202412';
	--DECLARE @p_program_id		    NVARCHAR(100)		= N'SCP0109';
	--DECLARE @p_sheet_name		    NVARCHAR(100)		= N'';
 --   DECLARE @p_user_id			    NVARCHAR(30)		= N'iamarock';
 --   DECLARE @debug_mode			    NVARCHAR(1)			= N'F';


	SELECT	  A.VER_ID
			, A.VER_SEQ
			, A.DIVISION_ID
			, A.PROG_STAT
			, SCP_FIN_PLAN_ID	       
			, SCP_PRDN_PLAN_REF_ST_YM	
			, SCP_PRDN_PLAN_REF_END_YM	
			, B.NAME						AS PROG_STAT_NAME
	FROM	SCP_MST_CAPA_VERSION A WITH(NOLOCK)
			JOIN (
					SELECT	  B.SEGMENT1 AS CODE
							, B.SEGMENT2 AS NAME
					FROM    SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
							INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON 
									A.LOOKUP_TYPE = B.LOOKUP_TYPE
					WHERE	1=1
						AND A.LOOKUP_GROUP  = 'SCP'
						AND A.LOOKUP_TYPE   = 'CAPA_PROG_STAT'
						AND B.VALID_YN      = 'Y'
				  ) B ON
					A.PROG_STAT = B.CODE
	    WHERE	1=1
		    AND	A.VER_ID BETWEEN @p_from_yyyymm AND @p_to_yyyymm
		    AND ((@p_division_id	IS NULL OR @p_division_id	    = '') OR A.DIVISION_ID    IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_division_id, ',')))

END

