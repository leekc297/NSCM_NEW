--USE [LGCE_FP_TR]

CREATE PROCEDURE [dbo].[PR_SCM_OF_DEMAND_ORDER_TRACKING_ELEC]
@p_master_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/*********************************************************************************************/ 
/** 프로그램 ID	: PR_SCM_OF_DEMAND_ORDER_TRACKING_ELEC													**/
/** 프로그램 명	:                                                                           **/
/** 설 명		:																			**/
/** Version		: 1.0.0																		**/
/**                                                                                         **/
/** Argument	:																			**/
/**                                                                                         **/
/** [검색 조건]																				**/
/**                                                                                         **/
/** [Biz Logic]                                                                             **/
/**                                                                                         **/
/**-----------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유													**/
/** 20200207       cys          Demand 별 Order Tracking									**/
/*********************************************************************************************/  
/*
*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_master_id      nvarchar(30)
  DECLARE @v_plan_id        nvarchar(30)
  DECLARE @plan_start_time  datetime
  DECLARE @plan_end_time    datetime

  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_OF_DEMAND_ORDER_TRACKING_ELEC'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code       nvarchar(10)
  
  DECLARE @sync_operation_id  nvarchar(30)
  DECLARE @in_operation_id    nvarchar(30)
  DECLARE @out_operation_id   nvarchar(30)

  DECLARE @v_instance_code      nvarchar(10)
  DECLARE @v_instance_sub_code  nvarchar(10)
  DECLARE @v_order_date_code    nvarchar(10)
  DECLARE @v_hhmiss             nvarchar(10)
  DECLARE @v_plan_date			datetime
  DECLARE @n_day_diff           datetime
  DECLARE @v_sqltext            nvarchar(MAX)

  DECLARE @sysdate          DATETIME2 = GETDATE()
  DECLARE @key_date         nvarchar(8)

  DECLARE @v_temp1          nvarchar(1000)
  DECLARE @v_temp2          nvarchar(1000)
  
  DECLARE @v_plan_month     nvarchar(30)
  DECLARE @v_cutoff_date     date

  SET @v_master_id  = @p_master_id
  SET @v_plan_id    = @p_plan_id
  
  
  SET @v_temp1 = 'S' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  SET @v_temp2 = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  
  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

  BEGIN TRY
    
    -- 필수 DATA 쿼리.. 
    BEGIN
    
      --LOG 생성
      SET @v_table_name = 'SCM_FP_PLAN_H'
             
      SELECT 
             @plan_start_time = PLAN_START_TIME
           , @plan_end_time = (
                                CASE  WHEN PLAN_HORIZON_UOM = 'DAY'   THEN DATEADD(DD, PLAN_HORIZON,     PLAN_START_TIME)
                                      WHEN PLAN_HORIZON_UOM = 'WEEK'  THEN DATEADD(DD, PLAN_HORIZON * 7, PLAN_START_TIME)
                                      WHEN PLAN_HORIZON_UOM = 'MONTH' THEN DATEADD(MM, PLAN_HORIZON ,    PLAN_START_TIME)
                                                                      ELSE DATEADD(DD, PLAN_HORIZON,     PLAN_START_TIME)
                                END  
                              )
           , @v_plan_month    = substring(CONVERT(varchar, CONVERT(DATETIME, PLAN_START_TIME, 20) , 112), 1, 6)
           , @key_date    = CONVERT(NVARCHAR, PLAN_START_TIME, 112)
           , @v_plan_date = CONVERT(DATE,     PLAN_START_TIME, 112)                           -- Pmix 소요량 생성용
           , @n_day_diff  = DATEDIFF(MINUTE, CONVERT(DATE, PLAN_START_TIME), PLAN_START_TIME) -- Pmix 소요량 생성용
           , @v_hhmiss    = REPLACE(CONVERT(NVARCHAR, PLAN_START_TIME, 8), ':', '')
      FROM   SCM_FP_PLAN_H WITH(NOLOCK)
      WHERE  INSTANCE_ID = @v_master_id
      AND    PLAN_ID     = @v_plan_id             
             
      --LOG 생성
      SET @v_message = 'PST : ' + CONVERT(nvarchar, @plan_start_time, 112) + ' / PET : ' + CONVERT(nvarchar, @plan_end_time, 112)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

       
      SET @v_table_name = 'FP_INSTANCE_CONFIG_M'

      SELECT @v_instance_code = ISNULL(MAX(A.KEY_VALUE), '-')
      FROM   FP_INSTANCE_CONFIG_M  AS A WITH(NOLOCK)
      WHERE  A.INSTANCE_ID = @v_master_id
      AND    A.CATEGORY_ID = 'EXPORT' 
      AND    A.KEY_ID = 'INSTANCE_CODE'

      --LOG 생성
      SET @v_message = '@v_instance_code : ' + ISNULL(@v_instance_code, '')
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

      DECLARE @v_instance_date  nvarchar(10)
	  DECLARE @v_plan_group_id  nvarchar(30)
	  DECLARE @v_release_group_id  nvarchar(30)
	  DECLARE @v_basic_plan_id  nvarchar(30)
  
		SELECT	@v_instance_date = A.INSTANCE_DATE
				, @v_plan_group_id= CASE WHEN ISNULL(A.FACTORY_ID,'-') = '-' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END
				, @v_basic_plan_id = A.AMEND_PLAN_ID 
		FROM	FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)
		WHERE	1=1
		AND		A.INSTANCE_ID		= @v_master_id
		AND		A.RELEASE_PLAN_ID	= @v_plan_id

		--LOG 생성
		SET @v_message = '@v_instance_date : ' + ISNULL(@v_instance_date, '')
		SET @n_log_count = @n_log_count + 1
		EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

	IF @sync_operation_id IS NULL
	BEGIN
    
		SELECT @sync_operation_id = MAX(OPERATION_ID)
		FROM   LGCE_FPDEV.dbo.TH_MST_OPERATION
		WHERE  MASTER_ID  = @v_master_id
		AND    PLAN_ID    = @v_basic_plan_id
      
	END
    
	IF @sync_operation_id = 'P9500'
		SET @sync_operation_id = 'P5500'
  
	DELETE FROM TH_BUF_INSTANCE_PLAN_INFO
	WHERE  INSTANCE_ID  = @v_master_id
	AND	   FP_PLAN_ID   = @v_plan_id
	
	DELETE FROM TH_BUF_SCP_TARGET
	WHERE  INSTANCE_ID  = @v_master_id
	AND	   FP_PLAN_ID   = @v_plan_id
		
	DELETE FROM TH_BUF_RAW_DATA
	WHERE  INSTANCE_ID  = @v_master_id
	AND    FP_PLAN_ID	= @v_plan_id

	DELETE FROM FP_ORDER_TRACKING_DEMEND_R
	WHERE  INSTANCE_ID  = @v_master_id
	AND    FP_PLAN_ID	= @v_plan_id

	DELETE FROM FP_ORDER_TRACKING_WO_R
	WHERE  INSTANCE_ID  = @v_master_id
	AND    FP_PLAN_ID	= @v_plan_id

		-- PLAN 정보저장
		INSERT INTO TH_BUF_INSTANCE_PLAN_INFO
		(
			  INSTANCE_ID
			, FP_PLAN_ID
			, INSTANCE_DATE 
			, PLAN_GROUP_ID
			, RELEASE_PLAN_ID
			, AMEND_PLAN_ID
			, DEMAND_PLAN_ID
			, DEMAND_START_DATE
			, RESULT_START_DATE
			, RESULT_END_DATE
			, PLAN_TYPE
			, SITE_ID
		)
		SELECT	  @v_master_id AS INSTANCE_ID	
				, @v_plan_id AS FP_PLAN_ID
				, INSTANCE_DATE
				, PLAN_GROUP_ID
				, RELEASE_PLAN_ID
				, AMEND_PLAN_ID
				, DEMAND_PLAN_ID
				, DEMAND_START_DATE
				, DEMAND_START_DATE AS RESULT_START_DATE
				, CONVERT(VARCHAR,DATEADD(DAY, -1, CONVERT(DATE,INSTANCE_DATE)),112) AS RESULT_END_DATE
				, PLAN_TYPE
				, SITE_ID
		FROM (
				SELECT 	A.INSTANCE_DATE
						, CASE WHEN B.PLAN_TYPE = 'BUILDING' THEN A.FACTORY_ID ELSE A.PLAN_GROUP_ID END AS PLAN_GROUP_ID
						, RELEASE_PLAN_ID, AMEND_PLAN_ID
						, D.DEMAND_PLAN_ID
						, SUBSTRING(D.DEMAND_PLAN_ID,1,8) AS DEMAND_START_DATE
						, RANK() OVER ( PARTITION	BY A.INSTANCE_ID, CASE WHEN B.PLAN_TYPE = 'BUILDING' THEN A.FACTORY_ID ELSE A.PLAN_GROUP_ID END
										ORDER		BY A.INSTANCE_DATE DESC, A.RELEASE_PLAN_ID, A.INSERT_TIME
									  ) AS RNK
						, B.PLAN_TYPE
						, D.SITE_ID
				FROM	FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)
						INNER JOIN(
									SELECT ATTRIBUTE1 AS PLAN_TYPE
									FROM   SCM_SYS_LOOKUP_VALUE WITH(NOLOCK)
									WHERE  1=1
									AND    SEGMENT1         = @v_master_id
									AND    LOOKUP_TYPE_CODE = 'INSTANCE_ID' 
									AND	   ACTIVE_FLAG = 'Y'
						) B
						ON 1=1
						INNER JOIN(
									SELECT SEGMENT2 AS PLANNING_GROUP
									FROM   SCM_SYS_LOOKUP_VALUE WITH(NOLOCK)
									WHERE  1=1
									AND    SEGMENT1         = @v_master_id
									AND    LOOKUP_TYPE_CODE = 'INSTANCE_PLANNING_GROUP'
									AND	   ACTIVE_FLAG = 'Y'
									UNION 
									SELECT DISTINCT AA.FACTORY_ID AS PLANNING_GROUP
									FROM   FP_INSTANCE_FACTORY_M AA WITH(NOLOCK), SCM_FACTORY_M BB WITH(NOLOCK)
									WHERE  AA.INSTANCE_ID  = @v_master_id
									AND    AA.ACTIVE_FLAG  = 'Y'
									AND    BB.ACTIVE_FLAG  = 'Y'
									AND    AA.FACTORY_ID   = BB.FACTORY_ID
						) C
						ON 1=1
						AND ( CASE WHEN B.PLAN_TYPE = 'BUILDING' THEN A.FACTORY_ID ELSE A.PLAN_GROUP_ID END ) = C.PLANNING_GROUP
						INNER JOIN SCM_FP_PLAN_H D WITH(NOLOCK)
						ON 1=1
						AND A.INSTANCE_ID	= D.INSTANCE_ID
						AND A.AMEND_PLAN_ID	= D.PLAN_ID
				WHERE	1=1
				AND		A.INSTANCE_ID = @v_master_id
				AND		A.INSERT_TIME > DATEADD(DAY, -14, GETDATE())
				--AND     A.RELEASE_PLAN_ID <> 'KR_CELL-20200217-98'
			) A
		WHERE 1=1
		AND RNK = 1

		--LOG 생성
		SET @v_message   = 'TH_BUF_INSTANCE_PLAN_INFO ' + CONVERT(NVARCHAR, @n_row_count)
		SET @n_log_count = @n_log_count + 1
		SET @sysdate = GETDATE()
		EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
    END;

    
  --  BEGIN
		
		
		
		
		DECLARE @v_target_table  nvarchar(100)
		SET @v_target_table = 'LGCE_FPDEV.dbo.TH_MST_SCM_DEMAND '

		-- TARGET 수량을 넣어준다.
		SET @v_table_name = 'TH_BUF_SCP_TARGET'
			
			set @v_sqltext	= '	INSERT INTO TH_BUF_SCP_TARGET		'
							+ '	(									'																															
							+'		INSTANCE_ID						'																															
							+'		,FP_PLAN_ID                     '																															
							+'		,DPP_PLAN_ID                    '
							+'		,COMPANY_ID                     '																															
							+'		,DIVISION_ID                    '																															
							+'		,SITE_ID                        '																															
							+'		,PLANT_ID                       '																															
							+'		,SHOP_GROUP_ID                  '																															
							+'		,FACTORY_ID                     '																															
							+'		,OPERATION_ID                   '																															
							+'		,LINE_ID                        '																															
							+'		,LOCATION                       '																															
							+'		,PRODUCTION_TYPE                '																															
							+'		,FP_PRODUCTION_TYPE             '																															
							+'		,MARKET                         '																															
							+'		,ELECTRODE_TYPE                 '																															
							+'		,TOP_ITEM_ID                    '																															
							+'		,ITEM_ID                        '																															
							+'		,FP_DEMAND_ID                   '																															
							+'		,SCP_PLAN_ID                    '																															
							+'		,SCP_TARGET_ID                  '																															
							+'		,WORK_ORDER_ID                  '																															
							+'		,PARENT_DEMAND_ID               '																															
							+'		,SCP_WEEK                       '																															
							+'		,MFG_WEEK                       '																															
							+'		,MFG_QTY                        '																															
							+'		,REMAIN_MFG_QTY                 '																															
							+'		,DUE_DATE                       '																															
							+'		,TARGET_SEQ                     '
							+'		,KEY_DATE                       '																															
							+'		,INSERT_ID                      '																															
							+'		,INSERT_TIME                    '																															
							+'		,UPDATE_ID                      '																															
							+'		,UPDATE_TIME                    '	
							+'	)                                   '	
							+ '	SELECT													'
							+ '			  INSTANCE_ID                                   '
							+ '			, '''+@v_plan_id+''' FP_PLAN_ID						'
							+ '			, DPP_PLAN_ID						'
							+ '			, COMPANY_ID                                    '
							+ '			, DIVISION_ID                                   '
							+ '			, SITE_ID                                       '
							+ '			, PLANT_ID                                      '
							+ '			, SHOP_GROUP_ID                                 '
							+ '			, NULL AS FACTORY_ID                            '
							+ '			, OPERATION_ID                                  '
							+ '			, LINE_ID                                       '
							+ '			, NULL AS LOCATION                              '
							+ '			, PRODUCTION_TYPE                               '
							+ '			, NULL AS FP_PRODUCTION_TYPE                    '
							+ '			, MARKET                                        '
							+ '			, NULL AS ELECTRODE_TYPE                        '
							+ '			, MODEL_CODE AS TOP_ITEM_ID                     '
							+ '			, ITEM_ID                                       '
							+ '			, FP_DEMAND_ID                                  '
							+ '			, SCP_PLAN_ID                                   '
							+ '			, SCP_TARGET_ID                                 '
							+ '			, WORK_ORDER_ID                                 '
							+ '			, FP_DEMAND_ID AS PARENT_DEMAND_ID				'
							+ '			, SCP_WEEK                                      '
							+ '			, MFG_WEEK                                      '
							+ '			, MFG_QTY                                       '
							+ '			, MFG_QTY AS REMAIN_MFG_QTY                     '
							+ '			, DUE_DATE                                      '
							+ '			, NULL AS TARGET_SEQ                                      '
							+ '			, KEY_DATE                                      '
							+ '			, INSERT_ID                                     '
							+ '			, INSERT_TIME                                   '
							+ '			, UPDATE_ID                                     '
							+ '			, UPDATE_TIME                                   '
							--+ '	FROM	'+@v_master_id+'_DEV_TH_MST_SCM_DEMAND  A WITH(NOLOCK)        '
							+ '	FROM	LGCE_FPDEV.dbo.TH_MST_SCM_DEMAND  A WITH(NOLOCK)        '
							--+ '	WHERE	A.DPP_PLAN_ID =   '''+@v_basic_plan_id+''' '
							+ '	WHERE	A.DPP_PLAN_ID = '''+'PL_E_PRE-20200228-02'+'''  ' 
							--+ ' AND A.FP_DEMAND_ID = '''+'81^A040-A^202011^ACHN1007I-A1^A1A02^A9000^MASS^D::FP200226'+''' '
							--+ ' AND A.FP_DEMAND_ID IN ('''+'40^G182-A^202007^MCP595490B10^M6L28^A9000^MASS^E::FP200217'+''' , '''+'40^G182-A^202008^MCP595490B10^M6L28^A9000^MASS^E::FP200217'+''' ) '
							--+ ' AND A.ITEM_ID = '''+'ACEN1053I-B1-D04'+''' '
			
			EXEC sp_executesql @v_sqltext, N'@v_return AS INTEGER OUTPUT', @v_return=@n_row_count OUTPUT

		--LOG 생성
		SET @v_message   = 'DYNAMIC SQL - ' +@v_table_name+ ' : ' + CONVERT(NVARCHAR, @n_row_count)
		SET @n_log_count = @n_log_count + 1
		SET @sysdate = GETDATE()
		EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

		
		-- TARGET SORTING : MFG_QTY, NICK_NAME, ITEM_ID, PRODUCTION TYPE, SCP_LINE_ID, (PLAN_DATE)
		UPDATE	A
		SET		A.TARGET_SEQ = ISNULL(ROW_IDX,1)
		FROM	(
					SELECT	A.*
							, B.NICK_NAME
							, ROW_NUMBER() OVER (PARTITION	BY	A.INSTANCE_ID, A.FP_PLAN_ID, A.ITEM_ID
												 ORDER		BY	A.MFG_WEEK
																, A.MFG_QTY DESC
																, B.NICK_NAME
																, A.ITEM_ID
																, A.PRODUCTION_TYPE
																, A.LINE_ID
												) AS ROW_IDX
					FROM	TH_BUF_SCP_TARGET A
							, SCM_ITEM_M B WITH(NOLOCK)
					WHERE	1=1
					AND		A.INSTANCE_ID	= @v_master_id
					AND		A.FP_PLAN_ID	= @v_plan_id
					AND		A.COMPANY_ID	= B.COMPANY_ID
					AND		A.DIVISION_ID	= B.DIVISION_ID
					AND		A.SITE_ID		= B.SITE_ID
					AND		A.ITEM_ID		= B.ITEM_ID
					AND		B.ACTIVE_FLAG	= 'Y'
				)	A

		--LOG 생성
        SET @v_message = 'TARGET_SEQ : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

		
		SET @v_table_name = 'TH_BUF_RAW_DATA'
		-- RESULT / PLAN 기본 데이타 생성

		INSERT INTO TH_BUF_RAW_DATA
		(
			INSTANCE_ID
			, FP_PLAN_ID
			, COMPANY_ID
			, DIVISION_ID
			, SITE_ID
			, PLANT_ID
			, FACTORY_ID
			, OPERATION_ID
			, LINE_ID
			, ELECTRODE_TYPE
			, PRODUCTION_TYPE
			, FP_PRODUCTION_TYPE
			, EQUIPMENT_ID
			, MARKET
			, TOP_ITEM_ID
			, ITEM_ID
			, WORK_ORDER_ID
			, PLAN_DATE
			, PLAN_QTY
			, PLAN_IN_QTY
			, REMAIN_QTY
			, TOTAL_QTY
			, DATA_TYPE
			, INSERT_ID
			, INSERT_DTTM
		)
		SELECT	@v_master_id AS INSTANCE_ID
				, @v_plan_id AS FP_PLAN_ID
				, '' -- (	SELECT MAX(COMPANY_ID) FROM FP_INSTANCE_INFO_V FF WITH(NOLOCK) WHERE FF.INSTANCE_ID = '@v_master_id') AS COMPANY_ID
				, DIVISION_ID
				, SITE_ID
				, '' AS PLANT_ID
				, FACTORY_ID
				, OPERATION_ID
				, LINE_ID
				, ELECTRODE_TYPE
				, PRODUCTION_TYPE
				, FP_PRODUCTION_TYPE
				, '' AS EQUIPMENT_ID
				, MARKET
				, TOP_ITEM_ID
				, ITEM_ID
				, WORK_ORDER_ID
				, PLAN_DATE
				, PLAN_QTY
				, 0  AS PLAN_IN_QTY
				, REMAIN_QTY
				, 0 AS TOTAL_QTY
				, DATA_TYPE
				, @v_proc_name AS INSERT_ID
				, GETDATE() AS INSERT_DTTM
		FROM	(
					SELECT	@v_master_id AS INSTANCE_ID, @v_plan_id AS FP_PLAN_ID, A.DIVISION_ID, B.SITE_ID, A.FACTORY_ID
							, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.FP_PRODUCTION_TYPE, '' AS EQUIPMENT_ID, A.MARKET, A.TOP_ITEM_ID, A.ITEM_ID
							, A.WORK_ORDER_ID, A.PLAN_DATE, A.PLAN_QTY, A.PLAN_QTY AS REMAIN_QTY, 'P' AS DATA_TYPE
					FROM	FP_RELEASE_FULL_PLAN_H A WITH(NOLOCK) 
							, TH_BUF_INSTANCE_PLAN_INFO B WITH(NOLOCK)
					WHERE	1=1
					AND A.INSTANCE_ID		= @v_master_id
					AND B.INSTANCE_ID		= @v_master_id
					AND B.FP_PLAN_ID		= @v_plan_id
					AND A.INSTANCE_ID		= B.INSTANCE_ID
					AND A.INSTANCE_DATE		= B.INSTANCE_DATE
					AND A.RELEASE_PLAN_ID	= B.RELEASE_PLAN_ID
					AND A.AMEND_PLAN_ID		= B.AMEND_PLAN_ID
					AND	A.PLAN_DATE			>=	@key_date  --CUTOFF DATE
					--AND A.ITEM_ID ='ACEN1053I-B1-D04'
					UNION ALL
					--SELECT	@v_master_id AS INSTANCE_ID, @v_plan_id AS FP_PLAN_ID, A.DIVISION_ID, B.SITE_ID, A.FACTORY_ID
					--		, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.FP_PRODUCTION_TYPE, '' AS EQUIPMENT_ID, A.MARKET, A.TOP_ITEM_ID, A.ITEM_ID
					--		, A.WORK_ORDER_ID, A.PLAN_DATE, A.PLAN_QTY, A.PLAN_QTY AS REMAIN_QTY, 'X' AS DATA_TYPE
					--FROM	FP_RELEASE_FULL_PLAN_H A WITH(NOLOCK) 
					--		, TH_BUF_INSTANCE_PLAN_INFO B WITH(NOLOCK)
					--WHERE	1=1
					--AND A.INSTANCE_ID		= @v_master_id
					--AND B.INSTANCE_ID		= @v_master_id
					--AND B.FP_PLAN_ID		= @v_plan_id
					--AND A.INSTANCE_ID		= B.INSTANCE_ID
					--AND A.INSTANCE_DATE		= B.INSTANCE_DATE
					--AND A.RELEASE_PLAN_ID	= B.RELEASE_PLAN_ID
					--AND A.AMEND_PLAN_ID		= B.AMEND_PLAN_ID
					--AND	A.PLAN_DATE			< @key_date  --CUTOFF DATE
					----AND A.ITEM_ID ='MCP4059D4A10'
					--UNION ALL
					SELECT 	@v_master_id AS INSTANCE_ID, @v_plan_id AS FP_PLAN_ID, A.DIVISION_ID, A.SITE_ID, A.FACTORY_ID
							, A.OPERATION_ID, A.LINE_ID, NULL AS ELECTRODE_TYPE, NULL AS PRODUCTION_TYPE, NULL AS FP_PRODUCTION_TYPE, '' AS EQUIPMENT_ID, NULL AS MARKET
							, NULL AS TOP_ITEM_ID, A.ITEM_ID
							, CONVERT(VARCHAR,A.CUTOFF_DATE,112)+'_'+A.OPERATION_ID+'_'+A.LINE_ID AS WORK_ORDER_ID, A.CUTOFF_DATE AS PLAN_DATE
							, A.WIP_QTY AS PLAN_QTY, A.WIP_QTY AS REMAIN_QTY, 'S' AS DATA_TYPE
					FROM	(		
								SELECT	A.CUTOFF_DATE, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.FP_APPLY_ITEM_ID AS ITEM_ID, A.FP_APPLY_OPERATION_ID AS OPERATION_ID, A.LINE_ID,
										ISNULL(SUM(A.MODIFY_FP_APPLY_WIPQTY),SUM(FP_APPLY_WIPQTY)) AS WIP_QTY
								FROM 	SCM_STOCK_H A,
										FP_INSTANCE_INFO_V C,
										FP_INSTANCE_OPERATION_V D
								WHERE 	1=1
								AND 	A.CUTOFF_DATE	= @key_date
								AND		c.INSTANCE_ID	= @v_master_id
								AND		D.INSTANCE_ID	= @v_master_id
								AND 	A.COMPANY_ID	= C.COMPANY_ID
								AND 	A.DIVISION_ID	= C.DIVISION_ID
								AND 	A.SITE_ID		= C.SITE_ID
								AND 	A.PLANT_ID		= C.PLANT_ID
								AND 	A.FP_APPLY_OPERATION_ID = D.OPERATION_ID
								GROUP BY A.CUTOFF_DATE, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.FP_APPLY_ITEM_ID, A.FP_APPLY_OPERATION_ID, A.LINE_ID
								HAVING  ISNULL(SUM(A.MODIFY_FP_APPLY_WIPQTY),SUM(FP_APPLY_WIPQTY)) > 0
							) A
					WHERE	1=1
					UNION ALL
					SELECT  @v_master_id AS INSTANCE_ID, @v_plan_id AS FP_PLAN_ID, A.DIVISION_ID, B.SITE_ID, A.FACTORY_ID
							, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.FP_PRODUCTION_TYPE, '' AS EQUIPMENT_ID, A.MARKET, A.TOP_ITEM_ID, A.ITEM_ID
							, CONVERT(VARCHAR,A.PLAN_DATE,112)+'_'+A.LINE_ID+'_'+A.FP_PRODUCTION_TYPE AS WORK_ORDER_ID, A.PLAN_DATE, A.ACTUAL_GOOD_QTY AS PLAN_QTY, A.ACTUAL_GOOD_QTY AS REMAIN_QTY, 'R' AS DATA_TYPE
					FROM SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK)
							INNER JOIN (
									SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, B.LINE_ID, B.ELECTRODE_TYPE, A.MODEL_TYPE
									FROM FP_INSTANCE_OPERATION_V A, SCM_LINE_M B
									WHERE INSTANCE_ID = @v_master_id
									AND A.COMPANY_ID = B.COMPANY_ID
									AND A.DIVISION_ID = B.DIVISION_ID
									AND A.SITE_ID = B.SITE_ID
									AND A.OPERATION_ID = B.OPERATION_ID
									AND A.MODEL_TYPE = B.MODEL_TYPE
									AND B.ACTIVE_FLAG = 'Y'
							) B
							ON	1=1
							AND A.COMPANY_ID = B.COMPANY_ID
							AND A.DIVISION_ID = B.DIVISION_ID
							AND A.SITE_ID = B.SITE_ID
							AND A.OPERATION_ID = B.OPERATION_ID
							AND A.LINE_ID = B.LINE_ID
							AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
							INNER JOIN TH_BUF_INSTANCE_PLAN_INFO C
							ON 1=1
							AND C.INSTANCE_ID		= @v_master_id
							AND C.FP_PLAN_ID		= @v_plan_id
							AND ( CASE WHEN C.PLAN_TYPE = 'BUILDING' THEN A.FACTORY_ID ELSE B.MODEL_TYPE END ) = C.PLAN_GROUP_ID
							AND A.PLAN_DATE BETWEEN C.RESULT_START_DATE AND C.RESULT_END_DATE
					WHERE 1=1
					AND EXISTS	(
									SELECT	1
									FROM	(
												SELECT DISTINCT BB.COMPANY_ID, BB.DIVISION_ID, BB.SITE_ID, BB.PLANT_ID, AA.FACTORY_ID
												FROM   FP_INSTANCE_FACTORY_M AA WITH(NOLOCK), SCM_FACTORY_M BB WITH(NOLOCK)
												WHERE  AA.INSTANCE_ID  = @v_master_id
												AND    AA.ACTIVE_FLAG  = 'Y'
												AND    BB.ACTIVE_FLAG  = 'Y'
												AND    AA.FACTORY_ID   = BB.FACTORY_ID
											) X
									WHERE	1=1
									AND		A.COMPANY_ID	= X.COMPANY_ID
									AND		A.DIVISION_ID	= X.DIVISION_ID
									AND		A.SITE_ID		= X.SITE_ID
									AND		A.PLANT_ID		= X.PLANT_ID
									AND		A.FACTORY_ID	= X.FACTORY_ID
								) 
								--AND A.ITEM_ID ='ACEN1053I-B1-D04'
				) A
		WHERE	1=1
	

		--LOG 생성
		SET @v_message = CONVERT(NVARCHAR, @@ROWCOUNT)
		SET @n_log_count = @n_log_count + 1
		SET @sysdate = GETDATE()
		EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

		
		UPDATE	A
		SET		A.COMPANY_ID	= B.COMPANY_ID
			   ,A.PLANT_ID		= B.PLANT_ID
		FROM	TH_BUF_RAW_DATA A
				INNER JOIN (
						SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, B.PLANT_ID, B.FACTORY_ID, A.OPERATION_ID, B.LINE_ID, B.ELECTRODE_TYPE, A.MODEL_TYPE
						FROM FP_INSTANCE_OPERATION_V A, SCM_LINE_M B
						WHERE INSTANCE_ID = @v_master_id
						AND A.COMPANY_ID = B.COMPANY_ID
						AND A.DIVISION_ID = B.DIVISION_ID
						AND A.SITE_ID = B.SITE_ID
						AND A.OPERATION_ID = B.OPERATION_ID
						AND A.MODEL_TYPE = B.MODEL_TYPE
						AND B.ACTIVE_FLAG = 'Y'
				) B
				ON	1=1
				--AND A.COMPANY_ID = B.COMPANY_ID
				AND A.DIVISION_ID	= B.DIVISION_ID
				AND A.SITE_ID		= B.SITE_ID
				AND A.FACTORY_ID	= B.FACTORY_ID
				AND A.OPERATION_ID	= B.OPERATION_ID
				AND A.LINE_ID		= B.LINE_ID
				AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
		WHERE	1=1
		AND		A.INSTANCE_ID	=	@v_master_id
		AND		A.FP_PLAN_ID	=	@v_plan_id

		
		--LOG 생성
		SET @v_message = CONVERT(NVARCHAR, @@ROWCOUNT)
		SET @n_log_count = @n_log_count + 1
		SET @sysdate = GETDATE()
		EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null


		-- CUFOFF 이전 W/O 를 RESULT 로 차감시킨 후 잔여 W/O 를 이월시킨다. --W/O Status 에서 비교하여 차감한다.
		/*
			UPDATE	A
			SET		REMAIN_QTY	= ( CASE WHEN A.SUM_QTY - A.ACTUAL_GOOD_QTY < 0						THEN 0
											 WHEN A.SUM_QTY - A.ACTUAL_GOOD_QTY < A.REMAIN_QTY		THEN A.SUM_QTY - A.ACTUAL_GOOD_QTY
																								ELSE A.REMAIN_QTY
										END  )
				   ,TOTAL_QTY		= A.SUM_QTY
			FROM	(  
						SELECT A.*
								, SUM(A.REMAIN_QTY) OVER (	PARTITION BY	A.SITE_ID, A.OPERATION_ID, A.ITEM_ID, A.PRODUCTION_TYPE
															ORDER     BY	A.PLAN_DATE, A.WORK_ORDER_ID
														 ) AS SUM_QTY
								, ROW_NUMBER() OVER (	PARTITION BY A.SITE_ID, A.OPERATION_ID, A.ITEM_ID, A.PRODUCTION_TYPE
														ORDER     BY A.PLAN_DATE, A.WORK_ORDER_ID
													) AS ROW_SEQ
								, B.ACTUAL_GOOD_QTY AS ACTUAL_GOOD_QTY
						FROM	TH_BUF_RAW_DATA A , 
								(
									SELECT  A.DIVISION_ID, B.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.FP_PRODUCTION_TYPE, A.MARKET
											, A.TOP_ITEM_ID, A.ITEM_ID, A.PLAN_DATE, SUM(A.ACTUAL_GOOD_QTY) AS ACTUAL_GOOD_QTY
									FROM SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK)
											INNER JOIN (
													SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, B.LINE_ID, B.ELECTRODE_TYPE, A.MODEL_TYPE
													FROM FP_INSTANCE_OPERATION_V A, SCM_LINE_M B
													WHERE INSTANCE_ID = @v_master_id
													AND A.COMPANY_ID = B.COMPANY_ID
													AND A.DIVISION_ID = B.DIVISION_ID
													AND A.SITE_ID = B.SITE_ID
													AND A.OPERATION_ID = B.OPERATION_ID
													AND A.MODEL_TYPE = B.MODEL_TYPE
													AND B.ACTIVE_FLAG = 'Y'
											) B
											ON	1=1
											AND A.COMPANY_ID = B.COMPANY_ID
											AND A.DIVISION_ID = B.DIVISION_ID
											AND A.SITE_ID = B.SITE_ID
											AND A.OPERATION_ID = B.OPERATION_ID
											AND A.LINE_ID = B.LINE_ID
											AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
											INNER JOIN TH_BUF_INSTANCE_PLAN_INFO C
											ON 1=1
											AND C.INSTANCE_ID		= @v_master_id
											AND C.FP_PLAN_ID		= @v_plan_id
											AND ( CASE WHEN C.PLAN_TYPE = 'BUILDING' THEN A.FACTORY_ID ELSE B.MODEL_TYPE END ) = C.PLAN_GROUP_ID
											AND A.PLAN_DATE BETWEEN DATEADD(DAY, 1, C.RESULT_END_DATE)  AND DATEADD(DAY, -1, @key_date)
									WHERE 1=1
									AND EXISTS	(
													SELECT	1
													FROM	(
																SELECT DISTINCT BB.COMPANY_ID, BB.DIVISION_ID, BB.SITE_ID, BB.PLANT_ID, AA.FACTORY_ID
																FROM   FP_INSTANCE_FACTORY_M AA WITH(NOLOCK), SCM_FACTORY_M BB WITH(NOLOCK)
																WHERE  AA.INSTANCE_ID  = @v_master_id
																AND    AA.ACTIVE_FLAG  = 'Y'
																AND    BB.ACTIVE_FLAG  = 'Y'
																AND    AA.FACTORY_ID   = BB.FACTORY_ID
															) X
													WHERE	1=1
													AND		A.COMPANY_ID	= X.COMPANY_ID
													AND		A.DIVISION_ID	= X.DIVISION_ID
													AND		A.SITE_ID		= X.SITE_ID
													AND		A.PLANT_ID		= X.PLANT_ID
													AND		A.FACTORY_ID	= X.FACTORY_ID
												) 
												--AND A.ITEM_ID ='MCP4059D4A10'
									--AND A.PLAN_DATE BETWEEN DATEADD(DAY, 1, '20200213')  AND DATEADD(DAY, -1, @key_date)
									GROUP BY A.DIVISION_ID, B.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.FP_PRODUCTION_TYPE, A.MARKET
											, A.TOP_ITEM_ID, A.ITEM_ID, A.PLAN_DATE
								) B
						WHERE 1=1
						AND A.DIVISION_ID	= B.DIVISION_ID
						AND A.SITE_ID		= B.SITE_ID
						--AND A.PLANT_ID	= B.PLANT_ID
						AND A.OPERATION_ID	= B.OPERATION_ID
						AND A.ELECTRODE_TYPE	= B.ELECTRODE_TYPE
						AND A.LINE_ID		= B.LINE_ID
						AND A.PRODUCTION_TYPE	= B.PRODUCTION_TYPE
						AND A.MARKET		= B.MARKET
						AND A.ITEM_ID		= B.ITEM_ID
						AND A.PLAN_DATE		= B.PLAN_DATE
						AND A.REMAIN_QTY	> 0
						AND	A.DATA_TYPE		= 'X'
						
					) A
			WHERE	1=1
			AND		A.INSTANCE_ID	=	@v_master_id
			AND		A.FP_PLAN_ID	=	@v_plan_id
		*/
			UPDATE	A
			SET		REMAIN_QTY	= ( CASE WHEN A.SUM_QTY - A.ACTUAL_GOOD_QTY < 0						THEN 0
											 WHEN A.SUM_QTY - A.ACTUAL_GOOD_QTY < A.REMAIN_QTY		THEN A.SUM_QTY - A.ACTUAL_GOOD_QTY
																								ELSE A.REMAIN_QTY
										END  )
				   ,TOTAL_QTY		= A.SUM_QTY
			FROM	(  
						SELECT A.*
								, SUM(A.REMAIN_QTY) OVER (	PARTITION BY	A.SITE_ID, A.OPERATION_ID, A.ITEM_ID, A.PRODUCTION_TYPE
															ORDER     BY	A.PLAN_DATE, A.WORK_ORDER_ID
														 ) AS SUM_QTY
								, ROW_NUMBER() OVER (	PARTITION BY A.SITE_ID, A.OPERATION_ID, A.ITEM_ID, A.PRODUCTION_TYPE
														ORDER     BY A.PLAN_DATE, A.WORK_ORDER_ID
													) AS ROW_SEQ
								, B.ACTUAL_GOOD_QTY AS ACTUAL_GOOD_QTY
						FROM	TH_BUF_RAW_DATA A , 
								(
									SELECT  A.DIVISION_ID, B.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, ISNULL(A.ELECTRODE_TYPE,'-') AS ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.FP_PRODUCTION_TYPE, A.MARKET
											, A.TOP_ITEM_ID, A.ITEM_ID, A.WORK_ORDER_ID, A.PLAN_DATE,  SUM(A.ACTUAL_GOOD_QTY) AS ACTUAL_GOOD_QTY
									FROM	FP_MES_WORK_ORDER_STATUS_H A WITH(NOLOCK)
											INNER JOIN (
													SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, B.LINE_ID, B.ELECTRODE_TYPE, A.MODEL_TYPE
													FROM FP_INSTANCE_OPERATION_V A, SCM_LINE_M B
													WHERE INSTANCE_ID = @v_master_id
													AND A.COMPANY_ID = B.COMPANY_ID
													AND A.DIVISION_ID = B.DIVISION_ID
													AND A.SITE_ID = B.SITE_ID
													AND A.OPERATION_ID = B.OPERATION_ID
													AND A.MODEL_TYPE = B.MODEL_TYPE
													AND B.ACTIVE_FLAG = 'Y'
											) B
											ON	1=1
											AND A.COMPANY_ID = B.COMPANY_ID
											AND A.DIVISION_ID = B.DIVISION_ID
											AND A.SITE_ID = B.SITE_ID
											AND A.OPERATION_ID = B.OPERATION_ID
											AND A.LINE_ID = B.LINE_ID
											AND ISNULL(A.ELECTRODE_TYPE,'-') = B.ELECTRODE_TYPE
									WHERE 1=1
									AND EXISTS	(
													SELECT	1
													FROM	(
																SELECT DISTINCT BB.COMPANY_ID, BB.DIVISION_ID, BB.SITE_ID, BB.PLANT_ID, AA.FACTORY_ID
																FROM   FP_INSTANCE_FACTORY_M AA WITH(NOLOCK), SCM_FACTORY_M BB WITH(NOLOCK)
																WHERE  AA.INSTANCE_ID  = @v_master_id
																AND    AA.ACTIVE_FLAG  = 'Y'
																AND    BB.ACTIVE_FLAG  = 'Y'
																AND    AA.FACTORY_ID   = BB.FACTORY_ID
															) X
													WHERE	1=1
													AND		A.COMPANY_ID	= X.COMPANY_ID
													AND		A.DIVISION_ID	= X.DIVISION_ID
													AND		A.SITE_ID		= X.SITE_ID
													AND		A.PLANT_ID		= X.PLANT_ID
													AND		A.FACTORY_ID	= X.FACTORY_ID
												) 
									AND A.CUTOFF_DATE = DATEADD(DAY, -1, @key_date)
									--AND A.PLAN_DATE < '20200226'
									AND A.ACTUAL_GOOD_QTY > 0
									GROUP BY A.DIVISION_ID, B.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, ISNULL(A.ELECTRODE_TYPE,'-') , A.PRODUCTION_TYPE, A.FP_PRODUCTION_TYPE, A.MARKET
											, A.TOP_ITEM_ID, A.ITEM_ID, A.WORK_ORDER_ID, A.PLAN_DATE
								) B
						WHERE 1=1
						AND A.DIVISION_ID	= B.DIVISION_ID
						AND A.SITE_ID		= B.SITE_ID
						AND A.PLANT_ID	= B.PLANT_ID
						AND A.OPERATION_ID	= B.OPERATION_ID
						AND A.ELECTRODE_TYPE	= B.ELECTRODE_TYPE
						AND A.LINE_ID		= B.LINE_ID
						AND A.PRODUCTION_TYPE	= B.PRODUCTION_TYPE
						AND A.MARKET		= B.MARKET
						AND A.ITEM_ID		= B.ITEM_ID
						AND A.PLAN_DATE		= B.PLAN_DATE
						AND A.WORK_ORDER_ID	= B.WORK_ORDER_ID
						AND A.REMAIN_QTY	> 0
						AND	A.DATA_TYPE		= 'X'
						
					) A
			WHERE	1=1
			AND		A.INSTANCE_ID	=	@v_master_id
			AND		A.FP_PLAN_ID	=	@v_plan_id

		--LOG 생성
		SET @v_message = CONVERT(NVARCHAR, @@ROWCOUNT)
		SET @n_log_count = @n_log_count + 1
		SET @sysdate = GETDATE()
		EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
		
		BEGIN
			DECLARE  @n_target_seq		Integer = 1

			-- Grouping 된 Seq 별로 Loop 돌린다.
			DECLARE C_TARGET_SEQ CURSOR FOR
				SELECT	DISTINCT TARGET_SEQ
				FROM	TH_BUF_SCP_TARGET
				WHERE	1=1
				AND		INSTANCE_ID	= @v_master_id
				AND		FP_PLAN_ID	= @v_plan_id
				AND		TARGET_SEQ IS NOT NULL
				--AND		TARGET_SEQ = 1
				ORDER BY TARGET_SEQ

			OPEN C_TARGET_SEQ
			WHILE 1=1
			BEGIN
			
				FETCH C_TARGET_SEQ
    			INTO  @n_target_seq
    	  
				IF @@FETCH_STATUS <> 0          -- FETCH 레코드 없으면 LOOP 탈출
				BREAK

				SET @v_table_name = 'C_TARGET_SEQ'

				--LOG 생성
				SET @v_message = '--------------- ' + Convert(varchar,@n_target_seq) + ' ---------------'
				SET @n_log_count = @n_log_count + 1
				SET @sysdate = GETDATE()
				EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
				
				--SET @v_proc_name = 1/0

				-- 실적 차감1
				SET @v_table_name = 'TH_BUF_RAW_DATA'

				UPDATE	A
				SET		REMAIN_QTY	= ( CASE WHEN A.SUM_QTY - A.MFG_QTY < 0							THEN 0
											 WHEN A.SUM_QTY - A.MFG_QTY < A.REMAIN_QTY				THEN A.SUM_QTY - A.MFG_QTY
																									ELSE A.REMAIN_QTY
													END  )
					   ,TOTAL_QTY		= A.SUM_QTY
					   ,SCP_SEQ 		= A.ROW_SEQ
					   ,SCP_DEMAND_ID	= A.FP_DEMAND_ID
				FROM	(  
							SELECT A.*
									, SUM(A.REMAIN_QTY) OVER (	PARTITION BY	A.SITE_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.PRODUCTION_TYPE, A.ITEM_ID
																ORDER     BY	(CASE WHEN DATA_TYPE = 'R' THEN 1 
																			  		  WHEN DATA_TYPE = 'X' THEN 2
																					  WHEN DATA_TYPE = 'P' THEN 3 
																					  ELSE 9
																				 END ), A.PLAN_DATE, A.PLAN_QTY DESC
															 ) AS SUM_QTY
									, ROW_NUMBER() OVER (	PARTITION BY A.SITE_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.PRODUCTION_TYPE, A.ITEM_ID
															ORDER     BY (CASE WHEN DATA_TYPE = 'R' THEN 1 
																			   WHEN DATA_TYPE = 'X' THEN 2
																			   WHEN DATA_TYPE = 'P' THEN 3 
																			   ELSE 9
																		  END ), A.PLAN_DATE, A.PLAN_QTY DESC
														) AS ROW_SEQ
									, B.FP_DEMAND_ID, B.REMAIN_MFG_QTY AS MFG_QTY
							FROM	TH_BUF_RAW_DATA A , 
									(
										SELECT	A.*
										FROM	TH_BUF_SCP_TARGET A
										WHERE	1=1
										AND		A.INSTANCE_ID	= @v_master_id
										AND		A.FP_PLAN_ID	= @v_plan_id
										AND		A.OPERATION_ID	= @sync_operation_id
										AND		A.TARGET_SEQ	= @n_target_seq
										AND		A.REMAIN_MFG_QTY > 0
									) B
							WHERE 1=1
							AND	A.INSTANCE_ID	= @v_master_id
							AND	A.FP_PLAN_ID	= @v_plan_id
							AND	A.OPERATION_ID	= @sync_operation_id
							AND A.COMPANY_ID	= B.COMPANY_ID
							AND A.DIVISION_ID	= B.DIVISION_ID
							AND A.SITE_ID		= B.SITE_ID
							AND A.PLANT_ID		= B.PLANT_ID
							AND A.ITEM_ID		= B.ITEM_ID
							AND A.LINE_ID		= B.LINE_ID
							AND A.PRODUCTION_TYPE	= B.PRODUCTION_TYPE
							AND A.MARKET		= B.MARKET
							AND A.REMAIN_QTY	> 0
						) A
				WHERE 1=1

				SET @v_message = 'RESULT_OFFSET_1 : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
				SET @n_log_count = @n_log_count + 1
				SET @sysdate = GETDATE()
				EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

				--저장 프로시져 호출
				EXECUTE PR_SCM_OF_DEMAND_ORDER_TRACKING_SUB @v_master_id, @v_plan_id, @v_basic_plan_id,  @sync_operation_id, @n_target_seq ,'TARGET', '-', '-', '-'

				
				-- 실적 차감2
				SET @v_table_name = 'TH_BUF_RAW_DATA'

				UPDATE	A
				SET		REMAIN_QTY	= ( CASE WHEN A.SUM_QTY - A.MFG_QTY < 0							THEN 0
											 WHEN A.SUM_QTY - A.MFG_QTY < A.REMAIN_QTY				THEN A.SUM_QTY - A.MFG_QTY
																									ELSE A.REMAIN_QTY
													END  )
					   ,TOTAL_QTY		= A.SUM_QTY
					   ,SCP_SEQ 		= A.ROW_SEQ
					   ,SCP_DEMAND_ID	= A.FP_DEMAND_ID
				FROM	(  
							SELECT A.*
									, SUM(A.REMAIN_QTY) OVER (	PARTITION BY	A.SITE_ID, A.FACTORY_ID, A.OPERATION_ID, A.PRODUCTION_TYPE, A.ITEM_ID
																ORDER     BY	(CASE WHEN DATA_TYPE = 'R' THEN 1 
																			  		  WHEN DATA_TYPE = 'X' THEN 2
																					  WHEN DATA_TYPE = 'P' THEN 3 
																					  ELSE 9
																				 END ), A.PLAN_DATE, A.PLAN_QTY DESC
															 ) AS SUM_QTY
									, ROW_NUMBER() OVER (	PARTITION BY A.SITE_ID, A.FACTORY_ID, A.OPERATION_ID, A.PRODUCTION_TYPE, A.ITEM_ID
															ORDER     BY (CASE WHEN DATA_TYPE = 'R' THEN 1 
																			   WHEN DATA_TYPE = 'X' THEN 2
																			   WHEN DATA_TYPE = 'P' THEN 3 
																			   ELSE 9
																		  END ), A.PLAN_DATE, A.PLAN_QTY DESC
														) AS ROW_SEQ
									, B.FP_DEMAND_ID, B.REMAIN_MFG_QTY AS MFG_QTY
							FROM	TH_BUF_RAW_DATA A , 
									(
										SELECT	A.*
										FROM	TH_BUF_SCP_TARGET A
										WHERE	1=1
										AND		A.INSTANCE_ID	= @v_master_id
										AND		A.FP_PLAN_ID	= @v_plan_id
										AND		A.OPERATION_ID	= @sync_operation_id
										AND		A.TARGET_SEQ	= @n_target_seq
										AND		A.REMAIN_MFG_QTY > 0
									) B
							WHERE 1=1
							AND	A.INSTANCE_ID	= @v_master_id
							AND	A.FP_PLAN_ID	= @v_plan_id
							AND	A.OPERATION_ID	= @sync_operation_id
							AND A.COMPANY_ID	= B.COMPANY_ID
							AND A.DIVISION_ID	= B.DIVISION_ID
							AND A.SITE_ID		= B.SITE_ID
							AND A.PLANT_ID		= B.PLANT_ID
							AND A.ITEM_ID		= B.ITEM_ID
							AND A.LINE_ID		= B.LINE_ID
							AND A.PRODUCTION_TYPE	= B.PRODUCTION_TYPE
							AND A.MARKET		= B.MARKET
							AND A.REMAIN_QTY > 0
						) A
				WHERE 1=1

				SET @v_message = 'RESULT_OFFSET_2 : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
				SET @n_log_count = @n_log_count + 1
				SET @sysdate = GETDATE()
				EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

				--저장 프로시져 호출
				EXECUTE PR_SCM_OF_DEMAND_ORDER_TRACKING_SUB @v_master_id, @v_plan_id, @v_basic_plan_id, @sync_operation_id, @n_target_seq, 'TARGET', '-', '-', '-'

				
				-- 실적 차감3
				SET @v_table_name = 'TH_BUF_RAW_DATA'

				UPDATE	A
				SET		REMAIN_QTY	= ( CASE WHEN A.SUM_QTY - A.MFG_QTY < 0							THEN 0
											 WHEN A.SUM_QTY - A.MFG_QTY < A.REMAIN_QTY				THEN A.SUM_QTY - A.MFG_QTY
																									ELSE A.REMAIN_QTY
													END  )
					   ,TOTAL_QTY		= A.SUM_QTY
					   ,SCP_SEQ 		= A.ROW_SEQ
					   ,SCP_DEMAND_ID	= A.FP_DEMAND_ID
				FROM	(  
							SELECT A.*
									, SUM(A.REMAIN_QTY) OVER (	PARTITION BY	A.SITE_ID, A.OPERATION_ID, A.PRODUCTION_TYPE, A.ITEM_ID
																ORDER     BY	(CASE WHEN DATA_TYPE = 'R' THEN 1 
																			  		  WHEN DATA_TYPE = 'X' THEN 2
																					  WHEN DATA_TYPE = 'P' THEN 3 
																					  ELSE 9
																				 END ), A.PLAN_DATE, A.PLAN_QTY DESC
															 ) AS SUM_QTY
									, ROW_NUMBER() OVER (	PARTITION BY A.SITE_ID, A.OPERATION_ID, A.PRODUCTION_TYPE, A.ITEM_ID
															ORDER     BY (CASE WHEN DATA_TYPE = 'R' THEN 1 
																			   WHEN DATA_TYPE = 'X' THEN 2
																			   WHEN DATA_TYPE = 'P' THEN 3 
																			   ELSE 9
																		  END ), A.PLAN_DATE, A.PLAN_QTY DESC
														) AS ROW_SEQ
									, B.FP_DEMAND_ID, B.REMAIN_MFG_QTY AS MFG_QTY
							FROM	TH_BUF_RAW_DATA A , 
									(
										SELECT	A.*
										FROM	TH_BUF_SCP_TARGET A
										WHERE	1=1
										AND		A.INSTANCE_ID	= @v_master_id
										AND		A.FP_PLAN_ID	= @v_plan_id
										AND		A.OPERATION_ID	= @sync_operation_id
										AND		A.TARGET_SEQ	= @n_target_seq
										AND		A.REMAIN_MFG_QTY > 0
									) B
							WHERE 1=1
							AND	A.INSTANCE_ID	= @v_master_id
							AND	A.FP_PLAN_ID	= @v_plan_id
							AND	A.OPERATION_ID	= @sync_operation_id
							AND A.COMPANY_ID	= B.COMPANY_ID
							AND A.DIVISION_ID	= B.DIVISION_ID
							AND A.SITE_ID		= B.SITE_ID
							AND A.PLANT_ID		= B.PLANT_ID
							AND A.ITEM_ID		= B.ITEM_ID
							AND A.LINE_ID		= B.LINE_ID
							AND A.PRODUCTION_TYPE	= B.PRODUCTION_TYPE
							AND A.MARKET		= B.MARKET
							AND A.REMAIN_QTY > 0
						) A
				WHERE 1=1

				SET @v_message = 'RESULT_OFFSET_3 : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
				SET @n_log_count = @n_log_count + 1
				SET @sysdate = GETDATE()
				EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

				--저장 프로시져 호출
				EXECUTE PR_SCM_OF_DEMAND_ORDER_TRACKING_SUB @v_master_id, @v_plan_id, @v_basic_plan_id, @sync_operation_id, @n_target_seq, 'TARGET', '-', '-', '-'


				-- 실적 차감4
				SET @v_table_name = 'TH_BUF_RAW_DATA'

				UPDATE	A
				SET		REMAIN_QTY	= ( CASE WHEN A.SUM_QTY - A.MFG_QTY < 0							THEN 0
											 WHEN A.SUM_QTY - A.MFG_QTY < A.REMAIN_QTY				THEN A.SUM_QTY - A.MFG_QTY
																									ELSE A.REMAIN_QTY
													END  )
					   ,TOTAL_QTY		= A.SUM_QTY
					   ,SCP_SEQ 		= A.ROW_SEQ
					   ,SCP_DEMAND_ID	= A.FP_DEMAND_ID
				FROM	(  
							SELECT A.*
									, SUM(A.REMAIN_QTY) OVER (	PARTITION BY	A.OPERATION_ID, A.LINE_ID, A.PRODUCTION_TYPE, A.ITEM_ID
																ORDER     BY	(CASE WHEN DATA_TYPE = 'R' THEN 1 
																			  		  WHEN DATA_TYPE = 'X' THEN 2
																					  WHEN DATA_TYPE = 'P' THEN 3 
																					  ELSE 9
																				 END ), A.PLAN_DATE, A.PLAN_QTY DESC
															 ) AS SUM_QTY
									, ROW_NUMBER() OVER (	PARTITION BY A.OPERATION_ID, A.LINE_ID, A.PRODUCTION_TYPE, A.ITEM_ID
															ORDER     BY (CASE WHEN DATA_TYPE = 'R' THEN 1 
																			   WHEN DATA_TYPE = 'X' THEN 2
																			   WHEN DATA_TYPE = 'P' THEN 3 
																			   ELSE 9
																		  END ), A.PLAN_DATE, A.PLAN_QTY DESC
														) AS ROW_SEQ
									, B.FP_DEMAND_ID, B.REMAIN_MFG_QTY AS MFG_QTY
							FROM	TH_BUF_RAW_DATA A , 
									(
										SELECT	A.*
										FROM	TH_BUF_SCP_TARGET A
										WHERE	1=1
										AND		A.INSTANCE_ID	= @v_master_id
										AND		A.FP_PLAN_ID	= @v_plan_id
										AND		A.OPERATION_ID	= @sync_operation_id
										AND		A.TARGET_SEQ	= @n_target_seq
										AND		A.REMAIN_MFG_QTY > 0
									) B
							WHERE 1=1
							AND	A.INSTANCE_ID	= @v_master_id
							AND	A.FP_PLAN_ID	= @v_plan_id
							AND	A.OPERATION_ID	= @sync_operation_id
							AND A.COMPANY_ID	= B.COMPANY_ID
							AND A.DIVISION_ID	= B.DIVISION_ID
							AND A.SITE_ID		= B.SITE_ID
							AND A.PLANT_ID		= B.PLANT_ID
							AND A.ITEM_ID		= B.ITEM_ID
							AND A.LINE_ID		= B.LINE_ID
							AND A.PRODUCTION_TYPE	= B.PRODUCTION_TYPE
							AND A.MARKET		= B.MARKET
							AND A.REMAIN_QTY > 0
						) A
				WHERE 1=1

				SET @v_message = 'RESULT_OFFSET_4 : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
				SET @n_log_count = @n_log_count + 1
				SET @sysdate = GETDATE()
				EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

				--저장 프로시져 호출
				EXECUTE PR_SCM_OF_DEMAND_ORDER_TRACKING_SUB @v_master_id, @v_plan_id, @v_basic_plan_id,  @sync_operation_id, @n_target_seq,'TARGET', '-', '-', '-'


				-- 실적 차감5
				SET @v_table_name = 'TH_BUF_RAW_DATA'

				UPDATE	A
				SET		REMAIN_QTY	= ( CASE WHEN A.SUM_QTY - A.MFG_QTY < 0							THEN 0
											 WHEN A.SUM_QTY - A.MFG_QTY < A.REMAIN_QTY				THEN A.SUM_QTY - A.MFG_QTY
																									ELSE A.REMAIN_QTY
													END  )
					   ,TOTAL_QTY		= A.SUM_QTY
					   ,SCP_SEQ 		= A.ROW_SEQ
					   ,SCP_DEMAND_ID	= A.FP_DEMAND_ID
				FROM	(  
							SELECT A.*
									, SUM(A.REMAIN_QTY) OVER (	PARTITION BY	A.OPERATION_ID, A.PRODUCTION_TYPE, A.ITEM_ID
																ORDER     BY	(CASE WHEN DATA_TYPE = 'R' THEN 1 
																			  		  WHEN DATA_TYPE = 'X' THEN 2
																					  WHEN DATA_TYPE = 'P' THEN 3 
																					  ELSE 9
																				 END ), A.PLAN_DATE, A.PLAN_QTY DESC
															 ) AS SUM_QTY
									, ROW_NUMBER() OVER (	PARTITION BY A.OPERATION_ID, A.PRODUCTION_TYPE, A.ITEM_ID
															ORDER     BY (CASE WHEN DATA_TYPE = 'R' THEN 1 
																			   WHEN DATA_TYPE = 'X' THEN 2
																			   WHEN DATA_TYPE = 'P' THEN 3 
																			   ELSE 9
																		  END ), A.PLAN_DATE, A.PLAN_QTY DESC
														) AS ROW_SEQ
									, B.FP_DEMAND_ID, B.REMAIN_MFG_QTY AS MFG_QTY
							FROM	TH_BUF_RAW_DATA A , 
									(
										SELECT	A.*
										FROM	TH_BUF_SCP_TARGET A
										WHERE	1=1
										AND		A.INSTANCE_ID	= @v_master_id
										AND		A.FP_PLAN_ID	= @v_plan_id
										AND		A.OPERATION_ID	= @sync_operation_id
										AND		A.TARGET_SEQ	= @n_target_seq
										AND		A.REMAIN_MFG_QTY > 0
									) B
							WHERE 1=1
							AND	A.INSTANCE_ID	= @v_master_id
							AND	A.FP_PLAN_ID	= @v_plan_id
							AND	A.OPERATION_ID	= @sync_operation_id
							AND A.COMPANY_ID	= B.COMPANY_ID
							AND A.DIVISION_ID	= B.DIVISION_ID
							AND A.SITE_ID		= B.SITE_ID
							AND A.PLANT_ID		= B.PLANT_ID
							AND A.ITEM_ID		= B.ITEM_ID
							AND A.LINE_ID		= B.LINE_ID
							AND A.PRODUCTION_TYPE	= B.PRODUCTION_TYPE
							AND A.MARKET		= B.MARKET
							AND A.REMAIN_QTY > 0
						) A
				WHERE 1=1

				SET @v_message = 'RESULT_OFFSET_5 : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
				SET @n_log_count = @n_log_count + 1
				SET @sysdate = GETDATE()
				EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

				--저장 프로시져 호출
				EXECUTE PR_SCM_OF_DEMAND_ORDER_TRACKING_SUB @v_master_id, @v_plan_id, @v_basic_plan_id, @sync_operation_id, @n_target_seq, 'TARGET', '-', '-', '-'
				EXECUTE PR_SCM_OF_DEMAND_ORDER_TRACKING_SUB @v_master_id, @v_plan_id, @v_basic_plan_id, @sync_operation_id, @n_target_seq, 'DEMAND', '-', '-', '-'
				EXECUTE PR_SCM_OF_DEMAND_ORDER_TRACKING_SUB @v_master_id, @v_plan_id, @v_basic_plan_id, @sync_operation_id, @n_target_seq, 'WO', '-', '-', '-'

				
		END	--C_TARGET_SEQ END

		--저장 프로시져 호출
		EXECUTE PR_SCM_OF_DEMAND_ORDER_TRACKING_SUB @v_master_id, @v_plan_id, @v_basic_plan_id, @sync_operation_id, @n_target_seq, 'UNPLAN', '-', '-', '-'
		
		CLOSE       C_TARGET_SEQ
		DEALLOCATE  C_TARGET_SEQ
		
		--LOG 생성
		SET @v_table_name = 'C_TARGET_SEQ'
		SET @v_message = 'C_TARGET_SEQ CLOSE :: ' + CONVERT(NVARCHAR, @@ROWCOUNT)
		SET @n_log_count = @n_log_count + 1
		SET @sysdate = GETDATE()
		EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
		



		SET @v_table_name = 'FP_ORDER_TRACKING_WO_R'
	
/* hs : 주석으로 막음.		
		---- Plan In QTY Update
		UPDATE	A
		SET		A.PLAN_IN_QTY		= CEILING(A.PLAN_QTY / CASE WHEN ISNULL(B.YIELD, 0) = 0 THEN 1 ELSE  B.YIELD END ) --CEILING(A.PLAN_QTY / ISNULL(D.YIELD, C.YIELD))
			  , A.ORG_PLAN_IN_QTY	= CEILING(A.ORG_PLAN_QTY / CASE WHEN ISNULL(B.YIELD, 0) = 0 THEN 1 ELSE  B.YIELD END )   --+ hs:yield 수정함. 
		FROM	FP_ORDER_TRACKING_WO_R A
				LEFT OUTER JOIN SCM_YIELD_M B WITH(NOLOCK)
				ON 1=1
				AND A.COMPANY_ID	= B.COMPANY_ID
				AND A.DIVISION_ID	= B.DIVISION_ID
				AND A.SITE_ID		= B.SITE_ID
				AND A.PLANT_ID		= B.PLANT_ID
				AND A.FACTORY_ID	= B.FACTORY_ID
				AND A.OPERATION_ID	= B.OPERATION_ID
				AND A.LINE_ID		= B.LINE_ID
				AND A.ITEM_ID		= B.ITEM_ID
				AND CONVERT(VARCHAR(6), A.PLAN_DATE,112) = B.MONTH
		WHERE	1=1
		AND		A.INSTANCE_ID	=	@v_master_id
		AND		A.FP_PLAN_ID	=	@v_plan_id
		--AND		A.OPERATION_ID	=	@v_operation_id

		--SET @v_message = 'PLAN IN QTY : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
		--SET @n_log_count = @n_log_count + 1
		--SET @sysdate = GETDATE()
		--EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
*/ 
	END
    
	--set @v_proc_name = 1/0


	DECLARE @v_demand_pegging_id   nvarchar(100)
	DECLARE @v_work_order_id   nvarchar(100)
	DECLARE @v_item_id   nvarchar(100)

	
	IF CHARINDEX('E_PRE',@v_master_id) = 0     --- 전극 아닌것만 하위로직 실행.
	BEGIN	--하위

			-- OPERATION 정보
			-- OUT_OPERATION_ID   IN_OPERATION_ID
			--        A9000             A8000
			--        A8000             A7000
			--        A7000             A5000
			DECLARE C_PSO_OPERATION CURSOR FOR
			
			SELECT IN_OPERATION_ID, OUT_OPERATION_ID
			FROM   (
					SELECT OPERATION_ID AS OUT_OPERATION_ID
							, LEAD(OPERATION_ID, 1, NULL) OVER (ORDER BY OPERATION_ID DESC) AS IN_OPERATION_ID
					FROM   (
							SELECT ITEM_ID, MIN(OPERATION_ID) AS OPERATION_ID
							FROM   LGCE_FPDEV.DBO.TH_MST_INSTANCE_FLOW
							WHERE  MASTER_ID        = @v_master_id
							--AND    PLAN_ID          = @v_basic_plan_id
							AND    PLAN_ID          = 'KR_CELL-20200226-04'
							AND    OPERATION_ID    <= ISNULL(@sync_operation_id,'ZZZZZ')            -- SYNC_OPERATION_ID
							GROUP  BY ITEM_ID
							) A
					GROUP  BY OPERATION_ID
					) A
			WHERE  IN_OPERATION_ID IS NOT NULL
			ORDER  BY OUT_OPERATION_ID DESC

			OPEN C_PSO_OPERATION
			WHILE 1=1
			BEGIN
      
				FETCH C_PSO_OPERATION
				INTO @in_operation_id,  @out_operation_id
    	  
				IF @@FETCH_STATUS <> 0          -- FETCH 레코드 없으면 LOOP 탈출
				BREAK

				--if @in_operation_id = 'A5000'
				--	break

				SET @v_table_name = 'C_PSO_OPERATION'

				--LOG 생성
				SET @v_message = '--------------- ' + @out_operation_id + ' > ' + @in_operation_id + ' ---------------'
				SET @n_log_count = @n_log_count + 1
				SET @sysdate = GETDATE()
				EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

				SET @v_table_name = 'TH_BUF_SCP_TARGET'
				
				DELETE	TH_BUF_SCP_TARGET
				WHERE	INSTANCE_ID	= @v_master_id
				AND		FP_PLAN_ID	= @v_plan_id
				AND		OPERATION_ID = @in_operation_id

				INSERT INTO TH_BUF_SCP_TARGET	
				(	INSTANCE_ID
					, FP_PLAN_ID
					, COMPANY_ID
					, DIVISION_ID
					, SITE_ID
					, PLANT_ID
					, SHOP_GROUP_ID
					, FACTORY_ID
					, OPERATION_ID
					, LINE_ID
					, LOCATION
					, PRODUCTION_TYPE
					, FP_PRODUCTION_TYPE
					, MARKET
					, ELECTRODE_TYPE
					, TOP_ITEM_ID
					, ITEM_ID
					, FP_DEMAND_ID
					, SCP_PLAN_ID
					, SCP_TARGET_ID
					, WORK_ORDER_ID
					, PARENT_DEMAND_ID
					, SCP_WEEK
					, MFG_WEEK
					, MFG_QTY
					, REMAIN_MFG_QTY
					, DUE_DATE
					, TARGET_SEQ
					, KEY_DATE
					, INSERT_ID
					, INSERT_TIME
					, UPDATE_ID
					, UPDATE_TIME                      
				) 
				SELECT
							A.INSTANCE_ID                       
							, A.FP_PLAN_ID 
							, A.COMPANY_ID							
							, A.DIVISION_ID                       
							, A.SITE_ID                           
							, A.PLANT_ID    
							, NULL AS SHOP_GROUP_ID
							, A.FACTORY_ID
							, @in_operation_id AS OPERATION_ID                      
							, A.LINE_ID
							, A.LOCATION
							, A.PRODUCTION_TYPE
							, A.FP_PRODUCTION_TYPE
							, A.MARKET
							, A.ELECTRODE_TYPE
							, A.ITEM_ID AS TOP_ITEM_ID
							, A.CHILD_ITEM_ID AS ITEM_ID                    
							, A.SCP_DEMAND_PEGGING_ID AS FP_DEMAND_ID                      
							, NULL AS SCP_PLAN_ID           
							, NULL AS SCP_TARGET_ID
							, A.WORK_ORDER_ID AS WORK_ORDER_ID
							, NULL AS PARENT_DEMAND_ID
							, NULL AS SCP_WEEK
							, NULL AS MFG_WEEK                          
							, A.PLAN_QTY * A.CONSUME_RATE AS MFG_QTY                           
							, A.PLAN_QTY * A.CONSUME_RATE AS REMAIN_MFG_QTY                    
							, A.PLAN_DATE AS DUE_DATE
							, NULL AS TARGET_SEQ
							, NULL AS KEY_DATE
							, '' AS INSERT_ID                         
							, GETDATE() AS INSERT_TIME                       
							, '' AS UPDATE_ID                         
							, GETDATE() AS UPDATE_TIME         
				  FROM (
							SELECT	A.*
									, B.CHILD_ITEM_ID
									, B.CONSUME_RATE
									, B.SITE_ID AS CHILD_SITE_ID 
									, B.ROUTE_ID AS CHILD_ROUTE_ID
									, DENSE_RANK() OVER ( PARTITION BY   ALT_ID  ORDER BY  CASE WHEN ISNULL(C.ALT_PRIORITY,1)  =9 THEN 9 ELSE   ISNULL(B.ALT_PRIORITY,1)  END ) AS ALT_PRIORITY
							FROM	(
							    		SELECT	A.INSTANCE_ID
												, A.FP_PLAN_ID
												, A.COMPANY_ID
												, A.DIVISION_ID
												, A.SITE_ID
												, A.PLANT_ID
												, A.FACTORY_ID
												, A.OPERATION_ID
												, A.LINE_ID
												, A.LOCATION
												, A.PRODUCTION_TYPE
												, A.FP_PRODUCTION_TYPE
												, A.MARKET
												, A.ELECTRODE_TYPE
												, A.TOP_ITEM_ID
												, A.ITEM_ID
												, A.SCP_DEMAND_PEGGING_ID
												, A.WORK_ORDER_ID
												, A.PLAN_DATE
												, A.PLAN_QTY
												, A.PLAN_IN_QTY
										FROM 	FP_ORDER_TRACKING_WO_R A WITH(NOLOCK)
										WHERE	1=1
										AND 	A.INSTANCE_ID	= @v_master_id
										AND 	A.FP_PLAN_ID	= @v_plan_id
										AND		A.OPERATION_ID	= @out_operation_id
										and a.SCP_DEMAND_PEGGING_ID in ( '81^A040-A^202011^ACHN1007I-A1^A1A02^A9000^MASS^D::FP200226_001' )
																		--, '81^A040-A^202011^ACHN1007I-A1^A1A02^A9000^MASS^D::FP200226_002')
									) A
									INNER JOIN (
											--SELECT	A.*
											--FROM   	LGCE_FPDEV.DBO.TH_MST_PLAN_BOM  A
											--		, SCM_ITEM_M      B WITH(NOLOCK)
											--WHERE	A.MASTER_ID      = @v_master_id
											----AND		A.PLAN_ID        = @v_basic_plan_id
											--AND		A.PLAN_ID		= 'KR_CELL-20200219-01'
											--AND		A.CHILD_ITEM_ID	 = B.ITEM_ID
											--AND		B.ITEM_TYPE		 = 'H'
											--AND		B.ACTIVE_FLAG    = 'Y'
											--AND		CHARINDEX(@in_operation_id, B.FLOW_ID) > 0
											----AND    (A.ALT_ID IS NULL OR ALT_PRIORITY = 1 OR ALT_PRIORITY IS NULL )
											SELECT	A.*
											FROM   	LGCE_FPDEV.DBO.TH_MST_PLAN_BOM  A
											WHERE	A.MASTER_ID      = @v_master_id
											--AND		A.PLAN_ID        = @v_basic_plan_id
											AND		A.PLAN_ID		= 'KR_CELL-20200226-04'
									) B
									ON    A.INSTANCE_ID		= B.MASTER_ID
									--AND   A.FP_PLAN_ID        = B.PLAN_ID
									AND   A.FACTORY_ID		= B.SITE_ID
									AND   A.LINE_ID			= B.ROUTE_ID
									AND   A.OPERATION_ID	= B.OPERATION_ID
									AND   A.ITEM_ID			= B.PARENT_ITEM_ID
									AND   A.PLAN_DATE		>= B.EFF_START_DATE
									AND   A.PLAN_DATE		< B.EFF_END_DATE
									LEFT OUTER JOIN (
											SELECT *
											FROM	LGCE_FPDEV.dbo.TH_MST_OP_RESOURCE_CAL A
											WHERE	MASTER_ID	= @v_master_id
											--AND		PLAN_ID		= @v_basic_plan_id
											AND		PLAN_ID		= 'KR_CELL-20200226-04'
											AND		ALT_PRIORITY = 9 
											AND		IS_USE		= 'N'
									)C
									ON	1=1
									AND	 B.SITE_ID  = C.SITE_ID
									AND	 B.ROUTE_ID = C.ROUTE_ID
									AND	 B.CHILD_ITEM_ID = C.ITEM_ID
									AND  A.PLAN_DATE    >= C.START_DATE
									AND  A.PLAN_DATE     < C.END_DATE
							WHERE	1=1
						)A
				WHERE	A.ALT_PRIORITY = 1
							 -- order by TOP_ITEM_ID, ITEM_ID, WORK_ORDER_ID
				
				--LOG 생성
				SET @v_message   = 'SUB OP Target - ' +@v_table_name+ ' : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
				SET @n_log_count = @n_log_count + 1
				SET @sysdate = GETDATE()
				EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

				
				-- TARGET SORTING : MFG_QTY, NICK_NAME, ITEM_ID, PRODUCTION TYPE, SCP_LINE_ID, (PLAN_DATE)
				--UPDATE	A
				--SET		A.TARGET_SEQ = ISNULL(ROW_IDX,1)
				--FROM	(
				--			SELECT	A.*
				--					, B.NICK_NAME
				--					, ROW_NUMBER() OVER (PARTITION	BY	A.INSTANCE_ID, A.FP_PLAN_ID, A.TOP_ITEM_ID, A.LINE_ID
				--										 ORDER		BY	A.FP_DEMAND_ID
				--														,A.MFG_WEEK
				--														, A.MFG_QTY DESC
				--														, B.NICK_NAME
				--														, A.ITEM_ID
				--														, A.PRODUCTION_TYPE
				--														, A.LINE_ID
				--										) AS ROW_IDX
				--			FROM	TH_BUF_SCP_TARGET A
				--					, SCM_ITEM_M B WITH(NOLOCK)
				--			WHERE	1=1
				--			AND		A.INSTANCE_ID	= @v_master_id
				--			AND		A.FP_PLAN_ID	= @v_plan_id
				--			AND		A.COMPANY_ID	= B.COMPANY_ID
				--			AND		A.DIVISION_ID	= B.DIVISION_ID
				--			AND		A.SITE_ID		= B.SITE_ID
				--			AND		A.ITEM_ID		= B.ITEM_ID
				--			AND		A.OPERATION_ID	= @in_operation_id
				--			AND		B.ACTIVE_FLAG	= 'Y'
				--		)	A

				----LOG 생성
				--SET @v_message = 'TARGET_SEQ : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
				--SET @n_log_count = @n_log_count + 1
				--SET @sysdate = GETDATE()
				--EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
				

				BEGIN

					DECLARE C_DEMAND_SEQ CURSOR FOR
						SELECT FP_DEMAND_ID, WORK_ORDER_ID, ITEM_ID
						FROM (
								SELECT	DISTINCT FP_DEMAND_ID, WORK_ORDER_ID, ITEM_ID
										, RANK() OVER (ORDER BY FP_DEMAND_ID, FACTORY_ID, LINE_ID, TOP_ITEM_ID, PRODUCTION_TYPE, ITEM_ID, FP_DEMAND_ID, DUE_DATE ) AS IDX
								FROM	TH_BUF_SCP_TARGET
								WHERE	1=1
								AND		INSTANCE_ID	= @v_master_id
								AND		FP_PLAN_ID	= @v_plan_id
								AND		OPERATION_ID= @in_operation_id
							) A
						WHERE 1=1
						ORDER BY IDX


					OPEN C_DEMAND_SEQ
					WHILE 1=1
					BEGIN
			
						FETCH C_DEMAND_SEQ
    					INTO  @v_demand_pegging_id, @v_work_order_id, @v_item_id
    	  
						IF @@FETCH_STATUS <> 0          -- FETCH 레코드 없으면 LOOP 탈출
						BREAK

						--if @v_demand_pegging_id = '81^A040-A^202011^ACHN1007I-A1^A1A02^A9000^MASS^D::FP200226_002' and @in_operation_id = 'A5000' break
						--if @in_operation_id = 'A5000' break

						SET @v_table_name = 'C_DEMAND_SEQ'

						--LOG 생성
						--SET @v_message = '--------------- ' + Convert(varchar,@v_demand_pegging_id) + ' ---------------'
						--SET @n_log_count = @n_log_count + 1
						--SET @sysdate = GETDATE()
						--EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
				
						--SET @v_proc_name = 1/0

						--if @in_operation_id = 'A7000' break
						--if @v_work_order_id = 'K20304ST0001' AND @v_item_id = 'ABCAT0450A'  break
						--if @v_work_order_id = 'WK20226ST#KA1#A1#04#0052' AND @v_item_id = 'ABCAT0450A'  break
						--if @v_work_order_id = 'K20304ST0001' AND @v_item_id = 'ABCCT0435A'  break
						--if @v_work_order_id = 'WK20226ST#KA1#A1#04#0052' AND @v_item_id = 'ABCCT0435A'  break
						

						-- 실적 차감
						SET @v_table_name = 'TH_BUF_RAW_DATA'
			
						-- STOCK
						UPDATE	A
						SET		REMAIN_QTY	= ( CASE WHEN A.SUM_QTY - A.MFG_QTY < 0							THEN 0
													 WHEN A.SUM_QTY - A.MFG_QTY < A.REMAIN_QTY				THEN A.SUM_QTY - A.MFG_QTY
																											ELSE A.REMAIN_QTY
															END  )
							   ,TOTAL_QTY		= A.SUM_QTY
							   ,SCP_SEQ 		= A.ROW_SEQ
							   ,SCP_DEMAND_ID	= A.FP_DEMAND_ID+'_'+@v_work_order_id
						FROM	(  
									SELECT A.*
											, SUM(A.REMAIN_QTY) OVER (	PARTITION BY	A.SITE_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.PRODUCTION_TYPE, A.ITEM_ID
																		ORDER     BY	(CASE WHEN DATA_TYPE = 'S' THEN 1 
																			  				  WHEN DATA_TYPE = 'X' THEN 2
																							  WHEN DATA_TYPE = 'P' THEN 3 
																							  ELSE 9
																						 END ), A.PLAN_DATE, A.PLAN_QTY DESC
																	 ) AS SUM_QTY
											, ROW_NUMBER() OVER (	PARTITION BY A.SITE_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.PRODUCTION_TYPE, A.ITEM_ID
																	ORDER     BY (CASE WHEN DATA_TYPE = 'S' THEN 1 
																					   WHEN DATA_TYPE = 'X' THEN 2
																					   WHEN DATA_TYPE = 'P' THEN 3 
																					   ELSE 9
																				  END ), A.PLAN_DATE, A.PLAN_QTY DESC
																) AS ROW_SEQ
											, B.FP_DEMAND_ID, B.REMAIN_MFG_QTY AS MFG_QTY
									FROM	TH_BUF_RAW_DATA A , 
											(
												SELECT	A.*
												FROM	TH_BUF_SCP_TARGET A
												WHERE	1=1
												AND		A.INSTANCE_ID	= @v_master_id
												AND		A.FP_PLAN_ID	= @v_plan_id
												AND		A.OPERATION_ID	= @in_operation_id
												--AND		A.TARGET_SEQ	= @n_target_seq
												AND		A.FP_DEMAND_ID	= @v_demand_pegging_id
												AND		A.WORK_ORDER_ID = @v_work_order_id
												AND		A.ITEM_ID		= @v_item_id
												AND		A.REMAIN_MFG_QTY > 0
											) B
									WHERE 1=1
									AND	A.INSTANCE_ID	= @v_master_id
									AND	A.FP_PLAN_ID	= @v_plan_id
									AND	A.OPERATION_ID	= @in_operation_id
									--AND A.COMPANY_ID	= B.COMPANY_ID
									--AND A.DIVISION_ID	= B.DIVISION_ID
									--AND A.SITE_ID		= B.SITE_ID
									--AND A.PLANT_ID		= B.PLANT_ID
									AND A.ITEM_ID		= B.ITEM_ID
									AND A.LINE_ID		= B.LINE_ID
									AND A.PRODUCTION_TYPE	= B.PRODUCTION_TYPE
									--AND A.MARKET		= B.MARKET
									AND A.REMAIN_QTY	> 0
									AND A.DATA_TYPE = 'S'
								) A
						WHERE 1=1

						--if @v_work_order_id = 'K20304ST0001' AND @v_item_id = 'ABCCT0435A'  break

						EXECUTE PR_SCM_OF_DEMAND_ORDER_TRACKING_SUB @v_master_id, @v_plan_id, @v_basic_plan_id, @in_operation_id, 0, 'SUB_TARGET', @v_demand_pegging_id, @v_work_order_id, @v_item_id

						--SET @v_message = 'RESULT_OFFSET_1 : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
						--SET @n_log_count = @n_log_count + 1
						--SET @sysdate = GETDATE()
						--EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
						
						--if @v_work_order_id = 'K20304ST0001' AND @v_item_id = 'ABCCT0435A'  break
						
						-- 계획/실적차감1
						UPDATE	A
						SET		REMAIN_QTY	= ( CASE WHEN A.SUM_QTY - A.MFG_QTY < 0							THEN 0
													 WHEN A.SUM_QTY - A.MFG_QTY < A.REMAIN_QTY				THEN A.SUM_QTY - A.MFG_QTY
																											ELSE A.REMAIN_QTY
															END  )
							   ,TOTAL_QTY		= A.SUM_QTY
							   ,SCP_SEQ 		= A.ROW_SEQ
							   ,SCP_DEMAND_ID	= A.FP_DEMAND_ID+'_'+@v_work_order_id
						FROM	(  
									SELECT A.*
											, SUM(A.REMAIN_QTY) OVER (	PARTITION BY	A.SITE_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.PRODUCTION_TYPE, A.ITEM_ID
																		ORDER     BY	(CASE WHEN DATA_TYPE = 'S' THEN 1 
																			  				  WHEN DATA_TYPE = 'X' THEN 2
																							  WHEN DATA_TYPE = 'P' THEN 3 
																							  ELSE 9
																						 END ), A.PLAN_DATE, A.PLAN_QTY DESC
																	 ) AS SUM_QTY
											, ROW_NUMBER() OVER (	PARTITION BY A.SITE_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.PRODUCTION_TYPE, A.ITEM_ID
																	ORDER     BY (CASE WHEN DATA_TYPE = 'S' THEN 1 
																					   WHEN DATA_TYPE = 'X' THEN 2
																					   WHEN DATA_TYPE = 'P' THEN 3 
																					   ELSE 9
																				  END ), A.PLAN_DATE, A.PLAN_QTY DESC
																) AS ROW_SEQ
											, B.FP_DEMAND_ID, B.REMAIN_MFG_QTY AS MFG_QTY
									FROM	TH_BUF_RAW_DATA A , 
											(
												SELECT	A.*
												FROM	TH_BUF_SCP_TARGET A
												WHERE	1=1
												AND		A.INSTANCE_ID	= @v_master_id
												AND		A.FP_PLAN_ID	= @v_plan_id
												AND		A.OPERATION_ID	= @in_operation_id
												--AND		A.TARGET_SEQ	= @n_target_seq
												AND		A.FP_DEMAND_ID	= @v_demand_pegging_id
												AND		A.WORK_ORDER_ID = @v_work_order_id
												AND		A.ITEM_ID		= @v_item_id
												AND		A.REMAIN_MFG_QTY > 0
											) B
									WHERE 1=1
									AND	A.INSTANCE_ID	= @v_master_id
									AND	A.FP_PLAN_ID	= @v_plan_id
									AND	A.OPERATION_ID	= @in_operation_id
									AND A.COMPANY_ID	= B.COMPANY_ID
									AND A.DIVISION_ID	= B.DIVISION_ID
									AND A.SITE_ID		= B.SITE_ID
									AND A.PLANT_ID		= B.PLANT_ID
									AND A.ITEM_ID		= B.ITEM_ID
									AND A.LINE_ID		= B.LINE_ID
									AND A.PRODUCTION_TYPE	= B.PRODUCTION_TYPE
									AND A.MARKET		= B.MARKET
									AND A.REMAIN_QTY	> 0
									AND A.DATA_TYPE IN ('P','X')
								) A
						WHERE 1=1

						SET @v_message = 'RESULT_OFFSET_1 : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
						SET @n_log_count = @n_log_count + 1
						SET @sysdate = GETDATE()
						EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null


						/*
							UPDATE	A
							SET		REMAIN_MFG_QTY	=	( CASE WHEN A.REMAIN_MFG_QTY - (A.PLAN_QTY - A.REMAIN_QTY) <= 0		THEN 0
												   																			ELSE A.REMAIN_MFG_QTY - (A.PLAN_QTY - A.REMAIN_QTY)
															END  )
							FROM	(
										SELECT	A.*, B.PLAN_QTY, B.REMAIN_QTY
										FROM	TH_BUF_SCP_TARGET A	
												INNER JOIN (
														SELECT	A.INSTANCE_ID, A.FP_PLAN_ID, A.SCP_DEMAND_ID, ISNULL(SUM(PLAN_QTY),0) AS PLAN_QTY, ISNULL(SUM(A.REMAIN_QTY),0) AS REMAIN_QTY
														FROM	TH_BUF_RAW_DATA	A
														WHERE	1=1
														AND		A.INSTANCE_ID	= @v_master_id
														AND		A.FP_PLAN_ID	= @v_plan_id
														AND		A.OPERATION_ID	= @in_operation_id
														AND		A.SCP_DEMAND_ID IS NOT NULL
														AND		A.SCP_DEMAND_ID = RTRIM(LTRIM(@v_demand_pegging_id))+'_'+RTRIM(LTRIM(@v_work_order_id))
														AND		A.ITEM_ID		=	@v_item_id
														AND		A.PLAN_QTY		<> A.REMAIN_QTY	
														GROUP BY A.INSTANCE_ID, A.FP_PLAN_ID, A.SCP_DEMAND_ID
												) B
												ON	1=1
												AND	A.INSTANCE_ID	=	@v_master_id
												AND	A.FP_PLAN_ID	=	@v_plan_id
												AND	A.OPERATION_ID	=	@in_operation_id
												AND	A.FP_DEMAND_ID	=	@v_demand_pegging_id
												AND	A.WORK_ORDER_ID =	@v_work_order_id
												AND	A.ITEM_ID		=	@v_item_id
												AND	A.INSTANCE_ID	=	B.INSTANCE_ID
												--AND	A.FP_PLAN_ID	=	B.FP_PLAN_ID
												AND	RTRIM(LTRIM(A.FP_DEMAND_ID))+'_'+RTRIM(LTRIM(@v_work_order_id))	=	B.SCP_DEMAND_ID
												AND	A.REMAIN_MFG_QTY > 0
										WHERE	1=1
										AND		A.REMAIN_MFG_QTY > 0
									) A
							WHERE 1=1
						*/

						-- target reamin_mfg_qty 조정
						EXECUTE PR_SCM_OF_DEMAND_ORDER_TRACKING_SUB  @v_master_id, @v_plan_id, @v_basic_plan_id, @in_operation_id, 0, 'SUB_TARGET',  @v_demand_pegging_id, @v_work_order_id, @v_item_id

						--IF @in_operation_id = 'A8000' BREAK

						-- 실적 차감2
						SET @v_table_name = 'TH_BUF_RAW_DATA'

						UPDATE	A
						SET		REMAIN_QTY	= ( CASE WHEN A.SUM_QTY - A.MFG_QTY < 0							THEN 0
													 WHEN A.SUM_QTY - A.MFG_QTY < A.REMAIN_QTY				THEN A.SUM_QTY - A.MFG_QTY
																											ELSE A.REMAIN_QTY
															END  )
							   ,TOTAL_QTY		= A.SUM_QTY
							   ,SCP_SEQ 		= A.ROW_SEQ
							   ,SCP_DEMAND_ID	= A.FP_DEMAND_ID+'_'+@v_work_order_id
						FROM	(  
									SELECT A.*
											, SUM(A.REMAIN_QTY) OVER (	PARTITION BY	A.SITE_ID, A.FACTORY_ID, A.OPERATION_ID, A.PRODUCTION_TYPE, A.ITEM_ID
																		ORDER     BY	(CASE WHEN DATA_TYPE = 'R' THEN 1 
																			  				  WHEN DATA_TYPE = 'X' THEN 2
																							  WHEN DATA_TYPE = 'P' THEN 3 
																							  ELSE 9
																						 END ), A.PLAN_DATE, A.PLAN_QTY DESC
																	 ) AS SUM_QTY
											, ROW_NUMBER() OVER (	PARTITION BY A.SITE_ID, A.FACTORY_ID, A.OPERATION_ID, A.PRODUCTION_TYPE, A.ITEM_ID
																	ORDER     BY (CASE WHEN DATA_TYPE = 'R' THEN 1 
																					   WHEN DATA_TYPE = 'X' THEN 2
																					   WHEN DATA_TYPE = 'P' THEN 3 
																					   ELSE 9
																				  END ), A.PLAN_DATE, A.PLAN_QTY DESC
																) AS ROW_SEQ
											, B.FP_DEMAND_ID, B.REMAIN_MFG_QTY AS MFG_QTY
									FROM	TH_BUF_RAW_DATA A , 
											(
												SELECT	A.*
												FROM	TH_BUF_SCP_TARGET A
												WHERE	1=1
												AND		A.INSTANCE_ID	= @v_master_id
												AND		A.FP_PLAN_ID	= @v_plan_id
												AND		A.OPERATION_ID	= @in_operation_id
												--AND		A.TARGET_SEQ	= @n_target_seq
												AND		A.FP_DEMAND_ID	= @v_demand_pegging_id
												AND		A.WORK_ORDER_ID = @v_work_order_id
												AND		A.ITEM_ID		= @v_item_id
												AND		A.REMAIN_MFG_QTY > 0
											) B
									WHERE 1=1
									AND	A.INSTANCE_ID	= @v_master_id
									AND	A.FP_PLAN_ID	= @v_plan_id
									AND	A.OPERATION_ID	= @in_operation_id
									AND A.COMPANY_ID	= B.COMPANY_ID
									AND A.DIVISION_ID	= B.DIVISION_ID
									AND A.SITE_ID		= B.SITE_ID
									AND A.PLANT_ID		= B.PLANT_ID
									AND A.ITEM_ID		= B.ITEM_ID
									AND A.LINE_ID		= B.LINE_ID
									AND A.PRODUCTION_TYPE	= B.PRODUCTION_TYPE
									AND A.MARKET		= B.MARKET
									AND A.REMAIN_QTY > 0
									AND A.DATA_TYPE IN ('P','X')
								) A
						WHERE 1=1

						--SET @v_message = 'RESULT_OFFSET_2 : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
						--SET @n_log_count = @n_log_count + 1
						--SET @sysdate = GETDATE()
						--EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

						-- target reamin_mfg_qty 조정
						EXECUTE PR_SCM_OF_DEMAND_ORDER_TRACKING_SUB @v_master_id, @v_plan_id, @v_basic_plan_id, @in_operation_id, 0, 'SUB_TARGET', @v_demand_pegging_id, @v_work_order_id, @v_item_id
						
				
						-- 실적 차감3
						SET @v_table_name = 'TH_BUF_RAW_DATA'

						UPDATE	A
						SET		REMAIN_QTY	= ( CASE WHEN A.SUM_QTY - A.MFG_QTY < 0							THEN 0
													 WHEN A.SUM_QTY - A.MFG_QTY < A.REMAIN_QTY				THEN A.SUM_QTY - A.MFG_QTY
																											ELSE A.REMAIN_QTY
															END  )
							   ,TOTAL_QTY		= A.SUM_QTY
							   ,SCP_SEQ 		= A.ROW_SEQ
							   ,SCP_DEMAND_ID	= A.FP_DEMAND_ID+'_'+@v_work_order_id
						FROM	(  
									SELECT A.*
											, SUM(A.REMAIN_QTY) OVER (	PARTITION BY	A.SITE_ID, A.OPERATION_ID, A.PRODUCTION_TYPE, A.ITEM_ID
																		ORDER     BY	(CASE WHEN DATA_TYPE = 'R' THEN 1 
																			  				  WHEN DATA_TYPE = 'X' THEN 2
																							  WHEN DATA_TYPE = 'P' THEN 3 
																							  ELSE 9
																						 END ), A.PLAN_DATE, A.PLAN_QTY DESC
																	 ) AS SUM_QTY
											, ROW_NUMBER() OVER (	PARTITION BY A.SITE_ID, A.OPERATION_ID, A.PRODUCTION_TYPE, A.ITEM_ID
																	ORDER     BY (CASE WHEN DATA_TYPE = 'R' THEN 1 
																					   WHEN DATA_TYPE = 'X' THEN 2
																					   WHEN DATA_TYPE = 'P' THEN 3 
																					   ELSE 9
																				  END ), A.PLAN_DATE, A.PLAN_QTY DESC
																) AS ROW_SEQ
											, B.FP_DEMAND_ID, B.REMAIN_MFG_QTY AS MFG_QTY
									FROM	TH_BUF_RAW_DATA A , 
											(
												SELECT	A.*
												FROM	TH_BUF_SCP_TARGET A
												WHERE	1=1
												AND		A.INSTANCE_ID	= @v_master_id
												AND		A.FP_PLAN_ID	= @v_plan_id
												AND		A.OPERATION_ID	= @in_operation_id
												--AND		A.TARGET_SEQ	= @n_target_seq
												AND		A.FP_DEMAND_ID	= @v_demand_pegging_id
												AND		A.WORK_ORDER_ID = @v_work_order_id
												AND		A.ITEM_ID		= @v_item_id
												AND		A.REMAIN_MFG_QTY > 0
											) B
									WHERE 1=1
									AND	A.INSTANCE_ID	= @v_master_id
									AND	A.FP_PLAN_ID	= @v_plan_id
									AND	A.OPERATION_ID	= @in_operation_id
									AND A.COMPANY_ID	= B.COMPANY_ID
									AND A.DIVISION_ID	= B.DIVISION_ID
									AND A.SITE_ID		= B.SITE_ID
									AND A.PLANT_ID		= B.PLANT_ID
									AND A.ITEM_ID		= B.ITEM_ID
									AND A.LINE_ID		= B.LINE_ID
									AND A.PRODUCTION_TYPE	= B.PRODUCTION_TYPE
									AND A.MARKET		= B.MARKET
									AND A.REMAIN_QTY > 0
									AND A.DATA_TYPE IN ('P','X')
								) A
						WHERE 1=1

						--SET @v_message = 'RESULT_OFFSET_3 : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
						--SET @n_log_count = @n_log_count + 1
						--SET @sysdate = GETDATE()
						--EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

						-- target reamin_mfg_qty 조정
						EXECUTE PR_SCM_OF_DEMAND_ORDER_TRACKING_SUB @v_master_id, @v_plan_id, @v_basic_plan_id, @in_operation_id, 0, 'SUB_TARGET', @v_demand_pegging_id, @v_work_order_id, @v_item_id
						

						-- 실적 차감4
						SET @v_table_name = 'TH_BUF_RAW_DATA'

						UPDATE	A
						SET		REMAIN_QTY	= ( CASE WHEN A.SUM_QTY - A.MFG_QTY < 0							THEN 0
													 WHEN A.SUM_QTY - A.MFG_QTY < A.REMAIN_QTY				THEN A.SUM_QTY - A.MFG_QTY
																											ELSE A.REMAIN_QTY
															END  )
							   ,TOTAL_QTY		= A.SUM_QTY
							   ,SCP_SEQ 		= A.ROW_SEQ
							   ,SCP_DEMAND_ID	= A.FP_DEMAND_ID+'_'+@v_work_order_id
						FROM	(  
									SELECT A.*
											, SUM(A.REMAIN_QTY) OVER (	PARTITION BY	A.OPERATION_ID, A.LINE_ID, A.PRODUCTION_TYPE, A.ITEM_ID
																		ORDER     BY	(CASE WHEN DATA_TYPE = 'R' THEN 1 
																			  				  WHEN DATA_TYPE = 'X' THEN 2
																							  WHEN DATA_TYPE = 'P' THEN 3 
																							  ELSE 9
																						 END ), A.PLAN_DATE, A.PLAN_QTY DESC
																	 ) AS SUM_QTY
											, ROW_NUMBER() OVER (	PARTITION BY A.OPERATION_ID, A.LINE_ID, A.PRODUCTION_TYPE, A.ITEM_ID
																	ORDER     BY (CASE WHEN DATA_TYPE = 'R' THEN 1 
																					   WHEN DATA_TYPE = 'X' THEN 2
																					   WHEN DATA_TYPE = 'P' THEN 3 
																					   ELSE 9
																				  END ), A.PLAN_DATE, A.PLAN_QTY DESC
																) AS ROW_SEQ
											, B.FP_DEMAND_ID, B.REMAIN_MFG_QTY AS MFG_QTY
									FROM	TH_BUF_RAW_DATA A , 
											(
												SELECT	A.*
												FROM	TH_BUF_SCP_TARGET A
												WHERE	1=1
												AND		A.INSTANCE_ID	= @v_master_id
												AND		A.FP_PLAN_ID	= @v_plan_id
												AND		A.OPERATION_ID	= @in_operation_id
												--AND		A.TARGET_SEQ	= @n_target_seq
												AND		A.FP_DEMAND_ID	= @v_demand_pegging_id
												AND		A.WORK_ORDER_ID = @v_work_order_id
												AND		A.ITEM_ID		= @v_item_id
												AND		A.REMAIN_MFG_QTY > 0
											) B
									WHERE 1=1
									AND	A.INSTANCE_ID	= @v_master_id
									AND	A.FP_PLAN_ID	= @v_plan_id
									AND	A.OPERATION_ID	= @in_operation_id
									AND A.COMPANY_ID	= B.COMPANY_ID
									AND A.DIVISION_ID	= B.DIVISION_ID
									AND A.SITE_ID		= B.SITE_ID
									AND A.PLANT_ID		= B.PLANT_ID
									AND A.ITEM_ID		= B.ITEM_ID
									AND A.LINE_ID		= B.LINE_ID
									AND A.PRODUCTION_TYPE	= B.PRODUCTION_TYPE
									AND A.MARKET		= B.MARKET
									AND A.REMAIN_QTY > 0
									AND A.DATA_TYPE IN ('P','X')
								) A
						WHERE 1=1

						--SET @v_message = 'RESULT_OFFSET_4 : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
						--SET @n_log_count = @n_log_count + 1
						--SET @sysdate = GETDATE()
						--EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

						-- target reamin_mfg_qty 조정
						EXECUTE PR_SCM_OF_DEMAND_ORDER_TRACKING_SUB @v_master_id, @v_plan_id, @v_basic_plan_id, @in_operation_id, 0, 'SUB_TARGET', @v_demand_pegging_id, @v_work_order_id, @v_item_id
						
						
						-- 실적 차감5
						SET @v_table_name = 'TH_BUF_RAW_DATA'

						UPDATE	A
						SET		REMAIN_QTY	= ( CASE WHEN A.SUM_QTY - A.MFG_QTY < 0							THEN 0
													 WHEN A.SUM_QTY - A.MFG_QTY < A.REMAIN_QTY				THEN A.SUM_QTY - A.MFG_QTY
																											ELSE A.REMAIN_QTY
															END  )
							   ,TOTAL_QTY		= A.SUM_QTY
							   ,SCP_SEQ 		= A.ROW_SEQ
							   ,SCP_DEMAND_ID	= A.FP_DEMAND_ID+'_'+@v_work_order_id
						FROM	(  
									SELECT A.*
											, SUM(A.REMAIN_QTY) OVER (	PARTITION BY	A.OPERATION_ID, A.PRODUCTION_TYPE, A.ITEM_ID
																		ORDER     BY	(CASE WHEN DATA_TYPE = 'R' THEN 1 
																			  				  WHEN DATA_TYPE = 'X' THEN 2
																							  WHEN DATA_TYPE = 'P' THEN 3 
																							  ELSE 9
																						 END ), A.PLAN_DATE, A.PLAN_QTY DESC
																	 ) AS SUM_QTY
											, ROW_NUMBER() OVER (	PARTITION BY A.OPERATION_ID, A.PRODUCTION_TYPE, A.ITEM_ID
																	ORDER     BY (CASE WHEN DATA_TYPE = 'R' THEN 1 
																					   WHEN DATA_TYPE = 'X' THEN 2
																					   WHEN DATA_TYPE = 'P' THEN 3 
																					   ELSE 9
																				  END ), A.PLAN_DATE, A.PLAN_QTY DESC
																) AS ROW_SEQ
											, B.FP_DEMAND_ID, B.REMAIN_MFG_QTY AS MFG_QTY
									FROM	TH_BUF_RAW_DATA A , 
											(
												SELECT	A.*
												FROM	TH_BUF_SCP_TARGET A
												WHERE	1=1
												AND		A.INSTANCE_ID	= @v_master_id
												AND		A.FP_PLAN_ID	= @v_plan_id
												AND		A.OPERATION_ID	= @in_operation_id
												--AND		A.TARGET_SEQ	= @n_target_seq
												AND		A.FP_DEMAND_ID	= @v_demand_pegging_id
												AND		A.WORK_ORDER_ID = @v_work_order_id
												AND		A.ITEM_ID		= @v_item_id
												AND		A.REMAIN_MFG_QTY > 0
											) B
									WHERE 1=1
									AND	A.INSTANCE_ID	= @v_master_id
									AND	A.FP_PLAN_ID	= @v_plan_id
									AND	A.OPERATION_ID	= @in_operation_id
									AND A.COMPANY_ID	= B.COMPANY_ID
									AND A.DIVISION_ID	= B.DIVISION_ID
									AND A.SITE_ID		= B.SITE_ID
									AND A.PLANT_ID		= B.PLANT_ID
									AND A.ITEM_ID		= B.ITEM_ID
									AND A.LINE_ID		= B.LINE_ID
									AND A.PRODUCTION_TYPE	= B.PRODUCTION_TYPE
									AND A.MARKET		= B.MARKET
									AND A.REMAIN_QTY > 0
									AND A.DATA_TYPE IN ('P','X')
								) A
						WHERE 1=1

						--SET @v_message = 'RESULT_OFFSET_5 : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
						--SET @n_log_count = @n_log_count + 1
						--SET @sysdate = GETDATE()
						--EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

						-- target reamin_mfg_qty 조정
						EXECUTE PR_SCM_OF_DEMAND_ORDER_TRACKING_SUB @v_master_id, @v_plan_id, @v_basic_plan_id, @in_operation_id, 0, 'SUB_TARGET', @v_demand_pegging_id, @v_work_order_id, @v_item_id
						

						--if @v_work_order_id = 'K20304ST0001' AND @v_item_id = 'ABCAT0450A'  break
						--if @v_work_order_id = 'WK20226ST#KA1#A1#04#0052' AND @v_item_id = 'ABCAT0450A'  break
						--if @v_work_order_id = 'K20304ST0001' AND @v_item_id = 'ABCCT0435A'  break
						--if @v_work_order_id = 'WK20226ST#KA1#A1#04#0052' AND @v_item_id = 'ABCCT0435A'  break
					
						SET @v_table_name = 'FP_ORDER_TRACKING_WO_R'

						--DELETE FP_ORDER_TRACKING_WO_R
						--WHERE	1=1
						--AND		INSTANCE_ID	= @v_master_id
						--AND		FP_PLAN_ID	= @v_plan_id
						--AND		OPERATION_ID	= @in_operation_id 
						--AND		SCP_DEMAND_PEGGING_ID	=	@v_demand_pegging_id
						--AND		WORK_ORDER_ID =	@v_work_order_id
						--AND		ITEM_ID		= @v_item_id

						INSERT INTO FP_ORDER_TRACKING_WO_R
						(
							INSTANCE_ID
							,FP_PLAN_ID
							,COMPANY_ID
							,DIVISION_ID
							,SITE_ID
							,PLANT_ID
							,FACTORY_ID
							,OPERATION_ID
							,LINE_ID
							,LOCATION
							,PRODUCTION_TYPE
							,FP_PRODUCTION_TYPE
							,MARKET
							,ELECTRODE_TYPE
							,TOP_ITEM_ID
							,ITEM_ID
							,SCP_DEMAND_PEGGING_ID
							,WORK_ORDER_ID
							,PARENT_WORK_ORDER_ID
							,PLAN_DATE
							,ORG_PLAN_QTY
							,ORG_PLAN_IN_QTY
							,PLAN_QTY
							,PLAN_IN_QTY
							,INSERT_ID
							,INSERT_DTTM
							,UPDATE_ID
							,UPDATE_DTTM
						)
						SELECT	INSTANCE_ID
								,FP_PLAN_ID
								,COMPANY_ID
								,DIVISION_ID
								,SITE_ID
								,PLANT_ID
								,FACTORY_ID
								,OPERATION_ID
								,LINE_ID
								,'-' AS LOCATION
								,PRODUCTION_TYPE
								,FP_PRODUCTION_TYPE
								,MARKET
								,ELECTRODE_TYPE
								,TOP_ITEM_ID
								,ITEM_ID
								,SCP_DEMAND_PEGGING_ID
								,WORK_ORDER_ID
								,@v_work_order_id AS PARENT_WORK_ORDER_ID
								,PLAN_DATE
								,ORG_PLAN_QTY
								,ORG_PLAN_IN_QTY
								,PLAN_QTY
								,PLAN_IN_QTY
								,@v_proc_name AS INSERT_ID
								,GETDATE() AS INSERT_DTTM
								,@v_proc_name AS UPDATE_ID
								,GETDATE() AS UPDATE_DTTM
						FROM	(
									SELECT	A.INSTANCE_ID, A.FP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID
											, A.LINE_ID, '-' AS LOCATION_ID, A.PRODUCTION_TYPE, A.FP_PRODUCTION_TYPE, A.MARKET, A.ELECTRODE_TYPE, A.TOP_ITEM_ID, A.ITEM_ID
											--, A.SCP_DEMAND_ID+'_' + CONVERT(NVARCHAR,REPLICATE('0',3 - LEN(A.SCP_SEQ)) + CAST(A.SCP_SEQ AS VARCHAR)) AS SCP_DEMAND_PEGGING_ID
											, @v_demand_pegging_id AS SCP_DEMAND_PEGGING_ID
											, A.WORK_ORDER_ID
											, A.PLAN_DATE
											, A.PLAN_QTY AS ORG_PLAN_QTY
											, A.PLAN_IN_QTY AS ORG_PLAN_IN_QTY
											--, CASE WHEN REMAIN_QTY = 0 THEN A.PLAN_QTY 
											--								ELSE (A.TOTAL_QTY - B.MFG_QTY) 
											--	END AS PLAN_QTY
											, CASE	WHEN A.PLAN_QTY > A.TOTAL_QTY						THEN	A.TOTAL_QTY - A.REMAIN_QTY 
													WHEN A.PLAN_QTY < A.TOTAL_QTY  AND A.REMAIN_QTY = 0 THEN	A.PLAN_QTY
																										ELSE	A.PLAN_QTY - A.REMAIN_QTY 
											  END PLAN_QTY
											, (CASE WHEN REMAIN_QTY = 0 THEN A.PLAN_QTY 
																			ELSE (A.TOTAL_QTY - B.MFG_QTY) 
												END ) / 0.99 AS PLAN_IN_QTY
									FROM	TH_BUF_RAW_DATA A, TH_BUF_SCP_TARGET B
									WHERE	1=1
									AND		A.INSTANCE_ID	= @v_master_id
									AND		A.FP_PLAN_ID	= @v_plan_id
									AND		A.OPERATION_ID	= @in_operation_id
									AND		B.INSTANCE_ID	= @v_master_id
									AND		B.FP_PLAN_ID	= @v_plan_id
									AND		B.OPERATION_ID	= @in_operation_id
									--AND		B.TARGET_SEQ	= @v_target_seq
									AND		B.FP_DEMAND_ID	=	@v_demand_pegging_id
									AND		B.WORK_ORDER_ID =	@v_work_order_id
									AND		B.ITEM_ID		= @v_item_id
									AND		A.SCP_DEMAND_ID = B.FP_DEMAND_ID+'_'+@v_work_order_id
									AND		A.ITEM_ID		= B.ITEM_ID
									AND		A.PRODUCTION_TYPE		= B.PRODUCTION_TYPE
									AND		A.PLAN_QTY		<> A.REMAIN_QTY

								) A
						WHERE	1=1

						--SET @v_message = 'WO_TRACKING_1 : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
						--SET @n_log_count = @n_log_count + 1
						--SET @sysdate = GETDATE()
						--EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

					END -- WHILE END

				END --C_DEMAND_SEQ END

				CLOSE       C_DEMAND_SEQ
				DEALLOCATE  C_DEMAND_SEQ
					
				--LOG 생성
				SET @v_message = CONVERT(NVARCHAR, @@ROWCOUNT)
				SET @n_log_count = @n_log_count + 1
				SET @sysdate = GETDATE()
				EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
				
				DELETE FP_ORDER_TRACKING_WO_R_ORG
				WHERE	1=1
				AND		INSTANCE_ID	= @v_master_id
				AND		FP_PLAN_ID	= @v_plan_id
				AND		OPERATION_ID	= @in_operation_id 


				INSERT INTO FP_ORDER_TRACKING_WO_R_ORG
				(
					INSTANCE_ID
					, FP_PLAN_ID
					, COMPANY_ID
					, DIVISION_ID
					, SITE_ID
					, PLANT_ID
					, FACTORY_ID
					, OPERATION_ID
					, LINE_ID
					, LOCATION
					, PRODUCTION_TYPE
					, FP_PRODUCTION_TYPE
					, MARKET
					, ELECTRODE_TYPE
					, TOP_ITEM_ID
					, ITEM_ID
					, SCP_DEMAND_PEGGING_ID
					, WORK_ORDER_ID
					, PLAN_DATE
					, ORG_PLAN_QTY
					, ORG_PLAN_IN_QTY
					, PLAN_QTY
					, PLAN_IN_QTY
					, INSERT_ID
					, INSERT_DTTM
					, UPDATE_ID
					, UPDATE_DTTM
					, PARENT_WORK_ORDER_ID
				)
				SELECT INSTANCE_ID
					, FP_PLAN_ID
					, COMPANY_ID
					, DIVISION_ID
					, SITE_ID
					, PLANT_ID
					, FACTORY_ID
					, OPERATION_ID
					, LINE_ID
					, LOCATION
					, PRODUCTION_TYPE
					, FP_PRODUCTION_TYPE
					, MARKET
					, ELECTRODE_TYPE
					, TOP_ITEM_ID
					, ITEM_ID
					, SCP_DEMAND_PEGGING_ID
					, WORK_ORDER_ID
					, PLAN_DATE
					, ORG_PLAN_QTY
					, ORG_PLAN_IN_QTY
					, PLAN_QTY
					, PLAN_IN_QTY
					, INSERT_ID
					, INSERT_DTTM
					, UPDATE_ID
					, UPDATE_DTTM
					, PARENT_WORK_ORDER_ID
				FROM FP_ORDER_TRACKING_WO_R
				WHERE	1=1
				AND		INSTANCE_ID	= @v_master_id
				AND		FP_PLAN_ID	= @v_plan_id
				AND		OPERATION_ID	= @in_operation_id
				
				DELETE FP_ORDER_TRACKING_WO_R
				WHERE	1=1
				AND		INSTANCE_ID	= @v_master_id
				AND		FP_PLAN_ID	= @v_plan_id
				AND		OPERATION_ID	= @in_operation_id 

				INSERT INTO FP_ORDER_TRACKING_WO_R
				(
					INSTANCE_ID
					, FP_PLAN_ID
					, COMPANY_ID
					, DIVISION_ID
					, SITE_ID
					, PLANT_ID
					, FACTORY_ID
					, OPERATION_ID
					, LINE_ID
					, LOCATION
					, PRODUCTION_TYPE
					, FP_PRODUCTION_TYPE
					, MARKET
					, ELECTRODE_TYPE
					, TOP_ITEM_ID
					, ITEM_ID
					, SCP_DEMAND_PEGGING_ID
					, WORK_ORDER_ID
					, PLAN_DATE
					, ORG_PLAN_QTY
					, ORG_PLAN_IN_QTY
					, PLAN_QTY
					, PLAN_IN_QTY
					, INSERT_ID
					, INSERT_DTTM
					, UPDATE_ID
					, UPDATE_DTTM
					, PARENT_WORK_ORDER_ID
				)
				SELECT	INSTANCE_ID
						, FP_PLAN_ID
						, COMPANY_ID
						, DIVISION_ID
						, SITE_ID
						, PLANT_ID
						, FACTORY_ID
						, OPERATION_ID
						, LINE_ID
						, LOCATION
						, PRODUCTION_TYPE
						, FP_PRODUCTION_TYPE
						, MARKET
						, ELECTRODE_TYPE
						, TOP_ITEM_ID
						, ITEM_ID
						, SCP_DEMAND_PEGGING_ID
						, WORK_ORDER_ID
						, PLAN_DATE
						, ORG_PLAN_QTY
						, ORG_PLAN_IN_QTY
						, PLAN_QTY
						, PLAN_IN_QTY
						, '' INSERT_ID
						, GETDATE() AS INSERT_DTTM
						, '' AS UPDATE_ID
						, GETDATE() UPDATE_DTTM
						, '' PARENT_WORK_ORDER_ID
				FROM	(
							SELECT
									INSTANCE_ID
									, FP_PLAN_ID
									, COMPANY_ID
									, DIVISION_ID
									, SITE_ID
									, PLANT_ID
									, FACTORY_ID
									, OPERATION_ID
									, LINE_ID
									, LOCATION
									, PRODUCTION_TYPE
									, FP_PRODUCTION_TYPE
									, MARKET
									, ELECTRODE_TYPE
									, TOP_ITEM_ID
									, ITEM_ID
									, SCP_DEMAND_PEGGING_ID
									, WORK_ORDER_ID
									, PLAN_DATE
									, MAX(ORG_PLAN_QTY) AS ORG_PLAN_QTY
									, MAX(ORG_PLAN_IN_QTY) AS ORG_PLAN_IN_QTY
									, SUM(PLAN_QTY) AS PLAN_QTY
									, SUM(PLAN_IN_QTY) AS PLAN_IN_QTY
							FROM	FP_ORDER_TRACKING_WO_R_ORG 
							WHERE	1=1
							AND		INSTANCE_ID	= @v_master_id
							AND		FP_PLAN_ID	= @v_plan_id
							AND		OPERATION_ID	= @in_operation_id
							GROUP BY INSTANCE_ID
									, FP_PLAN_ID
									, COMPANY_ID
									, DIVISION_ID
									, SITE_ID
									, PLANT_ID
									, FACTORY_ID
									, OPERATION_ID
									, LINE_ID
									, LOCATION
									, PRODUCTION_TYPE
									, FP_PRODUCTION_TYPE
									, MARKET
									, ELECTRODE_TYPE
									, TOP_ITEM_ID
									, ITEM_ID
									, SCP_DEMAND_PEGGING_ID
									, WORK_ORDER_ID
									, PLAN_DATE
						) A
					WHERE 1=1
				
		
			END --C_PSO_OPERATION WHILE END

			CLOSE       C_PSO_OPERATION
			DEALLOCATE  C_PSO_OPERATION

			--LOG 생성
			SET @v_message = CONVERT(NVARCHAR, @@ROWCOUNT)
			SET @n_log_count = @n_log_count + 1
			SET @sysdate = GETDATE()
			EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

	END --하위	


	---- Plan In QTY Update
		--UPDATE	A
		--SET		A.PLAN_IN_QTY		= CASE WHEN ISNULL(A.PLAN_QTY,0) > 0 AND ISNULL(B.YIELD, 0) > 0 THEN CEILING(A.PLAN_QTY / ISNULL(B.YIELD, 1)) ELSE 0 END --CEILING(A.PLAN_QTY / ISNULL(D.YIELD, C.YIELD))
		--	  , A.ORG_PLAN_IN_QTY	= CASE WHEN ISNULL(A.ORG_PLAN_QTY,0) > 0 AND ISNULL(B.YIELD, 0) > 0 THEN CEILING(A.PLAN_QTY / ISNULL(B.YIELD, 1)) ELSE 0 END
		--FROM	FP_ORDER_TRACKING_WO_R A
		--		LEFT OUTER JOIN SCM_YIELD_M B WITH(NOLOCK)
		--		ON 1=1
		--		AND A.COMPANY_ID	= B.COMPANY_ID
		--		AND A.DIVISION_ID	= B.DIVISION_ID
		--		AND A.SITE_ID		= B.SITE_ID
		--		AND A.PLANT_ID		= B.PLANT_ID
		--		AND A.FACTORY_ID	= B.FACTORY_ID
		--		AND A.OPERATION_ID	= B.OPERATION_ID
		--		AND A.LINE_ID		= B.LINE_ID
		--		AND A.ITEM_ID		= B.ITEM_ID
		--		AND CONVERT(VARCHAR(6), A.PLAN_DATE,112) = B.MONTH
		--WHERE	1=1
		--AND		A.INSTANCE_ID	=	@v_master_id
		--AND		A.FP_PLAN_ID	=	@v_plan_id
		----AND		A.OPERATION_ID	=	@v_operation_id

		--SET @v_message = 'PLAN IN QTY : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
		--SET @n_log_count = @n_log_count + 1
		--SET @sysdate = GETDATE()
		--EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
    

  END TRY

  BEGIN CATCH
    --ROLLBACK

	BEGIN
		
		IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'C_DEMAND_SEQ')
		BEGIN
			CLOSE C_DEMAND_SEQ
			DEALLOCATE C_DEMAND_SEQ
		END

		IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'C_TARGET_SEQ')
		BEGIN
			CLOSE C_TARGET_SEQ
			DEALLOCATE C_TARGET_SEQ
		END

		IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'C_PSO_OPERATION')
		BEGIN
			CLOSE C_PSO_OPERATION
			DEALLOCATE C_PSO_OPERATION
		END

    SET @v_descr = ERROR_MESSAGE()
    SET @sysdate = GETDATE()

    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_temp2, null, @v_descr
    commit;

	END

  END CATCH

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

END
