




/*  
 * Program ID   : PR_SCP_MST_MDL_ELTR_QTY
 * Description  : Capa Speed계획의 PPM 계산시 참조될 전극 장수 및 Pitch 정보를 적재한다. 
 *				 - Source : SCM_MST_BOM_SN		(ALT_PRIORITY = 'Y' 1순위만 대상으로 함)
 *				 - Target : SCP_MST_MDL_ELTR_QTY
 *
 * Program History  
 *===================================================================================================  
 *   Date      In Charge	Description  
 *===================================================================================================  
 * 2024.02.26	hrkim		Initial Release PJ20230692 SCM 역량 강화 위한 SCP 개선과제 이행 Phase2  
 * 2024.03.18	hrkim		JV 포함 적재
 * 2024.05.16	hrkim		Item Class / 전극라인유형코드 매핑 정보 lookup 참조 (ITEM_CLASS_ELTR_LN_TP_CD_MAPPING)
 * 2024.10.24	hrkim		F2모델 동일모델 법인Plant별 BOM 다른 건으로 전극수량/pitch 합산되는 문제 수정 
 * 2024.12.03	hrkim		LGES2024-002655 SCP 개선과제 이행 : BOM 참조 Cell모델 우선순위 변경
 *							1. 우선조건 1 : Status Plan (SCP_MST_FINAL_ITEM.FCST_YN = 'Y' 이거나 SCP_ANL_PRODUCTION_PLAN_N에 적재 시점 해당월 이후 계획이 있는 경우) 
 *							2. 우선조건 2 : 우선조건 3을 제외한 max(Item_id) 
 *							3. 우선조건 3 : item_id 13번째 자리가 '-'가 아닌 알파벳 'D, E, T,R'일 경우
 *							4. 우선조건 4 : max(item_id) 
 * 2025.02.04	hrkim		CPS Basic NickName별 BOM 우선 참조 셀 모델 적용	
 *							- lookup_type : CPS_BOM_REF_CELL_MODEL
 *
 */  

CREATE PROCEDURE [dbo].[PR_SCP_MST_MDL_ELTR_QTY]
AS

BEGIN


-- procedure body -- start 
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET NOCOUNT ON; 

	-- 실행시간 확인용              
    DECLARE @v_start_time   DATETIME		= SYSDATETIME();              
    DECLARE @v_exec_time    NVARCHAR(10)	= ''			--'[00:00]';    

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_MST_MDL_ELTR_QTY'; --Proc별 이름 설정
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
		SET @v_description = '[81,82,JV]';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_batch_user;
		SET @v_log_message = NULL 

		---------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### JV포함 대상 사업부 ' 
		---------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#TARGET_DIVISION') IS NOT NULL
			DROP TABLE #TARGET_DIVISION;

		SELECT DIVISION_ID
		 INTO #TARGET_DIVISION 
		 FROM SCM_MST_DIVISION WITH(NOLOCK)
		WHERE 1=1
		  AND ATTRIBUTE3 IN ('81', '82') 
		  AND VALID_YN	 = 'Y'


		---------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### SCM_MST_ITEM_SN 추출' 
		---------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#SCM_MST_ITEM_SN') IS NOT NULL
			DROP TABLE #SCM_MST_ITEM_SN;

		SELECT ITEM_ID
			  ,DIVISION_ID
			  ,MAX(ITEM_CLASS		   ) AS  ITEM_CLASS		   
			  ,MAX(ITEM_TYPE		   ) AS  ITEM_TYPE		   
			  ,MAX(DOE				   ) AS  DOE				   
			  ,MAX(NICK_NAME		   ) AS  NICK_NAME		   
			  ,MAX(SCP_FLOW_ID		   ) AS  SCP_FLOW_ID		   
			  ,MAX(SCP_OPERATION_GROUP ) AS  SCP_OPERATION_GROUP 
		 INTO #SCM_MST_ITEM_SN
		 FROM SCM_MST_ITEM_SN WITH(NOLOCK)
		WHERE 1=1
		  AND DIVISION_ID IN (SELECT DIVISION_ID FROM #TARGET_DIVISION) 
		  AND ACTIVE_FLAG = 'Y'
		GROUP BY ITEM_ID
				,DIVISION_ID


		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N'SCP Cell 모델 생산계획  - #ITEM_PRODUCTION_PLAN ' 
		----------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#ITEM_PRODUCTION_PLAN') IS NOT NULL 
			DROP TABLE #ITEM_PRODUCTION_PLAN;

		SELECT DISTINCT 
			   DIVISION_ID
			  ,ITEM_ID
		 INTO #ITEM_PRODUCTION_PLAN 
		 FROM SCP_ANL_PRODUCTION_PLAN_N WITH(NOLOCK)
		WHERE 1=1
		  AND DIVISION_ID IN (SELECT DIVISION_ID FROM #TARGET_DIVISION) 
		  AND YYYYMMDD	>= CONCAT(CONVERT(NVARCHAR(6), GETDATE(), 112) ,'01') --  적재 시점 해당월 이후
		  AND OPERATION_GROUP = 'A' -- Cell 			


		---------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### SCP_MST_FINAL_ITEM 추출 with Basic Nickname' 
		---------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#SCP_MST_FINAL_ITEM') IS NOT NULL
			DROP TABLE #SCP_MST_FINAL_ITEM;

		SELECT BI.BASIC_NICK_NAME
			 , FI.DIVISION_ID
			 , FI.ITEM_ID
			 , FI.FCST_YN
			 , CASE WHEN PP.ITEM_ID IS NOT NULL 
					THEN 'Y'
					ELSE 'N'
			   END	AS PLAN_YN
			 , CASE WHEN PP.ITEM_ID IS NOT NULL OR FI.FCST_YN = 'Y'
					THEN 'Y'
					ELSE 'N'
			   END	AS PLAN_STATUS 
			 , CASE WHEN LEN(FI.ITEM_ID) >= 13 
						 AND SUBSTRING(FI.ITEM_ID, 13, 1) != '-' 
						 AND ASCII(UPPER(SUBSTRING(FI.ITEM_ID, 13, 1))) BETWEEN 65 AND  90  -- 13번째 자리가 '-'가 아닌 알파벳인 경우    
					THEN 'Y'
					ELSE 'N'
			   END  AS POS13T_YN
			 , CASE WHEN LEN(FI.ITEM_ID) >= 13 
					THEN SUBSTRING(FI.ITEM_ID, 13, 1)
					ELSE NULL
			   END  AS POS13
		  INTO #SCP_MST_FINAL_ITEM
		  FROM SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
			   INNER JOIN SCP_MST_ITEM_BSI_IFO BI WITH(NOLOCK)
					   ON BI.ITEM_ID		= FI.ITEM_ID 
			   LEFT  JOIN #ITEM_PRODUCTION_PLAN PP 
					   ON PP.DIVISION_ID	= FI.DIVISION_ID
					  AND PP.ITEM_ID		= FI.ITEM_ID
		WHERE 1=1
		  AND FI.DIVISION_ID IN (SELECT DIVISION_ID FROM #TARGET_DIVISION) 
		  AND FI.OPERATION_GROUP = 'A' -- Cell Model 
  

		---------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 1순위 모델 BOM 추출 - plant별 '
		---------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#SCM_MST_BOM_SN_BEFORE') IS NOT NULL
			DROP TABLE #SCM_MST_BOM_SN_BEFORE;

		SELECT  BO.DIVISION_ID
			   ,BO.PLANT_ID
			   ,BO.MODEL_ID
			   ,BO.CHILD_ITEM_ID		
			   ,BO.CHILD_DIVISION_ID	
			   ,BO.CONCATENATE_ITEM
			   ,MAX(BO.ACCUMULATED_CHILD_QTY	)	AS	ACCUMULATED_CHILD_QTY
			   ,MAX(BO.CHILD_QTY				)	AS	CHILD_QTY	
		 INTO #SCM_MST_BOM_SN_BEFORE
		 FROM SCM_MST_BOM_SN BO WITH(NOLOCK)
			  INNER JOIN #SCP_MST_FINAL_ITEM FI
					  ON FI.DIVISION_ID = BO.DIVISION_ID
					 AND FI.ITEM_ID		= BO.MODEL_ID
		WHERE 1=1
		  AND BO.ALT_PRIORITY = 'Y' -- 1순위 
		GROUP BY BO.DIVISION_ID
				,BO.MODEL_ID
				,BO.CHILD_ITEM_ID		
				,BO.CHILD_DIVISION_ID	
				,BO.CONCATENATE_ITEM
				,BO.PLANT_ID


		-----------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### Item Class/전극라인유형코드 매핑정보 - #TGT_ITEM_CLASS'	-- 5/16  변경 추가 
		---------------------------------------------------------------------------------------------------
		---- lookup : ITEM_CLASS_ELTR_LN_TP_CD_MAPPING (QTY_PCH_TARGET_YN = 'Y') -------------------------
		 -- 'ES0301'	[APCAN]Anode Pancake		-- for pitch
		 -- 'ES0302'	[APCCA]Cathode Pancake		-- for pitch 
		 ----------------------------------------------------------------------------------
		 -- 'ES0501'	[ANPAN]Anode Notched Pancake
		 -- 'ES0502'	[ANPCA]Cathode Notched Pancake
		 -- 'ES0601'	[ABCAT]A-Type Bi-Cell
		 -- 'ES0602'	[ABCCT]C-Type Bi-Cell
		 -- 'ES1007'	[AMCMC]Mono-Type Cell
		 -- 'ES1101'	[AHCHC]HALF-Type Cell
		-----------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#TGT_ITEM_CLASS') IS NOT NULL	
			DROP TABLE #TGT_ITEM_CLASS;
	
		 SELECT SEGMENT1		AS CLASS_ID
			   ,MAX(ATTRIBUTE1)	AS ELTR_LN_TP_CD 
			   ,MAX(ATTRIBUTE2)	AS QTY_PCH_DIVS 
		  INTO #TGT_ITEM_CLASS  
		  FROM SCM_ADM_LOOKUP_MASTER_DETAIL with(nolock)
		 WHERE 1=1
		   AND LOOKUP_TYPE	= 'ITEM_CLASS_ELTR_LN_TP_CD_MAPPING'
		   AND VALID_YN		= 'Y'
		   AND ATTRIBUTE3	= 'Y' -- QTY_PCH_TARGET_YN (전극 수량/PCH 대상여부)
		GROUP BY SEGMENT1


		---------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 대상 Child Item 정보' 
		---------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#TGT_CHILD_ITEM') IS NOT NULL
			DROP TABLE #TGT_CHILD_ITEM;

		SELECT CI.ITEM_ID
			  ,CI.DIVISION_ID
			  ,CC.CLASS_ID
			  ,CC.ELTR_LN_TP_CD 
			  ,CC.QTY_PCH_DIVS
		 INTO #TGT_CHILD_ITEM
		 FROM #SCM_MST_ITEM_SN CI WITH(NOLOCK)
			  INNER JOIN #TGT_ITEM_CLASS CC with(nolock)
					  ON CC.CLASS_ID = CI.ITEM_CLASS 
		WHERE 1=1
		GROUP BY CI.ITEM_ID
				,CI.DIVISION_ID
				,CC.CLASS_ID
				,CC.ELTR_LN_TP_CD 
				,CC.QTY_PCH_DIVS

		---------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### #SCM_MST_BOM_SN ' 
		---------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#SCM_MST_BOM_SN') IS NOT NULL
			DROP TABLE #SCM_MST_BOM_SN;

		SELECT I.BASIC_NICK_NAME
			  ,B.*
			  ,I.PLAN_STATUS
			  ,I.POS13T_YN
		 INTO #SCM_MST_BOM_SN
		 FROM #SCM_MST_BOM_SN_BEFORE B
			  INNER JOIN #SCP_MST_FINAL_ITEM I WITH(NOLOCK)
					  ON I.DIVISION_ID	= B.DIVISION_ID
					 AND I.ITEM_ID		= B.MODEL_ID 
		WHERE 1=1

		---------------------------------------------------------------------------------------------------
		print convert(varchar(30), getdate(), 121) + N' ### Basic Nickname별 0순위 참조 모델' -- 2025.02.04
		---------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#CPS_BOM_REF_CELL_MODEL') IS NOT NULL	
			DROP TABLE #CPS_BOM_REF_CELL_MODEL;
	
		 SELECT SEGMENT1		AS BASIC_NICK_NAME
			   ,MAX(ATTRIBUTE1)	AS CELL_MODEL_CODE_PRIORITY_0 
		  INTO #CPS_BOM_REF_CELL_MODEL  
		  FROM SCM_ADM_LOOKUP_MASTER_DETAIL with(nolock)
		 WHERE 1=1
		   AND LOOKUP_TYPE	= 'CPS_BOM_REF_CELL_MODEL'
		   AND VALID_YN		= 'Y'
		GROUP BY SEGMENT1

		---------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 모델별 전극 장수/Pitch 정보' 
		---------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#MODEL_ELTR_QTY_PITCH') IS NOT NULL
			DROP TABLE #MODEL_ELTR_QTY_PITCH;

		SELECT BM.DIVISION_ID
			  ,BM.PLANT_ID
			  ,BM.MODEL_ID
			  ,BM.BASIC_NICK_NAME 
			  ,BM.PLAN_STATUS
			  ,BM.POS13T_YN
			  ,CI.ELTR_LN_TP_CD
			  ,P0.CELL_MODEL_CODE_PRIORITY_0	-- 2025.02.04 lookup 0순위 참조 모델 적용 
			  ,SUM(CASE WHEN CI.QTY_PCH_DIVS = 'QTY' THEN BM.ACCUMULATED_CHILD_QTY	ELSE 0.0 END)			AS ELTR_QTY
			  ,MAX(CASE WHEN CI.QTY_PCH_DIVS = 'PCH' THEN BM.CHILD_QTY 				ELSE 0.0 END) * 1000	AS ELTR_PCH_LEN	-- mm환산 
			  ,ROW_NUMBER() OVER (PARTITION BY BM.BASIC_NICK_NAME
											  ,CI.ELTR_LN_TP_CD
										 ORDER  BY CASE WHEN BM.MODEL_ID = P0.CELL_MODEL_CODE_PRIORITY_0 -- 2025.02.04 lookup 0순위 참조 모델 적용 
														THEN 1
														ELSE 2
													END
												  ,BM.PLAN_STATUS DESC
												  ,BM.POS13T_YN
												  ,BM.MODEL_ID	  DESC
												  ,CASE WHEN (BM.DIVISION_ID = '81' AND BM.MODEL_ID LIKE 'AC%') OR (BM.DIVISION_ID = '82' AND BM.MODEL_ID LIKE 'EC%') 
														THEN 1
														ELSE 2
												   END 
												  ,BM.PLANT_ID			) AS MODEL_PRIORITY
		INTO #MODEL_ELTR_QTY_PITCH
		FROM #SCM_MST_BOM_SN  BM WITH(NOLOCK)
			 INNER JOIN #TGT_CHILD_ITEM CI WITH(NOLOCK)
					 ON CI.ITEM_ID		= BM.CHILD_ITEM_ID		
					AND CI.DIVISION_ID	= BM.CHILD_DIVISION_ID	
			 LEFT  JOIN #CPS_BOM_REF_CELL_MODEL P0 WITH(NOLOCK)	-- 2025.02.04 lookup 0순위 참조 모델 적용 
					 ON P0.BASIC_NICK_NAME = BM.BASIC_NICK_NAME
		WHERE 1=1  
		  AND BM.BASIC_NICK_NAME IS NOT NULL 
		GROUP BY BM.DIVISION_ID
			  ,BM.PLANT_ID
			  ,BM.MODEL_ID
			  ,BM.BASIC_NICK_NAME 
			  ,BM.PLAN_STATUS
			  ,BM.POS13T_YN
			  ,CI.ELTR_LN_TP_CD
			  ,P0.CELL_MODEL_CODE_PRIORITY_0	-- 2025.02.04 lookup 0순위 참조 모델 적용 
		ORDER BY BM.BASIC_NICK_NAME
				,CI.ELTR_LN_TP_CD
				,BM.PLAN_STATUS DESC
				,BM.POS13T_YN
				,BM.MODEL_ID DESC 

		---------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 닉네임/전극유형별 전극/Pitch정보' 
		---------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#NICK_NAME_ELTR_QTY_PITCH') IS NOT NULL
			DROP TABLE #NICK_NAME_ELTR_QTY_PITCH;

		SELECT BASIC_NICK_NAME
			  ,ELTR_LN_TP_CD
			  ,ELTR_QTY
			  ,ELTR_PCH_LEN
			  ,MODEL_ID
		 INTO #NICK_NAME_ELTR_QTY_PITCH	
		 FROM #MODEL_ELTR_QTY_PITCH EQ	
		WHERE 1=1
		  AND EQ.MODEL_PRIORITY = 1 -- 닉네임/전극유형별 모델 우선 순위 


	------- Begin Tran : =======================================================================================
	  BEGIN TRAN   --- transaction 시작  

		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### 기 생성 데이터 변경(상태변경 포함)전 이력생성  ' 
		----------------------------------------------------------------------------------------------------------
		INSERT INTO SCP_MST_MDL_ELTR_QTY_H (
			 HISTORY_SEQ
			,HISTORY_CREATION_DATE
			,NICK_NM
			,ELTR_LN_TP_CD
			,ELTR_QTY
			,ELTR_PCH_LEN
			,USE_YN
			,CREATED_BY
			,CREATION_DATE
			,LAST_UPDATED_BY
			,LAST_UPDATE_DATE
			,ATTRIBUTE1
			,ATTRIBUTE2
			,ATTRIBUTE3
			,ATTRIBUTE4
			,ATTRIBUTE5
			,ATTRIBUTE6
			,ATTRIBUTE7
			,ATTRIBUTE8
			,ATTRIBUTE9
			,ATTRIBUTE10
		) 
		SELECT 
			 NEXT VALUE FOR SEQ1_SCP_MST_MDL_ELTR_QTY_H AS HISTORY_SEQ
			,GETDATE()									AS HISTORY_CREATION_DATE
			,SR.NICK_NM
			,SR.ELTR_LN_TP_CD
			,SR.ELTR_QTY
			,SR.ELTR_PCH_LEN
			,SR.USE_YN
			,SR.CREATED_BY
			,SR.CREATION_DATE
			,SR.LAST_UPDATED_BY
			,SR.LAST_UPDATE_DATE
			,SR.ATTRIBUTE1
			,SR.ATTRIBUTE2
			,SR.ATTRIBUTE3
			,SR.ATTRIBUTE4
			,SR.ATTRIBUTE5
			,SR.ATTRIBUTE6
			,SR.ATTRIBUTE7
			,SR.ATTRIBUTE8
			,SR.ATTRIBUTE9
			,SR.ATTRIBUTE10
		 FROM SCP_MST_MDL_ELTR_QTY SR WITH(NOLOCK)
			  LEFT JOIN #NICK_NAME_ELTR_QTY_PITCH TG WITH(NOLOCK)
					 ON TG.BASIC_NICK_NAME	= SR.NICK_NM
					AND TG.ELTR_LN_TP_CD	= SR.ELTR_LN_TP_CD
		WHERE 1=1
		  AND ((SR.USE_YN = 'Y' AND TG.BASIC_NICK_NAME IS NULL) -- 대상에 없는 기 생성 데이터 (use_yn = 'N'으로 update전 최종 상태 정보로 이력 생성) 
			   OR 
			   (TG.BASIC_NICK_NAME IS NOT NULL					-- 대상에 존재하는 기 생성된 데이터 값이 다른 경우 변경전 이력 생성 
			    AND (   SR.USE_YN		  = 'N'  
					 OR TG.ELTR_QTY	    != SR.ELTR_QTY
					 OR TG.ELTR_PCH_LEN != SR.ELTR_PCH_LEN
					 OR TG.MODEL_ID	    != ISNULL(SR.ATTRIBUTE1,'')
					 )
				) 
			   ) 

		------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### BOM에 없는 사용중인 모델 정보 상태 Update ' 
		------------------------------------------------------------------------------------------------------------
		UPDATE SR
		  SET USE_YN			= 'N'
			, LAST_UPDATE_DATE	= GETDATE()
			, LAST_UPDATED_BY	= @v_program_name
		 FROM SCP_MST_MDL_ELTR_QTY SR WITH(NOLOCK)
		WHERE 1=1
		  AND USE_YN = 'Y'
		  AND NOT EXISTS (SELECT *
							FROM #NICK_NAME_ELTR_QTY_PITCH TG WITH(NOLOCK)
						   WHERE TG.BASIC_NICK_NAME	= SR.NICK_NM
						     AND TG.ELTR_LN_TP_CD	= SR.ELTR_LN_TP_CD)

		----------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' ### MERGE INTO SCP_MST_MDL_ELTR_QTY ' 
		----------------------------------------------------------------------------------------------------------
		MERGE INTO SCP_MST_MDL_ELTR_QTY TGT
		USING (
				SELECT BASIC_NICK_NAME	AS NICK_NM
					 , ELTR_LN_TP_CD
					 , ELTR_QTY
					 , ELTR_PCH_LEN
					 , MODEL_ID			AS ATTRIBUTE1
				 FROM #NICK_NAME_ELTR_QTY_PITCH SR
				WHERE 1=1
				  AND NOT EXISTS (SELECT *
									FROM SCP_MST_MDL_ELTR_QTY TG 
								   WHERE 1=1
									 AND TG.NICK_NM					= SR.BASIC_NICK_NAME
									 AND TG.ELTR_LN_TP_CD			= SR.ELTR_LN_TP_CD
									 AND TG.USE_YN					= 'Y'
									 AND TG.ELTR_QTY				= SR.ELTR_QTY
									 AND TG.ELTR_PCH_LEN			= SR.ELTR_PCH_LEN  
									 AND ISNULL(TG.ATTRIBUTE1,'')	= SR.MODEL_ID)
			) SRC
		 ON (	SRC.NICK_NM			= TGT.NICK_NM
			AND SRC.ELTR_LN_TP_CD	= TGT.ELTR_LN_TP_CD
			)
		WHEN MATCHED THEN
			UPDATE SET TGT.LAST_UPDATE_DATE	= SYSDATETIME()
					  ,TGT.LAST_UPDATED_BY	= @v_program_name
					  ,TGT.USE_YN			= 'Y'
					  ,TGT.ELTR_QTY			= SRC.ELTR_QTY
					  ,TGT.ELTR_PCH_LEN		= SRC.ELTR_PCH_LEN
					  ,TGT.ATTRIBUTE1		= SRC.ATTRIBUTE1 
		WHEN NOT MATCHED THEN
			INSERT ( NICK_NM
					,ELTR_LN_TP_CD
					,ELTR_QTY
					,ELTR_PCH_LEN
					,USE_YN
					,CREATED_BY
					,CREATION_DATE
					,LAST_UPDATED_BY
					,LAST_UPDATE_DATE
					,ATTRIBUTE1
					)
			VALUES ( SRC.NICK_NM
					,SRC.ELTR_LN_TP_CD
					,SRC.ELTR_QTY
					,SRC.ELTR_PCH_LEN
					,'Y' 
					,@v_program_name
					,GETDATE()
					,@v_program_name
					,GETDATE()
					,SRC.ATTRIBUTE1 
					)
		;

	  COMMIT TRAN ;  --- transaction 종료  
	------- End Tran : ==========================================================================================================

		-------------------------------------------
		-------- 임시테이블 정리
		---------------------------------------------
		IF OBJECT_ID('TEMPDB..#TARGET_DIVISION') IS NOT NULL
			DROP TABLE #TARGET_DIVISION;
		IF OBJECT_ID('TEMPDB..#SCM_MST_ITEM_SN') IS NOT NULL
			DROP TABLE #SCM_MST_ITEM_SN;
		IF OBJECT_ID('TEMPDB..#ITEM_PRODUCTION_PLAN') IS NOT NULL 
			DROP TABLE #ITEM_PRODUCTION_PLAN;
		IF OBJECT_ID('TEMPDB..#SCP_MST_FINAL_ITEM') IS NOT NULL
			DROP TABLE #SCP_MST_FINAL_ITEM;
		IF OBJECT_ID('TEMPDB..#SCM_MST_BOM_SN_BEFORE') IS NOT NULL
			DROP TABLE #SCM_MST_BOM_SN_BEFORE;
		IF OBJECT_ID('TEMPDB..#TGT_ITEM_CLASS') IS NOT NULL	
			DROP TABLE #TGT_ITEM_CLASS;
		IF OBJECT_ID('TEMPDB..#TGT_CHILD_ITEM') IS NOT NULL
			DROP TABLE #TGT_CHILD_ITEM;
		IF OBJECT_ID('TEMPDB..#SCM_MST_BOM_SN') IS NOT NULL
			DROP TABLE #SCM_MST_BOM_SN;
		IF OBJECT_ID('TEMPDB..#MODEL_ELTR_QTY_PITCH') IS NOT NULL
			DROP TABLE #MODEL_ELTR_QTY_PITCH;
		IF OBJECT_ID('TEMPDB..#NICK_NAME_ELTR_QTY_PITCH') IS NOT NULL
			DROP TABLE #NICK_NAME_ELTR_QTY_PITCH;

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
    SET @v_description = N'[81,82,JV]['  + @v_exec_time + ']';  ;            
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
	RETURN 1;    

END
