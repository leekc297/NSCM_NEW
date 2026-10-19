
/*
 * Program ID   : PR_SCP_XLS_ADD_XLSPSI05_S
 * Description  : SCP SIMULATION SAVE
 * OutTable     :
 * Execute      : 
                 EXEC PR_SCP_XLS_ADD_XLSPSI05_S   @p_USER_ID             ='KTH'
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
 * 2021.06.16   KSW            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - 저장방식을 1 year 단위로 저장
 * 2021.10.25   KSW            튜닝개선요청에 따른 변경
 * 2022.03.23	KSW	           GM JV 반영
 * 2022.09.22	KSW			   PR_SCP_ANL_UI_EE_SEARCH_DATA_CREATE 오류발지를 위한 처리추가
 * 2023.11.14	KSK			   [PJ20230692] SCM 역량 강화 위한 SCP Phase2 개선과제 이행 (전극용 파샬위크 정보의 일간데이터 균등배분 저장)
 * 2023.12.04	OIJ			   전달 변수를 지역변수로 변경하여 사용하도록 수정 및 쿼리 정리
 */



CREATE PROCEDURE [dbo].[PR_SCP_XLS_ADD_XLSPSI05_S]
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

 ,@p_create_from_yyyymmdd     NVARCHAR(008)
 ,@p_create_to_yyyymmdd       NVARCHAR(008)

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
 
 ,@p_attribute1   NVARCHAR(150)   -- 'P'
 ,@p_attribute3   NVARCHAR(150)   -- ORIGINAL DIVISION ID
 ,@p_attribute8   NVARCHAR(150)   -- '4'
 ,@p_attribute9   NVARCHAR(150)   -- OPERATION_ID
 ,@P_PARTIAL	  NVARCHAR(4000) = NULL

 )                                     
AS                                     

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

	--전달 변수 
	DECLARE @v_batch_user_id					NVARCHAR(100) = N'';  
	DECLARE @v_batch_division_id				NVARCHAR(030) = N'';  
	DECLARE @v_batch_plan_start_yyyymmdd		NVARCHAR(008) = N'';  
	DECLARE @v_batch_plan_type					NVARCHAR(050) = N'';  
	DECLARE @v_batch_seq						BIGINT			   ;
	DECLARE @v_batch_item_id					NVARCHAR(050) = N'';  
	DECLARE @v_batch_measure					NVARCHAR(050) = N'';  
	DECLARE @v_batch_xls_key1					INT				   ;
	DECLARE @v_batch_xls_attribute1	        NVARCHAR(200) = N'';  
	DECLARE @v_batch_cell_type_group_code		NVARCHAR(1)     = NULL;
	DECLARE @v_batch_nick_name					NVARCHAR(200)   = NULL;
	DECLARE @v_batch_electrode_type	        NVARCHAR(30)    = NULL;
	DECLARE @v_batch_from_site_id				NVARCHAR(30)    = NULL;
	DECLARE @v_batch_from_site_description		NVARCHAR(150)   = NULL;
	DECLARE @v_batch_to_site_id	            NVARCHAR(30)    = NULL;   
	DECLARE @v_batch_to_site_description	    NVARCHAR(150)   = NULL; 
	DECLARE @v_batch_lt_week	                INT             = NULL;   
	DECLARE @v_batch_convert_qty_cell			NUMERIC (20,10) = NULL;
	DECLARE @v_batch_prod_line					NVARCHAR(50)    = NULL;
	DECLARE @v_batch_psi_type					NVARCHAR(10)    = NULL;
	DECLARE @v_batch_measure_label				NVARCHAR(150)   = NULL;
	DECLARE @v_batch_measure_value1	        NVARCHAR(50)    = NULL;
	DECLARE @v_batch_measure_value1_label		NVARCHAR(150)   = NULL;
	DECLARE @v_batch_measure_value2	        NVARCHAR(50)    = NULL;   -- NULL, NULL     ,NULL
	DECLARE @v_batch_measure_value2_label		NVARCHAR(150)   = NULL;  -- NULL, 광폭여부  ,NULL
	DECLARE @v_batch_unit						NVARCHAR(100)   = NULL;
	DECLARE @v_batch_cell_item_id				NVARCHAR(50)    = NULL;
	DECLARE @v_batch_boh	                    NUMERIC (20,10) = NULL;   -- NULL,NULL,NULL
	DECLARE @v_batch_sort_order_no				INT             = NULL;
	DECLARE @v_batch_create_from_yyyymmdd     NVARCHAR(008) = N'';  
	DECLARE @v_batch_create_to_yyyymmdd       NVARCHAR(008) = N'';  
	DECLARE @v_batch_attribute1   NVARCHAR(150)  = N'';    -- 'P'
	DECLARE @v_batch_attribute3   NVARCHAR(150)  = N'';   -- ORIGINAL DIVISION ID
	DECLARE @v_batch_attribute8   NVARCHAR(150)  = N'';   -- '4'
	DECLARE @v_batch_attribute9   NVARCHAR(150)  = N'';     -- OPERATION_ID

	SET @v_batch_user_id					=	@p_user_id 				;
	SET @v_batch_division_id				=	@p_division_id			;
	SET @v_batch_plan_start_yyyymmdd		=	@p_plan_start_yyyymmdd	;
	SET @v_batch_plan_type					=	@p_plan_type			;	
	SET @v_batch_seq						=	@p_seq					;
	SET @v_batch_item_id					=	@p_item_id				;
	SET @v_batch_measure					=	@p_measure				;
	SET @v_batch_xls_key1					=	CAST(@p_xls_key1 AS INT);	         
	SET @v_batch_xls_attribute1	       		=	@p_xls_attribute1	   	;
	SET @v_batch_cell_type_group_code		=	@p_cell_type_group_code	;
	SET @v_batch_nick_name					=	@p_nick_name			;	
	SET @v_batch_electrode_type	       		=	@p_electrode_type	   	;
	SET @v_batch_from_site_id				=	@p_from_site_id			;
	SET @v_batch_from_site_description		=	@p_from_site_description;
	SET @v_batch_to_site_id	           		=	@p_to_site_id	       	;
	SET @v_batch_to_site_description	   	=	@p_to_site_description	;
	SET @v_batch_lt_week	               	=	@p_lt_week	           	;
	SET @v_batch_convert_qty_cell			=	@p_convert_qty_cell		;
	SET @v_batch_prod_line					=	@p_prod_line			;	
	SET @v_batch_psi_type					=	@p_psi_type				;
	SET @v_batch_measure_label				=	@p_measure_label		;	
	SET @v_batch_measure_value1	       		=	@p_measure_value1	   	;
	SET @v_batch_measure_value1_label		=	@p_measure_value1_label	;
	SET @v_batch_measure_value2	       		=	@p_measure_value2	   	;
	SET @v_batch_measure_value2_label		=	@p_measure_value2_label	;
	SET @v_batch_unit						=	@p_unit					;
	SET @v_batch_cell_item_id				=	@p_cell_item_id			;
	SET @v_batch_boh	                   	=	@p_boh	               	;
	SET @v_batch_sort_order_no				=	@p_sort_order_no		;	
	SET @v_batch_create_from_yyyymmdd     	=	@p_create_from_yyyymmdd ;
	SET @v_batch_create_to_yyyymmdd       	=	@p_create_to_yyyymmdd   ;
	SET @v_batch_attribute1  				=	@p_attribute1     ;
	SET @v_batch_attribute3  				=	@p_attribute3     ;
	SET @v_batch_attribute8  				=	@p_attribute8     ;
	SET @v_batch_attribute9  				=	@p_attribute9     ;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'';  
    SET @v_batch_user = @p_user_id
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_XLS_ADD_XLSPSI05_S';
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
                              ,@p_user_id       = @v_batch_user_id
                              ;
    
    
        -- 임시 실행시간 확인용                
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();                
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';     

    --PRINT @p_plan_type
    -- PLAN_TYPE이 FN일경우 수정금지 RETURN
    if @v_batch_plan_type = 'FN'            
      return -1   

    ---------------------------------------------------------------------------------------------------------------------------------------------------------         
    ---- 입력된 버전과 현재 버전이 다를 경우 RETURN 
    ---------------------------------------------------------------------------------------------------------------------------------------------------------
    --    DECLARE   @v_division_id          NVARCHAR(030) = @p_division_id
    --            , @v_plan_start_yyyymmdd  NVARCHAR(008) = @p_plan_start_yyyymmdd
    --            , @v_plan_type            NVARCHAR(050) = @p_plan_type
    --            , @v_seq                  INT           = @p_seq

    --    SELECT TOP 1  @v_division_id          = DIVISION_ID
    --                , @v_plan_start_yyyymmdd  = PLAN_START_YYYYMMDD
    --                , @v_plan_type            = PLAN_TYPE
    --                , @v_seq                  = SEQ
    --      FROM SCP_XLS_PSI_GLOBAL_ELECTRODE WITH (NOLOCK)

    --  IF (@p_division_id <> @v_division_id OR @p_plan_start_yyyymmdd <> @v_plan_start_yyyymmdd OR @p_plan_type <> @v_plan_type OR @p_seq <> @v_seq)  
    --    return -1   
    ---------------------------------------------------------------------------------------------------------------------------------------------------------


      --PRINT @p_plan_type
    BEGIN TRY
      BEGIN         
    
        IF @v_batch_xls_attribute1 = 'I'
        BEGIN
          
          INSERT INTO dbo.SCP_XLS_PSI_GLOBAL_ELECTRODE
                     (DIVISION_ID
                     ,PLAN_START_YYYYMMDD
					 ,CREATE_FROM_YYYYMMDD
					 ,CREATE_TO_YYYYMMDD
                     ,PLAN_TYPE
                     ,SEQ

                     ,CELL_TYPE_GROUP_CODE
                     ,NICK_NAME
                     ,ELECTRODE_TYPE
                     ,ITEM_ID
                     ,FROM_SITE_ID
                     ,FROM_SITE_DESCRIPTION
                     ,TO_SITE_ID
                     ,TO_SITE_DESCRIPTION
                     ,LT_WEEK
                     ,CONVERT_QTY_CELL
                     ,PROD_LINE
                     ,PSI_TYPE
                     ,MEASURE
                     ,MEASURE_LABEL
                     ,MEASURE_VALUE1
                     ,MEASURE_VALUE1_LABEL
                     ,MEASURE_VALUE2
                     ,MEASURE_VALUE2_LABEL
                     ,UNIT
                     ,CELL_ITEM_ID
                     ,BOH
                     ,XLS_KEY1
                     ,XLS_ATTRIBUTE1
                     ,SORT_ORDER_NO
                     ,WQTY01,WQTY02,WQTY03,WQTY04,WQTY05,WQTY06,WQTY07,WQTY08,WQTY09,WQTY10
                     ,WQTY11,WQTY12,WQTY13,WQTY14,WQTY15,WQTY16,WQTY17,WQTY18,WQTY19,WQTY20
                     ,WQTY21,WQTY22,WQTY23,WQTY24,WQTY25,WQTY26,WQTY27,WQTY28,WQTY29,WQTY30
                     ,WQTY31,WQTY32,WQTY33,WQTY34,WQTY35,WQTY36,WQTY37,WQTY38,WQTY39,WQTY40
                     ,WQTY41,WQTY42,WQTY43,WQTY44,WQTY45,WQTY46,WQTY47,WQTY48,WQTY49,WQTY50
                     ,WQTY51,WQTY52
                     ,CREATED_BY
                     ,CREATION_DATE
                     ,LAST_UPDATED_BY
                     ,LAST_UPDATE_DATE
                     ,ATTRIBUTE1
                     --,ATTRIBUTE2
                     ,ATTRIBUTE3
                     --,ATTRIBUTE4
                     --,ATTRIBUTE5
                     --,ATTRIBUTE6
                     --,ATTRIBUTE7
                     ,ATTRIBUTE8
                     ,ATTRIBUTE9
                     --,ATTRIBUTE10
                     )
                    

               VALUES
                     (@v_batch_division_id
                     ,@v_batch_plan_start_yyyymmdd
					 ,@v_batch_create_from_yyyymmdd
					 ,CONVERT(VARCHAR(8), DATEADD(day, 363, @v_batch_create_from_yyyymmdd), 112)
                     ,@v_batch_plan_type
                     ,@v_batch_seq
                     ,@v_batch_cell_type_group_code
                     ,@v_batch_nick_name
                     ,@v_batch_electrode_type
                     ,@v_batch_item_id
                     ,@v_batch_from_site_id
                     ,@v_batch_from_site_description
                     ,@v_batch_to_site_id
                     ,@v_batch_to_site_description
                     ,@v_batch_lt_week
                     ,@v_batch_convert_qty_cell
                     ,@v_batch_prod_line
                     ,@v_batch_psi_type
                     ,@v_batch_measure
                     ,@v_batch_measure_label
                     ,@v_batch_measure_value1
                     ,@v_batch_measure_value1_label
                     ,@v_batch_measure_value2
                     ,@v_batch_measure_value2_label
                     ,@v_batch_unit
                     ,@v_batch_cell_item_id
                     ,@v_batch_boh
                     ,@v_batch_xls_key1
                     ,@v_batch_xls_attribute1
                     ,@v_batch_sort_order_no

                     ,@p_WQTY01
                     ,@p_WQTY02
                     ,@p_WQTY03
                     ,@p_WQTY04
                     ,@p_WQTY05
                     ,@p_WQTY06
                     ,@p_WQTY07
                     ,@p_WQTY08
                     ,@p_WQTY09
                     ,@p_WQTY10
                     ,@p_WQTY11
                     ,@p_WQTY12
                     ,@p_WQTY13
                     ,@p_WQTY14
                     ,@p_WQTY15
                     ,@p_WQTY16
                     ,@p_WQTY17
                     ,@p_WQTY18
                     ,@p_WQTY19
                     ,@p_WQTY20
                     ,@p_WQTY21
                     ,@p_WQTY22
                     ,@p_WQTY23
                     ,@p_WQTY24
                     ,@p_WQTY25
                     ,@p_WQTY26
                     ,@p_WQTY27
                     ,@p_WQTY28
                     ,@p_WQTY29
                     ,@p_WQTY30
                     ,@p_WQTY31
                     ,@p_WQTY32
                     ,@p_WQTY33
                     ,@p_WQTY34
                     ,@p_WQTY35
                     ,@p_WQTY36
                     ,@p_WQTY37
                     ,@p_WQTY38
                     ,@p_WQTY39
                     ,@p_WQTY40
                     ,@p_WQTY41
                     ,@p_WQTY42
                     ,@p_WQTY43
                     ,@p_WQTY44
                     ,@p_WQTY45
                     ,@p_WQTY46
                     ,@p_WQTY47
                     ,@p_WQTY48
                     ,@p_WQTY49
                     ,@p_WQTY50
                     ,@p_WQTY51
                     ,@p_WQTY52
                     ,@v_batch_user_id
                     ,GETDATE()
                     ,@v_batch_user_id
                     ,GETDATE()
                     ,@v_batch_attribute1   --ATTRIBUTE1
                   --  ,NULL  --ATTRIBUTE2
                     ,@v_batch_attribute3    --ATTRIBUTE3 ORIGINAL DIVISION ID
                   --  ,NULL  --ATTRIBUTE4
                   --  ,NULL  --ATTRIBUTE5
                   --  ,NULL  --ATTRIBUTE6
                   --  ,NULL  --ATTRIBUTE7
                     ,@v_batch_attribute8   --ATTRIBUTE8
                     ,@v_batch_attribute9    --ATTRIBUTE10-- OPERATION_ID
                     )
        END 
			-- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응
            --DECLARE @p_to_yyyymmdd  VARCHAR(8)   =  CONVERT(VARCHAR(8), DATEADD(day, 364, @p_plan_start_yyyymmdd), 112)
			DECLARE @p_to_yyyymmdd  VARCHAR(8)   =  @v_batch_create_to_yyyymmdd;

            -------------------------------------------------------------------------------------------------------------         
            -- 수정하기전의 테이블에 존재하는 데이타를 가져와서 변수에 담아둔다.
            ------------------------------------------------------------------------------------------------------------- 

              -- 수정전 QTY 변수                                        
             DECLARE  @x_WQTY01 INT = 0.0 ,@x_WQTY02  INT = 0.0 ,@x_WQTY03  INT = 0.0 ,@x_WQTY04  INT = 0.0 ,@x_WQTY05  INT = 0.0
                     ,@x_WQTY06	INT = 0.0 ,@x_WQTY07  INT = 0.0 ,@x_WQTY08  INT = 0.0 ,@x_WQTY09  INT = 0.0 ,@x_WQTY10  INT = 0.0
                     ,@x_WQTY11 INT = 0.0 ,@x_WQTY12  INT = 0.0 ,@x_WQTY13  INT = 0.0 ,@x_WQTY14  INT = 0.0 ,@x_WQTY15  INT = 0.0
                     ,@x_WQTY16	INT = 0.0 ,@x_WQTY17  INT = 0.0 ,@x_WQTY18  INT = 0.0 ,@x_WQTY19  INT = 0.0 ,@x_WQTY20  INT = 0.0
                     ,@x_WQTY21 INT = 0.0 ,@x_WQTY22  INT = 0.0 ,@x_WQTY23  INT = 0.0 ,@x_WQTY24  INT = 0.0 ,@x_WQTY25  INT = 0.0
                     ,@x_WQTY26	INT = 0.0 ,@x_WQTY27  INT = 0.0 ,@x_WQTY28  INT = 0.0 ,@x_WQTY29  INT = 0.0 ,@x_WQTY30  INT = 0.0
                     ,@x_WQTY31 INT = 0.0 ,@x_WQTY32  INT = 0.0 ,@x_WQTY33  INT = 0.0 ,@x_WQTY34  INT = 0.0 ,@x_WQTY35  INT = 0.0
                     ,@x_WQTY36	INT = 0.0 ,@x_WQTY37  INT = 0.0 ,@x_WQTY38  INT = 0.0 ,@x_WQTY39  INT = 0.0 ,@x_WQTY40  INT = 0.0
                     ,@x_WQTY41 INT = 0.0 ,@x_WQTY42  INT = 0.0 ,@x_WQTY43  INT = 0.0 ,@x_WQTY44  INT = 0.0 ,@x_WQTY45  INT = 0.0
                     ,@x_WQTY46	INT = 0.0 ,@x_WQTY47  INT = 0.0 ,@x_WQTY48  INT = 0.0 ,@x_WQTY49  INT = 0.0 ,@x_WQTY50  INT = 0.0
                     ,@x_WQTY51 INT = 0.0 ,@x_WQTY52  INT = 0.0 



             SELECT 
                     @X_WQTY01 = WQTY01  ,@X_WQTY02  = WQTY02  ,@X_WQTY03  = WQTY03  ,@X_WQTY04  = WQTY04  ,@X_WQTY05  = WQTY05  ,@X_WQTY06  = WQTY06  ,@X_WQTY07  = WQTY07  ,@X_WQTY08  = WQTY08  ,@X_WQTY09  = WQTY09  ,@X_WQTY10  = WQTY10
                    ,@X_WQTY11 = WQTY11  ,@X_WQTY12  = WQTY12  ,@X_WQTY13  = WQTY13  ,@X_WQTY14  = WQTY14  ,@X_WQTY15  = WQTY15  ,@X_WQTY16  = WQTY16  ,@X_WQTY17  = WQTY17  ,@X_WQTY18  = WQTY18  ,@X_WQTY19  = WQTY19  ,@X_WQTY20  = WQTY20
                    ,@X_WQTY21 = WQTY21  ,@X_WQTY22  = WQTY22  ,@X_WQTY23  = WQTY23  ,@X_WQTY24  = WQTY24  ,@X_WQTY25  = WQTY25  ,@X_WQTY26  = WQTY26  ,@X_WQTY27  = WQTY27  ,@X_WQTY28  = WQTY28  ,@X_WQTY29  = WQTY29  ,@X_WQTY30  = WQTY30
                    ,@X_WQTY31 = WQTY31  ,@X_WQTY32  = WQTY32  ,@X_WQTY33  = WQTY33  ,@X_WQTY34  = WQTY34  ,@X_WQTY35  = WQTY35  ,@X_WQTY36  = WQTY36  ,@X_WQTY37  = WQTY37  ,@X_WQTY38  = WQTY38  ,@X_WQTY39  = WQTY39  ,@X_WQTY40  = WQTY40
                    ,@X_WQTY41 = WQTY41  ,@X_WQTY42  = WQTY42  ,@X_WQTY43  = WQTY43  ,@X_WQTY44  = WQTY44  ,@X_WQTY45  = WQTY45  ,@X_WQTY46  = WQTY46  ,@X_WQTY47  = WQTY47  ,@X_WQTY48  = WQTY48  ,@X_WQTY49  = WQTY49  ,@X_WQTY50  = WQTY50
                    ,@X_WQTY51 = WQTY51  ,@X_WQTY52  = WQTY52  
               FROM DBO.SCP_XLS_PSI_GLOBAL_ELECTRODE WITH(NOLOCK)
              WHERE 0 = 0
                AND DIVISION_ID          = @v_batch_division_id
                AND PLAN_START_YYYYMMDD  = @v_batch_plan_start_yyyymmdd
				AND CREATE_FROM_YYYYMMDD = @v_batch_create_from_yyyymmdd
                AND SEQ                  = @v_batch_seq
                AND XLS_KEY1             = @v_batch_xls_key1; 



            -------------------------------------------------------------------------------------------------------------         
            -- FROZEN 구간 대상 DATA 생성
            -------------------------------------------------------------------------------------------------------------         
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
            --;


            -------------------------------------------------------------------------------------------------------------         
            -- 수정하기전의 테이블에 존재하는 데이타를 가져와서 임시 테이블에 담아둔다.
            ------------------------------------------------------------------------------------------------------------- 
            -- SOURCE에 반영될 테이블 #DAY_SCP_XLS_PSI_GLOBAL
     --       IF OBJECT_ID('tempdb..#DAY_SCP_XLS_PSI_GLOBAL') IS NOT NULL	
	    --          DROP TABLE #DAY_SCP_XLS_PSI_GLOBAL

     --           SELECT * 
     --           INTO #DAY_SCP_XLS_PSI_GLOBAL
     --           FROM SCP_XLS_PSI_GLOBAL_ELECTRODE  WITH (NOLOCK)
     --            WHERE 0 = 0
     --               AND DIVISION_ID          = @v_batch_division_id
     --               AND PLAN_START_YYYYMMDD  = @v_batch_plan_start_yyyymmdd
					--AND CREATE_FROM_YYYYMMDD = @v_batch_create_from_yyyymmdd
     --               AND SEQ                  = @v_batch_seq
     --               AND XLS_KEY1             = @v_batch_xls_key1 
     --               ;

     --       -- SCP_XLS_PSI_GLOBAL에 반영될 테이블 #SCP_XLS_PSI_GLOBAL_ORG
     --       IF OBJECT_ID('tempdb..#SCP_XLS_PSI_GLOBAL_ORG') IS NOT NULL	
	    --          DROP TABLE #SCP_XLS_PSI_GLOBAL_ORG

     --           SELECT * 
     --           INTO #SCP_XLS_PSI_GLOBAL_ORG
     --           FROM SCP_XLS_PSI_GLOBAL_ELECTRODE  WITH (NOLOCK)
     --            WHERE 0 = 0
     --               AND DIVISION_ID          = @v_batch_division_id
     --               AND PLAN_START_YYYYMMDD  = @v_batch_plan_start_yyyymmdd
					--AND CREATE_FROM_YYYYMMDD = @v_batch_create_from_yyyymmdd
     --               AND SEQ                  = @v_batch_seq
     --               AND XLS_KEY1             = @v_batch_xls_key1 
     --               ;


            -------------------------------------------------------------------------------------------------------------
            -- SCP_XLS_PSI_GLOBAL_ELECTRODE (XLSPSI05) 화면조회용 테이블에 해당 레코드를 수정한다.
            -------------------------------------------------------------------------------------------------------------
             -- PROD         --> SCP_ANL_PRODUCTION_PLAN.MEASURE 'PROD_PLAN_AMEND'
			-------------------------------------------------------------------------------------------------------------         
            -- SOURCE TABLE 반영
            -------------------------------------------------------------------------------------------------------------   

			SET @v_batch_user = @v_batch_user_id + '[SIMULATION]' -- UI 작업자와 시물레이션 작업자를 구분하기 위해서

            IF @v_batch_measure IN  ('PROD_PLAN_AMEND') -- 'PROD_PLAN_AMEND' SCP_XLS_PSI_GLOBAL_ELECTRODE 테이블에 저장만 처리함.
               BEGIN
            -------------------------------------------------------------------------------------------------------------         
            -- WEEK DATA를 DAY DATA로 반영  
            -- 확정 구간이 주에 포함될 경우 수정금지 구간을 제외하고, 일 배분해야 함.
            --  
            -------------------------------------------------------------------------------------------------------------   
                    UPDATE DBO.SCP_XLS_PSI_GLOBAL_ELECTRODE
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
                            ,LAST_UPDATED_BY    = @v_batch_user
                            ,LAST_UPDATE_DATE   = GETDATE()
                            ,ATTRIBUTE2         = 'Y'
                      WHERE 0 = 0
                        AND DIVISION_ID          = @v_batch_division_id
                        AND PLAN_START_YYYYMMDD  = @v_batch_plan_start_yyyymmdd
						AND CREATE_FROM_YYYYMMDD = @v_batch_create_from_yyyymmdd
                        AND SEQ                  = @v_batch_seq
                        AND XLS_KEY1             = @v_batch_xls_key1;    
    
               END


			   if (@P_PARTIAL <> '' and @P_PARTIAL is not null)
			   BEGIN
			-- 일자별 수량을 파샬위크 데이터  수정
			-- FORMATMESSAGE의 제한길이가 2044이므로 추후 수정시 개선요망(KSK, 2024-04-16)
				declare @sql  nvarchar(max)
				set @sql = FORMATMESSAGE('
						update SCP_XLS_PSI_GLOBAL_ELECTRODE
							set 
								%s
						 WHERE DIVISION_ID          = ''%s''
						AND CREATE_FROM_YYYYMMDD = ''%s''
                        AND XLS_KEY1             = %d;    
					', @P_PARTIAL , @p_division_id, @p_create_from_yyyymmdd, @v_batch_xls_key1) ;
					--( 간헐적 문자구분오류의 원인으로 의심되어 데이터 형을 지정함, KSK, 240906)
					

			   exec up_xls_print @sql
			   --select @v_batch_xls_key1 "@v_batch_xls_key1" , @p_xls_key1 "@p_xls_key1"

			   exec (@sql)			

			  

			   END


            DECLARE @n_history_seq	INTEGER;   -- HISTORY SEQ 
            
            -------------------------------------------------------------------------------------------------------------         
            -- SCP_ANL_PRODUCTION_PLAN UPDATE
            -- PROD  --> SCP_ANL_PRODUCTION_PLAN.MEASURE 'PROD_PLAN_AMEND' UPDATE
            -------------------------------------------------------------------------------------------------------------  

          IF @v_batch_measure IN  ('PROD_PLAN_AMEND')   
              BEGIN 
 
               IF OBJECT_ID('tempdb..#SCP_ANL_PRODUCTION_PLAN') IS NOT NULL	
	              DROP TABLE #SCP_ANL_PRODUCTION_PLAN

                SELECT X.DIVISION_ID, X.PLAN_START_YYYYMMDD, X.PLAN_TYPE, X.SEQ
                      ,CONVERT(NVARCHAR(10), 'E') AS OPERATION_GROUP
--                      ,X.CELL_ITEM_ID              
--                      ,X.SITE_ID AS SCM_SITE_ID
                      ,X.FROM_SITE_ID AS SCM_SITE_ID
                      ,X.CELL_ITEM_ID AS ITEM_ID
                      ,X.PROD_LINE AS LINE_ID
                      ,ISNULL(X.ATTRIBUTE9,'') AS OPERATION_ID
                      ,'PROD_PLAN_AMEND' AS MEASURE
                      ,Y.YYYYMMDD AS YYYYMMDD
                      --,X.QTY / ISNULL(X.CONVERT_QTY_CELL,1)  AS QTY
					  -- ZERO DIVIDE EXCEPTION 회피(KSK, 240930)
					  ,X.QTY / CASE WHEN ISNULL(X.CONVERT_QTY_CELL, 0) = 0 THEN 1 ELSE X.CONVERT_QTY_CELL END   AS QTY
                      ,X.ATTRIBUTE3 AS ORIGIN_DIVISION_ID
                      ,X.ELECTRODE_TYPE
                      ,'0'   AS CELL_QTY
                      ,Y.YYYYMMDD_COLUMN               
                INTO #SCP_ANL_PRODUCTION_PLAN
                FROM SCP_XLS_PSI_GLOBAL_ELECTRODE SourceTable WITH (NOLOCK) 
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
							  WHERE A.BASIS_YYYYMMDD BETWEEN @v_batch_create_from_yyyymmdd AND @p_to_yyyymmdd
                              --WHERE A.BASIS_YYYYMMDD     >= @v_batch_create_from_yyyymmdd
                              --  AND A.BASIS_YYYYMMDD     <  @p_to_yyyymmdd
                            ) Y
                ON X.YYYYMMDD_COLUMN = Y.YYYYMMDD_COLUMN
				WHERE 0 = 0
                AND X.DIVISION_ID          = @v_batch_division_id
                AND X.PLAN_START_YYYYMMDD  = @v_batch_plan_start_yyyymmdd
				AND X.CREATE_FROM_YYYYMMDD = @v_batch_create_from_yyyymmdd
                AND X.SEQ                  = @v_batch_seq
                AND X.XLS_KEY1             = @v_batch_xls_key1 --43 
                ;
              

             -- SELECT '#SCP_ANL_PRODUCTION_PLAN', * FROM #SCP_ANL_PRODUCTION_PLAN WITH (NOLOCK)
            -------------------------------------------------------------------------------------------------------------         
            -- FROZEN 구간 UPDATE
            -- PLANT SITE(SCM_MST_SITE)의 SHIP_FROZEN ,PROD_FROZEN를 주단위로 변경하여 FROZEN 구간을 저장 내역에서 삭제한다.
			-- 전지 공급 대응력 향상을 위한 SCM 관리 체계 개선 :: 2020-07-14 - MA Plan 추가로 인한 변경 - 주석처리 ('SE' 는 없는 조건에서...)
            -------------------------------------------------------------------------------------------------------------
            --IF @p_plan_type IN ('MA','SE')  AND @v_batch_measure IN  ('PROD_PLAN_AMEND') 
            --BEGIN
            --  DELETE  FROM #SCP_ANL_PRODUCTION_PLAN
            --          FROM #SCP_ANL_PRODUCTION_PLAN X
            --        INNER JOIN #SCM_MST_SITE Y
            --        ON Y.DIVISION_ID = X.DIVISION_ID
            --          AND Y.SCM_SITE_ID = X.SCM_SITE_ID
            --        WHERE 
            --            X.YYYYMMDD < (CASE WHEN @p_plan_type = 'MA' THEN Y.PROD_FROZEN_WEEK_DAY_MA ELSE Y.PROD_FROZEN_WEEK_DAY END)   --7
            --END

            
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
                        AND X.DIVISION_ID         = Y.DIVISION_ID				--@v_batch_division_id				--2021.10.25 튜닝개선요청에 따른 변경
                        AND X.PLAN_START_YYYYMMDD = Y.PLAN_START_YYYYMMDD		--@v_batch_PLAN_START_YYYYMMDD
                        AND X.PLAN_TYPE           = Y.PLAN_TYPE					--@v_batch_PLAN_TYPE
                        AND X.SEQ                 = Y.SEQ						--@v_batch_SEQ
                
                        AND X.OPERATION_GROUP     = Y.OPERATION_GROUP
                        AND X.SCM_SITE_ID         = Y.SCM_SITE_ID
                        AND X.ITEM_ID             = Y.ITEM_ID
                        AND X.MEASURE             = Y.MEASURE
                        AND X.YYYYMMDD            = Y.YYYYMMDD
                        AND X.LINE_ID             = Y.LINE_ID
                        --AND X.OPERATION_ID        = Y.OPERATION_ID
                        AND X.ORIGIN_DIVISION_ID  = Y.ORIGIN_DIVISION_ID
                        AND X.ELECTRODE_TYPE      = Y.ELECTRODE_TYPE

                

                        WHEN MATCHED  THEN 
                        UPDATE 
                          SET  X.QTY = Y.QTY
                              ,X.LAST_UPDATED_BY    = @v_batch_user
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
                                  ,@v_batch_user
                                  ,GETDATE()
                                  ,@v_batch_user
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
                                     ,@v_batch_user AS CREATED_BY
                                     ,GETDATE() AS CREATION_DATE
                                     ,@v_batch_user AS LAST_UPDATED_BY
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
                        ,@v_batch_user   AS CREATED_BY
                        ,GETDATE()    AS CREATION_DATE
                        ,@v_batch_user   AS LAST_UPDATED_BY
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
                            ,X.LAST_UPDATED_BY  = @v_batch_user
                            ,X.LAST_UPDATE_DATE = GETDATE()
                        FROM SCP_ANL_PRODUCTION_PLAN_FIX  X WITH (NOLOCK)     -- FIX_ID, DIVISION_ID, OPERATION_GROUP, SCM_SITE_ID, ITEM_ID, LINE_ID, OPERATION_ID, YYYYMMDD
                        INNER JOIN #SCP_ANL_PRODUCTION_PLAN Y WITH (NOLOCK)
                        ON 0 = 0
                        AND X.DIVISION_ID       = Y.DIVISION_ID
                        AND X.OPERATION_GROUP   = Y.OPERATION_GROUP
                        AND X.SCM_SITE_ID       = Y.SCM_SITE_ID
                        AND X.ITEM_ID           = Y.ITEM_ID
                        AND X.LINE_ID           = Y.LINE_ID
--                        AND X.OPERATION_ID      = Y.OPERATION_ID
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
                          ,@v_batch_user   AS CREATED_BY
                          ,GETDATE()    AS CREATION_DATE
                          ,@v_batch_user   AS LAST_UPDATED_BY
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
    --                    AND X.OPERATION_ID    = Y.OPERATION_ID
                        AND X.YYYYMMDD        = Y.YYYYMMDD
                        AND X.ATTRIBUTE1      =N'Y'

           
                  -------------------------------------------------------------------------------------------------------------         
                  -- PROD_PLAN_AMEND  저장시 SCM_ADM_LOOKUP_MASTER_DETAIL.LOOKUP_TYPE='EE_PRODUCTION_PLAN' 저장로직 추가 BEGIN
                  -------------------------------------------------------------------------------------------------------------  
                  /*
                  CREATE TABLE #Tbl_ADM_LOOKUP_MASTER_DETAIL (
					             LOOKUP_TYPE    nvarchar(100)
					            ,SEGMENT1			  nvarchar(100) 
					            ,SEGMENT2       nvarchar(100) --OPERATION_GROUP or BIZ_TYPE
					            ,SEGMENT3       nvarchar(100) --FROM_SITE or TO_SITE
					            ,SEGMENT4       nvarchar(100) 
					            ,SEGMENT5			  nvarchar(100)
					            ,DISPLAY_SEQ		INT
					            ,ATTRIBUTE1		  nvarchar(150)
					            ,ATTRIBUTE2		  nvarchar(150)
					          );
                  */

                  IF OBJECT_ID('tempdb..#Tbl_ADM_LOOKUP_MASTER_DETAIL') IS NOT NULL	
                    DROP TABLE #Tbl_ADM_LOOKUP_MASTER_DETAIL

                  SELECT 'EE_PRODUCTION_PLAN'															AS LOOKUP_TYPE
							          ,'SCP'															AS SEGMENT1
							          ,CONVERT(NVARCHAR(100),OPERATION_GROUP)							AS SEGMENT2
							          ,CONVERT(NVARCHAR(100),SCM_SITE_ID)								AS SEGMENT3
							          ,CONVERT(NVARCHAR(100),LINE_ID)									AS SEGMENT4
							          ,CONVERT(NVARCHAR(100),OPERATION_ID)								AS SEGMENT5
							          ,ROW_NUMBER() OVER(PARTITION BY DIVISION_ID ORDER BY DIVISION_ID) AS DISPLAY_SEQ		
							          ,ORIGIN_DIVISION_ID												AS ATTRIBUTE1 
									  ,@v_batch_division_id												AS ATTRIBUTE2							-- 2022.09.22 KSW PR_SCP_ANL_UI_EE_SEARCH_DATA_CREATE 오류발지를 위한 처리추가
                    INTO #Tbl_ADM_LOOKUP_MASTER_DETAIL
					          FROM(
							            SELECT DIVISION_ID, OPERATION_GROUP, SCM_SITE_ID, ORIGIN_DIVISION_ID, LINE_ID, OPERATION_ID
							            FROM (
									                SELECT DISTINCT DIVISION_ID, OPERATION_GROUP, SCM_SITE_ID, ORIGIN_DIVISION_ID, LINE_ID, OPERATION_ID
									                FROM #SCP_ANL_PRODUCTION_PLAN WITH (NOLOCK)
										                --AND OPERATION_GROUP	= @p_operation_group
										                --AND SCM_SITE_ID			= @p_scm_site_id
										                --AND ITEM_ID				  = @p_item_id
										                --AND LINE_ID				  = @p_line_id 
								               ) A 
                          WHERE NOT EXISTS(SELECT 1 
                                             FROM SCM_ADM_LOOKUP_MASTER_DETAIL B WITH (NOLOCK)
												                    WHERE LOOKUP_TYPE = 'EE_PRODUCTION_PLAN'
													                    AND SEGMENT1    = 'SCP'
													                    AND SEGMENT2    = A.OPERATION_GROUP
													                    AND SEGMENT3    = A.SCM_SITE_ID
													                    AND SEGMENT4    = A.LINE_ID
													                    AND SEGMENT5    = A.OPERATION_ID
													                )
					              ) X 
                    WHERE 0 = 0
                    --AND X.SCM_SITE_ID ='A010-A'
					          ORDER BY DIVISION_ID, OPERATION_GROUP, SCM_SITE_ID, ORIGIN_DIVISION_ID, LINE_ID,OPERATION_ID	 


                    INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
							            (LOOKUP_TYPE
							            ,SEGMENT1
							            ,SEGMENT2
							            ,SEGMENT3
							            ,SEGMENT4
							            ,SEGMENT5
							            ,DISPLAY_SEQ
							            ,ATTRIBUTE1
										,ATTRIBUTE2		-- 2022.09.22 KSW PR_SCP_ANL_UI_EE_SEARCH_DATA_CREATE 오류발지를 위한 처리추가
							            ,VALID_YN
							            ,DESCRIPTION
							            ,CREATED_BY
							            ,CREATION_DATE
							            ,LAST_UPDATED_BY
							            ,LAST_UPDATE_DATE
							            )
					          SELECT LOOKUP_TYPE
						              ,SEGMENT1
						              ,SEGMENT2
						              ,SEGMENT3
						              ,SEGMENT4
						              ,SEGMENT5
						              ,DISPLAY_SEQ
						              ,ATTRIBUTE1
									  ,ATTRIBUTE2		-- 2022.09.22 KSW PR_SCP_ANL_UI_EE_SEARCH_DATA_CREATE 오류발지를 위한 처리추가
						              ,'Y'            AS VALID_YN
						              ,LOOKUP_TYPE    AS DESCRIPTION
						              ,@v_batch_user     AS CREATED_BY
						              ,SYSDATETIME()  AS CREATION_DATE
						              ,@v_batch_user     AS LAST_UPDATED_BY
						              ,SYSDATETIME()  AS LAST_UPDATE_DATE
					            FROM #Tbl_ADM_LOOKUP_MASTER_DETAIL A  WITH (NOLOCK) 	  
					              ;

					            INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL_H
							            (HISTORY_SEQ
							            ,LOOKUP_TYPE
							            ,SEGMENT1
							            ,SEGMENT2
							            ,SEGMENT3
							            ,SEGMENT4
							            ,SEGMENT5
							            ,DISPLAY_SEQ
							            ,ATTRIBUTE1
										,ATTRIBUTE2		-- 2022.09.22 KSW PR_SCP_ANL_UI_EE_SEARCH_DATA_CREATE 오류발지를 위한 처리추가
							            ,VALID_YN
							            ,DESCRIPTION
							            ,CREATED_BY
							            ,CREATION_DATE
							            ,LAST_UPDATED_BY
							            ,LAST_UPDATE_DATE
							            ,HISTORY_CREATION_DATE
							            )
					            SELECT NEXT VALUE FOR [dbo].[SEQ1_SCM_ADM_LOOKUP_MASTER_DETAIL_H]
							            ,LOOKUP_TYPE
							            ,SEGMENT1
							            ,SEGMENT2
							            ,SEGMENT3
							            ,SEGMENT4
							            ,SEGMENT5
							            ,DISPLAY_SEQ
							            ,ATTRIBUTE1
										,ATTRIBUTE2		-- 2022.09.22 KSW PR_SCP_ANL_UI_EE_SEARCH_DATA_CREATE 오류발지를 위한 처리추가
							            ,'Y'            AS VALID_YN
							            ,LOOKUP_TYPE    AS DESCRIPTION
							            ,@v_batch_user     AS CREATED_BY
							            ,SYSDATETIME()  AS CREATION_DATE
							            ,@v_batch_user     AS LAST_UPDATED_BY
							            ,SYSDATETIME()  AS LAST_UPDATE_DATE
							            ,SYSDATETIME()  AS HISTORY_CREATION_DATE
					            FROM #Tbl_ADM_LOOKUP_MASTER_DETAIL A  WITH (NOLOCK);

                  -------------------------------------------------------------------------------------------------------------         
                  -- PROD_PLAN_AMEND  저장시 SCM_ADM_LOOKUP_MASTER_DETAIL.LOOKUP_TYPE='EE_PRODUCTION_PLAN' 저장로직 추가 BEGIN
                  -------------------------------------------------------------------------------------------------------------  

            END

           
            
--            -----------------------------------------------------------
--              -- FROZEN 구간 복구              
--              -----------------------------------------------------------
              
--                  -------------------------------------------------------------------------------------------------------------         
--                  -- 전체 임시 테이블 생성  (#SCP_XLS_PSI_GLOBAL_MODIFY)
--                  -------------------------------------------------------------------------------------------------------------  
--                  IF OBJECT_ID('tempdb..#SCP_XLS_PSI_GLOBAL_MODIFY') IS NOT NULL	
--	                    DROP TABLE #SCP_XLS_PSI_GLOBAL_MODIFY

--                    --DROP TABLE #SCP_XLS_PSI_GLOBAL_MODIFY
--                    CREATE TABLE #SCP_XLS_PSI_GLOBAL_MODIFY(
--	                    XLS_KEY1              NVARCHAR(200)     NULL,
--                      QTY001  NUMERIC (20,10) NULL, QTY002  NUMERIC (20,10) NULL, QTY003  NUMERIC (20,10) NULL, QTY004 NUMERIC (20,10) NULL,  QTY005  NUMERIC (20,10) NULL, -- 신규
--	                    QTY006  NUMERIC (20,10) NULL,	QTY007  NUMERIC (20,10) NULL, QTY008  NUMERIC (20,10) NULL, QTY009 NUMERIC (20,10) NULL,  QTY010  NUMERIC (20,10) NULL,
--	                    QTY011  NUMERIC (20,10) NULL, QTY012  NUMERIC (20,10) NULL, QTY013  NUMERIC (20,10) NULL, QTY014 NUMERIC (20,10) NULL,  QTY015  NUMERIC (20,10) NULL,
--	                    QTY016  NUMERIC (20,10) NULL,	QTY017  NUMERIC (20,10) NULL, QTY018  NUMERIC (20,10) NULL, QTY019 NUMERIC (20,10) NULL,  QTY020  NUMERIC (20,10) NULL,
--                      QTY021  NUMERIC (20,10) NULL, QTY022  NUMERIC (20,10) NULL, QTY023  NUMERIC (20,10) NULL, QTY024 NUMERIC (20,10) NULL,  QTY025  NUMERIC (20,10) NULL,
--	                    QTY026  NUMERIC (20,10) NULL,	QTY027  NUMERIC (20,10) NULL, QTY028  NUMERIC (20,10) NULL, QTY029 NUMERIC (20,10) NULL,  QTY030  NUMERIC (20,10) NULL,
--                      QTY031  NUMERIC (20,10) NULL, QTY032  NUMERIC (20,10) NULL, QTY033  NUMERIC (20,10) NULL, QTY034 NUMERIC (20,10) NULL,  QTY035  NUMERIC (20,10) NULL,
--	                    QTY036  NUMERIC (20,10) NULL,	QTY037  NUMERIC (20,10) NULL, QTY038  NUMERIC (20,10) NULL, QTY039 NUMERIC (20,10) NULL,  QTY040  NUMERIC (20,10) NULL,
--                      QTY041  NUMERIC (20,10) NULL, QTY042  NUMERIC (20,10) NULL, QTY043  NUMERIC (20,10) NULL, QTY044 NUMERIC (20,10) NULL,  QTY045  NUMERIC (20,10) NULL,
--	                    QTY046  NUMERIC (20,10) NULL,	QTY047  NUMERIC (20,10) NULL, QTY048  NUMERIC (20,10) NULL, QTY049 NUMERIC (20,10) NULL,  QTY050  NUMERIC (20,10) NULL,

--                      QTY051  NUMERIC (20,10) NULL, QTY052  NUMERIC (20,10) NULL, QTY053  NUMERIC (20,10) NULL, QTY054 NUMERIC (20,10) NULL,  QTY055  NUMERIC (20,10) NULL,
--	                    QTY056  NUMERIC (20,10) NULL,	QTY057  NUMERIC (20,10) NULL, QTY058  NUMERIC (20,10) NULL, QTY059 NUMERIC (20,10) NULL,  QTY060  NUMERIC (20,10) NULL,
--                      QTY061  NUMERIC (20,10) NULL, QTY062  NUMERIC (20,10) NULL, QTY063  NUMERIC (20,10) NULL, QTY064 NUMERIC (20,10) NULL,  QTY065  NUMERIC (20,10) NULL,
--	                    QTY066  NUMERIC (20,10) NULL,	QTY067  NUMERIC (20,10) NULL, QTY068  NUMERIC (20,10) NULL, QTY069 NUMERIC (20,10) NULL,  QTY070  NUMERIC (20,10) NULL,
--                      QTY071  NUMERIC (20,10) NULL, QTY072  NUMERIC (20,10) NULL, QTY073  NUMERIC (20,10) NULL, QTY074 NUMERIC (20,10) NULL,  QTY075  NUMERIC (20,10) NULL,
--	                    QTY076  NUMERIC (20,10) NULL,	QTY077  NUMERIC (20,10) NULL, QTY078  NUMERIC (20,10) NULL, QTY079 NUMERIC (20,10) NULL,  QTY080  NUMERIC (20,10) NULL,
--                      QTY081  NUMERIC (20,10) NULL, QTY082  NUMERIC (20,10) NULL, QTY083  NUMERIC (20,10) NULL, QTY084 NUMERIC (20,10) NULL,  QTY085  NUMERIC (20,10) NULL,
--	                    QTY086  NUMERIC (20,10) NULL,	QTY087  NUMERIC (20,10) NULL, QTY088  NUMERIC (20,10) NULL, QTY089 NUMERIC (20,10) NULL,  QTY090  NUMERIC (20,10) NULL,
--                      QTY091  NUMERIC (20,10) NULL, QTY092  NUMERIC (20,10) NULL, QTY093  NUMERIC (20,10) NULL, QTY094 NUMERIC (20,10) NULL,  QTY095  NUMERIC (20,10) NULL,
--	                    QTY096  NUMERIC (20,10) NULL,	QTY097  NUMERIC (20,10) NULL, QTY098  NUMERIC (20,10) NULL, QTY099 NUMERIC (20,10) NULL,  QTY100  NUMERIC (20,10) NULL,

--                      QTY101  NUMERIC (20,10) NULL, QTY102  NUMERIC (20,10) NULL, QTY103  NUMERIC (20,10) NULL, QTY104 NUMERIC (20,10) NULL,  QTY105  NUMERIC (20,10) NULL,
--	                    QTY106  NUMERIC (20,10) NULL,	QTY107  NUMERIC (20,10) NULL, QTY108  NUMERIC (20,10) NULL, QTY109 NUMERIC (20,10) NULL,  QTY110  NUMERIC (20,10) NULL,
--	                    QTY111  NUMERIC (20,10) NULL, QTY112  NUMERIC (20,10) NULL, QTY113  NUMERIC (20,10) NULL, QTY114 NUMERIC (20,10) NULL,  QTY115  NUMERIC (20,10) NULL,
--	                    QTY116  NUMERIC (20,10) NULL,	QTY117  NUMERIC (20,10) NULL, QTY118  NUMERIC (20,10) NULL, QTY119 NUMERIC (20,10) NULL,  QTY120  NUMERIC (20,10) NULL,
--                      QTY121  NUMERIC (20,10) NULL, QTY122  NUMERIC (20,10) NULL, QTY123  NUMERIC (20,10) NULL, QTY124 NUMERIC (20,10) NULL,  QTY125  NUMERIC (20,10) NULL,
--	                    QTY126  NUMERIC (20,10) NULL,	QTY127  NUMERIC (20,10) NULL, QTY128  NUMERIC (20,10) NULL, QTY129 NUMERIC (20,10) NULL,  QTY130  NUMERIC (20,10) NULL,
--                      QTY131  NUMERIC (20,10) NULL, QTY132  NUMERIC (20,10) NULL, QTY133  NUMERIC (20,10) NULL, QTY134 NUMERIC (20,10) NULL,  QTY135  NUMERIC (20,10) NULL,
--	                    QTY136  NUMERIC (20,10) NULL,	QTY137  NUMERIC (20,10) NULL, QTY138  NUMERIC (20,10) NULL, QTY139 NUMERIC (20,10) NULL,  QTY140  NUMERIC (20,10) NULL,
--                      QTY141  NUMERIC (20,10) NULL, QTY142  NUMERIC (20,10) NULL, QTY143  NUMERIC (20,10) NULL, QTY144 NUMERIC (20,10) NULL,  QTY145  NUMERIC (20,10) NULL,
--	                    QTY146  NUMERIC (20,10) NULL,	QTY147  NUMERIC (20,10) NULL, QTY148  NUMERIC (20,10) NULL, QTY149 NUMERIC (20,10) NULL,  QTY150  NUMERIC (20,10) NULL,

--                      QTY151  NUMERIC (20,10) NULL, QTY152  NUMERIC (20,10) NULL, QTY153  NUMERIC (20,10) NULL, QTY154 NUMERIC (20,10) NULL,  QTY155  NUMERIC (20,10) NULL,
--	                    QTY156  NUMERIC (20,10) NULL,	QTY157  NUMERIC (20,10) NULL, QTY158  NUMERIC (20,10) NULL, QTY159 NUMERIC (20,10) NULL,  QTY160  NUMERIC (20,10) NULL,
--                      QTY161  NUMERIC (20,10) NULL, QTY162  NUMERIC (20,10) NULL, QTY163  NUMERIC (20,10) NULL, QTY164 NUMERIC (20,10) NULL,  QTY165  NUMERIC (20,10) NULL,
--	                    QTY166  NUMERIC (20,10) NULL,	QTY167  NUMERIC (20,10) NULL, QTY168  NUMERIC (20,10) NULL, QTY169 NUMERIC (20,10) NULL,  QTY170  NUMERIC (20,10) NULL,
--                      QTY171  NUMERIC (20,10) NULL, QTY172  NUMERIC (20,10) NULL, QTY173  NUMERIC (20,10) NULL, QTY174 NUMERIC (20,10) NULL,  QTY175  NUMERIC (20,10) NULL,
--	                    QTY176  NUMERIC (20,10) NULL,	QTY177  NUMERIC (20,10) NULL, QTY178  NUMERIC (20,10) NULL, QTY179 NUMERIC (20,10) NULL,  QTY180  NUMERIC (20,10) NULL,
--                      QTY181  NUMERIC (20,10) NULL, QTY182  NUMERIC (20,10) NULL, QTY183  NUMERIC (20,10) NULL, QTY184 NUMERIC (20,10) NULL,  QTY185  NUMERIC (20,10) NULL,
--	                    QTY186  NUMERIC (20,10) NULL,	QTY187  NUMERIC (20,10) NULL, QTY188  NUMERIC (20,10) NULL, QTY189 NUMERIC (20,10) NULL,  QTY190  NUMERIC (20,10) NULL,
--                      QTY191  NUMERIC (20,10) NULL, QTY192  NUMERIC (20,10) NULL, QTY193  NUMERIC (20,10) NULL, QTY194 NUMERIC (20,10) NULL,  QTY195  NUMERIC (20,10) NULL,
--	                    QTY196  NUMERIC (20,10) NULL,	QTY197  NUMERIC (20,10) NULL, QTY198  NUMERIC (20,10) NULL, QTY199 NUMERIC (20,10) NULL,  QTY200  NUMERIC (20,10) NULL,

--                      QTY201  NUMERIC (20,10) NULL, QTY202  NUMERIC (20,10) NULL, QTY203  NUMERIC (20,10) NULL, QTY204 NUMERIC (20,10) NULL,  QTY205  NUMERIC (20,10) NULL,
--	                    QTY206  NUMERIC (20,10) NULL,	QTY207  NUMERIC (20,10) NULL, QTY208  NUMERIC (20,10) NULL, QTY209 NUMERIC (20,10) NULL,  QTY210  NUMERIC (20,10) NULL,
--	                    QTY211  NUMERIC (20,10) NULL, QTY212  NUMERIC (20,10) NULL, QTY213  NUMERIC (20,10) NULL, QTY214 NUMERIC (20,10) NULL,  QTY215  NUMERIC (20,10) NULL,
--	                    QTY216  NUMERIC (20,10) NULL,	QTY217  NUMERIC (20,10) NULL, QTY218  NUMERIC (20,10) NULL, QTY219 NUMERIC (20,10) NULL,  QTY220  NUMERIC (20,10) NULL,
--                      QTY221  NUMERIC (20,10) NULL, QTY222  NUMERIC (20,10) NULL, QTY223  NUMERIC (20,10) NULL, QTY224 NUMERIC (20,10) NULL,  QTY225  NUMERIC (20,10) NULL,
--	                    QTY226  NUMERIC (20,10) NULL,	QTY227  NUMERIC (20,10) NULL, QTY228  NUMERIC (20,10) NULL, QTY229 NUMERIC (20,10) NULL,  QTY230  NUMERIC (20,10) NULL,
--                      QTY231  NUMERIC (20,10) NULL, QTY232  NUMERIC (20,10) NULL, QTY233  NUMERIC (20,10) NULL, QTY234 NUMERIC (20,10) NULL,  QTY235  NUMERIC (20,10) NULL,
--	                    QTY236  NUMERIC (20,10) NULL,	QTY237  NUMERIC (20,10) NULL, QTY238  NUMERIC (20,10) NULL, QTY239 NUMERIC (20,10) NULL,  QTY240  NUMERIC (20,10) NULL,
--                      QTY241  NUMERIC (20,10) NULL, QTY242  NUMERIC (20,10) NULL, QTY243  NUMERIC (20,10) NULL, QTY244 NUMERIC (20,10) NULL,  QTY245  NUMERIC (20,10) NULL,
--	                    QTY246  NUMERIC (20,10) NULL,	QTY247  NUMERIC (20,10) NULL, QTY248  NUMERIC (20,10) NULL, QTY249 NUMERIC (20,10) NULL,  QTY250  NUMERIC (20,10) NULL,

--                      QTY251  NUMERIC (20,10) NULL, QTY252  NUMERIC (20,10) NULL, QTY253  NUMERIC (20,10) NULL, QTY254 NUMERIC (20,10) NULL,  QTY255  NUMERIC (20,10) NULL,
--	                    QTY256  NUMERIC (20,10) NULL,	QTY257  NUMERIC (20,10) NULL, QTY258  NUMERIC (20,10) NULL, QTY259 NUMERIC (20,10) NULL,  QTY260  NUMERIC (20,10) NULL,
--                      QTY261  NUMERIC (20,10) NULL, QTY262  NUMERIC (20,10) NULL, QTY263  NUMERIC (20,10) NULL, QTY264 NUMERIC (20,10) NULL,  QTY265  NUMERIC (20,10) NULL,
--	                    QTY266  NUMERIC (20,10) NULL,	QTY267  NUMERIC (20,10) NULL, QTY268  NUMERIC (20,10) NULL, QTY269 NUMERIC (20,10) NULL,  QTY270  NUMERIC (20,10) NULL,
--                      QTY271  NUMERIC (20,10) NULL, QTY272  NUMERIC (20,10) NULL, QTY273  NUMERIC (20,10) NULL, QTY274 NUMERIC (20,10) NULL,  QTY275  NUMERIC (20,10) NULL,
--	                    QTY276  NUMERIC (20,10) NULL,	QTY277  NUMERIC (20,10) NULL, QTY278  NUMERIC (20,10) NULL, QTY279 NUMERIC (20,10) NULL,  QTY280  NUMERIC (20,10) NULL,
--                      QTY281  NUMERIC (20,10) NULL, QTY282  NUMERIC (20,10) NULL, QTY283  NUMERIC (20,10) NULL, QTY284 NUMERIC (20,10) NULL,  QTY285  NUMERIC (20,10) NULL,
--	                    QTY286  NUMERIC (20,10) NULL,	QTY287  NUMERIC (20,10) NULL, QTY288  NUMERIC (20,10) NULL, QTY289 NUMERIC (20,10) NULL,  QTY290  NUMERIC (20,10) NULL,
--                      QTY291  NUMERIC (20,10) NULL, QTY292  NUMERIC (20,10) NULL, QTY293  NUMERIC (20,10) NULL, QTY294 NUMERIC (20,10) NULL,  QTY295  NUMERIC (20,10) NULL,
--	                    QTY296  NUMERIC (20,10) NULL,	QTY297  NUMERIC (20,10) NULL, QTY298  NUMERIC (20,10) NULL, QTY299 NUMERIC (20,10) NULL,  QTY300  NUMERIC (20,10) NULL,

--                      QTY301  NUMERIC (20,10) NULL, QTY302  NUMERIC (20,10) NULL, QTY303  NUMERIC (20,10) NULL, QTY304 NUMERIC (20,10) NULL,  QTY305  NUMERIC (20,10) NULL,
--	                    QTY306  NUMERIC (20,10) NULL,	QTY307  NUMERIC (20,10) NULL, QTY308  NUMERIC (20,10) NULL, QTY309 NUMERIC (20,10) NULL,  QTY310  NUMERIC (20,10) NULL,
--	                    QTY311  NUMERIC (20,10) NULL, QTY312  NUMERIC (20,10) NULL, QTY313  NUMERIC (20,10) NULL, QTY314 NUMERIC (20,10) NULL,  QTY315  NUMERIC (20,10) NULL,
--	                    QTY316  NUMERIC (20,10) NULL,	QTY317  NUMERIC (20,10) NULL, QTY318  NUMERIC (20,10) NULL, QTY319 NUMERIC (20,10) NULL,  QTY320  NUMERIC (20,10) NULL,
--                      QTY321  NUMERIC (20,10) NULL, QTY322  NUMERIC (20,10) NULL, QTY323  NUMERIC (20,10) NULL, QTY324 NUMERIC (20,10) NULL,  QTY325  NUMERIC (20,10) NULL,
--	                    QTY326  NUMERIC (20,10) NULL,	QTY327  NUMERIC (20,10) NULL, QTY328  NUMERIC (20,10) NULL, QTY329 NUMERIC (20,10) NULL,  QTY330  NUMERIC (20,10) NULL,
--                      QTY331  NUMERIC (20,10) NULL, QTY332  NUMERIC (20,10) NULL, QTY333  NUMERIC (20,10) NULL, QTY334 NUMERIC (20,10) NULL,  QTY335  NUMERIC (20,10) NULL,
--	                    QTY336  NUMERIC (20,10) NULL,	QTY337  NUMERIC (20,10) NULL, QTY338  NUMERIC (20,10) NULL, QTY339 NUMERIC (20,10) NULL,  QTY340  NUMERIC (20,10) NULL,
--                      QTY341  NUMERIC (20,10) NULL, QTY342  NUMERIC (20,10) NULL, QTY343  NUMERIC (20,10) NULL, QTY344 NUMERIC (20,10) NULL,  QTY345  NUMERIC (20,10) NULL,
--	                    QTY346  NUMERIC (20,10) NULL,	QTY347  NUMERIC (20,10) NULL, QTY348  NUMERIC (20,10) NULL, QTY349 NUMERIC (20,10) NULL,  QTY350  NUMERIC (20,10) NULL,

--                      QTY351  NUMERIC (20,10) NULL, QTY352  NUMERIC (20,10) NULL, QTY353  NUMERIC (20,10) NULL, QTY354 NUMERIC (20,10) NULL,  QTY355  NUMERIC (20,10) NULL,
--	                    QTY356  NUMERIC (20,10) NULL,	QTY357  NUMERIC (20,10) NULL, QTY358  NUMERIC (20,10) NULL, QTY359 NUMERIC (20,10) NULL,  QTY360  NUMERIC (20,10) NULL,
--                      QTY361  NUMERIC (20,10) NULL, QTY362  NUMERIC (20,10) NULL, QTY363  NUMERIC (20,10) NULL, QTY364 NUMERIC (20,10) NULL,
--                    ) 

--			   DECLARE @X_ITEM_ID         NVARCHAR(50) = ''

--              -- SCP_ANL_SHIPMENT_PLAN_FG/SEMI PK Parameter 
--              DECLARE @X_OPERATION_GROUP NVARCHAR(50) = ''   -- BIZ_TYPE
--              DECLARE @X_INCOTERMS       NVARCHAR(50) = ''
--              DECLARE @X_FROM_SITE       NVARCHAR(50) = ''   -- SCM_SITE_ID


--              -- SCP_ANL_PRODUCTION_PLAN PK Parameter 
--              DECLARE @X_LINE_ID         NVARCHAR(50) = ''
--              DECLARE @X_OPERATION_ID    NVARCHAR(50) = ''


--              SELECT @X_OPERATION_GROUP  = 'E'
--                    ,@X_ITEM_ID          = CELL_ITEM_ID
--                    ,@X_LINE_ID          = PROD_LINE
--                    ,@X_OPERATION_ID     = ATTRIBUTE9 
--                    ,@X_FROM_SITE        = FROM_SITE_ID
--              FROM SCP_XLS_PSI_GLOBAL_ELECTRODE  WITH (NOLOCK)
--              WHERE CREATE_FROM_YYYYMMDD = @v_batch_create_from_yyyymmdd
--			    AND DIVISION_ID          = @v_batch_division_id			-- 2022.03.23	KSW	GM JV 반영
--			    AND XLS_KEY1             = @v_batch_xls_key1

--PRINT @v_batch_measure + '12. ' +CONVERT(CHAR(23), GETDATE(), 21);
--        -----------------------------------------------------------
--        -- FROZEN 구간 복구
--        -----------------------------------------------------------
--        IF @v_batch_measure <> 'CELL_CHAR_PLAN'
--        BEGIN       

--            -------------------------------------------------------------------------------------------------------------         
--            -- 저장후 시물레이션 데이터 UPDATE
--            -------------------------------------------------------------------------------------------------------------
                  
--              DECLARE @mQry_sum2 NVARCHAR(MAX);      
   
--		          SET     @mQry_sum2 = '';
--		          SELECT  @mQry_sum2 = @mQry_sum2+','+       
--			          CASE  
--                      WHEN 1 = 1 THEN  ' SUM(CASE WHEN YYYYMMDD = '''+YYYYMMDD+'''    THEN QTY ELSE 0 END ) AS ' + 'QTY' + REPLICATE('0', 3 - LEN(ROW_NUMBER() OVER(ORDER BY YYYYMMDD) )) + CONVERT(NVARCHAR,ROW_NUMBER() OVER(ORDER BY YYYYMMDD))        
--			          END +''+CHAR(10)      
--		          FROM (       
--			          SELECT A.BASIS_YYYYMMDD                    AS YYYYMMDD    
--                      , A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 31) AS SORT_ORDER_NO      
--  	  				    FROM DBO.SCM_SYS_CALENDAR_M A  WITH(NOLOCK)	  
--					   WHERE A.BASIS_YYYYMMDD BETWEEN @p_create_from_yyyymmdd AND CONVERT(VARCHAR(8), DATEADD(day, 363, @p_create_from_yyyymmdd), 112)
--	 		            --WHERE A.BASIS_YYYYMMDD     >= @p_create_from_yyyymmdd 
--                --          AND A.BASIS_YYYYMMDD     <  CONVERT(VARCHAR(8), DATEADD(day, 364, @p_create_from_yyyymmdd), 112)		--@p_to_yyyymmdd     
--			            GROUP BY A.BASIS_YYYYMMDD       
--		          ) AS A      
--		          ORDER BY SORT_ORDER_NO  ;      

                    
--              DECLARE @mEXEC2 NVARCHAR(MAX);

--		          SET @mEXEC2 = '';
--              SET @mEXEC2 = @mEXEC2 + ' INSERT INTO #SCP_XLS_PSI_GLOBAL_MODIFY WITH (TABLOCK)  '+CHAR(10);	

                    
              

--              ------------------------------------------------------------------------------------------------------------- 
--              -- 'PROD_PLAN_AMEND'
--              -- PK : DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, SCM_SITE_ID, ITEM_ID, LINE_ID, OPERATION_ID, MEASURE, YYYYMMDD
--              ------------------------------------------------------------------------------------------------------------- 
--              DECLARE @mPROD NVARCHAR(MAX) = '';

--		          SET @mPROD = @mPROD + ' SELECT  '''+ @p_xls_key1  +''' AS XLS_KEY1  '+CHAR(10);	

--		          SET @mPROD = @mPROD + ' 				' + @mQry_sum2 +'									      '+CHAR(10);	
--  	          SET @mPROD = @mPROD + ' 		FROM SCP_ANL_PRODUCTION_PLAN X WITH (NOLOCK)  '+CHAR(10);	
--              SET @mPROD = @mPROD + ' 		WHERE 0 = 0                                 '+CHAR(10);	
--              SET @mPROD = @mPROD + ' 		AND X.DIVISION_ID         =  '''+ @p_division_id  +'''' +CHAR(10);	
--              SET @mPROD = @mPROD + ' 		AND X.PLAN_START_YYYYMMDD =  '''+ @p_plan_start_yyyymmdd+'''' +CHAR(10);		
--              SET @mPROD = @mPROD + '     AND X.PLAN_TYPE           =  '''+ @p_plan_type  +'''' +CHAR(10);	
--              SET @mPROD = @mPROD + ' 		AND X.SEQ                 =  '+ CONVERT(NVARCHAR,@p_seq)+'' +CHAR(10);	
--              SET @mPROD = @mPROD + ' 		AND X.OPERATION_GROUP     =  '''+ @X_OPERATION_GROUP+'''' +CHAR(10);	
--              SET @mPROD = @mPROD + ' 		AND X.SCM_SITE_ID         =  '''+ @X_FROM_SITE+'''' +CHAR(10);	
--              SET @mPROD = @mPROD + ' 		AND X.ITEM_ID             =  '''+ @X_ITEM_ID+'''' +CHAR(10);	
--              SET @mPROD = @mPROD + ' 		AND X.LINE_ID             =  '''+ @X_LINE_ID+'''' +CHAR(10);	
--              SET @mPROD = @mPROD + ' 		AND X.OPERATION_ID        =  '''+ @X_OPERATION_ID+'''' +CHAR(10);		
--              SET @mPROD = @mPROD + ' 		AND X.MEASURE             = ''PROD_PLAN_AMEND'' '+CHAR(10);	
--              SET @mPROD = @mPROD + ' 		AND X.YYYYMMDD            <  '''+ @p_to_yyyymmdd +''''+CHAR(10);
--              ------------------------------------------------------------------------------------------------------------- 

--              IF @v_batch_measure IN  ('PROD_PLAN_AMEND')   -- PROD
--                SET @mEXEC2 = @mEXEC2 + @mPROD

--            /*                            
--            DECLARE @POS int
--            DECLARE @LEN NVARCHAR(max)
--				    SET @POS =1;
--				    SET @LEN =LEN(@mEXEC2);
--				    WHILE @POS <= @LEN
--					    BEGIN
--						    PRINT SUBSTRING(@mEXEC2,@POS,4000);
--						    SET @POS = @POS+4000;
--					    END;
--            */
--			IF @v_batch_measure IN  ('PROD_PLAN_AMEND')   -- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 -- ')' 오류수정
--                EXEC sp_executesql @mEXEC2;
            
--        END



         --IF OBJECT_ID('tempdb..#SCM_MST_SITE') IS NOT NULL	
         --   DROP TABLE #SCM_MST_SITE
         --IF OBJECT_ID('tempdb..#DAY_SCP_XLS_PSI_GLOBAL') IS NOT NULL	
	        --  DROP TABLE #DAY_SCP_XLS_PSI_GLOBAL
         --IF OBJECT_ID('tempdb..#SCP_XLS_PSI_GLOBAL_ORG') IS NOT NULL	
	        --  DROP TABLE #SCP_XLS_PSI_GLOBAL_ORG
         IF OBJECT_ID('tempdb..#SCP_ANL_PRODUCTION_PLAN') IS NOT NULL	
	          DROP TABLE #SCP_ANL_PRODUCTION_PLAN
         IF OBJECT_ID('tempdb..#Tbl_ADM_LOOKUP_MASTER_DETAIL') IS NOT NULL	
            DROP TABLE #Tbl_ADM_LOOKUP_MASTER_DETAIL
         --IF OBJECT_ID('tempdb..#SCP_XLS_PSI_GLOBAL_MODIFY') IS NOT NULL	
	        --  DROP TABLE #SCP_XLS_PSI_GLOBAL_MODIFY

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
                                  ,@p_user_id       = @v_batch_user_id
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
                                ,@p_user_id       = @v_batch_user_id
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
                              ,@p_user_id       = @v_batch_user_id
                              ;
    return 1 


  END;

