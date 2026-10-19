
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : SCP0104_GET_CAPA_LINE_ASSIGN_MDL_ELTR
 * Description  : Line Assign 조립 팝업 조회용
 * Program History
 *================================================================================================================================================
 * Date         In Charge                          Description
 *================================================================================================================================================
 * 2024/08/30   chaan        V1.1.8                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial Release
 *                                                                                                           - 전극 Nickname 추가
*/

--CREATE PROCEDURE [dbo].[SCP0104_GET_CAPA_LINE_ASSIGN_MDL_ELTR]
CREATE PROCEDURE [dbo].[SCP0104_GET_CAPA_LINE_ASSIGN_MDL_ELTR]
	  @p_version			NVARCHAR(30)
	, @p_version_seq		TINYINT
	, @p_division_id		NVARCHAR(30)
	, @p_site_id			NVARCHAR(MAX)
	, @p_plant_id  			NVARCHAR(MAX)
	, @p_factory_id			NVARCHAR(MAX)
	, @p_line_id			NVARCHAR(MAX)
	, @p_operation_id		NVARCHAR(MAX)
	, @p_item_id		    NVARCHAR(MAX)
    , @p_electrode_type		NVARCHAR(MAX)
	, @p_program_id			NVARCHAR(100)
	, @p_sheet_name			NVARCHAR(100)
	, @p_user_id			NVARCHAR(30)
	, @debug_mode			NVARCHAR(1)
AS
BEGIN
    SET NOCOUNT ON;


	--DECLARE @p_version			    NVARCHAR(30)        = N'202408';
	--DECLARE @p_version_seq		    TINYINT             = 1;
	--DECLARE @p_division_id		    NVARCHAR(30)		= N'81';
	--DECLARE @p_site_id			    NVARCHAR(MAX)		= N'';
	--DECLARE @p_plant_id  		    NVARCHAR(MAX)		= N'';
	--DECLARE @p_factory_id		    NVARCHAR(MAX)		= N'';
	--DECLARE @p_line_id			    NVARCHAR(MAX)		= N'';
	--DECLARE @p_operation_id		    NVARCHAR(MAX)		= N'';
 --   DECLARE @p_item_id		        NVARCHAR(MAX)		= N'';
	--DECLARE @p_electrode_type	    NVARCHAR(MAX)		= N'';
	--DECLARE @p_program_id		    NVARCHAR(100)		= N'SCP0104';
	--DECLARE @p_sheet_name		    NVARCHAR(100)		= N'ELTR';
 --   DECLARE @p_user_id			    NVARCHAR(30)		= N'iamarock';
 --   DECLARE @debug_mode			    NVARCHAR(1)			= N'F';


    WITH tblVersion AS
    (
        SELECT    DIVISION_ID
                , MAX(VER_ID)          AS VER_ID
                , MAX(VER_SEQ)         AS VER_SEQ
                , CONVERT(NVARCHAR(6), DATEADD(MM, -1, CONVERT(DATETIME, MAX(VER_ID) + '01')), 112) AS RESULT_TO_YYYYMM
        FROM    SCP_MST_CAPA_VERSION A
        WHERE   1=1
            --AND VER_ID  = CAST(CONVERT(NVARCHAR(6), GETDATE(), 112) AS INT)
            AND PROG_STAT = '0'
        GROUP BY  DIVISION_ID
    )
    ,
    tbl_OPERATION_ELECTRODE_TYPE AS
	(
        SELECT    A.SEGMENT1		AS DIVISION_ID
                , A.SEGMENT2		AS OPERATION_ID 
                , A.SEGMENT3		AS ELTR_LN_TP_CD
                , A.ATTRIBUTE1		AS EQP_SPED_UNIT_CD
        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL A WITH(NOLOCK)
        WHERE   1=1
			--AND SEGMENT1 = 'SCP'
            AND A.LOOKUP_TYPE  = 'OPERATION_ELECTRODE_TYPE'
            AND A.VALID_YN  = 'Y'
	)
    ,
    tbl_SPEED_UNIT_ALL AS
	(
        SELECT    A.SEGMENT1        AS UNIT_GROUP
                , A.SEGMENT2        AS OPERATION_ID
                , A.SEGMENT3        AS MSR_TP_CD
                , A.SEGMENT4        AS LINE_TYPE
                , A.SEGMENT5        AS UNIT_GROUP_SEQ
                , A.DISPLAY_SEQ
        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL A WITH(NOLOCK)
        WHERE   1=1
			--AND SEGMENT1 = 'SCP'
            AND A.LOOKUP_TYPE  = 'OPERATION_SPEED_UNIT'
            AND A.VALID_YN  = 'Y'
	),
	tbl_SPEED_UNIT_GROUP_MSR AS
	(
        SELECT    A.UNIT_GROUP
                , A.MSR_TP_CD
                , MIN(A.DISPLAY_SEQ)      AS DISPLAY_SEQ
                , MAX(A.UNIT_GROUP_SEQ)   AS UNIT_GROUP_SEQ
        FROM    tbl_SPEED_UNIT_ALL A
        WHERE   1=1
            AND MSR_TP_CD <> 'M'
        GROUP BY  A.UNIT_GROUP
                , A.MSR_TP_CD
        --ORDER BY MIN(A.UNIT_GROUP_SEQ)
	)
    ,
	tbl_SPEED_UNIT_GROUP AS
	(
        SELECT    A.UNIT_GROUP
                , MAX(A.UNIT_GROUP_SEQ)   AS UNIT_GROUP_SEQ
        FROM    tbl_SPEED_UNIT_ALL A
        GROUP BY  A.UNIT_GROUP
        --ORDER BY MIN(A.DISPLAY_SEQ)
	)
    ,
	tblSCP0104_CODE_ALL AS
	(
		SELECT  *
		FROM    SCP_MST_CAPA_ELTR_LINE WITH(NOLOCK)
		WHERE   VALID_YN = 'Y'
	)
	,
	tblSCP0104_SITE AS
	(
		SELECT    SITE_ID
				, SITE_NAME
	    FROM    tblSCP0104_CODE_ALL
		GROUP BY  SITE_ID
				, SITE_NAME
	)
    ,
    tblSCP0104_COMPANY AS
	(
		SELECT    COMPANY_ID
				, COMPANY_NAME
		FROM    tblSCP0104_CODE_ALL
		GROUP BY  COMPANY_ID
				, COMPANY_NAME
	)
    ,
    tblSCP0104_PLANT AS
	(
		SELECT    PLANT_ID
				, PLANT_NAME
	    FROM    tblSCP0104_CODE_ALL
		GROUP BY  PLANT_ID
				, PLANT_NAME
	)
    ,
    tblSCP0104_FACTORY AS
	(
		SELECT    FACTORY_ID
				, FACTORY_NAME
		FROM    tblSCP0104_CODE_ALL
		GROUP BY  FACTORY_ID
				, FACTORY_NAME
	)
    ,
    tblSCP0104_LINE AS
	(
		SELECT    LINE_ID
				, LINE_NAME
		FROM    tblSCP0104_CODE_ALL
		GROUP BY  LINE_ID
				, LINE_NAME
	)
    ,
    tbl_OPERATION AS
    (
	    SELECT    OPERATION_ID      AS CODE
			    , OPERATION_NAME    AS NAME
	    FROM	[dbo].SCM_MST_OPERATION_SN WITH(NOLOCK)
        GROUP BY  OPERATION_ID 
			    , OPERATION_NAME
    )
    ,
 ------   tblSCP_NICKNAME_ELTR AS
	------(
 ------       SELECT    DIVISION_ID
 ------               , SITE_ID
 ------               , COMPANY_ID
 ------               , ITEM_ID
 ------               , NICK_NAME
 ------       FROM    SCM_MST_ITEM_SN WITH(NOLOCK)
 ------       WHERE   1=1
 ------           AND SCP_OPERATION_GROUP = 'E'
 ------           AND ACTIVE_FLAG         = 'Y'
	------)
 ------   ,
    tbl_Raw AS
    (
		SELECT	  V.VER_ID
				, V.VER_SEQ
				, A.DIVISION_ID
				, A.COMPANY_ID
				, A.SITE_ID
				, A.PLANT_ID
				, A.FACTORY_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				------, A.ITEM_ID
		FROM    SCP_MST_CAPA_ELTR_LINE_ASSIGN A WITH(NOLOCK)
                LEFT JOIN tblVersion V ON
                        A.DIVISION_ID = V.DIVISION_ID
		WHERE   1=1
			AND VALID_YN = 'Y'
		    AND ((@p_division_id	IS NULL OR @p_division_id	    = '') OR A.DIVISION_ID    IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_division_id, ',')))
		    AND ((@p_site_id  		IS NULL OR @p_site_id	        = '') OR A.SITE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_site_id, ',')))
		    AND ((@p_plant_id		IS NULL OR @p_plant_id	        = '') OR A.PLANT_ID       IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_plant_id, ',')))
		    AND ((@p_factory_id		IS NULL OR @p_factory_id		= '') OR A.FACTORY_ID     IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_factory_id, ',')))
		    AND ((@p_line_id		IS NULL OR @p_line_id			= '') OR A.LINE_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_line_id, ',')))
		    AND ((@p_operation_id	IS NULL OR @p_operation_id		= '') OR A.OPERATION_ID   IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_operation_id, ',')))
		    AND ((@p_electrode_type	IS NULL OR @p_electrode_type	= '') OR A.ELTR_LN_TP_CD  IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_electrode_type, ',')))
		    ------AND ((@p_item_id	    IS NULL OR @p_item_id	        = '') OR A.ITEM_ID        IN (SELECT TOKEN FROM dbo.STRING_SPLIT(@p_item_id, ',')))
        GROUP BY  V.VER_ID
				, V.VER_SEQ
				, A.DIVISION_ID
				, A.COMPANY_ID
				, A.SITE_ID
				, A.PLANT_ID
				, A.FACTORY_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				------, A.ITEM_ID
    )
		SELECT	  A.VER_ID
				, A.VER_SEQ
				, A.DIVISION_ID
				, A.COMPANY_ID
				, A.SITE_ID
				, A.PLANT_ID
				, A.FACTORY_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
			    , dbo.FN_GET_DIVISION_NAME (A.DIVISION_ID)		        AS DIVISION_NAME
			    , S.SITE_NAME							                AS SITE_NAME
			    , C.COMPANY_NAME					                    AS COMPANY_NAME
			    , P.PLANT_NAME						                    AS PLANT_NAME
			    , F.FACTORY_NAME					                    AS FACTORY_NAME
			    , L.LINE_NAME							                AS LINE_NAME
                , O.NAME                                                AS OPERATION_NAME
		FROM    tbl_Raw A
				LEFT JOIN tblSCP0104_SITE S WITH(NOLOCK) ON
					    A.SITE_ID		    = S.SITE_ID
			    LEFT JOIN tblSCP0104_COMPANY C WITH(NOLOCK) ON
					    A.COMPANY_ID		= C.COMPANY_ID
			    LEFT JOIN tblSCP0104_PLANT P WITH(NOLOCK) ON
					    A.PLANT_ID          = P.PLANT_ID
			    LEFT JOIN tblSCP0104_FACTORY F WITH(NOLOCK) ON
					    A.FACTORY_ID	    = F.FACTORY_ID
			    LEFT JOIN tblSCP0104_LINE L WITH(NOLOCK) ON
					    A.LINE_ID		    = L.LINE_ID
                LEFT JOIN tbl_OPERATION O ON
				        A.OPERATION_ID		= O.CODE
        ------        LEFT JOIN tblSCP_NICKNAME_ELTR K ON
					   ------ A.DIVISION_ID		= K.DIVISION_ID
				    ------AND A.COMPANY_ID		= K.COMPANY_ID
				    ------AND A.SITE_ID			= K.SITE_ID
				    ------AND A.ITEM_ID			= K.ITEM_ID
		ORDER BY  A.VER_ID
				, A.VER_SEQ
				, A.DIVISION_ID
			    , A.SITE_ID
			    , A.COMPANY_ID
			    , A.PLANT_ID
			    , A.FACTORY_ID
			    , A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				------, A.ITEM_ID

END

