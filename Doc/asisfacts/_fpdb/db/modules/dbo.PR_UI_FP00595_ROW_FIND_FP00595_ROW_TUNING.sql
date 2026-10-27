


CREATE
PROCEDURE [dbo].[PR_UI_FP00595_ROW_FIND_FP00595_ROW_TUNING]
    @p_sys_type NVARCHAR(max),
    @p_sys_flag NVARCHAR(max),
    @p_sys_gubun NVARCHAR(max),
    @p_user_id NVARCHAR(max),
    @in_columns NVARCHAR(max),
    @in_row NVARCHAR(max),
    @opt_none NVARCHAR(5) = 'N'
WITH EXEC AS caller
AS

BEGIN
    SET TRANSACTION isolation level READ uncommitted;
    SET nocount ON;
    SET xact_abort ON;

    --DECLARE BASE PARAMETER START    
    DECLARE @strlen NVARCHAR(max)
    DECLARE @runstart DATETIME
    DECLARE @runend DATETIME
    DECLARE @v_dsql NVARCHAR(max)
    DECLARE @v_err NVARCHAR(max)
    DECLARE @v_log NVARCHAR(max)
    DECLARE @v_proc_name NVARCHAR(100) = OBJECT_NAME(@@PROCID)
    DECLARE @v_delimiter NVARCHAR(1)
    DECLARE @max_loop_cnt INTEGER = 0
    DECLARE @mst_loop_cnt INTEGER = 0
    DECLARE @p_bucket_from NVARCHAR(max) = ''
    DECLARE @p_bucket_to NVARCHAR(max) = ''
    DECLARE @p_day_info NVARCHAR(max) = ''
    DECLARE @p_site_id NVARCHAR(max) = ''
    DECLARE @p_top_item_id NVARCHAR(max) = ''
    DECLARE @p_item_id NVARCHAR(max) = ''
    DECLARE @p_prod_type NVARCHAR(max) = ''
    DECLARE @p_prodtype_lt NVARCHAR(max) = ''
    DECLARE @p_item_name NVARCHAR(max) = ''
    DECLARE @p_fp_site_id NVARCHAR(max) = ''
    DECLARE @p_master_id NVARCHAR(max) = ''
    DECLARE @p_cell_group NVARCHAR(max) = ''
    DECLARE @p_instance_id NVARCHAR(max) = ''
    DECLARE @p_bucket NVARCHAR(max) = ''
    DECLARE @p_week_info NVARCHAR(max) = ''
    DECLARE @p_month_info NVARCHAR(max) = ''
    DECLARE @p_division_lt NVARCHAR(max) = ''
    DECLARE @p_plant_lt NVARCHAR(max) = ''
    DECLARE @p_plan_type NVARCHAR(max) = ''
    DECLARE @p_plan_id NVARCHAR(max) = ''
    DECLARE @p_factory_lt NVARCHAR(max) = ''
    DECLARE @p_line_lt NVARCHAR(max) = ''
    DECLARE @p_curr_date_col NVARCHAR(max) = ''
    DECLARE @p_model_lt NVARCHAR(max) = ''
    DECLARE @p_operation_lt NVARCHAR(max) = ''
    DECLARE @p_nickname_lt NVARCHAR(max) = ''
    DECLARE @p_nickname NVARCHAR(max) = ''
    DECLARE @p_day2month NVARCHAR(max) = ''
    DECLARE @p_day2week NVARCHAR(max) = ''
    DECLARE @p_amend_table NVARCHAR(max) = ''
    DECLARE @p_amend_capa_table NVARCHAR(max) = ''
    DECLARE @p_amend_util_table NVARCHAR(max) = ''
    --DECLARE @p_curr_date_col nvarchar(max) = ''    
    DECLARE @p_round_point NVARCHAR(max) = ''
    DECLARE @v_round_point NVARCHAR(max) = '1'
    DECLARE @p_confirm_area NVARCHAR(max) = ''
    DECLARE @p_plan_date NVARCHAR(max) = ''
    DECLARE @p_param NVARCHAR(max) = ''
    DECLARE @p_queryset1 NVARCHAR(max) = ''
    DECLARE @p_cate_info NVARCHAR(max) = ''
    DECLARE @v_user_id NVARCHAR(max) = ''
    DECLARE @v_plan_date NVARCHAR(max)
    DECLARE @v_plan_type NVARCHAR(max)
    DECLARE @v_bucket_from NVARCHAR(max)
    DECLARE @v_bucket_to NVARCHAR(max)
    DECLARE @v_site_id NVARCHAR(max)
    DECLARE @v_operation_id NVARCHAR(max)
    DECLARE @v_top_item_id NVARCHAR(max)
    DECLARE @v_item_id NVARCHAR(max)
    DECLARE @v_prod_type NVARCHAR(max)
    DECLARE @v_item_name NVARCHAR(max)
    DECLARE @v_fp_site_id NVARCHAR(max)
    DECLARE @v_master_id NVARCHAR(max)
    DECLARE @v_cell_group NVARCHAR(max)
    DECLARE @v_instance_id NVARCHAR(max)
    DECLARE @v_plan_id NVARCHAR(max)
    DECLARE @v_bucket NVARCHAR(max)
    DECLARE @v_week_info NVARCHAR(max)
    DECLARE @v_month_info NVARCHAR(max)
    DECLARE @v_division_lt NVARCHAR(max)
    DECLARE @v_plant_lt NVARCHAR(max)
    DECLARE @v_factory_lt NVARCHAR(max)
    DECLARE @v_line_lt NVARCHAR(max)
    DECLARE @v_model_lt NVARCHAR(max)
    DECLARE @v_operation_lt NVARCHAR(max)
    DECLARE @v_nickname_lt NVARCHAR(max)
    DECLARE @v_day2month NVARCHAR(max)
    DECLARE @v_day2week NVARCHAR(max)
    DECLARE @v_curr_date_col NVARCHAR(max)
    DECLARE @v_confirm_area NVARCHAR(max)
    DECLARE @v_param NVARCHAR(max)
    DECLARE @v_queryset1 NVARCHAR(max)
    --DECLARE BASE PARAMETER START END    
    --Optional Parameter Part START    
    DECLARE @opt_0bucket_from NVARCHAR(max)
    DECLARE @opt_1bucket_from NVARCHAR(max)
    DECLARE @opt_2bucket_from NVARCHAR(max)
    DECLARE @opt_3site_id NVARCHAR(max)
    DECLARE @opt_4top_item_id NVARCHAR(max)
    DECLARE @opt_5item_id NVARCHAR(max)
    DECLARE @opt_6site_id NVARCHAR(max)
    DECLARE @opt_7top_item_id NVARCHAR(max)
    DECLARE @opt_8item_id NVARCHAR(max)
    DECLARE @opt_9site_id NVARCHAR(max)
    DECLARE @opt_10operation_id NVARCHAR(max)
    DECLARE @opt_11top_item_id NVARCHAR(max)
    DECLARE @opt_12item_id NVARCHAR(max)
    DECLARE @opt_13prod_type NVARCHAR(max)
    DECLARE @opt_14site_id NVARCHAR(max)
    DECLARE @opt_15operation_id NVARCHAR(max)
    DECLARE @opt_16top_item_id NVARCHAR(max)
    DECLARE @opt_17item_id NVARCHAR(max)
    DECLARE @opt_18prod_type NVARCHAR(max)
    DECLARE @opt_19site_id NVARCHAR(max)
    DECLARE @opt_20operation_id NVARCHAR(max)
    DECLARE @opt_21site_id NVARCHAR(max)
    DECLARE @opt_22item_id NVARCHAR(max)
    DECLARE @opt_23item_name NVARCHAR(max)
    DECLARE @opt_24cell_group NVARCHAR(max)
    DECLARE @opt_25bucket_from NVARCHAR(max)
    DECLARE @opt_26site_id NVARCHAR(max)
    DECLARE @opt_27top_item_id NVARCHAR(max)
    DECLARE @opt_28item_id NVARCHAR(max)
    DECLARE @opt_29site_id NVARCHAR(max)
    DECLARE @opt_30top_item_id NVARCHAR(max)
    DECLARE @opt_31item_id NVARCHAR(max)
    DECLARE @opt_32site_id NVARCHAR(max)
    DECLARE @opt_33item_id NVARCHAR(max)
    DECLARE @opt_34item_name NVARCHAR(max)
    DECLARE @opt_35cell_group NVARCHAR(max)
    DECLARE @opt_36instance_id NVARCHAR(max)
    DECLARE @opt_37site_id NVARCHAR(max)
    DECLARE @opt_38top_item_id NVARCHAR(max)
    DECLARE @opt_39item_id NVARCHAR(max)
    DECLARE @opt_40site_id NVARCHAR(max)
    DECLARE @opt_41top_item_id NVARCHAR(max)
    DECLARE @opt_42item_id NVARCHAR(max)
    DECLARE @opt_43site_id NVARCHAR(max)
    DECLARE @opt_44operation_id NVARCHAR(max)
    DECLARE @opt_45top_item_id NVARCHAR(max)
    DECLARE @opt_46item_id NVARCHAR(max)
    DECLARE @opt_47prod_type NVARCHAR(max)
    DECLARE @opt_48site_id NVARCHAR(max)
    DECLARE @opt_49operation_id NVARCHAR(max)
    DECLARE @opt_50top_item_id NVARCHAR(max)
    DECLARE @opt_51item_id NVARCHAR(max)
    DECLARE @opt_52prod_type NVARCHAR(max)
    DECLARE @opt_53site_id NVARCHAR(max)
    DECLARE @opt_54operation_id NVARCHAR(max)
    DECLARE @opt_55site_id NVARCHAR(max)
    DECLARE @opt_56item_id NVARCHAR(max)
    DECLARE @opt_57item_name NVARCHAR(max)
    DECLARE @opt_58cell_group NVARCHAR(max)
    DECLARE @opt_59site_id NVARCHAR(max)
    DECLARE @opt_60top_item_id NVARCHAR(max)
    DECLARE @opt_61item_id NVARCHAR(max)
    DECLARE @opt_62site_id NVARCHAR(max)
    DECLARE @opt_63top_item_id NVARCHAR(max)
    DECLARE @opt_64item_id NVARCHAR(max)
    DECLARE @opt_65site_id NVARCHAR(max)
    DECLARE @opt_66item_id NVARCHAR(max)
    DECLARE @opt_67item_name NVARCHAR(max)
    DECLARE @opt_68cell_group NVARCHAR(max)

    --Optional Parameter Part END    

--DECLARE @PARAMS NVARCHAR(MAX)

--SET @PARAMS = ''
--SET @PARAMS += 'P_SYS_TYPE:' +ISNULL(@P_SYS_TYPE,'') +CHAR(10)
--SET @PARAMS += 'P_SYS_FLAG:' +ISNULL(@P_SYS_FLAG,'') +CHAR(10)
--SET @PARAMS += 'P_SYS_GUBUN:' +ISNULL(@P_SYS_GUBUN,'') +CHAR(10)
--SET @PARAMS += 'P_USER_ID:' +ISNULL(@P_USER_ID,'') +CHAR(10)
--SET @PARAMS += 'IN_COLUMNS:' +ISNULL(@IN_COLUMNS,'') +CHAR(10)
--SET @PARAMS += 'IN_ROW:' +ISNULL(@IN_ROW,'') +CHAR(10)
--SET @PARAMS += 'OPT_NONE:' +ISNULL(@OPT_NONE,'') +CHAR(10)

--IF @P_SYS_TYPE = 'SQL' BEGIN
--  SELECT @PARAMS AS SQL
--RETURN
--END


    SET @v_delimiter = '^' -- 데이터 구분자    
    SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@in_columns, @v_delimiter)

    -- 프로시저 LOOP 길이를 판단    
    DECLARE @tmp_column NVARCHAR(max) = ''

    WHILE @mst_loop_cnt < @max_loop_cnt
    BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트      
        SET @mst_loop_cnt = @mst_loop_cnt + 1; -- @mst_loop_cnt 1증가    
        SET @tmp_column = [dbo].[scm_arr_spl_val](@in_columns, @v_delimiter, @mst_loop_cnt);

        IF @tmp_column = '_SAVE_AUTH'
        BEGIN
            SET @tmp_column = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'BUCKET_FROM'
        BEGIN
            SET @p_bucket_from = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'BUCKET_TO'
        BEGIN
            SET @p_bucket_to = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'SITE_ID'
        BEGIN
            SET @p_site_id = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'TOP_ITEM_ID'
        BEGIN
            SET @p_top_item_id = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'ITEM_ID'
        BEGIN
            SET @p_item_id = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'PROD_TYPE'
        BEGIN
            SET @p_prod_type = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'PRODTYPE_LT'
        BEGIN
            SET @p_prodtype_lt = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'ITEM_NAME'
        BEGIN
            SET @p_item_name = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'FP_SITE_ID'
        BEGIN
            SET @p_fp_site_id = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'MASTER_ID'
        BEGIN
            SET @p_master_id = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'CELL_GROUP'
        BEGIN
            SET @p_cell_group = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'INSTANCE_ID'
        BEGIN
            SET @p_instance_id = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'PLANT_ID'
        BEGIN
            SET @p_plant_lt = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'PLAN_ID'
        BEGIN
            SET @p_plan_id = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'FP_PLAN_ID'
        BEGIN
            SET @p_plan_id = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'BUCKET'
        BEGIN
            SET @p_bucket = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'CURR_DATE_COL'
        BEGIN
            SET @p_curr_date_col = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'DAY_INFO'
        BEGIN
            SET @p_day_info = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'WEEK_INFO'
        BEGIN
            SET @p_week_info = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'AMEND_TABLE'
        BEGIN
            SET @p_amend_table = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'AMEND_CAPA_TABLE'
        BEGIN
            SET @p_amend_capa_table = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'AMEND_UTIL_TABLE'
        BEGIN
            SET @p_amend_util_table = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'MONTH_INFO'
        BEGIN
            SET @p_month_info = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'DIVISION_ID'
        BEGIN
            SET @p_division_lt = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'FACTORY_ID'
        BEGIN
            SET @p_factory_lt = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'LINE_ID'
        BEGIN
            SET @p_line_lt = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'MODEL_ID'
        BEGIN
            SET @p_model_lt = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'OPERATION_ID'
        BEGIN
            SET @p_operation_lt = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'NICKNAME'
        BEGIN
            SET @p_nickname = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'NICKNAME_LT'
        BEGIN
            SET @p_nickname_lt = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'DAY2MONTH'
        BEGIN
            SET @p_day2month = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'DAY2WEEK'
        BEGIN
            SET @p_day2week = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'CURR_DATE_COL'
        BEGIN
            SET @p_curr_date_col = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'CONFIRM_AREA'
        BEGIN
            SET @p_confirm_area = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'PLAN_DATE'
        BEGIN
            SET @p_plan_date = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'PLAN_TYPE'
        BEGIN
            SET @p_plan_type = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'PARAM'
        BEGIN
            SET @p_param = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'ROUND_POINT'
        BEGIN
            SET @p_round_point = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'CATE_INFO'
        BEGIN
            SET @p_cate_info = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'QUERYSET1'
        BEGIN
            SET @p_queryset1 = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = '_NON_AUTH'
        BEGIN
            SET @tmp_column = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
    END

    --SET @p_user_id = dbo.FN_deCRYPT_AES128(@p_user_id)    
    --SET @v_ROUND_POINT = TRY_CONVERT(INTEGER,@p_ROUND_POINT)    
    --SELECT @p_NICKNAME_LTT AS SQL    
    --RETURN    
    SET @v_round_point = isnull(@p_round_point, '1')

    SET @v_user_id = '''' + @p_user_id + ''''
    SET @v_plan_date = '''' + @p_plan_date + ''''
    SET @v_plan_type = '''' + @p_plan_type + ''''
    SET @v_bucket_from = '''' + @p_bucket_from + ''''
    SET @v_plan_id = '''' + @p_plan_id + ''''
    SET @v_bucket_to = '''' + @p_bucket_to + ''''
    SET @v_site_id = '''' + @p_site_id + ''''
    SET @v_top_item_id = '''' + @p_top_item_id + ''''
    SET @v_item_id = '''' + @p_item_id + ''''
    SET @v_prod_type = '''' + @p_prod_type + ''''
    SET @v_item_name = '''' + @p_item_name + ''''
    SET @v_fp_site_id = '''' + @p_fp_site_id + ''''
    SET @v_master_id = '''' + @p_master_id + ''''
    SET @v_cell_group = '''' + @p_cell_group + ''''
    SET @v_instance_id = '''' + @p_instance_id + ''''
    SET @v_bucket = '''' + @p_bucket + ''''
    SET @v_week_info = '''' + @p_week_info + ''''
    SET @v_month_info = '''' + @p_month_info + ''''
    SET @v_division_lt = '''' + @p_division_lt + ''''
    SET @v_plant_lt = '''' + @p_plant_lt + ''''
    SET @v_factory_lt = '''' + @p_factory_lt + ''''
    SET @v_line_lt = '''' + @p_line_lt + ''''
    SET @v_model_lt = '''' + @p_model_lt + ''''
    SET @v_operation_lt = '''' + @p_operation_lt + ''''
    SET @v_nickname_lt = '''' + @p_nickname_lt + ''''
    SET @v_curr_date_col = '''' + @p_curr_date_col + ''''
    SET @v_confirm_area = '''' + @p_confirm_area + ''''
    SET @v_param = '''' + @p_param + ''''
    SET @v_queryset1 = '''' + @p_queryset1 + ''''
    SET @strlen = Len(@p_bucket_from)

    IF @strlen < 1
    BEGIN
        SET @opt_0bucket_from = ''
    END
    ELSE
    BEGIN
        SET @opt_0bucket_from = 'i'
    END

    SET @strlen = Len(@p_bucket_from)

    IF @strlen < 1
    BEGIN
        SET @opt_1bucket_from = ''
    END
    ELSE
    BEGIN
        SET @opt_1bucket_from = 'i'
    END

    SET @strlen = Len(@p_bucket_from)

    IF @strlen < 1
    BEGIN
        SET @opt_2bucket_from = ''
    END
    ELSE
    BEGIN
        SET @opt_2bucket_from = 'i'
    END

    SET @strlen = Len(@p_site_id)

    IF @strlen < 1
    BEGIN
        SET @opt_3site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_3site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @strlen = Len(@p_top_item_id)

    IF @strlen < 1
    BEGIN
        SET @opt_4top_item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_4top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id + ' + ''%'''
    END

    SET @strlen = Len(@p_item_id)

    IF @strlen < 1
    BEGIN
        SET @opt_5item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_5item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @strlen = Len(@p_site_id)

    IF @strlen < 1
    BEGIN
        SET @opt_6site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_6site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @strlen = Len(@p_top_item_id)

    IF @strlen < 1
    BEGIN
        SET @opt_7top_item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_7top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id + ' + ''%'''
    END

    SET @strlen = Len(@p_item_id)

    IF @strlen < 1
    BEGIN
        SET @opt_8item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_8item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @strlen = Len(@p_site_id)

    IF @strlen < 1
    BEGIN
        SET @opt_9site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_9site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @strlen = Len(@p_top_item_id)

    IF @strlen < 1
    BEGIN
        SET @opt_11top_item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_11top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id + ' + ''%'''
    END

    SET @strlen = Len(@p_item_id)

    IF @strlen < 1
    BEGIN
        SET @opt_12item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_12item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @strlen = Len(@p_prod_type)

    IF @strlen < 1
    BEGIN
        SET @opt_13prod_type = ''
    END
    ELSE
    BEGIN
        SET @opt_13prod_type = 'AND    A.PRODUCTION_TYPE LIKE ''%'' + ' + @v_prod_type + ' + ''%'''
    END

    SET @strlen = Len(@p_site_id)

    IF @strlen < 1
    BEGIN
        SET @opt_14site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_14site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @strlen = Len(@p_top_item_id)

    IF @strlen < 1
    BEGIN
        SET @opt_16top_item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_16top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id + ' + ''%'''
    END

    SET @strlen = Len(@p_item_id)

    IF @strlen < 1
    BEGIN
        SET @opt_17item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_17item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @strlen = Len(@p_prod_type)

    IF @strlen < 1
    BEGIN
        SET @opt_18prod_type = ''
    END
    ELSE
    BEGIN
        SET @opt_18prod_type = 'AND    A.PRODUCTION_TYPE LIKE ''%'' + ' + @v_prod_type + ' + ''%'''
    END

    SET @strlen = Len(@p_site_id)

    IF @strlen < 1
    BEGIN
        SET @opt_19site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_19site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @strlen = Len(@p_site_id)

    IF @strlen < 1
    BEGIN
        SET @opt_21site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_21site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @strlen = Len(@p_item_id)

    IF @strlen < 1
    BEGIN
        SET @opt_22item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_22item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @strlen = Len(@p_item_name)

    IF @strlen < 1
    BEGIN
        SET @opt_23item_name = ''
    END
    ELSE
    BEGIN
        SET @opt_23item_name = 'AND    C.NICK_NAME LIKE ''%'' + ' + @v_item_name + ' + ''%'''
    END

    SET @strlen = Len(@p_cell_group)

    IF @strlen < 1
    BEGIN
        SET @opt_24cell_group = ''
    END
    ELSE
    BEGIN
        SET @opt_24cell_group = 'AND    J.CELL_GROUP LIKE ''%'' + ' + @v_cell_group + ' + ''%'''
    END

    SET @strlen = Len(@p_bucket_from)

    IF @strlen < 1
    BEGIN
        SET @opt_25bucket_from = ''
    END
    ELSE
    BEGIN
        SET @opt_25bucket_from = 'i'
    END

    SET @strlen = Len(@p_site_id)

    IF @strlen < 1
    BEGIN
        SET @opt_26site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_26site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @strlen = Len(@p_top_item_id)

    IF @strlen < 1
    BEGIN
        SET @opt_27top_item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_27top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id + ' + ''%'''
    END

    SET @strlen = Len(@p_item_id)

    IF @strlen < 1
    BEGIN
        SET @opt_28item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_28item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @strlen = Len(@p_site_id)

    IF @strlen < 1
    BEGIN
        SET @opt_29site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_29site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @strlen = Len(@p_top_item_id)

    IF @strlen < 1
    BEGIN
        SET @opt_30top_item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_30top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id + ' + ''%'''
    END

    SET @strlen = Len(@p_item_id)

    IF @strlen < 1
    BEGIN
        SET @opt_31item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_31item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @strlen = Len(@p_site_id)

    IF @strlen < 1
    BEGIN
        SET @opt_32site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_32site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @strlen = Len(@p_item_id)

    IF @strlen < 1
    BEGIN
        SET @opt_33item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_33item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @strlen = Len(@p_item_name)

    IF @strlen < 1
    BEGIN
        SET @opt_34item_name = ''
    END
    ELSE
    BEGIN
        SET @opt_34item_name = 'AND    C.NICK_NAME LIKE ''%'' + ' + @v_item_name + ' + ''%'''
    END

    SET @strlen = Len(@p_cell_group)

    IF @strlen < 1
    BEGIN
        SET @opt_35cell_group = ''
    END
    ELSE
    BEGIN
        SET @opt_35cell_group = 'AND    J.CELL_GROUP LIKE ''%'' + ' + @v_cell_group + ' + ''%'''
    END

    SET @strlen = Len(@p_instance_id)

    IF @strlen < 1
    BEGIN
        SET @opt_36instance_id = ''
    END
    ELSE
    BEGIN
        SET @opt_36instance_id = 'i'
    END

    SET @strlen = Len(@p_site_id)

    IF @strlen < 1
    BEGIN
        SET @opt_37site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_37site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @strlen = Len(@p_top_item_id)

    IF @strlen < 1
    BEGIN
        SET @opt_38top_item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_38top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id + ' + ''%'''
    END

    SET @strlen = Len(@p_item_id)

    IF @strlen < 1
    BEGIN
        SET @opt_39item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_39item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @strlen = Len(@p_site_id)

    IF @strlen < 1
    BEGIN
        SET @opt_40site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_40site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @strlen = Len(@p_top_item_id)

    IF @strlen < 1
    BEGIN
        SET @opt_41top_item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_41top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id + ' + ''%'''
    END

    SET @strlen = Len(@p_item_id)

    IF @strlen < 1
    BEGIN
        SET @opt_42item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_42item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @strlen = Len(@p_site_id)

    IF @strlen < 1
    BEGIN
        SET @opt_43site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_43site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @strlen = Len(@p_top_item_id)

    IF @strlen < 1
    BEGIN
        SET @opt_45top_item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_45top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id + ' + ''%'''
    END

    SET @strlen = Len(@p_item_id)

    IF @strlen < 1
    BEGIN
        SET @opt_46item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_46item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @strlen = Len(@p_prod_type)

    IF @strlen < 1
    BEGIN
        SET @opt_47prod_type = ''
    END
    ELSE
    BEGIN
        SET @opt_47prod_type = 'AND    A.PRODUCTION_TYPE LIKE ''%'' + ' + @v_prod_type + ' + ''%'''
    END

    SET @strlen = Len(@p_site_id)

    IF @strlen < 1
    BEGIN
        SET @opt_48site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_48site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @strlen = Len(@p_top_item_id)

    IF @strlen < 1
    BEGIN
        SET @opt_50top_item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_50top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id + ' + ''%'''
    END

    SET @strlen = Len(@p_item_id)

    IF @strlen < 1
    BEGIN
        SET @opt_51item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_51item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @strlen = Len(@p_prod_type)

    IF @strlen < 1
    BEGIN
        SET @opt_52prod_type = ''
    END
    ELSE
    BEGIN
        SET @opt_52prod_type = 'AND    A.PRODUCTION_TYPE LIKE ''%'' + ' + @v_prod_type + ' + ''%'''
    END

    SET @strlen = Len(@p_site_id)

    IF @strlen < 1
    BEGIN
        SET @opt_53site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_53site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @strlen = Len(@p_site_id)

    IF @strlen < 1
    BEGIN
        SET @opt_55site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_55site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @strlen = Len(@p_item_id)

    IF @strlen < 1
    BEGIN
        SET @opt_56item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_56item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @strlen = Len(@p_item_name)

    IF @strlen < 1
    BEGIN
        SET @opt_57item_name = ''
    END
    ELSE
    BEGIN
        SET @opt_57item_name = 'AND    C.NICK_NAME LIKE ''%'' + ' + @v_item_name + ' + ''%'''
    END

    SET @strlen = Len(@p_cell_group)

    IF @strlen < 1
    BEGIN
        SET @opt_58cell_group = ''
    END
    ELSE
    BEGIN
        SET @opt_58cell_group = 'AND    J.CELL_GROUP LIKE ''%'' + ' + @v_cell_group + ' + ''%'''
    END

    SET @strlen = Len(@p_site_id)

    IF @strlen < 1
    BEGIN
        SET @opt_59site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_59site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @strlen = Len(@p_top_item_id)

    IF @strlen < 1
    BEGIN
        SET @opt_60top_item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_60top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id + ' + ''%'''
    END

    SET @strlen = Len(@p_item_id)

    IF @strlen < 1
    BEGIN
        SET @opt_61item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_61item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @strlen = Len(@p_site_id)

    IF @strlen < 1
    BEGIN
        SET @opt_62site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_62site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @strlen = Len(@p_top_item_id)

    IF @strlen < 1
    BEGIN
        SET @opt_63top_item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_63top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id + ' + ''%'''
    END

    SET @strlen = Len(@p_item_id)

    IF @strlen < 1
    BEGIN
        SET @opt_64item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_64item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @strlen = Len(@p_site_id)

    IF @strlen < 1
    BEGIN
        SET @opt_65site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_65site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @strlen = Len(@p_item_id)

    IF @strlen < 1
    BEGIN
        SET @opt_66item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_66item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @strlen = Len(@p_item_name)

    IF @strlen < 1
    BEGIN
        SET @opt_67item_name = ''
    END
    ELSE
    BEGIN
        SET @opt_67item_name = 'AND    C.NICK_NAME LIKE ''%'' + ' + @v_item_name + ' + ''%'''
    END

    SET @strlen = Len(@p_cell_group)

    IF @strlen < 1
    BEGIN
        SET @opt_68cell_group = ''
    END
    ELSE
    BEGIN
        SET @opt_68cell_group = 'AND    J.CELL_GROUP LIKE ''%'' + ' + @v_cell_group + ' + ''%'''
    END

    DECLARE @sub_mst_loop_cnt INTEGER = 0
    DECLARE @sub_max_loop_cnt INTEGER = 0
    DECLARE @sub_v_delimiter NVARCHAR(2) = '#'
    DECLARE @sub_tmp_column NVARCHAR(max) = ''
    DECLARE @sub_param_0 NVARCHAR(max) = ''
    DECLARE @sub_param_1 NVARCHAR(max) = ''
    DECLARE @sub_param_2 NVARCHAR(max) = ''
    DECLARE @sub_param_3 NVARCHAR(max) = ''
    DECLARE @sub_param_4 NVARCHAR(max) = ''
    DECLARE @p_dsql VARCHAR(max) = ''
    DECLARE @o_dsql VARCHAR(max) = ''

    SET @p_dsql = ''

    DECLARE @binqty INTEGER = 0
    DECLARE @boutqty INTEGER = 0
    DECLARE @bmppinqty INTEGER = 0
    DECLARE @bmppoutqty INTEGER = 0
    DECLARE @bwppinqty INTEGER = 0
    DECLARE @bwppoutqty INTEGER = 0
    DECLARE @bresultin INTEGER = 0
    DECLARE @bresultout INTEGER = 0
    DECLARE @benginein INTEGER = 0
    DECLARE @bengineout INTEGER = 0
    DECLARE @bresult INTEGER = 0
    DECLARE @bseq INTEGER = 0
    DECLARE @bsim INTEGER = 0
    DECLARE @bdpp INTEGER = 0
    DECLARE @bwpp INTEGER = 0
    DECLARE @bmpp INTEGER = 0
    DECLARE @bengine INTEGER = 0
    DECLARE @bmemo INTEGER = 0
    DECLARE @bofftime INTEGER = 0
    DECLARE @bcapa INTEGER = 0
    DECLARE @bsetup INTEGER = 0
    DECLARE @bpc INTEGER = 0
    DECLARE @bjr INTEGER = 0
    DECLARE @bcell INTEGER = 0
    DECLARE @bbatch INTEGER = 0
    DECLARE @btotal INTEGER = 0
    DECLARE @bsubtotal INTEGER = 0

	DECLARE @bSunWeek				NVARCHAR(2) = 'N'
	DECLARE @WeekColumn NVARCHAR(10) = 'ISO_YYYYWW';

    --SELECT @p_cate_info as SQL    
    --RETURN    
    IF isnull(@p_cate_info, '') <> ''
    BEGIN
        SET @mst_loop_cnt = 0
        SET @v_delimiter = '!' -- 데이터 구분자    
        SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_cate_info, @v_delimiter)

        -- 프로시저 LOOP 길이를 판단    
        WHILE @mst_loop_cnt < @max_loop_cnt
        BEGIN
            -- 각 컬럼들에 대한 스플릿처리로직 스타트      
            SET @mst_loop_cnt = @mst_loop_cnt + 1;
            -- @mst_loop_cnt 1증가    
            SET @tmp_column = [dbo].[scm_arr_spl_val](@p_cate_info, @v_delimiter, @mst_loop_cnt);
            SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

            IF @sub_max_loop_cnt > 0
            BEGIN
                SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
            END

            IF @sub_max_loop_cnt > 1
            BEGIN
                SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
            END

            IF @sub_max_loop_cnt > 2
            BEGIN
                SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
            END

            IF @sub_max_loop_cnt > 3
            BEGIN
                SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
            END -- D0    

			IF isnull(@sub_param_0, '') = 'chk_week_sun'
               AND isnull(@sub_param_1, '') = 'true'
            BEGIN
                SET @bSunWeek = 'Y'
            END
            ELSE IF isnull(@sub_param_0, '') = 'chk_inqty'
               AND isnull(@sub_param_1, '') = 'true'
            BEGIN
                SET @binqty = 1
            END
            ELSE IF isnull(@sub_param_0, '') = 'chk_outqty'
                    AND isnull(@sub_param_1, '') = 'true'
            BEGIN --IF @tmp_column = 'chk_mpp_outqty' BEGIN    
                SET @boutqty = 1
            END
            ELSE IF isnull(@sub_param_0, '') = 'chk_mpp_inqty'
                    AND isnull(@sub_param_1, '') = 'true'
            BEGIN --IF @tmp_column = 'chk_wpp_inqty' BEGIN    
                SET @bmppinqty = 1
            END
            ELSE IF isnull(@sub_param_0, '') = 'chk_mpp_outqty'
                    AND isnull(@sub_param_1, '') = 'true'
            BEGIN --IF @tmp_column = 'chk_wpp_outqty' BEGIN    
                SET @bmppoutqty = 1
            END
            ELSE IF isnull(@sub_param_0, '') = 'chk_wpp_inqty'
                    AND isnull(@sub_param_1, '') = 'true'
            BEGIN --IF @tmp_column = 'chk_inqty' BEGIN    
                SET @bwppinqty = 1
            END
            ELSE IF isnull(@sub_param_0, '') = 'chk_wpp_outqty'
                    AND isnull(@sub_param_1, '') = 'true'
            BEGIN --IF @tmp_column = 'chk_outqty' BEGIN    
                SET @bwppoutqty = 1
            END
            ELSE IF isnull(@sub_param_0, '') = 'chk_result_in'
                    AND isnull(@sub_param_1, '') = 'true'
            BEGIN --IF @tmp_column = 'chk_result' BEGIN    
                SET @bresultin = 1
            END
            ELSE IF isnull(@sub_param_0, '') = 'chk_result_out'
                    AND isnull(@sub_param_1, '') = 'true'
            BEGIN --IF @tmp_column = 'chk_cell' BEGIN    
                SET @bresultout = 1
            END
            ELSE IF isnull(@sub_param_0, '') = 'chk_engine_inqty'
                    AND isnull(@sub_param_1, '') = 'true'
            BEGIN --IF @tmp_column = 'chk_cell' BEGIN    
                SET @benginein = 1
            END
            ELSE IF isnull(@sub_param_0, '') = 'chk_engine_outqty'
                    AND isnull(@sub_param_1, '') = 'true'
            BEGIN --IF @tmp_column = 'chk_cell' BEGIN    
                SET @bengineout = 1
            END
            ELSE IF isnull(@sub_param_0, '') = 'chk_seq'
                    AND isnull(@sub_param_1, '') = 'true'
            BEGIN --IF @tmp_column = 'chk_cell' BEGIN    
                SET @bseq = 1
            END
            ELSE IF isnull(@sub_param_0, '') = 'chk_off'
                    AND isnull(@sub_param_1, '') = 'true'
            BEGIN --IF @tmp_column = 'chk_capa' BEGIN    
                SET @bofftime = 1
            END
            ELSE IF isnull(@sub_param_0, '') = 'chk_capa'
                    AND isnull(@sub_param_1, '') = 'true'
            BEGIN --IF @tmp_column = 'chk_capa' BEGIN    
                SET @bcapa = 1
            END
            ELSE IF isnull(@sub_param_0, '') = 'chk_setup'
                    AND isnull(@sub_param_1, '') = 'true'
            BEGIN --IF @tmp_column = 'chk_capa' BEGIN    
                SET @bsetup = 1
            END
            ELSE IF isnull(@sub_param_0, '') = 'chk_pc'
                    AND isnull(@sub_param_1, '') = 'true'
            BEGIN --IF @tmp_column = 'chk_capa' BEGIN    
                SET @bpc = 1
            END
            ELSE IF isnull(@sub_param_0, '') = 'chk_jr'
                    AND isnull(@sub_param_1, '') = 'true'
            BEGIN --IF @tmp_column = 'chk_capa' BEGIN    
                SET @bjr = 1
            END
            ELSE IF isnull(@sub_param_0, '') = 'chk_cell'
                    AND isnull(@sub_param_1, '') = 'true'
            BEGIN --IF @tmp_column = 'chk_capa' BEGIN    
                SET @bcell = 1
            END
            ELSE IF isnull(@sub_param_0, '') = 'chk_batch'
                    AND isnull(@sub_param_1, '') = 'true'
            BEGIN --IF @tmp_column = 'chk_capa' BEGIN    
                SET @bbatch = 1
            END
            ELSE IF isnull(@sub_param_0, '') = 'chk_total'
                    AND isnull(@sub_param_1, '') = 'true'
            BEGIN --IF @tmp_column = 'chk_capa' BEGIN    
                SET @btotal = 1
            END
            ELSE IF isnull(@sub_param_0, '') = 'chk_subTotal'
                    AND isnull(@sub_param_1, '') = 'true'
            BEGIN --ELSE IF @tmp_column = 'chk_target' BEGIN    
                SET @bsubtotal = 1
            END
            ELSE IF isnull(@sub_param_0, '') = 'chk_memo'
                    AND isnull(@sub_param_1, '') = 'true'
            BEGIN --ELSE IF @tmp_column = 'chk_target' BEGIN    
                SET @bmemo = 1
            END
            ELSE IF isnull(@sub_param_0, '') = 'chk_sim'
                    AND isnull(@sub_param_1, '') = 'true'
            BEGIN --ELSE IF @tmp_column = 'chk_target' BEGIN    
                SET @bsim = 1
            END

			DECLARE @A_DIVISION_ID_EQ NVARCHAR(MAX) 
			DECLARE @A_SITE_ID_EQ NVARCHAR(MAX) 
			DECLARE @A_PLANT_ID_EQ NVARCHAR(MAX) 
			DECLARE @A_FACTORY_ID_EQ NVARCHAR(MAX) 
			SET @A_DIVISION_ID_EQ = '' + (SELECT [DBO].[fn_scm_get_where_sql]('A.DIVISION_ID', 'EQ', @p_division_lt))
			SET @A_SITE_ID_EQ = '' + (SELECT [DBO].[fn_scm_get_where_sql]('A.SITE_ID', 'EQ', @p_site_id))
			SET @A_PLANT_ID_EQ = '' + (SELECT [DBO].[fn_scm_get_where_sql]('A.PLANT_ID', 'EQ', @p_plant_lt))
			SET @A_FACTORY_ID_EQ = '' + (SELECT [DBO].[fn_scm_get_where_sql]('A.FACTORY_ID', 'EQ', @p_factory_lt))

            IF (
                   isnull(@sub_param_0, '') = 'chk_inqty'
                   AND isnull(@sub_param_1, '') = 'true'
               )
               OR (
                      isnull(@sub_param_0, '') = 'chk_outqty'
                      AND isnull(@sub_param_1, '') = 'true'
                  )
            BEGIN
                SET @bdpp = 1
            END

            IF (
                   isnull(@sub_param_0, '') = 'chk_mpp_inqty'
                   AND isnull(@sub_param_1, '') = 'true'
               )
               OR (
                      isnull(@sub_param_0, '') = 'chk_mpp_outqty'
                      AND isnull(@sub_param_1, '') = 'true'
                  )
            BEGIN
                SET @bmpp = 1
            END

            IF (
                   isnull(@sub_param_0, '') = 'chk_wpp_inqty'
                   AND isnull(@sub_param_1, '') = 'true'
               )
               OR (
                      isnull(@sub_param_0, '') = 'chk_wpp_outqty'
                      AND isnull(@sub_param_1, '') = 'true'
                  )
            BEGIN
                SET @bwpp = 1
            END

            IF (
                   isnull(@sub_param_0, '') = 'chk_result_in'
                   AND isnull(@sub_param_1, '') = 'true'
               )
               OR (
                      isnull(@sub_param_0, '') = 'chk_result_out'
                      AND isnull(@sub_param_1, '') = 'true'
                  )
            BEGIN
                SET @bresult = 1
            END

            IF (
                   isnull(@sub_param_0, '') = 'chk_engine_inqty'
                   AND isnull(@sub_param_1, '') = 'true'
               )
               OR (
                      isnull(@sub_param_0, '') = 'chk_engine_outqty'
                      AND isnull(@sub_param_1, '') = 'true'
                  )
            BEGIN
                SET @bengine = 1
            END
        END -- END OF WHILE    

        SET @p_dsql += 'SELECT ''X'' AS CATEGORY_ID, ''X'' AS MEASURE_NAME, '''' AS CATEGORY_NAME, 0 AS CATEGORY_ORDER '
                       + char(10)

        IF @bmppinqty = 1
           AND @bpc = 1
        BEGIN
            SET @p_dsql += 'UNION ALL' + char(10)
            SET @p_dsql += 'SELECT ''P_MPP_IN_M'' AS CATEGORY_ID, ''M(P/C)'' AS MEASURE_NAME, ''MPP(In)'' AS CATEGORY_NAME, 2.3 AS CATEGORY_ORDER'
                           + char(10)
        END

        IF @bmppinqty = 1
           AND @bjr = 1
        BEGIN
            SET @p_dsql += 'UNION ALL' + char(10)
            SET @p_dsql += 'SELECT ''P_MPP_IN_JR'' AS CATEGORY_ID, ''J/R'' AS MEASURE_NAME, ''MPP(In)'' AS CATEGORY_NAME, 2.2 AS CATEGORY_ORDER'
                           + char(10)
        END

        IF @bmppinqty = 1
           AND @bcell = 1
        BEGIN
            SET @p_dsql += 'UNION ALL' + char(10)
            SET @p_dsql += 'SELECT ''P_MPP_IN_CELL'' AS CATEGORY_ID, ''Cell'' AS MEASURE_NAME, ''MPP(In)'' AS CATEGORY_NAME, 2.4 AS CATEGORY_ORDER'
                           + char(10)
        END

        IF @bmppinqty = 1
           AND @bbatch = 1
        BEGIN
            SET @p_dsql += 'UNION ALL' + char(10)
            SET @p_dsql += 'SELECT ''P_MPP_IN_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''MPP(In)'' AS CATEGORY_NAME, 2.1 AS CATEGORY_ORDER'
                           + char(10)
        END

        IF @bmppoutqty = 1
           AND @bpc = 1
        BEGIN
            SET @p_dsql += 'UNION ALL' + char(10)
            SET @p_dsql += 'SELECT ''P_MPP_OUT_M'' AS CATEGORY_ID, ''M(P/C)'' AS MEASURE_NAME, ''MPP(Out)'' AS CATEGORY_NAME, 2.7 AS CATEGORY_ORDER'
                           + char(10)
        END

        IF @bmppoutqty = 1
           AND @bjr = 1
        BEGIN
            SET @p_dsql += 'UNION ALL' + char(10)
            SET @p_dsql += 'SELECT ''P_MPP_OUT_JR'' AS CATEGORY_ID, ''J/R'' AS MEASURE_NAME, ''MPP(Out)'' AS CATEGORY_NAME, 2.6 AS CATEGORY_ORDER'
                           + char(10)
        END

        IF @bmppoutqty = 1
           AND @bcell = 1
        BEGIN
            SET @p_dsql += 'UNION ALL' + char(10)
            SET @p_dsql += 'SELECT ''P_MPP_OUT_CELL'' AS CATEGORY_ID, ''Cell'' AS MEASURE_NAME, ''MPP(Out)'' AS CATEGORY_NAME, 2.8 AS CATEGORY_ORDER'
                           + char(10)
        END

        IF @bmppoutqty = 1
           AND @bbatch = 1
        BEGIN
            SET @p_dsql += 'UNION ALL' + char(10)
            SET @p_dsql += 'SELECT ''P_MPP_OUT_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''MPP(Out)'' AS CATEGORY_NAME, 2.5 AS CATEGORY_ORDER'
                           + char(10)
        END

        IF @bwppinqty = 1
           AND @bpc = 1
        BEGIN
            SET @p_dsql += 'UNION ALL' + char(10)
            SET @p_dsql += 'SELECT ''P_WPP_IN_M'' AS CATEGORY_ID, ''M(P/C)'' AS MEASURE_NAME, ''WPP(In)'' AS CATEGORY_NAME, 3.3 AS CATEGORY_ORDER'
                           + char(10)
        END

        IF @bwppinqty = 1
           AND @bjr = 1
        BEGIN
            SET @p_dsql += 'UNION ALL' + char(10)
            SET @p_dsql += 'SELECT ''P_WPP_IN_JR'' AS CATEGORY_ID, ''J/R'' AS MEASURE_NAME, ''WPP(In)'' AS CATEGORY_NAME, 3.2 AS CATEGORY_ORDER'
                           + char(10)
        END

        IF @bwppinqty = 1
           AND @bcell = 1
        BEGIN
            SET @p_dsql += 'UNION ALL' + char(10)
            SET @p_dsql += 'SELECT ''P_WPP_IN_CELL'' AS CATEGORY_ID, ''Cell'' AS MEASURE_NAME, ''WPP(In)'' AS CATEGORY_NAME, 3.4 AS CATEGORY_ORDER'
                           + char(10)
        END

        IF @bwppinqty = 1
           AND @bbatch = 1
        BEGIN
            SET @p_dsql += 'UNION ALL' + char(10)
            SET @p_dsql += 'SELECT ''P_WPP_IN_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''WPP(In)'' AS CATEGORY_NAME, 3.1 AS CATEGORY_ORDER'
                           + char(10)
        END

        IF @bwppoutqty = 1
           AND @bpc = 1
        BEGIN
            SET @p_dsql += 'UNION ALL' + char(10)
            SET @p_dsql += 'SELECT ''P_WPP_OUT_M'' AS CATEGORY_ID, ''M(P/C)'' AS MEASURE_NAME, ''WPP(Out)'' AS CATEGORY_NAME, 3.7 AS CATEGORY_ORDER'
                           + char(10)
        END

        IF @bwppoutqty = 1
           AND @bjr = 1
        BEGIN
            SET @p_dsql += 'UNION ALL' + char(10)
            SET @p_dsql += 'SELECT ''P_WPP_OUT_JR'' AS CATEGORY_ID, ''J/R'' AS MEASURE_NAME, ''WPP(Out)'' AS CATEGORY_NAME, 3.6 AS CATEGORY_ORDER'
                           + char(10)
        END

        IF @bwppoutqty = 1
           AND @bcell = 1
        BEGIN
            SET @p_dsql += 'UNION ALL' + char(10)
            SET @p_dsql += 'SELECT ''P_WPP_OUT_CELL'' AS CATEGORY_ID, ''Cell'' AS MEASURE_NAME, ''WPP(Out)'' AS CATEGORY_NAME, 3.8 AS CATEGORY_ORDER'
                           + char(10)
        END

        IF @bwppoutqty = 1
           AND @bbatch = 1
        BEGIN
            SET @p_dsql += 'UNION ALL' + char(10)
            SET @p_dsql += 'SELECT ''P_WPP_OUT_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''WPP(Out)'' AS CATEGORY_NAME, 3.5 AS CATEGORY_ORDER'
                           + char(10)
        END

        IF @binqty = 1
           AND @bpc = 1
        BEGIN
            SET @p_dsql += 'UNION ALL' + char(10)
            SET @p_dsql += 'SELECT ''P_IN_M'' AS CATEGORY_ID, ''M(P/C)'' AS MEASURE_NAME, ''Plan(In)'' AS CATEGORY_NAME, 30 AS CATEGORY_ORDER'
                           + char(10)
        END

        IF @binqty = 1
           AND @bjr = 1
        BEGIN
            SET @p_dsql += 'UNION ALL' + char(10)
            SET @p_dsql += 'SELECT ''P_IN_JR'' AS CATEGORY_ID, ''J/R'' AS MEASURE_NAME, ''Plan(In)'' AS CATEGORY_NAME, 20 AS CATEGORY_ORDER'
                           + char(10)
        END

        IF @binqty = 1
           AND @bcell = 1
        BEGIN
            SET @p_dsql += 'UNION ALL' + char(10)
            SET @p_dsql += 'SELECT ''P_IN_CELL'' AS CATEGORY_ID, ''Cell'' AS MEASURE_NAME, ''Plan(In)'' AS CATEGORY_NAME, 40 AS CATEGORY_ORDER'
                           + char(10)
        END

        IF @binqty = 1
           AND @bbatch = 1
        BEGIN
            SET @p_dsql += 'UNION ALL' + char(10)
            SET @p_dsql += 'SELECT ''P_IN_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''Plan(In)'' AS CATEGORY_NAME, 10 AS CATEGORY_ORDER'
                           + char(10)
        END

        IF @boutqty = 1
           AND @bpc = 1
        BEGIN
            SET @p_dsql += 'UNION ALL' + char(10)
            SET @p_dsql += 'SELECT ''P_OUT_M'' AS CATEGORY_ID, ''M(P/C)'' AS MEASURE_NAME, ''Plan(Out)'' AS CATEGORY_NAME, 70 AS CATEGORY_ORDER'
                           + char(10)
        END

        IF @boutqty = 1
           AND @bjr = 1
        BEGIN
            SET @p_dsql += 'UNION ALL' + char(10)
            SET @p_dsql += 'SELECT ''P_OUT_JR'' AS CATEGORY_ID, ''J/R'' AS MEASURE_NAME, ''Plan(Out)'' AS CATEGORY_NAME, 60 AS CATEGORY_ORDER'
                           + char(10)
        END

        IF @boutqty = 1
           AND @bcell = 1
        BEGIN
            SET @p_dsql += 'UNION ALL' + char(10)
            SET @p_dsql += 'SELECT ''P_OUT_CELL'' AS CATEGORY_ID, ''Cell'' AS MEASURE_NAME, ''Plan(Out)'' AS CATEGORY_NAME, 80 AS CATEGORY_ORDER'
                           + char(10)
        END

        IF @boutqty = 1
           AND @bbatch = 1
        BEGIN
            SET @p_dsql += 'UNION ALL' + char(10)
            SET @p_dsql += 'SELECT ''P_OUT_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''Plan(Out)'' AS CATEGORY_NAME, 50 AS CATEGORY_ORDER'
                           + char(10)
        END

        IF @bresultin = 1
           AND @bpc = 1
        BEGIN
            SET @p_dsql += 'UNION ALL' + char(10)
            SET @p_dsql += 'SELECT ''P_RESULT_IN_M'' AS CATEGORY_ID, ''M(P/C)'' AS MEASURE_NAME,  ''Result(In)'' AS CATEGORY_NAME, 330 AS CATEGORY_ORDER '
                           + char(10)
        END

        IF @bresultin = 1
           AND @bjr = 1
        BEGIN
            SET @p_dsql += 'UNION ALL' + char(10)
            SET @p_dsql += 'SELECT ''P_RESULT_IN_JR'' AS CATEGORY_ID, ''J/R'' AS MEASURE_NAME, ''Result(In)'' AS CATEGORY_NAME, 320 AS CATEGORY_ORDER '
                           + char(10)
        END

        IF @bresultin = 1
           AND @bcell = 1
        BEGIN
            SET @p_dsql += 'UNION ALL' + char(10)
            SET @p_dsql += 'SELECT ''P_RESULT_IN_CELL'' AS CATEGORY_ID, ''Cell'' AS MEASURE_NAME, ''Result(In)'' AS CATEGORY_NAME, 340 AS CATEGORY_ORDER '
                           + char(10)
        END

        IF @bresultin = 1
           AND @bbatch = 1
        BEGIN
            SET @p_dsql += 'UNION ALL' + char(10)
            SET @p_dsql += 'SELECT ''P_RESULT_IN_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''Result(In)'' AS CATEGORY_NAME, 310 AS CATEGORY_ORDER '
                           + char(10)
        END

        IF @bresultout = 1
           AND @bpc = 1
        BEGIN
            SET @p_dsql += 'UNION ALL' + char(10)
            SET @p_dsql += 'SELECT ''P_RESULT_OUT_M'' AS CATEGORY_ID, ''M(P/C)'' AS MEASURE_NAME, ''Result(Out)'' AS CATEGORY_NAME, 370 AS CATEGORY_ORDER '
                           + char(10)
        END

        IF @bresultout = 1
           AND @bjr = 1
        BEGIN
            SET @p_dsql += 'UNION ALL' + char(10)
            SET @p_dsql += 'SELECT ''P_RESULT_OUT_JR'' AS CATEGORY_ID, ''J/R'' AS MEASURE_NAME, ''Result(Out)'' AS CATEGORY_NAME, 360 AS CATEGORY_ORDER '
                           + char(10)
        END

        IF @bresultout = 1
           AND @bcell = 1
        BEGIN
            SET @p_dsql += 'UNION ALL' + char(10)
            SET @p_dsql += 'SELECT ''P_RESULT_OUT_CELL'' AS CATEGORY_ID, ''Cell'' AS MEASURE_NAME, ''Result(Out)'' AS CATEGORY_NAME, 380 AS CATEGORY_ORDER '
                           + char(10)
        END

        IF @bresultout = 1
           AND @bbatch = 1
        BEGIN
            SET @p_dsql += 'UNION ALL' + char(10)
            SET @p_dsql += 'SELECT ''P_RESULT_OUT_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''Result(Out)'' AS CATEGORY_NAME, 350 AS CATEGORY_ORDER '
                           + char(10)
        END

        IF @benginein = 1
           AND @bbatch = 1
        BEGIN
            SET @p_dsql += 'UNION ALL' + char(10)
            SET @p_dsql += 'SELECT ''P_ENGINE_IN_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME,  ''Engine(In)'' AS CATEGORY_NAME, 9.1 AS CATEGORY_ORDER '
                           + char(10)
        END

        IF @benginein = 1
           AND @bjr = 1
        BEGIN
            SET @p_dsql += 'UNION ALL' + char(10)
            SET @p_dsql += 'SELECT ''P_ENGINE_IN_JR'' AS CATEGORY_ID, ''J/R'' AS MEASURE_NAME, ''Engine(In)'' AS CATEGORY_NAME, 9.2 AS CATEGORY_ORDER '
                           + char(10)
        END

        IF @benginein = 1
           AND @bpc = 1
        BEGIN
            SET @p_dsql += 'UNION ALL' + char(10)
            SET @p_dsql += 'SELECT ''P_ENGINE_IN_M'' AS CATEGORY_ID, ''M(P/C)'' AS MEASURE_NAME, ''Engine(In)'' AS CATEGORY_NAME, 9.3 AS CATEGORY_ORDER '
                           + char(10)
        END

        IF @benginein = 1
           AND @bcell = 1
        BEGIN
            SET @p_dsql += 'UNION ALL' + char(10)
            SET @p_dsql += 'SELECT ''P_ENGINE_IN_CELL'' AS CATEGORY_ID, ''Cell'' AS MEASURE_NAME, ''Engine(In)'' AS CATEGORY_NAME, 9.4 AS CATEGORY_ORDER '
                           + char(10)
        END

        IF @bengineout = 1
           AND @bbatch = 1
        BEGIN
            SET @p_dsql += 'UNION ALL' + char(10)
            SET @p_dsql += 'SELECT ''P_ENGINE_OUT_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''Engine(Out)'' AS CATEGORY_NAME, 49.1 AS CATEGORY_ORDER '
                           + char(10)
        END

        IF @bengineout = 1
           AND @bjr = 1
        BEGIN
            SET @p_dsql += 'UNION ALL' + char(10)
            SET @p_dsql += 'SELECT ''P_ENGINE_OUT_JR'' AS CATEGORY_ID, ''J/R'' AS MEASURE_NAME, ''Engine(Out)'' AS CATEGORY_NAME, 49.2 AS CATEGORY_ORDER '
                           + char(10)
        END

        IF @bengineout = 1
           AND @bpc = 1
        BEGIN
            SET @p_dsql += 'UNION ALL' + char(10)
            SET @p_dsql += 'SELECT ''P_ENGINE_OUT_M'' AS CATEGORY_ID, ''M(P/C)'' AS MEASURE_NAME, ''Engine(Out)'' AS CATEGORY_NAME, 49.3 AS CATEGORY_ORDER '
                           + char(10)
        END

        IF @bengineout = 1
           AND @bcell = 1
        BEGIN
            SET @p_dsql += 'UNION ALL' + char(10)
            SET @p_dsql += 'SELECT ''P_ENGINE_OUT_CELL'' AS CATEGORY_ID, ''Cell'' AS MEASURE_NAME, ''Engine(Out)'' AS CATEGORY_NAME, 49.4 AS CATEGORY_ORDER '
                           + char(10)
        END

        IF @bseq = 1
        BEGIN
            SET @p_dsql += 'UNION ALL' + char(10)
            SET @p_dsql += 'SELECT ''P_SEQ'' AS CATEGORY_ID, '''' AS MEASURE_NAME, ''Seq'' AS CATEGORY_NAME, 45 AS CATEGORY_ORDER '
                           + char(10)
        END
        IF @bmemo = 1
        BEGIN

		    SET @p_dsql += 'UNION ALL' + char(10)
			SET @p_dsql += 'SELECT ''P_MEMO'' AS CATEGORY_ID, '''' AS MEASURE_NAME, ''Memo'' AS CATEGORY_NAME, 600 AS CATEGORY_ORDER'
                       + char(10)
		END
    END
    ELSE
    BEGIN
        SET @p_dsql += 'SELECT ''P_MPP_IN_M'' AS CATEGORY_ID, ''M(P/C)'' AS MEASURE_NAME, ''MPP(In)'' AS CATEGORY_NAME, 2.3 AS CATEGORY_ORDER '
                       + char(10)
        SET @p_dsql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @p_dsql += 'SELECT ''P_MPP_IN_JR'' AS CATEGORY_ID, ''J/R'' AS MEASURE_NAME, ''MPP(In)'' AS CATEGORY_NAME, 2.2 AS CATEGORY_ORDER '
                       + char(10)
        SET @p_dsql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @p_dsql += 'SELECT ''P_MPP_IN_CELL'' AS CATEGORY_ID, ''Cell'' AS MEASURE_NAME, ''MPP(In)'' AS CATEGORY_NAME, 2.4 AS CATEGORY_ORDER '
                       + char(10)
        SET @p_dsql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @p_dsql += 'SELECT ''P_MPP_IN_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''MPP(In)'' AS CATEGORY_NAME, 2.1 AS CATEGORY_ORDER '
                       + char(10)
        SET @p_dsql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @p_dsql += 'SELECT ''P_MPP_OUT_M'' AS CATEGORY_ID, ''M(P/C)'' AS MEASURE_NAME, ''MPP(Out)'' AS CATEGORY_NAME, 2.7 AS CATEGORY_ORDER '
                       + char(10)
        SET @p_dsql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @p_dsql += 'SELECT ''P_MPP_OUT_JR'' AS CATEGORY_ID, ''J/R'' AS MEASURE_NAME, ''MPP(Out)'' AS CATEGORY_NAME, 2.6 AS CATEGORY_ORDER '
                       + char(10)
        SET @p_dsql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @p_dsql += 'SELECT ''P_MPP_OUT_CELL'' AS CATEGORY_ID, ''Cell'' AS MEASURE_NAME, ''MPP(Out)'' AS CATEGORY_NAME, 2.8 AS CATEGORY_ORDER '
                       + char(10)
        SET @p_dsql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @p_dsql += 'SELECT ''P_MPP_OUT_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''MPP(Out)'' AS CATEGORY_NAME, 2.5 AS CATEGORY_ORDER '
                       + char(10)
        SET @p_dsql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @p_dsql += 'SELECT ''P_WPP_IN_M'' AS CATEGORY_ID, ''M(P/C)'' AS MEASURE_NAME, ''WPP(In)'' AS CATEGORY_NAME, 3.3 AS CATEGORY_ORDER '
                       + char(10)
        SET @p_dsql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @p_dsql += 'SELECT ''P_WPP_IN_JR'' AS CATEGORY_ID, ''J/R'' AS MEASURE_NAME, ''WPP(In)'' AS CATEGORY_NAME, 3.2 AS CATEGORY_ORDER '
                       + char(10)
        SET @p_dsql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @p_dsql += 'SELECT ''P_WPP_IN_CELL'' AS CATEGORY_ID, ''Cell'' AS MEASURE_NAME, ''WPP(In)'' AS CATEGORY_NAME, 3.4 AS CATEGORY_ORDER '
                       + char(10)
        SET @p_dsql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @p_dsql += 'SELECT ''P_WPP_IN_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''WPP(In)'' AS CATEGORY_NAME, 3.1 AS CATEGORY_ORDER '
                       + char(10)
        SET @p_dsql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @p_dsql += 'SELECT ''P_WPP_OUT_M'' AS CATEGORY_ID, ''M(P/C)'' AS MEASURE_NAME, ''WPP(Out)'' AS CATEGORY_NAME, 3.7 AS CATEGORY_ORDER '
                       + char(10)
        SET @p_dsql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @p_dsql += 'SELECT ''P_WPP_OUT_JR'' AS CATEGORY_ID, ''J/R'' AS MEASURE_NAME, ''WPP(Out)'' AS CATEGORY_NAME, 3.6 AS CATEGORY_ORDER '
                       + char(10)
        SET @p_dsql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @p_dsql += 'SELECT ''P_WPP_OUT_CELL'' AS CATEGORY_ID, ''Cell'' AS MEASURE_NAME, ''WPP(Out)'' AS CATEGORY_NAME, 3.8 AS CATEGORY_ORDER '
                       + char(10)
        SET @p_dsql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @p_dsql += 'SELECT ''P_WPP_OUT_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''WPP(Out)'' AS CATEGORY_NAME, 3.5 AS CATEGORY_ORDER '
                       + char(10)
        SET @p_dsql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @p_dsql += 'SELECT ''P_IN_M'' AS CATEGORY_ID, ''M(P/C)'' AS MEASURE_NAME, ''Plan(In)'' AS CATEGORY_NAME, 30 AS CATEGORY_ORDER '
                       + char(10)
        SET @p_dsql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @p_dsql += 'SELECT ''P_IN_JR'' AS CATEGORY_ID, ''J/R'' AS MEASURE_NAME, ''Plan(In)'' AS CATEGORY_NAME, 20 AS CATEGORY_ORDER        '
                       + char(10)
        SET @p_dsql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @p_dsql += 'SELECT ''P_IN_CELL'' AS CATEGORY_ID, ''Cell'' AS MEASURE_NAME, ''Plan(In)'' AS CATEGORY_NAME, 40 AS CATEGORY_ORDER     '
                       + char(10)
        SET @p_dsql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @p_dsql += 'SELECT ''P_IN_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''Plan(In)'' AS CATEGORY_NAME, 10 AS CATEGORY_ORDER   '
                       + char(10)
        SET @p_dsql += 'UNION ALL ' + char(10)
        SET @p_dsql += 'SELECT ''P_SEQ'' AS CATEGORY_ID, '''' AS MEASURE_NAME, ''Seq'' AS CATEGORY_NAME, 45 AS CATEGORY_ORDER  '
                       + char(10)
        SET @p_dsql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @p_dsql += 'SELECT ''P_OUT_M'' AS CATEGORY_ID, ''M(P/C)'' AS MEASURE_NAME, ''Plan(Out)'' AS CATEGORY_NAME, 70 AS CATEGORY_ORDER    '
                       + char(10)
        SET @p_dsql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @p_dsql += 'SELECT ''P_OUT_JR'' AS CATEGORY_ID, ''J/R'' AS MEASURE_NAME, ''Plan(Out)'' AS CATEGORY_NAME, 60 AS CATEGORY_ORDER      '
                       + char(10)
        SET @p_dsql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @p_dsql += 'SELECT ''P_OUT_CELL'' AS CATEGORY_ID, ''Cell'' AS MEASURE_NAME, ''Plan(Out)'' AS CATEGORY_NAME, 80 AS CATEGORY_ORDER   '
                       + char(10)
        SET @p_dsql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @p_dsql += 'SELECT ''P_OUT_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''Plan(Out)'' AS CATEGORY_NAME, 50 AS CATEGORY_ORDER '
                       + char(10)
        SET @p_dsql += 'UNION ALL ' + char(10)
        SET @p_dsql += 'SELECT ''P_RESULT_IN_M'' AS CATEGORY_ID, ''M(P/C)'' AS MEASURE_NAME,  ''Result(In)'' AS CATEGORY_NAME, 330 AS CATEGORY_ORDER  '
                       + char(10)
        SET @p_dsql += 'UNION ALL ' + char(10)
        SET @p_dsql += 'SELECT ''P_RESULT_IN_JR'' AS CATEGORY_ID, ''J/R'' AS MEASURE_NAME, ''Result(In)'' AS CATEGORY_NAME, 320 AS CATEGORY_ORDER  '
                       + char(10)
        SET @p_dsql += 'UNION ALL ' + char(10)
        SET @p_dsql += 'SELECT ''P_RESULT_IN_CELL'' AS CATEGORY_ID, ''Cell'' AS MEASURE_NAME, ''Result(In)'' AS CATEGORY_NAME, 340 AS CATEGORY_ORDER  '
                       + char(10)
        SET @p_dsql += 'UNION ALL ' + char(10)
        SET @p_dsql += 'SELECT ''P_RESULT_IN_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''Result(In)'' AS CATEGORY_NAME, 310 AS CATEGORY_ORDER  '
                       + char(10)
        SET @p_dsql += 'UNION ALL ' + char(10)
        SET @p_dsql += 'SELECT ''P_RESULT_OUT_M'' AS CATEGORY_ID, ''M(P/C)'' AS MEASURE_NAME, ''Result(Out)'' AS CATEGORY_NAME, 370 AS CATEGORY_ORDER  '
                       + char(10)
        SET @p_dsql += 'UNION ALL ' + char(10)
        SET @p_dsql += 'SELECT ''P_RESULT_OUT_JR'' AS CATEGORY_ID, ''J/R'' AS MEASURE_NAME, ''Result(Out)'' AS CATEGORY_NAME, 360 AS CATEGORY_ORDER  '
                       + char(10)
        SET @p_dsql += 'UNION ALL ' + char(10)
        SET @p_dsql += 'SELECT ''P_RESULT_OUT_CELL'' AS CATEGORY_ID, ''Cell'' AS MEASURE_NAME, ''Result(Out)'' AS CATEGORY_NAME, 380 AS CATEGORY_ORDER  '
                       + char(10)
        SET @p_dsql += 'UNION ALL ' + char(10)
        SET @p_dsql += 'SELECT ''P_RESULT_OUT_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''Result(Out)'' AS CATEGORY_NAME, 350 AS CATEGORY_ORDER  '
                       + char(10)
        SET @p_dsql += 'UNION ALL' + char(10)
        SET @p_dsql += 'SELECT ''P_ENGINE_IN_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''Engine(In)'' AS CATEGORY_NAME, 9.1 AS CATEGORY_ORDER'
                       + char(10)
        SET @p_dsql += 'UNION ALL' + char(10)
        SET @p_dsql += 'SELECT ''P_ENGINE_IN_JR'' AS CATEGORY_ID, ''J/R'' AS MEASURE_NAME, ''Engine(In)'' AS CATEGORY_NAME, 9.2 AS CATEGORY_ORDER'
                       + char(10)
        SET @p_dsql += 'UNION ALL' + char(10)
        SET @p_dsql += 'SELECT ''P_ENGINE_IN_M'' AS CATEGORY_ID, ''M(P/C)'' AS MEASURE_NAME,  ''Engine(In)'' AS CATEGORY_NAME, 9.3 AS CATEGORY_ORDER'
                       + char(10)
        SET @p_dsql += 'UNION ALL' + char(10)
        SET @p_dsql += 'SELECT ''P_ENGINE_IN_CELL'' AS CATEGORY_ID, ''Cell'' AS MEASURE_NAME, ''Engine(In)'' AS CATEGORY_NAME, 9.4 AS CATEGORY_ORDER'
                       + char(10)
        SET @p_dsql += 'UNION ALL' + char(10)
        SET @p_dsql += 'SELECT ''P_ENGINE_OUT_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''Engine(Out)'' AS CATEGORY_NAME, 49.1 AS CATEGORY_ORDER'
                       + char(10)
        SET @p_dsql += 'UNION ALL' + char(10)
        SET @p_dsql += 'SELECT ''P_ENGINE_OUT_JR'' AS CATEGORY_ID, ''J/R'' AS MEASURE_NAME, ''Engine(Out)'' AS CATEGORY_NAME, 49.2 AS CATEGORY_ORDER'
                       + char(10)
        SET @p_dsql += 'UNION ALL' + char(10)
        SET @p_dsql += 'SELECT ''P_ENGINE_OUT_M'' AS CATEGORY_ID, ''M(P/C)'' AS MEASURE_NAME, ''Engine(Out)'' AS CATEGORY_NAME, 49.3 AS CATEGORY_ORDER'
                       + char(10)
        SET @p_dsql += 'UNION ALL' + char(10)
        SET @p_dsql += 'SELECT ''P_ENGINE_OUT_CELL'' AS CATEGORY_ID, ''Cell'' AS MEASURE_NAME, ''Engine(Out)'' AS CATEGORY_NAME, 49.4 AS CATEGORY_ORDER'
                       + char(10)
        SET @p_dsql += 'UNION ALL' + char(10)
        SET @p_dsql += 'SELECT ''P_MEMO'' AS CATEGORY_ID, '''' AS MEASURE_NAME, ''Memo'' AS CATEGORY_NAME, 600 AS CATEGORY_ORDER'
                       + char(10)
    END

   	IF ISNULL(@bSunWeek,'') = 'Y' BEGIN
		SET @WeekColumn = 'YYYYWW'
	END
   
   SET @o_dsql = ''
    SET @o_dsql += ' AND (  1=0 ' + char(10)

    IF @bmpp = 1
    BEGIN
        SET @o_dsql += ' OR ISNULL(A.MPP_IN_QTY_BATCH,0) <> 0 ' + char(10)
    END

    IF @bwpp = 1
    BEGIN
        SET @o_dsql += ' OR ISNULL(A.WPP_IN_QTY_BATCH,0) <> 0 ' + char(10)
    END

    IF @bdpp = 1
    BEGIN
        SET @o_dsql += ' OR ISNULL(A.ADJUST_IN_QTY_BATCH,0) <> 0 ' + char(10)
    END

    IF @bresult = 1
    BEGIN
        SET @o_dsql += ' OR ISNULL(A.RESULT_OUT_QTY_BATCH,0) <> 0 ' + char(10)
    END

    IF @bengine = 1
    BEGIN
        SET @o_dsql += ' OR ISNULL(A.PLAN_IN_QTY_BATCH,0) <> 0 ' + char(10)
    END

	DECLARE @create_tmp NVARCHAR(MAX)

	
	SET @create_tmp = N''
	SET @create_tmp += 'if object_id(''tempdb..#MAIN'') is not null ' + char(10)
	SET @create_tmp += '	DROP TABLE #MAIN ' + char(10) + char(10)

	SET @create_tmp+= N'	CREATE TABLE [dbo].[#MAIN]('+char(10)
	SET @create_tmp+= N'		[COMPANY_ID] [nvarchar](30) NOT NULL,'+char(10)
	SET @create_tmp+= N'		[DIVISION_ID] [nvarchar](30) NOT NULL,'+char(10)
	SET @create_tmp+= N'		[SITE_ID] [nvarchar](30) NOT NULL,'+char(10)
	SET @create_tmp+= N'		[PLANT_ID] [nvarchar](30) NOT NULL,'+char(10)
	SET @create_tmp+= N'		[FACTORY_ID] [nvarchar](30) NOT NULL,'+char(10)
	SET @create_tmp+= N'		[LOCATION] [nvarchar](30) NOT NULL,'+char(10)
	SET @create_tmp+= N'		[OPERATION_ID] [nvarchar](30) NOT NULL,'+char(10)
	SET @create_tmp+= N'		[LINE_ID] [nvarchar](30) NOT NULL,'+char(10)
	SET @create_tmp+= N'		[LINE_NAME] [nvarchar](150) NOT NULL,'+char(10)
	SET @create_tmp+= N'		[ELECTRODE_TYPE] [nvarchar](30) NOT NULL,'+char(10)
	SET @create_tmp+= N'		[EQUIPMENT_ID] [nvarchar](30) NOT NULL,'+char(10)
	SET @create_tmp+= N'		[ITEM_ID] [nvarchar](150) NOT NULL,'+char(10)
	SET @create_tmp+= N'		[TOP_ITEM_ID] [nvarchar](150) NOT NULL,'+char(10)
	SET @create_tmp+= N'		[NICK_NAME] [nvarchar](50) NOT NULL,'+char(10)
	SET @create_tmp+= N'		[PRODUCTION_TYPE] [nvarchar](30) NOT NULL,'+char(10)
	SET @create_tmp+= N'		[MARKET] [nvarchar](30) NOT NULL,'+char(10)
	SET @create_tmp+= N'		[BATCH_ID] [nvarchar](150) NULL,'+char(10)
	SET @create_tmp+= N'		[BATCH_ID_2] [nvarchar](150) NULL,'+char(10)
	SET @create_tmp+= N'		[PRE_DISPERSION_ID] [nvarchar](150) NULL,'+char(10)
	SET @create_tmp+= N'		[PRE_DISPERSION_NAME] [nvarchar](509) NULL,'+char(10)
	SET @create_tmp+= N'		[PRE_DISPERSION_ID_2] [nvarchar](150) NULL,'+char(10)
	SET @create_tmp+= N'		[PRE_DISPERSION_NAME_2] [nvarchar](509) NULL,'+char(10)
	SET @create_tmp+= N'		[ACTIVE_MATERIAL_1] [nvarchar](509) NULL,'+char(10)
	SET @create_tmp+= N'		[ACTIVE_MATERIAL_2] [nvarchar](509) NULL,'+char(10)
	SET @create_tmp+= N'		[ACTIVE_MATERIAL_3] [nvarchar](509) NULL,'+char(10)
	SET @create_tmp+= N'		[BINDER_1] [nvarchar](509) NULL,'+char(10)
	SET @create_tmp+= N'		[BINDER_2] [nvarchar](509) NULL,'+char(10)
	SET @create_tmp+= N'		[BINDER_3] [nvarchar](509) NULL,'+char(10)
	SET @create_tmp+= N'		[CMC] [nvarchar](509) NULL,'+char(10)
	SET @create_tmp+= N'		[VERSION] [nvarchar](10) NULL,'+char(10)
	SET @create_tmp+= N'		[PC_MODEL_ID] [nvarchar](150) NULL,'+char(10)
	SET @create_tmp+= N'		[ADDITION_AGENT] [nvarchar](509) NULL,'+char(10)
	SET @create_tmp+= N'		[FOIL_CODE] [nvarchar](150) NULL,'+char(10)
	SET @create_tmp+= N'		[FOIL] [nvarchar](150) NULL,'+char(10)
	SET @create_tmp+= N'		[DC_PPM] [numeric](25, 19) NULL,'+char(10)
	SET @create_tmp+= N'		[DC_M] [numeric](20, 10) NULL,'+char(10)
	SET @create_tmp+= N'		[DC_CELL] [numeric](20, 10) NULL,'+char(10)
	SET @create_tmp+= N'		[DC_KG] [numeric](20, 10) NULL,'+char(10)
	SET @create_tmp+= N'		[DC_JR] [numeric](20, 10) NULL,'+char(10)
	SET @create_tmp+= N'		[DC_BATCH] [numeric](20, 10) NULL,'+char(10)
	SET @create_tmp+= N'		[DC_FLAG] [nvarchar](1) NULL,'+char(10)


    SET @p_day_info = @p_bucket
    IF isnull(@p_day_info, '') <> ''
    BEGIN
        SET @mst_loop_cnt = 0
        SET @v_delimiter = '!' -- 데이터 구분자    
        SET @sub_v_delimiter = '#'
        SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)

        -- 프로시저 LOOP 길이를 판단    
        IF @max_loop_cnt > 0
        BEGIN
            -- monthinfo    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_month_info, @v_delimiter)

            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_month_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

				SET @create_tmp += '		[M' + try_convert(nvarchar, @mst_loop_cnt - 1) + '] [numeric](38, 10) NULL,'+char(10)
				SET @create_tmp += '		[M' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_CR] [varchar](20) NULL,'+char(10)

            --SET @mst_loop_cnt =  @mst_loop_cnt + 1    
            END -- end of @mst_loop_cnt < @max_loop_cnt    

            -- weekinfo    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_week_info, @v_delimiter)

            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_week_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

				SET @create_tmp += '		[W' + try_convert(nvarchar, @mst_loop_cnt - 1) + '] [numeric](38, 10) NULL,'+char(10)
				SET @create_tmp += '		[W' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_CR] [varchar](20) NULL,'+char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    

            -- bucket    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)

            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_day_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

				SET @create_tmp += '		[D' + try_convert(nvarchar, @mst_loop_cnt - 1) + '] [numeric](38, 10) NULL,'+char(10)
				SET @create_tmp += '		[D' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_CR] [varchar](20) NULL,'+char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    
        END --end of @max_loop_cnt    
    END -- end of isnull(@p_day_info,'') <> ''    

	SET @create_tmp+= N'		[CATEGORY_NAME] [varchar](11) NOT NULL,'+char(10)
	SET @create_tmp+= N'		[CATEGORY_ID] [varchar](18) NOT NULL,'+char(10)
	SET @create_tmp+= N'		[CATEGORY_ORDER] [numeric](4, 1) NOT NULL,'+char(10)
	SET @create_tmp+= N'		[MEASURE_NAME] [varchar](6) NOT NULL,'+char(10)
	SET @create_tmp+= N'		[DATA_TYPE] [varchar](4) NOT NULL,'+char(10)
	SET @create_tmp+= N'		[LINE_SEQ] [bigint] NOT NULL,'+char(10)
	SET @create_tmp+= N'		[DPP_OMIT_ZERO] [varchar](1) NOT NULL,'+char(10)
	SET @create_tmp+= N'		[MPP_OMIT_ZERO] [varchar](1) NOT NULL,'+char(10)
	SET @create_tmp+= N'		[WPP_OMIT_ZERO] [varchar](1) NOT NULL,'+char(10)
	SET @create_tmp+= N'		[RESULT_OMIT_ZERO] [varchar](1) NOT NULL,'+char(10)
	SET @create_tmp+= N'		[CALC_TYPE] [nvarchar](10) NULL,'+char(10)
	SET @create_tmp+= N'		[PROD_SEQ] [nvarchar](50) NULL,'+char(10)
	SET @create_tmp+= N'		[PLM_EC_NO] [nvarchar](50) NULL '+char(10)
	SET @create_tmp+= N'	)'+char(10)


    SET @o_dsql += ')' + char(10)
    --END    
    --END    
    SET @v_dsql = ''
	SET @v_dsql += @create_tmp
    --SET @v_dsql += '      WITH MAIN AS (' + char(10)
	SET @v_dsql += '      INSERT INTO #MAIN' + char(10)
    SET @v_dsql += '       SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + char(10)
    SET @v_dsql += '                , A.LOCATION, A.OPERATION_ID' + char(10)
    SET @v_dsql += '                , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE' + char(10)
    SET @v_dsql += '                , A.EQUIPMENT_ID' + char(10)
    SET @v_dsql += '                , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME' + char(10)
    SET @v_dsql += '                , A.PRODUCTION_TYPE, A.MARKET' + char(10)
	SET @v_dsql += '                , E.SLURRY_1 AS BATCH_ID, E.SLURRY_2 AS BATCH_ID_2 ' + char(10)
	SET @v_dsql += '                , E.PRE_DISPERSION_ID AS PRE_DISPERSION_ID ' + char(10)
	SET @v_dsql += '                , E.PRE_DISPERSION_NAME AS PRE_DISPERSION_NAME ' + char(10)
	SET @v_dsql += '                , E.PRE_DISPERSION_ID_2 AS PRE_DISPERSION_ID_2 ' + char(10)
	SET @v_dsql += '                , E.PRE_DISPERSION_NAME_2 AS PRE_DISPERSION_NAME_2 ' + char(10)
	SET @v_dsql += '                , E.ACTIVE_MATERIAL_1 AS ACTIVE_MATERIAL_1 ' + char(10)
	SET @v_dsql += '                , E.ACTIVE_MATERIAL_2 AS ACTIVE_MATERIAL_2 ' + char(10)
	SET @v_dsql += '                , E.ACTIVE_MATERIAL_3 AS ACTIVE_MATERIAL_3 ' + char(10)
	SET @v_dsql += '                , E.BINDER_1 AS BINDER_1 ' + char(10)
	SET @v_dsql += '                , E.BINDER_2 AS BINDER_2 ' + char(10)
	SET @v_dsql += '                , E.BINDER_3 AS BINDER_3 ' + char(10)
	SET @v_dsql += '                , E.CMC ' + char(10)
	SET @v_dsql += '                , A.VERSION ' + char(10)
	SET @v_dsql += '                , A.WORK_REQUEST_MODEL_ID AS PC_MODEL_ID ' + char(10)
	SET @v_dsql += '                , E.ADDITION_AGENT AS ADDITION_AGENT ' + char(10)
	/*
    SET @v_dsql += '                , ISNULL(E.SLURRY_1,F.SLURRY_1) AS BATCH_ID, ISNULL(E.SLURRY_2,F.SLURRY_2) AS BATCH_ID_2' + char(10)
    SET @v_dsql += '                , ISNULL(E.PRE_DISPERSION_ID,F.PRE_DISPERSION_ID) AS PRE_DISPERSION_ID' + char(10)
    SET @v_dsql += '               , ISNULL(E.PRE_DISPERSION_NAME,F.PRE_DISPERSION_NAME) AS PRE_DISPERSION_NAME' + char(10)
    SET @v_dsql += '                , ISNULL(E.PRE_DISPERSION_ID_2,F.PRE_DISPERSION_ID_2) AS PRE_DISPERSION_ID_2' + char(10)
    SET @v_dsql += '               , ISNULL(E.PRE_DISPERSION_NAME_2,F.PRE_DISPERSION_NAME_2) AS PRE_DISPERSION_NAME_2' + char(10)
    SET @v_dsql += '                   , ISNULL(E.ACTIVE_MATERIAL_1,F.ACTIVE_MATERIAL_1) AS ACTIVE_MATERIAL_1' + char(10)
    SET @v_dsql += '                   , ISNULL(E.ACTIVE_MATERIAL_2,F.ACTIVE_MATERIAL_2) AS ACTIVE_MATERIAL_2' + char(10)
    SET @v_dsql += '                   , ISNULL(E.ACTIVE_MATERIAL_3,F.ACTIVE_MATERIAL_3) AS ACTIVE_MATERIAL_3' + char(10)
    SET @v_dsql += '                   , ISNULL(E.BINDER_1,F.BINDER_1) AS BINDER_1' + char(10)
    SET @v_dsql += '                   , ISNULL(E.BINDER_2,F.BINDER_2) AS BINDER_2' + char(10)
    SET @v_dsql += '                   , ISNULL(E.BINDER_3,F.BINDER_3) AS BINDER_3' + char(10)
    SET @v_dsql += '                   , ISNULL(E.CMC,F.CMC) AS CMC' + char(10)
    SET @v_dsql += '                   , A.VERSION' + char(10)
    SET @v_dsql += '                   , ISNULL(E.MODEL_ID,F.MODEL_ID) AS PC_MODEL_ID' + char(10)
    SET @v_dsql += '                   , ISNULL(E.ADDITION_AGENT,F.ADDITION_AGENT) AS ADDITION_AGENT' + char(10) -- 첨가재 정보 추가... 20210114    
	*/
    SET @v_dsql += '                   , ISNULL(G.FOIL_CODE, dbo.FN_GET_FOIL(A.FACTORY_ID, A.ITEM_ID, A.PROD_VERSION_TYPE, ''FOIL_CODE'')) AS FOIL_CODE' + char(10)
    SET @v_dsql += '                   , ISNULL(G.FOIL, dbo.FN_GET_FOIL(A.FACTORY_ID, A.ITEM_ID,A.PROD_VERSION_TYPE, ''FOIL'')) AS FOIL' + char(10)
    SET @v_dsql += '                   , Z.DAILY_CAPA_PPM  AS DC_PPM' + char(10)
	/*
    SET @v_dsql += '                   , ISNULL(D.DAILY_CAPA_M, H.DAILY_CAPA_M) AS DC_M' + char(10)
    SET @v_dsql += '                   , ISNULL(D.DAILY_CAPA_EA, H.DAILY_CAPA_EA) AS DC_CELL' + char(10)
    SET @v_dsql += '                   , ISNULL(D.DAILY_CAPA_KG, H.DAILY_CAPA_KG) AS DC_KG' + char(10)
    SET @v_dsql += '                   , ISNULL(D.DAILY_CAPA_JR, H.DAILY_CAPA_JR) AS DC_JR' + char(10)
    SET @v_dsql += '                   , ISNULL(D.DAILY_CAPA_BATCH, H.DAILY_CAPA_BATCH) AS DC_BATCH' + char(10)
    SET @v_dsql += '                   , CASE WHEN A.TOP_ITEM_ID=''NONE'' THEN ''N'' ELSE ISNULL(D.DC_FLAG, H.DC_FLAG) END AS DC_FLAG' + char(10)
	*/
    SET @v_dsql += '                   , D.DAILY_CAPA_M AS DC_M' + char(10)
    SET @v_dsql += '                   , D.DAILY_CAPA_EA AS DC_CELL' + char(10)
    SET @v_dsql += '                   , D.DAILY_CAPA_KG AS DC_KG' + char(10)
    SET @v_dsql += '                   , D.DAILY_CAPA_JR AS DC_JR' + char(10)
    SET @v_dsql += '                   , D.DAILY_CAPA_BATCH AS DC_BATCH' + char(10)
    SET @v_dsql += '                   , CASE WHEN A.TOP_ITEM_ID=''NONE'' THEN ''N'' ELSE D.DC_FLAG END AS DC_FLAG'+ char(10)
    SET @p_day_info = @p_bucket

    IF isnull(@p_day_info, '') <> ''
    BEGIN
        SET @mst_loop_cnt = 0
        SET @v_delimiter = '!' -- 데이터 구분자    
        SET @sub_v_delimiter = '#'
        SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)

        -- 프로시저 LOOP 길이를 판단    
        IF @max_loop_cnt > 0
        BEGIN
            -- monthinfo    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_month_info, @v_delimiter)

            -- 프로시저 LOOP 길이를 판단    
            --SET @v_dSql += '   ### MAX LOOP COUNT %%%'+TRY_CONVERT(NVARCHAR, @max_loop_cnt) +char(10)    
            --SET @v_dSql += @p_MONTH_INFO  +char(10)    
            --SET @v_dSql += '  KKKKKKKKKK ### MAX LOOP COUNT %%%'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)    
            --SET @v_dSql += '   ### MAX LOOP COUNT %%%'+@in_columns +char(10)    
            --SET @v_dSql += '   ### MAX LOOP COUNT %%%'+@in_row +char(10)    
            --SET @v_dSql += '   ### MAX LOOP COUNT %%%'+@p_MONTH_INFO +char(10)    
            --SET @v_dSql += '   ### MAX LOOP COUNT %%%'+@v_MONTH_INFO +char(10)    
            --SET @v_dSql += '   ### MAX LOOP COUNT %%%'+@v_delimiter +char(10)    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_month_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                IF @sub_max_loop_cnt > 4
                BEGIN
                    SET @sub_param_4 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 5)
                END

                -- //SAMPLE SET @v_dSql += '               , NULL AS M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)    
                SET @v_dsql += '               , M' + try_convert(nvarchar, @mst_loop_cnt - 1) + char(10)
                SET @v_dsql += '               , M' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_CR' + char(10)
            --SET @mst_loop_cnt =  @mst_loop_cnt + 1    
            END -- end of @mst_loop_cnt < @max_loop_cnt    

            -- weekinfo    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_week_info, @v_delimiter)

            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_week_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                IF @sub_max_loop_cnt > 4
                BEGIN
                    SET @sub_param_4 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 5)
                END

                -- @sub_param_0 => WEEK    
                -- @sub_param_0 => WEEK_NAME    
                -- @sub_param_0 => WEEK_COUNT    
                -- @sub_param_0 => W_VALUE    
                -- @sub_param_0 => IS_DAY_VIEW        
                SET @v_dsql += '               , W' + try_convert(nvarchar, @mst_loop_cnt - 1) + char(10)
                SET @v_dsql += '               , W' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_CR' + char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    

            -- bucket    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)

            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_day_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                --IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END    
                -- @sub_param_0 => MONth    
                -- @sub_param_0 => MONTH_NAME    
                -- @sub_param_0 => MONTH_COUNT    
                -- @sub_param_0 => M_VALUE    
                --SET @v_dSql += @tmp_column + '+++++++ffgs+++++++++++++++++' +char(10)    
                --SET @v_dSql += @sub_param_3 + '+++++++ffgs+++++++++++++++++' +char(10)    
                --SET @v_dSql += @p_plan_date + '++++++++++++++++++++++++' +char(10)    
                -- SAMPLE SET @v_dSql += '               , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_PLAN_DATE + ''' THEN ( CASE   WHEN B.CATEGORY_ID = ''I'' THEN A.EOH_QTY '+ char(10)    
                SET @v_dsql += '               , D' + try_convert(nvarchar, @mst_loop_cnt - 1) + char(10)
                SET @v_dsql += '               , D' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_CR' + char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    
        END --end of @max_loop_cnt    
    END -- end of isnull(@p_day_info,'') <> ''    

    SET @v_dsql += '                  , A.CATEGORY_NAME' + char(10)
    SET @v_dsql += '                  , A.CATEGORY_ID' + char(10)
    SET @v_dsql += '                  , A.CATEGORY_ORDER' + char(10)
    SET @v_dsql += '                  , A.MEASURE_NAME' + char(10)
    SET @v_dsql += '                  , A.DATA_TYPE' + char(10)
    SET @v_dsql += '                  , ISNULL(B.LINE_SEQ, 9999) LINE_SEQ' + char(10)
    SET @v_dsql += '                  , A.DPP_OMIT_ZERO, A.MPP_OMIT_ZERO, A.WPP_OMIT_ZERO, A.RESULT_OMIT_ZERO' + char(10)
    SET @v_dsql += '                  , A.CALC_TYPE' + char(10)
    SET @v_dsql += '                  , A.PROD_SEQ' + char(10)
	SET @v_dsql += '                  , A.PLM_EC_NO' + char(10)
    SET @v_dsql += '       FROM (' + char(10)
    SET @v_dsql += '           SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + char(10)
    SET @v_dsql += '                , A.LOCATION, A.OPERATION_ID' + char(10)
    SET @v_dsql += '                , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE' + char(10)
    SET @v_dsql += '                , A.EQUIPMENT_ID' + char(10)
    SET @v_dsql += '                , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME' + char(10)
    SET @v_dsql += '                , A.PRODUCTION_TYPE, A.MARKET, A.PROD_VERSION_TYPE' + char(10)

    IF isnull(@p_day_info, '') <> ''
    BEGIN
        SET @mst_loop_cnt = 0
        SET @v_delimiter = '!' -- 데이터 구분자    
        SET @sub_v_delimiter = '#'
        SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)

        -- 프로시저 LOOP 길이를 판단    
        IF @max_loop_cnt > 0
        BEGIN
            -- monthinfo    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_month_info, @v_delimiter)

            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_month_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END --MONTH    
                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END --MONTH_NAME    
                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END --MONTH_COUNT    
                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END --M_VALUE    
                IF @sub_max_loop_cnt > 4
                BEGIN
                    SET @sub_param_4 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 5)
                END

                -- @sub_param_0 => MONth    
                -- @sub_param_0 => MONTH_NAME    
                -- @sub_param_0 => MONTH_COUNT    
                -- @sub_param_0 => M_VALUE    
                -- //SAMPLE SET @v_dSql += '               , NULL AS M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)    
                --SET @v_dSql += '               , M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + '_M' + char(10)    
                SET @v_dsql += '               , SUM(CASE WHEN C.YYYYMM=''' + @sub_param_0
                               + ''' THEN (CASE WHEN B.CATEGORY_ID=''P_IN_M'' THEN CEILING(A.ADJUST_IN_QTY_M) '
                               + char(10)
                SET @v_dsql += '                                                               WHEN B.CATEGORY_ID=''P_IN_JR'' THEN CEILING(A.ADJUST_IN_QTY_JR) '
                               + char(10)
                SET @v_dsql += '                                                               WHEN B.CATEGORY_ID=''P_IN_CELL'' THEN CEILING(A.ADJUST_IN_QTY_CELL) '
                               + char(10)
                SET @v_dsql += '                                                               WHEN B.CATEGORY_ID=''P_IN_BATCH'' THEN ROUND(A.ADJUST_IN_QTY_BATCH,'
                               + @v_round_point + ') ' + char(10)
                SET @v_dsql += '                                                               WHEN B.CATEGORY_ID=''P_OUT_M'' THEN CEILING(A.ADJUST_OUT_QTY_M) '
                               + char(10)
                SET @v_dsql += '                                                               WHEN B.CATEGORY_ID=''P_OUT_JR'' THEN CEILING(A.ADJUST_OUT_QTY_JR) '
                               + char(10)
                SET @v_dsql += '                                                               WHEN B.CATEGORY_ID=''P_OUT_CELL'' THEN CEILING(A.ADJUST_OUT_QTY_CELL) '
                               + char(10)
                SET @v_dsql += '                                                               WHEN B.CATEGORY_ID=''P_OUT_BATCH'' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,'
                               + @v_round_point + ') ' + char(10)
                --    
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_MPP_IN_M'' THEN CEILING(A.MPP_IN_QTY_M) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_MPP_IN_JR'' THEN CEILING(A.MPP_IN_QTY_JR) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_MPP_IN_CELL'' THEN CEILING(A.MPP_IN_QTY_CELL) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_MPP_IN_BATCH'' THEN ROUND(A.MPP_IN_QTY_BATCH,'
                               + @v_round_point + ') ' + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_MPP_OUT_M'' THEN CEILING(A.MPP_OUT_QTY_M) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_MPP_OUT_JR'' THEN CEILING(A.MPP_OUT_QTY_JR) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_MPP_OUT_CELL'' THEN CEILING(A.MPP_OUT_QTY_CELL) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_MPP_OUT_BATCH'' THEN ROUND(A.MPP_OUT_QTY_BATCH,'
                               + @v_round_point + ') ' + char(10)
                --    
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_WPP_IN_M'' THEN CEILING(A.WPP_IN_QTY_M) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_WPP_IN_JR'' THEN CEILING(A.WPP_IN_QTY_JR) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_WPP_IN_CELL'' THEN CEILING(A.WPP_IN_QTY_CELL) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_WPP_IN_BATCH'' THEN ROUND(A.WPP_IN_QTY_BATCH,'
                               + @v_round_point + ') ' + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_WPP_OUT_M'' THEN CEILING(A.WPP_OUT_QTY_M) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_WPP_OUT_JR'' THEN CEILING(A.WPP_OUT_QTY_JR) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_WPP_OUT_CELL'' THEN CEILING(A.WPP_OUT_QTY_CELL) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_WPP_OUT_BATCH'' THEN ROUND(A.WPP_OUT_QTY_BATCH,'
                               + @v_round_point + ') ' + char(10)
                --    
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_RESULT_IN_M''THEN CEILING(A.RESULT_IN_QTY_M) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_RESULT_IN_JR'' THEN CEILING(A.RESULT_IN_QTY_JR) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_RESULT_IN_CELL'' THEN CEILING(A.RESULT_IN_QTY_CELL) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_RESULT_IN_BATCH'' THEN ROUND(A.RESULT_IN_QTY_BATCH,'
                               + @v_round_point + ') ' + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_RESULT_OUT_M'' THEN CEILING(A.RESULT_OUT_QTY_M) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_RESULT_OUT_JR'' THEN CEILING(A.RESULT_OUT_QTY_JR) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_RESULT_OUT_CELL'' THEN CEILING(A.RESULT_OUT_QTY_CELL) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_RESULT_OUT_BATCH'' THEN ROUND(A.RESULT_OUT_QTY_BATCH,'
                               + @v_round_point + ') ' + char(10)
                --    
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_ENGINE_IN_BATCH'' THEN ROUND(A.PLAN_IN_QTY_BATCH,'
                               + @v_round_point + ') ' + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_ENGINE_IN_JR'' THEN CEILING(A.PLAN_IN_QTY_JR) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_ENGINE_IN_M'' THEN CEILING(A.PLAN_IN_QTY_M) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_ENGINE_IN_CELL'' THEN CEILING(A.PLAN_IN_QTY_CELL) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_ENGINE_OUT_BATCH'' THEN ROUND(A.PLAN_OUT_QTY_BATCH,'
                               + @v_round_point + ') ' + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_ENGINE_OUT_JR'' THEN CEILING(A.PLAN_OUT_QTY_JR) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_ENGINE_OUT_M'' THEN CEILING(A.PLAN_OUT_QTY_M) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_ENGINE_OUT_CELL'' THEN CEILING(A.PLAN_OUT_QTY_CELL) '
                               + char(10)
                --    
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_SEQ'' THEN NULL '
                               + char(10)
                SET @v_dsql += '                                                               ELSE 0 END) ELSE 0 END) AS M'
                               + try_convert(nvarchar, @mst_loop_cnt - 1) + char(10)
                SET @v_dsql += '               , NULL AS M' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_CR '
                               + char(10)
            --SET @mst_loop_cnt =  @mst_loop_cnt + 1    
            END -- end of @mst_loop_cnt < @max_loop_cnt    

            -- weekinfo    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_week_info, @v_delimiter)

            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_week_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                IF @sub_max_loop_cnt > 4
                BEGIN
                    SET @sub_param_4 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 5)
                END

                -- @sub_param_0 => WEEK    
                -- @sub_param_0 => WEEK_NAME    
                -- @sub_param_0 => WEEK_COUNT    
                -- @sub_param_0 => W_VALUE    
                -- @sub_param_0 => IS_DAY_VIEW        
                SET @v_dsql += '               , SUM(CASE WHEN C.' + @WeekColumn + '=''' + @sub_param_0
                               + ''' THEN (CASE WHEN B.CATEGORY_ID=''P_IN_M'' THEN CEILING(A.ADJUST_IN_QTY_M)'
                               + char(10)
                SET @v_dsql += '                                                               WHEN B.CATEGORY_ID=''P_IN_JR'' THEN CEILING(A.ADJUST_IN_QTY_JR)'
                               + char(10)
                SET @v_dsql += '                                                               WHEN B.CATEGORY_ID=''P_IN_CELL'' THEN CEILING(A.ADJUST_IN_QTY_CELL)'
                               + char(10)
                SET @v_dsql += '                                                               WHEN B.CATEGORY_ID=''P_IN_BATCH'' THEN ROUND(A.ADJUST_IN_QTY_BATCH,'
                               + @v_round_point + ')' + char(10)
                SET @v_dsql += '                                                               WHEN B.CATEGORY_ID=''P_OUT_M'' THEN CEILING(A.ADJUST_OUT_QTY_M)'
                               + char(10)
                SET @v_dsql += '                                                               WHEN B.CATEGORY_ID=''P_OUT_JR'' THEN CEILING(A.ADJUST_OUT_QTY_JR)'
                               + char(10)
                SET @v_dsql += '                                                               WHEN B.CATEGORY_ID=''P_OUT_CELL'' THEN CEILING(A.ADJUST_OUT_QTY_CELL)'
                               + char(10)
                SET @v_dsql += '                                                               WHEN B.CATEGORY_ID=''P_OUT_BATCH'' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,'
                               + @v_round_point + ')' + char(10)
                --    
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_MPP_IN_M'' THEN CEILING(A.MPP_IN_QTY_M)'
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_MPP_IN_JR'' THEN CEILING(A.MPP_IN_QTY_JR)'
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_MPP_IN_CELL'' THEN CEILING(A.MPP_IN_QTY_CELL)'
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_MPP_IN_BATCH'' THEN ROUND(A.MPP_IN_QTY_BATCH,'
                               + @v_round_point + ')' + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_MPP_OUT_M'' THEN CEILING(A.MPP_OUT_QTY_M)'
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_MPP_OUT_JR'' THEN CEILING(A.MPP_OUT_QTY_JR)'
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_MPP_OUT_CELL'' THEN CEILING(A.MPP_OUT_QTY_CELL)'
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_MPP_OUT_BATCH'' THEN ROUND(A.MPP_OUT_QTY_BATCH,'
                               + @v_round_point + ')' + char(10)
                --    
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_WPP_IN_M'' THEN CEILING(A.WPP_IN_QTY_M)'
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_WPP_IN_JR'' THEN CEILING(A.WPP_IN_QTY_JR)'
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_WPP_IN_CELL'' THEN CEILING(A.WPP_IN_QTY_CELL)'
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_WPP_IN_BATCH'' THEN ROUND(A.WPP_IN_QTY_BATCH,'
                               + @v_round_point + ')' + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_WPP_OUT_M'' THEN CEILING(A.WPP_OUT_QTY_M)'
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_WPP_OUT_JR'' THEN CEILING(A.WPP_OUT_QTY_JR)'
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_WPP_OUT_CELL'' THEN CEILING(A.WPP_OUT_QTY_CELL)'
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_WPP_OUT_BATCH'' THEN ROUND(A.WPP_OUT_QTY_BATCH,'
                               + @v_round_point + ')' + char(10)
                --    
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_RESULT_IN_M'' THEN CEILING(A.RESULT_IN_QTY_M)'
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_RESULT_IN_JR'' THEN CEILING(A.RESULT_IN_QTY_JR)'
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_RESULT_IN_CELL'' THEN CEILING(A.RESULT_IN_QTY_CELL)'
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_RESULT_IN_BATCH'' THEN ROUND(A.RESULT_IN_QTY_BATCH,'
                               + @v_round_point + ')' + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_RESULT_OUT_M'' THEN CEILING(A.RESULT_OUT_QTY_M)'
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_RESULT_OUT_JR'' THEN CEILING(A.RESULT_OUT_QTY_JR)'
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_RESULT_OUT_CELL'' THEN CEILING(A.RESULT_OUT_QTY_CELL)'
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_RESULT_OUT_BATCH'' THEN ROUND(A.RESULT_OUT_QTY_BATCH,'
                               + @v_round_point + ')' + char(10)
                --    
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_ENGINE_IN_BATCH'' THEN ROUND(A.PLAN_IN_QTY_BATCH,'
                               + @v_round_point + ')' + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_ENGINE_IN_JR'' THEN CEILING(A.PLAN_IN_QTY_JR)'
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_ENGINE_IN_M'' THEN CEILING(A.PLAN_IN_QTY_M)'
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_ENGINE_IN_CELL'' THEN CEILING(A.PLAN_IN_QTY_CELL)'
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_ENGINE_OUT_BATCH'' THEN ROUND(A.PLAN_OUT_QTY_BATCH,'
                               + @v_round_point + ')' + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_ENGINE_OUT_JR'' THEN CEILING(A.PLAN_OUT_QTY_JR)'
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_ENGINE_OUT_M'' THEN CEILING(A.PLAN_OUT_QTY_M)'
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_ENGINE_OUT_CELL'' THEN CEILING(A.PLAN_OUT_QTY_CELL)'
                               + char(10)
                --    
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_SEQ'' THEN NULL'
                               + char(10)
                SET @v_dsql += '                                                               ELSE 0 END) ELSE 0 END) AS W'
                               + try_convert(nvarchar, @mst_loop_cnt - 1) + char(10)
                SET @v_dsql += '               , NULL AS W' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_CR'
                               + char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    

            -- bucket    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)

            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_day_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                --IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END    
                -- @sub_param_0 => MONth    
                -- @sub_param_0 => MONTH_NAME    
                -- @sub_param_0 => MONTH_COUNT    
                -- @sub_param_0 => M_VALUE    
                --SET @v_dSql += @tmp_column + '+++++++ffgs+++++++++++++++++' +char(10)    
                --SET @v_dSql += @sub_param_3 + '+++++++ffgs+++++++++++++++++' +char(10)    
                --SET @v_dSql += @p_plan_date + '++++++++++++++++++++++++' +char(10)    
                -- SAMPLE SET @v_dSql += '               , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_PLAN_DATE + ''' THEN ( CASE   WHEN B.CATEGORY_ID = ''I'' THEN A.EOH_QTY '+ char(10)    
                SET @v_dsql += '               , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)=''' + @sub_param_0
                               + ''' THEN (CASE WHEN B.CATEGORY_ID=''P_IN_M'' THEN CEILING(A.ADJUST_IN_QTY_M) '
                               + char(10)
                SET @v_dsql += '                                                               WHEN B.CATEGORY_ID=''P_IN_JR'' THEN CEILING(A.ADJUST_IN_QTY_JR) '
                               + char(10)
                SET @v_dsql += '                                                               WHEN B.CATEGORY_ID=''P_IN_CELL'' THEN CEILING(A.ADJUST_IN_QTY_CELL) '
                               + char(10)
                SET @v_dsql += '                                                               WHEN B.CATEGORY_ID=''P_IN_BATCH'' THEN ROUND(A.ADJUST_IN_QTY_BATCH,'
                               + @v_round_point + ') ' + char(10)
                SET @v_dsql += '                                                               WHEN B.CATEGORY_ID=''P_OUT_M'' THEN CEILING(A.ADJUST_OUT_QTY_M) '
                               + char(10)
                SET @v_dsql += '                                                               WHEN B.CATEGORY_ID=''P_OUT_JR'' THEN CEILING(A.ADJUST_OUT_QTY_JR) '
                               + char(10)
                SET @v_dsql += '                                                               WHEN B.CATEGORY_ID=''P_OUT_CELL'' THEN CEILING(A.ADJUST_OUT_QTY_CELL) '
                               + char(10)
                SET @v_dsql += '                                                               WHEN B.CATEGORY_ID=''P_OUT_BATCH'' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,'
                               + @v_round_point + ') ' + char(10)
                --    
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_MPP_IN_M'' THEN CEILING(A.MPP_IN_QTY_M) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_MPP_IN_JR'' THEN CEILING(A.MPP_IN_QTY_JR) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_MPP_IN_CELL'' THEN CEILING(A.MPP_IN_QTY_CELL) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_MPP_IN_BATCH'' THEN ROUND(A.MPP_IN_QTY_BATCH,'
                               + @v_round_point + ') ' + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_MPP_OUT_M'' THEN CEILING(A.MPP_OUT_QTY_M) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_MPP_OUT_JR'' THEN CEILING(A.MPP_OUT_QTY_JR) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_MPP_OUT_CELL'' THEN CEILING(A.MPP_OUT_QTY_CELL) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_MPP_OUT_BATCH'' THEN ROUND(A.MPP_OUT_QTY_BATCH,'
                               + @v_round_point + ') ' + char(10)
                --    
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_WPP_IN_M'' THEN CEILING(A.WPP_IN_QTY_M) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_WPP_IN_JR'' THEN CEILING(A.WPP_IN_QTY_JR) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_WPP_IN_CELL'' THEN CEILING(A.WPP_IN_QTY_CELL) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_WPP_IN_BATCH'' THEN ROUND(A.WPP_IN_QTY_BATCH,'
                               + @v_round_point + ') ' + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_WPP_OUT_M'' THEN CEILING(A.WPP_OUT_QTY_M) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_WPP_OUT_JR'' THEN CEILING(A.WPP_OUT_QTY_JR) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_WPP_OUT_CELL'' THEN CEILING(A.WPP_OUT_QTY_CELL) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_WPP_OUT_BATCH'' THEN ROUND(A.WPP_OUT_QTY_BATCH,'
                               + @v_round_point + ') ' + char(10)
                --    
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_RESULT_IN_M'' THEN CEILING(A.RESULT_IN_QTY_M) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_RESULT_IN_JR'' THEN CEILING(A.RESULT_IN_QTY_JR) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_RESULT_IN_CELL'' THEN CEILING(A.RESULT_IN_QTY_CELL) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_RESULT_IN_BATCH'' THEN ROUND(A.RESULT_IN_QTY_BATCH,'
                               + @v_round_point + ') ' + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_RESULT_OUT_M'' THEN CEILING(A.RESULT_OUT_QTY_M) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_RESULT_OUT_JR'' THEN CEILING(A.RESULT_OUT_QTY_JR) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_RESULT_OUT_CELL'' THEN CEILING(A.RESULT_OUT_QTY_CELL) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_RESULT_OUT_BATCH'' THEN ROUND(A.RESULT_OUT_QTY_BATCH,'
                               + @v_round_point + ') ' + char(10)
                --    
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_ENGINE_IN_BATCH'' THEN ROUND(A.PLAN_IN_QTY_BATCH,'
                               + @v_round_point + ') ' + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_ENGINE_IN_JR'' THEN CEILING(A.PLAN_IN_QTY_JR) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_ENGINE_IN_M'' THEN CEILING(A.PLAN_IN_QTY_M) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_ENGINE_IN_CELL'' THEN CEILING(A.PLAN_IN_QTY_CELL) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_ENGINE_OUT_BATCH'' THEN ROUND(A.PLAN_OUT_QTY_BATCH,'
                               + @v_round_point + ') ' + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_ENGINE_OUT_JR'' THEN CEILING(A.PLAN_OUT_QTY_JR) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_ENGINE_OUT_M'' THEN CEILING(A.PLAN_OUT_QTY_M) '
                               + char(10)
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_ENGINE_OUT_CELL'' THEN CEILING(A.PLAN_OUT_QTY_CELL) '
                               + char(10)
                --    
                SET @v_dsql += '                                                                                WHEN B.CATEGORY_ID=''P_SEQ'' THEN A.SEQ '
                               + char(10)
                SET @v_dsql += '                                                               ELSE 0 END) ELSE 0 END) AS D'
                               + try_convert(nvarchar, @mst_loop_cnt - 1) + char(10)
                SET @v_dsql += '               , NULL AS D' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_CR '
                               + char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    
        END --end of @max_loop_cnt    
    END -- end of isnull(@p_day_info,'') <> ''    

    SET @v_dsql += '                , B.CATEGORY_NAME' + char(10)
    SET @v_dsql += '                , B.CATEGORY_ID' + char(10)
    SET @v_dsql += '                , B.CATEGORY_ORDER' + char(10)
    SET @v_dsql += '                , B.MEASURE_NAME' + char(10)
    SET @v_dsql += '                , ''DATA'' AS DATA_TYPE' + char(10)
    SET @v_dsql += '                , CASE WHEN A.DPPTYPE = 0 AND ( PATINDEX( ''P_IN%'', B.CATEGORY_ID) > 0 OR  PATINDEX( ''P_OUT%'', B.CATEGORY_ID) > 0 ) THEN ''Y'' ELSE ''N'' END AS DPP_OMIT_ZERO' + char(10)
    SET @v_dsql += '                , CASE WHEN A.MPPTYPE = 0 AND ( PATINDEX( ''P_MPP%'', B.CATEGORY_ID) > 0 ) THEN ''Y'' ELSE ''N'' END AS MPP_OMIT_ZERO' + char(10)
    SET @v_dsql += '                , CASE WHEN A.WPPTYPE = 0 AND ( PATINDEX( ''P_WPP%'', B.CATEGORY_ID) > 0 ) THEN ''Y'' ELSE ''N'' END AS WPP_OMIT_ZERO' + char(10)
    SET @v_dsql += '                , CASE WHEN A.RESULTTYPE = 0 AND ( PATINDEX( ''P_RESULT%'', B.CATEGORY_ID) > 0 ) THEN ''Y'' ELSE ''N'' END AS RESULT_OMIT_ZERO' + char(10)
    SET @v_dsql += '                , A.CALC_TYPE' + char(10)
	SET @v_dsql += '                , A.PROD_SEQ, A.VERSION, A.WORK_REQUEST_MODEL_ID, A.PLM_EC_NO ' + char(10)
	------ Begin tuning block 1 ------- 
	SELECT @v_dsql += '	from (' + char(10)
	SELECT @v_dsql += '		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
	SELECT @v_dsql += '			, A.LOCATION, A.OPERATION_ID ' + char(10)
	SELECT @v_dsql += '			, A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
	SELECT @v_dsql += '			, A.EQUIPMENT_ID ' + char(10)
	SELECT @v_dsql += '			, A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME ' + char(10)
	SELECT @v_dsql += '			, A.PRODUCTION_TYPE, A.MARKET, A.PROD_VERSION_TYPE' + char(10)
	SELECT @v_dsql += '' + char(10)
	SELECT @v_dsql += '			,sum(CEILING(A.ADJUST_IN_QTY_M)) ADJUST_IN_QTY_M --1' + char(10)
	SELECT @v_dsql += '			,sum(CEILING(A.ADJUST_IN_QTY_JR)) ADJUST_IN_QTY_JR' + char(10)
	SELECT @v_dsql += '			,sum(CEILING(A.ADJUST_IN_QTY_CELL)) ADJUST_IN_QTY_CELL' + char(10)
	SELECT @v_dsql += '			,sum(ROUND(A.ADJUST_IN_QTY_BATCH,2)) ADJUST_IN_QTY_BATCH' + char(10)
	SELECT @v_dsql += '' + char(10)
	SELECT @v_dsql += '			,sum(CEILING(A.ADJUST_OUT_QTY_M)) ADJUST_OUT_QTY_M --2' + char(10)
	SELECT @v_dsql += '			,sum(CEILING(A.ADJUST_OUT_QTY_JR)) ADJUST_OUT_QTY_JR' + char(10)
	SELECT @v_dsql += '			,sum(CEILING(A.ADJUST_OUT_QTY_CELL)) ADJUST_OUT_QTY_CELL' + char(10)
	SELECT @v_dsql += '			,sum(ROUND(A.ADJUST_OUT_QTY_BATCH,2)) ADJUST_OUT_QTY_BATCH' + char(10)
	SELECT @v_dsql += '' + char(10)
	SELECT @v_dsql += '			,sum(CEILING(A.MPP_IN_QTY_M)) MPP_IN_QTY_M --3' + char(10)
	SELECT @v_dsql += '			,sum(CEILING(A.MPP_IN_QTY_JR)) MPP_IN_QTY_JR' + char(10)
	SELECT @v_dsql += '			,sum(CEILING(A.MPP_IN_QTY_CELL)) MPP_IN_QTY_CELL' + char(10)
	SELECT @v_dsql += '			,sum(ROUND(A.MPP_IN_QTY_BATCH,2)) MPP_IN_QTY_BATCH' + char(10)
	SELECT @v_dsql += '' + char(10)
	SELECT @v_dsql += '			,sum(CEILING(A.MPP_OUT_QTY_M)) MPP_OUT_QTY_M --4' + char(10)
	SELECT @v_dsql += '			,sum(CEILING(A.MPP_OUT_QTY_JR)) MPP_OUT_QTY_JR' + char(10)
	SELECT @v_dsql += '			,sum(CEILING(A.MPP_OUT_QTY_CELL)) MPP_OUT_QTY_CELL' + char(10)
	SELECT @v_dsql += '			,sum(ROUND(A.MPP_OUT_QTY_BATCH,2)) MPP_OUT_QTY_BATCH' + char(10)
	SELECT @v_dsql += '' + char(10)
	SELECT @v_dsql += '			,sum(CEILING(A.WPP_IN_QTY_M)) WPP_IN_QTY_M --5' + char(10)
	SELECT @v_dsql += '			,sum(CEILING(A.WPP_IN_QTY_JR)) WPP_IN_QTY_JR' + char(10)
	SELECT @v_dsql += '			,sum(CEILING(A.WPP_IN_QTY_CELL)) WPP_IN_QTY_CELL' + char(10)
	SELECT @v_dsql += '			,sum(ROUND(A.WPP_IN_QTY_BATCH,2)) WPP_IN_QTY_BATCH' + char(10)
	SELECT @v_dsql += '' + char(10)
	SELECT @v_dsql += '			,sum(CEILING(A.WPP_OUT_QTY_M)) WPP_OUT_QTY_M --6' + char(10)
	SELECT @v_dsql += '			,sum(CEILING(A.WPP_OUT_QTY_JR)) WPP_OUT_QTY_JR' + char(10)
	SELECT @v_dsql += '			,sum(CEILING(A.WPP_OUT_QTY_CELL)) WPP_OUT_QTY_CELL' + char(10)
	SELECT @v_dsql += '			,sum(ROUND(A.WPP_OUT_QTY_BATCH,2)) WPP_OUT_QTY_BATCH' + char(10)
	SELECT @v_dsql += '' + char(10)
	SELECT @v_dsql += '			,sum(CEILING(A.RESULT_IN_QTY_M)) RESULT_IN_QTY_M --7' + char(10)
	SELECT @v_dsql += '			,sum(CEILING(A.RESULT_IN_QTY_JR)) RESULT_IN_QTY_JR' + char(10)
	SELECT @v_dsql += '			,sum(CEILING(A.RESULT_IN_QTY_CELL)) RESULT_IN_QTY_CELL' + char(10)
	SELECT @v_dsql += '			,sum(ROUND(A.RESULT_IN_QTY_BATCH,2)) RESULT_IN_QTY_BATCH' + char(10)
	SELECT @v_dsql += '' + char(10)
	SELECT @v_dsql += '			,sum(CEILING(A.RESULT_OUT_QTY_M)) RESULT_OUT_QTY_M --8' + char(10)
	SELECT @v_dsql += '			,sum(CEILING(A.RESULT_OUT_QTY_JR)) RESULT_OUT_QTY_JR' + char(10)
	SELECT @v_dsql += '			,sum(CEILING(A.RESULT_OUT_QTY_CELL)) RESULT_OUT_QTY_CELL' + char(10)
	SELECT @v_dsql += '			,sum(ROUND(A.RESULT_OUT_QTY_BATCH,2)) RESULT_OUT_QTY_BATCH' + char(10)
	SELECT @v_dsql += '' + char(10)
	SELECT @v_dsql += '			,sum(ROUND(A.PLAN_IN_QTY_BATCH,2)) PLAN_IN_QTY_BATCH --9' + char(10)
	SELECT @v_dsql += '			,sum(CEILING(A.PLAN_IN_QTY_JR)) PLAN_IN_QTY_JR' + char(10)
	SELECT @v_dsql += '			,sum(CEILING(A.PLAN_IN_QTY_M)) PLAN_IN_QTY_M' + char(10)
	SELECT @v_dsql += '			,sum(CEILING(A.PLAN_IN_QTY_CELL)) PLAN_IN_QTY_CELL' + char(10)
	SELECT @v_dsql += '			,sum(ROUND(A.PLAN_OUT_QTY_BATCH,2)) PLAN_OUT_QTY_BATCH' + char(10)
	SELECT @v_dsql += '' + char(10)
	SELECT @v_dsql += '			,sum(CEILING(A.PLAN_OUT_QTY_JR)) PLAN_OUT_QTY_JR --10' + char(10)
	SELECT @v_dsql += '			,sum(CEILING(A.PLAN_OUT_QTY_M)) PLAN_OUT_QTY_M' + char(10)
	SELECT @v_dsql += '			,sum(CEILING(A.PLAN_OUT_QTY_CELL)) PLAN_OUT_QTY_CELL' + char(10)
	SELECT @v_dsql += '			,sum(A.SEQ) SEQ' + char(10)
	SELECT @v_dsql += '            , A.CALC_TYPE ' + char(10)
	SELECT @v_dsql += '            , A.PROD_SEQ, A.VERSION, A.WORK_REQUEST_MODEL_ID, A.PLM_EC_NO  ' + char(10)
	SELECT @v_dsql += '			,A.DPPTYPE, A.MPPTYPE, A.WPPTYPE, A.RESULTTYPE, A.PLAN_DATE' 
	------ End tuning block 1 -------
    SET @v_dsql += '           FROM (' + char(10)
    SET @v_dsql += '                   SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + char(10)
    SET @v_dsql += '                        , A.LOCATION, A.OPERATION_ID' + char(10)
    SET @v_dsql += '                        , A.LINE_ID, ISNULL(C.LINE_NAME,''-'') AS LINE_NAME, A.ELECTRODE_TYPE' + char(10)
    SET @v_dsql += '                        , A.EQUIPMENT_ID' + char(10)
    SET @v_dsql += '                        , A.PLAN_DATE' + char(10)
    SET @v_dsql += '                        , A.TOP_ITEM_ID, A.ITEM_ID, ISNULL(B.NICK_NAME,''-'') AS NICK_NAME' + char(10)
    SET @v_dsql += '                        , A.PRODUCTION_TYPE' + char(10)
    SET @v_dsql += '                        , A.MARKET' + char(10)
    SET @v_dsql += '                        , A.SEQ' + char(10)
    SET @v_dsql += '                        , A.ADJUST_IN_QTY_BATCH, A.ADJUST_IN_QTY, A.ADJUST_IN_QTY_M, A.ADJUST_IN_QTY_CELL, A.ADJUST_IN_QTY_JR' + char(10)
    SET @v_dsql += '                        , A.ADJUST_OUT_QTY_BATCH, A.ADJUST_OUT_QTY, A.ADJUST_OUT_QTY_M, A.ADJUST_OUT_QTY_CELL, A.ADJUST_OUT_QTY_JR' + char(10)
    SET @v_dsql += '                        , A.MPP_IN_QTY_BATCH, A.MPP_IN_QTY, A.MPP_IN_QTY_M, A.MPP_IN_QTY_CELL, A.MPP_IN_QTY_JR' + char(10)
    SET @v_dsql += '                        , A.MPP_OUT_QTY_BATCH, A.MPP_OUT_QTY, A.MPP_OUT_QTY_M, A.MPP_OUT_QTY_CELL, A.MPP_OUT_QTY_JR' + char(10)
    SET @v_dsql += '                        , A.WPP_IN_QTY_BATCH, A.WPP_IN_QTY, A.WPP_IN_QTY_M, A.WPP_IN_QTY_CELL, A.WPP_IN_QTY_JR' + char(10)
    SET @v_dsql += '                        , A.WPP_OUT_QTY_BATCH, A.WPP_OUT_QTY, A.WPP_OUT_QTY_M, A.WPP_OUT_QTY_CELL, A.WPP_OUT_QTY_JR' + char(10)
    SET @v_dsql += '                        , A.RESULT_IN_QTY_BATCH,  A.RESULT_IN_QTY, A.RESULT_IN_QTY_M, A.RESULT_IN_QTY_CELL, A.RESULT_IN_QTY_JR' + char(10)
    SET @v_dsql += '                        , A.RESULT_OUT_QTY_BATCH,  A.RESULT_OUT_QTY, A.RESULT_OUT_QTY_M, A.RESULT_OUT_QTY_CELL, A.RESULT_OUT_QTY_JR' + char(10)
    SET @v_dsql += '                        , A.PLAN_IN_QTY_BATCH, A.PLAN_IN_QTY_M, A.PLAN_IN_QTY_JR, A.PLAN_IN_QTY_CELL' + char(10)
    SET @v_dsql += '                        , A.PLAN_OUT_QTY_BATCH, A.PLAN_OUT_QTY_M, A.PLAN_OUT_QTY_JR, A.PLAN_OUT_QTY_CELL' + char(10)
    SET @v_dsql += '                        , A.TOTAL_BATCH' + char(10)
    SET @v_dsql += '                        , A.BGCOLOR' + char(10)
    SET @v_dsql += '                        , C.PROD_VERSION_TYPE' + char(10)
    SET @v_dsql += '                        , A.DPPTYPE, A.MPPTYPE, A.WPPTYPE, A.RESULTTYPE' + char(10)
    SET @v_dsql += '                        , ISNULL(X.CALC_TYPE, dbo.FN_GET_CONV_CALC(' + char(10)
    SET @v_dsql += '' + @v_master_id + '' + char(10)
    SET @v_dsql += ', A.PLANT_ID, A.FACTORY_ID, A.LINE_ID, '''', A.ITEM_ID, A.PRODUCTION_TYPE, NULL, ''CALC_TYPE'')) AS CALC_TYPE' + char(10)
    --SET @v_dsql += '                        , X.PROD_SEQ, X.VERSION' + char(10)
	SET @v_dsql += '                        , A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PROD_SEQ, A.PLM_EC_NO' + char(10)
    SET @v_dsql += '                    FROM (' + char(10)
    SET @v_dsql += '                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + char(10)
    SET @v_dsql += '                    , A.LOCATION, A.OPERATION_ID' + char(10)
    SET @v_dsql += '                    , A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE' + char(10)
    SET @v_dsql += '                    , A.EQUIPMENT_ID' + char(10)
    SET @v_dsql += '                    , A.PLAN_DATE' + char(10)
    SET @v_dsql += '                    , A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME' + char(10)
    SET @v_dsql += '                    , A.PRODUCTION_TYPE' + char(10)
    SET @v_dsql += '                    , A.MARKET' + char(10)
    SET @v_dsql += '                    , A.SEQ' + char(10)
    SET @v_dsql += '                    , A.ADJUST_IN_QTY_BATCH, A.ADJUST_IN_QTY, A.ADJUST_IN_QTY_M, A.ADJUST_IN_QTY_CELL, A.ADJUST_IN_QTY_JR' + char(10)
    SET @v_dsql += '                    , A.ADJUST_OUT_QTY_BATCH, A.ADJUST_OUT_QTY, A.ADJUST_OUT_QTY_M, A.ADJUST_OUT_QTY_CELL, A.ADJUST_OUT_QTY_JR' + char(10)
    SET @v_dsql += '                    , A.MPP_IN_QTY_BATCH, A.MPP_IN_QTY, A.MPP_IN_QTY_M, A.MPP_IN_QTY_CELL, A.MPP_IN_QTY_JR' + char(10)
    SET @v_dsql += '                    , A.MPP_OUT_QTY_BATCH, A.MPP_OUT_QTY, A.MPP_OUT_QTY_M, A.MPP_OUT_QTY_CELL, A.MPP_OUT_QTY_JR' + char(10)
    SET @v_dsql += '                    , A.WPP_IN_QTY_BATCH, A.WPP_IN_QTY, A.WPP_IN_QTY_M, A.WPP_IN_QTY_CELL, A.WPP_IN_QTY_JR' + char(10)
    SET @v_dsql += '                    , A.WPP_OUT_QTY_BATCH, A.WPP_OUT_QTY, A.WPP_OUT_QTY_M, A.WPP_OUT_QTY_CELL, A.WPP_OUT_QTY_JR' + char(10)
    SET @v_dsql += '                    , A.RESULT_IN_QTY_BATCH,  A.RESULT_IN_QTY, A.RESULT_IN_QTY_M, A.RESULT_IN_QTY_CELL, A.RESULT_IN_QTY_JR' + char(10)
    SET @v_dsql += '                    , A.RESULT_OUT_QTY_BATCH,  A.RESULT_OUT_QTY, A.RESULT_OUT_QTY_M, A.RESULT_OUT_QTY_CELL, A.RESULT_OUT_QTY_JR' + char(10)
    SET @v_dsql += '                    , A.PLAN_IN_QTY_BATCH, A.PLAN_IN_QTY_M, A.PLAN_IN_QTY_JR, A.PLAN_IN_QTY_CELL' + char(10)
    SET @v_dsql += '                    , A.PLAN_OUT_QTY_BATCH, A.PLAN_OUT_QTY_M, A.PLAN_OUT_QTY_JR, A.PLAN_OUT_QTY_CELL' + char(10)
    SET @v_dsql += '                    , A.TOTAL_BATCH' + char(10)
    SET @v_dsql += '                    , NULL AS BGCOLOR' + char(10)
    SET @v_dsql += '                    , SUM( ISNULL(A.ADJUST_IN_QTY_BATCH,0)) OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID' + char(10)
    SET @v_dsql += '                    , A.TOP_ITEM_ID, A.ITEM_ID, A.PRODUCTION_TYPE, A.MARKET ) AS DPPTYPE' + char(10)
    SET @v_dsql += '                    , SUM( ISNULL(A.MPP_IN_QTY_BATCH,0)) OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID' + char(10)
    SET @v_dsql += '                    , A.TOP_ITEM_ID, A.ITEM_ID, A.PRODUCTION_TYPE, A.MARKET ) AS MPPTYPE' + char(10)
    SET @v_dsql += '                    , SUM( ISNULL(A.MPP_IN_QTY_BATCH,0)) OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID' + char(10)
    SET @v_dsql += '                    , A.TOP_ITEM_ID, A.ITEM_ID, A.PRODUCTION_TYPE, A.MARKET ) AS WPPTYPE' + char(10)
    SET @v_dsql += '                    , SUM( ISNULL(A.RESULT_OUT_QTY_BATCH,0)) OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID' + char(10)
    SET @v_dsql += '                    , A.TOP_ITEM_ID, A.ITEM_ID, A.PRODUCTION_TYPE, A.MARKET ) AS RESULTTYPE' + char(10)
	SET @v_dsql += '                    , A.WORK_REQUEST_MODEL_ID, A.VERSION, B.PROD_SEQ, A.PLM_EC_NO ' + char(10)
	SET @v_dsql += '               FROM   ' + @p_amend_table + ' A WITH(NOLOCK)' + char(10)
	SET @v_dsql += '               LEFT OUTER JOIN ( ' + char(10)
	SET @v_dsql += '               		SELECT COMPANY_ID, FACTORY_ID, MODEL_ID, VERSION, OPERATION AS OPERATION_ID, ITEM_ID, MAX(PROD_SEQ) AS PROD_SEQ ' + char(10)
	SET @v_dsql += '               		FROM   SCM_ITEM_CONV_CALC_M A WITH(NOLOCK) ' + char(10)
	SET @v_dsql += '               		WHERE  A.OPERATION = ''E2000'' ' + char(10)
    SET @v_dsql += '               		' + @A_DIVISION_ID_EQ
    SET @v_dsql += '               		' + @A_SITE_ID_EQ
    SET @v_dsql += '               		' + @A_PLANT_ID_EQ
    SET @v_dsql += '               		' + @A_FACTORY_ID_EQ
	SET @v_dsql += '               		AND    A.VALUE > 0 ' + char(10)
	SET @v_dsql += '               		AND    A.CATEGORY IN ( ''Jumbo Roll (cell/m)'', ''Lane Number'', ''Pancake (m/batch)'', ''cell/batch'', ''Jumbo Roll (m/batch)'', ''Pancake (cell/m)'' ) ' + char(10)
	SET @v_dsql += '               		GROUP BY COMPANY_ID, FACTORY_ID, MODEL_ID, VERSION, OPERATION, ITEM_ID ' + char(10)
	SET @v_dsql += '               ) B ' + char(10)
	SET @v_dsql += '               ON  A.COMPANY_ID   = B.COMPANY_ID ' + char(10)
	SET @v_dsql += '               AND A.FACTORY_ID   = B.FACTORY_ID ' + char(10)
	SET @v_dsql += '               AND A.WORK_REQUEST_MODEL_ID = B.MODEL_ID ' + char(10)
	SET @v_dsql += '               AND A.VERSION      = B.VERSION ' + char(10)
	SET @v_dsql += '               AND A.OPERATION_ID = B.OPERATION_ID ' + char(10)
	SET @v_dsql += '               AND A.ITEM_ID      = B.ITEM_ID ' + char(10)
    SET @v_dsql += '               WHERE  INSTANCE_ID      =' + char(10)
    SET @v_dsql += '' + @v_instance_id + '' + char(10)
    SET @v_dsql += '               AND    FP_PLAN_ID       =' + char(10)
    SET @v_dsql += '' + @v_plan_id + '' + char(10)
    SET @v_dsql += '               AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN' + char(10)
    SET @v_dsql += '' + @v_bucket_from + '' + char(10)
    SET @v_dsql += ' AND' + char(10)
    SET @v_dsql += '' + @v_bucket_to + '' + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.DIVISION_ID', 'EQ', @p_division_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.SITE_ID', 'EQ', @p_site_id)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PLANT_ID', 'EQ', @p_plant_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.FACTORY_ID', 'EQ', @p_factory_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.OPERATION_ID', 'EQ', @p_operation_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.LINE_ID', 'EQ', @p_line_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.TOP_ITEM_ID', 'LK', @p_top_item_id)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.ITEM_ID', 'LK', @p_item_id)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PRODUCTION_TYPE', 'EQ', @p_prodtype_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PRODUCTION_TYPE', 'LK', @p_prod_type)
    ) + char(10)
    SET @v_dsql += isnull(@o_dsql, '')
    SET @v_dsql += '       ) A' + char(10)
    SET @v_dsql += '       INNER JOIN SCM_ITEM_M B WITH(NOLOCK)' + char(10)
    SET @v_dsql += '       ON     A.COMPANY_ID     = B.COMPANY_ID' + char(10)
    SET @v_dsql += '       AND    A.DIVISION_ID    = B.DIVISION_ID' + char(10)
    SET @v_dsql += '       AND    A.SITE_ID        = B.SITE_ID' + char(10)
    SET @v_dsql += '       AND    A.TOP_ITEM_ID    = B.ITEM_ID' + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('ISNULL(B.NICK_NAME,''-'')', 'EQ', @p_nickname_lt)
    ) + char(10)
    SET @v_dsql += '       INNER JOIN SCM_LINE_M C WITH(NOLOCK)' + char(10)
    SET @v_dsql += '       ON     A.COMPANY_ID     = C.COMPANY_ID' + char(10)
    SET @v_dsql += '       AND    A.DIVISION_ID    = C.DIVISION_ID' + char(10)
    SET @v_dsql += '       AND    A.SITE_ID        = C.SITE_ID' + char(10)
    SET @v_dsql += '       AND    A.PLANT_ID       = C.PLANT_ID' + char(10)
    SET @v_dsql += '       AND    A.FACTORY_ID     = C.FACTORY_ID' + char(10)
    SET @v_dsql += '       AND    A.OPERATION_ID   = C.OPERATION_ID' + char(10)
    SET @v_dsql += '       AND    A.LINE_ID        = C.LINE_ID' + char(10)
    SET @v_dsql += '       AND    A.ELECTRODE_TYPE = C.ELECTRODE_TYPE' + char(10)
    SET @v_dsql += '     LEFT OUTER HASH JOIN (' + char(10)
    SET @v_dsql += '     SELECT B.*' + char(10)
    SET @v_dsql += '      , MIN(B.IDX) OVER (PARTITION BY B.INSTANCE_ID, B.PRODUCTION_TYPE, A.LINE_ID, A.ITEM_ID ) AS MIN_IDX' + char(10)
    SET @v_dsql += '      , A.*' + char(10)
    SET @v_dsql += '     FROM (' + char(10)
    SET @v_dsql += '     SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID AS CALC_PLANT_ID, A.FACTORY_ID, B.LINE_ID, A.ITEM_ID, B.ELECTRODE_TYPE, A.VERSION_TYPE AS CALC_TYPE, A.VERSION, A.PROD_SEQ' + char(10)
    SET @v_dsql += '      , DENSE_RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION, A.ITEM_ID, A.PROD_VERSION_TYPE, A.VERSION_TYPE' + char(10)
    SET @v_dsql += '       ORDER BY A.APPLY_DATE DESC, (CASE WHEN A.VERSION LIKE ''Z%'' THEN REPLACE( A.VERSION, ''Z'', ''/'') ELSE A.VERSION END) DESC' + char(10)
    SET @v_dsql += '              , (CASE WHEN A.MODEL_ID = C.APPLIED_MODEL THEN 1 ELSE 2 END), A.MODEL_ID DESC ) AS SEQ ' + char(10)
    -- 적용모델이 동일한 것 우선순위 조건 추가...20210420    
    SET @v_dsql += '     FROM   SCM_ITEM_CONV_CALC_M A WITH(NOLOCK), SCM_LINE_M B WITH(NOLOCK), SCM_ITEM_M C WITH(NOLOCK)' + char(10)
    SET @v_dsql += '     WHERE  1=1' + char(10)
    SET @v_dsql += '     AND    A.OPERATION    = ''E2000''' + char(10)
    SET @v_dsql += '     AND    A.MAX_VER_FLAG = ''Y''' + char(10)
    SET @v_dsql += '     AND    A.COMPANY_ID   = B.COMPANY_ID' + char(10)
    SET @v_dsql += '     AND    A.DIVISION_ID  = B.DIVISION_ID' + char(10)
    SET @v_dsql += '     AND    A.SITE_ID      = B.SITE_ID' + char(10)
    SET @v_dsql += '     AND    A.PLANT_ID     = B.PLANT_ID' + char(10)
    SET @v_dsql += '     AND    A.FACTORY_ID   = B.FACTORY_ID' + char(10)
    SET @v_dsql += '     AND    A.OPERATION    = B.OPERATION_ID' + char(10)
    SET @v_dsql += '     AND    A.PROD_VERSION_TYPE = ISNULL(B.PROD_VERSION_TYPE, ''GENERAL'')' + char(10)
    SET @v_dsql += '                           AND    A.COMPANY_ID   = C.COMPANY_ID' + char(10)
    SET @v_dsql += '                           AND    A.DIVISION_ID  = C.DIVISION_ID' + char(10)
    SET @v_dsql += '                           AND    A.SITE_ID      = C.SITE_ID' + char(10)
    SET @v_dsql += '                           AND    A.ITEM_ID      = C.ITEM_ID' + char(10)
    SET @v_dsql += '     AND    B.ACTIVE_FLAG = ''Y''' + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.FACTORY_ID', 'EQ', @p_factory_lt)
    ) + char(10)
    SET @v_dsql += '     ) A' + char(10)
    SET @v_dsql += '     , (' + char(10)
    SET @v_dsql += '     SELECT SEGMENT1 AS INSTANCE_ID, SEGMENT2 AS PLANT_ID, SEGMENT3 AS PRODUCTION_TYPE,  VERSION_TYPE' + char(10)
    SET @v_dsql += '      , RANK() OVER (PARTITION BY SEGMENT1, SEGMENT3 ORDER BY GUBUN) AS IDX' + char(10)
    SET @v_dsql += '     FROM (' + char(10)
    SET @v_dsql += '     SELECT *' + char(10)
    SET @v_dsql += '     FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)' + char(10)
    SET @v_dsql += '     WHERE  1=1' + char(10)
    SET @v_dsql += '     AND    LOOKUP_TYPE_CODE = ''INSTANCE_CONV_PRIORITY''' + char(10)
    SET @v_dsql += '     AND    SEGMENT1         =' + char(10)
    SET @v_dsql += '' + @v_master_id + '' + char(10)
    SET @v_dsql += '     AND    ACTIVE_FLAG      = ''Y''' + char(10)
    SET @v_dsql += '     ) A' + char(10)
    SET @v_dsql += '     UNPIVOT(VERSION_TYPE FOR GUBUN IN (ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5) ) AS VERSION_TYPE' + char(10)
    SET @v_dsql += '     ) B' + char(10)
    SET @v_dsql += '     WHERE 1=1' + char(10)
    SET @v_dsql += '     AND   A.CALC_PLANT_ID = B.PLANT_ID' + char(10)
    SET @v_dsql += '     AND   A.CALC_TYPE = B.VERSION_TYPE' + char(10)
    SET @v_dsql += '     AND   A.SEQ = 1' + char(10)
    SET @v_dsql += '     ) X' + char(10)
    SET @v_dsql += '     ON    1=1' + char(10)
    SET @v_dsql += '     AND   X.MIN_IDX         = X.IDX' + char(10)
    SET @v_dsql += '     AND   A.SITE_ID         = X.SITE_ID' + char(10)
    SET @v_dsql += '     AND   A.PLANT_ID        = X.PLANT_ID' + char(10)
    SET @v_dsql += '     AND   A.FACTORY_ID      = X.FACTORY_ID' + char(10)
    SET @v_dsql += '     AND   A.LINE_ID         = X.LINE_ID' + char(10)
    SET @v_dsql += '     AND   A.ITEM_ID         = X.ITEM_ID' + char(10)
    SET @v_dsql += '     AND   A.ELECTRODE_TYPE  = X.ELECTRODE_TYPE' + char(10)
    SET @v_dsql += '     AND   A.PRODUCTION_TYPE = X.PRODUCTION_TYPE' + char(10)
    SET @v_dsql += '       WHERE 1=1' + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('B.NICK_NAME', 'LK', @p_nickname)
    ) + char(10)
    SET @v_dsql += '           ) A' + char(10)
	---- Begin tuning block 2 ----
	SELECT @v_dsql += '		GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
	SELECT @v_dsql += '                 , A.LOCATION, A.OPERATION_ID ' + char(10)
	SELECT @v_dsql += '                 , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
	SELECT @v_dsql += '                 , A.EQUIPMENT_ID ' + char(10)
	SELECT @v_dsql += '                 , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME ' + char(10)
	SELECT @v_dsql += '                 , A.PRODUCTION_TYPE, A.MARKET, A.PROD_VERSION_TYPE ' + char(10)
	SELECT @v_dsql += '                 --, B.CATEGORY_ID, B.CATEGORY_NAME, B.CATEGORY_ORDER, B.MEASURE_NAME ' + char(10)
	SELECT @v_dsql += '                 , A.DPPTYPE, A.MPPTYPE, A.WPPTYPE, A.RESULTTYPE, A.CALC_TYPE ' + char(10)
	SELECT @v_dsql += '                 , A.PROD_SEQ, A.VERSION, A.WORK_REQUEST_MODEL_ID, A.PLM_EC_NO ' + char(10)
	SELECT @v_dsql += '				 , A.PLAN_DATE' + char(10)
	SELECT @v_dsql += '	) A' 
	---- End tuning block 2 ----
    SET @v_dsql += '           INNER HASH JOIN TH_UIS_CAL C WITH(NOLOCK)' + char(10)
    SET @v_dsql += '           ON  1=1' + char(10)
    SET @v_dsql += '           AND CONVERT(VARCHAR, C.DT, 112) BETWEEN' + char(10)
    SET @v_dsql += '' + @v_bucket_from + '' + char(10)
    SET @v_dsql += ' AND' + char(10)
    SET @v_dsql += '' + @v_bucket_to + '' + char(10)
    SET @v_dsql += '           AND A.PLAN_DATE = C.DT' + char(10)
    SET @v_dsql += '           INNER JOIN (' + char(10)
    SET @v_dsql += '              SELECT *' + char(10)
    SET @v_dsql += '               FROM (' + char(10)
    SET @v_dsql += isnull(@p_dsql, '')
    SET @v_dsql += '               ) A' + char(10)
    SET @v_dsql += '               WHERE CATEGORY_ID <> ''X''' + char(10)
    SET @v_dsql += '           ) B' + char(10)
    SET @v_dsql += '           ON 1=1' + char(10)
    SET @v_dsql += '             GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + char(10)
    SET @v_dsql += '                 , A.LOCATION, A.OPERATION_ID' + char(10)
    SET @v_dsql += '                 , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE' + char(10)
    SET @v_dsql += '                 , A.EQUIPMENT_ID' + char(10)
    SET @v_dsql += '                 , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME' + char(10)
    SET @v_dsql += '                 , A.PRODUCTION_TYPE, A.MARKET, A.PROD_VERSION_TYPE' + char(10)
    SET @v_dsql += '                 , B.CATEGORY_ID, B.CATEGORY_NAME, B.CATEGORY_ORDER, B.MEASURE_NAME' + char(10)
    SET @v_dsql += '                 , A.DPPTYPE, A.MPPTYPE, A.WPPTYPE, A.RESULTTYPE, A.CALC_TYPE' + char(10)
    SET @v_dsql += '                 , A.PROD_SEQ, A.VERSION, A.WORK_REQUEST_MODEL_ID, A.PLM_EC_NO' + char(10)
    SET @v_dsql += '      ) A' + char(10)
    SET @v_dsql += '      LEFT OUTER HASH JOIN (' + char(10)
    SET @v_dsql += '               SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + char(10)
    SET @v_dsql += '                    , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID' + char(10)
    SET @v_dsql += '                    , A.TOP_ITEM_ID, A.ITEM_ID' + char(10)
    SET @v_dsql += '                    , ROUND(A.DAILY_CAPA_M,0) AS DAILY_CAPA_M' + char(10)
    SET @v_dsql += '                    , ROUND(A.DAILY_CAPA_EA,0) AS DAILY_CAPA_EA' + char(10)
    SET @v_dsql += '                    , ROUND(A.DAILY_CAPA_KG,0) AS DAILY_CAPA_KG' + char(10)
    SET @v_dsql += '                    , ROUND(A.DAILY_CAPA_JR,0) AS DAILY_CAPA_JR' + char(10)
    SET @v_dsql += '                    , ROUND(A.DAILY_CAPA_BATCH,' + @v_round_point + ') AS DAILY_CAPA_BATCH' + char(10)
    SET @v_dsql += '                    , CAPA_VALIDATION_FLAG AS DC_FLAG' + char(10)
    --SET @v_dsql += '                    , A.CALC_TYPE, A.VERSION, A.WORK_REQUEST_MODEL_ID' + char(10)
	SET @v_dsql += '                    , A.VERSION, A.WORK_REQUEST_MODEL_ID' + char(10)
    SET @v_dsql += '               FROM   ' + @p_amend_capa_table + ' A WITH(NOLOCK)' + char(10)
    SET @v_dsql += '               WHERE  1=1' + char(10)
    SET @v_dsql += '               AND A.INSTANCE_ID =' + char(10)
    SET @v_dsql += '' + @v_instance_id + '' + char(10)
    SET @v_dsql += '               AND    A.FP_PLAN_ID  =' + char(10)
    SET @v_dsql += '' + @v_plan_id + '' + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.DIVISION_ID', 'EQ', @p_division_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.SITE_ID', 'EQ', @p_site_id)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PLANT_ID', 'EQ', @p_plant_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.FACTORY_ID', 'EQ', @p_factory_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.OPERATION_ID', 'EQ', @p_operation_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.LINE_ID', 'EQ', @p_line_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.TOP_ITEM_ID', 'LK', @p_top_item_id)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.ITEM_ID', 'LK', @p_item_id)
    ) + char(10)
    SET @v_dsql += '   ) D' + char(10)
    SET @v_dsql += '          ON  A.COMPANY_ID      = D.COMPANY_ID' + char(10)
    SET @v_dsql += '          AND A.DIVISION_ID     = D.DIVISION_ID' + char(10)
    SET @v_dsql += '          AND A.SITE_ID         = D.SITE_ID' + char(10)
    SET @v_dsql += '          AND A.PLANT_ID        = D.PLANT_ID' + char(10)
    SET @v_dsql += '          AND A.FACTORY_ID      = D.FACTORY_ID' + char(10)
    SET @v_dsql += '          AND A.LOCATION        = D.LOCATION' + char(10)
    SET @v_dsql += '          AND A.OPERATION_ID    = D.OPERATION_ID' + char(10)
    SET @v_dsql += '          AND A.LINE_ID         = D.LINE_ID' + char(10)
    SET @v_dsql += '          AND A.ELECTRODE_TYPE  = D.ELECTRODE_TYPE' + char(10)
    SET @v_dsql += '          AND A.EQUIPMENT_ID    = D.EQUIPMENT_ID' + char(10)
    SET @v_dsql += '          --AND A.TOP_ITEM_ID     = D.TOP_ITEM_ID' + char(10)
    SET @v_dsql += '          AND A.ITEM_ID         = D.ITEM_ID' + char(10)
    SET @v_dsql += '          --AND (CASE WHEN PATINDEX(''%TEST'', A.PRODUCTION_TYPE) > 0 THEN ''TEST'' ELSE ''MASS'' END) = D.CALC_TYPE'
                   + char(10)
    --SET @v_dsql += '          AND A.CALC_TYPE = D.CALC_TYPE' + char(10)
	SET @v_dsql += '          AND A.VERSION = D.VERSION ' + char(10)
	SET @v_dsql += '          AND A.WORK_REQUEST_MODEL_ID = D.WORK_REQUEST_MODEL_ID ' + char(10)
    SET @v_dsql += '          LEFT OUTER HASH JOIN (' + char(10)
    SET @v_dsql += ' SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.PROD_VERSION_TYPE, A.PROD_TYPE, PAN_PROD_VERSION AS PROD_VERSION, A.PC_ITEM_ID, A.MODEL_ID, A.PROD_SEQ ' + char(10)
    --SET @v_dsql += ' , A.PC_ITEM_ID, A.MODEL_ID' + char(10)
    SET @v_dsql += ' , NULL AS BATCH_ID' + char(10)
    SET @v_dsql += ' , MAX(CASE WHEN A.UI_COLUMN = ''Slurry 1'' THEN A.MATERIAL_ITEM_ID END) AS SLURRY_1' + char(10)
    SET @v_dsql += ' , MAX(CASE WHEN A.UI_COLUMN = ''Slurry 2'' THEN A.MATERIAL_ITEM_ID END) AS SLURRY_2' + char(10)
    SET @v_dsql += ' , MAX(CASE WHEN A.UI_COLUMN = ''Active Material 1'' THEN A.DESCRIPTION END) AS ACTIVE_MATERIAL_1' + char(10)
    SET @v_dsql += ' , MAX(CASE WHEN A.UI_COLUMN = ''Active Material 2'' THEN A.DESCRIPTION END) AS ACTIVE_MATERIAL_2' + char(10)
    SET @v_dsql += ' , MAX(CASE WHEN A.UI_COLUMN = ''Active Material 3'' THEN A.DESCRIPTION END) AS ACTIVE_MATERIAL_3' + char(10)
    SET @v_dsql += ' , MAX(CASE WHEN A.UI_COLUMN = ''Binder 1'' THEN A.DESCRIPTION END) AS BINDER_1' + char(10)
    SET @v_dsql += ' , MAX(CASE WHEN A.UI_COLUMN = ''Binder 2'' THEN A.DESCRIPTION END) AS BINDER_2' + char(10)
    SET @v_dsql += ' , MAX(CASE WHEN A.UI_COLUMN = ''Binder 3'' THEN A.DESCRIPTION END) AS BINDER_3' + char(10)
    SET @v_dsql += ' , MAX(CASE WHEN A.UI_COLUMN = ''Pre Dispersion Slurry 1'' THEN A.MATERIAL_ITEM_ID END) AS PRE_DISPERSION_ID' + char(10)
    SET @v_dsql += ' , MAX(CASE WHEN A.UI_COLUMN = ''Pre Dispersion Slurry 1'' THEN A.DESCRIPTION END) AS PRE_DISPERSION_NAME' + char(10)
    SET @v_dsql += ' , MAX(CASE WHEN A.UI_COLUMN = ''Pre Dispersion Slurry 2'' THEN A.MATERIAL_ITEM_ID END) AS PRE_DISPERSION_ID_2' + char(10)
    SET @v_dsql += ' , MAX(CASE WHEN A.UI_COLUMN = ''Pre Dispersion Slurry 2'' THEN A.DESCRIPTION END) AS PRE_DISPERSION_NAME_2' + char(10)
    SET @v_dsql += ' , MAX(CASE WHEN A.CLASS_NAME = ''CMC'' then A.DESCRIPTION END) AS CMC' + char(10)
    SET @v_dsql += ' , MAX(CASE WHEN A.UI_COLUMN = ''Conducting Material 1'' THEN A.DESCRIPTION END) AS CONDUCTION_MATERIAL_1' + char(10)
    SET @v_dsql += ' , MAX(CASE WHEN A.UI_COLUMN = ''Conducting Material 2'' THEN A.DESCRIPTION END) AS CONDUCTION_MATERIAL_2' + char(10)
    SET @v_dsql += ' , MAX(CASE WHEN A.CLASS_NAME = ''Addition Agent'' THEN A.DESCRIPTION END) AS ADDITION_AGENT' + char(10)
    SET @v_dsql += ' FROM   SCM_PANCAKE_MATERIAL_ALL_VERSION_V A  WITH(NOLOCK)' + char(10)
    SET @v_dsql += ' WHERE  1=1' + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.DIVISION_ID', 'EQ', @p_division_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.SITE_ID', 'EQ', @p_site_id)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PLANT_ID', 'EQ', @p_plant_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.FACTORY_ID', 'EQ', @p_factory_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PC_ITEM_ID', 'LK', @p_item_id)
    ) + char(10)
    SET @v_dsql += ' GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.PROD_VERSION_TYPE, A.PROD_TYPE, PAN_PROD_VERSION, A.PC_ITEM_ID, A.MODEL_ID, A.PROD_SEQ '
                   + char(10)
    SET @v_dsql += ' ) E' + char(10)
    SET @v_dsql += '          ON  A.COMPANY_ID      = E.COMPANY_ID' + char(10)
    SET @v_dsql += '          AND A.DIVISION_ID     = E.DIVISION_ID' + char(10)
    SET @v_dsql += '          AND A.SITE_ID         = E.SITE_ID' + char(10)
    SET @v_dsql += '          AND A.PLANT_ID        = E.PLANT_ID' + char(10)
    SET @v_dsql += '          AND A.FACTORY_ID      = E.FACTORY_ID' + char(10)
    SET @v_dsql += '          AND A.ITEM_ID               = E.PC_ITEM_ID ' + char(10)
    SET @v_dsql += '          AND A.WORK_REQUEST_MODEL_ID = E.MODEL_ID ' + char(10)
    SET @v_dsql += '          AND A.VERSION               = E.PROD_VERSION ' + char(10)
    SET @v_dsql += '          AND A.PROD_SEQ              = E.PROD_SEQ ' + char(10)
    --SET @v_dsql += '          AND A.PROD_VERSION_TYPE = E.PROD_VERSION_TYPE' + char(10)
    --SET @v_dsql += '          --AND (CASE WHEN PATINDEX(''%TEST'', A.PRODUCTION_TYPE) > 0 THEN ''TEST'' ELSE ''MASS'' END) = E.PROD_TYPE' + char(10)
    --SET @v_dsql += '          AND A.CALC_TYPE = E.PROD_TYPE' + char(10)
    
	/*
	SET @v_dsql += '          LEFT OUTER HASH JOIN (' + char(10)
    SET @v_dsql += '         SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.PROD_VERSION_TYPE, A.PROD_TYPE, MAX(A.PAN_PROD_VERSION)  AS PROD_VERSION'
                   + char(10)
    SET @v_dsql += ' , A.PC_ITEM_ID, A.MODEL_ID' + char(10)
    SET @v_dsql += ' , NULL AS BATCH_ID' + char(10)
    SET @v_dsql += ' , MAX(CASE WHEN A.UI_COLUMN = ''Slurry 1'' THEN A.MATERIAL_ITEM_ID END) AS SLURRY_1' + char(10)
    SET @v_dsql += ' , MAX(CASE WHEN A.UI_COLUMN = ''Slurry 2'' THEN A.MATERIAL_ITEM_ID END) AS SLURRY_2' + char(10)
    SET @v_dsql += ' , MAX(CASE WHEN A.UI_COLUMN = ''Active Material 1'' THEN A.DESCRIPTION END) AS ACTIVE_MATERIAL_1'
                   + char(10)
    SET @v_dsql += ' , MAX(CASE WHEN A.UI_COLUMN = ''Active Material 2'' THEN A.DESCRIPTION END) AS ACTIVE_MATERIAL_2'
                   + char(10)
    SET @v_dsql += ' , MAX(CASE WHEN A.UI_COLUMN = ''Active Material 3'' THEN A.DESCRIPTION END) AS ACTIVE_MATERIAL_3'
                   + char(10)
    SET @v_dsql += ' , MAX(CASE WHEN A.UI_COLUMN = ''Binder 1'' THEN A.DESCRIPTION END) AS BINDER_1' + char(10)
    SET @v_dsql += ' , MAX(CASE WHEN A.UI_COLUMN = ''Binder 2'' THEN A.DESCRIPTION END) AS BINDER_2' + char(10)
    SET @v_dsql += ' , MAX(CASE WHEN A.UI_COLUMN = ''Binder 3'' THEN A.DESCRIPTION END) AS BINDER_3' + char(10)
    SET @v_dsql += ' , MAX(CASE WHEN A.UI_COLUMN = ''Pre Dispersion Slurry 1'' THEN A.MATERIAL_ITEM_ID END) AS PRE_DISPERSION_ID'
                   + char(10)
    SET @v_dsql += ' , MAX(CASE WHEN A.UI_COLUMN = ''Pre Dispersion Slurry 1'' THEN A.DESCRIPTION END) AS PRE_DISPERSION_NAME'
                   + char(10)
    SET @v_dsql += ' , MAX(CASE WHEN A.UI_COLUMN = ''Pre Dispersion Slurry 2'' THEN A.MATERIAL_ITEM_ID END) AS PRE_DISPERSION_ID_2'
                   + char(10)
    SET @v_dsql += ' , MAX(CASE WHEN A.UI_COLUMN = ''Pre Dispersion Slurry 2'' THEN A.DESCRIPTION END) AS PRE_DISPERSION_NAME_2'
                   + char(10)
    SET @v_dsql += ' , MAX(CASE WHEN A.CLASS_NAME = ''CMC'' then A.DESCRIPTION END) AS CMC' + char(10)
    SET @v_dsql += ' , MAX(CASE WHEN A.UI_COLUMN = ''Conducting Material 1'' THEN A.DESCRIPTION END) AS CONDUCTION_MATERIAL_1'
                   + char(10)
    SET @v_dsql += ' , MAX(CASE WHEN A.UI_COLUMN = ''Conducting Material 2'' THEN A.DESCRIPTION END) AS CONDUCTION_MATERIAL_2'
                   + char(10)
    SET @v_dsql += ' , MAX(CASE WHEN A.CLASS_NAME = ''Addition Agent'' THEN A.DESCRIPTION END) AS ADDITION_AGENT'
                   + char(10)
    SET @v_dsql += ' FROM   SCM_PANCAKE_MATERIAL_V A WITH(NOLOCK)' + char(10)
    SET @v_dsql += ' WHERE  1=1' + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.DIVISION_ID', 'EQ', @p_division_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.SITE_ID', 'EQ', @p_site_id)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PLANT_ID', 'EQ', @p_plant_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.FACTORY_ID', 'EQ', @p_factory_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PC_ITEM_ID', 'LK', @p_item_id)
    ) + char(10)
    SET @v_dsql += ' GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.PROD_VERSION_TYPE, A.PROD_TYPE, A.PC_ITEM_ID, A.MODEL_ID'
                   + char(10)
    SET @v_dsql += '       ) F' + char(10)
    SET @v_dsql += '          ON  A.COMPANY_ID      = F.COMPANY_ID' + char(10)
    SET @v_dsql += '          AND A.DIVISION_ID     = F.DIVISION_ID' + char(10)
    SET @v_dsql += '          AND A.SITE_ID         = F.SITE_ID' + char(10)
    SET @v_dsql += '          AND A.PLANT_ID        = F.PLANT_ID' + char(10)
    SET @v_dsql += '          AND A.FACTORY_ID     = F.FACTORY_ID' + char(10)
    SET @v_dsql += '          AND A.ITEM_ID         = F.PC_ITEM_ID' + char(10)
    SET @v_dsql += '          AND A.PROD_VERSION_TYPE = F.PROD_VERSION_TYPE' + char(10)
    SET @v_dsql += '          --AND (CASE WHEN PATINDEX(''%TEST'', A.PRODUCTION_TYPE) > 0 THEN ''TEST'' ELSE ''MASS'' END) <> F.PROD_TYPE'
                   + char(10)
    SET @v_dsql += '          AND A.CALC_TYPE <> F.PROD_TYPE' + char(10)
	*/

    SET @v_dsql += '          LEFT OUTER JOIN (' + char(10)
    SET @v_dsql += '             SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.ITEM_ID' + char(10)
    SET @v_dsql += '				, MAX(CASE WHEN A.TACT_TIME > 0 THEN ROUND(60/A.TACT_TIME, 0) ELSE 0 END) DAILY_CAPA_PPM' + char(10)
    SET @v_dsql += '				, MAX(CASE WHEN A.TACT_TIME > 0 THEN ROUND(60/(A.TACT_TIME*2), 0) ELSE 0 END) DAILY_CAPA_PPM2' + char(10)
    SET @v_dsql += '             FROM   SCM_TACT_TIME_M A WITH(NOLOCK)' + char(10)
    SET @v_dsql += '             WHERE  1=1' + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.DIVISION_ID', 'EQ', @p_division_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.SITE_ID', 'EQ', @p_site_id)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PLANT_ID', 'EQ', @p_plant_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.FACTORY_ID', 'EQ', @p_factory_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.OPERATION_ID', 'EQ', @p_operation_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.LINE_ID', 'EQ', @p_line_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.ITEM_ID', 'LK', @p_item_id)
    ) + char(10)
    SET @v_dsql += '             AND    A.MONTH = SUBSTRING(' + char(10)
    SET @v_dsql += '' + @v_plan_date + '' + char(10)
    SET @v_dsql += ',1,6)' + char(10)
    SET @v_dsql += '             GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.ITEM_ID'
                   + char(10)
    SET @v_dsql += ' ) Z' + char(10)
    SET @v_dsql += '          ON  A.COMPANY_ID      = Z.COMPANY_ID' + char(10)
    SET @v_dsql += '          AND A.DIVISION_ID     = Z.DIVISION_ID' + char(10)
    SET @v_dsql += '          AND A.SITE_ID         = Z.SITE_ID' + char(10)
    SET @v_dsql += '          AND A.PLANT_ID        = Z.PLANT_ID' + char(10)
    SET @v_dsql += '          AND A.FACTORY_ID      = Z.FACTORY_ID' + char(10)
    SET @v_dsql += '          AND A.OPERATION_ID    = Z.OPERATION_ID' + char(10)
    SET @v_dsql += '          AND A.LINE_ID         = Z.LINE_ID' + char(10)
    SET @v_dsql += '          AND A.ELECTRODE_TYPE  = Z.ELECTRODE_TYPE' + char(10)
    SET @v_dsql += '          AND A.ITEM_ID         = Z.ITEM_ID' + char(10)
    SET @v_dsql += '          LEFT OUTER HASH JOIN (' + char(10)
    SET @v_dsql += '                 SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.FOIL_CODE, A.FOIL, A.PROD_VERSION_TYPE, A.LINE_ID, A.PROD_TYPE' + char(10)
    SET @v_dsql += ' FROM   (' + char(10)
    SET @v_dsql += ' SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.FOIL_ID AS FOIL_CODE, B.ITEM_NAME AS FOIL, A.PROD_VERSION_TYPE, C.LINE_ID' + char(10)
    SET @v_dsql += '      , CASE WHEN LEFT(V.PROD_VERSION, 1) = ''Z'' THEN ''TEST'' ELSE ''MASS'' END AS PROD_TYPE' + char(10)
    SET @v_dsql += '      , ROW_NUMBER() OVER (  PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.PROD_VERSION_TYPE, C.LINE_ID' + char(10)
    SET @v_dsql += '      , CASE WHEN LEFT(V.PROD_VERSION, 1) = ''Z'' THEN ''TEST'' ELSE ''MASS'' END' + char(10)
    SET @v_dsql += ' ORDER BY V.APPLY_DATE DESC )  AS NUM' + char(10)
    SET @v_dsql += ' FROM  SCM_ITEM_FOIL_M        A WITH(NOLOCK)' + char(10)
    SET @v_dsql += '    ,FP_PROD_VERSION_M      V WITH(NOLOCK)' + char(10)
    SET @v_dsql += '    ,SCM_ITEM_M             B WITH(NOLOCK)' + char(10)
    SET @v_dsql += '    ,SCM_ITEM_LINE_ASSIGN_M C WITH(NOLOCK)' + char(10)
    SET @v_dsql += ' WHERE 1=1' + char(10)
    SET @v_dsql += ' AND   A.FACTORY_ID    = V.FACTORY_ID' + char(10)
    SET @v_dsql += ' AND   A.MODEL_ID      = V.MODEL_ID' + char(10)
    SET @v_dsql += ' AND   A.ITEM_ID       = V.ITEM_ID' + char(10)
    SET @v_dsql += ' AND   A.PROD_VERSION  = V.PROD_VERSION' + char(10)
    SET @v_dsql += ' AND   A.PROD_SEQ      = V.PROD_SEQ' + char(10)
    SET @v_dsql += ' AND   A.COMPANY_ID = B.COMPANY_ID' + char(10)
    SET @v_dsql += ' AND   A.DIVISION_ID = B.DIVISION_ID' + char(10)
    SET @v_dsql += ' AND   A.SITE_ID = B.SITE_ID' + char(10)
    SET @v_dsql += ' AND   A.FOIL_ID = B.ITEM_ID' + char(10)
    SET @v_dsql += ' AND   A.COMPANY_ID = C.COMPANY_ID' + char(10)
    SET @v_dsql += ' AND   A.DIVISION_ID = C.DIVISION_ID' + char(10)
    SET @v_dsql += ' AND   A.SITE_ID = C.SITE_ID' + char(10)
    SET @v_dsql += ' AND   A.PLANT_ID = C.PLANT_ID' + char(10)
    SET @v_dsql += ' AND   A.FACTORY_ID = C.FACTORY_ID' + char(10)
    SET @v_dsql += ' AND   A.ITEM_ID = C.ITEM_ID' + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.DIVISION_ID', 'EQ', @p_division_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.SITE_ID', 'EQ', @p_site_id)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PLANT_ID', 'EQ', @p_plant_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.FACTORY_ID', 'EQ', @p_factory_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('C.OPERATION_ID', 'EQ', @p_operation_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('C.LINE_ID', 'EQ', @p_line_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.ITEM_ID', 'LK', @p_item_id)
    ) + char(10)
    SET @v_dsql += ' ) A' + char(10)
    SET @v_dsql += ' WHERE  NUM = 1' + char(10)
    SET @v_dsql += ' ) G' + char(10)
    SET @v_dsql += '          ON 1=1' + char(10)
    SET @v_dsql += '          AND A.COMPANY_ID      = G.COMPANY_ID' + char(10)
    SET @v_dsql += '          AND A.DIVISION_ID     = G.DIVISION_ID' + char(10)
    SET @v_dsql += '          AND A.SITE_ID         = G.SITE_ID' + char(10)
    SET @v_dsql += '          AND A.PLANT_ID        = G.PLANT_ID' + char(10)
    SET @v_dsql += '          AND A.FACTORY_ID      = G.FACTORY_ID' + char(10)
    SET @v_dsql += '          AND A.LINE_ID         = G.LINE_ID' + char(10)
    SET @v_dsql += '         AND A.ITEM_ID         = G.ITEM_ID' + char(10)
    SET @v_dsql += '          AND A.PROD_VERSION_TYPE = G.PROD_VERSION_TYPE' + char(10)
    SET @v_dsql += '          --AND (CASE WHEN PATINDEX(''%TEST'', A.PRODUCTION_TYPE) > 0 THEN ''TEST'' ELSE ''MASS'' END) = G.PROD_TYPE  -- kimcd 2019-12-02'
                   + char(10)
    SET @v_dsql += '          AND A.CALC_TYPE = G.PROD_TYPE' + char(10)
/*
    SET @v_dsql += '   LEFT OUTER HASH JOIN (' + char(10)
    SET @v_dsql += '                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'
                   + char(10)
    SET @v_dsql += '                     , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID'
                   + char(10)
    SET @v_dsql += '                     --, A.TOP_ITEM_ID' + char(10)
    SET @v_dsql += '                     , A.ITEM_ID' + char(10)
    SET @v_dsql += '                 , MAX(ROUND(A.DAILY_CAPA_M,0)) AS DAILY_CAPA_M' + char(10)
    SET @v_dsql += '                 , MAX(ROUND(A.DAILY_CAPA_EA,0)) AS DAILY_CAPA_EA' + char(10)
    SET @v_dsql += '                 , MAX(ROUND(A.DAILY_CAPA_KG,0)) AS DAILY_CAPA_KG' + char(10)
    SET @v_dsql += '                 , MAX(ROUND(A.DAILY_CAPA_JR,0)) AS DAILY_CAPA_JR' + char(10)
    SET @v_dsql += '                 , MAX(ROUND(A.DAILY_CAPA_BATCH,3)) AS DAILY_CAPA_BATCH' + char(10)
    SET @v_dsql += '                 , MAX(CAPA_VALIDATION_FLAG) AS DC_FLAG' + char(10)
    SET @v_dsql += '               FROM   ' + @p_amend_capa_table + ' A WITH(NOLOCK)' + char(10)
    SET @v_dsql += '               WHERE  1=1' + char(10)
    SET @v_dsql += '               AND   A.INSTANCE_ID =' + char(10)
    SET @v_dsql += '' + @v_instance_id + '' + char(10)
    SET @v_dsql += '               AND    A.FP_PLAN_ID  =' + char(10)
    SET @v_dsql += '' + @v_plan_id + '' + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.DIVISION_ID', 'EQ', @p_division_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.SITE_ID', 'EQ', @p_site_id)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PLANT_ID', 'EQ', @p_plant_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.FACTORY_ID', 'EQ', @p_factory_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.OPERATION_ID', 'EQ', @p_operation_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.LINE_ID', 'EQ', @p_line_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.TOP_ITEM_ID', 'LK', @p_top_item_id)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.ITEM_ID', 'LK', @p_item_id)
    ) + char(10)
    SET @v_dsql += '          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + char(10)
    SET @v_dsql += '               , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID'
                   + char(10)
    --SET @v_dSql += '                                           --, A.TOP_ITEM_ID'+char(10)    
    SET @v_dsql += '               , A.ITEM_ID' + char(10)
    SET @v_dsql += ' ) H' + char(10)
    SET @v_dsql += ' ON  A.COMPANY_ID      = H.COMPANY_ID' + char(10)
    SET @v_dsql += ' AND A.DIVISION_ID     = H.DIVISION_ID' + char(10)
    SET @v_dsql += ' AND A.SITE_ID         = H.SITE_ID' + char(10)
    SET @v_dsql += ' AND A.PLANT_ID        = H.PLANT_ID' + char(10)
    SET @v_dsql += ' AND A.FACTORY_ID      = H.FACTORY_ID' + char(10)
    SET @v_dsql += ' AND A.LOCATION        = H.LOCATION' + char(10)
    SET @v_dsql += ' AND A.OPERATION_ID    = H.OPERATION_ID' + char(10)
    SET @v_dsql += ' AND A.LINE_ID         = H.LINE_ID' + char(10)
    SET @v_dsql += ' AND A.ELECTRODE_TYPE  = H.ELECTRODE_TYPE' + char(10)
    SET @v_dsql += ' AND A.EQUIPMENT_ID    = H.EQUIPMENT_ID' + char(10)
    SET @v_dsql += ' AND A.ITEM_ID         = H.ITEM_ID' + char(10)
*/
    SET @v_dsql += '    LEFT OUTER hash JOIN  (' + char(10)
    SET @v_dsql += '                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + char(10)
    SET @v_dsql += '                    , A.LOCATION, A.OPERATION_ID' + char(10)
    SET @v_dsql += '                    , A.LINE_ID' + char(10)
    SET @v_dsql += '                    , A.TOP_ITEM_ID, A.ITEM_ID' + char(10)
    SET @v_dsql += '                    , A.PRODUCTION_TYPE, A.MARKET' + char(10)
    SET @v_dsql += '                    , MIN(LINE_SEQ) LINE_SEQ' + char(10)
    SET @v_dsql += '                FROM (' + char(10)
    SET @v_dsql += '                    SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'
                   + char(10)
    SET @v_dsql += '                    , A.LOCATION, A.OPERATION_ID' + char(10)
    SET @v_dsql += '                    , A.LINE_ID' + char(10)
    SET @v_dsql += '                    , A.PLAN_DATE' + char(10)
    SET @v_dsql += '                    , A.TOP_ITEM_ID, A.ITEM_ID' + char(10)
    SET @v_dsql += '                    , A.PRODUCTION_TYPE, A.MARKET' + char(10)
    SET @v_dsql += '                    , A.SEQ' + char(10)
    SET @v_dsql += '                    , RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID'
                   + char(10)
    SET @v_dsql += '                                     ORDER     BY A.PLAN_DATE, A.SEQ ) LINE_SEQ' + char(10)
    SET @v_dsql += '               FROM   ' + @p_amend_table + ' A WITH(NOLOCK)' + char(10)
    SET @v_dsql += '               INNER JOIN SCM_ITEM_M B WITH(NOLOCK)' + char(10)
    SET @v_dsql += '               ON     A.COMPANY_ID     = B.COMPANY_ID' + char(10)
    SET @v_dsql += '               AND    A.DIVISION_ID    = B.DIVISION_ID' + char(10)
    SET @v_dsql += '               AND    A.SITE_ID        = B.SITE_ID' + char(10)
    SET @v_dsql += '               AND    A.ITEM_ID        = B.ITEM_ID' + char(10)
    SET @v_dsql += '               WHERE  INSTANCE_ID      =' + char(10)
    SET @v_dsql += '' + @v_instance_id + '' + char(10)
    SET @v_dsql += '               AND    FP_PLAN_ID       =' + char(10)
    SET @v_dsql += '' + @v_plan_id + '' + char(10)
    SET @v_dsql += '               AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN' + char(10)
    SET @v_dsql += '' + @v_bucket_from + '' + char(10)
    SET @v_dsql += ' AND' + char(10)
    SET @v_dsql += '' + @v_bucket_to + '' + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.DIVISION_ID', 'EQ', @p_division_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.SITE_ID', 'EQ', @p_site_id)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PLANT_ID', 'EQ', @p_plant_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.FACTORY_ID', 'EQ', @p_factory_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.OPERATION_ID', 'EQ', @p_operation_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.LINE_ID', 'EQ', @p_line_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.TOP_ITEM_ID', 'LK', @p_top_item_id)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.ITEM_ID', 'LK', @p_item_id)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PRODUCTION_TYPE', 'EQ', @p_prodtype_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PRODUCTION_TYPE', 'LK', @p_prod_type)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('B.NICK_NAME', 'LK', @p_nickname)
    ) + char(10)
    SET @v_dsql += '               AND  ISNULL(A.SEQ, 0) <> 0' + char(10)
    SET @v_dsql += '               AND  A.ADJUST_IN_QTY_BATCH > 0' + char(10)
    SET @v_dsql += '           ) A' + char(10)
    SET @v_dsql += '           GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + char(10)
    SET @v_dsql += '                          , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.TOP_ITEM_ID, A.ITEM_ID'
                   + char(10)
    SET @v_dsql += '                          , A.PRODUCTION_TYPE, A.MARKET' + char(10)
    SET @v_dsql += '       ) B' + char(10)
    SET @v_dsql += '        ON  A.COMPANY_ID      = B.COMPANY_ID' + char(10)
    SET @v_dsql += ' AND A.DIVISION_ID     = B.DIVISION_ID' + char(10)
    SET @v_dsql += ' AND A.SITE_ID         = B.SITE_ID' + char(10)
    SET @v_dsql += ' AND A.PLANT_ID        = B.PLANT_ID' + char(10)
    SET @v_dsql += ' AND A.FACTORY_ID      = B.FACTORY_ID' + char(10)
    SET @v_dsql += ' AND A.LOCATION        = B.LOCATION' + char(10)
    SET @v_dsql += ' AND A.OPERATION_ID    = B.OPERATION_ID' + char(10)
    SET @v_dsql += ' AND A.LINE_ID         = B.LINE_ID' + char(10)
    SET @v_dsql += ' AND A.TOP_ITEM_ID     = B.TOP_ITEM_ID' + char(10)
    SET @v_dsql += ' AND A.ITEM_ID         = B.ITEM_ID' + char(10)
    SET @v_dsql += ' AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE' + char(10)
    SET @v_dsql += ' AND A.MARKET          = B.MARKET' + char(10)
--    SET @v_dsql += '      )' + char(10)
    --SET @v_dsql += 'option (maxdop 1) ;' + char(10)
    SET @v_dsql += ';' + char(10)



    SET @v_dsql += 'with CAPA_VALUE AS (' + char(10)
    SET @v_dsql += '           SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID, A.ELECTRODE_TYPE' + char(10)
    SET @v_dsql += '                    , A.PLAN_DATE, A.YYYYMM, A.' + @WeekColumn + '' + char(10)
    SET @v_dsql += '                    , AVG(ISNULL(C.OFF_TIME,0)) AS OFF_TIME' + char(10)
    SET @v_dsql += '                    , AVG(ISNULL(C.SETUP_TIME,0)) AS SETUP_TIME' + char(10)
    SET @v_dsql += '                    , AVG(ISNULL(C.UTILIZATION,0)) AS UTILIZATION' + char(10)
    SET @v_dsql += '           FROM  (' + char(10)
    SET @v_dsql += ' SELECT  DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID, A.ELECTRODE_TYPE' + char(10)
    SET @v_dsql += ' , D.YYYYMMDD AS PLAN_DATE , D.YYYYMM, D.' + @WeekColumn + '' + char(10)
    SET @v_dsql += ' FROM  ' + @p_amend_table + ' A WITH(NOLOCK)' + char(10)
    SET @v_dsql += ' INNER JOIN SCM_ITEM_M B WITH(NOLOCK)' + char(10)
    SET @v_dsql += ' ON     A.COMPANY_ID     = B.COMPANY_ID' + char(10)
    SET @v_dsql += ' AND    A.DIVISION_ID    = B.DIVISION_ID' + char(10)
    SET @v_dsql += ' AND    A.SITE_ID        = B.SITE_ID' + char(10)
    SET @v_dsql += ' AND    A.ITEM_ID        = B.ITEM_ID' + char(10)
    SET @v_dsql += ' INNER JOIN TH_UIS_CAL D WITH(NOLOCK)' + char(10)
    SET @v_dsql += ' ON  1=1' + char(10)
    SET @v_dsql += ' AND D.YYYYMMDD BETWEEN' + char(10)
    SET @v_dsql += '' + @v_plan_date + '' + char(10)
    SET @v_dsql += ' AND' + char(10)
    SET @v_dsql += '' + @v_bucket_to + '' + char(10)
    SET @v_dsql += ' WHERE  INSTANCE_ID      =' + char(10)
    SET @v_dsql += '' + @v_instance_id + '' + char(10)
    SET @v_dsql += ' AND    FP_PLAN_ID       =' + char(10)
    SET @v_dsql += '' + @v_plan_id + '' + char(10)
    SET @v_dsql += ' AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN' + char(10)
    SET @v_dsql += '' + @v_bucket_from + '' + char(10)
    SET @v_dsql += ' AND' + char(10)
    SET @v_dsql += '' + @v_bucket_to + '' + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.DIVISION_ID', 'EQ', @p_division_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.SITE_ID', 'EQ', @p_site_id)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PLANT_ID', 'EQ', @p_plant_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.FACTORY_ID', 'EQ', @p_factory_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.OPERATION_ID', 'EQ', @p_operation_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.LINE_ID', 'EQ', @p_line_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.TOP_ITEM_ID', 'LK', @p_top_item_id)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.ITEM_ID', 'LK', @p_item_id)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PRODUCTION_TYPE', 'EQ', @p_prodtype_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PRODUCTION_TYPE', 'LK', @p_prod_type)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('B.NICK_NAME', 'LK', @p_nickname)
    ) + char(10)
    SET @v_dsql += ' ) A' + char(10)
    SET @v_dsql += '         LEFT OUTER JOIN (' + char(10)
    SET @v_dsql += '             SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID, A.ELECTRODE_TYPE' + char(10)
    SET @v_dsql += '                 , A.PLAN_DATE' + char(10)
    SET @v_dsql += '                 , A.OFF_TIME AS OFF_TIME' + char(10)
    SET @v_dsql += '                 , A.SETUP_TIME AS SETUP_TIME' + char(10)
    SET @v_dsql += '                 , A.UTILIZATION AS UTILIZATION' + char(10)
    SET @v_dsql += '           FROM   ' + @p_amend_util_table + ' A WITH(NOLOCK)' + char(10)
    SET @v_dsql += '           WHERE  A.INSTANCE_ID =' + char(10)
    SET @v_dsql += '' + @v_instance_id + '' + char(10)
    SET @v_dsql += '           AND    A.FP_PLAN_ID  =' + char(10)
    SET @v_dsql += '' + @v_plan_id + '' + char(10)
    SET @v_dsql += '           AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN' + char(10)
    SET @v_dsql += '' + @v_bucket_from + '' + char(10)
    SET @v_dsql += ' AND' + char(10)
    SET @v_dsql += '' + @v_bucket_to + '' + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.DIVISION_ID', 'EQ', @p_division_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.SITE_ID', 'EQ', @p_site_id)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PLANT_ID', 'EQ', @p_plant_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.FACTORY_ID', 'EQ', @p_factory_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.OPERATION_ID', 'EQ', @p_operation_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.LINE_ID', 'EQ', @p_line_lt)
    ) + char(10)
    SET @v_dsql += '       ) C' + char(10)
    SET @v_dsql += '       ON   1=1' + char(10)
    SET @v_dsql += '       AND    A.SITE_ID         = C.SITE_ID' + char(10)
    SET @v_dsql += '       AND    A.PLANT_ID        = C.PLANT_ID' + char(10)
    SET @v_dsql += '       AND    A.FACTORY_ID      = C.FACTORY_ID' + char(10)
    SET @v_dsql += '       AND    A.LOCATION        = C.LOCATION' + char(10)
    SET @v_dsql += '       AND    A.OPERATION_ID    = C.OPERATION_ID' + char(10)
    SET @v_dsql += '       AND    A.LINE_ID         = C.LINE_ID' + char(10)
    SET @v_dsql += '       AND    A.ELECTRODE_TYPE  = C.ELECTRODE_TYPE' + char(10)
    SET @v_dsql += '       AND    A.EQUIPMENT_ID    = C.EQUIPMENT_ID' + char(10)
    SET @v_dsql += '       AND    A.PLAN_DATE    = C.PLAN_DATE' + char(10)
    SET @v_dsql += '       GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID, A.ELECTRODE_TYPE'
                   + char(10)
    SET @v_dsql += '              , A.PLAN_DATE, A.YYYYMM, A.' + @WeekColumn + '' + char(10)
    SET @v_dsql += '      )' + char(10)
    SET @v_dsql += '      , T_MEMO AS (' + char(10)
    SET @v_dsql += '       SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + char(10)
    SET @v_dsql += '                , A.OPERATION_ID' + char(10)
    SET @v_dsql += '                , A.LINE_ID, A.ELECTRODE_TYPE' + char(10)
    SET @v_dsql += '                , A.EQUIPMENT_ID' + char(10)
    SET @v_dsql += '                , A.ITEM_ID, A.TOP_ITEM_ID' + char(10)
    SET @v_dsql += '                , A.PRODUCTION_TYPE, A.MARKET' + char(10)

    IF isnull(@p_day_info, '') <> ''
    BEGIN
        SET @mst_loop_cnt = 0
        SET @v_delimiter = '!' -- 데이터 구분자    
        SET @sub_v_delimiter = '#'
        SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)

        -- 프로시저 LOOP 길이를 판단    
        IF @max_loop_cnt > 0
        BEGIN
            -- bucket    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)

            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_day_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                --IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END    
                -- @sub_param_0 => MONth    
                -- @sub_param_0 => MONTH_NAME    
                -- @sub_param_0 => MONTH_COUNT    
                -- @sub_param_0 => M_VALUE    
                --SET @v_dSql += @tmp_column + '+++++++ffgs+++++++++++++++++' +char(10)    
                --SET @v_dSql += @sub_param_3 + '+++++++ffgs+++++++++++++++++' +char(10)    
                --SET @v_dSql += @p_plan_date + '++++++++++++++++++++++++' +char(10)    
                -- SAMPLE SET @v_dSql += '               , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_PLAN_DATE + ''' THEN ( CASE   WHEN B.CATEGORY_ID = ''I'' THEN A.EOH_QTY '+ char(10)    
                SET @v_dsql += '               , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)=''' + @sub_param_0
                               + ''' AND A.MEMO IS NOT NULL THEN ''Y'' ELSE NULL END) AS D'
                               + try_convert(nvarchar, @mst_loop_cnt - 1) + '_MO' + char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    
        END --end of @max_loop_cnt    
    END -- end of isnull(@p_day_info,'') <> ''    

    SET @v_dsql += '           FROM FP_AMEND_MEMO_M A WITH(NOLOCK)' + char(10)
    SET @v_dsql += '           WHERE 1=1' + char(10)
    SET @v_dsql += '           AND    A.INSTANCE_ID  =' + char(10)
    SET @v_dsql += '' + @v_instance_id + '' + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.DIVISION_ID', 'EQ', @p_division_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.SITE_ID', 'EQ', @p_site_id)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PLANT_ID', 'EQ', @p_plant_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.FACTORY_ID', 'EQ', @p_factory_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.OPERATION_ID', 'EQ', @p_operation_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.LINE_ID', 'EQ', @p_line_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.TOP_ITEM_ID', 'LK', @p_top_item_id)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.ITEM_ID', 'LK', @p_item_id)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PRODUCTION_TYPE', 'EQ', @p_prodtype_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PRODUCTION_TYPE', 'LK', @p_prod_type)
    ) + char(10)
    SET @v_dsql += '           GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + char(10)
    SET @v_dsql += ' , A.OPERATION_ID' + char(10)
    SET @v_dsql += ' , A.LINE_ID, A.ELECTRODE_TYPE' + char(10)
    SET @v_dsql += ' , A.EQUIPMENT_ID' + char(10)
    SET @v_dsql += ' , A.ITEM_ID, A.TOP_ITEM_ID' + char(10)
    SET @v_dsql += ' , A.PRODUCTION_TYPE, A.MARKET' + char(10)
    SET @v_dsql += '      )' + char(10)
    SET @v_dsql += '      , T_CHANGE AS (' + char(10)
    SET @v_dsql += '       SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + char(10)
    SET @v_dsql += '                    , A.LOCATION, A.OPERATION_ID' + char(10)
    SET @v_dsql += '                    , A.LINE_ID, A.ELECTRODE_TYPE' + char(10)
    SET @v_dsql += '                    , A.EQUIPMENT_ID' + char(10)
    SET @v_dsql += '                    , A.TOP_ITEM_ID, A.ITEM_ID' + char(10)
    SET @v_dsql += '                    , A.PRODUCTION_TYPE' + char(10)
    SET @v_dsql += '                    , A.MARKET' + char(10)

    IF isnull(@p_day_info, '') <> ''
    BEGIN
        SET @mst_loop_cnt = 0
        SET @v_delimiter = '!' -- 데이터 구분자    
        SET @sub_v_delimiter = '#'
        SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)

        -- 프로시저 LOOP 길이를 판단    
        IF @max_loop_cnt > 0
        BEGIN
            -- bucket    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)

            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_day_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                --IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END    
                -- @sub_param_0 => MONth    
                -- @sub_param_0 => MONTH_NAME    
                -- @sub_param_0 => MONTH_COUNT    
                -- @sub_param_0 => M_VALUE    
                --SET @v_dSql += @tmp_column + '+++++++ffgs+++++++++++++++++' +char(10)    
                --SET @v_dSql += @sub_param_3 + '+++++++ffgs+++++++++++++++++' +char(10)    
                --SET @v_dSql += @p_plan_date + '++++++++++++++++++++++++' +char(10)    
                -- SAMPLE SET @v_dSql += '               , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_PLAN_DATE + ''' THEN ( CASE   WHEN B.CATEGORY_ID = ''I'' THEN A.EOH_QTY '+ char(10)    
                SET @v_dsql += '               , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)=''' + @sub_param_0
                               + ''' THEN B.SETUP_COLOR ELSE NULL END) AS D' + try_convert(nvarchar, @mst_loop_cnt - 1)
                               + '_BG' + char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    
        END --end of @max_loop_cnt    
    END -- end of isnull(@p_day_info,'') <> ''    
    SET @v_dsql += '               FROM   ' + @p_amend_table + ' A WITH(NOLOCK)' + char(10)
    SET @v_dsql += '               LEFT OUTER JOIN (' + char(10)
    SET @v_dsql += '                      SELECT A.SEGMENT1 AS INSTANCE_ID, A.SEGMENT2 AS SETUP_COLOR_CODE, A.SEGMENT3 AS SETUP_COLOR_NAME, A.SEGMENT4 AS SETUP_COLOR, A.SORT_ORDER'
                   + char(10)
    SET @v_dsql += '                      FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)' + char(10)
    SET @v_dsql += '                      WHERE  A.LOOKUP_TYPE_CODE = ''UI_AMEND_COLOR''' + char(10)
    SET @v_dsql += '                      AND    A.ACTIVE_FLAG = ''Y''' + char(10)
    SET @v_dsql += '               ) B' + char(10)
    SET @v_dsql += '               ON A.INSTANCE_ID = B.INSTANCE_ID' + char(10)
    SET @v_dsql += '               AND A.SETUP_COLOR_CODE = B.SETUP_COLOR_CODE' + char(10)
    SET @v_dsql += '               WHERE  A.INSTANCE_ID      =' + char(10)
    SET @v_dsql += '' + @v_instance_id + '' + char(10)
    SET @v_dsql += '               AND    A.FP_PLAN_ID       =' + char(10)
    SET @v_dsql += '' + @v_plan_id + '' + char(10)
    SET @v_dsql += '               AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN' + char(10)
    SET @v_dsql += '' + @v_plan_date + '' + char(10)
    SET @v_dsql += ' AND' + char(10)
    SET @v_dsql += '' + @v_bucket_to + '' + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.DIVISION_ID', 'EQ', @p_division_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.SITE_ID', 'EQ', @p_site_id)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PLANT_ID', 'EQ', @p_plant_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.FACTORY_ID', 'EQ', @p_factory_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.OPERATION_ID', 'EQ', @p_operation_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.LINE_ID', 'EQ', @p_line_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.TOP_ITEM_ID', 'LK', @p_top_item_id)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.ITEM_ID', 'LK', @p_item_id)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PRODUCTION_TYPE', 'EQ', @p_prodtype_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PRODUCTION_TYPE', 'LK', @p_prod_type)
    ) + char(10)
    SET @v_dsql += '               AND  A.ADJUST_IN_QTY_BATCH > 0' + char(10)
    SET @v_dsql += '   GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + char(10)
    SET @v_dsql += '    , A.LOCATION, A.OPERATION_ID' + char(10)
    SET @v_dsql += '                    , A.LINE_ID, A.ELECTRODE_TYPE' + char(10)
    SET @v_dsql += '                    , A.EQUIPMENT_ID' + char(10)
    SET @v_dsql += '                    , A.TOP_ITEM_ID, A.ITEM_ID' + char(10)
    SET @v_dsql += '                    , A.PRODUCTION_TYPE' + char(10)
    SET @v_dsql += '                    , A.MARKET' + char(10)
    SET @v_dsql += '   )' + char(10)
    SET @v_dsql += '   , T_VERSION AS (' + char(10)
    SET @v_dsql += '      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + char(10)
    SET @v_dsql += '                , A.OPERATION AS OPERATION_ID' + char(10)
    SET @v_dsql += '                , A.MODEL_ID' + char(10)
    SET @v_dsql += '                , A.ITEM_ID' + char(10)
    SET @v_dsql += '                , A.PROD_VERSION_TYPE' + char(10)
    SET @v_dsql += '                , A.VERSION, A.VERSION_TYPE' + char(10)
    SET @v_dsql += '                , CASE WHEN A.CATEGORY = ''Pancake (m/batch)'' THEN ''M(P/C)''' + char(10)
    SET @v_dsql += '               WHEN A.CATEGORY = ''Jumbo Roll (m/batch)'' THEN ''J/R''' + char(10)
    SET @v_dsql += '               WHEN A.CATEGORY = ''cell/batch'' THEN ''Cell''' + char(10)
    SET @v_dsql += '               ELSE ''BATCH'' END AS CATEGORY' + char(10)
    SET @v_dsql += '                , MAX(A.VALUE) AS CAL' + char(10)
    SET @v_dsql += '         FROM    SCM_ITEM_CONV_CALC_M A WITH(NOLOCK)' + char(10)
    SET @v_dsql += '         WHERE   A.MAX_VER_FLAG = ''Y''' + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.DIVISION_ID', 'EQ', @p_division_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.SITE_ID', 'EQ', @p_site_id)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PLANT_ID', 'EQ', @p_plant_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.FACTORY_ID', 'EQ', @p_factory_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.OPERATION', 'EQ', @p_operation_lt)
    ) + char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.ITEM_ID', 'LK', @p_item_id)
    ) + char(10)
    SET @v_dsql += '   AND A.CATEGORY IN (''cell/batch'', ''Jumbo Roll (m/batch)'', ''Pancake (m/batch)'')' + char(10)
    SET @v_dsql += '           GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + char(10)
    SET @v_dsql += '               , A.OPERATION, A.MODEL_ID, A.ITEM_ID, A.PROD_VERSION_TYPE' + char(10)
    SET @v_dsql += '               , A.VERSION, A.VERSION_TYPE, A.CATEGORY' + char(10)
    SET @v_dsql += '   )' + char(10)
    SET @v_dsql += '      SELECT  A.*' + char(10)
    SET @v_dsql += '        , CASE WHEN A.DATA_TYPE = ''DATA'' THEN ROUND( ISNULL(G.CAL, ISNULL(dbo.FN_GET_CONVERT_CAL(A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID,  ISNULL(A.PC_MODEL_ID, B.APPLIED_MODEL), A.ITEM_ID, CASE WHEN A.FACTORY_ID NOT IN (''E2'', ''E3'', ''E5'',''E6'', ''EB'', ''EC'', ''ED'') THEN ''-'' ELSE A.VERSION END, ''-'', ISNULL(C.PROD_VERSION_TYPE,''GENERAL''), A.MEASURE_NAME )' + char(10)
    SET @v_dsql += '                              , dbo.FN_GET_CONVERT_CAL(A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID,  B.APPLIED_MODEL, A.ITEM_ID, CASE WHEN A.FACTORY_ID NOT IN (''E2'', ''E3'', ''E5'',''E6'', ''EB'', ''EC'', ''ED'') THEN ''-'' ELSE A.VERSION END, ''-'', ISNULL(C.PROD_VERSION_TYPE,''GENERAL''), A.MEASURE_NAME ) )) , 0)' + char(10)
    SET @v_dsql += '          ELSE NULL END AS CONVERSION' + char(10)
    SET @v_dsql += '        , DENSE_RANK() OVER(ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID) AS LV1' + char(10)
    --SET @v_dsql += '             , CASE WHEN A.DATA_TYPE = ''DATA'' AND B.APPLIED_MODEL = A.PC_MODEL_ID THEN NULL ELSE ISNULL(B.APPLIED_MODEL,''N/A'') END AS APPLIED_MODEL ' + char(10)
	SET @v_dsql += '             , B.APPLIED_MODEL' + char(10)
    --SET @v_dsql += '             , CASE WHEN A.DATA_TYPE = ''DATA'' AND B.APPLIED_MODEL = A.PC_MODEL_ID THEN NULL ELSE ISNULL(A.PC_MODEL_ID,''N/A'') END AS WORK_MODEL' + char(10)
    SET @v_dsql += '             , A.PC_MODEL_ID AS WORK_MODEL ' + char(10)
    SET @v_dsql += '             , ISNULL(C.PROD_VERSION_TYPE,''GENERAL'') AS PROD_VERSION_TYPE' + char(10)

    IF isnull(@p_day_info, '') <> ''
    BEGIN
        SET @mst_loop_cnt = 0
        SET @v_delimiter = '!' -- 데이터 구분자    
        SET @sub_v_delimiter = '#'
        SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)

        -- 프로시저 LOOP 길이를 판단    
        IF @max_loop_cnt > 0
        BEGIN
            -- bucket    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)

            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_day_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                --IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END    
                -- @sub_param_0 => MONth    
                -- @sub_param_0 => MONTH_NAME    
                -- @sub_param_0 => MONTH_COUNT    
                -- @sub_param_0 => M_VALUE    
                --SET @v_dSql += @tmp_column + '+++++++ffgs+++++++++++++++++' +char(10)    
                --SET @v_dSql += @sub_param_3 + '+++++++ffgs+++++++++++++++++' +char(10)    
                --SET @v_dSql += @p_plan_date + '++++++++++++++++++++++++' +char(10)    
                -- SAMPLE SET @v_dSql += '               , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_PLAN_DATE + ''' THEN ( CASE   WHEN B.CATEGORY_ID = ''I'' THEN A.EOH_QTY '+ char(10)    
                SET @v_dsql += '               , D.D' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_MO' + char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    

            -- bucket    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)

            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_day_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                --IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END    
                -- @sub_param_0 => MONth    
                -- @sub_param_0 => MONTH_NAME    
                -- @sub_param_0 => MONTH_COUNT    
                -- @sub_param_0 => M_VALUE    
                --SET @v_dSql += @tmp_column + '+++++++ffgs+++++++++++++++++' +char(10)    
                --SET @v_dSql += @sub_param_3 + '+++++++ffgs+++++++++++++++++' +char(10)    
                --SET @v_dSql += @p_plan_date + '++++++++++++++++++++++++' +char(10)    
                -- SAMPLE SET @v_dSql += '               , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_PLAN_DATE + ''' THEN ( CASE   WHEN B.CATEGORY_ID = ''I'' THEN A.EOH_QTY '+ char(10)    
                SET @v_dsql += '  , CASE WHEN A.DATA_TYPE=''TOTAL_2'' THEN ''#FFBA85''  ' + char(10)
                SET @v_dsql += '    WHEN A.DATA_TYPE=''TOTAL'' THEN ''#FFE5C2''  ' + char(10)
                --              //sql+="       WHEN A.DATA_TYPE = ''DATA'' AND PATINDEX(''%BATCH%'', A.CATEGORY_ID) > 0 AND A.D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + ' > 30 THEN ''#FF0000FF''   ' + char(10)    
                SET @v_dsql += '    WHEN ( A.CATEGORY_ID=''P_IN_BATCH'' OR A.CATEGORY_ID=''P_SEQ'' )  THEN (CASE WHEN E.D'
                               + try_convert(nvarchar, @mst_loop_cnt - 1) + '_BG IS NOT NULL THEN E.D'
                               + try_convert(nvarchar, @mst_loop_cnt - 1) + '_BG   ' + char(10)
                SET @v_dsql += '   WHEN ''' + @sub_param_0 + ''' >= ''' + @p_plan_date + ''' AND ''' + @p_plan_type
                               + ''' <> ''RELEASE'' THEN ( CASE WHEN A.DATA_TYPE = ''DATA'' AND R.FACTORY_ID IS NOT NULL THEN ''#FFFF0055'' ELSE '''' END )   '
                               + char(10)
                SET @v_dsql += '   ELSE '''' END )  ' + char(10)
                SET @v_dsql += '    WHEN A.CATEGORY_ID=''P_MPP_IN_BATCH'' OR A.CATEGORY_ID=''P_WPP_IN_BATCH'' THEN ( CASE WHEN '''
                               + @p_plan_type + ''' = ''RELEASE'' AND R_T.CURR_DATE <= ''' + @sub_param_0
                               + ''' AND R_T.IS_LATEST_PLAN = ''Y'' AND A.DATA_TYPE = ''DATA'' AND R.FACTORY_ID IS NOT NULL THEN ''#FFFF0055'' ELSE '''' END )   '
                               + char(10)
                SET @v_dsql += '    ELSE '''' END AS D' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_BG ' + char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    
        END --end of @max_loop_cnt    
    END -- end of isnull(@p_day_info,'') <> ''    

    --SET @v_dsql += '         , CASE WHEN A.DATA_TYPE = ''DATA'' /*AND H.PRODUCTION_TYPE IS NOT NULL */AND R.FACTORY_ID IS NOT NULL THEN ''Y'' ELSE ''N'' END AS EDIT_YN' + char(10)
	SET @v_dsql += '         , CASE WHEN RIGHT(' + @v_plan_id + ',2) = ''00'' THEN ''N'' WHEN A.DATA_TYPE = ''DATA'' AND R.FACTORY_ID IS NOT NULL THEN ''Y'' ELSE ''N'' END AS EDIT_YN' + char(10) -- 00 버전 입력 금지... 20231107
    SET @v_dsql += '         , B.ITEM_UOM' + char(10)
    
	SET @v_dSql += ' , ISNULL(WW.NICK_NAME,''-'') AS WORK_MODEL_NAME  ' + char(10) 
	SET @v_dSql += ' , WZ.SCP_EXTRA_SPEC  ' + char(10) 
	SET @v_dSql += ' , (CASE WHEN GG.VERSION IS NULL THEN ''N'' ELSE ''Y'' END) AS MAX_VER_FLAG ' + char(10) -- max version flag 추가... 20230905
	SET @v_dsql += '      FROM (' + char(10)
    SET @v_dsql += '          SELECT * FROM #MAIN' + char(10)
    SET @v_dsql += '          UNION ALL' + char(10)
    SET @v_dsql += '          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID' + char(10)
    SET @v_dsql += '                ,A.LINE_ID, ''Total'' AS LINE_NAME, A.ELECTRODE_TYPE, NULL AS EQUIPMENT_ID' + char(10)
    SET @v_dsql += '                ,NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME' + char(10)
    SET @v_dsql += '                ,NULL AS PRODUCTION_TYPE, NULL AS MARKET' + char(10)
    SET @v_dsql += '                ,NULL AS BATCH_ID, NULL AS BATCH_ID_2' + char(10)
    SET @v_dsql += '                ,NULL AS PRE_DISPERSION_ID' + char(10)
    SET @v_dsql += '                ,NULL AS PRE_DISPERSION_NAME' + char(10)
    SET @v_dsql += '                ,NULL AS PRE_DISPERSION_ID_2' + char(10)
    SET @v_dsql += '                ,NULL AS PRE_DISPERSION_NAME_2' + char(10)
    SET @v_dsql += '                ,NULL AS ACTIVE_MATERIAL_1, NULL AS ACTIVE_MATERIAL_2, NULL AS ACTIVE_MATERIAL_3' + char(10)
    SET @v_dsql += '                ,NULL AS BINDER_1, NULL AS BINDER_2, NULL AS BINDER_3' + char(10)
    SET @v_dsql += '                ,NULL AS CMC' + char(10)
    SET @v_dsql += '                ,NULL AS VERSION' + char(10)
    SET @v_dsql += '                ,NULL AS PC_MODEL_ID' + char(10)
    SET @v_dsql += '                ,NULL AS ADDITION_AGENT' + char(10)
    SET @v_dsql += '                ,NULL AS FOIL_CODE' + char(10)
    SET @v_dsql += '                ,NULL AS FOIL' + char(10)
    SET @v_dsql += '                ,NULL AS DC_PPM, NULL AS DC_M, NULL AS DC_CELL, NULL AS DC_KG, NULL AS DC_JR, NULL AS DC_BATCH' + char(10)
    SET @v_dsql += '                ,NULL AS DC_FLAG' + char(10)

    IF isnull(@p_day_info, '') <> ''
    BEGIN
        SET @mst_loop_cnt = 0
        SET @v_delimiter = '!' -- 데이터 구분자    
        SET @sub_v_delimiter = '#'
        SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)

        -- 프로시저 LOOP 길이를 판단    
        IF @max_loop_cnt > 0
        BEGIN
            -- monthinfo    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_month_info, @v_delimiter)

            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_month_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END --MONTH    
                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END --MONTH_NAME    
                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END --MONTH_COUNT    
                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END --M_VALUE    
                IF @sub_max_loop_cnt > 4
                BEGIN
                    SET @sub_param_4 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 5)
                END

                -- @sub_param_0 => MONth    
                -- @sub_param_0 => MONTH_NAME    
                -- @sub_param_0 => MONTH_COUNT    
                -- @sub_param_0 => M_VALUE    
                SET @v_dsql += '             , SUM(M' + try_convert(nvarchar, @mst_loop_cnt - 1) + ') AS M'
                               + try_convert(nvarchar, @mst_loop_cnt - 1) + char(10)
                SET @v_dsql += '             , NULL AS M' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_CR '
                               + char(10)
            --SET @mst_loop_cnt =  @mst_loop_cnt + 1    
            END -- end of @mst_loop_cnt < @max_loop_cnt    

            -- weekinfo    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_week_info, @v_delimiter)

            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_week_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                IF @sub_max_loop_cnt > 4
                BEGIN
                    SET @sub_param_4 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 5)
                END

                -- @sub_param_0 => WEEK    
                -- @sub_param_0 => WEEK_NAME    
                -- @sub_param_0 => WEEK_COUNT    
                -- @sub_param_0 => W_VALUE    
                -- @sub_param_0 => IS_DAY_VIEW        
                SET @v_dsql += '             , SUM(W' + try_convert(nvarchar, @mst_loop_cnt - 1) + ') AS W'
                               + try_convert(nvarchar, @mst_loop_cnt - 1) + char(10)
                SET @v_dsql += '             , NULL AS W' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_CR '
                               + char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    

            -- bucket    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)

            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_day_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                --IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END    
                -- @sub_param_0 => MONth    
                -- @sub_param_0 => MONTH_NAME    
                -- @sub_param_0 => MONTH_COUNT    
                -- @sub_param_0 => M_VALUE    
                --SET @v_dSql += @tmp_column + '+++++++ffgs+++++++++++++++++' +char(10)    
                --SET @v_dSql += @sub_param_3 + '+++++++ffgs+++++++++++++++++' +char(10)    
                --SET @v_dSql += @p_plan_date + '++++++++++++++++++++++++' +char(10)    
                SET @v_dsql += '             , SUM(D' + try_convert(nvarchar, @mst_loop_cnt - 1) + ') AS D'
                               + try_convert(nvarchar, @mst_loop_cnt - 1) + char(10)
                SET @v_dsql += '             , NULL AS D' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_CR '
                               + char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    
        END --end of @max_loop_cnt    
    END -- end of isnull(@p_day_info,'') <> ''    

    SET @v_dsql += '                , A.CATEGORY_NAME' + char(10)
    SET @v_dsql += '                , A.CATEGORY_ID' + char(10)
    SET @v_dsql += '                , A.CATEGORY_ORDER' + char(10)
    SET @v_dsql += '                , A.MEASURE_NAME' + char(10)
    SET @v_dsql += '                ,''TOTAL'' AS DATA_TYPE' + char(10)
    SET @v_dsql += '                , '''' LINE_SEQ' + char(10)
    SET @v_dsql += '                , NULL AS DPP_OMIT_ZERO, NULL AS MPP_OMIT_ZERO, NULL AS WPP_OMIT_ZERO, NULL AS RESULT_OMIT_ZERO' + char(10)
    SET @v_dsql += '                , NULL AS CALC_TYPE' + char(10)
    SET @v_dsql += '                , NULL AS PROD_SEQ' + char(10)
	SET @v_dsql += '                , NULL AS PLM_EC_NO' + char(10)
    SET @v_dsql += '          FROM   #MAIN A' + char(10)
    SET @v_dsql += '          WHERE  A.CATEGORY_ID <> ''P_SEQ''' + char(10)

    IF @bsubtotal <> 1
    BEGIN
        SET @v_dsql += 'AND 1=0' + char(10)
    END

    SET @v_dsql += '          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE'
                   + char(10)
    SET @v_dsql += '                  ,A.CATEGORY_NAME, A.CATEGORY_ID, A.CATEGORY_ORDER, A.MEASURE_NAME' + char(10)
    SET @v_dsql += '          -- Off Calendar, Setup' + char(10)
    SET @v_dsql += '          UNION ALL' + char(10)
    SET @v_dsql += '          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID'
                   + char(10)
    SET @v_dsql += '                ,A.LINE_ID, ''Total'' AS LINE_NAME, A.ELECTRODE_TYPE, NULL AS EQUIPMENT_ID'
                   + char(10)
    SET @v_dsql += '                ,NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME' + char(10)
    SET @v_dsql += '                ,NULL AS PRODUCTION_TYPE, NULL AS MARKET' + char(10)
    SET @v_dsql += '                ,NULL AS BATCH_ID, NULL AS BATCH_ID_2' + char(10)
    SET @v_dsql += '                ,NULL AS PRE_DISPERSION_ID' + char(10)
    SET @v_dsql += '                ,NULL AS PRE_DISPERSION_NAME' + char(10)
    SET @v_dsql += '                ,NULL AS PRE_DISPERSION_ID_2' + char(10)
    SET @v_dsql += '                ,NULL AS PRE_DISPERSION_NAME_2' + char(10)
    SET @v_dsql += '                ,NULL AS ACTIVE_MATERIAL_1, NULL AS ACTIVE_MATERIAL_2, NULL AS ACTIVE_MATERIAL_3'
                   + char(10)
    SET @v_dsql += '                ,NULL AS BINDER_1, NULL AS BINDER_2, NULL AS BINDER_3' + char(10)
    SET @v_dsql += '                ,NULL AS CMC' + char(10)
    SET @v_dsql += '                ,NULL AS VERSION' + char(10)
    SET @v_dsql += '                ,NULL AS PC_MODEL_ID' + char(10)
    SET @v_dsql += '                ,NULL AS ADDITION_AGENT' + char(10)
    SET @v_dsql += '                ,NULL AS FOIL_CODE' + char(10)
    SET @v_dsql += '                ,NULL AS FOIL' + char(10)
    SET @v_dsql += '                ,NULL AS DC_PPM, NULL AS DC_M, NULL AS DC_CELL, NULL AS DC_KG, NULL AS DC_JR, NULL AS DC_BATCH'
                   + char(10)
    SET @v_dsql += '                ,NULL AS DC_FLAG' + char(10)

    IF isnull(@p_day_info, '') <> ''
    BEGIN
        SET @mst_loop_cnt = 0
        SET @v_delimiter = '!' -- 데이터 구분자    
        SET @sub_v_delimiter = '#'
        SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)

        -- 프로시저 LOOP 길이를 판단    
        IF @max_loop_cnt > 0
        BEGIN
            -- monthinfo    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_month_info, @v_delimiter)

            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_month_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END --MONTH    
                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END --MONTH_NAME    
                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END --MONTH_COUNT    
                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END --M_VALUE    
                IF @sub_max_loop_cnt > 4
                BEGIN
                    SET @sub_param_4 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 5)
                END

                -- @sub_param_0 => MONth    
                -- @sub_param_0 => MONTH_NAME    
                -- @sub_param_0 => MONTH_COUNT    
                -- @sub_param_0 => M_VALUE    
                SET @v_dsql += '             , SUM(CASE WHEN A.YYYYMM=''' + @sub_param_0
                               + ''' THEN (CASE WHEN B.CATEGORY_ID=''OFF'' THEN A.OFF_TIME ELSE A.SETUP_TIME END) ELSE 0 END) AS M'
                               + try_convert(nvarchar, @mst_loop_cnt - 1) + char(10)
                SET @v_dsql += '             , NULL AS M' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_CR '
                               + char(10)
            --SET @mst_loop_cnt =  @mst_loop_cnt + 1    
            END -- end of @mst_loop_cnt < @max_loop_cnt    

            -- weekinfo    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_week_info, @v_delimiter)

            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_week_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                IF @sub_max_loop_cnt > 4
                BEGIN
                    SET @sub_param_4 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 5)
                END

                -- @sub_param_0 => WEEK    
                -- @sub_param_0 => WEEK_NAME    
                -- @sub_param_0 => WEEK_COUNT    
                -- @sub_param_0 => W_VALUE    
                -- @sub_param_0 => IS_DAY_VIEW        
                SET @v_dsql += '             , SUM(CASE WHEN A.' + @WeekColumn + '=''' + @sub_param_0
                               + ''' THEN (CASE WHEN B.CATEGORY_ID=''OFF'' THEN A.OFF_TIME ELSE A.SETUP_TIME END) ELSE 0 END) AS W'
                               + try_convert(nvarchar, @mst_loop_cnt - 1) + char(10)
                SET @v_dsql += '             , NULL AS W' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_CR '
                               + char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    

            -- bucket    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)

            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_day_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                --IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END    
                -- @sub_param_0 => MONth    
                -- @sub_param_0 => MONTH_NAME    
                -- @sub_param_0 => MONTH_COUNT    
                -- @sub_param_0 => M_VALUE    
                --SET @v_dSql += @tmp_column + '+++++++ffgs+++++++++++++++++' +char(10)    
                --SET @v_dSql += @sub_param_3 + '+++++++ffgs+++++++++++++++++' +char(10)    
                --SET @v_dSql += @p_plan_date + '++++++++++++++++++++++++' +char(10)    
                SET @v_dsql += '             , SUM(CASE WHEN A.PLAN_DATE=''' + @sub_param_0
                               + ''' THEN (CASE WHEN B.CATEGORY_ID=''OFF'' THEN A.OFF_TIME ELSE A.SETUP_TIME END) ELSE 0 END) AS D'
                               + try_convert(nvarchar, @mst_loop_cnt - 1) + char(10)
                SET @v_dsql += '             , NULL AS D' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_CR '
                               + char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    
        END --end of @max_loop_cnt    
    END -- end of isnull(@p_day_info,'') <> ''    

    SET @v_dsql += '                , B.CATEGORY_NAME' + char(10)
    SET @v_dsql += '                , B.CATEGORY_ID' + char(10)
    SET @v_dsql += '                , B.CATEGORY_ORDER' + char(10)
    SET @v_dsql += '                , B.MEASURE_NAME' + char(10)
    SET @v_dsql += '                ,''TOTAL'' AS DATA_TYPE' + char(10)
    SET @v_dsql += '                , '''' LINE_SEQ' + char(10)
    SET @v_dsql += '                , NULL AS DPP_OMIT_ZERO, NULL AS MPP_OMIT_ZERO, NULL AS WPP_OMIT_ZERO, NULL AS RESULT_OMIT_ZERO' + char(10)
    SET @v_dsql += '                , NULL AS CALC_TYPE' + char(10)
    SET @v_dsql += '                , NULL AS PROD_SEQ' + char(10)
	SET @v_dsql += '                , NULL AS PLM_EC_NO' + char(10)
    SET @v_dsql += '          FROM   CAPA_VALUE A' + char(10)
    SET @v_dsql += '          INNER JOIN (' + char(10)
    SET @v_dsql += '              SELECT ''OFF'' AS CATEGORY_ID, ''Off Cal.'' AS CATEGORY_NAME, '''' AS MEASURE_NAME, 100 AS CATEGORY_ORDER'
                   + char(10)
    SET @v_dsql += '              UNION ALL' + char(10)
    SET @v_dsql += '              SELECT ''SETUP'' AS CATEGORY_ID, ''M/C(min)'' AS CATEGORY_NAME, '''' AS MEASURE_NAME, 200 AS CATEGORY_ORDER'
                   + char(10)
    SET @v_dsql += '              UNION ALL' + char(10)
    SET @v_dsql += '              SELECT ''SIM_SETUP'' AS CATEGORY_ID, ''Simul M/C(min)'' AS CATEGORY_NAME, '''' AS MEASURE_NAME, 400 AS CATEGORY_ORDER'
                   + char(10)
    SET @v_dsql += '          ) B' + char(10)
    SET @v_dsql += '          ON 1=1' + char(10)
    SET @v_dsql += '          INNER HASH JOIN TH_UIS_CAL C WITH(NOLOCK)' + char(10)
    SET @v_dsql += '          ON  1=1' + char(10)
    SET @v_dsql += '          AND CONVERT(VARCHAR, C.YYYYMMDD, 112) BETWEEN' + char(10)
    SET @v_dsql += '' + @v_plan_date + '' + char(10)
    SET @v_dsql += ' AND' + char(10)
    SET @v_dsql += '' + @v_bucket_to + '' + char(10)
    SET @v_dsql += '          AND A.PLAN_DATE = C.YYYYMMDD' + char(10)

    IF @bsubtotal <> 1
    BEGIN
        SET @v_dsql += 'WHERE 1=0' + char(10)
    END

    SET @v_dsql += '          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE'
                   + char(10)
    SET @v_dsql += '                  ,B.CATEGORY_NAME, B.CATEGORY_ID, B.CATEGORY_ORDER, B.MEASURE_NAME' + char(10)
    SET @v_dsql += '          -- Capa' + char(10)
    SET @v_dsql += '          UNION ALL' + char(10)
    SET @v_dsql += '          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID'
                   + char(10)
    SET @v_dsql += '                ,A.LINE_ID, ''Total'' AS LINE_NAME, A.ELECTRODE_TYPE, NULL AS EQUIPMENT_ID'
                   + char(10)
    SET @v_dsql += '                ,NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME' + char(10)
    SET @v_dsql += '                ,NULL AS PRODUCTION_TYPE, NULL AS MARKET' + char(10)
    SET @v_dsql += '                ,NULL AS BATCH_ID, NULL AS BATCH_ID_2' + char(10)
    SET @v_dsql += '                ,NULL AS PRE_DISPERSION_ID' + char(10)
    SET @v_dsql += '                ,NULL AS PRE_DISPERSION_NAME' + char(10)
    SET @v_dsql += '                ,NULL AS PRE_DISPERSION_ID_2' + char(10)
    SET @v_dsql += '                ,NULL AS PRE_DISPERSION_NAME_2' + char(10)
    SET @v_dsql += '                ,NULL AS ACTIVE_MATERIAL_1, NULL AS ACTIVE_MATERIAL_2, NULL AS ACTIVE_MATERIAL_3'
                   + char(10)
    SET @v_dsql += '                ,NULL AS BINDER_1, NULL AS BINDER_2, NULL AS BINDER_3' + char(10)
    SET @v_dsql += '                ,NULL AS CMC' + char(10)
    SET @v_dsql += '                ,NULL AS VERSION' + char(10)
    SET @v_dsql += '                ,NULL AS PC_MODEL_ID' + char(10)
    SET @v_dsql += '                ,NULL AS ADDITION_AGENT' + char(10)
    SET @v_dsql += '                ,NULL AS FOIL_CODE' + char(10)
    SET @v_dsql += '                ,NULL AS FOIL' + char(10)
    SET @v_dsql += '                ,NULL AS DC_PPM, NULL AS DC_M, NULL AS DC_CELL, NULL AS DC_KG, NULL AS DC_JR, NULL AS DC_BATCH'
                   + char(10)
    SET @v_dsql += '                ,NULL AS DC_FLAG' + char(10)

    IF isnull(@p_day_info, '') <> ''
    BEGIN
        SET @mst_loop_cnt = 0
        SET @v_delimiter = '!' -- 데이터 구분자    
        SET @sub_v_delimiter = '#'
        SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)

        -- 프로시저 LOOP 길이를 판단    
        IF @max_loop_cnt > 0
        BEGIN
            -- monthinfo    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_month_info, @v_delimiter)

            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_month_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END --MONTH    
                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END --MONTH_NAME    
                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END --MONTH_COUNT    
                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END --M_VALUE    
                IF @sub_max_loop_cnt > 4
                BEGIN
                    SET @sub_param_4 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 5)
                END

                -- @sub_param_0 => MONth    
                -- @sub_param_0 => MONTH_NAME    
                -- @sub_param_0 => MONTH_COUNT    
                -- @sub_param_0 => M_VALUE    
                SET @v_dsql += '             , CEILING(AVG(CASE WHEN A.YYYYMM=''' + @sub_param_0
                               + ''' THEN A.UTILIZATION ELSE NULL END)*100)/100 AS M'
                               + try_convert(nvarchar, @mst_loop_cnt - 1) + char(10)
                SET @v_dsql += '             , CASE WHEN (CEILING(AVG(CASE WHEN A.YYYYMM=''' + @sub_param_0
                               + ''' THEN A.UTILIZATION ELSE NULL END)*100)/100) > 100 THEN ''red'' ELSE NULL END AS M'
                               + try_convert(nvarchar, @mst_loop_cnt - 1) + '_CR' + char(10)
            --SET @mst_loop_cnt =  @mst_loop_cnt + 1    
            END -- end of @mst_loop_cnt < @max_loop_cnt    

            -- weekinfo    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_week_info, @v_delimiter)

            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_week_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                IF @sub_max_loop_cnt > 4
                BEGIN
                    SET @sub_param_4 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 5)
                END

                -- @sub_param_0 => WEEK    
                -- @sub_param_0 => WEEK_NAME    
                -- @sub_param_0 => WEEK_COUNT    
                -- @sub_param_0 => W_VALUE    
                -- @sub_param_0 => IS_DAY_VIEW        
                SET @v_dsql += '             , CEILING(AVG(CASE WHEN A.' + @WeekColumn + '=''' + @sub_param_0
                               + ''' THEN A.UTILIZATION ELSE NULL END)*100)/100 AS W'
                               + try_convert(nvarchar, @mst_loop_cnt - 1) + char(10)
                SET @v_dsql += '             , CASE WHEN (CEILING(AVG(CASE WHEN A.' + @WeekColumn + '=''' + @sub_param_0
                               + ''' THEN A.UTILIZATION ELSE NULL END)*100)/100) > 100 THEN ''red'' ELSE NULL END AS W'
                               + try_convert(nvarchar, @mst_loop_cnt - 1) + '_CR' + char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    

            -- bucket    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)

            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_day_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                --IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END    
                -- @sub_param_0 => MONth    
                -- @sub_param_0 => MONTH_NAME    
                -- @sub_param_0 => MONTH_COUNT    
                -- @sub_param_0 => M_VALUE    
                --SET @v_dSql += @tmp_column + '+++++++ffgs+++++++++++++++++' +char(10)    
                --SET @v_dSql += @sub_param_3 + '+++++++ffgs+++++++++++++++++' +char(10)    
                --SET @v_dSql += @p_plan_date + '++++++++++++++++++++++++' +char(10)    
                SET @v_dsql += '             , CEILING(AVG(CASE WHEN A.PLAN_DATE=''' + @sub_param_0
                               + ''' THEN A.UTILIZATION ELSE NULL END)*100)/100 AS D'
                               + try_convert(nvarchar, @mst_loop_cnt - 1) + char(10)
                SET @v_dsql += '             , CASE WHEN (CEILING(AVG(CASE WHEN A.PLAN_DATE=''' + @sub_param_0
                               + ''' THEN A.UTILIZATION ELSE NULL END)*100)/100) > 100 THEN ''red'' ELSE NULL END AS D'
                               + try_convert(nvarchar, @mst_loop_cnt - 1) + '_CR' + char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    
        END --end of @max_loop_cnt    
    END -- end of isnull(@p_day_info,'') <> ''    

    SET @v_dsql += '                , B.CATEGORY_NAME' + char(10)
    SET @v_dsql += '                , B.CATEGORY_ID' + char(10)
    SET @v_dsql += '                , B.CATEGORY_ORDER' + char(10)
    SET @v_dsql += '                , B.MEASURE_NAME' + char(10)
    SET @v_dsql += '                ,''TOTAL'' AS DATA_TYPE' + char(10)
    SET @v_dsql += '                , '''' LINE_SEQ' + char(10)
    SET @v_dsql += '                , NULL AS DPP_OMIT_ZERO, NULL AS MPP_OMIT_ZERO, NULL AS WPP_OMIT_ZERO, NULL AS RESULT_OMIT_ZERO' + char(10)
    SET @v_dsql += '                , NULL AS CALC_TYPE' + char(10)
    SET @v_dsql += '                , NULL AS PROD_SEQ' + char(10)
	SET @v_dsql += '                , NULL AS PLM_EC_NO' + char(10)
    SET @v_dsql += '          FROM   CAPA_VALUE A' + char(10)
    SET @v_dsql += '          INNER JOIN (' + char(10)
    SET @v_dsql += '              SELECT ''CAPA'' AS CATEGORY_ID, ''Load(%)'' AS CATEGORY_NAME, '''' AS MEASURE_NAME, 300 AS CATEGORY_ORDER' + char(10)
    SET @v_dsql += '              UNION ALL' + char(10)
    SET @v_dsql += '              SELECT ''CAPA'' AS CATEGORY_ID, ''Simul Load(%)'' AS CATEGORY_NAME, '''' AS MEASURE_NAME, 500 AS CATEGORY_ORDER'
                   + char(10)
    SET @v_dsql += '          ) B' + char(10)
    SET @v_dsql += '          ON 1=1' + char(10)

    IF @bsubtotal <> 1
       OR @bcapa <> 1
    BEGIN
        SET @v_dsql += 'WHERE 1=0'
    END

    SET @v_dsql += '          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE'
                   + char(10)
    SET @v_dsql += '           ,B.CATEGORY_NAME, B.CATEGORY_ID, B.CATEGORY_ORDER, B.MEASURE_NAME' + char(10)
    SET @v_dsql += '          -- Total' + char(10)
    SET @v_dsql += '          UNION ALL' + char(10)
    SET @v_dsql += '          SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID, NULL AS FACTORY_ID, NULL AS LOCATION, NULL AS OPERATION_ID' + char(10)
    SET @v_dsql += '                ,NULL AS LINE_ID, ''Total'' AS LINE_NAME, NULL AS ELECTRODE_TYPE, NULL AS EQUIPMENT_ID' + char(10)
    SET @v_dsql += '                ,NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME' + char(10)
    SET @v_dsql += '                ,NULL AS PRODUCTION_TYPE, NULL AS MARKET' + char(10)
    SET @v_dsql += '                ,NULL AS BATCH_ID, NULL AS BATCH_ID_2' + char(10)
    SET @v_dsql += '                ,NULL AS PRE_DISPERSION_ID' + char(10)
    SET @v_dsql += '                ,NULL AS PRE_DISPERSION_NAME' + char(10)
    SET @v_dsql += '                ,NULL AS PRE_DISPERSION_ID_2' + char(10)
    SET @v_dsql += '                ,NULL AS PRE_DISPERSION_NAME_2' + char(10)
    SET @v_dsql += '                ,NULL AS ACTIVE_MATERIAL_1, NULL AS ACTIVE_MATERIAL_2, NULL AS ACTIVE_MATERIAL_3' + char(10)
    SET @v_dsql += '                ,NULL AS BINDER_1, NULL AS BINDER_2, NULL AS BINDER_3' + char(10)
    SET @v_dsql += '                ,NULL AS CMC' + char(10)
    SET @v_dsql += '                ,NULL AS VERSION' + char(10)
    SET @v_dsql += '                ,NULL AS PC_MODEL_ID' + char(10)
    SET @v_dsql += '                ,NULL AS ADDITION_AGENT' + char(10)
    SET @v_dsql += '                ,NULL AS FOIL_CODE' + char(10)
    SET @v_dsql += '                ,NULL AS FOIL' + char(10)
    SET @v_dsql += '                ,NULL AS DC_PPM, NULL AS DC_M, NULL AS DC_CELL, NULL AS DC_KG, NULL AS DC_JR, NULL AS DC_BATCH' + char(10)
    SET @v_dsql += '                ,NULL AS DC_FLAG' + char(10)

    IF isnull(@p_day_info, '') <> ''
    BEGIN
        SET @mst_loop_cnt = 0
        SET @v_delimiter = '!' -- 데이터 구분자    
        SET @sub_v_delimiter = '#'
        SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)

        -- 프로시저 LOOP 길이를 판단    
        IF @max_loop_cnt > 0
        BEGIN
            -- monthinfo    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_month_info, @v_delimiter)

            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_month_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END --MONTH    
                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END --MONTH_NAME    
                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END --MONTH_COUNT    
                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END --M_VALUE    
                IF @sub_max_loop_cnt > 4
                BEGIN
                    SET @sub_param_4 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 5)
                END

                -- @sub_param_0 => MONth    
                -- @sub_param_0 => MONTH_NAME    
                -- @sub_param_0 => MONTH_COUNT    
                -- @sub_param_0 => M_VALUE    
                SET @v_dsql += '             , SUM(M' + try_convert(nvarchar, @mst_loop_cnt - 1) + ') AS M'
                               + try_convert(nvarchar, @mst_loop_cnt - 1) + char(10)
                SET @v_dsql += '             , NULL AS M' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_CR '
                               + char(10)
            --SET @mst_loop_cnt =  @mst_loop_cnt + 1    
            END -- end of @mst_loop_cnt < @max_loop_cnt    

            -- weekinfo    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_week_info, @v_delimiter)

            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_week_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                IF @sub_max_loop_cnt > 4
                BEGIN
                    SET @sub_param_4 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 5)
                END

                -- @sub_param_0 => WEEK    
                -- @sub_param_0 => WEEK_NAME    
                -- @sub_param_0 => WEEK_COUNT    
                -- @sub_param_0 => W_VALUE    
                -- @sub_param_0 => IS_DAY_VIEW        
                SET @v_dsql += '             , SUM(W' + try_convert(nvarchar, @mst_loop_cnt - 1) + ') AS W'
                               + try_convert(nvarchar, @mst_loop_cnt - 1) + char(10)
                SET @v_dsql += '             , NULL AS W' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_CR '
                               + char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    

            -- bucket    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)

            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_day_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                --IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END    
                -- @sub_param_0 => MONth    
                -- @sub_param_0 => MONTH_NAME    
                -- @sub_param_0 => MONTH_COUNT    
                -- @sub_param_0 => M_VALUE    
                --SET @v_dSql += @tmp_column + '+++++++ffgs+++++++++++++++++' +char(10)    
                --SET @v_dSql += @sub_param_3 + '+++++++ffgs+++++++++++++++++' +char(10)    
                --SET @v_dSql += @p_plan_date + '++++++++++++++++++++++++' +char(10)    
                SET @v_dsql += '             , SUM(D' + try_convert(nvarchar, @mst_loop_cnt - 1) + ') AS D'
                               + try_convert(nvarchar, @mst_loop_cnt - 1) + char(10)
                SET @v_dsql += '             , NULL AS D' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_CR '
                               + char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    
        END --end of @max_loop_cnt    
    END -- end of isnull(@p_day_info,'') <> ''    

    SET @v_dsql += '                , A.CATEGORY_NAME' + char(10)
    SET @v_dsql += '                , A.CATEGORY_ID' + char(10)
    SET @v_dsql += '                , A.CATEGORY_ORDER' + char(10)
    SET @v_dsql += '                , A.MEASURE_NAME' + char(10)
    SET @v_dsql += '                ,''TOTAL_2'' AS DATA_TYPE' + char(10)
    SET @v_dsql += '                , '''' LINE_SEQ' + char(10)
    SET @v_dsql += '                , NULL AS DPP_OMIT_ZERO, NULL AS MPP_OMIT_ZERO, NULL AS WPP_OMIT_ZERO, NULL AS RESULT_OMIT_ZERO' + char(10)
    SET @v_dsql += '                , NULL AS CALC_TYPE' + char(10)
    SET @v_dsql += '                , NULL AS PROD_SEQ' + char(10)
	SET @v_dsql += '                , NULL AS PLM_EC_NO' + char(10)
    SET @v_dsql += '          FROM   #MAIN A' + char(10)
    SET @v_dsql += '          WHERE  A.CATEGORY_ID <> ''P_SEQ''' + char(10)

    IF @btotal <> 1
    BEGIN
        SET @v_dsql += 'AND 1=0' + char(10)
    END

    SET @v_dsql += '          GROUP BY A.CATEGORY_NAME, A.CATEGORY_ID, A.CATEGORY_ORDER, A.MEASURE_NAME' + char(10)
    SET @v_dsql += '      ) A' + char(10)
    SET @v_dsql += '      LEFT OUTER JOIN SCM_ITEM_M B WITH(NOLOCK)' + char(10)
    SET @v_dsql += '      ON  A.COMPANY_ID  = B.COMPANY_ID' + char(10)
    SET @v_dsql += '      AND A.DIVISION_ID = B.DIVISION_ID' + char(10)
    SET @v_dsql += '      AND A.SITE_ID     = B.SITE_ID' + char(10)
    SET @v_dsql += '      AND A.ITEM_ID     = B.ITEM_ID' + char(10)
    SET @v_dsql += '      LEFT OUTER JOIN SCM_LINE_M C WITH(NOLOCK)' + char(10)
    SET @v_dsql += '      ON     A.COMPANY_ID     = C.COMPANY_ID' + char(10)
    SET @v_dsql += '      AND    A.DIVISION_ID    = C.DIVISION_ID' + char(10)
    SET @v_dsql += '      AND    A.SITE_ID        = C.SITE_ID' + char(10)
    SET @v_dsql += '      AND    A.PLANT_ID       = C.PLANT_ID' + char(10)
    SET @v_dsql += '      AND    A.FACTORY_ID     = C.FACTORY_ID' + char(10)
    SET @v_dsql += '      AND    A.OPERATION_ID   = C.OPERATION_ID' + char(10)
    SET @v_dsql += '      AND    A.LINE_ID        = C.LINE_ID' + char(10)
    SET @v_dsql += '      AND    A.ELECTRODE_TYPE = C.ELECTRODE_TYPE' + char(10)
    SET @v_dsql += '      LEFT OUTER JOIN T_MEMO D WITH(NOLOCK)' + char(10)
    SET @v_dsql += '        ON  A.COMPANY_ID      = D.COMPANY_ID' + char(10)
    SET @v_dsql += '        AND A.DIVISION_ID     = D.DIVISION_ID' + char(10)
    SET @v_dsql += '        AND A.SITE_ID         = D.SITE_ID' + char(10)
    SET @v_dsql += '        AND A.PLANT_ID        = D.PLANT_ID' + char(10)
    SET @v_dsql += '        AND A.FACTORY_ID      = D.FACTORY_ID' + char(10)
    SET @v_dsql += '        AND A.OPERATION_ID    = D.OPERATION_ID' + char(10)
    SET @v_dsql += '        AND A.LINE_ID         = D.LINE_ID' + char(10)
    SET @v_dsql += '        AND A.ELECTRODE_TYPE  = D.ELECTRODE_TYPE' + char(10)
    SET @v_dsql += '        AND A.EQUIPMENT_ID    = D.EQUIPMENT_ID' + char(10)
    SET @v_dsql += '        AND A.PRODUCTION_TYPE = D.PRODUCTION_TYPE' + char(10)
    SET @v_dsql += '        AND A.MARKET          = D.MARKET' + char(10)
    SET @v_dsql += '        AND A.TOP_ITEM_ID     = D.TOP_ITEM_ID' + char(10)
    SET @v_dsql += '        AND A.ITEM_ID         = D.ITEM_ID' + char(10)
    SET @v_dsql += '        LEFT OUTER JOIN T_CHANGE E WITH(NOLOCK)' + char(10)
    SET @v_dsql += '        ON  A.COMPANY_ID      = E.COMPANY_ID' + char(10)
    SET @v_dsql += '        AND A.DIVISION_ID     = E.DIVISION_ID' + char(10)
    SET @v_dsql += '        AND A.SITE_ID         = E.SITE_ID' + char(10)
    SET @v_dsql += '        AND A.PLANT_ID        = E.PLANT_ID' + char(10)
    SET @v_dsql += '        AND A.FACTORY_ID      = E.FACTORY_ID' + char(10)
    SET @v_dsql += '        AND A.OPERATION_ID    = E.OPERATION_ID' + char(10)
    SET @v_dsql += '        AND A.LINE_ID         = E.LINE_ID' + char(10)
    SET @v_dsql += '        AND A.ELECTRODE_TYPE  = E.ELECTRODE_TYPE' + char(10)
    SET @v_dsql += '        AND A.EQUIPMENT_ID    = E.EQUIPMENT_ID' + char(10)
    SET @v_dsql += '        AND A.PRODUCTION_TYPE = E.PRODUCTION_TYPE' + char(10)
    SET @v_dsql += '        AND A.MARKET          = E.MARKET' + char(10)
    SET @v_dsql += '        AND A.TOP_ITEM_ID     = E.TOP_ITEM_ID' + char(10)
    SET @v_dsql += '        AND A.ITEM_ID         = E.ITEM_ID' + char(10)
    SET @v_dsql += '        LEFT OUTER JOIN T_VERSION G WITH(NOLOCK)' + char(10)
    SET @v_dsql += '        ON     A.COMPANY_ID     = G.COMPANY_ID' + char(10)
    SET @v_dsql += '        AND    A.DIVISION_ID    = G.DIVISION_ID' + char(10)
    SET @v_dsql += '        AND    A.SITE_ID        = G.SITE_ID' + char(10)
    SET @v_dsql += '        AND    A.PLANT_ID       = G.PLANT_ID' + char(10)
    SET @v_dsql += '        AND    A.FACTORY_ID     = G.FACTORY_ID' + char(10)
    SET @v_dsql += '        AND    A.OPERATION_ID   = G.OPERATION_ID' + char(10)
    SET @v_dsql += '        AND    ISNULL(A.PC_MODEL_ID, B.APPLIED_MODEL)  = G.MODEL_ID' + char(10)
    SET @v_dsql += '        AND    A.ITEM_ID        = G.ITEM_ID' + char(10)
    SET @v_dsql += '        AND    C.PROD_VERSION_TYPE = G.PROD_VERSION_TYPE' + char(10)
    SET @v_dsql += '        --AND    (CASE WHEN PATINDEX(''%TEST'', A.PRODUCTION_TYPE) > 0 THEN ''TEST'' ELSE ''MASS'' END) = G.VERSION_TYPE'
                   + char(10)
    SET @v_dsql += '        AND    A.CALC_TYPE      = G.VERSION_TYPE' + char(10)
    SET @v_dsql += '        AND    A.VERSION        = G.VERSION' + char(10)
    SET @v_dsql += '        AND    A.MEASURE_NAME   = G.CATEGORY' + char(10)
    SET @v_dsql += '        LEFT OUTER JOIN ' + char(10) -- max version flag 추가... 20230905
    SET @v_dsql += '        ( ' + char(10)
    SET @v_dsql += '        	SELECT GG.COMPANY_ID, GG.DIVISION_ID, GG.SITE_ID, GG.PLANT_ID, GG.FACTORY_ID ' + char(10)
    SET @v_dsql += '                 , GG.OPERATION_ID, GG.MODEL_ID, GG.ITEM_ID ' + char(10)
    SET @v_dsql += '                 , GG.PROD_VERSION_TYPE, GG.VERSION, GG.VERSION_TYPE ' + char(10)
    SET @v_dsql += '        	FROM   T_VERSION GG WITH(NOLOCK) ' + char(10)
    SET @v_dsql += '        	GROUP BY GG.COMPANY_ID, GG.DIVISION_ID, GG.SITE_ID, GG.PLANT_ID, GG.FACTORY_ID ' + char(10)
    SET @v_dsql += '                   , GG.OPERATION_ID, GG.MODEL_ID, GG.ITEM_ID ' + char(10)
    SET @v_dsql += '                   , GG.PROD_VERSION_TYPE, GG.VERSION, GG.VERSION_TYPE ' + char(10)
    SET @v_dsql += '        ) GG ' + char(10)
    SET @v_dsql += '        ON  A.COMPANY_ID        = GG.COMPANY_ID ' + char(10)
    SET @v_dsql += '        AND A.DIVISION_ID       = GG.DIVISION_ID ' + char(10)
    SET @v_dsql += '        AND A.SITE_ID           = GG.SITE_ID ' + char(10)
    SET @v_dsql += '        AND A.PLANT_ID          = GG.PLANT_ID ' + char(10)
    SET @v_dsql += '        AND A.FACTORY_ID        = GG.FACTORY_ID ' + char(10)
    SET @v_dsql += '        AND A.OPERATION_ID      = GG.OPERATION_ID ' + char(10)
    SET @v_dsql += '        AND ISNULL(A.PC_MODEL_ID, B.APPLIED_MODEL) = GG.MODEL_ID ' + char(10)
    SET @v_dsql += '        AND A.ITEM_ID           = GG.ITEM_ID ' + char(10)
    SET @v_dsql += '        AND C.PROD_VERSION_TYPE = GG.PROD_VERSION_TYPE ' + char(10)
    SET @v_dsql += '        AND A.CALC_TYPE         = GG.VERSION_TYPE ' + char(10)
    SET @v_dsql += '        AND A.VERSION           = GG.VERSION ' + char(10)
    SET @v_dsql += '        LEFT OUTER JOIN' + char(10)
    SET @v_dsql += '       (' + char(10)
    SET @v_dsql += '         SELECT DISTINCT  A.SEGMENT1 AS DIVISION_ID, A.ATTRIBUTE2 AS PRODUCTION_TYPE' + char(10)
    SET @v_dsql += '         FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)' + char(10)
    SET @v_dsql += '         WHERE  A.LOOKUP_TYPE_CODE = ''DIVISION_DEMAND_TYPE''' + char(10)
    SET @v_dsql += '         AND    A.ACTIVE_FLAG = ''Y''' + char(10)
    SET @v_dsql += '       ) H' + char(10)
    SET @v_dsql += '       ON A.DIVISION_ID = H.DIVISION_ID' + char(10)
    SET @v_dsql += '       AND A.PRODUCTION_TYPE = H.PRODUCTION_TYPE' + char(10)
    SET @v_dsql += '       AND (CASE WHEN A.SITE_ID <> ''A004'' AND A.PRODUCTION_TYPE IN (''E-TEST'',''D-TEST'') THEN ''XX'' ELSE A.PRODUCTION_TYPE END ) = H.PRODUCTION_TYPE'
                   + char(10)
    SET @v_dsql += '       LEFT OUTER JOIN (' + char(10)
    SET @v_dsql += '            SELECT CONVERT(VARCHAR, dbo.FN_SITE_TIME(' + char(10)
    SET @v_dsql += '' + @v_fp_site_id + '' + char(10)
    SET @v_dsql += ')-( SELECT ISNULL(LLL2._DAY, CONVERT(NUMERIC,ISNULL(LLL.SEGMENT1,''0''))) AS _DAY' + char(10)
    SET @v_dsql += '                                                                FROM   SCM_SYS_LOOKUP_VALUE LLL WITH(NOLOCK)'
                   + char(10)
    SET @v_dsql += '                                                                LEFT OUTER JOIN (' + char(10)
    SET @v_dsql += '                                                               SELECT CONVERT(NUMERIC,ISNULL(SEGMENT1,''0'')) AS _DAY'
                   + char(10)
    SET @v_dsql += '                                                               FROM   SCM_SYS_LOOKUP_VALUE LLL2 WITH(NOLOCK)'
                   + char(10)
    SET @v_dsql += '                                                               WHERE  LLL2.LOOKUP_TYPE_CODE = ''WPP_DAY_RANGE_BY_INSTANCE'''
                   + char(10)
    SET @v_dsql += '                                                               AND    LLL2.ACTIVE_FLAG = ''Y'''
                   + char(10)
    SET @v_dsql += '                                                               AND    LLL2.SEGMENT2 =' + char(10)
    SET @v_dsql += '' + @v_master_id + '' + char(10)
    SET @v_dsql += '                                                                ) LLL2' + char(10)
    SET @v_dsql += '                                                                ON 1=1' + char(10)
    SET @v_dsql += '                                                                WHERE LLL.LOOKUP_TYPE_CODE = ''WPP_DAY_RANGE'') ,112) AS CURR_DATE'
                   + char(10)
    SET @v_dsql += '                 , A.RELEASE_PLAN_ID, (CASE WHEN A.RELEASE_PLAN_ID =' + char(10)
    SET @v_dsql += '' + @v_plan_id + '' + char(10)
    SET @v_dsql += ' THEN ''Y'' ELSE ''N'' END) AS IS_LATEST_PLAN, A.RELEASE_TYPE AS RELEASE_VALUE' + char(10)
    SET @v_dsql += '            FROM (' + char(10)
    SET @v_dsql += '             SELECT A.*' + char(10)
    SET @v_dsql += '                , ROW_NUMBER() OVER (ORDER BY A.INSERT_TIME DESC) AS ROW_NUM' + char(10)
    SET @v_dsql += '                , B.RELEASE_TYPE' + char(10)
    SET @v_dsql += '             FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)' + char(10)
    SET @v_dsql += '             INNER JOIN (' + char(10)
    SET @v_dsql += '               SELECT RR.INSTANCE_ID, (CASE WHEN RR.FACTORY_ID =''-'' THEN RR.PLAN_GROUP_ID ELSE RR.FACTORY_ID END) AS RELEASE_TYPE'
                   + char(10)
    SET @v_dsql += '               FROM   FP_RELEASE_PLAN_INFO_H RR WITH(NOLOCK)' + char(10)
    SET @v_dsql += '               WHERE  INSTANCE_ID     =' + char(10)
    SET @v_dsql += '' + @v_master_id + '' + char(10)
    SET @v_dsql += '               AND    RELEASE_PLAN_ID =' + char(10)
    SET @v_dsql += '' + @v_plan_id + '' + char(10)
    SET @v_dsql += '             ) B' + char(10)
    SET @v_dsql += '             ON  A.INSTANCE_ID = B.INSTANCE_ID' + char(10)
    SET @v_dsql += '             AND (CASE WHEN' + char(10)
    SET @v_dsql += '' + @v_confirm_area + '' + char(10)
    SET @v_dsql += ' = ''BUILDING'' THEN A.FACTORY_ID ELSE A.PLAN_GROUP_ID END) = B.RELEASE_TYPE' + char(10)
    SET @v_dsql += '            ) A' + char(10)
    SET @v_dsql += '            WHERE A.ROW_NUM = 1' + char(10)
    SET @v_dsql += '    ) R_T' + char(10)
    SET @v_dsql += '    ON 1=1' + char(10)
    SET @v_dsql += '    LEFT OUTER JOIN (' + char(10)
    SET @v_dsql += ' SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID, R.LINE_ID'
                   + char(10)
    SET @v_dsql += ' FROM FP_USER_ROLE_INFO_V R WITH(NOLOCK)' + char(10)
    SET @v_dsql += ' WHERE 1=1' + char(10)
    SET @v_dsql += ' AND R.USER_ID =' + char(10)
    SET @v_dsql += '' + @v_user_id + '' + char(10)
    SET @v_dsql += ' AND R.SAVE_FLAG = ''Y''' + char(10)
    SET @v_dsql += ' AND R.INSTANCE_ID =' + char(10)
    SET @v_dsql += '' + @v_master_id + '' + char(10)
    SET @v_dsql += '    ) R' + char(10)
    SET @v_dsql += '    ON 1=1' + char(10)
    SET @v_dsql += '    AND A.COMPANY_ID = R.COMPANY_ID' + char(10)
    SET @v_dsql += '    AND A.DIVISION_ID = R.DIVISION_ID' + char(10)
    SET @v_dsql += '    AND A.SITE_ID = R.SITE_ID' + char(10)
    SET @v_dsql += '    AND A.PLANT_ID = R.PLANT_ID' + char(10)
    SET @v_dsql += '    AND A.FACTORY_ID = R.FACTORY_ID' + char(10)
    SET @v_dsql += '    AND A.OPERATION_ID = R.OPERATION_ID' + char(10)
    SET @v_dsql += '    AND A.LINE_ID = R.LINE_ID' + char(10)
    
	 --KIMSI 22.07.15
	---------------------------------------------------------------------------------
	SET @v_dSql += ' LEFT OUTER JOIN SCM_ITEM_M WW WITH(NOLOCK) '+char(10)
	SET @v_dSql += ' ON  A.COMPANY_ID  = WW.COMPANY_ID '+char(10)
	SET @v_dSql += ' AND A.DIVISION_ID = WW.DIVISION_ID '+char(10)
	SET @v_dSql += ' AND A.SITE_ID     = WW.SITE_ID '+char(10)
	--SET @v_dSql += ' AND (CASE WHEN A.DATA_TYPE = ''DATA'' AND B.APPLIED_MODEL = A.PC_MODEL_ID THEN NULL ELSE ISNULL(A.PC_MODEL_ID,''N/A'') END) = WW.ITEM_ID '+char(10)
	SET @v_dSql += ' AND A.PC_MODEL_ID = WW.ITEM_ID ' + char(10)
	---------------------------------------------------------------------------------
	--KIMSI 22.07.15
	SET @v_dSql += ' LEFT OUTER JOIN SCM_ITEM_M WZ WITH(NOLOCK) '+char(10)
	SET @v_dSql += ' ON  B.COMPANY_ID  = WZ.COMPANY_ID '+char(10)
	SET @v_dSql += ' AND B.DIVISION_ID = WZ.DIVISION_ID '+char(10)
	SET @v_dSql += ' AND B.SITE_ID     = WZ.SITE_ID '+char(10)
	SET @v_dSql += ' AND B.APPLIED_MODEL     = WZ.ITEM_ID '+char(10)
	SET @v_dSql += ' AND  WZ.SCP_EXTRA_SPEC IS NOT NULL'+char(10)
	
	SET @v_dsql += ' ORDER BY (CASE WHEN A.DATA_TYPE = ''TOTAL_2'' THEN A.CATEGORY_ORDER ELSE 999 END)' + char(10)
    SET @v_dsql += '             , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID'
                   + char(10)
    SET @v_dsql += '             , (CASE WHEN A.DATA_TYPE=''DATA'' THEN 1 ELSE A.CATEGORY_ORDER END), LV1' + char(10)
    SET @v_dsql += '             , (CASE WHEN A.TOP_ITEM_ID=''NONE'' THEN ''0'' ELSE LINE_SEQ END)' + char(10)
    --SET @v_dSql += '             --, LINE_SEQ'+char(10)    
    SET @v_dsql += '             , A.EQUIPMENT_ID, A.TOP_ITEM_ID, A.ITEM_ID' + char(10)
    SET @v_dsql += '             , A.PRODUCTION_TYPE, A.MARKET, A.ELECTRODE_TYPE' + char(10)
	SET @v_dsql += '             , A.VERSION, A.PROD_SEQ' + char(10)
    SET @v_dsql += '             , A.CATEGORY_ORDER' + char(10)

	-- 임시테이블 삭제
	SET @v_dsql += '; ' + char(10)+ char(10)
	SET @v_dsql += 'if object_id(''tempdb..#MAIN'') is not null ' + char(10)
	SET @v_dsql += '	DROP TABLE #MAIN ' + char(10)
    
    IF @p_sys_type = 'SQL'
    BEGIN
        -- return SQL Query Source    
        --SELECT @v_dsql AS [QUERY_VALUE]
		SELECT @v_dSql FOR XML PATH('') 
    END
    ELSE
    BEGIN
        SET @runstart = Getdate()

        BEGIN try
            BEGIN TRAN

            -- run dynamic sql    
            EXEC sp_executesql @v_dsql

            COMMIT TRAN
        END try
        BEGIN catch
            ROLLBACK

            SET @runend = Getdate()

            /*EXEC pr_ui_sql_log @v_proc_name,
                               @p_user_id,
                               '',
                               '',
                               @v_dsql,
                               'rollback error',
                               @runstart,
                               @runend*/
        END catch

        SET @runend = Getdate()

        -- Record sql query    
        --EXEC pr_ui_sql_log @v_proc_name,
        --                   @p_user_id,
        --                   '',
        --                   '',
        --                   @v_dsql,
        --                   'select',
        --                   @runstart,
        --                   @runend
    END
END
