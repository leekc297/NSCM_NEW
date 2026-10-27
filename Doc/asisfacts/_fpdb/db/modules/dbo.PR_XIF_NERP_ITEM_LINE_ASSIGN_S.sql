
CREATE PROCEDURE [dbo].[PR_XIF_NERP_ITEM_LINE_ASSIGN_S]
/*
-- ================================================================================================
-- BATCH PERIOD        : 1DAY
-- DESCRIPTION         : 
-- 1. XIF_ERP_ITEM_LINE_ASSIGN_S 테이블을 기초로 ERP NPP0153에 전송 준비(IFSEQ 목록)
-- 2. IF 테이블을 리턴한다 (IFSEQ 기준으로 미전송 데이터를 리턴)
-- 3. IF 테이블에 전송결과를 저장한다 (IFSEQ 기준으로 전송결과 / 전송시간 기록)
-- SOURCE SYSTEM       : FP
-- DESTINATION SYSTEM  : NERP
-- SOURCE TABLE        : XIF_ERP_ITEM_LINE_ASSIGN_S
-- DESTINATION TABLE   : 
--
-- CREATE DATE		   : 2024.05.016
-- command : create - today production plan
-- command : list - list all data (if_seq)
-- command : success - update if 'S'
-- command : fail - update if 'F'
-- VERSION             : 1.0
--- 06/25 OC 정보만 전송함
--           2025-01-04   kimcd   NERP 대상 PLANT만 전송하도록 제한
-- ================================================================================================
*/
-- PARAMETER

@p_option NVARCHAR(10) = 'create', -- create (list ifseq) , list (list with if_seq) , success (set success with if_seq) , fail (set fail with if_seq)
@p_if_seq NVARCHAR(50) = 'NULL',
@p_company_id NVARCHAR(50) = '' -- not used yet

AS

BEGIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_NERP_ITEM_LINE_ASSIGN_S'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	  = 0
	DECLARE @sysdate     DATETIME     = GETDATE()

	DECLARE @ROWCOUNT    INTEGER

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)


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
	   -- FAIL의 경우 재전송하는 경우
	   --select ifseqno from dbo.SY_XIF_ERP_ITEM_LINE_ASSIGN_S with(nolock) where  TRANSFER_FLAG <> 'Y' group by ifseqno

	   -- 한번 전송해 보고 실패하면 무시
	   select ifseqno from dbo.SY_XIF_ERP_ITEM_LINE_ASSIGN_S S with(nolock) 
	   inner join SCM_PLANT_M M with(nolock) 
	   on S.plant_id = M.plant_id
	   where  1=1
	   and S.TRANSFER_FLAG = 'N' 
	   and M.PLANT_ID IN  (SELECT SLV.SEGMENT1 FROM SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK) WHERE SLV.LOOKUP_TYPE_CODE = 'NERP_PLANT' AND SLV.ACTIVE_FLAG = 'Y' )  -- 2025-01-04   kimcd   NERP 대상 PLANT만 전송하도록 제한
	   group by ifseqno
	   order by ifseqno


		COMMIT TRAN
	END	ELSE IF @p_option = 'list' BEGIN
			EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'START READ IF DATA', 0, @V_TEMP1, '############### START OF LIST ###############', @p_if_seq, @SYSDATE
		    BEGIN TRAN
		--print @p_if_seq
		--print '---0-'
		IF isnull(@p_if_seq,'') <> '' 
		BEGIN
			--print '--1-'
			SELECT *
			
		 from SY_XIF_ERP_ITEM_LINE_ASSIGN_S S with(nolock) 
		   inner join SCM_PLANT_M M with(nolock) 
		   on S.plant_id = M.plant_id
		   where  1=1
		   and S.[IFSEQNO] = @p_if_seq 
		   and S.TRANSFER_FLAG = 'N' 
		   and M.PLANT_ID IN  (SELECT SLV.SEGMENT1 FROM SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK) WHERE SLV.LOOKUP_TYPE_CODE = 'NERP_PLANT' AND SLV.ACTIVE_FLAG = 'Y' )  -- 2025-01-04   kimcd   NERP 대상 PLANT만 전송하도록 제한

		END
			COMMIT TRAN
			EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'START READ IF DATA', @ROWCOUNT, @V_TEMP1, '############### END OF LIST ###############', NULL, @SYSDATE
	END ELSE IF @p_option = 'success' BEGIN
			--print 'success'
			--print @p_if_seq
		EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'START UPDATE IF RESULT', 0, @V_TEMP1, '############### START OF UPDATE ###############', @p_if_seq, @SYSDATE
		BEGIN TRAN
			IF isnull(@p_if_seq,'') <> '' BEGIN
			--update SY_XIF_ERP_ITEM_LINE_ASSIGN_S SET [TRANSFER_FLAG] = 'Y', [TRANSFER_DATE] = GetDate() where [IFSEQNO] = @p_if_seq
				update SY_XIF_ERP_ITEM_LINE_ASSIGN_S
				SET [TRANSFER_FLAG] = 'Y', [TRANSFER_DATE] = GetDate() 
				from SCM_PLANT_M
				where 1=1
				and SY_XIF_ERP_ITEM_LINE_ASSIGN_S.PLANT_ID = SCM_PLANT_M.PLANT_ID
				and [IFSEQNO] = @p_if_seq
				and SCM_PLANT_M.PLANT_ID IN  (SELECT SLV.SEGMENT1 FROM SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK) WHERE SLV.LOOKUP_TYPE_CODE = 'NERP_PLANT' AND SLV.ACTIVE_FLAG = 'Y' )  -- 2025-01-04   kimcd   NERP 대상 PLANT만 전송하도록 제한
				and SY_XIF_ERP_ITEM_LINE_ASSIGN_S.TRANSFER_FLAG = 'N'
			--print @p_if_seq --	20240508145846

			END
		COMMIT TRAN
			EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'END UPDATE IF RESULT', @ROWCOUNT, @V_TEMP1, '############### END OF UPDATE ###############', NULL, @SYSDATE
	END ELSE IF @p_option = 'fail' BEGIN
		EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'ERROR', 0, @V_TEMP1, '############### START OF UPDATE ###############', @p_if_seq, @SYSDATE
		
		BEGIN TRAN
			IF isnull(@p_if_seq,'') <> '' BEGIN
				update SY_XIF_ERP_ITEM_LINE_ASSIGN_S
				SET [TRANSFER_FLAG] = 'F', [TRANSFER_DATE] = GetDate() 
				from SCM_PLANT_M
				where 1=1
				and SY_XIF_ERP_ITEM_LINE_ASSIGN_S.PLANT_ID = SCM_PLANT_M.PLANT_ID
				and [IFSEQNO] = @p_if_seq
				and SCM_PLANT_M.PLANT_ID IN  (SELECT SLV.SEGMENT1 FROM SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK) WHERE SLV.LOOKUP_TYPE_CODE = 'NERP_PLANT' AND SLV.ACTIVE_FLAG = 'Y' )  -- 2025-01-04   kimcd   NERP 대상 PLANT만 전송하도록 제한
				and SY_XIF_ERP_ITEM_LINE_ASSIGN_S.TRANSFER_FLAG = 'N'
			END
		COMMIT TRAN
			EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'END UPDATE IF FAIL', @ROWCOUNT, @V_TEMP1, '############### END OF UPDATE ###############', NULL, @SYSDATE
	END
	






	END TRY	
	BEGIN CATCH

	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		-- print @v_descr
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate
	END CATCH

	EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate

end
