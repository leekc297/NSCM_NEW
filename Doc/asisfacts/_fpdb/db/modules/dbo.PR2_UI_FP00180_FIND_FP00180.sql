CREATE PROCEDURE [dbo].[PR2_UI_FP00180_FIND_FP00180]
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
/** 프로그램 ID   : PR_UI_FP00180_FIND_FP00180                                                **/
/** 프로그램 명   : Procedure PR_UI_FP00180_FIND_FP00180                                      **/
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
/** 2021-06-30     XPDbToProcedure      Auto Generated With Initial Setting                   **/
/** 2024-02-15     leejsthira2      operation id 기준 테이블 변경                             **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00180_FIND_FP00180
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
  DECLARE @v_proc_name nvarchar(100) = 'PR2_UI_FP00180_FIND_FP00180'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_site_id nvarchar(max) = ''
  DECLARE @p_item_type nvarchar(max) = ''
  DECLARE @p_item_id nvarchar(max) = ''
  DECLARE @p_item_class nvarchar(max) = ''
  DECLARE @p_nick_name nvarchar(max) = ''
  DECLARE @p_nick_name_lt nvarchar(max) = ''
  DECLARE @p_item_class_level_1 nvarchar(max) = ''
  DECLARE @p_item_class_level_2 nvarchar(max) = ''
  DECLARE @p_active_flag nvarchar(max) = ''
  DECLARE @p_division_id nvarchar(max) = ''
  DECLARE @p_model_id nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''


  DECLARE @v_user_id nvarchar(max)
  DECLARE @v_site_id nvarchar(max)
  DECLARE @v_item_type nvarchar(max)
  DECLARE @v_item_id nvarchar(max)
  DECLARE @v_item_class nvarchar(max)
  DECLARE @v_nick_name nvarchar(max)
  DECLARE @v_item_class_level_1 nvarchar(max)
  DECLARE @v_item_class_level_2 nvarchar(max)
  DECLARE @v_active_flag nvarchar(max)
  DECLARE @v_division_lt nvarchar(max)
  DECLARE @v_model_id nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  DECLARE @opt_0site_id nvarchar(max)
  DECLARE @opt_1item_type nvarchar(max)
  DECLARE @opt_2item_id nvarchar(max)
  DECLARE @opt_3item_class nvarchar(max)
  DECLARE @opt_4nick_name nvarchar(max)
  DECLARE @opt_5item_class_level_1 nvarchar(max)
  DECLARE @opt_6item_class_level_2 nvarchar(max)
  DECLARE @opt_7active_flag nvarchar(max)
  DECLARE @opt_8site_id nvarchar(max)
  DECLARE @opt_9item_type nvarchar(max)
  DECLARE @opt_10item_id nvarchar(max)
  DECLARE @opt_11item_class nvarchar(max)
  DECLARE @opt_12nick_name nvarchar(max)
  DECLARE @opt_13item_class_level_1 nvarchar(max)
  DECLARE @opt_14item_class_level_2 nvarchar(max)
  DECLARE @opt_15active_flag nvarchar(max)

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
    END ELSE IF @tmp_column = 'SITE_ID' BEGIN
      SET @p_site_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ITEM_TYPE' BEGIN
      SET @p_item_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ITEM_ID' BEGIN
      SET @p_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ITEM_CLASS' BEGIN
      SET @p_item_class =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'NICK_NAME' BEGIN
      SET @p_nick_name =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'NICK_NAME_LT' BEGIN
      SET @p_nick_name_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ITEM_CLASS_LEVEL_1' BEGIN
      SET @p_item_class_level_1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ITEM_CLASS_LEVEL_2' BEGIN
      SET @p_item_class_level_2 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ACTIVE_FLAG' BEGIN
      SET @p_active_flag =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
      SET @p_division_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'MODEL_ID' BEGIN
      SET @p_model_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PARAM' BEGIN
      SET @p_param =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
      SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END
  --SET @p_user_id = dbo.FN_deCRYPT_AES128(@p_user_id)
  
  SET @v_user_id ='''' + @p_user_id + ''''
  SET @v_site_id ='''' + @p_site_id + ''''
  SET @v_item_type ='''' + @p_item_type + ''''
  SET @v_item_id ='''' + @p_item_id + ''''
  SET @v_item_class ='''' + @p_item_class + ''''
  SET @v_nick_name ='''' + @p_nick_name + ''''
  SET @v_item_class_level_1 ='''' + @p_item_class_level_1 + ''''
  SET @v_item_class_level_2 ='''' + @p_item_class_level_2 + ''''
  SET @v_active_flag ='''' + @p_active_flag + ''''
  SET @v_division_lt ='''' + @p_division_id + ''''
  SET @v_model_id ='''' + @p_model_id + ''''
  SET @v_param ='''' + @p_param + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''

  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_0site_id = ''
  END ELSE BEGIN
    SET @opt_0site_id = 'AND   A.SITE_ID=' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_item_type)
  IF @STRLEN< 1  BEGIN
    SET @opt_1item_type = ''
  END ELSE BEGIN
    SET @opt_1item_type = 'AND   A.ITEM_TYPE=' + @v_item_type+''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_2item_id = ''
  END ELSE BEGIN
    SET @opt_2item_id = 'AND   A.ITEM_ID LIKE ''%'' + RTRIM(LTRIM( ' + @v_item_id+' )) + ''%'''
  END
  SET @STRLEN = LEN(@p_item_class)
  IF @STRLEN< 1  BEGIN
    SET @opt_3item_class = ''
  END ELSE BEGIN
    SET @opt_3item_class = 'AND   A.ITEM_CLASS LIKE ''%'' + RTRIM(LTRIM( ' + @v_item_class+' )) + ''%'''
  END
  SET @STRLEN = LEN(@p_nick_name)
  IF @STRLEN< 1  BEGIN
    SET @opt_4nick_name = ''
  END ELSE BEGIN
    SET @opt_4nick_name = 'AND   A.NICK_NAME LIKE ''%'' + RTRIM(LTRIM( ' + @v_nick_name+' )) + ''%'''
  END
  SET @STRLEN = LEN(@p_item_class_level_1)
  IF @STRLEN< 1  BEGIN
    SET @opt_5item_class_level_1 = ''
  END ELSE BEGIN
    SET @opt_5item_class_level_1 = 'AND   B.LEVEL_1_CODE=' + @v_item_class_level_1+''
  END
  SET @STRLEN = LEN(@p_item_class_level_2)
  IF @STRLEN< 1  BEGIN
    SET @opt_6item_class_level_2 = ''
  END ELSE BEGIN
    SET @opt_6item_class_level_2 = 'AND   B.LEVEL_2_CODE=' + @v_item_class_level_2+''
  END
  SET @STRLEN = LEN(@p_active_flag)
  IF @STRLEN< 1  BEGIN
    SET @opt_7active_flag = ''
  END ELSE BEGIN
    SET @opt_7active_flag = 'AND   A.ACTIVE_FLAG=' + @v_active_flag+''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_8site_id = ''
  END ELSE BEGIN
    SET @opt_8site_id = 'AND   A.SITE_ID=' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_item_type)
  IF @STRLEN< 1  BEGIN
    SET @opt_9item_type = ''
  END ELSE BEGIN
    SET @opt_9item_type = 'AND   A.ITEM_TYPE=' + @v_item_type+''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_10item_id = ''
  END ELSE BEGIN
    SET @opt_10item_id = 'AND   A.ITEM_ID LIKE ''%'' + RTRIM(LTRIM( ' + @v_item_id+' )) + ''%'''
  END
  SET @STRLEN = LEN(@p_item_class)
  IF @STRLEN< 1  BEGIN
    SET @opt_11item_class = ''
  END ELSE BEGIN
    SET @opt_11item_class = 'AND   A.ITEM_CLASS LIKE ''%'' + RTRIM(LTRIM( ' + @v_item_class+' )) + ''%'''
  END
  SET @STRLEN = LEN(@p_nick_name)
  IF @STRLEN< 1  BEGIN
    SET @opt_12nick_name = ''
  END ELSE BEGIN
    SET @opt_12nick_name = 'AND   A.NICK_NAME LIKE ''%'' + RTRIM(LTRIM( ' + @v_nick_name+' )) + ''%'''
  END
  SET @STRLEN = LEN(@p_item_class_level_1)
  IF @STRLEN< 1  BEGIN
    SET @opt_13item_class_level_1 = ''
  END ELSE BEGIN
    SET @opt_13item_class_level_1 = 'AND   B.LEVEL_1_CODE=' + @v_item_class_level_1+''
  END
  SET @STRLEN = LEN(@p_item_class_level_2)
  IF @STRLEN< 1  BEGIN
    SET @opt_14item_class_level_2 = ''
  END ELSE BEGIN
    SET @opt_14item_class_level_2 = 'AND   B.LEVEL_2_CODE=' + @v_item_class_level_2+''
  END
  SET @STRLEN = LEN(@p_active_flag)
  IF @STRLEN< 1  BEGIN
    SET @opt_15active_flag = ''
  END ELSE BEGIN
    SET @opt_15active_flag = 'AND   A.ACTIVE_FLAG=' + @v_active_flag+''
  END

/*
DECLARE @PARAMS NVARCHAR(MAX)

SET @PARAMS = ''
SET @PARAMS += ' @P_SYS_TYPE	= ''' +ISNULL(@P_SYS_TYPE,'')	+ '''' + CHAR(10)
SET @PARAMS += ',@P_SYS_FLAG	= ''' +ISNULL(@P_SYS_FLAG,'')	+ '''' + CHAR(10)
SET @PARAMS += ',@P_SYS_GUBUN	= ''' +ISNULL(@P_SYS_GUBUN,'')	+ '''' + CHAR(10)
SET @PARAMS += ',@P_USER_ID		= ''' +ISNULL(@P_USER_ID,'')	+ '''' + CHAR(10)
SET @PARAMS += ',@in_columns	= ''' +ISNULL(@in_columns,'')	+ '''' + CHAR(10)
SET @PARAMS += ',@in_row		= ''' +ISNULL(@in_row,'')		+ '''' + CHAR(10)
SET @PARAMS += ',@opt_none		= ''' +ISNULL(@opt_none,'')		+ '''' + CHAR(10)

IF @P_SYS_TYPE = 'SQL' BEGIN
	SELECT @PARAMS AS SQL
	RETURN
END
*/


  -- FP00180 find_FP00180  
  SET @v_dSql = ''
  --SET @v_dSql += @p_nick_name_lt
  --SELECT @v_dSql as sql
  --RETURN 1
  SET @v_dSql += '      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.APPLIED_MODEL'+char(10)
  SET @v_dSql += '            ,A.ITEM_ID, A.ITEM_NAME, ISNULL(A.NICK_NAME, ''-'') AS NICK_NAME'+char(10)
  SET @v_dSql += '            ,A.ITEM_TYPE'+char(10)
  SET @v_dSql += '            ,B.LEVEL_1_CODE, B.LEVEL_1_ID, B.LEVEL_1_NAME AS ITEM_CLASS_LEVEL_1'+char(10)
  SET @v_dSql += '            ,B.LEVEL_2_CODE, B.LEVEL_2_ID, B.LEVEL_2_NAME AS ITEM_CLASS_LEVEL_2'+char(10)
  SET @v_dSql += '            ,B.LEVEL_3_CODE, B.LEVEL_3_ID, B.LEVEL_3_NAME AS ITEM_CLASS_LEVEL_3'+char(10)
  SET @v_dSql += '            ,B.LEVEL_4_CODE, B.LEVEL_4_ID, B.LEVEL_4_NAME AS ITEM_CLASS_LEVEL_4'+char(10)
  SET @v_dSql += '            ,A.ITEM_CLASS, A.ITEM_CLASS_NAME'+char(10)
  SET @v_dSql += '            ,A.MATERIAL_CLASS, A.MATERIAL_CLASS_NAME'+char(10)
  SET @v_dSql += '            ,A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '            ,A.SIDE_TYPE'+char(10)
  SET @v_dSql += '            ,A.ITEM_GROUP_ID'+char(10)
  SET @v_dSql += '            ,A.SETUP_GROUP_ID_1, A.SETUP_GROUP_ID_2, A.SETUP_GROUP_ID_3'+char(10)
  SET @v_dSql += '            ,A.FLOW_ID'+char(10)
  SET @v_dSql += '            ,A.ERP_EOL, A.SCP_EOL'+char(10)
  SET @v_dSql += '            ,A.ITEM_UOM'+char(10)
  SET @v_dSql += '            ,A.SPEC'+char(10)
  SET @v_dSql += '            ,A.DEMAND_LOT_SIZE'+char(10)
  SET @v_dSql += '            ,A.ITEM_ATTRIBUTE'+char(10)
  SET @v_dSql += '            ,A.SETUP_ATTRIBUTE'+char(10)
  SET @v_dSql += '            ,A.OUTSOURCING_FACTORY'+char(10)
  SET @v_dSql += '            ,A.FINITE_TERM'+char(10)
  SET @v_dSql += '            ,A.FINITE_TERM_UOM'+char(10)
  SET @v_dSql += '            ,A.DESCRIPTION'+char(10)
  SET @v_dSql += '            ,A.ACTIVE_FLAG'+char(10)
  --SET @v_dSql += '			      ,C.OPERATION_ID'+char(10)
  SET @v_dSql += '            ,SOF.OPERATION_ID'+char(10)
  SET @v_dSql += '			      ,A.BATCH_RATIO_ID'+char(10)
  SET @v_dSql += '			      ,A.MAKE_AND_BUY'+char(10)
  SET @v_dSql += '			      ,A.FORMATION_FLOW_ID'+char(10)
  SET @v_dSql += '			      ,A.FORM_ATTRIBUTE'+char(10)
  SET @v_dSql += '			      ,(CASE WHEN R.COMPANY_ID IS NULL THEN ''N'' ELSE ''Y'' END) AS EDIT_YN'+char(10)
  SET @v_dSql += '			      ,A.SCP_EXTRA_SPEC'+char(10) -- SCP_EXTRA_SPEC 컬럼추가... 20210618
  SET @v_dSql += '			      ,A.FP_EXTRA_SPEC'+char(10) -- FP Extra Spec 컬럼 추가... 20220801
  SET @v_dSql += '			      ,A.EVAL_CLASS, A.EVAL_CLASS_INFO'+char(10) -- 등외품 구분 코드 컬럼 추가... 20220801
  SET @v_dSql += '			      ,A.EVAL_CLASS + '' '' + A.EVAL_CLASS_INFO AS EVAL_CLASS_DETAIL'+char(10)
  SET @v_dSql += '      FROM  SCM_ITEM_M A WITH(NOLOCK)'+char(10)

    	IF (isnull(@p_item_class_level_1,'')<>'') OR (isnull(@p_item_class_level_2,'')<>'')
	BEGIN
		SET @v_dSql += 'INNER HASH JOIN SCM_ITEM_CLASS_M B(NOLOCK) '+char(10)
	END ELSE BEGIN
		SET @v_dSql+='INNER HASH JOIN SCM_ITEM_CLASS_M B(NOLOCK) '+char(10)
	END
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --              var sql="";
  --              var cls1=$data.ITEM_CLASS_LEVEL_1;
  --              var cls2=$data.ITEM_CLASS_LEVEL_2;
  --
  --              if((cls1!="" && cls1!=null) || (cls2!="" && cls2!=null)) {
  --                sql+="INNER HASH JOIN SCM_ITEM_CLASS_M B(NOLOCK)\r\n";
  --              } else {
  --                sql+="INNER HASH JOIN SCM_ITEM_CLASS_M B(NOLOCK)\r\n";
  --              }
  --              sql;
  --            }

  --'
  
  SET @v_dSql += '      ON    A.ITEM_CLASS = B.CLASS_ID'+char(10)
  /*
  SET @v_dSql += '      LEFT OUTER HASH JOIN ('+char(10)
  SET @v_dSql += '                SELECT * FROM ('+char(10)
  SET @v_dSql += '                  SELECT COMPANY_ID,DIVISION_ID,SITE_ID,ITEM_ID,OPERATION_ID,OPERATION_SEQ'+char(10)
  SET @v_dSql += '                        ,ROW_NUMBER() OVER(PARTITION BY COMPANY_ID,DIVISION_ID,SITE_ID,ITEM_ID'+char(10)
  SET @v_dSql += '                                           ORDER BY COMPANY_ID,DIVISION_ID,SITE_ID,ITEM_ID,OPERATION_SEQ DESC) RNUM'+char(10)
  SET @v_dSql += '                  FROM SCM_ITEM_FLOW_V A'+char(10)

  SET @v_dSql += '                  INNER JOIN ('+char(10)
  SET @v_dSql += '                      SELECT DISTINCT R.SEGMENT1, R.SEGMENT2, R.SEGMENT3'+char(10)
  SET @v_dSql += '                            FROM   SCM_SYS_LOOKUP_VALUE R WITH(NOLOCK)'+char(10)
  SET @v_dSql += '                      WHERE  R.LOOKUP_TYPE_CODE = ''SETUP_ATTRIBUTE'''+char(10)
  SET @v_dSql += '                      ) RV ON '+char(10)
  SET @v_dSql += '                      A.DIVISION_ID      = RV.SEGMENT1 '+char(10)
  SET @v_dSql += '                      AND    A.SITE_ID          = RV.SEGMENT2'+char(10)
  SET @v_dSql += '                      AND    A.OPERATION_ID     = RV.SEGMENT3'+char(10)

  --SET @v_dSql += '                  WHERE   EXISTS ('+char(10)
  --SET @v_dSql += '                      SELECT B.SEGMENT1 AS DIVISION_ID'+char(10)
  --SET @v_dSql += '                            ,B.SEGMENT2 AS SITE_ID'+char(10)
  --SET @v_dSql += '                            ,B.SEGMENT3 AS OPERATION_ID'+char(10)
  --SET @v_dSql += '                      FROM   SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK)'+char(10)
  --SET @v_dSql += '                      WHERE  B.LOOKUP_TYPE_CODE = ''SETUP_ATTRIBUTE'''+char(10)
  --SET @v_dSql += '                      AND    A.DIVISION_ID      = B.SEGMENT1'+char(10)
  --SET @v_dSql += '                      AND    A.SITE_ID          = B.SEGMENT2'+char(10)
  --SET @v_dSql += '                      AND    A.OPERATION_ID     = B.SEGMENT3'+char(10)
  --SET @v_dSql += '                  )'+char(10)


  SET @v_dSql += '                ) A'+char(10)
  SET @v_dSql += '							  WHERE RNUM=1'+char(10)
  SET @v_dSql += '			) C'+char(10)
  SET @v_dSql += '      ON    A.COMPANY_ID  = C.COMPANY_ID'+char(10)
  SET @v_dSql += '      AND   A.DIVISION_ID = C.DIVISION_ID'+char(10)
  SET @v_dSql += '      AND   A.SITE_ID     = C.SITE_ID'+char(10)
  SET @v_dSql += '      AND   A.ITEM_ID     = C.ITEM_ID'+char(10)
  */
  -- operation id 기준 테이블 변경.... 20240215
  SET @v_dSql += '      LEFT OUTER JOIN SCM_OPERATION_FLOW_M SOF WITH(NOLOCK) '+char(10)
  SET @v_dSql += '      ON  SOF.COMPANY_ID     = A.COMPANY_ID '+char(10)
  SET @v_dSql += '      AND SOF.DIVISION_ID    = A.DIVISION_ID '+char(10)
  SET @v_dSql += '      AND SOF.SITE_ID        = A.SITE_ID '+char(10)
  SET @v_dSql += '      AND SOF.FLOW_ID        = A.FLOW_ID '+char(10)
  SET @v_dSql += '      AND SOF.OPERATION_SEQ  = 1 '+char(10)
  SET @v_dSql += '      AND SOF.ACTIVE_FLAG    = ''Y'' '+char(10)
  SET @v_dSql += '      LEFT OUTER HASH JOIN ('+char(10)
  SET @v_dSql += '          SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID'+char(10)
  SET @v_dSql += '          FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)'+char(10)
  SET @v_dSql += '          WHERE  R.USER_ID   ='+char(10)
  SET @v_dSql += '' + @v_user_id+''+char(10)
  SET @v_dSql += '          AND    R.SAVE_FLAG = ''Y'''+char(10)
  SET @v_dSql += '      ) R'+char(10)
  SET @v_dSql += '      ON   A.COMPANY_ID   = R.COMPANY_ID'+char(10)
  SET @v_dSql += '      AND  A.DIVISION_ID  = R.DIVISION_ID'+char(10)
  SET @v_dSql += '      AND  A.SITE_ID      = R.SITE_ID'+char(10)

  SET @v_dSql += '     INNER JOIN ('+char(10)
  SET @v_dSql += '          SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID'+char(10)
  SET @v_dSql += '          FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)'+char(10)
  SET @v_dSql += '          WHERE  R.USER_ID   ='+char(10)
  SET @v_dSql += '' + @v_user_id+''+char(10)
  SET @v_dSql += '      )BV '+char(10)
  SET @v_dSql += '        	ON  A.COMPANY_ID  = BV.COMPANY_ID'+char(10)
  SET @v_dSql += '        	AND    A.DIVISION_ID = BV.DIVISION_ID'+char(10)
  SET @v_dSql += '        	AND    A.SITE_ID     = BV.SITE_ID'+char(10)


  SET @v_dSql += '      WHERE B.USE_FLAG = ''Y'''+char(10)


  --SET @v_dSql += '      AND   EXISTS ('+char(10)
  --SET @v_dSql += '        	SELECT 1'+char(10)
  --SET @v_dSql += '        	FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)'+char(10)
  --SET @v_dSql += '        	WHERE  A.COMPANY_ID  = B.COMPANY_ID'+char(10)
  --SET @v_dSql += '        	AND    A.DIVISION_ID = B.DIVISION_ID'+char(10)
  --SET @v_dSql += '        	AND    A.SITE_ID     = B.SITE_ID'+char(10)
  --SET @v_dSql += '        	AND    B.USER_ID     ='+char(10)
  --SET @v_dSql += '' + @v_user_id+''+char(10)
  --SET @v_dSql += '      )'+char(10)


  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10);
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10);
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.NICK_NAME' , 'EQ', @p_nick_name_lt)) + char(10);
  --SET @v_dSql += '
  --{
  --      	var sql = "";
  --      	if($data.DIVISION_LT != null && $data.DIVISION_LT != ""){
  --      		sql+= "AND    A.DIVISION_ID IN (" + $data.DIVISION_LT + ")\r\n";
  --      	}
  --      	sql;
  --      }

  --'
  --SET @v_dSql += ' ' +@opt_0site_id +' '+''+char(10)--AND   A.SITE_ID=#SITE_ID#
  SET @v_dSql += ' ' +@opt_1item_type +' '+''+char(10)--AND   A.ITEM_TYPE=#ITEM_TYPE#
  SET @v_dSql += ' ' +@opt_2item_id +' '+''+char(10)--AND   A.ITEM_ID LIKE '%' + RTRIM(LTRIM( #ITEM_ID# )) + '%'
  SET @v_dSql += ' ' +@opt_3item_class +' '+''+char(10)--AND   A.ITEM_CLASS LIKE '%' + RTRIM(LTRIM( #ITEM_CLASS# )) + '%'

  SET @v_dSql += ' ' +@opt_4nick_name +' '+''+char(10)--AND   A.NICK_NAME LIKE '%' + RTRIM(LTRIM( #NICK_NAME# )) + '%'
  SET @v_dSql += ' ' +@opt_5item_class_level_1 +' '+''+char(10)--AND   B.LEVEL_1_CODE=#ITEM_CLASS_LEVEL_1#
  SET @v_dSql += ' ' +@opt_6item_class_level_2 +' '+''+char(10)--AND   B.LEVEL_2_CODE=#ITEM_CLASS_LEVEL_2#
  SET @v_dSql += ' ' +@opt_7active_flag +' '+''+char(10)--AND   A.ACTIVE_FLAG=#ACTIVE_FLAG#
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
   IF isnull(@p_model_id,'') <> '' BEGIN
		SET @v_dSql += 'AND A.ITEM_ID IN (																		'+char(10)
      		SET @v_dSql += '		SELECT CT.CHILD_ITEM_ID															'+char(10)
			SET @v_dSql += '		FROM  (                                                                         '+char(10)
			SET @v_dSql += '				SELECT 	CT.COMPANY_ID, CT.DIVISION_ID, CT.SITE_ID, CT.PLANT_ID          '+char(10)
			SET @v_dSql += '						,CT.MODEL_ID                                                    '+char(10)
			SET @v_dSql += '						,CT.CHILD_ITEM_ID                                               '+char(10)
			SET @v_dSql += '						,SI.NICK_NAME                                                   '+char(10)
			SET @v_dSql += '						,SUBSTRING(SI.FLOW_ID,1,5) AS FLOW_ID                           '+char(10)
			SET @v_dSql += '						,SUBSTRING(SI.FORMATION_FLOW_ID,1,5) AS FORMATION_FLOW_ID       '+char(10)
			SET @v_dSql += '				FROM   	SCM_MODEL_COMP_TEMP CT WITH(NOLOCK)                             '+char(10)
			SET @v_dSql += '						,SCM_ITEM_M SI WITH(NOLOCK)                                     '+char(10)
			SET @v_dSql += '						,SCM_ITEM_CLASS_M IC WITH(NOLOCK)                               '+char(10)
			SET @v_dSql += '				WHERE  CT.CHILD_COMPANY_ID  = SI.COMPANY_ID                             '+char(10)
			SET @v_dSql += '				AND    CT.CHILD_DIVISION_ID = SI.DIVISION_ID                            '+char(10)
			SET @v_dSql += '				AND    CT.CHILD_SITE_ID     = SI.SITE_ID                                '+char(10)
			SET @v_dSql += '				AND    CT.CHILD_ITEM_ID     = SI.ITEM_ID                                '+char(10)
			SET @v_dSql += '				AND    SI.ITEM_CLASS        = IC.CLASS_ID                               '+char(10)
			SET @v_dSql += '				AND    IC.USE_FLAG          = ''Y''                                       '+char(10)
			SET @v_dSql += '				AND    SI.ACTIVE_FLAG       = ''Y''                                       '+char(10)
			SET @v_dSql += '				AND    ISNULL(SI.ITEM_TYPE,''H'') IN (''P'',''Q'',''H'')                        '+char(10)
			--SET @v_dSql += '				AND    (SI.FLOW_ID IS NOT NULL OR SI.FORMATION_FLOW_ID IS NOT NULL)     '+char(10)
			SET @v_dSql += '				AND    CT.ALT_PRIORITY = ''Y''                                            '+char(10)
			
			  	SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('CT.DIVISION_ID' , 'EQ', @p_division_id)) + char(10);
			--SET @v_dSql += '				AND    CT.DIVISION_ID IN ('+ @v_division_lt +')                    '+char(10)
			SET @v_dSql += '				AND    CT.MODEL_ID = RTRIM(LTRIM(' + @v_model_id + '))	            '+char(10)
			SET @v_dSql += '		) CT                                                                            '+char(10)
			SET @v_dSql += '	)	'+char(10)

	END
  --SET @v_dSql += '
  --{
  --      	var sql = "";
  --      	if($data.MODEL_ID != null && $data.MODEL_ID != ""){
  --      		sql += "AND A.ITEM_ID IN (																		\r\n";
  --      		sql += "		SELECT CT.CHILD_ITEM_ID															\r\n";
  --			sql += "		FROM  (                                                                         \r\n";
  --			sql += "				SELECT 	CT.COMPANY_ID, CT.DIVISION_ID, CT.SITE_ID, CT.PLANT_ID          \r\n";
  --			sql += "						,CT.MODEL_ID                                                    \r\n";
  --			sql += "						,CT.CHILD_ITEM_ID                                               \r\n";
  --			sql += "						,SI.NICK_NAME                                                   \r\n";
  --			sql += "						,SUBSTRING(SI.FLOW_ID,1,5) AS FLOW_ID                           \r\n";
  --			sql += "						,SUBSTRING(SI.FORMATION_FLOW_ID,1,5) AS FORMATION_FLOW_ID       \r\n";
  --			sql += "				FROM   	SCM_MODEL_COMP_TEMP CT WITH(NOLOCK)                             \r\n";
  --			sql += "						,SCM_ITEM_M SI WITH(NOLOCK)                                     \r\n";
  --			sql += "						,SCM_ITEM_CLASS_M IC WITH(NOLOCK)                               \r\n";
  --			sql += "				WHERE  CT.CHILD_COMPANY_ID  = SI.COMPANY_ID                             \r\n";
  --			sql += "				AND    CT.CHILD_DIVISION_ID = SI.DIVISION_ID                            \r\n";
  --			sql += "				AND    CT.CHILD_SITE_ID     = SI.SITE_ID                                \r\n";
  --			sql += "				AND    CT.CHILD_ITEM_ID     = SI.ITEM_ID                                \r\n";
  --			sql += "				AND    SI.ITEM_CLASS        = IC.CLASS_ID                               \r\n";
  --			sql += "				AND    IC.USE_FLAG          = ''''Y''''                                       \r\n";
  --			sql += "				AND    SI.ACTIVE_FLAG       = ''''Y''''                                       \r\n";
  --			sql += "				AND    ISNULL(SI.ITEM_TYPE,''''H'''') IN (''''P'''',''''Q'''',''''H'''')                        \r\n";
  --			//sql += "				AND    (SI.FLOW_ID IS NOT NULL OR SI.FORMATION_FLOW_ID IS NOT NULL)     \r\n";
  --			sql += "				AND    CT.ALT_PRIORITY = ''''Y''''                                            \r\n";
  --			sql += "				AND    CT.DIVISION_ID IN (" + $data.DIVISION_LT + ")                    \r\n";
  --			sql += "				AND    CT.MODEL_ID = RTRIM(LTRIM(''''" + $data.MODEL_ID + "''''))	            \r\n";
  --			sql += "		) CT                                                                            \r\n";
  --			sql += "	)																					\r\n";
  --      	}
  --      	sql;
  --      }

  --'
  SET @v_dSql += '      ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.ITEM_NAME, A.ITEM_TYPE, A.ITEM_CLASS'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("FP00180","find_FP00180",param);
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
	  PRINT 'prin sql11 ' +ISNULL( @v_dSql, '(null)');
        -- run dynamic sql
        exec sp_executesql @v_dSql
      COMMIT TRAN
    END TRY
    BEGIN CATCH
      ROLLBACK
      SET @runend = GetDate()
      --exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    --exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
