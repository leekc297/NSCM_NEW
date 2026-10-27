

CREATE PROCEDURE [dbo].[FP00TEST_FIND_TEST]
	 @FP00TEST			AS DBO.FP00TEST       READONLY
AS
BEGIN
	SET NOCOUNT ON;

	SET ANSI_WARNINGS OFF
	SET ARITHIGNORE ON
	SET ARITHABORT OFF

	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0049_SAVE_CAPA';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 이력용 변수 설정
	DECLARE @v_job_type		NVARCHAR(10) = 'MERGE';


	-- 트렌젝션 시작
	BEGIN TRAN;

	BEGIN TRY
		/* ############################################################ */
		-- 0. 임시 변수를 테이블에 저장한다.
		-- 속도 문제로 WHILE 문을 사용하지 않고 FUNCTION 을 사용한다.
		/* ############################################################ */
		SELECT * FROM @FP00TEST
	return '---------------'
	
		COMMIT TRAN;
	
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
	END CATCH

	COMMIT TRAN;
	END
