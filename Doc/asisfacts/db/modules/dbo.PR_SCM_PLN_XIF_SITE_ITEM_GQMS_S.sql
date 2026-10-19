/*
 * Program ID   : PR_SCM_PLN_XIF_SITE_ITEM_GQMS_S
 * Description  : PR_SCM_PLN_XIF_SITE_ITEM_GQMS_S
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20220823		kdw2819		프로시저 생성
 * 20240321		JSSBAE		[E20240320-000882]_DM XIF 인덱스 생성 요청_데이터 삭제 로직 추가
 *===================================================================================================
 */

CREATE PROCEDURE [dbo].[PR_SCM_PLN_XIF_SITE_ITEM_GQMS_S] 
	-- @p_division_id			NVARCHAR(30)  -- 사용하지 않는 파라메터
AS

BEGIN

PRINT 'A:' + CONVERT(NVARCHAR(50), GETDATE(), 121)
	
	
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	---- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_PLN_XIF_SITE_ITEM_GQMS_S';
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
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	--	 시작 LOG  (END)


	BEGIN TRANSACTION GQMS_S;
		BEGIN TRY		
		
		/*-------------------------------------------------------------------------------------------------------
			매일 1회 도는 배치로 14일 이전 데이터는 삭제한다. 
			--[E20240320-000882]_DM XIF 인덱스 생성 요청_데이터 삭제 로직이 없어 데이터 계속 쌓이고 있는 상태임으로 
			  데이터 삭제로직 추가
		-------------------------------------------------------------------------------------------------------*/
		BEGIN			
			DELETE FROM XIF_SCM_MST_SITE_ITEM_S_SN
			WHERE CONVERT(NVARCHAR, IF_INS_DATE ,112) < CONVERT(NVARCHAR, DATEADD(DAY, -14,GETDATE()), 112)
		END

		BEGIN
		/*		SCM_MST_SITE_ITEM	->		XIF_SCM_MST_SITE_ITEM_S		*/
		INSERT INTO XIF_SCM_MST_SITE_ITEM_S_SN (
			IF_SEQ						,IF_TYPE						,IF_ID							,IF_INS_DATE		
			,IF_FLAG					,DIVISION_ID					,PROJECT_CODE					,SCM_SITE_ID					
			,ITEM_ID					,CURRENCY						,CELL_PER_CAR					,CELL_PER_MODULE				
			,LIABILITY_PERIOD			,SALES_PLAN_ADJUST_YN			,ITEM_HRCY_ID					,VALID_YN						
			,BPMS_EXIST					,CUST_GROUP						,CUST_GROUP_DTL					,OWNER							
			,APPLICATION				,ROUTE							,CREATED_BY						,CREATION_DATE					
			,LAST_UPDATED_BY			,LAST_UPDATE_DATE				,ATTRIBUTE1						,ATTRIBUTE2						
			,ATTRIBUTE3					,ATTRIBUTE4						,ATTRIBUTE5						,ATTRIBUTE6						
			,ATTRIBUTE7					,ATTRIBUTE8						,ATTRIBUTE9						,ATTRIBUTE10					
			,REPORT_GROUP1				,REPORT_GROUP2					,REPORT_GROUP3					,REPORT_GROUP4					
			,REPORT_GROUP5				,REPORT_GROUP6					,REPORT_GROUP7					,REPORT_GROUP8					
			,EDI_LT						,SCP_VMI_LT						,SALES_COMPANY					,SALES_PLANT					
			,PARTIAL_PLAN_YN
		)SELECT 
			'OSCM' + CONVERT(VARCHAR,GETDATE(),12) + DBO.FN_ZERO_LPAD(CONVERT(VARCHAR,NEXT VALUE FOR DBO.SEQ1_XIF_SCM_SITE_ITEM_S),10)  AS IF_SEQ		,'S' AS IF_TYPE				
			,'OSCM_GQMS_XIF_SCM_MST_SITE_ITEM' AS IF_ID					,GETDATE() AS IF_INS_DATE		,'N' AS IF_FLAG						
			,DIVISION_ID				,PROJECT_CODE					,SCM_SITE_ID					,ITEM_ID					
			,CURRENCY					,CELL_PER_CAR					,CELL_PER_MODULE				,LIABILITY_PERIOD				
			,SALES_PLAN_ADJUST_YN		,ITEM_HRCY_ID					,VALID_YN						,BPMS_EXIST						
			,CUST_GROUP					,CUST_GROUP_DTL					,OWNER							,APPLICATION					
			,ROUTE						,CREATED_BY						,CREATION_DATE					,LAST_UPDATED_BY				
			,LAST_UPDATE_DATE			,ATTRIBUTE1						,ATTRIBUTE2						,ATTRIBUTE3						
			,ATTRIBUTE4					,ATTRIBUTE5						,ATTRIBUTE6						,ATTRIBUTE7						
			,ATTRIBUTE8					,ATTRIBUTE9						,ATTRIBUTE10					,REPORT_GROUP1					
			,REPORT_GROUP2				,REPORT_GROUP3					,REPORT_GROUP4					,REPORT_GROUP5					
			,REPORT_GROUP6				,REPORT_GROUP7					,REPORT_GROUP8					,EDI_LT							
			,SCP_VMI_LT					,SALES_COMPANY					,SALES_PLANT					,PARTIAL_PLAN_YN
		FROM SCM_MST_SITE_ITEM;
		END

PRINT 'B:' + CONVERT(NVARCHAR(50), GETDATE(), 121)


		COMMIT WORK;


		END TRY

		BEGIN CATCH
		---- 트랜잭션 (END)
		ROLLBACK TRANSACTION GQMS_S;
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

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;









