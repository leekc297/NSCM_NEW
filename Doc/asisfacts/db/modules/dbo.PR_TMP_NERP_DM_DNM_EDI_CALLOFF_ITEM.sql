



-- =============================================
-- Author:		 P.C.I
-- Create date:  2024-04-26
-- Description:	 DM_DNM_EDI_CALLOFF_ITEM Incoterms Conversion - Incoterms key 값 아님 
-- =============================================
CREATE PROCEDURE [dbo].[PR_TMP_NERP_DM_DNM_EDI_CALLOFF_ITEM]

AS

BEGIN 

	--------------------------------------------------------------------------------------------	
	BEGIN TRANSACTION;
	--------------------------------------------------------------------------------------------	
	BEGIN TRY
	--------------------------------------------------------------------------------------------


	SET NOCOUNT ON;
	
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_TMP_NERP_DM_DNM_EDI_CALLOFF_ITEM';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
	DECLARE @UPDATE_CNT INT;
	SET @UPDATE_CNT = 0;

	--4000,6100,6200,6300,7000
	--EDI_IF_SEQ 는 매번 채번되는 값이므로, ERP 에서 엑셀로 공유된 데이터를 과거 EDI_IF_SEQ에 매핑하여 업데이트 해야 함 !

	--NERP에서 공유받은 엑셀파일로 NERP_EDI_CUSTOMER_PLANT_MAPPING 테이블에 데이터 생성


	
	--1. EDI_IF_SEQ 에 매핑된 CUSTOMER_PLANT 업데이트
	--6100	PISTON 은 일괄 'PA9'로 업데이트
	--1차 오픈대상 아님
	/*
	UPDATE A
	SET    A.CUSTOMER_PLANT = 'PA9'
	     --, A.LAST_UPDATE_DATE = getdate()
		 --, A.LAST_UPDATED_BY = A.LAST_UPDATED_BY + '_NERP'
	FROM   DM_DNM_EDI_CALLOFF_ITEM AS A 
	WHERE 1=1 
	AND   A.SENDER_CODE IN ('G6100')
	AND   ISNULL(A.CUSTOMER_PLANT, '') = ''
	;*/
	
	SET @UPDATE_CNT = @@ROWCOUNT;

	--2. EDI_IF_SEQ 에 매핑된 CUSTOMER_PLANT 업데이트(Excel 데이터 제공)
	--4000	PEUGEOT
	--7000	VOLVO
	UPDATE A
	SET    A.CUSTOMER_PLANT = B.CUSTOMER_PLANT
	     --, A.LAST_UPDATE_DATE = getdate()
		 --, A.LAST_UPDATED_BY = A.LAST_UPDATED_BY + '_NERP'
	FROM   DM_DNM_EDI_CALLOFF_ITEM AS A 
	INNER JOIN NERP_EDI_CUSTOMER_PLANT_MAPPING AS B 
	ON    A.EDI_IF_SEQ = B.EDI_IF_SEQ
	AND   A.SENDER_CODE = B.SENDER_CODE
	WHERE 1=1 --A.SENDER_CODE IN ('G4000','G6100','D6100','D6200','D6300','G7000')
	--AND   A.SENDER_CODE IN ('G4000','G7000','D7000')
	AND   ISNULL(A.CUSTOMER_PLANT, '') = ''
	;

	
	SET @UPDATE_CNT = @UPDATE_CNT + @@ROWCOUNT;


	COMMIT TRANSACTION;

	PRINT 'Transaction succeed!';
	
	-- 종료 LOG
	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @n_log_count = @UPDATE_CNT;
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	--------------------------------------------------------------------------------------------	
	END TRY
	--------------------------------------------------------------------------------------------	

	
	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
		ROLLBACK;
		PRINT 'Transaction is cancels cause of error';
		
		-- ERROR LOG
		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @n_log_count = 0;
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();
		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;	 
	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

END
