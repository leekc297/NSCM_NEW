CREATE PROCEDURE [dbo].[PR_UI_FP02510_FIND_FP02510_ALL]
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
/** 프로그램 ID   : PR_UI_FP02510_FIND_FP02510_ALL                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP02510_FIND_FP02510_ALL                                                                          **/
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
/** 2021-06-01     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP02510_FIND_FP02510_ALL
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP02510_FIND_FP02510_ALL'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_site_id nvarchar(max) = ''
  DECLARE @p_division_id nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''


  DECLARE @v_site_id nvarchar(max)
  DECLARE @v_division_lt nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  DECLARE @opt_0site_id nvarchar(max)
  DECLARE @opt_1site_id nvarchar(max)

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
    END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
      SET @p_division_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PARAM' BEGIN
      SET @p_param =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
      SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END
  
  SET @v_site_id ='''' + @p_site_id + ''''
  SET @v_division_lt ='''' + @p_division_id + ''''
  SET @v_param ='''' + @p_param + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''

  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_0site_id = ''
  END ELSE BEGIN
    SET @opt_0site_id = 'and    A.site_id=' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_1site_id = ''
  END ELSE BEGIN
    SET @opt_1site_id = 'and    A.site_id=' + @v_site_id+''
  END


  -- FP02510 find_FP02510_ALL  
  SET @v_dSql = ''
  SET @v_dSql += 'WITH ROOT AS ('+char(10)
  SET @v_dSql += '	SELECT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.PARENT_ITEM_ID,A.CHILD_ITEM_ID'+char(10)
  SET @v_dSql += '		,PD1.ITEM_TYPE AS CHILD_ITEM_TYPE'+char(10)
  SET @v_dSql += '		,PD1.ITEM_CLASS AS CHILD_ITEM_CLASS'+char(10)
  SET @v_dSql += '		,PDC1.LEVEL_2_CODE AS CHILD_LEVEL_2_CODE'+char(10)
  SET @v_dSql += '		,PDC1.LEVEL_2_CODE + PDC1.LEVEL_3_CODE AS CHILD_LEVEL_23_CODE'+char(10)
  SET @v_dSql += '		,PD.ITEM_TYPE AS PARENT_ITEM_TYPE'+char(10)
  SET @v_dSql += '		,PD.ITEM_CLASS AS PARENT_ITEM_CLASS'+char(10)
  SET @v_dSql += '		,PDC.LEVEL_2_CODE AS PARENT_LEVEL_2_CODE'+char(10)
  SET @v_dSql += '		,PDC.LEVEL_2_CODE + PDC.LEVEL_3_CODE AS PARENT_LEVEL_23_CODE'+char(10)
  SET @v_dSql += '		,A.PARENT_ITEM_ID AS ROOT_ITEM'+char(10)
  SET @v_dSql += '		,A.ALT_ID'+char(10)
  SET @v_dSql += '		,A.ALT_PRIORITY'+char(10)
  SET @v_dSql += '		,1 AS NLEVEL'+char(10)
  SET @v_dSql += '	FROM SCM_BOM_M A(NOLOCK)'+char(10)
  SET @v_dSql += '	INNER HASH JOIN SCM_ITEM_M PD(NOLOCK)'+char(10)
  SET @v_dSql += '	ON A.COMPANY_ID=PD.COMPANY_ID'+char(10)
  SET @v_dSql += '	AND A.DIVISION_ID=PD.DIVISION_ID'+char(10)
  SET @v_dSql += '	AND A.SITE_ID=PD.SITE_ID'+char(10)
  SET @v_dSql += '	AND A.PARENT_ITEM_ID=PD.ITEM_ID'+char(10)
  SET @v_dSql += '	AND PD.ACTIVE_FLAG=''Y'''+char(10)
  SET @v_dSql += '	AND PD.ITEM_TYPE=''P'''+char(10)
  SET @v_dSql += '	INNER HASH JOIN SCM_ITEM_CLASS_M PDC(NOLOCK)'+char(10)
  SET @v_dSql += '	ON PD.ITEM_CLASS=PDC.CLASS_ID'+char(10)
  SET @v_dSql += '	AND PDC.USE_FLAG=''Y'''+char(10)
  SET @v_dSql += '	INNER HASH JOIN SCM_ITEM_M PD1(NOLOCK)'+char(10)
  SET @v_dSql += '	ON A.COMPANY_ID=PD1.COMPANY_ID'+char(10)
  SET @v_dSql += '	AND A.DIVISION_ID=PD1.DIVISION_ID'+char(10)
  SET @v_dSql += '	AND A.SITE_ID=PD1.SITE_ID'+char(10)
  SET @v_dSql += '	AND A.CHILD_ITEM_ID=PD1.ITEM_ID'+char(10)
  SET @v_dSql += '	AND PD1.ACTIVE_FLAG=''Y'''+char(10)
  SET @v_dSql += '	AND PD1.ITEM_TYPE <> ''R'''+char(10)
  SET @v_dSql += '	INNER HASH JOIN SCM_ITEM_CLASS_M PDC1(NOLOCK)'+char(10)
  SET @v_dSql += '	ON PD1.ITEM_CLASS=PDC1.CLASS_ID'+char(10)
  SET @v_dSql += '	AND PDC1.USE_FLAG=''Y'''+char(10)
  SET @v_dSql += '	--WHERE A.PARENT_ITEM_ID IN (''ACEN1021U-A1'')'+char(10)
  SET @v_dSql += ')'+char(10)
  SET @v_dSql += ',LVL1 AS ('+char(10)
  SET @v_dSql += '	SELECT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.PARENT_ITEM_ID,A.CHILD_ITEM_ID'+char(10)
  SET @v_dSql += '		,PD1.ITEM_TYPE AS CHILD_ITEM_TYPE'+char(10)
  SET @v_dSql += '		,PD1.ITEM_CLASS AS CHILD_ITEM_CLASS'+char(10)
  SET @v_dSql += '		,PDC1.LEVEL_2_CODE AS CHILD_LEVEL_2_CODE'+char(10)
  SET @v_dSql += '		,PDC1.LEVEL_2_CODE + PDC1.LEVEL_3_CODE AS CHILD_LEVEL_23_CODE'+char(10)
  SET @v_dSql += '		,ROOT_ITEM'+char(10)
  SET @v_dSql += '		,A.ALT_ID'+char(10)
  SET @v_dSql += '		,A.ALT_PRIORITY'+char(10)
  SET @v_dSql += '		,2 AS NLEVEL'+char(10)
  SET @v_dSql += '	FROM SCM_BOM_M A(NOLOCK)'+char(10)
  SET @v_dSql += '	INNER HASH JOIN ROOT B'+char(10)
  SET @v_dSql += '	ON A.PARENT_ITEM_ID=B.CHILD_ITEM_ID'+char(10)
  SET @v_dSql += '	INNER HASH JOIN SCM_ITEM_M PD1(NOLOCK)'+char(10)
  SET @v_dSql += '	ON A.COMPANY_ID=PD1.COMPANY_ID'+char(10)
  SET @v_dSql += '	AND A.DIVISION_ID=PD1.DIVISION_ID'+char(10)
  SET @v_dSql += '	AND A.SITE_ID=PD1.SITE_ID'+char(10)
  SET @v_dSql += '	AND A.CHILD_ITEM_ID=PD1.ITEM_ID'+char(10)
  SET @v_dSql += '	AND PD1.ACTIVE_FLAG=''Y'''+char(10)
  SET @v_dSql += '	--AND PD1.ITEM_TYPE <> ''R'''+char(10)
  SET @v_dSql += '	INNER HASH JOIN SCM_ITEM_CLASS_M PDC1(NOLOCK)'+char(10)
  SET @v_dSql += '	ON PD1.ITEM_CLASS=PDC1.CLASS_ID'+char(10)
  SET @v_dSql += '	AND PDC1.USE_FLAG=''Y'''+char(10)
  SET @v_dSql += '	WHERE A.EFF_START_DATE <= DBO.SYSDATE1()'+char(10)
  SET @v_dSql += '	AND A.EFF_END_DATE >= DBO.SYSDATE1()'+char(10)
  SET @v_dSql += '	AND (PD1.ITEM_TYPE <> ''R'' OR (PD1.ITEM_TYPE = ''R'' AND PDC1.LEVEL_2_CODE=''APC''))'+char(10)
  SET @v_dSql += ')'+char(10)
  SET @v_dSql += ',LVL2 AS ('+char(10)
  SET @v_dSql += '	SELECT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.PARENT_ITEM_ID,A.CHILD_ITEM_ID'+char(10)
  SET @v_dSql += '		,PD1.ITEM_TYPE AS CHILD_ITEM_TYPE'+char(10)
  SET @v_dSql += '		,PD1.ITEM_CLASS AS CHILD_ITEM_CLASS'+char(10)
  SET @v_dSql += '		,PDC1.LEVEL_2_CODE AS CHILD_LEVEL_2_CODE'+char(10)
  SET @v_dSql += '		,PDC1.LEVEL_2_CODE + PDC1.LEVEL_3_CODE AS CHILD_LEVEL_23_CODE'+char(10)
  SET @v_dSql += '		,ROOT_ITEM'+char(10)
  SET @v_dSql += '		,A.ALT_ID'+char(10)
  SET @v_dSql += '		,A.ALT_PRIORITY'+char(10)
  SET @v_dSql += '		,3 AS NLEVEL'+char(10)
  SET @v_dSql += '	FROM SCM_BOM_M A(NOLOCK)'+char(10)
  SET @v_dSql += '	INNER HASH JOIN LVL1 B'+char(10)
  SET @v_dSql += '	ON A.PARENT_ITEM_ID=B.CHILD_ITEM_ID'+char(10)
  SET @v_dSql += '	INNER HASH JOIN SCM_ITEM_M PD1(NOLOCK)'+char(10)
  SET @v_dSql += '	ON A.COMPANY_ID=PD1.COMPANY_ID'+char(10)
  SET @v_dSql += '	AND A.DIVISION_ID=PD1.DIVISION_ID'+char(10)
  SET @v_dSql += '	AND A.SITE_ID=PD1.SITE_ID'+char(10)
  SET @v_dSql += '	AND A.CHILD_ITEM_ID=PD1.ITEM_ID'+char(10)
  SET @v_dSql += '	AND PD1.ACTIVE_FLAG=''Y'''+char(10)
  SET @v_dSql += '	--AND PD1.ITEM_TYPE <> ''R'''+char(10)
  SET @v_dSql += '	INNER HASH JOIN SCM_ITEM_CLASS_M PDC1(NOLOCK)'+char(10)
  SET @v_dSql += '	ON PD1.ITEM_CLASS=PDC1.CLASS_ID'+char(10)
  SET @v_dSql += '	AND PDC1.USE_FLAG=''Y'''+char(10)
  SET @v_dSql += '	WHERE A.EFF_START_DATE <= DBO.SYSDATE1()'+char(10)
  SET @v_dSql += '	AND A.EFF_END_DATE >= DBO.SYSDATE1()'+char(10)
  SET @v_dSql += '	AND (PD1.ITEM_TYPE <> ''R'' OR (PD1.ITEM_TYPE = ''R'' AND PDC1.LEVEL_2_CODE=''APC''))'+char(10)
  SET @v_dSql += ')'+char(10)
  SET @v_dSql += ',LVL3 AS ('+char(10)
  SET @v_dSql += '	SELECT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.PARENT_ITEM_ID,A.CHILD_ITEM_ID'+char(10)
  SET @v_dSql += '		,PD1.ITEM_TYPE AS CHILD_ITEM_TYPE'+char(10)
  SET @v_dSql += '		,PD1.ITEM_CLASS AS CHILD_ITEM_CLASS'+char(10)
  SET @v_dSql += '		,PDC1.LEVEL_2_CODE AS CHILD_LEVEL_2_CODE'+char(10)
  SET @v_dSql += '		,PDC1.LEVEL_2_CODE + PDC1.LEVEL_3_CODE AS CHILD_LEVEL_23_CODE'+char(10)
  SET @v_dSql += '		,ROOT_ITEM'+char(10)
  SET @v_dSql += '		,A.ALT_ID'+char(10)
  SET @v_dSql += '		,A.ALT_PRIORITY'+char(10)
  SET @v_dSql += '		,4 AS NLEVEL'+char(10)
  SET @v_dSql += '	FROM SCM_BOM_M A(NOLOCK)'+char(10)
  SET @v_dSql += '	INNER HASH JOIN LVL2 B'+char(10)
  SET @v_dSql += '	ON A.PARENT_ITEM_ID=B.CHILD_ITEM_ID'+char(10)
  SET @v_dSql += '	INNER HASH JOIN SCM_ITEM_M PD1(NOLOCK)'+char(10)
  SET @v_dSql += '	ON A.COMPANY_ID=PD1.COMPANY_ID'+char(10)
  SET @v_dSql += '	AND A.DIVISION_ID=PD1.DIVISION_ID'+char(10)
  SET @v_dSql += '	AND A.SITE_ID=PD1.SITE_ID'+char(10)
  SET @v_dSql += '	AND A.CHILD_ITEM_ID=PD1.ITEM_ID'+char(10)
  SET @v_dSql += '	AND PD1.ACTIVE_FLAG=''Y'''+char(10)
  SET @v_dSql += '	--AND PD1.ITEM_TYPE <> ''R'''+char(10)
  SET @v_dSql += '	INNER HASH JOIN SCM_ITEM_CLASS_M PDC1(NOLOCK)'+char(10)
  SET @v_dSql += '	ON PD1.ITEM_CLASS=PDC1.CLASS_ID'+char(10)
  SET @v_dSql += '	AND PDC1.USE_FLAG=''Y'''+char(10)
  SET @v_dSql += '	WHERE A.EFF_START_DATE <= DBO.SYSDATE1()'+char(10)
  SET @v_dSql += '	AND A.EFF_END_DATE >= DBO.SYSDATE1()'+char(10)
  SET @v_dSql += '	AND (PD1.ITEM_TYPE <> ''R'' OR (PD1.ITEM_TYPE = ''R'' AND PDC1.LEVEL_2_CODE=''APC''))'+char(10)
  SET @v_dSql += ')'+char(10)
  SET @v_dSql += ',LVL4 AS ('+char(10)
  SET @v_dSql += '	SELECT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.PARENT_ITEM_ID,A.CHILD_ITEM_ID'+char(10)
  SET @v_dSql += '		,PD1.ITEM_TYPE AS CHILD_ITEM_TYPE'+char(10)
  SET @v_dSql += '		,PD1.ITEM_CLASS AS CHILD_ITEM_CLASS'+char(10)
  SET @v_dSql += '		,PDC1.LEVEL_2_CODE AS CHILD_LEVEL_2_CODE'+char(10)
  SET @v_dSql += '		,PDC1.LEVEL_2_CODE + PDC1.LEVEL_3_CODE AS CHILD_LEVEL_23_CODE'+char(10)
  SET @v_dSql += '		,ROOT_ITEM'+char(10)
  SET @v_dSql += '		,A.ALT_ID'+char(10)
  SET @v_dSql += '		,A.ALT_PRIORITY'+char(10)
  SET @v_dSql += '		,5 AS NLEVEL'+char(10)
  SET @v_dSql += '	FROM SCM_BOM_M A(NOLOCK)'+char(10)
  SET @v_dSql += '	INNER HASH JOIN LVL3 B'+char(10)
  SET @v_dSql += '	ON A.PARENT_ITEM_ID=B.CHILD_ITEM_ID'+char(10)
  SET @v_dSql += '	INNER HASH JOIN SCM_ITEM_M PD1(NOLOCK)'+char(10)
  SET @v_dSql += '	ON A.COMPANY_ID=PD1.COMPANY_ID'+char(10)
  SET @v_dSql += '	AND A.DIVISION_ID=PD1.DIVISION_ID'+char(10)
  SET @v_dSql += '	AND A.SITE_ID=PD1.SITE_ID'+char(10)
  SET @v_dSql += '	AND A.CHILD_ITEM_ID=PD1.ITEM_ID'+char(10)
  SET @v_dSql += '	AND PD1.ACTIVE_FLAG=''Y'''+char(10)
  SET @v_dSql += '	--AND PD1.ITEM_TYPE <> ''R'''+char(10)
  SET @v_dSql += '	INNER HASH JOIN SCM_ITEM_CLASS_M PDC1(NOLOCK)'+char(10)
  SET @v_dSql += '	ON PD1.ITEM_CLASS=PDC1.CLASS_ID'+char(10)
  SET @v_dSql += '	AND PDC1.USE_FLAG=''Y'''+char(10)
  SET @v_dSql += '	WHERE A.EFF_START_DATE <= DBO.SYSDATE1()'+char(10)
  SET @v_dSql += '	AND A.EFF_END_DATE >= DBO.SYSDATE1()'+char(10)
  SET @v_dSql += '	AND (PD1.ITEM_TYPE <> ''R'' OR (PD1.ITEM_TYPE = ''R'' AND PDC1.LEVEL_2_CODE=''APC''))'+char(10)
  SET @v_dSql += ')'+char(10)
  SET @v_dSql += ',LVL5 AS ('+char(10)
  SET @v_dSql += '	SELECT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.PARENT_ITEM_ID,A.CHILD_ITEM_ID'+char(10)
  SET @v_dSql += '		,PD1.ITEM_TYPE AS CHILD_ITEM_TYPE'+char(10)
  SET @v_dSql += '		,PD1.ITEM_CLASS AS CHILD_ITEM_CLASS'+char(10)
  SET @v_dSql += '		,PDC1.LEVEL_2_CODE AS CHILD_LEVEL_2_CODE'+char(10)
  SET @v_dSql += '		,PDC1.LEVEL_2_CODE + PDC1.LEVEL_3_CODE AS CHILD_LEVEL_23_CODE'+char(10)
  SET @v_dSql += '		,ROOT_ITEM'+char(10)
  SET @v_dSql += '		,A.ALT_ID'+char(10)
  SET @v_dSql += '		,A.ALT_PRIORITY'+char(10)
  SET @v_dSql += '		,6 AS NLEVEL'+char(10)
  SET @v_dSql += '	FROM SCM_BOM_M A(NOLOCK)'+char(10)
  SET @v_dSql += '	INNER HASH JOIN LVL4 B'+char(10)
  SET @v_dSql += '	ON A.PARENT_ITEM_ID=B.CHILD_ITEM_ID'+char(10)
  SET @v_dSql += '	INNER HASH JOIN SCM_ITEM_M PD1(NOLOCK)'+char(10)
  SET @v_dSql += '	ON A.COMPANY_ID=PD1.COMPANY_ID'+char(10)
  SET @v_dSql += '	AND A.DIVISION_ID=PD1.DIVISION_ID'+char(10)
  SET @v_dSql += '	AND A.SITE_ID=PD1.SITE_ID'+char(10)
  SET @v_dSql += '	AND A.CHILD_ITEM_ID=PD1.ITEM_ID'+char(10)
  SET @v_dSql += '	AND PD1.ACTIVE_FLAG=''Y'''+char(10)
  SET @v_dSql += '	--AND PD1.ITEM_TYPE <> ''R'''+char(10)
  SET @v_dSql += '	INNER HASH JOIN SCM_ITEM_CLASS_M PDC1(NOLOCK)'+char(10)
  SET @v_dSql += '	ON PD1.ITEM_CLASS=PDC1.CLASS_ID'+char(10)
  SET @v_dSql += '	AND PDC1.USE_FLAG=''Y'''+char(10)
  SET @v_dSql += '	WHERE A.EFF_START_DATE <= DBO.SYSDATE1()'+char(10)
  SET @v_dSql += '	AND A.EFF_END_DATE >= DBO.SYSDATE1()'+char(10)
  SET @v_dSql += '	AND (PD1.ITEM_TYPE <> ''R'' OR (PD1.ITEM_TYPE = ''R'' AND PDC1.LEVEL_2_CODE=''APC''))'+char(10)
  SET @v_dSql += ')'+char(10)
  SET @v_dSql += ',LVL6 AS ('+char(10)
  SET @v_dSql += '	SELECT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.PARENT_ITEM_ID,A.CHILD_ITEM_ID'+char(10)
  SET @v_dSql += '		,PD1.ITEM_TYPE AS CHILD_ITEM_TYPE'+char(10)
  SET @v_dSql += '		,PD1.ITEM_CLASS AS CHILD_ITEM_CLASS'+char(10)
  SET @v_dSql += '		,PDC1.LEVEL_2_CODE AS CHILD_LEVEL_2_CODE'+char(10)
  SET @v_dSql += '		,PDC1.LEVEL_2_CODE + PDC1.LEVEL_3_CODE AS CHILD_LEVEL_23_CODE'+char(10)
  SET @v_dSql += '		,ROOT_ITEM'+char(10)
  SET @v_dSql += '		,A.ALT_ID'+char(10)
  SET @v_dSql += '		,A.ALT_PRIORITY'+char(10)
  SET @v_dSql += '		,7 AS NLEVEL'+char(10)
  SET @v_dSql += '	FROM SCM_BOM_M A(NOLOCK)'+char(10)
  SET @v_dSql += '	INNER HASH JOIN LVL5 B'+char(10)
  SET @v_dSql += '	ON A.PARENT_ITEM_ID=B.CHILD_ITEM_ID'+char(10)
  SET @v_dSql += '	INNER HASH JOIN SCM_ITEM_M PD1(NOLOCK)'+char(10)
  SET @v_dSql += '	ON A.COMPANY_ID=PD1.COMPANY_ID'+char(10)
  SET @v_dSql += '	AND A.DIVISION_ID=PD1.DIVISION_ID'+char(10)
  SET @v_dSql += '	AND A.SITE_ID=PD1.SITE_ID'+char(10)
  SET @v_dSql += '	AND A.CHILD_ITEM_ID=PD1.ITEM_ID'+char(10)
  SET @v_dSql += '	AND PD1.ACTIVE_FLAG=''Y'''+char(10)
  SET @v_dSql += '	--AND PD1.ITEM_TYPE <> ''R'''+char(10)
  SET @v_dSql += '	INNER HASH JOIN SCM_ITEM_CLASS_M PDC1(NOLOCK)'+char(10)
  SET @v_dSql += '	ON PD1.ITEM_CLASS=PDC1.CLASS_ID'+char(10)
  SET @v_dSql += '	AND PDC1.USE_FLAG=''Y'''+char(10)
  SET @v_dSql += '	WHERE A.EFF_START_DATE <= DBO.SYSDATE1()'+char(10)
  SET @v_dSql += '	AND A.EFF_END_DATE >= DBO.SYSDATE1()'+char(10)
  SET @v_dSql += '	AND (PD1.ITEM_TYPE <> ''R'' OR (PD1.ITEM_TYPE = ''R'' AND PDC1.LEVEL_2_CODE=''APC''))'+char(10)
  SET @v_dSql += ')'+char(10)
  SET @v_dSql += ',LVL7 AS ('+char(10)
  SET @v_dSql += '	SELECT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.PARENT_ITEM_ID,A.CHILD_ITEM_ID'+char(10)
  SET @v_dSql += '		,PD1.ITEM_TYPE AS CHILD_ITEM_TYPE'+char(10)
  SET @v_dSql += '		,PD1.ITEM_CLASS AS CHILD_ITEM_CLASS'+char(10)
  SET @v_dSql += '		,PDC1.LEVEL_2_CODE AS CHILD_LEVEL_2_CODE'+char(10)
  SET @v_dSql += '		,PDC1.LEVEL_2_CODE + PDC1.LEVEL_3_CODE AS CHILD_LEVEL_23_CODE'+char(10)
  SET @v_dSql += '		,ROOT_ITEM'+char(10)
  SET @v_dSql += '		,A.ALT_ID'+char(10)
  SET @v_dSql += '		,A.ALT_PRIORITY'+char(10)
  SET @v_dSql += '		,8 AS NLEVEL'+char(10)
  SET @v_dSql += '	FROM SCM_BOM_M A(NOLOCK)'+char(10)
  SET @v_dSql += '	INNER HASH JOIN LVL6 B'+char(10)
  SET @v_dSql += '	ON A.PARENT_ITEM_ID=B.CHILD_ITEM_ID'+char(10)
  SET @v_dSql += '	INNER HASH JOIN SCM_ITEM_M PD1(NOLOCK)'+char(10)
  SET @v_dSql += '	ON A.COMPANY_ID=PD1.COMPANY_ID'+char(10)
  SET @v_dSql += '	AND A.DIVISION_ID=PD1.DIVISION_ID'+char(10)
  SET @v_dSql += '	AND A.SITE_ID=PD1.SITE_ID'+char(10)
  SET @v_dSql += '	AND A.CHILD_ITEM_ID=PD1.ITEM_ID'+char(10)
  SET @v_dSql += '	AND PD1.ACTIVE_FLAG=''Y'''+char(10)
  SET @v_dSql += '	--AND PD1.ITEM_TYPE <> ''R'''+char(10)
  SET @v_dSql += '	INNER HASH JOIN SCM_ITEM_CLASS_M PDC1(NOLOCK)'+char(10)
  SET @v_dSql += '	ON PD1.ITEM_CLASS=PDC1.CLASS_ID'+char(10)
  SET @v_dSql += '	AND PDC1.USE_FLAG=''Y'''+char(10)
  SET @v_dSql += '	WHERE A.EFF_START_DATE <= DBO.SYSDATE1()'+char(10)
  SET @v_dSql += '	AND A.EFF_END_DATE >= DBO.SYSDATE1()'+char(10)
  SET @v_dSql += '	AND (PD1.ITEM_TYPE <> ''R'' OR (PD1.ITEM_TYPE = ''R'' AND PDC1.LEVEL_2_CODE=''APC''))'+char(10)
  SET @v_dSql += ')'+char(10)
  SET @v_dSql += ',LVL8 AS ('+char(10)
  SET @v_dSql += '	SELECT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.PARENT_ITEM_ID,A.CHILD_ITEM_ID'+char(10)
  SET @v_dSql += '		,PD1.ITEM_TYPE AS CHILD_ITEM_TYPE'+char(10)
  SET @v_dSql += '		,PD1.ITEM_CLASS AS CHILD_ITEM_CLASS'+char(10)
  SET @v_dSql += '		,PDC1.LEVEL_2_CODE AS CHILD_LEVEL_2_CODE'+char(10)
  SET @v_dSql += '		,PDC1.LEVEL_2_CODE + PDC1.LEVEL_3_CODE AS CHILD_LEVEL_23_CODE'+char(10)
  SET @v_dSql += '		,ROOT_ITEM'+char(10)
  SET @v_dSql += '		,A.ALT_ID'+char(10)
  SET @v_dSql += '		,A.ALT_PRIORITY'+char(10)
  SET @v_dSql += '		,9 AS NLEVEL'+char(10)
  SET @v_dSql += '	FROM SCM_BOM_M A(NOLOCK)'+char(10)
  SET @v_dSql += '	INNER HASH JOIN LVL7 B'+char(10)
  SET @v_dSql += '	ON A.PARENT_ITEM_ID=B.CHILD_ITEM_ID'+char(10)
  SET @v_dSql += '	INNER HASH JOIN SCM_ITEM_M PD1(NOLOCK)'+char(10)
  SET @v_dSql += '	ON A.COMPANY_ID=PD1.COMPANY_ID'+char(10)
  SET @v_dSql += '	AND A.DIVISION_ID=PD1.DIVISION_ID'+char(10)
  SET @v_dSql += '	AND A.SITE_ID=PD1.SITE_ID'+char(10)
  SET @v_dSql += '	AND A.CHILD_ITEM_ID=PD1.ITEM_ID'+char(10)
  SET @v_dSql += '	AND PD1.ACTIVE_FLAG=''Y'''+char(10)
  SET @v_dSql += '	--AND PD1.ITEM_TYPE <> ''R'''+char(10)
  SET @v_dSql += '	INNER HASH JOIN SCM_ITEM_CLASS_M PDC1(NOLOCK)'+char(10)
  SET @v_dSql += '	ON PD1.ITEM_CLASS=PDC1.CLASS_ID'+char(10)
  SET @v_dSql += '	AND PDC1.USE_FLAG=''Y'''+char(10)
  SET @v_dSql += '	WHERE A.EFF_START_DATE <= DBO.SYSDATE1()'+char(10)
  SET @v_dSql += '	AND A.EFF_END_DATE >= DBO.SYSDATE1()'+char(10)
  SET @v_dSql += '	AND (PD1.ITEM_TYPE <> ''R'' OR (PD1.ITEM_TYPE = ''R'' AND PDC1.LEVEL_2_CODE=''APC''))'+char(10)
  SET @v_dSql += ')'+char(10)
  SET @v_dSql += ',CTE_NODE AS ('+char(10)
  SET @v_dSql += 'SELECT COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,'+char(10)
  SET @v_dSql += 'PARENT_ITEM_ID,CHILD_ITEM_ID,CHILD_ITEM_TYPE,CHILD_ITEM_CLASS,CHILD_LEVEL_2_CODE,CHILD_LEVEL_23_CODE,ROOT_ITEM,ALT_ID,ALT_PRIORITY,NLEVEL'+char(10)
  SET @v_dSql += 'FROM ROOT'+char(10)
  SET @v_dSql += 'UNION ALL'+char(10)
  SET @v_dSql += 'SELECT * FROM LVL1'+char(10)
  SET @v_dSql += 'UNION ALL'+char(10)
  SET @v_dSql += 'SELECT * FROM LVL2'+char(10)
  SET @v_dSql += 'UNION ALL'+char(10)
  SET @v_dSql += 'SELECT * FROM LVL3'+char(10)
  SET @v_dSql += 'UNION ALL'+char(10)
  SET @v_dSql += 'SELECT * FROM LVL4'+char(10)
  SET @v_dSql += 'UNION ALL'+char(10)
  SET @v_dSql += 'SELECT * FROM LVL5'+char(10)
  SET @v_dSql += 'UNION ALL'+char(10)
  SET @v_dSql += 'SELECT * FROM LVL6'+char(10)
  SET @v_dSql += 'UNION ALL'+char(10)
  SET @v_dSql += 'SELECT * FROM LVL7'+char(10)
  SET @v_dSql += 'UNION ALL'+char(10)
  SET @v_dSql += 'SELECT * FROM LVL8'+char(10)
  SET @v_dSql += ')'+char(10)
  SET @v_dSql += '      select COMPANY_ID,DIVISION_ID,SITE_ID,MODEL_ID,RNUM'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''E0500'' THEN ITEM_ID END) AS E0500'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''E1000'' THEN ITEM_ID END) AS E1000'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''E2000'' THEN ITEM_ID END) AS E2000'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''E2500'' THEN ITEM_ID END) AS E2500'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''E3000'' THEN ITEM_ID END) AS E3000'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''E3500'' THEN ITEM_ID END) AS E3500'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''E4000'' THEN ITEM_ID END) AS E4000'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''E8000'' THEN ITEM_ID END) AS E8000'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''S1000'' THEN ITEM_ID END) AS S1000'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''S2000'' THEN ITEM_ID END) AS S2000'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''S4000'' THEN ITEM_ID END) AS S4000'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''A1000'' THEN ITEM_ID END) AS A1000'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''A2000'' THEN ITEM_ID END) AS A2000'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''A3000'' THEN ITEM_ID END) AS A3000'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''A5000'' THEN ITEM_ID END) AS A5000'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''A6000'' THEN ITEM_ID END) AS A6000'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''A7000'' THEN ITEM_ID END) AS A7000'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''A7100'' THEN ITEM_ID END) AS A7100'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''A7200'' THEN ITEM_ID END) AS A7200'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''A8000'' THEN ITEM_ID END) AS A8000'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''A9000'' THEN ITEM_ID END) AS A9000'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''P5000'' THEN ITEM_ID END) AS P5000'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID=''P5500'' THEN ITEM_ID END) AS P5500'+char(10)
  SET @v_dSql += '            ,MAX(CASE WHEN OPERATION_ID IS NULL THEN ITEM_ID END) AS ETC'+char(10)
  SET @v_dSql += '      FROM ('+char(10)
  SET @v_dSql += '      	select A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.MODEL_ID'+char(10)
  SET @v_dSql += '            	,A.OPERATION_ID,A.ITEM_ID'+char(10)
  SET @v_dSql += '            	,ROW_NUMBER() OVER(PARTITION BY A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.OPERATION_ID,A.MODEL_ID ORDER BY A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.ITEM_ID) AS RNUM'+char(10)
  SET @v_dSql += '      	from   ('+char(10)
  SET @v_dSql += '				SELECT DISTINCT'+char(10)
  SET @v_dSql += '				AA.COMPANY_ID, AA.DIVISION_ID, AA.SITE_ID, AA.ROOT_ITEM AS MODEL_ID, AA.CHILD_ITEM_ID AS ITEM_ID,BB.OPERATION_ID'+char(10)
  SET @v_dSql += '				FROM CTE_NODE AA INNER JOIN (SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID,'+char(10)
  SET @v_dSql += '												   B.FLOW_ID, B.OPERATION_ID, B.OPERATION_SEQ'+char(10)
  SET @v_dSql += '											FROM   SCM_ITEM_M A(NOLOCK)'+char(10)
  SET @v_dSql += '											INNER HASH JOIN SCM_OPERATION_FLOW_M B(NOLOCK)'+char(10)
  SET @v_dSql += '											ON     A.COMPANY_ID = B.COMPANY_ID'+char(10)
  SET @v_dSql += '											AND    A.DIVISION_ID = B.DIVISION_ID'+char(10)
  SET @v_dSql += '											AND    A.SITE_ID = B.SITE_ID'+char(10)
  SET @v_dSql += '											AND    A.FLOW_ID = B.FLOW_ID'+char(10)
  SET @v_dSql += '											AND    B.ACTIVE_FLAG = ''Y'''+char(10)
  SET @v_dSql += '											INNER HASH JOIN SCM_ITEM_CLASS_M C(NOLOCK)'+char(10)
  SET @v_dSql += '											ON     A.ITEM_CLASS = C.CLASS_ID'+char(10)
  SET @v_dSql += '											AND    C.USE_FLAG = ''Y'''+char(10)
  SET @v_dSql += '											WHERE  A.ACTIVE_FLAG = ''Y'' AND A.ITEM_TYPE <> ''R'''+char(10)
  SET @v_dSql += '										) BB'+char(10)
  SET @v_dSql += '				ON AA.COMPANY_ID=BB.COMPANY_ID'+char(10)
  SET @v_dSql += '				AND AA.DIVISION_ID=BB.DIVISION_ID'+char(10)
  SET @v_dSql += '				AND AA.SITE_ID=BB.SITE_ID'+char(10)
  SET @v_dSql += '				AND AA.CHILD_ITEM_ID=BB.ITEM_ID'+char(10)
  SET @v_dSql += '				UNION ALL'+char(10)
  SET @v_dSql += '				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID AS MODEL_ID, A.ITEM_ID, B.OPERATION_ID'+char(10)
  SET @v_dSql += '				FROM   SCM_ITEM_M A(NOLOCK)'+char(10)
  SET @v_dSql += '				INNER HASH JOIN SCM_OPERATION_FLOW_M B(NOLOCK)'+char(10)
  SET @v_dSql += '				ON     A.COMPANY_ID = B.COMPANY_ID'+char(10)
  SET @v_dSql += '				AND    A.DIVISION_ID = B.DIVISION_ID'+char(10)
  SET @v_dSql += '				AND    A.SITE_ID = B.SITE_ID'+char(10)
  SET @v_dSql += '				AND    A.FLOW_ID = B.FLOW_ID'+char(10)
  SET @v_dSql += '				AND    B.ACTIVE_FLAG = ''Y'''+char(10)
  SET @v_dSql += '				INNER HASH JOIN SCM_ITEM_CLASS_M C(NOLOCK)'+char(10)
  SET @v_dSql += '				ON     A.ITEM_CLASS = C.CLASS_ID'+char(10)
  SET @v_dSql += '				AND    C.USE_FLAG = ''Y'''+char(10)
  SET @v_dSql += '				WHERE  A.ACTIVE_FLAG = ''Y'' AND A.ITEM_TYPE <> ''R'''+char(10)
  SET @v_dSql += '				AND    B.OPERATION_SEQ=1'+char(10)
  SET @v_dSql += '				AND    A.ITEM_TYPE=''P'''+char(10)
  SET @v_dSql += '      	) A'+char(10)
  SET @v_dSql += '      	where  1=1'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  --SET @v_dSql += '
  --{
  --      	  var sql="";
  --      	  var sDiv = $data.DIVISION_LT;
  --
  --      	  if(sDiv!="" && sDiv!=null) {
  --      	    sql+="and    A.division_id in (" + sDiv + ") \r\n";
  --      	  }
  --
  --      	  sql;
  --      	}

  --'
  SET @v_dSql += ' ' +@opt_0site_id +' '+''+char(10)--and    A.site_id=#SITE_ID#
  SET @v_dSql += '      ) A'+char(10)
  SET @v_dSql += '      GROUP BY COMPANY_ID,DIVISION_ID,SITE_ID,MODEL_ID,RNUM'+char(10)
  SET @v_dSql += '      ORDER BY MODEL_ID,COMPANY_ID,DIVISION_ID,SITE_ID,RNUM'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --		var param = $data.param;
  --			$data.querySet1 = $jdbc.queryList("FP02510","find_FP02510_ALL",param);
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
      exec PR_UI_SQL_LOG 'PR_UI_FP02510_FIND_FP02510_ALL',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_FP02510_FIND_FP02510_ALL',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
