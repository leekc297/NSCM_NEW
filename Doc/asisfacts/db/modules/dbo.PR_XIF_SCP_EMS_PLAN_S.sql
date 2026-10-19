/*
 * Program ID   : PR_XIF_SCP_EMS_PLAN_S
 * Description  : SINGLEX 설비관리 시스템(EMS)에 월간합계 생산계획 데이터 제공. MQ 전송. 매주 일요일 I/F
 * OutTable     : XIF_SCP_EMS_PLAN_S (I/F Table)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2025.12.08	park.choyi	   [E20251107-001669] Initial Release
 *===================================================================================================
 */

CREATE PROCEDURE [dbo].[PR_XIF_SCP_EMS_PLAN_S] 
    @p_plan_start_yyyymmdd          NVARCHAR(08)
AS

BEGIN
	
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	
    DECLARE @v_plan_id                    NVARCHAR(30);
    DECLARE @v_plan_start_yyyymmdd        NVARCHAR(08);

	SET @v_plan_start_yyyymmdd = ISNULL(@p_plan_start_yyyymmdd, '');

	IF @v_plan_start_yyyymmdd = '' 
		SET @v_plan_start_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) 

	SELECT @v_plan_id = MAX(PLAN_ID)
	FROM   SCM_MST_PLAN WITH(NOLOCK)
	WHERE  PLAN_CYCLE	= 'WEEKLY'
	AND    PLAN_NAME	= @v_plan_start_yyyymmdd
	;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_XIF_SCP_EMS_PLAN_S';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '@p_plan_start_yyyymmdd : ' + ISNULL(@p_plan_start_yyyymmdd, 'NULL') + '/@v_plan_start_yyyymmdd : ' + ISNULL(@v_plan_start_yyyymmdd, 'NULL') + '/@v_plan_id : ' + ISNULL(@v_plan_id, 'NULL') ;
	SET @d_event_date = SYSDATETIME();

	EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;



	BEGIN TRANSACTION;
		BEGIN TRY
		BEGIN

		INSERT INTO XIF_SCP_EMS_PLAN_S_SN(
			IF_SEQ						,IF_TYPE						,IF_ID							,IF_INS_DATE		
			,IF_FLAG					,DIVISION_ID					,PLAN_START_YYYYMMDD			,PLAN_TYPE						
			,SEQ						,OPERATION_GROUP				,SCM_SITE_ID					,ITEM_ID							
			,MODEL_ID					,MES_LINE_ID					,OPERATION_ID					,MEASURE						
			,YYYYMM						,QTY							,CREATED_BY						,CREATION_DATE					
			,LAST_UPDATED_BY			,LAST_UPDATE_DATE				,ATTRIBUTE1						,ATTRIBUTE2						
			,ATTRIBUTE3					,ATTRIBUTE4						,ATTRIBUTE5						,ATTRIBUTE6						
			,ATTRIBUTE7					,ATTRIBUTE8						,ATTRIBUTE9						,ATTRIBUTE10
		)
		SELECT 'OSCM' + CONVERT(VARCHAR,GETDATE(),12) + DBO.FN_ZERO_LPAD(CONVERT(VARCHAR,NEXT VALUE FOR DBO.SEQ1_XIF_SCP_EMS_PLAN_S),10)  AS IF_SEQ		
			, 'S' AS IF_TYPE				
			, 'OSCM_OEC0_SCP_EMS_PLAN' AS IF_ID						
			, GETDATE() AS IF_INS_DATE		
			, 'N' AS IF_FLAG
			, DIVISION_ID		
			, PLAN_START_YYYYMMDD		
			, PLAN_TYPE		
			, SEQ		
			, OPERATION_GROUP		
			, SCM_SITE_ID		
			, ITEM_ID		
			, MODEL_ID
			, MES_LINE_ID
			, OPERATION_ID		
			, MEASURE		
			, YYYYMM		
			, SUM(QTY)				AS QTY
			, MAX(CREATED_BY)		AS CREATED_BY
			, GETDATE()				AS CREATION_DATE
			, MAX(LAST_UPDATED_BY)	AS LAST_UPDATED_BY
			, GETDATE()				AS LAST_UPDATE_DATE
			, MAX(ATTRIBUTE1)		AS ATTRIBUTE1
			, MAX(ATTRIBUTE2)		AS ATTRIBUTE2
			, MAX(ATTRIBUTE3)		AS ATTRIBUTE3
			, MAX(ATTRIBUTE4)		AS ATTRIBUTE4
			, MAX(ATTRIBUTE5)		AS ATTRIBUTE5
			, MAX(ATTRIBUTE6)		AS ATTRIBUTE6
			, MAX(ATTRIBUTE7)		AS ATTRIBUTE7
			, MAX(ATTRIBUTE8)		AS ATTRIBUTE8
			, MAX(ATTRIBUTE9)		AS ATTRIBUTE9
			, MAX(ATTRIBUTE10)		AS ATTRIBUTE10
		FROM (
			SELECT PP.DIVISION_ID
				, PP.PLAN_START_YYYYMMDD		
				, PP.PLAN_TYPE		
				, PP.SEQ		
				, PP.OPERATION_GROUP		
				, PP.SCM_SITE_ID		
				, PP.ITEM_ID		
				, DBO.FN_GET_ITEM_PROD_OP(PP.DIVISION_ID,PP.OPERATION_GROUP, PP.ITEM_ID) AS MODEL_ID
				, ISNULL(( SELECT TOP 1 NL.MES_LINE_ID
							FROM   SCP_MST_FINAL_ITEM  MFI WITH(NOLOCK)
							, SCM_MST_LINE_SN     NL  WITH(NOLOCK)
							WHERE MFI.DIVISION_ID  = NL.DIVISION_ID
							AND   MFI.FLOW_ID   LIKE NL.OPERATION_ID + '%'
							AND   MFI.ITEM_ID      = PP.ITEM_ID
							AND   NL.LINE_ID       = PP.LINE_ID
					AND   NL.ACTIVE_FLAG   = 'Y' ) ,'-') AS MES_LINE_ID
				, PP.OPERATION_ID		
				, PP.MEASURE		
				, LEFT(PP.YYYYMMDD,6)	AS YYYYMM		
				, QTY
				, CREATED_BY
				, CREATION_DATE
				, LAST_UPDATED_BY
				, LAST_UPDATE_DATE
				, ATTRIBUTE1
				, ATTRIBUTE2
				, ATTRIBUTE3
				, ATTRIBUTE4
				, ATTRIBUTE5
				, ATTRIBUTE6
				, ATTRIBUTE7
				, ATTRIBUTE8
				, ATTRIBUTE9
				, ATTRIBUTE10
			FROM SCP_ANL_PRODUCTION_PLAN PP WITH(NOLOCK)			
				JOIN		
				(		
					SELECT * FROM 	
					(	
						SELECT DIVISION_ID ,PLAN_TYPE, PLAN_SEQ , ROW_NUMBER() OVER(PARTITION BY DIVISION_ID,PLAN_TYPE ORDER BY DIVISION_ID,PLAN_TYPE,PLAN_SEQ DESC) AS ROW_NUM
						FROM SCM_MST_PLAN_DETAIL WITH(NOLOCK)
						WHERE PLAN_ID = @v_plan_id
						AND PLAN_TYPE = 'FN'
						AND PLAN_STATUS = '1'
						AND CONFIRM_FLAG = 'Y'
					) AS LIST 	
					WHERE LIST.ROW_NUM = 1	
				) AS PD		
				ON		PP.DIVISION_ID = PD.DIVISION_ID
				AND		PP.PLAN_TYPE = PD.PLAN_TYPE
				AND		PP.SEQ = PD.PLAN_SEQ
			WHERE	PP.MEASURE = 'PROD_PLAN_AMEND'		
			AND		PP.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
			AND     YYYYMMDD BETWEEN PP.PLAN_START_YYYYMMDD AND DATEADD(D,7*52,PP.PLAN_START_YYYYMMDD)-1 -- 52주			
			)AS LIST

		GROUP BY   			
			  DIVISION_ID		
			, PLAN_START_YYYYMMDD		
			, PLAN_TYPE		
			, SEQ		
			, OPERATION_GROUP		
			, SCM_SITE_ID		
			, ITEM_ID		
			, MODEL_ID
			, MES_LINE_ID
			, OPERATION_ID		
			, MEASURE		
			, YYYYMM		
		;

		SET @n_log_count = @@ROWCOUNT;		
		SET @v_log_type = 'ING';
		SET @v_log_message = 'INSERT INTO XIF_SCP_EMS_PLAN_S_SN';
		SET @d_event_date = SYSDATETIME();

		EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


		END

		COMMIT WORK;


		END TRY

		BEGIN CATCH
		---- 트랜잭션 (END)
		ROLLBACK TRANSACTION;
		  -- ERROR LOG VALUE SAVE
		  SET @v_log_type = 'ERROR';
		  SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		  SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		  SET @d_event_date = SYSDATETIME();

		  SELECT '' + Convert(NVARCHAR(10), ERROR_NUMBER()) + '' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/

		  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		END CATCH;


	--- 수행결과 성공여부 DISPLAY
	--  IF @v_log_message IS NULL
	--  SELECT 'success'
	--;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @d_event_date = SYSDATETIME();
	SET @n_log_count = 0;

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;









