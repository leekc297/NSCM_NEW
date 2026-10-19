---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


/*
 * Program ID   : PR_DM_MST_SITE_PROJECT_ITEM_MAPPING_HIST
 * Description  : SCM MST SITE ITEM H HISTORYT
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 11. 29    DWOK/DWPARK      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 20180618  KHSONG 소형관련 신규컬럼 5개 추가
 * 20180727 KHSONG attribute4 추가
 * 20181031 KHSONG attribute6 추가
 * 20190408 KHSONG 신규컬럼추가
 * 20191015 KHSONG [CSR ID:4098705] GSCM(DM)에서 Incoterms 조건에 따라 Customer EDI의 DP 반영 요청의 건
 * 20191021    KYH			[CSR ID:4103445] 컬럼통합. REPORT_GROUP4, 5 --> REPORT_GROUP4 
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 */

CREATE PROCEDURE [dbo].[PR_DM_MST_SITE_PROJECT_ITEM_MAPPING_HIST]

	@p_division_id				NVARCHAR(MAX),
	@p_project_code				NVARCHAR(MAX),
	@p_scm_site_id				NVARCHAR(MAX),
	@p_item_id					NVARCHAR(MAX),
	@p_currency					NVARCHAR(MAX),
	@p_cell_per_car				NVARCHAR(MAX),
	@p_cell_per_module			NVARCHAR(MAX),
	@p_liability_period			NVARCHAR(MAX),
	@p_sales_plan_adjust_yn		NVARCHAR(MAX),
	@p_item_hrcy_id				NVARCHAR(MAX),
	@p_valid_yn					NVARCHAR(MAX),
	@p_bpms_exist				NVARCHAR(MAX),

	-- 20180618  KHSONG 소형관련 신규컬럼 5개 추가
	@p_cust_group				NVARCHAR(MAX),
	@p_cust_group_dtl			NVARCHAR(MAX),
	@p_owner					NVARCHAR(MAX),
	@p_application				NVARCHAR(MAX),
	@p_route					NVARCHAR(MAX),
	-- 20180618  KHSONG 소형관련 신규컬럼 5개 추가

	@p_created_by				NVARCHAR(MAX),
	@p_attribute1				NVARCHAR(MAX),
	@p_attribute2				NVARCHAR(MAX),
	@p_attribute4				NVARCHAR(MAX), -- 20180727 KHSONG attribute4 추가
	@p_attribute6				NVARCHAR(MAX), -- 20181031
	@p_edi_lt					NVARCHAR(MAX), -- 20191015 KHSONG [CSR ID:4098705] EDI Leadtime 컬럼추가
    -- 20190408 KHSONG 신규컬럼추가
	@p_report_group1			NVARCHAR(MAX),
    @p_report_group2			NVARCHAR(MAX),
    @p_report_group3			NVARCHAR(MAX),
    @p_report_group4			NVARCHAR(MAX),
    --@p_report_group5			NVARCHAR(MAX),
    @p_report_group6			NVARCHAR(MAX),
    @p_report_group7			NVARCHAR(MAX),
    @p_report_group8			NVARCHAR(MAX)
	
    --@p_os_corp					NVARCHAR(MAX),
    --@p_contribution_type		NVARCHAR(MAX)
		
AS

BEGIN

	SET XACT_ABORT ON;
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @v_division_id				NVARCHAR(MAX);
	DECLARE @v_project_code				NVARCHAR(MAX);
	DECLARE @v_scm_site_id				NVARCHAR(MAX);
	DECLARE @v_item_id					NVARCHAR(MAX);
	DECLARE @v_currency					NVARCHAR(MAX);
	DECLARE @v_cell_per_car				NVARCHAR(MAX);
	DECLARE @v_cell_per_module			NVARCHAR(MAX);
	DECLARE @v_liability_period			NVARCHAR(MAX);
	DECLARE @v_sales_plan_adjust_yn		NVARCHAR(MAX);
	DECLARE @v_item_hrcy_id				NVARCHAR(MAX);
	DECLARE @v_valid_yn					NVARCHAR(MAX);
	DECLARE @v_bpms_exist				NVARCHAR(MAX);
	DECLARE @v_created_by				NVARCHAR(MAX);
	DECLARE @n_history_seq				INTEGER;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_MST_SITE_PROJECT_ITEM_MAPPING_HIST';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	
	--[C20200909-000203] LOG 표준화 적용
		-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		-- 트랜잭션 (START)
		BEGIN TRANSACTION PROJECT_ITEM_MAPPING_HIST;

	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	

			BEGIN    
				SET @n_history_seq = NEXT VALUE FOR SEQ1_SCM_MST_SITE_ITEM_H
				   BEGIN
						
						--[2018-03-19][수정]
						--MERGE INTO [dbo].[SCM_MST_SITE_ITEM_H] A
						--USING (
						--		SELECT
						--			 @p_division_id				AS DIVISION_ID
						--			,@p_project_code			AS PROJECT_CODE
						--			,@p_scm_site_id				AS SCM_SITE_ID
						--			,@p_item_id					AS ITEM_ID
						--			,@p_currency				AS CURRENCY
						--			,@p_liability_period		AS LIABILITY_PERIOD
						--			,@p_sales_plan_adjust_yn	AS SALES_PLAN_ADJUST_YN
						--			,@p_item_hrcy_id			AS ITEM_HRCY_ID
						--			,@p_valid_yn				AS VALID_YN
						--			,@p_bpms_exist				AS BPMS_EXIST
						--	  ) B
						--ON (
						--			A.DIVISION_ID			= B.DIVISION_ID
						--		AND A.PROJECT_CODE			= B.PROJECT_CODE
						--		AND A.SCM_SITE_ID			= B.SCM_SITE_ID
						--		AND A.ITEM_ID				= B.ITEM_ID
						--		AND A.CURRENCY				= B.CURRENCY
						--		AND A.LIABILITY_PERIOD		= B.LIABILITY_PERIOD
						--		AND A.SALES_PLAN_ADJUST_YN	= B.SALES_PLAN_ADJUST_YN
						--		AND A.ITEM_HRCY_ID			= B.ITEM_HRCY_ID
						--		AND A.VALID_YN				= B.VALID_YN
						--		AND A.BPMS_EXIST			= B.BPMS_EXIST
						--   )
						----WHEN MATCHED THEN
						--	--UPDATE SET
						--	--			 last_updated_by = @p_created_by
						--	--			,last_update_date = sysdatetime()
						--WHEN NOT MATCHED THEN
						--	INSERT	  (
						--			   DIVISION_ID ,HISTORY_SEQ, PROJECT_CODE ,SCM_SITE_ID 
						--			  ,ITEM_ID ,CURRENCY ,LIABILITY_PERIOD ,SALES_PLAN_ADJUST_YN ,ITEM_HRCY_ID ,VALID_YN ,BPMS_EXIST
						--			  ,CREATED_BY ,CREATION_DATE ,LAST_UPDATED_BY ,LAST_UPDATE_DATE)
						--	VALUES  
						--			  (
						--			   @p_division_id , @n_history_seq ,@p_project_code, @p_scm_site_id 
						--			  ,@p_item_id ,@p_currency ,@p_liability_period ,@p_sales_plan_adjust_yn ,@p_item_hrcy_id ,@p_valid_yn ,@p_bpms_exist
						--			  ,@p_created_by ,SYSDATETIME() ,@p_created_by ,SYSDATETIME()
						--			  );

							INSERT	INTO  [dbo].[SCM_MST_SITE_ITEM_H]
							(									   
										DIVISION_ID ,HISTORY_SEQ, PROJECT_CODE ,SCM_SITE_ID 
									  ,ITEM_ID ,CURRENCY ,CELL_PER_CAR, CELL_PER_MODULE, LIABILITY_PERIOD ,SALES_PLAN_ADJUST_YN ,ITEM_HRCY_ID ,VALID_YN ,BPMS_EXIST
									  ,cust_group,cust_group_dtl,owner,application,route  -- 20180618  KHSONG 소형관련 신규컬럼 5개 추가
									  ,CREATED_BY ,CREATION_DATE ,LAST_UPDATED_BY ,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE4,ATTRIBUTE6 -- 20180727 KHSONG attribute4 추가
									  ,edi_lt  -- 20191015 KHSONG [CSR ID:4098705] EDI Leadtime 컬럼추가
									  ,report_group1,report_group2,report_group3,report_group4
									  -- ,report_group5								-- 20191021 kyh report_group4, 5 통합 
									  ,report_group6,report_group7,report_group8  -- 20190408 KHSONG 신규컬럼추가
									  --,os_corp,contribution_type
							)		   
							VALUES  
							(
									   @p_division_id , @n_history_seq ,@p_project_code, @p_scm_site_id 
									  ,@p_item_id ,@p_currency ,@p_cell_per_car, @p_cell_per_module, @p_liability_period ,@p_sales_plan_adjust_yn ,@p_item_hrcy_id ,@p_valid_yn ,@p_bpms_exist
									  ,@p_cust_group,@p_cust_group_dtl,@p_owner,@p_application,@p_route  -- 20180618  KHSONG 소형관련 신규컬럼 5개 추가
									  ,@p_created_by ,SYSDATETIME() ,@p_created_by ,SYSDATETIME(),@p_attribute1,@p_attribute2,@p_attribute4,@p_attribute6 -- 20180727 KHSONG attribute4 추가
									  ,@p_edi_lt  -- 20191015 KHSONG [CSR ID:4098705] EDI Leadtime 컬럼추가
									  ,@p_report_group1,@p_report_group2,@p_report_group3,@p_report_group4
									  --,@p_report_group5
									  ,@p_report_group6,@p_report_group7,@p_report_group8  -- 20190408 KHSONG 신규컬럼추가
									  --,@p_os_corp,@p_contribution_type
							   );


				   END
				
			END

				-- 종료 LOG
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();

			EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		COMMIT WORK;

		END TRY

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	--[C20200909-000203] LOG 표준화 적용
	-- 트랜잭션 (END)
	ROLLBACK TRANSACTION  PROJECT_ITEM_MAPPING_HIST;

			  -- ERROR LOG
			  SET @v_log_type = 'ERROR';
			  SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
			  SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
			  SET @d_event_date = SYSDATETIME();
			  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	  
			  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	

	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	
	
		--[C20200909-000203] LOG 표준화 적용
		-- 종료 LOG
		SET @v_log_type    = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date  = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


	END;


