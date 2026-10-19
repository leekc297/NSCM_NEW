/*
 * Program ID   : SCP0001_SAVE_PLANT_SITE
 * Description  : Plant 등록,수정 (외주Paker만 가능)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/12/07   byunghunjung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/04/30   ygkim			logistic_plant_id 컬럼 추가
 * 2018/07/02   ygkim			packer_item_id_suffix 컬럼 추가
 * 2018/09/14   ygkim			p_hq_vendor_code 추가 
 * 2020/02/12	hwyoon			[C20200116-000114] ESS 외주 Packer Line 계획 수립 - p_packer_line_active_yn 추가
 * 2022/04/11	lwy			    PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - p_scm_vendor_name 추가
 * 2022/04/25	lwy			    PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - 사내, 사외 분리적용
 * 2022/05/02	hsbang			frozen_type 컬럼 추가
 * 2025/11/07   kimcd           [PJ2025F254]  JV법인 ESS 혼용 생산 시스템 개선
 *                              JV ESS 생산에 따른 실제 Link scm site id 값을 ATTRIBUTE9 저장 추가
 */
CREATE PROCEDURE [dbo].[SCP0001_SAVE_PLANT_SITE]

	-- Add the parameters for the stored procedure here
	@p_active_flag			NVARCHAR(MAX),
	@p_division_id			NVARCHAR(MAX),
	@p_plant_id 			NVARCHAR(MAX),
	@p_scm_site_id 			NVARCHAR(MAX),
	@p_site_description		NVARCHAR(MAX),
    @p_country 			    NVARCHAR(MAX),
	@p_city 			    NVARCHAR(MAX),
	@p_operation_group 		NVARCHAR(MAX),
	@p_vmi_yn			    NVARCHAR(MAX),
	@p_valid_yn			    NVARCHAR(MAX),
    @p_new_yn			    NVARCHAR(MAX),
	@p_ship_frozen   		NVARCHAR(MAX),
	@p_frozen_type   		NVARCHAR(MAX),
	@p_prod_frozen  		NVARCHAR(MAX),
	@p_fp_plan_period 		NVARCHAR(MAX),
	@p_build_ahead			NVARCHAR(MAX),
	@p_created_by			NVARCHAR(MAX),
	@p_creation_date		NVARCHAR(MAX),
	@p_last_updated_by		NVARCHAR(MAX),
	@p_company_id			NVARCHAR(MAX),
	@p_logistic_plant_id	NVARCHAR(MAX),
	@p_packer_item_id_suffix	NVARCHAR(MAX),
	@p_hq_vendor_code		NVARCHAR(MAX),
	@p_packer_line_active_yn NVARCHAR(MAX),
	--@p_site_type			NVARCHAR(MAX),
	--@p_dept_id			NVARCHAR(MAX),
	--@p_osp_yn				NVARCHAR(MAX),
	--@p_city				NVARCHAR(MAX),
	--@p_site_hrcy_id		NVARCHAR(MAX),
	--@p_end_customer		NVARCHAR(MAX),
	--@p_site_id			NVARCHAR(MAX)

	@p_scm_vendor_name      NVARCHAR(MAX),
	@p_osp_yn_gb			NVARCHAR(MAX),
	@P_LINK_PLANT_SITE_ID   NVARCHAR(MAX) -- 2025/11/07 kimcd [PJ2025F254]  JV법인 ESS 혼용 생산 시스템 개선 Link scm site id 값을 ATTRIBUTE9 저장 추가
AS

BEGIN

	SET NOCOUNT ON;

	--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_active_flag			NVARCHAR(MAX);
	DECLARE @v_division_id			NVARCHAR(MAX);
	DECLARE @v_plant_id			    NVARCHAR(MAX);
	DECLARE @v_scm_site_id			NVARCHAR(MAX);
	DECLARE @v_site_description		NVARCHAR(MAX);
	DECLARE @v_country				NVARCHAR(MAX);
	DECLARE @v_operation_group		NVARCHAR(MAX);
	DECLARE @v_vmi_yn			    NVARCHAR(MAX);
	DECLARE @v_valid_yn				NVARCHAR(MAX);
	DECLARE @v_new_yn				NVARCHAR(MAX);
	DECLARE @v_fp_plan_period		NVARCHAR(MAX);
	DECLARE @v_build_ahead			NVARCHAR(MAX);
	DECLARE @v_created_by			NVARCHAR(MAX);
	DECLARE @v_creation_date		DATETIME;
	DECLARE @v_last_updated_by		NVARCHAR(MAX);
	DECLARE @v_company_id			NVARCHAR(MAX);
	DECLARE @p_site_type			NVARCHAR(MAX);
	DECLARE @p_dept_id				NVARCHAR(MAX);
	DECLARE @p_osp_yn				NVARCHAR(MAX);
	DECLARE @v_city					NVARCHAR(MAX);
	DECLARE @p_site_hrcy_id			NVARCHAR(MAX);
	DECLARE @v_frozen_type			NVARCHAR(MAX);
	DECLARE @v_ship_frozen			NVARCHAR(MAX);
	DECLARE @v_prod_frozen			NVARCHAR(MAX);
	DECLARE @p_end_customer			NVARCHAR(MAX);
	DECLARE @p_site_id				NVARCHAR(MAX);
	DECLARE @v_logistic_plant_id	NVARCHAR(MAX);
	DECLARE @v_packer_item_id_suffix	NVARCHAR(MAX);
	DECLARE @v_hq_vendor_code		NVARCHAR(MAX);
	DECLARE @v_packer_line_active_yn	NVARCHAR(MAX);
	DECLARE @v_scm_vendor_name		NVARCHAR(MAX);
	DECLARE @v_osp_yn_gb			NVARCHAR(MAX);
	DECLARE @V_LINK_PLANT_SITE_ID   NVARCHAR(MAX) -- 2025/11/07 kimcd [PJ2025F254]  JV법인 ESS 혼용 생산 시스템 개선 Link scm site id 값을 ATTRIBUTE9 저장 추가
		
	SET @v_active_flag = NULL;
	SET @v_division_id = NULL;
	SET @v_plant_id = NULL;
	SET @v_scm_site_id = NULL;
	SET @v_site_description = NULL;
	SET @v_country = NULL;	 
	SET @v_operation_group = NULL;	 
	SET @v_vmi_yn = NULL;	 
	SET @v_valid_yn = NULL;	
	SET @v_new_yn = NULL;
	SET @v_fp_plan_period = NULL;	
	SET @v_build_ahead = NULL;	
	SET @v_created_by = NULL;	  
	SET @v_creation_date = NULL;
	SET @v_last_updated_by = NULL;
	SET @v_company_id = NULL;
	SET @v_logistic_plant_id = NULL;
	SET @v_packer_item_id_suffix = NULL;
	SET @v_hq_vendor_code = NULL;
	SET @v_packer_line_active_yn = NULL;
	SET @v_scm_vendor_name = NULL;
	SET @v_osp_yn_gb = NULL;
	SET @V_LINK_PLANT_SITE_ID = NULL; -- 2025/11/07 kimcd [PJ2025F254]  JV법인 ESS 혼용 생산 시스템 개선 Link scm site id 값을 ATTRIBUTE9 저장 추가

	SET @p_site_type = 'PLANT';
	SET @p_dept_id   = 'PLANT';
	SET @p_osp_yn = 'Y' ;
	SET @p_site_hrcy_id = NULL;
	SET @v_frozen_type = NULL;
	SET @v_ship_frozen = NULL;
	SET @v_prod_frozen = NULL;
	SET @p_end_customer = NULL;
	SET @p_site_id = NULL;


	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0001_SAVE_PLANT_SITE';
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

		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);    
		--SELECT    @max_loop_cnt;
		--	WHILE LEN(@p_active_flag) > 0
		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt

		BEGIN    
			
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;
			--SELECT @mst_loop_cnt,'@mst_loop_cnt'		


			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN

				SET @v_active_flag = [dbo].[SCM_ARR_SPL_VAL](@p_active_flag, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_division_id = [dbo].[SCM_ARR_SPL_VAL](@p_division_id, @v_delimiter , @mst_loop_cnt) ; 			
				SET @v_plant_id = [dbo].[SCM_ARR_SPL_VAL](@p_plant_id, @v_delimiter , @mst_loop_cnt) ;    				
				SET @v_scm_site_id = [dbo].[SCM_ARR_SPL_VAL](@p_scm_site_id, @v_delimiter , @mst_loop_cnt) ;    				
				SET @v_site_description = [dbo].[SCM_ARR_SPL_VAL](@p_site_description, @v_delimiter , @mst_loop_cnt) ; 				
				SET @v_country = [dbo].[SCM_ARR_SPL_VAL](@p_country, @v_delimiter, @mst_loop_cnt) ; 				
				SET @v_city = [dbo].[SCM_ARR_SPL_VAL](@p_city, @v_delimiter, @mst_loop_cnt) ; 				
				SET @v_operation_group = [dbo].[SCM_ARR_SPL_VAL](@p_operation_group, @v_delimiter, @mst_loop_cnt) ; 				
				SET @v_vmi_yn = [dbo].[SCM_ARR_SPL_VAL](@p_vmi_yn, @v_delimiter, @mst_loop_cnt) ; 				
				SET @v_valid_yn = [dbo].[SCM_ARR_SPL_VAL](@p_valid_yn, @v_delimiter, @mst_loop_cnt) ; 	
				SET @v_new_yn = [dbo].[SCM_ARR_SPL_VAL](@p_new_yn, @v_delimiter, @mst_loop_cnt) ; 				 
				SET @v_frozen_type = [dbo].[SCM_ARR_SPL_VAL](@p_frozen_type, @v_delimiter, @mst_loop_cnt) ; 				
				--SET @v_ship_frozen = [dbo].[SCM_ARR_SPL_VAL](@p_ship_frozen, @v_delimiter, @mst_loop_cnt) ; 			
				SET @v_prod_frozen = [dbo].[SCM_ARR_SPL_VAL](@p_prod_frozen, @v_delimiter, @mst_loop_cnt) ; 			

				SET @v_fp_plan_period = [dbo].[SCM_ARR_SPL_VAL](@p_fp_plan_period, @v_delimiter, @mst_loop_cnt) ; 				
				SET @v_build_ahead = [dbo].[SCM_ARR_SPL_VAL](@p_build_ahead, @v_delimiter, @mst_loop_cnt) ; 				
				SET @v_created_by = [dbo].[SCM_ARR_SPL_VAL](@p_created_by, @v_delimiter, @mst_loop_cnt) ; 				
				SET @v_creation_date = CONVERT(DATETIME, [dbo].[SCM_ARR_SPL_VAL](@p_creation_date, @v_delimiter, @mst_loop_cnt) , 120);				
				SET @v_last_updated_by = [dbo].[SCM_ARR_SPL_VAL](@p_last_updated_by, @v_delimiter, @mst_loop_cnt) ; 
				SET @v_company_id = [dbo].[SCM_ARR_SPL_VAL](@p_company_id, @v_delimiter, @mst_loop_cnt) ; 
				SET @p_site_id = (SELECT t.site_id FROM scm_mst_site_sn t where t.company_id = @v_company_id);
				SET @v_logistic_plant_id = [dbo].[SCM_ARR_SPL_VAL](@p_logistic_plant_id, @v_delimiter, @mst_loop_cnt) ; 
				SET @v_packer_item_id_suffix = [dbo].[SCM_ARR_SPL_VAL](@p_packer_item_id_suffix, @v_delimiter, @mst_loop_cnt) ; 
				SET @v_hq_vendor_code = [dbo].[SCM_ARR_SPL_VAL](@p_hq_vendor_code, @v_delimiter, @mst_loop_cnt) ; 
				SET @v_packer_line_active_yn = [dbo].[SCM_ARR_SPL_VAL](@p_packer_line_active_yn, @v_delimiter, @mst_loop_cnt) ; 
				SET @v_scm_vendor_name = [dbo].[SCM_ARR_SPL_VAL](@p_scm_vendor_name, @v_delimiter, @mst_loop_cnt) ;
				SET @v_osp_yn_gb = [dbo].[SCM_ARR_SPL_VAL](@p_osp_yn_gb, @v_delimiter, @mst_loop_cnt) ;
				SET @V_LINK_PLANT_SITE_ID = NULLIF([dbo].[SCM_ARR_SPL_VAL](@P_LINK_PLANT_SITE_ID, @v_delimiter, @mst_loop_cnt),'') ; -- 2025/11/07 kimcd [PJ2025F254]  JV법인 ESS 혼용 생산 시스템 개선 Link scm site id 값을 ATTRIBUTE9 저장 추가
					
			END

			--HISTORY INSERT
			EXEC [PR_SCM_MST_SITE_HIST]
								 @v_division_id 
								,@v_scm_site_id 
								,@v_site_description
								,@p_site_type
								,@v_city
								,@v_country 
								,@v_plant_id 
								,@v_operation_group 
								,@p_dept_id
								,@v_vmi_yn
								,@v_valid_yn
								,@v_new_yn
								,@p_site_hrcy_id
								,@p_osp_yn
								,@v_frozen_type
								,@v_ship_frozen
								,@v_prod_frozen
								,@p_end_customer
								,@v_fp_plan_period
								,@v_build_ahead
								,@v_created_by
								,@v_creation_date
								,@v_last_updated_by
								,@v_company_id
								,@p_site_id		
								,@v_logistic_plant_id												
								,@v_packer_item_id_suffix		
								,@v_hq_vendor_code		
								,@v_packer_line_active_yn				
								,@V_LINK_PLANT_SITE_ID -- 2025/11/07 kimcd [PJ2025F254]  JV법인 ESS 혼용 생산 시스템 개선 Link scm site id 값을 ATTRIBUTE9 저장 추가
			 ;

			
			-- 2022/04/25
			EXEC [SCP0001_SAVE_SCM_MST_VENDOR]
								 @v_company_id
								,@v_division_id								
								,@v_plant_id 
								,@v_scm_vendor_name
								,@v_osp_yn_gb
			;			
			
			IF @mst_loop_cnt > 0 

				BEGIN       
			 
					MERGE INTO [SCM_MST_SITE] A
					USING (
							SELECT 
								 @v_division_id as division_id
								,@v_plant_id as plant_id
								,@v_scm_site_id as scm_site_id							
						  ) B
					ON(
							    A.division_id  = B.division_id
							AND A.plant_id = B.plant_id
							AND A.scm_site_id  = B.scm_site_id
						
					  )
					WHEN MATCHED THEN
						 UPDATE SET 

								site_description    = @v_site_description
							   ,country				= @v_country
							   ,city				= @v_city
							   ,operation_group		= @v_operation_group
							   ,vmi_yn				= @v_vmi_yn
							   ,valid_yn			= @v_valid_yn
							   --,ship_frozen 		= @v_ship_frozen
							   ,ship_frozen 		= CASE WHEN ISNULL(@v_frozen_type, '') = '' THEN ship_frozen
							                                                                    ELSE [dbo].[FN_GET_CALC_SHIP_FROZEN_DAY_CNT](@v_frozen_type)
													  END
							   ,prod_frozen 		= @v_prod_frozen
							   ,fp_plan_period		= @v_fp_plan_period
							   ,build_ahead			= @v_build_ahead
							   ,logistic_plant_id	= @v_logistic_plant_id
							   ,packer_item_id_suffix	= @v_packer_item_id_suffix
							   ,hq_vendor_code = @v_hq_vendor_code
							   ,attribute1			= @v_packer_line_active_yn
							   ,attribute6          = @v_frozen_type
							   ,last_updated_by		= @v_last_updated_by
							   ,last_update_date	= sysdatetime()
							   ,ATTRIBUTE9          = @V_LINK_PLANT_SITE_ID -- 2025/11/07 kimcd [PJ2025F254]  JV법인 ESS 혼용 생산 시스템 개선 Link scm site id 값을 ATTRIBUTE9 저장 추가
					                
					WHEN NOT MATCHED THEN

						INSERT	(									   
								 division_id,scm_site_id,site_description,site_type
								,city,country,plant_id,operation_group,dept_id
								,vmi_yn,valid_yn,new_yn,site_hrcy_id,osp_yn
								,ship_frozen,prod_frozen,end_customer,fp_plan_period,build_ahead
								,created_by,creation_date,last_updated_by,last_update_date
								,company_id, site_id, logistic_plant_id, packer_item_id_suffix, hq_vendor_code
								,attribute1, attribute6
								,ATTRIBUTE9 -- 2025/11/07 kimcd [PJ2025F254]  JV법인 ESS 혼용 생산 시스템 개선 Link scm site id 값을 ATTRIBUTE9 저장 추가
								)
						VALUES  
								(
								 @v_division_id ,@v_scm_site_id , @v_site_description, 'PLANT'/*@v_site_type */
								,@v_city ,@v_country ,@v_plant_id ,@v_operation_group ,'PLANT' /*@v_dept_id */
								,@v_vmi_yn, @v_valid_yn, @v_new_yn, NULL /*@site_hrcy_id*/, 'Y' /* @osp_yn*/
								,/*@v_ship_frozen*/ [dbo].[FN_GET_CALC_SHIP_FROZEN_DAY_CNT](@v_frozen_type)
								, @v_prod_frozen, NULL /*@end_customer*/, @v_fp_plan_period, @v_build_ahead
								,@v_created_by,SYSDATETIME(),@v_created_by,SYSDATETIME()
								,@v_company_id, @p_site_id,@v_logistic_plant_id, @v_packer_item_id_suffix, @v_hq_vendor_code
								,@v_packer_line_active_yn, @v_frozen_type
								,@V_LINK_PLANT_SITE_ID -- 2025/11/07 kimcd [PJ2025F254]  JV법인 ESS 혼용 생산 시스템 개선 Link scm site id 값을 ATTRIBUTE9 저장 추가
								);

			
			  END
			END

			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			
			-- 결과코드, 결과 카운트 반환
			SELECT  'S' AS result_code,  @max_loop_cnt AS result_cnt ;
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

		  -- error코드, errror 메시지 반환
		  SELECT 'F' AS result_code;
		  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
		END CATCH;
	END






