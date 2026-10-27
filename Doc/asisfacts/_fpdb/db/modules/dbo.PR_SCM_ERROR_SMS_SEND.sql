
CREATE PROCEDURE [dbo].[PR_SCM_ERROR_SMS_SEND]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_SCM_ERROR_SMS_SEND
-- Param               :
-- Batch Period        : 30MIN
-- Description         :
--
-- Source System       : FP SDB
-- Destination System  : FP SDB
-- Source Table        : JOB_SCHEDULE_DETAIL, XIF_LOG_HISTORY
-- Destination Table   : XIF_IFS_SMS_DATA
--
-- Create(Update) Date : 2019.07.11
-- Author              : PIYONG
-- Version             : 1.0
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_SCM_ERROR_SMS_SEND'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	DECLARE @group_id		NVARCHAR(50)
	DECLARE @job_desc		NVARCHAR(100)
	DECLARE @job_id			NVARCHAR(200)
	DECLARE @start_date		DATETIME
	DECLARE @job_type		NVARCHAR(20)
	DECLARE @status			NVARCHAR(20)
	DECLARE @service_name	NVARCHAR(500)
	DECLARE @MSG			NVARCHAR(200)
	DECLARE @PHONE_NUM		NVARCHAR(20)


	--NET JOB 호출
	DECLARE CR_JOB CURSOR FOR
		SELECT [GROUP_ID]
			   , [JOB_DESC]
			   , [JOB_ID]
			   , [START_DATE]
			   , [JOB_TYPE]
			   , [STATUS]
		  FROM (
				SELECT [JOB_DESC]
					   , [START_DATE]
					   , [JOB_TYPE]
					   , [JOB_ID]
					   , [GROUP_ID]
					   , [STATUS]
					   , ROW_NUMBER() OVER ( PARTITION BY JOB_DESC
											     ORDER BY [START_DATE] DESC ) SEQ_NUM
				  FROM [JOB_SCHEDULE_DETAIL] WITH(NOLOCK)
				 WHERE VALID = 'Y'
				   AND END_DATE IS NULL
				   AND GROUP_ID LIKE '999%'
				   AND GROUP_ID != '999_0016'
				   AND DATEDIFF ( MI, [START_DATE], GETDATE() ) >= 10
				   AND DATEDIFF ( MI, [START_DATE], GETDATE() ) <= 120
			   ) W
		 WHERE W.SEQ_NUM = 1


	--CLASS 수신
	DECLARE CR_ERROR CURSOR FOR
		SELECT [SERVICE_NAME]
		  FROM (	
				SELECT IFSEQNO
					   , [SERVICE_NAME]
					   , LOG_MSR
					   , ROW_NUMBER() OVER ( PARTITION BY [SERVICE_NAME]
												 ORDER BY CREATE_DATE DESC ) SEQ_NUM
				  FROM LGCE_INFDEV.DBO.XIF_ERP_DW_LOG
				 WHERE IF_TYPE IS NULL
				   AND DATEDIFF ( MI, CREATE_DATE, GETDATE() ) >= 10
				   AND DATEDIFF ( MI, CREATE_DATE, GETDATE() ) <= 120
			   ) A
		 WHERE SEQ_NUM = 1


	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가
		-- ================================================
			OPEN CR_JOB;
			FETCH NEXT FROM CR_JOB INTO @group_id
										, @job_desc
										, @job_id
										, @start_date
										, @job_type
										, @status
			;             

			WHILE (@@FETCH_STATUS = 0)
			BEGIN
				IF @job_type = 'PROCEDURE'
					BEGIN
						IF @status = 'START'
							BEGIN
								SET @MSG = @job_id + N' 장기 수행 중'
							END
						ELSE
							BEGIN
								SET @MSG = @job_id + N' 오류 발생함'
							END
					END
				ELSE
					BEGIN
						SET @MSG = @group_id + N' : ' +@job_desc + N' 확인 요망'
					END


				DECLARE CUR_SMS CURSOR FOR
					SELECT ATTRIBUTE1 AS PN
					  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
					 WHERE LOOKUP_TYPE_CODE = 'SMS_ADDRESSEE'
					   AND SEGMENT1 =  'ERROR'
					   AND ACTIVE_FLAG = 'Y'	--2019-01-11 PIYONG ADD
				;

				OPEN CUR_SMS;
				FETCH NEXT FROM CUR_SMS INTO @PHONE_NUM
				;

				WHILE (@@FETCH_STATUS = 0)
					BEGIN

						INSERT INTO [SY_XIF_IFS_SMS_DATA] (
							[IF_TYPE]
							, [IF_ID]
							, [IF_INS_DATE]
							, [IF_FLAG]
							, [IF_SND_DATE]
							, [TR_SENDSTAT]
							, [TR_MSGTYPE]
							, [TR_PHONE]
							, [TR_CALLBACK]
							, [TR_MSG]
						) VALUES (
							'S'
							, 'OFP0_OSMS_SMS'
							, GETDATE()
							, 'N'
							, NULL
							, '0'
							, '0'
							, @PHONE_NUM
							, @PHONE_NUM
							, SUBSTRING (@MSG, 1, 80 )
						)

						FETCH NEXT FROM CUR_SMS INTO @PHONE_NUM
						;
					END;
				CLOSE CUR_SMS;
				DEALLOCATE CUR_SMS;


				FETCH NEXT FROM CR_JOB INTO @group_id
											, @job_desc
											, @job_id
											, @start_date
											, @job_type
				;              

			END;

			CLOSE CR_JOB;
			DEALLOCATE CR_JOB;



			OPEN CR_ERROR;
			FETCH NEXT FROM CR_ERROR INTO @service_name
			;

			WHILE (@@FETCH_STATUS = 0)
				BEGIN

					DECLARE CUR_ERROR_SMS CURSOR FOR
						SELECT ATTRIBUTE1 AS PN
						  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
						 WHERE LOOKUP_TYPE_CODE = 'SMS_ADDRESSEE'
						   AND SEGMENT1 =  'ERROR'
						   AND ACTIVE_FLAG = 'Y'	--2019-01-11 PIYONG ADD
					;

					OPEN CUR_ERROR_SMS;
					FETCH NEXT FROM CUR_ERROR_SMS INTO @PHONE_NUM
					;

					WHILE (@@FETCH_STATUS = 0)
						BEGIN

							INSERT INTO [SY_XIF_IFS_SMS_DATA] (
								[IF_TYPE]
								, [IF_ID]
								, [IF_INS_DATE]
								, [IF_FLAG]
								, [IF_SND_DATE]
								, [TR_SENDSTAT]
								, [TR_MSGTYPE]
								, [TR_PHONE]
								, [TR_CALLBACK]
								, [TR_MSG]
							) VALUES (
								'S'
								, 'OFP0_OSMS_SMS'
								, GETDATE()
								, 'N'
								, NULL
								, '0'
								, '0'
								, @PHONE_NUM
								, @PHONE_NUM
								, SUBSTRING ( @service_name + N'  오류 발생함 ', 1, 80 )
							)


							FETCH NEXT FROM CUR_ERROR_SMS INTO @PHONE_NUM
							;
						END;
					CLOSE CUR_ERROR_SMS;
					DEALLOCATE CUR_ERROR_SMS;


					FETCH NEXT FROM CR_ERROR INTO @service_name
					;              

				END;

			CLOSE CR_ERROR;
			DEALLOCATE CR_ERROR;

		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END



