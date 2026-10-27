CREATE PROCEDURE [dbo].[PR_UI_FP02843_WH_CAPA]
  @p_sys_type			NVARCHAR(MAX),  
  @p_sys_flag			NVARCHAR(MAX),
  @p_sys_gubun			NVARCHAR(MAX),  
  @p_user_id			NVARCHAR(MAX),
  @in_columns           NVARCHAR(MAX),
  @in_row               NVARCHAR(MAX),
  @opt_none             NVARCHAR(5) = 'N'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_UI_FP02843_WH_CAPA                                                     **/
/** 프로그램 명   : Procedure PR_UI_FP02843_WH_CAPA                             **/
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
/** 2022/03/15     KSI    		Initial Release UI통합                **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP02843_WH_CAPA
*/

BEGIN
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
  SET NOCOUNT ON; 
  SET XACT_ABORT ON;
  
  DECLARE @p_plan_date     NVARCHAR(100) = ''
  DECLARE @p_instance_id   NVARCHAR(100) = ''
  DECLARE @p_plan_id       NVARCHAR(100) = ''

  DECLARE @p_company_id   NVARCHAR(1000) = ''
  DECLARE @p_division_id   NVARCHAR(1000) = ''
  DECLARE @p_site_id       NVARCHAR(1000) = ''
  DECLARE @p_plant_id      NVARCHAR(2000) = ''
  DECLARE @p_factory_id    NVARCHAR(2000) = ''
  DECLARE @p_wh_id       NVARCHAR(100) = ''
  DECLARE @p_wh_name      NVARCHAR(2000) = ''

  DECLARE @p_prod_type    NVARCHAR(2000) = ''
  DECLARE @p_roll_type       NVARCHAR(100) = ''
  DECLARE @p_electrode_type       NVARCHAR(100) = ''
  DECLARE @p_wh_capa       NVARCHAR(100) = ''
  DECLARE @p_wh_temp_capa       NVARCHAR(100) = ''

  DECLARE @p_electrode_id    NVARCHAR(2000) = ''
  DECLARE @p_attr_type       NVARCHAR(100) = ''
  DECLARE @p_attr_type_name       NVARCHAR(100) = ''
  DECLARE @p_full_name       NVARCHAR(100) = ''


  --DECLARE BASE PARAMETER START
  DECLARE @runstart          datetime
  DECLARE @runend            datetime
  DECLARE @v_Err             NVARCHAR(max)
  DECLARE @v_Log             NVARCHAR(max) 
  DECLARE @v_proc_name       NVARCHAR(100) = 'PR_UI_FP02843_WH_CAPA'


  DECLARE @v_plan_date       NVARCHAR(100)
  DECLARE @v_instance_id     NVARCHAR(100)
  DECLARE @v_plan_id         NVARCHAR(100)

  DECLARE @v_company_id   NVARCHAR(1000) = ''
  DECLARE @v_division_id     NVARCHAR(1000)
  DECLARE @v_site_id         NVARCHAR(1000)
  DECLARE @v_plant_id        NVARCHAR(2000)
  DECLARE @v_factory_id      NVARCHAR(2000)
  DECLARE @v_wh_id       NVARCHAR(100) = ''
  DECLARE @v_wh_name      NVARCHAR(2000) = ''

  DECLARE @v_user_id         NVARCHAR(max)
  DECLARE @v_prod_type       NVARCHAR(2000) = ''  
  DECLARE @v_roll_type       NVARCHAR(100) = '' 
  DECLARE @v_electrode_type       NVARCHAR(100) = ''  
  DECLARE @v_electrode_id    NVARCHAR(2000) = ''

  DECLARE @v_wh_capa       NVARCHAR(100) = ''
  DECLARE @v_wh_temp_capa       NVARCHAR(1000) = ''
  DECLARE @v_attr_type       NVARCHAR(100) = ''
  DECLARE @v_attr_type_name       NVARCHAR(100) = ''
  DECLARE @v_full_name       NVARCHAR(100) = ''

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  DECLARE @v_dSql                 NVARCHAR(MAX)=''
	DECLARE @v_sub_delimiter          NVARCHAR(MAX)=''
	DECLARE @v_SqlTotal             NVARCHAR(MAX)=''

	DECLARE @v_pSql                 NVARCHAR(MAX)=''
	DECLARE @v_sSql                 NVARCHAR(MAX)=''

  DECLARE @v_Tmp1                 NVARCHAR(MAX)=''
  DECLARE @v_Tmp2                 NVARCHAR(MAX)=''
  DECLARE @v_Tmp3                 NVARCHAR(MAX)=''
  DECLARE @v_Tmp4                 NVARCHAR(MAX)=''
  DECLARE @v_Tmp5                 NVARCHAR(MAX)=''


  DECLARE @tmp_column             NVARCHAR(MAX) = ''
  DECLARE @dbg_txt                NVARCHAR(MAX) = ''

  DECLARE @v_delimiter            NVARCHAR(1)
  DECLARE @max_loop_cnt	          INTEGER = 0
  DECLARE @mst_loop_cnt	          INTEGER = 0

  DECLARE @sub_mst_loop_cnt       INTEGER = 0
  DECLARE @sub_max_loop_cnt       INTEGER = 0
  DECLARE @sub_v_delimiter        NVARCHAR(2) = '#'
  DECLARE @sub_tmp_column         NVARCHAR(MAX) = ''
								  
  DECLARE @sub_param_0            NVARCHAR(200) = '' 
  DECLARE @sub_param_1            NVARCHAR(200) = '' 
  DECLARE @sub_param_2            NVARCHAR(200) = '' 
  DECLARE @sub_param_3            NVARCHAR(200) = '' 
  DECLARE @sub_param_4            NVARCHAR(200) = '' 

    
SET	@v_pSql               = ''
SET   @v_sSql               = ''
--Optional Parameter Part END

SET @v_delimiter            = '^'  -- ������ ������
SET @v_sub_delimiter        = ','  -- ������ ������
SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@in_columns, @v_delimiter) -- ���ν��� LOOP ���̸� �Ǵ�


    

WHILE @mst_loop_cnt < @max_loop_cnt
BEGIN --START WHILE
    SET @mst_loop_cnt = @mst_loop_cnt + 1;    
    
    SET @tmp_column   = [dbo].[SCM_ARR_SPL_VAL]( @in_columns, @v_delimiter, @mst_loop_cnt);

    IF @tmp_column = 'INSTANCE_ID' 
    BEGIN
        SET @p_instance_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
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
	ELSE IF @tmp_column = 'PROD_TYPE' 
    BEGIN
        SET @p_prod_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row     ,@v_delimiter, @mst_loop_cnt);
    END 
	ELSE IF @tmp_column = 'ELECTRODE_ID' 
    BEGIN
        SET @p_electrode_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row     ,@v_delimiter, @mst_loop_cnt);
    END 
	ELSE IF @tmp_column = 'WH_ID' 
    BEGIN
        SET @p_wh_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row     ,@v_delimiter, @mst_loop_cnt);
    END
	ELSE IF @tmp_column = 'COMPANY_ID' 
    BEGIN
        SET @p_company_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row     ,@v_delimiter, @mst_loop_cnt);
    END
	ELSE IF @tmp_column = 'WH_NAME' 
    BEGIN
        SET @p_wh_name =  [dbo].[SCM_ARR_SPL_VAL]( @in_row     ,@v_delimiter, @mst_loop_cnt);
    END
	ELSE IF @tmp_column = 'ROLL_TYPE' 
    BEGIN
        SET @p_roll_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row     ,@v_delimiter, @mst_loop_cnt);
    END
	ELSE IF @tmp_column = 'ELECTRODE_TYPE' 
    BEGIN
        SET @p_electrode_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row     ,@v_delimiter, @mst_loop_cnt);
    END
	ELSE IF @tmp_column = 'WH_CAPA' 
    BEGIN
        SET @p_wh_capa =  [dbo].[SCM_ARR_SPL_VAL]( @in_row     ,@v_delimiter, @mst_loop_cnt);
    END
	ELSE IF @tmp_column = 'ATTR_TYPE' 
    BEGIN
        SET @p_attr_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row     ,@v_delimiter, @mst_loop_cnt);
    END
	ELSE IF @tmp_column = 'ATTR_TYPE_NAME' 
    BEGIN
        SET @p_attr_type_name =  [dbo].[SCM_ARR_SPL_VAL]( @in_row     ,@v_delimiter, @mst_loop_cnt);
    END
	ELSE IF @tmp_column = 'WH_TEMP_CAPA' 
    BEGIN
        SET @p_wh_temp_capa  =  [dbo].[SCM_ARR_SPL_VAL]( @in_row     ,@v_delimiter, @mst_loop_cnt);
    END
	ELSE IF @tmp_column = 'FULL_NAME' 
    BEGIN
        SET @p_full_name  =  [dbo].[SCM_ARR_SPL_VAL]( @in_row     ,@v_delimiter, @mst_loop_cnt);
    END
END


BEGIN 
    SELECT @v_instance_id    = '''' + @p_instance_id + ''''  
            , @v_plan_id      = '''' + @p_plan_id + ''''      , @v_division_id  = '''' + @p_division_id + ''''
            , @v_site_id      = '''' + @p_site_id + ''''      , @v_plant_id     = '''' + @p_plant_id + ''''
            , @v_factory_id   = '''' + @p_factory_id + ''''   , @v_wh_id     = '''' + @p_wh_id + ''''
			, @v_attr_type   = '''' + @p_attr_type + ''''   , @v_wh_temp_capa     = '''' + @p_wh_temp_capa + ''''
			
			, @v_company_id  = '''' + @p_company_id + ''''   , @v_wh_name     = '''' + @p_wh_name + ''''
			, @v_roll_type  = '''' + @p_roll_type + ''''   , @v_electrode_type     = '''' + @p_electrode_type + ''''
			, @v_wh_capa   = '''' + @p_wh_capa  + ''''  , @v_user_id     = '''' + @p_user_id + '''' 
			, @v_attr_type_name     = '''' + @p_attr_type_name + '''' , @v_full_name     = '''' + @p_full_name + ''''
END



	--MAIN IF
	IF @p_sys_flag = 'SELECT_MAIN'
	BEGIN --MAIN IF

        SELECT @v_dSql = '';
		SELECT @v_dSql  += '   SELECT 	FA.COMPANY_ID	,FA.DIVISION_ID		' + char(10);
		SELECT @v_dSql  += '		, FA.SITE_ID 		' + char(10);
		SELECT @v_dSql  += '		, FA.PLANT_ID 		' + char(10);
		SELECT @v_dSql  += '		, MAX(PW.FACTORY_ID) AS FACTORY_ID		' + char(10);
		SELECT @v_dSql  += '		, MAX(PWR.MTRL_CLSS_CODE) AS ROLL_TYPE		' + char(10);
		SELECT @v_dSql  += '		, MAX(PWR.ELECTRODE_TYPE) AS ELECTRODE_TYPE		' + char(10);
		SELECT @v_dSql  += '		,  PW.WH_ID		' + char(10);
		SELECT @v_dSql  += '		, MAX(PW.WH_NAME) AS WH_NAME		 ' + char(10);
		SELECT @v_dSql  += '		, MAX(RW.ATTR_TYPE) AS ATTR_TYPE		' + char(10);
		SELECT @v_dSql  += '		, COUNT(*) AS MAX_LOAD_QTY					' + char(10);
		SELECT @v_dSql  += '	FROM 	SCM_MMD_PRDT_WH_RACK_M AS PWR		' + char(10);
		SELECT @v_dSql  += '		JOIN SCM_MMD_MCS_RACK_M AS MR 		' + char(10);
		SELECT @v_dSql  += '			ON	1=1' + char(10);
		SELECT @v_dSql  += '			AND 	PWR.RACK_ID = MR.RACK_ID ' + char(10);
		SELECT @v_dSql  += '		JOIN SCM_MMD_PRDT_WH_M AS PW		' + char(10);
		SELECT @v_dSql  += '			ON 	1=1' + char(10);
		SELECT @v_dSql  += '			AND 	PWR.WH_ID = PW.WH_ID ' + char(10);
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                PW.FACTORY_ID' , 'EQ', @p_factory_id))          + char(10) 
		SELECT @v_dSql  += '		LEFT OUTER JOIN SCM_ROLL_WAREHOUSE_M RW		' + char(10);
		SELECT @v_dSql  += '			ON 	1=1' + char(10);
		SELECT @v_dSql  += '			AND 	PW.WH_ID = RW.WH_ID ' + char(10);			
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                RW.DIVISION_ID' , 'EQ', @p_division_id))        + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                RW.SITE_ID' , 'EQ', @p_site_id))        + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                RW.PLANT_ID' , 'EQ', @p_plant_id))              + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                RW.FACTORY_ID' , 'EQ', @p_factory_id))          + char(10) 
			
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                RW.ROLL_TYPE' , 'EQ', @p_prod_type))        + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                RW.ELECTRODE_TYPE' , 'EQ', @p_electrode_id))        + char(10)

		--SELECT @v_dSql  += '			AND     RW.ROLL_TYPE = ''P'' ' + char(10);
		--SELECT @v_dSql  += '			AND     RW.ELECTRODE_TYPE = ''C'' ' + char(10);
			

		SELECT @v_dSql  += '		JOIN SCM_FACTORY_M FA		' + char(10);
		SELECT @v_dSql  += '			ON 	1=1' + char(10);
		SELECT @v_dSql  += '			AND 	PW.FACTORY_ID = FA.FACTORY_ID ' + char(10);
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                FA.DIVISION_ID' , 'EQ', @p_division_id))        + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                FA.SITE_ID' , 'EQ', @p_site_id))        + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                FA.PLANT_ID' , 'EQ', @p_plant_id))              + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                FA.FACTORY_ID' , 'EQ', @p_factory_id))          + char(10) 

		SELECT @v_dSql  += '	WHERE 	1=1		' + char(10);
		SELECT @v_dSql  += '	AND 	PWR.USE_FLAG = ''Y''		' + char(10);
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                PWR.MTRL_CLSS_CODE' , 'EQ', @p_prod_type))        + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                PWR.ELECTRODE_TYPE' , 'EQ', @p_electrode_id))        + char(10)
		--SELECT @v_dSql  += '			AND     PWR.MTRL_CLSS_CODE = ''P'' ' + char(10);
		--SELECT @v_dSql  += '			AND     PWR.ELECTRODE_TYPE = ''C'' ' + char(10);
		SELECT @v_dSql  += '	AND 	MR.USE_FLAG = ''Y''		' + char(10);
		SELECT @v_dSql  += '	AND  	PW.USE_FLAG = ''Y''		' + char(10);
		SELECT @v_dSql  += '	AND 	PW.FACTORY_ID IN (		  ' + char(10);
		SELECT @v_dSql  += '								SELECT FACTORY_ID FROM SCM_FACTORY_M WHERE 	1=1 '  + char(10) 
		--SITE_ID = ''A004'' 
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('                FA.SITE_ID' , 'EQ', @p_site_id))        + char(10)
		SELECT @v_dSql  += '    AND SHOP_GROUP_ID = ''E'')		' + char(10);
			
			
		SELECT @v_dSql  += '	GROUP BY FA.COMPANY_ID, FA.DIVISION_ID, FA.SITE_ID, FA.PLANT_ID, PW.WH_ID--, RW.ROLL_TYPE, RW.ITEM_TYPE, RW.ELECTRODE_TYPE, RW.WH_TEMP_CAPA	' + char(10);		
		SELECT @v_dSql  += '	ORDER BY FACTORY_ID, ROLL_TYPE, ELECTRODE_TYPE, WH_ID 		' + char(10);    
	END
	ELSE IF @p_sys_flag = 'merge_batch'
	BEGIN
			SELECT @v_dSql  = '';

	--SELECT @v_dSql += 'BEGIN ' + char(10)
    SELECT @v_dSql += '     BEGIN TRAN       ' + char(10)
    SELECT @v_dSql += '         MERGE INTO SCM_ROLL_WAREHOUSE_M A            ' + char(10)
  SELECT @v_dSql += '         USING (SELECT ' + @v_company_id + ' AS COMPANY_ID,           ' + char(10)
    
    SELECT @v_dSql +=			@v_division_id + ' AS DIVISION_ID, ' + char(10)
    SELECT @v_dSql +=			@v_site_id + ' AS SITE_ID, ' + char(10)
    SELECT @v_dSql +=			@v_plant_id + ' AS PLANT_ID, ' + char(10)
    
    SELECT @v_dSql +=			@v_factory_id + ' AS FACTORY_ID, ' + char(10)
	SELECT @v_dSql +=			@v_wh_id + ' AS WH_ID, ' + char(10)    
	SELECT @v_dSql +=			@v_wh_name + ' AS WH_NAME, ' + char(10)

    SELECT @v_dSql +=			@v_roll_type + ' AS ROLL_TYPE, ' + char(10)
    SELECT @v_dSql +=			@v_attr_type + ' AS ATTR_TYPE, ' + char(10)
    SELECT @v_dSql +=			@v_electrode_type + ' AS ELECTRODE_TYPE, ' + char(10)
    SELECT @v_dSql +=			@v_wh_capa + ' AS WH_CAPA, ' + char(10)
    SELECT @v_dSql +=			@v_wh_temp_capa + ' AS WH_TEMP_CAPA ) B ' + char(10)

  

    SELECT @v_dSql +=			' ON (    	 A.COMPANY_ID = B.COMPANY_ID  ' + char(10)  
	SELECT @v_dSql +=			' AND  A.DIVISION_ID = B.DIVISION_ID' + char(10)
	SELECT @v_dSql +=			' AND A.SITE_ID = B.SITE_ID ' + char(10)
    SELECT @v_dSql +=			' AND A.PLANT_ID = B.PLANT_ID ' + char(10)
    SELECT @v_dSql +=			' AND A.FACTORY_ID = B.FACTORY_ID  ' + char(10)
    --SELECT @v_dSql +=			' AND A.ROLL_TYPE = B.ROLL_TYPE  ' + char(10)
    --SELECT @v_dSql +=			' AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE  ' + char(10)

    SELECT @v_dSql +=			' AND A.WH_ID = B.WH_ID   )    ' + char(10)

	SELECT @v_dSql +=			'  WHEN MATCHED THEN ' + char(10)
	SELECT @v_dSql +=			'  UPDATE SET ATTR_TYPE = B.ATTR_TYPE ' + char(10)
	SELECT @v_dSql +=			'  , WH_TEMP_CAPA  = B.WH_TEMP_CAPA ' +  char(10)
	SELECT @v_dSql +=			'  , UPDATE_ID  = ' + @v_user_id + char(10)
	SELECT @v_dSql +=			'  , UPDATE_TIME = ' + 'dbo.FN_SITE_TIME(' + @v_site_id + ')'+ char(10)
            
    SELECT @v_dSql +=	' WHEN NOT MATCHED THEN INSERT ( ' + char(10)
     SELECT @v_dSql +=	'		COMPANY_ID, ' + char(10)
	 SELECT @v_dSql +=	'		DIVISION_ID, ' + char(10)
	 SELECT @v_dSql +=	'		SITE_ID, ' + char(10)
	 SELECT @v_dSql +=	'		PLANT_ID, ' + char(10)
	 SELECT @v_dSql +=	'		FACTORY_ID, ' + char(10)
	 SELECT @v_dSql +=	'		WH_ID,WH_NAME,ROLL_TYPE,ATTR_TYPE,ELECTRODE_TYPE, ' + char(10)
	 SELECT @v_dSql +=	'		WH_CAPA,WH_TEMP_CAPA,ACTIVE_FLAG,DESCRIPTION, ' + char(10)
	 SELECT @v_dSql +=	'		INSERT_ID,INSERT_TIME,UPDATE_ID,UPDATE_TIME ' + char(10)

	 SELECT @v_dSql +=	'  ) ' + char(10)

	 SELECT @v_dSql +=	' VALUES (' + char(10)	
	 SELECT @v_dSql +=			@v_company_id + char(10)
	 SELECT @v_dSql +=	'     ,' + @v_division_id + char(10)
	 SELECT @v_dSql +=	'     ,' +  @v_site_id + char(10)
	 SELECT @v_dSql +=	'     ,' + @v_plant_id + char(10)
	 SELECT @v_dSql +=	'     ,' + @v_factory_id + char(10)
	 SELECT @v_dSql +=	'     ,' + @v_wh_id  + char(10)
	 SELECT @v_dSql +=	'     ,' + @v_wh_name + char(10)
	 SELECT @v_dSql +=	'     ,' + @v_roll_type  + char(10)
	 SELECT @v_dSql +=	'     ,' + @v_attr_type + char(10)
	 SELECT @v_dSql +=	'     ,' + @v_electrode_type + char(10)
	 SELECT @v_dSql +=	'     ,' + @p_wh_capa  + char(10)
	 SELECT @v_dSql +=	'     ,' + @p_wh_temp_capa + char(10)
	 SELECT @v_dSql +=	'     , ''Y'' ' + char(10)
	 SELECT @v_dSql +=	'     , null' + char(10)	
	 SELECT @v_dSql +=	'     ,' + @v_user_id + ',' +  'dbo.FN_SITE_TIME(' + @v_site_id + ')' + char(10)
	 SELECT @v_dSql +=	'     ,' + @v_user_id + ',' +  'dbo.FN_SITE_TIME(' + @v_site_id + ')' + char(10)
     SELECT @v_dSql +=	'       ); ' + char(10)
     SELECT @v_dSql +=	'   COMMIT; ' + char(10)


	


	 --SELECT @v_dSql +=	' END; ' + char(10)
	END
	ELSE IF @p_sys_flag = 'merge_batch_t'
	BEGIN
	SELECT @v_dSql += '     BEGIN TRAN       ' + char(10)
	SELECT @v_dSql += '         MERGE INTO SCM_SYS_LOOKUP_VALUE A            ' + char(10)
	SELECT @v_dSql += '         USING (SELECT ''E_POST_WH_CAPA_DEFINIT'' AS LOOKUP_TYPE_CODE,           ' + char(10)
    
	SELECT @v_dSql +='			''PL_E_POST'' AS SEGMENT1, ' + char(10)
	SELECT @v_dSql +=			@v_factory_id + ' AS SEGMENT2, ' + char(10)
	SELECT @v_dSql +=			@v_roll_type + ' AS SEGMENT3, ' + char(10)
    
	SELECT @v_dSql +=			@v_electrode_type + ' AS SEGMENT4, ' + char(10)
	SELECT @v_dSql +=			@v_attr_type + ' AS SEGMENT5, ' + char(10)    
	SELECT @v_dSql +=			@v_wh_temp_capa + ' AS ATTRIBUTE1 ) B ' + char(10)

	SELECT @v_dSql +=			' ON (    	 A.LOOKUP_TYPE_CODE = B.LOOKUP_TYPE_CODE  ' + char(10)  
	SELECT @v_dSql +=			' AND A.SEGMENT1 = B.SEGMENT1' + char(10)
	SELECT @v_dSql +=			' AND A.SEGMENT2 = B.SEGMENT2 ' + char(10)
	SELECT @v_dSql +=			' AND A.SEGMENT3 = B.SEGMENT3 ' + char(10)
	SELECT @v_dSql +=			' AND A.SEGMENT4 = B.SEGMENT4  ' + char(10)
	SELECT @v_dSql +=			' AND A.SEGMENT5 = B.SEGMENT5  ' + char(10)
	SELECT @v_dSql +=			'  )    ' + char(10)
	SELECT @v_dSql +=			'  WHEN MATCHED THEN ' + char(10)
	SELECT @v_dSql +=			'  UPDATE SET A.ATTRIBUTE1 = ' + char(10)
	SELECT @v_dSql +=			'  CASE ' + char(10)
	SELECT @v_dSql +=			'  WHEN  B.ATTRIBUTE1 = ''0'' THEN null ' + char(10)
	SELECT @v_dSql +=			'  ELSE  B.ATTRIBUTE1 END' + char(10)
	SELECT @v_dSql +=			'  , A.MODIFY_USER_ID  = ' + @v_user_id + char(10)
	SELECT @v_dSql +=			'  , A.MODIFY_DATE = ' + 'dbo.FN_SITE_TIME(' + @v_site_id + ');'+ char(10)

	 --SELECT @v_dSql +=	' WHEN NOT MATCHED THEN INSERT ( ' + char(10)
  --   SELECT @v_dSql +=	'		LOOKUP_TYPE_CODE, ' + char(10)
	 --SELECT @v_dSql +=	'		SEGMENT1, ' + char(10)
	 --SELECT @v_dSql +=	'		SEGMENT2, ' + char(10)
	 --SELECT @v_dSql +=	'		SEGMENT3, ' + char(10)
	 --SELECT @v_dSql +=	'		SEGMENT4, ' + char(10)
	 --SELECT @v_dSql +=	'		SEGMENT5,  SORT_ORDER, ACTIVE_FLAG, VALUE_DESCRIPTION, ' + char(10)
	 --SELECT @v_dSql +=	'		CREATE_USER_ID, CREATE_DATE, MODIFY_USER_ID, MODIFY_DATE, ' + char(10)
	 --SELECT @v_dSql +=	'		ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3 ' + char(10)

	 --SELECT @v_dSql +=	'  ) ' + char(10)

	 --SELECT @v_dSql +=	' VALUES (' + char(10)	
	 --SELECT @v_dSql +=			'''E_POST_WH_CAPA_DEFINIT''' + char(10)
	 --SELECT @v_dSql +=	'     ,' + '''PL_E_POST''' + char(10)
	 --SELECT @v_dSql +=	'     ,' +  @v_factory_id + char(10)
	 --SELECT @v_dSql +=	'     ,' +  @v_roll_type + char(10)
	 --SELECT @v_dSql +=	'     ,' +  @v_electrode_type + char(10)
	 --SELECT @v_dSql +=	'     ,' + @v_attr_type  + char(10)
	 --SELECT @v_dSql +=	'     ,' + 'CONVERT(numeric,' +  ' (select (select count(*) + 1 from SCM_SYS_LOOKUP_VALUE where lookup_type_code = ''E_POST_WH_CAPA_DEFINIT'' ) * 10 )) ' + char(10)
	 --SELECT @v_dSql +=	'     ,' + '''Y'''  + char(10)
	 --SELECT @v_dSql +=	'     , null ' +char(10)
	 --SELECT @v_dSql +=	'     ,' + @v_user_id + ',' +  'dbo.FN_SITE_TIME(' + @v_site_id + ')' + char(10)
	 --SELECT @v_dSql +=	'     ,' + @v_user_id + ',' +  'dbo.FN_SITE_TIME(' + @v_site_id + ')' + char(10)
	 --SELECT @v_dSql +=	'     ,' + @p_wh_temp_capa      + char(10)	
	 --SELECT @v_dSql +=	'     ,' + @v_attr_type_name + char(10)
	 --SELECT @v_dSql +=	'     ,' + @v_full_name + char(10)
  --   SELECT @v_dSql +=	'       ); ' + char(10)

	 SELECT @v_dSql +=	'   COMMIT; ' + char(10)
	END

--------------------------------------------------------------------------------------------------------------------------------------------------------------
IF @p_sys_type = 'SQL'
BEGIN
	-- return SQL Query Source
	select @v_dSql as [QUERY_VALUE]
END 
ELSE 
BEGIN
	SET @runstart = GetDate()

	BEGIN TRY
		BEGIN TRAN
		-- run dynamic sql
			exec sp_executesql @v_dSql
		COMMIT TRAN
	END 
		
	TRY
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
