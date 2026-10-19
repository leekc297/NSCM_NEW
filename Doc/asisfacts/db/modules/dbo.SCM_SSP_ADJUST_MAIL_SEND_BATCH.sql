


/*
 * Program ID   : SCM_SSP_MAIL_SEND_BATCH
 * Description  : SSP MAIL 발송 (Adjust 메뉴)
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================a
 * 2018/11/16	hwyoon			Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2019/06/11	mcTheJ			[CSR ID:3994058] [요청]생산관리 출하변경 시 사유 code화 관리
  */
CREATE PROCEDURE [dbo].[SCM_SSP_ADJUST_MAIL_SEND_BATCH]
	 
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;


	DECLARE @v_grp_change_req	NVARCHAR(MAX);
	DECLARE @i INT;
	DECLARE @maxNo INT;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCM_SSP_ADJUST_MAIL_SEND_BATCH';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	IF OBJECT_ID('tempdb..#TblSSPAdjustMailSendBatch') IS NOT NULL
		   DROP TABLE #TblSSPAdjustMailSendBatch 


	BEGIN TRY

		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


		SELECT GRP_CHANGE_REQ, ROW_NUMBER() OVER (ORDER BY GRP_CHANGE_REQ) AS ROWNUM
		INTO #TblSSPAdjustMailSendBatch     
		FROM SSP_MST_SEND_MAIL_REQ
		WHERE TRANSFER_FLAG='N'
		GROUP BY GRP_CHANGE_REQ;

		SET @i = 1;
		--SET @maxNo = @@ROWCOUNT;

		UPDATE SSP_MST_SEND_MAIL_REQ
		SET TRANSFER_FLAG='Y'
		FROM SSP_MST_SEND_MAIL_REQ T1 JOIN #TblSSPAdjustMailSendBatch T2 ON T1.GRP_CHANGE_REQ = T2.GRP_CHANGE_REQ
		WHERE TRANSFER_FLAG='N'

				

		--PRINT '1. BEFORE UPDATE-'

		--PRINT '2. AFTER UPDATE-'

		--SET @i = 1;
		SET @maxNo = (SELECT MAX(ROWNUM) FROM #TblSSPAdjustMailSendBatch);

		---- CURSOR 사용 X : CURSOR는 공유되기 때문에 여러사람이 동시 메일 전송 시 중복 선언 불가.
		WHILE @i <= @maxNo
			BEGIN
				SELECT @v_grp_change_req = GRP_CHANGE_REQ
				FROM #TblSSPAdjustMailSendBatch
				WHERE ROWNUM=@i

				--PRINT '3. SEND MAIL-'
				--EXEC PR_SSP_ADJUST_MAIL_SEND @v_change_req_no;
				
				EXEC PR_SSP_ADJUST_MAIL_SEND @v_grp_change_req;
				
				SET @i = @i + 1;
			END;

		/*
		DECLARE CUR_SEND_REQ CURSOR FOR
		SELECT CHANGE_REQ_NO
		FROM #TblSSPAdjustMailSendBatch

		OPEN CUR_SEND_REQ;
		FETCH NEXT FROM CUR_SEND_REQ INTO @v_change_req_no

		WHILE @@FETCH_STATUS = 0
			BEGIN
				PRINT '3. SEND MAIL-'

				EXEC PR_SSP_ADJUST_MAIL_SEND @v_change_req_no;

				FETCH NEXT FROM CUR_SEND_REQ INTO @v_change_req_no;

			END;
		*/

		-- 종료 LOG
		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	END TRY

	BEGIN CATCH
		--CLOSE CUR_SEND_REQ;
		--DEALLOCATE CUR_SEND_REQ;
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

	--임시테이블 삭제
	IF OBJECT_ID('tempdb..#TblSSPAdjustMailSendBatch') IS NOT NULL
		DROP TABLE #TblSSPAdjustMailSendBatch 

END



