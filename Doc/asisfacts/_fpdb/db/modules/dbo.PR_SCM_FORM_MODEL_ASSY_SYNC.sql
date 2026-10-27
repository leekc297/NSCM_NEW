
CREATE PROCEDURE [dbo].[PR_SCM_FORM_MODEL_ASSY_SYNC]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_CONV_SCM_BOM_M_SYNC_1
-- Param               :
-- Batch Period        : 
-- Description         :
--
-- Source System       : FP
-- Destination System  : FP
-- Source Table        : 
-- Destination Table   : 
--
-- Create(Update) Date : 
-- Author              : FP Pjt.
-- Version             : 1.0
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name		NVARCHAR(100) = 'PR_SCM_FORM_MODEL_ASSY_SYNC'
	DECLARE @v_descr			NVARCHAR(250)
	DECLARE @v_count			INTEGER	   = 0
	DECLARE @sysdate			DATETIME2     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1			NVARCHAR(1000)
	DECLARE @v_temp2			NVARCHAR(1000)

    declare @SCM_ITEM_M_ASSY2	table
    (
		[COMPANY_ID]		[nvarchar](30),
		[DIVISION_ID]		[nvarchar](30),
		[SITE_ID]			[nvarchar](30),
		[PLANT_ID]			[nvarchar](30),
		[ITEM_ID]			[nvarchar](50),
		[APPLIED_MODEL]		[nvarchar](50)
	)

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		--BEGIN TRAN
		-- ================================================

		-- 동기화 : 신규 데이터 Insert 
		INSERT INTO @SCM_ITEM_M_ASSY2 (COMPANY_ID, DIVISION_ID, SITE_ID, ITEM_ID, APPLIED_MODEL)
		SELECT COMPANY_ID
		     , DIVISION_ID
			 , SITE_ID
			 , ITEM_ID
			 , CASE WHEN ITEM_CLASS = 'ES2001' THEN 'MT' + SUBSTRING(ITEM_ID, 3, 100)
				    WHEN ITEM_CLASS = 'ES2002' THEN 'MI' + SUBSTRING(ITEM_ID, 3, 100)
				    WHEN ITEM_CLASS = 'ES2003' THEN 'MD' + SUBSTRING(ITEM_ID, 3, 100)
				    WHEN ITEM_CLASS = 'ES2004' THEN 'MC' + SUBSTRING(ITEM_ID, 3, 100)
				    END AS APPLIED_MODEL
		  FROM SCM_ITEM_M WITH(NOLOCK)
		 WHERE ITEM_CLASS IN ('ES2001', 'ES2002', 'ES2003', 'ES2004')

		----SELECT T.*
		--UPDATE T SET T.APPLIED_MODEL = S.APPLIED_MODEL
		--           , T.UPDATE_ID     = @v_proc_name
		--		   , T.UPDATE_TIME   = getdate()
		--  FROM SCM_ITEM_M AS T WITH(NOLOCK)
		--       JOIN @SCM_ITEM_M_ASSY2 AS S 
		--    ON T.COMPANY_ID		= S.COMPANY_ID
		--   AND T.DIVISION_ID	= S.DIVISION_ID
		--   AND T.SITE_ID		= S.SITE_ID
		--   AND T.ITEM_ID		= S.ITEM_ID
		--   AND S.APPLIED_MODEL  IS NOT NULL
		--   AND T.APPLIED_MODEL != S.APPLIED_MODEL


		--SELECT S.APPLIED_MODEL, T.*
		UPDATE T SET T.APPLIED_MODEL = S.APPLIED_MODEL
		           , T.UPDATE_ID     = @v_proc_name
				   , T.UPDATE_TIME   = getdate()
		  FROM SCM_ITEM_M AS T WITH(NOLOCK)
			  JOIN (
		           SELECT DISTINCT X.COMPANY_ID, X.DIVISION_ID, X.SITE_ID, X.CHILD_ITEM_ID AS ITEM_ID, P.APPLIED_MODEL
		             FROM SCM_BOM_M AS X WITH(NOLOCK)
		           	      JOIN SCM_ITEM_M AS C WITH(NOLOCK)
		           	   ON X.COMPANY_ID		= C.COMPANY_ID
		              AND X.DIVISION_ID		= C.DIVISION_ID
		              AND X.SITE_ID			= C.SITE_ID
		              AND X.CHILD_ITEM_ID	= C.ITEM_ID
		              AND C.ITEM_CLASS		= 'ES1901'
		           	      JOIN SCM_ITEM_M AS P WITH(NOLOCK)
		           	   ON X.COMPANY_ID		= P.COMPANY_ID
		              AND X.DIVISION_ID		= P.DIVISION_ID
		              AND X.SITE_ID			= P.SITE_ID
		              AND X.PARENT_ITEM_ID	= P.ITEM_ID
		                  JOIN @SCM_ITEM_M_ASSY2 AS S  
				       ON X.COMPANY_ID		= S.COMPANY_ID
				      AND X.DIVISION_ID		= S.DIVISION_ID
				      AND X.SITE_ID			= S.SITE_ID
				      AND X.PARENT_ITEM_ID	= S.ITEM_ID
					  AND S.APPLIED_MODEL   IS NOT NULL
		           ) AS S
		    ON T.COMPANY_ID		= S.COMPANY_ID
		   AND T.DIVISION_ID	= S.DIVISION_ID
		   AND T.SITE_ID		= S.SITE_ID
		   AND T.ITEM_ID		= S.ITEM_ID
		 WHERE T.APPLIED_MODEL != S.APPLIED_MODEL


 		
		-- ================================================
		--COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

		ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END



