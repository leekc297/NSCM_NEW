


/*
 * Program ID   : SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_DATASET
 * Description  : shipment plan semi 등록, 수정
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/05/27	YHW				[CSR ID:4010290] SCP UI 생산/출하 계획 저장속도 개선
 * 2019/07/22	YHW				[CSR ID:4053788] 자체개선 - Tact TIme Except 입력 날짜 Validation 추가 외 3건
 *                              -> 오류선조치 - qty INT 캐스팅 오류 수정
 * 2022/04/29   chaan			81_UC, EE_UC 추가로 DIVSION 크기 확장
 */

CREATE PROCEDURE [dbo].[SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_DATASET_20251114_dev_org]
	@SCP0010			AS DBO.SCP0010       READONLY
AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @max_loop_cnt		NVARCHAR(50);


	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_DATASET';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';

	-- 실행시간 확인용    
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();    
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'00:00';   

	DECLARE @v_time_zone  NVARCHAR(100);
	DECLARE @v_creation_date		datetime;		-- timezone에 따른 저장위해서


	/********************************************************************************
	* 임시테이블만들기
	********************************************************************************/
	IF OBJECT_ID('tempdb..#TblDynamic_SCP0010') IS NOT NULL	
		DROP TABLE #TblDynamic_SCP0010 

	CREATE TABLE #TblDynamic_SCP0010 (
		A							nvarchar(1),
		p_active_flag				nvarchar(1),
--chaan		p_division_id				nvarchar(2),
		p_division_id				nvarchar(30),--chaan
		p_plan_start_yyyymmdd		nvarchar(8),
		p_plan_type					nvarchar(2),
		p_seq						nvarchar(10),
		p_operation_group			nvarchar(1),
		p_item_id					nvarchar(100),
		p_from_site					nvarchar(50),
		p_bod_id					nvarchar(50),
		p_measure					nvarchar(100),
		p_yyyymmdd					nvarchar(8),
		p_to_site					nvarchar(100),
		p_qty						nvarchar(200),
--chaan		p_origin_from_division_id	nvarchar(2),
		p_origin_from_division_id	nvarchar(30),--chaan
--chaan		p_origin_to_division_id		nvarchar(2),
		p_origin_to_division_id		nvarchar(30),--chaan
		p_electrode_type			nvarchar(50),
		p_created_by				nvarchar(150),
		p_last_updated_by			nvarchar(150),
		p_time_zone					nvarchar(100),
		p_cplt_flag					nvarchar(1)
	);
	

	-- 트렌젝션 시작
	--BEGIN TRAN;
	BEGIN TRY
		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();

		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


		BEGIN    
			--TimeZone set
			SET @v_time_zone = (SELECT TOP 1 p_time_zone
								FROM @SCP0010  
								)
			;
			IF (@v_time_zone=NULL OR @v_time_zone='')
				SET @v_time_zone = 'AS054'
			;

			SET @v_creation_date    = [dbo].[FN_MULTY_TIME](@v_time_zone); 

			EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, '-2', @v_description, @d_event_date;

			-- 임시테이블 데이타 생성
			INSERT INTO #TblDynamic_SCP0010
			SELECT A,
					p_active_flag,
					p_division_id,
					p_plan_start_yyyymmdd,
					p_plan_type,
					p_seq,
					p_operation_group,
					p_item_id,
					p_from_site,
					p_bod_id,
					p_measure,
					p_yyyymmdd,
					p_to_site,
					p_qty,
					p_origin_from_division_id,
					p_origin_to_division_id,
					p_electrode_type,
					p_created_by,
					p_last_updated_by,
					p_time_zone,
					''
			FROM @SCP0010

			EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, '-1', @v_description, @d_event_date;

			--수정 Row
			SET @max_loop_cnt = convert(nvarchar(50), ISNULL((
									SELECT COUNT(*) 
									FROM #TblDynamic_SCP0010  
								  ),0))
			;

			EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, '0', @v_description, @d_event_date;

			-- 1. 수정수량 UPDATE
			UPDATE A
			SET A.TO_SITE			= B.p_to_site
				--, A.QTY				= cast(B.p_qty as int)
				, A.QTY				= cast(round (cast(B.p_qty as numeric(20,10)), 0 ,1) as int)
				, A.LAST_UPDATED_BY	= B.p_last_updated_by 
				, A.LAST_UPDATE_DATE	= @v_creation_date
			FROM SCP_ANL_SHIPMENT_PLAN_SEMI A, #TblDynamic_SCP0010 B
			WHERE A.DIVISION_ID				= B.p_division_id
			AND A.PLAN_START_YYYYMMDD		= B.p_plan_start_yyyymmdd
			AND A.PLAN_TYPE					= B.p_plan_type
			AND A.SEQ						= B.p_seq
			AND A.operation_group			= B.p_operation_group
			AND A.ITEM_ID					= B.p_item_id
			AND A.FROM_SITE					= B.p_from_site
			AND A.BOD_ID					= B.p_bod_id
			AND A.ORIGIN_FROM_DIVISION_ID	= B.p_origin_from_division_id
			AND A.ORIGIN_TO_DIVISION_ID		= B.p_origin_to_division_id
			AND ISNULL(A.ELECTRODE_TYPE,'')	= ISNULL(B.p_electrode_type,'') -- CSR:E20251028-000534
			AND A.MEASURE					= B.p_measure
			AND A.YYYYMMDD					= B.p_yyyymmdd
			AND B.p_active_flag IN ('M', 'I')
			;

			select 
				@v_description = concat(p_division_id,',',p_plan_start_yyyymmdd,',',p_plan_type,',',p_seq,','
				,p_operation_group,','
				,p_item_id,','
				,p_from_site,','
				,p_bod_id,','
				,p_origin_from_division_id,','
				,p_origin_to_division_id,','
				,p_electrode_type,','
				,p_measure,','
				,p_yyyymmdd,','
				) 
				from  #TblDynamic_SCP0010

			EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, '1', @v_description, @d_event_date;

			UPDATE B
			SET B.p_cplt_flag = 'Y'
			FROM SCP_ANL_SHIPMENT_PLAN_SEMI A, #TblDynamic_SCP0010 B
			WHERE A.DIVISION_ID				= B.p_division_id
			AND A.PLAN_START_YYYYMMDD		= B.p_plan_start_yyyymmdd
			AND A.PLAN_TYPE					= B.p_plan_type
			AND A.SEQ						= B.p_seq
			AND A.operation_group			= B.p_operation_group
			AND A.ITEM_ID					= B.p_item_id
			AND A.FROM_SITE					= B.p_from_site
			AND A.BOD_ID					= B.p_bod_id
			AND A.ORIGIN_FROM_DIVISION_ID	= B.p_origin_from_division_id
			AND A.ORIGIN_TO_DIVISION_ID		= B.p_origin_to_division_id
			AND ISNULL(A.ELECTRODE_TYPE,'')	= B.p_electrode_type  -- CSR:E20251028-000534
			AND A.MEASURE					= B.p_measure
			AND A.YYYYMMDD					= B.p_yyyymmdd
			AND B.p_active_flag IN ('M', 'I')
			;

			select 
				@v_description = concat(p_division_id,',',p_plan_start_yyyymmdd,',',p_plan_type,',',p_seq,','
				,p_operation_group,','
				,p_item_id,','
				,p_from_site,','
				,p_bod_id,','
				,p_origin_from_division_id,','
				,p_origin_to_division_id,','
				,p_electrode_type,','
				,p_measure,','
				,p_yyyymmdd,','
				) 
				from  #TblDynamic_SCP0010

			EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, '2', @v_description, @d_event_date;

			-- 2. 신규수량 INSERT
			INSERT INTO dbo.SCP_ANL_SHIPMENT_PLAN_SEMI
				(DIVISION_ID
				,PLAN_START_YYYYMMDD
				,PLAN_TYPE
				,SEQ
				,OPERATION_GROUP
				,ITEM_ID
				,FROM_SITE
				,BOD_ID
				,MEASURE
				,YYYYMMDD
				,TO_SITE
				,QTY
				,ORIGIN_FROM_DIVISION_ID
				,ORIGIN_TO_DIVISION_ID
				,ELECTRODE_TYPE
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
				)
			SELECT p_division_id  
					,p_plan_start_yyyymmdd
					,p_plan_type
					,p_seq
					,p_operation_group
					,p_item_id		
					,p_from_site
					,p_bod_id		
					,p_measure		
					,p_yyyymmdd		
					,p_to_site
					--,cast(p_qty as int)
					,cast(round (cast(p_qty as numeric(20,10)), 0 ,1) as int)
					,p_origin_from_division_id
					,p_origin_to_division_id
					,p_electrode_type
					,p_created_by
					,@v_creation_date
					,p_last_updated_by
					,@v_creation_date
			FROM #TblDynamic_SCP0010
			WHERE p_active_flag IN ('M', 'I')
			  AND ISNULL(p_cplt_flag,'')=''
			;
			EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, '3', @v_description, @d_event_date;

			-- 3. 삭제수량 DELETE
			DELETE A
			FROM SCP_ANL_SHIPMENT_PLAN_SEMI A, #TblDynamic_SCP0010 B
			WHERE A.DIVISION_ID				= B.p_division_id
			AND A.PLAN_START_YYYYMMDD		= B.p_plan_start_yyyymmdd
			AND A.PLAN_TYPE					= B.p_plan_type
			AND A.SEQ						= B.p_seq
			AND A.operation_group			= B.p_operation_group
			AND A.ITEM_ID					= B.p_item_id
			AND A.FROM_SITE					= B.p_from_site
			AND A.BOD_ID					= B.p_bod_id
			AND A.MEASURE					= B.p_measure
			AND A.YYYYMMDD					= B.p_yyyymmdd
			AND A.ORIGIN_FROM_DIVISION_ID	= B.p_origin_from_division_id
			AND A.ORIGIN_TO_DIVISION_ID		= B.p_origin_to_division_id
			AND A.ELECTRODE_TYPE			= B.p_electrode_type
			AND B.p_active_flag				= 'D'

			EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, '4', @v_description, @d_event_date;

			-- 4. FIX수량 UPDATE
			UPDATE A
			SET --A.qty				= cast(B.p_qty as int)
				A.qty				= cast(round (cast(B.p_qty as numeric(20,10)), 0 ,1) as int)
				,A.last_updated_by	= B.p_last_updated_by
				,A.last_update_date	= @v_creation_date
			FROM SCP_ANL_SHIPMENT_PLAN_FIX A, #TblDynamic_SCP0010 B
			WHERE A.division_id				= B.p_division_id
			and A.BIZ_TYPE					= B.p_operation_group
			and A.ITEM_ID					= B.p_item_id
			and A.TO_SITE					= B.p_to_site
			and A.FROM_SITE					= B.p_from_site
			and A.BOD_ID					= B.p_bod_id
			and A.yyyymmdd					= B.p_yyyymmdd
			AND A.ORIGIN_FROM_DIVISION_ID	= B.p_origin_from_division_id
			AND A.ORIGIN_TO_DIVISION_ID		= B.p_origin_to_division_id
			AND ISNULL(NULLIF(A.ELECTRODE_TYPE,''),'-') = ISNULL(NULLIF(B.p_electrode_type,''),'-')

			EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, '5', @v_description, @d_event_date;

			-- 5. FIX이력저장
			EXEC [dbo].[PR_SCP_ANL_SHIPMENT_PLAN_SEMI_FIX_HIST_DATASET] @SCP0010

			EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, '6', @v_description, @d_event_date;

			-- 6. 이력저장
			EXEC [dbo].[PR_SCP_ANL_SHIPMENT_PLAN_SEMI_HIST_DATASET] @SCP0010

			EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, '7', @v_description, @d_event_date;

			--commit;

		END;

		SET @v_exec_time  =  REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
							 REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))    

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description  = N'[' + @v_exec_time + ']';   
		SET @d_event_date = SYSDATETIME();

		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  @max_loop_cnt AS result_cnt ;

	END TRY

	BEGIN CATCH 
		BEGIN
			--if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리
						
			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			-- error코드, errror 메시지 반환
			SELECT 'F' AS result_code, '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE() AS err_message ;

		END;
	END CATCH;
end;

