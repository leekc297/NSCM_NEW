
/*
 * Program ID   : SCM_ADM_USER_LONGTERM_UNCONNECTED_CHECK
 * Description  : 장기 미접속 체크
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/04/09   ygkim          Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/07/03   ygkim          장기 미접속자 Guest 유저 제외
 * 2018/07/09   ygkim            체크 테이블 변경 TB_FX_UserConnectLog -> TB_FX_User
 *                                 TB_FX_User_H, TB_FX_UserGroupInfo_H, TB_FX_UserGroupAuthExtention_H 이력 저장 추가
 * 2019.02.26   YYDOK          TB_FX_UserLockList INSERT ERROR방지(PK위반) 
                               -> 3개월 이상 미접속자 TB_FX_UserLockList에 VALID_YN을 'Y'로 UPDATE/INSERT
 * 2019.03.13	hwyoon		   [CSR ID:3944643] Tact Time Big데이터 정제시 필터링 추가 외 3건 개선사항
 * 2020.02.04   khj79          장기 미접속자  PermanentYN = 'Y' 인 사용자 제외 및 사용자 이력(TB_FX_User_H)에 PermanentYN 추가
 * 2023.02.24   FP Pjt.        [E20230216-000381]로직정리
 * 2024.07.25   FP Prj.        [E20240722-000131]장기미접속 권환회수 기간 연장 요청의 건 : 3개월 -> 1년
 */

CREATE PROCEDURE [dbo].[SCM_ADM_USER_LONGTERM_UNCONNECTED_CHECK]
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;
  
	DECLARE @v_user_id			NVARCHAR(30);
	DECLARE @v_user_chk			INT;
	DECLARE @v_chk				INT;

	-- LOG 용 변수 설정
	DECLARE @v_program_name		NVARCHAR(150) = 'SCM_ADM_USER_LONGTERM_UNCONNECTED_CHECK';
	DECLARE @v_log_type			NVARCHAR(30); -- START/END/ERROR/...
	DECLARE @n_log_count		INTEGER = 0;
	DECLARE @v_log_message		NVARCHAR(1000);
	DECLARE @v_description		NVARCHAR(500);
	DECLARE @d_event_date		DATETIME;

	BEGIN TRY
		  -- 시작 LOG
		SET @v_log_type			= 'START';
		SET @v_log_message		= '########## Start of procedure ##########';
		SET @v_description		= '';
		SET @d_event_date		= SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    
		DECLARE CUR_MAIN CURSOR FOR
		 SELECT U.UserID
		   FROM TB_FX_User U WITH(NOLOCK)
		  WHERE U.UseYN = 'Y'
			AND U.UserID != 'Guest'
			AND U.PermanentYN != 'Y'
			--AND U.LastLoginDateTime < DATEADD(MONTH, -3, GETDATE()) 
			AND U.LastLoginDateTime < DATEADD(MONTH, -12, GETDATE()) -- [E20240722-000131]장기미접속 권환회수 기간 연장 요청의 건
		  order by U.UserID
		  ;

		OPEN CUR_MAIN;
		FETCH NEXT FROM CUR_MAIN
			INTO @v_user_id

			WHILE (@@FETCH_STATUS = 0)  
			BEGIN 
			
				-- TB_FX_User_H 이력 저장
				INSERT INTO TB_FX_User_H
				     (
					   UserID
					 , UserName
					 , UserName_E
					 , Email
					 , Dept_ID
					 , OfficePhoneNum
					 , CellPhoneNum
					 , Language
					 , DefaultGroupID
					 , TimeZone
					 , LastLoginDateTime
					 , PermanentYN
					 , UseYN
					 , RegtUserID
					 , RegtDateTime
					 , UpdateUserID
					 , UpdateDateTime
					 , Attribute1
					 , Attribute2
					 , Attribute3
					 , Attribute4
					 , Attribute5
					 , Attribute6
					 , Attribute7
					 , Attribute8
					 , Attribute9
					 , Attribute10
				     )
				SELECT UserID
					 , UserName
					 , UserName_E
					 , Email
					 , Dept_ID
					 , OfficePhoneNum
					 , CellPhoneNum
					 , Language
					 , DefaultGroupID
					 , TimeZone
					 , LastLoginDateTime
					 , PermanentYN
					 , UseYN
					 , 'SYSTEM'
					 , GETDATE()
					 , 'SYSTEM'
					 , GETDATE()
					 , Attribute1
					 , Attribute2
					 , Attribute3
					 , Attribute4
					 , Attribute5
					 , Attribute6
					 , Attribute7
					 , Attribute8
					 , Attribute9
					 , Attribute10
				  FROM TB_FX_User
				 WHERE UserID = @v_user_id;

				--TB_FX_UserGroupInfo_H 이력 저장
				INSERT INTO TB_FX_UserGroupInfo_H
				     (
					   GroupID
					 , UserID
					 , UseYN
					 , RegtUserID
					 , RegtDateTime
					 , UpdateUserID
					 , UpdateDateTime
				     )
				SELECT GroupID
					 , UserID
					 , UseYN
					 , 'SYSTEM'
					 , GETDATE()
					 , 'SYSTEM'
					 , GETDATE()
				  FROM TB_FX_UserGroupInfo
				 WHERE UserID = @v_user_id;

				INSERT INTO TB_FX_UserGroupAuthExtention_H
				     (
					   GroupID
					 , UserID
					 , AuthType
					 , Code
					 , PrntCode
					 , RegtUserID
					 , RegtDateTime
					 , UpdateUserID
					 , UpdateDateTime
				     )
				SELECT GroupID
					 , UserID
					 , AuthType
					 , Code
					 , PrntCode
					 , 'SYSTEM'
					 , GETDATE()
					 , 'SYSTEM'
					 , GETDATE()
				  FROM TB_FX_UserGroupAuthExtention
			     WHERE UserID = @v_user_id;

					-- USER 및 GROUP 권한 모두 지운다.
				EXEC [UP_FX_DeleteUserInfo] @v_user_id

				-- 요청한 권한 지운다.
				DELETE FROM SCM_MST_AUTH_REQUEST
				WHERE USER_ID = @v_user_id ;

				-- 장기 미접속 테이블에 정보 저장
				-- 최초 VALID_YN = 'Y' 다시 권한 요청을 하면 VALID_YN 'N' 으로 변경해준다.
				MERGE INTO TB_FX_UserLockList AS x
					USING ( SELECT @v_user_id as userid) AS y
					ON x.userid = y.userid
				WHEN MATCHED THEN 
					UPDATE 
					   SET x.VALID_YN = 'Y'
					     , x.LAST_UPDATED_BY = 'SYSTEM'
					     , x.LAST_UPDATE_DATE = GETDATE()
				WHEN NOT MATCHED THEN
					INSERT (							
					       UserID
						 , VALID_YN
						 , CREATED_BY
						 , CREATION_DATE
						 , LAST_UPDATED_BY
						 , LAST_UPDATE_DATE
						 )
					VALUES (
					       @v_user_id
						 , 'Y'      
						 , 'SYSTEM' 
						 , GETDATE()
						 , 'SYSTEM' 
						 , GETDATE()
						 )
						 ;

				-- FP 권한삭제
				UPDATE [dbo].[TH_UIS_USER_INSTANCE_RELATE_SN]
				   SET USE_AT_FLAG			= 'N'
					 , UPDATE_ID			= 'scm_batch'
					 , UPDATE_DTTM			= getdate()
				 WHERE USER_ID				= @v_user_id
				   AND USE_AT_FLAG			= 'Y'

				-- 기존 FP 권한요청을 REJECT 처리
				UPDATE dbo.FP_AUTH_REQUEST_INFO_M_SN
				   SET APPROVAL_FLAG		= 'N'
					 , DESCRIPTION			= 'USER_LONGTERM_UNCONNECTED'
					 , APPROVAL_ID			= 'scm_batch'
					 , APPROVAL_TIME		= getdate()
				 WHERE USER_ID				= @v_user_id
				   AND APPROVAL_FLAG		= 'Y'

					
				FETCH NEXT FROM CUR_MAIN
				INTO @v_user_id
			END

		CLOSE CUR_MAIN;
		DEALLOCATE CUR_MAIN;
        
		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

 	END TRY


	BEGIN CATCH
		CLOSE CUR_MAIN;
		DEALLOCATE CUR_MAIN;

		BEGIN

			SET @v_description = @v_program_name + N'ERROR_LINE : ' + STR(ERROR_LINE());

			INSERT INTO scm_sys_log_batch 
			          ( program_name
					  , log_type
					  , log_count
					  , log_message
					  , description
					  , event_date
					  , creation_date
					  , created_by
					  , last_update_date
					  , last_updated_by)
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
			          , ERROR_PROCEDURE()
					  );

			IF @@TRANCOUNT > 0
				COMMIT WORK;
		END;

		-- error코드, errror 메시지 반환
		SELECT 'F' AS result_code;
		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();

	END CATCH;
END
