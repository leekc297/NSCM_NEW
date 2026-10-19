





/*
 * Program ID   : PR_SCP_XLS_PSI_GLOBAL_SMALL_PACK_S
 * Description  : SCP SIMULATION CREATE
 * OutTable     :
 * Execute      : 
                 EXEC PR_SCP_XLS_PSI_GLOBAL_SMALL_PACK_S    


 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023.09.25   DHJ            Initial Release PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase.2
 * 2023.10.26   kHJ            동일 ITEM, 동일 FROM-TO SITE에서 2개 이상의 PROJECT_CODE 발생 ==> MIN으로 처리 (단, SHIP_AMEND는 PROJECT_CODE별로 분리가능)
 * 2025.09.02	kimcd		   속도 개선 HASH 추가
 * 2026.07.24   YMH            E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
 */    

CREATE PROCEDURE [dbo].[PR_SCP_XLS_PSI_GLOBAL_SMALL_PACK_S]
(       
      @p_plan_cycle           NVARCHAR(0150)        
    , @p_plan_start_yyyymmdd  NVARCHAR(0008)        
    , @p_plan_id              NVARCHAR(4000)        
    , @p_modeling_id          NVARCHAR(4000)        
    , @p_seq                  NVARCHAR(4000)        
    , @p_plan_type            NVARCHAR(4000)        
    , @p_master_id            NVARCHAR(4000)        
    , @p_division_id          NVARCHAR(0030)        
    , @p_engine_plan_id       NVARCHAR(4000)          
	, @p_create_from_yyyymmdd  NVARCHAR(0008)
	, @p_create_to_yyyymmdd   NVARCHAR(0008)
    , @p_user_id              NVARCHAR(0150)  = 'SCP_batch'        
    , @p_is_debug				bit      = 0  -- 0 :운영, 1 : 개발
)       
AS        
  BEGIN      
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;      
    SET NOCOUNT ON;      
    SET XACT_ABORT ON;      
    --SET ANSI_WARNINGS OFF;    
	SET ANSI_WARNINGS ON;     
    SET ANSI_NULLS ON;
      
    -- LOG 용 변수 설정      
    DECLARE @v_batch_user   NVARCHAR(150) = N'SCP_batch';        
    SET @v_batch_user                     = @p_user_id      
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_XLS_PSI_GLOBAL_SMALL_PACK_S';      
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...      
    DECLARE @n_log_count    INTEGER = 0;      
    DECLARE @v_log_message  NVARCHAR(1000);      
    DECLARE @v_description  NVARCHAR(500);    
    DECLARE @v_table_id     NVARCHAR(150) = N'SCM_SYS_LOG_BATCH';   
    DECLARE @d_event_date   DATETIME;   
       
    



  
  -- 시작 LOG      
    SET @v_log_type     = N'START';      
    SET @v_log_message  = N'########## Start of procedure ##########';      
    SET @v_description  = @v_program_name + ':' + N'INSERT LOGIC';      
    SET @d_event_date   = SYSDATETIME();      
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
                              ,@p_log_type      = @v_log_type      
                              ,@p_log_count     = @n_log_count       
                              ,@p_log_message   = @v_log_message       
                              ,@p_description   = @v_description       
                              ,@p_event_date    = @d_event_date       
                              ,@p_user_id       = @v_batch_user      
                              ;      
  
   
        -- 실행시간 확인용    
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();    
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'00:00';    

    DECLARE @p_program_id   NVARCHAR(30) = 'XLSPSI02'          
    --DECLARE @p_to_yyyymmdd  VARCHAR(8)   =  CONVERT(VARCHAR(8), DATEADD(day, 364, @p_plan_start_yyyymmdd), 112)
    --DECLARE @p_cutoff_date  VARCHAR(8)   =  CONVERT(VARCHAR(8), DATEADD(day,  -1, @p_plan_start_yyyymmdd), 112)

    DECLARE @v_Max_xls_key1 INTEGER = 0;  -- @p_update가 'Y' 일경우  전체 xls_key1 MAX

	/*
    IF @p_update = 'Y'
      BEGIN
        SELECT @v_Max_xls_key1 = ISNULL(MAX(xls_key1),0) +1
          FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK  WITH (NOLOCK)
      END
	  */
    --DECLARE @debug_mode            NVARCHAR(30) = 'T'
    BEGIN TRY        
          BEGIN        

		  -------------------------------------------------------------------------------------------------------------         
            -- LT 계산용 테이블 생성   
            -------------------------------------------------------------------------------------------------------------         
             IF OBJECT_ID('tempdb..#SCP_MST_BOD_V') IS NOT NULL      
	                DROP TABLE #SCP_MST_BOD_V; 

                SELECT DISTINCT X.DIVISION_ID,X.FROM_SITE,X.TO_SITE,X.INCOTERMS,X.TRANSPORT_MODE,X.LT_TOTAL, X.BOD_ID
                INTO #SCP_MST_BOD_V
                FROM SCP_MST_BOD_N_V  X WITH (NOLOCK)		-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V
                WHERE DIVISION_ID =@p_division_id
				;

		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 001 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;  

          -------------------------------------------------------------------------------------------------------------         
            -- LINE_TOTAL_LOAD_ENGINE (TACT_TIME,WORKING_TIME)  
            -------------------------------------------------------------------------------------------------------------
			
            -------------------------------------------------------------------------------------------------------------         
              -- Line Load 율 로직 작업중
              -------------------------------------------------------------------------------------------------------------
              IF OBJECT_ID('tempdb..#LINE_WORKINGTIME_BY_LOSS') IS NOT NULL      
	              DROP TABLE #LINE_WORKINGTIME_BY_LOSS;   

                --Working Time 추출
		            SELECT DIVISION_ID
			               , PLANT_SITE_ID AS SCM_SITE_ID
			               , OPERATION_ID
			               , LINE_ID
			               , YYYYMMDD
			               , WORKING_TIME
		            INTO #LINE_WORKINGTIME_BY_LOSS
--		            FROM dbo.FN_LINE_WORKINGTIME_BY_LOSS(@p_division_id, @p_plan_start_yyyymmdd, @p_create_to_yyyymmdd, '' )
		            FROM dbo.FN_LINE_WORKINGTIME_BY_LOSS(@p_division_id, @p_create_from_yyyymmdd, @p_create_to_yyyymmdd, '' )
		            ;

	              IF OBJECT_ID('tempdb..#LineLoad') IS NOT NULL      
	                DROP TABLE #LineLoad;  
  	
                 SELECT /*DISTINCT */
					A.DIVISION_ID
					, A.SCM_SITE_ID 
                    , A.OPERATION_GROUP
		            , A.OPERATION_ID
		            , A.LINE_ID
                    , 'PACK_PROD_LOAD' AS MEASURE
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
				AND A.LINE_ID        = E.LINE_ID    --- LINE_ID ='-'
                AND A.ITEM_ID        = E.ITEM_ID 
				AND A.YYYYMMDD       = E.YYYYMMDD
			    WHERE 1=1 
                AND A.DIVISION_ID         = @p_division_id
                AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
                AND A.PLAN_TYPE           = @p_plan_type
                AND A.SEQ                 = @p_seq			        
				AND A.YYYYMMDD           >= @p_create_from_yyyymmdd
	            AND A.YYYYMMDD           <=  @p_create_to_yyyymmdd
	            AND A.MEASURE             = 'PROD_PLAN_AMEND'
                AND A.OPERATION_GROUP     = 'P'
              GROUP BY A.DIVISION_ID, A.SCM_SITE_ID, A.OPERATION_ID ,A.LINE_ID, A.YYYYMMDD, D.WORKING_TIME,  C.ISO_YYYYWW,A.OPERATION_GROUP
			  
		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 002 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;  


              UPDATE X
              SET X.QTY       = Y.QTY
              FROM ##PSI_GLOBAL_SMALL_PACK X  WITH (NOLOCK)
              INNER JOIN #LineLoad  Y WITH (NOLOCK)
              ON 0 = 0
              AND X.DIVISION_ID   = Y.DIVISION_ID
		        AND X.YYYYMMDD  = Y.YYYYMMDD
              AND X.FROM_SITE     = Y.SCM_SITE_ID
              AND X.MEASURE       = 'PACK_PROD_LOAD'

		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 003 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;  
			  			  
		  -------------------------------------------------------------------------------------------------------------         
            -- 전체 임시 테이블 생성  (#SCP_XLS_PSI_GLOBAL_SMALL_PACK)
            -------------------------------------------------------------------------------------------------------------  
                IF OBJECT_ID('tempdb..#SCP_XLS_PSI_GLOBAL_SMALL_PACK') IS NOT NULL	
	                  DROP TABLE #SCP_XLS_PSI_GLOBAL_SMALL_PACK

              --DROP TABLE #SCP_XLS_PSI_GLOBAL_SMALL_PACKL
              CREATE TABLE #SCP_XLS_PSI_GLOBAL_SMALL_PACK(
	              DIVISION_ID           NVARCHAR(030)     NULL,
	              PLAN_START_YYYYMMDD   NVARCHAR(008)     NULL,
--				  CREATE_FROM_YYYYMMDD  NVARCHAR(008)     NULL,
--				  CREATE_TO_YYYYMMDD    NVARCHAR(008)     NULL,				  
	              PLAN_TYPE             NVARCHAR(050)     NULL,
	              SEQ                   BIGINT            NULL,
	              OPERATION_GROUP       NVARCHAR(010)     NULL,
	              OPERATION_GROUP_NAME  NVARCHAR(100)     NULL,   -- 신규
	              CELL_ITEM_ID          NVARCHAR(150)     NULL,
	              ITEM_ID               NVARCHAR(050)     NULL,
	              NICK_NAME             NVARCHAR(200)     NULL,
	              CELL_QTY_PACK         NUMERIC (20,10)   NULL,   -- 신규
	              TO_SITE               NVARCHAR(030)     NULL,
	              TO_SITE_DESCRIPTION   NVARCHAR(150)     NULL,   -- SCM_SITE_DESCRIPTION
                PROJECT_CODE          NVARCHAR(050)     NULL,   -- FG 때문에 추가
	              FROM_BOH_QTY          NUMERIC(20, 10)   NULL,
	              TO_BOH_QTY            NUMERIC(20, 10)   NULL,
	              INCOTERMS             NVARCHAR(010)     NULL,
	              FROM_SITE             NVARCHAR(030)     NULL,
	              FROM_SITE_DESCRIPTION NVARCHAR(150)     NULL,   -- SCM_SITE_DESCRIPTION
                TRANSPORT_MODE        NVARCHAR(050)     NULL,
                PROD_LINE             NVARCHAR(050)     NULL,
	              LT_DAY                INT               NULL,
	              BOD_ID                NVARCHAR(150)     NULL,
	              MEASURE               NVARCHAR(050)     NULL,
	              MEASURE_LABEL         NVARCHAR(150)     NULL,   -- COLUMN_LABEL_NAME
	              XLS_KEY1              NVARCHAR(200)     NULL,
	              XLS_KEY2              NVARCHAR(200)     NULL,
	              XLS_KEY3              NVARCHAR(200)     NULL,
	              XLS_KEY4              NVARCHAR(200)     NULL,
	              XLS_KEY5              NVARCHAR(200)     NULL,
	              XLS_ATTRIBUTE1        NVARCHAR(200)     NULL,
	              XLS_ATTRIBUTE2        NVARCHAR(200)     NULL,
	              XLS_ATTRIBUTE3        NVARCHAR(200)     NULL,
	              XLS_ATTRIBUTE4        NVARCHAR(200)     NULL,
	              XLS_ATTRIBUTE5        NVARCHAR(200)     NULL,
	          --    CALC_YN               NVARCHAR(001)     NULL,
	          --DISPLAY_YN            NVARCHAR(001)     NULL,
	              SORT_ORDER_NO         INT               NULL,
	              
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
--                CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
                ATTRIBUTE1            NVARCHAR(150) NULL,
                ATTRIBUTE2            NVARCHAR(150) NULL,
                ATTRIBUTE3            NVARCHAR(150) NULL,
                ATTRIBUTE4            NVARCHAR(150) NULL,
                ATTRIBUTE5            NVARCHAR(150) NULL,
                ATTRIBUTE6            NVARCHAR(150) NULL,
                ATTRIBUTE7            NVARCHAR(150) NULL,
                ATTRIBUTE8            NVARCHAR(150) NULL,
                ATTRIBUTE9            NVARCHAR(150) NULL,       -- OPERATION_ID
                ATTRIBUTE10           NVARCHAR(150) NULL
              ) 
              

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
	 		           WHERE A.BASIS_YYYYMMDD     >= @p_create_from_yyyymmdd 
                   AND A.BASIS_YYYYMMDD     <  @p_create_to_yyyymmdd     
			           GROUP BY A.BASIS_YYYYMMDD       
		          ) AS A      
		          ORDER BY SORT_ORDER_NO  ;      
--				  PRINT '364일 데이터 생성(PIVOIT 대상 날짜문자열 생성)';
           -------------------------------------------------------------------------------------------------------------         
            -- 전체 DATA 생성 (#PSI_GLOBAL_SMALL_PACK --> #SCP_XLS_PSI_GLOBAL_SMALL_PACK) PIVOT
            -- 속도 때문에 CASE문에서 PIVOT문으로 변경함.
            -------------------------------------------------------------------------------------------------------------

              --ALTER TABLE #PSI_GLOBAL_SMALL_PACK
              --ADD WEEK_COLUMN NVARCHAR(6)


              SELECT DISTINCT YYYYMMDD
                            ,'QTY' + REPLICATE('0', 3 - LEN(DENSE_RANK()  OVER(ORDER BY YYYYMMDD) )) + CONVERT(NVARCHAR,DENSE_RANK()  OVER(ORDER BY YYYYMMDD))  AS WEEK_COLUMN
              INTO #WEEK_COLUMN
              FROM ##PSI_GLOBAL_SMALL_PACK X  WITH (NOLOCK)
--              WHERE X.YYYYMMDD >= @p_plan_start_yyyymmdd
				WHERE X.YYYYMMDD           >= @p_create_from_yyyymmdd
				AND   X.YYYYMMDD           <=  @p_create_to_yyyymmdd


		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 004 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;  

            
              UPDATE X
                 SET X.WEEK_COLUMN = Y.WEEK_COLUMN
                FROM ##PSI_GLOBAL_SMALL_PACK X  WITH (NOLOCK)
               INNER JOIN #WEEK_COLUMN Y  WITH (NOLOCK)
                  ON X.YYYYMMDD = Y.YYYYMMDD
               WHERE X.YYYYMMDD = Y.YYYYMMDD

		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 005 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;  


               INSERT INTO #SCP_XLS_PSI_GLOBAL_SMALL_PACK WITH (TABLOCK) 
               SELECT  DIVISION_ID
                      ,PLAN_START_YYYYMMDD
--					  ,CREATE_FROM_YYYYMMDD
--					  ,CREATE_TO_YYYYMMDD
                      ,PLAN_TYPE,SEQ
                      ,OPERATION_GROUP
                      ,OPERATION_GROUP_NAME
                      ,CELL_ITEM_ID
                      ,ITEM_ID
                      ,NICK_NAME
                      ,CELL_QTY_PACK
                      ,TO_SITE
                      ,TO_SITE_DESCRIPTION
                      ,PROJECT_CODE
                      ,FROM_BOH_QTY
                      ,TO_BOH_QTY
                      ,INCOTERMS
                      ,FROM_SITE
                      ,FROM_SITE_DESCRIPTION
                      ,TRANSPORT_MODE
                      ,PROD_LINE
                      ,LT_DAY
                      ,BOD_ID
                      ,MEASURE
                      ,MEASURE_LABEL
                      ,XLS_KEY1,XLS_KEY2,XLS_KEY3,XLS_KEY4,XLS_KEY5,XLS_ATTRIBUTE1,XLS_ATTRIBUTE2,XLS_ATTRIBUTE3,XLS_ATTRIBUTE4,XLS_ATTRIBUTE5
                      ,SORT_ORDER_NO
                      ,ISNULL(QTY001,0) AS [QTY001] ,ISNULL(QTY002,0) AS [QTY002], ISNULL(QTY003,0) AS [QTY003], ISNULL(QTY004,0) AS [QTY004], ISNULL(QTY005,0) AS [QTY005], ISNULL(QTY006,0) AS [QTY006], ISNULL(QTY007,0) AS [QTY007], ISNULL(QTY008,0) AS [QTY008], ISNULL(QTY009,0) AS [QTY009], ISNULL(QTY010,0) AS [QTY010]
                      ,ISNULL(QTY011,0) AS [QTY011] ,ISNULL(QTY012,0) AS [QTY012], ISNULL(QTY013,0) AS [QTY013], ISNULL(QTY014,0) AS [QTY014], ISNULL(QTY015,0) AS [QTY015], ISNULL(QTY016,0) AS [QTY016], ISNULL(QTY017,0) AS [QTY017], ISNULL(QTY018,0) AS [QTY018], ISNULL(QTY019,0) AS [QTY019], ISNULL(QTY020,0) AS [QTY020]
                      ,ISNULL(QTY021,0) AS [QTY021], ISNULL(QTY022,0) AS [QTY022], ISNULL(QTY023,0) AS [QTY023], ISNULL(QTY024,0) AS [QTY024], ISNULL(QTY025,0) AS [QTY025], ISNULL(QTY026,0) AS [QTY026], ISNULL(QTY027,0) AS [QTY027], ISNULL(QTY028,0) AS [QTY028], ISNULL(QTY029,0) AS [QTY029], ISNULL(QTY030,0) AS [QTY030]
                      ,ISNULL(QTY031,0) AS [QTY031], ISNULL(QTY032,0) AS [QTY032], ISNULL(QTY033,0) AS [QTY033], ISNULL(QTY034,0) AS [QTY034], ISNULL(QTY035,0) AS [QTY035], ISNULL(QTY036,0) AS [QTY036], ISNULL(QTY037,0) AS [QTY037], ISNULL(QTY038,0) AS [QTY038], ISNULL(QTY039,0) AS [QTY039], ISNULL(QTY040,0) AS [QTY040]
                      ,ISNULL(QTY041,0) AS [QTY041], ISNULL(QTY042,0) AS [QTY042], ISNULL(QTY043,0) AS [QTY043], ISNULL(QTY044,0) AS [QTY044], ISNULL(QTY045,0) AS [QTY045], ISNULL(QTY046,0) AS [QTY046], ISNULL(QTY047,0) AS [QTY047], ISNULL(QTY048,0) AS [QTY048], ISNULL(QTY049,0) AS [QTY049], ISNULL(QTY050,0) AS [QTY050]
                                                                                                                                                                                                                                                                                                                  
                      ,ISNULL(QTY051,0) AS [QTY051], ISNULL(QTY052,0) AS [QTY052], ISNULL(QTY053,0) AS [QTY053], ISNULL(QTY054,0) AS [QTY054], ISNULL(QTY055,0) AS [QTY055], ISNULL(QTY056,0) AS [QTY056], ISNULL(QTY057,0) AS [QTY057], ISNULL(QTY058,0) AS [QTY058], ISNULL(QTY059,0) AS [QTY059], ISNULL(QTY060,0) AS [QTY060]
                      ,ISNULL(QTY061,0) AS [QTY061], ISNULL(QTY062,0) AS [QTY062], ISNULL(QTY063,0) AS [QTY063], ISNULL(QTY064,0) AS [QTY064], ISNULL(QTY065,0) AS [QTY065], ISNULL(QTY066,0) AS [QTY066], ISNULL(QTY067,0) AS [QTY067], ISNULL(QTY068,0) AS [QTY068], ISNULL(QTY069,0) AS [QTY069], ISNULL(QTY070,0) AS [QTY070]
                      ,ISNULL(QTY071,0) AS [QTY071], ISNULL(QTY072,0) AS [QTY072], ISNULL(QTY073,0) AS [QTY073], ISNULL(QTY074,0) AS [QTY074], ISNULL(QTY075,0) AS [QTY075], ISNULL(QTY076,0) AS [QTY076], ISNULL(QTY077,0) AS [QTY077], ISNULL(QTY078,0) AS [QTY078], ISNULL(QTY079,0) AS [QTY079], ISNULL(QTY080,0) AS [QTY080]
                      ,ISNULL(QTY081,0) AS [QTY081], ISNULL(QTY082,0) AS [QTY082], ISNULL(QTY083,0) AS [QTY083], ISNULL(QTY084,0) AS [QTY084], ISNULL(QTY085,0) AS [QTY085], ISNULL(QTY086,0) AS [QTY086], ISNULL(QTY087,0) AS [QTY087], ISNULL(QTY088,0) AS [QTY088], ISNULL(QTY089,0) AS [QTY089], ISNULL(QTY090,0) AS [QTY090]
                      ,ISNULL(QTY091,0) AS [QTY091], ISNULL(QTY092,0) AS [QTY092], ISNULL(QTY093,0) AS [QTY093], ISNULL(QTY094,0) AS [QTY094], ISNULL(QTY095,0) AS [QTY095], ISNULL(QTY096,0) AS [QTY096], ISNULL(QTY097,0) AS [QTY097], ISNULL(QTY098,0) AS [QTY098], ISNULL(QTY099,0) AS [QTY099], ISNULL(QTY100,0) AS [QTY100]
                                                                                                                                                                                                                                                                                                                  
                      ,ISNULL(QTY101,0) AS [QTY101], ISNULL(QTY102,0) AS [QTY102], ISNULL(QTY103,0) AS [QTY103], ISNULL(QTY104,0) AS [QTY104], ISNULL(QTY105,0) AS [QTY105], ISNULL(QTY106,0) AS [QTY106], ISNULL(QTY107,0) AS [QTY107], ISNULL(QTY108,0) AS [QTY108], ISNULL(QTY109,0) AS [QTY109], ISNULL(QTY110,0) AS [QTY110]
                      ,ISNULL(QTY111,0) AS [QTY111], ISNULL(QTY112,0) AS [QTY112], ISNULL(QTY113,0) AS [QTY113], ISNULL(QTY114,0) AS [QTY114], ISNULL(QTY115,0) AS [QTY115], ISNULL(QTY116,0) AS [QTY116], ISNULL(QTY117,0) AS [QTY117], ISNULL(QTY118,0) AS [QTY118], ISNULL(QTY119,0) AS [QTY119], ISNULL(QTY120,0) AS [QTY120]
                      ,ISNULL(QTY121,0) AS [QTY121], ISNULL(QTY122,0) AS [QTY122], ISNULL(QTY123,0) AS [QTY123], ISNULL(QTY124,0) AS [QTY124], ISNULL(QTY125,0) AS [QTY125], ISNULL(QTY126,0) AS [QTY126], ISNULL(QTY127,0) AS [QTY127], ISNULL(QTY128,0) AS [QTY128], ISNULL(QTY129,0) AS [QTY129], ISNULL(QTY130,0) AS [QTY130]
                      ,ISNULL(QTY131,0) AS [QTY131], ISNULL(QTY132,0) AS [QTY132], ISNULL(QTY133,0) AS [QTY133], ISNULL(QTY134,0) AS [QTY134], ISNULL(QTY135,0) AS [QTY135], ISNULL(QTY136,0) AS [QTY136], ISNULL(QTY137,0) AS [QTY137], ISNULL(QTY138,0) AS [QTY138], ISNULL(QTY139,0) AS [QTY139], ISNULL(QTY140,0) AS [QTY140]
                      ,ISNULL(QTY141,0) AS [QTY141], ISNULL(QTY142,0) AS [QTY142], ISNULL(QTY143,0) AS [QTY143], ISNULL(QTY144,0) AS [QTY144], ISNULL(QTY145,0) AS [QTY145], ISNULL(QTY146,0) AS [QTY146], ISNULL(QTY147,0) AS [QTY147], ISNULL(QTY148,0) AS [QTY148], ISNULL(QTY149,0) AS [QTY149], ISNULL(QTY150,0) AS [QTY150]
                                                                                                                                                                                                                                                                                                                  
                      ,ISNULL(QTY151,0) AS [QTY151], ISNULL(QTY152,0) AS [QTY152], ISNULL(QTY153,0) AS [QTY153], ISNULL(QTY154,0) AS [QTY154], ISNULL(QTY155,0) AS [QTY155], ISNULL(QTY156,0) AS [QTY156], ISNULL(QTY157,0) AS [QTY157], ISNULL(QTY158,0) AS [QTY158], ISNULL(QTY159,0) AS [QTY159], ISNULL(QTY160,0) AS [QTY160]
                      ,ISNULL(QTY161,0) AS [QTY161], ISNULL(QTY162,0) AS [QTY162], ISNULL(QTY163,0) AS [QTY162], ISNULL(QTY164,0) AS [QTY164], ISNULL(QTY165,0) AS [QTY165], ISNULL(QTY166,0) AS [QTY166], ISNULL(QTY167,0) AS [QTY167], ISNULL(QTY168,0) AS [QTY168], ISNULL(QTY169,0) AS [QTY169], ISNULL(QTY170,0) AS [QTY170]
                      ,ISNULL(QTY171,0) AS [QTY171], ISNULL(QTY172,0) AS [QTY172], ISNULL(QTY173,0) AS [QTY173], ISNULL(QTY174,0) AS [QTY174], ISNULL(QTY175,0) AS [QTY175], ISNULL(QTY176,0) AS [QTY176], ISNULL(QTY177,0) AS [QTY177], ISNULL(QTY178,0) AS [QTY178], ISNULL(QTY179,0) AS [QTY179], ISNULL(QTY180,0) AS [QTY180]
                      ,ISNULL(QTY181,0) AS [QTY181], ISNULL(QTY182,0) AS [QTY182], ISNULL(QTY183,0) AS [QTY183], ISNULL(QTY184,0) AS [QTY184], ISNULL(QTY185,0) AS [QTY185], ISNULL(QTY186,0) AS [QTY186], ISNULL(QTY187,0) AS [QTY187], ISNULL(QTY188,0) AS [QTY188], ISNULL(QTY189,0) AS [QTY189], ISNULL(QTY190,0) AS [QTY190]
                      ,ISNULL(QTY191,0) AS [QTY191], ISNULL(QTY192,0) AS [QTY192], ISNULL(QTY193,0) AS [QTY193], ISNULL(QTY194,0) AS [QTY194], ISNULL(QTY195,0) AS [QTY195], ISNULL(QTY196,0) AS [QTY196], ISNULL(QTY197,0) AS [QTY197], ISNULL(QTY198,0) AS [QTY198], ISNULL(QTY199,0) AS [QTY199], ISNULL(QTY200,0) AS [QTY200]
                                                                                                                                                                                                                                                                                                                  
                      ,ISNULL(QTY201,0) AS [QTY201], ISNULL(QTY202,0) AS [QTY202], ISNULL(QTY203,0) AS [QTY203], ISNULL(QTY204,0) AS [QTY204], ISNULL(QTY205,0) AS [QTY205], ISNULL(QTY206,0) AS [QTY206], ISNULL(QTY207,0) AS [QTY207], ISNULL(QTY208,0) AS [QTY208], ISNULL(QTY209,0) AS [QTY209], ISNULL(QTY210,0) AS [QTY210]
                      ,ISNULL(QTY211,0) AS [QTY211], ISNULL(QTY212,0) AS [QTY212], ISNULL(QTY213,0) AS [QTY213], ISNULL(QTY214,0) AS [QTY214], ISNULL(QTY215,0) AS [QTY215], ISNULL(QTY216,0) AS [QTY216], ISNULL(QTY217,0) AS [QTY217], ISNULL(QTY218,0) AS [QTY218], ISNULL(QTY219,0) AS [QTY219], ISNULL(QTY220,0) AS [QTY220]
                      ,ISNULL(QTY221,0) AS [QTY221], ISNULL(QTY222,0) AS [QTY222], ISNULL(QTY223,0) AS [QTY223], ISNULL(QTY224,0) AS [QTY224], ISNULL(QTY225,0) AS [QTY225], ISNULL(QTY226,0) AS [QTY226], ISNULL(QTY227,0) AS [QTY227], ISNULL(QTY228,0) AS [QTY228], ISNULL(QTY229,0) AS [QTY229], ISNULL(QTY230,0) AS [QTY230]
                      ,ISNULL(QTY231,0) AS [QTY231], ISNULL(QTY232,0) AS [QTY232], ISNULL(QTY233,0) AS [QTY233], ISNULL(QTY234,0) AS [QTY234], ISNULL(QTY235,0) AS [QTY235], ISNULL(QTY236,0) AS [QTY236], ISNULL(QTY237,0) AS [QTY237], ISNULL(QTY238,0) AS [QTY238], ISNULL(QTY239,0) AS [QTY239], ISNULL(QTY240,0) AS [QTY240]
                      ,ISNULL(QTY241,0) AS [QTY241], ISNULL(QTY242,0) AS [QTY242], ISNULL(QTY243,0) AS [QTY243], ISNULL(QTY244,0) AS [QTY244], ISNULL(QTY245,0) AS [QTY245], ISNULL(QTY246,0) AS [QTY246], ISNULL(QTY247,0) AS [QTY247], ISNULL(QTY248,0) AS [QTY248], ISNULL(QTY249,0) AS [QTY249], ISNULL(QTY250,0) AS [QTY250]
                                                                                                                                                                                                                                                                                                                  
                      ,ISNULL(QTY251,0) AS [QTY251], ISNULL(QTY252,0) AS [QTY252], ISNULL(QTY253,0) AS [QTY253], ISNULL(QTY254,0) AS [QTY254], ISNULL(QTY255,0) AS [QTY255], ISNULL(QTY256,0) AS [QTY256], ISNULL(QTY257,0) AS [QTY257], ISNULL(QTY258,0) AS [QTY258], ISNULL(QTY259,0) AS [QTY259], ISNULL(QTY260,0) AS [QTY260]
                      ,ISNULL(QTY261,0) AS [QTY261], ISNULL(QTY262,0) AS [QTY262], ISNULL(QTY263,0) AS [QTY263], ISNULL(QTY264,0) AS [QTY264], ISNULL(QTY265,0) AS [QTY265], ISNULL(QTY266,0) AS [QTY266], ISNULL(QTY267,0) AS [QTY267], ISNULL(QTY268,0) AS [QTY268], ISNULL(QTY269,0) AS [QTY269], ISNULL(QTY270,0) AS [QTY270]
                      ,ISNULL(QTY271,0) AS [QTY271], ISNULL(QTY272,0) AS [QTY272], ISNULL(QTY273,0) AS [QTY273], ISNULL(QTY274,0) AS [QTY274], ISNULL(QTY275,0) AS [QTY275], ISNULL(QTY276,0) AS [QTY276], ISNULL(QTY277,0) AS [QTY277], ISNULL(QTY278,0) AS [QTY278], ISNULL(QTY279,0) AS [QTY279], ISNULL(QTY280,0) AS [QTY280]
                      ,ISNULL(QTY281,0) AS [QTY281], ISNULL(QTY282,0) AS [QTY282], ISNULL(QTY283,0) AS [QTY283], ISNULL(QTY284,0) AS [QTY284], ISNULL(QTY285,0) AS [QTY285], ISNULL(QTY286,0) AS [QTY286], ISNULL(QTY287,0) AS [QTY287], ISNULL(QTY288,0) AS [QTY288], ISNULL(QTY289,0) AS [QTY289], ISNULL(QTY290,0) AS [QTY290]
                      ,ISNULL(QTY291,0) AS [QTY291], ISNULL(QTY292,0) AS [QTY292], ISNULL(QTY293,0) AS [QTY293], ISNULL(QTY294,0) AS [QTY294], ISNULL(QTY295,0) AS [QTY295], ISNULL(QTY296,0) AS [QTY296], ISNULL(QTY297,0) AS [QTY297], ISNULL(QTY298,0) AS [QTY298], ISNULL(QTY299,0) AS [QTY299], ISNULL(QTY300,0) AS [QTY300]
                                                                                                                                                                                                                                                                                                                  
                      ,ISNULL(QTY301,0) AS [QTY301], ISNULL(QTY302,0) AS [QTY302], ISNULL(QTY303,0) AS [QTY303], ISNULL(QTY304,0) AS [QTY304], ISNULL(QTY305,0) AS [QTY305], ISNULL(QTY306,0) AS [QTY306], ISNULL(QTY307,0) AS [QTY307], ISNULL(QTY308,0) AS [QTY308], ISNULL(QTY309,0) AS [QTY309], ISNULL(QTY310,0) AS [QTY310]
                      ,ISNULL(QTY311,0) AS [QTY311], ISNULL(QTY312,0) AS [QTY312], ISNULL(QTY313,0) AS [QTY313], ISNULL(QTY314,0) AS [QTY314], ISNULL(QTY315,0) AS [QTY315], ISNULL(QTY316,0) AS [QTY316], ISNULL(QTY317,0) AS [QTY317], ISNULL(QTY318,0) AS [QTY318], ISNULL(QTY319,0) AS [QTY319], ISNULL(QTY320,0) AS [QTY320]
                      ,ISNULL(QTY321,0) AS [QTY321], ISNULL(QTY322,0) AS [QTY322], ISNULL(QTY323,0) AS [QTY323], ISNULL(QTY324,0) AS [QTY324], ISNULL(QTY325,0) AS [QTY325], ISNULL(QTY326,0) AS [QTY326], ISNULL(QTY327,0) AS [QTY327], ISNULL(QTY328,0) AS [QTY328], ISNULL(QTY329,0) AS [QTY329], ISNULL(QTY330,0) AS [QTY330]
                      ,ISNULL(QTY331,0) AS [QTY331], ISNULL(QTY332,0) AS [QTY332], ISNULL(QTY333,0) AS [QTY333], ISNULL(QTY334,0) AS [QTY334], ISNULL(QTY335,0) AS [QTY335], ISNULL(QTY336,0) AS [QTY336], ISNULL(QTY337,0) AS [QTY337], ISNULL(QTY338,0) AS [QTY338], ISNULL(QTY339,0) AS [QTY339], ISNULL(QTY340,0) AS [QTY340]
                      ,ISNULL(QTY341,0) AS [QTY341], ISNULL(QTY342,0) AS [QTY342], ISNULL(QTY343,0) AS [QTY343], ISNULL(QTY344,0) AS [QTY344], ISNULL(QTY345,0) AS [QTY345], ISNULL(QTY346,0) AS [QTY346], ISNULL(QTY347,0) AS [QTY347], ISNULL(QTY348,0) AS [QTY348], ISNULL(QTY349,0) AS [QTY349], ISNULL(QTY350,0) AS [QTY350]
                                                                                                                                                                                                                                                                                                                  
                      ,ISNULL(QTY351,0) AS [QTY351], ISNULL(QTY352,0) AS [QTY352], ISNULL(QTY353,0) AS [QTY353], ISNULL(QTY354,0) AS [QTY354], ISNULL(QTY355,0) AS [QTY355], ISNULL(QTY356,0) AS [QTY356], ISNULL(QTY357,0) AS [QTY357], ISNULL(QTY358,0) AS [QTY358], ISNULL(QTY359,0) AS [QTY359], ISNULL(QTY360,0) AS [QTY360]
                      ,ISNULL(QTY361,0) AS [QTY361], ISNULL(QTY362,0) AS [QTY362], ISNULL(QTY363,0) AS [QTY363], ISNULL(QTY364,0) AS [QTY364]
                      , ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                FROM
                (
                  SELECT  @p_division_id  AS DIVISION_ID														
                        , @p_plan_start_yyyymmdd	  AS PLAN_START_YYYYMMDD
						
			--			, @p_create_from_yyyymmdd  AS CREATE_FROM_YYYYMMDD
			--			, @p_create_to_yyyymmdd    AS CREATE_TO_YYYYMMDD
						
                        , @p_plan_type	            AS PLAN_TYPE
                        , @p_seq	                  AS SEQ
                        , A.OPERATION_GROUP						
                        , NULL AS OPERATION_GROUP_NAME    
                        , A.CELL_ITEM_ID				
                        , A.ITEM_ID							
                        , NULL AS   NICK_NAME	
                        , '0' AS 	CELL_QTY_PACK  -- 완료후 UPDATE						
                        , A.TO_SITE							
                        , NULL AS  TO_SITE_DESCRIPTION	
                        , A.PROJECT_CODE		
                        , A.FROM_BOH_QTY												
                        , A.TO_BOH_QTY													
                        , ISNULL(NULLIF( A.INCOTERMS, '') , '-') AS INCOTERMS	
                        , A.FROM_SITE								
                        , '-' AS  FROM_SITE_DESCRIPTION	
                        , ISNULL(A.TRANSPORT_MODE,'-') AS   TRANSPORT_MODE 
                        , ISNULL(A.PROD_LINE,'-')  AS      PROD_LINE     
                        , '' AS LT_DAY  -- 완료후 UPDATE
                        , A.BOD_ID			
                        , A.MEASURE
                        , A.COLUMN_LABEL_NAME           AS MEASURE_LABEL 
 		                    , CONVERT(NVARCHAR(200), NULL)  AS XLS_KEY1
                        , CONVERT(NVARCHAR(200), NULL)  AS XLS_KEY2
                        , CONVERT(NVARCHAR(200), NULL)  AS XLS_KEY3
                        , CONVERT(NVARCHAR(200), NULL)  AS XLS_KEY4
                        , CONVERT(NVARCHAR(200), NULL)  AS XLS_KEY5
                        , CONVERT(NVARCHAR(200), NULL)  AS XLS_ATTRIBUTE1
                        , CONVERT(NVARCHAR(200), NULL)  AS XLS_ATTRIBUTE2
                        , CONVERT(NVARCHAR(200), NULL)  AS XLS_ATTRIBUTE3
                        , CONVERT(NVARCHAR(200), NULL)  AS XLS_ATTRIBUTE4
                        , CONVERT(NVARCHAR(200), NULL)  AS XLS_ATTRIBUTE5
                        , A.SORT_ORDER_NO			

						-- 2021.03.26   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 0값 제거에 따른 로직보완 - start
						-- Measure 중복방지를 위한 처리
						--
                        --, A.ATTRIBUTE1
						, '-'  AS ATTRIBUTE1
						-- 2021.03.26   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 0값 제거에 따른 로직보완 - end

                        , NULL AS ATTRIBUTE2, NULL AS ATTRIBUTE3, NULL AS ATTRIBUTE4, NULL AS ATTRIBUTE5, NULL AS ATTRIBUTE6, NULL AS ATTRIBUTE7, NULL AS ATTRIBUTE8
                        , A.ATTRIBUTE9, A.ATTRIBUTE10  
                        , A.QTY
                        , A.WEEK_COLUMN
                   FROM ##PSI_GLOBAL_SMALL_PACK A WITH (NOLOCK)
				   WHERE A.YYYYMMDD           >= @p_create_from_yyyymmdd
				   AND   A.YYYYMMDD           <=  @p_create_to_yyyymmdd

                ) AS X
                PIVOT (
                  SUM(QTY)
                  FOR WEEK_COLUMN IN (
                                         [QTY001],[QTY002],[QTY003],[QTY004],[QTY005],[QTY006],[QTY007],[QTY008],[QTY009],[QTY010]
                                        ,[QTY011],[QTY012],[QTY013],[QTY014],[QTY015],[QTY016],[QTY017],[QTY018],[QTY019],[QTY020]
                                        ,[QTY021],[QTY022],[QTY023],[QTY024],[QTY025],[QTY026],[QTY027],[QTY028],[QTY029],[QTY030]
                                        ,[QTY031],[QTY032],[QTY033],[QTY034],[QTY035],[QTY036],[QTY037],[QTY038],[QTY039],[QTY040]
                                        ,[QTY041],[QTY042],[QTY043],[QTY044],[QTY045],[QTY046],[QTY047],[QTY048],[QTY049],[QTY050]
                    
                                        ,[QTY051],[QTY052],[QTY053],[QTY054],[QTY055],[QTY056],[QTY057],[QTY058],[QTY059],[QTY060]
                                        ,[QTY061],[QTY062],[QTY063],[QTY064],[QTY065],[QTY066],[QTY067],[QTY068],[QTY069],[QTY070]
                                        ,[QTY071],[QTY072],[QTY073],[QTY074],[QTY075],[QTY076],[QTY077],[QTY078],[QTY079],[QTY080]
                                        ,[QTY081],[QTY082],[QTY083],[QTY084],[QTY085],[QTY086],[QTY087],[QTY088],[QTY089],[QTY090]
                                        ,[QTY091],[QTY092],[QTY093],[QTY094],[QTY095],[QTY096],[QTY097],[QTY098],[QTY099],[QTY100]
                      
                                        ,[QTY101],[QTY102],[QTY103],[QTY104],[QTY105],[QTY106],[QTY107],[QTY108],[QTY109],[QTY110]
                                        ,[QTY111],[QTY112],[QTY113],[QTY114],[QTY115],[QTY116],[QTY117],[QTY118],[QTY119],[QTY120]
                                        ,[QTY121],[QTY122],[QTY123],[QTY124],[QTY125],[QTY126],[QTY127],[QTY128],[QTY129],[QTY130]
                                        ,[QTY131],[QTY132],[QTY133],[QTY134],[QTY135],[QTY136],[QTY137],[QTY138],[QTY139],[QTY140]
                                        ,[QTY141],[QTY142],[QTY143],[QTY144],[QTY145],[QTY146],[QTY147],[QTY148],[QTY149],[QTY150]
                      
                                        ,[QTY151],[QTY152],[QTY153],[QTY154],[QTY155],[QTY156],[QTY157],[QTY158],[QTY159],[QTY160]
                                        ,[QTY161],[QTY162],[QTY163],[QTY164],[QTY165],[QTY166],[QTY167],[QTY168],[QTY169],[QTY170]
                                        ,[QTY171],[QTY172],[QTY173],[QTY174],[QTY175],[QTY176],[QTY177],[QTY178],[QTY179],[QTY180]
                                        ,[QTY181],[QTY182],[QTY183],[QTY184],[QTY185],[QTY186],[QTY187],[QTY188],[QTY189],[QTY190]
                                        ,[QTY191],[QTY192],[QTY193],[QTY194],[QTY195],[QTY196],[QTY197],[QTY198],[QTY199],[QTY200]
                                   
                                        ,[QTY201],[QTY202],[QTY203],[QTY204],[QTY205],[QTY206],[QTY207],[QTY208],[QTY209],[QTY210]
                                        ,[QTY211],[QTY212],[QTY213],[QTY214],[QTY215],[QTY216],[QTY217],[QTY218],[QTY219],[QTY220]
                                        ,[QTY221],[QTY222],[QTY223],[QTY224],[QTY225],[QTY226],[QTY227],[QTY228],[QTY229],[QTY230]
                                        ,[QTY231],[QTY232],[QTY233],[QTY234],[QTY235],[QTY236],[QTY237],[QTY238],[QTY239],[QTY240]
                                        ,[QTY241],[QTY242],[QTY243],[QTY244],[QTY245],[QTY246],[QTY247],[QTY248],[QTY249],[QTY250]
                                          
                                        ,[QTY251],[QTY252],[QTY253],[QTY254],[QTY255],[QTY256],[QTY257],[QTY258],[QTY259],[QTY260]
                                        ,[QTY261],[QTY262],[QTY263],[QTY264],[QTY265],[QTY266],[QTY267],[QTY268],[QTY269],[QTY270]
                                        ,[QTY271],[QTY272],[QTY273],[QTY274],[QTY275],[QTY276],[QTY277],[QTY278],[QTY279],[QTY280]
                                        ,[QTY281],[QTY282],[QTY283],[QTY284],[QTY285],[QTY286],[QTY287],[QTY288],[QTY289],[QTY290]
                                        ,[QTY291],[QTY292],[QTY293],[QTY294],[QTY295],[QTY296],[QTY297],[QTY298],[QTY299],[QTY300]
                                       
                                        ,[QTY301],[QTY302],[QTY303],[QTY304],[QTY305],[QTY306],[QTY307],[QTY308],[QTY309],[QTY310]
                                        ,[QTY311],[QTY312],[QTY313],[QTY314],[QTY315],[QTY316],[QTY317],[QTY318],[QTY319],[QTY320]
                                        ,[QTY321],[QTY322],[QTY323],[QTY324],[QTY325],[QTY326],[QTY327],[QTY328],[QTY329],[QTY330]
                                        ,[QTY331],[QTY332],[QTY333],[QTY334],[QTY335],[QTY336],[QTY337],[QTY338],[QTY339],[QTY340]
                                        ,[QTY341],[QTY342],[QTY343],[QTY344],[QTY345],[QTY346],[QTY347],[QTY348],[QTY349],[QTY350]
                         
                                        ,[QTY351],[QTY352],[QTY353],[QTY354],[QTY355],[QTY356],[QTY357],[QTY358],[QTY359],[QTY360]
                                        ,[QTY361],[QTY362],[QTY363],[QTY364]
                                    )
                    ) X

		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 006 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;  
										
                 UPDATE X
                    SET X.OPERATION_GROUP_NAME = Y.SEGMENT2
                    FROM #SCP_XLS_PSI_GLOBAL_SMALL_PACK X  WITH (NOLOCK)
                    INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL Y  WITH (NOLOCK)
                        ON Y.LOOKUP_TYPE = 'OPERATION_GROUP' 
                       AND Y.SEGMENT1    = X.OPERATION_GROUP

		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 007 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;  

                 UPDATE X
                    SET X.NICK_NAME = ISNULL(NULLIF( Y.NICK_NAME, '') , '-') 
                    FROM #SCP_XLS_PSI_GLOBAL_SMALL_PACK X  WITH (NOLOCK)
                    LEFT JOIN SCM_MST_ITEM_SN Y  WITH (NOLOCK)
                        ON Y.ITEM_ID = X.ITEM_ID

		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 008 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;  
                

                 UPDATE X
                    SET X.TO_SITE_DESCRIPTION = ISNULL(NULLIF( Y.SITE_DESCRIPTION, '') , '-')
                    FROM #SCP_XLS_PSI_GLOBAL_SMALL_PACK X  WITH (NOLOCK)
                    LEFT JOIN SCM_MST_SITE Y  WITH (NOLOCK)
                        ON Y.SCM_SITE_ID = X.TO_SITE

		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 009 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;  


                 UPDATE X
                    SET X.FROM_SITE_DESCRIPTION = ISNULL(NULLIF( Y.SITE_DESCRIPTION, '') , '-')
                    FROM #SCP_XLS_PSI_GLOBAL_SMALL_PACK X  WITH (NOLOCK)
                    LEFT JOIN SCM_MST_SITE Y  WITH (NOLOCK)   -- 250303, KSK, 키가 없을경우에도 작동하도록
                        ON Y.SCM_SITE_ID = X.FROM_SITE

		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 010 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;  

				---PRINT 'LABEL COMPLETE';
 -------------------------------------------------------------------------------------------------------------         
            -- TRANSPORT_MODE, LINE_ID 추가
            -------------------------------------------------------------------------------------------------------------            
			
            IF OBJECT_ID('tempdb..#TRANSPORT_MODE') IS NOT NULL      
	                DROP TABLE #TRANSPORT_MODE;

                SELECT DISTINCT X.DIVISION_ID,X.FROM_SITE,X.TO_SITE,X.INCOTERMS,X.TRANSPORT_MODE,X.LT_TOTAL, X.BOD_ID,Y.PROJECT_CODE 
                INTO #TRANSPORT_MODE
                FROM #SCP_MST_BOD_V X
                LEFT OUTER JOIN #SCP_XLS_PSI_GLOBAL_SMALL_PACK Y
                ON X.DIVISION_ID  = Y.DIVISION_ID
                AND X.FROM_SITE   = Y.FROM_SITE
                AND X.TO_SITE     = Y.TO_SITE
                AND X.INCOTERMS   = Y.INCOTERMS
                AND Y.PROJECT_CODE <> '-'
				AND X.BOD_ID      = Y.BOD_ID			-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 BOD_ID 추가
                WHERE ISNULL(Y.PROJECT_CODE ,'') <> ''

		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 011 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;  
                

            -- 'SHIP_PLAN'의 TRANSPORT_MODE 종류 별 추가 
               INSERT INTO #SCP_XLS_PSI_GLOBAL_SMALL_PACK 
                SELECT X.DIVISION_ID
                      ,PLAN_START_YYYYMMDD
			--		  	, @p_create_from_yyyymmdd 
			--			, @p_create_to_yyyymmdd   
                      ,PLAN_TYPE
                      ,SEQ
                      ,OPERATION_GROUP
                      ,OPERATION_GROUP_NAME
                      ,CELL_ITEM_ID
                      ,ITEM_ID
                      ,NICK_NAME
                      ,CELL_QTY_PACK
                      ,X.TO_SITE
                      ,TO_SITE_DESCRIPTION
                      ,X.PROJECT_CODE
                      ,FROM_BOH_QTY
                      ,TO_BOH_QTY
                      ,X.INCOTERMS
                      ,X.FROM_SITE
                      ,FROM_SITE_DESCRIPTION
                      ,Y.TRANSPORT_MODE
                      ,PROD_LINE
                      ,Y.LT_TOTAL AS LT_DAY
                      ,Y.BOD_ID
                      ,MEASURE
                      ,MEASURE_LABEL
                      ,XLS_KEY1
                      ,XLS_KEY2
                      ,XLS_KEY3
                      ,XLS_KEY4
                      ,XLS_KEY5
                      ,XLS_ATTRIBUTE1
                      ,XLS_ATTRIBUTE2
                      ,XLS_ATTRIBUTE3
                      ,XLS_ATTRIBUTE4
                      ,XLS_ATTRIBUTE5
                      --,CALC_YN
                      --,DISPLAY_YN
                      ,SORT_ORDER_NO
                      ,0  AS QTY001 ,0  AS QTY002,0  AS QTY003,0  AS QTY004,0  AS QTY005,0  AS QTY006 ,0  AS QTY007,0  AS QTY008,0  AS QTY009,0  AS QTY010
                      ,0  AS QTY011 ,0  AS QTY012,0  AS QTY013,0  AS QTY014,0  AS QTY015,0  AS QTY016 ,0  AS QTY017,0  AS QTY018,0  AS QTY019,0  AS QTY020
                      ,0  AS QTY021 ,0  AS QTY022,0  AS QTY023,0  AS QTY024,0  AS QTY025,0  AS QTY026 ,0  AS QTY027,0  AS QTY028,0  AS QTY029,0  AS QTY030
                      ,0  AS QTY031 ,0  AS QTY032,0  AS QTY033,0  AS QTY034,0  AS QTY035,0  AS QTY036 ,0  AS QTY037,0  AS QTY038,0  AS QTY039,0  AS QTY040
                      ,0  AS QTY041 ,0  AS QTY042,0  AS QTY043,0  AS QTY044,0  AS QTY045,0  AS QTY046 ,0  AS QTY047,0  AS QTY048,0  AS QTY049,0  AS QTY050
                      ,0  AS QTY051 ,0  AS QTY052,0  AS QTY053,0  AS QTY054,0  AS QTY055,0  AS QTY056 ,0  AS QTY057,0  AS QTY058,0  AS QTY059,0  AS QTY060
                      ,0  AS QTY061 ,0  AS QTY062,0  AS QTY063,0  AS QTY064,0  AS QTY065,0  AS QTY066 ,0  AS QTY067,0  AS QTY068,0  AS QTY069,0  AS QTY070
                      ,0  AS QTY071 ,0  AS QTY072,0  AS QTY073,0  AS QTY074,0  AS QTY075,0  AS QTY076 ,0  AS QTY077,0  AS QTY078,0  AS QTY079,0  AS QTY080
                      ,0  AS QTY081 ,0  AS QTY082,0  AS QTY083,0  AS QTY084,0  AS QTY085,0  AS QTY086 ,0  AS QTY087,0  AS QTY088,0  AS QTY089,0  AS QTY090
                      ,0  AS QTY091 ,0  AS QTY092,0  AS QTY093,0  AS QTY094,0  AS QTY095,0  AS QTY096 ,0  AS QTY097,0  AS QTY098,0  AS QTY099,0  AS QTY100

                      ,0  AS QTY101 ,0  AS QTY102,0  AS QTY103,0  AS QTY104,0  AS QTY105,0  AS QTY106 ,0  AS QTY107,0  AS QTY108,0  AS QTY109,0  AS QTY110
                      ,0  AS QTY111 ,0  AS QTY112,0  AS QTY113,0  AS QTY114,0  AS QTY115,0  AS QTY116 ,0  AS QTY117,0  AS QTY118,0  AS QTY119,0  AS QTY120
                      ,0  AS QTY121 ,0  AS QTY122,0  AS QTY123,0  AS QTY124,0  AS QTY125,0  AS QTY126 ,0  AS QTY127,0  AS QTY128,0  AS QTY129,0  AS QTY130
                      ,0  AS QTY131 ,0  AS QTY132,0  AS QTY133,0  AS QTY134,0  AS QTY135,0  AS QTY136 ,0  AS QTY137,0  AS QTY138,0  AS QTY139,0  AS QTY140
                      ,0  AS QTY141 ,0  AS QTY142,0  AS QTY143,0  AS QTY144,0  AS QTY145,0  AS QTY146 ,0  AS QTY147,0  AS QTY148,0  AS QTY149,0  AS QTY150
                      ,0  AS QTY151 ,0  AS QTY152,0  AS QTY153,0  AS QTY154,0  AS QTY155,0  AS QTY156 ,0  AS QTY157,0  AS QTY158,0  AS QTY159,0  AS QTY160
                      ,0  AS QTY161 ,0  AS QTY162,0  AS QTY163,0  AS QTY164,0  AS QTY165,0  AS QTY166 ,0  AS QTY167,0  AS QTY168,0  AS QTY169,0  AS QTY170
                      ,0  AS QTY171 ,0  AS QTY172,0  AS QTY173,0  AS QTY174,0  AS QTY175,0  AS QTY176 ,0  AS QTY177,0  AS QTY178,0  AS QTY179,0  AS QTY180
                      ,0  AS QTY181 ,0  AS QTY182,0  AS QTY183,0  AS QTY184,0  AS QTY185,0  AS QTY186 ,0  AS QTY187,0  AS QTY188,0  AS QTY189,0  AS QTY190
                      ,0  AS QTY191 ,0  AS QTY192,0  AS QTY193,0  AS QTY194,0  AS QTY195,0  AS QTY196 ,0  AS QTY197,0  AS QTY198,0  AS QTY199,0  AS QTY200

                      ,0  AS QTY201 ,0  AS QTY202,0  AS QTY203,0  AS QTY204,0  AS QTY205,0  AS QTY206 ,0  AS QTY207,0  AS QTY208,0  AS QTY209,0  AS QTY210
                      ,0  AS QTY211 ,0  AS QTY212,0  AS QTY213,0  AS QTY214,0  AS QTY215,0  AS QTY216 ,0  AS QTY217,0  AS QTY218,0  AS QTY219,0  AS QTY220
                      ,0  AS QTY221 ,0  AS QTY222,0  AS QTY223,0  AS QTY224,0  AS QTY225,0  AS QTY226 ,0  AS QTY227,0  AS QTY228,0  AS QTY229,0  AS QTY230
                      ,0  AS QTY231 ,0  AS QTY232,0  AS QTY233,0  AS QTY234,0  AS QTY235,0  AS QTY236 ,0  AS QTY237,0  AS QTY238,0  AS QTY239,0  AS QTY240
                      ,0  AS QTY241 ,0  AS QTY242,0  AS QTY243,0  AS QTY244,0  AS QTY245,0  AS QTY246 ,0  AS QTY247,0  AS QTY248,0  AS QTY249,0  AS QTY250
                      ,0  AS QTY251 ,0  AS QTY252,0  AS QTY253,0  AS QTY254,0  AS QTY255,0  AS QTY256 ,0  AS QTY257,0  AS QTY258,0  AS QTY259,0  AS QTY260
                      ,0  AS QTY261 ,0  AS QTY262,0  AS QTY263,0  AS QTY264,0  AS QTY265,0  AS QTY266 ,0  AS QTY267,0  AS QTY268,0  AS QTY269,0  AS QTY270
                      ,0  AS QTY271 ,0  AS QTY272,0  AS QTY273,0  AS QTY274,0  AS QTY275,0  AS QTY276 ,0  AS QTY277,0  AS QTY278,0  AS QTY279,0  AS QTY280
                      ,0  AS QTY281 ,0  AS QTY282,0  AS QTY283,0  AS QTY284,0  AS QTY285,0  AS QTY286 ,0  AS QTY287,0  AS QTY288,0  AS QTY289,0  AS QTY290
                      ,0  AS QTY291 ,0  AS QTY292,0  AS QTY293,0  AS QTY294,0  AS QTY295,0  AS QTY296 ,0  AS QTY297,0  AS QTY298,0  AS QTY299,0  AS QTY300

                      ,0  AS QTY301 ,0  AS QTY302,0  AS QTY303,0  AS QTY304,0  AS QTY305,0  AS QTY306 ,0  AS QTY307,0  AS QTY308,0  AS QTY309,0  AS QTY310
                      ,0  AS QTY311 ,0  AS QTY312,0  AS QTY313,0  AS QTY314,0  AS QTY315,0  AS QTY316 ,0  AS QTY317,0  AS QTY318,0  AS QTY319,0  AS QTY320
                      ,0  AS QTY321 ,0  AS QTY322,0  AS QTY323,0  AS QTY324,0  AS QTY325,0  AS QTY326 ,0  AS QTY327,0  AS QTY328,0  AS QTY329,0  AS QTY330
                      ,0  AS QTY331 ,0  AS QTY332,0  AS QTY333,0  AS QTY334,0  AS QTY335,0  AS QTY336 ,0  AS QTY337,0  AS QTY338,0  AS QTY339,0  AS QTY340
                      ,0  AS QTY341 ,0  AS QTY342,0  AS QTY343,0  AS QTY344,0  AS QTY345,0  AS QTY346 ,0  AS QTY347,0  AS QTY348,0  AS QTY349,0  AS QTY350
                      ,0  AS QTY351 ,0  AS QTY352,0  AS QTY353,0  AS QTY354,0  AS QTY355,0  AS QTY356 ,0  AS QTY357,0  AS QTY358,0  AS QTY359,0  AS QTY360
                      ,0  AS QTY361 ,0  AS QTY362,0  AS QTY363,0  AS QTY364                  
                      --,X.CREATED_BY
                      --,X.CREATION_DATE
                      --,X.LAST_UPDATED_BY
                      --,X.LAST_UPDATE_DATE
                      ,X.ATTRIBUTE1
                      ,X.ATTRIBUTE2
                      ,X.ATTRIBUTE3
                      ,X.ATTRIBUTE4
                      ,X.ATTRIBUTE5
                      ,X.ATTRIBUTE6
                      ,X.ATTRIBUTE7
                      ,X.ATTRIBUTE8
                      ,X.ATTRIBUTE9
                      ,X.ATTRIBUTE10
                      FROM #SCP_XLS_PSI_GLOBAL_SMALL_PACK X WITH (NOLOCK) 
                      OUTER APPLY #TRANSPORT_MODE Y  WITH (NOLOCK)
                      WHERE 0 = 0
                      AND X.DIVISION_ID     = Y.DIVISION_ID
                      AND X.FROM_SITE       = Y.FROM_SITE
                      AND X.TO_SITE         = Y.TO_SITE
                      AND X.INCOTERMS       = Y.INCOTERMS
                      AND X.MEASURE         = 'PACK_SHIP_PLAN'
                      AND X.TRANSPORT_MODE  <> Y.TRANSPORT_MODE
                      AND NOT EXISTS (
                                        SELECT 'X'
                                          FROM #SCP_XLS_PSI_GLOBAL_SMALL_PACK AS Z WITH(NOLOCK)
                                         WHERE 1=1
                                            AND Z.MEASURE        = 'PACK_SHIP_PLAN'
                                            AND Z.DIVISION_ID    = X.DIVISION_ID
                                            AND Z.FROM_SITE      = X.FROM_SITE
                                            AND Z.ITEM_ID        = X.ITEM_ID     
                                            AND Z.INCOTERMS      = X.INCOTERMS
                                      )
--PRINT '4444444444444444444444444444';


		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 012 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;  

			-------------------------------------------------------------------------------------------------------------         
            --  보정
            -------------------------------------------------------------------------------------------------------------
              UPDATE X
              SET X.LT_DAY = 0
              FROM #SCP_XLS_PSI_GLOBAL_SMALL_PACK  X WITH (NOLOCK)
              WHERE TRANSPORT_MODE = '-'


		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 013 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;  

              DELETE FROM #SCP_XLS_PSI_GLOBAL_SMALL_PACK 
              WHERE OPERATION_GROUP = 'A' 
              AND TO_SITE NOT LIKE '%-P' 
              AND MEASURE NOT IN ('CELL_REQ','CELL_BALANCE','CELL_WHIN')

		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 014 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;  

			    ------------------------------------------------------------------------------------------------------------- start        
            -- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: W-1 주차 PR 플랜에 대한 생산/출하 measure 추가
            -------------------------------------------------------------------------------------------------------------
			-- 매핑되지 않는 case 제거
			UPDATE #SCP_XLS_PSI_GLOBAL_SMALL_PACK
			   SET PROJECT_CODE = '-'
			 WHERE MEASURE = 'PACK_PROD' 
			 ;

		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 015 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;  

			-- W-1 주차 추가
			INSERT INTO #SCP_XLS_PSI_GLOBAL_SMALL_PACK
					(
                     DIVISION_ID
					,PLAN_START_YYYYMMDD
					,PLAN_TYPE
					,SEQ
					,OPERATION_GROUP
					,OPERATION_GROUP_NAME
					,CELL_ITEM_ID
					,ITEM_ID
					,NICK_NAME
					--,CHILD_ITEM_ID
					,CELL_QTY_PACK
					,TO_SITE
					,TO_SITE_DESCRIPTION
					,PROJECT_CODE
					,FROM_BOH_QTY
					,TO_BOH_QTY
					,INCOTERMS
					,FROM_SITE
					,FROM_SITE_DESCRIPTION
					,TRANSPORT_MODE
					,PROD_LINE
					--,END_CUSTOMER
					,LT_DAY
					,BOD_ID
					,MEASURE
					,MEASURE_LABEL
					,XLS_KEY1
					,SORT_ORDER_NO
					--,CREATED_BY
					--,CREATION_DATE
					--,LAST_UPDATED_BY
					--,LAST_UPDATE_DATE
					,ATTRIBUTE1
					,ATTRIBUTE2
					,ATTRIBUTE3
					,ATTRIBUTE4
					,ATTRIBUTE5
					,ATTRIBUTE6
					,ATTRIBUTE7
					,ATTRIBUTE8
					,ATTRIBUTE9
					,ATTRIBUTE10
					--,YIELD

                    ,QTY001,QTY002,QTY003,QTY004,QTY005,QTY006,QTY007,QTY008,QTY009,QTY010,QTY011,QTY012,QTY013,QTY014,QTY015,QTY016,QTY017,QTY018,QTY019,QTY020,QTY021,QTY022,QTY023,QTY024,QTY025
                    ,QTY026,QTY027,QTY028,QTY029,QTY030,QTY031,QTY032,QTY033,QTY034,QTY035,QTY036,QTY037,QTY038,QTY039,QTY040,QTY041,QTY042,QTY043,QTY044,QTY045,QTY046,QTY047,QTY048,QTY049,QTY050
                    ,QTY051,QTY052,QTY053,QTY054,QTY055,QTY056,QTY057,QTY058,QTY059,QTY060,QTY061,QTY062,QTY063,QTY064,QTY065,QTY066,QTY067,QTY068,QTY069,QTY070,QTY071,QTY072,QTY073,QTY074,QTY075
                    ,QTY076,QTY077,QTY078,QTY079,QTY080,QTY081,QTY082,QTY083,QTY084,QTY085,QTY086,QTY087,QTY088,QTY089,QTY090,QTY091,QTY092,QTY093,QTY094,QTY095,QTY096,QTY097,QTY098,QTY099,QTY100

                    ,QTY101,QTY102,QTY103,QTY104,QTY105,QTY106,QTY107,QTY108,QTY109,QTY110,QTY111,QTY112,QTY113,QTY114,QTY115,QTY116,QTY117,QTY118,QTY119,QTY120,QTY121,QTY122,QTY123,QTY124,QTY125
                    ,QTY126,QTY127,QTY128,QTY129,QTY130,QTY131,QTY132,QTY133,QTY134,QTY135,QTY136,QTY137,QTY138,QTY139,QTY140,QTY141,QTY142,QTY143,QTY144,QTY145,QTY146,QTY147,QTY148,QTY149,QTY150
                    ,QTY151,QTY152,QTY153,QTY154,QTY155,QTY156,QTY157,QTY158,QTY159,QTY160,QTY161,QTY162,QTY163,QTY164,QTY165,QTY166,QTY167,QTY168,QTY169,QTY170,QTY171,QTY172,QTY173,QTY174,QTY175
                    ,QTY176,QTY177,QTY178,QTY179,QTY180,QTY181,QTY182,QTY183,QTY184,QTY185,QTY186,QTY187,QTY188,QTY189,QTY190,QTY191,QTY192,QTY193,QTY194,QTY195,QTY196,QTY197,QTY198,QTY199,QTY200

                    ,QTY201,QTY202,QTY203,QTY204,QTY205,QTY206,QTY207,QTY208,QTY209,QTY210,QTY211,QTY212,QTY213,QTY214,QTY215,QTY216,QTY217,QTY218,QTY219,QTY220,QTY221,QTY222,QTY223,QTY224,QTY225
                    ,QTY226,QTY227,QTY228,QTY229,QTY230,QTY231,QTY232,QTY233,QTY234,QTY235,QTY236,QTY237,QTY238,QTY239,QTY240,QTY241,QTY242,QTY243,QTY244,QTY245,QTY246,QTY247,QTY248,QTY249,QTY250
                    ,QTY251,QTY252,QTY253,QTY254,QTY255,QTY256,QTY257,QTY258,QTY259,QTY260,QTY261,QTY262,QTY263,QTY264,QTY265,QTY266,QTY267,QTY268,QTY269,QTY270,QTY271,QTY272,QTY273,QTY274,QTY275
                    ,QTY276,QTY277,QTY278,QTY279,QTY280,QTY281,QTY282,QTY283,QTY284,QTY285,QTY286,QTY287,QTY288,QTY289,QTY290,QTY291,QTY292,QTY293,QTY294,QTY295,QTY296,QTY297,QTY298,QTY299,QTY300

                    ,QTY301,QTY302,QTY303,QTY304,QTY305,QTY306,QTY307,QTY308,QTY309,QTY310,QTY311,QTY312,QTY313,QTY314,QTY315,QTY316,QTY317,QTY318,QTY319,QTY320,QTY321,QTY322,QTY323,QTY324,QTY325
                    ,QTY326,QTY327,QTY328,QTY329,QTY330,QTY331,QTY332,QTY333,QTY334,QTY335,QTY336,QTY337,QTY338,QTY339,QTY340,QTY341,QTY342,QTY343,QTY344,QTY345,QTY346,QTY347,QTY348,QTY349,QTY350
                    ,QTY351,QTY352,QTY353,QTY354,QTY355,QTY356,QTY357,QTY358,QTY359,QTY360,QTY361,QTY362,QTY363,QTY364

                    --,WQTY01,WQTY02,WQTY03,WQTY04,WQTY05,WQTY06,WQTY07,WQTY08,WQTY09,WQTY10,WQTY11,WQTY12,WQTY13,WQTY14,WQTY15,WQTY16,WQTY17,WQTY18,WQTY19,WQTY20,WQTY21,WQTY22,WQTY23,WQTY24,WQTY25
                    --,WQTY26,WQTY27,WQTY28,WQTY29,WQTY30,WQTY31,WQTY32,WQTY33,WQTY34,WQTY35,WQTY36,WQTY37,WQTY38,WQTY39,WQTY40,WQTY41,WQTY42,WQTY43,WQTY44,WQTY45,WQTY46,WQTY47,WQTY48,WQTY49,WQTY50
                    --,WQTY51,WQTY52
					)			    
				 -- W-1 주차 PR 플랜
                 SELECT  X.DIVISION_ID
						,X.PLAN_START_YYYYMMDD
						,X.PLAN_TYPE
						,X.SEQ
						,X.OPERATION_GROUP
						,X.OPERATION_GROUP_NAME
						,X.CELL_ITEM_ID
						,X.ITEM_ID
						,X.NICK_NAME
						--,X.CHILD_ITEM_ID
						,X.CELL_QTY_PACK
						,X.TO_SITE
						,X.TO_SITE_DESCRIPTION
						,X.PROJECT_CODE
						,0 AS FROM_BOH_QTY
						,0 AS TO_BOH_QTY
						,X.INCOTERMS
						,X.FROM_SITE
						,X.FROM_SITE_DESCRIPTION
						,X.TRANSPORT_MODE
						,X.PROD_LINE
						--,X.END_CUSTOMER
						,X.LT_DAY
						,X.BOD_ID
						,'PREV_'  + X.MEASURE       AS MEASURE
						,'Prev. ' + X.MEASURE_LABEL AS MEASURE_LABEL
						,NULL						AS XLS_KEY1
						,(CASE WHEN X.MEASURE = 'PACK_SHIP_PLAN' THEN '245' ELSE '246' END) AS SORT_ORDER_NO
						--,X.CREATED_BY
						--,X.CREATION_DATE
						--,X.LAST_UPDATED_BY
						--,X.LAST_UPDATE_DATE
						,Y.ATTRIBUTE1
						,Y.ATTRIBUTE2
						,Y.ATTRIBUTE3
						,Y.ATTRIBUTE4
						,Y.ATTRIBUTE5
						,Y.ATTRIBUTE6
						,Y.ATTRIBUTE7
						,Y.ATTRIBUTE8
						,Y.ATTRIBUTE9
						,Y.ATTRIBUTE10
						--,Y.YIELD

						,ISNULL(Y.QTY008, 0) AS QTY001, ISNULL(Y.QTY009, 0) AS QTY002, ISNULL(Y.QTY010, 0) AS QTY003
						,ISNULL(Y.QTY011, 0) AS QTY004, ISNULL(Y.QTY012, 0) AS QTY005, ISNULL(Y.QTY013, 0) AS QTY006, ISNULL(Y.QTY014, 0) AS QTY007, ISNULL(Y.QTY015, 0) AS QTY008, ISNULL(Y.QTY016, 0) AS QTY009, ISNULL(Y.QTY017, 0) AS QTY010, ISNULL(Y.QTY018, 0) AS QTY011, ISNULL(Y.QTY019, 0) AS QTY012, ISNULL(Y.QTY020, 0) AS QTY013
						,ISNULL(Y.QTY021, 0) AS QTY014, ISNULL(Y.QTY022, 0) AS QTY015, ISNULL(Y.QTY023, 0) AS QTY016, ISNULL(Y.QTY024, 0) AS QTY017, ISNULL(Y.QTY025, 0) AS QTY018, ISNULL(Y.QTY026, 0) AS QTY019, ISNULL(Y.QTY027, 0) AS QTY020, ISNULL(Y.QTY028, 0) AS QTY021, ISNULL(Y.QTY029, 0) AS QTY022, ISNULL(Y.QTY030, 0) AS QTY023
						,ISNULL(Y.QTY031, 0) AS QTY024, ISNULL(Y.QTY032, 0) AS QTY025, ISNULL(Y.QTY033, 0) AS QTY026, ISNULL(Y.QTY034, 0) AS QTY027, ISNULL(Y.QTY035, 0) AS QTY028, ISNULL(Y.QTY036, 0) AS QTY029, ISNULL(Y.QTY037, 0) AS QTY030, ISNULL(Y.QTY038, 0) AS QTY031, ISNULL(Y.QTY039, 0) AS QTY032, ISNULL(Y.QTY040, 0) AS QTY033
						,ISNULL(Y.QTY041, 0) AS QTY034, ISNULL(Y.QTY042, 0) AS QTY035, ISNULL(Y.QTY043, 0) AS QTY036, ISNULL(Y.QTY044, 0) AS QTY037, ISNULL(Y.QTY045, 0) AS QTY038, ISNULL(Y.QTY046, 0) AS QTY039, ISNULL(Y.QTY047, 0) AS QTY040, ISNULL(Y.QTY048, 0) AS QTY041, ISNULL(Y.QTY049, 0) AS QTY042, ISNULL(Y.QTY050, 0) AS QTY043
						,ISNULL(Y.QTY051, 0) AS QTY044, ISNULL(Y.QTY052, 0) AS QTY045, ISNULL(Y.QTY053, 0) AS QTY046, ISNULL(Y.QTY054, 0) AS QTY047, ISNULL(Y.QTY055, 0) AS QTY048, ISNULL(Y.QTY056, 0) AS QTY049, ISNULL(Y.QTY057, 0) AS QTY050, ISNULL(Y.QTY058, 0) AS QTY051, ISNULL(Y.QTY059, 0) AS QTY052, ISNULL(Y.QTY060, 0) AS QTY053
						,ISNULL(Y.QTY061, 0) AS QTY054, ISNULL(Y.QTY062, 0) AS QTY055, ISNULL(Y.QTY063, 0) AS QTY056, ISNULL(Y.QTY064, 0) AS QTY057, ISNULL(Y.QTY065, 0) AS QTY058, ISNULL(Y.QTY066, 0) AS QTY059, ISNULL(Y.QTY067, 0) AS QTY060, ISNULL(Y.QTY068, 0) AS QTY061, ISNULL(Y.QTY069, 0) AS QTY062, ISNULL(Y.QTY070, 0) AS QTY063
						,ISNULL(Y.QTY071, 0) AS QTY064, ISNULL(Y.QTY072, 0) AS QTY065, ISNULL(Y.QTY073, 0) AS QTY066, ISNULL(Y.QTY074, 0) AS QTY067, ISNULL(Y.QTY075, 0) AS QTY068, ISNULL(Y.QTY076, 0) AS QTY069, ISNULL(Y.QTY077, 0) AS QTY070, ISNULL(Y.QTY078, 0) AS QTY071, ISNULL(Y.QTY079, 0) AS QTY072, ISNULL(Y.QTY080, 0) AS QTY073
						,ISNULL(Y.QTY081, 0) AS QTY074, ISNULL(Y.QTY082, 0) AS QTY075, ISNULL(Y.QTY083, 0) AS QTY076, ISNULL(Y.QTY084, 0) AS QTY077, ISNULL(Y.QTY085, 0) AS QTY078, ISNULL(Y.QTY086, 0) AS QTY079, ISNULL(Y.QTY087, 0) AS QTY080, ISNULL(Y.QTY088, 0) AS QTY081, ISNULL(Y.QTY089, 0) AS QTY082, ISNULL(Y.QTY090, 0) AS QTY083
						,ISNULL(Y.QTY091, 0) AS QTY084, ISNULL(Y.QTY092, 0) AS QTY085, ISNULL(Y.QTY093, 0) AS QTY086, ISNULL(Y.QTY094, 0) AS QTY087, ISNULL(Y.QTY095, 0) AS QTY088, ISNULL(Y.QTY096, 0) AS QTY089, ISNULL(Y.QTY097, 0) AS QTY090, ISNULL(Y.QTY098, 0) AS QTY091, ISNULL(Y.QTY099, 0) AS QTY092, ISNULL(Y.QTY100, 0) AS QTY093
						,ISNULL(Y.QTY101, 0) AS QTY094, ISNULL(Y.QTY102, 0) AS QTY095, ISNULL(Y.QTY103, 0) AS QTY096, ISNULL(Y.QTY104, 0) AS QTY097, ISNULL(Y.QTY105, 0) AS QTY098, ISNULL(Y.QTY106, 0) AS QTY099, ISNULL(Y.QTY107, 0) AS QTY100, ISNULL(Y.QTY108, 0) AS QTY101, ISNULL(Y.QTY109, 0) AS QTY102, ISNULL(Y.QTY110, 0) AS QTY103
						,ISNULL(Y.QTY111, 0) AS QTY104, ISNULL(Y.QTY112, 0) AS QTY105, ISNULL(Y.QTY113, 0) AS QTY106, ISNULL(Y.QTY114, 0) AS QTY107, ISNULL(Y.QTY115, 0) AS QTY108, ISNULL(Y.QTY116, 0) AS QTY109, ISNULL(Y.QTY117, 0) AS QTY110, ISNULL(Y.QTY118, 0) AS QTY111, ISNULL(Y.QTY119, 0) AS QTY112, ISNULL(Y.QTY120, 0) AS QTY113
						,ISNULL(Y.QTY121, 0) AS QTY114, ISNULL(Y.QTY122, 0) AS QTY115, ISNULL(Y.QTY123, 0) AS QTY116, ISNULL(Y.QTY124, 0) AS QTY117, ISNULL(Y.QTY125, 0) AS QTY118 ,ISNULL(Y.QTY126, 0) AS QTY119, ISNULL(Y.QTY127, 0) AS QTY120, ISNULL(Y.QTY128, 0) AS QTY121, ISNULL(Y.QTY129, 0) AS QTY122, ISNULL(Y.QTY130, 0) AS QTY123
						,ISNULL(Y.QTY131, 0) AS QTY124, ISNULL(Y.QTY132, 0) AS QTY125, ISNULL(Y.QTY133, 0) AS QTY126, ISNULL(Y.QTY134, 0) AS QTY127, ISNULL(Y.QTY135, 0) AS QTY128, ISNULL(Y.QTY136, 0) AS QTY129, ISNULL(Y.QTY137, 0) AS QTY130, ISNULL(Y.QTY138, 0) AS QTY131, ISNULL(Y.QTY139, 0) AS QTY132, ISNULL(Y.QTY140, 0) AS QTY133
						,ISNULL(Y.QTY141, 0) AS QTY134, ISNULL(Y.QTY142, 0) AS QTY135, ISNULL(Y.QTY143, 0) AS QTY136, ISNULL(Y.QTY144, 0) AS QTY137, ISNULL(Y.QTY145, 0) AS QTY138, ISNULL(Y.QTY146, 0) AS QTY139, ISNULL(Y.QTY147, 0) AS QTY140, ISNULL(Y.QTY148, 0) AS QTY141, ISNULL(Y.QTY149, 0) AS QTY142, ISNULL(Y.QTY150, 0) AS QTY143
						,ISNULL(Y.QTY151, 0) AS QTY144, ISNULL(Y.QTY152, 0) AS QTY145, ISNULL(Y.QTY153, 0) AS QTY146, ISNULL(Y.QTY154, 0) AS QTY147, ISNULL(Y.QTY155, 0) AS QTY148, ISNULL(Y.QTY156, 0) AS QTY149, ISNULL(Y.QTY157, 0) AS QTY150, ISNULL(Y.QTY158, 0) AS QTY151, ISNULL(Y.QTY159, 0) AS QTY152, ISNULL(Y.QTY160, 0) AS QTY153
						,ISNULL(Y.QTY161, 0) AS QTY154, ISNULL(Y.QTY162, 0) AS QTY155, ISNULL(Y.QTY163, 0) AS QTY156, ISNULL(Y.QTY164, 0) AS QTY157, ISNULL(Y.QTY165, 0) AS QTY158, ISNULL(Y.QTY166, 0) AS QTY159, ISNULL(Y.QTY167, 0) AS QTY160, ISNULL(Y.QTY168, 0) AS QTY161, ISNULL(Y.QTY169, 0) AS QTY162, ISNULL(Y.QTY170, 0) AS QTY163
						,ISNULL(Y.QTY171, 0) AS QTY164, ISNULL(Y.QTY172, 0) AS QTY165, ISNULL(Y.QTY173, 0) AS QTY166, ISNULL(Y.QTY174, 0) AS QTY167, ISNULL(Y.QTY175, 0) AS QTY168, ISNULL(Y.QTY176, 0) AS QTY169, ISNULL(Y.QTY177, 0) AS QTY170, ISNULL(Y.QTY178, 0) AS QTY171, ISNULL(Y.QTY179, 0) AS QTY172, ISNULL(Y.QTY180, 0) AS QTY173
						,ISNULL(Y.QTY181, 0) AS QTY174, ISNULL(Y.QTY182, 0) AS QTY175, ISNULL(Y.QTY183, 0) AS QTY176, ISNULL(Y.QTY184, 0) AS QTY177, ISNULL(Y.QTY185, 0) AS QTY178, ISNULL(Y.QTY186, 0) AS QTY179, ISNULL(Y.QTY187, 0) AS QTY180, ISNULL(Y.QTY188, 0) AS QTY181, ISNULL(Y.QTY189, 0) AS QTY182, ISNULL(Y.QTY190, 0) AS QTY183
						,ISNULL(Y.QTY191, 0) AS QTY184, ISNULL(Y.QTY192, 0) AS QTY185, ISNULL(Y.QTY193, 0) AS QTY186, ISNULL(Y.QTY194, 0) AS QTY187, ISNULL(Y.QTY195, 0) AS QTY188, ISNULL(Y.QTY196, 0) AS QTY189, ISNULL(Y.QTY197, 0) AS QTY190, ISNULL(Y.QTY198, 0) AS QTY191, ISNULL(Y.QTY199, 0) AS QTY192, ISNULL(Y.QTY200, 0) AS QTY193
						,ISNULL(Y.QTY201, 0) AS QTY194, ISNULL(Y.QTY202, 0) AS QTY195, ISNULL(Y.QTY203, 0) AS QTY196, ISNULL(Y.QTY204, 0) AS QTY197, ISNULL(Y.QTY205, 0) AS QTY198, ISNULL(Y.QTY206, 0) AS QTY199, ISNULL(Y.QTY207, 0) AS QTY200, ISNULL(Y.QTY208, 0) AS QTY201, ISNULL(Y.QTY209, 0) AS QTY202, ISNULL(Y.QTY210, 0) AS QTY203
						,ISNULL(Y.QTY211, 0) AS QTY204, ISNULL(Y.QTY212, 0) AS QTY205, ISNULL(Y.QTY213, 0) AS QTY206, ISNULL(Y.QTY214, 0) AS QTY207, ISNULL(Y.QTY215, 0) AS QTY208, ISNULL(Y.QTY216, 0) AS QTY209, ISNULL(Y.QTY217, 0) AS QTY210, ISNULL(Y.QTY218, 0) AS QTY211, ISNULL(Y.QTY219, 0) AS QTY212, ISNULL(Y.QTY220, 0) AS QTY213
						,ISNULL(Y.QTY221, 0) AS QTY214, ISNULL(Y.QTY222, 0) AS QTY215, ISNULL(Y.QTY223, 0) AS QTY216, ISNULL(Y.QTY224, 0) AS QTY217, ISNULL(Y.QTY225, 0) AS QTY218, ISNULL(Y.QTY226, 0) AS QTY219, ISNULL(Y.QTY227, 0) AS QTY220, ISNULL(Y.QTY228, 0) AS QTY221, ISNULL(Y.QTY229, 0) AS QTY222, ISNULL(Y.QTY230, 0) AS QTY223
						,ISNULL(Y.QTY231, 0) AS QTY224, ISNULL(Y.QTY232, 0) AS QTY225, ISNULL(Y.QTY233, 0) AS QTY226, ISNULL(Y.QTY234, 0) AS QTY227, ISNULL(Y.QTY235, 0) AS QTY228, ISNULL(Y.QTY236, 0) AS QTY229, ISNULL(Y.QTY237, 0) AS QTY230, ISNULL(Y.QTY238, 0) AS QTY231, ISNULL(Y.QTY239, 0) AS QTY232, ISNULL(Y.QTY240, 0) AS QTY233
						,ISNULL(Y.QTY241, 0) AS QTY234, ISNULL(Y.QTY242, 0) AS QTY235, ISNULL(Y.QTY243, 0) AS QTY236, ISNULL(Y.QTY244, 0) AS QTY237, ISNULL(Y.QTY245, 0) AS QTY238, ISNULL(Y.QTY246, 0) AS QTY239, ISNULL(Y.QTY247, 0) AS QTY240, ISNULL(Y.QTY248, 0) AS QTY241, ISNULL(Y.QTY249, 0) AS QTY242, ISNULL(Y.QTY250, 0) AS QTY243
						,ISNULL(Y.QTY251, 0) AS QTY244, ISNULL(Y.QTY252, 0) AS QTY245, ISNULL(Y.QTY253, 0) AS QTY246, ISNULL(Y.QTY254, 0) AS QTY247, ISNULL(Y.QTY255, 0) AS QTY248, ISNULL(Y.QTY256, 0) AS QTY249, ISNULL(Y.QTY257, 0) AS QTY250, ISNULL(Y.QTY258, 0) AS QTY251, ISNULL(Y.QTY259, 0) AS QTY252, ISNULL(Y.QTY260, 0) AS QTY253
						,ISNULL(Y.QTY261, 0) AS QTY254, ISNULL(Y.QTY262, 0) AS QTY255, ISNULL(Y.QTY263, 0) AS QTY256, ISNULL(Y.QTY264, 0) AS QTY257, ISNULL(Y.QTY265, 0) AS QTY258, ISNULL(Y.QTY266, 0) AS QTY259, ISNULL(Y.QTY267, 0) AS QTY260, ISNULL(Y.QTY268, 0) AS QTY261, ISNULL(Y.QTY269, 0) AS QTY262, ISNULL(Y.QTY270, 0) AS QTY263
						,ISNULL(Y.QTY271, 0) AS QTY264, ISNULL(Y.QTY272, 0) AS QTY265, ISNULL(Y.QTY273, 0) AS QTY266, ISNULL(Y.QTY274, 0) AS QTY267, ISNULL(Y.QTY275, 0) AS QTY268, ISNULL(Y.QTY276, 0) AS QTY269, ISNULL(Y.QTY277, 0) AS QTY270, ISNULL(Y.QTY278, 0) AS QTY271, ISNULL(Y.QTY279, 0) AS QTY272, ISNULL(Y.QTY280, 0) AS QTY273
						,ISNULL(Y.QTY281, 0) AS QTY274, ISNULL(Y.QTY282, 0) AS QTY275, ISNULL(Y.QTY283, 0) AS QTY276, ISNULL(Y.QTY284, 0) AS QTY277, ISNULL(Y.QTY285, 0) AS QTY278, ISNULL(Y.QTY286, 0) AS QTY279, ISNULL(Y.QTY287, 0) AS QTY280, ISNULL(Y.QTY288, 0) AS QTY281, ISNULL(Y.QTY289, 0) AS QTY282, ISNULL(Y.QTY290, 0) AS QTY283
						,ISNULL(Y.QTY291, 0) AS QTY284, ISNULL(Y.QTY292, 0) AS QTY285, ISNULL(Y.QTY293, 0) AS QTY286, ISNULL(Y.QTY294, 0) AS QTY287, ISNULL(Y.QTY295, 0) AS QTY288, ISNULL(Y.QTY296, 0) AS QTY289, ISNULL(Y.QTY297, 0) AS QTY290, ISNULL(Y.QTY298, 0) AS QTY291, ISNULL(Y.QTY299, 0) AS QTY292, ISNULL(Y.QTY300, 0) AS QTY293
						,ISNULL(Y.QTY301, 0) AS QTY294, ISNULL(Y.QTY302, 0) AS QTY295, ISNULL(Y.QTY303, 0) AS QTY296, ISNULL(Y.QTY304, 0) AS QTY297, ISNULL(Y.QTY305, 0) AS QTY298, ISNULL(Y.QTY306, 0) AS QTY299, ISNULL(Y.QTY307, 0) AS QTY300, ISNULL(Y.QTY308, 0) AS QTY301, ISNULL(Y.QTY309, 0) AS QTY302, ISNULL(Y.QTY310, 0) AS QTY303
						,ISNULL(Y.QTY311, 0) AS QTY304, ISNULL(Y.QTY312, 0) AS QTY305, ISNULL(Y.QTY313, 0) AS QTY306, ISNULL(Y.QTY314, 0) AS QTY307, ISNULL(Y.QTY315, 0) AS QTY308, ISNULL(Y.QTY316, 0) AS QTY309, ISNULL(Y.QTY317, 0) AS QTY310, ISNULL(Y.QTY318, 0) AS QTY311, ISNULL(Y.QTY319, 0) AS QTY312, ISNULL(Y.QTY320, 0) AS QTY313
						,ISNULL(Y.QTY321, 0) AS QTY314, ISNULL(Y.QTY322, 0) AS QTY315, ISNULL(Y.QTY323, 0) AS QTY316, ISNULL(Y.QTY324, 0) AS QTY317, ISNULL(Y.QTY325, 0) AS QTY318, ISNULL(Y.QTY326, 0) AS QTY319, ISNULL(Y.QTY327, 0) AS QTY320, ISNULL(Y.QTY328, 0) AS QTY321, ISNULL(Y.QTY329, 0) AS QTY322, ISNULL(Y.QTY330, 0) AS QTY323
						,ISNULL(Y.QTY331, 0) AS QTY324, ISNULL(Y.QTY332, 0) AS QTY325, ISNULL(Y.QTY333, 0) AS QTY326, ISNULL(Y.QTY334, 0) AS QTY327, ISNULL(Y.QTY335, 0) AS QTY328, ISNULL(Y.QTY336, 0) AS QTY329, ISNULL(Y.QTY337, 0) AS QTY330, ISNULL(Y.QTY338, 0) AS QTY331, ISNULL(Y.QTY339, 0) AS QTY332, ISNULL(Y.QTY340, 0) AS QTY333
						,ISNULL(Y.QTY341, 0) AS QTY334, ISNULL(Y.QTY342, 0) AS QTY335, ISNULL(Y.QTY343, 0) AS QTY336, ISNULL(Y.QTY344, 0) AS QTY337, ISNULL(Y.QTY345, 0) AS QTY338, ISNULL(Y.QTY346, 0) AS QTY339, ISNULL(Y.QTY347, 0) AS QTY340, ISNULL(Y.QTY348, 0) AS QTY341, ISNULL(Y.QTY349, 0) AS QTY342, ISNULL(Y.QTY350, 0) AS QTY343
						,ISNULL(Y.QTY351, 0) AS QTY344, ISNULL(Y.QTY352, 0) AS QTY345, ISNULL(Y.QTY353, 0) AS QTY346, ISNULL(Y.QTY354, 0) AS QTY347, ISNULL(Y.QTY355, 0) AS QTY348, ISNULL(Y.QTY356, 0) AS QTY349, ISNULL(Y.QTY357, 0) AS QTY350, ISNULL(Y.QTY358, 0) AS QTY351, ISNULL(Y.QTY359, 0) AS QTY352, ISNULL(Y.QTY360, 0) AS QTY353
						,ISNULL(Y.QTY361, 0) AS QTY354, ISNULL(Y.QTY362, 0) AS QTY355, ISNULL(Y.QTY363, 0) AS QTY356, ISNULL(Y.QTY364, 0) AS QTY357
						,0 AS QTY358, 0 AS QTY359, 0 AS QTY360, 0 AS QTY361, 0 AS QTY362, 0 AS QTY363, 0 AS QTY364

						--,ISNULL(Y.WQTY01, 0) AS WQTY01, ISNULL(Y.WQTY02, 0) AS WQTY02, ISNULL(Y.WQTY03, 0) AS WQTY03, ISNULL(Y.WQTY04, 0) AS WQTY04, ISNULL(Y.WQTY05, 0) AS WQTY05, ISNULL(Y.WQTY06, 0) AS WQTY06, ISNULL(Y.WQTY07, 0) AS WQTY07, ISNULL(Y.WQTY08, 0) AS WQTY08, ISNULL(Y.WQTY09, 0) AS WQTY09, ISNULL(Y.WQTY10, 0) AS WQTY10
						--,ISNULL(Y.WQTY11, 0) AS WQTY11, ISNULL(Y.WQTY12, 0) AS WQTY12, ISNULL(Y.WQTY13, 0) AS WQTY13, ISNULL(Y.WQTY14, 0) AS WQTY14, ISNULL(Y.WQTY15, 0) AS WQTY15, ISNULL(Y.WQTY16, 0) AS WQTY16, ISNULL(Y.WQTY17, 0) AS WQTY17, ISNULL(Y.WQTY18, 0) AS WQTY18, ISNULL(Y.WQTY19, 0) AS WQTY19, ISNULL(Y.WQTY20, 0) AS WQTY20
						--,ISNULL(Y.WQTY21, 0) AS WQTY21, ISNULL(Y.WQTY22, 0) AS WQTY22, ISNULL(Y.WQTY23, 0) AS WQTY23, ISNULL(Y.WQTY24, 0) AS WQTY24, ISNULL(Y.WQTY25, 0) AS WQTY25, ISNULL(Y.WQTY26, 0) AS WQTY26, ISNULL(Y.WQTY27, 0) AS WQTY27, ISNULL(Y.WQTY28, 0) AS WQTY28, ISNULL(Y.WQTY29, 0) AS WQTY29, ISNULL(Y.WQTY30, 0) AS WQTY30
						--,ISNULL(Y.WQTY31, 0) AS WQTY31, ISNULL(Y.WQTY32, 0) AS WQTY32, ISNULL(Y.WQTY33, 0) AS WQTY33, ISNULL(Y.WQTY34, 0) AS WQTY34, ISNULL(Y.WQTY35, 0) AS WQTY35, ISNULL(Y.WQTY36, 0) AS WQTY36, ISNULL(Y.WQTY37, 0) AS WQTY37, ISNULL(Y.WQTY38, 0) AS WQTY38, ISNULL(Y.WQTY39, 0) AS WQTY39, ISNULL(Y.WQTY40, 0) AS WQTY40
						--,ISNULL(Y.WQTY41, 0) AS WQTY41, ISNULL(Y.WQTY42, 0) AS WQTY42, ISNULL(Y.WQTY43, 0) AS WQTY43, ISNULL(Y.WQTY44, 0) AS WQTY44, ISNULL(Y.WQTY45, 0) AS WQTY45, ISNULL(Y.WQTY46, 0) AS WQTY46, ISNULL(Y.WQTY47, 0) AS WQTY47, ISNULL(Y.WQTY48, 0) AS WQTY48, ISNULL(Y.WQTY49, 0) AS WQTY49, ISNULL(Y.WQTY50, 0) AS WQTY50
						--,ISNULL(Y.WQTY51, 0) AS WQTY51, ISNULL(Y.WQTY52, 0) AS WQTY52
				   FROM (SELECT distinct *
				           FROM #SCP_XLS_PSI_GLOBAL_SMALL_PACK WITH (NOLOCK)		-- 당주플랜
						 -- WHERE DIVISION_ID         = @p_division_id
						 --   AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
							--AND PLAN_TYPE           = @p_plan_type
							--AND SEQ                 = @p_seq
							WHERE MEASURE            IN ('PACK_PROD', 'PACK_SHIP_PLAN')) X
				  LEFT OUTER JOIN 
				        (SELECT *
				           FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK WITH (NOLOCK)		-- W-1 PR 플랜
						  WHERE DIVISION_ID         = @p_division_id
						    AND PLAN_START_YYYYMMDD = CONVERT(VARCHAR(8), DATEADD(day, -7, @p_plan_start_yyyymmdd), 112)
							AND CREATE_FROM_YYYYMMDD = CONVERT(VARCHAR(8), DATEADD(day, -7, @p_create_from_yyyymmdd), 112)	--DHJ						
							AND PLAN_TYPE           = 'PR'
							--AND SEQ                 = @p_seq
							AND MEASURE            IN ('PACK_PROD', 'PACK_SHIP_PLAN')) Y
				   ON X.DIVISION_ID  = Y.DIVISION_ID
				  AND X.ITEM_ID      = Y.ITEM_ID
				  AND X.CELL_ITEM_ID = Y.CELL_ITEM_ID
				  AND X.FROM_SITE    = Y.FROM_SITE
				  AND X.TO_SITE      = Y.TO_SITE
				  AND X.PROD_LINE    = Y.PROD_LINE
				  AND X.INCOTERMS    = Y.INCOTERMS
				  AND X.BOD_ID       = Y.BOD_ID
				  AND X.PROJECT_CODE = Y.PROJECT_CODE
				  AND X.MEASURE      = Y.MEASURE
				  ;

		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 016 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;  
-------------------------------------------------------------------------
-------------------------------------------------------------------------
	/*			  PRINT '6666666666666666666';
  IF OBJECT_ID('tempdb..##PSI_GLOBAL_SMALL_PACK_CHARMM') IS NOT NULL      
	              DROP TABLE ##PSI_GLOBAL_SMALL_PACK_CHARMM;   
				                  
		            SELECT *
		            --INTO ##PSI_GLOBAL_SMALL_PACK_CHARMM
		            FROM #SCP_XLS_PSI_GLOBAL_SMALL_PACK
		            ;

					return -1;
--PREV_
*/
----------------------------------------------------------------------
--------------------------------------------------------------------------

			-- W-1 주차 불필요 data 삭제
			DELETE FROM #SCP_XLS_PSI_GLOBAL_SMALL_PACK
			 WHERE (CASE WHEN MEASURE = 'PREV_PACK_SHIP_PLAN' THEN ATTRIBUTE3 ELSE 'A' END) IS NULL
			 ;

		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 017 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;  
			 
            ------------------------------------------------------------------------------------------------------------- end

            -------------------------------------------------------------------------------------------------------------         
            --  삭제 후 입력
            -------------------------------------------------------------------------------------------------------------
            DELETE FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK                            
                    WHERE DIVISION_ID = @p_division_id -- AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND PLAN_TYPE = @p_plan_type AND SEQ = @p_seq           
					AND   PLAN_START_YYYYMMDD = CONVERT(VARCHAR(8), DATEADD(day, -14, @p_plan_start_yyyymmdd), 112)		-- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 지지난주차 플랜 PSI 삭제
					AND	CREATE_FROM_YYYYMMDD		= @p_create_from_yyyymmdd
					;

		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 018 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;  
				
              DELETE FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK                            
                    WHERE DIVISION_ID         = @p_division_id -- AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND PLAN_TYPE = @p_plan_type AND SEQ = @p_seq           
					AND   PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd		-- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 당주차 당플랜 PSI 삭제
					AND   PLAN_TYPE           = @p_plan_type
					AND	CREATE_FROM_YYYYMMDD		= @p_create_from_yyyymmdd
					;

		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 019 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;  

  
					--,CREATE_FROM_YYYYMMDD,CREATE_TO_YYYYMMDD
					--, @p_create_from_yyyymmdd  NVARCHAR(0008)
	--, @p_create_to_yyyymmdd   NVARCHAR(0008)
	
    INSERT INTO SCP_XLS_PSI_GLOBAL_SMALL_PACK WITH (TABLOCK)
              (
                    DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ
                    ,OPERATION_GROUP,OPERATION_GROUP_NAME,CELL_ITEM_ID,ITEM_ID,NICK_NAME,CELL_QTY_PACK,TO_SITE,TO_SITE_DESCRIPTION
                    ,PROJECT_CODE
                    ,FROM_BOH_QTY,TO_BOH_QTY,INCOTERMS,FROM_SITE,FROM_SITE_DESCRIPTION
                    ,TRANSPORT_MODE,PROD_LINE
                    ,LT_DAY
                    ,BOD_ID,MEASURE,MEASURE_LABEL
                    ,XLS_KEY1
                    ,XLS_KEY2
                    ,XLS_KEY3
                    ,XLS_KEY4,XLS_KEY5,XLS_ATTRIBUTE1,XLS_ATTRIBUTE2,XLS_ATTRIBUTE3,XLS_ATTRIBUTE4,XLS_ATTRIBUTE5
                    --,CALC_YN
                    --,DISPLAY_YN
                    ,SORT_ORDER_NO

                    ,QTY001,QTY002,QTY003,QTY004,QTY005,QTY006,QTY007,QTY008,QTY009,QTY010,QTY011,QTY012,QTY013,QTY014,QTY015,QTY016,QTY017,QTY018,QTY019,QTY020,QTY021,QTY022,QTY023,QTY024,QTY025
                    ,QTY026,QTY027,QTY028,QTY029,QTY030,QTY031,QTY032,QTY033,QTY034,QTY035,QTY036,QTY037,QTY038,QTY039,QTY040,QTY041,QTY042,QTY043,QTY044,QTY045,QTY046,QTY047,QTY048,QTY049,QTY050
                    ,QTY051,QTY052,QTY053,QTY054,QTY055,QTY056,QTY057,QTY058,QTY059,QTY060,QTY061,QTY062,QTY063,QTY064,QTY065,QTY066,QTY067,QTY068,QTY069,QTY070,QTY071,QTY072,QTY073,QTY074,QTY075
                    ,QTY076,QTY077,QTY078,QTY079,QTY080,QTY081,QTY082,QTY083,QTY084,QTY085,QTY086,QTY087,QTY088,QTY089,QTY090,QTY091,QTY092,QTY093,QTY094,QTY095,QTY096,QTY097,QTY098,QTY099,QTY100

                    ,QTY101,QTY102,QTY103,QTY104,QTY105,QTY106,QTY107,QTY108,QTY109,QTY110,QTY111,QTY112,QTY113,QTY114,QTY115,QTY116,QTY117,QTY118,QTY119,QTY120,QTY121,QTY122,QTY123,QTY124,QTY125
                    ,QTY126,QTY127,QTY128,QTY129,QTY130,QTY131,QTY132,QTY133,QTY134,QTY135,QTY136,QTY137,QTY138,QTY139,QTY140,QTY141,QTY142,QTY143,QTY144,QTY145,QTY146,QTY147,QTY148,QTY149,QTY150
                    ,QTY151,QTY152,QTY153,QTY154,QTY155,QTY156,QTY157,QTY158,QTY159,QTY160,QTY161,QTY162,QTY163,QTY164,QTY165,QTY166,QTY167,QTY168,QTY169,QTY170,QTY171,QTY172,QTY173,QTY174,QTY175
                    ,QTY176,QTY177,QTY178,QTY179,QTY180,QTY181,QTY182,QTY183,QTY184,QTY185,QTY186,QTY187,QTY188,QTY189,QTY190,QTY191,QTY192,QTY193,QTY194,QTY195,QTY196,QTY197,QTY198,QTY199,QTY200

                    ,QTY201,QTY202,QTY203,QTY204,QTY205,QTY206,QTY207,QTY208,QTY209,QTY210,QTY211,QTY212,QTY213,QTY214,QTY215,QTY216,QTY217,QTY218,QTY219,QTY220,QTY221,QTY222,QTY223,QTY224,QTY225
                    ,QTY226,QTY227,QTY228,QTY229,QTY230,QTY231,QTY232,QTY233,QTY234,QTY235,QTY236,QTY237,QTY238,QTY239,QTY240,QTY241,QTY242,QTY243,QTY244,QTY245,QTY246,QTY247,QTY248,QTY249,QTY250
                    ,QTY251,QTY252,QTY253,QTY254,QTY255,QTY256,QTY257,QTY258,QTY259,QTY260,QTY261,QTY262,QTY263,QTY264,QTY265,QTY266,QTY267,QTY268,QTY269,QTY270,QTY271,QTY272,QTY273,QTY274,QTY275
                    ,QTY276,QTY277,QTY278,QTY279,QTY280,QTY281,QTY282,QTY283,QTY284,QTY285,QTY286,QTY287,QTY288,QTY289,QTY290,QTY291,QTY292,QTY293,QTY294,QTY295,QTY296,QTY297,QTY298,QTY299,QTY300

                    ,QTY301,QTY302,QTY303,QTY304,QTY305,QTY306,QTY307,QTY308,QTY309,QTY310,QTY311,QTY312,QTY313,QTY314,QTY315,QTY316,QTY317,QTY318,QTY319,QTY320,QTY321,QTY322,QTY323,QTY324,QTY325
                    ,QTY326,QTY327,QTY328,QTY329,QTY330,QTY331,QTY332,QTY333,QTY334,QTY335,QTY336,QTY337,QTY338,QTY339,QTY340,QTY341,QTY342,QTY343,QTY344,QTY345,QTY346,QTY347,QTY348,QTY349,QTY350
                    ,QTY351,QTY352,QTY353,QTY354,QTY355,QTY356,QTY357,QTY358,QTY359,QTY360,QTY361,QTY362,QTY363,QTY364

                    --,WQTY01,WQTY02,WQTY03,WQTY04,WQTY05,WQTY06,WQTY07,WQTY08,WQTY09,WQTY10,WQTY11,WQTY12,WQTY13,WQTY14,WQTY15,WQTY16,WQTY17,WQTY18,WQTY19,WQTY20,WQTY21,WQTY22,WQTY23,WQTY24,WQTY25
                    --,WQTY26,WQTY27,WQTY28,WQTY29,WQTY30,WQTY31,WQTY32,WQTY33,WQTY34,WQTY35,WQTY36,WQTY37,WQTY38,WQTY39,WQTY40,WQTY41,WQTY42,WQTY43,WQTY44,WQTY45,WQTY46,WQTY47,WQTY48,WQTY49,WQTY50
                    --,WQTY51,WQTY52

                    ,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
                    ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9, ATTRIBUTE10
					,CREATE_FROM_YYYYMMDD,CREATE_TO_YYYYMMDD
              )
              SELECT DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ
                    ,OPERATION_GROUP,OPERATION_GROUP_NAME,CELL_ITEM_ID,ITEM_ID,NICK_NAME,CELL_QTY_PACK,TO_SITE,TO_SITE_DESCRIPTION
                    ,(CASE WHEN LEN(PROJECT_CODE) = 0 THEN '-' ELSE PROJECT_CODE END) AS PROJECT_CODE
                    ,FROM_BOH_QTY,TO_BOH_QTY,INCOTERMS,FROM_SITE,FROM_SITE_DESCRIPTION
                    ,TRANSPORT_MODE,PROD_LINE
                    ,LT_DAY
                    ,BOD_ID,MEASURE,MEASURE_LABEL
                    ,ROW_NUMBER() OVER(ORDER BY  DIVISION_ID
                                                ,CELL_ITEM_ID
                                                ,OPERATION_GROUP DESC
                                                ,ITEM_ID
                                                ,(CASE WHEN OPERATION_GROUP = 'A' THEN TO_SITE ELSE NULL END) 
                                                ,(CASE WHEN (FROM_SITE = '-'  AND MEASURE LIKE 'CELL%' ) THEN '-' ELSE FROM_SITE END) 
                                                ,TO_SITE DESC
                                                ,PROJECT_CODE
--                                                ,ATTRIBUTE10
                                                ,(CASE WHEN (MEASURE LIKE 'CELL%' ) THEN NULL ELSE ATTRIBUTE10 END) 
--                                                ,(CASE WHEN (PROD_LINE = '-'  AND MEASURE LIKE 'PACK_CELL%' ) THEN 'ZZZ' ELSE PROD_LINE END)
                                                ,INCOTERMS
                                                ,SORT_ORDER_NO
                                                ,TRANSPORT_MODE
                                                ,MEASURE_LABEL DESC)  AS XLS_KEY1


                    ,XLS_KEY2
                    ,XLS_KEY3
                    ,XLS_KEY4,XLS_KEY5,XLS_ATTRIBUTE1,XLS_ATTRIBUTE2,XLS_ATTRIBUTE3,XLS_ATTRIBUTE4,XLS_ATTRIBUTE5
                    --,'N' AS CALC_YN -- 사용안함
                    --,'N' AS DISPLAY_YN -- 사용안함
                    ,SORT_ORDER_NO
                    ,QTY001,QTY002,QTY003,QTY004,QTY005,QTY006,QTY007,QTY008,QTY009,QTY010,QTY011,QTY012,QTY013,QTY014,QTY015,QTY016,QTY017,QTY018,QTY019,QTY020,QTY021,QTY022,QTY023,QTY024,QTY025
                    ,QTY026,QTY027,QTY028,QTY029,QTY030,QTY031,QTY032,QTY033,QTY034,QTY035,QTY036,QTY037,QTY038,QTY039,QTY040,QTY041,QTY042,QTY043,QTY044,QTY045,QTY046,QTY047,QTY048,QTY049,QTY050
                    ,QTY051,QTY052,QTY053,QTY054,QTY055,QTY056,QTY057,QTY058,QTY059,QTY060,QTY061,QTY062,QTY063,QTY064,QTY065,QTY066,QTY067,QTY068,QTY069,QTY070,QTY071,QTY072,QTY073,QTY074,QTY075
                    ,QTY076,QTY077,QTY078,QTY079,QTY080,QTY081,QTY082,QTY083,QTY084,QTY085,QTY086,QTY087,QTY088,QTY089,QTY090,QTY091,QTY092,QTY093,QTY094,QTY095,QTY096,QTY097,QTY098,QTY099,QTY100

                    ,QTY101,QTY102,QTY103,QTY104,QTY105,QTY106,QTY107,QTY108,QTY109,QTY110,QTY111,QTY112,QTY113,QTY114,QTY115,QTY116,QTY117,QTY118,QTY119,QTY120,QTY121,QTY122,QTY123,QTY124,QTY125
                    ,QTY126,QTY127,QTY128,QTY129,QTY130,QTY131,QTY132,QTY133,QTY134,QTY135,QTY136,QTY137,QTY138,QTY139,QTY140,QTY141,QTY142,QTY143,QTY144,QTY145,QTY146,QTY147,QTY148,QTY149,QTY150
                    ,QTY151,QTY152,QTY153,QTY154,QTY155,QTY156,QTY157,QTY158,QTY159,QTY160,QTY161,QTY162,QTY163,QTY164,QTY165,QTY166,QTY167,QTY168,QTY169,QTY170,QTY171,QTY172,QTY173,QTY174,QTY175
                    ,QTY176,QTY177,QTY178,QTY179,QTY180,QTY181,QTY182,QTY183,QTY184,QTY185,QTY186,QTY187,QTY188,QTY189,QTY190,QTY191,QTY192,QTY193,QTY194,QTY195,QTY196,QTY197,QTY198,QTY199,QTY200

                    ,QTY201,QTY202,QTY203,QTY204,QTY205,QTY206,QTY207,QTY208,QTY209,QTY210,QTY211,QTY212,QTY213,QTY214,QTY215,QTY216,QTY217,QTY218,QTY219,QTY220,QTY221,QTY222,QTY223,QTY224,QTY225
                    ,QTY226,QTY227,QTY228,QTY229,QTY230,QTY231,QTY232,QTY233,QTY234,QTY235,QTY236,QTY237,QTY238,QTY239,QTY240,QTY241,QTY242,QTY243,QTY244,QTY245,QTY246,QTY247,QTY248,QTY249,QTY250
                    ,QTY251,QTY252,QTY253,QTY254,QTY255,QTY256,QTY257,QTY258,QTY259,QTY260,QTY261,QTY262,QTY263,QTY264,QTY265,QTY266,QTY267,QTY268,QTY269,QTY270,QTY271,QTY272,QTY273,QTY274,QTY275
                    ,QTY276,QTY277,QTY278,QTY279,QTY280,QTY281,QTY282,QTY283,QTY284,QTY285,QTY286,QTY287,QTY288,QTY289,QTY290,QTY291,QTY292,QTY293,QTY294,QTY295,QTY296,QTY297,QTY298,QTY299,QTY300

                    ,QTY301,QTY302,QTY303,QTY304,QTY305,QTY306,QTY307,QTY308,QTY309,QTY310,QTY311,QTY312,QTY313,QTY314,QTY315,QTY316,QTY317,QTY318,QTY319,QTY320,QTY321,QTY322,QTY323,QTY324,QTY325
                    ,QTY326,QTY327,QTY328,QTY329,QTY330,QTY331,QTY332,QTY333,QTY334,QTY335,QTY336,QTY337,QTY338,QTY339,QTY340,QTY341,QTY342,QTY343,QTY344,QTY345,QTY346,QTY347,QTY348,QTY349,QTY350
                    ,QTY351,QTY352,QTY353,QTY354,QTY355,QTY356,QTY357,QTY358,QTY359,QTY360,QTY361,QTY362,QTY363,QTY364

                    --,WQTY01,WQTY02,WQTY03,WQTY04,WQTY05,WQTY06,WQTY07,WQTY08,WQTY09,WQTY10,WQTY11,WQTY12,WQTY13,WQTY14,WQTY15,WQTY16,WQTY17,WQTY18,WQTY19,WQTY20,WQTY21,WQTY22,WQTY23,WQTY24,WQTY25
                    --,WQTY26,WQTY27,WQTY28,WQTY29,WQTY30,WQTY31,WQTY32,WQTY33,WQTY34,WQTY35,WQTY36,WQTY37,WQTY38,WQTY39,WQTY40,WQTY41,WQTY42,WQTY43,WQTY44,WQTY45,WQTY46,WQTY47,WQTY48,WQTY49,WQTY50
                    --,WQTY51,WQTY52

                    ,@p_user_id AS CREATED_BY,GETDATE() AS CREATION_DATE,@p_user_id AS LAST_UPDATED_BY,GETDATE() AS  LAST_UPDATE_DATE
                    ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9, ATTRIBUTE10
					,@p_create_from_yyyymmdd, @p_create_to_yyyymmdd
              FROM #SCP_XLS_PSI_GLOBAL_SMALL_PACK  WITH (NOLOCK)
			  /*
			  print 'aaaaaaaaaaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaa';
			  print @p_create_from_yyyymmdd;
			  print @p_create_to_yyyymmdd;
			  */

		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 020 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;  

            -------------------------------------------------------------------------------------------------------------         
            --  CHILD_ITEM_ID UPDATE
            -------------------------------------------------------------------------------------------------------------     
                UPDATE X
                  SET X.CHILD_ITEM_ID = Y.CHILD_ITEM_ID
--                  SELECT X.CHILD_ITEM_ID , Y.CHILD_ITEM_ID, OPERATION_GROUP
                  FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK X WITH (NOLOCK)
				  -- 2025.09.02	kimcd	속도 개선 HASH 추가
                  INNER HASH JOIN (
                                 SELECT MODEL_ID, CHILD_ITEM_ID 
                                      --,ROW_NUMBER() OVER (PARTITION BY MODEL_ID ORDER BY TCO_CELL_YN DESC) AS Rn		-- KSW 2021-08-26 :: CHILD_ITEM_ID 불일치 오류 수정 (cell requirement total 수식설정오류)
                                  FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V WITH (NOLOCK)
                                 WHERE 0 = 0
                                    AND MODEL_ID IN (SELECT DISTINCT ITEM_ID
                                                    FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK X
                                                   WHERE OPERATION_GROUP ='P'
												     AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd		-- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가

													 AND CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd---------DHJ

													 AND PLAN_TYPE           = @p_plan_type
													 AND SEQ                 = @p_seq
                                                  )
                                   AND OPERATION_GROUP_ID      = 'A'
								   AND LEFT(CHILD_ITEM_ID, 1)  = 'M'		-- KSW 2021-08-26 :: CHILD_ITEM_ID 불일치 오류 수정 (cell requirement total 수식설정오류)
                                   AND CELL_TYPE              IN ('CP', 'CA2') -- 20220701 PJ20230691 활성화 분리
                              ) Y
                  ON X.ITEM_ID = Y.MODEL_ID
                  --AND Y.Rn = 1				-- KSW 2021-08-26 :: CHILD_ITEM_ID 불일치 오류 수정 (cell requirement total 수식설정오류)
                WHERE X.OPERATION_GROUP ='P'
				  AND X.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd		-- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가

				  AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd---------DHJ

				  AND X.PLAN_TYPE           = @p_plan_type
				  AND X.SEQ                 = @p_seq;

                  -- CELL_QTY_PACK

                  UPDATE X
                     SET X.CELL_QTY_PACK = CONVERT(NVARCHAR(50), CEILING(V.ACCUMULATED_CHILD_QTY))
                    FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK X WITH (NOLOCK)
                   INNER JOIN DBO.SCM_MST_MODEL_FINAL_ITEM_BOM_V V WITH (NOLOCK)					
                          ON V.DIVISION_ID         = X.DIVISION_ID 
                         AND V.MODEL_ID            = X.ITEM_ID
                         AND V.CHILD_ITEM_ID       = X.CELL_ITEM_ID
                         AND V.OPERATION_GROUP_ID  = 'A'
                   WHERE X.OPERATION_GROUP ='P'       
				     AND X.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd		-- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가

					 AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd---------DHJ

				     AND X.PLAN_TYPE           = @p_plan_type
				     AND X.SEQ                 = @p_seq;

		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 021 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;  
				   
				  -- PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 :: ISUZU 적용
				  -- ISUZU 모듈에 대한 CELL_QTY_PACK 업데이트
				UPDATE X
				   SET X.CELL_QTY_PACK = ISNULL(Z.CELL_QTY_PACK, 1) / ISNULL(Z.module_qty_pack, 1)
				  FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK X WITH (NOLOCK)
				INNER JOIN (SELECT distinct z.model_id as item_id, z.child_item_id as cell_item_id, z.accumulated_child_qty as cell_qty_pack, y.module_id, y.module_qty_pack
							  FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V z WITH(NOLOCK),
								   ( SELECT x.DIVISION_ID, x.model_id, x.child_item_id as module_id, x.child_qty as module_qty_pack
									   FROM dbo.scm_mst_bom_sn_V x WITH(NOLOCK)	--2021-03-09	SCP 대치 BOM 적용
											INNER JOIN dbo.scm_mst_item_sn i WITH(NOLOCK)
											ON  x.child_division_id = i.division_id
											AND x.child_item_id     = i.item_id
											AND I.FLOW_ID = 'P5000'
											AND x.child_company_id  = i.company_id -- A002 빈강 추가 따른 조건 추가
											AND x.child_site_id     = i.site_id
											AND i.active_flag       = 'Y'     
										    AND x.DIVISION_ID       = @p_division_id      
									  WHERE 1=1
									) Y
							 WHERE z.DIVISION_ID        = Y.DIVISION_ID
								AND z.MODEL_ID           = Y.model_id
								AND z.OPERATION_GROUP_ID = 'A'
							    AND z.DIVISION_ID       = @p_division_id
						   ) Z
					 ON X.ITEM_ID    = Z.MODULE_ID
				  WHERE X.ATTRIBUTE9 = 'P5000'

				    AND X.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd		-- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가
				    AND X.PLAN_TYPE           = @p_plan_type
					AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd---------DHJ
				    AND X.SEQ                 = @p_seq;
				  ;

		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 022 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;  

                   
                   -- LT_DAY
                  UPDATE X
                     SET X.LT_DAY = (CASE WHEN X.BOD_ID='-' THEN '-' ELSE CONVERT(NVARCHAR(50), (B.LT_TOTAL)) END) 
                    FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK X WITH (NOLOCK)         
                    LEFT OUTER JOIN #SCP_MST_BOD_V B WITH (NOLOCK)			
                      ON 0 = 0 	
	                   AND B.DIVISION_ID = X.DIVISION_ID 	
	                   AND B.BOD_ID      = X.BOD_ID  	
	                   AND B.FROM_SITE   = X.FROM_SITE        
					 WHERE X.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd		-- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가
					   AND X.PLAN_TYPE           = @p_plan_type
					   AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd---------DHJ
					   AND X.SEQ                 = @p_seq;					   
                     

		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 023 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;  

            -------------------------------------------------------------------------------------------------------------         
            -- CELL_PKG_PLAN_OUT LT  
            -------------------------------------------------------------------------------------------------------------  
               UPDATE XX
                 SET 
                    XX.LT_DAY    =  YY.TOTAL_LT_FORMATION
                 FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK XX WITH (NOLOCK)
                 INNER JOIN (
                            SELECT MAX(Y.TOTAL_LT_FORMATION)  AS TOTAL_LT_FORMATION, AVG(FORMATION_TOTAL_YIELD) AS FORMATION_TOTAL_YIELD,CELL_ITEM_ID
                             FROM SCP_XLS_PSI_GLOBAL_SMALL_CELL X WITH (NOLOCK)   -- 주의 CELL 테이블 참조함
                             INNER JOIN (
                                            SELECT  ITEM_ID
                                                   ,PLANT_SITE_ID
                                                   ,MAX(FORMATION_TOTAL_YIELD) AS FORMATION_TOTAL_YIELD
                                                   ,MAX(TOTAL_LT_FORMATION)    AS TOTAL_LT_FORMATION
                                                   ,ROW_NUMBER() OVER(PARTITION BY ITEM_ID ORDER BY MAX(TOTAL_LT_FORMATION) DESC) AS Rn
                                              FROM dbo.SCP_MST_FORMATION_V Z  WITH (NOLOCK)
                                              WHERE Z.DIVISION_ID = '40'                                
                                              GROUP BY ITEM_ID 
                                                      ,PLANT_SITE_ID
                                        ) Y
                              ON X.CELL_ITEM_ID = Y.ITEM_ID
                             -- AND X.SITE_ID     = Y.PLANT_SITE_ID
                              WHERE 0 = 0
                                AND MEASURE = 'PROD'       
                                AND Y.Rn = 1
                            GROUP BY CELL_ITEM_ID--,FORMATION_TOTAL_YIELD
                        ) YY
						-- 활성화로 CP-CA 연계 필요
                      --ON XX.CELL_ITEM_ID = YY.CELL_ITEM_ID
					  ON YY.CELL_ITEM_ID = (       
                                            SELECT TOP 1 item_id_assy
                                            FROM   SCP_MST_CELL_PROD_ASSY_MAP with(nolock)
                                            WHERE  item_id_prod = xx.CELL_ITEM_ID
                                            AND    cell_type    = 'CA1'
                                           )
                    WHERE XX.MEASURE = 'CELL_PKG_PLAN_OUT'          
					  AND XX.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd		-- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가
					  AND XX.PLAN_TYPE           = @p_plan_type
					  AND XX.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd---------DHJ
					  AND XX.SEQ                 = @p_seq;

		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 024 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;  

            -------------------------------------------------------------------------------------------------------------         
            -- CELL_PKG_PLAN_OUT YIELD  
            -- [C20200513-000232] 소형SCP Pack Simulator Cell 활성화 수율 적용 요청
            -------------------------------------------------------------------------------------------------------------  
               UPDATE X
                 -- Cell 조립 수율 표기 (조립 수율 : GSCM - SSP - Shipment Plan(IT&Mobile)에 적용된 수율과 동일 수율 적용  
                 -- SSP0015_GET_SHIPMENT_PSI 와 동일 로직 적용
                  SET X.YIELD = ISNULL(CONVERT(NVARCHAR,(SELECT CONVERT(NUMERIC(5,2), ROUND(Y.SSP_MODIFY_YIELD*100,2) ))), '0.0')
                 FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK X WITH (NOLOCK)
                 INNER JOIN ( SELECT A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.PLANT_SITE_ID, A.ITEM_ID,A.SSP_MODIFY_YIELD
                              --, ISNULL(CONVERT(NVARCHAR,(SELECT CONVERT(NUMERIC(5,2), ROUND(Y.SSP_MODIFY_YIELD*100,2) ))), '0')
                                FROM SSP_ANL_FORMATION_C A  WITH (NOLOCK)
                                INNER JOIN (
                                    SELECT DIVISION_ID, MAX(PLAN_START_YYYYMMDD) PLAN_START_YYYYMMDD,  PLAN_TYPE, SEQ, PLANT_SITE_ID, ITEM_ID
                                    FROM SSP_ANL_FORMATION_C WITH (NOLOCK)
                                    GROUP BY DIVISION_ID, PLANT_SITE_ID,  PLAN_TYPE, SEQ, PLANT_SITE_ID, ITEM_ID
                                ) B 
                                 ON A.DIVISION_ID         = B.DIVISION_ID 
                                AND A.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD
                                AND A.PLAN_TYPE           = B.PLAN_TYPE
                                AND A.SEQ                 = B.SEQ
                                AND A.PLANT_SITE_ID       = B.PLANT_SITE_ID 
                                AND A.ITEM_ID             = B.ITEM_ID 
                              ) Y  
                     ON 0 = 0
                    AND X.DIVISION_ID         = Y.DIVISION_ID 
                    AND X.FROM_SITE           = Y.PLANT_SITE_ID 
                    AND X.CELL_ITEM_ID        = Y.ITEM_ID 
                  WHERE 0 = 0
                   -- AND X.PLAN_START_YYYYMMDD = Y.PLAN_START_YYYYMMDD
                    AND Y.PLAN_TYPE           = 'SP'
                    AND Y.SEQ                 = '1'
                    AND X.MEASURE = 'CELL_PKG_PLAN_OUT'  
					AND X.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd		-- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가
				    AND X.PLAN_TYPE           = @p_plan_type
					AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd---------DHJ
				    AND X.SEQ                 = @p_seq;


		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 025 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;  

			-------------------------------------------------------------------------------------------------------------
			-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계- start
			-- BOD_ID에 대한 from_yyyymmdd, to_yyyymmdd 추가 --> ATTRIBUTE3
			-------------------------------------------------------------------------------------------------------------
			UPDATE X
                 SET X.ATTRIBUTE3   = Z.FROM_YYYYMMDD + ',' + Z.TO_YYYYMMDD
               FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK X WITH (NOLOCK)
               INNER JOIN DBO.SCP_MST_BOD_N_V Z  WITH (NOLOCK)
                ON X.BOD_ID   = Z.BOD_ID
                WHERE X.MEASURE IN ('PACK_SHIP_PLAN', 'CELL_SHIP_PLAN')
				  AND X.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd		-- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가
				  AND X.PLAN_TYPE           = @p_plan_type
				  AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd---------DHJ
				  AND X.SEQ                 = @p_seq;
			-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계- end

		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 026 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;  

            -------------------------------------------------------------------------------------------------------------         
            --  52주 데이터 SCRIPT 생성후 UPDATE 
            -------------------------------------------------------------------------------------------------------------     
            
             IF OBJECT_ID('tempdb..#Rn') IS NOT NULL	
	            DROP TABLE #Rn
              --  SELECT 'WQTY' + A.ISO_WEEK     AS WEEK_COLUMN    
              --  , ROW_NUMBER() OVER (ORDER BY ISO_WEEK) AS Rn
              --  INTO #Rn
  	           -- FROM DBO.SCM_SYS_CALENDAR_M A  WITH(NOLOCK)	     
	 		          --WHERE A.BASIS_YYYYMMDD     >= @p_plan_start_yyyymmdd 
              --    AND A.BASIS_YYYYMMDD     <  @p_to_yyyymmdd
              
              CREATE TABLE #Rn
                  ( 
                     WEEK_COLUMN NVARCHAR(6)
                    ,Rn INT
                  )

                  INSERT INTO #Rn
                  SELECT 'WQTY01',	1	  UNION ALL	SELECT 'WQTY01',	2	  UNION ALL	SELECT 'WQTY01',	3	  UNION ALL	SELECT 'WQTY01',	4	  UNION ALL	SELECT 'WQTY01',	5	  UNION ALL	SELECT 'WQTY01',	6	  UNION ALL	SELECT 'WQTY01',	7	  UNION ALL
                  SELECT 'WQTY02',	8	  UNION ALL	SELECT 'WQTY02',	9	  UNION ALL	SELECT 'WQTY02',	10	UNION ALL	SELECT 'WQTY02',	11	UNION ALL	SELECT 'WQTY02',	12	UNION ALL	SELECT 'WQTY02',	13	UNION ALL	SELECT 'WQTY02',	14	UNION ALL
                  SELECT 'WQTY03',	15	UNION ALL	SELECT 'WQTY03',	16	UNION ALL	SELECT 'WQTY03',	17	UNION ALL	SELECT 'WQTY03',	18	UNION ALL	SELECT 'WQTY03',	19	UNION ALL	SELECT 'WQTY03',	20	UNION ALL	SELECT 'WQTY03',	21	UNION ALL
                  SELECT 'WQTY04',	22	UNION ALL	SELECT 'WQTY04',	23	UNION ALL	SELECT 'WQTY04',	24	UNION ALL	SELECT 'WQTY04',	25	UNION ALL	SELECT 'WQTY04',	26	UNION ALL	SELECT 'WQTY04',	27	UNION ALL	SELECT 'WQTY04',	28	UNION ALL
                  SELECT 'WQTY05',	29	UNION ALL	SELECT 'WQTY05',	30	UNION ALL	SELECT 'WQTY05',	31	UNION ALL	SELECT 'WQTY05',	32	UNION ALL	SELECT 'WQTY05',	33	UNION ALL	SELECT 'WQTY05',	34	UNION ALL	SELECT 'WQTY05',	35	UNION ALL
                  SELECT 'WQTY06',	36	UNION ALL	SELECT 'WQTY06',	37	UNION ALL	SELECT 'WQTY06',	38	UNION ALL	SELECT 'WQTY06',	39	UNION ALL	SELECT 'WQTY06',	40	UNION ALL	SELECT 'WQTY06',	41	UNION ALL	SELECT 'WQTY06',	42	UNION ALL
                  SELECT 'WQTY07',	43	UNION ALL	SELECT 'WQTY07',	44	UNION ALL	SELECT 'WQTY07',	45	UNION ALL	SELECT 'WQTY07',	46	UNION ALL	SELECT 'WQTY07',	47	UNION ALL	SELECT 'WQTY07',	48	UNION ALL	SELECT 'WQTY07',	49	UNION ALL
                  SELECT 'WQTY08',	50	UNION ALL	SELECT 'WQTY08',	51	UNION ALL	SELECT 'WQTY08',	52	UNION ALL	SELECT 'WQTY08',	53	UNION ALL	SELECT 'WQTY08',	54	UNION ALL	SELECT 'WQTY08',	55	UNION ALL	SELECT 'WQTY08',	56	UNION ALL
                  SELECT 'WQTY09',	57	UNION ALL	SELECT 'WQTY09',	58	UNION ALL	SELECT 'WQTY09',	59	UNION ALL	SELECT 'WQTY09',	60	UNION ALL	SELECT 'WQTY09',	61	UNION ALL	SELECT 'WQTY09',	62	UNION ALL	SELECT 'WQTY09',	63	UNION ALL
                  SELECT 'WQTY10',	64	UNION ALL	SELECT 'WQTY10',	65	UNION ALL	SELECT 'WQTY10',	66	UNION ALL	SELECT 'WQTY10',	67	UNION ALL	SELECT 'WQTY10',	68	UNION ALL	SELECT 'WQTY10',	69	UNION ALL	SELECT 'WQTY10',	70	UNION ALL
                  SELECT 'WQTY11',	71	UNION ALL	SELECT 'WQTY11',	72	UNION ALL	SELECT 'WQTY11',	73	UNION ALL	SELECT 'WQTY11',	74	UNION ALL	SELECT 'WQTY11',	75	UNION ALL	SELECT 'WQTY11',	76	UNION ALL	SELECT 'WQTY11',	77	UNION ALL
                  SELECT 'WQTY12',	78	UNION ALL	SELECT 'WQTY12',	79	UNION ALL	SELECT 'WQTY12',	80	UNION ALL	SELECT 'WQTY12',	81	UNION ALL	SELECT 'WQTY12',	82	UNION ALL	SELECT 'WQTY12',	83	UNION ALL	SELECT 'WQTY12',	84	UNION ALL
                  SELECT 'WQTY13',	85	UNION ALL	SELECT 'WQTY13',	86	UNION ALL	SELECT 'WQTY13',	87	UNION ALL	SELECT 'WQTY13',	88	UNION ALL	SELECT 'WQTY13',	89	UNION ALL	SELECT 'WQTY13',	90	UNION ALL	SELECT 'WQTY13',	91	UNION ALL
                  SELECT 'WQTY14',	92	UNION ALL	SELECT 'WQTY14',	93	UNION ALL	SELECT 'WQTY14',	94	UNION ALL	SELECT 'WQTY14',	95	UNION ALL	SELECT 'WQTY14',	96	UNION ALL	SELECT 'WQTY14',	97	UNION ALL	SELECT 'WQTY14',	98	UNION ALL
                  SELECT 'WQTY15',	99	UNION ALL	SELECT 'WQTY15',	100	UNION ALL	SELECT 'WQTY15',	101	UNION ALL	SELECT 'WQTY15',	102	UNION ALL	SELECT 'WQTY15',	103	UNION ALL	SELECT 'WQTY15',	104	UNION ALL	SELECT 'WQTY15',	105	UNION ALL
                  SELECT 'WQTY16',	106	UNION ALL	SELECT 'WQTY16',	107	UNION ALL	SELECT 'WQTY16',	108	UNION ALL	SELECT 'WQTY16',	109	UNION ALL	SELECT 'WQTY16',	110	UNION ALL	SELECT 'WQTY16',	111	UNION ALL	SELECT 'WQTY16',	112	UNION ALL
                  SELECT 'WQTY17',	113	UNION ALL	SELECT 'WQTY17',	114	UNION ALL	SELECT 'WQTY17',	115	UNION ALL	SELECT 'WQTY17',	116	UNION ALL	SELECT 'WQTY17',	117	UNION ALL	SELECT 'WQTY17',	118	UNION ALL	SELECT 'WQTY17',	119	UNION ALL
                  SELECT 'WQTY18',	120	UNION ALL	SELECT 'WQTY18',	121	UNION ALL	SELECT 'WQTY18',	122	UNION ALL	SELECT 'WQTY18',	123	UNION ALL	SELECT 'WQTY18',	124	UNION ALL	SELECT 'WQTY18',	125	UNION ALL	SELECT 'WQTY18',	126	UNION ALL
                  SELECT 'WQTY19',	127	UNION ALL	SELECT 'WQTY19',	128	UNION ALL	SELECT 'WQTY19',	129	UNION ALL	SELECT 'WQTY19',	130	UNION ALL	SELECT 'WQTY19',	131	UNION ALL	SELECT 'WQTY19',	132	UNION ALL	SELECT 'WQTY19',	133	UNION ALL
                  SELECT 'WQTY20',	134	UNION ALL	SELECT 'WQTY20',	135	UNION ALL	SELECT 'WQTY20',	136	UNION ALL	SELECT 'WQTY20',	137	UNION ALL	SELECT 'WQTY20',	138	UNION ALL	SELECT 'WQTY20',	139	UNION ALL	SELECT 'WQTY20',	140	UNION ALL
                  SELECT 'WQTY21',	141	UNION ALL	SELECT 'WQTY21',	142	UNION ALL	SELECT 'WQTY21',	143	UNION ALL	SELECT 'WQTY21',	144	UNION ALL	SELECT 'WQTY21',	145	UNION ALL	SELECT 'WQTY21',	146	UNION ALL	SELECT 'WQTY21',	147	UNION ALL
                  SELECT 'WQTY22',	148	UNION ALL	SELECT 'WQTY22',	149	UNION ALL	SELECT 'WQTY22',	150	UNION ALL	SELECT 'WQTY22',	151	UNION ALL	SELECT 'WQTY22',	152	UNION ALL	SELECT 'WQTY22',	153	UNION ALL	SELECT 'WQTY22',	154	UNION ALL
                  SELECT 'WQTY23',	155	UNION ALL	SELECT 'WQTY23',	156	UNION ALL	SELECT 'WQTY23',	157	UNION ALL	SELECT 'WQTY23',	158	UNION ALL	SELECT 'WQTY23',	159	UNION ALL	SELECT 'WQTY23',	160	UNION ALL	SELECT 'WQTY23',	161	UNION ALL
                  SELECT 'WQTY24',	162	UNION ALL	SELECT 'WQTY24',	163	UNION ALL	SELECT 'WQTY24',	164	UNION ALL	SELECT 'WQTY24',	165	UNION ALL	SELECT 'WQTY24',	166	UNION ALL	SELECT 'WQTY24',	167	UNION ALL	SELECT 'WQTY24',	168	UNION ALL
                  SELECT 'WQTY25',	169	UNION ALL	SELECT 'WQTY25',	170	UNION ALL	SELECT 'WQTY25',	171	UNION ALL	SELECT 'WQTY25',	172	UNION ALL	SELECT 'WQTY25',	173	UNION ALL	SELECT 'WQTY25',	174	UNION ALL	SELECT 'WQTY25',	175	UNION ALL
                  SELECT 'WQTY26',	176	UNION ALL	SELECT 'WQTY26',	177	UNION ALL	SELECT 'WQTY26',	178	UNION ALL	SELECT 'WQTY26',	179	UNION ALL	SELECT 'WQTY26',	180	UNION ALL	SELECT 'WQTY26',	181	UNION ALL	SELECT 'WQTY26',	182	UNION ALL
                  SELECT 'WQTY27',	183	UNION ALL	SELECT 'WQTY27',	184	UNION ALL	SELECT 'WQTY27',	185	UNION ALL	SELECT 'WQTY27',	186	UNION ALL	SELECT 'WQTY27',	187	UNION ALL	SELECT 'WQTY27',	188	UNION ALL	SELECT 'WQTY27',	189	UNION ALL
                  SELECT 'WQTY28',	190	UNION ALL	SELECT 'WQTY28',	191	UNION ALL	SELECT 'WQTY28',	192	UNION ALL	SELECT 'WQTY28',	193	UNION ALL	SELECT 'WQTY28',	194	UNION ALL	SELECT 'WQTY28',	195	UNION ALL	SELECT 'WQTY28',	196	UNION ALL
                  SELECT 'WQTY29',	197	UNION ALL	SELECT 'WQTY29',	198	UNION ALL	SELECT 'WQTY29',	199	UNION ALL	SELECT 'WQTY29',	200	UNION ALL	SELECT 'WQTY29',	201	UNION ALL	SELECT 'WQTY29',	202	UNION ALL	SELECT 'WQTY29',	203	UNION ALL
                  SELECT 'WQTY30',	204	UNION ALL	SELECT 'WQTY30',	205	UNION ALL	SELECT 'WQTY30',	206	UNION ALL	SELECT 'WQTY30',	207	UNION ALL	SELECT 'WQTY30',	208	UNION ALL	SELECT 'WQTY30',	209	UNION ALL	SELECT 'WQTY30',	210	UNION ALL
                  SELECT 'WQTY31',	211	UNION ALL	SELECT 'WQTY31',	212	UNION ALL	SELECT 'WQTY31',	213	UNION ALL	SELECT 'WQTY31',	214	UNION ALL	SELECT 'WQTY31',	215	UNION ALL	SELECT 'WQTY31',	216	UNION ALL	SELECT 'WQTY31',	217	UNION ALL
                  SELECT 'WQTY32',	218	UNION ALL	SELECT 'WQTY32',	219	UNION ALL	SELECT 'WQTY32',	220	UNION ALL	SELECT 'WQTY32',	221	UNION ALL	SELECT 'WQTY32',	222	UNION ALL	SELECT 'WQTY32',	223	UNION ALL	SELECT 'WQTY32',	224	UNION ALL
                  SELECT 'WQTY33',	225	UNION ALL	SELECT 'WQTY33',	226	UNION ALL	SELECT 'WQTY33',	227	UNION ALL	SELECT 'WQTY33',	228	UNION ALL	SELECT 'WQTY33',	229	UNION ALL	SELECT 'WQTY33',	230	UNION ALL	SELECT 'WQTY33',	231	UNION ALL
                  SELECT 'WQTY34',	232	UNION ALL	SELECT 'WQTY34',	233	UNION ALL	SELECT 'WQTY34',	234	UNION ALL	SELECT 'WQTY34',	235	UNION ALL	SELECT 'WQTY34',	236	UNION ALL	SELECT 'WQTY34',	237	UNION ALL	SELECT 'WQTY34',	238	UNION ALL
                  SELECT 'WQTY35',	239	UNION ALL	SELECT 'WQTY35',	240	UNION ALL	SELECT 'WQTY35',	241	UNION ALL	SELECT 'WQTY35',	242	UNION ALL	SELECT 'WQTY35',	243	UNION ALL	SELECT 'WQTY35',	244	UNION ALL	SELECT 'WQTY35',	245	UNION ALL
                  SELECT 'WQTY36',	246	UNION ALL	SELECT 'WQTY36',	247	UNION ALL	SELECT 'WQTY36',	248	UNION ALL	SELECT 'WQTY36',	249	UNION ALL	SELECT 'WQTY36',	250	UNION ALL	SELECT 'WQTY36',	251	UNION ALL	SELECT 'WQTY36',	252	UNION ALL
                  SELECT 'WQTY37',	253	UNION ALL	SELECT 'WQTY37',	254	UNION ALL	SELECT 'WQTY37',	255	UNION ALL	SELECT 'WQTY37',	256	UNION ALL	SELECT 'WQTY37',	257	UNION ALL	SELECT 'WQTY37',	258	UNION ALL	SELECT 'WQTY37',	259	UNION ALL
                  SELECT 'WQTY38',	260	UNION ALL	SELECT 'WQTY38',	261	UNION ALL	SELECT 'WQTY38',	262	UNION ALL	SELECT 'WQTY38',	263	UNION ALL	SELECT 'WQTY38',	264	UNION ALL	SELECT 'WQTY38',	265	UNION ALL	SELECT 'WQTY38',	266	UNION ALL
                  SELECT 'WQTY39',	267	UNION ALL	SELECT 'WQTY39',	268	UNION ALL	SELECT 'WQTY39',	269	UNION ALL	SELECT 'WQTY39',	270	UNION ALL	SELECT 'WQTY39',	271	UNION ALL	SELECT 'WQTY39',	272	UNION ALL	SELECT 'WQTY39',	273	UNION ALL
                  SELECT 'WQTY40',	274	UNION ALL	SELECT 'WQTY40',	275	UNION ALL	SELECT 'WQTY40',	276	UNION ALL	SELECT 'WQTY40',	277	UNION ALL	SELECT 'WQTY40',	278	UNION ALL	SELECT 'WQTY40',	279	UNION ALL	SELECT 'WQTY40',	280	UNION ALL
                  SELECT 'WQTY41',	281	UNION ALL	SELECT 'WQTY41',	282	UNION ALL	SELECT 'WQTY41',	283	UNION ALL	SELECT 'WQTY41',	284	UNION ALL	SELECT 'WQTY41',	285	UNION ALL	SELECT 'WQTY41',	286	UNION ALL	SELECT 'WQTY41',	287	UNION ALL
                  SELECT 'WQTY42',	288	UNION ALL	SELECT 'WQTY42',	289	UNION ALL	SELECT 'WQTY42',	290	UNION ALL	SELECT 'WQTY42',	291	UNION ALL	SELECT 'WQTY42',	292	UNION ALL	SELECT 'WQTY42',	293	UNION ALL	SELECT 'WQTY42',	294	UNION ALL
                  SELECT 'WQTY43',	295	UNION ALL	SELECT 'WQTY43',	296	UNION ALL	SELECT 'WQTY43',	297	UNION ALL	SELECT 'WQTY43',	298	UNION ALL	SELECT 'WQTY43',	299	UNION ALL	SELECT 'WQTY43',	300	UNION ALL	SELECT 'WQTY43',	301	UNION ALL
                  SELECT 'WQTY44',	302	UNION ALL	SELECT 'WQTY44',	303	UNION ALL	SELECT 'WQTY44',	304	UNION ALL	SELECT 'WQTY44',	305	UNION ALL	SELECT 'WQTY44',	306	UNION ALL	SELECT 'WQTY44',	307	UNION ALL	SELECT 'WQTY44',	308	UNION ALL
                  SELECT 'WQTY45',	309	UNION ALL	SELECT 'WQTY45',	310	UNION ALL	SELECT 'WQTY45',	311	UNION ALL	SELECT 'WQTY45',	312	UNION ALL	SELECT 'WQTY45',	313	UNION ALL	SELECT 'WQTY45',	314	UNION ALL	SELECT 'WQTY45',	315	UNION ALL
                  SELECT 'WQTY46',	316	UNION ALL	SELECT 'WQTY46',	317	UNION ALL	SELECT 'WQTY46',	318	UNION ALL	SELECT 'WQTY46',	319	UNION ALL	SELECT 'WQTY46',	320	UNION ALL	SELECT 'WQTY46',	321	UNION ALL	SELECT 'WQTY46',	322	UNION ALL
                  SELECT 'WQTY47',	323	UNION ALL	SELECT 'WQTY47',	324	UNION ALL	SELECT 'WQTY47',	325	UNION ALL	SELECT 'WQTY47',	326	UNION ALL	SELECT 'WQTY47',	327	UNION ALL	SELECT 'WQTY47',	328	UNION ALL	SELECT 'WQTY47',	329	UNION ALL
                  SELECT 'WQTY48',	330	UNION ALL	SELECT 'WQTY48',	331	UNION ALL	SELECT 'WQTY48',	332	UNION ALL	SELECT 'WQTY48',	333	UNION ALL	SELECT 'WQTY48',	334	UNION ALL	SELECT 'WQTY48',	335	UNION ALL	SELECT 'WQTY48',	336	UNION ALL
                  SELECT 'WQTY49',	337	UNION ALL	SELECT 'WQTY49',	338	UNION ALL	SELECT 'WQTY49',	339	UNION ALL	SELECT 'WQTY49',	340	UNION ALL	SELECT 'WQTY49',	341	UNION ALL	SELECT 'WQTY49',	342	UNION ALL	SELECT 'WQTY49',	343	UNION ALL
                  SELECT 'WQTY50',	344	UNION ALL	SELECT 'WQTY50',	345	UNION ALL	SELECT 'WQTY50',	346	UNION ALL	SELECT 'WQTY50',	347	UNION ALL	SELECT 'WQTY50',	348	UNION ALL	SELECT 'WQTY50',	349	UNION ALL	SELECT 'WQTY50',	350	UNION ALL
                  SELECT 'WQTY51',	351	UNION ALL	SELECT 'WQTY51',	352	UNION ALL	SELECT 'WQTY51',	353	UNION ALL	SELECT 'WQTY51',	354	UNION ALL	SELECT 'WQTY51',	355	UNION ALL	SELECT 'WQTY51',	356	UNION ALL	SELECT 'WQTY51',	357	UNION ALL
                  SELECT 'WQTY52',	358	UNION ALL	SELECT 'WQTY52',	359	UNION ALL	SELECT 'WQTY52',	360	UNION ALL	SELECT 'WQTY52',	361	UNION ALL	SELECT 'WQTY52',	362	UNION ALL	SELECT 'WQTY52',	363	UNION ALL	SELECT 'WQTY52',	364	


	          IF OBJECT_ID('tempdb..#CALENDAR') IS NOT NULL	
	            DROP TABLE #CALENDAR

	            SELECT 'D_'+A.BASIS_YYYYMMDD   AS D_YYYYMMDD
                      ,'QTY' + REPLICATE('0', 3 - LEN(ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD) )) + CONVERT(NVARCHAR,ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD)) AS YYYYMMDD_COLUMN
                      , MAX('W_' + A.BASIS_YYYYMM + ISO_WEEK) AS W_YYYY_WEEK 
                      , MAX('M_' + A.BASIS_YYYYMM) AS M_YYYYMM 
                      , MAX(ISO_WEEK) AS ISO_WEEK 
                      , ROW_NUMBER() OVER (ORDER BY A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 31) ) AS Rn
					            , A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 31) AS SORT_ORDER_NO
                  INTO #CALENDAR
						      FROM DBO.SCM_SYS_CALENDAR_M A
					      WHERE A.BASIS_YYYYMMDD  >= @p_create_from_yyyymmdd ------------------------------------------------DHJ****
                  AND A.BASIS_YYYYMMDD  < @p_create_to_yyyymmdd
					      GROUP BY A.BASIS_YYYYMMDD--,ISO_WEEK--,A.BASIS_YYYYMM,ISO_WEEK

		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 027 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;  

                      --SELECT * FROM #Rn
                      --order by rn
                      --SELECT * FROM #CALENDAR 
                      --order by SORT_ORDER_NO
	          IF OBJECT_ID('tempdb..#HEADER') IS NOT NULL	
	            DROP TABLE #HEADER
                  SELECT YYYYMMDD_COLUMN, WEEK_COLUMN, W_YYYY_WEEK,M_YYYYMM,ISO_WEEK, SORT_ORDER_NO, X.Rn
                  INTO #HEADER
                  FROM #CALENDAR X
                  INNER JOIN #Rn Y ON X.Rn = Y.Rn
                  order by x.rn

    
              DECLARE @mQry_sumWeek NVARCHAR(MAX);      
   
                SET @mQry_sumWeek = 'UPDATE X '+CHAR(10)
                SELECT @mQry_sumWeek = @mQry_sumWeek + 'SET '+CHAR(10) 
                SELECT @mQry_sumWeek = @mQry_sumWeek + '' + WSUM + ','+CHAR(10)  
               FROM (SELECT DISTINCT WEEK_COLUMN, WEEK_COLUMN +' = (' + 
                         STUFF((
                              SELECT '+' + YYYYMMDD_COLUMN
                              FROM   #HEADER
                              WHERE  WEEK_COLUMN = A.WEEK_COLUMN
                              ORDER BY SORT_ORDER_NO
                              FOR XML PATH('')
                         ),1,1,'') +')'  AS WSUM
                         , MIN(SORT_ORDER_NO)-1 AS SORT_ORDER_NO
                        FROM  #HEADER AS A
                        GROUP BY WEEK_COLUMN
                        ) A 
                ORDER BY WEEK_COLUMN
--              SELECT @mQry_sumWeek = @mQry_sumWeek + 'SET'+CHAR(10) 
              SET @mQry_sumWeek = LEFT(@mQry_sumWeek, LEN(@mQry_sumWeek) -2)
              SELECT @mQry_sumWeek = @mQry_sumWeek + CHAR(10) +   ' FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK X WITH (NOLOCK)'+CHAR(10) 

			  SET @mQry_sumWeek = @mQry_sumWeek + ' WHERE X.PLAN_START_YYYYMMDD  = ''' + @p_plan_start_yyyymmdd + ''''+CHAR(10);		-- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가
			  SET @mQry_sumWeek = @mQry_sumWeek + '	  AND X.CREATE_FROM_YYYYMMDD = ''' + @p_create_from_yyyymmdd + ''''+CHAR(10);---------DHJ
			  SET @mQry_sumWeek = @mQry_sumWeek + '   AND X.PLAN_TYPE           = ''' + @p_plan_type + ''''+CHAR(10);
			  SET @mQry_sumWeek = @mQry_sumWeek + '   AND X.SEQ                 = ''' + @p_seq + ''''+CHAR(10);
			  ----------------------------------------------------------DHJ
			  /*
			  PRINT '@mQry_sumWeek'
              PRINT @mQry_sumWeek
			  */
              EXEC sp_executesql @mQry_sumWeek;
			  
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

		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 028 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;  
						
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
                   FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK X WITH (NOLOCK)
                   INNER JOIN #LineLoad_WEEK_PIVOT Y WITH (NOLOCK)
                      ON Y.PROD_LINE    = X.PROD_LINE 
                     AND X.DIVISION_ID  = Y.DIVISION_ID
                     AND X.FROM_SITE    = Y.SITE_ID
                     AND X.ATTRIBUTE9   = Y.OPERATION_ID
                   WHERE X.MEASURE IN ('PACK_PROD_LOAD') 
					 AND X.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd		-- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가
					 AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd---------DHJ
					 AND X.PLAN_TYPE           = @p_plan_type
					 AND X.SEQ                 = @p_seq;
--             


		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 029 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;  

              -- END_CUSTOMER UPDATE
              UPDATE X
                SET X.END_CUSTOMER = Y.SOLDTO_CUSTOMER
                FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK X WITH (NOLOCK)
                INNER JOIN SCM_MST_SITE Y  WITH (NOLOCK)
                ON X.DIVISION_ID = Y.DIVISION_ID
                AND X.TO_SITE = Y.SCM_SITE_ID
				WHERE X.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd		-- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가
				AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd---------DHJ
				  AND X.PLAN_TYPE           = @p_plan_type
				  AND X.SEQ                 = @p_seq;
				  

		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 030 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;  

              -- PROJECT CODE UPDATE
                UPDATE X
                  SET X.PROJECT_CODE = Y.MIN_PROJECT_CODE
                  FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK X  WITH (NOLOCK)
                  INNER JOIN (
                                SELECT DISTINCT					-- 2021.11.17 DISTINCT 추가
								       A.DIVISION_ID
                                      ,A.PLAN_START_YYYYMMDD
                                      ,A.PLAN_TYPE
                                      ,A.SEQ
                                      ,A.BIZ_TYPE
                                      ,MIN(A.PROJECT_CODE) AS MIN_PROJECT_CODE	-- 동일  조건에서 2개 이상의 프로젝트 코드가 있음 (AMEND를 제외하고는 하나로 합침. 20231026. 신재욱 책임)
                                      ,A.ITEM_ID
									  ,A.TO_SITE
									  ,A.FROM_SITE
                                      FROM SCP_ANL_SHIPMENT_PLAN_FG A WITH (NOLOCK)
                                     WHERE A.DIVISION_ID			      =  @p_division_id
		                                    AND A.PLAN_START_YYYYMMDD	  =  @p_plan_start_yyyymmdd
		                                    AND A.PLAN_TYPE				      =  @p_plan_type
		                                    AND A.SEQ					          =  @p_seq
--		                                    AND A.YYYYMMDD              =  @p_plan_start_yyyymmdd
											AND A.YYYYMMDD              =  @p_create_from_yyyymmdd
											
                                        AND A.PROJECT_CODE          <> '-'
										AND A.MEASURE                   <> 'SHIP_PLAN_AMEND'		-- 2021.11.17 조건절 추가
--                                        AND A.BIZ_TYPE              =  'A'
                                      GROUP BY 
                                            A.DIVISION_ID
                                           ,A.PLAN_START_YYYYMMDD
                                           ,A.PLAN_TYPE
                                           ,A.SEQ
                                           ,A.BIZ_TYPE
                                           ,A.ITEM_ID
										   ,A.TO_SITE
										   ,A.FROM_SITE
                              ) Y
                      ON     X.DIVISION_ID           = Y.DIVISION_ID
                         AND X.PLAN_START_YYYYMMDD   = Y.PLAN_START_YYYYMMDD
                         AND X.PLAN_TYPE             = Y.PLAN_TYPE
                         AND X.SEQ                   = Y.SEQ
                         AND X.OPERATION_GROUP       = Y.BIZ_TYPE
--                         AND X.PROJECT_CODE          = Y.PROJECT_CODE
                         AND X.ITEM_ID               = Y.ITEM_ID
						 AND X.TO_SITE               = Y.TO_SITE		-- 2021.11.17 조건절 추가
						 AND X.FROM_SITE		     = Y.FROM_SITE		-- 2021.11.17 조건절 추가
                         AND X.OPERATION_GROUP       = 'P'
					   WHERE X.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd		-- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가

					     AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd
					   
						 AND X.PLAN_TYPE           = @p_plan_type
						 AND X.SEQ                 = @p_seq;

						 
		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 031 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;  

						 
                    UPDATE XX
                    SET XX.PROJECT_CODE =  YY.PROJECT_CODE
                    FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK XX  WITH (NOLOCK)
                    INNER JOIN 
                      (
                            -- 20260615 튜닝. 주석처리 시작
                            /* 
                         SELECT  DISTINCT CELL_ITEM_ID, 
                                            STUFF((SELECT ',' + PROJECT_CODE
                                                    FROM (
                                                            SELECT DISTINCT X.PROJECT_CODE
                                                            FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK X  WITH (NOLOCK)
                                                            WHERE 0 = 0
                                                            AND X.OPERATION_GROUP ='P'
                                                            AND X.CELL_ITEM_ID = Y.CELL_ITEM_ID
                                                            AND X.PROJECT_CODE <> '-'
															AND X.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd		-- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가
															AND X.PLAN_TYPE           = @p_plan_type
															AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd-----------------------DHJ
															AND X.SEQ                 = @p_seq
                                                            ) X
                                                            FOR XML PATH('')),1,1,''
                                                          ) AS PROJECT_CODE
                          FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK Y  WITH (NOLOCK)
                          WHERE 0 = 0
                            AND Y.OPERATION_GROUP ='P'
                            AND Y.PROJECT_CODE <> '-'
							AND Y.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd		-- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가
							AND Y.PLAN_TYPE           = @p_plan_type
							AND Y.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd -----------------------DHJ
							AND Y.SEQ                 = @p_seq
                            */
                            -- 20260615 튜닝. 주석처리 끝
                            -- 20260615 튜닝. 신규로직 시작
                             SELECT CELL_ITEM_ID , STRING_AGG(PROJECT_CODE,',') AS PROJECT_CODE FROM
                             (
                              SELECT  DISTINCT CELL_ITEM_ID, Y.PROJECT_CODE
                                FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK Y  WITH (NOLOCK)
                                WHERE 0 = 0
                                AND Y.OPERATION_GROUP ='P'
                                AND Y.PROJECT_CODE <> '-'
	                            AND Y.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd		-- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가
	                            AND Y.PLAN_TYPE           = @p_plan_type
	                            AND Y.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd -----------------------DHJ
	                            AND Y.SEQ                 = @p_seq
                            ) AS LIST   
                            GROUP BY CELL_ITEM_ID
                            -- 20260615 튜닝. 신규로직 끝


                      ) YY
                        ON XX.CELL_ITEM_ID    = YY.CELL_ITEM_ID
                       AND XX.OPERATION_GROUP ='A'
                       AND MEASURE NOT IN ('DM_MKT_FCST','SHIP_REQ','WHIN_TOTAL','SHIP_PLAN_TOTAL','INTRANSIT_TOTAL','BALANCE','BALANCE_CUM','TO_SITE_BOH','TO_SITE_EOH')
					 WHERE XX.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd		-- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가
					   AND XX.PLAN_TYPE           = @p_plan_type
					   AND XX.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd-----------------------DHJ
					   AND XX.SEQ                 = @p_seq;

		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 032 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;  
					   
                       -- 보정 PACK_SHIP_PLAN 이 중복으로 나옴.. --> 추가 수정 할것, 상단 로직 다시 확인 해야 함.
              DELETE TBL FROM
	                (
	                        SELECT
	                               ROW_NUMBER() OVER (PARTITION BY CELL_ITEM_ID,ITEM_ID,NICK_NAME,TO_SITE,PROJECT_CODE,INCOTERMS,FROM_SITE,TRANSPORT_MODE,PROD_LINE,BOD_ID  
                                                        ORDER BY ITEM_ID
                                                                ,(
                                                                  QTY001+QTY002+QTY003+QTY004+QTY005+QTY006+QTY007+QTY008+QTY009+QTY010+
                                                                  QTY011+QTY012+QTY013+QTY014+QTY015+QTY016+QTY017+QTY018+QTY019+QTY020+
                                                                  QTY021+QTY022+QTY023+QTY024+QTY025+QTY026+QTY027+QTY028+QTY029+QTY310+
                                                                  QTY031+QTY032+QTY033+QTY034+QTY035+QTY036+QTY037+QTY038+QTY039+QTY310+
                                                                  QTY041+QTY042+QTY043+QTY044+QTY045+QTY046+QTY047+QTY048+QTY049+QTY050+
                                                                  QTY051+QTY052+QTY053+QTY054+QTY055+QTY056+QTY057+QTY058+QTY059+QTY060+
                                                                  QTY061+QTY062+QTY063+QTY064+QTY065+QTY066+QTY067+QTY068+QTY069+QTY070+
                                                                  QTY071+QTY072+QTY073+QTY074+QTY075+QTY076+QTY077+QTY078+QTY079+QTY080+
                                                                  QTY081+QTY082+QTY083+QTY084+QTY085+QTY086+QTY087+QTY088+QTY089+QTY090+
                                                                  QTY091+QTY092+QTY093+QTY094+QTY095+QTY096+QTY097+QTY098+QTY099+QTY100+

                                                                  QTY101+QTY102+QTY103+QTY104+QTY105+QTY106+QTY107+QTY108+QTY109+QTY110+
                                                                  QTY111+QTY112+QTY113+QTY114+QTY115+QTY116+QTY117+QTY118+QTY119+QTY120+
                                                                  QTY121+QTY122+QTY123+QTY124+QTY125+QTY126+QTY127+QTY128+QTY129+QTY110+
                                                                  QTY131+QTY132+QTY133+QTY134+QTY135+QTY136+QTY137+QTY138+QTY139+QTY110+
                                                                  QTY141+QTY142+QTY143+QTY144+QTY145+QTY146+QTY147+QTY148+QTY149+QTY150+
                                                                  QTY151+QTY152+QTY153+QTY154+QTY155+QTY156+QTY157+QTY158+QTY159+QTY160+
                                                                  QTY161+QTY162+QTY163+QTY164+QTY165+QTY166+QTY167+QTY168+QTY169+QTY170+
                                                                  QTY171+QTY172+QTY173+QTY174+QTY175+QTY176+QTY177+QTY178+QTY179+QTY180+
                                                                  QTY181+QTY182+QTY183+QTY184+QTY185+QTY186+QTY187+QTY188+QTY189+QTY190+
                                                                  QTY191+QTY192+QTY193+QTY194+QTY195+QTY196+QTY197+QTY198+QTY199+QTY200+

                                                                  QTY201+QTY202+QTY203+QTY204+QTY205+QTY206+QTY207+QTY208+QTY209+QTY210+
                                                                  QTY211+QTY212+QTY213+QTY214+QTY215+QTY216+QTY217+QTY218+QTY219+QTY220+
                                                                  QTY221+QTY222+QTY223+QTY224+QTY225+QTY226+QTY227+QTY228+QTY229+QTY210+
                                                                  QTY231+QTY232+QTY233+QTY234+QTY235+QTY236+QTY237+QTY238+QTY239+QTY210+
                                                                  QTY241+QTY242+QTY243+QTY244+QTY245+QTY246+QTY247+QTY248+QTY249+QTY250+
                                                                  QTY251+QTY252+QTY253+QTY254+QTY255+QTY256+QTY257+QTY258+QTY259+QTY260+
                                                                  QTY261+QTY262+QTY263+QTY264+QTY265+QTY266+QTY267+QTY268+QTY269+QTY270+
                                                                  QTY271+QTY272+QTY273+QTY274+QTY275+QTY276+QTY277+QTY278+QTY279+QTY280+
                                                                  QTY281+QTY282+QTY283+QTY284+QTY285+QTY286+QTY287+QTY288+QTY289+QTY290+
                                                                  QTY291+QTY292+QTY293+QTY294+QTY295+QTY296+QTY297+QTY298+QTY299+QTY300+

                                                                  QTY301+QTY302+QTY303+QTY304+QTY305+QTY306+QTY307+QTY308+QTY309+QTY310+
                                                                  QTY311+QTY312+QTY313+QTY314+QTY315+QTY316+QTY317+QTY318+QTY319+QTY320+
                                                                  QTY321+QTY322+QTY323+QTY324+QTY325+QTY326+QTY327+QTY328+QTY329+QTY310+
                                                                  QTY331+QTY332+QTY333+QTY334+QTY335+QTY336+QTY337+QTY338+QTY339+QTY310+
                                                                  QTY341+QTY342+QTY343+QTY344+QTY345+QTY346+QTY347+QTY348+QTY349+QTY350+
                                                                  QTY351+QTY352+QTY353+QTY354+QTY355+QTY356+QTY357+QTY358+QTY359+QTY360+
                                                                  QTY361+QTY362+QTY363+QTY364
                                                                  ) DESC 
                                                               , xls_key1 desc
                                                    ) AS ROWNUM
--                                 ,*
	                        FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK  WITH (NOLOCK)
                          WHERE MEASURE IN ('PACK_SHIP_PLAN')
							AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd		-- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가
							AND PLAN_TYPE           = @p_plan_type
							AND CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd-----------------------DHJ
							AND SEQ                 = @p_seq
	                ) AS TBL
	                WHERE TBL.ROWNUM > 1


		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 033 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;                
                 

                 ---- 중복 제거 WHERE MEASURE IN ('CELL_REQ','CELL_BALANCE','CELL_WHIN')
                 DELETE TBL FROM
	                (
	                        SELECT
	                               --ROW_NUMBER() OVER (PARTITION BY DIVISION_ID,OPERATION_GROUP,CELL_ITEM_ID,ITEM_ID,TO_SITE,PROJECT_CODE,FROM_BOH_QTY,TO_BOH_QTY,INCOTERMS,FROM_SITE,TRANSPORT_MODE,PROD_LINE,MEASURE
                                --                                  ORDER BY CELL_ITEM_ID) AS ROWNUM
                                ROW_NUMBER() OVER (PARTITION BY DIVISION_ID,OPERATION_GROUP,CELL_ITEM_ID,ITEM_ID,TO_SITE,PROJECT_CODE,INCOTERMS,FROM_SITE,TRANSPORT_MODE,PROD_LINE,MEASURE
                                    ORDER BY CELL_ITEM_ID,ATTRIBUTE1) AS ROWNUM
	                        FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK  WITH (NOLOCK)
                          WHERE MEASURE IN ('CELL_REQ','CELL_BALANCE','CELL_WHIN')
							AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd		-- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가
							AND PLAN_TYPE           = @p_plan_type
							AND CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd-----------------------DHJ
							AND SEQ                 = @p_seq
	                ) AS TBL
	                WHERE TBL.ROWNUM > 1
					;


		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 034 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;  

                -- PACK 일 경우 'DM_MKT_FCST','SHIP_REQ','WHIN_TOTAL','SHIP_PLAN_TOTAL','INTRANSIT_TOTAL','BALANCE','BALANCE_CUM','TO_SITE_BOH','TO_SITE_EOH' 삭제
                DELETE FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK
                WHERE OPERATION_GROUP ='A'
                AND MEASURE IN ('DM_MKT_FCST','SHIP_REQ','WHIN_TOTAL','SHIP_PLAN_TOTAL','INTRANSIT_TOTAL','BALANCE','BALANCE_CUM','TO_SITE_BOH','TO_SITE_EOH')
				AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd		-- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가
				AND PLAN_TYPE           = @p_plan_type
				AND CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd-----------------------DHJ
				AND SEQ                 = @p_seq;

		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 035 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;  

                UPDATE X
                   SET X.TO_SITE = '-'
                     ,X.TO_SITE_DESCRIPTION = '-'
                     , X.PROJECT_CODE = '-'
--                SELECT DISTINCT CELL_ITEM_ID, ITEM_ID
                FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK X WITH (NOLOCK)
                WHERE X.MEASURE           IN ('CELL_PKG_PLAN_IN','CELL_PKG_PLAN_OUT','CELL_FORMATION','CELL_BOH','CELL_EOH')
				  AND X.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd		-- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가
				  AND X.PLAN_TYPE           = @p_plan_type
				  AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd-----------------------DHJ
				  AND X.SEQ                 = @p_seq;
                 
		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 036 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;  

                ---- 중복 제거 WHERE MEASURE IN  ('CELL_PKG_PLAN_IN','CELL_PKG_PLAN_OUT','CELL_FORMATION','CELL_BOH','CELL_EOH')
                 DELETE TBL FROM
	                (
	                        SELECT
	                               --ROW_NUMBER() OVER (PARTITION BY DIVISION_ID,OPERATION_GROUP,CELL_ITEM_ID,ITEM_ID,TO_SITE,PROJECT_CODE,FROM_BOH_QTY,TO_BOH_QTY,INCOTERMS,FROM_SITE,TRANSPORT_MODE,PROD_LINE,MEASURE
                                --                                  ORDER BY CELL_ITEM_ID) AS ROWNUM
                                ROW_NUMBER() OVER (PARTITION BY DIVISION_ID,OPERATION_GROUP,CELL_ITEM_ID,ITEM_ID,TO_SITE,PROJECT_CODE,INCOTERMS,FROM_SITE,TRANSPORT_MODE,PROD_LINE,MEASURE
                                    ORDER BY CELL_ITEM_ID,XLS_KEY1 DESC) AS ROWNUM
	                        FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK  WITH (NOLOCK)
                          WHERE MEASURE IN ('CELL_PKG_PLAN_IN','CELL_PKG_PLAN_OUT','CELL_FORMATION','CELL_BOH','CELL_EOH')
							AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd		-- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가
							AND PLAN_TYPE           = @p_plan_type
							AND CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd-----------------------DHJ
							AND SEQ                 = @p_seq
	                ) AS TBL
	                WHERE TBL.ROWNUM > 1
					;

		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 037 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;  


			-- 2022-03-31   KSW         OSP LT 적용 :: 생산계획의 LT 컬럼에 OSP LT 값을 표시하고 Pack Midel Inventory (EOH) 수식을 변경한다. (생산계획에 LT 적용) - start
				UPDATE X
					SET X.LT_DAY = Y.LT_DAY
					FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK X  WITH (NOLOCK)
					INNER JOIN SCP_MST_OPERATION_LT Y WITH (NOLOCK)
					ON X.DIVISION_ID   = Y.DIVISION_ID
					AND X.FROM_SITE    = Y.SCM_SITE_ID
					AND X.ITEM_ID      = Y.ITEM_ID
					AND X.MEASURE      ='PACK_PROD'       
					AND Y.LT_OPERATION = 'OSP_LT'
				  WHERE X.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd		-- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가
					AND X.PLAN_TYPE           = @p_plan_type
					AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd-----------------------DHJ
					AND X.SEQ                 = @p_seq
					;

		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 038 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;  

            -- 2022-03-31   KSW         OSP LT 적용 :: 생산계획의 LT 컬럼에 OSP LT 값을 표시하고 Pack Midel Inventory (EOH) 수식을 변경한다. (생산계획에 LT 적용) - end    

			-- 2022-07-01   KSW         PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 :: ISUZU 적용 :: 불필요한 measure 삭제 - start
                    DELETE X
                      FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK X
                     WHERE 0 = 0
                      AND X.MEASURE         IN ('CELL_REQ','CELL_BALANCE','CELL_WHIN')
                      AND X.OPERATION_GROUP ='A'
                      AND X.NICK_NAME       LIKE '%ISUZU%'
					  AND X.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd		-- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가
					  AND X.PLAN_TYPE           = @p_plan_type
					  AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd-----------------------DHJ
					  AND X.SEQ                 = @p_seq;

		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 039 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;  

			-- 2022-07-01   KSW         ISUZU 적용 :: 불필요한 measure 삭제 - end

            -------------------------------------------------------------------------------------------------------------         
            -- PACK_PROD_LOAD ISUZU 예외처리 - 2022.07.29
			-- LINE ID UPDATE
            ------------------------------------------------------------------------------------------------------------- 
			  UPDATE X
			     SET X.PROD_LINE = Y.PROD_LINE
				FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK X WITH (NOLOCK)
				INNER JOIN SCP_XLS_PSI_GLOBAL_SMALL_PACK Y WITH (NOLOCK)
				  ON X.DIVISION_ID         = Y.DIVISION_ID
				 AND X.PLAN_START_YYYYMMDD = Y.PLAN_START_YYYYMMDD		-- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가
				 AND X.PLAN_TYPE           = Y.PLAN_TYPE
				 AND X.SEQ				   = Y.SEQ
				 AND X.ITEM_ID             = Y.ITEM_ID
				 AND X.FROM_SITE           = Y.FROM_SITE
				 AND X.ATTRIBUTE9          = Y.ATTRIBUTE9
			   WHERE X.MEASURE     = 'PACK_PROD_LOAD'
			     AND Y.MEASURE     = 'PACK_PROD'
			     AND X.ATTRIBUTE9  = 'P5000'	
				 AND X.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd		-- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: 필수조건절추가
				 AND X.PLAN_TYPE           = @p_plan_type
				 AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd-----------------------DHJ
				 AND X.SEQ                 = @p_seq;				
				 ;

		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 040 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;  
            ------------------------------------------------------------------------------------------------------------- start        
            -- 2022-07-28 KSW W-1주차 생산/출하계획을 표시하는 measure 추가 등 :: W-1 주차 PR 플랜에 대한 생산/출하 measure 추가
            -------------------------------------------------------------------------------------------------------------
			-- W-1 주차 PR 플랜 measure 에 해당 주차의 월 1일 ~ 해당주차 시작전일 까지 실적 SUM 조회 (컬럼) 
				IF OBJECT_ID('tempdb..#tmp_PLAN_WEEK_FROM_TO') IS NOT NULL	
					DROP TABLE #tmp_PLAN_WEEK_FROM_TO

					------------------------------------------------------------------------------------------------
					-----------------------------------------------------------------------------------------------DHJ
				-- 수행된 이력에 대한 주차 구간 :: 당월 각 플랜이 실행된 주차의 시작일(월요일) ~ 마지막일(일요일) 의 실적 (당주 제외)
				SELECT X.PLAN_START_YYYYMMDD
					  ,X.PLAN_SEQ
--					  ,(CASE WHEN LEFT(X.START_YYYYMMDD, 6) <> LEFT(@p_plan_start_yyyymmdd, 6) THEN LEFT(@p_plan_start_yyyymmdd, 6) + '01'
					  ,(CASE WHEN LEFT(X.START_YYYYMMDD, 6) <> LEFT(@p_create_from_yyyymmdd, 6) THEN LEFT(@p_create_from_yyyymmdd, 6) + '01'					  
							 ELSE X.START_YYYYMMDD END) AS START_YYYYMMDD
					  ,X.END_YYYYMMDD
				  INTO #tmp_PLAN_WEEK_FROM_TO
				  FROM (
						SELECT P.PLAN_START_YYYYMMDD
							  ,MIN(C.BASIS_YYYYMMDD) AS START_YYYYMMDD
							  ,MAX(C.BASIS_YYYYMMDD) AS END_YYYYMMDD
							  ,P.PLAN_SEQ
						  FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
						 INNER JOIN 
							   (SELECT A.PLAN_NAME AS PLAN_START_YYYYMMDD
									  ,A.PLAN_ID
									  ,MAX(B.PLAN_SEQ) AS PLAN_SEQ
								  FROM SCM_MST_PLAN A WITH (NOLOCK)
								 INNER JOIN SCM_MST_PLAN_DETAIL B WITH (NOLOCK)
									ON A.DIVISION_ID = B.DIVISION_ID 
								   AND A.PLAN_ID     = B.PLAN_ID 
								 WHERE A.DIVISION_ID = @p_division_id
								   AND A.PLAN_CYCLE  = 'WEEKLY'
								   AND B.PLAN_TYPE   = 'FN'
								   
								 GROUP BY A.PLAN_NAME, A.PLAN_ID) P
							ON 1 = 1
						 WHERE C.BASIS_YYYYMMDD BETWEEN P.PLAN_START_YYYYMMDD AND   CONVERT(VARCHAR(8), DATEADD(day, 6, P.PLAN_START_YYYYMMDD), 112)
						   
						 GROUP BY P.PLAN_START_YYYYMMDD, P.PLAN_SEQ
					   ) X

				WHERE LEFT(X.END_YYYYMMDD, 6) = LEFT(@p_create_from_yyyymmdd, 6)	-- 당월 1일 부터 포함하기 위한 조건
				   AND X.PLAN_START_YYYYMMDD < @p_create_from_yyyymmdd	-- (당주 제외)
					   /*
				 WHERE LEFT(X.END_YYYYMMDD, 6) = LEFT(@p_plan_start_yyyymmdd, 6)	-- 당월 1일 부터 포함하기 위한 조건
				   AND X.PLAN_START_YYYYMMDD < @p_plan_start_yyyymmdd	-- (당주 제외)
				   */
				   ;

		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 041 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;  

				   ------------------------------------------------------------------------------------------------
					-----------------------------------------------------------------------------------------------DHJ
            -- 출하계획
			  UPDATE Y
			     SET Y.LAST_QTY = L.LAST_QTY
				FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK Y WITH (NOLOCK)
				INNER JOIN 
				     (
					  SELECT  X.ITEM_ID
							, X.FROM_SITE
							, X.TO_SITE
							, X.INCOTERMS
							, X.PROJECT_CODE
							, X.BOD_ID
							, SUM(S.QTY)		AS LAST_QTY
						FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK X WITH (NOLOCK)
						INNER JOIN SCP_ANL_SHIPMENT_PLAN_FG S WITH (NOLOCK)
							ON X.DIVISION_ID         = S.DIVISION_ID
						AND X.ITEM_ID             = S.ITEM_ID
						AND X.TO_SITE			  = S.TO_SITE
						AND X.FROM_SITE			  = S.FROM_SITE
						AND X.INCOTERMS			  = S.INCOTERMS
						AND X.PROJECT_CODE		  = S.PROJECT_CODE
						AND X.BOD_ID			  = S.BOD_ID
						INNER JOIN #tmp_PLAN_WEEK_FROM_TO P WITH (NOLOCK)
							ON S.PLAN_START_YYYYMMDD = P.PLAN_START_YYYYMMDD
						AND S.SEQ                 = P.PLAN_SEQ
						AND S.YYYYMMDD BETWEEN P.START_YYYYMMDD AND P.END_YYYYMMDD
						WHERE X.DIVISION_ID       = @p_division_id
						AND X.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
						AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd---------DHJ
						AND X.PLAN_TYPE           = @p_plan_type
						AND X.SEQ                 = @p_seq
						AND X.MEASURE   = 'PACK_SHIP_PLAN'
						AND S.PLAN_TYPE = 'FN'
						AND S.MEASURE   = 'SHIP_PLAN_AMEND'
						AND S.BIZ_TYPE  = 'P'
						GROUP BY X.ITEM_ID
							, X.FROM_SITE
							, X.TO_SITE
							, X.INCOTERMS
							, X.PROJECT_CODE
							, X.BOD_ID
				     ) L
				  ON Y.ITEM_ID      = L.ITEM_ID
				 AND Y.FROM_SITE    = L.FROM_SITE
				 AND Y.TO_SITE      = L.TO_SITE
				 AND Y.INCOTERMS    = L.INCOTERMS
				 AND Y.PROJECT_CODE = L.PROJECT_CODE
				 AND Y.BOD_ID       = L.BOD_ID
			   WHERE Y.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
				 AND Y.PLAN_TYPE           = @p_plan_type
				 AND Y.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd---------DHJ
				 AND Y.SEQ                 = @p_seq
				 AND Y.MEASURE             = 'PREV_PACK_SHIP_PLAN'
				 ;

		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 042 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;  

            -- 생산계획
			  UPDATE Y
			     SET Y.LAST_QTY = L.LAST_QTY
				FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK Y WITH (NOLOCK)
				INNER JOIN 
				    (
					 SELECT	  X.ITEM_ID
							, X.FROM_SITE
							, X.PROD_LINE
							, SUM(S.QTY)		AS LAST_QTY
					   FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK X WITH (NOLOCK)
					   INNER JOIN SCP_ANL_PRODUCTION_PLAN S WITH (NOLOCK)
						 ON X.DIVISION_ID         = S.DIVISION_ID
						AND X.ITEM_ID             = S.ITEM_ID
						AND X.FROM_SITE			  = S.SCM_SITE_ID
						AND X.PROD_LINE			  = S.LINE_ID
					   INNER JOIN #tmp_PLAN_WEEK_FROM_TO P WITH (NOLOCK)
						 ON S.PLAN_START_YYYYMMDD = P.PLAN_START_YYYYMMDD
						AND S.SEQ                 = P.PLAN_SEQ
						AND S.YYYYMMDD BETWEEN P.START_YYYYMMDD AND P.END_YYYYMMDD
					  WHERE X.DIVISION_ID         = @p_division_id
						AND X.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
						AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd---------DHJ
						AND X.PLAN_TYPE           = @p_plan_type
						AND X.SEQ                 = @p_seq
						AND X.MEASURE   = 'PACK_PROD'
						AND S.PLAN_TYPE = 'FN'
						AND S.MEASURE   = 'PROD_PLAN_AMEND'
					 GROUP BY X.ITEM_ID
							, X.FROM_SITE
							, X.PROD_LINE
				    ) L
				  ON Y.ITEM_ID      = L.ITEM_ID
				 AND Y.FROM_SITE    = L.FROM_SITE
				 AND Y.PROD_LINE    = L.PROD_LINE
			   WHERE Y.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
				 AND Y.PLAN_TYPE           = @p_plan_type
				 AND y.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd---------DHJ
				 AND Y.SEQ                 = @p_seq
				 AND Y.MEASURE             = 'PREV_PACK_PROD'
				 ;
				 print 'CREATE  PR_SCP_XLS_PSI_GLOBAL_SMALL_PACK_S END';
				 
		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 043 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								      ,@p_log_type      = N'TXN'        
								      ,@p_log_count     = 0       
								      ,@p_log_message   = @v_log_message       
								      ,@p_description   = @v_description       
								      ,@p_event_date    = @d_event_date       
								      ,@p_user_id       = @v_batch_user      
                                      ;  

            ------------------------------------------------------------------------------------------------------------- end

            -------------------------------------------------------------------------------------------------------------         
            -- 임시 TEMP  테이블 DROP  
            -------------------------------------------------------------------------------------------------------------
	            IF OBJECT_ID('tempdb..#LineLoad')   IS NOT NULL
	              DROP TABLE #LineLoad

              IF OBJECT_ID('tempdb..#LineLoad_WEEK')   IS NOT NULL
	              DROP TABLE #LineLoad_WEEK

              IF OBJECT_ID('tempdb..#MEASURE')    IS NOT NULL	
		            DROP TABLE #MEASURE

              IF OBJECT_ID('tempdb..#INTRANSIT')  IS NOT NULL       
		            DROP TABLE #INTRANSIT

              IF OBJECT_ID('tempdb..#SCP_PLN_PLANT_ONHAND')   IS NOT NULL       
		            DROP TABLE #SCP_PLN_PLANT_ONHAND

	            IF OBJECT_ID('tempdb..#BOH')        IS NOT NULL       
		            DROP TABLE #BOH

	            IF OBJECT_ID('tempdb..#PSI_GLOBAL_SMALL_PACK') IS NOT NULL       
		            DROP TABLE #PSI_GLOBAL_SMALL_PACK     

              IF OBJECT_ID('tempdb..#SCP_XLS_PSI_GLOBAL_SMALL_PACK') IS NOT NULL       
		            DROP TABLE #SCP_XLS_PSI_GLOBAL_SMALL_PACK

              IF OBJECT_ID('tempdb..#WEEK_COLUMN') IS NOT NULL       
		            DROP TABLE #WEEK_COLUMN
                

                

        -----------------------------------------------------------      
        -- 실행 Logic END --      
        -----------------------------------------------------------      
        --IF @@TRANCOUNT > 0      
        --  BEGIN      
        --    COMMIT TRAN T1;      
        --  END;             
      
      
        -- TXN LOG      
        SET @v_log_type     = N'TXN';        
        SET @n_log_count    = @@ROWCOUNT;      
        SET @v_log_message  = N'INSERT INTO '+@v_table_id;      
        SET @v_description  = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);      
        SET @d_event_date   = SYSDATETIME();      
      
        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
                                  ,@p_log_type      = @v_log_type      
                                  ,@p_log_count     = @n_log_count       
                                  ,@p_log_message   = @v_log_message       
                                  ,@p_description   = @v_description       
                                  ,@p_event_date    = @d_event_date       
                                  ,@p_user_id       = @v_batch_user      
                                  ;            
      
    END      
    END TRY      
      
    BEGIN CATCH      
      --IF @@TRANCOUNT > 0      
      --  BEGIN      
      --    ROLLBACK TRAN T1      
      --  END;      
            
      -- ERROR LOG      
      SET @v_log_type     = N'ERROR';      
      SET @v_log_message  = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));      
      SET @v_description  = @v_program_name + N'ERROR_LINE : ' + STR(ERROR_LINE());      
      SET @d_event_date   = SYSDATETIME();      
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
                                ,@p_log_type      = @v_log_type      
                                ,@p_log_count     = @n_log_count       
                                ,@p_log_message   = @v_log_message       
                                ,@p_description   = @v_description       
                                ,@p_event_date    = @d_event_date       
                                ,@p_user_id       = @v_batch_user      
                                ;      
--      PRINT @@ERROR      
      return -1      
    END CATCH;      
      
  
	if @p_is_debug = 1  
     SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
                          REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))     
       
    -- 종료 LOG          
    SET @v_log_type     = N'END';          
    SET @v_log_message  = N'########## END of procedure ##########';          
    SET @v_description  = N'['+@p_master_id+']['+@p_engine_plan_id+'][' + @v_exec_time + ']';                
    SET @d_event_date   = SYSDATETIME()  ;      
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

