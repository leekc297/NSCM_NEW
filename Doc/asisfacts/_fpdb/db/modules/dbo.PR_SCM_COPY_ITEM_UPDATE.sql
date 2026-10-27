
CREATE PROCEDURE [dbo].[PR_SCM_COPY_ITEM_UPDATE]  
AS

/************************************************************************************************
* 프로그램 ID	: PR_SCM_COPY_ITEM_UPDATE										
* 프로그램 명	:															
* 설	   명	: JV plant 품목 정보 Copy하여 생성된 ESS Virtaul Plant 품목 정보 Update 프로시저
*				  PR_XIF_ERP_PARTNO_R 프로시저에서 IF 수신 정보 처리시 등록
*				  UI 및 다른 프로시저에 의해 update된 JV plant의 품목 정보로 ESS 가상 plant 품목 정보 동기화 
* Version		: 1.0.0														
*																			
*																			
*--------------------------------------------------------------------------------------------
* 작 성 일 자    작 성 자    사     유                                 	                   
*============================================================================================
* 2025.11.04    hrkim       [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선									
*************************************************************************************************/

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;

	-- LOG 용 변수 설정
	DECLARE	@v_proc_name	nvarchar(100) = 'PR_SCM_COPY_ITEM_UPDATE'
	DECLARE	@v_table_name	nvarchar(100)
	DECLARE	@v_message		nvarchar(250)
	DECLARE	@v_descr		nvarchar(250)
	DECLARE	@n_row_count	Integer  = 0
	DECLARE	@n_log_count	Integer  = 0
	DECLARE	@v_log_code		nvarchar(10)
	DECLARE	@sysdate		DATETIME2 = GETDATE()
	DECLARE	@v_temp1		nvarchar(1000)
	DECLARE	@v_temp2		nvarchar(1000)

	DECLARE	@ROWCOUNT		INTEGER


	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

  BEGIN TRY

		-----------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ESS 가상 및 JV Real plant 매핑 정보' 
		-----------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#VIRTAUL_REAL_MAP') IS NOT NULL DROP TABLE #VIRTAUL_REAL_MAP;
		;WITH NON_VIRTUAL_PLANT AS (
			SELECT RP.PLANT_ID
				  ,RP.COMPANY_ID
				  ,RP.DIVISION_ID
				  ,RP.SITE_ID
				  ,ROW_NUMBER() OVER (PARTITION BY RP.PLANT_ID
										  ORDER BY CASE WHEN RP.DIVISION_ID LIKE '81%' THEN 1 ELSE 2 END
												  ,RP.UPDATE_TIME DESC ) AS RN 
			 FROM SCM_PLANT_M RP WITH(NOLOCK) -- COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID
			WHERE 1=1
			  AND ISNULL(RP.PLANT_TYPE, '')  != 'VIRTUAL'
		)
		SELECT VI.ITEM_ID
			  ,VI.COMPANY_ID	AS V_COMPANY_ID
			  ,VI.DIVISION_ID	AS V_DIVISION_ID
			  ,VI.SITE_ID		AS V_SITE_ID
			  ,RP.COMPANY_ID	AS R_COMPANY_ID
			  ,RP.DIVISION_ID	AS R_DIVISION_ID
			  ,RP.SITE_ID		AS R_SITE_ID
			  ,RP.PLANT_ID		AS R_PLANT_ID
		 INTO #VIRTAUL_REAL_MAP
		 FROM SCM_ITEM_M VI WITH(NOLOCK)	-- Virtual plant company 품목 
			  INNER JOIN NON_VIRTUAL_PLANT RP
					  ON RP.PLANT_ID = VI.ITEM_RAW_PLANT_ID
					 AND RP.RN		 = 1
		WHERE 1=1
		  AND VI.ITEM_COPY_YN	= 'Y'
		  AND VI.ITEM_RAW_PLANT_ID IS NOT NULL

		BEGIN TRAN
		-----------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' JV Real plant 품목 정보로 ESS copy하여 생성된 품목 update' 
		-----------------------------------------------------------------------------------------------------------------
		UPDATE VI
		   SET VI.ITEM_ID						  = RI.ITEM_ID
			  ,VI.ITEM_NAME						  = RI.ITEM_NAME
			  ,VI.NICK_NAME						  = RI.NICK_NAME
			  ,VI.ITEM_TYPE						  = RI.ITEM_TYPE
			  ,VI.ITEM_CLASS_LEVEL_1			  = RI.ITEM_CLASS_LEVEL_1
			  ,VI.ITEM_CLASS_LEVEL_2			  = RI.ITEM_CLASS_LEVEL_2
			  ,VI.ITEM_CLASS_LEVEL_3			  = RI.ITEM_CLASS_LEVEL_3
			  ,VI.ITEM_CLASS_LEVEL_4			  = RI.ITEM_CLASS_LEVEL_4
			  ,VI.ITEM_CLASS					  = RI.ITEM_CLASS
			  ,VI.ITEM_CLASS_NAME				  = RI.ITEM_CLASS_NAME
			  ,VI.MATERIAL_CLASS				  = RI.MATERIAL_CLASS
			  ,VI.MATERIAL_CLASS_NAME			  = RI.MATERIAL_CLASS_NAME
			  ,VI.ELECTRODE_TYPE				  = RI.ELECTRODE_TYPE
			  ,VI.SIDE_TYPE						  = RI.SIDE_TYPE
			  ,VI.ITEM_GROUP_ID					  = RI.ITEM_GROUP_ID
			  ,VI.SETUP_GROUP_ID_1				  = RI.SETUP_GROUP_ID_1
			  ,VI.SETUP_GROUP_ID_2				  = RI.SETUP_GROUP_ID_2
			  ,VI.SETUP_GROUP_ID_3				  = RI.SETUP_GROUP_ID_3
			  ,VI.FLOW_ID						  = RI.FLOW_ID
			  ,VI.ERP_EOL						  = RI.ERP_EOL
			  ,VI.SCP_EOL						  = RI.SCP_EOL
			  ,VI.ITEM_UOM						  = RI.ITEM_UOM
			  ,VI.SPEC							  = RI.SPEC
			  ,VI.DEMAND_LOT_SIZE				  = RI.DEMAND_LOT_SIZE
			  ,VI.ITEM_ATTRIBUTE				  = RI.ITEM_ATTRIBUTE
			  ,VI.SETUP_ATTRIBUTE				  = RI.SETUP_ATTRIBUTE
			  ,VI.BATCH_RATIO_ID				  = RI.BATCH_RATIO_ID
			  ,VI.OUTSOURCING_FACTORY			  = RI.OUTSOURCING_FACTORY
			  ,VI.FINITE_TERM					  = RI.FINITE_TERM
			  ,VI.FINITE_TERM_UOM				  = RI.FINITE_TERM_UOM
			  ,VI.COATED_LENGTH					  = RI.COATED_LENGTH
			  ,VI.UNCOATED_LENGTH				  = RI.UNCOATED_LENGTH
			  ,VI.LENGTH_UOM					  = RI.LENGTH_UOM
			  ,VI.SLURRY_LOSS_RATE				  = RI.SLURRY_LOSS_RATE
			  ,VI.DESCRIPTION					  = RI.DESCRIPTION
			  ,VI.ACTIVE_FLAG					  = RI.ACTIVE_FLAG
			  ,VI.UPDATE_ID						  = @v_proc_name
			  ,VI.UPDATE_TIME					  = GETDATE()
			  ,VI.APPLIED_MODEL					  = RI.APPLIED_MODEL
			  ,VI.CELL_TYPE						  = RI.CELL_TYPE
			  ,VI.MAKE_AND_BUY					  = RI.MAKE_AND_BUY
			  ,VI.COLOR_ATTRIBUTE				  = RI.COLOR_ATTRIBUTE
			  ,VI.FORMATION_FLOW_ID				  = RI.FORMATION_FLOW_ID
			  ,VI.STANDARD_COST					  = RI.STANDARD_COST
			  ,VI.CURRENCY						  = RI.CURRENCY
			  ,VI.FORM_ATTRIBUTE				  = RI.FORM_ATTRIBUTE
			  ,VI.ENERGE						  = RI.ENERGE
			  ,VI.SCP_FLOW_ID					  = RI.SCP_FLOW_ID
			  ,VI.SCP_OPERATION_GROUP			  = RI.SCP_OPERATION_GROUP
			  ,VI.SCP_OPERATION_GROUP_ID		  = RI.SCP_OPERATION_GROUP_ID
			  ,VI.MDM_PROJECT_NAME				  = RI.MDM_PROJECT_NAME
			  ,VI.MIN_CAPACITY					  = RI.MIN_CAPACITY
			  ,VI.MOBILE_MODEL_ID				  = RI.MOBILE_MODEL_ID
			  ,VI.FORECAST_INFO_BIZ_TYPE		  = RI.FORECAST_INFO_BIZ_TYPE
			  ,VI.FORECAST_INFO_PRODUCT_GROUP	  = RI.FORECAST_INFO_PRODUCT_GROUP
			  ,VI.FORECAST_INFO_CELL_MODEL		  = RI.FORECAST_INFO_CELL_MODEL
			  ,VI.FORECAST_INFO_CELL_PACK_COUNT	  = RI.FORECAST_INFO_CELL_PACK_COUNT
			  ,VI.FORECAST_INFO_SPEC			  = RI.FORECAST_INFO_SPEC
			  ,VI.FORECAST_INFOR_VERSION		  = RI.FORECAST_INFOR_VERSION
			  ,VI.DOE							  = RI.DOE
			  ,VI.INSULATION_COATING			  = RI.INSULATION_COATING
			  ,VI.PACK_PRODUCT_GROUP_CODE		  = RI.PACK_PRODUCT_GROUP_CODE
			  ,VI.CELL_QUANTITY					  = RI.CELL_QUANTITY
			  ,VI.SCP_EXTRA_SPEC				  = RI.SCP_EXTRA_SPEC
			  ,VI.SCM_PIC						  = RI.SCM_PIC
			  ,VI.REP_CUSTOMER					  = RI.REP_CUSTOMER
			  ,VI.MAKER							  = RI.MAKER
			  ,VI.EVAL_CLASS					  = RI.EVAL_CLASS
			  ,VI.EVAL_CLASS_INFO				  = RI.EVAL_CLASS_INFO
			  ,VI.FP_EXTRA_SPEC					  = RI.FP_EXTRA_SPEC
			  ,VI.MRP_USE_FLAG					  = RI.MRP_USE_FLAG
		 FROM #VIRTAUL_REAL_MAP MP 
			  INNER JOIN SCM_ITEM_M VI WITH(NOLOCK)
					  ON VI.ITEM_ID				= MP.ITEM_ID
					 AND VI.COMPANY_ID			= MP.V_COMPANY_ID
					 AND VI.DIVISION_ID			= MP.V_DIVISION_ID
					 AND VI.SITE_ID				= MP.V_SITE_ID
					 AND VI.ITEM_COPY_YN	= 'Y'
			  INNER JOIN SCM_ITEM_M RI WITH(NOLOCK)
					  ON RI.ITEM_ID				= MP.ITEM_ID
					 AND RI.COMPANY_ID			= MP.R_COMPANY_ID
					 AND RI.DIVISION_ID			= MP.R_DIVISION_ID
					 AND RI.SITE_ID				= MP.R_SITE_ID
		WHERE 1=1
 
		SET @ROWCOUNT = @@ROWCOUNT

		COMMIT TRAN;

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate

		-- 임시테이블  
		IF OBJECT_ID('TEMPDB..#VIRTAUL_REAL_MAP') IS NOT NULL DROP TABLE #VIRTAUL_REAL_MAP;

  END TRY

  BEGIN CATCH
		if (xact_state() <> 0) ROLLBACK TRAN;   

		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate
  END CATCH

END


