

/*
 * Program ID   : PR_UI_FP00731_STOCK
 * Description  : Stock
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/06/16   CYS				Initial Release UI통합
 --                       2024-03-15 chkim.68 하드코딩 전환 (ref scm_code_lookup_value )
*/

CREATE PROCEDURE [dbo].[PR_UI_FP00731_STOCK_NEW]
  @p_sys_type			NVARCHAR(MAX),
  @p_sys_flag			NVARCHAR(MAX),
  @p_sys_gubun			NVARCHAR(MAX),
  @p_user_id			NVARCHAR(MAX),
  @p_division_id		NVARCHAR(MAX),
  @p_site_id			NVARCHAR(MAX),
  @p_plant_id			NVARCHAR(MAX),
  @p_factory_id			NVARCHAR(MAX),
  @p_operation_id		NVARCHAR(MAX),
  @p_item_id			NVARCHAR(MAX),
  @p_nick_name			NVARCHAR(MAX),
  @p_stock_type			NVARCHAR(MAX),
  @p_fp_apply_item_id	NVARCHAR(MAX),
  @p_packer				NVARCHAR(MAX),
  @p_status				NVARCHAR(MAX),
  @p_cutoff_date		NVARCHAR(MAX),
  @p_is_all_fac			NVARCHAR(MAX)

AS

BEGIN

    SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @v_proc_name	nvarchar(100) = 'PR_UI_FP00731_STOCK';
	DECLARE @runstart		datetime;
	DECLARE @runend			datetime;
	DECLARE @v_dSql			nvarchar(MAX)='';


	BEGIN

		SET @p_fp_apply_item_id = @p_item_id;	-- 화면단에서 item_id 로 넘어와 변경

		SET	@v_dSql = ''

	    SET @v_dSql +=	'	IF object_id(''tempdb.dbo.#FP_USER_ROLE_INFO_V_TEMP'') is not null DROP TABLE #FP_USER_ROLE_INFO_V_TEMP; ' + char(10)
		SET @v_dSql +=	'	IF object_id(''tempdb.dbo.#FP_USER_ROLE_INFO_V_TEMP2'') is not null DROP TABLE #FP_USER_ROLE_INFO_V_TEMP2; ' + char(10)+ char(10)

		SET @v_dSql +=	'	SELECT DISTINCT  B.COMPANY_ID ,B.DIVISION_ID,B.SITE_ID,B.PLANT_ID INTO #FP_USER_ROLE_INFO_V_TEMP ' + char(10)
		SET @v_dSql +=	'	FROM FP_USER_ROLE_INFO_V B WHERE B.USER_ID = '''+ @p_user_id +''' AND B.SAVE_FLAG = ''Y'' ; ' + char(10)+ char(10)

		SET @v_dSql +=	'	SELECT DISTINCT  B.COMPANY_ID ,B.DIVISION_ID,B.SITE_ID,B.PLANT_ID INTO #FP_USER_ROLE_INFO_V_TEMP2 ' + char(10)
		SET @v_dSql +=	'	FROM FP_USER_ROLE_INFO_V B WHERE B.USER_ID = '''+ @p_user_id +''' ; ' + char(10)+ char(10)

		SELECT @v_dSql += N'	SELECT A.*																																																									' + char(10)
		SELECT @v_dSql += N'		   , B.MODIFY_DESCRIPTION, B.UPDATE_ID, CONVERT(VARCHAR, B.UPDATE_TIME, 20) AS UPDATE_TIME                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'		   , (CASE WHEN R.COMPANY_ID IS NULL THEN ''N'' ELSE ''Y'' END) AS EDIT_YN                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'	FROM 	(                                                                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'			  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.STORAGE_ID, CONVERT(VARCHAR,A.CUTOFF_DATE,112) AS CUTOFF_DATE, SEQ,                                                                                    ' + char(10)
		SELECT @v_dSql += N'			          CASE WHEN A.STOCK_TYPE = ''WIP'' THEN ''GMES'' WHEN A.STOCK_TYPE = ''INVENTORY'' THEN ''ERP'' ELSE A.STOCK_TYPE END AS STOCK_TYPE                                                                                         ' + char(10)
		SELECT @v_dSql += N'			          ,A.SECOND_OCV_EXP_DATE   AS SECOND_OCV_EXP_DATE,   A.FP_APPLY_ITEM_ID, A.NICK_NAME, A.LANE, A.FP_APPLY_OPERATION_ID,  A.OPERATION_ID , A.WIPHOLD_YN, A.QMS_HOLD_YN,                                        ' + char(10)
		SELECT @v_dSql += N'			          FP_APPLY_WIPQTY_SUM AS FP_APPLY_WIPQTY,                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'			          QTY2_SUM AS QTY2,                                                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'			          MODIFY_FP_APPLY_WIPQTY_MAX AS MODIFY_FP_APPLY_WIPQTY,                                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'			          CAL_QTY_SUM AS CAL_QTY,                                                                                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'			          A.ITEM_UOM, A.ITEM_UOM AS QTY_UOM                                                                                                                                                                                         ' + char(10)
		SELECT @v_dSql += N'			          , A.LOCATION                                                                                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'			          , A.PACK_MOVE_QTY_SUM                                                                                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'			          , A.PRODUCTION_TYPE ' + char(10)
		--SELECT @v_dSql += N'			          , A.LINE_ID, A.STOCK_STATUS, A.WIP_TYPE_CODE, A.AVAILABLE_DATE ' + char(10)
		SELECT @v_dSql += N'			          , A.LINE_ID, A.STOCK_STATUS, A.WIP_TYPE_CODE, A.UNHOLD_EXP_DATE AS AVAILABLE_DATE ' + char(10)
		SELECT @v_dSql += N'			          , A.LOT_COUNT_SUM AS LOT_COUNT   ' + char(10)
		SELECT @v_dSql += N'			          , A.LONG_TERM_FLAG ' + char(10)
		SELECT @v_dSql += N'			          , A.QLTY_NO_INSP_FLAG ' + char(10)
		SELECT @v_dSql += N'			          , A.POSITION_CATEGORY ' + char(10)
		SELECT @v_dSql += N'			          , A.DETAIL_POSITION ' + char(10)

		SELECT @v_dSql += N'			          , A.PACK_MOVE_FLAG ' + char(10)
		SELECT @v_dSql += N'			          , A.FROM_PLANT_ID ' + char(10)

		SELECT @v_dSql += N'			          , A.WORK_REQUEST_MODEL_ID ' + char(10)
		SELECT @v_dSql += N'			          , A.VERSION ' + char(10)
		SELECT @v_dSql += N'			          , A.PROD_SEQ ' + char(10)
		SELECT @v_dSql += N'			          , A.PLM_EC_NO ' + char(10)
		SELECT @v_dSql += N'			          , A.SPECIAL_STOCK_INDICATOR ' + char(10) -- 특별 지시 재고 추가

		SELECT @v_dSql += N'			  FROM   ( ' + char(10)
		SELECT @v_dSql += N'				          SELECT A.*, B.ITEM_UOM, B.NICK_NAME ' + char(10)
		SELECT @v_dSql += N'				                  , DENSE_RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,A.OPERATION_ID, A.FACTORY_ID, A.STORAGE_ID, A.CUTOFF_DATE, ' + char(10)
		SELECT @v_dSql += N'				                                                      A.STOCK_TYPE, A.FP_APPLY_ITEM_ID, B.NICK_NAME, A.LANE, A.FP_APPLY_OPERATION_ID, A.WIPHOLD_YN, A.QMS_HOLD_YN, B.ITEM_UOM, A.LOCATION, A.PRODUCTION_TYPE ' + char(10)
		SELECT @v_dSql += N'				                                                      , A.LINE_ID, A.STOCK_STATUS, A.WIP_TYPE_CODE, A.AVAILABLE_DATE, A.LONG_TERM_FLAG, A.QLTY_NO_INSP_FLAG, A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PLM_EC_NO ' + char(10)
		SELECT @v_dSql += N'				                                      ORDER     BY CASE WHEN A.OPERATION_ID = ''A6000'' THEN 2 ELSE 1 END ' + char(10)
		SELECT @v_dSql += N'				                                                  , A.SEQ) AS RANK_SEQ ' + char(10)
		SELECT @v_dSql += N'				                  , SUM(A.FP_APPLY_WIPQTY) OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,A.OPERATION_ID, A.FACTORY_ID, A.STORAGE_ID, A.CUTOFF_DATE, ' + char(10)
		SELECT @v_dSql += N'				                                                      A.STOCK_TYPE, A.FP_APPLY_ITEM_ID, B.NICK_NAME, A.LANE, A.FP_APPLY_OPERATION_ID, A.WIPHOLD_YN, A.QMS_HOLD_YN, B.ITEM_UOM, A.LOCATION, A.PRODUCTION_TYPE ' + char(10)
		SELECT @v_dSql += N'				                                                      , A.LINE_ID, A.STOCK_STATUS, A.WIP_TYPE_CODE, A.AVAILABLE_DATE, A.LONG_TERM_FLAG, A.QLTY_NO_INSP_FLAG, A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PLM_EC_NO	) AS FP_APPLY_WIPQTY_SUM																							' + char(10)
		SELECT @v_dSql += N'				                  , MAX(A.MODIFY_FP_APPLY_WIPQTY) OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,A.OPERATION_ID, A.FACTORY_ID, A.STORAGE_ID, A.CUTOFF_DATE, ' + char(10)
		SELECT @v_dSql += N'				                                                      A.STOCK_TYPE, A.FP_APPLY_ITEM_ID, B.NICK_NAME, A.LANE, A.FP_APPLY_OPERATION_ID, A.WIPHOLD_YN, A.QMS_HOLD_YN, B.ITEM_UOM, A.LOCATION, A.PRODUCTION_TYPE ' + char(10)
		SELECT @v_dSql += N'				                                                      , A.LINE_ID, A.STOCK_STATUS, A.WIP_TYPE_CODE, A.AVAILABLE_DATE, A.LONG_TERM_FLAG, A.QLTY_NO_INSP_FLAG, A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PLM_EC_NO	) AS MODIFY_FP_APPLY_WIPQTY_MAX ' + char(10)

		SELECT @v_dSql += N'				                  , SUM(A.QTY2)    OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID,A.FACTORY_ID, A.STORAGE_ID, A.CUTOFF_DATE, ' + char(10)
		SELECT @v_dSql += N'				                                                      A.STOCK_TYPE, A.FP_APPLY_ITEM_ID, B.NICK_NAME, A.LANE, A.FP_APPLY_OPERATION_ID, A.WIPHOLD_YN, A.QMS_HOLD_YN, B.ITEM_UOM, A.LOCATION, A.PRODUCTION_TYPE ' + char(10)
		SELECT @v_dSql += N'				                                                      , A.LINE_ID, A.STOCK_STATUS, A.WIP_TYPE_CODE, A.AVAILABLE_DATE, A.LONG_TERM_FLAG, A.QLTY_NO_INSP_FLAG, A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PLM_EC_NO	) AS QTY2_SUM       																							' + char(10)

		SELECT @v_dSql += N'				                  , SUM(A.CAL_QTY) OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID,A.FACTORY_ID, A.STORAGE_ID, A.CUTOFF_DATE, ' + char(10)
		SELECT @v_dSql += N'				                                                  A.STOCK_TYPE, A.FP_APPLY_ITEM_ID, B.NICK_NAME, A.LANE, A.FP_APPLY_OPERATION_ID, A.WIPHOLD_YN, A.QMS_HOLD_YN, B.ITEM_UOM, A.LOCATION, A.PRODUCTION_TYPE ' + char(10)
		SELECT @v_dSql += N'				                                                      , A.LINE_ID, A.STOCK_STATUS, A.WIP_TYPE_CODE, A.AVAILABLE_DATE, A.LONG_TERM_FLAG, A.QLTY_NO_INSP_FLAG, A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PLM_EC_NO	) AS CAL_QTY_SUM ' + char(10)

		SELECT @v_dSql += N'						          , SUM(A.PACK_MOVE_QTY) OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,A.OPERATION_ID, A.FACTORY_ID, A.STORAGE_ID, A.CUTOFF_DATE, ' + char(10)
		SELECT @v_dSql += N'				                  				                            A.STOCK_TYPE, A.FP_APPLY_ITEM_ID, B.NICK_NAME, A.LANE, A.FP_APPLY_OPERATION_ID, A.WIPHOLD_YN, A.QMS_HOLD_YN, B.ITEM_UOM, A.LOCATION, A.PRODUCTION_TYPE ' + char(10)
		SELECT @v_dSql += N'				                                                      , A.LINE_ID, A.STOCK_STATUS, A.WIP_TYPE_CODE, A.AVAILABLE_DATE, A.LONG_TERM_FLAG, A.QLTY_NO_INSP_FLAG, A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PLM_EC_NO	) AS PACK_MOVE_QTY_SUM ' + char(10)
		SELECT @v_dSql += N'						          , SUM(A.LOT_COUNT) OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID,A.FACTORY_ID, A.STORAGE_ID, A.CUTOFF_DATE, ' + char(10)
		SELECT @v_dSql += N'				                  				                            A.STOCK_TYPE, A.FP_APPLY_ITEM_ID, B.NICK_NAME, A.LANE, A.FP_APPLY_OPERATION_ID, A.WIPHOLD_YN, A.QMS_HOLD_YN, B.ITEM_UOM, A.LOCATION, A.PRODUCTION_TYPE ' + char(10)
		SELECT @v_dSql += N'				                                                      , A.LINE_ID, A.STOCK_STATUS, A.WIP_TYPE_CODE, A.AVAILABLE_DATE, A.LONG_TERM_FLAG, A.QLTY_NO_INSP_FLAG, A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PLM_EC_NO	) AS LOT_COUNT_SUM ' + char(10)
		SELECT @v_dSql += N'				          FROM   SCM_STOCK_H A WITH(NOLOCK) JOIN SCM_ITEM_M B WITH(NOLOCK) ' + char(10)

		SELECT @v_dSql += N'				          ON     A.FP_APPLY_ITEM_ID = B.ITEM_ID ' + char(10)
		SELECT @v_dSql += N'				          AND    A.COMPANY_ID       = B.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'				          AND    A.DIVISION_ID      = B.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'				          AND    A.SITE_ID          = B.SITE_ID ' + char(10)

		SELECT @v_dSql += N'				          JOIN   #FP_USER_ROLE_INFO_V_TEMP2 BT WITH(NOLOCK) ' + char(10)
		SELECT @v_dSql += N'				          ON     A.COMPANY_ID  = BT.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'				          AND    A.DIVISION_ID = BT.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'				          AND    A.SITE_ID     = BT.SITE_ID ' + char(10)
		SELECT @v_dSql += N'				          AND    A.PLANT_ID    = BT.PLANT_ID ' + char(10)
		SELECT @v_dSql += N'				          WHERE  1 = 1                                                                                                                                                                                 ' + char(10)
		--SELECT @v_dSql += N'				          WHERE  A.FP_APPLY_ITEM_ID = B.ITEM_ID                                                                                                                                                                                 ' + char(10)
		--SELECT @v_dSql += N'				          AND    A.COMPANY_ID       = B.COMPANY_ID                                                                                                                                                                              ' + char(10)
		--SELECT @v_dSql += N'				          AND    A.DIVISION_ID      = B.DIVISION_ID                                                                                                                                                                             ' + char(10)
		--SELECT @v_dSql += N'				          AND    A.SITE_ID          = B.SITE_ID                                                                                                                                                                                 ' + char(10)
		SELECT @v_dSql += N'				          AND    A.CUTOFF_DATE		= CONVERT(DATE, '''+ @p_cutoff_date +''' )                                                                                                                                                              ' + char(10)

		--SELECT @v_dSql += N'				          AND    ((A.STORAGE_ID  BETWEEN ''1000'' AND ''1999'') OR (A.STORAGE_ID >= ''5000'' AND A.STORAGE_ID < ''6000'') OR (ISNULL(A.FP_APPLY_WIPQTY, 0) >= 0))                                                               ' + char(10)
		SELECT @v_dSql += N'((A.STORAGE_ID >= (SELECT TOP 1 SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE=''PR_UI_FP00731_STOCK_NEW'' AND SEGMENT1  = ''2'' AND ACTIVE_FLAG = ''Y'' AND ATTRIBUTE3=''MIN'') ' + char(10)
		SELECT @v_dSql += N'AND A.STORAGE_ID < (SELECT TOP 1 SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE=''PR_UI_FP00731_STOCK_NEW'' AND SEGMENT1  = ''2'' AND ACTIVE_FLAG = ''Y'' AND ATTRIBUTE3=''MAX'') )' +char(10)
		SELECT @v_dSql += N'OR (A.STORAGE_ID >= (SELECT TOP 1 SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE=''PR_UI_FP00731_STOCK_NEW'' AND SEGMENT1  = ''1'' AND ACTIVE_FLAG = ''Y'' AND ATTRIBUTE3=''MIN'') ' + char(10)
		SELECT @v_dSql += N'AND A.STORAGE_ID < (SELECT TOP 1 SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE=''PR_UI_FP00731_STOCK_NEW'' AND SEGMENT1  = ''1'' AND ACTIVE_FLAG = ''Y'' AND ATTRIBUTE3=''MAX'') ))' +char(10)


		SELECT @v_dSql += N'				          AND     B.ITEM_CLASS IN (SELECT CLASS_ID FROM SCM_ITEM_CLASS_M WHERE  USE_FLAG = ''Y'')                                                                                                                               ' + char(10)

		SELECT @v_dSql += N'				          AND    ISNULL(A.SPECIAL_STOCK_INDICATOR, '''') NOT IN (''W'', ''E'', ''O'') ' + char(10) -- 특별 지시 재고 추가




		--SELECT @v_dSql += N'								  AND    EXISTS (                                                                                                                                                                                               ' + char(10)
		--SELECT @v_dSql += N'										SELECT 1                                                                                                                                                                                                ' + char(10)
		--SELECT @v_dSql += N'										FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                                                                                                                                                               ' + char(10)
		--SELECT @v_dSql += N'										WHERE  A.COMPANY_ID  = B.COMPANY_ID                                                                                                                                                                     ' + char(10)
		--SELECT @v_dSql += N'										AND    A.DIVISION_ID = B.DIVISION_ID                                                                                                                                                                    ' + char(10)
		--SELECT @v_dSql += N'										AND    A.SITE_ID     = B.SITE_ID                                                                                                                                                                        ' + char(10)
		--SELECT @v_dSql += N'										AND    A.PLANT_ID    = B.PLANT_ID                                                                                                                                                                       ' + char(10)
		--SELECT @v_dSql += N'										AND    B.USER_ID     = '''+ @p_user_id +'''                                                                                                                                                                        ' + char(10)
		--SELECT @v_dSql += N'								  )                                                                                                                                                                                                             ' + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)

		IF ( @p_factory_id != '' AND @p_factory_id IS NOT NULL AND @p_is_all_fac = 'Y' ) BEGIN
			SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL](' ( A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			SET @v_dSql += '	OR A.FACTORY_ID = ''-''	'
			SET @v_dSql += ' )	'
		END ELSE BEGIN
			SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		END

		-- Factory 정보에 All 로 넘어올 경우 '-' 조건이 붙어야 한다. IS_ALL_FAC  조건
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_APPLY_OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.STOCK_TYPE' , 'EQ', @p_stock_type)) + char(10)
		--SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_APPLY_ITEM_ID' , 'LIKE', @p_fp_apply_item_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OUTSOURCING_FACTORY' , 'LIKE', @p_packer)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)

		SELECT @v_dSql += N'				  ) A ' + char(10)
		SELECT @v_dSql += N'				  WHERE  RANK_SEQ = 1 ' + char(10)
		SELECT @v_dSql += N'			) A ' + char(10)
		SELECT @v_dSql += N'			LEFT OUTER JOIN #FP_USER_ROLE_INFO_V_TEMP R WITH(NOLOCK) ' + char(10)

		--SELECT @v_dSql += N'			LEFT OUTER JOIN ( ' + char(10)
		--SELECT @v_dSql += N'			   SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID -- FACTORY_ID, OPERATION_ID (null, ''-'') value exists... ' + char(10)
		--SELECT @v_dSql += N'			   FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK) ' + char(10)
		--SELECT @v_dSql += N'			   WHERE  R.USER_ID   = '''+ @p_user_id +''' ' + char(10)
		--SELECT @v_dSql += N'			   AND    R.SAVE_FLAG = ''Y'' ' + char(10)
		--SELECT @v_dSql += N'			) R ' + char(10)

		SELECT @v_dSql += N'			ON   A.COMPANY_ID   = R.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'			AND  A.DIVISION_ID  = R.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'			AND  A.SITE_ID      = R.SITE_ID ' + char(10)
		SELECT @v_dSql += N'			AND  A.PLANT_ID     = R.PLANT_ID ' + char(10)


		SELECT @v_dSql += N'			, SCM_STOCK_H B WITH(NOLOCK) ' + char(10)


		SELECT @v_dSql += N'	WHERE A.COMPANY_ID  = B.COMPANY_ID ' + char(10)
		SELECT @v_dSql += N'	AND   A.DIVISION_ID = B.DIVISION_ID ' + char(10)
		SELECT @v_dSql += N'	and   A.SITE_ID     = B.SITE_ID ' + char(10)
		SELECT @v_dSql += N'	and   A.PLANT_ID    = B.PLANT_ID ' + char(10)
		SELECT @v_dSql += N'	and   A.FACTORY_ID  = B.FACTORY_ID ' + char(10)
		SELECT @v_dSql += N'	and   A.STORAGE_ID  = B.STORAGE_ID ' + char(10)
		SELECT @v_dSql += N'	and   A.CUTOFF_DATE = B.CUTOFF_DATE ' + char(10)
		SELECT @v_dSql += N'	and   A.SEQ         = B.SEQ ' + char(10)
		--SELECT @v_dSql += N'	ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.STORAGE_ID, A.CUTOFF_DATE,                                                                                                                                     ' + char(10)
		--SELECT @v_dSql += N'	       A.STOCK_TYPE, A.FP_APPLY_ITEM_ID, A.NICK_NAME, A.LANE, A.FP_APPLY_OPERATION_ID, A.ITEM_UOM                                                                                                                                           ' + char(10)

		SELECT @v_dSql += N'	ORDER BY A.STOCK_TYPE, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.FP_APPLY_OPERATION_ID, A.LINE_ID, A.STORAGE_ID, A.CUTOFF_DATE,                                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'	       A.FP_APPLY_ITEM_ID, A.NICK_NAME, A.LANE, A.ITEM_UOM ' + char(10)+ char(10)

		SET @v_dSql +=	'	IF object_id(''tempdb.dbo.#FP_USER_ROLE_INFO_V_TEMP'') is not null DROP TABLE #FP_USER_ROLE_INFO_V_TEMP; ' + char(10)
	    SET @v_dSql +=	'	IF object_id(''tempdb.dbo.#FP_USER_ROLE_INFO_V_TEMP2'') is not null DROP TABLE #FP_USER_ROLE_INFO_V_TEMP2; ' + char(10)












	END

	IF @p_sys_type = 'SQL'
    BEGIN
		select @v_dSql as [QUERY_VALUE]
		--DECLARE @POS INT = 1;
		--DECLARE @LEN INT = LEN(@v_dSql);

		--WHILE @POS <= @LEN
		--BEGIN
		--	PRINT SUBSTRING (@v_dSql, @POS, 4000);
		--	SET @POS = @POS + 4000;
		--END




    END ELSE BEGIN


		SET @runstart = GetDate()
		BEGIN TRY
		     BEGIN TRAN
	             exec sp_executesql @v_dSql
		     COMMIT TRAN
		END TRY
        BEGIN CATCH
             ROLLBACK
        END CATCH
	    SET @runend = GetDate()
		exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql,'SELECT',@runstart, @runend
    END


END
