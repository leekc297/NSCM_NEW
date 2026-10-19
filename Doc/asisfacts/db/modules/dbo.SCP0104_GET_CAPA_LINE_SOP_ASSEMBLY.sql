
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : SCP0104_GET_CAPA_LINE_SOP_ASSEMBLY
 * Description  : CAPA LINE ASSING
 * Program History
 *================================================================================================================================================
 * Date         In Charge                          Description
 *================================================================================================================================================
 * 2024/08/26   chaan        V1.1.8                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial Release
*/

--CREATE PROCEDURE [dbo].[SCP0104_GET_CAPA_LINE_SOP_ASSEMBLY]
CREATE PROCEDURE [dbo].[SCP0104_GET_CAPA_LINE_SOP_ASSEMBLY]
	  @p_version			NVARCHAR(30)
	, @p_version_seq		TINYINT
	, @p_division_id		NVARCHAR(30)
	, @p_site_id			NVARCHAR(MAX)
	, @p_plant_id  			NVARCHAR(MAX)
	, @p_factory_id			NVARCHAR(MAX)
	, @p_line_id			NVARCHAR(MAX)
	, @p_operation_id		NVARCHAR(MAX)
    , @p_electrode_type		NVARCHAR(MAX)
	, @p_valid_flag			NVARCHAR(1)
	, @p_program_id			NVARCHAR(100)
	, @p_sheet_name			NVARCHAR(100)
	, @p_user_id			NVARCHAR(30)
	, @debug_mode			NVARCHAR(1)
AS
BEGIN
    SET NOCOUNT ON;

	--DECLARE @p_version			    NVARCHAR(30)        = N'202408';
	--DECLARE @p_version_seq		    TINYINT             = 3;
	--DECLARE @p_division_id		    NVARCHAR(30)		= N'81';
	--DECLARE @p_site_id			    NVARCHAR(MAX)		= N'';
	--DECLARE @p_plant_id  		    NVARCHAR(MAX)		= N'';
	--DECLARE @p_factory_id		    NVARCHAR(MAX)		= N'';
	--DECLARE @p_line_id			    NVARCHAR(MAX)		= N'';
	--DECLARE @p_operation_id		    NVARCHAR(MAX)		= N'';
	--DECLARE @p_electrode_type	    NVARCHAR(MAX)		= N'';
	--DECLARE @p_valid_flag		    NVARCHAR(1)			= N'';
	--DECLARE @p_program_id		    NVARCHAR(100)		= N'SCP0104';
	--DECLARE @p_sheet_name		    NVARCHAR(100)		= N'SOP_ASSEMBLY';
 --   DECLARE @p_user_id			    NVARCHAR(30)		= N'iamarock';
 --   DECLARE @debug_mode			    NVARCHAR(1)			= N'F';



	WITH tbl_CODE_ALL AS
	(
		SELECT  *
		FROM    SCP_MST_CAPA_LINE WITH(NOLOCK)
		WHERE   VALID_YN = 'Y'
	)
	,
	tbl_SITE AS
	(
		SELECT    SITE_ID
				, SITE_NAME
	    FROM    tbl_CODE_ALL
		GROUP BY  SITE_ID
				, SITE_NAME
	)
    ,
    tbl_COMPANY AS
	(
		SELECT    COMPANY_ID
				, COMPANY_NAME
		FROM    tbl_CODE_ALL
		GROUP BY  COMPANY_ID
				, COMPANY_NAME
	)
    ,
    tbl_PLANT AS
	(
		SELECT    PLANT_ID
				, PLANT_NAME
	    FROM    tbl_CODE_ALL
		GROUP BY  PLANT_ID
				, PLANT_NAME
	)
    ,
    tbl_FACTORY AS
	(
		SELECT    FACTORY_ID
				, FACTORY_NAME
		FROM    tbl_CODE_ALL
		GROUP BY  FACTORY_ID
				, FACTORY_NAME
	)
    ,
    tbl_LINE AS
	(
		SELECT    LINE_ID
				, LINE_NAME
		FROM    tbl_CODE_ALL
		GROUP BY  LINE_ID
				, LINE_NAME
	)
    ,
    tbl_OPERATION AS
    (
		SELECT    A.CODE
				, A.NAME
		FROM    (
					SELECT    A.OPERATION_ID        AS CODE
							, MAX(A.OPERATION_NAME) AS NAME
					FROM	[dbo].SCM_MST_OPERATION_SN A WITH(NOLOCK)
					GROUP BY  A.OPERATION_ID
					UNION ALL
					SELECT	  B.SEGMENT1   AS CODE
							, B.ATTRIBUTE1 AS NAME
					FROM    SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
							INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON 
									A.LOOKUP_TYPE = B.LOOKUP_TYPE
					WHERE	1=1
						AND A.LOOKUP_GROUP  = 'SCP'
						AND A.LOOKUP_TYPE   = 'CPS_FORMATION_OPERATION'
						AND B.VALID_YN      = 'Y'
					GROUP BY  B.SEGMENT1
							, B.ATTRIBUTE1
				) A
    )
	    SELECT	  A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.FACTORY_ID
			    , A.LINE_ID
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD
			    , A.VALID_YN
                --스프레드 셀타입을 DateText 로 설정하므로 변환필요!!!                , A.SOP_DT
    			, CONVERT(NVARCHAR(10), dbo.FN_CHAR_TO_DATE(A.SOP_DT), 121) AS SOP_DT--스프레드 셀타입을 DateText 로 설정하므로 변환필요!!!
                , A.SOP_YM
                , A.SOP_DDN
                , A.LAST_UPDATED_BY
                , A.LAST_UPDATE_DATE
			    , dbo.FN_GET_DIVISION_NAME (A.DIVISION_ID)              AS DIVISION_NAME
			    , S.SITE_NAME							                AS SITE_NAME
			    , C.COMPANY_NAME					                    AS COMPANY_NAME
			    , P.PLANT_NAME						                    AS PLANT_NAME
			    , F.FACTORY_NAME					                    AS FACTORY_NAME
			    , L.LINE_NAME							                AS LINE_NAME
                , O.NAME                                                AS OPERATION_NAME
	    FROM	SCP_MST_CAPA_LINE_SOP A WITH(NOLOCK)
			    LEFT JOIN tbl_SITE S WITH(NOLOCK) ON
					    A.SITE_ID		    = S.SITE_ID
			    LEFT JOIN tbl_COMPANY C WITH(NOLOCK) ON
					    A.COMPANY_ID		= C.COMPANY_ID
			    LEFT JOIN tbl_PLANT P WITH(NOLOCK) ON
					    A.PLANT_ID          = P.PLANT_ID
			    LEFT JOIN tbl_FACTORY F WITH(NOLOCK) ON
					    A.FACTORY_ID	    = F.FACTORY_ID
			    LEFT JOIN tbl_LINE L WITH(NOLOCK) ON
					    A.LINE_ID		    = L.LINE_ID
                LEFT JOIN tbl_OPERATION O ON
				        A.OPERATION_ID		= O.CODE
	        WHERE	1=1
		        AND ((@p_division_id	IS NULL OR @p_division_id	    = '') OR A.DIVISION_ID    IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_division_id, ',')))
		        AND ((@p_site_id  		IS NULL OR @p_site_id	        = '') OR A.SITE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_site_id, ',')))
		        AND ((@p_plant_id		IS NULL OR @p_plant_id	        = '') OR A.PLANT_ID       IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_plant_id, ',')))
		        AND ((@p_factory_id		IS NULL OR @p_factory_id		= '') OR A.FACTORY_ID     IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_factory_id, ',')))
		        AND ((@p_line_id		IS NULL OR @p_line_id			= '') OR A.LINE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_line_id, ',')))
		        AND ((@p_operation_id	IS NULL OR @p_operation_id		= '') OR A.OPERATION_ID   IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_operation_id, ',')))
		        AND ((@p_electrode_type	IS NULL OR @p_electrode_type	= '') OR A.ELTR_LN_TP_CD IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_electrode_type, ',')))
		        AND (@p_valid_flag	    IS NULL OR @p_valid_flag   		= '' OR @p_valid_flag = 'ALL' OR A.VALID_YN = @p_valid_flag)
        ORDER BY  A.DIVISION_ID
			    , S.SITE_ID
			    , C.COMPANY_ID
			    , P.PLANT_ID
			    , F.FACTORY_ID
			    , L.LINE_ID
                , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD
END

