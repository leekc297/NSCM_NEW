
/*
 * Program ID   : PR_DM_MST_BOD_ITEM_HIST
 * Description  : SCM MST BOD ITEM HISTORYT INSERT	
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 11. 29    DWOK/DWPARK      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 *
 */

CREATE PROCEDURE [dbo].[PR_DM_MST_BOD_ITEM_HIST]

	@p_division_id		NVARCHAR(MAX),
	@p_bod_id			NVARCHAR(MAX),
	@p_item_id			NVARCHAR(MAX),
	@p_eff_start_date	NVARCHAR(MAX),
	@p_lot_size			NVARCHAR(MAX),
	@p_frozen_period	NVARCHAR(MAX),
	@p_eff_end_date		NVARCHAR(MAX),
	@p_valid_yn			NVARCHAR(MAX),
	@p_created_by		NVARCHAR(MAX)

	--@p_OK_description	NVARCHAR(1200) OUTPUT		-- 자식 프로시저 성공/에러 셋팅 (필요없음 20180223 songkeeho)
AS

BEGIN

	SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	DECLARE @v_division_id			NVARCHAR(MAX);
	DECLARE @v_bod_id				NVARCHAR(MAX);
	DECLARE @v_item_id				NVARCHAR(MAX);
	DECLARE @v_eff_start_date		NVARCHAR(MAX);
	DECLARE @v_lot_size				NVARCHAR(MAX);
	DECLARE @v_frozen_period		NVARCHAR(MAX);
	DECLARE @v_eff_end_date			NVARCHAR(MAX);
	DECLARE @v_created_by			NVARCHAR(MAX);
	DECLARE @n_history_seq			INTEGER;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_MST_BOD_ITEM_HIST';
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
		BEGIN TRANSACTION PR_DM_MST_BOD_ITEM_HIST;

		BEGIN TRY

			BEGIN    

				SET @n_history_seq = NEXT VALUE FOR SEQ1_SCM_MST_BOD_ITEM_H
				   BEGIN
						
						--[2018-03-19][수정]
						--MERGE INTO [dbo].[SCM_MST_BOD_ITEM_H] A
						--USING (
						--		SELECT
						--			 @p_division_id		AS DIVISION_ID
						--			,@p_bod_id			AS BOD_ID
						--			,@p_item_id			AS ITEM_ID
						--			,@p_eff_start_date	AS EFF_START_DATE
						--			,@p_lot_size		AS LOT_SIZE
						--			,@p_frozen_period	AS FROZEN_PERIOD
						--			,@p_eff_end_date	AS EFF_END_DATE
						--			,@p_valid_yn		AS VALID_YN
						--	  ) B
						--ON (
						--			A.DIVISION_ID		= B.DIVISION_ID
						--		AND A.BOD_ID			= B.BOD_ID
						--		AND A.ITEM_ID			= B.ITEM_ID
						--		AND A.EFF_START_DATE	= B.EFF_START_DATE
						--		AND A.LOT_SIZE			= B.LOT_SIZE
						--		AND A.FROZEN_PERIOD		= B.FROZEN_PERIOD
						--		AND A.EFF_END_DATE		= B.EFF_END_DATE
						--		AND A.VALID_YN			= B.VALID_YN
						--   )
						----WHEN MATCHED THEN
						--	--UPDATE SET
						--	--			 last_updated_by = @p_created_by
						--	--			,last_update_date = sysdatetime()
						--WHEN NOT MATCHED THEN
						--	INSERT	  (
						--			   DIVISION_ID ,HISTORY_SEQ, BOD_ID ,ITEM_ID 
						--			  ,EFF_START_DATE ,LOT_SIZE ,FROZEN_PERIOD ,EFF_END_DATE ,VALID_YN
						--			  ,CREATED_BY ,CREATION_DATE ,LAST_UPDATED_BY ,LAST_UPDATE_DATE)
						--	VALUES  
						--			  (
						--			   @p_division_id , @n_history_seq ,@p_bod_id, @p_item_id 
						--			  ,@p_eff_start_date ,@p_lot_size ,@p_frozen_period ,@p_eff_end_date ,@p_valid_yn
						--			  ,@p_created_by ,SYSDATETIME() ,@p_created_by ,SYSDATETIME()
						--			  );

							INSERT	INTO  [dbo].[SCM_MST_BOD_ITEM_H]
							(									   
									   DIVISION_ID ,HISTORY_SEQ, BOD_ID ,ITEM_ID 
									  ,EFF_START_DATE ,LOT_SIZE ,FROZEN_PERIOD ,EFF_END_DATE ,VALID_YN
									  ,CREATED_BY ,CREATION_DATE ,LAST_UPDATED_BY ,LAST_UPDATE_DATE
							)
							VALUES  
							(
									   @p_division_id , @n_history_seq ,@p_bod_id, @p_item_id 
									  ,@p_eff_start_date ,@p_lot_size ,@p_frozen_period ,@p_eff_end_date ,@p_valid_yn
									  ,@p_created_by ,SYSDATETIME() ,@p_created_by ,SYSDATETIME()
						   );

				   END
		
					--SET @p_OK_description = 'OK';

					--RETURN;
				
			END

          COMMIT WORK;

		END TRY

     BEGIN CATCH

	 --[C20200909-000203] LOG 표준화 적용
	-- 트랜잭션 (END)
	ROLLBACK TRANSACTION  PR_DM_MST_BOD_ITEM_HIST;
      -- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


    END CATCH

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END; 








