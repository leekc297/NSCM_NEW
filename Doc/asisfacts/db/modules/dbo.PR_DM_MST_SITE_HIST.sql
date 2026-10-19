
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
 * Program ID   : PR_DM_MST_SITE_HIST
 * Description  : Site Master History 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.01.25   okaniel      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.03.26   KHSONG       modify
 * 20200306 hwi1993 [CSR:C20200303-000235 ] Ship plan Auto 추가 ( Attribute2 컬럼 사용 ) 에 따라 Attribute2 추가
 * 2020/04/22  P.C.I 		[PJ20200138] 전지 공급 대응력 향상을 위한 RTF 적확도 개선-유통경로 추가(Attribute3)
 * 2020/11/11	hwi1993		SI mkt fcst 입력시 vmi req 자동 산출. site 별로 vmi 재고일수 추가 ( attribute5)
 * 
 */
CREATE PROCEDURE [dbo].[PR_DM_MST_SITE_HIST]

	 @p_DIVISION_ID      		NVARCHAR(MAX)
	,@p_SCM_SITE_ID      		NVARCHAR(MAX)
	,@p_SITE_DESCRIPTION 		NVARCHAR(MAX)
	,@p_SITE_TYPE        		NVARCHAR(MAX)
	,@p_CITY             		NVARCHAR(MAX)
	,@p_COUNTRY          		NVARCHAR(MAX)
	,@p_PLANT_ID         		NVARCHAR(MAX)
	,@p_OPERATION_GROUP  		NVARCHAR(MAX)
	,@p_DEPT_ID          		NVARCHAR(MAX)
	,@p_VMI_YN           		NVARCHAR(MAX)
	,@p_VALID_YN         		NVARCHAR(MAX)
	,@p_NEW_YN           		NVARCHAR(MAX)
	,@p_SITE_HRCY_ID     		NVARCHAR(MAX)
	,@p_OSP_YN           		NVARCHAR(MAX)
	,@p_SHIP_FROZEN      		NVARCHAR(MAX)
	,@p_PROD_FROZEN      		NVARCHAR(MAX)
	,@p_END_CUSTOMER     		NVARCHAR(MAX)
	,@p_SOLDTO_CUSTOMER  		NVARCHAR(MAX)
	,@p_FP_PLAN_PERIOD   		NVARCHAR(MAX)
	,@p_BUILD_AHEAD      		NVARCHAR(MAX)
	,@p_LOGISTIC_PLANT_ID		NVARCHAR(MAX)
	,@p_COMPANY_ID       		NVARCHAR(MAX)
	,@p_SITE_ID          		NVARCHAR(MAX)
	,@p_CREATED_BY       		NVARCHAR(MAX)
	,@p_LAST_UPDATED_BY  		NVARCHAR(MAX)
	,@p_ATTRIBUTE1  			NVARCHAR(MAX)
	,@p_ATTRIBUTE2  			NVARCHAR(MAX)
	,@p_ATTRIBUTE3  			NVARCHAR(MAX) --[PJ20200138]
	,@p_ATTRIBUTE5  			NVARCHAR(MAX) --[PJ20200138]

AS

BEGIN

	SET XACT_ABORT ON;
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @n_history_seq	INTEGER;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_MST_SITE_HIST';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

		-- 트랜잭션 (START)
		--BEGIN TRANSACTION PR_DM_MST_SITE_HIST;

	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	
	
PRINT @v_program_name +' : A001--' + CONVERT(VARCHAR(30), GETDATE(), 121);
			-- 시작 LOG
			SET @v_log_type = 'START';
			SET @v_log_message = '########## Start of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
		
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
PRINT @v_program_name +' : A002--' + CONVERT(VARCHAR(30), GETDATE(), 121);
				   
				
			BEGIN    
PRINT @v_program_name +' : A003--' + CONVERT(VARCHAR(30), GETDATE(), 121);
				SET @n_history_seq = NEXT VALUE FOR SEQ1_SCM_MST_SITE_H
PRINT @v_program_name +' : A004--' + CONVERT(VARCHAR(30), GETDATE(), 121);
				
				   BEGIN
PRINT @v_program_name +' : A005--' + CONVERT(VARCHAR(30), GETDATE(), 121);

PRINT @v_program_name +' : A006--' + '@p_DIVISION_ID: '+ @p_DIVISION_ID + '/ @p_SCM_SITE_ID: ' + @p_SCM_SITE_ID + '/ @p_SITE_DESCRIPTION: ' + @p_SITE_DESCRIPTION
PRINT @v_program_name +' : A007--' + '@p_SITE_TYPE: '+ @p_SITE_TYPE + '/ @p_CITY: ' + @p_CITY + '/ @p_COUNTRY: ' + @p_COUNTRY + '/ @p_PLANT_ID: ' + @p_PLANT_ID
PRINT @v_program_name +' : A008--' + '@p_OPERATION_GROUP: '+ @p_OPERATION_GROUP + '/ @p_DEPT_ID: ' + @p_DEPT_ID + '/ @p_VMI_YN: ' + @p_VMI_YN + '/ @p_VALID_YN : ' + @p_VALID_YN 
PRINT @v_program_name +' : A009--' + '@p_NEW_YNP: '+ @p_NEW_YN + '/ @p_SITE_HRCY_ID: ' + @p_SITE_HRCY_ID + '/ @p_OSP_YN: ' + @p_OSP_YN + '/ @p_SHIP_FROZEN  : ' + @p_SHIP_FROZEN  
PRINT @v_program_name +' : A010--' + '@p_PROD_FROZEN: '+ @p_PROD_FROZEN + '/ @p_END_CUSTOMER: ' + @p_END_CUSTOMER + '/ @p_SOLDTO_CUSTOMER: ' + @p_SOLDTO_CUSTOMER + '/ @p_FP_PLAN_PERIOD  : ' + @p_FP_PLAN_PERIOD  
PRINT @v_program_name +' : A011--' + '@p_BUILD_AHEAD: '+ @p_BUILD_AHEAD + '/ @p_LOGISTIC_PLANT_ID: ' + @p_LOGISTIC_PLANT_ID + '/ @p_COMPANY_ID: ' + @p_COMPANY_ID + '/ @p_SITE_ID  : ' + @p_SITE_ID   
PRINT @v_program_name +' : A012--' + '@p_CREATED_BY: '+ @p_CREATED_BY + '/ @p_LAST_UPDATED_BY: ' + @p_LAST_UPDATED_BY + '/ @p_ATTRIBUTE1: ' + @p_ATTRIBUTE1 + '/ @p_ATTRIBUTE2  : ' + @p_ATTRIBUTE2  
PRINT @v_program_name +' : A013--' + '@p_ATTRIBUTE3: '+ @p_ATTRIBUTE3 + '/ @p_ATTRIBUTE5: ' + @p_ATTRIBUTE5 
					INSERT	INTO  [dbo].[SCM_MST_SITE_H]
					( HISTORY_SEQ, DIVISION_ID, SCM_SITE_ID, SITE_DESCRIPTION, SITE_TYPE, CITY, COUNTRY, PLANT_ID, OPERATION_GROUP
					, DEPT_ID, VMI_YN, VALID_YN, NEW_YN, SITE_HRCY_ID, OSP_YN, SHIP_FROZEN, PROD_FROZEN, END_CUSTOMER, SOLDTO_CUSTOMER
					, FP_PLAN_PERIOD, BUILD_AHEAD, LOGISTIC_PLANT_ID, COMPANY_ID, SITE_ID, CREATED_BY, CREATION_DATE
					, LAST_UPDATED_BY, LAST_UPDATE_DATE
					, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
					, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, HISTORY_CREATION_DATE )
					VALUES  
					( @n_history_seq, @p_DIVISION_ID, @p_SCM_SITE_ID, @p_SITE_DESCRIPTION, @p_SITE_TYPE, @p_CITY, @p_COUNTRY, @p_PLANT_ID, @p_OPERATION_GROUP  
					, @p_DEPT_ID, @p_VMI_YN, @p_VALID_YN, @p_NEW_YN, @p_SITE_HRCY_ID, @p_OSP_YN, @p_SHIP_FROZEN, @p_PROD_FROZEN, @p_END_CUSTOMER, @p_SOLDTO_CUSTOMER  
					, @p_FP_PLAN_PERIOD, @p_BUILD_AHEAD, @p_LOGISTIC_PLANT_ID, @p_COMPANY_ID, @p_SITE_ID, @p_CREATED_BY, SYSDATETIME()       
					, @p_LAST_UPDATED_BY, SYSDATETIME()
					--[PJ20200138] 유통경로 추가(Attribute3)
					, @p_ATTRIBUTE1, @p_ATTRIBUTE2, @p_ATTRIBUTE3, null, @p_ATTRIBUTE5
					, null, null, null, null, null, SYSDATETIME());

PRINT @v_program_name +' : A014--' + CONVERT(VARCHAR(30), GETDATE(), 121);
				   END
PRINT @v_program_name +' : A015--' + CONVERT(VARCHAR(30), GETDATE(), 121);
			END

		--COMMIT work ;

		END TRY

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	
PRINT @v_program_name +' : A016--' + CONVERT(VARCHAR(30), GETDATE(), 121);
	-- 트랜잭션 (END)
	--ROLLBACK TRANSACTION  PR_DM_MST_SITE_HIST;

	-- ERROR LOG
	SET @v_log_type = 'ERROR';
	SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
	SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
	SET @d_event_date = SYSDATETIME();
	--SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


	
PRINT @v_program_name +' : A017--' + CONVERT(VARCHAR(30), GETDATE(), 121);
	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	
    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	END;



