/* =============================================================================
프로그램ID	: SCP0078_SAVE_GSCM_VOC_FILE
업  무  명	: 시스템관리 - 프로그램관리 목록
프로그램명	: GSCM system VOC
최초작성일	: 2022.04.06
최종작성일	: 2022.05.06
개  발  자	: vadabi3
입  력  값	: 
출  력  값	: 
*===================================================================================================      
*   Date       In Charge	Description      
*===================================================================================================      
* 2022.05.06   vadabi3		Create   

  EXEC SCP0078_SAVE_GSCM_VOC_FILE 
   @p_active_flag='DELETE'
 , @p_voc_no='1000000000'
 , @p_file_seq='HAMMci4LnBTFeiUSCvPcFg'
 , @p_user_id='vadabi3'

   EXEC SCP0078_SAVE_GSCM_VOC_FILE 
   @p_active_flag='MAPPING'
 , @p_voc_no='1000000050'
 , @p_file_seq='06OtOVXSM78T5aCWde4lA|운영_API 문서(1).xlsx'
 , @p_user_id='vadabi3'
============================================================================= */

CREATE PROCEDURE [dbo].[SCP0078_SAVE_GSCM_VOC_FILE]
--ALTER PROCEDURE [dbo].[SCP0078_SAVE_GSCM_VOC_FILE]
 @p_active_flag                NVARCHAR(MAX) , 
 @p_voc_no              	   NVARCHAR(MAX) ,      
 @p_file_seq				   NVARCHAR(MAX) ,    
 @p_user_id					   NVARCHAR(MAX) 
AS
BEGIN
	SET NOCOUNT ON;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0078_SAVE_GSCM_VOC_FILE';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
	DECLARE @v_file_seq   NVARCHAR(MAX);
	DECLARE @v_action_info   NVARCHAR(MAX);
    DECLARE @d_event_date   DATETIME;
	DECLARE @n_search_position   INTEGER = 0;

	SET @v_action_info = concat(@p_active_flag
								,',', CONVERT(CHAR(23), getdate(), 21)
								,',', @p_user_id
								,',', @p_file_seq )
	-- 트렌젝션 시작
	BEGIN TRAN;

	BEGIN TRY
		--###################################################################################################################
		-- 시작 LOG
		--###################################################################################################################
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


		--###################################################################################################################
		-- Update File List
		--###################################################################################################################
		SELECT @v_file_seq = ATTRIBUTE2 FROM SCM_ADM_SYS_VOC WHERE VOC_NO = @p_voc_no;

		IF @p_active_flag = 'ADD'
		BEGIN
			IF LEN(@v_file_seq) > 0
			BEGIN
			SET @v_file_seq = concat(',',@p_file_seq);
			END
			ELSE
			BEGIN
			SET @v_file_seq = @p_file_seq
			END

			UPDATE SCM_ADM_SYS_VOC 
			SET ATTRIBUTE2 =	concat(ATTRIBUTE2, @v_file_seq)
			  , ATTRIBUTE3 = @v_action_info
			WHERE VOC_NO = @p_voc_no;
		END

		ELSE IF @p_active_flag = 'DELETE'
		BEGIN

			SET @v_file_seq = REPLACE(@v_file_seq, @p_file_seq, '');
			-- 중간일 경우 조정
			SET @v_file_seq = REPLACE(@v_file_seq, ',,', ',') 
			
			-- 시작일 경우 조정
			SELECT @n_search_position = CHARINDEX(',', @v_file_seq);
			IF @n_search_position = 1
			BEGIN
			SELECT @v_file_seq = SUBSTRING(@v_file_seq, 2, 1000);
			END

			-- 끝일 경우 조정
			SELECT @n_search_position = LEN(@v_file_seq);
			SELECT @p_file_seq = SUBSTRING(@v_file_seq,@n_search_position,@n_search_position);
			IF @p_file_seq = ','
			BEGIN
			SELECT @v_file_seq = SUBSTRING(@v_file_seq, 1, @n_search_position-1);
			END

			UPDATE SCM_ADM_SYS_VOC 
			SET ATTRIBUTE2 = @v_file_seq
			  , ATTRIBUTE3 = @v_action_info
			WHERE VOC_NO = @p_voc_no;

		END

		ELSE IF @p_active_flag = 'LIST'
		BEGIN
			UPDATE SCM_ADM_SYS_VOC 
			SET ATTRIBUTE3 = @v_action_info
			WHERE VOC_NO = @p_voc_no;
		END


		ELSE IF @p_active_flag = 'MAPPING'
		BEGIN
			SELECT @v_file_seq = ATTRIBUTE4 FROM SCM_ADM_SYS_VOC WHERE VOC_NO = @p_voc_no;
			IF LEN(@v_file_seq) > 0
			BEGIN
			SET @v_file_seq = concat(@v_file_seq, ',',@p_file_seq);
			END
			ELSE
			BEGIN
			SET @v_file_seq = @p_file_seq
			END

			UPDATE SCM_ADM_SYS_VOC 
			SET ATTRIBUTE4 =	@v_file_seq
			WHERE VOC_NO = @p_voc_no;

		END

		ELSE IF @p_active_flag = 'MAPPING_DEL'
		BEGIN
			SELECT @v_file_seq = ATTRIBUTE4 FROM SCM_ADM_SYS_VOC WHERE VOC_NO = @p_voc_no;
			SET @v_file_seq = REPLACE(@v_file_seq, @p_file_seq, '');
			-- 중간일 경우 조정
			SET @v_file_seq = REPLACE(@v_file_seq, ',,', ',') 
			
			-- 시작일 경우 조정
			SELECT @n_search_position = CHARINDEX(',', @v_file_seq);
			IF @n_search_position = 1
			BEGIN
			SELECT @v_file_seq = SUBSTRING(@v_file_seq, 2, 1000);
			END

			-- 끝일 경우 조정
			SELECT @n_search_position = LEN(@v_file_seq);
			SELECT @p_file_seq = SUBSTRING(@v_file_seq,@n_search_position,@n_search_position);
			IF @p_file_seq = ','
			BEGIN
			SELECT @v_file_seq = SUBSTRING(@v_file_seq, 1, @n_search_position-1);
			END

			UPDATE SCM_ADM_SYS_VOC 
			SET ATTRIBUTE4 =	@v_file_seq
			WHERE VOC_NO = @p_voc_no;

		END


		--###################################################################################################################
		-- 종료 LOG
		--###################################################################################################################
		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			
		COMMIT TRAN;
		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  1 AS result_cnt ;


	END TRY

	BEGIN CATCH 
		--###################################################################################################################
		-- Error
		--###################################################################################################################
		  if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리

		  BEGIN
			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			--IF @@TRANCOUNT > 0
			--  COMMIT WORK;
		  END;

		  -- error코드, errror 메시지 반환
		  SELECT 'F' AS result_code;
		  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	END CATCH;
END
