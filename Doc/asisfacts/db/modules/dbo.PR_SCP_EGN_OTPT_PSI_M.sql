




/*  
 * Program ID   : PR_SCP_EGN_OTPT_PSI_M
 * Description  : SCP엔진출력PSI데이터 생성 프로시저  
 *
 * Program History  
 *===================================================================================================  
 *   Date      In Charge	Description  
 *===================================================================================================  
 * 2026.03.27	hrkim		Initial Release : PJ20264226 Next SCM Pilot 설계 및 개발
 *
 */  

CREATE PROCEDURE [dbo].[PR_SCP_EGN_OTPT_PSI_M]
	@P_PLAN_ID	NVARCHAR(100)	= NULL
AS

BEGIN

-- procedure body -- start 
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET NOCOUNT ON; 

	DECLARE @V_PLAN_ID				NVARCHAR(100)	= @P_PLAN_ID;
	DECLARE @V_DIVISION_ID			NVARCHAR(50)	= '';
	DECLARE @V_PLAN_START_YYYYMMDD	NVARCHAR(8)		= '';
	DECLARE @V_PLAN_END_YYYYMMDD	NVARCHAR(8)		= '';
	DECLARE @V_PLAN_GROUP			NVARCHAR(100)	= ''

	-- 실행시간 확인용              
    DECLARE @v_start_time   DATETIME		= SYSDATETIME();              
    DECLARE @v_exec_time    NVARCHAR(10)	= ''			--'[00:00]';    

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_EGN_OTPT_PSI_M';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @v_batch_user   NVARCHAR(150) = N'scm_batch'; 

	BEGIN TRY
	  BEGIN

		-- 시작 LOG  (START)
		SET @v_log_type = 'START';
		SET @v_log_message = '##### Start of procedure #####';     
		SET @v_description = CONCAT('[plan_id=', ISNULL(@V_PLAN_ID,''),  ']')
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_batch_user;
		SET @v_log_message = NULL 

	------- Begin Tran : =======================================================================================
	  BEGIN TRAN   --- transaction 시작  

			-----------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' Plan Master 정보 ' 
			-----------------------------------------------------------------------------------
		    SELECT @V_DIVISION_ID			= PM.ATTRIBUTE1
				  ,@V_PLAN_START_YYYYMMDD	= PM.PLAN_START_DATE
				  ,@V_PLAN_END_YYYYMMDD		= PM.PLAN_END_DATE
				  ,@V_PLAN_GROUP			= PM.ATTRIBUTE2
			 FROM SCP_OPT_ENG_PLAN_MASTER_SN  PM WITH(NOLOCK)
			WHERE PM.PLAN_ID = @V_PLAN_ID

			----------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' DELETE ' 
			----------------------------------------------------------------------------------------------------------
			DELETE TG 
			  FROM SCP_EGN_OTPT_PSI_M TG
			 WHERE TG.PLAN_ID = @V_PLAN_ID 

			----------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' INSERT 생산/출하/소비/재고(IncomingStock)/RTF ' 
			----------------------------------------------------------------------------------------------------------
			;WITH TARGET_DATA AS ( 
				---------------------------------------
				---- 생산
				---------------------------------------
				SELECT OP.PLAN_ID 
					 , OP.PLAN_START_YYYYMMDD
					 , OP.DIVISION_ID
					 , OP.SCM_SITE_ID
					 , OP.ITEM_ID
					 , OP.STAGE					AS STAGE
					 , 'PRODUCTION'				AS MEASURE 
					 , 'P'						AS PSI_TYPE 
					 , OP.OPERATION_GROUP
					 , OP.OPERATION_ID
					 , CASE WHEN OP.PROJECT_CODE IS NULL OR OP.PROJECT_CODE = ''
							THEN '-'
							ELSE OP.PROJECT_CODE
						END						AS PROJECT_CODE 
					 , OP.END_DATE				AS YYYYMMDD -- 생산완료 
					 , OP.OUT_QTY				AS QTY
					 , OP.LINE_ID				AS ETC 
				  FROM SCP_EGN_OTPT_PRDN_M OP WITH(NOLOCK)
				 WHERE 1=1
				   AND OP.PLAN_ID	= @V_PLAN_ID
				-----------------------------------------------
				------ 출하
				-----------------------------------------------
				UNION ALL
				SELECT OS.PLAN_ID 
					 , OS.PLAN_START_YYYYMMDD
					 , OS.DIVISION_ID
					 , OS.FROM_SITE_ID			AS SCM_SITE_ID
					 , OS.ITEM_ID
					 , OS.STAGE	
					 , 'SHIPPING'				AS MEASURE 
					 , 'S'						AS PSI_TYPE 
					 , OS.OPERATION_GROUP
					 , OS.OPERATION_ID
					 , CASE WHEN OS.PROJECT_CODE IS NULL OR OS.PROJECT_CODE = ''
							THEN '-'
							ELSE OS.PROJECT_CODE
						END						AS PROJECT_CODE 
					 , OS.DEPARTURE_DATE		AS YYYYMMDD
					 , OS.QTY
					 , OS.TO_SITE_ID			AS ETC -- to site 
				  FROM SCP_EGN_OTPT_SIPM_M OS WITH(NOLOCK)
				 WHERE 1=1
				   AND OS.PLAN_ID			= @V_PLAN_ID
				-----------------------------------------------
				------ 소비
				-----------------------------------------------
				UNION ALL
				SELECT OC.PLAN_ID 
					 , OC.PLAN_START_YYYYMMDD
					 , OC.DIVISION_ID
					 , OC.SCM_SITE_ID
					 , OC.ITEM_ID
					 , OC.STAGE	
					 , 'CONSUME'				AS MEASURE 
					 , 'S'						AS PSI_TYPE 
					 , OC.OPERATION_GROUP
					 , OC.OPERATION_ID
					 , CASE WHEN OC.PROJECT_CODE IS NULL OR OC.PROJECT_CODE = ''
							THEN '-'
							ELSE OC.PROJECT_CODE
						END						AS PROJECT_CODE 
					 , OC.CONSUMED_DATE			AS YYYYMMDD
					 , OC.CONSUMED_QTY			AS QTY 
					 , OC.TO_ITEM_ID			AS ETC -- 상위품목   
				  FROM SCP_EGN_OTPT_CSP_M OC WITH(NOLOCK)
				 WHERE 1=1
				   AND OC.PLAN_ID			= @V_PLAN_ID
				---------------------------------------
				---- RTF  
				---------------------------------------
				UNION ALL
				SELECT RF.PLAN_ID 
					 , RF.PLAN_START_YYYYMMDD
					 , RF.DIVISION_ID
					 , RF.SCM_SITE_ID
					 , RF.ITEM_ID
					 , RF.STAGE	
					 , RF.MEASURE
					 , 'S'						AS PSI_TYPE 
					 , RF.OPERATION_GROUP
					 , RF.OPERATION_ID
					 , CASE WHEN RF.PROJECT_CODE IS NULL OR RF.PROJECT_CODE = ''
							THEN '-'
							ELSE RF.PROJECT_CODE
						END						AS PROJECT_CODE 
					 , RF.DELIVERY_DATE			AS YYYYMMDD
					 , RF.DELIVERY_QTY			AS QTY 
					 , RF.DEMAND_ITEM_ID		AS ETC --demand group일 수 있음 
				 FROM SCP_EGN_OTPT_RTF_M RF WITH(NOLOCK)
				 WHERE 1=1
				   AND RF.PLAN_ID			= @V_PLAN_ID
				   AND RF.MEASURE			= 'RTF'
				----------------------------------------------------
				---- Incoming Stock  (Intransit 제외) 
				----------------------------------------------------
				UNION ALL 
				SELECT OI.PLAN_ID 
					 , OI.PLAN_START_YYYYMMDD
					 , OI.DIVISION_ID
					 , OI.SCM_SITE_ID
					 , OI.ITEM_ID
					 , OI.STAGE
					 , 'IS'						AS MEASURE	-- Incoming Stock 
					 , 'I'						AS PSI_TYPE 
					 , OI.OPERATION_GROUP
					 , OI.OPERATION_ID
					 , CASE WHEN OI.PROJECT_CODE IS NULL OR OI.PROJECT_CODE = ''
							THEN '-'
							ELSE OI.PROJECT_CODE
						END	AS PROJECT_CODE 
					 , OI.EFFECTIVE_DATE		AS YYYYMMDD
					 , OI.QTY
					 , '-'						AS ETC  
				  FROM SCP_EGN_OTPT_INV_M OI WITH(NOLOCK)		
				 WHERE 1=1
				   AND OI.PLAN_ID			= @V_PLAN_ID
				   AND OI.INVENTORY_TYPE != 'INT'
				----------------------------------------------------
				---- Incoming Stock  (Intransit ETA) 
				----------------------------------------------------
				UNION ALL 
				SELECT OI.PLAN_ID 
					 , OI.PLAN_START_YYYYMMDD
					 , OI.DIVISION_ID
					 , OI.SCM_SITE_ID
					 , OI.ITEM_ID
					 , OI.STAGE
					 , 'INTRANSIT_ETA'			AS MEASURE	-- Incoming Stock 
					 , 'I'						AS PSI_TYPE 
					 , OI.OPERATION_GROUP
					 , OI.OPERATION_ID
					 , CASE WHEN OI.PROJECT_CODE IS NULL OR OI.PROJECT_CODE = ''
							THEN '-'
							ELSE OI.PROJECT_CODE
						END	AS PROJECT_CODE 
					 , OI.EFFECTIVE_DATE		AS YYYYMMDD
					 , OI.QTY
					 , '-'						AS ETC  
				  FROM SCP_EGN_OTPT_INV_M OI WITH(NOLOCK)		
				 WHERE 1=1
				   AND OI.PLAN_ID			= @V_PLAN_ID
				   AND OI.INVENTORY_TYPE	= 'INT'
			)
			INSERT INTO SCP_EGN_OTPT_PSI_M
					( PLAN_ID
					, PLAN_START_YYYYMMDD
					, DIVISION_ID
					, SCM_SITE_ID
					, ITEM_ID
					, STAGE
					, MEASURE
					, PSI_TYPE
					, OPERATION_GROUP
					, OPERATION_ID
					, PROJECT_CODE
					, YYYYMMDD 
					, QTY
					, ETC
					, CREATED_BY
					, CREATION_DATE
					, LAST_UPDATED_BY
					, LAST_UPDATE_DATE 
					, ATTRIBUTE1 )
			SELECT TG.PLAN_ID
				 , TG.PLAN_START_YYYYMMDD
				 , TG.DIVISION_ID
				 , TG.SCM_SITE_ID
				 , TG.ITEM_ID
				 , TG.STAGE
				 , TG.MEASURE
				 , TG.PSI_TYPE
				 , TG.OPERATION_GROUP
				 , TG.OPERATION_ID
				 , TG.PROJECT_CODE
				 , TG.YYYYMMDD
				 , SUM(QTY)				AS QTY
				 , TG.ETC 
				  , @v_program_name		AS CREATED_BY
				  , GETDATE()			AS CREATION_DATE
				  , @v_program_name		AS LAST_UPDATED_BY
				  , GETDATE()			AS LAST_UPDATE_DATE
				  , @V_PLAN_GROUP		AS PLAN_GROUP		-- attribute1 (SHIP_REQ 구분용)
			  FROM TARGET_DATA TG 
			 WHERE 1=1
			GROUP BY 
				   TG.PLAN_ID
				 , TG.PLAN_START_YYYYMMDD
				 , TG.DIVISION_ID
				 , TG.SCM_SITE_ID
				 , TG.ITEM_ID
				 , TG.STAGE
				 , TG.MEASURE
				 , TG.PSI_TYPE
				 , TG.OPERATION_GROUP
				 , TG.OPERATION_ID
				 , TG.PROJECT_CODE
				 , TG.YYYYMMDD
				 , TG.ETC 

			SET @n_log_count = @n_log_count + @@ROWCOUNT ;

			----------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' INSERT WH In  ' 
			---- WH In = Intransit ETA + Ship Plan ETA
			----------------------------------------------------------------------------------------------------------
			;WITH TARGET_DATA AS ( 
				---------------------------------------------
				---- Intransit ETA
				---------------------------------------------
				SELECT OI.PLAN_ID 
					 , OI.PLAN_START_YYYYMMDD
					 , OI.DIVISION_ID
					 , OI.SCM_SITE_ID
					 , OI.ITEM_ID
					 , OI.STAGE					AS STAGE 
					 , 'WH_IN'					AS MEASURE 
					 , 'I'						AS PSI_TYPE 
					 , OI.OPERATION_GROUP
					 , OI.OPERATION_ID
					 , CASE WHEN OI.PROJECT_CODE IS NULL OR OI.PROJECT_CODE = ''
							THEN '-'
							ELSE OI.PROJECT_CODE
						END	AS PROJECT_CODE 
					 , OI.EFFECTIVE_DATE		AS YYYYMMDD
					 , OI.QTY
					 , '-'						AS ETC -- from site id 
				   FROM SCP_EGN_OTPT_INV_M OI WITH(NOLOCK)		
				 WHERE 1=1
				   AND OI.PLAN_ID = @V_PLAN_ID
				   AND OI.INVENTORY_TYPE	= 'INT'
				---------------------------------------------
				---- Ship Plan ETA 
				---------------------------------------------
				UNION ALL
				SELECT OS.PLAN_ID 
					 , OS.PLAN_START_YYYYMMDD
					 , OS.DIVISION_ID
					 , OS.TO_SITE_ID			AS SCM_SITE_ID
					 , OS.ITEM_ID
					 , OS.TO_STAGE				AS STAGE 
					 , 'WH_IN'					AS MEASURE 
					 , 'I'						AS PSI_TYPE 
					 , OS.OPERATION_GROUP
					 , OS.OPERATION_ID
					 , CASE WHEN OS.PROJECT_CODE IS NULL OR OS.PROJECT_CODE = ''
							THEN '-'
							ELSE OS.PROJECT_CODE
						END	AS PROJECT_CODE 
					 , ARRIVAL_DATE				AS YYYYMMDD
					 , OS.QTY
					 , OS.FROM_SITE_ID			AS ETC -- from site id 
				  FROM SCP_EGN_OTPT_SIPM_M OS WITH(NOLOCK)
				 WHERE 1=1
				   AND OS.PLAN_ID = @V_PLAN_ID
			)
			INSERT INTO SCP_EGN_OTPT_PSI_M
					( PLAN_ID
					, PLAN_START_YYYYMMDD
					, DIVISION_ID
					, SCM_SITE_ID
					, ITEM_ID
					, STAGE
					, MEASURE
					, PSI_TYPE
					, OPERATION_GROUP
					, OPERATION_ID
					, PROJECT_CODE
					, YYYYMMDD 
					, QTY
					, ETC
					, CREATED_BY
					, CREATION_DATE
					, LAST_UPDATED_BY
					, LAST_UPDATE_DATE 
					, ATTRIBUTE1 )
			SELECT TG.PLAN_ID
				 , TG.PLAN_START_YYYYMMDD
				 , TG.DIVISION_ID
				 , TG.SCM_SITE_ID
				 , TG.ITEM_ID
				 , TG.STAGE
				 , TG.MEASURE
				 , TG.PSI_TYPE
				 , TG.OPERATION_GROUP
				 , TG.OPERATION_ID
				 , TG.PROJECT_CODE
				 , TG.YYYYMMDD
				 , SUM(QTY)				AS QTY
				 , TG.ETC 
				  , @v_program_name		AS CREATED_BY
				  , GETDATE()			AS CREATION_DATE
				  , @v_program_name		AS LAST_UPDATED_BY
				  , GETDATE()			AS LAST_UPDATE_DATE
				  , @V_PLAN_GROUP		AS PLAN_GROUP		-- attribute1 (SHIP_REQ 구분용)
			  FROM TARGET_DATA TG 
			 WHERE 1=1
			GROUP BY 
				   TG.PLAN_ID
				 , TG.PLAN_START_YYYYMMDD
				 , TG.DIVISION_ID
				 , TG.SCM_SITE_ID
				 , TG.ITEM_ID
				 , TG.STAGE
				 , TG.MEASURE
				 , TG.PSI_TYPE
				 , TG.OPERATION_GROUP
				 , TG.OPERATION_ID
				 , TG.PROJECT_CODE
				 , TG.YYYYMMDD
				 , TG.ETC 

			SET @n_log_count = @n_log_count + @@ROWCOUNT ;
	 
	 
			----------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' INSERT WIP 재공  ' 
			----------------------------------------------------------------------------------------------------------
			;WITH DATE_LIST AS (
				SELECT CM.BASIS_YYYYMMDD AS YYYYMMDD
				  FROM SCM_SYS_CALENDAR_M CM WITH(NOLOCK) 
				 WHERE 1=1
				   AND CM.BASIS_YYYYMMDD BETWEEN @V_PLAN_START_YYYYMMDD
											 AND @V_PLAN_END_YYYYMMDD
			)
			, TARGET_DATA AS ( 
				-------------------------------------------
				-- PLAN 시작 시점 진행중인 활성화 재공
				-------------------------------------------
				SELECT OI.PLAN_ID 
					 , OI.PLAN_START_YYYYMMDD
					 , OI.DIVISION_ID
					 , OI.SCM_SITE_ID
					 , OI.ITEM_ID
					 , OI.STAGE					AS STAGE 
					 , 'WIP'					AS MEASURE 
					 , 'I'						AS PSI_TYPE 
					 , OI.OPERATION_GROUP
					 , OI.OPERATION_ID
					 , CASE WHEN OI.PROJECT_CODE IS NULL OR OI.PROJECT_CODE = ''
							THEN '-'
							ELSE OI.PROJECT_CODE
						END	AS PROJECT_CODE 
					 , DL.YYYYMMDD
					 , OI.QTY
					 , '-'						AS ETC 
				  FROM SCP_EGN_OTPT_INV_M OI WITH(NOLOCK)		
					   INNER JOIN DATE_LIST DL
							   ON DL.YYYYMMDD < OI.EFFECTIVE_DATE 
				 WHERE 1=1
				   AND OI.PLAN_ID		= @V_PLAN_ID
				   AND OI.INVENTORY_TYPE IN ('FOR', 'FOR_HOLD') 
				-------------------------------------------
				-- 공정 WIP
				-------------------------------------------
				UNION ALL
				SELECT OP.PLAN_ID 
					 , OP.PLAN_START_YYYYMMDD
					 , OP.DIVISION_ID
					 , OP.SCM_SITE_ID
					 , OP.ITEM_ID
					 , OP.STAGE					AS STAGE
					 , 'WIP'					AS MEASURE 
					 , 'I'						AS PSI_TYPE 
					 , OP.OPERATION_GROUP
					 , OP.OPERATION_ID
					 , CASE WHEN OP.PROJECT_CODE IS NULL OR OP.PROJECT_CODE = ''
							THEN '-'
							ELSE OP.PROJECT_CODE
						END	AS PROJECT_CODE 
					 , DL.YYYYMMDD
					 , OP.OUT_QTY
					 , OP.LINE_ID				AS ETC 
				  FROM SCP_EGN_OTPT_PRDN_M OP WITH(NOLOCK)
					   INNER JOIN DATE_LIST DL
							   ON DL.YYYYMMDD >= START_DATE
							  AND DL.YYYYMMDD <  END_DATE 
				 WHERE 1=1
				   AND OP.PLAN_ID	= @V_PLAN_ID
			)
			INSERT INTO SCP_EGN_OTPT_PSI_M
					( PLAN_ID
					, PLAN_START_YYYYMMDD
					, DIVISION_ID
					, SCM_SITE_ID
					, ITEM_ID
					, STAGE
					, MEASURE
					, PSI_TYPE
					, OPERATION_GROUP
					, OPERATION_ID
					, PROJECT_CODE
					, YYYYMMDD 
					, QTY
					, ETC
					, CREATED_BY
					, CREATION_DATE
					, LAST_UPDATED_BY
					, LAST_UPDATE_DATE 
					, ATTRIBUTE1 )
			SELECT TG.PLAN_ID
				 , TG.PLAN_START_YYYYMMDD
				 , TG.DIVISION_ID
				 , TG.SCM_SITE_ID
				 , TG.ITEM_ID
				 , TG.STAGE
				 , TG.MEASURE
				 , TG.PSI_TYPE
				 , TG.OPERATION_GROUP
				 , TG.OPERATION_ID
				 , TG.PROJECT_CODE
				 , TG.YYYYMMDD
				 , SUM(QTY)				AS QTY
				 , TG.ETC 
				  , @v_program_name		AS CREATED_BY
				  , GETDATE()			AS CREATION_DATE
				  , @v_program_name		AS LAST_UPDATED_BY
				  , GETDATE()			AS LAST_UPDATE_DATE
				  , @V_PLAN_GROUP		AS PLAN_GROUP		-- attribute1 (SHIP_REQ 구분용)
			  FROM TARGET_DATA TG 
			 WHERE 1=1
			GROUP BY 
				   TG.PLAN_ID
				 , TG.PLAN_START_YYYYMMDD
				 , TG.DIVISION_ID
				 , TG.SCM_SITE_ID
				 , TG.ITEM_ID
				 , TG.STAGE
				 , TG.MEASURE
				 , TG.PSI_TYPE
				 , TG.OPERATION_GROUP
				 , TG.OPERATION_ID
				 , TG.PROJECT_CODE
				 , TG.YYYYMMDD
				 , TG.ETC 

			SET @n_log_count = @n_log_count + @@ROWCOUNT ;

			---------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' EOH 계산을 위한 데이터 추출 ' 
			---------------------------------------------------------------------------------
			IF OBJECT_ID('tempdb..#PSI_BASE_DATA_0_FILLED') is not null drop table #PSI_BASE_DATA_0_FILLED; 

			;WITH SALES_SITE_LIST AS (
				SELECT DISTINCT SCM_SITE_ID
				  FROM SCM_MST_SITE SM WITH(NOLOCK)
				 WHERE SM.SITE_TYPE = 'SALES'
				    AND SM.VALID_YN = 'Y'
			), PSI_BASE_DATA AS (
				SELECT BD.SCM_SITE_ID
					  ,BD.ITEM_ID
					  ,CASE WHEN SS.SCM_SITE_ID IS NOT NULL	
							THEN '-'		-- Sales Site Stage 
							ELSE BD.STAGE
						END AS STAGE 
					  ,BD.OPERATION_GROUP
					  ,BD.OPERATION_ID
					  ,BD.YYYYMMDD
					  ,CONVERT(FLOAT,SUM (CASE WHEN BD.PSI_TYPE = 'I' THEN BD.QTY ELSE 0 END))	AS I_QTY 
					  ,CONVERT(FLOAT,SUM (CASE WHEN BD.PSI_TYPE = 'P' THEN BD.QTY ELSE 0 END))	AS P_QTY 
					  ,CONVERT(FLOAT,SUM (CASE WHEN BD.PSI_TYPE = 'S' THEN BD.QTY ELSE 0 END))	AS S_QTY
				 FROM SCP_EGN_OTPT_PSI_M BD
					  LEFT JOIN SALES_SITE_LIST SS
							 ON SS.SCM_SITE_ID = BD.SCM_SITE_ID 
				WHERE 1=1
				  AND BD.PLAN_ID = @V_PLAN_ID
				  AND BD.MEASURE NOT IN ('WIP', 'INTRANSIT', 'INTRANSIT_ETA') -- 재공 및 Intransit, Intransit ETA(WH In에 포함) 제외
				GROUP BY BD.SCM_SITE_ID
						,BD.ITEM_ID
					    ,CASE WHEN SS.SCM_SITE_ID IS NOT NULL	
							  THEN '-'		-- Sales Site Stage 
							  ELSE BD.STAGE
						  END
					    ,BD.OPERATION_GROUP
					    ,BD.OPERATION_ID
				    ,BD.YYYYMMDD
			)
			SELECT BD.SCM_SITE_ID
				  ,BD.ITEM_ID
				  ,BD.STAGE
				  ,BD.OPERATION_GROUP
				  ,BD.OPERATION_ID
				  ,CONVERT(NVARCHAR(8), DATEADD(DAY,1, CM.BASIS_DATE), 112)														AS YYYYMMDD_NEXT
				  ,CM.BASIS_YYYYMMDD																							AS YYYYMMDD
				  ,CONVERT(FLOAT, ISNULL(MAX(CASE WHEN BD.YYYYMMDD = CM.BASIS_YYYYMMDD THEN I_QTY		ELSE NULL END),0.0)) 	AS I_QTY
				  ,CONVERT(FLOAT, ISNULL(MAX(CASE WHEN BD.YYYYMMDD = CM.BASIS_YYYYMMDD THEN P_QTY		ELSE NULL END),0.0)) 	AS P_QTY
				  ,CONVERT(FLOAT, ISNULL(MAX(CASE WHEN BD.YYYYMMDD = CM.BASIS_YYYYMMDD THEN S_QTY		ELSE NULL END),0.0)) 	AS S_QTY
			 INTO #PSI_BASE_DATA_0_FILLED
			 FROM PSI_BASE_DATA BD
				  INNER JOIN SCM_SYS_CALENDAR_M  CM WITH(NOLOCK)
						  ON CM.BASIS_YYYYMMDD BETWEEN @V_PLAN_START_YYYYMMDD	-- plan_starT_yyyymmdd 
												   AND @V_PLAN_END_YYYYMMDD		-- horizon_end_date 
			WHERE 1=1
			GROUP BY BD.SCM_SITE_ID
					,BD.ITEM_ID
					,BD.STAGE
				    ,BD.OPERATION_GROUP
				    ,BD.OPERATION_ID
					,CM.BASIS_YYYYMMDD
					,CONVERT(NVARCHAR(8), DATEADD(DAY,1, CM.BASIS_DATE), 112)	

			---------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' EOH 계산 - Insert  ' 
			-- 당일EOH = 당일BOH + I 수량 + P 수량 - S 수량 
			-- I : Incoming Stock + WH_IN 
			-- S : 출하 수량 + 소비 수량  + RTF 수량  
			---------------------------------------------------------------------------------
			create index #PSI_BASE_DATA_0_FILLED_IDX1 ON #PSI_BASE_DATA_0_FILLED(SCM_SITE_ID, ITEM_ID, STAGE, OPERATION_GROUP, OPERATION_ID,  YYYYMMDD) 

			;WITH RECURSIVE_DATA AS (
				SELECT BD.SCM_SITE_ID
					  ,BD.ITEM_ID
					  ,BD.STAGE
					  ,BD.OPERATION_GROUP
					  ,BD.OPERATION_ID
					  ,BD.YYYYMMDD
					  ,BD.YYYYMMDD_NEXT
					  ,CONVERT(FLOAT,0.0)														AS PRVS_EOH_QTY
					  ,CONVERT(FLOAT, BD.I_QTY)													AS I_QTY
					  ,CONVERT(FLOAT, BD.I_QTY)													AS BOH_QTY 
					  ,CONVERT(FLOAT, BD.P_QTY )												AS P_QTY
					  ,CONVERT(FLOAT, BD.S_QTY )												AS S_QTY
					  ,CONVERT(FLOAT,CONVERT(NUMERIC(20,10), BD.I_QTY + BD.P_QTY - BD.S_QTY))	AS EOH_QTY
				 FROM #PSI_BASE_DATA_0_FILLED BD 
				WHERE 1=1
				  AND BD.YYYYMMDD = @V_PLAN_START_YYYYMMDD   --- plan_start_date 
				UNION ALL 
				SELECT NBD.SCM_SITE_ID
					  ,NBD.ITEM_ID
					  ,NBD.STAGE
					  ,NBD.OPERATION_GROUP
					  ,NBD.OPERATION_ID
					  ,NBD.YYYYMMDD
					  ,NBD.YYYYMMDD_NEXT
					  ,CONVERT(FLOAT, RD.EOH_QTY)																AS PRVS_EOH_QTY
					  ,CONVERT(FLOAT, NBD.I_QTY)																AS I_QTY
					  ,CONVERT(FLOAT, RD.EOH_QTY + NBD.I_QTY)													AS BOH_QTY 
					  ,CONVERT(FLOAT, NBD.P_QTY)																AS P_QTY
					  ,CONVERT(FLOAT, NBD.S_QTY)																AS S_QTY
					  ,CONVERT(FLOAT, CONVERT(NUMERIC(20,10), RD.EOH_QTY + NBD.I_QTY + NBD.P_QTY - NBD.S_QTY))	AS EOH_QTY
				 FROM #PSI_BASE_DATA_0_FILLED NBD 
					  INNER JOIN RECURSIVE_DATA RD 
							  ON RD.SCM_SITE_ID				= NBD.SCM_SITE_ID
							 AND RD.ITEM_ID					= NBD.ITEM_ID
							 AND RD.STAGE					= NBD.STAGE
							 AND RD.OPERATION_GROUP			= NBD.OPERATION_GROUP
							 AND RD.OPERATION_ID			= NBD.OPERATION_ID
							 AND RD.YYYYMMDD_NEXT			= NBD.YYYYMMDD
				WHERE 1=1
			)
			INSERT INTO SCP_EGN_OTPT_PSI_M
					( PLAN_ID
					, PLAN_START_YYYYMMDD
					, DIVISION_ID
					, SCM_SITE_ID
					, ITEM_ID
					, STAGE
					, MEASURE
					, PSI_TYPE
					, OPERATION_GROUP
					, OPERATION_ID
					, PROJECT_CODE
					, YYYYMMDD 
					, QTY
					, ETC
					, CREATED_BY
					, CREATION_DATE
					, LAST_UPDATED_BY
					, LAST_UPDATE_DATE 
					, ATTRIBUTE1 )
			SELECT @V_PLAN_ID				AS PLAN_ID
				  ,@V_PLAN_START_YYYYMMDD	AS PLAN_START_YYYYYMMDD
				  ,@V_DIVISION_ID			AS DIVISION_ID
				  ,RD.SCM_SITE_ID
				  ,RD.ITEM_ID
				  ,RD.STAGE
				  ,'EOH'					AS MEASURE
				  ,'I'						AS PSI_TYPE
				  ,RD.OPERATION_GROUP
				  ,RD.OPERATION_ID
				  ,'-'						AS PROJECT_CODE
				  ,RD.YYYYMMDD
				  ,RD.EOH_QTY
				  ,NULL						AS ETC
				  ,@v_program_name			AS CREATED_BY
				  ,GETDATE()				AS CREATION_DATE
				  ,@v_program_name			AS LAST_UPDATED_BY
				  ,GETDATE()				AS LAST_UPDATE_DATE
				  , @V_PLAN_GROUP			AS PLAN_GROUP		-- attribute1 (SHIP_REQ 구분용)
			 FROM RECURSIVE_DATA RD
			OPTION(MAXRECURSION 1000) 

			SET @n_log_count = @n_log_count + @@ROWCOUNT ;

	  COMMIT TRAN ;  --- transaction 종료  
	------- End Tran : ==========================================================================================================

	  END			    
	END TRY

	BEGIN CATCH                  
		if (xact_state() <> 0) ROLLBACK TRAN; 

		-- ERROR LOG                  
		SET @v_log_type = N'ERROR';                  
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));                  
		SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE());                  
		SET @d_event_date = SYSDATETIME();                  
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name                  
		                          ,@p_log_type      = @v_log_type                  
		                          ,@p_log_count     = @n_log_count                   
		                          ,@p_log_message   = @v_log_message                   
		                          ,@p_description   = @v_description                   
		                          ,@p_event_date    = @d_event_date                   
		                          ,@p_user_id       = @v_batch_user                  
		                          ;                  
		PRINT @v_log_message      + ' : ' + @v_description ;  
		RETURN -1;    
		
    END CATCH;   

    SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +                 
                         REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))                 
    -- 종료 LOG                  
    SET @v_log_type = N'END';                  
    SET @v_log_message = N'##### END of procedure #####';                  
    SET @v_description = CONCAT('[plan_id=', ISNULL(@V_PLAN_ID,''),  ']['  + @v_exec_time + ']') ;          
    SET @d_event_date  = SYSDATETIME()  ;                 
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
                              ,@p_log_type      =@v_log_type                  
                              ,@p_log_count     =@n_log_count                   
                              ,@p_log_message   =@v_log_message                   
                              ,@p_description   =@v_description                   
                              ,@p_event_date    =@d_event_date                   
                              ,@p_user_id       =@v_batch_user                  
                              ;                  
	PRINT @v_log_message      + ' : ' + @v_description ;          
	RETURN 1;    

END
