

/*
 * Program ID   : [SCP0013_SAVE_PRODUCTION_PLAN_LINE_ROW_DATASET_20231206]
 * Description  : Production Plan의 Line "Prod. Plan(Amend)" Measure저장(Type Table 저장방식)
 * Program History
 *========================================================================================================================
 *   Date       In Charge		Description
 *========================================================================================================================
 * 2019/01/22	YHW				Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2019/02/21	YHW				[CSR ID:3929450] Supply(Plan Line, FG, SEMI) 수정 시 Fix 데이터 저장로직 개선
 * 2019/06/07	YHW				[CSR ID:4010290] SCP UI 생산/출하 계획 저장속도 개선
 * 2020/02/18	hwyoon			OUTPUT 수량 0 삭제 후 처리로직 추가
 * 2021/10/20   KMJ			    PJ2020964 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - UI 속도 개선으로 대응, 주 SUM 대응
 * 2022/04/29   chaan			81_UC, EE_UC 추가로 DIVSION 크기 확장
 * 2023/12/06   vadabi3			저장 개선
 --------------------------------------------------------------------------------------------------------------------------
 */
CREATE PROCEDURE [dbo].[SCP0013_SAVE_PRODUCTION_PLAN_LINE_ROW_DATASET_20231206]
	 @SCP0013			AS DBO.SCP0013       READONLY
	,@p_user_id			NVARCHAR(MAX) 
AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	--DECLARE @v_created_by       NVARCHAR(MAX)='hwwoonins';
	--DECLARE @v_creation_date    datetime =SYSDATETIME(); 
	--DECLARE @v_last_updated_by  NVARCHAR(MAX)='hwwoonins';
	
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0013_SAVE_PRODUCTION_PLAN_LINE_ROW_DATASET';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;


	--DECLARE @v_data_dup_cnt  INT=0;
	
	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';
	
	-- 트렌젝션 시작
	BEGIN TRAN;


          -- 실행시간 확인용    
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();    
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'00:00';    

	-- BUCKET 확인
	DECLARE @v_bucket_type NVARCHAR(10) = '';
	DECLARE @v_from_yyyymmdd NVARCHAR(8) = '';
	DECLARE @v_to_yyyymmdd NVARCHAR(8) = '';

	BEGIN TRY

		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = @p_user_id;
		SET @d_event_date = SYSDATETIME();
		SELECT @n_log_count = COUNT(*) FROM @SCP0013

		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		IF OBJECT_ID('tempdb..#TblDynamic_SCP0013_TEMP') IS NOT NULL	
			DROP TABLE #TblDynamic_SCP0013_TEMP;
		IF OBJECT_ID('tempdb..#TblDynamic_SCP0013') IS NOT NULL	
			DROP TABLE #TblDynamic_SCP0013;

			CREATE TABLE #TblDynamic_SCP0013 (				
				A						NVARCHAR(1)
				, P_ACTIVE_FLAG			NVARCHAR(1)
--chaan				, P_DIVISION_ID			NVARCHAR(2)
				, P_DIVISION_ID			NVARCHAR(30)--chaan
				, P_PLAN_START_YYYYMMDD	NVARCHAR(8)
				, P_PLAN_TYPE			NVARCHAR(2)
				, P_SEQ					NVARCHAR(10)
				, P_OPERATION_GROUP		NVARCHAR(1)
				, P_SCM_SITE_ID			NVARCHAR(100)
				, P_ITEM_ID				NVARCHAR(100)
				, P_LINE_ID				NVARCHAR(50)
				, P_OPERATION_ID		NVARCHAR(100)
				, P_MEASURE				NVARCHAR(100)
				, P_YYYYMMDD			NVARCHAR(8)
				, P_QTY					NVARCHAR(200)
				, P_USER_ID				NVARCHAR(100)
				, P_FIX					NVARCHAR(1)
				, P_LOC_FLAG			NVARCHAR(1)
				, P_PROGRAM_ID			NVARCHAR(200)
--chaan				, P_ORIGIN_DIVISION_ID	NVARCHAR(2)
				, P_ORIGIN_DIVISION_ID	NVARCHAR(30)--chaan
				, P_ELECTRODE_TYPE		NVARCHAR(50)
				, P_BUCKET_TYPE			NVARCHAR(10)
			);

		-- BUCKET TYPE에 따라 분기
		SELECT DISTINCT
			@v_from_yyyymmdd = P_FROM_YYYYMMDD
			, @v_to_yyyymmdd = P_TO_YYYYMMDD
			, @v_bucket_type = P_BUCKET_TYPE
		FROM @SCP0013
		;

		IF @v_bucket_type = 'WEEKLY'
		BEGIN

			-- 주 SUM QTY -> DAY QTY 변환
			WITH BB AS (

				SELECT
					BASIS_YYYYMM + ISO_WEEK AS WEEK_NAME
					, COUNT(BASIS_YYYYMM) AS DAY_CNT
				FROM SCM_SYS_CALENDAR_M A WITH(NOLOCK)	
				WHERE (BASIS_YYYYMM + ISO_WEEK) IN (
					SELECT P_YYYYMMDD FROM @SCP0013
				)
				AND BASIS_YYYYMMDD BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd
				GROUP BY BASIS_YYYYMM, ISO_WEEK

			),
			CC AS (

				SELECT
					P_DIVISION_ID			
					, P_PLAN_START_YYYYMMDD	
					, P_PLAN_TYPE			
					, P_SEQ					
					, P_OPERATION_GROUP		
					, P_SCM_SITE_ID			
					, P_ITEM_ID				
					, P_LINE_ID				
					, P_OPERATION_ID		
					, P_MEASURE				
					, P_YYYYMMDD AS WEEK_NAME
					, (A.P_QTY / B.DAY_CNT) AS DAY_QTY
					, (A.P_QTY % B.DAY_CNT) AS DAY_EX
				FROM @SCP0013 A
				JOIN BB B
				ON A.P_YYYYMMDD = B.WEEK_NAME

			),
			DD AS (

				SELECT
					BASIS_YYYYMM + ISO_WEEK AS WEEK_NAME
					, BASIS_YYYYMMDD AS DAY_NAME
					, RANK() OVER (PARTITION BY BASIS_YYYYMM + ISO_WEEK ORDER BY BASIS_YYYYMMDD) AS DAY_CNT
				FROM SCM_SYS_CALENDAR_M A WITH(NOLOCK)	
				WHERE (BASIS_YYYYMM + ISO_WEEK) IN (
					SELECT P_YYYYMMDD FROM @SCP0013
				)
				AND BASIS_YYYYMMDD BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd
				GROUP BY BASIS_YYYYMM, ISO_WEEK, BASIS_YYYYMMDD
			
			)
			SELECT
				CC.P_DIVISION_ID			
				, CC.P_PLAN_START_YYYYMMDD	
				, CC.P_PLAN_TYPE			
				, CC.P_SEQ					
				, CC.P_OPERATION_GROUP		
				, CC.P_SCM_SITE_ID			
				, CC.P_ITEM_ID				
				, CC.P_LINE_ID				
				, CC.P_OPERATION_ID		
				, CC.P_MEASURE				
				, DD.WEEK_NAME
				, DD.DAY_NAME
				, IIF(ISNULL(BB.DAY_CNT, 0)=0, CC.DAY_QTY, CC.DAY_QTY+CC.DAY_EX) AS QTY
			INTO #TblDynamic_SCP0013_TEMP
			FROM CC 
			JOIN DD ON CC.WEEK_NAME = DD.WEEK_NAME
			LEFT JOIN BB ON DD.WEEK_NAME = BB.WEEK_NAME AND DD.DAY_CNT = BB.DAY_CNT
			;

			INSERT INTO #TblDynamic_SCP0013
			SELECT DISTINCT
				A.A
				, A.P_ACTIVE_FLAG
				, A.P_DIVISION_ID
				, A.P_PLAN_START_YYYYMMDD
				, A.P_PLAN_TYPE
				, A.P_SEQ
				, A.P_OPERATION_GROUP
				, A.P_SCM_SITE_ID
				, A.P_ITEM_ID
				, A.P_LINE_ID
				, A.P_OPERATION_ID
				, A.P_MEASURE
				, B.DAY_NAME AS P_YYYYMMDD
				, B.QTY AS P_QTY
				, A.P_USER_ID
				, A.P_FIX
				, A.P_LOC_FLAG
				, A.P_PROGRAM_ID
				, A.P_ORIGIN_DIVISION_ID
				, A.P_ELECTRODE_TYPE
				, A.P_BUCKET_TYPE
			FROM @SCP0013 A
			JOIN #TblDynamic_SCP0013_TEMP B
			ON A.P_DIVISION_ID			= B.P_DIVISION_ID
			AND A.P_PLAN_START_YYYYMMDD	= B.P_PLAN_START_YYYYMMDD	
			AND A.P_PLAN_TYPE			= B.P_PLAN_TYPE			
			AND A.P_SEQ					= B.P_SEQ					
			AND A.P_OPERATION_GROUP		= B.P_OPERATION_GROUP		
			AND A.P_SCM_SITE_ID			= B.P_SCM_SITE_ID			
			AND A.P_ITEM_ID				= B.P_ITEM_ID				
			AND A.P_LINE_ID				= B.P_LINE_ID				
			AND A.P_OPERATION_ID		= B.P_OPERATION_ID		
			AND A.P_MEASURE				= B.P_MEASURE
			AND A.P_YYYYMMDD			= B.WEEK_NAME
			;


		END
		
		ELSE	-- DAILY
		BEGIN

			INSERT INTO #TblDynamic_SCP0013
			SELECT 
				A.A
				, A.P_ACTIVE_FLAG
				, A.P_DIVISION_ID
				, A.P_PLAN_START_YYYYMMDD
				, A.P_PLAN_TYPE
				, A.P_SEQ
				, A.P_OPERATION_GROUP
				, A.P_SCM_SITE_ID
				, A.P_ITEM_ID
				, A.P_LINE_ID
				, A.P_OPERATION_ID
				, A.P_MEASURE
				, A.P_YYYYMMDD
				, A.P_QTY
				, A.P_USER_ID
				, A.P_FIX
				, A.P_LOC_FLAG
				, A.P_PROGRAM_ID
				, A.P_ORIGIN_DIVISION_ID
				, A.P_ELECTRODE_TYPE
				, A.P_BUCKET_TYPE
			FROM @SCP0013 A
			;

		END
		;


		--수정
		UPDATE A
		SET A.QTY = B.p_qty
			, a.LAST_UPDATE_DATE = getdate()
			, a.LAST_UPDATED_BY = b.p_user_id
		FROM scp_anl_production_plan A, #TblDynamic_SCP0013 B
		WHERE A.DIVISION_ID        = B.p_division_id          
		AND A.PLAN_START_YYYYMMDD  = B.p_plan_start_yyyymmdd
		AND A.PLAN_TYPE            = B.p_plan_type
		AND A.SEQ                  = B.p_seq
		AND A.OPERATION_GROUP      = B.p_operation_group
		AND A.SCM_SITE_ID          = B.p_scm_site_id
		AND A.ITEM_ID              = B.p_item_id
		AND A.LINE_ID              = B.p_line_id
		AND A.OPERATION_ID         = B.p_operation_id
		AND A.MEASURE              = B.p_measure
		AND A.YYYYMMDD             = B.p_yyyymmdd
		AND ISNULL(NULLIF(A.ELECTRODE_TYPE,''),'-')  = ISNULL(NULLIF(B.p_electrode_type,''),'-')
		;


		--이력저장
		DECLARE @SCP0013_HIST	AS DBO.SCP0013;

		INSERT INTO @SCP0013_HIST
		(
			p_division_id, 
			p_plan_start_yyyymmdd, 
			p_plan_type,  
			p_seq, 
			p_operation_group,
			p_scm_site_id, 
			p_item_id, 
			p_line_id, 
			p_operation_id, 
			p_measure, 
			p_yyyymmdd, 
			p_qty, 
			p_origin_division_id, 
			p_electrode_type, 
			p_user_id
		)
		SELECT
			p_division_id, 
			p_plan_start_yyyymmdd, 
			p_plan_type,  
			p_seq, 
			p_operation_group,
			p_scm_site_id, 
			p_item_id, 
			p_line_id, 
			p_operation_id, 
			p_measure, 
			p_yyyymmdd, 
			p_qty, 
			p_origin_division_id, 
			p_electrode_type, 
			p_user_id
		FROM #TblDynamic_SCP0013
		;

		EXEC [dbo].[PR_SCP_ANL_PRODUCTION_PLAN_HIST_DATASET] @SCP0013_HIST;


		--Fix Data 수정
		UPDATE A
		SET A.QTY = B.p_qty
			, a.LAST_UPDATE_DATE = getdate()
			, a.LAST_UPDATED_BY = b.p_user_id
		FROM SCP_ANL_PRODUCTION_PLAN_FIX A, #TblDynamic_SCP0013 B
		WHERE A.DIVISION_ID          = B.p_division_id          
		AND A.OPERATION_GROUP      = B.p_operation_group
		AND A.SCM_SITE_ID          = B.p_scm_site_id
		AND A.ITEM_ID              = B.p_item_id
		AND A.LINE_ID              = B.p_line_id
		AND A.OPERATION_ID         = B.p_operation_id
		AND A.YYYYMMDD             = B.p_yyyymmdd
		AND ISNULL(NULLIF(A.ELECTRODE_TYPE,''),'-')  = ISNULL(NULLIF(B.p_electrode_type,''),'-')
		--AND B.p_fix='Y'

		--Fix 이력저장
		EXEC [dbo].[PR_SCP_ANL_PRODUCTION_PLAN_FIX_HIST_DATASET] @SCP0013_HIST;

		
		-- 임시 운영반영시에 주석처리 할것.    
		SET @v_exec_time  =  REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
							 REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))    

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description  = N'[' + @v_exec_time + ']';   
		SET @d_event_date = SYSDATETIME();
		
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		COMMIT TRAN;			
		
		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  1 AS result_cnt ;

	END TRY

	BEGIN CATCH 
		BEGIN
			--if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리
						
			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			--IF @@TRANCOUNT > 0
			--  COMMIT WORK;
					  

			-- error코드, errror 메시지 반환
			--SELECT 'F' AS result_code;

			IF( @v_err_code IS NULL OR @v_err_code ='')
				SET @v_err_code= ERROR_NUMBER() ;
			IF( @v_err_message IS NULL OR @v_err_message ='') 
				SET @v_err_message=  ERROR_MESSAGE();
						
			/* 에러 메시지, 에러 데이터  반환   */	
			SELECT  @v_err_code			AS err_code
				   ,@v_err_message		AS err_message
				     
			; 
		END;
	END CATCH;
END




