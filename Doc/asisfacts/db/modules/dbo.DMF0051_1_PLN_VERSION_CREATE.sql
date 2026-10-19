/****************************************************************************************************/
/* Program ID  : [DMF0051_1_PLN_VERSION_CREATE]                                                   */
/* Description : DMF0051_1_PLN_VERSION_CREATE INSERT	                                            */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
 /* 2023.09.23	chano0612		사업계획3차 수정[VERSION_NO Naming Rule]                             */
/*                                                                                                  */
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[DMF0051_1_PLN_VERSION_CREATE]
	@p_division_id		NVARCHAR(MAX),
	@p_ver_description  NVARCHAR(MAX),
	@p_ver_type			NVARCHAR(MAX),
	@p_created_by		NVARCHAR(MAX),
	@p_ver_return_no	NVARCHAR(40) OUTPUT,		-- 생성요청 버전넘버
	@p_OK_description	NVARCHAR(1200) OUTPUT		-- 생성요청 버전넘버
AS

BEGIN

	SET XACT_ABORT ON;
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	DECLARE @n_version_no		INTEGER;
	DECLARE @n_version_seq		NVARCHAR(40);
	DECLARE @n_ver_description  NVARCHAR(MAX);
	DECLARE @n_week             NVARCHAR(10);

	SET @n_ver_description = @p_ver_description
	SELECT @n_week = WEEK_NAME FROM SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD = CONVERT(NVARCHAR, GETDATE(), 112)
	SET @n_ver_description = @n_ver_description + '_' + SUBSTRING(CONVERT(NVARCHAR, GETDATE(), 112), 1, 4) + '_' + @n_week + '_'

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DMF0051_1_PLN_VERSION_CREATE';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	
	--[C20200909-000203] LOG 표준화 적용
		-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		
	-- 트랜잭션 (START)
	BEGIN TRANSACTION DMF0051_1_PLN_VERSION_CREATE;

	BEGIN TRY

			BEGIN    

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
						CONVERT(CHAR(4), sysdatetime(), 112) 
						+ '_' + 
						@n_week
						+ '_V' + 
						REPLICATE('0', 3 - LEN(CAST(@n_version_no AS NVARCHAR(10)))) + CAST(@n_version_no AS NVARCHAR(10))
				) 
				   BEGIN

				   --PRINT @n_version_seq
				   SET @n_ver_description = @n_ver_description + 'V' + REPLICATE('0', 3 - LEN(CAST(@n_version_no AS NVARCHAR(10)))) + CAST(@n_version_no AS NVARCHAR(10))
				   --PRINT @n_ver_description

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
		

				   --SELECT @n_version_seq	Output; 


				   -- 정상채번 경우
					SET @p_ver_return_no = @n_version_seq;

					SET @p_OK_description = 'OK';

					COMMIT WORK;

					--RETURN;


			END


	END TRY

    BEGIN CATCH
	--[C20200909-000203] LOG 표준화 적용
	ROLLBACK TRANSACTION DMF0051_1_PLN_VERSION_CREATE;

      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	  
		--[C20200909-000203] LOG 표준화 적용
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		

    END CATCH

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END; 
