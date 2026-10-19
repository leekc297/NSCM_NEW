
        

/*                  
 * Program ID   : PR_SCP_XLS_CREATE_DATA                  
 * Description  : EXCEL 데이터 반영 SP 호출                  
 * Execute      : EXEC PR_SCP_XLS_CREATE_DATA    @p_master_id1      = '81::WEEKLY'             
                                                ,@p_engine_plan_id1 = '1061::PR::1' 
                                                ,@p_user_id         = 'xls_batch'      
 * Program History                  
 *===================================================================================================                  
 *   Date       In Charge      Description                  
 *===================================================================================================                  
 * 2019.01.14   KTH         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트                  
 * 2019.02.25   KTH         소형 PACK 시물레이션 SP 추가
 * 2019.03.13   KTH         소형 CELL 시물레이션 SP 추가
 * 2019.05.28   KTH         PLAN_TYPE이 'PR','MA','SE','FN'일 경우만 실행   
 * 2019.06.27   KTH         [PJ20189106] 전지.GSCM 고도화 이행 ESS(82) 시물레이션 SP 추가
 * 2019.08.13   KTH         PR_SCP_XLS_BOH 전극('EE') 추가
 * 2019.09.23   KTH         전극(EE) 시뮬레이션 EXCEL DATA 생성 추가
 * 2020.01.15   KTH         PR_SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM 추가
 * 2022.03.21   KSW			GM JV 반영
 * 2023.03.17   HRK			[PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 
 *							- PR_SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM : PR plan시 생성된 데이터로 FN까지 반영 (PR만 수행)  
 * 2023.05.08	KSK			[PJ20230691] SCM 역량 강화 위한 SCP 개선과제 이행 (ESHM JV 사업부 지원)
* 2025.02.21	KSK		   소형 (40) 출하 시뮬레이터 EXCEL DATA 생성 추가
* 2026.03.17   YMH        E20260310-000934 시뮬레이션 용 Plan Type(Test Version) 추가 요청
 */                 
 
CREATE PROCEDURE [dbo].[PR_SCP_XLS_CREATE_DATA]
    (                   
       @p_master_id1      NVARCHAR(4000)  
      ,@p_engine_plan_id1 NVARCHAR(4000)  
      ,@p_user_id         NVARCHAR(150)    = 'xls_batch'                    
    ---- , @p_debug      INT OUTPUT                  
    )                   
 AS                  
  BEGIN                  
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;                  
    SET NOCOUNT ON;                  
    SET XACT_ABORT ON;                  
    SET ANSI_WARNINGS OFF;                  
                  
                      
    DECLARE @p_master_id      NVARCHAR(4000) = @p_master_id1 ;                                                                     
    DECLARE @p_engine_plan_id NVARCHAR(4000) = @p_engine_plan_id1 ;                                                                
    DECLARE @p_division_id    NVARCHAR(30)   = SUBSTRING(@p_master_id, 1,       CHARINDEX('::', @p_master_id)-1) ;                     
    DECLARE @p_plan_cycle     NVARCHAR(150)  = SUBSTRING(@p_master_id,          CHARINDEX('::', @p_master_id)+2,100) ;                    
    DECLARE @p_plan_id        NVARCHAR(4000) = SUBSTRING(@p_engine_plan_id, 1,  CHARINDEX('::', @p_engine_plan_id)-1) ;                    
    DECLARE @p_plan_type      NVARCHAR(4000) = SUBSTRING(@p_engine_plan_id,     CHARINDEX('::', @p_engine_plan_id)+2, 2) ;         
    DECLARE @p_seq            NVARCHAR(4000) = SUBSTRING(@p_engine_plan_id, DBO.FN_CHARINDEX_REV(@p_engine_plan_id, '::', 0)+2,100) ;                    
    DECLARE @p_modeling_id    NVARCHAR(4000) ;                    
                  
    DECLARE @p_plan_name      NVARCHAR(4000) ;                    
                  
                  
    -- LOG 용 변수 설정                  
    DECLARE @v_batch_user             NVARCHAR(150) = N'scp_batch';                    
    SET @v_batch_user                              = @p_user_id                  
    DECLARE @v_program_name           NVARCHAR(150) = 'PR_SCP_XLS_CREATE_DATA';                  
    DECLARE @v_log_type               NVARCHAR(30); -- START/END/ERROR/...                  
    DECLARE @n_log_count              INTEGER = 0;                  
    DECLARE @v_log_message            NVARCHAR(1000);                  
    DECLARE @v_description    NVARCHAR(500);                  
    DECLARE @v_table_id               NVARCHAR(150) = 'SCP_XLS_ALL';                  
    DECLARE @d_event_date             DATETIME;                  
    DECLARE @p_plan_start_yyyymmdd    NVARCHAR(30);                  
                  
    DECLARE @d_plan_name              DATETIME;                  
    
    DECLARE @rows INT;  
    DECLARE @v_plan_status INT;               
              
    -- PLAN_TYPE이 'PR','MA','SE','FN'일 경우만 실행   
    -- E20260310-000934 2026.03.17  시뮬레이션 용 Plan Type(Test Version) 추가 요청 'TE' 추가.
    if @p_plan_type NOT IN ('PR','MA','SE','FN','TE')            
      return -1              
            
    ---------------------------------------------------------                    
    -- 실행용 변수 설정
    -----------------------------------------------------------                    
    -- 1. Modelin ID                    
    SELECT /* PR_SCP_XLS_CREATE_DATA */                    
           @p_modeling_id = m.modeling_id                    
    FROM  scm_mst_modeling m with(nolock)                    
    WHERE division_id = @p_division_id                    
    AND   enterprise  = @p_master_id                    
    ANd   plan_cycle  = @p_plan_cycle ;                     
                    
    -- 2. Plan Name                    
    SELECT /* PR_SCP_XLS_CREATE_DATA */                    
           @p_plan_name = m.plan_name                    
    FROM  scm_mst_plan m with(nolock)                    
    WHERE division_id = @p_division_id               
    AND   plan_id     = @p_plan_id                    
    ANd   plan_cycle  = @p_plan_cycle ;                     
                  
    SET @p_plan_start_yyyymmdd =     @p_plan_name;                  
                  
  -- 시작 LOG                  
    SET @v_log_type    = 'START';                  
    SET @v_log_message = '#SCP_XLS_CREATE_DATA#### Start of procedure #';                  
    SET @v_description = @v_program_name + ':' + @p_plan_start_yyyymmdd;                  
    SET @d_event_date  = SYSDATETIME() ;  -- LOG 확인시 순차적으로 보기 위해서                   
                  
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
                              ,@p_log_type      =@v_log_type                  
                              ,@p_log_count     =@n_log_count                   
                              ,@p_log_message   =@v_log_message                   
                              ,@p_description   =@v_description                   
                              ,@p_event_date    =@d_event_date                   
                              ,@p_user_id       =@v_batch_user                  
                              ;                  
                  
    SET @rows = 0;                  
                  
    -- 임시 실행시간 확인용              
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();              
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';              
            
              
    BEGIN TRY                  
      BEGIN            
       -- BEGIN TRAN T1                  
              
        SELECT  @v_plan_status = dbo.FN_GET_PLAN_STATUS(@p_division_id,@p_plan_start_yyyymmdd,@p_plan_type,@p_seq)              
        PRINT '@v_plan_status[START][' +  convert(nvarchar, @v_plan_status)  +']'              
        IF @v_plan_status = -2 GOTO _RETURN_ERR_CODE               

        --IF @p_division_id <> 'EE'    
        --BEGIN 
          -----------------------------------------------------------------------------------------------------------------------                
          -- PR_SCP_XLS_BOH(BOH)
          -----------------------------------------------------------------------------------------------------------------------                
          EXEC @ROWS = PR_SCP_XLS_BOH                             @p_plan_cycle             = @p_plan_cycle          
                                                                , @p_plan_start_yyyymmdd    = @p_plan_start_yyyymmdd          
                                                                , @p_plan_id                = @p_plan_id          
                                                                , @p_modeling_id            = @p_modeling_id          
      , @p_seq                    = @p_seq          
                                                                , @p_plan_type              = @p_plan_type          
                                                                , @p_master_id              = @p_master_id          
                                                                , @p_division_id            = @p_division_id          
                                                                , @p_engine_plan_id         = @p_engine_plan_id            
                                                                , @p_user_id                = @v_batch_user    
          -----------------------------------------------------------------------------------------------------------------------              
          SELECT  @v_plan_status = dbo.FN_GET_PLAN_STATUS(@p_division_id,@p_plan_start_yyyymmdd,@p_plan_type,@p_seq)              
          PRINT '@v_plan_status[PR_SCP_XLS_BOH][' +  convert(nvarchar, @v_plan_status)  +']'              
              
          --SELECT 'PR_SCP_XLS_BOH', @rows;                  
          IF (@rows < 0 OR @v_plan_status = -2)  GOTO _RETURN_ERR_CODE                  
          --PRINT @rows                  
        --END

        IF dbo.FN_IS_DIVISION( @p_division_id, 'CREATE', '81') = 1    --  81_UC, 81_HM등의 JV 지원
        BEGIN 
          -----------------------------------------------------------------------------------------------------------------------                
          -- 지동차 (81) 시뮬레이션 EXCEL DATA 생성
          -----------------------------------------------------------------------------------------------------------------------                
          EXEC @ROWS = PR_SCP_XLS_PSI_GLOBAL                      @p_plan_cycle             = @p_plan_cycle          
                                                                , @p_plan_start_yyyymmdd    = @p_plan_start_yyyymmdd          
                                                                , @p_plan_id                = @p_plan_id          
                                                                , @p_modeling_id            = @p_modeling_id          
                                                                , @p_seq                    = @p_seq          
                                                                , @p_plan_type              = @p_plan_type          
                                                                , @p_master_id              = @p_master_id          
                                                                , @p_division_id            = @p_division_id          
                                                                , @p_engine_plan_id         = @p_engine_plan_id            
                                                                , @p_user_id                = @v_batch_user    
          -----------------------------------------------------------------------------------------------------------------------              
          SELECT  @v_plan_status = dbo.FN_GET_PLAN_STATUS(@p_division_id,@p_plan_start_yyyymmdd,@p_plan_type,@p_seq)              
          PRINT '@v_plan_status[PR_SCP_XLS_PSI_GLOBAL][' +  convert(nvarchar, @v_plan_status)  +']'              
              
          --SELECT 'PR_SCP_XLS_PSI_GLOBAL', @rows;                  
          IF (@rows < 0 OR @v_plan_status = -2)  GOTO _RETURN_ERR_CODE                  
          --PRINT @rows 
        END      


        IF @p_division_id = '40'    
        BEGIN 

          -----------------------------------------------------------------------------------------------------------------------                
          -- PR_SCP_XLS_BOH_SMALL_CELL(BOH)
          -----------------------------------------------------------------------------------------------------------------------                
          EXEC @ROWS = PR_SCP_XLS_BOH_SMALL_CELL                  @p_plan_cycle             = @p_plan_cycle          
                                     , @p_plan_start_yyyymmdd    = @p_plan_start_yyyymmdd          
                                                                , @p_plan_id                = @p_plan_id          
                                                                , @p_modeling_id            = @p_modeling_id          
                                                                , @p_seq                    = @p_seq          
                                                                , @p_plan_type              = @p_plan_type          
                                                                , @p_master_id              = @p_master_id          
                                                                , @p_division_id            = @p_division_id          
                                                                , @p_engine_plan_id         = @p_engine_plan_id            
                                                                , @p_user_id                = @v_batch_user    
          -----------------------------------------------------------------------------------------------------------------------              
          SELECT  @v_plan_status = dbo.FN_GET_PLAN_STATUS(@p_division_id,@p_plan_start_yyyymmdd,@p_plan_type,@p_seq)              
          PRINT '@v_plan_status[PR_SCP_XLS_BOH_SMALL_CELL][' +  convert(nvarchar, @v_plan_status)  +']'              
              
          --SELECT 'PR_SCP_XLS_BOH_SMALL_CELL', @rows;                  
          IF (@rows < 0 OR @v_plan_status = -2)  GOTO _RETURN_ERR_CODE                  
          --PRINT @rows                  

          -----------------------------------------------------------------------------------------------------------------------                  
          -- 소형 (40) PACK 시뮬레이션 EXCEL DATA 생성
          -----------------------------------------------------------------------------------------------------------------------       
          EXEC @ROWS = PR_SCP_XLS_PSI_GLOBAL_SMALL_PACK           @p_plan_cycle             = @p_plan_cycle          
                                                                , @p_plan_start_yyyymmdd    = @p_plan_start_yyyymmdd          
                                                                , @p_plan_id                = @p_plan_id          
                                                                , @p_modeling_id            = @p_modeling_id          
                                                                , @p_seq                    = @p_seq          
                                                                , @p_plan_type              = @p_plan_type          
                                                                , @p_master_id              = @p_master_id          
                                                                , @p_division_id            = @p_division_id          
                                                                , @p_engine_plan_id         = @p_engine_plan_id            
                                                                , @p_user_id                = @v_batch_user    
          -----------------------------------------------------------------------------------------------------------------------              
          SELECT  @v_plan_status = dbo.FN_GET_PLAN_STATUS(@p_division_id,@p_plan_start_yyyymmdd,@p_plan_type,@p_seq)              
          PRINT '@v_plan_status[PR_SCP_XLS_PSI_GLOBAL_SMALL_PACK][' +  convert(nvarchar, @v_plan_status)  +']'              
          --SELECT 'PR_SCP_XLS_PSI_GLOBAL_SMALL_PACK', @rows;                
          IF @rows < 0 OR @v_plan_status = -2 GOTO _RETURN_ERR_CODE                  
          --PRINT @rows     


          -----------------------------------------------------------------------------------------------------------------------                  
          -- 소형 (40) CELL 시뮬레이션 EXCEL DATA 생성
          -----------------------------------------------------------------------------------------------------------------------  
          EXEC @ROWS = PR_SCP_XLS_PSI_GLOBAL_SMALL_CELL           @p_plan_cycle             = @p_plan_cycle          
                                                                , @p_plan_start_yyyymmdd    = @p_plan_start_yyyymmdd          
                                                                , @p_plan_id                = @p_plan_id          
                                                                , @p_modeling_id            = @p_modeling_id          
                                                                , @p_seq                    = @p_seq          
                                                                , @p_plan_type              = @p_plan_type          
                                                                , @p_master_id              = @p_master_id          
                                                                , @p_division_id            = @p_division_id          
                                                                , @p_engine_plan_id         = @p_engine_plan_id            
                                                                , @p_user_id                = @v_batch_user    
          -----------------------------------------------------------------------------------------------------------------------              
          SELECT  @v_plan_status = dbo.FN_GET_PLAN_STATUS(@p_division_id,@p_plan_start_yyyymmdd,@p_plan_type,@p_seq)              
          PRINT '@v_plan_status[PR_SCP_XLS_PSI_GLOBAL_SMALL_CELL][' +  convert(nvarchar, @v_plan_status)  +']'              
          --SELECT 'PR_SCP_XLS_PSI_GLOBAL_SMALL_CELL', @rows;                
          IF @rows < 0 OR @v_plan_status = -2 GOTO _RETURN_ERR_CODE                  
          --PRINT @rows     

          -----------------------------------------------------------------------------------------------------------------------                  
          -- 소형 (40) 출하 시뮬레이션 EXCEL DATA 생성
          -----------------------------------------------------------------------------------------------------------------------       
          EXEC @ROWS = PR_SCP_XLS_PSI_GLOBAL_SMALL           @p_plan_cycle             = @p_plan_cycle          
                                                                , @p_plan_start_yyyymmdd    = @p_plan_start_yyyymmdd          
                                                                , @p_plan_id                = @p_plan_id          
                                                                , @p_modeling_id            = @p_modeling_id          
                                                                , @p_seq                    = @p_seq          
                                                                , @p_plan_type              = @p_plan_type          
                                                                , @p_master_id              = @p_master_id          
                                                                , @p_division_id            = @p_division_id          
                                                                , @p_engine_plan_id         = @p_engine_plan_id            
                                                                , @p_user_id                = @v_batch_user    
																, @p_is_debug				= 0  --RELEASE
          -----------------------------------------------------------------------------------------------------------------------              
          SELECT  @v_plan_status = dbo.FN_GET_PLAN_STATUS(@p_division_id,@p_plan_start_yyyymmdd,@p_plan_type,@p_seq)              
          PRINT '@v_plan_status[PR_SCP_XLS_PSI_GLOBAL_SMALL][' +  convert(nvarchar, @v_plan_status)  +']'              
          IF @rows < 0 OR @v_plan_status = -2 GOTO _RETURN_ERR_CODE                  



        END              

        IF @p_division_id = '82'    
        BEGIN 
          -----------------------------------------------------------------------------------------------------------------------                
          -- ESS (82) 시뮬레이션 EXCEL DATA 생성
          -----------------------------------------------------------------------------------------------------------------------                
          EXEC @ROWS = PR_SCP_XLS_PSI_GLOBAL_ESS                  @p_plan_cycle             = @p_plan_cycle          
                                                                , @p_plan_start_yyyymmdd    = @p_plan_start_yyyymmdd          
                                                                , @p_plan_id                = @p_plan_id          
                                                                , @p_modeling_id            = @p_modeling_id          
                                                                , @p_seq                    = @p_seq          
                                                                , @p_plan_type              = @p_plan_type          
                                                                , @p_master_id              = @p_master_id          
                                                                , @p_division_id            = @p_division_id          
                                                                , @p_engine_plan_id         = @p_engine_plan_id            
                                                                , @p_user_id                = @v_batch_user    
          -----------------------------------------------------------------------------------------------------------------------              
          SELECT  @v_plan_status = dbo.FN_GET_PLAN_STATUS(@p_division_id,@p_plan_start_yyyymmdd,@p_plan_type,@p_seq)              
          PRINT '@v_plan_status[PR_SCP_XLS_PSI_GLOBAL_ESS][' +  convert(nvarchar, @v_plan_status)  +']'              
              
          --SELECT 'PR_SCP_XLS_PSI_GLOBAL_ESS', @rows;          
          IF (@rows < 0 OR @v_plan_status = -2)  GOTO _RETURN_ERR_CODE                  
          --PRINT @rows 
        END      


        IF  dbo.FN_IS_DIVISION( @p_division_id, 'CREATE', 'EE') = 1    --  EE_UC, EE_HM등의 JV 지원
        BEGIN 

			IF (@p_plan_type = 'PR')	-- PR plan시 생성된 데이터로 FN까지 반영 
			BEGIN
				  -----------------------------------------------------------------------------------------------------------------------                
				  -- 전극(EE) 시뮬레이션 BOM 추가
				  -----------------------------------------------------------------------------------------------------------------------                
				  EXEC @ROWS = PR_SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM        @p_plan_cycle             = @p_plan_cycle          
																		, @p_plan_start_yyyymmdd    = @p_plan_start_yyyymmdd          
																		, @p_plan_id                = @p_plan_id          
																		, @p_modeling_id            = @p_modeling_id          
																		, @p_seq                    = @p_seq          
																		, @p_plan_type              = @p_plan_type          
																		, @p_master_id              = @p_master_id          
																		, @p_division_id            = @p_division_id          
																		, @p_engine_plan_id         = @p_engine_plan_id            
																		, @p_user_id                = @v_batch_user    
				  -----------------------------------------------------------------------------------------------------------------------              
				  SELECT  @v_plan_status = dbo.FN_GET_PLAN_STATUS(@p_division_id,@p_plan_start_yyyymmdd,@p_plan_type,@p_seq)              
				  PRINT '@v_plan_status[PR_SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM][' +  convert(nvarchar, @v_plan_status)  +']'              
              
				  --SELECT 'PR_SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM', @rows;                  
				  IF (@rows < 0 OR @v_plan_status = -2)  GOTO _RETURN_ERR_CODE                  
				  --PRINT @rows 
			END

          -----------------------------------------------------------------------------------------------------------------------                
          -- 전극(EE) 시뮬레이션 EXCEL DATA 생성
          -----------------------------------------------------------------------------------------------------------------------                
          EXEC @ROWS = PR_SCP_XLS_PSI_GLOBAL_ELECTRODE            @p_plan_cycle             = @p_plan_cycle          
                                                                , @p_plan_start_yyyymmdd    = @p_plan_start_yyyymmdd          
                                                                , @p_plan_id                = @p_plan_id          
                                                                , @p_modeling_id            = @p_modeling_id          
                                                                , @p_seq                    = @p_seq          
                                                                , @p_plan_type              = @p_plan_type          
                                                                , @p_master_id              = @p_master_id          
                                                                , @p_division_id            = @p_division_id          
                                                                , @p_engine_plan_id         = @p_engine_plan_id            
                                                                , @p_user_id                = @v_batch_user    
          -----------------------------------------------------------------------------------------------------------------------              
          SELECT  @v_plan_status = dbo.FN_GET_PLAN_STATUS(@p_division_id,@p_plan_start_yyyymmdd,@p_plan_type,@p_seq)              
          PRINT '@v_plan_status[PR_SCP_XLS_PSI_GLOBAL_ESS][' +  convert(nvarchar, @v_plan_status)  +']'              
              
          --SELECT 'PR_SCP_XLS_PSI_GLOBAL_ESS', @rows;                  
          IF (@rows < 0 OR @v_plan_status = -2)  GOTO _RETURN_ERR_CODE                  
          --PRINT @rows 
        END      


        
        -------------------------------------------------------------------------------------------------------------------------                  
        -- 실행 Logic END --                  
        -------------------------------------------------------------------------------------------------------------------------                  
        --IF @@TRANCOUNT > 0                  
        --  BEGIN                  
        --    COMMIT ;                  
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
    --  IF @@TRANCOUNT > 0                  
    --    BEGIN                  
    --      ROLLBACK                   
    --END;                  
                        
      -- ERROR LOG                  
      SET @v_log_type = N'ERROR';                  
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));                  
      SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE());                  
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
                  
     -- 임시 운영반영시에 주석처리 할것.              
     SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +               
                          REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))               
              
              
    -- 종료 LOG                  
    SET @v_log_type = N'END';                  
    SET @v_log_message = N'########## END of procedure ##########';                  
    SET @v_description = N'[' + @p_master_id1 + ']['+@p_engine_plan_id+'][' + @v_exec_time + ']';             
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
                  
    _RETURN_ERR_CODE:                  
        BEGIN                  
             RETURN -1                  
        END;                  
                  
  END;                               
            
                   
          
            
                   

            
                   
