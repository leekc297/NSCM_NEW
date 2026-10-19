
/*
 * Program ID   : SCM_ADM_MAIL_SEND_BATCH_MST
 * Description  : Mail 발송 정보 BATCH
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/03/05   ygkim   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/05/14   ygkim	Mail, SMS 구분 추가
 * 2018/10/05   ygkim   Mail 발송 시 UI 수신자 등록 여부를 가지고 발송 로직 구분
 * 2018/10/11   hwyoon	발송시간 10분단위로 변경
 */

CREATE PROCEDURE [dbo].[SCM_ADM_MAIL_SEND_BATCH_MST]
  --@p_category_id				int

AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON;
	
	DECLARE @v_category_id			INT;
	DECLARE @v_use_type_code		NVARCHAR(80);
	DECLARE @v_cycle_class_code		NVARCHAR(10);
	DECLARE @v_detail_class_code	NVARCHAR(20);
	DECLARE @v_send_time_text		NVARCHAR(80);

	DECLARE @v_week_day  NVARCHAR(10);
	DECLARE @v_month_day  NVARCHAR(10);
	DECLARE @v_time  NVARCHAR(10);
	DECLARE @p_category_id INT;

	DECLARE @v_ui_user_cnt	    int

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCM_ADM_MAIL_SEND_BATCH_MST';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	
	SET @p_category_id = NULL;

	DECLARE CUR_MAIN CURSOR FOR
		SELECT category_id
				,use_type_code
				,cycle_class_code
				,detail_class_code
				,send_time_text
		FROM (
				SELECT nrm.category_id
					,nrm.use_type_code
					,nrm.cycle_class_code
					,flv.segment4 detail_class_code
					--,flv1.segment4 send_time_text
					,(substring(flv1.segment4,1,2)+flv2.segment4) send_time_text
				FROM SCM_ADM_RECIPIENT_LIST nrm
					,SCM_ADM_LOOKUP_MASTER_DETAIL flv
					,SCM_ADM_LOOKUP_MASTER_DETAIL flv1
				LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL flv2 on flv2.LOOKUP_TYPE='MAIL_SEND_CYCLE_DETAIL' and flv2.SEGMENT1='HOUR'
				WHERE nrm.valid_yn = 'Y'
				AND flv.lookup_type   = 'MAIL_SEND_CYCLE_DETAIL'
				AND nrm.cycle_class_code   = flv.segment1
				AND nrm.detail_class_code  = flv.segment2
				AND flv1.lookup_type  = 'MAIL_SEND_CYCLE_DETAIL'
				AND nrm.send_time_text  = flv1.segment2
				AND flv1.valid_yn = 'Y'
				AND flv.valid_yn = 'Y'
				AND nrm.cycle_class_code NOT IN ( 'DAY', 'RT' )
				and ISNULL(NULLIF(nrm.SEND_MIN_TIME_TEXT,''),'H00')=flv2.SEGMENT2
				UNION ALL
				SELECT nrm.category_id
					,nrm.use_type_code
					,nrm.cycle_class_code
					,''
					--,flv.segment4 send_time_text
					,(substring(flv.segment4,1,2)+flv2.segment4) send_time_text
				FROM SCM_ADM_RECIPIENT_LIST nrm
					,SCM_ADM_LOOKUP_MASTER_DETAIL flv
				LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL flv2 on flv2.LOOKUP_TYPE='MAIL_SEND_CYCLE_DETAIL' and flv2.SEGMENT1='HOUR' 
				WHERE nrm.valid_yn = 'Y'
				AND flv.lookup_type   = 'MAIL_SEND_CYCLE_DETAIL'
				AND nrm.cycle_class_code   = flv.segment1
				AND nrm.detail_class_code  = flv.segment2
				AND flv.valid_yn = 'Y'
				AND nrm.cycle_class_code IN ( 'DAY', 'RT' )
				and ISNULL(NULLIF(nrm.SEND_TIME_TEXT,''),'H00')=flv2.SEGMENT2
		) a
		WHERE (
			(@p_category_id IS NULL AND cycle_class_code != 'RT')
			OR
			(@p_category_id IS NOT NULL AND category_id = @p_category_id )
			);
		
		BEGIN
			SELECT @v_week_day = a.dayofweek
				  ,@v_month_day = a.calendar_day
				  ,@v_time = (SELECT substring(convert(nvarchar(10), getdate(), 108),1,2)+substring(convert(nvarchar(10), getdate(), 108),4,1)+'0') 
			  FROM scm_sys_calendar_m a
			 WHERE a.basis_date = convert(nvarchar(10), getdate(), 112);
		END

	BEGIN TRY
			-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		OPEN CUR_MAIN;
		FETCH NEXT FROM CUR_MAIN
			INTO @v_category_id
			    ,@v_use_type_code
				,@v_cycle_class_code
				,@v_detail_class_code
				,@v_send_time_text
		WHILE (@@FETCH_STATUS = 0)	
			BEGIN	
				IF @v_use_type_code = 'MAIL'
					BEGIN
						SET @v_ui_user_cnt = 0;
						SELECT @v_ui_user_cnt = count(user_id)
						FROM SCM_ADM_RECIPIENT_ASSIGN
						WHERE CATEGORY_ID = @v_category_id
					END

				IF @v_cycle_class_code = 'DAY' 
					BEGIN
						IF @v_send_time_text = @v_time			
							BEGIN
								IF @v_use_type_code = 'MAIL'
									BEGIN
										IF @v_ui_user_cnt > 0 --UI에서 수신자가 등록되어 있는 경우
											BEGIN												
												EXEC SCM_ADM_MAIL_SEND_DATA @v_category_id;
											END
										ELSE --Sql에 수신자가 있는 경우
											BEGIN
												EXEC SCM_ADM_MAIL_SEND_BATCH @v_category_id;
											END
									END
								ELSE
									BEGIN
										EXEC SCM_ADM_SMS_SEND_BATCH @v_category_id;
									END
							END
					END
				ELSE IF @v_cycle_class_code = 'WEEK' 
					BEGIN
						IF @v_detail_class_code = @v_week_day AND @v_send_time_text = @v_time 
							BEGIN
								IF @v_use_type_code = 'MAIL'
									BEGIN
										IF @v_ui_user_cnt > 0 --UI에서 수신자가 등록되어 있는 경우
											BEGIN												
												EXEC SCM_ADM_MAIL_SEND_DATA @v_category_id;
											END
										ELSE --Sql에 수신자가 있는 경우
											BEGIN
												EXEC SCM_ADM_MAIL_SEND_BATCH @v_category_id;
											END
									END
								ELSE
									BEGIN
										EXEC SCM_ADM_SMS_SEND_BATCH @v_category_id;
									END
							END
					END
				ELSE IF @v_cycle_class_code = 'MONTH' 
					BEGIN
						IF @v_detail_class_code = @v_month_day AND @v_send_time_text = @v_time 
							BEGIN
								IF @v_use_type_code = 'MAIL'
									BEGIN
										IF @v_ui_user_cnt > 0 --UI에서 수신자가 등록되어 있는 경우
											BEGIN												
												EXEC SCM_ADM_MAIL_SEND_DATA @v_category_id;
											END
										ELSE --Sql에 수신자가 있는 경우
											BEGIN
												EXEC SCM_ADM_MAIL_SEND_BATCH @v_category_id;
											END
									END
								ELSE
									BEGIN
										EXEC SCM_ADM_SMS_SEND_BATCH @v_category_id;
									END
							END
					END
				ELSE IF @v_cycle_class_code = 'RT' 
					BEGIN
						IF @v_use_type_code = 'MAIL'
							BEGIN
								IF @v_ui_user_cnt > 0 --UI에서 수신자가 등록되어 있는 경우
									BEGIN												
										EXEC SCM_ADM_MAIL_SEND_DATA @v_category_id;
									END
								ELSE --Sql에 수신자가 있는 경우
									BEGIN
										EXEC SCM_ADM_MAIL_SEND_BATCH @v_category_id;
									END
							END
						ELSE
							BEGIN
								EXEC SCM_ADM_SMS_SEND_BATCH @v_category_id;
							END
					END

				FETCH NEXT FROM CUR_MAIN
					INTO @v_category_id
						,@v_use_type_code
						,@v_cycle_class_code
						,@v_detail_class_code
						,@v_send_time_text
			END
		CLOSE CUR_MAIN;
		DEALLOCATE CUR_MAIN;

		IF (SELECT substring(convert(nvarchar(10), getdate(), 108),1,2)) = '05'
			BEGIN
				DELETE FROM [dbo].[SCM_ADM_SMS_MAIL_SEND_LOG] 
				WHERE SEND_DATE < CONVERT(VARCHAR, dateadd(day,-15,getdate()), 112)
			END

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		-- 결과코드, 결과 카운트 반환
			--SELECT  'S' AS result_code ;
	END TRY

	BEGIN CATCH
		CLOSE CUR_MAIN;
		DEALLOCATE CUR_MAIN;

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
		VALUES (ISNULL(ERROR_PROCEDURE(), 'SCM_ADM_MAIL_SEND_BATCH_MST')
		        -- 2025-08-09 kimcd check program name
				,'ERROR'
				,NULL
				,ERROR_MESSAGE()
				,'v_category_id:' + CONVERT(NVARCHAR(100), @v_category_id)
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


