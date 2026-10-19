                          
                          
                        
/*                    
 * Program ID   : PR_SCP_ANL_PSI_PRODUCTION_AMEND                      
 * Description  :                     
 * OutTable     :                    
 * Execute      : 
                  EXEC PR_SCP_ANL_PSI_PRODUCTION_AMEND
                     @p_plan_cycle          = 'WEEKLY'
                   , @p_plan_start_yyyymmdd = NULL
                   , @p_plan_id             = NULL
                   , @p_modeling_id         = '1'           -- 소형만 수행
                   , @p_seq                 = NULL
                   , @p_plan_type           = 'PR'          -- PR만 수행
                   , @p_master_id           = '40::WEEKLY'  -- 소형 / WEEKLY
                   , @p_division_id         = '40'          -- 소형
                   , @p_engine_plan_id      = NULL
                   , @p_user_id             = 'scp_batch'
                   , @p_engine_flag         = 'Y'           -- 별도 Job으로 수행(Amend 정보 반영) 
 
 SELECT * FROM SCM_SYS_LOG_BATCH    WITH (NOLOCK)  WHERE CREATED_BY ='KTH' order by CREATION_DATE desc   

 * Program History                    
 *===================================================================================================                    
 *   Date       In Charge      Description                    
 *===================================================================================================                    
 * 2019.06.03   KTH           Initial Release [CSR ID:4009384] GSCM - PSI 화면 개선 요청    
 * 2021.05.10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응
 */                    
                     
CREATE PROCEDURE [dbo].[PR_SCP_ANL_PSI_PRODUCTION_AMEND]
(       
      @p_plan_cycle           NVARCHAR(150)              
    , @p_plan_start_yyyymmdd  NVARCHAR(8)     -- plan_name           
    , @p_plan_id              NVARCHAR(4000)              
    , @p_modeling_id          NVARCHAR(4000)              
    , @p_seq                  NVARCHAR(4000)              
    , @p_plan_type            NVARCHAR(4000)              
    , @p_master_id            NVARCHAR(4000)              
    , @p_division_id          NVARCHAR(30)              
    , @p_engine_plan_id       NVARCHAR(4000)              
    , @p_user_id              NVARCHAR(150)  = 'scp_batch'
    , @p_engine_flag          NVARCHAR(10)   = 'N'   -- 'N' : Plan 수행 시 자동 수행(엔진 DATA 반영) / 'Y' : 별도 Job으로 수행(Amend 정보 반영) 
    ---- , @p_debug       INT OUTPUT     
)    
AS                    
  BEGIN                    
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;                    
    SET NOCOUNT ON;                    
    SET XACT_ABORT ON;                    
    SET ANSI_WARNINGS OFF;                    
                    
        
   -- LOG 용 변수 설정            
    DECLARE @v_batch_user   NVARCHAR(150) = N'scp_batch';      
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_ANL_PSI_PRODUCTION_AMEND';            
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...            
    DECLARE @n_log_count    INTEGER = 0;            
    DECLARE @v_log_message  NVARCHAR(1000);            
    DECLARE @v_description  NVARCHAR(500);          
    DECLARE @v_table_id     NVARCHAR(150) = N'SCM_SYS_LOG_BATC';         
    DECLARE @d_event_date   DATETIME;   
	             
    DECLARE @v_plan_cycle           NVARCHAR(150);
    DECLARE @v_plan_start_yyyymmdd  NVARCHAR(8);
    DECLARE @v_plan_id              NVARCHAR(4000);
    DECLARE @v_modeling_id          NVARCHAR(4000);
    DECLARE @v_seq                  NVARCHAR(4000);
    DECLARE @v_plan_type            NVARCHAR(4000);
    DECLARE @v_master_id            NVARCHAR(4000);
    DECLARE @v_division_id          NVARCHAR(30);
    DECLARE @v_engine_plan_id       NVARCHAR(4000);
    DECLARE @v_engine_flag          NVARCHAR(10);

  -- 시작 LOG            
    SET @v_log_type = N'START';            
    SET @v_log_message = N'########## Start of procedure ##########';            
  SET @v_description = @v_program_name + ':' + N' SCP_ANL_PSI_PRODUCTION INSERT LOGIC';            
    SET @d_event_date = SYSDATETIME();            
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name            
                              ,@p_log_type      =@v_log_type            
                              ,@p_log_count     =@n_log_count             
                              ,@p_log_message   =@v_log_message             
                              ,@p_description   =@v_description             
                              ,@p_event_date    =@d_event_date             
                              ,@p_user_id       =@v_batch_user            
                              ;            
    -- 임시 실행시간 확인용                
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();                
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'00:00';        
	
    -----------------------------------------------------------
    -- 실행용 변수 설정 : Start
    -----------------------------------------------------------
				   	
    -- 0. 소형 / PR 만 수행하므로 고정값 적용 : NULL 이면 별도 Job 수행으로 처리
	SET @v_plan_cycle  = ISNULL(@p_plan_cycle, 'WEEKLY');				  
	SET @v_plan_start_yyyymmdd = ISNULL(@p_plan_start_yyyymmdd, '-'); 	
	SET @v_plan_id     = ISNULL(@p_plan_id, '-');				   	
	SET @v_modeling_id = ISNULL(@p_modeling_id, '1');			
	SET @v_seq         = ISNULL(@p_seq, '0');			   			   						   	
	SET @v_plan_type   = ISNULL(@p_plan_type, 'PR');	   	
	SET @v_master_id   = ISNULL(@p_master_id, '40::WEEKLY');				   	
	SET @v_division_id = ISNULL(@p_division_id, '40');					   	
	SET @v_engine_plan_id = ISNULL(@p_engine_plan_id, '-');		
	SET @v_engine_flag = ISNULL(@p_engine_flag, 'Y');	

	IF @v_engine_flag = 'Y'
	BEGIN
		-- 1. @v_plan_start_yyyymmdd
		SELECT /* PR_SCP_ANL_PSI_PRODUCTION_AMEND */
			   @v_plan_start_yyyymmdd   =
					CASE WHEN m.plan_cycle = 'WEEKLY' 
						 THEN
						   CONVERT(char(8), DATEADD(dd, -7, dbo.fn_next_day(GETDATE(), 'MON')), 112) -- weekly (당주 월요일)
						 ELSE
						   CONVERT(char(8), DATEADD(dd, -1, GETDATE()), 112) -- daily (전일자)
					END
		FROM  scm_mst_modeling m with(nolock)
		WHERE modeling_id = @v_modeling_id ; 

		-- 2. Plan ID
		SELECT /* PR_SCP_ANL_PSI_PRODUCTION_AMEND */
			   @v_plan_id = p.plan_id -- v_plan_id
		FROM   scm_mst_plan p with(nolock)
		WHERE  p.division_id = @v_division_id
		AND    p.plan_cycle  = @v_plan_cycle
		AND    p.plan_name   = @v_plan_start_yyyymmdd;

		-- 3.1 Plan seq : confirm 우선, 없으면 MAX
		SELECT /* PR_SCP_ANL_PSI_PRODUCTION_AMEND */
			   @v_seq = ISNULL(MAX(p.plan_seq),0)
		FROM   scm_mst_plan_detail p with(nolock)
		WHERE  p.modeling_id  = @v_modeling_id
		AND    p.division_id  = @v_division_id
		AND    p.plan_id      = @v_plan_id
		AND    p.plan_type    = @v_plan_type  
		AND    p.confirm_flag = 'Y'; 

		-- 3.2 Plan seq : MAX
		IF @v_seq = '0'
		BEGIN
		  SELECT /* PR_SCP_ANL_PSI_PRODUCTION_AMEND */
				 @v_seq = ISNULL(MAX(p.plan_seq),0)
		  FROM   scm_mst_plan_detail p with(nolock)
		  WHERE  p.modeling_id  = @v_modeling_id
		  AND    p.division_id  = @v_division_id
		  AND    p.plan_id      = @v_plan_id
		  AND    p.plan_type    = @v_plan_type  ;
		END
    
		-- 4. Engine Plan ID
		SET @v_engine_plan_id = @v_plan_id + '::' + @v_plan_type + '::' + @v_seq	
	END
	
    -----------------------------------------------------------
    -- 실행용 변수 설정 : End
    -----------------------------------------------------------       
             
    -- PLAN_TYPE이 PR인 정보가 존재하는 경우만 실행
    if @v_plan_type <> 'PR' OR @v_seq = '0'
      return -1   

    BEGIN TRY                    
      BEGIN                    
--        BEGIN TRAN TX_PSI1                    
          -------------------------------------------------------------------------------------------------------------                     
          -- 0. temp 테이블 생성 : AMEND 입력 임시 테이블
          -------------------------------------------------------------------------------------------------------------                     
          IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_PRODUCTION_AMEND') IS NOT NULL                    
            DROP TABLE #tmp_SCP_ANL_PSI_PRODUCTION_AMEND


            CREATE TABLE #tmp_SCP_ANL_PSI_PRODUCTION_AMEND(
	                        DIVISION_ID             NVARCHAR(30)    NULL,
	                        PLAN_START_YYYYMMDD     NVARCHAR(8)     NULL,
	                        PLAN_TYPE               NVARCHAR(50)    NULL,
	                        SEQ                     INT             NULL,   -- BIGINT        
	                        OPERATION_GROUP         NVARCHAR(10)    NULL,
	                        FROM_SITE               NVARCHAR(30)    NULL,
	                        ITEM_ID                 NVARCHAR(50)    NULL,
	                        PSI_TYPE                NVARCHAR(10)    NULL,
	                        PSI_VALUE               NVARCHAR(50)    NULL,
	                        YYYYMMDD                NVARCHAR(8)     NULL,
	                        QTY                     NUMERIC(20, 10) NULL,
	                        TO_SITE                 NVARCHAR(30)    NULL,
	                        PROD_LINE               NVARCHAR(50)    NULL,
	                        INVENTORY_TYPE          NVARCHAR(1)     NULL,
	                        ORIGIN_FROM_DIVISION_ID NVARCHAR(30)    NULL,
	                        ORIGIN_TO_DIVISION_ID   NVARCHAR(30)    NULL,
	                        ELECTRODE_TYPE          NVARCHAR(30)    NULL,
	                        CREATED_BY              NVARCHAR(150)   NULL,
	                        CREATION_DATE           DATETIME        NULL,
	                        LAST_UPDATED_BY         NVARCHAR(150)   NULL,
	                        LAST_UPDATE_DATE        DATETIME        NULL,
	                        ATTRIBUTE1              NVARCHAR(150)   NULL,
	                        ATTRIBUTE2              NVARCHAR(150)   NULL,
	                        ATTRIBUTE3              NVARCHAR(150)   NULL,
	                        ATTRIBUTE4              NVARCHAR(150)   NULL,
	                        ATTRIBUTE5              NVARCHAR(150)   NULL,
	                        ATTRIBUTE6              NVARCHAR(150)   NULL,
	                        ATTRIBUTE7              NVARCHAR(150)   NULL,
	                        ATTRIBUTE8              NVARCHAR(150)   NULL,
	                        ATTRIBUTE9              NVARCHAR(150)   NULL,
	                        ATTRIBUTE10             NVARCHAR(150)   NULL,
                        )             
           
           --SELECT * INTO #tmp_SCP_ANL_PSI_PRODUCTION_AMEND
           --FROM SCP_ANL_PSI_PRODUCTION
           --WHERE 0 = 1

		    -- * 2021.05.10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - start
			DECLARE @v_pet_date		NVARCHAR(12) = '';

			--  Plan End Date
			SELECT @v_pet_date = p.horizon_end_date
			FROM   dbo.scm_mst_plan p WITH(NOLOCK)
			WHERE  p.division_id = @v_division_id
			AND    p.plan_id     = @v_plan_id ;

			SET @v_pet_date = CONVERT(VARCHAR(8), DATEADD(DAY, 1, CONVERT(DATETIME, @v_pet_date, 112)), 112);
			-- * 2021-05-10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - end


            -------------------------------------------------------------------------------------------------------------                     
            -- PR 일경우
            -------------------------------------------------------------------------------------------------------------   
            -------------------------------------------------------------------------------------------------------------                     
            --  SHIPMENT AMEND, SHIPMENT AMEND 입력 - SPI_TYPE ='SA','PA'
            -------------------------------------------------------------------------------------------------------------       
              
            IF @v_plan_type = 'PR'  AND @v_engine_flag = 'N' 
            BEGIN     
              INSERT INTO #tmp_SCP_ANL_PSI_PRODUCTION_AMEND                    
              SELECT   
                     X.DIVISION_ID
                    ,X.PLAN_START_YYYYMMDD
                    ,X.PLAN_TYPE
                    ,X.SEQ
                    ,X.OPERATION_GROUP
                    ,X.FROM_SITE
                    ,X.ITEM_ID
                    ,(CASE  WHEN X.PSI_TYPE ='S' THEN 'SA'
                            WHEN X.PSI_TYPE ='P' THEN 'PA'
                      END )  AS PSI_TYPE
                    ,X.PSI_VALUE
                    ,X.YYYYMMDD
                    ,X.QTY
                    ,X.TO_SITE
                    ,X.PROD_LINE
                    ,X.INVENTORY_TYPE
                    ,X.ORIGIN_FROM_DIVISION_ID
                    ,X.ORIGIN_TO_DIVISION_ID
                    ,X.ELECTRODE_TYPE
                    ,@v_batch_user   AS CREATED_BY
                    ,GETDATE()       AS CREATION_DATE
                    ,@v_batch_user   AS LAST_UPDATED_BY
                    ,GETDATE()       AS LAST_UPDATE_DATE
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
                 FROM SCP_ANL_PSI_PRODUCTION X    WITH (NOLOCK)                
                WHERE 1 = 1                    
                  AND X.DIVISION_ID         = @v_division_id                    
                  AND X.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd                    
                  AND X.PLAN_TYPE           = @v_plan_type                    
                  AND X.SEQ                 = @v_seq                    
                  AND X.PSI_TYPE            IN ('P','S')
            END


            -------------------------------------------------------------------------------------------------------------                     
            -- SHIPMENT PLAN(FG)                  
            ------------------------------------------------------------------------------------------------------------- 
           IF @v_plan_type = 'PR'  AND @v_engine_flag = 'Y' 
            BEGIN                     
              INSERT INTO #tmp_SCP_ANL_PSI_PRODUCTION_AMEND                  
               SELECT X.DIVISION_ID
                    ,X.PLAN_START_YYYYMMDD
                    ,X.PLAN_TYPE
                    ,X.SEQ
                    ,X.BIZ_TYPE AS OPERATION_GROUP
                    ,X.FROM_SITE
                    ,X.ITEM_ID
                    ,'SA'  AS PSI_TYPE
                    ,X.TO_SITE AS PSI_VALUE
                    ,X.YYYYMMDD
                    ,X.QTY
                    ,X.TO_SITE
                    ,NULL AS PROD_LINE
                    ,NULL AS INVENTORY_TYPE
                    ,X.ORIGIN_FROM_DIVISION_ID
                    ,X.ORIGIN_TO_DIVISION_ID
                    ,X.ELECTRODE_TYPE
                    ,@v_batch_user   AS CREATED_BY
                    ,GETDATE()       AS CREATION_DATE
                    ,@v_batch_user   AS LAST_UPDATED_BY
                    ,GETDATE()       AS LAST_UPDATE_DATE
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
                    --,NULL AS CELL_QTY     -- 체크
                FROM SCP_ANL_SHIPMENT_PLAN_FG X WITH(NOLOCK)				
                WHERE 1=1													
                AND X.DIVISION_ID	      = @v_division_id		
                AND X.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd	
                AND X.PLAN_TYPE           = @v_plan_type				
                AND X.SEQ			      = @v_seq					
                AND X.MEASURE             ='SHIP_PLAN_AMEND'	
            END
            
            -------------------------------------------------------------------------------------------------------------                     
            -- SHIPMENT PLAN(SEMI)                  
            ------------------------------------------------------------------------------------------------------------- 
           IF @v_plan_type = 'PR'  AND @v_engine_flag = 'Y' 
            BEGIN                     
              INSERT INTO #tmp_SCP_ANL_PSI_PRODUCTION_AMEND                  
               SELECT X.DIVISION_ID
                    ,X.PLAN_START_YYYYMMDD
                    ,X.PLAN_TYPE
                    ,X.SEQ
                    ,X.OPERATION_GROUP
                    ,X.FROM_SITE
                    ,X.ITEM_ID
                    ,'SA'  AS PSI_TYPE
                    ,X.TO_SITE AS PSI_VALUE
                    ,X.YYYYMMDD
                    ,X.QTY
                    ,X.TO_SITE
                    ,NULL AS PROD_LINE
                    ,NULL AS INVENTORY_TYPE
                    ,X.ORIGIN_FROM_DIVISION_ID
                    ,X.ORIGIN_TO_DIVISION_ID
                    ,X.ELECTRODE_TYPE
                    ,@v_batch_user   AS CREATED_BY
                    ,GETDATE()       AS CREATION_DATE
                    ,@v_batch_user   AS LAST_UPDATED_BY
                    ,GETDATE()       AS LAST_UPDATE_DATE
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
                    --,NULL AS CELL_QTY     -- 체크
                FROM SCP_ANL_SHIPMENT_PLAN_SEMI X WITH(NOLOCK)				
                WHERE 1=1													
                AND X.DIVISION_ID	        = @v_division_id		
                AND X.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd	
                AND X.PLAN_TYPE           = @v_plan_type				
                AND X.SEQ			            = @v_seq					
                AND X.MEASURE             ='SHIP_PLAN_AMEND'	
            END
              
            -------------------------------------------------------------------------------------------------------------                
            -- PRODUCTION AMEND  입력 - SPI_TYPE ='PA'  , MEASURE='PROD_PLAN_AMEND'	                  
            -------------------------------------------------------------------------------------------------------------                     
            IF @v_plan_type = 'PR'  AND @v_engine_flag = 'Y' 
            BEGIN                     
              INSERT INTO #tmp_SCP_ANL_PSI_PRODUCTION_AMEND                  
               SELECT X.DIVISION_ID
                    ,X.PLAN_START_YYYYMMDD
                    ,X.PLAN_TYPE
                    ,X.SEQ
                    ,X.OPERATION_GROUP
                    ,X.SCM_SITE_ID
                    ,X.ITEM_ID
                    ,'PA'  AS PSI_TYPE
                    ,X.LINE_ID
                    --,X.MEASURE
                    ,X.YYYYMMDD
                    ,X.QTY
	                  ,'' AS  TO_SITE
	                  ,'' AS  PROD_LINE
	                  ,'' AS  INVENTORY_TYPE
                    ,X.ORIGIN_DIVISION_ID
	                  ,'' AS  ORIGIN_TO_DIVISION_ID 
                    ,X.ELECTRODE_TYPE
                    ,X.CREATED_BY
                    ,X.CREATION_DATE
                    ,X.LAST_UPDATED_BY
                    ,X.LAST_UPDATE_DATE
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
                    --,X.CELL_QTY
                FROM SCP_ANL_PRODUCTION_PLAN X WITH(NOLOCK)				
                WHERE 1=1													
                AND X.DIVISION_ID	      = @v_division_id		
                AND X.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd	
                AND X.PLAN_TYPE           = @v_plan_type				
                AND X.SEQ				  = @v_seq					
                AND X.MEASURE             ='PROD_PLAN_AMEND'	
       END

           /*
          -------------------------------------------------------------------------------------------------------------                     
          -- P.S.I 소계 반영
          --          P ISSUM (PA 전체 합)
          --          S ISSUM (SA 전체 합)
          --------------------------------------------------------------------------------------------------------------  
            INSERT INTO #tmp_SCP_ANL_PSI_PRODUCTION_AMEND                    
              (                    
                 DIVISION_ID                              
                ,PLAN_START_YYYYMMDD                      
                ,PLAN_TYPE                               
                ,SEQ                                      
                ,OPERATION_GROUP                          
                ,FROM_SITE                                
                ,ITEM_ID                                  
                ,PSI_TYPE                                 
                ,PSI_VALUE               
              --,TO_SITE                                  
              --,PROD_LINE                                
                ,YYYYMMDD                                 
                ,QTY                                      
              --,INVENTORY_TYPE        
              --,ORIGIN_FROM_DIVISION_ID             
              --,ORIGIN_TO_DIVISION_ID           
              --,ELECTRODE_TYPE       
              --,TO_SITE_ORG        
                )    
            SELECT DIVISION_ID
                  ,PLAN_START_YYYYMMDD
                  ,PLAN_TYPE
                  ,SEQ        
                  ,OPERATION_GROUP
                  ,FROM_SITE
                  ,ITEM_ID
                  ,PSI_TYPE
                  ,'ISSUM' AS PSI_VALUE
                  ,YYYYMMDD
                  ,QTY
            FROM
            (
              SELECT   DIVISION_ID
                      ,PLAN_START_YYYYMMDD
                      ,PLAN_TYPE
                      ,SEQ        
                      ,OPERATION_GROUP
                      ,FROM_SITE
                      ,ITEM_ID
                      ,YYYYMMDD
                      ,SUM((CASE WHEN PSI_TYPE ='SA'                                                          THEN ISNULL(QTY,0) ELSE 0 END))   AS SA
                      ,SUM((CASE WHEN PSI_TYPE ='PA'                                                          THEN ISNULL(QTY,0) ELSE 0 END))   AS PA
                      --,SUM((CASE WHEN PSI_TYPE ='I'AND  PSI_VALUE IN ('ACTIVATE_PROGRESS','MODEL_INVENTORY') THEN ISNULL(QTY,0) ELSE 0 END))   AS I
                FROM #tmp_SCP_ANL_PSI_PRODUCTION_AMEND  WITH (NOLOCK)
                GROUP BY DIVISION_ID
                        ,PLAN_START_YYYYMMDD
                        ,PLAN_TYPE
                        ,SEQ        
                        ,OPERATION_GROUP
                        ,FROM_SITE
                        ,ITEM_ID
                        ,YYYYMMDD
            ) X
            UNPIVOT
            ( 
              QTY FOR PSI_TYPE IN (SA, PA)
              )
            AS UNPVT
          */

          -------------------------------------------------------------------------------------------------------------                     
          -- SCP_ANL_PSI_PRODUCTION ('SA','PA') 삭제                     
          --------------------------------------------------------------------------------------------------------------                      
          WHILE @@ROWCOUNT > 0  -- 
            BEGIN
              DELETE TOP (1000)
              FROM SCP_ANL_PSI_PRODUCTION                            
              WHERE DIVISION_ID         = @v_division_id 
                AND PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd 
                AND PLAN_TYPE           = @v_plan_type 
                AND SEQ                 = @v_seq        
                AND PSI_TYPE            IN ('SA','PA')
            END           
                  
          -------------------------------------------------------------------------------------------------------------                     
          -- SCP_ANL_PSI_PRODUCTION 입력                     
          --------------------------------------------------------------------------------------------------------------                    
          INSERT INTO /* PR_SCP_ANL_PSI_PRODUCTION_AMEND */ dbo.SCP_ANL_PSI_PRODUCTION       WITH (TABLOCK)                    
                (                    
                   DIVISION_ID                              
                  ,PLAN_START_YYYYMMDD                      
                  ,PLAN_TYPE                                
                  ,SEQ                                      
                  ,OPERATION_GROUP                          
                  ,FROM_SITE                                
                  ,ITEM_ID                                  
                  ,PSI_TYPE                                 
                  ,PSI_VALUE                                
                  ,TO_SITE                                  
                  ,PROD_LINE                                
                  ,YYYYMMDD                                                 
                  ,QTY                                      
                  ,INVENTORY_TYPE                 
                  ,ORIGIN_FROM_DIVISION_ID        
                  ,ORIGIN_TO_DIVISION_ID        
                  ,ELECTRODE_TYPE                  
                  ,CREATED_BY                               
                  ,CREATION_DATE                            
                  ,LAST_UPDATED_BY                          
                  ,LAST_UPDATE_DATE                     
                  ,ATTRIBUTE7    
                  ,ATTRIBUTE9
                  ,ATTRIBUTE10    
                )                    
              
              SELECT                  
                    X.DIVISION_ID                              
                   ,X.PLAN_START_YYYYMMDD                      
                   ,X.PLAN_TYPE                                
                   ,X.SEQ                                      
                   ,X.OPERATION_GROUP                          
                   ,X.FROM_SITE                    
                   ,X.ITEM_ID                                  
                   ,X.PSI_TYPE                                 
                   ,ISNULL(X.PSI_VALUE,'X') AS PSI_VALUE
                   ,X.TO_SITE                            
                   ,X.PROD_LINE                                
                   ,X.YYYYMMDD                                 
                   ,SUM(X.QTY) AS QTY
                   ,X.INVENTORY_TYPE                    
                   ,X.ORIGIN_FROM_DIVISION_ID        
                   ,ISNULL(X.ORIGIN_TO_DIVISION_ID,'') AS     ORIGIN_TO_DIVISION_ID    
                   ,Y.ELECTRODE_TYPE                 
                   ,@v_batch_user AS CREATED_BY          
                   ,GETDATE()     AS CREATION_DATE                    
                   ,@v_batch_user AS LAST_UPDATED_BY                    
                   ,GETDATE()     AS LAST_UPDATED_BY    
                   ,X.ATTRIBUTE7
                   ,X.ATTRIBUTE9
                   ,X.ATTRIBUTE10                
              FROM #tmp_SCP_ANL_PSI_PRODUCTION_AMEND X WITH (NOLOCK)                    
              INNER JOIN SCP_MST_FINAL_ITEM_V Y  WITH (NOLOCK)                    
                      ON 0 = 0    
                     AND X.ITEM_ID      = Y.ITEM_ID                                  
             WHERE 1 = 1 			 
			 -- * 2021.05.10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - start
             --AND X.YYYYMMDD < CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,@v_plan_start_yyyymmdd,112)),112)   
			 --
			 AND X.YYYYMMDD < @v_pet_date 
			 -- * 2021.05.10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - end

             GROUP BY
                    X.DIVISION_ID            
                   ,X.PLAN_START_YYYYMMDD                      
                   ,X.PLAN_TYPE                                
                   ,X.SEQ                                      
                   ,X.OPERATION_GROUP                          
                   ,X.FROM_SITE                    
                   ,X.ITEM_ID                                  
                   ,X.PSI_TYPE                                 
                   ,X.PSI_VALUE                                
                   ,X.TO_SITE                    
                   ,X.PROD_LINE                                
                   ,X.YYYYMMDD                                 
                   ,X.INVENTORY_TYPE                    
                   ,X.ORIGIN_FROM_DIVISION_ID        
                   ,ISNULL(X.ORIGIN_TO_DIVISION_ID,'') 
                   ,Y.ELECTRODE_TYPE        
                   ,X.ATTRIBUTE7
                   ,ATTRIBUTE9
                   ,X.ATTRIBUTE10
             ;      
            
          -------------------------------------------------------------------------------------------------------------
          -- TEMPDB TABLE DROP
          -------------------------------------------------------------------------------------------------------------                         
                   
          IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_PRODUCTION_AMEND') IS NOT NULL                    
              DROP TABLE #tmp_SCP_ANL_PSI_PRODUCTION_AMEND  

       
        -----------------------------------------------------------                    
        -- 실행 Logic END --                    
        -----------------------------------------------------------                    
        --IF @@TRANCOUNT > 0                    
        --  BEGIN                    
        --    COMMIT TRAN TX_PSI1;                    
        --  END;          
                    
                    
        -- TXN LOG                    
        SET @v_log_type = N'TXN';                
        SET @n_log_count = @@ROWCOUNT;                    
        SET @v_log_message = N'INSERT INTO '+@v_table_id;         
        SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);     
        SET @d_event_date = SYSDATETIME();                    
                    
        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                    
                                  ,@p_log_type      =@v_log_type                    
                                  ,@p_log_count     =@n_log_count                     
                                  ,@p_log_message   =@v_log_message                     
                                  ,@p_description   =@v_description                     
                                  ,@p_event_date    =@d_event_date                     
                                  ,@p_user_id       =@v_batch_user                    
                                  ;                          
                    
    END                    
    END TRY                    
                    
    BEGIN CATCH                    
      --IF @@TRANCOUNT > 0             
      --  BEGIN            ROLLBACK TRAN TX_PSI1                    
      --  END;                    
                          
      -- ERROR LOG          
      SET @v_log_type = N'ERROR';                    
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));                    
      SET @v_description = @v_program_name + N'ERROR_LINE : ' + STR(ERROR_LINE());                    
      SET @d_event_date = SYSDATETIME();                    
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                    
                                ,@p_log_type      =@v_log_type                    
                                ,@p_log_count     =@n_log_count                     
                                ,@p_log_message   =@v_log_message                     
                                ,@p_description   =@v_description                     
                                ,@p_event_date    =@d_event_date                     
                                ,@p_user_id       =@v_batch_user    
                                ;                    
--      PRINT @@ERROR                    
      return -1                    
    END CATCH;                    
                    
--     임시 운영반영시에 주석처리 할것.                
     SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +                 
                          REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))                 
                
    -- 종료 LOG                    
    SET @v_log_type = N'END';                    
    SET @v_log_message = N'########## END of procedure ##########';                    
    SET @v_description = N'['+@v_master_id+']['+@v_engine_plan_id+'][' + @v_exec_time + ']';                  
    SET @d_event_date = SYSDATETIME()  ;                    
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                    
                              ,@p_log_type      =@v_log_type                    
                              ,@p_log_count     =@n_log_count                     
                              ,@p_log_message   =@v_log_message                     
                              ,@p_description   =@v_description                     
                              ,@p_event_date    =@d_event_date                     
                              ,@p_user_id       =@v_batch_user                    
                              ;                    
                     
    return 1                      
                    
  END;             

