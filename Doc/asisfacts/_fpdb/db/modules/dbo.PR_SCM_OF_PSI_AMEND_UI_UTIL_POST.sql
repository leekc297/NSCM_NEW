CREATE PROCEDURE [dbo].[PR_SCM_OF_PSI_AMEND_UI_UTIL_POST]
@p_instance_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_OF_PSI_AMEND_UI_UTIL                                               **/
/** 프로그램 명   : PSI_AMEND_UI 초기자료 생성                                                **/
/** 설 명         :                                                                           **/
/** Version       : 1.0.0                                                                     **/
/**                                                                                           **/
/** Argument                                                                                  **/
/**                                                                                           **/
/**  [검색 조건]                                                                              **/
/**                                                                                           **/
/** [Biz Logic]                                                                               **/
/**                                                                                           **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                                    **/
/**===========================================================================================**/
/** 2020.12.    CYS         전극 후공정 UTIL 계산                                                  **/
/***********************************************************************************************/
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;

	-- 필수 칼럼
	DECLARE @v_master_id        nvarchar(30)    = @p_instance_id
	DECLARE @v_plan_id          nvarchar(30)    = @p_plan_id

	-- LOG 용 변수 설정
	DECLARE @v_proc_name        nvarchar(100) = 'PR_SCM_OF_PSI_AMEND_UI_UTIL_POST'
	DECLARE @v_table_name       nvarchar(100)
	DECLARE @v_message          nvarchar(250)
	DECLARE @v_descr            nvarchar(250)
	DECLARE @n_row_count        Integer  = 0
	DECLARE @n_log_count        Integer  = 0
	DECLARE @v_log_code         nvarchar(10)
  
	DECLARE @logdate            DATETIME2 = GETDATE()
	DECLARE @sysdate            DATETIME2 = GETDATE()
  
	DECLARE @v_temp1            nvarchar(1000)
	DECLARE @v_temp2            nvarchar(1000)
  
	-- 사용자 변수 설정
	DECLARE @v_final_op_capa    nvarchar(20)
		, @v_start_date       DATE
		, @v_end_date         DATE
		, @n_count            Integer  = 0
		, @n_old_count        Integer  = 0
		, @n_day_diff         numeric(20, 10)
		, @v_sqltext          nvarchar(MAX)
		, @v_sqltable         nvarchar(30)        

	SET @v_temp1 = 'S' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
	SET @v_temp2 = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))

	EXEC PR_LOG2_RUNLOG  @logdate, @v_master_id, @v_plan_id, @v_proc_name, 'START', null
  
	SET @n_log_count = @n_log_count + 1
	SET @sysdate = GETDATE()
	EXEC pr_log2_process @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

	BEGIN TRY	--1
    
		BEGIN --2
    
			BEGIN --3
      
				SET @v_table_name = 'TH_MST_PLAN'
              
				SELECT  @v_start_date   = CONVERT(DATE, PLAN_START_TIME)
					  , @v_end_date     = DATEADD(DAY, PLAN_HORIZON + 7, CONVERT(DATE, PLAN_START_TIME))
					  , @n_day_diff     = DATEDIFF(MINUTE, CONVERT(DATE, PLAN_START_TIME), PLAN_START_TIME)
				FROM    SCM_FP_PLAN_H WITH(NOLOCK)
				WHERE   INSTANCE_ID = @v_master_id 
				AND     PLAN_ID     = @v_plan_id
      
				--LOG 생성
				SET @v_message  = '@v_start_date : ' + convert(nvarchar, @v_start_date, 112)
				SET @v_message += ' / ' + '@v_end_date : ' + convert(nvarchar, @v_end_date, 112)
				SET @n_log_count += 1
				EXECUTE pr_log2_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

				SET @v_table_name = 'FP_INSTANCE_CONFIG_M'

				SELECT @v_final_op_capa = ISNULL(MAX(KEY_VALUE), 'TACT_TIME')
				FROM   FP_INSTANCE_CONFIG_M WITH(NOLOCK)
				WHERE  INSTANCE_ID = @v_master_id
				AND    CATEGORY_ID = 'PLAN_CATEGORY'
				AND    KEY_ID      = 'FINAL_OP_CAPA'
        
				--LOG 생성
				SET @v_message = 'FINAL_OP_CAPA : ' + @v_final_op_capa
				SET @n_log_count = @n_log_count + 1
				SET @sysdate = GETDATE()
				EXECUTE pr_log2_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
    
			END

	  --Start
    
      ---------------------------------------------------------------------------------------------
      -- TH_BUF_AMEND_PSI_UTIL_LINE_CHECK 생성
      ---------------------------------------------------------------------------------------------
			BEGIN --3
      
				BEGIN --4

					SET @v_table_name = 'TH_BUF_AMEND_PSI_UTIL_LINE_CHECK'
					SET @n_count       = 0

					DELETE FROM TH_BUF_AMEND_PSI_UTIL_LINE_CHECK
					--WHERE  INSTANCE_ID  = @v_master_id
					--AND    FP_PLAN_ID   = @v_plan_id


				-- AMEND 정보가 변경된 것인지 CHECK
				--BEGIN
          
					INSERT INTO TH_BUF_AMEND_PSI_UTIL_LINE_CHECK
					(
						INSTANCE_ID, FP_PLAN_ID
						, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID
						, FACTORY_ID, LINE_ID, OPERATION_ID, ELECTRODE_TYPE, EQUIPMENT_ID, SHIFT 
					)
					SELECT 	DISTINCT 
								   INSTANCE_ID, FP_PLAN_ID 
								 , COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID 
								 , FACTORY_ID, LINE_ID, OPERATION_ID, ELECTRODE_TYPE, LINE_ID AS EQUIPMENT_ID , SHIFT
					FROM   ( 
									SELECT INSTANCE_ID, FP_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID 
											 , ITEM_ID, OPERATION_ID, FACTORY_ID, LOCATION, PRODUCTION_TYPE, MARKET, LINE_ID 
											 , ELECTRODE_TYPE, PLAN_DATE, TOP_ITEM_ID, SHIFT
									FROM   FP_AMEND_PLAN_POST_R  A WITH(NOLOCK)
									WHERE  INSTANCE_ID = @v_master_id
									AND    FP_PLAN_ID  = @v_plan_id
									AND    ADJUST_OUT_QTY_M     > 0 
									AND    CONVERT(NVARCHAR, A.PLAN_DATE, 112) >=  CONVERT(NVARCHAR, @v_start_date, 112)
									AND    NOT EXISTS ( 
																   SELECT 1 
																   FROM   TH_BUF_AMEND_PSI_UTIL_LINE_CHECK X 
																   WHERE  X.INSTANCE_ID    = A.INSTANCE_ID 
																   AND    X.FP_PLAN_ID     = A.FP_PLAN_ID 
																   AND    X.COMPANY_ID     = A.COMPANY_ID 
																   AND    X.DIVISION_ID    = A.DIVISION_ID 
																   AND    X.SITE_ID        = A.SITE_ID 
																   AND    X.PLANT_ID       = A.PLANT_ID 
																   AND    X.FACTORY_ID     = A.FACTORY_ID 
																   AND    X.OPERATION_ID   = A.OPERATION_ID 
																   AND    X.LINE_ID        = A.LINE_ID 
																   AND    X.ELECTRODE_TYPE = A.ELECTRODE_TYPE 
						                          			) 
									EXCEPT 
									SELECT INSTANCE_ID, FP_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID 
											 , ITEM_ID, OPERATION_ID, FACTORY_ID, LOCATION, PRODUCTION_TYPE, MARKET, LINE_ID 
											 , ELECTRODE_TYPE , PLAN_DATE, TOP_ITEM_ID, SHIFT
									FROM   TH_BUF_AMEND_PSI_PLAN_BACK A WITH(NOLOCK)
									WHERE  INSTANCE_ID = @v_master_id
									AND    FP_PLAN_ID  = @v_plan_id
									AND    OUT_QTY	   > 0 
						   ) A 
				       
				

							--SET @v_sqltext  = '' 
							--				+ 'INSERT INTO TH_BUF_AMEND_PSI_UTIL_LINE_CHECK '
							--				+ '     ( '
							--				+ '       INSTANCE_ID, FP_PLAN_ID '
							--				+ '     , COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID '
							--				+ '     , FACTORY_ID, LINE_ID, OPERATION_ID, ELECTRODE_TYPE '
							--				+ '     ) '
							--				+ 'SELECT DISTINCT '
							--				+ '       INSTANCE_ID, FP_PLAN_ID '
							--				+ '     , COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID '
							--				+ '     , FACTORY_ID, LINE_ID, OPERATION_ID, ELECTRODE_TYPE '
							--				+ 'FROM   ( '
							--				+ '        SELECT INSTANCE_ID, FP_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID '
							--				+ '             , ITEM_ID, OPERATION_ID, FACTORY_ID, LOCATION, PRODUCTION_TYPE, MARKET, LINE_ID '
							--				+ '             , ELECTRODE_TYPE , PLAN_DATE, TOP_ITEM_ID, ITEM_TYPE, IN_QTY, OUT_QTY '
							--				+ '        FROM   TH_BUF_AMEND_PSI_PLAN_BACK A WITH(NOLOCK)'
							--				+ '        WHERE  INSTANCE_ID = '''+@v_master_id+''' '
							--				+ '        AND    FP_PLAN_ID  = '''+@v_plan_id+''' '
							--				+ '        AND    OUT_QTY     > 0 '
							--				+ '        AND    NOT EXISTS ( '
							--				+ '                           SELECT 1 '
							--				+ '                           FROM   TH_BUF_AMEND_PSI_UTIL_LINE_CHECK X '
							--				+ '                           WHERE  X.INSTANCE_ID    = A.INSTANCE_ID '
							--				+ '                           AND    X.FP_PLAN_ID     = A.FP_PLAN_ID '
							--				+ '                           AND    X.COMPANY_ID     = A.COMPANY_ID '
							--				+ '                           AND    X.DIVISION_ID    = A.DIVISION_ID '
							--				+ '                           AND    X.SITE_ID        = A.SITE_ID '
							--				+ '                           AND    X.PLANT_ID       = A.PLANT_ID '
							--				+ '                           AND    X.FACTORY_ID     = A.FACTORY_ID '
							--				+ '                           AND    X.OPERATION_ID   = A.OPERATION_ID '
							--				+ '                           AND    X.LINE_ID        = A.LINE_ID '
							--				+ '                           AND    X.ELECTRODE_TYPE = A.ELECTRODE_TYPE '
							--				+ '                          ) '
							--				+ '        EXCEPT '
							--				+ '        SELECT INSTANCE_ID, FP_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID '
							--				+ '             , ITEM_ID, OPERATION_ID, FACTORY_ID, LOCATION, PRODUCTION_TYPE, MARKET, LINE_ID '
							--				+ '             , ELECTRODE_TYPE , PLAN_DATE, TOP_ITEM_ID, ITEM_TYPE, IN_QTY, OUT_QTY '
							--				+ '        FROM   ' + @v_sqltable + ' A WITH(NOLOCK) '
							--				+ '        WHERE  INSTANCE_ID = '''+@v_master_id+''' '
							--				+ '        AND    FP_PLAN_ID  = '''+@v_plan_id+''' '
							--				+ '        AND    OUT_QTY     > 0 '
							--				+ '        AND    CONVERT(NVARCHAR, A.PLAN_DATE, 112) >=  '''+convert(nvarchar, @v_start_date, 112)+''' '
							--				+ '       ) A '

							--EXEC sp_executesql @v_sqltext, N'@v_return AS INTEGER OUTPUT', @v_return=@n_row_count OUTPUT

							---- TABLE COUNT
							--SELECT @n_count = COUNT(1)
							--FROM   TH_BUF_AMEND_PSI_UTIL_LINE_CHECK
							--WHERE  INSTANCE_ID  = @v_master_id
							--AND    FP_PLAN_ID   = @v_plan_id
            
							--SET @n_row_count = @n_count - @n_old_count
							--SET @n_old_count = @n_count
            
							--LOG 생성
							SET @v_message   = 'AMEND CHECK : ' + CONVERT(NVARCHAR, @n_row_count)
							SET @n_log_count = @n_log_count + 1
							SET @sysdate     = GETDATE()
							EXECUTE pr_log2_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
            
				END	--4


				-- OFF CALENDAR 가 변경되는지 유무 CHECK
				BEGIN	--4
          
					INSERT INTO TH_BUF_AMEND_PSI_UTIL_LINE_CHECK 
					( 
						   INSTANCE_ID, FP_PLAN_ID 
						 , COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID 
						 , FACTORY_ID, LINE_ID, OPERATION_ID, ELECTRODE_TYPE 
					) 
					SELECT DISTINCT 
							   INSTANCE_ID, FP_PLAN_ID 
							 , COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID 
							 , FACTORY_ID, LINE_ID, OPERATION_ID, ELECTRODE_TYPE 
					FROM   ( 
									SELECT B.INSTANCE_ID, B.FP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID 
											 , A.FACTORY_ID, A.OPERATION_ID , A.LINE_ID, A.ELECTRODE_TYPE 
											 , A.OFF_DATE AS PLAN_DATE 
											 , A.OFF_TIME_TERM 
									FROM   SCM_OFF_CALENDAR_LINE_M   A WITH(NOLOCK) 
										 , FP_AMEND_PLAN_POST_UTIL_R  B WITH(NOLOCK) 
									WHERE  1=1 
									AND    B.INSTANCE_ID    = @v_master_id
									AND    B.FP_PLAN_ID     = @v_plan_id
									AND    A.COMPANY_ID     = B.COMPANY_ID 
									AND    A.DIVISION_ID    = B.DIVISION_ID 
									AND    A.SITE_ID        = B.SITE_ID 
									AND    A.PLANT_ID       = B.PLANT_ID 
									AND    A.FACTORY_ID     = B.FACTORY_ID 
									AND    A.LINE_ID        = B.LINE_ID 
									AND    A.OPERATION_ID   = B.OPERATION_ID 
									AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE 
									AND    A.OFF_DATE       = B.PLAN_DATE 
									AND    A.OFF_TIME_TERM  > 0 
									EXCEPT 
									SELECT A.INSTANCE_ID, A.FP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID 
											 , A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE 
											 , A.PLAN_DATE, A.OFF_TIME 
									FROM    FP_AMEND_PLAN_POST_UTIL_R  A WITH(NOLOCK) 
									WHERE  A.INSTANCE_ID    = @v_master_id
									AND    A.FP_PLAN_ID     = @v_plan_id
									AND    A.OFF_TIME       > 0 
				       			) A 
						WHERE  NOT EXISTS ( 
														SELECT 1 
														FROM   TH_BUF_AMEND_PSI_UTIL_LINE_CHECK X 
														WHERE  X.INSTANCE_ID    = A.INSTANCE_ID 
														AND    X.FP_PLAN_ID     = A.FP_PLAN_ID 
														AND    X.COMPANY_ID     = A.COMPANY_ID 
														AND    X.DIVISION_ID    = A.DIVISION_ID 
														AND    X.SITE_ID        = A.SITE_ID 
														AND    X.PLANT_ID       = A.PLANT_ID 
														AND    X.FACTORY_ID     = A.FACTORY_ID 
														AND    X.OPERATION_ID   = A.OPERATION_ID 
														AND    X.LINE_ID        = A.LINE_ID 
														AND    X.ELECTRODE_TYPE = A.ELECTRODE_TYPE 
													  ) 

						INSERT INTO TH_BUF_AMEND_PSI_UTIL_LINE_CHECK
						(
							INSTANCE_ID, FP_PLAN_ID
							, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID
							, FACTORY_ID, LINE_ID, OPERATION_ID, ELECTRODE_TYPE
						)
						SELECT DISTINCT
								   INSTANCE_ID, FP_PLAN_ID
								 , COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID
								 , FACTORY_ID, LINE_ID, OPERATION_ID, ELECTRODE_TYPE
						FROM   (
										SELECT A.INSTANCE_ID, A.FP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID
												 , A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE
												 , A.PLAN_DATE, A.OFF_TIME
										FROM   FP_AMEND_PLAN_POST_UTIL_R A WITH(NOLOCK)
										WHERE  A.INSTANCE_ID    = @v_master_id
										AND    A.FP_PLAN_ID     =	@v_plan_id
										AND    A.OFF_TIME       > 0
										EXCEPT
										SELECT B.INSTANCE_ID, B.FP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID
												 , A.FACTORY_ID, A.OPERATION_ID , A.LINE_ID, A.ELECTRODE_TYPE
												 , A.OFF_DATE AS PLAN_DATE
												 , A.OFF_TIME_TERM
										FROM   SCM_OFF_CALENDAR_LINE_M   A WITH(NOLOCK)
											 , FP_AMEND_PLAN_POST_UTIL_R B WITH(NOLOCK)
										WHERE  1=1
										AND    B.INSTANCE_ID    = @v_master_id
										AND    B.FP_PLAN_ID     =	@v_plan_id
										AND    A.COMPANY_ID     = B.COMPANY_ID
										AND    A.DIVISION_ID    = B.DIVISION_ID
										AND    A.SITE_ID        = B.SITE_ID
										AND    A.PLANT_ID       = B.PLANT_ID
										AND    A.FACTORY_ID     = B.FACTORY_ID
										AND    A.LINE_ID        = B.LINE_ID
										AND    A.OPERATION_ID   = B.OPERATION_ID
										AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
										AND    A.OFF_DATE       = B.PLAN_DATE
										AND    A.OFF_TIME_TERM  > 0
							   ) A
						WHERE  NOT EXISTS (
														SELECT 1
														FROM   TH_BUF_AMEND_PSI_UTIL_LINE_CHECK X
														WHERE  X.INSTANCE_ID    = A.INSTANCE_ID
														AND    X.FP_PLAN_ID     = A.FP_PLAN_ID
														AND    X.COMPANY_ID     = A.COMPANY_ID
														AND    X.DIVISION_ID    = A.DIVISION_ID
														AND    X.SITE_ID        = A.SITE_ID
														AND    X.PLANT_ID       = A.PLANT_ID
														AND    X.FACTORY_ID     = A.FACTORY_ID
														AND    X.OPERATION_ID   = A.OPERATION_ID
														AND    X.LINE_ID        = A.LINE_ID
														AND    X.ELECTRODE_TYPE = A.ELECTRODE_TYPE
													  ) 
          
							--  END
          
							--  -- TABLE COUNT
							--  SELECT @n_count = COUNT(1)
							--  FROM   TH_BUF_AMEND_PSI_UTIL_LINE_CHECK
							--  WHERE  INSTANCE_ID  = @v_master_id
							--  AND    FP_PLAN_ID   = @v_plan_id
          
							--  SET @n_row_count = @n_count - @n_old_count
							--  SET @n_old_count = @n_count

							--  --LOG 생성
							--  SET @v_message   = 'OFF-TIME CHECK : ' + CONVERT(NVARCHAR, @n_row_count)
							--  SET @n_log_count = @n_log_count + 1
							--  SET @sysdate     = GETDATE()
							--  EXECUTE pr_log2_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
							--  -- 자기 자신 라인이 아닌 경우 삭제
							--  DELETE FROM A 
							--  FROM   TH_BUF_AMEND_PSI_UTIL_LINE_CHECK A
							--  WHERE  A.INSTANCE_ID  = @v_master_id
							--  AND    A.FP_PLAN_ID   = @v_plan_id
							--  AND    NOT EXISTS (
							--                      SELECT 1
							--                      FROM   TH_MST_INSTANCE_LINE X
							--                      WHERE  X.MASTER_ID        = A.INSTANCE_ID
							--                      AND    X.PLAN_ID          = A.FP_PLAN_ID
							--                      AND    X.COMPANY_ID       = A.COMPANY_ID
							--                      AND    X.DIVISION_ID      = A.DIVISION_ID
							--                      AND    X.SITE_ID          = A.SITE_ID
							--                      AND    X.PLANT_ID         = A.PLANT_ID
							--                      AND    X.FACTORY_ID       = A.FACTORY_ID
							--                      AND    X.LINE_ID          = A.LINE_ID
							--                      AND    X.OPERATION_ID     = A.OPERATION_ID
							--                      AND    X.ELECTRODE_TYPE   = A.ELECTRODE_TYPE
							--                    )
        
							--  SET @n_row_count = @n_old_count - @@ROWCOUNT

							--  --LOG 생성
							--  SET @v_message   = 'PLAN LINE : ' + CONVERT(NVARCHAR, @n_row_count)
							--  SET @n_log_count = @n_log_count + 1
							--  SET @sysdate     = GETDATE()
							--  EXECUTE pr_log2_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

				END	--4
        
			END	--3


      ---------------------------------------------------------------------------------------------
      -- FP_AMEND_PLAN_CELL/PACK_BOR_R 생성
      ---------------------------------------------------------------------------------------------
			BEGIN	--3

				DELETE FROM TH_BUF_AMEND_PSI_BOR_A
				DELETE FROM TH_BUF_AMEND_PSI_BOR_B
				DELETE FROM TH_BUF_AMEND_PSI_BOR_C WHERE INSTANCE_ID = @v_master_id AND FP_PLAN_ID = @v_plan_id 

				INSERT INTO TH_BUF_AMEND_PSI_BOR_A
					 (
					   COMPANY_ID
					 , DIVISION_ID
					 , SITE_ID
					 , PLANT_ID
					 , FACTORY_ID
					 , LOCATION
					 , OPERATION_ID
					 , LINE_ID
					 , ELECTRODE_TYPE
					 , CAPA_TYPE
					 , ITEM_ID
					 , CHECK_DATE
					 )
				SELECT DISTINCT
					   A.COMPANY_ID
					 , A.DIVISION_ID
					 , A.SITE_ID
					 , A.PLANT_ID
					 , A.FACTORY_ID
					 , A.LOCATION
					 , A.OPERATION_ID
					 , A.LINE_ID
					 , A.ELECTRODE_TYPE
					 , A.CAPA_TYPE
					 , A.ITEM_ID
					 , CASE WHEN CHECK_DATE < @v_start_date                 THEN @v_start_date
							WHEN CHECK_DATE > DATEADD(DAY, 1, @v_end_date)  THEN DATEADD(DAY, 1, @v_end_date)
							ELSE CHECK_DATE
					   END  AS CHECK_DATE
				FROM   (
						SELECT 
							   A.COMPANY_ID
							 , A.DIVISION_ID
							 , A.SITE_ID
							 , A.PLANT_ID
							 , A.FACTORY_ID
							 , A.LOCATION
							 , A.OPERATION_ID
							 , A.LINE_ID
							 , A.ELECTRODE_TYPE
							 , A.CAPA_TYPE
							 , A.ITEM_ID
							 , CASE WHEN R = 1 THEN CONVERT(DATE, MONTH + '01')
											   ELSE DATEADD(MONTH, 1, CONVERT(DATE, MONTH + '01'))
							   END  AS CHECK_DATE
						FROM   (
								SELECT 
									   A.COMPANY_ID
									 , A.DIVISION_ID
									 , A.SITE_ID
									 , A.PLANT_ID
									 , A.FACTORY_ID
									 , A.LOCATION
									 , A.OPERATION_ID
									 , A.LINE_ID
									 , A.ELECTRODE_TYPE
									 , D.CAPA_TYPE
									 , B.ITEM_ID
									 , B.MONTH
								FROM   SCM_LINE_M              A WITH(NOLOCK)
									 , SCM_ITEM_LINE_ASSIGN_M  B WITH(NOLOCK)
									 , FP_INSTANCE_FACTORY_M   C WITH(NOLOCK)
									 , SCM_OPERATION_M         D WITH(NOLOCK)
								WHERE  1=1
								AND    A.COMPANY_ID       = B.COMPANY_ID             
								AND    A.DIVISION_ID      = B.DIVISION_ID
								AND    A.SITE_ID          = B.SITE_ID
								AND    A.PLANT_ID         = B.PLANT_ID
								AND    A.FACTORY_ID       = B.FACTORY_ID
								AND    A.LINE_ID          = B.LINE_ID
								AND    A.OPERATION_ID     = B.OPERATION_ID
								AND    A.ELECTRODE_TYPE   = B.ELECTRODE_TYPE
								AND    A.ACTIVE_FLAG      = 'Y'
								AND    A.FACTORY_ID       = C.FACTORY_ID
								AND    C.INSTANCE_ID      = @v_master_id
								AND    B.ACTIVE_FLAG      = 'Y'
								AND    A.COMPANY_ID       = D.COMPANY_ID
								AND    A.DIVISION_ID      = D.DIVISION_ID
								AND    A.SITE_ID          = D.SITE_ID
								AND    A.OPERATION_ID     = D.OPERATION_ID
								AND    C.INSTANCE_TYPE    = D.INSTANCE_TYPE
								--AND    D.AMEND_MAIN_FLAG  = 'Y'
								AND    D.CAPA_TYPE        = ( CASE WHEN CHARINDEX('E_PMIX',C.INSTANCE_ID) > 0 THEN 'BATCH' ELSE 'TACT' END )
								AND    B.MONTH BETWEEN CONVERT(nvarchar(6), @v_start_date, 112) 
												   AND CONVERT(nvarchar(6), @v_end_date,   112)
							   ) A
							 , (
								SELECT 1 R UNION ALL
								SELECT 2 R 
							   ) B
						WHERE  1=1
						UNION  ALL
						SELECT 
							   A.COMPANY_ID
							 , A.DIVISION_ID
							 , A.SITE_ID
							 , A.PLANT_ID
							 , A.FACTORY_ID
							 , A.LOCATION
							 , A.OPERATION_ID
							 , A.LINE_ID
							 , A.ELECTRODE_TYPE
							 , A.CAPA_TYPE
							 , A.ITEM_ID
							 , CASE WHEN R = 1 THEN A.START_DATE
											   ELSE DATEADD(DAY, 1, A.END_DATE)
							   END  AS CHECK_DATE
						FROM   (
								SELECT 
									   A.COMPANY_ID
									 , A.DIVISION_ID
									 , A.SITE_ID
									 , A.PLANT_ID
									 , A.FACTORY_ID
									 , A.LOCATION
									 , A.OPERATION_ID
									 , A.LINE_ID
									 , A.ELECTRODE_TYPE
									 , D.CAPA_TYPE
									 , B.ITEM_ID
									 , CONVERT(DATE, B.START_TIME) AS START_DATE
									 , CONVERT(DATE, B.END_TIME  ) AS END_DATE
								FROM   SCM_LINE_M                      A WITH(NOLOCK)
									 , SCM_ITEM_LINE_ASSIGN_EXCEPT_M   B WITH(NOLOCK)
									 , FP_INSTANCE_FACTORY_M           C WITH(NOLOCK)
									 , SCM_OPERATION_M                 D WITH(NOLOCK)
								WHERE  1=1
								AND    A.COMPANY_ID       = B.COMPANY_ID             
								AND    A.DIVISION_ID      = B.DIVISION_ID
								AND    A.SITE_ID          = B.SITE_ID
								AND    A.PLANT_ID         = B.PLANT_ID
								AND    A.FACTORY_ID       = B.FACTORY_ID
								AND    A.LINE_ID          = B.LINE_ID
								AND    A.OPERATION_ID     = B.OPERATION_ID
								AND    A.ELECTRODE_TYPE   = B.ELECTRODE_TYPE
								AND    A.ACTIVE_FLAG      = 'Y'
								AND    A.FACTORY_ID       = C.FACTORY_ID
								AND    C.INSTANCE_ID      = @v_master_id
								AND    B.ACTIVE_FLAG      = 'Y'
								AND    A.COMPANY_ID       = D.COMPANY_ID
								AND    A.DIVISION_ID      = D.DIVISION_ID
								AND    A.SITE_ID          = D.SITE_ID
								AND    A.OPERATION_ID     = D.OPERATION_ID
								AND    C.INSTANCE_TYPE    = D.INSTANCE_TYPE
								--AND    D.AMEND_MAIN_FLAG  = 'Y'
								AND    D.CAPA_TYPE        = ( CASE WHEN CHARINDEX('E_PMIX',C.INSTANCE_ID) > 0 THEN 'BATCH' ELSE 'TACT' END )
								AND    B.START_TIME      <= @v_end_date
								AND    B.END_TIME        >= @v_start_date
							   ) A
							 , (
								SELECT 1 R UNION ALL
								SELECT 2 R 
						) B
						WHERE  1=1              
						UNION  ALL
						SELECT 
							   A.COMPANY_ID
							 , A.DIVISION_ID
							 , A.SITE_ID
							 , A.PLANT_ID
							 , A.FACTORY_ID
							 , A.LOCATION
			   , A.OPERATION_ID
							 , A.LINE_ID
							 , A.ELECTRODE_TYPE
							 , A.CAPA_TYPE
							 , A.ITEM_ID
							 , CASE WHEN R = 1 THEN A.START_DATE
											   ELSE DATEADD(DAY, 1, A.END_DATE)
							   END  AS CHECK_DATE
						FROM   (
								SELECT 
									   A.COMPANY_ID
									 , A.DIVISION_ID
									 , A.SITE_ID
									 , A.PLANT_ID
									 , A.FACTORY_ID
									 , A.LOCATION
									 , A.OPERATION_ID
									 , A.LINE_ID
									 , A.ELECTRODE_TYPE
									 , D.CAPA_TYPE
									 , B.ITEM_ID
									 , CONVERT(DATE, B.START_TIME) AS START_DATE
									 , CONVERT(DATE, B.END_TIME  ) AS END_DATE
								FROM   SCM_LINE_M              A WITH(NOLOCK)
									 , SCM_TACT_TIME_EXCEPT_M  B WITH(NOLOCK)
									 , FP_INSTANCE_FACTORY_M   C WITH(NOLOCK)
									 , SCM_OPERATION_M         D WITH(NOLOCK)
								WHERE  1=1
								AND    A.COMPANY_ID       = B.COMPANY_ID             
								AND    A.DIVISION_ID      = B.DIVISION_ID
								AND    A.SITE_ID          = B.SITE_ID
								AND    A.PLANT_ID         = B.PLANT_ID
								AND    A.FACTORY_ID       = B.FACTORY_ID
								AND    A.LINE_ID          = B.LINE_ID
								AND    A.OPERATION_ID     = B.OPERATION_ID
								AND    A.ELECTRODE_TYPE   = B.ELECTRODE_TYPE
								AND    A.ACTIVE_FLAG      = 'Y'
								AND    A.FACTORY_ID       = C.FACTORY_ID
								AND    C.INSTANCE_ID      = @v_master_id
								AND    B.ACTIVE_FLAG      = 'Y'
								AND    A.COMPANY_ID       = D.COMPANY_ID
								AND    A.DIVISION_ID      = D.DIVISION_ID
								AND    A.SITE_ID          = D.SITE_ID
								AND    A.OPERATION_ID     = D.OPERATION_ID
								AND    C.INSTANCE_TYPE    = D.INSTANCE_TYPE
								--AND    D.AMEND_MAIN_FLAG  = 'Y'
								AND    D.CAPA_TYPE        = ( CASE WHEN CHARINDEX('E_PMIX',C.INSTANCE_ID) > 0 THEN 'BATCH' ELSE 'TACT' END )
								AND    B.START_TIME      <= @v_end_date
								AND    B.END_TIME        >= @v_start_date
							   ) A
							 , (
								SELECT 1 R UNION ALL
								SELECT 2 R 
							   ) B
						WHERE  1=1              
						UNION  ALL
						SELECT 
							   A.COMPANY_ID
							 , A.DIVISION_ID
							 , A.SITE_ID
							 , A.PLANT_ID
							 , A.FACTORY_ID
							 , A.LOCATION
							 , A.OPERATION_ID
							 , A.LINE_ID
							 , A.ELECTRODE_TYPE
							 , A.CAPA_TYPE
							 , A.ITEM_ID
							 , CASE WHEN R = 1 THEN A.START_DATE
											   ELSE DATEADD(DAY, 1, A.END_DATE)
							   END  AS CHECK_DATE
						FROM   (
								SELECT 
									   A.COMPANY_ID
									 , A.DIVISION_ID
									 , A.SITE_ID
									 , A.PLANT_ID
									 , A.FACTORY_ID
									 , A.LOCATION
									 , A.OPERATION_ID
									 , A.LINE_ID
									 , A.ELECTRODE_TYPE
									 , D.CAPA_TYPE
									 , B.ITEM_ID
									 , CONVERT(DATE, B.START_TIME) AS START_DATE
									 , CONVERT(DATE, B.END_TIME  ) AS END_DATE
								FROM   SCM_LINE_M              A WITH(NOLOCK)
									 , SCM_YIELD_EXCEPT_M      B WITH(NOLOCK)
									 , FP_INSTANCE_FACTORY_M   C WITH(NOLOCK)
									 , SCM_OPERATION_M         D WITH(NOLOCK)
								WHERE  1=1
								AND    A.COMPANY_ID       = B.COMPANY_ID             
								AND    A.DIVISION_ID      = B.DIVISION_ID
								AND    A.SITE_ID          = B.SITE_ID
								AND    A.PLANT_ID         = B.PLANT_ID
								AND    A.FACTORY_ID       = B.FACTORY_ID
								AND    A.LINE_ID          = B.LINE_ID
								AND    A.OPERATION_ID     = B.OPERATION_ID
								--AND    A.ELECTRODE_TYPE   = B.ELECTRODE_TYPE
								AND    A.ACTIVE_FLAG      = 'Y'
								AND    A.FACTORY_ID       = C.FACTORY_ID
								AND    C.INSTANCE_ID      = @v_master_id
								AND    B.ACTIVE_FLAG      = 'Y'
								AND    A.COMPANY_ID       = D.COMPANY_ID
								AND    A.DIVISION_ID      = D.DIVISION_ID
								AND    A.SITE_ID          = D.SITE_ID
								AND    A.OPERATION_ID     = D.OPERATION_ID
								AND    C.INSTANCE_TYPE    = D.INSTANCE_TYPE
								--AND    D.AMEND_MAIN_FLAG  = 'Y'
								AND    D.CAPA_TYPE        = ( CASE WHEN CHARINDEX('E_PMIX',C.INSTANCE_ID) > 0 THEN 'BATCH' ELSE 'TACT' END )
								AND    B.START_TIME      <= @v_end_date
								AND    B.END_TIME        >= @v_start_date
							   ) A
							 , (
								SELECT 1 R UNION ALL
								SELECT 2 R 
							   ) B
						WHERE  1=1   
					   ) A
				WHERE  A.OPERATION_ID NOT IN ('A6000','E2500','S4000')
				AND    EXISTS (
								SELECT 1
								FROM   TH_BUF_AMEND_PSI_UTIL_LINE_CHECK X WITH(NOLOCK)
								WHERE  X.INSTANCE_ID    = @v_master_id
								AND    X.FP_PLAN_ID     = @v_plan_id
								AND    X.COMPANY_ID     = A.COMPANY_ID
								AND    X.DIVISION_ID    = A.DIVISION_ID
								AND    X.SITE_ID        = A.SITE_ID
								AND    X.PLANT_ID       = A.PLANT_ID
								AND    X.FACTORY_ID     = A.FACTORY_ID
								AND    X.LINE_ID        = A.LINE_ID
								AND    X.OPERATION_ID   = A.OPERATION_ID
								AND    X.ELECTRODE_TYPE = A.ELECTRODE_TYPE
							  )
        
				--LOG 생성
				SET @v_message = CONVERT(NVARCHAR, @@ROWCOUNT)
				SET @n_log_count += 1
				EXECUTE pr_log2_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_BUF_AMEND_PSI_BOR_A', 'INSERT', @n_log_count, null, @v_message, null

				INSERT INTO TH_BUF_AMEND_PSI_BOR_B
					 (
					   COMPANY_ID
					 , DIVISION_ID
					 , SITE_ID
					 , PLANT_ID
					 , FACTORY_ID
					 , LOCATION
					 , OPERATION_ID
					 , LINE_ID
					 , ELECTRODE_TYPE
					 , CAPA_TYPE
					 , ITEM_ID
					 , ITEM_UOM
					 , MONTH
					 , START_DATE
					 , END_DATE
					 )
				SELECT 
					   A.COMPANY_ID
					 , A.DIVISION_ID
					 , A.SITE_ID
					 , A.PLANT_ID
					 , A.FACTORY_ID
					 , A.LOCATION
					 , A.OPERATION_ID
					 , A.LINE_ID
					 , A.ELECTRODE_TYPE
					 , A.CAPA_TYPE
					 , A.ITEM_ID
					 , B.ITEM_UOM
					 , CONVERT(NVARCHAR(6), A.START_DATE, 112) AS MONTH
					 , A.START_DATE
					 , DATEADD(DAY, -1, A.END_DATE) AS END_DATE
				FROM   (
						SELECT
							   A.COMPANY_ID
							 , A.DIVISION_ID
							 , A.SITE_ID
							 , A.PLANT_ID
							 , A.FACTORY_ID
							 , A.LOCATION
							 , A.OPERATION_ID
							 , A.LINE_ID
							 , A.ELECTRODE_TYPE
							 , A.CAPA_TYPE
							 , A.ITEM_ID
							 , A.CHECK_DATE   AS START_DATE
							 , LEAD(A.CHECK_DATE, 1, NULL) OVER (PARTITION BY A.COMPANY_ID
																			, A.DIVISION_ID
																			, A.SITE_ID
																			, A.PLANT_ID
																			, A.FACTORY_ID
																			, A.LOCATION
																			, A.OPERATION_ID
																			, A.LINE_ID
																			, A.ELECTRODE_TYPE
																			, A.CAPA_TYPE
																			, A.ITEM_ID
																 ORDER     BY A.CHECK_DATE) AS END_DATE
						FROM   TH_BUF_AMEND_PSI_BOR_A AS A
					   ) A
					 , SCM_ITEM_M B WITH(NOLOCK)
				WHERE  A.START_DATE   < A.END_DATE
				AND    A.COMPANY_ID   = B.COMPANY_ID
				AND    A.DIVISION_ID  = B.DIVISION_ID
				AND    A.SITE_ID      = B.SITE_ID
				AND    A.ITEM_ID      = B.ITEM_ID

				--LOG 생성
				SET @v_message = CONVERT(NVARCHAR, @@ROWCOUNT)
				SET @n_log_count += 1
				EXECUTE pr_log2_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_BUF_AMEND_PSI_BOR_B', 'INSERT', @n_log_count, null, @v_message, null

				INSERT INTO TH_BUF_AMEND_PSI_BOR_C
					 (
					   INSTANCE_ID
					 , FP_PLAN_ID
					 , COMPANY_ID
					 , DIVISION_ID
					 , SITE_ID
					 , PLANT_ID
					 , FACTORY_ID
					 , LOCATION
					 , OPERATION_ID
					 , LINE_ID
					 , ELECTRODE_TYPE
					 , EQUIPMENT_ID
					 , CAPA_TYPE
					 , ITEM_ID
					 , ITEM_UOM
					 , MONTH
					 , START_DATE
					 , END_DATE
					 , PRIORITY
					 , TACT_TIME
					 , TACT_TIME_UOM
					 , YIELD
					 , UTILIZATION
					 )
				SELECT 
					   @v_master_id     AS INSTANCE_ID
					 , @v_plan_id       AS FP_PLAN_ID
					 , A.COMPANY_ID
					 , A.DIVISION_ID
					 , A.SITE_ID
					 , A.PLANT_ID
					 , A.FACTORY_ID
					 , A.LOCATION
					 , A.OPERATION_ID
					 , A.LINE_ID
					 , A.ELECTRODE_TYPE
					 , A.EQUIPMENT_ID
					 , A.CAPA_TYPE
					 , A.ITEM_ID
					 , A.ITEM_UOM
					 , A.MONTH
					 , A.START_DATE
					 , A.END_DATE
					 , MAX(A.PRIORITY)      AS PRIORITY
					 , MAX(A.TACT_TIME)     AS TACT_TIME
					 , MAX(A.TACT_TIME_UOM) AS TACT_TIME_UOM
					 , MAX(A.YIELD)         AS YIELD
					 , MAX(A.UTILIZATION)   AS UTILIZATION
				FROM   (
						SELECT DISTINCT
							   AA.COMPANY_ID
							 , AA.DIVISION_ID
							 , AA.SITE_ID
							 , AA.PLANT_ID
							 , AA.FACTORY_ID
							 , AA.LOCATION
							 , AA.OPERATION_ID
							 , AA.LINE_ID
							 , AA.ELECTRODE_TYPE
							 , CASE WHEN CHARINDEX('CELL', @v_master_id) > 0
									  OR CHARINDEX('PACK', @v_master_id) > 0  
										  THEN AA.LINE_ID + '_' + AA.OPERATION_ID
														  + ( CASE AA.ELECTRODE_TYPE  WHEN NULL   THEN '' 
																					  WHEN ''     THEN '' 
																					  WHEN '-'    THEN '' 
																								  ELSE '_' + AA.ELECTRODE_TYPE 
															  END )
										  ELSE DD.EQUIPMENT_ID
							   END  AS EQUIPMENT_ID
							 , AA.CAPA_TYPE
							 , AA.ITEM_ID
							 , AA.ITEM_UOM
							 , AA.MONTH
							 , AA.START_DATE
							 , AA.END_DATE
							 , AA.PRIORITY
							 , CASE WHEN @v_final_op_capa = 'DAILY_CAPA' AND AA.DAILY_CAPA_TACT IS NOT NULL THEN AA.DAILY_CAPA_TACT
																											ELSE AA.TACT_TIME
							   END  AS TACT_TIME
							 , CASE WHEN @v_final_op_capa = 'DAILY_CAPA' AND AA.DAILY_CAPA_TACT IS NOT NULL THEN 'SECOND'
																											ELSE AA.TACT_TIME_UOM
							   END  AS TACT_TIME_UOM
							 , AA.YIELD
							 , CASE WHEN @v_final_op_capa = 'DAILY_CAPA' AND AA.DAILY_CAPA_TACT IS NOT NULL THEN 1
																											ELSE ISNULL(EE.UTILIZATION, 1)
							   END  AS UTILIZATION
						FROM   (
								SELECT A.*
									 , ISNULL(B2.LANE_QTY, B1.LANE_QTY)               AS LANE_QTY
									 , 1                                              AS PATTERN_QTY
									 , ISNULL(B2.PRIORITY, B1.PRIORITY)               AS PRIORITY
									 , CASE WHEN ISNULL(C2.DAILY_CAPA, C1.DAILY_CAPA) IS NULL THEN NULL
											WHEN ISNULL(C2.DAILY_CAPA, C1.DAILY_CAPA) = 0     THEN 0
											ELSE (86400 * 1.0) / (ISNULL(C2.DAILY_CAPA, C1.DAILY_CAPA) * 1.0)
									   END  DAILY_CAPA_TACT
									 , ISNULL(ISNULL(C2.TACT_TIME, C1.TACT_TIME), 0)  AS TACT_TIME
									 , CASE WHEN C2.TACT_TIME IS NOT NULL THEN ISNULL(ISNULL(C2.TACT_TIME_UOM, C1.TACT_TIME_UOM), 'SECOND')
											ELSE ISNULL(C1.TACT_TIME_UOM, 'SECOND')
									   END  AS TACT_TIME_UOM
									 , CASE WHEN ISNULL(ISNULL(D2.YIELD, D1.YIELD), 1) <= 0 THEN 1
											WHEN ISNULL(ISNULL(D2.YIELD, D1.YIELD), 1) >= 1 THEN 1
											ELSE ISNULL(ISNULL(D2.YIELD, D1.YIELD), 1)
									END  AS YIELD
								FROM   TH_BUF_AMEND_PSI_BOR_B A
									   LEFT OUTER JOIN SCM_ITEM_LINE_ASSIGN_M        AS B1 WITH(NOLOCK)
											ON     A.COMPANY_ID     = B1.COMPANY_ID
											AND    A.DIVISION_ID    = B1.DIVISION_ID
											AND    A.SITE_ID        = B1.SITE_ID
											AND    A.PLANT_ID       = B1.PLANT_ID
											AND    A.FACTORY_ID     = B1.FACTORY_ID
											AND    A.OPERATION_ID   = B1.OPERATION_ID
											AND    A.LINE_ID        = B1.LINE_ID
											AND    A.ELECTRODE_TYPE = B1.ELECTRODE_TYPE
											AND    A.ITEM_ID        = B1.ITEM_ID
											AND    A.MONTH          = B1.MONTH
											AND    B1.ACTIVE_FLAG   = 'Y'
									   LEFT OUTER JOIN SCM_ITEM_LINE_ASSIGN_EXCEPT_M AS B2 WITH(NOLOCK)
											ON     A.COMPANY_ID     = B2.COMPANY_ID
											AND    A.DIVISION_ID    = B2.DIVISION_ID
											AND    A.SITE_ID        = B2.SITE_ID
											AND    A.PLANT_ID       = B2.PLANT_ID
											AND    A.FACTORY_ID     = B2.FACTORY_ID
											AND    A.OPERATION_ID   = B2.OPERATION_ID
											AND    A.LINE_ID        = B2.LINE_ID
											AND    A.ELECTRODE_TYPE = B2.ELECTRODE_TYPE
											AND    A.ITEM_ID        = B2.ITEM_ID
											AND    A.START_DATE    >= B2.START_TIME
											AND    A.END_DATE      <= B2.END_TIME
											AND    B2.ACTIVE_FLAG   = 'Y'
									   LEFT OUTER JOIN SCM_TACT_TIME_M               AS C1 WITH(NOLOCK)
											ON     A.COMPANY_ID     = C1.COMPANY_ID
											AND    A.DIVISION_ID    = C1.DIVISION_ID
											AND    A.SITE_ID        = C1.SITE_ID
											AND    A.PLANT_ID       = C1.PLANT_ID
											AND    A.FACTORY_ID     = C1.FACTORY_ID
											AND    A.OPERATION_ID   = C1.OPERATION_ID
											AND    A.LINE_ID        = C1.LINE_ID
											AND    A.ELECTRODE_TYPE = C1.ELECTRODE_TYPE
											AND    A.ITEM_ID        = C1.ITEM_ID
											AND    A.MONTH          = C1.MONTH
									   LEFT OUTER JOIN SCM_TACT_TIME_EXCEPT_M        AS C2 WITH(NOLOCK)
											ON     A.COMPANY_ID     = C2.COMPANY_ID
											AND    A.DIVISION_ID    = C2.DIVISION_ID
											AND    A.SITE_ID        = C2.SITE_ID
											AND    A.PLANT_ID       = C2.PLANT_ID
											AND    A.FACTORY_ID     = C2.FACTORY_ID
											AND    A.OPERATION_ID   = C2.OPERATION_ID
											AND    A.LINE_ID        = C2.LINE_ID
											AND    A.ELECTRODE_TYPE = C2.ELECTRODE_TYPE
											AND    A.ITEM_ID        = C2.ITEM_ID
											AND    A.START_DATE    >= C2.START_TIME
											AND    A.END_DATE      <= C2.END_TIME
											AND    C2.ACTIVE_FLAG   = 'Y'
									   LEFT OUTER JOIN SCM_YIELD_M                   AS D1 WITH(NOLOCK)
								  ON     A.COMPANY_ID     = D1.COMPANY_ID
											AND    A.DIVISION_ID    = D1.DIVISION_ID
											AND    A.SITE_ID        = D1.SITE_ID
											AND    A.PLANT_ID       = D1.PLANT_ID
											AND    A.FACTORY_ID     = D1.FACTORY_ID
											AND    A.OPERATION_ID   = D1.OPERATION_ID
											AND    A.LINE_ID        = D1.LINE_ID
											--AND    A.ELECTRODE_TYPE = D1.ELECTRODE_TYPE
											AND    A.ITEM_ID        = D1.ITEM_ID
											AND    A.MONTH          = D1.MONTH
									   LEFT OUTER JOIN SCM_YIELD_EXCEPT_M            AS D2 WITH(NOLOCK)
											ON     A.COMPANY_ID     = D2.COMPANY_ID
											AND    A.DIVISION_ID    = D2.DIVISION_ID
											AND    A.SITE_ID        = D2.SITE_ID
											AND    A.PLANT_ID       = D2.PLANT_ID
											AND    A.FACTORY_ID     = D2.FACTORY_ID
											AND    A.OPERATION_ID   = D2.OPERATION_ID
											AND    A.LINE_ID        = D2.LINE_ID
											--AND    A.ELECTRODE_TYPE = D2.ELECTRODE_TYPE
											AND    A.ITEM_ID        = D2.ITEM_ID
											AND    A.START_DATE    >= D2.START_TIME
											AND    A.END_DATE      <= D2.END_TIME
											AND    D2.ACTIVE_FLAG   = 'Y'
							   ) AA
								--- (20190731) LOSS TABLE 변경 : SCM_UTILIZATION_M -> SCM_LINE_LOSS_M
							   LEFT OUTER JOIN (
														SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LINE_ID, A.OPERATION_ID, A.ELECTRODE_TYPE, A.MONTH AS LOSS_MONTH, A.LOSS_RATE AS LOSS_RATE, 1 - ISNULL(LOSS_RATE, 0) AS UTILIZATION
														FROM		SCM_LINE_LOSS_M A WITH(NOLOCK)
														WHERE	1=1
														AND		A.MONTH				>= FORMAT(@v_start_date, 'yyyyMM')
													) EE
								   ON 1=1
								   AND   AA.COMPANY_ID		= EE.COMPANY_ID
								   AND   AA.DIVISION_ID			= EE.DIVISION_ID
								   AND   AA.SITE_ID				= EE.SITE_ID
								   AND   AA.PLANT_ID				= EE.PLANT_ID
								   AND   AA.OPERATION_ID		= EE.OPERATION_ID
								   AND   AA.FACTORY_ID			= EE.FACTORY_ID
								   AND   AA.LINE_ID				= EE.LINE_ID
								   AND   AA.ELECTRODE_TYPE	= EE.ELECTRODE_TYPE
							 , SCM_ITEM_M        BB WITH(NOLOCK)
							 , SCM_EQUIPMENT_M   DD WITH(NOLOCK)
					  			--- LOSS UI & TABLE 변경으로 주석처리 (20190731) 
								/**
									 LEFT OUTER JOIN (
												SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LINE_ID, A.EQUIPMENT_ID, A.OPERATION_ID, A.ELECTRODE_TYPE, A.BASIS_MONTH, LOSS_MONTH, LOSS_RATE, 1 - ISNULL(LOSS_RATE, 0) AS UTILIZATION,
													   RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LINE_ID, A.OPERATION_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID, A.LOSS_MONTH ORDER BY A.BASIS_MONTH desc) as RNK
												FROM   (
														SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, C.LINE_ID, A.OPERATION_ID, C.ELECTRODE_TYPE, A.EQUIPMENT_ID, A.BASIS_MONTH, A.LOSS_MONTH, SUM(A.LOSS_RATE) AS LOSS_RATE
														FROM   SCM_UTILIZATION_M     A WITH(NOLOCK)
															 , SCM_SYS_LOOKUP_VALUE  B WITH(NOLOCK)
															 , SCM_EQUIPMENT_M       C WITH(NOLOCK)
														WHERE  1=1
														AND    A.OFF_TYPE_ID = B.SEGMENT1
														AND    B.LOOKUP_TYPE_CODE = 'CAPACITY_LOSS_TYPE'
														AND    B.ACTIVE_FLAG  = 'Y'
														AND    B.ATTRIBUTE3   = 'Y'
									  AND    A.COMPANY_ID   = C.COMPANY_ID
														AND    A.DIVISION_ID  = C.DIVISION_ID
														AND    A.SITE_ID      = C.SITE_ID
														AND    A.PLANT_ID     = C.PLANT_ID
														AND    A.OPERATION_ID = C.OPERATION_ID
														AND    A.EQUIPMENT_ID = C.EQUIPMENT_ID
														AND    A.LOSS_MONTH   = CONVERT(nvarchar(6),GETDATE(), 112)
														GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, C.LINE_ID, A.OPERATION_ID, C.ELECTRODE_TYPE, A.EQUIPMENT_ID, A.BASIS_MONTH, LOSS_MONTH
													   ) A
												WHERE  1=1
											   ) EE
									ON    1=1  
									AND   DD.COMPANY_ID      = EE.COMPANY_ID
									AND   DD.DIVISION_ID     = EE.DIVISION_ID
									AND   DD.SITE_ID         = EE.SITE_ID
									AND   DD.PLANT_ID        = EE.PLANT_ID
									AND   DD.OPERATION_ID    = EE.OPERATION_ID
									AND   DD.FACTORY_ID      = EE.FACTORY_ID
									AND   DD.LINE_ID         = EE.LINE_ID
									AND   DD.ELECTRODE_TYPE  = EE.ELECTRODE_TYPE
									AND   DD.EQUIPMENT_ID    = EE.EQUIPMENT_ID
									AND   EE.RNK = 1
								*/
						WHERE  1=1
						AND    AA.COMPANY_ID      = BB.COMPANY_ID
						AND    AA.DIVISION_ID		= BB.DIVISION_ID
						AND    AA.SITE_ID				= BB.SITE_ID
						AND    AA.ITEM_ID				= BB.ITEM_ID
						AND    AA.COMPANY_ID      = DD.COMPANY_ID
						AND    AA.DIVISION_ID		= DD.DIVISION_ID
						AND    AA.SITE_ID				= DD.SITE_ID
						AND    AA.PLANT_ID			= DD.PLANT_ID
						AND    AA.OPERATION_ID    = DD.OPERATION_ID
						AND    AA.FACTORY_ID		= DD.FACTORY_ID
						AND    AA.LINE_ID				= DD.LINE_ID
						AND    AA.ELECTRODE_TYPE	= DD.ELECTRODE_TYPE
						AND    DD.EQUIPMENT_TYPE	= 'M'
						AND    DD.ACTIVE_FLAG		= 'Y'
					   ) A
				GROUP  BY
					   A.COMPANY_ID
					 , A.DIVISION_ID
					 , A.SITE_ID
					 , A.PLANT_ID
					 , A.FACTORY_ID
					 , A.LOCATION
					 , A.OPERATION_ID
					 , A.LINE_ID
					 , A.ELECTRODE_TYPE
					 , A.EQUIPMENT_ID
					 , A.CAPA_TYPE
					 , A.ITEM_ID
					 , A.ITEM_UOM
					 , A.MONTH
					 , A.START_DATE
					 , A.END_DATE
             
				--LOG 생성
				SET @v_message = CONVERT(NVARCHAR, @@ROWCOUNT)
				SET @n_log_count += 1
				EXECUTE pr_log2_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_BUF_AMEND_PSI_BOR_C', 'INSERT', @n_log_count, null, @v_message, null


				UPDATE A
				SET    A.CHILD_YIELD = A.MAX_YIELD
				FROM   (
						SELECT A.*
							 , MAX(YIELD_CAL) OVER (PARTITION BY
																  COMPANY_ID
																, DIVISION_ID
																, SITE_ID
											   , PLANT_ID
																, FACTORY_ID
																, LOCATION
																, OPERATION_ID
																, LINE_ID
								  , ELECTRODE_TYPE
																, ITEM_ID
																, START_DATE
																, END_DATE) MAX_YIELD
						FROM   (
								SELECT A.*
									 , CASE WHEN B.YIELD > 1 THEN 1 ELSE B.YIELD END YIELD_CAL
								FROM   (
										SELECT A.*
											 , B.CHILD_ITEM_ID
											 , C.FLOW_ID
										FROM   TH_BUF_AMEND_PSI_BOR_C A
											 , SCM_BOM_M             B WITH(NOLOCK)
											 , SCM_ITEM_M            C WITH(NOLOCK)
											 , SCM_ITEM_CLASS_M      D WITH(NOLOCK)
										WHERE  1=1
										AND    B.ACTIVE_FLAG  = 'Y'
										AND    B.EFF_END_DATE > GETDATE()
										AND   (B.ALT_PRIORITY IS NULL OR B.ALT_PRIORITY = 1)
										AND    A.DIVISION_ID  = B.DIVISION_ID
										AND    A.SITE_ID      = B.SITE_ID
										AND    A.PLANT_ID     = B.PLANT_ID
										AND    A.ITEM_ID      = B.PARENT_ITEM_ID             
										AND    B.CHILD_ITEM_ID = C.ITEM_ID
										AND    C.ITEM_CLASS    = D.CLASS_ID
										AND    D.USE_FLAG       = 'Y'
										AND    CHARINDEX(A.OPERATION_ID, C.FLOW_ID) > 0
									   ) A
									   INNER JOIN SCM_YIELD_M B WITH(NOLOCK)
											ON    A.CHILD_ITEM_ID = B.ITEM_ID
											AND   A.FACTORY_ID    = B.FACTORY_ID
											AND   A.LINE_ID       = B.LINE_ID
											AND   A.FLOW_ID       = B.OPERATION_ID
											AND   A.MONTH         = B.MONTH
											AND   B.YIELD         > 0
							   ) A            
					   ) A

				--LOG 생성
				SET @v_message = 'CHILD_YIELD : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
				SET @n_log_count += 1
				EXECUTE pr_log2_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_BUF_AMEND_PSI_BOR_C', 'UPDATE', @n_log_count, null, @v_message, null
      


        ----------------------------------------------------------------------------------------
				BEGIN	--4
        			
					SET @v_table_name = 'FP_AMEND_PLAN_POST_BOR_R'
					
					-- 기존 데이터  삭제
					DELETE FROM A 
					FROM   FP_AMEND_PLAN_POST_BOR_R  A
					WHERE  1=1
					AND    INSTANCE_ID = @v_master_id
					AND    FP_PLAN_ID  = @v_plan_id
					AND    EXISTS (
							                SELECT 1
							                FROM   TH_BUF_AMEND_PSI_BOR_A X
							                WHERE  X.COMPANY_ID     = A.COMPANY_ID
							                AND    X.DIVISION_ID    = A.DIVISION_ID
							                AND    X.SITE_ID        = A.SITE_ID
							                AND    X.PLANT_ID       = A.PLANT_ID
							                AND    X.FACTORY_ID     = A.FACTORY_ID
							                AND    X.LINE_ID        = A.LINE_ID
							                AND    X.OPERATION_ID   = A.OPERATION_ID
							                AND    X.ELECTRODE_TYPE = A.ELECTRODE_TYPE
					              		)

					--LOG 생성
					SET @v_message   = 'DELETE  : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
					SET @n_log_count = @n_log_count + 1
					EXECUTE pr_log2_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null
					
					-- 신규 데이터 생성
					INSERT INTO  FP_AMEND_PLAN_POST_BOR_R
					( 
						INSTANCE_ID, FP_PLAN_ID 
						, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LOCATION, OPERATION_ID 
						, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, CAPA_TYPE, ITEM_ID, ITEM_UOM 
						, MONTH, START_DATE, END_DATE, LANE_QTY, PATTERN_QTY 
						, PRIORITY, TACT_TIME, TACT_TIME_UOM, YIELD, CHILD_YIELD, UTILIZATION, CHILD_UTILIZATION 
						--, INSERT_ID, INSERT_TIME 
					) 
					SELECT 
						       INSTANCE_ID, FP_PLAN_ID 
						     , COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LOCATION, OPERATION_ID 
						     , LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, CAPA_TYPE, ITEM_ID, ITEM_UOM 
						     , MONTH, START_DATE, END_DATE, LANE_QTY, PATTERN_QTY 
						     , PRIORITY, TACT_TIME, TACT_TIME_UOM, YIELD, CHILD_YIELD, UTILIZATION, CHILD_UTILIZATION 
						     --, @v_proc_name, GETDATE() 
					FROM   TH_BUF_AMEND_PSI_BOR_C 
					WHERE  INSTANCE_ID = @v_master_id 
					AND    FP_PLAN_ID = @v_plan_id

					--LOG 생성
					SET @v_message   = 'INSERT  : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
					SET @n_log_count = @n_log_count + 1
					EXECUTE pr_log2_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

				END --4

			END --3
      
			---------------------------------------------------------------------------------------------
			-- FP_AMEND_PLAN_CELL/PACK_UTIL_R 생성
			---------------------------------------------------------------------------------------------
			BEGIN  --3
      
				SET @v_table_name = 'TH_BUF_AMEND_PSI_PLAN_AMEND'
      			
				DELETE FROM TH_BUF_AMEND_PSI_PLAN_AMEND
				--WHERE  INSTANCE_ID  = @v_master_id
				--AND    FP_PLAN_ID   = @v_plan_id

				INSERT INTO TH_BUF_AMEND_PSI_PLAN_AMEND 
				( 
					INSTANCE_ID, FP_PLAN_ID 
					, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID 
					, FACTORY_ID, LINE_ID, OPERATION_ID, ELECTRODE_TYPE 
					, EQUIPMENT_ID 
					, ITEM_ID, PLAN_DATE, DATE_SEQ, IN_QTY, OUT_QTY 
					, TOTAL_WORKING_TIME 
					, SETUP_TIME 
				) 
				SELECT 
							INSTANCE_ID, FP_PLAN_ID 
							, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID 
							, FACTORY_ID, LINE_ID, OPERATION_ID, ELECTRODE_TYPE 
							, LINE_ID + '_' + OPERATION_ID + ( CASE ELECTRODE_TYPE 	WHEN NULL 	THEN  	''
																										WHEN '-' 		THEN  	''
																										WHEN '' 			THEN  	''
																															ELSE 		'_'+ ELECTRODE_TYPE 
																		 END ) AS EQUIPMENT_ID 
							, ITEM_ID, PLAN_DATE, '1' AS DATE_SEQ, ADJUST_IN_QTY_M, ADJUST_OUT_QTY_M 
							, 0          AS TOTAL_WORKING_TIME 
							, 0          AS SETUP_TIME 
				FROM    FP_AMEND_PLAN_POST_R  A WITH(NOLOCK)
				WHERE  	A.INSTANCE_ID  = @v_master_id 
				AND    	A.FP_PLAN_ID   = @v_plan_id 
				AND    	A.ADJUST_OUT_QTY_M      > 0 
				AND    	CONVERT(NVARCHAR, A.PLAN_DATE, 112) >=  convert(nvarchar, @v_start_date, 112) 

				--LOG 생성
				SET @v_message   = 'INSERT :: '+ CONVERT(NVARCHAR, @@ROWCOUNT)
				SET @n_log_count = @n_log_count + 1
				SET @sysdate     = GETDATE()
				EXECUTE pr_log2_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

				-- AMEND 한 라인만 남겨두고 삭제한다.
				DELETE FROM A
				FROM   TH_BUF_AMEND_PSI_PLAN_AMEND A
				WHERE  INSTANCE_ID  = @v_master_id
				AND    FP_PLAN_ID   = @v_plan_id
				AND    NOT EXISTS (
												SELECT 1
												FROM   TH_BUF_AMEND_PSI_UTIL_LINE_CHECK X WITH(NOLOCK)
												WHERE  X.INSTANCE_ID    = A.INSTANCE_ID
												AND    X.FP_PLAN_ID     = A.FP_PLAN_ID
												AND    X.COMPANY_ID     = A.COMPANY_ID
												AND    X.DIVISION_ID    = A.DIVISION_ID
												AND    X.SITE_ID        = A.SITE_ID
												AND    X.PLANT_ID       = A.PLANT_ID
												AND    X.FACTORY_ID     = A.FACTORY_ID
												AND    X.LINE_ID        = A.LINE_ID
												AND    X.OPERATION_ID   = A.OPERATION_ID
												AND    X.ELECTRODE_TYPE = A.ELECTRODE_TYPE
								  			)
        
				--LOG 생성
				SET @v_message   = 'DELETE - '+ CONVERT(NVARCHAR, @@ROWCOUNT)
				SET @n_log_count = @n_log_count + 1
				SET @sysdate     = GETDATE()
				EXECUTE pr_log2_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

        
				UPDATE A
				--SET    A.TOTAL_WORKING_TIME = A.IN_QTY * B.TACT_TIME
				--자리수 넘쳐서 강제 조정 처리 : 앞에 10 자리
				SET    A.TOTAL_WORKING_TIME = CASE WHEN A.OUT_QTY * B.TACT_TIME > 10000000000.0 THEN 9999999999.0
																								ELSE A.OUT_QTY * B.TACT_TIME
											  END        
				FROM   TH_BUF_AMEND_PSI_PLAN_AMEND     A
					 	 , TH_BUF_AMEND_PSI_BOR_C   B
				WHERE  A.INSTANCE_ID    = @v_master_id
				AND    A.FP_PLAN_ID     = @v_plan_id
				AND    A.FACTORY_ID     = B.FACTORY_ID
				AND    A.OPERATION_ID   = B.OPERATION_ID
				AND    A.LINE_ID        = B.LINE_ID
				AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
				AND    A.EQUIPMENT_ID   = B.EQUIPMENT_ID
				AND    A.ITEM_ID        = B.ITEM_ID
				AND    A.PLAN_DATE      BETWEEN B.START_DATE AND B.END_DATE

				--LOG 생성
				SET @v_message = 'TOTAL_WORKING_TIME : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
				SET @n_log_count += 1
				EXECUTE pr_log2_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

				UPDATE A
				SET    A.SETUP_TIME = ISNULL(B.SETUP_TIME, 0) * 60
				FROM   (
								SELECT A.*
										 , LAG(SETUP_GROUP_ID) OVER(PARTITION BY A.FACTORY_ID
																			   , A.LINE_ID
																			   , A.OPERATION_ID
																			   , A.EQUIPMENT_ID
																	ORDER     BY A.PLAN_DATE
																			   , A.DATE_SEQ
																			   , A.ITEM_ID
																	) AS PREV_SETUP_GROUP_ID
								FROM   (
												SELECT A.*
													 , B.RESOURCE_SETUP_GROUP_ID
													 , C.SETUP_GROUP_ID
												FROM   TH_BUF_AMEND_PSI_PLAN_AMEND  A
													 , TH_MST_RESOURCE              B
													 , TH_MST_ITEM                  C
												WHERE  A.INSTANCE_ID    = @v_master_id
												AND    A.FP_PLAN_ID     = @v_plan_id
												AND    A.INSTANCE_ID    = B.MASTER_ID
												AND    A.FP_PLAN_ID     = B.PLAN_ID
												AND    A.FACTORY_ID     = B.SITE_ID
												--AND    A.LINE_ID        = B.ROUTE_ID
												--AND    A.OPERATION_ID   = B.OPERATION_ID
												AND    A.EQUIPMENT_ID   = B.RESOURCE_ID
												AND    1=1
												AND    A.INSTANCE_ID    = C.MASTER_ID
												AND    A.FP_PLAN_ID     = C.PLAN_ID
												AND    A.ITEM_ID        = C.ITEM_ID
												--AND    A.OPERATION_ID   = C.OPERATION_ID
												AND    A.OUT_QTY        > 0
							   				) A
					   			) A
							   LEFT OUTER JOIN TH_MST_SETUP_TIME B
									ON    A.INSTANCE_ID             = B.MASTER_ID
									AND   A.FP_PLAN_ID              = B.PLAN_ID
									AND   A.RESOURCE_SETUP_GROUP_ID = B.RESOURCE_SETUP_GROUP_ID
									AND   A.PREV_SETUP_GROUP_ID     = B.FROM_SETUP_ID
									AND   A.SETUP_GROUP_ID          = B.TO_SETUP_ID

				--LOG 생성
				SET @v_message = 'SETUP_TIME : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
				SET @n_log_count += 1
				EXECUTE pr_log2_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

				UPDATE A
				SET    A.SETUP_COLOR_CODE = ( CASE WHEN ISNULL(B.SETUP_TIME, 0) > 0 THEN 'SETUP'
																					ELSE '-'
											  END  )
				FROM   (
						SELECT A.*
							 , LEAD(SETUP_GROUP_ID) OVER( PARTITION BY A.FACTORY_ID
																	 , A.LINE_ID
																	 , A.OPERATION_ID
																	 , A.EQUIPMENT_ID
														  ORDER     BY A.PLAN_DATE
																	, A.DATE_SEQ
																	 , A.ITEM_ID
														  ) AS NEXT_SETUP_GROUP_ID
						FROM   (
								SELECT A.*
									 , B.RESOURCE_SETUP_GROUP_ID
									 , C.SETUP_GROUP_ID
								FROM   TH_BUF_AMEND_PSI_PLAN_AMEND  A
									 , TH_MST_RESOURCE              B
									 , TH_MST_ITEM                  C
								WHERE  A.INSTANCE_ID    = @v_master_id
								AND    A.FP_PLAN_ID     = @v_plan_id
								AND    A.INSTANCE_ID    = B.MASTER_ID
								AND    A.FP_PLAN_ID     = B.PLAN_ID
								AND    A.FACTORY_ID     = B.SITE_ID
								--AND    A.LINE_ID        = B.ROUTE_ID
								--AND    A.OPERATION_ID   = B.OPERATION_ID
								AND    A.EQUIPMENT_ID   = B.RESOURCE_ID
								AND    1=1
								AND    A.INSTANCE_ID    = C.MASTER_ID
								AND    A.FP_PLAN_ID     = C.PLAN_ID
								AND    A.ITEM_ID        = C.ITEM_ID
								--AND    A.OPERATION_ID   = C.OPERATION_ID
								AND    A.OUT_QTY        > 0
							   ) A
					   ) A
					   LEFT OUTER JOIN TH_MST_SETUP_TIME B
							ON    A.INSTANCE_ID             = B.MASTER_ID
							AND   A.FP_PLAN_ID              = B.PLAN_ID
							AND   A.RESOURCE_SETUP_GROUP_ID = B.RESOURCE_SETUP_GROUP_ID
							AND   A.SETUP_GROUP_ID          = B.FROM_SETUP_ID
							AND   A.NEXT_SETUP_GROUP_ID     = B.TO_SETUP_ID

				--LOG 생성
				SET @v_message = 'SETUP_COLOR_CODE : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
				SET @n_log_count += 1
				EXECUTE pr_log2_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        		
				SET @v_table_name = 'TH_BUF_AMEND_PSI_PLAN_UTIL'
				
				DELETE FROM TH_BUF_AMEND_PSI_PLAN_UTIL
				--WHERE  INSTANCE_ID = @v_master_id
				--AND    FP_PLAN_ID = @v_plan_id
        
				--LOG 생성
				SET @v_message = CONVERT(NVARCHAR, @@ROWCOUNT)
				SET @n_log_count += 1
				EXECUTE pr_log2_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

				INSERT INTO TH_BUF_AMEND_PSI_PLAN_UTIL
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
					 , EQUIPMENT_ID
					 , PLAN_DATE
					 , INSERT_ID
					 , INSERT_TIME
					 )
				SELECT A.INSTANCE_ID
					 , A.FP_PLAN_ID
					 , A.COMPANY_ID
					 , A.DIVISION_ID
					 , A.SITE_ID
					 , A.PLANT_ID
					 , A.FACTORY_ID
					 , A.OPERATION_ID
					 , A.LINE_ID
					 , A.ELECTRODE_TYPE
					 , A.EQUIPMENT_ID
					 , B.PLAN_DATE
					 , @v_proc_name       AS INSERT_ID
					 , GETDATE()          AS INSERT_TIME
				FROM   (
						SELECT A.INSTANCE_ID
							 , A.FP_PLAN_ID
							 , A.COMPANY_ID
					, A.DIVISION_ID
							 , A.SITE_ID
							 , A.PLANT_ID
							 , A.FACTORY_ID
							 , A.OPERATION_ID
							 , A.LINE_ID
							 , A.ELECTRODE_TYPE
							 , A.EQUIPMENT_ID
						FROM   TH_BUF_AMEND_PSI_PLAN_AMEND    A
						WHERE  A.INSTANCE_ID  = @v_master_id
						AND    A.FP_PLAN_ID   = @v_plan_id
						GROUP  BY
							   A.INSTANCE_ID
							 , A.FP_PLAN_ID
							 , A.COMPANY_ID
							 , A.DIVISION_ID
							 , A.SITE_ID
							 , A.PLANT_ID
							 , A.FACTORY_ID
							 , A.OPERATION_ID
							 , A.LINE_ID
							 , A.ELECTRODE_TYPE
							 , A.EQUIPMENT_ID
					   ) A
					 , (
						SELECT CONVERT(DATE, DATEADD(DAY, B.INT-1, PLAN_START_TIME)) AS PLAN_DATE
						FROM   SCM_FP_PLAN_H A WITH(NOLOCK)
							 , COPYT            B WITH(NOLOCK)
						WHERE  A.INSTANCE_ID  = @v_master_id
						AND    A.PLAN_ID      = @v_plan_id
						AND    A.PLAN_HORIZON > B.INT - 1
					   ) B
				WHERE  1=1       
				ORDER  BY
					   A.INSTANCE_ID
					 , A.FP_PLAN_ID
					 , A.COMPANY_ID
					 , A.DIVISION_ID
					 , A.SITE_ID
					 , A.PLANT_ID
					 , A.FACTORY_ID
					 , A.OPERATION_ID
					 , A.LINE_ID
					 , A.ELECTRODE_TYPE
					 , A.EQUIPMENT_ID
					 , B.PLAN_DATE
      
				--LOG 생성
				SET @v_message = CONVERT(NVARCHAR, @@ROWCOUNT)
				SET @n_log_count += 1
				EXECUTE pr_log2_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null


				UPDATE A
				SET    A.RUN_TIME   = B.RUN_TIME
				FROM   TH_BUF_AMEND_PSI_PLAN_UTIL A
					 , (
						SELECT A.INSTANCE_ID
							 , A.FP_PLAN_ID
							 , A.COMPANY_ID
							 , A.DIVISION_ID
							 , A.SITE_ID
							 , A.PLANT_ID
							 , A.FACTORY_ID
							 , A.OPERATION_ID
							 , A.LINE_ID
							 , A.ELECTRODE_TYPE
							 , A.EQUIPMENT_ID
							 , A.PLAN_DATE
							 --자리수 넘쳐서 강제 조정 처리 : 앞에 10 자리
							 , CASE WHEN SUM(A.TOTAL_WORKING_TIME) > 10000000000.0  THEN 9999999999.0
																					ELSE SUM(A.TOTAL_WORKING_TIME)
							   END  AS RUN_TIME
						FROM   TH_BUF_AMEND_PSI_PLAN_AMEND A
						WHERE  A.INSTANCE_ID    = @v_master_id
						AND    A.FP_PLAN_ID     = @v_plan_id
						GROUP  BY
							   A.INSTANCE_ID
							 , A.FP_PLAN_ID
							 , A.COMPANY_ID
							 , A.DIVISION_ID
							 , A.SITE_ID
							 , A.PLANT_ID
							 , A.FACTORY_ID
							 , A.OPERATION_ID
							 , A.LINE_ID
							 , A.ELECTRODE_TYPE
							 , A.EQUIPMENT_ID
							 , A.PLAN_DATE
					   ) B
				WHERE  A.INSTANCE_ID    = @v_master_id
				AND    A.FP_PLAN_ID     = @v_plan_id
				AND    A.INSTANCE_ID    = B.INSTANCE_ID   
				AND    A.FP_PLAN_ID     = B.FP_PLAN_ID    
				AND    A.COMPANY_ID     = B.COMPANY_ID    
				AND    A.DIVISION_ID    = B.DIVISION_ID   
				AND    A.SITE_ID        = B.SITE_ID       
				AND    A.PLANT_ID       = B.PLANT_ID      
				AND    A.FACTORY_ID     = B.FACTORY_ID    
				AND    A.OPERATION_ID   = B.OPERATION_ID  
				AND    A.LINE_ID        = B.LINE_ID       
				AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
				AND    A.EQUIPMENT_ID   = B.EQUIPMENT_ID  
				AND    A.PLAN_DATE      = B.PLAN_DATE     
      
				--LOG 생성
				SET @v_message = 'RUN_TIME : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
				SET @n_log_count += 1
				EXECUTE pr_log2_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
      
		        ------------------------------------------------------------------------------------------------------
		        -- 2018.06.26 : CALENDAR 기준이 EQUIPMENT 에서 LINE 으로 변경됨
		        ------------------------------------------------------------------------------------------------------
				BEGIN   -- LINE 기준	--4
      
					UPDATE A
					SET    A.OFF_TIME = B.OFF_TIME
					FROM   TH_BUF_AMEND_PSI_PLAN_UTIL A
						, (
							SELECT RESOURCE_ID, PLAN_DATE
								, SUM(OFFTIME_TERM) / MAX(RES_COUNT) AS OFF_TIME
							FROM   (
									SELECT B.RESOURCE_ID
										, B.RES_COUNT
										, A.OFF_DATE AS PLAN_DATE
										, A.OFF_TIME_TERM * (CASE A.OFF_TIME_UOM WHEN 'DAY'    THEN 86400
																				WHEN 'HOUR'   THEN  3600
																				WHEN 'MINUTE' THEN    60
																				WHEN 'SECOND' THEN     1
																								ELSE    60    -- DEFAULT 는 MINUTE
															END )
											AS OFFTIME_TERM
									FROM   SCM_OFF_CALENDAR_LINE_M A WITH(NOLOCK)
										, (
											SELECT A.*
												, COUNT(1) OVER (PARTITION BY DIVISION_ID
																			, PLANT_ID
																			, FACTORY_ID
																			, LINE_ID
																			, OPERATION_ID
																			, ELECTRODE_TYPE
																			, RESOURCE_ID ) AS RES_COUNT 
											FROM   (
													SELECT DIVISION_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, ELECTRODE_TYPE, EQUIPMENT_ID
														, LINE_ID + '_' + OPERATION_ID
																		+ CASE ELECTRODE_TYPE WHEN NULL THEN ''
																								WHEN ''   THEN ''
																								WHEN '-'  THEN ''
																										ELSE '_'+ELECTRODE_TYPE
																			END
															AS RESOURCE_ID
													FROM   SCM_EQUIPMENT_M A WITH(NOLOCK)
													WHERE  EQUIPMENT_TYPE = 'M'
													AND    ACTIVE_FLAG = 'Y'
													) A
											) B
									WHERE  1=1
									AND    A.DIVISION_ID    = B.DIVISION_ID
									AND    A.PLANT_ID       = B.PLANT_ID
									AND    A.FACTORY_ID     = B.FACTORY_ID
									AND    A.OPERATION_ID   = B.OPERATION_ID
									AND    A.LINE_ID        = B.LINE_ID
									AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
									AND    A.OFF_DATE       BETWEEN @v_start_date AND DATEADD(DAY, 3, @v_end_date)
									AND    EXISTS (
													SELECT 1
													FROM   TH_BUF_AMEND_PSI_BOR_C X
													WHERE  X.COMPANY_ID   = A.COMPANY_ID
													AND    X.DIVISION_ID  = A.DIVISION_ID
													AND    X.SITE_ID      = A.SITE_ID
													AND    X.PLANT_ID     = A.PLANT_ID
													AND    X.FACTORY_ID   = A.FACTORY_ID
													AND    X.OPERATION_ID = A.OPERATION_ID
													AND    X.LINE_ID      = A.LINE_ID
												)
									) A
							GROUP  BY RESOURCE_ID, PLAN_DATE
							) B
					WHERE  A.INSTANCE_ID  = @v_master_id
					AND    A.FP_PLAN_ID   = @v_plan_id
					AND    A.EQUIPMENT_ID = B.RESOURCE_ID
					AND    A.PLAN_DATE    = B.PLAN_DATE

					--LOG 생성
					SET @v_message = 'OFF_TIME ( LINE ) : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
					SET @n_log_count += 1
					EXECUTE pr_log2_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

				END	--4

      
				UPDATE A
				SET    A.DAY_FIRST_SETUP_TIME     = B.DAY_FIRST_SETUP_TIME
					 , A.SETUP_TIME               = B.SETUP_TIME
					 , A.DAY_LAST_SETUP_TIME      = 0
					 , A.ORG_DAY_FIRST_SETUP_TIME = B.DAY_FIRST_SETUP_TIME
					 , A.ORG_SETUP_TIME           = B.SETUP_TIME
				FROM   TH_BUF_AMEND_PSI_PLAN_UTIL A
					 , (
						SELECT A.INSTANCE_ID
							 , A.FP_PLAN_ID
							 , A.COMPANY_ID
							 , A.DIVISION_ID
							 , A.SITE_ID
							 , A.PLANT_ID
							 , A.FACTORY_ID
							 , A.OPERATION_ID
							 , A.LINE_ID
							 , A.ELECTRODE_TYPE
							 , A.EQUIPMENT_ID
							 , A.PLAN_DATE
							 , SUM(A.NEW_DAY_FIRST_SETUP_TIME)  AS DAY_FIRST_SETUP_TIME
							 , SUM(A.NEW_SETUP_TIME)            AS SETUP_TIME
						FROM   (
								SELECT A.*
									 , CASE WHEN A.PLAN_DATE <> A.PREV_PLAN_DATE THEN ISNULL(A.SETUP_TIME, 0) ELSE 0
									   END  AS NEW_DAY_FIRST_SETUP_TIME
									 , CASE WHEN A.PLAN_DATE =  A.PREV_PLAN_DATE THEN ISNULL(A.SETUP_TIME, 0) ELSE 0
									   END  AS NEW_SETUP_TIME
								FROM   (
										SELECT A.INSTANCE_ID
											 , A.FP_PLAN_ID
											 , A.COMPANY_ID
											 , A.DIVISION_ID
											 , A.SITE_ID
											 , A.PLANT_ID
											 , A.FACTORY_ID
											 , A.OPERATION_ID
											 , A.LINE_ID
											 , A.ELECTRODE_TYPE
											 , A.EQUIPMENT_ID
											 , A.PLAN_DATE
											 , A.SETUP_TIME
											 , LAG(PLAN_DATE)  OVER(PARTITION BY A.FACTORY_ID
																			   , A.LINE_ID
							   , A.OPERATION_ID
																			   , A.EQUIPMENT_ID
																	ORDER     BY A.PLAN_DATE
																			   , A.DATE_SEQ
																			   , A.ITEM_ID
					   ) AS PREV_PLAN_DATE
										FROM   TH_BUF_AMEND_PSI_PLAN_AMEND    A
										WHERE  A.INSTANCE_ID  = @v_master_id
										AND    A.FP_PLAN_ID   = @v_plan_id
										AND    A.OUT_QTY      > 0
									   ) A
							   ) A
						GROUP  BY
							   A.INSTANCE_ID
							 , A.FP_PLAN_ID
							 , A.COMPANY_ID
							 , A.DIVISION_ID
							 , A.SITE_ID
							 , A.PLANT_ID
							 , A.FACTORY_ID
							 , A.OPERATION_ID
							 , A.LINE_ID
							 , A.ELECTRODE_TYPE
							 , A.EQUIPMENT_ID
							 , A.PLAN_DATE
					   ) B
				WHERE  A.INSTANCE_ID    = @v_master_id
				AND    A.FP_PLAN_ID     = @v_plan_id
				AND    A.INSTANCE_ID    = B.INSTANCE_ID   
				AND    A.FP_PLAN_ID     = B.FP_PLAN_ID    
				AND    A.COMPANY_ID     = B.COMPANY_ID    
				AND    A.DIVISION_ID    = B.DIVISION_ID   
				AND    A.SITE_ID        = B.SITE_ID       
				AND    A.PLANT_ID       = B.PLANT_ID      
				AND    A.FACTORY_ID     = B.FACTORY_ID    
				AND    A.OPERATION_ID   = B.OPERATION_ID  
				AND    A.LINE_ID        = B.LINE_ID       
				AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
				AND    A.EQUIPMENT_ID   = B.EQUIPMENT_ID  
				AND    A.PLAN_DATE      = B.PLAN_DATE
      
				--LOG 생성
				SET @v_message = 'SETUP_TIME : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
				SET @n_log_count += 1
				EXECUTE pr_log2_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

				UPDATE A
				SET    A.ORG_UTILIZATION  = ROUND(((A.RUN_TIME + A.OFF_TIME + A.ORG_DAY_FIRST_SETUP_TIME + A.ORG_SETUP_TIME) / 86400.0 * 100.0), 2)
					 , A.UTILIZATION      = ROUND(((A.RUN_TIME + A.OFF_TIME + A.DAY_FIRST_SETUP_TIME     + A.SETUP_TIME)     / 86400.0 * 100.0), 2)
				FROM   TH_BUF_AMEND_PSI_PLAN_UTIL A
				WHERE  A.INSTANCE_ID    = @v_master_id
				AND    A.FP_PLAN_ID     = @v_plan_id
      
				--LOG 생성
				SET @v_message = 'ORG_UTILIZATION : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
				SET @n_log_count += 1
				EXECUTE pr_log2_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

				UPDATE B
				SET    B.DAY_LAST_SETUP_TIME = B.DAY_LAST_SETUP_TIME
												 + CASE WHEN A.DAY_FIRST_SETUP_TIME < FLOOR(( 1.0 - B.UTILIZATION / 100.0 ) * 86400) THEN A.DAY_FIRST_SETUP_TIME
														ELSE FLOOR(( 1.0 - B.UTILIZATION / 100.0 ) * 86400)
												   END
				FROM   (
						SELECT A.*
							 , DATEADD(DAY, -1, PLAN_DATE) AS PREV_DATE
						FROM   TH_BUF_AMEND_PSI_PLAN_UTIL A
						WHERE  A.INSTANCE_ID          = @v_master_id
						AND    A.FP_PLAN_ID           = @v_plan_id
						AND    A.UTILIZATION          > 100
						AND    A.DAY_FIRST_SETUP_TIME > 0
					   ) A
					 , TH_BUF_AMEND_PSI_PLAN_UTIL B
				WHERE  A.INSTANCE_ID    = B.INSTANCE_ID   
				AND    A.FP_PLAN_ID     = B.FP_PLAN_ID    
				AND    A.COMPANY_ID    = B.COMPANY_ID    
				AND    A.DIVISION_ID    = B.DIVISION_ID   
				AND    A.SITE_ID        = B.SITE_ID       
				AND    A.PLANT_ID       = B.PLANT_ID      
				AND    A.FACTORY_ID     = B.FACTORY_ID    
				AND    A.OPERATION_ID   = B.OPERATION_ID  
				AND    A.LINE_ID        = B.LINE_ID       
				AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
				AND    A.EQUIPMENT_ID   = B.EQUIPMENT_ID  
				AND    A.PREV_DATE      = B.PLAN_DATE
				AND    B.UTILIZATION    < 100

				--LOG 생성
				SET @v_message = 'DAY_LAST_SETUP_TIME : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
				SET @n_log_count += 1
				EXECUTE pr_log2_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null


				UPDATE A
				SET    A.DAY_FIRST_SETUP_TIME = A.DAY_FIRST_SETUP_TIME
												 - CASE WHEN A.DAY_FIRST_SETUP_TIME < FLOOR(( 1.0 - B.UTILIZATION / 100.0 ) * 86400) THEN A.DAY_FIRST_SETUP_TIME
														ELSE FLOOR(( 1.0 - B.UTILIZATION / 100.0 ) * 86400)
												   END
				FROM (
						SELECT A.*
							 , DATEADD(DAY, -1, PLAN_DATE) AS PREV_DATE
						FROM   TH_BUF_AMEND_PSI_PLAN_UTIL A
						WHERE  A.INSTANCE_ID          = @v_master_id
						AND    A.FP_PLAN_ID           = @v_plan_id
						AND    A.UTILIZATION          > 100
						AND    A.DAY_FIRST_SETUP_TIME > 0
					   ) A
					 , TH_BUF_AMEND_PSI_PLAN_UTIL B
				WHERE  A.INSTANCE_ID    = B.INSTANCE_ID   
				AND    A.FP_PLAN_ID     = B.FP_PLAN_ID    
				AND    A.COMPANY_ID     = B.COMPANY_ID    
				AND    A.DIVISION_ID    = B.DIVISION_ID   
				AND    A.SITE_ID        = B.SITE_ID       
				AND    A.PLANT_ID       = B.PLANT_ID      
				AND    A.FACTORY_ID     = B.FACTORY_ID    
				AND    A.OPERATION_ID   = B.OPERATION_ID  
				AND    A.LINE_ID        = B.LINE_ID       
				AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
				AND    A.EQUIPMENT_ID   = B.EQUIPMENT_ID  
				AND    A.PREV_DATE      = B.PLAN_DATE
				AND    B.UTILIZATION    < 100

				--LOG 생성
				SET @v_message = 'DAY_FIRST_SETUP_TIME : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
				SET @n_log_count += 1
				EXECUTE pr_log2_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

				UPDATE A
				SET    A.UTILIZATION = ROUND(((A.RUN_TIME + A.OFF_TIME + A.DAY_FIRST_SETUP_TIME 
																	   + A.SETUP_TIME
																	   + A.DAY_LAST_SETUP_TIME 
																	   ) / 86400.0 * 100.0), 2)
				FROM   TH_BUF_AMEND_PSI_PLAN_UTIL A
				WHERE  A.INSTANCE_ID    = @v_master_id
				AND    A.FP_PLAN_ID     = @v_plan_id
      
				UPDATE A
				SET    A.ORG_UTILIZATION          = A.UTILIZATION
					 , A.ORG_DAY_FIRST_SETUP_TIME = A.DAY_FIRST_SETUP_TIME
					 , A.ORG_SETUP_TIME           = A.SETUP_TIME
					 , A.ORG_DAY_LAST_SETUP_TIME  = A.DAY_LAST_SETUP_TIME
				FROM   TH_BUF_AMEND_PSI_PLAN_UTIL A
				WHERE  A.INSTANCE_ID    = @v_master_id
				AND    A.FP_PLAN_ID     = @v_plan_id

				--LOG 생성
				SET @v_message = 'UTILIZATION : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
				SET @n_log_count += 1
				EXECUTE pr_log2_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null


				BEGIN	--4
        
					DECLARE C_UTIL_ADJ CURSOR FOR
						SELECT 	A.FACTORY_ID
									, A.OPERATION_ID
									, A.LINE_ID
									, A.ELECTRODE_TYPE
									, A.EQUIPMENT_ID
									, A.PLAN_DATE
									, A.DAY_FIRST_SETUP_TIME
						FROM   TH_BUF_AMEND_PSI_PLAN_UTIL A
						WHERE  A.INSTANCE_ID          = @v_master_id
						AND    A.FP_PLAN_ID           = @v_plan_id
						AND    A.UTILIZATION          > 100
						AND    A.DAY_FIRST_SETUP_TIME > 0
						ORDER  BY EQUIPMENT_ID, PLAN_DATE

					DECLARE               -- 커서로 받을 변수
						  @c_factory_id           nvarchar(30)
						, @c_operation_id         nvarchar(30)
						, @c_line_id              nvarchar(30)
						, @c_electrode_type       nvarchar(30)
						, @c_equipment_id         nvarchar(30)
						, @c_plan_date            datetime
						, @c_day_first_setup_time numeric(20,10)
						--
						, @c_new_plan_date        datetime
						, @c_new_check_date       int
						, @c_new_utilization      numeric(20,10)
						, @c_new_setup_time       numeric(20,10)

					OPEN C_UTIL_ADJ
          
						WHILE 1 = 1
						BEGIN  --6
            
							FETCH C_UTIL_ADJ
							INTO  @c_factory_id
								, @c_operation_id
								, @c_line_id
								, @c_electrode_type
								, @c_equipment_id
								, @c_plan_date
								, @c_day_first_setup_time
        
							IF @@FETCH_STATUS <> 0          -- FETCH 레코드 없으면 LOOP 탈출
								BREAK
              
							SET @c_new_plan_date = @c_plan_date
            
							WHILE 1=1
							BEGIN	--7
            
								SET @c_new_plan_date = DATEADD(DAY, -1, @c_new_plan_date)

								SELECT @c_new_check_date = COUNT(1)
								FROM   TH_BUF_AMEND_PSI_PLAN_UTIL A
								WHERE  A.INSTANCE_ID    = @v_master_id
								AND    A.FP_PLAN_ID     = @v_plan_id
								AND    A.FACTORY_ID     = @c_factory_id
								AND    A.OPERATION_ID   = @c_operation_id
								AND    A.LINE_ID        = @c_line_id
								AND    A.ELECTRODE_TYPE = @c_electrode_type
								AND    A.EQUIPMENT_ID   = @c_equipment_id
								AND    A.PLAN_DATE      = @c_new_plan_date
								AND    A.RUN_TIME       = 0
								AND   (A.OFF_TIME
													+ A.DAY_LAST_SETUP_TIME ) >= 86400
                      
              
								IF @c_new_check_date = 0  -- 배분 가능
								BEGIN	--8

									SET @c_new_utilization = 100.0    -- 빈 쿼리 생성 방지
                
									SELECT @c_new_utilization = A.UTILIZATION
										 , @c_new_setup_time = ( CASE WHEN @c_day_first_setup_time < FLOOR(( 1.0 - A.UTILIZATION / 100.0 ) * 86400) THEN @c_day_first_setup_time
																	  ELSE FLOOR(( 1.0 - A.UTILIZATION / 100.0 ) * 86400)
																 END )              
									FROM   TH_BUF_AMEND_PSI_PLAN_UTIL A
									WHERE  A.INSTANCE_ID    = @v_master_id
									AND    A.FP_PLAN_ID     = @v_plan_id
									AND    A.FACTORY_ID     = @c_factory_id
									AND    A.OPERATION_ID   = @c_operation_id
									AND    A.LINE_ID        = @c_line_id
									AND    A.ELECTRODE_TYPE = @c_electrode_type
									AND    A.EQUIPMENT_ID   = @c_equipment_id
									AND    A.PLAN_DATE      = @c_new_plan_date
									AND    A.UTILIZATION    < 100
                
									IF @c_new_utilization >= 100.0
									  BREAK;

									UPDATE A
									SET    A.DAY_LAST_SETUP_TIME = A.DAY_LAST_SETUP_TIME + @c_new_setup_time
									FROM   TH_BUF_AMEND_PSI_PLAN_UTIL A
									WHERE  A.INSTANCE_ID    = @v_master_id
									AND    A.FP_PLAN_ID     = @v_plan_id
									AND    A.FACTORY_ID     = @c_factory_id
          							AND    A.OPERATION_ID   = @c_operation_id
									AND    A.LINE_ID        = @c_line_id
									AND    A.ELECTRODE_TYPE = @c_electrode_type
									AND    A.EQUIPMENT_ID   = @c_equipment_id
									AND    A.PLAN_DATE      = @c_new_plan_date
                
									UPDATE A
									SET    A.DAY_FIRST_SETUP_TIME = A.DAY_FIRST_SETUP_TIME - @c_new_setup_time
									FROM   TH_BUF_AMEND_PSI_PLAN_UTIL A
									WHERE  A.INSTANCE_ID    = @v_master_id
									AND    A.FP_PLAN_ID     = @v_plan_id
									AND    A.FACTORY_ID     = @c_factory_id
									AND    A.OPERATION_ID   = @c_operation_id
									AND    A.LINE_ID        = @c_line_id
									AND    A.ELECTRODE_TYPE = @c_electrode_type
									AND    A.EQUIPMENT_ID   = @c_equipment_id
									AND    A.PLAN_DATE      = @c_plan_date

									SET @c_day_first_setup_time = @c_day_first_setup_time - @c_new_setup_time

								END --8

								IF @c_day_first_setup_time <= 0
									BREAK
            
							END--7

							UPDATE A
							SET    A.UTILIZATION = CASE WHEN A.OFF_TIME >= 86400.0 THEN 0
														ELSE ROUND((
																		( A.RUN_TIME  + A.DAY_FIRST_SETUP_TIME 
																					+ A.SETUP_TIME
																					+ A.DAY_LAST_SETUP_TIME  ) 
																	/ ( 86400.0     - A.OFF_TIME ) 
																	* 100.0
																	), 2)
													END
							FROM   TH_BUF_AMEND_PSI_PLAN_UTIL A
							WHERE  A.INSTANCE_ID    = @v_master_id
							AND    A.FP_PLAN_ID     = @v_plan_id

						END	--6
					CLOSE C_UTIL_ADJ
          
					DEALLOCATE C_UTIL_ADJ

					--LOG 생성
					SET @v_message = 'UTILIZATION : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
					SET @n_log_count += 1
					EXECUTE pr_log2_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'C_UTIL_ADJ', 'UPDATE', @n_log_count, null, @v_message, null

					UPDATE A
					SET    A.SETUP_TIME = B.DAY_FIRST_SETUP_TIME
					FROM   (
							SELECT A.*
								, LAG(A.PLAN_DATE)  OVER(PARTITION BY A.FACTORY_ID
																	, A.LINE_ID
																	, A.OPERATION_ID
																	, A.EQUIPMENT_ID
														ORDER     BY A.PLAN_DATE
																	, A.DATE_SEQ
																	, A.ITEM_ID
														) AS PREV_PLAN_DATE 
							FROM   TH_BUF_AMEND_PSI_PLAN_AMEND A
							WHERE  A.INSTANCE_ID  = @v_master_id
							AND    A.FP_PLAN_ID   = @v_plan_id
							AND    A.OUT_QTY      > 0
							) A
						, TH_BUF_AMEND_PSI_PLAN_UTIL B
					WHERE  A.PLAN_DATE     <> A.PREV_PLAN_DATE
					AND    A.INSTANCE_ID    = B.INSTANCE_ID
					AND    A.FP_PLAN_ID     = B.FP_PLAN_ID
					AND    A.COMPANY_ID     = B.COMPANY_ID    
					AND    A.DIVISION_ID    = B.DIVISION_ID   
					AND    A.SITE_ID        = B.SITE_ID       
					AND    A.PLANT_ID       = B.PLANT_ID      
					AND    A.FACTORY_ID     = B.FACTORY_ID    
					AND    A.OPERATION_ID   = B.OPERATION_ID  
					AND    A.LINE_ID        = B.LINE_ID       
					AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
					AND    A.EQUIPMENT_ID   = B.EQUIPMENT_ID  
					AND    A.PLAN_DATE      = B.PLAN_DATE
					AND    A.SETUP_TIME    <> B.DAY_FIRST_SETUP_TIME

					--LOG 생성
					SET @v_message = 'SETUP_TIME : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
					SET @n_log_count += 1
					EXECUTE pr_log2_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_BUF_AMEND_PSI_PLAN_UTIL', 'UPDATE', @n_log_count, null, @v_message, null

					UPDATE A
					SET    A.LOCATION = ISNULL(B.LOCATION, '-')
					FROM   TH_BUF_AMEND_PSI_PLAN_UTIL  A
					, SCM_LINE_M                B
					WHERE  A.INSTANCE_ID    = @v_master_id
					AND    A.FP_PLAN_ID     = @v_plan_id
					AND    A.FACTORY_ID     = B.FACTORY_ID
					AND    A.LINE_ID        = B.LINE_ID
					AND    A.OPERATION_ID   = B.OPERATION_ID
					AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
        
					--LOG 생성
					SET @v_message = 'LOCATION : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
					SET @n_log_count += 1
					EXECUTE pr_log2_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_BUF_AMEND_PSI_PLAN_UTIL', 'UPDATE', @n_log_count, null, @v_message, null

				END	--4
				
				SET @v_table_name = 'FP_AMEND_PLAN_POST_UTIL_R'
				
				-- 기존 데이터  삭제
				DELETE FROM A
				FROM   FP_AMEND_PLAN_POST_UTIL_R  A
				WHERE  1=1
				AND    INSTANCE_ID = @v_master_id
				AND    FP_PLAN_ID  = @v_plan_id
				AND    EXISTS (
						                SELECT 1
						                FROM   TH_BUF_AMEND_PSI_UTIL_LINE_CHECK X
						                WHERE  X.INSTANCE_ID    = A.INSTANCE_ID
						                AND    X.FP_PLAN_ID     = A.FP_PLAN_ID
						                AND    X.COMPANY_ID     = A.COMPANY_ID
						                AND    X.DIVISION_ID    = A.DIVISION_ID
						                AND    X.SITE_ID        = A.SITE_ID
						                AND    X.PLANT_ID       = A.PLANT_ID
						                AND    X.FACTORY_ID     = A.FACTORY_ID
						                AND    X.LINE_ID        = A.LINE_ID
						                AND    X.OPERATION_ID   = A.OPERATION_ID
						                AND    X.ELECTRODE_TYPE = A.ELECTRODE_TYPE
					              )

				SET @v_message   = 'DELETE : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
				SET @n_log_count = @n_log_count + 1
				SET @sysdate     = GETDATE()
				EXECUTE pr_log2_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

				INSERT INTO FP_AMEND_PLAN_POST_UTIL_R
				(
					  INSTANCE_ID, FP_PLAN_ID
					, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID
					, FACTORY_ID, LOCATION, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID
					, PLAN_DATE, RUN_TIME
					, OFF_TIME
					, SETUP_TIME
					, UTILIZATION
					, INSERT_ID
					, INSERT_TIME
				)
				SELECT	A.INSTANCE_ID, A.FP_PLAN_ID
							, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID
							, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID
							, A.PLAN_DATE, A.RUN_TIME
							, MIN(OFF_TIME) AS OFF_TIME 
							, MIN(SETUP_TIME) AS SETUP_TIME 
							, MIN(UTILIZATION) AS UTILIZATION
							, @v_proc_name AS INSERT_ID
							, GETDATE() AS INSERT_TIME
				FROM		(
								SELECT A.INSTANCE_ID, A.FP_PLAN_ID
										, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID
										, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID
										, A.PLAN_DATE, A.RUN_TIME
										, ROUND(A.OFF_TIME / 60, 0)          AS OFF_TIME
										, ROUND(
										        (A.DAY_FIRST_SETUP_TIME
										           + A.SETUP_TIME
										           + A.DAY_LAST_SETUP_TIME )
										         / 60, 0)                    AS SETUP_TIME
										, A.UTILIZATION
								
								FROM   TH_BUF_AMEND_PSI_PLAN_UTIL A
								WHERE  A.INSTANCE_ID  = @v_master_id
								AND    A.FP_PLAN_ID   =	@v_plan_id
							) 	A 
        		WHERE	1=1
        		GROUP BY A.INSTANCE_ID, A.FP_PLAN_ID
							, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID
							, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID
							, A.PLAN_DATE, A.RUN_TIME
							
				SET @v_message   = 'INSERT : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
				SET @n_log_count = @n_log_count + 1
				SET @sysdate     = GETDATE()
				EXECUTE pr_log2_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

			END	--3
      
			BEGIN	--3
			
				-- INSTANCE 별로 구분할 경우를 대비하여,, CASE 문으로 설정..
				SET @v_table_name = 'FP_AMEND_PLAN_POST_R'
				
				UPDATE	A
				SET    	A.SETUP_COLOR_CODE = B.SETUP_COLOR_CODE
				FROM   	FP_AMEND_PLAN_POST_R  A
				    	  , TH_BUF_AMEND_PSI_PLAN_AMEND B
				WHERE  A.INSTANCE_ID    = @v_master_id
				AND    A.FP_PLAN_ID     = @v_plan_id
				AND    A.INSTANCE_ID    = B.INSTANCE_ID
				AND    A.FP_PLAN_ID     = B.FP_PLAN_ID
				AND    A.COMPANY_ID     = B.COMPANY_ID
				AND    A.DIVISION_ID    = B.DIVISION_ID
				AND    A.SITE_ID        = B.SITE_ID
				AND    A.PLANT_ID       = B.PLANT_ID
				AND    A.FACTORY_ID     = B.FACTORY_ID
				AND    A.LINE_ID        = B.LINE_ID
				AND    A.OPERATION_ID   = B.OPERATION_ID
				AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
				AND    A.ITEM_ID        = B.ITEM_ID
				AND    A.PLAN_DATE      = B.PLAN_DATE
				
				SET @v_message   = 'UPDATE : ' + CONVERT(NVARCHAR, @@ROWCOUNT)
				SET @n_log_count = @n_log_count + 1
				SET @sysdate     = GETDATE()
				EXECUTE pr_log2_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
			
			END	--3
	  			
		END	--2

	END TRY	--1

	BEGIN CATCH
		--ROLLBACK

		SET @v_descr = ERROR_MESSAGE()
		SET @sysdate = GETDATE()

		EXEC pr_log2_process @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_temp2, null, @v_descr
		EXEC PR_LOG2_RUNLOG  @logdate, @v_master_id, @v_plan_id, @v_proc_name, 'ERROR', null
		commit;
	END CATCH

	SET @n_log_count = @n_log_count + 1
	EXEC pr_log2_process @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null
	EXEC PR_LOG2_RUNLOG  @logdate, @v_master_id, @v_plan_id, @v_proc_name, 'END', null

END
