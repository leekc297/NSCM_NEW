
CREATE PROCEDURE [dbo].[PR_XIF_AUTO_SEND_TABLE]
/*
-- ================================================================================================
-- BATCH PERIOD        : 
-- DESCRIPTION         : 
-- 1. @p_xif_table parameter에서 대상 테이블을 찾고 해당 테이블의 데이터를 IF할 수 있도록 가져온다
-- 2. @p_option  동작 옵션
-- 2-1 create : transfer flag 가 N인 모든 ifseqno를 리스트해준다. order by ifseqno asc (오래된 ifseqno 우선)
-- 2-2 list : ifseqno 기준으로 모든 data를 리스트해준다 (transfer flag 무시)
-- 2-3 success : ifseqno 기준으로 transfer flag를 모두 Y로 업데이트한다
-- 2-4 fail : ifseqno 기준으로 transfer flag를 모두 F로 업데이트한다.
-- SOURCE SYSTEM       : FP
-- DESTINATION SYSTEM  : NERP
-- SOURCE TABLE        : XIF_ERP_DAILY_PRODUCTION_PLAN_S
-- DESTINATION TABLE   : 
--
-- CREATE DATE		   : 2024.05.08
-- command : create - today production plan
-- command : list - list all data (if_seq)
-- command : success - update if 'S'
-- VERSION             : 1.0
-- ================================================================================================
*/
-- PARAMETER
@p_xif_table NVARCHAR(1000) = '', -- xif_****_.s table, target table to send
@p_option NVARCHAR(10) = 'create', -- create (list ifseq) , list (list with if_seq) , success (set success with if_seq) , fail (set fail with if_seq)
@p_if_seq NVARCHAR(50) = 'NULL',
@p_company_id NVARCHAR(50) = '' -- not used yet

AS

BEGIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_AUTO_SEND_TABLE:'+@p_xif_table
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	  = 0
	DECLARE @sysdate     DATETIME     = GETDATE()

	DECLARE @ROWCOUNT    INTEGER

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)
	DECLARE @v_sql NVARCHAR(MAX) =''

	-- ================================================
    -- Declare start
	-- ================================================

	DECLARE @IF_ID       NVARCHAR(50)
	DECLARE @ACCUM_DATE          NVARCHAR(1000)
	DECLARE @SITE_ID          NVARCHAR(1000)

	--declare @today_yyyymmdd nvarchar(10) = ''
	--declare @if_seq nvarchar(50) = ''
	--set @today_yyyymmdd = convert(char(8), getdate(), 112)
	
	-- ================================================
    -- Declare end
	-- ================================================

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate
		


	BEGIN TRY
	IF @p_option = 'create' BEGIN
		EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'START CREATE IF TABLE', @ROWCOUNT, @V_TEMP1, '############### START OF CREATE ###############', NULL, @SYSDATE
		BEGIN TRAN
			SET @v_sql = ''
			SET @v_sql += 'select ifseqno from dbo.' + @p_xif_table +  ' with(nolock) where  TRANSFER_FLAG = ''N'' group by ifseqno'
			exec @v_sql
		COMMIT TRAN
	END	ELSE IF @p_option = 'list' BEGIN
		EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'START READ IF DATA', 0, @V_TEMP1, '############### START OF LIST ###############', @p_if_seq, @SYSDATE
		BEGIN TRAN
			IF isnull(@p_if_seq,'') <> '' BEGIN
				SET @v_sql = ''
				SET @v_sql += 'select * from dbo.' + @p_xif_table +  ' with(nolock) where  [IFSEQNO] = ''' + @p_if_seq +''''
				exec @v_sql
			END
		COMMIT TRAN
		EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'START READ IF DATA', @ROWCOUNT, @V_TEMP1, '############### END OF LIST ###############', NULL, @SYSDATE
	END ELSE IF @p_option = 'success' BEGIN
		EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'START UPDATE IF RESULT', 0, @V_TEMP1, '############### START OF UPDATE ###############', @p_if_seq, @SYSDATE
		BEGIN TRAN
			IF isnull(@p_if_seq,'') <> '' BEGIN
				SET @v_sql = ''
				SET @v_sql += 'update ' + @p_xif_table +  ' SET [TRANSFER_FLAG] = ''Y'', [TRANSFER_DATE] = GetDate() where [IFSEQNO] = '''+@p_if_seq+''''
				exec @v_sql
			END
		COMMIT TRAN
		EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'END UPDATE IF RESULT', @ROWCOUNT, @V_TEMP1, '############### END OF UPDATE ###############', NULL, @SYSDATE
	END ELSE IF @p_option = 'fail' BEGIN
		EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'START UPDATE IF FAIL', 0, @V_TEMP1, '############### START OF UPDATE ###############', @p_if_seq, @SYSDATE
		BEGIN TRAN
			IF isnull(@p_if_seq,'') <> '' BEGIN
				SET @v_sql = ''
				SET @v_sql += 'update ' + @p_xif_table +  ' SET [TRANSFER_FLAG] = ''F'', [TRANSFER_DATE] = GetDate() where [IFSEQNO] = '''+@p_if_seq+''''
				exec @v_sql
			END
		COMMIT TRAN
		EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'END UPDATE IF FAIL', @ROWCOUNT, @V_TEMP1, '############### END OF UPDATE ###############', NULL, @SYSDATE
	END


	END TRY	
	BEGIN CATCH
	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate
	END CATCH

end
