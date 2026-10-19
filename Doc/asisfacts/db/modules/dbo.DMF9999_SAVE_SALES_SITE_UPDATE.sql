
/*
 * Program ID   : DMF9999_SAVE_SALES_SITE_UPDATE
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20190528 KHSONG Initial Release [PJ20189106] 전지본부 GSCM(DM) 고도화 프로젝트
 *
 *
 */

CREATE PROCEDURE [dbo].[DMF9999_SAVE_SALES_SITE_UPDATE]

AS

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DMF9999_SAVE_SALES_SITE_UPDATE';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @n_delete_count    INTEGER = 0;
    DECLARE @n_merge_count     INTEGER = 0;
	
	-- 시작 LOG  (START)
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	-- 시작 LOG  (END)

	-- 트랜잭션 (START)
	BEGIN TRANSACTION;

	---------------------------------------------------------------------------------------------------------------------------	
	BEGIN TRY
	---------------------------------------------------------------------------------------------------------------------------	

		---------------------------------------------------------------------------------
		BEGIN
		---------------------------------------------------------------------------------
			select *
			into TEMP_SKH_0528_1_SCM_MST_FUTURE_PRICE
			  from SCM_MST_FUTURE_PRICE 
			 where isnull(currency,'') = '' 
			   and scm_site_id = 'TTi_MO_MFM'
			   and item_id = 'MCCH350020A1'
			;

			select *
			into TEMP_SKH_0528_2_SCM_MST_FUTURE_PRICE
			  from SCM_MST_FUTURE_PRICE 
			 where isnull(currency,'') = '' 
			   and scm_site_id = 'Inventus Power_HK_HKG'
			   and item_id = 'MCP454291A10'
			;

			select *
			into TEMP_SKH_0528_3_SCM_MST_FUTURE_PRICE
			  from SCM_MST_FUTURE_PRICE 
			 where isnull(currency,'') = '' 
			   and scm_site_id = 'TTi_MO_MFM'
			   and item_id = 'MCCH329530A1'
			;

			delete
			  from SCM_MST_FUTURE_PRICE 
			 where isnull(currency,'') = '' 
			   and scm_site_id = 'TTi_MO_MFM'
			   and item_id = 'MCCH350020A1'
			;

			update SCM_MST_FUTURE_PRICE set
				   currency = 'KRW'
			 where isnull(currency,'') = '' 
			   and scm_site_id = 'Inventus Power_HK_HKG'
			   and item_id = 'MCP454291A10'
			;

			update SCM_MST_FUTURE_PRICE set
				   currency = 'USD'
			 where isnull(currency,'') = '' 
			   and scm_site_id = 'TTi_MO_MFM'
			   and item_id = 'MCCH329530A1'
			;

		---------------------------------------------------------------------------------
		END
		---------------------------------------------------------------------------------

		---------------------------------------------------------------------------------
		BEGIN
		---------------------------------------------------------------------------------
			SELECT *  
			into TEMP_SKH_0528_SCM_MST_SITE
			from SCM_MST_SITE WITH(NOLOCK) WHERE SCM_SITE_ID = 'Mitsui_FR_HSP'

			update SCM_MST_SITE set
				   END_CUSTOMER = 'Forsee'
			 where SCM_SITE_ID = 'Mitsui_FR_HSP'
			;

		---------------------------------------------------------------------------------
		END
		---------------------------------------------------------------------------------
    -- IF @@TRANCOUNT > 0 

-- 트랜잭션 (COMMIT)
    COMMIT WORK;

	---------------------------------------------------------------------------------------------------------------------------	
	END TRY
	---------------------------------------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
	BEGIN CATCH
	--------------------------------------------------------------	
		-- ROLLBACK
		-- ERROR LOG VALUE SAVE
		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();

		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/

	-- 트랜잭션 (END)
	ROLLBACK TRANSACTION;

	--------------------------------------------------------------	
	END CATCH;
	--------------------------------------------------------------	

	-- 수행결과 성공여부 DISPLAY
		IF @v_log_message IS NULL
		SELECT 'success'
	;

	-- 종료 LOG
	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = 'delete_count: '+ Convert(NVARCHAR(10), @n_delete_count)  + ' / merge_count: ' + Convert(NVARCHAR(10), @n_merge_count) ;
	SET @d_event_date = SYSDATETIME();

	-- ERROR LOG DB INSERT (로직의 TRANSACTION 종료이후수행 : 충돌방지)
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	END;
