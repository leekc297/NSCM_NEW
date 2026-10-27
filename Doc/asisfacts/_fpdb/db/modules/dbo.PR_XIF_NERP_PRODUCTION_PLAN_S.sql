

CREATE PROCEDURE [dbo].[PR_XIF_NERP_PRODUCTION_PLAN_S]
/*
-- ================================================================================================
-- BATCH PERIOD        : 1DAY
-- DESCRIPTION         : 
-- 1. XIF_ERP_PRODUCTION_PLAN_S 테이블을 기초로 ERP NPP0210에 전송 준비(IFSEQ 목록)
-- 2. IF 테이블을 리턴한다 (IFSEQ 기준으로 미전송 데이터를 리턴)
-- 3. IF 테이블에 전송결과를 저장한다 (IFSEQ 기준으로 전송결과 / 전송시간 기록)
-- SOURCE SYSTEM       : FP
-- DESTINATION SYSTEM  : NERP
-- SOURCE TABLE        : XIF_ERP_PRODUCTION_PLAN_S
-- DESTINATION TABLE   : 
--
-- CREATE DATE		   : 2024.05.016
-- command : create - today production plan
-- command : list - list all data (if_seq)
-- command : success - update if 'S'
-- command : fail - update if 'F'
-- VERSION             : 1.0
-- ================================================================================================
   2024/12/19 NERP IF COlumnn 추가 반영
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
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_NERP_PRODUCTION_PLAN_S'
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
	   --select ifseqno from dbo.SY_XIF_ERP_PRODUCTION_PLAN_S with(nolock) where  TRANSFER_FLAG <> 'Y' group by ifseqno

	   -- 한번 전송해 보고 실패하면 무시
	   --select ifseqno from dbo.SY_XIF_ERP_PRODUCTION_PLAN_S with(nolock) where  TRANSFER_FLAG = 'N' and plant_id like 'HQ%' group by ifseqno

	   SELECT IFSEQNO FROM DBO.SY_XIF_ERP_PRODUCTION_PLAN_S A WITH(NOLOCK) 
	   INNER JOIN SCM_SYS_LOOKUP_VALUE B
	   ON A.PLANT_ID = B.SEGMENT1
	   AND B.LOOKUP_TYPE_CODE = 'NERP_PLANT'
	   AND B.ACTIVE_FLAG = 'Y'
	   WHERE  TRANSFER_FLAG = 'N' 
	   GROUP BY IFSEQNO


		COMMIT TRAN
	END	ELSE IF @p_option = 'list' BEGIN
			EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'START READ IF DATA', 0, @V_TEMP1, '############### START OF LIST ###############', @p_if_seq, @SYSDATE
		    BEGIN TRAN
		--print @p_if_seq
		--print '---0-'
		IF isnull(@p_if_seq,'') <> '' BEGIN
			--print '--1-'
			SELECT left(FP_PLAN_ID ,len(FP_PLAN_ID) - 12) as plan_instance,
			substring(A.create_user_id,1,12) as create_psn_id, 
			substring(A.modify_user_id,1,12) as UPDATE_PSN_ID,
			FORMAT(A.modify_date, 'yyyyMMddhhmmss') as update_date,
			A.attribute2 as attr_01,
			A.attribute3 as attr_02,
			A.attribute4 as attr_03,
			A.attribute5 as attr_04,
			A.attribute6 as attr_05,

			[IFSEQNO]
			,[SEQ]
			,[FP_PLAN_ID]
			,A.[PLANT_ID]
			,A.[FACTORY_ID]
			,A.[LINE_ID]
			,A.[OPERATION_ID]
			,A.[BOM_VERSION_ID]
			,A.[WORK_CENTER_ID]
			,A.[ITEM_ID]
			,A.[DEMAND_ID]
			,A.[WORK_ORDER_ID]
			,A.[ORDER_TYPE]
			,A.[PLAN_DATE]
			,A.[START_TIME]
			,A.[END_TIME]
			,A.[PLAN_IN_QTY]
			,A.[PLAN_QTY]
			,A.[FIX_TYPE]
			,A.[TRANSFER_FLAG]
			,A.[TRANSFER_DATE]
			,A.[CREATE_USER_ID]
			,FORMAT(A.CREATE_DATE, 'yyyyMMddhhmmss') AS [CREATE_DATE]
			,A.[MODIFY_USER_ID]
			,A.[MODIFY_DATE]
			,A.[LANE_QTY]
			,A.[BATCH_ORDER_ID]
			,A.[SLITTER_PLANT]
			,A.[MARKET]
			,A.[ATTRIBUTE1]
			,A.[ATTRIBUTE2]
			,A.[ATTRIBUTE3]
			,A.[ATTRIBUTE4]
			,A.[ATTRIBUTE5]
			,A.[ATTRIBUTE6]
			,A.[ATTRIBUTE7]
			,A.[ATTRIBUTE8]
			,A.[ATTRIBUTE9]
			,A.[ATTRIBUTE10]
			,[TOP_BACK_IND]
			,[LINK_WO]
			,[FP_PLAN_QTY]
			,[FP_SNAP_QTY]
			,[TECO_IND]
			,[ZMODEL]
			,[VERSION]
			,NULL AS [SERIAL] -- 2024/08/30 이정성 연구위원 요청 // 
			,[EQUIPMENT_ID]
			,[PLAN_GRP]
			,[PLAN_WEEK]
			,[SCP_PLAN_ID]
			,[CUDTY]	
		from SY_XIF_ERP_PRODUCTION_PLAN_S A with(nolock) 
		INNER JOIN SCM_SYS_LOOKUP_VALUE B
		        ON A.PLANT_ID = B.SEGMENT1
		       AND B.LOOKUP_TYPE_CODE = 'NERP_PLANT'
			   AND B.ACTIVE_FLAG = 'Y'
		where [IFSEQNO] = @p_if_seq 

	 --from SY_XIF_ERP_PRODUCTION_PLAN_S A with(nolock) where [IFSEQNO] = @p_if_seq and plant_id like 'HQ%'

		END
			COMMIT TRAN
			EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'START READ IF DATA', @ROWCOUNT, @V_TEMP1, '############### END OF LIST ###############', NULL, @SYSDATE
	END ELSE IF @p_option = 'success' BEGIN
			--print 'success'
			--print @p_if_seq
			EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'START UPDATE IF RESULT', 0, @V_TEMP1, '############### START OF UPDATE ###############', @p_if_seq, @SYSDATE
		   BEGIN TRAN
		IF isnull(@p_if_seq,'') <> '' BEGIN

			UPDATE SY_XIF_ERP_PRODUCTION_PLAN_S 
			SET [TRANSFER_FLAG] = 'Y', 
			[TRANSFER_DATE] = GETDATE() 
			FROM SY_XIF_ERP_PRODUCTION_PLAN_S A, SCM_SYS_LOOKUP_VALUE B
			WHERE A.PLANT_ID = B.SEGMENT1
			  AND B.LOOKUP_TYPE_CODE = 'NERP_PLANT'
			  AND B.ACTIVE_FLAG = 'Y'
			  AND A.[IFSEQNO] = @p_if_seq

		--update SY_XIF_ERP_PRODUCTION_PLAN_S SET [TRANSFER_FLAG] = 'Y', [TRANSFER_DATE] = GetDate() where [IFSEQNO] = @p_if_seq and plant_id like 'HQ%'
			--print @p_if_seq --	20240508145846

		END
		COMMIT TRAN
			EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'END UPDATE IF RESULT', @ROWCOUNT, @V_TEMP1, '############### END OF UPDATE ###############', NULL, @SYSDATE
	END ELSE IF @p_option = 'fail' BEGIN
			EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'START UPDATE IF FAIL', 0, @V_TEMP1, '############### START OF UPDATE ###############', @p_if_seq, @SYSDATE
		   BEGIN TRAN
		IF isnull(@p_if_seq,'') <> '' BEGIN

				UPDATE SY_XIF_ERP_PRODUCTION_PLAN_S 
			SET [TRANSFER_FLAG] = 'F', 
			[TRANSFER_DATE] = GETDATE() 
			FROM SY_XIF_ERP_PRODUCTION_PLAN_S A, SCM_SYS_LOOKUP_VALUE B
			WHERE A.PLANT_ID = B.SEGMENT1
			  AND B.LOOKUP_TYPE_CODE = 'NERP_PLANT'
			  AND B.ACTIVE_FLAG = 'Y'
			  AND A.[IFSEQNO] = @p_if_seq

		--update SY_XIF_ERP_PRODUCTION_PLAN_S SET [TRANSFER_FLAG] = 'F', [TRANSFER_DATE] = GetDate() where [IFSEQNO] = @p_if_seq and plant_id like 'HQ%'

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
