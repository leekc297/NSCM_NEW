
/***********************************************************************************************/
/** 프로그램 ID   :PR_UI_FP00617_PLANBY_LINE_PREMIX                                                **/
/** 프로그램 명   : Procedure PR_UI_FP00617_PLANBY_LINE_PREMIX                             **/
/** 설 명         :                                                                           **/
/** Version       : 1.5.0(Auto)                                                               **/
/**                                                                                           **/
/** Argument                                                                                  **/
/**                                                                                           **/
/** [검색 조건]                                                                               **/
/**                                                                                           **/
/** [Biz Logic]                                                                               **/
/**                                                                                           **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                                    **/
/**===========================================================================================**/
/** 2021-11-08     XPDbToProcedure      Auto Generated With Initial Setting                   **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00617_PLANBY_LINE_PREMIX
*/

CREATE PROCEDURE [dbo].[PR_UI_FP00617_PLANBY_LINE_PREMIX_NEW]
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
  DECLARE @p_plan_id       NVARCHAR(100) = ''
  DECLARE @p_division_id   NVARCHAR(1000) = ''
  DECLARE @p_site_id       NVARCHAR(1000) = ''
  DECLARE @p_plant_id      NVARCHAR(2000) = ''
  DECLARE @p_factory_id    NVARCHAR(2000) = ''
  DECLARE @p_line_id       NVARCHAR(max) = ''
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
  DECLARE @v_proc_name       NVARCHAR(100) = 'PR_UI_FP00617_PLANBY_LINE_PREMIX'


  DECLARE @v_plan_date       NVARCHAR(100)
  DECLARE @v_instance_id     NVARCHAR(100)
  DECLARE @v_plan_id         NVARCHAR(100)
  DECLARE @v_division_id     NVARCHAR(1000)
  DECLARE @v_site_id         NVARCHAR(1000)
  DECLARE @v_plant_id        NVARCHAR(2000)
  DECLARE @v_factory_id      NVARCHAR(2000)
  DECLARE @v_line_id         NVARCHAR(max)
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
  DECLARE @v_dSql1                NVARCHAR(MAX)=''
  DECLARE @v_dSql2                NVARCHAR(MAX)=''
  DECLARE @v_dSql3                NVARCHAR(MAX)=''
  DECLARE @v_dSql4                NVARCHAR(MAX)=''
  DECLARE @v_dSql5                NVARCHAR(MAX)=''
  
  DECLARE @v_SqlsubTotal          NVARCHAR(MAX)=''
  DECLARE @v_SqlTotal             NVARCHAR(MAX)=''

  DECLARE @v_Tmp1                 NVARCHAR(MAX)=''
  DECLARE @v_Tmp2                 NVARCHAR(MAX)=''
  DECLARE @v_Tmp3                 NVARCHAR(MAX)=''
  DECLARE @v_Tmp4                 NVARCHAR(MAX)=''
  DECLARE @v_Tmp5                 NVARCHAR(MAX)=''

  DECLARE @v_pSql                 NVARCHAR(MAX)=''
  DECLARE @v_sSql                 NVARCHAR(MAX)=''

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
  DECLARE @bBatch                 NVARCHAR(2)= ''
  DECLARE @bTotal                 NVARCHAR(2)= ''
  DECLARE @bSubTotal              NVARCHAR(2)= ''

  DECLARE @bMppWpp                NVARCHAR(2)= ''

  DECLARE @tmp_column             NVARCHAR(MAX) = ''
  DECLARE @dbg_txt                NVARCHAR(MAX) = ''

  DECLARE @v_delimiter            NVARCHAR(1)
  DECLARE @v_sub_delimiter        NVARCHAR(1)

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

  SET	@v_pSql               = ''
  SET   @v_sSql               = ''
  --Optional Parameter Part END

--DECLARE @PARAMS NVARCHAR(MAX)

--SET @PARAMS = ''
--SET @PARAMS += '@P_SYS_TYPE=' +ISNULL(@P_SYS_TYPE,'') +CHAR(10)
--SET @PARAMS += '@P_SYS_FLAG=' +ISNULL(@P_SYS_FLAG,'') +CHAR(10)
--SET @PARAMS += '@P_SYS_GUBUN=' +ISNULL(@P_SYS_GUBUN,'') +CHAR(10)
--SET @PARAMS += '@P_USER_ID=' +ISNULL(@P_USER_ID,'') +CHAR(10)
--SET @PARAMS += '@in_columns=' +ISNULL(@in_columns,'') +CHAR(10)
--SET @PARAMS += '@in_row=' +ISNULL(@in_row,'') +CHAR(10)

--SELECT @PARAMS AS SQL
--RETURN


  SET @v_delimiter            = '^'  -- 데이터 구분자
  SET @v_sub_delimiter        = '|'  -- 데이터 구분자
  SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@in_columns, @v_delimiter) -- 프로시저 LOOP 길이를 판단
  
  WHILE @mst_loop_cnt < @max_loop_cnt
      BEGIN --START WHILE
	      --AMEND_INSTANCE^PLAN_DATE^AMEND_FLAG^ALL_LINE^USER_ID^INSTANCE_ID^CONFIRM_AREA^SITE_ID^PLANT_ID^FACTORY_ID^OPERATION_ID^BUCKET_FROM^BUCKET_TO^DIVISION_ID^LINE_ID^PROD_TYPE^NICK_NAME_LT^CURR_DATE^MASTER_ID^DAY_INFO^WEEK_INFO^MONTH_INFO^BUCKET^CATE_INFO^CATE_VALUE^CATE_TYPE^
          SET @mst_loop_cnt = @mst_loop_cnt + 1;	-- @mst_loop_cnt 1증가
          SET @tmp_column   = [dbo].[SCM_ARR_SPL_VAL]( @in_columns, @v_delimiter, @mst_loop_cnt);
          
		  --LINE_AMEND_E_PMIX^20211104^Y^Y^oFrkXiPla01k5uhwAJGBDw==^KR_E_PMIX^BUILDING^A001^A011^E2^E0500^20211018^20211121^40^FP_E2P01,FP_E2P02^C-MASS,D-MASS,D-SAMPLE,MASS,M-SAMPLE,SPECIAL,S-TEST,TEST
		  --^-,CNT_C01,E54M,LBCNT,LBCNT(7.15%),PHC10_740H,PHC10_C01,PHC26_740H,PHC7.5_740H^20211104^KR_E_PMIX
		  --^20211018|20211019|20211020|20211021|20211022|20211023|20211024|20211025|20211026|20211027|20211028|20211029|20211030|20211031|20211101|20211102|20211103|20211104|20211105|20211106|20211107|20211108|20211109|20211110|20211111|20211112|20211113|20211114|20211115|20211116|20211117|20211118|20211119|20211120|20211121
		  --^202142|202143|202144|202145|202146
		  --^202110|202111^202142|20211018|20211019|20211020|20211021|20211022|20211023|20211024|202143|20211025|20211026|20211027|20211028|20211029|20211030|20211031|202144|20211101|20211102|20211103|20211104|20211105|20211106|20211107|202145|20211108|20211109|20211110|20211111|20211112|20211113|20211114|202146|20211115|20211116|20211117|20211118|20211119|20211120|20211121
		  --^chk_batch|chk_day|chk_inqty|chk_inqty_tot|chk_kg|chk_memo|chk_month|chk_mpp_inqty|chk_mpp_inqty_tot|chk_mpp_outqty|chk_mpp_outqty_tot|chk_offtime|chk_outqty|chk_outqty_tot|chk_result_in|chk_result_in_tot|chk_result_out|chk_result_out_tot|chk_seq|chk_subTotal|chk_total|chk_week|chk_wpp_inqty|chk_wpp_inqty_tot|chk_wpp_outqty|chk_wpp_outqty_tot
		  --^TRUE|TRUE|TRUE|TRUE|TRUE|TRUE|TRUE|TRUE|TRUE|TRUE|TRUE|FALSE|TRUE|TRUE|TRUE|TRUE|FALSE|FALSE|TRUE|TRUE|TRUE|TRUE|TRUE|TRUE|TRUE|TRUE
		  --^CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY|CATEGORY^
          
		  IF @tmp_column = '_SAVE_AUTH' 
              BEGIN
          	     SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END 
          ELSE IF @tmp_column = 'INSTANCE_ID' 
              BEGIN
                  SET @p_instance_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
              END 
          ELSE IF @tmp_column = 'PLAN_DATE' 
              BEGIN
                  SET @p_plan_date =  [dbo].[SCM_ARR_SPL_VAL]( @in_row      ,@v_delimiter, @mst_loop_cnt);
              END 
          ELSE IF @tmp_column = 'PLAN_ID' 
              BEGIN
                  SET @p_plan_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END 
          ELSE IF @tmp_column = 'DIVISION_ID' 
              BEGIN
                  SET @p_division_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
              END 
          ELSE IF @tmp_column = 'SITE_ID' 
              BEGIN
                  SET @p_site_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END 
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
              END 
          ELSE IF @tmp_column = 'DAY_INFO' 
              BEGIN
                  SET @p_day_info =  [dbo].[SCM_ARR_SPL_VAL]( @in_row       ,@v_delimiter, @mst_loop_cnt);
              END 
          ELSE IF @tmp_column = 'WEEK_INFO' 
              BEGIN
                  SET @p_week_info =  [dbo].[SCM_ARR_SPL_VAL]( @in_row      ,@v_delimiter, @mst_loop_cnt);;
              END 
          ELSE IF @tmp_column = 'MONTH_INFO' 
              BEGIN
                  SET @p_month_info =  [dbo].[SCM_ARR_SPL_VAL]( @in_row     ,@v_delimiter, @mst_loop_cnt);
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
              END
          ELSE IF @tmp_column = 'CATE_VALUE' 
              BEGIN
                  SET @p_cate_value =  [dbo].[SCM_ARR_SPL_VAL]( @in_row     ,@v_delimiter, @mst_loop_cnt);
              END
          ELSE IF @tmp_column = 'CATE_TYPE' 
              BEGIN
                  SET @p_cate_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row      ,@v_delimiter, @mst_loop_cnt);
              END
          ELSE IF @tmp_column = '_NON_AUTH' 
              BEGIN
          	     SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END
      END --END WHILE


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
			   , @v_user_id      = '''' + @p_user_id + ''''
    END

	--MAIN IF
	IF @p_sys_flag = 'SELECT_MAIN'
		BEGIN --MAIN IF
            SELECT @v_dSql1 = ''
            SELECT @v_pSql  = ''

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
                            IF( @v_cate_info = 'chk_kg'         AND @v_cate_value = 'TRUE' ) 
                                SELECT @bKg = 'Y'		        
                            IF( @v_cate_info = 'chk_batch'      AND @v_cate_value = 'TRUE' ) 
                                SELECT @bBatch = 'Y'	        
                            IF( @v_cate_info = 'chk_total'      AND @v_cate_value = 'TRUE' ) 
                                SELECT @bTotal = 'Y'
                            IF( @v_cate_info = 'chk_subTotal'   AND @v_cate_value = 'TRUE' ) 
                                SELECT @bSubTotal = 'Y'

                         END    
						 
                     SELECT @v_pSql  = ''
                     SELECT @v_pSql += '                  SELECT ''X'' AS CATEGORY_ID, '''' AS MEASURE_NAME, '''' AS CATEGORY_NAME, 0 AS CATEGORY_ORDER ' + char(10)
		        					
                     IF( @bInqty= 'Y' AND  @bKg = 'Y' ) 
                          BEGIN
                              SELECT @v_pSql += ' UNION ALL ' + char(10)
                              SELECT @v_pSql += ' SELECT ''P_IN_KG'' AS CATEGORY_ID, ''Kg'' AS MEASURE_NAME, ''Plan(In)'' AS CATEGORY_NAME, 210 AS CATEGORY_ORDER  ' + char(10)
                          END
                     IF( @bInqty = 'Y' AND  @bBatch = 'Y' ) 
                          BEGIN
                              SELECT @v_pSql += ' UNION ALL ' + char(10)
                              SELECT @v_pSql += ' SELECT ''P_IN_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''Plan(In)'' AS CATEGORY_NAME, 240 AS CATEGORY_ORDER  ' + char(10)
                          END
                     IF( @bOutqty = 'Y' AND  @bKg = 'Y' ) 
                          BEGIN
                              SELECT @v_pSql += ' UNION ALL ' + char(10)
                              SELECT @v_pSql += ' SELECT ''P_OUT_KG'' AS CATEGORY_ID, ''Kg'' AS MEASURE_NAME, ''Plan(Out)'' AS CATEGORY_NAME, 250 AS CATEGORY_ORDER  ' + char(10)
                          END
                     IF( @bOutqty = 'Y' AND  @bBatch = 'Y' ) 
                          BEGIN
                              SELECT @v_pSql += ' UNION ALL ' + char(10)
                              SELECT @v_pSql += ' SELECT ''P_OUT_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''Plan(Out)'' AS CATEGORY_NAME, 280 AS CATEGORY_ORDER  ' + char(10)
                          END
                     
                     IF( @bMppInqty = 'Y' AND  @bKg = 'Y' ) 
                          BEGIN
                              SELECT @v_pSql += ' UNION ALL ' + char(10)
                              SELECT @v_pSql += ' SELECT ''P_MPP_IN_KG'' AS CATEGORY_ID, ''Kg'' AS MEASURE_NAME, ''MPP(In)'' AS CATEGORY_NAME, 10 AS CATEGORY_ORDER  ' + char(10)
                          END
                     IF( @bMppInqty = 'Y' AND  @bBatch = 'Y' ) 
                          BEGIN
                              SELECT @v_pSql += ' UNION ALL ' + char(10)
                              SELECT @v_pSql += ' SELECT ''P_MPP_IN_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''MPP(In)'' AS CATEGORY_NAME, 40 AS CATEGORY_ORDER  ' + char(10)
                          END
                     IF( @bMppOutqty = 'Y' AND  @bKg = 'Y' ) 
                          BEGIN
                              SELECT @v_pSql += ' UNION ALL ' + char(10)
                              SELECT @v_pSql += ' SELECT ''P_MPP_OUT_KG'' AS CATEGORY_ID, ''Kg'' AS MEASURE_NAME, ''MPP(Out)'' AS CATEGORY_NAME, 50 AS CATEGORY_ORDER  ' + char(10)
                          END
                     IF( @bMppOutqty = 'Y' AND  @bBatch = 'Y' ) 
                          BEGIN
                              SELECT @v_pSql += ' UNION ALL ' + char(10)
                              SELECT @v_pSql += ' SELECT ''P_MPP_OUT_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''MPP(Out)'' AS CATEGORY_NAME, 80 AS CATEGORY_ORDER  ' + char(10)
                          END
                     
                     IF( @bWppInqty = 'Y' AND  @bKg = 'Y' ) 
                          BEGIN
                              SELECT @v_pSql += ' UNION ALL ' + char(10)
                              SELECT @v_pSql += ' SELECT ''P_WPP_IN_KG'' AS CATEGORY_ID, ''Kg'' AS MEASURE_NAME, ''WPP(IN)'' AS CATEGORY_NAME, 110 AS CATEGORY_ORDER  ' + char(10)
                          END
                     IF( @bWppInqty = 'Y' AND  @bBatch = 'Y' ) 
                          BEGIN
                              SELECT @v_pSql += ' UNION ALL ' + char(10)
                              SELECT @v_pSql += ' SELECT ''P_WPP_IN_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''WPP(IN)'' AS CATEGORY_NAME, 140 AS CATEGORY_ORDER  ' + char(10)
                          END
                     IF( @bWppOutqty = 'Y' AND  @bKg = 'Y' ) 
                          BEGIN
                              SELECT @v_pSql += ' UNION ALL ' + char(10)
                              SELECT @v_pSql += ' SELECT ''P_WPP_OUT_KG'' AS CATEGORY_ID, ''Kg'' AS MEASURE_NAME, ''WPP(Out)'' AS CATEGORY_NAME, 150 AS CATEGORY_ORDER  ' + char(10)
                          END
                     IF( @bWppOutqty = 'Y' AND  @bBatch = 'Y' ) 
                          BEGIN
                              SELECT @v_pSql += ' UNION ALL ' + char(10)
                              SELECT @v_pSql += ' SELECT ''P_WPP_OUT_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''WPP(Out)'' AS CATEGORY_NAME, 180 AS CATEGORY_ORDER  ' + char(10)
                          END
                     
                     IF( @bResultIn = 'Y' AND  @bKg = 'Y' ) 
                          BEGIN
                              SELECT @v_pSql += ' UNION ALL ' + char(10)
                              SELECT @v_pSql += ' SELECT ''P_RESULT_IN_KG'' AS CATEGORY_ID, ''Kg'' AS MEASURE_NAME, ''Result'' AS CATEGORY_NAME, 310 AS CATEGORY_ORDER	 ' + char(10)
                          END
                     IF( @bResultIn = 'Y' AND  @bBatch = 'Y' ) 
                          BEGIN
                              SELECT @v_pSql += ' UNION ALL ' + char(10)
                              SELECT @v_pSql += ' SELECT ''P_RESULT_IN_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''Result'' AS CATEGORY_NAME, 340 AS CATEGORY_ORDER	 ' + char(10)
                          END
                     
                     IF( @bResultOut = 'Y' AND  @bKg = 'Y' ) 
                          BEGIN
						      SELECT @v_pSql = @v_pSql
                              --SELECT @v_pSql += ' UNION ALL ' + char(10)
                              --SELECT @v_pSql += ' SELECT ''P_RESULT_OUT_KG'' AS CATEGORY_ID, ''Kg'' AS MEASURE_NAME, ''Result(Out)'' AS CATEGORY_NAME, 350 AS CATEGORY_ORDER	 ' + char(10)
                          END
                     IF( @bResultOut = 'Y' AND  @bBatch = 'Y' ) 
                          BEGIN
						      SELECT @v_pSql = @v_pSql
                              --SELECT @v_pSql += ' UNION ALL ' + char(10)
                              --SELECT @v_pSql += ' SELECT ''P_RESULT_OUT_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''Result(Out)'' AS CATEGORY_NAME, 380 AS CATEGORY_ORDER ' + char(10)
                          END
      				
                     SELECT @v_pSql += ' UNION ALL  ' + char(10)
                     SELECT @v_pSql += ' SELECT ''P_SEQ'' AS CATEGORY_ID, '''' AS MEASURE_NAME, ''Seq'' AS CATEGORY_NAME, 290 AS CATEGORY_ORDER ' + char(10)
                     SELECT @v_pSql += ' UNION ALL ' + char(10)
                     SELECT @v_pSql += ' SELECT ''P_OFFTIME'' AS CATEGORY_ID, '''' AS MEASURE_NAME, ''Off Cal.'' AS CATEGORY_NAME, 390 AS CATEGORY_ORDER ' + char(10)
                     SELECT @v_pSql += ' UNION ALL  ' + char(10)
                     SELECT @v_pSql += ' SELECT ''P_MEMO'' AS CATEGORY_ID, '''' AS MEASURE_NAME, ''Memo'' AS CATEGORY_NAME, 400 AS CATEGORY_ORDER	 ' + char(10)
      				               
			    END
		    ELSE
			    BEGIN
				     SELECT @v_pSql  = ''
                     SELECT @v_pSql += ' SELECT ''P_IN_KG'' AS CATEGORY_ID, ''Kg'' AS MEASURE_NAME, ''Plan(In)'' AS CATEGORY_NAME, 210 AS CATEGORY_ORDER ' + char(10)
                     SELECT @v_pSql += ' UNION ALL                                                                                                   ' + char(10)
                     SELECT @v_pSql += ' SELECT ''P_IN_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''Plan(In)'' AS CATEGORY_NAME, 240 AS CATEGORY_ORDER  ' + char(10)
                     SELECT @v_pSql += ' UNION ALL                                                                                                   ' + char(10)
                     SELECT @v_pSql += ' SELECT ''P_OUT_KG'' AS CATEGORY_ID, ''Kg'' AS MEASURE_NAME, ''Plan(Out)'' AS CATEGORY_NAME, 250 AS CATEGORY_ORDER  ' + char(10)
                     SELECT @v_pSql += ' UNION ALL                                                                                                   ' + char(10)
                     SELECT @v_pSql += ' SELECT ''P_OUT_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''Plan(Out)'' AS CATEGORY_NAME, 280 AS CATEGORY_ORDER  ' + char(10)
                     SELECT @v_pSql += ' UNION ALL                                                                                                  ' + char(10)
                     SELECT @v_pSql += ' SELECT ''P_MPP_IN_KG'' AS CATEGORY_ID, ''Kg'' AS MEASURE_NAME, ''MPP(In)'' AS CATEGORY_NAME, 10 AS CATEGORY_ORDER ' + char(10)
                     SELECT @v_pSql += ' UNION ALL                                                                                                   ' + char(10)
                     SELECT @v_pSql += ' SELECT ''P_MPP_IN_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''MPP(In)'' AS CATEGORY_NAME, 40 AS CATEGORY_ORDER ' + char(10)
                     SELECT @v_pSql += ' UNION ALL                                                                                                   ' + char(10)
                     SELECT @v_pSql += ' SELECT ''P_MPP_OUT_KG'' AS CATEGORY_ID, ''Kg'' AS MEASURE_NAME, ''MPP(Out)'' AS CATEGORY_NAME, 50 AS CATEGORY_ORDER ' + char(10)
                     SELECT @v_pSql += ' UNION ALL                                                                                                  ' + char(10)
                     SELECT @v_pSql += ' SELECT ''P_MPP_OUT_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''MPP(Out)'' AS CATEGORY_NAME, 80 AS CATEGORY_ORDER ' + char(10)
                     SELECT @v_pSql += ' UNION ALL                                                                                                  ' + char(10)
                     SELECT @v_pSql += ' SELECT ''P_WPP_IN_KG'' AS CATEGORY_ID, ''Kg'' AS MEASURE_NAME, ''WPP(In)'' AS CATEGORY_NAME, 110 AS CATEGORY_ORDER ' + char(10)
                     SELECT @v_pSql += ' UNION ALL                                                                                                   ' + char(10)
                     SELECT @v_pSql += ' SELECT ''P_WPP_IN_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''WPP(In)'' AS CATEGORY_NAME, 140 AS CATEGORY_ORDER ' + char(10)
                     SELECT @v_pSql += ' UNION ALL                                                                                                   ' + char(10)
                     SELECT @v_pSql += ' SELECT ''P_WPP_OUT_KG'' AS CATEGORY_ID, ''Kg'' AS MEASURE_NAME, ''WPP(Out)'' AS CATEGORY_NAME, 150 AS CATEGORY_ORDER ' + char(10)
                     SELECT @v_pSql += ' UNION ALL                                                                                                   ' + char(10)
                     SELECT @v_pSql += ' SELECT ''P_WPP_OUT_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''WPP(Out)'' AS CATEGORY_NAME, 180 AS CATEGORY_ORDER ' + char(10)
                     SELECT @v_pSql += ' UNION ALL                                                                                                   ' + char(10)
                     SELECT @v_pSql += ' SELECT ''P_RESULT_IN_KG'' AS CATEGORY_ID, ''Kg'' AS MEASURE_NAME, ''Result'' AS CATEGORY_NAME, 310 AS CATEGORY_ORDER ' + char(10)
                     SELECT @v_pSql += ' UNION ALL                                                                                                      ' + char(10)
                     SELECT @v_pSql += ' SELECT ''P_RESULT_IN_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''Result'' AS CATEGORY_NAME, 340 AS CATEGORY_ORDER ' + char(10)
                     SELECT @v_pSql += ' UNION ALL                                                                                                      ' + char(10)
                     SELECT @v_pSql += ' SELECT ''P_SEQ'' AS CATEGORY_ID, '''' AS MEASURE_NAME, ''Seq'' AS CATEGORY_NAME, 290 AS CATEGORY_ORDER ' + char(10)
                     SELECT @v_pSql += ' UNION ALL                                                                                                      ' + char(10)
                     SELECT @v_pSql += ' SELECT ''P_OFFTIME'' AS CATEGORY_ID, '''' AS MEASURE_NAME, ''Off Cal.'' AS CATEGORY_NAME, 390 AS CATEGORY_ORDER ' + char(10)
                     SELECT @v_pSql += ' UNION ALL                                                                                                 ' + char(10)
                     SELECT @v_pSql += ' SELECT ''P_MEMO'' AS CATEGORY_ID, '''' AS MEASURE_NAME, ''Memo'' AS CATEGORY_NAME, 400 AS CATEGORY_ORDER ' + char(10)        
			    END	
				
            SELECT @v_dSql1 = ''
            SELECT @v_dSql1 += ' -- v_dSql1     ' + char(10)
            SELECT @v_dSql1 += ' WITH MAIN AS ( ' + char(10)
            SELECT @v_dSql1 += '      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
            SELECT @v_dSql1 += '          , A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME ' + char(10)
            SELECT @v_dSql1 += '          , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE     ' + char(10)
            SELECT @v_dSql1 += '          , A.EQUIPMENT_ID                               ' + char(10)
            SELECT @v_dSql1 += '          , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME        ' + char(10)
            SELECT @v_dSql1 += '          , A.PRODUCTION_TYPE, A.MARKET                  ' + char(10)
            SELECT @v_dSql1 += '          , E.BINDER_1, E.BINDER_2                       ' + char(10)
            SELECT @v_dSql1 += '          , E.CONDUCTING_MATERIAL                        ' + char(10)
            SELECT @v_dSql1 += '          , E.SOLVENT                                    ' + char(10)
            SELECT @v_dSql1 += '          , B.CATEGORY_NAME AS CATEGORY_NAME             ' + char(10)
            SELECT @v_dSql1 += '          , B.MEASURE_NAME AS MEASURE_NAME               ' + char(10)

            IF ISNULL(@p_day_info,'') <> '' 
			    BEGIN  --START IF

				    -- monthinfo
					SELECT @v_Tmp1       = ''					
		            SELECT @max_loop_cnt = 0
                    SELECT @mst_loop_cnt = 0
                    SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_sub_delimiter) -- 프로시저 LOOP 길이를 판단 ='|'

            	    WHILE @mst_loop_cnt < @max_loop_cnt
            	    	 BEGIN
            	    		 
                             SELECT @mst_loop_cnt  = @mst_loop_cnt +1
                             SELECT @v_month_info  = [dbo].[SCM_ARR_SPL_VAL](@p_month_info ,@v_sub_delimiter, @mst_loop_cnt)
				    
            	    		 SELECT @v_Tmp1 += '          , SUM(CASE WHEN C.YYYYMM='''+ @v_month_info +''' THEN (CASE WHEN A.PLAN_TYPE = ''RELEASE'' AND B.CATEGORY_ID=''P_IN_KG'' THEN CEILING(A.ADJUST_IN_QTY_KG) ' + char(10)
            	    		 SELECT @v_Tmp1 += '                             WHEN A.PLAN_TYPE = ''RELEASE'' AND B.CATEGORY_ID=''P_IN_BATCH'' THEN ROUND(A.ADJUST_IN_QTY_BATCH,3)   ' + char(10)
            	    		 SELECT @v_Tmp1 += '                             WHEN A.PLAN_TYPE = ''RELEASE'' AND B.CATEGORY_ID=''P_OUT_KG'' THEN CEILING(A.ADJUST_OUT_QTY_KG)       ' + char(10)
            	    		 SELECT @v_Tmp1 += '                             WHEN A.PLAN_TYPE = ''RELEASE'' AND B.CATEGORY_ID=''P_OUT_BATCH'' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,3) ' + char(10)
          		    
            	    		 SELECT @v_Tmp1 += '                             WHEN A.PLAN_TYPE = ''MPP'' AND B.CATEGORY_ID=''P_MPP_IN_KG'' THEN CEILING(A.ADJUST_IN_QTY_KG)         ' + char(10)
            	    		 SELECT @v_Tmp1 += '                             WHEN A.PLAN_TYPE = ''MPP'' AND B.CATEGORY_ID=''P_MPP_IN_BATCH'' THEN ROUND(A.ADJUST_IN_QTY_BATCH,3)   ' + char(10)
            	    		 SELECT @v_Tmp1 += '                             WHEN A.PLAN_TYPE = ''MPP'' AND B.CATEGORY_ID=''P_MPP_OUT_KG'' THEN CEILING(A.ADJUST_OUT_QTY_KG)       ' + char(10)
            	    		 SELECT @v_Tmp1 += '                             WHEN A.PLAN_TYPE = ''MPP'' AND B.CATEGORY_ID=''P_MPP_OUT_BATCH'' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,3) ' + char(10)
                    
            	    		 SELECT @v_Tmp1 += '                             WHEN A.PLAN_TYPE = ''WPP'' AND B.CATEGORY_ID=''P_WPP_IN_KG'' THEN CEILING(A.ADJUST_IN_QTY_KG)         ' + char(10)
            	    		 SELECT @v_Tmp1 += '                             WHEN A.PLAN_TYPE = ''WPP'' AND B.CATEGORY_ID=''P_WPP_IN_BATCH'' THEN ROUND(A.ADJUST_IN_QTY_BATCH,3)   ' + char(10)
            	    		 SELECT @v_Tmp1 += '                             WHEN A.PLAN_TYPE = ''WPP'' AND B.CATEGORY_ID=''P_WPP_OUT_KG'' THEN CEILING(A.ADJUST_OUT_QTY_KG)       ' + char(10)
            	    		 SELECT @v_Tmp1 += '                             WHEN A.PLAN_TYPE = ''WPP'' AND B.CATEGORY_ID=''P_WPP_OUT_BATCH'' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,3) ' + char(10)
            	    
            	    		 SELECT @v_Tmp1 += '                             WHEN A.PLAN_TYPE = ''RESULT'' AND B.CATEGORY_ID=''P_RESULT_IN_KG'' THEN CEILING(A.ADJUST_RESULT_IN_QTY_KG)         ' + char(10)
            	    		 SELECT @v_Tmp1 += '                             WHEN A.PLAN_TYPE = ''RESULT'' AND B.CATEGORY_ID=''P_RESULT_IN_BATCH'' THEN ROUND(A.ADJUST_RESULT_IN_QTY_BATCH,3)   ' + char(10)
            	    		 SELECT @v_Tmp1 += '                             WHEN A.PLAN_TYPE = ''RESULT'' AND B.CATEGORY_ID=''P_RESULT_OUT_KG'' THEN CEILING(A.ADJUST_RESULT_OUT_QTY_KG)       ' + char(10)
            	    		 SELECT @v_Tmp1 += '                             WHEN A.PLAN_TYPE = ''RESULT'' AND B.CATEGORY_ID=''P_RESULT_OUT_BATCH'' THEN ROUND(A.ADJUST_RESULT_OUT_QTY_BATCH,3) ' + char(10)
            	    		 SELECT @v_Tmp1 += '                             WHEN A.PLAN_TYPE = ''OFFTIME'' AND B.CATEGORY_ID=''P_OFFTIME'' THEN A.OFF_TIME  ' + char(10)
            	    		 SELECT @v_Tmp1 += '                             WHEN B.CATEGORY_ID =''P_SEQ'' THEN NULL   ' + char(10)
            	    		 SELECT @v_Tmp1 += '                             WHEN B.CATEGORY_ID =''P_MEMO'' THEN NULL  ' + char(10)
            	    		 SELECT @v_Tmp1 += '                             ELSE 0 END) ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' + char(10)
				    
            	    	 END

            	    -- weekinfo
            	    SELECT @v_Tmp2       = ''
            	    SELECT @max_loop_cnt = 0
            	    SELECT @mst_loop_cnt = 0
            	    SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_sub_delimiter) -- 프로시저 LOOP 길이를 판단 = '|'
            	    
					WHILE @mst_loop_cnt < @max_loop_cnt
            	    	BEGIN
                            SELECT @mst_loop_cnt = @mst_loop_cnt +1 
						    SELECT @v_week_info  = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_sub_delimiter, @mst_loop_cnt)
				    
            	    		 SELECT @v_Tmp2 += '          , SUM(CASE WHEN C.ISO_YYYYWW='''+ @v_week_info +''' THEN (CASE WHEN A.PLAN_TYPE = ''RELEASE'' AND B.CATEGORY_ID=''P_IN_KG'' THEN CEILING(A.ADJUST_IN_QTY_KG) ' + char(10)
            	    		 SELECT @v_Tmp2 += '                             WHEN A.PLAN_TYPE = ''RELEASE'' AND B.CATEGORY_ID=''P_IN_BATCH'' THEN ROUND(A.ADJUST_IN_QTY_BATCH,3)   ' + char(10)
            	    		 SELECT @v_Tmp2 += '                             WHEN A.PLAN_TYPE = ''RELEASE'' AND B.CATEGORY_ID=''P_OUT_KG'' THEN CEILING(A.ADJUST_OUT_QTY_KG)       ' + char(10)
            	    		 SELECT @v_Tmp2 += '                             WHEN A.PLAN_TYPE = ''RELEASE'' AND B.CATEGORY_ID=''P_OUT_BATCH'' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,3) ' + char(10)
				    
            	    		 SELECT @v_Tmp2 += '                             WHEN A.PLAN_TYPE = ''MPP'' AND B.CATEGORY_ID=''P_MPP_IN_KG'' THEN CEILING(A.ADJUST_IN_QTY_KG)         ' + char(10)
            	    		 SELECT @v_Tmp2 += '                             WHEN A.PLAN_TYPE = ''MPP'' AND B.CATEGORY_ID=''P_MPP_IN_BATCH'' THEN ROUND(A.ADJUST_IN_QTY_BATCH,3)   ' + char(10)
            	    		 SELECT @v_Tmp2 += '                             WHEN A.PLAN_TYPE = ''MPP'' AND B.CATEGORY_ID=''P_MPP_OUT_KG'' THEN CEILING(A.ADJUST_OUT_QTY_KG)       ' + char(10)
            	    		 SELECT @v_Tmp2 += '                             WHEN A.PLAN_TYPE = ''MPP'' AND B.CATEGORY_ID=''P_MPP_OUT_BATCH'' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,3) ' + char(10)
				    
            	    		 SELECT @v_Tmp2 += '                             WHEN A.PLAN_TYPE = ''WPP'' AND B.CATEGORY_ID=''P_WPP_IN_KG'' THEN CEILING(A.ADJUST_IN_QTY_KG)         ' + char(10)
            	    		 SELECT @v_Tmp2 += '                             WHEN A.PLAN_TYPE = ''WPP'' AND B.CATEGORY_ID=''P_WPP_IN_BATCH'' THEN ROUND(A.ADJUST_IN_QTY_BATCH,3)   ' + char(10)
            	    		 SELECT @v_Tmp2 += '                             WHEN A.PLAN_TYPE = ''WPP'' AND B.CATEGORY_ID=''P_WPP_OUT_KG'' THEN CEILING(A.ADJUST_OUT_QTY_KG)       ' + char(10)
            	    		 SELECT @v_Tmp2 += '                             WHEN A.PLAN_TYPE = ''WPP'' AND B.CATEGORY_ID=''P_WPP_OUT_BATCH'' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,3) ' + char(10)
				    
            	    		 SELECT @v_Tmp2 += '                             WHEN A.PLAN_TYPE = ''RESULT'' AND B.CATEGORY_ID=''P_RESULT_IN_KG'' THEN CEILING(A.ADJUST_RESULT_IN_QTY_KG)         ' + char(10)
            	    		 SELECT @v_Tmp2 += '                             WHEN A.PLAN_TYPE = ''RESULT'' AND B.CATEGORY_ID=''P_RESULT_IN_BATCH'' THEN ROUND(A.ADJUST_RESULT_IN_QTY_BATCH,3)   ' + char(10)
            	    		 SELECT @v_Tmp2 += '                             WHEN A.PLAN_TYPE = ''RESULT'' AND B.CATEGORY_ID=''P_RESULT_OUT_KG'' THEN CEILING(A.ADJUST_RESULT_OUT_QTY_KG)       ' + char(10)
            	    		 SELECT @v_Tmp2 += '                             WHEN A.PLAN_TYPE = ''RESULT'' AND B.CATEGORY_ID=''P_RESULT_OUT_BATCH'' THEN ROUND(A.ADJUST_RESULT_OUT_QTY_BATCH,3) ' + char(10)
            	    		 SELECT @v_Tmp2 += '                             WHEN A.PLAN_TYPE = ''OFFTIME'' AND B.CATEGORY_ID=''P_OFFTIME'' THEN A.OFF_TIME ' + char(10)
            	    		 SELECT @v_Tmp2 += '                             WHEN B.CATEGORY_ID=''P_SEQ'' THEN NULL  ' + char(10)
            	    		 SELECT @v_Tmp2 += '                             WHEN B.CATEGORY_ID=''P_MEMO'' THEN NULL ' + char(10)
            	    		 SELECT @v_Tmp2 += '                             ELSE 0 END) ELSE 0 END) AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' + char(10)
				    
            	    	END
            	    
            	  -- dayinfo
                  SELECT @v_Tmp3       = ''
				  SELECT @max_loop_cnt = 0
                  SELECT @mst_loop_cnt = 0
                  SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_sub_delimiter) -- 프로시저 LOOP 길이를 판단
                  
            	  WHILE @mst_loop_cnt < @max_loop_cnt
            	  	  BEGIN
                          SELECT @mst_loop_cnt = @mst_loop_cnt +1     
                          SELECT @v_day_info   = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_sub_delimiter, @mst_loop_cnt)
				  		  
            	  		  SELECT @v_Tmp3 += '          , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)='''+ @v_day_info +''' THEN (CASE WHEN A.PLAN_TYPE = ''RELEASE'' AND B.CATEGORY_ID=''P_IN_KG'' THEN CEILING(A.ADJUST_IN_QTY_KG) ' + char(10)
            	  		  SELECT @v_Tmp3 += '                             WHEN A.PLAN_TYPE = ''RELEASE'' AND B.CATEGORY_ID=''P_IN_BATCH'' THEN ROUND(A.ADJUST_IN_QTY_BATCH,3)   ' + char(10)
            	  		  SELECT @v_Tmp3 += '                             WHEN A.PLAN_TYPE = ''RELEASE'' AND B.CATEGORY_ID=''P_OUT_KG'' THEN CEILING(A.ADJUST_OUT_QTY_KG)       ' + char(10);
            	  		  SELECT @v_Tmp3 += '                             WHEN A.PLAN_TYPE = ''RELEASE'' AND B.CATEGORY_ID=''P_OUT_BATCH'' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,3) ' + char(10)
				  		 								                 
            	  		  SELECT @v_Tmp3 += '                             WHEN A.PLAN_TYPE = ''MPP'' AND B.CATEGORY_ID=''P_MPP_IN_KG'' THEN CEILING(A.ADJUST_IN_QTY_KG)         ' + char(10)
            	  		  SELECT @v_Tmp3 += '                             WHEN A.PLAN_TYPE = ''MPP'' AND B.CATEGORY_ID=''P_MPP_IN_BATCH'' THEN ROUND(A.ADJUST_IN_QTY_BATCH,3)   ' + char(10)
            	  		  SELECT @v_Tmp3 += '                             WHEN A.PLAN_TYPE = ''MPP'' AND B.CATEGORY_ID=''P_MPP_OUT_KG'' THEN CEILING(A.ADJUST_OUT_QTY_KG)       ' + char(10)
            	  		  SELECT @v_Tmp3 += '                             WHEN A.PLAN_TYPE = ''MPP'' AND B.CATEGORY_ID=''P_MPP_OUT_BATCH'' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,3) ' + char(10)
				  		 								                 
            	  		  SELECT @v_Tmp3 += '                             WHEN A.PLAN_TYPE = ''WPP'' AND B.CATEGORY_ID=''P_WPP_IN_KG'' THEN CEILING(A.ADJUST_IN_QTY_KG)         ' + char(10)
            	  		  SELECT @v_Tmp3 += '                             WHEN A.PLAN_TYPE = ''WPP'' AND B.CATEGORY_ID=''P_WPP_IN_BATCH'' THEN ROUND(A.ADJUST_IN_QTY_BATCH,3)   ' + char(10)
            	  		  SELECT @v_Tmp3 += '                             WHEN A.PLAN_TYPE = ''WPP'' AND B.CATEGORY_ID=''P_WPP_OUT_KG'' THEN CEILING(A.ADJUST_OUT_QTY_KG)       ' + char(10)
            	  		  SELECT @v_Tmp3 += '                             WHEN A.PLAN_TYPE = ''WPP'' AND B.CATEGORY_ID=''P_WPP_OUT_BATCH'' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,3) ' + char(10)
				  		 								                 
            	  		  SELECT @v_Tmp3 += '                             WHEN A.PLAN_TYPE = ''RESULT'' AND B.CATEGORY_ID=''P_RESULT_IN_KG'' THEN CEILING(A.ADJUST_RESULT_IN_QTY_KG)         ' + char(10)
            	  		  SELECT @v_Tmp3 += '                             WHEN A.PLAN_TYPE = ''RESULT'' AND B.CATEGORY_ID=''P_RESULT_IN_BATCH'' THEN ROUND(A.ADJUST_RESULT_IN_QTY_BATCH,3)   ' + char(10)
            	  		  SELECT @v_Tmp3 += '                             WHEN A.PLAN_TYPE = ''RESULT'' AND B.CATEGORY_ID=''P_RESULT_OUT_KG'' THEN CEILING(A.ADJUST_RESULT_OUT_QTY_KG)       ' + char(10)
            	  		  SELECT @v_Tmp3 += '                             WHEN A.PLAN_TYPE = ''RESULT'' AND B.CATEGORY_ID=''P_RESULT_OUT_BATCH'' THEN ROUND(A.ADJUST_RESULT_OUT_QTY_BATCH,3) ' + char(10)
            	  		  SELECT @v_Tmp3 += '                             WHEN A.PLAN_TYPE = ''OFFTIME'' AND B.CATEGORY_ID=''P_OFFTIME'' THEN A.OFF_TIME ' + char(10)
            	  		  SELECT @v_Tmp3 += '                             WHEN B.CATEGORY_ID=''P_SEQ'' THEN A.SEQ ' + char(10)
            	  		  SELECT @v_Tmp3 += '                             WHEN B.CATEGORY_ID=''P_MEMO'' THEN NULL ' + char(10)
            	  		  SELECT @v_Tmp3 += '                             ELSE 0 END) ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' + char(10)
            	  
            	  	  END 
                END --END IF
    
			SELECT @v_dSql1 = @v_dSql1 + @v_Tmp1 + @v_Tmp2 + @v_Tmp3 + @v_Tmp4

			SELECT @v_dSql1 += '          , B.CATEGORY_ID, B.CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql1 += '          , ''DATA'' AS DATA_TYPE           ' + char(10)
			SELECT @v_dSql1 += '     FROM (                                 ' + char(10)
			SELECT @v_dSql1 += '           SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID   ' + char(10)
			SELECT @v_dSql1 += '               , A.LOCATION, A.OPERATION_ID, D.OPERATION_NAME                        ' + char(10)
			SELECT @v_dSql1 += '               , A.LINE_ID, ISNULL(C.LINE_NAME,''-'') AS LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql1 += '               , A.EQUIPMENT_ID    ' + char(10)
			SELECT @v_dSql1 += '               , A.PLAN_DATE       ' + char(10)
			SELECT @v_dSql1 += '               , A.TOP_ITEM_ID, A.ITEM_ID, ISNULL(B.NICK_NAME,''-'') AS NICK_NAME    ' + char(10)
			SELECT @v_dSql1 += '               , A.PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql1 += '               , A.MARKET          ' + char(10)
			SELECT @v_dSql1 += '               , A.PLAN_TYPE       ' + char(10)
			SELECT @v_dSql1 += '               , A.ADJUST_IN_QTY_BATCH, A.ADJUST_IN_QTY, A.ADJUST_IN_QTY_KG    ' + char(10)
			SELECT @v_dSql1 += '               , A.ADJUST_OUT_QTY_BATCH, A.ADJUST_OUT_QTY, A.ADJUST_OUT_QTY_KG ' + char(10)
			SELECT @v_dSql1 += '               , A.ADJUST_RESULT_IN_QTY_BATCH, A.ADJUST_RESULT_IN_QTY_KG       ' + char(10)
			SELECT @v_dSql1 += '               , A.ADJUST_RESULT_OUT_QTY_BATCH, A.ADJUST_RESULT_OUT_QTY_KG     ' + char(10)
			SELECT @v_dSql1 += '               , A.SEQ               ' + char(10)
			SELECT @v_dSql1 += '               , A.OFF_TIME          ' + char(10)
			SELECT @v_dSql1 += '               , A.BGCOLOR           ' + char(10)
			SELECT @v_dSql1 += '               , C.PROD_VERSION_TYPE ' + char(10)
			SELECT @v_dSql1 += '          FROM (                     ' + char(10)
			SELECT @v_dSql1 += '                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += '                    , A.LOCATION, A.OPERATION_ID                     ' + char(10)
			SELECT @v_dSql1 += '                    , A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql1 += '                    , A.EQUIPMENT_ID                                 ' + char(10)
			SELECT @v_dSql1 += '                    , A.PLAN_DATE                                    ' + char(10)
			SELECT @v_dSql1 += '                    , A.ITEM_ID AS TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME ' + char(10)
			SELECT @v_dSql1 += '                    , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql1 += '                    , A.MARKET                                ' + char(10)
			SELECT @v_dSql1 += '                    , A.PLAN_TYPE                             ' + char(10)
			SELECT @v_dSql1 += '                    , A.BATCH_IN_QTY AS ADJUST_IN_QTY_BATCH, A.PLAN_IN_QTY AS ADJUST_IN_QTY, A.PLAN_IN_QTY AS ADJUST_IN_QTY_KG ' + char(10)
			SELECT @v_dSql1 += '                    , A.BATCH_OUT_QTY AS ADJUST_OUT_QTY_BATCH, A.PLAN_QTY AS ADJUST_OUT_QTY, A.PLAN_QTY AS ADJUST_OUT_QTY_KG   ' + char(10)
			SELECT @v_dSql1 += '                    , 0 AS ADJUST_RESULT_IN_QTY_BATCH,  0 AS ADJUST_RESULT_IN_QTY_KG  ' + char(10)
			SELECT @v_dSql1 += '                    , 0 AS ADJUST_RESULT_OUT_QTY_BATCH, 0 AS ADJUST_RESULT_OUT_QTY_KG ' + char(10)
			SELECT @v_dSql1 += '                    , SEQ             ' + char(10)
			SELECT @v_dSql1 += '                    , 0 AS OFF_TIME   ' + char(10)
			SELECT @v_dSql1 += '                    , null AS BGCOLOR ' + char(10)
			SELECT @v_dSql1 += '                FROM  FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)        ' + char(10)
			SELECT @v_dSql1 += '                WHERE  1=1                                              ' + char(10)
			SELECT @v_dSql1 += '                AND    A.PLAN_TYPE IN ( ''RELEASE'', ''MPP'', ''WPP'' ) ' + char(10)
			SELECT @v_dSql1 += '                AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN  ' + @v_bucket_from + ' AND ' + @v_bucket_to + ' ' + char(10)


			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.DIVISION_ID' , 'EQ', @p_division_id))        + char(10)
			IF(LEN(@p_site_id) > 0)
			    BEGIN
			        SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.SITE_ID' , 'EQ', @p_site_id))        + char(10)
				END
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))              + char(10)
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))          + char(10) 
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))      + char(10)
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))                + char(10)
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type))   + char(10)
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id))                + char(10)

			SELECT @v_dSql1 += '                AND  (A.BATCH_IN_QTY + A.PLAN_IN_QTY + A.ROLL_IN_QTY + A.BATCH_OUT_QTY + A.PLAN_QTY + A.ROLL_OUT_QTY ) > 0 ' + char(10)
			SELECT @v_dSql1 += '                UNION ALL                                                               ' + char(10)
			SELECT @v_dSql1 += '                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += '                       , A.LOCATION, A.OPERATION_ID                     ' + char(10)
			SELECT @v_dSql1 += '                       , A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql1 += '                       , A.EQUIPMENT_ID                              ' + char(10)
			SELECT @v_dSql1 += '                       , A.PLAN_DATE                                 ' + char(10)
			SELECT @v_dSql1 += '                       , A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME ' + char(10)
			SELECT @v_dSql1 += '                       , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE     ' + char(10)
			SELECT @v_dSql1 += '                       , A.MARKET                                    ' + char(10)
			SELECT @v_dSql1 += '                       , ''RESULT'' AS PLAN_TYPE                     ' + char(10)
			SELECT @v_dSql1 += '                       , 0 AS ADJUST_IN_QTY_BATCH, 0 AS ADJUST_IN_QTY, 0 AS ADJUST_IN_QTY_KG               ' + char(10)
			SELECT @v_dSql1 += '                       , 0 AS ADJUST_OUT_QTY_BATCH, 0 AS ADJUST_OUT_QTY, 0 AS ADJUST_OUT_QTY_KG            ' + char(10)
			SELECT @v_dSql1 += '                       , A.BATCH_IN_QTY AS ADJUST_RESULT_IN_QTY_BATCH, A.QTY AS ADJUST_RESULT_IN_QTY_KG    ' + char(10)
			SELECT @v_dSql1 += '                       , A.BATCH_OUT_QTY AS ADJUST_RESULT_OUT_QTY_BATCH, A.QTY AS ADJUST_RESULT_OUT_QTY_KG ' + char(10)
			SELECT @v_dSql1 += '                       , null AS SEQ                           ' + char(10)
			SELECT @v_dSql1 += '                       , 0 AS OFF_TIME                         ' + char(10)
			SELECT @v_dSql1 += '                       , null AS BGCOLOR                       ' + char(10)
			SELECT @v_dSql1 += '                FROM SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '                WHERE  1=1                                     ' + char(10)
			SELECT @v_dSql1 += '                AND  CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN ' + @v_bucket_from + ' AND ' + @v_bucket_to + ' ' + char(10)

			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.DIVISION_ID' , 'EQ', @p_division_id))        + char(10)
			IF(LEN(@p_site_id) > 0)
			    BEGIN
			        SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                A.SITE_ID' , 'EQ', @p_site_id))        + char(10)
				END
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))              + char(10)
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))          + char(10) 
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))      + char(10)
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))                + char(10)
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type))   + char(10)
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_top_item_id))        + char(10)
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id))                + char(10)

			SELECT @v_dSql1 += '                UNION ALL                                                  ' + char(10)
			SELECT @v_dSql1 += '                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += '                    , A.LOCATION, A.OPERATION_ID                     ' + char(10)
			SELECT @v_dSql1 += '                    , A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql1 += '                    , A.EQUIPMENT_ID                                 ' + char(10)
			SELECT @v_dSql1 += '                    , B.OFF_DATE AS PLAN_DATE                        ' + char(10)
			SELECT @v_dSql1 += '                    , A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME    ' + char(10)
			SELECT @v_dSql1 += '                    , A.PRODUCTION_TYPE                              ' + char(10)
			SELECT @v_dSql1 += '                    , A.MARKET                                       ' + char(10)
			SELECT @v_dSql1 += '                    , ''OFFTIME'' AS PLAN_TYPE                       ' + char(10)
			SELECT @v_dSql1 += '                    , 0 AS ADJUST_IN_QTY_BATCH, 0 AS ADJUST_IN_QTY, 0 AS ADJUST_IN_QTY_KG    ' + char(10)
			SELECT @v_dSql1 += '                    , 0 AS ADJUST_OUT_QTY_BATCH, 0 AS ADJUST_OUT_QTY, 0 AS ADJUST_OUT_QTY_KG ' + char(10)
			SELECT @v_dSql1 += '                    , 0 AS ADJUST_RESULT_IN_QTY_BATCH, 0 AS ADJUST_RESULT_IN_QTY_KG          ' + char(10)
			SELECT @v_dSql1 += '                    , 0 AS ADJUST_RESULT_OUT_QTY_BATCH, 0 AS ADJUST_RESULT_OUT_QTY_KG        ' + char(10)
			SELECT @v_dSql1 += '                    , '''' SEQ               ' + char(10)
			SELECT @v_dSql1 += '                    , B.OFF_TIME AS OFF_TIME ' + char(10)
			SELECT @v_dSql1 += '                    , null AS BGCOLOR        ' + char(10)

			SELECT @v_dSql1 += '                FROM (                                      ' + char(10)
			SELECT @v_dSql1 += '                      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID, A.TOP_ITEM_ID, A.ITEM_ID, A.PRODUCTION_TYPE, A.MARKET' + char(10)
			SELECT @v_dSql1 += '                      FROM (                                                            ' + char(10)
			SELECT @v_dSql1 += '                            SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID, A.ITEM_ID AS TOP_ITEM_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '                            		, A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE, A.MARKET ' + char(10)
			SELECT @v_dSql1 += '                            FROM FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)             ' + char(10)
			SELECT @v_dSql1 += '                            WHERE  1=1                                                  ' + char(10)
			SELECT @v_dSql1 += '                            AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN ' + @v_bucket_from + ' AND ' + @v_bucket_to + ' ' + char(10)
			SELECT @v_dSql1 += '                            AND    A.PLAN_TYPE IN ( ''RELEASE'', ''WPP'', ''MPP'' ) ' + char(10)

			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.DIVISION_ID' , 'EQ', @p_division_id))        + char(10)
			IF(LEN(@p_site_id) > 0)
			    BEGIN
			        SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.SITE_ID' , 'EQ', @p_site_id))        + char(10)
				END
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))              + char(10)
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))          + char(10) 
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))      + char(10)
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))                + char(10)
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type))   + char(10)
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_top_item_id))                + char(10)
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id))                + char(10)
			


			SELECT @v_dSql1 += '                            AND  (A.BATCH_IN_QTY + A.PLAN_IN_QTY + A.ROLL_IN_QTY + A.CELL_IN_QTY + A.JR_IN_QTY + A.BATCH_OUT_QTY + A.PLAN_QTY + A.ROLL_OUT_QTY + A.CELL_OUT_QTY + A.JR_OUT_QTY) > 0' + char(10)
			SELECT @v_dSql1 += '                            UNION ALL                              ' + char(10)
			SELECT @v_dSql1 += '                            SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID, A.TOP_ITEM_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '                            		, A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE, A.MARKET ' + char(10)
			SELECT @v_dSql1 += '                            FROM SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK)              ' + char(10)
			SELECT @v_dSql1 += '                            WHERE  1=1                                                  ' + char(10)
			SELECT @v_dSql1 += '                            AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN ' + @v_bucket_from + ' AND ' + @v_bucket_to + ' ' + char(10)

			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.DIVISION_ID' , 'EQ', @p_division_id))        + char(10)
			IF(LEN(@p_site_id) > 0)
			    BEGIN
			        SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.SITE_ID' , 'EQ', @p_site_id))        + char(10)
				END
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.PLANT_ID' , 'EQ', @p_plant_id))              + char(10)
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.FACTORY_ID' , 'EQ', @p_factory_id))          + char(10) 
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.OPERATION_ID' , 'EQ', @p_operation_id))      + char(10)
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.LINE_ID' , 'EQ', @p_line_id))                + char(10)
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                            A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type))   + char(10)
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_top_item_id))                + char(10)
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id))                + char(10)


			SELECT @v_dSql1 += '                            AND    A.BATCH_OUT_QTY > 0 ' + char(10)
			SELECT @v_dSql1 += '                        ) A                            ' + char(10)
			SELECT @v_dSql1 += '                    WHERE 1=1                          ' + char(10)
			SELECT @v_dSql1 += '                    GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID, A.TOP_ITEM_ID, A.ITEM_ID, A.PRODUCTION_TYPE, A.MARKET ' + char(10)
			SELECT @v_dSql1 += '               ) A         ' + char(10)
			SELECT @v_dSql1 += '           LEFT OUTER JOIN ' + char(10)
			SELECT @v_dSql1 += '           (               ' + char(10)
			SELECT @v_dSql1 += '               SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, T.EQUIPMENT_ID ' + char(10)
			SELECT @v_dSql1 += '                     , CONVERT(VARCHAR, A.OFF_DATE, 112) AS OFF_DATE, A.OFF_TIME_TERM AS OFF_TIME ' + char(10)
			SELECT @v_dSql1 += '               FROM   SCM_OFF_CALENDAR_LINE_V A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '               INNER JOIN SCM_LINE_M B WITH(NOLOCK)       ' + char(10)
			SELECT @v_dSql1 += '               ON     A.COMPANY_ID     = B.COMPANY_ID     ' + char(10)
			SELECT @v_dSql1 += '               AND    A.DIVISION_ID    = B.DIVISION_ID    ' + char(10)
			SELECT @v_dSql1 += '               AND    A.SITE_ID        = B.SITE_ID        ' + char(10)
			SELECT @v_dSql1 += '               AND    A.PLANT_ID       = B.PLANT_ID       ' + char(10)
			SELECT @v_dSql1 += '               AND    A.FACTORY_ID     = B.FACTORY_ID     ' + char(10)
			SELECT @v_dSql1 += '               AND    A.OPERATION_ID   = B.OPERATION_ID   ' + char(10)
			SELECT @v_dSql1 += '               AND    A.LINE_ID        = B.LINE_ID        ' + char(10)
			SELECT @v_dSql1 += '               AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql1 += '               LEFT OUTER JOIN SCM_EQUIPMENT_M T WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '               ON    T.COMPANY_ID     = B.COMPANY_ID     ' + char(10)
			SELECT @v_dSql1 += '               AND   T.DIVISION_ID    = B.DIVISION_ID    ' + char(10)
			SELECT @v_dSql1 += '               AND   T.SITE_ID        = B.SITE_ID        ' + char(10)
			SELECT @v_dSql1 += '               AND   T.PLANT_ID       = B.PLANT_ID       ' + char(10)
			SELECT @v_dSql1 += '               AND   T.FACTORY_ID     = B.FACTORY_ID     ' + char(10)
			SELECT @v_dSql1 += '               AND   T.OPERATION_ID   = B.OPERATION_ID   ' + char(10)
			SELECT @v_dSql1 += '               AND   T.LINE_ID        = B.LINE_ID        ' + char(10)
			SELECT @v_dSql1 += '               AND   T.ELECTRODE_TYPE = B.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql1 += '               AND   T.ACTIVE_FLAG     = ''Y''           ' + char(10)
			SELECT @v_dSql1 += '               AND   T.EQUIPMENT_TYPE  = ''M''           ' + char(10)
			SELECT @v_dSql1 += '               WHERE  B.ACTIVE_FLAG    = ''Y''           ' + char(10)
			SELECT @v_dSql1 += '               AND    CONVERT(VARCHAR, A.OFF_DATE, 112) BETWEEN ' + @v_bucket_from + ' AND ' + @v_bucket_to + ' ' + char(10)


			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('               A.DIVISION_ID' , 'EQ', @p_division_id))        + char(10)
			IF(LEN(@p_site_id) > 0)
			    BEGIN
			        SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('               A.SITE_ID' , 'EQ', @p_site_id))        + char(10)
				END
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('               A.PLANT_ID' , 'EQ', @p_plant_id))              + char(10)
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('               A.FACTORY_ID' , 'EQ', @p_factory_id))          + char(10) 
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('               A.OPERATION_ID' , 'EQ', @p_operation_id))      + char(10)
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('               A.LINE_ID' , 'EQ', @p_line_id))                + char(10)

			SELECT @v_dSql1 += '           ) B                                       ' + char(10)
			SELECT @v_dSql1 += '           ON    A.COMPANY_ID     = B.COMPANY_ID     ' + char(10)
			SELECT @v_dSql1 += '           AND   A.DIVISION_ID    = B.DIVISION_ID    ' + char(10)
			SELECT @v_dSql1 += '           AND   A.SITE_ID        = B.SITE_ID        ' + char(10)
			SELECT @v_dSql1 += '           AND   A.PLANT_ID       = B.PLANT_ID       ' + char(10)
			SELECT @v_dSql1 += '           AND   A.FACTORY_ID     = B.FACTORY_ID     ' + char(10)
			SELECT @v_dSql1 += '           AND   A.OPERATION_ID   = B.OPERATION_ID   ' + char(10)
			SELECT @v_dSql1 += '           AND   A.LINE_ID        = B.LINE_ID        ' + char(10)
			SELECT @v_dSql1 += '           AND   A.ELECTRODE_TYPE = B.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql1 += '       ) A                                           ' + char(10)
			SELECT @v_dSql1 += '       INNER JOIN   SCM_ITEM_M B WITH(NOLOCK)        ' + char(10)
			SELECT @v_dSql1 += '       ON     A.COMPANY_ID     = B.COMPANY_ID        ' + char(10)
			SELECT @v_dSql1 += '       AND    A.DIVISION_ID    = B.DIVISION_ID       ' + char(10)
			SELECT @v_dSql1 += '       AND    A.SITE_ID        = B.SITE_ID           ' + char(10)
			SELECT @v_dSql1 += '       AND    A.TOP_ITEM_ID    = B.ITEM_ID           ' + char(10)
			
			IF(LEN(@p_nick_name_lt) > 0)
			    BEGIN
			        SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('ISNULL(B.NICK_NAME,''-'')' , 'EQ', @p_nick_name_lt))        + char(10)
				END

			SELECT @v_dSql1 += '       INNER JOIN SCM_LINE_M C WITH(NOLOCK)       ' + char(10)
			SELECT @v_dSql1 += '       ON     A.COMPANY_ID     = C.COMPANY_ID     ' + char(10)
			SELECT @v_dSql1 += '       AND    A.DIVISION_ID    = C.DIVISION_ID    ' + char(10)
			SELECT @v_dSql1 += '       AND    A.SITE_ID        = C.SITE_ID        ' + char(10)
			SELECT @v_dSql1 += '       AND    A.PLANT_ID       = C.PLANT_ID       ' + char(10)
			SELECT @v_dSql1 += '       AND    A.FACTORY_ID     = C.FACTORY_ID     ' + char(10)
			SELECT @v_dSql1 += '       AND    A.OPERATION_ID   = C.OPERATION_ID   ' + char(10)
			SELECT @v_dSql1 += '       AND    A.LINE_ID        = C.LINE_ID        ' + char(10)
			SELECT @v_dSql1 += '       AND    A.ELECTRODE_TYPE = C.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql1 += '       INNER JOIN SCM_OPERATION_M D WITH(NOLOCK)  ' + char(10)
			SELECT @v_dSql1 += '       ON     A.COMPANY_ID     = D.COMPANY_ID     ' + char(10)
			SELECT @v_dSql1 += '       AND    A.DIVISION_ID    = D.DIVISION_ID    ' + char(10)
			SELECT @v_dSql1 += '       AND    A.SITE_ID        = D.SITE_ID        ' + char(10)
			SELECT @v_dSql1 += '       AND    A.OPERATION_ID   = D.OPERATION_ID   ' + char(10)
			SELECT @v_dSql1 += '       WHERE 1=1                                ' + char(10)
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.NICK_NAME' , 'LIKE', @p_nick_name))        + char(10)
			SELECT @v_dSql1 += '  ) A                                       ' + char(10)
			SELECT @v_dSql1 += '  INNER JOIN (     ' + char(10)
            SELECT @v_dSql1 += '         SELECT *  ' + char(10)
            SELECT @v_dSql1 += '         FROM (    ' + char(10)

            SELECT @v_dSql1 = @v_dSql1 + @v_pSql

            SELECT @v_dSql1 += '           ) A     ' + char(10)
            SELECT @v_dSql1 += '           WHERE CATEGORY_ID <> ''X'' ' + char(10)
            SELECT @v_dSql1 += '       ) B                            ' + char(10)
            SELECT @v_dSql1 += '       ON 1=1                         ' + char(10)
            SELECT @v_dSql1 += '       INNER HASH JOIN TH_UIS_CAL C WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql1 += '       ON  A.PLAN_DATE = C.DT                    ' + char(10)
            SELECT @v_dSql1 += '       LEFT OUTER JOIN (                         ' + char(10)
            SELECT @v_dSql1 += '            SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PMIX_ITEM_ID ' + char(10)
            SELECT @v_dSql1 += '                 , MAX(CASE WHEN A.CLASS_NAME = ''Binder''  AND A.UI_COLUMN = ''Binder 1'' THEN A.DESCRIPTION END) AS BINDER_1 ' + char(10)
            SELECT @v_dSql1 += '                 , MAX(CASE WHEN A.CLASS_NAME = ''Binder''  AND A.UI_COLUMN = ''Binder 2'' THEN A.DESCRIPTION END) AS BINDER_2 ' + char(10)
            SELECT @v_dSql1 += '                 , MAX(CASE WHEN A.CLASS_NAME = ''Conducting Material'' AND A.UI_COLUMN = ''Conducting Material 1'' THEN A.DESCRIPTION END) AS CONDUCTING_MATERIAL ' + char(10)
            SELECT @v_dSql1 += '                 , MAX(CASE WHEN A.CLASS_NAME = ''Solvent''  AND A.UI_COLUMN = ''Solvent 1'' THEN A.DESCRIPTION END) AS SOLVENT ' + char(10)
            SELECT @v_dSql1 += '            FROM   SCM_PDS_MATERIAL_V A ' + char(10)
            SELECT @v_dSql1 += '            WHERE  1=1                  ' + char(10)

			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('            A.DIVISION_ID' , 'EQ', @p_division_id))        + char(10)
			IF(LEN(@p_site_id) > 0)
			    BEGIN
			        SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('            A.SITE_ID' , 'EQ', @p_site_id))        + char(10)
				END
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('            A.PLANT_ID' , 'EQ', @p_plant_id))              + char(10)
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('            A.PMIX_ITEM_ID' , 'LK', @p_item_id))              + char(10)
			
			SELECT @v_dSql1 += '            GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PMIX_ITEM_ID ' + char(10)
            SELECT @v_dSql1 += '        ) E ' + char(10)

            SELECT @v_dSql1 += '        ON  A.COMPANY_ID      = E.COMPANY_ID   '  + char(10)
            SELECT @v_dSql1 += '        AND A.DIVISION_ID     = E.DIVISION_ID  '  + char(10)
            SELECT @v_dSql1 += '        AND A.SITE_ID         = E.SITE_ID      '  + char(10)
            SELECT @v_dSql1 += '        AND A.PLANT_ID        = E.PLANT_ID     '  + char(10)
            SELECT @v_dSql1 += '        AND A.ITEM_ID         = E.PMIX_ITEM_ID '  + char(10)
            SELECT @v_dSql1 += '        GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID '  + char(10)
            SELECT @v_dSql1 += '            , A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME '  + char(10)
            SELECT @v_dSql1 += '            , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE     '  + char(10)
            SELECT @v_dSql1 += '            , A.EQUIPMENT_ID                               '  + char(10)
            SELECT @v_dSql1 += '            , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME        '  + char(10)
            SELECT @v_dSql1 += '            , A.PRODUCTION_TYPE, A.MARKET                  '  + char(10)
            SELECT @v_dSql1 += '            , B.CATEGORY_ID, B.CATEGORY_NAME, B.MEASURE_NAME, B.CATEGORY_ORDER '  + char(10)
            SELECT @v_dSql1 += '            , E.BINDER_1, E.BINDER_2 '  + char(10)
            SELECT @v_dSql1 += '            , E.CONDUCTING_MATERIAL  '  + char(10)
            SELECT @v_dSql1 += '            , E.SOLVENT              '  + char(10)
            SELECT @v_dSql1 += '    )                                '  + char(10)

			SELECT @v_dSql2  = ''
			SELECT @v_dSql2 += ' -- v_dSql2     ' + char(10)
			SELECT @v_dSql2 += '  , T_CHANGE AS (      ' + char(10)
			SELECT @v_dSql2 += '         SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += '             , A.LOCATION, A.OPERATION_ID              ' + char(10)
			SELECT @v_dSql2 += '             , A.LINE_ID, A.ELECTRODE_TYPE             ' + char(10)
			SELECT @v_dSql2 += '             , A.EQUIPMENT_ID                          ' + char(10)
			SELECT @v_dSql2 += '             , A.ITEM_ID AS TOP_ITEM_ID, A.ITEM_ID     ' + char(10)
			SELECT @v_dSql2 += '             , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql2 += '             , A.MARKET                                ' + char(10)

			IF ISNULL(@p_day_info,'') <> '' 
				BEGIN
                    SELECT @v_Tmp1 = ''
				    SELECT @max_loop_cnt = 0
                    SELECT @mst_loop_cnt = 0
                    SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_sub_delimiter) -- 프로시저 LOOP 길이를 판단 ='|'
                  
					IF @max_loop_cnt > 0 
						BEGIN
							WHILE @mst_loop_cnt < @max_loop_cnt
                                BEGIN
								     SELECT @mst_loop_cnt = @mst_loop_cnt +1     
                                     SELECT @v_day_info   = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_sub_delimiter, @mst_loop_cnt)

                                     SELECT @v_Tmp1 += '             , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)='''+  @v_day_info +''' THEN ( CASE WHEN (A.FULL_CLEANING_FLAG = ''Y'' AND A.MODEL_TYPE_CHANGE_FLAG = ''Y'' ) OR A.FULL_CLEANING_FLAG = ''Y'' THEN ''F'' ' + char(10)
                                     SELECT @v_Tmp1 += '             													 	  WHEN A.MODEL_TYPE_CHANGE_FLAG = ''Y'' THEN ''M''                                  ' + char(10)
                                     SELECT @v_Tmp1 += '             													 	  ELSE NULL END ) ELSE NULL END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +'_BG ' + char(10)
                                END
						END 
				END

			SELECT @v_dSql2 = @v_dSql2 + @v_Tmp1

			SELECT @v_dSql2 += '         FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql2 += '         WHERE  1=0                                        ' + char(10)
			SELECT @v_dSql2 += '         AND CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN ' + @v_plan_date + ' AND ' + @v_bucket_to + ' ' + char(10)

			SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('        A.DIVISION_ID' , 'EQ', @p_division_id))        + char(10)
			IF(LEN(@p_site_id) > 0)
			    BEGIN
			        SELECT @v_dSql2+= (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('        A.SITE_ID' , 'EQ', @p_site_id))        + char(10)
				END
			SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('        A.PLANT_ID' , 'EQ', @p_plant_id))              + char(10)
			SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('        A.FACTORY_ID' , 'EQ', @p_factory_id))          + char(10) 
			SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('        A.OPERATION_ID' , 'EQ', @p_operation_id))      + char(10)
			SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('        A.LINE_ID' , 'EQ', @p_line_id))                + char(10)
			SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('        A.PRODUCTION_TYPE' , 'EQ', @p_prod_type))      + char(10)
			SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id))              + char(10)
			SELECT @v_dSql2 += '         GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += '             , A.LOCATION, A.OPERATION_ID  ' + char(10)
			SELECT @v_dSql2 += '             , A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql2 += '             , A.EQUIPMENT_ID              ' + char(10)
			SELECT @v_dSql2 += '             , A.ITEM_ID                   ' + char(10)
			SELECT @v_dSql2 += '             , A.FP_PRODUCTION_TYPE        ' + char(10)
			SELECT @v_dSql2 += '             , A.MARKET	                   ' + char(10)
			SELECT @v_dSql2 += '        )           	                   ' + char(10)

			SELECT @v_dSql3  = ''
			SELECT @v_dSql3 += ' -- v_dSql3     ' + char(10)
			SELECT @v_dSql3 += '  , T_RELEASE AS (            ' + char(10)
			SELECT @v_dSql3 += '          SELECT A.FACTORY_ID ' + char(10)

			IF ISNULL(@p_day_info,'') <> '' 
				BEGIN
                    SELECT @v_Tmp1 = ''
				    SELECT @max_loop_cnt = 0
                    SELECT @mst_loop_cnt = 0
                    SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_sub_delimiter) -- 프로시저 LOOP 길이를 판단 ='|'

					IF @max_loop_cnt > 0 
						BEGIN
							WHILE @mst_loop_cnt < @max_loop_cnt
                                BEGIN
								     SELECT @mst_loop_cnt = @mst_loop_cnt +1     
                                     SELECT @v_day_info   = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_sub_delimiter, @mst_loop_cnt)
                                     
									 SELECT @v_Tmp1 += '              , MAX(CASE WHEN CONVERT(VARCHAR,A.RELEASE_DATE,112)='''+  @v_day_info +''' THEN ''Y'' ELSE NULL END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +'_BG ' + char(10)
                                END
						END 
				END

			SELECT @v_dSql3 = @v_dSql3 + @v_Tmp1

			SELECT @v_dSql3 += '          FROM (       ' + char(10)
			SELECT @v_dSql3 += '                SELECT A.FACTORY_ID, CONVERT(VARCHAR,B.INSERT_TIME,112) AS RELEASE_DATE ' + char(10)
			SELECT @v_dSql3 += '                FROM ( ' + char(10)
			SELECT @v_dSql3 += '                      SELECT  A.INSTANCE_ID, A.RELEASE_PLAN_ID AS PLAN_ID, ''BUILDING'' AS CONFIRM_AREA ' + char(10)
			SELECT @v_dSql3 += '                          , A.FACTORY_ID, A.INSERT_TIME                                                 ' + char(10)
			SELECT @v_dSql3 += '                          , DENSE_RANK() OVER(PARTITION BY A.FACTORY_ID ORDER BY A.INSERT_TIME DESC) SORT_ORDER ' + char(10)
			SELECT @v_dSql3 += '                      FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)          ' + char(10)
			SELECT @v_dSql3 += '                          , (                                               ' + char(10)
			SELECT @v_dSql3 += '                              SELECT DISTINCT A.INSTANCE_ID, A.FACTORY_ID   ' + char(10)
			SELECT @v_dSql3 += '                              FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK)   ' + char(10)
			SELECT @v_dSql3 += '                              WHERE  A.ACTIVE_FLAG = ''Y''                  ' + char(10)
			SELECT @v_dSql3 += '                              AND    A.INSTANCE_ID = ' + @v_instance_id + ' ' + char(10)
			SELECT @v_dSql3 += '                            ) B                                             ' + char(10)
			SELECT @v_dSql3 += '                      WHERE  A.INSTANCE_ID  = B.INSTANCE_ID                 ' + char(10)
			SELECT @v_dSql3 += '                      AND    A.FACTORY_ID   = B.FACTORY_ID                  ' + char(10)
			SELECT @v_dSql3 += '                      AND    A.INSTANCE_ID  = ' + @v_instance_id + '        ' + char(10)
			SELECT @v_dSql3 += '                ) A                                  ' + char(10)
			SELECT @v_dSql3 += '                , SCM_FP_PLAN_H B WITH(NOLOCK)       ' + char(10)
			SELECT @v_dSql3 += '                WHERE A.INSTANCE_ID  = B.INSTANCE_ID ' + char(10)
			SELECT @v_dSql3 += '                AND   A.PLAN_ID      = B.PLAN_ID     ' + char(10)
			SELECT @v_dSql3 += '                AND   A.SORT_ORDER   = 1             ' + char(10)
			SELECT @v_dSql3 += '                AND   A.CONFIRM_AREA IN (            ' + char(10)
			SELECT @v_dSql3 += '                              SELECT MAX(A.ATTRIBUTE1) AS CONFIRM_AREA           ' + char(10)
			SELECT @v_dSql3 += '                              FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)         ' + char(10)
			SELECT @v_dSql3 += '                              WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_ID''        ' + char(10)
			SELECT @v_dSql3 += '                              AND    A.SEGMENT1         = ' + @v_instance_id + ' ' + char(10)
			SELECT @v_dSql3 += '                              AND    A.ACTIVE_FLAG      = ''Y''                  ' + char(10)
			SELECT @v_dSql3 += '                          )                                                      ' + char(10)
		    SELECT @v_dSql3 += '           ) A                   ' + char(10)
		    SELECT @v_dSql3 += '           GROUP BY A.FACTORY_ID ' + char(10)
		    SELECT @v_dSql3 += '  )          ' + char(10)
		    SELECT @v_dSql3 += '  SELECT A.* ' + char(10)

			IF ISNULL(@p_day_info,'') <> '' 
				BEGIN
                    SELECT @v_Tmp1 = ''
				    SELECT @max_loop_cnt = 0
                    SELECT @mst_loop_cnt = 0
                    SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_sub_delimiter) -- 프로시저 LOOP 길이를 판단 ='|'
                  
					IF @max_loop_cnt > 0 
						BEGIN
							WHILE @mst_loop_cnt < @max_loop_cnt
                                BEGIN

								     SELECT @mst_loop_cnt = @mst_loop_cnt +1     
                                     SELECT @v_day_info   = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_sub_delimiter, @mst_loop_cnt)
                                     
                                     SELECT @v_Tmp1 += '              ,	CASE WHEN A.DATA_TYPE=''TOTAL_2'' THEN ''#FFBA85'' ' + char(10)
                                     SELECT @v_Tmp1 += '              		 WHEN A.DATA_TYPE=''TOTAL'' THEN ''#FFE5C2'' ' + char(10)
                                     SELECT @v_Tmp1 += '              		 WHEN A.DATA_TYPE=''DATA'' THEN (CASE WHEN E.D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +'_BG = ''F'' THEN ''#00D8FF'' WHEN E.D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +'_BG = ''M'' THEN ''#E3C4FF'' WHEN F.D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +'_BG = ''Y'' THEN ''#FFFFE6'' ELSE '''' END ) ' + char(10)
                                     SELECT @v_Tmp1 += '              		 ELSE '''' END AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +'_BG ' + char(10)

                                END
						END 
				END

			SELECT @v_dSql3 = @v_dSql3 + @v_Tmp1

		    SELECT @v_dSql3 += '  FROM (                   ' + char(10)
		    SELECT @v_dSql3 += '        SELECT * FROM MAIN ' + char(10)
		    SELECT @v_dSql3 += '        UNION ALL          ' + char(10)
		    SELECT @v_dSql3 += '        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME ' + char(10)
		    SELECT @v_dSql3 += '            , A.LINE_ID, ''Total'' AS LINE_NAME, A.ELECTRODE_TYPE, NULL AS EQUIPMENT_ID ' + char(10)
		    SELECT @v_dSql3 += '            , NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME                   ' + char(10)
		    SELECT @v_dSql3 += '            , NULL AS PRODUCTION_TYPE, NULL AS MARKET ' + char(10)
		    SELECT @v_dSql3 += '            , NULL AS BINDER_1, NULL AS BINDER_2      ' + char(10)
		    SELECT @v_dSql3 += '            , NULL AS CONDUCTING_MATERIAL             ' + char(10)
		    SELECT @v_dSql3 += '            , NULL AS SOLVENT                         ' + char(10)
		    SELECT @v_dSql3 += '            , A.CATEGORY_NAME                         ' + char(10)
		    SELECT @v_dSql3 += '            , A.MEASURE_NAME                          ' + char(10)

			IF ISNULL(@p_day_info,'') <> ''
                BEGIN --START IF
                    
				    SELECT @max_loop_cnt = 0
                    SELECT @mst_loop_cnt = 0
                    SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_sub_delimiter) -- 프로시저 LOOP 길이를 판단 ='|'
                  
                    IF @max_loop_cnt > 0 
                        BEGIN --START2 IF

                    	    -- monthinfo
							SELECT @mst_loop_cnt = 0	
                    	    SELECT @max_loop_cnt = 0
                    	    SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_sub_delimiter) -- 프로시저 LOOP 길이를 판단
                    	    SELECT @v_Tmp1       = ''

						    WHILE @mst_loop_cnt < @max_loop_cnt
                    	        BEGIN
								     SELECT @mst_loop_cnt = @mst_loop_cnt +1     
                                     SELECT @v_month_info   = [dbo].[SCM_ARR_SPL_VAL](@p_month_info ,@v_sub_delimiter, @mst_loop_cnt)
                                     
                      	             SELECT @v_Tmp1 += '            , SUM(M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +') AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +' ' + char(10)
                    	        END
                    	    
                    	    -- weekinfo
                    	    SELECT @mst_loop_cnt = 0	
                    	    SELECT @max_loop_cnt = 0
                    	    SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_sub_delimiter) -- 프로시저 LOOP 길이를 판단
                    	    SELECT @v_Tmp2       = ''
                    	    
							WHILE @mst_loop_cnt < @max_loop_cnt
                    	        BEGIN
								     SELECT @mst_loop_cnt = @mst_loop_cnt +1     
                                     SELECT @v_month_info = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_sub_delimiter, @mst_loop_cnt)

                      	             SELECT @v_Tmp2 += '            , SUM(W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)+') AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +' ' + char(10)					
                    	        END
                    	    
                    	    -- dayinfo
                    	    SELECT @mst_loop_cnt = 0	
                    	    SELECT @max_loop_cnt = 0
                    	    SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_sub_delimiter) -- 프로시저 LOOP 길이를 판단
                    	    SELECT @v_Tmp3       = ''

                    	    WHILE @mst_loop_cnt < @max_loop_cnt
                    	        BEGIN
								     SELECT @mst_loop_cnt = @mst_loop_cnt +1     
                                     SELECT @v_month_info = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_sub_delimiter, @mst_loop_cnt)
                      	             
									 SELECT @v_Tmp3 += '            , SUM(D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + ') AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +' ' + char(10)
                    	        END
                        END --END2 IF
                END --END IF

			SELECT @v_dSql3  = @v_dSql3 + @v_Tmp1 + @v_Tmp2 + @v_Tmp3

		    SELECT @v_dSql3 += '            , A.CATEGORY_ID, A.CATEGORY_ORDER ' + char(10)
		    SELECT @v_dSql3 += '            , ''TOTAL'' AS DATA_TYPE          ' + char(10)
		    SELECT @v_dSql3 += '        FROM   MAIN A                         ' + char(10)
		    SELECT @v_dSql3 += '        GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
		    SELECT @v_dSql3 += '            ,A.CATEGORY_NAME, A.MEASURE_NAME, A.CATEGORY_ID, A.CATEGORY_ORDER ' + char(10)


		    SELECT @v_dSql3 += '        -- Total  ' + char(10)
		    SELECT @v_dSql3 += '        UNION ALL ' + char(10)
		    SELECT @v_dSql3 += '        SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID, NULL AS FACTORY_ID, NULL AS LOCATION, NULL AS OPERATION_ID, NULL AS OPERATION_NAME ' + char(10)
		    SELECT @v_dSql3 += '              ,NULL AS LINE_ID, ''Total'' AS LINE_NAME, NULL AS ELECTRODE_TYPE, NULL AS EQUIPMENT_ID ' + char(10)
		    SELECT @v_dSql3 += '              ,NULL AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME ' + char(10)
		    SELECT @v_dSql3 += '              ,NULL AS PRODUCTION_TYPE, NULL AS MARKET ' + char(10)
		    SELECT @v_dSql3 += '              ,NULL AS BINDER_1, NULL AS BINDER_2      ' + char(10)
		    SELECT @v_dSql3 += '              ,NULL AS CONDUCTING_MATERIAL             ' + char(10)
		    SELECT @v_dSql3 += '              ,NULL AS SOLVENT                         ' + char(10)
		    SELECT @v_dSql3 += '              ,A.CATEGORY_NAME                         ' + char(10)
		    SELECT @v_dSql3 += '              ,A.MEASURE_NAME                          ' + char(10)
			
			IF ISNULL(@p_day_info,'') <> ''
                BEGIN
				    SELECT @max_loop_cnt = 0
                    SELECT @mst_loop_cnt = 0
                    SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_sub_delimiter) -- 프로시저 LOOP 길이를 판단 ='|' 

                    IF @max_loop_cnt > 0 
                        BEGIN
                    	    -- monthinfo
							SELECT @mst_loop_cnt = 0	
                    	    SELECT @max_loop_cnt = 0
                    	    SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_sub_delimiter) -- 프로시저 LOOP 길이를 판단
                    	    SELECT @v_Tmp1       = ''
                    	    
							WHILE @mst_loop_cnt < @max_loop_cnt
                    	        BEGIN
								    SELECT @mst_loop_cnt = @mst_loop_cnt +1     
                                    SELECT @v_month_info   = [dbo].[SCM_ARR_SPL_VAL](@p_month_info ,@v_sub_delimiter, @mst_loop_cnt)

                      	            SELECT @v_Tmp1 += '            , SUM(M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +') AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +' ' + char(10)
                    	        END
                    	    
                    	    -- weekinfo
                    	    SELECT @mst_loop_cnt = 0	
                    	    SELECT @max_loop_cnt = 0
                    	    SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_sub_delimiter) -- 프로시저 LOOP 길이를 판단
                    	    SELECT @v_Tmp2       = ''
                    	   
						    WHILE @mst_loop_cnt < @max_loop_cnt
                    	        BEGIN
								    SELECT @mst_loop_cnt = @mst_loop_cnt +1     
                                    SELECT @v_week_info   = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_sub_delimiter, @mst_loop_cnt)

                      	            SELECT @v_Tmp2 += '            , SUM(W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)+') AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +' ' + char(10)
                    	        END
                    	    
                    	    -- dayinfo
                    	    SELECT @mst_loop_cnt = 0	
                    	    SELECT @max_loop_cnt = 0
                    	    SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_sub_delimiter) -- 프로시저 LOOP 길이를 판단
                    	    SELECT @v_Tmp3       = ''

                    	    WHILE @mst_loop_cnt < @max_loop_cnt
                    	        BEGIN
								    SELECT @mst_loop_cnt = @mst_loop_cnt +1     
                                    SELECT @v_day_info   = [dbo].[SCM_ARR_SPL_VAL](@p_day_info ,@v_sub_delimiter, @mst_loop_cnt)

                      	            SELECT @v_Tmp3 += '            , SUM(D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + ') AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +' ' + char(10)
                    	        END
                        END 
                END

			SELECT @v_dSql3  = @v_dSql3 + @v_Tmp1 + @v_Tmp2 + @v_Tmp3

		    SELECT @v_dSql3 += '              ,A.CATEGORY_ID, A.CATEGORY_ORDER ' + char(10)
		    SELECT @v_dSql3 += '              ,''TOTAL_2'' AS DATA_TYPE        ' + char(10)
		    SELECT @v_dSql3 += '        FROM   MAIN A                          ' + char(10)
		    SELECT @v_dSql3 += '        GROUP BY A.CATEGORY_NAME, A.MEASURE_NAME, A.CATEGORY_ID, A.CATEGORY_ORDER ' + char(10)
		    SELECT @v_dSql3 += '   ) A                                        ' + char(10)
		    SELECT @v_dSql3 += '   LEFT OUTER JOIN SCM_ITEM_M B WITH(NOLOCK)  ' + char(10)
		    SELECT @v_dSql3 += '   ON  A.COMPANY_ID  = B.COMPANY_ID           ' + char(10)
		    SELECT @v_dSql3 += '   AND A.DIVISION_ID = B.DIVISION_ID          ' + char(10)
		    SELECT @v_dSql3 += '   AND A.SITE_ID     = B.SITE_ID              ' + char(10)
		    SELECT @v_dSql3 += '   AND A.ITEM_ID     = B.ITEM_ID              ' + char(10)
		    SELECT @v_dSql3 += '   LEFT OUTER JOIN SCM_LINE_M C WITH(NOLOCK)  ' + char(10)
		    SELECT @v_dSql3 += '   ON     A.COMPANY_ID     = C.COMPANY_ID     ' + char(10)
		    SELECT @v_dSql3 += '   AND    A.DIVISION_ID    = C.DIVISION_ID    ' + char(10)
		    SELECT @v_dSql3 += '   AND    A.SITE_ID        = C.SITE_ID        ' + char(10)
		    SELECT @v_dSql3 += '   AND    A.PLANT_ID       = C.PLANT_ID       ' + char(10)
		    SELECT @v_dSql3 += '   AND    A.FACTORY_ID     = C.FACTORY_ID     ' + char(10)
		    SELECT @v_dSql3 += '   AND    A.OPERATION_ID   = C.OPERATION_ID   ' + char(10)
		    SELECT @v_dSql3 += '   AND    A.LINE_ID        = C.LINE_ID        ' + char(10)
		    SELECT @v_dSql3 += '   AND    A.ELECTRODE_TYPE = C.ELECTRODE_TYPE ' + char(10)
		    SELECT @v_dSql3 += '   LEFT OUTER JOIN T_CHANGE E WITH(NOLOCK)    ' + char(10)
		    SELECT @v_dSql3 += '   ON  A.COMPANY_ID      = E.COMPANY_ID       ' + char(10)
		    SELECT @v_dSql3 += '   AND A.DIVISION_ID     = E.DIVISION_ID      ' + char(10)
		    SELECT @v_dSql3 += '   AND A.SITE_ID         = E.SITE_ID          ' + char(10)
		    SELECT @v_dSql3 += '   AND A.PLANT_ID        = E.PLANT_ID         ' + char(10)
		    SELECT @v_dSql3 += '   AND A.FACTORY_ID      = E.FACTORY_ID       ' + char(10)
		    SELECT @v_dSql3 += '   AND A.OPERATION_ID    = E.OPERATION_ID     ' + char(10)
		    SELECT @v_dSql3 += '   AND A.LINE_ID         = E.LINE_ID          ' + char(10)
		    SELECT @v_dSql3 += '   AND A.ELECTRODE_TYPE  = E.ELECTRODE_TYPE   ' + char(10)
		    SELECT @v_dSql3 += '   AND A.EQUIPMENT_ID    = E.EQUIPMENT_ID     ' + char(10)
		    SELECT @v_dSql3 += '   AND A.PRODUCTION_TYPE = E.PRODUCTION_TYPE  ' + char(10)
		    SELECT @v_dSql3 += '   AND A.MARKET          = E.MARKET           ' + char(10)
		    SELECT @v_dSql3 += '   AND A.TOP_ITEM_ID     = E.TOP_ITEM_ID      ' + char(10)
		    SELECT @v_dSql3 += '   AND A.ITEM_ID         = E.ITEM_ID          ' + char(10)
		    SELECT @v_dSql3 += '   LEFT OUTER JOIN T_RELEASE F WITH(NOLOCK)   ' + char(10)
		    SELECT @v_dSql3 += '   ON 1=1                                     ' + char(10)
		    SELECT @v_dSql3 += '   AND A.FACTORY_ID = F.FACTORY_ID            ' + char(10) 
		    SELECT @v_dSql3 += '   ORDER BY (CASE WHEN A.DATA_TYPE = ''TOTAL_2'' THEN A.CATEGORY_ORDER ELSE 999 END) ' + char(10) 
		    SELECT @v_dSql3 += '          , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID ' + char(10) 
		    SELECT @v_dSql3 += '          , (CASE WHEN A.DATA_TYPE=''DATA'' THEN 1 ELSE A.CATEGORY_ORDER END) ' + char(10) 
		    SELECT @v_dSql3 += '          , A.EQUIPMENT_ID, A.TOP_ITEM_ID, A.ITEM_ID      ' + char(10) 
		    SELECT @v_dSql3 += '          , A.PRODUCTION_TYPE, A.MARKET, A.ELECTRODE_TYPE ' + char(10) 
		    SELECT @v_dSql3 += '          , A.CATEGORY_ORDER                              ' + char(10) 

			SELECT @v_dSql =  @v_dSql1 + @v_dSql2 + @v_dSql3

		END --MAIN IF

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
            SELECT @v_dSql += ' AND	 CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN ' + @v_bucket_from +' AND ' + @v_bucket_to +' ' + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))                  + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))                          + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))                        + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))                    + char(10) 
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))                + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))                          + char(10)
			
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'LIKE', @p_prod_type)) + char(10)
			
            SELECT @v_dSql += ' GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                   ' + char(10)
            SELECT @v_dSql += '     , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID                           ' + char(10)
            SELECT @v_dSql += '     , A.ITEM_ID, A.TOP_ITEM_ID, A.PRODUCTION_TYPE, A.MARKET                                 ' + char(10)

		END
--------------------------------------------------------------------------------------------------------------------------------------------------------------
	IF @p_sys_type = 'SQL'
		BEGIN
			--EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,',',@v_dSql,'select',@runstart, @runend
			SELECT @v_dSql as [QUERY_VALUE]

		END  
	ELSE 
		BEGIN
			SET @runstart = GetDate()
			--쿼리실행
			EXEC sp_executesql @v_dSql

			SET @runend = GetDate()
			EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,@p_sys_flag,'',@v_dSql,'select',@runstart, @runend
		END
END
