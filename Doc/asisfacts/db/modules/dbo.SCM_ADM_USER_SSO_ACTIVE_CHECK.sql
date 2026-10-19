

/*
 * Program ID   : SCM_ADM_USER_SSO_ACTIVE_CHECK
 * Description  : 퇴직자 체크
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2019/01/31	hwwoonins		Initial Release [PS02199094B] GSCM(DM/SCP) SM운영/유지보수
 *
 */

CREATE PROCEDURE [dbo].[SCM_ADM_USER_SSO_ACTIVE_CHECK]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	DECLARE @v_user_id		NVARCHAR(30);

    -- LOG 용 변수 설정
    DECLARE @v_batch_user NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name NVARCHAR(150) = 'SCM_ADM_USER_SSO_ACTIVE_CHECK';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @v_ifseqno     NVARCHAR(30); -- 최초 한번은 전체 데이터 insert

	-- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
		
		BEGIN
			
			--퇴직자 조회
			DECLARE CUR_MAIN CURSOR FOR
			SELECT A.UserID
			FROM TB_FX_User A WITH(NOLOCK)
			JOIN SCM_MST_SSO_USER_INFO B WITH(NOLOCK) ON A.UserID=B.user_id AND B.ACTIVE_FLAG='D'
			WHERE A.UseYN='Y'
			;

			OPEN CUR_MAIN;
			FETCH NEXT FROM CUR_MAIN INTO @v_user_id
			;

			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					-- TB_FX_User_H 이력 저장
					INSERT INTO TB_FX_User_H
					(
							UserID
							,UserName
							,UserName_E
							,Email
							,Dept_ID
							,OfficePhoneNum
							,CellPhoneNum
							,Language
							,DefaultGroupID
							,TimeZone
							,LastLoginDateTime
							,UseYN
							,RegtUserID
							,RegtDateTime
							,UpdateUserID
							,UpdateDateTime
							,Attribute1
							,Attribute2
							,Attribute3
							,Attribute4
							,Attribute5
							,Attribute6
							,Attribute7
							,Attribute8
							,Attribute9
							,Attribute10
					)
					SELECT UserID
							,UserName
							,UserName_E
							,Email
							,Dept_ID
							,OfficePhoneNum
							,CellPhoneNum
							,Language
							,DefaultGroupID
							,TimeZone
							,LastLoginDateTime
							,UseYN
							,'SYSTEM'
							,GETDATE()
							,'SYSTEM'
							,GETDATE()
							,Attribute1
							,Attribute2
							,Attribute3
							,Attribute4
							,Attribute5
							,Attribute6
							,Attribute7
							,Attribute8
							,Attribute9
							,Attribute10
					FROM TB_FX_User
					WHERE UserID = @v_user_id;

					--TB_FX_UserGroupInfo_H 이력 저장
					INSERT INTO TB_FX_UserGroupInfo_H
					(
						GroupID
						,UserID
						,UseYN
						,RegtUserID
						,RegtDateTime
						,UpdateUserID
						,UpdateDateTime
					)
					SELECT GroupID
						,UserID
						,UseYN
						,'SYSTEM'
						,GETDATE()
						,'SYSTEM'
						,GETDATE()
					FROM TB_FX_UserGroupInfo
					WHERE UserID = @v_user_id;

					INSERT INTO TB_FX_UserGroupAuthExtention_H
					(
						GroupID
						,UserID
						,AuthType
						,Code
						,PrntCode
						,RegtUserID
						,RegtDateTime
						,UpdateUserID
						,UpdateDateTime
					)
					SELECT GroupID
						,UserID
						,AuthType
						,Code
						,PrntCode
						,'SYSTEM'
						,GETDATE()
						,'SYSTEM'
						,GETDATE()
					FROM TB_FX_UserGroupAuthExtention
					WHERE UserID = @v_user_id;

					-- USER 및 GROUP 권한 모두 지운다.
					--EXEC [UP_FX_DeleteUserInfo] @v_user_id

					UPDATE dbo.TB_FX_User
						SET UseYN='N', 
							UpdateUserID = 'SYSTEM', 
							UpdateDateTime = GETDATE()
					WHERE UserID = @v_user_id
					;

					DELETE FROM dbo.TB_FX_UserGroupInfo
					WHERE UserID = @v_user_id
					;

					DELETE FROM dbo.TB_FX_UserMenuAuth
					WHERE UserID = @v_user_id
					;

					DELETE FROM dbo.TB_FX_UserMenuAuthExtension
					WHERE UserID = @v_user_id
					;

					DELETE FROM TB_FX_UserGroupAuthExtention
					WHERE UserID = @v_user_id
					;


					-- 요청한 권한 지운다.
					DELETE FROM SCM_MST_AUTH_REQUEST
					WHERE USER_ID = @v_user_id
					;

					-----------------------------------------------------------
					-- DELETE LOG
					-----------------------------------------------------------
					SET @v_log_type = 'DELETE';
					SET @v_log_message = 'UPDATE,DELETE sso user info';
					SET @v_description = 'USER_ID = ' + @v_user_id;
					SET @d_event_date = SYSDATETIME();
					EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
					-----------------------------------------------------------
		
					FETCH NEXT FROM CUR_MAIN INTO  @v_user_id

				END
		
		CLOSE CUR_MAIN;
		DEALLOCATE CUR_MAIN; 

        IF @@TRANCOUNT > 0
		  BEGIN
            COMMIT WORK;
		  END;

      END
    END TRY

    BEGIN CATCH
      IF @@TRANCOUNT > 0
		  BEGIN
            ROLLBACK;
		  END;
      -- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ';
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;


