


/*
 * Program ID   : PR_UI_FP02842_PLAN_AMEND_ELEC_POST_SHIFT_EXCEL_ROW
 * Description  : Plan Amend Elec Post SHift 화면
 * Program History : FP00596 소스 참조
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022/03/08   LJS				Initial 
 */

CREATE
PROCEDURE [dbo].[PR_UI_FP02842_PLAN_AMEND_ELEC_POST_SHIFT_EXCEL_ROW]
  @p_sys_type                   NVARCHAR(MAX),
  @p_sys_flag                   NVARCHAR(MAX),
  @p_sys_gubun                  NVARCHAR(MAX),
  @p_user_id                    NVARCHAR(MAX),

  @p_instance_id                NVARCHAR(MAX),
  @p_company_id                 NVARCHAR(MAX),
  @p_division_id                NVARCHAR(MAX),
  @p_site_id                    NVARCHAR(MAX),
  @p_plant_id                   NVARCHAR(MAX),
  @p_factory_id                 NVARCHAR(MAX),
  @p_line_id                    NVARCHAR(MAX),
  @p_operation_id               NVARCHAR(MAX),
  @p_master_id                  NVARCHAR(MAX),
  @p_plan_date                  NVARCHAR(MAX),
  @p_plan_id                    NVARCHAR(MAX),
  @p_plan_type                  NVARCHAR(MAX),
  @p_prod_type                  NVARCHAR(MAX),
  @p_top_item_id                NVARCHAR(MAX),
  @p_item_id                    NVARCHAR(MAX),
  @p_nick_name                  NVARCHAR(MAX),
  @p_nick_name_lt               NVARCHAR(MAX),
  @p_uom		                NVARCHAR(MAX),
  @p_bucket_from                NVARCHAR(MAX),
  @p_bucket_to                  NVARCHAR(MAX),
  @p_day_info                   NVARCHAR(MAX),
  @p_week_info                  NVARCHAR(MAX),
  @p_month_info                 NVARCHAR(MAX),
  @p_cate_info                  NVARCHAR(MAX),
  @p_cate_value                 NVARCHAR(MAX),
  @p_cate_type                  NVARCHAR(MAX),

  @p_amend_table                NVARCHAR(100),
  @p_total_table                NVARCHAR(100)
  --,@p_amend_cutoff_boh_table     NVARCHAR(100),
  --@p_amend_bor_table            NVARCHAR(100),
  --@p_amend_boh_table            NVARCHAR(100),
  --@p_amend_sales_table          NVARCHAR(100),
  --@p_amend_util_table           NVARCHAR(100),
  --@p_amend_capa_table           NVARCHAR(100)

AS 
BEGIN  --MAIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
    SET NOCOUNT ON                                                                                                                                                                                                                                                   
	SET XACT_ABORT ON 

	DECLARE @v_sys_type                   NVARCHAR(MAX)  -- 값>> SELEC: SQL저장안함, SQL:SQL저장함
	DECLARE @v_sys_flag                   NVARCHAR(MAX)  -- 값>> I: Insert, M: Update, D: Delete, G: MERGE
	DECLARE @v_sys_gubun                  NVARCHAR(MAX) 
	DECLARE @v_user_id                    NVARCHAR(MAX)
    DECLARE @v_instance_id                NVARCHAR(MAX)
    DECLARE @v_company_id                 NVARCHAR(MAX)
    DECLARE @v_division_id                NVARCHAR(MAX)
    DECLARE @v_site_id                    NVARCHAR(MAX)
    DECLARE @v_plant_id                   NVARCHAR(MAX)
    DECLARE @v_factory_id                 NVARCHAR(MAX)
    DECLARE @v_line_id                    NVARCHAR(MAX)
    DECLARE @v_operation_id               NVARCHAR(MAX)
    DECLARE @v_master_id                  NVARCHAR(MAX)
    DECLARE @v_plan_date                  NVARCHAR(MAX)
    DECLARE @v_plan_id                    NVARCHAR(MAX)
	DECLARE @v_plan_type                  NVARCHAR(MAX)
    DECLARE @v_prod_type                  NVARCHAR(MAX)
	DECLARE @v_top_item_id                NVARCHAR(MAX)
    DECLARE @v_item_id                    NVARCHAR(MAX)
    DECLARE @v_nick_name                  NVARCHAR(MAX)
	DECLARE @v_uom                        NVARCHAR(MAX)
    DECLARE @v_bucket_from_date           NVARCHAR(MAX)
    DECLARE @v_bucket_to_date             NVARCHAR(MAX)
    DECLARE @v_day_info                   NVARCHAR(MAX)
    DECLARE @v_week_info                  NVARCHAR(MAX)
    DECLARE @v_month_info                 NVARCHAR(MAX)
    DECLARE @v_cate_info                  NVARCHAR(MAX)
	DECLARE @v_cate_value                 NVARCHAR(MAX)
    DECLARE @v_cate_type                  NVARCHAR(MAX)
    DECLARE @v_amend_table                NVARCHAR(100) = 'FP_PRODUCTION_PLAN_EQUIPMENT_EPOST_R'
	DECLARE @v_total_table                NVARCHAR(100) = 'FP_ELECTRODE_POST_PLAN_H'
    --DECLARE @v_amend_cutoff_boh_table     NVARCHAR(100) = 'FP_AMEND_CUTOFF_BOH_R'
    --DECLARE @v_amend_bor_table            NVARCHAR(100) = 'FP_AMEND_DAILY_BOR_R'
	--DECLARE @v_amend_boh_table            NVARCHAR(100) = 'FP_AMEND_DAILY_BOH_R'
    --DECLARE @v_amend_sales_table          NVARCHAR(100) = 'FP_AMEND_DAILY_SALES_R'
    --DECLARE @v_amend_util_table           NVARCHAR(100) = 'FP_AMEND_DAILY_UTIL_R'
	--DECLARE @v_amend_capa_table           NVARCHAR(100) = 'FP_AMEND_DAILY_CAPA_R'
	
	-- uom 별 컬럼
	DECLARE @v_uom_text				NVARCHAR(100)
	DECLARE @v_uom_col_out			NVARCHAR(100)
	DECLARE @v_uom_col_total		NVARCHAR(100)
	DECLARE @v_uom_col_remain		NVARCHAR(100)

	DECLARE @recv_active_flag       NVARCHAR(MAX)				    
	DECLARE @v_proc_name	        NVARCHAR(100) = 'PR_UI_FP02842_PLAN_AMEND_ELEC_POST_SHIFT_EXCEL_ROW'
	DECLARE @v_log_type             NVARCHAR(100) = ''
	DECLARE @v_log_message          NVARCHAR(MAX) = ''
	DECLARE @v_error_description    NVARCHAR(MAX) = ''
	DECLARE @v_delimiter            NVARCHAR(1)
	DECLARE @max_loop_cnt	        INTEGER = 0
	DECLARE @mst_loop_cnt	        INTEGER = 0
	DECLARE @v_seq_no   	        INTEGER = 0
	DECLARE @rtnCount   	        INTEGER = 0

	DECLARE @sysdate                DATETIME      = GETDATE()
	DECLARE @runstart               datetime
    DECLARE @runend                 datetime

	DECLARE @v_dSql                 NVARCHAR(MAX)=''
	DECLARE @v_dSql1                NVARCHAR(MAX)=''
	DECLARE @v_dSql2                NVARCHAR(MAX)=''
	DECLARE @v_dSql3                NVARCHAR(MAX)=''
	DECLARE @v_dSql4                NVARCHAR(MAX)=''
	DECLARE @v_dSql5                NVARCHAR(MAX)=''

    DECLARE @pSql                   NVARCHAR(MAX)=''

	DECLARE @v_tmp1                 NVARCHAR(MAX)=''
	DECLARE @v_tmp2                 NVARCHAR(MAX)=''
	DECLARE @v_tmp3                 NVARCHAR(MAX)=''


	SET @v_sys_type                 = ''
	SET @v_sys_flag                 = ''
	SET @v_sys_gubun                = ''
	SET @v_user_id                  = ''
    SET @v_instance_id              = ''
    SET @v_company_id               = ''
    SET @v_division_id              = ''
    SET @v_site_id                  = ''
    SET @v_plant_id                 = ''
    SET @v_factory_id               = ''
    SET @v_line_id                  = ''
    SET @v_operation_id             = ''
    SET @v_master_id                = ''
    SET @v_plan_date                = ''
    SET @v_plan_id                  = ''
    SET @v_plan_type                = ''
	SET @v_prod_type                = ''
	SET @v_top_item_id              = ''
    SET @v_item_id                  = ''
    SET @v_nick_name                = ''

    SET @v_bucket_from_date         = ''
    SET @v_bucket_to_date           = ''
    SET @v_day_info                 = ''
    SET @v_week_info                = ''
    SET @v_month_info               = ''
    SET @v_cate_info                = ''
    SET @v_cate_value               = ''
    SET @v_cate_type                = ''

	SET @recv_active_flag       = NULL	
	SET @recv_active_flag       = @p_sys_flag
	SET @v_delimiter            = '|'             -- 데이터 구분자
	SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_sys_flag, @v_delimiter) -- 프로시저 LOOP 길이를 판단  

	SET	@v_dSql                 = ''
	SET	@v_dSql1                = ''
	SET	@v_dSql2                = ''
	SET	@v_dSql3                = ''
	SET	@v_dSql4                = ''
	SET	@v_dSql5                = ''

	SET	@pSql                   = ''

    SET	@v_tmp1                 = ''
	SET	@v_tmp2                 = ''
	SET	@v_tmp3                 = ''

	SET @v_uom_text				= 'M(J/R)'
	SET @v_uom_col_out			= 'JR_OUT_QTY'
	SET @v_uom_col_total		= 'JR_TOTAL_QTY'
	SET @v_uom_col_remain		= 'JR_REMAIN_QTY'

	IF @p_uom = 'PC'
	BEGIN
		SET @v_uom_text			= 'M(P/C)'
		SET @v_uom_col_out		= 'PC_OUT_QTY'
		SET @v_uom_col_total	= 'PC_TOTAL_QTY'
		SET @v_uom_col_remain	= 'PC_REMAIN_QTY'
	
	END


	/************************************************************************************************/
	/* SELECT인경우 :SELECT(SELECT)                                                                      */
	/************************************************************************************************/
    IF(@p_sys_flag ='SELECT_MAIN')
        BEGIN --IF(START)
			
			SELECT @pSql = ''

			SELECT @v_dSql1 = ''
			SELECT @v_dSql1 += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql1 += '		 , A.LINE_ID, E.LINE_NAME, A.ELECTRODE_TYPE, A.EQUIPMENT_ID, A.ITEM_ID, D.NICK_NAME ' + char(10)

			IF(LEN(@p_day_info) > 0)
			BEGIN
					-- day
			        SELECT @v_tmp3 = ''
			        SELECT @max_loop_cnt = 0
			        SELECT @mst_loop_cnt = 0
			        SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			        
			        WHILE LEN(@p_day_info) > 0 AND @mst_loop_cnt < @max_loop_cnt
			        BEGIN
						SELECT @mst_loop_cnt = @mst_loop_cnt + 1
						SELECT @v_day_info = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)

						SELECT @v_tmp3 += '		 		 , SUM(CASE WHEN A.PLAN_DATE = ''' + @v_day_info + ''' AND A.SHIFT = ''1'' THEN A.JR_OUT_QTY ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_1 ' + char(10)
						SELECT @v_tmp3 += '		 		 , SUM(CASE WHEN A.PLAN_DATE = ''' + @v_day_info + ''' AND A.SHIFT = ''2'' THEN A.JR_OUT_QTY ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '_SHIFT_2 ' + char(10)

			        END 
			END

			SELECT @v_dSql1 = @v_dSql1 + @v_tmp1 + @v_tmp2 + @v_tmp3

			SELECT @v_dSql1 += '	FROM ( ' + char(10)
			SELECT @v_dSql1 += '		SELECT A.*, B.ISO_YYYYWW AS PLAN_WEEK, B.MONTH AS PLAN_MONTH ' + char(10)
			SELECT @v_dSql1 += '		FROM ( ' + char(10)
			SELECT @v_dSql1 += '			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += '				 , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '				 , CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE, A.SHIFT ' + char(10)
			SELECT @v_dSql1 += '				 , SUM(A.JR_OUT_QTY) AS JR_OUT_QTY, SUM(A.PC_OUT_QTY) AS PC_OUT_QTY ' + char(10)
			SELECT @v_dSql1 += '				 , 0 AS LOAD ' + char(10)
			SELECT @v_dSql1 += '			FROM   ' + @p_amend_table + ' A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '			WHERE  1=1 ' + char(10)
			SELECT @v_dSql1 += '			AND    A.INSTANCE_ID = ''' + @p_instance_id + ''' ' + char(10)
			SELECT @v_dSql1 += '			AND    A.FP_PLAN_ID  = ''' + @p_plan_id + ''' ' + char(10)
			SELECT @v_dSql1 += '			AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN ''' + @p_bucket_from + ''' AND ''' + @p_bucket_to + ''' ' + char(10)

			SELECT @v_dSql1 += '			'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
			SELECT @v_dSql1 += '			'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))    + char(10)
			SELECT @v_dSql1 += '			'+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))    + char(10)
			SELECT @v_dSql1 += ' 		    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			SELECT @v_dSql1 += ' 		    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
			SELECT @v_dSql1 += ' 		    '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
			
			IF (LEN(@p_item_id) > 0)
			BEGIN
                SELECT @v_dSql1 += ' 		    AND    A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%'' ' + char(10)
			END

			SELECT @v_dSql1 += '			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += '				   , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID, A.ITEM_ID' + char(10)
			SELECT @v_dSql1 += '				   , A.PLAN_DATE, A.SHIFT ' + char(10)
			SELECT @v_dSql1 += '		) A ' + char(10)
			SELECT @v_dSql1 += '		INNER JOIN TH_UIS_CAL B WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '		ON  A.PLAN_DATE = B.YYYYMMDD ' + char(10)
			SELECT @v_dSql1 += '		AND B.YYYYMMDD BETWEEN ''' + @p_bucket_from + ''' AND ''' + @p_bucket_to + ''' ' + char(10)
			SELECT @v_dSql1 += '	) A ' + char(10)
			SELECT @v_dSql1 += '	LEFT OUTER JOIN SCM_ITEM_M D WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '	ON    A.COMPANY_ID  = D.COMPANY_ID ' + char(10)
			SELECT @v_dSql1 += '	AND   A.DIVISION_ID = D.DIVISION_ID ' + char(10)
			SELECT @v_dSql1 += '	AND   A.SITE_ID     = D.SITE_ID ' + char(10)
			SELECT @v_dSql1 += '	AND   A.ITEM_ID     = D.ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '	INNER JOIN SCM_LINE_M E WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '	ON    A.COMPANY_ID     = E.COMPANY_ID ' + char(10)
			SELECT @v_dSql1 += '	AND   A.DIVISION_ID    = E.DIVISION_ID ' + char(10)
			SELECT @v_dSql1 += '	AND   A.SITE_ID        = E.SITE_ID ' + char(10)
			SELECT @v_dSql1 += '	AND   A.PLANT_ID       = E.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '	AND   A.FACTORY_ID     = E.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += '	AND   A.OPERATION_ID   = E.OPERATION_ID ' + char(10)
			SELECT @v_dSql1 += '	AND   A.LINE_ID        = E.LINE_ID ' + char(10)
			SELECT @v_dSql1 += '	AND   A.ELECTRODE_TYPE = E.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql1 += '	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql1 += '	       , A.LINE_ID, E.LINE_NAME, A.ELECTRODE_TYPE, A.EQUIPMENT_ID, A.ITEM_ID, D.NICK_NAME' + char(10)

			SELECT @v_dSql = '';
			SELECT @v_dSql = @v_dSql1 + @v_dSql2 + @v_dSql3;
	
		    IF @p_sys_type = 'SQL'
		  	BEGIN
		  	  	EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql, 'select',@runstart, @runend
		  	  	SELECT @v_dSql as [QUERY_VALUE]
		  	  
		  	END  
		    ELSE 
		  	BEGIN
				EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql, 'select',@runstart, @runend

		  	  	SET @runstart = GetDate()
		  	  	--쿼리실행
		  	  	EXEC sp_executesql @v_dSql
		  	  	  
		  	  	SET @runend = GetDate()

		  	END

        END	--IF( END )
	

	ELSE
		-- 트랜잭션 (TRAN)
		BEGIN TRY				                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
		BEGIN TRAN   

		BEGIN --ELSE ( BEGIN )
		    --max_loop_cnt:전체 Row수 , mst_loop_cnt:1씩 증가시켜서 전체 Row수 까지만 로직을 수행
			WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
			    BEGIN --WHILE 내(START)
					 
						SELECT @mst_loop_cnt = @mst_loop_cnt + 1	-- @mst_loop_cnt 1증가

						SELECT @v_sys_type            = [dbo].[SCM_ARR_SPL_VAL](@p_sys_type ,    @v_delimiter,  @mst_loop_cnt)
						, @v_sys_flag                 = [dbo].[SCM_ARR_SPL_VAL](@p_sys_flag ,    @v_delimiter,  @mst_loop_cnt)
						, @v_sys_gubun                = [dbo].[SCM_ARR_SPL_VAL](@p_sys_gubun ,   @v_delimiter,  @mst_loop_cnt)
						, @v_user_id                  = [dbo].[SCM_ARR_SPL_VAL](@p_user_id ,     @v_delimiter,  @mst_loop_cnt)
                        , @v_instance_id              = [dbo].[SCM_ARR_SPL_VAL](@p_instance_id , @v_delimiter,  @mst_loop_cnt)
                        , @v_company_id               = [dbo].[SCM_ARR_SPL_VAL](@p_company_id ,  @v_delimiter,  @mst_loop_cnt)
                        , @v_division_id              = [dbo].[SCM_ARR_SPL_VAL](@p_division_id , @v_delimiter,  @mst_loop_cnt)
                        , @v_site_id                  = [dbo].[SCM_ARR_SPL_VAL](@p_site_id ,     @v_delimiter,  @mst_loop_cnt)
                        , @v_plant_id                 = [dbo].[SCM_ARR_SPL_VAL](@p_plant_id ,    @v_delimiter,  @mst_loop_cnt)
                        , @v_operation_id             = [dbo].[SCM_ARR_SPL_VAL](@p_operation_id ,@v_delimiter,  @mst_loop_cnt)
                        , @v_line_id                  = [dbo].[SCM_ARR_SPL_VAL](@p_line_id ,     @v_delimiter,  @mst_loop_cnt)
                        , @v_plan_date                = [dbo].[SCM_ARR_SPL_VAL](@p_plan_date ,   @v_delimiter,  @mst_loop_cnt)
                        , @v_plan_id                  = [dbo].[SCM_ARR_SPL_VAL](@p_plan_id ,     @v_delimiter,  @mst_loop_cnt)
                        , @v_plan_type                = [dbo].[SCM_ARR_SPL_VAL](@p_plan_type ,   @v_delimiter,  @mst_loop_cnt)


					   /******************************************************************************/
					   /* EXECUTE  경우  :  EXEC_PAICALCUL                                       */
					   /******************************************************************************/
					   IF(@v_sys_flag ='EXEC_PAICALCUL')  
                           BEGIN
								EXEC  @rtnCount = [dbo].[PR_SCM_OF_INSTANCE_CALL_DAILY_AMEND_UI] @v_instance_id, @v_plan_id
								
								SELECT	'Result' = @rtnCount

                            END
					  
					IF @v_sys_type = 'SQL'
						BEGIN
							--EXEC PR_UI_SQL_LOG @v_proc_name,  @v_user_id,'','',@v_dSql,'select',@runstart, @runend
							SELECT @v_dSql as [QUERY_VALUE]

						END
					ELSE
						BEGIN
							SET @runstart = GetDate()
							--쿼리실행
							EXEC sp_executesql @v_dSql

							SET @runend = GetDate()
							EXEC PR_UI_SQL_LOG  @v_proc_name,  @v_user_id,@v_sys_flag,'', @v_dSql,'SELECT',@runstart, @runend
						END

			    END --WHILE 내(END)

		END --ELSE (END)
 		
        -- 트랜잭션 (COMMIT)
		COMMIT TRAN
		
		-- 수행결과 성공여부 RETURN
		IF @v_sys_type <> 'SQL'
		    SELECT 'SUCCESS' AS result_code,  @max_loop_cnt AS result_cnt	

		END TRY
		BEGIN CATCH                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
			ROLLBACK TRAN                                                                                                                                                                                                                                                 
			-- 에러나도 로그는 인서트                                                                                                                                                                                                                                              
			SET @v_log_message = ERROR_MESSAGE()
			EXEC PR_UI_SQL_LOG  @v_proc_name,  @v_user_id,'','',@v_log_message,'excute',@runstart, @runend
			SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  
		END CATCH    

END --MAIN END


