-- =============================================
-- Author:		 chkim.68
-- Create date:  2024-02-14
-- Description: NERP를 위해, 기존 테이블의 데이터를 변경함
-- =============================================
CREATE PROCEDURE [dbo].[PR_TMP_NERP_EXISTING_TABLE_BATCH_001]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

BEGIN TRY
	BEGIN
	BEGIN TRANSACTION

	DECLARE @SHOW_MESSAGE int = 1
	DECLARE @DEBUG int = 1
	DECLARE @TOTAL_COUNT int = 0
	DECLARE @PHASE_COUNT int = 0
	DECLARE @PHASE_NAME NVARCHAR(100) = ''
-----------------------------------------------------------	
-- TEMPLATE FOR EACH TRANSACTION
	SET @PHASE_NAME = 'procedure name'
	if @SHOW_MESSAGE = 1
	BEGIN
		print 'Start (' + @PHASE_NAME + ')'
	END

	
	
	
	SET @PHASE_COUNT = @@ROWCOUNT
	SET @TOTAL_COUNT += @PHASE_COUNT
	
	if @SHOW_MESSAGE = 1
	BEGIN
		print @PHASE_NAME + 'result :' + Convert(NVARCHAR,@PHASE_COUNT)
		print 'TOtal yet :' + Convert(NVARCHAR,@TOTAL_COUNT)
		print 'End '
	END
-----------------------------------------------------------


	COMMIT TRANSACTION
	END
END TRY
BEGIN CATCH
	BEGIN
		ROLLBACK TRANSACTION
		SELECT   
        ERROR_NUMBER() AS ErrorNumber  
        ,ERROR_MESSAGE() AS ErrorMessage;  	
	END
END CATCH


END
