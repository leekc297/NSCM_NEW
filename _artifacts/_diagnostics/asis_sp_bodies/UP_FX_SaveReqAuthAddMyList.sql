

/*
 * Program ID   : UP_FX_SaveReqAuthAddMyList
 * Description  : 신규 사용자 권한 요청 저장 (Auth Request > Add 버튼 클릭)
 * Program History
 *===================================================================================================
 *   Date       In Charge       Description
 *===================================================================================================
 * 2017.02.27   KYH            
 * 2023.03.02   FP Pjt.         E20230216-000381 Merge 처리
 * 2025.04.03   Philsu Park     [E20250401-000548] 선감지(SMS) 대상 기준 정리: 오류 수정.
 */	
CREATE PROCEDURE [dbo].[UP_FX_SaveReqAuthAddMyList]
(
	@p_active_flag			NVARCHAR(MAX) = 'I'
	, @p_User_ID			NVARCHAR(MAX)
	, @p_Group_ID			NVARCHAR(MAX)
	, @p_Division_ID		NVARCHAR(MAX)
	, @p_Plant_ID			NVARCHAR(MAX)
	, @p_Customer_Code		NVARCHAR(MAX)
	, @p_Approval_Result	NVARCHAR(MAX)
    , @p_Created_By			NVARCHAR(MAX)
	, @p_Last_Updated_By	NVARCHAR(MAX)
	-- , @p_Created_By			NVARCHAR(150)
	-- , @p_Last_Updated_By	NVARCHAR(150)
	--, @Attribute1			NVARCHAR(150)
	--, @Attribute2			NVARCHAR(150)
	--, @Attribute3			NVARCHAR(150)
	--, @Attribute4			NVARCHAR(150)
	--, @Attribute5			NVARCHAR(150)
	--, @Attribute6			NVARCHAR(150)
	--, @Attribute7			NVARCHAR(150)
	--, @Attribute8			NVARCHAR(150)
	--, @Attribute9			NVARCHAR(150)
	--, @Attribute10			NVARCHAR(150)
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;
	
	DECLARE @V_User_ID				NVARCHAR(MAX) = null ;
	DECLARE @V_Group_ID				NVARCHAR(MAX) = null ;
	DECLARE @V_Division_ID			NVARCHAR(MAX) = null ;
	DECLARE @V_Plant_ID				NVARCHAR(MAX) = null ;
	--DECLARE @V_Customer_Code		NVARCHAR(MAX) = null ;
	DECLARE @V_Approval_Result		NVARCHAR(MAX) = null ;
	DECLARE @V_Created_By			NVARCHAR(MAX) = null ;
	DECLARE @V_Last_Updated_By		NVARCHAR(MAX) = null ;
    -- Philsu Park [E20250401-000548]: Parameter 값 사이즈 제약으로 Cursor에서 created_by 값 누락을 방지하기 위한 조치.
    DECLARE @V_Created_By_Rep       NVARCHAR(150) = LEFT(@p_Created_By, IIF(CHARINDEX('^', @p_Created_By) = 0, LEN(@p_Created_By), CHARINDEX('^', @p_Created_By)-1));

	DECLARE @v_delimiter	NVARCHAR(1) = '^' 
	DECLARE @max_loop_cnt	INTEGER = 0; 
	DECLARE @mst_loop_cnt	INTEGER = 0;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'UP_FX_SaveReqAuthAddMyList';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	BEGIN TRY
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
        -- SET @v_description = @p_Created_By;
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);    
		SELECT    @max_loop_cnt;

		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;
			SELECT @mst_loop_cnt,'@mst_loop_cnt'		

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN			 
			    SET @V_User_ID = [dbo].[SCM_ARR_SPL_VAL](@p_User_ID, @v_delimiter , @mst_loop_cnt) ;    
				SET @V_Group_ID = [dbo].[SCM_ARR_SPL_VAL](@p_Group_ID, @v_delimiter , @mst_loop_cnt) ;    
				SET @V_Division_ID = [dbo].[SCM_ARR_SPL_VAL](@p_Division_ID, @v_delimiter , @mst_loop_cnt) ; 
				SET @V_Plant_ID = [dbo].[SCM_ARR_SPL_VAL](@p_Plant_ID, @v_delimiter , @mst_loop_cnt) ;
				--SET @V_Customer_Code = [dbo].[SCM_ARR_SPL_VAL](@p_Customer_Code, @v_delimiter , @mst_loop_cnt) ;  
				SET @V_Approval_Result = [dbo].[SCM_ARR_SPL_VAL](@p_Approval_Result, @v_delimiter , @mst_loop_cnt) ;  
                -- 2025.04.03 Philsu Park [E20250401-000548]: NULL값으로 간헐적 에러 발생 방지를 위해 Created_by 값이 NULL인 경우 default 값으로 넣어줌.
				-- SET @V_Created_By = [dbo].[SCM_ARR_SPL_VAL](@p_Created_By, @v_delimiter , @mst_loop_cnt) ;    
                SET @V_Created_By = ISNULL([dbo].[SCM_ARR_SPL_VAL](@p_Created_By, @v_delimiter , @mst_loop_cnt), @V_Created_By_Rep) ;
				SET @V_Last_Updated_By = [dbo].[SCM_ARR_SPL_VAL](@p_Last_Updated_By , @v_delimiter , @mst_loop_cnt) ;

				IF @mst_loop_cnt > 0 
				BEGIN
				   
					MERGE dbo.SCM_MST_AUTH_REQUEST AS U
					USING (
						SELECT @v_user_id			AS USER_ID
						     , @v_group_id			AS GROUP_ID 	
							 , @v_division_id		AS DIVISION_ID
						     , @V_Plant_ID			AS PLANT_ID
							 ) AS T
				      ON U.User_ID			= T.User_ID
					 AND U.GROUP_ID			= T.Group_ID
					 AND U.Division_ID		= T.Division_ID
					 AND U.Plant_ID			= T.Plant_ID
					WHEN MATCHED THEN
						UPDATE SET
							U.Approval_Result		= @V_Approval_Result,
							U.Approval_User			= null,
							U.Reject_reason         = null,
							U.CREATED_BY			= @V_Created_By,
							U.CREATION_DATE			= getdate(),
							U.Last_UPDATED_BY		= null,
							U.Last_Update_Date		= null,
							Attribute1				= null,
							Attribute2				= null,	
							Attribute3				= null,
							Attribute4				= null,
							Attribute5				= null,
							Attribute6				= null,
							Attribute7				= null,
							Attribute8				= null,
							Attribute9				= null,
							Attribute10				= null
					WHEN NOT MATCHED THEN
						INSERT ( 
							user_id, group_id, division_id, PLANT_ID,
							Approval_Result, Approval_User,	CREATED_BY,	CREATION_DATE ,	
							Last_UPDATED_BY, Last_Update_Date,	
							Attribute1,
							Attribute2,	
							Attribute3,
							Attribute4,
							Attribute5,
							Attribute6,
							Attribute7,
							Attribute8,
							Attribute9,
							Attribute10
						) 
						VALUES (
							@v_user_id , @v_group_id ,	@v_division_id ,@v_plant_id ,
							@v_Approval_Result ,NULL , @v_CREATED_BY , getdate() ,	
							null, null,
							null,
							null,
							null,
							null,
							null,
							null,
							null,
							null,
							null,
							null
						);
				END
			END
		END

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
	END TRY

	BEGIN CATCH
	BEGIN
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

		IF @@TRANCOUNT > 0
			COMMIT WORK;
		END;

		-- error코드, errror 메시지 반환
		SELECT 'F' AS result_code;
		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	END CATCH;

	
END

