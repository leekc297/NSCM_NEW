
/*
 * Program ID   : PR_SCP_PLN_IF_CHECK_SMS_SEND
 * Description  : I/F DATA Check
 * OutTable     :
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2020.10.08   KSG             Initial Release 전지GSCM(SCP) SM 운영
 */
 
CREATE PROCEDURE [dbo].[PR_SCP_PLN_IF_CHECK_SMS_SEND]
(
      @p_division_id          NVARCHAR(10)
    , @p_plan_type            NVARCHAR(10)
    , @p_if_type              NVARCHAR(40)
)
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_PLN_IF_CHECK_SMS_SEND';
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
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;   
    
    BEGIN TRY
      BEGIN
    
        declare @rs nvarchar(10);
		declare @message nvarchar(100);

		--========================= FP Prod Target ===========================
		IF @p_if_type = 'FP_PROD' AND @p_plan_type = 'MA'
		BEGIN

			set @rs = '';
			set @message = '';
		
			WITH RS AS (
				SELECT PLAN_WEEK, COUNT(PLAN_WEEK) CNT
					 , ROW_NUMBER() OVER (PARTITION BY DIVISION ORDER BY PLAN_WEEK DESC ) ROW_NUM 
				FROM   XIF_SCP_PROD_TARGET_R_SN WITH(NOLOCK)
				WHERE  DIVISION     = @p_division_id
				AND    PLAN_TYPE    = @p_plan_type
				AND    IF_RCV_DATE >= GETDATE()-7*4
				GROUP BY DIVISION, PLAN_WEEK
			)
			SELECT @rs = (CASE WHEN RS1.PLAN_WEEK IS NULL                               THEN 'false'
							   WHEN RS1.PLAN_WEEK IS NOT NULL AND RS2.PLAN_WEEK IS NULL THEN 'true' 
							   WHEN RS2.CNT*0.8 > RS1.CNT                               THEN 'false'
							   ELSE 'true'
						  END) 
			FROM (SELECT 'TEST' AS T) A
			LEFT JOIN RS RS1 ON RS1.ROW_NUM=1
			LEFT JOIN RS RS2 ON RS2.ROW_NUM=2
			;

			IF(@rs='false')
				BEGIN
					SET @message = N'FP Prod Target I/F Check'
					EXEC SCM_ADM_SMS_SEND_BATCH 60, @message
				END
			;

		END; -- IF @p_if_type = 'FP_PROD' 

		--========================= FP Ship Target ===========================
		IF @p_if_type = 'FP_SHIP' AND @p_plan_type = 'MA'
		BEGIN

			set @rs = '';
			set @message = '';
		
			WITH RS AS (
				SELECT PLAN_WEEK, COUNT(PLAN_WEEK) CNT
					 , ROW_NUMBER() OVER (PARTITION BY DIVISION ORDER BY PLAN_WEEK DESC ) ROW_NUM 
				FROM   XIF_SCP_SALES_EXFACTORY_R_SN WITH(NOLOCK)
				WHERE  DIVISION     = @p_division_id
				AND    PLAN_TYPE    = @p_plan_type
				AND    IF_RCV_DATE >= GETDATE()-7*4
				GROUP BY DIVISION, PLAN_WEEK
			)
			SELECT @rs = (CASE WHEN RS1.PLAN_WEEK IS NULL                               THEN 'false'
							   WHEN RS1.PLAN_WEEK IS NOT NULL AND RS2.PLAN_WEEK IS NULL THEN 'true' 
							   WHEN RS2.CNT*0.8 > RS1.CNT                               THEN 'false'
							   ELSE 'true'
						  END) 
			FROM (SELECT 'TEST' AS T) A
			LEFT JOIN RS RS1 ON RS1.ROW_NUM=1
			LEFT JOIN RS RS2 ON RS2.ROW_NUM=2
			;

			IF(@rs='false')
				BEGIN
					SET @message = N'FP Ship Target I/F Check'
					EXEC SCM_ADM_SMS_SEND_BATCH 60, @message
				END
			;

		END; -- IF @p_if_type = 'FP_PROD' 

		--========================= MRP Prod Target ===========================
		IF @p_if_type = 'MRP_PROD' AND @p_plan_type = 'FN'
		BEGIN

			set @rs = '';
			set @message = '';
		
			WITH RS AS (
				SELECT PLAN_VRSN_ID, COUNT(PLAN_VRSN_ID) CNT
					 , ROW_NUMBER() OVER (PARTITION BY DIV_CD ORDER BY PLAN_VRSN_ID DESC ) ROW_NUM 
				FROM   XIF_SCP_PROD_TARGET_MRP_S_SN WITH(NOLOCK)
				WHERE  DIV_CD       = @p_division_id
				AND    PLAN_TYP     = @p_plan_type
				AND    IF_INS_DATE >= GETDATE()-7*4
				GROUP BY DIV_CD, PLAN_VRSN_ID
			)
			SELECT @rs = (CASE WHEN RS1.PLAN_VRSN_ID IS NULL                                  THEN 'false'
							   WHEN RS1.PLAN_VRSN_ID IS NOT NULL AND RS2.PLAN_VRSN_ID IS NULL THEN 'true' 
							   WHEN RS2.CNT*0.8 > RS1.CNT                                     THEN 'false'
							   ELSE 'true'
						  END) 
			FROM (SELECT 'TEST' AS T) A
			LEFT JOIN RS RS1 ON RS1.ROW_NUM=1
			LEFT JOIN RS RS2 ON RS2.ROW_NUM=2
			;

			IF(@rs='false')
				BEGIN
					SET @message = N'MRP Prod Target I/F Check'
					EXEC SCM_ADM_SMS_SEND_BATCH 60, @message
				END
			;

		END; -- IF @p_if_type = 'MRP_PROD' 

        -----------------------------------------------------------------------------------------

      END;

    END TRY

    BEGIN CATCH        
      
      -- ERROR LOG
	  INSERT INTO scm_sys_log_batch (program_name
										,log_type
										,log_count
										,log_message
										,description
										,event_date
										,creation_date
										,created_by
										,last_update_date
										,last_updated_by)
		VALUES (ERROR_PROCEDURE()
				,'ERROR'
				,NULL
				,ERROR_MESSAGE()
				,NULL
				,SYSDATETIME()
				,SYSDATETIME()
				,ERROR_PROCEDURE()
				,SYSDATETIME()
				,ERROR_PROCEDURE());

      return 1  -- 이 Proc 가 오류 발생해도 Call 한 원 Proc는 정상 수행되어야 함
    END CATCH;

    -- 종료 LOG
	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description  = N'';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    return 1 

  END;
