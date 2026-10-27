
CREATE PROCEDURE [dbo].[PR_UI_FP00634_FIND_FP00634]
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
/** 프로그램 ID   : PR_UI_FP00634_FIND_FP00634                                                **/
/** 프로그램 명   : Procedure PR_UI_FP00634_FIND_FP00634                                      **/
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
/** 2021-08-24     XPDbToProcedure      Auto Generated With Initial Setting                   **/
/** 2023-06-19     LJS					활성화 분리 처리                                      **/
/** 2024-03-13     CYS					PKG 인스턴스 정보 발췌 - ELEC_ASSY_INSTANCE_MAP 룩업 변경      **/ -- (D240313~R240313.01)
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00634_FIND_FP00634
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP00634_FIND_FP00634'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_plan_date nvarchar(max) = ''
  DECLARE @p_instance_id nvarchar(max) = ''
  DECLARE @p_plan_id nvarchar(max) = ''
  DECLARE @p_ nvarchar(max) = ''
  DECLARE @p_bucket_from nvarchar(max) = ''
  DECLARE @p_bucket_to nvarchar(max) = ''
  DECLARE @p_site_id nvarchar(max) = ''
  DECLARE @p_operation_id nvarchar(max) = ''
  DECLARE @p_item_id nvarchar(max) = ''
  DECLARE @p_group_tray_id nvarchar(max) = ''
  DECLARE @p_release_flag nvarchar(max) = ''
  DECLARE @p_chk_planid nvarchar(max) = ''
  DECLARE @p_bucket nvarchar(max) = ''
  DECLARE @p_week_info nvarchar(max) = ''
  DECLARE @p_month_info nvarchar(max) = ''
  DECLARE @p_plan_type nvarchar(max) = ''
  DECLARE @p_division_id nvarchar(max) = ''
  DECLARE @p_plant_id nvarchar(max) = ''
  DECLARE @p_factory_id nvarchar(max) = ''
  DECLARE @p_line_id nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_categoryinfo nvarchar(max) = ''
  DECLARE @p_ctrl_date nvarchar(max) = ''
  DECLARE @p_ctrl_cate nvarchar(max) = ''
  DECLARE @p_ctrl_catf nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''
  DECLARE @p_tray_opt	NVARCHAR(MAX) = ''
  DECLARE @p_factory_opt	NVARCHAR(MAX) = ''
  DECLARE @p_factory_opt2	NVARCHAR(MAX) = ''

  DECLARE @v_plan_date nvarchar(max)
  DECLARE @v_instance_id nvarchar(max)
  DECLARE @v_plan_id nvarchar(max)
  DECLARE @v_ nvarchar(max)
  DECLARE @v_bucket_from nvarchar(max)
  DECLARE @v_bucket_to nvarchar(max)
  DECLARE @v_site_id nvarchar(max)
  DECLARE @v_operation_id nvarchar(max)
  DECLARE @v_item_id nvarchar(max)
  DECLARE @v_group_tray_id nvarchar(max)
  DECLARE @v_release_flag nvarchar(max)
  DECLARE @v_chk_planid nvarchar(max)
  DECLARE @v_bucket nvarchar(max)
  DECLARE @v_week_info nvarchar(max)
  DECLARE @v_month_info nvarchar(max)
  DECLARE @v_plan_type nvarchar(max)
  DECLARE @v_division_lt nvarchar(max)
  DECLARE @v_plant_lt nvarchar(max)
  DECLARE @v_factory_lt nvarchar(max)
  DECLARE @v_line_lt nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_categoryinfo nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  DECLARE @opt_0 nvarchar(max)
  DECLARE @opt_1site_id nvarchar(max)
  DECLARE @opt_2site_id nvarchar(max)
  DECLARE @opt_3site_id nvarchar(max)
  DECLARE @opt_4site_id nvarchar(max)
  DECLARE @opt_5site_id nvarchar(max)
  DECLARE @opt_6item_id nvarchar(max)
  DECLARE @opt_7site_id nvarchar(max)
  DECLARE @opt_8item_id nvarchar(max)
  DECLARE @opt_9 nvarchar(max)
  DECLARE @opt_10site_id nvarchar(max)
  DECLARE @opt_11site_id nvarchar(max)
  DECLARE @opt_12site_id nvarchar(max)
  DECLARE @opt_13site_id nvarchar(max)
  DECLARE @opt_14site_id nvarchar(max)
  DECLARE @opt_15item_id nvarchar(max)
  DECLARE @opt_16site_id nvarchar(max)
  DECLARE @opt_17group_tray_id nvarchar(max)
  DECLARE @opt_18site_id nvarchar(max)
  DECLARE @opt_19site_id nvarchar(max)
  DECLARE @opt_20site_id nvarchar(max)
  DECLARE @opt_21site_id nvarchar(max)
  DECLARE @opt_22site_id nvarchar(max)
  DECLARE @opt_23item_id nvarchar(max)
  DECLARE @opt_24site_id nvarchar(max)
  DECLARE @opt_25item_id nvarchar(max)
  DECLARE @opt_26site_id nvarchar(max)
  DECLARE @opt_27site_id nvarchar(max)
  DECLARE @opt_28site_id nvarchar(max)
  DECLARE @opt_29site_id nvarchar(max)
  DECLARE @opt_30site_id nvarchar(max)
  DECLARE @opt_31item_id nvarchar(max)
  DECLARE @opt_32site_id nvarchar(max)
  DECLARE @opt_33group_tray_id nvarchar(max)

  --Optional Parameter Part END

  SET @v_delimiter            = '^'  -- 데이터 구분자
  SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@in_columns, @v_delimiter) -- 프로시저 LOOP 길이를 판단
  DECLARE @tmp_column nvarchar(MAX) = ''
  WHILE @mst_loop_cnt < @max_loop_cnt
  BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
	SET @mst_loop_cnt = @mst_loop_cnt + 1;	-- @mst_loop_cnt 1증가

	SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @in_columns			    ,@v_delimiter, @mst_loop_cnt);
	IF @tmp_column = '_SAVE_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLAN_DATE' BEGIN
      SET @p_plan_date =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'INSTANCE_ID' BEGIN
      SET @p_instance_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLAN_ID' BEGIN
      SET @p_plan_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = '' BEGIN
      SET @p_ =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'BUCKET_FROM' BEGIN
      SET @p_bucket_from =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'BUCKET_TO' BEGIN
      SET @p_bucket_to =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'SITE_ID' BEGIN
      SET @p_site_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'OPERATION_ID' BEGIN
      SET @p_operation_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ITEM_ID' BEGIN
      SET @p_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'GROUP_TRAY_ID' BEGIN
      SET @p_group_tray_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'RELEASE_FLAG' BEGIN
      SET @p_release_flag =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'CHK_PLANID' BEGIN
      SET @p_chk_planid =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'BUCKET' BEGIN
      SET @p_bucket =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'WEEK_INFO' BEGIN
      SET @p_week_info =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'MONTH_INFO' BEGIN
      SET @p_month_info =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLAN_TYPE' BEGIN
      SET @p_plan_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
      SET @p_division_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLANT_ID' BEGIN
      SET @p_plant_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'FACTORY_ID' BEGIN
      SET @p_factory_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'LINE_ID' BEGIN
      SET @p_line_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PARAM' BEGIN
      SET @p_param =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'CATEGORYINFO' BEGIN
      SET @p_categoryinfo =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'CTRL_DATE' BEGIN
      SET @p_ctrl_date =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'CTRL_CATE' BEGIN
      SET @p_ctrl_cate =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'CTRL_CATF' BEGIN
      SET @p_ctrl_catf =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
      SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END

	SELECT	@p_tray_opt = CASE WHEN ISNULL(C.ATTRIBUTE1,'SITE') = 'SITE' THEN 'N' ELSE 'Y' END
	FROM	SCM_SYS_LOOKUP_VALUE C                                                                                          
	WHERE	1=1                                                                                                                          
	AND		C.LOOKUP_TYPE_CODE = 'FORM_TRAY_SIMUL_OPTION'                                                                         
	AND		C.ACTIVE_FLAG = 'Y'       
	AND		C.SEGMENT1 = @p_instance_id

	--IF @p_tray_opt = 'N' BEGIN
	--	SET @p_factory_opt = ' , ''-'' AS FACTORY_ID	' +char(10)
	--	SET @p_factory_opt2 = ' , ''-''	' +char(10)
	--END ELSE BEGIN
	--	SET @p_factory_opt = ' , A.FACTORY_ID	' +char(10)
	--	SET @p_factory_opt2 = ' , A.FACTORY_ID	' +char(10)
	--END


  --SET @p_user_id = dbo.FN_deCRYPT_AES128(@p_user_id)
  
  SET @v_plan_date ='''' + @p_plan_date + ''''
  SET @v_instance_id ='''' + @p_instance_id + ''''
  SET @v_plan_id ='''' + @p_plan_id + ''''
  SET @v_ ='''' + @p_ + ''''
  SET @v_bucket_from ='''' + @p_bucket_from + ''''
  SET @v_bucket_to ='''' + @p_bucket_to + ''''
  SET @v_site_id ='''' + @p_site_id + ''''
  SET @v_operation_id ='''' + @p_operation_id + ''''
  SET @v_item_id ='''' + @p_item_id + ''''
  SET @v_group_tray_id ='''' + @p_group_tray_id + ''''
  SET @v_release_flag ='''' + @p_release_flag + ''''
  SET @v_chk_planid ='''' + @p_chk_planid + ''''
  SET @v_bucket ='''' + @p_bucket + ''''
  SET @v_week_info ='''' + @p_week_info + ''''
  SET @v_month_info ='''' + @p_month_info + ''''
  SET @v_plan_type ='''' + @p_plan_type + ''''
  --SET @v_division_lt ='''' + @p_division_lt + ''''
  --SET @v_plant_lt ='''' + @p_plant_lt + ''''
  --SET @v_factory_lt ='''' + @p_factory_lt + ''''
  --SET @v_line_lt ='''' + @p_line_lt + ''''
  SET @v_param ='''' + @p_param + ''''
  SET @v_categoryinfo ='''' + @p_categoryinfo + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''

  SET @STRLEN = LEN(@p_)
  IF @STRLEN< 1  BEGIN
    SET @opt_0 = ''
  END ELSE BEGIN
    SET @opt_0 = 'i'
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_1site_id = ''
  END ELSE BEGIN
    SET @opt_1site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_2site_id = ''
  END ELSE BEGIN
    SET @opt_2site_id = 'AND    C.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_3site_id = ''
  END ELSE BEGIN
    SET @opt_3site_id = 'AND    E.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_4site_id = ''
  END ELSE BEGIN
    SET @opt_4site_id = 'AND    F.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_5site_id = ''
  END ELSE BEGIN
    SET @opt_5site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_6item_id = ''
  END ELSE BEGIN
    SET @opt_6item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_7site_id = ''
  END ELSE BEGIN
    SET @opt_7site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_8item_id = ''
  END ELSE BEGIN
    SET @opt_8item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_)
  IF @STRLEN< 1  BEGIN
    SET @opt_9 = ''
  END ELSE BEGIN
    SET @opt_9 = 'i'
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_10site_id = ''
  END ELSE BEGIN
    SET @opt_10site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_11site_id = ''
  END ELSE BEGIN
    SET @opt_11site_id = 'AND    C.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_12site_id = ''
  END ELSE BEGIN
    SET @opt_12site_id = 'AND    E.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_13site_id = ''
  END ELSE BEGIN
    SET @opt_13site_id = 'AND    F.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_14site_id = ''
  END ELSE BEGIN
    SET @opt_14site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_15item_id = ''
  END ELSE BEGIN
    SET @opt_15item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_16site_id = ''
  END ELSE BEGIN
    SET @opt_16site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_group_tray_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_17group_tray_id = ''
  END ELSE BEGIN
    SET @opt_17group_tray_id = 'AND   A.GROUP_TRAY_ID LIKE ''%'' + RTRIM(LTRIM(' + @v_group_tray_id+')) + ''%'''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_18site_id = ''
  END ELSE BEGIN
    SET @opt_18site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_19site_id = ''
  END ELSE BEGIN
    SET @opt_19site_id = 'AND    C.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_20site_id = ''
  END ELSE BEGIN
    SET @opt_20site_id = 'AND    E.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_21site_id = ''
  END ELSE BEGIN
    SET @opt_21site_id = 'AND    F.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_22site_id = ''
  END ELSE BEGIN
    SET @opt_22site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_23item_id = ''
  END ELSE BEGIN
    SET @opt_23item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_24site_id = ''
  END ELSE BEGIN
    SET @opt_24site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_25item_id = ''
  END ELSE BEGIN
    SET @opt_25item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_26site_id = ''
  END ELSE BEGIN
    SET @opt_26site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_27site_id = ''
  END ELSE BEGIN
    SET @opt_27site_id = 'AND    C.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_28site_id = ''
  END ELSE BEGIN
    SET @opt_28site_id = 'AND    E.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_29site_id = ''
  END ELSE BEGIN
    SET @opt_29site_id = 'AND    F.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_30site_id = ''
  END ELSE BEGIN
    SET @opt_30site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_31item_id = ''
  END ELSE BEGIN
    SET @opt_31item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_32site_id = ''
  END ELSE BEGIN
    SET @opt_32site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_group_tray_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_33group_tray_id = ''
  END ELSE BEGIN
    SET @opt_33group_tray_id = 'AND   A.GROUP_TRAY_ID LIKE ''%'' + RTRIM(LTRIM(' + @v_group_tray_id+')) + ''%'''
  END


  -- FP00634 find_FP00634  
  SET @v_dSql = ''

  SELECT @v_dSql += '    		WITH TRAY_INFO AS ('+char(10)
  SELECT @v_dSql += '    				  SELECT	A.*'+char(10)
  SELECT @v_dSql += '    				  FROM		('+char(10)
  SELECT @v_dSql += '									  SELECT	DISTINCT A.COMPANY_ID'+char(10)
  SELECT @v_dSql += '												,A.DIVISION_ID'+char(10)
  SELECT @v_dSql += '												,A.SITE_ID'+char(10)
  SELECT @v_dSql += '												,A.PLANT_ID'+char(10)
  SELECT @v_dSql += '												,CASE WHEN V.SITE_ID IS NULL THEN ''-'' ELSE A.FACTORY_ID END AS FACTORY_ID	'+char(10)
  SELECT @v_dSql += '												,CASE WHEN V.SITE_ID IS NULL THEN ''-'' ELSE A.PSEUDO_FACTORY_ID END AS TRAY_FACTORY_ID	'+char(10)
  SELECT @v_dSql += '												,A.LINE_ID'+char(10)
  SELECT @v_dSql += '												,ISNULL(B.GROUP_TRAY_ID, A.TRAY_TYPE_CODE) AS GROUP_TRAY_ID'+char(10)
  SELECT @v_dSql += '												,ISNULL(B.GROUP_TRAY_ID, A.TRAY_TYPE_CODE) AS TRAY_ID'+char(10)
  SELECT @v_dSql += '												,B.TRAY_TYPE_NAME AS TRAY_NAME'+char(10)
  SELECT @v_dSql += '												,B.TRAY_TYPE'+char(10)
  SELECT @v_dSql += '												,('+char(10)
  SELECT @v_dSql += '													SELECT TOP 1  B.MODEL_LOT_ID'+char(10)
  SELECT @v_dSql += '													FROM   FP_MODEL_LOT_M  B (NOLOCK)'+char(10)
  SELECT @v_dSql += '													WHERE  B.COMPANY_ID  = A.COMPANY_ID'+char(10)
  SELECT @v_dSql += '													AND    B.DIVISION_ID = A.DIVISION_ID'+char(10)
  SELECT @v_dSql += '													AND    B.SITE_ID = A.SITE_ID'+char(10)
  SELECT @v_dSql += '													AND    B.PLANT_ID = A.PLANT_ID'+char(10)
  SELECT @v_dSql += '													AND    B.MODEL_ID = A.ITEM_ID'+char(10)
  SELECT @v_dSql += '												 ) AS FCS_MODEL_ID'+char(10)
  SELECT @v_dSql += '												,A.ITEM_ID'+char(10)
  SELECT @v_dSql += '												,ISNULL(B.LOAD_YIELD,1) AS LOAD_YIELD'+char(10)
  SELECT @v_dSql += '												,ISNULL(B.BUFFER_DAY,0) AS BUFFER_DAY'+char(10)
  SELECT @v_dSql += '												--,ISNULL(B.TRAY_CNT,0) AS TRAY_CNT'+char(10)
  SELECT @v_dSql += '												--,ISNULL(B.INTRANSIT_CNT,0) AS INTRANSIT_CNT'+char(10)
  SELECT @v_dSql += '												--,SUM(ISNULL(B.TRAY_CNT,0)) OVER( PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.LINE_ID, ISNULL(B.GROUP_TRAY_ID, A.TRAY_TYPE_CODE), A.ITEM_ID ) AS TRAY_CNT'+char(10)
  SELECT @v_dSql += '												,B.GROUP_TRAY_CNT AS TRAY_CNT'+char(10)
  SELECT @v_dSql += '												,B.GROUP_INTRANSIT_CNT AS INTRANSIT_CNT'+char(10)
  SELECT @v_dSql += '												--,SUM(ISNULL(B.INTRANSIT_CNT,0)) OVER( PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.LINE_ID, ISNULL(B.GROUP_TRAY_ID, A.TRAY_TYPE_CODE), A.ITEM_ID ) AS INTRANSIT_CNT'+char(10)
  SELECT @v_dSql += '												,ISNULL(B.CELL_CNT,1) AS CELL_CNT'+char(10)
  SELECT @v_dSql += '												,B.DEGAS_BEFORE_TYPE'+char(10)
  SELECT @v_dSql += '										FROM	SCM_FCS_TRAY_MODEL_M A WITH(NOLOCK)'+char(10)
  SELECT @v_dSql += '												LEFT OUTER JOIN ('+char(10)
  SELECT @v_dSql += '																	SELECT	 A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SELECT @v_dSql += '																			, ISNULL(A.TRAY_TYPE_GROUP,A.TRAY_TYPE_CODE) AS GROUP_TRAY_ID'+char(10)
  SELECT @v_dSql += '																			, A.TRAY_TYPE_CODE'+char(10)
  SELECT @v_dSql += '																			, B.TRAY_TYPE_NAME'+char(10)
  SELECT @v_dSql += '																			, B.DEGAS_BEFORE_TYPE'+char(10)
  SELECT @v_dSql += '																			, B.CELL_CNT'+char(10)
  SELECT @v_dSql += '																			, B.BUFFER_DAY'+char(10)
  SELECT @v_dSql += '																			, B.LOAD_YIELD'+char(10)
  SELECT @v_dSql += '																			, A.TRAY_CNT'+char(10)
  SELECT @v_dSql += '																			, A.INTRANSIT_CNT'+char(10)
  SELECT @v_dSql += '																			, ISNULL(C.ATTRIBUTE1, A.DEGAS_BEFORE_TYPE) AS TRAY_TYPE'+char(10)
  SELECT @v_dSql += '																			, SUM(ISNULL(A.TRAY_CNT,0)) OVER( PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, ISNULL(A.TRAY_TYPE_GROUP,A.TRAY_TYPE_CODE)) AS GROUP_TRAY_CNT'+char(10)
  SELECT @v_dSql += '																			, SUM(ISNULL(A.INTRANSIT_CNT,0)) OVER( PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, ISNULL(A.TRAY_TYPE_GROUP,A.TRAY_TYPE_CODE)) AS GROUP_INTRANSIT_CNT'+char(10)
  SELECT @v_dSql += '																	FROM	SCM_FCS_TRAY_M A WITH(NOLOCK)'+char(10)
  SELECT @v_dSql += '																			INNER JOIN SCM_FCS_TRAY_M B WITH(NOLOCK)'+char(10)
  SELECT @v_dSql += '																				ON	1=1'+char(10)
  SELECT @v_dSql += '																				AND	A.COMPANY_ID = B.COMPANY_ID'+char(10)
  SELECT @v_dSql += '																				AND	A.SITE_ID = B.SITE_ID'+char(10)
  SELECT @v_dSql += '																				AND	A.PLANT_ID = B.PLANT_ID'+char(10)
  SELECT @v_dSql += '																				AND	A.FACTORY_ID = B.FACTORY_ID'+char(10)
  SELECT @v_dSql += '																				AND	ISNULL(A.TRAY_TYPE_GROUP,A.TRAY_TYPE_CODE)  = B.TRAY_TYPE_CODE'+char(10)
  SELECT @v_dSql += '																				AND	B.USE_YN = ''Y'''+char(10)
  SELECT @v_dSql += '																			LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE C WITH(NOLOCK)'+char(10)
  SELECT @v_dSql += '																				ON 1=1'+char(10)
  SELECT @v_dSql += '																				AND C.LOOKUP_TYPE_CODE = ''FORMATION_TRAY_TYPE'''+char(10)
  SELECT @v_dSql += '																				AND C.ACTIVE_FLAG = ''Y'''+char(10)
  SELECT @v_dSql += '																				AND A.PLANT_ID = C.SEGMENT1'+char(10)
  SELECT @v_dSql += '																				AND A.DEGAS_BEFORE_TYPE = C.SEGMENT2'+char(10)
  SELECT @v_dSql += '																	WHERE  	1=1'+char(10)
  SELECT @v_dSql += '																	AND	 	A.USE_YN = ''Y'''+char(10)
  SELECT @v_dSql += '												) B'+char(10)
  SELECT @v_dSql += '												ON  1=1'+char(10)
  SELECT @v_dSql += '												AND	A.COMPANY_ID = B.COMPANY_ID'+char(10)
  SELECT @v_dSql += '												AND	A.DIVISION_ID = B.DIVISION_ID'+char(10)
  SELECT @v_dSql += '												AND	A.SITE_ID = B.SITE_ID'+char(10)
  SELECT @v_dSql += '												AND	A.PLANT_ID = B.PLANT_ID'+char(10)
  --SELECT @v_dSql += '												AND	A.FACTORY_ID = B.FACTORY_ID'+char(10)
  SELECT @v_dSql += '												AND	A.PSEUDO_FACTORY_ID = B.FACTORY_ID'+char(10)
  SELECT @v_dSql += '												AND	A.TRAY_TYPE_CODE = B.TRAY_TYPE_CODE'+char(10)
	SELECT @v_dSql += '												LEFT OUTER HASH JOIN (															'+char(10)																							              
	SELECT @v_dSql += '														SELECT	DISTINCT C.SEGMENT1 AS INSTNCE_ID, V.COMPANY_ID, V.SITE_ID    	'+char(10)
	SELECT @v_dSql += '														FROM	SCM_SYS_LOOKUP_VALUE C  										'+char(10)												              
	SELECT @v_dSql += '																, FP_INSTANCE_LINE_V V											'+char(10)												              
	SELECT @v_dSql += '														WHERE	1=1                                                             '+char(10)                                                              
	SELECT @v_dSql += '														AND		C.LOOKUP_TYPE_CODE = ''FORM_TRAY_SIMUL_OPTION''                   '+char(10)                                                              
	SELECT @v_dSql += '														AND		C.ACTIVE_FLAG = ''Y''       										'+char(10)												              
	SELECT @v_dSql += '														AND     C.ATTRIBUTE1 = ''BUILDING''										'+char(10)												              
	SELECT @v_dSql += '														AND		C.SEGMENT1 = V.INSTANCE_ID										'+char(10)												              
	SELECT @v_dSql += '												) V																				'+char(10)											              
	SELECT @v_dSql += '												ON 1=1																			'+char(10)											              
	SELECT @v_dSql += '												AND A.COMPANY_ID    = V.COMPANY_ID                  							'+char(10)											              
	SELECT @v_dSql += '												AND A.SITE_ID       = V.SITE_ID         										'+char(10)
  SELECT @v_dSql += '										WHERE 1=1'+char(10)
  SELECT @v_dSql += '										AND	  A.USE_YN = ''Y'''+char(10)
  SELECT @v_dSql += '								) A'+char(10)
  SELECT @v_dSql += '						WHERE	1=1'+char(10)
  SELECT @v_dSql += '			)'+char(10)
  SELECT @v_dSql += '			, FORM_PLAN AS ('+char(10)
  SELECT @v_dSql += '					        	SELECT A.*'+char(10)
  SELECT @v_dSql += '					        	FROM ('+char(10)
  SELECT @v_dSql += '						        		SELECT A.INSTANCE_ID, (CASE WHEN A.FACTORY_ID=''-'' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END) AS RELEASE_VALUE'+char(10)
  SELECT @v_dSql += '						                		, RELEASE_PLAN_ID, INSERT_TIME'+char(10)
  SELECT @v_dSql += '						                		, ROW_NUMBER() OVER(PARTITION BY A.INSTANCE_ID, (CASE WHEN A.FACTORY_ID=''-'' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END)'+char(10)
  SELECT @v_dSql += '						                						ORDER BY     A.INSERT_TIME DESC ) AS ROW_NUM'+char(10)
  SELECT @v_dSql += '						        		FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)'+char(10)
  SELECT @v_dSql += '						        		WHERE  A.INSTANCE_DATE <='+char(10)
  SELECT @v_dSql += '' + @v_plan_date+''+char(10)
  SELECT @v_dSql += '					        	) A'+char(10)
  SELECT @v_dSql += '					        	WHERE A.ROW_NUM = 1'+char(10)
  SELECT @v_dSql += '					        	AND   A.INSTANCE_ID ='+char(10)
  SELECT @v_dSql += '' + @v_instance_id+''+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  IF ISNULL(@p_Release_flag,'') ='Y' BEGIN
	SELECT @v_dSql +=  '      	AND   1=1' + char(10)
  END ELSE BEGIN
	SELECT @v_dSql +=  '      	AND   1=0' + char(10)
  END
  SELECT @v_dSql += '					        	UNION ALL'+char(10)
  SELECT @v_dSql += '				    			SELECT  A.INSTANCE_ID, ''-'' AS RELEASE_VALUE, A.PLAN_ID AS RELEASE_PLAN_ID, A.INSERT_TIME, 1 AS ROW_NM'+char(10)
  SELECT @v_dSql += '				    			FROM SCM_FP_PLAN_H A WITH(NOLOCK)'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  IF ISNULL(@p_Release_flag,'') ='Y' BEGIN
	SELECT @v_dSql +=  '      	WHERE   1=0' + char(10)
  END ELSE BEGIN
	SELECT @v_dSql +=  '      	WHERE   1=1' + char(10)
  END
  SELECT @v_dSql += '				    			AND A.INSTANCE_ID ='+char(10)
  SELECT @v_dSql += '' + @v_instance_id+''+char(10)
  SELECT @v_dSql += '				    			AND A.PLAN_ID ='+char(10)
  SELECT @v_dSql += '' + @v_plan_id+''+char(10)
  SELECT @v_dSql += '        	)'+char(10)
  SELECT @v_dSql += '        	, ASSY_PLAN AS ('+char(10)
  SELECT @v_dSql += '					        	SELECT A.*'+char(10)
  SELECT @v_dSql += '					        	FROM ('+char(10)
  SELECT @v_dSql += '						        		SELECT A.INSTANCE_ID, (CASE WHEN A.FACTORY_ID=''-'' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END) AS RELEASE_VALUE'+char(10)
  SELECT @v_dSql += '						                	 , RELEASE_PLAN_ID, INSERT_TIME'+char(10)
  SELECT @v_dSql += '						                	 , ROW_NUMBER() OVER(PARTITION BY A.INSTANCE_ID, (CASE WHEN A.FACTORY_ID=''-'' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END)'+char(10)
  SELECT @v_dSql += '						                						 ORDER BY     A.INSERT_TIME DESC ) AS ROW_NUM'+char(10)
  SELECT @v_dSql += '						        		FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)'+char(10)
  SELECT @v_dSql += '						        		WHERE	1=1'+char(10)
  SELECT @v_dSql += '						        		AND   	A.INSTANCE_ID IN ('+char(10)
  
  --SELECT @v_dSql += '													        		SELECT A.SEGMENT2 AS ASSY_ID'+char(10)
  --SELECT @v_dSql += '													        		FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)'+char(10)
  --SELECT @v_dSql += '													        		WHERE  A.LOOKUP_TYPE_CODE = ''ELEC_ASSY_INSTANCE_MAP'''+char(10)
  --SELECT @v_dSql += '													        		AND    A.SEGMENT1 ='+char(10)
  --SELECT @v_dSql += '' + @v_instance_id+''+char(10)
  -- (D240313~R240313.01)
  SELECT @v_dSql += '													        		SELECT DISTINCT A.SEGMENT2 AS ASSY_ID'+char(10)
  SELECT @v_dSql += '													        		FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)'+char(10)
  SELECT @v_dSql += '													        		WHERE  A.LOOKUP_TYPE_CODE = ''ELEC_ASSY_INSTANCE_MAP'''+char(10)
  SELECT @v_dSql += '													        		AND    A.SEGMENT4 =' + @v_instance_id+''+char(10)
  SELECT @v_dSql += '													        		AND    A.ACTIVE_FLAG = ''Y'' '+char(10)
  SELECT @v_dSql += '													          	 )'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  IF ISNULL(@p_Release_flag,'') ='Y' OR ISNULL(@p_CHK_PLANID,'') = 'Y' BEGIN
	SELECT @v_dSql +=  '        AND  A.INSTANCE_DATE <= '''+ @p_plan_Date +'''' + char(10)
  END ELSE BEGIN
	SELECT @v_dSql +=  '        AND  A.INSERT_TIME <= ( SELECT INSERT_TIME FROM FORM_PLAN )' + char(10)
  END

  SELECT @v_dSql += '					        	) A'+char(10)
  SELECT @v_dSql += '					        	WHERE A.ROW_NUM = 1'+char(10)
  SELECT @v_dSql += '		      )'+char(10)
  SELECT @v_dSql += '		    , ASSY_ITEM AS ('+char(10)
  SELECT @v_dSql += '		    					SELECT  A.INSTANCE_ID, A.COMPANY_ID,A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID, A.LINE_ID, A.ITEM_ID'+char(10)
  SELECT @v_dSql += '								FROM    FP_AMEND_PLAN_CELL_H A WITH(NOLOCK)'+char(10)
  SELECT @v_dSql += '								WHERE  	1=1'+char(10)
  SELECT @v_dSql += '								AND    	EXISTS ('+char(10)
  SELECT @v_dSql += '													SELECT 1'+char(10)
  SELECT @v_dSql += '													FROM   ASSY_PLAN CC'+char(10)
  SELECT @v_dSql += '													WHERE  A.INSTANCE_ID = CC.INSTANCE_ID'+char(10)
  SELECT @v_dSql += '													AND    A.FP_PLAN_ID  = CC.RELEASE_PLAN_ID'+char(10)
  SELECT @v_dSql += '											  	)'+char(10)
  SELECT @v_dSql += '								AND	   A.PLAN_DATE BETWEEN CONVERT(DATETIME,'+char(10)
  SELECT @v_dSql += '' + @v_bucket_from+''+char(10)
  SELECT @v_dSql += ') AND DATEADD(DD, 56, CONVERT(DATETIME,'+char(10)
  SELECT @v_dSql += '' + @v_bucket_to+''+char(10)
  SELECT @v_dSql += '))'+char(10)
  SELECT @v_dSql += '								AND    A.IN_QTY > 0'+char(10)
  SELECT @v_dSql += '								GROUP BY A.INSTANCE_ID, A.COMPANY_ID,A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID, A.LINE_ID, A.ITEM_ID'+char(10)
  SELECT @v_dSql += '		    )'+char(10)
  SELECT @v_dSql += '			, MAIN_I AS ('+char(10)
  SELECT @v_dSql += '							SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SELECT @v_dSql += '									, A.TRAY_FACTORY_ID	'+char(10)
  SELECT @v_dSql += '									, NULL AS CELL_GROUP_CODE, NULL AS TOP_ITEM_ID, NULL AS ITEM_ID, NULL AS ITEM_TYPE, NULL AS NICK_NAME'+char(10)
  SELECT @v_dSql += '									, NULL AS OPERATION_ID'+char(10)
  SELECT @v_dSql += '									, NULL AS BOH_QTY --ISNULL(MAX(A.TRAY_CNT),0) AS  BOH_QTY'+char(10)
  SELECT @v_dSql += '									, NULL AS BOH_INT --ISNULL(MAX(A.INTRANSIT_CNT),0) AS BOH_INT'+char(10)
  SELECT @v_dSql += '									, NULL AS MARKET, NULL AS PRODUCTION_TYPE'+char(10)
  SELECT @v_dSql += '									, ''I'' AS PSI'+char(10)
  SELECT @v_dSql += '									, NULL AS FACTORY_ID, NULL AS LOCATION'+char(10)
  SELECT @v_dSql += '									, NULL AS LINE_ID, NULL AS LINE_NAME, NULL AS ELECTRODE_TYPE'+char(10)
  SELECT @v_dSql += '									, D.CATE_NAME AS CATEGORY_NAME'+char(10)
  SELECT @v_dSql += '									, D.CATE_ID AS CATEGORY_ID'+char(10)
  SELECT @v_dSql += '									, D.UOM_ID'+char(10)
  SELECT @v_dSql += '									, D.CATE_ORDER AS CATEGORY_ORDER'+char(10)
  SELECT @v_dSql += '									, ''DATA'' AS DATA_TYPE'+char(10)
  SELECT @v_dSql += '									, NULL AS S_ROW'+char(10)
  SELECT @v_dSql += '									, A.GROUP_TRAY_ID'+char(10)
  SELECT @v_dSql += '									, NULL AS TRAY_ID'+char(10)
  SELECT @v_dSql += '									, NULL AS TRAY_NAME'+char(10)
  SELECT @v_dSql += '									, NULL AS TRAY_TYPE'+char(10)
  SELECT @v_dSql += '									, NULL AS TEMP_TRAY_ID'+char(10)
  SELECT @v_dSql += '									, NULL AS CELL_CNT'+char(10)
  SELECT @v_dSql += '									, NULL AS BUFFER_DAY'+char(10)
  SELECT @v_dSql += '									, MAX(A.DEGAS_BEFORE_TYPE) AS DEGAS_BEFORE_TYPE'+char(10)
  SELECT @v_dSql += '									, NULL AS LOAD_YIELD'+char(10)
  SELECT @v_dSql += '									, MAX(A.SORT_IDX) AS SORT_IDX'+char(10)
  SELECT @v_dSql += '									, NULL AS ORG_PKG_CAPA'+char(10)
  SELECT @v_dSql += '									, NULL AS ORG_PKG_CAPA_CELL'+char(10)
  SELECT @v_dSql += '									--, A.TRAY_ID'+char(10)
  SELECT @v_dSql += '									--, A.TRAY_NAME'+char(10)
  SELECT @v_dSql += '									--, A.TRAY_TYPE'+char(10)
  SELECT @v_dSql += '									--, ISNULL(A.TRAY_ID, A.ITEM_ID) AS TEMP_TRAY_ID'+char(10)
  SELECT @v_dSql += '									--, MAX(A.CELL_CNT) AS CELL_CNT'+char(10)
  SELECT @v_dSql += '									--, MAX(A.BUFFER_DAY) AS BUFFER_DAY'+char(10)
  SELECT @v_dSql += '									--, MAX(A.DEGAS_BEFORE_TYPE) AS DEGAS_BEFORE_TYPE'+char(10)
  SELECT @v_dSql += '									--, MAX(A.LOAD_YIELD) AS LOAD_YIELD'+char(10)
  SELECT @v_dSql += '									--, MAX(A.SORT_IDX) AS SORT_IDX'+char(10)
  SELECT @v_dSql += '									--, CEILING( MAX(A.PKG_CAPA) * MAX(A.BUFFER_DAY) * MAX(A.LOAD_YIELD) / MAX(A.CELL_CNT) ) AS ORG_PKG_CAPA'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SELECT @v_dSql += @p_CTRL_date
  
 DECLARE @sub_mst_loop_cnt integer = 0
 DECLARE @sub_max_loop_cnt integer = 0
 DECLARE @sub_v_delimiter NVARCHAR(2) = '#'
 DECLARE @sub_tmp_column NVARCHAR(MAX) = ''

 DECLARE @sub_param_0 NVARCHAR(MAX) = '' 
 DECLARE @sub_param_1 NVARCHAR(MAX) = '' 
 DECLARE @sub_param_2 NVARCHAR(MAX) = '' 
 DECLARE @sub_param_3 NVARCHAR(MAX) = '' 
 DECLARE @sub_param_4 NVARCHAR(MAX) = '' 

 IF isnull(@p_bucket,'') <> '' BEGIN
 SET @mst_loop_cnt = 0
 SET @v_delimiter = '!' -- 데이터 구분자
 SET @sub_v_delimiter = '#'
 SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_bucket, @v_delimiter) -- 프로시저 LOOP 길이를 판단

 IF @max_loop_cnt > 0 BEGIN
 -- bucket
 SET @mst_loop_cnt = 0	
 SET @max_loop_cnt = 0
 SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_bucket, @v_delimiter) -- 프로시저 LOOP 길이를 판단
 WHILE @mst_loop_cnt < @max_loop_cnt
 BEGIN
 SET @mst_loop_cnt = @mst_loop_cnt + 1
 SET @tmp_column = ''
 SET @tmp_column = [dbo].[SCM_ARR_SPL_VAL]( @p_bucket,@v_delimiter, @mst_loop_cnt)
 SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
 IF @sub_max_loop_cnt > 0 BEGIN SET @sub_param_0 = [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1) END-- @sub_param_0 => Date 20210322
 IF @sub_max_loop_cnt > 1 BEGIN SET @sub_param_1 = [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2) END-- @sub_param_1 => Name 2021-03022(M...)
 IF @sub_max_loop_cnt > 2 BEGIN SET @sub_param_2 = [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3) END-- @sub_param_2 => Count 1
 IF @sub_max_loop_cnt > 3 BEGIN SET @sub_param_3 = [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4) END-- @sub_param_3 => Value D0
 --IF @sub_max_loop_cnt > 4 BEGIN SET @sub_param_4 = [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1) END


 SET @v_dSql += ' , SUM(CASE WHEN CONVERT(VARCHAR,G.DT,112)='''+@sub_param_0+''' THEN ( CASE WHEN D.CATE_ID = ''I_EOH'' THEN 0 ' + char(10)
 SET @v_dSql += ' WHEN D.CATE_ID = ''I_EOH_INT''	THEN 0 ' + char(10);
 SET @v_dSql += ' ELSE 0 END ) ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '' + char(10)

  END -- end of @mst_loop_cnt < @max_loop_cnt
 END --end of @max_loop_cnt
	END-- end of isnull(@p_bucket,'') <> ''
  
  SELECT @v_dSql += '							FROM	('+char(10)
  SELECT @v_dSql += '										SELECT	A.INSTANCE_ID, A.FP_PLAN_ID'+char(10)
  SELECT @v_dSql += '												, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, M.TRAY_FACTORY_ID '+char(10)
  SELECT @v_dSql += '												, A.PLAN_DATE'+char(10)
  SELECT @v_dSql += '												, A.ITEM_ID'+char(10)
  SELECT @v_dSql += '												, M.GROUP_TRAY_ID'+char(10)
  SELECT @v_dSql += '												, M.TRAY_ID AS TRAY_ID --M.TRAY_ID'+char(10)
  SELECT @v_dSql += '												, M.TRAY_NAME'+char(10)
  SELECT @v_dSql += '												, M.TRAY_TYPE'+char(10)
  SELECT @v_dSql += '												, ISNULL(M.LOAD_YIELD, 1) AS LOAD_YIELD'+char(10)
  SELECT @v_dSql += '												, M.BUFFER_DAY'+char(10)
  SELECT @v_dSql += '												, M.TRAY_CNT'+char(10)
  SELECT @v_dSql += '												, M.INTRANSIT_CNT'+char(10)
  SELECT @v_dSql += '												, ISNULL(M.DEGAS_BEFORE_TYPE,''X'') AS DEGAS_BEFORE_TYPE'+char(10)
  SELECT @v_dSql += '												, CASE WHEN ISNULL(M.DEGAS_BEFORE_TYPE,''X'') = ''D'' THEN 10'+char(10)
  SELECT @v_dSql += '													   WHEN ISNULL(M.DEGAS_BEFORE_TYPE,''X'') = ''E'' THEN 20'+char(10)
  SELECT @v_dSql += '													   WHEN ISNULL(M.DEGAS_BEFORE_TYPE,''X'') = ''A'' THEN 30'+char(10)
  SELECT @v_dSql += '																								  ELSE 99'+char(10)
  SELECT @v_dSql += '												  END AS SORT_IDX'+char(10)
  SELECT @v_dSql += '												, M.CELL_CNT'+char(10)
  SELECT @v_dSql += '												, MAX(ISNULL(F.DAILY_CAPA,0)) OVER ( PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, M.TRAY_ID) AS PKG_CAPA'+char(10)
  SELECT @v_dSql += '												, MAX(ISNULL(F.DAILY_CAPA,0)) OVER ( PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, M.TRAY_ID) AS ORG_PKG_CAPA_CELL'+char(10)
  SELECT @v_dSql += '												--, CEILING((ISNULL(F.DAILY_CAPA,0) * M.BUFFER_DAY)  / FLOOR(M.CELL_CNT * M.LOAD_YIELD) ) AS PKG_CAPA'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  IF ISNULL(@p_Release_flag,'') ='Y' OR ISNULL(@p_plan_type,'') = 'RELEASE' BEGIN
	SELECT @v_dSql +=  '        		FROM   FP_AMEND_PLAN_FORM_H A WITH(NOLOCK)'+ char(10)
  END ELSE BEGIN
	SELECT @v_dSql +=  '        		FROM   FP_AMEND_PLAN_FORM_R A WITH(NOLOCK)' + char(10)
  END  --SELECT @v_dSql += '
  
  SELECT @v_dSql += '												INNER HASH JOIN ('+char(10)
  SELECT @v_dSql += '															SELECT	DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID,'+char(10)
  SELECT @v_dSql += '																	('+char(10)
  SELECT @v_dSql += '																		CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME'+char(10)
  SELECT @v_dSql += '																			 WHEN LEFT(A.FLOW_ID,5) = ''A9000''										THEN ISNULL(C.LEVEL_4_NAME, ''-'')'+char(10)
  SELECT @v_dSql += '																																					ELSE C.LEVEL_3_NAME'+char(10)
  SELECT @v_dSql += '																		END'+char(10)
  SELECT @v_dSql += '																	) AS ITEM_TYPE,'+char(10)
  SELECT @v_dSql += '																	ISNULL(A.NICK_NAME,''-'') AS NICK_NAME'+char(10)
  SELECT @v_dSql += '															FROM	SCM_ITEM_M A WITH(NOLOCK),'+char(10)
  SELECT @v_dSql += '																	SCM_ITEM_CLASS_M C WITH(NOLOCK)'+char(10)
  SELECT @v_dSql += '															WHERE	1=1'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
      SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)

  SELECT @v_dSql += '															AND		A.ACTIVE_FLAG = ''Y'''+char(10)
  SELECT @v_dSql += '															AND		A.ITEM_CLASS  = C.CLASS_ID'+char(10)
  SELECT @v_dSql += '												) B'+char(10)
  SELECT @v_dSql += '												ON     A.COMPANY_ID  = B.COMPANY_ID'+char(10)
  SELECT @v_dSql += '												AND    A.DIVISION_ID = B.DIVISION_ID'+char(10)
  SELECT @v_dSql += '												AND    A.SITE_ID     = B.SITE_ID'+char(10)
  SELECT @v_dSql += '												AND    A.ITEM_ID     = B.ITEM_ID'+char(10)
  SELECT @v_dSql += '												INNER HASH JOIN SCM_ITEM_M C WITH(NOLOCK)'+char(10)
  SELECT @v_dSql += '												ON     1=1'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
      SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.SITE_ID' , 'EQ', @p_site_id)) + char(10)

  SELECT @v_dSql += '								                AND		C.ACTIVE_FLAG = ''Y'''+char(10)
  SELECT @v_dSql += '												AND	   A.COMPANY_ID   = C.COMPANY_ID'+char(10)
  SELECT @v_dSql += '												AND    A.DIVISION_ID  = C.DIVISION_ID'+char(10)
  SELECT @v_dSql += '												AND    A.SITE_ID      = C.SITE_ID'+char(10)
  SELECT @v_dSql += '												AND    A.TOP_ITEM_ID  = C.ITEM_ID'+char(10)
  SELECT @v_dSql += '												INNER HASH JOIN SCM_LINE_M E WITH(NOLOCK)'+char(10)
  SELECT @v_dSql += '												ON     1=1'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
    SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('E.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('E.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('E.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
  SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('E.LINE_ID' , 'EQ', @p_line_id)) + char(10)
  SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('E.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
  SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('E.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
  
  SELECT @v_dSql += '												AND	   A.COMPANY_ID     = E.COMPANY_ID'+char(10)
  SELECT @v_dSql += '												AND    A.DIVISION_ID    = E.DIVISION_ID'+char(10)
  SELECT @v_dSql += '												AND    A.SITE_ID        = E.SITE_ID'+char(10)
  SELECT @v_dSql += '												AND    A.PLANT_ID       = E.PLANT_ID'+char(10)
  SELECT @v_dSql += '												AND    A.FACTORY_ID     = E.FACTORY_ID'+char(10)
  SELECT @v_dSql += '												AND    A.OPERATION_ID   = E.OPERATION_ID'+char(10)
  SELECT @v_dSql += '												AND    A.LINE_ID        = E.LINE_ID'+char(10)
  SELECT @v_dSql += '												AND    A.ELECTRODE_TYPE = E.ELECTRODE_TYPE'+char(10)
  SELECT @v_dSql += '												LEFT OUTER HASH JOIN SCM_TACT_TIME_M F WITH(NOLOCK)'+char(10)
  SELECT @v_dSql += '												ON     1=1'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
      SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('F.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('F.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('F.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)

  
  SELECT @v_dSql += '								                AND    F.OPERATION_ID = ''A9000'''+char(10)
  SELECT @v_dSql += '								                AND	   F.MONTH = CONVERT(VARCHAR(6),'+char(10)
  SELECT @v_dSql += '' + @v_bucket_from+''+char(10)
  SELECT @v_dSql += ')'+char(10)
  SELECT @v_dSql += '												AND	   A.COMPANY_ID     = E.COMPANY_ID'+char(10)
  SELECT @v_dSql += '												AND    A.DIVISION_ID    = E.DIVISION_ID'+char(10)
  SELECT @v_dSql += '												AND    A.SITE_ID        = E.SITE_ID'+char(10)
  SELECT @v_dSql += '												AND    A.PLANT_ID       = E.PLANT_ID'+char(10)
  SELECT @v_dSql += '												AND    CASE WHEN CHARINDEX(''-'',A.LINE_ID) > 0 THEN SUBSTRING(A.LINE_ID, 0, CHARINDEX(''-'',A.LINE_ID)) ELSE A.LINE_ID END = F.LINE_ID'+char(10)
  SELECT @v_dSql += '												AND    A.ITEM_ID		= F.ITEM_ID'+char(10)
  SELECT @v_dSql += '												LEFT OUTER HASH JOIN TRAY_INFO M'+char(10)
  SELECT @v_dSql += '												--inner HASH JOIN TRAY_INFO M'+char(10)
  SELECT @v_dSql += '												ON	1=1'+char(10)
  SELECT @v_dSql += '												--and m.group_tray_id =''XFSC'''+char(10)
  SELECT @v_dSql += '												AND	   A.COMPANY_ID     = M.COMPANY_ID'+char(10)
  SELECT @v_dSql += '												AND    A.DIVISION_ID    = M.DIVISION_ID'+char(10)
  SELECT @v_dSql += '												AND    A.SITE_ID        = M.SITE_ID'+char(10)
  SELECT @v_dSql += '												AND    A.PLANT_ID       = M.PLANT_ID'+char(10)
  SELECT @v_dSql += '												AND    A.LINE_ID       	= M.LINE_ID'+char(10)
  SELECT @v_dSql += '												AND	   A.ITEM_ID		= M.ITEM_ID'+char(10)
  SELECT @v_dSql += '										WHERE  1=1'+char(10)
  SELECT @v_dSql += '										AND	   A.INSTANCE_ID  ='+char(10)
  SELECT @v_dSql += '' + @v_instance_id+''+char(10)
  SELECT @v_dSql += '										AND    EXISTS 	('+char(10)
  SELECT @v_dSql += '															SELECT 1'+char(10)
  SELECT @v_dSql += '															FROM   FORM_PLAN CC'+char(10)
  SELECT @v_dSql += '															WHERE  A.INSTANCE_ID = CC.INSTANCE_ID'+char(10)
  SELECT @v_dSql += '															AND    A.FP_PLAN_ID  = CC.RELEASE_PLAN_ID'+char(10)
  SELECT @v_dSql += '														)'+char(10)
  SELECT @v_dSql += '										AND		(A.IN_QTY <> 0 OR A.AVAILABILITY <> 0 OR A.AGING_WIP <> 0 OR A.AGING_WIP_BD <> 0 OR A.AGING_WIP_AD <> 0 )'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
      SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
  SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
  SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
  SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
  
  SELECT @v_dSql += ' ' +@opt_6item_id +' '+''+char(10)--AND    A.ITEM_ID LIKE '%' + #ITEM_ID# + '%'
  SELECT @v_dSql += '										AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN'+char(10)
  SELECT @v_dSql += '' + @v_bucket_from+''+char(10)
  SELECT @v_dSql += ' AND'+char(10)
  SELECT @v_dSql += '' + @v_bucket_to+''+char(10)
  SELECT @v_dSql += '									) A'+char(10)
  SELECT @v_dSql += '									INNER JOIN ('+char(10)
  SELECT @v_dSql += '												SELECT * FROM ('+char(10)
  SELECT @v_dSql += '																SELECT 100 AS CATE_ORDER, ''Tray EOH(Buf.)'' AS CATE_NAME, ''I_EOH'' AS CATE_ID, '''' AS UOM_ID'+char(10)
  SELECT @v_dSql += '																UNION ALL'+char(10)
  SELECT @v_dSql += '																SELECT 200 AS CATE_ORDER, ''Tray EOH(Buf. + Int.)'' AS CATE_NAME, ''I_EOH_INT'' AS CATE_ID , '''' AS UOM_ID'+char(10)
  SELECT @v_dSql += '												) A'+char(10)
  SELECT @v_dSql += '												WHERE CATE_ID <> ''X'''+char(10)
  SELECT @v_dSql += '									) D'+char(10)
  SELECT @v_dSql += '									ON     1=1'+char(10)
  SELECT @v_dSql += '									INNER HASH JOIN TH_UIS_CAL G WITH(NOLOCK)'+char(10)
  SELECT @v_dSql += '									ON  1=1'+char(10)
  SELECT @v_dSql += '									AND	G.DT BETWEEN'+char(10)
  SELECT @v_dSql += '' + @v_bucket_from+''+char(10)
  SELECT @v_dSql += ' AND'+char(10)
  SELECT @v_dSql += '' + @v_bucket_to+''+char(10)
  SELECT @v_dSql += '									AND	A.PLAN_DATE  = G.DT'+char(10)
  SELECT @v_dSql += '							WHERE  1=1'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
      SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)

  
  SELECT @v_dSql += ' ' +@opt_6item_id +' '+''+char(10)--AND    A.ITEM_ID LIKE '%' + #ITEM_ID# + '%'
  SELECT @v_dSql += '							GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TRAY_FACTORY_ID	'+char(10)
  SELECT @v_dSql += '									, A.GROUP_TRAY_ID'+char(10)
  SELECT @v_dSql += '									--, A.TRAY_ID'+char(10)
  SELECT @v_dSql += '									--, A.TRAY_NAME'+char(10)
  SELECT @v_dSql += '									--, A.TRAY_TYPE'+char(10)
  SELECT @v_dSql += '									--, ISNULL(A.TRAY_ID, A.ITEM_ID)'+char(10)
  SELECT @v_dSql += '									, D.CATE_NAME, D.CATE_ID, D.CATE_ORDER, D.UOM_ID'+char(10)
  SELECT @v_dSql += '						)'+char(10)
  SELECT @v_dSql += '			, MAIN_P AS ('+char(10)
  SELECT @v_dSql += '							SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TRAY_FACTORY_ID	'+char(10)
  SELECT @v_dSql += '							        , A.CELL_GROUP_CODE, A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME'+char(10)
  SELECT @v_dSql += '							        , A.OPERATION_ID'+char(10)
  SELECT @v_dSql += '							        , ISNULL(MAX(A.TRAY_CNT),0) AS  BOH_QTY, ISNULL(MAX(A.INTRANSIT_CNT),0) AS BOH_INT'+char(10)
  SELECT @v_dSql += '							        , A.MARKET, A.PRODUCTION_TYPE'+char(10)
  SELECT @v_dSql += '							        , ''P'' AS PSI'+char(10)
  SELECT @v_dSql += '							        , A.FACTORY_ID, A.LOCATION'+char(10)
  SELECT @v_dSql += '							        , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE'+char(10)
  SELECT @v_dSql += '							        , D.CATE_NAME AS CATEGORY_NAME'+char(10)
  SELECT @v_dSql += '									, D.CATE_ID AS CATEGORY_ID'+char(10)
  SELECT @v_dSql += '									, D.UOM_ID'+char(10)
  SELECT @v_dSql += '							        , D.CATE_ORDER AS CATEGORY_ORDER'+char(10)
  SELECT @v_dSql += '							        , ''DATA'' AS DATA_TYPE'+char(10)
  SELECT @v_dSql += '							        , NULL AS S_ROW'+char(10)
  SELECT @v_dSql += '							        , A.GROUP_TRAY_ID'+char(10)
  SELECT @v_dSql += '									, A.TRAY_ID'+char(10)
  SELECT @v_dSql += '									, A.TRAY_NAME'+char(10)
  SELECT @v_dSql += '									, A.TRAY_TYPE'+char(10)
  SELECT @v_dSql += '									, ISNULL(A.TRAY_ID, A.ITEM_ID) AS TEMP_TRAY_ID'+char(10)
  SELECT @v_dSql += '									, MAX(A.CELL_CNT) AS CELL_CNT'+char(10)
  SELECT @v_dSql += '									, MAX(A.BUFFER_DAY) AS BUFFER_DAY'+char(10)
  SELECT @v_dSql += '									, MAX(A.DEGAS_BEFORE_TYPE) AS DEGAS_BEFORE_TYPE'+char(10)
  SELECT @v_dSql += '									, MAX(A.LOAD_YIELD) AS LOAD_YIELD'+char(10)
  SELECT @v_dSql += '									, MAX(A.SORT_IDX) AS SORT_IDX'+char(10)
  SELECT @v_dSql += '									--, ROUND( MAX(A.PKG_CAPA) * MAX(A.BUFFER_DAY) / (MAX(A.LOAD_YIELD) * MAX(A.CELL_CNT)) ,0) + (CASE WHEN (MAX(A.PKG_CAPA) * MAX(A.BUFFER_DAY) % (MAX(A.LOAD_YIELD) * MAX(A.CELL_CNT))) > 0 THEN 1 ELSE 0 END)  AS ORG_PKG_CAPA'+char(10)
  SELECT @v_dSql += '									--, ROUND( (MAX(A.PKG_CAPA) / FLOOR(MAX(A.LOAD_YIELD) * MAX(A.CELL_CNT))) * MAX(A.BUFFER_DAY) ,0)   AS ORG_PKG_CAPA'+char(10)
  SELECT @v_dSql += '									, ROUND( (MAX(A.PKG_CAPA) / FLOOR(MAX(A.LOAD_YIELD) * MAX(A.CELL_CNT))) ,0)   AS ORG_PKG_CAPA'+char(10)
  SELECT @v_dSql += '									, MAX(A.PKG_CAPA)  AS ORG_PKG_CAPA_CELL'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----

  --  DECLARE @sub_mst_loop_cnt integer = 0
  --DECLARE @sub_max_loop_cnt integer = 0
  --DECLARE @sub_v_delimiter NVARCHAR(2) = '#'
  --DECLARE @sub_tmp_column NVARCHAR(MAX) = ''

  --DECLARE @sub_param_0 NVARCHAR(MAX) = '' 
  --DECLARE @sub_param_1 NVARCHAR(MAX) = '' 
  --DECLARE @sub_param_2 NVARCHAR(MAX) = '' 
  --DECLARE @sub_param_3 NVARCHAR(MAX) = '' 
  --DECLARE @sub_param_4 NVARCHAR(MAX) = '' 

     IF isnull(@p_bucket,'') <> '' BEGIN
		SET @mst_loop_cnt = 0
		SET @v_delimiter            = '!'  -- 데이터 구분자
		SET @sub_v_delimiter = '#'
		SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_bucket, @v_delimiter) -- 프로시저 LOOP 길이를 판단

		IF @max_loop_cnt > 0 BEGIN
			-- bucket
			SET @mst_loop_cnt = 0	
			SET @max_loop_cnt = 0
			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_bucket, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			WHILE @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @mst_loop_cnt =  @mst_loop_cnt + 1
				SET @tmp_column = ''
				SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @p_bucket,@v_delimiter, @mst_loop_cnt)
				SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
				IF @sub_max_loop_cnt > 0 BEGIN   SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END-- @sub_param_0 => Date 20210322
				IF @sub_max_loop_cnt > 1 BEGIN   SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   END-- @sub_param_1 => Name 2021-03022(M...)
				IF @sub_max_loop_cnt > 2 BEGIN   SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   END-- @sub_param_2 => Count 1
				IF @sub_max_loop_cnt > 3 BEGIN   SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   END-- @sub_param_3 => Value D0
				--IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   END
-- ORIGINAL QUERY START
--: neodeex + exec sp_execute로 실행 시 query fail 발생한다 . neodeex와 mssqlmanagement의 실행 옵션 차이에 의해 에러가 발생하는 것으로 생각된다.
-- QUERY를 FIXED로 바꾸면 정상 실행된다.
  --SELECT @v_dSql += '      				 , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)='''+@sub_param_0+'''  THEN ( CASE 	WHEN D.CATE_ID = ''P_IN''			THEN A.IN_QTY 					' + char(10)
  --SELECT @v_dSql += '      				 																						WHEN D.CATE_ID = ''P_OUT''		THEN A.OUT_QTY                  ' + char(10)
  --SELECT @v_dSql += '      				 																						WHEN D.CATE_ID = ''P_ACT''		THEN A.ACTIVATED                ' + char(10)
  --SELECT @v_dSql += '      				 																						WHEN D.CATE_ID = ''P_WIP''		THEN A.AGING_WIP                ' + char(10)
  --SELECT @v_dSql += '      				 																						WHEN D.CATE_ID = ''P_BD''			THEN A.AGING_WIP_BD             ' + char(10)
  --SELECT @v_dSql += '      				 																						WHEN D.CATE_ID = ''P_AD''			THEN A.AGING_WIP_AD             ' + char(10)
  --SELECT @v_dSql += '      				 																						WHEN D.CATE_ID = ''P_OUT_TRAY''	THEN A.OUT_QTY_TRAY             ' + char(10)
  --SELECT @v_dSql += '      				 																						WHEN D.CATE_ID = ''P_ACT_TRAY''	THEN A.ACTIVATED_TRAY           ' + char(10)
  --SELECT @v_dSql += '      				 																						WHEN D.CATE_ID = ''P_WIP_TRAY''	THEN A.AGING_WIP_TRAY           ' + char(10)
  --SELECT @v_dSql += '      				 																						WHEN D.CATE_ID = ''P_BD_TRAY'' 	THEN A.AGING_WIP_BD_TRAY       ' + char(10)
  --SELECT @v_dSql += '      				 																						WHEN D.CATE_ID = ''P_AD_TRAY'' 	THEN A.AGING_WIP_AD_TRAY       ' + char(10)
  --SELECT @v_dSql += '      				 																						ELSE 0 END ) ELSE 0 END) AS  D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '	 						' + char(10)
-- ORIGINAL QUERY END
-- FIXED QUERY START (FIXED QUERY는 SUM을 CASE 문 안으로 접어 넣는다)
  SELECT @v_dSql += '      				 ,  CASE 	WHEN D.CATE_ID = ''P_IN''			THEN SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)='''+@sub_param_0+''' THEN A.IN_QTY ELSE 0 END) 					' + char(10)
  SELECT @v_dSql += '      				            WHEN D.CATE_ID = ''P_OUT''		THEN SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)='''+@sub_param_0+''' THEN A.OUT_QTY ELSE 0 END)                  ' + char(10)
  SELECT @v_dSql += '      				            WHEN D.CATE_ID = ''P_ACT''		THEN SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)='''+@sub_param_0+''' THEN A.ACTIVATED ELSE 0 END)                ' + char(10)
  SELECT @v_dSql += '      				            WHEN D.CATE_ID = ''P_WIP''		THEN SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)='''+@sub_param_0+''' THEN A.AGING_WIP ELSE 0 END)                ' + char(10)
  SELECT @v_dSql += '      				            WHEN D.CATE_ID = ''P_BD''			THEN SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)='''+@sub_param_0+''' THEN A.AGING_WIP_BD ELSE 0 END)             ' + char(10)
  SELECT @v_dSql += '      				            WHEN D.CATE_ID = ''P_AD''			THEN SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)='''+@sub_param_0+''' THEN A.AGING_WIP_AD ELSE 0 END)             ' + char(10)
  SELECT @v_dSql += '      				            WHEN D.CATE_ID = ''P_OUT_TRAY''	THEN SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)='''+@sub_param_0+''' THEN A.OUT_QTY_TRAY ELSE 0 END)             ' + char(10)
  SELECT @v_dSql += '      				            WHEN D.CATE_ID = ''P_ACT_TRAY''	THEN SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)='''+@sub_param_0+''' THEN A.ACTIVATED_TRAY ELSE 0 END)           ' + char(10)
  SELECT @v_dSql += '      				            WHEN D.CATE_ID = ''P_WIP_TRAY''	THEN SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)='''+@sub_param_0+''' THEN A.AGING_WIP_TRAY ELSE 0 END)           ' + char(10)
  SELECT @v_dSql += '      				            WHEN D.CATE_ID = ''P_BD_TRAY'' 	THEN SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)='''+@sub_param_0+''' THEN A.AGING_WIP_BD_TRAY ELSE 0 END)       ' + char(10)
  SELECT @v_dSql += '      				            WHEN D.CATE_ID = ''P_AD_TRAY'' 	THEN SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)='''+@sub_param_0+''' THEN A.AGING_WIP_AD_TRAY ELSE 0 END)       ' + char(10)
  SELECT @v_dSql += '      				            ELSE 0 END AS  D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '	 						' + char(10)

			
			END -- end of @mst_loop_cnt < @max_loop_cnt
		END --end of @max_loop_cnt
	END-- end of isnull(@p_bucket,'') <> ''


  SELECT @v_dSql += '							FROM ('+char(10)
  SELECT @v_dSql += '										SELECT	A.INSTANCE_ID, A.FP_PLAN_ID'+char(10)
  SELECT @v_dSql += '												, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, M.TRAY_FACTORY_ID '+char(10)
  SELECT @v_dSql += '												, A.CELL_GROUP_CODE, A.TOP_ITEM_ID, A.ITEM_ID'+char(10)
  SELECT @v_dSql += '												, B.ITEM_TYPE, ISNULL(C.NICK_NAME,''-'') AS NICK_NAME, ISNULL(E.LINE_NAME,''-'') AS LINE_NAME'+char(10)
  SELECT @v_dSql += '												, A.OPERATION_ID'+char(10)
  SELECT @v_dSql += '												, A.FACTORY_ID, A.LOCATION'+char(10)
  SELECT @v_dSql += '												, NULL AS BOH_QTY'+char(10)
  SELECT @v_dSql += '												, A.PRODUCTION_TYPE, A.MARKET'+char(10)
  SELECT @v_dSql += '												, ''P'' AS PSI'+char(10)
  SELECT @v_dSql += '												, A.LINE_ID'+char(10)
  SELECT @v_dSql += '												, A.ELECTRODE_TYPE'+char(10)
  SELECT @v_dSql += '												, A.PLAN_DATE'+char(10)
  SELECT @v_dSql += '												, A.IN_QTY'+char(10)
  SELECT @v_dSql += '												, A.OUT_QTY'+char(10)
  SELECT @v_dSql += '												, A.ACTIVATED_SIM  AS ACTIVATED			-- A.AVAILABILITY AS ACTIVATED'+char(10)
  SELECT @v_dSql += '												, A.AGING_WIP_SIM AS AGING_WIP			-- A.AGING_WIP'+char(10)
  SELECT @v_dSql += '												, A.AGING_WIP_SIM_BD AS	AGING_WIP_BD	-- A.AGING_WIP_BD'+char(10)
  SELECT @v_dSql += '												, A.AGING_WIP_SIM_AD AS AGING_WIP_AD	-- A.AGING_WIP_AD'+char(10)
  SELECT @v_dSql += '												, M.GROUP_TRAY_ID'+char(10)
  SELECT @v_dSql += '												, M.TRAY_ID'+char(10)
  SELECT @v_dSql += '												, M.TRAY_NAME'+char(10)
  SELECT @v_dSql += '												, M.TRAY_TYPE'+char(10)
  SELECT @v_dSql += '												, ISNULL(M.LOAD_YIELD, 1) AS LOAD_YIELD'+char(10)
  SELECT @v_dSql += '												, M.BUFFER_DAY'+char(10)
  SELECT @v_dSql += '												, M.TRAY_CNT'+char(10)
  SELECT @v_dSql += '												, M.INTRANSIT_CNT'+char(10)
  SELECT @v_dSql += '												, ISNULL(M.DEGAS_BEFORE_TYPE,''X'') AS DEGAS_BEFORE_TYPE'+char(10)
  SELECT @v_dSql += '												, CASE WHEN ISNULL(M.DEGAS_BEFORE_TYPE,''X'') = ''D'' THEN 10'+char(10)
  SELECT @v_dSql += '													   WHEN ISNULL(M.DEGAS_BEFORE_TYPE,''X'') = ''E'' THEN 20'+char(10)
  SELECT @v_dSql += '													   WHEN ISNULL(M.DEGAS_BEFORE_TYPE,''X'') = ''A'' THEN 30'+char(10)
  SELECT @v_dSql += '																								  ELSE 99'+char(10)
  SELECT @v_dSql += '												  END AS SORT_IDX'+char(10)
  SELECT @v_dSql += '												, M.CELL_CNT'+char(10)
  SELECT @v_dSql += '												, ROUND(A.IN_QTY / (M.CELL_CNT * M.LOAD_YIELD) ,0) + (CASE WHEN (A.IN_QTY % (M.CELL_CNT * M.LOAD_YIELD)) > 0 THEN 1 ELSE 0 END) AS IN_QTY_TRAY'+char(10)
  SELECT @v_dSql += '												, ROUND(A.OUT_QTY / (M.CELL_CNT * M.LOAD_YIELD) ,0) + (CASE WHEN (A.OUT_QTY % (M.CELL_CNT * M.LOAD_YIELD)) > 0 THEN 1 ELSE 0 END) AS OUT_QTY_TRAY'+char(10)
  SELECT @v_dSql += '												, ROUND(A.ACTIVATED_SIM / (M.CELL_CNT * M.LOAD_YIELD) ,0) + (CASE WHEN (A.ACTIVATED_SIM % (M.CELL_CNT * M.LOAD_YIELD)) > 0 THEN 1 ELSE 0 END) AS ACTIVATED_TRAY'+char(10)
  SELECT @v_dSql += '												, ROUND(A.AGING_WIP_SIM / (M.CELL_CNT * M.LOAD_YIELD) ,0) + (CASE WHEN (A.AGING_WIP_SIM % (M.CELL_CNT * M.LOAD_YIELD)) > 0 THEN 1 ELSE 0 END) AS AGING_WIP_TRAY'+char(10)
  SELECT @v_dSql += '												, ROUND(A.AGING_WIP_SIM_BD / (M.CELL_CNT * M.LOAD_YIELD) ,0) + (CASE WHEN (A.AGING_WIP_SIM_BD % (M.CELL_CNT * M.LOAD_YIELD)) > 0 THEN 1 ELSE 0 END) AS AGING_WIP_BD_TRAY'+char(10)
  SELECT @v_dSql += '												, ROUND(A.AGING_WIP_SIM_AD / (M.CELL_CNT * M.LOAD_YIELD) ,0) + (CASE WHEN (A.AGING_WIP_SIM_AD % (M.CELL_CNT * M.LOAD_YIELD)) > 0 THEN 1 ELSE 0 END) AS AGING_WIP_AD_TRAY'+char(10)
  SELECT @v_dSql += '												, MAX(ISNULL(F.DAILY_CAPA,0)) OVER ( PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, M.TRAY_FACTORY_ID , M.TRAY_ID) AS PKG_CAPA'+char(10)
  SELECT @v_dSql += '												--, CEILING((ISNULL(F.DAILY_CAPA,0) * M.BUFFER_DAY)  / FLOOR(M.CELL_CNT * M.LOAD_YIELD)) AS PKG_CAPA'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  IF ISNULL(@p_Release_flag,'') ='Y' OR ISNULL(@p_plan_type,'') = 'RELEASE' BEGIN
	SELECT @v_dSql +=  '        		FROM   FP_AMEND_PLAN_FORM_H A WITH(NOLOCK)'+ char(10)
  END ELSE BEGIN
	SELECT @v_dSql +=  '        		FROM   FP_AMEND_PLAN_FORM_R A WITH(NOLOCK)' + char(10)  --SELECT @v_dSql += '
  END
  
  SELECT @v_dSql += '												INNER HASH JOIN ('+char(10)
  SELECT @v_dSql += '															SELECT	DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID,'+char(10)
  SELECT @v_dSql += '																	('+char(10)
  SELECT @v_dSql += '																		CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME'+char(10)
  SELECT @v_dSql += '																			 WHEN LEFT(A.FLOW_ID,5) = ''A9000''										THEN ISNULL(C.LEVEL_4_NAME, ''-'')'+char(10)
  SELECT @v_dSql += '																																					ELSE C.LEVEL_3_NAME'+char(10)
  SELECT @v_dSql += '																		END'+char(10)
  SELECT @v_dSql += '																	) AS ITEM_TYPE,'+char(10)
  SELECT @v_dSql += '																	ISNULL(A.NICK_NAME,''-'') AS NICK_NAME'+char(10)
  SELECT @v_dSql += '															FROM	SCM_ITEM_M A WITH(NOLOCK),'+char(10)
  SELECT @v_dSql += '																	SCM_ITEM_CLASS_M C WITH(NOLOCK)'+char(10)
  SELECT @v_dSql += '															WHERE	1=1'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
      SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)

  
  SELECT @v_dSql += '											                AND		A.ACTIVE_FLAG = ''Y'''+char(10)
  SELECT @v_dSql += '															AND		A.ITEM_CLASS  = C.CLASS_ID'+char(10)
  SELECT @v_dSql += '												) B'+char(10)
  SELECT @v_dSql += '												ON     A.COMPANY_ID  = B.COMPANY_ID'+char(10)
  SELECT @v_dSql += '												AND    A.DIVISION_ID = B.DIVISION_ID'+char(10)
  SELECT @v_dSql += '												AND    A.SITE_ID     = B.SITE_ID'+char(10)
  SELECT @v_dSql += '												AND    A.ITEM_ID     = B.ITEM_ID'+char(10)
  SELECT @v_dSql += '												INNER HASH JOIN SCM_ITEM_M C WITH(NOLOCK)'+char(10)
  SELECT @v_dSql += '												ON     1=1'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
      SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.SITE_ID' , 'EQ', @p_site_id)) + char(10)

  
  SELECT @v_dSql += '												AND		C.ACTIVE_FLAG = ''Y'''+char(10)
  SELECT @v_dSql += '												AND	   A.COMPANY_ID   = C.COMPANY_ID'+char(10)
  SELECT @v_dSql += '												AND    A.DIVISION_ID  = C.DIVISION_ID'+char(10)
  SELECT @v_dSql += '												AND    A.SITE_ID      = C.SITE_ID'+char(10)
  SELECT @v_dSql += '												AND    A.TOP_ITEM_ID  = C.ITEM_ID'+char(10)
  SELECT @v_dSql += '												INNER HASH JOIN SCM_LINE_M E WITH(NOLOCK)'+char(10)
  SELECT @v_dSql += '												ON     1=1'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
    SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('E.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('E.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('E.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
  SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('E.LINE_ID' , 'EQ', @p_line_id)) + char(10)
  SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('E.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
  SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('E.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)

  
  SELECT @v_dSql += '												AND	   A.COMPANY_ID     = E.COMPANY_ID'+char(10)
  SELECT @v_dSql += '												AND    A.DIVISION_ID    = E.DIVISION_ID'+char(10)
  SELECT @v_dSql += '												AND    A.SITE_ID        = E.SITE_ID'+char(10)
  SELECT @v_dSql += '												AND    A.PLANT_ID       = E.PLANT_ID'+char(10)
  SELECT @v_dSql += '												AND    A.FACTORY_ID     = E.FACTORY_ID'+char(10)
  SELECT @v_dSql += '												AND    A.OPERATION_ID   = E.OPERATION_ID'+char(10)
  SELECT @v_dSql += '												AND    A.LINE_ID        = E.LINE_ID'+char(10)
  SELECT @v_dSql += '												AND    A.ELECTRODE_TYPE = E.ELECTRODE_TYPE'+char(10)
  SELECT @v_dSql += '												LEFT OUTER HASH JOIN SCM_TACT_TIME_M F WITH(NOLOCK)'+char(10)
  SELECT @v_dSql += '												ON     1=1'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
    SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('F.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('F.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('F.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
 
  SELECT @v_dSql += '								                AND    F.OPERATION_ID = ''A9000'''+char(10)
  SELECT @v_dSql += '								                AND	   F.MONTH = CONVERT(VARCHAR(6),'+char(10)
  SELECT @v_dSql += '' + @v_bucket_from+''+char(10)
  SELECT @v_dSql += ')'+char(10)
  SELECT @v_dSql += '												AND	   A.COMPANY_ID     = E.COMPANY_ID'+char(10)
  SELECT @v_dSql += '												AND    A.DIVISION_ID    = E.DIVISION_ID'+char(10)
  SELECT @v_dSql += '												AND    A.SITE_ID        = E.SITE_ID'+char(10)
  SELECT @v_dSql += '												AND    A.PLANT_ID       = E.PLANT_ID'+char(10)
  SELECT @v_dSql += '												AND    CASE WHEN CHARINDEX(''-'',A.LINE_ID) > 0 THEN SUBSTRING(A.LINE_ID, 0, CHARINDEX(''-'',A.LINE_ID)) ELSE A.LINE_ID END = F.LINE_ID'+char(10)
  SELECT @v_dSql += '												AND    A.ITEM_ID		= F.ITEM_ID'+char(10)
  SELECT @v_dSql += '												LEFT OUTER HASH JOIN TRAY_INFO M'+char(10)
  SELECT @v_dSql += '												--inner HASH JOIN TRAY_INFO M'+char(10)
  SELECT @v_dSql += '												ON	1=1'+char(10)
  SELECT @v_dSql += '												--and m.group_tray_id =''XFSC'''+char(10)
  SELECT @v_dSql += '												AND	   A.COMPANY_ID     = M.COMPANY_ID'+char(10)
  SELECT @v_dSql += '												AND    A.DIVISION_ID    = M.DIVISION_ID'+char(10)
  SELECT @v_dSql += '												AND    A.SITE_ID        = M.SITE_ID'+char(10)
  SELECT @v_dSql += '												AND    A.PLANT_ID       = M.PLANT_ID'+char(10)
  SELECT @v_dSql += '												AND    A.LINE_ID       	= M.LINE_ID'+char(10)
  SELECT @v_dSql += '												AND	   A.ITEM_ID		= M.ITEM_ID'+char(10)
  SELECT @v_dSql += '										WHERE  1=1'+char(10)
  SELECT @v_dSql += '										AND	   A.INSTANCE_ID  ='+char(10)
  SELECT @v_dSql += '' + @v_instance_id+''+char(10)
  SELECT @v_dSql += '										AND    EXISTS 	('+char(10)
  SELECT @v_dSql += '															SELECT 1'+char(10)
  SELECT @v_dSql += '															FROM   FORM_PLAN CC'+char(10)
  SELECT @v_dSql += '															WHERE  A.INSTANCE_ID = CC.INSTANCE_ID'+char(10)
  SELECT @v_dSql += '															AND    A.FP_PLAN_ID  = CC.RELEASE_PLAN_ID'+char(10)
  SELECT @v_dSql += '														)'+char(10)
  SELECT @v_dSql += '										AND		(A.IN_QTY <> 0 OR A.AVAILABILITY <> 0 OR A.AGING_WIP <> 0 OR A.AGING_WIP_BD <> 0 OR A.AGING_WIP_AD <> 0 )'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
    SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
  SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
  SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
  SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
 
  SELECT @v_dSql += ' ' +@opt_6item_id +' '+''+char(10)--AND    A.ITEM_ID LIKE '%' + #ITEM_ID# + '%'
  SELECT @v_dSql += '										AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN'+char(10)
  SELECT @v_dSql += '' + @v_bucket_from+''+char(10)
  SELECT @v_dSql += ' AND'+char(10)
  SELECT @v_dSql += '' + @v_bucket_to+''+char(10)
  SELECT @v_dSql += '								) A'+char(10)
  SELECT @v_dSql += '						        		INNER JOIN ('+char(10)
  SELECT @v_dSql += '						                	SELECT *'+char(10)
  SELECT @v_dSql += '						                	FROM ('+char(10)
  SELECT @v_dSql += '						                				SELECT 100 AS CATE_ORDER, ''BEFORE DEGAS'' AS CATE_NAME, ''P_BD'' AS CATE_ID , ''CELL'' AS UOM_ID'+char(10)
  SELECT @v_dSql += '						                				UNION ALL'+char(10)
  SELECT @v_dSql += '														SELECT 150 AS CATE_ORDER, ''BEFORE DEGAS'' AS CATE_NAME, ''P_BD_TRAY'' AS CATE_ID , ''TRAY'' AS UOM_ID'+char(10)
  SELECT @v_dSql += '														UNION ALL'+char(10)
  SELECT @v_dSql += '														SELECT 200 AS CATE_ORDER, ''AFTER DEGAS'' AS CATE_NAME, ''P_AD'' AS CATE_ID , ''CELL'' AS UOM_ID'+char(10)
  SELECT @v_dSql += '														UNION ALL'+char(10)
  SELECT @v_dSql += '														SELECT 250 AS CATE_ORDER, ''AFTER DEGAS'' AS CATE_NAME, ''P_AD_TRAY'' AS CATE_ID , ''TRAY'' AS UOM_ID'+char(10)
  SELECT @v_dSql += '														UNION ALL'+char(10)
  SELECT @v_dSql += '														SELECT 300 AS CATE_ORDER, ''AGING WIP'' AS CATE_NAME, ''P_WIP'' AS CATE_ID , ''CELL'' AS UOM_ID'+char(10)
  SELECT @v_dSql += '														UNION ALL'+char(10)
  SELECT @v_dSql += '														SELECT 350 AS CATE_ORDER, ''AGING WIP'' AS CATE_NAME, ''P_WIP_TRAY'' AS CATE_ID , ''TRAY'' AS UOM_ID'+char(10)
  SELECT @v_dSql += '														UNION ALL'+char(10)
  SELECT @v_dSql += '														SELECT 400 AS CATE_ORDER, ''ACTIVATED'' AS CATE_NAME, ''P_ACT'' AS CATE_ID , ''CELL'' AS UOM_ID'+char(10)
  SELECT @v_dSql += '														UNION ALL'+char(10)
  SELECT @v_dSql += '														SELECT 450 AS CATE_ORDER, ''ACTIVATED'' AS CATE_NAME, ''P_ACT_TRAY'' AS CATE_ID , ''TRAY'' AS UOM_ID'+char(10)
  SELECT @v_dSql += '														UNION ALL'+char(10)
  SELECT @v_dSql += '														SELECT 500 AS CATE_ORDER, ''EOL'' AS CATE_NAME, ''P_OUT'' AS CATE_ID, ''CELL'' AS UOM_ID'+char(10)
  SELECT @v_dSql += '														UNION ALL'+char(10)
  SELECT @v_dSql += '														SELECT 550 AS CATE_ORDER, ''EOL'' AS CATE_NAME, ''P_OUT_TRAY'' AS CATE_ID, ''TRAY'' AS UOM_ID'+char(10)
  SELECT @v_dSql += '									            ) A'+char(10)
  SELECT @v_dSql += '									            WHERE CATE_ID <> ''X'''+char(10)
  SELECT @v_dSql += '								        ) D'+char(10)
  SELECT @v_dSql += '								        ON     1=1'+char(10)
  SELECT @v_dSql += '				        				INNER HASH JOIN TH_UIS_CAL G WITH(NOLOCK)'+char(10)
  SELECT @v_dSql += '								        ON  A.PLAN_DATE       = G.DT'+char(10)
  SELECT @v_dSql += '					        WHERE  1=1'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
  SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
  SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
  SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)


  SELECT @v_dSql += '			                AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN'+char(10)
  SELECT @v_dSql += '' + @v_bucket_from+''+char(10)
  SELECT @v_dSql += ' AND'+char(10)
  SELECT @v_dSql += '' + @v_bucket_to+''+char(10)
  SELECT @v_dSql += '					        GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TRAY_FACTORY_ID'+char(10)
  SELECT @v_dSql += '					                , A.CELL_GROUP_CODE, A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME'+char(10)
  SELECT @v_dSql += '					                , A.OPERATION_ID'+char(10)
  SELECT @v_dSql += '					                , A.MARKET, A.PRODUCTION_TYPE'+char(10)
  SELECT @v_dSql += '					                , A.FACTORY_ID, A.LOCATION'+char(10)
  SELECT @v_dSql += '					                , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE'+char(10)
  SELECT @v_dSql += '					                , D.CATE_NAME, D.CATE_ID, D.CATE_ORDER, D.UOM_ID'+char(10)
  SELECT @v_dSql += '					                , A.GROUP_TRAY_ID'+char(10)
  SELECT @v_dSql += '									, A.TRAY_ID'+char(10)
  SELECT @v_dSql += '									, A.TRAY_NAME'+char(10)
  SELECT @v_dSql += '									, A.TRAY_TYPE'+char(10)
  SELECT @v_dSql += '									, ISNULL(A.TRAY_ID, A.ITEM_ID)'+char(10)
  SELECT @v_dSql += '					)'+char(10)
  SELECT @v_dSql += '					SELECT	A.*'+char(10)
  SELECT @v_dSql += '							, MAX(CASE WHEN CATEGORY_ID = ''P_OUT'' THEN A.BOH_QTY - A.BOH_HOLD - (A.PKG_CAPA*BUFFER_DAY) ELSE 0 END) OVER (PARTITION BY A.DIVISION_ID, A.GROUP_IDX ) AS BOH_SUM'+char(10)
  SELECT @v_dSql += '							, MAX(CASE WHEN CATEGORY_ID = ''P_OUT'' THEN A.BOH_QTY + A.BOH_INT - A.BOH_HOLD - (A.PKG_CAPA*BUFFER_DAY) ELSE 0 END) OVER (PARTITION BY A.DIVISION_ID, A.GROUP_IDX ) AS BOH_INT_SUM'+char(10)
  SELECT @v_dSql += '					FROM	('+char(10)
  SELECT @v_dSql += '								SELECT 	A.*'+char(10)
  SELECT @v_dSql += '										, case when psi= ''P'' then MAX(CASE WHEN C.ITEM_ID IS NULL THEN 0 ELSE A.ORG_PKG_CAPA END) OVER (PARTITION BY A.DIVISION_ID, A.TRAY_FACTORY_ID, A.GROUP_TRAY_ID) else null end AS PKG_CAPA'+char(10)
  SELECT @v_dSql += '										, case when psi= ''P'' then MAX(CASE WHEN C.ITEM_ID IS NULL THEN 0 ELSE A.ORG_PKG_CAPA_CELL END) OVER (PARTITION BY A.DIVISION_ID, A.TRAY_FACTORY_ID, A.GROUP_TRAY_ID) else null end AS PKG_CAPA_CELL'+char(10)
  SELECT @v_dSql += '										, DENSE_RANK() OVER (PARTITION BY A.DIVISION_ID ORDER BY A.TRAY_FACTORY_ID, A.GROUP_TRAY_ID ) AS GROUP_IDX'+char(10)
  SELECT @v_dSql += '										, COUNT(A.GROUP_TRAY_ID) OVER (PARTITION BY A.DIVISION_ID, A.TRAY_FACTORY_ID, A.GROUP_TRAY_ID ) AS GROUP_CNT'+char(10)
  SELECT @v_dSql += '										--, DENSE_RANK() OVER (PARTITION BY A.DIVISION_ID ORDER BY A.TRAY_TYPE, A.GROUP_TRAY_ID ) AS GROUP_IDX'+char(10)
  SELECT @v_dSql += '										--, COUNT(A.GROUP_TRAY_ID) OVER (PARTITION BY A.TRAY_TYPE, A.GROUP_TRAY_ID ) AS GROUP_CNT'+char(10)
  SELECT @v_dSql += '										--, CEILING(ISNULL(B.BOH_HOLD,0) / FLOOR(A.CELL_CNT * A.LOAD_YIELD)) AS BOH_HOLD'+char(10)
  SELECT @v_dSql += '										, MAX(ROUND(ISNULL(B.BOH_HOLD,0) / (A.CELL_CNT * A.LOAD_YIELD) ,0) + (CASE WHEN (ISNULL(B.BOH_HOLD,0) % (A.CELL_CNT * A.LOAD_YIELD)) > 0 THEN 1 ELSE 0 END) ) OVER (PARTITION BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TRAY_FACTORY_ID , A.TRAY_ID ) AS BOH_HOLD'+char(10)
  SELECT @v_dSql += '								FROM 	('+char(10)
  SELECT @v_dSql += '											SELECT *'+char(10)
  SELECT @v_dSql += '											FROM MAIN_P'+char(10)
  SELECT @v_dSql += '											UNION ALL'+char(10)
  SELECT @v_dSql += '											SELECT *'+char(10)
  SELECT @v_dSql += '											FROM MAIN_I'+char(10)
  SELECT @v_dSql += '									  	) A'+char(10)
  SELECT @v_dSql += '										LEFT OUTER HASH JOIN ('+char(10)
  --SELECT @v_dSql += '												SELECT 	B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.LINE_ID, B.ITEM_ID, SUM(ORIGINAL_QTY) AS BOH_HOLD'+char(10)
  SELECT @v_dSql += '												SELECT 	B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.LINE_ID, SUM(ORIGINAL_QTY) AS BOH_HOLD, (CASE WHEN C.IS_CELL_ASSY = ''Y'' THEN ISNULL(D.CELL_ASSY_ITEM_ID, B.ITEM_ID) ELSE B.ITEM_ID END) AS ITEM_ID ' + char(10) -- 활성화 분리 처리... 20230619
  SELECT @v_dSql += '												FROM   	SCM_AGING_STOCK_H B WITH(NOLOCK)'+char(10)
  SELECT @v_dSql += '												LEFT OUTER JOIN ( '+char(10)
  SELECT @v_dSql += '													SELECT (CASE WHEN MAX(B.SEGMENT1) IS NULL THEN ''N'' ELSE ''Y'' END) AS IS_CELL_ASSY '+char(10)
  SELECT @v_dSql += '													FROM   SCM_SYS_LOOKUP_VALUE  B WITH(NOLOCK) '+char(10)
  SELECT @v_dSql += '													WHERE  B.ACTIVE_FLAG = ''Y'' '+char(10)

  -- 2023-07-25 FROM CELL_PRODUCT_ASSY
  --SELECT @v_dSql += '													AND    B.LOOKUP_TYPE_CODE = ''CELL_PRODUCT_ASSY'' '+char(10)
  --SELECT @v_dSql += '													AND    B.SEGMENT1 IN ( '+char(10)
  --SELECT @v_dSql += '														SELECT MAX(SITE_ID) '+char(10)
  --SELECT @v_dSql += '														FROM   FP_INSTANCE_INFO_V V WITH(NOLOCK) '+char(10)
  --SELECT @v_dSql += '														WHERE  V.INSTANCE_ID = ' + @v_instance_id + ' '+char(10)
  --SELECT @v_dSql += '													) '+char(10)
  -- TO 
  SELECT @v_dSql += '													AND    B.LOOKUP_TYPE_CODE = ''CELL_PRODUCT_ASSY_INSTANCE'' '+char(10)
  SELECT @v_dSql += '													AND    B.SEGMENT1 = ' + @v_instance_id + ' '+char(10)

  SELECT @v_dSql += '												) C '+char(10)
  SELECT @v_dSql += '												ON  1=1 '+char(10)
  SELECT @v_dSql += '												LEFT OUTER JOIN FP_CELL_ASSY_PRODUCT_MAP_V D WITH(NOLOCK) '+char(10)
  SELECT @v_dSql += '												ON  1=1 '+char(10)
  SELECT @v_dSql += '												AND B.COMPANY_ID  = D.COMPANY_ID '+char(10)
  SELECT @v_dSql += '												AND B.DIVISION_ID = D.DIVISION_ID '+char(10)
  SELECT @v_dSql += '												AND B.SITE_ID     = D.SITE_ID '+char(10)
  SELECT @v_dSql += '												AND B.ITEM_ID     = D.CELL_PRODUCT_ITEM_ID '+char(10)
  SELECT @v_dSql += '												WHERE  	1=1'+char(10)
  SELECT @v_dSql += '												AND		B.QTY 			= 0'+char(10)
  SELECT @v_dSql += '												AND    	B.ORIGINAL_QTY 	> 0'+char(10)
  SELECT @v_dSql += '												AND    	B.CUTOFF_DATE 	='+char(10)
  SELECT @v_dSql += '' + @v_plan_date+''+char(10)
  --SELECT @v_dSql += '												GROUP BY B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.LINE_ID, B.ITEM_ID'+char(10)
  SELECT @v_dSql += '												GROUP BY B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.LINE_ID, (CASE WHEN C.IS_CELL_ASSY = ''Y'' THEN ISNULL(D.CELL_ASSY_ITEM_ID, B.ITEM_ID) ELSE B.ITEM_ID END) '+char(10) -- 활성화 분리 처리... 20230619
  SELECT @v_dSql += '										) B'+char(10)
  SELECT @v_dSql += '											ON	1=1'+char(10)
  SELECT @v_dSql += '											AND	A.COMPANY_ID = B.COMPANY_ID'+char(10)
  SELECT @v_dSql += '											AND	A.DIVISION_ID = B.DIVISION_ID'+char(10)
  SELECT @v_dSql += '											AND	A.SITE_ID = B.SITE_ID'+char(10)
  SELECT @v_dSql += '											AND	A.PLANT_ID = B.PLANT_ID'+char(10)
  SELECT @v_dSql += '											AND	A.LINE_ID = B.LINE_ID'+char(10)
  SELECT @v_dSql += '											AND	A.ITEM_ID = B.ITEM_ID'+char(10)
  SELECT @v_dSql += '									   LEFT OUTER HASH JOIN ASSY_ITEM C'+char(10)
  SELECT @v_dSql += '											ON	1=1'+char(10)
  SELECT @v_dSql += '											AND	A.COMPANY_ID = C.COMPANY_ID'+char(10)
  SELECT @v_dSql += '											AND	A.DIVISION_ID = C.DIVISION_ID'+char(10)
  SELECT @v_dSql += '											AND	A.SITE_ID = C.SITE_ID'+char(10)
  SELECT @v_dSql += '											AND	A.PLANT_ID = C.PLANT_ID'+char(10)
  SELECT @v_dSql += '											AND	CASE WHEN CHARINDEX(''-'',A.LINE_ID) > 0 THEN SUBSTRING(A.LINE_ID, 0, CHARINDEX(''-'',A.LINE_ID)) ELSE A.LINE_ID END = C.LINE_ID'+char(10)
  SELECT @v_dSql += '											AND	A.ITEM_ID = C.ITEM_ID'+char(10)
  SELECT @v_dSql += '								WHERE 1=1'+char(10)
  SELECT @v_dSql += '								--AND DEGAS_BEFORE_TYPE IN ( ''D'', ''E'', ''A'' )'+char(10)
  SELECT @v_dSql += '								--AND DEGAS_BEFORE_TYPE = ''X'''+char(10)
  SELECT @v_dSql += '							)	A'+char(10)
  SELECT @v_dSql += '					WHERE	1=1'+char(10)
  SELECT @v_dSql += ' ' +@opt_17group_tray_id +' '+''+char(10)--AND   A.GROUP_TRAY_ID LIKE '%' + RTRIM(LTRIM(#GROUP_TRAY_ID#)) + '%'
  SELECT @v_dSql += '					ORDER BY case when A.TRAY_FACTORY_ID IS NULL THEN ''ZZZZ'' ELSE A.TRAY_FACTORY_ID END , CASE WHEN ISNULL(DEGAS_BEFORE_TYPE,''X'') = ''X'' THEN ''ZZZZ'' ELSE ISNULL(A.GROUP_TRAY_ID,''ZZZZ'') END, A.SORT_IDX'+char(10)
  SELECT @v_dSql += '							, CASE WHEN A.PSI = ''P'' THEN 10 ELSE 90 END'+char(10)
  SELECT @v_dSql += '							, A.TRAY_TYPE,  A.TRAY_NAME, A.TEMP_TRAY_ID'+char(10)
  SELECT @v_dSql += '							, A.ITEM_ID, A.NICK_NAME, A.FACTORY_ID, A.LINE_ID'+char(10)
  SELECT @v_dSql += '							, CATEGORY_ORDER'+char(10)



  IF @p_sys_type = 'SQL'
  BEGIN
    -- return SQL Query Source
    select @v_dSql as [QUERY_VALUE]
	--select @p_ctrl_cate as [QUERY_VALUE]
  END ELSE BEGIN
    SET @runstart = GetDate()

    BEGIN TRY
      BEGIN TRAN
         --run dynamic sql
        exec sp_executesql @v_dSql
      COMMIT TRAN
    END TRY
    BEGIN CATCH
      ROLLBACK
      SET @runend = GetDate()
      exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend

    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
