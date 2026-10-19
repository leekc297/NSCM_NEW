

/*
 * Program ID   : SCP0099_SAVE_LONGTERM_PLAN_COPY
 * Description  : 중장기 계획 COPY
 *				 Source       : SCP_PLN_RTF_ALLOCATION_V
 *								SCP_ANL_PRODUCTION_PLAN				
 *				 Target Table : SCP_ANL_BUSINESS_PLAN_RTF
 *								SCP_ANL_BUSINESS_PLAN_PROD
 * Program History
 *===================================================================================================
 *   Date       In Charge	Description
 *===================================================================================================
 * 2023.08.22	hrkim		Initial Release   PJ20230692 SCM 역량 강화 위한 SCP 개선과제 이행 Phase2
 * 2023.08.29	hrkim		PJ20230692 SCM 역량 강화 위한 SCP 개선과제 이행 Phase2 - RTF 전극 생산 사이트별 분배
 * 2023.09.08	hrkim		최종 출하 모델(셀/팩) 생산사이트 매핑 로직 변경 
 *							- 변경전 : ALLOCATION의 PLANT_SITE_ID
 *							- 변경후 : Delivery Order의 FROM_SITE_ID
 * 2023.10.13	hrkim		RTF eng_demand_id의 org eng_demand_id 조회 쿼리 변경 
 */

CREATE PROCEDURE [dbo].[SCP0099_SAVE_LONGTERM_PLAN_COPY]
	 @p_division_id			NVARCHAR(60)	= ''
	,@p_plan_start_yyyymmdd	NVARCHAR(8)		= ''
	,@p_plan_type			NVARCHAR(50)	= ''
	,@p_plan_seq			INT				= 1 
	,@p_plan_id				NVARCHAR(50)	= ''
	,@p_user_id				NVARCHAR(50)	= '' 

AS
BEGIN

    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

	-- 변수 
	DECLARE @v_scp_plan_id			NVARCHAR(50)    = NULL;
	DECLARE @v_eng_plan_id			NVARCHAR(50)    = NULL;
	DECLARE @v_master_id			NVARCHAR(50)	= @p_division_id + '::WEEKLY'
	DECLARE @v_START_YYYYMM			NVARCHAR(6)		= NULL
	DECLARE @v_END_YYYYMM			NVARCHAR(6)		= NULL
	DECLARE @v_prod_result_cnt		INT				= 0
	DECLARE @v_rtf_result_cnt		INT				= 0

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0099_SAVE_LONGTERM_PLAN_COPY'; --Proc별 이름 설정
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @v_batch_user   NVARCHAR(150) = ISNULL(@p_user_id, ''); 

	-- 임시 실행시간 확인용              
    DECLARE @v_start_time   DATETIME		= SYSDATETIME();              
    DECLARE @v_exec_time    NVARCHAR(10)	= ''	--'[00:00]';    

	BEGIN TRY
		BEGIN

			----------------------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' ### eng plan id 정보 ' 
			----------------------------------------------------------------------------------------------------------------------------------------------------------
			-- eng plan id 정보 조회 
			SELECT @v_eng_plan_id = PM.PLAN_ID + '::' + @p_plan_type + '::' + CONVERT(NVARCHAR(10), @p_plan_seq)
				  ,@v_scp_plan_id = PM.PLAN_ID
			 FROM SCM_MST_PLAN PM WITH(NOLOCK)
			WHERE 1=1
			  AND PM.DIVISION_ID = @p_division_id
			  AND PM.PLAN_CYCLE	 = 'WEEKLY'
			  AND PM.PLAN_NAME	 = @p_plan_start_yyyymmdd	

			---------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' ### BUSINESS PLAN 기간 정보 ' 
			---------------------------------------------------------------------------------------
			SELECT @v_START_YYYYMM	= SUBSTRING(BP.PLAN_START_DATE, 1, 6) 
				  ,@v_END_YYYYMM	= SUBSTRING(BP.PLAN_END_DATE  , 1, 6) 
			 FROM SCP_ANL_BUSINESS_PLAN_INFO BP WITH(NOLOCK)
			WHERE BP.DIVISION_ID	= @p_division_id
			  AND BP.PLAN_ID		= @p_plan_id
			  AND BP.VALID_YN		= 'Y'

			print '--------------------------------------------------------------------------------'
			print '@p_division_id			: ' + @p_division_id
			print '@p_plan_start_yyyymmdd	: ' + @p_plan_start_yyyymmdd
			print '@p_plan_type				: ' + @p_plan_type
			print '@p_plan_seq				: ' + convert(nvarchar(10), @p_plan_seq)
			print '@v_START_YYYYMM			: ' + @v_START_YYYYMM
			print '@v_END_YYYYMM			: ' + @v_END_YYYYMM
			print '@p_plan_id				: ' + @p_plan_id
			print '@v_eng_plan_id			: ' + @v_eng_plan_id
			print '@v_master_id			    : ' + @v_master_id
			print '--------------------------------------------------------------------------------'


			IF @v_START_YYYYMM IS NULL OR  @v_END_YYYYMM IS NULL OR @v_eng_plan_id IS NULL
				BEGIN
					PRINT '@v_START_YYYYMM IS NULL OR  @v_END_YYYYMM IS NULL OR @v_eng_plan_id IS NULL';

					-- error코드, errror 메시지 반환
					SELECT 'F'					AS result_code
						  , 0					AS result_cnt
						  , 'check parameters'	AS result_message;

					RETURN 9;
				END 

			-- 시작 LOG  (START)
			SET @v_log_type = 'START';
			SET @v_log_message = '##### Start of procedure #####';     
			SET @v_description = '['+ @p_division_id + '::' + @p_plan_id + ']';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @p_user_id;
			SET @v_log_message = NULL 

			---------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' ### 대상 기간 월 목록' 
			---------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#TMP_DATE_LIST') IS NOT NULL 
				DROP TABLE #TMP_DATE_LIST;

			SELECT B.YYYYMMDD
				  ,B.YYYYMM
				  ,DENSE_RANK() OVER (ORDER BY B.YYYYMM) AS MM_SEQ 
			 INTO #TMP_DATE_LIST
			 FROM SCM_MST_BUCKET B	WITH(NOLOCK)
			WHERE B.YYYYMM BETWEEN @v_START_YYYYMM
							   AND @v_END_YYYYMM
			ORDER BY B.YYYYMMDD 

			---------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' ### Item Master Info ' 
			---------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#TMP_ITEM_INFO') IS NOT NULL
				DROP TABLE #TMP_ITEM_INFO;
	
			SELECT II.ITEM_ID
				 , MAX(II.SCP_OPERATION_GROUP)	AS OPERATION_GROUP
				 , MAX(II.ITEM_CLASS		 )	AS ITEM_CLASS		  
				 , MAX(II.ITEM_CLASS_NAME	 )	AS ITEM_CLASS_NAME	
				 , MAX(II.NICK_NAME			 )	AS ITEM_NICK_NAME
				 , CASE WHEN MAX(II.SCP_OPERATION_GROUP) = 'E'
						THEN MAX(II.ITEM_UOM)	
						ELSE 'EA'
				   END  AS ITEM_UOM
			 INTO #TMP_ITEM_INFO
			  FROM SCM_MST_ITEM_SN II WITH(NOLOCK) 
			WHERE 1=1 
			  AND II.DIVISION_ID	= CASE WHEN @p_division_id LIKE  'EE%'
										   THEN II.DIVISION_ID
										   ELSE @p_division_id
									  END 
			  AND II.SCP_OPERATION_GROUP IS NOT NULL  
			GROUP BY II.ITEM_ID

			----------------------------------------------------------------------------------------------------------------------------- 전극 사이트 매핑을 위한 임시 정보 begin -----
			-----------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' ###  FInal 모델별 전극 모델 정보 추출 (임의 전극 하나 선택) ' 
			-----------------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#TMP_ELEC_ITEM_INFO') IS NOT NULL
				DROP TABLE #TMP_ELEC_ITEM_INFO;

			SELECT BI.DIVISION_ID
				  ,BI.MODEL_ID
				  ,MAX(BI.CHILD_ITEM_ID)	AS ELEC_ITEM_ID
			 INTO #TMP_ELEC_ITEM_INFO
			 FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V BI
			WHERE 1=1
			  AND BI.DIVISION_ID		= @p_division_id
			  AND BI.OPERATION_GROUP_ID = 'E'
			  AND BI.ELECTRODE_TYPE     = 'CATHODE'
			GROUP BY BI.DIVISION_ID
					,BI.MODEL_ID

			-----------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' ### 월별 양극재 생산 사이트 정보 - (For RTF 전극 사이트)  ' 
			-----------------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#TMP_ELEC_PROD_SITE') IS NOT NULL
				DROP TABLE #TMP_ELEC_PROD_SITE;

			;WITH ELEC_PLAN_INFO AS (
				SELECT TOP 1
					   PD.DIVISION_ID	AS  ELEC_DIVISION_ID
					  ,PD.PLAN_SEQ 
				 FROM SCM_MST_DIVISION DM WITH(NOLOCK)
					  INNER JOIN SCM_MST_DIVISION ED WITH(NOLOCK)
							   ON ED.ATTRIBUTE4		= DM.ATTRIBUTE4 -- 동일 회사 
							  AND ED.ATTRIBUTE3		= 'EE'			-- 전극 
					  INNER JOIN SCM_MST_PLAN_DETAIL PD WITH(NOLOCK)
							  ON PD.DIVISION_ID		= ED.DIVISION_ID
							 AND PD.PLAN_ID			= @v_scp_plan_id 
							 AND PD.PLAN_TYPE		= @p_plan_type 
							 AND PD.PLAN_STATUS		= '1'
							 AND PD.CONFIRM_FLAG	= 'Y'
				WHERE DM.DIVISION_ID = @p_division_id
				  AND DM.ATTRIBUTE3 != 'EE' -- copy 대상 사업부가 전극이 아닌 경우만! (전극은 RTF없음!)
				ORDER BY PD.PLAN_SEQ DESC	-- 최종 Plan 
			)
			SELECT SUBSTRING(PP.YYYYMMDD, 1, 6)																			AS YYYYMM
				  ,PP.ITEM_ID																							AS ELEC_ITEM_ID
				  -- 20230904 begin RTF 전극 사이트 생산 수량 비중으로 배분
				  ,PP.SCM_SITE_ID																						AS ELEC_PROD_SITE_ID
				  ,SUM(QTY)																								AS ELEC_ITEM_QTY																				
				  ,SUM(SUM(QTY))	OVER (PARTITION BY SUBSTRING(PP.YYYYMMDD, 1, 6)	,PP.ITEM_ID	)						AS	MM_ELEC_ITEM_TOT_QTY
				  ,CONVERT(NUMERIC(20,10), SUM(QTY))																	
				    / SUM(CONVERT(NUMERIC(20,10), SUM(QTY)))
									OVER (PARTITION BY SUBSTRING(PP.YYYYMMDD, 1, 6)	,PP.ITEM_ID	)						AS ELEC_SITE_RT 
				  ,ROW_NUMBER()		OVER (PARTITION BY SUBSTRING(PP.YYYYMMDD, 1, 6), PP.ITEM_ID ORDER BY SUM(QTY) DESC) AS ELEC_DESC_RNK
				  ,ROW_NUMBER()		OVER (PARTITION BY SUBSTRING(PP.YYYYMMDD, 1, 6), PP.ITEM_ID ORDER BY SUM(QTY) ASC)  AS ELEC_ASC_RNK
				  -- 20230904 end RTF 전극 사이트 생산 수량 비중으로 배분
				  -- 변경전,MAX(SCM_SITE_ID)				AS ELEC_PROD_SITE_ID
			 INTO #TMP_ELEC_PROD_SITE
			 FROM ELEC_PLAN_INFO EP WITH(NOLOCK)
				  INNER JOIN SCP_ANL_PRODUCTION_PLAN PP WITH(NOLOCK)
						 ON PP.DIVISION_ID			= EP.ELEC_DIVISION_ID -- 전극 division
						AND PP.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
						AND PP.PLAN_TYPE			= @p_plan_type
						AND PP.SEQ					= EP.PLAN_SEQ
						AND PP.MEASURE				= 'PROD_PLAN_AMEND'
				  INNER JOIN SCP_MST_FINAL_ITEM_V FI WITH(NOLOCK)
						  ON FI.ITEM_ID			= PP.ITEM_ID
						 AND FI.OPERATION_GROUP	= 'E'
						 AND FI.ELECTRODE_TYPE	= 'CATHODE'
			WHERE 1=1
			  AND PP.QTY != 0 
			GROUP BY SUBSTRING(PP.YYYYMMDD, 1, 6)
					,PP.ITEM_ID
					,PP.SCM_SITE_ID	 

			-----------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' ### Model Allocation (For RTF 전극 사이트)  ' 
			-----------------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#TMP_MODEL_ALLOCATION') IS NOT NULL
				DROP TABLE #TMP_MODEL_ALLOCATION;

			SELECT MA.DIVISION_ID
				  ,MA.CELL_PLANT_SITE_ID
				  ,MA.CELL_ITEM_ID
				  ,MAX(ELEC_PLANT_SITE_ID)  AS ELEC_PLANT_SITE_ID
			 INTO #TMP_MODEL_ALLOCATION
			 FROM SCP_MST_MODEL_ALLOCATION MA WITH(NOLOCK)
			WHERE 1=1
			  AND MA.DIVISION_ID	= @p_division_id
			  AND MA.YYYYMMDD		= @p_plan_start_yyyymmdd 
			  AND MA.VALID_YN		= 'Y'
			GROUP BY MA.DIVISION_ID
					,MA.CELL_PLANT_SITE_ID
					,MA.CELL_ITEM_ID

			-----------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' ### Project Route (For RTF 전극 사이트)   ' 
			-----------------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#TMP_SITE_ITEM_PRIORITY') IS NOT NULL
				DROP TABLE #TMP_SITE_ITEM_PRIORITY;

			;WITH SITE_ITEM_PRIORITY AS ( 
				SELECT  SI.ITEM_ID				AS ELEC_ITEM_ID 
					  , SI.FROM_YYYYMMDD
					  , SI.TO_YYYYMMDD
					  , SI.PLANT_SITE_ID
					  , ROW_NUMBER()   OVER (PARTITION BY SI.ITEM_ID
												 ORDER BY SI.PRIORITY
														 ,SI.TO_YYYYMMDD DESC
														 ,SI.FROM_YYYYMMDD ) AS SITE_PRIORITY

				 FROM SCM_MST_SITE_ITEM_PRIORITY SI  WITH(NOLOCK)
					  INNER JOIN SCP_MST_FINAL_ITEM_V FI WITH(NOLOCK)
							  ON FI.ITEM_ID			= SI.ITEM_ID
							 AND FI.OPERATION_GROUP	= 'E'
				WHERE 1=1
				  AND SI.VALID_YN = 'Y'
				  AND @p_plan_start_yyyymmdd between SI.FROM_YYYYMMDD AND SI.TO_YYYYMMDD
			)
			SELECT *
			 INTO #TMP_SITE_ITEM_PRIORITY
			 FROM SITE_ITEM_PRIORITY 
			WHERE SITE_PRIORITY = 1 

			-----------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' ### from 전극 plant -> To Cell Plant BOD 정보 (For RTF 전극 사이트)   ' 
			-----------------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#TMP_BOD') IS NOT NULL
				DROP TABLE #TMP_BOD;

			SELECT B.DIVISION_ID
				  ,B.TO_SITE
				  ,B.FROM_SITE
				  ,ROW_NUMBER() OVER (PARTITION BY B.DIVISION_ID
												  ,B.TO_SITE
										  ORDER BY FS.OSP_YN 
												  ,CASE WHEN FS.COMPANY_ID = TS.COMPANY_ID
														THEN 1
														ELSE 2
												   END
												  ,B.FROM_SITE DESC ) AS FROM_SITE_PRIORITY
			INTO #TMP_BOD
			FROM SCP_MST_BOD B WITH(NOLOCK)
				 INNER JOIN SCM_MST_SITE TS WITH(NOLOCK)
						 ON TS.DIVISION_ID		= B.DIVISION_ID
						AND TS.SCM_SITE_ID		= B.TO_SITE
						AND TS.SITE_TYPE		= 'PLANT'
						AND TS.OPERATION_GROUP	= 'A'
				 INNER JOIN SCM_MST_SITE FS WITH(NOLOCK)
						 ON FS.DIVISION_ID		= B.DIVISION_ID
						AND FS.SCM_SITE_ID		= B.FROM_SITE
						AND FS.SITE_TYPE		= 'PLANT'
						AND FS.OPERATION_GROUP	= 'E'
			WHERE 1=1
			  AND B.DIVISION_ID = @p_division_id
			  AND B.VALID_YN	= 'Y'
			----------------------------------------------------------------------------------------------------------------------------- 전극 사이트 매핑을 위한 임시 정보 end -----

			-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' ### 모델 하위 CP(Cell Product) 또는 CA(Cell Assay) 품목 참조를 위한 엔진 BOM Base Data' 
			-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			IF  OBJECT_ID('tempdb..#ENG_BOM_BASE_DATA')  IS NOT NULL
				DROP TABLE #ENG_BOM_BASE_DATA ; 

			SELECT DISTINCT
				   B.MASTER_ID
				  ,B.PARENT_ITEM_ID
				  ,B.CHILD_ITEM_ID
			 INTO #ENG_BOM_BASE_DATA
			 FROM TH_ENG_PLAN_BOM_SN B WITH(NOLOCK) 
			WHERE 1=1
			  AND MASTER_ID = @v_master_id
			  AND PLAN_ID   = @v_eng_plan_id

			-- index 생성 
			CREATE NONCLUSTERED INDEX tmp_idx_1 on #ENG_BOM_BASE_DATA (PARENT_ITEM_ID, CHILD_ITEM_ID) ;
												
			-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N'### 모델 하위 CP(Cell Product) 또는 CA(Cell Assay) 품목 참조를 위한 엔진 BOM : Model - Child 매핑정보' 
			-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			IF  OBJECT_ID('tempdb..#ENG_BOM_TREE_MODEL')  IS NOT NULL 
				DROP TABLE #ENG_BOM_TREE_MODEL;

			;WITH TREE_MODEL AS (
				SELECT  1					AS NLEVEL 
					   ,BD.PARENT_ITEM_ID	AS MODEL_ID 
					   ,BD.PARENT_ITEM_ID
					   ,BD.CHILD_ITEM_ID
					   ,CONVERT(NVARCHAR(4000), CONCAT(BD.PARENT_ITEM_ID  , '^' , BD.CHILD_ITEM_ID))	AS CONCATENATE_ITEM 
					FROM #ENG_BOM_BASE_DATA  BD
					WHERE 1=1
				UNION ALL 
				SELECT  P.NLEVEL+1			AS NLEVEL 
					   ,P.MODEL_ID
					   ,C.PARENT_ITEM_ID
					   ,C.CHILD_ITEM_ID
					   ,CONVERT(NVARCHAR(4000), CONCAT(P.CONCATENATE_ITEM  , '^' , C.CHILD_ITEM_ID) )	AS CONCATENATE_ITEM 
					FROM TREE_MODEL P
						 INNER JOIN #ENG_BOM_BASE_DATA C
								 ON C.PARENT_ITEM_ID = P.CHILD_ITEM_ID
					WHERE 1=1
			), DISTINCT_TREE_MODEL AS (
				SELECT DISTINCT 
					   T.NLEVEL
					  ,T.MODEL_ID
					  --,T.PARENT_ITEM_ID
					  ,T.CHILD_ITEM_ID
					 -- ,T.CONCATENATE_ITEM
					  ,FP.OPERATION_GROUP	AS PARENT_OPERATION_GROUP
				FROM TREE_MODEL T
					  LEFT JOIN #TMP_ITEM_INFO	 FP WITH(NOLOCK)	-- parent (pack) 
							 ON FP.ITEM_ID	   = T.PARENT_ITEM_ID
				WHERE 1=1
				  AND EXISTS (SELECT TOP 1 *
							   FROM TH_ENG_NET_DEMAND_SN DM WITH(NOLOCK)  -- Demand가 존재하는 모델들만 
							  WHERE 1=1
								AND DM.MASTER_ID	= @v_master_id
								AND DM.PLAN_ID		= @v_eng_plan_id
								AND DM.ITEM		    = T.MODEL_ID)
			)
			SELECT  
				   T.NLEVEL
				  ,T.MODEL_ID
				  ,T.CHILD_ITEM_ID
				  ,T.PARENT_OPERATION_GROUP
				  ,FM.OPERATION_GROUP		AS MODEL_OPERATION_GROUP
				  ,FM.ATTRIBUTE8			AS MODEL_CELL_TYPE
				  ,FM.FLOW_ID				AS MODEL_FLOW_ID
				  ,FC.OPERATION_GROUP		AS CHILD_OPERATION_GROUP
				  ,FC.ATTRIBUTE8			AS CHILD_CELL_TYPE
				  ,FC.FLOW_ID				AS CHILD_FLOW_ID
				  ,MIN(T.NLEVEL) OVER (PARTITION BY T.MODEL_ID
												  , FC.OPERATION_GROUP) AS MIN_FC_OP_NLEVEL
				  ,MAX(T.NLEVEL) OVER (PARTITION BY T.MODEL_ID
												  , FC.OPERATION_GROUP) AS MAX_FC_OP_NLEVEL
			 INTO #ENG_BOM_TREE_MODEL
			 FROM DISTINCT_TREE_MODEL T
				  INNER JOIN SCP_MST_FINAL_ITEM FM WITH(NOLOCK)	-- model 
						 ON FM.DIVISION_ID = @p_division_id
						AND FM.ITEM_ID	   = T.MODEL_ID
				  INNER JOIN SCP_MST_FINAL_ITEM FC WITH(NOLOCK)	-- child 
						 ON FC.DIVISION_ID = @p_division_id
						AND FC.ITEM_ID	   = T.CHILD_ITEM_ID
			WHERE 1=1
			Option (MaxRecursion 7)
			;

			-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' ### Delivery Order 정보 for 출하모델 생산사이트 참조를 위한 DO'   -- 20230908 추가 
			-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#TMP_ENG_DELIVERY_ORDER') IS NOT NULL
				DROP TABLE #TMP_ENG_DELIVERY_ORDER;

			-- 출하 계획
			SELECT  DO.TO_ITEM_ID
				  , DO.TO_DELIVERY_ORDER_ID
				  , MIN(SUBSTRING(DO.FROM_SITE_ID, 1, CHARINDEX('~' , DO.FROM_SITE_ID)  -1))	AS FROM_SITE  
			  INTO #TMP_ENG_DELIVERY_ORDER
			 FROM TH_EXP_PEGGING_INFO_SN  DO WITH(NOLOCK) 
			WHERE  1=1
			  AND DO.MASTER_ID		 = @v_master_id		
			  AND DO.PLAN_ID		 = @v_eng_plan_id	
			  AND DO.OUT_VERSION_ID  = @v_eng_plan_id   
			  AND DO.PEGGING_TYPE	 = 'DELIVERY_ORDER'		
			GROUP BY DO.TO_ITEM_ID
				   , DO.TO_DELIVERY_ORDER_ID

			-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N'###  SCP RTF(ALLOCATION) RAW DATA'  -- 20230911 추가 Raw 데이터 참조와 집계 단계 분리
			-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#TMP_ALLOCATION_RAW') IS NOT NULL
				DROP TABLE #TMP_ALLOCATION_RAW;

			SELECT RA.DIVISION_ID
				  ,RA.SALES_SITE_ID
				  ,CASE WHEN RA.OPERATION_GROUP = 'A' THEN 'Cell'
						WHEN RA.OPERATION_GROUP = 'P' THEN 'Pack'
						ELSE RA.OPERATION_GROUP
					END											AS BIZ_TYPE
				  ,RA.PROJECT_CODE
				  ,RA.ITEM_ID
				  ,RA.INCOTERMS 
				  ,RA.ALLOCATION_QTY
				  ,DO.FROM_SITE									AS DO_FROM_SITE
				  ,CASE WHEN RA.ENG_DEMAND_ID NOT LIKE '%^S%'				AND  isNumeric(RIGHT(RA.ENG_DEMAND_ID, 1)) = 1		AND RA.ENG_DEMAND_ID	 LIKE '%#%'  	-- 20231013 납기 지연으로 split된 케이스 조건 변경 
					    THEN SUBSTRING(RA.ENG_DEMAND_ID,1, CHARINDEX('#',RA.ENG_DEMAND_ID)-1)
					    WHEN RA.ENG_DEMAND_ID	  LIKE '%^S___________'		AND  isNumeric(RIGHT(RA.ENG_DEMAND_ID, 1)) = 1		AND RA.ENG_DEMAND_ID NOT LIKE '%#%' 	-- 20231013 납기 지연으로 split된 케이스 추가
					    THEN SUBSTRING(RA.ENG_DEMAND_ID,1, LEN(RA.ENG_DEMAND_ID)-13)
					    WHEN RA.ENG_DEMAND_ID	  LIKE '%^S______________'	AND  isNumeric(RIGHT(RA.ENG_DEMAND_ID, 1)) = 1		AND RA.ENG_DEMAND_ID	 LIKE '%#%' 	-- 20231013 납기 지연으로 split된 케이스 추가
					    THEN SUBSTRING(RA.ENG_DEMAND_ID,1, LEN(RA.ENG_DEMAND_ID)-16)
					    ELSE RA.ENG_DEMAND_ID
					END											AS ENG_DEMAND_ID
				  ,DL.MM_SEQ
				  ,DL.YYYYMM
			 INTO #TMP_ALLOCATION_RAW 
			 FROM SCP_PLN_RTF_ALLOCATION_V RA WITH(NOLOCK) 
				  INNER JOIN #TMP_DATE_LIST DL WITH(NOLOCK)
						  ON DL.YYYYMMDD = RA.YYYYMMDD
				  LEFT	JOIN #TMP_ENG_DELIVERY_ORDER DO  -- 20230908 추가
						  ON DO.TO_ITEM_ID				= RA.ITEM_ID
						 AND DO.TO_DELIVERY_ORDER_ID	= ISNULL(RA.DELIVERY_ORDER_ID,'Z')
			WHERE 1=1
			  AND RA.DIVISION_ID			= @p_division_id
			  AND RA.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
			  AND RA.PLAN_TYPE				= @p_plan_type
			  AND RA.SEQ					= @p_plan_seq

			-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' ###  SCP RTF(ALLOCATION) BASE 정보' 
			-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#TMP_ALLOCATION_INFO') IS NOT NULL
				DROP TABLE #TMP_ALLOCATION_INFO;

			;WITH PROJECT_INFO AS (
				SELECT PM.DIVISION_ID
					 , PM.PROJECT_CODE
					 , MAX(PROJECT_NAME)		AS PROJECT_NAME 
				 FROM SCM_MST_PROJECT PM WITH(NOLOCK) 
				WHERE 1=1
				GROUP BY PM.DIVISION_ID, PM.PROJECT_CODE
			)
			SELECT RA.DIVISION_ID
				  ,RA.SALES_SITE_ID								AS SALES_SITE
				  ,RA.BIZ_TYPE
				  ,CASE WHEN TS.DIVISION_ID = '40'
						THEN RA.PROJECT_CODE 
						ELSE TS.END_CUSTOMER	
					END											AS CUST
				  ,RA.PROJECT_CODE								AS PROJECT
				  ,ISNULL(PM.PROJECT_NAME,	RA.PROJECT_CODE)	AS PROJECT_DESC
				  ,RA.ITEM_ID									AS MODEL_CODE
				  ,RA.INCOTERMS 
				  ,SUM(RA.ALLOCATION_QTY)						AS ALLOCATION_QTY -- 20230904 
				  ,RA.DO_FROM_SITE								AS PLANT_SITE_ID  -- 20230908 변경  
				  ,DM.DEMAND_ID
				  ,RA.MM_SEQ
				  ,RA.YYYYMM
			 INTO #TMP_ALLOCATION_INFO 
			 FROM #TMP_ALLOCATION_RAW RA WITH(NOLOCK) 
				  INNER JOIN SCM_MST_SITE TS WITH(NOLOCK) 
						  ON TS.DIVISION_ID		= RA.DIVISION_ID
						 AND TS.SCM_SITE_ID		= RA.SALES_SITE_ID
				  LEFT  JOIN TH_ENG_NET_DEMAND_SN DM WITH(NOLOCK)
	  				  ON DM.MASTER_ID		= @v_master_id
						 AND DM.PLAN_ID			= @v_eng_plan_id
						 AND DM.DEMAND_GROUP_ID = RA.ENG_DEMAND_ID 
				  LEFT  JOIN PROJECT_INFO PM WITH(NOLOCK)
						  ON PM.DIVISION_ID  = RA.DIVISION_ID
						 AND PM.PROJECT_CODE = RA.PROJECT_CODE
			WHERE 1=1
			GROUP BY 
				   RA.DIVISION_ID
				  ,RA.SALES_SITE_ID								
				  ,RA.BIZ_TYPE										
				  ,CASE WHEN TS.DIVISION_ID = '40'
						THEN RA.PROJECT_CODE 
						ELSE TS.END_CUSTOMER	
					END											
				  ,RA.PROJECT_CODE								
				  ,ISNULL(PM.PROJECT_NAME,	RA.PROJECT_CODE)	
				  ,RA.ITEM_ID									
				  ,RA.INCOTERMS 
				  ,RA.DO_FROM_SITE 
				  ,DM.DEMAND_ID
				  ,RA.MM_SEQ
				  ,RA.YYYYMM

			-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' ### Demand에 대한 Work Order 정보' 
			-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#TMP_DEMAND_WORK_ORDER') IS NOT NULL
				DROP TABLE #TMP_DEMAND_WORK_ORDER;

			-- 생산 계획
			SELECT  ORG_DEMAND_ID
				  , SUBSTRING(ORG_DEMAND_ID,1, CHARINDEX('::', ORG_DEMAND_ID)  -1)	AS MODEL_ID 
				  , SUBSTRING(TO_SITE_ID,   1, CHARINDEX('~' , TO_SITE_ID)  -1)		AS TO_SCM_SITE_ID 
				  , TO_ITEM_ID
				  , SUM(TO_REQUEST_QTY)												AS TO_REQUEST_QTY
			 INTO #TMP_DEMAND_WORK_ORDER
			 FROM TH_EXP_PEGGING_INFO_SN WITH(NOLOCK) 
			WHERE  1=1
			  AND MASTER_ID		 = @v_master_id		
			  AND PLAN_ID		 = @v_eng_plan_id	
			  AND OUT_VERSION_ID = @v_eng_plan_id   
			  AND PEGGING_TYPE	 = 'WORK_ORDER'		
			GROUP BY ORG_DEMAND_ID
					,SUBSTRING(TO_SITE_ID  , 1, CHARINDEX('~', TO_SITE_ID)-1)
					,TO_ITEM_ID

			-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' ###  팩 Demand 에 소요되는 cell(CP) 생산 사이트 정보 (#TMP_PACK_DEMAND_CELL_PROD_SITE)' 
			-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#TMP_PACK_DEMAND_CELL_PROD_SITE') IS NOT NULL
				DROP TABLE #TMP_PACK_DEMAND_CELL_PROD_SITE;

			SELECT DW.ORG_DEMAND_ID
				  ,DW.TO_SCM_SITE_ID
				  ,DW.TO_REQUEST_QTY
				  ,SUM(DW.TO_REQUEST_QTY) 
								OVER (PARTITION BY DW.ORG_DEMAND_ID)		AS TOT_TO_REQUEST_QTY 
				  ,DW.TO_REQUEST_QTY
				   / CONVERT(NUMERIC(20,10) ,SUM(DW.TO_REQUEST_QTY) 
								OVER (PARTITION BY DW.ORG_DEMAND_ID))		AS SITE_RATIO
				  ,ROW_NUMBER() OVER (PARTITION BY DW.ORG_DEMAND_ID
										  ORDER BY DW.TO_REQUEST_QTY DESC)	AS CELL_SITE_QTY_DESC_RNK   --- 20230904 
				  ,ROW_NUMBER() OVER (PARTITION BY DW.ORG_DEMAND_ID
										  ORDER BY DW.TO_REQUEST_QTY)		AS CELL_SITE_QTY_ASC_RNK	--- 20230904 
			 INTO #TMP_PACK_DEMAND_CELL_PROD_SITE
			 FROM #TMP_DEMAND_WORK_ORDER DW 
				  INNER JOIN #ENG_BOM_TREE_MODEL EB WITH(NOLOCK)
						 ON EB.PARENT_OPERATION_GROUP = 'P' 
						AND EB.CHILD_OPERATION_GROUP  = 'A'
						AND EB.MIN_FC_OP_NLEVEL       = EB.NLEVEL -- Pack에 투입되는 Cell 모델 (CP) 
						AND EB.CHILD_ITEM_ID		  = DW.TO_ITEM_ID
						AND EB.MODEL_ID				  = DW.MODEL_ID
			WHERE 1=1
			  AND DW.TO_REQUEST_QTY != 0
			ORDER BY DW.ORG_DEMAND_ID

			-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' ### Demand에 대한 Cell Assy 생산 사이트 정보 (#TMP_PACK_DEMAND_CA1_SITE)' 
			-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#TMP_PACK_DEMAND_CA1_SITE') IS NOT NULL
				DROP TABLE #TMP_PACK_DEMAND_CA1_SITE;

			SELECT  
				   DW.ORG_DEMAND_ID
				  ,EB.CHILD_ITEM_ID			AS CA_ITEM_ID
 				  ,MAX(DW.TO_SCM_SITE_ID)	AS CA_SITE_ID
			INTO #TMP_PACK_DEMAND_CA1_SITE
			 FROM #TMP_DEMAND_WORK_ORDER DW 
				  INNER JOIN #ENG_BOM_TREE_MODEL EB WITH(NOLOCK)
						 ON EB.PARENT_OPERATION_GROUP = 'A'  -- CP..?
						AND EB.CHILD_OPERATION_GROUP  = 'A'  -- CA 
						AND EB.MAX_FC_OP_NLEVEL       = EB.NLEVEL -- CA1 
						AND EB.CHILD_ITEM_ID		  = DW.TO_ITEM_ID
						AND EB.MODEL_ID				  = DW.MODEL_ID
			WHERE 1=1
			  AND DW.TO_REQUEST_QTY != 0
			GROUP BY DW.ORG_DEMAND_ID
					,EB.CHILD_ITEM_ID

			-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' ### 셀 생산 사이트별 RTF정보 - 셀생산 사이트 Cell 생산 계획수량 비율로 RTF 분배 (#TMP_RTF_FOR_CELL_SITE)' 
			-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('tempdb..#TMP_RTF_FOR_CELL_SITE') IS NOT NULL  
			   DROP TABLE #TMP_RTF_FOR_CELL_SITE;

			SELECT RF.*
				  ,CASE WHEN EB.CHILD_ITEM_ID IS NOT NULL
						THEN EB.CHILD_ITEM_ID 
						ELSE RF.MODEL_CODE
				   END AS CELL_CODE		-- CP  
				  ,FI.NICK_NAME		AS CELL_NICKNAME 
				  ,EB.PARENT_OPERATION_GROUP 
				  ,EB.CHILD_OPERATION_GROUP 
				  ,CASE WHEN RF.BIZ_TYPE = 'CELL'
						THEN RF.PLANT_SITE_ID
						ELSE CS.TO_SCM_SITE_ID	
					END AS CELL_SITE		-- Cell 생산 사이트  
				  ,CASE WHEN RF.BIZ_TYPE = 'PACK'
						THEN RF.PLANT_SITE_ID
						ELSE NULL
					END AS PACK_SITE		-- Pack  생산 사이트 
				  ,CASE WHEN RF.BIZ_TYPE = 'CELL'
						THEN MS.PLANT_ID
						ELSE MS2.PLANT_ID	
					END AS CELL		-- Cell 생산 Plant  
				  ,CASE WHEN RF.BIZ_TYPE = 'PACK'
						THEN MS.PLANT_ID
						ELSE NULL
					END AS PACK		-- Pack  생산 Plant 
				  ,CS.SITE_RATIO
				  ,ROUND(ISNULL(CS.SITE_RATIO, 1) * RF.ALLOCATION_QTY, 0)
				   + CASE WHEN CS.ORG_DEMAND_ID IS NOT NULL  -- 소수점처리로 인해 발생되는 gap 수량 더해줌
							   AND CS.CELL_SITE_QTY_DESC_RNK != CS.CELL_SITE_QTY_ASC_RNK 
							   AND CS.CELL_SITE_QTY_DESC_RNK  = 1 
						  THEN RF.ALLOCATION_QTY  
								- SUM(ROUND(ISNULL(CS.SITE_RATIO, 1) * RF.ALLOCATION_QTY, 0)) OVER (PARTITION BY RF.DEMAND_ID , RF.YYYYMM )
						  ELSE 0
				      END 													AS CELL_SITE_ALLOCATION_QTY
				  ,RF.ALLOCATION_QTY										AS ORG_ALLOCATION_QTY
				  ,EI.ELEC_ITEM_ID 
				  ,CA.CA_ITEM_ID
				  ,CA.CA_SITE_ID
				  ,MS.OSP_YN	-- 모델 생산 사이트 외주 여부
				  ,SUM(ROUND(ISNULL(CS.SITE_RATIO,1) * RF.ALLOCATION_QTY, 0)) OVER (PARTITION BY RF.DEMAND_ID, RF.YYYYMM )	AS DEMAND_ALLOCATION_QTY 
				  ,ISNULL(CS.CELL_SITE_QTY_DESC_RNK, 0)																		AS CELL_SITE_QTY_DESC_RNK 
				  ,ISNULL(CS.CELL_SITE_QTY_ASC_RNK , 0)																		AS CELL_SITE_QTY_ASC_RNK
				  ,ROW_NUMBER()	OVER (PARTITION BY 'A'	ORDER BY RF.DEMAND_ID,  RF.YYYYMM, CA.CA_SITE_ID)					AS CELL_SITE_SEQ 
			 INTO #TMP_RTF_FOR_CELL_SITE
			 FROM #TMP_ALLOCATION_INFO RF WITH(NOLOCK)
				  LEFT JOIN SCM_MST_SITE MS WITH(NOLOCK)		-- 2023/8/25 left join으로 변경 --> NO PLANT ALLOCATION 정보가 존재함 (40 소형) 
						  ON MS.DIVISION_ID = RF.DIVISION_ID
						 AND MS.SCM_SITE_ID = RF.PLANT_SITE_ID 
						 AND MS.SITE_TYPE   = 'PLANT'
				  LEFT JOIN #ENG_BOM_TREE_MODEL EB WITH(NOLOCK)
						 ON EB.PARENT_OPERATION_GROUP = 'P'
						AND EB.CHILD_OPERATION_GROUP  = 'A'
						AND EB.MIN_FC_OP_NLEVEL       = EB.NLEVEL   --- CP
						AND EB.MODEL_ID				  = RF.MODEL_CODE 
				  LEFT JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
						 ON FI.DIVISION_ID = RF.DIVISION_ID
						AND FI.ITEM_ID	   = CASE WHEN EB.CHILD_ITEM_ID IS NOT NULL
												  THEN EB.CHILD_ITEM_ID 
												  ELSE RF.MODEL_CODE
											  END
				  LEFT	JOIN #TMP_PACK_DEMAND_CELL_PROD_SITE CS WITH(NOLOCK)
						  ON CS.ORG_DEMAND_ID	= RF.DEMAND_ID -- TH_ENG_NET_DEMAND_SN.DEMAND_ID
				  LEFT	JOIN #TMP_PACK_DEMAND_CA1_SITE CA WITH(NOLOCK)
						  ON CA.ORG_DEMAND_ID	= RF.DEMAND_ID 
				  LEFT  JOIN #TMP_ELEC_ITEM_INFO EI WITH(NOLOCK)
						  ON EI.DIVISION_ID		= RF.DIVISION_ID
						 AND EI.MODEL_ID		= CA.CA_ITEM_ID -- demand에 대한 생산 ca품목 20230824 -- RF.MODEL_CODE
				  LEFT JOIN SCM_MST_SITE MS2 WITH(NOLOCK)
						 ON MS2.DIVISION_ID = RF.DIVISION_ID
						AND MS2.SCM_SITE_ID = CS.TO_SCM_SITE_ID
						AND MS2.SITE_TYPE	= 'PLANT'
			WHERE 1=1

			-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' ### 최종 Business Plan RTF 등록 대상 정보' 
			-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('tempdb..#TMP_RTF_FINAL') IS NOT NULL  
			   DROP TABLE #TMP_RTF_FINAL;

			SELECT RF.DIVISION_ID
				  ,RF.SALES_SITE
				  ,RF.BIZ_TYPE
				  ,RF.CUST
				  ,RF.PROJECT
				  ,RF.PROJECT_DESC
				  ,II.ITEM_NICK_NAME	AS MODEL 
				  ,II.ITEM_UOM			AS UNIT
				  ,RF.MODEL_CODE
				  ,RF.INCOTERMS
				  ,RF.CELL_CODE
				  ,RF.CELL_NICKNAME
				  ,CASE WHEN RF.BIZ_TYPE = 'Pack' AND RF.PACK IS NULL -- Pack모델의 Pack 생산사이트 정보가 없으면 Cell 생산사이트 정보도 Null
						THEN NULL
						ELSE CELL
					END AS CELL		-- cell 생산 plant
				  ,RF.PACK			-- pack 생산 plant
				  ,RF.OSP_YN		-- model 생산 사이트 외주 여부
				  ,RF.CA_ITEM_ID
				  ,RF.CA_SITE_ID
				  ,RF.MM_SEQ
				  ,RF.YYYYMM
				  ,RF.ALLOCATION_QTY
				  ,RF.CELL_SITE_ALLOCATION_QTY
				  ,RF.SITE_RATIO
				  ,ISNULL(EP.ELEC_SITE_RT, 1)														AS ELEC_SITE_RT
				  ,ROUND(ISNULL(EP.ELEC_SITE_RT, 1) * RF.CELL_SITE_ALLOCATION_QTY, 0)	
				   + CASE WHEN EP.ELEC_SITE_RT IS NOT NULL AND EP.ELEC_DESC_RNK != EP.ELEC_ASC_RNK AND ELEC_DESC_RNK = 1 -- 전극 사이트 분할 적용인 경우 차이 수량을 비중이 높은 전극 사이트에 할당 
						  THEN RF.CELL_SITE_ALLOCATION_QTY 
							   - SUM(ROUND(ISNULL(EP.ELEC_SITE_RT, 1) * RF.CELL_SITE_ALLOCATION_QTY,0)) 
									OVER (PARTITION BY RF.CELL_SITE_SEQ)
						  ELSE 0
					  END																			AS ELEC_SITE_ALLOCATION_QTY	
				  ,ISNULL(EP.ELEC_ITEM_QTY, 0)														AS ELEC_ITEM_QTY			
				  ,ISNULL(EP.MM_ELEC_ITEM_TOT_QTY,0)												AS MM_ELEC_ITEM_TOT_QTY		
				  ,SUM(ROUND(ISNULL(EP.ELEC_SITE_RT, 1) * RF.CELL_SITE_ALLOCATION_QTY,0))
						OVER (PARTITION BY RF.CELL_SITE_SEQ)										AS ELEC_ALLOCATION_QTY 
				  ,RF.CELL_SITE_SEQ
				  ,RF.DEMAND_ID
				  ,RF.ELEC_ITEM_ID 
				  ,ES.PLANT_ID			AS ELECTRODE
				  ,CASE WHEN EP.ELEC_PROD_SITE_ID	IS NOT NULL	THEN EP.ELEC_PROD_SITE_ID	
						WHEN MA.ELEC_PLANT_SITE_ID	IS NOT NULL	THEN MA.ELEC_PLANT_SITE_ID	
						WHEN SI.PLANT_SITE_ID		IS NOT NULL	THEN SI.PLANT_SITE_ID		
						WHEN BO1.FROM_SITE			IS NOT NULL	THEN BO1.FROM_SITE			
						WHEN BO2.FROM_SITE			IS NOT NULL	THEN BO2.FROM_SITE			
						ELSE NULL
					END AS  ELECTRODE_SITE
				  ,CASE WHEN EP.ELEC_PROD_SITE_ID	IS NOT NULL	THEN 'Electrode Production'	
						WHEN MA.ELEC_PLANT_SITE_ID	IS NOT NULL	THEN 'Model Allocation'
						WHEN SI.PLANT_SITE_ID		IS NOT NULL	THEN 'Project Route'
						WHEN BO1.FROM_SITE			IS NOT NULL	THEN 'BOD (CP site)'
						WHEN BO2.FROM_SITE			IS NOT NULL	THEN 'BOD (CA site)'
						ELSE NULL
					END AS   ELECTRODE_CASE 
			INTO #TMP_RTF_FINAL
			FROM #TMP_RTF_FOR_CELL_SITE RF WITH(NOLOCK)
				 LEFT JOIN #TMP_ELEC_PROD_SITE EP WITH(NOLOCK)
						ON EP.YYYYMM				= RF.YYYYMM
					   AND EP.ELEC_ITEM_ID			= RF.ELEC_ITEM_ID
				 LEFT JOIN #TMP_MODEL_ALLOCATION MA WITH(NOLOCK)
						ON MA.DIVISION_ID			= RF.DIVISION_ID
					   AND MA.CELL_ITEM_ID			= RF.CA_ITEM_ID
					   AND MA.CELL_PLANT_SITE_ID	= RF.CELL_SITE 
				 LEFT JOIN #TMP_SITE_ITEM_PRIORITY SI WITH(NOLOCK)
						ON SI.ELEC_ITEM_ID			= RF.ELEC_ITEM_ID
				 LEFT JOIN #TMP_BOD BO1 WITH(NOLOCK)
						ON BO1.DIVISION_ID			= RF.DIVISION_ID
					   AND BO1.TO_SITE				= RF.CELL_SITE
					   AND BO1.FROM_SITE_PRIORITY	= 1 
				 LEFT JOIN #TMP_BOD BO2 WITH(NOLOCK)
						ON BO2.DIVISION_ID			= RF.DIVISION_ID
					   AND BO2.TO_SITE				= RF.CA_SITE_ID
					   AND BO2.FROM_SITE_PRIORITY	= 1 
				 LEFT JOIN #TMP_ITEM_INFO II WITH(NOLOCK)
						ON II.ITEM_ID	  = RF.MODEL_CODE
				 LEFT JOIN SCM_MST_SITE ES WITH(NOLOCK)
						ON ES.SCM_SITE_ID = CASE WHEN EP.ELEC_PROD_SITE_ID	IS NOT NULL	THEN EP.ELEC_PROD_SITE_ID	
												 WHEN MA.ELEC_PLANT_SITE_ID	IS NOT NULL	THEN MA.ELEC_PLANT_SITE_ID	
												 WHEN SI.PLANT_SITE_ID		IS NOT NULL	THEN SI.PLANT_SITE_ID		
												 WHEN BO1.FROM_SITE			IS NOT NULL	THEN BO1.FROM_SITE			
												 WHEN BO2.FROM_SITE			IS NOT NULL	THEN BO2.FROM_SITE			
												 ELSE NULL
											 END
					   AND ES.SITE_TYPE = 'PLANT'
			WHERE 1=1

			-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' ### SCP Production Plan Amend 데이터' 
			-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#TMP_SCP_PROD_PLAN_AMEND') IS NOT NULL 
				DROP TABLE #TMP_SCP_PROD_PLAN_AMEND;

			SELECT DL.*
				  ,PP.DIVISION_ID
				  ,PP.SCM_SITE_ID
				  ,CASE WHEN PP.OPERATION_GROUP = 'A'	THEN 'Cell'
						WHEN PP.OPERATION_GROUP = 'P'	THEN 'Pack'
						WHEN PP.OPERATION_GROUP = 'E'	THEN 'Electrode'
						ELSE PP.OPERATION_GROUP
				   END  AS OPERATION_GROUP
				  ,PP.ITEM_ID
				  ,PP.LINE_ID
				  ,PP.OPERATION_ID
				  ,PP.QTY
			 INTO #TMP_SCP_PROD_PLAN_AMEND
			 FROM SCP_ANL_PRODUCTION_PLAN PP WITH(NOLOCK)
				  INNER JOIN #TMP_DATE_LIST DL WITH(NOLOCK)
						  ON DL.YYYYMMDD = PP.YYYYMMDD
                  INNER JOIN SCM_MST_DIVISION D WITH(NOLOCK)
                          ON D.DIVISION_ID = PP.DIVISION_ID 
                          AND D.VALID_YN   = 'Y'
	  
			WHERE 1=1
			  AND PP.DIVISION_ID			= @p_division_id
			  AND PP.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
			  AND PP.PLAN_TYPE				= @p_plan_type
			  AND PP.SEQ					= @p_plan_seq 
			  AND PP.OPERATION_GROUP		= CASE WHEN D.ATTRIBUTE3 = 'EE'
												   THEN 'E'
												   ELSE PP.OPERATION_GROUP
											  END 
			  AND PP.MEASURE				= 'PROD_PLAN_AMEND'
			  AND PP.QTY				   != 0 
			  AND (PP.OPERATION_ID IN (
									SELECT DISTINCT b.segment4
														 FROM   scm_adm_lookup_master_detail a WITH(NOLOCK)
														 INNER JOIN scm_adm_lookup_master_detail b WITH(NOLOCK)
														 ON  a.segment1    = b.segment1
														 AND a.lookup_type = 'LOCATION_GROUP'
														 AND a.segment4    = 'Y' -- Capa 공정 여부 
														 AND a.segment5    = 'Y' -- Line 별 Capa 적용 공정( Capa공정여부가 'N'이면  Line 별 Capa 적용 공정이 'Y'가 될수없음)
														 AND a.valid_yn    = 'Y'
														 AND b.lookup_type = 'LOCATION_GROUP_ROUTE'
														 AND b.valid_yn    = 'Y'
														 AND b.segment3    = 'Y' -- Capa 세부 공정 여부 
			                          )
				     OR --외주PACKER의 업체코드
					 (CASE WHEN CHARINDEX('_', PP.operation_id) > 0 THEN (SUBSTRING(PP.operation_id, 1, DBO.FN_CHARINDEX_REV(PP.operation_id, '_', 0)-1)) ELSE PP.operation_id END) 
					         IN (--외주PACKER의 업체코드
                                                 SELECT PLANT_ID  AS OPERATION_ID
                                                   FROM SCM_MST_SITE WITH(NOLOCK)      
                                                  WHERE 1=1
                                                    AND SITE_TYPE   = 'PLANT'
                                                    AND OSP_YN      = 'Y'  
								)
				     OR OPERATION_ID = 'F6200' 
				   )
			;


			-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' ### final PROD'   -- 20231013 
			-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..##SCP_ANL_BUSINESS_PLAN_PROD') IS NOT NULL 
				DROP TABLE ##SCP_ANL_BUSINESS_PLAN_PROD;

			SELECT PP.DIVISION_ID
				  ,@p_plan_id				AS PLAN_ID
				  ,PP.OPERATION_GROUP
				  ,MS.PLANT_ID				AS SITE_ID
				  ,CASE WHEN MS.OSP_YN = 'N' 
						THEN SUBSTRING(PP.LINE_ID, 1, 2)
						ELSE '-'
				   END						AS BUILDING
				  ,PP.LINE_ID
				  ,II.ITEM_NICK_NAME		AS NICKNAME
				  ,PP.ITEM_ID				AS MODEL
				  ,II.ITEM_UOM				AS UNIT
				  ,'Prod. Plan'				AS MEASURE
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 1	THEN PP.QTY		ELSE 0	END),0) 	AS M1_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 2	THEN PP.QTY		ELSE 0	END),0) 	AS M2_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 3	THEN PP.QTY		ELSE 0	END),0) 	AS M3_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 4	THEN PP.QTY		ELSE 0	END),0) 	AS M4_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 5	THEN PP.QTY		ELSE 0	END),0) 	AS M5_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 6	THEN PP.QTY		ELSE 0	END),0) 	AS M6_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 7	THEN PP.QTY		ELSE 0	END),0) 	AS M7_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 8	THEN PP.QTY		ELSE 0	END),0) 	AS M8_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 9	THEN PP.QTY		ELSE 0	END),0) 	AS M9_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 10	THEN PP.QTY		ELSE 0	END),0) 	AS M10_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 11	THEN PP.QTY		ELSE 0	END),0) 	AS M11_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 12	THEN PP.QTY		ELSE 0	END),0) 	AS M12_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 13	THEN PP.QTY		ELSE 0	END),0) 	AS M13_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 14	THEN PP.QTY		ELSE 0	END),0) 	AS M14_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 15	THEN PP.QTY		ELSE 0	END),0) 	AS M15_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 16	THEN PP.QTY		ELSE 0	END),0) 	AS M16_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 17	THEN PP.QTY		ELSE 0	END),0) 	AS M17_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 18	THEN PP.QTY		ELSE 0	END),0) 	AS M18_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 19	THEN PP.QTY		ELSE 0	END),0) 	AS M19_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 20	THEN PP.QTY		ELSE 0	END),0) 	AS M20_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 21	THEN PP.QTY		ELSE 0	END),0) 	AS M21_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 22	THEN PP.QTY		ELSE 0	END),0) 	AS M22_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 23	THEN PP.QTY		ELSE 0	END),0) 	AS M23_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 24	THEN PP.QTY		ELSE 0	END),0) 	AS M24_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 25	THEN PP.QTY		ELSE 0	END),0) 	AS M25_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 26	THEN PP.QTY		ELSE 0	END),0) 	AS M26_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 27	THEN PP.QTY		ELSE 0	END),0) 	AS M27_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 28	THEN PP.QTY		ELSE 0	END),0) 	AS M28_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 29	THEN PP.QTY		ELSE 0	END),0) 	AS M29_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 30	THEN PP.QTY		ELSE 0	END),0) 	AS M30_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 31	THEN PP.QTY		ELSE 0	END),0) 	AS M31_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 32	THEN PP.QTY		ELSE 0	END),0) 	AS M32_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 33	THEN PP.QTY		ELSE 0	END),0) 	AS M33_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 34	THEN PP.QTY		ELSE 0	END),0) 	AS M34_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 35	THEN PP.QTY		ELSE 0	END),0) 	AS M35_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 36	THEN PP.QTY		ELSE 0	END),0) 	AS M36_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 37	THEN PP.QTY		ELSE 0	END),0) 	AS M37_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 38	THEN PP.QTY		ELSE 0	END),0) 	AS M38_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 39	THEN PP.QTY		ELSE 0	END),0) 	AS M39_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 40	THEN PP.QTY		ELSE 0	END),0) 	AS M40_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 41	THEN PP.QTY		ELSE 0	END),0) 	AS M41_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 42	THEN PP.QTY		ELSE 0	END),0) 	AS M42_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 43	THEN PP.QTY		ELSE 0	END),0) 	AS M43_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 44	THEN PP.QTY		ELSE 0	END),0) 	AS M44_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 45	THEN PP.QTY		ELSE 0	END),0) 	AS M45_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 46	THEN PP.QTY		ELSE 0	END),0) 	AS M46_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 47	THEN PP.QTY		ELSE 0	END),0) 	AS M47_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 48	THEN PP.QTY		ELSE 0	END),0) 	AS M48_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 49	THEN PP.QTY		ELSE 0	END),0) 	AS M49_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 50	THEN PP.QTY		ELSE 0	END),0) 	AS M50_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 51	THEN PP.QTY		ELSE 0	END),0) 	AS M51_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 52	THEN PP.QTY		ELSE 0	END),0) 	AS M52_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 53	THEN PP.QTY		ELSE 0	END),0) 	AS M53_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 54	THEN PP.QTY		ELSE 0	END),0) 	AS M54_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 55	THEN PP.QTY		ELSE 0	END),0) 	AS M55_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 56	THEN PP.QTY		ELSE 0	END),0) 	AS M56_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 57	THEN PP.QTY		ELSE 0	END),0) 	AS M57_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 58	THEN PP.QTY		ELSE 0	END),0) 	AS M58_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 59	THEN PP.QTY		ELSE 0	END),0) 	AS M59_QTY
				  ,ROUND(SUM(CASE WHEN PP.MM_SEQ = 60	THEN PP.QTY		ELSE 0	END),0) 	AS M60_QTY
				  ,@p_user_id				AS CREATED_BY
				  ,GETDATE()				AS CREATION_DATE
				  ,@p_user_id				AS LAST_UPDATED_BY
				  ,GETDATE()				AS LAST_UPDATE_DATE
				  ,@v_eng_plan_id			AS ATTRIBUTE1
				  ,@p_plan_start_yyyymmdd	AS ATTRIBUTE2
				  ,MS.OSP_YN				AS ATTRIBUTE3
				  ,NEWID()					AS KEYVALUE -- 8/28 
			 INTO ##SCP_ANL_BUSINESS_PLAN_PROD
			 FROM #TMP_SCP_PROD_PLAN_AMEND PP WITH(NOLOCK)
				  INNER JOIN #TMP_ITEM_INFO II WITH(NOLOCK)
						  ON II.ITEM_ID		= PP.ITEM_ID 
				  INNER JOIN SCM_MST_SITE MS WITH(NOLOCK)
						  ON MS.DIVISION_ID = CASE WHEN @p_division_id LIKE 'EE%'
												   THEN MS.DIVISION_ID
												   ELSE PP.DIVISION_ID 
											  END 
						 AND MS.SCM_SITE_ID = PP.SCM_SITE_ID 
						 AND MS.SITE_TYPE   = 'PLANT'
			WHERE 1=1 
			GROUP BY PP.DIVISION_ID
					,PP.OPERATION_GROUP
					,MS.PLANT_ID
					,CASE WHEN MS.OSP_YN = 'N' 
							THEN SUBSTRING(PP.LINE_ID, 1, 2)
							ELSE '-'
					   END
					,PP.LINE_ID
					,II.ITEM_NICK_NAME
					,PP.ITEM_ID	
					,II.ITEM_UOM
					,MS.OSP_YN  -- MS/PLANT_ID에 종속적인 값


			-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' ### final RTF'   -- 20231013 
			-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..##SCP_ANL_BUSINESS_PLAN_RTF') IS NOT NULL 
				DROP TABLE ##SCP_ANL_BUSINESS_PLAN_RTF;

			SELECT 
				  RF.DIVISION_ID
				 ,@p_plan_id		AS PLAN_ID
				 ,RF.SALES_SITE
				 ,RF.BIZ_TYPE
				 ,RF.CUST
				 ,RF.PROJECT
				 ,RF.PROJECT_DESC
				 ,RF.MODEL
				 ,RF.MODEL_CODE
				 ,RF.CELL_NICKNAME
				 ,RF.CELL_CODE
				 ,CASE WHEN ISNULL(RF.CELL,'') = '' 
					   THEN NULL
					   ELSE RF.ELECTRODE
				  END  AS ELECTRODE
				 ,RF.CELL
				 ,RF.PACK
				 ,RF.UNIT
				 ,RF.INCOTERMS
				 ,'RTF'	AS MEASURE
				 -- 20230829 begin RTF 전극 사이트 생산 수량 비중으로 배분 (변경전 : CELL_SITE_ALLOCATION_QTY -> 변경후:ELEC_SITE_ALLOCATION_QTY)
				 ,SUM(CASE WHEN RF.MM_SEQ = 1  THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M1_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 2  THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M2_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 3  THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M3_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 4  THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M4_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 5  THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M5_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 6  THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M6_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 7  THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M7_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 8  THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M8_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 9  THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M9_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 10 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M10_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 11 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M11_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 12 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M12_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 13 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M13_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 14 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M14_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 15 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M15_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 16 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M16_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 17 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M17_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 18 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M18_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 19 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M19_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 20 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M20_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 21 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M21_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 22 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M22_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 23 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M23_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 24 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M24_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 25 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M25_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 26 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M26_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 27 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M27_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 28 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M28_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 29 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M29_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 30 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M30_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 31 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M31_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 32 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M32_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 33 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M33_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 34 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M34_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 35 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M35_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 36 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M36_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 37 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M37_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 38 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M38_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 39 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M39_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 40 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M40_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 41 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M41_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 42 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M42_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 43 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M43_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 44 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M44_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 45 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M45_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 46 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M46_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 47 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M47_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 48 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M48_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 49 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M49_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 50 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M50_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 51 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M51_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 52 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M52_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 53 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M53_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 54 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M54_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 55 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M55_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 56 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M56_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 57 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M57_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 58 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M58_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 59 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M59_QTY
				 ,SUM(CASE WHEN RF.MM_SEQ = 60 THEN RF.ELEC_SITE_ALLOCATION_QTY ELSE 0 END)  M60_QTY
				 -- 20230829 end RTF 전극 사이트 생산 수량 비중으로 배분 (CELL_SITE_ALLOCATION_QTY -> ELEC_SITE_ALLOCATION_QTY)
				 ,@p_user_id AS CREATED_BY
				 ,GETDATE()	AS CREATION_DATE
				 ,@p_user_id AS LAST_UPDATED_BY
				 ,GETDATE() LAST_UPDATE_DATE
				 ,@v_eng_plan_id			AS ATTRIBUTE1
				 ,@p_plan_start_yyyymmdd	AS ATTRIBUTE2
				 ,RF.OSP_YN					AS ATTRIBUTE3
				 ,NEWID()					AS KEYVALUE  -- 8/28 
			 INTO ##SCP_ANL_BUSINESS_PLAN_RTF
			 FROM #TMP_RTF_FINAL RF WITH(NOLOCK) 
			WHERE 1=1
			GROUP BY  RF.DIVISION_ID
					 ,RF.SALES_SITE
					 ,RF.BIZ_TYPE
					 ,RF.CUST
					 ,RF.PROJECT
					 ,RF.PROJECT_DESC
					 ,RF.MODEL
					 ,RF.MODEL_CODE
					 ,RF.CELL_NICKNAME
					 ,RF.CELL_CODE
					 ,CASE WHEN ISNULL(RF.CELL,'') = '' 
					       THEN NULL
					       ELSE RF.ELECTRODE
				      END
					 ,RF.CELL
					 ,RF.PACK
					 ,RF.UNIT
					 ,RF.INCOTERMS
					 ,RF.OSP_YN


			BEGIN TRAN   --- transaction 시작  
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' ### 1.1 DELETE SCP SCP_ANL_BUSINESS_PLAN_PROD PLAN' 
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			DELETE TGT
			  FROM SCP_ANL_BUSINESS_PLAN_PROD TGT WITH(NOLOCK) 
			WHERE 1=1
			  AND TGT.DIVISION_ID	= @p_division_id
			  AND TGT.PLAN_ID		= @p_plan_id 

			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' ### 1.2 INSERT INTO SCP SCP_ANL_BUSINESS_PLAN_PROD PLAN' 
			--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			INSERT INTO SCP_ANL_BUSINESS_PLAN_PROD (
				  DIVISION_ID
				 ,PLAN_ID
				 ,OPERATION_GROUP
				 ,SITE_ID
				 ,BUILDING
				 ,LINE_ID
				 ,NICKNAME
				 ,MODEL
				 ,UNIT
				 ,MEASURE
				 ,M1_QTY
				 ,M2_QTY
				 ,M3_QTY
				 ,M4_QTY
				 ,M5_QTY
				 ,M6_QTY
				 ,M7_QTY
				 ,M8_QTY
				 ,M9_QTY
				 ,M10_QTY
				 ,M11_QTY
				 ,M12_QTY
				 ,M13_QTY
				 ,M14_QTY
				 ,M15_QTY
				 ,M16_QTY
				 ,M17_QTY
				 ,M18_QTY
				 ,M19_QTY
				 ,M20_QTY
				 ,M21_QTY
				 ,M22_QTY
				 ,M23_QTY
				 ,M24_QTY
				 ,M25_QTY
				 ,M26_QTY
				 ,M27_QTY
				 ,M28_QTY
				 ,M29_QTY
				 ,M30_QTY
				 ,M31_QTY
				 ,M32_QTY
				 ,M33_QTY
				 ,M34_QTY
				 ,M35_QTY
				 ,M36_QTY
				 ,M37_QTY
				 ,M38_QTY
				 ,M39_QTY
				 ,M40_QTY
				 ,M41_QTY
				 ,M42_QTY
				 ,M43_QTY
				 ,M44_QTY
				 ,M45_QTY
				 ,M46_QTY
				 ,M47_QTY
				 ,M48_QTY
				 ,M49_QTY
				 ,M50_QTY
				 ,M51_QTY
				 ,M52_QTY
				 ,M53_QTY
				 ,M54_QTY
				 ,M55_QTY
				 ,M56_QTY
				 ,M57_QTY
				 ,M58_QTY
				 ,M59_QTY
				 ,M60_QTY
				 ,CREATED_BY
				 ,CREATION_DATE
				 ,LAST_UPDATED_BY
				 ,LAST_UPDATE_DATE
				 ,ATTRIBUTE1
				 ,ATTRIBUTE2
				 ,ATTRIBUTE3
				 ,KEYVALUE		-- 8/28
			 )
			SELECT *
			 FROM ##SCP_ANL_BUSINESS_PLAN_PROD PP WITH(NOLOCK)

			SET @v_prod_result_cnt = @@rowcount;
			print '@v_prod_result_cnt :' + convert(nvarchar(100), @v_prod_result_cnt) 

			-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' ### 2.1 DELETE FROM SCP_ANL_BUSINESS_PLAN_RTF ' 
			-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			DELETE TGT
			 FROM SCP_ANL_BUSINESS_PLAN_RTF TGT
			WHERE TGT.DIVISION_ID = @p_division_id
			  AND TGT.PLAN_ID     = @p_plan_id 

			-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' ### 2.2 INSERT INTO SCP_ANL_BUSINESS_PLAN_RTF ' 
			-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			INSERT INTO SCP_ANL_BUSINESS_PLAN_RTF (
				  DIVISION_ID
				 ,PLAN_ID
				 ,SALES_SITE
				 ,BIZ_TYPE
				 ,CUST
				 ,PROJECT
				 ,PROJECT_DESC
				 ,MODEL
				 ,MODEL_CODE
				 ,CELL_NICKNAME
				 ,CELL_CODE
				 ,ELECTRODE
				 ,CELL
				 ,PACK
				 ,UNIT
				 ,INCOTERMS
				 ,MEASURE
				 ,M1_QTY
				 ,M2_QTY
				 ,M3_QTY
				 ,M4_QTY
				 ,M5_QTY
				 ,M6_QTY
				 ,M7_QTY
				 ,M8_QTY
				 ,M9_QTY
				 ,M10_QTY
				 ,M11_QTY
				 ,M12_QTY
				 ,M13_QTY
				 ,M14_QTY
				 ,M15_QTY
				 ,M16_QTY
				 ,M17_QTY
				 ,M18_QTY
				 ,M19_QTY
				 ,M20_QTY
				 ,M21_QTY
				 ,M22_QTY
				 ,M23_QTY
				 ,M24_QTY
				 ,M25_QTY
				 ,M26_QTY
				 ,M27_QTY
				 ,M28_QTY
				 ,M29_QTY
				 ,M30_QTY
				 ,M31_QTY
				 ,M32_QTY
				 ,M33_QTY
				 ,M34_QTY
				 ,M35_QTY
				 ,M36_QTY
				 ,M37_QTY
				 ,M38_QTY
				 ,M39_QTY
				 ,M40_QTY
				 ,M41_QTY
				 ,M42_QTY
				 ,M43_QTY
				 ,M44_QTY
				 ,M45_QTY
				 ,M46_QTY
				 ,M47_QTY
				 ,M48_QTY
				 ,M49_QTY
				 ,M50_QTY
				 ,M51_QTY
				 ,M52_QTY
				 ,M53_QTY
				 ,M54_QTY
				 ,M55_QTY
				 ,M56_QTY
				 ,M57_QTY
				 ,M58_QTY
				 ,M59_QTY
				 ,M60_QTY
				 ,CREATED_BY
				 ,CREATION_DATE
				 ,LAST_UPDATED_BY
				 ,LAST_UPDATE_DATE
				 ,ATTRIBUTE1
				 ,ATTRIBUTE2
				 ,ATTRIBUTE3
				 ,KEYVALUE	-- 8/28
			)
			SELECT *
			 FROM ##SCP_ANL_BUSINESS_PLAN_RTF RF WITH(NOLOCK)

			SET @v_rtf_result_cnt = @@rowcount;
			print '@v_rtf_result_cnt :' + convert(nvarchar(100), @v_rtf_result_cnt) 

			-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' ### 3. UPDATE SCP_ANL_BUSINESS_PLAN_INFO : RTF 및 PROD 생성 SCP plan 정보 update  ' 
			-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			UPDATE TGT
			   SET TGT.ATTRIBUTE1		= @v_eng_plan_id
				  ,TGT.ATTRIBUTE2		= @p_plan_start_yyyymmdd
				  ,TGT.LAST_UPDATE_DATE = GETDATE()
				  ,TGT.LAST_UPDATED_BY	= @p_user_id
			  FROM SCP_ANL_BUSINESS_PLAN_INFO TGT WITH(NOLOCK)
			 WHERE 1=1
			  AND TGT.DIVISION_ID	= @p_division_id
			  AND TGT.PLAN_ID		= @p_plan_id


			COMMIT TRAN;   ---- Transaction 끝.


			-- 결과코드, 결과 카운트 반환
			SELECT  'S'																										AS result_code
				  ,  @v_prod_result_cnt+@v_rtf_result_cnt																	AS result_cnt
				  , 'Success [PROD:'+CONVERT(NVARCHAR,@v_prod_result_cnt)+'][RTF:'+ CONVERT(NVARCHAR,@v_rtf_result_cnt)+']' AS result_message;

		END			    
    END TRY

    BEGIN CATCH                  

		if (xact_state() <> 0) ROLLBACK TRAN; 

		-- ERROR LOG                  
		SET @v_log_type = N'ERROR';                  
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));                  
		SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE());                  
		SET @d_event_date = SYSDATETIME();                  

		-- error코드, errror 메시지 반환
		SELECT 'F'				AS result_code
			  , 0				AS result_cnt
			  , @v_log_message	AS result_message;

		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name                  
		                          ,@p_log_type      = @v_log_type                  
		                          ,@p_log_count     = @n_log_count                   
		                          ,@p_log_message   = @v_log_message                   
		                          ,@p_description   = @v_description                   
		                          ,@p_event_date    = @d_event_date                   
		                          ,@p_user_id       = @v_batch_user                  
		                          ;                  
		PRINT @v_log_message      + ' : ' + @v_description ;          
    END CATCH;   

    SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +                 
                         REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))                 
    -- 종료 LOG                  
    SET @v_log_type = N'END';                  
    SET @v_log_message = N'##### END of procedure #####';                  
    SET @v_description = N'['+ @p_division_id + '::' + @p_plan_id + ']['+@p_plan_start_yyyymmdd+'::'+ISNULL(@v_eng_plan_id,'')+']['  + @v_exec_time + ']';  ;            
    SET @d_event_date = SYSDATETIME()  ;                 
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
                              ,@p_log_type      =@v_log_type                  
                              ,@p_log_count     =@n_log_count                   
                              ,@p_log_message   =@v_log_message                   
                              ,@p_description   =@v_description                   
                              ,@p_event_date    =@d_event_date                   
                              ,@p_user_id       =@v_batch_user                  
                              ;                  
	PRINT @v_log_message      + ' : ' + @v_description ;          

END
