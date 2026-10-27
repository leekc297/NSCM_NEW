
CREATE PROCEDURE [dbo].[PR_SCM_MPP_WPP_MRP_SMS_SEND]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_SCM_MPP_WPP_MRP_SMS_SEND
-- Param               :
-- Batch Period        : 
-- Description         :
--
-- Source System       : FP SDB
-- Destination System  : FP SDB
-- Source Table        : 
-- Destination Table   : XIF_IFS_SMS_DATA
--
-- Create Date		   : 2017.08.25
-- Update Date		   : 

-- Author              : PIYONG

-- Version             : 1.0
-- ================================================================================================

@P_PLAN_WEEK NVARCHAR(50) = NULL
,@P_PLAN_REVISION NVARCHAR(4000) = NULL

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_SCM_MPP_WPP_MRP_SMS_SEND'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	DECLARE @i			INTEGER			=0
	DECLARE @TEMP		NVARCHAR(4000)
	DECLARE @PHONE_NUM	NVARCHAR(50)


	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가
		-- ================================================

			SET @TEMP = @P_PLAN_REVISION;

			WHILE( @i < (LEN(@P_PLAN_REVISION) - LEN(REPLACE(@P_PLAN_REVISION, ',', '')) ) +1 )
				BEGIN
				
					DECLARE CUR_SMS CURSOR FOR
						SELECT ATTRIBUTE1 AS PN
						  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
						 WHERE LOOKUP_TYPE_CODE = 'SMS_ADDRESSEE'
						   AND SEGMENT1 = 'WPP_MPP_MRP'

					OPEN CUR_SMS;
					FETCH NEXT FROM CUR_SMS INTO @PHONE_NUM;
					WHILE (@@FETCH_STATUS = 0)
						BEGIN
							INSERT INTO [SY_XIF_IFS_SMS_DATA] (
								[IF_TYPE]
								,[IF_ID]
								,[IF_INS_DATE]
								,[IF_FLAG]
								,[IF_SND_DATE]
								,[TR_SENDSTAT]
								,[TR_MSGTYPE]
								,[TR_PHONE]
								,[TR_CALLBACK]
								,[TR_MSG]
							) VALUES (
								'S'
								,'OFP0_OSMS_SMS'
								,GETDATE()
								,'N'
								,NULL
								,'0'
								,'0'
								,@PHONE_NUM
								,@PHONE_NUM
								,CASE WHEN  @i = (LEN(@P_PLAN_REVISION) - LEN(REPLACE(@P_PLAN_REVISION, ',', '')) ) THEN
										N'[MRP] For '+@P_PLAN_WEEK +' Week, '+@TEMP +' version of FP is uploaded.'
									  ELSE
										N'[MRP] For '+@P_PLAN_WEEK +' Week, '+SUBSTRING(@TEMP, 0, CHARINDEX(N',',  @TEMP ) ) +' version of FP is uploaded.'
									  END
							)

							FETCH NEXT FROM CUR_SMS INTO @PHONE_NUM;
						END;

					CLOSE CUR_SMS;
					DEALLOCATE CUR_SMS;

					SET @TEMP = SUBSTRING(@TEMP, CHARINDEX(N',',  @TEMP ) +1, LEN(@TEMP));

					SET @i = @i + 1

				END

		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END



