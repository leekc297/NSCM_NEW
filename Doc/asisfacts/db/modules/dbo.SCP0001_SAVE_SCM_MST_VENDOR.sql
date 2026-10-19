
/*
 * Program ID   : SCP0001_SAVE_SCM_MST_VENDOR
 * Description  : Shipping Result Check VOC 적용
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022/04/11   lwy   Initial Release PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - GSCM_VENDOR  적용.
 * 2022/04/25	lwy	  PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - 사내, 사외 분리적용
 */

CREATE PROCEDURE [dbo].[SCP0001_SAVE_SCM_MST_VENDOR]
	 @p_company_id 		nvarchar(60)
	,@p_division_id		nvarchar(20)
	,@p_plant_id	    nvarchar(20)
	,@p_vendor_name		nvarchar(100)
	,@p_osp_yn_gb       nvarchar(100)
AS
BEGIN

	--SET @v_qty = NULL;

	-- LOG 용 변수 설정
	DECLARE @v_program_name NVARCHAR(150) = 'SCP0001_SAVE_SCM_MST_VENDOR';
	DECLARE @v_log_type     NVARCHAR(30);
	DECLARE @n_log_count    INTEGER = 0;
	DECLARE @v_log_message  NVARCHAR(1000);
	DECLARE @v_description  NVARCHAR(500);
	DECLARE @d_event_date   DATETIME;

	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';

	BEGIN TRY

		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


		SET @d_event_date = SYSDATETIME();

		IF @p_osp_yn_gb = 'Y'
		BEGIN
			--사외 수정		
			UPDATE A
			   SET ATTRIBUTE1 = @p_vendor_name
			FROM SCM_MST_VENDOR A WITH(NOLOCK)
			WHERE 1 = 1				
			  AND A.COMPANY_ID  = @p_company_id
			  AND A.VENDOR_CODE = @p_plant_id
			;
		END
		ELSE IF @p_osp_yn_gb = 'N'
		BEGIN
			--사내 수정		
			UPDATE A
			   SET DESCRIPTION = @p_vendor_name
			FROM SCM_PLANT_M_SN A WITH(NOLOCK)    -- FP
			WHERE 1 = 1				
			  --AND A.COMPANY_ID  = @p_company_id			  
			  --AND A.SITE_ID     = @p_site_id
			  AND A.DIVISION_ID = @p_division_id
			  AND A.PLANT_ID    = @p_plant_id
			;

		END

		
		
		
		
		
		SELECT 'S' AS RESULT_CODE, '' AS MSG

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	END TRY

	BEGIN CATCH
		BEGIN		
			INSERT INTO scm_sys_log_batch (  program_name
											,log_type
											,log_count
											,log_message
											,description
											,event_date
											,creation_date
											,created_by
											,last_update_date
											,last_updated_by)
			VALUES ( ERROR_PROCEDURE()
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
			IF( @v_err_message IS NULL OR @v_err_message ='')
				SELECT 'F' AS result_code, '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE() AS ERR_MESSAGE ;
			ELSE
				SELECT 'N' AS result_code, @v_err_message AS ERR_MESSAGE ;
	
	END CATCH;

END










