



/*
 * Program ID   : [SCP0083_SAVE_DIO_CYCLE_INVENTORY_ROW_DATASET]
 * Description  : DIO Report 내 주기재고 (Cycle Stock Tab) 수정본 저장(Type Table 저장방식), 관련 DIO Report 테이블 수정
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2021/11/03   KMJ			    [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - initial release
 * 2021/12/21   KMJ			    [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - PLANT_ID 추가
 * 2022/06/10   vadabi3			SCP0083_CYCLE > VERSION 추가
 */
CREATE PROCEDURE [dbo].[SCP0083_SAVE_DIO_CYCLE_INVENTORY_ROW_DATASET]
	 @SCP0083_CYCLE			AS DBO.SCP0083_CYCLE       READONLY
AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0083_SAVE_DIO_CYCLE_INVENTORY_ROW_DATASET';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	
	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';
	
	-- 트렌젝션 시작
	BEGIN TRAN;

    -- 실행시간 확인용    
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();    
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'00:00';    

	-- BUCKET 확인
	DECLARE @v_bucket_type NVARCHAR(10) = '';
	DECLARE @v_from_yyyymmdd NVARCHAR(8) = '';
	DECLARE @v_to_yyyymmdd NVARCHAR(8) = '';

	BEGIN TRY

		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();

		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


		--------------------------------------------------------------
		-- SCP_ANL_DIO_CYCLE_INVENTORY 수정
		--------------------------------------------------------------
		UPDATE A SET
			A.PRIVATE_FLAG			= B.PRIVATE_FLAG,
			A.CYCLE					= B.CYCLE,
			A.LAST_UPDATED_BY		= B.USER_ID,
			A.LAST_UPDATE_DATE		= GETDATE()	
		FROM SCP_ANL_DIO_CYCLE_INVENTORY A, @SCP0083_CYCLE B
		WHERE A.DIVISION_ID			= B.DIVISION_ID
		AND A.PLAN_START_YYYYMMDD	= B.PLAN_START_YYYYMMDD
		AND A.PLAN_TYPE				= B.PLAN_TYPE
		AND A.SEQ					= B.SEQ
		AND A.VER					= B.VER
		AND A.NICK_NAME				= B.NICK_NAME
		AND A.PLANT_ID				= B.PLANT_ID
		AND A.TRANSPORT_MODE_LINE	= B.TRANSPORT_MODE_LINE
		;


		--------------------------------------------------------------
		-- #SCP0083_CYCLE_SUM
		--------------------------------------------------------------
		IF OBJECT_ID('tempdb..##SCP0083_CYCLE_SUM') IS NOT NULL
			DROP TABLE #SCP0083_CYCLE_SUM;

	  SELECT DIVISION_ID
			,PLAN_START_YYYYMMDD
			,PLAN_TYPE
			,SEQ
			,VER
			,NICK_NAME
			,OPERATION_GROUP
			,SUM(WEIGHT_CYCLE_STOCK) AS WEIGHT_CYCLE_STOCK
			,SUM(GLOBAL_MODEL_SUM)  AS GLOBAL_MODEL_SUM
			,SUM(GLOBAL_SITE_RATIO) AS GLOBAL_SITE_RATIO
			,MAX(USER_ID) AS USER_ID
		INTO #SCP0083_CYCLE_SUM  -- nick_name별 sum
		FROM @SCP0083_CYCLE
	GROUP BY DIVISION_ID
			,PLAN_START_YYYYMMDD
			,PLAN_TYPE
			,SEQ
			,VER
			,NICK_NAME
			,OPERATION_GROUP



		--------------------------------------------------------------
		-- SCP_ANL_DIO_REPORT > CELL 수정
		--------------------------------------------------------------
		-- 관련 DIO 정보 수정
		--WEIGHT_CYCLE_STOCK  -> PRODUCTION_CYCLE_CELL, PRODUCTION_CYCLE_PACK
        --GLOBAL_MODEL_SUM	  -> ASSEMBLY_QTY
        --GLOBAL_SITE_RATIO	  -> ASSEMBLY_TOTAL_RATIO
		 UPDATE A SET
				A.PRODUCTION_CYCLE_CELL	= B.WEIGHT_CYCLE_STOCK,
				A.ASSEMBLY_QTY			= B.GLOBAL_MODEL_SUM,
				A.ASSEMBLY_TOTAL_RATIO	= B.GLOBAL_SITE_RATIO,
				A.LAST_UPDATED_BY		= B.USER_ID,
				A.LAST_UPDATE_DATE		= GETDATE()	
			FROM SCP_ANL_DIO_REPORT A
			   , #SCP0083_CYCLE_SUM B
			WHERE A.DIVISION_ID			= B.DIVISION_ID
			AND A.PLAN_START_YYYYMMDD	= B.PLAN_START_YYYYMMDD
			AND A.PLAN_TYPE				= B.PLAN_TYPE
			AND A.SEQ					= B.SEQ
			AND A.VER					= B.VER
			AND A.NICK_NAME				= B.NICK_NAME
			--AND A.PLANT_ID				= B.PLANT_ID
			--AND A.OPERATION_GROUP		= B.OPERATION_GROUP
			AND B.OPERATION_GROUP		= 'A' -- CELL UPDATE
			;

		--------------------------------------------------------------
		-- SCP_ANL_DIO_REPORT > PACK 수정
		--------------------------------------------------------------
		UPDATE A SET
			A.PRODUCTION_CYCLE_PACK	= B.WEIGHT_CYCLE_STOCK,
			A.LAST_UPDATED_BY		= B.USER_ID,
			A.LAST_UPDATE_DATE		= GETDATE()	
		FROM SCP_ANL_DIO_REPORT A
		   , #SCP0083_CYCLE_SUM B
		WHERE A.DIVISION_ID			= B.DIVISION_ID
		AND A.PLAN_START_YYYYMMDD	= B.PLAN_START_YYYYMMDD
		AND A.PLAN_TYPE				= B.PLAN_TYPE
		AND A.SEQ					= B.SEQ
		AND A.VER					= B.VER 
		AND A.NICK_NAME				= B.NICK_NAME
		--AND A.PLANT_ID				= B.PLANT_ID
		--AND A.OPERATION_GROUP		= B.OPERATION_GROUP
		AND B.OPERATION_GROUP		= 'P' -- PACK UPDATE
		;


		--------------------------------------------------------------
		-- @MAX_VER
		--------------------------------------------------------------
		-- DIO 이력 저장
		-- 수정된 목록 이력 저장
		-- MAX VER 조회
		DECLARE @MAX_VER INT = 0;

		SELECT @MAX_VER = ISNULL(MAX(VERSION), 0) + 1
		FROM SCP_ANL_DIO_REPORT_H A WITH(NOLOCK)
		JOIN (
			SELECT DISTINCT
				DIVISION_ID
				, PLAN_START_YYYYMMDD
				, PLAN_TYPE
				, SEQ
				, VER
			FROM @SCP0083_CYCLE
		) B
		ON A.DIVISION_ID			= B.DIVISION_ID
		AND A.PLAN_START_YYYYMMDD	= B.PLAN_START_YYYYMMDD
		AND A.PLAN_TYPE				= B.PLAN_TYPE
		AND A.SEQ					= B.SEQ
		AND A.VER					= B.VER
		;
		

		--------------------------------------------------------------
		-- SCP_ANL_DIO_REPORT_H 등록
		--------------------------------------------------------------
		INSERT INTO SCP_ANL_DIO_REPORT_H (
			DIVISION_ID
			, PLAN_START_YYYYMMDD
			, PLAN_TYPE
			, SEQ
			, VER
			, NICK_NAME
			, PLANT_ID
			, FROM_SITE
			, VERSION
			, FROM_SITE_DESCRIPTION
			, OPERATION_GROUP
			, TO_SITE
			, TO_BOH_QTY
			, BOD_ID
			, TRANSPORT_MODE_LINE
			, MEASURE
			, SHIP_PLAN_QTY
			, END_CUSTOMER -- TO_SITE
			, PRODUCTION_TYPE
			, EXTRA_SPEC
			, ITEM_ID
			, CELL_ITEM_ID
			, BIZ_TYPE
			, INCOTERMS
			, CELL_AGING_LT
			, CELL_EOL_SHIPPING_LOT
			, PACK_INCOMMING
			, PACK_OPERATION_LT
			, SHIPMENT_CELL_INSPECTION_LOAD
			, SHIPMENT_CELL_INSPECTION_WAITING
			, SHIPMENT_PACK_INSPECTION_LOAD
			, SHIPMENT_PACK_INSPECTION_WAITING
			, DNI_CELL_DEPARTURE_DAYS
			, DNI_CELL_DEPARTURE_INLAND
			, DNI_CELL_WAITING_FOR_SHIPPING
			, DNI_CELL_VOYAGE
			, DNI_CELL_LAY_OFF_CUSTOMS_CLEARANCE
			, DNI_CELL_ARRIVAL_INLAND
			, DNI_PACK_DEPARTURE_DAYS
			, DNI_PACK_DEPARTURE_INLAND
			, DNI_PACK_WAITING_FOR_SHIPPING
			, DNI_PACK_VOYAGE
			, DNI_PACK_LAY_OFF_CUSTOMS_CLEARANCE
			, DNI_PACK_ARRIVAL_INLAND
			, PRE_INSPECTION_CELL
			, PRE_INSPECTION_PACK
			, VMI_CELL
			, VMI_PACK
			, FOREIGN_CORP
			, RACK_BIZ
			, DEPARTURE_INTRANSIT_VMI
			, SAFETY_STOCK_CELL
			, SAFETY_STOCK_PACK
			, OTHER_STOCK_CELL
			, OTHER_STOCK_PACK
			, PRODUCTION_CYCLE_CELL
			, PRODUCTION_CYCLE_PACK
			, STANDARD_DIO
			, ASSEMBLY_QTY
			, ASSEMBLY_TYPE_RATIO
			, ASSEMBLY_TOTAL_RATIO
			, WEIGHT_DIO
			, CREATED_BY
			, CREATION_DATE
			, LAST_UPDATED_BY
			, LAST_UPDATE_DATE
			, ATTRIBUTE1
			, ATTRIBUTE2
			, ATTRIBUTE3
			, ATTRIBUTE4
			, ATTRIBUTE5
			, ATTRIBUTE6
			, ATTRIBUTE7
			, ATTRIBUTE8
			, ATTRIBUTE9
			, ATTRIBUTE10
		)
		SELECT 
			A.DIVISION_ID
			, A.PLAN_START_YYYYMMDD
			, A.PLAN_TYPE
			, A.SEQ
			, A.VER
			, A.NICK_NAME
			, A.PLANT_ID
			, A.FROM_SITE
			, @MAX_VER
			, A.FROM_SITE_DESCRIPTION
			, A.OPERATION_GROUP
			, A.TO_SITE
			, A.TO_BOH_QTY
			, A.BOD_ID
			, A.TRANSPORT_MODE_LINE
			, A.MEASURE
			, A.SHIP_PLAN_QTY
			, A.END_CUSTOMER -- TO_SITE
			, A.PRODUCTION_TYPE
			, A.EXTRA_SPEC
			, A.ITEM_ID
			, A.CELL_ITEM_ID
			, A.BIZ_TYPE
			, A.INCOTERMS
			, A.CELL_AGING_LT
			, A.CELL_EOL_SHIPPING_LOT
			, A.PACK_INCOMMING
			, A.PACK_OPERATION_LT
			, A.SHIPMENT_CELL_INSPECTION_LOAD
			, A.SHIPMENT_CELL_INSPECTION_WAITING
			, A.SHIPMENT_PACK_INSPECTION_LOAD
			, A.SHIPMENT_PACK_INSPECTION_WAITING
			, A.DNI_CELL_DEPARTURE_DAYS
			, A.DNI_CELL_DEPARTURE_INLAND
			, A.DNI_CELL_WAITING_FOR_SHIPPING
			, A.DNI_CELL_VOYAGE
			, A.DNI_CELL_LAY_OFF_CUSTOMS_CLEARANCE
			, A.DNI_CELL_ARRIVAL_INLAND
			, A.DNI_PACK_DEPARTURE_DAYS
			, A.DNI_PACK_DEPARTURE_INLAND
			, A.DNI_PACK_WAITING_FOR_SHIPPING
			, A.DNI_PACK_VOYAGE
			, A.DNI_PACK_LAY_OFF_CUSTOMS_CLEARANCE
			, A.DNI_PACK_ARRIVAL_INLAND
			, A.PRE_INSPECTION_CELL
			, A.PRE_INSPECTION_PACK
			, A.VMI_CELL
			, A.VMI_PACK
			, A.FOREIGN_CORP
			, A.RACK_BIZ
			, A.DEPARTURE_INTRANSIT_VMI
			, A.SAFETY_STOCK_CELL
			, A.SAFETY_STOCK_PACK
			, A.OTHER_STOCK_CELL
			, A.OTHER_STOCK_PACK
			, A.PRODUCTION_CYCLE_CELL
			, A.PRODUCTION_CYCLE_PACK
			, A.STANDARD_DIO
			, A.ASSEMBLY_QTY
			, A.ASSEMBLY_TYPE_RATIO
			, A.ASSEMBLY_TOTAL_RATIO
			, A.WEIGHT_DIO
			, A.CREATED_BY
			, A.CREATION_DATE
			, A.LAST_UPDATED_BY
			, A.LAST_UPDATE_DATE
			, A.ATTRIBUTE1
			, A.ATTRIBUTE2
			, A.ATTRIBUTE3
			, A.ATTRIBUTE4
			, A.ATTRIBUTE5
			, A.ATTRIBUTE6
			, A.ATTRIBUTE7
			, A.ATTRIBUTE8
			, A.ATTRIBUTE9
			, A.ATTRIBUTE10
		FROM SCP_ANL_DIO_REPORT A WITH(NOLOCK)
		JOIN (
			SELECT DISTINCT
				DIVISION_ID
				, PLAN_START_YYYYMMDD
				, PLAN_TYPE
				, SEQ
				, VER
			FROM @SCP0083_CYCLE
		) B
		ON A.DIVISION_ID			= B.DIVISION_ID
		AND A.PLAN_START_YYYYMMDD	= B.PLAN_START_YYYYMMDD
		AND A.PLAN_TYPE				= B.PLAN_TYPE
		AND A.SEQ					= B.SEQ
		AND A.VER					= B.VER
		;


		-- 임시 운영반영시에 주석처리 할것.    
		SET @v_exec_time  =  REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
							 REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))    

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description  = N'[' + @v_exec_time + ']';   
		SET @d_event_date = SYSDATETIME();
		
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		COMMIT TRAN;			
		
		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  1 AS result_cnt ;

	END TRY

	BEGIN CATCH 
		BEGIN
			if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리
						
			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			--IF @@TRANCOUNT > 0
			--  COMMIT WORK;
					  

			-- error코드, errror 메시지 반환
			--SELECT 'F' AS result_code;

			IF( @v_err_code IS NULL OR @v_err_code ='')
				SET @v_err_code= ERROR_NUMBER() ;
			IF( @v_err_message IS NULL OR @v_err_message ='') 
				SET @v_err_message=  ERROR_MESSAGE();
						
			/* 에러 메시지, 에러 데이터  반환   */	
			SELECT  @v_err_code			AS err_code
				   ,@v_err_message		AS err_message
				     
			; 
		END;
	END CATCH;
END




