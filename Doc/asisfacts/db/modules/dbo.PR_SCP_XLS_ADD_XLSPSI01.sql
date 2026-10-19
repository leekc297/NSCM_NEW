

/*
 * Program ID   : PR_SCP_XLS_ADD_XLSPSI01
 * Description  : SCP SIMULATION SAVE
 * OutTable     :
 * Execute      : 
 	-- ACEN4069I-A1-110
	EXEC PR_SCP_XLS_ADD_XLSPSI01 'luckydohan'  ,'81','20230731','PR','3','AMFMCC727-A1','SHIP_PLAN','2702',10,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9

	EXEC PR_SCP_XLS_ADD_XLSPSI01
		'KSK'  ,'81','20230731', 'PR','3','APFCAPHEV-B2','PACK_MODEL_CHANGE'
		,'2718'
		,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N|N'

              EXEC PR_SCP_XLS_ADD_XLSPSI01        @p_USER_ID             ='KSK'
                                                 ,@p_division_id         = '81'
                                                 ,@p_PLAN_START_YYYYMMDD = '20230731'
                                                 ,@p_PLAN_TYPE           ='PR'
                                                 ,@p_SEQ                 ='3'
                                                 ,@p_item_id             ='APFCAPHEV-B2'
                                                 ,@p_measure             ='PACK_MODEL_CHANGE'
                                                 ,@p_xls_key1            ='5849'
                                                 ,@p_WQTY01 INT = 3  ,@p_WQTY02  INT = 0.0 ,@p_WQTY03  INT = 0.0 ,@p_WQTY04  INT = 0.0 ,@p_WQTY05  INT = 0.0
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
 * 2021.05.24   KSW            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응
 * 2022.03.23	KSW	           GM JV 반영
 * 2022.08.17   KSW            중장기 버전 2 year 대응처리 
 * 2023.08.24	KSK		      [PJ20230692] SCM 역량 강화 위한 SCP 개선과제 이행 Phase2 (52주차 초과플랜의  SHIPMENT FG 파샬위크 SPLIT 저장로직 반영)
 * 2023.12.26	KSK		      [PJ20230692] SCM 역량 강화 위한 SCP 개선과제 이행2 ( SHIP_PLAN 및 SEMI_SHIP_PLAN 일분배 로직 시뮬레이터로 이동 및 년도별 파라미터 추가)
 * 2024.04.17	KSK		      디버그 파라미터(@p_is_debug) 추가
 */
 CREATE PROCEDURE [dbo].[PR_SCP_XLS_ADD_XLSPSI01]
( 
  @p_user_id                 VARCHAR(100)
 --,@P_GUBUN                 VARCHAR(040)       -- MEASURE  @P_GUBUN  PACK / CELL / SUPPLY 
 ,@p_division_id	          NVARCHAR(030)
 ,@p_plan_start_yyyymmdd	  NVARCHAR(008)
 ,@p_plan_type	            NVARCHAR(050)
 ,@p_seq	                  BIGINT
 ,@p_item_id	              NVARCHAR(050)
 ,@p_measure	              NVARCHAR(050)       -- MEASURE별
 ,@p_xls_key1	              NVARCHAR(200)

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

 ,@p_WQTY53 INT = 0.0 ,@p_WQTY54 INT = 0.0 ,@p_WQTY55 INT = 0.0 ,@p_WQTY56 INT = 0.0 ,@p_WQTY57 INT = 0.0
 ,@p_WQTY58 INT = 0.0 ,@p_WQTY59 INT = 0.0 ,@p_WQTY60 INT = 0.0 ,@p_WQTY61 INT = 0.0 ,@p_WQTY62 INT = 0.0
 ,@p_WQTY63 INT = 0.0 ,@p_WQTY64 INT = 0.0 ,@p_WQTY65 INT = 0.0 ,@p_WQTY66 INT = 0.0 ,@p_WQTY67 INT = 0.0
 ,@p_WQTY68 INT = 0.0 ,@p_WQTY69 INT = 0.0 ,@p_WQTY70 INT = 0.0 ,@p_WQTY71 INT = 0.0 ,@p_WQTY72 INT = 0.0
 ,@p_WQTY73 INT = 0.0 ,@p_WQTY74 INT = 0.0 ,@p_WQTY75 INT = 0.0 ,@p_WQTY76 INT = 0.0 ,@p_WQTY77 INT = 0.0
 ,@p_WQTY78 INT = 0.0 ,@p_WQTY79 INT = 0.0 ,@p_WQTY80 INT = 0.0 ,@p_WQTY81 INT = 0.0 ,@p_WQTY82 INT = 0.0
 ,@p_WQTY83 INT = 0.0 ,@p_WQTY84 INT = 0.0 ,@p_WQTY85 INT = 0.0 ,@p_WQTY86 INT = 0.0 ,@p_WQTY87 INT = 0.0
 ,@p_WQTY88 INT = 0.0 ,@p_WQTY89 INT = 0.0 ,@p_WQTY90 INT = 0.0 ,@p_WQTY91 INT = 0.0 ,@p_WQTY92 INT = 0.0
 ,@p_WQTY93 INT = 0.0 ,@p_WQTY94 INT = 0.0 ,@p_WQTY95 INT = 0.0 ,@p_WQTY96 INT = 0.0 ,@p_WQTY97 INT = 0.0
 ,@p_WQTY98  INT = 0.0 ,@p_WQTY99  INT = 0.0 ,@p_WQTY100 INT = 0.0 ,@p_WQTY101 INT = 0.0 ,@p_WQTY102 INT = 0.0
 ,@p_WQTY103 INT = 0.0 ,@p_WQTY104 INT = 0.0 

 -- 2021.04.13   KSW            출하계획(SHIP_PLAN) 저장 - 자동차 Partial Week 저장방식 추가 :: Balance(WH In) Measure 값이 0 일 경우 월요일에 입력된 수량전체를 배분한다. - start
 -- Week 플랜구간에 대한 Partial week 정보를 입력값으로 받는다. 'Y' : 시뮬레이터에서 Partial Week 경계선 다음날, 'N' : Partial Week 경계선 다음날이 아닌 경우
 , @p_partial	        NVARCHAR(240)	 = null	-- 사용하지 않으나 에러방지위해  기본값 처리(KSK, 250527)
  ,@p_dailyQty1		nvarchar(max) = '' -- 시뮬레이터에서 전송하는 1년차 일분배 정보용 파라미터(KSK, 2024-04-29)
  ,@p_dailyQty2		nvarchar(max) = '' -- 시뮬레이터에서 전송하는 2년차 일분배 정보용 파라미터(KSK, 2024-04-29)
  ,@p_is_debug				bit = 0			-- 0: RELEASE (KSK, 250417)
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
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_XLS_ADD_XLSPSI01';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);     
    DECLARE @v_table_id     NVARCHAR(150) = N'SCP_XLS_PSI_GLOBAL'; 
    DECLARE @d_event_date   DATETIME;

	-- 20231109 'PACK_MODEL_CHANGE','CELL_MODEL_CHANGE' 처리 안 함 : PI 요청	 
    IF @p_measure IN  ('PACK_MODEL_CHANGE','CELL_MODEL_CHANGE')    
      return 1 

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
                              ;
    
    
        -- 임시 실행시간 확인용                
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();                
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';     

    --PRINT @p_plan_type
    -- PLAN_TYPE이 FN일경우 수정금지 RETURN
	--[TEST]
    if @p_plan_type = 'FN'   AND @p_is_debug = 0
      return -1   

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
          FROM SCP_XLS_PSI_GLOBAL WITH (NOLOCK)
		 WHERE DIVISION_ID          = @p_division_id			-- 2022.03.23	KSW	GM JV 반영
		  ;

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


			DECLARE @rows INT;  
			DECLARE @p_create_from_yyyymmdd  NVARCHAR(0008);
			DECLARE @p_create_to_yyyymmdd    NVARCHAR(0008);

			SET @p_create_from_yyyymmdd = @p_plan_start_yyyymmdd;
			SET @p_create_to_yyyymmdd   = CONVERT(VARCHAR(8), DATEADD(day, 364, @p_create_from_yyyymmdd), 112);

			--  Plan End Date
			DECLARE @v_pet_date		NVARCHAR(12) = '';
			DECLARE @v_bp_flag		NVARCHAR(8) = '';
			DECLARE @v_bp_days		INT = 0;
			DECLARE @v_bp_plan_end_yyyymmdd NVARCHAR(0008) = '';

			SELECT @v_pet_date = p.horizon_end_date,
				   @v_bp_flag  = (case when DATEDIFF(DAY, p.plan_name, p.horizon_end_date) > 364 then 'Y' else 'N' end),
				   @v_bp_days  = (case when DATEDIFF(DAY, p.plan_name, p.horizon_end_date) > 364 then DATEDIFF(DAY, p.plan_name, p.horizon_end_date) - 363 else 0 end)
			FROM   dbo.scm_mst_plan p WITH(NOLOCK)
			WHERE  p.division_id = @p_division_id
			AND    p.plan_id     = (SELECT max(plan_id) FROM dbo.scm_mst_plan p WITH(NOLOCK) WHERE division_id = @p_division_id and plan_id < 9999)
			;

			-------------------------------------------------------------------------------------------------------------
            -- 1 year 저장 프로시저 실행
			-------------------------------------------------------------------------------------------------------------
			declare @p_partial2 nvarchar(240)
			set @p_partial2 =  left( @p_partial, 52 * 2 -1)
			EXEC @rows = PR_SCP_XLS_ADD_XLSPSI01_S     @p_USER_ID             = @p_user_id
                                                 ,@p_division_id         = @p_division_id
                                                 ,@p_PLAN_START_YYYYMMDD = @p_PLAN_START_YYYYMMDD
                                                 ,@p_PLAN_TYPE           = @p_PLAN_TYPE
                                                 ,@p_SEQ                 = @p_seq
                                                 ,@p_item_id             = @p_item_id
                                                 ,@p_measure             = @p_measure
                                                 ,@p_xls_key1            = @p_xls_key1
												 ,@p_create_from_yyyymmdd = @p_create_from_yyyymmdd
												 ,@p_create_to_yyyymmdd   = @p_create_to_yyyymmdd
                                                 ,@p_WQTY01 = @p_WQTY01 ,@p_WQTY02 = @p_WQTY02 ,@p_WQTY03 = @p_WQTY03 ,@p_WQTY04 = @p_WQTY04 ,@p_WQTY05 = @p_WQTY05
                                                 ,@p_WQTY06	= @p_WQTY06 ,@p_WQTY07 = @p_WQTY07 ,@p_WQTY08 = @p_WQTY08 ,@p_WQTY09 = @p_WQTY09 ,@p_WQTY10 = @p_WQTY10
                                                 ,@p_WQTY11 = @p_WQTY11 ,@p_WQTY12 = @p_WQTY12 ,@p_WQTY13 = @p_WQTY13 ,@p_WQTY14 = @p_WQTY14 ,@p_WQTY15 = @p_WQTY15
                                                 ,@p_WQTY16	= @p_WQTY16 ,@p_WQTY17 = @p_WQTY17 ,@p_WQTY18 = @p_WQTY18 ,@p_WQTY19 = @p_WQTY19 ,@p_WQTY20 = @p_WQTY20
                                                 ,@p_WQTY21 = @p_WQTY21 ,@p_WQTY22 = @p_WQTY22 ,@p_WQTY23 = @p_WQTY23 ,@p_WQTY24 = @p_WQTY24 ,@p_WQTY25 = @p_WQTY25
                                                 ,@p_WQTY26	= @p_WQTY26 ,@p_WQTY27 = @p_WQTY27 ,@p_WQTY28 = @p_WQTY28 ,@p_WQTY29 = @p_WQTY29 ,@p_WQTY30 = @p_WQTY30
                                                 ,@p_WQTY31 = @p_WQTY31 ,@p_WQTY32 = @p_WQTY32 ,@p_WQTY33 = @p_WQTY33 ,@p_WQTY34 = @p_WQTY34 ,@p_WQTY35 = @p_WQTY35
                                                 ,@p_WQTY36	= @p_WQTY36 ,@p_WQTY37 = @p_WQTY37 ,@p_WQTY38 = @p_WQTY38 ,@p_WQTY39 = @p_WQTY39 ,@p_WQTY40 = @p_WQTY40
                                                 ,@p_WQTY41 = @p_WQTY41 ,@p_WQTY42 = @p_WQTY42 ,@p_WQTY43 = @p_WQTY43 ,@p_WQTY44 = @p_WQTY44 ,@p_WQTY45 = @p_WQTY45
                                                 ,@p_WQTY46	= @p_WQTY46 ,@p_WQTY47 = @p_WQTY47 ,@p_WQTY48 = @p_WQTY48 ,@p_WQTY49 = @p_WQTY49 ,@p_WQTY50 = @p_WQTY50
                                                 ,@p_WQTY51 = @p_WQTY51 ,@p_WQTY52 = @p_WQTY52 
												 ,@p_partial = @p_partial2
												 ,@p_dailyQty = @p_dailyQty1
												  ,@p_is_debug = @p_is_debug
			;
			IF (@rows < 0)  GOTO _RETURN_ERR_CODE


			IF @v_bp_flag = 'Y'
			BEGIN
				-------------------------------------------------------------------------------------------------------------
				-- 2 year 저장 프로시저 실행
				-------------------------------------------------------------------------------------------------------------
				SET @p_create_from_yyyymmdd = @p_create_to_yyyymmdd;	--CONVERT(VARCHAR(8), DATEADD(day, 1, @p_create_to_yyyymmdd), 112);
				SET @p_create_to_yyyymmdd   = CONVERT(VARCHAR(8), DATEADD(day, 364, @p_create_from_yyyymmdd), 112);		-- 2022.08.17 중장기 버전 2 year 대응처리

				set @p_partial2 =  right( @p_partial, 52 * 2 -1)
				EXEC @rows = PR_SCP_XLS_ADD_XLSPSI01_S     @p_USER_ID             = @p_user_id
													 ,@p_division_id         = @p_division_id
													 ,@p_PLAN_START_YYYYMMDD = @p_PLAN_START_YYYYMMDD
													 ,@p_PLAN_TYPE           = @p_PLAN_TYPE
													 ,@p_SEQ                 = @p_seq
													 ,@p_item_id             = @p_item_id
													 ,@p_measure             = @p_measure
													 ,@p_xls_key1            = @p_xls_key1
													 ,@p_create_from_yyyymmdd = @p_create_from_yyyymmdd
													 ,@p_create_to_yyyymmdd   = @p_create_to_yyyymmdd
													 ,@p_WQTY01 = @p_WQTY53  ,@p_WQTY02 = @p_WQTY54  ,@p_WQTY03 = @p_WQTY55  ,@p_WQTY04 = @p_WQTY56  ,@p_WQTY05 = @p_WQTY57 
													 ,@p_WQTY06 = @p_WQTY58  ,@p_WQTY07 = @p_WQTY59  ,@p_WQTY08 = @p_WQTY60  ,@p_WQTY09 = @p_WQTY61  ,@p_WQTY10 = @p_WQTY62 
													 ,@p_WQTY11 = @p_WQTY63  ,@p_WQTY12 = @p_WQTY64  ,@p_WQTY13 = @p_WQTY65  ,@p_WQTY14 = @p_WQTY66  ,@p_WQTY15 = @p_WQTY67 
													 ,@p_WQTY16 = @p_WQTY68  ,@p_WQTY17 = @p_WQTY69  ,@p_WQTY18 = @p_WQTY70  ,@p_WQTY19 = @p_WQTY71  ,@p_WQTY20 = @p_WQTY72 
													 ,@p_WQTY21 = @p_WQTY73  ,@p_WQTY22 = @p_WQTY74  ,@p_WQTY23 = @p_WQTY75  ,@p_WQTY24 = @p_WQTY76  ,@p_WQTY25 = @p_WQTY77 
													 ,@p_WQTY26 = @p_WQTY78  ,@p_WQTY27 = @p_WQTY79  ,@p_WQTY28 = @p_WQTY80  ,@p_WQTY29 = @p_WQTY81  ,@p_WQTY30 = @p_WQTY82 
													 ,@p_WQTY31 = @p_WQTY83  ,@p_WQTY32 = @p_WQTY84  ,@p_WQTY33 = @p_WQTY85  ,@p_WQTY34 = @p_WQTY86  ,@p_WQTY35 = @p_WQTY87 
													 ,@p_WQTY36 = @p_WQTY88  ,@p_WQTY37 = @p_WQTY89  ,@p_WQTY38 = @p_WQTY90  ,@p_WQTY39 = @p_WQTY91  ,@p_WQTY40 = @p_WQTY92 
													 ,@p_WQTY41 = @p_WQTY93  ,@p_WQTY42 = @p_WQTY94  ,@p_WQTY43 = @p_WQTY95  ,@p_WQTY44 = @p_WQTY96  ,@p_WQTY45 = @p_WQTY97 
													 ,@p_WQTY46 = @p_WQTY98  ,@p_WQTY47 = @p_WQTY99  ,@p_WQTY48 = @p_WQTY100 ,@p_WQTY49 = @p_WQTY101 ,@p_WQTY50 = @p_WQTY102
													 ,@p_WQTY51 = @p_WQTY103 ,@p_WQTY52 = @p_WQTY104
													 ,@p_partial = @p_partial2
													 ,@p_dailyQty = @p_dailyQty2
													 ,@p_is_debug = @p_is_debug
				;
				IF (@rows < 0)  GOTO _RETURN_ERR_CODE
			END


		-- 2021.03.17   KSW            temp table 일괄 drop 스크립트 추가 - start
		IF OBJECT_ID('tempdb..#SCM_MST_SITE') IS NOT NULL	
						  DROP TABLE #SCM_MST_SITE;

		IF OBJECT_ID('tempdb..#DAY_SCP_XLS_PSI_GLOBAL') IS NOT NULL	
						  DROP TABLE #DAY_SCP_XLS_PSI_GLOBAL;

		IF OBJECT_ID('tempdb..#SCP_XLS_PSI_GLOBAL_ORG') IS NOT NULL	
						  DROP TABLE #SCP_XLS_PSI_GLOBAL_ORG;

		IF OBJECT_ID('tempdb..#SCP_ANL_SHIPMENT_PLAN_FG') IS NOT NULL	
						  DROP TABLE #SCP_ANL_SHIPMENT_PLAN_FG;

		IF OBJECT_ID('tempdb..#SCP_ANL_SHIPMENT_PLAN_SEMI') IS NOT NULL	
						  DROP TABLE #SCP_ANL_SHIPMENT_PLAN_SEMI;

		IF OBJECT_ID('tempdb..#SCP_ANL_PRODUCTION_PLAN') IS NOT NULL	
						  DROP TABLE #SCP_ANL_PRODUCTION_PLAN;

		IF OBJECT_ID('tempdb..#SCP_XLS_PSI_GLOBAL_MODIFY') IS NOT NULL	
						  DROP TABLE #SCP_XLS_PSI_GLOBAL_MODIFY;

		IF OBJECT_ID('tempdb..#LINE_WORKINGTIME_BY_LOSS') IS NOT NULL      
						  DROP TABLE #LINE_WORKINGTIME_BY_LOSS;

		IF OBJECT_ID('tempdb..#LineLoad') IS NOT NULL      
						  DROP TABLE #LineLoad;  

		IF OBJECT_ID('tempdb..#LineLoad_WEEK') IS NOT NULL      
						  DROP TABLE #LineLoad_WEEK;

		IF OBJECT_ID('tempdb..#LineLoad_WEEK_PIVOT') IS NOT NULL
						  DROP TABLE #LineLoad_WEEK_PIVOT;
		-- 2021.03.17   KSW            temp table 일괄 drop 스크립트 추가 - end

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

    _RETURN_ERR_CODE:                  
        BEGIN                  
             RETURN -1                  
        END; 
  END;
