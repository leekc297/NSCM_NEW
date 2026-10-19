
/****************************************************************************************************/
/* Program ID  : [DMF0051_1_GET_DM_VERSION]                                                           */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2023/12/04  chano0612	Business Plan Confirm > Cut Off 팝업 조회 
 * 2024.03.18	kjj				화면에서 BP 컷오프 수행
*/
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[DMF0051_1_GET_DM_VERSION]    
	@p_division_id		NVARCHAR(MAX),
	@p_ver_description  NVARCHAR(MAX),
	@p_ver_type			NVARCHAR(MAX),
	@p_created_by		NVARCHAR(MAX)
	,@P_BPYEAR			NVARCHAR(4)--2024.03.18	kjj  
	 ,@P_FCST_VER		NVARCHAR(50)  
	 ,@P_RTF_VER		NVARCHAR(50) 
	,@p_ver_return_no	NVARCHAR(40) OUTPUT,		
	@p_OK_description	NVARCHAR(1200) OUTPUT		
 
AS  

BEGIN

	SET XACT_ABORT ON;
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	DECLARE @n_version_no		INTEGER;
	DECLARE @n_version_seq		NVARCHAR(40);
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DMF0051_1_GET_DM_VERSION';
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
	BEGIN TRANSACTION DMF0051_1_GET_DM_VERSION;

	BEGIN TRY

			IF @p_ver_type = 'BP_DM'
			BEGIN
				DECLARE @n_YYYY NVARCHAR(5)
				DECLARE @n_WEEK NVARCHAR(5)
				DECLARE @n_ver_description NVARCHAR(MAX)
				--SET @n_YYYY = SUBSTRING(CONVERT(NVARCHAR(4), DATEADD(YY,+1, GETDATE()), 112), 3,2)--'24' --SUBSTRING(CONVERT(NVARCHAR, GETDATE(), 112), 1, 4)


				SET @n_YYYY = SUBSTRING(@P_BPYEAR, 3,2)--'24' --SUBSTRING(CONVERT(NVARCHAR, GETDATE(), 112), 1, 4)--사업계획년도


				SELECT @n_WEEK = WEEK_NAME FROM SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD = CONVERT(NVARCHAR, GETDATE(), 112)--컷오프주차

				--UPDATE DM_MST_VERSION SET VERSION_NO = REPLACE(@v_ver_return_no, CONVERT(NVARCHAR, GETDATE(), 112), @n_YYYY + '_' + @n_WEEK) WHERE VERSION_NO = @v_ver_return_no

				SET @n_ver_description = @p_ver_description

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
							  ,YYYYMMDD
 							  ,MAX([VER_CRE_SEQ]) AS VERSION_NEXT
						FROM [dbo].[DM_MST_VERSION]  WITH(NOLOCK)	
						WHERE
								DIVISION_ID = @p_division_id
								AND VERSION_TYPE = 'BP_M'	
								--날짜가 아닌 주차의 중복으로 체크해야 함
								--[YYYYMMDD] = CONVERT(CHAR(8), sysdatetime(), 112) AND
								--SUBSTRING(VERSION_NO, 14, 3) = (select WEEK_NAME FROM SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD = CONVERT(NVARCHAR, GETDATE(), 112)) AND
								AND SUBSTRING(VERSION_NO, 14, 3) = @n_WEEK
								AND SUBSTRING(VERSION_NO, 3, 5) = 'BP_DM'
						GROUP BY 
								[DIVISION_ID],
								[VERSION_TYPE],
								[YYYYMMDD]
					) A	
				)
PRINT @n_version_no
				SET @n_version_seq =
				(
					SELECT 
						@n_YYYY
						+
						@p_ver_type 
						+ '_' + 
						CONVERT(CHAR(4), sysdatetime(), 112) 
						+ '_' + 
						@n_WEEK
						+ '_V' + 
						REPLICATE('0', 2 - LEN(CAST(@n_version_no AS NVARCHAR(10)))) + CAST(@n_version_no AS NVARCHAR(10))
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
									LAST_UPDATE_DATE,
									ATTRIBUTE9,
									ATTRIBUTE10
						)
						VALUES  
						(
									 @p_division_id, 
									 @n_version_seq,
									 --@p_ver_description + '_V' + REPLICATE('0', 2 - LEN(CAST(@n_version_no AS NVARCHAR(10)))) + CAST(@n_version_no AS NVARCHAR(10)), 
									 @p_ver_description,--뒤에 쓸데없는것 붙이지 말고 넘긴값만 저장
									 'BP_M',--@p_ver_type,
									 CONVERT(CHAR(8), sysdatetime(), 112),
									 @n_version_no, 
									 @p_created_by,
									 SYSDATETIME(),
									 @p_created_by,
									 SYSDATETIME(),
									 @P_FCST_VER,
									 @P_RTF_VER
						);
						
				   END
		
PRINT @n_version_seq
				   --SELECT @n_version_seq	Output; 


				   -- 정상채번 경우
					SET @p_ver_return_no = @n_version_seq;

					SET @p_OK_description = 'OK';

					COMMIT WORK;

					--RETURN;			

			END
			ELSE
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
	ROLLBACK TRANSACTION DMF0051_1_GET_DM_VERSION;

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



