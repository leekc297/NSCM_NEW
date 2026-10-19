
/*
 * Program ID   : PR_SCP_MST_PIC_INFO
 * Description  : MRP PIC INFO 데이터 이관
 * Program History
 * 
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022.07.27   vadabi3        Create	XIF_MRP_PIC_INFO_OUT_IF_R => SCP_MST_PIC_INFO
 * 2022.07.27   vadabi3        Modify	SCP_MST_PIC_INFO 전체 삭제 후 새로 입력하는 방식 (=PI 요청)
 ----------------------------------------------------------------------------------------------------
 EXEC PR_SCP_MST_PIC_INFO
 */
CREATE PROCEDURE [dbo].[PR_SCP_MST_PIC_INFO]
AS

  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON; 

    -- LOG 용 변수 설정
    DECLARE @v_batch_user NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_MST_PIC_INFO';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @v_ifseqno     NVARCHAR(30); 
	DECLARE @n_success_cnt	BIGINT;
	DECLARE @n_fail_cnt  	BIGINT;
	SET @n_success_cnt	= 0 ;
	SET @n_fail_cnt 	= 0 ; 	

	-- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN
      --------------------------------------------------------------------------------
      -- 1. XIF_MRP_PIC_INFO_OUT_IF_R_SN 배치 대상 count
      -------------------------------------------------------------------------------- 
		SELECT @n_log_count = COUNT(*) FROM XIF_MRP_PIC_INFO_OUT_IF_R_SN WHERE  ISNULL(PROC_FLAG,'N') = 'N';
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'STEP1', @n_log_count, N'배치 대상 Count ( PROC_FLAG : N => P) ', @v_description, @d_event_date;

   	    UPDATE XIF_MRP_PIC_INFO_OUT_IF_R_SN 
		SET    PROC_FLAG = 'P'
		      ,PROC_DATE = GETDATE()
		WHERE  ISNULL(PROC_FLAG,'N') = 'N';
		
		
	  --------------------------------------------------------------------------------
      -- 2. TRUNCATE SCP_MST_PIC_INFO (전체 데이터 삭제 후 입력) 
	  --    배치 대상 없을 시 기존 데이터 유지
      -------------------------------------------------------------------------------
	  IF (@n_log_count < 1)
		BEGIN
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'BATCH SKIP', @n_log_count, N'NO BATCH DATA', @v_description, @d_event_date;
			RETURN;
		END


      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'STEP2', @n_log_count, N'TRUNCATE SCP_MST_PIC_INFO', @v_description, @d_event_date;
	  TRUNCATE TABLE SCP_MST_PIC_INFO;


		--------------------------------------------------------------------------------
		-- 3-1. INSERT SCP_MST_PIC_INFO
		-------------------------------------------------------------------------------- 
		INSERT INTO SCP_MST_PIC_INFO
		(
				PLANT_ID
			,ITEM_ID
			,PIC_NO
			,PIC_NM
			,ATTRIBUTE1
			,ATTRIBUTE2
			,ATTRIBUTE3
			,ATTRIBUTE4
			,ATTRIBUTE5
			,CREATED_BY
			,CREATION_DATE
			,LAST_UPDATED_BY
			,LAST_UPDATE_DATE
		)
			SELECT PLANT_CD
				,ITEM_CD
				,PIC_NO
				,PIC_NM
				,ATTR_01
				,ATTR_02
				,ATTR_03
				,ATTR_04
				,IF_SEQ AS ATTRIBUTE5 
				,@v_batch_user	AS CREATE_USER
				,GETDATE()		AS CREATE_DATE
				,@v_batch_user	AS UPDATE_USER
				,GETDATE()		AS UPDATE_DATE	
			FROM XIF_MRP_PIC_INFO_OUT_IF_R_SN
			WHERE IF_SEQ IN (	  
									SELECT IF_SEQ
										FROM
										(
											SELECT IF_SEQ 
												, RANK() OVER(PARTITION BY PLANT_CD,ITEM_CD,PIC_NO ORDER BY IF_SEQ DESC) AS SEQ
											FROM XIF_MRP_PIC_INFO_OUT_IF_R_SN WITH(NOLOCK)
											WHERE proc_flag = 'P'
										) LIST
									WHERE LIST.SEQ = 1
							)

		--------------------------------------------------------------------------------
		-- 3-2.  처리 한 row 마킹
		-------------------------------------------------------------------------------- 
		UPDATE [dbo].[XIF_MRP_PIC_INFO_OUT_IF_R_SN]
			SET proc_flag = 'Y' 
			, PROC_MSG  = concat(PROC_MSG, N'이관대상 ', CONVERT(CHAR(23), getdate(), 21))
			, PROC_DATE = SYSDATETIME()
		WHERE IF_SEQ   IN (SELECT ATTRIBUTE5 FROM SCP_MST_PIC_INFO)
			AND proc_flag = 'P';
				
		UPDATE [dbo].[XIF_MRP_PIC_INFO_OUT_IF_R_SN]
			SET proc_flag = 'S' 
			, PROC_MSG  = concat(PROC_MSG, N'이관대상 제외 ', CONVERT(CHAR(23), getdate(), 21))
			, PROC_DATE = SYSDATETIME()
		WHERE proc_flag = 'P'; 



		-----------------------------------------------------------
		-- History LOG
		-----------------------------------------------------------
        SET @v_log_type = 'HISTORY';
        SET @v_description = '@n_history_seq' +':'+ CAST(@n_success_cnt AS nvarchar(100));
        SET @d_event_date = SYSDATETIME();
		SET @n_log_count = @@ROWCOUNT;
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, 'Insert Count', @n_log_count, @d_event_date;

		SELECT @n_success_cnt = count(*) FROM XIF_MRP_PIC_INFO_OUT_IF_R_SN WHERE proc_flag = 'Y' AND  PROC_DATE > getdate() - 0.002; -- 3분 이내
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_success_cnt, N'이관대상', @n_success_cnt, @d_event_date;

		SELECT @n_success_cnt = count(*) FROM XIF_MRP_PIC_INFO_OUT_IF_R_SN WHERE proc_flag = 'S' AND  PROC_DATE > getdate() - 0.002; -- 3분 이내
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_success_cnt, N'이관대상 제외', @n_success_cnt, @d_event_date;

		SELECT @n_success_cnt = count(*) FROM SCP_MST_PIC_INFO;
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_success_cnt, N'SCP_MST_PIC_INFO COUNT', @n_success_cnt, @d_event_date;

		
        IF @@TRANCOUNT > 0
		  BEGIN
            COMMIT WORK;
		  END;

      END
    END TRY

    BEGIN CATCH
	  IF @@TRANCOUNT > 0
		  BEGIN
            ROLLBACK;
		  END;
		-----------------------------------------------------------
		-- Error LOG
		-----------------------------------------------------------
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : '+ CAST(ERROR_LINE() AS nvarchar(10));;
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_fail_cnt, @v_log_message, @v_description, @d_event_date;
    END CATCH;

	-----------------------------------------------------------
	-- 종료 LOG
	-----------------------------------------------------------
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;

