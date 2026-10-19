
/*
 * Program ID   : UP_FX_SaveReqAuthRequestMyList
 * Description  : 신규 사용자 권한 요청 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.02.27   KYH			   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.04.09   ygkim          장기 미 접속자 정보 'N'으로 업데이트 로직 추가
 *                             UPDATE SCM_MST_AUTH_REQUEST  LAST_UPDATE_DATE, REJECT_REASON, LAST_UPDATED_BY NULL 로 초기화(반려 재 권한 요청하기 위해서)
 * 2020.03.12   KHJ79		   C20200312-000090 Auth Approval 화면 처리 오류
                               장기 미사용자 관리를 위한 [UP_FX_SaveUserInfo].PermanentYN 추가('Y' 면 미접속 상용자 등록 제외)
 * 2021.03.11   KIMYONGHO	   [C20210310-000519] 권한요청 알림 메일 발송
 * 2022.05.17   lwy	           PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - commit 수정. 
 * 2023.03.02   FP Pjt.        E20230216-000381 REQUESTING 에서 CREATION_DATE (Request Date) 업데이트 항목 추가
 */
 	
CREATE PROCEDURE [dbo].[UP_FX_SaveReqAuthRequestMyList]
(
	@p_active_flag		NVARCHAR(MAX)	,
	@p_User_ID			NVARCHAR(MAX)	,
	@p_User_Name		NVARCHAR(MAX)	,
	
	-- loop 처리할 대상들
	@p_Group_ID			NVARCHAR(MAX)	,
	@p_Division_ID		NVARCHAR(MAX)	,
	@p_Plant_ID			NVARCHAR(MAX)	,
	@p_Customer_Code		NVARCHAR(MAX)	,
	-- loop 처리 대상 여기까지

	@p_User_NameE		nvarchar(100)	,
	@p_Default_Group_ID	nvarchar(100)	,
	@p_Dept_ID			NVARCHAR(50)	,
	@p_Email			NVARCHAR(150)	,
	@p_CellPhone		NVARCHAR(30)	,
	@p_Language			NVARCHAR(100)	,
	@p_TimeZone			NVARCHAR(100)
)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_Group_ID				NVARCHAR(MAX) = null ;
	DECLARE @v_Division_ID			NVARCHAR(MAX) = null ;
	DECLARE @v_Plant_ID				NVARCHAR(MAX) = null ;
	DECLARE @v_user_chk				INT = 0 ;
	--DECLARE @v_Customer_Code		NVARCHAR(MAX) = null ;

	DECLARE @v_delimiter	NVARCHAR(1) = '^' 
	DECLARE @max_loop_cnt	INTEGER = 0; 
	DECLARE @mst_loop_cnt	INTEGER = 0;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'UP_FX_SaveReqAuthRequestMyList';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	begin tran
	BEGIN TRY
		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);    

		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN
			SET @mst_loop_cnt = @mst_loop_cnt + 1;
			SELECT @mst_loop_cnt,'@mst_loop_cnt'

			BEGIN
				BEGIN
					-- loop 처리할 대상들만 string 처리
					SET @v_Group_ID = [dbo].[SCM_ARR_SPL_VAL](@p_Group_ID , @v_delimiter , @mst_loop_cnt) ;
					SET @v_Division_ID = [dbo].[SCM_ARR_SPL_VAL](@p_Division_ID , @v_delimiter , @mst_loop_cnt) ;
					SET @v_Plant_ID = [dbo].[SCM_ARR_SPL_VAL](@p_Plant_ID , @v_delimiter , @mst_loop_cnt) ;
					--SET @v_Customer_Code = [dbo].[SCM_ARR_SPL_VAL](@p_Customer_Code , @v_delimiter , @mst_loop_cnt) ;
				END

				IF @mst_loop_cnt > 0 
				BEGIN
					-- 처음에 SCM_MST_AUTH_REQUEST 정보 갱신
					UPDATE SCM_MST_AUTH_REQUEST
					SET
						APPROVAL_RESULT = 'REQUESTING'
					   ,APPROVAL_USER = ''
					   ,LAST_UPDATE_DATE = null
					   ,REJECT_REASON = null
					   ,LAST_UPDATED_BY = null
					   ,CREATION_DATE = getdate()    
					WHERE 1=1
						AND USER_ID = @p_User_ID
						AND GROUP_ID = @v_Group_ID
						AND DIVISION_ID = @v_Division_ID
						AND PLANT_ID = @v_Plant_ID
						--AND CUSTOMER_CODE = @v_Customer_Code
					;
				END
			END
		END

		IF @mst_loop_cnt > 0
		begin
			exec dbo.UP_FX_SaveUserInfo
				@p_user_id , @p_User_Name, @p_User_NameE, @p_Email ,
				@p_Dept_ID, null, @p_CellPhone, @p_Language ,
				@p_Default_Group_ID, @p_TimeZone, 'N','Y', 'REQ' , null,
				null, null, null, null ,
				null, null, null, null,
				null
		end

		--장기 미접속자 VALID_YN 'Y' -> 'N'으로 변경해줌
		SET @v_user_chk = 0;
		SELECT @v_user_chk = COUNT(*)
		FROM TB_FX_UserLockList WITH(NOLOCK)
		WHERE UserID = @p_User_ID;

		IF @v_user_chk > 0
			BEGIN
				UPDATE TB_FX_UserLockList
					SET VALID_YN = 'N'
						,LAST_UPDATED_BY = @p_User_ID
						,LAST_UPDATE_DATE = GETDATE()
				WHERE UserID = @p_User_ID;
			END	

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			
		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  @max_loop_cnt AS result_cnt ;

		commit tran

		--[C20210310-000519] 권한요청 알림 메일 발송 
		EXEC DBO.SCM_AUTH_REQ_MAIL_SEND @p_user_id;

	--commit tran : 2022/05/17 

	END TRY

	BEGIN CATCH
	IF XACT_STATE() <> 0
	BEGIN
	ROLLBACK TRAN;

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
	END
	END CATCH
	
END
