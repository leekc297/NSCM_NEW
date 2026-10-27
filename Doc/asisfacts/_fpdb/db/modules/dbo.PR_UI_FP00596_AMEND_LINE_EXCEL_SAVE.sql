
CREATE PROCEDURE [dbo].[PR_UI_FP00596_AMEND_LINE_EXCEL_SAVE]
  @p_sys_type           nvarchar(MAX),  
  @p_sys_flag           nvarchar(MAX),
  @p_sys_gubun          nvarchar(MAX),  
  @p_user_id            nvarchar(MAX),
  @p_instance_id        NVARCHAR(max),
  @p_plan_date          NVARCHAR(max),
  @p_plan_id            NVARCHAR(max),
  @p_division_id        NVARCHAR(max),
  @p_site_id            NVARCHAR(max),
  @p_mpp_wpp            NVARCHAR(max)
  --@p_bucket_from        NVARCHAR(max),
  --@p_bucket_to          NVARCHAR(max)

WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_UI_FP00596_AMEND_LINE_EXCEL_SAVE                                      **/
/** 프로그램 명   : Procedure PR_UI_FP00596_AMEND_LINE_EXCEL_SAVE                            **/
/** 설 명         :                                                                           **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                                    **/
/**===========================================================================================**/
/** 2021-11-16      JYJ                                                                    **/
/***********************************************************************************************/

BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
  SET NOCOUNT ON; 
  SET XACT_ABORT ON;
  
  --DECLARE BASE PARAMETER START

  DECLARE @v_dSql               NVARCHAR(max)
  DECLARE @v_dSql1              NVARCHAR(max)
  DECLARE @v_dSql2              NVARCHAR(max)
  DECLARE @v_dSql3              NVARCHAR(max)
  DECLARE @v_tmp                NVARCHAR(MAX) = '' 

  DECLARE @v_Err                NVARCHAR(max)
  DECLARE @v_log_message        NVARCHAR(max) 
  DECLARE @v_proc_name          NVARCHAR(100) = 'PR_UI_FP00596_AMEND_LINE_EXCEL_SAVE'

  DECLARE @v_sys_type			nvarchar(MAX)  
  DECLARE @v_sys_flag			nvarchar(MAX)
  DECLARE @v_sys_gubun			nvarchar(MAX)  
  DECLARE @v_user_id			nvarchar(MAX)

  DECLARE @v_instance_id        NVARCHAR(max)
  DECLARE @v_plan_id            NVARCHAR(max)
  DECLARE @v_division_id        NVARCHAR(max)
  DECLARE @v_site_id            NVARCHAR(max)


  DECLARE @runstart             datetime
  DECLARE @runend               datetime
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  DECLARE @v_delimiter          NVARCHAR(2)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @v_seq_no             integer = 0


  SET @v_delimiter            = '|'  -- 데이터 구분자
  SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_instance_id, @v_delimiter) -- 프로시저 LOOP 길이를 판단--'^' 데이터 구분자로 @in_column(key)정보갯수 구하기
  

	/************************************************************************************************/
	/* SELECT인경우 :SELECT_VALID_COLUMN_DEV  TYPE인경우( )                                         */
	/* MODEL : COLUMN / DEV TYPE 인경우( )                                                          */
	/* LINE  : COLUMN / DEV TYPE 인경우( )                                                          */
	/************************************************************************************************/
	IF(@p_sys_flag ='SELECT_VALID_COLUMN_DEV')
		BEGIN --IF(START)

            SELECT @v_dSql = ''
            SELECT @v_dSql += ' SELECT A.* ' + char(10)
            SELECT @v_dSql += '     ,CASE WHEN __MSG = '' Not Found'' THEN (CASE WHEN MSG99 = '''' THEN '''' ELSE MSG99 END) ' + char(10)
            SELECT @v_dSql += '           ELSE (CASE WHEN MSG99 = '''' THEN __MSG ELSE __MSG + '' AND '' + MSG99 END) ' + char(10)
            SELECT @v_dSql += '           END AS _MSG ' + char(10)
            SELECT @v_dSql += '     ,CASE WHEN __MSG = '' Not Found'' AND MSG99 = '''' THEN ''Y'' ELSE ''N'' END AS _VALID ' + char(10)
            SELECT @v_dSql += ' FROM (            ' + char(10)
            SELECT @v_dSql += '       SELECT TT.* ' + char(10)
            SELECT @v_dSql += '           ,MSG1   ' + char(10)
            SELECT @v_dSql += '           +(CASE WHEN (MSG1 = '''')                                                                                                                                               THEN MSG2 ELSE (CASE WHEN MSG2 = '''' THEN '''' ELSE '','' + MSG2 END) END) ' + char(10)
            SELECT @v_dSql += '           +(CASE WHEN (MSG1 = '''' AND MSG2 = '''')                                                                                                                                 THEN MSG3 ELSE (CASE WHEN MSG3 = '''' THEN '''' ELSE '','' + MSG3 END) END) ' + char(10)
            SELECT @v_dSql += '           +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''')                                                                                                                   THEN MSG4 ELSE (CASE WHEN MSG4 = '''' THEN '''' ELSE '','' + MSG4 END) END) ' + char(10)
            SELECT @v_dSql += '           +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''')                                                                                                     THEN MSG5 ELSE (CASE WHEN MSG5 = '''' THEN '''' ELSE '','' + MSG5 END) END) ' + char(10)
            SELECT @v_dSql += '           +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = '''')                                                                                       THEN MSG6 ELSE (CASE WHEN MSG6 = '''' THEN '''' ELSE '','' + MSG6 END) END) ' + char(10)
            SELECT @v_dSql += '           +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = '''' AND MSG6 = '''')                                                                         THEN MSG7 ELSE (CASE WHEN MSG7 = '''' THEN '''' ELSE '','' + MSG7 END) END) ' + char(10)
            SELECT @v_dSql += '           +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = '''' AND MSG6 = '''' AND MSG7 = '''')                                                           THEN MSG8 ELSE (CASE WHEN MSG8 = '''' THEN '''' ELSE '','' + MSG8 END) END) ' + char(10)
            SELECT @v_dSql += '           +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = '''' AND MSG6 = '''' AND MSG7 = '''' AND MSG8 = '''')                                             THEN MSG9 ELSE (CASE WHEN MSG9 = '''' THEN '''' ELSE '','' + MSG9 END) END) ' + char(10)
            SELECT @v_dSql += '           +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = '''' AND MSG6 = '''' AND MSG7 = '''' AND MSG8 = '''' AND MSG9 = '''')                               THEN MSG10 ELSE (CASE WHEN MSG10 = '''' THEN '''' ELSE '','' + MSG10 END) END) ' + char(10)
            SELECT @v_dSql += '           +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = '''' AND MSG6 = '''' AND MSG7 = '''' AND MSG8 = '''' AND MSG9 = '''' AND MSG10 = '''')                THEN MSG11 ELSE (CASE WHEN MSG11 = '''' THEN '''' ELSE '','' + MSG11 END) END) ' + char(10)
            SELECT @v_dSql += '           +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = '''' AND MSG6 = '''' AND MSG7 = '''' AND MSG8 = '''' AND MSG9 = '''' AND MSG10 = '''' AND MSG11 = '''') THEN MSG12 ELSE (CASE WHEN MSG12 = '''' THEN '''' ELSE '','' + MSG12 END) END) ' + char(10)
            SELECT @v_dSql += '           + '' Not Found'' AS __MSG                                ' + char(10)
            SELECT @v_dSql += '       FROM (                                                       ' + char(10)
            SELECT @v_dSql += '           SELECT DISTINCT A.INSTANCE_ID, A.FP_PLAN_ID              ' + char(10)
            SELECT @v_dSql += '                ,A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
            SELECT @v_dSql += '                ,A.FACTORY_ID, A.LOCATION                           ' + char(10)
            SELECT @v_dSql += '                ,A.OPERATION_ID, A.LINE_ID, D.LINE_NAME, A.ELECTRODE_TYPE, A.EQUIPMENT_ID ' + char(10)
            SELECT @v_dSql += '                ,A.PLAN_DATE                                        ' + char(10)
            SELECT @v_dSql += '                ,A.TOP_ITEM_ID, A.ITEM_ID, B.NICK_NAME              ' + char(10)
            SELECT @v_dSql += '                ,A.PRODUCTION_TYPE, A.MARKET                        ' + char(10)
            SELECT @v_dSql += '                ,A.SEQ, A.QTY                                       ' + char(10)
            SELECT @v_dSql += '                ,A.ADJUST_OUT_QTY_BATCH, A.ADJUST_OUT_QTY_KG        ' + char(10)
            SELECT @v_dSql += '                ,A.JOB_USER_ID, A.JOB_TIME, A.JOB_TYPE, A.JOB_ORDER ' + char(10)
            SELECT @v_dSql += '                ,CASE WHEN A.COMPANY_ID IS NULL THEN ''Building'' ELSE '''' END AS MSG1    ' + char(10)
            SELECT @v_dSql += '                ,CASE WHEN B.ITEM_ID IS NULL THEN ''Material'' ELSE '''' END AS MSG2       ' + char(10)
            SELECT @v_dSql += '                ,CASE WHEN C.OPERATION_ID IS NULL THEN ''Operation'' ELSE '''' END AS MSG3 ' + char(10)
            SELECT @v_dSql += '                ,CASE WHEN D.LINE_ID IS NULL THEN ''Line or Electrode Type'' ELSE '''' END AS MSG4 ' + char(10)
            SELECT @v_dSql += '                ,CASE WHEN E.CODE_ID IS NULL THEN ''Production Type'' ELSE '''' END AS MSG5        ' + char(10)
            SELECT @v_dSql += '                ,CASE WHEN F.CODE_ID IS NULL THEN ''Market'' ELSE '''' END AS MSG6                 ' + char(10)
            SELECT @v_dSql += '                ,CASE WHEN L.EQUIPMENT_ID IS NULL THEN ''Equipment'' ELSE '''' END AS MSG7         ' + char(10)
            SELECT @v_dSql += '                ,'''' AS MSG8 ' + char(10)
            SELECT @v_dSql += '                ,'''' AS MSG9 ' + char(10)
            SELECT @v_dSql += '                ,CASE WHEN A.QTY > 0 THEN ( CASE WHEN I.LINE_ID IS NULL THEN ''Line Assign'' ELSE '''' END ) ELSE '''' END AS MSG10 ' + char(10)
            SELECT @v_dSql += '                ,CASE WHEN A.QTY > 0 THEN ( CASE WHEN K.KEY_VALUE = ''DAILY_CAPA'' THEN (CASE WHEN (J.DAILY_CAPA IS NULL OR J.DAILY_CAPA = 0) THEN ''Daily Capa'' ELSE '''' END) ' + char(10)
            SELECT @v_dSql += '                                                 ELSE (CASE WHEN (J.TACT_TIME IS NULL OR J.TACT_TIME = 0) THEN ''Tact Time'' ELSE '''' END) END ) ELSE '''' END AS MSG11   ' + char(10)                                              
            SELECT @v_dSql += '                ,CASE WHEN M.ITEM_ID IS NULL THEN ''Model Measure Conversion'' ELSE '''' END AS MSG12 ' + char(10)
            SELECT @v_dSql += '                ,CASE WHEN ROW_NUMBER() OVER(PARTITION BY A.FACTORY_ID, A.ITEM_ID, A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.MARKET, A.PLAN_DATE ' + char(10)
            SELECT @v_dSql += '                		                             ORDER BY     A.FACTORY_ID, A.ITEM_ID, A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.MARKET, A.PLAN_DATE)>1 THEN ''Data Overlap'' ' + char(10)
            SELECT @v_dSql += '                		      ELSE '''' END AS MSG99   ' + char(10)
            SELECT @v_dSql += '           FROM (                                   ' + char(10)
            SELECT @v_dSql += '                 SELECT A.INSTANCE_ID, A.FP_PLAN_ID ' + char(10)
            SELECT @v_dSql += '                      , ISNULL(B.COMPANY_ID,''-'') AS COMPANY_ID, ISNULL(B.DIVISION_ID,''-'') AS DIVISION_ID, ISNULL(B.SITE_ID,''-'') AS SITE_ID, ISNULL(B.PLANT_ID,''-'') AS PLANT_ID ' + char(10)
            SELECT @v_dSql += '                      , A.FACTORY_ID, A.LOCATION                                    ' + char(10)
            SELECT @v_dSql += '                      , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID ' + char(10)
            SELECT @v_dSql += '                      , CONVERT(VARCHAR, A.PLAN_DATE, 112) AS PLAN_DATE             ' + char(10)
            SELECT @v_dSql += '                      , A.TOP_ITEM_ID, A.ITEM_ID                           ' + char(10)
            SELECT @v_dSql += '                      , A.PRODUCTION_TYPE, A.MARKET                        ' + char(10)
            SELECT @v_dSql += '                      , A.SEQ, A.QTY                                       ' + char(10)
            SELECT @v_dSql += '                      , A.ADJUST_OUT_QTY_BATCH, A.ADJUST_OUT_QTY_KG        ' + char(10)
            SELECT @v_dSql += '                      , A.JOB_USER_ID, A.JOB_TIME, A.JOB_TYPE, A.JOB_ORDER ' + char(10)
            SELECT @v_dSql += '                 FROM   BUF_AMEND_DAILY_PLAN_R A WITH(NOLOCK)              ' + char(10)
            SELECT @v_dSql += '                 LEFT OUTER JOIN SCM_FACTORY_M B WITH(NOLOCK)              ' + char(10)
            SELECT @v_dSql += '                 ON    A.DIVISION_ID = B.DIVISION_ID            ' + char(10)
            SELECT @v_dSql += '                 AND   A.SITE_ID     = B.SITE_ID                ' + char(10)
            SELECT @v_dSql += '                 AND   A.PLANT_ID    = B.PLANT_ID               ' + char(10)
            SELECT @v_dSql += '                 AND 	A.FACTORY_ID  = B.FACTORY_ID           ' + char(10)
            SELECT @v_dSql += '                 AND   B.ACTIVE_FLAG = ''Y''                    ' + char(10)
            SELECT @v_dSql += '                 WHERE A.JOB_USER_ID = '''+ @p_user_id +'''     ' + char(10)
            SELECT @v_dSql += '                 AND   A.INSTANCE_ID = '''+ @p_instance_id +''' ' + char(10)
            SELECT @v_dSql += '           ) A                                                  ' + char(10)
            SELECT @v_dSql += '           LEFT OUTER JOIN (                                    ' + char(10)
            SELECT @v_dSql += '                  SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID,  ' + char(10)
            SELECT @v_dSql += '                         A.ITEM_ID, ISNULL(A.NICK_NAME,''-'') AS NICK_NAME ' + char(10)
            SELECT @v_dSql += '                  FROM	 SCM_ITEM_M A WITH(NOLOCK),      ' + char(10)
            SELECT @v_dSql += '                    		 SCM_ITEM_CLASS_M C WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += '                  WHERE	 A.ITEM_CLASS  = C.CLASS_ID      ' + char(10)
            SELECT @v_dSql += '           ) B                                            ' + char(10)
            SELECT @v_dSql += '           ON  A.COMPANY_ID      = B.COMPANY_ID           ' + char(10)
            SELECT @v_dSql += '           AND A.DIVISION_ID     = B.DIVISION_ID          ' + char(10)
            SELECT @v_dSql += '           AND A.SITE_ID         = B.SITE_ID              ' + char(10)
            SELECT @v_dSql += '           AND A.ITEM_ID         = B.ITEM_ID              ' + char(10)
            SELECT @v_dSql += '           LEFT OUTER JOIN SCM_OPERATION_M C WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += '           ON  A.COMPANY_ID      = C.COMPANY_ID           ' + char(10)
            SELECT @v_dSql += '           AND A.DIVISION_ID     = C.DIVISION_ID          ' + char(10)
            SELECT @v_dSql += '           AND A.SITE_ID         = C.SITE_ID              ' + char(10)
            SELECT @v_dSql += '           AND A.OPERATION_ID    = C.OPERATION_ID         ' + char(10)
            SELECT @v_dSql += '           AND C.ACTIVE_FLAG     = ''Y''                  ' + char(10)
            SELECT @v_dSql += '           LEFT OUTER JOIN SCM_LINE_M D WITH(NOLOCK)      ' + char(10)
            SELECT @v_dSql += '           ON  A.COMPANY_ID      = D.COMPANY_ID           ' + char(10)
            SELECT @v_dSql += '           AND A.DIVISION_ID     = D.DIVISION_ID          ' + char(10)
            SELECT @v_dSql += '           AND A.SITE_ID         = D.SITE_ID              ' + char(10)
            SELECT @v_dSql += '           AND A.PLANT_ID        = D.PLANT_ID             ' + char(10)
            SELECT @v_dSql += '           AND A.FACTORY_ID      = D.FACTORY_ID           ' + char(10)
            SELECT @v_dSql += '           AND A.OPERATION_ID    = D.OPERATION_ID         ' + char(10)
            SELECT @v_dSql += '           AND A.LINE_ID         = D.LINE_ID              ' + char(10)
            SELECT @v_dSql += '           AND A.ELECTRODE_TYPE  = D.ELECTRODE_TYPE       ' + char(10)
            SELECT @v_dSql += '           AND D.ACTIVE_FLAG     = ''Y''                  ' + char(10)
            SELECT @v_dSql += '           LEFT OUTER JOIN (                              ' + char(10)
            SELECT @v_dSql += '                  SELECT DISTINCT  A.SEGMENT1, A.ATTRIBUTE2 AS CODE_ID ' + char(10)
            SELECT @v_dSql += '                  FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)           ' + char(10)
            SELECT @v_dSql += '                  WHERE  A.LOOKUP_TYPE_CODE = ''DIVISION_DEMAND_TYPE'' ' + char(10)
            SELECT @v_dSql += '                  AND    A.ACTIVE_FLAG      = ''Y''                    ' + char(10)
            SELECT @v_dSql += '           ) E                               ' + char(10)
            SELECT @v_dSql += '           ON  A.PRODUCTION_TYPE = E.CODE_ID ' + char(10)
            SELECT @v_dSql += '           AND A.DIVISION_ID = E.SEGMENT1    ' + char(10)
            SELECT @v_dSql += '           AND (CASE WHEN A.SITE_ID <> ''A004'' AND A.PRODUCTION_TYPE IN (''E-TEST'',''D-TEST'') THEN ''XX'' ELSE A.PRODUCTION_TYPE END ) = E.CODE_ID ' + char(10)
            SELECT @v_dSql += '           LEFT OUTER JOIN (                                         ' + char(10)
            SELECT @v_dSql += '                  SELECT A.SEGMENT1 AS CODE_ID                       ' + char(10)
            SELECT @v_dSql += '                  FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)         ' + char(10)
            SELECT @v_dSql += '                  WHERE  A.LOOKUP_TYPE_CODE = ''DEMAND_MARKET_TYPE'' ' + char(10)
            SELECT @v_dSql += '                  AND    A.ACTIVE_FLAG      = ''Y''                  ' + char(10)
            SELECT @v_dSql += '           ) F                                                       ' + char(10)
            SELECT @v_dSql += '           ON  A.MARKET = F.CODE_ID                                  ' + char(10)
            SELECT @v_dSql += '           LEFT OUTER JOIN (                                         ' + char(10)
            SELECT @v_dSql += '                  SELECT DISTINCT INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID ' + char(10)
            SELECT @v_dSql += '                  FROM   FP_INSTANCE_ITEM_V  ' + char(10)
            SELECT @v_dSql += '           ) G                               ' + char(10)
            SELECT @v_dSql += '           ON  A.INSTANCE_ID = G.INSTANCE_ID ' + char(10)
            SELECT @v_dSql += '           AND A.COMPANY_ID  = G.COMPANY_ID  ' + char(10)
            SELECT @v_dSql += '           AND A.DIVISION_ID = G.DIVISION_ID ' + char(10)
            SELECT @v_dSql += '           AND A.SITE_ID     = G.SITE_ID     ' + char(10)
            SELECT @v_dSql += '           AND A.PLANT_ID    = G.PLANT_ID    ' + char(10)
            SELECT @v_dSql += '           AND A.ITEM_ID     = G.ITEM_ID     ' + char(10)
            SELECT @v_dSql += '           LEFT OUTER JOIN (                 ' + char(10)
            SELECT @v_dSql += '                  SELECT DISTINCT H.*        ' + char(10)
            SELECT @v_dSql += '                  FROM (                     ' + char(10)
            SELECT @v_dSql += '                        SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(A.MARKET,''D'') AS MARKET, A.ITEM_ID ' + char(10)
            SELECT @v_dSql += '                        FROM   FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += '                        WHERE  (A.DIVISION_ID+A.SHOP_GROUP_ID+A.SCP_PLAN_ID) IN (SELECT A.DIVISION_ID+A.SHOP_GROUP_ID+MAX(A.SCP_PLAN_ID) AS SCP_PLAN_ID FROM FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H A WITH(NOLOCK) GROUP BY A.DIVISION_ID, A.SHOP_GROUP_ID) ' + char(10)
            SELECT @v_dSql += '                        UNION ALL ' + char(10)
            SELECT @v_dSql += '                        SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(A.MARKET,''D'') AS MARKET, A.ITEM_ID ' + char(10)
            SELECT @v_dSql += '                        FROM   FP_WEEKLY_DEMAND_SHIPMENT_AUTO_H A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += '                        WHERE  A.SCP_PLAN_ID = (SELECT MAX(SCP_PLAN_ID) AS SCP_PLAN_ID FROM FP_WEEKLY_DEMAND_SHIPMENT_AUTO_H A WITH(NOLOCK)) ' + char(10)
            SELECT @v_dSql += '                        UNION ALL ' + char(10)
            SELECT @v_dSql += '                        SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(A.MARKET,''D'') AS MARKET, A.ITEM_ID ' + char(10)
            SELECT @v_dSql += '                        FROM   FP_WEEKLY_DEMAND_PRODUCT_TEST_H A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += '                        WHERE  A.DUE_DATE >= ( SELECT CONVERT(DATETIME,CONVERT(VARCHAR,PLAN_START_TIME,112)) ' + char(10)
            SELECT @v_dSql += '                                               FROM   SCM_FP_PLAN_H ' + char(10)
            SELECT @v_dSql += '                                               WHERE  PLAN_ID = '''+ @p_plan_id +''' ) ' + char(10)
            SELECT @v_dSql += '                        UNION ALL ' + char(10)
            SELECT @v_dSql += '                        SELECT  DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(A.MARKET,''D'') AS MARKET, A.ITEM_ID ' + char(10)
            SELECT @v_dSql += '                        FROM   FP_DAILY_INSTANCE_DEMAND_H A ' + char(10)
            SELECT @v_dSql += '                        WHERE  1=1 ' + char(10)
            SELECT @v_dSql += '                        AND   INSTANCE_ID = CASE WHEN '''+ @p_instance_id +''' = ''KR_E_PRE_A'' OR '''+ @p_instance_id +''' = ''KR_E_PRE_M'' THEN ''KR_E_PRE'' ' + char(10)
            SELECT @v_dSql += '                                            ELSE '''+ @p_instance_id +''' END                                      ' + char(10)
            SELECT @v_dSql += '                        AND   INSTANCE_DATE = '''+ @p_plan_date +'''                                               ' + char(10)
            SELECT @v_dSql += '                        AND   CONVERT(VARCHAR, INSTANCE_DATE,102) = ( SELECT CONVERT(VARCHAR, PLAN_START_TIME,102) ' + char(10)
            SELECT @v_dSql += '                                                                      FROM   SCM_FP_PLAN_H                         ' + char(10)
            SELECT @v_dSql += '                                                                      WHERE  PLAN_ID = '''+ @p_plan_id +'''        ' + char(10)
            SELECT @v_dSql += '                                                                      )                                            ' + char(10)
            SELECT @v_dSql += '                  ) H                        ' + char(10)
            SELECT @v_dSql += '           ) H                               ' + char(10)
            SELECT @v_dSql += '           ON  A.COMPANY_ID  = H.COMPANY_ID  ' + char(10)
            SELECT @v_dSql += '           AND A.DIVISION_ID = H.DIVISION_ID ' + char(10)
            SELECT @v_dSql += '           AND A.SITE_ID     = H.SITE_ID     ' + char(10)
            SELECT @v_dSql += '           AND A.PLANT_ID    = H.PLANT_ID    ' + char(10)
            SELECT @v_dSql += '           AND A.MARKET      = H.MARKET      ' + char(10)
            SELECT @v_dSql += '           AND A.ITEM_ID     = H.ITEM_ID     ' + char(10)
            SELECT @v_dSql += '           LEFT OUTER JOIN SCM_ITEM_LINE_ASSIGN_M I WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += '           ON  A.COMPANY_ID     = I.COMPANY_ID      ' + char(10)
            SELECT @v_dSql += '           AND A.DIVISION_ID    = I.DIVISION_ID     ' + char(10)
            SELECT @v_dSql += '           AND A.SITE_ID        = I.SITE_ID         ' + char(10)
            SELECT @v_dSql += '           AND A.PLANT_ID       = I.PLANT_ID        ' + char(10)
            SELECT @v_dSql += '           AND A.FACTORY_ID     = I.FACTORY_ID      ' + char(10)
            SELECT @v_dSql += '           AND A.ITEM_ID        = I.ITEM_ID         ' + char(10)
            SELECT @v_dSql += '           AND A.OPERATION_ID   = I.OPERATION_ID    ' + char(10)
            SELECT @v_dSql += '           AND A.LINE_ID        = I.LINE_ID         ' + char(10)
            SELECT @v_dSql += '           AND A.ELECTRODE_TYPE = I.ELECTRODE_TYPE  ' + char(10)
            SELECT @v_dSql += '           AND SUBSTRING(A.PLAN_DATE,1,6) = I.MONTH ' + char(10)
            SELECT @v_dSql += '           AND I.ACTIVE_FLAG    = ''Y''             ' + char(10)
            SELECT @v_dSql += '           AND I.PRIORITY NOT IN (''0'',''9'')      ' + char(10)
            SELECT @v_dSql += '           LEFT OUTER JOIN SCM_TACT_TIME_M J WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += '           ON  A.COMPANY_ID      = J.COMPANY_ID           ' + char(10)
            SELECT @v_dSql += '           AND A.DIVISION_ID     = J.DIVISION_ID          ' + char(10)
            SELECT @v_dSql += '           AND A.SITE_ID         = J.SITE_ID              ' + char(10)
            SELECT @v_dSql += '           AND A.PLANT_ID        = J.PLANT_ID             ' + char(10)
            SELECT @v_dSql += '           AND A.FACTORY_ID      = J.FACTORY_ID           ' + char(10)
            SELECT @v_dSql += '           AND A.ITEM_ID         = J.ITEM_ID              ' + char(10)
            SELECT @v_dSql += '           AND A.OPERATION_ID    = J.OPERATION_ID         ' + char(10)
            SELECT @v_dSql += '           AND A.LINE_ID         = J.LINE_ID              ' + char(10)
            SELECT @v_dSql += '           AND A.ELECTRODE_TYPE  = J.ELECTRODE_TYPE       ' + char(10)
            SELECT @v_dSql += '           AND SUBSTRING(A.PLAN_DATE,1,6) = J.MONTH       ' + char(10)
            SELECT @v_dSql += '           LEFT OUTER JOIN FP_INSTANCE_CONFIG_M K WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += '           ON  A.INSTANCE_ID     = K.INSTANCE_ID          ' + char(10)
            SELECT @v_dSql += '           AND K.KEY_ID          = ''FINAL_OP_CAPA''      ' + char(10)
            SELECT @v_dSql += '           LEFT OUTER JOIN SCM_EQUIPMENT_M L WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += '           ON  A.COMPANY_ID      = L.COMPANY_ID           ' + char(10)
            SELECT @v_dSql += '           AND A.DIVISION_ID     = L.DIVISION_ID          ' + char(10)
            SELECT @v_dSql += '           AND A.SITE_ID         = L.SITE_ID              ' + char(10)
            SELECT @v_dSql += '           AND A.PLANT_ID        = L.PLANT_ID             ' + char(10)
            SELECT @v_dSql += '           AND A.FACTORY_ID      = L.FACTORY_ID           ' + char(10)
            SELECT @v_dSql += '           AND A.OPERATION_ID    = L.OPERATION_ID         ' + char(10)
            SELECT @v_dSql += '           AND A.LINE_ID		    = L.LINE_ID              ' + char(10)
            SELECT @v_dSql += '           AND A.EQUIPMENT_ID    = L.EQUIPMENT_ID         ' + char(10)
            SELECT @v_dSql += '           AND L.ACTIVE_FLAG 	= ''Y''                  ' + char(10)
            SELECT @v_dSql += '           LEFT OUTER JOIN (                              ' + char(10)
            SELECT @v_dSql += '               SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
            SELECT @v_dSql += '                         , A.OPERATION_ID, A.ITEM_ID               ' + char(10)
            SELECT @v_dSql += '                   FROM SCM_ITEM_EQUIP_RATE_BATCH_M A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += '                   WHERE 1=1                    ' + char(10)
            SELECT @v_dSql += '           ) M                                  ' + char(10)
            SELECT @v_dSql += '           ON  A.COMPANY_ID    = M.COMPANY_ID   ' + char(10)
            SELECT @v_dSql += '           AND A.DIVISION_ID   = M.DIVISION_ID  ' + char(10)
            SELECT @v_dSql += '           AND A.SITE_ID       = M.SITE_ID      ' + char(10)
            SELECT @v_dSql += '           AND A.PLANT_ID      = M.PLANT_ID     ' + char(10)
            SELECT @v_dSql += '           AND A.FACTORY_ID    = M.FACTORY_ID   ' + char(10)
            SELECT @v_dSql += '           AND A.OPERATION_ID  = M.OPERATION_ID ' + char(10)
            SELECT @v_dSql += '           AND A.ITEM_ID       = M.ITEM_ID      ' + char(10)
            SELECT @v_dSql += '       ) TT                                     ' + char(10)
            SELECT @v_dSql += ' ) A                                            ' + char(10)
            SELECT @v_dSql += ' ORDER BY A.JOB_ORDER                           ' + char(10)

           IF @p_sys_type = 'SQL'
               BEGIN
                   --EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
                   SELECT @v_dSql as [QUERY_VALUE]
               END  
           ELSE 
               BEGIN
                   SET @runstart = GetDate()
                   --쿼리실행
                   EXEC sp_executesql @v_dSql
                   
                   SET @runend = GetDate()
                   EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql,'select',@runstart, @runend
               END	
       END

	/************************************************************************************************/
	/* SELECT인경우 :SELECT_VALID_ROW     TYPE인경우                                                */
	/* MODEL : ROW / DEV TYPE 인경우( )                                                             */
	/* LINE  : ROW / DEV TYPE 인경우( )                                                             */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='SELECT_VALID_ROW_DEV')
        BEGIN --IF(START)
            SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT A.* ' + char(10)
                SELECT @v_dSql += '     ,CASE WHEN __MSG = '' Not Found'' THEN (CASE WHEN MSG99 = '''' THEN '''' ELSE MSG99 END) ' + char(10)
                SELECT @v_dSql += '           ELSE (CASE WHEN MSG99 = '''' THEN __MSG ELSE __MSG + '' AND '' + MSG99 END)        ' + char(10)
                SELECT @v_dSql += '           END AS _MSG                                                                        ' + char(10)
                SELECT @v_dSql += '     ,CASE WHEN __MSG = '' Not Found'' AND MSG99 = '''' THEN ''Y'' ELSE ''N'' END AS _VALID   ' + char(10)
                SELECT @v_dSql += ' FROM (            ' + char(10)
                SELECT @v_dSql += '       SELECT TT.* ' + char(10)
                SELECT @v_dSql += '           ,MSG1   ' + char(10)
                SELECT @v_dSql += '           +(CASE WHEN (MSG1 = '''')                                                                                                                                               THEN MSG2 ELSE (CASE WHEN MSG2 = '''' THEN '''' ELSE '','' + MSG2 END) END) ' + char(10)
                SELECT @v_dSql += '           +(CASE WHEN (MSG1 = '''' AND MSG2 = '''')                                                                                                                                 THEN MSG3 ELSE (CASE WHEN MSG3 = '''' THEN '''' ELSE '','' + MSG3 END) END) ' + char(10)
                SELECT @v_dSql += '           +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''')                                                                                                                   THEN MSG4 ELSE (CASE WHEN MSG4 = '''' THEN '''' ELSE '','' + MSG4 END) END) ' + char(10)
                SELECT @v_dSql += '           +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''')                                                                                                     THEN MSG5 ELSE (CASE WHEN MSG5 = '''' THEN '''' ELSE '','' + MSG5 END) END) ' + char(10)
                SELECT @v_dSql += '           +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = '''')                                                                                       THEN MSG6 ELSE (CASE WHEN MSG6 = '''' THEN '''' ELSE '','' + MSG6 END) END) ' + char(10)
                SELECT @v_dSql += '           +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = '''' AND MSG6 = '''')                                                                         THEN MSG7 ELSE (CASE WHEN MSG7 = '''' THEN '''' ELSE '','' + MSG7 END) END) ' + char(10)
                SELECT @v_dSql += '           +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = '''' AND MSG6 = '''' AND MSG7 = '''')                                                           THEN MSG8 ELSE (CASE WHEN MSG8 = '''' THEN '''' ELSE '','' + MSG8 END) END) ' + char(10)
                SELECT @v_dSql += '           +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = '''' AND MSG6 = '''' AND MSG7 = '''' AND MSG8 = '''')                                             THEN MSG9 ELSE (CASE WHEN MSG9 = '''' THEN '''' ELSE '','' + MSG9 END) END) ' + char(10)
                SELECT @v_dSql += '           +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = '''' AND MSG6 = '''' AND MSG7 = '''' AND MSG8 = '''' AND MSG9 = '''')                               THEN MSG10 ELSE (CASE WHEN MSG10 = '''' THEN '''' ELSE '','' + MSG10 END) END) ' + char(10)
                SELECT @v_dSql += '           +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = '''' AND MSG6 = '''' AND MSG7 = '''' AND MSG8 = '''' AND MSG9 = '''' AND MSG10 = '''')                THEN MSG11 ELSE (CASE WHEN MSG11 = '''' THEN '''' ELSE '','' + MSG11 END) END) ' + char(10)
                SELECT @v_dSql += '           +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4 = '''' AND MSG5 = '''' AND MSG6 = '''' AND MSG7 = '''' AND MSG8 = '''' AND MSG9 = '''' AND MSG10 = '''' AND MSG11 = '''') THEN MSG12 ELSE (CASE WHEN MSG12 = '''' THEN '''' ELSE '','' + MSG12 END) END) ' + char(10)
                SELECT @v_dSql += '           + '' Not Found'' AS __MSG                                 ' + char(10)
                SELECT @v_dSql += '       FROM (                                                        ' + char(10)
                SELECT @v_dSql += '             SELECT DISTINCT A.INSTANCE_ID, A.FP_PLAN_ID             ' + char(10)
                SELECT @v_dSql += '                 ,A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
                SELECT @v_dSql += '                 ,A.FACTORY_ID, A.LOCATION                           ' + char(10)
                SELECT @v_dSql += '                 ,A.OPERATION_ID, A.LINE_ID, D.LINE_NAME, A.ELECTRODE_TYPE, A.EQUIPMENT_ID ' + char(10)
                SELECT @v_dSql += '                 ,A.PLAN_DATE                                        ' + char(10)
                SELECT @v_dSql += '                 ,A.TOP_ITEM_ID, A.ITEM_ID, B.NICK_NAME              ' + char(10)
                SELECT @v_dSql += '                 ,A.PRODUCTION_TYPE, A.MARKET                        ' + char(10)
                SELECT @v_dSql += '                 ,A.SEQ, A.QTY                                       ' + char(10)
                SELECT @v_dSql += '                 ,A.ADJUST_IN_QTY_BATCH, A.ADJUST_IN_QTY_KG          ' + char(10)
                SELECT @v_dSql += '                 ,A.JOB_USER_ID, A.JOB_TIME, A.JOB_TYPE, A.JOB_ORDER ' + char(10)
                SELECT @v_dSql += '                 ,CASE WHEN A.COMPANY_ID IS NULL THEN ''Building'' ELSE '''' END AS MSG1            ' + char(10)
                SELECT @v_dSql += '                 ,CASE WHEN B.ITEM_ID IS NULL THEN ''Material'' ELSE '''' END AS MSG2               ' + char(10)
                SELECT @v_dSql += '                 ,CASE WHEN C.OPERATION_ID IS NULL THEN ''Operation'' ELSE '''' END AS MSG3         ' + char(10)
                SELECT @v_dSql += '                 ,CASE WHEN D.LINE_ID IS NULL THEN ''Line or Electrode Type'' ELSE '''' END AS MSG4 ' + char(10)
                SELECT @v_dSql += '                 ,CASE WHEN E.CODE_ID IS NULL THEN ''Production Type'' ELSE '''' END AS MSG5 ' + char(10)
                SELECT @v_dSql += '                 ,CASE WHEN F.CODE_ID IS NULL THEN ''Market'' ELSE '''' END AS MSG6          ' + char(10)
                SELECT @v_dSql += '                 ,CASE WHEN L.EQUIPMENT_ID IS NULL THEN ''Equipment'' ELSE '''' END AS MSG7  ' + char(10)
                SELECT @v_dSql += '                 ,'''' AS MSG8 ' + char(10)
                SELECT @v_dSql += '                 ,'''' AS MSG9 ' + char(10)
                SELECT @v_dSql += '                 ,CASE WHEN A.QTY > 0 THEN ( CASE WHEN I.LINE_ID IS NULL THEN ''Line Assign'' ELSE '''' END ) ELSE '''' END AS MSG10 ' + char(10)
                SELECT @v_dSql += '                 ,CASE WHEN A.QTY > 0 THEN ( CASE WHEN K.KEY_VALUE = ''DAILY_CAPA'' THEN (CASE WHEN (J.DAILY_CAPA IS NULL OR J.DAILY_CAPA = 0) THEN ''Daily Capa'' ELSE '''' END) ' + char(10)
                SELECT @v_dSql += '                       ELSE (CASE WHEN (J.TACT_TIME IS NULL OR J.TACT_TIME = 0) THEN ''Tact Time'' ELSE '''' END) END ) ELSE '''' END AS MSG11 ' + char(10)
                SELECT @v_dSql += '                 ,CASE WHEN M.ITEM_ID IS NULL THEN ''Model Measure Conversion'' ELSE '''' END AS MSG12 ' + char(10)
                SELECT @v_dSql += '                 ,CASE WHEN ROW_NUMBER() OVER(PARTITION BY A.FACTORY_ID, A.ITEM_ID, A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.MARKET, A.PLAN_DATE ' + char(10)
                SELECT @v_dSql += '                                ORDER BY   A.FACTORY_ID, A.ITEM_ID, A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.MARKET, A.PLAN_DATE)>1 THEN ''Data Overlap'' ' + char(10)
                SELECT @v_dSql += '                       ELSE '''' END AS MSG99         ' + char(10)
                SELECT @v_dSql += '             FROM (                                   ' + char(10)
                SELECT @v_dSql += '                   SELECT A.INSTANCE_ID, A.FP_PLAN_ID ' + char(10)
                SELECT @v_dSql += '                       , ISNULL(B.COMPANY_ID,''-'') AS COMPANY_ID, ISNULL(B.DIVISION_ID,''-'') AS DIVISION_ID, ISNULL(B.SITE_ID,''-'') AS SITE_ID, ISNULL(B.PLANT_ID,''-'') AS PLANT_ID ' + char(10)
                SELECT @v_dSql += '                       , A.FACTORY_ID, A.LOCATION                                    ' + char(10)
                SELECT @v_dSql += '                       , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID ' + char(10)
                SELECT @v_dSql += '                       , CONVERT(VARCHAR, A.PLAN_DATE, 112) AS PLAN_DATE             ' + char(10)
                SELECT @v_dSql += '                       , A.TOP_ITEM_ID, A.ITEM_ID                                    ' + char(10)
                SELECT @v_dSql += '                       , A.PRODUCTION_TYPE, A.MARKET                                 ' + char(10)
                SELECT @v_dSql += '                       , A.SEQ, A.QTY                                                ' + char(10)
                SELECT @v_dSql += '                       , A.ADJUST_IN_QTY_BATCH, A.ADJUST_IN_QTY_KG                   ' + char(10)
                SELECT @v_dSql += '                       , A.JOB_USER_ID, A.JOB_TIME, A.JOB_TYPE, A.JOB_ORDER          ' + char(10)
                SELECT @v_dSql += '                   FROM   BUF_AMEND_DAILY_PLAN_R A WITH(NOLOCK)    ' + char(10)
                SELECT @v_dSql += '                   LEFT OUTER JOIN SCM_FACTORY_M B WITH(NOLOCK)    ' + char(10)
                SELECT @v_dSql += '                   ON    A.DIVISION_ID  = B.DIVISION_ID            ' + char(10)
                SELECT @v_dSql += '                   AND   A.SITE_ID      = B.SITE_ID                ' + char(10)
                SELECT @v_dSql += '                   AND   A.PLANT_ID     = B.PLANT_ID               ' + char(10)
                SELECT @v_dSql += '                   AND   A.FACTORY_ID   = B.FACTORY_ID             ' + char(10)
                SELECT @v_dSql += '                   AND   B.ACTIVE_FLAG  = ''Y''                    ' + char(10)
                SELECT @v_dSql += '                   WHERE A.JOB_USER_ID  = '''+ @p_user_id +'''     ' + char(10)
                SELECT @v_dSql += '                   AND   A.INSTANCE_ID  = '''+ @p_instance_id +''' ' + char(10)
                SELECT @v_dSql += '             ) A               ' + char(10)
                SELECT @v_dSql += '             LEFT OUTER JOIN ( ' + char(10)
                SELECT @v_dSql += '                   SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, ' + char(10)
                SELECT @v_dSql += '                        A.ITEM_ID, ISNULL(A.NICK_NAME,''-'') AS NICK_NAME  ' + char(10)
                SELECT @v_dSql += '                   FROM   SCM_ITEM_M A WITH(NOLOCK),                       ' + char(10)
                SELECT @v_dSql += '                          SCM_ITEM_CLASS_M C WITH(NOLOCK)                  ' + char(10)
                SELECT @v_dSql += '                   WHERE  A.ITEM_CLASS  = C.CLASS_ID                       ' + char(10)
                SELECT @v_dSql += '             ) B                                            ' + char(10)
                SELECT @v_dSql += '             ON  A.COMPANY_ID      = B.COMPANY_ID           ' + char(10)
                SELECT @v_dSql += '             AND A.DIVISION_ID     = B.DIVISION_ID          ' + char(10)
                SELECT @v_dSql += '             AND A.SITE_ID         = B.SITE_ID              ' + char(10)
                SELECT @v_dSql += '             AND A.ITEM_ID         = B.ITEM_ID              ' + char(10)
                SELECT @v_dSql += '             LEFT OUTER JOIN SCM_OPERATION_M C WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '             ON  A.COMPANY_ID      = C.COMPANY_ID           ' + char(10)
                SELECT @v_dSql += '             AND A.DIVISION_ID     = C.DIVISION_ID          ' + char(10)
                SELECT @v_dSql += '             AND A.SITE_ID         = C.SITE_ID              ' + char(10)
                SELECT @v_dSql += '             AND A.OPERATION_ID    = C.OPERATION_ID         ' + char(10)
                SELECT @v_dSql += '             AND C.ACTIVE_FLAG     = ''Y''                  ' + char(10)
                SELECT @v_dSql += '             LEFT OUTER JOIN SCM_LINE_M D WITH(NOLOCK)      ' + char(10)
                SELECT @v_dSql += '             ON  A.COMPANY_ID      = D.COMPANY_ID           ' + char(10)
                SELECT @v_dSql += '             AND A.DIVISION_ID     = D.DIVISION_ID          ' + char(10)
                SELECT @v_dSql += '             AND A.SITE_ID         = D.SITE_ID              ' + char(10)
                SELECT @v_dSql += '             AND A.PLANT_ID        = D.PLANT_ID             ' + char(10)
                SELECT @v_dSql += '             AND A.FACTORY_ID      = D.FACTORY_ID           ' + char(10)
                SELECT @v_dSql += '             AND A.OPERATION_ID    = D.OPERATION_ID         ' + char(10)
                SELECT @v_dSql += '             AND A.LINE_ID         = D.LINE_ID              ' + char(10)
                SELECT @v_dSql += '             AND A.ELECTRODE_TYPE  = D.ELECTRODE_TYPE       ' + char(10)
                SELECT @v_dSql += '             AND D.ACTIVE_FLAG     = ''Y''                  ' + char(10)
                SELECT @v_dSql += '             LEFT OUTER JOIN (                              ' + char(10)
                SELECT @v_dSql += '                    SELECT DISTINCT  A.SEGMENT1, A.ATTRIBUTE2 AS CODE_ID ' + char(10)
                SELECT @v_dSql += '                    FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)           ' + char(10)
                SELECT @v_dSql += '                    WHERE  A.LOOKUP_TYPE_CODE = ''DIVISION_DEMAND_TYPE'' ' + char(10)
                SELECT @v_dSql += '                    AND    A.ACTIVE_FLAG = ''Y''                         ' + char(10)
                SELECT @v_dSql += '             ) E                               ' + char(10)
                SELECT @v_dSql += '             ON  A.PRODUCTION_TYPE = E.CODE_ID ' + char(10)
                SELECT @v_dSql += '             AND A.DIVISION_ID = E.SEGMENT1    ' + char(10)
                SELECT @v_dSql += '             AND (CASE WHEN A.SITE_ID <> ''A004'' AND A.PRODUCTION_TYPE IN (''E-TEST'',''D-TEST'') THEN ''XX'' ELSE A.PRODUCTION_TYPE END ) = E.CODE_ID ' + char(10)
                SELECT @v_dSql += '             LEFT OUTER JOIN (                                         ' + char(10)
                SELECT @v_dSql += '                    SELECT A.SEGMENT1 AS CODE_ID                       ' + char(10)
                SELECT @v_dSql += '                    FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)         ' + char(10)
                SELECT @v_dSql += '                    WHERE  A.LOOKUP_TYPE_CODE = ''DEMAND_MARKET_TYPE'' ' + char(10)
                SELECT @v_dSql += '                    AND    A.ACTIVE_FLAG = ''Y''                       ' + char(10)
                SELECT @v_dSql += '             ) F                      ' + char(10)
                SELECT @v_dSql += '             ON  A.MARKET = F.CODE_ID ' + char(10)
                SELECT @v_dSql += '             LEFT OUTER JOIN (        ' + char(10)
                SELECT @v_dSql += '                   SELECT DISTINCT INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID ' + char(10)
                SELECT @v_dSql += '                   FROM   FP_INSTANCE_ITEM_V                                                        ' + char(10)
                SELECT @v_dSql += '             ) G                               ' + char(10)
                SELECT @v_dSql += '             ON  A.INSTANCE_ID = G.INSTANCE_ID ' + char(10)
                SELECT @v_dSql += '             AND A.COMPANY_ID  = G.COMPANY_ID  ' + char(10)
                SELECT @v_dSql += '             AND A.DIVISION_ID = G.DIVISION_ID ' + char(10)
                SELECT @v_dSql += '             AND A.SITE_ID     = G.SITE_ID     ' + char(10)
                SELECT @v_dSql += '             AND A.PLANT_ID    = G.PLANT_ID    ' + char(10)
                SELECT @v_dSql += '             AND A.ITEM_ID     = G.ITEM_ID     ' + char(10)
                SELECT @v_dSql += '             LEFT OUTER JOIN (                 ' + char(10)
                SELECT @v_dSql += '                    SELECT DISTINCT H.*        ' + char(10)
                SELECT @v_dSql += '                    FROM (                     ' + char(10)
                SELECT @v_dSql += '                        SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(A.MARKET,''D'') AS MARKET, A.ITEM_ID ' + char(10)
                SELECT @v_dSql += '                        FROM   FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H A WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '                        WHERE  (A.DIVISION_ID+A.SHOP_GROUP_ID+A.SCP_PLAN_ID) IN (SELECT A.DIVISION_ID+A.SHOP_GROUP_ID+MAX(A.SCP_PLAN_ID) AS SCP_PLAN_ID FROM FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H A WITH(NOLOCK) GROUP BY A.DIVISION_ID, A.SHOP_GROUP_ID) ' + char(10)
                SELECT @v_dSql += '                        UNION ALL ' + char(10)
                SELECT @v_dSql += '                        SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(A.MARKET,''D'') AS MARKET, A.ITEM_ID ' + char(10)
                SELECT @v_dSql += '                        FROM   FP_WEEKLY_DEMAND_SHIPMENT_AUTO_H A WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '                        WHERE  A.SCP_PLAN_ID = (SELECT MAX(SCP_PLAN_ID) AS SCP_PLAN_ID FROM FP_WEEKLY_DEMAND_SHIPMENT_AUTO_H A WITH(NOLOCK)) ' + char(10)
                SELECT @v_dSql += '                        UNION ALL ' + char(10)
                SELECT @v_dSql += '                        SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(A.MARKET,''D'') AS MARKET, A.ITEM_ID ' + char(10)
                SELECT @v_dSql += '                        FROM   FP_WEEKLY_DEMAND_PRODUCT_TEST_H A WITH(NOLOCK)                                ' + char(10)
                SELECT @v_dSql += '                        WHERE  A.DUE_DATE >= ( SELECT CONVERT(DATETIME,CONVERT(VARCHAR,PLAN_START_TIME,112)) ' + char(10)
                SELECT @v_dSql += '                                               FROM   SCM_FP_PLAN_H                   ' + char(10)
                SELECT @v_dSql += '                                               WHERE  PLAN_ID ='''+ @p_plan_id +''' ) ' + char(10)
                SELECT @v_dSql += '                        UNION ALL ' + char(10)
                SELECT @v_dSql += '                        SELECT  DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(A.MARKET,''D'') AS MARKET, A.ITEM_ID ' + char(10)
                SELECT @v_dSql += '                        FROM   FP_DAILY_INSTANCE_DEMAND_H A ' + char(10)
                SELECT @v_dSql += '                        WHERE  1=1                          ' + char(10)
                SELECT @v_dSql += '                        AND   INSTANCE_ID = CASE WHEN '''+ @p_instance_id +''' = ''KR_E_PRE_A'' OR '''+ @p_instance_id +''' = ''KR_E_PRE_M'' THEN ''KR_E_PRE'' ' + char(10)
                SELECT @v_dSql += '                                            ELSE '''+ @p_instance_id +''' END ' + char(10)
                SELECT @v_dSql += '                        AND   INSTANCE_DATE = '''+ @p_plan_date +'''          ' + char(10)
                SELECT @v_dSql += '                        AND   CONVERT(VARCHAR, INSTANCE_DATE,102) = ( SELECT CONVERT(VARCHAR, PLAN_START_TIME,102) ' + char(10)
                SELECT @v_dSql += '                                                                      FROM   SCM_FP_PLAN_H                         ' + char(10)
                SELECT @v_dSql += '                                                                      WHERE  PLAN_ID = '''+ @p_plan_id +'''        ' + char(10)
                SELECT @v_dSql += '                                                                      )                                            ' + char(10)
                SELECT @v_dSql += '                    ) H                         ' + char(10)
                SELECT @v_dSql += '             ) H                                ' + char(10)
                SELECT @v_dSql += '             ON  A.COMPANY_ID  = H.COMPANY_ID   ' + char(10)
                SELECT @v_dSql += '             AND A.DIVISION_ID = H.DIVISION_ID  ' + char(10)
                SELECT @v_dSql += '             AND A.SITE_ID     = H.SITE_ID      ' + char(10)
                SELECT @v_dSql += '             AND A.PLANT_ID    = H.PLANT_ID     ' + char(10)
                SELECT @v_dSql += '             AND A.MARKET      = H.MARKET       ' + char(10)
                SELECT @v_dSql += '             AND A.ITEM_ID     = H.ITEM_ID      ' + char(10)
                SELECT @v_dSql += '             LEFT OUTER JOIN SCM_ITEM_LINE_ASSIGN_M I WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '             ON  A.COMPANY_ID     = I.COMPANY_ID      ' + char(10)
                SELECT @v_dSql += '             AND A.DIVISION_ID    = I.DIVISION_ID     ' + char(10)
                SELECT @v_dSql += '             AND A.SITE_ID        = I.SITE_ID         ' + char(10)
                SELECT @v_dSql += '             AND A.PLANT_ID       = I.PLANT_ID        ' + char(10)
                SELECT @v_dSql += '             AND A.FACTORY_ID     = I.FACTORY_ID      ' + char(10)
                SELECT @v_dSql += '             AND A.ITEM_ID        = I.ITEM_ID         ' + char(10)
                SELECT @v_dSql += '             AND A.OPERATION_ID   = I.OPERATION_ID    ' + char(10)
                SELECT @v_dSql += '             AND A.LINE_ID        = I.LINE_ID         ' + char(10)
                SELECT @v_dSql += '             AND A.ELECTRODE_TYPE = I.ELECTRODE_TYPE  ' + char(10)
                SELECT @v_dSql += '             AND SUBSTRING(A.PLAN_DATE,1,6) = I.MONTH ' + char(10)
                SELECT @v_dSql += '             AND I.ACTIVE_FLAG    = ''Y''             ' + char(10)
                SELECT @v_dSql += '             AND I.PRIORITY NOT IN (''0'',''9'')      ' + char(10)
                SELECT @v_dSql += '             LEFT OUTER JOIN SCM_TACT_TIME_M J WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '             ON  A.COMPANY_ID      = J.COMPANY_ID     ' + char(10)
                SELECT @v_dSql += '             AND A.DIVISION_ID     = J.DIVISION_ID    ' + char(10)
                SELECT @v_dSql += '             AND A.SITE_ID         = J.SITE_ID        ' + char(10)
                SELECT @v_dSql += '             AND A.PLANT_ID        = J.PLANT_ID       ' + char(10)
                SELECT @v_dSql += '             AND A.FACTORY_ID      = J.FACTORY_ID     ' + char(10)
                SELECT @v_dSql += '             AND A.ITEM_ID         = J.ITEM_ID        ' + char(10)
                SELECT @v_dSql += '             AND A.OPERATION_ID    = J.OPERATION_ID   ' + char(10)
                SELECT @v_dSql += '             AND A.LINE_ID         = J.LINE_ID        ' + char(10)
                SELECT @v_dSql += '             AND A.ELECTRODE_TYPE  = J.ELECTRODE_TYPE ' + char(10)
                SELECT @v_dSql += '             AND SUBSTRING(A.PLAN_DATE,1,6) = J.MONTH ' + char(10)
                SELECT @v_dSql += '             LEFT OUTER JOIN FP_INSTANCE_CONFIG_M K WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '             ON  A.INSTANCE_ID     = K.INSTANCE_ID          ' + char(10)
                SELECT @v_dSql += '             AND K.KEY_ID          = ''FINAL_OP_CAPA''      ' + char(10)
                SELECT @v_dSql += '             LEFT OUTER JOIN SCM_EQUIPMENT_M L WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '             ON  A.COMPANY_ID      = L.COMPANY_ID   ' + char(10)
                SELECT @v_dSql += '             AND A.DIVISION_ID     = L.DIVISION_ID  ' + char(10)
                SELECT @v_dSql += '             AND A.SITE_ID         = L.SITE_ID      ' + char(10)
                SELECT @v_dSql += '             AND A.PLANT_ID        = L.PLANT_ID     ' + char(10)
                SELECT @v_dSql += '             AND A.FACTORY_ID      = L.FACTORY_ID   ' + char(10)
                SELECT @v_dSql += '             AND A.OPERATION_ID    = L.OPERATION_ID ' + char(10)
                SELECT @v_dSql += '             AND A.LINE_ID         = L.LINE_ID      ' + char(10)
                SELECT @v_dSql += '             AND A.EQUIPMENT_ID    = L.EQUIPMENT_ID ' + char(10)
                SELECT @v_dSql += '             AND L.ACTIVE_FLAG 	  = ''Y''           ' + char(10)
                SELECT @v_dSql += '             LEFT OUTER JOIN (                      ' + char(10)
                SELECT @v_dSql += '                 SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
                SELECT @v_dSql += '                     , A.OPERATION_ID, A.ITEM_ID                 ' + char(10)
                SELECT @v_dSql += '                 FROM SCM_ITEM_EQUIP_RATE_BATCH_M A WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '                 WHERE 1=1 ' + char(10)
                SELECT @v_dSql += '             ) M           ' + char(10)
                SELECT @v_dSql += '             ON  A.COMPANY_ID    = M.COMPANY_ID   ' + char(10)
                SELECT @v_dSql += '             AND A.DIVISION_ID   = M.DIVISION_ID  ' + char(10)
                SELECT @v_dSql += '             AND A.SITE_ID       = M.SITE_ID      ' + char(10)
                SELECT @v_dSql += '             AND A.PLANT_ID      = M.PLANT_ID     ' + char(10)
                SELECT @v_dSql += '             AND A.FACTORY_ID    = M.FACTORY_ID   ' + char(10)
                SELECT @v_dSql += '             AND A.OPERATION_ID  = M.OPERATION_ID ' + char(10)
                SELECT @v_dSql += '             AND A.ITEM_ID       = M.ITEM_ID      ' + char(10)
                SELECT @v_dSql += '       ) TT           ' + char(10)
                SELECT @v_dSql += ' ) A                  ' + char(10)
                SELECT @v_dSql += ' ORDER BY A.JOB_ORDER ' + char(10)
	    
          IF @p_sys_type = 'SQL'
              BEGIN
                --EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
                SELECT @v_dSql as [QUERY_VALUE]
              END  
          ELSE 
              BEGIN
                SET @runstart = GetDate()
                --쿼리실행
                EXEC sp_executesql @v_dSql
                
                SET @runend = GetDate()
                EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql,'select',@runstart, @runend
              END
        END

	ELSE
		-- 트랜잭션 (TRAN)
		BEGIN TRY				                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
		BEGIN TRAN   

		/*******************************************************************************************************/
		/* INSERT_EXCEL_COLUMN 경우(최종저장): 버퍼를 읽어서 Insert하기때문 While문 필요없음               */
		/*  LINE : COLUMN 타입 : pr_amend/planamend_cn2_Form( saveAll_cn2_importAll : merge_cn2_import )     */
		/*******************************************************************************************************/
		IF(@p_sys_flag ='INSERT_EXCEL_COLUMN')
		    BEGIN
		        SELECT @v_dSql  = ''

			    SELECT @v_dSql1 = ''
                SELECT @v_dSql1 += ' MERGE INTO FP_AMEND_DAILY_PLAN_R AS A    ' + char(10) 
                SELECT @v_dSql1 += ' USING (                                  ' + char(10) 
                SELECT @v_dSql1 += '     SELECT BB.INSTANCE_ID, BB.FP_PLAN_ID ' + char(10) 
                SELECT @v_dSql1 += '          , BB.COMPANY_ID, BB.DIVISION_ID, BB.SITE_ID, BB.PLANT_ID, BB.FACTORY_ID, ''-'' AS LOCATION ' + char(10) 
                SELECT @v_dSql1 += '          , BB.OPERATION_ID, BB.LINE_ID                                  ' + char(10) 
                SELECT @v_dSql1 += '          , ( SELECT ISNULL(KK.SEGMENT1,''-'')                           ' + char(10) 
                SELECT @v_dSql1 += '              FROM   SCM_SYS_LOOKUP_VALUE KK WITH(NOLOCK)                ' + char(10) 
                SELECT @v_dSql1 += '              WHERE  KK.LOOKUP_TYPE_CODE = ''ELECTRODE_TYPE''            ' + char(10) 
                SELECT @v_dSql1 += '              AND    KK.SEGMENT1 = BB.ELECTRODE_TYPE ) AS ELECTRODE_TYPE ' + char(10) 
                SELECT @v_dSql1 += '          , BB.EQUIPMENT_ID                                          ' + char(10) 
                SELECT @v_dSql1 += '          , BB.ITEM_ID AS TOP_ITEM_ID, BB.ITEM_ID                    ' + char(10) 
                SELECT @v_dSql1 += '          , BB.PRODUCTION_TYPE, BB.MARKET                            ' + char(10) 
                SELECT @v_dSql1 += '          , BB.PLAN_DATE                                             ' + char(10) 
                SELECT @v_dSql1 += '          , ROUND(BB.ADJUST_IN_QTY_BATCH,2) AS ADJUST_IN_QTY_BATCH   ' + char(10) 
                SELECT @v_dSql1 += '          , BB.ADJUST_IN_QTY_KG AS ADJUST_IN_QTY_KG                  ' + char(10) 
                SELECT @v_dSql1 += '          , ROUND(BB.ADJUST_OUT_QTY_BATCH,2) AS ADJUST_OUT_QTY_BATCH ' + char(10) 
                SELECT @v_dSql1 += '          , BB.ADJUST_OUT_QTY_KG AS ADJUST_OUT_QTY_KG  ' + char(10) 
                SELECT @v_dSql1 += '          , BB.SEQ                                     ' + char(10) 
                SELECT @v_dSql1 += '     FROM   BUF_AMEND_DAILY_PLAN_R BB WITH(NOLOCK)     ' + char(10) 
                SELECT @v_dSql1 += '     WHERE  BB.JOB_USER_ID  = '''+ @p_user_id +'''     ' + char(10) 
                SELECT @v_dSql1 += '     AND    BB.INSTANCE_ID  = '''+ @p_instance_id +''' ' + char(10) 
                SELECT @v_dSql1 += ' ) AS B                                    ' + char(10) 
                SELECT @v_dSql1 += ' ON  A.INSTANCE_ID     = B.INSTANCE_ID     ' + char(10) 
                SELECT @v_dSql1 += ' AND A.FP_PLAN_ID      = B.FP_PLAN_ID      ' + char(10) 
                SELECT @v_dSql1 += ' AND A.FACTORY_ID      = B.FACTORY_ID      ' + char(10) 
                SELECT @v_dSql1 += ' AND A.LOCATION        = B.LOCATION        ' + char(10) 
                SELECT @v_dSql1 += ' AND A.OPERATION_ID    = B.OPERATION_ID    ' + char(10) 
                SELECT @v_dSql1 += ' AND A.LINE_ID         = B.LINE_ID         ' + char(10) 
                SELECT @v_dSql1 += ' AND A.ELECTRODE_TYPE  = B.ELECTRODE_TYPE  ' + char(10) 
                SELECT @v_dSql1 += ' AND A.EQUIPMENT_ID    = B.EQUIPMENT_ID    ' + char(10)  
                SELECT @v_dSql1 += ' AND A.PLAN_DATE       = B.PLAN_DATE       ' + char(10) 
                SELECT @v_dSql1 += ' AND A.TOP_ITEM_ID     = B.TOP_ITEM_ID     ' + char(10) 
                SELECT @v_dSql1 += ' AND A.ITEM_ID         = B.ITEM_ID         ' + char(10) 
                SELECT @v_dSql1 += ' AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE ' + char(10) 
                SELECT @v_dSql1 += ' AND A.MARKET          = B.MARKET          ' + char(10) 
                SELECT @v_dSql1 += ' WHEN MATCHED THEN                         ' + char(10) 
                SELECT @v_dSql1 += ' 	UPDATE SET ADJUST_IN_QTY_BATCH = B.ADJUST_IN_QTY_BATCH, ADJUST_OUT_QTY_BATCH = B.ADJUST_OUT_QTY_BATCH ' + char(10) 
                SELECT @v_dSql1 += '            , ADJUST_IN_QTY_KG = B.ADJUST_IN_QTY_KG, ADJUST_OUT_QTY_KG = B.ADJUST_OUT_QTY_KG ' + char(10) 
                SELECT @v_dSql1 += '            , SEQ = B.SEQ                                                                    ' + char(10) 
                SELECT @v_dSql1 += ' 	       , UPDATE_ID = '''+ @p_user_id +''', UPDATE_TIME = dbo.FN_SITE_TIME(B.SITE_ID)     ' + char(10) 
                SELECT @v_dSql1 += ' 	       , PRODUCTION_TYPE = B.PRODUCTION_TYPE    ' + char(10)  
                SELECT @v_dSql1 += ' WHEN NOT MATCHED BY TARGET THEN                    ' + char(10)
                SELECT @v_dSql1 += ' 	INSERT (                                        ' + char(10)
                SELECT @v_dSql1 += '        INSTANCE_ID, FP_PLAN_ID                     ' + char(10)
                SELECT @v_dSql1 += '       ,COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID ' + char(10)
                SELECT @v_dSql1 += '       ,LOCATION, OPERATION_ID, LINE_ID, ELECTRODE_TYPE ' + char(10)
                SELECT @v_dSql1 += '       ,EQUIPMENT_ID, PLAN_DATE              ' + char(10)
                SELECT @v_dSql1 += '       ,TOP_ITEM_ID, ITEM_ID                 ' + char(10)
                SELECT @v_dSql1 += '       ,PRODUCTION_TYPE, MARKET              ' + char(10)
                SELECT @v_dSql1 += '       ,SEQ                                  ' + char(10)
                SELECT @v_dSql1 += '       ,ADJUST_IN_QTY_BATCH, ADJUST_IN_QTY   ' + char(10)
                SELECT @v_dSql1 += '       ,ADJUST_IN_QTY_KG                     ' + char(10)
                SELECT @v_dSql1 += '       ,ADJUST_OUT_QTY_BATCH, ADJUST_OUT_QTY ' + char(10)
                SELECT @v_dSql1 += '       ,ADJUST_OUT_QTY_KG                    ' + char(10)
                SELECT @v_dSql1 += '       ,INSERT_ID, INSERT_TIME               ' + char(10)
                SELECT @v_dSql1 += '       ,UPDATE_ID, UPDATE_TIME               ' + char(10)
                SELECT @v_dSql1 += ' 	)                                        ' + char(10)
                SELECT @v_dSql1 += ' 	VALUES (                                 ' + char(10)
                SELECT @v_dSql1 += '        B.INSTANCE_ID, B.FP_PLAN_ID          ' + char(10)
                SELECT @v_dSql1 += '       ,(SELECT MAX(KK.COMPANY_ID) AS COMPANY_ID FROM SCM_FACTORY_M KK WITH(NOLOCK) WHERE KK.FACTORY_ID = B.FACTORY_ID AND KK.ACTIVE_FLAG = ''Y'') ' + char(10)
                SELECT @v_dSql1 += '       ,B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.FACTORY_ID      ' + char(10)
                SELECT @v_dSql1 += '       ,B.LOCATION, B.OPERATION_ID, B.LINE_ID, B.ELECTRODE_TYPE ' + char(10)
                SELECT @v_dSql1 += '       ,B.EQUIPMENT_ID ,B.PLAN_DATE ' + char(10)
                SELECT @v_dSql1 += '       ,B.TOP_ITEM_ID, B.ITEM_ID    ' + char(10)
                SELECT @v_dSql1 += '       ,B.PRODUCTION_TYPE, B.MARKET ' + char(10)
                SELECT @v_dSql1 += '       ,B.SEQ                       ' + char(10)
                SELECT @v_dSql1 += '       ,B.ADJUST_IN_QTY_BATCH, 0    ' + char(10)
                SELECT @v_dSql1 += '       ,B.ADJUST_IN_QTY_KG          ' + char(10)
                SELECT @v_dSql1 += '       ,B.ADJUST_OUT_QTY_BATCH, 0   ' + char(10)
                SELECT @v_dSql1 += '       ,B.ADJUST_OUT_QTY_KG         ' + char(10)
                SELECT @v_dSql1 += '       ,'''+ @p_user_id +''', dbo.FN_SITE_TIME('''+ @p_site_id +''') ' + char(10)
                SELECT @v_dSql1 += '       ,'''+ @p_user_id +''', dbo.FN_SITE_TIME('''+ @p_site_id +''') ' + char(10)
                SELECT @v_dSql1 += ' 	) ' + char(10)
                SELECT @v_dSql1 += '   ;  ' + char(10)
				SELECT @v_dSql2 = ''
                SELECT @v_dSql2 += ' INSERT INTO HIS_AMEND_DAILY_PLAN_R (                          ' + char(10)
                SELECT @v_dSql2 += '        INSTANCE_ID, FP_PLAN_ID                                ' + char(10)
                SELECT @v_dSql2 += '       ,COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID ' + char(10)
                SELECT @v_dSql2 += '       ,LOCATION, OPERATION_ID, LINE_ID, ELECTRODE_TYPE        ' + char(10)
                SELECT @v_dSql2 += '       ,EQUIPMENT_ID, PLAN_DATE              ' + char(10)
                SELECT @v_dSql2 += '       ,TOP_ITEM_ID, ITEM_ID                 ' + char(10)
                SELECT @v_dSql2 += '       ,PRODUCTION_TYPE, MARKET              ' + char(10)
                SELECT @v_dSql2 += '       ,SEQ                                  ' + char(10)
                SELECT @v_dSql2 += '       ,ADJUST_IN_QTY_BATCH, ADJUST_IN_QTY   ' + char(10)
                SELECT @v_dSql2 += '       ,ADJUST_IN_QTY_KG                     ' + char(10)
                SELECT @v_dSql2 += '       ,ADJUST_OUT_QTY_BATCH, ADJUST_OUT_QTY ' + char(10)
                SELECT @v_dSql2 += '       ,ADJUST_OUT_QTY_KG                    ' + char(10)
                SELECT @v_dSql2 += '       ,INSERT_ID, INSERT_TIME               ' + char(10)
                SELECT @v_dSql2 += '       ,UPDATE_ID, UPDATE_TIME               ' + char(10)
                SELECT @v_dSql2 += '       ,JOB_USER_ID, JOB_TIME,JOB_TYPE       ' + char(10)
                SELECT @v_dSql2 += ' )                                           ' + char(10)
                SELECT @v_dSql2 += ' SELECT A.INSTANCE_ID, A.FP_PLAN_ID          ' + char(10)
                SELECT @v_dSql2 += '       ,(SELECT MAX(YY.COMPANY_ID) AS COMPANY_ID FROM SCM_FACTORY_M YY WITH(NOLOCK) WHERE A.FACTORY_ID = YY.FACTORY_ID AND YY.ACTIVE_FLAG = ''Y'') AS COMPANY_ID ' + char(10)
                SELECT @v_dSql2 += '       ,A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
                SELECT @v_dSql2 += '       ,''-'' AS LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
                SELECT @v_dSql2 += '       ,A.EQUIPMENT_ID, A.PLAN_DATE                 ' + char(10)
                SELECT @v_dSql2 += '       ,A.ITEM_ID AS TOP_ITEM_ID, A.ITEM_ID         ' + char(10)
                SELECT @v_dSql2 += '       ,A.PRODUCTION_TYPE, A.MARKET                 ' + char(10)
                SELECT @v_dSql2 += '       ,A.SEQ                                       ' + char(10)
                SELECT @v_dSql2 += '       ,A.ADJUST_IN_QTY_BATCH , 0 AS ADJUST_IN_QTY  ' + char(10)
                SELECT @v_dSql2 += '       ,A.ADJUST_IN_QTY_KG                          ' + char(10)
                SELECT @v_dSql2 += '       ,A.ADJUST_OUT_QTY_BATCH , 0 AS ADJUST_IN_QTY ' + char(10)
                SELECT @v_dSql2 += '       ,A.ADJUST_OUT_QTY_KG                         ' + char(10)
                SELECT @v_dSql2 += '       ,'''+ @p_user_id +''' AS INSERT_ID, dbo.FN_SITE_TIME(A.SITE_ID) AS INSERT_TIME     ' + char(10)
                SELECT @v_dSql2 += '       ,'''+ @p_user_id +''' AS UPDATE_ID, dbo.FN_SITE_TIME(A.SITE_ID) AS UPDATE_TIME     ' + char(10)
                SELECT @v_dSql2 += '       ,'''+ @p_user_id +''' AS JOB_USER_ID, GETDATE() AS JOB_TIME, ''EXCEL'' AS JOB_TYPE ' + char(10)
                SELECT @v_dSql2 += ' FROM   BUF_AMEND_DAILY_PLAN_R A WITH(NOLOCK)    ' + char(10)
                SELECT @v_dSql2 += ' WHERE  JOB_USER_ID   = '''+ @p_user_id +'''     ' + char(10)
                SELECT @v_dSql2 += ' AND    A.INSTANCE_ID = '''+ @p_instance_id +''' ' + char(10)
				SELECT @v_dSql2 += ' ; ' + char(10)

			    SELECT @v_dSql = @v_dSql1 + @v_dSql2

				IF @p_sys_type = 'SQL'
					BEGIN
						--EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
						SELECT @v_dSql as [QUERY_VALUE]
				
					END
				ELSE
					BEGIN
						SET @runstart = GetDate()
						--쿼리실행
						EXEC sp_executesql @v_dSql
				
						SET @runend = GetDate()
						EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id, @p_sys_flag,'', @v_dSql,'SELECT',@runstart, @runend
					END
		    END --'IF'

		/************************************************************************************************************/
		/* INSERT_EXCEL_ROW 경우(최종저장): 버퍼를 읽어서 Insert하기때문 While문 필요없음                           */
		/*  LINE : ROW타입 : pr_amend/planamend_cn2_Form_excel_2 ( saveAll_cn2_importAll: merge_cn2_import)        */
		/************************************************************************************************************/
		ELSE IF(@p_sys_flag ='INSERT_EXCEL_ROW')
		    BEGIN
		        SELECT @v_dSql  = ''

				SELECT @v_dSql1 = ''
                SELECT @v_dSql1 += ' MERGE INTO FP_AMEND_DAILY_PLAN_R AS A     ' + char(10)
                SELECT @v_dSql1 += ' USING (                                   ' + char(10)
                SELECT @v_dSql1 += '      SELECT BB.INSTANCE_ID, BB.FP_PLAN_ID ' + char(10)
                SELECT @v_dSql1 += '           , BB.COMPANY_ID, BB.DIVISION_ID, BB.SITE_ID, BB.PLANT_ID, BB.FACTORY_ID, ''-'' AS LOCATION ' + char(10)
                SELECT @v_dSql1 += '           , BB.OPERATION_ID, BB.LINE_ID                       ' + char(10)
                SELECT @v_dSql1 += '           , ( SELECT ISNULL(KK.SEGMENT1,''-'')                ' + char(10)
                SELECT @v_dSql1 += '               FROM   SCM_SYS_LOOKUP_VALUE KK WITH(NOLOCK)     ' + char(10)
                SELECT @v_dSql1 += '               WHERE  KK.LOOKUP_TYPE_CODE = ''ELECTRODE_TYPE'' ' + char(10)
                SELECT @v_dSql1 += '               AND    KK.SEGMENT1 = BB.ELECTRODE_TYPE ) AS ELECTRODE_TYPE ' + char(10)
                SELECT @v_dSql1 += '           , BB.EQUIPMENT_ID                       ' + char(10)
                SELECT @v_dSql1 += '           , BB.ITEM_ID AS TOP_ITEM_ID, BB.ITEM_ID ' + char(10)
                SELECT @v_dSql1 += '           , BB.PRODUCTION_TYPE, BB.MARKET         ' + char(10)
                SELECT @v_dSql1 += '           , BB.PLAN_DATE                          ' + char(10)
                SELECT @v_dSql1 += '           , ROUND(BB.ADJUST_IN_QTY_BATCH,2) AS ADJUST_IN_QTY_BATCH   ' + char(10)
                SELECT @v_dSql1 += '           , ROUND(BB.ADJUST_OUT_QTY_BATCH,2) AS ADJUST_OUT_QTY_BATCH ' + char(10)
                SELECT @v_dSql1 += '           , BB.ADJUST_IN_QTY_KG AS ADJUST_IN_QTY_KG   ' + char(10)
                SELECT @v_dSql1 += '           , BB.ADJUST_OUT_QTY_KG AS ADJUST_OUT_QTY_KG ' + char(10)
                SELECT @v_dSql1 += '           , BB.SEQ                                    ' + char(10)
                SELECT @v_dSql1 += '      FROM   BUF_AMEND_DAILY_PLAN_R BB WITH(NOLOCK)    ' + char(10)
                SELECT @v_dSql1 += '      WHERE  BB.JOB_USER_ID = '''+ @p_user_id +'''     ' + char(10)
                SELECT @v_dSql1 += '      AND    BB.INSTANCE_ID = '''+ @p_instance_id +''' ' + char(10)
                SELECT @v_dSql1 += ' ) AS B                                    ' + char(10)
                SELECT @v_dSql1 += ' ON  A.INSTANCE_ID     = B.INSTANCE_ID     ' + char(10)
                SELECT @v_dSql1 += ' AND A.FP_PLAN_ID      = B.FP_PLAN_ID      ' + char(10)
                SELECT @v_dSql1 += ' AND A.FACTORY_ID      = B.FACTORY_ID      ' + char(10)
                SELECT @v_dSql1 += ' AND A.LOCATION        = B.LOCATION        ' + char(10)
                SELECT @v_dSql1 += ' AND A.OPERATION_ID    = B.OPERATION_ID    ' + char(10)
                SELECT @v_dSql1 += ' AND A.LINE_ID         = B.LINE_ID         ' + char(10)
                SELECT @v_dSql1 += ' AND A.ELECTRODE_TYPE  = B.ELECTRODE_TYPE  ' + char(10)
                SELECT @v_dSql1 += ' AND A.EQUIPMENT_ID    = B.EQUIPMENT_ID    ' + char(10)
                SELECT @v_dSql1 += ' AND A.PLAN_DATE       = B.PLAN_DATE       ' + char(10)
                SELECT @v_dSql1 += ' AND A.TOP_ITEM_ID     = B.TOP_ITEM_ID     ' + char(10)
                SELECT @v_dSql1 += ' AND A.ITEM_ID         = B.ITEM_ID         ' + char(10)
                SELECT @v_dSql1 += ' AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE ' + char(10)
                SELECT @v_dSql1 += ' AND A.MARKET          = B.MARKET          ' + char(10)
                SELECT @v_dSql1 += ' WHEN MATCHED THEN                         ' + char(10)
                SELECT @v_dSql1 += ' 	UPDATE SET ADJUST_IN_QTY_BATCH = B.ADJUST_IN_QTY_BATCH, ADJUST_OUT_QTY_BATCH = B.ADJUST_OUT_QTY_BATCH ' + char(10)
                SELECT @v_dSql1 += '            , ADJUST_IN_QTY_KG = B.ADJUST_IN_QTY_KG, ADJUST_OUT_QTY_KG = B.ADJUST_OUT_QTY_KG ' + char(10)
                SELECT @v_dSql1 += '            , SEQ = B.SEQ                                                                    ' + char(10)
                SELECT @v_dSql1 += ' 	       , UPDATE_ID = '''+ @p_user_id +''', UPDATE_TIME = dbo.FN_SITE_TIME(B.SITE_ID)     ' + char(10)
                SELECT @v_dSql1 += ' 	       , PRODUCTION_TYPE = B.PRODUCTION_TYPE                                             ' + char(10)
                SELECT @v_dSql1 += ' WHEN NOT MATCHED BY TARGET THEN ' + char(10)
                SELECT @v_dSql1 += ' INSERT (                        ' + char(10)
                SELECT @v_dSql1 += '      INSTANCE_ID, FP_PLAN_ID    ' + char(10)
                SELECT @v_dSql1 += '     ,COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID ' + char(10)
                SELECT @v_dSql1 += '     ,LOCATION, OPERATION_ID, LINE_ID, ELECTRODE_TYPE        ' + char(10)
                SELECT @v_dSql1 += '     ,EQUIPMENT_ID, PLAN_DATE              ' + char(10)
                SELECT @v_dSql1 += '     ,TOP_ITEM_ID, ITEM_ID                 ' + char(10)
                SELECT @v_dSql1 += '     ,PRODUCTION_TYPE, MARKET              ' + char(10)
                SELECT @v_dSql1 += '     ,SEQ                                  ' + char(10)
                SELECT @v_dSql1 += '     ,ADJUST_IN_QTY_BATCH, ADJUST_IN_QTY   ' + char(10)
                SELECT @v_dSql1 += '     ,ADJUST_IN_QTY_KG                     ' + char(10)
                SELECT @v_dSql1 += '     ,ADJUST_OUT_QTY_BATCH, ADJUST_OUT_QTY ' + char(10)
                SELECT @v_dSql1 += '     ,ADJUST_OUT_QTY_KG                    ' + char(10)
                SELECT @v_dSql1 += '     ,INSERT_ID, INSERT_TIME               ' + char(10)
                SELECT @v_dSql1 += '     ,UPDATE_ID, UPDATE_TIME               ' + char(10)
                SELECT @v_dSql1 += ' )                                         ' + char(10)
                SELECT @v_dSql1 += ' VALUES (                                  ' + char(10)
                SELECT @v_dSql1 += '      B.INSTANCE_ID, B.FP_PLAN_ID          ' + char(10)
                SELECT @v_dSql1 += '     ,(SELECT MAX(KK.COMPANY_ID) AS COMPANY_ID FROM SCM_FACTORY_M KK WITH(NOLOCK) WHERE KK.FACTORY_ID = B.FACTORY_ID AND KK.ACTIVE_FLAG = ''Y''), B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.FACTORY_ID ' + char(10)
                SELECT @v_dSql1 += '     ,B.LOCATION, B.OPERATION_ID, B.LINE_ID, B.ELECTRODE_TYPE ' + char(10)
                SELECT @v_dSql1 += '     ,B.EQUIPMENT_ID ,B.PLAN_DATE ' + char(10)
                SELECT @v_dSql1 += '     ,B.TOP_ITEM_ID, B.ITEM_ID    ' + char(10)
                SELECT @v_dSql1 += '     ,B.PRODUCTION_TYPE, B.MARKET ' + char(10)
                SELECT @v_dSql1 += '     ,B.SEQ                       ' + char(10)
                SELECT @v_dSql1 += '     ,B.ADJUST_IN_QTY_BATCH, 0    ' + char(10)
                SELECT @v_dSql1 += '     ,B.ADJUST_IN_QTY_KG          ' + char(10)
                SELECT @v_dSql1 += '     ,B.ADJUST_OUT_QTY_BATCH, 0   ' + char(10)
                SELECT @v_dSql1 += '     ,B.ADJUST_OUT_QTY_KG         ' + char(10)
                SELECT @v_dSql1 += '     ,'''+ @p_user_id +''', dbo.FN_SITE_TIME('''+ @p_site_id +''') ' + char(10)
                SELECT @v_dSql1 += '     ,'''+ @p_user_id +''', dbo.FN_SITE_TIME('''+ @p_site_id +''') ' + char(10)
                SELECT @v_dSql1 += ' ) ' + char(10)
                SELECT @v_dSql1 += ' ; ' + char(10)
                SELECT @v_dSql2 = ''	  
                SELECT @v_dSql2 += ' INSERT INTO HIS_AMEND_DAILY_PLAN_R ( ' + char(10)
                SELECT @v_dSql2 += '        INSTANCE_ID, FP_PLAN_ID       ' + char(10)
                SELECT @v_dSql2 += '       ,COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID ' + char(10)
                SELECT @v_dSql2 += '       ,LOCATION, OPERATION_ID, LINE_ID, ELECTRODE_TYPE        ' + char(10)
                SELECT @v_dSql2 += '       ,EQUIPMENT_ID, PLAN_DATE              ' + char(10)
                SELECT @v_dSql2 += '       ,TOP_ITEM_ID, ITEM_ID                 ' + char(10)
                SELECT @v_dSql2 += '       ,PRODUCTION_TYPE, MARKET              ' + char(10)
                SELECT @v_dSql2 += '       ,SEQ                                  ' + char(10)
                SELECT @v_dSql2 += '       ,PLAN_IN_QTY_BATCH, PLAN_IN_QTY       ' + char(10)
                SELECT @v_dSql2 += '       ,PLAN_IN_QTY_M, PLAN_IN_QTY_CELL      ' + char(10)
                SELECT @v_dSql2 += '       ,PLAN_OUT_QTY_BATCH, PLAN_OUT_QTY     ' + char(10)
                SELECT @v_dSql2 += '       ,PLAN_OUT_QTY_M, PLAN_OUT_QTY_CELL    ' + char(10)
                SELECT @v_dSql2 += '       ,ADJUST_IN_QTY_BATCH, ADJUST_IN_QTY   ' + char(10)
                SELECT @v_dSql2 += '       ,ADJUST_IN_QTY_KG                     ' + char(10)
                SELECT @v_dSql2 += '       ,ADJUST_OUT_QTY_BATCH, ADJUST_OUT_QTY ' + char(10)
                SELECT @v_dSql2 += '       ,ADJUST_OUT_QTY_KG                    ' + char(10)
                SELECT @v_dSql2 += '       ,INSERT_ID, INSERT_TIME               ' + char(10)
                SELECT @v_dSql2 += '       ,UPDATE_ID, UPDATE_TIME               ' + char(10)
                SELECT @v_dSql2 += '       ,JOB_USER_ID, JOB_TIME,JOB_TYPE       ' + char(10)
                SELECT @v_dSql2 += ' )                                           ' + char(10)
                SELECT @v_dSql2 += ' SELECT A.INSTANCE_ID, A.FP_PLAN_ID          ' + char(10)
                SELECT @v_dSql2 += '       ,(SELECT MAX(YY.COMPANY_ID) AS COMPANY_ID FROM SCM_FACTORY_M YY WITH(NOLOCK) WHERE A.FACTORY_ID = YY.FACTORY_ID AND YY.ACTIVE_FLAG = ''Y'') AS COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
                SELECT @v_dSql2 += '       ,''-'' AS LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
                SELECT @v_dSql2 += '       ,A.EQUIPMENT_ID, A.PLAN_DATE                 ' + char(10)
                SELECT @v_dSql2 += '       ,A.ITEM_ID AS TOP_ITEM_ID, A.ITEM_ID         ' + char(10)
                SELECT @v_dSql2 += '       ,A.PRODUCTION_TYPE, A.MARKET                 ' + char(10)
                SELECT @v_dSql2 += '       ,A.SEQ                                       ' + char(10)
                SELECT @v_dSql2 += '       ,0 AS PLAN_IN_QTY_BATCH, 0 AS PLAN_IN_QTY    ' + char(10)
                SELECT @v_dSql2 += '       ,0 AS PLAN_IN_QTY_M, 0 AS PLAN_IN_QTY_CELL   ' + char(10)
                SELECT @v_dSql2 += '       ,0 AS PLAN_OUT_QTY_BATCH, 0 AS  PLAN_OUT_QTY ' + char(10)
                SELECT @v_dSql2 += '       ,0 AS PLAN_OUT_QTY_M, 0 AS PLAN_OUT_QTY_CELL ' + char(10)
                SELECT @v_dSql2 += '       ,A.ADJUST_IN_QTY_BATCH, 0 AS ADJUST_IN_QTY   ' + char(10)
                SELECT @v_dSql2 += '       ,A.ADJUST_IN_QTY_KG                          ' + char(10)
                SELECT @v_dSql2 += '       ,A.ADJUST_OUT_QTY_BATCH, 0 AS ADJUST_OUT_QTY ' + char(10)
                SELECT @v_dSql2 += '       ,A.ADJUST_OUT_QTY_KG                         ' + char(10)
                SELECT @v_dSql2 += '       ,'''+ @p_user_id +''' AS INSERT_ID, dbo.FN_SITE_TIME(A.SITE_ID) AS INSERT_TIME      ' + char(10)
                SELECT @v_dSql2 += '       ,'''+ @p_user_id +''' AS UPDATE_ID, dbo.FN_SITE_TIME(A.SITE_ID) AS UPDATE_TIME      ' + char(10)
                SELECT @v_dSql2 += '       ,'''+ @p_user_id +''' AS JOB_USER_ID, GETDATE() AS JOB_TIME, ''EXCEL2'' AS JOB_TYPE ' + char(10)
                SELECT @v_dSql2 += ' FROM   BUF_AMEND_DAILY_PLAN_R A WITH(NOLOCK)      ' + char(10)
                SELECT @v_dSql2 += ' WHERE  JOB_USER_ID     = '''+ @p_user_id +'''     ' + char(10)
                SELECT @v_dSql2 += ' AND    A.INSTANCE_ID 	= '''+ @p_instance_id +''' ' + char(10)


			    SELECT @v_dSql = @v_dSql1 + @v_dSql2

				IF @p_sys_type = 'SQL'
					BEGIN
						--EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
						SELECT @v_dSql as [QUERY_VALUE]
				
					END
				ELSE
					BEGIN
						SET @runstart = GetDate()
						--쿼리실행
						EXEC sp_executesql @v_dSql
				
						SET @runend = GetDate()
						EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id, @p_sys_flag,'', @v_dSql,'SELECT',@runstart, @runend
					END
		    END --'IF'

		/******************************************************************************/
		/* DELETE_BUFFER 경우 :                                                 */
		/******************************************************************************/
		ELSE IF(@p_sys_flag ='DELETE_BUFFER')  
			BEGIN
                 SELECT @v_dSql = ''
                 SELECT @v_dSql += ' DELETE FROM BUF_AMEND_DAILY_PLAN_R             ' + char(10)
                 SELECT @v_dSql += ' WHERE JOB_USER_ID = '''+ @p_user_id +'''       ' + char(10)
                 SELECT @v_dSql += ' AND INSTANCE_ID = '''+ @p_instance_id +'''     ' + char(10)

				 IF @p_sys_type = 'SQL'
				 	BEGIN
				 		--EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
				 		SELECT @v_dSql as [QUERY_VALUE]
				 
				 	END
				 ELSE
				 	BEGIN
				 		SET @runstart = GetDate()
				 		--쿼리실행
				 		EXEC sp_executesql @v_dSql
				 
				 		SET @runend = GetDate()
				 		EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id, @p_sys_flag,'', @v_dSql,'SELECT',@runstart, @runend
				 	END
		   END --'I'

        -- 트랜잭션 (COMMIT)
		COMMIT TRAN
		
		-- 수행결과 성공여부 RETURN
		IF @p_sys_type <> 'SQL'
		    SELECT 'SUCCESS' AS result_code,  @max_loop_cnt AS result_cnt	

		END TRY
		BEGIN CATCH                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
			ROLLBACK TRAN                                                                                                                                                                                                                                                 
			-- 에러나도 로그는 인서트                                                                                                                                                                                                                                              
			SET @v_log_message = ERROR_MESSAGE()
			EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_log_message,'excute',@runstart, @runend
			SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  
		END CATCH    
END
