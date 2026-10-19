
/*
 * Program ID   : PR_SCP_XLS_ADD_XLSPSI04
 * Description  : SCP SIMULATION SAVE
 * OutTable     :
 * Execute      : 
                 EXEC PR_SCP_XLS_ADD_XLSPSI04     @p_USER_ID             ='KTH'
                                                 ,@p_division_id         = '82'
                                                 ,@p_PLAN_START_YYYYMMDD = '2019128'
                                                 ,@p_PLAN_TYPE           ='PR'
                                                 ,@p_SEQ                 ='1'
                                                 ,@p_item_id             ='ACEN1063I-A3'
                                                 ,@p_measure             ='CELL_CHAR_PLAN'
                                                 ,@p_xls_key1            ='468'
                                                 ,@p_WQTY01 INT = 0.0 ,@p_WQTY02  INT = 0.0 ,@p_WQTY03  INT = 0.0 ,@p_WQTY04  INT = 0.0 ,@p_WQTY05  INT = 0.0
                                                 ,@p_WQTY06	INT = 0.0 ,@p_WQTY07  INT = 0.0 ,@p_WQTY08  INT = 0.0 ,@p_WQTY09  INT = 0.0 ,@p_WQTY10  INT = 0.0
                                                 ,@p_WQTY11 INT = 0.0 ,@p_WQTY12  INT = 0.0 ,@p_WQTY13  INT = 0.0 ,@p_WQTY14  INT = 0.0 ,@p_WQTY15  INT = 0.0
                                                 ,@p_WQTY16	INT = 0.0 ,@p_WQTY17  INT = 0.0 ,@p_WQTY18  INT = 0.0 ,@p_WQTY19  INT = 0.0 ,@p_WQTY20  INT = 0.0
                                                 ,@p_WQTY21 INT = 0.0 ,@p_WQTY22  INT = 0.0 ,@p_WQTY23  INT = 0.0 ,@p_WQTY24  INT = 0.0 ,@p_WQTY25  INT = 0.0
                                                 ,@p_WQTY26	INT = 0.0 ,@p_WQTY27  INT = 0.0 ,@p_WQTY28  INT = 0.0 ,@p_WQTY29  INT = 0.0 ,@p_WQTY30  INT = 0.0
                                                 ,@p_WQTY31 INT = 0.0 ,@p_WQTY32  INT = 0.0 ,@p_WQTY33  INT = 0.0 ,@p_WQTY34  INT = 0.0 ,@p_WQTY35  INT = 0.0
                                                 ,@p_WQTY36	INT = 0.0 ,@p_WQTY37  INT = 0.0 ,@p_WQTY38  INT = 0.0 ,@p_WQTY39  INT = 0.0 ,@p_WQTY40  INT = 0.0
                                                 ,@p_WQTY41 INT = 0.0 ,@p_WQTY42  INT = 0.0 ,@p_WQTY43  INT = 0.0 ,@p_WQTY44  INT = 0.0 ,@p_WQTY45  INT = 0.0
                                                 ,@p_WQTY46	INT = 0.0 ,@p_WQTY47  INT = 0.0 ,@p_WQTY48  INT = 0.0 ,@p_WQTY49  INT = 0.0 ,@p_WQTY50  INT = 0.0
                                                 ,@p_WQTY51 INT = 0.0 ,@p_WQTY52  INT = 0.0 

 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.06.27   KTH            Initial Release [PJ20189106] 전지.GSCM 고도화 이행
 * 2019.12.04   KTH            SHIP_PLAN 저장시 -9로 입력되는것은 0으로 처리 하는 로직 추가
 * 2020.01.09   KTH            저장로직 변경 : 모두 주 입력으로 변경
 */



CREATE PROCEDURE [dbo].[PR_SCP_XLS_ADD_XLSPSI04]
( 
  @p_user_id                 VARCHAR(100)
 --,@P_GUBUN                 VARCHAR(040)       -- MEASURE  @P_GUBUN  PACK / CELL / SUPPLY 
 ,@p_division_id	          NVARCHAR(030)
 ,@p_plan_start_yyyymmdd	  NVARCHAR(008)
 ,@p_plan_type	            NVARCHAR(050)
 ,@p_seq	                  INT
 ,@p_item_id	              NVARCHAR(050)
 ,@p_measure	              NVARCHAR(050)       -- MEASURE별
 ,@p_day_week_flag          NVARCHAR(010)       -- (day,week)
 ,@p_xls_key1	              NVARCHAR(200)

 ,@p_WQTY01 INT = 0.0 ,@p_WQTY02  INT = 0.0 ,@p_WQTY03  INT = 0.0 ,@p_WQTY04  INT = 0.0 ,@p_WQTY05  INT = 0.0
 ,@p_WQTY06	INT = 0.0 ,@p_WQTY07  INT = 0.0 ,@p_WQTY08  INT = 0.0 ,@p_WQTY09  INT = 0.0 ,@p_WQTY10  INT = 0.0
 ,@p_WQTY11 INT = 0.0 ,@p_WQTY12  INT = 0.0 ,@p_WQTY13  INT = 0.0 ,@p_WQTY14  INT = 0.0 ,@p_WQTY15  INT = 0.0
 ,@p_WQTY16	INT = 0.0  ,@p_WQTY17  INT = 0.0 ,@p_WQTY18  INT = 0.0 ,@p_WQTY19  INT = 0.0 ,@p_WQTY20  INT = 0.0
 ,@p_WQTY21 INT = 0.0 ,@p_WQTY22  INT = 0.0 ,@p_WQTY23  INT = 0.0 ,@p_WQTY24  INT = 0.0 ,@p_WQTY25  INT = 0.0
 ,@p_WQTY26	INT = 0.0 ,@p_WQTY27  INT = 0.0 ,@p_WQTY28  INT = 0.0 ,@p_WQTY29  INT = 0.0 ,@p_WQTY30  INT = 0.0
 ,@p_WQTY31 INT = 0.0 ,@p_WQTY32  INT = 0.0 ,@p_WQTY33  INT = 0.0 ,@p_WQTY34  INT = 0.0 ,@p_WQTY35  INT = 0.0
 ,@p_WQTY36	INT = 0.0 ,@p_WQTY37  INT = 0.0 ,@p_WQTY38  INT = 0.0 ,@p_WQTY39  INT = 0.0 ,@p_WQTY40  INT = 0.0
 ,@p_WQTY41 INT = 0.0 ,@p_WQTY42  INT = 0.0 ,@p_WQTY43  INT = 0.0 ,@p_WQTY44  INT = 0.0 ,@p_WQTY45  INT = 0.0
 ,@p_WQTY46	INT = 0.0 ,@p_WQTY47  INT = 0.0 ,@p_WQTY48  INT = 0.0 ,@p_WQTY49  INT = 0.0 ,@p_WQTY50  INT = 0.0
 ,@p_WQTY51 INT = 0.0 ,@p_WQTY52  INT = 0.0 
 
 )                                     
AS                                     

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'';  
    SET @v_batch_user = @p_user_id
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_XLS_ADD_XLSPSI04';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);     
    DECLARE @v_table_id     NVARCHAR(150) = N'SCP_XLS_PSI_GLOBAL_ESS'; 
    DECLARE @d_event_date   DATETIME;

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SCP_XLS_PSI_GLOBAL_ESS SAVE LOGIC';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                              ,@p_log_type      = @v_log_type
                              ,@p_log_count     = @n_log_count 
                              ,@p_log_message   = @v_log_message 
                              ,@p_description   = @v_description 
                              ,@p_event_date    = @d_event_date 
                              ,@p_user_id       = @v_batch_user
                              ;
    
    
        -- 임시 실행시간 확인용                
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();                
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';     

    --PRINT @p_plan_type
    -- PLAN_TYPE이 FN일경우 수정금지 RETURN
    IF @p_plan_type = 'FN'            
      RETURN -1   

    -------------------------------------------------------------------------------------------------------------------------------------------------------         
    -- 입력된 버전과 현재 버전이 다를 경우 RETURN 
    -------------------------------------------------------------------------------------------------------------------------------------------------------
        DECLARE   @v_division_id          NVARCHAR(030) = @p_division_id
                , @v_plan_start_yyyymmdd  NVARCHAR(008) = @p_plan_start_yyyymmdd
                , @v_plan_type            NVARCHAR(050) = @p_plan_type
                , @v_seq                  INT           = @p_seq

        SELECT TOP 1  @v_division_id          = DIVISION_ID
                    , @v_plan_start_yyyymmdd  = PLAN_START_YYYYMMDD
                    , @v_plan_type            = PLAN_TYPE
                    , @v_seq                  = SEQ
          FROM SCP_XLS_PSI_GLOBAL_ESS WITH (NOLOCK)


      IF (@p_division_id <> @v_division_id OR @p_plan_start_yyyymmdd <> @v_plan_start_yyyymmdd OR @p_plan_type <> @v_plan_type OR @p_seq <> @v_seq)  
        return -1   
    -------------------------------------------------------------------------------------------------------------------------------------------------------

      --PRINT @p_plan_type
    BEGIN TRY
      BEGIN         
            
            -------------------------------------------------------------------------------------------------------------         
            -- SCM_ADM_LOOKUP_MASTER_DETAIL.LOOKUP_TYPE  ='DAYOFWEEK_NO' 
            -- 저장할 요일 (월,화,수,목,금,토,일:2,3,4,5,6,7,1), 8이상은 일배분
            ------------------------------------------------------------------------------------------------------------- 
            DECLARE @x_DAYOFWEEK_NO INT          =  8 --(1~7) 8은 일별배분 (월,화,수,목,금,토,일:2,3,4,5,6,7,1)

            --SELECT SEGMENT1, SEGMENT2,DESCRIPTION
            SELECT TOP 1 @x_DAYOFWEEK_NO = ISNULL(SEGMENT2,8) 
              FROM dbo.SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK)  
             WHERE LOOKUP_TYPE  ='SHIP_PLAN_SAVE_WEEK'--'DAYOFWEEK_NO'
               AND SEGMENT1     = @p_division_id -- DIVISION_ID
               AND VALID_YN ='Y' 

               -- 선택된 항목만 주로 변경해야 하기 때문에 반영하지 않도록 수정 2019.05.07
               --SET @x_DAYOFWEEK_NO = '8'
            
            DECLARE @p_to_yyyymmdd  VARCHAR(8)   =  CONVERT(VARCHAR(8), DATEADD(day, 364, @p_plan_start_yyyymmdd), 112)

            -------------------------------------------------------------------------------------------------------------         
            -- FROZEN 구간 대상 DATA 생성
            -------------------------------------------------------------------------------------------------------------         
            IF OBJECT_ID('tempdb..#SCM_MST_SITE') IS NOT NULL	
	              DROP TABLE #SCM_MST_SITE

                  SELECT 
                         S.DIVISION_ID
	                      ,S.PLANT_ID
	                      ,S.OPERATION_GROUP
	                      ,S.SCM_SITE_ID 
	                      ,S.SHIP_FROZEN
                        ,(S.SHIP_FROZEN/7 + (CASE WHEN SHIP_FROZEN%7 > 0 THEN 1 ELSE 0 END)) AS SHIP_FROZEN_WEEK
                        ,CONVERT(NVARCHAR(8),  DATEADD(WEEK, (S.SHIP_FROZEN/7 + (CASE WHEN SHIP_FROZEN%7 > 0 THEN 1 ELSE 0 END)), @p_plan_start_yyyymmdd), 112)  AS SHIP_FROZEN_WEEK_DAY
	                      ,S.PROD_FROZEN
                        ,(S.PROD_FROZEN/7 + (CASE WHEN PROD_FROZEN%7 > 0 THEN 1 ELSE 0 END)) AS PROD_FROZEN_WEEK
                        ,CONVERT(NVARCHAR(8),  DATEADD(WEEK, (S.PROD_FROZEN/7 + (CASE WHEN PROD_FROZEN%7 > 0 THEN 1 ELSE 0 END)), @p_plan_start_yyyymmdd), 112)  AS PROD_FROZEN_WEEK_DAY
                        ,CONVERT(NVARCHAR(8),  DATEADD(WEEK, ( (CASE WHEN ((S.PROD_FROZEN -7) > 0) THEN (S.PROD_FROZEN -7) ELSE 0 END) /7 + (CASE WHEN (CASE WHEN ((S.PROD_FROZEN -7) > 0) THEN (S.PROD_FROZEN -7) ELSE 0 END)%7 > 0 THEN 1 ELSE 0 END)), @p_plan_start_yyyymmdd), 112)  AS PROD_FROZEN_WEEK_DAY_MA
	                      ,S.FP_PLAN_PERIOD		
	                      ,S.VALID_YN
	                      ,S.NEW_YN
	                      ,S.COMPANY_ID
	                      ,S.LOGISTIC_PLANT_ID
	                      ,S.PACKER_ITEM_ID_SUFFIX
                    INTO #SCM_MST_SITE 
                    FROM SCM_MST_SITE S WITH (NOLOCK)
                    WHERE S.SITE_TYPE   = 'PLANT'
                      AND S.VALID_YN    = 'Y'
                      AND S.DIVISION_ID = @p_division_id
                      ;

                      

            -------------------------------------------------------------------------------------------------------------         
            -- 수정하기전의 테이블에 존재하는 데이타를 가져와서 임시 테이블에 담아둔다.
            ------------------------------------------------------------------------------------------------------------- 
            -- SOURCE에 반영될 테이블 #DAY_SCP_XLS_PSI_GLOBAL
            IF OBJECT_ID('tempdb..#DAY_SCP_XLS_PSI_GLOBAL') IS NOT NULL	
	              DROP TABLE #DAY_SCP_XLS_PSI_GLOBAL

                SELECT * 
                INTO #DAY_SCP_XLS_PSI_GLOBAL
                FROM SCP_XLS_PSI_GLOBAL_ESS  WITH (NOLOCK)
                 WHERE 0 = 0
                    AND DIVISION_ID         = @p_division_id
                    AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
                    AND SEQ                 = @p_seq
                    AND XLS_KEY1            = @p_xls_key1 
                    ;

            -- SCP_XLS_PSI_GLOBAL_ESS에 반영될 테이블 #SCP_XLS_PSI_GLOBAL_ESS_ORG
            IF OBJECT_ID('tempdb..#SCP_XLS_PSI_GLOBAL_ESS_ORG') IS NOT NULL	
	              DROP TABLE #SCP_XLS_PSI_GLOBAL_ESS_ORG

                SELECT * 
                INTO #SCP_XLS_PSI_GLOBAL_ESS_ORG
                FROM SCP_XLS_PSI_GLOBAL_ESS  WITH (NOLOCK)
                 WHERE 0 = 0
                    AND DIVISION_ID         = @p_division_id
                    AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
                    AND SEQ                 = @p_seq
                    AND XLS_KEY1            = @p_xls_key1 
                    ;

                    
            -------------------------------------------------------------------------------------------------------------         
            -- 수정하기전의 테이블에 존재하는 데이타를 가져와서 변수에 담아둔다.
            ------------------------------------------------------------------------------------------------------------- 
            /*
            -- 수정전 QTY 변수                                        
             DECLARE  @x_QTY001 INT = 0.0 ,@x_QTY002  INT = 0.0 ,@x_QTY003  INT = 0.0 ,@x_QTY004  INT = 0.0 ,@x_QTY005  INT = 0.0
                     ,@x_QTY006	INT = 0.0 ,@x_QTY007  INT = 0.0 ,@x_QTY008  INT = 0.0 ,@x_QTY009  INT = 0.0 ,@x_QTY010  INT = 0.0
                     ,@x_QTY011 INT = 0.0 ,@x_QTY012  INT = 0.0 ,@x_QTY013  INT = 0.0 ,@x_QTY014  INT = 0.0 ,@x_QTY015  INT = 0.0
                     ,@x_QTY016	INT = 0.0 ,@x_QTY017  INT = 0.0 ,@x_QTY018  INT = 0.0 ,@x_QTY019  INT = 0.0 ,@x_QTY020  INT = 0.0
                     ,@x_QTY021 INT = 0.0 ,@x_QTY022  INT = 0.0 ,@x_QTY023  INT = 0.0 ,@x_QTY024  INT = 0.0 ,@x_QTY025  INT = 0.0
                     ,@x_QTY026	INT = 0.0 ,@x_QTY027  INT = 0.0 ,@x_QTY028  INT = 0.0 ,@x_QTY029  INT = 0.0 ,@x_QTY030  INT = 0.0
                     ,@x_QTY031 INT = 0.0 ,@x_QTY032  INT = 0.0 ,@x_QTY033  INT = 0.0 ,@x_QTY034  INT = 0.0 ,@x_QTY035  INT = 0.0
                     ,@x_QTY036	INT = 0.0 ,@x_QTY037  INT = 0.0 ,@x_QTY038  INT = 0.0 ,@x_QTY039  INT = 0.0 ,@x_QTY040  INT = 0.0
                     ,@x_QTY041 INT = 0.0 ,@x_QTY042  INT = 0.0 ,@x_QTY043  INT = 0.0 ,@x_QTY044  INT = 0.0 ,@x_QTY045  INT = 0.0
                     ,@x_QTY046	INT = 0.0 ,@x_QTY047  INT = 0.0 ,@x_QTY048  INT = 0.0 ,@x_QTY049  INT = 0.0 ,@x_QTY050  INT = 0.0
                     ,@x_QTY051 INT = 0.0 ,@x_QTY052  INT = 0.0 ,@x_QTY053  INT = 0.0 ,@x_QTY054  INT = 0.0 ,@x_QTY055  INT = 0.0
                     ,@x_QTY056	INT = 0.0 ,@x_QTY057  INT = 0.0 ,@x_QTY058  INT = 0.0 ,@x_QTY059  INT = 0.0 ,@x_QTY060  INT = 0.0
                     ,@x_QTY061 INT = 0.0 ,@x_QTY062  INT = 0.0 ,@x_QTY063  INT = 0.0 ,@x_QTY064  INT = 0.0 ,@x_QTY065  INT = 0.0
                     ,@x_QTY066	INT = 0.0 ,@x_QTY067  INT = 0.0 ,@x_QTY068  INT = 0.0 ,@x_QTY069  INT = 0.0 ,@x_QTY070  INT = 0.0
                     ,@x_QTY071 INT = 0.0 ,@x_QTY072  INT = 0.0 ,@x_QTY073  INT = 0.0 ,@x_QTY074  INT = 0.0 ,@x_QTY075  INT = 0.0
                     ,@x_QTY076	INT = 0.0 ,@x_QTY077  INT = 0.0 ,@x_QTY078  INT = 0.0 ,@x_QTY079  INT = 0.0 ,@x_QTY080  INT = 0.0
                     ,@x_QTY081 INT = 0.0 ,@x_QTY082  INT = 0.0 ,@x_QTY083  INT = 0.0 ,@x_QTY084  INT = 0.0 ,@x_QTY085  INT = 0.0
                     ,@x_QTY086	INT = 0.0 ,@x_QTY087  INT = 0.0 ,@x_QTY088  INT = 0.0 ,@x_QTY089  INT = 0.0 ,@x_QTY090  INT = 0.0
                     ,@x_QTY091 INT = 0.0 ,@x_QTY092  INT = 0.0 ,@x_QTY093  INT = 0.0 ,@x_QTY094  INT = 0.0 ,@x_QTY095  INT = 0.0
                     ,@x_QTY096	INT = 0.0 ,@x_QTY097  INT = 0.0 ,@x_QTY098  INT = 0.0 ,@x_QTY099  INT = 0.0 ,@x_QTY100  INT = 0.0

                     ,@x_QTY101 INT = 0.0 ,@x_QTY102  INT = 0.0 ,@x_QTY103  INT = 0.0 ,@x_QTY104  INT = 0.0 ,@x_QTY105  INT = 0.0
                     ,@x_QTY106	INT = 0.0 ,@x_QTY107  INT = 0.0 ,@x_QTY108  INT = 0.0 ,@x_QTY109  INT = 0.0 ,@x_QTY110  INT = 0.0
                     ,@x_QTY111 INT = 0.0 ,@x_QTY112  INT = 0.0 

                     
                     ,@x_WQTY16	INT = 0.0 ,@x_WQTY17  INT = 0.0 ,@x_WQTY18  INT = 0.0 ,@x_WQTY19  INT = 0.0 ,@x_WQTY20  INT = 0.0
                     ,@x_WQTY21 INT = 0.0 ,@x_WQTY22  INT = 0.0 ,@x_WQTY23  INT = 0.0 ,@x_WQTY24  INT = 0.0 ,@x_WQTY25  INT = 0.0
                     ,@x_WQTY26	INT = 0.0 ,@x_WQTY27  INT = 0.0 ,@x_WQTY28  INT = 0.0 ,@x_WQTY29  INT = 0.0 ,@x_WQTY30  INT = 0.0
                     ,@x_WQTY31 INT = 0.0 ,@x_WQTY32  INT = 0.0 ,@x_WQTY33  INT = 0.0 ,@x_WQTY34  INT = 0.0 ,@x_WQTY35  INT = 0.0
                     ,@x_WQTY36	INT = 0.0 ,@x_WQTY37  INT = 0.0 ,@x_WQTY38  INT = 0.0 ,@x_WQTY39  INT = 0.0 ,@x_WQTY40  INT = 0.0
                     ,@x_WQTY41 INT = 0.0 ,@x_WQTY42  INT = 0.0 ,@x_WQTY43  INT = 0.0 ,@x_WQTY44  INT = 0.0 ,@x_WQTY45  INT = 0.0
                     ,@x_WQTY46	INT = 0.0 ,@x_WQTY47  INT = 0.0 ,@x_WQTY48  INT = 0.0 ,@x_WQTY49  INT = 0.0 ,@x_WQTY50  INT = 0.0
                     ,@x_WQTY51 INT = 0.0 ,@x_WQTY52  INT = 0.0 
            */
            /*
            IF @p_day_week_flag = 'day'
              BEGIN
                 SELECT 
                         @X_QTY001 = QTY001  ,@X_QTY002  = QTY002  ,@X_QTY003  = QTY003  ,@X_QTY004  = QTY004  ,@X_QTY005  = QTY005  ,@X_QTY006  = QTY006  ,@X_QTY007  = QTY007  ,@X_QTY008  = QTY008  ,@X_QTY009  = QTY009  ,@X_QTY010  = QTY010
                        ,@X_QTY011 = QTY011  ,@X_QTY012  = QTY012  ,@X_QTY013  = QTY013  ,@X_QTY014  = QTY014  ,@X_QTY015  = QTY015  ,@X_QTY016  = QTY016  ,@X_QTY017  = QTY017  ,@X_QTY018  = QTY018  ,@X_QTY019  = QTY019  ,@X_QTY020  = QTY020
                        ,@X_QTY021 = QTY021  ,@X_QTY022  = QTY022  ,@X_QTY023  = QTY023  ,@X_QTY024  = QTY024  ,@X_QTY025  = QTY025  ,@X_QTY026  = QTY026  ,@X_QTY027  = QTY027  ,@X_QTY028  = QTY028  ,@X_QTY029  = QTY029  ,@X_QTY030  = QTY030
                        ,@X_QTY031 = QTY031  ,@X_QTY032  = QTY032  ,@X_QTY033  = QTY033  ,@X_QTY034  = QTY034  ,@X_QTY035  = QTY035  ,@X_QTY036  = QTY036  ,@X_QTY037  = QTY037  ,@X_QTY038  = QTY038  ,@X_QTY039  = QTY039  ,@X_QTY040  = QTY040
                        ,@X_QTY041 = QTY041  ,@X_QTY042  = QTY042  ,@X_QTY043  = QTY043  ,@X_QTY044  = QTY044  ,@X_QTY045  = QTY045  ,@X_QTY046  = QTY046  ,@X_QTY047  = QTY047  ,@X_QTY048  = QTY048  ,@X_QTY049  = QTY049  ,@X_QTY050  = QTY050
                        ,@X_QTY051 = QTY051  ,@X_QTY052  = QTY052  ,@X_QTY053  = QTY053  ,@X_QTY054  = QTY054  ,@X_QTY055  = QTY055  ,@X_QTY056  = QTY056  ,@X_QTY057  = QTY057  ,@X_QTY058  = QTY058  ,@X_QTY059  = QTY059  ,@X_QTY060  = QTY060
                        ,@X_QTY061 = QTY061  ,@X_QTY062  = QTY062  ,@X_QTY063  = QTY063  ,@X_QTY064  = QTY064  ,@X_QTY065  = QTY065  ,@X_QTY066  = QTY066  ,@X_QTY067  = QTY067  ,@X_QTY068  = QTY068  ,@X_QTY069  = QTY069  ,@X_QTY070  = QTY070
                        ,@X_QTY071 = QTY071  ,@X_QTY072  = QTY072  ,@X_QTY073  = QTY073  ,@X_QTY074  = QTY074  ,@X_QTY075  = QTY075  ,@X_QTY076  = QTY076  ,@X_QTY077  = QTY077  ,@X_QTY078  = QTY078  ,@X_QTY079  = QTY079  ,@X_QTY080  = QTY080
                        ,@X_QTY081 = QTY081  ,@X_QTY082  = QTY082  ,@X_QTY083  = QTY083  ,@X_QTY084  = QTY084  ,@X_QTY085  = QTY085  ,@X_QTY086  = QTY086  ,@X_QTY087  = QTY087  ,@X_QTY088  = QTY088  ,@X_QTY089  = QTY089  ,@X_QTY090  = QTY090
                        ,@X_QTY091 = QTY091  ,@X_QTY092  = QTY092  ,@X_QTY093  = QTY093  ,@X_QTY094  = QTY094  ,@X_QTY095  = QTY095  ,@X_QTY096  = QTY096  ,@X_QTY097  = QTY097  ,@X_QTY098  = QTY098  ,@X_QTY099  = QTY099  ,@X_QTY100  = QTY100

                        ,@X_QTY101 = QTY101  ,@X_QTY102  = QTY102  ,@X_QTY103  = QTY103  ,@X_QTY104  = QTY004  ,@X_QTY105  = QTY105  ,@X_QTY106  = QTY106  ,@X_QTY107  = QTY107  ,@X_QTY108  = QTY108  ,@X_QTY109  = QTY109  ,@X_QTY110  = QTY110
                        ,@X_QTY111 = QTY111  ,@X_QTY112  = QTY112 

                   FROM DBO.SCP_XLS_PSI_GLOBAL_ESS WITH(NOLOCK)
                  WHERE 0 = 0
                    AND DIVISION_ID         = @p_division_id
                    AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
                    AND SEQ                 = @p_seq
                    AND XLS_KEY1            = @p_xls_key1; 
              END
              */
              /*
          IF @p_day_week_flag = 'week'
              BEGIN
                 SELECT 
                         
                         @X_WQTY01 = WQTY01  ,@X_WQTY02  = WQTY02  ,@X_WQTY03  = WQTY03  ,@X_WQTY04  = WQTY04  ,@X_WQTY05  = WQTY05  ,@X_WQTY06  = WQTY06  ,@X_WQTY07  = WQTY07  ,@X_WQTY08  = WQTY08  ,@X_WQTY09  = WQTY09  ,@X_WQTY10  = WQTY10
                        ,@X_WQTY11 = WQTY11  ,@X_WQTY12  = WQTY12  ,@X_WQTY13  = WQTY13  ,@X_WQTY14  = WQTY14  ,@X_WQTY15  = WQTY15  ,@X_WQTY16  = WQTY16  
                                                                                                                                                           ,@X_WQTY17  = WQTY17  ,@X_WQTY18  = WQTY18  ,@X_WQTY19  = WQTY19  ,@X_WQTY20  = WQTY20
                        ,@X_WQTY21 = WQTY21  ,@X_WQTY22  = WQTY22  ,@X_WQTY23  = WQTY23  ,@X_WQTY24  = WQTY24  ,@X_WQTY25  = WQTY25  ,@X_WQTY26  = WQTY26  ,@X_WQTY27  = WQTY27  ,@X_WQTY28  = WQTY28  ,@X_WQTY29  = WQTY29  ,@X_WQTY30  = WQTY30
                        ,@X_WQTY31 = WQTY31  ,@X_WQTY32  = WQTY32  ,@X_WQTY33  = WQTY33  ,@X_WQTY34  = WQTY34  ,@X_WQTY35  = WQTY35  ,@X_WQTY36  = WQTY36  ,@X_WQTY37  = WQTY37  ,@X_WQTY38  = WQTY38  ,@X_WQTY39  = WQTY39  ,@X_WQTY40  = WQTY40
                        ,@X_WQTY41 = WQTY41  ,@X_WQTY42  = WQTY42  ,@X_WQTY43  = WQTY43  ,@X_WQTY44  = WQTY44  ,@X_WQTY45  = WQTY45  ,@X_WQTY46  = WQTY46  ,@X_WQTY47  = WQTY47  ,@X_WQTY48  = WQTY48  ,@X_WQTY49  = WQTY49  ,@X_WQTY50  = WQTY50
                        ,@X_WQTY51 = WQTY51  ,@X_WQTY52  = WQTY52  
                   FROM DBO.SCP_XLS_PSI_GLOBAL_ESS WITH(NOLOCK)
                  WHERE 0 = 0
                    AND DIVISION_ID         = @p_division_id
                    AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
                    AND SEQ                 = @p_seq
                    AND XLS_KEY1            = @p_xls_key1; 
              END
              */


            
            -------------------------------------------------------------------------------------------------------------
            -- SCP_XLS_PSI_GLOBAL_ESS (XLSPSI04) 화면조회용 테이블에 해당 레코드를 수정한다.
            -------------------------------------------------------------------------------------------------------------
             -- CELL_PROD,PACK_PROD         --> SCP_ANL_PRODUCTION_PLAN.MEASURE 'PROD_PLAN_AMEND'
             -- SEMI_SHIP_PLAN, SHIP_PLAN   --> SHIP_PLAN_AMEND           
            -------------------------------------------------------------------------------------------------------------         
            -- WEEK DATA를 DAY DATA로 반영  
            -- 확정 구간이 주에 포함될 경우 수정금지 구간을 제외하고, 일 배분해야 함.
            -------------------------------------------------------------------------------------------------------------   

            IF @p_measure IN  ('PACK_PROD','CELL_CHAR_PLAN','CELL_PROD')    -- CELL_CHAR_PLAN SCP_XLS_PSI_GLOBAL_ESS 테이블에 저장만 처리함.
               BEGIN
               /*
               IF  @p_day_week_flag = 'day'
                BEGIN
                     UPDATE X
                        SET  
                             QTY001 = @p_QTY001 ,QTY002  = @p_QTY002  ,QTY003 = @p_QTY003 ,QTY004 = @p_QTY004 ,QTY005  = @p_QTY005 ,QTY006  = @p_QTY006 ,QTY007 = @p_QTY007 
                            ,QTY008 = @p_QTY008 ,QTY009  = @p_QTY009  ,QTY010 = @p_QTY010 ,QTY011 = @p_QTY011 ,QTY012  = @p_QTY012 ,QTY013  = @p_QTY013 ,QTY014 = @p_QTY014
                            ,QTY015 = @p_QTY015 ,QTY016  = @p_QTY016  ,QTY017 = @p_QTY017 ,QTY018 = @p_QTY018 ,QTY019  = @p_QTY019 ,QTY020  = @p_QTY020 ,QTY021 = @p_QTY021
                            ,QTY022 = @p_QTY022 ,QTY023  = @p_QTY023  ,QTY024 = @p_QTY024 ,QTY025 = @p_QTY025 ,QTY026  = @p_QTY026 ,QTY027  = @p_QTY027 ,QTY028 = @p_QTY028
                            ,QTY029 = @p_QTY029 ,QTY030  = @p_QTY030  ,QTY031 = @p_QTY031 ,QTY032 = @p_QTY032 ,QTY033  = @p_QTY033 ,QTY034  = @p_QTY034 ,QTY035 = @p_QTY035
                            ,QTY036 = @p_QTY036 ,QTY037  = @p_QTY037  ,QTY038 = @p_QTY038 ,QTY039 = @p_QTY039 ,QTY040  = @p_QTY040 ,QTY041  = @p_QTY041 ,QTY042 = @p_QTY042
                            ,QTY043 = @p_QTY043 ,QTY044  = @p_QTY044  ,QTY045 = @p_QTY045 ,QTY046 = @p_QTY046 ,QTY047  = @p_QTY047 ,QTY048  = @p_QTY048 ,QTY049 = @p_QTY049
                            ,QTY050 = @p_QTY050 ,QTY051  = @p_QTY051  ,QTY052 = @p_QTY052 ,QTY053 = @p_QTY053 ,QTY054  = @p_QTY054 ,QTY055  = @p_QTY055 ,QTY056 = @p_QTY056
                            ,QTY057 = @p_QTY057 ,QTY058  = @p_QTY058  ,QTY059 = @p_QTY059 ,QTY060 = @p_QTY060 ,QTY061  = @p_QTY061 ,QTY062  = @p_QTY062 ,QTY063 = @p_QTY063
                            ,QTY064 = @p_QTY064 ,QTY065  = @p_QTY065  ,QTY066 = @p_QTY066 ,QTY067 = @p_QTY067 ,QTY068  = @p_QTY068 ,QTY069  = @p_QTY069 ,QTY070 = @p_QTY070
                            ,QTY071 = @p_QTY071 ,QTY072  = @p_QTY072  ,QTY073 = @p_QTY073 ,QTY074 = @p_QTY074 ,QTY075  = @p_QTY075 ,QTY076  = @p_QTY076 ,QTY077 = @p_QTY077
                            ,QTY078 = @p_QTY078 ,QTY079  = @p_QTY079  ,QTY080 = @p_QTY080 ,QTY081 = @p_QTY081 ,QTY082  = @p_QTY082 ,QTY083  = @p_QTY083 ,QTY084 = @p_QTY084
                            ,QTY085 = @p_QTY085 ,QTY086  = @p_QTY086  ,QTY087 = @p_QTY087 ,QTY088 = @p_QTY088 ,QTY089  = @p_QTY089 ,QTY090  = @p_QTY090 ,QTY091 = @p_QTY091
                            ,QTY092 = @p_QTY092 ,QTY093  = @p_QTY093  ,QTY094 = @p_QTY094 ,QTY095 = @p_QTY095 ,QTY096  = @p_QTY096 ,QTY097  = @p_QTY097 ,QTY098 = @p_QTY098
                            ,QTY099 = @p_QTY099 ,QTY100  = @p_QTY100  ,QTY101 = @p_QTY101 ,QTY102 = @p_QTY102 ,QTY103  = @p_QTY103 ,QTY104  = @p_QTY104 ,QTY105 = @p_QTY105
                            ,QTY106 = @p_QTY106 ,QTY107  = @p_QTY107  ,QTY108 = @p_QTY108 ,QTY109 = @p_QTY109 ,QTY110  = @p_QTY110 ,QTY111  = @p_QTY111 ,QTY112 = @p_QTY112

                            ,LAST_UPDATED_BY    = @p_user_id
                            ,LAST_UPDATE_DATE   = GETDATE()
                      FROM SCP_XLS_PSI_GLOBAL_ESS X  WITH (NOLOCK)
                      WHERE 0 = 0
                        AND DIVISION_ID         = @p_division_id
                        AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
                        AND SEQ                 = @p_seq
                        AND XLS_KEY1            = @p_xls_key1;    

                END  --  @p_day_week_flag = 'day'
                */

                IF  @p_day_week_flag = 'week'
                BEGIN
                    

                    UPDATE DBO.SCP_XLS_PSI_GLOBAL_ESS
                        SET  
                             QTY001 = @p_WQTY01/7 ,QTY002  = @p_WQTY01/7  ,QTY003 = @p_WQTY01/7 ,QTY004 = @p_WQTY01/7 ,QTY005  = @p_WQTY01/7 ,QTY006  = @p_WQTY01/7 ,QTY007 = ((@p_WQTY01/7)+(@p_WQTY01%7))
                            ,QTY008 = @p_WQTY02/7 ,QTY009  = @p_WQTY02/7  ,QTY010 = @p_WQTY02/7 ,QTY011 = @p_WQTY02/7 ,QTY012  = @p_WQTY02/7 ,QTY013  = @p_WQTY02/7 ,QTY014 = ((@p_WQTY02/7)+(@p_WQTY02%7))
                            ,QTY015 = @p_WQTY03/7 ,QTY016  = @p_WQTY03/7  ,QTY017 = @p_WQTY03/7 ,QTY018 = @p_WQTY03/7 ,QTY019  = @p_WQTY03/7 ,QTY020  = @p_WQTY03/7 ,QTY021 = ((@p_WQTY03/7)+(@p_WQTY03%7))
                            ,QTY022 = @p_WQTY04/7 ,QTY023  = @p_WQTY04/7  ,QTY024 = @p_WQTY04/7 ,QTY025 = @p_WQTY04/7 ,QTY026  = @p_WQTY04/7 ,QTY027  = @p_WQTY04/7 ,QTY028 = ((@p_WQTY04/7)+(@p_WQTY04%7))
                            ,QTY029 = @p_WQTY05/7 ,QTY030  = @p_WQTY05/7  ,QTY031 = @p_WQTY05/7 ,QTY032 = @p_WQTY05/7 ,QTY033  = @p_WQTY05/7 ,QTY034  = @p_WQTY05/7 ,QTY035 = ((@p_WQTY05/7)+(@p_WQTY05%7))
                            ,QTY036 = @p_WQTY06/7 ,QTY037  = @p_WQTY06/7  ,QTY038 = @p_WQTY06/7 ,QTY039 = @p_WQTY06/7 ,QTY040  = @p_WQTY06/7 ,QTY041  = @p_WQTY06/7 ,QTY042 = ((@p_WQTY06/7)+(@p_WQTY06%7))
                            ,QTY043 = @p_WQTY07/7 ,QTY044  = @p_WQTY07/7  ,QTY045 = @p_WQTY07/7 ,QTY046 = @p_WQTY07/7 ,QTY047  = @p_WQTY07/7 ,QTY048  = @p_WQTY07/7 ,QTY049 = ((@p_WQTY07/7)+(@p_WQTY07%7))
                            ,QTY050 = @p_WQTY08/7 ,QTY051  = @p_WQTY08/7  ,QTY052 = @p_WQTY08/7 ,QTY053 = @p_WQTY08/7 ,QTY054  = @p_WQTY08/7 ,QTY055  = @p_WQTY08/7 ,QTY056 = ((@p_WQTY08/7)+(@p_WQTY08%7))
                            ,QTY057 = @p_WQTY09/7 ,QTY058  = @p_WQTY09/7  ,QTY059 = @p_WQTY09/7 ,QTY060 = @p_WQTY09/7 ,QTY061  = @p_WQTY09/7 ,QTY062  = @p_WQTY09/7 ,QTY063 = ((@p_WQTY09/7)+(@p_WQTY09%7))
                            ,QTY064 = @p_WQTY10/7 ,QTY065  = @p_WQTY10/7  ,QTY066 = @p_WQTY10/7 ,QTY067 = @p_WQTY10/7 ,QTY068  = @p_WQTY10/7 ,QTY069  = @p_WQTY10/7 ,QTY070 = ((@p_WQTY10/7)+(@p_WQTY10%7))
                            ,QTY071 = @p_WQTY11/7 ,QTY072  = @p_WQTY11/7  ,QTY073 = @p_WQTY11/7 ,QTY074 = @p_WQTY11/7 ,QTY075  = @p_WQTY11/7 ,QTY076  = @p_WQTY11/7 ,QTY077 = ((@p_WQTY11/7)+(@p_WQTY11%7))
                            ,QTY078 = @p_WQTY12/7 ,QTY079  = @p_WQTY12/7  ,QTY080 = @p_WQTY12/7 ,QTY081 = @p_WQTY12/7 ,QTY082  = @p_WQTY12/7 ,QTY083  = @p_WQTY12/7 ,QTY084 = ((@p_WQTY12/7)+(@p_WQTY12%7))
                            ,QTY085 = @p_WQTY13/7 ,QTY086  = @p_WQTY13/7  ,QTY087 = @p_WQTY13/7 ,QTY088 = @p_WQTY13/7 ,QTY089  = @p_WQTY13/7 ,QTY090  = @p_WQTY13/7 ,QTY091 = ((@p_WQTY13/7)+(@p_WQTY13%7))
                            ,QTY092 = @p_WQTY14/7 ,QTY093  = @p_WQTY14/7  ,QTY094 = @p_WQTY14/7 ,QTY095 = @p_WQTY14/7 ,QTY096  = @p_WQTY14/7 ,QTY097  = @p_WQTY14/7 ,QTY098 = ((@p_WQTY14/7)+(@p_WQTY14%7))
                            ,QTY099 = @p_WQTY15/7 ,QTY100  = @p_WQTY15/7  ,QTY101 = @p_WQTY15/7 ,QTY102 = @p_WQTY15/7 ,QTY103  = @p_WQTY15/7 ,QTY104  = @p_WQTY15/7 ,QTY105 = ((@p_WQTY15/7)+(@p_WQTY15%7))
                            ,QTY106 = @p_WQTY16/7 ,QTY107  = @p_WQTY16/7  ,QTY108 = @p_WQTY16/7 ,QTY109 = @p_WQTY16/7 ,QTY110  = @p_WQTY16/7 ,QTY111  = @p_WQTY16/7 ,QTY112 = ((@p_WQTY16/7)+(@p_WQTY16%7))
                            ,QTY113 = @p_WQTY17/7 ,QTY114  = @p_WQTY17/7  ,QTY115 = @p_WQTY17/7 ,QTY116 = @p_WQTY17/7 ,QTY117  = @p_WQTY17/7 ,QTY118  = @p_WQTY17/7 ,QTY119 = ((@p_WQTY17/7)+(@p_WQTY17%7))
                            ,QTY120 = @p_WQTY18/7 ,QTY121  = @p_WQTY18/7  ,QTY122 = @p_WQTY18/7 ,QTY123 = @p_WQTY18/7 ,QTY124  = @p_WQTY18/7 ,QTY125  = @p_WQTY18/7 ,QTY126 = ((@p_WQTY18/7)+(@p_WQTY18%7))
                            ,QTY127 = @p_WQTY19/7 ,QTY128  = @p_WQTY19/7  ,QTY129 = @p_WQTY19/7 ,QTY130 = @p_WQTY19/7 ,QTY131  = @p_WQTY19/7 ,QTY132  = @p_WQTY19/7 ,QTY133 = ((@p_WQTY19/7)+(@p_WQTY19%7))
                            ,QTY134 = @p_WQTY20/7 ,QTY135  = @p_WQTY20/7  ,QTY136 = @p_WQTY20/7 ,QTY137 = @p_WQTY20/7 ,QTY138  = @p_WQTY20/7 ,QTY139  = @p_WQTY20/7 ,QTY140 = ((@p_WQTY20/7)+(@p_WQTY20%7))
                            ,QTY141 = @p_WQTY21/7 ,QTY142  = @p_WQTY21/7  ,QTY143 = @p_WQTY21/7 ,QTY144 = @p_WQTY21/7 ,QTY145  = @p_WQTY21/7 ,QTY146  = @p_WQTY21/7 ,QTY147 = ((@p_WQTY21/7)+(@p_WQTY21%7))
                            ,QTY148 = @p_WQTY22/7 ,QTY149  = @p_WQTY22/7  ,QTY150 = @p_WQTY22/7 ,QTY151 = @p_WQTY22/7 ,QTY152  = @p_WQTY22/7 ,QTY153  = @p_WQTY22/7 ,QTY154 = ((@p_WQTY22/7)+(@p_WQTY22%7))
                            ,QTY155 = @p_WQTY23/7 ,QTY156  = @p_WQTY23/7  ,QTY157 = @p_WQTY23/7 ,QTY158 = @p_WQTY23/7 ,QTY159  = @p_WQTY23/7 ,QTY160  = @p_WQTY23/7 ,QTY161 = ((@p_WQTY23/7)+(@p_WQTY23%7))
                            ,QTY162 = @p_WQTY24/7 ,QTY163  = @p_WQTY24/7  ,QTY164 = @p_WQTY24/7 ,QTY165 = @p_WQTY24/7 ,QTY166  = @p_WQTY24/7 ,QTY167  = @p_WQTY24/7 ,QTY168 = ((@p_WQTY24/7)+(@p_WQTY24%7))
                            ,QTY169 = @p_WQTY25/7 ,QTY170  = @p_WQTY25/7  ,QTY171 = @p_WQTY25/7 ,QTY172 = @p_WQTY25/7 ,QTY173  = @p_WQTY25/7 ,QTY174  = @p_WQTY25/7 ,QTY175 = ((@p_WQTY25/7)+(@p_WQTY25%7))
                            ,QTY176 = @p_WQTY26/7 ,QTY177  = @p_WQTY26/7  ,QTY178 = @p_WQTY26/7 ,QTY179 = @p_WQTY26/7 ,QTY180  = @p_WQTY26/7 ,QTY181  = @p_WQTY26/7 ,QTY182 = ((@p_WQTY26/7)+(@p_WQTY26%7))
                            ,QTY183 = @p_WQTY27/7 ,QTY184  = @p_WQTY27/7  ,QTY185 = @p_WQTY27/7 ,QTY186 = @p_WQTY27/7 ,QTY187  = @p_WQTY27/7 ,QTY188  = @p_WQTY27/7 ,QTY189 = ((@p_WQTY27/7)+(@p_WQTY27%7))
                            ,QTY190 = @p_WQTY28/7 ,QTY191  = @p_WQTY28/7  ,QTY192 = @p_WQTY28/7 ,QTY193 = @p_WQTY28/7 ,QTY194  = @p_WQTY28/7 ,QTY195  = @p_WQTY28/7 ,QTY196 = ((@p_WQTY28/7)+(@p_WQTY28%7))
                            ,QTY197 = @p_WQTY29/7 ,QTY198  = @p_WQTY29/7  ,QTY199 = @p_WQTY29/7 ,QTY200 = @p_WQTY29/7 ,QTY201  = @p_WQTY29/7 ,QTY202  = @p_WQTY29/7 ,QTY203 = ((@p_WQTY29/7)+(@p_WQTY29%7))
                            ,QTY204 = @p_WQTY30/7 ,QTY205  = @p_WQTY30/7  ,QTY206 = @p_WQTY30/7 ,QTY207 = @p_WQTY30/7 ,QTY208  = @p_WQTY30/7 ,QTY209  = @p_WQTY30/7 ,QTY210 = ((@p_WQTY30/7)+(@p_WQTY30%7))
                            ,QTY211 = @p_WQTY31/7 ,QTY212  = @p_WQTY31/7  ,QTY213 = @p_WQTY31/7 ,QTY214 = @p_WQTY31/7 ,QTY215  = @p_WQTY31/7 ,QTY216  = @p_WQTY31/7 ,QTY217 = ((@p_WQTY31/7)+(@p_WQTY31%7))
                            ,QTY218 = @p_WQTY32/7 ,QTY219  = @p_WQTY32/7  ,QTY220 = @p_WQTY32/7 ,QTY221 = @p_WQTY32/7 ,QTY222  = @p_WQTY32/7 ,QTY223  = @p_WQTY32/7 ,QTY224 = ((@p_WQTY32/7)+(@p_WQTY32%7))
                            ,QTY225 = @p_WQTY33/7 ,QTY226  = @p_WQTY33/7  ,QTY227 = @p_WQTY33/7 ,QTY228 = @p_WQTY33/7 ,QTY229  = @p_WQTY33/7 ,QTY230  = @p_WQTY33/7 ,QTY231 = ((@p_WQTY33/7)+(@p_WQTY33%7))
                            ,QTY232 = @p_WQTY34/7 ,QTY233  = @p_WQTY34/7  ,QTY234 = @p_WQTY34/7 ,QTY235 = @p_WQTY34/7 ,QTY236  = @p_WQTY34/7 ,QTY237  = @p_WQTY34/7 ,QTY238 = ((@p_WQTY34/7)+(@p_WQTY34%7))
                            ,QTY239 = @p_WQTY35/7 ,QTY240  = @p_WQTY35/7  ,QTY241 = @p_WQTY35/7 ,QTY242 = @p_WQTY35/7 ,QTY243  = @p_WQTY35/7 ,QTY244  = @p_WQTY35/7 ,QTY245 = ((@p_WQTY35/7)+(@p_WQTY35%7))
                            ,QTY246 = @p_WQTY36/7 ,QTY247  = @p_WQTY36/7  ,QTY248 = @p_WQTY36/7 ,QTY249 = @p_WQTY36/7 ,QTY250  = @p_WQTY36/7 ,QTY251  = @p_WQTY36/7 ,QTY252 = ((@p_WQTY36/7)+(@p_WQTY36%7))
                            ,QTY253 = @p_WQTY37/7 ,QTY254  = @p_WQTY37/7  ,QTY255 = @p_WQTY37/7 ,QTY256 = @p_WQTY37/7 ,QTY257  = @p_WQTY37/7 ,QTY258  = @p_WQTY37/7 ,QTY259 = ((@p_WQTY37/7)+(@p_WQTY37%7))
                            ,QTY260 = @p_WQTY38/7 ,QTY261  = @p_WQTY38/7  ,QTY262 = @p_WQTY38/7 ,QTY263 = @p_WQTY38/7 ,QTY264  = @p_WQTY38/7 ,QTY265  = @p_WQTY38/7 ,QTY266 = ((@p_WQTY38/7)+(@p_WQTY38%7))
                            ,QTY267 = @p_WQTY39/7 ,QTY268  = @p_WQTY39/7  ,QTY269 = @p_WQTY39/7 ,QTY270 = @p_WQTY39/7 ,QTY271  = @p_WQTY39/7 ,QTY272  = @p_WQTY39/7 ,QTY273 = ((@p_WQTY39/7)+(@p_WQTY39%7))
                            ,QTY274 = @p_WQTY40/7 ,QTY275  = @p_WQTY40/7  ,QTY276 = @p_WQTY40/7 ,QTY277 = @p_WQTY40/7 ,QTY278  = @p_WQTY40/7 ,QTY279  = @p_WQTY40/7 ,QTY280 = ((@p_WQTY40/7)+(@p_WQTY40%7))
                            ,QTY281 = @p_WQTY41/7 ,QTY282  = @p_WQTY41/7  ,QTY283 = @p_WQTY41/7 ,QTY284 = @p_WQTY41/7 ,QTY285  = @p_WQTY41/7 ,QTY286  = @p_WQTY41/7 ,QTY287 = ((@p_WQTY41/7)+(@p_WQTY41%7))
                            ,QTY288 = @p_WQTY42/7 ,QTY289  = @p_WQTY42/7  ,QTY290 = @p_WQTY42/7 ,QTY291 = @p_WQTY42/7 ,QTY292  = @p_WQTY42/7 ,QTY293  = @p_WQTY42/7 ,QTY294 = ((@p_WQTY42/7)+(@p_WQTY42%7))
                            ,QTY295 = @p_WQTY43/7 ,QTY296  = @p_WQTY43/7  ,QTY297 = @p_WQTY43/7 ,QTY298 = @p_WQTY43/7 ,QTY299  = @p_WQTY43/7 ,QTY300  = @p_WQTY43/7 ,QTY301 = ((@p_WQTY43/7)+(@p_WQTY43%7))
                            ,QTY302 = @p_WQTY44/7 ,QTY303  = @p_WQTY44/7  ,QTY304 = @p_WQTY44/7 ,QTY305 = @p_WQTY44/7 ,QTY306  = @p_WQTY44/7 ,QTY307  = @p_WQTY44/7 ,QTY308 = ((@p_WQTY44/7)+(@p_WQTY44%7))
                            ,QTY309 = @p_WQTY45/7 ,QTY310  = @p_WQTY45/7  ,QTY311 = @p_WQTY45/7 ,QTY312 = @p_WQTY45/7 ,QTY313  = @p_WQTY45/7 ,QTY314  = @p_WQTY45/7 ,QTY315 = ((@p_WQTY45/7)+(@p_WQTY45%7))
                            ,QTY316 = @p_WQTY46/7 ,QTY317  = @p_WQTY46/7  ,QTY318 = @p_WQTY46/7 ,QTY319 = @p_WQTY46/7 ,QTY320  = @p_WQTY46/7 ,QTY321  = @p_WQTY46/7 ,QTY322 = ((@p_WQTY46/7)+(@p_WQTY46%7))
                            ,QTY323 = @p_WQTY47/7 ,QTY324  = @p_WQTY47/7  ,QTY325 = @p_WQTY47/7 ,QTY326 = @p_WQTY47/7 ,QTY327  = @p_WQTY47/7 ,QTY328  = @p_WQTY47/7 ,QTY329 = ((@p_WQTY47/7)+(@p_WQTY47%7))
                            ,QTY330 = @p_WQTY48/7 ,QTY331  = @p_WQTY48/7  ,QTY332 = @p_WQTY48/7 ,QTY333 = @p_WQTY48/7 ,QTY334  = @p_WQTY48/7 ,QTY335  = @p_WQTY48/7 ,QTY336 = ((@p_WQTY48/7)+(@p_WQTY48%7))
                            ,QTY337 = @p_WQTY49/7 ,QTY338  = @p_WQTY49/7  ,QTY339 = @p_WQTY49/7 ,QTY340 = @p_WQTY49/7 ,QTY341  = @p_WQTY49/7 ,QTY342  = @p_WQTY49/7 ,QTY343 = ((@p_WQTY49/7)+(@p_WQTY49%7))
                            ,QTY344 = @p_WQTY50/7 ,QTY345  = @p_WQTY50/7  ,QTY346 = @p_WQTY50/7 ,QTY347 = @p_WQTY50/7 ,QTY348  = @p_WQTY50/7 ,QTY349  = @p_WQTY50/7 ,QTY350 = ((@p_WQTY50/7)+(@p_WQTY50%7))
                            ,QTY351 = @p_WQTY51/7 ,QTY352  = @p_WQTY51/7  ,QTY353 = @p_WQTY51/7 ,QTY354 = @p_WQTY51/7 ,QTY355  = @p_WQTY51/7 ,QTY356  = @p_WQTY51/7 ,QTY357 = ((@p_WQTY51/7)+(@p_WQTY51%7))
                            ,QTY358 = @p_WQTY52/7 ,QTY359  = @p_WQTY52/7  ,QTY360 = @p_WQTY52/7 ,QTY361 = @p_WQTY52/7 ,QTY362  = @p_WQTY52/7 ,QTY363  = @p_WQTY52/7 ,QTY364 = ((@p_WQTY52/7)+(@p_WQTY52%7))

                            ,WQTY01 = @p_WQTY01  ,WQTY02  = @p_WQTY02  ,WQTY03  = @p_WQTY03  ,WQTY04  = @p_WQTY04  ,WQTY05  = @p_WQTY05  ,WQTY06  = @p_WQTY06  ,WQTY07  = @p_WQTY07  ,WQTY08  = @p_WQTY08  ,WQTY09  = @p_WQTY09  ,WQTY10  = @p_WQTY10
                            ,WQTY11 = @p_WQTY11  ,WQTY12  = @p_WQTY12  ,WQTY13  = @p_WQTY13  ,WQTY14  = @p_WQTY14  ,WQTY15  = @p_WQTY15  ,WQTY16  = @p_WQTY16  ,WQTY17  = @p_WQTY17  ,WQTY18  = @p_WQTY18  ,WQTY19  = @p_WQTY19  ,WQTY20  = @p_WQTY20
                            ,WQTY21 = @p_WQTY21  ,WQTY22  = @p_WQTY22  ,WQTY23  = @p_WQTY23  ,WQTY24  = @p_WQTY24  ,WQTY25  = @p_WQTY25  ,WQTY26  = @p_WQTY26  ,WQTY27  = @p_WQTY27  ,WQTY28  = @p_WQTY28  ,WQTY29  = @p_WQTY29  ,WQTY30  = @p_WQTY30
                            ,WQTY31 = @p_WQTY31  ,WQTY32  = @p_WQTY32  ,WQTY33  = @p_WQTY33  ,WQTY34  = @p_WQTY34  ,WQTY35  = @p_WQTY35  ,WQTY36  = @p_WQTY36  ,WQTY37  = @p_WQTY37  ,WQTY38  = @p_WQTY38  ,WQTY39  = @p_WQTY39  ,WQTY40  = @p_WQTY40
                            ,WQTY41 = @p_WQTY41  ,WQTY42  = @p_WQTY42  ,WQTY43  = @p_WQTY43  ,WQTY44  = @p_WQTY44  ,WQTY45  = @p_WQTY45  ,WQTY46  = @p_WQTY46  ,WQTY47  = @p_WQTY47  ,WQTY48  = @p_WQTY48  ,WQTY49  = @p_WQTY49  ,WQTY50  = @p_WQTY50
                            ,WQTY51 = @p_WQTY51  ,WQTY52  = @p_WQTY52 
                            ,LAST_UPDATED_BY    = @p_user_id
                            ,LAST_UPDATE_DATE   = GETDATE()
                            ,ATTRIBUTE2         = 'Y'
                      WHERE 0 = 0
                        AND DIVISION_ID         = @p_division_id
                        AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
                        AND SEQ                 = @p_seq
                        AND XLS_KEY1            = @p_xls_key1;    
                END  --  @p_day_week_flag = 'week'
                
  
              END

            -------------------------------------------------------------------------------------------------------------         
            -- 'SHIP_PLAN','SEMI_SHIP_PLAN' 일경우 지정 요일에 저장
            --  대상 주QTY가 -9 일경우는 기존 값(0)을 사용하고, +일경우는 값을 UPDATE한다.
            ------------------------------------------------------------------------------------------------------------- 
            -------------------------------------------------------------------------------------------------------------
            IF @p_measure IN  ('SHIP_PLAN','SEMI_SHIP_PLAN')   --
              BEGIN 
              
               IF  @p_day_week_flag = 'week'
                BEGIN
                  UPDATE X
                   SET   
                         X.QTY001 = (CASE WHEN @p_WQTY01 < 0 THEN X.QTY001 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY01 ELSE 0 END )  END)
                        ,X.QTY002 = (CASE WHEN @p_WQTY01 < 0 THEN X.QTY002 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY01 ELSE 0 END )  END)
                        ,X.QTY003 = (CASE WHEN @p_WQTY01 < 0 THEN X.QTY003 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY01 ELSE 0 END )  END)
                        ,X.QTY004 = (CASE WHEN @p_WQTY01 < 0 THEN X.QTY004 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY01 ELSE 0 END )  END)
                        ,X.QTY005 = (CASE WHEN @p_WQTY01 < 0 THEN X.QTY005 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY01 ELSE 0 END )  END)
                        ,X.QTY006 = (CASE WHEN @p_WQTY01 < 0 THEN X.QTY006 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY01 ELSE 0 END )  END)
                        ,X.QTY007 = (CASE WHEN @p_WQTY01 < 0 THEN X.QTY007 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY01 ELSE 0 END )  END)
                                                                                                                              
                        ,X.QTY008 = (CASE WHEN @p_WQTY02 < 0 THEN X.QTY008 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY02 ELSE 0 END )  END)
                        ,X.QTY009 = (CASE WHEN @p_WQTY02 < 0 THEN X.QTY009 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY02 ELSE 0 END )  END)
                        ,X.QTY010 = (CASE WHEN @p_WQTY02 < 0 THEN X.QTY010 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY02 ELSE 0 END )  END)
                        ,X.QTY011 = (CASE WHEN @p_WQTY02 < 0 THEN X.QTY011 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY02 ELSE 0 END )  END)
                        ,X.QTY012 = (CASE WHEN @p_WQTY02 < 0 THEN X.QTY012 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY02 ELSE 0 END )  END)
                        ,X.QTY013 = (CASE WHEN @p_WQTY02 < 0 THEN X.QTY013 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY02 ELSE 0 END )  END)
                        ,X.QTY014 = (CASE WHEN @p_WQTY02 < 0 THEN X.QTY014 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY02 ELSE 0 END )  END)
                                                                                                                              
                        ,X.QTY015 = (CASE WHEN @p_WQTY03 < 0 THEN X.QTY015 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY03 ELSE 0 END )  END)
                        ,X.QTY016 = (CASE WHEN @p_WQTY03 < 0 THEN X.QTY016 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY03 ELSE 0 END )  END)
                        ,X.QTY017 = (CASE WHEN @p_WQTY03 < 0 THEN X.QTY017 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY03 ELSE 0 END )  END)
                        ,X.QTY018 = (CASE WHEN @p_WQTY03 < 0 THEN X.QTY018 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY03 ELSE 0 END )  END)
                        ,X.QTY019 = (CASE WHEN @p_WQTY03 < 0 THEN X.QTY019 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY03 ELSE 0 END )  END)
                        ,X.QTY020 = (CASE WHEN @p_WQTY03 < 0 THEN X.QTY020 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY03 ELSE 0 END )  END)
                        ,X.QTY021 = (CASE WHEN @p_WQTY03 < 0 THEN X.QTY021 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY03 ELSE 0 END )  END)
                                                                                                                              
                        ,X.QTY022 = (CASE WHEN @p_WQTY04 < 0 THEN X.QTY022 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY04 ELSE 0 END )  END)
                        ,X.QTY023 = (CASE WHEN @p_WQTY04 < 0 THEN X.QTY023 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY04 ELSE 0 END )  END)
                        ,X.QTY024 = (CASE WHEN @p_WQTY04 < 0 THEN X.QTY024 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY04 ELSE 0 END )  END)
                        ,X.QTY025 = (CASE WHEN @p_WQTY04 < 0 THEN X.QTY025 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY04 ELSE 0 END )  END)
                        ,X.QTY026 = (CASE WHEN @p_WQTY04 < 0 THEN X.QTY026 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY04 ELSE 0 END )  END)
                        ,X.QTY027 = (CASE WHEN @p_WQTY04 < 0 THEN X.QTY027 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY04 ELSE 0 END )  END)
                        ,X.QTY028 = (CASE WHEN @p_WQTY04 < 0 THEN X.QTY028 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY04 ELSE 0 END )  END)
                                                                                                                              
                        ,X.QTY029 = (CASE WHEN @p_WQTY05 < 0 THEN X.QTY029 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY05 ELSE 0 END )  END)
                        ,X.QTY030 = (CASE WHEN @p_WQTY05 < 0 THEN X.QTY030 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY05 ELSE 0 END )  END)
                        ,X.QTY031 = (CASE WHEN @p_WQTY05 < 0 THEN X.QTY031 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY05 ELSE 0 END )  END)
                        ,X.QTY032 = (CASE WHEN @p_WQTY05 < 0 THEN X.QTY032 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY05 ELSE 0 END )  END)
                        ,X.QTY033 = (CASE WHEN @p_WQTY05 < 0 THEN X.QTY033 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY05 ELSE 0 END )  END)
                        ,X.QTY034 = (CASE WHEN @p_WQTY05 < 0 THEN X.QTY034 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY05 ELSE 0 END )  END)
                        ,X.QTY035 = (CASE WHEN @p_WQTY05 < 0 THEN X.QTY035 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY05 ELSE 0 END )  END)
                                                                                                                              
                        ,X.QTY036 = (CASE WHEN @p_WQTY06 < 0 THEN X.QTY036 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY06 ELSE 0 END )  END)
                        ,X.QTY037 = (CASE WHEN @p_WQTY06 < 0 THEN X.QTY037 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY06 ELSE 0 END )  END)
                        ,X.QTY038 = (CASE WHEN @p_WQTY06 < 0 THEN X.QTY038 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY06 ELSE 0 END )  END)
                        ,X.QTY039 = (CASE WHEN @p_WQTY06 < 0 THEN X.QTY039 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY06 ELSE 0 END )  END)
                        ,X.QTY040 = (CASE WHEN @p_WQTY06 < 0 THEN X.QTY040 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY06 ELSE 0 END )  END)
                        ,X.QTY041 = (CASE WHEN @p_WQTY06 < 0 THEN X.QTY041 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY06 ELSE 0 END )  END)
                        ,X.QTY042 = (CASE WHEN @p_WQTY06 < 0 THEN X.QTY042 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY06 ELSE 0 END )  END)
                                                                                                                              
                        ,X.QTY043 = (CASE WHEN @p_WQTY07 < 0 THEN X.QTY043 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY07 ELSE 0 END )  END)
                        ,X.QTY044 = (CASE WHEN @p_WQTY07 < 0 THEN X.QTY044 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY07 ELSE 0 END )  END)
                        ,X.QTY045 = (CASE WHEN @p_WQTY07 < 0 THEN X.QTY045 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY07 ELSE 0 END )  END)
                        ,X.QTY046 = (CASE WHEN @p_WQTY07 < 0 THEN X.QTY046 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY07 ELSE 0 END )  END)
                        ,X.QTY047 = (CASE WHEN @p_WQTY07 < 0 THEN X.QTY047 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY07 ELSE 0 END )  END)
                        ,X.QTY048 = (CASE WHEN @p_WQTY07 < 0 THEN X.QTY048 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY07 ELSE 0 END )  END)
                        ,X.QTY049 = (CASE WHEN @p_WQTY07 < 0 THEN X.QTY049 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY07 ELSE 0 END )  END)
                                                                                                                              
                        ,X.QTY050 = (CASE WHEN @p_WQTY08 < 0 THEN X.QTY050 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY08 ELSE 0 END )  END)
                        ,X.QTY051 = (CASE WHEN @p_WQTY08 < 0 THEN X.QTY051 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY08 ELSE 0 END )  END)
                        ,X.QTY052 = (CASE WHEN @p_WQTY08 < 0 THEN X.QTY052 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY08 ELSE 0 END )  END)
                        ,X.QTY053 = (CASE WHEN @p_WQTY08 < 0 THEN X.QTY053 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY08 ELSE 0 END )  END)
                        ,X.QTY054 = (CASE WHEN @p_WQTY08 < 0 THEN X.QTY054 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY08 ELSE 0 END )  END)
                        ,X.QTY055 = (CASE WHEN @p_WQTY08 < 0 THEN X.QTY055 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY08 ELSE 0 END )  END)
                        ,X.QTY056 = (CASE WHEN @p_WQTY08 < 0 THEN X.QTY056 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY08 ELSE 0 END )  END)
                                                                                                                              
                        ,X.QTY057 = (CASE WHEN @p_WQTY09 < 0 THEN X.QTY057 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY09 ELSE 0 END )  END)
                        ,X.QTY058 = (CASE WHEN @p_WQTY09 < 0 THEN X.QTY058 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY09 ELSE 0 END )  END)
                        ,X.QTY059 = (CASE WHEN @p_WQTY09 < 0 THEN X.QTY059 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY09 ELSE 0 END )  END)
                        ,X.QTY060 = (CASE WHEN @p_WQTY09 < 0 THEN X.QTY060 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY09 ELSE 0 END )  END)
                        ,X.QTY061 = (CASE WHEN @p_WQTY09 < 0 THEN X.QTY061 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY09 ELSE 0 END )  END)
                        ,X.QTY062 = (CASE WHEN @p_WQTY09 < 0 THEN X.QTY062 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY09 ELSE 0 END )  END)
                        ,X.QTY063 = (CASE WHEN @p_WQTY09 < 0 THEN X.QTY063 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY09 ELSE 0 END )  END)

                        ,X.QTY064 = (CASE WHEN @p_WQTY10 < 0 THEN X.QTY064 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY10 ELSE 0 END )  END)
                        ,X.QTY065 = (CASE WHEN @p_WQTY10 < 0 THEN X.QTY065 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY10 ELSE 0 END )  END)
                        ,X.QTY066 = (CASE WHEN @p_WQTY10 < 0 THEN X.QTY066 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY10 ELSE 0 END )  END)
                        ,X.QTY067 = (CASE WHEN @p_WQTY10 < 0 THEN X.QTY067 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY10 ELSE 0 END )  END)
                        ,X.QTY068 = (CASE WHEN @p_WQTY10 < 0 THEN X.QTY068 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY10 ELSE 0 END )  END)
                        ,X.QTY069 = (CASE WHEN @p_WQTY10 < 0 THEN X.QTY069 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY10 ELSE 0 END )  END)
                        ,X.QTY070 = (CASE WHEN @p_WQTY10 < 0 THEN X.QTY070 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY10 ELSE 0 END )  END)
                                                                                                                              
                        ,X.QTY071 = (CASE WHEN @p_WQTY11 < 0 THEN X.QTY071 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY11 ELSE 0 END )  END)
                        ,X.QTY072 = (CASE WHEN @p_WQTY11 < 0 THEN X.QTY072 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY11 ELSE 0 END )  END)
                        ,X.QTY073 = (CASE WHEN @p_WQTY11 < 0 THEN X.QTY073 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY11 ELSE 0 END )  END)
                        ,X.QTY074 = (CASE WHEN @p_WQTY11 < 0 THEN X.QTY074 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY11 ELSE 0 END )  END)
                        ,X.QTY075 = (CASE WHEN @p_WQTY11 < 0 THEN X.QTY075 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY11 ELSE 0 END )  END)
                        ,X.QTY076 = (CASE WHEN @p_WQTY11 < 0 THEN X.QTY076 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY11 ELSE 0 END )  END)
                        ,X.QTY077 = (CASE WHEN @p_WQTY11 < 0 THEN X.QTY077 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY11 ELSE 0 END )  END)
                                                                                                                              
                        ,X.QTY078 = (CASE WHEN @p_WQTY12 < 0 THEN X.QTY078 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY12 ELSE 0 END )  END)
                        ,X.QTY079 = (CASE WHEN @p_WQTY12 < 0 THEN X.QTY079 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY12 ELSE 0 END )  END)
                        ,X.QTY080 = (CASE WHEN @p_WQTY12 < 0 THEN X.QTY080 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY12 ELSE 0 END )  END)
                        ,X.QTY081 = (CASE WHEN @p_WQTY12 < 0 THEN X.QTY081 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY12 ELSE 0 END )  END)
                        ,X.QTY082 = (CASE WHEN @p_WQTY12 < 0 THEN X.QTY082 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY12 ELSE 0 END )  END)
                        ,X.QTY083 = (CASE WHEN @p_WQTY12 < 0 THEN X.QTY083 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY12 ELSE 0 END )  END)
                        ,X.QTY084 = (CASE WHEN @p_WQTY12 < 0 THEN X.QTY084 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY12 ELSE 0 END )  END)
                                                                                                                              
                        ,X.QTY085 = (CASE WHEN @p_WQTY13 < 0 THEN X.QTY085 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY13 ELSE 0 END )  END)
                        ,X.QTY086 = (CASE WHEN @p_WQTY13 < 0 THEN X.QTY086 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY13 ELSE 0 END )  END)
                        ,X.QTY087 = (CASE WHEN @p_WQTY13 < 0 THEN X.QTY087 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY13 ELSE 0 END )  END)
                        ,X.QTY088 = (CASE WHEN @p_WQTY13 < 0 THEN X.QTY088 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY13 ELSE 0 END )  END)
                        ,X.QTY089 = (CASE WHEN @p_WQTY13 < 0 THEN X.QTY089 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY13 ELSE 0 END )  END)
                        ,X.QTY090 = (CASE WHEN @p_WQTY13 < 0 THEN X.QTY090 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY13 ELSE 0 END )  END)
                        ,X.QTY091 = (CASE WHEN @p_WQTY13 < 0 THEN X.QTY091 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY13 ELSE 0 END )  END)
                                                                                                                              
                        ,X.QTY092 = (CASE WHEN @p_WQTY14 < 0 THEN X.QTY092 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY14 ELSE 0 END )  END)
                        ,X.QTY093 = (CASE WHEN @p_WQTY14 < 0 THEN X.QTY093 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY14 ELSE 0 END )  END)
                        ,X.QTY094 = (CASE WHEN @p_WQTY14 < 0 THEN X.QTY094 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY14 ELSE 0 END )  END)
                        ,X.QTY095 = (CASE WHEN @p_WQTY14 < 0 THEN X.QTY095 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY14 ELSE 0 END )  END)
                        ,X.QTY096 = (CASE WHEN @p_WQTY14 < 0 THEN X.QTY096 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY14 ELSE 0 END )  END)
                        ,X.QTY097 = (CASE WHEN @p_WQTY14 < 0 THEN X.QTY097 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY14 ELSE 0 END )  END)
                        ,X.QTY098 = (CASE WHEN @p_WQTY14 < 0 THEN X.QTY098 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY14 ELSE 0 END )  END)
                                                                                                                              
                        ,X.QTY099 = (CASE WHEN @p_WQTY15 < 0 THEN X.QTY099 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY15 ELSE 0 END )  END)
                        ,X.QTY100 = (CASE WHEN @p_WQTY15 < 0 THEN X.QTY100 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY15 ELSE 0 END )  END)
                        ,X.QTY101 = (CASE WHEN @p_WQTY15 < 0 THEN X.QTY101 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY15 ELSE 0 END )  END)
                        ,X.QTY102 = (CASE WHEN @p_WQTY15 < 0 THEN X.QTY102 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY15 ELSE 0 END )  END)
                        ,X.QTY103 = (CASE WHEN @p_WQTY15 < 0 THEN X.QTY103 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY15 ELSE 0 END )  END)
                        ,X.QTY104 = (CASE WHEN @p_WQTY15 < 0 THEN X.QTY104 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY15 ELSE 0 END )  END)
                        ,X.QTY105 = (CASE WHEN @p_WQTY15 < 0 THEN X.QTY105 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY15 ELSE 0 END )  END)
                                                                                                                              
                        ,X.QTY106 = (CASE WHEN @p_WQTY16 < 0 THEN X.QTY106 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY16 ELSE 0 END )  END)
                        ,X.QTY107 = (CASE WHEN @p_WQTY16 < 0 THEN X.QTY107 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY16 ELSE 0 END )  END)
                        ,X.QTY108 = (CASE WHEN @p_WQTY16 < 0 THEN X.QTY108 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY16 ELSE 0 END )  END)
                        ,X.QTY109 = (CASE WHEN @p_WQTY16 < 0 THEN X.QTY109 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY16 ELSE 0 END )  END)
                        ,X.QTY110 = (CASE WHEN @p_WQTY16 < 0 THEN X.QTY110 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY16 ELSE 0 END )  END)
                        ,X.QTY111 = (CASE WHEN @p_WQTY16 < 0 THEN X.QTY111 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY16 ELSE 0 END )  END)
                        ,X.QTY112 = (CASE WHEN @p_WQTY16 < 0 THEN X.QTY112 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY16 ELSE 0 END )  END)
                        ------------------------------------------------------------------------------------------------------------------------------------
                        ,X.QTY113 = (CASE WHEN @p_WQTY17 < 0 THEN X.QTY113 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY17 ELSE 0 END )  END)
                        ,X.QTY114 = (CASE WHEN @p_WQTY17 < 0 THEN X.QTY114 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY17 ELSE 0 END )  END)
                        ,X.QTY115 = (CASE WHEN @p_WQTY17 < 0 THEN X.QTY115 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY17 ELSE 0 END )  END)
                        ,X.QTY116 = (CASE WHEN @p_WQTY17 < 0 THEN X.QTY116 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY17 ELSE 0 END )  END)
                        ,X.QTY117 = (CASE WHEN @p_WQTY17 < 0 THEN X.QTY117 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY17 ELSE 0 END )  END)
                        ,X.QTY118 = (CASE WHEN @p_WQTY17 < 0 THEN X.QTY118 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY17 ELSE 0 END )  END)
                        ,X.QTY119 = (CASE WHEN @p_WQTY17 < 0 THEN X.QTY119 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY17 ELSE 0 END )  END)

                        ,X.QTY120 = (CASE WHEN @p_WQTY18 < 0 THEN X.QTY120 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY18 ELSE 0 END )  END)
                        ,X.QTY121 = (CASE WHEN @p_WQTY18 < 0 THEN X.QTY121 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY18 ELSE 0 END )  END)
                        ,X.QTY122 = (CASE WHEN @p_WQTY18 < 0 THEN X.QTY122 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY18 ELSE 0 END )  END)
                        ,X.QTY123 = (CASE WHEN @p_WQTY18 < 0 THEN X.QTY123 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY18 ELSE 0 END )  END)
                        ,X.QTY124 = (CASE WHEN @p_WQTY18 < 0 THEN X.QTY124 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY18 ELSE 0 END )  END)
                        ,X.QTY125 = (CASE WHEN @p_WQTY18 < 0 THEN X.QTY125 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY18 ELSE 0 END )  END)
                        ,X.QTY126 = (CASE WHEN @p_WQTY18 < 0 THEN X.QTY126 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY18 ELSE 0 END )  END)

                        ,X.QTY127 = (CASE WHEN @p_WQTY19 < 0 THEN X.QTY127 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY19 ELSE 0 END )  END)
                        ,X.QTY128 = (CASE WHEN @p_WQTY19 < 0 THEN X.QTY128 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY19 ELSE 0 END )  END)
                        ,X.QTY129 = (CASE WHEN @p_WQTY19 < 0 THEN X.QTY129 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY19 ELSE 0 END )  END)
                        ,X.QTY130 = (CASE WHEN @p_WQTY19 < 0 THEN X.QTY130 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY19 ELSE 0 END )  END)
                        ,X.QTY131 = (CASE WHEN @p_WQTY19 < 0 THEN X.QTY131 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY19 ELSE 0 END )  END)
                        ,X.QTY132 = (CASE WHEN @p_WQTY19 < 0 THEN X.QTY132 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY19 ELSE 0 END )  END)
                        ,X.QTY133 = (CASE WHEN @p_WQTY19 < 0 THEN X.QTY133 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY19 ELSE 0 END )  END)

                        ,X.QTY134 = (CASE WHEN @p_WQTY20 < 0 THEN X.QTY134 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY20 ELSE 0 END )  END)
                        ,X.QTY135 = (CASE WHEN @p_WQTY20 < 0 THEN X.QTY135 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY20 ELSE 0 END )  END)
                        ,X.QTY136 = (CASE WHEN @p_WQTY20 < 0 THEN X.QTY136 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY20 ELSE 0 END )  END)
                        ,X.QTY137 = (CASE WHEN @p_WQTY20 < 0 THEN X.QTY137 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY20 ELSE 0 END )  END)
                        ,X.QTY138 = (CASE WHEN @p_WQTY20 < 0 THEN X.QTY138 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY20 ELSE 0 END )  END)
                        ,X.QTY139 = (CASE WHEN @p_WQTY20 < 0 THEN X.QTY139 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY20 ELSE 0 END )  END)
                        ,X.QTY140 = (CASE WHEN @p_WQTY20 < 0 THEN X.QTY140 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY20 ELSE 0 END )  END)

                        ,X.QTY141 = (CASE WHEN @p_WQTY21 < 0 THEN X.QTY141 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY21 ELSE 0 END )  END)
                        ,X.QTY142 = (CASE WHEN @p_WQTY21 < 0 THEN X.QTY142 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY21 ELSE 0 END )  END)
                        ,X.QTY143 = (CASE WHEN @p_WQTY21 < 0 THEN X.QTY143 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY21 ELSE 0 END )  END)
                        ,X.QTY144 = (CASE WHEN @p_WQTY21 < 0 THEN X.QTY144 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY21 ELSE 0 END )  END)
                        ,X.QTY145 = (CASE WHEN @p_WQTY21 < 0 THEN X.QTY145 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY21 ELSE 0 END )  END)
                        ,X.QTY146 = (CASE WHEN @p_WQTY21 < 0 THEN X.QTY146 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY21 ELSE 0 END )  END)
                        ,X.QTY147 = (CASE WHEN @p_WQTY21 < 0 THEN X.QTY147 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY21 ELSE 0 END )  END)

                        ,X.QTY148 = (CASE WHEN @p_WQTY22 < 0 THEN X.QTY148 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY22 ELSE 0 END )  END)
                        ,X.QTY149 = (CASE WHEN @p_WQTY22 < 0 THEN X.QTY149 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY22 ELSE 0 END )  END)
                        ,X.QTY150 = (CASE WHEN @p_WQTY22 < 0 THEN X.QTY150 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY22 ELSE 0 END )  END)
                        ,X.QTY151 = (CASE WHEN @p_WQTY22 < 0 THEN X.QTY151 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY22 ELSE 0 END )  END)
                        ,X.QTY152 = (CASE WHEN @p_WQTY22 < 0 THEN X.QTY152 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY22 ELSE 0 END )  END)
                        ,X.QTY153 = (CASE WHEN @p_WQTY22 < 0 THEN X.QTY153 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY22 ELSE 0 END )  END)
                        ,X.QTY154 = (CASE WHEN @p_WQTY22 < 0 THEN X.QTY154 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY22 ELSE 0 END )  END)

                        ,X.QTY155 = (CASE WHEN @p_WQTY23 < 0 THEN X.QTY155 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY23 ELSE 0 END )  END)
                        ,X.QTY156 = (CASE WHEN @p_WQTY23 < 0 THEN X.QTY156 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY23 ELSE 0 END )  END)
                        ,X.QTY157 = (CASE WHEN @p_WQTY23 < 0 THEN X.QTY157 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY23 ELSE 0 END )  END)
                        ,X.QTY158 = (CASE WHEN @p_WQTY23 < 0 THEN X.QTY158 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY23 ELSE 0 END )  END)
                        ,X.QTY159 = (CASE WHEN @p_WQTY23 < 0 THEN X.QTY159 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY23 ELSE 0 END )  END)
                        ,X.QTY160 = (CASE WHEN @p_WQTY23 < 0 THEN X.QTY160 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY23 ELSE 0 END )  END)
                        ,X.QTY161 = (CASE WHEN @p_WQTY23 < 0 THEN X.QTY161 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY23 ELSE 0 END )  END)

                        ,X.QTY162 = (CASE WHEN @p_WQTY24 < 0 THEN X.QTY162 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY24 ELSE 0 END )  END)
                        ,X.QTY163 = (CASE WHEN @p_WQTY24 < 0 THEN X.QTY163 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY24 ELSE 0 END )  END)
                        ,X.QTY164 = (CASE WHEN @p_WQTY24 < 0 THEN X.QTY164 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY24 ELSE 0 END )  END)
                        ,X.QTY165 = (CASE WHEN @p_WQTY24 < 0 THEN X.QTY165 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY24 ELSE 0 END )  END)
                        ,X.QTY166 = (CASE WHEN @p_WQTY24 < 0 THEN X.QTY166 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY24 ELSE 0 END )  END)
                        ,X.QTY167 = (CASE WHEN @p_WQTY24 < 0 THEN X.QTY167 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY24 ELSE 0 END )  END)
                        ,X.QTY168 = (CASE WHEN @p_WQTY24 < 0 THEN X.QTY168 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY24 ELSE 0 END )  END)

                        ,X.QTY169 = (CASE WHEN @p_WQTY25 < 0 THEN X.QTY169 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY25 ELSE 0 END )  END)
                        ,X.QTY170 = (CASE WHEN @p_WQTY25 < 0 THEN X.QTY170 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY25 ELSE 0 END )  END)
                        ,X.QTY171 = (CASE WHEN @p_WQTY25 < 0 THEN X.QTY171 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY25 ELSE 0 END )  END)
                        ,X.QTY172 = (CASE WHEN @p_WQTY25 < 0 THEN X.QTY172 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY25 ELSE 0 END )  END)
                        ,X.QTY173 = (CASE WHEN @p_WQTY25 < 0 THEN X.QTY173 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY25 ELSE 0 END )  END)
                        ,X.QTY174 = (CASE WHEN @p_WQTY25 < 0 THEN X.QTY174 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY25 ELSE 0 END )  END)
                        ,X.QTY175 = (CASE WHEN @p_WQTY25 < 0 THEN X.QTY175 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY25 ELSE 0 END )  END)

                        ,X.QTY176 = (CASE WHEN @p_WQTY26 < 0 THEN X.QTY176 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY26 ELSE 0 END )  END)
                        ,X.QTY177 = (CASE WHEN @p_WQTY26 < 0 THEN X.QTY177 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY26 ELSE 0 END )  END)
                        ,X.QTY178 = (CASE WHEN @p_WQTY26 < 0 THEN X.QTY178 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY26 ELSE 0 END )  END)
                        ,X.QTY179 = (CASE WHEN @p_WQTY26 < 0 THEN X.QTY179 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY26 ELSE 0 END )  END)
                        ,X.QTY180 = (CASE WHEN @p_WQTY26 < 0 THEN X.QTY180 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY26 ELSE 0 END )  END)
                        ,X.QTY181 = (CASE WHEN @p_WQTY26 < 0 THEN X.QTY181 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY26 ELSE 0 END )  END)
                        ,X.QTY182 = (CASE WHEN @p_WQTY26 < 0 THEN X.QTY182 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY26 ELSE 0 END )  END)

                        ,X.QTY183 = (CASE WHEN @p_WQTY27 < 0 THEN X.QTY183 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY27 ELSE 0 END )  END)
                        ,X.QTY184 = (CASE WHEN @p_WQTY27 < 0 THEN X.QTY184 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY27 ELSE 0 END )  END)
                        ,X.QTY185 = (CASE WHEN @p_WQTY27 < 0 THEN X.QTY185 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY27 ELSE 0 END )  END)
                        ,X.QTY186 = (CASE WHEN @p_WQTY27 < 0 THEN X.QTY186 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY27 ELSE 0 END )  END)
                        ,X.QTY187 = (CASE WHEN @p_WQTY27 < 0 THEN X.QTY187 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY27 ELSE 0 END )  END)
                        ,X.QTY188 = (CASE WHEN @p_WQTY27 < 0 THEN X.QTY188 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY27 ELSE 0 END )  END)
                        ,X.QTY189 = (CASE WHEN @p_WQTY27 < 0 THEN X.QTY189 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY27 ELSE 0 END )  END)

                        ,X.QTY190 = (CASE WHEN @p_WQTY28 < 0 THEN X.QTY190 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY28 ELSE 0 END )  END)
                        ,X.QTY191 = (CASE WHEN @p_WQTY28 < 0 THEN X.QTY191 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY28 ELSE 0 END )  END)
                        ,X.QTY192 = (CASE WHEN @p_WQTY28 < 0 THEN X.QTY192 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY28 ELSE 0 END )  END)
                        ,X.QTY193 = (CASE WHEN @p_WQTY28 < 0 THEN X.QTY193 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY28 ELSE 0 END )  END)
                        ,X.QTY194 = (CASE WHEN @p_WQTY28 < 0 THEN X.QTY194 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY28 ELSE 0 END )  END)
                        ,X.QTY195 = (CASE WHEN @p_WQTY28 < 0 THEN X.QTY195 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY28 ELSE 0 END )  END)
                        ,X.QTY196 = (CASE WHEN @p_WQTY28 < 0 THEN X.QTY196 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY28 ELSE 0 END )  END)

                        ,X.QTY197 = (CASE WHEN @p_WQTY29 < 0 THEN X.QTY197 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY29 ELSE 0 END )  END)
                        ,X.QTY198 = (CASE WHEN @p_WQTY29 < 0 THEN X.QTY198 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY29 ELSE 0 END )  END)
                        ,X.QTY199 = (CASE WHEN @p_WQTY29 < 0 THEN X.QTY199 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY29 ELSE 0 END )  END)
                        ,X.QTY200 = (CASE WHEN @p_WQTY29 < 0 THEN X.QTY200 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY29 ELSE 0 END )  END)
                        ,X.QTY201 = (CASE WHEN @p_WQTY29 < 0 THEN X.QTY201 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY29 ELSE 0 END )  END)
                        ,X.QTY202 = (CASE WHEN @p_WQTY29 < 0 THEN X.QTY202 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY29 ELSE 0 END )  END)
                        ,X.QTY203 = (CASE WHEN @p_WQTY29 < 0 THEN X.QTY203 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY29 ELSE 0 END )  END)

                        ,X.QTY204 = (CASE WHEN @p_WQTY30 < 0 THEN X.QTY204 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY30 ELSE 0 END )  END)
                        ,X.QTY205 = (CASE WHEN @p_WQTY30 < 0 THEN X.QTY205 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY30 ELSE 0 END )  END)
                        ,X.QTY206 = (CASE WHEN @p_WQTY30 < 0 THEN X.QTY206 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY30 ELSE 0 END )  END)
                        ,X.QTY207 = (CASE WHEN @p_WQTY30 < 0 THEN X.QTY207 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY30 ELSE 0 END )  END)
                        ,X.QTY208 = (CASE WHEN @p_WQTY30 < 0 THEN X.QTY208 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY30 ELSE 0 END )  END)
                        ,X.QTY209 = (CASE WHEN @p_WQTY30 < 0 THEN X.QTY209 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY30 ELSE 0 END )  END)
                        ,X.QTY210 = (CASE WHEN @p_WQTY30 < 0 THEN X.QTY210 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY30 ELSE 0 END )  END)

                        ,X.QTY211 = (CASE WHEN @p_WQTY31 < 0 THEN X.QTY211 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY31 ELSE 0 END )  END)
                        ,X.QTY212 = (CASE WHEN @p_WQTY31 < 0 THEN X.QTY212 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY31 ELSE 0 END )  END)
                        ,X.QTY213 = (CASE WHEN @p_WQTY31 < 0 THEN X.QTY213 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY31 ELSE 0 END )  END)
                        ,X.QTY214 = (CASE WHEN @p_WQTY31 < 0 THEN X.QTY214 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY31 ELSE 0 END )  END)
                        ,X.QTY215 = (CASE WHEN @p_WQTY31 < 0 THEN X.QTY215 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY31 ELSE 0 END )  END)
                        ,X.QTY216 = (CASE WHEN @p_WQTY31 < 0 THEN X.QTY216 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY31 ELSE 0 END )  END)
                        ,X.QTY217 = (CASE WHEN @p_WQTY31 < 0 THEN X.QTY217 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY31 ELSE 0 END )  END)

                        ,X.QTY218 = (CASE WHEN @p_WQTY32 < 0 THEN X.QTY218 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY32 ELSE 0 END )  END)
                        ,X.QTY219 = (CASE WHEN @p_WQTY32 < 0 THEN X.QTY219 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY32 ELSE 0 END )  END)
                        ,X.QTY220 = (CASE WHEN @p_WQTY32 < 0 THEN X.QTY220 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY32 ELSE 0 END )  END)
                        ,X.QTY221 = (CASE WHEN @p_WQTY32 < 0 THEN X.QTY221 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY32 ELSE 0 END )  END)
                        ,X.QTY222 = (CASE WHEN @p_WQTY32 < 0 THEN X.QTY222 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY32 ELSE 0 END )  END)
                        ,X.QTY223 = (CASE WHEN @p_WQTY32 < 0 THEN X.QTY223 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY32 ELSE 0 END )  END)
                        ,X.QTY224 = (CASE WHEN @p_WQTY32 < 0 THEN X.QTY224 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY32 ELSE 0 END )  END)

                        ,X.QTY225 = (CASE WHEN @p_WQTY33 < 0 THEN X.QTY225 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY33 ELSE 0 END )  END)
                        ,X.QTY226 = (CASE WHEN @p_WQTY33 < 0 THEN X.QTY226 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY33 ELSE 0 END )  END)
                        ,X.QTY227 = (CASE WHEN @p_WQTY33 < 0 THEN X.QTY227 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY33 ELSE 0 END )  END)
                        ,X.QTY228 = (CASE WHEN @p_WQTY33 < 0 THEN X.QTY228 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY33 ELSE 0 END )  END)
                        ,X.QTY229 = (CASE WHEN @p_WQTY33 < 0 THEN X.QTY229 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY33 ELSE 0 END )  END)
                        ,X.QTY230 = (CASE WHEN @p_WQTY33 < 0 THEN X.QTY230 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY33 ELSE 0 END )  END)
                        ,X.QTY231 = (CASE WHEN @p_WQTY33 < 0 THEN X.QTY231 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY33 ELSE 0 END )  END)

                        ,X.QTY232 = (CASE WHEN @p_WQTY34 < 0 THEN X.QTY232 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY34 ELSE 0 END )  END)
                        ,X.QTY233 = (CASE WHEN @p_WQTY34 < 0 THEN X.QTY233 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY34 ELSE 0 END )  END)
                        ,X.QTY234 = (CASE WHEN @p_WQTY34 < 0 THEN X.QTY234 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY34 ELSE 0 END )  END)
                        ,X.QTY235 = (CASE WHEN @p_WQTY34 < 0 THEN X.QTY235 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY34 ELSE 0 END )  END)
                        ,X.QTY236 = (CASE WHEN @p_WQTY34 < 0 THEN X.QTY236 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY34 ELSE 0 END )  END)
                        ,X.QTY237 = (CASE WHEN @p_WQTY34 < 0 THEN X.QTY237 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY34 ELSE 0 END )  END)
                        ,X.QTY238 = (CASE WHEN @p_WQTY34 < 0 THEN X.QTY238 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY34 ELSE 0 END )  END)

                        ,X.QTY239 = (CASE WHEN @p_WQTY35 < 0 THEN X.QTY239 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY35 ELSE 0 END )  END)
                        ,X.QTY240 = (CASE WHEN @p_WQTY35 < 0 THEN X.QTY240 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY35 ELSE 0 END )  END)
                        ,X.QTY241 = (CASE WHEN @p_WQTY35 < 0 THEN X.QTY241 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY35 ELSE 0 END )  END)
                        ,X.QTY242 = (CASE WHEN @p_WQTY35 < 0 THEN X.QTY242 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY35 ELSE 0 END )  END)
                        ,X.QTY243 = (CASE WHEN @p_WQTY35 < 0 THEN X.QTY243 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY35 ELSE 0 END )  END)
                        ,X.QTY244 = (CASE WHEN @p_WQTY35 < 0 THEN X.QTY244 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY35 ELSE 0 END )  END)
                        ,X.QTY245 = (CASE WHEN @p_WQTY35 < 0 THEN X.QTY245 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY35 ELSE 0 END )  END)

                        ,X.QTY246 = (CASE WHEN @p_WQTY36 < 0 THEN X.QTY246 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY36 ELSE 0 END )  END)
                        ,X.QTY247 = (CASE WHEN @p_WQTY36 < 0 THEN X.QTY247 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY36 ELSE 0 END )  END)
                        ,X.QTY248 = (CASE WHEN @p_WQTY36 < 0 THEN X.QTY248 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY36 ELSE 0 END )  END)
                        ,X.QTY249 = (CASE WHEN @p_WQTY36 < 0 THEN X.QTY249 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY36 ELSE 0 END )  END)
                        ,X.QTY250 = (CASE WHEN @p_WQTY36 < 0 THEN X.QTY250 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY36 ELSE 0 END )  END)
                        ,X.QTY251 = (CASE WHEN @p_WQTY36 < 0 THEN X.QTY251 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY36 ELSE 0 END )  END)
                        ,X.QTY252 = (CASE WHEN @p_WQTY36 < 0 THEN X.QTY252 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY36 ELSE 0 END )  END)

                        ,X.QTY253 = (CASE WHEN @p_WQTY37 < 0 THEN X.QTY253 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY37 ELSE 0 END )  END)
                        ,X.QTY254 = (CASE WHEN @p_WQTY37 < 0 THEN X.QTY254 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY37 ELSE 0 END )  END)
                        ,X.QTY255 = (CASE WHEN @p_WQTY37 < 0 THEN X.QTY255 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY37 ELSE 0 END )  END)
                        ,X.QTY256 = (CASE WHEN @p_WQTY37 < 0 THEN X.QTY256 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY37 ELSE 0 END )  END)
                        ,X.QTY257 = (CASE WHEN @p_WQTY37 < 0 THEN X.QTY257 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY37 ELSE 0 END )  END)
                        ,X.QTY258 = (CASE WHEN @p_WQTY37 < 0 THEN X.QTY258 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY37 ELSE 0 END )  END)
                        ,X.QTY259 = (CASE WHEN @p_WQTY37 < 0 THEN X.QTY259 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY37 ELSE 0 END )  END)

                        ,X.QTY260 = (CASE WHEN @p_WQTY38 < 0 THEN X.QTY260 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY38 ELSE 0 END )  END)
                        ,X.QTY261 = (CASE WHEN @p_WQTY38 < 0 THEN X.QTY261 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY38 ELSE 0 END )  END)
                        ,X.QTY262 = (CASE WHEN @p_WQTY38 < 0 THEN X.QTY262 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY38 ELSE 0 END )  END)
                        ,X.QTY263 = (CASE WHEN @p_WQTY38 < 0 THEN X.QTY263 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY38 ELSE 0 END )  END)
                        ,X.QTY264 = (CASE WHEN @p_WQTY38 < 0 THEN X.QTY264 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY38 ELSE 0 END )  END)
                        ,X.QTY265 = (CASE WHEN @p_WQTY38 < 0 THEN X.QTY265 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY38 ELSE 0 END )  END)
                        ,X.QTY266 = (CASE WHEN @p_WQTY38 < 0 THEN X.QTY266 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY38 ELSE 0 END )  END)

                        ,X.QTY267 = (CASE WHEN @p_WQTY39 < 0 THEN X.QTY267 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY39 ELSE 0 END )  END)
                        ,X.QTY268 = (CASE WHEN @p_WQTY39 < 0 THEN X.QTY268 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY39 ELSE 0 END )  END)
                        ,X.QTY269 = (CASE WHEN @p_WQTY39 < 0 THEN X.QTY269 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY39 ELSE 0 END )  END)
                        ,X.QTY270 = (CASE WHEN @p_WQTY39 < 0 THEN X.QTY270 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY39 ELSE 0 END )  END)
                        ,X.QTY271 = (CASE WHEN @p_WQTY39 < 0 THEN X.QTY271 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY39 ELSE 0 END )  END)
                        ,X.QTY272 = (CASE WHEN @p_WQTY39 < 0 THEN X.QTY272 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY39 ELSE 0 END )  END)
                        ,X.QTY273 = (CASE WHEN @p_WQTY39 < 0 THEN X.QTY273 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY39 ELSE 0 END )  END)

                        ,X.QTY274 = (CASE WHEN @p_WQTY40 < 0 THEN X.QTY274 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY40 ELSE 0 END )  END)
                        ,X.QTY275 = (CASE WHEN @p_WQTY40 < 0 THEN X.QTY275 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY40 ELSE 0 END )  END)
                        ,X.QTY276 = (CASE WHEN @p_WQTY40 < 0 THEN X.QTY276 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY40 ELSE 0 END )  END)
                        ,X.QTY277 = (CASE WHEN @p_WQTY40 < 0 THEN X.QTY277 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY40 ELSE 0 END )  END)
                        ,X.QTY278 = (CASE WHEN @p_WQTY40 < 0 THEN X.QTY278 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY40 ELSE 0 END )  END)
                        ,X.QTY279 = (CASE WHEN @p_WQTY40 < 0 THEN X.QTY279 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY40 ELSE 0 END )  END)
                        ,X.QTY280 = (CASE WHEN @p_WQTY40 < 0 THEN X.QTY280 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY40 ELSE 0 END )  END)

                        ,X.QTY281 = (CASE WHEN @p_WQTY41 < 0 THEN X.QTY281 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY41 ELSE 0 END )  END)
                        ,X.QTY282 = (CASE WHEN @p_WQTY41 < 0 THEN X.QTY282 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY41 ELSE 0 END )  END)
                        ,X.QTY283 = (CASE WHEN @p_WQTY41 < 0 THEN X.QTY283 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY41 ELSE 0 END )  END)
                        ,X.QTY284 = (CASE WHEN @p_WQTY41 < 0 THEN X.QTY284 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY41 ELSE 0 END )  END)
                        ,X.QTY285 = (CASE WHEN @p_WQTY41 < 0 THEN X.QTY285 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY41 ELSE 0 END )  END)
                        ,X.QTY286 = (CASE WHEN @p_WQTY41 < 0 THEN X.QTY286 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY41 ELSE 0 END )  END)
                        ,X.QTY287 = (CASE WHEN @p_WQTY41 < 0 THEN X.QTY287 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY41 ELSE 0 END )  END)

                        ,X.QTY288 = (CASE WHEN @p_WQTY42 < 0 THEN X.QTY288 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY42 ELSE 0 END )  END)
                        ,X.QTY289 = (CASE WHEN @p_WQTY42 < 0 THEN X.QTY289 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY42 ELSE 0 END )  END)
                        ,X.QTY290 = (CASE WHEN @p_WQTY42 < 0 THEN X.QTY290 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY42 ELSE 0 END )  END)
                        ,X.QTY291 = (CASE WHEN @p_WQTY42 < 0 THEN X.QTY291 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY42 ELSE 0 END )  END)
                        ,X.QTY292 = (CASE WHEN @p_WQTY42 < 0 THEN X.QTY292 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY42 ELSE 0 END )  END)
                        ,X.QTY293 = (CASE WHEN @p_WQTY42 < 0 THEN X.QTY293 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY42 ELSE 0 END )  END)
                        ,X.QTY294 = (CASE WHEN @p_WQTY42 < 0 THEN X.QTY294 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY42 ELSE 0 END )  END)

                        ,X.QTY295 = (CASE WHEN @p_WQTY43 < 0 THEN X.QTY295 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY43 ELSE 0 END )  END)
                        ,X.QTY296 = (CASE WHEN @p_WQTY43 < 0 THEN X.QTY296 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY43 ELSE 0 END )  END)
                        ,X.QTY297 = (CASE WHEN @p_WQTY43 < 0 THEN X.QTY297 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY43 ELSE 0 END )  END)
                        ,X.QTY298 = (CASE WHEN @p_WQTY43 < 0 THEN X.QTY298 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY43 ELSE 0 END )  END)
                        ,X.QTY299 = (CASE WHEN @p_WQTY43 < 0 THEN X.QTY299 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY43 ELSE 0 END )  END)
                        ,X.QTY300 = (CASE WHEN @p_WQTY43 < 0 THEN X.QTY300 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY43 ELSE 0 END )  END)
                        ,X.QTY301 = (CASE WHEN @p_WQTY43 < 0 THEN X.QTY301 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY43 ELSE 0 END )  END)

                        ,X.QTY302 = (CASE WHEN @p_WQTY44 < 0 THEN X.QTY302 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY44 ELSE 0 END )  END)
                        ,X.QTY303 = (CASE WHEN @p_WQTY44 < 0 THEN X.QTY303 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY44 ELSE 0 END )  END)
                        ,X.QTY304 = (CASE WHEN @p_WQTY44 < 0 THEN X.QTY304 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY44 ELSE 0 END )  END)
                        ,X.QTY305 = (CASE WHEN @p_WQTY44 < 0 THEN X.QTY305 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY44 ELSE 0 END )  END)
                        ,X.QTY306 = (CASE WHEN @p_WQTY44 < 0 THEN X.QTY306 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY44 ELSE 0 END )  END)
                        ,X.QTY307 = (CASE WHEN @p_WQTY44 < 0 THEN X.QTY307 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY44 ELSE 0 END )  END)
                        ,X.QTY308 = (CASE WHEN @p_WQTY44 < 0 THEN X.QTY308 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY44 ELSE 0 END )  END)

                        ,X.QTY309 = (CASE WHEN @p_WQTY45 < 0 THEN X.QTY309 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY45 ELSE 0 END )  END)
                        ,X.QTY310 = (CASE WHEN @p_WQTY45 < 0 THEN X.QTY310 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY45 ELSE 0 END )  END)
                        ,X.QTY311 = (CASE WHEN @p_WQTY45 < 0 THEN X.QTY311 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY45 ELSE 0 END )  END)
                        ,X.QTY312 = (CASE WHEN @p_WQTY45 < 0 THEN X.QTY312 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY45 ELSE 0 END )  END)
                        ,X.QTY313 = (CASE WHEN @p_WQTY45 < 0 THEN X.QTY313 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY45 ELSE 0 END )  END)
                        ,X.QTY314 = (CASE WHEN @p_WQTY45 < 0 THEN X.QTY314 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY45 ELSE 0 END )  END)
                        ,X.QTY315 = (CASE WHEN @p_WQTY45 < 0 THEN X.QTY315 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY45 ELSE 0 END )  END)

                        ,X.QTY316 = (CASE WHEN @p_WQTY46 < 0 THEN X.QTY316 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY46 ELSE 0 END )  END)
                        ,X.QTY317 = (CASE WHEN @p_WQTY46 < 0 THEN X.QTY317 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY46 ELSE 0 END )  END)
                        ,X.QTY318 = (CASE WHEN @p_WQTY46 < 0 THEN X.QTY318 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY46 ELSE 0 END )  END)
                        ,X.QTY319 = (CASE WHEN @p_WQTY46 < 0 THEN X.QTY319 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY46 ELSE 0 END )  END)
                        ,X.QTY320 = (CASE WHEN @p_WQTY46 < 0 THEN X.QTY320 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY46 ELSE 0 END )  END)
                        ,X.QTY321 = (CASE WHEN @p_WQTY46 < 0 THEN X.QTY321 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY46 ELSE 0 END )  END)
                        ,X.QTY322 = (CASE WHEN @p_WQTY46 < 0 THEN X.QTY322 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY46 ELSE 0 END )  END)

                        ,X.QTY323 = (CASE WHEN @p_WQTY47 < 0 THEN X.QTY323 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY47 ELSE 0 END )  END)
                        ,X.QTY324 = (CASE WHEN @p_WQTY47 < 0 THEN X.QTY324 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY47 ELSE 0 END )  END)
                        ,X.QTY325 = (CASE WHEN @p_WQTY47 < 0 THEN X.QTY325 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY47 ELSE 0 END )  END)
                        ,X.QTY326 = (CASE WHEN @p_WQTY47 < 0 THEN X.QTY326 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY47 ELSE 0 END )  END)
                        ,X.QTY327 = (CASE WHEN @p_WQTY47 < 0 THEN X.QTY327 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY47 ELSE 0 END )  END)
                        ,X.QTY328 = (CASE WHEN @p_WQTY47 < 0 THEN X.QTY328 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY47 ELSE 0 END )  END)
                        ,X.QTY329 = (CASE WHEN @p_WQTY47 < 0 THEN X.QTY329 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY47 ELSE 0 END )  END)

                        ,X.QTY330 = (CASE WHEN @p_WQTY48 < 0 THEN X.QTY330 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY48 ELSE 0 END )  END)
                        ,X.QTY331 = (CASE WHEN @p_WQTY48 < 0 THEN X.QTY331 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY48 ELSE 0 END )  END)
                        ,X.QTY332 = (CASE WHEN @p_WQTY48 < 0 THEN X.QTY332 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY48 ELSE 0 END )  END)
                        ,X.QTY333 = (CASE WHEN @p_WQTY48 < 0 THEN X.QTY333 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY48 ELSE 0 END )  END)
                        ,X.QTY334 = (CASE WHEN @p_WQTY48 < 0 THEN X.QTY334 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY48 ELSE 0 END )  END)
                        ,X.QTY335 = (CASE WHEN @p_WQTY48 < 0 THEN X.QTY335 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY48 ELSE 0 END )  END)
                        ,X.QTY336 = (CASE WHEN @p_WQTY48 < 0 THEN X.QTY336 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY48 ELSE 0 END )  END)

                        ,X.QTY337 = (CASE WHEN @p_WQTY49 < 0 THEN X.QTY337 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY49 ELSE 0 END )  END)
                        ,X.QTY338 = (CASE WHEN @p_WQTY49 < 0 THEN X.QTY338 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY49 ELSE 0 END )  END)
                        ,X.QTY339 = (CASE WHEN @p_WQTY49 < 0 THEN X.QTY339 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY49 ELSE 0 END )  END)
                        ,X.QTY340 = (CASE WHEN @p_WQTY49 < 0 THEN X.QTY340 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY49 ELSE 0 END )  END)
                        ,X.QTY341 = (CASE WHEN @p_WQTY49 < 0 THEN X.QTY341 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY49 ELSE 0 END )  END)
                        ,X.QTY342 = (CASE WHEN @p_WQTY49 < 0 THEN X.QTY342 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY49 ELSE 0 END )  END)
                        ,X.QTY343 = (CASE WHEN @p_WQTY49 < 0 THEN X.QTY343 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY49 ELSE 0 END )  END)

                        ,X.QTY344 = (CASE WHEN @p_WQTY50 < 0 THEN X.QTY344 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY50 ELSE 0 END )  END)
                        ,X.QTY345 = (CASE WHEN @p_WQTY50 < 0 THEN X.QTY345 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY50 ELSE 0 END )  END)
                        ,X.QTY346 = (CASE WHEN @p_WQTY50 < 0 THEN X.QTY346 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY50 ELSE 0 END )  END)
                        ,X.QTY347 = (CASE WHEN @p_WQTY50 < 0 THEN X.QTY347 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY50 ELSE 0 END )  END)
                        ,X.QTY348 = (CASE WHEN @p_WQTY50 < 0 THEN X.QTY348 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY50 ELSE 0 END )  END)
                        ,X.QTY349 = (CASE WHEN @p_WQTY50 < 0 THEN X.QTY349 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY50 ELSE 0 END )  END)
                        ,X.QTY350 = (CASE WHEN @p_WQTY50 < 0 THEN X.QTY350 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY50 ELSE 0 END )  END)

                        ,X.QTY351 = (CASE WHEN @p_WQTY51 < 0 THEN X.QTY351 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY51 ELSE 0 END )  END)
                        ,X.QTY352 = (CASE WHEN @p_WQTY51 < 0 THEN X.QTY352 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY51 ELSE 0 END )  END)
                        ,X.QTY353 = (CASE WHEN @p_WQTY51 < 0 THEN X.QTY353 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY51 ELSE 0 END )  END)
                        ,X.QTY354 = (CASE WHEN @p_WQTY51 < 0 THEN X.QTY354 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY51 ELSE 0 END )  END)
                        ,X.QTY355 = (CASE WHEN @p_WQTY51 < 0 THEN X.QTY355 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY51 ELSE 0 END )  END)
                        ,X.QTY356 = (CASE WHEN @p_WQTY51 < 0 THEN X.QTY356 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY51 ELSE 0 END )  END)
                        ,X.QTY357 = (CASE WHEN @p_WQTY51 < 0 THEN X.QTY357 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY51 ELSE 0 END )  END)

                        ,X.QTY358 = (CASE WHEN @p_WQTY52 < 0 THEN X.QTY358 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 2  THEN @p_WQTY52 ELSE 0 END )  END)
                        ,X.QTY359 = (CASE WHEN @p_WQTY52 < 0 THEN X.QTY359 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 3  THEN @p_WQTY52 ELSE 0 END )  END)
                        ,X.QTY360 = (CASE WHEN @p_WQTY52 < 0 THEN X.QTY360 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 4  THEN @p_WQTY52 ELSE 0 END )  END)
                        ,X.QTY361 = (CASE WHEN @p_WQTY52 < 0 THEN X.QTY361 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 5  THEN @p_WQTY52 ELSE 0 END )  END)
                        ,X.QTY362 = (CASE WHEN @p_WQTY52 < 0 THEN X.QTY362 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 6  THEN @p_WQTY52 ELSE 0 END )  END)
                        ,X.QTY363 = (CASE WHEN @p_WQTY52 < 0 THEN X.QTY363 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 7  THEN @p_WQTY52 ELSE 0 END )  END)
                        ,X.QTY364 = (CASE WHEN @p_WQTY52 < 0 THEN X.QTY364 ELSE (CASE WHEN @x_DAYOFWEEK_NO = 1  THEN @p_WQTY52 ELSE 0 END )  END)
                   FROM #DAY_SCP_XLS_PSI_GLOBAL X


                   UPDATE X
                      SET  WQTY01   = Y.QTY001  + Y.QTY002 + Y.QTY003  + Y.QTY004  + Y.QTY005  + Y.QTY006  + Y.QTY007
                          ,WQTY02   = Y.QTY008  + Y.QTY009 + Y.QTY010  + Y.QTY011  + Y.QTY012  + Y.QTY013  + Y.QTY014
                          ,WQTY03   = Y.QTY015  + Y.QTY016 + Y.QTY017  + Y.QTY018  + Y.QTY019  + Y.QTY020  + Y.QTY021
                          ,WQTY04   = Y.QTY022  + Y.QTY023 + Y.QTY024  + Y.QTY025  + Y.QTY026  + Y.QTY027  + Y.QTY028
                          ,WQTY05   = Y.QTY029  + Y.QTY030 + Y.QTY031  + Y.QTY032  + Y.QTY033  + Y.QTY034  + Y.QTY035
                          ,WQTY06   = Y.QTY036  + Y.QTY037 + Y.QTY038  + Y.QTY039  + Y.QTY040  + Y.QTY041  + Y.QTY042
                          ,WQTY07   = Y.QTY043  + Y.QTY044 + Y.QTY045  + Y.QTY046  + Y.QTY047  + Y.QTY048  + Y.QTY049
                          ,WQTY08   = Y.QTY050  + Y.QTY051 + Y.QTY052  + Y.QTY053  + Y.QTY054  + Y.QTY055  + Y.QTY056
                          ,WQTY09   = Y.QTY057  + Y.QTY058 + Y.QTY059  + Y.QTY060  + Y.QTY061  + Y.QTY062  + Y.QTY063
                          ,WQTY10   = Y.QTY064  + Y.QTY065 + Y.QTY066  + Y.QTY067  + Y.QTY068  + Y.QTY069  + Y.QTY070
                          ,WQTY11   = Y.QTY071  + Y.QTY072 + Y.QTY073  + Y.QTY074  + Y.QTY075  + Y.QTY076  + Y.QTY007
                          ,WQTY12   = Y.QTY078  + Y.QTY079 + Y.QTY080  + Y.QTY081  + Y.QTY082  + Y.QTY083  + Y.QTY084
                          ,WQTY13   = Y.QTY085  + Y.QTY086 + Y.QTY087  + Y.QTY088  + Y.QTY089  + Y.QTY090  + Y.QTY091
                          ,WQTY14   = Y.QTY092  + Y.QTY093 + Y.QTY094  + Y.QTY095  + Y.QTY096  + Y.QTY097  + Y.QTY098
                          ,WQTY15   = Y.QTY099  + Y.QTY100 + Y.QTY101  + Y.QTY102  + Y.QTY103  + Y.QTY104  + Y.QTY105
                          ,WQTY16   = Y.QTY106  + Y.QTY107 + Y.QTY108  + Y.QTY109  + Y.QTY110  + Y.QTY111  + Y.QTY112

                          ,WQTY17   = Y.QTY113  + Y.QTY114 + Y.QTY115  + Y.QTY116  + Y.QTY117  + Y.QTY118  + Y.QTY119
                          ,WQTY18   = Y.QTY120  + Y.QTY121 + Y.QTY122  + Y.QTY123  + Y.QTY124  + Y.QTY125  + Y.QTY126
                          ,WQTY19   = Y.QTY127  + Y.QTY128 + Y.QTY129  + Y.QTY130  + Y.QTY131  + Y.QTY132  + Y.QTY133
                          ,WQTY20   = Y.QTY134  + Y.QTY135 + Y.QTY136  + Y.QTY137  + Y.QTY138  + Y.QTY139  + Y.QTY140
                          ,WQTY21   = Y.QTY141  + Y.QTY142 + Y.QTY143  + Y.QTY144  + Y.QTY145  + Y.QTY146  + Y.QTY147
                          ,WQTY22   = Y.QTY148  + Y.QTY149 + Y.QTY150  + Y.QTY151  + Y.QTY152  + Y.QTY153  + Y.QTY154
                          ,WQTY23   = Y.QTY155  + Y.QTY156 + Y.QTY157  + Y.QTY158  + Y.QTY159  + Y.QTY160  + Y.QTY161
                          ,WQTY24   = Y.QTY162  + Y.QTY163 + Y.QTY164  + Y.QTY165  + Y.QTY166  + Y.QTY167  + Y.QTY168
                          ,WQTY25   = Y.QTY169  + Y.QTY170 + Y.QTY171  + Y.QTY172  + Y.QTY173  + Y.QTY174  + Y.QTY175
                          ,WQTY26   = Y.QTY176  + Y.QTY177 + Y.QTY178  + Y.QTY179  + Y.QTY180  + Y.QTY181  + Y.QTY182
                          ,WQTY27   = Y.QTY183  + Y.QTY184 + Y.QTY185  + Y.QTY186  + Y.QTY187  + Y.QTY188  + Y.QTY189
                          ,WQTY28   = Y.QTY190  + Y.QTY191 + Y.QTY192  + Y.QTY193  + Y.QTY194  + Y.QTY195  + Y.QTY196
                          ,WQTY29   = Y.QTY197  + Y.QTY198 + Y.QTY199  + Y.QTY200  + Y.QTY201  + Y.QTY202  + Y.QTY203
                          ,WQTY30   = Y.QTY204  + Y.QTY205 + Y.QTY206  + Y.QTY207  + Y.QTY208  + Y.QTY209  + Y.QTY210
                          ,WQTY31   = Y.QTY211  + Y.QTY212 + Y.QTY213  + Y.QTY214  + Y.QTY215  + Y.QTY216  + Y.QTY217
                          ,WQTY32   = Y.QTY218  + Y.QTY219 + Y.QTY220  + Y.QTY221  + Y.QTY222  + Y.QTY223  + Y.QTY224
                          ,WQTY33   = Y.QTY225  + Y.QTY226 + Y.QTY227  + Y.QTY228  + Y.QTY229  + Y.QTY230  + Y.QTY231
                          ,WQTY34   = Y.QTY232  + Y.QTY233 + Y.QTY234  + Y.QTY235  + Y.QTY236  + Y.QTY237  + Y.QTY238
                          ,WQTY35   = Y.QTY239  + Y.QTY240 + Y.QTY241  + Y.QTY242  + Y.QTY243  + Y.QTY244  + Y.QTY245
                          ,WQTY36   = Y.QTY246  + Y.QTY247 + Y.QTY248  + Y.QTY249  + Y.QTY250  + Y.QTY251  + Y.QTY252
                          ,WQTY37   = Y.QTY253  + Y.QTY254 + Y.QTY255  + Y.QTY256  + Y.QTY257  + Y.QTY258  + Y.QTY259
                          ,WQTY38   = Y.QTY260  + Y.QTY261 + Y.QTY262  + Y.QTY263  + Y.QTY264  + Y.QTY265  + Y.QTY266
                          ,WQTY39   = Y.QTY267  + Y.QTY268 + Y.QTY269  + Y.QTY270  + Y.QTY271  + Y.QTY272  + Y.QTY273
                          ,WQTY40   = Y.QTY274  + Y.QTY275 + Y.QTY276  + Y.QTY277  + Y.QTY278  + Y.QTY279  + Y.QTY280
                          ,WQTY41   = Y.QTY281  + Y.QTY282 + Y.QTY283  + Y.QTY284  + Y.QTY285  + Y.QTY286  + Y.QTY287
                          ,WQTY42   = Y.QTY288  + Y.QTY289 + Y.QTY290  + Y.QTY291  + Y.QTY292  + Y.QTY293  + Y.QTY294
                          ,WQTY43   = Y.QTY295  + Y.QTY296 + Y.QTY297  + Y.QTY298  + Y.QTY299  + Y.QTY300  + Y.QTY301
                          ,WQTY44   = Y.QTY302  + Y.QTY303 + Y.QTY304  + Y.QTY305  + Y.QTY306  + Y.QTY307  + Y.QTY308
                          ,WQTY45   = Y.QTY309  + Y.QTY310 + Y.QTY311  + Y.QTY312  + Y.QTY313  + Y.QTY314  + Y.QTY315
                          ,WQTY46   = Y.QTY316  + Y.QTY317 + Y.QTY318  + Y.QTY319  + Y.QTY320  + Y.QTY321  + Y.QTY322
                          ,WQTY47   = Y.QTY323  + Y.QTY324 + Y.QTY325  + Y.QTY326  + Y.QTY327  + Y.QTY328  + Y.QTY329
                          ,WQTY48   = Y.QTY330  + Y.QTY331 + Y.QTY332  + Y.QTY333  + Y.QTY334  + Y.QTY335  + Y.QTY336
                          ,WQTY49   = Y.QTY337  + Y.QTY338 + Y.QTY339  + Y.QTY340  + Y.QTY341  + Y.QTY342  + Y.QTY343
                          ,WQTY50   = Y.QTY344  + Y.QTY345 + Y.QTY346  + Y.QTY347  + Y.QTY348  + Y.QTY349  + Y.QTY350
                          ,WQTY51   = Y.QTY351  + Y.QTY352 + Y.QTY353  + Y.QTY354  + Y.QTY355  + Y.QTY356  + Y.QTY357
                          ,WQTY52   = Y.QTY358  + Y.QTY359 + Y.QTY360  + Y.QTY361  + Y.QTY362  + Y.QTY363  + Y.QTY364
                          ,LAST_UPDATED_BY    = @p_user_id
                          ,LAST_UPDATE_DATE   = GETDATE()

                   FROM SCP_XLS_PSI_GLOBAL_ESS  X WITH (NOLOCK)
                   INNER JOIN #DAY_SCP_XLS_PSI_GLOBAL Y WITH (NOLOCK)
                   ON X.XLS_KEY1            = Y.xls_key1 
                     WHERE 0 = 0
                        AND X.DIVISION_ID         = @p_division_id
                        AND X.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
                        AND X.SEQ                 = @p_seq
                        AND X.XLS_KEY1            = @p_xls_key1 --43 
                        AND X.MEASURE             IN  ('SHIP_PLAN','SEMI_SHIP_PLAN')               
              END -- IF  @p_day_week_flag = 'week'

            END

           
            
            -------------------------------------------------------------------------------------------------------------         
            -- SOURCE TABLE 반영
            -------------------------------------------------------------------------------------------------------------   

            SET @p_user_id = @p_user_id + '[SIMULATION]' -- UI 작업자와 시물레이션 작업자를 구분하기 위해서
                          
            -------------------------------------------------------------------------------------------------------------         
            -- SCP_ANL_SHIPMENT_PLAN_FG UPDATE
            -- SHIP_PLAN  --> SCP_ANL_SHIPMENT_PLAN_FG.MEASURE 'SHIP_PLAN_AMEND' UPDATE
            -------------------------------------------------------------------------------------------------------------
            IF @p_measure IN  ('SHIP_PLAN')   -- FG
              BEGIN 
              
            -- SHIP_PLAN
               IF OBJECT_ID('tempdb..#SCP_ANL_SHIPMENT_PLAN_FG') IS NOT NULL	
	              DROP TABLE #SCP_ANL_SHIPMENT_PLAN_FG

                SELECT X.DIVISION_ID, X.PLAN_START_YYYYMMDD, X.PLAN_TYPE, X.SEQ
                      ,X.OPERATION_GROUP AS BIZ_TYPE
                      ,X.PROJECT_CODE
--                      ,X.CELL_ITEM_ID
                      ,X.ITEM_ID
                      ,X.TO_SITE
                      ,X.INCOTERMS
                      ,X.FROM_SITE
                      ,X.BOD_ID
                      ,X.TRANSPORT_MODE
                      ,'SHIP_PLAN_AMEND' AS MEASURE 
                      ,Y.YYYYMMDD AS YYYYMMDD
                      ,X.QTY
                      ,'82' AS ORIGIN_FROM_DIVISION_ID
                      ,'82' AS ORIGIN_TO_DIVISION_ID
                      ,'' AS ELECTRODE_TYPE
                      ,X.ATTRIBUTE1
                      ,Y.YYYYMMDD_COLUMN
                INTO #SCP_ANL_SHIPMENT_PLAN_FG
                FROM
                  (
                  SELECT * 
                   FROM #DAY_SCP_XLS_PSI_GLOBAL     WITH (NOLOCK) 
                   WHERE 0 = 0
                   ) AS SourceTable  
                UNPIVOT 
                    (
                     QTY FOR  YYYYMMDD_COLUMN IN (
                                           [QTY001], [QTY002], [QTY003], [QTY004], [QTY005],[QTY006], [QTY007], [QTY008], [QTY009], [QTY010]
                                          ,[QTY011], [QTY012], [QTY013], [QTY014], [QTY015],[QTY016], [QTY017], [QTY018], [QTY019], [QTY020]
                                          ,[QTY021], [QTY022], [QTY023], [QTY024], [QTY025],[QTY026], [QTY027], [QTY028], [QTY029], [QTY030]
                                          ,[QTY031], [QTY032], [QTY033], [QTY034], [QTY035],[QTY036], [QTY037], [QTY038], [QTY039], [QTY040]
                                          ,[QTY041], [QTY042], [QTY043], [QTY044], [QTY045],[QTY046], [QTY047], [QTY048], [QTY049], [QTY050]
                                          ,[QTY051], [QTY052], [QTY053], [QTY054], [QTY055],[QTY056], [QTY057], [QTY058], [QTY059], [QTY060]
                                          ,[QTY061], [QTY062], [QTY063], [QTY064], [QTY065],[QTY066], [QTY067], [QTY068], [QTY069], [QTY070]
                                          ,[QTY071], [QTY072], [QTY073], [QTY074], [QTY075],[QTY076], [QTY077], [QTY078], [QTY079], [QTY080]
                                          ,[QTY081], [QTY082], [QTY083], [QTY084], [QTY085],[QTY086], [QTY087], [QTY088], [QTY089], [QTY090]
                                          ,[QTY091], [QTY092], [QTY093], [QTY094], [QTY095],[QTY096], [QTY097], [QTY098], [QTY099], [QTY100]

                                          ,[QTY101], [QTY102], [QTY103], [QTY104], [QTY105],[QTY106], [QTY107], [QTY108], [QTY109], [QTY110]
                                          ,[QTY111], [QTY112], [QTY113], [QTY114], [QTY115],[QTY116], [QTY117], [QTY118], [QTY119], [QTY120]
                                          ,[QTY121], [QTY122], [QTY123], [QTY124], [QTY125],[QTY126], [QTY127], [QTY128], [QTY129], [QTY130]
                                          ,[QTY131], [QTY132], [QTY133], [QTY134], [QTY135],[QTY136], [QTY137], [QTY138], [QTY139], [QTY140]
                                          ,[QTY141], [QTY142], [QTY143], [QTY144], [QTY145],[QTY146], [QTY147], [QTY148], [QTY149], [QTY150]
                                          ,[QTY151], [QTY152], [QTY153], [QTY154], [QTY155],[QTY156], [QTY157], [QTY158], [QTY159], [QTY160]
                                          ,[QTY161], [QTY162], [QTY163], [QTY164], [QTY165],[QTY166], [QTY167], [QTY168], [QTY169], [QTY170]
                                          ,[QTY171], [QTY172], [QTY173], [QTY174], [QTY175],[QTY176], [QTY177], [QTY178], [QTY179], [QTY180]
                                          ,[QTY181], [QTY182], [QTY183], [QTY184], [QTY185],[QTY186], [QTY187], [QTY188], [QTY189], [QTY190]
                                          ,[QTY191], [QTY192], [QTY193], [QTY194], [QTY195],[QTY196], [QTY197], [QTY198], [QTY199], [QTY200]

                                          ,[QTY201], [QTY202], [QTY203], [QTY204], [QTY205],[QTY206], [QTY207], [QTY208], [QTY209], [QTY210]
                                          ,[QTY211], [QTY212], [QTY213], [QTY214], [QTY215],[QTY216], [QTY217], [QTY218], [QTY219], [QTY220]
                                          ,[QTY221], [QTY222], [QTY223], [QTY224], [QTY225],[QTY226], [QTY227], [QTY228], [QTY229], [QTY230]
                                          ,[QTY231], [QTY232], [QTY233], [QTY234], [QTY235],[QTY236], [QTY237], [QTY238], [QTY239], [QTY240]
                                          ,[QTY241], [QTY242], [QTY243], [QTY244], [QTY245],[QTY246], [QTY247], [QTY248], [QTY249], [QTY250]
                                          ,[QTY251], [QTY252], [QTY253], [QTY254], [QTY255],[QTY256], [QTY257], [QTY258], [QTY259], [QTY260]
                                          ,[QTY261], [QTY262], [QTY263], [QTY264], [QTY265],[QTY266], [QTY267], [QTY268], [QTY269], [QTY270]
                                          ,[QTY271], [QTY272], [QTY273], [QTY274], [QTY275],[QTY276], [QTY277], [QTY278], [QTY279], [QTY280]
                                          ,[QTY281], [QTY282], [QTY283], [QTY284], [QTY285],[QTY286], [QTY287], [QTY288], [QTY289], [QTY290]
                                          ,[QTY291], [QTY292], [QTY293], [QTY294], [QTY295],[QTY296], [QTY297], [QTY298], [QTY299], [QTY300]

                                          ,[QTY301], [QTY302], [QTY303], [QTY304], [QTY305],[QTY306], [QTY307], [QTY308], [QTY309], [QTY310]
                                          ,[QTY311], [QTY312], [QTY313], [QTY314], [QTY315],[QTY316], [QTY317], [QTY318], [QTY319], [QTY320]
                                          ,[QTY321], [QTY322], [QTY323], [QTY324], [QTY325],[QTY326], [QTY327], [QTY328], [QTY329], [QTY330]
                                          ,[QTY331], [QTY332], [QTY333], [QTY334], [QTY335],[QTY336], [QTY337], [QTY338], [QTY339], [QTY340]
                                          ,[QTY341], [QTY342], [QTY343], [QTY344], [QTY345],[QTY346], [QTY347], [QTY348], [QTY349], [QTY350]
                                          ,[QTY351], [QTY352], [QTY353], [QTY354], [QTY355],[QTY356], [QTY357], [QTY358], [QTY359], [QTY360]
                                          ,[QTY361], [QTY362], [QTY363], [QTY364]

                                          )  
                ) AS X
                INNER JOIN (SELECT A.BASIS_YYYYMMDD AS YYYYMMDD    
                                  ,'QTY' + REPLICATE('0', 3 - LEN(ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD) )) + CONVERT(NVARCHAR,ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD)) AS YYYYMMDD_COLUMN
                              FROM DBO.SCM_SYS_CALENDAR_M A  WITH(NOLOCK)	     
                              WHERE A.BASIS_YYYYMMDD     >= @p_PLAN_START_YYYYMMDD
                                AND A.BASIS_YYYYMMDD     <  @p_to_yyyymmdd
                            ) Y
                ON X.YYYYMMDD_COLUMN = Y.YYYYMMDD_COLUMN
             ;

            -------------------------------------------------------------------------------------------------------------         
            -- FROZEN 구간 UPDATE
            -- PLANT SITE(SCM_MST_SITE)의 SHIP_FROZEN ,PROD_FROZEN를 주단위로 변경하여 FROZEN 구간을 저장 내역에서 삭제한다.
            -------------------------------------------------------------------------------------------------------------
              IF @p_plan_type IN  ('PR','MA','SE')  
              BEGIN
                DELETE  FROM #SCP_ANL_SHIPMENT_PLAN_FG
                        FROM #SCP_ANL_SHIPMENT_PLAN_FG X
                      INNER JOIN #SCM_MST_SITE Y
                         ON Y.DIVISION_ID = X.DIVISION_ID
                        AND Y.SCM_SITE_ID = X.FROM_SITE
                      WHERE 
                          X.YYYYMMDD < Y.SHIP_FROZEN_WEEK_DAY;
              END

               MERGE INTO SCP_ANL_SHIPMENT_PLAN_FG AS X  
                USING (SELECT 
                              DIVISION_ID
                             ,PLAN_START_YYYYMMDD
                             ,PLAN_TYPE
                             ,SEQ
                             ,BIZ_TYPE
                             ,PROJECT_CODE
      --                     ,CELL_ITEM_ID
                             ,ITEM_ID
                             ,TO_SITE
                             ,INCOTERMS
                             ,FROM_SITE
                             ,BOD_ID
--                             ,TRANSPORT_MODE
                             ,MEASURE 
                             ,YYYYMMDD
                             ,QTY
                             ,ORIGIN_FROM_DIVISION_ID
                             ,ORIGIN_TO_DIVISION_ID
                             ,ELECTRODE_TYPE
                        FROM #SCP_ANL_SHIPMENT_PLAN_FG
                       --WHERE QTY > 0 
                      ) AS Y
                ON 0 = 0
                AND X.DIVISION_ID               = @p_division_id
                AND X.PLAN_START_YYYYMMDD       = @p_PLAN_START_YYYYMMDD
                AND X.PLAN_TYPE                 = @p_PLAN_TYPE
                AND X.SEQ                       = @p_SEQ
                
                AND X.BIZ_TYPE                  = Y.BIZ_TYPE
                AND X.PROJECT_CODE              = Y.PROJECT_CODE
                AND X.ITEM_ID                   = Y.ITEM_ID
                AND X.TO_SITE                   = Y.TO_SITE
                AND X.INCOTERMS                 = Y.INCOTERMS
                AND X.FROM_SITE                 = Y.FROM_SITE
                AND X.BOD_ID                    = Y.BOD_ID
                
                AND X.MEASURE                   = Y.MEASURE
                AND X.YYYYMMDD                  = Y.YYYYMMDD


                WHEN MATCHED  THEN 
                UPDATE 
                  SET  X.QTY = Y.QTY
                      --,X.CREATED_BY         = @p_USER_ID
                      --,X.CREATION_DATE      = GETDATE()
                      ,X.LAST_UPDATED_BY    = @p_USER_ID
                      ,X.LAST_UPDATE_DATE   = GETDATE()

                WHEN NOT MATCHED  THEN 
                 
                  INSERT (
                             DIVISION_ID
                             ,PLAN_START_YYYYMMDD
                             ,PLAN_TYPE
                             ,SEQ
                             ,BIZ_TYPE
                             ,PROJECT_CODE
      --                     ,CELL_ITEM_ID
                             ,ITEM_ID
                             ,TO_SITE
                             ,INCOTERMS
                             ,FROM_SITE
                             ,BOD_ID
    --                       ,TRANSPORT_MODE
                             ,MEASURE 
                             ,YYYYMMDD
                             ,QTY
                             ,ORIGIN_FROM_DIVISION_ID
                             ,ORIGIN_TO_DIVISION_ID
                             ,ELECTRODE_TYPE
                            ,CREATED_BY
                            ,CREATION_DATE
                            ,LAST_UPDATED_BY
                            ,LAST_UPDATE_DATE
                        )
                 VALUES (
                           Y.DIVISION_ID
                          ,Y.PLAN_START_YYYYMMDD
                          ,Y.PLAN_TYPE
                          ,Y.SEQ
                          ,Y.BIZ_TYPE
                          ,Y.PROJECT_CODE
  --                     ,Y.CELL_ITEM_ID
                          ,Y.ITEM_ID
                          ,Y.TO_SITE
                          ,Y.INCOTERMS
                          ,Y.FROM_SITE
                          ,Y.BOD_ID
  --                       ,Y.TRANSPORT_MODE
                          ,Y.MEASURE 
                          ,Y.YYYYMMDD
                          ,Y.QTY
                          ,Y.ORIGIN_FROM_DIVISION_ID
                          ,Y.ORIGIN_TO_DIVISION_ID
                          ,Y.ELECTRODE_TYPE
                          ,@p_USER_ID
                          ,GETDATE()
                          ,@p_USER_ID
                          ,GETDATE()
                        )

                        ;                        

            -------------------------------------------------------------------------------------------------------------         
            -- SCP_ANL_SHIPMENT_PLAN_FG_H : History 입력
            -------------------------------------------------------------------------------------------------------------         
            -- SELECT top 10 * FROM dbo.SCP_ANL_SHIPMENT_PLAN_FG_H WITH (NOLOCK)     -- HISTORY_SEQ
            -- SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_ANL_SHIPMENT_PLAN_FG_H

                      INSERT INTO dbo.SCP_ANL_SHIPMENT_PLAN_FG_H
                      (
                        HISTORY_SEQ
                        ,DIVISION_ID
                        ,PLAN_START_YYYYMMDD
                        ,PLAN_TYPE
                        ,SEQ
                        ,BIZ_TYPE
                        ,PROJECT_CODE
                        ,ITEM_ID
                        ,TO_SITE
                        ,INCOTERMS
                        ,FROM_SITE
                        ,BOD_ID
                        ,MEASURE
                        ,YYYYMMDD
                        ,QTY
                        ,ORIGIN_TO_DIVISION_ID
                        ,ORIGIN_FROM_DIVISION_ID
                        ,ELECTRODE_TYPE
                        ,CREATED_BY
                        ,CREATION_DATE
                        ,LAST_UPDATED_BY
                        ,LAST_UPDATE_DATE
                        --,ATTRIBUTE1
                        --,ATTRIBUTE2
                        --,ATTRIBUTE3
                        --,ATTRIBUTE4
                        --,ATTRIBUTE5
                        --,ATTRIBUTE6
                        --,ATTRIBUTE7
                        --,ATTRIBUTE8
                        --,ATTRIBUTE9
                        --,ATTRIBUTE10
                        ,HISTORY_CREATION_DATE
                      )
                      SELECT 
                        NEXT VALUE FOR SEQ1_SCP_ANL_SHIPMENT_PLAN_FG_H
                        ,DIVISION_ID
                        ,PLAN_START_YYYYMMDD
                        ,PLAN_TYPE
                        ,SEQ
                        ,BIZ_TYPE
                        ,PROJECT_CODE
                        ,ITEM_ID
                        ,TO_SITE
                        ,INCOTERMS
                        ,FROM_SITE
                        ,BOD_ID
                        ,MEASURE
                        ,YYYYMMDD
                        ,QTY
                        ,ORIGIN_TO_DIVISION_ID
                        ,ORIGIN_FROM_DIVISION_ID
                        ,ELECTRODE_TYPE
                        ,@p_user_id   AS CREATED_BY
                        ,GETDATE()    AS CREATION_DATE
                        ,@p_user_id   AS LAST_UPDATED_BY
                        ,GETDATE()    AS LAST_UPDATE_DATE
                        --,ATTRIBUTE1
                        --,ATTRIBUTE2
                        --,ATTRIBUTE3
                        --,ATTRIBUTE4
                        --,ATTRIBUTE5
                        --,ATTRIBUTE6
                        --,ATTRIBUTE7
                        --,ATTRIBUTE8
                        --,ATTRIBUTE9
                        --,ATTRIBUTE10
                        ,GETDATE()    AS HISTORY_CREATION_DATE
                       FROM #SCP_ANL_SHIPMENT_PLAN_FG  WITH (NOLOCK)


            -------------------------------------------------------------------------------------------------------------         
            -- SCP_ANL_SHIPMENT_PLAN_FIX : FIX 입력(FG)
            -------------------------------------------------------------------------------------------------------------         


                        -- FIX UPDATE
                        UPDATE X
                          SET X.QTY               = Y.QTY
                             ,X.FIX_REASON    = 'SIMULATION UPDATE'
                             ,X.ATTRIBUTE1        = 'Y'       -- History 구분을 위해
                             ,X.LAST_UPDATED_BY   = @p_user_id
                             ,X.LAST_UPDATE_DATE  = GETDATE()
                          FROM SCP_ANL_SHIPMENT_PLAN_FIX  X WITH (NOLOCK)     -- FIX_ID, DIVISION_ID, BIZ_TYPE, ITEM_ID, TO_SITE, FROM_SITE, BOD_ID, YYYYMMDD
                          INNER JOIN #SCP_ANL_SHIPMENT_PLAN_FG Y WITH (NOLOCK)
                          ON 0 = 0
                          AND X.DIVISION_ID = Y.DIVISION_ID
                          AND X.BIZ_TYPE    = Y.BIZ_TYPE
                          AND X.ITEM_ID     = Y.ITEM_ID
                          AND X.TO_SITE     = Y.TO_SITE
                          AND X.FROM_SITE   = Y.FROM_SITE
                          AND X.BOD_ID      = Y.BOD_ID
                          AND X.YYYYMMDD    = Y.YYYYMMDD          


            -------------------------------------------------------------------------------------------------------------         
            -- SCP_ANL_SHIPMENT_PLAN_FIX_H : FIX History 입력
            -------------------------------------------------------------------------------------------------------------         

--                       SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_ANL_SHIPMENT_PLAN_FIX_H   -- 현재 사용안함.
--                       SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H -- SCP_ANL_PRODUCTION_PLAN_FIX 대신 사용중임.
                       --SELECT NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H

                      INSERT INTO dbo.SCP_ANL_SHIPMENT_PLAN_FIX_H
                      (
                          HISTORY_SEQ
                          ,FIX_ID
                          ,DIVISION_ID
                          ,BIZ_TYPE
                          ,ITEM_ID
                          ,TO_SITE
                          ,FROM_SITE
                          ,PROJECT_CODE
                          ,INCOTERMS
                          ,BOD_ID
                          ,YYYYMMDD
                          ,QTY
                          ,FIX_REASON
                          ,ORIGIN_FROM_DIVISION_ID
                          ,ORIGIN_TO_DIVISION_ID
                          ,ELECTRODE_TYPE
                          ,CREATED_BY
                          ,CREATION_DATE
                          ,LAST_UPDATED_BY
                          ,LAST_UPDATE_DATE
                          --,ATTRIBUTE1
                          --,ATTRIBUTE2
                          --,ATTRIBUTE3
                          --,ATTRIBUTE4
                          --,ATTRIBUTE5
                          --,ATTRIBUTE6
                          --,ATTRIBUTE7
                          --,ATTRIBUTE8
                          --,ATTRIBUTE9
                          --,ATTRIBUTE10
                          ,HISTORY_CREATION_DATE
                    )
                    SELECT NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H
                          ,FIX_ID
                          ,DIVISION_ID
                          ,BIZ_TYPE
                          ,ITEM_ID
                          ,TO_SITE
                          ,FROM_SITE
                          ,PROJECT_CODE
                          ,INCOTERMS
                          ,BOD_ID
                          ,YYYYMMDD
                          ,QTY
                          ,FIX_REASON
                          ,ORIGIN_FROM_DIVISION_ID
                          ,ORIGIN_TO_DIVISION_ID
                          ,ELECTRODE_TYPE
                            ,@p_user_id   AS CREATED_BY
                          ,GETDATE()    AS CREATION_DATE
                          ,@p_user_id   AS LAST_UPDATED_BY
                          ,GETDATE()    AS LAST_UPDATE_DATE
                        --,ATTRIBUTE1
                        --,ATTRIBUTE2
                        --,ATTRIBUTE3
                        --,ATTRIBUTE4
                        --,ATTRIBUTE5
                        --,ATTRIBUTE6
                        --,ATTRIBUTE7
                        --,ATTRIBUTE8
                        --,ATTRIBUTE9
                        --,ATTRIBUTE10
                        ,GETDATE()    AS HISTORY_CREATION_DATE
                   FROM SCP_ANL_SHIPMENT_PLAN_FIX  WITH (NOLOCK)
                  WHERE ATTRIBUTE1 =N'Y'


                  UPDATE X
                    SET X.ATTRIBUTE1 = NULL       -- History 구분을 위해 원상복구
                    FROM SCP_ANL_SHIPMENT_PLAN_FIX  X WITH (NOLOCK)     -- FIX_ID, DIVISION_ID, BIZ_TYPE, ITEM_ID, TO_SITE, FROM_SITE, BOD_ID, YYYYMMDD
                    INNER JOIN #SCP_ANL_SHIPMENT_PLAN_FG Y WITH (NOLOCK)
                    ON 0 = 0
                    AND X.DIVISION_ID = Y.DIVISION_ID
                    AND X.BIZ_TYPE    = Y.BIZ_TYPE
                    AND X.ITEM_ID     = Y.ITEM_ID
                    AND X.TO_SITE     = Y.TO_SITE
                    AND X.FROM_SITE   = Y.FROM_SITE
                    AND X.BOD_ID      = Y.BOD_ID
                    AND X.YYYYMMDD    = Y.YYYYMMDD  
                    AND X.ATTRIBUTE1  ='Y'
            END

            
            -------------------------------------------------------------------------------------------------------------         
            -- SCP_ANL_SHIPMENT_PLAN_SEMI UPDATE
            -- SEMI_SHIP_PLAN --> SCP_ANL_SHIPMENT_PLAN_SEMI.MEASURE 'SHIP_PLAN_AMEND' UPDATE
            -------------------------------------------------------------------------------------------------------------
            IF @p_measure IN  ('SEMI_SHIP_PLAN')   -- SEMI
              BEGIN 

            -- SEMI_SHIP_PLAN
              IF OBJECT_ID('tempdb..#SCP_ANL_SHIPMENT_PLAN_SEMI') IS NOT NULL	
	              DROP TABLE #SCP_ANL_SHIPMENT_PLAN_SEMI

                SELECT X.DIVISION_ID, X.PLAN_START_YYYYMMDD, X.PLAN_TYPE, X.SEQ
                      ,X.OPERATION_GROUP
--                      ,X.CELL_ITEM_ID
                      ,X.ITEM_ID
                      ,X.FROM_SITE
                      ,X.BOD_ID
                      ,'SHIP_PLAN_AMEND' AS MEASURE
                      ,Y.YYYYMMDD AS YYYYMMDD
                      ,X.TO_SITE
                      ,X.QTY
                      ,'82' AS ORIGIN_FROM_DIVISION_ID
                      ,'82' AS ORIGIN_TO_DIVISION_ID
                      ,'' AS ELECTRODE_TYPE
                      ,X.ATTRIBUTE1
                      ,Y.YYYYMMDD_COLUMN
                INTO #SCP_ANL_SHIPMENT_PLAN_SEMI
                FROM
                  (
                  SELECT * --
                   FROM #DAY_SCP_XLS_PSI_GLOBAL     WITH (NOLOCK) 
                   WHERE 0 = 0
                    AND XLS_KEY1            = @p_xls_key1 --43 
                   ) AS SourceTable  
                UNPIVOT 
                    (
                     QTY FOR  YYYYMMDD_COLUMN IN (
                                           [QTY001], [QTY002], [QTY003], [QTY004], [QTY005],[QTY006], [QTY007], [QTY008], [QTY009], [QTY010]
                                          ,[QTY011], [QTY012], [QTY013], [QTY014], [QTY015],[QTY016], [QTY017], [QTY018], [QTY019], [QTY020]
                                          ,[QTY021], [QTY022], [QTY023], [QTY024], [QTY025],[QTY026], [QTY027], [QTY028], [QTY029], [QTY030]
                                          ,[QTY031], [QTY032], [QTY033], [QTY034], [QTY035],[QTY036], [QTY037], [QTY038], [QTY039], [QTY040]
                                          ,[QTY041], [QTY042], [QTY043], [QTY044], [QTY045],[QTY046], [QTY047], [QTY048], [QTY049], [QTY050]
                                          ,[QTY051], [QTY052], [QTY053], [QTY054], [QTY055],[QTY056], [QTY057], [QTY058], [QTY059], [QTY060]
                                          ,[QTY061], [QTY062], [QTY063], [QTY064], [QTY065],[QTY066], [QTY067], [QTY068], [QTY069], [QTY070]
                                          ,[QTY071], [QTY072], [QTY073], [QTY074], [QTY075],[QTY076], [QTY077], [QTY078], [QTY079], [QTY080]
                                          ,[QTY081], [QTY082], [QTY083], [QTY084], [QTY085],[QTY086], [QTY087], [QTY088], [QTY089], [QTY090]
                                          ,[QTY091], [QTY092], [QTY093], [QTY094], [QTY095],[QTY096], [QTY097], [QTY098], [QTY099], [QTY100]

                                          ,[QTY101], [QTY102], [QTY103], [QTY104], [QTY105],[QTY106], [QTY107], [QTY108], [QTY109], [QTY110]
                                          ,[QTY111], [QTY112], [QTY113], [QTY114], [QTY115],[QTY116], [QTY117], [QTY118], [QTY119], [QTY120]
                                          ,[QTY121], [QTY122], [QTY123], [QTY124], [QTY125],[QTY126], [QTY127], [QTY128], [QTY129], [QTY130]
                                          ,[QTY131], [QTY132], [QTY133], [QTY134], [QTY135],[QTY136], [QTY137], [QTY138], [QTY139], [QTY140]
                                          ,[QTY141], [QTY142], [QTY143], [QTY144], [QTY145],[QTY146], [QTY147], [QTY148], [QTY149], [QTY150]
                                          ,[QTY151], [QTY152], [QTY153], [QTY154], [QTY155],[QTY156], [QTY157], [QTY158], [QTY159], [QTY160]
                                          ,[QTY161], [QTY162], [QTY163], [QTY164], [QTY165],[QTY166], [QTY167], [QTY168], [QTY169], [QTY170]
                                          ,[QTY171], [QTY172], [QTY173], [QTY174], [QTY175],[QTY176], [QTY177], [QTY178], [QTY179], [QTY180]
                                          ,[QTY181], [QTY182], [QTY183], [QTY184], [QTY185],[QTY186], [QTY187], [QTY188], [QTY189], [QTY190]
                                          ,[QTY191], [QTY192], [QTY193], [QTY194], [QTY195],[QTY196], [QTY197], [QTY198], [QTY199], [QTY200]

                                          ,[QTY201], [QTY202], [QTY203], [QTY204], [QTY205],[QTY206], [QTY207], [QTY208], [QTY209], [QTY210]
                                          ,[QTY211], [QTY212], [QTY213], [QTY214], [QTY215],[QTY216], [QTY217], [QTY218], [QTY219], [QTY220]
                                          ,[QTY221], [QTY222], [QTY223], [QTY224], [QTY225],[QTY226], [QTY227], [QTY228], [QTY229], [QTY230]
                                          ,[QTY231], [QTY232], [QTY233], [QTY234], [QTY235],[QTY236], [QTY237], [QTY238], [QTY239], [QTY240]
                                          ,[QTY241], [QTY242], [QTY243], [QTY244], [QTY245],[QTY246], [QTY247], [QTY248], [QTY249], [QTY250]
                                          ,[QTY251], [QTY252], [QTY253], [QTY254], [QTY255],[QTY256], [QTY257], [QTY258], [QTY259], [QTY260]
                                          ,[QTY261], [QTY262], [QTY263], [QTY264], [QTY265],[QTY266], [QTY267], [QTY268], [QTY269], [QTY270]
                                          ,[QTY271], [QTY272], [QTY273], [QTY274], [QTY275],[QTY276], [QTY277], [QTY278], [QTY279], [QTY280]
                                          ,[QTY281], [QTY282], [QTY283], [QTY284], [QTY285],[QTY286], [QTY287], [QTY288], [QTY289], [QTY290]
                                          ,[QTY291], [QTY292], [QTY293], [QTY294], [QTY295],[QTY296], [QTY297], [QTY298], [QTY299], [QTY300]

                                          ,[QTY301], [QTY302], [QTY303], [QTY304], [QTY305],[QTY306], [QTY307], [QTY308], [QTY309], [QTY310]
                                          ,[QTY311], [QTY312], [QTY313], [QTY314], [QTY315],[QTY316], [QTY317], [QTY318], [QTY319], [QTY320]
                                          ,[QTY321], [QTY322], [QTY323], [QTY324], [QTY325],[QTY326], [QTY327], [QTY328], [QTY329], [QTY330]
                                          ,[QTY331], [QTY332], [QTY333], [QTY334], [QTY335],[QTY336], [QTY337], [QTY338], [QTY339], [QTY340]
                                          ,[QTY341], [QTY342], [QTY343], [QTY344], [QTY345],[QTY346], [QTY347], [QTY348], [QTY349], [QTY350]
                                          ,[QTY351], [QTY352], [QTY353], [QTY354], [QTY355],[QTY356], [QTY357], [QTY358], [QTY359], [QTY360]
                                          ,[QTY361], [QTY362], [QTY363], [QTY364]

                                          )  
                ) AS X
                INNER JOIN (SELECT A.BASIS_YYYYMMDD AS YYYYMMDD    
                                  ,'QTY' + REPLICATE('0', 3 - LEN(ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD) )) + CONVERT(NVARCHAR,ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD)) AS YYYYMMDD_COLUMN
                              FROM DBO.SCM_SYS_CALENDAR_M A  WITH(NOLOCK)	     
                              WHERE A.BASIS_YYYYMMDD     >= @p_PLAN_START_YYYYMMDD
                                AND A.BASIS_YYYYMMDD     <  @p_to_yyyymmdd
                            ) Y
                ON X.YYYYMMDD_COLUMN = Y.YYYYMMDD_COLUMN
                ;
                
                -------------------------------------------------------------------------------------------------------------         
                -- FROZEN 구간 UPDATE
                -- PLANT SITE(SCM_MST_SITE)의 SHIP_FROZEN ,PROD_FROZEN를 주단위로 변경하여 FROZEN 구간을 저장 내역에서 삭제한다.
                -------------------------------------------------------------------------------------------------------------
                IF @p_plan_type IN  ('PR','MA','SE')  
                BEGIN
                  DELETE  FROM #SCP_ANL_SHIPMENT_PLAN_SEMI
                          FROM #SCP_ANL_SHIPMENT_PLAN_SEMI X
                        INNER JOIN #SCM_MST_SITE Y
                           ON Y.DIVISION_ID = X.DIVISION_ID
                          AND Y.SCM_SITE_ID = X.FROM_SITE
                        WHERE 
                            X.YYYYMMDD < Y.SHIP_FROZEN_WEEK_DAY;
                END

               MERGE INTO SCP_ANL_SHIPMENT_PLAN_SEMI AS X  
                USING (SELECT DIVISION_ID
                             ,PLAN_START_YYYYMMDD
                             ,PLAN_TYPE
                             ,SEQ
                             ,OPERATION_GROUP
--                             ,CELL_ITEM_ID
                             ,ITEM_ID
                             ,FROM_SITE
                             ,BOD_ID
                             ,MEASURE
                             ,YYYYMMDD
                             ,TO_SITE
                             ,QTY
                             ,ORIGIN_FROM_DIVISION_ID
                             ,ORIGIN_TO_DIVISION_ID
                             ,ELECTRODE_TYPE
                        FROM #SCP_ANL_SHIPMENT_PLAN_SEMI
                       --WHERE QTY > 0 
                      ) AS Y
                ON 0 = 0
                AND X.DIVISION_ID         = @p_division_id
                AND X.PLAN_START_YYYYMMDD = @p_PLAN_START_YYYYMMDD
                AND X.PLAN_TYPE           = @p_PLAN_TYPE
                AND X.SEQ                 = @p_SEQ
                
                AND X.OPERATION_GROUP     = Y.OPERATION_GROUP
                AND X.ITEM_ID             = Y.ITEM_ID
                AND X.FROM_SITE           = Y.FROM_SITE
                AND X.BOD_ID              = Y.BOD_ID
                AND X.MEASURE             = Y.MEASURE
                AND X.YYYYMMDD            = Y.YYYYMMDD
                AND X.TO_SITE             = Y.TO_SITE


                WHEN MATCHED  THEN 
                UPDATE 
                  SET  X.QTY = Y.QTY
                      --,X.CREATED_BY         = @p_USER_ID
                      --,X.CREATION_DATE      = GETDATE()
                      ,X.LAST_UPDATED_BY    = @p_USER_ID
                      ,X.LAST_UPDATE_DATE   = GETDATE()

                WHEN NOT MATCHED  THEN 
                  INSERT (
                             DIVISION_ID
                            ,PLAN_START_YYYYMMDD
                            ,PLAN_TYPE
                            ,SEQ
                            ,OPERATION_GROUP
                            ,ITEM_ID
                            ,FROM_SITE
                            ,BOD_ID
                            ,MEASURE
                            ,YYYYMMDD
                            ,TO_SITE
                            ,QTY
                            ,ORIGIN_FROM_DIVISION_ID
                            ,ORIGIN_TO_DIVISION_ID
                            ,ELECTRODE_TYPE
                            ,CREATED_BY
                            ,CREATION_DATE
                            ,LAST_UPDATED_BY
                            ,LAST_UPDATE_DATE
                        )
                 VALUES (
                           Y.DIVISION_ID
                          ,Y.PLAN_START_YYYYMMDD
                          ,Y.PLAN_TYPE
                          ,Y.SEQ
                          ,Y.OPERATION_GROUP
                          ,Y.ITEM_ID
                          ,Y.FROM_SITE
                          ,Y.BOD_ID
                          ,Y.MEASURE
                          ,Y.YYYYMMDD
                          ,Y.TO_SITE
                          ,Y.QTY
                          ,Y.ORIGIN_FROM_DIVISION_ID
                          ,Y.ORIGIN_TO_DIVISION_ID
                          ,Y.ELECTRODE_TYPE
                          ,@p_USER_ID
                          ,GETDATE()
                          ,@p_USER_ID
                          ,GETDATE()
                        )
                        ;


            -------------------------------------------------------------------------------------------------------------         
            -- SCP_ANL_SHIPMENT_PLAN_SEMI_H : History 입력(SEMI)
            ------------------------------------------------------------------------------------------------------------- 

                      INSERT INTO dbo.SCP_ANL_SHIPMENT_PLAN_SEMI_H
                      (
                        HISTORY_SEQ
                        ,DIVISION_ID
                        ,PLAN_START_YYYYMMDD
                        ,PLAN_TYPE
                        ,SEQ
                        ,OPERATION_GROUP
                        ,ITEM_ID
                        ,FROM_SITE
                        ,TO_SITE
                        ,BOD_ID
                        ,MEASURE
                        ,YYYYMMDD
                        ,QTY
                        ,UPDATE_REASON_BOD
                        ,ORIGIN_FROM_DIVISION_ID
                        ,ORIGIN_TO_DIVISION_ID
                        ,ELECTRODE_TYPE
                        ,CREATED_BY
                        ,CREATION_DATE
                        ,LAST_UPDATED_BY
                        ,LAST_UPDATE_DATE
                        --,ATTRIBUTE1
                        --,ATTRIBUTE2
                        --,ATTRIBUTE3
                        --,ATTRIBUTE4
                        --,ATTRIBUTE5
                        --,ATTRIBUTE6
                        --,ATTRIBUTE7
                        --,ATTRIBUTE8
                        --,ATTRIBUTE9
                        --,ATTRIBUTE10
                        ,HISTORY_CREATION_DATE
                      )
                      SELECT 
                         NEXT VALUE FOR SEQ1_SCP_ANL_SHIPMENT_PLAN_SEMI_H
                        ,DIVISION_ID
                        ,PLAN_START_YYYYMMDD
                        ,PLAN_TYPE
                        ,SEQ
                        ,OPERATION_GROUP
                        ,ITEM_ID
                        ,FROM_SITE
                        ,TO_SITE
                        ,BOD_ID
                        ,MEASURE
                        ,YYYYMMDD
                        ,QTY
                        ,NULL AS UPDATE_REASON_BOD
                        ,ORIGIN_FROM_DIVISION_ID
                        ,ORIGIN_TO_DIVISION_ID
                        ,ELECTRODE_TYPE
                        ,@p_user_id   AS CREATED_BY
                        ,GETDATE()    AS CREATION_DATE
                        ,@p_user_id   AS LAST_UPDATED_BY
                        ,GETDATE()    AS LAST_UPDATE_DATE
                        --,ATTRIBUTE1
                        --,ATTRIBUTE2
                        --,ATTRIBUTE3
                        --,ATTRIBUTE4
                        --,ATTRIBUTE5
                        --,ATTRIBUTE6
                        --,ATTRIBUTE7
                        --,ATTRIBUTE8
                        --,ATTRIBUTE9
                        --,ATTRIBUTE10
                        ,GETDATE() AS HISTORY_CREATION_DATE
                       FROM #SCP_ANL_SHIPMENT_PLAN_SEMI  WITH (NOLOCK)

            -------------------------------------------------------------------------------------------------------------         
            -- SCP_ANL_SHIPMENT_PLAN_FIX : FIX 입력(SEMI)
            ------------------------------------------------------------------------------------------------------------- 
                        -- FIX UPDATE
                        UPDATE X
                          SET X.QTY         = Y.QTY
                            , X.FIX_REASON    = 'SIMULATION UPDATE'
                            , X.ATTRIBUTE1  ='Y'       -- History 구분을 위해
                          FROM SCP_ANL_SHIPMENT_PLAN_FIX  X WITH (NOLOCK)     -- FIX_ID, DIVISION_ID, BIZ_TYPE, ITEM_ID, TO_SITE, FROM_SITE, BOD_ID, YYYYMMDD
                          INNER JOIN #SCP_ANL_SHIPMENT_PLAN_SEMI Y WITH (NOLOCK)
                          ON 0 = 0
                          AND X.DIVISION_ID = Y.DIVISION_ID
                          AND X.BIZ_TYPE    = Y.OPERATION_GROUP
                          AND X.ITEM_ID     = Y.ITEM_ID
                          AND X.TO_SITE     = Y.TO_SITE
                          AND X.FROM_SITE   = Y.FROM_SITE
                          AND X.BOD_ID      = Y.BOD_ID
                          AND X.YYYYMMDD    = Y.YYYYMMDD


            -------------------------------------------------------------------------------------------------------------         
            -- SCP_ANL_SHIPMENT_PLAN_FIX_H : FIX History 입력(SEMI)
            -------------------------------------------------------------------------------------------------------------         
            INSERT INTO dbo.SCP_ANL_SHIPMENT_PLAN_FIX_H
                      (
                          HISTORY_SEQ
                          ,FIX_ID
                          ,DIVISION_ID
                          ,BIZ_TYPE
                          ,ITEM_ID
                          ,TO_SITE
                          ,FROM_SITE
                          ,PROJECT_CODE
                          ,INCOTERMS
                          ,BOD_ID
                          ,YYYYMMDD
                          ,QTY
                          ,FIX_REASON
                          ,ORIGIN_FROM_DIVISION_ID
                          ,ORIGIN_TO_DIVISION_ID
                          ,ELECTRODE_TYPE
                          ,CREATED_BY
                          ,CREATION_DATE
                          ,LAST_UPDATED_BY
                          ,LAST_UPDATE_DATE
                          --,ATTRIBUTE1
                          --,ATTRIBUTE2
                          --,ATTRIBUTE3
                          --,ATTRIBUTE4
                          --,ATTRIBUTE5
                          --,ATTRIBUTE6
                          --,ATTRIBUTE7
                          --,ATTRIBUTE8
                          --,ATTRIBUTE9
                          --,ATTRIBUTE10
                          ,HISTORY_CREATION_DATE
                    )
                    SELECT NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H
                          ,FIX_ID
                          ,DIVISION_ID
                          ,BIZ_TYPE
                          ,ITEM_ID
                          ,TO_SITE
                          ,FROM_SITE
                          ,PROJECT_CODE
                          ,INCOTERMS
                          ,BOD_ID
                          ,YYYYMMDD
                          ,QTY
                          ,FIX_REASON
                          ,ORIGIN_FROM_DIVISION_ID
                          ,ORIGIN_TO_DIVISION_ID
                          ,ELECTRODE_TYPE
                            ,@p_user_id   AS CREATED_BY
                          ,GETDATE()    AS CREATION_DATE
                          ,@p_user_id   AS LAST_UPDATED_BY
                          ,GETDATE()    AS LAST_UPDATE_DATE
                        --,ATTRIBUTE1
                        --,ATTRIBUTE2
                        --,ATTRIBUTE3
                        --,ATTRIBUTE4
                        --,ATTRIBUTE5
                        --,ATTRIBUTE6
                        --,ATTRIBUTE7
                        --,ATTRIBUTE8
                        --,ATTRIBUTE9
                        --,ATTRIBUTE10
                        ,GETDATE()    AS HISTORY_CREATION_DATE
                   FROM SCP_ANL_SHIPMENT_PLAN_FIX  WITH (NOLOCK)
                  WHERE ATTRIBUTE1 ='Y'


                  -- FIX UPDATE
                   UPDATE X
                    SET X.ATTRIBUTE1 = NULL       -- History 구분을 위해 원상복구
                    FROM SCP_ANL_SHIPMENT_PLAN_FIX  X WITH (NOLOCK)     -- FIX_ID, DIVISION_ID, BIZ_TYPE, ITEM_ID, TO_SITE, FROM_SITE, BOD_ID, YYYYMMDD
                    INNER JOIN #SCP_ANL_SHIPMENT_PLAN_SEMI Y WITH (NOLOCK)
                    ON 0 = 0
                    AND X.DIVISION_ID = Y.DIVISION_ID
                    AND X.BIZ_TYPE    = Y.OPERATION_GROUP
                    AND X.ITEM_ID     = Y.ITEM_ID
                    AND X.TO_SITE     = Y.TO_SITE
                    AND X.FROM_SITE   = Y.FROM_SITE
                    AND X.BOD_ID      = Y.BOD_ID
                    AND X.YYYYMMDD    = Y.YYYYMMDD
                    AND X.ATTRIBUTE1  ='Y'


            END
            
            -------------------------------------------------------------------------------------------------------------         
            -- SCP_ANL_PRODUCTION_PLAN UPDATE
            -- CELL_PROD,PACK_PROD  --> SCP_ANL_PRODUCTION_PLAN.MEASURE 'PROD_PLAN_AMEND' UPDATE
            -------------------------------------------------------------------------------------------------------------  

            IF @p_measure IN  ('PACK_PROD','CELL_PROD')   
              BEGIN 

               IF OBJECT_ID('tempdb..#SCP_ANL_PRODUCTION_PLAN') IS NOT NULL	
	              DROP TABLE #SCP_ANL_PRODUCTION_PLAN

                SELECT X.DIVISION_ID, X.PLAN_START_YYYYMMDD, X.PLAN_TYPE, X.SEQ
                      ,X.OPERATION_GROUP
--                      ,X.CELL_ITEM_ID
                      ,X.FROM_SITE AS SCM_SITE_ID
                      ,X.ITEM_ID
                      ,X.PROD_LINE AS LINE_ID
                      ,ISNULL(X.ATTRIBUTE9,'') AS OPERATION_ID
                      ,'PROD_PLAN_AMEND' AS MEASURE
                      ,Y.YYYYMMDD AS YYYYMMDD
                      ,X.QTY
                      ,X.DIVISION_ID AS ORIGIN_DIVISION_ID
                      ,'' AS ELECTRODE_TYPE
                      ,CELL_QTY_PACK AS CELL_QTY
                      ,Y.YYYYMMDD_COLUMN
                INTO #SCP_ANL_PRODUCTION_PLAN
                FROM
                  (
                  SELECT * --
                   FROM SCP_XLS_PSI_GLOBAL_ESS     WITH (NOLOCK) 
                   WHERE 0 = 0
                    AND DIVISION_ID         = @p_division_id
                    AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
                    AND SEQ                 = @p_seq
                    AND XLS_KEY1            = @p_xls_key1 --43 
                   ) AS SourceTable  
                UNPIVOT 
                    (
                     QTY FOR  YYYYMMDD_COLUMN IN (
                                           [QTY001], [QTY002], [QTY003], [QTY004], [QTY005],[QTY006], [QTY007], [QTY008], [QTY009], [QTY010]
                                          ,[QTY011], [QTY012], [QTY013], [QTY014], [QTY015],[QTY016], [QTY017], [QTY018], [QTY019], [QTY020]
                                          ,[QTY021], [QTY022], [QTY023], [QTY024], [QTY025],[QTY026], [QTY027], [QTY028], [QTY029], [QTY030]
                                          ,[QTY031], [QTY032], [QTY033], [QTY034], [QTY035],[QTY036], [QTY037], [QTY038], [QTY039], [QTY040]
                                          ,[QTY041], [QTY042], [QTY043], [QTY044], [QTY045],[QTY046], [QTY047], [QTY048], [QTY049], [QTY050]
                                          ,[QTY051], [QTY052], [QTY053], [QTY054], [QTY055],[QTY056], [QTY057], [QTY058], [QTY059], [QTY060]
                                          ,[QTY061], [QTY062], [QTY063], [QTY064], [QTY065],[QTY066], [QTY067], [QTY068], [QTY069], [QTY070]
                                          ,[QTY071], [QTY072], [QTY073], [QTY074], [QTY075],[QTY076], [QTY077], [QTY078], [QTY079], [QTY080]
                                          ,[QTY081], [QTY082], [QTY083], [QTY084], [QTY085],[QTY086], [QTY087], [QTY088], [QTY089], [QTY090]
                                          ,[QTY091], [QTY092], [QTY093], [QTY094], [QTY095],[QTY096], [QTY097], [QTY098], [QTY099], [QTY100]

                                          ,[QTY101], [QTY102], [QTY103], [QTY104], [QTY105],[QTY106], [QTY107], [QTY108], [QTY109], [QTY110]
                                          ,[QTY111], [QTY112], [QTY113], [QTY114], [QTY115],[QTY116], [QTY117], [QTY118], [QTY119], [QTY120]
                                          ,[QTY121], [QTY122], [QTY123], [QTY124], [QTY125],[QTY126], [QTY127], [QTY128], [QTY129], [QTY130]
                                          ,[QTY131], [QTY132], [QTY133], [QTY134], [QTY135],[QTY136], [QTY137], [QTY138], [QTY139], [QTY140]
                                          ,[QTY141], [QTY142], [QTY143], [QTY144], [QTY145],[QTY146], [QTY147], [QTY148], [QTY149], [QTY150]
                                          ,[QTY151], [QTY152], [QTY153], [QTY154], [QTY155],[QTY156], [QTY157], [QTY158], [QTY159], [QTY160]
                                          ,[QTY161], [QTY162], [QTY163], [QTY164], [QTY165],[QTY166], [QTY167], [QTY168], [QTY169], [QTY170]
                                          ,[QTY171], [QTY172], [QTY173], [QTY174], [QTY175],[QTY176], [QTY177], [QTY178], [QTY179], [QTY180]
                                          ,[QTY181], [QTY182], [QTY183], [QTY184], [QTY185],[QTY186], [QTY187], [QTY188], [QTY189], [QTY190]
                                          ,[QTY191], [QTY192], [QTY193], [QTY194], [QTY195],[QTY196], [QTY197], [QTY198], [QTY199], [QTY200]

                                          ,[QTY201], [QTY202], [QTY203], [QTY204], [QTY205],[QTY206], [QTY207], [QTY208], [QTY209], [QTY210]
                                          ,[QTY211], [QTY212], [QTY213], [QTY214], [QTY215],[QTY216], [QTY217], [QTY218], [QTY219], [QTY220]
                                          ,[QTY221], [QTY222], [QTY223], [QTY224], [QTY225],[QTY226], [QTY227], [QTY228], [QTY229], [QTY230]
                                          ,[QTY231], [QTY232], [QTY233], [QTY234], [QTY235],[QTY236], [QTY237], [QTY238], [QTY239], [QTY240]
                                          ,[QTY241], [QTY242], [QTY243], [QTY244], [QTY245],[QTY246], [QTY247], [QTY248], [QTY249], [QTY250]
                                          ,[QTY251], [QTY252], [QTY253], [QTY254], [QTY255],[QTY256], [QTY257], [QTY258], [QTY259], [QTY260]
                                          ,[QTY261], [QTY262], [QTY263], [QTY264], [QTY265],[QTY266], [QTY267], [QTY268], [QTY269], [QTY270]
                                          ,[QTY271], [QTY272], [QTY273], [QTY274], [QTY275],[QTY276], [QTY277], [QTY278], [QTY279], [QTY280]
                                          ,[QTY281], [QTY282], [QTY283], [QTY284], [QTY285],[QTY286], [QTY287], [QTY288], [QTY289], [QTY290]
                                          ,[QTY291], [QTY292], [QTY293], [QTY294], [QTY295],[QTY296], [QTY297], [QTY298], [QTY299], [QTY300]

                                          ,[QTY301], [QTY302], [QTY303], [QTY304], [QTY305],[QTY306], [QTY307], [QTY308], [QTY309], [QTY310]
                                          ,[QTY311], [QTY312], [QTY313], [QTY314], [QTY315],[QTY316], [QTY317], [QTY318], [QTY319], [QTY320]
                                          ,[QTY321], [QTY322], [QTY323], [QTY324], [QTY325],[QTY326], [QTY327], [QTY328], [QTY329], [QTY330]
                                          ,[QTY331], [QTY332], [QTY333], [QTY334], [QTY335],[QTY336], [QTY337], [QTY338], [QTY339], [QTY340]
                                          ,[QTY341], [QTY342], [QTY343], [QTY344], [QTY345],[QTY346], [QTY347], [QTY348], [QTY349], [QTY350]
                                          ,[QTY351], [QTY352], [QTY353], [QTY354], [QTY355],[QTY356], [QTY357], [QTY358], [QTY359], [QTY360]
                                          ,[QTY361], [QTY362], [QTY363], [QTY364]

                                          )  
                ) AS X
                INNER JOIN (SELECT A.BASIS_YYYYMMDD AS YYYYMMDD    
                                  ,'QTY' + REPLICATE('0', 3 - LEN(ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD) )) + CONVERT(NVARCHAR,ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD)) AS YYYYMMDD_COLUMN
                              FROM DBO.SCM_SYS_CALENDAR_M A  WITH(NOLOCK)	     
                              WHERE A.BASIS_YYYYMMDD     >= @p_PLAN_START_YYYYMMDD
                                AND A.BASIS_YYYYMMDD     <  @p_to_yyyymmdd
                            ) Y
                ON X.YYYYMMDD_COLUMN = Y.YYYYMMDD_COLUMN
                ;


                
                
            -------------------------------------------------------------------------------------------------------------         
            -- FROZEN 구간 UPDATE
            -- PLANT SITE(SCM_MST_SITE)의 SHIP_FROZEN ,PROD_FROZEN를 주단위로 변경하여 FROZEN 구간을 저장 내역에서 삭제한다.
            -------------------------------------------------------------------------------------------------------------
            IF @p_plan_type IN  ('MA','SE')  
            BEGIN
              DELETE  FROM #SCP_ANL_PRODUCTION_PLAN
                      FROM #SCP_ANL_PRODUCTION_PLAN X
                    INNER JOIN #SCM_MST_SITE Y
                       ON Y.DIVISION_ID = X.DIVISION_ID
                      AND Y.SCM_SITE_ID = X.SCM_SITE_ID
                    WHERE 
                        X.YYYYMMDD < Y.PROD_FROZEN_WEEK_DAY
            END           
            ;
               -- PROD_PLAN_AMEND

                INSERT INTO SCP_ANL_PRODUCTION_PLAN
                                     (DIVISION_ID
                                     ,PLAN_START_YYYYMMDD
                                     ,PLAN_TYPE
                                     ,SEQ
                                     ,OPERATION_GROUP
        --                             ,CELL_ITEM_ID
                                     ,SCM_SITE_ID
                                     ,ITEM_ID
                                     ,LINE_ID
                                     ,OPERATION_ID
                                     ,MEASURE
                                     ,YYYYMMDD
                                     ,QTY
                                     ,ORIGIN_DIVISION_ID
                                     ,ELECTRODE_TYPE
                                     ,CELL_QTY
                                     ,CREATED_BY
                                     ,CREATION_DATE
                                     ,LAST_UPDATED_BY
                                     ,LAST_UPDATE_DATE  
                                     )

                SELECT DIVISION_ID
                      ,PLAN_START_YYYYMMDD
                      ,PLAN_TYPE
                      ,SEQ
                      ,OPERATION_GROUP
        --                             ,CELL_ITEM_ID
                      ,SCM_SITE_ID
                      ,ITEM_ID
                      ,LINE_ID
                      ,ISNULL(OPERATION_ID,'') AS OPERATION_ID
                      ,MEASURE
                      ,YYYYMMDD
                      ,QTY
                      ,ORIGIN_DIVISION_ID
                      ,ELECTRODE_TYPE
                      ,CELL_QTY
                      ,CREATED_BY
                      ,CREATION_DATE
                      ,LAST_UPDATED_BY
                      ,LAST_UPDATE_DATE  
                  FROM  
                  (   
                       MERGE INTO SCP_ANL_PRODUCTION_PLAN AS X  
                        USING (SELECT DIVISION_ID
                                     ,PLAN_START_YYYYMMDD
                                     ,PLAN_TYPE
                                     ,SEQ
                                     ,OPERATION_GROUP
        --                             ,CELL_ITEM_ID
                                     ,SCM_SITE_ID
                                     ,ITEM_ID
                                     ,LINE_ID
                                     ,OPERATION_ID
                                     ,MEASURE
                                     ,YYYYMMDD
                                     ,QTY
                                     ,ORIGIN_DIVISION_ID
                                     ,ELECTRODE_TYPE
                                     ,CELL_QTY
                                FROM #SCP_ANL_PRODUCTION_PLAN
                               --WHERE QTY > 0 
                              ) AS Y
                        ON 0 = 0
                        AND X.DIVISION_ID         = @p_division_id
                        AND X.PLAN_START_YYYYMMDD = @p_PLAN_START_YYYYMMDD
                        AND X.PLAN_TYPE           = @p_PLAN_TYPE
                        AND X.SEQ                 = @p_SEQ
                
                        AND X.OPERATION_GROUP     = Y.OPERATION_GROUP
                        AND X.SCM_SITE_ID         = Y.SCM_SITE_ID
                        AND X.ITEM_ID             = Y.ITEM_ID
                        AND X.MEASURE             = Y.MEASURE
                        AND X.YYYYMMDD            = Y.YYYYMMDD
                        AND X.LINE_ID             = Y.LINE_ID
                        AND X.OPERATION_ID        = Y.OPERATION_ID
                        AND X.ORIGIN_DIVISION_ID  = Y.ORIGIN_DIVISION_ID
                        AND X.ELECTRODE_TYPE      = Y.ELECTRODE_TYPE

                

                        WHEN MATCHED  THEN 
                        UPDATE 
                          SET  X.QTY = Y.QTY
                              --,X.CREATED_BY         = @p_USER_ID
                              --,X.CREATION_DATE      = GETDATE()
                              ,X.LAST_UPDATED_BY    = @p_USER_ID
                              ,X.LAST_UPDATE_DATE   = GETDATE()

                        WHEN NOT MATCHED THEN  
                          INSERT (
                                     DIVISION_ID
                                     ,PLAN_START_YYYYMMDD
                                     ,PLAN_TYPE
                                     ,SEQ
                                     ,OPERATION_GROUP
        --                             ,CELL_ITEM_ID
                                     ,SCM_SITE_ID
                                     ,ITEM_ID
                                     ,LINE_ID
                                     ,OPERATION_ID
                                     ,MEASURE
                                     ,YYYYMMDD
                                     ,QTY
                                     ,ORIGIN_DIVISION_ID
                                     ,ELECTRODE_TYPE
                                     ,CELL_QTY
                                    ,CREATED_BY
                                    ,CREATION_DATE
                                    ,LAST_UPDATED_BY
                                    ,LAST_UPDATE_DATE
                                )
                         VALUES (
                                   Y.DIVISION_ID
                                   ,Y.PLAN_START_YYYYMMDD
                                   ,Y.PLAN_TYPE
                                   ,Y.SEQ
                                   ,Y.OPERATION_GROUP
        --                         ,Y.CELL_ITEM_ID
                                   ,Y.SCM_SITE_ID
                                   ,Y.ITEM_ID
                                   ,Y.LINE_ID
                                   ,ISNULL(Y.OPERATION_ID,'') 
                                   ,Y.MEASURE
                                   ,Y.YYYYMMDD
                                   ,Y.QTY
                                   ,Y.ORIGIN_DIVISION_ID
                                   ,Y.ELECTRODE_TYPE
                                   ,Y.CELL_QTY
                                  ,@p_USER_ID
                                  ,GETDATE()
                                  ,@p_USER_ID
                                  ,GETDATE()
                                )

                     -- INSERT 일경우 PROD_PLAN_ENGINE/PROD_PLAN_AMEND 쌍으로 입력한다.
                      OUTPUT $action, Inserted.DIVISION_ID
                                     ,Inserted.PLAN_START_YYYYMMDD
                                     ,Inserted.PLAN_TYPE
                                     ,Inserted.SEQ
                                     ,Inserted.OPERATION_GROUP
          --                         ,Inserted.CELL_ITEM_ID
                                     ,Inserted.SCM_SITE_ID
                                     ,Inserted.ITEM_ID
                                     ,Inserted.LINE_ID
                                     ,Inserted.OPERATION_ID
                                     ,'PROD_PLAN_ENGINE' AS MEASURE
                                     ,Inserted.YYYYMMDD
                                     ,0  AS QTY
                                     ,Inserted.ORIGIN_DIVISION_ID
                                     ,Inserted.ELECTRODE_TYPE
                                     ,Inserted.CELL_QTY
                                     ,@p_USER_ID AS CREATED_BY
                                     ,GETDATE() AS CREATION_DATE
                                     ,@p_USER_ID AS LAST_UPDATED_BY
                                     ,GETDATE() AS LAST_UPDATE_DATE                             
                        )

                        AS Changes ( Action
                                    ,DIVISION_ID
                                    ,PLAN_START_YYYYMMDD
                                    ,PLAN_TYPE
                                    ,SEQ
                                    ,OPERATION_GROUP
                      --                             ,CELL_ITEM_ID
                                    ,SCM_SITE_ID
                                    ,ITEM_ID
                                    ,LINE_ID
                                    ,OPERATION_ID
                                    ,MEASURE
                                    ,YYYYMMDD
                                    ,QTY
                                    ,ORIGIN_DIVISION_ID
                                    ,ELECTRODE_TYPE
                                    ,CELL_QTY
                                    ,CREATED_BY
                                    ,CREATION_DATE
                                    ,LAST_UPDATED_BY
                                    ,LAST_UPDATE_DATE
                                    ) 
                        WHERE Action = 'INSERT' 
                                ;

            -------------------------------------------------------------------------------------------------------------         
            -- SCP_ANL_PRODUCTION_PLAN_H : History 입력
            -------------------------------------------------------------------------------------------------------------         
            -- SELECT top 10 * FROM dbo.SCP_ANL_PRODUCTION_PLAN_H WITH (NOLOCK)     -- HISTORY_SEQ
            -------------------------------------------------------------------------------------------------------------   
--                      SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_H

                      INSERT INTO dbo.SCP_ANL_PRODUCTION_PLAN_H
                      (
                        HISTORY_SEQ
                        ,DIVISION_ID
                        ,PLAN_START_YYYYMMDD
                        ,PLAN_TYPE
                        ,SEQ
                        ,OPERATION_GROUP
                        ,SCM_SITE_ID
                        ,ITEM_ID
                        ,LINE_ID
                        ,OPERATION_ID
                        ,MEASURE
                        ,YYYYMMDD
                        ,QTY
                        ,ORIGIN_DIVISION_ID
                        ,ELECTRODE_TYPE
                        ,CREATED_BY
                        ,CREATION_DATE
                        ,LAST_UPDATED_BY
                        ,LAST_UPDATE_DATE
                        --,ATTRIBUTE1
                        --,ATTRIBUTE2
                        --,ATTRIBUTE3
                        --,ATTRIBUTE4
                        --,ATTRIBUTE5
                        --,ATTRIBUTE6
                        --,ATTRIBUTE7
                        --,ATTRIBUTE8
                        --,ATTRIBUTE9
                        --,ATTRIBUTE10
                        ,HISTORY_CREATION_DATE
                      )
                      SELECT 
                        NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_H
                        ,DIVISION_ID
                        ,PLAN_START_YYYYMMDD
                        ,PLAN_TYPE
                        ,SEQ
                        ,OPERATION_GROUP
                        ,SCM_SITE_ID
                        ,ITEM_ID
                        ,LINE_ID
                        ,OPERATION_ID
                        ,MEASURE
                        ,YYYYMMDD
                        ,QTY
                        ,ORIGIN_DIVISION_ID
                        ,ELECTRODE_TYPE
                        ,@p_user_id   AS CREATED_BY
                        ,GETDATE()    AS CREATION_DATE
                        ,@p_user_id   AS LAST_UPDATED_BY
                        ,GETDATE()    AS LAST_UPDATE_DATE
                        --,ATTRIBUTE1
                        --,ATTRIBUTE2
                        --,ATTRIBUTE3
                        --,ATTRIBUTE4
                        --,ATTRIBUTE5
                        --,ATTRIBUTE6
                        --,ATTRIBUTE7
                        --,ATTRIBUTE8
                        --,ATTRIBUTE9
                        --,ATTRIBUTE10
                        ,GETDATE() AS HISTORY_CREATION_DATE
                       FROM #SCP_ANL_PRODUCTION_PLAN  WITH (NOLOCK)


            -------------------------------------------------------------------------------------------------------------         
            -- SCP_ANL_PRODUCTION_PLAN_FIX : FIX 입력
            -------------------------------------------------------------------------------------------------------------  
                      UPDATE X
                        SET  X.QTY              = Y.QTY
                            ,X.ATTRIBUTE1       ='Y'
                            ,X.FIX_REASON    = 'SIMULATION UPDATE'
                            ,X.LAST_UPDATED_BY  = @p_user_id
                            ,X.LAST_UPDATE_DATE = GETDATE()
                        FROM SCP_ANL_PRODUCTION_PLAN_FIX  X WITH (NOLOCK)     -- FIX_ID, DIVISION_ID, OPERATION_GROUP, SCM_SITE_ID, ITEM_ID, LINE_ID, OPERATION_ID, YYYYMMDD
                        INNER JOIN #SCP_ANL_PRODUCTION_PLAN Y WITH (NOLOCK)
                        ON 0 = 0
                        AND X.DIVISION_ID       = Y.DIVISION_ID
                        AND X.OPERATION_GROUP   = Y.OPERATION_GROUP
                        AND X.SCM_SITE_ID       = Y.SCM_SITE_ID
                        AND X.ITEM_ID           = Y.ITEM_ID
                        AND X.LINE_ID           = Y.LINE_ID
                        AND X.OPERATION_ID      = Y.OPERATION_ID
                        AND X.YYYYMMDD          = Y.YYYYMMDD

            -------------------------------------------------------------------------------------------------------------         
            -- SCP_ANL_PRODUCTION_PLAN_FIX : FIX History 입력
            -------------------------------------------------------------------------------------------------------------         

--                       SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H 
                       --SELECT NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H

                      INSERT INTO dbo.SCP_ANL_PRODUCTION_PLAN_FIX_H
                      (
                          HISTORY_SEQ
                          ,FIX_ID
                          ,DIVISION_ID
                          ,OPERATION_GROUP
                          ,SCM_SITE_ID
                          ,ITEM_ID
                          ,LINE_ID
                          ,OPERATION_ID
                          ,YYYYMMDD
                          ,QTY
                          ,FIX_REASON
                          ,ORIGIN_DIVISION_ID
                          ,ELECTRODE_TYPE
                          ,CREATED_BY
                          ,CREATION_DATE
                          ,LAST_UPDATED_BY
                          ,LAST_UPDATE_DATE
                          --,ATTRIBUTE1
                          --,ATTRIBUTE2
                          --,ATTRIBUTE3
                          --,ATTRIBUTE4
                          --,ATTRIBUTE5
                          --,ATTRIBUTE6
                          --,ATTRIBUTE7
                          --,ATTRIBUTE8
                          --,ATTRIBUTE9
                          --,ATTRIBUTE10
                          ,HISTORY_CREATION_DATE
                    )

                    SELECT NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H
                          ,FIX_ID
                          ,DIVISION_ID
                          ,OPERATION_GROUP
                          ,SCM_SITE_ID
                          ,ITEM_ID
                          ,LINE_ID
                          ,OPERATION_ID
                          ,YYYYMMDD
                          ,QTY
                          ,FIX_REASON
                          ,ORIGIN_DIVISION_ID
                          ,ELECTRODE_TYPE
                          ,@p_user_id   AS CREATED_BY
                          ,GETDATE()    AS CREATION_DATE
                          ,@p_user_id   AS LAST_UPDATED_BY
                          ,GETDATE()    AS LAST_UPDATE_DATE
                        --,ATTRIBUTE1
                        --,ATTRIBUTE2
                        --,ATTRIBUTE3
                        --,ATTRIBUTE4
                        --,ATTRIBUTE5
                        --,ATTRIBUTE6
                        --,ATTRIBUTE7
                        --,ATTRIBUTE8
                        --,ATTRIBUTE9
                        --,ATTRIBUTE10
                        ,GETDATE()    AS HISTORY_CREATION_DATE
                   FROM SCP_ANL_PRODUCTION_PLAN_FIX  WITH (NOLOCK)
                  WHERE ATTRIBUTE1 = 'Y'


              UPDATE X
                    SET X.ATTRIBUTE1 = NULL       -- History 구분을 위해 원상복구
                    FROM SCP_ANL_PRODUCTION_PLAN_FIX  X WITH (NOLOCK)     -- FIX_ID, DIVISION_ID, OPERATION_GROUP, SCM_SITE_ID, ITEM_ID, LINE_ID, OPERATION_ID, YYYYMMDD
                    INNER JOIN #SCP_ANL_PRODUCTION_PLAN Y WITH (NOLOCK)
                    ON 0 = 0
                    AND X.DIVISION_ID     = Y.DIVISION_ID
                    AND X.OPERATION_GROUP = Y.OPERATION_GROUP
                    AND X.SCM_SITE_ID     = Y.SCM_SITE_ID
                    AND X.ITEM_ID         = Y.ITEM_ID
                    AND X.LINE_ID         = Y.LINE_ID
                    AND X.OPERATION_ID    = Y.OPERATION_ID
                    AND X.YYYYMMDD        = Y.YYYYMMDD
                    AND X.ATTRIBUTE1      =N'Y'

             
            END

            

            

              -----------------------------------------------------------
              -- FROZEN 구간 복구              
              -----------------------------------------------------------
              
               -------------------------------------------------------------------------------------------------------------         
                  -- 전체 임시 테이블 생성  (#SCP_XLS_PSI_GLOBAL_ESS_MODIFY)
                  -------------------------------------------------------------------------------------------------------------  
                      IF OBJECT_ID('tempdb..#SCP_XLS_PSI_GLOBAL_ESS_MODIFY') IS NOT NULL	
	                        DROP TABLE #SCP_XLS_PSI_GLOBAL_ESS_MODIFY

                    --DROP TABLE #SCP_XLS_PSI_GLOBAL_ESS_MODIFY
                    CREATE TABLE #SCP_XLS_PSI_GLOBAL_ESS_MODIFY(
	                    XLS_KEY1              NVARCHAR(200)     NULL,
                      QTY001  NUMERIC (20,10) NULL, QTY002  NUMERIC (20,10) NULL, QTY003  NUMERIC (20,10) NULL, QTY004 NUMERIC (20,10) NULL,  QTY005  NUMERIC (20,10) NULL, -- 신규
	                    QTY006  NUMERIC (20,10) NULL,	QTY007  NUMERIC (20,10) NULL, QTY008  NUMERIC (20,10) NULL, QTY009 NUMERIC (20,10) NULL,  QTY010  NUMERIC (20,10) NULL,
	                    QTY011  NUMERIC (20,10) NULL, QTY012  NUMERIC (20,10) NULL, QTY013  NUMERIC (20,10) NULL, QTY014 NUMERIC (20,10) NULL,  QTY015  NUMERIC (20,10) NULL,
	                    QTY016  NUMERIC (20,10) NULL,	QTY017  NUMERIC (20,10) NULL, QTY018  NUMERIC (20,10) NULL, QTY019 NUMERIC (20,10) NULL,  QTY020  NUMERIC (20,10) NULL,
                      QTY021  NUMERIC (20,10) NULL, QTY022  NUMERIC (20,10) NULL, QTY023  NUMERIC (20,10) NULL, QTY024 NUMERIC (20,10) NULL,  QTY025  NUMERIC (20,10) NULL,
	                    QTY026  NUMERIC (20,10) NULL,	QTY027  NUMERIC (20,10) NULL, QTY028  NUMERIC (20,10) NULL, QTY029 NUMERIC (20,10) NULL,  QTY030  NUMERIC (20,10) NULL,
                      QTY031  NUMERIC (20,10) NULL, QTY032  NUMERIC (20,10) NULL, QTY033  NUMERIC (20,10) NULL, QTY034 NUMERIC (20,10) NULL,  QTY035  NUMERIC (20,10) NULL,
	                    QTY036  NUMERIC (20,10) NULL,	QTY037  NUMERIC (20,10) NULL, QTY038  NUMERIC (20,10) NULL, QTY039 NUMERIC (20,10) NULL,  QTY040  NUMERIC (20,10) NULL,
                      QTY041  NUMERIC (20,10) NULL, QTY042  NUMERIC (20,10) NULL, QTY043  NUMERIC (20,10) NULL, QTY044 NUMERIC (20,10) NULL,  QTY045  NUMERIC (20,10) NULL,
	                    QTY046  NUMERIC (20,10) NULL,	QTY047  NUMERIC (20,10) NULL, QTY048  NUMERIC (20,10) NULL, QTY049 NUMERIC (20,10) NULL,  QTY050  NUMERIC (20,10) NULL,

                      QTY051  NUMERIC (20,10) NULL, QTY052  NUMERIC (20,10) NULL, QTY053  NUMERIC (20,10) NULL, QTY054 NUMERIC (20,10) NULL,  QTY055  NUMERIC (20,10) NULL,
	                    QTY056  NUMERIC (20,10) NULL,	QTY057  NUMERIC (20,10) NULL, QTY058  NUMERIC (20,10) NULL, QTY059 NUMERIC (20,10) NULL,  QTY060  NUMERIC (20,10) NULL,
                      QTY061  NUMERIC (20,10) NULL, QTY062  NUMERIC (20,10) NULL, QTY063  NUMERIC (20,10) NULL, QTY064 NUMERIC (20,10) NULL,  QTY065  NUMERIC (20,10) NULL,
	                    QTY066  NUMERIC (20,10) NULL,	QTY067  NUMERIC (20,10) NULL, QTY068  NUMERIC (20,10) NULL, QTY069 NUMERIC (20,10) NULL,  QTY070  NUMERIC (20,10) NULL,
                      QTY071  NUMERIC (20,10) NULL, QTY072  NUMERIC (20,10) NULL, QTY073  NUMERIC (20,10) NULL, QTY074 NUMERIC (20,10) NULL,  QTY075  NUMERIC (20,10) NULL,
	                    QTY076  NUMERIC (20,10) NULL,	QTY077  NUMERIC (20,10) NULL, QTY078  NUMERIC (20,10) NULL, QTY079 NUMERIC (20,10) NULL,  QTY080  NUMERIC (20,10) NULL,
                      QTY081  NUMERIC (20,10) NULL, QTY082  NUMERIC (20,10) NULL, QTY083  NUMERIC (20,10) NULL, QTY084 NUMERIC (20,10) NULL,  QTY085  NUMERIC (20,10) NULL,
	                    QTY086  NUMERIC (20,10) NULL,	QTY087  NUMERIC (20,10) NULL, QTY088  NUMERIC (20,10) NULL, QTY089 NUMERIC (20,10) NULL,  QTY090  NUMERIC (20,10) NULL,
                      QTY091  NUMERIC (20,10) NULL, QTY092  NUMERIC (20,10) NULL, QTY093  NUMERIC (20,10) NULL, QTY094 NUMERIC (20,10) NULL,  QTY095  NUMERIC (20,10) NULL,
	                    QTY096  NUMERIC (20,10) NULL,	QTY097  NUMERIC (20,10) NULL, QTY098  NUMERIC (20,10) NULL, QTY099 NUMERIC (20,10) NULL,  QTY100  NUMERIC (20,10) NULL,

                      QTY101  NUMERIC (20,10) NULL, QTY102  NUMERIC (20,10) NULL, QTY103  NUMERIC (20,10) NULL, QTY104 NUMERIC (20,10) NULL,  QTY105  NUMERIC (20,10) NULL,
	                    QTY106  NUMERIC (20,10) NULL,	QTY107  NUMERIC (20,10) NULL, QTY108  NUMERIC (20,10) NULL, QTY109 NUMERIC (20,10) NULL,  QTY110  NUMERIC (20,10) NULL,
	                    QTY111  NUMERIC (20,10) NULL, QTY112  NUMERIC (20,10) NULL, QTY113  NUMERIC (20,10) NULL, QTY114 NUMERIC (20,10) NULL,  QTY115  NUMERIC (20,10) NULL,
	                    QTY116  NUMERIC (20,10) NULL,	QTY117  NUMERIC (20,10) NULL, QTY118  NUMERIC (20,10) NULL, QTY119 NUMERIC (20,10) NULL,  QTY120  NUMERIC (20,10) NULL,
                      QTY121  NUMERIC (20,10) NULL, QTY122  NUMERIC (20,10) NULL, QTY123  NUMERIC (20,10) NULL, QTY124 NUMERIC (20,10) NULL,  QTY125  NUMERIC (20,10) NULL,
	                    QTY126  NUMERIC (20,10) NULL,	QTY127  NUMERIC (20,10) NULL, QTY128  NUMERIC (20,10) NULL, QTY129 NUMERIC (20,10) NULL,  QTY130  NUMERIC (20,10) NULL,
                      QTY131  NUMERIC (20,10) NULL, QTY132  NUMERIC (20,10) NULL, QTY133  NUMERIC (20,10) NULL, QTY134 NUMERIC (20,10) NULL,  QTY135  NUMERIC (20,10) NULL,
	                    QTY136  NUMERIC (20,10) NULL,	QTY137  NUMERIC (20,10) NULL, QTY138  NUMERIC (20,10) NULL, QTY139 NUMERIC (20,10) NULL,  QTY140  NUMERIC (20,10) NULL,
                      QTY141  NUMERIC (20,10) NULL, QTY142  NUMERIC (20,10) NULL, QTY143  NUMERIC (20,10) NULL, QTY144 NUMERIC (20,10) NULL,  QTY145  NUMERIC (20,10) NULL,
	                    QTY146  NUMERIC (20,10) NULL,	QTY147  NUMERIC (20,10) NULL, QTY148  NUMERIC (20,10) NULL, QTY149 NUMERIC (20,10) NULL,  QTY150  NUMERIC (20,10) NULL,

                      QTY151  NUMERIC (20,10) NULL, QTY152  NUMERIC (20,10) NULL, QTY153  NUMERIC (20,10) NULL, QTY154 NUMERIC (20,10) NULL,  QTY155  NUMERIC (20,10) NULL,
	                    QTY156  NUMERIC (20,10) NULL,	QTY157  NUMERIC (20,10) NULL, QTY158  NUMERIC (20,10) NULL, QTY159 NUMERIC (20,10) NULL,  QTY160  NUMERIC (20,10) NULL,
                      QTY161  NUMERIC (20,10) NULL, QTY162  NUMERIC (20,10) NULL, QTY163  NUMERIC (20,10) NULL, QTY164 NUMERIC (20,10) NULL,  QTY165  NUMERIC (20,10) NULL,
	                    QTY166  NUMERIC (20,10) NULL,	QTY167  NUMERIC (20,10) NULL, QTY168  NUMERIC (20,10) NULL, QTY169 NUMERIC (20,10) NULL,  QTY170  NUMERIC (20,10) NULL,
                      QTY171  NUMERIC (20,10) NULL, QTY172  NUMERIC (20,10) NULL, QTY173  NUMERIC (20,10) NULL, QTY174 NUMERIC (20,10) NULL,  QTY175  NUMERIC (20,10) NULL,
	                    QTY176  NUMERIC (20,10) NULL,	QTY177  NUMERIC (20,10) NULL, QTY178  NUMERIC (20,10) NULL, QTY179 NUMERIC (20,10) NULL,  QTY180  NUMERIC (20,10) NULL,
                      QTY181  NUMERIC (20,10) NULL, QTY182  NUMERIC (20,10) NULL, QTY183  NUMERIC (20,10) NULL, QTY184 NUMERIC (20,10) NULL,  QTY185  NUMERIC (20,10) NULL,
	                    QTY186  NUMERIC (20,10) NULL,	QTY187  NUMERIC (20,10) NULL, QTY188  NUMERIC (20,10) NULL, QTY189 NUMERIC (20,10) NULL,  QTY190  NUMERIC (20,10) NULL,
                      QTY191  NUMERIC (20,10) NULL, QTY192  NUMERIC (20,10) NULL, QTY193  NUMERIC (20,10) NULL, QTY194 NUMERIC (20,10) NULL,  QTY195  NUMERIC (20,10) NULL,
	                    QTY196  NUMERIC (20,10) NULL,	QTY197  NUMERIC (20,10) NULL, QTY198  NUMERIC (20,10) NULL, QTY199 NUMERIC (20,10) NULL,  QTY200  NUMERIC (20,10) NULL,

                      QTY201  NUMERIC (20,10) NULL, QTY202  NUMERIC (20,10) NULL, QTY203  NUMERIC (20,10) NULL, QTY204 NUMERIC (20,10) NULL,  QTY205  NUMERIC (20,10) NULL,
	                    QTY206  NUMERIC (20,10) NULL,	QTY207  NUMERIC (20,10) NULL, QTY208  NUMERIC (20,10) NULL, QTY209 NUMERIC (20,10) NULL,  QTY210  NUMERIC (20,10) NULL,
	                    QTY211  NUMERIC (20,10) NULL, QTY212  NUMERIC (20,10) NULL, QTY213  NUMERIC (20,10) NULL, QTY214 NUMERIC (20,10) NULL,  QTY215  NUMERIC (20,10) NULL,
	                    QTY216  NUMERIC (20,10) NULL,	QTY217  NUMERIC (20,10) NULL, QTY218  NUMERIC (20,10) NULL, QTY219 NUMERIC (20,10) NULL,  QTY220  NUMERIC (20,10) NULL,
                      QTY221  NUMERIC (20,10) NULL, QTY222  NUMERIC (20,10) NULL, QTY223  NUMERIC (20,10) NULL, QTY224 NUMERIC (20,10) NULL,  QTY225  NUMERIC (20,10) NULL,
	                    QTY226  NUMERIC (20,10) NULL,	QTY227  NUMERIC (20,10) NULL, QTY228  NUMERIC (20,10) NULL, QTY229 NUMERIC (20,10) NULL,  QTY230  NUMERIC (20,10) NULL,
                      QTY231  NUMERIC (20,10) NULL, QTY232  NUMERIC (20,10) NULL, QTY233  NUMERIC (20,10) NULL, QTY234 NUMERIC (20,10) NULL,  QTY235  NUMERIC (20,10) NULL,
	                    QTY236  NUMERIC (20,10) NULL,	QTY237  NUMERIC (20,10) NULL, QTY238  NUMERIC (20,10) NULL, QTY239 NUMERIC (20,10) NULL,  QTY240  NUMERIC (20,10) NULL,
                      QTY241  NUMERIC (20,10) NULL, QTY242  NUMERIC (20,10) NULL, QTY243  NUMERIC (20,10) NULL, QTY244 NUMERIC (20,10) NULL,  QTY245  NUMERIC (20,10) NULL,
	                    QTY246  NUMERIC (20,10) NULL,	QTY247  NUMERIC (20,10) NULL, QTY248  NUMERIC (20,10) NULL, QTY249 NUMERIC (20,10) NULL,  QTY250  NUMERIC (20,10) NULL,

                      QTY251  NUMERIC (20,10) NULL, QTY252  NUMERIC (20,10) NULL, QTY253  NUMERIC (20,10) NULL, QTY254 NUMERIC (20,10) NULL,  QTY255  NUMERIC (20,10) NULL,
	                    QTY256  NUMERIC (20,10) NULL,	QTY257  NUMERIC (20,10) NULL, QTY258  NUMERIC (20,10) NULL, QTY259 NUMERIC (20,10) NULL,  QTY260  NUMERIC (20,10) NULL,
                      QTY261  NUMERIC (20,10) NULL, QTY262  NUMERIC (20,10) NULL, QTY263  NUMERIC (20,10) NULL, QTY264 NUMERIC (20,10) NULL,  QTY265  NUMERIC (20,10) NULL,
	                    QTY266  NUMERIC (20,10) NULL,	QTY267  NUMERIC (20,10) NULL, QTY268  NUMERIC (20,10) NULL, QTY269 NUMERIC (20,10) NULL,  QTY270  NUMERIC (20,10) NULL,
                      QTY271  NUMERIC (20,10) NULL, QTY272  NUMERIC (20,10) NULL, QTY273  NUMERIC (20,10) NULL, QTY274 NUMERIC (20,10) NULL,  QTY275  NUMERIC (20,10) NULL,
	                    QTY276  NUMERIC (20,10) NULL,	QTY277  NUMERIC (20,10) NULL, QTY278  NUMERIC (20,10) NULL, QTY279 NUMERIC (20,10) NULL,  QTY280  NUMERIC (20,10) NULL,
                      QTY281  NUMERIC (20,10) NULL, QTY282  NUMERIC (20,10) NULL, QTY283  NUMERIC (20,10) NULL, QTY284 NUMERIC (20,10) NULL,  QTY285  NUMERIC (20,10) NULL,
	                    QTY286  NUMERIC (20,10) NULL,	QTY287  NUMERIC (20,10) NULL, QTY288  NUMERIC (20,10) NULL, QTY289 NUMERIC (20,10) NULL,  QTY290  NUMERIC (20,10) NULL,
                      QTY291  NUMERIC (20,10) NULL, QTY292  NUMERIC (20,10) NULL, QTY293  NUMERIC (20,10) NULL, QTY294 NUMERIC (20,10) NULL,  QTY295  NUMERIC (20,10) NULL,
	                    QTY296  NUMERIC (20,10) NULL,	QTY297  NUMERIC (20,10) NULL, QTY298  NUMERIC (20,10) NULL, QTY299 NUMERIC (20,10) NULL,  QTY300  NUMERIC (20,10) NULL,

                      QTY301  NUMERIC (20,10) NULL, QTY302  NUMERIC (20,10) NULL, QTY303  NUMERIC (20,10) NULL, QTY304 NUMERIC (20,10) NULL,  QTY305  NUMERIC (20,10) NULL,
	                    QTY306  NUMERIC (20,10) NULL,	QTY307  NUMERIC (20,10) NULL, QTY308  NUMERIC (20,10) NULL, QTY309 NUMERIC (20,10) NULL,  QTY310  NUMERIC (20,10) NULL,
	                    QTY311  NUMERIC (20,10) NULL, QTY312  NUMERIC (20,10) NULL, QTY313  NUMERIC (20,10) NULL, QTY314 NUMERIC (20,10) NULL,  QTY315  NUMERIC (20,10) NULL,
	                    QTY316  NUMERIC (20,10) NULL,	QTY317  NUMERIC (20,10) NULL, QTY318  NUMERIC (20,10) NULL, QTY319 NUMERIC (20,10) NULL,  QTY320  NUMERIC (20,10) NULL,
                      QTY321  NUMERIC (20,10) NULL, QTY322  NUMERIC (20,10) NULL, QTY323  NUMERIC (20,10) NULL, QTY324 NUMERIC (20,10) NULL,  QTY325  NUMERIC (20,10) NULL,
	                    QTY326  NUMERIC (20,10) NULL,	QTY327  NUMERIC (20,10) NULL, QTY328  NUMERIC (20,10) NULL, QTY329 NUMERIC (20,10) NULL,  QTY330  NUMERIC (20,10) NULL,
                      QTY331  NUMERIC (20,10) NULL, QTY332  NUMERIC (20,10) NULL, QTY333  NUMERIC (20,10) NULL, QTY334 NUMERIC (20,10) NULL,  QTY335  NUMERIC (20,10) NULL,
	                    QTY336  NUMERIC (20,10) NULL,	QTY337  NUMERIC (20,10) NULL, QTY338  NUMERIC (20,10) NULL, QTY339 NUMERIC (20,10) NULL,  QTY340  NUMERIC (20,10) NULL,
                      QTY341  NUMERIC (20,10) NULL, QTY342  NUMERIC (20,10) NULL, QTY343  NUMERIC (20,10) NULL, QTY344 NUMERIC (20,10) NULL,  QTY345  NUMERIC (20,10) NULL,
	                    QTY346  NUMERIC (20,10) NULL,	QTY347  NUMERIC (20,10) NULL, QTY348  NUMERIC (20,10) NULL, QTY349 NUMERIC (20,10) NULL,  QTY350  NUMERIC (20,10) NULL,

                      QTY351  NUMERIC (20,10) NULL, QTY352  NUMERIC (20,10) NULL, QTY353  NUMERIC (20,10) NULL, QTY354 NUMERIC (20,10) NULL,  QTY355  NUMERIC (20,10) NULL,
	                    QTY356  NUMERIC (20,10) NULL,	QTY357  NUMERIC (20,10) NULL, QTY358  NUMERIC (20,10) NULL, QTY359 NUMERIC (20,10) NULL,  QTY360  NUMERIC (20,10) NULL,
                      QTY361  NUMERIC (20,10) NULL, QTY362  NUMERIC (20,10) NULL, QTY363  NUMERIC (20,10) NULL, QTY364 NUMERIC (20,10) NULL,
                    ) 

                    

                    DECLARE @X_ITEM_ID         NVARCHAR(50) = ''

                    -- SCP_ANL_SHIPMENT_PLAN_FG/SEMI PK Parameter 
                    DECLARE @X_OPERATION_GROUP NVARCHAR(50) = ''   -- BIZ_TYPE
                    DECLARE @X_PROJECT_CODE    NVARCHAR(50) = ''
                    DECLARE @X_TO_SITE         NVARCHAR(50) = ''
                    DECLARE @X_INCOTERMS       NVARCHAR(50) = ''
                    DECLARE @X_FROM_SITE       NVARCHAR(50) = ''   -- SCM_SITE_ID
                    DECLARE @X_BOD_ID          NVARCHAR(50) = ''

                    -- SCP_ANL_PRODUCTION_PLAN PK Parameter 
                    DECLARE @X_LINE_ID         NVARCHAR(50) = ''
                    DECLARE @X_OPERATION_ID    NVARCHAR(50) = ''


                    SELECT @X_OPERATION_GROUP  = OPERATION_GROUP
                          ,@X_ITEM_ID          = ITEM_ID
                          ,@X_LINE_ID          = PROD_LINE
                          ,@X_OPERATION_ID     = ATTRIBUTE9 
                          ,@X_PROJECT_CODE     = PROJECT_CODE
                          ,@X_TO_SITE          = TO_SITE
                          ,@X_INCOTERMS        = INCOTERMS
                          ,@X_FROM_SITE        = FROM_SITE
                          ,@X_BOD_ID           = BOD_ID
                    FROM SCP_XLS_PSI_GLOBAL_ESS  WITH (NOLOCK)
                    WHERE XLS_KEY1 = @p_xls_key1

                    
              IF @p_measure <> 'CELL_CHAR_PLAN'
              BEGIN
                  -------------------------------------------------------------------------------------------------------------         
                  -- 저장후 시물레이션 데이터 UPDATE
                  -------------------------------------------------------------------------------------------------------------
                  
                    DECLARE @mQry_sum2 NVARCHAR(MAX);      
   
		                SET     @mQry_sum2 = '';
		                SELECT  @mQry_sum2 = @mQry_sum2+','+       
			                CASE  
                            WHEN 1 = 1 THEN  ' SUM(CASE WHEN YYYYMMDD = '''+YYYYMMDD+'''    THEN QTY ELSE 0 END ) AS ' + 'QTY' + REPLICATE('0', 3 - LEN(ROW_NUMBER() OVER(ORDER BY YYYYMMDD) )) + CONVERT(NVARCHAR,ROW_NUMBER() OVER(ORDER BY YYYYMMDD))        
			                END +''+CHAR(10)      
		                FROM (       
			                SELECT A.BASIS_YYYYMMDD                    AS YYYYMMDD    
                            , A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 31) AS SORT_ORDER_NO      
  	  	                FROM DBO.SCM_SYS_CALENDAR_M A  WITH(NOLOCK)	     
	 		                 WHERE A.BASIS_YYYYMMDD     >= @p_plan_start_yyyymmdd 
                         AND A.BASIS_YYYYMMDD     <  @p_to_yyyymmdd     
			                 GROUP BY A.BASIS_YYYYMMDD       
		                ) AS A      
		                ORDER BY SORT_ORDER_NO  ;      

                    
                    DECLARE @mEXEC2 NVARCHAR(MAX);

		                SET @mEXEC2 = '';
                    SET @mEXEC2 = @mEXEC2 + ' INSERT INTO #SCP_XLS_PSI_GLOBAL_ESS_MODIFY WITH (TABLOCK)  '+CHAR(10);	

                    
                    ------------------------------------------------------------------------------------------------------------- 
                    -- 'SHIP_PLAN'
                    -- PK : DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, YYYYMMDD, BIZ_TYPE, ITEM_ID, PROJECT_CODE, TO_SITE, INCOTERMS, FROM_SITE, BOD_ID, MEASURE
                    ------------------------------------------------------------------------------------------------------------- 
                    DECLARE @mFG NVARCHAR(MAX) = '';

		                SET @mFG = @mFG + ' SELECT  '''+ @p_xls_key1  +''' AS XLS_KEY1  '+CHAR(10);	

		                SET @mFG = @mFG + ' 				' + @mQry_sum2 +'									      '+CHAR(10);	
  	                SET @mFG = @mFG + ' 		FROM SCP_ANL_SHIPMENT_PLAN_FG WITH (NOLOCK)  '+CHAR(10);	
                    SET @mFG = @mFG + ' 		WHERE 0 = 0                                 '+CHAR(10);	
                    SET @mFG = @mFG + ' 		AND DIVISION_ID         =  '''+ @p_division_id  +'''' +CHAR(10);	
                    SET @mFG = @mFG + ' 		AND PLAN_START_YYYYMMDD =  '''+ @p_plan_start_yyyymmdd+'''' +CHAR(10);		
                    SET @mFG = @mFG + ' 		AND PLAN_TYPE           =  '''+ @p_plan_type  +'''' +CHAR(10);	
                    SET @mFG = @mFG + ' 		AND SEQ                 =  '+ CONVERT(NVARCHAR,@p_seq)+'' +CHAR(10);
                    
                    SET @mFG = @mFG + ' 		AND BIZ_TYPE            =  '''+ @X_OPERATION_GROUP+'''' +CHAR(10);	
                    SET @mFG = @mFG + ' 		AND ITEM_ID             =  '''+ @X_ITEM_ID+'''' +CHAR(10);	
                    SET @mFG = @mFG + ' 		AND PROJECT_CODE        =  '''+ @X_PROJECT_CODE+'''' +CHAR(10);	
                    SET @mFG = @mFG + ' 		AND TO_SITE             =  '''+ @X_TO_SITE+'''' +CHAR(10);	
                    SET @mFG = @mFG + ' 		AND INCOTERMS           =  '''+ @X_INCOTERMS+'''' +CHAR(10);		
                    SET @mFG = @mFG + ' 		AND FROM_SITE           =  '''+ @X_FROM_SITE+'''' +CHAR(10);	
                    SET @mFG = @mFG + ' 		AND BOD_ID              =  '''+ @X_BOD_ID+'''' +CHAR(10);	
                    
                    SET @mFG = @mFG + ' 		AND MEASURE             = ''SHIP_PLAN_AMEND'' '+CHAR(10);	
                    SET @mFG = @mFG + ' 		AND YYYYMMDD            <  '''+ @p_to_yyyymmdd +''''+CHAR(10);

                    ------------------------------------------------------------------------------------------------------------- 
                    -- 'SEMI_SHIP_PLAN'
                    -- PK : DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, FROM_SITE, BOD_ID, MEASURE, YYYYMMDD
                    ------------------------------------------------------------------------------------------------------------- 
                    DECLARE @mSEMI NVARCHAR(MAX) = '';

		                SET @mSEMI = @mSEMI + ' SELECT  '''+ @p_xls_key1  +''' AS XLS_KEY1  '+CHAR(10);	

		                SET @mSEMI = @mSEMI + ' 				' + @mQry_sum2 +'									      '+CHAR(10);	
  	                SET @mSEMI = @mSEMI + ' 		FROM SCP_ANL_SHIPMENT_PLAN_SEMI WITH (NOLOCK)  '+CHAR(10);	
                    SET @mSEMI = @mSEMI + ' 		WHERE 0 = 0                                 '+CHAR(10);	
                    SET @mSEMI = @mSEMI + ' 		AND DIVISION_ID         =  '''+ @p_division_id  +'''' +CHAR(10);	
                    SET @mSEMI = @mSEMI + ' 		AND PLAN_START_YYYYMMDD =  '''+ @p_plan_start_yyyymmdd+'''' +CHAR(10);		
                    SET @mSEMI = @mSEMI + '     AND PLAN_TYPE           =  '''+ @p_plan_type  +'''' +CHAR(10);	
                    SET @mSEMI = @mSEMI + ' 		AND SEQ                 =  '+ CONVERT(NVARCHAR,@p_seq)+'' +CHAR(10);
                    
                    SET @mSEMI = @mSEMI + ' 		AND OPERATION_GROUP     =  '''+ @X_OPERATION_GROUP+'''' +CHAR(10);	
                    SET @mSEMI = @mSEMI + ' 		AND ITEM_ID             =  '''+ @X_ITEM_ID+'''' +CHAR(10);	
                    SET @mSEMI = @mSEMI + ' 		AND FROM_SITE           =  '''+ @X_FROM_SITE+'''' +CHAR(10);	
                    SET @mSEMI = @mSEMI + ' 		AND BOD_ID              =  '''+ @X_BOD_ID+'''' +CHAR(10);	
                    
                    SET @mSEMI = @mSEMI + ' 		AND MEASURE             = ''SHIP_PLAN_AMEND'' '+CHAR(10);	
                    SET @mSEMI = @mSEMI + ' 		AND YYYYMMDD            <  '''+ @p_to_yyyymmdd +''''+CHAR(10);

                    ------------------------------------------------------------------------------------------------------------- 
                    -- 'PACK_PROD','CELL_PROD'
                    -- PK : DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, SCM_SITE_ID, ITEM_ID, LINE_ID, OPERATION_ID, MEASURE, YYYYMMDD
                    ------------------------------------------------------------------------------------------------------------- 
                    DECLARE @mPROD NVARCHAR(MAX) = '';

		                SET @mPROD = @mPROD + ' SELECT  '''+ @p_xls_key1  +''' AS XLS_KEY1  '+CHAR(10);	

		                SET @mPROD = @mPROD + ' 				' + @mQry_sum2 +'									      '+CHAR(10);	
  	                SET @mPROD = @mPROD + ' 		FROM SCP_ANL_PRODUCTION_PLAN WITH (NOLOCK)  '+CHAR(10);	
                    SET @mPROD = @mPROD + ' 		WHERE 0 = 0                                 '+CHAR(10);	
                    SET @mPROD = @mPROD + ' 		AND DIVISION_ID         =  '''+ @p_division_id  +'''' +CHAR(10);	
                    SET @mPROD = @mPROD + ' 		AND PLAN_START_YYYYMMDD =  '''+ @p_plan_start_yyyymmdd+'''' +CHAR(10);		
                    SET @mPROD = @mPROD + '     AND PLAN_TYPE           =  '''+ @p_plan_type  +'''' +CHAR(10);	
                    SET @mPROD = @mPROD + ' 		AND SEQ                 =  '+ CONVERT(NVARCHAR,@p_seq)+'' +CHAR(10);	
                    SET @mPROD = @mPROD + ' 		AND OPERATION_GROUP     =  '''+ @X_OPERATION_GROUP+'''' +CHAR(10);	
                    SET @mPROD = @mPROD + ' 		AND SCM_SITE_ID         =  '''+ @X_FROM_SITE+'''' +CHAR(10);	
                    SET @mPROD = @mPROD + ' 		AND ITEM_ID             =  '''+ @X_ITEM_ID+'''' +CHAR(10);	
                    SET @mPROD = @mPROD + ' 		AND LINE_ID             =  '''+ @X_LINE_ID+'''' +CHAR(10);	
                    SET @mPROD = @mPROD + ' 		AND OPERATION_ID        =  '''+ @X_OPERATION_ID+'''' +CHAR(10);		
                    SET @mPROD = @mPROD + ' 		AND MEASURE             = ''PROD_PLAN_AMEND'' '+CHAR(10);	
                    SET @mPROD = @mPROD + ' 		AND YYYYMMDD            <  '''+ @p_to_yyyymmdd +''''+CHAR(10);
                    ------------------------------------------------------------------------------------------------------------- 



                    IF @p_measure IN  ('SHIP_PLAN')   -- FG
                      SET @mEXEC2 = @mEXEC2 + @mFG

                    IF @p_measure IN  ('SEMI_SHIP_PLAN')  -- SEMI
                      SET @mEXEC2 = @mEXEC2 + @mSEMI

                    IF @p_measure IN  ('PACK_PROD','CELL_PROD')   -- PROD
                      SET @mEXEC2 = @mEXEC2 + @mPROD

/*                            
            DECLARE @POS int
            DECLARE @LEN NVARCHAR(max)
				    SET @POS =1;
				    SET @LEN =LEN(@mEXEC2);
				    WHILE @POS <= @LEN
					    BEGIN
						    PRINT SUBSTRING(@mEXEC2,@POS,4000);
						    SET @POS = @POS+4000;
					    END;
*/
          EXEC sp_executesql @mEXEC2;

                  -- #SCP_XLS_PSI_GLOBAL_ESS_MODIFY

                  UPDATE  X SET 
                          X.QTY001 = Y.QTY001, X.QTY002 = Y.QTY002, X.QTY003 = Y.QTY003, X.QTY004 = Y.QTY004, X.QTY005 = Y.QTY005, X.QTY006= Y.QTY006, X.QTY007 = Y.QTY007, X.QTY008 = Y.QTY008, X.QTY009 = Y.QTY009, X.QTY010 = Y.QTY010,
                          X.QTY011 = Y.QTY011, X.QTY012 = Y.QTY012, X.QTY013 = Y.QTY013, X.QTY014 = Y.QTY014, X.QTY015 = Y.QTY015, X.QTY016= Y.QTY016, X.QTY017 = Y.QTY017, X.QTY018 = Y.QTY018, X.QTY019 = Y.QTY019, X.QTY020 = Y.QTY020,
                          X.QTY021 = Y.QTY021, X.QTY022 = Y.QTY022, X.QTY023 = Y.QTY023, X.QTY024 = Y.QTY024, X.QTY025 = Y.QTY025, X.QTY026= Y.QTY026, X.QTY027 = Y.QTY027, X.QTY028 = Y.QTY028, X.QTY029 = Y.QTY029, X.QTY030 = Y.QTY030,
                          X.QTY031 = Y.QTY031, X.QTY032 = Y.QTY032, X.QTY033 = Y.QTY033, X.QTY034 = Y.QTY034, X.QTY035 = Y.QTY035, X.QTY036= Y.QTY036, X.QTY037 = Y.QTY037, X.QTY038 = Y.QTY038, X.QTY039 = Y.QTY039, X.QTY040 = Y.QTY040,
                          X.QTY041 = Y.QTY041, X.QTY042 = Y.QTY042, X.QTY043 = Y.QTY043, X.QTY044 = Y.QTY044, X.QTY045 = Y.QTY045, X.QTY046= Y.QTY046, X.QTY047 = Y.QTY047, X.QTY048 = Y.QTY048, X.QTY049 = Y.QTY049, X.QTY050 = Y.QTY050,
                          X.QTY051 = Y.QTY051, X.QTY052 = Y.QTY052, X.QTY053 = Y.QTY053, X.QTY054 = Y.QTY054, X.QTY055 = Y.QTY055, X.QTY056= Y.QTY056, X.QTY057 = Y.QTY057, X.QTY058 = Y.QTY058, X.QTY059 = Y.QTY059, X.QTY060 = Y.QTY060,
                          X.QTY061 = Y.QTY061, X.QTY062 = Y.QTY062, X.QTY063 = Y.QTY063, X.QTY064 = Y.QTY064, X.QTY065 = Y.QTY065, X.QTY066= Y.QTY066, X.QTY067 = Y.QTY067, X.QTY068 = Y.QTY068, X.QTY069 = Y.QTY069, X.QTY070 = Y.QTY070,
                          X.QTY071 = Y.QTY071, X.QTY072 = Y.QTY072, X.QTY073 = Y.QTY073, X.QTY074 = Y.QTY074, X.QTY075 = Y.QTY075, X.QTY076= Y.QTY076, X.QTY077 = Y.QTY077, X.QTY078 = Y.QTY078, X.QTY079 = Y.QTY079, X.QTY080 = Y.QTY080,
                          X.QTY081 = Y.QTY081, X.QTY082 = Y.QTY082, X.QTY083 = Y.QTY083, X.QTY084 = Y.QTY084, X.QTY085 = Y.QTY085, X.QTY086= Y.QTY086, X.QTY087 = Y.QTY087, X.QTY088 = Y.QTY088, X.QTY089 = Y.QTY089, X.QTY090 = Y.QTY090,
                          X.QTY091 = Y.QTY091, X.QTY092 = Y.QTY092, X.QTY093 = Y.QTY093, X.QTY094 = Y.QTY094, X.QTY095 = Y.QTY095, X.QTY096= Y.QTY096, X.QTY097 = Y.QTY097, X.QTY098 = Y.QTY098, X.QTY099 = Y.QTY099, X.QTY100 = Y.QTY100, 

                          X.QTY101 = Y.QTY101, X.QTY102 = Y.QTY102, X.QTY103 = Y.QTY103, X.QTY104 = Y.QTY104, X.QTY105 = Y.QTY105, X.QTY106= Y.QTY106, X.QTY107 = Y.QTY107, X.QTY108 = Y.QTY108, X.QTY109 = Y.QTY109, X.QTY110 = Y.QTY110,
                          X.QTY111 = Y.QTY111, X.QTY112 = Y.QTY112, X.QTY113 = Y.QTY113, X.QTY114 = Y.QTY114, X.QTY115 = Y.QTY115, X.QTY116= Y.QTY116, X.QTY117 = Y.QTY117, X.QTY118 = Y.QTY118, X.QTY119 = Y.QTY119, X.QTY120 = Y.QTY120,
                          X.QTY121 = Y.QTY121, X.QTY122 = Y.QTY122, X.QTY123 = Y.QTY123, X.QTY124 = Y.QTY124, X.QTY125 = Y.QTY125, X.QTY126= Y.QTY126, X.QTY127 = Y.QTY127, X.QTY128 = Y.QTY128, X.QTY129 = Y.QTY129, X.QTY130 = Y.QTY130,
                          X.QTY131 = Y.QTY131, X.QTY132 = Y.QTY132, X.QTY133 = Y.QTY133, X.QTY134 = Y.QTY134, X.QTY135 = Y.QTY135, X.QTY136= Y.QTY136, X.QTY137 = Y.QTY137, X.QTY138 = Y.QTY138, X.QTY139 = Y.QTY139, X.QTY140 = Y.QTY140,
                          X.QTY141 = Y.QTY141, X.QTY142 = Y.QTY142, X.QTY143 = Y.QTY143, X.QTY144 = Y.QTY144, X.QTY145 = Y.QTY145, X.QTY146= Y.QTY146, X.QTY147 = Y.QTY147, X.QTY148 = Y.QTY148, X.QTY149 = Y.QTY149, X.QTY150 = Y.QTY150,
                          X.QTY151 = Y.QTY151, X.QTY152 = Y.QTY152, X.QTY153 = Y.QTY153, X.QTY154 = Y.QTY154, X.QTY155 = Y.QTY155, X.QTY156= Y.QTY156, X.QTY157 = Y.QTY157, X.QTY158 = Y.QTY158, X.QTY159 = Y.QTY159, X.QTY160 = Y.QTY160,
                          X.QTY161 = Y.QTY161, X.QTY162 = Y.QTY162, X.QTY163 = Y.QTY163, X.QTY164 = Y.QTY164, X.QTY165 = Y.QTY165, X.QTY166= Y.QTY166, X.QTY167 = Y.QTY167, X.QTY168 = Y.QTY168, X.QTY169 = Y.QTY169, X.QTY170 = Y.QTY170,
                          X.QTY171 = Y.QTY171, X.QTY172 = Y.QTY172, X.QTY173 = Y.QTY173, X.QTY174 = Y.QTY174, X.QTY175 = Y.QTY175, X.QTY176= Y.QTY176, X.QTY177 = Y.QTY177, X.QTY178 = Y.QTY178, X.QTY179 = Y.QTY179, X.QTY180 = Y.QTY180,
                          X.QTY181 = Y.QTY181, X.QTY182 = Y.QTY182, X.QTY183 = Y.QTY183, X.QTY184 = Y.QTY184, X.QTY185 = Y.QTY185, X.QTY186= Y.QTY186, X.QTY187 = Y.QTY187, X.QTY188 = Y.QTY188, X.QTY189 = Y.QTY189, X.QTY190 = Y.QTY190,
                          X.QTY191 = Y.QTY191, X.QTY192 = Y.QTY192, X.QTY193 = Y.QTY193, X.QTY194 = Y.QTY194, X.QTY195 = Y.QTY195, X.QTY196= Y.QTY196, X.QTY197 = Y.QTY197, X.QTY198 = Y.QTY198, X.QTY199 = Y.QTY199, X.QTY200 = Y.QTY200, 

                          X.QTY201 = Y.QTY201, X.QTY202 = Y.QTY202, X.QTY203 = Y.QTY203, X.QTY204 = Y.QTY204, X.QTY205 = Y.QTY205, X.QTY206= Y.QTY206, X.QTY207 = Y.QTY207, X.QTY208 = Y.QTY208, X.QTY209 = Y.QTY209, X.QTY210 = Y.QTY210,
                          X.QTY211 = Y.QTY211, X.QTY212 = Y.QTY212, X.QTY213 = Y.QTY213, X.QTY214 = Y.QTY214, X.QTY215 = Y.QTY215, X.QTY216= Y.QTY216, X.QTY217 = Y.QTY217, X.QTY218 = Y.QTY218, X.QTY219 = Y.QTY219, X.QTY220 = Y.QTY220,
                          X.QTY221 = Y.QTY221, X.QTY222 = Y.QTY222, X.QTY223 = Y.QTY223, X.QTY224 = Y.QTY224, X.QTY225 = Y.QTY225, X.QTY226= Y.QTY226, X.QTY227 = Y.QTY227, X.QTY228 = Y.QTY228, X.QTY229 = Y.QTY229, X.QTY230 = Y.QTY230,
                          X.QTY231 = Y.QTY231, X.QTY232 = Y.QTY232, X.QTY233 = Y.QTY233, X.QTY234 = Y.QTY234, X.QTY235 = Y.QTY235, X.QTY236= Y.QTY236, X.QTY237 = Y.QTY237, X.QTY238 = Y.QTY238, X.QTY239 = Y.QTY239, X.QTY240 = Y.QTY240,
                          X.QTY241 = Y.QTY241, X.QTY242 = Y.QTY242, X.QTY243 = Y.QTY243, X.QTY244 = Y.QTY244, X.QTY245 = Y.QTY245, X.QTY246= Y.QTY246, X.QTY247 = Y.QTY247, X.QTY248 = Y.QTY248, X.QTY249 = Y.QTY249, X.QTY250 = Y.QTY250,
                          X.QTY251 = Y.QTY251, X.QTY252 = Y.QTY252, X.QTY253 = Y.QTY253, X.QTY254 = Y.QTY254, X.QTY255 = Y.QTY255, X.QTY256= Y.QTY256, X.QTY257 = Y.QTY257, X.QTY258 = Y.QTY258, X.QTY259 = Y.QTY259, X.QTY260 = Y.QTY260,
                          X.QTY261 = Y.QTY261, X.QTY262 = Y.QTY262, X.QTY263 = Y.QTY263, X.QTY264 = Y.QTY264, X.QTY265 = Y.QTY265, X.QTY266= Y.QTY266, X.QTY267 = Y.QTY267, X.QTY268 = Y.QTY268, X.QTY269 = Y.QTY269, X.QTY270 = Y.QTY270,
                          X.QTY271 = Y.QTY271, X.QTY272 = Y.QTY272, X.QTY273 = Y.QTY273, X.QTY274 = Y.QTY274, X.QTY275 = Y.QTY275, X.QTY276= Y.QTY276, X.QTY277 = Y.QTY277, X.QTY278 = Y.QTY278, X.QTY279 = Y.QTY279, X.QTY280 = Y.QTY280,
                          X.QTY281 = Y.QTY281, X.QTY282 = Y.QTY282, X.QTY283 = Y.QTY283, X.QTY284 = Y.QTY284, X.QTY285 = Y.QTY285, X.QTY286= Y.QTY286, X.QTY287 = Y.QTY287, X.QTY288 = Y.QTY288, X.QTY289 = Y.QTY289, X.QTY290 = Y.QTY290,
                          X.QTY291 = Y.QTY291, X.QTY292 = Y.QTY292, X.QTY293 = Y.QTY293, X.QTY294 = Y.QTY294, X.QTY295 = Y.QTY295, X.QTY296= Y.QTY296, X.QTY297 = Y.QTY297, X.QTY298 = Y.QTY298, X.QTY299 = Y.QTY299, X.QTY300 = Y.QTY300, 

                          X.QTY301 = Y.QTY301, X.QTY302 = Y.QTY302, X.QTY303 = Y.QTY303, X.QTY304 = Y.QTY304, X.QTY305 = Y.QTY305, X.QTY306= Y.QTY306, X.QTY307 = Y.QTY307, X.QTY308 = Y.QTY308, X.QTY309 = Y.QTY309, X.QTY310 = Y.QTY310,
                          X.QTY311 = Y.QTY311, X.QTY312 = Y.QTY312, X.QTY313 = Y.QTY313, X.QTY314 = Y.QTY314, X.QTY315 = Y.QTY315, X.QTY316= Y.QTY316, X.QTY317 = Y.QTY317, X.QTY318 = Y.QTY318, X.QTY319 = Y.QTY319, X.QTY320 = Y.QTY320,
                          X.QTY321 = Y.QTY321, X.QTY322 = Y.QTY322, X.QTY323 = Y.QTY323, X.QTY324 = Y.QTY324, X.QTY325 = Y.QTY325, X.QTY326= Y.QTY326, X.QTY327 = Y.QTY327, X.QTY328 = Y.QTY328, X.QTY329 = Y.QTY329, X.QTY330 = Y.QTY330,
                          X.QTY331 = Y.QTY331, X.QTY332 = Y.QTY332, X.QTY333 = Y.QTY333, X.QTY334 = Y.QTY334, X.QTY335 = Y.QTY335, X.QTY336= Y.QTY336, X.QTY337 = Y.QTY337, X.QTY338 = Y.QTY338, X.QTY339 = Y.QTY339, X.QTY340 = Y.QTY340,
                          X.QTY341 = Y.QTY341, X.QTY342 = Y.QTY342, X.QTY343 = Y.QTY343, X.QTY344 = Y.QTY344, X.QTY345 = Y.QTY345, X.QTY346= Y.QTY346, X.QTY347 = Y.QTY347, X.QTY348 = Y.QTY348, X.QTY349 = Y.QTY349, X.QTY350 = Y.QTY350,
                          X.QTY351 = Y.QTY351, X.QTY352 = Y.QTY352, X.QTY353 = Y.QTY353, X.QTY354 = Y.QTY354, X.QTY355 = Y.QTY355, X.QTY356= Y.QTY356, X.QTY357 = Y.QTY357, X.QTY358 = Y.QTY358, X.QTY359 = Y.QTY359, X.QTY360 = Y.QTY360, 
                          X.QTY361 = Y.QTY361, X.QTY362 = Y.QTY362, X.QTY363 = Y.QTY363, X.QTY364 = Y.QTY364, 

                          X.WQTY01 = Y.QTY001 + Y.QTY002 +  Y.QTY003 +  Y.QTY004 +  Y.QTY005 +  Y.QTY006 +  Y.QTY007,  
                          X.WQTY02 = Y.QTY008 + Y.QTY009 +  Y.QTY010 +  Y.QTY011 +  Y.QTY012 +  Y.QTY013 +  Y.QTY014,  
                          X.WQTY03 = Y.QTY015 + Y.QTY016 +  Y.QTY017 +  Y.QTY018 +  Y.QTY019 +  Y.QTY020 +  Y.QTY021,   
                          X.WQTY04 = Y.QTY022 + Y.QTY023 +  Y.QTY024 +  Y.QTY025 +  Y.QTY026 +  Y.QTY027 +  Y.QTY028,  
                          X.WQTY05 = Y.QTY029 + Y.QTY030 +  Y.QTY031 +  Y.QTY032 +  Y.QTY033 +  Y.QTY034 +  Y.QTY035,  
                          X.WQTY06 = Y.QTY036 + Y.QTY037 +  Y.QTY038 +  Y.QTY039 +  Y.QTY040 +  Y.QTY041 +  Y.QTY042,  
                          X.WQTY07 = Y.QTY043 + Y.QTY044 +  Y.QTY045 +  Y.QTY046 +  Y.QTY047 +  Y.QTY048 +  Y.QTY049,  
                          X.WQTY08 = Y.QTY050 + Y.QTY051 +  Y.QTY052 +  Y.QTY053 +  Y.QTY054 +  Y.QTY055 +  Y.QTY056,  
                          X.WQTY09 = Y.QTY057 + Y.QTY058 +  Y.QTY059 +  Y.QTY060 +  Y.QTY061 +  Y.QTY062 +  Y.QTY063,  
                          X.WQTY10 = Y.QTY064 + Y.QTY065 +  Y.QTY066 +  Y.QTY067 +  Y.QTY068 +  Y.QTY069 +  Y.QTY070,  

                          X.WQTY11 = Y.QTY071 + Y.QTY072 +  Y.QTY073 +  Y.QTY074 +  Y.QTY075 +  Y.QTY076 +  Y.QTY077,  
                          X.WQTY12 = Y.QTY078 + Y.QTY079 +  Y.QTY080 +  Y.QTY081 +  Y.QTY082 +  Y.QTY083 +  Y.QTY084,   
                          X.WQTY13 = Y.QTY085 + Y.QTY086 +  Y.QTY087 +  Y.QTY088 +  Y.QTY089 +  Y.QTY090 +  Y.QTY091,  
                          X.WQTY14 = Y.QTY092 + Y.QTY093 +  Y.QTY094 +  Y.QTY095 +  Y.QTY096 +  Y.QTY097 +  Y.QTY098,  
                          X.WQTY15 = Y.QTY099 + Y.QTY100 +  Y.QTY101 +  Y.QTY102 +  Y.QTY103 +  Y.QTY104 +  Y.QTY105,  
                          X.WQTY16 = Y.QTY106 + Y.QTY107 +  Y.QTY108 +  Y.QTY109 +  Y.QTY110 +  Y.QTY111 +  Y.QTY112,  
                          X.WQTY17 = Y.QTY113 + Y.QTY114 +  Y.QTY115 +  Y.QTY116 +  Y.QTY117 +  Y.QTY118 +  Y.QTY119,  
                          X.WQTY18 = Y.QTY120 + Y.QTY121 +  Y.QTY122 +  Y.QTY123 +  Y.QTY124 +  Y.QTY125 +  Y.QTY126,  
                          X.WQTY19 = Y.QTY127 + Y.QTY128 +  Y.QTY129 +  Y.QTY130 +  Y.QTY131 +  Y.QTY132 +  Y.QTY133,  
                          X.WQTY20 = Y.QTY134 + Y.QTY135 +  Y.QTY136 +  Y.QTY137 +  Y.QTY138 +  Y.QTY139 +  Y.QTY140,  

                          X.WQTY21 = Y.QTY141 + Y.QTY142 +  Y.QTY143 +  Y.QTY144 +  Y.QTY145 +  Y.QTY146 +  Y.QTY147,  
                          X.WQTY22 = Y.QTY148 + Y.QTY149 +  Y.QTY150 +  Y.QTY151 +  Y.QTY152 +  Y.QTY153 +  Y.QTY154,  
                          X.WQTY23 = Y.QTY155 + Y.QTY156 +  Y.QTY157 +  Y.QTY158 +  Y.QTY159 +  Y.QTY160 +  Y.QTY161,  
                          X.WQTY24 = Y.QTY162 + Y.QTY163 +  Y.QTY164 +  Y.QTY165 +  Y.QTY166 +  Y.QTY167 +  Y.QTY168,  
                          X.WQTY25 = Y.QTY169 + Y.QTY170 +  Y.QTY171 +  Y.QTY172 +  Y.QTY173 +  Y.QTY174 +  Y.QTY175,  
                          X.WQTY26 = Y.QTY176 + Y.QTY177 +  Y.QTY178 +  Y.QTY179 +  Y.QTY180 +  Y.QTY181 +  Y.QTY182,   
                          X.WQTY27 = Y.QTY183 + Y.QTY184 +  Y.QTY185 +  Y.QTY186 +  Y.QTY187 +  Y.QTY188 +  Y.QTY189,   
                          X.WQTY28 = Y.QTY190 + Y.QTY191 +  Y.QTY192 +  Y.QTY193 +  Y.QTY194 +  Y.QTY195 +  Y.QTY196,   
                          X.WQTY29 = Y.QTY197 + Y.QTY198 +  Y.QTY199 +  Y.QTY200 +  Y.QTY201 +  Y.QTY202 +  Y.QTY203,   
                          X.WQTY30 = Y.QTY204 + Y.QTY205 +  Y.QTY206 +  Y.QTY207 +  Y.QTY208 +  Y.QTY209 +  Y.QTY210,  

                          X.WQTY31 = Y.QTY211 + Y.QTY212 +  Y.QTY213 +  Y.QTY214 +  Y.QTY215 +  Y.QTY216 +  Y.QTY217,   
                          X.WQTY32 = Y.QTY218 + Y.QTY219 +  Y.QTY220 +  Y.QTY221 +  Y.QTY222 +  Y.QTY223 +  Y.QTY224,   
                          X.WQTY33 = Y.QTY225 + Y.QTY226 +  Y.QTY227 +  Y.QTY228 +  Y.QTY229 +  Y.QTY230 +  Y.QTY231,   
                          X.WQTY34 = Y.QTY232 + Y.QTY233 +  Y.QTY234 +  Y.QTY235 +  Y.QTY236 +  Y.QTY237 +  Y.QTY238,   
                          X.WQTY35 = Y.QTY239 + Y.QTY240 +  Y.QTY241 +  Y.QTY242 +  Y.QTY243 +  Y.QTY244 +  Y.QTY245,   
                          X.WQTY36 = Y.QTY246 + Y.QTY247 +  Y.QTY248 +  Y.QTY249 +  Y.QTY250 +  Y.QTY251 +  Y.QTY252,   
                          X.WQTY37 = Y.QTY253 + Y.QTY254 +  Y.QTY255 +  Y.QTY256 +  Y.QTY257 +  Y.QTY258 +  Y.QTY259,   
                          X.WQTY38 = Y.QTY260 + Y.QTY261 +  Y.QTY262 +  Y.QTY263 +  Y.QTY264 +  Y.QTY265 +  Y.QTY266,   
                          X.WQTY39 = Y.QTY267 + Y.QTY268 +  Y.QTY269 +  Y.QTY270 +  Y.QTY271 +  Y.QTY272 +  Y.QTY273,   
                          X.WQTY40 = Y.QTY274 + Y.QTY275 +  Y.QTY276 +  Y.QTY277 +  Y.QTY278 +  Y.QTY279 +  Y.QTY280,  

                          X.WQTY41 = Y.QTY281 + Y.QTY282 +  Y.QTY283 +  Y.QTY284 +  Y.QTY285 +  Y.QTY286 +  Y.QTY287,   
                          X.WQTY42 = Y.QTY288 + Y.QTY289 +  Y.QTY290 +  Y.QTY291 +  Y.QTY292 +  Y.QTY293 +  Y.QTY294,   
                          X.WQTY43 = Y.QTY295 + Y.QTY296 +  Y.QTY297 +  Y.QTY298 +  Y.QTY299 +  Y.QTY300 +  Y.QTY301,   
                          X.WQTY44 = Y.QTY302 + Y.QTY303 +  Y.QTY304 +  Y.QTY305 +  Y.QTY306 +  Y.QTY307 +  Y.QTY308,   
                          X.WQTY45 = Y.QTY309 + Y.QTY310 +  Y.QTY311 +  Y.QTY312 +  Y.QTY313 +  Y.QTY314 +  Y.QTY315,   
                          X.WQTY46 = Y.QTY316 + Y.QTY317 +  Y.QTY318 +  Y.QTY319 +  Y.QTY320 +  Y.QTY321 +  Y.QTY322,   
                          X.WQTY47 = Y.QTY323 + Y.QTY324 +  Y.QTY325 +  Y.QTY326 +  Y.QTY327 +  Y.QTY328 +  Y.QTY329,   
                          X.WQTY48 = Y.QTY330 + Y.QTY331 +  Y.QTY332 +  Y.QTY333 +  Y.QTY334 +  Y.QTY335 +  Y.QTY336,   
                          X.WQTY49 = Y.QTY337 + Y.QTY338 +  Y.QTY339 +  Y.QTY340 +  Y.QTY341 +  Y.QTY342 +  Y.QTY343,   
                          X.WQTY50 = Y.QTY344 + Y.QTY345 +  Y.QTY346 +  Y.QTY347 +  Y.QTY348 +  Y.QTY349 +  Y.QTY350,  

                          X.WQTY51 = Y.QTY351 + Y.QTY352 +  Y.QTY353 +  Y.QTY354 +  Y.QTY355 +  Y.QTY356 +  Y.QTY357,   
                          X.WQTY52 = Y.QTY358 + Y.QTY359 +  Y.QTY360 +  Y.QTY361 +  Y.QTY362 +  Y.QTY363 +  Y.QTY364,  
                          X.LAST_UPDATED_BY   = @p_USER_ID , 
                          X.LAST_UPDATE_DATE  = GETDATE() 
                    FROM SCP_XLS_PSI_GLOBAL_ESS X  WITH (NOLOCK) 
                    INNER JOIN #SCP_XLS_PSI_GLOBAL_ESS_MODIFY Y WITH (NOLOCK)
                    ON X.XLS_KEY1 = Y.XLS_KEY1
                    ;

              IF @p_measure IN  ('PACK_PROD','CELL_PROD')   
              BEGIN 
              -------------------------------------------------------------------------------------------------------------         
              -- LINE_TOTAL_LOAD_ENGINE UPDATE (TACT_TIME,WORKING_TIME)  , PACK_PROD_LOAD,CELL_PROD_LOAD
              -------------------------------------------------------------------------------------------------------------
              -------------------------------------------------------------------------------------------------------------         
              -- Line Load 율 로직 작업중
              -------------------------------------------------------------------------------------------------------------
              IF OBJECT_ID('tempdb..#LINE_WORKINGTIME_BY_LOSS') IS NOT NULL      
	              DROP TABLE #LINE_WORKINGTIME_BY_LOSS;   

                DECLARE @v_line_id  NVARCHAR(100) = ''

                SELECT @v_line_id = PROD_LINE 
                FROM SCP_XLS_PSI_GLOBAL_ESS WITH (NOLOCK)
                WHERE XLS_KEY1 = @p_xls_key1
                --Working Time 추출
		            SELECT DIVISION_ID
			               , PLANT_SITE_ID AS SCM_SITE_ID
			               , OPERATION_ID
			               , LINE_ID
			               , YYYYMMDD
			               , WORKING_TIME
		            INTO #LINE_WORKINGTIME_BY_LOSS
		            FROM dbo.FN_LINE_WORKINGTIME_BY_LOSS(@p_division_id, @p_plan_start_yyyymmdd, @p_to_yyyymmdd, @v_line_id )
                WHERE LINE_ID = @v_line_id
		            ;

	              IF OBJECT_ID('tempdb..#LineLoad') IS NOT NULL      
	                DROP TABLE #LineLoad;  
  	
                SELECT /*DISTINCT */
						          A.DIVISION_ID
					          , A.SCM_SITE_ID 
                    , A.OPERATION_GROUP
		                , A.OPERATION_ID
		                , A.LINE_ID
                    , (CASE WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND  A.OPERATION_GROUP ='P' THEN 'PACK_PROD_LOAD' WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND  A.OPERATION_GROUP ='A'  THEN 'CELL_PROD_LOAD' END ) AS MEASURE
                    , CASE WHEN D.WORKING_TIME <= 0.0 THEN 0 ELSE ISNULL( ( ( ROUND(SUM(A.QTY * (E.TACT_TIME/60)),0) / D.WORKING_TIME ) ) ,0 ) *100  END AS QTY
					          , ISNULL(ROUND(SUM(A.QTY * (E.TACT_TIME/60)),0), 0) AS CAPA_TACT
					          , ISNULL( D.WORKING_TIME ,0 ) AS WORKING_TIME
                    , A.YYYYMMDD AS YYYYMMDD
                    , C.ISO_YYYYWW AS ISO_YYYYWW
                    ,'WQTY' + REPLICATE('0', 2 - LEN(DENSE_RANK()  OVER(PARTITION BY  A.LINE_ID ORDER BY C.ISO_YYYYWW) )) + CONVERT(NVARCHAR,DENSE_RANK()  OVER(PARTITION BY  A.LINE_ID ORDER BY C.ISO_YYYYWW))  AS WEEK_COLUMN
                INTO #LineLoad
			          FROM SCP_ANL_PRODUCTION_PLAN A WITH (NOLOCK)
                INNER JOIN SCM_SYS_CALENDAR_M C   WITH (NOLOCK)
                        ON A.YYYYMMDD = C.BASIS_YYYYMMDD
			          LEFT OUTER JOIN #LINE_WORKINGTIME_BY_LOSS D  WITH (NOLOCK)
                     ON   A.DIVISION_ID   = D.DIVISION_ID 
                      AND A.OPERATION_ID  = D.OPERATION_ID 
					            AND A.SCM_SITE_ID   = D.SCM_SITE_ID 
					            AND A.LINE_ID       = D.LINE_ID 
					            AND A.YYYYMMDD      = D.YYYYMMDD
			          LEFT OUTER JOIN SCP_ANL_TACT_TIME E WITH(NOLOCK)	
                      ON A.DIVISION_ID    = E.DIVISION_ID 
                     AND A.OPERATION_ID   = E.OPERATION_ID 
				             AND A.SCM_SITE_ID    = E.SCM_SITE_ID  
				             AND A.LINE_ID        = E.LINE_ID 
                     AND A.ITEM_ID        = E.ITEM_ID 
				             AND A.YYYYMMDD       = E.YYYYMMDD
			          WHERE 1=1 
                   AND A.DIVISION_ID         = @p_division_id
                  AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
                  AND A.PLAN_TYPE           = @p_plan_type
                  AND A.SEQ                 = @p_seq
			            AND A.YYYYMMDD           >= @p_plan_start_yyyymmdd
	                AND A.YYYYMMDD           <  @p_to_yyyymmdd
	                AND A.MEASURE             = 'PROD_PLAN_AMEND'
                  AND A.LINE_ID             = @v_line_id
              GROUP BY A.DIVISION_ID, A.SCM_SITE_ID ,A.OPERATION_ID ,A.LINE_ID, A.YYYYMMDD, D.WORKING_TIME,  C.ISO_YYYYWW,A.OPERATION_GROUP
              , (CASE WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND  A.OPERATION_GROUP ='P' THEN 'PACK_PROD_LOAD' WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND  A.OPERATION_GROUP ='A'  THEN 'CELL_PROD_LOAD' END ) 


  


            -------------------------------------------------------------------------------------------------------------         
            --  364일 데이터 생성(PIVOIT 대상 날짜문자열 생성)
            -------------------------------------------------------------------------------------------------------------         
              DECLARE @mQry_sum NVARCHAR(MAX);      
   
		          SET     @mQry_sum = '';
		          SELECT  @mQry_sum = @mQry_sum+','+       
			          CASE  
                      WHEN 1 = 1 THEN  ' SUM(CASE WHEN YYYYMMDD = '''+YYYYMMDD+'''    THEN QTY ELSE 0 END ) AS ' + 'QTY' + REPLICATE('0', 3 - LEN(ROW_NUMBER() OVER(ORDER BY YYYYMMDD) )) + CONVERT(NVARCHAR,ROW_NUMBER() OVER(ORDER BY YYYYMMDD))        
			          END +''+CHAR(10)      
		          FROM (       
			          SELECT A.BASIS_YYYYMMDD                    AS YYYYMMDD    
                      , A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 31) AS SORT_ORDER_NO      
  	  	          FROM DBO.SCM_SYS_CALENDAR_M A  WITH(NOLOCK)	     
	 		           WHERE A.BASIS_YYYYMMDD     >= @p_plan_start_yyyymmdd 
                   AND A.BASIS_YYYYMMDD     <  @p_to_yyyymmdd     
			           GROUP BY A.BASIS_YYYYMMDD       
		          ) AS A      
		          ORDER BY SORT_ORDER_NO  ;      


              DECLARE @mEXEC NVARCHAR(MAX);

		          SET @mEXEC = '';
              SET @mEXEC = @mEXEC + 'UPDATE X SET 
                                            X.QTY001 = Y.QTY001, X.QTY002 = Y.QTY002, X.QTY003 = Y.QTY003, X.QTY004 = Y.QTY004, X.QTY005 = Y.QTY005, X.QTY006= Y.QTY006, X.QTY007 = Y.QTY007, X.QTY008 = Y.QTY008, X.QTY009 = Y.QTY009, X.QTY010 = Y.QTY010,
                                            X.QTY011 = Y.QTY011, X.QTY012 = Y.QTY012, X.QTY013 = Y.QTY013, X.QTY014 = Y.QTY014, X.QTY015 = Y.QTY015, X.QTY016= Y.QTY016, X.QTY017 = Y.QTY017, X.QTY018 = Y.QTY018, X.QTY019 = Y.QTY019, X.QTY020 = Y.QTY020,
                                            X.QTY021 = Y.QTY021, X.QTY022 = Y.QTY022, X.QTY023 = Y.QTY023, X.QTY024 = Y.QTY024, X.QTY025 = Y.QTY025, X.QTY026= Y.QTY026, X.QTY027 = Y.QTY027, X.QTY028 = Y.QTY028, X.QTY029 = Y.QTY029, X.QTY030 = Y.QTY030,
                                            X.QTY031 = Y.QTY031, X.QTY032 = Y.QTY032, X.QTY033 = Y.QTY033, X.QTY034 = Y.QTY034, X.QTY035 = Y.QTY035, X.QTY036= Y.QTY036, X.QTY037 = Y.QTY037, X.QTY038 = Y.QTY038, X.QTY039 = Y.QTY039, X.QTY040 = Y.QTY040,
                                            X.QTY041 = Y.QTY041, X.QTY042 = Y.QTY042, X.QTY043 = Y.QTY043, X.QTY044 = Y.QTY044, X.QTY045 = Y.QTY045, X.QTY046= Y.QTY046, X.QTY047 = Y.QTY047, X.QTY048 = Y.QTY048, X.QTY049 = Y.QTY049, X.QTY050 = Y.QTY050,
                                            X.QTY051 = Y.QTY051, X.QTY052 = Y.QTY052, X.QTY053 = Y.QTY053, X.QTY054 = Y.QTY054, X.QTY055 = Y.QTY055, X.QTY056= Y.QTY056, X.QTY057 = Y.QTY057, X.QTY058 = Y.QTY058, X.QTY059 = Y.QTY059, X.QTY060 = Y.QTY060,
                                            X.QTY061 = Y.QTY061, X.QTY062 = Y.QTY062, X.QTY063 = Y.QTY063, X.QTY064 = Y.QTY064, X.QTY065 = Y.QTY065, X.QTY066= Y.QTY066, X.QTY067 = Y.QTY067, X.QTY068 = Y.QTY068, X.QTY069 = Y.QTY069, X.QTY070 = Y.QTY070,
                                            X.QTY071 = Y.QTY071, X.QTY072 = Y.QTY072, X.QTY073 = Y.QTY073, X.QTY074 = Y.QTY074, X.QTY075 = Y.QTY075, X.QTY076= Y.QTY076, X.QTY077 = Y.QTY077, X.QTY078 = Y.QTY078, X.QTY079 = Y.QTY079, X.QTY080 = Y.QTY080,
                                            X.QTY081 = Y.QTY081, X.QTY082 = Y.QTY082, X.QTY083 = Y.QTY083, X.QTY084 = Y.QTY084, X.QTY085 = Y.QTY085, X.QTY086= Y.QTY086, X.QTY087 = Y.QTY087, X.QTY088 = Y.QTY088, X.QTY089 = Y.QTY089, X.QTY090 = Y.QTY090,
                                            X.QTY091 = Y.QTY091, X.QTY092 = Y.QTY092, X.QTY093 = Y.QTY093, X.QTY094 = Y.QTY094, X.QTY095 = Y.QTY095, X.QTY096= Y.QTY096, X.QTY097 = Y.QTY097, X.QTY098 = Y.QTY098, X.QTY099 = Y.QTY099, X.QTY100 = Y.QTY100, '+CHAR(10);	

              SET @mEXEC = @mEXEC + '       X.QTY101 = Y.QTY101, X.QTY102 = Y.QTY102, X.QTY103 = Y.QTY103, X.QTY104 = Y.QTY104, X.QTY105 = Y.QTY105, X.QTY106= Y.QTY106, X.QTY107 = Y.QTY107, X.QTY108 = Y.QTY108, X.QTY109 = Y.QTY109, X.QTY110 = Y.QTY110,
                                            X.QTY111 = Y.QTY111, X.QTY112 = Y.QTY112, X.QTY113 = Y.QTY113, X.QTY114 = Y.QTY114, X.QTY115 = Y.QTY115, X.QTY116= Y.QTY116, X.QTY117 = Y.QTY117, X.QTY118 = Y.QTY118, X.QTY119 = Y.QTY119, X.QTY120 = Y.QTY120,
                                            X.QTY121 = Y.QTY121, X.QTY122 = Y.QTY122, X.QTY123 = Y.QTY123, X.QTY124 = Y.QTY124, X.QTY125 = Y.QTY125, X.QTY126= Y.QTY126, X.QTY127 = Y.QTY127, X.QTY128 = Y.QTY128, X.QTY129 = Y.QTY129, X.QTY130 = Y.QTY130,
                                            X.QTY131 = Y.QTY131, X.QTY132 = Y.QTY132, X.QTY133 = Y.QTY133, X.QTY134 = Y.QTY134, X.QTY135 = Y.QTY135, X.QTY136= Y.QTY136, X.QTY137 = Y.QTY137, X.QTY138 = Y.QTY138, X.QTY139 = Y.QTY139, X.QTY140 = Y.QTY140,
                                            X.QTY141 = Y.QTY141, X.QTY142 = Y.QTY142, X.QTY143 = Y.QTY143, X.QTY144 = Y.QTY144, X.QTY145 = Y.QTY145, X.QTY146= Y.QTY146, X.QTY147 = Y.QTY147, X.QTY148 = Y.QTY148, X.QTY149 = Y.QTY149, X.QTY150 = Y.QTY150,
                                            X.QTY151 = Y.QTY151, X.QTY152 = Y.QTY152, X.QTY153 = Y.QTY153, X.QTY154 = Y.QTY154, X.QTY155 = Y.QTY155, X.QTY156= Y.QTY156, X.QTY157 = Y.QTY157, X.QTY158 = Y.QTY158, X.QTY159 = Y.QTY159, X.QTY160 = Y.QTY160,
                                            X.QTY161 = Y.QTY161, X.QTY162 = Y.QTY162, X.QTY163 = Y.QTY163, X.QTY164 = Y.QTY164, X.QTY165 = Y.QTY165, X.QTY166= Y.QTY166, X.QTY167 = Y.QTY167, X.QTY168 = Y.QTY168, X.QTY169 = Y.QTY169, X.QTY170 = Y.QTY170,
                                            X.QTY171 = Y.QTY171, X.QTY172 = Y.QTY172, X.QTY173 = Y.QTY173, X.QTY174 = Y.QTY174, X.QTY175 = Y.QTY175, X.QTY176= Y.QTY176, X.QTY177 = Y.QTY177, X.QTY178 = Y.QTY178, X.QTY179 = Y.QTY179, X.QTY180 = Y.QTY180,
                                            X.QTY181 = Y.QTY181, X.QTY182 = Y.QTY182, X.QTY183 = Y.QTY183, X.QTY184 = Y.QTY184, X.QTY185 = Y.QTY185, X.QTY186= Y.QTY186, X.QTY187 = Y.QTY187, X.QTY188 = Y.QTY188, X.QTY189 = Y.QTY189, X.QTY190 = Y.QTY190,
                                            X.QTY191 = Y.QTY191, X.QTY192 = Y.QTY192, X.QTY193 = Y.QTY193, X.QTY194 = Y.QTY194, X.QTY195 = Y.QTY195, X.QTY196= Y.QTY196, X.QTY197 = Y.QTY197, X.QTY198 = Y.QTY198, X.QTY199 = Y.QTY199, X.QTY200 = Y.QTY200, '+CHAR(10);	

              SET @mEXEC = @mEXEC + '       X.QTY201 = Y.QTY201, X.QTY202 = Y.QTY202, X.QTY203 = Y.QTY203, X.QTY204 = Y.QTY204, X.QTY205 = Y.QTY205, X.QTY206= Y.QTY206, X.QTY207 = Y.QTY207, X.QTY208 = Y.QTY208, X.QTY209 = Y.QTY209, X.QTY210 = Y.QTY210,
                                            X.QTY211 = Y.QTY211, X.QTY212 = Y.QTY212, X.QTY213 = Y.QTY213, X.QTY214 = Y.QTY214, X.QTY215 = Y.QTY215, X.QTY216= Y.QTY216, X.QTY217 = Y.QTY217, X.QTY218 = Y.QTY218, X.QTY219 = Y.QTY219, X.QTY220 = Y.QTY220,
                                            X.QTY221 = Y.QTY221, X.QTY222 = Y.QTY222, X.QTY223 = Y.QTY223, X.QTY224 = Y.QTY224, X.QTY225 = Y.QTY225, X.QTY226= Y.QTY226, X.QTY227 = Y.QTY227, X.QTY228 = Y.QTY228, X.QTY229 = Y.QTY229, X.QTY230 = Y.QTY230,
                                            X.QTY231 = Y.QTY231, X.QTY232 = Y.QTY232, X.QTY233 = Y.QTY233, X.QTY234 = Y.QTY234, X.QTY235 = Y.QTY235, X.QTY236= Y.QTY236, X.QTY237 = Y.QTY237, X.QTY238 = Y.QTY238, X.QTY239 = Y.QTY239, X.QTY240 = Y.QTY240,
                                            X.QTY241 = Y.QTY241, X.QTY242 = Y.QTY242, X.QTY243 = Y.QTY243, X.QTY244 = Y.QTY244, X.QTY245 = Y.QTY245, X.QTY246= Y.QTY246, X.QTY247 = Y.QTY247, X.QTY248 = Y.QTY248, X.QTY249 = Y.QTY249, X.QTY250 = Y.QTY250,
                                            X.QTY251 = Y.QTY251, X.QTY252 = Y.QTY252, X.QTY253 = Y.QTY253, X.QTY254 = Y.QTY254, X.QTY255 = Y.QTY255, X.QTY256= Y.QTY256, X.QTY257 = Y.QTY257, X.QTY258 = Y.QTY258, X.QTY259 = Y.QTY259, X.QTY260 = Y.QTY260,
                                            X.QTY261 = Y.QTY261, X.QTY262 = Y.QTY262, X.QTY263 = Y.QTY263, X.QTY264 = Y.QTY264, X.QTY265 = Y.QTY265, X.QTY266= Y.QTY266, X.QTY267 = Y.QTY267, X.QTY268 = Y.QTY268, X.QTY269 = Y.QTY269, X.QTY270 = Y.QTY270,
                                            X.QTY271 = Y.QTY271, X.QTY272 = Y.QTY272, X.QTY273 = Y.QTY273, X.QTY274 = Y.QTY274, X.QTY275 = Y.QTY275, X.QTY276= Y.QTY276, X.QTY277 = Y.QTY277, X.QTY278 = Y.QTY278, X.QTY279 = Y.QTY279, X.QTY280 = Y.QTY280,
                                            X.QTY281 = Y.QTY281, X.QTY282 = Y.QTY282, X.QTY283 = Y.QTY283, X.QTY284 = Y.QTY284, X.QTY285 = Y.QTY285, X.QTY286= Y.QTY286, X.QTY287 = Y.QTY287, X.QTY288 = Y.QTY288, X.QTY289 = Y.QTY289, X.QTY290 = Y.QTY290,
                                            X.QTY291 = Y.QTY291, X.QTY292 = Y.QTY292, X.QTY293 = Y.QTY293, X.QTY294 = Y.QTY294, X.QTY295 = Y.QTY295, X.QTY296= Y.QTY296, X.QTY297 = Y.QTY297, X.QTY298 = Y.QTY298, X.QTY299 = Y.QTY299, X.QTY300 = Y.QTY300, '+CHAR(10);	

              SET @mEXEC = @mEXEC + '       X.QTY301 = Y.QTY301, X.QTY302 = Y.QTY302, X.QTY303 = Y.QTY303, X.QTY304 = Y.QTY304, X.QTY305 = Y.QTY305, X.QTY306= Y.QTY306, X.QTY307 = Y.QTY307, X.QTY308 = Y.QTY308, X.QTY309 = Y.QTY309, X.QTY310 = Y.QTY310,
                                            X.QTY311 = Y.QTY311, X.QTY312 = Y.QTY312, X.QTY313 = Y.QTY313, X.QTY314 = Y.QTY314, X.QTY315 = Y.QTY315, X.QTY316= Y.QTY316, X.QTY317 = Y.QTY317, X.QTY318 = Y.QTY318, X.QTY319 = Y.QTY319, X.QTY320 = Y.QTY320,
                                            X.QTY321 = Y.QTY321, X.QTY322 = Y.QTY322, X.QTY323 = Y.QTY323, X.QTY324 = Y.QTY324, X.QTY325 = Y.QTY325, X.QTY326= Y.QTY326, X.QTY327 = Y.QTY327, X.QTY328 = Y.QTY328, X.QTY329 = Y.QTY329, X.QTY330 = Y.QTY330,
                                            X.QTY331 = Y.QTY331, X.QTY332 = Y.QTY332, X.QTY333 = Y.QTY333, X.QTY334 = Y.QTY334, X.QTY335 = Y.QTY335, X.QTY336= Y.QTY336, X.QTY337 = Y.QTY337, X.QTY338 = Y.QTY338, X.QTY339 = Y.QTY339, X.QTY340 = Y.QTY340,
                                            X.QTY341 = Y.QTY341, X.QTY342 = Y.QTY342, X.QTY343 = Y.QTY343, X.QTY344 = Y.QTY344, X.QTY345 = Y.QTY345, X.QTY346= Y.QTY346, X.QTY347 = Y.QTY347, X.QTY348 = Y.QTY348, X.QTY349 = Y.QTY349, X.QTY350 = Y.QTY350,
                                            X.QTY351 = Y.QTY351, X.QTY352 = Y.QTY352, X.QTY353 = Y.QTY353, X.QTY354 = Y.QTY354, X.QTY355 = Y.QTY355, X.QTY356= Y.QTY356, X.QTY357 = Y.QTY357, X.QTY358 = Y.QTY358, X.QTY359 = Y.QTY359, X.QTY360 = Y.QTY360, 
                                            X.QTY361 = Y.QTY361, X.QTY362 = Y.QTY362, X.QTY363 = Y.QTY363, X.QTY364 = Y.QTY364, 
                                            X.LAST_UPDATED_BY = ''' + @p_USER_ID + ''', 
                                            X.LAST_UPDATE_DATE = GETDATE() '+CHAR(10);	

              SET @mEXEC = @mEXEC + ' FROM SCP_XLS_PSI_GLOBAL_ESS X  WITH (NOLOCK) '+CHAR(10);	
		          SET @mEXEC = @mEXEC + ' INNER JOIN ('
		          SET @mEXEC = @mEXEC + '               SELECT A.DIVISION_ID
                                                           ,A.OPERATION_GROUP
                                                           ,A.SCM_SITE_ID	 
                                                           ,A.OPERATION_ID
                                                           ,A.MEASURE  
                                                           ,A.LINE_ID '+CHAR(10);	
		          SET @mEXEC = @mEXEC + ' 				           ' + @mQry_sum +'  '+CHAR(10);	
  	          SET @mEXEC = @mEXEC + ' 		            FROM #LineLoad A WITH (NOLOCK)		
                                                  GROUP BY  A.DIVISION_ID
                                                           ,A.OPERATION_GROUP
                                                           ,A.SCM_SITE_ID	 
                                                           ,A.OPERATION_ID
                                                           ,A.MEASURE  
                                                           ,A.LINE_ID
                                                          '+CHAR(10);
              SET @mEXEC = @mEXEC + '             ) Y '+CHAR(10);	
              SET @mEXEC = @mEXEC + ' ON 0 = 0
                                      AND X.OPERATION_GROUP   = Y.OPERATION_GROUP 
                                      AND X.FROM_SITE         = Y.SCM_SITE_ID 
                                      AND X.ATTRIBUTE9        = Y.OPERATION_ID
                                      AND X.PROD_LINE         = Y.LINE_ID 
                                      AND X.MEASURE           = Y.MEASURE
                                    '+CHAR(10);	

              EXEC sp_executesql @mEXEC;
              
          /*
            DECLARE @POS int
            DECLARE @LEN NVARCHAR(max)
				    SET @POS =1;
				    SET @LEN =LEN(@mEXEC);
				    WHILE @POS <= @LEN
					    BEGIN
						    PRINT SUBSTRING(@mEXEC,@POS,4000);
						    SET @POS = @POS+4000;
					    END;
            */

            -------------------------------------------------------------------------------------------------------------         
            --  WEEK SUM PIVOT 생성 후 UPDATE
            -------------------------------------------------------------------------------------------------------------         
              IF OBJECT_ID('tempdb..#LineLoad_WEEK') IS NOT NULL      
	              DROP TABLE #LineLoad_WEEK;   

                SELECT   A.DIVISION_ID
                        ,A.SCM_SITE_ID  AS SITE_ID
                        ,A.OPERATION_ID
                        ,A.LINE_ID AS PROD_LINE
                        ,A.MEASURE
                        ,CASE WHEN SUM(A.WORKING_TIME) <= 0.0   THEN 0 
                              ELSE ISNULL( ( ROUND(SUM(A.CAPA_TACT),0) / SUM(A.WORKING_TIME) ) ,0 ) *100
                         END AS WQTY
                        ,A.ISO_YYYYWW
                        ,A.WEEK_COLUMN
                 INTO #LineLoad_WEEK
                  FROM #LineLoad A WITH (NOLOCK)
                GROUP BY A.DIVISION_ID
                        ,A.SCM_SITE_ID
                        ,A.OPERATION_ID
                        ,A.LINE_ID
                        ,A.MEASURE
                        ,A.ISO_YYYYWW
                        ,A.WEEK_COLUMN

                IF OBJECT_ID('tempdb..#LineLoad_WEEK_PIVOT') IS NOT NULL      
	                DROP TABLE #LineLoad_WEEK_PIVOT; 

                  SELECT *
                  INTO #LineLoad_WEEK_PIVOT
                  FROM
                    (
                    SELECT DIVISION_ID, SITE_ID, OPERATION_ID, PROD_LINE, MEASURE,WQTY,WEEK_COLUMN
                     FROM #LineLoad_WEEK WITH (NOLOCK) 
                     ) AS SourceTable  
                  PIVOT 
                      (
                       MIN(WQTY)
                       FOR  WEEK_COLUMN IN ( [WQTY01],[WQTY02],[WQTY03],[WQTY04],[WQTY05],[WQTY06],[WQTY07],[WQTY08],[WQTY09],[WQTY10],
                                             [WQTY11],[WQTY12],[WQTY13],[WQTY14],[WQTY15],[WQTY16],[WQTY17],[WQTY18],[WQTY19],[WQTY20],
                                             [WQTY21],[WQTY22],[WQTY23],[WQTY24],[WQTY25],[WQTY26],[WQTY27],[WQTY28],[WQTY29],[WQTY30],
                                             [WQTY31],[WQTY32],[WQTY33],[WQTY34],[WQTY35],[WQTY36],[WQTY37],[WQTY38],[WQTY39],[WQTY40],
                                             [WQTY41],[WQTY42],[WQTY43],[WQTY44],[WQTY45],[WQTY46],[WQTY47],[WQTY48],[WQTY49],[WQTY50],
                                             [WQTY51],[WQTY52]
                                            )  
                       ) X


                UPDATE X 
                  SET   X.WQTY01 = Y.WQTY01 ,X.WQTY02 = Y.WQTY02  ,X.WQTY03 = Y.WQTY03  ,X.WQTY04 = Y.WQTY04  ,X.WQTY05 = Y.WQTY05
                      , X.WQTY06 = Y.WQTY06 ,X.WQTY07 = Y.WQTY07  ,X.WQTY08 = Y.WQTY08  ,X.WQTY09 = Y.WQTY09  ,X.WQTY10 = Y.WQTY10
                      , X.WQTY11 = Y.WQTY11 ,X.WQTY12 = Y.WQTY12  ,X.WQTY13 = Y.WQTY13  ,X.WQTY14 = Y.WQTY14  ,X.WQTY15 = Y.WQTY15
                      , X.WQTY16 = Y.WQTY16 ,X.WQTY17 = Y.WQTY17  ,X.WQTY18 = Y.WQTY18  ,X.WQTY19 = Y.WQTY19  ,X.WQTY20 = Y.WQTY20
                      , X.WQTY21 = Y.WQTY21 ,X.WQTY22 = Y.WQTY22  ,X.WQTY23 = Y.WQTY23  ,X.WQTY24 = Y.WQTY24  ,X.WQTY25 = Y.WQTY25
                      , X.WQTY26 = Y.WQTY26 ,X.WQTY27 = Y.WQTY27  ,X.WQTY28 = Y.WQTY28  ,X.WQTY29 = Y.WQTY29  ,X.WQTY30 = Y.WQTY30
                      , X.WQTY31 = Y.WQTY31 ,X.WQTY32 = Y.WQTY32  ,X.WQTY33 = Y.WQTY33  ,X.WQTY34 = Y.WQTY34  ,X.WQTY35 = Y.WQTY35
                      , X.WQTY36 = Y.WQTY36 ,X.WQTY37 = Y.WQTY37  ,X.WQTY38 = Y.WQTY38  ,X.WQTY39 = Y.WQTY39  ,X.WQTY40 = Y.WQTY40
                      , X.WQTY41 = Y.WQTY41 ,X.WQTY42 = Y.WQTY42  ,X.WQTY43 = Y.WQTY43  ,X.WQTY44 = Y.WQTY44  ,X.WQTY45 = Y.WQTY45
                      , X.WQTY46 = Y.WQTY46 ,X.WQTY47 = Y.WQTY47  ,X.WQTY48 = Y.WQTY48  ,X.WQTY49 = Y.WQTY49  ,X.WQTY50 = Y.WQTY50
                      , X.WQTY51 = Y.WQTY51 ,X.WQTY52 = Y.WQTY52
                   FROM SCP_XLS_PSI_GLOBAL_ESS X WITH (NOLOCK)
                   INNER JOIN #LineLoad_WEEK_PIVOT Y WITH (NOLOCK)
                      ON Y.PROD_LINE    = X.PROD_LINE 
                     AND X.DIVISION_ID  = Y.DIVISION_ID
                     AND X.FROM_SITE    = Y.SITE_ID
                     AND X.ATTRIBUTE9   = Y.OPERATION_ID
                   WHERE X.MEASURE IN ('PACK_PROD_LOAD','CELL_PROD_LOAD') 


            END



        END

        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        -- TXN LOG
        SET @v_log_type = N'TXN';    -- 로그타입
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = N'INSERT INTO '+@v_table_id;
        SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(23) ,@d_event_date ,121);
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                                  ,@p_log_type      = @v_log_type
                                  ,@p_log_count     = @n_log_count 
                                  ,@p_log_message   = @v_log_message 
                                  ,@p_description   = @v_description 
                                  ,@p_event_date    = @d_event_date 
                                  ,@p_user_id       = @v_batch_user
                                  ;

      END;

    END TRY

    BEGIN CATCH
        
      --IF @@TRANCOUNT > 0 
      --  BEGIN
      --    ROLLBACK;
      --  END;
      
      -- ERROR LOG
      SET @v_log_type = N'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE()) + '[' + @p_measure + ']';
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                                ,@p_log_type      = @v_log_type
                                ,@p_log_count     = @n_log_count 
                                ,@p_log_message   = @v_log_message 
                                ,@p_description   = @v_description 
                                ,@p_event_date    = @d_event_date 
                                ,@p_user_id       = @v_batch_user
                                ;

      return -1 
    END CATCH;

    --     임시 운영반영시에 주석처리 할것.                
     SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +                 
                          REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))                 


    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description = N'['+@p_division_id+']['+@p_PLAN_START_YYYYMMDD+']['+@p_measure+']['+@p_xls_key1+'][' + @v_exec_time + ']';         
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                              ,@p_log_type      = @v_log_type
                              ,@p_log_count     = @n_log_count 
                              ,@p_log_message   = @v_log_message 
                              ,@p_description   = @v_description 
                              ,@p_event_date    = @d_event_date 
                              ,@p_user_id       = @v_batch_user
                              ;
    return 1 


  END;



