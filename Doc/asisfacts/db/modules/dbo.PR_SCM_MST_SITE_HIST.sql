/*
 * Program ID   : PR_SCM_MST_SITE_HIST
 * Description  : Site Master History 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017.12.07   byunghunjung      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/04/30   ygkim			logistic_plant_id 컬럼 추가
 * 2018/07/02   ygkim			packer_item_id_suffix 컬럼 추가
 * 2018/09/14   ygkim			p_hq_vendor_code 추가 
 * 2020/02/12	hwyoon			[C20200116-000114] ESS 외주 Packer Line 계획 수립 - p_packer_line_active_yn 추가
 * 2022/05/02	hsbang			frozen_type 컬럼 추가
 * 2025/11/07   kimcd           [PJ2025F254]  JV법인 ESS 혼용 생산 시스템 개선
 *                              JV ESS 생산에 따른 실제 Link scm site id 값을 ATTRIBUTE9 저장 추가
 */
CREATE PROCEDURE [dbo].[PR_SCM_MST_SITE_HIST]

	@p_division_id			NVARCHAR(MAX),
	@p_scm_site_id 			NVARCHAR(MAX),
	@p_site_description		NVARCHAR(MAX),
	@p_site_type			NVARCHAR(MAX),
	@p_city					NVARCHAR(MAX),
    @p_country 			    NVARCHAR(MAX),
	@p_plant_id				NVARCHAR(MAX),
	@p_operation_group 		NVARCHAR(MAX),
	@p_dept_id				NVARCHAR(MAX),
	@p_vmi_yn			    NVARCHAR(MAX),
	@p_valid_yn			    NVARCHAR(MAX),
    @p_new_yn			    NVARCHAR(MAX),
	@p_site_hrcy_id			NVARCHAR(MAX),
	@p_osp_yn				NVARCHAR(MAX),
	@p_frozen_type			NVARCHAR(MAX),
	@p_ship_frozen			NVARCHAR(MAX),
	@p_prod_frozen			NVARCHAR(MAX),
	@p_end_customer			NVARCHAR(MAX),
	@p_fp_plan_period 		NVARCHAR(MAX),
	@p_build_ahead			NVARCHAR(MAX),
	@p_created_by			NVARCHAR(MAX),
	@p_creation_date		DATETIME,
	@p_last_updated_by		NVARCHAR(MAX),
	@p_company_id			NVARCHAR(MAX),
	@p_site_id				NVARCHAR(MAX),
	@p_logistic_plant_id	NVARCHAR(MAX),
	@p_packer_item_id_suffix	NVARCHAR(MAX),
	@p_hq_vendor_code	NVARCHAR(MAX),
	@p_packer_line_active_yn NVARCHAR(MAX)=null,
	@P_LINK_PLANT_SITE_ID   NVARCHAR(MAX) -- 2025/11/07 kimcd [PJ2025F254]  JV법인 ESS 혼용 생산 시스템 개선 Link scm site id 값을 ATTRIBUTE9 저장 추가
AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @n_history_seq	INTEGER;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_MST_SITE_HIST';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;


		BEGIN TRY

				-- 시작 LOG
			SET @v_log_type = 'START';
			SET @v_log_message = '########## Start of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		   
				
			BEGIN    
				SET @n_history_seq = NEXT VALUE FOR SEQ1_SCM_MST_SITE_H
				
				   BEGIN
					INSERT	INTO  SCM_MST_SITE_H(									   
								 history_seq,division_id,scm_site_id,site_description,site_type
								,city,country,plant_id,operation_group,dept_id
								,vmi_yn,valid_yn,new_yn,site_hrcy_id,osp_yn
								,ship_frozen,prod_frozen,end_customer,fp_plan_period,build_ahead,logistic_plant_id, packer_item_id_suffix
								,created_by,creation_date,last_updated_by,last_update_date,history_creation_date
								,company_id, site_id,hq_vendor_code, ATTRIBUTE1, ATTRIBUTE6, ATTRIBUTE9) -- 2025/11/07 kimcd [PJ2025F254]  JV법인 ESS 혼용 생산 시스템 개선 Link scm site id 값을 ATTRIBUTE9 저장 추가
					VALUES  
								(
								 @n_history_seq, @p_division_id ,@p_scm_site_id , @p_site_description, @p_site_type
								,@p_city ,@p_country ,@p_plant_id ,@p_operation_group ,@p_dept_id 
								,@p_vmi_yn, @p_valid_yn, @p_new_yn, @p_site_hrcy_id, @p_osp_yn
								,@p_ship_frozen,@p_prod_frozen,@p_end_customer,@p_fp_plan_period,@p_build_ahead,@p_logistic_plant_id, @p_packer_item_id_suffix
								,@p_created_by,@p_creation_date,@p_last_updated_by,SYSDATETIME(),SYSDATETIME()
								,@p_company_id, @p_site_id,@p_hq_vendor_code, @p_packer_line_active_yn, @p_frozen_type
								,@P_LINK_PLANT_SITE_ID -- 2025/11/07 kimcd [PJ2025F254]  JV법인 ESS 혼용 생산 시스템 개선 Link scm site id 값을 ATTRIBUTE9 저장 추가
								);
				   END
			END

			SET @v_log_type = 'END';
				SET @v_log_message = '########## END of procedure ##########';
				SET @v_description = '';
				SET @d_event_date = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		END TRY

		BEGIN CATCH
		  BEGIN
			INSERT INTO scm_sys_log_batch (program_name
										  ,log_type
										  ,log_count
										  ,log_message
										  ,description
										  ,event_date
										  ,creation_date
										  ,created_by
										  ,last_update_date
										  ,last_updated_by)
			VALUES (ERROR_PROCEDURE()
				   ,'ERROR'
				   ,NULL
				   ,ERROR_MESSAGE()
				   ,NULL
				   ,SYSDATETIME()
				   ,SYSDATETIME()
				   ,ERROR_PROCEDURE()
				   ,SYSDATETIME()
				   ,ERROR_PROCEDURE());

			IF @@TRANCOUNT > 0
			  COMMIT WORK;
		  END;
		END CATCH;
	END;





