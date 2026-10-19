        
/*                  
 * Program ID   : PR_SCP_ANL_CREATE_DATA                  
 * Description  : UI 데이터 반영 SP 호출                  
 * Execute      : EXEC PR_SCP_ANL_CREATE_DATA    @p_master_id1      = '81::WEEKLY'             
                                                ,@p_engine_plan_id1 = '1023::FN::1'                  
 * Program History                  
 *===================================================================================================                  
 *   Date       In Charge      Description                  
 *===================================================================================================                  
 * 2018.02.06   KTH         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트                  
 * 2018.05.17   YYDOK       PSI DIO 호출로직 제거                 
 * 2018.05.17   KTH         PR_SCP_ANL_PROBLEM_REPORT_PEGGING 파라미터 변경        
 * 2018.07.02   KTH         PR_SCP_ANL_SHIPMENT_PLAN_FG 실행순서 변경      
 * 2018.07.09   KTH         파라미터 변경 (PLN과 동일하게 변경)    
 * 2018.07.16   LTW         PR_SCP_PLN_ELEC_CELL_RTF_PLAN 프로시져 추가(전극일경우만 호출)    
 * 2018.08.30   KTH         PR_SCP_ANL_UI_EE_SEARCH_DATA_CREATE 프로시져 추가
 * 2018.09.04   KTH         PR_SCP_ANL_UI_EE_SEARCH_DATA_CREATE 'EE' 일 경우만 실행하도록 변경, PR_SCP_ANL_UI_EE_SEARCH_DATA_CREATE 파리미터 추가
 * 2018.09.10   KTH         PR_SCP_ANL_PSI_GLOBAL 프로시져 추가
 * 2018.10.05   KTH         PR_SCP_ANL_PSI_ELECTRODE( CELL 환산비율 표기) 프로시저 추가
 * 2018.11.28   KTH         SCP_ANL_PSI_GLOBAL_SMALL(소형) 프로시저 추가
 * 2019.01.30   yydok       전극 timeline이 셀계획수립과 일치하지 않아, PR_SCP_PLN_ELEC_CELL_RTF_PLAN 호출제외
 * 2019.02.14   KTH         SCP SIMULATOR 용 PR_SCP_XLS_CREATE_DATA 프로시저 추가
 * 2019.06.03   KTH         [CSR ID:4009384] GSCM - PSI 화면 개선 요청 - PR_SCP_ANL_PSI_PRODUCTION_AMEND 프로시저 추가
 * 2019.06.21   KTH         82 GLOBAL PSI 추가
 * 2019.07.01   KTH         [PJ20189106] 전지.GSCM 고도화 이행 PR_SCP_ANL_PSI_GLOBAL_ESS 추가
 * 2019.10.31   KTH         PR_SCP_ANL_TACT_TIME 파라미터 개수 변경
 * 2021.08.11   KSG         PJ20209643 Digital SCM Level.3 달성을 위한 개선(Phase2)
 * 2021.08.18   LHJ          PJ20209643 Digital SCM Level.3 달성을 위한 개선(Phase2) Capa Balance Report (소형, 자동차/ESS, 전극) 추가
 * 2021.09.06   LHJ          PJ20209643 Digital SCM Level.3 달성을 위한 개선(Phase2) 모델별 공급 PSI ESS 추가
 * 2022.03.23	KSW			GM JV 반영 :: 81_UC , EE_UC  추가
 * 2022.06.30   KSW         PR_SCP_ANL_UI_EE_SEARCH_DATA_CREATE 프로시저에 @p_division_id 추가
 * 2023.03.31   HRK		    PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 * 2026.03.17   YMH        E20260310-000934 시뮬레이션 용 Plan Type(Test Version) 추가 요청 (소형,전극)
 * 2026-04-17   YMH         E20260406-000042 자동차 사업부 최적화 엔진 사용성 개선위한 TE엔진 버전 추가 요청건
 * 2026-06-10   YMH         E20260605-001440 81_HG DIVISION TE 엔진 추가요청건
 */                  
                  
CREATE PROCEDURE [dbo].[PR_SCP_ANL_CREATE_DATA]                  
    (                   
      @p_master_id1      NVARCHAR(4000)  -- '81::WEEKELY'                  
    , @p_engine_plan_id1 NVARCHAR(4000)  -- '1023::PR::1'                  
    --, @p_user_id         NVARCHAR(150)    = 'scp_batch'                    
    ---- , @p_debug      INT OUTPUT                  
    )                   
 AS                  
  BEGIN                  
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;                  
    SET NOCOUNT ON;                  
    SET XACT_ABORT ON;                  
    SET ANSI_WARNINGS OFF;                  
                  
                      
    DECLARE @p_master_id      NVARCHAR(4000) = @p_master_id1 ;                                                                        -- 82::WEEKLY                    
    DECLARE @p_engine_plan_id NVARCHAR(4000) = @p_engine_plan_id1 ;                                                                   -- 1018::PR::9                    
    DECLARE @p_division_id    NVARCHAR(30)   = SUBSTRING(@p_master_id, 1,       CHARINDEX('::', @p_master_id)-1) ;                     
    DECLARE @p_plan_cycle     NVARCHAR(150)  = SUBSTRING(@p_master_id,          CHARINDEX('::', @p_master_id)+2,100) ;                    
    DECLARE @p_plan_id        NVARCHAR(4000) = SUBSTRING(@p_engine_plan_id, 1,  CHARINDEX('::', @p_engine_plan_id)-1) ;                    
    DECLARE @p_plan_type      NVARCHAR(4000) = SUBSTRING(@p_engine_plan_id,     CHARINDEX('::', @p_engine_plan_id)+2, 2) ;            -- Plan Type이 두 자리이기 때문에 마지막 인수가 2임                    
    DECLARE @p_seq            NVARCHAR(4000) = SUBSTRING(@p_engine_plan_id, DBO.FN_CHARINDEX_REV(@p_engine_plan_id, '::', 0)+2,100) ;                    
    DECLARE @p_modeling_id    NVARCHAR(4000) ;                    
                  
    DECLARE @p_plan_name      NVARCHAR(4000) ;                    
                  
                  
  -- LOG 용 변수 설정                  
    DECLARE @v_batch_user             NVARCHAR(150) = N'scp_batch';                    
--    SET @v_batch_user = @p_user_id                  
    DECLARE @v_program_name           NVARCHAR(150) = 'PR_SCP_ANL_CREATE_DATA';                  
    DECLARE @v_log_type   NVARCHAR(30); -- START/END/ERROR/...                  
    DECLARE @n_log_count              INTEGER = 0;                  
    DECLARE @v_log_message            NVARCHAR(1000);                  
    DECLARE @v_description    NVARCHAR(500);                  
    DECLARE @v_table_id               NVARCHAR(150) = 'SCP_ANL_ALL';                  
    DECLARE @d_event_date             DATETIME;                  
    DECLARE @p_plan_start_yyyymmdd    NVARCHAR(30);                  
                  
    DECLARE @d_plan_name              DATETIME;                  
    
    DECLARE @rows INT;                  
    DECLARE @v_plan_status INT;               
              
    -- PLAN_TYPE이 SP일경우      
    if @p_plan_type = 'SP'            
      return -1              
            
    ---------------------------------------------------------                    
    -- 실행용 변수 설정                    
    -----------------------------------------------------------                    
    -- 1. Modelin ID                    
    SELECT /* PR_SCP_ANL_CREATE_DATA */                    
           @p_modeling_id = m.modeling_id                    
    FROM  scm_mst_modeling m with(nolock)                    
    WHERE division_id = @p_division_id                    
    AND   enterprise  = @p_master_id                    
    ANd   plan_cycle  = @p_plan_cycle ;                     
                    
    -- 2. Plan Name                    
    SELECT /* PR_SCP_ANL_CREATE_DATA */                    
           @p_plan_name = m.plan_name                    
    FROM  scm_mst_plan m with(nolock)                    
    WHERE division_id = @p_division_id               
    AND   plan_id     = @p_plan_id                    
    ANd   plan_cycle  = @p_plan_cycle ;                     
                  
    SET @p_plan_start_yyyymmdd =     @p_plan_name;                  
                  
  -- 시작 LOG                  
    SET @v_log_type    = 'START';                  
    SET @v_log_message = '#SCP_ANL_CREATE_DATA#### Start of procedure #';                  
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
              
              
        -----------------------------------------------------------------------------------------------------------------------                
        -- 출하계획/요청 (SEMI)                
        -----------------------------------------------------------------------------------------------------------------------                
        EXEC @ROWS = PR_SCP_ANL_SHIPMENT_PLAN_SEMI              @p_plan_cycle             = @p_plan_cycle          
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
        PRINT '@v_plan_status[PR_SCP_ANL_SHIPMENT_PLAN_SEMI][' +  convert(nvarchar, @v_plan_status)  +']'              
              
        --SELECT 'PR_SCP_ANL_SHIPMENT_PLAN_SEMI', @rows;                  
        IF (@rows < 0 OR @v_plan_status = -2)  GOTO _RETURN_ERR_CODE                  
        --PRINT @rows                  
              
        -------------------------------------------------------------------------------------------------------------------------                  
        ---- 생산계획 Requirment                 
        -------------------------------------------------------------------------------------------------------------------------                  
        EXEC @ROWS = PR_SCP_ANL_PRODUCTION_PLAN_S               @p_plan_cycle             = @p_plan_cycle          
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
        PRINT '@v_plan_status[PR_SCP_ANL_PRODUCTION_PLAN_S][' +  convert(nvarchar, @v_plan_status)  +']'              
              
        --SELECT 'PR_SCP_ANL_PRODUCTION_PLAN_S', @rows;                  
     IF (@rows < 0 OR @v_plan_status = -2)  GOTO _RETURN_ERR_CODE                  
        --PRINT @rows                  
              
        -----------------------------------------------------------------------------------------------------------------------                  
        ---- 생산계획                  
       -----------------------------------------------------------------------------------------------------------------------              
        EXEC @ROWS = PR_SCP_ANL_PRODUCTION_PLAN                 @p_plan_cycle             = @p_plan_cycle          
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
        PRINT '@v_plan_status[PR_SCP_ANL_PRODUCTION_PLAN][' +  convert(nvarchar, @v_plan_status)  +']'              
              
        --SELECT 'PR_SCP_ANL_PRODUCTION_PLAN', @rows;                  
        IF (@rows < 0 OR @v_plan_status = -2)  GOTO _RETURN_ERR_CODE                  
        --PRINT @rows                 
             
        -----------------------------------------------------------------------------------------------------------------------                  
        ---- 생산계획 수율               
        -----------------------------------------------------------------------------------------------------------------------              
        EXEC @ROWS = PR_SCP_ANL_PRODUCTION_PLAN_I               @p_plan_cycle             = @p_plan_cycle          
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
        PRINT '@v_plan_status[PR_SCP_ANL_PRODUCTION_PLAN_I][' +  convert(nvarchar, @v_plan_status)  +']'              
                        
        --SELECT 'PR_SCP_ANL_PRODUCTION_PLAN_I', @rows;                  
        IF (@rows < 0 OR @v_plan_status = -2)  GOTO _RETURN_ERR_CODE                  
        --PRINT @rows                  
              
        -------------------------------------------------------------------------------------------------------------------------                  
        -- PSI                  
        -------------------------------------------------------------------------------------------------------------------------                  
        EXEC @ROWS = PR_SCP_ANL_PSI_PRODUCTION                  @p_plan_cycle             = @p_plan_cycle          
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
        PRINT '@v_plan_status[PR_SCP_ANL_PSI_PRODUCTION][' +  convert(nvarchar, @v_plan_status)  +']'              
        ------SELECT 'PR_SCP_ANL_PSI_PRODUCTION', @rows;                  
        IF (@rows < 0 OR @v_plan_status = -2)  GOTO _RETURN_ERR_CODE                  
        --PRINT @rows            
        
        -----------------------------------------------------------------------------------------------------------------------                  
        -- PRODUCTION AMEND 실행 : 소형 / PR Plan만 수행
        -----------------------------------------------------------------------------------------------------------------------      
        IF @p_division_id = '40' AND @p_plan_type IN ('PR') 
        BEGIN                 
            EXEC @ROWS = PR_SCP_ANL_PSI_PRODUCTION_AMEND        @p_plan_cycle             = @p_plan_cycle          
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
            PRINT '@v_plan_status[PR_SCP_ANL_PSI_PRODUCTION_AMEND][' +  convert(nvarchar, @v_plan_status)  +']'                      
            --SELECT 'PR_SCP_ANL_PSI_PRODUCTION_AMEND', @rows;                  
            IF (@rows < 0 OR @v_plan_status = -2)  GOTO _RETURN_ERR_CODE                  
            --PRINT @rows      
		END          
          
        -------------------------------------------------------------------------------------------------------------------------                  
        -- PROBLEM REPORT DEMAND                 
        -------------------------------------------------------------------------------------------------------------------------                  
        EXEC @ROWS = PR_SCP_ANL_PROBLEM_REPORT_DEMAND           @p_plan_cycle             = @p_plan_cycle          
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
        PRINT '@v_plan_status[PR_SCP_ANL_PROBLEM_REPORT_DEMAND][' +  convert(nvarchar, @v_plan_status)  +']'              
        --SELECT 'PR_SCP_ANL_PROBLEM_REPORT_DEMAND', @rows;                  
        IF (@rows < 0 OR @v_plan_status = -2)  GOTO _RETURN_ERR_CODE                  
      --PRINT @rows                       
              
        -----------------------------------------------------------------------------------------------------------------------                  
        -- PROBLEM REPORT PEGGING              
        -----------------------------------------------------------------------------------------------------------------------              
        EXEC @ROWS = PR_SCP_ANL_PROBLEM_REPORT_PEGGING          @p_plan_cycle             = @p_plan_cycle          
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
        PRINT '@v_plan_status[PR_SCP_ANL_PROBLEM_REPORT_PEGGING][' +  convert(nvarchar, @v_plan_status)  +']'              
        --SELECT 'PR_SCP_ANL_PROBLEM_REPORT_PEGGING', @rows;                  
        IF (@rows < 0 OR @v_plan_status = -2)  GOTO _RETURN_ERR_CODE                  
        --PRINT @rows                  
              
        -----------------------------------------------------------------------------------------------------------------------                  
        -- 출하계획/요청 (FG)                  
        -----------------------------------------------------------------------------------------------------------------------           
        EXEC @ROWS = PR_SCP_ANL_SHIPMENT_PLAN_FG                @p_plan_cycle             = @p_plan_cycle          
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
        PRINT '@v_plan_status[PR_SCP_ANL_SHIPMENT_PLAN_FG][' +  convert(nvarchar, @v_plan_status)  +']'              
        --SELECT 'PR_SCP_ANL_SHIPMENT_PLAN_FG', @rows;                
        IF @rows < 0 OR @v_plan_status = -2 GOTO _RETURN_ERR_CODE                  
        --PRINT @rows                  


        -- 2023.03.31 HM JV IF @p_division_id IN ( '81','82', '81_UC')    -- 2022.03.23	KSW	GM JV 반영 :: 81_UC  추가
		-- 2023.03.30 HM JV 가상 사업부 추가 대응
		IF EXISTS (SELECT 1 
					 FROM SCM_MST_DIVISION DM WITH(NOLOCK)
					WHERE DM.DIVISION_ID = @p_division_id
					  AND DM.ATTRIBUTE3 IN ('81', '82') -- 자동차/ESS
					  AND DM.VALID_YN	 = 'Y'
					)
        BEGIN 
          -----------------------------------------------------------------------------------------------------------------------                  
          -- GLOBAL PSI
          -----------------------------------------------------------------------------------------------------------------------                  
		  WAITFOR DELAY '0:0:3' -- 선행 Transaction 종료 대기. kimcd 선행 정보 미반영 현상 발생하여 wait 추가
          EXEC @ROWS = PR_SCP_ANL_PSI_GLOBAL                      @p_plan_cycle             = @p_plan_cycle          
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
          PRINT '@v_plan_status[PR_SCP_ANL_PSI_GLOBAL][' +  convert(nvarchar, @v_plan_status)  +']'              
          --SELECT 'PR_SCP_ANL_PSI_GLOBAL', @rows;                
          IF @rows < 0 OR @v_plan_status = -2 GOTO _RETURN_ERR_CODE                  
          --PRINT @rows          
          END      
        
        IF @p_division_id = '40'    
        BEGIN 
          -----------------------------------------------------------------------------------------------------------------------                  
          -- GLOBAL PSI SMALL 소형
          -----------------------------------------------------------------------------------------------------------------------                  
          EXEC @ROWS = PR_SCP_ANL_PSI_GLOBAL_SMALL                @p_plan_cycle             = @p_plan_cycle          
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
          PRINT '@v_plan_status[PR_SCP_ANL_PSI_GLOBAL_SMALL][' +  convert(nvarchar, @v_plan_status)  +']'              
          --SELECT 'PR_SCP_ANL_PSI_GLOBAL_SMALL', @rows;                
          IF @rows < 0 OR @v_plan_status = -2 GOTO _RETURN_ERR_CODE                  
          --PRINT @rows          
        END              

        IF @p_division_id = '82'    
        BEGIN 
          -----------------------------------------------------------------------------------------------------------------------                  
          -- GLOBAL PSI ESS
          -----------------------------------------------------------------------------------------------------------------------                  
        EXEC @ROWS = PR_SCP_ANL_PSI_GLOBAL_ESS                  @p_plan_cycle             = @p_plan_cycle          
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
          PRINT '@v_plan_status[PR_SCP_ANL_PSI_GLOBAL_ESS][' +  convert(nvarchar, @v_plan_status)  +']'              
          --SELECT 'PR_SCP_ANL_PSI_GLOBAL_ESS', @rows;                
          IF @rows < 0 OR @v_plan_status = -2 GOTO _RETURN_ERR_CODE                  
          --PRINT @rows          
        END              


        -----------------------------------------------------------------------------------------------------------------------                  
        -- PROBLEM REPORT DESC                      
        -----------------------------------------------------------------------------------------------------------------------                  
        EXEC @ROWS = PR_SCP_ANL_PROBLEM_REPORT_DESC             @p_plan_cycle             = @p_plan_cycle          
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
        PRINT '@v_plan_status[PR_SCP_ANL_PROBLEM_REPORT_DESC][' +  convert(nvarchar, @v_plan_status)  +']'                      
        --SELECT 'PR_SCP_ANL_PROBLEM_REPORT_DESC', @rows;                  
        IF (@rows < 0 OR @v_plan_status = -2)  GOTO _RETURN_ERR_CODE                  
        --PRINT @rows                  
             
         -----------------------------------------------------------------------------------------------------------------------                  
        -- TACT TIME FOR LINE LOADING CALC                    
        -----------------------------------------------------------------------------------------------------------------------                  
        EXEC @ROWS = PR_SCP_ANL_TACT_TIME            @p_plan_cycle             = @p_plan_cycle          
                                                   , @p_plan_start_yyyymmdd    = @p_plan_start_yyyymmdd   
                                                   , @p_plan_id                = @p_plan_id          
                                                   , @p_modeling_id            = @p_modeling_id          
                                                   , @p_seq                    = @p_seq          
                                                   , @p_plan_type              = @p_plan_type          
                                                   , @p_master_id              = @p_master_id            -- 속도체크용
                                                   , @p_division_id            = @p_division_id          -- 실제사용
                                                   , @p_engine_plan_id         = @p_engine_plan_id       -- 속도체크용 
                                                   , @p_user_id                = @v_batch_user           -- 실제사용 
        -----------------------------------------------------------------------------------------------------------------------              
        SELECT  @v_plan_status = dbo.FN_GET_PLAN_STATUS(@p_division_id,@p_plan_start_yyyymmdd,@p_plan_type,@p_seq)              
        PRINT '@v_plan_status[PR_SCP_ANL_TACT_TIME][' +  convert(nvarchar, @v_plan_status)  +']'                      
        --SELECT 'PR_SCP_ANL_TACT_TIME', @rows;                  
        IF (@rows < 0 OR @v_plan_status = -2)  GOTO _RETURN_ERR_CODE                  
        --PRINT @rows                
            
        -----------------------------------------------------------------------------------------------------------------------                  
        -- WORKING TIME FOR LINE LOADING CALC                         
        -----------------------------------------------------------------------------------------------------------------------                  
        EXEC @ROWS = PR_SCP_ANL_WORKING_TIME             @p_division_id           = @p_division_id               
        -----------------------------------------------------------------------------------------------------------------------              
        SELECT  @v_plan_status = dbo.FN_GET_PLAN_STATUS(@p_division_id,@p_plan_start_yyyymmdd,@p_plan_type,@p_seq)              
        PRINT '@v_plan_status[PR_SCP_ANL_WORKING_TIME][' +  convert(nvarchar, @v_plan_status)  +']'                      
        --SELECT 'PR_SCP_ANL_PROBLEM_REPORT_DESC', @rows;                  
        IF (@rows < 0 OR @v_plan_status = -2)  GOTO _RETURN_ERR_CODE       
        --PRINT @rows              
               
  
        -- 2023.03.31 HM JV IF @p_division_id IN ('EE', 'EE_UC')    -- 2022.03.23	KSW	GM JV 반영 :: EE_UC  추가
		-- 2023.03.31 HM JV 가상 사업부 추가 대응
		IF EXISTS (SELECT 1 
					 FROM SCM_MST_DIVISION DM WITH(NOLOCK)
					WHERE DM.DIVISION_ID = @p_division_id
					  AND DM.ATTRIBUTE3  = 'EE' -- 전극 
					  AND DM.VALID_YN	 = 'Y'
					)
        BEGIN    
            
            -----------------------------------------------------------------------------------------------------------------------                  
            -- PR_SCP_ANL_PSI_ELECTRODE                         
            -----------------------------------------------------------------------------------------------------------------------                  
            EXEC @ROWS = PR_SCP_ANL_PSI_ELECTRODE               @p_plan_cycle             = @p_plan_cycle          
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
            PRINT '@v_plan_status[PR_SCP_ANL_PSI_ELECTRODE][' +  convert(nvarchar, @v_plan_status)  +']'                      
            --SELECT 'PR_SCP_ANL_PSI_ELECTRODE', @rows;                  
            IF (@rows < 0 OR @v_plan_status = -2)  GOTO _RETURN_ERR_CODE                  
            --PRINT @rows      


            -----------------------------------------------------------------------------------------------------------------------                  
            -- PR_SCP_PLN_ELEC_CELL_RTF_PLAN                      
            -----------------------------------------------------------------------------------------------------------------------                  
/*
            EXEC @ROWS = PR_SCP_PLN_ELEC_CELL_RTF_PLAN              @p_plan_start_yyyymmdd    = @p_plan_start_yyyymmdd     
                                                                  , @p_seq                    = @p_seq          
                                                                  , @p_plan_type              = @p_plan_type  
                                                                  , @p_division_id            = @p_division_id          
                                                                  , @p_engine_plan_id         = @p_engine_plan_id      
*/                                                                  
            -----------------------------------------------------------------------------------------------------------------------              
/*            
            SELECT  @v_plan_status = dbo.FN_GET_PLAN_STATUS(@p_division_id,@p_plan_start_yyyymmdd,@p_plan_type,@p_seq)              
            PRINT '@v_plan_status[PR_SCP_PLN_ELEC_CELL_RTF_PLAN][' +  convert(nvarchar, @v_plan_status)  +']'                      
            --SELECT 'PR_SCP_PLN_ELEC_CELL_RTF_PLAN', @rows;                  
            IF (@rows < 0 OR @v_plan_status = -2)  GOTO _RETURN_ERR_CODE                  
            --PRINT @rows        
*/
            -----------------------------------------------------------------------------------------------------------------------                  
            -- PR_SCP_ANL_UI_EE_SEARCH_DATA_CREATE                         
            -----------------------------------------------------------------------------------------------------------------------                  
            EXEC @ROWS = PR_SCP_ANL_UI_EE_SEARCH_DATA_CREATE        @p_plan_start_yyyymmdd    = @p_plan_start_yyyymmdd     
                                                                  , @p_seq                    = @p_seq          
                                                                  , @p_plan_type              = @p_plan_type  
																  , @p_division_id            = @p_division_id
            -----------------------------------------------------------------------------------------------------------------------              
            SELECT  @v_plan_status = dbo.FN_GET_PLAN_STATUS(@p_division_id,@p_plan_start_yyyymmdd,@p_plan_type,@p_seq)              
            PRINT '@v_plan_status[PR_SCP_ANL_UI_EE_SEARCH_DATA_CREATE][' +  convert(nvarchar, @v_plan_status)  +']'                      
            --SELECT 'PR_SCP_ANL_UI_EE_SEARCH_DATA_CREATE', @rows;                  
            IF (@rows < 0 OR @v_plan_status = -2)  GOTO _RETURN_ERR_CODE                  
            --PRINT @rows 

        END  

        -----------------------------------------------------------------------------------------------------------------------                  
        -- SCP SIMULATOR PR_SCP_XLS_CREATE_DATA 실행
        -----------------------------------------------------------------------------------------------------------------------      
        -- E20260310-000934 시뮬레이션 용 Plan Type(Test Version) 추가 요청
        DECLARE @DB_NAME NVARCHAR(50)
        SELECT @DB_NAME = DB_NAME() 
        SELECT @DB_NAME
        IF @DB_NAME != 'LGCE_SCMDEV' -- YMH 개발 임시.
        BEGIN
            IF @p_plan_type IN ('PR', 'MA', 'SE', 'FN')  -- 정상 Plan만 수행
                OR (@p_plan_type = 'TE' AND @p_division_id = '40')
                OR (@p_plan_type = 'TE' AND @p_division_id = 'EE')
                OR (@p_plan_type = 'TE' AND @p_division_id = '81') -- E20260406-000042 자동차 사업부 최적화 엔진 사용성 개선위한 TE엔진 버전 추가 요청건
                OR (@p_plan_type = 'TE' AND @p_division_id = '81_HG') -- E20260605-001440 81_HG DIVISION TE 엔진 추가요청건
            BEGIN                 
                EXEC @ROWS = PR_SCP_XLS_CREATE_DATA              @p_master_id1            = @p_master_id    
                                                                ,@p_engine_plan_id1       = @p_engine_plan_id
                                                                ,@p_user_id               = @v_batch_user
                -----------------------------------------------------------------------------------------------------------------------              
                SELECT  @v_plan_status = dbo.FN_GET_PLAN_STATUS(@p_division_id,@p_plan_start_yyyymmdd,@p_plan_type,@p_seq)              
                PRINT '@v_plan_status[PR_SCP_XLS_CREATE_DATA][' +  convert(nvarchar, @v_plan_status)  +']'                      
                --SELECT 'PR_SCP_XLS_CREATE_DATA', @rows;                  
                IF (@rows < 0 OR @v_plan_status = -2)  GOTO _RETURN_ERR_CODE                  
                --PRINT @rows      
		    END              
        END

        -----------------------------------------------------------------------------------------------------------------------     
        -- 20210811 PJ20209643 Digital SCM Level.3 달성을 위한 개선(Phase2)
        -- YYYYMMDD 기준 최신계획 정보 실행 : 자체가 Error 처리되더라도 Plan은 계속 수행
        -----------------------------------------------------------------------------------------------------------------------      
        IF @p_plan_type = 'FN'  -- Final Plan만 수행
        BEGIN                 
            EXEC @ROWS = PR_SCP_ANL_PLAN_N              @p_division_id            = @p_division_id    
                                                       ,@p_plan_start_yyyymmdd    = @p_plan_start_yyyymmdd
                                                       ,@p_seq                    = @p_seq
            -----------------------------------------------------------------------------------------------------------------------              
            SELECT  @v_plan_status = dbo.FN_GET_PLAN_STATUS(@p_division_id,@p_plan_start_yyyymmdd,@p_plan_type,@p_seq)
            --IF (@rows < 0 OR @v_plan_status = -2)  GOTO _RETURN_ERR_CODE -- 자체가 Error 처리되더라도 Plan은 계속 수행
		END   

        -----------------------------------------------------------------------------------------------------------------------     
        -- 20210811 PJ20209643 Digital SCM Level.3 달성을 위한 개선(Phase2)
        -- Capa Balance Report 용 정보 생성  : 자체가 Error 처리되더라도 Plan은 계속 수행
        -----------------------------------------------------------------------------------------------------------------------   
        -----------------------------------------------------------------------------------------------------------------------   
		-- 소형
        -----------------------------------------------------------------------------------------------------------------------   
        IF @p_division_id = '40'    
        BEGIN    		
          EXEC @ROWS = PR_SCP_ANL_CAPA_BALANCE_40     @p_division_id            = @p_division_id    
                                                     ,@p_plan_start_yyyymmdd    = @p_plan_start_yyyymmdd
                                                     ,@p_plan_type              = @p_plan_type
                                                     ,@p_seq                    = @p_seq
                                                     ,@debug_mode               = 'F'
          -----------------------------------------------------------------------------------------------------------------------              
          SELECT  @v_plan_status = dbo.FN_GET_PLAN_STATUS(@p_division_id,@p_plan_start_yyyymmdd,@p_plan_type,@p_seq)
          --IF (@rows < 0 OR @v_plan_status = -2)  GOTO _RETURN_ERR_CODE -- 자체가 Error 처리되더라도 Plan은 계속 수행
		END
		
        -----------------------------------------------------------------------------------------------------------------------   
		-- 자동차/ESS
        ----------------------------------------------------------------------------------------------------------------------- 
        -- 2023.03.31 HM JV IF @p_division_id IN ('81', '82', '81_UC')		-- 2022.03.23	KSW	GM JV 반영 :: 81_UC  추가
		-- 2023.03.31 HM JV 가상 사업부 추가 대응
		IF EXISTS (SELECT 1 
					 FROM SCM_MST_DIVISION DM WITH(NOLOCK)
					WHERE DM.DIVISION_ID = @p_division_id
					  AND DM.ATTRIBUTE3 IN ('81', '82') -- 자동차/ESS
					  AND DM.VALID_YN	 = 'Y'
					)
        BEGIN      
          EXEC @ROWS = PR_SCP_ANL_CAPA_BALANCE_8182   @p_division_id            = @p_division_id    
                                                     ,@p_plan_start_yyyymmdd    = @p_plan_start_yyyymmdd
                                                     ,@p_plan_type              = @p_plan_type
                                                     ,@p_seq                    = @p_seq
                                                     ,@debug_mode               = 'F'
          -----------------------------------------------------------------------------------------------------------------------              
          SELECT  @v_plan_status = dbo.FN_GET_PLAN_STATUS(@p_division_id,@p_plan_start_yyyymmdd,@p_plan_type,@p_seq)
          --IF (@rows < 0 OR @v_plan_status = -2)  GOTO _RETURN_ERR_CODE -- 자체가 Error 처리되더라도 Plan은 계속 수행
		END
			
        -----------------------------------------------------------------------------------------------------------------------   
		-- 전극
        ----------------------------------------------------------------------------------------------------------------------- 
        -- 2023.03.31 HM JV IF @p_division_id IN ('EE', 'EE_UC')   -- 2022.03.23	KSW	GM JV 반영 :: EE_UC  추가
		-- 2023.03.31 HM JV 가상 사업부 추가 대응
		IF EXISTS (SELECT 1 
					 FROM SCM_MST_DIVISION DM WITH(NOLOCK)
					WHERE DM.DIVISION_ID = @p_division_id
					  AND DM.ATTRIBUTE3  = 'EE' -- 전극  
					  AND DM.VALID_YN	 = 'Y'
					)
        BEGIN    
          EXEC @ROWS = PR_SCP_ANL_CAPA_BALANCE_EE     @p_division_id            = @p_division_id    
                                                     ,@p_plan_start_yyyymmdd    = @p_plan_start_yyyymmdd
                                                     ,@p_plan_type              = @p_plan_type
                                                     ,@p_seq                    = @p_seq
                                                     ,@debug_mode               = 'F'
          -----------------------------------------------------------------------------------------------------------------------              
          SELECT  @v_plan_status = dbo.FN_GET_PLAN_STATUS(@p_division_id,@p_plan_start_yyyymmdd,@p_plan_type,@p_seq)
          --IF (@rows < 0 OR @v_plan_status = -2)  GOTO _RETURN_ERR_CODE -- 자체가 Error 처리되더라도 Plan은 계속 수행
		END

		
		-----------------------------------------------------------------------------------------------------------------------     
        -- 20210906 PJ20209643 Digital SCM Level.3 달성을 위한 개선(Phase2)
        -- 모델별 공급 PSI ESS 용 정보 생성  : 자체가 Error 처리되더라도 Plan은 계속 수행
        -----------------------------------------------------------------------------------------------------------------------   
        -----------------------------------------------------------------------------------------------------------------------   
		-- ESS
        -----------------------------------------------------------------------------------------------------------------------   
        IF @p_division_id = '82'    
        BEGIN    		
          EXEC @ROWS = PR_SCP_ANL_SUPPLY_PSI_BY_MODEL_82    @p_division_id            = @p_division_id    
                                                     ,@p_plan_start_yyyymmdd    = @p_plan_start_yyyymmdd
                                                     ,@p_plan_type              = @p_plan_type
                                                     ,@p_seq                    = @p_seq
                                                     ,@debug_mode               = 'F'
          -----------------------------------------------------------------------------------------------------------------------              
          SELECT  @v_plan_status = dbo.FN_GET_PLAN_STATUS(@p_division_id,@p_plan_start_yyyymmdd,@p_plan_type,@p_seq)
          --IF (@rows < 0 OR @v_plan_status = -2)  GOTO _RETURN_ERR_CODE -- 자체가 Error 처리되더라도 Plan은 계속 수행
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
     SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,      @v_start_time, SYSDATETIME())/ 60))) + ':' +               
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
