

/*
 * Program ID   : [SCP0113_GET_LGTM_ITEM_TYPE_QTY_INPUT_EXCEPTION]
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge			Description
 *===================================================================================================
 * 2024/12/24   TanVQ1				Create new procedure to get Monthly Input Exception by Item_type and exht_tp_cd
 */

CREATE PROCEDURE [dbo].[SCP0113_GET_LGTM_DETAIL_FOR_EXPORT] 
	@p_plan_date			NVARCHAR(8),
	@p_division_id			NVARCHAR(500),	
	@p_creation_type		NVARCHAR(500),
	@p_group_code			NVARCHAR(500),
	@p_item_type			NVARCHAR(500),
	@p_item_id				NVARCHAR(500),
	@p_end_month			NVARCHAR(6),
	@p_plant_id				NVARCHAR(500),
	@debug_mode				NVARCHAR(1) = 'T'
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 
	
	------------------------------------------------------------------------
	-- LOG 용 변수 설정
	------------------------------------------------------------------------
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0113_GET_LGTM_DETAIL_FOR_EXPORT';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	------------------------------------------------------------------------  

	------------------------------------------------------------------------
	-- LOG 시작
	------------------------------------------------------------------------
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########'; 
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	------------------------------------------------------------------------  
	
	SELECT * FROM (
		SELECT SUM.PLAN_START_YYYYMMDD                      AS PLAN_DATE
			  ,SUM.DIVISION_ID                              AS DIV
			  ,SUM.ORIGIN_DIVISION_ID                       AS ORIGIN_DIV
			  ,'*'                                          AS PLANT_ID
			  ,N'완제품'                                     AS PLAN_TYPE
			  ,SUM.GROUP_CODE1                              AS GROUP_CODE
			  ,SUM.ITEM_ID                                  AS MATERIAL
			  ,SUM.ORIGIN_ITEM_ID                           AS ORIGIN_MATERIAL
			  ,CASE WHEN SUM.DATA_TP_CD = 'BOH' THEN 1
					WHEN SUM.DATA_TP_CD = 'P'   THEN 2
					WHEN SUM.DATA_TP_CD = 'S'   THEN 3
					WHEN SUM.DATA_TP_CD = 'EOH' THEN 4 END  AS SORT
			  ,(SELECT  LK.ATTRIBUTE1
				FROM    SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
				WHERE   1=1
				AND     LK.LOOKUP_TYPE  = 'SCM_LGTM_CODE_NAME_FOR_LGTM'
				AND     LK.VALID_YN     = 'Y'
				AND     LK.SEGMENT1     = 'DATA_TP_CD'
				AND     LK.SEGMENT2     = SUM.DATA_TP_CD)   AS DATA_TP_CD
			  ,(SELECT  LK.ATTRIBUTE1
				FROM    SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
				WHERE   1=1
				AND     LK.LOOKUP_TYPE  = 'SCM_LGTM_CODE_NAME_FOR_LGTM'
				AND     LK.VALID_YN     = 'Y'
				AND     LK.SEGMENT1     = 'SRCE_TP_CD'
				AND     LK.SEGMENT2     = SUM.DATA_TP_CD
				AND     LK.SEGMENT3     = SUM.SRCE_TP_CD)   AS SRCE_TP_CD
			  ,CASE WHEN SUM.DATA_TP_CD IN ( 'BOH', 'EOH' ) THEN SUM.LONG_TERM_TYPE 
			   ELSE '-' END AS LONG_TERM_TYPE
			  ,SUM.PLAN_YYYYMM                              AS PLAN_YYYYMM
			  ,SUM.SRCE_YYYYMM                              AS SOURCE_YYYYMM
			  ,SUM(SUM.QTY)                                 AS QTY 
			  ,MAX(SUM.STANDARD_COST)                       AS PRICE
			  ,SUM(SUM.AMT)                                 AS AMT 
		FROM  SCM_LGTM_INV_PSI_SUMMARY SUM
        LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
            ON  LK.SEGMENT2     = SUM.DATA_TP_CD
            AND LK.SEGMENT3     = SUM.SRCE_TP_CD 
            AND LK.LOOKUP_TYPE  = 'SCM_LGTM_CODE_NAME_FOR_LGTM'
            AND LK.VALID_YN     = 'Y'
            AND LK.SEGMENT1     = 'SRCE_TP_CD'
		WHERE 1=1
		AND   DATA_TP_CD     <> 'RESULT'
		AND   SUM.PLAN_TP_CD  = 'FERT_INIT'
		AND	  SUM.PLAN_START_YYYYMMDD = @p_plan_date
		AND	  ( ISNULL(@p_division_id, '') = '' OR SUM.DIVISION_ID	IN (SELECT token FROM dbo.String_Split(@p_division_id,',')) )
		AND	  ( ISNULL(@p_creation_type, '') = '' OR LK.ATTRIBUTE1	IN (SELECT token FROM dbo.String_Split(@p_creation_type,',')) )
		AND	  ( ISNULL(@p_group_code, '')	= '' OR SUM.GROUP_CODE1 IN (SELECT token FROM dbo.String_Split(@p_group_code,',')) )
		AND	  ( ISNULL(@p_item_id	, '')	= '' OR SUM.ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id,',')) )
		AND	  SUM.PLAN_YYYYMM <= @p_end_month
		GROUP BY SUM.PLAN_START_YYYYMMDD
			  ,SUM.DIVISION_ID
			  ,SUM.ORIGIN_DIVISION_ID
			  ,SUM.GROUP_CODE1
			  ,SUM.ITEM_ID
			  ,SUM.ORIGIN_ITEM_ID
			  ,SUM.DATA_TP_CD
			  ,SUM.SRCE_TP_CD
			  ,SUM.LONG_TERM_TYPE 
			  ,SUM.SRCE_YYYYMM
			  ,SUM.PLAN_YYYYMM
		------------------------------------------------------------------------------
		UNION ALL
		------------------------------------------------------------------------------
		-- 반제품
		------------------------------------------------------------------------------
		SELECT SUM.PLAN_START_YYYYMMDD                      AS PLAN_DATE
			  ,SUM.DIVISION_ID                              AS DIV
			  ,SUM.DIVISION_ID                               AS ORIGIN_DIV
			  ,'*'                                          AS PLANT_ID
			  ,N'반제품'                                     AS PLAN_TYPE
			  ,SUM.GROUP_CODE1                              AS GROUP_CODE
			  ,SUM.ITEM_ID                                  AS MATERIAL
			  ,SUM.ORIGIN_ITEM_ID                           AS ORIGIN_MATERIAL
			  ,CASE WHEN SUM.DATA_TP_CD = 'BOH' THEN 1
					WHEN SUM.DATA_TP_CD = 'P'   THEN 2
					WHEN SUM.DATA_TP_CD = 'S'   THEN 3
					WHEN SUM.DATA_TP_CD = 'EOH' THEN 4 END  AS SORT
			  ,(SELECT  LK.ATTRIBUTE1
				FROM    SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
				WHERE   1=1
				AND     LK.LOOKUP_TYPE  = 'SCM_LGTM_CODE_NAME_FOR_LGTM'
				AND     LK.VALID_YN     = 'Y'
				AND     LK.SEGMENT1     = 'DATA_TP_CD'
				AND     LK.SEGMENT2     = SUM.DATA_TP_CD)   AS DATA_TP_CD
			  ,(SELECT  LK.ATTRIBUTE1
				FROM    SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
				WHERE   1=1
				AND     LK.LOOKUP_TYPE  = 'SCM_LGTM_CODE_NAME_FOR_LGTM'
				AND     LK.VALID_YN     = 'Y'
				AND     LK.SEGMENT1     = 'SRCE_TP_CD'
				AND     LK.SEGMENT2     = SUM.DATA_TP_CD
				AND     LK.SEGMENT3     = SUM.SRCE_TP_CD)   AS SRCE_TP_CD
			  ,CASE WHEN SUM.DATA_TP_CD IN ( 'BOH', 'EOH' ) THEN SUM.LONG_TERM_TYPE 
			   ELSE '-' END AS LONG_TERM_TYPE
			  ,SUM.PLAN_YYYYMM                              AS PLAN_YYYYMM
			  ,SUM.SRCE_YYYYMM                              AS SOURCE_YYYYMM
			  ,SUM(SUM.QTY)                                 AS QTY 
			  ,MAX(SUM.STANDARD_COST)                       AS PRICE
			  ,SUM(SUM.AMT)                                 AS AMT 
		FROM  SCM_LGTM_INV_PSI_SUMMARY_SPRD SUM
		LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
            ON  LK.SEGMENT2     = SUM.DATA_TP_CD
            AND LK.SEGMENT3     = SUM.SRCE_TP_CD 
            AND LK.LOOKUP_TYPE  = 'SCM_LGTM_CODE_NAME_FOR_LGTM'
            AND LK.VALID_YN     = 'Y'
            AND LK.SEGMENT1     = 'SRCE_TP_CD'
		WHERE 1=1
		AND   DATA_TP_CD      <> 'RESULT'
		AND   SUM.PLAN_TP_CD  = 'SPRD_INIT'
		AND	  SUM.PLAN_START_YYYYMMDD = @p_plan_date
		AND	  ( ISNULL(@p_division_id, '') = '' OR SUM.DIVISION_ID	IN (SELECT token FROM dbo.String_Split(@p_division_id,',')) )
		AND	  ( ISNULL(@p_creation_type, '') = '' OR LK.ATTRIBUTE1	IN (SELECT token FROM dbo.String_Split(@p_creation_type,',')) )
		AND	  ( ISNULL(@p_group_code, '')	= '' OR SUM.GROUP_CODE1 IN (SELECT token FROM dbo.String_Split(@p_group_code,',')) )
		AND	  ( ISNULL(@p_item_id	, '')	= '' OR SUM.ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id,',')) )
		AND	  SUM.PLAN_YYYYMM <= @p_end_month
		GROUP BY SUM.PLAN_START_YYYYMMDD
			  ,SUM.DIVISION_ID
			  ,SUM.DIVISION_ID
			  ,SUM.GROUP_CODE1
			  ,SUM.ITEM_ID
			  ,SUM.ORIGIN_ITEM_ID
			  ,SUM.DATA_TP_CD
			  ,SUM.SRCE_TP_CD
			  ,SUM.LONG_TERM_TYPE 
			  ,SUM.SRCE_YYYYMM
			  ,SUM.PLAN_YYYYMM
		------------------------------------------------------------------------------
		UNION ALL
		------------------------------------------------------------------------------
		-- 원재료
		------------------------------------------------------------------------------
		SELECT SUM.PLAN_START_YYYYMMDD                      AS PLAN_DATE
			  ,SUM.DIVISION_ID                              AS DIV
			  ,SUM.DIVISION_ID                               AS ORIGIN_DIV
			  ,PLANT_ID                                      AS PLANT_ID
			  ,N'원재료'                                     AS PLAN_TYPE
			  ,SUM.GROUP_CODE1                              AS GROUP_CODE
			  ,SUM.ITEM_ID                                  AS MATERIAL
			  ,SUM.ORIGIN_ITEM_ID                           AS ORIGIN_MATERIAL
			  ,CASE WHEN SUM.DATA_TP_CD = 'BOH' THEN 1
					WHEN SUM.DATA_TP_CD = 'P'   THEN 2
					WHEN SUM.DATA_TP_CD = 'S'   THEN 3
					WHEN SUM.DATA_TP_CD = 'EOH' THEN 4 END  AS SORT
			  ,(SELECT  LK.ATTRIBUTE1
				FROM    SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
				WHERE   1=1
				AND     LK.LOOKUP_TYPE  = 'SCM_LGTM_CODE_NAME_FOR_LGTM'
				AND     LK.VALID_YN     = 'Y'
				AND     LK.SEGMENT1     = 'DATA_TP_CD'
				AND     LK.SEGMENT2     = SUM.DATA_TP_CD)   AS DATA_TP_CD
			  ,(SELECT  LK.ATTRIBUTE1
				FROM    SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
				WHERE   1=1
				AND     LK.LOOKUP_TYPE  = 'SCM_LGTM_CODE_NAME_FOR_LGTM'
				AND     LK.VALID_YN     = 'Y'
				AND     LK.SEGMENT1     = 'SRCE_TP_CD'
				AND     LK.SEGMENT2     = SUM.DATA_TP_CD
				AND     LK.SEGMENT3     = SUM.SRCE_TP_CD)   AS SRCE_TP_CD
			  ,CASE WHEN SUM.DATA_TP_CD IN ( 'BOH', 'EOH' ) THEN SUM.LONG_TERM_TYPE 
			   ELSE '-' END AS LONG_TERM_TYPE
			  ,SUM.PLAN_YYYYMM                              AS PLAN_YYYYMM
			  ,SUM.SRCE_YYYYMM                              AS SOURCE_YYYYMM
			  ,SUM(SUM.QTY)                                 AS QTY 
			  ,MAX(SUM.STANDARD_COST)                       AS PRICE
			  ,SUM(SUM.AMT)                                 AS AMT 
		FROM  SCM_LGTM_INV_PSI_SUMMARY_RMTL SUM
		LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
            ON  LK.SEGMENT2     = SUM.DATA_TP_CD
            AND LK.SEGMENT3     = SUM.SRCE_TP_CD 
            AND LK.LOOKUP_TYPE  = 'SCM_LGTM_CODE_NAME_FOR_LGTM'
            AND LK.VALID_YN     = 'Y'
            AND LK.SEGMENT1     = 'SRCE_TP_CD'
		WHERE 1=1
		AND   DATA_TP_CD      <> 'RESULT'
		AND   SUM.PLAN_TP_CD  = 'RMTL_INIT'
		AND	  SUM.PLAN_START_YYYYMMDD = @p_plan_date
		AND	  ( ISNULL(@p_division_id, '') = '' OR SUM.DIVISION_ID	IN (SELECT token FROM dbo.String_Split(@p_division_id,',')) )
		AND	  ( ISNULL(@p_creation_type, '') = '' OR LK.ATTRIBUTE1	IN (SELECT token FROM dbo.String_Split(@p_creation_type,',')) )
		AND	  ( ISNULL(@p_group_code, '')	= '' OR SUM.GROUP_CODE1 IN (SELECT token FROM dbo.String_Split(@p_group_code,',')) )
		AND	  ( ISNULL(@p_item_id	, '')	= '' OR SUM.ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id,',')) )
		AND	  SUM.PLAN_YYYYMM <= @p_end_month
		GROUP BY SUM.PLAN_START_YYYYMMDD
			  ,SUM.DIVISION_ID
			  ,SUM.DIVISION_ID
			  ,SUM.PLANT_ID
			  ,SUM.GROUP_CODE1
			  ,SUM.ITEM_ID
			  ,SUM.ORIGIN_ITEM_ID
			  ,SUM.DATA_TP_CD
			  ,SUM.SRCE_TP_CD
			  ,SUM.LONG_TERM_TYPE 
			  ,SUM.SRCE_YYYYMM
			  ,SUM.PLAN_YYYYMM      

		------------------------------------------------------------------------------
		UNION ALL
		------------------------------------------------------------------------------
		-- 상품
		------------------------------------------------------------------------------
		SELECT SUM.PLAN_START_YYYYMMDD                      AS PLAN_DATE
			  ,SUM.DIVISION_ID                              AS DIV
			  ,SUM.DIVISION_ID                               AS ORIGIN_DIV
			  ,'*'                                          AS PLANT_ID
			  ,N'상품'                                     AS PLAN_TYPE
			  ,SUM.GROUP_CODE1                              AS GROUP_CODE
			  ,SUM.ITEM_ID                                  AS MATERIAL
			  ,SUM.ORIGIN_ITEM_ID                           AS ORIGIN_MATERIAL
			  ,CASE WHEN SUM.DATA_TP_CD = 'BOH' THEN 1
					WHEN SUM.DATA_TP_CD = 'P'   THEN 2
					WHEN SUM.DATA_TP_CD = 'S'   THEN 3
					WHEN SUM.DATA_TP_CD = 'EOH' THEN 4 END  AS SORT
			  ,(SELECT  LK.ATTRIBUTE1
				FROM    SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
				WHERE   1=1
				AND     LK.LOOKUP_TYPE  = 'SCM_LGTM_CODE_NAME_FOR_LGTM'
				AND     LK.VALID_YN     = 'Y'
				AND     LK.SEGMENT1     = 'DATA_TP_CD'
				AND     LK.SEGMENT2     = SUM.DATA_TP_CD)   AS DATA_TP_CD
			  ,(SELECT  LK.ATTRIBUTE1
				FROM    SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
				WHERE   1=1
				AND     LK.LOOKUP_TYPE  = 'SCM_LGTM_CODE_NAME_FOR_LGTM'
				AND     LK.VALID_YN     = 'Y'
				AND     LK.SEGMENT1     = 'SRCE_TP_CD'
				AND     LK.SEGMENT2     = SUM.DATA_TP_CD
				AND     LK.SEGMENT3     = SUM.SRCE_TP_CD)   AS SRCE_TP_CD
			  ,CASE WHEN SUM.DATA_TP_CD IN ( 'BOH', 'EOH' ) THEN SUM.LONG_TERM_TYPE 
			   ELSE '-' END AS LONG_TERM_TYPE
			  ,SUM.PLAN_YYYYMM                              AS PLAN_YYYYMM
			  ,SUM.SRCE_YYYYMM                              AS SOURCE_YYYYMM
			  ,SUM(SUM.QTY)                                 AS QTY 
			  ,MAX(SUM.STANDARD_COST)                       AS PRICE
			  ,SUM(SUM.AMT)                                 AS AMT 
		FROM  SCM_LGTM_INV_PSI_SUMMARY_GODS SUM
		LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
            ON  LK.SEGMENT2     = SUM.DATA_TP_CD
            AND LK.SEGMENT3     = SUM.SRCE_TP_CD 
            AND LK.LOOKUP_TYPE  = 'SCM_LGTM_CODE_NAME_FOR_LGTM'
            AND LK.VALID_YN     = 'Y'
            AND LK.SEGMENT1     = 'SRCE_TP_CD'
		WHERE 1=1
		AND   DATA_TP_CD      <> 'RESULT'
		AND   SUM.PLAN_TP_CD  = 'GODS_INIT'
		AND	  SUM.PLAN_START_YYYYMMDD = @p_plan_date
		AND	  ( ISNULL(@p_division_id, '') = '' OR SUM.DIVISION_ID	IN (SELECT token FROM dbo.String_Split(@p_division_id,',')) )
		AND	  ( ISNULL(@p_creation_type, '') = '' OR LK.ATTRIBUTE1	IN (SELECT token FROM dbo.String_Split(@p_creation_type,',')) )
		AND	  ( ISNULL(@p_group_code, '')	= '' OR SUM.GROUP_CODE1 IN (SELECT token FROM dbo.String_Split(@p_group_code,',')) )
		AND	  ( ISNULL(@p_item_id	, '')	= '' OR SUM.ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id,',')) )
		AND	  SUM.PLAN_YYYYMM <= @p_end_month
		GROUP BY SUM.PLAN_START_YYYYMMDD
			  ,SUM.DIVISION_ID
			  ,SUM.DIVISION_ID
			  ,SUM.GROUP_CODE1
			  ,SUM.ITEM_ID
			  ,SUM.ORIGIN_ITEM_ID
			  ,SUM.DATA_TP_CD
			  ,SUM.SRCE_TP_CD
			  ,SUM.LONG_TERM_TYPE 
			  ,SUM.SRCE_YYYYMM
			  ,SUM.PLAN_YYYYMM            
	) TOT
	WHERE 1=1
	AND ( ISNULL(@p_item_type, '')	= '' OR TOT.PLAN_TYPE	 IN (SELECT token FROM dbo.String_Split(@p_item_type,',')) )
	AND ( ISNULL(@p_plant_id, '')	= '' OR TOT.PLANT_ID	 IN (SELECT token FROM dbo.String_Split(@p_plant_id,',')) )
	ORDER BY PLAN_DATE
			,DIV
			,ORIGIN_DIV
			,PLANT_ID
			,GROUP_CODE
			,MATERIAL
			,ORIGIN_MATERIAL
			,PLAN_YYYYMM
			,SORT
			,SOURCE_YYYYMM
			,DATA_TP_CD
			,SRCE_TP_CD
	------------------------------------------------------------------------
    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @n_log_count   = @@ROWCOUNT;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	------------------------------------------------------------------------

END;
