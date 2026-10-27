CREATE PROCEDURE [dbo].[PR2_UI_FP00130_FIND_FP00130]
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
/** 프로그램 ID   : PR_UI_FP00130_FIND_FP00130                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP00130_FIND_FP00130                                                                          **/
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
/** 2021-06-30     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00130_FIND_FP00130
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP00130_FIND_FP00130'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  --DECLARE @p_company_id nvarchar(max) = ''
  --DECLARE @p_division_id nvarchar(max) = ''
  --DECLARE @p_site_id nvarchar(max) = ''
  --DECLARE @p_plant_id nvarchar(max) = ''
  --DECLARE @p_factory_id nvarchar(max) = ''
  DECLARE @p_shop_group_id nvarchar(max) = ''
  DECLARE @p_line_id nvarchar(max) = ''
  DECLARE @p_operation_id nvarchar(max) = ''
  DECLARE @p_resource_id nvarchar(max) = ''
  DECLARE @p_equipment_type nvarchar(max) = ''
  DECLARE @p_management_type nvarchar(max) = ''
  DECLARE @p_active_flag nvarchar(max) = ''
  DECLARE @p_company_lt nvarchar(max) = ''
  DECLARE @p_division_lt nvarchar(max) = ''
  DECLARE @p_site_lt nvarchar(max) = ''
  DECLARE @p_plant_lt nvarchar(max) = ''
  DECLARE @p_loc_lt nvarchar(max) = ''
  DECLARE @p_factory_lt nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''


  DECLARE @v_user_id nvarchar(max)
  DECLARE @v_company_id nvarchar(max)
  DECLARE @v_division_id nvarchar(max)
  DECLARE @v_site_id nvarchar(max)
  DECLARE @v_plant_id nvarchar(max)
  DECLARE @v_factory_id nvarchar(max)
  DECLARE @v_shop_group_id nvarchar(max)
  DECLARE @v_line_id nvarchar(max)
  DECLARE @v_operation_id nvarchar(max)
  DECLARE @v_resource_id nvarchar(max)
  DECLARE @v_equipment_type nvarchar(max)
  DECLARE @v_management_type nvarchar(max)
  DECLARE @v_active_flag nvarchar(max)
  DECLARE @v_company_lt nvarchar(max)
  DECLARE @v_division_lt nvarchar(max)
  DECLARE @v_site_lt nvarchar(max)
  DECLARE @v_plant_lt nvarchar(max)
  DECLARE @v_loc_lt nvarchar(max)
  DECLARE @v_factory_lt nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  DECLARE @opt_0company_id nvarchar(max)
  DECLARE @opt_1division_id nvarchar(max)
  DECLARE @opt_2site_id nvarchar(max)
  DECLARE @opt_3plant_id nvarchar(max)
  DECLARE @opt_4factory_id nvarchar(max)
  DECLARE @opt_5shop_group_id nvarchar(max)
  --DECLARE @opt_6line_id nvarchar(max)
  --DECLARE @opt_7operation_id nvarchar(max)
  DECLARE @opt_8resource_id nvarchar(max)
  DECLARE @opt_9equipment_type nvarchar(max)
  DECLARE @opt_10management_type nvarchar(max)
  DECLARE @opt_11active_flag nvarchar(max)
  DECLARE @opt_12company_id nvarchar(max)
  DECLARE @opt_13division_id nvarchar(max)
  DECLARE @opt_14site_id nvarchar(max)
  DECLARE @opt_15plant_id nvarchar(max)
  DECLARE @opt_16factory_id nvarchar(max)
  DECLARE @opt_17shop_group_id nvarchar(max)
  --DECLARE @opt_18line_id nvarchar(max)
  --DECLARE @opt_19operation_id nvarchar(max)
  DECLARE @opt_20resource_id nvarchar(max)
  DECLARE @opt_21equipment_type nvarchar(max)
  DECLARE @opt_22management_type nvarchar(max)
  DECLARE @opt_23active_flag nvarchar(max)

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
    --END ELSE IF @tmp_column = 'COMPANY_ID' BEGIN
    --  SET @p_company_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    --END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
    --  SET @p_division_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    --END ELSE IF @tmp_column = 'SITE_ID' BEGIN
    --  SET @p_site_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    --END ELSE IF @tmp_column = 'PLANT_ID' BEGIN
      --SET @p_plant_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    --END ELSE IF @tmp_column = 'FACTORY_ID' BEGIN
      --SET @p_factory_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'SHOP_GROUP_ID' BEGIN
      SET @p_shop_group_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'LINE_ID' BEGIN
      SET @p_line_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'OPERATION_ID' BEGIN
      SET @p_operation_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'RESOURCE_ID' BEGIN
      SET @p_resource_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'EQUIPMENT_TYPE' BEGIN
      SET @p_equipment_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'MANAGEMENT_TYPE' BEGIN
      SET @p_management_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ACTIVE_FLAG' BEGIN
      SET @p_active_flag =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'COMPANY_ID' BEGIN
      SET @p_company_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
      SET @p_division_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'SITE_ID' BEGIN
      SET @p_site_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLANT_ID' BEGIN
      SET @p_plant_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'LOC_LT' BEGIN
      SET @p_loc_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'FACTORY_ID' BEGIN
      SET @p_factory_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
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
  --SET @v_company_id ='''' + @p_company_id + ''''
  --SET @v_division_id ='''' + @p_division_id + ''''
  --SET @v_site_id ='''' + @p_site_id + ''''
  --SET @v_plant_id ='''' + @p_plant_id + ''''
  --SET @v_factory_id ='''' + @p_factory_id + ''''
  SET @v_shop_group_id ='''' + @p_shop_group_id + ''''
  SET @v_line_id ='''' + @p_line_id + ''''
  SET @v_operation_id ='''' + @p_operation_id + ''''
  SET @v_resource_id ='''' + @p_resource_id + ''''
  SET @v_equipment_type ='''' + @p_equipment_type + ''''
  SET @v_management_type ='''' + @p_management_type + ''''
  SET @v_active_flag ='''' + @p_active_flag + ''''
  SET @v_company_lt ='''' + @p_company_lt + ''''
  SET @v_division_lt ='''' + @p_division_lt + ''''
  SET @v_site_lt ='''' + @p_site_lt + ''''
  SET @v_plant_lt ='''' + @p_plant_lt + ''''
  SET @v_loc_lt ='''' + @p_loc_lt + ''''
  SET @v_factory_lt ='''' + @p_factory_lt + ''''
  SET @v_param ='''' + @p_param + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''

  --SET @STRLEN = LEN(@p_company_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_0company_id = ''
  --END ELSE BEGIN
  --  SET @opt_0company_id = 'and    a.company_id=' + @v_company_id+''
  --END
  --SET @STRLEN = LEN(@p_division_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_1division_id = ''
  --END ELSE BEGIN
  --  SET @opt_1division_id = 'and    a.division_id=' + @v_division_id+''
  --END
  --SET @STRLEN = LEN(@p_site_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_2site_id = ''
  --END ELSE BEGIN
  --  SET @opt_2site_id = 'and    a.site_id=' + @v_site_id+''
  --END
  --SET @STRLEN = LEN(@p_plant_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_3plant_id = ''
  --END ELSE BEGIN
  --  SET @opt_3plant_id = 'and    a.plant_id=' + @v_plant_id+''
  --END
  --SET @STRLEN = LEN(@p_factory_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_4factory_id = ''
  --END ELSE BEGIN
  --  SET @opt_4factory_id = 'and    a.factory_id=' + @v_factory_id+''
  --END
  SET @STRLEN = LEN(@p_shop_group_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_5shop_group_id = ''
  END ELSE BEGIN
    SET @opt_5shop_group_id = 'and    d.shop_group_id=' + @v_shop_group_id+''
  END
  --SET @STRLEN = LEN(@p_line_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_6line_id = ''
  --END ELSE BEGIN
  --  SET @opt_6line_id = 'and    a.line_id=' + @v_line_id+''
  --END
  --SET @STRLEN = LEN(@p_operation_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_7operation_id = ''
  --END ELSE BEGIN
  --  SET @opt_7operation_id = 'and    a.operation_id=' + @v_operation_id+''
  --END
  SET @STRLEN = LEN(@p_resource_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_8resource_id = ''
  END ELSE BEGIN
	-- 초기 장문으로 들어올 경우 방어 코드
	if @STRLEN > 100 begin
		SET @opt_8resource_id = ''
	end else begin
		SET @opt_8resource_id = 'and    a.equipment_id = ' + @v_resource_id+''
	end
  END
  SET @STRLEN = LEN(@p_equipment_type)
  IF @STRLEN< 1  BEGIN
    SET @opt_9equipment_type = ''
  END ELSE BEGIN
    SET @opt_9equipment_type = 'and    a.equipment_type = ' + @v_equipment_type+''
  END
  SET @STRLEN = LEN(@p_management_type)
  IF @STRLEN< 1  BEGIN
    SET @opt_10management_type = ''
  END ELSE BEGIN
    SET @opt_10management_type = 'and    a.management_type = ' + @v_management_type+''
  END
  SET @STRLEN = LEN(@p_active_flag)
  IF @STRLEN< 1  BEGIN
    SET @opt_11active_flag = ''
  END ELSE BEGIN
    SET @opt_11active_flag = 'and    a.active_flag = ' + @v_active_flag+''
  END
  --SET @STRLEN = LEN(@p_company_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_12company_id = ''
  --END ELSE BEGIN
  --  SET @opt_12company_id = 'and    a.company_id=' + @v_company_id+''
  --END
  --SET @STRLEN = LEN(@p_division_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_13division_id = ''
  --END ELSE BEGIN
  --  SET @opt_13division_id = 'and    a.division_id=' + @v_division_id+''
  --END
  --SET @STRLEN = LEN(@p_site_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_14site_id = ''
  --END ELSE BEGIN
  --  SET @opt_14site_id = 'and    a.site_id=' + @v_site_id+''
  --END
  --SET @STRLEN = LEN(@p_plant_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_15plant_id = ''
  --END ELSE BEGIN
  --  SET @opt_15plant_id = 'and    a.plant_id=' + @v_plant_id+''
  --END
  --SET @STRLEN = LEN(@p_factory_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_16factory_id = ''
  --END ELSE BEGIN
  --  SET @opt_16factory_id = 'and    a.factory_id=' + @v_factory_id+''
  --END
  SET @STRLEN = LEN(@p_shop_group_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_17shop_group_id = ''
  END ELSE BEGIN
    SET @opt_17shop_group_id = 'and    d.shop_group_id=' + @v_shop_group_id+''
  END
  --SET @STRLEN = LEN(@p_line_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_18line_id = ''
  --END ELSE BEGIN
  --  SET @opt_18line_id = 'and    a.line_id=' + @v_line_id+''
  --END
  --SET @STRLEN = LEN(@p_operation_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_19operation_id = ''
  --END ELSE BEGIN
  --  SET @opt_19operation_id = 'and    a.operation_id=' + @v_operation_id+''
  --END
  SET @STRLEN = LEN(@p_resource_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_20resource_id = ''
  END ELSE BEGIN
    SET @opt_20resource_id = 'and    a.equipment_id = ' + @v_resource_id+''
  END
  SET @STRLEN = LEN(@p_equipment_type)
  IF @STRLEN< 1  BEGIN
    SET @opt_21equipment_type = ''
  END ELSE BEGIN
    SET @opt_21equipment_type = 'and    a.equipment_type = ' + @v_equipment_type+''
  END
  SET @STRLEN = LEN(@p_management_type)
  IF @STRLEN< 1  BEGIN
    SET @opt_22management_type = ''
  END ELSE BEGIN
    SET @opt_22management_type = 'and    a.management_type = ' + @v_management_type+''
  END
  SET @STRLEN = LEN(@p_active_flag)
  IF @STRLEN< 1  BEGIN
    SET @opt_23active_flag = ''
  END ELSE BEGIN
    SET @opt_23active_flag = 'and    a.active_flag = ' + @v_active_flag+''
  END


  -- FP00130 find_FP00130  
  SET @v_dSql = ''
  SET @v_dSql += '      select distinct'+char(10)
  SET @v_dSql += '             a.company_id'+char(10)
  SET @v_dSql += '            ,a.division_id'+char(10)
  SET @v_dSql += '            ,a.site_id'+char(10)
  SET @v_dSql += '            ,a.plant_id'+char(10)
  SET @v_dSql += '            ,a.factory_id'+char(10)
  SET @v_dSql += '            ,d.shop_group_id'+char(10)
  SET @v_dSql += '            ,a.line_id'+char(10)
  SET @v_dSql += '            ,(select max(b.line_name)'+char(10)
  SET @v_dSql += '              from   scm_line_m b WITH(NOLOCK)'+char(10)
  SET @v_dSql += '              where  a.company_id = b.company_id'+char(10)
  SET @v_dSql += '              and    a.division_id = b.division_id'+char(10)
  SET @v_dSql += '              and    a.site_id = b.site_id'+char(10)
  SET @v_dSql += '              and    a.plant_id = b.plant_id'+char(10)
  SET @v_dSql += '              and    a.factory_id = b.factory_id'+char(10)
  SET @v_dSql += '              and    a.line_id = b.line_id'+char(10)
  SET @v_dSql += '              and    a.operation_id = b.operation_id) as line_name'+char(10)
  SET @v_dSql += '            ,a.work_center_id'+char(10)
  SET @v_dSql += '            ,a.operation_id'+char(10)
  SET @v_dSql += '            ,c.operation_name'+char(10)
  SET @v_dSql += '            ,a.equipment_id'+char(10)
  SET @v_dSql += '            ,a.equipment_name'+char(10)
  SET @v_dSql += '            ,a.equipment_type'+char(10)
  SET @v_dSql += '            ,a.electrode_type'+char(10)
  SET @v_dSql += '            ,a.active_flag'+char(10)
  SET @v_dSql += '            ,a.line_type'+char(10)
  SET @v_dSql += '            ,a.MES_LINE_ID'+char(10)
  SET @v_dSql += '            , CASE WHEN R.FACTORY_ID IS NULL THEN ''N'' ELSE ''Y'' END EDIT_YN'+char(10)
  SET @v_dSql += '      FROM   SCM_EQUIPMENT_M A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '      INNER HASH JOIN ( '+char(10)
  SET @v_dSql += '      	SELECT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.FACTORY_ID '+char(10)
  SET @v_dSql += '      	FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK) '+char(10)
  SET @v_dSql += '      	WHERE  1=1 '+char(10)
  SET @v_dSql += '      	AND    B.USER_ID = ' + @v_user_id + ' '+char(10)
  SET @v_dSql += '      	GROUP BY B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.FACTORY_ID '+char(10)
  SET @v_dSql += '      ) B '+char(10)
  SET @v_dSql += '      on 1=1 '+char(10)
  SET @v_dSql += '      AND    A.COMPANY_ID   = B.COMPANY_ID '+char(10)
  SET @v_dSql += '      AND    A.DIVISION_ID  = B.DIVISION_ID '+char(10)
  SET @v_dSql += '      AND    A.SITE_ID      = B.SITE_ID '+char(10)
  SET @v_dSql += '      AND    A.PLANT_ID	  = B.PLANT_ID '+char(10)
  SET @v_dSql += '      AND    A.FACTORY_ID   = B.FACTORY_ID '+char(10)
  --SET @v_dSql += '      AND    A.OPERATION_ID = B.OPERATION_ID '+char(10)
  SET @v_dSql += '      		LEFT OUTER JOIN ('+char(10)
  SET @v_dSql += '					SELECT	DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID'+char(10)
  SET @v_dSql += '					FROM	FP_USER_ROLE_INFO_V R WITH(NOLOCK)'+char(10)
  SET @v_dSql += '					WHERE	1=1'+char(10)
  SET @v_dSql += '					AND		R.USER_ID	='+char(10)
  SET @v_dSql += '' + @v_user_id+''+char(10)
  SET @v_dSql += '					AND		R.SAVE_FLAG	= ''Y'''+char(10)
  SET @v_dSql += '			) R'+char(10)
  SET @v_dSql += '			ON		1=1'+char(10)
  SET @v_dSql += '			AND		A.COMPANY_ID    = R.COMPANY_ID'+char(10)
  SET @v_dSql += '			AND		A.DIVISION_ID   = R.DIVISION_ID'+char(10)
  SET @v_dSql += '			AND		A.SITE_ID       = R.SITE_ID'+char(10)
  SET @v_dSql += '			AND		A.PLANT_ID      = R.PLANT_ID'+char(10)
  SET @v_dSql += '			AND		A.FACTORY_ID    = R.FACTORY_ID'+char(10)
  SET @v_dSql += '      		, SCM_OPERATION_M C WITH(NOLOCK), SCM_FACTORY_M D WITH(NOLOCK)'+char(10)
  SET @v_dSql += '      WHERE  A.COMPANY_ID   = C.COMPANY_ID'+char(10)
  SET @v_dSql += '      AND    A.DIVISION_ID  = C.DIVISION_ID'+char(10)
  SET @v_dSql += '      AND    A.SITE_ID      = C.SITE_ID'+char(10)
  SET @v_dSql += '      AND    A.OPERATION_ID = C.OPERATION_ID'+char(10)
  SET @v_dSql += '      AND    A.COMPANY_ID   = D.COMPANY_ID'+char(10)
  SET @v_dSql += '      AND    A.FACTORY_ID   = D.FACTORY_ID'+char(10)
  SET @v_dSql += '      AND    C.ACTIVE_FLAG  = ''Y'''+char(10)
  SET @v_dSql += '      AND    D.ACTIVE_FLAG  = ''Y'''+char(10)
/*
  SET @v_dSql += '      AND    EXISTS ('+char(10)
  SET @v_dSql += '			        	SELECT 1'+char(10)
  SET @v_dSql += '			        	FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '			        	WHERE  A.COMPANY_ID  = B.COMPANY_ID'+char(10)
  SET @v_dSql += '			        	AND    A.DIVISION_ID = B.DIVISION_ID'+char(10)
  SET @v_dSql += '			        	AND    A.SITE_ID     = B.SITE_ID'+char(10)
  SET @v_dSql += '			        	AND    A.PLANT_ID	 = B.PLANT_ID'+char(10)
  SET @v_dSql += '			        	AND    A.FACTORY_ID  = B.FACTORY_ID'+char(10)
  SET @v_dSql += '			        	AND    A.OPERATION_ID = B.OPERATION_ID'+char(10)
  SET @v_dSql += '			        	AND    B.USER_ID     ='+char(10)
  SET @v_dSql += '' + @v_user_id+''+char(10)
  SET @v_dSql += '			      	)'+char(10)
*/
  --SET @v_dSql += ' ' +@opt_0company_id +' '+''+char(10)--and    a.company_id=#COMPANY_ID#
  --SET @v_dSql += ' ' +@opt_1division_id +' '+''+char(10)--and    a.division_id=#DIVISION_ID#
  --SET @v_dSql += ' ' +@opt_2site_id +' '+''+char(10)--and    a.site_id=#SITE_ID#
  --SET @v_dSql += ' ' +@opt_3plant_id +' '+''+char(10)--and    a.plant_id=#PLANT_ID#
  --SET @v_dSql += ' ' +@opt_4factory_id +' '+''+char(10)--and    a.factory_id=#FACTORY_ID#
  SET @v_dSql += ' ' +@opt_5shop_group_id +' '+''+char(10)--and    d.shop_group_id=#SHOP_GROUP_ID#
  --SET @v_dSql += ' ' +@opt_6line_id +' '+''+char(10)--and    a.line_id=#LINE_ID#
  --SET @v_dSql += ' ' +@opt_7operation_id +' '+''+char(10)--and    a.operation_id=#OPERATION_ID#
  SET @v_dSql += ' ' +@opt_8resource_id +' '+''+char(10)--and    a.equipment_id = #RESOURCE_ID#
  SET @v_dSql += ' ' +@opt_9equipment_type +' '+''+char(10)--and    a.equipment_type = #EQUIPMENT_TYPE#
  SET @v_dSql += ' ' +@opt_10management_type +' '+''+char(10)--and    a.management_type = #MANAGEMENT_TYPE#
  SET @v_dSql += ' ' +@opt_11active_flag +' '+''+char(10)--and    a.active_flag = #ACTIVE_FLAG#
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10); 
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10); 
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.COMPANY_ID' , 'EQ', @p_company_lt)) + char(10); 
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_lt)) + char(10); 
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_lt)) + char(10); 
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_lt)) + char(10); 
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_lt)) + char(10); 
  --SET @v_dSql += '
  --{
  --      	var sql = "";
  --      	if($data.PLANT_LT != null && $data.PLANT_LT != ""){
  --      		sql+= "AND    A.PLANT_ID IN (" + $data.PLANT_LT + ")\r\n";
  --      	}
  --      	sql;
  --      }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
    IF isnull(@p_loc_lt,'') <> ''
	BEGIN
      SET @v_dSql +=  'AND EXISTS (SELECT * FROM LG_MST_FACTORY WHERE COMPANY_id + ''^'' + DIVISION_id + ''^'' + F_SITE + ''^'' + BUILDING IN (' +@p_loc_lt+ ')' + char(10)
      SET @v_dSql +=  'AND COMPANY_id = A.COMPANY_id AND DIVISION_id = A.DIVISION_id AND SITE_id = A.SITE_id)' + char(10)
	END
  --SET @v_dSql += '
  --{
  --      	var sql = "";
  --      	if($data.LOC_LT != null && $data.LOC_LT != ""){
  --      		sql+= "AND EXISTS (SELECT * FROM LG_MST_FACTORY WHERE COMPANY_id + ''''^'''' + DIVISION_id + ''''^'''' + F_SITE + ''''^'''' + BUILDING IN (" + $data.LOC_LT + ")\r\n";
  --      		sql+= "AND COMPANY_id = A.COMPANY_id AND DIVISION_id = A.DIVISION_id AND SITE_id = A.SITE_id)\r\n";
  --      	}
  --      	sql;
  --      }

  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --      	var sql = "";
  --      	if($data.DIVISION_LT != null && $data.DIVISION_LT != ""){
  --      		sql+= "AND    A.DIVISION_ID IN (" + $data.DIVISION_LT + ")\r\n";
  --      	}
  --      	sql;
  --      }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --      	var sql = "";
  --      	if($data.SITE_LT != null && $data.SITE_LT != ""){
  --      		sql+= "AND    A.SITE_ID IN (" + $data.SITE_LT + ")\r\n";
  --      	}
  --      	sql;
  --      }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --      	var sql = "";
  --      	if($data.PLANT_LT != null && $data.PLANT_LT != ""){
  --      		sql+= "AND    A.PLANT_ID IN (" + $data.PLANT_LT + ")\r\n";
  --      	}
  --      	sql;
  --      }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --      	var sql = "";
  --      	if($data.LOC_LT != null && $data.LOC_LT != ""){
  --      		sql+= "AND EXISTS (SELECT * FROM LG_MST_FACTORY WHERE COMPANY_id + ''''^'''' + DIVISION_id + ''''^'''' + F_SITE + ''''^'''' + BUILDING IN (" + $data.LOC_LT + ")\r\n";
  --      		sql+= "AND COMPANY_id = A.COMPANY_id AND DIVISION_id = A.DIVISION_id AND SITE_id = A.SITE_id)\r\n";
  --      	}
  --      	sql;
  --      }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --      	var sql = "";
  --      	if($data.FACTORY_LT != null && $data.FACTORY_LT != ""){
  --      		sql+= "AND    A.FACTORY_ID IN (" + $data.FACTORY_LT + ")\r\n";
  --      	}
  --      	sql;
  --      }

  --'
  SET @v_dSql += '      order by a.division_id, a.site_id, a.plant_id, a.factory_id, a.operation_id, a.line_id, a.equipment_id'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("FP00130","find_FP00130",param);
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
      exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
