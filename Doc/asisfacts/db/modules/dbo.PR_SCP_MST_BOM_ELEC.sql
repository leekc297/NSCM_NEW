



/*      
 * Program ID  : [PR_SCP_MST_BOM_ELEC]      
 * Description : SCP BOM (Elec) Master 데이터 적재  
 * Execute     : 
 				 
				 EXEC [dbo].[PR_SCP_MST_BOM_ELEC]
						@P_BASE_YYYYMMDD = N'20230308'
 *
 * Program History      
 *=================================================================================================================      
 *   Date		In Charge	Description      
 *=================================================================================================================      
 * 2023/03/02	hrkim		Initial Release  [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행
 * 2024/01/08	hrkim		base data 추출시 템프테이블 추가 사용
 * 2025.08.01   hrkim		PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 : Cell 완성 공정 하드코딩 변경
 * 
*/


CREATE PROCEDURE [dbo].[PR_SCP_MST_BOM_ELEC]
	@P_BASE_YYYYMMDD		NVARCHAR(8) = NULL
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET NOCOUNT ON; 

	DECLARE @P_BASE_DATE		DATE = NULL;
	
	IF 	ISNULL(@P_BASE_YYYYMMDD, '') = '' 
			SET @P_BASE_DATE  = CONVERT(DATE, CONVERT(NVARCHAR(8), GETDATE(), 112) , 112) ; 
	ELSE 
			SET @P_BASE_DATE  = CONVERT(DATE,  @P_BASE_YYYYMMDD, 112) ;
	
	PRINT '------------------------------------------------';
	PRINT '@P_BASE_YYYYMMDD	= ' + @P_BASE_YYYYMMDD;
	PRINT '@P_BASE_DATE		= ' + CONVERT(NVARCHAR(8),@P_BASE_DATE,112);
	PRINT '------------------------------------------------';

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_MST_BOM_ELEC'; --Proc별 이름 설정
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @v_batch_user   NVARCHAR(150) = N'scm_batch'; 

	-- 임시 실행시간 확인용              
    DECLARE @v_start_time   DATETIME   = SYSDATETIME();              
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';    

	------------------------------------------------------------------------------------------------------------------
	-- [PJ20257329] Cell 완성 공정 하드 코딩 변경 (임시 테이블 변수) 
	print  convert(varchar(30), getdate(), 121) + N' SCP Cell Final 공정 정보 - Cell Packaging/Assembly' 
	------------------------------------------------------------------------------------------------------------------
	 DECLARE @SCP_CELL_FINAL_OPERATION TABLE
	 (
		   OPERATION_ID					NVARCHAR(30)	NULL
	 )

	INSERT INTO @SCP_CELL_FINAL_OPERATION
	SELECT SEGMENT1 AS OPERATION_ID
	  FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
	 WHERE 1=1
	   AND LK.LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
	   AND LK.SEGMENT3	  = 'A'	 -- 공정그룹 (Cell)
	   AND LK.ATTRIBUTE1  = 'Y'	 -- Final Operation
	------------------------------------------------------------------------------------------------------------------

	BEGIN TRY
		BEGIN

			-- 시작 LOG  (START)
			SET @v_log_type = 'START';
			SET @v_log_message = '##### Start of procedure #####';     
			SET @v_description = CONVERT(NVARCHAR(8),@P_BASE_DATE,112) ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			SET @v_log_message = NULL      /*-- < - 변수 재사용을 위하여 초기화해야함 --*/
			-- 시작 LOG  (END)

			---------------------------------------------------------------------------------------------------------------------------------------
			PRINT convert(varchar(30), getdate(), 121) +  N' ### 0 #SCM_MST_ITEM_SN - 품목 Master데이터 추출'
			---------------------------------------------------------------------------------------------------------------------------------------
			IF  OBJECT_ID('tempdb..#SCM_MST_ITEM_SN')  IS NOT NULL
				DROP TABLE #SCM_MST_ITEM_SN ; 

			SELECT ITEM_ID
				  ,COMPANY_ID
				  ,SITE_ID
				  ,DIVISION_ID
				  ,ACTIVE_FLAG
				  ,SCP_OPERATION_GROUP
				  ,SCP_FLOW_ID
				  ,ITEM_CLASS
			INTO #SCM_MST_ITEM_SN
			FROM SCM_MST_ITEM_SN WITH(NOLOCK)
			WHERE 1=1
			  AND ACTIVE_FLAG	= 'Y'
			  AND (SCP_OPERATION_GROUP = 'A' 
				   OR 
				   ITEM_CLASS in ('ES0301'	-- [APCAN]Anode Pancake
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
					  AND BD.PARENT_FLOW_ID  IN (SELECT OPERATION_ID  FROM @SCP_CELL_FINAL_OPERATION)  -- [PJ20257329] Cell 완성 공정 하드 코딩 변경
					  -- [PJ20257329] 변경전 AND BD.PARENT_FLOW_ID  in ('A3000', 'A9000') 
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

			-----------------------------------------------------------------------------------------------------------------------------------------
			PRINT convert(varchar(30), getdate(), 121) +  N' ### 5.1 최종 대상에 없는 기 생성 데이터 삭제 '
			-----------------------------------------------------------------------------------------------------------------------------------------
			DELETE TGT 
			FROM SCP_MST_BOM_ELEC TGT WITH(NOLOCK)
			WHERE 1=1
			  AND NOT EXISTS ( SELECT  TOP 1 *
							   FROM #SCP_BOM_ELEC_TARGET_FINAL F
							  WHERE F.DIVISION_ID		= TGT.DIVISION_ID
								AND F.PARENT_ITEM_ID	= TGT.PARENT_ITEM_ID
								AND F.CHILD_ITEM_ID		= TGT.CHILD_ITEM_ID
								) 
			;
	
			-----------------------------------------------------------------------------------------------------------------------------------------
			PRINT convert(varchar(30), getdate(), 121) +  N' ### 5.2 MERGE INTO (UPDATE / INSERT) '
			-----------------------------------------------------------------------------------------------------------------------------------------
			MERGE INTO SCP_MST_BOM_ELEC TGT 
			USING ( 
				SELECT F.DIVISION_ID
					  ,F.PARENT_ITEM_ID
					  ,F.CHILD_ITEM_ID
					  ,F.CHILD_ELEC_TYPE
					  ,F.CHILD_ITEM_CLASS 
					  ,F.ACC_PRIORITY
					  ,F.ALT_ID_PRIORITY_NEW
					  ,F.ACCUMULATED_CHILD_QTY
					  ,F.SCP_YN_PRIORITY
					  ,F.SCP_YN
					  ,ISNULL(U.UI_UPDATED, 'N') AS UI_UPDATED
				FROM #SCP_BOM_ELEC_TARGET_FINAL F
					 LEFT JOIN (--## UI에서 scp_yn 수정된 데이터 (DIVISION/PARENT/ELEC_TYPE별로 UI 변경된 건이 존재하면 기존 SCP_YN 값 유지) 
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
				WHERE 1=1
				  AND NOT EXISTS ( 
								-- TGT와 일치하는 건 제외 
								SELECT *
								  FROM SCP_MST_BOM_ELEC T
								 WHERE 1=1
								   AND T.DIVISION_ID	= F.DIVISION_ID
								   AND T.PARENT_ITEM_ID	= F.PARENT_ITEM_ID
								   AND T.CHILD_ITEM_ID	= F.CHILD_ITEM_ID
								   AND T.USAGE			= F.ACCUMULATED_CHILD_QTY
								   AND T.SCP_YN			= F.SCP_YN
								   AND T.ELECTRODE_TYPE	= F.CHILD_ELEC_TYPE
								   AND T.ATTRIBUTE1		= F.CHILD_ITEM_CLASS
								   AND T.ATTRIBUTE2		= F.ACC_PRIORITY
								   AND T.ATTRIBUTE3		= F.ALT_ID_PRIORITY_NEW
								   AND T.ATTRIBUTE4		= F.SCP_YN
								)
			) SRC
			 ON (
					TGT.DIVISION_ID		= SRC.DIVISION_ID
				AND TGT.PARENT_ITEM_ID	= SRC.PARENT_ITEM_ID
				AND TGT.CHILD_ITEM_ID	= SRC.CHILD_ITEM_ID
				)
			WHEN MATCHED THEN
				 UPDATE SET LAST_UPDATE_DATE	= CASE	WHEN UI_UPDATED = 'Y'
														THEN TGT.LAST_UPDATE_DATE -- UI SCP_YN 수정일시 유지
														ELSE GETDATE()
												   END 
						   ,LAST_UPDATED_BY		=  CASE	WHEN UI_UPDATED = 'Y'
														THEN TGT.LAST_UPDATED_BY -- UI SCP_YN 수정자 정보 유지
														ELSE @v_program_name
												   END  
						   ,SCP_YN				= CASE	WHEN UI_UPDATED = 'Y'
														THEN TGT.SCP_YN			  -- UI SCP_YN 설정 정보 유지
														ELSE SRC.SCP_YN 
												   END
						   ,USAGE				= SRC.ACCUMULATED_CHILD_QTY
						   ,ELECTRODE_TYPE		= SRC.CHILD_ELEC_TYPE
						   ,ATTRIBUTE1			= SRC.CHILD_ITEM_CLASS
						   ,ATTRIBUTE2			= SRC.ACC_PRIORITY
						   ,ATTRIBUTE3			= SRC.ALT_ID_PRIORITY_NEW
						   ,ATTRIBUTE4			= SRC.SCP_YN
						   ,ATTRIBUTE10			= 'PR_SCP_MST_BOM_ELEC : '+CONVERT(NVARCHAR(150), GETDATE(), 120) 
			WHEN NOT MATCHED THEN 
					INSERT (
							 DIVISION_ID
							,PARENT_ITEM_ID
							,CHILD_ITEM_ID
							,USAGE
							,SCP_YN 
							,STOCK_SUM
							,ELECTRODE_TYPE
							,CREATED_BY
							,CREATION_DATE 
							,LAST_UPDATED_BY
							,LAST_UPDATE_DATE 
							,ATTRIBUTE1
							,ATTRIBUTE2
							,ATTRIBUTE3
							,ATTRIBUTE4
					)
					VALUES ( SRC.DIVISION_ID
							,SRC.PARENT_ITEM_ID
							,SRC.CHILD_ITEM_ID
							,SRC.ACCUMULATED_CHILD_QTY			-- usage
							,CASE	WHEN SRC.UI_UPDATED = 'Y' 	-- scp_yn 
				 					THEN 'N'
				 					ELSE SRC.SCP_YN 
							  END
							,'Y'					-- stock_sum
							,SRC.CHILD_ELEC_TYPE	-- electrode_type
							,@v_program_name		-- created_by
							,GETDATE()				-- creation_date 
							,@v_program_name		-- last_updated_by
							,GETDATE()				-- last_update_date 
							,SRC.CHILD_ITEM_CLASS		-- attribute1 
							,SRC.ACC_PRIORITY			-- attribute2
							,SRC.ALT_ID_PRIORITY_NEW	-- attribute3
							,SRC.SCP_YN					-- attribute4
							);

			COMMIT TRAN
				  
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
    SET @v_description = N'['  + @v_exec_time + ']';             
    SET @d_event_date = SYSDATETIME()  ;                 
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
                              ,@p_log_type      =@v_log_type                  
                              ,@p_log_count     =@n_log_count                   
                              ,@p_log_message   =@v_log_message                   
                              ,@p_description   =@v_description                   
                              ,@p_event_date    =@d_event_date                   
                              ,@p_user_id       =@v_batch_user                  
                              ;                  
    RETURN 1;                
                  
END

