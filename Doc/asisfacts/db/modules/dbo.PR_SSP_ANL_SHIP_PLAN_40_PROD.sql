CREATE PROCEDURE [dbo].[PR_SSP_ANL_SHIP_PLAN_40_PROD]
( 
      @p_division_id         NVARCHAR(30)
	, @p_company_id          NVARCHAR(30)
) 
/**=========================================================================================================================================================
 * Program ID   : PR_SSP_ANL_SHIP_PLAN_40
 * Description  : 소형사업부 재고 PSI 정보 생성 
 * OutTable     :
 * Execute      : batch job JOB.SCMPROD_PLAN_SUPPLY_40_Creation 에서 호출 
 * Program History
 *=========================================================================================================================================================
 *   Date       In Charge      Description
 *=========================================================================================================================================================
 	<MEASURE>  
	[S]SHIP_REQ(Shipment Request)    : MKT 담당자가 출하요청한 수량         
	[S]SHIP_CONFIRM(Shipment Confirm): 출하 확정 수량   
	[S]POSTP_PLAN(Post Process Plan) : 활성화 후 공정에서 필요로 Barecell 소요량(남경)   	                    
	[P]WH_IN(WH in Plan)             : 제품 창고 인계 계획,Production과 동일(사용자 수정 가능)  
	[P]PROD_PLAN(Production)         : 조립실적+계획(활성화 L/T, 수율 적용) 
	[P]PROD_DATE(Production Date)    : 조립완료일(실적완료일)    
	[P]LOT(Lot)                      : SUBSTRIN(LOT_ID, 4,4)    	           
	[P]INCO_WIP(Incomming WIP)       : 활성화 Aging 후 일자별 특성검사 가능재고로 넘어 올 수량(Remain Lead Time 기준 향후 특성검사가능 재고)    
	[P]INSP_WIP(Inspection WIP)      : 특성 검사 가능 재고  당일 Inspection WIP : 전일 Inspection WIP + 당일 Incomming WIP - 전일 WH in Plan
    [I]MES_FCS_HOLD(Hold Stock)      : MES/FCS 재고중 출하불가 LOT수량(LOT_ID날짜에 L/T 고려)     
	[I]MES_FCS_RELEASE(Release Stock): MES/FCS 재고중 출하불가 LOT수량에 대해 사용자가 지정된 Release 일자의 LOT수량 
	[I]WH_STOC(Warehouse Stock)      : 당일 WH_STOC = OWMS 가용수량 , 익일 WH_STOC = 전일 WH_STOC + 전일WH_IN - 전일SHIP_CONFIRM - 전일POSTP_PLAN - 전일 HOLD수량 + 전일 RELEASE수량      
	[I]BALANCE(Balance)              : 당일 Balance :  당일Warehouse Stock - 당일 Shipment Confirm -당일 POSTP_PLAN
 *=========================================================================================================================================================
 * 2019.04.09   juhlee         Initial Release [PJ20189106} 전지.GSCM 고도화 이행 PROJECT
                               소형 출하PSI 화면용 DATA생성 
 -----------------------------------------------------------------------------------------------------------------------------------------------------------
 * 2019.04.19   juhlee         PROD_PLAN 공정추가 [PJ20189106} 전지.GSCM 고도화 이행 PROJECT
                                PROD_PLAN F로 시작되는 공정(TCO Cell) 은 ADD L/T만 반영  (TCO Cell) 
 							   SSP_ANL_FORMATION_C 생성시 적용
 -----------------------------------------------------------------------------------------------------------------------------------------------------------
 * 2019.04.19   juhlee         INSP_WIP 계산시 TCO 모델은 WH_IN과 관계없이 전부 0으로 SETTING     
 -----------------------------------------------------------------------------------------------------------------------------------------------------------
 * 2019.05.10   juhlee         출하계획생성기간 변경 기존 8주(56일) --> 12주(84일)  : @v_data_end_yyyymmdd 
 -----------------------------------------------------------------------------------------------------------------------------------------------------------
 * 2019.05.13   juhlee         PROD_PLAN 생성시 MY MODEL등록건은 생산계획이 없더라도 계획생성되게 추가(Requested by 김광희책임) 
 -----------------------------------------------------------------------------------------------------------------------------------------------------------
 * 2019.05.14   juhlee         SSP_ANL_SHIP_REQ 생성 시 이전에 요청한 데이터 있으면 같이 생성함(소형 출하요청 2달 입력 기능)  
 -----------------------------------------------------------------------------------------------------------------------------------------------------------
 * 2019.05.15   juhlee         활성화 후 공정에서 필요로 하는 Bare Cell에 대한 Measure 생성 
                                해당 Bare Cell 수량을 재고에서 제외 , Balance에서도 제외 
 	[S]POSTP_PLAN(Post Process Plan) : 활성화 후 공정에서 필요로 Barecell 소요량    
 	[I]WH_STOC(Warehouse Stock)      : 당일 WH_STOC = OWMS 가용수량 , 익일 WH_STOC = 전일 WH_STOC + 전일WH_IN - 전일SHIP_CONFIRM  - 전일Barecell수량(POSTP_PLAN)
 	[I]BALANCE(Balance)              : 당일 Balance :  당일Warehouse Stock - 당일 Shipment Confirm - 당일Barecell수량(POSTP_PLAN) 
 ----------------------------------------------------------------------------------------------------------------------------------------------------------- 
 * 2019.05.16   juhlee         WH_STOCK에 storage B100(TCO Ass.BS D/F), R100(TCO Ass.SW D/F) 재고 수량 적용 (<--SSP_ANL_TCO_STOCK_C)
                                BOH적용시 기존 OWMS 재고와 SSP_ANL_TCO_STOCK_C 추가 적용
 							   SSP_ANL_OWMS_STOCK_C를 SSP_ANL_WH_STOCK_V(SSP_ANL_OWMS_STOCK_C + SSP_ANL_TCO_STOCK_C )로 적용 
 -----------------------------------------------------------------------------------------------------------------------------------------------------------
 * 2019.05.17   juhlee         [P]PROD_PLAN(Production) 에 CNJ Pouch 특성실적 반영 (2019.05.17) 
                                실적일 (D-2,D-1)을 계획일(D, D+1)에 반영 , 해당 공정의 실적이 있을 경우 조립실적에서는 제외함 영 
 							   대상 공정 F5500 : Grading/Charateristic (Pouch), F5600 : Offline Charateristic Measurement (Pouch)
 							   ex) 5/15실적 --> 5/17일 계획 
 -----------------------------------------------------------------------------------------------------------------------------------------------------------
 * 2019.05.20   juhlee         OWMS 가용재고 로직 수정:G182(남경)의 경우 BLOCK_QTY(HOLD)재고만 제외 함 
 -----------------------------------------------------------------------------------------------------------------------------------------------------------
 * 2019.05.22	hwyoon		   SSP_ANL_TCO_STOCK_C 입력 시 SCM_SITE_ID가 null인 Model은 제외
 -----------------------------------------------------------------------------------------------------------------------------------------------------------
 * 2019.05.27   ayj			   [CSR ID:4000602] [요청]외부생산, 장기재고의 출하가능재고 인식 및 가시화(20190516, 20190520 수정 내용)
 -----------------------------------------------------------------------------------------------------------------------------------------------------------
 * 2019.05.28   juhlee	       [P]PROD_PLAN(Production) 에 CNJ Pouch 특성계획 반영 (2019.05.28) 
                                대상 공정 F5500 : Grading/Charateristic (Pouch), F5600 : Offline Charateristic Measurement (Pouch)
 							   단, 조립계획과 중복시 조립계획은 제외하고 Pouch 특성계획을 우선으로 함(ITEM기준)  
 -----------------------------------------------------------------------------------------------------------------------------------------------------------
 * 2019.05.30   juhlee         CNJ Pouch 공정 추가 F5400 : Grading (Pouch) (requested by 김광희책임)
 -----------------------------------------------------------------------------------------------------------------------------------------------------------   
 * 2019.06.27   juhlee	       [P]INCO_WIP(Incomming WIP)에 조립계획(SCM_DNM_PLAN_FROZEN_V)  CNJ Pouch 특성계획 반영[CSR ID:4027867] 
                                 대상 공정 F5400, F5500, F5600 <-- 해당공정의 계획이 우선함 (L/T 2일 적용) 
 -----------------------------------------------------------------------------------------------------------------------------------------------------------
 * 2019.08.13   juhlee	       [P]PROD_PLAN(Production)변경, 조립실적일자를 실적완료일이 아닌 MES LOT실적으로 LOTID의 일자 기준으로 적용[CSR ID:4045693]
 							   [P]LOT(Lot) Measure 추가(attribute1에 lot정보추가) [CSR ID:4045693]  
                                적용된 수량에서 OWMS재고중 해당 LOT(일자,PROD_DATE)에 대한 재고 수량를 차감[CSR ID:4045697]   
 -----------------------------------------------------------------------------------------------------------------------------------------------------------
 * 2019.08.26   juhlee         이전 AGING L/T(LT_FORMATION + ATTRIBUTE1)과 다른 경우 이전 L/T 정보를 SP_ANL_FORMATION_C.ATTRIBUTE2에 UPDATE  	
 -----------------------------------------------------------------------------------------------------------------------------------------------------------
 * 2019.09.17   juhlee	       [P]PROD_PLAN(Production)변경: MES lot실적적용을 A3000번 공정만 적용하는것으로 수정 (request by 김광희) 						    
 -----------------------------------------------------------------------------------------------------------------------------------------------------------
 * 2019.10.23   juhlee	       FP생산계획 view 변경 SCM_DNM_PLAN_FROZEN_V --> SSP_DNM_PLAN_FROZEN_V (FP SSP용 Plan확정 사용) 	
 -----------------------------------------------------------------------------------------------------------------------------------------------------------
 * 2019.11.04   juhlee         MES 재고 정보 적용, Measure 추가 [PJ20189106] 전지.GSCM 고도화 이행 
 -----------------------------------------------------------------------------------------------------------------------------------------------------------
 * 2019.12.05   juhlee         [C20191205-000173] 소형 초소형 모델의 출하 가능량 산출을 위한 PSI 개선 요청
                                (2-13) [S]POSTP_PLAN (Post Process Plan) 조정(예외) : MCSS20253-A2 -> MCSS20253-A4로 투입되므로 재고 차감을 위해POSTP_PLAN으로 적용 
 			                   MCSS20253-A4 의 PROD_PLAN 수량을 MCSS20253-A2 의 PPOST_PLAN 수량으로 적용 
 -----------------------------------------------------------------------------------------------------------------------------------------------------------
 * 2020.01.06   juhlee         [C20200107-000219] 
                                (1-6) 재고 Cutoff 변경
 							    기존  :  MES STOCK Cutoff생성:SCM_DNM_STOCK_V  --> SSP_ANL_MES_STOCK_C (1-2삭제)                                
                                 추가  :  MES STOCK Cutoff생성:SSP_DNM_GMES_STOCK_40    --> SSP_ANL_MES_FCS_STOCK_40_C   
 
 							   (2-5-1) [I]MES_FCS_HOLD(Hold Stock)  메져 추가 (수율적용수량)
 							   (2-5-2) [I]MES_FCS_RELEASE(Release Stock) 메져 추가(수율적용수량) ( <--SSP_ANL_MES_FCS_STOCK_40_C) 
                                (2-14)  [I]WH_STOC(Warehouse Stock) 메저 산술식 변경 :전일 [I]MES_FCS_HOLD(Hold Stock) 차감, 전일 [I]MES_FCS_RELEASE(Release Stock) 추가
 -----------------------------------------------------------------------------------------------------------------------------------------------------------
 * 2020.02.04   juhlee         [C20200115-000418] :오창(A010-A) Production type = MASS 수량을 WH_IN수량에 적용
 								- [C20200115-000418]-1 : Production Type별(MASS / 전체) 수량 추출
 								- [C20200115-000418]-2 : Prod Qty(MASS)와 Prod Qty(MASS)가 다를 경우 Memo 추가 표시, 오창(A010-A)만 적용
 								- [C20200115-000418]-3 : WH_IN수량에 Prodcution_type이 MASS 수량 반영 , 오창(A010-A)만 적용
 
                               (기존) : Production type 전체 대상 - oWMS 재고 수량  
 							   (변경) : 오창의 경우 Prodcution type = 'MASS'인 수량 - oWMS 재고 수량 
 							           해당 내용 적용을 위해 [P]PROD_PLAN(Production) 메저에 ATTRIBUTE4,5,6 컬럼 사용 
 							           - ATTRIBUTE4 : PRODUCTION_TYPE= MASS QTY 
 									   - ATTRIBUTE5 : PRODUCTION_TYPE= 전체 QTY
 									   - ATTRIBUTE6 : OWMS 재고수량(SSP_ANL_OWMS_STOCK_C)
 									   - ATTRIBUTE3 : oWMS 재고수량 or (전체 Prod Qty와 MASS Prod Qty가 다를 경우) 화면 상에 메모 표시를 위해 사용 
 									       ex) MASS Prod Qty : xxx , oWMS Qty : xxxx
 -----------------------------------------------------------------------------------------------------------------------------------------------------------
 * 2020.02.18   juhlee         [C20200218-000100]:oWMS cutoff재고 법인별 시업시간으로 생성(기존 PLAN수행시 최신 oWMS 재고)
                                 - AO10(오창)     : oWMS 06시 생성 재고 
                                 - G182(남경,CNJ) : oWMS 09시 생성 재고
 								* 기존: 최신 oWMS재고(SSP_ANL_OWMS_STOCK) 
 								* 변경: I/F시점 데이터(XIF_OWMS_STOCK_R_SN)
 -------------------------------------------------------------------------------------------------------------------------------------------------------------
 * 2020.03.18   KIMYONGHO      [C20200303-000163] LONGTERM_HOLD_YN 컬럼 추가
 -------------------------------------------------------------------------------------------------------------------------------------------------------------
 * 2020.05.07   KIMYONGHO	   [C20200407-000144] PSI - Aging L/T Alarm 기간 변경 요청건 
 * 2020.06.08   KIMYONGHO	   [C20200601-000370] oWMS - SSP 재고 I/F 주기 수정 요청
 * 2020.09.21   KIM BOK KI     INCOTERMS COLUMN 변경(INCOTERMS -> SSP_INCOTERMS)
 * 2020.09.22   KIM BOK KI     ISNULL(A.CHANGE_STATUS, '') <> 'D' 추가
 * 2020.10.13   KIM BOK KI     INCO_WIP / MES_FCS_HOLD / MES_FCS_RELEASE 생성로직 변경
                               POUCH_WH_ID_DAY LOOKUP 생성 신규추가
 * 2020.10.16   KIM BOK KI     COMPANY 별 수행(C100 대상 외)
 * 2020.11.10   KIM BOK KI     40 Daily Rolling 을 위한 로직변경
 * 2021.01.05   kimbk          Lookup 'LOT_ID_YEAR' 조회 조건 변경
 * 2021.01.13   kimbk          MEASURE 'SHIP_CONFIRM' 데이터 생성 시 확정구간 이후 데이터에 대해 'SHIP_PLAN' 정보를 추가
 * 2021.01.19   KIM BOK KI     MES & OWMS 재고 정보 체크로직 추가 (I/F 재고 정보미 존재 시 수행하지 않음)
 * 2021.01.26   KIM BOK KI     SHIP_CONFIRM 생성 로직 보안
 * 2021.02.26   KIM BOK KI     실행 파라메터 COMPANY_ID 추가
 * 2021.03.10   KIM BOK KI     I/F 재고 정보 체크 로직 추가
 * 2021.07.27   SSP Pjt        SSP_ANL_MES_FCS_STOCK_40_C.attribute4 불량수량 적용
 * 2021.09.01   SSP Pjt.       SCP_MST_BOD_N_V 적용
 * 2022.02.16   SSP Pjt.       SCM_DNM_STOCK_V -> SSP_DNM_STOCK_C
                               2-4에 OPTION (RECOMPILE) 적용(parameter sniffing 방지)
							   SCM_DNM_STOCK_AGING_V -> #tmp_SCM_DNM_STOCK_AGING_V
							   SSP_DNM_MES_STOCK_40 -> SSP_DNM_GMES_STOCK_40
 * 2022.09.01   SSP Pjt.       소형 모듈 비즈 적용 (FP실적: P5000, FP계획: P5500) 
 * 2023.08.30   jilee          반제품->제품코드 변환 작업
 * 2025/08/18   chkim.68       to_company_id를 from_site에 따라 to_company_id가 다르게 적용되는 예외를 적용 (scm_site_company_exception)
							FN_GET_SSP_SITE_INFO -> [FN_GET_SSP_SITE_INFO_EXCEPTION]
*========================================================================================================================================================= */
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS ON;


    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'ssp_batch';  

    DECLARE @v_program_name NVARCHAR(150) = N'PR_SSP_ANL_SHIP_PLAN_40_PROD';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N'SSP_ANL_SHIP_PLAN_40'; -- ▶ 테이블 필수
    DECLARE @d_event_date   DATETIME;

    -- 임시 실행시간 확인용
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();
    DECLARE @v_exec_time    NVARCHAR(10) = ''
	DECLARE @v_sms_desc     NVARCHAR(4000);
	DECLARE @v_sms_req      NVARCHAR(10)= '';

	DECLARE @v_company_id   NVARCHAR(30)= '';
	SET     @v_company_id = @p_company_id ;

    DECLARE @v_plan_start_yyyymmdd    NVARCHAR(8) = '';
	--SET     @v_plan_start_yyyymmdd =  CONVERT(char(8), DATEADD(DD, -1, GETDATE()), 112); 
	SET     @v_plan_start_yyyymmdd =  CONVERT(char(8), GETDATE(), 112); 


	DECLARE @v_division_id    NVARCHAR(30) = '';
	SET     @v_division_id =  @p_division_id ;

 	DECLARE @v_plan_type  NVARCHAR(30) = 'SP'; 
	DECLARE @v_seq        INTEGER = 1;


	/*AGING재고의 cutoff는 생성시점의 가장 최근 정보 ( 보통 한국: 전일cutoff_date기준 당일 08:00~08:30 , 남경 10~11시에  생성됨) 
	  owms 재고는 당일 생성 시점 재고 이므로 Data생성은 당일시작일 기준으로 생성 */
	-- DATA 생성 시작 일자 (당일) 
    DECLARE @v_data_start_yyyymmdd    NVARCHAR(8) = '';
	SET     @v_data_start_yyyymmdd =  CONVERT(char(8), DATEADD(DD, -1, GETDATE()), 112); 

 	-- DATA 생성 마지막 일자    
	DECLARE @v_data_end_yyyymmdd   NVARCHAR(8) = '';
	SET     @v_data_end_yyyymmdd = CONVERT(VARCHAR, DATEADD(D, 84, CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)) ,112) ; --12주(84일) 
	
	-- [C20200601-000370] OWMS I/F SSP_DNM_OWMS_STOCK 테이블 CUTOFF 조회용 
	DECLARE @v_data_cutoff_yyyymmdd    NVARCHAR(8) = '';
	--SET @v_data_cutoff_yyyymmdd = @v_plan_start_yyyymmdd;
	SET @v_data_cutoff_yyyymmdd = @v_data_start_yyyymmdd;

	DECLARE @v_plan_id         NVARCHAR(4000);
    DECLARE @v_owms_count      INTEGER = 0;     
	DECLARE @v_owms_if_count   INTEGER = 0;	--[C20200601-000370] OWMS I/F 수신 여부 체크 변수 추가
	DECLARE @v_tco_count       INTEGER = 0;
	DECLARE @stock_cnt   INTEGER = 0;	
	DECLARE @plan_cnt    INTEGER = 0;	
	DECLARE @v_cnt       INTEGER = 0;	

    DECLARE @v_last_plan_start_yyyymmdd    NVARCHAR(8) = '';
	DECLARE @v_last_plan_type  NVARCHAR(30) = 'SP'; 
	DECLARE @v_last_seq        INTEGER = 1;


	SELECT @plan_cnt = COUNT(*)
	FROM   SSP_ANL_SHIP_PLAN_40 (NOLOCK)
	WHERE  1 = 1
	AND    DIVISION_ID = @v_division_id
	AND    PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
	AND    MEASURE = 'SHIP_CONFIRM'
	AND    ATTRIBUTE10 = @v_company_id
	;

	SELECT @stock_cnt = CASE WHEN A.TOT_CNT <> B.PASS_CNT THEN 1 ELSE 0 END
	FROM   (
			SELECT COUNT(*)  AS TOT_CNT
			FROM   [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
			WHERE  1 = 1
			AND    LOOKUP_TYPE = 'IF_STOCK_CHECK'
			AND    VALID_YN    = 'Y'
			AND    SEGMENT1    = 'PLAN_40'
			AND    SEGMENT3    = '40'
			AND    SEGMENT4    = @v_company_id
			) A
			LEFT OUTER JOIN 
			(
			SELECT COUNT(*)  AS PASS_CNT
			FROM   [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
			WHERE  1 = 1
			AND    LOOKUP_TYPE = 'IF_STOCK_CHECK'
			AND    VALID_YN    = 'Y'
			AND    SEGMENT1    = 'PLAN_40'
			AND    SEGMENT3    = '40'
			AND    SEGMENT4    = @v_company_id
			AND    SEGMENT5    = CONVERT(CHAR(8), GETDATE(), 112)
			AND    ATTRIBUTE1  = 'Y'
			) B
			ON   1 = 1
	WHERE  1 = 1
	;

	IF @plan_cnt > 0 OR @stock_cnt > 0
	BEGIN
PRINT('SKIP....');
		RETURN ;
	END;

    -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SHIP_PLAN INSERT LOGIC';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;

    BEGIN TRY
      BEGIN

		------------------------------------------------------------------------------------------------------------- 
		-- PLAN Start status Plan Detail Insert 
		-------------------------------------------------------------------------------------------------------------
		SELECT @v_plan_id = P.PLAN_ID -- v_plan_id
		FROM   SCM_MST_PLAN P WITH(NOLOCK)
		WHERE  P.DIVISION_ID = @v_division_id
		AND    P.PLAN_CYCLE  = 'DAILY'
		AND    P.PLAN_NAME   = @v_plan_start_yyyymmdd  --@v_data_start_yyyymmdd
		; 

		SELECT @v_cnt = COUNT(DIVISION_ID)		
		FROM   SCM_MST_PLAN_DETAIL   A WITH(NOLOCK)
		WHERE  MODELING_ID = '101'
		AND    DIVISION_ID = @v_division_id
		AND    PLAN_ID     = @v_plan_id
		AND    PLAN_SEQ    = @v_seq 
		AND    PLAN_TYPE   = @v_plan_type
		;

		IF @v_cnt = 0 
		BEGIN
			INSERT INTO SCM_MST_PLAN_DETAIL (
				 MODELING_ID
				,DIVISION_ID
				,PLAN_ID          
				,PLAN_SEQ             
				,PLAN_TYPE         
				,INPUT_START_DATE  
				,INPUT_END_DATE  
				,PLAN_START_DATE
				,PLAN_END_DATE 
				,PLAN_OUTPUT_END_DATE 
				,OUTPUT_START_DATE 
				,OUTPUT_END_DATE 
				,ANL_START_DATE 
				,ANL_END_DATE  
				,PLAN_STATUS  
				,RUN_TYPE    
				,PLAN_TYPE_DESCRIPTION 
				,BASE_SEQ    
				,DISPLAY_YN    
				,UI_DISPLAY_YN  
				,NORMAL_COMPLETE_YN 
				,CONFIRM_FLAG     
				,CONFIRM_USER
				,CONFIRM_DATE
				,ACTIVE_FLAG
				,CREATION_DATE
				,CREATED_BY
				,LAST_UPDATE_DATE
				,LAST_UPDATED_BY
				) 
			VALUES ( 
				 '101'          -- MODELING_ID
				,@v_division_id -- DIVISION_ID
				,@v_plan_id     -- PLAN_ID          
				,@v_seq         -- PLAN_SEQ  
				,@v_plan_type   -- PLAN_TYPE     
				,@v_start_time  -- INPUT_START_DATE  
				,NULL           -- INPUT_END_DATE  
				,@v_start_time  -- PLAN_START_DATE
				,NULL           -- PLAN_END_DATE 
				,NULL           -- PLAN_OUTPUT_END_DATE 
				,@v_start_time  -- OUTPUT_START_DATE
				,NULL           -- OUTPUT_END_DATE
				,@v_start_time  -- ANL_START_DATE
				,NULL           -- ANL_END_DATE
				,0              -- PLAN_STATUS  0:진행 , 1:완료, -1:에러 
				,'PROD'		    -- RUN_TYPE
				,NULL           -- PLAN_TYPE_DESCRIPTION
				,1			    -- BASE_SEQ
				,'Y'		    -- DISPLAY_YN 
				,'Y'            -- UI_DISPLAY_YN
				,'Y'            -- NORMAL_COMPLETE_YN 
				,'Y'            -- CONFIRM_FLAG    
				,@v_batch_user  -- CONFIRM_USER
				,GETDATE()      -- CONFIRM_DATE
				,'Y'            -- ACTIVE_FLAG
				,GETDATE()      -- CREATION_DATE
				,@v_batch_user  -- CREATED_BY
				,GETDATE()      -- LAST_UPDATE_DATE
				,@v_batch_user  -- LAST_UPDATED_BY
				) ;
		END;

        -- 이전 VESION PLAN 정보 추출 
		SELECT @v_last_plan_start_yyyymmdd = MAX(PLAN_START_YYYYMMDD)
		,      @v_last_seq                 = MAX(PLAN_SEQ)
		,      @v_last_plan_type           = MAX(PLAN_TYPE)
		FROM   SSP_PLAN_VERSION_V
		WHERE  PLAN_TYPE    = 'SP'
		AND    DIVISION_ID  = @v_division_id 
		AND    CONFIRM_FLAG = 'Y'
		AND    PLAN_START_YYYYMMDD = (SELECT MAX(PLAN_START_YYYYMMDD)
										FROM SSP_PLAN_VERSION_V T
										WHERE T.DIVISION_ID  = @v_division_id 
										AND   T.PLAN_TYPE    = 'SP'
										AND   T.CONFIRM_FLAG = 'Y'
										AND   T.PLAN_START_YYYYMMDD < @v_plan_start_yyyymmdd
									 );

        BEGIN TRAN TX_SH

		-- 2020.08.19 현업 요청에 의한 LOOKUP DETAIL 정보 생성 (요청자 : 김광희 책임)
		-- CELL 출하대상에 없는 SCP 출하계획이 있는 경우 전극출하대상 LOOKUP에 자동 신규 추가 함 
		-- 단, SALES_COMPANY_ID(3자거래 대상)는 PI담당자가 추가 입력해야 해서 제외 함(시스템판단로직 불가)    
		-- VALID_YN N으로 설정된값은 추가 대상이 아님(VALID_YN 관계없이 비교하여 없으면 신규생성함) 
		INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
			(
			LOOKUP_TYPE
			,SEGMENT1     -- FROM_COMPANY_ID   
			,SEGMENT2     -- FROM_DIVISION_ID
			,SEGMENT3     -- FROM_SITE
			,SEGMENT4     -- TO_COMPANY_ID
			,SEGMENT5     -- TO_SITE
			,ATTRIBUTE1   -- TO_DIVISION_ID
			,DISPLAY_SEQ
			,VALID_YN
			,DESCRIPTION
			,CREATED_BY
			,CREATION_DATE
			,LAST_UPDATED_BY
			,LAST_UPDATE_DATE
			)
		SELECT A.LOOKUP_TYPE
				, A.FROM_COMPANY_ID
				, A.FROM_DIVISION_ID
				, A.FROM_SITE
				, A.TO_COMPANY_ID
				, A.TO_SITE
				, A.TO_DIVISION_ID
				, 10   AS DISPLAY_SEQ
				, 'Y'  AS VALID_YN
				, 'System Auto Create'   AS DESCRIPTION
				, 'ssp_batch'      AS CREATED_BY   --@v_batch_user
				, GETDATE()        AS CREATION_DATE
				, 'ssp_batch'      AS LAST_UPDATED_BY  --@v_batch_user
				, GETDATE()        AS LAST_UPDATE_DATE
		FROM   (
				SELECT DISTINCT
						'CELL_SHIP_FROM_TO' AS LOOKUP_TYPE
				,      [DBO].[FN_GET_SSP_SITE_INFO](F.DIVISION_ID, A.FROM_SITE, 'COMPANY_ID')  AS FROM_COMPANY_ID 
				,      F.DIVISION_ID    AS FROM_DIVISION_ID
				,      A.FROM_SITE
				,      [DBO].[FN_GET_SSP_SITE_INFO_EXCEPTION](T.DIVISION_ID,A.FROM_SITE, A.TO_SITE, 'COMPANY_ID')  AS TO_COMPANY_ID 
				,      T.DIVISION_ID    AS TO_DIVISION_ID
				,      A.TO_SITE
				FROM   [SCP_ANL_SHIPMENT_PLAN_SEMI] A WITH(NOLOCK)
						JOIN  SCM_MST_SITE  F WITH(NOLOCK)
						ON    F.SITE_TYPE = 'PLANT'
						AND   F.VALID_YN = 'Y'
						AND   F.OPERATION_GROUP = 'A'
						AND   F.DIVISION_ID = A.ORIGIN_FROM_DIVISION_ID
						AND   F.SCM_SITE_ID = A.FROM_SITE
						JOIN  SCM_MST_SITE  T WITH(NOLOCK)
						ON    T.VALID_YN = 'Y'
						AND   T.OPERATION_GROUP = 'P'
						AND   T.DIVISION_ID = A.ORIGIN_TO_DIVISION_ID
						AND   T.SCM_SITE_ID = A.TO_SITE
				WHERE  1 = 1
				AND    A.DIVISION_ID = @v_division_id
				AND    A.plan_start_yyyymmdd = @v_plan_start_yyyymmdd  -- '20200817'
				AND    A.MEASURE = 'SHIP_PLAN'
				AND    A.OPERATION_GROUP = 'A'
				AND    A.TO_SITE <> '-'
				--AND    A.MEASURE = 'SHIP_PLAN_AMEND'
				AND    A.QTY > 0
				) A
		WHERE  1 = 1
		AND    A.TO_COMPANY_ID <> ''
		AND    A.FROM_COMPANY_ID <> A.TO_COMPANY_ID
		AND    NOT EXISTS ( 
							SELECT *   -- 전극출하대상
							FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
							WHERE  1=1 
							AND    L.LOOKUP_TYPE =  'CELL_SHIP_FROM_TO' 
							AND    L.SEGMENT1    =  A.FROM_COMPANY_ID   
							AND    L.SEGMENT2    =  A.FROM_DIVISION_ID    
							AND    L.SEGMENT3    =  A.FROM_SITE    
							AND    L.SEGMENT4    =  A.TO_COMPANY_ID   
							AND    L.SEGMENT5    =  A.TO_SITE   
							AND    L.ATTRIBUTE1  =  A.TO_DIVISION_ID 
							) 

		-- 2020.09.28  현업 요구사항으로 LOGIC 추가 (Pouch Item Group 별 WH_IN 합산 일수 관리)
		INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
				(
				 LOOKUP_TYPE
				,SEGMENT1     -- CELL_TYPE   
				,SEGMENT2     -- OPERATION_ID
				,SEGMENT3
				,SEGMENT4
				,SEGMENT5
				,DISPLAY_SEQ
				,VALID_YN
				,DESCRIPTION
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
				)
		SELECT 'POUCH_WH_IN_DAY'       AS LOOKUP_TYPE
			 , SUBSTRING(A.ITEM_ID, 1, 3)  AS SEGMENT1 -- POUCH_ITEM_GROUP
			 , CASE WHEN (SUBSTRING(A.ITEM_ID, 1, 3) = 'MDP' OR SUBSTRING(A.ITEM_ID, 1, 3) = 'MIP' OR SUBSTRING(A.ITEM_ID, 1, 3) = 'MTP') THEN '3'
			   ELSE '2' END            AS SEGMENT2  -- WH_IN_DAY
			 , '-'   AS SEGMENT3
			 , '-'   AS SEGMENT4
			 , '-'   AS SEGMENT5
			 , 10    AS DISPLAY_SEQ
			 , 'Y'   AS VALID_YN
			 , 'System Auto Create'   AS DESCRIPTION
			 , 'System'
			 , GETDATE()        AS CREATION_DATE
			 , 'System'
			 , GETDATE()        AS LAST_UPDATE_DATE
		FROM   (
				SELECT DISTINCT
						A.DIVISION_ID
				,      A.ITEM_ID
				FROM   [SCP_ANL_SHIPMENT_PLAN_SEMI] A WITH(NOLOCK) -- SCP_ANL_SHIPMENT_PLAN_SEMI A WITH(NOLOCK)
						JOIN  SCM_MST_SITE  F WITH(NOLOCK)
						ON    F.SITE_TYPE = 'PLANT'
						AND   F.VALID_YN = 'Y'
						AND   F.OPERATION_GROUP = 'A'
						AND   F.DIVISION_ID = A.ORIGIN_FROM_DIVISION_ID
						AND   F.SCM_SITE_ID = A.FROM_SITE
						JOIN  SCM_MST_SITE  T WITH(NOLOCK)
						ON    T.VALID_YN = 'Y'
						AND   T.OPERATION_GROUP = 'P'
						AND   T.DIVISION_ID = A.ORIGIN_TO_DIVISION_ID
						AND   T.SCM_SITE_ID = A.TO_SITE
				WHERE  1 = 1
				AND    A.division_id = @v_division_id
				AND    A.plan_start_yyyymmdd = @v_plan_start_yyyymmdd  -- '20200817'
				AND    A.MEASURE = 'SHIP_PLAN'
				--AND    A.OPERATION_GROUP = 'A'
				AND    A.TO_SITE <> '-'
				--AND    A.MEASURE = 'SHIP_PLAN_AMEND'
				AND    A.QTY > 0
				GROUP BY A.DIVISION_ID, A.ITEM_ID
				) A
				LEFT OUTER JOIN SCP_MST_FINAL_ITEM  C WITH(NOLOCK)
				ON   C.DIVISION_ID = A.DIVISION_ID
				AND  C.ITEM_ID = A.ITEM_ID
				JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK) 
				ON  D.SEGMENT3 = 'P'
				AND D.LOOKUP_TYPE = 'CELL_TYPE_CODE' 
				AND D.VALID_YN    = 'Y' 
				AND D.SEGMENT1    = C.CELL_TYPE_GROUP_CODE
		WHERE  1 = 1
		AND    NOT EXISTS (
							SELECT 1
							FROM   SCM_ADM_LOOKUP_MASTER_DETAIL  B WITH(NOLOCK)
							WHERE  1 = 1
							AND    B.LOOKUP_TYPE = 'POUCH_WH_IN_DAY'
							AND    B.VALID_YN    = 'Y' 
							AND    B.SEGMENT1    =  SUBSTRING(A.ITEM_ID, 1, 3)
							--AND    B.SEGMENT2    = A.ATTRIBUTE1 
							AND    B.SEGMENT3    = '-'
							AND    B.SEGMENT4    = '-'
							AND    B.SEGMENT5    = '-'
		                  )
		GROUP BY SUBSTRING(A.ITEM_ID, 1, 3)
		;

		-----------------------------------------------------------
		-- SMS 전송 : Daily Plan  START (50)
		--50 Daily Plan Start 
		--51 Daily Plan End 
		--52 Daily Plan Error 
		-----------------------------------------------------------
		--수행시간이 짧아 시작은 제외 
		--SET @v_sms_desc = @v_division_id +':'+@v_sms_req+':SSP';
		--EXEC SCM_ADM_SMS_SEND_BATCH 50, @v_sms_desc;

        ------------------------------------------------------------------------------------------------------------- 
        --1.기준정보,재고 정보 Cutoff 정보 생성 
		   --1.Daily OWMS 재고 생성:SSP_ANL_OWMS_STOCK --> SSP_ANL_OWMS_STOCK_C
		   --2.MES STOCK Cutoff생성:SCM_DNM_STOCK_V    --> SSP_ANL_MES_STOCK_C  -삭제6.으로 대체 
		   --3.TCO 재고 Cutoff생성 :SCM_DNM_STOCK_V    --> SSP_ANL_TCO_STOCK_C
		   --4.Hold재고 Cutoff생성 :SSP_ANL_HOLD_STOCK --> SSP_ANL_HOLD_STOCK (전일 Hold 정보를 금일 Hold정보)  
		   --5.Formation Cutoff생성:SCP_MST_FORMATION  --> SSP_ANL_FORMATION_C 
		   --6.MES_FCS Stock Cutoff생성 :SSP_DNM_GMES_STOCK_40(MES), SCM_DNM_STOCK_AGING_V(FCS) --> SSP_ANL_MES_FCS_STOCK_40_C 
        ------------------------------------------------------------------------------------------------------------- 
			/*------------------------------------------------------------------------------------------------------------- 
			1-1.OWMS 재고 Cutoff 및 Hold Stock Cutoff 
			 변경전)
			  PLAN 생성 시점의 OWMS 재고 정보 추출 및 Data 생성
			  최신 oWMS재고(SSP_ANL_OWMS_STOCK_C)  
             
			 [C20200218-000100] 
			 변경후)  법인별 시업시간으로 생성
			  - AO10(오창)     : oWMS 06시 생성 재고 
			  - G182(남경,CNJ) : oWMS 09시 생성 재고
			  - I/F시점 데이터(XIF_OWMS_STOCK_R_SN)
			-------------------------------------------------------------------------------------------------------------*/
			SELECT @v_owms_count =  COUNT(A.DIVISION_ID) 
			FROM   SSP_ANL_OWMS_STOCK_C A WITH(NOLOCK) 
				   JOIN SCM_MST_SITE B WITH(NOLOCK)
				   ON   B.DIVISION_ID = @v_division_id
				   AND  ISNULL(B.COMPANY_ID, '')  = @v_company_id
				   AND  B.DIVISION_ID = A.DIVISION_ID
				   AND  B.SCM_SITE_ID = A.FROM_SITE
			WHERE  A.DIVISION_ID         = @v_division_id
			AND    A.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
			--AND    A.PLAN_START_YYYYMMDD = @v_data_start_yyyymmdd
			AND    A.PLAN_TYPE           = @v_plan_type
			AND    A.SEQ                 = @v_seq
			;

			-- Daily OWMS 재고 생성 (추출시점을 CUTOFF개념을 생성함, Daily 1회 9시 전송받은 재고)
			IF @v_owms_count = 0

				BEGIN
					-- 과거 데이터 삭제 로직 
					DELETE A
					FROM  SSP_ANL_OWMS_STOCK_C  A WITH(NOLOCK)
						   JOIN SCM_MST_SITE B WITH(NOLOCK)
						   ON   B.DIVISION_ID = @v_division_id
						   AND  ISNULL(B.COMPANY_ID, '')  = @v_company_id
						   AND  B.DIVISION_ID = A.DIVISION_ID
						   AND  B.SCM_SITE_ID = A.FROM_SITE
					WHERE A.DIVISION_ID         = @v_division_id 
					  AND A.PLAN_START_YYYYMMDD < CONVERT(VARCHAR(8),DATEADD(D,-30,GETDATE()),112) --30일 이전 데이터 삭제 
					  AND A.PLAN_TYPE           = @v_plan_type 
					  AND A.SEQ                 = @v_seq
                    ;

				-- [C20200601-000370] 해당 일 기준 OWMS I/F 내역이 없으면 가장 최근 CUTOFF 일자 사용
				SELECT @v_owms_if_count = COUNT(*)
				FROM   [SSP_DNM_OWMS_STOCK] O WITH(NOLOCK)  
					   JOIN SCM_MST_SITE B WITH(NOLOCK)
					   ON   B.DIVISION_ID = @v_division_id
					   AND  ISNULL(B.COMPANY_ID, '')  = @v_company_id
					   AND  B.DIVISION_ID = O.DIVISION_ID
					   AND  B.PLANT_ID = O.PLANT_ID
					   AND  B.OPERATION_GROUP = [dbo].[FN_GET_ITEM_OPERATION_GROUP](O.PROD_GROUP, O.ITEM_ID)
				WHERE  1=1 
				AND    O.PROD_GROUP = @v_division_id
				--AND	   O.CUTOFF_DATE = @v_plan_start_yyyymmdd
				AND	   O.CUTOFF_DATE = @v_data_start_yyyymmdd
				AND    [dbo].[FN_GET_SCM_SITE_ID_PLANT](O.PLANT_ID, [dbo].[FN_GET_ITEM_OPERATION_GROUP](O.PROD_GROUP, O.ITEM_ID)) IS NOT NULL 
				;

				IF @v_owms_if_count = 0
					--THROW 60001, 'No Data - WMS I/F Receive Data', 1;  -- ERROR 
					BEGIN
						SELECT @v_data_cutoff_yyyymmdd = MAX(CUTOFF_DATE)
						FROM   [SSP_DNM_OWMS_STOCK] O WITH(NOLOCK) 
							   JOIN SCM_MST_SITE B WITH(NOLOCK)
							   ON   B.DIVISION_ID = @v_division_id
							   AND  ISNULL(B.COMPANY_ID, '')  = @v_company_id
							   AND  B.DIVISION_ID = O.DIVISION_ID
							   AND  B.PLANT_ID = O.PLANT_ID
						WHERE  1=1 
						AND    O.PROD_GROUP = @v_division_id
						AND    [dbo].[FN_GET_SCM_SITE_ID_PLANT](O.PLANT_ID, [dbo].[FN_GET_ITEM_OPERATION_GROUP](O.PROD_GROUP, O.ITEM_ID)) IS NOT NULL 
						;
					END



					INSERT INTO SSP_ANL_OWMS_STOCK_C (
							 DIVISION_ID
							,PLAN_START_YYYYMMDD
							,PLAN_TYPE
							,SEQ
							,FROM_SITE
							,ITEM_ID
							,PALLET_ID
							,STOCK_QTY
							,AVAILABLE_QTY
							,AVAILABLE_QTY_ORIGIN
							,NON_QC_QTY
							,ALLOCATION_QTY
							,BLOCK_QTY
							,PACKING_QTY
							,MOVING_QTY
							,RCVLOC_QTY
							,EXPIRATION_QTY
							,LONG_QTY
							,PROD_GROUP
							,LOT_ID
							,PLANT_ID
							,GRADE
							,PACKING_STATUS
							,STOCK_STATUS
							,STORAGE_ID
							,CUSTOMER_CODE
							,CUSTOMER_NAME
							,LOT_DATE
							,SOC
							,CAPACITY_GRADE
							,ORIGIN_FROM_DIVISION_ID
							,CREATED_BY
							,CREATION_DATE
							,LAST_UPDATED_BY
							,LAST_UPDATE_DATE
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
								)
						SELECT 
							 O.PROD_GROUP AS DIVISION_ID
							,@v_plan_start_yyyymmdd
							,@v_plan_type
							,@v_seq
							,[dbo].[FN_GET_SCM_SITE_ID_PLANT](O.PLANT_ID, [dbo].[FN_GET_ITEM_OPERATION_GROUP](O.PROD_GROUP, O.ITEM_ID))  
							,O.ITEM_ID
							,O.PALLET_ID
							,O.STOCK_QTY
							 -- STOCK_QTY - BLOCK_QTY - LONG_QTY , 단 BLOCK_QTY , LONG_QTY 둘다 있으면, 큰수를 적용, 남경의 경우 BLOCK_QTY만 제외 
							 -- G182의 경우는 STOCK_QTY - BLOCK_QTY 적용 (20190520 Requested by 지준혁) 
							,O.STOCK_QTY -  CASE WHEN O.PLANT_ID = 'G182' THEN O.BLOCK_QTY
										  ELSE
											   CASE WHEN  O.BLOCK_QTY > O.LONG_QTY THEN  O.BLOCK_QTY
													WHEN  O.BLOCK_QTY < O.LONG_QTY THEN  O.LONG_QTY
													WHEN  O.BLOCK_QTY = O.LONG_QTY THEN  O.BLOCK_QTY
											   END    
										  END AS AVAILABLE_QTY -- STOCK_QTY - BLOCK_QTY - LONG_QTY , 단 BLOCK_QTY , LONG_QTY 둘다 있으면, 큰수를 적용
							,O.AVAILABLE_QTY  AS AVAILABLE_QTY_ORIGIN
							,O.NON_QC_QTY
							,O.ALLOCATION_QTY
							,O.BLOCK_QTY
							,O.PACKING_QTY
							,O.MOVING_QTY
							,O.RCVLOC_QTY
							,O.EXPIRATION_QTY
							,O.LONG_QTY
							,O.PROD_GROUP
							,ISNULL(O.LOT_ID,'-')          AS LOT_ID
							,O.PLANT_ID					 AS PLANT_ID
							,ISNULL(O.GRADE, '-')          AS GRADE
							,ISNULL(O.PACKING_STATUS, '-') AS PACKING_STATUS
							,ISNULL(O.STOCK_STATUS,'-')    AS STOCK_STATUS
							,ISNULL(O.STORAGE_ID,'-')      AS STORAGE_ID
							,ISNULL(O.CUSTOMER_CODE,'-')   AS CUSTOMER_CODE
							,O.CUSTOMER_NAME
							,O.LOT_DATE
							,ISNULL(O.SOC, '-')            AS CUSTOMER_NAME
							,ISNULL(O.CAPACITY_GRADE, '-') AS CAPACITY_GRADE
							,O.PROD_GROUP     --ORIGIN_FROM_DIVISION_ID
							,@v_batch_user     
							,O.CREATION_DATE   --OWMS I/F 처리 DATE
							,@v_batch_user
							,GETDATE()
							,O.ATTRIBUTE1
							,O.ATTRIBUTE2
							,O.ATTRIBUTE3
							,O.ATTRIBUTE4
							,O.ATTRIBUTE5
							,O.ATTRIBUTE6
							,O.ATTRIBUTE7
							,O.ATTRIBUTE8
							,O.ATTRIBUTE9
							,O.ATTRIBUTE10
						FROM   [SSP_DNM_OWMS_STOCK] O WITH(NOLOCK)  --FROM XIF_OWMS_STOCK_R_SN O WITH(NOLOCK) [C20200601-000370] 테이블 변경
							   JOIN SCM_MST_SITE B WITH(NOLOCK)
							   ON   B.DIVISION_ID = @v_division_id
							   AND  ISNULL(B.COMPANY_ID, '')  = @v_company_id
							   AND  B.DIVISION_ID = O.DIVISION_ID
							   AND  B.PLANT_ID = O.PLANT_ID
							   AND  B.OPERATION_GROUP = [dbo].[FN_GET_ITEM_OPERATION_GROUP](O.PROD_GROUP, O.ITEM_ID)
						WHERE  1=1 
						AND    O.PROD_GROUP = @v_division_id
						AND	   O.CUTOFF_DATE = @v_data_cutoff_yyyymmdd 
						AND    [dbo].[FN_GET_SCM_SITE_ID_PLANT](O.PLANT_ID, [dbo].[FN_GET_ITEM_OPERATION_GROUP](O.PROD_GROUP, O.ITEM_ID)) IS NOT NULL 
                        ;
				END; 

			------------------------------------------------------------------------------------------------------------- 
			--1-3.TCO STOCK Cutoff생성
				-- STORAGE ID : B100(TCO Ass.BS D/F), R100(TCO Ass.SW D/F) 
				-- 해당 재고는 WH_STOCK에 적용 
			------------------------------------------------------------------------------------------------------------- 
			SELECT @v_tco_count =  COUNT(A.DIVISION_ID) 
			FROM   SSP_ANL_TCO_STOCK_C A WITH(NOLOCK) 
					JOIN SCM_MST_SITE B WITH(NOLOCK)
					ON   B.DIVISION_ID = @v_division_id
					AND  ISNULL(B.COMPANY_ID, '')  = @v_company_id
					AND  B.DIVISION_ID = A.DIVISION_ID
					AND  B.SCM_SITE_ID = A.SCM_SITE_ID
			WHERE  A.DIVISION_ID         = @v_division_id
			AND    A.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
			--AND    A.PLAN_START_YYYYMMDD = @v_data_cutoff_yyyymmdd
			AND    A.PLAN_TYPE           = @v_plan_type
			AND    A.SEQ                 = @v_seq
			;

			IF @v_tco_count = 0  

				BEGIN

					DELETE A
					FROM   SSP_ANL_TCO_STOCK_C  A WITH(NOLOCK)
						   JOIN SCM_MST_SITE B WITH(NOLOCK)
						   ON   B.DIVISION_ID = @v_division_id
						   AND  ISNULL(B.COMPANY_ID, '')  = @v_company_id
						   AND  B.DIVISION_ID = A.DIVISION_ID
						   AND  B.SCM_SITE_ID = A.SCM_SITE_ID
					WHERE  A.DIVISION_ID = @v_division_id 
					AND    A.PLAN_START_YYYYMMDD  = @v_plan_start_yyyymmdd
					AND    A.PLAN_TYPE            = @v_plan_type
					AND    A.SEQ                  = @v_seq
					;

					INSERT INTO SSP_ANL_TCO_STOCK_C ( 
							DIVISION_ID
							,PLAN_START_YYYYMMDD
							,PLAN_TYPE
							,SEQ
							,SCM_SITE_ID
							,ITEM_ID
							,QTY
							,CREATED_BY
							,CREATION_DATE
							,LAST_UPDATED_BY
							,LAST_UPDATE_DATE
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
							) 
					SELECT A.DIVISION_ID  AS DIVISION_ID
						,@v_plan_start_yyyymmdd  AS PLAN_START_YYYYMMDD
						,@v_plan_type     AS PLAN_TYPE
						,@v_seq           AS SEQ
						,DBO.FN_GET_SCM_SITE_ID_PLANT(A.PLANT_ID, DBO.FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, RTRIM(LTRIM(A.ITEM_ID)))) AS SCM_SITE_ID
						-- jilee 230830	 		
						,ISNULL(IM.APPLIED_MODEL, A.ITEM_iD) AS ITEM_ID			
						--,A.ITEM_ID       AS ITEM_ID 
						,SUM(A.SSP_QTY)       AS QTY 
						,@v_batch_user AS CREATED_BY
						,GETDATE() AS CREATION_DATE
						,@v_batch_user AS LAST_UPDATED_BY
						,GETDATE() AS LAST_UPDATE_DATE
						,NULL AS ATTRIBUTE1
						,NULL AS ATTRIBUTE2
						,NULL AS ATTRIBUTE3
						,NULL AS ATTRIBUTE4
						,NULL AS ATTRIBUTE5
						,NULL AS ATTRIBUTE6
						,NULL AS ATTRIBUTE7
						,NULL AS ATTRIBUTE8
						,NULL AS ATTRIBUTE9
						,NULL AS ATTRIBUTE10
					FROM [SSP_DNM_STOCK_C] A  WITH(NOLOCK) -- SCM_DNM_STOCK_V
							JOIN (  
								SELECT C.DIVISION_ID , C.SITE_ID , MAX(C.CUTOFF_DATE) AS CUTOFF_DATE
								FROM   [SSP_DNM_STOCK_C] C WITH(NOLOCK) 
								WHERE  C.CUTOFF_DATE  >  GETDATE() - 5
								AND    C.DIVISION_ID = @v_division_id
								GROUP BY C.DIVISION_ID, C.SITE_ID
								) B 
							ON   B.DIVISION_ID = A.DIVISION_ID
							AND  B.SITE_ID     = A.SITE_ID
							AND  B.CUTOFF_DATE = A.CUTOFF_DATE
							-- jilee 230830
                            LEFT OUTER JOIN [LGCE_FPDEV_TR].[DBO].[SCM_ITEM_M] IM WITH(NOLOCK) 
				    		ON   IM.DIVISION_ID = A.DIVISION_ID							   
							AND  IM.COMPANY_ID = @V_COMPANY_ID
							AND  IM.SITE_ID = A.SITE_ID
							AND  IM.ITEM_ID = A.ITEM_ID
							AND IM.ITEM_CLASS IN ('ES1901', 'ES2001','ES2002', 'ES2003', 'ES2004')			
					WHERE  A.DIVISION_ID = @v_division_id
					AND    A.COMPANY_ID  = @v_company_id
					AND    A.STORAGE_ID  IN ('B100','R100') 
					AND	   DBO.FN_GET_SCM_SITE_ID_PLANT(A.PLANT_ID, DBO.FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, RTRIM(LTRIM(A.ITEM_ID)))) IS NOT NULL
					GROUP BY A.DIVISION_ID
					,        DBO.FN_GET_SCM_SITE_ID_PLANT(A.PLANT_ID, DBO.FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, RTRIM(LTRIM(A.ITEM_ID)))) 
					         -- jilee 230830
					,        IM.APPLIED_MODEL
					,        A.ITEM_ID   
					;    

				END;

			------------------------------------------------------------------------------------------------------------- 
			--1-4.Hold 재고 Cutoff생성  
				--Daily HOLD Stock  생성 (이전 Plan 기준으로 현재 정보 생성) 
			------------------------------------------------------------------------------------------------------------- 
			IF OBJECT_ID('tempdb..#tmp_SSP_ANL_HOLD_STOCK') IS NOT NULL
			DROP TABLE #tmp_SSP_ANL_HOLD_STOCK

			CREATE TABLE #tmp_SSP_ANL_HOLD_STOCK(
			 HOLD_ID                        nvarchar(050)   
			,PLAN_START_YYYYMMDD            nvarchar(008)    
			,PLAN_TYPE                      nvarchar(050)   
			,SEQ                            INT         
			,DIVISION_ID                    nvarchar(030)   
			,FROM_SITE                      nvarchar(030)   
			,ITEM_ID                        nvarchar(050)   
			,HOLD_YYYYMMDD                  nvarchar(008)    
			,RELEASE_YYYYMMDD               nvarchar(008)    
			,HOLD_QTY                       numeric(20, 10)
			,REMARKS                        nvarchar(255)  
			,ORIGIN_FROM_DIVISION_ID        nvarchar(030)   
			,CREATED_BY                     nvarchar(150)  
			,CREATION_DATE                  datetime       
			,LAST_UPDATED_BY                nvarchar(150)  
			,LAST_UPDATE_DATE               datetime       
			);

			INSERT INTO #tmp_SSP_ANL_HOLD_STOCK (
						 HOLD_ID
						,PLAN_START_YYYYMMDD
						,PLAN_TYPE
						,SEQ
						,DIVISION_ID
						,FROM_SITE
						,ITEM_ID
						,HOLD_YYYYMMDD
						,RELEASE_YYYYMMDD
						,HOLD_QTY
						,REMARKS
						,ORIGIN_FROM_DIVISION_ID
						,CREATED_BY
						,CREATION_DATE
						,LAST_UPDATED_BY
						,LAST_UPDATE_DATE
     			)
			SELECT 
				 A.HOLD_ID
				,@v_plan_start_yyyymmdd -- PLAN_START_YYYYMMDD
				,@v_plan_type--PLAN_TYPE
				,@v_seq--SEQ
				,A.DIVISION_ID
				,A.FROM_SITE
				,A.ITEM_ID
				,A.HOLD_YYYYMMDD
				,A.RELEASE_YYYYMMDD
				,A.HOLD_QTY
				,A.REMARKS
				,A.DIVISION_ID -- ORIGIN_FROM_DIVISION_ID
				,A.CREATED_BY
				,A.CREATION_DATE
				,A.LAST_UPDATED_BY
				,A.LAST_UPDATE_DATE
			FROM  [SSP_ANL_HOLD_STOCK] A WITH(NOLOCK) 
					JOIN SCM_MST_SITE B WITH(NOLOCK)
					ON   B.DIVISION_ID = @v_division_id
					AND  ISNULL(B.COMPANY_ID, '')  = @v_company_id
					AND  B.DIVISION_ID = A.DIVISION_ID
					AND  B.SCM_SITE_ID = A.FROM_SITE
			WHERE A.DIVISION_ID         = @v_division_id
			AND   A.PLAN_START_YYYYMMDD = ( --@v_last_plan_start_yyyymmdd
			                               SELECT MAX(PLAN_START_YYYYMMDD)
										   FROM   [SSP_ANL_HOLD_STOCK] C WITH(NOLOCK) 
										   WHERE  C.DIVISION_ID = @v_division_id
										   AND    C.PLAN_TYPE   = @v_last_plan_type
										   AND    C.SEQ         = @v_last_seq
			                              )
			AND   A.PLAN_TYPE           = @v_last_plan_type
			AND   A.SEQ                 = @v_last_seq
			;

			-- SSP_ANL_HOLD_STOCK 생성 
			DELETE A
			FROM   SSP_ANL_HOLD_STOCK  A WITH(NOLOCK)
					JOIN SCM_MST_SITE B WITH(NOLOCK)
					ON   B.DIVISION_ID = @v_division_id
					AND  ISNULL(B.COMPANY_ID, '')  = @v_company_id
					AND  B.DIVISION_ID = A.DIVISION_ID
					AND  B.SCM_SITE_ID = A.FROM_SITE
			WHERE A.DIVISION_ID         = @v_division_id
			AND   A.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
			AND   A.PLAN_TYPE           = @v_plan_type
			AND   A.SEQ                 = @v_seq
			;

			INSERT INTO SSP_ANL_HOLD_STOCK (
				 HOLD_ID
				,PLAN_START_YYYYMMDD
				,PLAN_TYPE
				,SEQ
				,DIVISION_ID
				,FROM_SITE
				,ITEM_ID
				,HOLD_YYYYMMDD
				,RELEASE_YYYYMMDD
				,HOLD_QTY
				,REMARKS
				,ORIGIN_FROM_DIVISION_ID
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
     			)
			SELECT 
				 HOLD_ID
				,@v_plan_start_yyyymmdd -- PLAN_START_YYYYMMDD
				,@v_plan_type--PLAN_TYPE
				,@v_seq--SEQ
				,DIVISION_ID
				,FROM_SITE
				,ITEM_ID
				,HOLD_YYYYMMDD
				,RELEASE_YYYYMMDD
				,HOLD_QTY
				,REMARKS
				,ORIGIN_FROM_DIVISION_ID
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
			FROM #tmp_SSP_ANL_HOLD_STOCK WITH(NOLOCK) 
			;

			------------------------------------------------------------------------------------------------------------- 
			--1-5.활성화수율 CUTOFF DATA 생성 
			-- 활성화수율 CUTOFF DATA 생성 (SSP0015,Shipment Plan(Samll)의 Aging L/T, Yeild 조회용, Data생성시점과 조회시점 일치화용) 
			------------------------------------------------------------------------------------------------------------
			DELETE A
			FROM   SSP_ANL_FORMATION_C  A WITH(NOLOCK)
					JOIN SCM_MST_SITE B WITH(NOLOCK)
					ON   B.DIVISION_ID = @v_division_id
					AND  ISNULL(B.COMPANY_ID, '')  = @v_company_id
					AND  B.DIVISION_ID = A.DIVISION_ID
					AND  B.SCM_SITE_ID = A.PLANT_SITE_ID
			WHERE  A.DIVISION_ID         = @v_division_id
			AND    A.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
			AND    A.PLAN_TYPE           = @v_plan_type
			AND    A.SEQ                 = @v_seq
			;

			INSERT INTO SSP_ANL_FORMATION_C (
					 DIVISION_ID
					,PLAN_START_YYYYMMDD
					,PLAN_TYPE
					,SEQ
					,PLANT_SITE_ID
					,ITEM_ID
					,LT_FORMATION
					,FORMATION_YIELD
					,CHAR_YIELD
					,FORMATION_TOTAL_YIELD
					,SSP_MODIFY_YIELD
					,CREATED_BY
					,CREATION_DATE
					,LAST_UPDATED_BY
					,LAST_UPDATE_DATE
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
			)
			SELECT 	 F.DIVISION_ID
					,@v_plan_start_yyyymmdd AS PLAN_START_YYYYMMDD
					,@v_plan_type			AS PLAN_TYPE
					,@v_seq					AS SEQ
					,F.PLANT_SITE_ID
					-- jilee 230830 주석해제 할것
					--,ISNULL(IM.APPLIED_MODEL, F.ITEM_ID) AS ITEM_ID
					,F.ITEM_ID
					--TCO 시작하는 공정은 ADD L/T만 반영 ( SSP_ANL_FORMATION_C에 TCO공정은 0으로 setting ) 
					,CASE WHEN V.TCO_CELL_YN = 'Y' THEN 0 ELSE F.LT_FORMATION END AS LT_FORMATION -- TCO 모델의 경우 LT_FORMATION 0으로 SETUP
					,F.FORMATION_YIELD
					,F.CHAR_YIELD
					,F.FORMATION_TOTAL_YIELD
					,F.SSP_MODIFY_YIELD
					,F.CREATED_BY
					,F.CREATION_DATE
					,F.LAST_UPDATED_BY
					,F.LAST_UPDATE_DATE
					,F.ATTRIBUTE1
					,F.ATTRIBUTE2
					,F.ATTRIBUTE3
					,F.ATTRIBUTE4
					,F.ATTRIBUTE5
					,F.ATTRIBUTE6
					,F.ATTRIBUTE7
					,F.ATTRIBUTE8
					,F.ATTRIBUTE9
					,F.ATTRIBUTE10
			FROM   [SCP_MST_FORMATION] F WITH(NOLOCK)
					LEFT OUTER JOIN SCP_MST_FINAL_ITEM V WITH(NOLOCK)
					ON  V.ITEM_ID = F.ITEM_ID 
					AND V.DIVISION_ID = F.DIVISION_ID 
					AND V.TCO_CELL_YN = 'Y'
				   JOIN SCM_MST_SITE B WITH(NOLOCK)
				   ON   B.DIVISION_ID = @v_division_id
				   AND  ISNULL(B.COMPANY_ID, '')  = @v_company_id
				   AND  B.DIVISION_ID = F.DIVISION_ID
				   AND  B.SCM_SITE_ID = F.PLANT_SITE_ID
				   -- jilee 230830 주석해제 할것
				   -- LEFT OUTER JOIN [LGCE_FPDEV_TR].[DBO].[SCM_ITEM_M] IM WITH(NOLOCK) 
				   -- ON   IM.DIVISION_ID = F.DIVISION_ID							   
				   -- AND  IM.COMPANY_ID = @v_company_id
				   -- AND  IM.SITE_ID = B.SITE_ID
				   -- AND  IM.ITEM_ID = F.ITEM_ID
				   -- AND  IM.ITEM_CLASS IN ('ES1901', 'ES2001','ES2002', 'ES2003', 'ES2004')	
			WHERE  F.DIVISION_ID = @v_division_id
			;
		  
            -- 이전 AGING L/T(LT_FORMATION + ATTRIBUTE1)과 다른 경우 이전 L/T 정보를 ATTRIBUTE2에 UPDATE    
		    --[C20200407-000144] Alarm 기간 2주로 변경
			UPDATE SSP_ANL_FORMATION_C 
			SET    ATTRIBUTE2  = 'Before L/T : '+  CONVERT(VARCHAR,  CONVERT(INT ,B.LT ) , 0)
			FROM   SSP_ANL_FORMATION_C A WITH(NOLOCK)  
			       JOIN  (
							SELECT X.DIVISION_ID 
							,      X.PLANT_SITE_ID 
							,      X.ITEM_ID 
							,      X.LT 
							FROM (
									SELECT A.PLAN_START_YYYYMMDD 
									,      A.DIVISION_ID , A.PLANT_SITE_ID , A.ITEM_ID 
									,      SUM(A.LT_FORMATION + CASE WHEN ISNUMERIC(A.ATTRIBUTE1) =1 THEN CONVERT(NUMERIC(20,10), A.ATTRIBUTE1) ELSE 0 END ) AS LT
									,      ROW_NUMBER() OVER(PARTITION BY A.DIVISION_ID , A.PLANT_SITE_ID, A.ITEM_ID ORDER BY A.PLAN_START_YYYYMMDD DESC )   AS MAX_PLAN_START_YYYYMMDD
									FROM   SSP_ANL_FORMATION_C A WITH(NOLOCK)  
										JOIN 
											(
											SELECT DIVISION_ID 
											,      PLANT_SITE_ID
											,      ITEM_ID 
											,      LT_FORMATION 
											,      ATTRIBUTE1
											,      LT_FORMATION + CASE WHEN ISNUMERIC(ATTRIBUTE1) =1 THEN CONVERT(NUMERIC(20,10), ATTRIBUTE1) ELSE 0 END AS LT
											FROM   SSP_ANL_FORMATION_C WITH(NOLOCK) 
											WHERE  DIVISION_ID         = @v_division_id
											AND    PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
											AND    PLAN_TYPE           = @v_plan_type
											AND    SEQ                 = @v_seq
											) B
										ON  A.DIVISION_ID   = B.DIVISION_ID 
										AND A.PLANT_SITE_ID = B.PLANT_SITE_ID 
										AND A.ITEM_ID       = B.ITEM_ID 			       
									WHERE  A.DIVISION_ID          = @v_division_id			
									AND    A.PLAN_START_YYYYMMDD <= @v_plan_start_yyyymmdd
									AND    A.PLAN_START_YYYYMMDD >= CONVERT(char(8), DATEADD(DD, -14, CONVERT(DATETIME, @v_plan_start_yyyymmdd, 112)), 112) 
									AND    A.PLAN_TYPE            = @v_plan_type
									AND    A.SEQ                  = @v_seq
									AND    A.LT_FORMATION + CASE WHEN ISNUMERIC(A.ATTRIBUTE1) =1 THEN CONVERT(NUMERIC(20,10), A.ATTRIBUTE1) ELSE 0 END <> B.LT
									GROUP  BY A.PLAN_START_YYYYMMDD , A.DIVISION_ID , A.PLANT_SITE_ID , A.ITEM_ID 
							) X
							WHERE X.MAX_PLAN_START_YYYYMMDD = 1 -- 가장 최근 값 	
				        ) B 
				   ON   A.DIVISION_ID   = B.DIVISION_ID 
				   AND  A.PLANT_SITE_ID = B.PLANT_SITE_ID 
				   AND  A.ITEM_ID       = B.ITEM_ID 	
				   JOIN SCM_MST_SITE C WITH(NOLOCK)
				   ON   C.DIVISION_ID = @v_division_id
				   AND  ISNULL(C.COMPANY_ID, '')  = @v_company_id
				   AND  C.DIVISION_ID = A.DIVISION_ID
				   AND  C.SCM_SITE_ID = A.PLANT_SITE_ID
            WHERE  A.DIVISION_ID         = @v_division_id		
			AND    A.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
			AND    A.PLAN_TYPE           = @v_plan_type
			AND    A.SEQ                 = @v_seq
			;

			------------------------------------------------------------------------------------------------------------- 
			--1-6.MES/FCS 재고 CUTOFF DATA 생성 (L/T,수율적용) 
			-- 6.MES_FCS Stock Cutoff생성 :SSP_DNM_GMES_STOCK_40(MES), SCM_DNM_STOCK_AGING_V(FCS) --> SSP_ANL_MES_FCS_STOCK_C_40 
			------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('tempdb..#tmp_SSP_ANL_MES_FCS_STOCK_40_C') IS NOT NULL
			DROP TABLE #tmp_SSP_ANL_MES_FCS_STOCK_40_C

			CREATE TABLE #tmp_SSP_ANL_MES_FCS_STOCK_40_C(
				 DIVISION_ID                   nvarchar(050)                   
				,FROM_SITE                     nvarchar(050)
				,ITEM_ID                       nvarchar(050)
				,LOT_ID                        nvarchar(050)
				,LOT_TYPE                      nvarchar(050)
				,LOT_QTY_MES                   numeric(20, 10) 
				,LOT_QTY_FCS                   numeric(20, 10) 
				,LOT_QTY_TOT                   numeric(20, 10) 
				,FCS_SPECIAL_QTY               numeric(20, 10) 
				,AVAILABLE_YN                  nvarchar(001)        
				,MES_HOLD_YN                   nvarchar(001)
				,QMS_HOLD_YN                   nvarchar(001)
				,FCS_HOLD_YN                   nvarchar(001)
				,LONGTERM_HOLD_YN			 NVARCHAR(001) 	-- [C20200303-000163] 신규추가
				,JUDG_VLD_DATE                 nvarchar(008)
				,MES_HOLD_RELEASE              nvarchar(008)
				,QMS_HOLD_RELEASE              nvarchar(008)   
				,USER_MOD_RELEASE_DATE         nvarchar(008)
				,REMARKS                       nvarchar(4000)
				,SUM_DATE                      nvarchar(008)
				,CHANGE_STATUS                 nvarchar(001)
				,CREATED_BY                    nvarchar(150)
				,CREATION_DATE                 datetime
				,LAST_UPDATED_BY               nvarchar(150)
				,LAST_UPDATE_DATE              datetime
				,ATTRIBUTE4                    nvarchar(100)  --불량수량
				) ;

			--튜닝 : SCM_DNM_STOCK_AGING_V -> #tmp_SCM_DNM_STOCK_AGING_V
			IF OBJECT_ID('tempdb..#tmp_SCM_DNM_STOCK_AGING_V') IS NOT NULL
			DROP TABLE #tmp_SCM_DNM_STOCK_AGING_V
			
			CREATE TABLE #tmp_SCM_DNM_STOCK_AGING_V  
			(
				[DIVISION_ID]				[nvarchar](30) NULL,
				[SCM_SITE_ID]				[nvarchar](50) NULL,
				[ITEM_ID]					[nvarchar](150) NULL,
				[LOT_ID]                    [nvarchar](150) NULL,
				QTY							NUMERIC(20,10),
				WIPHOLD_YN					NVARCHAR(1),
				SPECIAL_YN					NVARCHAR(1),
				UNHOLD_EXP_DATE				DATE
			)

	        INSERT INTO #tmp_SCM_DNM_STOCK_AGING_V
	               (DIVISION_ID,SCM_SITE_ID, ITEM_ID, LOT_ID, QTY, WIPHOLD_YN, SPECIAL_YN, UNHOLD_EXP_DATE)
            SELECT  
                   A.DIVISION_ID        
                 , A.SCM_SITE_ID   
                 , A.ITEM_ID   
                 , A.LOT_ID            
                 , A.QTY     
                 , A.WIPHOLD_YN   
                 , A.SPECIAL_YN   
                 , A.UNHOLD_EXP_DATE
              FROM SCM_DNM_STOCK_AGING_V A WITH(NOLOCK)  -- SCM_DNM_STOCK_AGING_V] A WITH(NOLOCK) 
                   JOIN (-- 가장최근 CUTOFF 기준 
                        SELECT C.DIVISION_ID, C.SITE_ID ,  MAX(C.CUTOFF_DATE) AS CUTOFF_DATE
                          FROM SCM_DNM_STOCK_AGING_V C WITH(NOLOCK)  -- SCM_DNM_STOCK_AGING_V] C WITH(NOLOCK) 
                         WHERE C.CUTOFF_DATE >  GETDATE() - 5 
                           AND C.DIVISION_ID  = @v_division_id
                         GROUP BY C.DIVISION_ID, C.SITE_ID 
                        ) B
                ON A.DIVISION_ID = B.DIVISION_ID
               AND A.SITE_ID     = B.SITE_ID
               AND A.CUTOFF_DATE = B.CUTOFF_DATE
             ;
			 
            -- MES / FCS 재고 정보 추출 및 병합  
			WITH NEW AS (
				SELECT  X.DIVISION_ID 
				,       X.FROM_SITE 
				,       X.ITEM_ID 
				,       X.LOT_ID2                               AS LOT_ID 
				,       MAX(X.LOT_TYPE)                         AS LOT_TYPE
				,       SUM(X.LOT_QTY_MES)                      AS LOT_QTY_MES
				,       SUM(X.LOT_QTY_FCS)                      AS LOT_QTY_FCS
				,       SUM(X.LOT_QTY_MES) + SUM(X.LOT_QTY_FCS) AS LOT_QTY_TOT
				,       SUM(X.FCS_SPECIAL_QTY)                  AS FCS_SPECIAL_QTY
	                    -- AVAILABLE_YN_MES ,AVAILABLE_YN_FCS 의 MIN값 우선    
				,       CASE WHEN  MIN(X.AVAILABLE_YN_MES) = 'N' OR MIN(X.AVAILABLE_YN_FCS) = 'N' THEN 'N' ELSE 'Y' END   AVAILABLE_YN 				  
				,       ISNULL(MAX(X.MES_HOLD_YN),'-')          AS MES_HOLD_YN
				,       ISNULL(MAX(X.QMS_HOLD_YN),'-')          AS QMS_HOLD_YN
				,       ISNULL(MAX(X.FCS_HOLD_YN),'-')          AS FCS_HOLD_YN
				,       ISNULL(MAX(X.LONGTERM_HOLD_YN),'-')     AS LONGTERM_HOLD_YN	-- [C20200303-000163] 신규추가
				,       ISNULL(MAX(X.FCS_SPECIAL_YN),'-')       AS FCS_SPECIAL_YN
				,       MAX(X.JUDG_VLD_DATE)                    AS JUDG_VLD_DATE
				,       MAX(X.MES_HOLD_RELEASE)                 AS MES_HOLD_RELEASE
				,       MAX(X.QMS_HOLD_RELEASE)                 AS QMS_HOLD_RELEASE
				,       NULL                                    AS USER_MOD_RELEASE_DATE
				,       NULL                                    AS REMARKS
				,       SUM(X.ATTRIBUTE4)                       AS ATTRIBUTE4  
				FROM (  -- FCS 재고 정보 
						SELECT A.DIVISION_ID        AS DIVISION_ID
						,      'FCS'                AS TYPE
						,      A.SCM_SITE_ID 		AS FROM_SITE
						--     jilee 230830			 			
						,      ISNULL(IM.APPLIED_MODEL, A.ITEM_ID)  AS ITEM_ID 						
						--,      A.ITEM_ID			AS ITEM_ID
						,      A.LOT_ID             AS LOT_ID
						--,      SUBSTRING(A.LOT_ID,1,8) AS LOT_ID2
						,      CASE WHEN ISNULL(D.SEGMENT3, '') = 'P' THEN
								   CASE WHEN CHARINDEX('-', A.LOT_ID) = 10 AND LEN(A.LOT_ID) = 13 THEN SUBSTRING(A.LOT_ID, 1, CHARINDEX('-', LOT_ID) -1) 
										WHEN CHARINDEX('-', A.LOT_ID) = 10 AND LEN(A.LOT_ID) > 13 THEN SUBSTRING(A.LOT_ID, 1, 10) 
										WHEN CHARINDEX('-', A.LOT_ID) <> 10 AND LEN(A.LOT_ID) > 13 THEN SUBSTRING(A.LOT_ID, 1, 10) 
								   ELSE SUBSTRING(A.LOT_ID, 1, 8) END
							   ELSE SUBSTRING(A.LOT_ID, 1, 8) END   AS LOT_ID2
						,      NULL                 AS LOT_TYPE
						,      0      			    AS LOT_QTY_MES
						,      A.QTY 				AS LOT_QTY_FCS
						,      0                    AS LOT_QTY_TOT
						,      CASE WHEN A.SPECIAL_YN = 'Y' THEN A.QTY ELSE 0 END AS FCS_SPECIAL_QTY 
						,      NULL         		AS AVAILABLE_YN_MES
						-- AVAILABLE_YN_FCS : WIPHOLD_YN='Y' 이면 AVAILABLE_YN_FCS = 'N'
						,      CASE WHEN A.WIPHOLD_YN = 'Y' THEN 'N' ELSE 'Y' END  	AS AVAILABLE_YN_FCS 
						,      NULL					AS MES_HOLD_YN
						,      NULL					AS QMS_HOLD_YN
						,      A.WIPHOLD_YN			AS FCS_HOLD_YN
						,      NULL				AS LONGTERM_HOLD_YN -- [C20200303-000163] 신규추가
						,      A.SPECIAL_YN			AS FCS_SPECIAL_YN
						,      NULL                 AS JUDG_VLD_DATE
						,      CONVERT(NVARCHAR(8), A.UNHOLD_EXP_DATE, 112)	AS MES_HOLD_RELEASE
						,      NULL					AS QMS_HOLD_RELEASE
						,      0                    AS ATTRIBUTE4
						FROM   #tmp_SCM_DNM_STOCK_AGING_V AS A 						
							   LEFT OUTER JOIN SCP_MST_FINAL_ITEM  C WITH(NOLOCK)
							   ON   C.DIVISION_ID = A.DIVISION_ID
							   AND  C.ITEM_ID = A.ITEM_ID
							   LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK) 
							   ON  D.LOOKUP_TYPE = 'CELL_TYPE_CODE' 
							   AND D.VALID_YN    = 'Y' 
							   AND D.SEGMENT1    = C.CELL_TYPE_GROUP_CODE
							   JOIN SCM_MST_SITE E WITH(NOLOCK)
							   ON   E.DIVISION_ID = @v_division_id
							   AND  ISNULL(E.COMPANY_ID, '')  = @v_company_id
							   AND  E.DIVISION_ID = A.DIVISION_ID
							   AND  E.SCM_SITE_ID = A.SCM_SITE_ID
							   -- jilee 230830
							   LEFT OUTER JOIN [LGCE_FPDEV_TR].[DBO].[SCM_ITEM_M] IM WITH(NOLOCK) 
				    		   ON  IM.DIVISION_ID = A.DIVISION_ID		
							   AND IM.COMPANY_ID = @V_COMPANY_ID							   
							   AND IM.SITE_ID = E.SITE_ID							   
							   AND IM.ITEM_ID = A.ITEM_ID
							   AND IM.ITEM_CLASS IN ('ES1901', 'ES2001','ES2002', 'ES2003', 'ES2004')							   
						WHERE  1=1 
						AND    A.DIVISION_ID = @v_division_id
						AND    A.SCM_SITE_ID IS NOT NULL 
						--AND    A.CUTOFF_DATE >  CONVERT(DATETIME, CONVERT(NVARCHAR, GETDATE()-1, 112)) -- GETDATE() - 5	
						--AND    A.CUTOFF_DATE >  GETDATE() - 5	
						AND    A.QTY <> 0

						UNION ALL 
						-- MES 재고정보 
						SELECT A.DIVISION_ID        AS DIVISION_ID
						,      'MES'                AS TYPE
						,      A.FROM_SITE			AS FROM_SITE
						--     jilee 230830		 				
						,      ISNULL(IM.APPLIED_MODEL, A.ITEM_ID)     AS ITEM_ID 						
						--,      A.ITEM_ID			AS ITEM_ID
						,      A.LOT_ID             AS LOT_ID
						--,      SUBSTRING(A.LOT_ID,1,8) AS LOT_ID2
						,      CASE WHEN ISNULL(C.SEGMENT3, '') = 'P' THEN
								   CASE WHEN CHARINDEX('-', A.LOT_ID) = 10 AND LEN(A.LOT_ID) = 13 THEN SUBSTRING(A.LOT_ID, 1, CHARINDEX('-', LOT_ID) -1) 
										WHEN CHARINDEX('-', A.LOT_ID) = 10 AND LEN(A.LOT_ID) > 13 THEN SUBSTRING(A.LOT_ID, 1, 10) 
										WHEN CHARINDEX('-', A.LOT_ID) <> 10 AND LEN(A.LOT_ID) > 13 THEN SUBSTRING(A.LOT_ID, 1, 10) 
								   ELSE SUBSTRING(A.LOT_ID, 1, 8) END
							   ELSE SUBSTRING(A.LOT_ID, 1, 8) END   AS LOT_ID2
						,      A.LOT_TYPE           AS LOT_TYPE
						,      A.LOT_QTY			AS LOT_QTY_MES
						,      0					AS LOT_QTY_FCS
						,      0                    AS LOT_QTY_TOT
						,      0                    AS FCS_SPECIAL_QTY
						-- AVAILABLE_YN_MES : MES_HOLD='Y'or QMS_HOLD='Y' 이거나 생산유효일(JUDG_VLD_DATE)이 과거일자 이면 AVAILABLE_YN_MES = 'N'
						-- PR_SSP_XIF_MES_FORMATION_LOT_QMS_INSP_RESULT_R 에서 MES I/F처리시 AVAILABLE_YN 적용됨  
						,      A.AVAILABLE_YN		AS AVAILABLE_YN_MES 
						,      NULL                 AS AVAILABLE_YN_FCS 
						,      A.MES_HOLD_YN		AS MES_HOLD_YN
						,      A.QMS_HOLD_YN		AS QMS_HOLD_YN
						,      NULL					AS FCS_HOLD_YN
						,      A.LONGTERM_HOLD_YN		AS LONGTERM_HOLD_YN -- [C20200303-000163] 신규추가
						,      NULL					AS FCS_SPECIAL_YN
						,      A.JUDG_VLD_DATE      AS JUDG_VLD_DATE
						,      A.MES_HOLD_RELEASE   AS MES_HOLD_RELEASE
						,      A.QMS_HOLD_RELEASE   AS QMS_HOLD_RELEASE
						,      ISNULL(CONVERT(decimal, A.ATTRIBUTE4),0)     AS ATTRIBUTE4
						FROM   SSP_DNM_GMES_STOCK_40 A WITH(NOLOCK) 
							   LEFT OUTER JOIN SCP_MST_FINAL_ITEM  B WITH(NOLOCK)
							   ON   B.DIVISION_ID = A.DIVISION_ID
							   AND  B.ITEM_ID = A.ITEM_ID
							   LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH(NOLOCK) 
							   ON  C.LOOKUP_TYPE = 'CELL_TYPE_CODE' 
							   AND C.VALID_YN    = 'Y' 
							   AND C.SEGMENT1    = B.CELL_TYPE_GROUP_CODE
							   JOIN SCM_MST_SITE E WITH(NOLOCK)
							   ON   E.DIVISION_ID = @v_division_id
							   AND  ISNULL(E.COMPANY_ID, '')  = @v_company_id
							   AND  E.DIVISION_ID = A.DIVISION_ID
							   AND  E.SCM_SITE_ID = A.FROM_SITE
							   -- jilee 230830
                               LEFT OUTER JOIN [LGCE_FPDEV_TR].[DBO].[SCM_ITEM_M] IM WITH(NOLOCK) 
				    		   ON   IM.DIVISION_ID = A.DIVISION_ID							   
							   AND  IM.COMPANY_ID = @V_COMPANY_ID
							   AND  IM.SITE_ID = E.SITE_ID
							   AND  IM.ITEM_ID = A.ITEM_ID
							   AND IM.ITEM_CLASS IN ('ES1901', 'ES2001','ES2002', 'ES2003', 'ES2004')			
						WHERE  A.DIVISION_ID = @v_division_id 
						--AND    A.YYYYMMDD    = CONVERT(VARCHAR, DATEADD(D, 1, CONVERT(DATETIME, @v_plan_start_yyyymmdd  ,112)) ,112) --  현재일(PLAN_START_YYYYMMDD + 1)
						AND    A.YYYYMMDD    = @v_plan_start_yyyymmdd
						AND    A.LOT_QTY <> 0
				 )  X 
				   JOIN SCM_MST_SITE C WITH(NOLOCK)
				   ON   C.DIVISION_ID = @v_division_id
				   AND  ISNULL(C.COMPANY_ID, '')  = @v_company_id
				   AND  C.DIVISION_ID = X.DIVISION_ID
				   AND  C.SCM_SITE_ID = X.FROM_SITE

			WHERE  X.DIVISION_ID =@v_division_id
			GROUP BY X.DIVISION_ID 
			,        X.FROM_SITE 
			,        X.ITEM_ID 
			,        X.LOT_ID2
			)


			-- 전일 내용 비교 후 신규/변경/삭제 상태 적용 후 TEMP 테이블 저장 
			INSERT INTO #tmp_SSP_ANL_MES_FCS_STOCK_40_C (
					DIVISION_ID               
			 ,      FROM_SITE                 
			 ,      ITEM_ID                   
			 ,      LOT_ID                    
			 ,      LOT_TYPE                  
			 ,      LOT_QTY_MES               
			 ,      LOT_QTY_FCS               
			 ,      LOT_QTY_TOT          
			 ,      FCS_SPECIAL_QTY     
			 ,      AVAILABLE_YN              
			 ,      MES_HOLD_YN               
			 ,      QMS_HOLD_YN               
			 ,      FCS_HOLD_YN               
			 ,      LONGTERM_HOLD_YN	-- [C20200303-000163] 신규추가
			 ,      JUDG_VLD_DATE             
			 ,      MES_HOLD_RELEASE          
			 ,      QMS_HOLD_RELEASE          
			 ,      USER_MOD_RELEASE_DATE     
			 ,      REMARKS                   
			 ,      SUM_DATE                  
			 ,      CHANGE_STATUS             
			 ,      CREATED_BY                
			 ,      CREATION_DATE             
			 ,      LAST_UPDATED_BY           
			 ,      LAST_UPDATE_DATE
			 ,      ATTRIBUTE4
			)
			-- 전일 정보와 비교 신규/삭제/변경 구분하여 생성 
			SELECT ISNULL(A.DIVISION_ID               , B.DIVISION_ID               )  AS DIVISION_ID      
			,      ISNULL(A.FROM_SITE                 , B.FROM_SITE                 )  AS FROM_SITE                 
			,      ISNULL(A.ITEM_ID                   , B.ITEM_ID                   )  AS ITEM_ID                   
			,      ISNULL(A.LOT_ID                    , B.LOT_ID                    )  AS LOT_ID                    
			,      ISNULL(A.LOT_TYPE                  , B.LOT_TYPE                  )  AS LOT_TYPE                  
			,      ISNULL(A.LOT_QTY_MES               , B.LOT_QTY_MES               )  AS LOT_QTY_MES               
			,      ISNULL(A.LOT_QTY_FCS               , B.LOT_QTY_FCS               )  AS LOT_QTY_FCS               
			,      ISNULL(A.LOT_QTY_TOT               , B.LOT_QTY_TOT               )  AS LOT_QTY_TOT  
			,      ISNULL(A.FCS_SPECIAL_QTY           , B.FCS_SPECIAL_QTY           )  AS FCS_SPECIAL_QTY     
			,      ISNULL(A.AVAILABLE_YN              , B.AVAILABLE_YN              )  AS AVAILABLE_YN      
			,      ISNULL(A.MES_HOLD_YN               , B.MES_HOLD_YN               )  AS MES_HOLD_YN               
			,      ISNULL(A.QMS_HOLD_YN               , B.QMS_HOLD_YN               )  AS QMS_HOLD_YN               
			,      ISNULL(A.FCS_HOLD_YN               , B.FCS_HOLD_YN               )  AS FCS_HOLD_YN
			,      ISNULL(A.LONGTERM_HOLD_YN          , B.LONGTERM_HOLD_YN          )  AS LONGTERM_HOLD_YN   -- [C20200303-000163] 신규추가     
			,      ISNULL(A.JUDG_VLD_DATE             , B.JUDG_VLD_DATE             )  AS JUDG_VLD_DATE             
			,      ISNULL(A.MES_HOLD_RELEASE          , B.MES_HOLD_RELEASE          )  AS MES_HOLD_RELEASE          
			,      ISNULL(A.QMS_HOLD_RELEASE          , B.QMS_HOLD_RELEASE          )  AS QMS_HOLD_RELEASE  
			--     이전 정보가 AVAILABLE_YN = 'N'이면 이전USER_MOD_RELEASE_DATE 유지      
			--,      CASE WHEN B.AVAILABLE_YN = 'N' THEN B.USER_MOD_RELEASE_DATE 
			,      CASE WHEN B.USER_MOD_RELEASE_DATE IS NOT NULL THEN B.USER_MOD_RELEASE_DATE 
			            ELSE 
						     CASE WHEN A.AVAILABLE_YN = 'N' THEN '29991231' 
							 ELSE NULL  
							 END 
						END                                                            AS USER_MOD_RELEASE_DATE
			,      ISNULL(A.REMARKS                   , B.REMARKS                   )  AS REMARKS                   
			,      @v_plan_start_yyyymmdd --  현재일(PLAN_START_YYYYMMDD + 1) AS SUM_DATE   
				   -- CHANGE_STATUS : 전일 기준 AVAILABLE_YN의 변경상태 : N(신규), C(변경), D(삭제), 'X'(변경없음) <--LOOKUP : MES_CHANGE_STATUS
			,      CASE WHEN B.AVAILABLE_YN IS NULL THEN 'N'  -- 신규 
						ELSE 
							 CASE WHEN A.AVAILABLE_YN IS NULL THEN 'D' -- 삭제 
								  ELSE 
									   CASE WHEN A.AVAILABLE_YN <> B.AVAILABLE_YN THEN 'C' -- 변경
									   ELSE 'X'  -- 변경없음  
									   END 
								  END  
						END															   AS CHANGE_STATUS                             
			,      ISNULL(B.CREATED_BY                , 'ssp_batch'                 )  AS CREATED_BY                
			,      ISNULL(B.CREATION_DATE             , GETDATE()                   )  AS CREATION_DATE             
			,      ISNULL(B.LAST_UPDATED_BY           , 'ssp_batch'                 )  AS LAST_UPDATED_BY           
			,      ISNULL(B.LAST_UPDATE_DATE          , GETDATE()                   )  AS LAST_UPDATE_DATE 
			,      ISNULL(A.ATTRIBUTE4                , B.ATTRIBUTE4                )  AS ATTRIBUTE4               

			FROM   NEW A WITH(NOLOCK) 
				FULL OUTER JOIN ( -- 이전 재고 정보    
				                SELECT 
									 A.DIVISION_ID
									,A.FROM_SITE																
									,A.ITEM_ID
									,A.LOT_ID
									,A.LOT_TYPE
									,A.LOT_QTY_MES
									,A.LOT_QTY_FCS
									,A.LOT_QTY_TOT
									,A.FCS_SPECIAL_QTY
									,A.AVAILABLE_YN
									,A.MES_HOLD_YN
									,A.QMS_HOLD_YN
									,A.FCS_HOLD_YN
									,A.LONGTERM_HOLD_YN    -- [C20200303-000163] 신규추가     
									,A.JUDG_VLD_DATE
									,A.MES_HOLD_RELEASE
									,A.QMS_HOLD_RELEASE
									,A.USER_MOD_RELEASE_DATE
									,A.REMARKS
									,A.CREATED_BY
									,A.CREATION_DATE
									,A.LAST_UPDATED_BY
									,A.LAST_UPDATE_DATE
									,A.ATTRIBUTE4
								FROM [SSP_ANL_MES_FCS_STOCK_40_C] A  WITH(NOLOCK)
									   JOIN SCM_MST_SITE E WITH(NOLOCK)
									   ON   E.DIVISION_ID = @v_division_id
									   AND  ISNULL(E.COMPANY_ID, '')  = @v_company_id
									   AND  E.DIVISION_ID = A.DIVISION_ID
									   AND  E.SCM_SITE_ID = A.FROM_SITE									   
								WHERE A.DIVISION_ID         = @v_division_id 
								AND   A.PLAN_START_YYYYMMDD = ( --@v_last_plan_start_yyyymmdd
															   SELECT MAX(PLAN_START_YYYYMMDD)
															   FROM   [SSP_ANL_MES_FCS_STOCK_40_C] C WITH(NOLOCK) 
															   WHERE  C.DIVISION_ID = @v_division_id
															   AND    C.PLAN_TYPE   = @v_last_plan_type
															   AND    C.SEQ         = @v_last_seq
															  ) 
								AND   A.PLAN_TYPE           = @v_last_plan_type
								AND   A.SEQ                 = @v_last_seq
								AND   A.CHANGE_STATUS       <> 'D' -- 삭제된건 제외 
								) B 
				ON  B.DIVISION_ID         = A.DIVISION_ID
				AND B.FROM_SITE           = A.FROM_SITE
				AND B.ITEM_ID             = A.ITEM_ID
				AND B.LOT_ID              = A.LOT_ID
			;


			-- SSP_ANL_MES_FCS_STOCK_40_C 생성전 Data Clear
			DELETE A
			FROM SSP_ANL_MES_FCS_STOCK_40_C A WITH(NOLOCK)
				JOIN SCM_MST_SITE E WITH(NOLOCK)
				ON   E.DIVISION_ID = @v_division_id
				AND  ISNULL(E.COMPANY_ID, '')  = @v_company_id
				AND  E.DIVISION_ID = A.DIVISION_ID
				AND  E.SCM_SITE_ID = A.FROM_SITE
			WHERE A.DIVISION_ID         = @v_division_id
			AND   A.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
			AND   A.PLAN_TYPE           = @v_plan_type
			AND   A.SEQ                 = @v_seq
			;

			-- SSP_ANL_MES_FCS_STOCK_40_C 생성
			INSERT INTO SSP_ANL_MES_FCS_STOCK_40_C(
					 DIVISION_ID
					,PLAN_START_YYYYMMDD
					,PLAN_TYPE
					,SEQ
					,FROM_SITE
					,ITEM_ID
					,LOT_ID
					,YYYYMMDD_LOT_ID
					,YYYYMMDD_LOT_ID_APPLIED_LT
					,LOT_TYPE
					,LOT_QTY_MES
					,LOT_QTY_FCS
					,LOT_QTY_TOT
					,LOT_QTY_TOT_YIELD
					,FCS_SPECIAL_QTY
					,OWMS_STOCK_QTY  
					,AVAILABLE_YN
					,MES_HOLD_YN
					,QMS_HOLD_YN
					,FCS_HOLD_YN
					,LONGTERM_HOLD_YN     -- [C20200303-000163] 신규추가    
					,JUDG_VLD_DATE
					,MES_HOLD_RELEASE
					,QMS_HOLD_RELEASE
					,USER_MOD_RELEASE_DATE
					,REMARKS
					,SUM_DATE
					,CHANGE_STATUS
					,CREATED_BY
					,CREATION_DATE
					,LAST_UPDATED_BY
					,LAST_UPDATE_DATE
					,ATTRIBUTE1
					,ATTRIBUTE2
					,ATTRIBUTE3
					,ATTRIBUTE4  --불량수량
					,ATTRIBUTE5
					,ATTRIBUTE6
					,ATTRIBUTE7
					,ATTRIBUTE8
					,ATTRIBUTE9
					,ATTRIBUTE10
					) 
			SELECT 
					 A.DIVISION_ID
					,@v_plan_start_yyyymmdd  AS PLAN_START_YYYYMMDD
					,@v_plan_type            AS PLAN_TYPE
					,@v_seq                  AS SEQ
					,A.FROM_SITE
					,A.ITEM_ID
					,A.LOT_ID
					,CASE WHEN ISDATE(LY.SEGMENT2 + LM.SEGMENT2+ SUBSTRING(A.LOT_ID,6,2))  = 1 THEN LY.SEGMENT2 + LM.SEGMENT2+ SUBSTRING(A.LOT_ID,6,2) 
						  ELSE NULL  END		AS YYYYMMDD_LOT_ID
					,CONVERT(VARCHAR(8), CONVERT(DATETIME, CASE WHEN ISDATE(LY.SEGMENT2 + LM.SEGMENT2+ SUBSTRING(A.LOT_ID,6,2))  = 1 
																	 THEN LY.SEGMENT2 + LM.SEGMENT2+ SUBSTRING(A.LOT_ID,6,2) 
																ELSE NULL END , 112) 
										 + (ISNULL(F.LT_FORMATION,0) + ISNULL(F.ATTRIBUTE1,0)) , 112) AS YYYYMMDD_LOT_ID_APPLIED_LT	
					,A.LOT_TYPE
					/* -- 수율 적용 
					,ROUND(A.LOT_QTY_MES * ISNULL(F.SSP_MODIFY_YIELD ,1), 0)                           AS LOT_QTY_MES
					,ROUND(A.LOT_QTY_FCS * ISNULL(F.SSP_MODIFY_YIELD ,1), 0)                           AS LOT_QTY_FCS
					,ROUND(A.LOT_QTY_MES * ISNULL(F.SSP_MODIFY_YIELD ,1), 0)  + ROUND(A.LOT_QTY_FCS * ISNULL(F.SSP_MODIFY_YIELD ,1), 0)  AS LOT_QTY_TOT
					,ROUND(A.FCS_SPECIAL_QTY * ISNULL(F.SSP_MODIFY_YIELD ,1), 0)                       AS FCS_SPECIAL_QTY
					 --------------------------------------------------------------------------------------------------------------------------------*/
					--수율 미적용 
					,ROUND(A.LOT_QTY_MES , 0)                           AS LOT_QTY_MES
					,ROUND(A.LOT_QTY_FCS , 0)                           AS LOT_QTY_FCS
					,ROUND(A.LOT_QTY_MES  + A.LOT_QTY_FCS , 0)          AS LOT_QTY_TOT
					,ROUND((A.LOT_QTY_MES + A.LOT_QTY_FCS) * ISNULL(F.SSP_MODIFY_YIELD ,1),0) AS LOT_QTY_TOT_YIELD --수율적용 토탈수량 추가
					,ROUND(A.FCS_SPECIAL_QTY , 0)                       AS FCS_SPECIAL_QTY
					--------------------------------------------------------------------------------------------------------------------------------		
					,ISNULL(S.OWMS_STOCK_QTY,0)                                                        AS OWMS_STOCK_QTY
					,A.AVAILABLE_YN
					,A.MES_HOLD_YN
					,A.QMS_HOLD_YN
					,A.FCS_HOLD_YN
					,A.LONGTERM_HOLD_YN     -- [C20200303-000163] 신규추가    
					,A.JUDG_VLD_DATE
					,A.MES_HOLD_RELEASE
					,A.QMS_HOLD_RELEASE
					,A.USER_MOD_RELEASE_DATE
					,A.REMARKS
					,A.SUM_DATE
					,A.CHANGE_STATUS
					,A.CREATED_BY
					,A.CREATION_DATE
					,A.LAST_UPDATED_BY
					,A.LAST_UPDATE_DATE
					,NULL -- ATTRIBUTE1
					,NULL -- ATTRIBUTE2
					,NULL -- ATTRIBUTE3
					,A.ATTRIBUTE4
					,NULL -- ATTRIBUTE5
					,NULL -- ATTRIBUTE6
					,NULL -- ATTRIBUTE7
					,NULL -- ATTRIBUTE8
					,NULL -- ATTRIBUTE9
					,NULL -- ATTRIBUTE10
			FROM #tmp_SSP_ANL_MES_FCS_STOCK_40_C A WITH(NOLOCK) 
				LEFT OUTER JOIN (   SELECT   A.DIVISION_ID 
									,        A.PLAN_START_YYYYMMDD
									,        A.PLAN_TYPE
									,        A.SEQ
									,        A.FROM_SITE
									,        A.ITEM_ID 
									,        SUBSTRING(A.LOT_ID,1,8) AS LOT_ID
									,        SUM(A.STOCK_QTY)        AS OWMS_STOCK_QTY -- MES STOCK DETAIL정보에는 AVAILABLE_QTY가아닌 전체 재고정보 적용
									FROM     SSP_ANL_OWMS_STOCK_C A WITH(NOLOCK) 
											   JOIN SCM_MST_SITE E WITH(NOLOCK)
											   ON   E.DIVISION_ID = @v_division_id
											   AND  ISNULL(E.COMPANY_ID, '')  = @v_company_id
											   AND  E.DIVISION_ID = A.DIVISION_ID
											   AND  E.SCM_SITE_ID = A.FROM_SITE
									WHERE    A.DIVISION_ID         = @v_division_id  
									AND      A.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd --@v_data_cutoff_yyyymmdd --
									AND      A.PLAN_TYPE           = @v_plan_type 
									AND      A.SEQ                 = @v_seq
									GROUP BY A.DIVISION_ID 
									,        A.PLAN_START_YYYYMMDD
									,        A.PLAN_TYPE
									,        A.SEQ
									,        A.FROM_SITE
									,        A.ITEM_ID 
									,        SUBSTRING(A.LOT_ID,1,8) 
									) S
                              ON S.FROM_SITE           = A.FROM_SITE
							 AND S.ITEM_ID             = A.ITEM_ID
							 AND S.LOT_ID              = A.LOT_ID   
                 LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LY WITH(NOLOCK) 
						      ON LY.LOOKUP_TYPE = 'LOT_ID_YEAR' 
							 AND LY.VALID_YN    = 'Y' 
							 AND LY.SEGMENT1    = SUBSTRING(A.LOT_ID,4,1)
                             AND LY.SEGMENT2 BETWEEN CONVERT(VARCHAR(4),DATEADD(YY,-11,GETDATE()),112) AND  CONVERT(VARCHAR(4),DATEADD(YY,8,GETDATE()),112)
				 LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LM WITH(NOLOCK) 
							  ON LM.LOOKUP_TYPE = 'LOT_ID_MONTH' 
							 AND LM.VALID_YN    = 'Y' 
							 AND LM.SEGMENT1    = SUBSTRING(A.LOT_ID,5,1)
				 LEFT OUTER	JOIN SCM_SYS_CALENDAR_M  C WITH(NOLOCK) -- 유효한 날짜만 추출 
							  ON C.BASIS_YYYYMMDD = LY.SEGMENT2 + LM.SEGMENT2+ SUBSTRING(A.LOT_ID,6,2)
				 LEFT OUTER JOIN SSP_ANL_FORMATION_C F WITH(NOLOCK) 
				  			  ON F.DIVISION_ID         = A.DIVISION_ID 
							 AND F.PLANT_SITE_ID       = A.FROM_SITE 
							 AND F.ITEM_ID             = A.ITEM_ID 
							 AND F.DIVISION_ID         = @v_division_id
							 AND F.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
							 AND F.PLAN_TYPE           = @v_plan_type
							 AND F.SEQ                 = @v_seq
             ;
			 
        ------------------------------------------------------------------------------------------------------------- 
        --2. MEASURE별 Data생성 
        ------------------------------------------------------------------------------------------------------------- 
        --temp 테이블 생성 : Measure까지 생성후 마지막에 한번에 입력하기 위해서
        IF OBJECT_ID('tempdb..#tmp_SSP_ANL_SHIP_PLAN_40') IS NOT NULL
            DROP TABLE #tmp_SSP_ANL_SHIP_PLAN_40
		------------------------------------------------------------------------------------------------------------- 
		/* ATTRIBUTE Description (#tmp_SSP_ANL_SHIP_PLAN_40)
		------------------------------------------------------------------------------------------------------------- 
				1)ATTRIBUTE1
					- LOT정보에 대한 생산일자
					- 적용MEASURE :[S]POSTP_PLAN(Post Process Plan), [P]PROD_PLAN(Production), [P]PROD_DATE(Production Date), 
					            [I]MES_FCS_HOLD(Hold Stock), [I]MES_FCS_RELEASE(Release Stock) 
				2)ATTRIBUTE2
					- REQUESTOR
					- 적용MEASURE :[S]SHIP_REQ(Shipment Request) , [S]SHIP_CONFIRM(Shipment Confirm)
				3)ATTRIBUTE3
					- Prod Qty(MASS) , oWMS Qty Description  : PSI화면에 Mouse over시 Display
					   ex)MASS Prod Qty : xxx / oWMS Qty : xxxx  
					- 적용MEASURE :[P]PROD_PLAN(Production)
				4)ATTRIBUTE4
					- (PRODUCTION_TYPE= MASS)QTY
					- 적용MEASURE :[P]PROD_PLAN(Production)
				5)ATTRIBUTE5
					- (PRODUCTION_TYPE= ALL)QTY
					- 적용MEASURE :[P]PROD_PLAN(Production)
				6)ATTRIBUTE6
					- OWMS 재고수량(SSP_ANL_OWMS_STOCK_C)
					- 적용MEASURE :[P]PROD_PLAN(Production)
		-------------------------------------------------------------------------------------------------------------*/
        CREATE TABLE #tmp_SSP_ANL_SHIP_PLAN_40(
				 DIVISION_ID  				nvarchar(030)
				,PLAN_START_YYYYMMDD		nvarchar(008)
				,PLAN_TYPE					nvarchar(050)
				,SEQ						INT	
				,ITEM_ID					nvarchar(050)
				,FROM_SITE					nvarchar(030)
				,TO_SITE					nvarchar(030)
				,MEASURE					nvarchar(050)
				,YYYYMMDD					nvarchar(008)
				,BOD_ID						nvarchar(150)
				,QTY						numeric(20,10)
				,ROUTE_ID					INT	
				,INCOTERMS					nvarchar(010)   
				,TRANSPORT_MODE				nvarchar(050)    
				,BIZ_TYPE					nvarchar(030)
				,PROJECT_CODE				nvarchar(050)
				,FCST_TYPE					nvarchar(020)
				,FCST_ETD_DATE				nvarchar(008)
				,FCST_ETA_DATE				nvarchar(008)
				,ETD_DATE					nvarchar(008)
				,ETA_DATE					nvarchar(008)
				,CONFIRM_ID					nvarchar(020)
				,ORIGIN_FROM_DIVISION_ID	nvarchar(030)
				,ORIGIN_TO_DIVISION_ID		nvarchar(030)
				,ATTRIBUTE1                 nvarchar(150)
				,ATTRIBUTE2                 nvarchar(150) 
				,ATTRIBUTE3                 nvarchar(150) 
				,ATTRIBUTE4                 nvarchar(150)
				,ATTRIBUTE5                 nvarchar(150)
				,ATTRIBUTE6                 nvarchar(150)
            );

			------------------------------------------------------------------------------------------------------------- 
			--2-1. [S]SHIP_REQ(Shipment Request)    : MKT 담당자가 출하요청한 수량 (SSP_ANL_SHIP_REQ)
			------------------------------------------------------------------------------------------------------------- 
			INSERT INTO #tmp_SSP_ANL_SHIP_PLAN_40
					(
					 DIVISION_ID  	     
					,PLAN_START_YYYYMMDD 
					,PLAN_TYPE	         
					,SEQ	             
					,ITEM_ID	         
					,FROM_SITE	         
					,TO_SITE	         
					,MEASURE	         
					,YYYYMMDD	         
					,BOD_ID	           
					,QTY	             
					,ROUTE_ID	         
					,INCOTERMS         
					,TRANSPORT_MODE    
					,BIZ_TYPE	         
					,PROJECT_CODE	     
					,FCST_TYPE	       
					,FCST_ETD_DATE	
					,FCST_ETA_DATE   
					,ETD_DATE	         
					,ETA_DATE
					,CONFIRM_ID	    
					,ORIGIN_FROM_DIVISION_ID
					,ORIGIN_TO_DIVISION_ID	
					,ATTRIBUTE2	 -- REQUESTOR 			     
					)
			SELECT 
					R.DIVISION_ID             AS DIVISION_ID  	                   
			,      @v_plan_start_yyyymmdd    AS PLAN_START_YYYYMMDD              
			,      @v_plan_type              AS PLAN_TYPE	                       
			,      @v_seq                    AS SEQ	                             
			,      R.ITEM_ID                 AS ITEM_ID	                         
			,      R.FROM_SITE	             AS FROM_SITE	                       
			,      R.TO_SITE	             AS TO_SITE	                         
			,      'SHIP_REQ'   	         AS MEASURE	                         
			,      R.YYYYMMDD	             AS YYYYMMDD	                       
			,      R.BOD_ID	                 AS BOD_ID	                         
			,      SUM(R.QTY)                AS QTY	                             
			,      ISNULL(S.ROUTE_ID, '-')	             AS ROUTE_ID	                       
			,      ISNULL(S.SSP_INCOTERMS, R.INCOTERMS)  AS INCOTERMS                        
			,      R.TRANSPORT_MODE          AS TRANSPORT_MODE                   
			,      R.BIZ_TYPE	             AS BIZ_TYPE	                       
			,      R.PROJECT_CODE	         AS PROJECT_CODE	                   
			,      R.FCST_TYPE	             AS FCST_TYPE	                       
			,      R.FCST_ETD_DATE	         AS FCST_ETD_DATE	                   
			,      R.FCST_ETA_DATE           AS FCST_ETA_DATE                    
			,      R.ETD_DATE	             AS ETD_DATE	                       
			,      R.ETA_DATE                AS ETA_DATE                         
			,      R.CONFIRM_ID	-- CONFIRM_ID 대신 REQ_DET_ID                      
			,      R.DIVISION_ID			 AS ORIGIN_FROM_DIVISION_ID          
			,      R.DIVISION_ID			 AS ORIGIN_TO_DIVISION_ID  
			,      R.CREATED_BY              AS ATTRIBUTE2 --REQUESTOR     
			FROM   (
			        SELECT R.DIVISION_ID
						, R.ITEM_ID
						, R.PLANT_SITE_ID  AS FROM_SITE
						, R.SCM_SITE_ID    AS TO_SITE
						, R.MEASURE
						, R.YYYYMMDD
						, R.BOD_ID
						, R.QTY
						, R.INCOTERMS
						, R.TRANSPORT_MODE
						, CASE WHEN CHARINDEX('-', R.PLANT_SITE_ID) = 0 THEN 'A'
						  ELSE SUBSTRING(R.PLANT_SITE_ID, CHARINDEX('-', R.PLANT_SITE_ID)+1, 1) END   AS BIZ_TYPE
						, R.PROJECT_CODE
						, R.FCST_TYPE
						, R.YYYYMMDD AS FCST_ETD_DATE
						, [dbo].[FN_GET_SSP_ETA_DATE](R.DIVISION_ID, R.BOD_ID, R.YYYYMMDD) AS FCST_ETA_DATE
						, R.YYYYMMDD AS ETD_DATE
						, [dbo].[FN_GET_SSP_ETA_DATE](R.DIVISION_ID, R.BOD_ID, R.YYYYMMDD) AS ETA_DATE
						, R.ATTRIBUTE10                                                    AS CONFIRM_ID
						, R.CREATED_BY
					FROM   DM_PLN_SHIPMENT_REQ R WITH(NOLOCK) 
					       JOIN  SCM_MST_SITE  B WITH(NOLOCK) 
						   ON  B.OPERATION_GROUP <> 'E'
						   --AND B.VALID_YN         = 'Y'
						   AND B.DIVISION_ID      = R.DIVISION_ID
						   AND B.SCM_SITE_ID      = R.PLANT_SITE_ID
					WHERE  1=1 
					AND    R.DIVISION_ID = @p_division_id 
					AND    R.MEASURE     = 'SHIP_REQ'
					AND    R.QTY         > 0
					AND    R.YYYYMMDD    >= @v_data_start_yyyymmdd
					AND    R.YYYYMMDD    <= @v_data_end_yyyymmdd

					UNION ALL

			        SELECT R.DIVISION_ID
						, R.MODEL_ID       AS ITEM_ID
						, R.FROM_SITE      AS FROM_SITE
						, R.TO_SITE        AS TO_SITE
						, N'SHIP_REQ'      AS MEASURE
						, R.YYYYMMDD
						, R.BOD_ID
						, R.QTY
						, R.INCOTERMS
						, R.TRANSPORT_MODE
						, CASE WHEN CHARINDEX('-', R.FROM_SITE) = 0 THEN 'P'
						  ELSE SUBSTRING(R.FROM_SITE, CHARINDEX('-', R.FROM_SITE)+1, 1) END   AS BIZ_TYPE
						, '-'               AS PROJECT_CODE
						, '-'               AS FCST_TYPE
						, R.YYYYMMDD AS FCST_ETD_DATE
						, [dbo].[FN_GET_SSP_ETA_DATE](R.DIVISION_ID, R.BOD_ID, R.YYYYMMDD) AS FCST_ETA_DATE
						, R.YYYYMMDD AS ETD_DATE
						, [dbo].[FN_GET_SSP_ETA_DATE](R.DIVISION_ID, R.BOD_ID, R.YYYYMMDD) AS ETA_DATE
						, R.ATTRIBUTE10                                                    AS CONFIRM_ID
						, @v_batch_user      AS CREATED_BY  --R.CREATED_BY
					FROM   SSP_ANL_SHIP_PLAN_PACK_REQ R WITH(NOLOCK)       
					WHERE  1=1 
					AND    R.DIVISION_ID = @p_division_id 
					AND    R.QTY         > 0
					AND    R.YYYYMMDD    >= @v_data_start_yyyymmdd
					AND    R.YYYYMMDD    <= @v_data_end_yyyymmdd
			       ) R
					LEFT OUTER JOIN SCP_MST_BOD_N_V  S WITH(NOLOCK)
					ON    S.INCOTERMS <> S.SSP_INCOTERMS
					AND   S.DIVISION_ID = R.DIVISION_ID
					AND   S.FROM_SITE   = R.FROM_SITE
					AND   S.BOD_ID      = R.BOD_ID
					JOIN SCM_MST_SITE E WITH(NOLOCK)
					ON    E.DIVISION_ID = @v_division_id
					AND   ISNULL(E.COMPANY_ID, '')  = @v_company_id
					AND   E.DIVISION_ID = R.DIVISION_ID
					AND   E.SCM_SITE_ID = R.FROM_SITE
			WHERE 1=1 
			AND   R.DIVISION_ID = @v_division_id
			--AND   R.PLAN_TYPE   = @v_plan_type
			AND   R.MEASURE     = 'SHIP_REQ'
			AND   R.YYYYMMDD    >= @v_data_start_yyyymmdd 	  
			AND   R.YYYYMMDD    <  @v_data_end_yyyymmdd 
			GROUP BY R.DIVISION_ID  
			,      R.ITEM_ID        
			,      R.FROM_SITE	    
			,      R.TO_SITE	    
			,      R.YYYYMMDD	    
			,      R.BOD_ID	        
			,      ISNULL(S.ROUTE_ID, '-')
			,      ISNULL(S.SSP_INCOTERMS, R.INCOTERMS)
			,      R.TRANSPORT_MODE 
			,      R.BIZ_TYPE	    
			,      R.PROJECT_CODE
			,      R.FCST_TYPE	  
			,      R.FCST_ETD_DATE
			,      R.FCST_ETA_DATE
			,      R.ETD_DATE	
			,      R.ETA_DATE   
			,      R.CONFIRM_ID	
			,      R.CREATED_BY
			;
			
			------------------------------------------------------------------------------------------------------------- 
			--2-2. [S]SHIP_CONFIRM(Shipment Confirm): 출하 확정 수량  
			------------------------------------------------------------------------------------------------------------- 
			INSERT INTO #tmp_SSP_ANL_SHIP_PLAN_40
					(
					 DIVISION_ID  	     
					,PLAN_START_YYYYMMDD 
					,PLAN_TYPE	         
					,SEQ	             
					,ITEM_ID	         
					,FROM_SITE	         
					,TO_SITE	         
					,MEASURE	         
					,YYYYMMDD	         
					,BOD_ID	           
					,QTY	             
					,ROUTE_ID	         
					,INCOTERMS         
					,TRANSPORT_MODE    
					,BIZ_TYPE	         
					,PROJECT_CODE	     
					,FCST_TYPE	       
					,FCST_ETD_DATE	
					,FCST_ETA_DATE   
					,ETD_DATE	         
					,ETA_DATE
					,CONFIRM_ID	    
					,ORIGIN_FROM_DIVISION_ID
					,ORIGIN_TO_DIVISION_ID	
					,ATTRIBUTE2  -- REQUESTOR				     
					)
			SELECT A.DIVISION_ID  	     
					,A.PLAN_START_YYYYMMDD 
					,A.PLAN_TYPE	         
					,A.SEQ	             
					,A.ITEM_ID	         
					,A.FROM_SITE	         
					,A.TO_SITE	         
					,A.MEASURE	         
					,A.YYYYMMDD	         
					,A.BOD_ID	           
					,SUM(A.QTY)	             AS QTY
					,A.ROUTE_ID
					,A.INCOTERMS         
					,A.TRANSPORT_MODE    
					,A.BIZ_TYPE	         
					,A.PROJECT_CODE	     
					,A.FCST_TYPE	       
					,A.FCST_ETD_DATE
					,MAX(A.FCST_ETA_DATE)   AS    FCST_ETA_DATE
					,A.ETD_DATE
					,MAX(A.ETA_DATE)   AS ETA_DATE
					,MAX(A.CONFIRM_ID)	    AS CONFIRM_ID
					,A.ORIGIN_FROM_DIVISION_ID
					,A.ORIGIN_TO_DIVISION_ID	
					,MAX(A.ATTRIBUTE2)
			FROM   (
					SELECT 
							C.DIVISION_ID             AS DIVISION_ID  	                   
					,      @v_plan_start_yyyymmdd    AS PLAN_START_YYYYMMDD              
					,      @v_plan_type              AS PLAN_TYPE	                       
					,      @v_seq                    AS SEQ	                             
					,      C.ITEM_ID                 AS ITEM_ID	                         
					,      C.FROM_SITE	             AS FROM_SITE	                       
					,      C.TO_SITE	             AS TO_SITE	                         
					,      'SHIP_CONFIRM'	         AS MEASURE	                         
					,      C.YYYYMMDD	             AS YYYYMMDD	                       
					,      C.BOD_ID	                 AS BOD_ID	                         
					,      C.QTY	                 AS QTY	                             
					,      C.ROUTE_ID	             AS ROUTE_ID	                       
					,      ISNULL(S.SSP_INCOTERMS, C.INCOTERMS)               AS INCOTERMS                        
					,      C.TRANSPORT_MODE          AS TRANSPORT_MODE                   
					,      C.BIZ_TYPE	             AS BIZ_TYPE	                       
					,      C.PROJECT_CODE	         AS PROJECT_CODE	                   
					,      C.FCST_TYPE	             AS FCST_TYPE	                       
					,      C.FCST_ETD_DATE	         AS FCST_ETD_DATE	                   
					,      C.FCST_ETA_DATE           AS FCST_ETA_DATE                    
					,      C.ETD_DATE	             AS ETD_DATE	                       
					,      C.ETA_DATE                AS ETA_DATE                         
					,      C.CONFIRM_ID	             AS CONFIRM_ID	                     
					,      C.DIVISION_ID             AS ORIGIN_FROM_DIVISION_ID          
					,      C.DIVISION_ID             AS ORIGIN_TO_DIVISION_ID 
					,      C.REQUESTOR               AS ATTRIBUTE2  -- REQUESTOR	
					FROM   SSP_ANL_SHIP_CONFIRM  C WITH(NOLOCK) 
							LEFT OUTER JOIN SCP_MST_BOD_N_V  S WITH(NOLOCK)
							ON    S.INCOTERMS <> S.SSP_INCOTERMS
							AND   S.DIVISION_ID = C.DIVISION_ID
							AND   S.FROM_SITE   = C.FROM_SITE
							AND   S.BOD_ID      = C.BOD_ID
							JOIN SCM_MST_SITE E WITH(NOLOCK)
							ON    E.DIVISION_ID = @v_division_id
							AND   ISNULL(E.COMPANY_ID, '')  = @v_company_id
							AND   E.DIVISION_ID = C.DIVISION_ID
							AND   E.SCM_SITE_ID = C.FROM_SITE
					WHERE  C.DIVISION_ID = @v_division_id
					AND    C.CHANGE_TYPE = 'C'
					AND    C.BIZ_TYPE   <> 'E' -- 전극제외 
					AND    C.QTY > 0 
					AND    C.YYYYMMDD    >= @v_data_start_yyyymmdd 	  
					AND    C.YYYYMMDD    <  @v_data_end_yyyymmdd 

					UNION ALL

					SELECT R.DIVISION_ID
					,      @v_plan_start_yyyymmdd    AS PLAN_START_YYYYMMDD              
					,      @v_plan_type              AS PLAN_TYPE	                       
					,      @v_seq                    AS SEQ	                             
						, R.ITEM_ID
						, R.PLANT_SITE_ID  AS FROM_SITE
						, R.SCM_SITE_ID    AS TO_SITE
					,      'SHIP_CONFIRM'	         AS MEASURE	                         
						, R.YYYYMMDD
						, R.BOD_ID
						, R.QTY
						, S.ROUTE_ID AS ROUTE_ID
						, R.INCOTERMS
						, R.TRANSPORT_MODE
						, CASE WHEN CHARINDEX('-', R.PLANT_SITE_ID) = 0 THEN 'A' ELSE SUBSTRING(R.PLANT_SITE_ID, CHARINDEX('-', R.PLANT_SITE_ID)+1, 1) END   AS BIZ_TYPE
						, R.PROJECT_CODE
						, R.FCST_TYPE

						, R.YYYYMMDD AS FCST_ETD_DATE
						, [dbo].[FN_GET_SSP_ETA_DATE](R.DIVISION_ID, R.BOD_ID, R.YYYYMMDD) AS FCST_ETA_DATE
						, R.YYYYMMDD AS ETD_DATE
						, [dbo].[FN_GET_SSP_ETA_DATE](R.DIVISION_ID, R.BOD_ID, R.YYYYMMDD) AS ETA_DATE

						, R.ATTRIBUTE10                                                    AS CONFIRM_ID
					,      R.DIVISION_ID             AS ORIGIN_FROM_DIVISION_ID          
					,      R.DIVISION_ID             AS ORIGIN_TO_DIVISION_ID 
						, NULL   AS ATTRIBUTE2
					FROM   DM_PLN_SHIPMENT_REQ R WITH(NOLOCK) 
							JOIN SCM_MST_SITE E WITH(NOLOCK)
							ON    E.DIVISION_ID = @v_division_id
							AND   ISNULL(E.COMPANY_ID, '')  = @v_company_id
							AND   E.DIVISION_ID = R.DIVISION_ID
							AND   E.SCM_SITE_ID = R.PLANT_SITE_ID
							JOIN SCP_MST_BOD_N_V  S WITH(NOLOCK)
							ON    S.DIVISION_ID = R.DIVISION_ID
							AND   S.FROM_SITE   = R.PLANT_SITE_ID
							AND   S.BOD_ID      = R.BOD_ID
					WHERE  1=1 
					AND    R.DIVISION_ID = @p_division_id 
					AND    R.MEASURE     = 'SHIP_REQ'
					AND    R.QTY         > 0
					AND    R.YYYYMMDD    >= @v_data_start_yyyymmdd
					AND    R.YYYYMMDD    <= @v_data_end_yyyymmdd
					AND    R.YYYYMMDD    > (CASE WHEN ISNULL([DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](R.DIVISION_ID, R.PLANT_SITE_ID), 0) = 0 THEN @v_plan_start_yyyymmdd
											ELSE CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](R.DIVISION_ID, R.PLANT_SITE_ID)-1, @v_plan_start_yyyymmdd) ,112) END)
					AND    R.ATTRIBUTE10 IS NULL
				   ) A
			WHERE  1 = 1
			GROUP BY A.DIVISION_ID  	     
					,A.PLAN_START_YYYYMMDD 
					,A.PLAN_TYPE	         
					,A.SEQ	             
					,A.ITEM_ID	         
					,A.FROM_SITE	         
					,A.TO_SITE	         
					,A.MEASURE	         
					,A.YYYYMMDD	         
					,A.BOD_ID	           
					,A.ROUTE_ID
					,A.INCOTERMS         
					,A.TRANSPORT_MODE    
					,A.BIZ_TYPE	         
					,A.PROJECT_CODE	     
					,A.FCST_TYPE	  
					,A.FCST_ETD_DATE
					,A.ETD_DATE     
					,A.ORIGIN_FROM_DIVISION_ID
					,A.ORIGIN_TO_DIVISION_ID
			;

			------------------------------------------------------------------------------------------------------------- 
			--2-3. [S]POSTP_PLAN (Post Process Plan): 활성화 후 공정에서 필요로 Barecell 소요량  (2019.05.15)
			------------------------------------------------------------------------------------------------------------- 
			--temp 테이블 생성 : Measure까지 생성후 마지막에 한번에 입력하기 위해서
			IF OBJECT_ID('tempdb..#tmp_SSP_FORMATION_POST_CELL') IS NOT NULL
				DROP TABLE #tmp_SSP_FORMATION_POST_CELL

			CREATE TABLE #tmp_SSP_FORMATION_POST_CELL(
					 DIVISION_ID  				nvarchar(030)
					,ITEM_ID					nvarchar(050)
					,FROM_SITE					nvarchar(030)
					,TO_SITE					nvarchar(030)
					,MEASURE					nvarchar(050)
					,YYYYMMDD					nvarchar(008)
					,BOD_ID						nvarchar(150)
					,QTY						numeric(20,10)
					,INCOTERMS					nvarchar(010)   
					,TRANSPORT_MODE				nvarchar(050)    
					,PROJECT_CODE				nvarchar(050)
					,FCST_TYPE					nvarchar(020)
					,CONFIRM_ID					nvarchar(020)
					,ORIGIN_FROM_DIVISION_ID	nvarchar(030)
					,ORIGIN_TO_DIVISION_ID		nvarchar(030)
				);

			INSERT INTO #tmp_SSP_FORMATION_POST_CELL
					(
					 DIVISION_ID  		
					,ITEM_ID					
					,FROM_SITE				
					,TO_SITE					
					,MEASURE					
					,YYYYMMDD					
					,BOD_ID						
					,QTY						
					,INCOTERMS				 
					,TRANSPORT_MODE		    
					,PROJECT_CODE			
					,FCST_TYPE				
					,CONFIRM_ID				
					,ORIGIN_FROM_DIVISION_ID	
					,ORIGIN_TO_DIVISION_ID				 
					)
			SELECT  P.DIVISION_ID				AS DIVISION_ID
			-- jilee 230830			
			,       ISNULL(IM.APPLIED_MODEL, P.CELL_ITEM_ID) AS ITEM_ID
			--,       P.CELL_ITEM_ID				AS ITEM_ID 
			,       P.SCM_SITE_ID				AS FROM_SITE
			,       '-'							AS TO_SITE
			,       'POSTP_PLAN'				AS MEASURE
			,       P.PLAN_DATE                 AS YYYYMMDD
			,       '-'							AS BOD_ID     
			,		P.PLAN_QTY                  AS QTY 
			,		'-'							AS INCOTERMS
			,		'-'							AS TRANSPORT_MODE
			,		'-'							AS PROJECT_CODE
			,		'-'							AS FCST_TYPE
			,		'-'							AS CONFIRM_ID
			,       P.DIVISION_ID				AS ORIGIN_FROM_DIVISION_ID
			,       P.DIVISION_ID				AS ORIGIN_TO_DIVISION_ID
			FROM    [SSP_FORMATION_POST_CELL_V] P WITH(NOLOCK)  
					JOIN SCM_MST_SITE E WITH(NOLOCK)
					ON    E.DIVISION_ID = @v_division_id
					AND   ISNULL(E.COMPANY_ID, '')  = @v_company_id
					AND   E.DIVISION_ID = P.DIVISION_ID
					AND   E.SCM_SITE_ID = P.SCM_SITE_ID
					-- jilee 230830
					LEFT OUTER JOIN [LGCE_FPDEV_TR].[DBO].[SCM_ITEM_M] IM WITH(NOLOCK) 
						ON   IM.DIVISION_ID = P.DIVISION_ID							   
						AND  IM.COMPANY_ID = @v_company_id
						AND  IM.SITE_ID = P.SITE_ID
						AND  IM.ITEM_ID = P.CELL_ITEM_ID
						AND  IM.ITEM_CLASS IN ('ES1901', 'ES2001','ES2002', 'ES2003', 'ES2004')	
			WHERE   P.DIVISION_ID = @v_division_id
			;

			INSERT INTO #tmp_SSP_ANL_SHIP_PLAN_40
					(
					 DIVISION_ID  	     
					,PLAN_START_YYYYMMDD 
					,PLAN_TYPE	         
					,SEQ	             
					,ITEM_ID	         
					,FROM_SITE	         
					,TO_SITE	         
					,MEASURE	         
					,YYYYMMDD	         
					,BOD_ID	           
					,QTY	             
					,INCOTERMS         
					,TRANSPORT_MODE    
					,PROJECT_CODE	
					,FCST_TYPE
					,CONFIRM_ID						     
					,ORIGIN_FROM_DIVISION_ID
					,ORIGIN_TO_DIVISION_ID 	
					)  
			SELECT  DIVISION_ID				    AS DIVISION_ID
			,       @v_plan_start_yyyymmdd		AS PLAN_START_YYYYMMDD
			,       @v_plan_type				AS PLAN_TYPE
			,       @v_seq						AS SEQ
			,       ITEM_ID						AS ITEM_ID 
			,       FROM_SITE				    AS FROM_SITE
			,       '-'							AS TO_SITE
			,       'POSTP_PLAN'				AS MEASURE
			,       YYYYMMDD                    AS YYYYMMDD
			,       '-'							AS BOD_ID     
			,		SUM(QTY)                    AS QTY 
			,		'-'							AS INCOTERMS
			,		'-'							AS TRANSPORT_MODE
			,		'-'							AS PROJECT_CODE
			,		'-'							AS FCST_TYPE
			,		'-'							AS CONFIRM_ID
			,       DIVISION_ID				AS ORIGIN_FROM_DIVISION_ID
			,       DIVISION_ID				AS ORIGIN_TO_DIVISION_ID
			FROM    #tmp_SSP_FORMATION_POST_CELL
			WHERE  DIVISION_ID =  @v_division_id
			AND    YYYYMMDD    >= @v_data_start_yyyymmdd 
			AND    YYYYMMDD    <  @v_data_end_yyyymmdd 
			GROUP BY DIVISION_ID
			,        ITEM_ID
			,        FROM_SITE
			,        YYYYMMDD
			;
						
			------------------------------------------------------------------------------------------------------------- 
			--2-4. [P]PROD_PLAN(Production)         : 조립실적+계획(활성화 L/T, 수율 적용) : 
			------------------------------------------------------------------------------------------------------------- 
			/*	A9000	Packaging
				A3000	Assembly
				F7000	DSF
				F7100	TCO
				F7200	Taping
				F7300	Side Taping
				F6200   External Tap Welding    -- 2019.04.19 추가 requested by 김광희

				CNJ Pouch 특성실적 반영 (2019.05.17) 단, 조립실적과 중복시 특성을 우선함 
				F5400 : Grading (Pouch) <-- 2019.05.30 추가 
				F5500 : Grading/Charateristic (Pouch)
				F5600 : Offline Charateristic Measurement (Pouch)
						실적일 (D-2,D-1)을 계획일(D, D+1)에 반영 
						대상 공정 F5500 : Grading/Charateristic (Pouch), F5600 : Offline Charateristic Measurement (Pouch)
						ex) 5/15실적 --> 5/17일 계획  계획 

				CNJ Pouch 특성계획 반영 (2019.05.28) 단, 조립계획과 중복시 특성을 우선함
				F5400 : Grading (Pouch) <-- 2019.05.30 추가 
				F5500 : Grading/Charateristic (Pouch)
				F5600 : Offline Charateristic Measurement (Pouch)

				조립실적일자를 실적완료일이 아닌 MES LOT실적으로 LOTID의 일자 기준으로 적용(2019.07.22) [CSR ID:4045697]
				SCM_DNM_PRODUCT_RESULT_V --> [LGCE_FP_TR].[DBO].[SCM_MES_WIP_HISTORY_H]  
                MES LOT실적 적용대상을 A3000번 공정만 적용하는것으로 수정, 나머지는 FP실적 기준 (2019.09.17)
			------------------------------------------------------------------------------------------------------------- 
				실적 
				 - MES-LOT별실적(RESULT_MES_LOT) : A3000						
				 - 조립실적(RESULT_FP_ASSY) : A9000	F6200 F7000	F7100 F7200	F7300	
				 - 특성실적(RESULT_FP_POUCH): F5400	F5500 F5600				
				계획
				 - 조립계획(PLAN_FP_ASSY)	: A3000	A9000 F6200	F7000 F7100	F7200 F7300
				 - 특성계획(RESULT_FP_POUCH): F5400	F5500 F5600		
				 - 외주생산계획 (PLAN_SSP_OSP): SSP0018(Production Plan(OSP)) 화면에서 입력한 계획
				 - 생산계획없는 모델 추가 ( MY MODEL에 담당자 지정된 모델은 강제로 생성) 
			------------------------------------------------------------------------------------------------------------- 
                 [C20200115-000418]-1 : Production Type별(MASS / 전체) 수량 추출
				  - ATTRIBUTE4 : MASS Prod Qty  
				  - ATTRIBUTE5 : 전체 Prod Qty
			------------------------------------------------------------------------------------------------------------- */

			-- MES Lot별 실적 정보 TEMP TABLE생성  LOT_ID를 날짜로 환산하여 수량 적용을 위함 
			IF OBJECT_ID('tempdb..#tmp_SSP_MES_WIP_HISTORY') IS NOT NULL
				DROP TABLE #tmp_SSP_MES_WIP_HISTORY

			CREATE TABLE #tmp_SSP_MES_WIP_HISTORY(
				 	 DIVISION_ID  				NVARCHAR(030)
					,SCM_SITE_ID				NVARCHAR(030)
					,ITEM_ID					NVARCHAR(050)
					,PLAN_DATE                  DATETIME
					,LOT                        NVARCHAR(020) 
					,QTY						NUMERIC(20,10)
					,OPERATION_ID               NVARCHAR(020) 
					,PRODUCTION_TYPE            NVARCHAR(150) 
			);


			INSERT INTO #tmp_SSP_MES_WIP_HISTORY(
					 DIVISION_ID  				
					,SCM_SITE_ID				
					,ITEM_ID					
					,PLAN_DATE                   
					,LOT                         
					,QTY						
					,OPERATION_ID  
					,PRODUCTION_TYPE              		
			)
			SELECT   A.DIVISION_ID  				
					,A.SCM_SITE_ID
					-- jilee 230830	 				
					,ISNULL(IM.APPLIED_MODEL, A.ITEM_ID) AS ITEM_ID
					--,A.ITEM_ID					
					,A.PLAN_DATE                   
					,A.LOT                         
					,A.QTY						
					,A.OPERATION_ID  
					,A.PRODUCTION_TYPE  
			FROM   (
					SELECT S.DIVISION_ID    AS DIVISION_ID 
					,      DBO.FN_GET_SCM_SITE_ID_PLANT (S.PLANT_ID, DBO.FN_GET_ITEM_OPERATION_GROUP(S.DIVISION_ID, R.PRODID) )  AS SCM_SITE_ID 
					,      R.PRODID AS ITEM_ID					
					,      CONVERT(DATETIME, LY.SEGMENT2 + LM.SEGMENT2+ SUBSTRING(R.ATTRIBUTE7,6,2), 112) AS PLAN_DATE
					,      SUBSTRING(R.ATTRIBUTE7,4,4) AS LOT  -- LOT_ID 
					,      SUM(R.WIPQTY2_ENGINE)   AS QTY      -- FP 반영 양품 Out 수량
					,      R.PROCID  AS OPERATION_ID
					,      R.ATTRIBUTE6 AS PRODUCTION_TYPE
			        FROM [LGCE_FPDEV_TR].[DBO].[SCM_MES_WIP_HISTORY_H] R WITH(NOLOCK) -- SCM_MES_WIP_HISTORY_H_SN R WITH(NOLOCK) 
							JOIN SCM_MST_FACTORY_SN S WITH(NOLOCK) 
								ON S.SITE_ID = R.ATTRIBUTE1 
								AND S.FACTORY_ID = R.ATTRIBUTE2 
							JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LY WITH(NOLOCK) 
								ON  LY.LOOKUP_TYPE = 'LOT_ID_YEAR' 
								AND LY.VALID_YN    = 'Y' 
								AND LY.SEGMENT1    = SUBSTRING(R.ATTRIBUTE7,4,1)
								AND LY.SEGMENT2 BETWEEN CONVERT(VARCHAR(4),DATEADD(YY,-11,GETDATE()),112) AND  CONVERT(VARCHAR(4),DATEADD(YY,8,GETDATE()),112)
							JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LM WITH(NOLOCK) 
								ON  LM.LOOKUP_TYPE = 'LOT_ID_MONTH' 
								AND LM.VALID_YN    = 'Y' 
								AND LM.SEGMENT1    = SUBSTRING(R.ATTRIBUTE7,5,1)
							JOIN SCM_SYS_CALENDAR_M    C WITH(NOLOCK) -- 유효한 날짜만 추출 
								ON C.BASIS_YYYYMMDD = LY.SEGMENT2 + LM.SEGMENT2+ SUBSTRING(R.ATTRIBUTE7,6,2)                            
					WHERE  R.PROCID = 'A3000'  
					AND    R.WIP_TYPE_CODE in ( 'OUT','INOUT','PACKED', 'PROD')
					AND    R.ATTRIBUTE7 IS NOT NULL 
					AND    R.WIPQTY2_ENGINE > 0  
					AND    S.DIVISION_ID = @v_division_id
					GROUP BY S.DIVISION_ID
					,        S.PLANT_ID
					,        R.PRODID 					
					,        CONVERT(DATETIME, LY.SEGMENT2 + LM.SEGMENT2+ SUBSTRING(R.ATTRIBUTE7,6,2), 112)
					,        SUBSTRING(R.ATTRIBUTE7,4,4)
					,        R.PROCID
					,        R.ATTRIBUTE6 -- PRODUCTION_TYPE
				   ) A
					JOIN SCM_MST_SITE E WITH(NOLOCK)
					ON    E.DIVISION_ID = @v_division_id
					AND   ISNULL(E.COMPANY_ID, '')  = @v_company_id
					AND   E.DIVISION_ID = A.DIVISION_ID
					AND   E.SCM_SITE_ID = A.SCM_SITE_ID
					-- jilee 230830
					LEFT OUTER JOIN [LGCE_FPDEV_TR].[DBO].[SCM_ITEM_M] IM WITH(NOLOCK) 
						ON   IM.DIVISION_ID = A.DIVISION_ID							   
						AND  IM.COMPANY_ID = @v_company_id
						AND  IM.SITE_ID = E.SITE_ID
						AND  IM.ITEM_ID = A.ITEM_ID
						AND  IM.ITEM_CLASS IN ('ES1901', 'ES2001','ES2002', 'ES2003', 'ES2004')	
			WHERE  1 = 1
			;
			
			-- jilee 230830 생산코드 복수(2개이상)일때 모델코드가 같은 경우, 중복 발생에 의한 Data Merge를 위한 임시 테이블
            IF OBJECT_ID('tempdb..#tmp_SSP_ANL_SHIP_PLAN_40_TEMP') IS NOT NULL
            DROP TABLE #tmp_SSP_ANL_SHIP_PLAN_40_TEMP
		
            CREATE TABLE #tmp_SSP_ANL_SHIP_PLAN_40_TEMP(
				 DIVISION_ID  				nvarchar(030)
				,PLAN_START_YYYYMMDD		nvarchar(008)
				,PLAN_TYPE					nvarchar(050)
				,SEQ						INT	
				,ITEM_ID					nvarchar(050)
				,FROM_SITE					nvarchar(030)
				,TO_SITE					nvarchar(030)
				,MEASURE					nvarchar(050)
				,YYYYMMDD					nvarchar(008)
				,BOD_ID						nvarchar(150)
				,QTY						numeric(20,10)
				,ROUTE_ID					INT	
				,INCOTERMS					nvarchar(010)   
				,TRANSPORT_MODE				nvarchar(050)    
				,BIZ_TYPE					nvarchar(030)
				,PROJECT_CODE				nvarchar(050)
				,FCST_TYPE					nvarchar(020)
				,FCST_ETD_DATE				nvarchar(008)
				,FCST_ETA_DATE				nvarchar(008)
				,ETD_DATE					nvarchar(008)
				,ETA_DATE					nvarchar(008)
				,CONFIRM_ID					nvarchar(020)
				,ORIGIN_FROM_DIVISION_ID	nvarchar(030)
				,ORIGIN_TO_DIVISION_ID		nvarchar(030)
				,ATTRIBUTE1                 nvarchar(150)
				,ATTRIBUTE2                 nvarchar(150) 
				,ATTRIBUTE3                 nvarchar(150) 
				,ATTRIBUTE4                 nvarchar(150)
				,ATTRIBUTE5                 nvarchar(150)
				,ATTRIBUTE6                 nvarchar(150)
            );

			-- PROD_PLAN Data 생성  
			INSERT INTO #tmp_SSP_ANL_SHIP_PLAN_40_TEMP
					(
					 DIVISION_ID  	     
					,PLAN_START_YYYYMMDD 
					,PLAN_TYPE	         
					,SEQ	             
					,ITEM_ID	         
					,FROM_SITE	         
					,TO_SITE	         
					,MEASURE	         
					,YYYYMMDD	         
					,BOD_ID	           
					,QTY	             
					,INCOTERMS         
					,TRANSPORT_MODE    
					,PROJECT_CODE	
					,FCST_TYPE
					,CONFIRM_ID						     
					,ORIGIN_FROM_DIVISION_ID
					,ORIGIN_TO_DIVISION_ID 	
					,ATTRIBUTE1
					,ATTRIBUTE4 
					,ATTRIBUTE5 
					)   
			SELECT  X.DIVISION_ID				AS DIVISION_ID
			,       @v_plan_start_yyyymmdd		AS PLAN_START_YYYYMMDD
			,       @v_plan_type				AS PLAN_TYPE
			,       @v_seq						AS SEQ
			-- jilee 230830			
			,       ISNULL(IM.APPLIED_MODEL, X.ITEM_iD) AS ITEM_ID			
			--,       X.ITEM_ID					AS ITEM_ID 
			,       X.FROM_SITE					AS FROM_SITE
			,       '-'							AS TO_SITE
			,       'PROD_PLAN'					AS MEASURE
			,       CONVERT(VARCHAR(8), X.YYYYMMDD ,112)  AS YYYYMMDD
			,       '-'							AS BOD_ID     
			,		ROUND(SUM(X.QTY) ,0 )       AS QTY 
			,		'-'							AS INCOTERMS
			,		'-'							AS TRANSPORT_MODE
			,		'-'							AS PROJECT_CODE
			,		'-'							AS FCST_TYPE
			,		'-'							AS CONFIRM_ID
			,       X.DIVISION_ID				AS ORIGIN_FROM_DIVISION_ID
			,       X.DIVISION_ID				AS ORIGIN_TO_DIVISION_ID
			,       CONVERT(VARCHAR(8), MAX(X.PRD_YYYYMMDD), 112)  AS ATTRIBUTE1 
			,       ROUND(SUM(CASE WHEN ISNULL(X.PRODUCTION_TYPE,'MASS') ='MASS' THEN X.QTY ELSE 0 END), 0)  AS ATTRIBUTE4 --Prod Qty(MASS)
			,		ROUND(SUM(X.QTY) ,0 )       AS ATTRIBUTE5  -- Prod Qty(ALL)
			FROM  ( 
			       ---------------------------------------------------------------------------------------------------------------
				   -- 실적 
				   -- MES-LOT별실적(RESULT_MES_LOT) : A3000	
			       ---------------------------------------------------------------------------------------------------------------
					SELECT R.DIVISION_ID
					     , R.FROM_SITE
					     , R.ITEM_iD
					     , R.TYPE
					     , R.YYYYMMDD
					     , R.PRD_YYYYMMDD
					     , R.QTY
					     , R.OPERATION_ID
					     , R.PRODUCTION_TYPE
					FROM   (
							SELECT R.DIVISION_ID							AS DIVISION_ID 
							,      R.SCM_SITE_ID							AS FROM_SITE
							,      R.ITEM_ID								AS ITEM_iD
							,      'MES_LOT_RESULT'                         AS TYPE      
							--,      CONVERT(VARCHAR(8), R.PLAN_DATE + (ISNULL(F.LT_FORMATION,0) + ISNULL(F.ATTRIBUTE1,0)) , 112) AS YYYYMMDD 
							,      CASE WHEN ISNULL(X.SEGMENT2, '') = '' THEN CONVERT(VARCHAR(8), R.PLAN_DATE + (ISNULL(F.LT_FORMATION,0) + ISNULL(F.ATTRIBUTE1,0)) , 112)
								   ELSE CONVERT(VARCHAR(8), R.PLAN_DATE + CONVERT(INT, X.SEGMENT2), 112) END  AS YYYYMMDD 
							,      R.PLAN_DATE                              AS PRD_YYYYMMDD
							,      R.QTY * ISNULL(F.SSP_MODIFY_YIELD ,1)    AS QTY 
							,      R.OPERATION_ID                           AS OPERATION_ID
							,      R.PRODUCTION_TYPE                        AS PRODUCTION_TYPE
							FROM   #tmp_SSP_MES_WIP_HISTORY R WITH(NOLOCK) 
									LEFT OUTER JOIN SSP_ANL_FORMATION_C F WITH(NOLOCK) 
													ON F.DIVISION_ID      = R.DIVISION_ID 
												AND F.PLANT_SITE_ID       = R.SCM_SITE_ID 
												AND F.ITEM_ID             = R.ITEM_ID 
												AND F.DIVISION_ID         = @v_division_id
												AND F.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
												AND F.PLAN_TYPE           = @v_plan_type
												AND F.SEQ                 = @v_seq
									LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL  X WITH(NOLOCK)
									ON     X.LOOKUP_TYPE = 'POUCH_WH_IN_DAY'
									AND    X.VALID_YN    = 'Y' 
									AND    X.SEGMENT1    =  SUBSTRING(R.ITEM_ID, 1, 3)
									AND    X.SEGMENT3    = '-'
									AND    X.SEGMENT4    = '-'
									AND    X.SEGMENT5    = '-'
							WHERE 1=1 
							AND   R.DIVISION_ID = @v_division_id
							AND   R.OPERATION_ID = 'A3000'
							AND   R.PLAN_DATE < CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 112))
							--AND    CONVERT(VARCHAR(8), R.PLAN_DATE + (ISNULL(F.LT_FORMATION,0) + ISNULL(F.ATTRIBUTE1,0)) , 112)  >=  @v_data_start_yyyymmdd 
							--AND    CONVERT(VARCHAR(8), R.PLAN_DATE + (ISNULL(F.LT_FORMATION,0) + ISNULL(F.ATTRIBUTE1,0)) , 112)  <   @v_data_end_yyyymmdd 
						   ) R
					WHERE  R.YYYYMMDD  >=  @v_data_start_yyyymmdd 
					AND    R.YYYYMMDD  <   @v_data_end_yyyymmdd 

					--     CNJ Pouch 특성실적과 중복되는건 제외(2019.05.17) 
					AND    NOT EXISTS ( SELECT 1
										FROM    [SCM_DNM_PRODUCT_RESULT_V] A WITH(NOLOCK)   
										WHERE  A.DIVISION_ID = @v_division_id
										AND    A.SCM_SITE_ID IS NOT NULL 
										--AND    CONVERT(VARCHAR(8), A.PLAN_DATE, 112) >= CONVERT(char(8), DATEADD(DD, -2, GETDATE()), 112) 
										--AND    CONVERT(VARCHAR(8), A.PLAN_DATE, 112) <  @v_data_start_yyyymmdd 
										AND    A.PLAN_DATE >= CONVERT(date, DATEADD(DD, -2, GETDATE()))
										AND    A.PLAN_DATE  < CONVERT(date, @v_data_start_yyyymmdd, 112)
										AND    A.OPERATION_ID IN  ('F5400','F5500','F5600') 
										AND    A.QTY > 0 
										AND    A.DIVISION_ID = R.DIVISION_ID
										AND    A.ITEM_ID     = R.ITEM_ID 
										AND    A.SCM_SITE_ID = R.FROM_SITE
										)
					--     CNJ Pouch 특성계획과 중복되는건 제외(2019.05.28) 
					AND    NOT EXISTS ( SELECT 1
										FROM   SSP_DNM_PLAN_FROZEN_V A WITH(NOLOCK)   
										WHERE  A.DIVISION_ID = @v_division_id
										AND    A.SCM_SITE_ID IS NOT NULL 
										AND    A.OPERATION_ID IN  ('F5400','F5500','F5600') 
										AND    A.PLAN_QTY > 0 
										--AND    CONVERT(VARCHAR(8),A.PLAN_DATE,112) >=  @v_data_start_yyyymmdd 
										--AND    CONVERT(VARCHAR(8),A.PLAN_DATE,112) <   @v_data_end_yyyymmdd
										AND    A.PLAN_DATE >= CONVERT(date, @v_data_start_yyyymmdd, 112)
										AND    A.PLAN_DATE  < CONVERT(date, @v_data_end_yyyymmdd, 112)
										AND    A.DIVISION_ID = R.DIVISION_ID
										AND    A.ITEM_ID     = R.ITEM_ID 
										AND    A.SCM_SITE_ID = R.FROM_SITE
										)

					UNION ALL 
			       ---------------------------------------------------------------------------------------------------------------
				   -- 실적 
				   -- 조립실적(RESULT_FP_ASSY) : A9000	F6200 F7000	F7100 F7200	F7300
				   -- 모듈실적 : P5000
				   ---------------------------------------------------------------------------------------------------------------
					SELECT R.DIVISION_ID
					     , R.FROM_SITE
					     , R.ITEM_iD
					     , R.TYPE
					     , R.YYYYMMDD
					     , R.PRD_YYYYMMDD
					     , R.QTY
					     , R.OPERATION_ID
					     , R.PRODUCTION_TYPE
				   FROM   (
							SELECT R.DIVISION_ID                              AS DIVISION_ID 
							,      R.SCM_SITE_ID                              AS FROM_SITE 
							,      R.ITEM_ID                                  AS ITEM_ID 
							,      'RESULT_FP_ASSY'                           AS TYPE
							--,      CONVERT(VARCHAR(8), R.PLAN_DATE + (ISNULL(F.LT_FORMATION,0) + ISNULL(F.ATTRIBUTE1,0)) , 112) AS YYYYMMDD 
							,      CASE WHEN ISNULL(X.SEGMENT2, '') = '' THEN CONVERT(VARCHAR(8), R.PLAN_DATE + (ISNULL(F.LT_FORMATION,0) + ISNULL(F.ATTRIBUTE1,0)) , 112)
								   ELSE CONVERT(VARCHAR(8), R.PLAN_DATE + CONVERT(INT, X.SEGMENT2), 112) END  AS YYYYMMDD 
							,      R.PLAN_DATE                                AS PRD_YYYYMMDD
 							,      R.QTY * ISNULL(F.SSP_MODIFY_YIELD ,1)      AS QTY 
							,      R.OPERATION_ID                             AS OPERATION_ID
							,      R.PRODUCTION_TYPE                          AS PRODUCTION_TYPE 
							FROM   [SCM_DNM_PRODUCT_RESULT_V] R WITH(NOLOCK)   
									LEFT OUTER JOIN SSP_ANL_FORMATION_C F WITH(NOLOCK) 
												 ON F.DIVISION_ID         = R.DIVISION_ID 
												AND F.PLANT_SITE_ID       = R.SCM_SITE_ID 
												AND F.ITEM_ID             = R.ITEM_ID 
												AND F.DIVISION_ID         = @v_division_id
												AND F.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
												AND F.PLAN_TYPE           = @v_plan_type
												AND F.SEQ                 = @v_seq
									LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL  X WITH(NOLOCK)
									ON     X.LOOKUP_TYPE = 'POUCH_WH_IN_DAY'
									AND    X.VALID_YN    = 'Y' 
									AND    X.SEGMENT1    =  SUBSTRING(R.ITEM_ID, 1, 3)
									AND    X.SEGMENT3    = '-'
									AND    X.SEGMENT4    = '-'
									AND    X.SEGMENT5    = '-'
							WHERE  R.DIVISION_ID = @v_division_id
							AND    R.SCM_SITE_ID IS NOT NULL 
							--AND    CONVERT(VARCHAR(8), R.PLAN_DATE, 112) >= '20180101'  --   <-- 기준 정의 필요
							AND    R.PLAN_DATE >= CONVERT(date, DATEADD(DD, -150, GETDATE()))
							--AND    CONVERT(VARCHAR(8), R.PLAN_DATE + (ISNULL(F.LT_FORMATION,0) + ISNULL(F.ATTRIBUTE1,0)) , 112)  >=  @v_data_start_yyyymmdd
							--AND    CONVERT(VARCHAR(8), R.PLAN_DATE + (ISNULL(F.LT_FORMATION,0) + ISNULL(F.ATTRIBUTE1,0)) , 112)  <   @v_data_end_yyyymmdd 
							AND    R.OPERATION_ID IN  ('A9000','F7000','F7100','F7200','F7300' ,'F6200', 'P5000') 
							AND    R.QTY > 0 
						   ) R
					WHERE  R.YYYYMMDD  >=  @v_data_start_yyyymmdd 
					AND    R.YYYYMMDD  <   @v_data_end_yyyymmdd 
					--     CNJ Pouch 특성실적과 중복되는건 제외(2019.05.17) 
					AND    NOT EXISTS ( SELECT 1
					                    FROM   [SCM_DNM_PRODUCT_RESULT_V] A WITH(NOLOCK)   
										WHERE  A.DIVISION_ID = @v_division_id
										AND    A.SCM_SITE_ID IS NOT NULL 
										--AND    CONVERT(VARCHAR(8), A.PLAN_DATE, 112) >= CONVERT(char(8), DATEADD(DD, -2, GETDATE()), 112) 
										--AND    CONVERT(VARCHAR(8), A.PLAN_DATE, 112) <  @v_data_start_yyyymmdd
										AND    A.PLAN_DATE >= CONVERT(date, DATEADD(DD, -2, GETDATE()))
										AND    A.PLAN_DATE  < CONVERT(date, @v_data_start_yyyymmdd, 112)
										AND    A.OPERATION_ID IN  ('F5400','F5500','F5600') 
										AND    A.QTY > 0 
					                    AND    A.DIVISION_ID = R.DIVISION_ID
										AND    A.ITEM_ID     = R.ITEM_ID 
										AND    A.SCM_SITE_ID = R.FROM_SITE
                                        )
					--     CNJ Pouch 특성계획과 중복되는건 제외(2019.05.28) 
				    AND    NOT EXISTS ( SELECT 1
										FROM   [SSP_DNM_PLAN_FROZEN_V] A WITH(NOLOCK)   
										WHERE  A.DIVISION_ID = @v_division_id
										AND    A.SCM_SITE_ID IS NOT NULL 
										AND    A.OPERATION_ID IN  ('F5400','F5500','F5600') 
										AND    A.PLAN_QTY > 0 
										--AND    CONVERT(VARCHAR(8),A.PLAN_DATE,112) >=  @v_data_start_yyyymmdd
										--AND    CONVERT(VARCHAR(8),A.PLAN_DATE,112) <   @v_data_end_yyyymmdd 					    
										AND    A.PLAN_DATE >= CONVERT(date, @v_data_start_yyyymmdd, 112)
										AND    A.PLAN_DATE  < CONVERT(date, @v_data_end_yyyymmdd, 112)
					                    AND    A.DIVISION_ID = R.DIVISION_ID
										AND    A.ITEM_ID     = R.ITEM_ID 
										AND    A.SCM_SITE_ID = R.FROM_SITE
                                      )
                    --     A3000 MES실적 중복되는건 제외(2019.09.17) 
					AND    NOT EXISTS ( SELECT 1
										FROM    #tmp_SSP_MES_WIP_HISTORY A WITH(NOLOCK)   
										WHERE  A.DIVISION_ID = @v_division_id
										AND    A.SCM_SITE_ID IS NOT NULL 
										--AND    CONVERT(VARCHAR(8), A.PLAN_DATE, 112) >= CONVERT(char(8), DATEADD(DD, -2, GETDATE()), 112) 
										--AND    CONVERT(VARCHAR(8), A.PLAN_DATE, 112) <  @v_data_start_yyyymmdd 
										AND    A.PLAN_DATE >= CONVERT(date, DATEADD(DD, -2, GETDATE()))
										AND    A.PLAN_DATE  < CONVERT(date, @v_data_start_yyyymmdd, 112)
										AND    A.OPERATION_ID ='A3000'
										AND    A.QTY > 0 
										AND    A.DIVISION_ID = R.DIVISION_ID
										AND    A.ITEM_ID     = R.ITEM_ID 
										AND    A.SCM_SITE_ID = R.FROM_SITE
										)

					UNION ALL 
			       ---------------------------------------------------------------------------------------------------------------
				   -- 실적 
				   -- 특성실적(RESULT_FP_POUCH) : F5400 F5500 F5600
				   ---------------------------------------------------------------------------------------------------------------
					SELECT R.DIVISION_ID                              AS DIVISION_ID 
					,      R.SCM_SITE_ID                              AS FROM_SITE 
					,      R.ITEM_ID                                  AS ITEM_ID 
					,      'RESULT_FP_POUCH'                          AS TYPE
					,      CONVERT(VARCHAR(8), R.PLAN_DATE + 2,112)   AS YYYYMMDD 
					,      R.PLAN_DATE                                AS PRD_YYYYMMDD
 					,      R.QTY                                      AS QTY 
					,      R.OPERATION_ID							  AS OPERATION_ID
					,      R.PRODUCTION_TYPE                          AS PRODUCTION_TYPE 
					FROM   [SCM_DNM_PRODUCT_RESULT_V] R WITH(NOLOCK)   
					WHERE  R.DIVISION_ID = @v_division_id
					AND    R.SCM_SITE_ID IS NOT NULL 
					--AND    CONVERT(VARCHAR(8), R.PLAN_DATE, 112) >= CONVERT(char(8), DATEADD(DD, -2, GETDATE()), 112) 
					--AND    CONVERT(VARCHAR(8), R.PLAN_DATE, 112) <  @v_data_start_yyyymmdd 
					AND    R.PLAN_DATE >= CONVERT(date, DATEADD(DD, -2, GETDATE()))
					AND    R.PLAN_DATE  < CONVERT(date, @v_data_start_yyyymmdd, 112)
					AND    R.OPERATION_ID IN  ('F5400','F5500','F5600') 
					AND    R.QTY > 0 

					UNION ALL 
			       ---------------------------------------------------------------------------------------------------------------
				   -- 계획  
				   -- 조립계획(PLAN_FP_ASSY)	: A3000	A9000 F6200	F7000 F7100	F7200 F7300
				   -- 모듈계획 : P5500
				   ---------------------------------------------------------------------------------------------------------------
					SELECT R.DIVISION_ID
					     , R.FROM_SITE
					     , R.ITEM_iD
					     , R.TYPE
					     , R.YYYYMMDD
					     , R.PRD_YYYYMMDD
					     , R.QTY
					     , R.OPERATION_ID
					     , R.PRODUCTION_TYPE
				   FROM   (
							SELECT P.DIVISION_ID                              AS DIVISION_ID 
							,      P.SCM_SITE_ID                              AS FROM_SITE 
							,      P.ITEM_ID                                  AS ITEM_ID 
							,      'PLAN_FP_ASSY'                             AS TYPE
							--,      CONVERT(VARCHAR(8), P.PLAN_DATE + (ISNULL(F.LT_FORMATION,0) + ISNULL(F.ATTRIBUTE1,0)) , 112) AS YYYYMMDD 
							,      CASE WHEN ISNULL(X.SEGMENT2, '') = '' THEN CONVERT(VARCHAR(8), P.PLAN_DATE + (ISNULL(F.LT_FORMATION,0) + ISNULL(F.ATTRIBUTE1,0)) , 112)
								   ELSE CONVERT(VARCHAR(8), P.PLAN_DATE + CONVERT(INT, X.SEGMENT2), 112) END  AS YYYYMMDD 
							,      P.PLAN_DATE                          	  AS PRD_YYYYMMDD 
 							,      P.PLAN_QTY * ISNULL(F.SSP_MODIFY_YIELD ,1) AS QTY 
							,      P.OPERATION_ID                             AS OPERATION_ID
							,      P.FP_PRODUCTION_TYPE                       AS PRODUCTION_TYPE
							FROM   [SSP_DNM_PLAN_FROZEN_V] P WITH(NOLOCK)   
									LEFT OUTER JOIN SSP_ANL_FORMATION_C F WITH(NOLOCK) 
													ON F.DIVISION_ID         = P.DIVISION_ID 
												AND F.PLANT_SITE_ID       = P.SCM_SITE_ID 
												AND F.ITEM_ID             = P.ITEM_ID 
												AND F.DIVISION_ID         = @v_division_id
												AND F.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
												AND F.PLAN_TYPE           = @v_plan_type
												AND F.SEQ                 = @v_seq
									LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL  X WITH(NOLOCK)
									ON     X.LOOKUP_TYPE = 'POUCH_WH_IN_DAY'
									AND    X.VALID_YN    = 'Y' 
									AND    X.SEGMENT1    =  SUBSTRING(P.ITEM_ID, 1, 3)
									AND    X.SEGMENT3    = '-'
									AND    X.SEGMENT4    = '-'
									AND    X.SEGMENT5    = '-'
							WHERE  P.DIVISION_ID = @v_division_id
							AND    P.SCM_SITE_ID IS NOT NULL 
							--AND    CONVERT(VARCHAR(8), P.PLAN_DATE + (ISNULL(F.LT_FORMATION,0) + ISNULL(F.ATTRIBUTE1,0)) , 112)  >=  @v_data_start_yyyymmdd 
							--AND    CONVERT(VARCHAR(8), P.PLAN_DATE + (ISNULL(F.LT_FORMATION,0) + ISNULL(F.ATTRIBUTE1,0)) , 112)  <   @v_data_end_yyyymmdd 
							AND    P.OPERATION_ID IN  ('A3000', 'A9000' ,'F7000','F7100','F7200','F7300','F6200', 'P5500') 
							AND    P.PLAN_QTY > 0 
							--AND    CONVERT(VARCHAR(8),P.PLAN_DATE,112) >=  @v_data_start_yyyymmdd
							AND    P.PLAN_DATE >= CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 112))
						   ) R
					WHERE  R.YYYYMMDD  >=  @v_data_start_yyyymmdd 
					AND    R.YYYYMMDD  <   @v_data_end_yyyymmdd 
					--     CNJ Pouch 특성실적과 중복되는건 제외(2019.05.17) 
					AND    NOT EXISTS ( SELECT 1
										FROM   [SCM_DNM_PRODUCT_RESULT_V]  A WITH(NOLOCK)   
										WHERE  A.DIVISION_ID = @v_division_id
										--AND    A.SCM_SITE_ID IS NOT NULL 
										--AND    CONVERT(VARCHAR(8), A.PLAN_DATE, 112) >= CONVERT(char(8), DATEADD(DD, -2, GETDATE()), 112) 
										--AND    CONVERT(VARCHAR(8), A.PLAN_DATE, 112) <  @v_data_start_yyyymmdd 
										AND    A.PLAN_DATE >= CONVERT(date, DATEADD(DD, -2, GETDATE()))
										AND    A.PLAN_DATE  < CONVERT(date, @v_data_start_yyyymmdd, 112)
										AND    A.OPERATION_ID IN  ('F5400','F5500','F5600') 
										AND    A.QTY > 0 
										AND    A.DIVISION_ID = R.DIVISION_ID
										AND    A.ITEM_ID     = R.ITEM_ID 
										AND    A.SCM_SITE_ID = R.FROM_SITE
										)
					--     CNJ Pouch 특성계획과 중복되는건 제외(2019.05.28) 
					AND    NOT EXISTS ( SELECT 1
										FROM   [SSP_DNM_PLAN_FROZEN_V] A WITH(NOLOCK)   
										WHERE  A.DIVISION_ID = @v_division_id
										AND    A.SCM_SITE_ID IS NOT NULL 
										AND    A.OPERATION_ID IN  ('F5400','F5500','F5600') 
										AND    A.PLAN_QTY > 0 
										--AND    CONVERT(VARCHAR(8),A.PLAN_DATE,112) >=  @v_data_start_yyyymmdd 
										--AND    CONVERT(VARCHAR(8),A.PLAN_DATE,112) <   @v_data_end_yyyymmdd 					    
										AND    A.PLAN_DATE >= CONVERT(date, @v_data_start_yyyymmdd, 112)
										AND    A.PLAN_DATE  < CONVERT(date, @v_data_end_yyyymmdd, 112)
										AND    A.DIVISION_ID = R.DIVISION_ID
										AND    A.ITEM_ID     = R.ITEM_ID 
										AND    A.SCM_SITE_ID = R.FROM_SITE
										)

					UNION ALL 
			       ---------------------------------------------------------------------------------------------------------------
				   -- 계획  
				   -- 특성계획(PLAN_FP_POUCH): F5400 F5500 F5600	
				   ---------------------------------------------------------------------------------------------------------------
					SELECT P.DIVISION_ID                              AS DIVISION_ID 
					,      P.SCM_SITE_ID                              AS FROM_SITE 
					,      P.ITEM_ID                                  AS ITEM_ID 
					,      'PLAN_FP_POUCH'                            AS TYPE
					,      CONVERT(VARCHAR(8), P.PLAN_DATE + 2,112)   AS YYYYMMDD 
					,      P.PLAN_DATE                          	  AS PRD_YYYYMMDD 
 					,      P.PLAN_QTY * ISNULL(F.SSP_MODIFY_YIELD ,1) AS QTY 
					,      P.OPERATION_ID                             AS OPERATION_ID
					,      P.FP_PRODUCTION_TYPE                       AS PRODUCTION_TYPE
					FROM   [SSP_DNM_PLAN_FROZEN_V] P WITH(NOLOCK)  
							LEFT OUTER JOIN SSP_ANL_FORMATION_C F WITH(NOLOCK) 
											ON F.DIVISION_ID         = P.DIVISION_ID 
										AND F.PLANT_SITE_ID       = P.SCM_SITE_ID 
										AND F.ITEM_ID             = P.ITEM_ID 
										AND F.DIVISION_ID         = @v_division_id
										AND F.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
										AND F.PLAN_TYPE           = @v_plan_type
										AND F.SEQ                 = @v_seq					 
					WHERE  P.DIVISION_ID = @v_division_id
					AND    P.SCM_SITE_ID IS NOT NULL 
					AND    P.OPERATION_ID IN  ('F5400','F5500','F5600') 
					AND    P.PLAN_QTY > 0 
					--AND    CONVERT(VARCHAR(8),P.PLAN_DATE,112) >=  @v_data_start_yyyymmdd 
					--AND    CONVERT(VARCHAR(8),P.PLAN_DATE,112) <   @v_data_end_yyyymmdd 
					AND    P.PLAN_DATE >= CONVERT(date, @v_data_start_yyyymmdd, 112)
					AND    P.PLAN_DATE  < CONVERT(date, @v_data_end_yyyymmdd, 112)

					UNION ALL 
			       ---------------------------------------------------------------------------------------------------------------
				   -- 계획  
				   -- 외주생산계획 (PLAN_SSP_OSP): SSP0018(Production Plan(OSP)) 화면에서 입력한 계획 (SSP_ANL_PROD_PLAN_OSP)
				   ---------------------------------------------------------------------------------------------------------------
					-- 남경('G182-A') 외주 생산계획 추가 
					SELECT R.DIVISION_ID
					     , R.FROM_SITE
					     , R.ITEM_iD
					     , R.TYPE
					     , R.YYYYMMDD
					     , R.PRD_YYYYMMDD
					     , R.QTY
					     , R.OPERATION_ID
					     , R.PRODUCTION_TYPE
				   FROM   (
							SELECT P.DIVISION_ID                              AS DIVISION_ID 
							,      'G182-A'                                   AS FROM_SITE 
							,      P.ITEM_ID                                  AS ITEM_ID 
							,      'PLAN_SSP_OSP'                                     AS TYPE
							--,      CONVERT(VARCHAR(8), P.YYYYMMDD + (ISNULL(F.LT_FORMATION,0) + ISNULL(F.ATTRIBUTE1,0)) , 112) AS YYYYMMDD 
							,      CASE WHEN ISNULL(X.SEGMENT2, '') = '' THEN CONVERT(VARCHAR(8), P.YYYYMMDD + (ISNULL(F.LT_FORMATION,0) + ISNULL(F.ATTRIBUTE1,0)) , 112)
								   ELSE CONVERT(VARCHAR(8), P.YYYYMMDD + CONVERT(INT, X.SEGMENT2), 112) END  AS YYYYMMDD 
							,      P.YYYYMMDD                           	  AS PRD_YYYYMMDD 
 							,      P.QTY * ISNULL(F.SSP_MODIFY_YIELD ,1)  AS QTY 
							,      NULL                                       AS OPERATION_ID
							,      NULL                                       AS PRODUCTION_TYPE 
							FROM   [SSP_ANL_PROD_PLAN_OSP] P WITH(NOLOCK)   
									LEFT OUTER JOIN SSP_ANL_FORMATION_C F WITH(NOLOCK) 
													ON F.DIVISION_ID         = P.DIVISION_ID 
												AND F.PLANT_SITE_ID       = 'G182-A'--P.SCM_SITE_ID (SSP_ANL_PROD_PLAN_OSP에는 PACKRE이므로 G182-A로 조인)
												AND F.ITEM_ID             = P.ITEM_ID 
												AND F.DIVISION_ID         = @v_division_id
												AND F.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
												AND F.PLAN_TYPE           = @v_plan_type
												AND F.SEQ                 =	@v_seq
									LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL  X WITH(NOLOCK)
									ON     X.LOOKUP_TYPE = 'POUCH_WH_IN_DAY'
									AND    X.VALID_YN    = 'Y' 
									AND    X.SEGMENT1    =  SUBSTRING(P.ITEM_ID, 1, 3)
									AND    X.SEGMENT3    = '-'
									AND    X.SEGMENT4    = '-'
									AND    X.SEGMENT5    = '-'
							WHERE  P.DIVISION_ID = @v_division_id
							AND    P.SCM_SITE_ID IS NOT NULL 
							--AND    CONVERT(VARCHAR(8), P.YYYYMMDD + (ISNULL(F.LT_FORMATION,0) + ISNULL(F.ATTRIBUTE1,0)) , 112)  >=  @v_data_start_yyyymmdd 
							--AND    CONVERT(VARCHAR(8), P.YYYYMMDD + (ISNULL(F.LT_FORMATION,0) + ISNULL(F.ATTRIBUTE1,0)) , 112)  <   @v_data_end_yyyymmdd 
							AND    P.QTY > 0 
							AND    P.YYYYMMDD  >=  @v_data_start_yyyymmdd 
						   ) R
					WHERE  R.YYYYMMDD  >=  @v_data_start_yyyymmdd 
					AND    R.YYYYMMDD  <   @v_data_end_yyyymmdd 

					UNION ALL  
			       ---------------------------------------------------------------------------------------------------------------
				   -- 계획  
				   -- 생산계획없는 모델 추가 ( MY MODEL에 담당자 지정된 모델은 강제로 생성) 
				   ---------------------------------------------------------------------------------------------------------------
					SELECT M.DIVISION_ID                            AS DIVISION_ID 
					,      M.FROM_SITE                              AS FROM_SITE 
					,      M.ITEM_ID                                AS ITEM_ID 
					,      'PLAN_SSP_MYMODEL'                       AS TYPE
					,      @v_data_start_yyyymmdd                   AS YYYYMMDD 
					,      NULL                                	    AS PRD_YYYYMMDD 
 					,      0                                        AS QTY 
					,      NULL                                     AS OPERATION_ID
					,      NULL                                     AS PRODUCTION_TYPE 
					FROM   [SSP_MST_MODEL_USER] M WITH(NOLOCK) 
					WHERE  M.DIVISION_ID =  @v_division_id
					AND    M.VALID_YN = 'Y'

					) X
					JOIN SCM_MST_SITE E WITH(NOLOCK)
					ON    E.DIVISION_ID = @v_division_id
					AND   ISNULL(E.COMPANY_ID, '')  = @v_company_id
					AND   E.DIVISION_ID = X.DIVISION_ID
					AND   E.SCM_SITE_ID = X.FROM_SITE
					-- jilee 230830
					LEFT OUTER JOIN [LGCE_FPDEV_TR].[DBO].[SCM_ITEM_M] IM WITH(NOLOCK) 
					ON   IM.DIVISION_ID = X.DIVISION_ID							   
					AND  IM.COMPANY_ID = @v_company_id
					AND  IM.SITE_ID = E.SITE_ID
					AND  IM.ITEM_ID = X.ITEM_ID
					AND  IM.ITEM_CLASS IN ('ES1901', 'ES2001','ES2002', 'ES2003', 'ES2004')		
			WHERE  1=1 
			GROUP BY 
					X.DIVISION_ID 
			,      X.FROM_SITE			
			-- jilee 230830
			,      IM.APPLIED_MODEL
			,      X.ITEM_ID 
			,      X.YYYYMMDD
			OPTION (RECOMPILE)
			;

			-- jilee 230830 'PROD_PLAN' 중복 발생한 TEMP 테이블 Merge
			INSERT INTO #tmp_SSP_ANL_SHIP_PLAN_40
					(
					 DIVISION_ID  	     
					,PLAN_START_YYYYMMDD 
					,PLAN_TYPE	         
					,SEQ	             
					,ITEM_ID	         
					,FROM_SITE	         
					,TO_SITE	         
					,MEASURE	         
					,YYYYMMDD	         
					,BOD_ID	           
					,QTY	             
					,INCOTERMS         
					,TRANSPORT_MODE    
					,PROJECT_CODE	
					,FCST_TYPE
					,CONFIRM_ID						     
					,ORIGIN_FROM_DIVISION_ID
					,ORIGIN_TO_DIVISION_ID 	
					,ATTRIBUTE1
					,ATTRIBUTE4 
					,ATTRIBUTE5 
					)   
			select   T.DIVISION_ID  	     
					,@v_plan_start_yyyymmdd		AS PLAN_START_YYYYMMDD
					,@v_plan_type				AS PLAN_TYPE
					,@v_seq						AS SEQ
					,T.ITEM_ID	         
					,T.FROM_SITE	         
					,'-'						AS TO_SITE
					,'PROD_PLAN'				AS MEASURE
					,T.YYYYMMDD	         
					,'-'						AS BOD_ID  
					,ROUND(SUM(T.QTY),0)	             
					,'-'						AS INCOTERMS
					,'-'						AS TRANSPORT_MODE
					,'-'						AS PROJECT_CODE
					,'-'						AS FCST_TYPE
					,'-'						AS CONFIRM_ID					     
					,T.ORIGIN_FROM_DIVISION_ID 
					,T.ORIGIN_TO_DIVISION_ID 				
			        ,MAX(T.ATTRIBUTE1)          AS ATTRIBUTE1
					,CONVERT(nvarchar(150),SUM(CONVERT(DECIMAL(20,6), T.ATTRIBUTE4))) AS ATTRIBUTE4
					,CONVERT(nvarchar(150),SUM(CONVERT(DECIMAL(20,6), T.ATTRIBUTE5))) AS ATTRIBUTE5
					FROM #tmp_SSP_ANL_SHIP_PLAN_40_TEMP T WITH (NOLOCK) 
						GROUP BY T.DIVISION_ID  	     
						,T.FROM_SITE	                      
						,T.ITEM_ID	         
						,T.YYYYMMDD	    
						,T.ORIGIN_FROM_DIVISION_ID
						,T.ORIGIN_TO_DIVISION_ID 	
			
			------------------------------------------------------------------------------------------------------------- 
			--2-5. [P]INCO_WIP(Incomming WIP)       : aging 재고 기준  
			--    AGING 재고 + 조립계획 
			-------------------------------------------------------------------------------------------------------------  
			INSERT INTO #tmp_SSP_ANL_SHIP_PLAN_40
					(
					 DIVISION_ID  	     
					,PLAN_START_YYYYMMDD 
					,PLAN_TYPE	         
					,SEQ	             
					,ITEM_ID	         
					,FROM_SITE	         
					,TO_SITE	         
					,MEASURE	         
					,YYYYMMDD	         
					,BOD_ID	           
					,QTY	             
					,INCOTERMS         
					,TRANSPORT_MODE    
					,PROJECT_CODE	
					,FCST_TYPE
					,CONFIRM_ID						     
					,ORIGIN_FROM_DIVISION_ID
					,ORIGIN_TO_DIVISION_ID 	
					,ATTRIBUTE1
					)   
			SELECT  X.DIVISION_ID				AS DIVISION_ID 
			,       @v_plan_start_yyyymmdd		AS PLAN_START_YYYYMMDD
			,       @v_plan_type				AS PLAN_TYPE
			,       @v_seq						AS SEQ
			-- jilee 230830			
			,       ISNULL(IM.APPLIED_MODEL, X.ITEM_iD) AS ITEM_ID			
			--,       X.ITEM_ID					AS ITEM_ID
			,       X.FROM_SITE					AS FROM_SITE 
			,       '-'							AS TO_SITE
			,       'INCO_WIP'					AS MEASURE
			,       CONVERT(VARCHAR(8), X.YYYYMMDD, 112) AS YYYYMMDD
			,       '-'							AS BOD_ID     
			,       SUM(ROUND(X.QTY,0))			AS QTY

			,		'-'							AS INCOTERMS
			,		'-'							AS TRANSPORT_MODE
			,		'-'							AS PROJECT_CODE
			,		'-'							AS FCST_TYPE
			,		'-'							AS CONFIRM_ID
			,       X.DIVISION_ID				AS ORIGIN_FROM_DIVISION_ID
			,       X.DIVISION_ID				AS ORIGIN_TO_DIVISION_ID
			,       NULL                        AS ATTRIBUTE1
			FROM   (  
					SELECT A.DIVISION_ID               AS DIVISION_ID 
					,      A.SCM_SITE_ID               AS FROM_SITE 
					,      A.ITEM_ID                   AS ITEM_ID
 					,      CASE WHEN CONVERT(VARCHAR(8), A.AVAILABLE_DATE, 112) <= @v_plan_start_yyyymmdd 
										THEN @v_plan_start_yyyymmdd 
								ELSE CONVERT(VARCHAR(8), A.AVAILABLE_DATE, 112) END  AS YYYYMMDD 
					,      A.QTY  - CASE WHEN (A.WIPHOLD_YN ='Y' OR A.SPECIAL_YN = 'Y' ) THEN A.QTY ELSE 0 END   AS QTY 
					FROM   [SCM_DNM_STOCK_AGING_V] A WITH(NOLOCK) 
					,     ( -- 가장최근 CUTOFF 기준 
							SELECT C.DIVISION_ID, C.SITE_ID ,  MAX(C.CUTOFF_DATE) AS CUTOFF_DATE
							FROM   [SCM_DNM_STOCK_AGING_V] C WITH(NOLOCK) 
							WHERE  C.CUTOFF_DATE >  GETDATE() - 5
							AND    C.DIVISION_ID  = @v_division_id
							GROUP BY C.DIVISION_ID, C.SITE_ID 
						  ) B
					WHERE  1=1   
					AND    A.DIVISION_ID = B.DIVISION_ID
					AND    A.SITE_ID     = B.SITE_ID
					AND    A.CUTOFF_DATE = B.CUTOFF_DATE
					AND    A.DIVISION_ID = @v_division_id
					AND    A.SCM_SITE_ID IS NOT NULL 
					--AND    CONVERT(VARCHAR(8), A.AVAILABLE_DATE, 112) <= @v_data_end_yyyymmdd
					and    A.AVAILABLE_DATE <= CONVERT(date, @v_data_end_yyyymmdd, 112)
					AND    A.CUTOFF_DATE >  GETDATE() - 5


					UNION ALL 

					-- 조립계획 ('A3000', 'A9000' )
					SELECT P.DIVISION_ID                              AS DIVISION_ID 
					,      P.SCM_SITE_ID                              AS FROM_SITE 
					,      P.ITEM_ID                                  AS ITEM_ID 
					,       CASE WHEN CONVERT(VARCHAR(8), P.PLAN_DATE + (ISNULL(F.LT_FORMATION,0) + ISNULL(F.ATTRIBUTE1,0)), 112)  <= @v_plan_start_yyyymmdd  THEN @v_plan_start_yyyymmdd
             		 				ELSE CONVERT(VARCHAR(8), P.PLAN_DATE + (ISNULL(F.LT_FORMATION,0) + ISNULL(F.ATTRIBUTE1,0)), 112)  END  AS YYYYMMDD
					,      P.PLAN_QTY * ISNULL(F.SSP_MODIFY_YIELD ,1)   AS QTY 
					FROM   [SSP_DNM_PLAN_FROZEN_V] P WITH(NOLOCK)   
							LEFT OUTER JOIN SSP_ANL_FORMATION_C F WITH(NOLOCK)   
											ON F.DIVISION_ID   = P.DIVISION_ID 
										AND F.PLANT_SITE_ID = P.SCM_SITE_ID 
										AND F.ITEM_ID       = P.ITEM_ID 
										AND F.DIVISION_ID   = @v_division_id
										AND F.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
										AND F.PLAN_TYPE           = @v_plan_type
										AND F.SEQ                 = @v_seq
					WHERE  P.DIVISION_ID = @v_division_id
					AND    P.SCM_SITE_ID IS NOT NULL 
					AND    P.OPERATION_ID IN  ('A3000', 'A9000') -- INCO_WIP의 경우 F공정은 제외 (PROD_PLAN은 F공정포함됨)
					AND    CONVERT(VARCHAR(8), P.PLAN_DATE + (ISNULL(F.LT_FORMATION,0) + ISNULL(F.ATTRIBUTE1,0)) , 112)  > @v_data_start_yyyymmdd 
					AND    CONVERT(VARCHAR(8), P.PLAN_DATE + (ISNULL(F.LT_FORMATION,0) + ISNULL(F.ATTRIBUTE1,0)) , 112) <  @v_data_end_yyyymmdd
					AND    P.PLAN_QTY > 0 
					--AND    CONVERT(VARCHAR(8),P.PLAN_DATE,112) >=  @v_data_start_yyyymmdd 
					AND    P.PLAN_DATE >= CONVERT(date, @v_data_start_yyyymmdd, 112)
					--     CNJ Pouch 특성계획과 중복되는건 제외(2019.06.27) 
					AND    NOT EXISTS ( SELECT 1
										FROM   [SSP_DNM_PLAN_FROZEN_V] A WITH(NOLOCK)   
										WHERE  A.DIVISION_ID = @v_division_id
										AND    A.SCM_SITE_ID IS NOT NULL 
										AND    A.OPERATION_ID IN  ('F5400','F5500','F5600') 
										AND    A.PLAN_QTY > 0 
										--AND    CONVERT(VARCHAR(8),A.PLAN_DATE,112) >=  @v_data_start_yyyymmdd 
										--AND    CONVERT(VARCHAR(8),A.PLAN_DATE,112) >  @v_data_start_yyyymmdd 
										--AND    CONVERT(VARCHAR(8),A.PLAN_DATE,112) <   @v_data_end_yyyymmdd 					    
										AND    A.PLAN_DATE  > CONVERT(date, @v_data_start_yyyymmdd, 112)
										AND    A.PLAN_DATE  < CONVERT(date, @v_data_end_yyyymmdd, 112)
										AND    A.DIVISION_ID = P.DIVISION_ID
										AND    A.ITEM_ID     = P.ITEM_ID 
										AND    A.SCM_SITE_ID = P.SCM_SITE_ID
										) 

					UNION ALL 

					-- 조립계획(SSP_DNM_PLAN_FROZEN_V)  CNJ Pouch 특성계획 반영 (2019.06.27) 
					-- CNJ Pouch 특성계획  F5500 : Grading/Charateristic (Pouch)
					SELECT P.DIVISION_ID                              AS DIVISION_ID 
					,      P.SCM_SITE_ID                              AS FROM_SITE 
					,      P.ITEM_ID                                  AS ITEM_ID 
					,      CONVERT(VARCHAR(8), P.PLAN_DATE + 2,112)   AS YYYYMMDD 
					,      P.PLAN_QTY * ISNULL(F.SSP_MODIFY_YIELD ,1)   AS QTY 
					FROM   [SSP_DNM_PLAN_FROZEN_V] P WITH(NOLOCK)   
							LEFT OUTER JOIN SSP_ANL_FORMATION_C F WITH(NOLOCK)   
											ON F.DIVISION_ID   = P.DIVISION_ID 
										AND F.PLANT_SITE_ID = P.SCM_SITE_ID 
										AND F.ITEM_ID       = P.ITEM_ID 
										AND F.DIVISION_ID   = @v_division_id
										AND F.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
										AND F.PLAN_TYPE           = @v_plan_type
										AND F.SEQ                 = @v_seq
					WHERE  P.DIVISION_ID = @v_division_id
					AND    P.SCM_SITE_ID IS NOT NULL 
					AND    P.OPERATION_ID IN  ('F5400','F5500','F5600') 
					--AND    CONVERT(VARCHAR(8),P.PLAN_DATE,112) >=  @v_data_start_yyyymmdd 
					--AND    CONVERT(VARCHAR(8),P.PLAN_DATE,112) >  @v_data_start_yyyymmdd 
					--AND    CONVERT(VARCHAR(8),P.PLAN_DATE,112) <   @v_data_end_yyyymmdd 
					AND    P.PLAN_DATE  > CONVERT(date, @v_data_start_yyyymmdd, 112)
					AND    P.PLAN_DATE  < CONVERT(date, @v_data_end_yyyymmdd, 112)
					AND    P.PLAN_QTY > 0 
				   ) X
					JOIN SCM_MST_SITE E WITH(NOLOCK)
					ON    E.DIVISION_ID = @v_division_id
					AND   ISNULL(E.COMPANY_ID, '')  = @v_company_id
					AND   E.DIVISION_ID = X.DIVISION_ID
					AND   E.SCM_SITE_ID = X.FROM_SITE
					-- jilee 230830
					LEFT OUTER JOIN [LGCE_FPDEV_TR].[DBO].[SCM_ITEM_M] IM WITH(NOLOCK) 
					ON   IM.DIVISION_ID = X.DIVISION_ID							   
					AND  IM.COMPANY_ID = @v_company_id
					AND  IM.SITE_ID = E.SITE_ID
					AND  IM.ITEM_ID = X.ITEM_ID
					AND  IM.ITEM_CLASS IN ('ES1901', 'ES2001','ES2002', 'ES2003', 'ES2004')	
			--WHERE  X.YYYYMMDD < @v_data_end_yyyymmdd
			GROUP BY 
					X.DIVISION_ID
			,      X.FROM_SITE
			-- jilee 230830
			,      IM.APPLIED_MODEL
			,      X.ITEM_ID 			
			,      X.YYYYMMDD 
			; 


			------------------------------------------------------------------------------------------------------------- 
			--2-5-1. [I]MES_FCS_HOLD(Hold Stock)       : MES/FCS HOLD 수량 : LOT_ID(일자) + FORMATION L/T 의 hold 수량 
			------------------------------------------------------------------------------------------------------------- 
			INSERT INTO #tmp_SSP_ANL_SHIP_PLAN_40
					(
					 DIVISION_ID  	     
					,PLAN_START_YYYYMMDD 
					,PLAN_TYPE	         
					,SEQ	             
					,ITEM_ID	         
					,FROM_SITE	         
					,TO_SITE	         
					,MEASURE	         
					,YYYYMMDD	         
					,BOD_ID	           
					,QTY	             
					,INCOTERMS         
					,TRANSPORT_MODE    
					,PROJECT_CODE	
					,FCST_TYPE
					,CONFIRM_ID						     
					,ORIGIN_FROM_DIVISION_ID
					,ORIGIN_TO_DIVISION_ID 	
					,ATTRIBUTE1
					)  
			SELECT   X.DIVISION_ID
			,        @v_plan_start_yyyymmdd  
			,        @v_plan_type
			,        @v_seq			
			,        X.ITEM_ID
			,        X.FROM_SITE 
			,        '-' AS TO_SITE
			,       'MES_FCS_HOLD' AS MEASURE
			,        X.YYYYMMDD
			,	    '-' AS BOD_ID	
			,        SUM(X.QTY) 			,       '-' AS INCOTERMS         
			,       '-' AS TRANSPORT_MODE    
			,       '-' AS PROJECT_CODE	
			,       '-' AS FCST_TYPE
			,       '-' AS CONFIRM_ID	
			,       X.DIVISION_ID  AS ORIGIN_FROM_DIVISION_ID
			,       X.DIVISION_ID  AS ORIGIN_TO_DIVISION_ID 
			,       MAX(X.ATTRIBUTE1) 
			FROM    ( 
						SELECT H.DIVISION_ID
						,      H.ITEM_ID
						,      H.FROM_SITE
						,      H.YYYYMMDD_LOT_ID_APPLIED_LT AS YYYYMMDD 
						-- 2020.10.13   KIM BOK KI 수율적용 수량이 아닌 원 수량으로 변경
						--,      H.LOT_QTY_TOT_YIELD   AS QTY -- 수율적용된 수량을 적용    
						,      H.LOT_QTY_TOT   AS QTY -- 수율적용된 수량을 적용    
						,      SUBSTRING(H.LOT_ID, 4,4)             AS ATTRIBUTE1  
						FROM   SSP_ANL_MES_FCS_STOCK_40_C H WITH(NOLOCK)   
						WHERE  H.DIVISION_ID         = @v_division_id
						AND    H.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
						AND    H.PLAN_TYPE           = @v_plan_type
						AND    H.SEQ                 = @v_seq
						-- 2020.10.12 KIM BIK KI 수정
						--AND    (H.AVAILABLE_YN = 'N' OR H.USER_MOD_RELEASE_DATE IS NOT NULL ) 
						AND    H.AVAILABLE_YN = 'N'
						AND    H.CHANGE_STATUS      <> 'D'
						AND    H.LOT_QTY_TOT         > 0
						AND    H.USER_MOD_RELEASE_DATE      >= @v_data_start_yyyymmdd
						AND    H.YYYYMMDD_LOT_ID_APPLIED_LT >= @v_data_start_yyyymmdd
						AND    H.YYYYMMDD_LOT_ID_APPLIED_LT <  @v_data_end_yyyymmdd

						--UNION ALL 

						--SELECT   DISTINCT
						--		 P.DIVISION_ID
						--,        P.ITEM_ID
						--,        P.FROM_SITE
						--,        @v_data_start_yyyymmdd  AS YYYYMMDD 
						--,        0        AS QTY    
						--,        NULL             AS ATTRIBUTE1  
						--FROM     #tmp_SSP_ANL_SHIP_PLAN_40 P WITH(NOLOCK) 
						--WHERE    P.DIVISION_ID = @v_division_id
						--AND    P.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
						--AND    P.PLAN_TYPE           = @v_plan_type
						--AND    P.SEQ                 = @v_seq
						
					) X
					JOIN SCM_MST_SITE E WITH(NOLOCK)
					ON    E.DIVISION_ID = @v_division_id
					AND   ISNULL(E.COMPANY_ID, '')  = @v_company_id
					AND   E.DIVISION_ID = X.DIVISION_ID
					AND   E.SCM_SITE_ID = X.FROM_SITE					
			GROUP BY X.DIVISION_ID
			,        X.ITEM_ID			
			,        X.FROM_SITE 
			,        X.YYYYMMDD
			;

			------------------------------------------------------------------------------------------------------------- 
			--2-5-2. [I]MES_FCS_RELEASE(Release Stock) : MES/FCS HOLD Release 수량 : Default 20991231 이며 사용자가 SSP화면에서 수정 
			--                                SSP_ANL_MES_FCS_STOCK_40_C.USER_MOD_RELEASE_DATE 
			------------------------------------------------------------------------------------------------------------- 
			INSERT INTO #tmp_SSP_ANL_SHIP_PLAN_40
					(
					 DIVISION_ID  	     
					,PLAN_START_YYYYMMDD 
					,PLAN_TYPE	         
					,SEQ	             
					,ITEM_ID	         
					,FROM_SITE	         
					,TO_SITE	         
					,MEASURE	         
					,YYYYMMDD	         
					,BOD_ID	           
					,QTY	             
					,INCOTERMS         
					,TRANSPORT_MODE    
					,PROJECT_CODE	
					,FCST_TYPE
					,CONFIRM_ID						     
					,ORIGIN_FROM_DIVISION_ID
					,ORIGIN_TO_DIVISION_ID 	
					,ATTRIBUTE1
					)  
			SELECT   X.DIVISION_ID
			,        @v_plan_start_yyyymmdd  
			,        @v_plan_type
			,        @v_seq			
			,        X.ITEM_ID
			,        X.FROM_SITE 
			,        '-' AS TO_SITE
			,       'MES_FCS_RELEASE' AS MEASURE
			,        X.YYYYMMDD
			,	    '-' AS BOD_ID	
			,        SUM(X.QTY) 			,       '-' AS INCOTERMS         
			,       '-' AS TRANSPORT_MODE    
			,       '-' AS PROJECT_CODE	
			,       '-' AS FCST_TYPE
			,       '-' AS CONFIRM_ID	
			,       X.DIVISION_ID  AS ORIGIN_FROM_DIVISION_ID
			,       X.DIVISION_ID  AS ORIGIN_TO_DIVISION_ID 
			,       MAX(X.ATTRIBUTE1) 
			FROM   (----------------------------------------------------------------------- 
			        -- USER MODIFY DATE 존재 시 우선 순위 1 단, 2999-12-31 은 제외
					-- MES_FCS_RELEASE DATE 체크하여 반영 QMS  RELEASE DATE 둘중 MAX DATE
					----------------------------------------------------------------------- 
						SELECT   H.DIVISION_ID
						,        H.ITEM_ID
						,        H.FROM_SITE
						,        H.USER_MOD_RELEASE_DATE AS YYYYMMDD 
						-- 2020.10.13   KIM BOK KI 수율적용 수량이 아닌 원 수량으로 변경
						--,        H.LOT_QTY_TOT_YIELD   AS QTY -- 수율적용된 수량을 적용    
						,        H.LOT_QTY_TOT   AS QTY -- 수율적용된 수량을 적용    
						,        SUBSTRING(H.LOT_ID, 4,4)             AS ATTRIBUTE1  
						FROM     (
								SELECT H.DIVISION_ID
									, H.FROM_SITE
									, H.ITEM_ID
									, H.LOT_ID
  						            -- 2020.10.13   KIM BOK KI 수율적용 수량이 아닌 원 수량으로 변경
									--, H.LOT_QTY_TOT_YIELD
									, H.LOT_QTY_TOT
									, CASE WHEN (ISNULL(H.USER_MOD_RELEASE_DATE, '') <> '29991231' AND ISNULL(H.USER_MOD_RELEASE_DATE, '') <> '') THEN H.USER_MOD_RELEASE_DATE
											WHEN (ISNULL(H.USER_MOD_RELEASE_DATE, '') =  '29991231') AND (ISNULL(H.QMS_HOLD_RELEASE, '') > ISNULL(H.MES_HOLD_RELEASE, '')) THEN H.QMS_HOLD_RELEASE
										ELSE H.MES_HOLD_RELEASE  END   AS USER_MOD_RELEASE_DATE
								FROM   SSP_ANL_MES_FCS_STOCK_40_C H (NOLOCK)
								WHERE  1 = 1
								AND    DIVISION_ID         = @v_division_id
								AND    PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
								AND    PLAN_TYPE           = @v_plan_type
								AND    SEQ                 = @v_seq
								AND    AVAILABLE_YN        = 'N'
						        AND    CHANGE_STATUS      <> 'D'
								AND    USER_MOD_RELEASE_DATE >= @v_data_start_yyyymmdd
						         ) H
						WHERE  1 = 1
						AND    H.USER_MOD_RELEASE_DATE IS NOT NULL
						AND    H.USER_MOD_RELEASE_DATE >= @v_data_start_yyyymmdd 
						AND    H.USER_MOD_RELEASE_DATE <  @v_data_end_yyyymmdd

						-- 2020.10.13 LOGIC 변경에 따른 주석 처리
						--FROM   SSP_ANL_MES_FCS_STOCK_40_C H WITH(NOLOCK)    
						--WHERE  H.DIVISION_ID         = @v_division_id
						--AND    H.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
						--AND    H.PLAN_TYPE           = @v_plan_type
						--AND    H.SEQ                 = @v_seq
						--AND    H.CHANGE_STATUS      <> 'D'
						--AND    H.USER_MOD_RELEASE_DATE >= @v_data_start_yyyymmdd 
						--AND    H.USER_MOD_RELEASE_DATE <  @v_data_end_yyyymmdd
						--AND    H.LOT_QTY_TOT > 0
						--AND    H.USER_MOD_RELEASE_DATE IS NOT NULL 

						--UNION ALL 

						--SELECT   DISTINCT
						--		 P.DIVISION_ID
						--,        P.ITEM_ID
						--,        P.FROM_SITE
						--,        @v_data_start_yyyymmdd  AS YYYYMMDD 
						--,        0        AS QTY    
						--,        NULL             AS ATTRIBUTE1  
						--FROM     #tmp_SSP_ANL_SHIP_PLAN_40 P WITH(NOLOCK) 
						--WHERE    P.DIVISION_ID = @v_division_id
						--AND    P.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
						--AND    P.PLAN_TYPE           = @v_plan_type
						--AND    P.SEQ                 = @v_seq
			
				   ) X
					JOIN SCM_MST_SITE E WITH(NOLOCK)
					ON    E.DIVISION_ID = @v_division_id
					AND   ISNULL(E.COMPANY_ID, '')  = @v_company_id
					AND   E.DIVISION_ID = X.DIVISION_ID
					AND   E.SCM_SITE_ID = X.FROM_SITE					
			GROUP BY X.DIVISION_ID
			,        X.ITEM_ID			
			,        X.FROM_SITE 
			,        X.YYYYMMDD
			;

			-------------------------------------------------------------------------------------------------------------             
			--2-6. PROD_PLAN OR INCO_WIP 존재하지 않는 경우, 해당 MEASURE를 0으로 추가  
			-------------------------------------------------------------------------------------------------------------   
 			DECLARE @X_INT        INT   =1;  
			DECLARE @X_MEASURE    NVARCHAR(100);  
  
			WHILE @X_INT < 8
			BEGIN  
              
				SELECT @X_MEASURE = ( CASE @X_INT   WHEN 1 THEN 'PROD_PLAN'   
													WHEN 2 THEN 'INCO_WIP'   
													WHEN 3 THEN 'SHIP_REQ'
													WHEN 4 THEN 'SHIP_CONFIRM'
													WHEN 5 THEN 'POSTP_PLAN'
													WHEN 6 THEN 'MES_FCS_HOLD'
													WHEN 7 THEN 'MES_FCS_RELEASE'
										END);  
       
				INSERT INTO #tmp_SSP_ANL_SHIP_PLAN_40
					(
					 DIVISION_ID  	     
					,PLAN_START_YYYYMMDD 
					,PLAN_TYPE	         
					,SEQ	             
					,ITEM_ID	         
					,FROM_SITE	         
					,TO_SITE	         
					,MEASURE	         
					,YYYYMMDD	         
					,BOD_ID	           
					,QTY	             
					,INCOTERMS         
					,TRANSPORT_MODE    
					,PROJECT_CODE	
					,FCST_TYPE
					,CONFIRM_ID 						     
					,ORIGIN_FROM_DIVISION_ID	
					,ORIGIN_TO_DIVISION_ID	-- ORIGIN_TO_DIVISION_ID      
					)        
				SELECT   
					 SUB.DIVISION_ID
					,SUB.PLAN_START_YYYYMMDD
					,SUB.PLAN_TYPE
					,SUB.SEQ
					,SUB.ITEM_ID
					,SUB.FROM_SITE
					,SUB.TO_SITE
					,SUB.MEASURE
					,SUB.YYYYMMDD
					,SUB.BOD_ID
					,0              AS QTY                      
					,SUB.INCOTERMS
					,SUB.TRANSPORT_MODE
					,SUB.PROJECT_CODE
					,SUB.FCST_TYPE
					,SUB.CONFIRM_ID --'-' AS CONFIRM_ID 
					,SUB.DIVISION_ID -- ORIGIN_FROM_DIVISION_ID
					,SUB.DIVISION_ID --ORIGIN_TO_DIVISION_ID	
				FROM     
					(    
						SELECT   DIVISION_ID
								,PLAN_START_YYYYMMDD
								,PLAN_TYPE
								,SEQ
								,ITEM_ID
								,FROM_SITE
								,'-'         AS TO_SITE
								,@X_MEASURE  AS MEASURE
								,YYYYMMDD
								,'-' AS BOD_ID
								,'-' AS INCOTERMS
								,'-' AS TRANSPORT_MODE
								,'-' AS PROJECT_CODE
								,'-' AS FCST_TYPE
								,'-' AS CONFIRM_ID
							FROM    
								(  -- 56 DAYS (7*8)
									SELECT C.BASIS_YYYYMMDD AS YYYYMMDD      
									FROM SCM_SYS_CALENDAR_M    C WITH(NOLOCK)     
									WHERE 1=1  
									AND C.BASIS_YYYYMMDD >= @v_data_start_yyyymmdd   
									AND C.BASIS_YYYYMMDD <  @v_data_end_yyyymmdd
								) A,    
								(    
									SELECT  DISTINCT   
											DIVISION_ID
										,PLAN_START_YYYYMMDD
										,PLAN_TYPE
										,SEQ
										,ITEM_ID
										,FROM_SITE
									FROM  #tmp_SSP_ANL_SHIP_PLAN_40 X WITH(NOLOCK)   								 
									WHERE 1=1  
								  
								) B    
					) SUB    
					WHERE 1=1    
						AND NOT EXISTS (    
										SELECT 'X'    
										FROM #tmp_SSP_ANL_SHIP_PLAN_40 Z WITH(NOLOCK)     
										WHERE 1=1    
											AND Z.DIVISION_ID              = SUB.DIVISION_ID            
											AND Z.PLAN_START_YYYYMMDD      = SUB.PLAN_START_YYYYMMDD        
											AND Z.PLAN_TYPE                = SUB.PLAN_TYPE              
											AND Z.SEQ                      = SUB.SEQ          
											AND Z.ITEM_ID                  = SUB.ITEM_ID   										            
											AND Z.FROM_SITE                = SUB.FROM_SITE       
											AND Z.MEASURE                  = @X_MEASURE      										     										                                                    
											AND Z.YYYYMMDD                 = SUB.YYYYMMDD     

										)
				;    

				SET @X_INT = @X_INT + 1;  
      
			END  

			-------------------------------------------------------------------------------------------------------------             
			--2-7. MEASURE별 BUCKET일자별 0 채우기        
			-------------------------------------------------------------------------------------------------------------                      
			INSERT INTO #tmp_SSP_ANL_SHIP_PLAN_40
				(
					DIVISION_ID  	     
				,PLAN_START_YYYYMMDD 
				,PLAN_TYPE	         
				,SEQ	             
				,ITEM_ID	         
				,FROM_SITE	         
				,TO_SITE	         
				,MEASURE	         
				,YYYYMMDD	         
				,BOD_ID	           
				,QTY	             
				,INCOTERMS         
				,TRANSPORT_MODE    
				,PROJECT_CODE	
				,FCST_TYPE
				,CONFIRM_ID						     
				,ORIGIN_FROM_DIVISION_ID	
				,ORIGIN_TO_DIVISION_ID -- ORIGIN_TO_DIVISION_ID     
				)        
			SELECT   
					SUB.DIVISION_ID
				,SUB.PLAN_START_YYYYMMDD
				,SUB.PLAN_TYPE
				,SUB.SEQ
				,SUB.ITEM_ID
				,SUB.FROM_SITE
				,SUB.TO_SITE
				,SUB.MEASURE
				,SUB.YYYYMMDD
				,SUB.BOD_ID
				,0              AS QTY                      
				,SUB.INCOTERMS
				,SUB.TRANSPORT_MODE
				,SUB.PROJECT_CODE
				,SUB.FCST_TYPE
				,'-' AS CONFIRM_ID 
				,SUB.DIVISION_ID	
				,SUB.DIVISION_ID -- ORIGIN_TO_DIVISION_ID	    
			FROM     
				(    
					SELECT   DIVISION_ID
							,PLAN_START_YYYYMMDD
							,PLAN_TYPE
							,SEQ
							,ITEM_ID
							,FROM_SITE
							,TO_SITE
							,MEASURE
							,YYYYMMDD
							,'-' AS  BOD_ID
							,'-' AS  INCOTERMS
							,'-' AS  TRANSPORT_MODE
							,'-' AS  PROJECT_CODE
							,'-' AS  FCST_TYPE
						FROM    
							(   -- 56 DAYS (7*8) 
								SELECT C.BASIS_YYYYMMDD AS YYYYMMDD      
								FROM SCM_SYS_CALENDAR_M    C WITH(NOLOCK)     
								WHERE 1=1  
								AND C.BASIS_YYYYMMDD >= @v_data_start_yyyymmdd   
								AND C.BASIS_YYYYMMDD <  @v_data_end_yyyymmdd 
							) A,    
							(    
								SELECT DISTINCT   
									 DIVISION_ID
									,PLAN_START_YYYYMMDD
									,PLAN_TYPE
									,SEQ
									,ITEM_ID
									,FROM_SITE
									,TO_SITE
									,MEASURE
								FROM  #tmp_SSP_ANL_SHIP_PLAN_40 X WITH(NOLOCK)   
								WHERE 1=1  
								  
							) B    
				) SUB    
				WHERE 1=1    
					AND NOT EXISTS (    
									SELECT 'X'    
										FROM #tmp_SSP_ANL_SHIP_PLAN_40 Z WITH(NOLOCK)     
									WHERE 1=1    
										AND Z.DIVISION_ID              = SUB.DIVISION_ID            
										AND Z.PLAN_START_YYYYMMDD      = SUB.PLAN_START_YYYYMMDD        
										AND Z.PLAN_TYPE                = SUB.PLAN_TYPE              
										AND Z.SEQ                      = SUB.SEQ          
										AND Z.ITEM_ID                  = SUB.ITEM_ID   										            
										AND Z.FROM_SITE                = SUB.FROM_SITE       
										AND Z.TO_SITE                  = SUB.TO_SITE    
										AND Z.MEASURE                  = SUB.MEASURE      										     										                                                    
										AND Z.YYYYMMDD                 = SUB.YYYYMMDD     
									)
			;  

 			/*------------------------------------------------------------------------------------------------------------- 
			2-8. PROD_PLAN 재 적용   
			---------------------------------------------------------------------------------------------------------------
			    [CSR ID:4045697]   : PROD수량 - OWMS 수량,LOT(PROD_DATE) 및 화면메모 Description 저장 
			---------------------------------------------------------------------------------------------------------------	
			    [C20200115-000418]-2 : Prod Qty(MASS)와 Prod Qty(MASS)가 다를 경우 Memo 추가 표시, 오창(A010-A)만 적용
			   		ATTRIBUTE4 : Prod Qty(MASS)	
			   		ATTRIBUTE5 : Prod Qty(ALL)
			   		ATTRIBUTE6 : oWMS 재고 수량	
					ATTRIBUTE3 : 메모Description 
						  (기존) : oWMS 재고 존재시 : oWMS재고 표시  
			  			  (변경) : Prod Qty(전체) 와 Prod Qty(MASS)가 다를 경우 Prod Qty(MASS) 수량 추가 표시, 오참(A010-A)만 적용
			-------------------------------------------------------------------------------------------------------------*/
			WITH OWMS_LOT AS 
				( --OWMS LOT별 재고 
				SELECT S.DIVISION_ID 
				,      S.FROM_SITE 
				,      S.ITEM_ID 
				,      SUM(S.AVAILABLE_QTY) AS QTY 
				,      SUBSTRING(S.LOT_ID,4,4) AS LOT 
				,      LY.SEGMENT2 + LM.SEGMENT2+ SUBSTRING(S.LOT_ID,6,2) AS PROD_DATE 
				FROM   SSP_ANL_OWMS_STOCK_C S WITH(NOLOCK) 
					  JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LY WITH(NOLOCK) 
						ON LY.LOOKUP_TYPE = 'LOT_ID_YEAR' 
						AND LY.VALID_YN    = 'Y' 
						AND LY.SEGMENT1    = SUBSTRING(S.LOT_ID,4,1)
						AND LY.SEGMENT2 BETWEEN CONVERT(VARCHAR(4),DATEADD(YY,-11,GETDATE()),112) AND  CONVERT(VARCHAR(4),DATEADD(YY,8,GETDATE()),112)
					  JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LM WITH(NOLOCK) 
						ON LM.LOOKUP_TYPE = 'LOT_ID_MONTH' 
						AND LM.VALID_YN    = 'Y' 
						AND LM.SEGMENT1    = SUBSTRING(S.LOT_ID,5,1)
					  JOIN SCM_SYS_CALENDAR_M    C WITH(NOLOCK) -- 유효한 날짜만 추출
						ON C.BASIS_YYYYMMDD = LY.SEGMENT2 + LM.SEGMENT2+ SUBSTRING(S.LOT_ID,6,2)

						JOIN SCM_MST_SITE E WITH(NOLOCK)
						ON    E.DIVISION_ID = @v_division_id
						AND   ISNULL(E.COMPANY_ID, '')  = @v_company_id
						AND   E.DIVISION_ID = S.DIVISION_ID
						AND   E.SCM_SITE_ID = S.FROM_SITE
				WHERE S.DIVISION_ID         = @v_division_id  
				AND   S.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd 
				AND   S.PLAN_TYPE           = @v_plan_type 
				AND   S.SEQ                 = @v_seq 
				AND   S.AVAILABLE_QTY > 0
				GROUP BY S.DIVISION_ID 
				,        S.FROM_SITE 
				,        S.ITEM_ID 
				,        SUBSTRING(S.LOT_ID,4,4) 
				,        LY.SEGMENT2 + LM.SEGMENT2+ SUBSTRING(S.LOT_ID,6,2) 
				) 

			UPDATE #tmp_SSP_ANL_SHIP_PLAN_40   
			SET    QTY        = CASE WHEN (P.QTY - ISNULL(S.QTY ,0)) < 0 THEN 0 ELSE  P.QTY - ISNULL(S.QTY ,0) END -- 음수일경우 0으로 적용(전체 PROD수량 - OWMS재고수량) 
			--[C20200115-000418]-2 : 오창일 경우 Prod Qty(MASS)와 Prod Qty(MASS)가 다를 경우 Memo 추가 표시 
            ,      ATTRIBUTE3 = CASE WHEN P.FROM_SITE = 'A010-A' THEN 
										CASE WHEN (S.QTY IS NOT NULL AND P.ATTRIBUTE4 <> P.ATTRIBUTE5 ) THEN 
													'Prod Qty(MASS) : '+ REPLACE(CONVERT(VARCHAR, CAST( CONVERT(DECIMAL(20,10),  P.ATTRIBUTE4 ) AS MONEY),1),'.00','') + '  ,' + 
													'oWMS Qty : '+ REPLACE(CONVERT(VARCHAR, CAST( S.QTY AS MONEY),1),'.00','')
											 WHEN (S.QTY IS NOT NULL AND P.ATTRIBUTE4 = P.ATTRIBUTE5) THEN 
													'oWMS Qty : '+ REPLACE(CONVERT(VARCHAR, CAST( S.QTY AS MONEY),1),'.00','')
											 WHEN (S.QTY IS NULL AND P.ATTRIBUTE4 <> P.ATTRIBUTE5 ) THEN 
													'Prod Qty(MASS) : '+ REPLACE(CONVERT(VARCHAR, CAST( CONVERT(DECIMAL(20,10),  P.ATTRIBUTE4 ) AS MONEY),1),'.00','')
										ELSE
											 NULL
										END
                                 ELSE
								       'oWMS Qty : '+ REPLACE(CONVERT(VARCHAR, CAST( S.QTY AS MONEY),1),'.00','')
								 END 
			 ,      ATTRIBUTE6 = S.QTY --OWMS 재고 수량 
			FROM   #tmp_SSP_ANL_SHIP_PLAN_40 P WITH(NOLOCK) 
				LEFT OUTER JOIN OWMS_LOT S WITH(NOLOCK) 
				   ON S.DIVISION_ID = P.DIVISION_ID 
				  AND S.ITEM_ID     = P.ITEM_ID 
				  AND S.FROM_SITE   = P.FROM_SITE 
				  AND S.PROD_DATE   = P.ATTRIBUTE1 

					JOIN SCM_MST_SITE E WITH(NOLOCK)
					ON    E.DIVISION_ID = @v_division_id
					AND   ISNULL(E.COMPANY_ID, '')  = @v_company_id
					AND   E.DIVISION_ID = P.DIVISION_ID
					AND   E.SCM_SITE_ID = P.FROM_SITE
			WHERE P.DIVISION_ID         = @v_division_id  
			AND   P.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd 
			AND   P.PLAN_TYPE           = @v_plan_type 
			AND   P.SEQ                 = @v_seq 
			AND   P.MEASURE             = 'PROD_PLAN'
			AND   P.ATTRIBUTE1 IS NOT NULL 
			;

			------------------------------------------------------------------------------------------------------------- 
			--2-9. [P]PROD_DATE(Production Date)    : 조립완료일(실적완료일) 
			--   PROD_PLAN의 ATTRIBUTE1 에 조립완료일 
			------------------------------------------------------------------------------------------------------------- 
			INSERT INTO #tmp_SSP_ANL_SHIP_PLAN_40
				(
				 DIVISION_ID  	     
				,PLAN_START_YYYYMMDD 
				,PLAN_TYPE	         
				,SEQ	             
				,ITEM_ID	         
				,FROM_SITE	         
				,TO_SITE	         
				,MEASURE	         
				,YYYYMMDD	         
				,BOD_ID	           
				,QTY	             
				,ROUTE_ID	         
				,INCOTERMS         
				,TRANSPORT_MODE    
				,BIZ_TYPE	         
				,PROJECT_CODE	     
				,FCST_TYPE	       
				,FCST_ETD_DATE	
				,FCST_ETA_DATE   
				,ETD_DATE	         
				,ETA_DATE
				,CONFIRM_ID
				,ORIGIN_FROM_DIVISION_ID
				,ORIGIN_TO_DIVISION_ID 
				,ATTRIBUTE1     					     
				)
			SELECT   A.DIVISION_ID  	     
				,A.PLAN_START_YYYYMMDD 
				,A.PLAN_TYPE	         
				,A.SEQ	             
				,A.ITEM_ID	         
				,A.FROM_SITE	         
				,A.TO_SITE	         
				,'PROD_DATE' AS MEASURE	         
				,A.YYYYMMDD	         
				,A.BOD_ID	           
				,A.QTY             
				,A.ROUTE_ID	         
				,A.INCOTERMS         
				,A.TRANSPORT_MODE    
				,A.BIZ_TYPE	         
				,A.PROJECT_CODE	     
				,A.FCST_TYPE	       
				,A.FCST_ETD_DATE	
				,A.FCST_ETA_DATE   
				,A.ETD_DATE	         
				,A.ETA_DATE	
				,A.CONFIRM_ID
				,A.DIVISION_ID
				,A.DIVISION_ID
				,CASE WHEN A.QTY > 0 THEN A.ATTRIBUTE1 ELSE NULL END ATTRIBUTE1
			FROM  #tmp_SSP_ANL_SHIP_PLAN_40 A WITH (NOLOCK) 

					JOIN SCM_MST_SITE E WITH(NOLOCK)
					ON    E.DIVISION_ID = @v_division_id
					AND   ISNULL(E.COMPANY_ID, '')  = @v_company_id
					AND   E.DIVISION_ID = A.DIVISION_ID
					AND   E.SCM_SITE_ID = A.FROM_SITE
			WHERE A.MEASURE ='PROD_PLAN'
			;

			------------------------------------------------------------------------------------------------------------- 
			--2-10. [P]LOT(Lot)    : PROD_DATE의 LOT정보 [CSR ID:4045697]
			--   PROD_PLAN의 ATTRIBUTE1 에 조립완료일의 LOT정보 
			------------------------------------------------------------------------------------------------------------- 
			INSERT INTO #tmp_SSP_ANL_SHIP_PLAN_40
				(
					DIVISION_ID  	     
				,PLAN_START_YYYYMMDD 
				,PLAN_TYPE	         
				,SEQ	             
				,ITEM_ID	         
				,FROM_SITE	         
				,TO_SITE	         
				,MEASURE	         
				,YYYYMMDD	         
				,BOD_ID	           
				,QTY	             
				,ROUTE_ID	         
				,INCOTERMS         
				,TRANSPORT_MODE    
				,BIZ_TYPE	         
				,PROJECT_CODE	     
				,FCST_TYPE	       
				,FCST_ETD_DATE	
				,FCST_ETA_DATE   
				,ETD_DATE	         
				,ETA_DATE
				,CONFIRM_ID
				,ORIGIN_FROM_DIVISION_ID
				,ORIGIN_TO_DIVISION_ID 
				,ATTRIBUTE1     					     
				)
			SELECT P.DIVISION_ID  	     
				,P.PLAN_START_YYYYMMDD 
				,P.PLAN_TYPE	         
				,P.SEQ	             
				,P.ITEM_ID	         
				,P.FROM_SITE	         
				,P.TO_SITE	         
				,'LOT' AS MEASURE	         
				,P.YYYYMMDD	         
				,P.BOD_ID	           
				,P.QTY             
				,P.ROUTE_ID	         
				,P.INCOTERMS         
				,P.TRANSPORT_MODE    
				,P.BIZ_TYPE	         
				,P.PROJECT_CODE	     
				,P.FCST_TYPE	       
				,P.FCST_ETD_DATE	
				,P.FCST_ETA_DATE   
				,P.ETD_DATE	         
				,P.ETA_DATE	
				,P.CONFIRM_ID
				,P.DIVISION_ID --ORIGIN_FROM_DIVISION_ID
				,P.DIVISION_ID --ORIGIN_TO_DIVISION_ID
				,CASE WHEN QTY > 0 THEN LY.SEGMENT1 + LM.SEGMENT1 + SUBSTRING(P.ATTRIBUTE1,7,2) ELSE NULL END ATTRIBUTE1
			FROM  #tmp_SSP_ANL_SHIP_PLAN_40 P WITH (NOLOCK) 
				  LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LY WITH(NOLOCK) 
					ON LY.LOOKUP_TYPE = 'LOT_ID_YEAR' 
					AND LY.VALID_YN    = 'Y' 
					AND LY.SEGMENT2    = SUBSTRING(P.ATTRIBUTE1,1,4)
					AND LY.SEGMENT2 BETWEEN CONVERT(VARCHAR(4),DATEADD(YY,-11,GETDATE()),112) AND  CONVERT(VARCHAR(4),DATEADD(YY,8,GETDATE()),112)
				  LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LM WITH(NOLOCK) 
					ON LM.LOOKUP_TYPE = 'LOT_ID_MONTH' 
					AND LM.VALID_YN    = 'Y' 
					AND LM.SEGMENT2    = SUBSTRING(P.ATTRIBUTE1,5,2)

					JOIN SCM_MST_SITE E WITH(NOLOCK)
					ON    E.DIVISION_ID = @v_division_id
					AND   ISNULL(E.COMPANY_ID, '')  = @v_company_id
					AND   E.DIVISION_ID = P.DIVISION_ID
					AND   E.SCM_SITE_ID = P.FROM_SITE
			WHERE MEASURE ='PROD_DATE'			
			;

			/*------------------------------------------------------------------------------------------------------------- 
			2-11. [P]WH_IN(WH in Plan)  : Prod Qty(MASS) - oWMS 재고 수량, 단 사용자가 입력한 값이 있으면 사용자 입력가 유지 
			     최근 PLAN의 값을 읽어와 유지 필요 
              --------------------------------------------------------------------------------------------------------------
              [C20200115-000418]-3 : WH_IN수량에 Prodcution_type이 MASS 수량 반영 , 오창(A010-A)만 적용
			        (기존) : Prod Qty(전체) -  oWMS 재고 수량
			        (변경) : Prod Qty(MASS)(ATTRIBUTE4)  - oWMS 재고 수량(ATTRIBUTE6)  

			                 [P]WH_IN(WH in Plan) QTY 
			                    오창(A010-A) : ATTRIBUTE4 - ATTRIBUTE6  ( Prod Qty(MASS) - oWMS 재고 수량) 
			                    나머지       : ATTRIBUTE4 - ATTRIBUTE6  ( Prod Qty(ALL)  - oWMS 재고 수량) 

			   	ATTRIBUTE4 : Prod Qty(MASS)	
			   	ATTRIBUTE5 : Prod Qty(ALL)
			   	ATTRIBUTE6 : oWMS 재고 수량	
			--------------------------------------------------------------------------------------------------------------*/ 
			INSERT INTO #tmp_SSP_ANL_SHIP_PLAN_40
				(
				 DIVISION_ID  	     
				,PLAN_START_YYYYMMDD 
				,PLAN_TYPE	         
				,SEQ	             
				,ITEM_ID	         
				,FROM_SITE	         
				,TO_SITE	         
				,MEASURE	         
				,YYYYMMDD	         
				,BOD_ID	           
				,QTY	             
				,ROUTE_ID	         
				,INCOTERMS         
				,TRANSPORT_MODE    
				,BIZ_TYPE	         
				,PROJECT_CODE	     
				,FCST_TYPE	       
				,FCST_ETD_DATE	
				,FCST_ETA_DATE   
				,ETD_DATE	         
				,ETA_DATE
				,CONFIRM_ID
				,ORIGIN_FROM_DIVISION_ID
				,ORIGIN_TO_DIVISION_ID      					     
				)
			SELECT   
				 T. DIVISION_ID  	     
				,T.PLAN_START_YYYYMMDD 
				,T.PLAN_TYPE	         
				,T.SEQ	             
				,T.ITEM_ID	         
				,T.FROM_SITE	         
				,T.TO_SITE	         
				,'WH_IN' AS MEASURE	         
				,T.YYYYMMDD	         
				,T.BOD_ID	  
				--[C20200115-000418]-3 : WH_IN수량에 Prodcution_type이 MASS 수량 반영 , 오창(A010-A)만 적용
				,CASE WHEN X.QTY IS NOT NULL THEN X.QTY --사용자 수정수량이 있으면 사용자 수정 수량 적용 
				 ELSE 
					  CASE WHEN T.FROM_SITE = 'A010-A' THEN 
					      -- 오창(A010-A) : ATTRIBUTE4 - ATTRIBUTE6  ( Prod Qty(MASS) - oWMS 재고 수량) 
						  CASE WHEN CONVERT(DECIMAL(20,10), ISNULL(T.ATTRIBUTE4,0)) - CONVERT(DECIMAL(20,10), ISNULL(T.ATTRIBUTE6,0)) < 0 THEN 0 
						  ELSE
							   CONVERT(DECIMAL(20,10), ISNULL(T.ATTRIBUTE4,0)) - CONVERT(DECIMAL(20,10), ISNULL(T.ATTRIBUTE6,0))
						  END 

					  ELSE 
					      -- 이외 : ATTRIBUTE5 - ATTRIBUTE6  ( Prod Qty(ALL) - oWMS 재고 수량)  
						  CASE WHEN CONVERT(DECIMAL(20,10), ISNULL(T.ATTRIBUTE5,0)) - CONVERT(DECIMAL(20,10), ISNULL(T.ATTRIBUTE6,0)) < 0 THEN 0 
						  ELSE
							   CONVERT(DECIMAL(20,10), ISNULL(T.ATTRIBUTE5,0)) - CONVERT(DECIMAL(20,10), ISNULL(T.ATTRIBUTE6,0))
						  END					      
					  END 
				 END   AS QTY    		 
				,T.ROUTE_ID	         
				,T.INCOTERMS         
				,T.TRANSPORT_MODE    
				,T.BIZ_TYPE	         
				,T.PROJECT_CODE	     
				,T.FCST_TYPE	       
				,T.FCST_ETD_DATE	
				,T.FCST_ETA_DATE                              
				,T.ETD_DATE	                                    
				,T.ETA_DATE	                           
				,T.CONFIRM_ID                           
				,T.DIVISION_ID --ORIGIN_FROM_DIVISION_ID                           
				,T.DIVISION_ID --ORIGIN_TO_DIVISION_ID                           
			FROM  #tmp_SSP_ANL_SHIP_PLAN_40 T  WITH (NOLOCK)   
				LEFT OUTER JOIN ( 
								SELECT H.DIVISION_ID 
								,      H.ITEM_ID
								,      H.FROM_SITE 
								,      H.MEASURE 
								,      H.YYYYMMDD
								,      H.QTY 
								FROM [SSP_ANL_SHIP_PLAN_40_WH_IN_H] H WITH(NOLOCK) 
								WHERE H.HISTORY_SEQ = (SELECT MAX(B.HISTORY_SEQ ) 
														FROM  [SSP_ANL_SHIP_PLAN_40_WH_IN_H] B WITH(NOLOCK) 
														WHERE B.DIVISION_ID = H.DIVISION_ID 
														AND   B.ITEM_ID     = H.ITEM_ID 
														AND   B.FROM_SITE   = H.FROM_SITE 
														AND   B.MEASURE     = H.MEASURE 
														AND   B.YYYYMMDD    = H.YYYYMMDD )  
								) X 
					ON  X.DIVISION_ID = T.DIVISION_ID 
					AND X.ITEM_ID = T.ITEM_ID
					AND X.FROM_SITE = T.FROM_SITE
					AND X.MEASURE =  'WH_IN' 
					AND X.YYYYMMDD = T.YYYYMMDD 

					JOIN SCM_MST_SITE E WITH(NOLOCK)
					ON    E.DIVISION_ID = @v_division_id
					AND   ISNULL(E.COMPANY_ID, '')  = @v_company_id
					AND   E.DIVISION_ID = T.DIVISION_ID
					AND   E.SCM_SITE_ID = T.FROM_SITE
			WHERE T.MEASURE ='PROD_PLAN'             
			;
			------------------------------------------------------------------------------------------------------------- 
			--2-12.	[P]INSP_WIP(Inspection WIP) : 당일 I[P]INSP_WIP(Inspection WIP) : 전일 [P]INSP_WIP(Inspection WIP) + 당일 [P]INCO_WIP(Incomming WIP) - 전일[P]WH_IN(WH in Plan)
			--      TCO 모델은 0으로 
			-------------------------------------------------------------------------------------------------------------  
			WITH INSP AS (    
						-- INCO_WIP(Incomming WIP) 기준 시작       
						SELECT DISTINCT  
							   A.DIVISION_ID  	     
						,      A.PLAN_START_YYYYMMDD 
						,      A.PLAN_TYPE	         
						,      A.SEQ	             
						,      A.ITEM_ID	         
						,      A.FROM_SITE  
						,      SUM(A.QTY) AS QTY      
						FROM  #tmp_SSP_ANL_SHIP_PLAN_40 A WITH(NOLOCK ) 
								JOIN SCM_MST_SITE E WITH(NOLOCK)
								ON    E.DIVISION_ID = @v_division_id
								AND   ISNULL(E.COMPANY_ID, '')  = @v_company_id
								AND   E.DIVISION_ID = A.DIVISION_ID
								AND   E.SCM_SITE_ID = A.FROM_SITE
						WHERE 1=1 
						AND A.DIVISION_ID         = @v_division_id         
						AND A.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd  
						AND A.PLAN_TYPE           = @v_plan_type           
						AND A.SEQ                 = @v_seq                
						AND A.MEASURE             = 'INCO_WIP' 
						AND A.YYYYMMDD            = @v_data_start_yyyymmdd
						GROUP BY A.DIVISION_ID  	     
						,        A.PLAN_START_YYYYMMDD 
						,        A.PLAN_TYPE	         
						,        A.SEQ	             
						,        A.ITEM_ID	         
						,        A.FROM_SITE  
						,        A.YYYYMMDD 
							),
				Z AS (
						SELECT DISTINCT  
								A.DIVISION_ID  	     
						,      A.PLAN_START_YYYYMMDD 
						,      A.PLAN_TYPE	         
						,      A.SEQ	             
						,      A.ITEM_ID	         
						,      A.FROM_SITE  
						,      A.YYYYMMDD     
						FROM  #tmp_SSP_ANL_SHIP_PLAN_40 A WITH(NOLOCK ) 
								JOIN SCM_MST_SITE E WITH(NOLOCK)
								ON    E.DIVISION_ID = @v_division_id
								AND   ISNULL(E.COMPANY_ID, '')  = @v_company_id
								AND   E.DIVISION_ID = A.DIVISION_ID
								AND   E.SCM_SITE_ID = A.FROM_SITE
						WHERE 1=1 
						AND A.DIVISION_ID         = @v_division_id         
						AND A.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd  
						AND A.PLAN_TYPE           = @v_plan_type           
						AND A.SEQ                 = @v_seq                
						AND A.MEASURE             IN ( 'INCO_WIP' ,'WH_IN')
						AND A.YYYYMMDD            >= @v_data_start_yyyymmdd
						GROUP BY A.DIVISION_ID  	     
						,        A.PLAN_START_YYYYMMDD 
						,        A.PLAN_TYPE	         
						,        A.SEQ	             
						,        A.ITEM_ID	         
						,        A.FROM_SITE  
						,        A.YYYYMMDD 
						) 
					
			INSERT INTO #tmp_SSP_ANL_SHIP_PLAN_40
				(
					DIVISION_ID  	     
				,PLAN_START_YYYYMMDD 
				,PLAN_TYPE	         
				,SEQ	             
				,ITEM_ID	         
				,FROM_SITE	         
				,TO_SITE	         
				,MEASURE	         
				,YYYYMMDD	         
				,BOD_ID	           
				,QTY	             
				,INCOTERMS         
				,TRANSPORT_MODE    
				,PROJECT_CODE	     
				,FCST_TYPE
				,CONFIRM_ID	      
				,ORIGIN_FROM_DIVISION_ID
				,ORIGIN_TO_DIVISION_ID -- ORIGIN_TO_DIVISION_ID					 
				)
			SELECT   
				Z.DIVISION_ID            
				,Z.PLAN_START_YYYYMMDD            
				,Z.PLAN_TYPE            
				,Z.SEQ            
				,Z.ITEM_ID            
				,Z.FROM_SITE    
				,'-'   AS TO_SITE         
				,'INSP_WIP' AS MEASURE
				,Z.YYYYMMDD  
				,'-'   AS BOD_ID
				,ISNULL(INSP.QTY,0)  
					+
					(-- INCO_WIP 당일  
					SELECT  ISNULL(SUM(  ISNULL(X.QTY,0)),0)   
					FROM #tmp_SSP_ANL_SHIP_PLAN_40 X WITH(NOLOCK)   
					WHERE 1=1  
					AND X.DIVISION_ID          = Z.DIVISION_ID  
					AND X.PLAN_START_YYYYMMDD  = Z.PLAN_START_YYYYMMDD           
					AND X.PLAN_TYPE            = Z.PLAN_TYPE  
					AND X.SEQ                  = Z.SEQ  
					AND X.ITEM_ID              = Z.ITEM_ID  
					AND X.FROM_SITE            = Z.FROM_SITE  
					AND X.MEASURE              = 'INCO_WIP' 
					AND X.YYYYMMDD             > @v_data_start_yyyymmdd
					AND X.YYYYMMDD             <= Z.YYYYMMDD  )   	
					+ 
					(-- 전날 WH_IN 
					SELECT  ISNULL(SUM(ISNULL(X.QTY,0)),0)   * -1
					FROM #tmp_SSP_ANL_SHIP_PLAN_40 X WITH(NOLOCK)   
					WHERE 1=1  
					AND X.DIVISION_ID          = Z.DIVISION_ID  
					AND X.PLAN_START_YYYYMMDD  = Z.PLAN_START_YYYYMMDD           
					AND X.PLAN_TYPE            = Z.PLAN_TYPE  
					AND X.SEQ                  = Z.SEQ  
					AND X.ITEM_ID              = Z.ITEM_ID  
					AND X.FROM_SITE            = Z.FROM_SITE  
					AND X.MEASURE              = 'WH_IN' 
					AND X.YYYYMMDD             >= @v_data_start_yyyymmdd
					AND X.YYYYMMDD             < Z.YYYYMMDD	)   	
				,'-'   AS INCOTERMS         
				,'-'   AS TRANSPORT_MODE    
				,'-'   AS PROJECT_CODE	
				,'-'   AS FCST_TYPE	
				,'-'   AS CONFIRM_ID	
				,Z.DIVISION_ID --ORIGIN_FROM_DIVISION_ID
				,Z.DIVISION_ID --ORIGIN_TO_DIVISION_ID	
			FROM Z WITH(NOLOCK)   
			LEFT OUTER JOIN INSP WITH(NOLOCK) 
				ON Z.DIVISION_ID         = INSP.DIVISION_ID  
			AND Z.PLAN_START_YYYYMMDD = INSP.PLAN_START_YYYYMMDD  
			AND Z.PLAN_TYPE           = INSP.PLAN_TYPE  
			AND Z.SEQ                 = INSP.SEQ  
			AND Z.ITEM_ID             = INSP.ITEM_ID  
			AND Z.FROM_SITE           = INSP.FROM_SITE  
			WHERE 1=1 
			;
			
			-- TCO 모델은 WH_IN과 관계없이 전부 0으로 SETTING (2019.04.19 Requested by 김광희) 해당내용 변경시 PR_SSP_ANL_SHIP_UPDATE_BOH_VAL_40 동시 변경필요  
			UPDATE #tmp_SSP_ANL_SHIP_PLAN_40
			SET    QTY = 0 
			FROM   #tmp_SSP_ANL_SHIP_PLAN_40 P WITH(NOLOCK) 
				  JOIN SCP_MST_FINAL_ITEM F WITH(NOLOCK) 
					ON  F.ITEM_ID = P.ITEM_ID 
					AND F.DIVISION_ID = P.DIVISION_ID
					AND F.TCO_CELL_YN = 'Y'

					JOIN SCM_MST_SITE E WITH(NOLOCK)
					ON    E.DIVISION_ID = @v_division_id
					AND   ISNULL(E.COMPANY_ID, '')  = @v_company_id
					AND   E.DIVISION_ID = P.DIVISION_ID
					AND   E.SCM_SITE_ID = P.FROM_SITE
			WHERE  P.MEASURE  = 'INSP_WIP'
			;


			------------------------------------------------------------------------------------------------------------- 
			--2-13. [S]POSTP_PLAN (Post Process Plan) 조정(예외사항) : 
			--  [C20191205-000173] 
			--   내용 " 초소형셀 MCSS20253-A2 -> MCSS20253-A4로 투입되므로 재고 차감을 위해POSTP_PLAN으로 적용
			--     : MCSS20253-A4   PROD_PLAN 수량 --> MCSS20253-A2  PPOST_PLAN으로 수량으로 적용  
			--   사유 : 소형 사업부 초소형 모델의 경우 BOM상  MCSS20253-A4(1) -MCSS20253-A2(1)의 소요량이 전개되나
			--          , 현재 FP에서 별도 계획을 수립하고 있지 않으므로(전용라인 1모델 생산) 모자 관계의 생산계획을 I/F 받는데 한계가 있어예외적으로 적용함  
			------------------------------------------------------------------------------------------------------------- 
			DELETE A
			FROM  #tmp_SSP_ANL_SHIP_PLAN_40 A WITH(NOLOCK)
			      
					JOIN SCM_MST_SITE E WITH(NOLOCK)
					ON    E.DIVISION_ID = @v_division_id
					AND   ISNULL(E.COMPANY_ID, '')  = @v_company_id
					AND   E.DIVISION_ID = A.DIVISION_ID
					AND   E.SCM_SITE_ID = A.FROM_SITE
			WHERE A.ITEM_ID = 'MCSS20253-A2'
			AND   A.MEASURE  = 'POSTP_PLAN'
			;

			INSERT INTO #tmp_SSP_ANL_SHIP_PLAN_40
				(
				 DIVISION_ID  	     
				,PLAN_START_YYYYMMDD 
				,PLAN_TYPE	         
				,SEQ	             
				,ITEM_ID	         
				,FROM_SITE	         
				,TO_SITE	         
				,MEASURE	         
				,YYYYMMDD	         
				,BOD_ID	           
				,QTY	             
				,ROUTE_ID	         
				,INCOTERMS         
				,TRANSPORT_MODE    
				,BIZ_TYPE	         
				,PROJECT_CODE	     
				,FCST_TYPE	       
				,FCST_ETD_DATE	
				,FCST_ETA_DATE   
				,ETD_DATE	         
				,ETA_DATE
				,CONFIRM_ID
				,ORIGIN_FROM_DIVISION_ID
				,ORIGIN_TO_DIVISION_ID 
				,ATTRIBUTE1     					     
				)
			SELECT P.DIVISION_ID  	     
				,P.PLAN_START_YYYYMMDD 
				,P.PLAN_TYPE	         
				,P.SEQ	             
				,'MCSS20253-A2'	         
				,P.FROM_SITE	         
				,P.TO_SITE	         
				,'POSTP_PLAN' AS MEASURE	         
				,P.YYYYMMDD	         
				,P.BOD_ID	           
				,P.QTY             
				,P.ROUTE_ID	         
				,P.INCOTERMS         
				,P.TRANSPORT_MODE    
				,P.BIZ_TYPE	         
				,P.PROJECT_CODE	     
				,P.FCST_TYPE	       
				,P.FCST_ETD_DATE	
				,P.FCST_ETA_DATE   
				,P.ETD_DATE	         
				,P.ETA_DATE	
				,P.CONFIRM_ID
				,P.DIVISION_ID --ORIGIN_FROM_DIVISION_ID
				,P.DIVISION_ID --ORIGIN_TO_DIVISION_ID
				,P.ATTRIBUTE1
			FROM  #tmp_SSP_ANL_SHIP_PLAN_40 P WITH (NOLOCK) 
					JOIN SCM_MST_SITE E WITH(NOLOCK)
					ON    E.DIVISION_ID = @v_division_id
					AND   ISNULL(E.COMPANY_ID, '')  = @v_company_id
					AND   E.DIVISION_ID = P.DIVISION_ID
					AND   E.SCM_SITE_ID = P.FROM_SITE
			WHERE ITEM_ID = 'MCSS20253-A4'
			AND   MEASURE  = 'PROD_PLAN'
			;

			------------------------------------------------------------------------------------------------------------- 
			--12-14.[I]WH_STOC(Warehouse Stock) 
			--      당일 WH_STOC = OWMS 가용수량 
			--      익일 WH_STOC = 전일 WH_STOC + 전일WH_IN - 전일SHIP_CONFIRM - 전일POSTP_PLAN - 전일 MES_FCS_HOLD수량(MES/FCS) + 전일 MES_FCS_RELEASE수량(MES/FCS 사용자설정)
			------------------------------------------------------------------------------------------------------------- 
			WITH BOH AS (
			             SELECT A.DIVISION_ID
							  , A.PLAN_START_YYYYMMDD
							  , A.PLAN_TYPE
							  , A.SEQ
							  , A.FROM_SITE
							  , A.ITEM_ID
							  , SUM(A.QTY)   AS QTY
						 FROM   (
								SELECT A.DIVISION_ID
									 , A.PLAN_START_YYYYMMDD
									 , A.PLAN_TYPE
									 , A.SEQ
									 , A.FROM_SITE
									 , A.ITEM_ID
									 , (CASE WHEN ISNULL(C.SEGMENT3, '-') = 'P' THEN SUM(A.LOT_QTY_MES) ELSE 0 END) AS QTY
								FROM   SSP_ANL_MES_FCS_STOCK_40_C  A WITH(NOLOCK)
									   LEFT OUTER JOIN SCP_MST_FINAL_ITEM  B WITH(NOLOCK)
									   ON   B.DIVISION_ID = A.DIVISION_ID
									   AND  B.ITEM_ID = A.ITEM_ID
									   LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH(NOLOCK) 
									   ON  C.LOOKUP_TYPE = 'CELL_TYPE_CODE' 
									   AND C.VALID_YN    = 'Y' 
									   AND C.SEGMENT1    = B.CELL_TYPE_GROUP_CODE
								WHERE  1 = 1
								AND    A.DIVISION_ID         = @v_division_id
								AND    A.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
								AND    A.PLAN_TYPE           = @v_plan_type
								AND    A.SEQ                 = @v_seq
								AND    A.AVAILABLE_YN <> 'N'
								AND    ISNULL(A.CHANGE_STATUS, '') <> 'D'
								--AND    ITEM_ID = 'MDP303994C11'
								GROUP BY A.DIVISION_ID
									 , A.PLAN_START_YYYYMMDD
									 , A.PLAN_TYPE
									 , A.SEQ
									 , A.FROM_SITE
									 , A.ITEM_ID
									 , C.SEGMENT3

								UNION ALL

								SELECT A.DIVISION_ID
									 , A.PLAN_START_YYYYMMDD
									 , A.PLAN_TYPE
									 , A.SEQ
									 , A.FROM_SITE
									 , A.ITEM_ID
									 , SUM(A.AVAILABLE_QTY) AS QTY
								FROM   SSP_ANL_OWMS_STOCK_C  A WITH(NOLOCK)
								WHERE  1 = 1
								AND    A.DIVISION_ID         = @v_division_id
								AND    A.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
								AND    A.PLAN_TYPE           = @v_plan_type
								AND    A.SEQ                 = @v_seq
								GROUP BY A.DIVISION_ID
									 , A.PLAN_START_YYYYMMDD
									 , A.PLAN_TYPE
									 , A.SEQ
									 , A.FROM_SITE
									 , A.ITEM_ID

								UNION ALL

								--STORAGE ID : B100(TCO Ass.BS D/F), R100(TCO Ass.SW D/F) 외주 재고
								SELECT T.DIVISION_ID  	        AS DIVISION_ID   
								,	   T.PLAN_START_YYYYMMDD    AS PLAN_START_YYYYMMDD
								,      T.PLAN_TYPE	            AS PLAN_TYPE
								,      T.SEQ 	                AS SEQ
								,      T.SCM_SITE_ID            AS FROM_SITE  
								,      T.ITEM_ID	            AS ITEM_ID   
								,      ROUND(SUM(T.QTY),0) AS  QTY	  
								FROM   SSP_ANL_TCO_STOCK_C T WITH(NOLOCK)  
								WHERE  1 = 1
								AND    T.DIVISION_ID         = @v_division_id
								AND    T.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
								AND    T.PLAN_TYPE           = @v_plan_type
								AND    T.SEQ                 = @v_seq
								GROUP BY 
										T.DIVISION_ID 
								,     T.PLAN_START_YYYYMMDD
								,     T.PLAN_TYPE
								,     T.SEQ
								,     T.ITEM_ID
								,     T.SCM_SITE_ID

								) A
								JOIN SCM_MST_SITE E WITH(NOLOCK)
								ON    E.DIVISION_ID = @v_division_id
								AND   ISNULL(E.COMPANY_ID, '')  = @v_company_id
								AND   E.DIVISION_ID = A.DIVISION_ID
								AND   E.SCM_SITE_ID = A.FROM_SITE
						 WHERE  1 = 1
						 GROUP BY A.DIVISION_ID
							  , A.PLAN_START_YYYYMMDD
							  , A.PLAN_TYPE
							  , A.SEQ
							  , A.FROM_SITE
							  , A.ITEM_ID

							---- 수행시 최신 시점의 OWMS 재고정보 + B100(TCO Ass.BS D/F), R100(TCO Ass.SW D/F) 재고 수량 적용 (<--SSP_ANL_TCO_STOCK_C)
							--SELECT O.DIVISION_ID  	        AS DIVISION_ID   
							--,	   O.PLAN_START_YYYYMMDD    AS PLAN_START_YYYYMMDD
							--,      O.PLAN_TYPE	            AS PLAN_TYPE
							--,      O.SEQ 	                AS SEQ
							--,      O.ITEM_ID	            AS ITEM_ID   
							--,      FROM_SITE                AS FROM_SITE  
							--,      ROUND(SUM(O.QTY),0)      AS  QTY	  
							--FROM   SSP_ANL_WH_STOCK_V O WITH(NOLOCK) --SSP_ANL_WH_STOCK_V O WITH(NOLOCK)  
							--WHERE  1=1 
							--AND    O.DIVISION_ID         = @v_division_id
							--AND    O.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
							--AND    O.PLAN_TYPE           = @v_plan_type
							--AND    O.SEQ                 = @v_seq
							--GROUP BY 
							--	  O.DIVISION_ID 
							--,     O.PLAN_START_YYYYMMDD
							--,     O.PLAN_TYPE
							--,     O.SEQ
							--,     O.ITEM_ID
							--,     O.FROM_SITE  
						),  
				Z AS (
					SELECT DISTINCT  
							P.DIVISION_ID  	     
					,      P.PLAN_START_YYYYMMDD 
					,      P.PLAN_TYPE	         
					,      P.SEQ	             
					,      P.ITEM_ID	         
					,      P.FROM_SITE  
					,      P.YYYYMMDD     
					FROM  #tmp_SSP_ANL_SHIP_PLAN_40 P WITH(NOLOCK ) 
							JOIN SCM_MST_SITE E WITH(NOLOCK)
							ON    E.DIVISION_ID = @v_division_id
							AND   ISNULL(E.COMPANY_ID, '')  = @v_company_id
							AND   E.DIVISION_ID = P.DIVISION_ID
							AND   E.SCM_SITE_ID = P.FROM_SITE
					WHERE 1=1 
					AND P.DIVISION_ID         = @v_division_id         -- '81'
					AND P.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd -- '20180429' 
					AND P.PLAN_TYPE           = @v_plan_type           -- 'SP'
					AND P.SEQ                 = @v_seq                 -- '3'
					AND P.MEASURE IN ('SHIP_CONFIRM', 'WH_IN', 'POSTP_PLAN', 'MES_FCS_HOLD', 'MES_FCS_RELEASE')
					AND P.YYYYMMDD            >= @v_data_start_yyyymmdd
					GROUP BY P.DIVISION_ID  	     
					,        P.PLAN_START_YYYYMMDD 
					,        P.PLAN_TYPE	         
					,        P.SEQ	             
					,        P.ITEM_ID	         
					,        P.FROM_SITE  
					,        P.YYYYMMDD 
					)  

			INSERT INTO #tmp_SSP_ANL_SHIP_PLAN_40
				(
				 DIVISION_ID  	     
				,PLAN_START_YYYYMMDD 
				,PLAN_TYPE	         
				,SEQ	             
				,ITEM_ID	         
				,FROM_SITE	         
				,TO_SITE	         
				,MEASURE	         
				,YYYYMMDD	         
				,BOD_ID	           
				,QTY	             
				,INCOTERMS         
				,TRANSPORT_MODE    
				,PROJECT_CODE	     
				,FCST_TYPE
				,CONFIRM_ID	      
				,ORIGIN_FROM_DIVISION_ID
				,ORIGIN_TO_DIVISION_ID -- ORIGIN_TO_DIVISION_ID					 
				)
			SELECT   
					 Z.DIVISION_ID            
					,Z.PLAN_START_YYYYMMDD            
					,Z.PLAN_TYPE            
					,Z.SEQ            
					,Z.ITEM_ID            
					,Z.FROM_SITE    
					,'-'   AS TO_SITE         
					,'WH_STOCK' AS MEASURE
					,Z.YYYYMMDD  
					,'-'   AS BOD_ID
					,-- 전일 WH_IN , 전일 SHIP_CONFIRM
					 (
					 CASE WHEN CONVERT(NVARCHAR(8), GETDATE(), 112) < Z.YYYYMMDD THEN
						  --CASE WHEN SUBSTRING(Z.ITEM_ID, 1, 3) = 'MCP' OR SUBSTRING(Z.ITEM_ID, 1, 3) = 'MDP' OR SUBSTRING(Z.ITEM_ID, 1, 3) = 'MIP' OR SUBSTRING(Z.ITEM_ID, 1, 3) = 'MTP' THEN 
						  CASE WHEN ( ISNULL(B.SEGMENT3, '-') = 'P' ) THEN
						            (
									SELECT  
										ISNULL( SUM(CASE X.MEASURE WHEN 'SHIP_CONFIRM'    THEN -1 * ISNULL(X.QTY,0)  
																   WHEN 'POSTP_PLAN'      THEN -1 * ISNULL(X.QTY,0) 
																   WHEN 'MES_FCS_HOLD'    THEN -1 * ISNULL(X.QTY,0) 
																   WHEN 'WH_IN'           THEN      ISNULL(X.QTY,0)  
																   WHEN 'MES_FCS_RELEASE' THEN      ISNULL(X.QTY,0)  
														ELSE 0.0  
											END),0)   
									FROM #tmp_SSP_ANL_SHIP_PLAN_40 X WITH(NOLOCK)     
									WHERE 1=1  
									AND X.DIVISION_ID          = Z.DIVISION_ID  
									AND X.PLAN_START_YYYYMMDD  = Z.PLAN_START_YYYYMMDD           
									AND X.PLAN_TYPE            = Z.PLAN_TYPE  
									AND X.SEQ                  = Z.SEQ  
									AND X.ITEM_ID              = Z.ITEM_ID  
									AND X.FROM_SITE            = Z.FROM_SITE  
									AND X.MEASURE              IN ('SHIP_CONFIRM', 'WH_IN', 'POSTP_PLAN', 'MES_FCS_HOLD', 'MES_FCS_RELEASE')
									AND X.YYYYMMDD             > @v_data_start_yyyymmdd
									AND X.YYYYMMDD             < Z.YYYYMMDD  
									)
						  ELSE
						            (
									SELECT  
										ISNULL( SUM(CASE X.MEASURE WHEN 'SHIP_CONFIRM'    THEN -1 * ISNULL(X.QTY,0)  
																   WHEN 'POSTP_PLAN'      THEN -1 * ISNULL(X.QTY,0) 
																   WHEN 'MES_FCS_HOLD'    THEN -1 * ISNULL(X.QTY,0) 
																   WHEN 'WH_IN'           THEN      ISNULL(X.QTY,0)  
																   WHEN 'MES_FCS_RELEASE' THEN      ISNULL(X.QTY,0)  
														ELSE 0.0  
											END),0)   
									FROM #tmp_SSP_ANL_SHIP_PLAN_40 X WITH(NOLOCK)     
									WHERE 1=1  
									AND X.DIVISION_ID          = Z.DIVISION_ID  
									AND X.PLAN_START_YYYYMMDD  = Z.PLAN_START_YYYYMMDD           
									AND X.PLAN_TYPE            = Z.PLAN_TYPE  
									AND X.SEQ                  = Z.SEQ  
									AND X.ITEM_ID              = Z.ITEM_ID  
									AND X.FROM_SITE            = Z.FROM_SITE  
									AND X.MEASURE              IN ('SHIP_CONFIRM', 'WH_IN', 'POSTP_PLAN', 'MES_FCS_HOLD', 'MES_FCS_RELEASE')
									AND X.YYYYMMDD             > @v_data_start_yyyymmdd
									AND X.YYYYMMDD             < Z.YYYYMMDD  
									)
						  END
					 ELSE  0
					 END
					 )

						-- 당일 OWMS 재고 
						    + ISNULL(BOH.QTY,0)

						-- 2020.09.09 KBK : 'DCP', 'MDP', 'MIP', 'MTP' 처리
						    - (
							  CASE WHEN CONVERT(NVARCHAR(8), GETDATE(), 112) <= Z.YYYYMMDD THEN
							       CASE WHEN ISNULL(B.SEGMENT3, '-') = 'P' THEN ISNULL(B.WH_IN_QTY2, 0)
								   ELSE 0 END
							  ELSE 0 END
							  )

						-- HOLD 재고 
							-   ISNULL((SELECT SUM(H.HOLD_QTY )  -- HOLD재고 제외
										FROM  SSP_ANL_HOLD_STOCK H WITH(NOLOCK) -- #tmp_SSP_ANL_HOLD_STOCK H WITH(NOLOCK) 
										,     SCM_SYS_CALENDAR_M    C WITH(NOLOCK)
										WHERE H.DIVISION_ID         = @v_division_id 
										AND   H.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
										AND   H.PLAN_TYPE           = @v_plan_type
										AND   H.SEQ                 = @v_seq
										AND   C.BASIS_YYYYMMDD     >= H.HOLD_YYYYMMDD
										AND   C.BASIS_YYYYMMDD     <= H.RELEASE_YYYYMMDD
										AND   C.BASIS_YYYYMMDD     >  @v_data_start_yyyymmdd
										AND   C.BASIS_YYYYMMDD     <  @v_data_end_yyyymmdd
										AND   H.DIVISION_ID         = Z.DIVISION_ID 
										AND   H.FROM_SITE           = Z.FROM_SITE
										AND   H.ITEM_ID             = Z.ITEM_ID 
										AND   C.BASIS_YYYYMMDD      = Z.YYYYMMDD	
   										GROUP BY H.DIVISION_ID 
									,        H.FROM_SITE
									,        H.ITEM_ID 
									,        C.BASIS_YYYYMMDD ) ,0)					  AS QTY
	      --------------------------------------------------------------------------------------------------------------------------------------
					,'-'   AS INCOTERMS         
					,'-'   AS TRANSPORT_MODE    
					,'-'   AS PROJECT_CODE	
					,'-'   AS FCST_TYPE	
					,'-'   AS CONFIRM_ID	
					,Z.DIVISION_ID
					,Z.DIVISION_ID  --ORIGIN_TO_DIVISION_ID	
			FROM Z WITH(NOLOCK)   
			LEFT OUTER JOIN BOH WITH(NOLOCK) 
							ON Z.DIVISION_ID         = BOH.DIVISION_ID  
						AND Z.PLAN_START_YYYYMMDD = BOH.PLAN_START_YYYYMMDD  
						AND Z.PLAN_TYPE           = BOH.PLAN_TYPE  
						AND Z.SEQ                 = BOH.SEQ  
						AND Z.ITEM_ID             = BOH.ITEM_ID  
						AND Z.FROM_SITE           = BOH.FROM_SITE  
				-- 2020.09.09 KBK 
				LEFT OUTER JOIN (
								SELECT A.DIVISION_ID
										, A.PLAN_START_YYYYMMDD
										, A.PLAN_TYPE
										, A.SEQ
										, A.ITEM_ID
										, A.FROM_SITE
										--, A.TO_SITE
										, SUM(A.QTY)   AS WH_IN_QTY2
										, C.SEGMENT3
								FROM   #tmp_SSP_ANL_SHIP_PLAN_40  A WITH(NOLOCK)
									   LEFT OUTER JOIN SCP_MST_FINAL_ITEM  B WITH(NOLOCK)
									   ON   B.DIVISION_ID = A.DIVISION_ID
									   AND  B.ITEM_ID = A.ITEM_ID
									   JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH(NOLOCK) 
									   ON  C.LOOKUP_TYPE = 'CELL_TYPE_CODE' 
									   AND C.VALID_YN    = 'Y' 
									   AND C.SEGMENT3    = 'P'
									   AND C.SEGMENT1    = B.CELL_TYPE_GROUP_CODE
									   JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK) 
									   ON  D.LOOKUP_TYPE = 'POUCH_WH_IN_DAY' 
									   AND D.SEGMENT1    = SUBSTRING(A.ITEM_ID, 1, 3)
									   AND D.VALID_YN    = 'Y' 
								WHERE  1 = 1
								AND    A.DIVISION_ID         = @v_division_id
								AND    A.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
								AND    A.PLAN_TYPE           = @v_plan_type
								AND    A.SEQ                 = @v_seq
								AND    A.MEASURE = 'WH_IN'
								AND    A.YYYYMMDD > @v_data_start_yyyymmdd
								AND    A.YYYYMMDD <= CONVERT(VARCHAR, DATEADD(D, CONVERT(INT, D.SEGMENT2), CONVERT(DATETIME, @v_data_start_yyyymmdd ,112)) ,112)
								GROUP BY A.DIVISION_ID
										, A.PLAN_START_YYYYMMDD
										, A.PLAN_TYPE
										, A.SEQ
										, A.ITEM_ID
										, A.FROM_SITE
										--, A.TO_SITE
										, C.SEGMENT3
								)  B
				ON   B.DIVISION_ID = Z.DIVISION_ID
				AND  B.PLAN_START_YYYYMMDD = Z.PLAN_START_YYYYMMDD
				AND  B.PLAN_TYPE = Z.PLAN_TYPE
				AND  B.SEQ = Z.SEQ
				AND  B.ITEM_ID = Z.ITEM_ID
				AND  B.FROM_SITE = Z.FROM_SITE

			WHERE 1=1 
			;


			------------------------------------------------------------------------------------------------------------- 
			--2-15. [I]BALANCE(Balance)              : 당일 Balance :  당일Warehouse Stock - 당일 Shipment Confirm - 당일 Post Process Plan 
			------------------------------------------------------------------------------------------------------------- 
			INSERT INTO #tmp_SSP_ANL_SHIP_PLAN_40
				(
				 DIVISION_ID  	     
				,PLAN_START_YYYYMMDD 
				,PLAN_TYPE	         
				,SEQ	             
				,ITEM_ID	         
				,FROM_SITE	         
				,TO_SITE	         
				,MEASURE	         
				,YYYYMMDD	         
				,BOD_ID	           
				,QTY	             
				,INCOTERMS         
				,TRANSPORT_MODE    
				,PROJECT_CODE	     
				,FCST_TYPE	
				,CONFIRM_ID      
				,ORIGIN_FROM_DIVISION_ID
				,ORIGIN_TO_DIVISION_ID				 
				)
			SELECT B.DIVISION_ID 
			,      B.PLAN_START_YYYYMMDD 
			,      B.PLAN_TYPE	         
			,      B.SEQ	             
			,      B.ITEM_ID	         
			,      B.FROM_SITE	         
			,      B.TO_SITE	         
			,      'BALANCE'  AS MEASURE	         
			,      B.YYYYMMDD	         
			,      B.BOD_ID	           
			,      B.QTY - (SELECT SUM(C.QTY) 
							FROM #tmp_SSP_ANL_SHIP_PLAN_40 C WITH(NOLOCK) 
							WHERE 1=1 
							AND B.DIVISION_ID          = C.DIVISION_ID        
							AND B.PLAN_START_YYYYMMDD  = C.PLAN_START_YYYYMMDD
							AND B.PLAN_TYPE            = C.PLAN_TYPE          
							AND B.SEQ                  = C.SEQ                
							AND B.ITEM_ID              = C.ITEM_ID             
							AND B.FROM_SITE            = C.FROM_SITE           
							AND B.YYYYMMDD             = C.YYYYMMDD 
							AND C.MEASURE              IN ('SHIP_CONFIRM' ,'POSTP_PLAN')
							GROUP BY C.DIVISION_ID        							
									,C.PLAN_START_YYYYMMDD
									,C.PLAN_TYPE          
									,C.SEQ                
									,C.ITEM_ID            
									,C.FROM_SITE          
									,C.YYYYMMDD ) AS QTY 		             
			,      B.INCOTERMS         
			,      B.TRANSPORT_MODE    
			,      B.PROJECT_CODE	     
			,      B.FCST_TYPE	
			,      '-' AS CONFIRM_ID 
			,      B.DIVISION_ID -- ORIGIN_FROM_DIVISION_ID
			,      B.DIVISION_ID -- ORIGIN_TO_DIVISION_ID			 
			FROM #tmp_SSP_ANL_SHIP_PLAN_40 B WITH(NOLOCK) 
					JOIN SCM_MST_SITE E WITH(NOLOCK)
					ON    E.DIVISION_ID = @v_division_id
					AND   ISNULL(E.COMPANY_ID, '')  = @v_company_id
					AND   E.DIVISION_ID = B.DIVISION_ID
					AND   E.SCM_SITE_ID = B.FROM_SITE
			WHERE 1=1 
			AND B.DIVISION_ID         = @v_division_id          -- '81'
			AND B.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd  -- '20180429'  
			AND B.PLAN_TYPE           = @v_plan_type            -- 'SP' 
			AND B.SEQ                 = @v_seq                  -- '3'
			AND B.MEASURE = 'WH_STOCK'       
			;

 		------------------------------------------------------------------------------------------------------------- 
		--3. 최종 SSP_ANL_SHIP_PLAN_40 생성 
		-------------------------------------------------------------------------------------------------------------
        DELETE A
		FROM   SSP_ANL_SHIP_PLAN_40  A WITH(NOLOCK)
				JOIN SCM_MST_SITE E WITH(NOLOCK)
				ON    E.DIVISION_ID = @v_division_id
				AND   ISNULL(E.COMPANY_ID, '')  = @v_company_id
				AND   E.DIVISION_ID = A.DIVISION_ID
				AND   E.SCM_SITE_ID = A.FROM_SITE
        WHERE  A.DIVISION_ID         = @v_division_id 
        AND    A.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd 
        AND    A.PLAN_TYPE           = @v_plan_type 
		AND    A.SEQ                 = @v_seq
        ;
		
        INSERT INTO /* PR_SSP_ANL_SHIP_PLAN_40 */ dbo.SSP_ANL_SHIP_PLAN_40
                (
				 DIVISION_ID
				,PLAN_START_YYYYMMDD
				,PLAN_TYPE
				,SEQ
				,ITEM_ID
				,FROM_SITE
				,TO_SITE
				,MEASURE
				,YYYYMMDD
				,BOD_ID
				,QTY
				,ROUTE_ID
				,INCOTERMS
				,TRANSPORT_MODE
				,BIZ_TYPE
				,PROJECT_CODE
				,FCST_TYPE
				,FCST_ETD_DATE
				,FCST_ETA_DATE
				,ETD_DATE
				,ETA_DATE
				,CONFIRM_FLAG
				,CONFIRM_ID
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
				,ORIGIN_FROM_DIVISION_ID	
				,ORIGIN_TO_DIVISION_ID	
				,ATTRIBUTE1 -- PROD_DATE
				,ATTRIBUTE2 -- REQUESTOR
				,ATTRIBUTE3 -- Description : Prod Qty(MASS), oWMS재고수량 
				,ATTRIBUTE4 -- Prod Qty(MASS)	
				,ATTRIBUTE5 -- Prod Qty(ALL)
				,ATTRIBUTE6 -- oWMS재고수량									  	
				,ATTRIBUTE10 -- COMPANY_ID
                )
		SELECT DISTINCT 
			T.DIVISION_ID
			,T.PLAN_START_YYYYMMDD
			,T.PLAN_TYPE
			,T.SEQ
			,T.ITEM_ID
			,T.FROM_SITE
			,T.TO_SITE
			,T.MEASURE
			,T.YYYYMMDD
			,T.BOD_ID			
			,T.QTY
			,T.ROUTE_ID
			,T.INCOTERMS
			,T.TRANSPORT_MODE
			,V.OPERATION_GROUP AS BIZ_TYPE 
			,T.PROJECT_CODE
			,T.FCST_TYPE
			,T.FCST_ETD_DATE
			,T.FCST_ETA_DATE
			,T.ETD_DATE
			,T.ETA_DATE
			,CASE WHEN T.CONFIRM_ID LIKE 'C%' THEN 'Y' ELSE 'N' END AS CONFIRM_FLAG
			,ISNULL(T.CONFIRM_ID, '-')  AS CONFIRM_ID
			,@v_batch_user AS CREATED_BY
			,GETDATE()     AS CREATION_DATE
			,@v_batch_user AS LAST_UPDATED_BY
			,GETDATE()     AS LAST_UPDATED_BY
			,T.DIVISION_ID --ORIGIN_FROM_DIVISION_ID
			,T.DIVISION_ID --ORIGIN_TO_DIVISION_ID
			,T.ATTRIBUTE1  -- PROD_DATE
			,T.ATTRIBUTE2  -- REQUESTOR		
			,T.ATTRIBUTE3  -- Description : Prod Qty(MASS), oWMS재고수량 
			,T.ATTRIBUTE4  -- Prod Qty(MASS)	
			,T.ATTRIBUTE5  -- Prod Qty(ALL)
			,T.ATTRIBUTE6  -- oWMS재고수량
			,E.COMPANY_ID AS ATTRIBUTE10
		FROM #tmp_SSP_ANL_SHIP_PLAN_40 T WITH (NOLOCK)
			JOIN SCP_MST_FINAL_ITEM V 
			ON V.ITEM_ID = T.ITEM_ID 
			AND V.DIVISION_ID = T.DIVISION_ID

			JOIN SCM_MST_SITE E WITH(NOLOCK)
			ON    E.DIVISION_ID = @v_division_id
			AND   ISNULL(E.COMPANY_ID, '')  = @v_company_id
			AND   E.DIVISION_ID = T.DIVISION_ID
			AND   E.SCM_SITE_ID = T.FROM_SITE
		WHERE 1=1
		AND   ISNULL(E.COMPANY_ID, '')  = @v_company_id		
        ;

		------------------------------------------------------------------------------------------------------------- 
		--4 PLAN 결과 UPDATE PLAN Start status Plan Detail Update  status = 1 
		-------------------------------------------------------------------------------------------------------------
        UPDATE SCM_MST_PLAN_DETAIL
        SET    PLAN_STATUS          = '1' -- 정상 종료
		,      LAST_UPDATE_DATE     = GETDATE()
		,      INPUT_END_DATE       = GETDATE()
		,      PLAN_END_DATE        = GETDATE()
		,      PLAN_OUTPUT_END_DATE = GETDATE()
		,      OUTPUT_END_DATE      = GETDATE()
		,      ANL_END_DATE         = GETDATE()
        WHERE  DIVISION_ID = @v_division_id
        AND    PLAN_ID     = @v_plan_id
        AND    PLAN_SEQ    = @v_seq       
        AND    PLAN_TYPE   = @v_plan_type
		;

		------------------------------------------------------------------------------------------------------------- 
		--4 SMS 전송 : Daily Plan  END (51)
		--50 Daily Plan Start 
		--51 Daily Plan End 
		--52 Daily Plan Error 
		-------------------------------------------------------------------------------------------------------------
		--SET @v_sms_desc = @v_division_id + ' ' + @v_company_id +':'+@v_sms_req+':SSP';
		--EXEC SCM_ADM_SMS_SEND_BATCH 51, @v_sms_desc;

        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------
        IF @@TRANCOUNT > 0
          BEGIN
            COMMIT TRAN TX_SH;
          END;       

        -- TXN LOG
        SET @v_log_type = N'TXN';    -- ▶ 로그타입
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
      IF @@TRANCOUNT > 0
        BEGIN
          ROLLBACK TRAN TX_SH
        END;
      
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
		------------------------------------------------------------------------------------------------------------- 
		-- PLAN Start status Plan Detail Update  status = -1 
		-------------------------------------------------------------------------------------------------------------
        UPDATE SCM_MST_PLAN_DETAIL
        SET    PLAN_STATUS          = '-1' -- 에러
		,      LAST_UPDATE_DATE     = GETDATE()
		,      INPUT_END_DATE       = GETDATE()
		,      PLAN_END_DATE        = GETDATE()
		,      PLAN_OUTPUT_END_DATE = GETDATE()
		,      OUTPUT_END_DATE      = GETDATE()
		,      ANL_END_DATE         = GETDATE()
        WHERE  DIVISION_ID = @v_division_id
        AND    PLAN_ID     = @v_plan_id
        AND    PLAN_SEQ    = @v_seq       
        AND    PLAN_TYPE   = @v_plan_type
		;
		-----------------------------------------------------------
		-- SMS 전송 : Daily Plan  ERROR (52)
		--50 Daily Plan Start 
		--51 Daily Plan End 
		--52 Daily Plan Error 
		-----------------------------------------------------------
        SET @v_sms_desc = @v_division_id + ' ' + @v_company_id +':'+@v_sms_req+':SSP';
		EXEC SCM_ADM_SMS_SEND_BATCH 52, @v_sms_desc;
 
      return -1
    END CATCH;

     --임시 운영반영시에 주석처리 할것.
     SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' + 
                          REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) 


    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description = N'['+@v_plan_id+'][' + @v_exec_time + ']';  
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
