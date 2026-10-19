
/*
 * Program ID   : UP_FX_SaveMenuExecutionLog
 * Description  : UI 실행 시간 LOG 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/08/18   khj79          [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - 최초작성

 */
 
CREATE PROCEDURE [dbo].[UP_FX_SaveMenuExecutionLog]
	  @p_menu_id		NVARCHAR(10)
	, @p_log_type		NVARCHAR(10)
	, @p_db_time		NVARCHAR(100)
	, @p_ui_time		NVARCHAR(100)
	, @p_log_cnt		NVARCHAR(100)
	, @p_user_id		NVARCHAR(100)

AS
BEGIN
	SET NOCOUNT ON;

	-- 트렌젝션 시작
	BEGIN TRAN;

	BEGIN TRY
		
			INSERT INTO SCM_SYS_LOG_BATCH
			(  
			   PROGRAM_NAME
			 , log_type			-- FIND : 조회
			 , log_count		-- 건수
			 , log_message		-- DB 처리 시간
			 , description		-- UI 처리 시간
			 , EVENT_DATE
			 , CREATION_DATE
			 , CREATED_BY		-- USER_ID
			 , LAST_UPDATE_DATE
			 , LAST_UPDATED_BY
			 )
			VALUES (
			  @p_menu_id
			, @p_log_type
			, @p_log_cnt
			, @p_db_time
			, @p_ui_time
			, SYSDATETIME()
			, SYSDATETIME()
			, @p_user_id
			, SYSDATETIME()
			, @p_user_id
			)
		COMMIT TRAN;

	END TRY

	BEGIN CATCH 

		  if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리

	END CATCH;

END
