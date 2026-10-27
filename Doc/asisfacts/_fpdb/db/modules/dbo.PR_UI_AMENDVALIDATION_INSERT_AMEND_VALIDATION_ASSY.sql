CREATE PROCEDURE [dbo].[PR_UI_AMENDVALIDATION_INSERT_AMEND_VALIDATION_ASSY]
  @p_sys_type			nvarchar(MAX),  
  @p_sys_flag			nvarchar(MAX),
  @p_sys_gubun			nvarchar(MAX),  
  @p_user_id			nvarchar(MAX),
  @in_columns nvarchar(MAX),
  @in_row nvarchar(MAX),
  @opt_none nvarchar(5) = 'N'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_UI_AMENDVALIDATION_INSERT_AMEND_VALIDATION_ASSY                                                            **/
/** 프로그램 명   : Procedure PR_UI_AMENDVALIDATION_INSERT_AMEND_VALIDATION_ASSY                                                                          **/
/** 설 명         :                                                                           **/
/** Version       : 1.5.0(Auto)                                                                     **/
/**                                                                                           **/
/** Argument                                                                                  **/
/**                                                                                           **/
/** [검색 조건]                                                                              **/
/**                                                                                           **/
/** [Biz Logic]                                                                               **/
/**                                                                                           **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                                    **/
/**===========================================================================================**/
/** 2021-03-26     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_AMENDVALIDATION_INSERT_AMEND_VALIDATION_ASSY
*/

BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
  SET NOCOUNT ON; 
  SET XACT_ABORT ON;
  
  --DECLARE BASE PARAMETER START
  DECLARE @STRLEN nvarchar(max)
  DECLARE @runstart datetime
  DECLARE @runend datetime
  DECLARE @v_dSql nvarchar(max)
  DECLARE @v_Err nvarchar(max)
  DECLARE @v_Log nvarchar(max) 
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_AMENDVALIDATION_INSERT_AMEND_VALIDATION_ASSY'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_instance_id nvarchar(max) = ''
  DECLARE @p_fp_plan_id nvarchar(max) = ''
  DECLARE @p_company_id nvarchar(max) = ''
  DECLARE @p_division_id nvarchar(max) = ''
  DECLARE @p_site_id nvarchar(max) = ''
  DECLARE @p_plant_id nvarchar(max) = ''
  DECLARE @p_item_id nvarchar(max) = ''
  DECLARE @p_operation_id nvarchar(max) = ''
  DECLARE @p_factory_id nvarchar(max) = ''
  DECLARE @p_location nvarchar(max) = ''
  DECLARE @p_production_type nvarchar(max) = ''
  DECLARE @p_market nvarchar(max) = ''
  DECLARE @p_line_id nvarchar(max) = ''
  DECLARE @p_electrode_type nvarchar(max) = ''
  DECLARE @p_plan_date nvarchar(max) = ''
  DECLARE @p_top_item_id nvarchar(max) = ''
  DECLARE @p_item_type nvarchar(max) = ''
  DECLARE @p_cell_out_qty nvarchar(max) = ''
  DECLARE @p_qty nvarchar(max) = ''
  DECLARE @p_new_seq nvarchar(max) = ''
  DECLARE @p_job_order nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''


  DECLARE @v_instance_id nvarchar(max)
  DECLARE @v_fp_plan_id nvarchar(max)
  DECLARE @v_company_id nvarchar(max)
  DECLARE @v_division_id nvarchar(max)
  DECLARE @v_site_id nvarchar(max)
  DECLARE @v_plant_id nvarchar(max)
  DECLARE @v_item_id nvarchar(max)
  DECLARE @v_operation_id nvarchar(max)
  DECLARE @v_factory_id nvarchar(max)
  DECLARE @v_location nvarchar(max)
  DECLARE @v_production_type nvarchar(max)
  DECLARE @v_market nvarchar(max)
  DECLARE @v_line_id nvarchar(max)
  DECLARE @v_electrode_type nvarchar(max)
  DECLARE @v_plan_date nvarchar(max)
  DECLARE @v_top_item_id nvarchar(max)
  DECLARE @v_item_type nvarchar(max)
  DECLARE @v_cell_out_qty nvarchar(max)
  DECLARE @v_qty nvarchar(max)
  DECLARE @v_new_seq nvarchar(max)
  DECLARE @v_user_id nvarchar(max)
  DECLARE @v_job_order nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START

  --Optional Parameter Part END

  SET @v_delimiter            = '^'  -- 데이터 구분자
  SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@in_columns, @v_delimiter) -- 프로시저 LOOP 길이를 판단
  DECLARE @tmp_column nvarchar(MAX) = ''
  WHILE @mst_loop_cnt < @max_loop_cnt
  BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
	SET @mst_loop_cnt = @mst_loop_cnt + 1;	-- @mst_loop_cnt 1증가

	SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @in_columns			    ,@v_delimiter, @mst_loop_cnt);
	--IF @tmp_column = '_SAVE_AUTH' BEGIN
	--	SET @p__save_auth =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
     IF @tmp_column = 'INSTANCE_ID' BEGIN
      SET @p_instance_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'FP_PLAN_ID' BEGIN
      SET @p_fp_plan_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'COMPANY_ID' BEGIN
      SET @p_company_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
      SET @p_division_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'SITE_ID' BEGIN
      SET @p_site_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLANT_ID' BEGIN
      SET @p_plant_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ITEM_ID' BEGIN
      SET @p_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'OPERATION_ID' BEGIN
      SET @p_operation_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'FACTORY_ID' BEGIN
      SET @p_factory_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'LOCATION' BEGIN
      SET @p_location =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PRODUCTION_TYPE' BEGIN
      SET @p_production_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'MARKET' BEGIN
      SET @p_market =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'LINE_ID' BEGIN
      SET @p_line_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ELECTRODE_TYPE' BEGIN
      SET @p_electrode_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLAN_DATE' BEGIN
      SET @p_plan_date =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'TOP_ITEM_ID' BEGIN
      SET @p_top_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ITEM_TYPE' BEGIN
      SET @p_item_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'CELL_OUT_QTY' BEGIN
      SET @p_cell_out_qty =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QTY' BEGIN
      SET @p_qty =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'NEW_SEQ' BEGIN
      SET @p_new_seq =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'JOB_ORDER' BEGIN
      SET @p_job_order =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PARAM' BEGIN
      SET @p_param =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
      SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	--END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
	--	SET @p__non_auth =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END
  
  SET @v_instance_id ='''' + @p_instance_id + ''''
  SET @v_fp_plan_id ='''' + @p_fp_plan_id + ''''
  SET @v_company_id ='''' + @p_company_id + ''''
  SET @v_division_id ='''' + @p_division_id + ''''
  SET @v_site_id ='''' + @p_site_id + ''''
  SET @v_plant_id ='''' + @p_plant_id + ''''
  SET @v_item_id ='''' + @p_item_id + ''''
  SET @v_operation_id ='''' + @p_operation_id + ''''
  SET @v_factory_id ='''' + @p_factory_id + ''''
  SET @v_location ='''' + @p_location + ''''
  SET @v_production_type ='''' + @p_production_type + ''''
  SET @v_market ='''' + @p_market + ''''
  SET @v_line_id ='''' + @p_line_id + ''''
  SET @v_electrode_type ='''' + @p_electrode_type + ''''
  SET @v_plan_date ='''' + @p_plan_date + ''''
  SET @v_top_item_id ='''' + @p_top_item_id + ''''
  SET @v_item_type ='''' + @p_item_type + ''''
  SET @v_cell_out_qty ='''' + @p_cell_out_qty + ''''
  SET @v_qty ='''' + @p_qty + ''''
  SET @v_new_seq ='''' + @p_new_seq + ''''
  SET @v_user_id ='''' + @p_user_id + ''''
  SET @v_job_order ='''' + @p_job_order + ''''
  SET @v_param ='''' + @p_param + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''



  -- AmendValidation insert_Amend_Validation_ASSY  
  SET @v_dSql = ''
  SET @v_dSql += '      BEGIN'+char(10)
  SET @v_dSql += '        BEGIN TRAN'+char(10)
  SET @v_dSql += '          INSERT INTO BUF_AMEND_PLAN_CELL_R ('+char(10)
  SET @v_dSql += '             INSTANCE_ID, FP_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID'+char(10)
  SET @v_dSql += '            ,ITEM_ID, OPERATION_ID, FACTORY_ID'+char(10)
  SET @v_dSql += '            ,LOCATION, PRODUCTION_TYPE, MARKET'+char(10)
  SET @v_dSql += '            ,LINE_ID, ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '            ,CATEGORY_ID'+char(10)
  SET @v_dSql += '            ,PLAN_DATE'+char(10)
  SET @v_dSql += '            ,TOP_ITEM_ID, ITEM_TYPE'+char(10)
  SET @v_dSql += '            ,CELL_OUT_QTY'+char(10)
  SET @v_dSql += '            ,OUT_QTY'+char(10)
  SET @v_dSql += '            ,DATE_SEQ'+char(10)
  SET @v_dSql += '            ,JOB_SAVE_SEQ'+char(10)
  SET @v_dSql += '            ,JOB_USER_ID, JOB_TIME, JOB_TYPE, JOB_ORDER'+char(10)
  SET @v_dSql += '          )'+char(10)
  SET @v_dSql += '          VALUES ('+char(10)
  SET @v_dSql += '             UPPER(RTRIM(LTRIM('+char(10)
  SET @v_dSql += '' + @v_instance_id+''+char(10)
  SET @v_dSql += '))), UPPER(RTRIM(LTRIM('+char(10)
  SET @v_dSql += '' + @v_fp_plan_id+''+char(10)
  SET @v_dSql += '))), UPPER(RTRIM(LTRIM('+char(10)
  SET @v_dSql += '' + @v_company_id+''+char(10)
  SET @v_dSql += '))), UPPER(RTRIM(LTRIM('+char(10)
  SET @v_dSql += '' + @v_division_id+''+char(10)
  SET @v_dSql += '))), UPPER(RTRIM(LTRIM('+char(10)
  SET @v_dSql += '' + @v_site_id+''+char(10)
  SET @v_dSql += '))), UPPER(RTRIM(LTRIM('+char(10)
  SET @v_dSql += '' + @v_plant_id+''+char(10)
  SET @v_dSql += ')))'+char(10)
  SET @v_dSql += '            ,UPPER(RTRIM(LTRIM('+char(10)
  SET @v_dSql += '' + @v_item_id+''+char(10)
  SET @v_dSql += '))), UPPER(RTRIM(LTRIM('+char(10)
  SET @v_dSql += '' + @v_operation_id+''+char(10)
  SET @v_dSql += '))), UPPER(RTRIM(LTRIM('+char(10)
  SET @v_dSql += '' + @v_factory_id+''+char(10)
  SET @v_dSql += ')))'+char(10)
  SET @v_dSql += '            ,UPPER(RTRIM(LTRIM('+char(10)
  SET @v_dSql += '' + @v_location+''+char(10)
  SET @v_dSql += '))), UPPER(RTRIM(LTRIM('+char(10)
  SET @v_dSql += '' + @v_production_type+''+char(10)
  SET @v_dSql += '))), UPPER(RTRIM(LTRIM('+char(10)
  SET @v_dSql += '' + @v_market+''+char(10)
  SET @v_dSql += ')))'+char(10)
  SET @v_dSql += '            ,UPPER(RTRIM(LTRIM('+char(10)
  SET @v_dSql += '' + @v_line_id+''+char(10)
  SET @v_dSql += '))), UPPER(SUBSTRING(RTRIM(LTRIM('+char(10)
  SET @v_dSql += '' + @v_electrode_type+''+char(10)
  SET @v_dSql += ')),1,1)) + LOWER(SUBSTRING(RTRIM(LTRIM('+char(10)
  SET @v_dSql += '' + @v_electrode_type+''+char(10)
  SET @v_dSql += ')),2,99))'+char(10)
  SET @v_dSql += '            ,''PLAN'''+char(10)
  SET @v_dSql += '            ,CONVERT(DATE, RTRIM(LTRIM('+char(10)
  SET @v_dSql += '' + @v_plan_date+''+char(10)
  SET @v_dSql += ')))'+char(10)
  SET @v_dSql += '            ,UPPER(RTRIM(LTRIM('+char(10)
  SET @v_dSql += '' + @v_top_item_id+''+char(10)
  SET @v_dSql += '))), RTRIM(LTRIM('+char(10)
  SET @v_dSql += '' + @v_item_type+''+char(10)
  SET @v_dSql += '))'+char(10)
  SET @v_dSql += '            ,RTRIM(LTRIM('+char(10)
  SET @v_dSql += '' + @v_cell_out_qty+''+char(10)
  SET @v_dSql += '))'+char(10)
  SET @v_dSql += '            ,RTRIM(LTRIM('+char(10)
  SET @v_dSql += '' + @v_qty+''+char(10)
  SET @v_dSql += '))'+char(10)
  SET @v_dSql += '            ,RTRIM(CASE WHEN CONVERT(NUMERIC(25,10),ISNULL(RTRIM(LTRIM('+char(10)
  SET @v_dSql += '' + @v_qty+''+char(10)
  SET @v_dSql += ')),0)) = 0 THEN 0 ELSE 1 END)'+char(10)
  SET @v_dSql += '            ,'+char(10)
  SET @v_dSql += '' + @v_new_seq+''+char(10)
  SET @v_dSql += '            ,'+char(10)
  SET @v_dSql += '' + @v_user_id+''+char(10)
  SET @v_dSql += ', dbo.SYSDATE1(), ''-'','+char(10)
  SET @v_dSql += '' + @v_job_order+''+char(10)
  SET @v_dSql += '          )'+char(10)
  SET @v_dSql += '          ;'+char(10)
  SET @v_dSql += '        COMMIT;'+char(10)
  SET @v_dSql += '      END;'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("AmendValidation","insert_Amend_Validation_ASSY",param);
  --
  --}

  --'


  IF @p_sys_type = 'SQL'
  BEGIN
    -- return SQL Query Source
    select @v_dSql as [QUERY_VALUE]
  END ELSE BEGIN
    SET @runstart = GetDate()

    BEGIN TRY
      BEGIN TRAN
        -- run dynamic sql
        exec sp_executesql @v_dSql
      COMMIT TRAN
    END TRY
    BEGIN CATCH
      ROLLBACK
      SET @runend = GetDate()
      exec PR_UI_SQL_LOG 'PR_UI_AMENDVALIDATION_INSERT_AMEND_VALIDATION_ASSY',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_AMENDVALIDATION_INSERT_AMEND_VALIDATION_ASSY',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
