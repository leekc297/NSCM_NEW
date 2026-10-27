

CREATE PROCEDURE [dbo].[PR_SCM_ITEM_M_SELF_REPAIR]
-- ================================================================================================
-- Program ID          : FP00190
-- Program Name        : PR_SCM_ITEM_M_SELF_REPAIR
-- Param               :
-- Batch Period        : 6Hour
-- Description         : 신규 생성 E20260202-000115 -MMD IF 재 정비 건 1. Nick name 2 mes route
--
-- Source System       : ERP
-- Destination System  : FP SDB
-- Source Table        : SCM_ITEM_M
-- Destination Table   : SCM_ITEM_M 
--
-- Create(Update) Date : 2026.02.10
-- Update Date		   :  


-- Author              : SEOYNGSN
-- Version             : 
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON


	
	-- LOG 용 변수 설정
	DECLARE @ROWCOUNT         INTEGER 
	DECLARE @v_proc_name      NVARCHAR(100) 
	DECLARE @sysdate          DATETIME2
	DECLARE @v_master_id      NVARCHAR(30)
	DECLARE @v_plan_id        NVARCHAR(30)
	DECLARE @v_descr          NVARCHAR(250)
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000) 


	SET @v_master_id = '-'
	SET @v_plan_id   = '-'
	SET @v_proc_name = 'PR_SCM_ITEM_M_SELF_REPAIR'
	SET @v_descr = '############### Start of procedure ###############' 
	SET @sysdate = GETDATE()


	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))		
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START',    1, null, @v_descr, null
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, @v_descr, NULL, @sysdate

	BEGIN TRY

		BEGIN TRAN

		UPDATE A
		SET A.DESCRIPTION = B.DESCRIPTION
		--SELECT A.DESCRIPTION , B.DESCRIPTION
		FROM SCM_ITEM_M A WITH(NOLOCK)
		INNER JOIN (			
					SELECT  ITEM_ID, DESCRIPTION
					FROM (
							SELECT *,
									ROW_NUMBER() OVER (
										PARTITION BY ITEM_ID 
										ORDER BY INSERT_TIME DESC
									) AS RN
							FROM SCM_ITEM_M WITH(NOLOCK)
							WHERE DESCRIPTION IS NOT NULL
					) X
					WHERE RN = 1		
					) B ON A.ITEM_ID = B.ITEM_ID	
		WHERE 1=1
		AND A.DESCRIPTION IS NULL 
		AND A.FLOW_ID IS NOT NULL

		SET @ROWCOUNT = @@ROWCOUNT

		COMMIT TRAN

		SET @v_descr = 'DESCRIPTION'
		EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, 'SCM_ITEM_M', 'UPDATE',    @ROWCOUNT, null, @v_descr, null

		BEGIN TRAN --rollback
		UPDATE A
		   SET A.NICK_NAME = CASE WHEN ( A.[ITEM_ID] LIKE 'ASLPD%' OR A.[ITEM_ID] LIKE 'ASLPW%' ) THEN A.[NICK_NAME] ELSE B.NICK_NAME END --B.NICK_NAME
		--SELECT A.NICK_NAME , B.NICK_NAME
		FROM SCM_ITEM_M A WITH(NOLOCK)
		INNER JOIN (			
					SELECT  ITEM_ID, NICK_NAME
					FROM (
							SELECT *,
									ROW_NUMBER() OVER (
										PARTITION BY ITEM_ID 
										ORDER BY INSERT_TIME DESC
									) AS RN
							FROM SCM_ITEM_M WITH(NOLOCK)
							WHERE NICK_NAME IS NOT NULL
					) X
					WHERE RN = 1		
					) B ON A.ITEM_ID = B.ITEM_ID	
		WHERE 1=1
		AND A.NICK_NAME IS NULL 
		AND A.FLOW_ID IS NOT NULL

		SET @ROWCOUNT = @@ROWCOUNT 

		COMMIT TRAN

		SET @v_descr = 'NICK_NAME'
		EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, 'SCM_ITEM_M', 'UPDATE',    @ROWCOUNT, null, @v_descr, null


		BEGIN TRAN
		UPDATE A
		SET A.PACK_PRODUCT_GROUP_CODE = B.PACK_PRODUCT_GROUP_CODE
		--SELECT A.PACK_PRODUCT_GROUP_CODE, B.PACK_PRODUCT_GROUP_CODE
		FROM SCM_ITEM_M A WITH(NOLOCK)
		INNER JOIN (			
					SELECT  ITEM_ID, PACK_PRODUCT_GROUP_CODE
					FROM (
							SELECT *,
									ROW_NUMBER() OVER (
										PARTITION BY ITEM_ID 
										ORDER BY INSERT_TIME DESC
									) AS RN
							FROM SCM_ITEM_M WITH(NOLOCK)
							WHERE PACK_PRODUCT_GROUP_CODE IS NOT NULL
					) X
					WHERE RN = 1		
					) B ON A.ITEM_ID = B.ITEM_ID	
		WHERE 1=1
		AND A.PACK_PRODUCT_GROUP_CODE IS NULL 
		AND A.FLOW_ID IS NOT NULL

		SET @ROWCOUNT = @@ROWCOUNT				
		 
		COMMIT TRAN

		SET @v_descr = 'PACK_PRODUCT_GROUP_CODE'
		EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, 'SCM_ITEM_M', 'UPDATE',    @ROWCOUNT, null, @v_descr, null

		

		
		SET @v_descr = '############### End of procedure ###############'
		EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, @v_descr, null
		EXEC PR_XIF_LOG @v_proc_name, NULL,   'END', NULL, @v_temp1, @v_descr, NULL, @sysdate
		
	END TRY
	BEGIN CATCH		
	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()	
		EXEC PR_XIF_LOG @v_proc_name, @v_descr, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END

