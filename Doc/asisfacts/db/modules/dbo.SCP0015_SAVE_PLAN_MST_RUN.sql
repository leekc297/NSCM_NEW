/*
 * Program ID   : [SCP0015_SAVE_PLAN_MST_RUN]
 * Description  : PLAN RUN 실행
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/04/18   PJS   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2025/09/22	YMH	  5분안에 엔진수행기록 있을때 재수행 안되게 수정.
 * 실행예제)
 *  EXEC SCP0015_SAVE_PLAN_MST_RUN @p_modeling_id='2',@p_plan_type='MA'
 */
CREATE PROCEDURE [dbo].[SCP0015_SAVE_PLAN_MST_RUN]
 (
	 @p_modeling_id  	NVARCHAR(1000)
  	,@p_plan_type		NVARCHAR(1000)  
 )
AS
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @v_plan_name NVARCHAR(8)='';
	DECLARE @v_plan_type NVARCHAR(2)='';
	DECLARE @v_plan_seq  NVARCHAR(2)='';
    DECLARE @v_plan_id   NVARCHAR(30)='';	
	
		-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0015_SAVE_PLAN_MST_RUN';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	
	BEGIN TRY

		
		-- YMH 동일동작 실행시킨것이 있다면 실행시키지 않는다.
		DECLARE @NDIFFCHKMIN INT = 5

		-- 20250922 YMH 5분안에 동일한 엔진시작건이 있으면 수행하지 않는다.
		IF NOT EXISTS(
			SELECT * FROM SCM_SYS_LOG_BATCH T WITH(NOLOCK)
			WHERE 1 = 1 
			AND T.PROGRAM_NAME = 'SCP0015_SAVE_PLAN_MST_RUN'
			AND CONVERT(CHAR(8), T.EVENT_DATE, 112) = CONVERT(CHAR(8), GETDATE(), 112)
			AND T.LOG_TYPE = 'START'
			AND CONVERT(VARCHAR(MAX),T.DESCRIPTION) = concat(@p_modeling_id, ' : ' , @p_plan_type)
			AND DATEDIFF(MINUTE,T.EVENT_DATE,GETDATE())  < @NDIFFCHKMIN
			AND NOT EXISTS  -- 종료나 에러가 있으면 대상이 아님.
			(
				SELECT * FROM SCM_SYS_LOG_BATCH T2 WITH(NOLOCK)
				WHERE 1 = 1 
				AND T2.PROGRAM_NAME = 'SCP0015_SAVE_PLAN_MST_RUN'
				AND T2.EVENT_DATE > T.EVENT_DATE
				AND T2.LOG_TYPE <> 'START'
				AND CONVERT(VARCHAR(MAX),T2.DESCRIPTION) = concat(@p_modeling_id, ' : ' , @p_plan_type)
			)
		)
		BEGIN

			SET @v_log_type = 'START';
			SET @v_log_message = '########## Start of procedure ##########';
			SET @v_description = concat(@p_modeling_id, ' : ' , @p_plan_type); 
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			--PLAN RUN 실행
			EXEC PR_SCP_ENG_CONTROL @p_modeling_id, @p_plan_type

			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = concat(@p_modeling_id, ' : ' , @p_plan_type); 
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			-- 결과코드, 결과 카운트 반환
			SELECT  'S' AS result_code, 1 result_cnt ;		
		END
		ELSE
		BEGIN
			-- 결과코드, 결과 카운트 반환
			SELECT  'E' AS result_code, 0 result_cnt ;		
			SELECT '해당 엔진이 이미 실행 되었습니다.';
		END

	END TRY

	BEGIN CATCH 
	  BEGIN
		INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
		VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

		IF @@TRANCOUNT > 0
		  COMMIT WORK;
	  END;

	  -- error코드, errror 메시지 반환
	  SELECT 'F' AS result_code;
	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	END CATCH;
END
