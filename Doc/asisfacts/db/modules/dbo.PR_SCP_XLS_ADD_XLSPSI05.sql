

/*
 * Program ID   : PR_SCP_XLS_ADD_XLSPSI05
 * Description  : SCP SIMULATION SAVE
 * OutTable     :
 * Execute      : 
                 EXEC PR_SCP_XLS_ADD_XLSPSI05     @p_USER_ID             ='KTH'
                                                 ,@p_division_id         = '81'
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
 * 2020.01.15   KTH            Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020.01.20   KTH            생산저장 로직 반영 PLAN_AMEND MEASURE
 * 2020.02.11   KTH            PROD_PLAN_AMEND  저장시 CONVERT_QTY 반영
 * 2020.04.21   KTH            PROD_PLAN_AMEND  저장시 SCM_ADM_LOOKUP_MASTER_DETAIL.LOOKUP_TYPE='EE_PRODUCTION_PLAN' 저장로직 추가 
 * 2020.05.27   KTH            PROD_PLAN_AMEND LINE 추가 로직 반영 파라미터 @p_xls_attribute1  추가 외
 * 2020.07.13   KSW            전지 공급 대응력 향상을 위한 SCM 관리 체계 개선 :: 2020-07-14 - MA Plan 추가로 인한 변경 - 주석처리 ('SE' 는 없는 조건에서...)
 * 2021.06.16   KSW            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응
 * 2021.08.30   KSW            XLS_KEY1 불일치 오류수정
 * 2022.03.23	KSW	           GM JV 반영
 * 2022.08.17   KSW            중장기 버전 2 year 대응처리
 * 2023.11.14	KSK			  [PJ20230692] SCM 역량 강화 위한 SCP Phase2 개선과제 이행 (전극용 파샬위크 정보의 일간데이터 균등배분 저장)
 */



CREATE PROCEDURE [dbo].[PR_SCP_XLS_ADD_XLSPSI05]
( 
  
  @p_user_id                NVARCHAR(100)
 ,@p_division_id	          NVARCHAR(030)
 ,@p_plan_start_yyyymmdd	  NVARCHAR(008)
 ,@p_plan_type	            NVARCHAR(050)
 ,@p_seq	                  INT
 --,@p_CELL_ITEM_ID	        NVARCHAR(150)
 ,@p_item_id	              NVARCHAR(050)
 ,@p_measure	              NVARCHAR(050)       -- MEASURE별
 ,@p_xls_key1	              NVARCHAR(200)
 -----
 ,@p_xls_attribute1	        NVARCHAR(200)   = 'U'    -- U / I (Update/Insert)
 ,@p_cell_type_group_code	  NVARCHAR(1)     = NULL
 ,@p_nick_name	            NVARCHAR(200)   = NULL
 ,@p_electrode_type	        NVARCHAR(30)    = NULL
 ,@p_from_site_id	          NVARCHAR(30)    = NULL
 ,@p_from_site_description  NVARCHAR(150)   = NULL
 ,@p_to_site_id	            NVARCHAR(30)    = NULL    --'-'
 ,@p_to_site_description	  NVARCHAR(150)   = NULL    --'-'
 ,@p_lt_week	              INT             = NULL    -- 0
 ,@p_convert_qty_cell	      NUMERIC (20,10) = NULL
 ,@p_prod_line	            NVARCHAR(50)    = NULL
 ,@p_psi_type	              NVARCHAR(10)    = NULL

 ,@p_measure_label	        NVARCHAR(150)   = NULL
 ,@p_measure_value1	        NVARCHAR(50)    = NULL
 ,@p_measure_value1_label	  NVARCHAR(150)   = NULL
 ,@p_measure_value2	        NVARCHAR(50)    = NULL    -- NULL, NULL     ,NULL
 ,@p_measure_value2_label	  NVARCHAR(150)   = NULL    -- NULL, 광폭여부  ,NULL
 ,@p_unit	                  NVARCHAR(100)   = NULL
 ,@p_cell_item_id	          NVARCHAR(50)    = NULL
 ,@p_boh	                  NUMERIC (20,10) = NULL    -- NULL,NULL,NULL
 ,@p_sort_order_no	        INT             = NULL


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
 
 ,@p_attribute1   NVARCHAR(150)   -- 'P'
 ,@p_attribute3   NVARCHAR(150)   -- ORIGINAL DIVISION ID
 ,@p_attribute8   NVARCHAR(150)   -- '4'
 ,@p_attribute9   NVARCHAR(150)   -- OPERATION_ID

 , @P_PARTIAL_1  NVARCHAR(4000)  = NULL
 , @P_PARTIAL_2  NVARCHAR(4000)  = NULL
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
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_XLS_ADD_XLSPSI05';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);     
    DECLARE @v_table_id     NVARCHAR(150) = N'SCP_XLS_PSI_GLOBAL_ELECTRODE'; -- 테이블
    DECLARE @d_event_date   DATETIME;

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SCP_XLS_PSI_GLOBAL_ELECTRODE SAVE LOGIC';
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
    if @p_plan_type = 'FN'            
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
          FROM SCP_XLS_PSI_GLOBAL_ELECTRODE WITH (NOLOCK)
		 WHERE DIVISION_ID          = @p_division_id			-- 2022.03.23	KSW	GM JV 반영
		  ;

      IF (@p_division_id <> @v_division_id OR @p_plan_start_yyyymmdd <> @v_plan_start_yyyymmdd OR @p_plan_type <> @v_plan_type OR @p_seq <> @v_seq)  
        return -1   
    -------------------------------------------------------------------------------------------------------------------------------------------------------


      --PRINT @p_plan_type
    BEGIN TRY
      BEGIN         

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
			EXEC @rows = PR_SCP_XLS_ADD_XLSPSI05_S     @p_user_id         = @p_user_id
												 ,@p_division_id	      = @p_division_id
												 ,@p_plan_start_yyyymmdd  = @p_plan_start_yyyymmdd
												 ,@p_plan_type	          = @p_plan_type
												 ,@p_seq	              = @p_seq
												 ,@p_item_id	          = @p_item_id
												 ,@p_measure	          = @p_measure
												 ,@p_xls_key1	          = @p_xls_key1
												 -----
												 ,@p_xls_attribute1	      = @p_xls_attribute1
												 ,@p_cell_type_group_code = @p_cell_type_group_code
												 ,@p_nick_name	          = @p_nick_name
												 ,@p_electrode_type	      = @p_electrode_type
												 ,@p_from_site_id	      = @p_from_site_id
												 ,@p_from_site_description= @p_from_site_description
												 ,@p_to_site_id	          = @p_to_site_id
												 ,@p_to_site_description  = @p_to_site_description
												 ,@p_lt_week	          = @p_lt_week
												 ,@p_convert_qty_cell	  = @p_convert_qty_cell
												 ,@p_prod_line	          = @p_prod_line
												 ,@p_psi_type	          = @p_psi_type

												 ,@p_measure_label	      = @p_measure_label
												 ,@p_measure_value1	      = @p_measure_value1
												 ,@p_measure_value1_label = @p_measure_value1_label
												 ,@p_measure_value2	      = @p_measure_value2
												 ,@p_measure_value2_label = @p_measure_value2_label
												 ,@p_unit	              = @p_unit
												 ,@p_cell_item_id	      = @p_cell_item_id
												 ,@p_boh	              = @p_boh
												 ,@p_sort_order_no	      = @p_sort_order_no

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

												 ,@p_attribute1   = @p_attribute1
												 ,@p_attribute3   = @p_attribute3
												 ,@p_attribute8   = @p_attribute8
												 ,@p_attribute9   = @p_attribute9
												 ,@P_PARTIAL  	 = @P_PARTIAL_1
			;
			IF (@rows < 0)  GOTO _RETURN_ERR_CODE


			IF @v_bp_flag = 'Y'
			BEGIN
				
				-------------------------------------------------------------------------------------------------------------
				-- 2 year 저장 프로시저 실행
				-------------------------------------------------------------------------------------------------------------
				SET @p_create_from_yyyymmdd = @p_create_to_yyyymmdd;	--CONVERT(VARCHAR(8), DATEADD(day, 1, @p_create_to_yyyymmdd), 112);
				SET @p_create_to_yyyymmdd   = CONVERT(VARCHAR(8), DATEADD(day, 364, @p_create_from_yyyymmdd), 112);		-- 중장기 버전 2 year 대응처리

				-- XLS_KEY1 불일치 오류수정 - KSW 2021.08.30 - start
				DECLARE @v_link_xls_key1	              NVARCHAR(200) = '';

				SELECT @v_link_xls_key1 = Y.XLS_KEY1
				  FROM (
						SELECT PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, NICK_NAME, ELECTRODE_TYPE, ITEM_ID, FROM_SITE_ID, TO_SITE_ID, PROD_LINE, MEASURE
						  FROM SCP_XLS_PSI_GLOBAL_ELECTRODE WITH (NOLOCK)
						 WHERE PLAN_START_YYYYMMDD  = @p_plan_start_yyyymmdd
						   AND PLAN_TYPE            = @p_plan_type
						   AND SEQ                  = @p_seq
						   AND CREATE_FROM_YYYYMMDD = @p_plan_start_yyyymmdd
						   AND DIVISION_ID          = @p_division_id			-- 2022.03.23	KSW	GM JV 반영
						   AND XLS_KEY1             = @p_xls_key1
					   ) X, SCP_XLS_PSI_GLOBAL_ELECTRODE Y WITH (NOLOCK)
				 WHERE Y.PLAN_START_YYYYMMDD = X.PLAN_START_YYYYMMDD
				   AND Y.PLAN_TYPE           = X.PLAN_TYPE
				   AND Y.SEQ                 = X.SEQ
				   AND Y.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd
				   AND Y.DIVISION_ID          = @p_division_id			-- 2022.03.23	KSW	GM JV 반영
				   AND Y.NICK_NAME           = X.NICK_NAME
				   AND Y.ELECTRODE_TYPE      = X.ELECTRODE_TYPE
				   AND Y.ITEM_ID             = X.ITEM_ID
				   AND Y.FROM_SITE_ID        = X.FROM_SITE_ID
				   AND Y.TO_SITE_ID          = X.TO_SITE_ID
				   AND Y.PROD_LINE           = X.PROD_LINE
				   AND Y.MEASURE             = X.MEASURE
				   ;
				-- XLS_KEY1 불일치 오류수정 - KSW 2021.08.30 - end

				EXEC @rows = PR_SCP_XLS_ADD_XLSPSI05_S     @p_user_id         = @p_user_id
													 ,@p_division_id	      = @p_division_id
													 ,@p_plan_start_yyyymmdd  = @p_plan_start_yyyymmdd
													 ,@p_plan_type	          = @p_plan_type
													 ,@p_seq	              = @p_seq
													 ,@p_item_id	          = @p_item_id
													 ,@p_measure	          = @p_measure
													 ,@p_xls_key1	          = @v_link_xls_key1
													 -----
													 ,@p_xls_attribute1	      = @p_xls_attribute1
													 ,@p_cell_type_group_code = @p_cell_type_group_code
													 ,@p_nick_name	          = @p_nick_name
													 ,@p_electrode_type	      = @p_electrode_type
													 ,@p_from_site_id	      = @p_from_site_id
													 ,@p_from_site_description= @p_from_site_description
													 ,@p_to_site_id	          = @p_to_site_id
													 ,@p_to_site_description  = @p_to_site_description
													 ,@p_lt_week	          = @p_lt_week
													 ,@p_convert_qty_cell	  = @p_convert_qty_cell
													 ,@p_prod_line	          = @p_prod_line
													 ,@p_psi_type	          = @p_psi_type

													 ,@p_measure_label	      = @p_measure_label
													 ,@p_measure_value1	      = @p_measure_value1
													 ,@p_measure_value1_label = @p_measure_value1_label
													 ,@p_measure_value2	      = @p_measure_value2
													 ,@p_measure_value2_label = @p_measure_value2_label
													 ,@p_unit	              = @p_unit
													 ,@p_cell_item_id	      = @p_cell_item_id
													 ,@p_boh	              = @p_boh
													 ,@p_sort_order_no	      = @p_sort_order_no

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

													 ,@p_attribute1   = @p_attribute1
													 ,@p_attribute3   = @p_attribute3
													 ,@p_attribute8   = @p_attribute8
													 ,@p_attribute9   = @p_attribute9
													 ,@P_PARTIAL  	 = @P_PARTIAL_2
				;
				IF (@rows < 0)  GOTO _RETURN_ERR_CODE
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

