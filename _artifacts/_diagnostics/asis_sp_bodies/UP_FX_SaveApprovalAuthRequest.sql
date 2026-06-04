
/*
 * Program ID   : UP_FX_SaveApprovalAuthRequest
 * Description  : 신규 사용자 권한 요청 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.02.27   KYH			   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.04.09   ygkim	       기존 권한이 있는 인원이 추가로 권한 요청을 할 경우 추가 요청한 권한이 Default 권한으로
 *							   자동 변경되지 않게 처리, Plant 저장 하는 부분 수정
 * 2018.10.02   ygkim		   Division 넣는 조건 변경
 * 2020.03.12   KHJ79		   C20200312-000090 Auth Approval 화면 처리 오류
                               장기 미사용자 관리를 위한 [UP_FX_SaveUserInfo].PermanentYN 추가('Y' 면 미접속 상용자 등록 제외)
 * 2023.03.02   FP Pjt.        E20230216-000381 REJECT시 기존 권한 회수
 */
 	
CREATE PROCEDURE [dbo].[UP_FX_SaveApprovalAuthRequest]
(
	@p_active_flag		NVARCHAR(MAX)	,	-- M
	@p_Appr_Result		nvarchar(max)	,	-- Approved | Reject

	-- loop 처리할 대상들
	@p_User_ID			NVARCHAR(MAX)	,
	@p_User_Name		NVARCHAR(MAX)	,	
	@p_Dept_ID			NVARCHAR(MAX)	,
	@p_Group_ID			NVARCHAR(MAX)	,
	@p_Division_ID		NVARCHAR(MAX)	,
	@p_Plant_ID			NVARCHAR(MAX)	,
	@p_Customer_Code	NVARCHAR(MAX)	,
	@p_Regt_User_ID		NVARCHAR(30) ,
	@p_reject_reason	NVARCHAR(MAX)
)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_User_ID				NVARCHAR(MAX) = null ;
	DECLARE @v_User_Name			NVARCHAR(MAX) = null ;
	DECLARE @v_Group_ID				NVARCHAR(MAX) = null ;
	DECLARE @v_Division_ID			NVARCHAR(MAX) = null ;
	DECLARE @v_Plant_ID				NVARCHAR(MAX) = null ;
	--DECLARE @v_Customer_Code		NVARCHAR(MAX) = null ;
	DECLARE @v_Appr_Result			NVARCHAR(MAX) = null ;
	DECLARE @v_Default_Group_ID		NVARCHAR(MAX) = null ;

	DECLARE @v_delimiter	NVARCHAR(1) = '^' 
	DECLARE @max_loop_cnt	INTEGER = 0; 
	DECLARE @mst_loop_cnt	INTEGER = 0;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'UP_FX_SaveApprovalAuthRequest';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	declare @curUserID		nvarchar(50)= N'';
	declare @curGroupID		nvarchar(60) = N'';
	declare @curDivisionID	nvarchar(60) = N'';
	declare @curPlantID		nvarchar(60) = N'';
	--declare @curCustomerCode	nvarchar(60) = N'';

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
					SET @v_User_ID = [dbo].[SCM_ARR_SPL_VAL](@p_User_ID , @v_delimiter , @mst_loop_cnt) ;
					SET @v_User_Name = [dbo].[SCM_ARR_SPL_VAL](@p_User_Name , @v_delimiter , @mst_loop_cnt) ;					
					SET @v_Group_ID = [dbo].[SCM_ARR_SPL_VAL](@p_Group_ID , @v_delimiter , @mst_loop_cnt) ;
					SET @v_Division_ID = [dbo].[SCM_ARR_SPL_VAL](@p_Division_ID , @v_delimiter , @mst_loop_cnt) ;
					SET @v_Plant_ID = [dbo].[SCM_ARR_SPL_VAL](@p_Plant_ID , @v_delimiter , @mst_loop_cnt) ;
					--SET @v_Customer_Code = [dbo].[SCM_ARR_SPL_VAL](@p_Customer_Code , @v_delimiter , @mst_loop_cnt) ;
				END

				IF @mst_loop_cnt > 0 
				BEGIN
					-- reject면 SCM_MST_AUTH_REQUEST만 갱신
					-- approved라면 해당 group권한부여 등의 작업도 진행해야 한다
					IF UPPER(@p_Appr_Result) = 'REJECT'
					BEGIN

						UPDATE SCM_MST_AUTH_REQUEST
						   SET
							   APPROVAL_RESULT = @p_Appr_Result ,
							   APPROVAL_USER = @p_Regt_User_ID ,
							   REJECT_REASON = @p_reject_reason ,	-- Reject할때는 reason을 추가
							   LAST_UPDATED_BY = @p_Regt_User_ID ,
							   LAST_UPDATE_DATE = GETDATE()
						 WHERE 1=1
						   AND USER_ID = @v_User_ID
						   AND GROUP_ID = @v_Group_ID
						   AND DIVISION_ID = @v_Division_ID
						   AND PLANT_ID = @v_Plant_ID

						-- E20230216-000381, 기존 권한 회수
						DELETE FROM [dbo].[TB_FX_UserGroupAuthExtention]
						 WHERE groupid = @v_Group_ID
						   AND userid = @v_User_ID
						   AND code = @v_Division_ID

						UPDATE T
						   SET T.useyn = 'N'
						  FROM [dbo].[TB_FX_UserGroupInfo] as T with(nolock)
						 WHERE userid = @v_User_ID
						   AND groupid = @v_Group_ID
						   AND NOT EXISTS (SELECT *
						                     FROM [dbo].[TB_FX_UserGroupAuthExtention] as S with(nolock)
						                    WHERE s.groupid = t.groupid
						                      AND s.userid = t.userid
						                  )
						--
					END

					ELSE IF UPPER(@p_Appr_Result) = 'APPROVED'
					BEGIN
						UPDATE SCM_MST_AUTH_REQUEST
						SET
							APPROVAL_RESULT = @p_Appr_Result ,
							APPROVAL_USER = @p_Regt_User_ID ,
							LAST_UPDATED_BY = @p_Regt_User_ID ,
							LAST_UPDATE_DATE = GETDATE()
						WHERE 1=1							
							AND USER_ID = @v_User_ID	
							AND GROUP_ID = @v_Group_ID		
							AND DIVISION_ID = @v_Division_ID
							AND PLANT_ID = @v_Plant_ID;

						-- user_id가 달라지면, 정보 저장
						if @curUserID != @v_User_ID
						begin
							-- user info 다시 저장처리 (Guest -> 다른 default gruop id로 갱신 -- User테이블의 DefaultGroupID세팅 -- 처음 들어온 GroupID로 갱신
							declare 
								@tUserNameE nvarchar(150) ,
								@tEmail nvarchar(150),
								@tDept_ID NVARCHAR(50) ,
								@tCellPhoneNum			NVARCHAR(30) ,
								@tLanguage				NVARCHAR(100) ,
								@tTimeZone				NVARCHAR(100),
								@tPermanentYN			NVARCHAR(1)

							select
								@tUserNameE = a.UserName_E , 
								@tEmail = a.Email, 
								@tDept_ID = a.Dept_ID,
								@tCellPhoneNum = a.CellPhoneNum,
								@tLanguage = a.Language ,
								@tTimeZone = a.TimeZone ,
								@v_Default_Group_ID = DefaultGroupID,
								@tPermanentYN = a.PermanentYN
							from TB_FX_User a
							where UserID= @v_User_ID;

							--Default 권한일 경우 신규 권한 요청 그룹을 Default 권한으로 넣어주고 아닐 경우 기존 Default 권한을 유지한다.
							if @v_Default_Group_ID = 'Guest'
								begin
									set @v_Default_Group_ID = @v_Group_ID
								end

							exec dbo.UP_FX_SaveUserInfo
								@v_User_ID , 
								@v_User_Name, 
								@tUserNameE, 
								@tEmail ,
								@tDept_ID , 
								null,	-- office phone Num
								@tCellPhoneNum , 
								@tLanguage ,
								@v_Default_Group_ID, -- defaultGruopID
								@tTimeZone , 
								@tPermanentYN ,
								'Y', @p_Regt_User_ID , null,
								null, null, null, null ,
								null, null, null, null,
								null

							-- 달라진 userid별로 다시 division 부터 Customer_code입력까지 다시 넣어하므로 초기화
							-- customer 입력부분은 없어짐.
							set @curUserID = @v_User_ID
							set @curGroupID		= N'';
							set @curDivisionID	= N'';
							set @curPlantID = N'';

						end

						-- 그룹 id (권한) 이 다를때마다 저장하기
						if @curGroupID != @v_Group_ID
						begin
							select 'user', @curUserID , '현재 권한' , @curGroupID , '다음 권한', @v_Group_ID 
							-- 현재 권한 정보 저장
							set @curGroupID = @v_Group_ID
							
							exec [dbo].[UP_FX_SaveUserGroupInfo] @v_Group_ID , @curUserID , N'Y' , @p_Regt_User_ID ;
						end

						-- division이 다를때마다 저장
						-- division이 다르더라도, Plant가 있느냐 없느냐로 분기
						--if @curDivisionID != @v_Division_ID
						if @curGroupID = @v_Group_ID and @v_Division_ID != null or @v_Division_ID != '' 
						begin
							set @curDivisionID = @v_Division_ID

							exec [dbo].[UP_FX_SaveUserGroupAuthExtention]
								@curGroupID , @curUserID, 'D', @curDivisionID , '' , @p_Regt_User_ID;
						end
						
						/*
						-- division + plant 조합인경우
						if @curDivisionID = @v_Division_ID and @v_Plant_ID != null or @v_Plant_ID != '' 
						begin
							exec [dbo].[UP_FX_SaveUserGroupAuthExtention]
									@curGroupID , @curUserID, 'P', @v_Plant_ID , @curDivisionID , @p_Regt_User_ID;
						end
						*/

					END	-- Approved에 대한 처리

				END	-- reject or approved에 대한 분기

			END
		END

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			
		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  @max_loop_cnt AS result_cnt ;

	commit tran

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

