---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 *===================================================================================================
 * PROGRAM ID   : PR_SCP_MST_ITEM_GROUP_OPT_SYNC
 * DESCRIPTION  : 최적화 룩업 DEMAND GROUP 룩업(SCP_OPT_ENG_CONST_DEMAND_GROUP) 을 DEMAND GROUP MASTER UI 데이터로 동기화
 * PROGRAM HISTORY
 *===================================================================================================
 *   DATE       IN CHARGE		DESCRIPTION
 *	2026.09.01	YMH				E20260828-002065 Demand Grouping 데이터 동기화 요청 INIT
 *===================================================================================================
 *===================================================================================================     
*/
CREATE PROC [dbo].[PR_SCP_MST_ITEM_GROUP_OPT_SYNC]
AS
	SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	-- LOG 용 변수 설정
    DECLARE @V_PROGRAM_NAME		NVARCHAR(150) = 'PR_SCP_MST_ITEM_GROUP_OPT_SYNC';
    DECLARE @V_LOG_TYPE			NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @N_LOG_COUNT		INTEGER = 0;
    DECLARE @V_LOG_MESSAGE		NVARCHAR(1000);
    DECLARE @V_DESCRIPTION		NVARCHAR(500);
    DECLARE @D_EVENT_DATE		DATETIME;
    DECLARE @N_DELETE_COUNT		INTEGER = 0;
    DECLARE @N_INSERT_COUNT     INTEGER = 0;

	-- 시작 LOG
	SET @V_LOG_TYPE = 'START';
	SET @V_LOG_MESSAGE = '########## START OF PROCEDURE ##########';
	SET @V_DESCRIPTION = '';
	SET @D_EVENT_DATE = SYSDATETIME();
	EXEC  PR_SCM_SYS_LOG_BATCH @V_PROGRAM_NAME, @V_LOG_TYPE, @N_LOG_COUNT, @V_LOG_MESSAGE, @V_DESCRIPTION, @D_EVENT_DATE;

	BEGIN TRY

		DECLARE @MAX_NUM VARCHAR(5)
		-- 내부번호를 위한 카운트 설정-- 키값에 'G'에 0으로 4자리 채우고 1씩 증가시킴?
		SELECT @MAX_NUM = CAST(MAX(SUBSTRING(GROUP_ID,2,5)) AS INT)   FROM SCP_MST_ITEM_GROUP WITH(NOLOCK)

		INSERT INTO SCP_MST_ITEM_GROUP
		(DIVISION_ID,GROUP_ID,GROUP_NAME,OPERATION_GROUP,VALID_YN,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE)
		SELECT 
			  DIVISION_ID														AS DIVISION_ID
			, 'G'+  REPLICATE('0',5-LEN(NEW_NUM)) + CONVERT(VARCHAR,NEW_NUM)	AS GROUP_ID
			, GROUP_NM															AS GROUP_NAME
			, 'P'																AS OPERATION_GROUP
			, 'Y'																AS VALID_YN
			, @V_PROGRAM_NAME													AS CREATED_BY
			, GETDATE()															AS CREATION_DATE
			, @V_PROGRAM_NAME													AS LAST_UPDATED_BY
			, GETDATE()															AS LAST_UPDATE_DATE
		FROM 
		(
			SELECT
				  SEGMENT2 AS DIVISION_ID
				, SEGMENT4 AS GROUP_NM
				, @MAX_NUM + ROW_NUMBER() OVER(ORDER BY SEGMENT4) AS NEW_NUM
			FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL AS A WITH(NOLOCK)
			WHERE	LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP' 
			AND		SEGMENT2	= '82'
			AND		SEGMENT3	LIKE 'ET%'
			AND		VALID_YN	= 'Y'
			AND NOT EXISTS
			(
				SELECT * FROM SCP_MST_ITEM_GROUP AS B WITH(NOLOCK)
				WHERE DIVISION_ID	= '82'
				AND A.SEGMENT4		= B.GROUP_NAME
			)
			GROUP BY SEGMENT2 , SEGMENT4
		) AS LIST

		EXEC PR_SCM_MST_GROUP_DETAIL_OPT_SYNC

	END TRY
	BEGIN CATCH
	    		
		-- ERROR LOG
		SET @V_LOG_TYPE = 'ERROR';
		SET @V_LOG_MESSAGE = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @V_DESCRIPTION = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @D_EVENT_DATE = SYSDATETIME();

		EXEC PR_SCM_SYS_LOG_BATCH @V_PROGRAM_NAME, @V_LOG_TYPE, @N_LOG_COUNT, @V_LOG_MESSAGE, @V_DESCRIPTION, @D_EVENT_DATE;
		
    END CATCH;

	-- 시작 LOG
	SET @V_LOG_TYPE = 'END';
	SET @V_LOG_MESSAGE = '########## END OF PROCEDURE ##########';
	SET @V_DESCRIPTION = '';
	SET @D_EVENT_DATE = SYSDATETIME();
	EXEC  PR_SCM_SYS_LOG_BATCH @V_PROGRAM_NAME, @V_LOG_TYPE, @N_LOG_COUNT, @V_LOG_MESSAGE, @V_DESCRIPTION, @D_EVENT_DATE;

