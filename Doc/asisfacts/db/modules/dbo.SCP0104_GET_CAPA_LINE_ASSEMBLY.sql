
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : SCP0104_GET_CAPA_LINE_ASSEMBLY
 * Description  : CAPA LINE ASSING
 * Program History
 *================================================================================================================================================
 * Date         In Charge                          Description
 *================================================================================================================================================
 * 2024/09/30   chaan        V1.1.8                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial Release
*/

--CREATE PROCEDURE [dbo].[SCP0104_GET_CAPA_LINE_ASSEMBLY]
CREATE PROCEDURE [dbo].[SCP0104_GET_CAPA_LINE_ASSEMBLY]
	  @p_division_id		NVARCHAR(30)
	, @p_site_id			NVARCHAR(MAX)
	, @p_plant_id  			NVARCHAR(MAX)
	, @p_factory_id			NVARCHAR(MAX)
	, @p_line_id			NVARCHAR(MAX)
	, @p_program_id			NVARCHAR(100)
	, @p_sheet_name			NVARCHAR(100)
	, @p_user_id			NVARCHAR(30)
	, @debug_mode			NVARCHAR(1)
AS
BEGIN
    SET NOCOUNT ON;

	--DECLARE @p_division_id		    NVARCHAR(30)		= N'81';
	--DECLARE @p_site_id			    NVARCHAR(MAX)		= N'';
	--DECLARE @p_plant_id  		    NVARCHAR(MAX)		= N'';
	--DECLARE @p_factory_id		    NVARCHAR(MAX)		= N'';
	--DECLARE @p_line_id			    NVARCHAR(MAX)		= N'';
	--DECLARE @p_operation_id		    NVARCHAR(MAX)		= N'';
	--DECLARE @p_electrode_type	    NVARCHAR(MAX)		= N'';
	--DECLARE @p_program_id		    NVARCHAR(100)		= N'SCP0104';
	--DECLARE @p_sheet_name		    NVARCHAR(100)		= N'LINE_ASSEMBLY';
 --   DECLARE @p_user_id			    NVARCHAR(30)		= N'iamarock';
 --   DECLARE @debug_mode			    NVARCHAR(1)			= N'F';


    SELECT	  A.DIVISION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.PLANT_ID
			, A.FACTORY_ID
			, A.LINE_ID
            , MAX(A.LAST_UPDATED_BY)                        AS LAST_UPDATED_BY
            , MAX(A.LAST_UPDATE_DATE)                       AS LAST_UPDATE_DATE
			, dbo.FN_GET_DIVISION_NAME (A.DIVISION_ID)      AS DIVISION_NAME
			, MAX(A.SITE_NAME)                              AS SITE_NAME
			, MAX(A.COMPANY_NAME)                           AS COMPANY_NAME
			, MAX(A.PLANT_NAME)                             AS PLANT_NAME
			, MAX(A.FACTORY_NAME)                           AS FACTORY_NAME
			, MAX(A.LINE_NAME)                              AS LINE_NAME
	FROM	SCP_MST_CAPA_LINE A WITH(NOLOCK)
	WHERE	1=1
		    AND ((@p_division_id	IS NULL OR @p_division_id	    = '') OR A.DIVISION_ID    IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_division_id, ',')))
		    AND ((@p_site_id  		IS NULL OR @p_site_id	        = '') OR A.SITE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_site_id, ',')))
		    AND ((@p_plant_id		IS NULL OR @p_plant_id	        = '') OR A.PLANT_ID       IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_plant_id, ',')))
		    AND ((@p_factory_id		IS NULL OR @p_factory_id		= '') OR A.FACTORY_ID     IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_factory_id, ',')))
		    AND ((@p_line_id		IS NULL OR @p_line_id			= '') OR A.LINE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_line_id, ',')))
		    AND A.VALID_YN = 'Y'
            AND A.COMPANY_ID    <> '-'
            AND A.DIVISION_ID   <> '-'
            AND A.SITE_ID       <> '-'
            AND A.PLANT_ID      <> '-'
            AND A.FACTORY_ID    <> '-'
            AND A.LINE_ID       <> '-'
    GROUP BY  A.DIVISION_ID
			, A.COMPANY_ID
			, A.SITE_ID
			, A.PLANT_ID
			, A.FACTORY_ID
			, A.LINE_ID
    ORDER BY  A.DIVISION_ID
			, A.COMPANY_ID
			, A.SITE_ID
	    	, A.PLANT_ID
    		, A.FACTORY_ID
		    , A.LINE_ID
END

