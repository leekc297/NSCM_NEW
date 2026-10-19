

/*
 * Program ID   : SCP0009_SAVE_ANL_SHIPMENT_PLAN_FG_DATASET
 * Description  : ANL SHIPMENT PLAN FG save
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2019/05/24	hwyoon			[CSR ID:4010290] SCP UI 생산/출하 계획 저장속도 개선
 * 2019/07/22	hwyoon			오류선조치 - qty INT 캐스팅 오류 수정
 * 2022/04/29   chaan			81_UC, EE_UC 추가로 DIVSION 크기 확장
 * 
 */
CREATE PROCEDURE [dbo].[SCP0009_SAVE_ANL_SHIPMENT_PLAN_FG_DATASET]
	@SCP0009			AS DBO.SCP0009       READONLY
AS

BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	DECLARE @max_loop_cnt		NVARCHAR(50);
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0009_SAVE_ANL_SHIPMENT_PLAN_FG_DATASET';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';
	
	DECLARE @v_time_zone  NVARCHAR(100);
	DECLARE @v_creation_date		datetime;		-- timezone에 따른 저장위해서

	-- 실행시간 확인용    
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();    
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'00:00';   

	/********************************************************************************
	* 임시테이블만들기
	********************************************************************************/
	IF OBJECT_ID('tempdb..#TblDynamic_SCP0009') IS NOT NULL	
		DROP TABLE #TblDynamic_SCP0009 

	CREATE TABLE #TblDynamic_SCP0009 (
		A	nvarchar(1),
		p_active_flag	nvarchar(1),
--chaan		p_division_id	nvarchar(2),
		p_division_id	nvarchar(30),--chaan
		p_plan_start_yyyymmdd	nvarchar(8),
		p_plan_type	nvarchar(2),
		p_seq	nvarchar(10),
		p_biz_type	nvarchar(1),
		p_project_code	nvarchar(100),
		p_item_id	nvarchar(100),
		p_to_site	nvarchar(100),
		p_incoterms	nvarchar(20),
		p_from_site	nvarchar(50),
		p_bod_id	nvarchar(50),
		p_measure	nvarchar(100),
		p_yyyymmdd	nvarchar(8),
		p_qty	nvarchar(200),
--chaan		p_origin_from_division_id	nvarchar(2),
		p_origin_from_division_id	nvarchar(30),--chaan
--chaan		p_origin_to_division_id	nvarchar(2),
		p_origin_to_division_id	nvarchar(30),--chaan
		p_electrode_type	nvarchar(50),
		p_created_by	nvarchar(150),
		p_last_updated_by	nvarchar(150),
		p_time_zone	nvarchar(100),
		p_cplt_flag				nvarchar(1)
	);

	-- 트렌젝션 시작
	BEGIN TRAN;
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
								FROM @SCP0009  
								)
			;
			IF (@v_time_zone=NULL OR @v_time_zone='')
				SET @v_time_zone = 'AS054'
			;

			SET @v_creation_date    = [dbo].[FN_MULTY_TIME](@v_time_zone); 

			-- 임시테이블 데이타 생성
			INSERT INTO #TblDynamic_SCP0009
			SELECT A,
					p_active_flag,
					p_division_id,
					p_plan_start_yyyymmdd,
					p_plan_type,
					p_seq,
					p_biz_type,
					p_project_code,
					p_item_id,
					p_to_site,
					p_incoterms,
					p_from_site,
					p_bod_id,
					p_measure,
					p_yyyymmdd,
					p_qty,
					p_origin_from_division_id,
					p_origin_to_division_id,
					p_electrode_type,
					p_created_by,
					p_last_updated_by,
					p_time_zone,
					''
			FROM @SCP0009

			--수정 Row
			SET @max_loop_cnt = convert(nvarchar(50), ISNULL((
									SELECT COUNT(*) 
									FROM #TblDynamic_SCP0009  
								  ),0))
			;

			-- 1. 수정수량 UPDATE
			UPDATE A
			SET A.QTY = cast(round (cast(B.p_qty as numeric(20,10)), 0 ,1) as int)
				--A.QTY = cast(B.p_qty as int)
				, a.LAST_UPDATE_DATE = @v_creation_date
				, a.LAST_UPDATED_BY = B.p_last_updated_by
			FROM SCP_ANL_SHIPMENT_PLAN_FG A, #TblDynamic_SCP0009 B
			WHERE A.DIVISION_ID				= B.p_division_id          
			AND A.PLAN_START_YYYYMMDD		= B.p_plan_start_yyyymmdd
			AND A.PLAN_TYPE					= B.p_plan_type
			AND A.SEQ						= B.p_seq
			AND A.BIZ_TYPE					= B.p_biz_type
			AND A.PROJECT_CODE				= B.p_project_code
			AND A.ITEM_ID					= B.p_item_id
			AND A.TO_SITE					= B.p_to_site
			AND A.INCOTERMS					= B.p_incoterms
			AND A.FROM_SITE					= B.p_from_site
			AND A.BOD_ID					= B.p_bod_id
			AND A.MEASURE					= B.p_measure
			AND A.YYYYMMDD					= B.p_yyyymmdd
			AND A.ORIGIN_FROM_DIVISION_ID	= B.p_origin_from_division_id
			AND A.ORIGIN_TO_DIVISION_ID		= B.p_origin_to_division_id
			AND A.ELECTRODE_TYPE			= B.p_electrode_type
			AND B.p_active_flag IN ('M', 'I')


			UPDATE B
			SET B.p_cplt_flag = 'Y'
			FROM SCP_ANL_SHIPMENT_PLAN_FG A, #TblDynamic_SCP0009 B
			WHERE A.DIVISION_ID				= B.p_division_id          
			AND A.PLAN_START_YYYYMMDD		= B.p_plan_start_yyyymmdd
			AND A.PLAN_TYPE					= B.p_plan_type
			AND A.SEQ						= B.p_seq
			AND A.BIZ_TYPE					= B.p_biz_type
			AND A.PROJECT_CODE				= B.p_project_code
			AND A.ITEM_ID					= B.p_item_id
			AND A.TO_SITE					= B.p_to_site
			AND A.INCOTERMS					= B.p_incoterms
			AND A.FROM_SITE					= B.p_from_site
			AND A.BOD_ID					= B.p_bod_id
			AND A.MEASURE					= B.p_measure
			AND A.YYYYMMDD					= B.p_yyyymmdd
			AND A.ORIGIN_FROM_DIVISION_ID	= B.p_origin_from_division_id
			AND A.ORIGIN_TO_DIVISION_ID		= B.p_origin_to_division_id
			AND A.ELECTRODE_TYPE			= B.p_electrode_type
			AND B.p_active_flag IN ('M', 'I')


			-- 2. 신규수량 INSERT
			INSERT INTO dbo.SCP_ANL_SHIPMENT_PLAN_FG
				(DIVISION_ID
				,PLAN_START_YYYYMMDD
				,PLAN_TYPE
				,SEQ
				,BIZ_TYPE
				,PROJECT_CODE
				,ITEM_ID
				,TO_SITE
				,INCOTERMS
				,FROM_SITE
				,BOD_ID
				,MEASURE
				,YYYYMMDD
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
					,p_biz_type		
					,p_project_code	
					,p_item_id		
					,p_to_site		
					,p_incoterms	
					,p_from_site	
					,p_bod_id		
					,p_measure
					,p_yyyymmdd		
					--,cast(p_qty as int)
					,cast(round (cast(p_qty as numeric(20,10)), 0 ,1) as int)
					,p_origin_from_division_id
					,p_origin_to_division_id
					,p_electrode_type
					,p_created_by
					,@v_creation_date
					,p_last_updated_by
					,@v_creation_date
			FROM #TblDynamic_SCP0009
			WHERE p_active_flag IN ('M', 'I')
			  AND ISNULL(p_cplt_flag,'')=''


			-- 3. 삭제수량 DELETE
			DELETE A
			FROM SCP_ANL_SHIPMENT_PLAN_FG A, #TblDynamic_SCP0009 B
			WHERE A.DIVISION_ID				= B.p_division_id
			AND A.PLAN_START_YYYYMMDD		= B.p_plan_start_yyyymmdd
			AND A.PLAN_TYPE					= B.p_plan_type
			AND A.SEQ						= B.p_seq
			AND A.BIZ_TYPE					= B.p_biz_type
			AND A.PROJECT_CODE				= B.p_project_code
			AND A.ITEM_ID					= B.p_item_id
			AND A.TO_SITE					= B.p_to_site
			AND A.INCOTERMS					= B.p_incoterms
			AND A.FROM_SITE					= B.p_from_site
			AND A.BOD_ID					= B.p_bod_id
			AND A.MEASURE					= B.p_measure
			AND A.YYYYMMDD					= B.p_yyyymmdd
			AND A.ORIGIN_FROM_DIVISION_ID	= B.p_origin_from_division_id
			AND A.ORIGIN_TO_DIVISION_ID		= B.p_origin_to_division_id
			AND A.ELECTRODE_TYPE			= B.p_electrode_type
			AND B.p_active_flag				= 'D'
		
			-- 4. FIX수량 UPDATE
			UPDATE A
			SET A.qty				= cast(round (cast(B.p_qty as numeric(20,10)), 0 ,1) as int)
				--A.qty				= cast(B.p_qty as int)
				,A.last_updated_by	= B.p_last_updated_by
				,A.last_update_date	= @v_creation_date
			FROM SCP_ANL_SHIPMENT_PLAN_FIX A, #TblDynamic_SCP0009 B
			WHERE A.division_id				= B.p_division_id
			and A.BIZ_TYPE					= B.p_biz_type
			and A.ITEM_ID					= B.p_item_id
			and A.TO_SITE					= B.p_to_site
			and A.FROM_SITE					= B.p_from_site
			and A.PROJECT_CODE				= B.p_project_code
			and A.INCOTERMS					= B.p_incoterms
			and A.BOD_ID					= B.p_bod_id
			and A.yyyymmdd					= B.p_yyyymmdd
			AND A.ORIGIN_FROM_DIVISION_ID	= B.p_origin_from_division_id
			AND A.ORIGIN_TO_DIVISION_ID		= B.p_origin_to_division_id
			AND ISNULL(NULLIF(A.ELECTRODE_TYPE,''),'-') = ISNULL(NULLIF(B.p_electrode_type,''),'-')

			-- 5. FIX이력저장
			EXEC [dbo].[PR_SCP_ANL_SHIPMENT_PLAN_FG_FIX_HIST_DATASET] @SCP0009
			
			-- 6. 이력저장
			EXEC [dbo].[PR_SCP_ANL_SHIPMENT_PLAN_FG_HIST_DATASET] @SCP0009

			commit;

		END

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
			if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리
						
			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			--IF @@TRANCOUNT > 0
			--  COMMIT WORK;

			-- error코드, errror 메시지 반환
			--SELECT 'F' AS result_code , 0 as result_cnt ;
			/*
			IF( @v_err_code IS NULL OR @v_err_code ='')
				SET @v_err_code= ERROR_NUMBER() ;
			IF( @v_err_message IS NULL OR @v_err_message ='') 
				SET @v_err_message=  ERROR_MESSAGE();
			*/
			   						
			/* 에러 메시지, 에러 데이터  반환   */
			/*
			SELECT  @v_err_code			AS err_code
				   ,@v_err_message		AS err_message
				   , error_line()
			; 
			*/

			-- error코드, errror 메시지 반환
			SELECT 'F' AS result_code, '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE() AS err_message ;

		END;
	END CATCH;

	IF OBJECT_ID('tempdb..#TblDynamic_SCP0009') IS NOT NULL	
		DROP TABLE #TblDynamic_SCP0009 

END

