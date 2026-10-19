


 
CREATE PROCEDURE [dbo].[SCP0056_SET_MPP_NOTE]
	@P_DIVISION_ID			NVARCHAR(30),
	@P_SITE_ID				NVARCHAR(30),
	@P_OPERATION_ID			NVARCHAR(30),
	@P_LINE_ID  			NVARCHAR(30),
	@P_BASIC_CODE			NVARCHAR(30),
	@P_PLAN_DATE            NVARCHAR(20),
	@P_DEMAND               INT,
	@P_PRODUCT_MOD          INT,
	@P_PRODUCT_SETBACK      INT,
	@P_SEMI_PRODUCT         INT,
	@P_MATERIAL             INT,
	@P_ETC_REASON           INT,
	@P_PRODUCT_OVER         INT,
	@P_NOTE1                NVARCHAR(500),
	@P_NOTE2                NVARCHAR(500),
	@P_NOTE3                NVARCHAR(500),
	@P_PROD_TYPE            NVARCHAR(100),
	@P_PROGRAM_ID			NVARCHAR(10) = 'SCP0056',
	@P_USER_ID				NVARCHAR(30)
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = '[SCP0056_SET_MPP_NOTE]';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @n_Bom_Ratio    INTEGER = 0;

	-- 트렌젝션 시작
	BEGIN TRAN;

	BEGIN TRY
			
		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


		SET @n_Bom_Ratio = (SELECT TOP 1 A.BOM_RATIO
							FROM   (
									SELECT DISTINCT DIVISION_ID, BASIC_MODEL, ISNULL(MPP_QTY_CELL/MPP_QTY, 0) AS BOM_RATIO
									FROM   SCM_DNM_MPP_SNAPSHOT A
									WHERE  1=1
									AND    EXISTS (
													SELECT DIVISION_ID, SNAPSHOT_MAX_WEEK
													FROM   (
															SELECT DIVISION_ID, MAX(SNAPSHOT_WEEK) AS SNAPSHOT_MAX_WEEK
															FROM   SCM_DNM_MPP_SNAPSHOT 
															WHERE  1=1
															GROUP  BY DIVISION_ID
														   ) B
													WHERE  1=1
													AND    A.DIVISION_ID = B.DIVISION_ID
													AND    A.SNAPSHOT_WEEK = B.SNAPSHOT_MAX_WEEK
												  )
									AND    MPP_QTY > 0
									UNION  ALL
									SELECT DISTINCT DIVISION_ID, BASIC_MODEL, ISNULL(RESULT_QTY_CELL/RESULT_QTY, 0) AS BOM_RATIO
									FROM   SCM_DNM_MPP_SNAPSHOT A
									WHERE  1=1
									AND    EXISTS (
													SELECT DIVISION_ID, SNAPSHOT_MAX_WEEK
													FROM   (
															SELECT DIVISION_ID, MAX(SNAPSHOT_WEEK) AS SNAPSHOT_MAX_WEEK
															FROM   SCM_DNM_MPP_SNAPSHOT 
															WHERE  1=1
															GROUP  BY DIVISION_ID
														   ) B
													WHERE  1=1
													AND    A.DIVISION_ID = B.DIVISION_ID
													AND    A.SNAPSHOT_WEEK = B.SNAPSHOT_MAX_WEEK
												  )
									AND    RESULT_QTY > 0
									) A
							where a.BASIC_MODEL= @P_BASIC_CODE
							  and a.DIVISION_ID= @P_DIVISION_ID);
;
			-- 기존 정보 백업
			UPDATE SCM_DNM_MPP_REASON
			   SET VALID = 'N',
				   UPDDTTM = GETDATE(),
				   UPDUSER = @P_USER_ID
			 WHERE 1=1
			   AND DIVISION_ID = @P_DIVISION_ID
			   AND SITE_ID = @P_SITE_ID
			   AND OPERATION_ID = @P_OPERATION_ID
			   AND LINE_ID = @P_LINE_ID
			   AND BASIC_CODE = @P_BASIC_CODE
			   AND PLAN_DATE = @P_PLAN_DATE
			   AND PROD_TYPE = @P_PROD_TYPE
			   AND VALID = 'Y';

			-- 신규 정보 생성
			INSERT INTO SCM_DNM_MPP_REASON (
											   DIVISION_ID,
											   SITE_ID,
											   OPERATION_ID,
											   LINE_ID,
											   BASIC_CODE,
											   PLAN_DATE,
											   INSDTTM,
											   INSUSER,
											   VALID,
											   DEMAND,
											   PRODUCT_MOD,
											   PRODUCT_SETBACK,
											   SEMI_PRODUCT,
											   MATERIAL,
											   ETC_REASON,
											   PRODUCT_OVER,
											   DEMAND_CELL,
											   PRODUCT_MOD_CELL,
											   PRODUCT_SETBACK_CELL,
											   SEMI_PRODUCT_CELL,
											   MATERIAL_CELL,
											   ETC_REASON_CELL,
											   PRODUCT_OVER_CELL,
											   NOTE1,
											   NOTE2,
											   NOTE3,
											   PROD_TYPE
											 )
									  VALUES (
											   @P_DIVISION_ID,
											   @P_SITE_ID,
											   @P_OPERATION_ID,
											   @P_LINE_ID,
											   @P_BASIC_CODE,
											   @P_PLAN_DATE,
											   GETDATE(),
											   @P_USER_ID,
											   'Y',
											   @P_DEMAND,
											   @P_PRODUCT_MOD,
											   @P_PRODUCT_SETBACK,
											   @P_SEMI_PRODUCT,
											   @P_MATERIAL,
											   @P_ETC_REASON,
											   @P_PRODUCT_OVER,
											   @P_DEMAND*@n_Bom_Ratio,
											   @P_PRODUCT_MOD*@n_Bom_Ratio,
											   @P_PRODUCT_SETBACK*@n_Bom_Ratio,
											   @P_SEMI_PRODUCT*@n_Bom_Ratio,
											   @P_MATERIAL*@n_Bom_Ratio,
											   @P_ETC_REASON*@n_Bom_Ratio,
											   @P_PRODUCT_OVER*@n_Bom_Ratio,
											   @P_NOTE1,
											   @P_NOTE2,
											   @P_NOTE3,
											   @P_PROD_TYPE
											 );

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		COMMIT TRAN;
	END TRY

	BEGIN CATCH 
		BEGIN
			if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리
						
			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			--IF @@TRANCOUNT > 0
			--  COMMIT WORK;
		END;
	END CATCH;
END
