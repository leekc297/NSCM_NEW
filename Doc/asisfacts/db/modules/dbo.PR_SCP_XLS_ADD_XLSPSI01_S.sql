
/*
 * Program ID   : PR_SCP_XLS_ADD_XLSPSI01_S
 * Description  : SCP SIMULATION SAVE
 * OutTable     :
 * Execute      : 			
              EXEC PR_SCP_XLS_ADD_XLSPSI01_S      @p_USER_ID             ='KSK'
                                                 ,@p_division_id         = '81'
                                                 ,@p_PLAN_START_YYYYMMDD = '20230731'
                                                 ,@p_PLAN_TYPE           ='PR'
                                                 ,@p_SEQ                 ='3'
                                                 ,@p_item_id             ='APFCAPHEV-B2'
                                                 ,@p_measure             ='PACK_MODEL_CHANGE'
                                                 ,@p_xls_key1            ='5849'
												 ,@p_create_from_yyyymmdd = '20230731'
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
 * 2019.01.21   KTH            Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2019.01.31   KTH            SCP_ANL_PRODUCTION_PLAN 저장로직 반영
 * 2019.02.11   KTH            SCP_ANL_SHIPMENT_PLAN_SEMI 저장로직 반영
 * 2019.02.12   KTH            SCP_ANL_SHIPMENT_PLAN_FG 저장로직 반영, 
                               LINE_TOTAL_LOAD_ENGINE UPDATE 반영
 * 2019.02.15   KTH            'FN' 일 경우 저장 되지 않도록 수정 
 * 2019.03.05   KTH            HISTORY 테이블 반영, @p_user_id 구분 하도록 수정
 * 2019.04.03   KTH            WEEK 로직 반영
 * 2019.04.08   KTH            LINE LOAD율 수정
 * 2019.05.02   KTH            출하계획 수정시 특정 요일에 저장(@x_DAYOFWEEK_NO) 1~7(일~토)
 * 2019.05.08   KTH            수정된 DATA 외에는 특정 요일 반영 금지로직 추가
 * 2019.05.24   KTH            FROZEN 구간 DATA 미반영 로직 추가
 * 2019.05.30   KTH            FROZEN 구간 'SE'추가
 * 2019.06.03   KTH            저장후 시물레이션 데이터 UPDATE 로직 변경
 * 2019.06.05   KTH            출하(FG/SEMI) FROZEN DATA 미반영 구간 'PR'추가
 * 2019.06.12   KTH            Line Load율 로직 변경
 * 2019.06.14   KTH            생산 FROZEN 구간 MA(-7)로직 제거
 * 2019.07.06   KTH            입력된 버전과 현재 버전이 다를 경우 RETURN  
 * 2020.04.08   KTH            SCP_ANL_SHIPMENT_PLAN_FIX(FG) 변경조건 추가 (PROJECT_CODE)
 * 2020.07.21   KSW            항차를 고려한 출하계획 저장로직 개발 (L/T를 고려한 요일별 분배)
 * 2020.09.02   KSW            항차를 고려한 출하계획 저장로직 개발 (L/T를 고려한 요일별 분배) ==> 트럭(TRK) 제외
 * 2020.10.16   KSW            C20201016-000200 :: GSCM 시스템의 RTF 적확도 개선을 위한 SSP구간 Shipment 수량 변경 기능 요청 건
                               SHIP_PLAN 저장시 Frozen 구간 체크하지 않음 (PR, MA plan 한함)
 * 2020.10.28   KSW            C20201019-000175   SCP-FP 협의사항 수정반영 요청 (화 → 수) - 자동차(81) 사업부의 경우 Final Plan 제외하고 전 구간 생산계획 수정 가능
 * 2021.03.17   KSW            temp table 일괄 drop 스크립트 추가
 * 2021.04.13   KSW            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 출하계획(SHIP_PLAN) 저장 - 자동차 Partial Week 저장방식 추가 
                               :: Balance(WH In) Measure 값이 0 일 경우 월요일에 입력된 수량전체를 배분한다.
 * 2021.05.24   KSW            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - 저장방식을 1 year 단위로 저장
 * 2021.08.11   KSW            PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - 형교환 적용
 * 2021.08.19   KSW            PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
 * 2021.10.25   KSW            튜닝개선요청에 따른 변경
 * 2021.12.06   KSW            SEMI SHIP PLAN 에 대한 PR/MA Frozen 구간해제
 * 2022.03.21   KSW		       GM JV 반영
 * 2022.06.27   KSW			   출하 수량을 항차별 n/1 --> 출하 Lot Size 를 고려한 출하수량 배분으로 변경
 * 2022.09.19   KSW			   생산계획(PACK_PROD, CELL_PROD) 일배분로직 변경 - 1/7 에서 워킹타임(CAPA 로스타임을 고려한) 비율로 변경
 * 2023.01.13	 KKH			   시뮬레이터 저장 후 숫자 변경 오류 (배분 로직 수정 weekly 11 -> 12로 출력되는 현상)
 * 2023.05.03	 KSK		[PJ20230691  SCM 역량 강화 위한 SCP 개선과제 이행] UI / Simulator에서  SE 단계에서 Frozen 구간 수정 불가
 * 2023.08.24	 KSK		[PJ20230691] SCM 역량 강화 위한 SCP 개선과제 이행 (52주차 초과플랜의  SHIPMENT FG 파샬위크 SPLIT 저장로직 반영)
 * 2023.10.23   OIJ			   전달 변수를 지역변수로 변경하여 사용하도록 수정
 * 2023.10.23   OIJ			   IF @v_batch_measure IN  ('PACK_PROD', 'CELL_PROD') 연산 방식 수정(update -> select + insert)
 * 2023.11.07   OIJ			   IF @v_batch_measure IN  ('PACK_MODEL_CHANGE','CELL_MODEL_CHANGE') 인덱스활용하도록 수정
 * 2023.11.07   OIJ			   IF @v_batch_measure IN  ('SHIP_PLAN','SEMI_SHIP_PLAN')  연산 방식 수정(update -> select + insert)
 * 2023.12.26	 KSK		[PJ20230692] SCM 역량 강화 위한 SCP 개선과제 이행2 ( SHIP_PLAN 및 SEMI_SHIP_PLAN 일분배 로직 시뮬레이터로 이동)
 * 2024.09.03    KSK	    구문오류방지 위해 formatMessage에서 xls_key1갑을 위해  %d 사용 및 	입력파라미터가  아닌 지역변수 @p_to_yyyymmdd의 삭제 
 * 2024.09.03    KSK	    프로시저 종료시 로그이력에 1년차 xls_key1 대신에 현재 저장되는 데이터의  xls_key1 기록
 * 2024.04.17	 KSK		      디버그 파라미터(@p_is_debug) 추가 및 디버그 메세지 추가
 * 2025.12.09    HRK		[PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인에 매핑된 JV CELL 생산계획 수정인 경우 SKIP처리 (ESS->JV 단방향 동기화 반영) 
 */

CREATE PROCEDURE [dbo].[PR_SCP_XLS_ADD_XLSPSI01_S]
( 
	@p_user_id					VARCHAR(100)
	--,@P_GUBUN                 VARCHAR(040)       -- MEASURE  @P_GUBUN  PACK / CELL / SUPPLY 
	,@p_division_id				NVARCHAR(030)
	,@p_plan_start_yyyymmdd		NVARCHAR(008)
	,@p_plan_type	            NVARCHAR(050)
	,@p_seq						BIGINT
	,@p_item_id					NVARCHAR(050)
	,@p_measure					NVARCHAR(050)       -- MEASURE별
	,@p_xls_key1	            NVARCHAR(200)
	,@p_create_from_yyyymmdd    NVARCHAR(008)
	,@p_create_to_yyyymmdd      NVARCHAR(008)

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
	-- 2021.04.13   KSW            출하계획(SHIP_PLAN) 저장 - 자동차 Partial Week 저장방식 추가 :: Balance(WH In) Measure 값이 0 일 경우 월요일에 입력된 수량전체를 배분한다. - start
	-- Week 플랜구간에 대한 Partial week 정보를 입력값으로 받는다. 'Y' : 시뮬레이터에서 Partial Week 경계선 다음날, 'N' : Partial Week 경계선 다음날이 아닌 경우
	-- 2021.04.13   KSW            출하계획(SHIP_PLAN) 저장 - 자동차 Partial Week 저장방식 추가 :: Balance(WH In) Measure 값이 0 일 경우 월요일에 입력된 수량전체를 배분한다. - end
	,@p_partial	                NVARCHAR(120)	 -- PatialWeekYN
	,@p_dailyQty				nvarchar(MAX) = '' --일간수량정보(콤마)
	,@p_is_debug				bit = 0			-- 0: RELEASE (KSK, 250417)
 )                                     
AS        
 
BEGIN	
	--SELECT N'파라미터' tn,  @p_dailyQty, @P_WQTY01,@P_WQTY02,@P_WQTY03,@P_WQTY04,@P_WQTY05,@P_WQTY06,@P_WQTY07,@P_WQTY08,@P_WQTY09,@P_WQTY10,@P_WQTY11,@P_WQTY12,@P_WQTY13,@P_WQTY14,@P_WQTY15,@P_WQTY16,@P_WQTY17,@P_WQTY18,@P_WQTY19,@P_WQTY20,@P_WQTY21,@P_WQTY22,@P_WQTY23,@P_WQTY24,@P_WQTY25,@P_WQTY26,@P_WQTY27,@P_WQTY28,@P_WQTY29,@P_WQTY30,@P_WQTY31,@P_WQTY32,@P_WQTY33,@P_WQTY34,@P_WQTY35,@P_WQTY36,@P_WQTY37,@P_WQTY38,@P_WQTY39,@P_WQTY40,@P_WQTY41,@P_WQTY42,@P_WQTY43,@P_WQTY44,@P_WQTY45,@P_WQTY46,@P_WQTY47,@P_WQTY48,@P_WQTY49,@P_WQTY50,@P_WQTY51,@P_WQTY52--TEST
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

	--파라미터 변수 선언
	DECLARE @v_company_id   NVARCHAR(100) = N'';   
	DECLARE @v_batch_user   NVARCHAR(150) = N'';  
	DECLARE @v_batch_division_id   NVARCHAR(30) = N'';  
	DECLARE @v_batch_plan_start_yyyymmdd   NVARCHAR(8) = N'';  
	DECLARE @v_batch_plan_type   NVARCHAR(8) = N'';  
	DECLARE @v_batch_seq   BIGINT;  
	DECLARE @v_batch_item_id   NVARCHAR(50) = N'';  
	DECLARE @v_batch_measure					NVARCHAR(50);       
	DECLARE @v_batch_xls_key1	            INT;
	DECLARE @v_batch_create_from_yyyymmdd    NVARCHAR(8);
	DECLARE @v_batch_create_to_yyyymmdd      NVARCHAR(8);
	DECLARE @v_batch_partial	                NVARCHAR(120)

	SET @v_batch_user = @p_user_id
    SET @v_batch_division_id = @p_division_id
    SET @v_batch_plan_start_yyyymmdd = @p_plan_start_yyyymmdd
    SET @v_batch_plan_type = @p_plan_type
    SET @v_batch_seq = @p_seq
	SET @v_batch_item_id = @p_item_id
	SET @v_batch_measure = @p_measure
	SET @v_batch_xls_key1 = CAST(@p_xls_key1 AS INT) -- 전달된 XLS_KEY1
	SET @v_batch_create_from_yyyymmdd  = @p_create_from_yyyymmdd
	SET @v_batch_create_to_yyyymmdd  = @p_create_to_yyyymmdd
	SET @v_batch_partial = @p_partial

    -- LOG 용 변수 설정
	DECLARE @v_batch_user_sim   NVARCHAR(150) = N'';  
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_XLS_ADD_XLSPSI01_S';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);     
    DECLARE @v_table_id     NVARCHAR(150) = N'SCP_XLS_PSI_GLOBAL'; 
    DECLARE @d_event_date   DATETIME;



    -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SCP_XLS_PSI_GLOBAL SAVE LOGIC';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                              ,@p_log_type      = @v_log_type
                              ,@p_log_count     = @n_log_count 
                              ,@p_log_message   = @v_log_message 
                              ,@p_description   = @v_description 
                              ,@p_event_date    = @d_event_date 
                              ,@p_user_id       = @v_batch_user
	/* 반영보류(KSK)
							  , @p_attribute1 = @p_division_id
                              ;
	*/
    
    
    -- 임시 실행시간 확인용                
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();                
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';     

	

    --PRINT @v_batch_plan_type
    --PLAN_TYPE이 FN일경우 수정금지 RETURN
    if @v_batch_plan_type = 'FN'            
      return -1   

	---------------------------------------------------------------------------------------------------------------------------------------------------------------- 
	--### Start : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인에 매핑된 JV CELL 생산계획 수정인 경우 SKIP처리 (ESS->JV 단방향 동기화 반영)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------- 
	print  convert(varchar(30), getdate(), 121) + N' JV/ESS 라인 및 scm site 매핑 정보 추출' 
	----------------------------------------------------------------------------------------------------------------------------------------------------------------
	IF EXISTS (SELECT 'X'
				 FROM SCP_XLS_PSI_GLOBAL XL WITH (NOLOCK) -- PK : DIVISION_ID, CREATE_FROM_YYYYMMDD, XLS_KEY1
					  INNER JOIN FN_GET_JV_REAL_ESS_VIRTUAL_SITE_MAP() SM
							  ON SM.RP_DIVISION_ID	= XL.DIVISION_ID
							 AND SM.RP_SCM_SITE_ID	= XL.FROM_SITE
					  INNER JOIN FN_GET_JV_REAL_ESS_VIRTUAL_LINE_MAP() LM 
							  ON LM.RL_DIVISION_ID	= SM.RP_DIVISION_ID
							 AND LM.RL_COMPANY_ID	= SM.RP_COMPANY_ID
							 AND LM.RL_SITE_ID		= SM.RP_SITE_ID
							 AND LM.RL_PLANT_ID		= SM.RP_PLANT_ID
							 AND LM.RL_LINE_ID		= XL.PROD_LINE 
				WHERE 1=1
				  AND XL.DIVISION_ID			= @v_batch_division_id
				  AND XL.CREATE_FROM_YYYYMMDD	= @v_batch_create_from_yyyymmdd
				  AND XL.XLS_KEY1				= @v_batch_xls_key1
				  AND XL.PLAN_START_YYYYMMDD	= @v_batch_plan_start_yyyymmdd
				  AND XL.PLAN_TYPE				= @v_batch_plan_type
				  AND XL.SEQ					= @v_batch_seq
				  AND XL.MEASURE				= 'CELL_PROD')
		BEGIN
			-- 종료 LOG 남기고 return 
			SET @v_log_type = N'END';
			SET @v_log_message = N'########## END of procedure ##########';
			SET @v_description = N'['+@v_batch_division_id+']['+@v_batch_plan_start_yyyymmdd+']['+@v_batch_measure+']['+str(@v_batch_xls_key1)+N'][ESS 가상 라인 매핑]';         
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
									  ,@p_log_type      = @v_log_type
									  ,@p_log_count     = @n_log_count 
									  ,@p_log_message   = @v_log_message 
									  ,@p_description   = @v_description 
									  ,@p_event_date    = @d_event_date 
									  ,@p_user_id       = @v_batch_user
									  ;
			RETURN -1 -- 저장 SKIP 
		END 
	---------------------------------------------------------------------------------------------------------------------------------------------------------------- 
	--### End : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인에 매핑된 JV CELL 생산계획 수정인 경우 SKIP처리 (ESS->JV 단방향 동기화 반영)
	---------------------------------------------------------------------------------------------------------------------------------------------------------------- 

    ---------------------------------------------------------------------------------------------------------------------------------------------------------         
    ---- 입력된 버전과 현재 버전이 다를 경우 RETURN 
    ---------------------------------------------------------------------------------------------------------------------------------------------------------
    --    DECLARE   @v_division_id          NVARCHAR(030) = @v_batch_division_id
    --            , @v_plan_start_yyyymmdd  NVARCHAR(008) = @p_plan_start_yyyymmdd
    --            , @v_plan_type            NVARCHAR(050) = @v_batch_plan_type
    --            , @v_seq                  INT           = @v_batch_seq

    --    SELECT TOP 1  @v_division_id          = DIVISION_ID
    --                , @v_plan_start_yyyymmdd  = PLAN_START_YYYYMMDD
    --                , @v_plan_type            = PLAN_TYPE
    --                , @v_seq                  = SEQ
    --      FROM SCP_XLS_PSI_GLOBAL WITH (NOLOCK)

    --  IF (@v_batch_division_id <> @v_division_id OR @p_plan_start_yyyymmdd <> @v_plan_start_yyyymmdd OR @v_batch_plan_type <> @v_plan_type OR @v_batch_seq <> @v_seq)  
    --    return -1   
    ---------------------------------------------------------------------------------------------------------------------------------------------------------



    --PRINT @v_batch_plan_type
    BEGIN TRY
		BEGIN         

			IF  @p_is_debug = 1 
			BEGIN 
				SELECT  @p_dailyQty AS "@p_dailyQty1"
			END
            
            ---------------------------------------------------------------------------------------------------------------         
            ---- SCM_ADM_LOOKUP_MASTER_DETAIL.LOOKUP_TYPE  ='DAYOFWEEK_NO' 
            ---- 저장할 요일 (월,화,수,목,금,토,일:2,3,4,5,6,7,1), 8이상은 일배분
            --------------------------------------------------------------------------------------------------------------- 
            --DECLARE @x_DAYOFWEEK_NO INT          =  8 --(1~7) 8은 일별배분 (월,화,수,목,금,토,일:2,3,4,5,6,7,1)

            ----SELECT SEGMENT1, SEGMENT2,DESCRIPTION
            --SELECT TOP 1 @x_DAYOFWEEK_NO = ISNULL(SEGMENT2,8) 
            --  FROM dbo.SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK)  
            -- WHERE LOOKUP_TYPE  ='SHIP_PLAN_SAVE_WEEK'--'DAYOFWEEK_NO'
            --   AND SEGMENT1     = @v_batch_division_id -- DIVISION_ID
            --   AND VALID_YN ='Y' 

            --   -- 선택된 항목만 주로 변경해야 하기 때문에 반영하지 않도록 수정 2019.05.07
            --   --SET @x_DAYOFWEEK_NO = '8'
            
            --DECLARE @v_batch_create_to_yyyymmdd  VARCHAR(8)   =  CONVERT(VARCHAR(8), DATEADD(day, 364, @p_plan_start_yyyymmdd), 112)

            ---------------------------------------------------------------------------------------------------------------         
            ---- FROZEN 구간 대상 DATA 생성
            ---------------------------------------------------------------------------------------------------------------         
            --IF OBJECT_ID('tempdb..#SCM_MST_SITE') IS NOT NULL	
	           --   DROP TABLE #SCM_MST_SITE

            --      SELECT 
            --             S.DIVISION_ID
	           --           ,S.PLANT_ID
	           --           ,S.OPERATION_GROUP
	           --           ,S.SCM_SITE_ID 
	           --           ,S.SHIP_FROZEN
            --            ,(S.SHIP_FROZEN/7 + (CASE WHEN SHIP_FROZEN%7 > 0 THEN 1 ELSE 0 END)) AS SHIP_FROZEN_WEEK
            --            ,CONVERT(NVARCHAR(8),  DATEADD(WEEK, (S.SHIP_FROZEN/7 + (CASE WHEN SHIP_FROZEN%7 > 0 THEN 1 ELSE 0 END)), @v_batch_plan_start_yyyymmdd), 112)  AS SHIP_FROZEN_WEEK_DAY
	           --           ,S.PROD_FROZEN
            --            ,(S.PROD_FROZEN/7 + (CASE WHEN PROD_FROZEN%7 > 0 THEN 1 ELSE 0 END)) AS PROD_FROZEN_WEEK
            --            ,CONVERT(NVARCHAR(8),  DATEADD(WEEK, (S.PROD_FROZEN/7 + (CASE WHEN PROD_FROZEN%7 > 0 THEN 1 ELSE 0 END)), @v_batch_plan_start_yyyymmdd), 112)  AS PROD_FROZEN_WEEK_DAY
            --            ,CONVERT(NVARCHAR(8),  DATEADD(WEEK, ( (CASE WHEN ((S.PROD_FROZEN -7) > 0) THEN (S.PROD_FROZEN -7) ELSE 0 END) /7 + (CASE WHEN (CASE WHEN ((S.PROD_FROZEN -7) > 0) THEN (S.PROD_FROZEN -7) ELSE 0 END)%7 > 0 THEN 1 ELSE 0 END)), @v_batch_plan_start_yyyymmdd), 112)  AS PROD_FROZEN_WEEK_DAY_MA
	           --           ,S.FP_PLAN_PERIOD		
	           --           ,S.VALID_YN
	           --           ,S.NEW_YN
	           --           ,S.COMPANY_ID
	           --           ,S.LOGISTIC_PLANT_ID
	           --           ,S.PACKER_ITEM_ID_SUFFIX
            --        INTO #SCM_MST_SITE 
            --        FROM SCM_MST_SITE S WITH (NOLOCK)
            --        WHERE S.SITE_TYPE   = 'PLANT'
            --          AND S.VALID_YN    = 'Y'
            --          AND S.DIVISION_ID = @v_batch_division_id
            --          ;

			DECLARE @SQL      NVARCHAR(MAX);
			--SELECT 	@v_batch_create_from_yyyymmdd AS "@v_batch_create_from_yyyymmdd",   @v_batch_create_to_yyyymmdd AS "@v_batch_create_to_yyyymmdd"--TEST

			-- XLS_KEY1 불일치 오류수정 - KSW 2021.08.30 - start
			-- 30 주 (중장기구간) 에 대한 XLS_KEY1 값 재확인
			IF ( @v_batch_plan_start_yyyymmdd <> @v_batch_create_from_yyyymmdd )
			BEGIN				
				SELECT N'XLS_KEY1 불일치 발견' MSG, @v_batch_plan_start_yyyymmdd "@v_batch_plan_start_yyyymmdd", @v_batch_create_from_yyyymmdd "@v_batch_create_from_yyyymmdd"

				DECLARE @v_link_xls_key1	              NVARCHAR(200) = '';

				SELECT @v_link_xls_key1 = Y.XLS_KEY1
				  FROM (
						SELECT *
						  FROM SCP_XLS_PSI_GLOBAL WITH (NOLOCK)
						 WHERE PLAN_START_YYYYMMDD  = @v_batch_plan_start_yyyymmdd
						   AND PLAN_TYPE            = @v_batch_plan_type
						   AND SEQ                  = @v_batch_seq
						   AND CREATE_FROM_YYYYMMDD = @v_batch_plan_start_yyyymmdd
						   AND DIVISION_ID          = @v_batch_division_id			-- 2022.03.21   KSW		       GM JV 반영
						   AND XLS_KEY1             = @v_batch_xls_key1
					   ) X, SCP_XLS_PSI_GLOBAL Y WITH (NOLOCK)
				 WHERE Y.PLAN_START_YYYYMMDD = X.PLAN_START_YYYYMMDD
				   AND Y.PLAN_TYPE           = X.PLAN_TYPE
				   AND Y.SEQ                 = X.SEQ
				   AND Y.CREATE_FROM_YYYYMMDD = @v_batch_create_from_yyyymmdd
				   AND Y.DIVISION_ID         = X.DIVISION_ID			-- 2022.03.21   KSW		       GM JV 반영
				   AND Y.OPERATION_GROUP     = X.OPERATION_GROUP
				   AND Y.CELL_ITEM_ID        = X.CELL_ITEM_ID
				   AND Y.ITEM_ID             = X.ITEM_ID
				   AND Y.TO_SITE             = X.TO_SITE
				   AND Y.PROJECT_CODE        = X.PROJECT_CODE
				   AND Y.INCOTERMS           = X.INCOTERMS
				   AND Y.FROM_SITE           = X.FROM_SITE
				   AND Y.TRANSPORT_MODE      = X.TRANSPORT_MODE
				   AND Y.PROD_LINE           = X.PROD_LINE
				   AND Y.BOD_ID              = X.BOD_ID
				   AND Y.MEASURE             = X.MEASURE
				   ;

				SET @v_batch_xls_key1 = @v_link_xls_key1;

				--SELECT @v_batch_xls_key1   "수정된 XLS_KEY1 ", @p_xls_key1 AS "원래 XLS_KEY1"--TEST

			END
			-- XLS_KEY1 불일치 오류수정 - KSW 2021.08.30 - end

			-- 일분배 로직을 시뮬레이터로 이동하여 코드 간소화 및 속도개선효과 도모(KSK, 2024-04-29)
			IF @v_batch_measure IN  ('SHIP_PLAN','SEMI_SHIP_PLAN')   
            BEGIN 

				DECLARE @v_bod_from				NVARCHAR(12) = '';
				DECLARE @v_bod_to				NVARCHAR(12) = '';

				SELECT @v_bod_from = (CASE WHEN ATTRIBUTE3 IS NULL THEN '19900101' 
										   ELSE LEFT(ATTRIBUTE3, 8) END)
					  ,@v_bod_to   = (CASE WHEN ATTRIBUTE3 IS NULL THEN '29991231' 
										   ELSE RIGHT(ATTRIBUTE3, 8) END)
				  FROM SCP_XLS_PSI_GLOBAL WITH (NOLOCK)
				 WHERE 0 = 0 --1024추가
				   AND DIVISION_ID          = @v_batch_division_id
				   AND CREATE_FROM_YYYYMMDD = @v_batch_create_from_yyyymmdd
				   AND XLS_KEY1             = @v_batch_xls_key1       
				;

				--SELECT @v_bod_from AS "@v_bod_from", @v_bod_to AS "@v_bod_to"--TEST

				
				update SCP_XLS_PSI_GLOBAL
				  SET		
						  WQTY01 =  CASE WHEN @p_WQTY01 = -9 THEN WQTY01 ELSE @p_WQTY01 END
						, WQTY02 =  CASE WHEN @p_WQTY02 = -9 THEN WQTY02 ELSE @p_WQTY02 END
						, WQTY03 =  CASE WHEN @p_WQTY03 = -9 THEN WQTY03 ELSE @p_WQTY03 END
						, WQTY04 =  CASE WHEN @p_WQTY04 = -9 THEN WQTY04 ELSE @p_WQTY04 END
						, WQTY05 =  CASE WHEN @p_WQTY05 = -9 THEN WQTY05 ELSE @p_WQTY05 END
						, WQTY06 =  CASE WHEN @p_WQTY06 = -9 THEN WQTY06 ELSE @p_WQTY06 END
						, WQTY07 =  CASE WHEN @p_WQTY07 = -9 THEN WQTY07 ELSE @p_WQTY07 END
						, WQTY08 =  CASE WHEN @p_WQTY08 = -9 THEN WQTY08 ELSE @p_WQTY08 END
						, WQTY09 =  CASE WHEN @p_WQTY09 = -9 THEN WQTY09 ELSE @p_WQTY09 END
						, WQTY10 =  CASE WHEN @p_WQTY10 = -9 THEN WQTY10 ELSE @p_WQTY10 END
						, WQTY11 =  CASE WHEN @p_WQTY11 = -9 THEN WQTY11 ELSE @p_WQTY11 END
						, WQTY12 =  CASE WHEN @p_WQTY12 = -9 THEN WQTY12 ELSE @p_WQTY12 END
						, WQTY13 =  CASE WHEN @p_WQTY13 = -9 THEN WQTY13 ELSE @p_WQTY13 END
						, WQTY14 =  CASE WHEN @p_WQTY14 = -9 THEN WQTY14 ELSE @p_WQTY14 END
						, WQTY15 =  CASE WHEN @p_WQTY15 = -9 THEN WQTY15 ELSE @p_WQTY15 END
						, WQTY16 =  CASE WHEN @p_WQTY16 = -9 THEN WQTY16 ELSE @p_WQTY16 END
						, WQTY17 =  CASE WHEN @p_WQTY17 = -9 THEN WQTY17 ELSE @p_WQTY17 END
						, WQTY18 =  CASE WHEN @p_WQTY18 = -9 THEN WQTY18 ELSE @p_WQTY18 END
						, WQTY19 =  CASE WHEN @p_WQTY19 = -9 THEN WQTY19 ELSE @p_WQTY19 END
						, WQTY20 =  CASE WHEN @p_WQTY20 = -9 THEN WQTY20 ELSE @p_WQTY20 END
						, WQTY21 =  CASE WHEN @p_WQTY21 = -9 THEN WQTY21 ELSE @p_WQTY21 END
						, WQTY22 =  CASE WHEN @p_WQTY22 = -9 THEN WQTY22 ELSE @p_WQTY22 END
						, WQTY23 =  CASE WHEN @p_WQTY23 = -9 THEN WQTY23 ELSE @p_WQTY23 END
						, WQTY24 =  CASE WHEN @p_WQTY24 = -9 THEN WQTY24 ELSE @p_WQTY24 END
						, WQTY25 =  CASE WHEN @p_WQTY25 = -9 THEN WQTY25 ELSE @p_WQTY25 END
						, WQTY26 =  CASE WHEN @p_WQTY26 = -9 THEN WQTY26 ELSE @p_WQTY26 END
						, WQTY27 =  CASE WHEN @p_WQTY27 = -9 THEN WQTY27 ELSE @p_WQTY27 END
						, WQTY28 =  CASE WHEN @p_WQTY28 = -9 THEN WQTY28 ELSE @p_WQTY28 END
						, WQTY29 =  CASE WHEN @p_WQTY29 = -9 THEN WQTY29 ELSE @p_WQTY29 END
						, WQTY30 =  CASE WHEN @p_WQTY30 = -9 THEN WQTY30 ELSE @p_WQTY30 END
						, WQTY31 =  CASE WHEN @p_WQTY31 = -9 THEN WQTY31 ELSE @p_WQTY31 END
						, WQTY32 =  CASE WHEN @p_WQTY32 = -9 THEN WQTY32 ELSE @p_WQTY32 END
						, WQTY33 =  CASE WHEN @p_WQTY33 = -9 THEN WQTY33 ELSE @p_WQTY33 END
						, WQTY34 =  CASE WHEN @p_WQTY34 = -9 THEN WQTY34 ELSE @p_WQTY34 END
						, WQTY35 =  CASE WHEN @p_WQTY35 = -9 THEN WQTY35 ELSE @p_WQTY35 END
						, WQTY36 =  CASE WHEN @p_WQTY36 = -9 THEN WQTY36 ELSE @p_WQTY36 END
						, WQTY37 =  CASE WHEN @p_WQTY37 = -9 THEN WQTY37 ELSE @p_WQTY37 END
						, WQTY38 =  CASE WHEN @p_WQTY38 = -9 THEN WQTY38 ELSE @p_WQTY38 END
						, WQTY39 =  CASE WHEN @p_WQTY39 = -9 THEN WQTY39 ELSE @p_WQTY39 END
						, WQTY40 =  CASE WHEN @p_WQTY40 = -9 THEN WQTY40 ELSE @p_WQTY40 END
						, WQTY41 =  CASE WHEN @p_WQTY41 = -9 THEN WQTY41 ELSE @p_WQTY41 END
						, WQTY42 =  CASE WHEN @p_WQTY42 = -9 THEN WQTY42 ELSE @p_WQTY42 END
						, WQTY43 =  CASE WHEN @p_WQTY43 = -9 THEN WQTY43 ELSE @p_WQTY43 END
						, WQTY44 =  CASE WHEN @p_WQTY44 = -9 THEN WQTY44 ELSE @p_WQTY44 END
						, WQTY45 =  CASE WHEN @p_WQTY45 = -9 THEN WQTY45 ELSE @p_WQTY45 END
						, WQTY46 =  CASE WHEN @p_WQTY46 = -9 THEN WQTY46 ELSE @p_WQTY46 END
						, WQTY47 =  CASE WHEN @p_WQTY47 = -9 THEN WQTY47 ELSE @p_WQTY47 END
						, WQTY48 =  CASE WHEN @p_WQTY48 = -9 THEN WQTY48 ELSE @p_WQTY48 END
						, WQTY49 =  CASE WHEN @p_WQTY49 = -9 THEN WQTY49 ELSE @p_WQTY49 END
						, WQTY50 =  CASE WHEN @p_WQTY50 = -9 THEN WQTY50 ELSE @p_WQTY50 END
						, WQTY51 =  CASE WHEN @p_WQTY51 = -9 THEN WQTY51 ELSE @p_WQTY51 END
						, WQTY52 =  CASE WHEN @p_WQTY52 = -9 THEN WQTY52 ELSE @p_WQTY52 END
						   ,LAST_UPDATED_BY    = @v_batch_user
                            ,LAST_UPDATE_DATE   = GETDATE()
			  WHERE  DIVISION_ID          = @v_batch_division_id
			  	 AND  XLS_KEY1             = @v_batch_xls_key1  		
				  AND CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd				;	
			
			  if  ISNULL(@p_dailyQty, '') <> '' 
			  begin
				set @sql = 'update SCP_XLS_PSI_GLOBAL ' + CHAR(10)
				set @sql =@SQL + ' SET ' +  @p_dailyQty + CHAR(10)
				set @sql =@SQL + FORMATMESSAGE(' WHERE DIVISION_ID = ''%s''', @v_batch_division_id) + CHAR(10)
				set @sql =@SQL + FORMATMESSAGE(' AND XLS_KEY1 = %d ', @v_batch_xls_key1) + CHAR(10)  --구문 오류 회피(KSK)
				set @sql =@SQL + FORMATMESSAGE(' AND CREATE_FROM_YYYYMMDD = ''%s''', @p_create_from_yyyymmdd) + CHAR(10)		
                
				
				IF @P_IS_DEBUG = 1 SELECT @SQL AS "SQL"
				 
				exec (@sql)			
			   end

			 END

			 --SELECT 'GLOBAL PSI SAVED' TN,  * FROM  SCP_XLS_PSI_GLOBAL WITH (NOLOCK) WHERE  DIVISION_ID  = @v_batch_division_id AND  XLS_KEY1 = @v_batch_xls_key1 AND CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd --TEST				
			 

			
		--PRINT 	'@v_batch_measure2  ' + @v_batch_measure

			-- 2022.09.19 생산계획(PACK_PROD, CELL_PROD) 일배분로직 변경 - 1/7 에서 워킹타임(CAPA 로스타임을 고려한) 비율로 변경
			IF @v_batch_measure IN  ('PACK_PROD', 'CELL_PROD')
			BEGIN
				----------------------------------
				-- Working Time 에 따른 daily 분배
				----------------------------------
				DECLARE @v_prod_line_id  NVARCHAR(12) = '';
				DECLARE @v_scm_site      NVARCHAR(12) = '';
				DECLARE @v_operation	 NVARCHAR(12) = '';
				DECLARE @v_wkcnt         INT = 0;

				-- 라인정보 조회
				SELECT  @v_prod_line_id = PROD_LINE
					   ,@v_scm_site     = FROM_SITE
					   ,@v_operation	= ATTRIBUTE9
				FROM SCP_XLS_PSI_GLOBAL     WITH (NOLOCK) 
				WHERE 0 = 0
				AND DIVISION_ID          = @v_batch_division_id
				AND PLAN_START_YYYYMMDD  = @v_batch_plan_start_yyyymmdd
				AND CREATE_FROM_YYYYMMDD = @v_batch_create_from_yyyymmdd
				AND SEQ                  = @v_batch_seq
				AND XLS_KEY1             = @v_batch_xls_key1 
				;

				--select @v_prod_line_id, @v_scm_site;
				;
					
	            --PRINT 'start. '+CONVERT(CHAR(23), GETDATE(), 21);

				-- Working Time 정보 가져오기 :: 364일
				IF OBJECT_ID('tempdb..#WORKING_TBL_TEMP') IS NOT NULL	
					DROP TABLE #WORKING_TBL_TEMP

				IF OBJECT_ID('tempdb..#WORKING_TBL') IS NOT NULL	
					DROP TABLE #WORKING_TBL;

				CREATE TABLE #WORKING_TBL_TEMP (
					ROWNUM INT, XLS_KEY INT, YYYYMMDD NVARCHAR(010), WORKING_TIME NUMERIC(20,10), QTY NUMERIC(20,10)
				);
				------------------------------------------
				-- 생산계획 저장로직
				------------------------------------------
				-- CAPA 워킹타임 AVAILABLE 값을 가져오기 위한 처리
				DECLARE @WORK_AVALIABLE TABLE (YYYYMMDD NVARCHAR(8), G_VALUE INT, A_VALUE INT, B_VALUE INT, C_VALUE INT);

				INSERT @WORK_AVALIABLE EXEC PR_SCP_XLS_LINE_WORKINGTIME_BY_LOSS_AVAILABLE @v_batch_create_from_yyyymmdd, @v_batch_division_id, @v_prod_line_id, @v_operation;

				INSERT INTO #WORKING_TBL_TEMP
				SELECT  ROW_NUMBER() OVER(ORDER BY YYYYMMDD) AS ROWNUM
						, @v_batch_xls_key1 AS XLS_KEY
						, X.YYYYMMDD
						, X.WORKING_TIME
						, 0.0            AS QTY
					FROM (
						SELECT  A.DIVISION_ID
								, A.OPERATION_ID
								, A.LINE_ID
								, C.YYYYMMDD
								, A.WORKING_TIME 
						FROM (SELECT BASIS_YYYYMMDD AS YYYYMMDD, 0 As WORKING_TIME 
									FROM SCM_SYS_CALENDAR_M WITH(NOLOCK) WHERE BASIS_YYYYMMDD BETWEEN @v_batch_create_from_yyyymmdd AND CONVERT(VARCHAR(8), DATEADD(day, 363, @v_batch_create_from_yyyymmdd), 112)) C
						LEFT OUTER JOIN
							(SELECT   @v_batch_division_id	AS DIVISION_ID
									, @v_operation		AS OPERATION_ID
									, @v_prod_line_id	AS LINE_ID
									, YYYYMMDD
									, G_VALUE			AS WORKING_TIME
							from @WORK_AVALIABLE) A
						ON C.YYYYMMDD = A.YYYYMMDD
						WHERE 1 = 1
				) X
				order by X.YYYYMMDD
				;

				DECLARE @v_lp     INT = 1;
				DECLARE @v_daylp  INT = 1;
				DECLARE @v_weeklp INT = 1;

				DECLARE @v_addday INT = 0;
				DECLARE @v_first_day INT = 0;

				-- 입력된 Week 수량을 Daily로 분배하기 위한 처리
				IF OBJECT_ID('tempdb..#WEEK_QTY_TBL') IS NOT NULL	
					DROP TABLE #WEEK_QTY_TBL

					CREATE TABLE #WEEK_QTY_TBL (
							WQTY01 INT ,WQTY02  INT ,WQTY03  INT ,WQTY04  INT ,WQTY05  INT
						,WQTY06	INT ,WQTY07  INT ,WQTY08  INT ,WQTY09  INT ,WQTY10  INT
						,WQTY11 INT ,WQTY12  INT ,WQTY13  INT ,WQTY14  INT ,WQTY15  INT
						,WQTY16	INT ,WQTY17  INT ,WQTY18  INT ,WQTY19  INT ,WQTY20  INT 
						,WQTY21 INT ,WQTY22  INT ,WQTY23  INT ,WQTY24  INT ,WQTY25  INT 
						,WQTY26	INT ,WQTY27  INT ,WQTY28  INT ,WQTY29  INT ,WQTY30  INT
						,WQTY31 INT ,WQTY32  INT ,WQTY33  INT ,WQTY34  INT ,WQTY35  INT 
						,WQTY36	INT ,WQTY37  INT ,WQTY38  INT ,WQTY39  INT ,WQTY40  INT 
						,WQTY41 INT ,WQTY42  INT ,WQTY43  INT ,WQTY44  INT ,WQTY45  INT 
						,WQTY46	INT ,WQTY47  INT ,WQTY48  INT ,WQTY49  INT ,WQTY50  INT
						,WQTY51 INT ,WQTY52  INT  
					);

				INSERT INTO #WEEK_QTY_TBL ( WQTY01, WQTY02, WQTY03, WQTY04, WQTY05   
											,WQTY06, WQTY07, WQTY08, WQTY09, WQTY10  
											,WQTY11, WQTY12, WQTY13, WQTY14, WQTY15  
											,WQTY16, WQTY17, WQTY18, WQTY19, WQTY20   
											,WQTY21, WQTY22, WQTY23, WQTY24, WQTY25   
											,WQTY26, WQTY27, WQTY28, WQTY29, WQTY30  
											,WQTY31, WQTY32, WQTY33, WQTY34, WQTY35   
											,WQTY36, WQTY37, WQTY38, WQTY39, WQTY40   
											,WQTY41, WQTY42, WQTY43, WQTY44, WQTY45   
											,WQTY46, WQTY47, WQTY48, WQTY49, WQTY50
											,WQTY51, WQTY52)
				SELECT   @p_WQTY01, @p_WQTY02, @p_WQTY03, @p_WQTY04, @p_WQTY05  
						,@p_WQTY06, @p_WQTY07, @p_WQTY08, @p_WQTY09, @p_WQTY10  
						,@p_WQTY11, @p_WQTY12, @p_WQTY13, @p_WQTY14, @p_WQTY15  
						,@p_WQTY16, @p_WQTY17, @p_WQTY18, @p_WQTY19, @p_WQTY20   
						,@p_WQTY21, @p_WQTY22, @p_WQTY23, @p_WQTY24, @p_WQTY25   
						,@p_WQTY26, @p_WQTY27, @p_WQTY28, @p_WQTY29, @p_WQTY30  
						,@p_WQTY31, @p_WQTY32, @p_WQTY33, @p_WQTY34, @p_WQTY35   
						,@p_WQTY36, @p_WQTY37, @p_WQTY38, @p_WQTY39, @p_WQTY40   
						,@p_WQTY41, @p_WQTY42, @p_WQTY43, @p_WQTY44, @p_WQTY45   
						,@p_WQTY46, @p_WQTY47, @p_WQTY48, @p_WQTY49, @p_WQTY50
						,@p_WQTY51, @p_WQTY52;
				;


				-------------------------------------------------------------------
				WITH SE1 AS(
				SELECT A.ROWNUM, A.XLS_KEY, A.YYYYMMDD, A.WORKING_TIME, A.WEEKNO, B.ITEM, B.CNT, R.WORKING_DAY, ROUND(CASE WHEN R.WORKING_DAY <= B.CNT THEN WORKING_TIME/ WEEK_WORKING_TIME  * CNT ELSE 0 END, 0) AS STEP1_QTY   FROM 
					(
					SELECT *, (ROWNUM-1)/7 +1 AS WEEKNO, 'WQTY' + RIGHT('0' + CONVERT(VARCHAR, (ROWNUM-1)/7 +1), 2) AS ITEM FROM #WORKING_TBL_TEMP 
					)  A
					LEFT JOIN 
					(
					SELECT (ROWNUM-1)/7 +1 AS WEEKNO, COUNT(WORKING_TIME) AS WORKING_DAY, CASE WHEN SUM(WORKING_TIME) = 0 THEN 1 ELSE SUM(WORKING_TIME) END AS WEEK_WORKING_TIME FROM #WORKING_TBL_TEMP
						WHERE WORKING_TIME > 0
						GROUP BY (ROWNUM-1)/7 +1
					) R
					ON A.WEEKNO = R.WEEKNO
					LEFT JOIN 
					(
					SELECT  ITEM, CNT
					FROM #WEEK_QTY_TBL A
					UNPIVOT (CNT FOR ITEM IN ( WQTY01,WQTY02,WQTY03,WQTY04,WQTY05,WQTY06,WQTY07,WQTY08,WQTY09,WQTY10
					,WQTY11,WQTY12,WQTY13,WQTY14,WQTY15,WQTY16,WQTY17,WQTY18,WQTY19,WQTY20
					,WQTY21,WQTY22,WQTY23,WQTY24,WQTY25,WQTY26,WQTY27,WQTY28,WQTY29,WQTY30
					,WQTY31,WQTY32,WQTY33,WQTY34,WQTY35,WQTY36,WQTY37,WQTY38,WQTY39,WQTY40
					,WQTY41,WQTY42,WQTY43,WQTY44,WQTY45,WQTY46,WQTY47,WQTY48,WQTY49,WQTY50
					,WQTY51,WQTY52)) AS UN
					)B
					ON A.ITEM =B.ITEM
				)
				, SE2 AS(
				SELECT A.ROWNUM, A.XLS_KEY, A.YYYYMMDD, A.WORKING_TIME, A.WEEKNO, A.ITEM, A.CNT, A.WORKING_DAY, C.WEEKSUM, STEP1_QTY, CASE WHEN A.ROWNUM = C.ADDDAY THEN (CASE WHEN A.STEP1_QTY + (A.CNT - C.WEEKSUM) < 0 THEN 0 ELSE A.STEP1_QTY + (A.CNT - C.WEEKSUM) END) ELSE STEP1_QTY END STEP2_QTY, MINDAY FROM SE1 A
				LEFT JOIN (SELECT WEEKNO, MAX(ROWNUM) AS ADDDAY,MIN(ROWNUM) AS MINDAY, SUM(STEP1_QTY) AS WEEKSUM FROM SE1 GROUP BY WEEKNO) C
				ON A.WEEKNO = C.WEEKNO
				)
				, SE3 AS(
				SELECT R.ROWNUM, R.XLS_KEY, R.YYYYMMDD, R.WORKING_TIME, R.WEEKNO, R.ITEM, R.CNT, R.WORKING_DAY, R.WEEKSUM, R.STEP1_QTY, R.STEP2_QTY, R.MINDAY, (SELECT SUM(ISNULL(T.STEP2_QTY, 0)) FROM SE2 T WHERE T.ROWNUM <= R.ROWNUM AND T.WEEKNO = R.WEEKNO) AS SUM_ROW , (SELECT SUM(ISNULL(T.STEP2_QTY, 0)) FROM SE2 T WHERE T.ROWNUM <= R.ROWNUM-1 AND T.WEEKNO = R.WEEKNO) AS SUM_ROW2
				FROM SE2 R
				)
				SELECT SE3.ROWNUM, SE3.XLS_KEY, SE3.YYYYMMDD, SE3.WORKING_TIME, ISNULL(CASE WHEN ISNULL(SE3.CNT, 0) < ISNULL(SE3.SUM_ROW, 0) 
				THEN (CASE WHEN (ISNULL(SE3.CNT, 0) - SE3.SUM_ROW2) = NULL OR (ISNULL(SE3.CNT, 0) - SE3.SUM_ROW2) < 0 THEN 0 ELSE ISNULL(SE3.CNT, 0) - SE3.SUM_ROW2 END) ELSE SE3.STEP2_QTY END, 0) AS QTY
				INTO #WORKING_TBL
				FROM SE3;


				------------------------------------------
				-- Pack 생산계획 저장로직개선(튜닝)건 반영 -- end
				------------------------------------------

				-- 분배된 수량 업데이트
				MERGE INTO SCP_XLS_PSI_GLOBAL AS E
				USING (
						SELECT   S.XLS_KEY
								,SUM([1])  AS QTY001, SUM([2]) AS QTY002,  SUM([3])  AS QTY003, SUM([4])  AS QTY004, SUM([5])  AS QTY005, SUM([6])  AS QTY006, SUM([7])  AS QTY007, SUM([8])  AS QTY008, SUM([9])  AS QTY009, SUM([10]) AS QTY010
								,SUM([11]) AS QTY011, SUM([12]) AS QTY012, SUM([13]) AS QTY013, SUM([14]) AS QTY014, SUM([15]) AS QTY015, SUM([16]) AS QTY016, SUM([17]) AS QTY017, SUM([18]) AS QTY018, SUM([19]) AS QTY019, SUM([20]) AS QTY020
								,SUM([21]) AS QTY021, SUM([22]) AS QTY022, SUM([23]) AS QTY023, SUM([24]) AS QTY024, SUM([25]) AS QTY025, SUM([26]) AS QTY026, SUM([27]) AS QTY027, SUM([28]) AS QTY028, SUM([29]) AS QTY029, SUM([30]) AS QTY030
								,SUM([31]) AS QTY031, SUM([32]) AS QTY032, SUM([33]) AS QTY033, SUM([34]) AS QTY034, SUM([35]) AS QTY035, SUM([36]) AS QTY036, SUM([37]) AS QTY037, SUM([38]) AS QTY038, SUM([39]) AS QTY039, SUM([40]) AS QTY040
								,SUM([41]) AS QTY041, SUM([42]) AS QTY042, SUM([43]) AS QTY043, SUM([44]) AS QTY044, SUM([45]) AS QTY045, SUM([46]) AS QTY046, SUM([47]) AS QTY047, SUM([48]) AS QTY048, SUM([49]) AS QTY049, SUM([50]) AS QTY050
								,SUM([51]) AS QTY051, SUM([52]) AS QTY052, SUM([53]) AS QTY053, SUM([54]) AS QTY054, SUM([55]) AS QTY055, SUM([56]) AS QTY056, SUM([57]) AS QTY057, SUM([58]) AS QTY058, SUM([59]) AS QTY059, SUM([60]) AS QTY060
								,SUM([61]) AS QTY061, SUM([62]) AS QTY062, SUM([63]) AS QTY063, SUM([64]) AS QTY064, SUM([65]) AS QTY065, SUM([66]) AS QTY066, SUM([67]) AS QTY067, SUM([68]) AS QTY068, SUM([69]) AS QTY069, SUM([70]) AS QTY070
								,SUM([71]) AS QTY071, SUM([72]) AS QTY072, SUM([73]) AS QTY073, SUM([74]) AS QTY074, SUM([75]) AS QTY075, SUM([76]) AS QTY076, SUM([77]) AS QTY077, SUM([78]) AS QTY078, SUM([79]) AS QTY079, SUM([80]) AS QTY080
								,SUM([81]) AS QTY081, SUM([82]) AS QTY082, SUM([83]) AS QTY083, SUM([84]) AS QTY084, SUM([85]) AS QTY085, SUM([86]) AS QTY086, SUM([87]) AS QTY087, SUM([88]) AS QTY088, SUM([89]) AS QTY089, SUM([90]) AS QTY090
								,SUM([91]) AS QTY091, SUM([92]) AS QTY092, SUM([93]) AS QTY093, SUM([94]) AS QTY094, SUM([95]) AS QTY095, SUM([96]) AS QTY096, SUM([97]) AS QTY097, SUM([98]) AS QTY098, SUM([99]) AS QTY099, SUM([100]) AS QTY100
								,SUM([101]) AS QTY101, SUM([102]) AS QTY102, SUM([103]) AS QTY103, SUM([104]) AS QTY104, SUM([105]) AS QTY105, SUM([106]) AS QTY106, SUM([107]) AS QTY107, SUM([108]) AS QTY108, SUM([109]) AS QTY109, SUM([110]) AS QTY110
								,SUM([111]) AS QTY111, SUM([112]) AS QTY112, SUM([113]) AS QTY113, SUM([114]) AS QTY114, SUM([115]) AS QTY115, SUM([116]) AS QTY116, SUM([117]) AS QTY117, SUM([118]) AS QTY118, SUM([119]) AS QTY119, SUM([120]) AS QTY120
								,SUM([121]) AS QTY121, SUM([122]) AS QTY122, SUM([123]) AS QTY123, SUM([124]) AS QTY124, SUM([125]) AS QTY125, SUM([126]) AS QTY126, SUM([127]) AS QTY127, SUM([128]) AS QTY128, SUM([129]) AS QTY129, SUM([130]) AS QTY130
								,SUM([131]) AS QTY131, SUM([132]) AS QTY132, SUM([133]) AS QTY133, SUM([134]) AS QTY134, SUM([135]) AS QTY135, SUM([136]) AS QTY136, SUM([137]) AS QTY137, SUM([138]) AS QTY138, SUM([139]) AS QTY139, SUM([140]) AS QTY140
								,SUM([141]) AS QTY141, SUM([142]) AS QTY142, SUM([143]) AS QTY143, SUM([144]) AS QTY144, SUM([145]) AS QTY145, SUM([146]) AS QTY146, SUM([147]) AS QTY147, SUM([148]) AS QTY148, SUM([149]) AS QTY149, SUM([150]) AS QTY150
								,SUM([151]) AS QTY151, SUM([152]) AS QTY152, SUM([153]) AS QTY153, SUM([154]) AS QTY154, SUM([155]) AS QTY155, SUM([156]) AS QTY156, SUM([157]) AS QTY157, SUM([158]) AS QTY158, SUM([159]) AS QTY159, SUM([160]) AS QTY160
								,SUM([161]) AS QTY161, SUM([162]) AS QTY162, SUM([163]) AS QTY163, SUM([164]) AS QTY164, SUM([165]) AS QTY165, SUM([166]) AS QTY166, SUM([167]) AS QTY167, SUM([168]) AS QTY168, SUM([169]) AS QTY169, SUM([170]) AS QTY170
								,SUM([171]) AS QTY171, SUM([172]) AS QTY172, SUM([173]) AS QTY173, SUM([174]) AS QTY174, SUM([175]) AS QTY175, SUM([176]) AS QTY176, SUM([177]) AS QTY177, SUM([178]) AS QTY178, SUM([179]) AS QTY179, SUM([180]) AS QTY180
								,SUM([181]) AS QTY181, SUM([182]) AS QTY182, SUM([183]) AS QTY183, SUM([184]) AS QTY184, SUM([185]) AS QTY185, SUM([186]) AS QTY186, SUM([187]) AS QTY187, SUM([188]) AS QTY188, SUM([189]) AS QTY189, SUM([190]) AS QTY190
								,SUM([191]) AS QTY191, SUM([192]) AS QTY192, SUM([193]) AS QTY193, SUM([194]) AS QTY194, SUM([195]) AS QTY195, SUM([196]) AS QTY196, SUM([197]) AS QTY197, SUM([198]) AS QTY198, SUM([199]) AS QTY199, SUM([200]) AS QTY200
								,SUM([201]) AS QTY201, SUM([202]) AS QTY202, SUM([203]) AS QTY203, SUM([204]) AS QTY204, SUM([205]) AS QTY205, SUM([206]) AS QTY206, SUM([207]) AS QTY207, SUM([208]) AS QTY208, SUM([209]) AS QTY209, SUM([210]) AS QTY210
								,SUM([211]) AS QTY211, SUM([212]) AS QTY212, SUM([213]) AS QTY213, SUM([214]) AS QTY214, SUM([215]) AS QTY215, SUM([216]) AS QTY216, SUM([217]) AS QTY217, SUM([218]) AS QTY218, SUM([219]) AS QTY219, SUM([220]) AS QTY220
								,SUM([221]) AS QTY221, SUM([222]) AS QTY222, SUM([223]) AS QTY223, SUM([224]) AS QTY224, SUM([225]) AS QTY225, SUM([226]) AS QTY226, SUM([227]) AS QTY227, SUM([228]) AS QTY228, SUM([229]) AS QTY229, SUM([230]) AS QTY230
								,SUM([231]) AS QTY231, SUM([232]) AS QTY232, SUM([233]) AS QTY233, SUM([234]) AS QTY234, SUM([235]) AS QTY235, SUM([236]) AS QTY236, SUM([237]) AS QTY237, SUM([238]) AS QTY238, SUM([239]) AS QTY239, SUM([240]) AS QTY240
								,SUM([241]) AS QTY241, SUM([242]) AS QTY242, SUM([243]) AS QTY243, SUM([244]) AS QTY244, SUM([245]) AS QTY245, SUM([246]) AS QTY246, SUM([247]) AS QTY247, SUM([248]) AS QTY248, SUM([249]) AS QTY249, SUM([250]) AS QTY250
								,SUM([251]) AS QTY251, SUM([252]) AS QTY252, SUM([253]) AS QTY253, SUM([254]) AS QTY254, SUM([255]) AS QTY255, SUM([256]) AS QTY256, SUM([257]) AS QTY257, SUM([258]) AS QTY258, SUM([259]) AS QTY259, SUM([260]) AS QTY260
								,SUM([261]) AS QTY261, SUM([262]) AS QTY262, SUM([263]) AS QTY263, SUM([264]) AS QTY264, SUM([265]) AS QTY265, SUM([266]) AS QTY266, SUM([267]) AS QTY267, SUM([268]) AS QTY268, SUM([269]) AS QTY269, SUM([270]) AS QTY270
								,SUM([271]) AS QTY271, SUM([272]) AS QTY272, SUM([273]) AS QTY273, SUM([274]) AS QTY274, SUM([275]) AS QTY275, SUM([276]) AS QTY276, SUM([277]) AS QTY277, SUM([278]) AS QTY278, SUM([279]) AS QTY279, SUM([280]) AS QTY280
								,SUM([281]) AS QTY281, SUM([282]) AS QTY282, SUM([283]) AS QTY283, SUM([284]) AS QTY284, SUM([285]) AS QTY285, SUM([286]) AS QTY286, SUM([287]) AS QTY287, SUM([288]) AS QTY288, SUM([289]) AS QTY289, SUM([290]) AS QTY290
								,SUM([291]) AS QTY291, SUM([292]) AS QTY292, SUM([293]) AS QTY293, SUM([294]) AS QTY294, SUM([295]) AS QTY295, SUM([296]) AS QTY296, SUM([297]) AS QTY297, SUM([298]) AS QTY298, SUM([299]) AS QTY299, SUM([300]) AS QTY300
								,SUM([301]) AS QTY301, SUM([302]) AS QTY302, SUM([303]) AS QTY303, SUM([304]) AS QTY304, SUM([305]) AS QTY305, SUM([306]) AS QTY306, SUM([307]) AS QTY307, SUM([308]) AS QTY308, SUM([309]) AS QTY309, SUM([310]) AS QTY310
								,SUM([311]) AS QTY311, SUM([312]) AS QTY312, SUM([313]) AS QTY313, SUM([314]) AS QTY314, SUM([315]) AS QTY315, SUM([316]) AS QTY316, SUM([317]) AS QTY317, SUM([318]) AS QTY318, SUM([319]) AS QTY319, SUM([320]) AS QTY320
								,SUM([321]) AS QTY321, SUM([322]) AS QTY322, SUM([323]) AS QTY323, SUM([324]) AS QTY324, SUM([325]) AS QTY325, SUM([326]) AS QTY326, SUM([327]) AS QTY327, SUM([328]) AS QTY328, SUM([329]) AS QTY329, SUM([330]) AS QTY330
								,SUM([331]) AS QTY331, SUM([332]) AS QTY332, SUM([333]) AS QTY333, SUM([334]) AS QTY334, SUM([335]) AS QTY335, SUM([336]) AS QTY336, SUM([337]) AS QTY337, SUM([338]) AS QTY338, SUM([339]) AS QTY339, SUM([340]) AS QTY340
								,SUM([341]) AS QTY341, SUM([342]) AS QTY342, SUM([343]) AS QTY343, SUM([344]) AS QTY344, SUM([345]) AS QTY345, SUM([346]) AS QTY346, SUM([347]) AS QTY347, SUM([348]) AS QTY348, SUM([349]) AS QTY349, SUM([350]) AS QTY350
								,SUM([351]) AS QTY351, SUM([352]) AS QTY352, SUM([353]) AS QTY353, SUM([354]) AS QTY354, SUM([355]) AS QTY355, SUM([356]) AS QTY356, SUM([357]) AS QTY357, SUM([358]) AS QTY358, SUM([359]) AS QTY359, SUM([360]) AS QTY360
								,SUM([361]) AS QTY361, SUM([362]) AS QTY362, SUM([363]) AS QTY363, SUM([364]) AS QTY364
							FROM (SELECT   P.XLS_KEY
							            ,ISNULL([1],0) AS [1],   ISNULL([2],0) AS [2],   ISNULL([3],0) AS [3],   ISNULL([4],0) AS [4], ISNULL([5],0) AS [5], ISNULL([6],0) AS [6], ISNULL([7],0) AS [7], ISNULL([8],0) AS [8], ISNULL([9],0) AS [9], ISNULL([10],0) AS [10]
										,ISNULL([11],0) AS [11], ISNULL([12],0) AS [12], ISNULL([13],0) AS [13], ISNULL([14],0) AS [14], ISNULL([15],0) AS [15], ISNULL([16],0) AS [16], ISNULL([17],0) AS [17], ISNULL([18],0) AS [18], ISNULL([19],0) AS [19], ISNULL([20],0) AS [20]
										,ISNULL([21],0) AS [21], ISNULL([22],0) AS [22], ISNULL([23],0) AS [23], ISNULL([24],0) AS [24], ISNULL([25],0) AS [25], ISNULL([26],0) AS [26], ISNULL([27],0) AS [27], ISNULL([28],0) AS [28], ISNULL([29],0) AS [29], ISNULL([30],0) AS [30]
										,ISNULL([31],0) AS [31], ISNULL([32],0) AS [32], ISNULL([33],0) AS [33], ISNULL([34],0) AS [34], ISNULL([35],0) AS [35], ISNULL([36],0) AS [36], ISNULL([37],0) AS [37], ISNULL([38],0) AS [38], ISNULL([39],0) AS [39], ISNULL([40],0) AS [40]
										,ISNULL([41],0) AS [41], ISNULL([42],0) AS [42], ISNULL([43],0) AS [43], ISNULL([44],0) AS [44], ISNULL([45],0) AS [45], ISNULL([46],0) AS [46], ISNULL([47],0) AS [47], ISNULL([48],0) AS [48], ISNULL([49],0) AS [49], ISNULL([50],0) AS [50]
										,ISNULL([51],0) AS [51], ISNULL([52],0) AS [52], ISNULL([53],0) AS [53], ISNULL([54],0) AS [54], ISNULL([55],0) AS [55], ISNULL([56],0) AS [56], ISNULL([57],0) AS [57], ISNULL([58],0) AS [58], ISNULL([59],0) AS [59], ISNULL([60],0) AS [60]
										,ISNULL([61],0) AS [61], ISNULL([62],0) AS [62], ISNULL([63],0) AS [63], ISNULL([64],0) AS [64], ISNULL([65],0) AS [65], ISNULL([66],0) AS [66], ISNULL([67],0) AS [67], ISNULL([68],0) AS [68], ISNULL([69],0) AS [69], ISNULL([70],0) AS [70]
										,ISNULL([71],0) AS [71], ISNULL([72],0) AS [72], ISNULL([73],0) AS [73], ISNULL([74],0) AS [74], ISNULL([75],0) AS [75], ISNULL([76],0) AS [76], ISNULL([77],0) AS [77], ISNULL([78],0) AS [78], ISNULL([79],0) AS [79], ISNULL([80],0) AS [80]
										,ISNULL([81],0) AS [81], ISNULL([82],0) AS [82], ISNULL([83],0) AS [83], ISNULL([84],0) AS [84], ISNULL([85],0) AS [85], ISNULL([86],0) AS [86], ISNULL([87],0) AS [87], ISNULL([88],0) AS [88], ISNULL([89],0) AS [89], ISNULL([90],0) AS [90]
										,ISNULL([91],0) AS [91], ISNULL([92],0) AS [92], ISNULL([93],0) AS [93], ISNULL([94],0) AS [94], ISNULL([95],0) AS [95], ISNULL([96],0) AS [96], ISNULL([97],0) AS [97], ISNULL([98],0) AS [98], ISNULL([99],0) AS [99], ISNULL([100],0) AS [100]
										,ISNULL([101],0) AS [101], ISNULL([102],0) AS [102], ISNULL([103],0) AS [103], ISNULL([104],0) AS [104], ISNULL([105],0) AS [105], ISNULL([106],0) AS [106], ISNULL([107],0) AS [107], ISNULL([108],0) AS [108], ISNULL([109],0) AS [109], ISNULL([110],0) AS [110]
										,ISNULL([111],0) AS [111], ISNULL([112],0) AS [112], ISNULL([113],0) AS [113], ISNULL([114],0) AS [114], ISNULL([115],0) AS [115], ISNULL([116],0) AS [116], ISNULL([117],0) AS [117], ISNULL([118],0) AS [118], ISNULL([119],0) AS [119], ISNULL([120],0) AS [120]
										,ISNULL([121],0) AS [121], ISNULL([122],0) AS [122], ISNULL([123],0) AS [123], ISNULL([124],0) AS [124], ISNULL([125],0) AS [125], ISNULL([126],0) AS [126], ISNULL([127],0) AS [127], ISNULL([128],0) AS [128], ISNULL([129],0) AS [129], ISNULL([130],0) AS [130]
										,ISNULL([131],0) AS [131], ISNULL([132],0) AS [132], ISNULL([133],0) AS [133], ISNULL([134],0) AS [134], ISNULL([135],0) AS [135], ISNULL([136],0) AS [136], ISNULL([137],0) AS [137], ISNULL([138],0) AS [138], ISNULL([139],0) AS [139], ISNULL([140],0) AS [140]
										,ISNULL([141],0) AS [141], ISNULL([142],0) AS [142], ISNULL([143],0) AS [143], ISNULL([144],0) AS [144], ISNULL([145],0) AS [145], ISNULL([146],0) AS [146], ISNULL([147],0) AS [147], ISNULL([148],0) AS [148], ISNULL([149],0) AS [149], ISNULL([150],0) AS [150]
										,ISNULL([151],0) AS [151], ISNULL([152],0) AS [152], ISNULL([153],0) AS [153], ISNULL([154],0) AS [154], ISNULL([155],0) AS [155], ISNULL([156],0) AS [156], ISNULL([157],0) AS [157], ISNULL([158],0) AS [158], ISNULL([159],0) AS [159], ISNULL([160],0) AS [160]
										,ISNULL([161],0) AS [161], ISNULL([162],0) AS [162], ISNULL([163],0) AS [163], ISNULL([164],0) AS [164], ISNULL([165],0) AS [165], ISNULL([166],0) AS [166], ISNULL([167],0) AS [167], ISNULL([168],0) AS [168], ISNULL([169],0) AS [169], ISNULL([170],0) AS [170]
										,ISNULL([171],0) AS [171], ISNULL([172],0) AS [172], ISNULL([173],0) AS [173], ISNULL([174],0) AS [174], ISNULL([175],0) AS [175], ISNULL([176],0) AS [176], ISNULL([177],0) AS [177], ISNULL([178],0) AS [178], ISNULL([179],0) AS [179], ISNULL([180],0) AS [180]
										,ISNULL([181],0) AS [181], ISNULL([182],0) AS [182], ISNULL([183],0) AS [183], ISNULL([184],0) AS [184], ISNULL([185],0) AS [185], ISNULL([186],0) AS [186], ISNULL([187],0) AS [187], ISNULL([188],0) AS [188], ISNULL([189],0) AS [189], ISNULL([190],0) AS [190]
										,ISNULL([191],0) AS [191], ISNULL([192],0) AS [192], ISNULL([193],0) AS [193], ISNULL([194],0) AS [194], ISNULL([195],0) AS [195], ISNULL([196],0) AS [196], ISNULL([197],0) AS [197], ISNULL([198],0) AS [198], ISNULL([199],0) AS [199], ISNULL([200],0) AS [200]
										,ISNULL([201],0) AS [201], ISNULL([202],0) AS [202], ISNULL([203],0) AS [203], ISNULL([204],0) AS [204], ISNULL([205],0) AS [205], ISNULL([206],0) AS [206], ISNULL([207],0) AS [207], ISNULL([208],0) AS [208], ISNULL([209],0) AS [209], ISNULL([210],0) AS [210]
										,ISNULL([211],0) AS [211], ISNULL([212],0) AS [212], ISNULL([213],0) AS [213], ISNULL([214],0) AS [214], ISNULL([215],0) AS [215], ISNULL([216],0) AS [216], ISNULL([217],0) AS [217], ISNULL([218],0) AS [218], ISNULL([219],0) AS [219], ISNULL([220],0) AS [220]
										,ISNULL([221],0) AS [221], ISNULL([222],0) AS [222], ISNULL([223],0) AS [223], ISNULL([224],0) AS [224], ISNULL([225],0) AS [225], ISNULL([226],0) AS [226], ISNULL([227],0) AS [227], ISNULL([228],0) AS [228], ISNULL([229],0) AS [229], ISNULL([230],0) AS [230]
										,ISNULL([231],0) AS [231], ISNULL([232],0) AS [232], ISNULL([233],0) AS [233], ISNULL([234],0) AS [234], ISNULL([235],0) AS [235], ISNULL([236],0) AS [236], ISNULL([237],0) AS [237], ISNULL([238],0) AS [238], ISNULL([239],0) AS [239], ISNULL([240],0) AS [240]
										,ISNULL([241],0) AS [241], ISNULL([242],0) AS [242], ISNULL([243],0) AS [243], ISNULL([244],0) AS [244], ISNULL([245],0) AS [245], ISNULL([246],0) AS [246], ISNULL([247],0) AS [247], ISNULL([248],0) AS [248], ISNULL([249],0) AS [249], ISNULL([250],0) AS [250]
										,ISNULL([251],0) AS [251], ISNULL([252],0) AS [252], ISNULL([253],0) AS [253], ISNULL([254],0) AS [254], ISNULL([255],0) AS [255], ISNULL([256],0) AS [256], ISNULL([257],0) AS [257], ISNULL([258],0) AS [258], ISNULL([259],0) AS [259], ISNULL([260],0) AS [260]
										,ISNULL([261],0) AS [261], ISNULL([262],0) AS [262], ISNULL([263],0) AS [263], ISNULL([264],0) AS [264], ISNULL([265],0) AS [265], ISNULL([266],0) AS [266], ISNULL([267],0) AS [267], ISNULL([268],0) AS [268], ISNULL([269],0) AS [269], ISNULL([270],0) AS [270]
										,ISNULL([271],0) AS [271], ISNULL([272],0) AS [272], ISNULL([273],0) AS [273], ISNULL([274],0) AS [274], ISNULL([275],0) AS [275], ISNULL([276],0) AS [276], ISNULL([277],0) AS [277], ISNULL([278],0) AS [278], ISNULL([279],0) AS [279], ISNULL([280],0) AS [280]
										,ISNULL([281],0) AS [281], ISNULL([282],0) AS [282], ISNULL([283],0) AS [283], ISNULL([284],0) AS [284], ISNULL([285],0) AS [285], ISNULL([286],0) AS [286], ISNULL([287],0) AS [287], ISNULL([288],0) AS [288], ISNULL([289],0) AS [289], ISNULL([290],0) AS [290]
										,ISNULL([291],0) AS [291], ISNULL([292],0) AS [292], ISNULL([293],0) AS [293], ISNULL([294],0) AS [294], ISNULL([295],0) AS [295], ISNULL([296],0) AS [296], ISNULL([297],0) AS [297], ISNULL([298],0) AS [298], ISNULL([299],0) AS [299], ISNULL([300],0) AS [300]
										,ISNULL([301],0) AS [301], ISNULL([302],0) AS [302], ISNULL([303],0) AS [303], ISNULL([304],0) AS [304], ISNULL([305],0) AS [305], ISNULL([306],0) AS [306], ISNULL([307],0) AS [307], ISNULL([308],0) AS [308], ISNULL([309],0) AS [309], ISNULL([310],0) AS [310]
										,ISNULL([311],0) AS [311], ISNULL([312],0) AS [312], ISNULL([313],0) AS [313], ISNULL([314],0) AS [314], ISNULL([315],0) AS [315], ISNULL([316],0) AS [316], ISNULL([317],0) AS [317], ISNULL([318],0) AS [318], ISNULL([319],0) AS [319], ISNULL([320],0) AS [320]
										,ISNULL([321],0) AS [321], ISNULL([322],0) AS [322], ISNULL([323],0) AS [323], ISNULL([324],0) AS [324], ISNULL([325],0) AS [325], ISNULL([326],0) AS [326], ISNULL([327],0) AS [327], ISNULL([328],0) AS [328], ISNULL([329],0) AS [329], ISNULL([330],0) AS [330]
										,ISNULL([331],0) AS [331], ISNULL([332],0) AS [332], ISNULL([333],0) AS [333], ISNULL([334],0) AS [334], ISNULL([335],0) AS [335], ISNULL([336],0) AS [336], ISNULL([337],0) AS [337], ISNULL([338],0) AS [338], ISNULL([339],0) AS [339], ISNULL([340],0) AS [340]
										,ISNULL([341],0) AS [341], ISNULL([342],0) AS [342], ISNULL([343],0) AS [343], ISNULL([344],0) AS [344], ISNULL([345],0) AS [345], ISNULL([346],0) AS [346], ISNULL([347],0) AS [347], ISNULL([348],0) AS [348], ISNULL([349],0) AS [349], ISNULL([350],0) AS [350]
										,ISNULL([351],0) AS [351], ISNULL([352],0) AS [352], ISNULL([353],0) AS [353], ISNULL([354],0) AS [354], ISNULL([355],0) AS [355], ISNULL([356],0) AS [356], ISNULL([357],0) AS [357], ISNULL([358],0) AS [358], ISNULL([359],0) AS [359], ISNULL([360],0) AS [360]
										,ISNULL([361],0) AS [361], ISNULL([362],0) AS [362], ISNULL([363],0) AS [363], ISNULL([364],0) AS [364]
									FROM #WORKING_TBL
									PIVOT (
										SUM(QTY) FOR ROWNUM IN ( [1], [2], [3], [4], [5], [6], [7], [8], [9], [10]
																,[11], [12], [13], [14], [15], [16], [17], [18], [19], [20]
																,[21], [22], [23], [24], [25], [26], [27], [28], [29], [30]
																,[31], [32], [33], [34], [35], [36], [37], [38], [39], [40]
																,[41], [42], [43], [44], [45], [46], [47], [48], [49], [50]
																,[51], [52], [53], [54], [55], [56], [57], [58], [59], [60]
																,[61], [62], [63], [64], [65], [66], [67], [68], [69], [70]
																,[71], [72], [73], [74], [75], [76], [77], [78], [79], [80]
																,[81], [82], [83], [84], [85], [86], [87], [88], [89], [90]
																,[91], [92], [93], [94], [95], [96], [97], [98], [99], [100]
																,[101], [102], [103], [104], [105], [106], [107], [108], [109], [110]
																,[111], [112], [113], [114], [115], [116], [117], [118], [119], [120]
																,[121], [122], [123], [124], [125], [126], [127], [128], [129], [130]
																,[131], [132], [133], [134], [135], [136], [137], [138], [139], [140]
																,[141], [142], [143], [144], [145], [146], [147], [148], [149], [150]
																,[151], [152], [153], [154], [155], [156], [157], [158], [159], [160]
																,[161], [162], [163], [164], [165], [166], [167], [168], [169], [170]
																,[171], [172], [173], [174], [175], [176], [177], [178], [179], [180]
																,[181], [182], [183], [184], [185], [186], [187], [188], [189], [190]
																,[191], [192], [193], [194], [195], [196], [197], [198], [199], [200]
																,[201], [202], [203], [204], [205], [206], [207], [208], [209], [210]
																,[211], [212], [213], [214], [215], [216], [217], [218], [219], [220]
																,[221], [222], [223], [224], [225], [226], [227], [228], [229], [230]
																,[231], [232], [233], [234], [235], [236], [237], [238], [239], [240]
																,[241], [242], [243], [244], [245], [246], [247], [248], [249], [250]
																,[251], [252], [253], [254], [255], [256], [257], [258], [259], [260]
																,[261], [262], [263], [264], [265], [266], [267], [268], [269], [270]
																,[271], [272], [273], [274], [275], [276], [277], [278], [279], [280]
																,[281], [282], [283], [284], [285], [286], [287], [288], [289], [290]
																,[291], [292], [293], [294], [295], [296], [297], [298], [299], [300]
																,[301], [302], [303], [304], [305], [306], [307], [308], [309], [310]
																,[311], [312], [313], [314], [315], [316], [317], [318], [319], [320]
																,[321], [322], [323], [324], [325], [326], [327], [328], [329], [330]
																,[331], [332], [333], [334], [335], [336], [337], [338], [339], [340]
																,[341], [342], [343], [344], [345], [346], [347], [348], [349], [350]
																,[351], [352], [353], [354], [355], [356], [357], [358], [359], [360]
																,[361], [362], [363], [364]
											                    )
									    ) P
							    ) S
							GROUP BY S.XLS_KEY
						) AS W
					   ON 0 = 0
					  AND E.XLS_KEY1           = W.XLS_KEY
					  AND DIVISION_ID          = @v_batch_division_id
                      AND PLAN_START_YYYYMMDD  = @v_batch_plan_start_yyyymmdd
					  AND CREATE_FROM_YYYYMMDD = @v_batch_create_from_yyyymmdd
                      AND SEQ                  = @v_batch_seq
                      AND XLS_KEY1             = @v_batch_xls_key1   

					WHEN MATCHED  THEN
					UPDATE
					SET  E.QTY001 = W.QTY001, E.QTY002 = W.QTY002, E.QTY003 = W.QTY003, E.QTY004 = W.QTY004, E.QTY005 = W.QTY005, E.QTY006 = W.QTY006, E.QTY007 = W.QTY007, E.QTY008 = W.QTY008, E.QTY009 = W.QTY009, E.QTY010 = W.QTY010
						,E.QTY011 = W.QTY011, E.QTY012 = W.QTY012, E.QTY013 = W.QTY013, E.QTY014 = W.QTY014, E.QTY015 = W.QTY015, E.QTY016 = W.QTY016, E.QTY017 = W.QTY017, E.QTY018 = W.QTY018, E.QTY019 = W.QTY019, E.QTY020 = W.QTY020
						,E.QTY021 = W.QTY021, E.QTY022 = W.QTY022, E.QTY023 = W.QTY023, E.QTY024 = W.QTY024, E.QTY025 = W.QTY025, E.QTY026 = W.QTY026, E.QTY027 = W.QTY027, E.QTY028 = W.QTY028, E.QTY029 = W.QTY029, E.QTY030 = W.QTY030
						,E.QTY031 = W.QTY031, E.QTY032 = W.QTY032, E.QTY033 = W.QTY033, E.QTY034 = W.QTY034, E.QTY035 = W.QTY035, E.QTY036 = W.QTY036, E.QTY037 = W.QTY037, E.QTY038 = W.QTY038, E.QTY039 = W.QTY039, E.QTY040 = W.QTY040
						,E.QTY041 = W.QTY041, E.QTY042 = W.QTY042, E.QTY043 = W.QTY043, E.QTY044 = W.QTY044, E.QTY045 = W.QTY045, E.QTY046 = W.QTY046, E.QTY047 = W.QTY047, E.QTY048 = W.QTY048, E.QTY049 = W.QTY049, E.QTY050 = W.QTY050
						,E.QTY051 = W.QTY051, E.QTY052 = W.QTY052, E.QTY053 = W.QTY053, E.QTY054 = W.QTY054, E.QTY055 = W.QTY055, E.QTY056 = W.QTY056, E.QTY057 = W.QTY057, E.QTY058 = W.QTY058, E.QTY059 = W.QTY059, E.QTY060 = W.QTY060
						,E.QTY061 = W.QTY061, E.QTY062 = W.QTY062, E.QTY063 = W.QTY063, E.QTY064 = W.QTY064, E.QTY065 = W.QTY065, E.QTY066 = W.QTY066, E.QTY067 = W.QTY067, E.QTY068 = W.QTY068, E.QTY069 = W.QTY069, E.QTY070 = W.QTY070
						,E.QTY071 = W.QTY071, E.QTY072 = W.QTY072, E.QTY073 = W.QTY073, E.QTY074 = W.QTY074, E.QTY075 = W.QTY075, E.QTY076 = W.QTY076, E.QTY077 = W.QTY077, E.QTY078 = W.QTY078, E.QTY079 = W.QTY079, E.QTY080 = W.QTY080
						,E.QTY081 = W.QTY081, E.QTY082 = W.QTY082, E.QTY083 = W.QTY083, E.QTY084 = W.QTY084, E.QTY085 = W.QTY085, E.QTY086 = W.QTY086, E.QTY087 = W.QTY087, E.QTY088 = W.QTY088, E.QTY089 = W.QTY089, E.QTY090 = W.QTY090
						,E.QTY091 = W.QTY091, E.QTY092 = W.QTY092, E.QTY093 = W.QTY093, E.QTY094 = W.QTY094, E.QTY095 = W.QTY095, E.QTY096 = W.QTY096, E.QTY097 = W.QTY097, E.QTY098 = W.QTY098, E.QTY099 = W.QTY099, E.QTY100 = W.QTY100
						,E.QTY101 = W.QTY101, E.QTY102 = W.QTY102, E.QTY103 = W.QTY103, E.QTY104 = W.QTY104, E.QTY105 = W.QTY105, E.QTY106 = W.QTY106, E.QTY107 = W.QTY107, E.QTY108 = W.QTY108, E.QTY109 = W.QTY109, E.QTY110 = W.QTY110
						,E.QTY111 = W.QTY111, E.QTY112 = W.QTY112, E.QTY113 = W.QTY113, E.QTY114 = W.QTY114, E.QTY115 = W.QTY115, E.QTY116 = W.QTY116, E.QTY117 = W.QTY117, E.QTY118 = W.QTY118, E.QTY119 = W.QTY119, E.QTY120 = W.QTY120
						,E.QTY121 = W.QTY121, E.QTY122 = W.QTY122, E.QTY123 = W.QTY123, E.QTY124 = W.QTY124, E.QTY125 = W.QTY125, E.QTY126 = W.QTY126, E.QTY127 = W.QTY127, E.QTY128 = W.QTY128, E.QTY129 = W.QTY129, E.QTY130 = W.QTY130
						,E.QTY131 = W.QTY131, E.QTY132 = W.QTY132, E.QTY133 = W.QTY133, E.QTY134 = W.QTY134, E.QTY135 = W.QTY135, E.QTY136 = W.QTY136, E.QTY137 = W.QTY137, E.QTY138 = W.QTY138, E.QTY139 = W.QTY139, E.QTY140 = W.QTY140
						,E.QTY141 = W.QTY141, E.QTY142 = W.QTY142, E.QTY143 = W.QTY143, E.QTY144 = W.QTY144, E.QTY145 = W.QTY145, E.QTY146 = W.QTY146, E.QTY147 = W.QTY147, E.QTY148 = W.QTY148, E.QTY149 = W.QTY149, E.QTY150 = W.QTY150
						,E.QTY151 = W.QTY151, E.QTY152 = W.QTY152, E.QTY153 = W.QTY153, E.QTY154 = W.QTY154, E.QTY155 = W.QTY155, E.QTY156 = W.QTY156, E.QTY157 = W.QTY157, E.QTY158 = W.QTY158, E.QTY159 = W.QTY159, E.QTY160 = W.QTY160
						,E.QTY161 = W.QTY161, E.QTY162 = W.QTY162, E.QTY163 = W.QTY163, E.QTY164 = W.QTY164, E.QTY165 = W.QTY165, E.QTY166 = W.QTY166, E.QTY167 = W.QTY167, E.QTY168 = W.QTY168, E.QTY169 = W.QTY169, E.QTY170 = W.QTY170
						,E.QTY171 = W.QTY171, E.QTY172 = W.QTY172, E.QTY173 = W.QTY173, E.QTY174 = W.QTY174, E.QTY175 = W.QTY175, E.QTY176 = W.QTY176, E.QTY177 = W.QTY177, E.QTY178 = W.QTY178, E.QTY179 = W.QTY179, E.QTY180 = W.QTY180
						,E.QTY181 = W.QTY181, E.QTY182 = W.QTY182, E.QTY183 = W.QTY183, E.QTY184 = W.QTY184, E.QTY185 = W.QTY185, E.QTY186 = W.QTY186, E.QTY187 = W.QTY187, E.QTY188 = W.QTY188, E.QTY189 = W.QTY189, E.QTY190 = W.QTY190
						,E.QTY191 = W.QTY191, E.QTY192 = W.QTY192, E.QTY193 = W.QTY193, E.QTY194 = W.QTY194, E.QTY195 = W.QTY195, E.QTY196 = W.QTY196, E.QTY197 = W.QTY197, E.QTY198 = W.QTY198, E.QTY199 = W.QTY199, E.QTY200 = W.QTY200
						,E.QTY201 = W.QTY201, E.QTY202 = W.QTY202, E.QTY203 = W.QTY203, E.QTY204 = W.QTY204, E.QTY205 = W.QTY205, E.QTY206 = W.QTY206, E.QTY207 = W.QTY207, E.QTY208 = W.QTY208, E.QTY209 = W.QTY209, E.QTY210 = W.QTY210
						,E.QTY211 = W.QTY211, E.QTY212 = W.QTY212, E.QTY213 = W.QTY213, E.QTY214 = W.QTY214, E.QTY215 = W.QTY215, E.QTY216 = W.QTY216, E.QTY217 = W.QTY217, E.QTY218 = W.QTY218, E.QTY219 = W.QTY219, E.QTY220 = W.QTY220
						,E.QTY221 = W.QTY221, E.QTY222 = W.QTY222, E.QTY223 = W.QTY223, E.QTY224 = W.QTY224, E.QTY225 = W.QTY225, E.QTY226 = W.QTY226, E.QTY227 = W.QTY227, E.QTY228 = W.QTY228, E.QTY229 = W.QTY229, E.QTY230 = W.QTY230
						,E.QTY231 = W.QTY231, E.QTY232 = W.QTY232, E.QTY233 = W.QTY233, E.QTY234 = W.QTY234, E.QTY235 = W.QTY235, E.QTY236 = W.QTY236, E.QTY237 = W.QTY237, E.QTY238 = W.QTY238, E.QTY239 = W.QTY239, E.QTY240 = W.QTY240
						,E.QTY241 = W.QTY241, E.QTY242 = W.QTY242, E.QTY243 = W.QTY243, E.QTY244 = W.QTY244, E.QTY245 = W.QTY245, E.QTY246 = W.QTY246, E.QTY247 = W.QTY247, E.QTY248 = W.QTY248, E.QTY249 = W.QTY249, E.QTY250 = W.QTY250
						,E.QTY251 = W.QTY251, E.QTY252 = W.QTY252, E.QTY253 = W.QTY253, E.QTY254 = W.QTY254, E.QTY255 = W.QTY255, E.QTY256 = W.QTY256, E.QTY257 = W.QTY257, E.QTY258 = W.QTY258, E.QTY259 = W.QTY259, E.QTY260 = W.QTY260
						,E.QTY261 = W.QTY261, E.QTY262 = W.QTY262, E.QTY263 = W.QTY263, E.QTY264 = W.QTY264, E.QTY265 = W.QTY265, E.QTY266 = W.QTY266, E.QTY267 = W.QTY267, E.QTY268 = W.QTY268, E.QTY269 = W.QTY269, E.QTY270 = W.QTY270
						,E.QTY271 = W.QTY271, E.QTY272 = W.QTY272, E.QTY273 = W.QTY273, E.QTY274 = W.QTY274, E.QTY275 = W.QTY275, E.QTY276 = W.QTY276, E.QTY277 = W.QTY277, E.QTY278 = W.QTY278, E.QTY279 = W.QTY279, E.QTY280 = W.QTY280
						,E.QTY281 = W.QTY281, E.QTY282 = W.QTY282, E.QTY283 = W.QTY283, E.QTY284 = W.QTY284, E.QTY285 = W.QTY285, E.QTY286 = W.QTY286, E.QTY287 = W.QTY287, E.QTY288 = W.QTY288, E.QTY289 = W.QTY289, E.QTY290 = W.QTY290
						,E.QTY291 = W.QTY291, E.QTY292 = W.QTY292, E.QTY293 = W.QTY293, E.QTY294 = W.QTY294, E.QTY295 = W.QTY295, E.QTY296 = W.QTY296, E.QTY297 = W.QTY297, E.QTY298 = W.QTY298, E.QTY299 = W.QTY299, E.QTY300 = W.QTY300
						,E.QTY301 = W.QTY301, E.QTY302 = W.QTY302, E.QTY303 = W.QTY303, E.QTY304 = W.QTY304, E.QTY305 = W.QTY305, E.QTY306 = W.QTY306, E.QTY307 = W.QTY307, E.QTY308 = W.QTY308, E.QTY309 = W.QTY309, E.QTY310 = W.QTY310
						,E.QTY311 = W.QTY311, E.QTY312 = W.QTY312, E.QTY313 = W.QTY313, E.QTY314 = W.QTY314, E.QTY315 = W.QTY315, E.QTY316 = W.QTY316, E.QTY317 = W.QTY317, E.QTY318 = W.QTY318, E.QTY319 = W.QTY319, E.QTY320 = W.QTY320
						,E.QTY321 = W.QTY321, E.QTY322 = W.QTY322, E.QTY323 = W.QTY323, E.QTY324 = W.QTY324, E.QTY325 = W.QTY325, E.QTY326 = W.QTY326, E.QTY327 = W.QTY327, E.QTY328 = W.QTY328, E.QTY329 = W.QTY329, E.QTY330 = W.QTY330
						,E.QTY331 = W.QTY331, E.QTY332 = W.QTY332, E.QTY333 = W.QTY333, E.QTY334 = W.QTY334, E.QTY335 = W.QTY335, E.QTY336 = W.QTY336, E.QTY337 = W.QTY337, E.QTY338 = W.QTY338, E.QTY339 = W.QTY339, E.QTY340 = W.QTY340
						,E.QTY341 = W.QTY341, E.QTY342 = W.QTY342, E.QTY343 = W.QTY343, E.QTY344 = W.QTY344, E.QTY345 = W.QTY345, E.QTY346 = W.QTY346, E.QTY347 = W.QTY347, E.QTY348 = W.QTY348, E.QTY349 = W.QTY349, E.QTY350 = W.QTY350
						,E.QTY351 = W.QTY351, E.QTY352 = W.QTY352, E.QTY353 = W.QTY353, E.QTY354 = W.QTY354, E.QTY355 = W.QTY355, E.QTY356 = W.QTY356, E.QTY357 = W.QTY357, E.QTY358 = W.QTY358, E.QTY359 = W.QTY359, E.QTY360 = W.QTY360
						,E.QTY361 = W.QTY361, E.QTY362 = W.QTY362, E.QTY363 = W.QTY363, E.QTY364 = W.QTY364

						,WQTY01 = @p_WQTY01  ,WQTY02  = @p_WQTY02  ,WQTY03  = @p_WQTY03  ,WQTY04  = @p_WQTY04  ,WQTY05  = @p_WQTY05  ,WQTY06  = @p_WQTY06  ,WQTY07  = @p_WQTY07  ,WQTY08  = @p_WQTY08  ,WQTY09  = @p_WQTY09  ,WQTY10  = @p_WQTY10
                        ,WQTY11 = @p_WQTY11  ,WQTY12  = @p_WQTY12  ,WQTY13  = @p_WQTY13  ,WQTY14  = @p_WQTY14  ,WQTY15  = @p_WQTY15  ,WQTY16  = @p_WQTY16  ,WQTY17  = @p_WQTY17  ,WQTY18  = @p_WQTY18  ,WQTY19  = @p_WQTY19  ,WQTY20  = @p_WQTY20
                        ,WQTY21 = @p_WQTY21  ,WQTY22  = @p_WQTY22  ,WQTY23  = @p_WQTY23  ,WQTY24  = @p_WQTY24  ,WQTY25  = @p_WQTY25  ,WQTY26  = @p_WQTY26  ,WQTY27  = @p_WQTY27  ,WQTY28  = @p_WQTY28  ,WQTY29  = @p_WQTY29  ,WQTY30  = @p_WQTY30
                        ,WQTY31 = @p_WQTY31  ,WQTY32  = @p_WQTY32  ,WQTY33  = @p_WQTY33  ,WQTY34  = @p_WQTY34  ,WQTY35  = @p_WQTY35  ,WQTY36  = @p_WQTY36  ,WQTY37  = @p_WQTY37  ,WQTY38  = @p_WQTY38  ,WQTY39  = @p_WQTY39  ,WQTY40  = @p_WQTY40
                        ,WQTY41 = @p_WQTY41  ,WQTY42  = @p_WQTY42  ,WQTY43  = @p_WQTY43  ,WQTY44  = @p_WQTY44  ,WQTY45  = @p_WQTY45  ,WQTY46  = @p_WQTY46  ,WQTY47  = @p_WQTY47  ,WQTY48  = @p_WQTY48  ,WQTY49  = @p_WQTY49  ,WQTY50  = @p_WQTY50
                        ,WQTY51 = @p_WQTY51  ,WQTY52  = @p_WQTY52 
                        ,LAST_UPDATED_BY    = @v_batch_user
                        ,LAST_UPDATE_DATE   = GETDATE()
                        ,ATTRIBUTE2         = 'Y'
				;

			  IF  ISNULL(@p_dailyQty, '') <> '' 
			  BEGIN
				set @sql = 'update SCP_XLS_PSI_GLOBAL ' + CHAR(10)
				set @sql =@SQL + ' SET ' +  @p_dailyQty + CHAR(10)
				set @sql =@SQL + FORMATMESSAGE(' WHERE DIVISION_ID = ''%s''', @v_batch_division_id) + CHAR(10)
				set @sql =@SQL + FORMATMESSAGE(' AND XLS_KEY1 = %d ', @v_batch_xls_key1) + CHAR(10)  --구문 오류 회피(KSK)
				set @sql =@SQL + FORMATMESSAGE(' AND CREATE_FROM_YYYYMMDD = ''%s''', @p_create_from_yyyymmdd) + CHAR(10)		                				
				IF @P_IS_DEBUG = 1 SELECT @SQL AS "SQL"				 
				exec (@sql)			
			   END

				IF OBJECT_ID('tempdb..#WORKING_TBL') IS NOT NULL	
					DROP TABLE #WORKING_TBL;
   
				IF OBJECT_ID('tempdb..#WEEK_QTY_TBL') IS NOT NULL	
					DROP TABLE #WEEK_QTY_TBL;

			END;				


            --IF @v_batch_measure IN  ('PACK_PROD','CELL_CHAR_PLAN','CELL_PROD')    -- CELL_CHAR_PLAN SCP_XLS_PSI_GLOBAL 테이블에 저장만 처리함.
			IF @v_batch_measure IN  ('CELL_CHAR_PLAN')    -- CELL_CHAR_PLAN SCP_XLS_PSI_GLOBAL 테이블에 저장만 처리함.
               BEGIN
                     UPDATE DBO.SCP_XLS_PSI_GLOBAL
                        SET  QTY001 = @p_WQTY01/7 ,QTY002  = @p_WQTY01/7  ,QTY003 = @p_WQTY01/7 ,QTY004 = @p_WQTY01/7 ,QTY005  = @p_WQTY01/7 ,QTY006  = @p_WQTY01/7 ,QTY007 = ((@p_WQTY01/7)+(@p_WQTY01%7))
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

                            ,WQTY01 = @p_WQTY01  ,WQTY02  = @p_WQTY02  ,WQTY03  = @p_WQTY03  ,WQTY04  = @p_WQTY04  ,WQTY05  = @p_WQTY05  ,WQTY06  = @p_WQTY06  ,WQTY07  = @p_WQTY07 ,WQTY08  = @p_WQTY08  ,WQTY09  = @p_WQTY09  ,WQTY10  = @p_WQTY10
                            ,WQTY11 = @p_WQTY11  ,WQTY12  = @p_WQTY12  ,WQTY13  = @p_WQTY13  ,WQTY14  = @p_WQTY14  ,WQTY15  = @p_WQTY15  ,WQTY16  = @p_WQTY16  ,WQTY17  = @p_WQTY17 ,WQTY18  = @p_WQTY18  ,WQTY19  = @p_WQTY19  ,WQTY20  = @p_WQTY20
                            ,WQTY21 = @p_WQTY21  ,WQTY22  = @p_WQTY22  ,WQTY23  = @p_WQTY23  ,WQTY24  = @p_WQTY24  ,WQTY25  = @p_WQTY25  ,WQTY26  = @p_WQTY26  ,WQTY27  = @p_WQTY27 ,WQTY28  = @p_WQTY28  ,WQTY29  = @p_WQTY29  ,WQTY30  = @p_WQTY30
                            ,WQTY31 = @p_WQTY31  ,WQTY32  = @p_WQTY32  ,WQTY33  = @p_WQTY33  ,WQTY34  = @p_WQTY34  ,WQTY35  = @p_WQTY35  ,WQTY36  = @p_WQTY36  ,WQTY37  = @p_WQTY37 ,WQTY38  = @p_WQTY38  ,WQTY39  = @p_WQTY39  ,WQTY40  = @p_WQTY40
                            ,WQTY41 = @p_WQTY41  ,WQTY42  = @p_WQTY42  ,WQTY43  = @p_WQTY43  ,WQTY44  = @p_WQTY44  ,WQTY45  = @p_WQTY45  ,WQTY46  = @p_WQTY46  ,WQTY47  = @p_WQTY47 ,WQTY48  = @p_WQTY48  ,WQTY49  = @p_WQTY49  ,WQTY50  = @p_WQTY50
                            ,WQTY51 = @p_WQTY51  ,WQTY52  = @p_WQTY52 


                            ,LAST_UPDATED_BY    = @v_batch_user
                            ,LAST_UPDATE_DATE   = GETDATE()
                      WHERE 0 = 0
                        AND DIVISION_ID          = @v_batch_division_id
                        AND PLAN_START_YYYYMMDD  = @v_batch_plan_start_yyyymmdd
						AND CREATE_FROM_YYYYMMDD = @v_batch_create_from_yyyymmdd
                        AND SEQ                  = @v_batch_seq
                        AND XLS_KEY1             = @v_batch_xls_key1
						AND MEASURE              = @v_batch_measure
						;
               END

			 
			-------------------------------------------------------------------------------------------------------------
			-- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - 형교환 Model Change 저장 - start
			--
            IF @v_batch_measure IN  ('PACK_MODEL_CHANGE','CELL_MODEL_CHANGE')   -- PACK_MODEL_CHANGE, CELL_MODEL_CHANGE 만 처리함
              BEGIN 
					declare @v_from_site            nvarchar(12) =  '';
					declare @v_operation_id         nvarchar(12) =  '';
					declare @v_prod_line            nvarchar(12) =  '';
					declare @p_plan_id              nvarchar(12) =  '';
					declare @v_version_id           nvarchar(12) =  '';

					SELECT  @v_from_site    = FROM_SITE 
					       ,@v_operation_id = ATTRIBUTE9
						   ,@v_prod_line    = PROD_LINE
					  FROM SCP_XLS_PSI_GLOBAL A WITH (NOLOCK) 
					 WHERE CREATE_FROM_YYYYMMDD = @v_batch_create_from_yyyymmdd 
					   AND DIVISION_ID          = @v_batch_division_id			-- 2022.03.23	KSW	GM JV 반영
					   AND XLS_KEY1				= @v_batch_xls_key1
					  ;

					--SELECT @v_from_site, @v_operation_id, @v_prod_line

					SELECT @p_plan_id = max(plan_id) 
					  FROM dbo.SCM_MST_SITE_ENG p WITH(NOLOCK) 
					 WHERE division_id = @v_batch_division_id 
					   AND plan_id < 9999
					   ;

					--SELECT @p_plan_id;

					SELECT @v_version_id = VERSION_ID
					  FROM SCP_PLAN_VERSION_V WITH(NOLOCK)
					 WHERE plan_id     = @p_plan_id
					   AND DIVISION_ID = @v_batch_division_id
					   AND PLAN_TYPE   = @v_batch_plan_type
					   AND PLAN_SEQ    = @v_batch_seq
					;

					-- 시뮬레이터 data 업데이트
					-- 동일한 형교환을 사용하는시뮬레이터 data 업데이트 (FROM_SITE, PROD_LINE, ATTRIBUTE9(OPERATION_ID)
                     UPDATE DBO.SCP_XLS_PSI_GLOBAL
                        SET  QTY001 = @p_WQTY01/7 ,QTY002  = @p_WQTY01/7  ,QTY003 = @p_WQTY01/7 ,QTY004 = @p_WQTY01/7 ,QTY005  = @p_WQTY01/7 ,QTY006  = @p_WQTY01/7 ,QTY007 = ((@p_WQTY01/7)+(@p_WQTY01%7))
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

                            ,WQTY01 = @p_WQTY01  ,WQTY02  = @p_WQTY02  ,WQTY03  = @p_WQTY03  ,WQTY04  = @p_WQTY04  ,WQTY05  = @p_WQTY05  ,WQTY06  = @p_WQTY06  ,WQTY07  = @p_WQTY07 ,WQTY08  = @p_WQTY08  ,WQTY09  = @p_WQTY09  ,WQTY10  = @p_WQTY10
                            ,WQTY11 = @p_WQTY11  ,WQTY12  = @p_WQTY12  ,WQTY13  = @p_WQTY13  ,WQTY14  = @p_WQTY14  ,WQTY15  = @p_WQTY15  ,WQTY16  = @p_WQTY16  ,WQTY17  = @p_WQTY17 ,WQTY18  = @p_WQTY18  ,WQTY19  = @p_WQTY19  ,WQTY20  = @p_WQTY20
                            ,WQTY21 = @p_WQTY21  ,WQTY22  = @p_WQTY22  ,WQTY23  = @p_WQTY23  ,WQTY24  = @p_WQTY24  ,WQTY25  = @p_WQTY25  ,WQTY26  = @p_WQTY26  ,WQTY27  = @p_WQTY27 ,WQTY28  = @p_WQTY28  ,WQTY29  = @p_WQTY29  ,WQTY30  = @p_WQTY30
                            ,WQTY31 = @p_WQTY31  ,WQTY32  = @p_WQTY32  ,WQTY33  = @p_WQTY33  ,WQTY34  = @p_WQTY34  ,WQTY35  = @p_WQTY35  ,WQTY36  = @p_WQTY36  ,WQTY37  = @p_WQTY37 ,WQTY38  = @p_WQTY38  ,WQTY39  = @p_WQTY39  ,WQTY40  = @p_WQTY40
                            ,WQTY41 = @p_WQTY41  ,WQTY42  = @p_WQTY42  ,WQTY43  = @p_WQTY43  ,WQTY44  = @p_WQTY44  ,WQTY45  = @p_WQTY45  ,WQTY46  = @p_WQTY46  ,WQTY47  = @p_WQTY47 ,WQTY48  = @p_WQTY48  ,WQTY49  = @p_WQTY49  ,WQTY50  = @p_WQTY50
                            ,WQTY51 = @p_WQTY51  ,WQTY52  = @p_WQTY52 

                            ,LAST_UPDATED_BY    = @v_batch_user
                            ,LAST_UPDATE_DATE   = GETDATE()
                      WHERE 0 = 0
                        AND DIVISION_ID          = @v_batch_division_id
                        AND PLAN_START_YYYYMMDD  = @v_batch_plan_start_yyyymmdd
						AND CREATE_FROM_YYYYMMDD = @v_batch_create_from_yyyymmdd
                        AND SEQ                  = @v_batch_seq 
						AND MEASURE              = @v_batch_measure
						AND FROM_SITE            = @v_from_site
						AND PROD_LINE            = @v_prod_line
						AND ATTRIBUTE9           = @v_operation_id
						;

					-- 형교환(Model Change) 정보를 capa 테이블에 저장하기 위해서 임시테이블 생성 (un pivot)
				   IF OBJECT_ID('tempdb..#SCM_WORK_CALENDAR_M') IS NOT NULL	
					  DROP TABLE #SCM_WORK_CALENDAR_M

					SELECT @v_version_id AS VERSION_ID
					      ,X.COMPANY_ID
					      ,X.DIVISION_ID
						  ,X.SITE_ID
						  ,X.PLANT_ID
						  ,X.FACTORY_ID
						  ,X.ATTRIBUTE9 AS OPERATION_ID
						  ,X.PROD_LINE  AS LINE_ID
						  ,'-'          AS ELECTRODE_TYPE
						  ,Y.YYYYMMDD   AS WORK_DATE
						  ,'XC031'      AS LOSS_CODE
						  ,QTY          AS TIME_TERM
						  ,0.0          AS TIME_TERM_RESULT
					INTO #SCM_WORK_CALENDAR_M
					FROM
					  (
					  SELECT  A.* --
					         ,B.COMPANY_ID
							 ,B.SITE_ID
							 ,B.PLANT_ID
							 ,C.FACTORY_ID
					   FROM SCP_XLS_PSI_GLOBAL A WITH (NOLOCK),
					        (SELECT TOP 1 COMPANY_ID, SITE_ID, PLANT_ID FROM dbo.SCM_MST_SITE_ENG B WITH (NOLOCK) WHERE B.DIVISION_ID = @v_batch_division_id AND B.PLAN_ID =  @p_plan_id AND PLAN_SEQ = @v_batch_seq AND B.SCM_SITE_ID = @v_from_site) B,
							(SELECT TOP 1 FACTORY_ID FROM SCP_MST_WORKING_TIME WITH (NOLOCK) WHERE DIVISION_ID = @v_batch_division_id AND PLANT_SITE_ID = @v_from_site AND OPERATION_ID = @v_operation_id AND LINE_ID = @v_prod_line ) C
					   WHERE 0 = 0
						AND A.DIVISION_ID          = @v_batch_division_id
						AND A.PLAN_START_YYYYMMDD  = @v_batch_plan_start_yyyymmdd
						AND A.CREATE_FROM_YYYYMMDD = @v_batch_create_from_yyyymmdd
						AND A.SEQ                  = @v_batch_seq
						AND A.XLS_KEY1             = @v_batch_xls_key1 --43 
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
								  WHERE A.BASIS_YYYYMMDD BETWEEN @v_batch_create_from_yyyymmdd AND CONVERT(VARCHAR(8), DATEADD(day, 364, @v_batch_create_from_yyyymmdd), 112)
								 -- WHERE A.BASIS_YYYYMMDD     >= @v_batch_create_from_yyyymmdd
									--AND A.BASIS_YYYYMMDD     <  @v_batch_create_to_yyyymmdd
								) Y
					ON X.YYYYMMDD_COLUMN = Y.YYYYMMDD_COLUMN
					;

				   -- current 정보 저장
				   MERGE INTO DBO.SCM_WORK_CALENDAR_M_SN AS X  
					USING (SELECT 
								   COMPANY_ID
								  ,DIVISION_ID
								  ,SITE_ID
								  ,PLANT_ID
								  ,FACTORY_ID
								  ,OPERATION_ID
								  ,LINE_ID
								  ,ELECTRODE_TYPE
								  ,WORK_DATE
								  ,LOSS_CODE
								  ,TIME_TERM
								  ,TIME_TERM_RESULT
							FROM #SCM_WORK_CALENDAR_M WITH (NOLOCK)
						  ) AS Y
					ON 0 = 0
					AND X.DIVISION_ID               = Y.DIVISION_ID
					AND X.SITE_ID                   = Y.SITE_ID
					AND X.PLANT_ID                  = Y.PLANT_ID
					AND X.OPERATION_ID              = Y.OPERATION_ID
					AND X.LINE_ID                   = Y.LINE_ID
					AND X.WORK_DATE                 = convert(datetime, Y.WORK_DATE)
					AND X.LOSS_CODE                 = Y.LOSS_CODE
					AND X.COMPANY_ID				= Y.COMPANY_ID

					WHEN MATCHED  THEN 
					UPDATE 
					  SET  X.TIME_TERM   = Y.TIME_TERM
						  ,X.UPDATE_ID   = @v_batch_user
						  ,X.UPDATE_TIME = GETDATE()

					WHEN NOT MATCHED  THEN 
                 
					  INSERT (
								 COMPANY_ID
								,DIVISION_ID
								,SITE_ID
								,PLANT_ID
								,FACTORY_ID
								,OPERATION_ID
								,LINE_ID
								,ELECTRODE_TYPE
								,WORK_DATE
								,LOSS_CODE
								,TIME_TERM
								,TIME_TERM_RESULT
								,INSERT_ID
								,INSERT_TIME
								,UPDATE_ID
								,UPDATE_TIME
							)
					 VALUES (
							     Y.COMPANY_ID
								,Y.DIVISION_ID
								,Y.SITE_ID
								,Y.PLANT_ID
								,Y.FACTORY_ID
								,Y.OPERATION_ID
								,Y.LINE_ID
								,Y.ELECTRODE_TYPE
								,Y.WORK_DATE
								,Y.LOSS_CODE
								,Y.TIME_TERM
								,Y.TIME_TERM_RESULT
								,@v_batch_user
								,GETDATE()
								,@v_batch_user
								,GETDATE()
							)
							;  

			  END
			-- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - 형교환 Model Change 저장 - end



            -------------------------------------------------------------------------------------------------------------         
            -- SOURCE TABLE 반영
            -------------------------------------------------------------------------------------------------------------   

            SET @v_batch_user_sim = @v_batch_user + '[SIMULATION]' -- UI 작업자와 시물레이션 작업자를 구분하기 위해서
                          
            -------------------------------------------------------------------------------------------------------------         
            -- SCP_ANL_SHIPMENT_PLAN_FG UPDATE
            -- SHIP_PLAN  --> SCP_ANL_SHIPMENT_PLAN_FG.MEASURE 'SHIP_PLAN_AMEND' UPDATE
            -------------------------------------------------------------------------------------------------------------

		
            IF @v_batch_measure IN  ('SHIP_PLAN')   -- FG
              BEGIN 			  
              
            -- SHIP_PLAN
               IF OBJECT_ID('tempdb..#SCP_ANL_SHIPMENT_PLAN_FG') IS NOT NULL	
	              DROP TABLE #SCP_ANL_SHIPMENT_PLAN_FG

                SELECT X.DIVISION_ID
					  ,X.PLAN_START_YYYYMMDD
					  ,X.PLAN_TYPE
					  ,X.SEQ
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
                      ,@v_batch_division_id  AS ORIGIN_FROM_DIVISION_ID		-- 2022.03.21 :: GM JV 반영 '81' --> @v_batch_division_id 
                      ,@v_batch_division_id  AS ORIGIN_TO_DIVISION_ID			-- 2022.03.21 :: GM JV 반영 '81' --> @v_batch_division_id 
                      ,'' AS ELECTRODE_TYPE
                      ,X.ATTRIBUTE1
                      ,Y.YYYYMMDD_COLUMN
                INTO #SCP_ANL_SHIPMENT_PLAN_FG
                --FROM #DAY_SCP_XLS_PSI_GLOBAL SourceTable WITH (NOLOCK) 
				FROM SCP_XLS_PSI_GLOBAL SourceTable WITH (NOLOCK) 
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
							 WHERE A.BASIS_YYYYMMDD     BETWEEN @v_batch_create_from_yyyymmdd AND @v_batch_create_to_yyyymmdd
                              --WHERE A.BASIS_YYYYMMDD     >= @v_batch_create_from_yyyymmdd
                              --  AND A.BASIS_YYYYMMDD     <  @v_batch_create_to_yyyymmdd
                            ) Y
                ON X.YYYYMMDD_COLUMN = Y.YYYYMMDD_COLUMN
				-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - start
				WHERE Y.YYYYMMDD >= @v_bod_from
				  AND Y.YYYYMMDD <= @v_bod_to
				-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - end
				  AND X.DIVISION_ID          = @v_batch_division_id
				  AND X.PLAN_START_YYYYMMDD  = @v_batch_plan_start_yyyymmdd
				  AND X.CREATE_FROM_YYYYMMDD = @v_batch_create_from_yyyymmdd
				  AND X.SEQ                  = @v_batch_seq
				  AND X.XLS_KEY1             = @v_batch_xls_key1  
             ;

			 
			 --SELECT '#SCP_ANL_SHIPMENT_PLAN_FG'  +  @v_batch_create_to_yyyymmdd   TN,  * FROM #SCP_ANL_SHIPMENT_PLAN_FG--TEST

            -------------------------------------------------------------------------------------------------------------         
            -- FROZEN 구간 UPDATE
            -- PLANT SITE(SCM_MST_SITE)의 SHIP_FROZEN ,PROD_FROZEN를 주단위로 변경하여 FROZEN 구간을 저장 내역에서 삭제한다.
            -------------------------------------------------------------------------------------------------------------

			------------------------------------------------------------------------------------------------------------- start
			-- 2020.10.16   KSW            C20201016-000200 :: GSCM 시스템의 RTF 적확도 개선을 위한 SSP구간 Shipment 수량 변경 기능 요청 건
			-- SHIP_PLAN 저장시 Frozen 구간 체크하지 않음 (PR, MA plan 한함)
			-- 주석처리 :: Frozen 구간에 속한 플랜 data 를 삭제하지 않음
			--
              --IF @v_batch_plan_type IN  ('PR','MA','SE')  
              --BEGIN
              --  DELETE  FROM #SCP_ANL_SHIPMENT_PLAN_FG
              --          FROM #SCP_ANL_SHIPMENT_PLAN_FG X
              --        INNER JOIN #SCM_MST_SITE Y
              --           ON Y.DIVISION_ID = X.DIVISION_ID
              --          AND Y.SCM_SITE_ID = X.FROM_SITE
              --        WHERE 
              --            X.YYYYMMDD < Y.SHIP_FROZEN_WEEK_DAY;
              --END

			  ------------------------------------------------------------------------------------------------------------- end
			  -- 2020.10.16   KSW            C20201016-000200 :: GSCM 시스템의 RTF 적확도 개선을 위한 SSP구간 Shipment 수량 변경 기능 요청 건
			  ------------------------------------------------------------------------------------------------------------- 
			  
               MERGE INTO SCP_ANL_SHIPMENT_PLAN_FG AS X  
			    USING  #SCP_ANL_SHIPMENT_PLAN_FG AS Y WITH(NOLOCK)
                ON 0 = 0
                AND X.DIVISION_ID               = Y.DIVISION_ID				--@v_batch_division_id			--  2021.10.25 튜닝개선요청에 따른 변경
                AND X.PLAN_START_YYYYMMDD       = Y.PLAN_START_YYYYMMDD		--@@v_batch_plan_start_yyyymmdd
                AND X.PLAN_TYPE                 = Y.PLAN_TYPE				--@v_batch_plan_type
                AND X.SEQ                       = Y.SEQ						--@v_batch_seq
                
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
                      --,X.CREATED_BY         = @v_batch_user_sim
                      --,X.CREATION_DATE      = GETDATE()
                      ,X.LAST_UPDATED_BY    = @v_batch_user_sim
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
                          ,@v_batch_user_sim
                          ,GETDATE()
                          ,@v_batch_user_sim
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
                        ,@v_batch_user_sim   AS CREATED_BY
                        ,GETDATE()    AS CREATION_DATE
                        ,@v_batch_user_sim   AS LAST_UPDATED_BY
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
                             ,X.LAST_UPDATED_BY   = @v_batch_user_sim
                             ,X.LAST_UPDATE_DATE  = GETDATE()
                          FROM SCP_ANL_SHIPMENT_PLAN_FIX  X WITH (NOLOCK)     -- FIX_ID, DIVISION_ID, BIZ_TYPE, ITEM_ID, TO_SITE, FROM_SITE, BOD_ID, YYYYMMDD
                          INNER JOIN #SCP_ANL_SHIPMENT_PLAN_FG Y WITH (NOLOCK)
                          ON 0 = 0
                          AND X.DIVISION_ID = Y.DIVISION_ID
                          AND X.BIZ_TYPE    = Y.BIZ_TYPE
                          AND X.PROJECT_CODE= Y.PROJECT_CODE
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
                          ,@v_batch_user_sim   AS CREATED_BY
                          ,GETDATE()    AS CREATION_DATE
                          ,@v_batch_user_sim   AS LAST_UPDATED_BY
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
                    AND X.PROJECT_CODE= Y.PROJECT_CODE
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
            IF @v_batch_measure IN  ('SEMI_SHIP_PLAN')   -- SEMI
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
                      ,@v_batch_division_id AS ORIGIN_FROM_DIVISION_ID		-- 2022.03.21 :: GM JV 반영 '81' --> @v_batch_division_id 
                      ,@v_batch_division_id AS ORIGIN_TO_DIVISION_ID			-- 2022.03.21 :: GM JV 반영 '81' --> @v_batch_division_id 
                      ,'' AS ELECTRODE_TYPE
                      ,X.ATTRIBUTE1
                      ,Y.YYYYMMDD_COLUMN
                INTO #SCP_ANL_SHIPMENT_PLAN_SEMI
                --FROM #DAY_SCP_XLS_PSI_GLOBAL SourceTable WITH (NOLOCK) 
				FROM SCP_XLS_PSI_GLOBAL SourceTable WITH (NOLOCK) 
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
							  WHERE A.BASIS_YYYYMMDD     BETWEEN @v_batch_create_from_yyyymmdd AND @v_batch_create_to_yyyymmdd
                              --WHERE A.BASIS_YYYYMMDD     >= @v_batch_create_from_yyyymmdd
                              --  AND A.BASIS_YYYYMMDD     <  @v_batch_create_to_yyyymmdd
                            ) Y
                ON X.YYYYMMDD_COLUMN = Y.YYYYMMDD_COLUMN
				-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - start
				WHERE Y.YYYYMMDD >= @v_bod_from
				  AND Y.YYYYMMDD <= @v_bod_to
				-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - end
				  AND X.DIVISION_ID          = @v_batch_division_id
				  AND X.PLAN_START_YYYYMMDD  = @v_batch_plan_start_yyyymmdd
				  AND X.CREATE_FROM_YYYYMMDD = @v_batch_create_from_yyyymmdd
				  AND X.SEQ                  = @v_batch_seq
				  AND X.XLS_KEY1             = @v_batch_xls_key1  
				  AND X.MEASURE              IN  ('SEMI_SHIP_PLAN')   
                ;
                
                -------------------------------------------------------------------------------------------------------------         
                -- FROZEN 구간 UPDATE
                -- PLANT SITE(SCM_MST_SITE)의 SHIP_FROZEN ,PROD_FROZEN를 주단위로 변경하여 FROZEN 구간을 저장 내역에서 삭제한다.
                -------------------------------------------------------------------------------------------------------------
				-- 2021.12.06 SEMI SHIP PLAN 에 대한 PR/MA Frozen 구간해제
                --IF @v_batch_plan_type IN  ('PR','MA','SE')  
                --BEGIN
                --  DELETE  FROM #SCP_ANL_SHIPMENT_PLAN_SEMI
                --          FROM #SCP_ANL_SHIPMENT_PLAN_SEMI X
                --        INNER JOIN #SCM_MST_SITE Y
                --           ON Y.DIVISION_ID = X.DIVISION_ID
                --          AND Y.SCM_SITE_ID = X.FROM_SITE
                --        WHERE 
                --            X.YYYYMMDD < Y.SHIP_FROZEN_WEEK_DAY;
                --END

               MERGE INTO SCP_ANL_SHIPMENT_PLAN_SEMI AS X  
                USING #SCP_ANL_SHIPMENT_PLAN_SEMI Y WITH (NOLOCK)
                ON 0 = 0
                AND X.DIVISION_ID         = Y.DIVISION_ID			--@v_batch_division_id	-- 2021.10.25 튜닝개선요청에 따른 변경
                AND X.PLAN_START_YYYYMMDD = Y.PLAN_START_YYYYMMDD	--@v_batch_plan_start_yyyymmdd
                AND X.PLAN_TYPE           = Y.PLAN_TYPE				--@v_batch_plan_type
                AND X.SEQ                 = Y.SEQ					--@v_batch_seq
                
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
                      --,X.CREATED_BY         = @v_batch_user_sim
                      --,X.CREATION_DATE      = GETDATE()
                      ,X.LAST_UPDATED_BY    = @v_batch_user_sim
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
                          ,@v_batch_user_sim
                          ,GETDATE()
                          ,@v_batch_user_sim
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
                        ,@v_batch_user_sim   AS CREATED_BY
                        ,GETDATE()    AS CREATION_DATE
                        ,@v_batch_user_sim   AS LAST_UPDATED_BY
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
                          ,@v_batch_user_sim   AS CREATED_BY
                          ,GETDATE()    AS CREATION_DATE
                          ,@v_batch_user_sim   AS LAST_UPDATED_BY
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

            IF @v_batch_measure IN  ('PACK_PROD','CELL_PROD')   
              BEGIN 
 
               IF OBJECT_ID('tempdb..#SCP_ANL_PRODUCTION_PLAN') IS NOT NULL	
	              DROP TABLE #SCP_ANL_PRODUCTION_PLAN

				CREATE TABLE #SCP_ANL_PRODUCTION_PLAN(
					DIVISION_ID				NVARCHAR(50)
					, PLAN_START_YYYYMMDD	NVARCHAR(8)
					, PLAN_TYPE				NVARCHAR(10)
					, SEQ					BIGINT
					, OPERATION_GROUP		NVARCHAR(100)
					, SCM_SITE_ID			NVARCHAR(50)
					, ITEM_ID				NVARCHAR(100)
					, LINE_ID				NVARCHAR(50)
					, OPERATION_ID			NVARCHAR(100)
					, MEASURE				NVARCHAR(50)
					, YYYYMMDD				NVARCHAR(8)
					, QTY					INT
					, ORIGIN_DIVISION_ID	NVARCHAR(50)
					, ELECTRODE_TYPE		NVARCHAR(50)
					, CELL_QTY				INT
					, YYYYMMDD_COLUMN		NVARCHAR(50)
				);

				insert INTO #SCP_ANL_PRODUCTION_PLAN
                SELECT X.DIVISION_ID
					  , X.PLAN_START_YYYYMMDD
					  , X.PLAN_TYPE
					  , X.SEQ
                      ,X.OPERATION_GROUP
--                      ,X.CELL_ITEM_ID
                      ,X.FROM_SITE AS SCM_SITE_ID
                      ,X.ITEM_ID
                      ,X.PROD_LINE AS LINE_ID
                      ,X.ATTRIBUTE9 AS OPERATION_ID
                      ,'PROD_PLAN_AMEND' AS MEASURE
                      ,Y.YYYYMMDD AS YYYYMMDD
                      ,X.QTY
                      ,X.DIVISION_ID AS ORIGIN_DIVISION_ID
                      ,'' AS ELECTRODE_TYPE
                      ,CELL_QTY_PACK AS CELL_QTY
                      ,Y.YYYYMMDD_COLUMN
                FROM SCP_XLS_PSI_GLOBAL SourceTable WITH (NOLOCK)  
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
							 WHERE A.BASIS_YYYYMMDD		BETWEEN @v_batch_create_from_yyyymmdd AND @v_batch_create_to_yyyymmdd
                              --WHERE A.BASIS_YYYYMMDD     >= @v_batch_create_from_yyyymmdd
                              --  AND A.BASIS_YYYYMMDD     <  @v_batch_create_to_yyyymmdd
                            ) Y
                ON X.YYYYMMDD_COLUMN = Y.YYYYMMDD_COLUMN
				WHERE 1=1
				 AND X.DIVISION_ID          = @v_batch_division_id
                 AND X.PLAN_START_YYYYMMDD  = @v_batch_plan_start_yyyymmdd
				 AND X.CREATE_FROM_YYYYMMDD = @v_batch_create_from_yyyymmdd
                 AND X.SEQ                  = @v_batch_seq
                 AND X.XLS_KEY1             = @v_batch_xls_key1 --43 
				 AND X.MEASURE              IN  ('PACK_PROD','CELL_PROD')   
                ;
                 

            -------------------------------------------------------------------------------------------------------------         
            -- FROZEN 구간 UPDATE
            -- PLANT SITE(SCM_MST_SITE)의 SHIP_FROZEN ,PROD_FROZEN를 주단위로 변경하여 FROZEN 구간을 저장 내역에서 삭제한다.
            -------------------------------------------------------------------------------------------------------------

			------------------------------------------------------------------------------------------------------------- start
			-- 2020.10.28   KSW            C20201019-000175   SCP-FP 협의사항 수정반영 요청 (화 → 수) - 자동차(81) 사업부의 경우 Final Plan 제외하고 전 구간 생산계획 수정 가능
			-- PRODUCTION_PLAN 저장시 Frozen 구간 체크하지 않음 (MA plan 한함)
			-- 주석처리 :: Frozen 구간에 속한 플랜 data 를 삭제하지 않음
			--
           --[2023.05.03	KSK		UI / Simulator에서 SE 단계에서 Prod Frozen 구간 수정 방지		 ]=========================
            IF @v_batch_plan_type IN ('SE')  
            BEGIN
              DELETE  FROM #SCP_ANL_PRODUCTION_PLAN
                      FROM #SCP_ANL_PRODUCTION_PLAN X
                    INNER JOIN #SCM_MST_SITE Y
                       ON Y.DIVISION_ID = X.DIVISION_ID
                      AND Y.SCM_SITE_ID = X.SCM_SITE_ID
                    WHERE 
                        X.YYYYMMDD < Y.PROD_FROZEN_WEEK_DAY  -- 동결구간의 익일
            END        
			--==========================================================================================================[2023.05.03]
			------------------------------------------------------------------------------------------------------------- 
			-- 2020.10.28   KSW            C20201019-000175   SCP-FP 협의사항 수정반영 요청 (화 → 수) - 자동차(81) 사업부의 경우 Final Plan 제외하고 전 구간 생산계획 수정 가능
			------------------------------------------------------------------------------------------------------------- end

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
                  FROM  
                  (   
                       MERGE INTO SCP_ANL_PRODUCTION_PLAN AS X  
                        USING #SCP_ANL_PRODUCTION_PLAN Y WITH (NOLOCK)
                        ON 0 = 0
                        AND X.DIVISION_ID         = Y.DIVISION_ID			--@v_batch_division_id			-- 2021.10.25 튜닝개선요청에 따른 변경
                        AND X.PLAN_START_YYYYMMDD = Y.PLAN_START_YYYYMMDD	--@v_batch_plan_start_yyyymmdd
                        AND X.PLAN_TYPE           = Y.PLAN_TYPE				--@v_batch_plan_type
                        AND X.SEQ                 = Y.SEQ					--@v_batch_seq
                
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
                              --,X.CREATED_BY         = @v_batch_user_sim
                              --,X.CREATION_DATE      = GETDATE()
                              ,X.LAST_UPDATED_BY    = @v_batch_user_sim
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
                                   ,Y.OPERATION_ID
                                   ,Y.MEASURE
                                   ,Y.YYYYMMDD
                                   ,Y.QTY
                                   ,Y.ORIGIN_DIVISION_ID
                                   ,Y.ELECTRODE_TYPE
                                   ,Y.CELL_QTY
                                  ,@v_batch_user_sim
                                  ,GETDATE()
                                  ,@v_batch_user_sim
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
                                     ,@v_batch_user_sim AS CREATED_BY
                                     ,GETDATE() AS CREATION_DATE
                                     ,@v_batch_user_sim AS LAST_UPDATED_BY
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
                        ,@v_batch_user_sim   AS CREATED_BY
                        ,GETDATE()    AS CREATION_DATE
                        ,@v_batch_user_sim   AS LAST_UPDATED_BY
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
                            ,X.LAST_UPDATED_BY  = @v_batch_user_sim
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
                          ,@v_batch_user_sim   AS CREATED_BY
                          ,GETDATE()    AS CREATION_DATE
                          ,@v_batch_user_sim   AS LAST_UPDATED_BY
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
                  -- 전체 임시 테이블 생성  (#SCP_XLS_PSI_GLOBAL_MODIFY)
                  -------------------------------------------------------------------------------------------------------------  
                      IF OBJECT_ID('tempdb..#SCP_XLS_PSI_GLOBAL_MODIFY') IS NOT NULL	
	                        DROP TABLE #SCP_XLS_PSI_GLOBAL_MODIFY

                    --DROP TABLE #SCP_XLS_PSI_GLOBAL_MODIFY
                    CREATE TABLE #SCP_XLS_PSI_GLOBAL_MODIFY(
	                    XLS_KEY1       INT     NOT NULL, DIVISION_ID       NVARCHAR(30)     NOT NULL, CREATE_FROM_YYYYMMDD     NVARCHAR(8)     NOT NULL,
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
                    FROM SCP_XLS_PSI_GLOBAL  WITH (NOLOCK)
                    WHERE XLS_KEY1 = @v_batch_xls_key1
					AND CREATE_FROM_YYYYMMDD = @v_batch_create_from_yyyymmdd
					AND DIVISION_ID          = @v_batch_division_id			-- 2022.03.23	KSW	GM JV 반영
					;
 
              IF @v_batch_measure <> 'CELL_CHAR_PLAN'
              BEGIN
			    IF OBJECT_ID('tempdb..#SCP_XLS_PSI_GLOBAL_MODIFY_ROW') IS NOT NULL	
	                DROP TABLE #SCP_XLS_PSI_GLOBAL_MODIFY_ROW;

	                CREATE TABLE #SCP_XLS_PSI_GLOBAL_MODIFY_ROW(
	                    YYYYMMDD       VARCHAR(20)     NOT NULL, QTY       NUMERIC (20,10)     NOT NULL, COLS_NAME     NVARCHAR(30)     NOT NULL
						);

				IF @v_batch_measure = 'SHIP_PLAN'  -- FG
				BEGIN
				INSERT INTO #SCP_XLS_PSI_GLOBAL_MODIFY_ROW
				SELECT 
				    A.YYYYMMDD
				  , A.QTY
				  , B.COLS_NAME
				  FROM SCP_ANL_SHIPMENT_PLAN_FG A
					  INNER JOIN
					  (		SELECT  ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD) AS SORT_SEQ
								, 'QTY' + REPLICATE('0', 3 - LEN(ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD) )) + CONVERT(NVARCHAR,ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD))  AS COLS_NAME
								, A.BASIS_YYYYMMDD                        AS YYYYMMDD    
								, A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 31) AS SORT_ORDER_NO           
  	  						 FROM DBO.SCM_SYS_CALENDAR_M A  WITH(NOLOCK)	     
						    WHERE A.BASIS_YYYYMMDD     BETWEEN @v_batch_create_from_yyyymmdd AND CONVERT(VARCHAR(8), DATEADD(day, 364, @v_batch_create_from_yyyymmdd), 112)		--@v_batch_create_to_yyyymmdd     
						 GROUP BY A.BASIS_YYYYMMDD  
					) B
					ON A.YYYYMMDD = B.YYYYMMDD
				WHERE 0 = 0                                  
                AND A.PLAN_START_YYYYMMDD =  @v_batch_plan_start_yyyymmdd
                AND A.PLAN_TYPE           =  @v_batch_plan_type
                AND A.SEQ                 =  @v_batch_seq
				AND A.DIVISION_ID         =  @v_batch_division_id
				AND A.YYYYMMDD            <  @v_batch_create_to_yyyymmdd
                AND A.BIZ_TYPE            =  @X_OPERATION_GROUP
                AND A.ITEM_ID             =  @X_ITEM_ID
                AND A.PROJECT_CODE        =  @X_PROJECT_CODE
                AND A.TO_SITE             =  @X_TO_SITE
                AND A.INCOTERMS           =  @X_INCOTERMS		
                AND A.FROM_SITE           =  @X_FROM_SITE	
                AND A.BOD_ID              =  @X_BOD_ID
                AND A.MEASURE             = 'SHIP_PLAN_AMEND'
				AND A.QTY				  <> 0.0

				END

				IF @v_batch_measure ='SEMI_SHIP_PLAN'  -- SEMI
				BEGIN
				INSERT INTO #SCP_XLS_PSI_GLOBAL_MODIFY_ROW
				SELECT 
				   A.YYYYMMDD
				  , A.QTY
				  , B.COLS_NAME
				  FROM SCP_ANL_SHIPMENT_PLAN_SEMI A
				  INNER JOIN
				  (		SELECT  ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD) AS SORT_SEQ
							, 'QTY' + REPLICATE('0', 3 - LEN(ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD) )) + CONVERT(NVARCHAR,ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD))  AS COLS_NAME
							, A.BASIS_YYYYMMDD                        AS YYYYMMDD    
                            , A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 31) AS SORT_ORDER_NO           
  	  	                FROM DBO.SCM_SYS_CALENDAR_M A  WITH(NOLOCK)	   
						WHERE A.BASIS_YYYYMMDD     BETWEEN @v_batch_create_from_yyyymmdd AND CONVERT(VARCHAR(8), DATEADD(day, 364, @v_batch_create_from_yyyymmdd), 112)		--@v_batch_create_to_yyyymmdd     
			                 GROUP BY A.BASIS_YYYYMMDD  
				) B
				ON A.YYYYMMDD = B.YYYYMMDD
				  WHERE 0 = 0                                 
                    AND A.DIVISION_ID         =  @v_batch_division_id
                    AND A.PLAN_START_YYYYMMDD =  @v_batch_plan_start_yyyymmdd
                    AND A.PLAN_TYPE           =  @v_batch_plan_type
                    AND A.SEQ                 =  @v_batch_seq
                    AND A.OPERATION_GROUP     =  @X_OPERATION_GROUP
                    AND A.ITEM_ID             =  @X_ITEM_ID	
                    AND A.FROM_SITE           =  @X_FROM_SITE	
                    AND A.BOD_ID              =  @X_BOD_ID
                    AND A.MEASURE             = 'SHIP_PLAN_AMEND'
                    AND A.YYYYMMDD            <  @v_batch_create_to_yyyymmdd
				    AND A.QTY				  <> 0
				END



     --               ------------------------------------------------------------------------------------------------------------- 
     --               -- 'PACK_PROD','CELL_PROD'
     --               -- PK : DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, SCM_SITE_ID, ITEM_ID, LINE_ID, OPERATION_ID, MEASURE, YYYYMMDD
     --               ------------------------------------------------------------------------------------------------------------- 
     --               DECLARE @mPROD NVARCHAR(MAX) = '';

		   --             SET @mPROD = @mPROD + ' SELECT  '''+ convert(varchar, @v_batch_xls_key1)  +''' AS XLS_KEY1  '+CHAR(10);	
					--	SET @mPROD = @mPROD + '         ,'''+ convert(varchar, @v_batch_division_id)  +''' AS DIVISION_ID  '+CHAR(10);	
					--	SET @mPROD = @mPROD + '         ,'''+ convert(varchar, @v_batch_create_from_yyyymmdd)  +''' AS CREATE_FROM_YYYYMMDD  '+CHAR(10);

		   --             SET @mPROD = @mPROD + ' 				' + @mQry_sum2 +'									      '+CHAR(10);	
  	  --              SET @mPROD = @mPROD + ' 		FROM SCP_ANL_PRODUCTION_PLAN WITH (NOLOCK)  '+CHAR(10);	
     --               SET @mPROD = @mPROD + ' 		WHERE 0 = 0                                 '+CHAR(10);	
     --               SET @mPROD = @mPROD + ' 		AND DIVISION_ID         =  '''+ @v_batch_division_id  +'''' +CHAR(10);	
     --               SET @mPROD = @mPROD + ' 		AND PLAN_START_YYYYMMDD =  '''+ @v_batch_plan_start_yyyymmdd+'''' +CHAR(10);		
     --               SET @mPROD = @mPROD + '     AND PLAN_TYPE           =  '''+ @v_batch_plan_type  +'''' +CHAR(10);	
     --               SET @mPROD = @mPROD + ' 		AND SEQ                 =  '+ CONVERT(NVARCHAR,@v_batch_seq)+'' +CHAR(10);	
     --               SET @mPROD = @mPROD + ' 		AND OPERATION_GROUP     =  '''+ @X_OPERATION_GROUP+'''' +CHAR(10);	
     --               SET @mPROD = @mPROD + ' 		AND SCM_SITE_ID         =  '''+ @X_FROM_SITE+'''' +CHAR(10);	
     --               SET @mPROD = @mPROD + ' 		AND ITEM_ID             =  '''+ @X_ITEM_ID+'''' +CHAR(10);	
     --               SET @mPROD = @mPROD + ' 		AND LINE_ID             =  '''+ @X_LINE_ID+'''' +CHAR(10);	
     --               SET @mPROD = @mPROD + ' 		AND OPERATION_ID        =  '''+ @X_OPERATION_ID+'''' +CHAR(10);		
     --               SET @mPROD = @mPROD + ' 		AND MEASURE             = ''PROD_PLAN_AMEND'' '+CHAR(10);	
     --               SET @mPROD = @mPROD + ' 		AND YYYYMMDD            <  '''+ @v_batch_create_to_yyyymmdd +''''+CHAR(10);
     --               ------------------------------------------------------------------------------------------------------------- 

				IF @v_batch_measure IN  ('PACK_PROD','CELL_PROD')   -- PROD
				BEGIN
				INSERT INTO #SCP_XLS_PSI_GLOBAL_MODIFY_ROW
				SELECT 
				   A.YYYYMMDD
				  , A.QTY
				  , B.COLS_NAME
				  FROM SCP_ANL_PRODUCTION_PLAN A
				  INNER JOIN
				  (		SELECT  ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD) AS SORT_SEQ
							, 'QTY' + REPLICATE('0', 3 - LEN(ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD) )) + CONVERT(NVARCHAR,ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD))  AS COLS_NAME
							, A.BASIS_YYYYMMDD                        AS YYYYMMDD    
                            , A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 31) AS SORT_ORDER_NO           
  	  	                FROM DBO.SCM_SYS_CALENDAR_M A  WITH(NOLOCK)	  
						WHERE A.BASIS_YYYYMMDD     BETWEEN @v_batch_create_from_yyyymmdd AND CONVERT(VARCHAR(8), DATEADD(day, 364, @v_batch_create_from_yyyymmdd), 112)		--@v_batch_create_to_yyyymmdd     
			                 GROUP BY A.BASIS_YYYYMMDD  
				) B
				ON A.YYYYMMDD = B.YYYYMMDD
				  WHERE 0 = 0                                 
                    AND A.DIVISION_ID         =  @v_batch_division_id
                    AND A.PLAN_START_YYYYMMDD =  @v_batch_plan_start_yyyymmdd
                    AND A.PLAN_TYPE           =  @v_batch_plan_type
                    AND A.SEQ                 =  @v_batch_seq
                    AND A.OPERATION_GROUP     =  @X_OPERATION_GROUP
					AND A.SCM_SITE_ID         =  @X_FROM_SITE	
                    AND A.ITEM_ID             =  @X_ITEM_ID	
                    AND A.LINE_ID             =  @X_LINE_ID
                    AND A.OPERATION_ID        =  @X_OPERATION_ID
                    AND A.MEASURE             = 'PROD_PLAN_AMEND'
                    AND A.YYYYMMDD            <  @v_batch_create_to_yyyymmdd
				    AND A.QTY				  <> 0
				END



				IF @v_batch_measure <> 'PACK_MODEL_CHANGE' AND @v_batch_measure <> 'CELL_MODEL_CHANGE'
				BEGIN

				INSERT INTO #SCP_XLS_PSI_GLOBAL_MODIFY WITH (TABLOCK)
				SELECT 
				 @v_batch_xls_key1  AS XLS_KEY1 ,@v_batch_division_id  AS DIVISION_ID ,@v_batch_create_from_yyyymmdd   AS CREATE_FROM_YYYYMMDD
				,SUM(ISNULL(QTY001, 0)) AS QTY001, SUM(ISNULL(QTY002, 0)) AS QTY002, SUM(ISNULL(QTY003, 0)) AS QTY003, SUM(ISNULL(QTY004, 0)) AS QTY004, SUM(ISNULL(QTY005, 0)) AS QTY005, SUM(ISNULL(QTY006, 0)) AS QTY006, SUM(ISNULL(QTY007, 0)) AS QTY007, SUM(ISNULL(QTY008, 0)) AS QTY008, SUM(ISNULL(QTY009, 0)) AS QTY009, SUM(ISNULL(QTY010, 0)) AS QTY010
				,SUM(ISNULL(QTY011, 0)) AS QTY011, SUM(ISNULL(QTY012, 0)) AS QTY012, SUM(ISNULL(QTY013, 0)) AS QTY013, SUM(ISNULL(QTY014, 0)) AS QTY014, SUM(ISNULL(QTY015, 0)) AS QTY015, SUM(ISNULL(QTY016, 0)) AS QTY016, SUM(ISNULL(QTY017, 0)) AS QTY017, SUM(ISNULL(QTY018, 0)) AS QTY018, SUM(ISNULL(QTY019, 0)) AS QTY019, SUM(ISNULL(QTY020, 0)) AS QTY020
				,SUM(ISNULL(QTY021, 0)) AS QTY021, SUM(ISNULL(QTY022, 0)) AS QTY022, SUM(ISNULL(QTY023, 0)) AS QTY023, SUM(ISNULL(QTY024, 0)) AS QTY024, SUM(ISNULL(QTY025, 0)) AS QTY025, SUM(ISNULL(QTY026, 0)) AS QTY026, SUM(ISNULL(QTY027, 0)) AS QTY027, SUM(ISNULL(QTY028, 0)) AS QTY028, SUM(ISNULL(QTY029, 0)) AS QTY029, SUM(ISNULL(QTY030, 0)) AS QTY030
				,SUM(ISNULL(QTY031, 0)) AS QTY031, SUM(ISNULL(QTY032, 0)) AS QTY032, SUM(ISNULL(QTY033, 0)) AS QTY033, SUM(ISNULL(QTY034, 0)) AS QTY034, SUM(ISNULL(QTY035, 0)) AS QTY035, SUM(ISNULL(QTY036, 0)) AS QTY036, SUM(ISNULL(QTY037, 0)) AS QTY037, SUM(ISNULL(QTY038, 0)) AS QTY038, SUM(ISNULL(QTY039, 0)) AS QTY039, SUM(ISNULL(QTY040, 0)) AS QTY040
				,SUM(ISNULL(QTY041, 0)) AS QTY041, SUM(ISNULL(QTY042, 0)) AS QTY042, SUM(ISNULL(QTY043, 0)) AS QTY043, SUM(ISNULL(QTY044, 0)) AS QTY044, SUM(ISNULL(QTY045, 0)) AS QTY045, SUM(ISNULL(QTY046, 0)) AS QTY046, SUM(ISNULL(QTY047, 0)) AS QTY047, SUM(ISNULL(QTY048, 0)) AS QTY048, SUM(ISNULL(QTY049, 0)) AS QTY049, SUM(ISNULL(QTY050, 0)) AS QTY050
				,SUM(ISNULL(QTY051, 0)) AS QTY051, SUM(ISNULL(QTY052, 0)) AS QTY052, SUM(ISNULL(QTY053, 0)) AS QTY053, SUM(ISNULL(QTY054, 0)) AS QTY054, SUM(ISNULL(QTY055, 0)) AS QTY055, SUM(ISNULL(QTY056, 0)) AS QTY056, SUM(ISNULL(QTY057, 0)) AS QTY057, SUM(ISNULL(QTY058, 0)) AS QTY058, SUM(ISNULL(QTY059, 0)) AS QTY059, SUM(ISNULL(QTY060, 0)) AS QTY060
				,SUM(ISNULL(QTY061, 0)) AS QTY061, SUM(ISNULL(QTY062, 0)) AS QTY062, SUM(ISNULL(QTY063, 0)) AS QTY063, SUM(ISNULL(QTY064, 0)) AS QTY064, SUM(ISNULL(QTY065, 0)) AS QTY065, SUM(ISNULL(QTY066, 0)) AS QTY066, SUM(ISNULL(QTY067, 0)) AS QTY067, SUM(ISNULL(QTY068, 0)) AS QTY068, SUM(ISNULL(QTY069, 0)) AS QTY069, SUM(ISNULL(QTY070, 0)) AS QTY070
				,SUM(ISNULL(QTY071, 0)) AS QTY071, SUM(ISNULL(QTY072, 0)) AS QTY072, SUM(ISNULL(QTY073, 0)) AS QTY073, SUM(ISNULL(QTY074, 0)) AS QTY074, SUM(ISNULL(QTY075, 0)) AS QTY075, SUM(ISNULL(QTY076, 0)) AS QTY076, SUM(ISNULL(QTY077, 0)) AS QTY077, SUM(ISNULL(QTY078, 0)) AS QTY078, SUM(ISNULL(QTY079, 0)) AS QTY079, SUM(ISNULL(QTY080, 0)) AS QTY080
				,SUM(ISNULL(QTY081, 0)) AS QTY081, SUM(ISNULL(QTY082, 0)) AS QTY082, SUM(ISNULL(QTY083, 0)) AS QTY083, SUM(ISNULL(QTY084, 0)) AS QTY084, SUM(ISNULL(QTY085, 0)) AS QTY085, SUM(ISNULL(QTY086, 0)) AS QTY086, SUM(ISNULL(QTY087, 0)) AS QTY087, SUM(ISNULL(QTY088, 0)) AS QTY088, SUM(ISNULL(QTY089, 0)) AS QTY089, SUM(ISNULL(QTY090, 0)) AS QTY090
				,SUM(ISNULL(QTY091, 0)) AS QTY091, SUM(ISNULL(QTY092, 0)) AS QTY092, SUM(ISNULL(QTY093, 0)) AS QTY093, SUM(ISNULL(QTY094, 0)) AS QTY094, SUM(ISNULL(QTY095, 0)) AS QTY095, SUM(ISNULL(QTY096, 0)) AS QTY096, SUM(ISNULL(QTY097, 0)) AS QTY097, SUM(ISNULL(QTY098, 0)) AS QTY098, SUM(ISNULL(QTY099, 0)) AS QTY099, SUM(ISNULL(QTY100, 0)) AS QTY100
				,SUM(ISNULL(QTY101, 0)) AS QTY101, SUM(ISNULL(QTY102, 0)) AS QTY102, SUM(ISNULL(QTY103, 0)) AS QTY103, SUM(ISNULL(QTY104, 0)) AS QTY104, SUM(ISNULL(QTY105, 0)) AS QTY105, SUM(ISNULL(QTY106, 0)) AS QTY106, SUM(ISNULL(QTY107, 0)) AS QTY107, SUM(ISNULL(QTY108, 0)) AS QTY108, SUM(ISNULL(QTY109, 0)) AS QTY109, SUM(ISNULL(QTY110, 0)) AS QTY110
				,SUM(ISNULL(QTY111, 0)) AS QTY111, SUM(ISNULL(QTY112, 0)) AS QTY112, SUM(ISNULL(QTY113, 0)) AS QTY113, SUM(ISNULL(QTY114, 0)) AS QTY114, SUM(ISNULL(QTY115, 0)) AS QTY115, SUM(ISNULL(QTY116, 0)) AS QTY116, SUM(ISNULL(QTY117, 0)) AS QTY117, SUM(ISNULL(QTY118, 0)) AS QTY118, SUM(ISNULL(QTY119, 0)) AS QTY119, SUM(ISNULL(QTY120, 0)) AS QTY120
				,SUM(ISNULL(QTY121, 0)) AS QTY121, SUM(ISNULL(QTY122, 0)) AS QTY122, SUM(ISNULL(QTY123, 0)) AS QTY123, SUM(ISNULL(QTY124, 0)) AS QTY124, SUM(ISNULL(QTY125, 0)) AS QTY125, SUM(ISNULL(QTY126, 0)) AS QTY126, SUM(ISNULL(QTY127, 0)) AS QTY127, SUM(ISNULL(QTY128, 0)) AS QTY128, SUM(ISNULL(QTY129, 0)) AS QTY129, SUM(ISNULL(QTY130, 0)) AS QTY130
				,SUM(ISNULL(QTY131, 0)) AS QTY131, SUM(ISNULL(QTY132, 0)) AS QTY132, SUM(ISNULL(QTY133, 0)) AS QTY133, SUM(ISNULL(QTY134, 0)) AS QTY134, SUM(ISNULL(QTY135, 0)) AS QTY135, SUM(ISNULL(QTY136, 0)) AS QTY136, SUM(ISNULL(QTY137, 0)) AS QTY137, SUM(ISNULL(QTY138, 0)) AS QTY138, SUM(ISNULL(QTY139, 0)) AS QTY139, SUM(ISNULL(QTY140, 0)) AS QTY140
				,SUM(ISNULL(QTY141, 0)) AS QTY141, SUM(ISNULL(QTY142, 0)) AS QTY142, SUM(ISNULL(QTY143, 0)) AS QTY143, SUM(ISNULL(QTY144, 0)) AS QTY144, SUM(ISNULL(QTY145, 0)) AS QTY145, SUM(ISNULL(QTY146, 0)) AS QTY146, SUM(ISNULL(QTY147, 0)) AS QTY147, SUM(ISNULL(QTY148, 0)) AS QTY148, SUM(ISNULL(QTY149, 0)) AS QTY149, SUM(ISNULL(QTY150, 0)) AS QTY150
				,SUM(ISNULL(QTY151, 0)) AS QTY151, SUM(ISNULL(QTY152, 0)) AS QTY152, SUM(ISNULL(QTY153, 0)) AS QTY153, SUM(ISNULL(QTY154, 0)) AS QTY154, SUM(ISNULL(QTY155, 0)) AS QTY155, SUM(ISNULL(QTY156, 0)) AS QTY156, SUM(ISNULL(QTY157, 0)) AS QTY157, SUM(ISNULL(QTY158, 0)) AS QTY158, SUM(ISNULL(QTY159, 0)) AS QTY159, SUM(ISNULL(QTY160, 0)) AS QTY160
				,SUM(ISNULL(QTY161, 0)) AS QTY161, SUM(ISNULL(QTY162, 0)) AS QTY162, SUM(ISNULL(QTY163, 0)) AS QTY163, SUM(ISNULL(QTY164, 0)) AS QTY164, SUM(ISNULL(QTY165, 0)) AS QTY165, SUM(ISNULL(QTY166, 0)) AS QTY166, SUM(ISNULL(QTY167, 0)) AS QTY167, SUM(ISNULL(QTY168, 0)) AS QTY168, SUM(ISNULL(QTY169, 0)) AS QTY169, SUM(ISNULL(QTY170, 0)) AS QTY170
				,SUM(ISNULL(QTY171, 0)) AS QTY171, SUM(ISNULL(QTY172, 0)) AS QTY172, SUM(ISNULL(QTY173, 0)) AS QTY173, SUM(ISNULL(QTY174, 0)) AS QTY174, SUM(ISNULL(QTY175, 0)) AS QTY175, SUM(ISNULL(QTY176, 0)) AS QTY176, SUM(ISNULL(QTY177, 0)) AS QTY177, SUM(ISNULL(QTY178, 0)) AS QTY178, SUM(ISNULL(QTY179, 0)) AS QTY179, SUM(ISNULL(QTY180, 0)) AS QTY180
				,SUM(ISNULL(QTY181, 0)) AS QTY181, SUM(ISNULL(QTY182, 0)) AS QTY182, SUM(ISNULL(QTY183, 0)) AS QTY183, SUM(ISNULL(QTY184, 0)) AS QTY184, SUM(ISNULL(QTY185, 0)) AS QTY185, SUM(ISNULL(QTY186, 0)) AS QTY186, SUM(ISNULL(QTY187, 0)) AS QTY187, SUM(ISNULL(QTY188, 0)) AS QTY188, SUM(ISNULL(QTY189, 0)) AS QTY189, SUM(ISNULL(QTY190, 0)) AS QTY190
				,SUM(ISNULL(QTY191, 0)) AS QTY191, SUM(ISNULL(QTY192, 0)) AS QTY192, SUM(ISNULL(QTY193, 0)) AS QTY193, SUM(ISNULL(QTY194, 0)) AS QTY194, SUM(ISNULL(QTY195, 0)) AS QTY195, SUM(ISNULL(QTY196, 0)) AS QTY196, SUM(ISNULL(QTY197, 0)) AS QTY197, SUM(ISNULL(QTY198, 0)) AS QTY198, SUM(ISNULL(QTY199, 0)) AS QTY199, SUM(ISNULL(QTY200, 0)) AS QTY200
				,SUM(ISNULL(QTY201, 0)) AS QTY201, SUM(ISNULL(QTY202, 0)) AS QTY202, SUM(ISNULL(QTY203, 0)) AS QTY203, SUM(ISNULL(QTY204, 0)) AS QTY204, SUM(ISNULL(QTY205, 0)) AS QTY205, SUM(ISNULL(QTY206, 0)) AS QTY206, SUM(ISNULL(QTY207, 0)) AS QTY207, SUM(ISNULL(QTY208, 0)) AS QTY208, SUM(ISNULL(QTY209, 0)) AS QTY209, SUM(ISNULL(QTY210, 0)) AS QTY210
				,SUM(ISNULL(QTY211, 0)) AS QTY211, SUM(ISNULL(QTY212, 0)) AS QTY212, SUM(ISNULL(QTY213, 0)) AS QTY213, SUM(ISNULL(QTY214, 0)) AS QTY214, SUM(ISNULL(QTY215, 0)) AS QTY215, SUM(ISNULL(QTY216, 0)) AS QTY216, SUM(ISNULL(QTY217, 0)) AS QTY217, SUM(ISNULL(QTY218, 0)) AS QTY218, SUM(ISNULL(QTY219, 0)) AS QTY219, SUM(ISNULL(QTY220, 0)) AS QTY220
				,SUM(ISNULL(QTY221, 0)) AS QTY221, SUM(ISNULL(QTY222, 0)) AS QTY222, SUM(ISNULL(QTY223, 0)) AS QTY223, SUM(ISNULL(QTY224, 0)) AS QTY224, SUM(ISNULL(QTY225, 0)) AS QTY225, SUM(ISNULL(QTY226, 0)) AS QTY226, SUM(ISNULL(QTY227, 0)) AS QTY227, SUM(ISNULL(QTY228, 0)) AS QTY228, SUM(ISNULL(QTY229, 0)) AS QTY229, SUM(ISNULL(QTY230, 0)) AS QTY230
				,SUM(ISNULL(QTY231, 0)) AS QTY231, SUM(ISNULL(QTY232, 0)) AS QTY232, SUM(ISNULL(QTY233, 0)) AS QTY233, SUM(ISNULL(QTY234, 0)) AS QTY234, SUM(ISNULL(QTY235, 0)) AS QTY235, SUM(ISNULL(QTY236, 0)) AS QTY236, SUM(ISNULL(QTY237, 0)) AS QTY237, SUM(ISNULL(QTY238, 0)) AS QTY238, SUM(ISNULL(QTY239, 0)) AS QTY239, SUM(ISNULL(QTY240, 0)) AS QTY240
				,SUM(ISNULL(QTY241, 0)) AS QTY241, SUM(ISNULL(QTY242, 0)) AS QTY242, SUM(ISNULL(QTY243, 0)) AS QTY243, SUM(ISNULL(QTY244, 0)) AS QTY244, SUM(ISNULL(QTY245, 0)) AS QTY245, SUM(ISNULL(QTY246, 0)) AS QTY246, SUM(ISNULL(QTY247, 0)) AS QTY247, SUM(ISNULL(QTY248, 0)) AS QTY248, SUM(ISNULL(QTY249, 0)) AS QTY249, SUM(ISNULL(QTY250, 0)) AS QTY250
				,SUM(ISNULL(QTY251, 0)) AS QTY251, SUM(ISNULL(QTY252, 0)) AS QTY252, SUM(ISNULL(QTY253, 0)) AS QTY253, SUM(ISNULL(QTY254, 0)) AS QTY254, SUM(ISNULL(QTY255, 0)) AS QTY255, SUM(ISNULL(QTY256, 0)) AS QTY256, SUM(ISNULL(QTY257, 0)) AS QTY257, SUM(ISNULL(QTY258, 0)) AS QTY258, SUM(ISNULL(QTY259, 0)) AS QTY259, SUM(ISNULL(QTY260, 0)) AS QTY260
				,SUM(ISNULL(QTY261, 0)) AS QTY261, SUM(ISNULL(QTY262, 0)) AS QTY262, SUM(ISNULL(QTY263, 0)) AS QTY263, SUM(ISNULL(QTY264, 0)) AS QTY264, SUM(ISNULL(QTY265, 0)) AS QTY265, SUM(ISNULL(QTY266, 0)) AS QTY266, SUM(ISNULL(QTY267, 0)) AS QTY267, SUM(ISNULL(QTY268, 0)) AS QTY268, SUM(ISNULL(QTY269, 0)) AS QTY269, SUM(ISNULL(QTY270, 0)) AS QTY270
				,SUM(ISNULL(QTY271, 0)) AS QTY271, SUM(ISNULL(QTY272, 0)) AS QTY272, SUM(ISNULL(QTY273, 0)) AS QTY273, SUM(ISNULL(QTY274, 0)) AS QTY274, SUM(ISNULL(QTY275, 0)) AS QTY275, SUM(ISNULL(QTY276, 0)) AS QTY276, SUM(ISNULL(QTY277, 0)) AS QTY277, SUM(ISNULL(QTY278, 0)) AS QTY278, SUM(ISNULL(QTY279, 0)) AS QTY279, SUM(ISNULL(QTY280, 0)) AS QTY280
				,SUM(ISNULL(QTY281, 0)) AS QTY281, SUM(ISNULL(QTY282, 0)) AS QTY282, SUM(ISNULL(QTY283, 0)) AS QTY283, SUM(ISNULL(QTY284, 0)) AS QTY284, SUM(ISNULL(QTY285, 0)) AS QTY285, SUM(ISNULL(QTY286, 0)) AS QTY286, SUM(ISNULL(QTY287, 0)) AS QTY287, SUM(ISNULL(QTY288, 0)) AS QTY288, SUM(ISNULL(QTY289, 0)) AS QTY289, SUM(ISNULL(QTY290, 0)) AS QTY290
				,SUM(ISNULL(QTY291, 0)) AS QTY291, SUM(ISNULL(QTY292, 0)) AS QTY292, SUM(ISNULL(QTY293, 0)) AS QTY293, SUM(ISNULL(QTY294, 0)) AS QTY294, SUM(ISNULL(QTY295, 0)) AS QTY295, SUM(ISNULL(QTY296, 0)) AS QTY296, SUM(ISNULL(QTY297, 0)) AS QTY297, SUM(ISNULL(QTY298, 0)) AS QTY298, SUM(ISNULL(QTY299, 0)) AS QTY299, SUM(ISNULL(QTY300, 0)) AS QTY300
				,SUM(ISNULL(QTY301, 0)) AS QTY301, SUM(ISNULL(QTY302, 0)) AS QTY302, SUM(ISNULL(QTY303, 0)) AS QTY303, SUM(ISNULL(QTY304, 0)) AS QTY304, SUM(ISNULL(QTY305, 0)) AS QTY305, SUM(ISNULL(QTY306, 0)) AS QTY306, SUM(ISNULL(QTY307, 0)) AS QTY307, SUM(ISNULL(QTY308, 0)) AS QTY308, SUM(ISNULL(QTY309, 0)) AS QTY309, SUM(ISNULL(QTY310, 0)) AS QTY310
				,SUM(ISNULL(QTY311, 0)) AS QTY311, SUM(ISNULL(QTY312, 0)) AS QTY312, SUM(ISNULL(QTY313, 0)) AS QTY313, SUM(ISNULL(QTY314, 0)) AS QTY314, SUM(ISNULL(QTY315, 0)) AS QTY315, SUM(ISNULL(QTY316, 0)) AS QTY316, SUM(ISNULL(QTY317, 0)) AS QTY317, SUM(ISNULL(QTY318, 0)) AS QTY318, SUM(ISNULL(QTY319, 0)) AS QTY319, SUM(ISNULL(QTY320, 0)) AS QTY320
				,SUM(ISNULL(QTY321, 0)) AS QTY321, SUM(ISNULL(QTY322, 0)) AS QTY322, SUM(ISNULL(QTY323, 0)) AS QTY323, SUM(ISNULL(QTY324, 0)) AS QTY324, SUM(ISNULL(QTY325, 0)) AS QTY325, SUM(ISNULL(QTY326, 0)) AS QTY326, SUM(ISNULL(QTY327, 0)) AS QTY327, SUM(ISNULL(QTY328, 0)) AS QTY328, SUM(ISNULL(QTY329, 0)) AS QTY329, SUM(ISNULL(QTY330, 0)) AS QTY330
				,SUM(ISNULL(QTY331, 0)) AS QTY331, SUM(ISNULL(QTY332, 0)) AS QTY332, SUM(ISNULL(QTY333, 0)) AS QTY333, SUM(ISNULL(QTY334, 0)) AS QTY334, SUM(ISNULL(QTY335, 0)) AS QTY335, SUM(ISNULL(QTY336, 0)) AS QTY336, SUM(ISNULL(QTY337, 0)) AS QTY337, SUM(ISNULL(QTY338, 0)) AS QTY338, SUM(ISNULL(QTY339, 0)) AS QTY339, SUM(ISNULL(QTY340, 0)) AS QTY340
				,SUM(ISNULL(QTY341, 0)) AS QTY341, SUM(ISNULL(QTY342, 0)) AS QTY342, SUM(ISNULL(QTY343, 0)) AS QTY343, SUM(ISNULL(QTY344, 0)) AS QTY344, SUM(ISNULL(QTY345, 0)) AS QTY345, SUM(ISNULL(QTY346, 0)) AS QTY346, SUM(ISNULL(QTY347, 0)) AS QTY347, SUM(ISNULL(QTY348, 0)) AS QTY348, SUM(ISNULL(QTY349, 0)) AS QTY349, SUM(ISNULL(QTY350, 0)) AS QTY350
				,SUM(ISNULL(QTY351, 0)) AS QTY351, SUM(ISNULL(QTY352, 0)) AS QTY352, SUM(ISNULL(QTY353, 0)) AS QTY353, SUM(ISNULL(QTY354, 0)) AS QTY354, SUM(ISNULL(QTY355, 0)) AS QTY355, SUM(ISNULL(QTY356, 0)) AS QTY356, SUM(ISNULL(QTY357, 0)) AS QTY357, SUM(ISNULL(QTY358, 0)) AS QTY358, SUM(ISNULL(QTY359, 0)) AS QTY359, SUM(ISNULL(QTY360, 0)) AS QTY360
				,SUM(ISNULL(QTY361, 0)) AS QTY361, SUM(ISNULL(QTY362, 0)) AS QTY362, SUM(ISNULL(QTY363, 0)) AS QTY363, SUM(ISNULL(QTY364, 0)) AS QTY364  			 
				from #SCP_XLS_PSI_GLOBAL_MODIFY_ROW sourcedata WITH (TABLOCK)
				  PIVOT (
					SUM(QTY) FOR COLS_NAME IN ( [QTY001], [QTY002], [QTY003], [QTY004], [QTY005], [QTY006], [QTY007], [QTY008], [QTY009], [QTY010]
										,[QTY011], [QTY012], [QTY013], [QTY014], [QTY015], [QTY016], [QTY017], [QTY018], [QTY019], [QTY020]
										,[QTY021], [QTY022], [QTY023], [QTY024], [QTY025], [QTY026], [QTY027], [QTY028], [QTY029], [QTY030]
										,[QTY031], [QTY032], [QTY033], [QTY034], [QTY035], [QTY036], [QTY037], [QTY038], [QTY039], [QTY040]
										,[QTY041], [QTY042], [QTY043], [QTY044], [QTY045], [QTY046], [QTY047], [QTY048], [QTY049], [QTY050]
										,[QTY051], [QTY052], [QTY053], [QTY054], [QTY055], [QTY056], [QTY057], [QTY058], [QTY059], [QTY060]
										,[QTY061], [QTY062], [QTY063], [QTY064], [QTY065], [QTY066], [QTY067], [QTY068], [QTY069], [QTY070]
										,[QTY071], [QTY072], [QTY073], [QTY074], [QTY075], [QTY076], [QTY077], [QTY078], [QTY079], [QTY080]
										,[QTY081], [QTY082], [QTY083], [QTY084], [QTY085], [QTY086], [QTY087], [QTY088], [QTY089], [QTY090]
										,[QTY091], [QTY092], [QTY093], [QTY094], [QTY095], [QTY096], [QTY097], [QTY098], [QTY099], [QTY100]
										,[QTY101], [QTY102], [QTY103], [QTY104], [QTY105], [QTY106], [QTY107], [QTY108], [QTY109], [QTY110]
										,[QTY111], [QTY112], [QTY113], [QTY114], [QTY115], [QTY116], [QTY117], [QTY118], [QTY119], [QTY120]
										,[QTY121], [QTY122], [QTY123], [QTY124], [QTY125], [QTY126], [QTY127], [QTY128], [QTY129], [QTY130]
										,[QTY131], [QTY132], [QTY133], [QTY134], [QTY135], [QTY136], [QTY137], [QTY138], [QTY139], [QTY140]
										,[QTY141], [QTY142], [QTY143], [QTY144], [QTY145], [QTY146], [QTY147], [QTY148], [QTY149], [QTY150]
										,[QTY151], [QTY152], [QTY153], [QTY154], [QTY155], [QTY156], [QTY157], [QTY158], [QTY159], [QTY160]
										,[QTY161], [QTY162], [QTY163], [QTY164], [QTY165], [QTY166], [QTY167], [QTY168], [QTY169], [QTY170]
										,[QTY171], [QTY172], [QTY173], [QTY174], [QTY175], [QTY176], [QTY177], [QTY178], [QTY179], [QTY180]
										,[QTY181], [QTY182], [QTY183], [QTY184], [QTY185], [QTY186], [QTY187], [QTY188], [QTY189], [QTY190]
										,[QTY191], [QTY192], [QTY193], [QTY194], [QTY195], [QTY196], [QTY197], [QTY198], [QTY199], [QTY200]
										,[QTY201], [QTY202], [QTY203], [QTY204], [QTY205], [QTY206], [QTY207], [QTY208], [QTY209], [QTY210]
										,[QTY211], [QTY212], [QTY213], [QTY214], [QTY215], [QTY216], [QTY217], [QTY218], [QTY219], [QTY220]
										,[QTY221], [QTY222], [QTY223], [QTY224], [QTY225], [QTY226], [QTY227], [QTY228], [QTY229], [QTY230]
										,[QTY231], [QTY232], [QTY233], [QTY234], [QTY235], [QTY236], [QTY237], [QTY238], [QTY239], [QTY240]
										,[QTY241], [QTY242], [QTY243], [QTY244], [QTY245], [QTY246], [QTY247], [QTY248], [QTY249], [QTY250]
										,[QTY251], [QTY252], [QTY253], [QTY254], [QTY255], [QTY256], [QTY257], [QTY258], [QTY259], [QTY260]
										,[QTY261], [QTY262], [QTY263], [QTY264], [QTY265], [QTY266], [QTY267], [QTY268], [QTY269], [QTY270]
										,[QTY271], [QTY272], [QTY273], [QTY274], [QTY275], [QTY276], [QTY277], [QTY278], [QTY279], [QTY280]
										,[QTY281], [QTY282], [QTY283], [QTY284], [QTY285], [QTY286], [QTY287], [QTY288], [QTY289], [QTY290]
										,[QTY291], [QTY292], [QTY293], [QTY294], [QTY295], [QTY296], [QTY297], [QTY298], [QTY299], [QTY300]
										,[QTY301], [QTY302], [QTY303], [QTY304], [QTY305], [QTY306], [QTY307], [QTY308], [QTY309], [QTY310]
										,[QTY311], [QTY312], [QTY313], [QTY314], [QTY315], [QTY316], [QTY317], [QTY318], [QTY319], [QTY320]
										,[QTY321], [QTY322], [QTY323], [QTY324], [QTY325], [QTY326], [QTY327], [QTY328], [QTY329], [QTY330]
										,[QTY331], [QTY332], [QTY333], [QTY334], [QTY335], [QTY336], [QTY337], [QTY338], [QTY339], [QTY340]
										,[QTY341], [QTY342], [QTY343], [QTY344], [QTY345], [QTY346], [QTY347], [QTY348], [QTY349], [QTY350]
										,[QTY351], [QTY352], [QTY353], [QTY354], [QTY355], [QTY356], [QTY357], [QTY358], [QTY359], [QTY360]
										,[QTY361], [QTY362], [QTY363], [QTY364]
									)
							)	  AS UN
							;
				END



				-- 저장을 위한 공통메쏘드 입니다
				 if @v_batch_measure not in ('SHIP_PLAN', 'SEMI_SHIP_PLAN') 				 
					  -- #SCP_XLS_PSI_GLOBAL_MODIFY
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
							  X.LAST_UPDATED_BY   = @v_batch_user_sim , 
							  X.LAST_UPDATE_DATE  = GETDATE() 
						FROM SCP_XLS_PSI_GLOBAL X  WITH (NOLOCK) 
						INNER JOIN #SCP_XLS_PSI_GLOBAL_MODIFY Y WITH (NOLOCK)
						ON X.XLS_KEY1 = Y.XLS_KEY1
						AND X.CREATE_FROM_YYYYMMDD = Y.CREATE_FROM_YYYYMMDD
						AND X.DIVISION_ID          = Y.DIVISION_ID
						AND X.CREATE_FROM_YYYYMMDD = @v_batch_create_from_yyyymmdd
						AND X.DIVISION_ID          = @v_batch_division_id			-- 2022.03.23	KSW	GM JV 반영
						;				 					


              IF @v_batch_measure IN  ('PACK_PROD','CELL_PROD', 'PACK_MODEL_CHANGE', 'CELL_MODEL_CHANGE')   -- 형교환(Model Change) 적용 2021.08.12
              BEGIN 
              -------------------------------------------------------------------------------------------------------------         
              -- LINE_TOTAL_LOAD_ENGINE UPDATE (TACT_TIME,WORKING_TIME)  , PACK_PROD_LOAD,CELL_PROD_LOAD
              -------------------------------------------------------------------------------------------------------------
			SELECT @v_company_id = S.COMPANY_ID
			  FROM SCM_MST_SITE  S WITH (NOLOCK),
			  (SELECT DIVISION_ID, FROM_SITE			
               FROM DBO.SCP_XLS_PSI_GLOBAL WITH(NOLOCK)
              WHERE 0 = 0
                AND DIVISION_ID          = @v_batch_division_id
                AND PLAN_START_YYYYMMDD  = @v_batch_plan_start_yyyymmdd
				AND CREATE_FROM_YYYYMMDD = @v_batch_create_from_yyyymmdd
                AND SEQ                  = @v_batch_seq
                AND XLS_KEY1             = @v_batch_xls_key1
				) B
			 WHERE S.SITE_TYPE   = 'PLANT'
			   AND S.VALID_YN    = 'Y'
			   AND S.DIVISION_ID = B.DIVISION_ID
			   AND S.SCM_SITE_ID = B.FROM_SITE
			  
			  -------------------------------------------------------------------------------------------------------------         
              -- Line Load 율 로직 작업중
              -------------------------------------------------------------------------------------------------------------
              IF OBJECT_ID('tempdb..#LINE_WORKINGTIME_BY_LOSS') IS NOT NULL      
	              DROP TABLE #LINE_WORKINGTIME_BY_LOSS;   

                DECLARE @v_line_id  NVARCHAR(100) = ''

                SELECT @v_line_id = PROD_LINE 
                FROM SCP_XLS_PSI_GLOBAL WITH (NOLOCK)
                WHERE XLS_KEY1 = @v_batch_xls_key1
				  AND CREATE_FROM_YYYYMMDD = @v_batch_create_from_yyyymmdd
				  AND DIVISION_ID          = @v_batch_division_id			-- 2022.03.23	KSW	GM JV 반영
				  ;

				CREATE TABLE #LINE_WORKINGTIME_BY_LOSS
				(
					DIVISION_ID		VARCHAR(100) NOT NULL,
					SCM_SITE_ID		VARCHAR(100) NOT NULL,
					OPERATION_ID		VARCHAR(100) NOT NULL,
					LINE_ID		VARCHAR(100) NOT NULL,
					YYYYMMDD		VARCHAR(100) NOT NULL,
					WORKING_TIME		INT		 NULL,
				)

                --Working Time 추출
                INSERT INTO #LINE_WORKINGTIME_BY_LOSS
		            SELECT DIVISION_ID
			               , PLANT_SITE_ID AS SCM_SITE_ID
			               , OPERATION_ID
			               , LINE_ID
			               , YYYYMMDD
			               , WORKING_TIME
		            FROM dbo.FN_LINE_WORKINGTIME_BY_LOSS(@v_batch_division_id, @v_batch_create_from_yyyymmdd, @v_batch_create_to_yyyymmdd, @v_line_id )
                WHERE LINE_ID = @v_line_id
		            ;

	              IF OBJECT_ID('tempdb..#LineLoad') IS NOT NULL      
	                DROP TABLE #LineLoad;  
  
  				CREATE TABLE #LineLoad (
					DIVISION_ID         NVARCHAR(200)    NOT NULL,
                    SCM_SITE_ID	        NVARCHAR(200)    NOT NULL,
                    OPERATION_GROUP     NVARCHAR(200)    NOT NULL,
					OPERATION_ID        NVARCHAR(200)    NOT NULL,
                    LINE_ID             NVARCHAR(200)    NOT NULL,
					MEASURE             NVARCHAR(200)    NOT NULL,
					QTY					INT				 NULL,
					CAPA_TACT			INT			     NULL,
					WORKING_TIME		INT			    NULL,
					YYYYMMDD			NVARCHAR(8)    NULL,
					ISO_YYYYWW			NVARCHAR(6)    NULL,
					TIME_TERM			INT		 	     NULL,
					WEEK_COLUMN			NVARCHAR(200)    NULL
					);

				INSERT INTO #LineLoad
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
					, M.TIME_TERM		-- 형교환(Model Change)
					,'WQTY' + REPLICATE('0', 2 - LEN(DENSE_RANK()  OVER(PARTITION BY  A.LINE_ID ORDER BY C.ISO_YYYYWW) )) + CONVERT(NVARCHAR,DENSE_RANK()  OVER(PARTITION BY  A.LINE_ID ORDER BY C.ISO_YYYYWW))  AS WEEK_COLUMN
			    FROM SCP_ANL_PRODUCTION_PLAN A WITH (NOLOCK)
				INNER JOIN SCM_SYS_CALENDAR_M C   WITH (NOLOCK)
                    ON A.YYYYMMDD = C.BASIS_YYYYMMDD
			    LEFT OUTER JOIN #LINE_WORKINGTIME_BY_LOSS D  WITH (NOLOCK)
                    ON A.DIVISION_ID   = D.DIVISION_ID 
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
				-- 형교환(Model Change) 적용 - start
				LEFT OUTER JOIN SCM_WORK_CALENDAR_M_SN M  WITH (NOLOCK)
					ON A.DIVISION_ID           = M.DIVISION_ID
					AND LEFT(A.SCM_SITE_ID, 4) = M.PLANT_ID
					AND A.OPERATION_ID         = M.OPERATION_ID
					--AND A.YYYYMMDD             = CONVERT(VARCHAR(8), M.WORK_DATE)
					AND convert(datetime, A.YYYYMMDD)             = M.WORK_DATE
					AND A.LINE_ID              = M.LINE_ID
					AND M.LOSS_CODE            = 'XC031'
					AND M.COMPANY_ID		   = @v_company_id
				-- 형교환(Model Change) 적용 - end
			    WHERE 1=1 
				AND A.DIVISION_ID         = @v_batch_division_id
				AND A.PLAN_START_YYYYMMDD = @v_batch_plan_start_yyyymmdd
				AND A.PLAN_TYPE           = @v_batch_plan_type
				AND A.SEQ                 = @v_batch_seq
				AND A.YYYYMMDD           >= @v_batch_create_from_yyyymmdd
				AND A.YYYYMMDD           <  CONVERT(VARCHAR(8), DATEADD(day, 364, @v_batch_create_from_yyyymmdd), 112)		--@v_batch_create_to_yyyymmdd
				AND A.MEASURE             = 'PROD_PLAN_AMEND'
				AND A.LINE_ID             = @v_line_id
				GROUP BY A.DIVISION_ID, A.SCM_SITE_ID ,A.OPERATION_ID ,A.LINE_ID, A.YYYYMMDD, D.WORKING_TIME,  C.ISO_YYYYWW,A.OPERATION_GROUP
				, (CASE WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND  A.OPERATION_GROUP ='P' THEN 'PACK_PROD_LOAD' WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND  A.OPERATION_GROUP ='A'  THEN 'CELL_PROD_LOAD' END ) 
				, M.TIME_TERM		-- 형교환(Model Change)
				;



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
				  		WHERE A.BASIS_YYYYMMDD    BETWEEN @v_batch_create_from_yyyymmdd  AND CONVERT(VARCHAR(8), DATEADD(day, 364, @v_batch_create_from_yyyymmdd), 112)		--@v_batch_create_to_yyyymmdd     
	 		           --WHERE A.BASIS_YYYYMMDD     >= @v_batch_create_from_yyyymmdd 
               --          AND A.BASIS_YYYYMMDD     <  CONVERT(VARCHAR(8), DATEADD(day, 364, @v_batch_create_from_yyyymmdd), 112)		--@v_batch_create_to_yyyymmdd     
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
                                            X.LAST_UPDATED_BY = ''' + @v_batch_user_sim + ''', 
                                            X.LAST_UPDATE_DATE = GETDATE() '+CHAR(10);	

              SET @mEXEC = @mEXEC + ' FROM SCP_XLS_PSI_GLOBAL X  WITH (NOLOCK) '+CHAR(10);	
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
			  SET @mEXEC = @mEXEC + ' AND X.CREATE_FROM_YYYYMMDD = ''' + @v_batch_create_from_yyyymmdd + ''''+CHAR(10);
			  SET @mEXEC = @mEXEC + ' AND X.DIVISION_ID          = ''' + @v_batch_division_id	+ ''''+CHAR(10);				-- 2022.03.23	KSW	GM JV 반영

			 
			 --EXEC UP_XLS_PRINT @mEXEC--TEST

              EXEC sp_executesql @mEXEC;



            




            -------------------------------------------------------------------------------------------------------------         
            --  WEEK SUM PIVOT 생성 후 UPDATE
            -------------------------------------------------------------------------------------------------------------         
			IF @v_batch_measure in ('PACK_PROD_LOAD','CELL_PROD_LOAD') 
			begin
              IF OBJECT_ID('tempdb..#LineLoad_WEEK') IS NOT NULL      
	              DROP TABLE #LineLoad_WEEK;   

                SELECT   A.DIVISION_ID
                        ,A.SCM_SITE_ID  AS SITE_ID
                        ,A.OPERATION_ID
                        ,A.LINE_ID AS PROD_LINE
                        ,A.MEASURE
						-- 형교환(Model Change) 적용 - start
						-- 변경전
						--
                        --,CASE WHEN SUM(A.WORKING_TIME) <= 0.0   THEN 0 
                        --      ELSE ISNULL( ( ROUND(SUM(A.CAPA_TACT),0) / SUM(A.WORKING_TIME) ) ,0 ) *100
                        -- END AS WQTY

						-- 변경후
                        ,CASE WHEN SUM(A.WORKING_TIME) <= 0.0   THEN 0 
							  ELSE ISNULL( ( ROUND(SUM(A.CAPA_TACT),0) / (SUM(A.WORKING_TIME)-ISNULL(SUM(A.TIME_TERM),0)) ) ,0 ) *100
                         END AS WQTY
						 -- 형교환(Model Change) 적용 - end

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
                   FROM SCP_XLS_PSI_GLOBAL X WITH (NOLOCK)
                   INNER JOIN #LineLoad_WEEK_PIVOT Y WITH (NOLOCK)
                      ON Y.PROD_LINE    = X.PROD_LINE 
                     AND X.DIVISION_ID  = Y.DIVISION_ID
                     AND X.FROM_SITE    = Y.SITE_ID
                     AND X.ATTRIBUTE9   = Y.OPERATION_ID
					 AND X.CREATE_FROM_YYYYMMDD = @v_batch_create_from_yyyymmdd
                   WHERE X.MEASURE IN ('PACK_PROD_LOAD','CELL_PROD_LOAD') 
				     AND X.CREATE_FROM_YYYYMMDD = @v_batch_create_from_yyyymmdd
					 AND X.DIVISION_ID          = @v_batch_division_id			-- 2022.03.23	KSW	GM JV 반영
					 AND X.XLS_KEY1				= @v_batch_xls_key1


			end
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
	
	/* 반영보류 (KSK)
	 declare @v_param_text nvarchar(MAX)
				, @v_dailyQty as varchar(8000)
	 set @v_dailyQty =  CAST(@p_dailyQtY AS varchar(8000))
	 EXEC PR_XLS_PARAM_TEXT @v_param_text OUTPUT,  @v_program_name , @p_user_id,@p_division_id,@p_plan_start_yyyymmdd,@p_plan_type,@p_seq,@p_item_id,@p_measure,@p_xls_key1,@p_create_from_yyyymmdd,@p_create_to_yyyymmdd,@p_WQTY01,@p_WQTY02,@p_WQTY03,@p_WQTY04,@p_WQTY05,@p_WQTY06,@p_WQTY07,@p_WQTY08,@p_WQTY09,@p_WQTY10,@p_WQTY11,@p_WQTY12,@p_WQTY13,@p_WQTY14,@p_WQTY15,@p_WQTY16,@p_WQTY17,@p_WQTY18,@p_WQTY19,@p_WQTY20,@p_WQTY21,@p_WQTY22,@p_WQTY23,@p_WQTY24,@p_WQTY25,@p_WQTY26,@p_WQTY27,@p_WQTY28,@p_WQTY29,@p_WQTY30,@p_WQTY31,@p_WQTY32,@p_WQTY33,@p_WQTY34,@p_WQTY35,@p_WQTY36,@p_WQTY37,@p_WQTY38,@p_WQTY39,@p_WQTY40,@p_WQTY41,@p_WQTY42,@p_WQTY43,@p_WQTY44,@p_WQTY45,@p_WQTY46,@p_WQTY47,@p_WQTY48,@p_WQTY49,@p_WQTY50,@p_WQTY51,@p_WQTY52,@p_partial
				,@v_dailyQty , @p_is_debug		 
	*/

      -- ERROR LOG
      SET @v_log_type = N'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                                ,@p_log_type      = @v_log_type
                                ,@p_log_count     = @n_log_count 
                                ,@p_log_message   = @v_log_message 
                                ,@p_description   = @v_description 
                                ,@p_event_date    = @d_event_date 
                                ,@p_user_id       = @v_batch_user
                                ;


	  /*  반영보류 ( KSK)
		, @p_division_id, null, null,  null, null, null, null, null, null,  @v_param_text	 
	 */
								 ;

      return -1 
    END CATCH;

    --     임시 운영반영시에 주석처리 할것.                
     SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +                 
                          REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))                 


    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
	--@p_xls_key1 대신에 현재 데이터의 키인 @v_batch_xls_key1를 기록(KSK,, 240903)
    SET @v_description = N'['+@v_batch_division_id+']['+@v_batch_plan_start_yyyymmdd+']['+@v_batch_measure+']['+str(@v_batch_xls_key1)+'][' + @v_exec_time + ']';         
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
