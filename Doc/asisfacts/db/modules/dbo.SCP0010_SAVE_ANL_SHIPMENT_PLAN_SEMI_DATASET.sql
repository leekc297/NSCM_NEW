


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
 * 2025/11/11   hrkim			[PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 
 *								  : ESS 가상 사이트 계획을 매핑된 JV 사이트 계획으로 동기화 저장 (ESS 가상 -> JV Real 단방향 저장) 
 *									- @SCP0010를 @SCP0010_WITH_JV 변수로 대체하여 사용
 *									- TO Site 정보는 그대로 가져간다. (BOD_ID는 매핑이 안되면 '-')
 *								    - 2025.12.16 동기화 대상 데이터 from/to 사이트와 무관하게 origin from/to division_id 컬럼 division_id와 같은 값으로 저장(81_ST) : 김춘동 책임님 
 *								    - 2025.12.23 동기화 데이터 생성시 BOD_ID 매핑이 안되는 경우 ESS 가상 사이트 BOD_ID 유지 
 */

CREATE PROCEDURE [dbo].[SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_DATASET]
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

	DECLARE @SCP0010_WITH_JV	AS DBO.SCP0010;	-- [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : @SCP0010 + MI법인 가상 사이트에 매핑된 JV 출하계획 정보 담을 테이블 Type 변수

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
	BEGIN TRAN;
	BEGIN TRY
		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();

		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	
		------------------------------------------------------------------------------------------------------------------------------------------------------- 
		--### Start : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장) 
		-------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' JV/ESS scm site 매핑 정보 추출' 
		-------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#JV_ESS_SCM_SITE_MAP') IS NOT NULL DROP TABLE #JV_ESS_SCM_SITE_MAP;
		SELECT VP_COMPANY_ID
			  ,VP_DIVISION_ID
			  ,VP_SITE_ID
			  ,VP_PLANT_ID
			  ,VP_SCM_SITE_ID
			  ,RP_COMPANY_ID
			  ,RP_DIVISION_ID
			  ,RP_SITE_ID
			  ,RP_PLANT_ID
			  ,RP_SCM_SITE_ID
		 INTO #JV_ESS_SCM_SITE_MAP
		 FROM FN_GET_JV_REAL_ESS_VIRTUAL_SITE_MAP () 
		 WHERE 1=1;
		------------------------------------------------------------------------------------------------------------  
		print  convert(varchar(30), getdate(), 121) + N' DIVISION 주차별 최종 수행 Plan 버전 정보 ' 
		-- ESS 가상 라인 매핑 JV division의 동기화 대상 버전 정보 확인을 위한 데이터
		-- Final Plan은 수정 대상에서 제외 ? 
		------------------------------------------------------------------------------------------------------------  
		IF OBJECT_ID('TEMPDB..#DIVISION_LAST_PLAN_INFO') IS NOT NULL DROP TABLE #DIVISION_LAST_PLAN_INFO;
		;WITH SCP_PLAN_INFO AS (
			SELECT PD.DIVISION_ID
				 , PM.PLAN_NAME			AS PLAN_START_YYYYMMDD
				 , PD.PLAN_TYPE
				 , PD.PLAN_SEQ
				 , PM.HORIZON_END_DATE	
				 , PD.PLAN_STATUS
				 , PD.INPUT_START_DATE 
				 , ROW_NUMBER()	OVER (PARTITION BY PD.DIVISION_ID
												 , PM.PLAN_NAME
										 ORDER  BY CASE WHEN PD.PLAN_TYPE = 'PR' THEN 4
														WHEN PD.PLAN_TYPE = 'MA' THEN 3
														WHEN PD.PLAN_TYPE = 'SE' THEN 2
														WHEN PD.PLAN_TYPE = 'FN' THEN 1
														ELSE 0
												   END
												  ,PD.PLAN_SEQ DESC
												  ,PD.INPUT_START_DATE DESC ) AS RN
			 FROM SCM_MST_PLAN PM WITH(NOLOCK)
				  INNER JOIN SCM_MST_PLAN_DETAIL PD WITH(NOLOCK)
						  ON PD.DIVISION_ID = PM.DIVISION_ID
						 AND PD.PLAN_ID		= PM.PLAN_ID
						 AND PD.PLAN_STATUS	= 1
				  INNER JOIN SCM_MST_DIVISION DM WITH(NOLOCK)
						  ON DM.DIVISION_ID	= PM.DIVISION_ID 
						 AND DM.ATTRIBUTE3 != 'EE'
			WHERE 1=1 
			  AND PM.PLAN_CYCLE = 'WEEKLY'
			  AND PM.PLAN_NAME	>= CONVERT(NVARCHAR(8), DATEADD(DAY, -20, GETDATE()) , 112)
		)
		SELECT DIVISION_ID
			  ,PLAN_START_YYYYMMDD
			  ,PLAN_TYPE
			  ,PLAN_SEQ
			  ,HORIZON_END_DATE
			  ,PLAN_STATUS
			  ,INPUT_START_DATE
			  ,RN
		  INTO #DIVISION_LAST_PLAN_INFO
		 FROM SCP_PLAN_INFO
		WHERE 1=1
		  AND RN = 1 
		  AND PLAN_TYPE != 'FN' -- Final plan 대상에서 제외 
		  ;
		------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' BOD 및 BOD ITEM 정보' 
		------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#BOD_ITEM') IS NOT NULL DROP TABLE #BOD_ITEM
		;WITH BOD_ITEM AS ( 
			SELECT  BD.DIVISION_ID
				   ,BD.FROM_SITE
				   ,BD.TO_SITE
				   ,BD.INCOTERMS
				   ,BI.ITEM_ID
				   ,BD.BOD_ID
				   ,ROW_NUMBER() OVER (PARTITION BY BD.DIVISION_ID
												   ,BD.FROM_SITE
												   ,BD.TO_SITE
												   ,BD.INCOTERMS
												   ,BI.ITEM_ID
										   ORDER BY BD.PRIORITY 
												   ,BI.PRIORITY
												   ,BD.ATTRIBUTE3 DESC
												   ,BD.LAST_UPDATE_DATE DESC )	AS RN 
			  FROM SCP_MST_BOD BD WITH(NOLOCK)
				   INNER JOIN SCP_MST_BOD_ITEM BI WITH(NOLOCK)
						   ON BI.BOD_ID			= BD.BOD_ID
						  AND BI.VALID_YN		= 'Y'
						  AND BI.TO_YYYYMMDD	>= CONVERT(NVARCHAR(8), DATEADD(DAY, -7, GETDATE()) , 112)
			 WHERE 1=1
			   AND BD.ATTRIBUTE3 > CONVERT(NVARCHAR(8), DATEADD(DAY, -7, GETDATE()) , 112)
			   AND BD.VALID_YN	= 'Y'
			   AND EXISTS (SELECT TOP 1 'X'
							 FROM #JV_ESS_SCM_SITE_MAP SM 
							WHERE SM.RP_DIVISION_ID = BD.DIVISION_ID
							  AND SM.RP_SCM_SITE_ID	= BD.FROM_SITE )
		)
		SELECT DIVISION_ID
			  ,FROM_SITE
			  ,TO_SITE
			  ,INCOTERMS
			  ,ITEM_ID
			  ,BOD_ID
			  ,RN
		 INTO #BOD_ITEM
		 FROM BOD_ITEM 
		WHERE RN = 1 ;
		------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' 파마미터로 받은 데이터 @SCP0010_WITH_JV 변수에 추가' 
		-- ESS MI법인 -> JV 동기화 저장 (단방향 저장으로 가상 사이트에 매핑된 JV 사이트 데이터는 제외) 
		------------------------------------------------------------------------------------------------------------------
		INSERT INTO @SCP0010_WITH_JV (
			   A
			  ,P_ACTIVE_FLAG
			  ,P_DIVISION_ID
			  ,P_PLAN_START_YYYYMMDD
			  ,P_PLAN_TYPE
			  ,P_SEQ
			  ,P_BIZ_TYPE
			  ,P_OPERATION_GROUP
			  ,P_ITEM_ID
			  ,P_FROM_SITE
			  ,P_BOD_ID
			  ,P_MEASURE
			  ,P_YYYYMMDD
			  ,P_TO_SITE
			  ,P_QTY
			  ,P_ORIGIN_FROM_DIVISION_ID
			  ,P_ORIGIN_TO_DIVISION_ID
			  ,P_ELECTRODE_TYPE
			  ,P_FIX_REASON
			  ,P_CREATED_BY
			  ,P_LAST_UPDATED_BY
			  ,P_TIME_ZONE
			  ,P_BUCKET_TYPE
			  ,P_TRANS_MODE
			  ,DEBUG_MODE  )
		SELECT PR.A
			  ,PR.P_ACTIVE_FLAG
			  ,PR.P_DIVISION_ID
			  ,PR.P_PLAN_START_YYYYMMDD
			  ,PR.P_PLAN_TYPE
			  ,PR.P_SEQ
			  ,PR.P_BIZ_TYPE
			  ,PR.P_OPERATION_GROUP
			  ,PR.P_ITEM_ID
			  ,PR.P_FROM_SITE
			  ,PR.P_BOD_ID
			  ,PR.P_MEASURE
			  ,PR.P_YYYYMMDD
			  ,PR.P_TO_SITE
			  ,PR.P_QTY
			  ,PR.P_ORIGIN_FROM_DIVISION_ID
			  ,PR.P_ORIGIN_TO_DIVISION_ID
			  ,PR.P_ELECTRODE_TYPE
			  ,PR.P_FIX_REASON
			  ,PR.P_CREATED_BY
			  ,PR.P_LAST_UPDATED_BY
			  ,PR.P_TIME_ZONE
			  ,PR.P_BUCKET_TYPE
			  ,PR.P_TRANS_MODE
			  ,PR.DEBUG_MODE
		 FROM @SCP0010 PR
		-- 2025.11.24 주석처리 (JV 자동차 계획할 수 있음) 	  LEFT JOIN #JV_ESS_SCM_SITE_MAP SM
		-- 2025.11.24 주석처리 (JV 자동차 계획할 수 있음) 		     ON SM.RP_DIVISION_ID	= PR.P_DIVISION_ID
		-- 2025.11.24 주석처리 (JV 자동차 계획할 수 있음) 		    AND SM.RP_SCM_SITE_ID	= PR.P_FROM_SITE
		-- 2025.11.24 주석처리 (JV 자동차 계획할 수 있음) WHERE SM.RP_DIVISION_ID IS NULL  --- 가상 사이트에 매핑된 JV 사이트 데이터는 제외
		;
		------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' 가상 사이트에 매핑된 JV 사이트 데이터 @SCP0010_WITH_JV 변수에 추가' 
		-- ESS MI법인 -> JV 동기화 저장 (단방향 저장으로 가상 사이트에 매핑된 JV 사이트 데이터는 제외) 
		------------------------------------------------------------------------------------------------------------------
		INSERT INTO @SCP0010_WITH_JV (
			   A
			  ,P_ACTIVE_FLAG
			  ,P_DIVISION_ID
			  ,P_PLAN_START_YYYYMMDD
			  ,P_PLAN_TYPE
			  ,P_SEQ
			  ,P_BIZ_TYPE
			  ,P_OPERATION_GROUP
			  ,P_ITEM_ID
			  ,P_FROM_SITE
			  ,P_BOD_ID
			  ,P_MEASURE
			  ,P_YYYYMMDD
			  ,P_TO_SITE
			  ,P_QTY
			  ,P_ORIGIN_FROM_DIVISION_ID
			  ,P_ORIGIN_TO_DIVISION_ID
			  ,P_ELECTRODE_TYPE
			  ,P_FIX_REASON
			  ,P_CREATED_BY
			  ,P_LAST_UPDATED_BY
			  ,P_TIME_ZONE
			  ,P_BUCKET_TYPE
			  ,P_TRANS_MODE
			  ,DEBUG_MODE  )
		SELECT PR.A
			  ,PR.P_ACTIVE_FLAG
			  ,SM.RP_DIVISION_ID			AS P_DIVISION_ID
			  ,PR.P_PLAN_START_YYYYMMDD
			  ,PV.PLAN_TYPE					AS P_PLAN_TYPE
			  ,PV.PLAN_SEQ					AS P_SEQ
			  ,PR.P_BIZ_TYPE
			  ,PR.P_OPERATION_GROUP
			  ,PR.P_ITEM_ID
			  ,SM.RP_SCM_SITE_ID								AS P_FROM_SITE
			  ,ISNULL(ISNULL(BI.BOD_ID, PR.P_BOD_ID), '-')		AS P_BOD_ID			-- 2025.12.23 bod_id 매핑이 안되는 경우 ESS가상 사이트 기준 BOD_ID 유지	
			  ,PR.P_MEASURE
			  ,PR.P_YYYYMMDD
			  ,PR.P_TO_SITE
			  ,PR.P_QTY
			  ,SM.RP_DIVISION_ID			AS P_ORIGIN_FROM_DIVISION_ID
			  ,SM.RP_DIVISION_ID			AS P_ORIGIN_TO_DIVISION_ID		-- 2025.12.16 division_id와 같은 값으로 
			  ,PR.P_ELECTRODE_TYPE
			  ,PR.P_FIX_REASON
			  ,PR.P_CREATED_BY
			  ,PR.P_LAST_UPDATED_BY
			  ,PR.P_TIME_ZONE
			  ,PR.P_BUCKET_TYPE
			  ,PR.P_TRANS_MODE
			  ,PR.DEBUG_MODE
		 FROM @SCP0010 PR
			  INNER JOIN #JV_ESS_SCM_SITE_MAP SM
				      ON SM.VP_DIVISION_ID	= PR.P_DIVISION_ID
				     AND SM.VP_SCM_SITE_ID	= PR.P_FROM_SITE
			  INNER JOIN #DIVISION_LAST_PLAN_INFO PV				-- 수정할 대상 버전이 있어야 수정 (FN 까지 완료된 경우 수정하지 않음) 
					  ON PV.DIVISION_ID			= SM.RP_DIVISION_ID
					 AND PV.PLAN_START_YYYYMMDD	= PR.P_PLAN_START_YYYYMMDD
			  LEFT  JOIN SCP_MST_BOD BO WITH(NOLOCK)
					  ON BO.BOD_ID = PR.P_BOD_ID
			  LEFT  JOIN #BOD_ITEM BI
					  ON BI.DIVISION_ID		= SM.RP_DIVISION_ID
					 AND BI.FROM_SITE		= SM.RP_SCM_SITE_ID
					 AND BI.TO_SITE			= PR.P_TO_SITE
					 AND BI.INCOTERMS		= BO.INCOTERMS
					 AND BI.ITEM_ID			= PR.P_ITEM_ID 
		WHERE 1=1
		;
		------------------------------------------------------------------------------------------------------------------------------------------------------- 
		--### End : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장) 
		-------------------------------------------------------------------------------------------------------------------------------------------------------

		BEGIN    
			--TimeZone set
			SET @v_time_zone = (SELECT TOP 1 p_time_zone
								FROM @SCP0010_WITH_JV  -- PJ2025F254 : @SCP0010를 @SCP0010_WITH_JV 변수로 대체하여 사용
								)
			;
			IF (@v_time_zone=NULL OR @v_time_zone='')
				SET @v_time_zone = 'AS054'
			;

			SET @v_creation_date    = [dbo].[FN_MULTY_TIME](@v_time_zone); 


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
			FROM @SCP0010_WITH_JV  -- PJ2025F254 : @SCP0010를 @SCP0010_WITH_JV 변수로 대체하여 사용

			--수정 Row
			SET @max_loop_cnt = convert(nvarchar(50), ISNULL((
									SELECT COUNT(*) 
									FROM #TblDynamic_SCP0010  
								  ),0))
			;

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
			AND A.ELECTRODE_TYPE			= B.p_electrode_type
			AND A.MEASURE					= B.p_measure
			AND A.YYYYMMDD					= B.p_yyyymmdd
			AND B.p_active_flag IN ('M', 'I')
			;

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
			AND A.ELECTRODE_TYPE			= B.p_electrode_type
			AND A.MEASURE					= B.p_measure
			AND A.YYYYMMDD					= B.p_yyyymmdd
			AND B.p_active_flag IN ('M', 'I')
			;

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

			-- 5. FIX이력저장
			EXEC [dbo].[PR_SCP_ANL_SHIPMENT_PLAN_SEMI_FIX_HIST_DATASET] @SCP0010_WITH_JV  -- PJ2025F254 : @SCP0010를 @SCP0010_WITH_JV 변수로 대체하여 사용

			-- 6. 이력저장
			EXEC [dbo].[PR_SCP_ANL_SHIPMENT_PLAN_SEMI_HIST_DATASET] @SCP0010_WITH_JV  -- PJ2025F254 : @SCP0010를 @SCP0010_WITH_JV 변수로 대체하여 사용

			commit;

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
			if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리
						
			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			-- error코드, errror 메시지 반환
			SELECT 'F' AS result_code, '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE() AS err_message ;

		END;
	END CATCH;
end;

