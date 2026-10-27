

/*
 * Program ID   : PR_UI_FP00521_DEMAND_WATERFALL
 * Description  : Demand WaterFall
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/06/02   JYJ				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00521_DEMAND_WATERFALL]
  @p_sys_type                   NVARCHAR(100),
  @p_sys_flag                   NVARCHAR(100),
  @p_sys_gubun                  NVARCHAR(100),
  @p_user_id                    NVARCHAR(100),
  @p_instance_id				NVARCHAR(100),
  @p_site_id					NVARCHAR(100),
  @p_plant_id					NVARCHAR(100),
  @p_factory_id					NVARCHAR(MAX),
  @p_operation_id				NVARCHAR(MAX),
  @p_line_id					NVARCHAR(MAX),
  @p_prod_type					NVARCHAR(MAX),
  @p_model_id					NVARCHAR(100),
  @p_item_id					NVARCHAR(100),
  @p_nick_name					NVARCHAR(100),
  @p_chk_total_include			NVARCHAR(100),
  @p_pp_option					NVARCHAR(100),
  @p_curr_week					NVARCHAR(100),
  @p_bucket_from_date			NVARCHAR(100),
  @p_bucket_to_date				NVARCHAR(100),
  @p_bucket_from_week			NVARCHAR(100),
  @p_bucket_to_week				NVARCHAR(100),
  @p_plan_from_week				NVARCHAR(100),
  @p_plan_to_week				NVARCHAR(100),
  @p_week_info					NVARCHAR(MAX),
  @p_month_week_column	        NVARCHAR(MAX),
  @p_month_column_info		    NVARCHAR(MAX),
  @p_plan_week_Info			    NVARCHAR(MAX)



AS 
BEGIN  --MAIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
    SET NOCOUNT ON                                                                                                                                                                                                                                                   
	SET XACT_ABORT ON 

	DECLARE @v_sys_type                   NVARCHAR(100)  -- 값>> SELEC: SQL저장안함, SQL:SQL저장함
	DECLARE @v_sys_flag                   NVARCHAR(100)  -- 값>> I: Insert, M: Update, D: Delete, G: MERGE
	DECLARE @v_sys_gubun                  NVARCHAR(100) 
	DECLARE @v_user_id                    NVARCHAR(100)
    DECLARE @v_instance_id                NVARCHAR(100)
    DECLARE @v_site_id                    NVARCHAR(100)
    DECLARE @v_plant_id                   NVARCHAR(100)
    DECLARE @v_factory_id                 NVARCHAR(MAX)
    DECLARE @v_operation_id               NVARCHAR(MAX)
    DECLARE @v_line_id                    NVARCHAR(MAX)
    DECLARE @v_prod_type                  NVARCHAR(MAX)
    DECLARE @v_model_id                   NVARCHAR(100)
    DECLARE @v_item_id                    NVARCHAR(100)
    DECLARE @v_nick_name                  NVARCHAR(100)
    DECLARE @v_chk_total_include          NVARCHAR(100)
    DECLARE @v_pp_option                  NVARCHAR(100)
    DECLARE @v_curr_week                  NVARCHAR(100)
    DECLARE @v_bucket_from_date           NVARCHAR(100)
    DECLARE @v_bucket_to_date             NVARCHAR(100)
    DECLARE @v_bucket_from_week           NVARCHAR(100)
    DECLARE @v_bucket_to_week             NVARCHAR(100)
    DECLARE @v_plan_from_week             NVARCHAR(100)
    DECLARE @v_plan_to_week               NVARCHAR(100)
    DECLARE @v_week_info                  NVARCHAR(MAX)
    DECLARE @v_month_week_column          NVARCHAR(MAX)
    DECLARE @v_month_column_info          NVARCHAR(MAX)
    DECLARE @v_plan_week_Info             NVARCHAR(MAX)

	DECLARE @recv_active_flag       NVARCHAR(MAX)				    
	DECLARE @v_proc_name	        NVARCHAR(100) = 'PR_UI_FP00521_DEMAND_WATERFALL'
	DECLARE @v_log_type             NVARCHAR(100) = ''
	DECLARE @v_log_message          NVARCHAR(MAX) = ''
	DECLARE @v_error_description    NVARCHAR(MAX) = ''
	DECLARE @v_delimiter            NVARCHAR(1)
	DECLARE @max_loop_cnt	        INTEGER = 0
	DECLARE @mst_loop_cnt	        INTEGER = 0
	DECLARE @max_loop_cnt2	        INTEGER = 0
	DECLARE @mst_loop_cnt2	        INTEGER = 0
	DECLARE @v_seq_no   	        INTEGER = 0
	DECLARE @rtnCount   	        INTEGER = 0

	DECLARE @sysdate                DATETIME      = GETDATE()
	DECLARE @runstart               datetime
    DECLARE @runend                 datetime

	DECLARE @v_dSql                 NVARCHAR(MAX)=''
	DECLARE @v_dSql1                NVARCHAR(MAX)=''
	DECLARE @v_dSql2                NVARCHAR(MAX)=''
	DECLARE @v_dSql3                NVARCHAR(MAX)=''
	DECLARE @v_dSql4                NVARCHAR(MAX)=''
	DECLARE @v_dSql5                NVARCHAR(MAX)=''
	DECLARE @v_dSql6                NVARCHAR(MAX)=''

	DECLARE @v_tmp1                 NVARCHAR(MAX)=''
	DECLARE @v_tmp2                 NVARCHAR(MAX)=''

	SET @v_sys_type                 = ''
	SET @v_sys_flag                 = ''
	SET @v_sys_gubun                = ''
	SET @v_user_id                  = ''
    SET @v_instance_id              = ''
    SET @v_site_id                  = ''
    SET @v_plant_id                 = ''
    SET @v_factory_id               = ''
    SET @v_operation_id             = ''
    SET @v_line_id                  = ''
    SET @v_prod_type                = ''
    SET @v_model_id                 = ''
    SET @v_item_id                  = ''
    SET @v_nick_name                = ''
    SET @v_chk_total_include        = ''
    SET @v_pp_option                = ''
    SET @v_curr_week                = ''
    SET @v_bucket_from_date         = ''
    SET @v_bucket_to_date           = ''
    SET @v_bucket_from_week         = ''
    SET @v_bucket_to_week           = ''
    SET @v_plan_from_week           = ''
    SET @v_plan_to_week             = ''
    SET @v_week_info                = ''
    SET @v_month_week_column        = ''
    SET @v_month_column_info        = ''
    SET @v_plan_week_Info           = ''

	--SET @p_user_id              = dbo.FN_deCRYPT_AES128(@p_user_id)
	SET @recv_active_flag       = NULL	
	SET @recv_active_flag       = @p_sys_flag
	SET @v_delimiter            = '|'             -- 데이터 구분자

	SET	@v_dSql                 = ''
	SET	@v_dSql1                = ''
	SET	@v_dSql2                = ''
	SET	@v_dSql3                = ''
	SET	@v_dSql4                = ''
	SET	@v_dSql5                = ''
	SET	@v_dSql6                = ''

    SET	@v_tmp1                 = ''
	SET	@v_tmp2                 = ''

	/************************************************************************************************/
	/* SELECT인경우 :SELECT(SELECT)                                                                      */
	/************************************************************************************************/
    IF(@p_sys_flag ='SELECT_MAIN')
        BEGIN --IF(START)
            SELECT @v_dSql1 = ''

            SELECT @v_dSql1 += ' -- scp target master ' +char(10)
            SELECT @v_dSql1 += ' WITH SCP_INFO AS (                                                               ' +char(10)
            SELECT @v_dSql1 += '         SELECT A.*                                                               ' +char(10)
            SELECT @v_dSql1 += '         FROM (                                                                   ' +char(10)
            SELECT @v_dSql1 += '               SELECT  A.SCP_PLAN_ID, A.PLAN_WEEK, A.COMPANY_ID                   ' +char(10)
            SELECT @v_dSql1 += '			    , A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.MARKET                  ' +char(10)
            SELECT @v_dSql1 += '                   , (CASE WHEN A.PRODUCTION_TYPE = ''TEST'' THEN ''S-TEST''      ' +char(10)
            SELECT @v_dSql1 += '				        ELSE A.PRODUCTION_TYPE END) AS PRODUCTION_TYPE            ' +char(10)
            SELECT @v_dSql1 += '                   , A.SCP_TARGET_ID, A.OPERATION_ID, A.LINE_ID                   ' +char(10) 
            SELECT @v_dSql1 += '                   , A.ITEM_ID, A.MFG_WEEK , A.MFG_QTY                            ' +char(10)
            SELECT @v_dSql1 += '                   , DENSE_RANK() OVER( PARTITION BY A.PLAN_WEEK, A.COMPANY_ID    ' +char(10)
            SELECT @v_dSql1 += '				                  , A.DIVISION_ID, A.SITE_ID, A.PLANT_ID          ' +char(10)
            SELECT @v_dSql1 += '                              ORDER BY     A.SCP_PLAN_ID DESC ) AS RNK            ' +char(10)
            SELECT @v_dSql1 += '               FROM (                                                             ' +char(10)
            SELECT @v_dSql1 += '                    SELECT A.*, CAL.ISO_YYYYWW AS PLAN_WEEK                       ' +char(10)
            SELECT @v_dSql1 += '                    FROM   FP_WEEKLY_DEMAND_PRODUCT_H A WITH(NOLOCK)              ' +char(10)
            SELECT @v_dSql1 += '                    INNER JOIN TH_UIS_CAL CAL WITH(NOLOCK)                        ' +char(10)
            SELECT @v_dSql1 += '                    ON  1=1                                                       ' +char(10)
            SELECT @v_dSql1 += '                    AND EXISTS (                                                  ' +char(10)
            SELECT @v_dSql1 += '                                SELECT 1                                          ' +char(10)
            SELECT @v_dSql1 += '                                FROM   FP_INSTANCE_FACTORY_M AA WITH(NOLOCK)      ' +char(10)
			SELECT @v_dSql1 += '                                    , SCM_FACTORY_M BB WITH(NOLOCK)               ' +char(10)
            SELECT @v_dSql1 += '                                WHERE  AA.INSTANCE_ID  = '''+ @p_instance_id +''' ' +char(10)
            SELECT @v_dSql1 += '                                AND    AA.ACTIVE_FLAG  = ''Y''                    ' +char(10)
            SELECT @v_dSql1 += '                                AND    BB.ACTIVE_FLAG  = ''Y''                    ' +char(10)
            SELECT @v_dSql1 += '                                AND    AA.FACTORY_ID   = BB.FACTORY_ID            ' +char(10)
            SELECT @v_dSql1 += '                                AND    A.COMPANY_ID    = BB.COMPANY_ID            ' +char(10)
            SELECT @v_dSql1 += '                                AND    A.DIVISION_ID   = BB.DIVISION_ID           ' +char(10)
            SELECT @v_dSql1 += '                                AND    A.SITE_ID       = BB.SITE_ID               ' +char(10)
            SELECT @v_dSql1 += '                                AND    A.PLANT_ID      = BB.PLANT_ID              ' +char(10)
            SELECT @v_dSql1 += '                                AND    A.SHOP_GROUP_ID = BB.SHOP_GROUP_ID         ' +char(10)
            SELECT @v_dSql1 += '                               )                                                  ' +char(10)
            SELECT @v_dSql1 += '                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))             + char(10)
            SELECT @v_dSql1 += '                    AND   SUBSTRING(A.SCP_PLAN_ID, 1, 8) = CAL.YYYYMMDD                                     ' +char(10)
            SELECT @v_dSql1 += '                    AND   A.MFG_WEEK BETWEEN '''+ @p_bucket_from_week +''' AND '''+ @p_bucket_to_week +'''  ' +char(10)
            SELECT @v_dSql1 += '                    AND   CAL.ISO_YYYYWW BETWEEN '''+ @p_plan_from_week +''' AND '''+ @p_plan_to_week +'''  ' +char(10)
            SELECT @v_dSql1 += '             ) A                                                                  ' +char(10)
            SELECT @v_dSql1 += '         ) A                                                                      ' +char(10)
            SELECT @v_dSql1 += '         WHERE A.RNK = 1                                                          ' +char(10)
            SELECT @v_dSql1 += '   )                                                                              ' +char(10)
            SELECT @v_dSql1 += '   -- scp target detail                                                           ' +char(10)
            SELECT @v_dSql1 += '   , SCP_TARGET_RAW AS (                                                          ' +char(10)
            SELECT @v_dSql1 += '         SELECT A.SCP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID             ' +char(10)
			SELECT @v_dSql1 += '            , A.PLANT_ID, A.MODEL, A.ITEM_ID, A.NICK_NAME, A.ITEM_TYPE            ' +char(10)
            SELECT @v_dSql1 += '            , A.OPERATION_ID, A.FACTORY_ID, A.PRODUCTION_TYPE, A.MARKET           ' +char(10)
            SELECT @v_dSql1 += '            , A.LINE_ID, A.LINE_NAME, A.PLAN_WEEK , A.MFG_WEEK                    ' +char(10)
            SELECT @v_dSql1 += '            , SUM(MFG_QTY) AS SCP_QTY                                             ' +char(10)
            SELECT @v_dSql1 += '         FROM  (                                                                  ' +char(10)
            SELECT @v_dSql1 += '                --SCP DATA + 부가정보                                             ' +char(10)
            SELECT @v_dSql1 += '                SELECT A.SCP_PLAN_ID, A.PLAN_WEEK, A.COMPANY_ID, A.DIVISION_ID             ' +char(10)
			SELECT @v_dSql1 += '                   , A.SITE_ID, A.PLANT_ID, A.MARKET                                       ' +char(10)
			SELECT @v_dSql1 += '                   , ( CASE WHEN A.PRODUCTION_TYPE = ''TEST'' THEN ''S-TEST''              ' +char(10)
			SELECT @v_dSql1 += '                              ELSE A.PRODUCTION_TYPE END) AS PRODUCTION_TYPE               ' +char(10)
            SELECT @v_dSql1 += '                   , B.OPERATION_ID, A.SCP_TARGET_ID, A.LINE_ID, C.LINE_NAME               ' +char(10)
            SELECT @v_dSql1 += '                   , C.FACTORY_ID, A.ITEM_ID, B.APPLIED_MODEL                              ' +char(10)
            SELECT @v_dSql1 += '                   , ISNULL( B.APPLIED_MODEL, B.ITEM_ID ) AS MODEL                         ' +char(10)
            SELECT @v_dSql1 += '                   , ISNULL(B.NICK_NAME, ''-'') AS NICK_NAME, B.LEVEL_3_NAME AS ITEM_TYPE  ' +char(10)
            SELECT @v_dSql1 += '                   , A.MFG_WEEK , A.MFG_QTY                                                ' +char(10)
            SELECT @v_dSql1 += '                FROM   SCP_INFO A                                                          ' +char(10)
            SELECT @v_dSql1 += '                INNER HASH JOIN (                                                          ' +char(10)
            SELECT @v_dSql1 += '                	     SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID            ' +char(10)
			SELECT @v_dSql1 += '                	         , A.ITEM_ID, A.NICK_NAME, B.LEVEL_3_NAME, A.APPLIED_MODEL     ' +char(10)
			SELECT @v_dSql1 += '                	         , SUBSTRING(A.FLOW_ID, 1,5)  AS OPERATION_ID                  ' +char(10)
            SELECT @v_dSql1 += '                	     FROM   SCM_ITEM_M A WITH(NOLOCK), SCM_ITEM_CLASS_M B WITH(NOLOCK) ' +char(10)
            SELECT @v_dSql1 += '                	WHERE  A.ITEM_CLASS  = B.CLASS_ID                                      ' +char(10)
            SELECT @v_dSql1 += '                	AND    A.ACTIVE_FLAG = ''Y''                                           ' +char(10)
            SELECT @v_dSql1 += '                	AND    B.USE_FLAG    = ''Y''                                           ' +char(10)
            SELECT @v_dSql1 += '                ) B                                                                        ' +char(10)
            SELECT @v_dSql1 += '                ON  A.COMPANY_ID  = B.COMPANY_ID                                           ' +char(10)
            SELECT @v_dSql1 += '                AND A.DIVISION_ID = B.DIVISION_ID                                          ' +char(10)
            SELECT @v_dSql1 += '                AND A.SITE_ID     = B.SITE_ID                                              ' +char(10)
            SELECT @v_dSql1 += '                AND A.ITEM_ID     = B.ITEM_ID                                              ' +char(10)
            SELECT @v_dSql1 += '                INNER HASH JOIN (                                                          ' +char(10)
            SELECT @v_dSql1 += '                               SELECT  COMPANY_ID, DIVISION_ID , SITE_ID , PLANT_ID  ' +char(10)
			SELECT @v_dSql1 += '                               , FACTORY_ID , OPERATION_ID , SCP_LINE_ID , LINE_NAME ' +char(10)
            SELECT @v_dSql1 += '                               FROM    SCM_LINE_M A WITH(NOLOCK)                     ' +char(10)
            SELECT @v_dSql1 += '                               WHERE   ACTIVE_FLAG = ''Y''                           ' +char(10)
            SELECT @v_dSql1 += '                               AND     SCP_LINE_ID IS NOT NULL                       ' +char(10)
            SELECT @v_dSql1 += '                ) C                                   ' +char(10)
            SELECT @v_dSql1 += '                ON   A.SITE_ID      =  C.SITE_ID      ' +char(10)
            SELECT @v_dSql1 += '                AND  A.PLANT_ID     =  C.PLANT_ID     ' +char(10)
            SELECT @v_dSql1 += '                AND  A.COMPANY_ID   =  C.COMPANY_ID   ' +char(10)
            SELECT @v_dSql1 += '                AND  A.DIVISION_ID  =  C.DIVISION_ID  ' +char(10)
            SELECT @v_dSql1 += '                AND  A.LINE_ID      =  C.SCP_LINE_ID  ' +char(10)
            SELECT @v_dSql1 += '                AND  A.OPERATION_ID =  C.OPERATION_ID ' +char(10)
            SELECT @v_dSql1 += '                WHERE 1=1                             ' +char(10)
            SELECT @v_dSql1 += '                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))             + char(10)
            SELECT @v_dSql1 += '                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.FACTORY_ID' , 'EQ', @p_factory_id))         + char(10)
            SELECT @v_dSql1 += '                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))     + char(10)
            SELECT @v_dSql1 += '                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))               + char(10)
           
		    IF LEN(@p_model_id) > 0 																			                
                BEGIN																						                
                    SELECT @v_dSql1 += '           AND  ISNULL( B.APPLIED_MODEL, B.ITEM_ID ) LIKE ''%'' + '''+ @p_model_id +''' + ''%''   ' + char(10)
                END	
            IF LEN(@p_item_id) > 0 																			                
                BEGIN																						                
                    SELECT @v_dSql1 += '           AND  A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%''           ' + char(10)
                END	
            IF LEN(@p_nick_name) > 0 																			                
                BEGIN																						                
                    SELECT @v_dSql1 += '           AND  B.NICK_NAME LIKE ''%'' + '''+ @p_nick_name +''' + ''%''       ' + char(10)
                END	

            SELECT @v_dSql1 += '            ) A       ' + char(10)
            SELECT @v_dSql1 += '            WHERE 1=1 ' + char(10)

            IF LEN(@p_model_id) > 0 																			                
                BEGIN																						                
                     SELECT @v_dSql1 += '           AND  A.MODEL LIKE ''%'' + '''+ @p_model_id +''' + ''%''   ' + char(10)
                END	

            SELECT @v_dSql1 += '           '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type))    + char(10)
            SELECT @v_dSql1 += '            GROUP BY A.SCP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.MODEL ' + char(10)
            SELECT @v_dSql1 += '		     , A.ITEM_ID, A.NICK_NAME, A.ITEM_TYPE, A.OPERATION_ID, A.FACTORY_ID                ' + char(10)
            SELECT @v_dSql1 += '			 , A.PRODUCTION_TYPE, A.MARKET, A.LINE_ID, A.LINE_NAME, A.PLAN_WEEK, MFG_WEEK       ' + char(10)
            SELECT @v_dSql1 += '        ) ' + char(10)

			SELECT @v_dSql2  = ''
            SELECT @v_dSql2 += '   , SCP_TARGET AS (                                                             ' + char(10)
            SELECT @v_dSql2 += '         SELECT * FROM SCP_TARGET_RAW                                            ' + char(10)
            SELECT @v_dSql2 += '         UNION ALL                                                               ' + char(10)
            SELECT @v_dSql2 += '         -- PLAN WEEK, MFG_WEEK 주차 강제 생성                                   ' + char(10)
            SELECT @v_dSql2 += '         SELECT DISTINCT A.SCP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID   ' + char(10)
            SELECT @v_dSql2 += '	        , A.PLANT_ID, A.MODEL, A.ITEM_ID, A.NICK_NAME, A.ITEM_TYPE           ' + char(10)
            SELECT @v_dSql2 += '		    , A.OPERATION_ID, A.FACTORY_ID, A.PRODUCTION_TYPE, A.MARKET          ' + char(10)
            SELECT @v_dSql2 += '		    , A.LINE_ID, A.LINE_NAME, B.PLAN_WEEK AS PLAN_WEEK                   ' + char(10)
            SELECT @v_dSql2 += '		    , C.MFG_WEEK AS MFG_WEEK, 0 AS SCP_QTY                               ' + char(10)
            SELECT @v_dSql2 += '         FROM   SCP_TARGET_RAW A,                                                ' + char(10)
            SELECT @v_dSql2 += '	     (                                                                       ' + char(10)
            
			SELECT @v_tmp1 = ''         
            SELECT @max_loop_cnt = 0
            SELECT @mst_loop_cnt = 0
            SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_plan_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			
			IF(LEN(@p_plan_week_info) > 0)
                 BEGIN
                     WHILE @mst_loop_cnt < @max_loop_cnt      
                         BEGIN                                
                             SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                             SELECT @v_plan_week_info   = [dbo].[SCM_ARR_SPL_VAL](@p_plan_week_info ,@v_delimiter, @mst_loop_cnt) 
                             IF @mst_loop_cnt = 1
                                 BEGIN
                                     SELECT @v_tmp1 += '	      SELECT ''' + @v_plan_week_info + '''  AS  PLAN_WEEK ' +char(10)
                                 END
                             ELSE
                                 BEGIN
                                     SELECT @v_tmp1 += '	      UNION ALL ' +char(10)
                                     SELECT @v_tmp1 += '	      SELECT ''' + @v_plan_week_info + '''  AS  PLAN_WEEK ' +char(10)
                                 END
                     	END                                  
                 END

            SELECT @v_dSql2 = @v_dSql2 + @v_tmp1
            SELECT @v_dSql2 += '         ) B,  ' +char(10)
            SELECT @v_dSql2 += '         (     ' +char(10)
			
			SELECT @v_tmp2 = ''         
            SELECT @max_loop_cnt = 0
            SELECT @mst_loop_cnt = 0
            SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			
            IF(LEN(@p_week_info) > 0)
                BEGIN
                    WHILE @mst_loop_cnt < @max_loop_cnt      
                        BEGIN                                
                            SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                            SELECT @v_week_info   = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt) 
                            IF @mst_loop_cnt = 1
                                BEGIN
                                    SELECT @v_tmp2 += '          SELECT ''' + @v_week_info + '''  AS  MFG_WEEK ' +char(10)
                                END
                            ELSE
                                BEGIN
                                    SELECT @v_tmp2 += '          UNION ALL ' +char(10)
                                    SELECT @v_tmp2 += '          SELECT ''' + @v_week_info + '''  AS  MFG_WEEK ' +char(10)
                                END
                        END                                  
                END

            SELECT @v_dSql2 = @v_dSql2+ @v_tmp2

            SELECT @v_dSql2 += '         ) C            ' +char(10)
            SELECT @v_dSql2 += '     )                  ' +char(10)
            SELECT @v_dSql2 += '   -- result            ' +char(10)
            SELECT @v_dSql2 += '   , RESULT_TARGET AS ( ' +char(10)
            SELECT @v_dSql2 += '         SELECT A.*     ' +char(10)
            SELECT @v_dSql2 += '         FROM (         ' +char(10)
            SELECT @v_dSql2 += '               SELECT CAL.ISO_YYYYWW AS PROD_WEEK, A.COMPANY_ID, A.DIVISION_ID ' +char(10)
            SELECT @v_dSql2 += '			    , A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID ' +char(10)
            SELECT @v_dSql2 += '				, A.OPERATION_ID, A.LINE_ID, A.FP_PRODUCTION_TYPE, A.MARKET ' +char(10)
            SELECT @v_dSql2 += '               	, SUM(CEILING(A.ACTUAL_GOOD_QTY)) AS ACTUAL_GOOD_QTY ' +char(10)
            SELECT @v_dSql2 += '               FROM   SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK) ' +char(10)
            SELECT @v_dSql2 += '               INNER HASH JOIN SCM_ITEM_M B WITH(NOLOCK) ' +char(10)
            SELECT @v_dSql2 += '               ON   A.COMPANY_ID  = B.COMPANY_ID ' +char(10)
            SELECT @v_dSql2 += '               AND  A.DIVISION_ID = B.DIVISION_ID ' +char(10)
            SELECT @v_dSql2 += '               AND  A.SITE_ID     = B.SITE_ID ' +char(10)
            SELECT @v_dSql2 += '               AND  A.ITEM_ID     = B.ITEM_ID ' +char(10)
            SELECT @v_dSql2 += '               INNER JOIN TH_UIS_CAL CAL WITH(NOLOCK) ' +char(10)
            SELECT @v_dSql2 += '               ON   CONVERT(DATE, A.PLAN_DATE) = CAL.YYYYMMDD ' +char(10)
            SELECT @v_dSql2 += '               WHERE 1=1 ' +char(10)
            SELECT @v_dSql2 += '               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))             + char(10)
            SELECT @v_dSql2 += '               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))         + char(10)
            SELECT @v_dSql2 += '               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))     + char(10)
            SELECT @v_dSql2 += '               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))               + char(10)
            SELECT @v_dSql2 += '               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type))     + char(10)
            
			IF LEN(@p_item_id) > 0 																			                
                BEGIN																						                
                    SELECT @v_dSql2 += '               AND  A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%''           ' + char(10)
                END	
            IF LEN(@p_nick_name) > 0 																			                
                BEGIN																						                
                    SELECT @v_dSql2 += '               AND  B.NICK_NAME LIKE ''%'' + '''+ @p_nick_name +''' + ''%''       ' + char(10)
                END	
            SELECT @v_dSql2 += '               AND   CAL.YYYYMMDD BETWEEN '''+ @p_bucket_from_date +''' AND '''+ @p_bucket_to_date +'''  ' +char(10)
            SELECT @v_dSql2 += '               GROUP BY CAL.ISO_YYYYWW, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID               ' +char(10)
            SELECT @v_dSql2 += '                  , A.FACTORY_ID, A.ITEM_ID, A.OPERATION_ID, A.LINE_ID   ' +char(10)
            SELECT @v_dSql2 += '                  , A.FP_PRODUCTION_TYPE, A.MARKET                       ' +char(10)
            SELECT @v_dSql2 += '           ) A                                                           ' +char(10)
            SELECT @v_dSql2 += '           WHERE 1=1                                                     ' +char(10)
            SELECT @v_dSql2 += '           AND   EXISTS (                                                ' +char(10)
            SELECT @v_dSql2 += '                         SELECT 1                                        ' +char(10)
            SELECT @v_dSql2 += '                         FROM   SCP_TARGET_RAW B                         ' +char(10)
            SELECT @v_dSql2 += '                         WHERE  1=1                                      ' +char(10)
            SELECT @v_dSql2 += '                         AND    A.COMPANY_ID   = B.COMPANY_ID            ' +char(10)
            SELECT @v_dSql2 += '                         AND    A.DIVISION_ID  = B.DIVISION_ID           ' +char(10)
            SELECT @v_dSql2 += '                         AND    A.SITE_ID      = B.SITE_ID               ' +char(10)
            SELECT @v_dSql2 += '                         AND    A.PLANT_ID     = B.PLANT_ID              ' +char(10)
            SELECT @v_dSql2 += '                         AND    A.OPERATION_ID = B.OPERATION_ID          ' +char(10)
            SELECT @v_dSql2 += '                         AND    A.LINE_ID      = B.LINE_ID               ' +char(10)
            SELECT @v_dSql2 += '                         AND    A.FP_PRODUCTION_TYPE = B.PRODUCTION_TYPE ' +char(10)
            SELECT @v_dSql2 += '                         AND    A.MARKET       = B.MARKET                ' +char(10)
            SELECT @v_dSql2 += '                         AND    A.ITEM_ID      = B.ITEM_ID               ' +char(10)
            SELECT @v_dSql2 += '                        )                                                ' +char(10)
            SELECT @v_dSql2 += '      )                                                                  ' +char(10)
            
			SELECT @v_dSql3  = ''
			SELECT @v_dSql3 += '   -- PP 데이터       ' +char(10)
            SELECT @v_dSql3 += '   , PP_DATA_RAW AS ( ' +char(10)
            SELECT @v_dSql3 += '         SELECT A.*   ' +char(10)
            SELECT @v_dSql3 += '           , B.NICK_NAME, B.LEVEL_3_NAME AS ITEM_TYPE                                              ' +char(10)
            SELECT @v_dSql3 += '           , ISNULL( B.APPLIED_MODEL, B.ITEM_ID ) AS MODEL                                         ' +char(10)
            SELECT @v_dSql3 += '           , C.LINE_NAME                                                                           ' +char(10)
            SELECT @v_dSql3 += '         FROM (                                                                                    ' +char(10)
            SELECT @v_dSql3 += '               -- 당주                                                                             ' +char(10)
            SELECT @v_dSql3 += '               SELECT '''+ @p_curr_week +''' AS PLAN_WEEK, B.ISO_YYYYWW AS MFG_WEEK                ' +char(10)
            SELECT @v_dSql3 += '                   , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID              ' +char(10)
            SELECT @v_dSql3 += '                   , A.OPERATION_ID, A.LINE_ID, A.ITEM_ID, A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE ' +char(10)
            SELECT @v_dSql3 += '				, A.MARKET, SUM(A.PLAN_QTY) AS QTY                                                 ' +char(10)
            SELECT @v_dSql3 += '               FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)                                   ' +char(10)
            SELECT @v_dSql3 += '               INNER HASH JOIN TH_UIS_CAL B WITH(NOLOCK)                                           ' +char(10)
            SELECT @v_dSql3 += '               ON   CONVERT(VARCHAR,A.PLAN_DATE,112) = B.YYYYMMDD                                  ' +char(10)
            SELECT @v_dSql3 += '               WHERE  1=1                                                                          ' +char(10)
            SELECT @v_dSql3 += '               AND   A.PLAN_TYPE = '''+ @p_pp_option +'''                                          ' +char(10)
            SELECT @v_dSql3 += '               AND   CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from_date +''' AND '''+ @p_bucket_to_date +'''    ' +char(10)
            SELECT @v_dSql3 += '                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))             + char(10)
            SELECT @v_dSql3 += '                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))         + char(10)
            SELECT @v_dSql3 += '                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))     + char(10)
            SELECT @v_dSql3 += '                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))               + char(10)
            SELECT @v_dSql3 += '                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type))     + char(10)
            IF LEN(@p_item_id) > 0 																			                
                BEGIN																						                
                       SELECT @v_dSql3 += '                AND  A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%''    ' + char(10)
                END	
            
            SELECT @v_dSql3 += '                AND   B.ISO_YYYYWW >= '''+ @p_curr_week +'''                            ' + char(10)
            SELECT @v_dSql3 += '                GROUP BY B.ISO_YYYYWW, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID           ' + char(10)
            SELECT @v_dSql3 += '                  , A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID                 ' + char(10)
            SELECT @v_dSql3 += '                  , A.ITEM_ID, A.FP_PRODUCTION_TYPE, A.MARKET                           ' + char(10)
            SELECT @v_dSql3 += '                UNION ALL                                                               ' + char(10)
            SELECT @v_dSql3 += '                -- 과거                                                                 ' + char(10)
            SELECT @v_dSql3 += '                SELECT A.YYYYWW AS PLAN_WEEK, B.ISO_YYYYWW AS MFG_WEEK, A.COMPANY_ID    ' + char(10)
            SELECT @v_dSql3 += '                   , A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID ' + char(10)
            SELECT @v_dSql3 += '                   , A.LINE_ID, A.ITEM_ID, A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE      ' + char(10)
            SELECT @v_dSql3 += '                   , A.MARKET, SUM(A.PLAN_QTY) AS QTY                                   ' + char(10)
            SELECT @v_dSql3 += '                FROM   FP_DAILY_PRODUCTION_PLAN_DW_H A WITH(NOLOCK)                     ' + char(10)
            SELECT @v_dSql3 += '                INNER HASH JOIN TH_UIS_CAL B WITH(NOLOCK)                               ' + char(10)
            SELECT @v_dSql3 += '                ON     CONVERT(VARCHAR,A.PLAN_DATE,112) = B.YYYYMMDD                    ' + char(10)
            SELECT @v_dSql3 += '                WHERE  1=1                                                              ' + char(10)
            SELECT @v_dSql3 += '                AND   A.PLAN_TYPE = '''+ @p_pp_option +'''                              ' + char(10)
            SELECT @v_dSql3 += '                AND   CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from_date +''' AND '''+ @p_bucket_to_date +'''    ' +char(10)
            SELECT @v_dSql3 += '                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))             + char(10)
            SELECT @v_dSql3 += '                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))         + char(10)
            SELECT @v_dSql3 += '                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))     + char(10)
            SELECT @v_dSql3 += '                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))               + char(10)
            SELECT @v_dSql3 += '                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type))     + char(10)
           
		    IF LEN(@p_item_id) > 0 																			                
                BEGIN																						                
                       SELECT @v_dSql3 += '                AND  A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%''  ' + char(10)
                END	

            SELECT @v_dSql3 += '                GROUP BY A.YYYYWW, B.ISO_YYYYWW, A.COMPANY_ID, A.DIVISION_ID     ' + char(10)
            SELECT @v_dSql3 += '                   , A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID         ' + char(10)
            SELECT @v_dSql3 += '                   , A.LINE_ID, A.ITEM_ID, A.FP_PRODUCTION_TYPE, A.MARKET        ' + char(10)
            SELECT @v_dSql3 += '          ) A                                                                    ' + char(10)
            SELECT @v_dSql3 += '          INNER HASH JOIN (                                                      ' + char(10)
            SELECT @v_dSql3 += '                      SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID     ' + char(10)
            SELECT @v_dSql3 += '				       , A.ITEM_ID, A.NICK_NAME, B.LEVEL_3_NAME, A.APPLIED_MODEL ' + char(10)
            SELECT @v_dSql3 += '					   , SUBSTRING(A.FLOW_ID, 1,5)  AS OPERATION_ID              ' + char(10)
            SELECT @v_dSql3 += '                      FROM   SCM_ITEM_M A WITH(NOLOCK)                           ' + char(10)
			SELECT @v_dSql3 += '                          , SCM_ITEM_CLASS_M B WITH(NOLOCK)                      ' + char(10)
            SELECT @v_dSql3 += '                      WHERE  A.ITEM_CLASS  = B.CLASS_ID                          ' + char(10)
            SELECT @v_dSql3 += '                      AND    A.ACTIVE_FLAG = ''Y''                               ' + char(10)
            SELECT @v_dSql3 += '                      AND    B.USE_FLAG    = ''Y''                               ' + char(10)
            SELECT @v_dSql3 += '          ) B                                                                    ' + char(10)
            SELECT @v_dSql3 += '          ON  A.COMPANY_ID  = B.COMPANY_ID                                       ' + char(10)
            SELECT @v_dSql3 += '          AND A.DIVISION_ID = B.DIVISION_ID                                      ' + char(10)
            SELECT @v_dSql3 += '          AND A.SITE_ID     = B.SITE_ID                                          ' + char(10)
            SELECT @v_dSql3 += '          AND A.ITEM_ID     = B.ITEM_ID                                          ' + char(10)
            SELECT @v_dSql3 += '          INNER HASH JOIN (                                                      ' + char(10)
            SELECT @v_dSql3 += '                    SELECT  COMPANY_ID, DIVISION_ID , SITE_ID , PLANT_ID         ' + char(10)
            SELECT @v_dSql3 += '				   , FACTORY_ID , OPERATION_ID , SCP_LINE_ID , LINE_NAME         ' + char(10)
            SELECT @v_dSql3 += '                    FROM    SCM_LINE_M A WITH(NOLOCK)                            ' + char(10)
            SELECT @v_dSql3 += '                    WHERE   ACTIVE_FLAG = ''Y''                                  ' + char(10)
            SELECT @v_dSql3 += '                    AND     SCP_LINE_ID IS NOT NULL                              ' + char(10)
            SELECT @v_dSql3 += '          ) C                                                                    ' + char(10)
            SELECT @v_dSql3 += '          ON   A.SITE_ID      =  C.SITE_ID                                       ' + char(10)
            SELECT @v_dSql3 += '          AND  A.PLANT_ID     =  C.PLANT_ID                                      ' + char(10)
            SELECT @v_dSql3 += '          AND  A.COMPANY_ID   =  C.COMPANY_ID                                    ' + char(10)
            SELECT @v_dSql3 += '          AND  A.DIVISION_ID  =  C.DIVISION_ID                                   ' + char(10)
            SELECT @v_dSql3 += '          AND  A.LINE_ID      =  C.SCP_LINE_ID                                   ' + char(10)
            SELECT @v_dSql3 += '          AND  A.OPERATION_ID =  C.OPERATION_ID                                  ' + char(10)
            SELECT @v_dSql3 += '          WHERE 1=1                                                              ' + char(10)
            
			IF LEN(@p_model_id) > 0 																			                
                BEGIN																						                
                    SELECT @v_dSql3 += '          AND  ISNULL( B.APPLIED_MODEL, B.ITEM_ID ) LIKE ''%'' + '''+ @p_model_id +''' + ''%'' ' + char(10)
                END	
            IF LEN(@p_item_id) > 0 																			                
                BEGIN																						                
                    SELECT @v_dSql3 += '          AND  A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%''     ' + char(10)
                END	
            IF LEN(@p_nick_name) > 0 																			          
                BEGIN																						          
                    SELECT @v_dSql3 += '          AND  B.NICK_NAME LIKE ''%'' + '''+ @p_nick_name +''' + ''%'' ' + char(10)
                END	
            SELECT @v_dSql3 += '      )                                                                         ' + char(10)
			
			SELECT @v_dSql4 = ''
            SELECT @v_dSql4 += '   , PP_DATA AS (                                                             ' + char(10)
            SELECT @v_dSql4 += '         SELECT *                                                             ' + char(10)
            SELECT @v_dSql4 += '         FROM   PP_DATA_RAW A WITH(NOLOCK)                                    ' + char(10)
            SELECT @v_dSql4 += '         -- PLAN WEEK, MFG_WEEK 주차 강제 생성                                ' + char(10)
            SELECT @v_dSql4 += '         UNION ALL                                                            ' + char(10)
            SELECT @v_dSql4 += '         SELECT DISTINCT B.PLAN_WEEK, C.MFG_WEEK, A.COMPANY_ID, A.DIVISION_ID ' + char(10)
            SELECT @v_dSql4 += '            , A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID  ' + char(10)
            SELECT @v_dSql4 += '            , A.ITEM_ID, A.PRODUCTION_TYPE, A.MARKET, 0 AS QTY, A.NICK_NAME   ' + char(10) 
            SELECT @v_dSql4 += '            , A.ITEM_TYPE, A.MODEL, A.LINE_NAME                               ' + char(10)
            SELECT @v_dSql4 += '         FROM   PP_DATA_RAW A WITH(NOLOCK)                                    ' + char(10)
            SELECT @v_dSql4 += '	     ,(                                                                   ' + char(10)

			SELECT @v_tmp1 = ''         
            SELECT @max_loop_cnt = 0
            SELECT @mst_loop_cnt = 0
            SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_plan_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
           
			IF(LEN(@p_plan_week_info) > 0)
                 BEGIN
                  WHILE @mst_loop_cnt < @max_loop_cnt      
                         BEGIN                                
                            SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                            SELECT @v_plan_week_info   = [dbo].[SCM_ARR_SPL_VAL](@p_plan_week_info ,@v_delimiter, @mst_loop_cnt) 
                         IF @mst_loop_cnt = 1
                             BEGIN
                                 SELECT @v_tmp1 += '                SELECT ''' + @v_plan_week_info + '''  AS  PLAN_WEEK ' +char(10)
                             END
                         ELSE
                             BEGIN
                                 SELECT @v_tmp1 += '                UNION ALL ' +char(10)
                                 SELECT @v_tmp1 += '                SELECT ''' + @v_plan_week_info + '''  AS  PLAN_WEEK ' +char(10)
                             END
                      END                                  
                 END

            SELECT @v_dSql4 = @v_dSql4 + @v_tmp1

            SELECT @v_dSql4 += '         ) B,  ' + char(10)
            SELECT @v_dSql4 += '         (     ' + char(10)

			SELECT @v_tmp1 = ''         
            SELECT @max_loop_cnt = 0
            SELECT @mst_loop_cnt = 0
            SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단

            IF(LEN(@p_week_info) > 0)
                 BEGIN
                     WHILE @mst_loop_cnt < @max_loop_cnt      
                         BEGIN                                
                             SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                             SELECT @v_week_info  = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt) 
                             IF @mst_loop_cnt = 1
                                 BEGIN
                                     SELECT @v_tmp1 += '                SELECT ''' + @v_week_info + '''  AS  MFG_WEEK ' +char(10)
                                 END
                             ELSE
                                 BEGIN
                                     SELECT @v_tmp1 += '                UNION ALL ' +char(10)
                                     SELECT @v_tmp1 += '                SELECT ''' + @v_week_info + '''  AS  MFG_WEEK ' +char(10)
                                 END
                             END                                  
                 END

            SELECT @v_dSql4 = @v_dSql4 + @v_tmp1

            SELECT @v_dSql4 += '         ) C        ' + char(10)
            SELECT @v_dSql4 += '     )              ' + char(10)

            SELECT @v_dSql4 += '   , MAIN AS (      ' + char(10)
            SELECT @v_dSql4 += '         SELECT A.* ' + char(10)

            SELECT @v_tmp1 = ''         
            SELECT @max_loop_cnt = 0
            SELECT @mst_loop_cnt = 0
            SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_month_column_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단

            IF(LEN(@p_month_column_info) > 0)
                BEGIN
                    WHILE @mst_loop_cnt < @max_loop_cnt      
                        BEGIN                                
                            SELECT @mst_loop_cnt          = @mst_loop_cnt + 1
                            SELECT @v_month_week_column   = [dbo].[SCM_ARR_SPL_VAL](@p_month_week_column ,@v_delimiter, @mst_loop_cnt) 
                            SELECT @v_month_column_info   = [dbo].[SCM_ARR_SPL_VAL](@p_month_column_info ,@v_delimiter, @mst_loop_cnt) 
                             
                            SELECT @v_tmp1 += '              , ' + @v_month_week_column + '  AS ' + @v_month_column_info + ' ' +char(10)
                        END                                  
                END



            SELECT @v_dSql4 = @v_dSql4 + @v_tmp1

            SELECT @v_dSql4 += '             , ''DATA'' AS DATA_TYPE                                                        ' +char(10)
            SELECT @v_dSql4 += '         FROM (                                                                             ' +char(10)
            SELECT @v_dSql4 += '               -- R+P  * 과거구간 = PLAN_WEEK > MFG_WEEK, * 미래구간 = 과거구간 이외        ' +char(10)
            SELECT @v_dSql4 += '               SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID      ' +char(10)
            SELECT @v_dSql4 += '                   , A.OPERATION_ID, A.LINE_ID, A.LINE_NAME, A.PRODUCTION_TYPE              ' +char(10)
            SELECT @v_dSql4 += '                   , A.MARKET, A.MODEL, A.ITEM_ID, A.NICK_NAME, A.ITEM_TYPE                 ' +char(10)
            SELECT @v_dSql4 += '                   , ''R_P'' AS CATEGORY_ID, ''R+P'' AS CATEGORY_NAME, 10 AS CATEGORY_ORDER ' +char(10)
            SELECT @v_dSql4 += '                   , B.PLAN_WEEK, B.PLAN_WEEK_NAME, B.PLAN_WEEK_ORDER                       ' +char(10)
            SELECT @v_dSql4 += '                   -- PLAN_WEEK : 행, MFG_WEEK : 열                                         ' +char(10)

            SELECT @v_tmp1 = ''         
            SELECT @max_loop_cnt = 0
            SELECT @mst_loop_cnt = 0
            SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단

			IF(LEN(@p_week_info) > 0)
                BEGIN
                    WHILE @mst_loop_cnt < @max_loop_cnt      
                        BEGIN                                
                            SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                            SELECT @v_week_info   = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt) 
                            SELECT @v_tmp1 += '                   , MAX( CASE  ' +char(10)
                            
                            SELECT @max_loop_cnt2 = 0
                            SELECT @mst_loop_cnt2 = 0
                            SELECT @max_loop_cnt2 = [dbo].[SCM_ARR_SPL_CNT](@p_plan_week_Info, @v_delimiter) -- 프로시저 LOOP 길이를 판단

                            WHILE @mst_loop_cnt2 < @max_loop_cnt2
                                BEGIN
                                    SELECT @mst_loop_cnt2    = @mst_loop_cnt2 + 1
                                    SELECT @v_plan_week_Info = [dbo].[SCM_ARR_SPL_VAL](@p_plan_week_Info ,@v_delimiter, @mst_loop_cnt2) 
                                    SELECT @v_tmp1 += '                         WHEN B.PLAN_WEEK = ''' + @v_plan_week_Info + ''' THEN ( CASE WHEN A.MFG_WEEK = ''' + @v_week_info + ''' THEN ( CASE WHEN B.PLAN_WEEK > A.MFG_WEEK THEN ( CASE WHEN C.PROD_WEEK = A.MFG_WEEK THEN C.ACTUAL_GOOD_QTY ELSE 0 END )  ELSE A.SCP_QTY END ) ELSE 0 END ) ' +char(10)
								END

                            SELECT @v_tmp1 += '                         ELSE 0 END ) AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' +char(10)
                        END                                  
                END


			SELECT @v_dSql4 = @v_dSql4 + @v_tmp1

            SELECT @v_dSql4 += '               FROM   SCP_TARGET A ' +char(10)
            SELECT @v_dSql4 += '               INNER HASH JOIN (   ' +char(10)

            SELECT @v_tmp1       = ''         
            SELECT @max_loop_cnt = 0
            SELECT @mst_loop_cnt = 0
            SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_plan_week_Info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
            
			IF(LEN(@p_plan_week_Info) > 0)
                BEGIN
                    WHILE @mst_loop_cnt < @max_loop_cnt      
                        BEGIN                                
                            SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                            SELECT @v_plan_week_Info   = [dbo].[SCM_ARR_SPL_VAL](@p_plan_week_Info ,@v_delimiter, @mst_loop_cnt) 
                            IF( @mst_loop_cnt = 1)
                                BEGIN
                                    SELECT @v_tmp1 += '                     SELECT ''' + @v_plan_week_Info + ''' AS  PLAN_WEEK, ''' + @v_plan_week_Info + ''' AS  PLAN_WEEK_NAME, '+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' AS PLAN_WEEK_ORDER ' + char(10)
                                END
                            ELSE
                                BEGIN
                                    SELECT @v_tmp1 += '                     UNION ALL ' +char(10)
                                    SELECT @v_tmp1 += '                     SELECT ''' + @v_plan_week_Info + ''' AS  PLAN_WEEK, ''' + @v_plan_week_Info + ''' AS  PLAN_WEEK_NAME, '+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' AS PLAN_WEEK_ORDER ' + char(10)
                                END
                        END                                  
                END

			SELECT @v_dSql4 = @v_dSql4 + @v_tmp1

            SELECT @v_dSql4 += '               ) B                                           ' +char(10)
            SELECT @v_dSql4 += '               ON A.PLAN_WEEK = B.PLAN_WEEK                  ' +char(10)
            SELECT @v_dSql4 += '               LEFT OUTER HASH JOIN RESULT_TARGET C          ' +char(10)
            SELECT @v_dSql4 += '               ON  A.COMPANY_ID      = C.COMPANY_ID          ' +char(10)
            SELECT @v_dSql4 += '               AND A.DIVISION_ID     = C.DIVISION_ID         ' +char(10)
            SELECT @v_dSql4 += '               AND A.SITE_ID         = C.SITE_ID             ' +char(10)
            SELECT @v_dSql4 += '               AND A.PLANT_ID        = C.PLANT_ID            ' +char(10)
            SELECT @v_dSql4 += '               AND A.FACTORY_ID      = C.FACTORY_ID          ' +char(10)
            SELECT @v_dSql4 += '               AND A.OPERATION_ID    = C.OPERATION_ID        ' +char(10)
            SELECT @v_dSql4 += '               AND A.LINE_ID         = C.LINE_ID             ' +char(10)
            SELECT @v_dSql4 += '               AND A.PRODUCTION_TYPE = C.FP_PRODUCTION_TYPE  ' +char(10)
            SELECT @v_dSql4 += '               AND A.MARKET          = C.MARKET              ' +char(10)
            SELECT @v_dSql4 += '               AND A.ITEM_ID         = C.ITEM_ID             ' +char(10)
            SELECT @v_dSql4 += '               GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' +char(10)
            SELECT @v_dSql4 += '                  , A.OPERATION_ID, A.LINE_ID, A.LINE_NAME, A.PRODUCTION_TYPE            ' +char(10)
            SELECT @v_dSql4 += '                  , A.MARKET, A.MODEL, A.ITEM_ID, A.NICK_NAME, A.ITEM_TYPE               ' +char(10)
            SELECT @v_dSql4 += '                  , B.PLAN_WEEK, B.PLAN_WEEK_NAME, B.PLAN_WEEK_ORDER                     ' +char(10)
            SELECT @v_dSql4 += '                 -- P+P                                                   ' +char(10)
            SELECT @v_dSql4 += '               UNION ALL                                                  ' +char(10)
            SELECT @v_dSql4 += '               SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID  ' +char(10)
            SELECT @v_dSql4 += '                   , A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.LINE_NAME ' +char(10)
            SELECT @v_dSql4 += '                   , A.PRODUCTION_TYPE, A.MARKET, A.MODEL, A.ITEM_ID      ' +char(10)
            SELECT @v_dSql4 += '                   , A.NICK_NAME, A.ITEM_TYPE, ''PP_FP'' AS CATEGORY_ID   ' +char(10)
            SELECT @v_dSql4 += '                   , ''P+P_FP'' AS CATEGORY_NAME, 20 AS CATEGORY_ORDER    ' +char(10)
            SELECT @v_dSql4 += '                   , B.PLAN_WEEK, B.PLAN_WEEK_NAME, B.PLAN_WEEK_ORDER     ' +char(10)
            SELECT @v_dSql4 += '                   -- PLAN_WEEK : 행, MFG_WEEK : 열                       ' +char(10)

            SELECT @v_tmp1 = ''         
            SELECT @max_loop_cnt = 0
            SELECT @mst_loop_cnt = 0
            SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
            
            
			IF(LEN(@p_week_info) > 0)
                BEGIN
                    WHILE @mst_loop_cnt < @max_loop_cnt      
                        BEGIN                                
                            SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                            SELECT @v_week_info   = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt) 
                            SELECT @v_tmp1 += '                   , MAX( CASE  ' +char(10)
                            
                            SELECT @max_loop_cnt2 = 0
                            SELECT @mst_loop_cnt2 = 0
                            SELECT @max_loop_cnt2 = [dbo].[SCM_ARR_SPL_CNT](@p_plan_week_Info, @v_delimiter) -- 프로시저 LOOP 길이를 판단

                            WHILE @mst_loop_cnt2 < @max_loop_cnt2
                                BEGIN
                                    SELECT @mst_loop_cnt2    = @mst_loop_cnt2 + 1
                                    SELECT @v_plan_week_Info = [dbo].[SCM_ARR_SPL_VAL](@p_plan_week_Info ,@v_delimiter, @mst_loop_cnt2) 
                                    SELECT @v_tmp1 += '                       WHEN B.PLAN_WEEK = ''' + @v_plan_week_Info + ''' THEN ( CASE WHEN A.MFG_WEEK = ''' + @v_week_info + ''' THEN  A.QTY ELSE 0 END ) ' +char(10)
								END

                            SELECT @v_tmp1 += '                            ELSE 0 END ) AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' +char(10)
                        END                                  
                END
            
            SELECT @v_dSql4  = @v_dSql4 + @v_tmp1
            SELECT @v_dSql4 += '               FROM   PP_DATA A  ' +char(10)
            SELECT @v_dSql4 += '               INNER HASH JOIN ( ' +char(10)                         
            
			SELECT @v_tmp1 = ''         
            SELECT @max_loop_cnt = 0
            SELECT @mst_loop_cnt = 0
            SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_plan_week_Info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
            
			IF(LEN(@p_plan_week_Info) > 0)
                BEGIN
                    WHILE @mst_loop_cnt < @max_loop_cnt      
                        BEGIN                                
                            SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                            SELECT @v_plan_week_Info   = [dbo].[SCM_ARR_SPL_VAL](@p_plan_week_Info ,@v_delimiter, @mst_loop_cnt) 
                            IF( @mst_loop_cnt = 1)
                                BEGIN
                                    SELECT @v_tmp1 += '                     SELECT  ''' + @v_plan_week_Info + '''  AS  PLAN_WEEK, ''' + @v_plan_week_Info + '''  AS  PLAN_WEEK_NAME, '+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' AS PLAN_WEEK_ORDER ' +char(10)
                                END
                            ELSE
                                BEGIN
                                    SELECT @v_tmp1 += '                     UNION ALL ' +char(10)
                                    SELECT @v_tmp1 += '                     SELECT  ''' + @v_plan_week_Info + '''  AS  PLAN_WEEK, ''' + @v_plan_week_Info + '''  AS  PLAN_WEEK_NAME, '+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' AS PLAN_WEEK_ORDER ' +char(10)
                                END
                        END                                  
                END

            SELECT @v_dSql4  = @v_dSql4 + @v_tmp1
            SELECT @v_dSql4 += '               ) B                                                           ' +char(10)
            SELECT @v_dSql4 += '               ON A.PLAN_WEEK = B.PLAN_WEEK                                  ' +char(10)
            SELECT @v_dSql4 += '               GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID   ' +char(10)
            SELECT @v_dSql4 += '                   , A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.LINE_NAME    ' +char(10)
            SELECT @v_dSql4 += '                   , A.PRODUCTION_TYPE, A.MARKET, A.MODEL, A.ITEM_ID         ' +char(10)
            SELECT @v_dSql4 += '                   , A.NICK_NAME, A.ITEM_TYPE, B.PLAN_WEEK, B.PLAN_WEEK_NAME ' +char(10)
            SELECT @v_dSql4 += '                   , B.PLAN_WEEK_ORDER                                       ' +char(10)
            SELECT @v_dSql4 += '           ) A                                                               ' +char(10)
            SELECT @v_dSql4 += '       )                                                                     ' +char(10)

			SELECT @v_dSql5 = ''
            SELECT @v_dSql5 += '   SELECT A.*                                                                          ' +char(10)
            SELECT @v_dSql5 += '       , (CASE WHEN A.CATEGORY_ID = ''R_P'' THEN ''R_P''                               ' +char(10)
            SELECT @v_dSql5 += '               WHEN A.CATEGORY_ID = ''PP_FP'' THEN ''PP_FP'' + ''_'' + ( CASE          ' +char(10)
            SELECT @v_dSql5 += '			           WHEN ''' + @p_pp_option + ''' = ''RELEASE'' THEN ''DPP''        ' +char(10)
            SELECT @v_dSql5 += '					   ELSE ''' + @p_pp_option + ''' END  )                            ' +char(10)
            SELECT @v_dSql5 += '               ELSE A.CATEGORY_ID END) AS CATEGORY_DETAIL_ID -- memo 용 category id    ' +char(10)
            SELECT @v_dSql5 += '     FROM (                                                                            ' +char(10)
            SELECT @v_dSql5 += '           SELECT A.*                                                                  ' +char(10)
            SELECT @v_dSql5 += '           FROM   MAIN A                                                               ' +char(10)
            SELECT @v_dSql5 += '           UNION ALL                                                                   ' +char(10)
            SELECT @v_dSql5 += '           SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID     ' +char(10)
            SELECT @v_dSql5 += '               , A.OPERATION_ID, NULL AS LINE_ID, NULL AS LINE_NAME, A.PRODUCTION_TYPE ' +char(10)
            SELECT @v_dSql5 += '               , A.MARKET, A.MODEL, A.ITEM_ID, A.NICK_NAME, A.ITEM_TYPE, A.CATEGORY_ID ' +char(10)
            SELECT @v_dSql5 += '			, A.CATEGORY_NAME, A.CATEGORY_ORDER, A.PLAN_WEEK, A.PLAN_WEEK_NAME         ' +char(10)
            SELECT @v_dSql5 += '			, A.PLAN_WEEK_ORDER                                                        ' +char(10)

            SELECT @v_tmp1 = ''         
            SELECT @max_loop_cnt = 0
            SELECT @mst_loop_cnt = 0
            SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단

            IF(LEN(@p_week_info) > 0)
                BEGIN
                    WHILE @mst_loop_cnt < @max_loop_cnt      
                        BEGIN                                
                            SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                            SELECT @v_tmp1 += '				, SUM ( W'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +') AS W'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +' ' +char(10)
                        END                                  
                END

            SELECT @v_dSql5  = @v_dSql5 + @v_tmp1

            SELECT @v_tmp1 = ''         
            SELECT @max_loop_cnt = 0
            SELECT @mst_loop_cnt = 0
            SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_month_column_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
            
			IF(LEN(@p_month_column_info) > 0)
                 BEGIN
                   WHILE @mst_loop_cnt < @max_loop_cnt      
                         BEGIN                                
                            SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                            SELECT @v_tmp1 += '				, SUM ( M'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +') AS M'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +' ' +char(10)
            
                       END                                  
                 END
            SELECT @v_dSql5  = @v_dSql5 + @v_tmp1

            SELECT @v_dSql5 += '               , ''TOTAL'' AS DATA_TYPE                                                          ' +char(10)
            SELECT @v_dSql5 += '           FROM   MAIN A                                                                         ' +char(10)
            SELECT @v_dSql5 += '           WHERE  1=(CASE WHEN ''' + @p_chk_total_include +''' = ''Y'' THEN 1 ELSE 0 END)        ' +char(10)
            SELECT @v_dSql5 += '           GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID             ' +char(10)
            SELECT @v_dSql5 += '               , A.OPERATION_ID, A.PRODUCTION_TYPE, A.MARKET, A.MODEL, A.ITEM_ID                 ' +char(10)
            SELECT @v_dSql5 += '               , A.NICK_NAME, A.ITEM_TYPE, A.CATEGORY_ID, A.CATEGORY_NAME, A.CATEGORY_ORDER      ' +char(10)
            SELECT @v_dSql5 += '               , A.PLAN_WEEK, A.PLAN_WEEK_NAME, A.PLAN_WEEK_ORDER, A.DATA_TYPE                   ' +char(10)
            SELECT @v_dSql5 += '       ) A                                                                                       ' +char(10)
            SELECT @v_dSql5 += '       ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.MODEL                      ' +char(10)
            SELECT @v_dSql5 += '          , A.ITEM_ID, A.OPERATION_ID DESC, A.FACTORY_ID, A.PRODUCTION_TYPE, A.MARKET            ' +char(10)
            SELECT @v_dSql5 += '          , (CASE WHEN DATA_TYPE = ''DATA'' THEN 1 WHEN DATA_TYPE = ''TOTAL'' THEN 2 ELSE 0 END) ' +char(10)
            SELECT @v_dSql5 += '          , A.LINE_ID, A.CATEGORY_ORDER, A.PLAN_WEEK_ORDER                                       ' +char(10)


		    SELECT @v_dSql = @v_dSql1 + @v_dSql2 + @v_dSql3 + @v_dSql4 + @v_dSql5

		    IF @p_sys_type = 'SQL'
		  	    BEGIN
		  	    	 EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
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
        END	--IF( END )

	/************************************************************************************************/
	/* SELECT인경우 :SELECT(MEMO_DOWN)                                                                      */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='SELECT_MEMO_DOWN_POPUP')
	    BEGIN
		    SELECT @v_dSql1  = ''
            SELECT @v_dSql1 += ' -- scp target master ' +char(10)
            SELECT @v_dSql1 += ' WITH SCP_INFO AS (                                                               ' +char(10)
            SELECT @v_dSql1 += '         SELECT  A.*, AA.PLAN_WEEK                                                ' +char(10)
            SELECT @v_dSql1 += '         FROM    FP_WEEKLY_DEMAND_PRODUCT_H A WITH(NOLOCK)                        ' +char(10)
            SELECT @v_dSql1 += '         INNER HASH JOIN (                                                        ' +char(10)
            SELECT @v_dSql1 += '			                SELECT DISTINCT C.SEGMENT5 AS DIVISION_ID, C.SEGMENT2 AS SITE_ID' +char(10)
            SELECT @v_dSql1 += '                              , C.SEGMENT3 AS SHOP_GROUP_ID                       ' +char(10)
            SELECT @v_dSql1 += '				            FROM   SCM_SYS_LOOKUP_VALUE C WITH(NOLOCK)            ' +char(10)
            SELECT @v_dSql1 += '                            WHERE  C.LOOKUP_TYPE_CODE = ''TARGET_INSTANCE''       ' +char(10) 
            SELECT @v_dSql1 += '                            AND    C.SEGMENT1         = ''SCP TARGET''            ' +char(10)
            SELECT @v_dSql1 += '                            AND    C.ACTIVE_FLAG      = ''Y''                     ' +char(10)
            SELECT @v_dSql1 += '				            AND    C.SEGMENT4         = '''+ @p_instance_id +'''  ' +char(10)
            SELECT @v_dSql1 += '                         ) I                                                      ' +char(10)
            SELECT @v_dSql1 += '          ON    A.DIVISION_ID   = I.DIVISION_ID                                   ' +char(10)
            SELECT @v_dSql1 += '          AND   A.SITE_ID       = I.SITE_ID                                       ' +char(10)
            SELECT @v_dSql1 += '          AND   A.SHOP_GROUP_ID = I.SHOP_GROUP_ID                                 ' +char(10)
            SELECT @v_dSql1 += '          -- 조회할 SCP PLAN ID 리스트                                            ' +char(10)
            SELECT @v_dSql1 += '          INNER JOIN (                                                            ' +char(10)
            SELECT @v_dSql1 += '          SELECT A.*                                                              ' +char(10)
            SELECT @v_dSql1 += '          FROM (                                                                  ' +char(10)
			SELECT @v_dSql1 += '                SELECT A.PLAN_WEEK, A.COMPANY_ID, A.DIVISION_ID                   ' +char(10)
            SELECT @v_dSql1 += '                    , A.SITE_ID, A.PLANT_ID, A.SCP_PLAN_ID                        ' +char(10)
            SELECT @v_dSql1 += '                    , DENSE_RANK() OVER( PARTITION BY A.PLAN_WEEK                 ' +char(10)
            SELECT @v_dSql1 += '                             , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' +char(10)
            SELECT @v_dSql1 += '                          ORDER BY     A.SCP_PLAN_ID DESC ) AS RNK                ' +char(10)
            SELECT @v_dSql1 += '                FROM (                                                            ' +char(10)
            SELECT @v_dSql1 += '                      SELECT DISTINCT CAL.ISO_YYYYWW AS PLAN_WEEK, A.COMPANY_ID   ' +char(10)
            SELECT @v_dSql1 += '                          , A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.SCP_PLAN_ID   ' +char(10)
            SELECT @v_dSql1 += '                      FROM   FP_WEEKLY_DEMAND_PRODUCT_H A WITH(NOLOCK)            ' +char(10)
            SELECT @v_dSql1 += '                      INNER JOIN  TH_UIS_CAL CAL WITH(NOLOCK)                     ' +char(10)
            SELECT @v_dSql1 += '                      ON   SUBSTRING(A.SCP_PLAN_ID, 1, 8) = CAL.YYYYMMDD          ' +char(10)
            SELECT @v_dSql1 += '                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))             + char(10)
            SELECT @v_dSql1 += '                      AND  CAL.ISO_YYYYWW BETWEEN '''+ @p_plan_from_week +''' AND '''+ @p_plan_to_week +'''  ' +char(10)
            SELECT @v_dSql1 += '                     ) A                                                               ' +char(10)
            SELECT @v_dSql1 += '                ) A                                                                    ' +char(10)
            SELECT @v_dSql1 += '                WHERE A.RNK = 1                                                        ' +char(10)
            SELECT @v_dSql1 += '          ) AA                                                                         ' +char(10)
			SELECT @v_dSql1 += '          ON  1=1                                                                      ' +char(10)
			SELECT @v_dSql1 += '          AND A.COMPANY_ID  =  AA.COMPANY_ID                                           ' +char(10)
			SELECT @v_dSql1 += '          AND A.DIVISION_ID =  AA.DIVISION_ID                                          ' +char(10)
			SELECT @v_dSql1 += '          AND A.SITE_ID     =  AA.SITE_ID                                              ' +char(10)
			SELECT @v_dSql1 += '          AND A.PLANT_ID    =  AA.PLANT_ID                                             ' +char(10)
			SELECT @v_dSql1 += '          AND A.SCP_PLAN_ID =  AA.SCP_PLAN_ID                                          ' +char(10)
			SELECT @v_dSql1 += '          WHERE 1=1                                                                               ' +char(10)
			SELECT @v_dSql1 += '          AND   A.MFG_WEEK BETWEEN '''+ @p_bucket_from_week +''' AND '''+ @p_bucket_to_week +'''  ' +char(10)
			SELECT @v_dSql1 += '         '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))               + char(10)
			SELECT @v_dSql1 += '   )                                                                                       ' +char(10)
            SELECT @v_dSql1 += '   -- scp target detail                                                                    ' +char(10)
            SELECT @v_dSql1 += '   , SCP_TARGET_RAW AS (                                                                   ' +char(10)
            SELECT @v_dSql1 += '         SELECT A.SCP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID                      ' +char(10)
			SELECT @v_dSql1 += '            , A.PLANT_ID, A.MODEL, A.ITEM_ID, A.NICK_NAME, A.ITEM_TYPE                     ' +char(10)
            SELECT @v_dSql1 += '            , A.OPERATION_ID, A.FACTORY_ID, A.PRODUCTION_TYPE, A.MARKET                    ' +char(10)
            SELECT @v_dSql1 += '            , A.LINE_ID, A.LINE_NAME, A.PLAN_WEEK , A.MFG_WEEK                             ' +char(10)
            SELECT @v_dSql1 += '            , SUM(MFG_QTY) AS SCP_QTY                                                      ' +char(10)
            SELECT @v_dSql1 += '         FROM  (                                                                           ' +char(10)
            SELECT @v_dSql1 += '                --SCP DATA + 부가정보                                                      ' +char(10)
            SELECT @v_dSql1 += '                SELECT A.SCP_PLAN_ID, A.PLAN_WEEK, A.COMPANY_ID, A.DIVISION_ID             ' +char(10)
			SELECT @v_dSql1 += '                   , A.SITE_ID, A.PLANT_ID, A.MARKET                                       ' +char(10)
			SELECT @v_dSql1 += '                   , ( CASE WHEN A.PRODUCTION_TYPE = ''TEST'' THEN ''S-TEST''              ' +char(10)
			SELECT @v_dSql1 += '                              ELSE A.PRODUCTION_TYPE END) AS PRODUCTION_TYPE               ' +char(10)
            SELECT @v_dSql1 += '                   , B.OPERATION_ID, A.SCP_TARGET_ID, A.LINE_ID, C.LINE_NAME               ' +char(10)
            SELECT @v_dSql1 += '                   , C.FACTORY_ID, A.ITEM_ID, B.APPLIED_MODEL                              ' +char(10)
            SELECT @v_dSql1 += '                   , ISNULL( B.APPLIED_MODEL, B.ITEM_ID ) AS MODEL                         ' +char(10)
            SELECT @v_dSql1 += '                   , ISNULL(B.NICK_NAME, ''-'') AS NICK_NAME, B.LEVEL_3_NAME AS ITEM_TYPE  ' +char(10)
            SELECT @v_dSql1 += '                   , A.MFG_WEEK , A.MFG_QTY                                                ' +char(10)
            SELECT @v_dSql1 += '                FROM   SCP_INFO A                                                          ' +char(10)
            SELECT @v_dSql1 += '                INNER HASH JOIN (                                                          ' +char(10)
            SELECT @v_dSql1 += '                	     SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID            ' +char(10)
			SELECT @v_dSql1 += '                	         , A.ITEM_ID, A.NICK_NAME, B.LEVEL_3_NAME, A.APPLIED_MODEL     ' +char(10)
			SELECT @v_dSql1 += '                	         , SUBSTRING(A.FLOW_ID, 1,5)  AS OPERATION_ID                  ' +char(10)
            SELECT @v_dSql1 += '                	     FROM   SCM_ITEM_M A WITH(NOLOCK), SCM_ITEM_CLASS_M B WITH(NOLOCK) ' +char(10)
            SELECT @v_dSql1 += '                	WHERE  A.ITEM_CLASS  = B.CLASS_ID                                      ' +char(10)
            SELECT @v_dSql1 += '                	AND    A.ACTIVE_FLAG = ''Y''                                           ' +char(10)
            SELECT @v_dSql1 += '                	AND    B.USE_FLAG    = ''Y''                                           ' +char(10)
            SELECT @v_dSql1 += '                ) B                                                                        ' +char(10)
            SELECT @v_dSql1 += '                ON  A.COMPANY_ID  = B.COMPANY_ID                                           ' +char(10)
            SELECT @v_dSql1 += '                AND A.DIVISION_ID = B.DIVISION_ID                                          ' +char(10)
            SELECT @v_dSql1 += '                AND A.SITE_ID     = B.SITE_ID                                              ' +char(10)
            SELECT @v_dSql1 += '                AND A.ITEM_ID     = B.ITEM_ID                                              ' +char(10)
            SELECT @v_dSql1 += '                INNER HASH JOIN (                                                          ' +char(10)
            SELECT @v_dSql1 += '                               SELECT  COMPANY_ID, DIVISION_ID , SITE_ID , PLANT_ID        ' +char(10)
			SELECT @v_dSql1 += '                               , FACTORY_ID , OPERATION_ID , SCP_LINE_ID , LINE_NAME       ' +char(10)
            SELECT @v_dSql1 += '                               FROM    SCM_LINE_M A WITH(NOLOCK)                           ' +char(10)
            SELECT @v_dSql1 += '                               WHERE   ACTIVE_FLAG = ''Y''                                 ' +char(10)
            SELECT @v_dSql1 += '                               AND     SCP_LINE_ID IS NOT NULL                             ' +char(10)
            SELECT @v_dSql1 += '                ) C                                   ' +char(10)
            SELECT @v_dSql1 += '                ON   A.SITE_ID      =  C.SITE_ID      ' +char(10)
            SELECT @v_dSql1 += '                AND  A.PLANT_ID     =  C.PLANT_ID     ' +char(10)
            SELECT @v_dSql1 += '                AND  A.COMPANY_ID   =  C.COMPANY_ID   ' +char(10)
            SELECT @v_dSql1 += '                AND  A.DIVISION_ID  =  C.DIVISION_ID  ' +char(10)
            SELECT @v_dSql1 += '                AND  A.LINE_ID      =  C.SCP_LINE_ID  ' +char(10)
            SELECT @v_dSql1 += '                AND  A.OPERATION_ID =  C.OPERATION_ID ' +char(10)
            SELECT @v_dSql1 += '                WHERE 1=1                             ' +char(10)
            SELECT @v_dSql1 += '                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))             + char(10)
            SELECT @v_dSql1 += '                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.FACTORY_ID' , 'EQ', @p_factory_id))         + char(10)
            SELECT @v_dSql1 += '                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))     + char(10)
            SELECT @v_dSql1 += '                     '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))               + char(10)
           
		    IF LEN(@p_model_id) > 0 																			                
                BEGIN																						                
                    SELECT @v_dSql1 += '           AND  ISNULL( B.APPLIED_MODEL, B.ITEM_ID ) LIKE ''%'' + '''+ @p_model_id +''' + ''%''   ' + char(10)
                END	
            IF LEN(@p_item_id) > 0 																			                
                BEGIN																						                
                    SELECT @v_dSql1 += '           AND  A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%''           ' + char(10)
                END	
            IF LEN(@p_nick_name) > 0 																			                
                BEGIN																						                
                    SELECT @v_dSql1 += '           AND  B.NICK_NAME LIKE ''%'' + '''+ @p_nick_name +''' + ''%''       ' + char(10)
                END	

            SELECT @v_dSql1 += '            ) A       ' + char(10)
            SELECT @v_dSql1 += '            WHERE 1=1 ' + char(10)

            IF LEN(@p_model_id) > 0 																			                
                BEGIN																						                
                     SELECT @v_dSql1 += '           AND  A.MODEL LIKE ''%'' + '''+ @p_model_id +''' + ''%''   ' + char(10)
                END	

            SELECT @v_dSql1 += '           '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type))    + char(10)
            SELECT @v_dSql1 += '            GROUP BY A.SCP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.MODEL ' + char(10)
            SELECT @v_dSql1 += '		     , A.ITEM_ID, A.NICK_NAME, A.ITEM_TYPE, A.OPERATION_ID, A.FACTORY_ID                ' + char(10)
            SELECT @v_dSql1 += '			 , A.PRODUCTION_TYPE, A.MARKET, A.LINE_ID, A.LINE_NAME, A.PLAN_WEEK, MFG_WEEK       ' + char(10)
            SELECT @v_dSql1 += '        ) ' + char(10)

			SELECT @v_dSql2  = ''
            SELECT @v_dSql2 += '   , SCP_TARGET AS (                                                             ' + char(10)
            SELECT @v_dSql2 += '         SELECT * FROM SCP_TARGET_RAW                                            ' + char(10)
            SELECT @v_dSql2 += '         UNION ALL                                                               ' + char(10)
            SELECT @v_dSql2 += '         -- PLAN WEEK, MFG_WEEK 주차 강제 생성                                   ' + char(10)
            SELECT @v_dSql2 += '         SELECT DISTINCT A.SCP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID   ' + char(10)
            SELECT @v_dSql2 += '	        , A.PLANT_ID, A.MODEL, A.ITEM_ID, A.NICK_NAME, A.ITEM_TYPE           ' + char(10)
            SELECT @v_dSql2 += '		    , A.OPERATION_ID, A.FACTORY_ID, A.PRODUCTION_TYPE, A.MARKET          ' + char(10)
            SELECT @v_dSql2 += '		    , A.LINE_ID, A.LINE_NAME, B.PLAN_WEEK AS PLAN_WEEK                   ' + char(10)
            SELECT @v_dSql2 += '		    , C.MFG_WEEK AS MFG_WEEK, 0 AS SCP_QTY                               ' + char(10)
            SELECT @v_dSql2 += '         FROM   SCP_TARGET_RAW A,                                                ' + char(10)
            SELECT @v_dSql2 += '	     (                                                                       ' + char(10)
            
			SELECT @v_tmp1 = ''         
            SELECT @max_loop_cnt = 0
            SELECT @mst_loop_cnt = 0
            SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_plan_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			
			IF(LEN(@p_plan_week_info) > 0)
                 BEGIN
                     WHILE @mst_loop_cnt < @max_loop_cnt      
                         BEGIN                                
                             SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                             SELECT @v_plan_week_info   = [dbo].[SCM_ARR_SPL_VAL](@p_plan_week_info ,@v_delimiter, @mst_loop_cnt) 
                             IF @mst_loop_cnt = 1
                                 BEGIN
                                     SELECT @v_tmp1 += '	      SELECT ''' + @v_plan_week_info + '''  AS  PLAN_WEEK ' +char(10)
                                 END
                             ELSE
                                 BEGIN
                                     SELECT @v_tmp1 += '	      UNION ALL ' +char(10)
                                     SELECT @v_tmp1 += '	      SELECT ''' + @v_plan_week_info + '''  AS  PLAN_WEEK ' +char(10)
                                 END
                     	END                                  
                 END

            SELECT @v_dSql2 = @v_dSql2 + @v_tmp1
            SELECT @v_dSql2 += '         ) B,  ' +char(10)
            SELECT @v_dSql2 += '         (     ' +char(10)
			
			SELECT @v_tmp2 = ''         
            SELECT @max_loop_cnt = 0
            SELECT @mst_loop_cnt = 0
            SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
			
            IF(LEN(@p_week_info) > 0)
                BEGIN
                    WHILE @mst_loop_cnt < @max_loop_cnt      
                        BEGIN                                
                            SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                            SELECT @v_week_info   = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt) 
                            IF @mst_loop_cnt = 1
                                BEGIN
                                    SELECT @v_tmp2 += '          SELECT ''' + @v_week_info + '''  AS  MFG_WEEK ' +char(10)
                                END
                            ELSE
                                BEGIN
                                    SELECT @v_tmp2 += '          UNION ALL ' +char(10)
                                    SELECT @v_tmp2 += '          SELECT ''' + @v_week_info + '''  AS  MFG_WEEK ' +char(10)
                                END
                        END                                  
                END

            SELECT @v_dSql2 = @v_dSql2+ @v_tmp2

            SELECT @v_dSql2 += '         ) C            ' +char(10)
            SELECT @v_dSql2 += '     )                  ' +char(10)
            SELECT @v_dSql2 += '   -- result            ' +char(10)
            SELECT @v_dSql2 += '   , RESULT_TARGET AS ( ' +char(10)
            SELECT @v_dSql2 += '         SELECT A.*     ' +char(10)
            SELECT @v_dSql2 += '         FROM (         ' +char(10)
            SELECT @v_dSql2 += '               SELECT CAL.ISO_YYYYWW AS PROD_WEEK, A.COMPANY_ID, A.DIVISION_ID ' +char(10)
            SELECT @v_dSql2 += '			    , A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID ' +char(10)
            SELECT @v_dSql2 += '				, A.OPERATION_ID, A.LINE_ID, A.FP_PRODUCTION_TYPE, A.MARKET ' +char(10)
            SELECT @v_dSql2 += '               	, SUM(CEILING(A.ACTUAL_GOOD_QTY)) AS ACTUAL_GOOD_QTY ' +char(10)
            SELECT @v_dSql2 += '               FROM   SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK) ' +char(10)

            SELECT @v_dSql2 += '               INNER JOIN TH_UIS_CAL CAL WITH(NOLOCK) ' +char(10)
            SELECT @v_dSql2 += '               ON   CONVERT(DATE, A.PLAN_DATE) = CAL.YYYYMMDD ' +char(10)
            SELECT @v_dSql2 += '               WHERE 1=1 ' +char(10)
            SELECT @v_dSql2 += '               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))             + char(10)
            SELECT @v_dSql2 += '               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))         + char(10)
            SELECT @v_dSql2 += '               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))     + char(10)
            SELECT @v_dSql2 += '               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))               + char(10)
            SELECT @v_dSql2 += '               '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type))     + char(10)
            
			IF LEN(@p_item_id) > 0 																			                
                BEGIN																						                
                    SELECT @v_dSql2 += '               AND  A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%''           ' + char(10)
                END	
            IF LEN(@p_nick_name) > 0 																			                
                BEGIN																						                
                    SELECT @v_dSql2 += '               AND  B.NICK_NAME LIKE ''%'' + '''+ @p_nick_name +''' + ''%''       ' + char(10)
                END	
            SELECT @v_dSql2 += '               AND   CAL.YYYYMMDD BETWEEN '''+ @p_bucket_from_date +''' AND '''+ @p_bucket_to_date +'''  ' +char(10)
            SELECT @v_dSql2 += '               GROUP BY CAL.ISO_YYYYWW, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID               ' +char(10)
            SELECT @v_dSql2 += '                  , A.FACTORY_ID, A.ITEM_ID, A.OPERATION_ID, A.LINE_ID   ' +char(10)
            SELECT @v_dSql2 += '                  , A.FP_PRODUCTION_TYPE, A.MARKET                       ' +char(10)
            SELECT @v_dSql2 += '           ) A                                                           ' +char(10)
            SELECT @v_dSql2 += '           WHERE 1=1                                                     ' +char(10)
            SELECT @v_dSql2 += '           AND   EXISTS (                                                ' +char(10)
            SELECT @v_dSql2 += '                         SELECT 1                                        ' +char(10)
            SELECT @v_dSql2 += '                         FROM   SCP_TARGET_RAW B                         ' +char(10)
            SELECT @v_dSql2 += '                         WHERE  1=1                                      ' +char(10)
            SELECT @v_dSql2 += '                         AND    A.COMPANY_ID   = B.COMPANY_ID            ' +char(10)
            SELECT @v_dSql2 += '                         AND    A.DIVISION_ID  = B.DIVISION_ID           ' +char(10)
            SELECT @v_dSql2 += '                         AND    A.SITE_ID      = B.SITE_ID               ' +char(10)
            SELECT @v_dSql2 += '                         AND    A.PLANT_ID     = B.PLANT_ID              ' +char(10)
            SELECT @v_dSql2 += '                         AND    A.OPERATION_ID = B.OPERATION_ID          ' +char(10)
            SELECT @v_dSql2 += '                         AND    A.LINE_ID      = B.LINE_ID               ' +char(10)
            SELECT @v_dSql2 += '                         AND    A.FP_PRODUCTION_TYPE = B.PRODUCTION_TYPE ' +char(10)
            SELECT @v_dSql2 += '                         AND    A.MARKET       = B.MARKET                ' +char(10)
            SELECT @v_dSql2 += '                         AND    A.ITEM_ID      = B.ITEM_ID               ' +char(10)
            SELECT @v_dSql2 += '                        )                                                ' +char(10)
            SELECT @v_dSql2 += '      )                                                                  ' +char(10)
            
			SELECT @v_dSql3  = ''
			SELECT @v_dSql3 += '   -- PP 데이터       ' +char(10)
            SELECT @v_dSql3 += '   , PP_DATA_RAW AS ( ' +char(10)
            SELECT @v_dSql3 += '         SELECT A.*   ' +char(10)
            SELECT @v_dSql3 += '           , B.NICK_NAME, B.LEVEL_3_NAME AS ITEM_TYPE                                              ' +char(10)
            SELECT @v_dSql3 += '           , ISNULL( B.APPLIED_MODEL, B.ITEM_ID ) AS MODEL                                         ' +char(10)
            SELECT @v_dSql3 += '           , C.LINE_NAME                                                                           ' +char(10)
            SELECT @v_dSql3 += '         FROM (                                                                                    ' +char(10)
            SELECT @v_dSql3 += '               -- 당주                                                                             ' +char(10)
            SELECT @v_dSql3 += '               SELECT '''+ @p_curr_week +''' AS PLAN_WEEK, B.ISO_YYYYWW AS MFG_WEEK                ' +char(10)
            SELECT @v_dSql3 += '                   , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID              ' +char(10)
            SELECT @v_dSql3 += '                   , A.OPERATION_ID, A.LINE_ID, A.ITEM_ID, A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE ' +char(10)
            SELECT @v_dSql3 += '				, A.MARKET, SUM(A.PLAN_QTY) AS QTY                                                 ' +char(10)
            SELECT @v_dSql3 += '               FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)                                   ' +char(10)
            SELECT @v_dSql3 += '               INNER HASH JOIN TH_UIS_CAL B WITH(NOLOCK)                                           ' +char(10)
            SELECT @v_dSql3 += '               ON   CONVERT(VARCHAR,A.PLAN_DATE,112) = B.YYYYMMDD                                  ' +char(10)
            SELECT @v_dSql3 += '               WHERE  1=1                                                                          ' +char(10)
            SELECT @v_dSql3 += '               AND   A.PLAN_TYPE = '''+ @p_pp_option +'''                                          ' +char(10)
            SELECT @v_dSql3 += '               AND   CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from_date +''' AND '''+ @p_bucket_to_date +'''    ' +char(10)
            SELECT @v_dSql3 += '                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))             + char(10)
            SELECT @v_dSql3 += '                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))         + char(10)
            SELECT @v_dSql3 += '                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))     + char(10)
            SELECT @v_dSql3 += '                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))               + char(10)
            SELECT @v_dSql3 += '                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type))     + char(10)
            IF LEN(@p_item_id) > 0 																			                
                BEGIN																						                
                       SELECT @v_dSql3 += '                AND  A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%''    ' + char(10)
                END	
            
            SELECT @v_dSql3 += '                AND   B.ISO_YYYYWW >= '''+ @p_curr_week +'''                            ' + char(10)
            SELECT @v_dSql3 += '                GROUP BY B.ISO_YYYYWW, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID           ' + char(10)
            SELECT @v_dSql3 += '                  , A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID                 ' + char(10)
            SELECT @v_dSql3 += '                  , A.ITEM_ID, A.FP_PRODUCTION_TYPE, A.MARKET                           ' + char(10)
            SELECT @v_dSql3 += '                UNION ALL                                                               ' + char(10)
            SELECT @v_dSql3 += '                -- 과거                                                                 ' + char(10)
            SELECT @v_dSql3 += '                SELECT A.YYYYWW AS PLAN_WEEK, B.ISO_YYYYWW AS MFG_WEEK, A.COMPANY_ID    ' + char(10)
            SELECT @v_dSql3 += '                   , A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID ' + char(10)
            SELECT @v_dSql3 += '                   , A.LINE_ID, A.ITEM_ID, A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE      ' + char(10)
            SELECT @v_dSql3 += '                   , A.MARKET, SUM(A.PLAN_QTY) AS QTY                                   ' + char(10)
            SELECT @v_dSql3 += '                FROM   FP_DAILY_PRODUCTION_PLAN_DW_H A WITH(NOLOCK)                     ' + char(10)
            SELECT @v_dSql3 += '                INNER HASH JOIN TH_UIS_CAL B WITH(NOLOCK)                               ' + char(10)
            SELECT @v_dSql3 += '                ON     CONVERT(VARCHAR,A.PLAN_DATE,112) = B.YYYYMMDD                    ' + char(10)
            SELECT @v_dSql3 += '                WHERE  1=1                                                              ' + char(10)
            SELECT @v_dSql3 += '                AND   A.PLAN_TYPE = '''+ @p_pp_option +'''                              ' + char(10)
            SELECT @v_dSql3 += '                AND   CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_bucket_from_date +''' AND '''+ @p_bucket_to_date +'''    ' +char(10)
            SELECT @v_dSql3 += '                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))             + char(10)
            SELECT @v_dSql3 += '                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))         + char(10)
            SELECT @v_dSql3 += '                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))     + char(10)
            SELECT @v_dSql3 += '                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))               + char(10)
            SELECT @v_dSql3 += '                '+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type))     + char(10)
           
		    IF LEN(@p_item_id) > 0 																			                
                BEGIN																						                
                       SELECT @v_dSql3 += '                AND  A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%''  ' + char(10)
                END	

            SELECT @v_dSql3 += '                GROUP BY A.YYYYWW, B.ISO_YYYYWW, A.COMPANY_ID, A.DIVISION_ID     ' + char(10)
            SELECT @v_dSql3 += '                   , A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID         ' + char(10)
            SELECT @v_dSql3 += '                   , A.LINE_ID, A.ITEM_ID, A.FP_PRODUCTION_TYPE, A.MARKET        ' + char(10)
            SELECT @v_dSql3 += '          ) A                                                                    ' + char(10)
            SELECT @v_dSql3 += '          INNER HASH JOIN (                                                      ' + char(10)
            SELECT @v_dSql3 += '                      SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID     ' + char(10)
            SELECT @v_dSql3 += '				       , A.ITEM_ID, A.NICK_NAME, B.LEVEL_3_NAME, A.APPLIED_MODEL ' + char(10)
            SELECT @v_dSql3 += '					   , SUBSTRING(A.FLOW_ID, 1,5)  AS OPERATION_ID              ' + char(10)
            SELECT @v_dSql3 += '                      FROM   SCM_ITEM_M A WITH(NOLOCK)                           ' + char(10)
			SELECT @v_dSql3 += '                          , SCM_ITEM_CLASS_M B WITH(NOLOCK)                      ' + char(10)
            SELECT @v_dSql3 += '                      WHERE  A.ITEM_CLASS  = B.CLASS_ID                          ' + char(10)
            SELECT @v_dSql3 += '                      AND    A.ACTIVE_FLAG = ''Y''                               ' + char(10)
            SELECT @v_dSql3 += '                      AND    B.USE_FLAG    = ''Y''                               ' + char(10)
            SELECT @v_dSql3 += '          ) B                                                                    ' + char(10)
            SELECT @v_dSql3 += '          ON  A.COMPANY_ID  = B.COMPANY_ID                                       ' + char(10)
            SELECT @v_dSql3 += '          AND A.DIVISION_ID = B.DIVISION_ID                                      ' + char(10)
            SELECT @v_dSql3 += '          AND A.SITE_ID     = B.SITE_ID                                          ' + char(10)
            SELECT @v_dSql3 += '          AND A.ITEM_ID     = B.ITEM_ID                                          ' + char(10)
            SELECT @v_dSql3 += '          INNER HASH JOIN (                                                      ' + char(10)
            SELECT @v_dSql3 += '                    SELECT  COMPANY_ID, DIVISION_ID , SITE_ID , PLANT_ID         ' + char(10)
            SELECT @v_dSql3 += '				   , FACTORY_ID , OPERATION_ID , SCP_LINE_ID , LINE_NAME         ' + char(10)
            SELECT @v_dSql3 += '                    FROM    SCM_LINE_M A WITH(NOLOCK)                            ' + char(10)
            SELECT @v_dSql3 += '                    WHERE   ACTIVE_FLAG = ''Y''                                  ' + char(10)
            SELECT @v_dSql3 += '                    AND     SCP_LINE_ID IS NOT NULL                              ' + char(10)
            SELECT @v_dSql3 += '          ) C                                                                    ' + char(10)
            SELECT @v_dSql3 += '          ON   A.SITE_ID      =  C.SITE_ID                                       ' + char(10)
            SELECT @v_dSql3 += '          AND  A.PLANT_ID     =  C.PLANT_ID                                      ' + char(10)
            SELECT @v_dSql3 += '          AND  A.COMPANY_ID   =  C.COMPANY_ID                                    ' + char(10)
            SELECT @v_dSql3 += '          AND  A.DIVISION_ID  =  C.DIVISION_ID                                   ' + char(10)
            SELECT @v_dSql3 += '          AND  A.LINE_ID      =  C.SCP_LINE_ID                                   ' + char(10)
            SELECT @v_dSql3 += '          AND  A.OPERATION_ID =  C.OPERATION_ID                                  ' + char(10)
            SELECT @v_dSql3 += '          WHERE 1=1                                                              ' + char(10)
            IF LEN(@p_item_id) > 0 																			                
                BEGIN																						                
                    SELECT @v_dSql3 += '          AND  ISNULL( B.APPLIED_MODEL, B.ITEM_ID ) LIKE ''%'' + '''+ @p_model_id +''' + ''%'' ' + char(10)
                END	
            IF LEN(@p_item_id) > 0 																			                
                BEGIN																						                
                    SELECT @v_dSql3 += '          AND  A.ITEM_ID LIKE ''%'' + '''+ @p_item_id +''' + ''%''     ' + char(10)
                END	
            IF LEN(@p_nick_name) > 0 																			          
                BEGIN																						          
                    SELECT @v_dSql3 += '          AND  B.NICK_NAME LIKE ''%'' + '''+ @p_nick_name +''' + ''%'' ' + char(10)
                END	
            SELECT @v_dSql3 += '      )                                                                         ' + char(10)
            SELECT @v_dSql3 += '   , PP_DATA AS (                                                             ' + char(10)
            SELECT @v_dSql3 += '         SELECT *                                                             ' + char(10)
            SELECT @v_dSql3 += '         FROM   PP_DATA_RAW A WITH(NOLOCK)                                    ' + char(10)
            SELECT @v_dSql3 += '         -- PLAN WEEK, MFG_WEEK 주차 강제 생성                                ' + char(10)
            SELECT @v_dSql3 += '         UNION ALL                                                            ' + char(10)
            SELECT @v_dSql3 += '         SELECT DISTINCT B.PLAN_WEEK, C.MFG_WEEK, A.COMPANY_ID, A.DIVISION_ID ' + char(10)
            SELECT @v_dSql3 += '            , A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID  ' + char(10)
            SELECT @v_dSql3 += '            , A.ITEM_ID, A.PRODUCTION_TYPE, A.MARKET, 0 AS QTY, A.NICK_NAME   ' + char(10) 
            SELECT @v_dSql3 += '            , A.ITEM_TYPE, A.MODEL, A.LINE_NAME                               ' + char(10)
            SELECT @v_dSql3 += '         FROM   PP_DATA_RAW A WITH(NOLOCK)                                    ' + char(10)
            SELECT @v_dSql3 += '	     ,(                                                                   ' + char(10)

			SELECT @v_tmp1 = ''         
            SELECT @max_loop_cnt = 0
            SELECT @mst_loop_cnt = 0
            SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_plan_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
           
			IF(LEN(@p_plan_week_info) > 0)
                 BEGIN
                  WHILE @mst_loop_cnt < @max_loop_cnt      
                         BEGIN                                
                            SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                            SELECT @v_plan_week_info   = [dbo].[SCM_ARR_SPL_VAL](@p_plan_week_info ,@v_delimiter, @mst_loop_cnt) 
                         IF @mst_loop_cnt = 1
                             BEGIN
                                 SELECT @v_tmp1 += '                SELECT ''' + @v_plan_week_info + '''  AS  PLAN_WEEK ' +char(10)
                             END
                         ELSE
                             BEGIN
                                 SELECT @v_tmp1 += '                UNION ALL ' +char(10)
                                 SELECT @v_tmp1 += '                SELECT ''' + @v_plan_week_info + '''  AS  PLAN_WEEK ' +char(10)
                             END
                      END                                  
                 END

            SELECT @v_dSql3 = @v_dSql3 + @v_tmp1

            SELECT @v_dSql3 += '         ) B,  ' + char(10)
            SELECT @v_dSql3 += '         (     ' + char(10)

			SELECT @v_tmp1 = ''         
            SELECT @max_loop_cnt = 0
            SELECT @mst_loop_cnt = 0
            SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단

            IF(LEN(@p_week_info) > 0)
                 BEGIN
                     WHILE @mst_loop_cnt < @max_loop_cnt      
                         BEGIN                                
                             SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                             SELECT @v_week_info  = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt) 
                             IF @mst_loop_cnt = 1
                                 BEGIN
                                     SELECT @v_tmp1 += '                SELECT ''' + @v_week_info + '''  AS  MFG_WEEK ' +char(10)
                                 END
                             ELSE
                                 BEGIN
                                     SELECT @v_tmp1 += '                UNION ALL ' +char(10)
                                     SELECT @v_tmp1 += '                SELECT ''' + @v_week_info + '''  AS  MFG_WEEK ' +char(10)
                                 END
                             END                                  
                 END

            SELECT @v_dSql3 = @v_dSql3 + @v_tmp1

            SELECT @v_dSql3 += '         ) C        ' + char(10)
            SELECT @v_dSql3 += '     )              ' + char(10)

			SELECT @v_dSql4  = ''
            SELECT @v_dSql4 += '   , MAIN AS (      ' + char(10)
            SELECT @v_dSql4 += '         SELECT A.* ' + char(10)
            SELECT @v_dSql4 += '             , ''DATA'' AS DATA_TYPE                                                        ' +char(10)
            SELECT @v_dSql4 += '         FROM (                                                                             ' +char(10)
            SELECT @v_dSql4 += '               -- R+P  * 과거구간 = PLAN_WEEK > MFG_WEEK, * 미래구간 = 과거구간 이외        ' +char(10)
            SELECT @v_dSql4 += '               SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID      ' +char(10)
            SELECT @v_dSql4 += '                   , A.OPERATION_ID, A.LINE_ID, A.LINE_NAME, A.PRODUCTION_TYPE              ' +char(10)
            SELECT @v_dSql4 += '                   , A.MARKET, A.MODEL, A.ITEM_ID, A.NICK_NAME, A.ITEM_TYPE                 ' +char(10)
            SELECT @v_dSql4 += '                   , ''R_P'' AS CATEGORY_ID, ''R+P'' AS CATEGORY_NAME, 10 AS CATEGORY_ORDER ' +char(10)
            SELECT @v_dSql4 += '                   , B.PLAN_WEEK, B.PLAN_WEEK_NAME, B.PLAN_WEEK_ORDER                       ' +char(10)
            SELECT @v_dSql4 += '                   -- PLAN_WEEK : 행, MFG_WEEK : 열                                         ' +char(10)

            SELECT @v_tmp1 = ''         
            SELECT @max_loop_cnt = 0
            SELECT @mst_loop_cnt = 0
            SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단

			IF(LEN(@p_week_info) > 0)
                BEGIN
                    WHILE @mst_loop_cnt < @max_loop_cnt      
                        BEGIN                                
                            SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                            SELECT @v_week_info   = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt) 
                            SELECT @v_tmp1 += '                   , MAX( CASE  ' +char(10)
                            
                            SELECT @max_loop_cnt2 = 0
                            SELECT @mst_loop_cnt2 = 0
                            SELECT @max_loop_cnt2 = [dbo].[SCM_ARR_SPL_CNT](@p_plan_week_Info, @v_delimiter) -- 프로시저 LOOP 길이를 판단

                            WHILE @mst_loop_cnt2 < @max_loop_cnt2
                                BEGIN
                                    SELECT @mst_loop_cnt2    = @mst_loop_cnt2 + 1
                                    SELECT @v_plan_week_Info = [dbo].[SCM_ARR_SPL_VAL](@p_plan_week_Info ,@v_delimiter, @mst_loop_cnt2) 
                                    SELECT @v_tmp1 += '                         WHEN B.PLAN_WEEK = ''' + @v_plan_week_Info + ''' THEN ( CASE WHEN A.MFG_WEEK = ''' + @v_week_info + ''' THEN ( CASE WHEN B.PLAN_WEEK > A.MFG_WEEK THEN ( CASE WHEN C.PROD_WEEK = A.MFG_WEEK THEN C.ACTUAL_GOOD_QTY ELSE 0 END )  ELSE A.SCP_QTY END ) ELSE 0 END ) ' +char(10)
								END

                            SELECT @v_tmp1 += '                         ELSE 0 END ) AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' +char(10)
                        END                                  
                END


			SELECT @v_dSql4 = @v_dSql4 + @v_tmp1

            SELECT @v_dSql4 += '               FROM   SCP_TARGET A ' +char(10)
            SELECT @v_dSql4 += '               INNER HASH JOIN (   ' +char(10)

            SELECT @v_tmp1       = ''         
            SELECT @max_loop_cnt = 0
            SELECT @mst_loop_cnt = 0
            SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_plan_week_Info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
            
			IF(LEN(@p_plan_week_Info) > 0)
                BEGIN
                    WHILE @mst_loop_cnt < @max_loop_cnt      
                        BEGIN                                
                            SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                            SELECT @v_plan_week_Info   = [dbo].[SCM_ARR_SPL_VAL](@p_plan_week_Info ,@v_delimiter, @mst_loop_cnt) 
                            IF( @mst_loop_cnt = 1)
                                BEGIN
                                    SELECT @v_tmp1 += '                     SELECT ''' + @v_plan_week_Info + ''' AS  PLAN_WEEK, ''' + @v_plan_week_Info + ''' AS  PLAN_WEEK_NAME, '+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' AS PLAN_WEEK_ORDER ' + char(10)
                                END
                            ELSE
                                BEGIN
                                    SELECT @v_tmp1 += '                     UNION ALL ' +char(10)
                                    SELECT @v_tmp1 += '                     SELECT ''' + @v_plan_week_Info + ''' AS  PLAN_WEEK, ''' + @v_plan_week_Info + ''' AS  PLAN_WEEK_NAME, '+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' AS PLAN_WEEK_ORDER ' + char(10)
                                END
                        END                                  
                END

			SELECT @v_dSql4 = @v_dSql4 + @v_tmp1

            SELECT @v_dSql4 += '               ) B                                           ' +char(10)
            SELECT @v_dSql4 += '               ON A.PLAN_WEEK = B.PLAN_WEEK                  ' +char(10)
            SELECT @v_dSql4 += '               LEFT OUTER HASH JOIN RESULT_TARGET C          ' +char(10)
            SELECT @v_dSql4 += '               ON  A.COMPANY_ID      = C.COMPANY_ID          ' +char(10)
            SELECT @v_dSql4 += '               AND A.DIVISION_ID     = C.DIVISION_ID         ' +char(10)
            SELECT @v_dSql4 += '               AND A.SITE_ID         = C.SITE_ID             ' +char(10)
            SELECT @v_dSql4 += '               AND A.PLANT_ID        = C.PLANT_ID            ' +char(10)
            SELECT @v_dSql4 += '               AND A.FACTORY_ID      = C.FACTORY_ID          ' +char(10)
            SELECT @v_dSql4 += '               AND A.OPERATION_ID    = C.OPERATION_ID        ' +char(10)
            SELECT @v_dSql4 += '               AND A.LINE_ID         = C.LINE_ID             ' +char(10)
            SELECT @v_dSql4 += '               AND A.PRODUCTION_TYPE = C.FP_PRODUCTION_TYPE  ' +char(10)
            SELECT @v_dSql4 += '               AND A.MARKET          = C.MARKET              ' +char(10)
            SELECT @v_dSql4 += '               AND A.ITEM_ID         = C.ITEM_ID             ' +char(10)
            SELECT @v_dSql4 += '               GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' +char(10)
            SELECT @v_dSql4 += '                  , A.OPERATION_ID, A.LINE_ID, A.LINE_NAME, A.PRODUCTION_TYPE            ' +char(10)
            SELECT @v_dSql4 += '                  , A.MARKET, A.MODEL, A.ITEM_ID, A.NICK_NAME, A.ITEM_TYPE               ' +char(10)
            SELECT @v_dSql4 += '                  , B.PLAN_WEEK, B.PLAN_WEEK_NAME, B.PLAN_WEEK_ORDER                     ' +char(10)
            SELECT @v_dSql4 += '                 -- P+P                                                   ' +char(10)
            SELECT @v_dSql4 += '               UNION ALL                                                  ' +char(10)
            SELECT @v_dSql4 += '               SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID  ' +char(10)
            SELECT @v_dSql4 += '                   , A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.LINE_NAME ' +char(10)
            SELECT @v_dSql4 += '                   , A.PRODUCTION_TYPE, A.MARKET, A.MODEL, A.ITEM_ID      ' +char(10)
            SELECT @v_dSql4 += '                   , A.NICK_NAME, A.ITEM_TYPE, ''PP_FP'' AS CATEGORY_ID   ' +char(10)
            SELECT @v_dSql4 += '                   , ''P+P_FP'' AS CATEGORY_NAME, 20 AS CATEGORY_ORDER    ' +char(10)
            SELECT @v_dSql4 += '                   , B.PLAN_WEEK, B.PLAN_WEEK_NAME, B.PLAN_WEEK_ORDER     ' +char(10)
            SELECT @v_dSql4 += '                   -- PLAN_WEEK : 행, MFG_WEEK : 열                       ' +char(10)

            SELECT @v_tmp1 = ''         
            SELECT @max_loop_cnt = 0
            SELECT @mst_loop_cnt = 0
            SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
            
			IF(LEN(@p_week_info) > 0)
                BEGIN
                    WHILE @mst_loop_cnt < @max_loop_cnt      
                        BEGIN                                
                            SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                            SELECT @v_week_info   = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt) 
                            SELECT @v_tmp1 += '                   , MAX( CASE  ' +char(10)
                            
                            SELECT @max_loop_cnt2 = 0
                            SELECT @mst_loop_cnt2 = 0
                            SELECT @max_loop_cnt2 = [dbo].[SCM_ARR_SPL_CNT](@p_plan_week_Info, @v_delimiter) -- 프로시저 LOOP 길이를 판단

                            WHILE @mst_loop_cnt2 < @max_loop_cnt2
                                BEGIN
                                    SELECT @mst_loop_cnt2    = @mst_loop_cnt2 + 1
                                    SELECT @v_plan_week_Info = [dbo].[SCM_ARR_SPL_VAL](@p_plan_week_Info ,@v_delimiter, @mst_loop_cnt2) 
                                    SELECT @v_tmp1 += '                       WHEN B.PLAN_WEEK = ''' + @v_plan_week_Info + ''' THEN ( CASE WHEN A.MFG_WEEK = ''' + @v_week_info + ''' THEN  A.QTY ELSE 0 END ) ' +char(10)
								END

                            SELECT @v_tmp1 += '                            ELSE 0 END ) AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' +char(10)
                        END                                  
                END
            
            SELECT @v_dSql4  = @v_dSql4 + @v_tmp1
            SELECT @v_dSql4 += '               FROM   PP_DATA A  ' +char(10)
            SELECT @v_dSql4 += '               INNER HASH JOIN ( ' +char(10)                         
            
			SELECT @v_tmp1 = ''         
            SELECT @max_loop_cnt = 0
            SELECT @mst_loop_cnt = 0
            SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_plan_week_Info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
            
			IF(LEN(@p_plan_week_Info) > 0)
                BEGIN
                    WHILE @mst_loop_cnt < @max_loop_cnt      
                        BEGIN                                
                            SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                            SELECT @v_plan_week_Info   = [dbo].[SCM_ARR_SPL_VAL](@p_plan_week_Info ,@v_delimiter, @mst_loop_cnt) 
                            IF( @mst_loop_cnt = 1)
                                BEGIN
                                    SELECT @v_tmp1 += '                     SELECT  ''' + @v_plan_week_Info + '''  AS  PLAN_WEEK, ''' + @v_plan_week_Info + '''  AS  PLAN_WEEK_NAME, '+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' AS PLAN_WEEK_ORDER ' +char(10)
                                END
                            ELSE
                                BEGIN
                                    SELECT @v_tmp1 += '                     UNION ALL ' +char(10)
                                    SELECT @v_tmp1 += '                     SELECT  ''' + @v_plan_week_Info + '''  AS  PLAN_WEEK, ''' + @v_plan_week_Info + '''  AS  PLAN_WEEK_NAME, '+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' AS PLAN_WEEK_ORDER ' +char(10)
                                END
                        END                                  
                END

            SELECT @v_dSql4  = @v_dSql4 + @v_tmp1
            SELECT @v_dSql4 += '               ) B                                                           ' +char(10)
            SELECT @v_dSql4 += '               ON A.PLAN_WEEK = B.PLAN_WEEK                                  ' +char(10)
            SELECT @v_dSql4 += '               GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID   ' +char(10)
            SELECT @v_dSql4 += '                   , A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.LINE_NAME    ' +char(10)
            SELECT @v_dSql4 += '                   , A.PRODUCTION_TYPE, A.MARKET, A.MODEL, A.ITEM_ID         ' +char(10)
            SELECT @v_dSql4 += '                   , A.NICK_NAME, A.ITEM_TYPE, B.PLAN_WEEK, B.PLAN_WEEK_NAME ' +char(10)
            SELECT @v_dSql4 += '                   , B.PLAN_WEEK_ORDER                                       ' +char(10)
            SELECT @v_dSql4 += '           ) A                                                               ' +char(10)

			SELECT @v_dSql4 += '        UNION ALL                                                            ' +char(10)

            SELECT @v_dSql5  = ''
            SELECT @v_dSql5 += '        SELECT C.* ' + char(10)
            SELECT @v_dSql5 += '             , ''DATA'' AS DATA_TYPE                                                        ' +char(10)
            SELECT @v_dSql5 += '        FROM (                                                                              ' +char(10)
            SELECT @v_dSql5 += '               -- R+P  * 과거구간 = PLAN_WEEK > MFG_WEEK, * 미래구간 = 과거구간 이외        ' +char(10)
            SELECT @v_dSql5 += '               SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID      ' +char(10)
            SELECT @v_dSql5 += '                   , A.OPERATION_ID, A.LINE_ID, A.LINE_NAME, A.PRODUCTION_TYPE              ' +char(10)
            SELECT @v_dSql5 += '                   , A.MARKET, A.MODEL, A.ITEM_ID, A.NICK_NAME, A.ITEM_TYPE                 ' +char(10)
            SELECT @v_dSql5 += '                   , ''R_P'' AS CATEGORY_ID, ''R+P'' AS CATEGORY_NAME, 11 AS CATEGORY_ORDER ' +char(10)
            SELECT @v_dSql5 += '                   , B.PLAN_WEEK, ''Memo'' AS PLAN_WEEK_NAME, B.PLAN_WEEK_ORDER             ' +char(10)
            SELECT @v_dSql5 += '                   -- PLAN_WEEK : 행, MFG_WEEK : 열                                         ' +char(10)

            SELECT @v_tmp1 = ''         
            SELECT @max_loop_cnt = 0
            SELECT @mst_loop_cnt = 0
            SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단

            IF(LEN(@p_week_info) > 0)
                BEGIN
                    WHILE @mst_loop_cnt < @max_loop_cnt      
                        BEGIN                                
                            SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                            SELECT @v_week_info   = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt) 
                            SELECT @v_tmp1 += '                   , MAX( CASE  ' +char(10)
                            
                            SELECT @max_loop_cnt2 = 0
                            SELECT @mst_loop_cnt2 = 0
                            SELECT @max_loop_cnt2 = [dbo].[SCM_ARR_SPL_CNT](@p_plan_week_Info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                            
                            WHILE @mst_loop_cnt2 < @max_loop_cnt2
                                BEGIN
                                    SELECT @mst_loop_cnt2    = @mst_loop_cnt2 + 1
                                    SELECT @v_plan_week_Info = [dbo].[SCM_ARR_SPL_VAL](@p_plan_week_Info ,@v_delimiter, @mst_loop_cnt2) 
                                    SELECT @v_tmp1 += '                         WHEN B.PLAN_WEEK = ''' + @v_plan_week_Info + ''' THEN 0 ' +char(10)
                                END
                                
                            SELECT @v_tmp1 += '                         ELSE 0 END ) AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' +char(10)
                        END                                  
                END


            SELECT  @v_dSql5 = @v_dSql5 + @v_tmp1

            SELECT @v_dSql5 += '               FROM   SCP_TARGET A ' +char(10)
            SELECT @v_dSql5 += '               INNER HASH JOIN (   ' +char(10)
            
            SELECT @v_tmp1       = ''         
            SELECT @max_loop_cnt = 0
            SELECT @mst_loop_cnt = 0
            SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_plan_week_Info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
            
            IF(LEN(@p_plan_week_Info) > 0)
                BEGIN
                    WHILE @mst_loop_cnt < @max_loop_cnt      
                        BEGIN                                
                            SELECT @mst_loop_cnt     = @mst_loop_cnt + 1
                            SELECT @v_plan_week_Info = [dbo].[SCM_ARR_SPL_VAL](@p_plan_week_Info ,@v_delimiter, @mst_loop_cnt) 
                            IF( @mst_loop_cnt = 1)
                                BEGIN
                                    SELECT @v_tmp1 += '                     SELECT ''' + @v_plan_week_Info + ''' AS  PLAN_WEEK, ''' + @v_plan_week_Info + ''' AS  PLAN_WEEK_NAME, '+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' AS PLAN_WEEK_ORDER ' + char(10)
                                END
                            ELSE
                                BEGIN
                                    SELECT @v_tmp1 += '                     UNION ALL ' +char(10)
                                    SELECT @v_tmp1 += '                     SELECT ''' + @v_plan_week_Info + ''' AS  PLAN_WEEK, ''' + @v_plan_week_Info + ''' AS  PLAN_WEEK_NAME, '+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' AS PLAN_WEEK_ORDER ' + char(10)
                                END
                        END                                  
                END
			
			SELECT  @v_dSql5 =  @v_dSql5 + @v_tmp1

            SELECT @v_dSql5 += '               ) B                                           ' +char(10)
            SELECT @v_dSql5 += '               ON A.PLAN_WEEK = B.PLAN_WEEK                  ' +char(10)
            SELECT @v_dSql5 += '               LEFT OUTER HASH JOIN RESULT_TARGET C          ' +char(10)
            SELECT @v_dSql5 += '               ON  A.COMPANY_ID      = C.COMPANY_ID          ' +char(10)
            SELECT @v_dSql5 += '               AND A.DIVISION_ID     = C.DIVISION_ID         ' +char(10)
            SELECT @v_dSql5 += '               AND A.SITE_ID         = C.SITE_ID             ' +char(10)
            SELECT @v_dSql5 += '               AND A.PLANT_ID        = C.PLANT_ID            ' +char(10)
            SELECT @v_dSql5 += '               AND A.FACTORY_ID      = C.FACTORY_ID          ' +char(10)
            SELECT @v_dSql5 += '               AND A.OPERATION_ID    = C.OPERATION_ID        ' +char(10)
            SELECT @v_dSql5 += '               AND A.LINE_ID         = C.LINE_ID             ' +char(10)
            SELECT @v_dSql5 += '               AND A.PRODUCTION_TYPE = C.FP_PRODUCTION_TYPE  ' +char(10)
            SELECT @v_dSql5 += '               AND A.MARKET          = C.MARKET              ' +char(10)
            SELECT @v_dSql5 += '               AND A.ITEM_ID         = C.ITEM_ID             ' +char(10)
            SELECT @v_dSql5 += '               GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' +char(10)
            SELECT @v_dSql5 += '                  , A.OPERATION_ID, A.LINE_ID, A.LINE_NAME, A.PRODUCTION_TYPE            ' +char(10)
            SELECT @v_dSql5 += '                  , A.MARKET, A.MODEL, A.ITEM_ID, A.NICK_NAME, A.ITEM_TYPE               ' +char(10)
            SELECT @v_dSql5 += '                  , B.PLAN_WEEK, B.PLAN_WEEK_NAME, B.PLAN_WEEK_ORDER                     ' +char(10)
            SELECT @v_dSql5 += '               UNION ALL                                                                 ' + char(10)
            
            SELECT @v_dSql6 = ''
            SELECT @v_dSql6 += '               SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID  ' + char(10)
            SELECT @v_dSql6 += '                   , A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.LINE_NAME ' + char(10)
            SELECT @v_dSql6 += '                   , A.PRODUCTION_TYPE, A.MARKET, A.MODEL, A.ITEM_ID      ' + char(10)
            SELECT @v_dSql6 += '                   , A.NICK_NAME, A.ITEM_TYPE, ''PP_FP'' AS CATEGORY_ID   ' + char(10)
            SELECT @v_dSql6 += '                   , ''P+P_FP'' AS CATEGORY_NAME, 21 AS CATEGORY_ORDER    ' + char(10)
            SELECT @v_dSql6 += '                   , B.PLAN_WEEK, ''Memo'' AS PLAN_WEEK_NAME, B.PLAN_WEEK_ORDER     ' + char(10)
            
			SELECT @v_tmp2 = ''
            SELECT @max_loop_cnt = 0
            SELECT @mst_loop_cnt = 0
            SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
            IF(LEN(@p_week_info) > 0)
                BEGIN
                    WHILE @mst_loop_cnt < @max_loop_cnt
                        BEGIN
                            SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                            SELECT @v_week_info  = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)
                            SELECT @v_tmp2 += '                   , MAX( CASE  ' +char(10)
                            
                            SELECT @max_loop_cnt2 = 0
                            SELECT @mst_loop_cnt2 = 0
                            SELECT @max_loop_cnt2 = [dbo].[SCM_ARR_SPL_CNT](@p_plan_week_Info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                            
                            WHILE @mst_loop_cnt2 < @max_loop_cnt2
                                BEGIN
                                    SELECT @mst_loop_cnt2    = @mst_loop_cnt2 + 1
                                    SELECT @v_plan_week_Info = [dbo].[SCM_ARR_SPL_VAL](@p_plan_week_Info ,@v_delimiter, @mst_loop_cnt2)
                                    SELECT @v_tmp2 += '                         WHEN B.PLAN_WEEK = ''' + @v_plan_week_Info + '''  THEN 0  ' +char(10)
                                END
                                
                            SELECT @v_tmp2 += '                             ELSE 0 END ) AS W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +'  ' +char(10)
                        END
                END

            SELECT  @v_dSql6 = @v_dSql6 + @v_tmp2

            SELECT @v_dSql6 += '               FROM   PP_DATA A  ' +char(10)
            SELECT @v_dSql6 += '               INNER HASH JOIN ( ' +char(10)                         
            
            SELECT @v_tmp1 = ''         
            SELECT @max_loop_cnt = 0
            SELECT @mst_loop_cnt = 0
            SELECT @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_plan_week_Info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
            
            IF(LEN(@p_plan_week_Info) > 0)
                BEGIN
                    WHILE @mst_loop_cnt < @max_loop_cnt      
                        BEGIN                                
                            SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                            SELECT @v_plan_week_Info   = [dbo].[SCM_ARR_SPL_VAL](@p_plan_week_Info ,@v_delimiter, @mst_loop_cnt) 
                            IF( @mst_loop_cnt = 1)
                                BEGIN
                                    SELECT @v_tmp1 += '                     SELECT  ''' + @v_plan_week_Info + '''  AS  PLAN_WEEK, ''' + @v_plan_week_Info + '''  AS  PLAN_WEEK_NAME, '+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' AS PLAN_WEEK_ORDER ' +char(10)
                                END
                            ELSE
                                BEGIN
                                    SELECT @v_tmp1 += '                     UNION ALL ' +char(10)
                                    SELECT @v_tmp1 += '                     SELECT  ''' + @v_plan_week_Info + '''  AS  PLAN_WEEK, ''' + @v_plan_week_Info + '''  AS  PLAN_WEEK_NAME, '+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' AS PLAN_WEEK_ORDER ' +char(10)
                                END
                        END                                  
                END
            
            SELECT @v_dSql6  = @v_dSql6 + @v_tmp1
            SELECT @v_dSql6 += '               ) B                                                           ' +char(10)
            SELECT @v_dSql6 += '               ON A.PLAN_WEEK = B.PLAN_WEEK                                  ' +char(10)
            SELECT @v_dSql6 += '               GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID   ' +char(10)
            SELECT @v_dSql6 += '                   , A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.LINE_NAME    ' +char(10)
            SELECT @v_dSql6 += '                   , A.PRODUCTION_TYPE, A.MARKET, A.MODEL, A.ITEM_ID         ' +char(10)
            SELECT @v_dSql6 += '                   , A.NICK_NAME, A.ITEM_TYPE, B.PLAN_WEEK, B.PLAN_WEEK_NAME ' +char(10)
            SELECT @v_dSql6 += '                   , B.PLAN_WEEK_ORDER                                       ' +char(10)
            SELECT @v_dSql6 += '           ) C                                                               ' +char(10)
            SELECT @v_dSql6 += '       )                                                                     ' +char(10)
            --SELECT @v_dSql6 += '   SELECT A.*                                                                ' +char(10)
			SELECT @v_dSql6 += '   SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID  ' + char(10)
            SELECT @v_dSql6 += '       , A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.LINE_NAME ' + char(10)
            SELECT @v_dSql6 += '       , A.PRODUCTION_TYPE, A.MARKET, A.MODEL, A.ITEM_ID      ' + char(10)
            SELECT @v_dSql6 += '       , A.NICK_NAME, A.ITEM_TYPE, A.CATEGORY_ID   ' + char(10)
            SELECT @v_dSql6 += '       , A.CATEGORY_NAME, A.CATEGORY_ORDER    ' + char(10)
            SELECT @v_dSql6 += '       , A.PLAN_WEEK, A.PLAN_WEEK_NAME, A.PLAN_WEEK_ORDER     ' + char(10)

			SELECT @v_tmp2 = ''
            SELECT @max_loop_cnt = 0
            SELECT @mst_loop_cnt = 0
            SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
            IF(LEN(@p_week_info) > 0)
                BEGIN
                    WHILE @mst_loop_cnt < @max_loop_cnt
                        BEGIN
                            SELECT @mst_loop_cnt = @mst_loop_cnt + 1
                            SELECT @v_week_info  = [dbo].[SCM_ARR_SPL_VAL](@p_week_info ,@v_delimiter, @mst_loop_cnt)
                            SELECT @v_tmp2 += '       , CASE  WHEN A.PLAN_WEEK_NAME = ''Memo'' THEN '''' ELSE  CAST(A.W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' AS CHAR(20)) END  W'+ TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' '+char(10)
                        END
                END

            SELECT @v_dSql6 = @v_dSql6 + @v_tmp2
            SELECT @v_dSql6 += '       , A.DATA_TYPE AS DATA_TYPE ' +char(10)
            SELECT @v_dSql6 += '       , (CASE WHEN A.CATEGORY_ID = ''R_P'' AND A.PLAN_WEEK_NAME <> ''Memo'' THEN ''R_P''                      ' +char(10)
            SELECT @v_dSql6 += '               WHEN A.CATEGORY_ID = ''PP_FP'' AND A.PLAN_WEEK_NAME <> ''Memo'' THEN ''PP_FP'' + ''_'' + ( CASE ' +char(10)
            SELECT @v_dSql6 += '			           WHEN ''' + @p_pp_option + ''' = ''RELEASE'' THEN ''DPP''              ' +char(10)
            SELECT @v_dSql6 += '					   ELSE ''' + @p_pp_option + ''' END  )                                  ' +char(10)
            SELECT @v_dSql6 += '               ELSE ''MEMO'' END) AS CATEGORY_DETAIL_ID -- memo 용 category id               ' +char(10)
            
            SELECT @v_dSql6 += '   FROM   MAIN A                                                                             ' +char(10)
            SELECT @v_dSql6 += '   ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.MODEL                      ' +char(10)
            SELECT @v_dSql6 += '      , A.ITEM_ID, A.OPERATION_ID DESC, A.FACTORY_ID, A.PRODUCTION_TYPE, A.MARKET            ' +char(10)
            SELECT @v_dSql6 += '      , (CASE WHEN DATA_TYPE = ''DATA'' THEN 1 WHEN DATA_TYPE = ''TOTAL'' THEN 2 ELSE 0 END) ' +char(10)
            SELECT @v_dSql6 += '      , A.LINE_ID, CATEGORY_ID DESC,A.PLAN_WEEK_ORDER, A.CATEGORY_ORDER                      ' +char(10)

		    SELECT @v_dSql = @v_dSql1 + @v_dSql2 + @v_dSql3 + @v_dSql4 + @v_dSql5 + @v_dSql6
            --SELECT @v_dSql = @v_dSql1 + @v_dSql2 + @v_dSql3 + @v_dSql4 
			--SELECT @v_dSql = @v_dSql5

		    IF @p_sys_type = 'SQL'
		  	    BEGIN
		  	    	 EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
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
		END
	/************************************************************************************************/
	/* SELECT인경우 :SELECT(MEMO_DATA)                                                                      */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='SELECT_MEMO_DATA')
	    BEGIN
		    SELECT @v_dSql = ''
            SELECT @v_dSql += ' SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                              ' + char(10)
            SELECT @v_dSql += '      , A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ITEM_ID                              ' + char(10)
            SELECT @v_dSql += '      , A.PRODUCTION_TYPE, A.MARKET, A.CATEGORY_ID, A.PLAN_WEEK                         ' + char(10)
            SELECT @v_dSql += '      , A.MFG_WEEK, A.DESCRIPTION, A.UPDATE_ID                                          ' + char(10)
            SELECT @v_dSql += '      , CONVERT(VARCHAR, A.UPDATE_DATE, 20) AS UPDATE_DATE                              ' + char(10)
            SELECT @v_dSql += ' FROM   FP_SCP_CHANGE_MEMO_M A WITH(NOLOCK)                                             ' + char(10)
            SELECT @v_dSql += ' WHERE  A.DESCRIPTION IS NOT NULL AND A.DESCRIPTION <> ''''                             ' + char(10)
			SELECT @v_dSql +=  (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))                + char(10)
            SELECT @v_dSql +=  (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))            + char(10)
            SELECT @v_dSql +=  (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))        + char(10)
            SELECT @v_dSql += ' AND   A.PLAN_WEEK BETWEEN '''+ @p_plan_from_week +'''  AND '''+ @p_plan_to_week +'''   ' + char(10)
            SELECT @v_dSql += ' AND   A.MFG_WEEK BETWEEN '''+ @p_bucket_from_week +''' AND '''+ @p_bucket_to_week +''' ' + char(10)
            SELECT @v_dSql += ' ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID              ' + char(10)
            SELECT @v_dSql += '     , A.OPERATION_ID, A.LINE_ID, A.ITEM_ID, A.PRODUCTION_TYPE, A.MARKET                ' + char(10)
            SELECT @v_dSql += '     , A.CATEGORY_ID, A.PLAN_WEEK, A.MFG_WEEK                                           ' + char(10)

		    IF @p_sys_type = 'SQL'
		  	    BEGIN
		  	    	 EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
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
		END
	ELSE
		-- 트랜잭션 (TRAN)
		BEGIN TRY				                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
		BEGIN TRAN   

		BEGIN --ELSE ( BEGIN )
		    --max_loop_cnt:전체 Row수 , mst_loop_cnt:1씩 증가시켜서 전체 Row수 까지만 로직을 수행
			WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
			    BEGIN --WHILE 내(START)
					 
						SELECT @mst_loop_cnt = @mst_loop_cnt + 1	-- @mst_loop_cnt 1증가

                        SELECT @v_sys_type       = [dbo].[SCM_ARR_SPL_VAL](@p_sys_type ,    @v_delimiter, @mst_loop_cnt)
                             , @v_sys_flag       = [dbo].[SCM_ARR_SPL_VAL](@p_sys_flag ,    @v_delimiter, @mst_loop_cnt)
                             , @v_sys_gubun      = [dbo].[SCM_ARR_SPL_VAL](@p_sys_gubun ,   @v_delimiter, @mst_loop_cnt)
                             , @v_user_id        = [dbo].[SCM_ARR_SPL_VAL](@p_user_id ,     @v_delimiter, @mst_loop_cnt)
                             , @v_site_id        = [dbo].[SCM_ARR_SPL_VAL](@p_site_id ,     @v_delimiter, @mst_loop_cnt)
                             , @v_plant_id       = [dbo].[SCM_ARR_SPL_VAL](@p_plant_id ,    @v_delimiter, @mst_loop_cnt)
					    	 , @v_factory_id     = [dbo].[SCM_ARR_SPL_VAL](@p_factory_id ,  @v_delimiter, @mst_loop_cnt)
                             , @v_operation_id   = [dbo].[SCM_ARR_SPL_VAL](@p_operation_id ,@v_delimiter, @mst_loop_cnt)
                             , @v_line_id        = [dbo].[SCM_ARR_SPL_VAL](@p_line_id ,     @v_delimiter, @mst_loop_cnt)
                             , @v_item_id        = [dbo].[SCM_ARR_SPL_VAL](@p_item_id ,     @v_delimiter, @mst_loop_cnt)
                             , @v_prod_type      = [dbo].[SCM_ARR_SPL_VAL](@p_prod_type ,   @v_delimiter, @mst_loop_cnt)

					   /****************************************************************************/
					   /* INSERT  경우  :     I(INSERT)                                    */
					   /****************************************************************************/
					   IF(@v_sys_flag ='INSERT')
						   BEGIN
						        --EXEC  @rtnCount = [dbo].[PR_SCM_UF_ITEM_SETUP_INSERT] @v_company_id, @v_division_id, @v_site_id, @v_operation_id, @v_setup_category_id, @v_setup_key_id;
								SELECT @v_dSql1 = ''

								SELECT @v_dSql = @v_dSql1 + @v_dSql2

						   END --'D'

					IF @v_sys_type = 'SQL'
						BEGIN
							--EXEC PR_UI_SQL_LOG @v_proc_name,  @v_user_id,'','',@v_dSql,'select',@runstart, @runend
							SELECT @v_dSql as [QUERY_VALUE]

						END
					ELSE
						BEGIN
							SET @runstart = GetDate()
							--쿼리실행
							EXEC sp_executesql @v_dSql

							SET @runend = GetDate()
							EXEC PR_UI_SQL_LOG  @v_proc_name,  @v_user_id,'','', @v_dSql,'SELECT',@runstart, @runend
						END

			    END --WHILE 내(END)

		END --ELSE (END)
 		
        -- 트랜잭션 (COMMIT)
		COMMIT TRAN
		
		-- 수행결과 성공여부 RETURN
		IF @v_sys_type <> 'SQL'
		    SELECT 'SUCCESS' AS result_code,  @max_loop_cnt AS result_cnt	

		END TRY
		BEGIN CATCH                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
			ROLLBACK TRAN                                                                                                                                                                                                                                                 
			-- 에러나도 로그는 인서트                                                                                                                                                                                                                                              
			SET @v_log_message = ERROR_MESSAGE()
			EXEC PR_UI_SQL_LOG  @v_proc_name,  @v_user_id,'','',@v_log_message,'excute',@runstart, @runend
			SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  
		END CATCH    

END --MAIN END

