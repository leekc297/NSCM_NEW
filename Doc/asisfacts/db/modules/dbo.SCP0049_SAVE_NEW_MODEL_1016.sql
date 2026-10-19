



/*
 * Program ID   : SCP0049_SAVE_NEW_MODEL
 * Description  : CAPAA SAVE NEW MODEL
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020/08/13   khj79          [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 - 최초작성
 * 2021/05/17   khj79          [PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선 - TACT TIME 저장되도록 수정
 * 2021/07/20   kmj            [PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선 - Coater(E2000) Line assign 생성 시(New모델로 생성 시만) Mixer(E1000) 도 동일 라인/BOM 기준으로 자동 생성
 * 2021/08/24   kmj            [PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선 - 이력 저장 및 LINE ASSIGN 9 입력시 삭제 처리
 * 2022/08/24   cys            E1000 데이타가 동시에 들어올 경우 E1000 자동등록 부분에서 중복으로 추가되어 PK 오류 발생되어 수정 (D.20220824~R.0824.01)
 * 2023/03/31   leejsthira2    line assign, lane 저장시 pancake master 정보 동기화 처리
 
 ex) EXEC	SCP0049_SAVE_NEW_MODEL
	 @p_active_flag = 'M^M^M^M'					,@p_division_id		= '40^40^40^40'	
	,@p_company_id	= 'C100^C100^C100^C100'		,@p_site_id			= 'A001^A001^A001^A001'	
	,@p_plant_id	= 'A010^A010^A010^A010'		,@p_factory_id		= 'M1^M1^M1^M1'	
	,@p_line_id		= 'M1C01^M1C01^M1C01^M1C01'	,@p_electrode_type	= '-^-^-^-'
	,@p_operation_id= 'A2000^A2000^A2000^A2000'	,@p_loss_code		= 'EL004^EL004^EL005^EL012'
	,@p_data_table	= 'SCM_WORK_CALENDAR_M^SCM_WORK_CALENDAR_M^SCM_WORK_CALENDAR_M^SCM_LOSS_M'	
	,@p_confirm_flag= 'Y^Y^Y^N'					,@p_day_name		= 'CONFIRM_FLAG^20200701^20200701^202008'	
	,@p_day_qty		= 'True^10^30^1.00'			,@p_data_type		= 'CF^Day^Day^Month'			
	,@p_update_id	= 'khj79^khj79^khj79^khj79'
*/	

  CREATE PROCEDURE [dbo].[SCP0049_SAVE_NEW_MODEL_1016]
	 @p_active_flag			NVARCHAR(MAX)
	,@p_today_yyyymmdd		NVARCHAR(MAX)
	,@p_division_id			NVARCHAR(MAX)
	,@p_company_id			NVARCHAR(MAX)
	,@p_site_id				NVARCHAR(MAX)
	,@p_plant_id			NVARCHAR(MAX)
	,@p_factory_id			NVARCHAR(MAX)
	,@p_operation_id		NVARCHAR(MAX)
	,@p_item_id				NVARCHAR(MAX)
	,@p_line_id				NVARCHAR(MAX)
	,@p_electrode_type		NVARCHAR(MAX)
	,@p_day_name			NVARCHAR(MAX)
	,@p_day_qty				NVARCHAR(MAX)
	,@p_lane_qty			NVARCHAR(MAX)
	,@p_data_type			NVARCHAR(MAX)
	,@p_update_id			NVARCHAR(MAX)

AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^'

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0049_SAVE_NEW_MODEL';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 결과 반환 변수 설정
	DECLARE @v_mod_cnt		INTEGER = 0;

	-- 이력 저장용 변수 설정
	DECLARE @SCP0049_HIST	AS DBO.SCP0049
	-- 삭제용 변수 설정
	DECLARE @SCP0049_DELETE	AS DBO.SCP0049

	IF OBJECT_ID('TEMPDB..#TMP_SCP0049_SAVE_NEW_MODEL') IS NOT NULL
		DROP TABLE #TMP_SCP0049_SAVE_NEW_MODEL;

	CREATE TABLE #TMP_SCP0049_SAVE_NEW_MODEL
	(
	    DATA_TYPE			NVARCHAR(030)
	  , COMPANY_ID			NVARCHAR(030)
	  , DIVISION_ID			NVARCHAR(030)
	  , SITE_ID				NVARCHAR(030)
	  , PLANT_ID			NVARCHAR(030)
	  , FACTORY_ID			NVARCHAR(030)
	  , LINE_ID				NVARCHAR(030)
	  , ELECTRODE_TYPE		NVARCHAR(030)
	  , OPERATION_ID		NVARCHAR(030)
	  , ITEM_ID				NVARCHAR(030)
	  , LANE_QTY			NVARCHAR(030)
	  , DAY_NAME			NVARCHAR(030)
	  , DAY_QTY				NVARCHAR(030)
	  , UPDATE_ID			NVARCHAR(030)
	)

	-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	-- 트렌젝션 시작
	BEGIN TRAN;

	BEGIN TRY
		


		INSERT INTO #TMP_SCP0049_SAVE_NEW_MODEL
			(
				  DATA_TYPE
				, DIVISION_ID
				, COMPANY_ID
				, SITE_ID
				, PLANT_ID
				, FACTORY_ID
				, LINE_ID
				, ELECTRODE_TYPE
				, OPERATION_ID
				, ITEM_ID
				, LANE_QTY
				, DAY_NAME
				, DAY_QTY
				, UPDATE_ID
		)
		SELECT A1.TOKEN AS DATA_TYPE
			 , A2.TOKEN AS DIVISION_ID
			 , A3.TOKEN AS COMPANY_ID
			 , A4.TOKEN AS SITE_ID
			 , A5.TOKEN AS PLANT_ID
			 , A6.TOKEN AS FACTORY_ID
			 , A7.TOKEN AS LINE_ID
			 , A8.TOKEN AS ELECTRODE_TYPE
			 , A9.TOKEN AS OPERATION_ID
			 , A10.TOKEN AS ITEM_ID
			 , A11.TOKEN AS LANE_QTY
			 , A12.TOKEN AS DAY_NAME
			 , A13.TOKEN AS DAY_QTY
			 , A14.TOKEN AS UPDATE_ID
			 FROM DBO.UF_FX_String_Split(@p_data_type		, @v_delimiter) A1
			JOIN DBO.UF_FX_String_Split(@p_division_id		, @v_delimiter) A2  ON A1.NR = A2.NR
			JOIN DBO.UF_FX_String_Split(@p_company_id		, @v_delimiter) A3  ON A1.NR = A3.NR
			JOIN DBO.UF_FX_String_Split(@p_site_id			, @v_delimiter) A4  ON A1.NR = A4.NR
			JOIN DBO.UF_FX_String_Split(@P_plant_id			, @v_delimiter) A5  ON A1.NR = A5.NR
			JOIN DBO.UF_FX_String_Split(@p_factory_id		, @v_delimiter) A6  ON A1.NR = A6.NR
			JOIN DBO.UF_FX_String_Split(@p_line_id			, @v_delimiter) A7  ON A1.NR = A7.NR
			JOIN DBO.UF_FX_String_Split(@p_electrode_type	, @v_delimiter) A8  ON A1.NR = A8.NR
			JOIN DBO.UF_FX_String_Split(@p_operation_id		, @v_delimiter) A9  ON A1.NR = A9.NR
			JOIN DBO.UF_FX_String_Split(@p_item_id			, @v_delimiter) A10  ON A1.NR = A10.NR
			JOIN DBO.UF_FX_String_Split(@p_lane_qty			, @v_delimiter) A11  ON A1.NR = A11.NR
			JOIN DBO.UF_FX_String_Split(@p_day_name			, @v_delimiter) A12  ON A1.NR = A12.NR
			JOIN DBO.UF_FX_String_Split(@p_day_qty			, @v_delimiter) A13  ON A1.NR = A13.NR
			JOIN DBO.UF_FX_String_Split(@p_update_id		, @v_delimiter) A14  ON A1.NR = A14.NR
		;


		-- 이력 저장
		INSERT INTO @SCP0049_HIST
		(
			  P_DATA_TABLE
			, P_DATA_TYPE
			, P_DIVISION_ID
			, P_COMPANY_ID
			, P_SITE_ID
			, P_PLANT_ID
			, P_FACTORY_ID
			, P_LINE_ID
			, P_ELECTRODE_TYPE
			, P_OPERATION_ID
			, P_ITEM_ID
			, P_DAY_NAME
			, P_DAY_QTY
			, P_UPDATE_ID
		)
		SELECT 'LA'	AS DATA_TABLE
			 , CASE WHEN DATA_TYPE = 'LANE_QTY_DATA' THEN 'LQ'
			 	   WHEN DATA_TYPE = 'PRIORITY_DATA' THEN 'M'
			   END	AS DATA_TYPE
			 , DIVISION_ID
			 , COMPANY_ID
			 , SITE_ID
			 , PLANT_ID
			 , FACTORY_ID
			 , LINE_ID
			 , ELECTRODE_TYPE
			 , OPERATION_ID
			 , ITEM_ID
			 , DAY_NAME
			 , DAY_QTY
			 , UPDATE_ID
		  FROM #TMP_SCP0049_SAVE_NEW_MODEL
		;

		-- 이력저장
		EXEC [dbo].[PR_SCP_CAPA_HIST_DATASET] @SCP0049_HIST;

		-- 데이터 삭제를 위한 변수 설정
		INSERT INTO @SCP0049_DELETE
		SELECT *
		  FROM @SCP0049_HIST
		 WHERE ISNULL(CONVERT(INT,CONVERT(NUMERIC(20,10),P_DAY_QTY)),0) = 9
		;

		-- 데이터 삭제(LINE_ASSIGN,TACT_TIME,YIELD)
		EXEC [dbo].[PR_SCP_CAPA_LINE_ASSIGN_DELETE_DATASET] @SCP0049_DELETE;


		-- 9 값은 삭제
		DELETE FROM #TMP_SCP0049_SAVE_NEW_MODEL WHERE ISNULL(CONVERT(INT,CONVERT(NUMERIC(20,10),DAY_QTY)),0) = 9;


			-- E2000(coating) NEW MODEL 등록시(신규 등록시만/수정X) 
			-- E1000(mixing) 자동 등록

			BEGIN		

					INSERT INTO #TMP_SCP0049_SAVE_NEW_MODEL
					(

					  DATA_TYPE
					, COMPANY_ID
					, DIVISION_ID
					, SITE_ID
					, PLANT_ID
					, FACTORY_ID
					, LINE_ID
					, ELECTRODE_TYPE
					, OPERATION_ID
					, ITEM_ID
					, LANE_QTY
					, DAY_NAME
					, DAY_QTY
					, UPDATE_ID

					)
					SELECT DISTINCT
						  M.DATA_TYPE
						, M.COMPANY_ID
						, M.DIVISION_ID
						, M.SITE_ID
						, M.PLANT_ID
						, M.FACTORY_ID
						, M.LINE_ID
						, M.ELECTRODE_TYPE
						--, A.OPERATION_ID
						, (CASE WHEN B.ITEM_CLASS = 'ES0109' THEN 'E0430' ELSE A.OPERATION_ID END) AS OPERATION_ID -- [E20240711-001442]신규 공정(DAM Slurry Mixing) 개발로 인한 FP WO 생성 기능 개발 요청 건
						, B.ITEM_ID
						, M.LANE_QTY
						, M.DAY_NAME
						, M.DAY_QTY
						, M.UPDATE_ID
					  FROM SCM_LINE_HIERARCHY_V_SN A WITH(NOLOCK)
					  JOIN SCM_ITEM_M_SN B WITH(NOLOCK)
						ON A.DIVISION_ID	= B.DIVISION_ID
					   AND A.SITE_ID		= B.SITE_ID
					   AND ( CHARINDEX( A.OPERATION_ID, B.FLOW_ID, 0 )  > 0 
							  OR CHARINDEX( A.OPERATION_ID, B.FORMATION_FLOW_ID, 0 )  > 0 
							)
					   AND B.ACTIVE_FLAG	= 'Y'

					  JOIN SCM_MST_BOM_ENG_SN BO WITH(NOLOCK)  -- SCM_BOM_M 
						ON A.DIVISION_ID	= BO.DIVISION_ID
					   AND A.SITE_ID		= BO.SITE_ID
					   AND A.PLANT_ID		= BO.PLANT_ID
					   AND B.ITEM_ID		= BO.CHILD_ITEM_ID
					   AND BO.ACTIVE_FLAG	= 'Y'
					   AND BO.EFF_END_DATE >= GETDATE()
		
					  JOIN (

						SELECT 
							  M.DATA_TYPE
							, M.COMPANY_ID
							, M.DIVISION_ID
							, M.SITE_ID
							, M.PLANT_ID
							, M.FACTORY_ID
							, M.LINE_ID
							, M.ELECTRODE_TYPE
							, M.OPERATION_ID
							, M.ITEM_ID
							, M.LANE_QTY
							, M.DAY_NAME
							, M.DAY_QTY
							, M.UPDATE_ID
							, (
								SELECT COUNT(1)
								FROM SCM_MST_ITEM_LINE_ASSIGN_SN T WITH(NOLOCK)
								WHERE T.COMPANY_ID	= M.COMPANY_ID
								AND T.DIVISION_ID	= M.DIVISION_ID
								AND T.SITE_ID		= M.SITE_ID
								AND T.PLANT_ID		= M.PLANT_ID
								AND T.FACTORY_ID	= M.FACTORY_ID
								AND T.ITEM_ID		= M.ITEM_ID
								AND T.OPERATION_ID	= M.OPERATION_ID
								AND T.LINE_ID		= M.LINE_ID
								AND T.ELECTRODE_TYPE= M.ELECTRODE_TYPE
								AND T.MONTH			= M.DAY_NAME
							) AS CNT					
						FROM #TMP_SCP0049_SAVE_NEW_MODEL M
						WHERE M.OPERATION_ID = 'E2000'
										  
					  ) M 
						ON BO.DIVISION_ID	= M.DIVISION_ID
					   AND BO.PLANT_ID		= M.PLANT_ID
					   AND BO.COMPANY_ID	= M.COMPANY_ID
					   AND BO.PARENT_ITEM_ID= M.ITEM_ID
					   AND BO.SITE_ID		= M.SITE_ID
					   AND A.FACTORY_ID		= M.FACTORY_ID
					   AND A.LINE_ID		= M.LINE_ID
					   AND A.ELECTRODE_TYPE	= M.ELECTRODE_TYPE
					   AND CHARINDEX('E1000', B.FLOW_ID) > 0
					   AND M.CNT = 0
					 WHERE 1=1
				 	 AND   NOT EXISTS (	-- (D.20220824~R.0824.01)
											SELECT 1
											FROM #TMP_SCP0049_SAVE_NEW_MODEL T
											WHERE 1=1
											AND T.COMPANY_ID	= M.COMPANY_ID
											AND T.DIVISION_ID	= M.DIVISION_ID
											AND T.SITE_ID		= M.SITE_ID
											AND T.PLANT_ID		= M.PLANT_ID
											AND T.FACTORY_ID	= M.FACTORY_ID
											AND T.ITEM_ID		= B.ITEM_ID
											AND T.OPERATION_ID	= A.OPERATION_ID
											AND T.LINE_ID		= M.LINE_ID
											AND T.ELECTRODE_TYPE= M.ELECTRODE_TYPE
											AND T.DAY_NAME		= M.DAY_NAME
											AND T.OPERATION_ID  = 'E1000'
										)
					 ;

		
			END;

		/* ############################################################################ */
		/* LANE QTY 는 PRIORITY 가 다 처리된 다음 UPDATE 를 진행해야 누락이 발생하지 않는다	*/
		/* ############################################################################ */

		
			BEGIN
				MERGE INTO SCM_MST_ITEM_LINE_ASSIGN_SN M
				USING (
						SELECT COMPANY_ID
							 , DIVISION_ID
							 , SITE_ID
							 , PLANT_ID
							 , FACTORY_ID
							 , ITEM_ID
							 , OPERATION_ID
							 , LINE_ID
							 , ELECTRODE_TYPE
							 , LANE_QTY
							 , UPDATE_ID
						  FROM #TMP_SCP0049_SAVE_NEW_MODEL T
						 WHERE T.DATA_TYPE = 'LANE_QTY_DATA'
						) B
					ON M.COMPANY_ID		= B.COMPANY_ID
					AND M.DIVISION_ID	= B.DIVISION_ID
					AND M.SITE_ID		= B.SITE_ID
					AND M.PLANT_ID		= B.PLANT_ID
					AND M.FACTORY_ID	= B.FACTORY_ID
					AND M.ITEM_ID		= B.ITEM_ID
					AND M.OPERATION_ID	= B.OPERATION_ID
					AND M.LINE_ID		= B.LINE_ID
					AND M.ELECTRODE_TYPE= B.ELECTRODE_TYPE
					AND M.MONTH			>= CONVERT(NVARCHAR(6) , @p_today_yyyymmdd) 

				WHEN MATCHED THEN
					UPDATE SET
							LANE_QTY	= B.LANE_QTY
						, UPDATE_ID		= B.UPDATE_ID
						, UPDATE_TIME	= sysdatetime()
						;

				
				-- pancake master 에 lane 값 동기화...기존 lane 삭제 ... 20230331
				DELETE [dbo].[SCM_ITEM_LANE_M_SN]
				FROM [dbo].[SCM_ITEM_LANE_M_SN] A
				JOIN (
					SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID
						 , ISNULL(B.PROD_VERSION_TYPE, 'GENERAL') AS PROD_VERSION_TYPE
						 , A.UPDATE_ID
						 , A.LANE_QTY
					FROM   #TMP_SCP0049_SAVE_NEW_MODEL A, SCM_LINE_M_SN B WITH(NOLOCK)
					WHERE  A.DATA_TYPE = 'LANE_QTY_DATA'
					AND    A.COMPANY_ID     = B.COMPANY_ID
					AND    A.DIVISION_ID    = B.DIVISION_ID
					AND    A.SITE_ID        = B.SITE_ID
					AND    A.PLANT_ID       = B.PLANT_ID
					AND    A.FACTORY_ID     = B.FACTORY_ID
					AND    A.OPERATION_ID   = B.OPERATION_ID
					AND    A.LINE_ID        = B.LINE_ID
					AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
					AND    A.OPERATION_ID IN ('E2000','E3000','E4000')
				) B
				ON	  A.COMPANY_ID        = B.COMPANY_ID
				AND   A.DIVISION_ID       = B.DIVISION_ID
				AND   A.SITE_ID           = B.SITE_ID
				AND   A.PLANT_ID          = B.PLANT_ID
				AND   A.ITEM_ID           = B.ITEM_ID
				AND   A.FACTORY_ID        = B.FACTORY_ID
				AND   A.PROD_VERSION_TYPE = B.PROD_VERSION_TYPE 
				AND   A.LANE_QTY <> B.LANE_QTY -- 저장할 LANE 과 같지 않은 lane 삭제
				WHERE 1=1
				;
				
				-- pancake master 에 lane 값 동기화... 20230331
				MERGE INTO [dbo].[SCM_ITEM_LANE_M_SN] A
				USING (
					SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID
						 , ISNULL((CASE WHEN A.LANE_QTY  = '' THEN 0.0 ELSE CONVERT(NUMERIC(20,10) , A.LANE_QTY) END ),0) AS LANE_QTY
						 , ISNULL(B.PROD_VERSION_TYPE, 'GENERAL') AS PROD_VERSION_TYPE
						 , A.UPDATE_ID
					FROM   #TMP_SCP0049_SAVE_NEW_MODEL A, SCM_LINE_M_SN B WITH(NOLOCK)
					WHERE  A.DATA_TYPE = 'LANE_QTY_DATA'
					AND    A.COMPANY_ID     = B.COMPANY_ID
					AND    A.DIVISION_ID    = B.DIVISION_ID
					AND    A.SITE_ID        = B.SITE_ID
					AND    A.PLANT_ID       = B.PLANT_ID
					AND    A.FACTORY_ID     = B.FACTORY_ID
					AND    A.OPERATION_ID   = B.OPERATION_ID
					AND    A.LINE_ID        = B.LINE_ID
					AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
					AND    A.OPERATION_ID IN ('E2000','E3000','E4000')
				) B
				ON  (
						A.COMPANY_ID        = B.COMPANY_ID
					AND A.DIVISION_ID       = B.DIVISION_ID
					AND A.SITE_ID           = B.SITE_ID
					AND A.PLANT_ID          = B.PLANT_ID
					AND A.ITEM_ID           = B.ITEM_ID
					AND A.FACTORY_ID        = B.FACTORY_ID
					AND A.PROD_VERSION_TYPE = B.PROD_VERSION_TYPE 
					AND A.LANE_QTY          = B.LANE_QTY 
				)
				WHEN MATCHED THEN
					UPDATE SET A.ACTIVE_FLAG = 'Y'
							 , A.UPDATE_ID   = B.UPDATE_ID
							 , A.UPDATE_TIME = GETDATE()
				WHEN NOT MATCHED THEN
					INSERT (
						  COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID
						, ITEM_ID, LANE_QTY
						, SLIT_WIDTH
						, MAIN_LANE_QTY, SUB_LANE_QTY, PATTERN_QTY
						, HALF_SLIT_FLAG, FOIL_ID, ACTIVE_FLAG
						, DESCRIPTION
						, INSERT_ID, INSERT_TIME
						, UPDATE_ID, UPDATE_TIME
						, PC_ROLL_LENGTH, PC_ROLL_LENGTH_UOM
						, GPLM_LANE_QTY, GPLM_MAIN_LANE_QTY, GPLM_SUB_LANE_QTY
						, PROD_VERSION_TYPE
						, JUMBO_ROLL_LENGTH
						, GPLM_PC_ROLL_LENGTH, GPLM_JUMBO_ROLL_LENGTH
					)
					VALUES (
						  B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.FACTORY_ID
						, B.ITEM_ID, B.LANE_QTY
						, 0
						, B.LANE_QTY, 0, 1
						, 'N', NULL, 'Y'
						, ''
						, B.UPDATE_ID, GETDATE()
						, B.UPDATE_ID, GETDATE()
						, NULL, ''
						, NULL, NULL, NULL
						, B.PROD_VERSION_TYPE
						, NULL
						, NULL, NULL
					)
					;

			END
			/* #################################################### */
			/* SCM_MST_ITEM_LINE_ASSIGN_EXCEPT_SN					*/
			/* LANE QTY 정보 UPDATE									*/
			/* #################################################### */
			BEGIN
				MERGE INTO SCM_MST_ITEM_LINE_ASSIGN_EXCEPT_SN M
				USING (
						SELECT COMPANY_ID
							 , DIVISION_ID
							 , SITE_ID
							 , PLANT_ID
							 , FACTORY_ID
							 , ITEM_ID
							 , OPERATION_ID
							 , LINE_ID
							 , ELECTRODE_TYPE
							 , LANE_QTY
							 , UPDATE_ID
						  FROM #TMP_SCP0049_SAVE_NEW_MODEL T
						 WHERE T.DATA_TYPE = 'LANE_QTY_DATA'
						) B
					ON M.COMPANY_ID			= B.COMPANY_ID
					AND M.DIVISION_ID		= B.DIVISION_ID
					AND M.SITE_ID			= B.SITE_ID
					AND M.PLANT_ID			= B.PLANT_ID
					AND M.FACTORY_ID		= B.FACTORY_ID
					AND M.ITEM_ID			= B.ITEM_ID
					AND M.OPERATION_ID		= B.OPERATION_ID
					AND M.LINE_ID			= B.LINE_ID
					AND M.ELECTRODE_TYPE	= B.ELECTRODE_TYPE
					AND CONVERT(NVARCHAR(6) , M.START_TIME,112) >= CONVERT(NVARCHAR(6) , @p_today_yyyymmdd) 

				WHEN MATCHED THEN
					UPDATE SET
							LANE_QTY	= B.LANE_QTY
						, UPDATE_ID		= B.UPDATE_ID
						, UPDATE_TIME	= sysdatetime()
				;
			END

			BEGIN
				MERGE INTO SCM_MST_ITEM_LINE_ASSIGN_SN M
					USING (
							SELECT COMPANY_ID
								 , DIVISION_ID
								 , SITE_ID
								 , PLANT_ID
								 , FACTORY_ID
								 , ITEM_ID
								 , OPERATION_ID
								 , LINE_ID
								 , ELECTRODE_TYPE
								 , DAY_NAME
								 , CASE WHEN OPERATION_ID != 'E2000' OR LANE_QTY = '' THEN 0.0 ELSE ISNULL(convert(NUMERIC(20,10),LANE_QTY),0) END  AS LANE_QTY
								 , CONVERT(INT,DAY_QTY) AS DAY_QTY
								 , UPDATE_ID
							FROM #TMP_SCP0049_SAVE_NEW_MODEL T
						  WHERE T.DATA_TYPE = 'PRIORITY_DATA'
							) B
					   ON M.COMPANY_ID		= B.COMPANY_ID
					  AND M.DIVISION_ID		= B.DIVISION_ID
					  AND M.SITE_ID			= B.SITE_ID
					  AND M.PLANT_ID		= B.PLANT_ID
					  AND M.FACTORY_ID		= B.FACTORY_ID
					  AND M.ITEM_ID			= B.ITEM_ID
					  AND M.OPERATION_ID	= B.OPERATION_ID
					  AND M.LINE_ID			= B.LINE_ID
					  AND M.ELECTRODE_TYPE	= B.ELECTRODE_TYPE
					  AND M.MONTH			= B.DAY_NAME
					  --AND ISNULL(M.LANE_QTY,0) = B.LANE_QTY

					WHEN MATCHED THEN
						UPDATE SET
							  PRIORITY		= B.DAY_QTY
							, UPDATE_ID		= B.UPDATE_ID
							, UPDATE_TIME	= sysdatetime()

					WHEN NOT MATCHED THEN
						INSERT	(
								  COMPANY_ID, DIVISION_ID	, SITE_ID		, PLANT_ID		, FACTORY_ID
								, ITEM_ID	, OPERATION_ID	, LINE_ID		, ELECTRODE_TYPE, MONTH
								, LANE_QTY
								, PRIORITY	, INSERT_ID		, INSERT_TIME	, UPDATE_ID		, UPDATE_TIME
								)
						VALUES  (
					 			  B.COMPANY_ID, B.DIVISION_ID	, B.SITE_ID		, B.PLANT_ID		, B.FACTORY_ID
								, B.ITEM_ID	, B.OPERATION_ID	, LINE_ID		, B.ELECTRODE_TYPE, B.DAY_NAME
								, B.LANE_QTY
								, B.DAY_QTY	, B.UPDATE_ID		, SYSDATETIME()	, B.UPDATE_ID		, SYSDATETIME()
								);
			END

		COMMIT TRAN;

		SELECT @v_mod_cnt = COUNT(1)
		  FROM @SCP0049_HIST
		;

		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  @v_mod_cnt AS result_cnt ;

	END TRY

	BEGIN CATCH 

		  if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리

		  BEGIN
			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			--IF @@TRANCOUNT > 0
			--  COMMIT WORK;
		  END;

		  -- error코드, errror 메시지 반환
		  SELECT 'F' AS result_code;
		  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
		END CATCH;

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	END

