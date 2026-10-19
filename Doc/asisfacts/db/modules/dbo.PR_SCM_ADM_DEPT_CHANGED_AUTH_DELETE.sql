
/*
 * Program ID   : PR_SCM_ADM_DEPT_CHANGED_AUTH_DELETE
 * Description  : 부서변경으로 인한 권한삭제
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023.02.20   FP Pjt.        권한 보유자의 소속변경(부서이동)시 15일 후 권한삭제
 *
 */


CREATE   PROCEDURE [dbo].[PR_SCM_ADM_DEPT_CHANGED_AUTH_DELETE]
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON;

	-- 변수 설정
	DECLARE @v_user_id          NVARCHAR(30);   -- 사용자ID
	DECLARE @v_user_name        NVARCHAR(150);  -- 사용자명
	DECLARE @v_remain_day       NVARCHAR(30);   -- 권한회수까지 남은 일수
	DECLARE @v_dbname           NVARCHAR(50);

	-- LOG 용 변수 설정
    DECLARE @v_program_name		NVARCHAR(150) = 'PR_SCM_ADM_DEPT_CHANGED_AUTH_DELETE';
    DECLARE @v_log_type			NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count		INTEGER = 0;
    DECLARE @v_log_message		NVARCHAR(1000);
    DECLARE @v_description		NVARCHAR(500);
    DECLARE @d_event_date		DATETIME;

	DECLARE @inx				INT	= 0;
    DECLARE @max_num			INT	= 0;
	DECLARE @TAB_CHANGED		TABLE
	(
	    rownum					int,
		[group_id]				[nvarchar](20) null,
		[division_id]			[nvarchar](30) null
	);

	DECLARE @t_group_id			NVARCHAR(20);
	DECLARE @t_division_id		NVARCHAR(30);

	BEGIN TRY
		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


		DECLARE CUR_CHANGED CURSOR FOR
			SELECT DISTINCT V.USER_ID
				 , V.USER_NAME
				 , V.REMAIN_DAYS 
			  FROM dbo.SCM_ADM_DEPT_CHANGED_V AS V
			 WHERE 1 = 1
			   AND V.ELAPSED_DAYS > 15

		OPEN CUR_CHANGED;
			FETCH NEXT FROM CUR_CHANGED
			INTO @v_user_id, @v_user_name, @v_remain_day

			WHILE (@@FETCH_STATUS = 0)  
			BEGIN
			    
				DELETE FROM @TAB_CHANGED;

				INSERT INTO @TAB_CHANGED (ROWNUM, GROUP_ID, DIVISION_ID)
			    SELECT ROW_NUMBER() OVER (ORDER BY V.GROUP_ID, V.DIVISION_ID ) AS ROWNUM
				     , V.GROUP_ID
				     , V.DIVISION_ID 
			      FROM dbo.SCM_ADM_DEPT_CHANGED_V AS V
			     WHERE 1 = 1
				   AND V.USER_ID = @v_user_id
				 ORDER BY 
				       GROUP_ID
				     , DIVISION_ID


                update [dbo].[TB_FX_User] set DefaultGroupID = 'Guest' where userid = @v_user_id


				SELECT @inx			= 1
					  ,@max_num		= count(*)
				  FROM @TAB_CHANGED

				WHILE @inx <= @max_num
				BEGIN 

					SELECT @t_group_id			= GROUP_ID
						 , @t_division_id		= DIVISION_ID
					  FROM @TAB_CHANGED 
					 WHERE ROWNUM				= @inx

					-- SCM 권한삭제
					DELETE 
					  FROM [dbo].[TB_FX_USERGROUPAUTHEXTENTION]
					 WHERE USERID				= @v_user_id
					   AND GROUPID				= @t_group_id
					   AND Code                 = @t_division_id

					UPDATE UG
					   SET UG.USEYN				= 'N'
					     , UG.UPDATEUSERID		= 'scm_batch'
					     , UG.UPDATEDATETIME	= getdate()
					  FROM dbo.TB_FX_USERGROUPINFO AS UG with(nolock)
					 WHERE UG.USERID			= @v_user_id
					   AND UG.GROUPID			= @t_group_id
					   AND UG.USEYN             = 'Y'
					   AND NOT EXISTS (SELECT GROUPID 
					                     FROM [dbo].[TB_FX_USERGROUPAUTHEXTENTION] with(nolock)
					                    WHERE USERID				= UG.USERID
										  AND GROUPID				= UG.GROUPID
									  )
					
					-- 기존 SCM 권한요청을 REJECT 처리
				   UPDATE SCM_MST_AUTH_REQUEST 
					  SET APPROVAL_RESULT		= 'REJECT'
					    , REJECT_REASON         = 'DEPT_CHANGED_AUTH_DELETE'
					    , LAST_UPDATED_BY		= 'scm_batch'
						, LAST_UPDATE_DATE		= getdate()
					WHERE USER_ID				= @v_user_id
					  AND GROUP_ID				= @t_group_id
					  AND DIVISION_ID           = @t_division_id

					IF @t_group_id = 'FP Planner'
					BEGIN

						-- FP 권한삭제
						UPDATE UIR
						   SET USE_AT_FLAG		= 'N'
						     , UPDATE_ID		= 'scm_batch'
						     , UPDATE_DTTM		= getdate()
						  FROM [dbo].[TH_UIS_USER_INSTANCE_RELATE_SN] AS UIR WITH(NOLOCK)
						       JOIN [dbo].[TH_UIS_ROLE_INSTANCE_SN] AS RI WITH(NOLOCK)
						    ON UIR.ROLE_ID		= RI.ROLE_ID
						 WHERE USER_ID			= @v_user_id
                           AND RI.ROLE_ID IN (SELECT RIR.ROLE_ID 
						                        FROM [dbo].[TH_UIS_ROLE_INSTANCE_RELATE_SN] AS RIR WITH(NOLOCK)
                                               WHERE RIR.ROLE_ID		= RI.ROLE_ID
				                                 AND RIR.DIVISION_ID	= @t_division_id
											 )
                           AND UIR.SAVE_FLAG		= CASE WHEN @t_group_id = 'FP Planner' THEN 'Y' ELSE 'N' END
						   AND UIR.USE_AT_FLAG		= 'Y'

	   					-- 기존 FP 권한요청을 REJECT 처리
						UPDATE dbo.FP_AUTH_REQUEST_INFO_M_SN
						   SET APPROVAL_FLAG	= 'N'
						     , DESCRIPTION      = 'DEPT_CHANGED_AUTH_DELETE'
						     , APPROVAL_ID		= 'scm_batch'
						     , APPROVAL_TIME	= getdate()
						 WHERE USER_ID			= @v_user_id
						   AND DIVISION_ID		= @t_division_id
						   AND MENU_AUTHORITY_ID = CASE WHEN @t_group_id = 'FP Planner' THEN 'PLANNER' ELSE 'VIEWER' END
						   AND APPROVAL_FLAG	= 'Y'

				    END

					SET @inx = @inx + 1

				END

				-- next fatch
				FETCH NEXT FROM CUR_CHANGED
				INTO @v_user_id, @v_user_name, @v_remain_day
			END

		-- CURSOR 종료	
		CLOSE CUR_CHANGED;
		DEALLOCATE CUR_CHANGED;
		
		-- 종료 LOG
		SET @v_log_type		= 'END';
		SET @v_log_message	= '########## END of procedure ##########';
		SET @v_description	= '';
		SET @d_event_date	= SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  

	END TRY

	-- CATCH 실행
	BEGIN CATCH
		CLOSE CUR_CHANGED;
		DEALLOCATE CUR_CHANGED;

		BEGIN

			SET @v_description = @v_program_name + N'ERROR_LINE : ' + STR(ERROR_LINE());

			INSERT INTO SCM_SYS_LOG_BATCH 
			     ( PROGRAM_NAME
				 , LOG_TYPE
				 , LOG_COUNT
				 , LOG_MESSAGE
				 , DESCRIPTION
				 , EVENT_DATE
				 , CREATION_DATE
				 , CREATED_BY
				 , LAST_UPDATE_DATE
	             , LAST_UPDATED_BY)
			VALUES 
			     ( ERROR_PROCEDURE()
				 , 'ERROR'
				 , NULL
				 , ERROR_MESSAGE()
				 , @v_description
				 , SYSDATETIME()
				 , SYSDATETIME()
				 , ERROR_PROCEDURE()
				 , SYSDATETIME()
				 , ERROR_PROCEDURE());

		IF @@TRANCOUNT > 0
			COMMIT WORK;
		END;

		-- error코드, errror 메시지 반환
		SELECT 'F' AS result_code;
		SELECT '[' + CONVERT(nvarchar(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	END CATCH;
 
END
