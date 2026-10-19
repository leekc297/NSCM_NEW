


CREATE PROCEDURE [dbo].[PR_SCP_ENG_CONTROL]
    ( @p_modeling_id1    NVARCHAR(4000)
    , @p_plan_type1      NVARCHAR(4000)
) AS

/*
 * Program ID   : PR_SCP_ENG_CONTROL
 * Description  : Plan Control
 * OutTable     : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017.12.01   KSG            Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.05.24   KSG            FN Plan 정상 종료 시 자동 Confirm 처리
 * 2018.06.19   KSG            MA Plan 정상 종료 시 자동 Confirm 처리
 * 2018.08.08   KSG            전극 실행 처리
 * 2018.10.30   KSG            Test Plan 추가 : Lookup 추가 : 'PLAN_TYPE' - 'TE'  Test Plan
 *                             PRE Plan과 동일 형태로 수행
 * 2018.11.15   KSG            Test Main Plan 추가 : Lookup 추가 : 'PLAN_TYPE' - 'TM'  Test Plan
 *                             MAIN Plan과 동일 형태로 수행
 * 2019.07.09   KSG            [CSR ID:4034546] GSCM 계획 수립 시점 별 FP Version 조회가능 UI 개발 요청 : Plan Version 저장 작업 Call 추가
 * 2020.01.22   KSG            Daily Plan 수행 종료에 따른 소스 정리
 * 2020.03.30   KSG            전지 공급 대응력 향상을 위한 RTF 적확도 개선 : 전극 수율 건
 * 2021.04.05   KSG            PJ20209642 LGES 전지GSCM 상반기 프로젝트 : Capa 정보 반영
 * 2022.02.08   KSG            PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : Waterfall 생성 사업부별 수행
 * 2022.03.23   KSG            PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : 전극 수율 생성 Call
 * 2022.04.04   LHS            PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선: JV사업부 추가: 사업부 조건별 로직구현시 division_id 대신 속성값(attribute3) 기준으로 변경
                                ----------------------------------------------------------------
                                        구분                         자동차           전극
                                ==============================    =============   ==============
                                  division_group(attribute3)  :        81              EE                
                                ------------------------------    -------------   --------------
                                  division_id                 :     81 , 81_UC      EE , EE_UC  
                                ----------------------------------------------------------------
 * 2022.05.30   sclee.lee      PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 - 계획실행 당시 참조하는 bod_n_v를 별도 테이블에 저장
 * 2022.06.15   KKC            PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선: 계획저장 방식 변경(CSV Upload 계획저장 -> CSV Upload X 저장) 로직 추가       
 * 2023.02.28   KSG            PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 소형 Pre FP 전송 추가   
 * 2023.04.06   KSG            PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 도전과제 계획
                                  1차 사업부 BP/BF 에 해당하는 내역만 수정 함 : 전극용 수정 및 연관 Proc 확인 필요
 * 2024.01.29   HRK            PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase.2 : 자동차 Global PSI New 추가   
 * 2024.07.01   KSG            PJ20239015 LGES Capa. 관리 시스템 구축 : Capa Report 용 Prod Plan 호출
 * 2024.10.18   KSG            E20241016-000757 [공급 SCM PI팀] GSCM시스템 Global PSI New UI 산출시 자동화위한 JV Division 확장 개발건
 * 2024.11.07   KSG            PJ20249346 SCP 개선과제 이행 : ESS 회수포장재 Simulator 정보 생성
 * 2024.11.19   KSG            E20241114-000976 81_ST Global PSI New 생성 시점 외 1건 : 81_ST Final 후 : Global PSI New 정보 생성 중지
 * 2024.12.03   KSG            [PJ20249346] LGES SCP 개선과제 이행 : Semi 도 PR_SCP_PLN_INTERFACE_PLAN 호출
 * 2024.12.18   KSG            E20241211-000667 [공급SCM PI팀] SCM 시스템 G-PSI 내 STD_DIO 프로시저 반영 : PR_SCP_RPT_GLOBAL_PSI_STD_DIO 호출 추가
 * 2025.01.06	HRK			   CPS_BATCH_PROC_RUN lookup 참조하여 생산계획 반영 프로시저 수행 
 * 2026.08.12   YMH            E20260708-000926 Global PSI New 수행 Plan type 추가 요청의 건
 */
  BEGIN
    --SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

     --20180228 프로시저 속도 개선을 위해서 입력변수를 일반변수로 변경함
    DECLARE @p_modeling_id NVARCHAR(4000)   = @p_modeling_id1 ;
    DECLARE @p_plan_type   NVARCHAR(4000)   = @p_plan_type1 ;    

    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_CONTROL';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = '';
    DECLARE @d_event_date   DATETIME;

    DECLARE @v_master_id        NVARCHAR(4000);
    DECLARE @v_division_id      NVARCHAR(4000);
    DECLARE @v_plan_cycle       NVARCHAR(4000);
    DECLARE @v_plan_name        NVARCHAR(4000);
    DECLARE @v_plan_id          NVARCHAR(4000);
    DECLARE @v_engine_plan_id   NVARCHAR(4000);
    DECLARE @n_plan_seq         INTEGER;
    DECLARE @v_outversion_id    NVARCHAR(4000);

    DECLARE @n_pre_plan_id       INTEGER = 0;
    DECLARE @n_cur_plan_id       INTEGER = 0;
    DECLARE @n_pre_week_plan_id  INTEGER = 0;
    DECLARE @n_cur_week_plan_id  INTEGER = 0;
    DECLARE @v_cur_day           NVARCHAR(8) = CONVERT(CHAR(8), GETDATE(), 112); -- 당일 YYYYMMDD
    DECLARE @v_cur_monday        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    DECLARE @d_plan_name         DATETIME;
    DECLARE @v_eng_flag          NVARCHAR(10);
    DECLARE @n_eng_time          INTEGER = 0;
    DECLARE @v_version_name      NVARCHAR(100);

    DECLARE @rows                INT;
    DECLARE @plan_status         INT = 0;
    DECLARE @v_sms_desc          NVARCHAR(4000);
    DECLARE @v_plan_summary1     NVARCHAR(4000);
    DECLARE @v_plan_summary2     NVARCHAR(4000);
    
    DECLARE @X_DB_NAME NVARCHAR(100);
    DECLARE @v_DB_NAME NVARCHAR(100);

    DECLARE @v_division_group   NVARCHAR(30)  ;     ---(2022.04.01) 변수추가 

    DECLARE @v_ENG_NWDRIVE_CNT  INT = 0 ;           --2022.06.15 변수추가 

  -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_modeling_id + ' / ' + @p_plan_type ;
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    SET @rows = 0;

    -----------------------------------------------------------
    -- 실행용 변수 설정
    -----------------------------------------------------------
    -- 1. Master ID / Division ID / Plan Cycle / Planname
    SELECT /* PR_SCP_ENG_CONTROL */
           @v_master_id   = m.enterprise  -- v_master_id
         , @v_division_id = m.division_id -- v_division_id
         , @v_plan_cycle  = m.plan_cycle  -- v_plan_cycle
         , @v_plan_name   =
                CASE WHEN m.plan_cycle = 'WEEKLY' 
                     THEN
                       CONVERT(char(8), DATEADD(dd, -7, dbo.fn_next_day(GETDATE(), 'MON')), 112) -- weekly (당주 월요일)
                     ELSE
                       CONVERT(char(8), DATEADD(dd, -1, GETDATE()), 112) -- daily (전일자)
                END
    FROM  scm_mst_modeling m with(nolock)
    WHERE modeling_id = @p_modeling_id ; --'1'; -- v_master_id
  	-- SELECT '1. ==>      ', @v_master_id as master_id, @v_division_id as division_id , @v_division_id as division_id , @v_plan_cycle as plan_cycle , @v_plan_name as plan_name;

    -- 2. Plan ID
    SELECT /* PR_SCP_ENG_CONTROL */
           @v_plan_id = p.plan_id -- v_plan_id
    FROM   scm_mst_plan p with(nolock)
    WHERE  p.division_id = @v_division_id
    AND    p.plan_cycle  = @v_plan_cycle
    AND    p.plan_name   = @v_plan_name;
  	-- SELECT '2. ==>      ', @@v_plan_id as plan_id;

    -- 3. Plan seq : 처음이면 1, 아니면 MAX(Seq) + 1
    SELECT /* PR_SCP_ENG_CONTROL */
           @n_plan_seq = ISNULL(MAX(p.plan_seq),0) + 1 -- n_plan_seq
    FROM   scm_mst_plan_detail p with(nolock)
    WHERE  p.modeling_id = @p_modeling_id
    AND    p.division_id = @v_division_id
    AND    p.plan_id     = @v_plan_id
    AND    p.plan_type   = @p_plan_type  --20180219 추가 (plan_type 별 seq 구하기 위해서 수정함) 
	;
	
	IF (@n_plan_seq = null)  select @n_plan_seq = ISNULL(@n_plan_seq,1)
  	-- SELECT '3. ==>      ', @n_plan_seq as plan_seq;
    
    -- 4. Engine Plan ID
    SET @v_engine_plan_id = @v_plan_id + '::' + @p_plan_type + '::' + CONVERT(NVARCHAR, @n_plan_seq)
	SET @v_version_name   = @v_plan_name + '_' + @p_plan_type + '_' + CONVERT(NVARCHAR, @n_plan_seq) + '_' + @v_division_id

    -- 5. DIVISION GROUP 
    /*------------------------------------------------------------------
     * Division Group 정의  (2022.04.04: Joint Venture 사업부 추가) 
        - JV사업부 코드(81_UC, EE_UC)추가되면서 division_id만으로는 사업부별 로직분개시 구분값으로 활용 불가.
        - 40, 81, 82, EE 등 사업부별 로직전개에 사용할 기준값을 (attribute3)컬럼에 정의하고 변수 '@v_division_group'로 처리
        - 기존의 division_id 분개로직을 division_group 기준으로 대체하여 사용한다.
        - 예) division_group: 81 >> division_id: 81 , 81_UC
    ----------------------------------------------------------------------*/     
    SELECT @v_division_group = di.attribute3
    FROM   scm_mst_division di WITH(NOLOCK)
    WHERE  di.valid_yn       = 'Y' 
    AND    di.division_id    =  @v_division_id  ; 


	------------------------------------------------
	-- Plan Version 저장 작업 Call : 20190709 
	--   오류 발생해도 Plan 작업은 정상 수행되어야 함
	------------------------------------------------
    BEGIN TRY
      BEGIN
        -- 20230406 PJ20230691 BF 추가
	    IF @p_plan_type IN ('MA', 'SE', 'FN', 'TM', 'BF') -- PR/TE는 FP Plan Cutoff 시 한 번 수행 
          EXEC [dbo].[PR_SCM_MST_PLAN_FP_RELEASE_ID] @v_plan_name, @v_plan_id, @p_modeling_id, @n_plan_seq, @p_plan_type, @v_division_id;	

      END;
    END TRY
    BEGIN CATCH
        SET @v_log_type = 'TXN'; -- 오류 발생해도 Plan 작업은 정상 수행되어야 함
    END CATCH;
 
	------------------------------------------------
	-- 20210405 PJ20209642 Capa 정보 반영 Call
	--   오류 발생해도 Plan 작업은 정상 수행되어야 함
	------------------------------------------------
    BEGIN TRY
      BEGIN
        EXEC [dbo].SCP0049_SAVE_NEW_VERSION  @p_today_yyyymmdd   = @v_cur_day
                                           , @p_chk_bp           = 'N'
                                           , @p_chk_rp           = 'N'
                                           , @p_chk_scp          = 'Y'
                                           , @p_version_division = @v_division_id
                                           , @p_version_name     = @v_version_name
                                           , @p_update_id        = 'scp_batch' ;
										   
        EXEC [dbo].[PR_SCP_MST_WORKING_TIME_COPY_FROM_FP] @v_division_id ;
        EXEC [dbo].[PR_SCP_MST_LOSS_TIME_COPY_FROM_FP] @v_division_id ;
        EXEC [dbo].[PR_SCP_MST_TACT_TIME_EXCEPT_COPY_FROM_FP] @v_division_id ;

      END;
    END TRY
    BEGIN CATCH
        -- 오류 발생해도 SMS 전송 후 Plan 작업은 정상 수행되어야 함
        -----------------------------------------------------------
        -- SMS 전송 : Plan ERROR (20)
        -----------------------------------------------------------
        SET @v_sms_desc = @v_master_id + '::' + @p_plan_type + ' : Capa Error' ;
        EXEC SCM_ADM_SMS_SEND_BATCH 20, @v_sms_desc;
        -----------------------------------------------------------
    END CATCH;

    BEGIN TRY
      BEGIN
        -----------------------------------------------------------
        -- 실행 로직 Start
        -----------------------------------------------------------
        -----------------------------------------------------------
        -- 1. Engine Input Create
        -----------------------------------------------------------
        SET @v_log_type = 'TXN';
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = 'Plan Input';
        SET @v_description = 'Start Plan Input... ' + ' / ' + @v_master_id + ' / ' + @v_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;   
		
        -----------------------------------------------------------
        -- SMS 전송 : Plan START (17)
        -----------------------------------------------------------
        SET @v_sms_desc = @v_master_id + '::' + @p_plan_type;
        EXEC SCM_ADM_SMS_SEND_BATCH 17, @v_sms_desc;
        -----------------------------------------------------------
		
        -----------------------------------------------------------
        -- PR Type 
        -----------------------------------------------------------
		-- 전극 외 사업부 : 2018.08.08  전극 실행 처리
		-- 20181030 : 'TE' Plan 수행 추가
        -- 20230406 PJ20230691 BP 추가
        IF @p_plan_type IN ('PR', 'TE', 'BP') AND  @v_division_group <> 'EE'           ---2022.04.04 JV사업부 추가 변수변경: @p_modeling_id -> @v_division_group
                                         /*  @p_modeling_id NOT LIKE '4%'   */   -- 20220404 변경전 

		  BEGIN

            EXEC @rows = PR_SCP_ENG_IN_PRE_ALL @p_modeling_id, @p_plan_type
            SELECT 'PR_SCP_ENG_IN_PRE_ALL', @rows;
            IF @rows < 0 GOTO _RETURN_ERR_CODE

		  END
        
		-- 전극 사업부 : 2018.08.08  전극 실행 처리
		-- 20181030 : 'TE' Plan 수행 추가
        ELSE IF @p_plan_type IN ('PR', 'TE') AND  @v_division_group = 'EE'       ---2022.04.04 JV사업부 추가 변수변경: @p_modeling_id -> @v_division_group
                                               /* @p_modeling_id LIKE '4%' */    -- 20220404 변경전
		  BEGIN
        
            -- SCP용 DEMAND 데이터 ( OUTPUT 파트에서 생성한 프로시저임)
            EXEC @rows = PR_SCP_PLN_ELEC_DEMAND_CELL_PLAN @v_division_id, @v_plan_name, @p_plan_type
            
			SELECT 'PR_SCP_PLN_ELEC_DEMAND_CELL_PLAN', @rows;
            IF @rows < 0 GOTO _RETURN_ERR_CODE		

            ------------------------------------------------
			-- 20220323  PJ20216891 : Line 별 전극 수율 생성 Call : EE/PR 에서만 수행함
            ------------------------------------------------
			IF @p_plan_type IN ('PR')
			BEGIN
                EXEC @rows = PR_SCP_PLN_ASSEMBLY_YIELD_AVG @v_division_id
                SELECT 'PR_SCP_PLN_ASSEMBLY_YIELD_AVG', @rows;
                IF @rows < 0 GOTO _RETURN_ERR_CODE
			END

            ------------------------------------------------

			-- 20200330 전극 수율 정보 생성 Proc Call : Line_id = '-'
            EXEC @rows = PR_SCP_PLN_ELEC_YIELD_AVG @v_division_id, @v_plan_name, @p_plan_type
            SELECT 'PR_SCP_PLN_ELEC_YIELD_AVG', @rows;
            IF @rows < 0 GOTO _RETURN_ERR_CODE

            ------------------------------------------------

            EXEC @rows = PR_SCP_ENG_EE_PRE_ALL @p_modeling_id, @p_plan_type
            SELECT 'PR_SCP_ENG_EE_PRE_ALL', @rows;
            IF @rows < 0 GOTO _RETURN_ERR_CODE

		  END
		  
        -----------------------------------------------------------
        -- MA/SE/FN Type
        -----------------------------------------------------------
		-- 전극 외 사업부 : 2018.08.08  전극 실행 처리
		-- 20181115 Test Main Plan 추가 : TM
        -- 20230406 PJ20230691 BF 추가
        ELSE IF @p_plan_type IN ('MA', 'SE', 'FN', 'TM', 'BF') AND @v_division_group <> 'EE'          ---2022.04.04 JV사업부 추가 변수변경: @p_modeling_id -> @v_division_group
                                                          /* @p_modeling_id NOT LIKE '4%' */    -- 20220404 변경전 
		  BEGIN

            EXEC @rows = PR_SCP_ENG_IN_FN_ALL @p_modeling_id, @p_plan_type
            SELECT 'PR_SCP_ENG_IN_FN_ALL', @rows;
            IF @rows < 0 GOTO _RETURN_ERR_CODE

		  END

		-- 전극 사업부 : 2018.08.08  전극 실행 처리
		-- 20181115 Test Main Plan 추가 : TM
        ELSE IF @p_plan_type IN ('MA', 'SE', 'FN', 'TM') AND @v_division_group = 'EE'          ---2022.04.04 JV사업부 추가 변수변경: @p_modeling_id -> @v_division_group
                                                          /* @p_modeling_id LIKE '4%' */       -- 20220404 변경전 
		  BEGIN
        
            -- SCP용 DEMAND 데이터 ( OUTPUT 파트에서 생성한 프로시저임)
            EXEC @rows = PR_SCP_PLN_ELEC_DEMAND_CELL_PLAN @v_division_id, @v_plan_name, @p_plan_type
            SELECT 'PR_SCP_PLN_ELEC_DEMAND_CELL_PLAN', @rows;
            IF @rows < 0 GOTO _RETURN_ERR_CODE

            ------------------------------------------------

			-- 20200330 전극 수율 정보 생성 Proc Call
            EXEC @rows = PR_SCP_PLN_ELEC_YIELD_AVG @v_division_id, @v_plan_name, @p_plan_type
            SELECT 'PR_SCP_PLN_ELEC_YIELD_AVG', @rows;
            IF @rows < 0 GOTO _RETURN_ERR_CODE

            ------------------------------------------------

            EXEC @rows = PR_SCP_ENG_EE_FN_ALL @p_modeling_id, @p_plan_type
            SELECT 'PR_SCP_ENG_EE_FN_ALL', @rows;
            IF @rows < 0 GOTO _RETURN_ERR_CODE

		  END
		  
        ------------------------------------------------
        -- Plan Status Check : 사용자 중지 시 Plan Stop
        ------------------------------------------------
        SELECT @plan_status = dbo.fn_get_plan_status(@v_division_id, @v_plan_name, @p_plan_type, @n_plan_seq)
        IF @plan_status < 0 
		BEGIN 
          SET @rows = -1;
          GOTO _RETURN_ERR_CODE
        END   
        ------------------------------------------------

	    -------------------------------------------------------------------------------------------------------------------
	    -- 2. 엔진 수행 여부 확인 후 Output 처리
	    --    무한루프 돌면서 엔진 수행 완료여부 확인
        -------------------------------------------------------------------------------------------------------------------
        SET @v_log_type = 'TXN';
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = 'RUN Engine Check';
        SET @v_description = 'Engine Start Check... ' + ' / ' + @v_master_id + ' / ' + @v_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	
	    SET @v_eng_flag = 'R';
        SET @n_eng_time = 0;
	
        -- 엔진 수행 시작 확인 : 확인 후 시작지 않으면 Error 처리 
        WHILE(@v_eng_flag = 'R')
        BEGIN

	      WAITFOR DELAY '0:0:10'; -- 10초 Delay
	  	  
          -- 엔진제어용 Flag 정보 확인
          SELECT /* PR_SCP_ENG_CONTROL */
                 @v_eng_flag = engine_flag  -- Engine 시작 시 P, 완료시 C 로 Update됨
          FROM   th_mst_eng_plan_flag_sn  with(nolock)
          WHERE  master_id      = @v_master_id
          AND    plan_id        = @v_engine_plan_id
          AND    out_version_id = @v_engine_plan_id;

	      SET @n_eng_time = @n_eng_time + 10; -- 10초 Delay

	      IF @n_eng_time = 1200 -- 20분
	        BREAK;
        END;

	    -- Input 생성 후 Engine이 시작되지 않은 경우
	    IF @v_eng_flag = 'R'
        BEGIN
          -- ERROR LOG
          SET @v_log_type = 'ERROR';
          SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
          SET @v_description = 'Engine Not Started... ' + ' / ' + @v_master_id + ' / ' + @v_engine_plan_id ;
          SET @d_event_date = SYSDATETIME();
          EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;    

          SET @rows = -1;
          GOTO _RETURN_ERR_CODE

          RETURN -1
        END;
		
        ------------------------------------------------
        -- Plan Status Check : 사용자 중지 시 Plan Stop
        ------------------------------------------------
        SELECT @plan_status = dbo.fn_get_plan_status(@v_division_id, @v_plan_name, @p_plan_type, @n_plan_seq)
        IF @plan_status < 0 
		BEGIN 
          SET @rows = -1;
          GOTO _RETURN_ERR_CODE
        END   
        ------------------------------------------------

	    -------------------------------------------------------------------------------------------------------------------
	    -- 3. 엔진 수행 종료 확인 : 확인 후 종료되지 않으면 Error 처리 
        -------------------------------------------------------------------------------------------------------------------		
	    -- Engine이 정상 시작되면 Engine 종료 대기
        SET @v_log_type = 'TXN';
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = 'RUN Engine';
        SET @v_description = 'Start Engine... ' + ' / ' + @v_master_id + ' / ' + @v_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        WHILE(@v_eng_flag = 'P')
        BEGIN

	      WAITFOR DELAY '0:0:10'; -- 10초 Delay
	  	  
          -- 엔진제어용 Flag 정보 확인
          SELECT /* PR_SCP_ENG_CONTROL */
                 @v_eng_flag = engine_flag  -- Engine 시작 시 P, 완료시 C 로 Update됨
          FROM   th_mst_eng_plan_flag_sn with(nolock)
          WHERE  master_id      = @v_master_id
          AND    plan_id        = @v_engine_plan_id
          AND    out_version_id = @v_engine_plan_id;

	      SET @n_eng_time = @n_eng_time + 10; -- 10초 Delay

	      IF @n_eng_time = 10800 -- 180분
	        BREAK;
	    END;

	    -- Engine 시작 후 정해진 시간 내에 종료되지 않은 경우
	    IF @v_eng_flag = 'P'
        BEGIN
          -- ERROR LOG
          SET @v_log_type = 'ERROR';
          SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
          SET @v_description = 'Engine Not Completed... ' + ' / ' + @v_master_id + ' / ' + @v_engine_plan_id ;
          SET @d_event_date = SYSDATETIME();
          EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date; 

          SET @rows = -1;
          GOTO _RETURN_ERR_CODE
   
          RETURN -1
        END;
		
        ------------------------------------------------
        -- Plan Status Check : 사용자 중지 시 Plan Stop
        ------------------------------------------------
        SELECT @plan_status = dbo.fn_get_plan_status(@v_division_id, @v_plan_name, @p_plan_type, @n_plan_seq)
        IF @plan_status < 0 
		BEGIN 
          SET @rows = -1;
          GOTO _RETURN_ERR_CODE
        END   
        ------------------------------------------------
				
	    -------------------------------------------------------------------------------------------------------------------
	    -- 4. Engine Output Transfer
        -------------------------------------------------------------------------------------------------------------------
	    -- Engine이 정상 종료된 경우
        SET @v_log_type = 'TXN';
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = 'Plan Output';
        SET @v_description = 'Start Plan Output Transfer... ' + ' / ' + @v_master_id + ' / ' + @v_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        EXEC @rows = PR_SCP_ENG_OUT_ALL @v_master_id, @v_engine_plan_id;
        SELECT 'PR_SCP_ENG_OUT_ALL', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE
		
        ------------------------------------------------
        -- Plan Status Check : 사용자 중지 시 Plan Stop
        ------------------------------------------------
        SELECT @plan_status = dbo.fn_get_plan_status(@v_division_id, @v_plan_name, @p_plan_type, @n_plan_seq)
        IF @plan_status < 0 
		BEGIN 
          SET @rows = -1;
          GOTO _RETURN_ERR_CODE
        END   
        ------------------------------------------------
				
	    -------------------------------------------------------------------------------------------------------------------
	    -- 5. UI용 Output 처리
        -------------------------------------------------------------------------------------------------------------------
		
        -------------------------------------------------------------------------------------------------------------------
	    -- 5.1 UI용 Output 처리 : PLN
        -------------------------------------------------------------------------------------------------------------------
	    -- Engine이 정상 종료된 경우
        SET @v_log_type = 'TXN';
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = 'Plan PLN Output';
        SET @d_event_date = SYSDATETIME();
		
	    -- WEEKLY
        IF @v_plan_cycle = 'WEEKLY' 
		BEGIN
          SET @v_description = 'Start Plan SCP PLN Create... ' + ' / ' + @v_master_id + ' / ' + @v_engine_plan_id ;
          EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

          EXEC @rows = PR_SCP_PLN_CREATE_DATA @v_master_id, @v_engine_plan_id;
          SELECT 'PR_SCP_PLN_CREATE_DATA', @rows;
          IF @rows < 0 GOTO _RETURN_ERR_CODE		

        END; -- IF @v_plan_cycle = 'WEEKLY' 

        -- Plan Detail 정보 Update
        UPDATE /* PR_SCP_ENG_CONTROL */
               scm_mst_plan_detail
        SET    output_end_date   = GETDATE()
             , anl_start_date    = GETDATE()
             , last_update_date  = GETDATE()
        WHERE  modeling_id = @p_modeling_id
        AND    division_id = @v_division_id
        AND    plan_id     = @v_plan_id    
        AND    plan_type   = @p_plan_type 
        AND    plan_seq    = CONVERT(NVARCHAR, @n_plan_seq)  
		;
		
        ------------------------------------------------
        -- Plan Status Check : 사용자 중지 시 Plan Stop
        ------------------------------------------------
        SELECT @plan_status = dbo.fn_get_plan_status(@v_division_id, @v_plan_name, @p_plan_type, @n_plan_seq)
        IF @plan_status < 0 
		BEGIN 
          SET @rows = -1;
          GOTO _RETURN_ERR_CODE
        END   
        ------------------------------------------------
		
        -------------------------------------------------------------------------------------------------------------------
	    -- 5.2 UI용 Output 처리 : ANL
        -------------------------------------------------------------------------------------------------------------------
        SET @v_log_type = 'TXN';
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = 'Plan ANL Output';
        SET @d_event_date = SYSDATETIME();
		
        ------------------------------------------
	    -- WEEKLY
        ------------------------------------------
        IF @v_plan_cycle = 'WEEKLY' 
		BEGIN
          SET @v_description = 'Start Plan SCP ANL Create... ' + ' / ' + @v_master_id + ' / ' + @v_engine_plan_id ;
          EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

          -- WEEKLY 수행용 PR Call
          EXEC @rows = PR_SCP_ANL_CREATE_DATA @v_master_id, @v_engine_plan_id;
          SELECT 'PR_SCP_ANL_CREATE_DATA', @rows;
          IF @rows < 0 GOTO _RETURN_ERR_CODE	

        END; -- IF @v_plan_cycle = 'WEEKLY' 
		
        ------------------------------------------
        -- Plan Detail 정보 Update
        ------------------------------------------
		-- WEEKLY 이면서 PR/SE 인 경우 : Confirm 없음
		-- 20181114 TE/TM 조건 추가
        -- 20230406 PJ20230691 BF 추가
        IF @p_plan_type NOT IN ('MA', 'FN', 'TE', 'TM', 'BF')
		BEGIN
            UPDATE /* PR_SCP_ENG_OUT_ALL */
                   scm_mst_plan_detail
            SET    plan_status        = '1' -- 정상 종료
                 , display_yn         = 'Y'
                 , ui_display_yn      = 'Y'
                 , normal_complete_yn = 'Y'
                 , anl_end_date       = GETDATE()
                 , last_update_date   = GETDATE()
            WHERE  modeling_id = @p_modeling_id
            AND    division_id = @v_division_id
            AND    plan_id     = @v_plan_id    
            AND    plan_type   = @p_plan_type 
            AND    plan_seq    = CONVERT(NVARCHAR, @n_plan_seq)    
            ; 

        END; -- IF @p_plan_type NOT IN ('MA', 'FN', 'TE', 'TM', 'BF')
		
		-- WEEKLY이면서 MA/FN인 경우 : 자동 Confirm -- 2018.06.19  MA Plan 정상 종료 시 자동 Confirm 처리
		-- 20181114 TE/TM 조건 추가
        -- 20230406 PJ20230691 BF 추가
        IF @p_plan_type IN ('MA', 'FN', 'TE', 'TM', 'BF')
		BEGIN
            -- 자동 Confirm 실행 
            UPDATE /* PR_SCP_ENG_CONTROL */
                   scm_mst_plan_detail
	    	   SET CONFIRM_FLAG = ''
                  ,CONFIRM_USER = ''
	    		  ,CONFIRM_DATE = ''
	    	 WHERE modeling_id = @p_modeling_id
	    	   AND division_id = @v_division_id
		       AND plan_id     = @v_plan_id
    		   AND plan_type   = @p_plan_type ;

            UPDATE /* PR_SCP_ENG_CONTROL */
                   scm_mst_plan_detail
            SET    plan_status        = '1' -- 정상 종료
                 , display_yn         = 'Y'
                 , ui_display_yn      = 'Y'
                 , normal_complete_yn = 'Y'
                 , anl_end_date       = GETDATE()
                 , last_update_date   = GETDATE()

	    	     , CONFIRM_FLAG       = 'Y'
		    	 , CONFIRM_USER       = 'scm_batch'
			     , CONFIRM_DATE       = GETDATE()

            WHERE  modeling_id = @p_modeling_id
            AND    division_id = @v_division_id
            AND    plan_id     = @v_plan_id    
            AND    plan_type   = @p_plan_type 
            AND    plan_seq    = CONVERT(NVARCHAR, @n_plan_seq)    
            ; 

        END; -- IF @p_plan_type IN ('MA', 'FN', 'TE', 'TM', 'BF')
				
       /**************************************************************
        * 엔진 점검용 BUF 정보 Insert : 2022.06.20 Plan 결과 SMS 추가를 위하여 위치 조정함
        **************************************************************/
        BEGIN TRY
          BEGIN
		      SET @v_plan_summary1 = ';'
		      SET @v_plan_summary2 = ';'
		   
              EXEC ENG_SCP.DBO.PR_SCP_SUMMARY_REPORT @v_master_id, @v_engine_plan_id, @v_engine_plan_id;
              EXEC ENG_SCP.DBO.PR_SCP_SUMMARY_REPORT_SALES @v_master_id, @v_engine_plan_id, @v_engine_plan_id;

			  SELECT @v_plan_summary1 = 'PLAN' + ' : ' + SUBSTRING(CONVERT(VARCHAR(50), ROUND(A.QTY_RATIO,2)), 1, 5)
			    FROM SCP_ENG_PLAN_SUMMARY_SN A WITH(NOLOCK)
				   , TH_ENG_PLAN_INFO_SN     B WITH(NOLOCK)
			   WHERE A.MASTER_ID = B.MASTER_ID
			     AND A.PLAN_ID   = B.PLAN_ID   
			     AND A.MASTER_ID = @v_master_id
			     AND A.PLAN_ID   = @v_engine_plan_id
			     AND A.STEP      < '3'
			     AND A.TITLE     = 'DEMAND PLAN'

			  SELECT @v_plan_summary2 = 'ON-TIME' + ' : ' + SUBSTRING(CONVERT(VARCHAR(50), ROUND(A.QTY_RATIO,2)), 1, 5)
			    FROM SCP_ENG_PLAN_SUMMARY_SN A WITH(NOLOCK)
				   , TH_ENG_PLAN_INFO_SN     B WITH(NOLOCK)
			   WHERE A.MASTER_ID = B.MASTER_ID
			     AND A.PLAN_ID   = B.PLAN_ID   
			     AND A.MASTER_ID = @v_master_id
			     AND A.PLAN_ID   = @v_engine_plan_id
			     AND A.STEP      < '3'
			     AND A.TITLE     = 'ON-TIME'

          END;
        END TRY
        BEGIN CATCH
          SET @v_plan_summary1 = ';'; -- 오류 발생해도 Plan 작업은 정상 수행되어야 함
          SET @v_plan_summary2 = ';'; -- 오류 발생해도 Plan 작업은 정상 수행되어야 함
        END CATCH;
				
        -----------------------------------------------------------
        -- SMS 전송 : Plan END (18)
        -----------------------------------------------------------
        --SET @v_sms_desc = @v_master_id + '::' + @p_plan_type;
        SET @v_sms_desc = @v_master_id + '::' + @p_plan_type + ' / ' + @v_plan_summary1 + ' / ' + @v_plan_summary2;
        EXEC SCM_ADM_SMS_SEND_BATCH 18, @v_sms_desc;
        -----------------------------------------------------------
		
        -----------------------------------------------------------
        -- 엔진결과 외부시스템 인터페이스 처리 실행
        -----------------------------------------------------------
		-- 20230228 PJ20230691R 소형 Pre FP 전송 추가를 위하여 PR에서도 Call함 : PR_SCP_PLN_INTERFACE_PLAN 내부에서 분기 처리
        -- 20241203 PJ20249346 : Semi 도 PR_SCP_PLN_INTERFACE_PLAN 호출
        IF @p_plan_type IN ('PR', 'MA', 'SE', 'FN')
		BEGIN
		   
            EXEC PR_SCP_PLN_INTERFACE_PLAN @v_division_id, @v_plan_name, @p_plan_type, @n_plan_seq, 'scm_batch' ;

        END; -- IF @p_plan_type IN ('PR', 'MA', 'SE', 'FN')
		
        -----------------------------------------------------------
        -- 재고 DIO Trend 정보 생성 : 20230228 PJ20230691R FN - 81/81_UC
        -----------------------------------------------------------
        IF @p_plan_type IN ('FN') AND @v_division_group IN ('81')  
		BEGIN
			BEGIN TRY
			  BEGIN
				EXEC PR_SCP_RPT_DIO_TREND_MM @v_division_id, @v_plan_name, 'scm_batch' ;
			  END;
			END TRY

			BEGIN CATCH
			  SET @v_log_type = 'TXN'; -- 오류 발생해도 Plan 작업은 정상 수행되어야 함
			END CATCH;
        END;
		
        -----------------------------------------------------------
        -- 2024.01.29 자동차 Global PSI New 데이터 생성 추가
        -- 20241018  E20241016-000757 81 JV Division 확장 개발건
		-- 2024.11.19 E20241114-000976 
        --  WA 도입셀 정보 반영을 위하여 81_ST Global PSI New 생성 시점 변경
        --   - 81_ST Final 후 : Global PSI New 정보 생성 중지
        --   - 81 Final 후 : 81 Global PSI New 정보 생성 이후 81_ST 정보도 같이 생성
        -----------------------------------------------------------
        --IF @p_plan_type IN ('FN') AND @v_division_id IN ('81')  -- JV제외 
        -- E20260708-000926 Global PSI New 수행 Plan type 추가 요청의 건 기존 로직 주석처리
        -- IF @p_plan_type IN ('FN') AND @v_division_group IN ('81')  -- JV 포함
        -- E20260708-000926 Global PSI New 수행 Plan type 추가 요청의 건 기존 로직 신규로직
        IF @p_plan_type IN ('PR','MA','FN') AND @v_division_group IN ('81')  -- JV 포함
		   AND @v_division_id NOT IN ('81_ST') -- 81_ST 는 81 Finlal 이후 수행 
		BEGIN
			BEGIN TRY
			  BEGIN
                -- E20260708-000926 Global PSI New 수행 Plan type 추가 요청의 건 기존 로직 주석처리 시작
                /*
				EXEC PR_SCP_RPT_GLOBAL_PSI_MD_MM @v_division_id, @v_plan_name;	-- 월별
				EXEC PR_SCP_RPT_GLOBAL_PSI_MD_WW @v_division_id, @v_plan_name;	-- 주별
                
				-- 2024.12.18 E20241211-000667 : PR_SCP_RPT_GLOBAL_PSI_STD_DIO 호출 추가
				EXEC PR_SCP_RPT_GLOBAL_PSI_STD_DIO @P_DIVISION_ID = @v_division_id, @P_PLAN_START_YYYYMMDD = @v_plan_name
                */
                -- E20260708-000926 Global PSI New 수행 Plan type 추가 요청의 건 기존 로직 주석처리 끝
                -- E20260708-000926 Global PSI New 수행 Plan type 추가 요청의 건 기존 로직 신규로직 시작
                EXEC PR_SCP_RPT_GLOBAL_PSI_MD_MM @v_division_id, @v_plan_name, @p_plan_type;	-- 월별
				EXEC PR_SCP_RPT_GLOBAL_PSI_MD_WW @v_division_id, @v_plan_name, @p_plan_type;	-- 주별
                EXEC PR_SCP_RPT_GLOBAL_PSI_STD_DIO @P_DIVISION_ID = @v_division_id, @P_PLAN_START_YYYYMMDD = @v_plan_name, @P_PLAN_TYPE = @p_plan_type
                -- E20260708-000926 Global PSI New 수행 Plan type 추가 요청의 건 기존 로직 신규로직 끝

				-- 81_ST 는 81 Finlal 이후 수행 
				IF @v_division_id IN ('81')  
				BEGIN
                    -- E20260708-000926 Global PSI New 수행 Plan type 추가 요청의 건 기존 로직 주석처리 시작
                    /*
					EXEC PR_SCP_RPT_GLOBAL_PSI_MD_MM '81_ST', @v_plan_name;	-- 월별
					EXEC PR_SCP_RPT_GLOBAL_PSI_MD_WW '81_ST', @v_plan_name;	-- 주별

				    -- 2024.12.18 E20241211-000667 : PR_SCP_RPT_GLOBAL_PSI_STD_DIO 호출 추가
				    EXEC PR_SCP_RPT_GLOBAL_PSI_STD_DIO @P_DIVISION_ID = '81_ST', @P_PLAN_START_YYYYMMDD = @v_plan_name
                    */
                    -- E20260708-000926 Global PSI New 수행 Plan type 추가 요청의 건 기존 로직 주석처리 끝
                    -- E20260708-000926 Global PSI New 수행 Plan type 추가 요청의 건 기존 로직 신규로직 시작
                    EXEC PR_SCP_RPT_GLOBAL_PSI_MD_MM '81_ST', @v_plan_name, @p_plan_type;	-- 월별
					EXEC PR_SCP_RPT_GLOBAL_PSI_MD_WW '81_ST', @v_plan_name, @p_plan_type;	-- 주별
                    EXEC PR_SCP_RPT_GLOBAL_PSI_STD_DIO @P_DIVISION_ID = '81_ST', @P_PLAN_START_YYYYMMDD = @v_plan_name , @P_PLAN_TYPE = @p_plan_type
                    -- E20260708-000926 Global PSI New 수행 Plan type 추가 요청의 건 기존 로직 신규로직 끝
				END;
			  END;
			END TRY

			BEGIN CATCH
			  SET @v_log_type = 'TXN'; -- 오류 발생해도 Plan 작업은 정상 수행되어야 함
			END CATCH;
		END;

        -----------------------------------------------------------
        -- PJ20216891 :  bod_n_v를 테이블로 저장
        -----------------------------------------------------------
        BEGIN TRY
          BEGIN
              EXEC PR_SCP_ANL_BOD_N_V_PLAN_H @v_division_id, @v_plan_name, @p_plan_type, @n_plan_seq;
          END;
        END TRY
        BEGIN CATCH
          SET @v_log_type = 'TXN'; -- 오류 발생해도 Plan 작업은 정상 수행되어야 함
        END CATCH;
		
        -----------------------------------------------------------
        -- Capa Report 용 Prod Plan 정보 생성 : 20240701 PJ20239015 LGES Capa. 관리 시스템 구축
		-- Capa Proc 내에서 월 마지막 목요일이 속한 주차만 수행됨
		-- 20240820 : Capa 사업 계획 처리로 임시로 막음
		-- 20250106 : CPS_BATCH_PROC_RUN lookup 참조하여 생산계획 반영 프로시저 수행
        -----------------------------------------------------------
        IF @p_plan_type IN ('FN') AND @v_division_group NOT IN ('EE')  -- 전극 외
		   AND EXISTS (SELECT 1
						 FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
						WHERE LK.LOOKUP_TYPE	= 'CPS_BATCH_PROC_RUN'
						  AND LK.SEGMENT1		= 'PR_SCP_ENG_CONTROL'					-- 상위 프로시저 : SCP 엔진 Control
						  AND LK.SEGMENT2		= 'PR_SCP_MST_CAPA_PROD_PLAN_APPLY'		-- 하위 프로시저 : 조립팩 SCP 생산계획 반영 
						  AND LK.VALID_YN		= 'Y'
						  AND LK.ATTRIBUTE1		= 'Y'	)								-- 수행여부 
		BEGIN
			BEGIN TRY
			  BEGIN
				EXEC PR_SCP_MST_CAPA_PROD_PLAN_APPLY @P_IS_MANUAL= 'N', @P_DIVISION_ID = @v_division_id ;
			  END;
			END TRY

			BEGIN CATCH
			  SET @v_log_type = 'TXN'; -- 오류 발생해도 Plan 작업은 정상 수행되어야 함
			END CATCH;
        END;

        IF @p_plan_type IN ('FN') AND @v_division_group IN ('EE')  -- 전극 
		   AND EXISTS (SELECT 1
						 FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
						WHERE LK.LOOKUP_TYPE	= 'CPS_BATCH_PROC_RUN'
						  AND LK.SEGMENT1		= 'PR_SCP_ENG_CONTROL'						-- 상위 프로시저 : SCP 엔진 Control
						  AND LK.SEGMENT2		= 'PR_SCP_MST_CAPA_PROD_PLAN_APPLY_ELTR'	-- 하위 프로시저 : 조립팩 SCP 생산계획 반영 
						  AND LK.VALID_YN		= 'Y'
						  AND LK.ATTRIBUTE1		= 'Y'	)									-- 수행여부 
		BEGIN
			BEGIN TRY
			  BEGIN
				EXEC PR_SCP_MST_CAPA_PROD_PLAN_APPLY_ELTR @P_IS_MANUAL= 'N', @P_EE_DIVISION_ID = @v_division_id ;
			  END;
			END TRY

			BEGIN CATCH
			  SET @v_log_type = 'TXN'; -- 오류 발생해도 Plan 작업은 정상 수행되어야 함
			END CATCH;
        END;
		
        -----------------------------------------------------------
        -- 20241107  PJ20249346 ESS 회수포장재 Simulator 정보 생성
        --   오류 발생해도 Plan 작업은 정상 수행되어야 함
        -----------------------------------------------------------
        IF @v_division_id IN ('82')  
		BEGIN
			BEGIN TRY
			  BEGIN
				EXEC PR_SCP_ANL_CELL_Tray_Simulation @v_division_id, @v_plan_name, @p_plan_type;	
			  END;
			END TRY

			BEGIN CATCH
			  SET @v_log_type = 'TXN'; -- 오류 발생해도 Plan 작업은 정상 수행되어야 함
			END CATCH;
		END;

		
        -----------------------------------------------------------
        -- 20220208  PJ20216891  Waterfall 생성 사업부별 수행
        --   오류 발생해도 Plan 작업은 정상 수행되어야 함
        -----------------------------------------------------------
		-- PRODUCTION_PLAN Waterfall
        BEGIN TRY
          BEGIN
              IF @p_plan_type IN ('FN')
		      BEGIN		   
                EXEC PR_SCP_ANL_PRODUCTION_PLAN_CUTOFF    @v_division_id ;
              END; -- IF @p_plan_type IN ('FN')
          END;
        END TRY
        BEGIN CATCH
          SET @v_log_type = 'TXN'; -- 오류 발생해도 Plan 작업은 정상 수행되어야 함
        END CATCH;
		
		-- SHIPMENT_PLAN_FG Waterfall
        BEGIN TRY
          BEGIN
              IF @p_plan_type IN ('FN')
		      BEGIN
                EXEC PR_SCP_ANL_SHIPMENT_PLAN_FG_CUTOFF   @v_division_id ;
              END; -- IF @p_plan_type IN ('FN')
          END;
        END TRY
        BEGIN CATCH
          SET @v_log_type = 'TXN'; -- 오류 발생해도 Plan 작업은 정상 수행되어야 함
        END CATCH;
		
		-- SHIPMENT_PLAN_SEMI Waterfall
        BEGIN TRY
          BEGIN
              IF @p_plan_type IN ('FN')
		      BEGIN
                EXEC PR_SCP_ANL_SHIPMENT_PLAN_SEMI_CUTOFF @v_division_id ;
              END; -- IF @p_plan_type IN ('FN')
          END;
        END TRY
        BEGIN CATCH
          SET @v_log_type = 'TXN'; -- 오류 발생해도 Plan 작업은 정상 수행되어야 함
        END CATCH;
				
        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        SET @v_log_type = 'TXN';
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = 'RUN '+ @v_table_id;
        SET @v_description = 'Process Complete... ' + ' / ' + @v_master_id + ' / ' + @v_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
        IF @@TRANCOUNT > 0
          BEGIN
            COMMIT WORK;
          END;

        _RETURN_ERR_CODE:
        BEGIN
          IF @rows < 0
            BEGIN
              -- ROLLBACK
              -- ERROR LOG
              SET @v_log_type = 'ERROR';
              SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
              SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE())  + ' / ' + @v_master_id + ' / ' + @v_engine_plan_id ;
              SET @d_event_date = SYSDATETIME();
              EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
              -- Plan Detail 정보 Update
              UPDATE /* PR_SCP_ENG_OUT_ALL */
                     scm_mst_plan_detail
              SET    plan_status        = '-1' -- Error 종료
                   , normal_complete_yn = 'N'
                   , last_update_date   = GETDATE()
              WHERE  modeling_id = @p_modeling_id
              AND    division_id = @v_division_id
              AND    plan_id     = @v_plan_id
              AND    plan_seq    = CONVERT(NVARCHAR, @n_plan_seq)        
              AND    plan_type   = @p_plan_type 
              ;
		
              -----------------------------------------------------------
              -- SMS 전송 : Plan ERROR (20)
              -----------------------------------------------------------
              SET @v_sms_desc = @v_master_id + '::' + @p_plan_type;
              EXEC SCM_ADM_SMS_SEND_BATCH 20, @v_sms_desc;
              -----------------------------------------------------------

              RETURN -1
            END; -- IF @rows < 0

        END; -- _RETURN_ERR_CODE:

      END;

    END TRY

    BEGIN CATCH
      -- ROLLBACK
      -- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE()) + ' / ' + @v_master_id + ' / ' + @v_engine_plan_id ;
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
      -- Plan Detail 정보 Update
      UPDATE /* PR_SCP_ENG_OUT_ALL */
             scm_mst_plan_detail
      SET    plan_status        = '-1' -- Error 종료
           , normal_complete_yn = 'N'
           , last_update_date   = GETDATE()
      WHERE  modeling_id = @p_modeling_id
      AND    division_id = @v_division_id
      AND    plan_id     = @v_plan_id
      AND    plan_seq    = CONVERT(NVARCHAR, @n_plan_seq)        
      AND    plan_type   = @p_plan_type 
      ;
		
      -----------------------------------------------------------
      -- SMS 전송 : Plan ERROR (20)
      -----------------------------------------------------------
      SET @v_sms_desc = @v_master_id + '::' + @p_plan_type;
      EXEC SCM_ADM_SMS_SEND_BATCH 20, @v_sms_desc;
      -----------------------------------------------------------

      RETURN -1
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description =  @v_master_id + ' / ' + @v_engine_plan_id ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			
    /**************************************************************
     * 엔진 점검용 BUF 정보 Insert : 2022.06.20 Plan 결과 SMS 추가를 위하여 위치 조정함 
     **************************************************************/
    --EXEC ENG_SCP.DBO.PR_SCP_SUMMARY_REPORT @v_master_id, @v_engine_plan_id, @v_engine_plan_id;
    --EXEC ENG_SCP.DBO.PR_SCP_SUMMARY_REPORT_SALES @v_master_id, @v_engine_plan_id, @v_engine_plan_id;

    -----------------------------------------------------------
    -- 운영 : '1'   개발 : '2'
    -----------------------------------------------------------

    SELECT @X_DB_NAME = DB_NAME();

	-- 운영 : '1'   개발 : '2'
    SET @v_DB_NAME = '2';

    IF @X_DB_NAME = 'LGCE_SCMPROD'  
        SET @v_DB_NAME = '1';

	SELECT @v_ENG_NWDRIVE_CNT = COUNT(B.VALUE)
	  FROM ENG_SCP.dbo.TH_ENG_PLAN_INFO A WITH(NOLOCK)
	  JOIN ENG_SCP.dbo.TH_CFG_CONFIG_VALUE B WITH(NOLOCK)
		ON A.CONFIG_SET_ID = B.CONFIG_SET_ID
	 WHERE A.MASTER_ID = @v_master_id
	   AND A.PLAN_ID   = @v_engine_plan_id
	   AND B.KEY_ID    = 'BULK_WRITE_METHOD'
	   AND B.VALUE     = 'NW_DRIVE'
	;
    
	--NW_DRIVE 방식 저장시에만, 호출, 2022.06.15 추가    
	IF @v_ENG_NWDRIVE_CNT > 0 

		BEGIN
			EXEC ENG_SCP.DBO.PR_SCP_BUF_BULK_INSERT @v_master_id, @v_engine_plan_id, @v_engine_plan_id, @v_DB_NAME;
		END		
    /**************************************************************
     * 엔진 점검용 BUF 정보 Insert : END
     **************************************************************/

    RETURN 1

  END;

