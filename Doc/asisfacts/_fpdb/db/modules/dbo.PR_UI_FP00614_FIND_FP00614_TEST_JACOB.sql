

CREATE PROCEDURE [dbo].[PR_UI_FP00614_FIND_FP00614_TEST_JACOB]
  @p_sys_type			NVARCHAR(MAX),  
  @p_sys_flag			NVARCHAR(MAX),
  @p_sys_gubun			NVARCHAR(MAX),  
  @p_user_id			NVARCHAR(MAX),
  @in_columns           NVARCHAR(MAX),
  @in_row               NVARCHAR(MAX),
  @opt_none             NVARCHAR(5) = 'N'
WITH EXEC AS CALLER
AS


BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SET NOCOUNT ON; 
SET XACT_ABORT ON;

DECLARE @p_plan_date     NVARCHAR(100) = ''
DECLARE @p_instance_id   NVARCHAR(100) = ''
DECLARE @p_amend_instance   NVARCHAR(100) = ''
DECLARE @p_amend_flag   NVARCHAR(100) = ''
DECLARE @p_amend_main_flag   NVARCHAR(100) = ''
DECLARE @p_use_wow_status   NVARCHAR(100) = ''
DECLARE @p_is_same_plan_id   NVARCHAR(100) = ''
DECLARE @p_basis_start_time   NVARCHAR(100) = ''
DECLARE @p_all_line   NVARCHAR(100) = ''
DECLARE @p_plan_id       NVARCHAR(100) = ''
DECLARE @p_division_id   NVARCHAR(1000) = ''
DECLARE @p_site_id       NVARCHAR(1000) = ''
DECLARE @p_plant_id      NVARCHAR(2000) = ''
DECLARE @p_factory_id    NVARCHAR(2000) = ''
DECLARE @p_line_id       NVARCHAR(max) = ''
DECLARE @p_curr_date_col nvarchar(max) = ''
DECLARE @p_operation_id  NVARCHAR(max) = ''
DECLARE @p_top_item_id   NVARCHAR(100) = ''
DECLARE @p_item_id       NVARCHAR(100) = ''
DECLARE @p_model_lt      NVARCHAR(max) = ''
DECLARE @p_nick_name     NVARCHAR(100) = ''
DECLARE @p_nick_name_lt  NVARCHAR(max) = ''
DECLARE @p_prod_type     NVARCHAR(max) = ''
DECLARE @p_prodtype_id   NVARCHAR(max) = ''
DECLARE @p_cell_group    NVARCHAR(100) = ''
DECLARE @p_confirm_area  NVARCHAR(100) = ''
DECLARE @p_curr_date     NVARCHAR(100) = ''                        
DECLARE @p_bucket_from   NVARCHAR(100) = ''
DECLARE @p_bucket_to     NVARCHAR(100) = ''
DECLARE @p_bucket        NVARCHAR(max) = ''
DECLARE @p_day_info      NVARCHAR(max) = ''
DECLARE @p_week_info     NVARCHAR(max) = ''
DECLARE @p_month_info    NVARCHAR(max) = ''
DECLARE @p_cate_info     NVARCHAR(max) = ''
DECLARE @p_cate_value    NVARCHAR(max) = ''
DECLARE @p_cate_type     NVARCHAR(max) = ''
DECLARE @p_day2week      NVARCHAR(max) = ''
DECLARE @p_day2month     NVARCHAR(max) = ''

--DECLARE BASE PARAMETER START
DECLARE @runstart          datetime
DECLARE @runend            datetime
DECLARE @v_Err             NVARCHAR(max)
DECLARE @v_Log             NVARCHAR(max) 
DECLARE @v_proc_name       NVARCHAR(100) = 'PR_UI_FP00614_FIND_FP00614'


DECLARE @v_plan_date       NVARCHAR(100)
DECLARE @v_instance_id     NVARCHAR(100)
DECLARE @v_amend_instance   NVARCHAR(100)
DECLARE @v_amend_flag   NVARCHAR(100)
DECLARE @v_amend_main_flag   NVARCHAR(100)
DECLARE @v_use_wow_status   NVARCHAR(100)
DECLARE @v_is_same_plan_id   NVARCHAR(100)
DECLARE @v_basis_start_time   NVARCHAR(100)
DECLARE @v_all_line   NVARCHAR(100)
DECLARE @v_plan_id         NVARCHAR(100)
DECLARE @v_division_id     NVARCHAR(1000)
DECLARE @v_site_id         NVARCHAR(1000)
DECLARE @v_plant_id        NVARCHAR(2000)
DECLARE @v_factory_id      NVARCHAR(2000)
DECLARE @v_line_id         NVARCHAR(max)
DECLARE @v_curr_date_col         NVARCHAR(max)  
DECLARE @v_operation_id    NVARCHAR(max)
DECLARE @v_top_item_id     NVARCHAR(100)
DECLARE @v_item_id         NVARCHAR(100)
DECLARE @v_model_lt        NVARCHAR(max)
DECLARE @v_nick_name       NVARCHAR(100)
DECLARE @v_nick_name_lt    NVARCHAR(max)
DECLARE @v_prod_type       NVARCHAR(max)
DECLARE @v_prodtype_id     NVARCHAR(max)
DECLARE @v_cell_group      NVARCHAR(100)  --Pjr Group
DECLARE @v_confirm_area    NVARCHAR(100)
DECLARE @v_curr_date       NVARCHAR(100)
DECLARE @v_bucket_from     NVARCHAR(100)
DECLARE @v_bucket_to       NVARCHAR(100)
DECLARE @v_bucket          NVARCHAR(max)
DECLARE @v_day_info        NVARCHAR(max)
DECLARE @v_week_info       NVARCHAR(max)
DECLARE @v_month_info      NVARCHAR(max)
DECLARE @v_cate_info       NVARCHAR(MAX)
DECLARE @v_cate_value      NVARCHAR(MAX)
DECLARE @v_cate_type       NVARCHAR(MAX)
DECLARE @v_day2week        NVARCHAR(max)
DECLARE @v_day2month       NVARCHAR(max)
DECLARE @v_user_id         NVARCHAR(max)
--DECLARE BASE PARAMETER START END

--Optional Parameter Part START
DECLARE @v_dSql                 NVARCHAR(MAX)=''

DECLARE @v_SqlsubTotal          NVARCHAR(MAX)=''
DECLARE @v_SqlTotal             NVARCHAR(MAX)=''

DECLARE @v_Tmp1                 NVARCHAR(MAX)=''
DECLARE @v_Tmp2                 NVARCHAR(MAX)=''
DECLARE @v_Tmp3                 NVARCHAR(MAX)=''
DECLARE @v_Tmp4                 NVARCHAR(MAX)=''
DECLARE @v_Tmp5                 NVARCHAR(MAX)=''

DECLARE @v_pSql                 NVARCHAR(MAX)=''
DECLARE @v_sSql                 NVARCHAR(MAX)=''

DECLARE @bGapIn				  NVARCHAR(2)= ''
DECLARE @bGapOut                NVARCHAR(2)= ''
DECLARE @bGapInTot              NVARCHAR(2)= ''
DECLARE @bGapOutTot             NVARCHAR(2)= ''
DECLARE @bInqty                 NVARCHAR(2)= ''
DECLARE @bOutqty                NVARCHAR(2)= ''
DECLARE @bMppInqty              NVARCHAR(2)= ''
DECLARE @bMppOutqty             NVARCHAR(2)= ''
DECLARE @bWppInqty              NVARCHAR(2)= ''
DECLARE @bWppOutqty             NVARCHAR(2)= ''
DECLARE @bResultIn              NVARCHAR(2)= ''
DECLARE @bResultOut             NVARCHAR(2)= ''
DECLARE @bSeq                   NVARCHAR(2)= ''
DECLARE @bMemo                  NVARCHAR(2)= ''
DECLARE @bOffTime               NVARCHAR(2)= ''
DECLARE @bKg                    NVARCHAR(2)= ''
DECLARE @bPc                    NVARCHAR(2)= ''
DECLARE @bJr                    NVARCHAR(2)= ''
DECLARE @bCell                    NVARCHAR(2)= ''
DECLARE @bBatch                 NVARCHAR(2)= ''
DECLARE @bTotal                 NVARCHAR(2)= ''
DECLARE @bSubTotal              NVARCHAR(2)= ''
DECLARE @bAccInqty              NVARCHAR(2)= ''
DECLARE @bAccOutqty              NVARCHAR(2)= ''
DECLARE @bSunWeek				NVARCHAR(2) = 'N'

DECLARE @WeekColumn NVARCHAR(10) = 'ISO_YYYYWW';

DECLARE @bMppWpp                NVARCHAR(2)= ''

DECLARE @tmp_column             NVARCHAR(MAX) = ''
DECLARE @dbg_txt                NVARCHAR(MAX) = ''

DECLARE @v_delimiter            NVARCHAR(1)
DECLARE @v_sub_delimiter        NVARCHAR(1)
DECLARE @sub_v_delimiter        NVARCHAR(1)

DECLARE @max_loop_cnt	          INTEGER = 0
DECLARE @mst_loop_cnt	          INTEGER = 0

DECLARE @sub_mst_loop_cnt       INTEGER = 0
DECLARE @sub_max_loop_cnt       INTEGER = 0
DECLARE @sub_tmp_column         NVARCHAR(MAX) = ''
                                
DECLARE @sub_param_0            NVARCHAR(200) = '' 
DECLARE @sub_param_1            NVARCHAR(200) = '' 
DECLARE @sub_param_2            NVARCHAR(200) = '' 
DECLARE @sub_param_3            NVARCHAR(200) = '' 
DECLARE @sub_param_4            NVARCHAR(200) = '' 

DECLARE @v_tmpSql                 NVARCHAR(MAX)=''
DECLARE @v_tmpSql_Start           NVARCHAR(MAX)=''

-- SET	@v_pSql               = ''
-- SET   @v_sSql               = ''
--Optional Parameter Part END

SET @v_delimiter            = '^'  
SET @v_sub_delimiter        = '|'  
SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@in_columns, @v_delimiter) -- ���ν��� LOOP ���̸� �Ǵ�

WHILE @mst_loop_cnt < @max_loop_cnt
BEGIN --START WHILE
    SET @mst_loop_cnt = @mst_loop_cnt + 1;    
    
    SET @tmp_column   = [dbo].[SCM_ARR_SPL_VAL]( @in_columns, @v_delimiter, @mst_loop_cnt);

    IF @tmp_column = 'AMEND_INSTANCE' 
    BEGIN
        SET @p_amend_instance =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);			
    END 
    ELSE IF @tmp_column = 'INSTANCE_ID' 
    BEGIN
        SET @p_instance_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 
    ELSE IF @tmp_column = 'PLAN_DATE' 
    BEGIN
        SET @p_plan_date =  [dbo].[SCM_ARR_SPL_VAL]( @in_row      ,@v_delimiter, @mst_loop_cnt);
    END 
    ELSE IF @tmp_column = 'AMEND_FLAG' 
    BEGIN
        SET @p_amend_flag =  [dbo].[SCM_ARR_SPL_VAL]( @in_row      ,@v_delimiter, @mst_loop_cnt);
    END 
    ELSE IF @tmp_column = 'AMEND_MAIN_FLAG' 
    BEGIN
        SET @p_amend_main_flag =  [dbo].[SCM_ARR_SPL_VAL]( @in_row      ,@v_delimiter, @mst_loop_cnt);
    END 
    ELSE IF @tmp_column = 'USE_WOW_STATUS' 
    BEGIN
        SET @p_use_wow_status =  [dbo].[SCM_ARR_SPL_VAL]( @in_row      ,@v_delimiter, @mst_loop_cnt);
    END 
    ELSE IF @tmp_column = 'IS_SAME_PLAN_ID' 
    BEGIN
        SET @p_is_same_plan_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row      ,@v_delimiter, @mst_loop_cnt);
    END 
    ELSE IF @tmp_column = 'BASIS_START_TIME' 
    BEGIN
        SET @p_basis_start_time =  [dbo].[SCM_ARR_SPL_VAL]( @in_row      ,@v_delimiter, @mst_loop_cnt);
    END 
    ELSE IF @tmp_column = 'ALL_LINE' 
    BEGIN
        SET @p_all_line =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
    END 
    ELSE IF @tmp_column = 'PLAN_ID' 
    BEGIN
        SET @p_plan_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
    END 
    ELSE IF @tmp_column = 'DIVISION_ID' 
    BEGIN
        SET @p_division_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 
    --ELSE IF @tmp_column = 'SITE_ID' 
    --BEGIN
    --    SET @p_site_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
    --END 
    ELSE IF @tmp_column = 'PLANT_ID' 
    BEGIN
        SET @p_plant_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row       ,@v_delimiter, @mst_loop_cnt);
    END 
    ELSE IF @tmp_column = 'FACTORY_ID' 
    BEGIN
        SET @p_factory_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row     ,@v_delimiter, @mst_loop_cnt);
    END 
    ELSE IF @tmp_column = 'OPERATION_ID' 
    BEGIN
        SET @p_operation_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 
    ELSE IF @tmp_column = 'LINE_ID' 
    BEGIN
        SET @p_line_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
    END
    ELSE IF @tmp_column = 'CURR_DATE_COL' 
    BEGIN
        SET @p_curr_date_col =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END
    ELSE IF @tmp_column = 'TOP_ITEM_ID' 
    BEGIN
        SET @p_top_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END
    ELSE IF @tmp_column = 'ITEM_ID' 
    BEGIN
        SET @p_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
    END 
    ELSE IF @tmp_column = 'MODEL_LT' 
    BEGIN
        SET @p_model_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row       ,@v_delimiter, @mst_loop_cnt);
    END 
    ELSE IF @tmp_column = 'NICK_NAME_LT' 
    BEGIN
        SET @p_nick_name_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row   ,@v_delimiter, @mst_loop_cnt);
    END 
    ELSE IF @tmp_column = 'NICK_NAME' 
    BEGIN
        SET @p_nick_name =  [dbo].[SCM_ARR_SPL_VAL]( @in_row      ,@v_delimiter, @mst_loop_cnt);
    END
    ELSE IF @tmp_column = 'PROD_TYPE' 
    BEGIN
        SET @p_prod_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row      ,@v_delimiter, @mst_loop_cnt);
    END
    ELSE IF @tmp_column = 'CELL_GROUP'
    BEGIN
        SET @p_cell_group =  [dbo].[SCM_ARR_SPL_VAL]( @in_row     ,@v_delimiter, @mst_loop_cnt);
    END
    ELSE IF @tmp_column = 'CONFIRM_AREA'
    BEGIN
        SET @p_confirm_area =  [dbo].[SCM_ARR_SPL_VAL]( @in_row   ,@v_delimiter, @mst_loop_cnt);
    END
    ELSE IF @tmp_column = 'CURR_DATE'
    BEGIN
        SET @p_curr_date =  [dbo].[SCM_ARR_SPL_VAL]( @in_row      ,@v_delimiter, @mst_loop_cnt);
    END
    ELSE IF @tmp_column = 'BUCKET_FROM' 
    BEGIN
        SET @p_bucket_from =  [dbo].[SCM_ARR_SPL_VAL]( @in_row     ,@v_delimiter, @mst_loop_cnt);
    END  
    ELSE IF @tmp_column = 'BUCKET_TO' 
    BEGIN
        SET @p_bucket_to =  [dbo].[SCM_ARR_SPL_VAL]( @in_row      ,@v_delimiter, @mst_loop_cnt);
    END
    ELSE IF @tmp_column = 'BUCKET' 
    BEGIN
        SET @p_bucket =  [dbo].[SCM_ARR_SPL_VAL]( @in_row           ,@v_delimiter, @mst_loop_cnt);
        --SET @p_bucket =  '202151|20211220|20211221|20211222|20211223|20211224|20211225|20211226|202152|20211227|20211228|20211229|20211230|20211231|20220101|20220102|202201|20220103|20220104|20220105|20220106|20220107|20220108|20220109|202202|20220110|20220111|20220112|20220113|20220114|20220115|20220116|202203|20220117|20220118|20220119|20220120|20220121|20220122|20220123|202204|20220124|20220125|20220126|20220127|20220128|20220129|20220130';				
    END 
    ELSE IF @tmp_column = 'DAY_INFO' 
    BEGIN
        SET @p_day_info =  [dbo].[SCM_ARR_SPL_VAL]( @in_row       ,@v_delimiter, @mst_loop_cnt);
        --SET @p_day_info =  '20211220|20211221|20211222|20211223|20211224|20211225|20211226|20211227|20211228|20211229|20211230|20211231|20220101|20220102|20220103|20220104|20220105|20220106|20220107|20220108|20220109|20220110|20220111|20220112|20220113|20220114|20220115|20220116|20220117|20220118|20220119|20220120|20220121|20220122|20220123|20220124|20220125|20220126|20220127|20220128|20220129|20220130';
    END 
    ELSE IF @tmp_column = 'WEEK_INFO' 
    BEGIN
        SET @p_week_info =  [dbo].[SCM_ARR_SPL_VAL]( @in_row      ,@v_delimiter, @mst_loop_cnt);
        --SET @p_week_info =  '202151|202152|202201|202202|202203|202204';				  
    END 
    ELSE IF @tmp_column = 'MONTH_INFO' 
    BEGIN
        SET @p_month_info =  [dbo].[SCM_ARR_SPL_VAL]( @in_row     ,@v_delimiter, @mst_loop_cnt);
        --SET @p_month_info =  '202112|202201';
    END
    ELSE IF @tmp_column = 'DAY2WEEK' 
    BEGIN
        SET @p_day2week =  [dbo].[SCM_ARR_SPL_VAL]( @in_row       ,@v_delimiter, @mst_loop_cnt);
    END
    ELSE IF @tmp_column = 'DAY2MONTH' 
    BEGIN
        SET @p_day2month =  [dbo].[SCM_ARR_SPL_VAL]( @in_row      ,@v_delimiter, @mst_loop_cnt);
    END
    ELSE IF @tmp_column = 'CATE_INFO' 
    BEGIN
        SET @p_cate_info =  [dbo].[SCM_ARR_SPL_VAL]( @in_row      ,@v_delimiter, @mst_loop_cnt);
        --SET @p_cate_info = 'chk_acc_inqty|chk_acc_inqty_tot|chk_acc_outqty|chk_acc_outqty_tot|chk_batch|chk_cell|chk_inqty|chk_inqty_tot|chk_jr|chk_memo|chk_mpp_inqty|chk_mpp_inqty_tot|chk_mpp_outqty|chk_mpp_outqty_tot|chk_offtime|chk_outqty|chk_outqty_tot|chk_pc|chk_result_in|chk_result_in_tot|chk_result_out|chk_result_out_tot|chk_seq|chk_subTotal|chk_total|chk_wpp_inqty|chk_wpp_inqty_tot|chk_wpp_outqty|chk_wpp_outqty_tot';
    END
    ELSE IF @tmp_column = 'CATE_VALUE' 
    BEGIN
        SET @p_cate_value =  [dbo].[SCM_ARR_SPL_VAL]( @in_row     ,@v_delimiter, @mst_loop_cnt);
        --SET @p_cate_value =  'TRUE|TRUE|TRUE|TRUE|TRUE|TRUE|TRUE|TRUE|TRUE|TRUE|TRUE|FALSE|FALSE|FALSE|FALSE|FALSE|FALSE|FALSE|FALSE|FALSE|FALSE|FALSE|FALSE|FALSE|FALSE|FALSE|FALSE|FALSE|FALSE';
    END
    ELSE IF @tmp_column = 'CATE_TYPE' 
    BEGIN
        SET @p_cate_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row      ,@v_delimiter, @mst_loop_cnt);
        --SET @p_cate_type =  'CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY';
    END
    ELSE IF @tmp_column = '_NON_AUTH' 
    BEGIN
        SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
    END

END


--DECLARE @PARAMS NVARCHAR(MAX)

--SET @PARAMS = ''
--SET @PARAMS += ' @P_SYS_TYPE	= ''' +ISNULL(@P_SYS_TYPE,'')	+ '''' + CHAR(10)
--SET @PARAMS += ',@P_SYS_FLAG	= ''' +ISNULL(@P_SYS_FLAG,'')	+ '''' + CHAR(10)
--SET @PARAMS += ',@P_SYS_GUBUN	= ''' +ISNULL(@P_SYS_GUBUN,'')	+ '''' + CHAR(10)
--SET @PARAMS += ',@P_USER_ID		= ''' +ISNULL(@P_USER_ID,'')	+ '''' + CHAR(10)
--SET @PARAMS += ',@in_columns	= ''' +ISNULL(@in_columns,'')	+ '''' + CHAR(10)
--SET @PARAMS += ',@in_row		= ''' +ISNULL(@in_row,'')		+ '''' + CHAR(10)
--SET @PARAMS += ',@opt_none		= ''' +ISNULL(@opt_none,'')		+ '''' + CHAR(10)

--IF @P_SYS_TYPE = 'SQL' BEGIN
--	SELECT @PARAMS AS SQL
--	RETURN
--END

BEGIN 
    SELECT @v_instance_id    = '''' + @p_instance_id + ''''  , @v_plan_date    = '''' + @p_plan_date + ''''
            , @v_plan_id      = '''' + @p_plan_id + ''''      , @v_division_id  = '''' + @p_division_id + ''''
            , @v_site_id      = '''' + @p_site_id + ''''      , @v_plant_id     = '''' + @p_plant_id + ''''
            , @v_factory_id   = '''' + @p_factory_id + ''''   , @v_line_id      = '''' + @p_line_id + ''''
            , @v_operation_id = '''' + @p_operation_id + '''' , @v_top_item_id  = '''' + @p_top_item_id + ''''
            , @v_item_id      = '''' + @p_item_id + ''''      , @v_nick_name    = '''' + @p_nick_name + ''''
            , @v_prodtype_id  = '''' + @p_prodtype_id + ''''  , @v_prod_type    = '''' + @p_prod_type + ''''
            , @v_cell_group   = '''' + @p_cell_group + ''''   , @v_curr_date    = '''' + @p_curr_date + ''''
            , @v_bucket_from  = '''' + @p_bucket_from + ''''  , @v_bucket_to    = '''' + @p_bucket_to + ''''
            , @v_bucket       = '''' + @p_bucket + ''''       , @v_confirm_area = '''' + @p_confirm_area + ''''
            , @v_user_id      = '''' + @p_user_id + '''' ,  @v_curr_date_col = '''' + @p_curr_date_col + '''' 
            , @v_amend_instance = '''' + @p_amend_instance +'''', @v_amend_flag   = '''' + @p_amend_flag + ''''
            , @v_amend_main_flag  = '''' + @p_amend_main_flag + '''' , @v_use_wow_status   = '''' + @p_use_wow_status + ''''
            , @v_is_same_plan_id = '''' + @p_is_same_plan_id  + '''', @v_basis_start_time   = '''' + @p_basis_start_time + ''''
            , @v_all_line   = '''' + @p_all_line + ''''
END

IF @p_sys_flag = 'SELECT_MAIN'
BEGIN --MAIN IF
	SELECT @v_dSql = ''
	--SELECT @v_pSql  = ''

	IF(LEN(@p_cate_info) > 0) 
	BEGIN
		SELECT @v_sub_delimiter = '|'
		SELECT @max_loop_cnt = 0
		SELECT @mst_loop_cnt = 0
		SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_cate_info, @v_sub_delimiter) -- ���ν��� LOOP ���̸� �Ǵ�
    
		WHILE @mst_loop_cnt < @max_loop_cnt
		BEGIN
			SELECT @mst_loop_cnt    = @mst_loop_cnt + 1
			SELECT @v_cate_info     = [dbo].[SCM_ARR_SPL_VAL](@p_cate_info ,@v_sub_delimiter, @mst_loop_cnt)
			SELECT @v_cate_value    = [dbo].[SCM_ARR_SPL_VAL](@p_cate_value ,@v_sub_delimiter, @mst_loop_cnt)
        
			IF(@v_cate_info = 'chk_week_sun' AND @v_cate_value = 'TRUE')
				SELECT @bSunWeek = 'Y'                            
			IF( @v_cate_info = 'chk_inqty'      AND @v_cate_value = 'TRUE' )  
				SELECT @bInqty = 'Y'
			IF( @v_cate_info = 'chk_outqty'     AND @v_cate_value = 'TRUE' ) 
				SELECT @bOutqty = 'Y'
			IF( @v_cate_info = 'chk_mpp_inqty'  AND @v_cate_value = 'TRUE' ) 
				SELECT @bMppInqty = 'Y'
			IF( @v_cate_info = 'chk_mpp_outqty' AND @v_cate_value = 'TRUE' ) 
				SELECT @bMppOutqty = 'Y'
			IF( @v_cate_info = 'chk_wpp_inqty'  AND @v_cate_value = 'TRUE' ) 
				SELECT @bWppInqty = 'Y'
			IF( @v_cate_info = 'chk_wpp_outqty' AND @v_cate_value = 'TRUE' )
				SELECT @bWppOutqty = 'Y'
			IF( @v_cate_info = 'chk_result_in'  AND @v_cate_value = 'TRUE' ) 
				SELECT @bResultIn = 'Y'
			IF( @v_cate_info = 'chk_result_out' AND @v_cate_value = 'TRUE' ) 
				SELECT @bResultOut = 'Y'
			IF( @v_cate_info = 'chk_seq'        AND @v_cate_value = 'TRUE' ) 
				SELECT @bSeq = 'Y'		        
			IF( @v_cate_info = 'chk_memo'       AND @v_cate_value = 'TRUE' ) 
				SELECT @bMemo = 'Y'
			IF( @v_cate_info = 'chk_offtime'    AND @v_cate_value = 'TRUE' ) 
				SELECT @bOffTime = 'Y'
			IF( @v_cate_info = 'chk_pc'         AND @v_cate_value = 'TRUE' ) 
				SELECT @bPc = 'Y'		        
			IF( @v_cate_info = 'chk_jr'         AND @v_cate_value = 'TRUE' ) 
				SELECT @bJr = 'Y'	
			IF( @v_cate_info = 'chk_cell'         AND @v_cate_value = 'TRUE' ) 							 
				SELECT @bCell = 'Y'
			IF( @v_cate_info = 'chk_batch'      AND @v_cate_value = 'TRUE' ) 
				SELECT @bBatch = 'Y'	        
			IF( @v_cate_info = 'chk_total'      AND @v_cate_value = 'TRUE' ) 
				SELECT @bTotal = 'Y'
			IF( @v_cate_info = 'chk_subTotal'   AND @v_cate_value = 'TRUE' ) 
				SELECT @bSubTotal = 'Y'
			IF( @v_cate_info = 'chk_acc_inqty'      AND @v_cate_value = 'TRUE' ) 
				SELECT @bAccInqty = 'Y'
			IF( @v_cate_info = 'chk_acc_outqty'      AND @v_cate_value = 'TRUE' ) 
				SELECT @bAccOutqty = 'Y'
			--IF( @v_cate_info = 'chk_wpp_inqty_tot'  AND @v_cate_value = 'TRUE' ) 
			--	SELECT @bWppInqtyTot = 'Y'
			--IF( @v_cate_info = 'chk_wpp_outqty_tot' AND @v_cate_value = 'TRUE' )
				--	SELECT @bWppOutqtyTot = 'Y'

			SELECT @v_pSql  = ''
			SELECT @v_pSql += '                  SELECT ''X'' AS CATEGORY_ID, '''' AS MEASURE_NAME, '''' AS CATEGORY_NAME, 0 AS CATEGORY_ORDER ' + char(10)
        
			IF( @bInqty = 'Y' and @bPc = 'Y' ) BEGIN
				SELECT @v_pSql += 'UNION ALL  ' + char(10)
				SELECT @v_pSql += 'SELECT ''P_IN_M'' AS CATEGORY_ID, ''M(P/C)'' AS MEASURE_NAME, ''Plan(In)'' AS CATEGORY_NAME, 230 AS CATEGORY_ORDER  ' + char(10)
			END
			IF( @bInqty = 'Y' and @bJr = 'Y' ) BEGIN
				SELECT @v_pSql += 'UNION ALL  ' + char(10)
				SELECT @v_pSql += 'SELECT ''P_IN_JR'' AS CATEGORY_ID, ''J/R'' AS MEASURE_NAME, ''Plan(In)'' AS CATEGORY_NAME, 220 AS CATEGORY_ORDER  ' + char(10)
			END
			IF( @bInqty = 'Y' and @bCell = 'Y' ) BEGIN
				SELECT @v_pSql += 'UNION ALL  ' + char(10)
				SELECT @v_pSql += 'SELECT ''P_IN_CELL'' AS CATEGORY_ID, ''Cell'' AS MEASURE_NAME, ''Plan(In)'' AS CATEGORY_NAME, 240 AS CATEGORY_ORDER  ' + char(10)
			END
			IF( @bInqty = 'Y' and @bBatch = 'Y' ) BEGIN
				SELECT @v_pSql += 'UNION ALL  ' + char(10)
				SELECT @v_pSql += 'SELECT ''P_IN_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''Plan(In)'' AS CATEGORY_NAME, 210 AS CATEGORY_ORDER  ' + char(10)
			END
			IF( @bOutqty = 'Y' and @bPc = 'Y' ) BEGIN
				SELECT @v_pSql += 'UNION ALL  ' + char(10)
				SELECT @v_pSql += 'SELECT ''P_OUT_M'' AS CATEGORY_ID, ''M(P/C)'' AS MEASURE_NAME, ''Plan(Out)'' AS CATEGORY_NAME, 270 AS CATEGORY_ORDER  ' + char(10)
			END
			IF( @bOutqty = 'Y' and @bJr = 'Y' ) BEGIN
				SELECT @v_pSql += 'UNION ALL  ' + char(10)
				SELECT @v_pSql += 'SELECT ''P_OUT_JR'' AS CATEGORY_ID, ''J/R'' AS MEASURE_NAME, ''Plan(Out)'' AS CATEGORY_NAME, 260 AS CATEGORY_ORDER  ' + char(10)
			END
			IF( @bOutqty = 'Y' and @bCell = 'Y' ) BEGIN
				SELECT @v_pSql += 'UNION ALL  ' + char(10)
				SELECT @v_pSql += 'SELECT ''P_OUT_CELL'' AS CATEGORY_ID, ''Cell'' AS MEASURE_NAME, ''Plan(Out)'' AS CATEGORY_NAME, 280 AS CATEGORY_ORDER  ' + char(10)
			END
			IF( @bOutqty = 'Y' and @bBatch = 'Y' ) BEGIN
				SELECT @v_pSql += 'UNION ALL  ' + char(10)
				SELECT @v_pSql += 'SELECT ''P_OUT_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''Plan(Out)'' AS CATEGORY_NAME, 250 AS CATEGORY_ORDER  ' + char(10)
			END
        
			IF( @bMppInqty = 'Y' and @bPc = 'Y' ) BEGIN
				SELECT @v_pSql += 'UNION ALL  ' + char(10)
				SELECT @v_pSql += 'SELECT ''P_MPP_IN_M'' AS CATEGORY_ID, ''M(P/C)'' AS MEASURE_NAME, ''MPP(In)'' AS CATEGORY_NAME, 30 AS CATEGORY_ORDER  ' + char(10)
			END
			IF( @bMppInqty = 'Y' and @bJr = 'Y' ) BEGIN
				SELECT @v_pSql += 'UNION ALL  ' + char(10)
				SELECT @v_pSql += 'SELECT ''P_MPP_IN_JR'' AS CATEGORY_ID, ''J/R'' AS MEASURE_NAME, ''MPP(In)'' AS CATEGORY_NAME, 20 AS CATEGORY_ORDER  ' + char(10)
			END
			IF( @bMppInqty = 'Y' and @bCell = 'Y' ) BEGIN
				SELECT @v_pSql += 'UNION ALL  ' + char(10)
				SELECT @v_pSql += 'SELECT ''P_MPP_IN_CELL'' AS CATEGORY_ID, ''Cell'' AS MEASURE_NAME, ''MPP(In)'' AS CATEGORY_NAME, 40 AS CATEGORY_ORDER  ' + char(10)
			END
			IF( @bMppInqty = 'Y' and @bBatch = 'Y' ) BEGIN
				SELECT @v_pSql += 'UNION ALL  ' + char(10)
				SELECT @v_pSql += 'SELECT ''P_MPP_IN_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''MPP(In)'' AS CATEGORY_NAME, 10 AS CATEGORY_ORDER  ' + char(10)
			END
			IF( @bMppOutqty = 'Y' and @bPc = 'Y' ) BEGIN
				SELECT @v_pSql += 'UNION ALL  ' + char(10)
				SELECT @v_pSql += 'SELECT ''P_MPP_OUT_M'' AS CATEGORY_ID, ''M(P/C)'' AS MEASURE_NAME, ''MPP(Out)'' AS CATEGORY_NAME, 70 AS CATEGORY_ORDER  ' + char(10)
			END
			IF( @bMppOutqty = 'Y' and @bJr = 'Y' ) BEGIN
				SELECT @v_pSql += 'UNION ALL  ' + char(10)
				SELECT @v_pSql += 'SELECT ''P_MPP_OUT_JR'' AS CATEGORY_ID, ''J/R'' AS MEASURE_NAME, ''MPP(Out)'' AS CATEGORY_NAME, 60 AS CATEGORY_ORDER  ' + char(10)
			END
			IF( @bMppOutqty = 'Y' and @bCell = 'Y' ) BEGIN
				SELECT @v_pSql += 'UNION ALL  ' + char(10)
				SELECT @v_pSql += 'SELECT ''P_MPP_OUT_CELL'' AS CATEGORY_ID, ''Cell'' AS MEASURE_NAME, ''MPP(Out)'' AS CATEGORY_NAME, 80 AS CATEGORY_ORDER  ' + char(10)
			END
			IF( @bMppOutqty = 'Y' and @bBatch = 'Y' ) BEGIN
				SELECT @v_pSql += 'UNION ALL  ' + char(10)
				SELECT @v_pSql += 'SELECT ''P_MPP_OUT_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''MPP(Out)'' AS CATEGORY_NAME, 50 AS CATEGORY_ORDER  ' + char(10)
			END
        
			IF( @bWppInqty = 'Y' and @bPc = 'Y' ) BEGIN
				SELECT @v_pSql += 'UNION ALL  ' + char(10)
				SELECT @v_pSql += 'SELECT ''P_WPP_IN_M'' AS CATEGORY_ID, ''M(P/C)'' AS MEASURE_NAME, ''WPP(IN)'' AS CATEGORY_NAME, 130 AS CATEGORY_ORDER  ' + char(10)
			END
			IF( @bWppInqty = 'Y' and @bJr = 'Y' ) BEGIN
				SELECT @v_pSql += 'UNION ALL  ' + char(10)
				SELECT @v_pSql += 'SELECT ''P_WPP_IN_JR'' AS CATEGORY_ID, ''J/R'' AS MEASURE_NAME, ''WPP(IN)'' AS CATEGORY_NAME, 120 AS CATEGORY_ORDER  ' + char(10)
			END
			IF( @bWppInqty = 'Y' and @bCell = 'Y' ) BEGIN
				SELECT @v_pSql += 'UNION ALL  ' + char(10)
				SELECT @v_pSql += 'SELECT ''P_WPP_IN_CELL'' AS CATEGORY_ID, ''Cell'' AS MEASURE_NAME, ''WPP(IN)'' AS CATEGORY_NAME, 140 AS CATEGORY_ORDER  ' + char(10)
			END
			IF( @bWppInqty = 'Y' and @bBatch = 'Y' ) BEGIN
				SELECT @v_pSql += 'UNION ALL  ' + char(10)
				SELECT @v_pSql += 'SELECT ''P_WPP_IN_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''WPP(IN)'' AS CATEGORY_NAME, 110 AS CATEGORY_ORDER  ' + char(10)
			END
			IF( @bWppOutqty = 'Y' and @bPc = 'Y' ) BEGIN
				SELECT @v_pSql += 'UNION ALL  ' + char(10)
				SELECT @v_pSql += 'SELECT ''P_WPP_OUT_M'' AS CATEGORY_ID, ''M(P/C)'' AS MEASURE_NAME, ''WPP(Out)'' AS CATEGORY_NAME, 170 AS CATEGORY_ORDER  ' + char(10)
			END
			IF( @bWppOutqty = 'Y' and @bJr = 'Y' ) BEGIN
				SELECT @v_pSql += 'UNION ALL  ' + char(10)
				SELECT @v_pSql += 'SELECT ''P_WPP_OUT_JR'' AS CATEGORY_ID, ''J/R'' AS MEASURE_NAME, ''WPP(Out)'' AS CATEGORY_NAME, 160 AS CATEGORY_ORDER  ' + char(10)
			END
			IF( @bWppOutqty = 'Y' and @bCell = 'Y' ) BEGIN
				SELECT @v_pSql += 'UNION ALL  ' + char(10)
				SELECT @v_pSql += 'SELECT ''P_WPP_OUT_CELL'' AS CATEGORY_ID, ''Cell'' AS MEASURE_NAME, ''WPP(Out)'' AS CATEGORY_NAME, 180 AS CATEGORY_ORDER  ' + char(10)
			END
			IF( @bWppOutqty = 'Y' and @bBatch = 'Y' ) BEGIN
				SELECT @v_pSql += 'UNION ALL  ' + char(10)
				SELECT @v_pSql += 'SELECT ''P_WPP_OUT_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''WPP(Out)'' AS CATEGORY_NAME, 150 AS CATEGORY_ORDER  ' + char(10)
			END
        
			IF( @bResultIn = 'Y' and @bPc = 'Y' ) BEGIN
				SELECT @v_pSql += 'UNION ALL  ' + char(10)
				SELECT @v_pSql += 'SELECT ''P_RESULT_IN_M'' AS CATEGORY_ID, ''M(P/C)'' AS MEASURE_NAME, ''Result(In)'' AS CATEGORY_NAME, 330 AS CATEGORY_ORDER		  ' + char(10)
			END
			IF( @bResultIn = 'Y' and @bJr = 'Y' ) BEGIN
				SELECT @v_pSql += 'UNION ALL  ' + char(10)
				SELECT @v_pSql += 'SELECT ''P_RESULT_IN_JR'' AS CATEGORY_ID, ''J/R'' AS MEASURE_NAME, ''Result(In)'' AS CATEGORY_NAME, 320 AS CATEGORY_ORDER		  ' + char(10)
			END
			IF( @bResultIn = 'Y' and @bCell = 'Y' ) BEGIN
				SELECT @v_pSql += 'UNION ALL  ' + char(10)
				SELECT @v_pSql += 'SELECT ''P_RESULT_IN_CELL'' AS CATEGORY_ID, ''Cell'' AS MEASURE_NAME, ''Result(In)'' AS CATEGORY_NAME, 340 AS CATEGORY_ORDER		  ' + char(10)
			END
			IF( @bResultIn = 'Y' and @bBatch = 'Y' ) BEGIN
				SELECT @v_pSql += 'UNION ALL  ' + char(10)
				SELECT @v_pSql += 'SELECT ''P_RESULT_IN_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''Result(In)'' AS CATEGORY_NAME, 310 AS CATEGORY_ORDER		  ' + char(10)
			END
        
			IF( @bResultOut = 'Y' and @bPc = 'Y' ) BEGIN
				SELECT @v_pSql += 'UNION ALL  ' + char(10)
				SELECT @v_pSql += 'SELECT ''P_RESULT_OUT_M'' AS CATEGORY_ID, ''M(P/C)'' AS MEASURE_NAME, ''Result(Out)'' AS CATEGORY_NAME, 370 AS CATEGORY_ORDER		  ' + char(10)
			END
			IF( @bResultOut = 'Y' and @bJr = 'Y' ) BEGIN
				SELECT @v_pSql += 'UNION ALL  ' + char(10)
				SELECT @v_pSql += 'SELECT ''P_RESULT_OUT_JR'' AS CATEGORY_ID, ''J/R'' AS MEASURE_NAME, ''Result(Out)'' AS CATEGORY_NAME, 360 AS CATEGORY_ORDER		  ' + char(10)
			END
			IF( @bResultOut = 'Y' and @bCell = 'Y' ) BEGIN
				SELECT @v_pSql += 'UNION ALL  ' + char(10)
				SELECT @v_pSql += 'SELECT ''P_RESULT_OUT_CELL'' AS CATEGORY_ID, ''Cell'' AS MEASURE_NAME, ''Result(Out)'' AS CATEGORY_NAME, 380 AS CATEGORY_ORDER		  ' + char(10)
			END
			IF( @bResultOut = 'Y' and @bBatch = 'Y' ) BEGIN
				SELECT @v_pSql += 'UNION ALL  ' + char(10)
				SELECT @v_pSql += 'SELECT ''P_RESULT_OUT_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''Result(Out)'' AS CATEGORY_NAME, 350 AS CATEGORY_ORDER		  ' + char(10)
			END

			SELECT @v_pSql += 'UNION ALL ' + char(10)
			SELECT @v_pSql += 'SELECT ''P_SEQ'' AS CATEGORY_ID, '''' AS MEASURE_NAME, ''Seq'' AS CATEGORY_NAME, 290 AS CATEGORY_ORDER		 ' + char(10)
			SELECT @v_pSql += 'UNION ALL ' + char(10)
			SELECT @v_pSql += 'SELECT ''P_OFFTIME'' AS CATEGORY_ID, '''' AS MEASURE_NAME, ''Off Cal.'' AS CATEGORY_NAME, 390 AS CATEGORY_ORDER		 ' + char(10)
			SELECT @v_pSql += 'UNION ALL ' + char(10)
			SELECT @v_pSql += 'SELECT ''P_MEMO'' AS CATEGORY_ID, '''' AS MEASURE_NAME, ''Memo'' AS CATEGORY_NAME, 400 AS CATEGORY_ORDER'	+ char(10)

		END	
	END
	ELSE
	BEGIN
		SELECT @v_pSql += 'SELECT ''P_IN_M'' AS CATEGORY_ID, ''M(P/C)'' AS MEASURE_NAME, ''Plan(In)'' AS CATEGORY_NAME, 230 AS CATEGORY_ORDER			' + char(10)
		SELECT @v_pSql += 'UNION ALL                                                                                                  ' + char(10)
		SELECT @v_pSql += 'SELECT ''P_IN_JR'' AS CATEGORY_ID, ''J/R'' AS MEASURE_NAME, ''Plan(In)'' AS CATEGORY_NAME, 220 AS CATEGORY_ORDER            ' + char(10)
		SELECT @v_pSql += 'UNION ALL                                                                                                  ' + char(10)
		SELECT @v_pSql += 'SELECT ''P_IN_CELL'' AS CATEGORY_ID, ''Cell'' AS MEASURE_NAME, ''Plan(In)'' AS CATEGORY_NAME, 240 AS CATEGORY_ORDER         ' + char(10)
		SELECT @v_pSql += 'UNION ALL                                                                                                  ' + char(10)
		SELECT @v_pSql += 'SELECT ''P_IN_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''Plan(In)'' AS CATEGORY_NAME, 210 AS CATEGORY_ORDER       ' + char(10)
		SELECT @v_pSql += 'UNION ALL                                                                                                  ' + char(10)
		SELECT @v_pSql += 'SELECT ''P_OUT_M'' AS CATEGORY_ID, ''M(P/C)'' AS MEASURE_NAME, ''Plan(Out)'' AS CATEGORY_NAME, 270 AS CATEGORY_ORDER        ' + char(10)
		SELECT @v_pSql += 'UNION ALL                                                                                                  ' + char(10)
		SELECT @v_pSql += 'SELECT ''P_OUT_JR'' AS CATEGORY_ID, ''J/R'' AS MEASURE_NAME, ''Plan(Out)'' AS CATEGORY_NAME, 260 AS CATEGORY_ORDER          ' + char(10)
		SELECT @v_pSql += 'UNION ALL                                                                                                  ' + char(10)
		SELECT @v_pSql += 'SELECT ''P_OUT_CELL'' AS CATEGORY_ID, ''Cell'' AS MEASURE_NAME, ''Plan(Out)'' AS CATEGORY_NAME, 280 AS CATEGORY_ORDER       ' + char(10)
		SELECT @v_pSql += 'UNION ALL                                                                                                  ' + char(10)
		SELECT @v_pSql += 'SELECT ''P_OUT_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''Plan(Out)'' AS CATEGORY_NAME, 250 AS CATEGORY_ORDER     ' + char(10)
		SELECT @v_pSql += 'UNION ALL                                                                                                  ' + char(10)
        
		SELECT @v_pSql += 'SELECT ''P_MPP_IN_M'' AS CATEGORY_ID, ''M(P/C)'' AS MEASURE_NAME, ''MPP(In)'' AS CATEGORY_NAME, 30 AS CATEGORY_ORDER			' + char(10)
		SELECT @v_pSql += 'UNION ALL                                                                                                  ' + char(10)
		SELECT @v_pSql += 'SELECT ''P_MPP_IN_JR'' AS CATEGORY_ID, ''J/R'' AS MEASURE_NAME, ''MPP(In)'' AS CATEGORY_NAME, 20 AS CATEGORY_ORDER            ' + char(10)
		SELECT @v_pSql += 'UNION ALL                                                                                                  ' + char(10)
		SELECT @v_pSql += 'SELECT ''P_MPP_IN_CELL'' AS CATEGORY_ID, ''Cell'' AS MEASURE_NAME, ''MPP(In)'' AS CATEGORY_NAME, 40 AS CATEGORY_ORDER         ' + char(10)
		SELECT @v_pSql += 'UNION ALL                                                                                                  ' + char(10)
		SELECT @v_pSql += 'SELECT ''P_MPP_IN_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''MPP(In)'' AS CATEGORY_NAME, 10 AS CATEGORY_ORDER       ' + char(10)
		SELECT @v_pSql += 'UNION ALL                                                                                                  ' + char(10)
		SELECT @v_pSql += 'SELECT ''P_MPP_OUT_M'' AS CATEGORY_ID, ''M(P/C)'' AS MEASURE_NAME, ''MPP(Out)'' AS CATEGORY_NAME, 70 AS CATEGORY_ORDER        ' + char(10)
		SELECT @v_pSql += 'UNION ALL                                                                                                  ' + char(10)
		SELECT @v_pSql += 'SELECT ''P_MPP_OUT_JR'' AS CATEGORY_ID, ''J/R'' AS MEASURE_NAME, ''MPP(Out)'' AS CATEGORY_NAME, 60 AS CATEGORY_ORDER          ' + char(10)
		SELECT @v_pSql += 'UNION ALL                                                                                                  ' + char(10)
		SELECT @v_pSql += 'SELECT ''P_MPP_OUT_CELL'' AS CATEGORY_ID, ''Cell'' AS MEASURE_NAME, ''MPP(Out)'' AS CATEGORY_NAME, 80 AS CATEGORY_ORDER       ' + char(10)
		SELECT @v_pSql += 'UNION ALL                                                                                                  ' + char(10)
		SELECT @v_pSql += 'SELECT ''P_MPP_OUT_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''MPP(Out)'' AS CATEGORY_NAME, 50 AS CATEGORY_ORDER     ' + char(10)
		SELECT @v_pSql += 'UNION ALL                                                                                                  ' + char(10)
        
		SELECT @v_pSql += 'SELECT ''P_WPP_IN_M'' AS CATEGORY_ID, ''M(P/C)'' AS MEASURE_NAME, ''WPP(In)'' AS CATEGORY_NAME, 130 AS CATEGORY_ORDER			' + char(10)
		SELECT @v_pSql += 'UNION ALL                                                                                                  ' + char(10)
		SELECT @v_pSql += 'SELECT ''P_WPP_IN_JR'' AS CATEGORY_ID, ''J/R'' AS MEASURE_NAME, ''WPP(In)'' AS CATEGORY_NAME, 120 AS CATEGORY_ORDER            ' + char(10)
		SELECT @v_pSql += 'UNION ALL                                                                                                  ' + char(10)
		SELECT @v_pSql += 'SELECT ''P_WPP_IN_CELL'' AS CATEGORY_ID, ''Cell'' AS MEASURE_NAME, ''WPP(In)'' AS CATEGORY_NAME, 140 AS CATEGORY_ORDER         ' + char(10)
		SELECT @v_pSql += 'UNION ALL                                                                                                  ' + char(10)
		SELECT @v_pSql += 'SELECT ''P_WPP_IN_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''WPP(In)'' AS CATEGORY_NAME, 110 AS CATEGORY_ORDER       ' + char(10)
		SELECT @v_pSql += 'UNION ALL                                                                                                  ' + char(10)
		SELECT @v_pSql += 'SELECT ''P_WPP_OUT_M'' AS CATEGORY_ID, ''M(P/C)'' AS MEASURE_NAME, ''WPP(Out)'' AS CATEGORY_NAME, 170 AS CATEGORY_ORDER        ' + char(10)
		SELECT @v_pSql += 'UNION ALL                                                                                                  ' + char(10)
		SELECT @v_pSql += 'SELECT ''P_WPP_OUT_JR'' AS CATEGORY_ID, ''J/R'' AS MEASURE_NAME, ''WPP(Out)'' AS CATEGORY_NAME, 160 AS CATEGORY_ORDER          ' + char(10)
		SELECT @v_pSql += 'UNION ALL                                                                                                  ' + char(10)
		SELECT @v_pSql += 'SELECT ''P_WPP_OUT_CELL'' AS CATEGORY_ID, ''Cell'' AS MEASURE_NAME, ''WPP(Out)'' AS CATEGORY_NAME, 180 AS CATEGORY_ORDER       ' + char(10)
		SELECT @v_pSql += 'UNION ALL                                                                                                  ' + char(10)
		SELECT @v_pSql += 'SELECT ''P_WPP_OUT_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''WPP(Out)'' AS CATEGORY_NAME, 150 AS CATEGORY_ORDER     ' + char(10)
		SELECT @v_pSql += 'UNION ALL                                                                                                  ' + char(10)
        
		SELECT @v_pSql += 'SELECT ''P_RESULT_IN_M'' AS CATEGORY_ID, ''M(P/C)'' AS MEASURE_NAME, ''Result(In)'' AS CATEGORY_NAME, 330 AS CATEGORY_ORDER		 ' + char(10)
		SELECT @v_pSql += 'UNION ALL ' + char(10)
		SELECT @v_pSql += 'SELECT ''P_RESULT_IN_JR'' AS CATEGORY_ID, ''J/R'' AS MEASURE_NAME, ''Result(In)'' AS CATEGORY_NAME, 320 AS CATEGORY_ORDER		 ' + char(10)
		SELECT @v_pSql += 'UNION ALL ' + char(10)
		SELECT @v_pSql += 'SELECT ''P_RESULT_IN_CELL'' AS CATEGORY_ID, ''Cell'' AS MEASURE_NAME, ''Result(In)'' AS CATEGORY_NAME, 340 AS CATEGORY_ORDER		 ' + char(10)
		SELECT @v_pSql += 'UNION ALL ' + char(10)
		SELECT @v_pSql += 'SELECT ''P_RESULT_IN_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''Result(In)'' AS CATEGORY_NAME, 310 AS CATEGORY_ORDER		 ' + char(10)
		SELECT @v_pSql += 'UNION ALL ' + char(10)
		SELECT @v_pSql += 'SELECT ''P_RESULT_OUT_M'' AS CATEGORY_ID, ''M(P/C)'' AS MEASURE_NAME, ''Result(Out)'' AS CATEGORY_NAME, 370 AS CATEGORY_ORDER		 ' + char(10)
		SELECT @v_pSql += 'UNION ALL ' + char(10)
		SELECT @v_pSql += 'SELECT ''P_RESULT_OUT_JR'' AS CATEGORY_ID, ''J/R'' AS MEASURE_NAME, ''Result(Out)'' AS CATEGORY_NAME, 360 AS CATEGORY_ORDER		 ' + char(10)
		SELECT @v_pSql += 'UNION ALL ' + char(10)
		SELECT @v_pSql += 'SELECT ''P_RESULT_OUT_CELL'' AS CATEGORY_ID, ''Cell'' AS MEASURE_NAME, ''Result(Out)'' AS CATEGORY_NAME, 380 AS CATEGORY_ORDER		 ' + char(10)
		SELECT @v_pSql += 'UNION ALL ' + char(10)
		SELECT @v_pSql += 'SELECT ''P_RESULT_OUT_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''Result(Out)'' AS CATEGORY_NAME, 350 AS CATEGORY_ORDER		 ' + char(10)
        
		SELECT @v_pSql += 'UNION ALL ' + char(10)
		SELECT @v_pSql += 'SELECT ''P_SEQ'' AS CATEGORY_ID, '''' AS MEASURE_NAME, ''Seq'' AS CATEGORY_NAME, 290 AS CATEGORY_ORDER	        ' + char(10)
		SELECT @v_pSql += 'UNION ALL                                                                                                  ' + char(10)
		SELECT @v_pSql += 'SELECT ''P_OFFTIME'' AS CATEGORY_ID, '''' AS MEASURE_NAME, ''Off Cal.'' AS CATEGORY_NAME, 390 AS CATEGORY_ORDER	        ' + char(10)
		SELECT @v_pSql += 'UNION ALL                                                                                                  ' + char(10)
		SELECT @v_pSql += 'SELECT ''P_MEMO'' AS CATEGORY_ID, '''' AS MEASURE_NAME, ''Memo'' AS CATEGORY_NAME, 400 AS CATEGORY_ORDER	        ' + char(10)

	END	  

	IF ISNULL(@bSunWeek,'') = 'Y' BEGIN
		SET @WeekColumn = 'YYYYWW'
	END
	--TEMP TABLE

	-- foil 정보 수정... 20240329
	SELECT @v_dSql += 'if object_id(''tempdb..#FOIL_INFO'') is not null	DROP TABLE #FOIL_INFO ' + char(10);
	SELECT @v_dSql += 'SELECT A.* ' + char(10);
	SELECT @v_dSql += 'INTO #FOIL_INFO ' + char(10);
	SELECT @v_dSql += 'FROM   ( ' + char(10);
	SELECT @v_dSql += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.FOIL_ID AS FOIL_CODE, B.ITEM_NAME AS FOIL, A.PROD_VERSION_TYPE, C.LINE_ID, A.MODEL_ID, A.PROD_VERSION AS VERSION ' + char(10);
	SELECT @v_dSql += '		 , ROW_NUMBER() OVER ( PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.PROD_VERSION_TYPE, C.LINE_ID, A.MODEL_ID, A.PROD_VERSION ' + char(10);
	SELECT @v_dSql += '		 				       ORDER BY     V.APPLY_DATE DESC )  AS NUM ' + char(10);
	SELECT @v_dSql += '	FROM ( ' + char(10);
	SELECT @v_dSql += '		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10);
	SELECT @v_dSql += '			 , A.FACTORY_ID, A.MODEL_ID, A.ITEM_ID, A.PROD_VERSION, A.PROD_SEQ ' + char(10);
	SELECT @v_dSql += '			 , A.PROD_VERSION_TYPE, A.FOIL_ID ' + char(10);
	SELECT @v_dSql += '		FROM   ( ' + char(10);
	SELECT @v_dSql += '			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10);
	SELECT @v_dSql += '				 , A.FACTORY_ID, A.MODEL_ID, A.ITEM_ID, A.PROD_VERSION, A.PROD_SEQ ' + char(10); -- key value
	SELECT @v_dSql += '				 , A.PROD_VERSION_TYPE, A.FOIL_ID ' + char(10);
	SELECT @v_dSql += '				 , ROW_NUMBER() OVER ( PARTITION BY A.FACTORY_ID, A.MODEL_ID, A.ITEM_ID, A.PROD_VERSION ORDER BY A.PROD_SEQ DESC ) AS NUM ' + char(10);
	SELECT @v_dSql += '			FROM   SCM_ITEM_FOIL_M A WITH(NOLOCK) ' + char(10);
	SELECT @v_dSql += '			WHERE  1=1 ' + char(10);
	SELECT @v_dSql += '			' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))
	SELECT @v_dSql += '			' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))
	SELECT @v_dSql += '			' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))
	SELECT @v_dSql += '			' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))
	SELECT @v_dSql += '			' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id)) + char(10)
	SELECT @v_dSql += '		) A ' + char(10);
	SELECT @v_dSql += '		WHERE A.NUM = 1 ' + char(10);
	SELECT @v_dSql += '	) A ' + char(10);
	SELECT @v_dSql += '	, FP_PROD_VERSION_M      V WITH(NOLOCK) ' + char(10);
	SELECT @v_dSql += '	, SCM_ITEM_M             B WITH(NOLOCK) ' + char(10);
	SELECT @v_dSql += '	, SCM_ITEM_LINE_ASSIGN_M C WITH(NOLOCK) ' + char(10);
	SELECT @v_dSql += '	WHERE A.FACTORY_ID    = V.FACTORY_ID ' + char(10);
	SELECT @v_dSql += '	AND   A.MODEL_ID      = V.MODEL_ID ' + char(10);
	SELECT @v_dSql += '	AND   A.ITEM_ID       = V.ITEM_ID ' + char(10);
	SELECT @v_dSql += '	AND   A.PROD_VERSION  = V.PROD_VERSION ' + char(10);
	SELECT @v_dSql += '	AND   A.PROD_SEQ      = V.PROD_SEQ ' + char(10);
	SELECT @v_dSql += '	AND   A.COMPANY_ID    = B.COMPANY_ID ' + char(10);
	SELECT @v_dSql += '	AND   A.DIVISION_ID   = B.DIVISION_ID ' + char(10);
	SELECT @v_dSql += '	AND   A.SITE_ID       = B.SITE_ID ' + char(10);
	SELECT @v_dSql += '	AND   A.FOIL_ID       = B.ITEM_ID ' + char(10);
	SELECT @v_dSql += '	AND   A.COMPANY_ID    = C.COMPANY_ID ' + char(10);
	SELECT @v_dSql += '	AND   A.DIVISION_ID   = C.DIVISION_ID ' + char(10);
	SELECT @v_dSql += '	AND   A.SITE_ID       = C.SITE_ID ' + char(10);
	SELECT @v_dSql += '	AND   A.PLANT_ID      = C.PLANT_ID ' + char(10);
	SELECT @v_dSql += '	AND   A.FACTORY_ID    = C.FACTORY_ID ' + char(10);
	SELECT @v_dSql += '	AND   A.ITEM_ID       = C.ITEM_ID ' + char(10);
	SELECT @v_dSql += ') A ' + char(10);
	SELECT @v_dSql += 'WHERE A.NUM = 1 ' + char(10);
	SELECT @v_dSql += '; ' + char(10)+ char(10);

	-----------------------
	SELECT @v_dSql += '	IF OBJECT_ID(''tempdb..#TblFP00614_FIND_FP00614'') IS NOT NULL	 ' + char(10);
	SELECT @v_dSql += '			DROP TABLE #TblFP00614_FIND_FP00614;					 ' + char(10);
	SELECT @v_dSql += '		CREATE TABLE #TblFP00614_FIND_FP00614(						 ' + char(10);
	SELECT @v_dSql += '				 [COMPANY_ID] [nvarchar](30) NOT NULL				 ' + char(10);
	SELECT @v_dSql += '				,[DIVISION_ID] [nvarchar](30) NOT NULL				 ' + char(10);
	SELECT @v_dSql += '				,[SITE_ID] [nvarchar](30) NOT NULL					 ' + char(10);
	SELECT @v_dSql += '				,[PLANT_ID] [nvarchar](30) NOT NULL					 ' + char(10);
	SELECT @v_dSql += '				,[FACTORY_ID] [nvarchar](30) NOT NULL				 ' + char(10);
	SELECT @v_dSql += '				,[PLAN_GROUP_ID] [nvarchar](30) NOT NULL			 ' + char(10);
	SELECT @v_dSql += '				,[TOP_ITEM_ID] [nvarchar](30) NOT NULL				 ' + char(10);
	SELECT @v_dSql += '				,[ITEM_ID] [nvarchar](150) NOT NULL					 ' + char(10);
	SELECT @v_dSql += '				,[OPERATION_ID] [nvarchar](30) NOT NULL				 ' + char(10);
	SELECT @v_dSql += '				,[LOCATION] [nvarchar](30) NOT NULL					 ' + char(10);
	SELECT @v_dSql += '				,[PRODUCTION_TYPE] [nvarchar](30) NOT NULL			 ' + char(10);
	SELECT @v_dSql += '				,[MARKET] [nvarchar](30) NOT NULL					 ' + char(10);
	SELECT @v_dSql += '				,[LINE_ID] [nvarchar](30) NOT NULL					 ' + char(10);
	SELECT @v_dSql += '				,[ELECTRODE_TYPE] [nvarchar](20) NOT NULL			 ' + char(10);
	SELECT @v_dSql += '				,[PLAN_DATE] [datetime] NOT NULL					 ' + char(10);
	SELECT @v_dSql += '				,[PLAN_QTY] [numeric](20, 4) NOT NULL				 ' + char(10);
	SELECT @v_dSql += '				,[PLAN_IN_QTY] [numeric](20, 4) NULL				 ' + char(10);
	SELECT @v_dSql += '				,[INSERT_ID] [nvarchar](150) NULL					 ' + char(10);
	SELECT @v_dSql += '				,[INSERT_TIME] [datetime] NULL						 ' + char(10);
	SELECT @v_dSql += '				,[PLAN_TYPE] [nvarchar](10) NOT NULL				 ' + char(10);
	SELECT @v_dSql += '				,[EQUIPMENT_ID] [nvarchar](30) NOT NULL				 ' + char(10);
	SELECT @v_dSql += '				,[FP_PRODUCTION_TYPE] [nvarchar](30) NOT NULL		 ' + char(10);
	SELECT @v_dSql += '				,[ROLL_IN_QTY] [numeric](20, 5) NULL				 ' + char(10);
	SELECT @v_dSql += '				,[ROLL_OUT_QTY] [numeric](20, 5) NULL				 ' + char(10);
	SELECT @v_dSql += '				,[JR_IN_QTY] [numeric](20, 5) NULL					 ' + char(10);
	SELECT @v_dSql += '				,[JR_OUT_QTY] [numeric](20, 5) NULL					 ' + char(10);
	SELECT @v_dSql += '				,[BATCH_IN_QTY] [numeric](20, 5) NULL				 ' + char(10);
	SELECT @v_dSql += '				,[BATCH_OUT_QTY] [numeric](20, 5) NULL				 ' + char(10);
	SELECT @v_dSql += '				,[CELL_IN_QTY] [numeric](20, 5) NULL				 ' + char(10);
	SELECT @v_dSql += '				,[CELL_OUT_QTY] [numeric](20, 5) NULL				 ' + char(10);
	SELECT @v_dSql += '				,[SEQ] [int] NULL									 ' + char(10);
	SELECT @v_dSql += '				,[TOTAL_BATCH] [numeric](20, 10) NULL				 ' + char(10);
	SELECT @v_dSql += '				,[SETUP_COLOR_CODE] [nvarchar](10) NULL				 ' + char(10);
	SELECT @v_dSql += '				,[WORK_REQUEST_MODEL_ID] [nvarchar](50) NULL		' + char(10);
	SELECT @v_dSql += '				,[VERSION] [nvarchar](10) NULL						' + char(10);
	SELECT @v_dSql += '				,[PROD_SEQ] [nvarchar](50) NULL						' + char(10);
	SELECT @v_dSql += '				,[PLM_EC_NO] [nvarchar](150) NULL					' + char(10); -- PDS 2차 고도화
	SELECT @v_dSql += '			);	 ' + char(10)+ char(10);
	--------------------------		
	
	SELECT @v_dSql += '  insert into #TblFP00614_FIND_FP00614			   ' + char(10);
	SELECT @v_dSql += '  SELECT distinct  COMPANY_ID 	,DIVISION_ID ,SITE_ID 	,PLANT_ID 			   ' + char(10);
	SELECT @v_dSql += '					,FACTORY_ID ,PLAN_GROUP_ID 	,TOP_ITEM_ID ,ITEM_ID 			   ' + char(10);
	SELECT @v_dSql += '					,OPERATION_ID ,LOCATION ,PRODUCTION_TYPE ,MARKET 			   ' + char(10);
	SELECT @v_dSql += '					,LINE_ID ,ELECTRODE_TYPE ,PLAN_DATE	,PLAN_QTY 				   ' + char(10);
	SELECT @v_dSql += '					,PLAN_IN_QTY ,INSERT_ID ,INSERT_TIME,PLAN_TYPE 				   ' + char(10);
	SELECT @v_dSql += '					,EQUIPMENT_ID ,FP_PRODUCTION_TYPE ,ROLL_IN_QTY 				   ' + char(10);
	SELECT @v_dSql += '					,ROLL_OUT_QTY ,JR_IN_QTY ,JR_OUT_QTY ,BATCH_IN_QTY 			   ' + char(10);
	SELECT @v_dSql += '					,BATCH_OUT_QTY,CELL_IN_QTY ,CELL_OUT_QTY 					   ' + char(10);
	SELECT @v_dSql += '					,SEQ ,TOTAL_BATCH ,SETUP_COLOR_CODE 						   ' + char(10);
	SELECT @v_dSql += '					,WORK_REQUEST_MODEL_ID, VERSION, PROD_SEQ, PLM_EC_NO		   ' + char(10);
	SELECT @v_dSql += '	from FP_DAILY_PRODUCTIOIN_PLAN_H fP_DAILY_A WITH(NOLOCK)	   ' + char(10);
	SELECT @v_dSql += '	where 1=1 																	   ' + char(10);
	SELECT @v_dSql += '	AND    fP_DAILY_A.PLAN_DATE BETWEEN CONVERT(DATE, ''' +  @p_bucket_from + ''') AND CONVERT(DATE, ''' +  @p_bucket_to +''') ' + char(10);
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                fP_DAILY_A.DIVISION_ID' , 'EQ', @p_division_id))        + char(10)
	
	IF(LEN(@p_site_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                fP_DAILY_A.SITE_ID' , 'EQ', @p_site_id))        + char(10)
	END
	
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                fP_DAILY_A.PLANT_ID' , 'EQ', @p_plant_id))              + char(10)
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                fP_DAILY_A.FACTORY_ID' , 'EQ', @p_factory_id))          + char(10) 

	IF(LEN(@p_operation_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                fP_DAILY_A.OPERATION_ID' , 'EQ', @p_operation_id))      + char(10)
	END

	SELECT @v_dSql += '' + char(10)+ char(10);

	-- item 메모 관련
	SELECT @v_dSql += 'IF OBJECT_ID(''tempdb..#ITEM_MEMO_TEMP'') IS NOT NULL	DROP TABLE #ITEM_MEMO_TEMP;' + char(10);
	SELECT @v_dSql += 'SELECT B.* INTO #ITEM_MEMO_TEMP ' + char(10)
	SELECT @v_dSql += 'FROM ( ' + char(10)
	SELECT @v_dSql += '  		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
	SELECT @v_dSql += '  			 , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID ' + char(10)
	SELECT @v_dSql += '  			 , A.ITEM_ID, A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE, A.MARKET ' + char(10)
	SELECT @v_dSql += '  		FROM #TblFP00614_FIND_FP00614 A WITH(NOLOCK) ' + char(10)
	SELECT @v_dSql += '  		LEFT OUTER JOIN ( ' + char(10)
	SELECT @v_dSql += '  				SELECT A.SEGMENT1 AS INSTANCE_ID, A.SEGMENT2 AS SETUP_COLOR_CODE, A.SEGMENT3 AS SETUP_COLOR_NAME, A.SEGMENT4 AS SETUP_COLOR, A.SORT_ORDER ' + char(10)
	SELECT @v_dSql += '  				FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
	SELECT @v_dSql += '  				WHERE  A.LOOKUP_TYPE_CODE = ''UI_AMEND_COLOR'' ' + char(10)
	SELECT @v_dSql += '  				AND    A.SEGMENT1 = ' + @v_instance_id + ' ' + char(10)
	SELECT @v_dSql += '  				AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
	SELECT @v_dSql += '  		) B ' + char(10)
	SELECT @v_dSql += '  		ON A.SETUP_COLOR_CODE = B.SETUP_COLOR_CODE ' + char(10)
	SELECT @v_dSql += '  		WHERE  1=1 ' + char(10)
	SELECT @v_dSql += '  		AND    A.PLAN_TYPE IN ( ''RELEASE'', ''MPP'', ''WPP'' ) ' + char(10)
	SELECT @v_dSql += '  		AND    A.PLAN_DATE BETWEEN CONVERT(DATE, ' + @v_bucket_from + ') AND CONVERT(DATE, ' + @v_bucket_to + ') ' + char(10)
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('  		A.DIVISION_ID' , 'EQ', @p_division_id))
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('  		A.SITE_ID' , 'EQ', @p_site_id))
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('  		A.PLANT_ID' , 'EQ', @p_plant_id))
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('  		A.FACTORY_ID' , 'EQ', @p_factory_id))
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('  		A.OPERATION_ID' , 'EQ', @p_operation_id))
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('  		A.LINE_ID' , 'EQ', @p_line_id))
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('  		A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type))
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('  		A.TOP_ITEM_ID' , 'LK', @p_top_item_id))
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('  		A.ITEM_ID' , 'LK', @p_item_id)) + char(10)
	SELECT @v_dSql += '  		AND ( ISNULL(A.TOTAL_BATCH,0) + ISNULL(A.BATCH_IN_QTY,0) + ISNULL(A.PLAN_IN_QTY,0) + ISNULL(A.ROLL_IN_QTY,0) + ISNULL(A.CELL_IN_QTY,0) + ISNULL(A.JR_IN_QTY,0) + ISNULL(A.BATCH_OUT_QTY,0) + ISNULL(A.PLAN_QTY,0) + ISNULL(A.ROLL_OUT_QTY,0) + ISNULL(A.CELL_OUT_QTY,0) + ISNULL(A.JR_OUT_QTY,0) ) > 0 ' + char(10)
	SELECT @v_dSql += '  		GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
	SELECT @v_dSql += '  			   , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID ' + char(10)
	SELECT @v_dSql += '  			   , A.ITEM_ID, A.FP_PRODUCTION_TYPE, A.MARKET ' + char(10)
	SELECT @v_dSql += '  		UNION ' + char(10)
	SELECT @v_dSql += '  		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
	SELECT @v_dSql += '  			 , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID ' + char(10)
	SELECT @v_dSql += '  			 , A.ITEM_ID, A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE, A.MARKET ' + char(10)
	SELECT @v_dSql += '  		FROM SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK) ' + char(10)
	SELECT @v_dSql += '  		WHERE  1=1 ' + char(10)
	SELECT @v_dSql += '  		AND    A.PLAN_DATE BETWEEN CONVERT(DATE, ' + @v_bucket_from + ') AND CONVERT(DATE, ' + @v_bucket_to + ') ' + char(10)
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('  		A.DIVISION_ID' , 'EQ', @p_division_id))
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('  		A.SITE_ID' , 'EQ', @p_site_id))
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('  		A.PLANT_ID' , 'EQ', @p_plant_id))
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('  		A.FACTORY_ID' , 'EQ', @p_factory_id))
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('  		A.OPERATION_ID' , 'EQ', @p_operation_id))
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('  		A.LINE_ID' , 'EQ', @p_line_id))
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('  		A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type))
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('  		A.TOP_ITEM_ID' , 'LK', @p_top_item_id))
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('  		A.ITEM_ID' , 'LK', @p_item_id)) + char(10)
	SELECT @v_dSql += '  		AND	A.BATCH_IN_QTY > 0 ' + char(10)
	SELECT @v_dSql += '  		GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
	SELECT @v_dSql += '  				, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID ' + char(10)
	SELECT @v_dSql += '  				, A.ITEM_ID, A.FP_PRODUCTION_TYPE, A.MARKET ' + char(10)
	SELECT @v_dSql += ') B ' + char(10)+ char(10)

	/*--------------------------
	SELECT @v_dSql += '	IF OBJECT_ID(''tempdb..#FOIL_M'') IS NOT NULL ' + char(10);
	SELECT @v_dSql += '		DROP TABLE #FOIL_M; ' + char(10)+char(10);
	
	SELECT @v_dSql += '		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.FOIL_CODE, A.FOIL, A.PROD_VERSION_TYPE, A.LINE_ID, A.PROD_TYPE'+char(10)
	SELECT @v_dSql += '		INTO	#FOIL_M  ' + char(10)
	SELECT @v_dSql += '		FROM   ( '+char(10)
	SELECT @v_dSql += '					SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.FOIL_ID AS FOIL_CODE, B.ITEM_NAME AS FOIL, A.PROD_VERSION_TYPE, C.LINE_ID' + char(10)
	SELECT @v_dSql += '						   	, CASE WHEN LEFT(V.PROD_VERSION, 1) = ''Z'' THEN ''TEST'' ELSE ''MASS'' END AS PROD_TYPE' + char(10)
	SELECT @v_dSql += '						   	, ROW_NUMBER() OVER ( 	PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.PROD_VERSION_TYPE, C.LINE_ID' + char(10)
	SELECT @v_dSql += '						   										                 , CASE WHEN LEFT(V.PROD_VERSION, 1) = ''Z'' THEN ''TEST'' ELSE ''MASS'' END' + char(10)
	SELECT @v_dSql += '													              ORDER BY V.APPLY_DATE DESC, A.PROD_VERSION DESC, A.PROD_SEQ DESC )	 AS NUM' + char(10)
	
	SELECT @v_dSql += '					FROM  SCM_ITEM_FOIL_M        A WITH(NOLOCK)  ' + char(10)
	SELECT @v_dSql += '						   ,FP_PROD_VERSION_M      V WITH(NOLOCK)' + char(10)
	SELECT @v_dSql += '						   ,SCM_ITEM_M             B WITH(NOLOCK)' + char(10)
	SELECT @v_dSql += '						   ,SCM_ITEM_LINE_ASSIGN_M C WITH(NOLOCK)' + char(10)
	SELECT @v_dSql += '					WHERE 1=1' + char(10)
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.DIVISION_ID' , 'EQ', @p_division_id))        + char(10)
	IF(LEN(@p_site_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.SITE_ID' , 'EQ', @p_site_id))        + char(10)
	END
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.PLANT_ID' , 'EQ', @p_plant_id))              + char(10)
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.FACTORY_ID' , 'EQ', @p_factory_id))          + char(10) 
	IF(LEN(@p_item_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.ITEM_ID' , 'LK', @p_item_id))                + char(10)
	END
	SELECT @v_dSql += '					AND   A.FACTORY_ID   = V.FACTORY_ID' + char(10)
	SELECT @v_dSql += '					AND   A.MODEL_ID     = V.MODEL_ID' + char(10)
	SELECT @v_dSql += '					AND   A.ITEM_ID      = V.ITEM_ID' + char(10)
	SELECT @v_dSql += '					AND   A.PROD_VERSION = V.PROD_VERSION' + char(10)
	SELECT @v_dSql += '					AND   A.PROD_SEQ     = V.PROD_SEQ' + char(10)
	SELECT @v_dSql += '					AND   A.COMPANY_ID   = B.COMPANY_ID' + char(10)
	SELECT @v_dSql += '					AND   A.DIVISION_ID  = B.DIVISION_ID' + char(10)
	SELECT @v_dSql += '					AND   A.SITE_ID      = B.SITE_ID' + char(10)
	SELECT @v_dSql += '					AND   A.FOIL_ID      = B.ITEM_ID' + char(10)
	SELECT @v_dSql += '					AND   A.COMPANY_ID   = C.COMPANY_ID' + char(10)
	SELECT @v_dSql += '					AND   A.DIVISION_ID  = C.DIVISION_ID' + char(10)
	SELECT @v_dSql += '					AND   A.SITE_ID      = C.SITE_ID' + char(10)
	SELECT @v_dSql += '					AND   A.PLANT_ID     = C.PLANT_ID' + char(10)
	SELECT @v_dSql += '					AND   A.FACTORY_ID   = C.FACTORY_ID' + char(10)
	SELECT @v_dSql += '					AND   A.ITEM_ID      = C.ITEM_ID' + char(10)
	IF(LEN(@p_operation_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                C.OPERATION_ID' , 'EQ', @p_operation_id))      + char(10)
	END
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            C.LINE_ID' , 'EQ', @p_line_id))                + char(10)
	
	SELECT @v_dSql += '    ) A'+char(10)
	SELECT @v_dSql += '    WHERE  NUM = 1'+char(10)+char(10)
	*/
	-----
	SELECT @v_dSql += '	IF OBJECT_ID(''tempdb..#SCM_PANCAKE_MATERIAL_V'') IS NOT NULL ' + char(10);
	SELECT @v_dSql += '		DROP TABLE #SCM_PANCAKE_MATERIAL_V; ' + char(10)+char(10)

	SELECT @v_dSql += '	 		SELECT   A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.PROD_VERSION_TYPE, A.PROD_TYPE, A.PROD_VERSION, A.PROD_SEQ	' + char(10)
	SELECT @v_dSql += '	 				, A.PC_ITEM_ID, A.MODEL_ID, A.BATCH_ID, A.SLURRY_1, A.SLURRY_2, A.ACTIVE_MATERIAL_1, A.ACTIVE_MATERIAL_2, A.ACTIVE_MATERIAL_3	' + char(10)
	SELECT @v_dSql += '	 				, A.BINDER_1, A.BINDER_2, A.BINDER_3, A.PRE_DISPERSION_ID, A.PRE_DISPERSION_NAME, A.PRE_DISPERSION_ID_2, A.PRE_DISPERSION_NAME_2	' + char(10)
	SELECT @v_dSql += '	 				, A.CMC, A.CONDUCTION_MATERIAL_1, A.CONDUCTION_MATERIAL_2, A.ADDITION_AGENT	' + char(10)
	SELECT @v_dSql += '	 		INTO	#SCM_PANCAKE_MATERIAL_V	' + char(10)
	SELECT @v_dSql += '	 		FROM	(	' + char(10)
	SELECT @v_dSql += '	 					SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.PROD_VERSION_TYPE, A.PROD_TYPE, PAN_PROD_VERSION AS PROD_VERSION, A.PC_ITEM_ID, A.MODEL_ID, A.PROD_SEQ' + char(10)
	SELECT @v_dSql += '	 							, NULL AS BATCH_ID' + char(10)
	SELECT @v_dSql += '	 							, MAX(CASE WHEN A.UI_COLUMN = ''Slurry 1'' THEN A.MATERIAL_ITEM_ID END) AS SLURRY_1' + char(10)
	SELECT @v_dSql += '	 							, MAX(CASE WHEN A.UI_COLUMN = ''Slurry 2'' THEN A.MATERIAL_ITEM_ID END) AS SLURRY_2' + char(10)
	SELECT @v_dSql += '	 							, MAX(CASE WHEN A.UI_COLUMN = ''Active Material 1'' THEN A.DESCRIPTION END) AS ACTIVE_MATERIAL_1' + char(10)
	SELECT @v_dSql += '	 							, MAX(CASE WHEN A.UI_COLUMN = ''Active Material 2'' THEN A.DESCRIPTION END) AS ACTIVE_MATERIAL_2' + char(10)
	SELECT @v_dSql += '	 							, MAX(CASE WHEN A.UI_COLUMN = ''Active Material 3'' THEN A.DESCRIPTION END) AS ACTIVE_MATERIAL_3' + char(10)
	SELECT @v_dSql += '	 							, MAX(CASE WHEN A.UI_COLUMN = ''Binder 1'' THEN A.DESCRIPTION END) AS BINDER_1' + char(10)
	SELECT @v_dSql += '	 							, MAX(CASE WHEN A.UI_COLUMN = ''Binder 2'' THEN A.DESCRIPTION END) AS BINDER_2' + char(10)
	SELECT @v_dSql += '	 							, MAX(CASE WHEN A.UI_COLUMN = ''Binder 3'' THEN A.DESCRIPTION END) AS BINDER_3' + char(10)
	SELECT @v_dSql += '	 							, MAX(CASE WHEN A.UI_COLUMN = ''Pre Dispersion Slurry 1'' THEN A.MATERIAL_ITEM_ID END) AS PRE_DISPERSION_ID' + char(10)
	SELECT @v_dSql += '	 							, MAX(CASE WHEN A.UI_COLUMN = ''Pre Dispersion Slurry 1'' THEN A.DESCRIPTION END) AS PRE_DISPERSION_NAME' + char(10)
	SELECT @v_dSql += '	 							, MAX(CASE WHEN A.UI_COLUMN = ''Pre Dispersion Slurry 2'' THEN A.MATERIAL_ITEM_ID END) AS PRE_DISPERSION_ID_2' + char(10)
	SELECT @v_dSql += '	 							, MAX(CASE WHEN A.UI_COLUMN = ''Pre Dispersion Slurry 2'' THEN A.DESCRIPTION END) AS PRE_DISPERSION_NAME_2' + char(10)
	SELECT @v_dSql += '	 							, MAX(CASE WHEN A.CLASS_NAME = ''CMC'' then A.DESCRIPTION END) AS CMC' + char(10)
	SELECT @v_dSql += '	 							, MAX(CASE WHEN A.UI_COLUMN = ''Conducting Material 1'' THEN A.DESCRIPTION END) AS CONDUCTION_MATERIAL_1' + char(10)
	SELECT @v_dSql += '	 							, MAX(CASE WHEN A.UI_COLUMN = ''Conducting Material 2'' THEN A.DESCRIPTION END) AS CONDUCTION_MATERIAL_2' + char(10)
	SELECT @v_dSql += '	 							, MAX(CASE WHEN A.CLASS_NAME = ''Addition Agent'' THEN A.DESCRIPTION END) AS ADDITION_AGENT' + char(10)
	SELECT @v_dSql += '	 					FROM   SCM_PANCAKE_MATERIAL_ALL_VERSION_V A WITH(NOLOCK)' + char(10)
	SELECT @v_dSql += '	 					WHERE  1=1' + char(10)
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.DIVISION_ID' , 'EQ', @p_division_id))        + char(10)
	IF(LEN(@p_site_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.SITE_ID' , 'EQ', @p_site_id))        + char(10)
	END
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.PLANT_ID' , 'EQ', @p_plant_id))              + char(10)
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.FACTORY_ID' , 'EQ', @p_factory_id))          + char(10) 
	IF(LEN(@p_item_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.PC_ITEM_ID' , 'LK', @p_item_id))                + char(10)
	END
	SELECT @v_dSql += '						GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.PROD_VERSION_TYPE, A.PROD_TYPE, PAN_PROD_VERSION, A.PC_ITEM_ID, A.MODEL_ID, A.PROD_SEQ	'+char(10)
	SELECT @v_dSql += '					) A	'+char(10)+char(10)


	-------------------------
	SELECT @v_dSql += '	if object_id(''tempdb..#T_RELEASE'') is not null ' + char(10);
	SELECT @v_dSql += '		drop table #T_RELEASE; ' + char(10)+char(10)

	--SELECT @v_dSql += 'WITH T_RELEASE AS ( ' + char(10)
	SELECT @v_dSql += 'SELECT A.FACTORY_ID ' + char(10)

	IF ISNULL(@p_day_info,'') <> '' 
	BEGIN
	
		SET @v_delimiter      = '|'  
		SELECT @max_loop_cnt = 0
		SELECT @mst_loop_cnt = 0
		SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) 
	
		IF @max_loop_cnt > 0 
		BEGIN
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN							
				SELECT @mst_loop_cnt = @mst_loop_cnt +1     
				SELECT @v_bucket   = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)                        
				SELECT @v_dSql += '  , MAX(CASE WHEN CONVERT(VARCHAR,A.RELEASE_DATE,112)='+ char(39) +  @v_bucket + char(39) + ' THEN ''#FFFFE6'' ELSE NULL END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +'_BG ' + char(10)
			END
		END 
	END
	SELECT @v_dSql += '   into #T_RELEASE ' + char(10)
	SELECT @v_dSql += '   FROM ( ' + char(10)
	SELECT @v_dSql += '		SELECT A.FACTORY_ID, CONVERT(VARCHAR,B.INSERT_TIME,112) AS RELEASE_DATE ' + char(10)
	SELECT @v_dSql += '        FROM ( ' + char(10)
	SELECT @v_dSql += '              SELECT  A.INSTANCE_ID, A.RELEASE_PLAN_ID AS PLAN_ID, ''BUILDING'' AS CONFIRM_AREA ' + char(10)
	SELECT @v_dSql += '                    , A.FACTORY_ID, A.INSERT_TIME ' + char(10)
	SELECT @v_dSql += '                    , DENSE_RANK() OVER(PARTITION BY A.FACTORY_ID ORDER BY A.INSERT_TIME DESC) SORT_ORDER ' + char(10)
	SELECT @v_dSql += '              FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK) ' + char(10)
	SELECT @v_dSql += '                  , ( ' + char(10)
	SELECT @v_dSql += '                        SELECT DISTINCT A.INSTANCE_ID, A.FACTORY_ID ' + char(10)
	SELECT @v_dSql += '                        FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK) ' + char(10)
	SELECT @v_dSql += '                        WHERE  A.ACTIVE_FLAG = ''Y'' ' + char(10)
	SELECT @v_dSql += '                        AND    A.INSTANCE_ID = ' + char(39) + @p_instance_id + char(39)  +  char(10)
	SELECT @v_dSql += '                    ) B ' + char(10)
	SELECT @v_dSql += '              WHERE  A.INSTANCE_ID  = B.INSTANCE_ID ' + char(10)
	SELECT @v_dSql += '              AND    A.FACTORY_ID   = B.FACTORY_ID                        ' + char(10) 
	SELECT @v_dSql += '              AND    A.INSTANCE_ID  = ' + char(39) + @p_instance_id + char(39) + char(10)
	SELECT @v_dSql += '          ) A ' + char(10)
	SELECT @v_dSql += '          , SCM_FP_PLAN_H B WITH(NOLOCK) ' + char(10)
	SELECT @v_dSql += '        WHERE A.INSTANCE_ID  = B.INSTANCE_ID ' + char(10)
	SELECT @v_dSql += '        AND   A.PLAN_ID      = B.PLAN_ID ' + char(10)
	SELECT @v_dSql += '        AND   A.SORT_ORDER   = 1 ' + char(10)
	SELECT @v_dSql += '        AND   A.CONFIRM_AREA IN ( ' + char(10)
	SELECT @v_dSql += '                  SELECT MAX(A.ATTRIBUTE1) AS CONFIRM_AREA ' + char(10)
	SELECT @v_dSql += '                  FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
	SELECT @v_dSql += '                  WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_ID'' ' + char(10)
	SELECT @v_dSql += '                  AND    A.SEGMENT1         = ' + char(39) + @p_instance_id + char(39) + char(10)
	SELECT @v_dSql += '                  AND    A.ACTIVE_FLAG      = ''Y'' ' + char(10)
	SELECT @v_dSql += '              )  ' + char(10)
	SELECT @v_dSql += '    ) A' + char(10)
	SELECT @v_dSql += '    GROUP BY A.FACTORY_ID' + char(10)
--	SELECT @v_dSql += ' )' + char(10)

	-------------------------
	SELECT @v_dSql += '	if object_id(''tempdb..#T_VERSION'') is not null ' + char(10);
	SELECT @v_dSql += '		drop table #T_VERSION; ' + char(10)+char(10)

--	SELECT @v_dSql += ' , T_VERSION AS (' + char(10)
	SELECT @v_dSql += '        SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + char(10)
	SELECT @v_dSql += '            , A.OPERATION AS OPERATION_ID' + char(10)
	SELECT @v_dSql += '            , A.MODEL_ID' + char(10)
	SELECT @v_dSql += '            , A.ITEM_ID' + char(10)
	SELECT @v_dSql += '            , A.PROD_VERSION_TYPE' + char(10)
	SELECT @v_dSql += '            , A.VERSION, A.VERSION_TYPE' + char(10)
	SELECT @v_dSql += '            , CASE WHEN A.CATEGORY = ''Pancake (m/batch)'' THEN ''M(P/C)''' + char(10)
	SELECT @v_dSql += '                WHEN A.CATEGORY = ''Jumbo Roll (m/batch)'' THEN ''J/R''' + char(10)
	SELECT @v_dSql += '                WHEN A.CATEGORY = ''cell/batch'' THEN ''Cell''' + char(10)
	SELECT @v_dSql += '                ELSE	''BATCH'' END AS CATEGORY' + char(10)
	SELECT @v_dSql += '            , MAX(A.VALUE) AS CAL' + char(10)
	SELECT @v_dSql += '        into #T_VERSION' + char(10)

	SELECT @v_dSql += '        FROM   SCM_ITEM_CONV_CALC_M A WITH(NOLOCK)' + char(10)
	SELECT @v_dSql += '        WHERE  A.MAX_VER_FLAG = ''Y''' + char(10)

	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.DIVISION_ID' , 'EQ', @p_division_id))        + char(10)

	IF(LEN(@p_site_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.SITE_ID' , 'EQ', @p_site_id))        + char(10)
	END

	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.PLANT_ID' , 'EQ', @p_plant_id))              + char(10)
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.FACTORY_ID' , 'EQ', @p_factory_id))          + char(10) 

	IF(LEN(@p_operation_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.OPERATION' , 'EQ', @p_operation_id))      + char(10)
	END

	IF(LEN(@p_item_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                 A.ITEM_ID' , 'LK', @p_item_id))        + char(10)
	END

	SELECT @v_dSql += ' AND A.CATEGORY IN (''cell/batch'', ''Jumbo Roll (m/batch)'', ''Pancake (m/batch)'') ' + char(10)
	SELECT @v_dSql += '       GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + char(10)
	SELECT @v_dSql += ' 	  	        , A.OPERATION' + char(10)
	SELECT @v_dSql += ' 	  	        , A.MODEL_ID' + char(10)
	SELECT @v_dSql += ' 	  	        , A.ITEM_ID' + char(10)
	SELECT @v_dSql += ' 	  	        , A.PROD_VERSION_TYPE ' + char(10)
	SELECT @v_dSql += ' 	  	        , A.VERSION, A.VERSION_TYPE' + char(10)
	SELECT @v_dSql += ' 	  	        , A.CATEGORY' + char(10)
--	SELECT @v_dSql += '  )' + char(10)


	-------------------------
	SELECT @v_dSql += '	if object_id(''tempdb..#MAIN'') is not null ' + char(10);
	SELECT @v_dSql += '		drop table #MAIN; ' + char(10)+char(10)

--	SELECT @v_dSql += '  , MAIN AS (' + char(10)
	SELECT @v_dSql += ' 	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + char(10)
	SELECT @v_dSql += '                , A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME' + char(10)
	SELECT @v_dSql += '                , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE' + char(10)
	SELECT @v_dSql += '                , A.EQUIPMENT_ID' + char(10)
	SELECT @v_dSql += '                , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME' + char(10)
	SELECT @v_dSql += '                , A.PRODUCTION_TYPE, A.MARKET' + char(10)
	SELECT @v_dSql += '                , E.BATCH_ID ' + char(10)
	SELECT @v_dSql += '                , E.SLURRY_1, E.SLURRY_2 ' + char(10)
	SELECT @v_dSql += '                , E.PRE_DISPERSION_ID ' + char(10)
	SELECT @v_dSql += '                , E.PRE_DISPERSION_NAME ' + char(10)
	SELECT @v_dSql += '                , E.PRE_DISPERSION_ID_2 ' + char(10)
	SELECT @v_dSql += '                , E.PRE_DISPERSION_NAME_2 ' + char(10)
	SELECT @v_dSql += '                , E.ACTIVE_MATERIAL_1 ' + char(10)
	SELECT @v_dSql += '                , E.ACTIVE_MATERIAL_2 ' + char(10)
	SELECT @v_dSql += '                , E.ACTIVE_MATERIAL_3 ' + char(10)
	SELECT @v_dSql += '                , E.BINDER_1 ' + char(10)
	SELECT @v_dSql += '                , E.BINDER_2 ' + char(10)
	SELECT @v_dSql += '                , E.BINDER_3 ' + char(10)
	SELECT @v_dSql += '                , E.CONDUCTION_MATERIAL_1 ' + char(10)
	SELECT @v_dSql += '                , E.CONDUCTION_MATERIAL_2 ' + char(10)
	SELECT @v_dSql += '                , E.CMC ' + char(10)
	SELECT @v_dSql += '                , A.VERSION ' + char(10)
	SELECT @v_dSql += '                , A.WORK_REQUEST_MODEL_ID AS PC_MODEL_ID ' + char(10)
	SELECT @v_dSql += '                , E.ADDITION_AGENT AS ADDITION_AGENT ' + char(10)
	/*
	SELECT @v_dSql += '                , ISNULL(E.BATCH_ID,F.BATCH_ID) AS BATCH_ID' + char(10)
	SELECT @v_dSql += '                , ISNULL(E.SLURRY_1,F.SLURRY_1) AS SLURRY_1, ISNULL(E.SLURRY_2,F.SLURRY_2) AS SLURRY_2' +char(10)
	SELECT @v_dSql += '                , ISNULL(E.PRE_DISPERSION_ID,F.PRE_DISPERSION_ID) AS PRE_DISPERSION_ID' +char(10)
	SELECT @v_dSql += '                , ISNULL(E.PRE_DISPERSION_NAME,F.PRE_DISPERSION_NAME) AS PRE_DISPERSION_NAME' +char(10)
	SELECT @v_dSql += '                , ISNULL(E.PRE_DISPERSION_ID_2,F.PRE_DISPERSION_ID_2) AS PRE_DISPERSION_ID_2' +char(10)
	SELECT @v_dSql += '                , ISNULL(E.PRE_DISPERSION_NAME_2,F.PRE_DISPERSION_NAME_2) AS PRE_DISPERSION_NAME_2' +char(10)
	SELECT @v_dSql += '                , ISNULL(E.ACTIVE_MATERIAL_1,F.ACTIVE_MATERIAL_1) AS ACTIVE_MATERIAL_1' +char(10)
	SELECT @v_dSql += '                , ISNULL(E.ACTIVE_MATERIAL_2,F.ACTIVE_MATERIAL_2) AS ACTIVE_MATERIAL_2' +char(10)
	SELECT @v_dSql += '                , ISNULL(E.ACTIVE_MATERIAL_3,F.ACTIVE_MATERIAL_3) AS ACTIVE_MATERIAL_3' +char(10)
	SELECT @v_dSql += '                , ISNULL(E.BINDER_1,F.BINDER_1) AS BINDER_1' +char(10)
	SELECT @v_dSql += '                , ISNULL(E.BINDER_2,F.BINDER_2) AS BINDER_2' +char(10)
	SELECT @v_dSql += '                , ISNULL(E.BINDER_3,F.BINDER_3) AS BINDER_3' +char(10)
	SELECT @v_dSql += '                , ISNULL(E.CONDUCTION_MATERIAL_1,F.CONDUCTION_MATERIAL_1) AS CONDUCTION_MATERIAL_1' +char(10)
	SELECT @v_dSql += '                , ISNULL(E.CONDUCTION_MATERIAL_2,F.CONDUCTION_MATERIAL_2) AS CONDUCTION_MATERIAL_2' +char(10)
	SELECT @v_dSql += '                , ISNULL(E.CMC,F.CMC) AS CMC' +char(10)
	SELECT @v_dSql += '                , A.VERSION' +char(10)
	--SELECT @v_dSql += '                , ISNULL(E.MODEL_ID,F.MODEL_ID) AS PC_MODEL_ID' +char(10)
	SELECT @v_dSql += '                , A.WORK_REQUEST_MODEL_ID AS PC_MODEL_ID' +char(10)
	SELECT @v_dSql += '                , ISNULL(E.ADDITION_AGENT,F.ADDITION_AGENT) AS ADDITION_AGENT ' +char(10)
	*/
	SELECT @v_dSql += '                , ISNULL(H.FOIL_CODE, dbo.FN_GET_FOIL(A.FACTORY_ID, A.ITEM_ID, A.PROD_VERSION_TYPE, ''FOIL_CODE'')) AS FOIL_CODE' +char(10)
	SELECT @v_dSql += '                , ISNULL(H.FOIL, dbo.FN_GET_FOIL(A.FACTORY_ID, A.ITEM_ID,A.PROD_VERSION_TYPE, ''FOIL'')) AS FOIL' +char(10)
	SELECT @v_dSql += '                , G.DAILY_CAPA_PPM  AS DC_PPM' +char(10)
	SELECT @v_dSql += '                , A.CATEGORY_NAME' +char(10)
	SELECT @v_dSql += '                , A.MEASURE_NAME' +char(10)

	IF ISNULL(@p_day_info,'') <> '' 
	BEGIN

		SET @v_delimiter      = '|'  
		SELECT @max_loop_cnt = 0
		SELECT @mst_loop_cnt = 0
		SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) 

		IF @max_loop_cnt > 0 
		BEGIN
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN							
				SELECT @mst_loop_cnt = @mst_loop_cnt +1                                
				SELECT @v_dSql += '  , M'+   TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
			END
		END 

		SET @v_delimiter      = '|'  
		SELECT @max_loop_cnt = 0
		SELECT @mst_loop_cnt = 0
		SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) 

		IF @max_loop_cnt > 0 
		BEGIN
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN							
				SELECT @mst_loop_cnt = @mst_loop_cnt +1                         
				SELECT @v_dSql += '  , W'+   TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
			END
		END 

		SET @v_delimiter      = '|'  
		SELECT @max_loop_cnt = 0
		SELECT @mst_loop_cnt = 0
		SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) 

		IF @max_loop_cnt > 0 
		BEGIN
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN							
				SELECT @mst_loop_cnt = @mst_loop_cnt +1                         
				SELECT @v_dSql += '  , D'+   TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
			END
		END 

		SET @v_delimiter      = '|'  
		SELECT @max_loop_cnt = 0
		SELECT @mst_loop_cnt = 0
		SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) 

		IF @max_loop_cnt > 0 
		BEGIN
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN							
				SELECT @mst_loop_cnt = @mst_loop_cnt +1                         
				SELECT @v_dSql += '  , T'+   TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
			END
		END 

		SET @v_delimiter      = '|'  
		SELECT @max_loop_cnt = 0
		SELECT @mst_loop_cnt = 0
		SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) 

		IF @max_loop_cnt > 0 
		BEGIN
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN							
				SELECT @mst_loop_cnt = @mst_loop_cnt +1                         
				SELECT @v_dSql += '  , CASE  WHEN A.D'+   TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_BG IS NOT NULL AND A.D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_BG <> ''''  THEN A.D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)+ '_BG ELSE Z.D'  + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)+ '_BG END D'  + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)  + '_BG' + char(10)   
			END
		END 

	END

	SELECT @v_dSql += '             , A.CATEGORY_ID' + char(10)
	SELECT @v_dSql += '             , A.CATEGORY_ORDER' + char(10)
	SELECT @v_dSql += '             , A.DATA_TYPE' + char(10)
	SELECT @v_dSql += '             , ISNULL(B.LINE_SEQ, 9999) LINE_SEQ' + char(10)
	SELECT @v_dSql += '             , A.CALC_TYPE' + char(10)
	SELECT @v_dSql += '             , A.PROD_SEQ' + char(10)
	SELECT @v_dSql += '             , A.PLM_EC_NO' + char(10)
	SELECT @v_dSql += '  into #MAIN' + char(10)
	SELECT @v_dSql += '  FROM (' + char(10)
	SELECT @v_dSql += '        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + char(10)
	SELECT @v_dSql += '             , A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME' + char(10)
	SELECT @v_dSql += '             , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE' + char(10)
	SELECT @v_dSql += '             , A.EQUIPMENT_ID' + char(10)
	SELECT @v_dSql += '             , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME' + char(10)
	SELECT @v_dSql += '             , A.PRODUCTION_TYPE, A.MARKET, A.PROD_VERSION_TYPE' + char(10)
	SELECT @v_dSql += '             , B.CATEGORY_NAME AS CATEGORY_NAME' + char(10)
	SELECT @v_dSql += '             , B.MEASURE_NAME AS MEASURE_NAME' + char(10)
			        				  
	IF ISNULL(@p_day_info,'') <> '' 
	BEGIN
		SET @v_delimiter      = '|'  
		SELECT @max_loop_cnt = 0
		SELECT @mst_loop_cnt = 0
		SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) 
    
		IF @max_loop_cnt > 0 
		BEGIN
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN							
				SELECT @mst_loop_cnt = @mst_loop_cnt +1     
				SELECT @v_month_info   = [dbo].[SCM_ARR_SPL_VAL](@p_month_info ,@v_delimiter, @mst_loop_cnt)         
                       
				SELECT @v_dSql += ' , SUM(CASE WHEN C.YYYYMM='+ char(39) + @v_month_info + char(39)+ ' THEN (CASE WHEN A.PLAN_TYPE = ''RELEASE'' AND B.CATEGORY_ID=''P_IN_M'' THEN CEILING(A.ADJUST_IN_QTY_M) ' + char(10)
				SELECT @v_dSql += '                 WHEN A.PLAN_TYPE = ''RELEASE'' AND B.CATEGORY_ID=''P_IN_JR'' THEN CEILING(A.ADJUST_IN_QTY_JR) ' + char(10)
				SELECT @v_dSql += '                 WHEN A.PLAN_TYPE = ''RELEASE'' AND B.CATEGORY_ID=''P_IN_CELL'' THEN CEILING(A.ADJUST_IN_QTY_CELL) ' + char(10)
				SELECT @v_dSql += '                 WHEN A.PLAN_TYPE = ''RELEASE'' AND B.CATEGORY_ID=''P_IN_BATCH'' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2) ' + char(10)
				SELECT @v_dSql += '                 WHEN A.PLAN_TYPE = ''RELEASE'' AND B.CATEGORY_ID=''P_OUT_M'' THEN CEILING(A.ADJUST_OUT_QTY_M) ' + char(10)
				SELECT @v_dSql += '                 WHEN A.PLAN_TYPE = ''RELEASE'' AND B.CATEGORY_ID=''P_OUT_JR'' THEN CEILING(A.ADJUST_OUT_QTY_JR) ' + char(10)
				SELECT @v_dSql += '                 WHEN A.PLAN_TYPE = ''RELEASE'' AND B.CATEGORY_ID=''P_OUT_CELL'' THEN CEILING(A.ADJUST_OUT_QTY_CELL) ' + char(10)
				SELECT @v_dSql += '                 WHEN A.PLAN_TYPE = ''RELEASE'' AND B.CATEGORY_ID=''P_OUT_BATCH'' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) ' + char(10)
			
				SELECT @v_dSql += '                  WHEN A.PLAN_TYPE = ''MPP'' AND B.CATEGORY_ID=''P_MPP_IN_M'' THEN CEILING(A.ADJUST_IN_QTY_M) ' + char(10)
				SELECT @v_dSql += '                  WHEN A.PLAN_TYPE = ''MPP'' AND B.CATEGORY_ID=''P_MPP_IN_JR'' THEN CEILING(A.ADJUST_IN_QTY_JR) ' + char(10)
				SELECT @v_dSql += '                  WHEN A.PLAN_TYPE = ''MPP'' AND B.CATEGORY_ID=''P_MPP_IN_CELL'' THEN CEILING(A.ADJUST_IN_QTY_CELL) ' + char(10)
				SELECT @v_dSql += '                  WHEN A.PLAN_TYPE = ''MPP'' AND B.CATEGORY_ID=''P_MPP_IN_BATCH'' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2) ' + char(10)
				SELECT @v_dSql += '                  WHEN A.PLAN_TYPE = ''MPP'' AND B.CATEGORY_ID=''P_MPP_OUT_M'' THEN CEILING(A.ADJUST_OUT_QTY_M) ' + char(10)
				SELECT @v_dSql += '                  WHEN A.PLAN_TYPE = ''MPP'' AND B.CATEGORY_ID=''P_MPP_OUT_JR'' THEN CEILING(A.ADJUST_OUT_QTY_JR) ' + char(10)
				SELECT @v_dSql += '                  WHEN A.PLAN_TYPE = ''MPP'' AND B.CATEGORY_ID=''P_MPP_OUT_CELL'' THEN CEILING(A.ADJUST_OUT_QTY_CELL) ' + char(10)
				SELECT @v_dSql += '                  WHEN A.PLAN_TYPE = ''MPP'' AND B.CATEGORY_ID=''P_MPP_OUT_BATCH'' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) ' + char(10)
			
				SELECT @v_dSql += '                  WHEN A.PLAN_TYPE = ''WPP'' AND B.CATEGORY_ID=''P_WPP_IN_M'' THEN CEILING(A.ADJUST_IN_QTY_M) ' + char(10)
				SELECT @v_dSql += '                  WHEN A.PLAN_TYPE = ''WPP'' AND B.CATEGORY_ID=''P_WPP_IN_JR'' THEN CEILING(A.ADJUST_IN_QTY_JR) ' + char(10)
				SELECT @v_dSql += '                  WHEN A.PLAN_TYPE = ''WPP'' AND B.CATEGORY_ID=''P_WPP_IN_CELL'' THEN CEILING(A.ADJUST_IN_QTY_CELL) ' + char(10)
				SELECT @v_dSql += '                  WHEN A.PLAN_TYPE = ''WPP'' AND B.CATEGORY_ID=''P_WPP_IN_BATCH'' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2) ' + char(10)
				SELECT @v_dSql += '                  WHEN A.PLAN_TYPE = ''WPP'' AND B.CATEGORY_ID=''P_WPP_OUT_M'' THEN CEILING(A.ADJUST_OUT_QTY_M) ' + char(10)
				SELECT @v_dSql += '                  WHEN A.PLAN_TYPE = ''WPP'' AND B.CATEGORY_ID=''P_WPP_OUT_JR'' THEN CEILING(A.ADJUST_OUT_QTY_JR) ' + char(10)
				SELECT @v_dSql += '                  WHEN A.PLAN_TYPE = ''WPP'' AND B.CATEGORY_ID=''P_WPP_OUT_CELL'' THEN CEILING(A.ADJUST_OUT_QTY_CELL) ' + char(10)
				SELECT @v_dSql += '                  WHEN A.PLAN_TYPE = ''WPP'' AND B.CATEGORY_ID=''P_WPP_OUT_BATCH'' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) ' + char(10)
			
				SELECT @v_dSql += '                  WHEN A.PLAN_TYPE = ''RESULT'' AND B.CATEGORY_ID=''P_RESULT_IN_M'' THEN CEILING(A.ADJUST_RESULT_IN_QTY_M) ' + char(10)
				SELECT @v_dSql += '                  WHEN A.PLAN_TYPE = ''RESULT'' AND B.CATEGORY_ID=''P_RESULT_IN_JR'' THEN CEILING(A.ADJUST_RESULT_IN_QTY_JR) ' + char(10)
				SELECT @v_dSql += '                  WHEN A.PLAN_TYPE = ''RESULT'' AND B.CATEGORY_ID=''P_RESULT_IN_CELL'' THEN CEILING(A.ADJUST_RESULT_IN_QTY_CELL) ' + char(10)
				SELECT @v_dSql += '                  WHEN A.PLAN_TYPE = ''RESULT'' AND B.CATEGORY_ID=''P_RESULT_IN_BATCH'' THEN ROUND(A.ADJUST_RESULT_IN_QTY_BATCH,2) ' + char(10)
				SELECT @v_dSql += '                  WHEN A.PLAN_TYPE = ''RESULT'' AND B.CATEGORY_ID=''P_RESULT_OUT_M'' THEN CEILING(A.ADJUST_RESULT_OUT_QTY_M) ' + char(10)
				SELECT @v_dSql += '                  WHEN A.PLAN_TYPE = ''RESULT'' AND B.CATEGORY_ID=''P_RESULT_OUT_JR'' THEN CEILING(A.ADJUST_RESULT_OUT_QTY_JR) ' + char(10)
				SELECT @v_dSql += '                  WHEN A.PLAN_TYPE = ''RESULT'' AND B.CATEGORY_ID=''P_RESULT_OUT_CELL'' THEN CEILING(A.ADJUST_RESULT_OUT_QTY_CELL) ' + char(10)
				SELECT @v_dSql += '                  WHEN A.PLAN_TYPE = ''RESULT'' AND B.CATEGORY_ID=''P_RESULT_OUT_BATCH'' THEN ROUND(A.ADJUST_RESULT_OUT_QTY_BATCH,2) ' + char(10)
				SELECT @v_dSql += '                  WHEN A.PLAN_TYPE = ''OFFTIME'' AND B.CATEGORY_ID=''P_OFFTIME'' THEN A.OFF_TIME ' + char(10)
				SELECT @v_dSql += '                  WHEN B.CATEGORY_ID=''P_SEQ'' THEN NULL ' + char(10)
				SELECT @v_dSql += '                  WHEN B.CATEGORY_ID=''P_MEMO'' THEN NULL ' + char(10)
				SELECT @v_dSql += '                  ELSE 0 END) ELSE 0 END) AS M' +TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)+ char(10)
			END
		END 

		SET @v_delimiter      = '|'  
		SELECT @max_loop_cnt = 0
		SELECT @mst_loop_cnt = 0
		SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) 

		IF @max_loop_cnt > 0 
		BEGIN
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN							
				SELECT @mst_loop_cnt = @mst_loop_cnt +1     
				SELECT @v_week_info   = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)                         
				--SELECT @v_dSql += '               , SUM(CASE WHEN C.ISO_YYYYWW='+ char(39) + @v_week_info +  char(39) + ' THEN (CASE WHEN A.PLAN_TYPE = ''RELEASE'' AND B.CATEGORY_ID=''P_IN_M'' THEN CEILING(A.ADJUST_IN_QTY_M) ' + char(10)
				SELECT @v_dSql += '               , SUM(CASE WHEN C.' + @WeekColumn + '='+ char(39) + @v_week_info +  char(39) + ' THEN (CASE WHEN A.PLAN_TYPE = ''RELEASE'' AND B.CATEGORY_ID=''P_IN_M'' THEN CEILING(A.ADJUST_IN_QTY_M) ' + char(10)
				SELECT @v_dSql += '                 WHEN A.PLAN_TYPE = ''RELEASE'' AND B.CATEGORY_ID=''P_IN_JR'' THEN CEILING(A.ADJUST_IN_QTY_JR) ' + char(10)
				SELECT @v_dSql += '                 WHEN A.PLAN_TYPE = ''RELEASE'' AND B.CATEGORY_ID=''P_IN_CELL'' THEN CEILING(A.ADJUST_IN_QTY_CELL) ' + char(10)
				SELECT @v_dSql += '                 WHEN A.PLAN_TYPE = ''RELEASE'' AND B.CATEGORY_ID=''P_IN_BATCH'' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2) ' + char(10)
				SELECT @v_dSql += '                 WHEN A.PLAN_TYPE = ''RELEASE'' AND B.CATEGORY_ID=''P_OUT_M'' THEN CEILING(A.ADJUST_OUT_QTY_M) ' + char(10)
				SELECT @v_dSql += '                 WHEN A.PLAN_TYPE = ''RELEASE'' AND B.CATEGORY_ID=''P_OUT_JR'' THEN CEILING(A.ADJUST_OUT_QTY_JR) ' + char(10)
				SELECT @v_dSql += '                 WHEN A.PLAN_TYPE = ''RELEASE'' AND B.CATEGORY_ID=''P_OUT_CELL'' THEN CEILING(A.ADJUST_OUT_QTY_CELL) ' + char(10)
				SELECT @v_dSql += '                 WHEN A.PLAN_TYPE = ''RELEASE'' AND B.CATEGORY_ID=''P_OUT_BATCH'' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) ' + char(10)
			
				SELECT @v_dSql += '                 WHEN A.PLAN_TYPE = ''MPP'' AND B.CATEGORY_ID=''P_MPP_IN_M'' THEN CEILING(A.ADJUST_IN_QTY_M) ' + char(10)
				SELECT @v_dSql += '                 WHEN A.PLAN_TYPE = ''MPP'' AND B.CATEGORY_ID=''P_MPP_IN_JR'' THEN CEILING(A.ADJUST_IN_QTY_JR) ' + char(10)
				SELECT @v_dSql += '                 WHEN A.PLAN_TYPE = ''MPP'' AND B.CATEGORY_ID=''P_MPP_IN_CELL'' THEN CEILING(A.ADJUST_IN_QTY_CELL) ' + char(10)
				SELECT @v_dSql += '                 WHEN A.PLAN_TYPE = ''MPP'' AND B.CATEGORY_ID=''P_MPP_IN_BATCH'' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2) ' + char(10)
				SELECT @v_dSql += '                 WHEN A.PLAN_TYPE = ''MPP'' AND B.CATEGORY_ID=''P_MPP_OUT_M'' THEN CEILING(A.ADJUST_OUT_QTY_M) ' + char(10)
				SELECT @v_dSql += '                 WHEN A.PLAN_TYPE = ''MPP'' AND B.CATEGORY_ID=''P_MPP_OUT_JR'' THEN CEILING(A.ADJUST_OUT_QTY_JR) ' + char(10)
				SELECT @v_dSql += '                 WHEN A.PLAN_TYPE = ''MPP'' AND B.CATEGORY_ID=''P_MPP_OUT_CELL'' THEN CEILING(A.ADJUST_OUT_QTY_CELL) ' + char(10)
				SELECT @v_dSql += '                 WHEN A.PLAN_TYPE = ''MPP'' AND B.CATEGORY_ID=''P_MPP_OUT_BATCH'' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) ' + char(10)
			
				SELECT @v_dSql += '                 WHEN A.PLAN_TYPE = ''WPP'' AND B.CATEGORY_ID=''P_WPP_IN_M'' THEN CEILING(A.ADJUST_IN_QTY_M) ' + char(10)
				SELECT @v_dSql += '                 WHEN A.PLAN_TYPE = ''WPP'' AND B.CATEGORY_ID=''P_WPP_IN_JR'' THEN CEILING(A.ADJUST_IN_QTY_JR) ' + char(10)
				SELECT @v_dSql += '                 WHEN A.PLAN_TYPE = ''WPP'' AND B.CATEGORY_ID=''P_WPP_IN_CELL'' THEN CEILING(A.ADJUST_IN_QTY_CELL) ' + char(10)
				SELECT @v_dSql += '                 WHEN A.PLAN_TYPE = ''WPP'' AND B.CATEGORY_ID=''P_WPP_IN_BATCH'' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2) ' + char(10)
				SELECT @v_dSql += '                 WHEN A.PLAN_TYPE = ''WPP'' AND B.CATEGORY_ID=''P_WPP_OUT_M'' THEN CEILING(A.ADJUST_OUT_QTY_M) ' + char(10)
				SELECT @v_dSql += '                 WHEN A.PLAN_TYPE = ''WPP'' AND B.CATEGORY_ID=''P_WPP_OUT_JR'' THEN CEILING(A.ADJUST_OUT_QTY_JR) ' + char(10)
				SELECT @v_dSql += '                 WHEN A.PLAN_TYPE = ''WPP'' AND B.CATEGORY_ID=''P_WPP_OUT_CELL'' THEN CEILING(A.ADJUST_OUT_QTY_CELL) ' + char(10)
				SELECT @v_dSql += '                 WHEN A.PLAN_TYPE = ''WPP'' AND B.CATEGORY_ID=''P_WPP_OUT_BATCH'' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) ' + char(10)
			
				SELECT @v_dSql += '                 WHEN A.PLAN_TYPE = ''RESULT'' AND B.CATEGORY_ID=''P_RESULT_IN_M'' THEN CEILING(A.ADJUST_RESULT_IN_QTY_M) ' + char(10)
				SELECT @v_dSql += '                 WHEN A.PLAN_TYPE = ''RESULT'' AND B.CATEGORY_ID=''P_RESULT_IN_JR'' THEN CEILING(A.ADJUST_RESULT_IN_QTY_JR) ' + char(10)
				SELECT @v_dSql += '                 WHEN A.PLAN_TYPE = ''RESULT'' AND B.CATEGORY_ID=''P_RESULT_IN_CELL'' THEN CEILING(A.ADJUST_RESULT_IN_QTY_CELL) ' + char(10)
				SELECT @v_dSql += '                 WHEN A.PLAN_TYPE = ''RESULT'' AND B.CATEGORY_ID=''P_RESULT_IN_BATCH'' THEN ROUND(A.ADJUST_RESULT_IN_QTY_BATCH,2) ' + char(10)
				SELECT @v_dSql += '                 WHEN A.PLAN_TYPE = ''RESULT'' AND B.CATEGORY_ID=''P_RESULT_OUT_M'' THEN CEILING(A.ADJUST_RESULT_OUT_QTY_M) ' + char(10)
				SELECT @v_dSql += '                 WHEN A.PLAN_TYPE = ''RESULT'' AND B.CATEGORY_ID=''P_RESULT_OUT_JR'' THEN CEILING(A.ADJUST_RESULT_OUT_QTY_JR) ' + char(10)
				SELECT @v_dSql += '                 WHEN A.PLAN_TYPE = ''RESULT'' AND B.CATEGORY_ID=''P_RESULT_OUT_CELL'' THEN CEILING(A.ADJUST_RESULT_OUT_QTY_CELL) ' + char(10)
				SELECT @v_dSql += '                 WHEN A.PLAN_TYPE = ''RESULT'' AND B.CATEGORY_ID=''P_RESULT_OUT_BATCH'' THEN ROUND(A.ADJUST_RESULT_OUT_QTY_BATCH,2) ' + char(10)
				SELECT @v_dSql += '                 WHEN A.PLAN_TYPE = ''OFFTIME'' AND B.CATEGORY_ID=''P_OFFTIME'' THEN A.OFF_TIME ' + char(10)
				SELECT @v_dSql += '  	            WHEN B.CATEGORY_ID=''P_SEQ'' THEN NULL ' + char(10)
				SELECT @v_dSql += '  	            WHEN B.CATEGORY_ID=''P_MEMO'' THEN NULL ' + char(10)
				SELECT @v_dSql += '                 ELSE 0 END) ELSE 0 END) AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
			END
		END 


		SET @v_delimiter      = '|'  
		SELECT @max_loop_cnt = 0
		SELECT @mst_loop_cnt = 0
		SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) 

		IF @max_loop_cnt > 0 
		BEGIN
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN							
				SELECT @mst_loop_cnt = @mst_loop_cnt +1     
				SELECT @v_day_info   = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)   
				SELECT @v_dSql += ' , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)=' + char(39) + @v_day_info + char(39) + 'THEN (CASE WHEN A.PLAN_TYPE = ''RELEASE'' AND B.CATEGORY_ID=''P_IN_M'' THEN CEILING(A.ADJUST_IN_QTY_M)' + char(10)
				SELECT @v_dSql += '      WHEN A.PLAN_TYPE = ''RELEASE'' AND B.CATEGORY_ID=''P_IN_JR'' THEN CEILING(A.ADJUST_IN_QTY_JR) ' + char(10)
				SELECT @v_dSql += '      WHEN A.PLAN_TYPE = ''RELEASE'' AND B.CATEGORY_ID=''P_IN_CELL'' THEN CEILING(A.ADJUST_IN_QTY_CELL) ' + char(10)
				SELECT @v_dSql += '      WHEN A.PLAN_TYPE = ''RELEASE'' AND B.CATEGORY_ID=''P_IN_BATCH'' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2) ' + char(10)
				SELECT @v_dSql += '      WHEN A.PLAN_TYPE = ''RELEASE'' AND B.CATEGORY_ID=''P_OUT_M'' THEN CEILING(A.ADJUST_OUT_QTY_M) ' + char(10)
				SELECT @v_dSql += '      WHEN A.PLAN_TYPE = ''RELEASE'' AND B.CATEGORY_ID=''P_OUT_JR'' THEN CEILING(A.ADJUST_OUT_QTY_JR) ' + char(10)
				SELECT @v_dSql += '      WHEN A.PLAN_TYPE = ''RELEASE'' AND B.CATEGORY_ID=''P_OUT_CELL'' THEN CEILING(A.ADJUST_OUT_QTY_CELL) ' + char(10)
				SELECT @v_dSql += '      WHEN A.PLAN_TYPE = ''RELEASE'' AND B.CATEGORY_ID=''P_OUT_BATCH'' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) ' + char(10)
				SELECT @v_dSql += '      WHEN A.PLAN_TYPE = ''MPP'' AND B.CATEGORY_ID=''P_MPP_IN_M'' THEN CEILING(A.ADJUST_IN_QTY_M) ' + char(10)
				SELECT @v_dSql += '      WHEN A.PLAN_TYPE = ''MPP'' AND B.CATEGORY_ID=''P_MPP_IN_JR'' THEN CEILING(A.ADJUST_IN_QTY_JR) ' + char(10)
				SELECT @v_dSql += '      WHEN A.PLAN_TYPE = ''MPP'' AND B.CATEGORY_ID=''P_MPP_IN_CELL'' THEN CEILING(A.ADJUST_IN_QTY_CELL) ' + char(10)
				SELECT @v_dSql += '      WHEN A.PLAN_TYPE = ''MPP'' AND B.CATEGORY_ID=''P_MPP_IN_BATCH'' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2) ' + char(10)
				SELECT @v_dSql += '      WHEN A.PLAN_TYPE = ''MPP'' AND B.CATEGORY_ID=''P_MPP_OUT_M'' THEN CEILING(A.ADJUST_OUT_QTY_M) ' + char(10)
				SELECT @v_dSql += '      WHEN A.PLAN_TYPE = ''MPP'' AND B.CATEGORY_ID=''P_MPP_OUT_JR'' THEN CEILING(A.ADJUST_OUT_QTY_JR) ' + char(10)
				SELECT @v_dSql += '      WHEN A.PLAN_TYPE = ''MPP'' AND B.CATEGORY_ID=''P_MPP_OUT_CELL'' THEN CEILING(A.ADJUST_OUT_QTY_CELL) ' + char(10)
				SELECT @v_dSql += '      WHEN A.PLAN_TYPE = ''MPP'' AND B.CATEGORY_ID=''P_MPP_OUT_BATCH'' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) ' + char(10)
				SELECT @v_dSql += '      WHEN A.PLAN_TYPE = ''WPP'' AND B.CATEGORY_ID=''P_WPP_IN_M'' THEN CEILING(A.ADJUST_IN_QTY_M) ' + char(10)
				SELECT @v_dSql += '      WHEN A.PLAN_TYPE = ''WPP'' AND B.CATEGORY_ID=''P_WPP_IN_JR'' THEN CEILING(A.ADJUST_IN_QTY_JR) ' + char(10)
				SELECT @v_dSql += '      WHEN A.PLAN_TYPE = ''WPP'' AND B.CATEGORY_ID=''P_WPP_IN_CELL'' THEN CEILING(A.ADJUST_IN_QTY_CELL) ' + char(10)
				SELECT @v_dSql += '      WHEN A.PLAN_TYPE = ''WPP'' AND B.CATEGORY_ID=''P_WPP_IN_BATCH'' THEN ROUND(A.ADJUST_IN_QTY_BATCH,2) ' + char(10)
				SELECT @v_dSql += '      WHEN A.PLAN_TYPE = ''WPP'' AND B.CATEGORY_ID=''P_WPP_OUT_M'' THEN CEILING(A.ADJUST_OUT_QTY_M) ' + char(10)
				SELECT @v_dSql += '      WHEN A.PLAN_TYPE = ''WPP'' AND B.CATEGORY_ID=''P_WPP_OUT_JR'' THEN CEILING(A.ADJUST_OUT_QTY_JR) ' + char(10)
				SELECT @v_dSql += '      WHEN A.PLAN_TYPE = ''WPP'' AND B.CATEGORY_ID=''P_WPP_OUT_CELL'' THEN CEILING(A.ADJUST_OUT_QTY_CELL) ' + char(10)
				SELECT @v_dSql += '      WHEN A.PLAN_TYPE = ''WPP'' AND B.CATEGORY_ID=''P_WPP_OUT_BATCH'' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) ' + char(10)
				SELECT @v_dSql += '      WHEN A.PLAN_TYPE = ''RESULT'' AND B.CATEGORY_ID=''P_RESULT_IN_M'' THEN CEILING(A.ADJUST_RESULT_IN_QTY_M) ' + char(10)
				SELECT @v_dSql += '      WHEN A.PLAN_TYPE = ''RESULT'' AND B.CATEGORY_ID=''P_RESULT_IN_JR'' THEN CEILING(A.ADJUST_RESULT_IN_QTY_JR) ' + char(10)
				SELECT @v_dSql += '      WHEN A.PLAN_TYPE = ''RESULT'' AND B.CATEGORY_ID=''P_RESULT_IN_CELL'' THEN CEILING(A.ADJUST_RESULT_IN_QTY_CELL) ' + char(10)
				SELECT @v_dSql += '      WHEN A.PLAN_TYPE = ''RESULT'' AND B.CATEGORY_ID=''P_RESULT_IN_BATCH'' THEN ROUND(A.ADJUST_RESULT_IN_QTY_BATCH,2) ' + char(10)
				SELECT @v_dSql += '      WHEN A.PLAN_TYPE = ''RESULT'' AND B.CATEGORY_ID=''P_RESULT_OUT_M'' THEN CEILING(A.ADJUST_RESULT_OUT_QTY_M) ' + char(10)
				SELECT @v_dSql += '      WHEN A.PLAN_TYPE = ''RESULT'' AND B.CATEGORY_ID=''P_RESULT_OUT_JR'' THEN CEILING(A.ADJUST_RESULT_OUT_QTY_JR) ' + char(10)
				SELECT @v_dSql += '      WHEN A.PLAN_TYPE = ''RESULT'' AND B.CATEGORY_ID=''P_RESULT_OUT_CELL'' THEN CEILING(A.ADJUST_RESULT_OUT_QTY_CELL) ' + char(10)
				SELECT @v_dSql += '      WHEN A.PLAN_TYPE = ''RESULT'' AND B.CATEGORY_ID=''P_RESULT_OUT_BATCH'' THEN ROUND(A.ADJUST_RESULT_OUT_QTY_BATCH,2) ' + char(10)
				SELECT @v_dSql += '      WHEN A.PLAN_TYPE = ''OFFTIME'' AND B.CATEGORY_ID=''P_OFFTIME'' THEN A.OFF_TIME ' + char(10)
				SELECT @v_dSql += '      WHEN B.CATEGORY_ID=''P_SEQ'' THEN A.SEQ ' + char(10)
				SELECT @v_dSql += '      WHEN B.CATEGORY_ID=''P_MEMO'' THEN NULL ' + char(10)
				SELECT @v_dSql += '      ELSE 0 END) ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
			END
		END


		SET @v_delimiter      = '|'  
		SELECT @max_loop_cnt = 0
		SELECT @mst_loop_cnt = 0
		SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) 

		IF @max_loop_cnt > 0 
		BEGIN
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN							
				SELECT @mst_loop_cnt = @mst_loop_cnt +1     
				SELECT @v_week_info   = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)                         
           		SELECT @v_dSql += '  , SUM(CASE WHEN C.' + @WeekColumn + '=' + char(39)  + @v_week_info + char(39) +  'THEN (CASE WHEN A.PLAN_TYPE = ''RELEASE'' AND B.CATEGORY_ID=''P_IN_BATCH'' THEN ROUND(A.TOTAL_BATCH,2) ' + char(10)
				SELECT @v_dSql += '    WHEN A.PLAN_TYPE = ''OFFTIME'' AND B.CATEGORY_ID=''P_OFFTIME'' THEN NULL ' + char(10)
				SELECT @v_dSql += '    WHEN B.CATEGORY_ID=''P_SEQ'' THEN NULL ' + char(10)
				SELECT @v_dSql += '    WHEN B.CATEGORY_ID=''P_MEMO'' THEN NULL ' + char(10)
				SELECT @v_dSql += '    ELSE 0 END) ELSE 0 END) AS T' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + char(10)
            
			END
		END 


		SET @v_delimiter      = '|'  
		SELECT @max_loop_cnt = 0
		SELECT @mst_loop_cnt = 0
		SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) 

		IF @max_loop_cnt > 0 
		BEGIN
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN							
				SELECT @mst_loop_cnt = @mst_loop_cnt +1     
				SELECT @v_day_info   = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_delimiter, @mst_loop_cnt)   
				SELECT @v_dSql += '               , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)=' + char(39) + @v_day_info + char(39) + 'THEN A.BGCOLOR ELSE '''' END ) AS D'  + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)  + '_BG' + char(10)
			END
		END

	END

	SELECT @v_dSql += '           , B.CATEGORY_ID, B.CATEGORY_ORDER ' + char(10)                                                                                                        
	SELECT @v_dSql += '           , ''DATA'' AS DATA_TYPE																' + char(10)
	SELECT @v_dSql += '           , A.CALC_TYPE																			' + char(10)
	--SELECT @v_dSql += '           , A.PROD_SEQ, A.VERSION																' + char(10)
	SELECT @v_dSql += '           , A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PROD_SEQ, A.PLM_EC_NO							' + char(10)
	SELECT @v_dSql += '      FROM (																						' + char(10)
	SELECT @v_dSql += '           SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID				' + char(10)
	SELECT @v_dSql += '               , A.LOCATION, A.OPERATION_ID, D.OPERATION_NAME									' + char(10)
	SELECT @v_dSql += '               , A.LINE_ID, ISNULL(C.LINE_NAME,''-'') AS LINE_NAME, A.ELECTRODE_TYPE				' + char(10)
	SELECT @v_dSql += '               , A.EQUIPMENT_ID																	' + char(10)
	SELECT @v_dSql += '               , A.PLAN_DATE																		' + char(10)
	SELECT @v_dSql += '               , A.TOP_ITEM_ID, A.ITEM_ID, ISNULL(B.NICK_NAME,''-'') AS NICK_NAME				' + char(10)
	SELECT @v_dSql += '               , A.PRODUCTION_TYPE																' + char(10)
	SELECT @v_dSql += '               , A.MARKET																		' + char(10)
	SELECT @v_dSql += '               , A.PLAN_TYPE																		' + char(10)
	SELECT @v_dSql += '               , A.ADJUST_IN_QTY_BATCH, A.ADJUST_IN_QTY, A.ADJUST_IN_QTY_M, A.ADJUST_IN_QTY_CELL, A.ADJUST_IN_QTY_JR							   ' + char(10)
	SELECT @v_dSql += '               , A.ADJUST_OUT_QTY_BATCH, A.ADJUST_OUT_QTY, A.ADJUST_OUT_QTY_M, A.ADJUST_OUT_QTY_CELL, A.ADJUST_OUT_QTY_JR					   ' + char(10)
	SELECT @v_dSql += '               , A.ADJUST_RESULT_IN_QTY_BATCH, A.ADJUST_RESULT_IN_QTY_M, A.ADJUST_RESULT_IN_QTY_CELL, A.ADJUST_RESULT_IN_QTY_JR				   ' + char(10)
	SELECT @v_dSql += '               , A.ADJUST_RESULT_OUT_QTY_BATCH, A.ADJUST_RESULT_OUT_QTY_M, A.ADJUST_RESULT_OUT_QTY_CELL, A.ADJUST_RESULT_OUT_QTY_JR			   ' + char(10)
	SELECT @v_dSql += '               , A.TOTAL_BATCH								   ' + char(10)
	SELECT @v_dSql += '               , A.SEQ										   ' + char(10)
	SELECT @v_dSql += '               , A.OFF_TIME									   ' + char(10)
	SELECT @v_dSql += '               , A.BGCOLOR AS BGCOLOR						   ' + char(10)
	SELECT @v_dSql += '               , C.PROD_VERSION_TYPE							   ' + char(10)
	SELECT @v_dSql += '               , ISNULL(X.CALC_TYPE, dbo.FN_GET_CONV_CALC(' + @v_instance_id + ', A.PLANT_ID, A.FACTORY_ID, A.LINE_ID, '''', A.ITEM_ID, A.PRODUCTION_TYPE, NULL, ''CALC_TYPE'')) AS CALC_TYPE ' + char(10)
	--SELECT @v_dSql += '               , X.PROD_SEQ, X.VERSION ' + char(10)
	SELECT @v_dSql += '               , A.WORK_REQUEST_MODEL_ID, A.VERSION, XX.PROD_SEQ, A.PLM_EC_NO ' + char(10)
	SELECT @v_dSql += '	           FROM ( ' + char(10)
	SELECT @v_dSql += '                    SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
	SELECT @v_dSql += '  		                   , A.LOCATION, A.OPERATION_ID									   ' + char(10)
	SELECT @v_dSql += '  		                   , A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE				   ' + char(10)
	SELECT @v_dSql += '  		                   , A.EQUIPMENT_ID												   ' + char(10)
	SELECT @v_dSql += '  		                   , A.PLAN_DATE												   ' + char(10)
	SELECT @v_dSql += '  		                   , A.ITEM_ID AS TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME		   ' + char(10)
	SELECT @v_dSql += '  		                   , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE					   ' + char(10)
	SELECT @v_dSql += '  		                   , A.MARKET													   ' + char(10)
	SELECT @v_dSql += '  		                   , A.PLAN_TYPE												   ' + char(10)
	SELECT @v_dSql += '  		                   , A.BATCH_IN_QTY AS ADJUST_IN_QTY_BATCH, A.PLAN_IN_QTY AS ADJUST_IN_QTY, A.ROLL_IN_QTY AS ADJUST_IN_QTY_M, A.CELL_IN_QTY AS ADJUST_IN_QTY_CELL, A.JR_IN_QTY AS ADJUST_IN_QTY_JR ' + char(10)
	SELECT @v_dSql += '                 	   , A.BATCH_OUT_QTY AS ADJUST_OUT_QTY_BATCH, A.PLAN_QTY AS ADJUST_OUT_QTY, A.ROLL_OUT_QTY AS ADJUST_OUT_QTY_M, A.CELL_OUT_QTY AS ADJUST_OUT_QTY_CELL, A.JR_OUT_QTY AS ADJUST_OUT_QTY_JR ' + char(10)
	SELECT @v_dSql += '                 	   , 0 AS ADJUST_RESULT_IN_QTY_BATCH,  0 AS ADJUST_RESULT_IN_QTY_M, 0 AS ADJUST_RESULT_IN_QTY_CELL, 0 AS ADJUST_RESULT_IN_QTY_JR ' + char(10)
	SELECT @v_dSql += '                 	   , 0 AS ADJUST_RESULT_OUT_QTY_BATCH, 0 AS ADJUST_RESULT_OUT_QTY_M, 0 AS ADJUST_RESULT_OUT_QTY_CELL, 0 AS ADJUST_RESULT_OUT_QTY_JR ' + char(10)
	SELECT @v_dSql += '                 	   , A.TOTAL_BATCH ' + char(10)
	SELECT @v_dSql += '                 	   , SEQ ' + char(10)
	SELECT @v_dSql += '                 	   , 0 AS OFF_TIME ' + char(10)
	SELECT @v_dSql += '                 	   , B.SETUP_COLOR AS BGCOLOR ' + char(10)
	SELECT @v_dSql += '                 	   , A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PROD_SEQ, A.PLM_EC_NO ' + char(10)
	SELECT @v_dSql += '                    FROM #TblFP00614_FIND_FP00614 A WITH(NOLOCK) ' + char(10)
	SELECT @v_dSql += '                    LEFT OUTER JOIN ( ' + char(10)
	SELECT @v_dSql += '				              	SELECT A.SEGMENT1 AS INSTANCE_ID, A.SEGMENT2 AS SETUP_COLOR_CODE, A.SEGMENT3 AS SETUP_COLOR_NAME, A.SEGMENT4 AS SETUP_COLOR, A.SORT_ORDER ' + char(10)
	SELECT @v_dSql += '										FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)  		  ' + char(10)
	SELECT @v_dSql += '										WHERE  A.LOOKUP_TYPE_CODE = ''UI_AMEND_COLOR''		  ' + char(10)
	SELECT @v_dSql += '										AND    A.SEGMENT1 = ' + @v_instance_id + char(10)
	SELECT @v_dSql += '										AND    A.ACTIVE_FLAG = ''Y''						  ' + char(10)
	SELECT @v_dSql += '			            ) B																	  ' + char(10)
	SELECT @v_dSql += '			            ON A.SETUP_COLOR_CODE = B.SETUP_COLOR_CODE							  ' + char(10)
	SELECT @v_dSql += '			            WHERE  1=1															  ' + char(10)
	SELECT @v_dSql += '	              	AND 	A.PLAN_TYPE IN ( ''RELEASE'', ''MPP'', ''WPP'' )				  ' + char(10)
	SELECT @v_dSql += '                	AND    A.PLAN_DATE BETWEEN CONVERT(DATE, ' +  @v_bucket_from + ') AND CONVERT(DATE, ' +  @v_bucket_to + ') ' + char(10)
	--22.04.01 수정(ksi)

	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.DIVISION_ID' , 'EQ', @p_division_id))        + char(10)
	IF(LEN(@p_site_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.SITE_ID' , 'EQ', @p_site_id))        + char(10)
	END
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.PLANT_ID' , 'EQ', @p_plant_id))              + char(10)

	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.FACTORY_ID' , 'EQ', @p_factory_id))          + char(10) 

	IF(LEN(@p_operation_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.OPERATION_ID' , 'EQ', @p_operation_id))      + char(10)
	END


	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.LINE_ID' , 'EQ', @p_line_id))                + char(10)
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type))   + char(10)

	IF(LEN(@p_top_item_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.TOP_ITEM_ID' , 'LK', @p_top_item_id))                + char(10)
	END

	IF(LEN(@p_item_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.ITEM_ID' , 'LK', @p_item_id))                + char(10)
	END

	--IF(LEN(@p_prod_type) > 0)
	--BEGIN
	--	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.FP_PRODUCTION_TYPE' , 'LK', @p_prod_type))                + char(10)
	--END

	SELECT @v_dSql += '    AND 	( ISNULL(A.TOTAL_BATCH,0) + ISNULL(A.BATCH_IN_QTY,0) + ISNULL(A.PLAN_IN_QTY,0) + ISNULL(A.ROLL_IN_QTY,0) + ISNULL(A.CELL_IN_QTY,0) + ISNULL(A.JR_IN_QTY,0) + ISNULL(A.BATCH_OUT_QTY,0) + ISNULL(A.PLAN_QTY,0) + ISNULL(A.ROLL_OUT_QTY,0) + ISNULL(A.CELL_OUT_QTY,0) + ISNULL(A.JR_OUT_QTY,0) ) > 0 '   + char(10)
	SELECT @v_dSql += '              UNION ALL  ' + char(10)
	SELECT @v_dSql += '    SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + char(10)
	SELECT @v_dSql += '               , A.LOCATION, A.OPERATION_ID' + char(10)
	SELECT @v_dSql += '               , A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE' + char(10)
	SELECT @v_dSql += '               , A.EQUIPMENT_ID' + char(10)
	SELECT @v_dSql += '               , A.PLAN_DATE' + char(10)
	SELECT @v_dSql += '               , A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME' + char(10)
	SELECT @v_dSql += '               , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE' + char(10)
	SELECT @v_dSql += '               , A.MARKET' + char(10)
	SELECT @v_dSql += '               , ''RESULT'' AS PLAN_TYPE' + char(10)
	SELECT @v_dSql += '               , 0 AS ADJUST_IN_QTY_BATCH, 0 AS ADJUST_IN_QTY, 0 AS ADJUST_IN_QTY_M, 0 AS ADJUST_IN_QTY_CELL, 0 AS ADJUST_IN_QTY_JR' + char(10)
	SELECT @v_dSql += '               , 0 AS ADJUST_OUT_QTY_BATCH, 0 AS ADJUST_OUT_QTY, 0 AS ADJUST_OUT_QTY_M, 0 AS ADJUST_OUT_QTY_CELL, 0 AS ADJUST_OUT_QTY_JR' + char(10)
	SELECT @v_dSql += '               , A.BATCH_IN_QTY AS ADJUST_RESULT_IN_QTY_BATCH, A.ROLL_IN_QTY AS ADJUST_RESULT_IN_QTY_M, A.CELL_IN_QTY AS ADJUST_RESULT_IN_QTY_CELL, A.JR_IN_QTY AS ADJUST_RESULT_IN_QTY_JR ' + char(10)
	SELECT @v_dSql += '               , A.BATCH_OUT_QTY AS ADJUST_RESULT_OUT_QTY_BATCH, A.ROLL_OUT_QTY AS ADJUST_RESULT_OUT_QTY_M, A.CELL_OUT_QTY AS ADJUST_RESULT_OUT_QTY_CELL, A.JR_OUT_QTY AS ADJUST_RESULT_OUT_QTY_JR ' + char(10)
	SELECT @v_dSql += '               , 0 AS TOTAL_BATCH ' + char(10)
	SELECT @v_dSql += '               , null AS SEQ' + char(10)
	SELECT @v_dSql += '               , 0 AS OFF_TIME' + char(10)
	SELECT @v_dSql += '               , null AS BGCOLOR' + char(10)
	SELECT @v_dSql += '               , A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PROD_SEQ, A.PLM_EC_NO' + char(10)
	SELECT @v_dSql += '      FROM SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK)' + char(10)
	SELECT @v_dSql += '      WHERE  1=1' + char(10)
	SELECT @v_dSql += '      AND    A.PLAN_DATE BETWEEN CONVERT(DATE, ' +  @v_bucket_from + ') AND CONVERT(DATE, ' +  @v_bucket_to + ') ' + char(10)
	
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.DIVISION_ID' , 'EQ', @p_division_id))        + char(10)
	IF(LEN(@p_site_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.SITE_ID' , 'EQ', @p_site_id))        + char(10)
	END
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.PLANT_ID' , 'EQ', @p_plant_id))              + char(10)

	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.FACTORY_ID' , 'EQ', @p_factory_id))          + char(10) 

	IF(LEN(@p_operation_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.OPERATION_ID' , 'EQ', @p_operation_id))      + char(10)
	END


	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.LINE_ID' , 'EQ', @p_line_id))                + char(10)
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type))   + char(10)

	IF(LEN(@p_top_item_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.TOP_ITEM_ID' , 'LK', @p_top_item_id))                + char(10)
	END

	IF(LEN(@p_item_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.ITEM_ID' , 'LK', @p_item_id))                + char(10)
	END

	--IF(LEN(@p_prod_type) > 0)
	--BEGIN
	--	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.FP_PRODUCTION_TYPE' , 'LK', @p_prod_type))                + char(10)
	--END

	SELECT @v_dSql += '  AND	A.BATCH_IN_QTY > 0 ' + char(10)                                                                                             
	SELECT @v_dSql += '      	UNION ALL ' + char(10)
	SELECT @v_dSql += '  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
	SELECT @v_dSql += '       , A.LOCATION, A.OPERATION_ID ' + char(10)
	SELECT @v_dSql += '       , A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
	SELECT @v_dSql += '       , A.EQUIPMENT_ID ' + char(10)
	SELECT @v_dSql += '       , B.OFF_DATE AS PLAN_DATE ' + char(10)
	SELECT @v_dSql += '       , A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME ' + char(10)
	SELECT @v_dSql += '       , A.PRODUCTION_TYPE ' + char(10)
	SELECT @v_dSql += '       , A.MARKET ' + char(10)
	SELECT @v_dSql += '       , ''OFFTIME'' AS PLAN_TYPE ' + char(10)
	SELECT @v_dSql += '       , 0 AS ADJUST_IN_QTY_BATCH, 0 AS ADJUST_IN_QTY, 0 AS ADJUST_IN_QTY_M, 0 AS ADJUST_IN_QTY_CELL, 0 AS ADJUST_IN_QTY_JR ' + char(10)
	SELECT @v_dSql += '   		   , 0 AS ADJUST_OUT_QTY_BATCH, 0 AS ADJUST_OUT_QTY, 0 AS ADJUST_OUT_QTY_M, 0 AS ADJUST_OUT_QTY_CELL, 0 AS ADJUST_OUT_QTY_JR ' + char(10)
	SELECT @v_dSql += '       , 0 AS ADJUST_RESULT_IN_QTY_BATCH, 0 AS ADJUST_RESULT_IN_QTY_M, 0 AS ADJUST_RESULT_IN_QTY_CELL, 0 AS ADJUST_RESULT_IN_QTY_JR  ' + char(10)
	SELECT @v_dSql += '       , 0 AS ADJUST_RESULT_OUT_QTY_BATCH, 0 AS ADJUST_RESULT_OUT_QTY_M, 0 AS ADJUST_RESULT_OUT_QTY_CELL, 0 AS ADJUST_RESULT_OUT_QTY_JR ' + char(10)
	SELECT @v_dSql += '       , 0 AS TOTAL_BATCH  ' + char(10)
	SELECT @v_dSql += '       , '''' SEQ ' + char(10)
	SELECT @v_dSql += '       , B.OFF_TIME AS OFF_TIME ' + char(10)
	SELECT @v_dSql += '       , null AS BGCOLOR ' + char(10)
	SELECT @v_dSql += '       , A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PROD_SEQ, A.PLM_EC_NO ' + char(10)
	SELECT @v_dSql += '  FROM (' + char(10)
	SELECT @v_dSql += '            SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID, A.TOP_ITEM_ID, A.ITEM_ID, A.PRODUCTION_TYPE, A.MARKET' + char(10)
	SELECT @v_dSql += '                 , A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PROD_SEQ, A.PLM_EC_NO ' + char(10)
	SELECT @v_dSql += '            FROM (' + char(10)
	SELECT @v_dSql += '                              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID, A.ITEM_ID AS TOP_ITEM_ID, A.ITEM_ID' + char(10)
	SELECT @v_dSql += '                              		, A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE, A.MARKET' + char(10)
	SELECT @v_dSql += '                              		, A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PROD_SEQ, A.PLM_EC_NO' + char(10)
	SELECT @v_dSql += '                              FROM #TblFP00614_FIND_FP00614 A WITH(NOLOCK)' + char(10)
	SELECT @v_dSql += '                              WHERE  1=1' + char(10)
	--SELECT @v_dSql += '		                      AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN ' +  @v_bucket_from + ' AND ' +  @v_bucket_to + char(10)
	--22.04.01 ksi
	SELECT @v_dSql += '		                      AND    A.PLAN_TYPE IN ( ''RELEASE'', ''WPP'', ''MPP'' )' + char(10)

	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.DIVISION_ID' , 'EQ', @p_division_id))        + char(10)
	IF(LEN(@p_site_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.SITE_ID' , 'EQ', @p_site_id))        + char(10)
	END
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.PLANT_ID' , 'EQ', @p_plant_id))              + char(10)

	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.FACTORY_ID' , 'EQ', @p_factory_id))          + char(10) 

	IF(LEN(@p_operation_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.OPERATION_ID' , 'EQ', @p_operation_id))      + char(10)
	END


	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.LINE_ID' , 'EQ', @p_line_id))                + char(10)
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type))   + char(10)

	IF(LEN(@p_top_item_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.TOP_ITEM_ID' , 'LK', @p_top_item_id))                + char(10)
	END

	IF(LEN(@p_item_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.ITEM_ID' , 'LK', @p_item_id))                + char(10)
	END

	--IF(LEN(@p_prod_type) > 0)
	--BEGIN
	--	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.FP_PRODUCTION_TYPE' , 'LK', @p_prod_type))                + char(10)
	--END

	SELECT @v_dSql += '	 AND 	(ISNULL(A.BATCH_IN_QTY,0) + ISNULL(A.PLAN_IN_QTY,0) + ISNULL(A.ROLL_IN_QTY,0) + ISNULL(A.CELL_IN_QTY,0) + ISNULL(A.JR_IN_QTY,0) + ISNULL(A.BATCH_OUT_QTY,0) + ISNULL(A.PLAN_QTY,0) + ISNULL(A.ROLL_OUT_QTY,0) + ISNULL(A.CELL_OUT_QTY,0) + ISNULL(A.JR_OUT_QTY,0)) > 0 ' + char(10)
	SELECT @v_dSql += '	 UNION ALL ' + char(10)
	SELECT @v_dSql += '	 SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID, A.TOP_ITEM_ID, A.ITEM_ID ' + char(10)
	SELECT @v_dSql += '	 		, A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE, A.MARKET ' + char(10)
	SELECT @v_dSql += '	 		, A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PROD_SEQ, A.PLM_EC_NO ' + char(10)
	SELECT @v_dSql += '	 FROM SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK) ' + char(10)
	SELECT @v_dSql += '	 WHERE  1=1 ' + char(10)
	SELECT @v_dSql += '  AND    A.PLAN_DATE BETWEEN CONVERT(DATE, ' +  @v_bucket_from + ') AND CONVERT(DATE, ' +  @v_bucket_to + ') ' + char(10)
	
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.DIVISION_ID' , 'EQ', @p_division_id))        + char(10)
	IF(LEN(@p_site_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.SITE_ID' , 'EQ', @p_site_id))        + char(10)
	END
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.PLANT_ID' , 'EQ', @p_plant_id))              + char(10)

	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.FACTORY_ID' , 'EQ', @p_factory_id))          + char(10) 

	IF(LEN(@p_operation_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.OPERATION_ID' , 'EQ', @p_operation_id))      + char(10)
	END


	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.LINE_ID' , 'EQ', @p_line_id))                + char(10)
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type))   + char(10)

	IF(LEN(@p_top_item_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.TOP_ITEM_ID' , 'LK', @p_top_item_id))                + char(10)
	END

	IF(LEN(@p_item_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.ITEM_ID' , 'LK', @p_item_id))                + char(10)
	END

	--IF(LEN(@p_prod_type) > 0)
	--BEGIN
	--	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.FP_PRODUCTION_TYPE' , 'LK', @p_prod_type))                + char(10)
	--END

	SELECT @v_dSql += '    AND    ISNULL(A.BATCH_OUT_QTY,0) > 0 '  + char(10)
	SELECT @v_dSql += '		        ) A '  + char(10)
	SELECT @v_dSql += '			      WHERE 1=1 '  + char(10)
	SELECT @v_dSql += '			      GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID, A.TOP_ITEM_ID, A.ITEM_ID, A.PRODUCTION_TYPE, A.MARKET '  + char(10)
	SELECT @v_dSql += '			             , A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PROD_SEQ, A.PLM_EC_NO '  + char(10)
	SELECT @v_dSql += '    ) A '  + char(10)
	SELECT @v_dSql += '    LEFT OUTER JOIN  '  + char(10)
	SELECT @v_dSql += '    ( '  + char(10)
	SELECT @v_dSql += '                      SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, T.EQUIPMENT_ID '  + char(10)
	SELECT @v_dSql += '                            , CONVERT(VARCHAR, A.OFF_DATE, 112) AS OFF_DATE, A.OFF_TIME_TERM AS OFF_TIME '  + char(10)
	SELECT @v_dSql += '                      FROM   SCM_OFF_CALENDAR_LINE_V A WITH(NOLOCK) '  + char(10)
	SELECT @v_dSql += '                      INNER JOIN SCM_LINE_M B WITH(NOLOCK) '  + char(10)
	SELECT @v_dSql += '                      ON     A.COMPANY_ID     = B.COMPANY_ID '  + char(10)
	SELECT @v_dSql += '                      AND    A.DIVISION_ID    = B.DIVISION_ID '  + char(10)
	SELECT @v_dSql += '                      AND    A.SITE_ID        = B.SITE_ID '  + char(10)
	SELECT @v_dSql += '                      AND    A.PLANT_ID       = B.PLANT_ID '  + char(10)
	SELECT @v_dSql += '                      AND    A.FACTORY_ID     = B.FACTORY_ID '  + char(10)
	SELECT @v_dSql += '                      AND    A.OPERATION_ID   = B.OPERATION_ID '  + char(10)
	SELECT @v_dSql += '                      AND    A.LINE_ID        = B.LINE_ID '  + char(10)
	SELECT @v_dSql += '                      AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE '  + char(10)
	SELECT @v_dSql += '                      LEFT OUTER JOIN SCM_EQUIPMENT_M T WITH(NOLOCK) '  + char(10)
	SELECT @v_dSql += '                      ON    T.COMPANY_ID     = B.COMPANY_ID '  + char(10)
	SELECT @v_dSql += '                      AND   T.DIVISION_ID    = B.DIVISION_ID '  + char(10)
	SELECT @v_dSql += '                      AND   T.SITE_ID        = B.SITE_ID '  + char(10)
	SELECT @v_dSql += '                      AND   T.PLANT_ID       = B.PLANT_ID '  + char(10)
	SELECT @v_dSql += '                      AND   T.FACTORY_ID     = B.FACTORY_ID '  + char(10)
	SELECT @v_dSql += '                      AND   T.OPERATION_ID   = B.OPERATION_ID '  + char(10)
	SELECT @v_dSql += '                      AND   T.LINE_ID        = B.LINE_ID '  + char(10)
	SELECT @v_dSql += '                      AND   T.ELECTRODE_TYPE = B.ELECTRODE_TYPE '  + char(10)
	SELECT @v_dSql += '                      AND   T.ACTIVE_FLAG    = ''Y'' '  + char(10)
	SELECT @v_dSql += '          	         AND   T.EQUIPMENT_TYPE = ''M'' '  + char(10)
	SELECT @v_dSql += '                      WHERE  B.ACTIVE_FLAG    = ''Y'' '  + char(10)
	SELECT @v_dSql += '                		 AND    A.OFF_DATE BETWEEN CONVERT(DATE, ' +  @v_bucket_from + ') AND CONVERT(DATE, ' +  @v_bucket_to + ') ' + char(10)
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.DIVISION_ID' , 'EQ', @p_division_id))        + char(10)
	IF(LEN(@p_site_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.SITE_ID' , 'EQ', @p_site_id))        + char(10)
	END
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.PLANT_ID' , 'EQ', @p_plant_id))              + char(10)

	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.FACTORY_ID' , 'EQ', @p_factory_id))          + char(10) 

	IF(LEN(@p_operation_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.OPERATION_ID' , 'EQ', @p_operation_id))      + char(10)
	END
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.LINE_ID' , 'EQ', @p_line_id))                + char(10)

	SELECT @v_dSql += '     ) B ' + char(10)
	SELECT @v_dSql += '       ON    A.COMPANY_ID     = B.COMPANY_ID' + char(10)
	SELECT @v_dSql += '       AND   A.DIVISION_ID    = B.DIVISION_ID' + char(10)
	SELECT @v_dSql += '       AND   A.SITE_ID        = B.SITE_ID' + char(10)
	SELECT @v_dSql += '       AND   A.PLANT_ID       = B.PLANT_ID' + char(10)
	SELECT @v_dSql += '       AND   A.FACTORY_ID     = B.FACTORY_ID' + char(10)
	SELECT @v_dSql += '       AND   A.OPERATION_ID   = B.OPERATION_ID' + char(10)
	SELECT @v_dSql += '       AND   A.LINE_ID        = B.LINE_ID' + char(10)
	SELECT @v_dSql += '       AND   A.ELECTRODE_TYPE = B.ELECTRODE_TYPE' + char(10)
	SELECT @v_dSql += '       AND   A.EQUIPMENT_ID   = B.EQUIPMENT_ID' + char(10)

	-- 메모정보는 있으되, 계획,실적은 없는 item-line 을 찾는다.
	SELECT @v_dSql += '  UNION ALL ' + char(10)
	SELECT @v_dSql += '  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
	SELECT @v_dSql += '  	 , ''-'' AS LOCATION ' + char(10)
	SELECT @v_dSql += '  	 , A.OPERATION_ID, A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE, A.EQUIPMENT_ID ' + char(10)
	SELECT @v_dSql += '  	 , A.PLAN_DATE, A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME ' + char(10)
	SELECT @v_dSql += '  	 , A.PRODUCTION_TYPE, A.MARKET, '''' AS PLAN_TYPE ' + char(10)
	SELECT @v_dSql += '  	 , 0 AS ADJUST_IN_QTY_BATCH, 0 AS ADJUST_IN_QTY, 0 AS ADJUST_IN_QTY_M, 0 AS ADJUST_IN_QTY_CELL, 0 AS ADJUST_IN_QTY_JR ' + char(10)
	SELECT @v_dSql += '  	 , 0 AS ADJUST_OUT_QTY_BATCH, 0 AS ADJUST_OUT_QTY, 0 AS ADJUST_OUT_QTY_M, 0 AS ADJUST_OUT_QTY_CELL, 0 AS ADJUST_OUT_QTY_JR ' + char(10)
	SELECT @v_dSql += '  	 , 0 AS ADJUST_RESULT_IN_QTY_BATCH, 0 AS ADJUST_RESULT_IN_QTY_M, 0 AS ADJUST_RESULT_IN_QTY_CELL, 0 AS ADJUST_RESULT_IN_QTY_JR ' + char(10)
	SELECT @v_dSql += '  	 , 0 AS ADJUST_RESULT_OUT_QTY_BATCH, 0 AS ADJUST_RESULT_OUT_QTY_M, 0 AS ADJUST_RESULT_OUT_QTY_CELL, 0 AS ADJUST_RESULT_OUT_QTY_JR ' + char(10)
	SELECT @v_dSql += '  	 , NULL AS TOTAL_BATCH, NULL AS SEQ, 0 AS OFF_TIME, NULL AS BGCOLOR ' + char(10)
	SELECT @v_dSql += '  	 , ''-'' AS WORK_REQUEST_MODEL_ID ' + char(10)
	SELECT @v_dSql += '  	 , ''-'' AS VERSION ' + char(10)
	SELECT @v_dSql += '  	 , ''-'' AS PROD_SEQ ' + char(10)
	SELECT @v_dSql += '  	 , ''-'' AS PLM_EC_NO ' + char(10)
	SELECT @v_dSql += '  FROM   FP_AMEND_MEMO_M A WITH(NOLOCK) ' + char(10)
	SELECT @v_dSql += '  WHERE  1=1 ' + char(10)
	SELECT @v_dSql += '  AND    A.ITEM_ID <> ''-''  ' + char(10) -- item 메모
	SELECT @v_dSql += '  AND    A.PLAN_DATE BETWEEN CONVERT(DATE, ' + @v_bucket_from + ') AND CONVERT(DATE, ' + @v_bucket_to + ')  ' + char(10)
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('  A.DIVISION_ID' , 'EQ', @p_division_id))
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('  A.SITE_ID' , 'EQ', @p_site_id))
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('  A.PLANT_ID' , 'EQ', @p_plant_id))
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('  A.FACTORY_ID' , 'EQ', @p_factory_id))
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('  A.OPERATION_ID' , 'EQ', @p_operation_id))
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('  A.LINE_ID' , 'EQ', @p_line_id))
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('  A.PRODUCTION_TYPE' , 'EQ', @p_prod_type))
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('  A.ITEM_ID' , 'LK', @p_item_id)) + char(10)
	SELECT @v_dSql += '  AND NOT EXISTS ( ' + char(10)
	SELECT @v_dSql += '  	SELECT 1 ' + char(10)
	SELECT @v_dSql += '  	FROM   #ITEM_MEMO_TEMP B WITH(NOLOCK) ' + char(10)
	SELECT @v_dSql += '  	WHERE 1=1 ' + char(10)
	SELECT @v_dSql += '  	AND   A.COMPANY_ID      = B.COMPANY_ID ' + char(10)
	SELECT @v_dSql += '  	AND   A.DIVISION_ID     = B.DIVISION_ID ' + char(10)
	SELECT @v_dSql += '  	AND   A.SITE_ID         = B.SITE_ID ' + char(10)
	SELECT @v_dSql += '  	AND   A.PLANT_ID        = B.PLANT_ID ' + char(10)
	SELECT @v_dSql += '  	AND   A.FACTORY_ID      = B.FACTORY_ID ' + char(10)
	SELECT @v_dSql += '  	AND   A.OPERATION_ID    = B.OPERATION_ID ' + char(10)
	SELECT @v_dSql += '  	AND   A.LINE_ID         = B.LINE_ID ' + char(10)
	SELECT @v_dSql += '  	AND   A.ELECTRODE_TYPE  = B.ELECTRODE_TYPE ' + char(10)
	SELECT @v_dSql += '  	AND   A.EQUIPMENT_ID    = B.EQUIPMENT_ID ' + char(10)
	SELECT @v_dSql += '  	AND   A.ITEM_ID         = B.ITEM_ID ' + char(10)
	SELECT @v_dSql += '  	AND   A.PRODUCTION_TYPE = B.PRODUCTION_TYPE ' + char(10)
	SELECT @v_dSql += '  	AND   A.MARKET          = B.MARKET ' + char(10)
	SELECT @v_dSql += '  ) ' + char(10)
	SELECT @v_dSql += ' 	      ) A' + char(10)
	SELECT @v_dSql += ' 	      INNER JOIN SCM_ITEM_M B WITH(NOLOCK)' + char(10)
	SELECT @v_dSql += '       ON     A.COMPANY_ID     = B.COMPANY_ID' + char(10)
	SELECT @v_dSql += '       AND    A.DIVISION_ID    = B.DIVISION_ID' + char(10)
	SELECT @v_dSql += '       AND    A.SITE_ID        = B.SITE_ID' + char(10)
	SELECT @v_dSql += '       AND    A.TOP_ITEM_ID    = B.ITEM_ID' + char(10)


	IF(LEN(@p_nick_name) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('               ISNULL(B.NICK_NAME,''-'')' , 'LK', @p_nick_name))        + char(10)
	END
	IF(LEN(@p_nick_name_lt) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('       ISNULL(B.NICK_NAME,''-'')' , 'LK', @p_nick_name_lt))        + char(10)
	END


	SELECT @v_dSql += '    INNER JOIN SCM_LINE_M C WITH(NOLOCK)'+char(10)
	SELECT @v_dSql += '          ON     A.COMPANY_ID     = C.COMPANY_ID'+char(10)
	SELECT @v_dSql += '          AND    A.DIVISION_ID    = C.DIVISION_ID'+char(10)
	SELECT @v_dSql += '          AND    A.SITE_ID        = C.SITE_ID'+char(10)
	SELECT @v_dSql += '          AND    A.PLANT_ID       = C.PLANT_ID'+char(10)
	SELECT @v_dSql += '          AND    A.FACTORY_ID     = C.FACTORY_ID'+char(10)
	SELECT @v_dSql += '          AND    A.OPERATION_ID   = C.OPERATION_ID'+char(10)
	SELECT @v_dSql += '          AND    A.LINE_ID        = C.LINE_ID'+char(10)
	SELECT @v_dSql += '          AND    A.ELECTRODE_TYPE = C.ELECTRODE_TYPE'+char(10)
	SELECT @v_dSql += '          INNER JOIN SCM_OPERATION_M D WITH(NOLOCK)'+char(10)
	SELECT @v_dSql += '    ON     A.COMPANY_ID     = D.COMPANY_ID'+char(10)
	SELECT @v_dSql += '          AND    A.DIVISION_ID    = D.DIVISION_ID'+char(10)
	SELECT @v_dSql += '          AND    A.SITE_ID        = D.SITE_ID'+char(10)
	SELECT @v_dSql += '          AND    A.OPERATION_ID   = D.OPERATION_ID'+char(10)
	SELECT @v_dSql += '					LEFT OUTER HASH JOIN ('+char(10)
	SELECT @v_dSql += '							SELECT B.*'+char(10)
	SELECT @v_dSql += '								 , MIN(B.IDX) OVER (PARTITION BY B.INSTANCE_ID, B.PRODUCTION_TYPE, A.LINE_ID, A.ITEM_ID ) AS MIN_IDX'+char(10)
	SELECT @v_dSql += '								 , A.*'+char(10)
	SELECT @v_dSql += '							FROM ('+char(10)
	SELECT @v_dSql += '									SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID AS CALC_PLANT_ID, A.FACTORY_ID, B.LINE_ID, A.ITEM_ID, B.ELECTRODE_TYPE, A.VERSION_TYPE AS CALC_TYPE, A.VERSION '+char(10)
	SELECT @v_dSql += '											-- , A.PROD_SEQ  -- 중복 데이타가 생성되어 제외함 20230502 by cys	'+char(10)
	SELECT @v_dSql += '										 , DENSE_RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION, A.ITEM_ID, A.PROD_VERSION_TYPE, A.VERSION_TYPE '+char(10)
	SELECT @v_dSql += '															  ORDER BY A.APPLY_DATE DESC, (CASE WHEN A.VERSION LIKE ''Z%'' THEN REPLACE( A.VERSION, ''Z'', ''/'') ELSE A.VERSION END) DESC '+char(10)
	SELECT @v_dSql += '															         , (CASE WHEN A.MODEL_ID = C.APPLIED_MODEL THEN 1 ELSE 2 END) ) AS SEQ  '+char(10)
	SELECT @v_dSql += '									FROM   SCM_ITEM_CONV_CALC_M A WITH(NOLOCK), SCM_LINE_M B WITH(NOLOCK), SCM_ITEM_M C WITH(NOLOCK) '+char(10)
	SELECT @v_dSql += '									WHERE  1=1 '+char(10)
	SELECT @v_dSql += '									AND    A.OPERATION    = ''E2000'' '+char(10)
	SELECT @v_dSql += '									AND    A.MAX_VER_FLAG = ''Y'' '+char(10)
	SELECT @v_dSql += '									AND    A.COMPANY_ID   = B.COMPANY_ID '+char(10)
	SELECT @v_dSql += '									AND    A.DIVISION_ID  = B.DIVISION_ID '+char(10)
	SELECT @v_dSql += '									AND    A.SITE_ID      = B.SITE_ID '+char(10)
	SELECT @v_dSql += '									AND    A.PLANT_ID     = B.PLANT_ID '+char(10)
	SELECT @v_dSql += '									AND    A.FACTORY_ID   = B.FACTORY_ID '+char(10)
	SELECT @v_dSql += '									AND    A.OPERATION    = B.OPERATION_ID '+char(10)
	SELECT @v_dSql += '									AND    A.PROD_VERSION_TYPE = ISNULL(B.PROD_VERSION_TYPE, ''GENERAL'') '+char(10)
	SELECT @v_dSql += '          	AND    A.COMPANY_ID   = C.COMPANY_ID '+char(10)
	SELECT @v_dSql += '          	AND    A.DIVISION_ID  = C.DIVISION_ID '+char(10)
	SELECT @v_dSql += '          	AND    A.SITE_ID      = C.SITE_ID '+char(10)
	SELECT @v_dSql += '          	AND    A.ITEM_ID      = C.ITEM_ID '+char(10)
	SELECT @v_dSql += '									AND    B.ACTIVE_FLAG = ''Y'' '+char(10)

	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.FACTORY_ID' , 'EQ', @p_factory_id))          + char(10) 

	SELECT @v_dSql += '	    ) A                                                                                                                                  ' + char(10)
	SELECT @v_dSql += '				, (' + char(10)
	SELECT @v_dSql += '						SELECT SEGMENT1 AS INSTANCE_ID, SEGMENT2 AS PLANT_ID, SEGMENT3 AS PRODUCTION_TYPE,  VERSION_TYPE' + char(10)
	SELECT @v_dSql += '							 , RANK() OVER (PARTITION BY SEGMENT1, SEGMENT3 ORDER BY GUBUN) AS IDX' + char(10)
	SELECT @v_dSql += '						FROM (' + char(10)
	SELECT @v_dSql += '								SELECT *' + char(10)
	SELECT @v_dSql += '								FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)' + char(10)
	SELECT @v_dSql += '								WHERE  1=1' + char(10)
	SELECT @v_dSql += '								AND	   LOOKUP_TYPE_CODE	= ''INSTANCE_CONV_PRIORITY'' ' + char(10)
	SELECT @v_dSql += '								AND	   SEGMENT1         = ' + @v_instance_id + char(10)
	SELECT @v_dSql += '								AND    ACTIVE_FLAG      = ''Y'' ' + char(10)
	SELECT @v_dSql += '						) A' + char(10)
	SELECT @v_dSql += '						UNPIVOT(VERSION_TYPE FOR GUBUN IN (ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5) ) AS VERSION_TYPE' + char(10)
	SELECT @v_dSql += '				) B' + char(10)
	SELECT @v_dSql += '				WHERE 1=1' + char(10)
	SELECT @v_dSql += '				AND   A.CALC_PLANT_ID	= B.PLANT_ID' + char(10)
	SELECT @v_dSql += '				AND   A.CALC_TYPE		= B.VERSION_TYPE' + char(10)
	SELECT @v_dSql += '				AND   A.SEQ = 1' + char(10)
	SELECT @v_dSql += '		) X' + char(10)
	SELECT @v_dSql += '		ON    1=1' + char(10)
	SELECT @v_dSql += '		AND   X.MIN_IDX         = X.IDX' + char(10)
	SELECT @v_dSql += '		AND   A.SITE_ID         = X.SITE_ID' + char(10)
	SELECT @v_dSql += '		AND   A.PLANT_ID        = X.PLANT_ID' + char(10)
	SELECT @v_dSql += '		AND   A.FACTORY_ID      = X.FACTORY_ID' + char(10)
	SELECT @v_dSql += '		AND   A.LINE_ID         = X.LINE_ID' + char(10)
	SELECT @v_dSql += '		AND   A.ITEM_ID         = X.ITEM_ID' + char(10)
	SELECT @v_dSql += '		AND   A.ELECTRODE_TYPE  = X.ELECTRODE_TYPE' + char(10)
	SELECT @v_dSql += '		AND   A.PRODUCTION_TYPE = X.PRODUCTION_TYPE' + char(10)
	-- seq 대체
	SELECT @v_dSql += '		LEFT OUTER JOIN SCM_ITEM_CONV_CALC_M XX WITH(NOLOCK) ' + char(10)
	SELECT @v_dSql += '		ON  A.COMPANY_ID            = XX.COMPANY_ID ' + char(10)
	SELECT @v_dSql += '		AND A.FACTORY_ID            = XX.FACTORY_ID ' + char(10)
	SELECT @v_dSql += '		AND A.WORK_REQUEST_MODEL_ID = XX.MODEL_ID ' + char(10)
	SELECT @v_dSql += '		AND A.VERSION               = XX.VERSION ' + char(10)
	SELECT @v_dSql += '		AND A.OPERATION_ID          = XX.OPERATION ' + char(10)
	SELECT @v_dSql += '		AND A.ITEM_ID               = XX.ITEM_ID ' + char(10)
	SELECT @v_dSql += '		AND XX.CATEGORY             = ''Lane Number'' ' + char(10)
	SELECT @v_dSql += '     WHERE 1=1' + char(10)

	SELECT @v_dSql += '     ) A ' + char(10)
	SELECT @v_dSql += '		          INNER JOIN ( ' + char(10)
	SELECT @v_dSql += '		              SELECT * '  + char(10)
	SELECT @v_dSql += '		              FROM ( '  + char(10)

	SELECT @v_dSql += @v_pSql

	SELECT @v_dSql += '	) A' + char(10)
	SELECT @v_dSql += '	          WHERE CATEGORY_ID <> ''X'' ' + char(10)
	SELECT @v_dSql += '	      ) B ' + char(10)
	SELECT @v_dSql += '	      ON 1=1 ' + char(10)
	SELECT @v_dSql += '	      INNER HASH JOIN TH_UIS_CAL C WITH(NOLOCK) ' + char(10)
	SELECT @v_dSql += '	      ON  A.PLAN_DATE = C.DT ' + char(10)
	SELECT @v_dSql += '	      GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
	SELECT @v_dSql += '	             , A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME ' + char(10)
	SELECT @v_dSql += '	             , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
	SELECT @v_dSql += '	             , A.EQUIPMENT_ID ' + char(10)
	SELECT @v_dSql += '	             , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME ' + char(10)
	SELECT @v_dSql += '	             , A.PRODUCTION_TYPE, A.MARKET, A.PROD_VERSION_TYPE ' + char(10)
	SELECT @v_dSql += '	             , B.CATEGORY_ID, B.CATEGORY_NAME, B.MEASURE_NAME, B.CATEGORY_ORDER ' + char(10)
	SELECT @v_dSql += '	             , A.CALC_TYPE ' + char(10)
	--SELECT @v_dSql += '	             , A.PROD_SEQ, A.VERSION ' + char(10)
	SELECT @v_dSql += '	             , A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PROD_SEQ, A.PLM_EC_NO ' + char(10)
	SELECT @v_dSql += '		) A ' + char(10)
	SELECT @v_dSql += '		LEFT OUTER HASH JOIN ( ' + char(10)
	SELECT @v_dSql += '	 				SELECT * FROM   #SCM_PANCAKE_MATERIAL_V A	' + char(10)
	SELECT @v_dSql += '	         ) E' + char(10)
	SELECT @v_dSql += '	         ON  A.COMPANY_ID      = E.COMPANY_ID' + char(10)
	SELECT @v_dSql += '	         AND A.DIVISION_ID     = E.DIVISION_ID' + char(10)
	SELECT @v_dSql += '	         AND A.SITE_ID         = E.SITE_ID' + char(10)
	SELECT @v_dSql += '	         AND A.PLANT_ID        = E.PLANT_ID' + char(10)
	SELECT @v_dSql += '	         AND A.FACTORY_ID      = E.FACTORY_ID' + char(10)
	SELECT @v_dSql += '	         AND A.ITEM_ID         = E.PC_ITEM_ID' + char(10)
	SELECT @v_dSql += '	         AND A.WORK_REQUEST_MODEL_ID = E.MODEL_ID' + char(10)
	SELECT @v_dSql += '	         AND A.VERSION               = E.PROD_VERSION' + char(10)
	SELECT @v_dSql += '	         AND A.PROD_SEQ              = E.PROD_SEQ' + char(10)
	/*
	SELECT @v_dSql += '	         AND A.PROD_VERSION_TYPE = E.PROD_VERSION_TYPE' + char(10)
	SELECT @v_dSql += '	         AND A.CALC_TYPE = E.PROD_TYPE' + char(10)
	SELECT @v_dSql += '	         LEFT OUTER HASH JOIN (' + char(10)
	SELECT @v_dSql += '	 				SELECT * FROM   #SCM_PANCAKE_MATERIAL_V A	' + char(10)
	SELECT @v_dSql += '	    ) F'+char(10)
	SELECT @v_dSql += '	    ON  A.COMPANY_ID      = F.COMPANY_ID'+char(10)
	SELECT @v_dSql += '	    AND A.DIVISION_ID     = F.DIVISION_ID'+char(10)
	SELECT @v_dSql += '	    AND A.SITE_ID         = F.SITE_ID'+char(10)
	SELECT @v_dSql += '	    AND A.PLANT_ID        = F.PLANT_ID'+char(10)
	SELECT @v_dSql += '	    AND A.FACTORY_ID      = F.FACTORY_ID'+char(10)
	SELECT @v_dSql += '	    AND A.ITEM_ID         = F.PC_ITEM_ID'+char(10)
	SELECT @v_dSql += '	    AND A.WORK_REQUEST_MODEL_ID = F.MODEL_ID'+char(10)
	SELECT @v_dSql += '	    AND A.PROD_VERSION_TYPE = F.PROD_VERSION_TYPE'+char(10)
	SELECT @v_dSql += '	    AND A.CALC_TYPE <> F.PROD_TYPE'+char(10)
	*/
	SELECT @v_dSql += '	    LEFT OUTER JOIN ('+char(10)
	SELECT @v_dSql += '		SELECT   A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.ITEM_ID'+char(10)
	SELECT @v_dSql += '		       , MAX(CASE WHEN A.TACT_TIME > 0 THEN ROUND(60/A.TACT_TIME, 0) ELSE 0 END) DAILY_CAPA_PPM'+char(10)
	SELECT @v_dSql += '					 , MAX(CASE WHEN A.TACT_TIME > 0 THEN ROUND(60/(A.TACT_TIME*2), 0) ELSE 0 END) DAILY_CAPA_PPM2'+char(10)
	SELECT @v_dSql += '		FROM   SCM_TACT_TIME_M A WITH(NOLOCK)'+char(10)
	SELECT @v_dSql += '		WHERE  1=1'+char(10)

	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.DIVISION_ID' , 'EQ', @p_division_id))        + char(10)
	IF(LEN(@p_site_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.SITE_ID' , 'EQ', @p_site_id))        + char(10)
	END
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.PLANT_ID' , 'EQ', @p_plant_id))              + char(10)

	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.FACTORY_ID' , 'EQ', @p_factory_id))          + char(10) 

	IF(LEN(@p_operation_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.OPERATION_ID' , 'EQ', @p_operation_id))      + char(10)
	END
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.LINE_ID' , 'EQ', @p_line_id))                + char(10)
	IF(LEN(@p_item_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.ITEM_ID' , 'LK', @p_item_id))                + char(10)
	END

	SELECT @v_dSql += '	   AND    A.MONTH = SUBSTRING(' + @v_plan_date +',1,6)'+char(10)
	SELECT @v_dSql += '			            	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.ITEM_ID'+char(10)
	SELECT @v_dSql += '	     ) G'+char(10)
	SELECT @v_dSql += '	     ON  A.COMPANY_ID      = G.COMPANY_ID'+char(10)
	SELECT @v_dSql += '	     AND A.DIVISION_ID     = G.DIVISION_ID'+char(10)
	SELECT @v_dSql += '	     AND A.SITE_ID         = G.SITE_ID'+char(10)
	SELECT @v_dSql += '	     AND A.PLANT_ID        = G.PLANT_ID'+char(10)
	SELECT @v_dSql += '	     AND A.FACTORY_ID      = G.FACTORY_ID'+char(10)
	SELECT @v_dSql += '	     AND A.OPERATION_ID    = G.OPERATION_ID'+char(10)
	SELECT @v_dSql += '	     AND A.LINE_ID         = G.LINE_ID'+char(10)
	SELECT @v_dSql += '	     AND A.ELECTRODE_TYPE  = G.ELECTRODE_TYPE'+char(10)
	SELECT @v_dSql += '	     AND A.ITEM_ID         = G.ITEM_ID'+char(10)
	-- foil 정보 수정... 20240329
	SELECT @v_dSql += '	     LEFT OUTER JOIN #FOIL_INFO H WITH(NOLOCK) '+char(10)
	SELECT @v_dSql += '	     ON 1=1 '+char(10)
	SELECT @v_dSql += '	     AND A.COMPANY_ID            = H.COMPANY_ID '+char(10)
	SELECT @v_dSql += '	     AND A.DIVISION_ID           = H.DIVISION_ID '+char(10)
	SELECT @v_dSql += '	     AND A.SITE_ID               = H.SITE_ID '+char(10)
	SELECT @v_dSql += '	     AND A.PLANT_ID              = H.PLANT_ID '+char(10)
	SELECT @v_dSql += '	     AND A.FACTORY_ID            = H.FACTORY_ID '+char(10)
	SELECT @v_dSql += '	     AND A.LINE_ID               = H.LINE_ID '+char(10)
	SELECT @v_dSql += '	     AND A.ITEM_ID               = H.ITEM_ID '+char(10)
	SELECT @v_dSql += '	     AND A.WORK_REQUEST_MODEL_ID = H.MODEL_ID '+char(10)
	SELECT @v_dSql += '	     AND A.VERSION               = H.VERSION '+char(10)
/*
	SELECT @v_dSql += '	     LEFT OUTER HASH JOIN ('+char(10)
	SELECT @v_dSql += '				SELECT * FROM #FOIL_M A	'+char(10)
	
	--SELECT @v_dSql += '		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.FOIL_CODE, A.FOIL, A.PROD_VERSION_TYPE, A.LINE_ID, A.PROD_TYPE'+char(10)
	--SELECT @v_dSql += '		FROM   ( '+char(10)
	--SELECT @v_dSql += '					SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.FOIL_ID AS FOIL_CODE, B.ITEM_NAME AS FOIL, A.PROD_VERSION_TYPE, C.LINE_ID'+char(10)
	--SELECT @v_dSql += '							 , CASE WHEN LEFT(V.PROD_VERSION, 1) = ''Z'' THEN ''TEST'' ELSE ''MASS'' END AS PROD_TYPE'+char(10)
	--SELECT @v_dSql += '						   , ROW_NUMBER() OVER ( 	PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.PROD_VERSION_TYPE, C.LINE_ID'+char(10)
	--SELECT @v_dSql += '						   										 , CASE WHEN LEFT(V.PROD_VERSION, 1) = ''Z'' THEN ''TEST'' ELSE ''MASS'' END'+char(10)
	--SELECT @v_dSql += '													ORDER BY V.APPLY_DATE DESC, A.PROD_VERSION DESC, A.PROD_SEQ DESC )	 AS NUM'+char(10)
	--SELECT @v_dSql += '					FROM 	SCM_ITEM_FOIL_M        A WITH(NOLOCK)'+char(10)
	--SELECT @v_dSql += '						   ,FP_PROD_VERSION_M      V WITH(NOLOCK)'+char(10)
	--SELECT @v_dSql += '						   ,SCM_ITEM_M             B WITH(NOLOCK)'+char(10)
	--SELECT @v_dSql += '						   ,SCM_ITEM_LINE_ASSIGN_M C WITH(NOLOCK)'+char(10)
	--SELECT @v_dSql += '					WHERE 1=1'+char(10)
	--SELECT @v_dSql += '					AND   A.FACTORY_ID    = V.FACTORY_ID'+char(10)
	--SELECT @v_dSql += '					AND   A.MODEL_ID      = V.MODEL_ID'+char(10)
	--SELECT @v_dSql += '					AND   A.ITEM_ID       = V.ITEM_ID'+char(10)
	--SELECT @v_dSql += '					AND   A.PROD_VERSION  = V.PROD_VERSION'+char(10)
	--SELECT @v_dSql += '					AND   A.PROD_SEQ      = V.PROD_SEQ'+char(10)
	--SELECT @v_dSql += '					AND   A.COMPANY_ID = B.COMPANY_ID'+char(10)
	--SELECT @v_dSql += '					AND   A.DIVISION_ID = B.DIVISION_ID'+char(10)
	--SELECT @v_dSql += '					AND   A.SITE_ID = B.SITE_ID'+char(10)
	--SELECT @v_dSql += '					AND   A.FOIL_ID = B.ITEM_ID'+char(10)
	--SELECT @v_dSql += '					AND   A.COMPANY_ID = C.COMPANY_ID'+char(10)
	--SELECT @v_dSql += '					AND   A.DIVISION_ID = C.DIVISION_ID'+char(10)
	--SELECT @v_dSql += '					AND   A.SITE_ID = C.SITE_ID'+char(10)
	--SELECT @v_dSql += '					AND   A.PLANT_ID = C.PLANT_ID'+char(10)
	--SELECT @v_dSql += '					AND   A.FACTORY_ID = C.FACTORY_ID'+char(10)
	--SELECT @v_dSql += '					AND   A.ITEM_ID = C.ITEM_ID'+char(10)

	--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.DIVISION_ID' , 'EQ', @p_division_id))        + char(10)
	--IF(LEN(@p_site_id) > 0)
	--BEGIN
	--	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.SITE_ID' , 'EQ', @p_site_id))        + char(10)
	--END
	--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.PLANT_ID' , 'EQ', @p_plant_id))              + char(10)

	--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.FACTORY_ID' , 'EQ', @p_factory_id))          + char(10) 

	--IF(LEN(@p_operation_id) > 0)
	--BEGIN
	--	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                C.OPERATION_ID' , 'EQ', @p_operation_id))      + char(10)
	--END
	--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            C.LINE_ID' , 'EQ', @p_line_id))                + char(10)
	--IF(LEN(@p_item_id) > 0)
	--BEGIN
	--	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.ITEM_ID' , 'LK', @p_item_id))                + char(10)
	--END
								  
	--SELECT @v_dSql += ' ) A ' + char(10)
	--SELECT @v_dSql += ' 										WHERE  NUM = 1 ' + char(10)
	SELECT @v_dSql += '     ) H ' + char(10)
	SELECT @v_dSql += '     ON 1=1 ' + char(10)
	SELECT @v_dSql += '     AND A.COMPANY_ID      = H.COMPANY_ID ' + char(10)
	SELECT @v_dSql += '     AND A.DIVISION_ID     = H.DIVISION_ID ' + char(10)
	SELECT @v_dSql += '     AND A.SITE_ID         = H.SITE_ID ' + char(10)
	SELECT @v_dSql += '     AND A.PLANT_ID        = H.PLANT_ID ' + char(10)
	SELECT @v_dSql += '     AND A.FACTORY_ID      = H.FACTORY_ID ' + char(10)
	SELECT @v_dSql += '     AND A.LINE_ID         = H.LINE_ID ' + char(10)
	SELECT @v_dSql += ' 	AND A.ITEM_ID         = H.ITEM_ID ' + char(10)
	SELECT @v_dSql += '     AND A.PROD_VERSION_TYPE = H.PROD_VERSION_TYPE ' + char(10)
	SELECT @v_dSql += '     AND A.CALC_TYPE       = H.PROD_TYPE ' + char(10)
*/



	SELECT @v_dSql += ' 		LEFT OUTER JOIN #T_RELEASE Z WITH(NOLOCK) ' + char(10)
	SELECT @v_dSql += ' 	  	ON  1=1 ' + char(10)
	SELECT @v_dSql += ' 	  	AND A.FACTORY_ID = Z.FACTORY_ID ' + char(10)
	SELECT @v_dSql += '   		LEFT OUTER JOIN ( ' + char(10)
	SELECT @v_dSql += '         	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
	SELECT @v_dSql += ' 		            , A.LOCATION, A.OPERATION_ID ' + char(10)
	SELECT @v_dSql += ' 		            , A.LINE_ID ' + char(10)
	SELECT @v_dSql += ' 		            , A.TOP_ITEM_ID, A.ITEM_ID ' + char(10)
	SELECT @v_dSql += ' 		            , A.PRODUCTION_TYPE, A.MARKET ' + char(10)
	SELECT @v_dSql += ' 		            , MIN(LINE_SEQ) LINE_SEQ ' + char(10)
	SELECT @v_dSql += '         	FROM ( ' + char(10)
	SELECT @v_dSql += ' 		        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
	SELECT @v_dSql += ' 			           , A.LOCATION, A.OPERATION_ID ' + char(10)
	SELECT @v_dSql += ' 			           , A.LINE_ID ' + char(10)
	SELECT @v_dSql += ' 			           , A.PLAN_DATE ' + char(10)
	SELECT @v_dSql += ' 			           , A.TOP_ITEM_ID, A.ITEM_ID ' + char(10)
	SELECT @v_dSql += ' 			           , A.PRODUCTION_TYPE, A.MARKET ' + char(10)
	SELECT @v_dSql += ' 			           , A.SEQ ' + char(10)
	SELECT @v_dSql += ' 			           , RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
	SELECT @v_dSql += ' 	                                      , A.LOCATION, A.OPERATION_ID, A.LINE_ID' + char(10)
	SELECT @v_dSql += ' 	                   				ORDER     BY A.PLAN_DATE, A.SEQ ) LINE_SEQ' + char(10)
	SELECT @v_dSql += ' 			    FROM   #TblFP00614_FIND_FP00614 A WITH(NOLOCK)' + char(10)
	SELECT @v_dSql += ' 			    INNER JOIN SCM_ITEM_M B WITH(NOLOCK)' + char(10)
	SELECT @v_dSql += ' 			    ON     A.COMPANY_ID     = B.COMPANY_ID' + char(10)
	SELECT @v_dSql += ' 			    AND    A.DIVISION_ID    = B.DIVISION_ID' + char(10)
	SELECT @v_dSql += ' 			    AND    A.SITE_ID        = B.SITE_ID' + char(10)
	SELECT @v_dSql += ' 			    AND    A.ITEM_ID        = B.ITEM_ID' + char(10)
	SELECT @v_dSql += ' 			    INNER JOIN SCM_LINE_M C WITH(NOLOCK)' + char(10)
	SELECT @v_dSql += ' 			    ON     A.COMPANY_ID     = C.COMPANY_ID' + char(10)
	SELECT @v_dSql += ' 			    AND    A.DIVISION_ID    = C.DIVISION_ID' + char(10)
	SELECT @v_dSql += ' 			    AND    A.SITE_ID        = C.SITE_ID' + char(10)
	SELECT @v_dSql += ' 			    AND    A.PLANT_ID       = C.PLANT_ID' + char(10)
	SELECT @v_dSql += ' 			    AND    A.FACTORY_ID     = C.FACTORY_ID' + char(10)
	SELECT @v_dSql += ' 			    AND    A.OPERATION_ID   = C.OPERATION_ID' + char(10)
	SELECT @v_dSql += ' 			    AND    A.LINE_ID        = C.LINE_ID' + char(10)
	SELECT @v_dSql += ' 			    AND    A.ELECTRODE_TYPE = C.ELECTRODE_TYPE' + char(10)
	SELECT @v_dSql += ' 			    WHERE  1=1' + char(10)
	--SELECT @v_dSql += ' 			    AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN ' +  @v_bucket_from + ' AND ' +  @v_bucket_to + char(10)



	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.DIVISION_ID' , 'EQ', @p_division_id))        + char(10)
	IF(LEN(@p_site_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.SITE_ID' , 'EQ', @p_site_id))        + char(10)
	END
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.PLANT_ID' , 'EQ', @p_plant_id))              + char(10)

	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.FACTORY_ID' , 'EQ', @p_factory_id))          + char(10) 

	IF(LEN(@p_operation_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.OPERATION_ID' , 'EQ', @p_operation_id))      + char(10)
	END


	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.LINE_ID' , 'EQ', @p_line_id))                + char(10)
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type))   + char(10)

	IF(LEN(@p_top_item_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.TOP_ITEM_ID' , 'LK', @p_top_item_id))                + char(10)
	END

	IF(LEN(@p_item_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.ITEM_ID' , 'LK', @p_item_id))                + char(10)
	END



	IF(LEN(@p_nick_name) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('               ISNULL(B.NICK_NAME,''-'')' , 'LK', @p_nick_name))        + char(10)
	END
	IF(LEN(@p_nick_name_lt) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('       ISNULL(B.NICK_NAME,''-'')' , 'LK', @p_nick_name_lt))        + char(10)
	END


	--IF(LEN(@p_prod_type) > 0)
	--BEGIN
	--	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.FP_PRODUCTION_TYPE' , 'LK', @p_prod_type))                + char(10)
	--END
		
	SELECT @v_dSql += 'AND 	ISNULL(A.SEQ, 0) <> 0 ' + char(10)
	SELECT @v_dSql += '					              AND 	(A.BATCH_IN_QTY + A.PLAN_IN_QTY + A.ROLL_IN_QTY + A.CELL_IN_QTY + A.JR_IN_QTY + A.BATCH_OUT_QTY + A.PLAN_QTY + A.ROLL_OUT_QTY + A.CELL_OUT_QTY + A.JR_OUT_QTY) > 0 ' + char(10)     
	SELECT @v_dSql += '					          ) A' + char(10)
	SELECT @v_dSql += '					          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + char(10)
	SELECT @v_dSql += '	                         , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.TOP_ITEM_ID, A.ITEM_ID' + char(10)
	SELECT @v_dSql += '	                         , A.PRODUCTION_TYPE, A.MARKET' + char(10)
	SELECT @v_dSql += '			) B' + char(10)
	SELECT @v_dSql += '     	ON  A.COMPANY_ID      = B.COMPANY_ID' + char(10)
	SELECT @v_dSql += '				AND A.DIVISION_ID     = B.DIVISION_ID' + char(10)
	SELECT @v_dSql += '				AND A.SITE_ID         = B.SITE_ID' + char(10)
	SELECT @v_dSql += '				AND A.PLANT_ID        = B.PLANT_ID' + char(10)
	SELECT @v_dSql += '				AND A.FACTORY_ID      = B.FACTORY_ID' + char(10)
	SELECT @v_dSql += '				AND A.LOCATION        = B.LOCATION' + char(10)
	SELECT @v_dSql += '				AND A.OPERATION_ID    = B.OPERATION_ID' + char(10)
	SELECT @v_dSql += '				AND A.LINE_ID         = B.LINE_ID' + char(10)
	SELECT @v_dSql += '				AND A.TOP_ITEM_ID     = B.TOP_ITEM_ID' + char(10)
	SELECT @v_dSql += '				AND A.ITEM_ID         = B.ITEM_ID' + char(10)
	SELECT @v_dSql += '				AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE' + char(10)
	SELECT @v_dSql += '				AND A.MARKET         	= B.MARKET' + char(10)
--	SELECT @v_dSql += '  )' + char(10)
	SELECT @v_dSql += '' + char(10) + char(10)


	----------------------
	SELECT @v_dSql += 'if object_id(''tempdb..#MAIN_GAP'') is not null' + char(10)
	SELECT @v_dSql += '		drop table #MAIN_GAP;' + char(10)

--	SELECT @v_dSql += '  , MAIN_GAP AS (' + char(10)
	SELECT @v_dSql += '			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + char(10)
	SELECT @v_dSql += '					, A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME' + char(10)
	SELECT @v_dSql += '					, A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE' + char(10)
	SELECT @v_dSql += '					, A.EQUIPMENT_ID' + char(10)
	SELECT @v_dSql += '					, A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME' + char(10)
	SELECT @v_dSql += '					, A.PRODUCTION_TYPE, A.MARKET' + char(10)
	SELECT @v_dSql += '					, A.BATCH_ID' + char(10)
	SELECT @v_dSql += '					, A.SLURRY_1, A.SLURRY_2' + char(10)
	SELECT @v_dSql += '					, A.PRE_DISPERSION_ID' + char(10)
	SELECT @v_dSql += '					, A.PRE_DISPERSION_NAME' + char(10)
	SELECT @v_dSql += '					, A.PRE_DISPERSION_ID_2' + char(10)
	SELECT @v_dSql += '					, A.PRE_DISPERSION_NAME_2' + char(10)
	SELECT @v_dSql += '					, A.ACTIVE_MATERIAL_1' + char(10)
	SELECT @v_dSql += '					, A.ACTIVE_MATERIAL_2' + char(10)
	SELECT @v_dSql += '					, A.ACTIVE_MATERIAL_3' + char(10)
	SELECT @v_dSql += '					, A.BINDER_1' + char(10)
	SELECT @v_dSql += '					, A.BINDER_2' + char(10)
	SELECT @v_dSql += '					, A.BINDER_3' + char(10)
	SELECT @v_dSql += '					, A.CONDUCTION_MATERIAL_1' + char(10)
	SELECT @v_dSql += '					, A.CONDUCTION_MATERIAL_2' + char(10)
	SELECT @v_dSql += '					, A.CMC' + char(10)
	SELECT @v_dSql += '					, A.VERSION' + char(10)
	SELECT @v_dSql += '					, A.PC_MODEL_ID' + char(10)
	SELECT @v_dSql += '					, A.ADDITION_AGENT' + char(10)
	SELECT @v_dSql += '					, A.FOIL_CODE' + char(10)
	SELECT @v_dSql += '					, A.FOIL' + char(10)
	SELECT @v_dSql += '					, A.DC_PPM' + char(10)
	SELECT @v_dSql += '					, A.CATEGORY_NAME' + char(10)
	SELECT @v_dSql += '					, A.MEASURE_NAME' + char(10)

	SELECT @v_dSql += @p_day2month
	SELECT @v_dSql += @p_day2week

	 IF ISNULL(@p_day_info,'') <> '' 
	BEGIN
		SET @mst_loop_cnt     = 0
		SET @v_delimiter      = '|'  
		SET @max_loop_cnt     = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
	
		IF @max_loop_cnt > 0 
		BEGIN    
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SELECT @v_dSql += '                 , A.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+ ' AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
				SELECT @mst_loop_cnt =  @mst_loop_cnt + 1
			END
		END 
	END


	IF ISNULL(@p_week_info,'') <> ''
	BEGIN
		SET @mst_loop_cnt = 0
		SET @max_loop_cnt = 0
		SET @v_delimiter      = '|'  -- 데이터 구분자
		SET @max_loop_cnt     = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단    
        
		IF @max_loop_cnt > 0 
		BEGIN
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '            , NULL AS T'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+ char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END
		END
	END
	 IF ISNULL(@p_day_info,'') <> '' 
	BEGIN
		SET @mst_loop_cnt     = 0
		SET @v_delimiter      = '|'  
		SET @max_loop_cnt     = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
	
		IF @max_loop_cnt > 0 
		BEGIN    
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SELECT @v_dSql += '                 , A.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+ '_BG' + char(10)
				SELECT @mst_loop_cnt =  @mst_loop_cnt + 1
			END
		END 
	END

	SELECT @v_dSql += '						, A.CATEGORY_ID													   ' + char(10)
	SELECT @v_dSql += '						, A.CATEGORY_ORDER												   ' + char(10)
	SELECT @v_dSql += '						, A.DATA_TYPE													   ' + char(10)
	SELECT @v_dSql += '						, A.LINE_SEQ													   ' + char(10)
	SELECT @v_dSql += '						, A.CALC_TYPE													   ' + char(10)
	SELECT @v_dSql += '						, A.PROD_SEQ													   ' + char(10)
	SELECT @v_dSql += '						, A.PLM_EC_NO													   ' + char(10)
	SELECT @v_dSql += '				into #MAIN_GAP															   ' + char(10)
	SELECT @v_dSql += '				FROM (																	   ' + char(10)
	SELECT @v_dSql += '					SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + char(10)
	SELECT @v_dSql += '						   , A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME										 ' + char(10)
	SELECT @v_dSql += '						   , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE											 ' + char(10)
	SELECT @v_dSql += '						   , A.EQUIPMENT_ID																		 ' + char(10)
	SELECT @v_dSql += '						   , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME												 ' + char(10)
	SELECT @v_dSql += '						   , A.PRODUCTION_TYPE, A.MARKET														 ' + char(10)
	SELECT @v_dSql += '						   , E.BATCH_ID ' + char(10)
	SELECT @v_dSql += '						   , E.SLURRY_1, E.SLURRY_2 ' + char(10)
	SELECT @v_dSql += '						   , E.PRE_DISPERSION_ID ' + char(10)
	SELECT @v_dSql += '						   , E.PRE_DISPERSION_NAME ' + char(10)
	SELECT @v_dSql += '						   , E.PRE_DISPERSION_ID_2 ' + char(10)
	SELECT @v_dSql += '						   , E.PRE_DISPERSION_NAME_2 ' + char(10)
	SELECT @v_dSql += '						   , E.ACTIVE_MATERIAL_1 ' + char(10)
	SELECT @v_dSql += '						   , E.ACTIVE_MATERIAL_2 ' + char(10)
	SELECT @v_dSql += '						   , E.ACTIVE_MATERIAL_3 ' + char(10)
	SELECT @v_dSql += '						   , E.BINDER_1 ' + char(10)
	SELECT @v_dSql += '						   , E.BINDER_2 ' + char(10)
	SELECT @v_dSql += '						   , E.BINDER_3 ' + char(10)
	SELECT @v_dSql += '						   , E.CONDUCTION_MATERIAL_1 ' + char(10)
	SELECT @v_dSql += '						   , E.CONDUCTION_MATERIAL_2 ' + char(10)
	SELECT @v_dSql += '						   , E.CMC ' + char(10)
	SELECT @v_dSql += '						   , A.VERSION ' + char(10)
	SELECT @v_dSql += '						   , A.WORK_REQUEST_MODEL_ID AS PC_MODEL_ID ' + char(10)
	SELECT @v_dSql += '						   , E.ADDITION_AGENT AS ADDITION_AGENT ' + char(10)
	/*
	SELECT @v_dSql += '						   , ISNULL(E.BATCH_ID,F.BATCH_ID) AS BATCH_ID											 ' + char(10)
	SELECT @v_dSql += '						   , ISNULL(E.SLURRY_1,F.SLURRY_1) AS SLURRY_1, ISNULL(E.SLURRY_2,F.SLURRY_2) AS SLURRY_2' + char(10)
	SELECT @v_dSql += '						   , ISNULL(E.PRE_DISPERSION_ID,F.PRE_DISPERSION_ID) AS PRE_DISPERSION_ID			 ' + char(10)
	SELECT @v_dSql += '						   , ISNULL(E.PRE_DISPERSION_NAME,F.PRE_DISPERSION_NAME) AS PRE_DISPERSION_NAME		 ' + char(10)
	SELECT @v_dSql += '						   , ISNULL(E.PRE_DISPERSION_ID_2,F.PRE_DISPERSION_ID_2) AS PRE_DISPERSION_ID_2		 ' + char(10)
	SELECT @v_dSql += '						   , ISNULL(E.PRE_DISPERSION_NAME_2,F.PRE_DISPERSION_NAME_2) AS PRE_DISPERSION_NAME_2' + char(10)
	SELECT @v_dSql += '						   , ISNULL(E.ACTIVE_MATERIAL_1,F.ACTIVE_MATERIAL_1) AS ACTIVE_MATERIAL_1			 ' + char(10)
	SELECT @v_dSql += '						   , ISNULL(E.ACTIVE_MATERIAL_2,F.ACTIVE_MATERIAL_2) AS ACTIVE_MATERIAL_2			 ' + char(10)
	SELECT @v_dSql += '						   , ISNULL(E.ACTIVE_MATERIAL_3,F.ACTIVE_MATERIAL_3) AS ACTIVE_MATERIAL_3			 ' + char(10)
	SELECT @v_dSql += '						   , ISNULL(E.BINDER_1,F.BINDER_1) AS BINDER_1										 ' + char(10)
	SELECT @v_dSql += '						   , ISNULL(E.BINDER_2,F.BINDER_2) AS BINDER_2										 ' + char(10)
	SELECT @v_dSql += '						   , ISNULL(E.BINDER_3,F.BINDER_3) AS BINDER_3										 ' + char(10)
	SELECT @v_dSql += '						   , ISNULL(E.CONDUCTION_MATERIAL_1,F.CONDUCTION_MATERIAL_1) AS CONDUCTION_MATERIAL_1' + char(10)
	SELECT @v_dSql += '						   , ISNULL(E.CONDUCTION_MATERIAL_2,F.CONDUCTION_MATERIAL_2) AS CONDUCTION_MATERIAL_2' + char(10)
	SELECT @v_dSql += '						   , ISNULL(E.CMC,F.CMC) AS CMC' + char(10)
	SELECT @v_dSql += '						   , A.VERSION' + char(10)
	--SELECT @v_dSql += '						   , ISNULL(E.MODEL_ID,F.MODEL_ID) AS PC_MODEL_ID' + char(10)
	SELECT @v_dSql += '						   , A.WORK_REQUEST_MODEL_ID AS PC_MODEL_ID' + char(10)
	SELECT @v_dSql += '						   , ISNULL(E.ADDITION_AGENT,F.ADDITION_AGENT) AS ADDITION_AGENT' + char(10)
	*/
	SELECT @v_dSql += '						   , ISNULL(H.FOIL_CODE, dbo.FN_GET_FOIL(A.FACTORY_ID, A.ITEM_ID, A.PROD_VERSION_TYPE, ''FOIL_CODE'')) AS FOIL_CODE' + char(10)
	SELECT @v_dSql += '						   , ISNULL(H.FOIL, dbo.FN_GET_FOIL(A.FACTORY_ID, A.ITEM_ID,A.PROD_VERSION_TYPE, ''FOIL'')) AS FOIL' + char(10)
	SELECT @v_dSql += '						   , G.DAILY_CAPA_PPM  AS DC_PPM' + char(10)
	SELECT @v_dSql += '						   , A.CATEGORY_NAME' + char(10)
	SELECT @v_dSql += '						   , A.MEASURE_NAME' + char(10)
						   


		IF(@p_curr_date_col = '-999')
			BEGIN
				IF ISNULL(@p_day_info,'') <> '' 
				BEGIN
					SET @mst_loop_cnt     = 0
					SET @v_delimiter      = '|'  -- 데이터 구분자
					--SET @sub_v_delimiter  = '#'
					SET @max_loop_cnt     = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
					--SET @v_Tmp1           = ''

					IF @max_loop_cnt > 0 
					BEGIN
						-- bucket
						SET @mst_loop_cnt = 0	
						SET @max_loop_cnt = 0
						SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
            
						WHILE @mst_loop_cnt < @max_loop_cnt
						BEGIN
							SET @v_dSql += '                 , A.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+ ' ' + char(10)
							SET @mst_loop_cnt =  @mst_loop_cnt + 1
						END
					END 
				END
			END
			ELSE
			BEGIN
				IF ISNULL(@p_day_info,'') <> '' 
				BEGIN
					SET @mst_loop_cnt     = 0
					SET @v_delimiter      = '|'  -- 데이터 구분자
					--SET @sub_v_delimiter  = '#'
					SET @max_loop_cnt     = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
					--SET @v_Tmp1           = ''

					IF @max_loop_cnt > 0 
					BEGIN
    
						DECLARE @vFlag   NVARCHAR(1) = 'N'
						-- bucket
						SET @mst_loop_cnt = 0	
						SET @max_loop_cnt = 0
						SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
            
						WHILE @mst_loop_cnt < @max_loop_cnt
						BEGIN
					
							IF(@p_curr_date_col = 'D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt))
							BEGIN
								SET @v_dSql += '                 , 0  AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+ ' ' + char(10)
								SET @vFlag = 'Y'
							END
							ELSE
							BEGIN
								IF(@vFlag = 'Y')
								BEGIN
									SET @v_dSql += '                 , 0 AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+ ' ' + char(10)
								END
								ELSE
								BEGIN
									SET @v_dSql += '                 , A.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+ ' ' + char(10)
								END
							END
							SET @mst_loop_cnt =  @mst_loop_cnt + 1
						END
					END 
				END
			END

	IF ISNULL(@p_day_info,'') <> '' 
	BEGIN
		-- bucket
		SET @mst_loop_cnt = 0	
		SET @max_loop_cnt = 0
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단

		WHILE @mst_loop_cnt < @max_loop_cnt
		BEGIN
        
			SELECT @v_dSql += ', CASE WHEN A.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+ '_BG IS NOT NULL AND A.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+ '_BG <> '''' THEN A.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+ '_BG ELSE Z.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+  '_BG END D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+'_BG' +char(10)
			SELECT @mst_loop_cnt =  @mst_loop_cnt + 1
		END
	END

	SELECT @v_dSql += '		   , A.CATEGORY_ID, A.CATEGORY_ORDER'+char(10)
	SELECT @v_dSql += '		   , A.DATA_TYPE'+char(10)
	SELECT @v_dSql += '		   , ISNULL(B.LINE_SEQ, 9999) LINE_SEQ'+char(10)
	SELECT @v_dSql += '		   , A.CALC_TYPE'+char(10)
	SELECT @v_dSql += '		   , A.PROD_SEQ'+char(10)
	SELECT @v_dSql += '		   , A.PLM_EC_NO'+char(10)
	SELECT @v_dSql += '	FROM ('+char(10)
	SELECT @v_dSql += '		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
	SELECT @v_dSql += '			   , A.LOCATION, A.OPERATION_ID, D.OPERATION_NAME'+char(10)
	SELECT @v_dSql += '			   , A.LINE_ID, ISNULL(C.LINE_NAME,''-'') AS LINE_NAME, A.ELECTRODE_TYPE'+char(10)
	SELECT @v_dSql += '			   , A.EQUIPMENT_ID'+char(10)
	SELECT @v_dSql += '			   , A.ITEM_ID, A.TOP_ITEM_ID, ISNULL(B.NICK_NAME,''-'') AS NICK_NAME'+char(10)
	SELECT @v_dSql += '			   , A.PRODUCTION_TYPE, A.MARKET, C.PROD_VERSION_TYPE'+char(10)
	SELECT @v_dSql += '			   , E.CATEGORY_NAME'+char(10)
	SELECT @v_dSql += '			   , E.MEASURE_NAME'+char(10)

	IF ISNULL(@p_day_info,'') <> ''
	BEGIN
		-- bucket
		SET @mst_loop_cnt = 0	
		SET @max_loop_cnt = 0
		SET @v_delimiter            = '^'  
		SET @v_sub_delimiter        = '|'  
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_sub_delimiter) -- 프로시저 LOOP 길이를 판단
	
		WHILE @mst_loop_cnt < @max_loop_cnt
		BEGIN
			SELECT @mst_loop_cnt =  @mst_loop_cnt + 1	
			SELECT @v_day_info   = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_sub_delimiter, @mst_loop_cnt)
		
			SELECT @v_dSql += '	 , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)<='''+ @v_day_info +''' AND A.PLAN_DATE >= F.INSTANCE_DATE THEN (CASE	WHEN E.CATEGORY_ID=''GAP_IN_M'' THEN A.GAP_IN_QTY_M ' + char(10)
			SELECT @v_dSql += '	 WHEN E.CATEGORY_ID=''GAP_IN_JR'' THEN A.GAP_IN_QTY_JR' + char(10)
			SELECT @v_dSql += '	 WHEN E.CATEGORY_ID=''GAP_IN_CELL'' THEN A.GAP_IN_QTY_CELL' + char(10)
			SELECT @v_dSql += '	 WHEN E.CATEGORY_ID=''GAP_IN_BATCH'' THEN A.GAP_IN_QTY_BATCH' + char(10)
			SELECT @v_dSql += '	 WHEN E.CATEGORY_ID=''GAP_OUT_M'' THEN A.GAP_OUT_QTY_M' + char(10)
			SELECT @v_dSql += '	 WHEN E.CATEGORY_ID=''GAP_OUT_JR'' THEN A.GAP_OUT_QTY_JR' + char(10)
			SELECT @v_dSql += '	 WHEN E.CATEGORY_ID=''GAP_OUT_CELL'' THEN A.GAP_OUT_QTY_CELL' + char(10)
			SELECT @v_dSql += '	 WHEN E.CATEGORY_ID=''GAP_OUT_BATCH'' THEN A.GAP_OUT_QTY_BATCH' + char(10)  
			SELECT @v_dSql += '	 ELSE 0 END) ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt -1) + char(10)  
	
		END

		-- bucket
		SET @mst_loop_cnt = 0	
		SET @max_loop_cnt = 0
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_sub_delimiter) -- 프로시저 LOOP 길이를 판단

		WHILE @mst_loop_cnt < @max_loop_cnt
		BEGIN
		 SELECT @mst_loop_cnt =  @mst_loop_cnt + 1	
			SELECT @v_bucket   = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_sub_delimiter, @mst_loop_cnt)
			SELECT @v_dSql += '	  , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)='''+ @v_bucket + ''' THEN A.BGCOLOR ELSE '''' END ) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + '_BG' + char(10)        
       	
		END
	END

	SELECT @v_dSql += '			    , E.CATEGORY_ID, E.CATEGORY_ORDER'+char(10)
	SELECT @v_dSql += '			    , ''DATA'' AS DATA_TYPE'+char(10)
	SELECT @v_dSql += '			    , A.CALC_TYPE'+char(10)
	--SELECT @v_dSql += '			    , A.PROD_SEQ, A.VERSION'+char(10)
	SELECT @v_dSql += '			    , A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PROD_SEQ, A.PLM_EC_NO'+char(10)
	SELECT @v_dSql += '		FROM ('+char(10)
	SELECT @v_dSql += '              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
	SELECT @v_dSql += '					, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID'+char(10)
	SELECT @v_dSql += '					, A.PLAN_DATE, A.TOP_ITEM_ID, A.ITEM_ID'+char(10)
	SELECT @v_dSql += '					, A.PRODUCTION_TYPE, A.MARKET, A.PLAN_TYPE '+char(10)
	SELECT @v_dSql += '					, ROUND(ISNULL(A.ADJUST_RESULT_IN_QTY_BATCH,0),2) - ROUND(ISNULL(A.ADJUST_IN_QTY_BATCH,0),2)  AS GAP_IN_QTY_BATCH'+char(10)
	SELECT @v_dSql += '					, CEILING(ISNULL(A.ADJUST_RESULT_IN_QTY_M,0))      - CEILING(ISNULL(A.ADJUST_IN_QTY_M,0))      AS GAP_IN_QTY_M'+char(10)
	SELECT @v_dSql += '					, CEILING(ISNULL(A.ADJUST_RESULT_IN_QTY_CELL,0))   - CEILING(ISNULL(A.ADJUST_IN_QTY_CELL,0))   AS GAP_IN_QTY_CELL'+char(10)
	SELECT @v_dSql += '					, CEILING(ISNULL(A.ADJUST_RESULT_IN_QTY_JR,0))     - CEILING(ISNULL(A.ADJUST_IN_QTY_JR,0))     AS GAP_IN_QTY_JR'+char(10)
	SELECT @v_dSql += '					, ROUND(ISNULL(A.ADJUST_RESULT_OUT_QTY_BATCH,0),2) - ROUND(ISNULL(A.ADJUST_OUT_QTY_BATCH,0),2) AS GAP_OUT_QTY_BATCH'+char(10)
	SELECT @v_dSql += '					, CEILING(ISNULL(A.ADJUST_RESULT_OUT_QTY_M,0))     - CEILING(ISNULL(A.ADJUST_OUT_QTY_M,0))     AS GAP_OUT_QTY_M'+char(10)
	SELECT @v_dSql += '					, CEILING(ISNULL(A.ADJUST_RESULT_OUT_QTY_CELL,0))  - CEILING(ISNULL(A.ADJUST_OUT_QTY_CELL,0))  AS GAP_OUT_QTY_CELL'+char(10)
	SELECT @v_dSql += '					, CEILING(ISNULL(A.ADJUST_RESULT_OUT_QTY_JR,0))    - CEILING(ISNULL(A.ADJUST_OUT_QTY_JR,0))    AS GAP_OUT_QTY_JR'+char(10)
	SELECT @v_dSql += '					, A.TOTAL_BATCH, A.SEQ, A.BGCOLOR'+char(10)
	SELECT @v_dSql += '					, ISNULL(X.CALC_TYPE, dbo.FN_GET_CONV_CALC(' + @v_instance_id + ', A.PLANT_ID, A.FACTORY_ID, A.LINE_ID, '''', A.ITEM_ID, A.PRODUCTION_TYPE, NULL, ''CALC_TYPE'')) AS CALC_TYPE'+char(10)
	--SELECT @v_dSql += '					, X.PROD_SEQ, X.VERSION'+char(10)
	SELECT @v_dSql += '					, A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PROD_SEQ, A.PLM_EC_NO '+char(10)
	SELECT @v_dSql += '			FROM ('+char(10)
	SELECT @v_dSql += ' SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
	SELECT @v_dSql += '      , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID'+char(10)
	SELECT @v_dSql += '      , A.PLAN_DATE, A.ITEM_ID AS TOP_ITEM_ID, A.ITEM_ID'+char(10)
	SELECT @v_dSql += '      , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE, A.MARKET, A.PLAN_TYPE'+char(10)
	SELECT @v_dSql += '      , A.BATCH_IN_QTY AS ADJUST_IN_QTY_BATCH, A.PLAN_IN_QTY AS ADJUST_IN_QTY, A.ROLL_IN_QTY AS ADJUST_IN_QTY_M, A.CELL_IN_QTY AS ADJUST_IN_QTY_CELL, A.JR_IN_QTY AS ADJUST_IN_QTY_JR'+char(10)
	SELECT @v_dSql += '      , A.BATCH_OUT_QTY AS ADJUST_OUT_QTY_BATCH, A.PLAN_QTY AS ADJUST_OUT_QTY, A.ROLL_OUT_QTY AS ADJUST_OUT_QTY_M, A.CELL_OUT_QTY AS ADJUST_OUT_QTY_CELL, A.JR_OUT_QTY AS ADJUST_OUT_QTY_JR'+char(10)
	SELECT @v_dSql += '      , 0 AS ADJUST_RESULT_IN_QTY_BATCH,  0 AS ADJUST_RESULT_IN_QTY_M, 0 AS ADJUST_RESULT_IN_QTY_CELL, 0 AS ADJUST_RESULT_IN_QTY_JR'+char(10)
	SELECT @v_dSql += '      , 0 AS ADJUST_RESULT_OUT_QTY_BATCH, 0 AS ADJUST_RESULT_OUT_QTY_M, 0 AS ADJUST_RESULT_OUT_QTY_CELL, 0 AS ADJUST_RESULT_OUT_QTY_JR'+char(10)
	SELECT @v_dSql += '      , A.TOTAL_BATCH'+char(10)
	SELECT @v_dSql += '      , A.SEQ'+char(10)
	SELECT @v_dSql += '      , B.SETUP_COLOR AS BGCOLOR'+char(10)
	SELECT @v_dSql += '      , A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PROD_SEQ, A.PLM_EC_NO '+char(10)
	SELECT @v_dSql += 'FROM  #TblFP00614_FIND_FP00614 A WITH(NOLOCK)'+char(10)
	SELECT @v_dSql += 'LEFT OUTER JOIN ('+char(10)
	SELECT @v_dSql += '    SELECT A.SEGMENT1 AS INSTANCE_ID, A.SEGMENT2 AS SETUP_COLOR_CODE, A.SEGMENT3 AS SETUP_COLOR_NAME, A.SEGMENT4 AS SETUP_COLOR, A.SORT_ORDER'+char(10)
	SELECT @v_dSql += '    FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)'+char(10)
	SELECT @v_dSql += '    WHERE  A.LOOKUP_TYPE_CODE = ''UI_AMEND_COLOR'''+char(10)
	SELECT @v_dSql += '    AND    A.SEGMENT1 =' + @v_instance_id +char(10)
	SELECT @v_dSql += '    AND    A.ACTIVE_FLAG = ''Y'''+char(10)
	SELECT @v_dSql += ') B'+char(10)
	SELECT @v_dSql += 'ON    A.SETUP_COLOR_CODE = B.SETUP_COLOR_CODE'+char(10)
	SELECT @v_dSql += 'WHERE  1=1'+char(10)
	SELECT @v_dSql += 'AND    A.PLAN_TYPE = ''RELEASE'''+char(10)
	--SELECT @v_dSql += 'AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN ' +  @v_bucket_from + ' AND ' +  @v_bucket_to + char(10)

	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.DIVISION_ID' , 'EQ', @p_division_id))        + char(10)
	IF(LEN(@p_site_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.SITE_ID' , 'EQ', @p_site_id))        + char(10)
	END
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.PLANT_ID' , 'EQ', @p_plant_id))              + char(10)

	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.FACTORY_ID' , 'EQ', @p_factory_id))          + char(10) 

	IF(LEN(@p_operation_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.OPERATION_ID' , 'EQ', @p_operation_id))      + char(10)
	END


	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.LINE_ID' , 'EQ', @p_line_id))                + char(10)



	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type))   + char(10)

	IF(LEN(@p_top_item_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.TOP_ITEM_ID' , 'LK', @p_top_item_id))                + char(10)
	END
	IF(LEN(@p_item_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.ITEM_ID' , 'LK', @p_item_id))                + char(10)
	END

	--IF(LEN(@p_prod_type) > 0)
	--BEGIN
	--	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.FP_PRODUCTION_TYPE' , 'LK', @p_prod_type))                + char(10)
	--END

	SELECT @v_dSql += ' AND 	( ISNULL(A.TOTAL_BATCH,0) + ISNULL(A.BATCH_IN_QTY,0) + ISNULL(A.PLAN_IN_QTY,0) + ISNULL(A.ROLL_IN_QTY,0) + ISNULL(A.CELL_IN_QTY,0) + ISNULL(A.JR_IN_QTY,0) + ISNULL(A.BATCH_OUT_QTY,0) + ISNULL(A.PLAN_QTY,0) + ISNULL(A.ROLL_OUT_QTY,0) + ISNULL(A.CELL_OUT_QTY,0) + ISNULL(A.JR_OUT_QTY,0) ) > 0   '+char(10)          
	SELECT @v_dSql += ' 				UNION ALL'+char(10)
	SELECT @v_dSql += '         SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
	SELECT @v_dSql += '         , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID'+char(10)
	SELECT @v_dSql += '         , A.PLAN_DATE, A.TOP_ITEM_ID, A.ITEM_ID'+char(10)
	SELECT @v_dSql += '         , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE, A.MARKET, ''RESULT'' AS PLAN_TYPE'+char(10)
	SELECT @v_dSql += '         , 0 AS ADJUST_IN_QTY_BATCH, 0 AS ADJUST_IN_QTY, 0 AS ADJUST_IN_QTY_M, 0 AS ADJUST_IN_QTY_CELL, 0 AS ADJUST_IN_QTY_JR'+char(10)
	SELECT @v_dSql += '         , 0 AS ADJUST_OUT_QTY_BATCH, 0 AS ADJUST_OUT_QTY, 0 AS ADJUST_OUT_QTY_M, 0 AS ADJUST_OUT_QTY_CELL, 0 AS ADJUST_OUT_QTY_JR'+char(10)
	SELECT @v_dSql += '         , A.BATCH_IN_QTY AS ADJUST_RESULT_IN_QTY_BATCH, A.ROLL_IN_QTY AS ADJUST_RESULT_IN_QTY_M, A.CELL_IN_QTY AS ADJUST_RESULT_IN_QTY_CELL, A.JR_IN_QTY AS ADJUST_RESULT_IN_QTY_JR '+char(10)
	SELECT @v_dSql += '         , A.BATCH_OUT_QTY AS ADJUST_RESULT_OUT_QTY_BATCH, A.ROLL_OUT_QTY AS ADJUST_RESULT_OUT_QTY_M, A.CELL_OUT_QTY AS ADJUST_RESULT_OUT_QTY_CELL, A.JR_OUT_QTY AS ADJUST_RESULT_OUT_QTY_JR '+char(10)
	SELECT @v_dSql += '         , 0 AS TOTAL_BATCH'+char(10)
	SELECT @v_dSql += '         , NULL AS SEQ'+char(10)
	SELECT @v_dSql += '         , NULL AS BGCOLOR'+char(10)
	SELECT @v_dSql += '         , A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PROD_SEQ, A.PLM_EC_NO '+char(10)
	SELECT @v_dSql += ' FROM   SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK)'+char(10)
	SELECT @v_dSql += ' WHERE  1=1'+char(10)
	SELECT @v_dSql += ' AND    A.PLAN_DATE BETWEEN CONVERT(DATE, ' +  @v_bucket_from + ') AND CONVERT(DATE, ' +  @v_bucket_to + ') ' + char(10)
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.DIVISION_ID' , 'EQ', @p_division_id))        + char(10)
	IF(LEN(@p_site_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.SITE_ID' , 'EQ', @p_site_id))        + char(10)
	END
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.PLANT_ID' , 'EQ', @p_plant_id))              + char(10)

	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.FACTORY_ID' , 'EQ', @p_factory_id))          + char(10) 

	IF(LEN(@p_operation_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.OPERATION_ID' , 'EQ', @p_operation_id))      + char(10)
	END


	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.LINE_ID' , 'EQ', @p_line_id))                + char(10)



	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type))   + char(10)

	IF(LEN(@p_top_item_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.TOP_ITEM_ID' , 'LK', @p_top_item_id))                + char(10)
	END
	IF(LEN(@p_item_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.ITEM_ID' , 'LK', @p_item_id))                + char(10)
	END

	--IF(LEN(@p_prod_type) > 0)
	--BEGIN
	--	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.FP_PRODUCTION_TYPE' , 'LK', @p_prod_type))                + char(10)
	--END

	SELECT @v_dSql += ' AND	   A.BATCH_IN_QTY > 0'+char(10)
	SELECT @v_dSql += ' ) A'+char(10)
	SELECT @v_dSql += '	LEFT OUTER HASH JOIN ('+char(10)
	SELECT @v_dSql += '			SELECT B.*'+char(10)
	SELECT @v_dSql += '				 , MIN(B.IDX) OVER (PARTITION BY B.INSTANCE_ID, B.PRODUCTION_TYPE, A.LINE_ID, A.ITEM_ID ) AS MIN_IDX'+char(10)
	SELECT @v_dSql += '				 , A.*'+char(10)
	SELECT @v_dSql += '			FROM ('+char(10)
	SELECT @v_dSql += '					SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID AS CALC_PLANT_ID, A.FACTORY_ID, B.LINE_ID, A.ITEM_ID, B.ELECTRODE_TYPE, A.VERSION_TYPE AS CALC_TYPE, A.VERSION	'+char(10)
	SELECT @v_dSql += '											-- , A.PROD_SEQ  -- 중복 데이타가 생성되어 제외함 20230502 by cys	'+char(10)
	SELECT @v_dSql += '						 , DENSE_RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION, A.ITEM_ID, A.PROD_VERSION_TYPE, A.VERSION_TYPE'+char(10)
	SELECT @v_dSql += '											  ORDER BY A.APPLY_DATE DESC, (CASE WHEN A.VERSION LIKE ''Z%'' THEN REPLACE( A.VERSION, ''Z'', ''/'') ELSE A.VERSION END) DESC '+char(10)
	SELECT @v_dSql += '											         , (CASE WHEN A.MODEL_ID = C.APPLIED_MODEL THEN 1 ELSE 2 END) ) AS SEQ '+char(10)
	SELECT @v_dSql += '					FROM   SCM_ITEM_CONV_CALC_M A WITH(NOLOCK), SCM_LINE_M B WITH(NOLOCK), SCM_ITEM_M C WITH(NOLOCK)'+char(10)
	SELECT @v_dSql += '					WHERE  1=1'+char(10)
	SELECT @v_dSql += '					AND    A.OPERATION    = ''E2000'''+char(10)
	SELECT @v_dSql += '					AND    A.MAX_VER_FLAG = ''Y'''+char(10)
	SELECT @v_dSql += '					AND    A.COMPANY_ID   = B.COMPANY_ID'+char(10)
	SELECT @v_dSql += '					AND    A.DIVISION_ID  = B.DIVISION_ID'+char(10)
	SELECT @v_dSql += '					AND    A.SITE_ID      = B.SITE_ID'+char(10)
	SELECT @v_dSql += '					AND    A.PLANT_ID     = B.PLANT_ID'+char(10)
	SELECT @v_dSql += '					AND    A.FACTORY_ID   = B.FACTORY_ID'+char(10)
	SELECT @v_dSql += '					AND    A.OPERATION    = B.OPERATION_ID'+char(10)
	SELECT @v_dSql += '					AND    A.PROD_VERSION_TYPE = ISNULL(B.PROD_VERSION_TYPE, ''GENERAL'')'+char(10)
	SELECT @v_dSql += '                 AND    A.COMPANY_ID   = C.COMPANY_ID'+char(10)
	SELECT @v_dSql += '                 AND    A.DIVISION_ID  = C.DIVISION_ID'+char(10)
	SELECT @v_dSql += '                 AND    A.SITE_ID      = C.SITE_ID'+char(10)
	SELECT @v_dSql += '                 AND    A.ITEM_ID      = C.ITEM_ID'+char(10)
	SELECT @v_dSql += '					AND    B.ACTIVE_FLAG = ''Y'''+char(10)

	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.FACTORY_ID' , 'EQ', @p_factory_id))          + char(10) 

	SELECT @v_dSql += '            ) A'+char(10)
	SELECT @v_dSql += '			, ('+char(10)
	SELECT @v_dSql += '					SELECT SEGMENT1 AS INSTANCE_ID, SEGMENT2 AS PLANT_ID, SEGMENT3 AS PRODUCTION_TYPE,  VERSION_TYPE'+char(10)
	SELECT @v_dSql += '						   , RANK() OVER (PARTITION BY SEGMENT1, SEGMENT3 ORDER BY GUBUN) AS IDX'+char(10)
	SELECT @v_dSql += '					FROM ('+char(10)
	SELECT @v_dSql += '							SELECT *'+char(10)
	SELECT @v_dSql += '							FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)'+char(10)
	SELECT @v_dSql += '							WHERE  1=1'+char(10)
	SELECT @v_dSql += '							AND	   LOOKUP_TYPE_CODE	= ''INSTANCE_CONV_PRIORITY'''+char(10)
	SELECT @v_dSql += '							AND	   SEGMENT1         =' +  @v_instance_id +char(10)
	SELECT @v_dSql += '							AND    ACTIVE_FLAG      = ''Y'''+char(10)
	SELECT @v_dSql += '					) A'+char(10)
	SELECT @v_dSql += '					UNPIVOT(VERSION_TYPE FOR GUBUN IN (ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5) ) AS VERSION_TYPE'+char(10)
	SELECT @v_dSql += '			) B'+char(10)
	SELECT @v_dSql += '			WHERE 1=1'+char(10)
	SELECT @v_dSql += '			AND   A.CALC_PLANT_ID	= B.PLANT_ID'+char(10)
	SELECT @v_dSql += '			AND   A.CALC_TYPE		= B.VERSION_TYPE'+char(10)
	SELECT @v_dSql += '			AND   A.SEQ = 1'+char(10)
	SELECT @v_dSql += '	) X'+char(10)
	SELECT @v_dSql += '	ON    1=1'+char(10)
	SELECT @v_dSql += '	AND   X.MIN_IDX         = X.IDX'+char(10)
	SELECT @v_dSql += '	AND   A.SITE_ID         = X.SITE_ID'+char(10)
	SELECT @v_dSql += '	AND   A.PLANT_ID        = X.PLANT_ID'+char(10)
	SELECT @v_dSql += '	AND   A.FACTORY_ID      = X.FACTORY_ID'+char(10)
	SELECT @v_dSql += '	AND   A.LINE_ID         = X.LINE_ID'+char(10)
	SELECT @v_dSql += '	AND   A.ITEM_ID         = X.ITEM_ID'+char(10)
	SELECT @v_dSql += '	AND   A.ELECTRODE_TYPE  = X.ELECTRODE_TYPE'+char(10)
	SELECT @v_dSql += '	AND   A.PRODUCTION_TYPE = X.PRODUCTION_TYPE'+char(10)

	IF(ISNULL(@p_confirm_area,'') = 'BUILDING') --factory 단위
	BEGIN
		SELECT @v_dSql += 'INNER JOIN ('+char(10)
		SELECT @v_dSql += '            								SELECT A.FACTORY_ID, CONVERT(DATETIME,A.INSTANCE_DATE) AS INSTANCE_DATE'+char(10)
		SELECT @v_dSql += '            								FROM ('+char(10)
		SELECT @v_dSql += '            									SELECT A.INSTANCE_ID, A.INSTANCE_DATE, A.FACTORY_ID, A.RELEASE_PLAN_ID, A.INSERT_TIME'+char(10)
		SELECT @v_dSql += '            										 , ROW_NUMBER() OVER (PARTITION BY A.FACTORY_ID ORDER BY A.INSERT_TIME DESC) AS ROW_NUM'+char(10)
		SELECT @v_dSql += '            									FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)'+char(10)
		SELECT @v_dSql += '            									WHERE  A.INSTANCE_ID = '+ @v_instance_id + +char(10)
		SELECT @v_dSql += '            									AND    A.FACTORY_ID IN ('+char(10)
		SELECT @v_dSql += '              										SELECT DISTINCT B.FACTORY_ID'+char(10)
		SELECT @v_dSql += '              										FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK)'+char(10)
		SELECT @v_dSql += '              										INNER JOIN SCM_FACTORY_M B WITH(NOLOCK)'+char(10)
		SELECT @v_dSql += '              										ON    A.FACTORY_ID  = B.FACTORY_ID'+char(10)
		SELECT @v_dSql += '              										AND   A.ACTIVE_FLAG = ''Y'''+char(10)
		SELECT @v_dSql += '              										AND   B.ACTIVE_FLAG = ''Y'''+char(10)
		SELECT @v_dSql += '              										AND   A.INSTANCE_ID = ' + @v_instance_id +char(10)
		SELECT @v_dSql += '            									)'+char(10)
		SELECT @v_dSql += '            								) A'+char(10)
		SELECT @v_dSql += '            								WHERE A.ROW_NUM = 1'+char(10)
		SELECT @v_dSql += '            							) B'+char(10)
		SELECT @v_dSql += '            							ON    A.FACTORY_ID = B.FACTORY_ID'+char(10)
		SELECT @v_dSql += '            							WHERE A.PLAN_DATE >= B.INSTANCE_DATE'+char(10)
	END
	ELSE
	BEGIN
		SELECT @v_dSql += ' INNER JOIN SCM_LINE_M C WITH(NOLOCK)'+char(10)
		SELECT @v_dSql += '                          ON  A.COMPANY_ID     = C.COMPANY_ID'+char(10)
		SELECT @v_dSql += '                          AND A.DIVISION_ID    = C.DIVISION_ID'+char(10)
		SELECT @v_dSql += '                          AND A.SITE_ID        = C.SITE_ID'+char(10)
		SELECT @v_dSql += '                          AND A.PLANT_ID       = C.PLANT_ID'+char(10)
		SELECT @v_dSql += '                          AND A.FACTORY_ID     = C.FACTORY_ID'+char(10)
		SELECT @v_dSql += '                          AND A.OPERATION_ID   = C.OPERATION_ID'+char(10)
		SELECT @v_dSql += '                          AND A.LINE_ID        = C.LINE_ID'+char(10)
		SELECT @v_dSql += '                          AND A.ELECTRODE_TYPE = C.ELECTRODE_TYPE'+char(10)
		SELECT @v_dSql += '                          INNER JOIN ('+char(10)
		SELECT @v_dSql += '                          	SELECT A.PLAN_GROUP_ID, A.INSTANCE_DATE'+char(10)
		SELECT @v_dSql += '                          	FROM ('+char(10)
		SELECT @v_dSql += '                          		SELECT A.INSTANCE_ID, A.INSTANCE_DATE, A.PLAN_GROUP_ID, A.RELEASE_PLAN_ID, A.INSERT_TIME'+char(10)
		SELECT @v_dSql += '                          			 , ROW_NUMBER() OVER (PARTITION BY A.PLAN_GROUP_ID ORDER BY A.INSERT_TIME DESC) AS ROW_NUM'+char(10)
		SELECT @v_dSql += '                          		FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)'+char(10)
		SELECT @v_dSql += '                          		WHERE  A.INSTANCE_ID = '+ @v_instance_id +char(10)
		SELECT @v_dSql += '                          		AND    A.PLAN_GROUP_ID IN ('+char(10)
		SELECT @v_dSql += '                          				SELECT DISTINCT A.SEGMENT2 AS PLAN_GROUP_ID'+char(10)
		SELECT @v_dSql += '                          				FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)'+char(10)
		SELECT @v_dSql += '                          				WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP'''+char(10)
		SELECT @v_dSql += '                          				AND    A.ACTIVE_FLAG = ''Y'''+char(10)
		SELECT @v_dSql += '                          				AND    A.SEGMENT1 = '+ @v_instance_id +char(10)
		SELECT @v_dSql += '                          		)'+char(10)
		SELECT @v_dSql += '                          	) A'+char(10)
		SELECT @v_dSql += '                          	WHERE A.ROW_NUM = 1'+char(10)
		SELECT @v_dSql += '                          ) B'+char(10)
		SELECT @v_dSql += '                          ON    C.MODEL_TYPE = B.PLAN_GROUP_ID'+char(10)
		SELECT @v_dSql += '                          WHERE A.PLAN_DATE >= B.INSTANCE_DATE'+char(10)
	END

	SELECT @v_dSql += ' 		) A'+char(10)
	SELECT @v_dSql += ' INNER JOIN SCM_ITEM_M B WITH(NOLOCK)'+char(10)
	SELECT @v_dSql += ' ON     A.COMPANY_ID     = B.COMPANY_ID'+char(10)
	SELECT @v_dSql += ' AND    A.DIVISION_ID    = B.DIVISION_ID'+char(10)
	SELECT @v_dSql += ' AND    A.SITE_ID        = B.SITE_ID'+char(10)
	SELECT @v_dSql += ' AND    A.TOP_ITEM_ID    = B.ITEM_ID'+char(10)



	IF(LEN(@p_nick_name) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('               ISNULL(B.NICK_NAME,''-'')' , 'LK', @p_nick_name))        + char(10)
	END
	IF(LEN(@p_nick_name_lt) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('       ISNULL(B.NICK_NAME,''-'')' , 'LK', @p_nick_name_lt))        + char(10)
	END


	SELECT @v_dSql += ' INNER JOIN SCM_LINE_M C WITH(NOLOCK)'+ char(10)
	SELECT @v_dSql += ' ON     A.COMPANY_ID     = C.COMPANY_ID'+ char(10)
	SELECT @v_dSql += ' AND    A.DIVISION_ID    = C.DIVISION_ID'+ char(10)
	SELECT @v_dSql += ' AND    A.SITE_ID        = C.SITE_ID'+ char(10)
	SELECT @v_dSql += ' AND    A.PLANT_ID       = C.PLANT_ID'+ char(10)
	SELECT @v_dSql += ' AND    A.FACTORY_ID     = C.FACTORY_ID'+ char(10)
	SELECT @v_dSql += ' AND    A.OPERATION_ID   = C.OPERATION_ID'+ char(10)
	SELECT @v_dSql += ' AND    A.LINE_ID        = C.LINE_ID'+ char(10)
	SELECT @v_dSql += ' AND    A.ELECTRODE_TYPE = C.ELECTRODE_TYPE'+ char(10)
	SELECT @v_dSql += ' INNER JOIN SCM_OPERATION_M D WITH(NOLOCK)'+ char(10)
	SELECT @v_dSql += ' ON     A.COMPANY_ID     = D.COMPANY_ID'+ char(10)
	SELECT @v_dSql += ' AND    A.DIVISION_ID    = D.DIVISION_ID'+ char(10)
	SELECT @v_dSql += ' AND    A.SITE_ID        = D.SITE_ID'+ char(10)
	SELECT @v_dSql += ' AND    A.OPERATION_ID   = D.OPERATION_ID'+ char(10)
	SELECT @v_dSql += ' 			INNER JOIN ('+ char(10)
	SELECT @v_dSql += ' 				SELECT * '+ char(10)
	SELECT @v_dSql += ' 				FROM ('+ char(10)

	------------
	IF(LEN(@p_cate_info) > 0)            
	BEGIN
		SELECT @v_sub_delimiter = '|'
		SELECT @max_loop_cnt = 0
		SELECT @mst_loop_cnt = 0
		SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_cate_info, @v_sub_delimiter) -- 프로시저 LOOP 길이를 판단

		WHILE @mst_loop_cnt < @max_loop_cnt
		BEGIN
			SELECT @mst_loop_cnt    = @mst_loop_cnt + 1
			SELECT @v_cate_info     = [dbo].[SCM_ARR_SPL_VAL](@p_cate_info ,@v_sub_delimiter, @mst_loop_cnt)
			SELECT @v_cate_value    = [dbo].[SCM_ARR_SPL_VAL](@p_cate_value ,@v_sub_delimiter, @mst_loop_cnt)

			IF( @v_cate_info = 'chk_gap_in'      AND @v_cate_value = 'TRUE' )  
				SELECT @bGapIn = 'Y'
			IF( @v_cate_info = 'chk_gap_out'     AND @v_cate_value = 'TRUE' ) 
				SELECT @bGapOut = 'Y'     
			IF( @v_cate_info = 'chk_pc'      AND @v_cate_value = 'TRUE' )  
				SELECT @bPc = 'Y'
			IF( @v_cate_info = 'chk_jr'     AND @v_cate_value = 'TRUE' ) 
				SELECT @bJr = 'Y'
			IF( @v_cate_info = 'chk_cell'      AND @v_cate_value = 'TRUE' )  
				SELECT @bCell = 'Y'
			IF( @v_cate_info = 'chk_batch'     AND @v_cate_value = 'TRUE' ) 
				SELECT @bBatch = 'Y'
		END  

		SELECT @v_dSql += 'SELECT ''X'' AS CATEGORY_ID, '''' AS MEASURE_NAME, '''' AS CATEGORY_NAME, 0 AS CATEGORY_ORDER' + char(10)
		IF( @bGapIn = 'Y' AND @bPc = 'Y' ) 
		BEGIN
			SELECT @v_dSql += 'UNION ALL' + char(10)
			SELECT @v_dSql += 'SELECT ''GAP_IN_M'' AS CATEGORY_ID, ''M(P/C)'' AS MEASURE_NAME, ''Accu. Gap (In)'' AS CATEGORY_NAME, 383 AS CATEGORY_ORDER' + char(10)
		END
		IF( @bGapIn = 'Y' AND @bJr = 'Y' ) 
		BEGIN
			SELECT @v_dSql += 'UNION ALL' + char(10)
			SELECT @v_dSql += 'SELECT ''GAP_IN_JR'' AS CATEGORY_ID, ''J/R'' AS MEASURE_NAME, ''Accu. Gap (In)'' AS CATEGORY_NAME, 382 AS CATEGORY_ORDER' + char(10)
		END
		IF( @bGapIn = 'Y' AND @bCell = 'Y' ) 
		BEGIN
			SELECT @v_dSql += 'UNION ALL' + char(10)
			SELECT @v_dSql += 'SELECT ''GAP_IN_CELL'' AS CATEGORY_ID, ''Cell'' AS MEASURE_NAME, ''Accu. Gap (In)'' AS CATEGORY_NAME, 384 AS CATEGORY_ORDER' + char(10)
		END
		IF( @bGapIn = 'Y' AND @bBatch = 'Y' ) 
		BEGIN
			SELECT @v_dSql += 'UNION ALL' + char(10)
			SELECT @v_dSql += 'SELECT ''GAP_IN_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''Accu. Gap (In)'' AS CATEGORY_NAME, 381 AS CATEGORY_ORDER' + char(10)
		END
		IF( @bGapOut = 'Y' AND @bPc = 'Y' ) 
		BEGIN
			SELECT @v_dSql += 'UNION ALL' + char(10)
			SELECT @v_dSql += 'SELECT ''GAP_OUT_M'' AS CATEGORY_ID, ''M(P/C)'' AS MEASURE_NAME, ''Accu. Gap (Out)'' AS CATEGORY_NAME, 387 AS CATEGORY_ORDER' + char(10)
		END
		IF( @bGapOut = 'Y' AND @bJr = 'Y' ) 
		BEGIN
			SELECT @v_dSql += 'UNION ALL' + char(10)
			SELECT @v_dSql += 'SELECT ''GAP_OUT_JR'' AS CATEGORY_ID, ''J/R'' AS MEASURE_NAME, ''Accu. Gap (Out)'' AS CATEGORY_NAME, 386 AS CATEGORY_ORDER' + char(10)
		END
		IF( @bGapOut = 'Y' AND @bCell = 'Y' ) 
		BEGIN
			SELECT @v_dSql += 'UNION ALL' + char(10)
			SELECT @v_dSql += 'SELECT ''GAP_OUT_CELL'' AS CATEGORY_ID, ''Cell'' AS MEASURE_NAME, ''Accu. Gap (Out)'' AS CATEGORY_NAME, 388 AS CATEGORY_ORDER' + char(10)
		END
		IF( @bGapOut = 'Y' AND @bBatch = 'Y' ) 
		BEGIN
			SELECT @v_dSql += 'UNION ALL' + char(10)
			SELECT @v_dSql += 'SELECT ''GAP_OUT_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''Accu. Gap (Out)'' AS CATEGORY_NAME, 385 AS CATEGORY_ORDER' + char(10)
		END
	END
	ELSE
	BEGIN
		SELECT @v_dSql += 'SELECT ''GAP_IN_M'' AS CATEGORY_ID, ''M(P/C)'' AS MEASURE_NAME, ''Accu. Gap (In)'' AS CATEGORY_NAME, 383 AS CATEGORY_ORDER' + char(10)
		SELECT @v_dSql += 'UNION ALL' + char(10)
		SELECT @v_dSql += 'SELECT ''GAP_IN_JR'' AS CATEGORY_ID, ''J/R'' AS MEASURE_NAME, ''Accu. Gap (In)'' AS CATEGORY_NAME, 382 AS CATEGORY_ORDER' + char(10)
		SELECT @v_dSql += 'UNION ALL' + char(10)
		SELECT @v_dSql += 'SELECT ''GAP_IN_CELL'' AS CATEGORY_ID, ''Cell'' AS MEASURE_NAME, ''Accu. Gap (In)'' AS CATEGORY_NAME, 384 AS CATEGORY_ORDER' + char(10)
		SELECT @v_dSql += 'UNION ALL' + char(10)
		SELECT @v_dSql += 'SELECT ''GAP_IN_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''Accu. Gap (In)'' AS CATEGORY_NAME, 381 AS CATEGORY_ORDER' + char(10)
		SELECT @v_dSql += 'UNION ALL' + char(10)
		SELECT @v_dSql += 'SELECT ''GAP_OUT_M'' AS CATEGORY_ID, ''M(P/C)'' AS MEASURE_NAME, ''Accu. Gap (Out)'' AS CATEGORY_NAME, 387 AS CATEGORY_ORDER' + char(10)
		SELECT @v_dSql += 'UNION ALL' + char(10)
		SELECT @v_dSql += 'SELECT ''GAP_OUT_JR'' AS CATEGORY_ID, ''J/R'' AS MEASURE_NAME, ''Accu. Gap (Out)'' AS CATEGORY_NAME, 386 AS CATEGORY_ORDER' + char(10)
		SELECT @v_dSql += 'UNION ALL' + char(10)
		SELECT @v_dSql += 'SELECT ''GAP_OUT_CELL'' AS CATEGORY_ID, ''Cell'' AS MEASURE_NAME, ''Accu. Gap (Out)'' AS CATEGORY_NAME, 388 AS CATEGORY_ORDER' + char(10)
		SELECT @v_dSql += 'UNION ALL' + char(10)
		SELECT @v_dSql += 'SELECT ''GAP_OUT_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''Accu. Gap (Out)'' AS CATEGORY_NAME, 385 AS CATEGORY_ORDER' + char(10)  
	END          
            
	SELECT @v_dSql += ' ) A' + char(10)
	SELECT @v_dSql += ' 	WHERE CATEGORY_ID <> ''X''' + char(10)
	SELECT @v_dSql += ' ) E' + char(10)
	SELECT @v_dSql += ' ON 1=1' + char(10)
        


	IF(ISNULL(@p_confirm_area,'') = 'BUILDING') --factory 단위
	BEGIN
		SELECT @v_dSql += 'INNER JOIN ('+char(10)
		SELECT @v_dSql += '            								SELECT A.FACTORY_ID, A.INSTANCE_DATE'+char(10)
		SELECT @v_dSql += '            								FROM ('+char(10)
		SELECT @v_dSql += '            									SELECT A.INSTANCE_ID, A.INSTANCE_DATE, A.FACTORY_ID, A.RELEASE_PLAN_ID, A.INSERT_TIME'+char(10)
		SELECT @v_dSql += '            									, ROW_NUMBER() OVER (PARTITION BY A.FACTORY_ID ORDER BY A.INSERT_TIME DESC) AS ROW_NUM'+char(10)
		SELECT @v_dSql += '            									FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)'+char(10)
		SELECT @v_dSql += '            									WHERE  A.INSTANCE_ID = '+ @v_instance_id + +char(10)
		SELECT @v_dSql += '            									AND    A.FACTORY_ID IN ('+char(10)
		SELECT @v_dSql += '              										SELECT DISTINCT B.FACTORY_ID'+char(10)
		SELECT @v_dSql += '              										FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK)'+char(10)
		SELECT @v_dSql += '              										INNER JOIN SCM_FACTORY_M B WITH(NOLOCK)'+char(10)
		SELECT @v_dSql += '              										ON    A.FACTORY_ID  = B.FACTORY_ID'+char(10)
		SELECT @v_dSql += '              										AND   A.ACTIVE_FLAG = ''Y'''+char(10)
		SELECT @v_dSql += '              										AND   B.ACTIVE_FLAG = ''Y'''+char(10)
		SELECT @v_dSql += '              										AND   A.INSTANCE_ID = ' + @v_instance_id +char(10)
		SELECT @v_dSql += '            									)'+char(10)
		SELECT @v_dSql += '            								) A'+char(10)  
		SELECT @v_dSql += '                        WHERE A.ROW_NUM = 1'+char(10)
		SELECT @v_dSql += '                    ) F'+char(10)
		SELECT @v_dSql += '                    ON    A.FACTORY_ID = F.FACTORY_ID'+char(10)
	END
	ELSE
	BEGIN
		SELECT @v_dSql += '                          INNER JOIN ('+char(10)
		SELECT @v_dSql += '                          	SELECT A.PLAN_GROUP_ID, A.INSTANCE_DATE'+char(10)
		SELECT @v_dSql += '                          	FROM ('+char(10)
		SELECT @v_dSql += '                          		SELECT A.INSTANCE_ID, A.INSTANCE_DATE, A.PLAN_GROUP_ID, A.RELEASE_PLAN_ID, A.INSERT_TIME'+char(10)
		SELECT @v_dSql += '                          			 , ROW_NUMBER() OVER (PARTITION BY A.PLAN_GROUP_ID ORDER BY A.INSERT_TIME DESC) AS ROW_NUM'+char(10)
		SELECT @v_dSql += '                          		FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)'+char(10)
		SELECT @v_dSql += '                          		WHERE  A.INSTANCE_ID = ' + @v_instance_id + char(10)
		SELECT @v_dSql += '                          		AND    A.PLAN_GROUP_ID IN ('+char(10)
		SELECT @v_dSql += '                          				SELECT DISTINCT A.SEGMENT2 AS PLAN_GROUP_ID'+char(10)
		SELECT @v_dSql += '                          				FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)'+char(10)
		SELECT @v_dSql += '                          				WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP'''+char(10)
		SELECT @v_dSql += '                          				AND    A.ACTIVE_FLAG = ''Y'''+char(10)
		SELECT @v_dSql += '                          				AND    A.SEGMENT1 = ' + @v_instance_id +char(10)
		SELECT @v_dSql += '                          		)'+char(10)
		SELECT @v_dSql += '                          	) A'+char(10)
		SELECT @v_dSql += '                          	WHERE A.ROW_NUM = 1'+char(10)
		SELECT @v_dSql += '                          ) F'+char(10)
		SELECT @v_dSql += '                          ON    C.MODEL_TYPE = F.PLAN_GROUP_ID'+char(10)
	END

	SELECT @v_dSql += ' 		WHERE 1=1'+char(10)
	SELECT @v_dSql += ' 		GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
	SELECT @v_dSql += ' 			   , A.LOCATION, A.OPERATION_ID, D.OPERATION_NAME'+char(10)
	SELECT @v_dSql += ' 			   , A.LINE_ID, ISNULL(C.LINE_NAME,''-''), A.ELECTRODE_TYPE, A.EQUIPMENT_ID'+char(10)
	SELECT @v_dSql += ' 			   , A.ITEM_ID, A.TOP_ITEM_ID, ISNULL(B.NICK_NAME,''-'')'+char(10)
	SELECT @v_dSql += ' 			   , A.PRODUCTION_TYPE, A.MARKET, C.PROD_VERSION_TYPE'+char(10)
	SELECT @v_dSql += ' 			   , E.CATEGORY_NAME, E.MEASURE_NAME'+char(10)
	SELECT @v_dSql += ' 			   , E.CATEGORY_ID, E.CATEGORY_ORDER'+char(10)
	SELECT @v_dSql += ' 			   , A.CALC_TYPE'+char(10)
	--SELECT @v_dSql += ' 			   , A.PROD_SEQ, A.VERSION'+char(10)
	SELECT @v_dSql += ' 			   , A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PROD_SEQ, A.PLM_EC_NO '+char(10)
	SELECT @v_dSql += ' ) A'+char(10)
	SELECT @v_dSql += ' LEFT OUTER HASH JOIN ('+char(10)
	SELECT @v_dSql += '	 				SELECT * FROM   #SCM_PANCAKE_MATERIAL_V A	' + char(10)
	SELECT @v_dSql += '  	) E'+char(10)
	SELECT @v_dSql += '  	ON  A.COMPANY_ID      = E.COMPANY_ID'+char(10)
	SELECT @v_dSql += '      AND A.DIVISION_ID     = E.DIVISION_ID'+char(10)
	SELECT @v_dSql += '      AND A.SITE_ID         = E.SITE_ID'+char(10)
	SELECT @v_dSql += '      AND A.PLANT_ID        = E.PLANT_ID'+char(10)
	SELECT @v_dSql += '      AND A.FACTORY_ID      = E.FACTORY_ID'+char(10)
	SELECT @v_dSql += '      AND A.ITEM_ID         = E.PC_ITEM_ID'+char(10)
	SELECT @v_dSql += '      AND A.WORK_REQUEST_MODEL_ID = E.MODEL_ID'+char(10)
	SELECT @v_dSql += '      AND A.VERSION               = E.PROD_VERSION'+char(10)
	SELECT @v_dSql += '      AND A.PROD_SEQ              = E.PROD_SEQ'+char(10)
	/*
	SELECT @v_dSql += '      AND A.PROD_VERSION_TYPE = E.PROD_VERSION_TYPE'+char(10)
	SELECT @v_dSql += '      AND A.CALC_TYPE       = E.PROD_TYPE'+char(10)
	SELECT @v_dSql += '  	LEFT OUTER HASH JOIN ('+char(10)
	SELECT @v_dSql += '	 				SELECT * FROM   #SCM_PANCAKE_MATERIAL_V A	' + char(10)
	SELECT @v_dSql += '	) F'+char(10)
	SELECT @v_dSql += '	ON  A.COMPANY_ID      = F.COMPANY_ID'+char(10)
	SELECT @v_dSql += '	AND A.DIVISION_ID     = F.DIVISION_ID'+char(10)
	SELECT @v_dSql += '	AND A.SITE_ID         = F.SITE_ID'+char(10)
	SELECT @v_dSql += '	AND A.PLANT_ID        = F.PLANT_ID'+char(10)
	SELECT @v_dSql += '	AND A.FACTORY_ID      = F.FACTORY_ID'+char(10)
	SELECT @v_dSql += '	AND A.ITEM_ID         = F.PC_ITEM_ID'+char(10)
	SELECT @v_dSql += '	AND A.WORK_REQUEST_MODEL_ID = F.MODEL_ID'+char(10)
	SELECT @v_dSql += '	AND A.PROD_VERSION_TYPE = F.PROD_VERSION_TYPE'+char(10)
	SELECT @v_dSql += '	AND A.CALC_TYPE <> F.PROD_TYPE'+char(10)
	*/
	SELECT @v_dSql += '	LEFT OUTER JOIN ('+char(10)
	SELECT @v_dSql += '				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.ITEM_ID'+char(10)
	SELECT @v_dSql += '					 , MAX(CASE WHEN A.TACT_TIME > 0 THEN ROUND(60/A.TACT_TIME, 0) ELSE 0 END) DAILY_CAPA_PPM'+char(10)
	SELECT @v_dSql += '					 , MAX(CASE WHEN A.TACT_TIME > 0 THEN ROUND(60/(A.TACT_TIME*2), 0) ELSE 0 END) DAILY_CAPA_PPM2'+char(10)
	SELECT @v_dSql += '				FROM   SCM_TACT_TIME_M A WITH(NOLOCK)'+char(10)
	SELECT @v_dSql += '				WHERE  1=1'+char(10)

	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.DIVISION_ID' , 'EQ', @p_division_id))        + char(10)
	IF(LEN(@p_site_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.SITE_ID' , 'EQ', @p_site_id))        + char(10)
	END
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.PLANT_ID' , 'EQ', @p_plant_id))              + char(10)
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.FACTORY_ID' , 'EQ', @p_factory_id))          + char(10) 
	IF(LEN(@p_operation_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.OPERATION_ID' , 'EQ', @p_operation_id))      + char(10)
	END
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.LINE_ID' , 'EQ', @p_line_id))                + char(10)
	IF(LEN(@p_item_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.ITEM_ID' , 'LK', @p_item_id))                + char(10)
	END


	SELECT @v_dSql += ' AND    A.MONTH = SUBSTRING(' + @v_plan_date + ',1,6) ' + char(10)
	SELECT @v_dSql += '	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.ITEM_ID' + char(10)
	SELECT @v_dSql += '	) G' + char(10)
	SELECT @v_dSql += '	ON  A.COMPANY_ID      = G.COMPANY_ID' + char(10)
	SELECT @v_dSql += '	AND A.DIVISION_ID     = G.DIVISION_ID' + char(10)
	SELECT @v_dSql += '	AND A.SITE_ID         = G.SITE_ID' + char(10)
	SELECT @v_dSql += '	AND A.PLANT_ID        = G.PLANT_ID' + char(10)
	SELECT @v_dSql += '	AND A.FACTORY_ID      = G.FACTORY_ID' + char(10)
	SELECT @v_dSql += '	AND A.OPERATION_ID    = G.OPERATION_ID' + char(10)
	SELECT @v_dSql += '	AND A.LINE_ID         = G.LINE_ID' + char(10)
	SELECT @v_dSql += '	AND A.ELECTRODE_TYPE  = G.ELECTRODE_TYPE' + char(10)
	SELECT @v_dSql += '	AND A.ITEM_ID         = G.ITEM_ID' + char(10)
	-- foil 정보 수정... 20240329
	SELECT @v_dSql += '	LEFT OUTER JOIN #FOIL_INFO H WITH(NOLOCK) ' + char(10)
	SELECT @v_dSql += '	ON 1=1 ' + char(10)
	SELECT @v_dSql += '	AND A.COMPANY_ID            = H.COMPANY_ID ' + char(10)
	SELECT @v_dSql += '	AND A.DIVISION_ID           = H.DIVISION_ID ' + char(10)
	SELECT @v_dSql += '	AND A.SITE_ID               = H.SITE_ID ' + char(10)
	SELECT @v_dSql += '	AND A.PLANT_ID              = H.PLANT_ID ' + char(10)
	SELECT @v_dSql += '	AND A.FACTORY_ID            = H.FACTORY_ID ' + char(10)
	SELECT @v_dSql += '	AND A.LINE_ID               = H.LINE_ID ' + char(10)
	SELECT @v_dSql += '	AND A.ITEM_ID               = H.ITEM_ID ' + char(10)
	SELECT @v_dSql += '	AND A.WORK_REQUEST_MODEL_ID = H.MODEL_ID ' + char(10)
	SELECT @v_dSql += '	AND A.VERSION               = H.VERSION ' + char(10)
/*
	SELECT @v_dSql += '	LEFT OUTER HASH JOIN (' + char(10)
	SELECT @v_dSql += '				SELECT * FROM #FOIL_M A	'+char(10)
	--SELECT @v_dSql += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.FOIL_CODE, A.FOIL, A.PROD_VERSION_TYPE, A.LINE_ID, A.PROD_TYPE' + char(10)
	--SELECT @v_dSql += '	FROM   (' + char(10)
	--SELECT @v_dSql += '		SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.FOIL_ID AS FOIL_CODE, B.ITEM_NAME AS FOIL, A.PROD_VERSION_TYPE, C.LINE_ID' + char(10)
	--SELECT @v_dSql += '			   	, CASE WHEN LEFT(V.PROD_VERSION, 1) = ''Z'' THEN ''TEST'' ELSE ''MASS'' END AS PROD_TYPE' + char(10)
	--SELECT @v_dSql += '			   	, ROW_NUMBER() OVER ( 	PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.PROD_VERSION_TYPE, C.LINE_ID' + char(10)
	--SELECT @v_dSql += '			   										                 , CASE WHEN LEFT(V.PROD_VERSION, 1) = ''Z'' THEN ''TEST'' ELSE ''MASS'' END' + char(10)
	--SELECT @v_dSql += '										              ORDER BY V.APPLY_DATE DESC, A.PROD_VERSION DESC, A.PROD_SEQ DESC )	 AS NUM' + char(10)
	--SELECT @v_dSql += '		FROM  SCM_ITEM_FOIL_M        A WITH(NOLOCK)  ' + char(10)
	--SELECT @v_dSql += '			   ,FP_PROD_VERSION_M      V WITH(NOLOCK)' + char(10)
	--SELECT @v_dSql += '			   ,SCM_ITEM_M             B WITH(NOLOCK)' + char(10)
	--SELECT @v_dSql += '			   ,SCM_ITEM_LINE_ASSIGN_M C WITH(NOLOCK)' + char(10)
	--SELECT @v_dSql += '		WHERE 1=1' + char(10)
	--SELECT @v_dSql += '		        AND   A.FACTORY_ID   = V.FACTORY_ID' + char(10)
	--SELECT @v_dSql += '		        AND   A.MODEL_ID     = V.MODEL_ID' + char(10)
	--SELECT @v_dSql += '		        AND   A.ITEM_ID      = V.ITEM_ID' + char(10)
	--SELECT @v_dSql += '		        AND   A.PROD_VERSION = V.PROD_VERSION' + char(10)
	--SELECT @v_dSql += '		        AND   A.PROD_SEQ     = V.PROD_SEQ' + char(10)
	--SELECT @v_dSql += '		        AND   A.COMPANY_ID   = B.COMPANY_ID' + char(10)
	--SELECT @v_dSql += '		        AND   A.DIVISION_ID  = B.DIVISION_ID' + char(10)
	--SELECT @v_dSql += '		        AND   A.SITE_ID      = B.SITE_ID' + char(10)
	--SELECT @v_dSql += '		        AND   A.FOIL_ID      = B.ITEM_ID' + char(10)
	--SELECT @v_dSql += '		        AND   A.COMPANY_ID   = C.COMPANY_ID' + char(10)
	--SELECT @v_dSql += '		        AND   A.DIVISION_ID  = C.DIVISION_ID' + char(10)
	--SELECT @v_dSql += '		        AND   A.SITE_ID      = C.SITE_ID' + char(10)
	--SELECT @v_dSql += '		        AND   A.PLANT_ID     = C.PLANT_ID' + char(10)
	--SELECT @v_dSql += '		        AND   A.FACTORY_ID   = C.FACTORY_ID' + char(10)
	--SELECT @v_dSql += '		        AND   A.ITEM_ID      = C.ITEM_ID' + char(10)


	--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.DIVISION_ID' , 'EQ', @p_division_id))        + char(10)
	--IF(LEN(@p_site_id) > 0)
	--BEGIN
	--	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.SITE_ID' , 'EQ', @p_site_id))        + char(10)
	--END
	--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.PLANT_ID' , 'EQ', @p_plant_id))              + char(10)
	--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.FACTORY_ID' , 'EQ', @p_factory_id))          + char(10) 
	--IF(LEN(@p_operation_id) > 0)
	--BEGIN
	--	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                C.OPERATION_ID' , 'EQ', @p_operation_id))      + char(10)
	--END
	--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            C.LINE_ID' , 'EQ', @p_line_id))                + char(10)
	--IF(LEN(@p_item_id) > 0)
	--BEGIN
	--	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.ITEM_ID' , 'LK', @p_item_id))                + char(10)
	--END

	--SELECT @v_dSql += '    ) A'+char(10)
	--SELECT @v_dSql += '    WHERE  NUM = 1'+char(10)
	SELECT @v_dSql += '    ) H'+char(10)
	SELECT @v_dSql += '    ON 1=1'+char(10)
	SELECT @v_dSql += '    AND A.COMPANY_ID      = H.COMPANY_ID'+char(10)
	SELECT @v_dSql += '    AND A.DIVISION_ID     = H.DIVISION_ID'+char(10)
	SELECT @v_dSql += '    AND A.SITE_ID         = H.SITE_ID'+char(10)
	SELECT @v_dSql += '    AND A.PLANT_ID        = H.PLANT_ID'+char(10)
	SELECT @v_dSql += '    AND A.FACTORY_ID      = H.FACTORY_ID'+char(10)
	SELECT @v_dSql += '    AND A.LINE_ID         = H.LINE_ID'+char(10)
	SELECT @v_dSql += '    AND A.ITEM_ID         = H.ITEM_ID'+char(10)
	SELECT @v_dSql += '    AND A.PROD_VERSION_TYPE = H.PROD_VERSION_TYPE'+char(10)
	SELECT @v_dSql += '    AND A.CALC_TYPE       = H.PROD_TYPE'+char(10)
*/
	SELECT @v_dSql += '	  LEFT OUTER JOIN #T_RELEASE Z WITH(NOLOCK)'+char(10)
	SELECT @v_dSql += '  	ON  1=1'+char(10)
	SELECT @v_dSql += '  	AND A.FACTORY_ID = Z.FACTORY_ID'+char(10)
	SELECT @v_dSql += '	LEFT OUTER JOIN  ('+char(10)
	SELECT @v_dSql += '   	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
	SELECT @v_dSql += '                 , A.LOCATION, A.OPERATION_ID'+char(10)
	SELECT @v_dSql += '                 , A.LINE_ID'+char(10)
	SELECT @v_dSql += '                 , A.TOP_ITEM_ID, A.ITEM_ID'+char(10)
	SELECT @v_dSql += '                 , A.PRODUCTION_TYPE, A.MARKET'+char(10)
	SELECT @v_dSql += '                 , MIN(LINE_SEQ) LINE_SEQ'+char(10)
	SELECT @v_dSql += '   	FROM ('+char(10)
	SELECT @v_dSql += '	           SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
	SELECT @v_dSql += '	             , A.LOCATION, A.OPERATION_ID'+char(10)
	SELECT @v_dSql += '	             , A.LINE_ID'+char(10)
	SELECT @v_dSql += '	             , A.PLAN_DATE'+char(10)
	SELECT @v_dSql += '	             , A.TOP_ITEM_ID, A.ITEM_ID'+char(10)
	SELECT @v_dSql += '	             , A.PRODUCTION_TYPE, A.MARKET'+char(10)
	SELECT @v_dSql += '	             , A.SEQ'+char(10)
	SELECT @v_dSql += '	             , RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
	SELECT @v_dSql += '                                         , A.LOCATION, A.OPERATION_ID, A.LINE_ID'+char(10)
	SELECT @v_dSql += '                      				ORDER     BY A.PLAN_DATE, A.SEQ ) LINE_SEQ'+char(10)
	SELECT @v_dSql += '	        FROM   #TblFP00614_FIND_FP00614 A WITH(NOLOCK)'+char(10)
	SELECT @v_dSql += '	        INNER JOIN SCM_ITEM_M B WITH(NOLOCK)'+char(10)
	SELECT @v_dSql += '	        ON     A.COMPANY_ID     = B.COMPANY_ID'+char(10)
	SELECT @v_dSql += '	        AND    A.DIVISION_ID    = B.DIVISION_ID'+char(10)
	SELECT @v_dSql += '	        AND    A.SITE_ID        = B.SITE_ID'+char(10)
	SELECT @v_dSql += '	        AND    A.ITEM_ID        = B.ITEM_ID'+char(10)
	SELECT @v_dSql += '	        INNER JOIN SCM_LINE_M C WITH(NOLOCK)'+char(10)
	SELECT @v_dSql += '	        ON     A.COMPANY_ID     = C.COMPANY_ID'+char(10)
	SELECT @v_dSql += '	        AND    A.DIVISION_ID    = C.DIVISION_ID'+char(10)
	SELECT @v_dSql += '	        AND    A.SITE_ID        = C.SITE_ID'+char(10)
	SELECT @v_dSql += '	        AND    A.PLANT_ID       = C.PLANT_ID'+char(10)
	SELECT @v_dSql += '	        AND    A.FACTORY_ID     = C.FACTORY_ID'+char(10)
	SELECT @v_dSql += '	        AND    A.OPERATION_ID   = C.OPERATION_ID'+char(10)
	SELECT @v_dSql += '	        AND    A.LINE_ID        = C.LINE_ID'+char(10)
	SELECT @v_dSql += '	        AND    A.ELECTRODE_TYPE = C.ELECTRODE_TYPE'+char(10)
	SELECT @v_dSql += '	        WHERE  1=1'+char(10)
	--SELECT @v_dSql += '	        AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN ' +  @v_bucket_from + ' AND ' +  @v_bucket_to + char(10)

	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.DIVISION_ID' , 'EQ', @p_division_id))        + char(10)
	IF(LEN(@p_site_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.SITE_ID' , 'EQ', @p_site_id))        + char(10)
	END
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.PLANT_ID' , 'EQ', @p_plant_id))              + char(10)

	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.FACTORY_ID' , 'EQ', @p_factory_id))          + char(10) 

	IF(LEN(@p_operation_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.OPERATION_ID' , 'EQ', @p_operation_id))      + char(10)
	END


	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.LINE_ID' , 'EQ', @p_line_id))                + char(10)
	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type))   + char(10)
	IF(LEN(@p_top_item_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.TOP_ITEM_ID' , 'LK', @p_top_item_id))                + char(10)
	END

	IF(LEN(@p_item_id) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.ITEM_ID' , 'LK', @p_item_id))                + char(10)
	END


	IF(LEN(@p_nick_name) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('               ISNULL(B.NICK_NAME,''-'')' , 'LK', @p_nick_name))        + char(10)
	END
	IF(LEN(@p_nick_name_lt) > 0)
	BEGIN
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('       ISNULL(B.NICK_NAME,''-'')' , 'LK', @p_nick_name_lt))        + char(10)
	END


	--IF(LEN(@p_prod_type) > 0)
	--BEGIN
	--	SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.FP_PRODUCTION_TYPE' , 'LK', @p_prod_type))                + char(10)
	--END

	SELECT @v_dSql += '	                AND   ISNULL(A.SEQ, 0) <> 0 '+char(10)
	SELECT @v_dSql += '	                AND   (A.BATCH_IN_QTY + A.PLAN_IN_QTY + A.ROLL_IN_QTY + A.CELL_IN_QTY + A.JR_IN_QTY + A.BATCH_OUT_QTY + A.PLAN_QTY + A.ROLL_OUT_QTY + A.CELL_OUT_QTY + A.JR_OUT_QTY) > 0'+char(10)
	SELECT @v_dSql += '	            ) A'+char(10)
	SELECT @v_dSql += '	            GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
	SELECT @v_dSql += '	                            , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.TOP_ITEM_ID, A.ITEM_ID'+char(10)
	SELECT @v_dSql += '	                            , A.PRODUCTION_TYPE, A.MARKET'+char(10)
	SELECT @v_dSql += '	            ) B'+char(10)
	SELECT @v_dSql += '	        ON  A.COMPANY_ID      = B.COMPANY_ID'+char(10)
	SELECT @v_dSql += '				AND A.DIVISION_ID     = B.DIVISION_ID'+char(10)
	SELECT @v_dSql += '				AND A.SITE_ID         = B.SITE_ID'+char(10)
	SELECT @v_dSql += '				AND A.PLANT_ID        = B.PLANT_ID'+char(10)
	SELECT @v_dSql += '				AND A.FACTORY_ID      = B.FACTORY_ID'+char(10)
	SELECT @v_dSql += '				AND A.LOCATION        = B.LOCATION'+char(10)
	SELECT @v_dSql += '				AND A.OPERATION_ID    = B.OPERATION_ID'+char(10)
	SELECT @v_dSql += '				AND A.LINE_ID         = B.LINE_ID'+char(10)
	SELECT @v_dSql += '				AND A.TOP_ITEM_ID     = B.TOP_ITEM_ID'+char(10)
	SELECT @v_dSql += '				AND A.ITEM_ID         = B.ITEM_ID'+char(10)
	SELECT @v_dSql += '				AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE'+char(10)
	SELECT @v_dSql += '				AND A.MARKET          = B.MARKET'+char(10)
	SELECT @v_dSql += '			) A'+char(10)+char(10)
--	SELECT @v_dSql += '	    )'+char(10)



	SELECT @v_dSql += '	    SELECT A.* '+char(10)
	--SELECT @v_dSql += '		, CASE WHEN A.DATA_TYPE = ''DATA'' THEN B.APPLIED_MODEL ELSE NULL END AS APPLIED_MODEL'+char(10)
	--SELECT @v_dSql += '		, CASE WHEN A.DATA_TYPE = ''DATA'' AND B.APPLIED_MODEL = A.PC_MODEL_ID THEN NULL ELSE ISNULL(A.PC_MODEL_ID,''N/A'') END AS WORK_MODEL'+char(10)
	SELECT @v_dSql += '		     , CASE WHEN A.DATA_TYPE = ''DATA'' AND B.APPLIED_MODEL = A.PC_MODEL_ID THEN NULL ELSE ISNULL(B.APPLIED_MODEL,''N/A'') END AS APPLIED_MODEL '+char(10)
	SELECT @v_dSql += '		     , CASE WHEN A.DATA_TYPE = ''DATA'' THEN A.PC_MODEL_ID ELSE NULL END AS WORK_MODEL '+char(10)
	SELECT @v_dSql += '	  , CASE WHEN A.DATA_TYPE = ''DATA'' THEN ROUND(ISNULL(G.CAL, ISNULL( dbo.FN_GET_CONVERT_CAL(A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID,  ISNULL(A.PC_MODEL_ID, B.APPLIED_MODEL), A.ITEM_ID, CASE WHEN A.FACTORY_ID NOT IN (''E2'', ''E3'', ''E5'',''E6'', ''EB'', ''EC'', ''ED'') THEN ''-'' ELSE A.VERSION END, ''-'', ISNULL(C.PROD_VERSION_TYPE,''GENERAL''), A.MEASURE_NAME ) '+char(10)
	SELECT @v_dSql += '	    										                                          , dbo.FN_GET_CONVERT_CAL(A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID,  B.APPLIED_MODEL, A.ITEM_ID, CASE WHEN A.FACTORY_ID NOT IN (''E2'', ''E3'', ''E5'',''E6'', ''EB'', ''EC'', ''ED'') THEN ''-'' ELSE A.VERSION END, ''-'', ISNULL(C.PROD_VERSION_TYPE,''GENERAL''), A.MEASURE_NAME )) ), 0) '+char(10)
	SELECT @v_dSql += '	    		 ELSE NULL END AS CONVERSION '+char(10)
	SELECT @v_dSql += '	  , CASE WHEN A.DATA_TYPE = ''DATA'' THEN ( CASE WHEN B.APPLIED_MODEL LIKE N''A%'' THEN ''AUTOMOTIVE'''+char(10)
	SELECT @v_dSql += '	                                               WHEN B.APPLIED_MODEL LIKE N''E%'' THEN ''ESS'''+char(10)
	SELECT @v_dSql += '	                                               ELSE B.CELL_TYPE END ) ELSE NULL END AS CELL_TYPE '+char(10)
	SELECT @v_dSql += ' , ISNULL(WW.NICK_NAME,''-'') AS WORK_MODEL_NAME  ' + char(10) 
	SELECT @v_dSql += ' , WZ.SCP_EXTRA_SPEC  ' + char(10) 
	SELECT @v_dSql += ' , (CASE WHEN GG.VERSION IS NULL THEN ''N'' ELSE ''Y'' END) AS MAX_VER_FLAG ' + char(10) -- max version flag 추가... 20230905
	SELECT @v_dSql += '	    FROM ('+char(10)
	SELECT @v_dSql += '	        SELECT * FROM #MAIN'+char(10)
	SELECT @v_dSql += '	        UNION ALL'+char(10)
	SELECT @v_dSql += '	        SELECT * FROM #MAIN_GAP'+char(10)
	SELECT @v_dSql += '	        UNION ALL'+char(10)
	SELECT @v_dSql += '	        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME'+char(10)
	SELECT @v_dSql += '	                ,A.LINE_ID, ''Total'' AS LINE_NAME, A.ELECTRODE_TYPE, NULL AS EQUIPMENT_ID'+char(10)
	SELECT @v_dSql += '	                ,NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME'+char(10)
	SELECT @v_dSql += '	                ,NULL AS PRODUCTION_TYPE, NULL AS MARKET'+char(10)
	SELECT @v_dSql += '	                ,NULL AS BATCH_ID'+char(10)
	SELECT @v_dSql += '	                ,NULL AS SLURRY_1, NULL AS SLURRY_2'+char(10)
	SELECT @v_dSql += '	                ,NULL AS PRE_DISPERSION_ID'+char(10)
	SELECT @v_dSql += '	                ,NULL AS PRE_DISPERSION_NAME'+char(10)
	SELECT @v_dSql += '	                ,NULL AS PRE_DISPERSION_ID_2'+char(10)
	SELECT @v_dSql += '	                ,NULL AS PRE_DISPERSION_NAME_2'+char(10)
	SELECT @v_dSql += '	                ,NULL AS ACTIVE_MATERIAL_1, NULL AS ACTIVE_MATERIAL_2, NULL AS ACTIVE_MATERIAL_3'+char(10)
	SELECT @v_dSql += '	                ,NULL AS BINDER_1, NULL AS BINDER_2, NULL AS BINDER_3'+char(10)
	SELECT @v_dSql += '	                ,NULL AS CONDUCTION_MATERIAL_1, NULL AS CONDUCTION_MATERIAL_2'+char(10)
	SELECT @v_dSql += '	                ,NULL AS CMC'+char(10)
	SELECT @v_dSql += '	                ,NULL AS VERSION'+char(10)
	SELECT @v_dSql += '	                ,NULL AS PC_MODEL_ID'+char(10)
	SELECT @v_dSql += '	                ,NULL AS ADDITION_AGENT'+char(10)
	SELECT @v_dSql += '	                ,NULL AS FOIL_CODE'+char(10)
	SELECT @v_dSql += '	                ,NULL AS FOIL'+char(10)
	SELECT @v_dSql += '	                ,NULL AS PPM'+char(10)
	SELECT @v_dSql += '	                ,A.CATEGORY_NAME'+char(10)
	SELECT @v_dSql += '	                ,A.MEASURE_NAME'+char(10)

	IF ISNULL(@p_day_info,'') <> ''
	BEGIN
    
		IF ISNULL(@p_month_info,'') <> ''
		BEGIN
			-- monthinfo
			SET @mst_loop_cnt = 0
			SET @max_loop_cnt = 0
			SET @v_delimiter      = '|'  -- 데이터 구분자
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) 

			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '            , ISNULL(SUM(M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'),0) AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END
		END

		IF ISNULL(@p_week_info,'') <> ''
		BEGIN
			SET @mst_loop_cnt = 0
			SET @max_loop_cnt = 0
			SET @v_delimiter      = '|'  -- 데이터 구분자
			SET @max_loop_cnt     = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단    
        
			IF @max_loop_cnt > 0 
			BEGIN
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SET @v_dSql += '            , ISNULL(SUM(W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+'),0) AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END
			END
		END

		IF ISNULL(@p_day_info,'') <> ''
		BEGIN
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
    
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '            , ISNULL(SUM(D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '),0) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt)  + char(10)            
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END            
		END

		IF ISNULL(@p_week_info,'') <> ''
		BEGIN
			SET @mst_loop_cnt     = 0
			SET @v_delimiter      = '|'  -- 데이터 구분자
			SET @max_loop_cnt     = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단    

			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '            , ISNULL(SUM(T'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+'),0) AS T' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1		
			END
		END

		IF ISNULL(@p_day_info,'') <> ''
		BEGIN
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
    
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '            , ''#FFE5C2'' AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_BG' + char(10)
            
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END            
		END

	END

	SELECT @v_dSql += '         ,A.CATEGORY_ID, A.CATEGORY_ORDER'+char(10)
	SELECT @v_dSql += '         ,''TOTAL'' AS DATA_TYPE'+char(10)
	SELECT @v_dSql += '         ,'''' LINE_SEQ'+char(10)
	SELECT @v_dSql += '         ,NULL AS CALC_TYPE'+char(10)
	SELECT @v_dSql += '         ,NULL AS PROD_SEQ'+char(10)
	SELECT @v_dSql += '         ,NULL AS PLM_EC_NO'+char(10)
	SELECT @v_dSql += ' FROM   #MAIN A            '+char(10)
	SELECT @v_dSql += ' GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME, A.LINE_ID, A.ELECTRODE_TYPE'+char(10)
	SELECT @v_dSql += '         ,A.CATEGORY_NAME, A.MEASURE_NAME, A.CATEGORY_ID, A.CATEGORY_ORDER'+char(10)
	SELECT @v_dSql += ' UNION -- line memo ' + char(10) -- 메모 관련 추가 line : 중복제거를 위해 union all 이 아닌 union 으로 처리
	SELECT @v_dSql += ' SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME ' + char(10)
	SELECT @v_dSql += '      , A.LINE_ID, ''Total'' AS LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
	SELECT @v_dSql += '      , NULL AS EQUIPMENT_ID ' + char(10)
	SELECT @v_dSql += '      , NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME ' + char(10)
	SELECT @v_dSql += '      , NULL AS PRODUCTION_TYPE, NULL AS MARKET ' + char(10)
	SELECT @v_dSql += '      , NULL AS BATCH_ID ' + char(10)
	SELECT @v_dSql += '      , NULL AS SLURRY_1, NULL AS SLURRY_2 ' + char(10)
	SELECT @v_dSql += '      , NULL AS PRE_DISPERSION_ID ' + char(10)
	SELECT @v_dSql += '      , NULL AS PRE_DISPERSION_NAME ' + char(10)
	SELECT @v_dSql += '      , NULL AS PRE_DISPERSION_ID_2 ' + char(10)
	SELECT @v_dSql += '      , NULL AS PRE_DISPERSION_NAME_2 ' + char(10)
	SELECT @v_dSql += '      , NULL AS ACTIVE_MATERIAL_1, NULL AS ACTIVE_MATERIAL_2, NULL AS ACTIVE_MATERIAL_3 ' + char(10)
	SELECT @v_dSql += '      , NULL AS BINDER_1, NULL AS BINDER_2, NULL AS BINDER_3 ' + char(10)
	SELECT @v_dSql += '      , NULL AS CONDUCTION_MATERIAL_1, NULL AS CONDUCTION_MATERIAL_2 ' + char(10)
	SELECT @v_dSql += '      , NULL AS CMC ' + char(10)
	SELECT @v_dSql += '      , NULL AS VERSION ' + char(10)
	SELECT @v_dSql += '      , NULL AS PC_MODEL_ID ' + char(10)
	SELECT @v_dSql += '      , NULL AS ADDITION_AGENT ' + char(10)
	SELECT @v_dSql += '      , NULL AS FOIL_CODE ' + char(10)
	SELECT @v_dSql += '      , NULL AS FOIL ' + char(10)
	SELECT @v_dSql += '      , NULL AS PPM ' + char(10)
	SELECT @v_dSql += '      , ''Memo'' AS CATEGORY_NAME ' + char(10)
	SELECT @v_dSql += '      , '''' AS MEASURE_NAME ' + char(10)
	        
	IF ISNULL(@p_day_info,'') <> ''
	BEGIN
    
		IF ISNULL(@p_month_info,'') <> ''
		BEGIN
			-- monthinfo
			SET @mst_loop_cnt = 0
			SET @max_loop_cnt = 0
			SET @v_delimiter      = '|'  -- 데이터 구분자
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) 

			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '      , 0 AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END
		END

		IF ISNULL(@p_week_info,'') <> ''
		BEGIN
			SET @mst_loop_cnt = 0
			SET @max_loop_cnt = 0
			SET @v_delimiter      = '|'  -- 데이터 구분자
			SET @max_loop_cnt     = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단    
        
			IF @max_loop_cnt > 0 
			BEGIN
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SET @v_dSql += '      , 0 AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END
			END
		END

		IF ISNULL(@p_day_info,'') <> ''
		BEGIN
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
    
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '      , 0 AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt)  + char(10)            
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END            
		END

		IF ISNULL(@p_week_info,'') <> ''
		BEGIN
			SET @mst_loop_cnt     = 0
			SET @v_delimiter      = '|'  -- 데이터 구분자
			SET @max_loop_cnt     = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단    

			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '      , 0 AS T' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1		
			END
		END

		IF ISNULL(@p_day_info,'') <> ''
		BEGIN
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
    
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '      , ''#FFE5C2'' AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_BG' + char(10)
            
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END            
		END

	END

	SELECT @v_dSql += '      , ''P_MEMO'' AS CATEGORY_ID, 400 AS CATEGORY_ORDER ' + char(10)
	SELECT @v_dSql += '      , ''TOTAL'' AS DATA_TYPE ' + char(10)
	SELECT @v_dSql += '      , '''' LINE_SEQ ' + char(10)
	SELECT @v_dSql += '      , NULL AS CALC_TYPE ' + char(10)
	SELECT @v_dSql += '      , NULL AS PROD_SEQ ' + char(10)
	SELECT @v_dSql += '      , NULL AS PLM_EC_NO ' + char(10)
	SELECT @v_dSql += ' FROM  ( ' + char(10)
	SELECT @v_dSql += ' 	SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID ' + char(10)
	SELECT @v_dSql += ' 		 , B.ELECTRODE_TYPE, B.LOCATION, B.OPERATION_NAME ' + char(10)
	SELECT @v_dSql += ' 	FROM   FP_AMEND_MEMO_M A WITH(NOLOCK) ' + char(10)
	SELECT @v_dSql += ' 	LEFT OUTER JOIN ( ' + char(10)
	SELECT @v_dSql += ' 		SELECT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.FACTORY_ID, B.OPERATION_ID, B.LINE_ID ' + char(10)
	SELECT @v_dSql += ' 			 , MAX(B.ELECTRODE_TYPE) AS ELECTRODE_TYPE, MAX(B.LOCATION) AS LOCATION, MAX(C.OPERATION_NAME) AS OPERATION_NAME ' + char(10)
	SELECT @v_dSql += ' 		FROM   SCM_LINE_M B WITH(NOLOCK), SCM_OPERATION_M C WITH(NOLOCK) ' + char(10)
	SELECT @v_dSql += ' 		WHERE  1=1 ' + char(10)
	SELECT @v_dSql += ' 		AND    B.COMPANY_ID   = C.COMPANY_ID ' + char(10)
	SELECT @v_dSql += ' 		AND    B.DIVISION_ID  = C.DIVISION_ID ' + char(10)
	SELECT @v_dSql += ' 		AND    B.SITE_ID      = C.SITE_ID ' + char(10)
	SELECT @v_dSql += ' 		AND    B.OPERATION_ID = C.OPERATION_ID ' + char(10)
	SELECT @v_dSql += ' 		' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.DIVISION_ID' , 'EQ', @p_division_id))
	SELECT @v_dSql += ' 		' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.SITE_ID' , 'EQ', @p_site_id))
	SELECT @v_dSql += ' 		' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.PLANT_ID' , 'EQ', @p_plant_id))
	SELECT @v_dSql += ' 		' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.FACTORY_ID' , 'EQ', @p_factory_id))
	SELECT @v_dSql += ' 		' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
	SELECT @v_dSql += ' 		GROUP BY B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.FACTORY_ID, B.OPERATION_ID, B.LINE_ID ' + char(10)
	SELECT @v_dSql += ' 	) B ' + char(10)
	SELECT @v_dSql += ' 	ON     1=1 ' + char(10)
	SELECT @v_dSql += ' 	AND    A.COMPANY_ID   = B.COMPANY_ID ' + char(10)
	SELECT @v_dSql += ' 	AND    A.DIVISION_ID  = B.DIVISION_ID ' + char(10)
	SELECT @v_dSql += ' 	AND    A.SITE_ID      = B.SITE_ID ' + char(10)
	SELECT @v_dSql += ' 	AND    A.PLANT_ID     = B.PLANT_ID ' + char(10)
	SELECT @v_dSql += ' 	AND    A.FACTORY_ID   = B.FACTORY_ID ' + char(10)
	SELECT @v_dSql += ' 	AND    A.OPERATION_ID = B.OPERATION_ID ' + char(10)
	SELECT @v_dSql += ' 	AND    A.LINE_ID      = B.LINE_ID ' + char(10)
	SELECT @v_dSql += ' 	WHERE  1=1 ' + char(10)
	SELECT @v_dSql += '     AND    A.PLAN_DATE BETWEEN CONVERT(DATE, ''' + @p_bucket_from + ''') AND CONVERT(DATE, ''' + @p_bucket_to + ''') ' + char(10)
	SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))
	SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))
	SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))
	SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))
	SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
	SELECT @v_dSql += ' ) A ' + char(10)
	SELECT @v_dSql += ' GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
	SELECT @v_dSql += ' UNION ALL'+char(10)
	SELECT @v_dSql += ' SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME'+char(10)
	SELECT @v_dSql += '     ,A.LINE_ID, ''Total'' AS LINE_NAME, A.ELECTRODE_TYPE, NULL AS EQUIPMENT_ID'+char(10)
	SELECT @v_dSql += '     ,NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME'+char(10)
	SELECT @v_dSql += '     ,NULL AS PRODUCTION_TYPE, NULL AS MARKET'+char(10)
	SELECT @v_dSql += '     ,NULL AS BATCH_ID'+char(10)
	SELECT @v_dSql += '     ,NULL AS SLURRY_1, NULL AS SLURRY_2'+char(10)
	SELECT @v_dSql += '     ,NULL AS PRE_DISPERSION_ID'+char(10)
	SELECT @v_dSql += '     ,NULL AS PRE_DISPERSION_NAME'+char(10)
	SELECT @v_dSql += '     ,NULL AS PRE_DISPERSION_ID_2'+char(10)
	SELECT @v_dSql += '     ,NULL AS PRE_DISPERSION_NAME_2'+char(10)
	SELECT @v_dSql += '     ,NULL AS ACTIVE_MATERIAL_1, NULL AS ACTIVE_MATERIAL_2, NULL AS ACTIVE_MATERIAL_3'+char(10)
	SELECT @v_dSql += '     ,NULL AS BINDER_1, NULL AS BINDER_2, NULL AS BINDER_3'+char(10)
	SELECT @v_dSql += '     ,NULL AS CONDUCTION_MATERIAL_1, NULL AS CONDUCTION_MATERIAL_2'+char(10)
	SELECT @v_dSql += '     ,NULL AS CMC'+char(10)
	SELECT @v_dSql += '     ,NULL AS VERSION'+char(10)
	SELECT @v_dSql += '     ,NULL AS PC_MODEL_ID'+char(10)
	SELECT @v_dSql += '     ,NULL AS ADDITION_AGENT'+char(10)
	SELECT @v_dSql += '     ,NULL AS FOIL_CODE'+char(10)
	SELECT @v_dSql += '     ,NULL AS FOIL'+char(10)
	SELECT @v_dSql += '     ,NULL AS PPM'+char(10)
	SELECT @v_dSql += '     ,A.CATEGORY_NAME'+char(10)
	SELECT @v_dSql += '     ,A.MEASURE_NAME'+char(10)

	IF ISNULL(@p_day_info,'') <> ''
	BEGIN
    
		IF ISNULL(@p_month_info,'') <> ''
		BEGIN
			-- monthinfo
			SET @mst_loop_cnt = 0
			SET @max_loop_cnt = 0
			SET @v_delimiter      = '|'  -- 데이터 구분자
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) 

			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '            , SUM(M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END
		END

		IF ISNULL(@p_week_info,'') <> ''
		BEGIN
			SET @mst_loop_cnt = 0
			SET @max_loop_cnt = 0
			SET @v_delimiter      = '|'  -- 데이터 구분자
			SET @max_loop_cnt     = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단    
        
			IF @max_loop_cnt > 0 
			BEGIN
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SET @v_dSql += '            , SUM(W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+') AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END
			END
		END

		IF ISNULL(@p_day_info,'') <> ''
		BEGIN
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
    
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '            , SUM(D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + ') AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt)  + char(10)            
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END            
		END

		IF ISNULL(@p_week_info,'') <> ''
		BEGIN
			SET @mst_loop_cnt     = 0
			SET @v_delimiter      = '|'  -- 데이터 구분자
			SET @max_loop_cnt     = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단    

			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '            , NULL AS T'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1		
			END
		END

		IF ISNULL(@p_day_info,'') <> ''
		BEGIN
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
    
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '            , ''#FFE5C2'' AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_BG' + char(10)
            
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END            
		END

	END


	SELECT @v_dSql += '        ,A.CATEGORY_ID, A.CATEGORY_ORDER' + char(10)
	SELECT @v_dSql += '        ,''TOTAL'' AS DATA_TYPE' + char(10)
	SELECT @v_dSql += '        ,'''' LINE_SEQ' + char(10)
	SELECT @v_dSql += '        ,NULL AS CALC_TYPE' + char(10)
	SELECT @v_dSql += '        ,NULL AS PROD_SEQ' + char(10)
	SELECT @v_dSql += '        ,NULL AS PLM_EC_NO' + char(10)
	SELECT @v_dSql += '  FROM   #MAIN_GAP A' + char(10)   
	SELECT @v_dSql += '  GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME, A.LINE_ID, A.ELECTRODE_TYPE' + char(10)
	SELECT @v_dSql += '          ,A.CATEGORY_NAME, A.MEASURE_NAME, A.CATEGORY_ID, A.CATEGORY_ORDER ' + char(10)
	SELECT @v_dSql += '  UNION ALL' + char(10)
	SELECT @v_dSql += '  SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID, NULL AS FACTORY_ID, NULL AS LOCATION, NULL AS OPERATION_ID, NULL AS OPERATION_NAME' + char(10)
	SELECT @v_dSql += '        ,NULL AS LINE_ID, ''Total'' AS LINE_NAME, NULL AS ELECTRODE_TYPE, NULL AS EQUIPMENT_ID' + char(10)
	SELECT @v_dSql += '        ,NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME' + char(10)
	SELECT @v_dSql += '        ,NULL AS PRODUCTION_TYPE, NULL AS MARKET' + char(10)
	SELECT @v_dSql += '        ,NULL AS BATCH_ID' + char(10)
	SELECT @v_dSql += '        ,NULL AS SLURRY_1, NULL AS SLURRY_2' + char(10)
	SELECT @v_dSql += '        ,NULL AS PRE_DISPERSION_ID' + char(10)
	SELECT @v_dSql += '        ,NULL AS PRE_DISPERSION_NAME' + char(10)
	SELECT @v_dSql += '        ,NULL AS PRE_DISPERSION_ID_2' + char(10)
	SELECT @v_dSql += '        ,NULL AS PRE_DISPERSION_NAME_2' + char(10)
	SELECT @v_dSql += '        ,NULL AS ACTIVE_MATERIAL_1, NULL AS ACTIVE_MATERIAL_2, NULL AS ACTIVE_MATERIAL_3' + char(10)
	SELECT @v_dSql += '        ,NULL AS BINDER_1, NULL AS BINDER_2, NULL AS BINDER_3' + char(10)
	SELECT @v_dSql += '        ,NULL AS CONDUCTION_MATERIAL_1, NULL AS CONDUCTION_MATERIAL_2' + char(10)
	SELECT @v_dSql += '        ,NULL AS CMC' + char(10)
	SELECT @v_dSql += '        ,NULL AS VERSION' + char(10)
	SELECT @v_dSql += '        ,NULL AS PC_MODEL_ID' + char(10)
	SELECT @v_dSql += '        ,NULL AS ADDITION_AGENT' + char(10)
	SELECT @v_dSql += '        ,NULL AS FOIL_CODE' + char(10)
	SELECT @v_dSql += '        ,NULL AS FOIL' + char(10)
	SELECT @v_dSql += '        ,NULL AS PPM' + char(10)
	SELECT @v_dSql += '        ,A.CATEGORY_NAME' + char(10)
	SELECT @v_dSql += '        ,A.MEASURE_NAME' + char(10)

	IF ISNULL(@p_day_info,'') <> ''
	BEGIN
    
		IF ISNULL(@p_month_info,'') <> ''
		BEGIN
			-- monthinfo
			SET @mst_loop_cnt = 0
			SET @max_loop_cnt = 0
			SET @v_delimiter      = '|'  -- 데이터 구분자
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) 

			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '            , SUM(M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END
		END

		IF ISNULL(@p_week_info,'') <> ''
		BEGIN
			SET @mst_loop_cnt = 0
			SET @max_loop_cnt = 0
			SET @v_delimiter      = '|'  -- 데이터 구분자
			SET @max_loop_cnt     = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단    
        
			IF @max_loop_cnt > 0 
			BEGIN
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SET @v_dSql += '            , SUM(W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+') AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END
			END
		END

		IF ISNULL(@p_day_info,'') <> ''
		BEGIN
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
    
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '            , SUM(D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + ') AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt)  + char(10)            
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END            
		END

		IF ISNULL(@p_week_info,'') <> ''
		BEGIN
			SET @mst_loop_cnt     = 0
			SET @v_delimiter      = '|'  -- 데이터 구분자
			SET @max_loop_cnt     = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단    

			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '            , SUM(T'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + ') AS T' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1		
			END
		END

		IF ISNULL(@p_day_info,'') <> ''
		BEGIN
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
    
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '            , ''#FFBA85'' AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_BG' + char(10)
            
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END            
		END

	END


	SELECT @v_dSql += '        ,A.CATEGORY_ID, A.CATEGORY_ORDER' + char(10)
	SELECT @v_dSql += '        ,''TOTAL_2'' AS DATA_TYPE' + char(10)
	SELECT @v_dSql += '        ,'''' LINE_SEQ' + char(10)
	SELECT @v_dSql += '        ,NULL AS CALC_TYPE' + char(10)
	SELECT @v_dSql += '        ,NULL AS PROD_SEQ' + char(10)
	SELECT @v_dSql += '        ,NULL AS PLM_EC_NO' + char(10)
	SELECT @v_dSql += '  FROM   #MAIN A          ' + char(10)
	SELECT @v_dSql += '  GROUP BY A.CATEGORY_NAME, A.MEASURE_NAME, A.CATEGORY_ID, A.CATEGORY_ORDER' + char(10)
	SELECT @v_dSql += '  UNION ALL' + char(10)
	SELECT @v_dSql += '  SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID, NULL AS FACTORY_ID, NULL AS LOCATION, NULL AS OPERATION_ID, NULL AS OPERATION_NAME' + char(10)
	SELECT @v_dSql += '        ,NULL AS LINE_ID, ''Total'' AS LINE_NAME, NULL AS ELECTRODE_TYPE, NULL AS EQUIPMENT_ID' + char(10)
	SELECT @v_dSql += '        ,NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME' + char(10)
	SELECT @v_dSql += '        ,NULL AS PRODUCTION_TYPE, NULL AS MARKET' + char(10)
	SELECT @v_dSql += '        ,NULL AS BATCH_ID' + char(10)
	SELECT @v_dSql += '        ,NULL AS SLURRY_1, NULL AS SLURRY_2' + char(10)
	SELECT @v_dSql += '        ,NULL AS PRE_DISPERSION_ID' + char(10)
	SELECT @v_dSql += '        ,NULL AS PRE_DISPERSION_NAME' + char(10)
	SELECT @v_dSql += '        ,NULL AS PRE_DISPERSION_ID_2' + char(10)
	SELECT @v_dSql += '        ,NULL AS PRE_DISPERSION_NAME_2' + char(10)
	SELECT @v_dSql += '        ,NULL AS ACTIVE_MATERIAL_1, NULL AS ACTIVE_MATERIAL_2, NULL AS ACTIVE_MATERIAL_3' + char(10)
	SELECT @v_dSql += '        ,NULL AS BINDER_1, NULL AS BINDER_2, NULL AS BINDER_3' + char(10)
	SELECT @v_dSql += '        ,NULL AS CONDUCTION_MATERIAL_1, NULL AS CONDUCTION_MATERIAL_2' + char(10)
	SELECT @v_dSql += '        ,NULL AS CMC' + char(10)
	SELECT @v_dSql += '        ,NULL AS VERSION' + char(10)
	SELECT @v_dSql += '        ,NULL AS PC_MODEL_ID' + char(10)
	SELECT @v_dSql += '        ,NULL AS ADDITION_AGENT' + char(10)
	SELECT @v_dSql += '        ,NULL AS FOIL_CODE' + char(10)
	SELECT @v_dSql += '        ,NULL AS FOIL' + char(10)
	SELECT @v_dSql += '        ,NULL AS PPM' + char(10)
	SELECT @v_dSql += '        ,A.CATEGORY_NAME' + char(10)
	SELECT @v_dSql += '        ,A.MEASURE_NAME' + char(10)



	IF ISNULL(@p_day_info,'') <> ''
	BEGIN
    
		IF ISNULL(@p_month_info,'') <> ''
		BEGIN
			-- monthinfo
			SET @mst_loop_cnt = 0
			SET @max_loop_cnt = 0
			SET @v_delimiter      = '|'  -- 데이터 구분자
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) 

			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '            , SUM(M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END
		END

		IF ISNULL(@p_week_info,'') <> ''
		BEGIN
			SET @mst_loop_cnt = 0
			SET @max_loop_cnt = 0
			SET @v_delimiter      = '|'  -- 데이터 구분자
			SET @max_loop_cnt     = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단    
        
			IF @max_loop_cnt > 0 
			BEGIN
				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SET @v_dSql += '            , SUM(W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+') AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
					SET @mst_loop_cnt =  @mst_loop_cnt + 1
				END
			END
		END

		IF ISNULL(@p_day_info,'') <> ''
		BEGIN
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
    
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '            , SUM(D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + ') AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt)  + char(10)            
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END            
		END

		IF ISNULL(@p_week_info,'') <> ''
		BEGIN
			SET @mst_loop_cnt     = 0
			SET @v_delimiter      = '|'  -- 데이터 구분자
			SET @max_loop_cnt     = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단    

			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '             , NULL AS T'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +  char(10)
				SET @mst_loop_cnt =  @mst_loop_cnt + 1		
			END
		END

		IF ISNULL(@p_day_info,'') <> ''
		BEGIN
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
    
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @v_dSql += '            , ''#FFBA85'' AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +'_BG' + char(10)
            
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
			END            
		END

	END


	SELECT @v_dSql += '            ,A.CATEGORY_ID, A.CATEGORY_ORDER'+char(10)
	SELECT @v_dSql += '            ,''TOTAL_2'' AS DATA_TYPE'+char(10)
	SELECT @v_dSql += '            ,'''' LINE_SEQ'+char(10)
	SELECT @v_dSql += '            ,NULL AS CALC_TYPE'+char(10)
	SELECT @v_dSql += '            ,NULL AS PROD_SEQ'+char(10)
	SELECT @v_dSql += '            ,NULL AS PLM_EC_NO'+char(10)
	SELECT @v_dSql += '      FROM   #MAIN_GAP A'+char(10)
	SELECT @v_dSql += '      GROUP BY A.CATEGORY_NAME, A.MEASURE_NAME, A.CATEGORY_ID, A.CATEGORY_ORDER'+char(10)
	SELECT @v_dSql += '  ) A'+char(10)
	SELECT @v_dSql += '  LEFT OUTER JOIN SCM_ITEM_M B WITH(NOLOCK)'+char(10)
	SELECT @v_dSql += '  ON  A.COMPANY_ID  = B.COMPANY_ID'+char(10)
	SELECT @v_dSql += '  AND A.DIVISION_ID = B.DIVISION_ID'+char(10)
	SELECT @v_dSql += '  AND A.SITE_ID     = B.SITE_ID'+char(10)
	SELECT @v_dSql += '  AND A.ITEM_ID     = B.ITEM_ID'+char(10)
	SELECT @v_dSql += '  LEFT OUTER JOIN SCM_LINE_M C WITH(NOLOCK)'+char(10)
	SELECT @v_dSql += '  ON     A.COMPANY_ID     = C.COMPANY_ID'+char(10)
	SELECT @v_dSql += '  AND    A.DIVISION_ID    = C.DIVISION_ID'+char(10)
	SELECT @v_dSql += '  AND    A.SITE_ID        = C.SITE_ID'+char(10)
	SELECT @v_dSql += '  AND    A.PLANT_ID       = C.PLANT_ID'+char(10)
	SELECT @v_dSql += '  AND    A.FACTORY_ID     = C.FACTORY_ID'+char(10)
	SELECT @v_dSql += '  AND    A.OPERATION_ID   = C.OPERATION_ID'+char(10)
	SELECT @v_dSql += '  AND    A.LINE_ID        = C.LINE_ID'+char(10)
	SELECT @v_dSql += '  AND    A.ELECTRODE_TYPE = C.ELECTRODE_TYPE'+char(10)
	SELECT @v_dSql += '  LEFT OUTER JOIN #T_VERSION G WITH(NOLOCK)'+char(10)
	SELECT @v_dSql += '  ON     A.COMPANY_ID     = G.COMPANY_ID'+char(10)
	SELECT @v_dSql += '  AND    A.DIVISION_ID    = G.DIVISION_ID'+char(10)
	SELECT @v_dSql += '  AND    A.SITE_ID        = G.SITE_ID'+char(10)
	SELECT @v_dSql += '  AND    A.PLANT_ID       = G.PLANT_ID'+char(10)
	SELECT @v_dSql += '  AND    A.FACTORY_ID     = G.FACTORY_ID'+char(10)
	SELECT @v_dSql += '  AND    A.OPERATION_ID   = G.OPERATION_ID'+char(10)
	SELECT @v_dSql += '  AND    ISNULL(A.PC_MODEL_ID, B.APPLIED_MODEL)  = G.MODEL_ID'+char(10)
	SELECT @v_dSql += '  AND    A.ITEM_ID        = G.ITEM_ID'+char(10)
	SELECT @v_dSql += '  AND    C.PROD_VERSION_TYPE = G.PROD_VERSION_TYPE      '+char(10)
	SELECT @v_dSql += '  AND    A.CALC_TYPE      = G.VERSION_TYPE'+char(10)
	SELECT @v_dSql += '  AND    A.VERSION        = G.VERSION'+char(10)
	SELECT @v_dSql += '  AND    A.MEASURE_NAME   = G.CATEGORY'+char(10)
	SELECT @v_dSql += '  LEFT OUTER JOIN '+char(10) -- max version flag 추가... 20230905
	SELECT @v_dSql += '  ( '+char(10)
	SELECT @v_dSql += '  	SELECT GG.COMPANY_ID, GG.DIVISION_ID, GG.SITE_ID, GG.PLANT_ID, GG.FACTORY_ID '+char(10)
	SELECT @v_dSql += '           , GG.OPERATION_ID, GG.MODEL_ID, GG.ITEM_ID '+char(10)
	SELECT @v_dSql += '           , GG.PROD_VERSION_TYPE, GG.VERSION, GG.VERSION_TYPE '+char(10)
	SELECT @v_dSql += '  	FROM   #T_VERSION GG WITH(NOLOCK) '+char(10)
	SELECT @v_dSql += '  	GROUP BY GG.COMPANY_ID, GG.DIVISION_ID, GG.SITE_ID, GG.PLANT_ID, GG.FACTORY_ID '+char(10)
	SELECT @v_dSql += '             , GG.OPERATION_ID, GG.MODEL_ID, GG.ITEM_ID '+char(10)
	SELECT @v_dSql += '             , GG.PROD_VERSION_TYPE, GG.VERSION, GG.VERSION_TYPE '+char(10)
	SELECT @v_dSql += '  ) GG '+char(10)
	SELECT @v_dSql += '  ON  A.COMPANY_ID        = GG.COMPANY_ID '+char(10)
	SELECT @v_dSql += '  AND A.DIVISION_ID       = GG.DIVISION_ID '+char(10)
	SELECT @v_dSql += '  AND A.SITE_ID           = GG.SITE_ID '+char(10)
	SELECT @v_dSql += '  AND A.PLANT_ID          = GG.PLANT_ID '+char(10)
	SELECT @v_dSql += '  AND A.FACTORY_ID        = GG.FACTORY_ID '+char(10)
	SELECT @v_dSql += '  AND A.OPERATION_ID      = GG.OPERATION_ID '+char(10)
	SELECT @v_dSql += '  AND ISNULL(A.PC_MODEL_ID, B.APPLIED_MODEL) = GG.MODEL_ID '+char(10)
	SELECT @v_dSql += '  AND A.ITEM_ID           = GG.ITEM_ID '+char(10)
	SELECT @v_dSql += '  AND C.PROD_VERSION_TYPE = GG.PROD_VERSION_TYPE '+char(10)
	SELECT @v_dSql += '  AND A.CALC_TYPE         = GG.VERSION_TYPE '+char(10)
	SELECT @v_dSql += '  AND A.VERSION           = GG.VERSION '+char(10)
	--KIMSI 22.07.15
	---------------------------------------------------------------------------------
	SELECT @v_dSql += ' LEFT OUTER JOIN SCM_ITEM_M WW WITH(NOLOCK) '+char(10)
	SELECT @v_dSql += ' ON  A.COMPANY_ID  = WW.COMPANY_ID '+char(10)
	SELECT @v_dSql += ' AND A.DIVISION_ID = WW.DIVISION_ID '+char(10)
	SELECT @v_dSql += ' AND A.SITE_ID     = WW.SITE_ID '+char(10)
	--SELECT @v_dSql += ' AND (CASE WHEN A.DATA_TYPE = ''DATA'' AND B.APPLIED_MODEL = A.PC_MODEL_ID THEN NULL ELSE ISNULL(A.PC_MODEL_ID,''N/A'') END) = WW.ITEM_ID '+char(10)
	SELECT @v_dSql += ' AND A.PC_MODEL_ID = WW.ITEM_ID '+char(10)
	---------------------------------------------------------------------------------
	--KIMSI 22.07.15
	SELECT @v_dSql += ' LEFT OUTER JOIN SCM_ITEM_M WZ WITH(NOLOCK) '+char(10)
	SELECT @v_dSql += ' ON  B.COMPANY_ID  = WZ.COMPANY_ID '+char(10)
	SELECT @v_dSql += ' AND B.DIVISION_ID = WZ.DIVISION_ID '+char(10)
	SELECT @v_dSql += ' AND B.SITE_ID     = WZ.SITE_ID '+char(10)
	SELECT @v_dSql += ' AND B.APPLIED_MODEL     = WZ.ITEM_ID '+char(10)
	SELECT @v_dSql += ' AND  WZ.SCP_EXTRA_SPEC IS NOT NULL'+char(10)
	SELECT @v_dSql += '  ORDER BY (CASE WHEN A.DATA_TYPE = ''TOTAL_2'' THEN A.CATEGORY_ORDER ELSE 999 END)'+char(10)
	SELECT @v_dSql += '         , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.ELECTRODE_TYPE, A.LINE_ID'+char(10)
	SELECT @v_dSql += '         , (CASE WHEN A.DATA_TYPE=''DATA'' THEN 1 ELSE A.CATEGORY_ORDER END)'+char(10)
	SELECT @v_dSql += '         , A.LINE_SEQ'+char(10)
	--SELECT @v_dSql += '         , A.EQUIPMENT_ID, A.TOP_ITEM_ID, A.ITEM_ID'+char(10)
	SELECT @v_dSql += '         , A.EQUIPMENT_ID, A.PC_MODEL_ID, A.TOP_ITEM_ID, A.ITEM_ID'+char(10) -- work_request_model_id 조건 추가... 20240610
	SELECT @v_dSql += '         , A.PRODUCTION_TYPE, A.MARKET'+char(10)
	SELECT @v_dSql += '         , A.VERSION, a.PROD_SEQ'+char(10)
	SELECT @v_dSql += '         , A.CATEGORY_ORDER'+char(10)
	SELECT @v_dSql += ';'+char(10)+char(10)

	-- 임시테이블 제거
	SELECT @v_dSql += '	IF OBJECT_ID(''tempdb..#TblFP00614_FIND_FP00614'') IS NOT NULL	 ' + char(10);
	SELECT @v_dSql += '			DROP TABLE #TblFP00614_FIND_FP00614;					 ' + char(10);
	SELECT @v_dSql += '	IF OBJECT_ID(''tempdb..#FOIL_M'') IS NOT NULL ' + char(10);
	SELECT @v_dSql += '		DROP TABLE #FOIL_M; ' + char(10)+char(10);
	SELECT @v_dSql += '	IF OBJECT_ID(''tempdb..#SCM_PANCAKE_MATERIAL_V'') IS NOT NULL ' + char(10);
	SELECT @v_dSql += '		DROP TABLE #SCM_PANCAKE_MATERIAL_V; ' + char(10)+char(10)
	SELECT @v_dSql += '	if object_id(''tempdb..#T_RELEASE'') is not null ' + char(10);
	SELECT @v_dSql += '		drop table #T_RELEASE; ' + char(10)+char(10)
	SELECT @v_dSql += '	if object_id(''tempdb..#T_VERSION'') is not null ' + char(10);
	SELECT @v_dSql += '		drop table #T_VERSION; ' + char(10)+char(10)
	SELECT @v_dSql += '	if object_id(''tempdb..#MAIN'') is not null ' + char(10);
	SELECT @v_dSql += '		drop table #MAIN; ' + char(10)+char(10)
	SELECT @v_dSql += 'if object_id(''tempdb..#MAIN_GAP'') is not null' + char(10)
	SELECT @v_dSql += '		drop table #MAIN_GAP;' + char(10)
	SELECT @v_dSql += 'IF OBJECT_ID(''tempdb..#ITEM_MEMO_TEMP'') IS NOT NULL	DROP TABLE #ITEM_MEMO_TEMP;' + char(10);
	SELECT @v_dSql += 'if object_id(''tempdb..#FOIL_INFO'') is not null	DROP TABLE #FOIL_INFO;' + char(10);

END

ELSE IF @p_sys_flag = 'SELECT_MEA_MEMO'
BEGIN
	SELECT @v_dSql = ''
    SELECT @v_dSql += ' SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
    SELECT @v_dSql += '     , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID       ' + char(10)
    SELECT @v_dSql += '     , A.ITEM_ID, A.TOP_ITEM_ID, A.PRODUCTION_TYPE, A.MARKET             ' + char(10)
            
	IF isnull(@p_day_info,'') <> '' 
        BEGIN
            SELECT @mst_loop_cnt = 0	
            SELECT @max_loop_cnt = 0
            SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_sub_delimiter) -- 프로시저 LOOP 길이를 판단
            SELECT @v_Tmp1       = ''
            
            IF @max_loop_cnt > 0 
            		BEGIN
            		-- dayinfo
					SELECT @v_Tmp1       = ''
            		SELECT @mst_loop_cnt = 0	
            		SELECT @max_loop_cnt = 0
            		SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_sub_delimiter) -- 프로시저 LOOP 길이를 판단
            			    
            		WHILE @mst_loop_cnt < @max_loop_cnt
            			    BEGIN
								SELECT @mst_loop_cnt = @mst_loop_cnt +1     
                                SELECT @v_day_info   = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_sub_delimiter, @mst_loop_cnt)

            			    	SELECT @v_Tmp1 += '     , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)= ''' + @v_day_info + ''' THEN  A.MEMO ELSE NULL END) AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +'_MEMO ' + char(10)
            				END 
            	END
        END

    SELECT @v_dSql = @v_dSql + @v_Tmp1

    SELECT @v_dSql += ' FROM FP_AMEND_MEMO_M A WITH(NOLOCK)                                                         ' + char(10)
    SELECT @v_dSql += ' WHERE 1=1                                                                                   ' + char(10)
    SELECT @v_dSql += ' AND  A.INSTANCE_ID  = ' + @v_instance_id+'                                                  ' + char(10)
    SELECT @v_dSql += ' AND  A.PLAN_DATE BETWEEN CONVERT(DATE, ' +  @v_bucket_from + ') AND CONVERT(DATE, ' +  @v_bucket_to + ') ' + char(10)
    SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))                  + char(10)
    SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))                          + char(10)
    SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))                        + char(10)
    SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))                    + char(10) 
    SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))                + char(10)
    SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))                          + char(10)
			
    SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_top_item_id))                          + char(10)
    SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id))                          + char(10)
    SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'LK', @p_prod_type))                          + char(10)
	--IF(LEN(@p_top_item_id) > 0 )
	--	BEGIN
	--		SELECT @v_dSql += ' AND   A.TOP_ITEM_ID LIKE ''%'' + '''+ @p_top_item_id +''' + ''%''    ' + char(10)
	--	END
	--IF(LEN(@p_item_id) > 0 )
	--	BEGIN
	--		SELECT @v_dSql += ' AND   A.ITEM_ID LIKE ''%'+ @p_item_id + '%''    ' + char(10)
	--	END
	--IF(LEN(@p_prod_type) > 0 )
	--	BEGIN
	--		SELECT @v_dSql += ' AND   A.PRODUCTION_TYPE LIKE ''%'' + '''+ @p_prod_type +''' + ''%''    ' + char(10)
	--	END

    SELECT @v_dSql += ' GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                   ' + char(10)
    SELECT @v_dSql += '     , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID                           ' + char(10)
    SELECT @v_dSql += '     , A.ITEM_ID, A.TOP_ITEM_ID, A.PRODUCTION_TYPE, A.MARKET                                 ' + char(10)

END
--------------------------------------------------------------------------------------------------------------------------------------------------------------




IF @p_sys_type = 'SQL'
BEGIN
 --SELECT @v_tmpSql_Start + @v_tmpSql + @v_dSql AS SQL
 SELECT @v_dSql AS SQL

END 
ELSE 
BEGIN
	SET @runstart = GetDate()

	BEGIN TRY
		--BEGIN TRAN
		-- run dynamic sql
			exec sp_executesql @v_dSql
			--COMMIT TRAN
		END 
		
		TRY
			BEGIN CATCH
			--ROLLBACK
			SET @runend = GetDate()
			--exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
		END CATCH

		SET @runend = GetDate()
		-- Record sql query
		--exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
	END

END
		      
		    
