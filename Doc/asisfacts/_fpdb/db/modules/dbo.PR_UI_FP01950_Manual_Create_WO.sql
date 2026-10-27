
CREATE
PROCEDURE [dbo].[PR_UI_FP01950_Manual_Create_WO]
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
/** 프로그램 ID   : PR_UI_FP01950_Manual_Create_WO                                            **/
/** 프로그램 명   : Procedure PR_UI_FP01950_Manual_Create_WO                                  **/
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
/** 2022-04-12     XPDbToProcedure      Auto Generated With Initial Setting                   **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP01950_Manual_Create_WO
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP01950_Manual_Create_WO'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0

  DECLARE @p_wo_base_date nvarchar(max) = ''
  DECLARE @p_operation_id nvarchar(max) = ''
  DECLARE @p_item_id nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''

  DECLARE @v_user_id nvarchar(max)
  DECLARE @v_site_id nvarchar(max)
  DECLARE @v_active_flag nvarchar(max)
  DECLARE @v_item_id nvarchar(max)
  DECLARE @v_nick_name nvarchar(max)
  DECLARE @v_fcs_model_id nvarchar(max)
  DECLARE @v_division_lt nvarchar(max)
  DECLARE @v_plant_lt nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  /*
  DECLARE @opt_0site_id nvarchar(max)
  DECLARE @opt_1active_flag nvarchar(max)
  DECLARE @opt_2item_id nvarchar(max)
  DECLARE @opt_3nick_name nvarchar(max)
  DECLARE @opt_4fcs_model_id nvarchar(max)
  DECLARE @opt_5site_id nvarchar(max)
  DECLARE @opt_6active_flag nvarchar(max)
  DECLARE @opt_7item_id nvarchar(max)
  DECLARE @opt_8nick_name nvarchar(max)
  DECLARE @opt_9fcs_model_id nvarchar(max)
  */

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
    END ELSE IF @tmp_column = 'WO_BASE_DATE' BEGIN
      SET @p_wo_base_date =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'OPERATION_ID' BEGIN
      SET @p_operation_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ITEM_ID' BEGIN
      SET @p_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);

	  /*
    END ELSE IF @tmp_column = 'NICK_NAME' BEGIN
      SET @p_nick_name =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'FCS_MODEL_ID' BEGIN
      SET @p_fcs_model_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
      SET @p_division_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLANT_ID' BEGIN
      SET @p_plant_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PARAM' BEGIN
      SET @p_param =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
      SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
		*/
	END
  END
  --SET @p_user_id = dbo.FN_deCRYPT_AES128(@p_user_id)
  
  /*
  SET @v_user_id ='''' + @p_user_id + ''''
  SET @v_site_id ='''' + @p_site_id + ''''
  SET @v_active_flag ='''' + @p_active_flag + ''''
  SET @v_item_id ='''' + @p_item_id + ''''
  SET @v_nick_name ='''' + @p_nick_name + ''''
  SET @v_fcs_model_id ='''' + @p_fcs_model_id + ''''
  SET @v_division_lt ='''' + @p_division_lt + ''''
  SET @v_plant_lt ='''' + @p_plant_lt + ''''
  SET @v_param ='''' + @p_param + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''

  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_0site_id = ''
  END ELSE BEGIN
    SET @opt_0site_id = 'AND    A.SITE_ID = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_active_flag)
  IF @STRLEN< 1  BEGIN
    SET @opt_1active_flag = ''
  END ELSE BEGIN
    SET @opt_1active_flag = 'AND    A.USE_YN = ' + @v_active_flag+''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_2item_id = ''
  END ELSE BEGIN
    SET @opt_2item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_nick_name)
  IF @STRLEN< 1  BEGIN
    SET @opt_3nick_name = ''
  END ELSE BEGIN
    SET @opt_3nick_name = 'AND    C.NICK_NAME LIKE ''%'' + ' + @v_nick_name+' + ''%'''
  END
  SET @STRLEN = LEN(@p_fcs_model_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_4fcs_model_id = ''
  END ELSE BEGIN
    SET @opt_4fcs_model_id = 'AND    A.FCS_MODEL_ID LIKE ''%'' + ' + @v_fcs_model_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_5site_id = ''
  END ELSE BEGIN
    SET @opt_5site_id = 'AND    A.SITE_ID = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_active_flag)
  IF @STRLEN< 1  BEGIN
    SET @opt_6active_flag = ''
  END ELSE BEGIN
    SET @opt_6active_flag = 'AND    A.USE_YN = ' + @v_active_flag+''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_7item_id = ''
  END ELSE BEGIN
    SET @opt_7item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_nick_name)
  IF @STRLEN< 1  BEGIN
    SET @opt_8nick_name = ''
  END ELSE BEGIN
    SET @opt_8nick_name = 'AND    C.NICK_NAME LIKE ''%'' + ' + @v_nick_name+' + ''%'''
  END
  SET @STRLEN = LEN(@p_fcs_model_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_9fcs_model_id = ''
  END ELSE BEGIN
    SET @opt_9fcs_model_id = 'AND    A.FCS_MODEL_ID LIKE ''%'' + ' + @v_fcs_model_id+' + ''%'''
  END
  */


  -- FP00414 find_FP00414 
  SET @v_dSql = ''
  SET @v_dSql += 'SELECT(CASE WHEN PROCESSING_YN = ''N'' THEN ''1'' ELSE ''0'' END) AS _SELECT ' + char(10)
  SET @v_dSql += '    ,A.SEQ ' + char(10)
  SET @v_dSql += '    ,A.STATUS ' + char(10)
  SET @v_dSql += '    ,A.WO_BASE_DATE ' + char(10)
  SET @v_dSql += '    ,A.FACTORY_ID ' + char(10)
  SET @v_dSql += '    ,A.LINE_ID ' + char(10)
  SET @v_dSql += '    ,A.OPERATION_ID ' + char(10)
  SET @v_dSql += '    ,A.EQUIPMENT_ID ' + char(10)
  SET @v_dSql += '    ,A.ITEM_ID ' + char(10)
  SET @v_dSql += '    ,A.WORK_CENTER_ID ' + char(10)
  SET @v_dSql += '    ,A.WO_ID ' + char(10)
  SET @v_dSql += '    ,A.MO_ID ' + char(10)
  SET @v_dSql += '    ,A.ORDER_TYPE ' + char(10)
  SET @v_dSql += '    ,A.WO_TYPE ' + char(10)
  SET @v_dSql += '    ,A.START_TIME, A.END_TIME ' + char(10)
  SET @v_dSql += '    ,A.IN_QTY, A.OUT_QTY, A.LANE_QTY, A.BATCH_QTY ' + char(10)
  SET @v_dSql += '    ,A.MARKET ' + char(10)
  SET @v_dSql += '    ,A.PROCESSING_YN ' + char(10)
  SET @v_dSql += '    ,CONVERT(VARCHAR, A.ORDER_CREAT_DATE, 20) AS ORDER_CREAT_DATE ' + char(10)
  SET @v_dSql += '    ,CONVERT(VARCHAR, A.CREATE_DATE, 20) AS CREATE_DATE, A.CREATE_PSN_ID ' + char(10)
  SET @v_dSql += '    ,CONVERT(VARCHAR, A.UPDATE_DATE, 20) AS UPDATE_DATE, A.UPDATE_PSN_ID ' + char(10)
  SET @v_dSql += '    ,A.ERROR_MSG ' + char(10)
  SET @v_dSql += '    ,CASE WHEN XIF2.CREATE_DATE > XIF1.CREATE_DATE THEN ISNULL(XIF2.MESSAGE,XIF1.E_MESSAGE) ELSE ISNULL(XIF1.E_MESSAGE,XIF2.MESSAGE) END AS ERP_RESULT ' + char(10)
  SET @v_dSql += '    ,A.REQUESTER, A.REQUEST_TYPE, A.REQUEST_REASON ' + char(10)
  SET @v_dSql += '    ,A.TOP_ITEM_ID ' + char(10)
  SET @v_dSql += '    ,A.CSR_ID' + char(10)
  SET @v_dSql += '    ,A.WORK_REQUEST_MODEL_ID,	A.VERSION,	A.PROD_SEQ,	A.PLM_EC_NO' + char(10)
  --WORK_REQUEST_MODEL_ID	VERSION	PROD_SEQ	PLM_EC_NO

  SET @v_dSql += 'FROM   SCM_MANUAL_WO_CREATE A ' + char(10)
  SET @v_dSql += 'LEFT OUTER JOIN ( ' + char(10)
  SET @v_dSql += '    SELECT A.E_MESSAGE, A.WO_NO, A.CREATE_DATE ' + char(10)
  SET @v_dSql += '    FROM ( ' + char(10)
  SET @v_dSql += '        SELECT ROW_NUMBER( ) OVER(PARTITION BY XIF1.WO_NO ORDER BY XIF1.WO_NO, XIF1.CREATE_DATE DESC) AS ROW_NUM, XIF1.E_MESSAGE ' + char(10)
  SET @v_dSql += '			 , XIF1.WO_NO, XIF1.CREATE_DATE ' + char(10)
  SET @v_dSql += '        FROM   SY_XIF_ERP_WORK_ORDER_RESULT_R XIF1 WITH(NOLOCK) ' + char(10)
  SET @v_dSql += '    ) A ' + char(10)
  SET @v_dSql += '    WHERE ROW_NUM = 1 ' + char(10)
  SET @v_dSql += ') XIF1 ' + char(10)
  SET @v_dSql += 'ON XIF1.WO_NO = A.WO_ID ' + char(10)
  SET @v_dSql += 'LEFT OUTER JOIN ( ' + char(10)
  SET @v_dSql += '    SELECT A.MESSAGE, A.WORKORDERID, A.CREATE_DATE ' + char(10)
  SET @v_dSql += '    FROM ( ' + char(10)
  SET @v_dSql += '        SELECT ROW_NUMBER( ) OVER(PARTITION BY XIF2.WORKORDERID ORDER BY XIF2.WORKORDERID, XIF2.CREATE_DATE DESC) AS ROW_NUM, XIF2.MESSAGE ' + char(10)
  SET @v_dSql += '             , XIF2.WORKORDERID, XIF2.CREATE_DATE ' + char(10)
  SET @v_dSql += '        FROM   SY_XIF_ERP_PRODUCTION_PLAN_LOG XIF2 WITH(NOLOCK) ' + char(10)
  SET @v_dSql += '    ) A ' + char(10)
  SET @v_dSql += '    WHERE ROW_NUM = 1 ' + char(10)
  SET @v_dSql += ') XIF2 ' + char(10)
  SET @v_dSql += 'ON XIF2.WORKORDERID = A.WO_ID ' + char(10)
  SET @v_dSql += 'WHERE  1=1 ' + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.WO_BASE_DATE' , 'EQ', @p_wo_base_date)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id)) + char(10)
  SET @v_dSql += 'ORDER BY A.SEQ ' + char(10)


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
      exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
