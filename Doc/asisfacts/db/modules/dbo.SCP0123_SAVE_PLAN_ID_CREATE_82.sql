
/*
 * Program ID   : SCP0123_SAVE_PLAN_ID_CREATE_82
 * Description  : Plan ID 등록
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/05/12   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Initial Release
 * 2025/06/11   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Plan ID 채번시 plan group name 으로 채번
 * 2025/07/08   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - No Frozen 체크 추가
 * 2025/08/20   mrchois			PJ20257329  최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Plan ID 채번시 ATTRIBUTE10 = 'AI' 인 정보 제외
 * 2025/09/05   mrchois			PJ20257329  최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Plan ID 생성시 '_'가 있는 그룹명의 채번 수정
 * 2026/09/07	YMH				E20260812-000909 [ESS] Supply > OPT Plan > Plan Control 의 Create Plan ID 팝업 변경 요청드립니다.
 *								   		SCP0123_SAVE_PLAN_ID_CREATE 에서 SCP0123_SAVE_PLAN_ID_CREATE_82 로 로직 분리
 */
CREATE PROCEDURE [dbo].[SCP0123_SAVE_PLAN_ID_CREATE_82]

	-- Add the parameters for the stored procedure here
	@p_division_id						NVARCHAR(30), 
	@p_plan_gr_id						NVARCHAR(30), 
	@p_plan_gr_name						NVARCHAR(200), 
	@p_prs_cd							NVARCHAR(30), 
	@p_plan_start_yyyymmdd				NVARCHAR(8), 
	@p_plan_end_yyyymmdd				NVARCHAR(8), 
	@p_dmd_ver_id						NVARCHAR(50),
	@p_prod_ref_sys_divs_cd				NVARCHAR(30), 
	@p_prod_ref_sys_plan_id				NVARCHAR(50), 
	@p_link_prod_frz_start_yyyymmdd		NVARCHAR(8), 
	@p_link_prod_frz_end_yyyymmdd		NVARCHAR(8), 
	@p_pmdu_prod_frz_start_yyyymmdd		NVARCHAR(8), 
	@p_pmdu_prod_frz_end_yyyymmdd		NVARCHAR(8), 
	@p_cell_prod_frz_start_yyyymmdd		NVARCHAR(8), 
	@p_cell_prod_frz_end_yyyymmdd		NVARCHAR(8), 
	@p_ship_ref_sys_divs_cd				NVARCHAR(30), 
	@p_ship_ref_sys_plan_id				NVARCHAR(50), 
	@p_link_ship_frz_start_yyyymmdd		NVARCHAR(8), 
	@p_link_ship_frz_end_yyyymmdd		NVARCHAR(8), 
	@p_pmdu_ship_frz_start_yyyymmdd		NVARCHAR(8), 
	@p_pmdu_ship_frz_end_yyyymmdd		NVARCHAR(8), 
	@p_cell_ship_frz_start_yyyymmdd		NVARCHAR(8), 
	@p_cell_ship_frz_end_yyyymmdd		NVARCHAR(8), 
	@p_pram_ty_cd						NVARCHAR(20), 
	@p_plan_desc						NVARCHAR(400), 
	@p_link_prod_no_frz_yn				NVARCHAR(1), 
	@p_pmdu_prod_no_frz_yn				NVARCHAR(1), 
	@p_cell_prod_no_frz_yn				NVARCHAR(1), 
	@p_link_ship_no_frz_yn				NVARCHAR(1), 
	@p_pmdu_ship_no_frz_yn				NVARCHAR(1), 
	@p_cell_ship_no_frz_yn				NVARCHAR(1), 
	@p_user_id							NVARCHAR(MAX)

AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @v_working_time			DATETIME =sysdatetime();
	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	--SET @recv_active_flag = @p_active_flag;

	DECLARE @v_active_flag		NVARCHAR(MAX);
	DECLARE @v_plan_id		NVARCHAR(MAX);
	
	SET @v_active_flag		= NULL;
	SET @v_plan_id		= NULL;	
		
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0123_SAVE_PLAN_ID_CREATE_82';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	DECLARE @v_data_dup_cnt  INT=0;


	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';

	-- 트렌젝션 시작
	BEGIN TRAN;

	BEGIN TRY
			-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		DECLARE @strKey  NVARCHAR(50)
		SET @strKey = @p_plan_start_yyyymmdd + '_' + @p_division_id + '_' + @p_plan_gr_name + '_'	--채번시 plan group name 으로 채번(2025-06-11 요청)
		--Plan Id 채번(계획시작일_Div._Plan Group_Plan Group별 Seq) 
		--SELECT @v_plan_id = @strKey + dbo.FN_ZERO_LPAD(CONVERT(NVARCHAR, CAST(ISNULL(MAX(SUBSTRING(OPMZ_PLAN_ID, 20, 3)), '000') AS INT) + 1 ), 3)
		-- Plan Group Name 길이 변동에 따른 에러 발생으로 Plan ID 마지막 3자리 잘라서 채번하도록 수정(2025-06-17)
		SELECT @v_plan_id = @strKey + dbo.FN_ZERO_LPAD(CONVERT(NVARCHAR, CAST(ISNULL(MAX(RIGHT(OPMZ_PLAN_ID, 3)), '000') AS INT) + 1 ), 3) 
		FROM SCP_OPMZ_PLAN_M
		WHERE OPMZ_PLAN_ID like '%' + @strKey + '%'
		AND OPMZ_PLAN_GR_ID = @p_plan_gr_id		--[PJ20257329] Plan ID 생성시 '_'가 있는 그룹명의 채번 수정(2025-09-05)
		AND ISNULL(ATTRIBUTE10, '') != 'AI'		--[PJ20257329] Plan ID 채번시 ATTRIBUTE10 = 'AI' 인 정보 제외 (2025-08-20)

		INSERT INTO SCP_OPMZ_PLAN_M
		(
			OPMZ_PLAN_ID
			, OPMZ_PLAN_GR_ID
			, OPMZ_PRS_CD
			, DIVISION_ID
			, PLAN_START_YYYYMMDD
			, PLAN_END_YYYYMMDD
			, DMD_VER_ID
			, OPMZ_PRAM_TP_CD
			, OPMZ_PLAN_DESC
			, PROD_REF_SYS_DIVS_CD ---------------- ㅇ
			, PROD_REF_SYS_PLAN_ID
			, LINK_PROD_FRZ_START_YYYYMMDD
			, LINK_PROD_FRZ_END_YYYYMMDD
			, PMDU_PROD_FRZ_START_YYYYMMDD
			, PMDU_PROD_FRZ_END_YYYYMMDD
			, CELL_PROD_FRZ_START_YYYYMMDD
			, CELL_PROD_FRZ_END_YYYYMMDD
			, SHIP_REF_SYS_DIVS_CD
			, SHIP_REF_SYS_PLAN_ID
			, LINK_SHIP_FRZ_START_YYYYMMDD	---------------- ㅇㅇ
			, LINK_SHIP_FRZ_END_YYYYMMDD
			, PMDU_SHIP_FRZ_START_YYYYMMDD
			, PMDU_SHIP_FRZ_END_YYYYMMDD
			, CELL_SHIP_FRZ_START_YYYYMMDD
			, CELL_SHIP_FRZ_END_YYYYMMDD
			, ATTRIBUTE1	--PMDU_prod_no_frz_yn    
			, ATTRIBUTE2	--cell_PROD_no_frz_yn
			, ATTRIBUTE4	--LINK_PROD_no_frz_yn -- ATTRIBUTE3 은 SHIP공통으로 82때에는 사용안함.
			, ATTRIBUTE5	-- LINK_SHIP_NO_FRZ_YN
			, ATTRIBUTE6	-- PMDU_SHIP_NO_FRZ_YN
			, ATTRIBUTE7	-- CELL_SHIP_NO_FRZ_YN
			, CREATED_BY
			, CREATION_DATE					---------------- ㅇㅇㅇ
			, LAST_UPDATED_BY
			, LAST_UPDATE_DATE
		)
		VALUES
		(
			@v_plan_id
			, @p_plan_gr_id
			, @p_prs_cd
			, @p_division_id
			, @p_plan_start_yyyymmdd
			, @p_plan_end_yyyymmdd
			, @p_dmd_ver_id
			, @p_pram_ty_cd
			, @p_plan_desc
			, @p_prod_ref_sys_divs_cd		---------------- ㅇ
			, @p_prod_ref_sys_plan_id
			, @p_link_prod_frz_start_yyyymmdd
			, @p_link_prod_frz_end_yyyymmdd
			, @p_pmdu_prod_frz_start_yyyymmdd
			, @p_pmdu_prod_frz_end_yyyymmdd
			, @p_cell_prod_frz_start_yyyymmdd
			, @p_cell_prod_frz_end_yyyymmdd
			, @p_ship_ref_sys_divs_cd
			, @p_ship_ref_sys_plan_id
			, @p_link_ship_frz_start_yyyymmdd	---------------- ㅇㅇ
			, @p_link_ship_frz_end_yyyymmdd
			, @p_pmdu_ship_frz_start_yyyymmdd
			, @p_pmdu_ship_frz_end_yyyymmdd
			, @p_cell_ship_frz_start_yyyymmdd
			, @p_cell_ship_frz_end_yyyymmdd
			, @p_pmdu_prod_no_frz_yn	-- attribute1 -- SCP0123_SAVE_PLAN_ID_CREATE 공통사용
			, @p_cell_prod_no_frz_yn	-- attribute2 -- SCP0123_SAVE_PLAN_ID_CREATE 공통사용
			, @p_link_prod_no_frz_yn	-- attribute4
			, @p_link_ship_no_frz_yn	-- attribute5
			, @p_pmdu_ship_no_frz_yn	-- attribute6
			, @p_cell_ship_no_frz_yn	-- attribute7
			, @p_user_id
			, SYSDATETIME()						---------------- ㅇㅇㅇ
			, @p_user_id
			, SYSDATETIME()
		);


		--SCP최적화계획제어활동, SCP최적화계획제어활동운행 정보 등록
		EXEC SCP0123_SAVE_PLAN_CTRL_ACTV_RUN @p_division_id, @p_plan_start_yyyymmdd, @p_prs_cd, @p_plan_gr_id, 'A002', @v_plan_id, @p_user_id ;


		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			
		COMMIT TRAN;
			
		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  '1' AS result_cnt ;

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






