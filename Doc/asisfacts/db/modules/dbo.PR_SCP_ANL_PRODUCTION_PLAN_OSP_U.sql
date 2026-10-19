

/*      
 * Program ID  : [PR_SCP_ANL_PRODUCTION_PLAN_OSP_U]      
 * Description : 외주OSP SCS 생산계획 Prod. Plan Amend에 반영한다.
 *				 Final Plan이 수행되기 전 최종 Plan정보에 반영한다. 
 *				
 * Execute     : 
 				 
				 EXEC [dbo].[PR_SCP_ANL_PRODUCTION_PLAN_OSP_U]
					 @P_DIVISION_ID				= '82'
					,@P_PLAN_START_YYYYMMDD		= '20230306'
*
 * Program History      
 *=================================================================================================================      
 *   Date		In Charge	Description      
 *=================================================================================================================      
 * 2023/03/03	hrkim		Initial Release  [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행
 * 2023/04/20	hrkim		품목이 아닌 line단위 모든 데이터를 대상으로 수정. (DIVISION_ID/SCM_SITE_ID/LINE_ID) 
 * 2023/04/21   hrkim		SCS 수신 데이터가 없는 경우라도 대상 Line 생산계획 수정 반영 (0)
 * 
*/

CREATE PROCEDURE [dbo].[PR_SCP_ANL_PRODUCTION_PLAN_OSP_U]
	 @P_DIVISION_ID				NVARCHAR(30) = NULL
	,@P_PLAN_START_YYYYMMDD		NVARCHAR(8)  = NULL
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 

	-- 변수 선언
	DECLARE @V_PLAN_TYPE	NVARCHAR(50) = '';
	DECLARE @V_PLAN_SEQ		BIGINT = 0;
	
	IF 	ISNULL(@P_PLAN_START_YYYYMMDD, '') = '' 
			SET @P_PLAN_START_YYYYMMDD  = CONVERT(NVARCHAR(8),  DATEADD(DAY, -7, dbo.fn_next_day(GETDATE(), 'MON')), 112) ;   -- 당주 월요일  

	PRINT '------------------------------------------------';
	PRINT '@P_DIVISION_ID			= ' + @P_DIVISION_ID;
	PRINT '@P_PLAN_START_YYYYMMDD	= ' + @P_PLAN_START_YYYYMMDD;
	PRINT '------------------------------------------------';

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ANL_PRODUCTION_PLAN_OSP_U'; --Proc별 이름 설정
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @v_batch_user   NVARCHAR(150) = N'scm_batch'; 

	-- 임시 실행시간 확인용              
    DECLARE @v_start_time   DATETIME   = SYSDATETIME();              
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';    

	BEGIN TRY
		BEGIN

			---------------------------------------------------------------------------------------------------------------------------------------
			PRINT convert(varchar(30), getdate(), 121) +  N' ### 1. 당주 최종 PLAN 실행 정보 확인  '
			---------------------------------------------------------------------------------------------------------------------------------------
			SELECT TOP 1
				   @V_PLAN_TYPE =  PD.PLAN_TYPE
				  ,@V_PLAN_SEQ  = PD.PLAN_SEQ
			 FROM SCM_MST_PLAN  PM  WITH(NOLOCK)
				 INNER JOIN SCM_MST_MODELING  MM  WITH(NOLOCK)
						 ON MM.DIVISION_ID	= PM.DIVISION_ID
						AND MM.PLAN_CYCLE	= PM.PLAN_CYCLE
				 INNER JOIN SCM_MST_PLAN_DETAIL  PD  WITH(NOLOCK)
						 ON PD.MODELING_ID = MM.MODELING_ID
						AND PD.DIVISION_ID = PM.DIVISION_ID
						AND PD.PLAN_ID     = PM.PLAN_ID 
			WHERE 1=1
			  AND PM.DIVISION_ID	= @P_DIVISION_ID
			  AND PM.PLAN_NAME		= @P_PLAN_START_YYYYMMDD
			  AND PM.PLAN_CYCLE		= 'WEEKLY'
			  AND PD.PLAN_TYPE IN ('PR', 'MA', 'SE', 'FN') 
			  AND PD.PLAN_STATUS	=  '1'
			ORDER BY CASE PD.PLAN_TYPE 
						WHEN 'PR' THEN 1	-- Pre
						WHEN 'MA' THEN 2	-- Master
						WHEN 'SE' THEN 3	-- Semi
						WHEN 'FN' THEN 4	-- Final 
					 END DESC 
					,PD.PLAN_SEQ DESC 
			;
			PRINT '---------------------------------------------------------------';
			PRINT '@V_PLAN_TYPE			= ' + @V_PLAN_TYPE;
			PRINT '@V_PLAN_SEQ			= ' + CONVERT(NVARCHAR(10), @V_PLAN_SEQ);
			PRINT '---------------------------------------------------------------';

			-- 시작 LOG  (START)
			SET @v_log_type = 'START';
			SET @v_log_message = '##### Start of procedure #####';     
			SET @v_description = @P_DIVISION_ID + ' : ' + @P_PLAN_START_YYYYMMDD + ' : ' + @V_PLAN_TYPE  + ' : ' +  CONVERT(VARCHAR(10), @V_PLAN_SEQ) ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			SET @v_log_message = NULL      /*-- < - 변수 재사용을 위하여 초기화해야함 --*/
			-- 시작 LOG  (END)


			IF ISNULL(@V_PLAN_TYPE, '') != '' AND @V_PLAN_TYPE != 'FN' -- ### Final Plan이 아닌 경우만 실행  (FN plan 이전에만 실행 ) 
			BEGIN

				---------------------------------------------------------------------------------------------------------------------------------------
				PRINT convert(varchar(30), getdate(), 121) +  N' ### 2. SCS 생산계획 반영 대상 데이터 추출 '
				---------------------------------------------------------------------------------------------------------------------------------------
				IF  OBJECT_ID('tempdb..#SCS_PROD_PLAN')  IS NOT NULL 
					DROP TABLE #SCS_PROD_PLAN;

				;WITH SCS_PROD_PLAN AS (
					SELECT 
						   L.DIVISION_ID
						  ,L.SCM_SITE_ID
						  ,S.CUTOFF_DATE
						  ,DENSE_RANK() OVER (PARTITION BY S.DIVISION_ID
														  ,S.SCM_SITE_ID
												  ORDER BY S.CUTOFF_DATE DESC) AS CUTOFF_DATE_PRIORITY 
						  ,F.OPERATION_GROUP
						  ,S.ITEM_ID
						  ,L.LINE_ID
						  ,L.OPERATION_ID
						  ,S.PROD_DATE
						  ,S.PROD_QTY
						  ,C.CELL_CF AS CELL_QTY
						  ,L.ATTRIBUTE1		AS TARGET_YN
					  FROM SCM_MST_SITE MS WITH(NOLOCK) 
						   INNER JOIN SCM_MST_LINE_OSP L WITH(NOLOCK)
								   ON L.DIVISION_ID = MS.DIVISION_ID
								  AND L.SCM_SITE_ID = MS.SCM_SITE_ID
								  AND L.VALID_YN    = 'Y'
								  AND L.ATTRIBUTE1  = 'Y'	--###  prod plan amend update대상 line 여부
							LEFT JOIN SCM_DNM_SCS_PROD_PLAN S WITH(NOLOCK) -- 2023.04.21 SCS 수신 데이터가 없는 경우라도 대상 Line 생산계획 수정 반영 (0) : join 변경 
								   ON S.DIVISION_ID = L.DIVISION_ID
								  AND S.SCM_SITE_ID = L.SCM_SITE_ID
								  AND S.LINE_ID		= L.LINE_ID 
								  AND S.CUTOFF_DATE >= @P_PLAN_START_YYYYMMDD  -- plan date(월요일) 이전 수신/생성된 데이터는 참조하지 않음.
								  AND S.PROD_DATE   >= @P_PLAN_START_YYYYMMDD 
						    LEFT JOIN SCP_MST_FINAL_ITEM F WITH(NOLOCK)
								   ON F.DIVISION_ID = S.DIVISION_ID
								  AND F.ITEM_ID     = S.ITEM_ID
							LEFT JOIN SCP_MST_ITEM_CELL_CF C
								   ON C.ITEM_ID = S.ITEM_ID
					WHERE 1=1
					  AND MS.DIVISION_ID =  @P_DIVISION_ID
					  AND MS.VALID_YN	 = 'Y'
					  AND MS.OSP_YN		 = 'Y'
				)
				SELECT 
						 @P_PLAN_START_YYYYMMDD	AS PLAN_START_YYYYMMDD
						,@V_PLAN_TYPE				AS PLAN_TYPE
						,@V_PLAN_SEQ				AS SEQ 
						,*
				 INTO #SCS_PROD_PLAN 
				 FROM SCS_PROD_PLAN 
				WHERE CUTOFF_DATE_PRIORITY = 1 -- 최종 수신/생성된 데이터 참조
				 

				---------------------------------------------------------------------------------------------------------------------------------------
				PRINT convert(varchar(30), getdate(), 121) +  N' ### 3.1 SCP_ANL_PRODUCTION_PLAN 수정 반영 대상 추출 - #tmp_SCP_ANL_PRODUCTION_PLAN'
				---------------------------------------------------------------------------------------------------------------------------------------
				IF  OBJECT_ID('tempdb..#tmp_SCP_ANL_PRODUCTION_PLAN')  IS NOT NULL 
					DROP TABLE #tmp_SCP_ANL_PRODUCTION_PLAN;

				;WITH PROD_PLAN_ASIS_TOBE AS (
					 SELECT SP.DIVISION_ID
						   ,SP.PLAN_START_YYYYMMDD
						   ,SP.PLAN_TYPE
						   ,SP.SEQ
						   ,SP.OPERATION_GROUP
						   ,SP.SCM_SITE_ID
						   ,SP.ITEM_ID
						   ,SP.LINE_ID
						   ,SP.OPERATION_ID
						   ,SP.PROD_DATE		AS YYYYMMDD
						   ,SUM(SP.PROD_QTY)	AS QTY
						   ,MAX(SP.CELL_QTY)	AS CELL_QTY
						   ,MAX(SP.DIVISION_ID)	AS ORIGIN_DIVISION_ID 
						   ,''					AS ELECTRODE_TYPE
						   ,'NEW'				AS DV
						   ,@v_program_name		AS CREATED_BY
						   ,SYSDATETIME()		AS CREATION_DATE
					  FROM #SCS_PROD_PLAN SP
					 GROUP BY  SP.DIVISION_ID
							  ,SP.PLAN_START_YYYYMMDD
							  ,SP.PLAN_TYPE
							  ,SP.SEQ
							  ,SP.OPERATION_GROUP
							  ,SP.SCM_SITE_ID
							  ,SP.ITEM_ID
							  ,SP.LINE_ID
							  ,SP.OPERATION_ID
							  ,SP.PROD_DATE		
					  UNION ALL
					 SELECT PP.DIVISION_ID
						   ,PP.PLAN_START_YYYYMMDD
						   ,PP.PLAN_TYPE
						   ,PP.SEQ
						   ,PP.OPERATION_GROUP
						   ,PP.SCM_SITE_ID
						   ,PP.ITEM_ID
						   ,PP.LINE_ID
						   ,PP.OPERATION_ID
						   ,PP.YYYYMMDD
						   ,PP.QTY
						   ,PP.CELL_QTY
						   ,PP.ORIGIN_DIVISION_ID
						   ,PP.ELECTRODE_TYPE
						   ,'OLD'				AS DV
						   ,PP.CREATED_BY	
						   ,PP.CREATION_DATE
					  FROM SCP_ANL_PRODUCTION_PLAN PP WITH(NOLOCK) 
					 WHERE 1=1
					   AND PP.MEASURE = 'PROD_PLAN_AMEND'
					   AND EXISTS (SELECT TOP 1 *   -- 라인별 전구간 데이터 반영
									 FROM #SCS_PROD_PLAN S
									WHERE S.DIVISION_ID			= PP.DIVISION_ID
									  AND S.PLAN_START_YYYYMMDD	= PP.PLAN_START_YYYYMMDD
									  AND S.PLAN_TYPE			= PP.PLAN_TYPE
									  AND S.SEQ					= PP.SEQ
									  AND S.SCM_SITE_ID			= PP.SCM_SITE_ID
									  AND S.LINE_ID				= PP.LINE_ID
									  -- 2023.04.20 라인단위 전체 품목 대상으로 함 AND S.OPERATION_GROUP		= PP.OPERATION_GROUP
									  -- 2023.04.20 라인단위 전체 품목 대상으로 함 AND S.ITEM_ID				= PP.ITEM_ID
									  -- 2023.04.20 라인단위 전체 품목 대상으로 함 AND S.OPERATION_ID		= PP.OPERATION_ID
									 )
				) 
				SELECT DIVISION_ID
					  ,PLAN_START_YYYYMMDD
					  ,PLAN_TYPE
					  ,SEQ
					  ,OPERATION_GROUP
					  ,SCM_SITE_ID
					  ,ITEM_ID
					  ,LINE_ID
					  ,OPERATION_ID
					  ,YYYYMMDD
					  ,MAX(CASE WHEN DV = 'OLD' THEN QTY			ELSE 0.0	END)	AS QTY_OLD
					  ,MAX(CASE WHEN DV = 'NEW' THEN QTY			ELSE 0.0	END)	AS QTY_NEW
					  ,MAX(CASE WHEN DV = 'OLD' THEN 'Y'			ELSE 'N'	END)	AS OLD_YN
					  ,MAX(CASE WHEN DV = 'NEW' THEN 'Y'			ELSE 'N'	END)	AS NEW_YN
					  ,MAX(CASE WHEN DV = 'OLD' THEN CREATED_BY		ELSE NULL	END)	AS CREATED_BY_OLD
					  ,MAX(CASE WHEN DV = 'NEW' THEN CREATED_BY		ELSE NULL	END)	AS CREATED_BY_NEW
					  ,MAX(CASE WHEN DV = 'OLD' THEN CREATION_DATE	ELSE NULL	END)	AS CREATION_DATE_OLD
					  ,MAX(CASE WHEN DV = 'NEW' THEN CREATION_DATE	ELSE NULL	END)	AS CREATION_DATE_NEW
					  ,MAX(CASE WHEN DV = 'OLD' THEN CELL_QTY			ELSE NULL	END)	AS CELL_QTY_OLD
					  ,MAX(CASE WHEN DV = 'NEW' THEN CELL_QTY			ELSE NULL	END)	AS CELL_QTY_NEW
					  ,MAX(CASE WHEN DV = 'OLD' THEN ORIGIN_DIVISION_ID	ELSE NULL	END)	AS ORIGIN_DIVISION_ID_OLD
					  ,MAX(CASE WHEN DV = 'NEW' THEN ORIGIN_DIVISION_ID	ELSE NULL	END)	AS ORIGIN_DIVISION_ID_NEW
					  ,MAX(CASE WHEN DV = 'OLD' THEN ELECTRODE_TYPE		ELSE NULL	END)	AS ELECTRODE_TYPE_OLD
					  ,MAX(CASE WHEN DV = 'NEW' THEN ELECTRODE_TYPE		ELSE NULL	END)	AS ELECTRODE_TYPE_NEW
				 INTO #tmp_SCP_ANL_PRODUCTION_PLAN  
				 FROM PROD_PLAN_ASIS_TOBE
				WHERE 1=1
				GROUP BY DIVISION_ID
					    ,PLAN_START_YYYYMMDD
					    ,PLAN_TYPE
					    ,SEQ
					    ,OPERATION_GROUP
					    ,SCM_SITE_ID
					    ,ITEM_ID
					    ,LINE_ID
					    ,OPERATION_ID
					    ,YYYYMMDD

				--------------------------------------------------------------------------------------------------------------------------------------------
				PRINT convert(varchar(30), getdate(), 121) +  N' ### 3.2 SCP_ANL_PRODUCTION_PLAN_FIX 수정 반영 대상 추출 - #tmp_SCP_ANL_PRODUCTION_PLAN_FIX'
				--------------------------------------------------------------------------------------------------------------------------------------------
				IF  OBJECT_ID('tempdb..#tmp_SCP_ANL_PRODUCTION_PLAN_FIX')  IS NOT NULL 
					DROP TABLE #tmp_SCP_ANL_PRODUCTION_PLAN_FIX;

				;WITH PROD_PLAN_ASIS_TOBE AS (
					 SELECT NULL				AS FIX_ID
						   ,SP.DIVISION_ID
						   ,SP.OPERATION_GROUP
						   ,SP.SCM_SITE_ID
						   ,SP.ITEM_ID
						   ,SP.LINE_ID
						   ,SP.OPERATION_ID
						   ,SP.PROD_DATE		AS YYYYMMDD
						   ,SUM(SP.PROD_QTY)	AS QTY
						   ,NULL				AS FIX_REASON
						   ,NULL				AS ORIGIN_DIVISION_ID
						   ,NULL				AS ELECTRODE_TYPE 
						   ,'NEW'				AS DV
						   ,@v_program_name		AS CREATED_BY
						   ,SYSDATETIME()		AS CREATION_DATE
					  FROM #SCS_PROD_PLAN SP
					 GROUP BY  SP.DIVISION_ID
							  ,SP.OPERATION_GROUP
							  ,SP.SCM_SITE_ID
							  ,SP.ITEM_ID
							  ,SP.LINE_ID
							  ,SP.OPERATION_ID
							  ,SP.PROD_DATE		
					  UNION ALL
					 SELECT PP.FIX_ID
						   ,PP.DIVISION_ID
						   ,PP.OPERATION_GROUP
						   ,PP.SCM_SITE_ID
						   ,PP.ITEM_ID
						   ,PP.LINE_ID
						   ,PP.OPERATION_ID
						   ,PP.YYYYMMDD
						   ,PP.QTY
						   ,PP.FIX_REASON
						   ,PP.ORIGIN_DIVISION_ID
						   ,PP.ELECTRODE_TYPE 
						   ,'OLD'				AS DV
						   ,PP.CREATED_BY	
						   ,PP.CREATION_DATE
					  FROM SCP_ANL_PRODUCTION_PLAN_FIX PP WITH(NOLOCK)  
					 WHERE 1=1
					   AND EXISTS (SELECT TOP 1 *   -- 라인별 전구간 데이터 반영
									 FROM #SCS_PROD_PLAN S
									WHERE S.DIVISION_ID			= PP.DIVISION_ID
									  AND S.SCM_SITE_ID			= PP.SCM_SITE_ID
									  AND S.LINE_ID				= PP.LINE_ID
									  -- 2023.04.20 라인단위 전체 품목 대상으로 함 AND S.OPERATION_GROUP		= PP.OPERATION_GROUP
									  -- 2023.04.20 라인단위 전체 품목 대상으로 함 AND S.ITEM_ID				= PP.ITEM_ID
									  -- 2023.04.20 라인단위 전체 품목 대상으로 함 AND S.OPERATION_ID		= PP.OPERATION_ID
									 )
				) 
				SELECT MAX(FIX_ID)														AS FIX_ID
					  ,DIVISION_ID
					  ,OPERATION_GROUP
					  ,SCM_SITE_ID
					  ,ITEM_ID
					  ,LINE_ID
					  ,OPERATION_ID
					  ,YYYYMMDD
					  ,MAX(CASE WHEN DV = 'OLD' THEN QTY			ELSE 0.0	END)	AS QTY_OLD
					  ,MAX(CASE WHEN DV = 'NEW' THEN QTY			ELSE 0.0	END)	AS QTY_NEW
					  ,MAX(CASE WHEN DV = 'OLD' THEN 'Y'			ELSE 'N'	END)	AS OLD_YN
					  ,MAX(CASE WHEN DV = 'NEW' THEN 'Y'			ELSE 'N'	END)	AS NEW_YN
					  ,MAX(CASE WHEN DV = 'OLD' THEN CREATED_BY		ELSE NULL	END)	AS CREATED_BY_OLD
					  ,MAX(CASE WHEN DV = 'NEW' THEN CREATED_BY		ELSE NULL	END)	AS CREATED_BY_NEW
					  ,MAX(CASE WHEN DV = 'OLD' THEN CREATION_DATE	ELSE NULL	END)	AS CREATION_DATE_OLD
					  ,MAX(CASE WHEN DV = 'NEW' THEN CREATION_DATE	ELSE NULL	END)	AS CREATION_DATE_NEW
					  ,MAX(FIX_REASON)													AS FIX_REASON
					  ,MAX(ORIGIN_DIVISION_ID)											AS ORIGIN_DIVISION_ID
					  ,MAX(ELECTRODE_TYPE)												AS ELECTRODE_TYPE
				 INTO #tmp_SCP_ANL_PRODUCTION_PLAN_FIX 
				 FROM PROD_PLAN_ASIS_TOBE
				WHERE 1=1
				GROUP BY DIVISION_ID
					    ,OPERATION_GROUP
					    ,SCM_SITE_ID
					    ,ITEM_ID
					    ,LINE_ID
					    ,OPERATION_ID
					    ,YYYYMMDD
						;


				BEGIN TRAN

					------------------------------------------------- production plan & history -------------------------------------------------------------

					-----------------------------------------------------------------------------------------------------------------------------------------
					PRINT convert(varchar(30), getdate(), 121) +  N' 4.1 SCP_ANL_PRODUCTION_PLAN  UPDATE / INSERT '
					-----------------------------------------------------------------------------------------------------------------------------------------
					MERGE INTO SCP_ANL_PRODUCTION_PLAN   TGT 
						USING ( 
							SELECT SP.DIVISION_ID		
								  ,SP.PLAN_START_YYYYMMDD
								  ,SP.PLAN_TYPE			
								  ,SP.SEQ			
								  ,SP.OPERATION_GROUP	
								  ,SP.SCM_SITE_ID		
								  ,SP.ITEM_ID			
								  ,SP.LINE_ID			
								  ,SP.OPERATION_ID		
								  ,SP.YYYYMMDD	
								  ,'PROD_PLAN_AMEND'												AS MEASURE 
								  ,SP.QTY_NEW														AS QTY
								  ,ISNULL(SP.CELL_QTY_NEW			, SP.CELL_QTY_OLD)				AS CELL_QTY
								  ,ISNULL(CREATED_BY_OLD			, CREATED_BY_NEW)				AS CREATED_BY
								  ,ISNULL(CREATION_DATE_OLD			, CREATION_DATE_NEW)			AS CREATION_DATE
								  ,ISNULL(SP.ORIGIN_DIVISION_ID_OLD	, SP.ORIGIN_DIVISION_ID_NEW)	AS ORIGIN_DIVISION_ID
								  ,ISNULL(SP.ELECTRODE_TYPE_OLD		, SP.ELECTRODE_TYPE_NEW)		AS ELECTRODE_TYPE
							 FROM  #tmp_SCP_ANL_PRODUCTION_PLAN SP 
							WHERE 1=1
							  AND QTY_OLD != QTY_NEW
						) SRC
						 ON (
								TGT.DIVISION_ID			= SRC.DIVISION_ID
							AND TGT.PLAN_START_YYYYMMDD	= SRC.PLAN_START_YYYYMMDD
							AND TGT.PLAN_TYPE			= SRC.PLAN_TYPE
							AND TGT.SEQ					= SRC.SEQ
							AND TGT.OPERATION_GROUP		= SRC.OPERATION_GROUP
							AND TGT.SCM_SITE_ID			= SRC.SCM_SITE_ID
							AND TGT.ITEM_ID				= SRC.ITEM_ID
							AND TGT.LINE_ID				= SRC.LINE_ID
							AND TGT.OPERATION_ID		= SRC.OPERATION_ID
							AND TGT.YYYYMMDD			= SRC.YYYYMMDD
							AND TGT.MEASURE				= SRC.MEASURE
							)
						WHEN MATCHED THEN
							 UPDATE SET LAST_UPDATE_DATE	= SYSDATETIME()
									   ,LAST_UPDATED_BY		= @v_program_name
									   ,QTY					= SRC.QTY
									   ,ATTRIBUTE2			= 'QTY_OLD : ' + CONVERT(NVARCHAR(150), TGT.QTY)	    

						WHEN NOT MATCHED THEN 
								INSERT (
										 DIVISION_ID
										,PLAN_START_YYYYMMDD
										,PLAN_TYPE
										,SEQ
										,OPERATION_GROUP
										,SCM_SITE_ID
										,ITEM_ID
										,LINE_ID
										,OPERATION_ID
										,MEASURE
										,YYYYMMDD
										,QTY
										,ORIGIN_DIVISION_ID
										,ELECTRODE_TYPE
										,CELL_QTY
										,CREATED_BY
										,CREATION_DATE
										,LAST_UPDATED_BY
										,LAST_UPDATE_DATE
								)
								VALUES ( 
										 SRC.DIVISION_ID
										,SRC.PLAN_START_YYYYMMDD
										,SRC.PLAN_TYPE
										,SRC.SEQ
										,SRC.OPERATION_GROUP
										,SRC.SCM_SITE_ID
										,SRC.ITEM_ID
										,SRC.LINE_ID
										,SRC.OPERATION_ID
										,SRC.MEASURE
										,SRC.YYYYMMDD
										,SRC.QTY
										,SRC.ORIGIN_DIVISION_ID
										,SRC.ELECTRODE_TYPE
										,SRC.CELL_QTY
										,SRC.CREATED_BY			-- created_by
										,SRC.CREATION_DATE		-- creation_date 
										,@v_program_name		-- last_updated_by
										,SYSDATETIME()			-- last_update_date 
										)
							;

					-----------------------------------------------------------------------------------------------------------------------------------------
					PRINT convert(varchar(30), getdate(), 121) +  N' 4.2 SCP_ANL_PRODUCTION_PLAN_H  INSERT  (이력추가)'
					-----------------------------------------------------------------------------------------------------------------------------------------
					INSERT INTO SCP_ANL_PRODUCTION_PLAN_H    ( 
									 HISTORY_SEQ
									,DIVISION_ID
									,PLAN_START_YYYYMMDD
									,PLAN_TYPE
									,SEQ
									,OPERATION_GROUP
									,SCM_SITE_ID
									,ITEM_ID
									,LINE_ID
									,OPERATION_ID
									,MEASURE
									,YYYYMMDD
									,QTY
									,ORIGIN_DIVISION_ID
									,ELECTRODE_TYPE
									,CREATED_BY
									,CREATION_DATE
									,LAST_UPDATED_BY
									,LAST_UPDATE_DATE
									,HISTORY_CREATION_DATE
									,ATTRIBUTE2
									)
							SELECT NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_H AS HISTORY_SEQ
								  ,SP.DIVISION_ID		
								  ,SP.PLAN_START_YYYYMMDD
								  ,SP.PLAN_TYPE			
								  ,SP.SEQ			
								  ,SP.OPERATION_GROUP	
								  ,SP.SCM_SITE_ID		
								  ,SP.ITEM_ID			
								  ,SP.LINE_ID			
								  ,SP.OPERATION_ID		
								  ,'PROD_PLAN_AMEND'												AS MEASURE 
								  ,SP.YYYYMMDD	
								  ,SP.QTY_NEW														AS QTY
								  ,ISNULL(SP.ORIGIN_DIVISION_ID_OLD	, SP.ORIGIN_DIVISION_ID_NEW)	AS ORIGIN_DIVISION_ID
								  ,ISNULL(SP.ELECTRODE_TYPE_OLD		, SP.ELECTRODE_TYPE_NEW)		AS ELECTRODE_TYPE
								  ,ISNULL(CREATED_BY_OLD			, CREATED_BY_NEW)				AS CREATED_BY
								  ,ISNULL(CREATION_DATE_OLD			, CREATION_DATE_NEW)			AS CREATION_DATE
								  ,@v_program_name													AS LAST_UPDATED_BY
								  ,SYSDATETIME()													AS LAST_UPDATE_DATE
								  ,SYSDATETIME()													AS HISTORY_CREATION_DATE
								  ,'QTY_OLD : ' + CONVERT(NVARCHAR(150), SP.QTY_OLD)				AS ATTRIBUTE2
							 FROM  #tmp_SCP_ANL_PRODUCTION_PLAN SP 
							WHERE 1=1
							  AND QTY_OLD != QTY_NEW
							;


					------------------------------------------------- production plan fix & history ---------------------------------------------------------

					-----------------------------------------------------------------------------------------------------------------------------------------
					PRINT convert(varchar(30), getdate(), 121) +  N' 5.1 SCP_ANL_PRODUCTION_PLAN_FIX - UPDATE '
					-----------------------------------------------------------------------------------------------------------------------------------------
					MERGE INTO SCP_ANL_PRODUCTION_PLAN_FIX  TGT 
						USING ( 
							SELECT SP.FIX_ID
								  ,SP.DIVISION_ID		
								  ,SP.OPERATION_GROUP	
								  ,SP.SCM_SITE_ID		
								  ,SP.ITEM_ID			
								  ,SP.LINE_ID			
								  ,SP.OPERATION_ID		
								  ,SP.YYYYMMDD	
								  ,SP.QTY_NEW		AS QTY
							 FROM  #tmp_SCP_ANL_PRODUCTION_PLAN_FIX SP 
							WHERE 1=1
							  AND QTY_OLD != QTY_NEW
							  AND FIX_ID IS NOT NULL 
						) SRC
						 ON (
								TGT.DIVISION_ID			= SRC.DIVISION_ID
							AND TGT.OPERATION_GROUP		= SRC.OPERATION_GROUP
							AND TGT.SCM_SITE_ID			= SRC.SCM_SITE_ID
							AND TGT.ITEM_ID				= SRC.ITEM_ID
							AND TGT.LINE_ID				= SRC.LINE_ID
							AND TGT.OPERATION_ID		= SRC.OPERATION_ID
							AND TGT.YYYYMMDD			= SRC.YYYYMMDD
							)
						WHEN MATCHED THEN
							 UPDATE SET LAST_UPDATE_DATE	= SYSDATETIME()
									   ,LAST_UPDATED_BY		= @v_program_name
									   ,QTY					= SRC.QTY
									   ,ATTRIBUTE2			= 'QTY_OLD : ' + CONVERT(NVARCHAR(150), TGT.QTY)
						 ;

					-----------------------------------------------------------------------------------------------------------------------------------------
					PRINT convert(varchar(30), getdate(), 121) +  N' 5.2 SCP_ANL_PRODUCTION_PLAN_FIX_H  INSERT  (이력추가)'
					-----------------------------------------------------------------------------------------------------------------------------------------
					INSERT INTO SCP_ANL_PRODUCTION_PLAN_FIX_H  (
									 HISTORY_SEQ
									,FIX_ID
									,DIVISION_ID
									,OPERATION_GROUP
									,SCM_SITE_ID
									,ITEM_ID
									,LINE_ID
									,OPERATION_ID
									,YYYYMMDD
									,QTY
									,FIX_REASON
									,ORIGIN_DIVISION_ID
									,ELECTRODE_TYPE
									,CREATED_BY
									,CREATION_DATE
									,LAST_UPDATED_BY
									,LAST_UPDATE_DATE
									,HISTORY_CREATION_DATE
									,ATTRIBUTE2
									)
							SELECT NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H AS HISTORY_SEQ
								  ,SP.FIX_ID
								  ,SP.DIVISION_ID	
								  ,SP.OPERATION_GROUP	
								  ,SP.SCM_SITE_ID		
								  ,SP.ITEM_ID			
								  ,SP.LINE_ID			
								  ,SP.OPERATION_ID		
								  ,SP.YYYYMMDD	
								  ,SP.QTY_NEW												AS QTY
								  ,SP.FIX_REASON
								  ,SP.ORIGIN_DIVISION_ID
								  ,SP.ELECTRODE_TYPE
								  ,ISNULL(CREATED_BY_OLD			, CREATED_BY_NEW)		AS CREATED_BY
								  ,ISNULL(CREATION_DATE_OLD			, CREATION_DATE_NEW)	AS CREATION_DATE
								  ,@v_program_name											AS LAST_UPDATED_BY
								  ,SYSDATETIME()											AS LAST_UPDATE_DATE
								  ,SYSDATETIME()											AS HISTORY_CREATION_DATE
								  ,'QTY_OLD : ' + CONVERT(NVARCHAR(150), SP.QTY_OLD)		AS ATTRIBUTE2
							 FROM  #tmp_SCP_ANL_PRODUCTION_PLAN_FIX SP 
							WHERE 1=1
							  AND QTY_OLD != QTY_NEW
							  AND FIX_ID IS NOT NULL 
							  ;

				COMMIT TRAN


			END -- IF ISNULL(@V_PLAN_TYPE, '') != '' AND @V_PLAN_TYPE != 'FN' -- ### Final Plan이 아닌 경우만 실행  (FN plan 이전에만 실행 )


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
