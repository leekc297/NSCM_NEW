/****************************************************************************************************/
/* Program ID  : [PR_DM_PLN_VERSION_CREATE_SELF]                                                   */
/* Description : PR_DM_PLN_VERSION_CREATE_SELF INSERT	                                                  */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2017/12/09  DWOK/DWPARK  Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/*                                                                                                  */
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[PR_DM_PLN_VERSION_CREATE_SELF]

	@p_division_id		NVARCHAR(MAX),
	@p_ver_description  NVARCHAR(MAX),
	@p_ver_type			NVARCHAR(MAX),
	@p_created_by		NVARCHAR(MAX),
	@p_ver_return_no	NVARCHAR(40) OUTPUT		-- 생성요청 버전넘버
	--@DateTime DateTime Output;

AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @n_version_no		INTEGER;
	DECLARE @n_version_seq		NVARCHAR(40);
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_PLN_VERSION_CREATE_SELF';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;


		BEGIN TRY

			-- 시작 LOG
			SET @v_log_type = 'START';
			SET @v_log_message = '########## Start of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();

			EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
			BEGIN    
				--	OK_20140930_V392 select CONVERT(CHAR(8), sysdatetime(), 112) SELECT REPLICATE('0', 3 - LEN(A.VERSION_NEXT)) + A.VERSION_NEXT;
				SET @n_version_no = 
				(
					SELECT 
						CASE 
						WHEN	MAX(A.VERSION_NEXT) IS NULL THEN  1
						ELSE	MAX(A.VERSION_NEXT)+1
						END  AS VERSION_NEXT 
					FROM
					(
						SELECT [DIVISION_ID]
							  ,[VERSION_TYPE]
							  ,[YYYYMMDD]
							  ,MAX([VER_CRE_SEQ]) AS VERSION_NEXT
						FROM [dbo].[DM_MST_VERSION]  WITH(NOLOCK)	
						WHERE
								DIVISION_ID = @p_division_id	AND
								VERSION_TYPE = @p_ver_type	AND
								[YYYYMMDD] = CONVERT(CHAR(8), sysdatetime(), 112)
						GROUP BY 
								[DIVISION_ID],
								[VERSION_TYPE],
								[YYYYMMDD]
					) A	
				)

				SET @n_version_seq =
				(
					SELECT 
						@p_ver_type 
						+ '_' + 
						CONVERT(CHAR(8), sysdatetime(), 112) 
						+ '_V' + 
						REPLICATE('0', 3 - LEN(CAST(@n_version_no AS NVARCHAR(10)))) + CAST(@n_version_no AS NVARCHAR(10))
				) 
				   BEGIN

						INSERT	INTO  [dbo].[DM_MST_VERSION] 
						(
									DIVISION_ID,
									VERSION_NO,
									VERSION_DESCRIPTION,
									VERSION_TYPE,
									YYYYMMDD,
									VER_CRE_SEQ,
									CREATED_BY,
									CREATION_DATE,
									LAST_UPDATED_BY,
									LAST_UPDATE_DATE
						)
						VALUES  
						(
									 @p_division_id, 
									 @n_version_seq,
									 @p_ver_description, 
									 @p_ver_type,
									 CONVERT(CHAR(8), sysdatetime(), 112),
									 @n_version_no, 
									 @p_created_by,
									 SYSDATETIME(),
									 @p_created_by,
									 SYSDATETIME()
						);
	
				   END

				   -- 정상채번 경우
					SET @p_ver_return_no = @n_version_seq;

					RETURN

			END


		END TRY

    BEGIN CATCH

      -- ROLLBACK
      -- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();

      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();

    END CATCH;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;
  
