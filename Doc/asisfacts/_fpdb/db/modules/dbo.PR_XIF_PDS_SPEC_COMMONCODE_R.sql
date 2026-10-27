
CREATE PROCEDURE [dbo].[PR_XIF_PDS_SPEC_COMMONCODE_R]

-- ================================================================================================
-- Program ID          : FPX0002
-- Program Name        : PR_XIF_PDS_SPEC_COMMONCODE_R
-- Param               :
-- Batch Period        : 1DAY
-- Description         :
--
-- Source System       : PDS
-- Destination System  : FP SDB
-- Source Table        : XIF_PLM_SPEC_COMMONCODE_R
-- Destination Table   : SCM_ITEM_PLM_DESC_M
--
-- Create(Update) Date : 2023.09.01
-- Author              : FP Pjt.
-- Version             : 1.0
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_PDS_SPEC_COMMONCODE_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가
		-- ================================================
			UPDATE SY_XIF_PLM_SPEC_COMMONCODE_R
			   SET PROC_FLAG = 'P'
			 WHERE ISNULL(PROC_FLAG, 'N') = 'N'

			MERGE INTO [DBO].[SCM_ITEM_PLM_DESC_M] A
			USING ( 
					SELECT CMCDTYPE
						 , ITEM_ID
						 , DESCRIPTION
						 , USE_YN
					  FROM (
							SELECT CMCDTYPE
								 , CMCODE AS ITEM_ID
								 , [VALUE6] AS DESCRIPTION
								 , CMCDIUSE AS USE_YN
								 , ROW_NUMBER() OVER ( PARTITION BY CMCDTYPE, CMCODE  ORDER BY IF_SEQ DESC) ROWUMBER
							  FROM SY_XIF_PLM_SPEC_COMMONCODE_R with(nolock)
							 WHERE PROC_FLAG = 'P'
							   AND CMCDTYPE != CMCODE
						   ) BB
					 WHERE ROWUMBER = 1
				  )B
			   ON ( A.CD_TYPE = B.CMCDTYPE
			  AND A.ITEM_ID = B.ITEM_ID
				  )
			 WHEN MATCHED THEN
					UPDATE 
					   SET A.DESCRIPTION			   = B.DESCRIPTION
					     , A.USE_YN = B.USE_YN
					     , A.[UPDATE_ID]			   = @v_proc_name
					     , A.[UPDATE_TIME]			   = GETDATE()
				WHEN NOT MATCHED THEN

					INSERT (
					       CD_TYPE
						 , ITEM_ID
						 , DESCRIPTION
						 , USE_YN
						 , [CREATE_TIME]
						 , [CREATE_ID]
						 , [UPDATE_TIME]
						 , [UPDATE_ID]
						 )
					VALUES (
						   B.CMCDTYPE
						 , B.ITEM_ID
						 , B.DESCRIPTION
						 , B.USE_YN
						 , GETDATE()
						 , @v_proc_name
						 , GETDATE()
						 , @v_proc_name
					)
				;
		
			UPDATE SY_XIF_PLM_SPEC_COMMONCODE_R
			   SET PROC_FLAG = 'Y'
				 , PROC_DATE = GETDATE()
			 WHERE PROC_FLAG = 'P'
			;


		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

		ROLLBACK TRAN

		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END
