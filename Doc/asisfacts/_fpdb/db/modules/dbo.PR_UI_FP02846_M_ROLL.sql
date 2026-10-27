create PROCEDURE [dbo].[PR_UI_FP02846_M_ROLL]
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
/** 프로그램 ID   : PR_UI_FP02846_M_ROLL                                                     **/
/** 프로그램 명   : Procedure PR_UI_FP02846_M_ROLL                             **/
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
/** 2022/03/25     KSI    		Initial Release UI통합                **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP02846_M_ROLL
*/

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
  DECLARE @p_prod_type    NVARCHAR(2000) = ''
  DECLARE @p_electrode_id    NVARCHAR(2000) = ''


  --DECLARE BASE PARAMETER START
  DECLARE @runstart          datetime
  DECLARE @runend            datetime
  DECLARE @v_Err             NVARCHAR(max)
  DECLARE @v_Log             NVARCHAR(max) 
  DECLARE @v_proc_name       NVARCHAR(100) = 'PR_UI_FP02843_WH_CAPA'


  DECLARE @v_plan_date       NVARCHAR(100)
  DECLARE @v_instance_id     NVARCHAR(100)
  DECLARE @v_plan_id         NVARCHAR(100)
  DECLARE @v_division_id     NVARCHAR(1000)
  DECLARE @v_site_id         NVARCHAR(1000)
  DECLARE @v_plant_id        NVARCHAR(2000)
  DECLARE @v_factory_id      NVARCHAR(2000)
  DECLARE @v_user_id         NVARCHAR(max)
  DECLARE @v_prod_type       NVARCHAR(2000) = ''
  DECLARE @v_electrode_id    NVARCHAR(2000) = ''
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


END


BEGIN 
    SELECT @v_instance_id    = '''' + @p_instance_id + ''''  
            , @v_plan_id      = '''' + @p_plan_id + ''''      , @v_division_id  = '''' + @p_division_id + ''''
            , @v_site_id      = '''' + @p_site_id + ''''      , @v_plant_id     = '''' + @p_plant_id + ''''
            , @v_factory_id   = '''' + @p_factory_id + ''''   
END



	--MAIN IF
	IF @p_sys_flag = 'SELECT_MAIN'
		BEGIN --MAIN IF

            SELECT @v_dSql = '';
			SELECT @v_dSql  += '   SELECT 	FA.DIVISION_ID		' + char(10);
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
			
			
			SELECT @v_dSql  += '	GROUP BY FA.DIVISION_ID, FA.SITE_ID, FA.PLANT_ID, PW.WH_ID--, RW.ROLL_TYPE, RW.ITEM_TYPE, RW.ELECTRODE_TYPE, RW.WH_TEMP_CAPA	' + char(10);		
			SELECT @v_dSql  += '	ORDER BY FACTORY_ID, ROLL_TYPE, ELECTRODE_TYPE, WH_ID 		' + char(10);
    

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
			EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
		END


	--		SELECT 	MAX(PW.FACTORY_ID) AS FACTORY_ID		
	--	, MAX(PW.WH_NAME) AS WH_NAME		
	--	, PW.WH_ID		
	--	, MAX(PWR.MTRL_CLSS_CODE) AS ROLL_TYPE		
	--	, MAX(PWR.ELECTRODE_TYPE) AS ELECTRODE_TYPE 		
	--	, MAX(PW.USE_FLAG) AS USE_FLAG 		
	--	, SUM(MAX_LOAD_QTY) AS CAPA		
	--FROM 	SCM_MMD_PRDT_WH_RACK_M AS PWR		
	--	JOIN SCM_MMD_MCS_RACK_M AS MR 		
	--		ON	1=1
	--		AND 	PWR.RACK_ID = MR.RACK_ID 
	--	JOIN SCM_MMD_PRDT_WH_M AS PW		
	--		ON 	1=1
	--		AND 	PWR.WH_ID = PW.WH_ID 
	--WHERE 	1=1		
	--AND 	PWR.USE_FLAG = 'Y'		
	--AND 	MR.USE_FLAG = 'Y'		
	--AND  	PW.USE_FLAG = 'Y'		
	--AND 	PW.FACTORY_ID IN (SELECT FACTORY_ID FROM SCM_FACTORY_M WHERE SITE_ID = 'A004' AND SHOP_GROUP_ID = 'E')		
	--GROUP BY PW.WH_ID			
				
	--* 조회 쿼리 - WH 별 정보 및 CAPA			
	--SELECT 	FA.DIVISION_ID		
	--	, FA.SITE_ID 		
	--	, FA.PLANT_ID 		
	--	, MAX(PW.FACTORY_ID) AS FACTORY_ID		
	--	, MAX(PWR.MTRL_CLSS_CODE) AS ROLL_TYPE		
	--	, MAX(PWR.ELECTRODE_TYPE) AS ELECTRODE_TYPE		
	--	,  PW.WH_ID		
	--	, MAX(PW.WH_NAME) AS WH_NAME		 
	--	, MAX(RW.ATTR_TYPE) AS ATTR_TYPE		
	--	, COUNT(*) AS WH_CAPA		
	----	, SUM(RW.WH_TEMP_CAPA) AS WH_TEMP_CAPA		
	--FROM 	SCM_MMD_PRDT_WH_RACK_M AS PWR		
	--	JOIN SCM_MMD_MCS_RACK_M AS MR 		
	--		ON	1=1
	--		AND 	PWR.RACK_ID = MR.RACK_ID 
	--	JOIN SCM_MMD_PRDT_WH_M AS PW		
	--		ON 	1=1
	--		AND 	PWR.WH_ID = PW.WH_ID 
	--	LEFT OUTER JOIN SCM_ROLL_WAREHOUSE_M RW		
	--		ON 	1=1
	--		AND 	PW.WH_ID = RW.WH_ID 
	--	JOIN SCM_FACTORY_M FA		
	--		ON 	1=1
	--		AND 	PW.FACTORY_ID = FA.FACTORY_ID 
	--WHERE 	1=1		
	--AND 	PWR.USE_FLAG = 'Y'		
	--AND 	MR.USE_FLAG = 'Y'		
	--AND  	PW.USE_FLAG = 'Y'		
	--AND 	PW.FACTORY_ID IN (SELECT FACTORY_ID FROM SCM_FACTORY_M WHERE SITE_ID = 'A004' AND SHOP_GROUP_ID = 'E')		
	--GROUP BY FA.DIVISION_ID, FA.SITE_ID, FA.PLANT_ID, PW.WH_ID--, RW.ROLL_TYPE, RW.ITEM_TYPE, RW.ELECTRODE_TYPE, RW.WH_TEMP_CAPA			
	--ORDER BY FACTORY_ID, WH_ID 			
				
	--* 조회 쿼리 - WH 그룹 별 TEMP CAPA			
	--SELECT 	SEGMENT1 AS INSTANCE_ID, SEGMENT2 AS FACTORY_ID, SEGMENT3 AS ROLL_TYPE, SEGMENT4 AS ELECTRODE_TYPE, SEGMENT5 AS ATTR_TYPE, ATTRIBUTE1 AS TEMP_CAPA		
	--FROM 	SCM_SYS_LOOKUP_VALUE		
	--WHERE 	1=1		
	--AND 	LOOKUP_TYPE_CODE = 'E_POST_WH_CAPA_DEFINIT'		
END
