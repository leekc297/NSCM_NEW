



CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_EE_INPUT_BOM_ELEC]
     @P_PLAN_ID             NVARCHAR(50)
    ,@V_DIVISION_ID         NVARCHAR(20)
    ,@V_GROUP_ID            NVARCHAR(20)
    ,@V_PLAN_START_YYYYMMDD NVARCHAR(8)
    ,@V_PLAN_END_YYYYMMDD   NVARCHAR(8)
AS
BEGIN
	--2025.02.05 Y.S.H Initial Release
	------------------------------------------------------------------------  
    -- Procedure 기본조건.
	------------------------------------------------------------------------
	SET XACT_ABORT ON;
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	------------------------------------------------------------------------  
	
	------------------------------------------------------------------------
	-- Set Prameter
	------------------------------------------------------------------------
    DECLARE @V_PROGRAM_NAME        NVARCHAR(150) = 'PR_SCP_OPT_ENG_EE_INPUT_BOM_ELEC';
    DECLARE @V_PLAN_ID             NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT        NVARCHAR(1000);
    DECLARE @V_DETAIL_DATE         DATETIME;
	------------------------------------------------------------------------
	DECLARE @P_BASE_YYYYMMDD	NVARCHAR(8) = NULL;
	DECLARE @P_BASE_DATE		DATE		= NULL;
	------------------------------------------------------------------------
	-- Set Base Date
	------------------------------------------------------------------------
	IF 	ISNULL(@P_BASE_YYYYMMDD, '') = '' 
	------------------------------------------------------------------------
			SET @P_BASE_DATE  = CONVERT(DATE, CONVERT(NVARCHAR(8), GETDATE(), 112) , 112) ; 
	------------------------------------------------------------------------
	ELSE 
	------------------------------------------------------------------------
			SET @P_BASE_DATE  = CONVERT(DATE,  @P_BASE_YYYYMMDD, 112) ;
	------------------------------------------------------------------------

	PRINT '------------------------------------------------';
	PRINT '@P_BASE_YYYYMMDD	= ' + @P_BASE_YYYYMMDD;
	PRINT '@P_BASE_DATE		= ' + CONVERT(NVARCHAR(8),@P_BASE_DATE,112);
	PRINT '------------------------------------------------';
	
    ------------------------------------------------------------------------ 
    -- Step 3. SCP_OPT_ENG_ENGINE_DATA_CREATE_L_N 생성
	------------------------------------------------------------------------
	EXEC PR_SCP_OPT_ENG_LOG_CRE_PROC 'I','INPUT',@V_PLAN_ID,@V_PROGRAM_NAME,'START',NULL,NULL,NULL,@V_PLAN_ID


	-- 임시 실행시간 확인용              
    DECLARE @v_start_time   DATETIME   = SYSDATETIME();              
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';    

	BEGIN TRY
		BEGIN
			---------------------------------------------------------------------------------------------------------------------------------------
			PRINT convert(varchar(30), getdate(), 121) +  N' ### 0 #SCM_MST_ITEM_SN - 품목 Master데이터 추출'
			---------------------------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#DIVISION') IS NOT NULL
			BEGIN 
				DROP TABLE  #DIVISION;
			END;

			/*
			SELECT DIVISION_ID 
			INTO #DIVISION
			FROM SCM_MST_DIVISION WITH(NOLOCK)
			WHERE  VALID_YN = 'Y'
			AND    ATTRIBUTE3 <> 'EE'
			AND    ATTRIBUTE4 = (SELECT ATTRIBUTE4 FROM SCM_MST_DIVISION WITH(NOLOCK) WHERE DIVISION_ID = @V_DIVISION_ID) -- 전극 Division 변수
			;*/

			SELECT DISTINCT SMS.DIVISION_ID 
			INTO   #DIVISION
			FROM   SCP_OPT_ENG_MODEL_LIST_N_SN SML WITH(NOLOCK)
				  ,SCM_MST_SITE				   SMS WITH(NOLOCK) 
			WHERE  SML.SCM_SITE_ID = SMS.SCM_SITE_ID 
			AND    SML.PLAN_ID	 = @V_PLAN_ID


			IF  OBJECT_ID('tempdb..#SCM_MST_ITEM_SN')  IS NOT NULL
				DROP TABLE #SCM_MST_ITEM_SN ; 

			SELECT A.ITEM_ID
				  ,A.COMPANY_ID
				  ,A.SITE_ID
				  ,A.DIVISION_ID
				  ,A.ACTIVE_FLAG
				  ,A.SCP_OPERATION_GROUP
				  ,A.SCP_FLOW_ID
				  ,A.ITEM_CLASS
			INTO #SCM_MST_ITEM_SN
			FROM SCM_MST_ITEM_SN A WITH(NOLOCK)

				INNER JOIN #DIVISION D WITH(NOLOCK)
				ON A.DIVISION_ID = D.DIVISION_ID

			WHERE 1=1
			  --AND DIVISION_ID   = @V_DIVISION_ID
			  AND A.ACTIVE_FLAG	= 'Y'
			  AND (A.SCP_OPERATION_GROUP = 'A' 
				   OR 
				   A.ITEM_CLASS in ('ES0301'	-- [APCAN]Anode Pancake
	  							, 'ES0302'	-- [APCCA]Cathode Pancake
	  							, 'ES0303'	-- [APCCS]Cathode(One Side) Pancake
	  							, 'ES0305')	-- [APCAS]Anode(One Side) Pancake
				  )
			
			---------------------------------------------------------------------------------------------------------------------------------------
			PRINT convert(varchar(30), getdate(), 121) +  N' ### 1.1 #BASE_DATA_0 추출 - SCM_MST_BOM_ENG_SN <- [LGCE_FP_TR].[dbo].[SCM_BOM_M]'
			---------------------------------------------------------------------------------------------------------------------------------------
			IF  OBJECT_ID('tempdb..#BASE_DATA_0')  IS NOT NULL
				DROP TABLE #BASE_DATA_0 ; 

			SELECT B.*
				 ,CONVERT(NUMERIC(20, 10) , CHILD_QTY / CASE WHEN ISNULL(PARENT_QTY, 1.0) != 0 THEN PARENT_QTY ELSE 1.0 END) AS ACCUMULATED_CHILD_QTY 
				 ,FORMAT(CONVERT(NUMERIC(4), ISNULL(ALT_PRIORITY, '0')) , '000')  AS ACC_PRIORITY 
				 ,R.SCP_FLOW_ID				AS PARENT_FLOW_ID
				 ,R.SCP_OPERATION_GROUP		AS PARENT_OPERATION_GROUP
				 ,CI.SCP_FLOW_ID			AS CHILD_FLOW_ID
				 ,CI.SCP_OPERATION_GROUP	AS CHILD_OPERATION_GROUP 
				 ,CI.ITEM_CLASS             AS CHILD_ITEM_CLASS 
				 ,CASE WHEN CI.ITEM_CLASS = 'ES0301'				THEN 'ANODE'
					   WHEN CI.ITEM_CLASS = 'ES0302'				THEN 'CATHODE'
					   WHEN CI.ITEM_CLASS IN ('ES0303', 'ES0305')	THEN 'ONESIDE'
					   ELSE '-'
				  END						AS CHILD_ELEC_TYPE
				 ,ROW_NUMBER() OVER (PARTITION BY B.COMPANY_ID
												 ,B.DIVISION_ID
												 ,B.SITE_ID
												 ,B.PLANT_ID
												 ,B.PARENT_ITEM_ID
												 ,B.CHILD_ITEM_ID
										ORDER BY  B.BOM_VERSION_ID DESC
												, B.KEY_DATE       DESC 
										) AS KEY_DATE_RN
			INTO #BASE_DATA_0
			FROM SCM_MST_BOM_ENG_SN    B  WITH(NOLOCK)
					 INNER JOIN #SCM_MST_ITEM_SN  R  WITH(NOLOCK)
					 		 ON R.ITEM_ID		= B.PARENT_ITEM_ID
							AND R.COMPANY_ID	= B.COMPANY_ID
							AND R.DIVISION_ID	= B.DIVISION_ID
							AND R.SITE_ID		= B.SITE_ID
							AND R.SCP_OPERATION_GROUP	= 'A'
					 INNER JOIN #SCM_MST_ITEM_SN CI WITH(NOLOCK)
					 		 ON CI.ITEM_ID		= B.CHILD_ITEM_ID
							AND CI.COMPANY_ID	= B.COMPANY_ID
							AND CI.DIVISION_ID	= B.DIVISION_ID
							AND CI.SITE_ID		= B.SITE_ID
			WHERE 1=1
			  AND EFF_START_DATE <= @P_BASE_DATE
			  AND (EFF_END_DATE IS NULL OR EFF_END_DATE >= @P_BASE_DATE)   

			---------------------------------------------------------------------------------------------------------------------------------------
			PRINT convert(varchar(30), getdate(), 121) +  N' ### 1.2 #BASE_DATA 추출'
			---------------------------------------------------------------------------------------------------------------------------------------
			IF  OBJECT_ID('tempdb..#BASE_DATA')  IS NOT NULL
				DROP TABLE #BASE_DATA ; 

			SELECT BD.*
			     ,FORMAT(
				 		DENSE_RANK() OVER (PARTITION BY DIVISION_ID
													   ,PARENT_ITEM_ID
													   ,ALT_ID
										ORDER BY ALT_PRIORITY
										) 
						  - 1
						,'000'
						) AS ALT_ID_PRIORITY
			INTO #BASE_DATA
			FROM (
					SELECT
							DIVISION_ID
						   ,PLANT_ID
						   ,PARENT_ITEM_ID
						   ,CHILD_ITEM_ID
						   ,PARENT_QTY
						   ,CHILD_QTY
						   ,ALT_ID
						   ,ALT_PRIORITY
						   ,ALT_RATE
						   ,ACCUMULATED_CHILD_QTY
						   ,ACC_PRIORITY
						   ,PARENT_FLOW_ID
						   ,PARENT_OPERATION_GROUP
						   ,KEY_DATE_RN
						   ,CHILD_FLOW_ID
						   ,CHILD_OPERATION_GROUP
						   ,CHILD_ITEM_CLASS
						   ,CHILD_ELEC_TYPE
						   ,ROW_NUMBER() OVER (PARTITION BY DIVISION_ID
														   ,PARENT_ITEM_ID
														   ,CHILD_ITEM_ID
													ORDER BY PLANT_ID ) AS PLANT_PRIORITY 
					FROM #BASE_DATA_0 -- 20240108 
					WHERE 1=1
					  AND KEY_DATE_RN = 1
				) BD 
			WHERE 1=1
			  AND PLANT_PRIORITY = 1

			-- index 생성 
			CREATE NONCLUSTERED INDEX tmp_idx_1 on #BASE_DATA(DIVISION_ID
															, PARENT_ITEM_ID
															, CHILD_ITEM_ID
															) ;

			-----------------------------------------------------------------------------------------------------------------------------------------
			PRINT convert(varchar(30), getdate(), 121) +  N' ### 2. #TREE_MODEL 데이터 추출 - 최상위 Cell Model부터 전극 Final 품목까지 전개'
			-----------------------------------------------------------------------------------------------------------------------------------------
			IF  OBJECT_ID('tempdb..#TREE_MODEL')  IS NOT NULL 
				DROP TABLE #TREE_MODEL;

			;WITH TREE_MODEL AS (
				SELECT  1					AS NLEVEL 
					   ,BD.DIVISION_ID
					   ,BD.PARENT_ITEM_ID	AS MODEL_ID 
					   ,BD.PARENT_ITEM_ID
					   ,BD.CHILD_ITEM_ID
					   ,CONVERT(NVARCHAR(4000), CONCAT(BD.PARENT_ITEM_ID  , '^' , BD.CHILD_ITEM_ID))	AS CONCATENATE_ITEM 
					   ,CONVERT(NVARCHAR(1000), CONCAT('1', ISNULL(BD.ACC_PRIORITY,		'000')))		AS ACC_PRIORITY 
					   ,CONVERT(NVARCHAR(1000), ISNULL(BD.ALT_ID_PRIORITY,	'000'))						AS ALT_ID_PRIORITY
					   ,BD.ALT_ID
					   ,BD.ALT_PRIORITY
					   ,BD.PARENT_QTY
					   ,BD.CHILD_QTY
					   ,BD.ACCUMULATED_CHILD_QTY
					   ,BD.PARENT_FLOW_ID
					   ,BD.PARENT_OPERATION_GROUP 
					   ,BD.CHILD_FLOW_ID
					   ,BD.CHILD_OPERATION_GROUP 
					   ,BD.CHILD_ITEM_CLASS 
					   ,BD.CHILD_ELEC_TYPE
					FROM #BASE_DATA  BD
					WHERE 1=1
					  --AND BD.PARENT_FLOW_ID  in ('A3000', 'A9000') 
					 UNION ALL 
				SELECT  P.NLEVEL+1			AS NLEVEL 
					   ,C.DIVISION_ID
					   ,P.MODEL_ID
					   ,C.PARENT_ITEM_ID
					   ,C.CHILD_ITEM_ID
					   ,CONVERT(NVARCHAR(4000), CONCAT(P.CONCATENATE_ITEM  , '^' , C.CHILD_ITEM_ID) )				AS CONCATENATE_ITEM 
					   ,CONVERT(NVARCHAR(1000), CONCAT(P.ACC_PRIORITY		, ISNULL(C.ACC_PRIORITY,    '000')))	AS ACC_PRIORITY 
					   ,CONVERT(NVARCHAR(1000), CONCAT(P.ALT_ID_PRIORITY	, ISNULL(C.ALT_ID_PRIORITY, '000')))	AS ALT_ID_PRIORITY 
					   ,C.ALT_ID
					   ,C.ALT_PRIORITY
					   ,C.PARENT_QTY
					   ,C.CHILD_QTY
					   ,CONVERT(NUMERIC(20, 10), P.ACCUMULATED_CHILD_QTY * C.ACCUMULATED_CHILD_QTY)			AS ACCUMULATED_CHILD_QTY
					   ,C.PARENT_FLOW_ID
					   ,C.PARENT_OPERATION_GROUP 
					   ,C.CHILD_FLOW_ID
					   ,C.CHILD_OPERATION_GROUP 
					   ,C.CHILD_ITEM_CLASS 
					   ,C.CHILD_ELEC_TYPE
					FROM TREE_MODEL P
						 INNER JOIN #BASE_DATA C
								 ON C.DIVISION_ID    = P.DIVISION_ID   
								AND C.PARENT_ITEM_ID = P.CHILD_ITEM_ID
					WHERE 1=1
				)
			SELECT T.*
				  ,CONCAT(T.ALT_ID_PRIORITY, REPLICATE('0', 3*(T.CHILD_NLEVEL_MAX - T.NLEVEL))) AS ALT_ID_PRIORITY_NEW
			INTO #TREE_MODEL   
			FROM ( 
					SELECT TM.NLEVEL
						  ,TM.DIVISION_ID
						  ,TM.MODEL_ID
						  ,TM.PARENT_ITEM_ID
						  ,TM.CHILD_ITEM_ID
						  ,TM.CONCATENATE_ITEM
						  ,TM.ACC_PRIORITY
						  ,TM.ALT_ID_PRIORITY
						  ,TM.ALT_ID
						  ,TM.ALT_PRIORITY
						  ,TM.PARENT_QTY
						  ,TM.CHILD_QTY
						  ,TM.ACCUMULATED_CHILD_QTY
						  ,TM.PARENT_FLOW_ID
						  ,TM.PARENT_OPERATION_GROUP
						  ,TM.CHILD_FLOW_ID
						  ,TM.CHILD_OPERATION_GROUP
						  ,TM.CHILD_ITEM_CLASS
						  ,TM.CHILD_ELEC_TYPE 
						  ,MAX(TM.NLEVEL) OVER (PARTITION BY TM.DIVISION_ID
															,TM.MODEL_ID
															,TM.CHILD_ITEM_ID
															,TM.CHILD_ITEM_CLASS
															,TM.CHILD_ELEC_TYPE)	AS CHILD_NLEVEL_MAX
					FROM TREE_MODEL  TM 
					WHERE 1=1
			) T
			Option (MaxRecursion 7)
			;

			-----------------------------------------------------------------------------------------------------------------------------------------
			PRINT convert(varchar(30), getdate(), 121) +  N' ### 3. SCP BOM Elec 대상 데이터 추출 - Child가 전극 Final 품목인 데이터'
			-----------------------------------------------------------------------------------------------------------------------------------------
			IF  OBJECT_ID('tempdb..#SCP_BOM_ELEC_TARGET')  IS NOT NULL
				DROP TABLE #SCP_BOM_ELEC_TARGET ; 

			SELECT B.DIVISION_ID
				  ,B.MODEL_ID					AS PARENT_ITEM_ID
				  ,B.CHILD_ITEM_ID
				  ,B.CHILD_ITEM_CLASS			-- child_item_id에 종속적인 값
				  ,B.CHILD_ELEC_TYPE			-- child_item_id에 종속적인 값
				  ,B.ALT_ID_PRIORITY_NEW
				  ,MIN(ACC_PRIORITY)			AS ACC_PRIORITY
				  ,SUM(B.ACCUMULATED_CHILD_QTY)	AS ACCUMULATED_CHILD_QTY
				  ,ROW_NUMBER() OVER (PARTITION BY B.DIVISION_ID
				  								  ,B.MODEL_ID
				  								  ,B.CHILD_ITEM_ID
										  ORDER BY ALT_ID_PRIORITY_NEW
										)		AS ACC_CHILD_QTY_PRIORITY 
			INTO #SCP_BOM_ELEC_TARGET
			FROM #TREE_MODEL B 
				 INNER JOIN SCM_MST_FINAL_ITEM_V F WITH(NOLOCK) 
						 ON F.DIVISION_ID	= B.DIVISION_ID
						AND F.ITEM_ID		= B.CHILD_ITEM_ID 
			WHERE 1=1 
			  AND B.CHILD_ITEM_CLASS IN ('ES0301', 'ES0302', 'ES0303', 'ES0305') -- 전극
			  AND B.CHILD_ITEM_ID IN (  SELECT SML.ITEM_ID
										FROM   SCP_OPT_ENG_MODEL_LIST_N_SN SML WITH(NOLOCK)
										WHERE  SML.PLAN_ID = @P_PLAN_ID )
			GROUP BY B.DIVISION_ID
					,B.MODEL_ID
					,B.CHILD_ITEM_ID
					,B.CHILD_ITEM_CLASS
					,B.CHILD_ELEC_TYPE
					,B.ALT_ID_PRIORITY_NEW

			-----------------------------------------------------------------------------------------------------------------------------------------
			PRINT convert(varchar(30), getdate(), 121) +  N' ### 4. 최신BOM 기준 SCP_YN 설정'
			-----------------------------------------------------------------------------------------------------------------------------------------
			IF  OBJECT_ID('tempdb..#SCP_BOM_ELEC_TARGET_FINAL')  IS NOT NULL 
				DROP TABLE #SCP_BOM_ELEC_TARGET_FINAL ;

			; WITH SCP_BOM_ELEC_TARGET AS (
				SELECT BT.*
					  ,ROW_NUMBER() OVER (PARTITION BY BT.DIVISION_ID
													  ,BT.PARENT_ITEM_ID
													  ,BT.CHILD_ELEC_TYPE
											  ORDER BY BT.ALT_ID_PRIORITY_NEW
													  ,BT.ACCUMULATED_CHILD_QTY DESC 
													  ,BT.ACC_PRIORITY
													  ,BT.CHILD_ITEM_ID
											)  AS SCP_YN_PRIORITY 

				 FROM #SCP_BOM_ELEC_TARGET  BT 
				WHERE 1=1
				  AND ACC_CHILD_QTY_PRIORITY = 1 
			)
			SELECT BT.*
				  ,CASE WHEN BT.SCP_YN_PRIORITY = 1 
						THEN 'Y' 
						ELSE 'N' 
					END AS SCP_YN 
			 INTO #SCP_BOM_ELEC_TARGET_FINAL
			 FROM SCP_BOM_ELEC_TARGET BT
			WHERE 1=1 

		--------------------------------------------------------------- 최종 결과 반영 --------------------------------------------------------------

		BEGIN TRAN
			/*
			-----------------------------------------------------------------------------------------------------------------------------------------
			PRINT convert(varchar(30), getdate(), 121) +  N' ### 5.1 최종 대상에 없는 기 생성 데이터 삭제 '
			-----------------------------------------------------------------------------------------------------------------------------------------
			DELETE TGT 
			FROM SCP_OPT_ENG_BOM_ELEC_SN TGT WITH(NOLOCK)
			WHERE 1=1
			  AND NOT EXISTS ( SELECT  TOP 1 *
							   FROM #SCP_BOM_ELEC_TARGET_FINAL F
							  WHERE F.DIVISION_ID		= TGT.DIVISION_ID
								AND F.PARENT_ITEM_ID	= TGT.PARENT_ITEM_ID
								AND F.CHILD_ITEM_ID		= TGT.CHILD_ITEM_ID
								) 
			;*/
	
			-----------------------------------------------------------------------------------------------------------------------------------------
			PRINT convert(varchar(30), getdate(), 121) +  N' ### 5.2 INSERT INTO ';
			-----------------------------------------------------------------------------------------------------------------------------------------
			/*-----------------------------------------------------------------------------------------------------------------------------------------
            -- 2026.03.19 Minyong Lee : BOM_ELEC에서 사용자가 SCP_YN 수정한 건 반영 안되는 오류 대응 건
            --
            -- PR_SCP_MST_BOM_ELEC 로직 복사에서 잘못된 JOIN 테이블 및 MERGE INTO 구문 사용 식별
            -- - MERGE INTO -> INSERT 구문으로 변경
            -- - UI에서 SCP_YN 수정된 데이터 (DIVISION/PARENT/ELEC_TYPE별로) UI 변경된 건이 존재하는지 식별하고
            -- - 수정된 데이터의 경우 SCP_MST_BOM_ELEC 테이블의 현재 SCP_YN 플래그 값 기준으로 최적화 Input 생성되도록 조치 */
            WITH SRC AS (
			    SELECT @P_PLAN_ID AS PLAN_ID
				          ,F.DIVISION_ID
					      ,F.PARENT_ITEM_ID
					      ,F.CHILD_ITEM_ID
					      ,F.CHILD_ELEC_TYPE
					      ,F.CHILD_ITEM_CLASS 
					      ,F.ACC_PRIORITY
					      ,F.ALT_ID_PRIORITY_NEW
					      ,F.ACCUMULATED_CHILD_QTY
					      ,F.SCP_YN_PRIORITY
                          ,CASE
                               WHEN U.UI_UPDATED = 'Y' THEN U2.SCP_YN
                               ELSE F.SCP_YN
                           END AS SCP_YN
				    FROM #SCP_BOM_ELEC_TARGET_FINAL F
					     LEFT JOIN (
								    SELECT DISTINCT
									       DIVISION_ID
									      ,PARENT_ITEM_ID
									      ,ELECTRODE_TYPE	AS CHILD_ELEC_TYPE 
									      ,'Y'				AS UI_UPDATED
								    FROM SCP_MST_BOM_ELEC T WITH(NOLOCK)
								    WHERE 1=1
								      and ATTRIBUTE5 = 'Y'  -- UI_UPDATED
								    ) U
							    ON U.DIVISION_ID		= F.DIVISION_ID
						       AND U.PARENT_ITEM_ID		= F.PARENT_ITEM_ID
						       AND U.CHILD_ELEC_TYPE	= F.CHILD_ELEC_TYPE 
					     LEFT JOIN (
								    SELECT DISTINCT
									       DIVISION_ID
									      ,PARENT_ITEM_ID
									      ,ELECTRODE_TYPE	AS CHILD_ELEC_TYPE 
                                          ,CHILD_ITEM_ID
                                          ,SCP_YN
								    FROM SCP_MST_BOM_ELEC T WITH(NOLOCK)
								    ) U2
							    ON U2.DIVISION_ID		= F.DIVISION_ID
						       AND U2.PARENT_ITEM_ID	= F.PARENT_ITEM_ID
						       AND U2.CHILD_ELEC_TYPE	= F.CHILD_ELEC_TYPE
                               AND U2.CHILD_ITEM_ID	    = F.CHILD_ITEM_ID
            )
			INSERT INTO SCP_OPT_ENG_BOM_ELEC_SN (
					 PLAN_ID
					,DIVISION_ID
					,PARENT_ITEM_ID
					,CHILD_ITEM_ID
					,USAGE
					,SCP_YN 
					,STOCK_SUM
					,ELECTRODE_TYPE
					,ATTRIBUTE1
					,ATTRIBUTE2
					,ATTRIBUTE3
					,ATTRIBUTE4
			)
			SELECT   @P_PLAN_ID
					,SRC.DIVISION_ID
					,SRC.PARENT_ITEM_ID
					,SRC.CHILD_ITEM_ID
					,SRC.ACCUMULATED_CHILD_QTY			-- usage
                    ,SRC.SCP_YN
					,'Y'					    -- stock_sum
					,SRC.CHILD_ELEC_TYPE		-- electrode_type
					,SRC.CHILD_ITEM_CLASS		-- attribute1 
					,SRC.ACC_PRIORITY			-- attribute2
					,SRC.ALT_ID_PRIORITY_NEW	-- attribute3
					,SRC.SCP_YN					-- attribute4
			FROM    SRC

            -- 2026.07.03 Minyong Lee : [E20260625-001419] [최적화 엔진 ODS] BOM_Elec 테이블의 SCP_YN 변경 개선
            UPDATE TGT
            SET    TGT.SCP_YN      = LKP.SCP_YN
                  ,TGT.ATTRIBUTE4  = LKP.SCP_YN
            FROM   SCP_OPT_ENG_BOM_ELEC_SN TGT
                   INNER JOIN (
                       SELECT  SEGMENT4 AS PARENT_ITEM_ID
                              ,SEGMENT5 AS CHILD_ITEM_ID
                              ,ATTRIBUTE1 AS SCP_YN
                       FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                       WHERE   LOOKUP_TYPE = 'SCP_OPT_BOM_ELEC_CONFIG'
                       AND     VALID_YN    = 'Y'
                       AND     SEGMENT1    = @V_DIVISION_ID
                       AND     SEGMENT3    = @V_GROUP_ID
                   ) LKP
                       ON  LKP.PARENT_ITEM_ID = TGT.PARENT_ITEM_ID
                       AND LKP.CHILD_ITEM_ID  = TGT.CHILD_ITEM_ID
            WHERE  TGT.PLAN_ID = @P_PLAN_ID


			COMMIT TRAN
				  
			IF OBJECT_ID('TEMPDB..#DIVISION') IS NOT NULL
				DROP TABLE  #DIVISION;
			IF  OBJECT_ID('tempdb..#SCM_MST_ITEM_SN')  IS NOT NULL
				DROP TABLE #SCM_MST_ITEM_SN ; 
			IF  OBJECT_ID('tempdb..#BASE_DATA_0')  IS NOT NULL
				DROP TABLE #BASE_DATA_0 ; 
			IF  OBJECT_ID('tempdb..#BASE_DATA')  IS NOT NULL
				DROP TABLE #BASE_DATA ; 
			IF  OBJECT_ID('tempdb..#TREE_MODEL')  IS NOT NULL 
				DROP TABLE #TREE_MODEL;
			IF  OBJECT_ID('tempdb..#SCP_BOM_ELEC_TARGET')  IS NOT NULL
				DROP TABLE #SCP_BOM_ELEC_TARGET ; 
			IF  OBJECT_ID('tempdb..#SCP_BOM_ELEC_TARGET_FINAL')  IS NOT NULL 
				DROP TABLE #SCP_BOM_ELEC_TARGET_FINAL ;

		END			    
    END TRY

    ------------------------------------------------------------------------
    BEGIN CATCH
	------------------------------------------------------------------------
	--ROLLBACK TRANSACTION PR_SCP_OPT_ENG_RUN_MAIN_PROC;
	------------------------------------------------------------------------
      -- ERROR LOG
	------------------------------------------------------------------------
        SET @V_MESSAGE_TEXT = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
        ------------------------------------------------------------------------
        EXEC PR_SCP_OPT_ENG_LOG_CRE_PROC 'I','INPUT',@V_PLAN_ID,@V_PROGRAM_NAME,'ERROR',NULL,@V_MESSAGE_TEXT,NULL,@V_PLAN_ID
        ------------------------------------------------------------------------
        SELECT @V_DETAIL_DATE = GETDATE()
        ------------------------------------------------------------------------
        EXEC PR_SCP_OPT_ENG_LOG_DTL_PROC 'U',@V_PLAN_ID,'STEP01',NULL,NULL,@V_DETAIL_DATE,NULL,@V_MESSAGE_TEXT,'ERROR'
        ------------------------------------------------------------------------
        RAISERROR(@V_PROGRAM_NAME, 16,1)
        ------------------------------------------------------------------------
    END CATCH
	------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- 종료 LOG
    ------------------------------------------------------------------------
    IF @V_MESSAGE_TEXT IS NULL 
    ------------------------------------------------------------------------
    BEGIN
	    EXEC PR_SCP_OPT_ENG_LOG_CRE_PROC 'I','INPUT',@V_PLAN_ID,@V_PROGRAM_NAME,'END',NULL,NULL,NULL,@V_PLAN_ID
        EXEC PR_SCP_OPT_ENG_LOG_DTL_PROC 'U',@V_PLAN_ID,'STEP01',NULL,NULL,NULL,NULL,NULL,NULL
    END
    ------------------------------------------------------------------------         
                  
END

