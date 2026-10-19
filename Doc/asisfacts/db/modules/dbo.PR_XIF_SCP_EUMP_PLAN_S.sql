/*
 * Program ID   : PR_XIF_SCP_EUMP_PLAN_S
 * Description  :SCP -> EUMP 생산계획 I/F , 주단위 
 * OutTable     : PR_XIF_SCP_EUMP_PLAN_S (I/F Table)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2026.06.18	YMH			   [E20260604-001210] 	[공급/생산SCM PI팀] Supply Plan Data I/F 개발 요청 건(SCM_SCP → EUM)
 *===================================================================================================
 */
 
CREATE PROCEDURE [dbo].[PR_XIF_SCP_EUMP_PLAN_S] 
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_XIF_SCP_EUMP_PLAN_S';
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

		INSERT INTO XIF_SCP_EUMP_PLAN_S_SN(
			  [IF_SEQ]
			, [IF_TYPE]
			, [IF_ID]
			, [IF_INS_DATE]
			, [IF_FLAG]
			, [DIVISION_ID]
			, [PLAN_START_YYYYMMDD]
			, [PLAN_TYPE]
			, [SEQ]
			, [OPERATION_GROUP]
			, [SCM_SITE_ID]
			, [ITEM_ID]
			, [FACTORY_ID]
			, [LINE_ID]
			, [OPERATION_ID]
			, [MEASURE]
			, [YYYYPW]
			, [QTY]
			, [UNIT]
			, [CREATED_BY]
			, [CREATION_DATE]
			, [LAST_UPDATED_BY]
			, [LAST_UPDATE_DATE]
			, [ATTRIBUTE1]
			, [ATTRIBUTE2]
			, [ATTRIBUTE3]
			, [ATTRIBUTE4]
			, [ATTRIBUTE5]
			, [ATTRIBUTE6]
			, [ATTRIBUTE7]
			, [ATTRIBUTE8]
			, [ATTRIBUTE9]
			, [ATTRIBUTE10]
		
		)
		SELECT 'OSCM' + CONVERT(VARCHAR,GETDATE(),12) + DBO.FN_ZERO_LPAD(CONVERT(VARCHAR,NEXT VALUE FOR DBO.SEQ1_XIF_SCP_EUMP_PLAN_S),10)  AS IF_SEQ		
			, 'S' AS IF_TYPE				
			, 'OSCM_GEUP_SCP_EUMP_PLAN' AS IF_ID						
			, GETDATE() AS IF_INS_DATE		
			, 'N' AS IF_FLAG		
			, PP.DIVISION_ID 
			, PP.PLAN_START_YYYYMMDD 
			, PP.PLAN_TYPE 
			, PP.SEQ 
			, PP.OPERATION_GROUP 				
			, PP.SCM_SITE_ID				
			, PP.ITEM_ID 				
			, ISNULL(MAX(LN.FACTORY_ID),'-') AS FACTORY_ID				
			, PP.LINE_ID 										
			, PP.OPERATION_ID 							
			, PP.MEASURE 				
			, CAL.CALENDAR_YYYY + CAL.PARTIAL_WEEK_NAME AS YYYYPW				
			, SUM(QTY) AS QTY				
			, MAX(X.ITEM_UOM) AS UNIT				
			, 'SCP_BATCH'
			, GETDATE()
			, 'SCP_BATCH'
			, GETDATE()
			, NULL -- ATTRIBUTE1
			, NULL -- ATTRIBUTE2
			, NULL -- ATTRIBUTE3
			, NULL -- ATTRIBUTE4
			, NULL -- ATTRIBUTE5
			, NULL -- ATTRIBUTE6
			, NULL -- ATTRIBUTE7
			, NULL -- ATTRIBUTE8
			, NULL -- ATTRIBUTE9
			, NULL -- ATTRIBUTE10
		FROM SCP_ANL_PRODUCTION_PLAN AS PP WITH(NOLOCK)					
			JOIN 				
			(				
				SELECT PL.HORIZON_END_DATE ,  PLD.DIVISION_ID ,PLD.PLAN_TYPE, PLD.PLAN_SEQ  , ROW_NUM FROM SCM_MST_PLAN AS PL			
					JOIN 		
					(		
							SELECT PLAN_ID , DIVISION_ID ,PLAN_TYPE, PLAN_SEQ 
							, ROW_NUMBER() OVER(PARTITION BY DIVISION_ID,PLAN_TYPE ORDER BY DIVISION_ID,PLAN_TYPE,PLAN_SEQ DESC) AS ROW_NUM
							FROM SCM_MST_PLAN_DETAIL WITH(NOLOCK)
							WHERE PLAN_ID = @V_PLAN_ID
							AND PLAN_TYPE = 'FN'
							AND PLAN_STATUS = '1'
							AND CONFIRM_FLAG = 'Y'
					) AS PLD		
					ON PL.PLAN_ID = PLD.PLAN_ID		
					AND PL.DIVISION_ID = PLD.DIVISION_ID		
					AND PL.PLAN_NAME = @v_plan_start_yyyymmdd		
				WHERE ROW_NUM = 1			
			) AS PD 				
			ON PP.DIVISION_ID = PD.DIVISION_ID				
			AND PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd				
			AND PP.PLAN_TYPE = PD.PLAN_TYPE				
			AND PP.SEQ = PD.PLAN_SEQ				
			AND MEASURE LIKE 'PROD_PLAN_AMEND'				
			AND PP.YYYYMMDD <= PD.HORIZON_END_DATE				
			JOIN  --- 주통합하여 보내달라고 하여 LEFT(PARTIAL_WEEK_NAME,3) 처리함.
			(
				SELECT BASIS_YYYYMMDD , CALENDAR_YYYY , LEFT(PARTIAL_WEEK_NAME,3) AS PARTIAL_WEEK_NAME FROM [SCM_SYS_CALENDAR_M] 
				GROUP BY BASIS_YYYYMMDD , CALENDAR_YYYY , LEFT(PARTIAL_WEEK_NAME,3)				
			) AS CAL				
			
			ON PP.YYYYMMDD = BASIS_YYYYMMDD		
			LEFT JOIN 				
			(				
				SELECT LINE_ID , MAX(LINE_NAME) AS LINE_NAME , MAX(FACTORY_ID) AS FACTORY_ID FROM SCM_MST_LINE_SN WITH(NOLOCK)			
				GROUP BY LINE_ID			
			) AS LN				
			ON PP.LINE_ID = LN.LINE_ID					
			LEFT JOIN				
			(				
				SELECT DISTINCT ITEM_ID			
          			, ITEM_UOM				
          			, MIN(DIVISION_ID) AS DIVISION_ID				
          		FROM SCM_MST_ITEM_SN WITH(NOLOCK)					
          		WHERE 1=1 					
          		GROUP BY ITEM_ID, ITEM_UOM					
			) X 				
			ON PP.ITEM_ID = X.ITEM_ID				
					
		WHERE PP.OPERATION_GROUP = 'A'
		/* CSR 요청은 전극과 셀이였지만 업무협의중에 A 만 보내달라고 요청이 옴.
		WHERE ( 					
			(PP.DIVISION_ID LIKE 'EE%' AND PP.OPERATION_GROUP = 'E')				
			OR				
			(PP.DIVISION_ID NOT LIKE 'EE%' AND PP.OPERATION_GROUP = 'A')				
		)
		*/
						
		GROUP BY PP.DIVISION_ID , PP.PLAN_START_YYYYMMDD , PP.PLAN_TYPE , PP.SEQ , PP.OPERATION_GROUP , PP.SCM_SITE_ID , PP.ITEM_ID , PP.LINE_ID , PP.OPERATION_ID , PP.MEASURE 					
		, CAL.CALENDAR_YYYY + CAL.PARTIAL_WEEK_NAME						
	
		;

		SET @n_log_count = @@ROWCOUNT;		
		SET @v_log_type = 'ING';
		SET @v_log_message = 'INSERT INTO XIF_SCP_EUMP_PLAN_S_SN';
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









