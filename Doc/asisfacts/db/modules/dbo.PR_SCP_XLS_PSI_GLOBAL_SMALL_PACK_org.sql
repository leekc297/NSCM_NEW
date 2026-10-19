


/*      
 * Program ID   : PR_SCP_XLS_PSI_GLOBAL_SMALL_PACK        
 * Description  : PR_SCP_XLS_CREATE_DATA 에서 호출함.      
 * OutTable     :      
 * Execute      : 
    DELETE FROM SCM_SYS_LOG_BATCH where CREATED_BY ='KSK'
	
    EXEC PR_SCP_XLS_PSI_GLOBAL_SMALL_PACK
                                 @p_plan_cycle          = 'WEEKLY'
                               , @p_plan_start_yyyymmdd = '20250324'
                               , @p_plan_id             = '1384'
                               , @p_modeling_id         = '1'
                               , @p_seq                 = '2'
                               , @p_plan_type           = 'PR'
                               , @p_master_id           = '40::WEEKLY'
                               , @p_division_id         = '40'
                               , @p_engine_plan_id      = '1384::PR::2'
                               , @p_user_id             = 'KSK' 
							   , @P_IS_DEBUG	 = 1

	SELECT TOP 30 * FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK WITH (NOLOCK)

 * Program History      
 *===================================================================================================      
 *   Date       In Charge      Description      
 *===================================================================================================      
 * 2019.02.21   KTH         Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트  
 *              KSG         과거 이력 정리
 * 2021.03.26   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 0값 제거에 따른 로직보완
 * 2021.04.06   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 0값 제거에 따른 로직보완 - DM_MKT_FCST, CELL_PKG_PLAN_IN 추가
 * 2021.08.25   KSW         PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V
 * 2021-08.26   KSW         CHILD_ITEM_ID 불일치 오류 수정 (cell requirement total 수식설정오류)
 * 2022-03-31   KSW         OSP LT 적용 :: 생산계획의 LT 컬럼에 OSP LT 값을 표시하고 Pack Model Inventory (EOH) 수식을 변경한다. (생산계획에 LT 적용)
 * 2022-07-01   KSW         PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 :: ISUZU 적용
 * 2022-09-21   KSW			W-1주차 생산/출하계획을 표시하는 measure 추가 등 (소형SCM개선요청사항 적용)
 * 2023-01-13   KKH			소형팩 시뮬레이터 mkt_fcst수량 수정 (최종 월에 해당하는 값만 업데이트 -> 여러건을 group by에서 최종값 연결)
 * 2023.07.01	KSG		    PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase.2 : 활성화 분리
 * 2023.10.10	KHJ		    1년차와 2년차의 XLS_KEY1 값 일치화 작업
 * 2023.10.30	KHJ		    특정 MEASURE 2년차의 데이터 미생성부분 BP_FLAG를 통해 분기 처리함.
 * 2024.11.12    KSK		   MKT_FCST 메저관련 원본교체 DM_PLN_MKT_FCST_C => DM_PLN_MKT_FCST  
 * 2025.02.27    KSK		   TO SITE별 RTF 관련 메저 생성
 * 2025.03.05    KSK	       출하계획의 SSP는 승인건수(CHANGE_TYPE=C)에 한정하도록 보완
 * 2025.03.13    KSK	       SHIP_PLAN_ETA의 LT관련 필드조회 
 * 2025.08.01   hrkim	    PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 : Cell 완성 공정 하드코딩 변경
 */    
 CREATE PROCEDURE [dbo].[PR_SCP_XLS_PSI_GLOBAL_SMALL_PACK_org]
(       
      @p_plan_cycle           NVARCHAR(0150)        
    , @p_plan_start_yyyymmdd  NVARCHAR(0008)        
    , @p_plan_id              NVARCHAR(4000)        
    , @p_modeling_id          NVARCHAR(4000)        
    , @p_seq                  NVARCHAR(4000)        
    , @p_plan_type            NVARCHAR(4000)        
    , @p_master_id            NVARCHAR(4000)        
    , @p_division_id          NVARCHAR(0030)        
    , @p_engine_plan_id       NVARCHAR(4000)        
    , @p_user_id              NVARCHAR(0150)  = 'SCP_batch'        
    , @p_is_debug				bit  = 0 --0 : RELEASE, 1 : DEBUG
)       
AS        
  BEGIN      
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;      
    SET NOCOUNT ON;      
    SET XACT_ABORT ON;      
    SET ANSI_WARNINGS OFF;      
      
    -- LOG 용 변수 설정      
    DECLARE @v_batch_user   NVARCHAR(150) = N'SCP_batch';        
    SET @v_batch_user                     = @p_user_id      
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_XLS_PSI_GLOBAL_SMALL_PACK_org';      
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...      
    DECLARE @n_log_count    INTEGER = 0;      
    DECLARE @v_log_message  NVARCHAR(1000);      
    DECLARE @v_description  NVARCHAR(500);    
    DECLARE @v_table_id     NVARCHAR(150) = N'SCM_SYS_LOG_BATC';   
    DECLARE @d_event_date   DATETIME;      
  
	PRINT 'Start of PR_SCP_XLS_PSI_GLOBAL_SMALL_PACK'

	------------------------------------------------------------------------------------------------------------------
	-- [PJ20257329] 2025.08.01  Cell 완성 공정 하드코딩 변경
	print  convert(varchar(30), getdate(), 121) + N' SCP Cell Final 공정 정보 - Cell Packaging/Assembly' 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#SCP_CELL_FINAL_OPERATION') IS NOT NULL DROP TABLE #SCP_CELL_FINAL_OPERATION
	SELECT DISTINCT SEGMENT1 AS OPERATION_ID
	  INTO #SCP_CELL_FINAL_OPERATION
	  FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
	 WHERE 1=1
	   AND LK.LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
	   AND LK.SEGMENT3	  = 'A'	 -- 공정그룹 (Cell)
	   AND LK.ATTRIBUTE1  = 'Y'	 -- Final Operation
	------------------------------------------------------------------------------------------------------------------

  -- 시작 LOG      
    SET @v_log_type     = N'START';      
    SET @v_log_message  = N'########## Start of procedure ##########';      
    SET @v_description  = @v_program_name + ':' + N'INSERT LOGIC';      
    SET @d_event_date   = SYSDATETIME();      
	if @p_is_debug = 0
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
                              ,@p_log_type      = @v_log_type      
                              ,@p_log_count     = @n_log_count       
                              ,@p_log_message   = @v_log_message       
                              ,@p_description   = @v_description       
                              ,@p_event_date    = @d_event_date       
                              ,@p_user_id       = @v_batch_user      
                              ;      
  
   
        -- 실행시간 확인용    
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();    
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'00:00';    

    DECLARE @p_program_id   NVARCHAR(30) = 'XLSPSI02'          
	
        BEGIN TRY        
          BEGIN        
          /*
          ALTER TABLE SCP_XLS_PSI_GLOBAL_SMALL_PACK
          ADD YIELD	NUMERIC(20,10) DEFAULT '0'
          */

			DECLARE @v_bp_flag		NVARCHAR(8) = '';						
			SELECT @v_bp_flag  = (case when DATEDIFF(DAY, p.plan_name, p.horizon_end_date) > 364 then 'Y' else 'N' end)
--				, @v_bp_days  = (case when DATEDIFF(DAY, p.plan_name, p.horizon_end_date) > 364 then DATEDIFF(DAY, p.plan_name, p.horizon_end_date) - 363 else 0 end)
			FROM   dbo.scm_mst_plan p WITH(NOLOCK)
			WHERE  p.division_id = @p_division_id
			AND    p.plan_id     = (SELECT max(plan_id) FROM dbo.scm_mst_plan p WITH(NOLOCK) WHERE division_id = @p_division_id and plan_id < 9999)
			;

			DECLARE @v_to_yyyymmdd  VARCHAR(8)   --계획종료구간일
			set @v_to_yyyymmdd = case when @v_bp_flag = 'Y' then CONVERT(VARCHAR(8), DATEADD(day, 364 * 2, @p_plan_start_yyyymmdd), 112)
				else CONVERT(VARCHAR(8), DATEADD(day, 364, @p_plan_start_yyyymmdd), 112) END

            -------------------------------------------------------------------------------------------------------------         
            -- MEASURE 정보
            -------------------------------------------------------------------------------------------------------------              
	          IF OBJECT_ID('tempdb..#MEASURE') IS NOT NULL	
	              DROP TABLE #MEASURE

	            /* MEASURE 세팅값 추출 */ 
--              INSERT INTO #MEASURE
	            SELECT M.COLUMN_NAME, M.COLUMN_LABEL_NAME,M.SORT_ORDER_NO,(CASE WHEN ATTRIBUTE1 ='PACK' THEN 'P' WHEN ATTRIBUTE1 ='CELL' THEN 'A'  ELSE 'C' END) AS DIV
					, ATTRIBUTE2 AS GUBUN--,ATTRIBUTE1
              INTO #MEASURE
              --SELECT *
  	          FROM SCM_MST_SHEET_MEASURE M WITH(NOLOCK)
	            WHERE M.PROGRAM_ID      = @p_program_id
	              AND M.VALID_YN        = 'Y'


            -------------------------------------------------------------------------------------------------------------         
            -- SCP_ANL_PSI_GLOBAL_SMALL  데이터 이관 ('SHIP_REQ','SHIP_PLAN','PRODUCTION')
            -------------------------------------------------------------------------------------------------------------     
              IF OBJECT_ID('tempdb..#PSI_GLOBAL_SMALL_PACK') IS NOT NULL      
	              DROP TABLE #PSI_GLOBAL_SMALL_PACK;        

	            CREATE TABLE #PSI_GLOBAL_SMALL_PACK (
		             DIVISION_ID		      NVARCHAR(060)	
		            ,OPERATION_GROUP	    NVARCHAR(060)
		            ,CELL_ITEM_ID		      NVARCHAR(100)	
		            ,ITEM_ID			        NVARCHAR(100)
--                ,BOM_DESC             NVARCHAR(100)
		            ,TO_SITE			        NVARCHAR(060)
                ,PROJECT_CODE         NVARCHAR(050)     -- 
		            ,TO_BOH_QTY			      numeric(20,10)    -- BIGINT
		            ,FROM_BOH_QTY		      numeric(20,10)    -- BIGINT
		            ,INCOTERMS			      NVARCHAR(20)
		            ,FROM_SITE			      NVARCHAR(60)
		            ,TRANSPORT_MODE_LINE	NVARCHAR(100)
                ,TRANSPORT_MODE       NVARCHAR(50)
                ,PROD_LINE            NVARCHAR(50)
--                ,END_CUSTOMER         NVARCHAR(50)
		            ,MEASURE			        NVARCHAR(100)
		            ,YYYYMMDD			        NVARCHAR(010)
		            ,QTY				          NUMERIC(20,10)
		            ,SORT_ORDER_NO		    INT
		            ,COLUMN_LABEL_NAME	  NVARCHAR(300)
		            ,BOD_ID				        NVARCHAR(300)
                ,ATTRIBUTE1			      NVARCHAR(150)
		            ,ATTRIBUTE9			      NVARCHAR(150)   -- OPERATION_ID
		            ,ATTRIBUTE10		      NVARCHAR(150)
                ,WEEK_COLUMN          NVARCHAR(6)
	            );


             INSERT INTO #PSI_GLOBAL_SMALL_PACK	 
             SELECT A.DIVISION_ID								
			            , A.OPERATION_GROUP						
			            , A.CELL_ITEM_ID							
			            , A.ITEM_ID										
			            , isnull(NULLIF(A.TO_SITE, '') , '-') TO_SITE		
                  , '' AS PROJECT_CODE
			            , 0 AS TO_BOH_QTY										
			            , 0 AS FROM_BOH_QTY									
			            , A.INCOTERMS 										
			            , A.FROM_SITE 										
			            , A.TRANSPORT_MODE_LINE			
                  , NULL            AS TRANSPORT_MODE
                  , NULL            AS PROD_LINE
			            , M.COLUMN_NAME     AS MEASURE												
			            , A.YYYYMMDD        AS YYYYMMDD				
                  , ISNULL(QTY,0)     AS QTY  -- 기존 INTRANSIT 무시하고 모두 0
			            , M.SORT_ORDER_NO									
			            , M.COLUMN_LABEL_NAME							
			            , A.BOD_ID						
                  , A.ATTRIBUTE1										
			            , A.ATTRIBUTE9										
			            , A.ATTRIBUTE10				
                  , NULL AS WEEK_COLUMN
	               FROM SCP_ANL_PSI_GLOBAL_SMALL A WITH(NOLOCK)	
	               INNER JOIN #MEASURE M WITH(NOLOCK)	 
                    ON M.COLUMN_NAME        =  (CASE 
                                                      WHEN A.MEASURE = 'PRODUCTION'         AND A.OPERATION_GROUP = 'P'                         THEN 'PACK_PROD' 
                                                      WHEN A.MEASURE = 'SHIP_PLAN'          AND A.OPERATION_GROUP = 'P'                         THEN 'PACK_SHIP_PLAN'
                                                      WHEN A.MEASURE = 'SHIP_PLAN'          AND A.OPERATION_GROUP = 'A'                         THEN 'CELL_SHIP_PLAN' 
                                                      ELSE A.MEASURE END) 
	              WHERE A.DIVISION_ID			    =  @p_division_id
		            AND A.PLAN_START_YYYYMMDD	  =  @p_plan_start_yyyymmdd
		            AND A.PLAN_TYPE				      =  @p_plan_type
		            AND A.SEQ					          =  @p_seq
		            AND A.YYYYMMDD             >=  @p_plan_start_yyyymmdd
		            AND A.YYYYMMDD             <=   @v_to_yyyymmdd  --말일포함(KSK, 20240814)
                AND A.MEASURE              IN ('SHIP_REQ','PRODUCTION','SHIP_PLAN' )
                ;

            ------------------------------------------------------------------------------------------------------------- start        
            -- ISUZU SCP_ANL_SHIPMENT_PLAN_SEMI  데이터 이관 ('SHIP_REQ','SHIP_PLAN')
			-- * PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 :: ISUZU 적용
            -------------------------------------------------------------------------------------------------------------
			DECLARE @v_isuzu_cnt	INT = 0;			
			SELECT @v_isuzu_cnt = COUNT(*) 
			FROM #PSI_GLOBAL_SMALL_PACK WITH(NOLOCK) 
			WHERE MEASURE IN ('SHIP_REQ','PRODUCTION','SHIP_PLAN') AND ATTRIBUTE9 = 'P5000';

			IF (@v_isuzu_cnt = 0)
			BEGIN

              INSERT INTO #PSI_GLOBAL_SMALL_PACK
                SELECT  X.DIVISION_ID
                       ,X.OPERATION_GROUP
                       ,(SELECT TOP 1 CHILD_ITEM_ID
						  FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V V WITH (NOLOCK)
						 WHERE V.DIVISION_ID = X.DIVISION_ID
						   AND V.MODEL_ID  = (SELECT TOP 1 MODEL_ID
										   	    FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V A WITH (NOLOCK)
											   WHERE A.DIVISION_ID = X.DIVISION_ID
											     AND A.CHILD_ITEM_ID = X.ITEM_ID)
						   AND V.OPERATION_GROUP_ID = 'A') AS CELL_ITEM_ID
                       ,X.ITEM_ID
                       ,X.TO_SITE
                       ,X.PROJECT_CODE
                       ,X.TO_BOH_QTY
                       ,X.FROM_BOH_QTY
                       ,X.INCOTERMS
                       ,X.FROM_SITE
					   ,NULL AS TRANSPORT_MODE_LINE
                       ,X.TRANSPORT_MODE
                       ,X.PROD_LINE
                       ,X.MEASURE
                       ,X.YYYYMMDD
                       ,X.QTY
                       ,X.SORT_ORDER_NO
                       ,X.COLUMN_LABEL_NAME
                       ,MAX(X.BOD_ID) AS BOD_ID   --
                       ,X.ATTRIBUTE1
                       ,(SELECT TOP 1 FLOW_ID
						  FROM SCM_MST_ITEM_SN M WITH (NOLOCK)
						 WHERE M.DIVISION_ID = X.DIVISION_ID
						   AND M.ITEM_ID     = X.ITEM_ID) AS ATTRIBUTE9
					   ,NULL AS ATTRIBUTE10
					   ,NULL AS WEEK_COLUMN
                FROM (

                     SELECT   A.DIVISION_ID								
			                      , A.OPERATION_GROUP						
			                      , '' AS CELL_ITEM_ID							
			                      , A.ITEM_ID										
			                      , ISNULL(NULLIF(A.TO_SITE, '') , '-') TO_SITE		
                            , '-' AS PROJECT_CODE
			                      , 0 AS TO_BOH_QTY										
			                      , 0 AS FROM_BOH_QTY									
			                      , '-' AS INCOTERMS 										
			                      , A.FROM_SITE 		
							-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V
                            ,ISNULL((SELECT TOP 1 TRANSPORT_MODE FROM SCP_MST_BOD_N_V C where 0 = 0 and C.division_id =A.division_id AND A.BOD_ID = C.BOD_ID AND A.FROM_SITE = C.FROM_SITE	),'-') AS TRANSPORT_MODE
                            , '-'              AS PROD_LINE
			                      , M.COLUMN_NAME  AS MEASURE											
			                      , A.YYYYMMDD        AS YYYYMMDD				
                            , ISNULL(QTY,0)     AS QTY  -- 기존 INTRANSIT 무시하고 모두 0
			                      , M.SORT_ORDER_NO									
			                      , M.COLUMN_LABEL_NAME							
			                      , A.BOD_ID						
                            , 'SCP_ANL_SHIPMENT_PLAN_SEMI' AS ATTRIBUTE1										
			                      , A.ATTRIBUTE9						
	                         FROM SCP_ANL_SHIPMENT_PLAN_SEMI A WITH(NOLOCK)	
                           --INNER JOIN SCM_SYS_CALENDAR_M  C  WITH(NOLOCK) 
                           --   ON A.YYYYMMDD           = C.BASIS_YYYYMMDD				
                           INNER JOIN #MEASURE M WITH(NOLOCK)	
                              ON M.COLUMN_NAME          IN ('PACK_SHIP_PLAN', 'SHIP_REQ')
                              AND (CASE A.MEASURE WHEN  'SHIP_PLAN' THEN 'PACK_SHIP_PLAN' ELSE A.MEASURE  END)              = M.COLUMN_NAME
                           WHERE A.DIVISION_ID			    =  @p_division_id
		                          AND A.PLAN_START_YYYYMMDD	=  @p_plan_start_yyyymmdd
		                          AND A.PLAN_TYPE				    =  @p_plan_type
		                          AND A.SEQ					        =  @p_seq
		                          AND A.YYYYMMDD            >=  @p_plan_start_yyyymmdd
		                          AND A.YYYYMMDD            <=   @v_to_yyyymmdd       --말일포함(KSK, 20240814) 
                              AND A.MEASURE             IN ('SHIP_PLAN', 'SHIP_REQ')      
							  AND A.ITEM_ID IN (SELECT DISTINCT S.CHILD_ITEM_ID
												  FROM (SELECT V.DIVISION_ID, V.CHILD_ITEM_ID
														  FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V V WITH (NOLOCK)
														 WHERE DIVISION_ID = @p_division_id
														   AND MODEL_ID IN (select DISTINCT ITEM_ID
																			  from scm_mst_item_sn with (nolock)
																			 where division_id = @p_division_id
																			   and active_flag = 'Y'
																			   and nick_name like '%ISUZU%'
																			   AND ITEM_TYPE = 'P')
														) S
														INNER JOIN SCM_MST_ITEM_SN M WITH (NOLOCK)
													ON S.DIVISION_ID = M.DIVISION_ID
												    AND S.CHILD_ITEM_ID = M.ITEM_ID
													WHERE M.nick_name like '%ISUZU%'
													  AND M.ITEM_TYPE = 'P')

                        ) X

                        GROUP BY X.DIVISION_ID
                               ,X.OPERATION_GROUP
                               ,X.CELL_ITEM_ID
                               ,X.ITEM_ID
                               ,X.TO_SITE
                               ,X.PROJECT_CODE
                               ,X.TO_BOH_QTY
                               ,X.FROM_BOH_QTY
                               ,X.INCOTERMS
                               ,X.FROM_SITE
                               ,X.TRANSPORT_MODE
                               ,X.PROD_LINE
                               ,X.MEASURE
                               ,X.YYYYMMDD
                               ,X.QTY
                               ,X.SORT_ORDER_NO
                               ,X.COLUMN_LABEL_NAME
                               ,X.ATTRIBUTE1
                               ,X.ATTRIBUTE9
							   ;



             
            -- ISUZU SCP_ANL_SHIPMENT_PLAN_SEMI  데이터 이관 ('PACK_PROD')
            INSERT INTO #PSI_GLOBAL_SMALL_PACK
               SELECT  
                        A.DIVISION_ID             
                      , A.OPERATION_GROUP         
                      ,(SELECT TOP 1 CHILD_ITEM_ID
						  FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V V WITH (NOLOCK)
						 WHERE V.DIVISION_ID = A.DIVISION_ID
						   AND V.MODEL_ID  = (SELECT TOP 1 MODEL_ID
										   	    FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V V1 WITH (NOLOCK)
											   WHERE V1.DIVISION_ID   = A.DIVISION_ID
											     AND V1.CHILD_ITEM_ID = A.ITEM_ID)
						   AND V.OPERATION_GROUP_ID = 'A') AS CELL_ITEM_ID          
                      , A.ITEM_ID        
                      , '-' AS  TO_SITE	
                      , '-' AS PROJECT_CODE
                      , 0 AS TO_BOH_QTY        
                      , 0 AS FROM_BOH_QTY	      
                      , '-' AS INCOTERMS           
                      , A.SCM_SITE_ID  AS FROM_SITE
					  , NULL       AS TRANSPORT_MODE_LINE
                      , '-'        AS TRANSPORT_MODE
                      , A.LINE_ID   AS PROD_LINE                       
                      , M.COLUMN_NAME AS MEASURE
                      , A.YYYYMMDD                
                      , SUM(A.QTY) AS QTY                
                      , M.SORT_ORDER_NO									
			                , M.COLUMN_LABEL_NAME							
			                ,  '-' AS BOD_ID						
                      , 'SCP_ANL_PRODUCTION_PLAN' AS ATTRIBUTE1										
			                , OPERATION_ID AS ATTRIBUTE9	    
							, A.ATTRIBUTE10
							, NULL AS WEEK_COLUMN
                      FROM SCP_ANL_PRODUCTION_PLAN A WITH (NOLOCK) 
                       --INNER JOIN SCM_SYS_CALENDAR_M  C  WITH(NOLOCK) 
                       --   ON A.YYYYMMDD           = C.BASIS_YYYYMMDD				
                       INNER JOIN #MEASURE M WITH(NOLOCK)	
                          ON M.COLUMN_NAME          IN ('PACK_PROD')
                          AND (CASE  WHEN A.MEASURE ='PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'P' THEN 'PACK_PROD' 
                                     WHEN A.MEASURE ='PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'A' THEN 'CELL_PROD'
                                     ELSE '-' END )  = M.COLUMN_NAME
                      WHERE 1 = 1                    
                         AND A.DIVISION_ID           = @p_division_id                    
                         AND A.PLAN_START_YYYYMMDD   = @p_plan_start_yyyymmdd                 
                         AND A.PLAN_TYPE             = @p_plan_type                    
                         AND A.SEQ                   = @p_seq      
                         AND A.LINE_ID              <> '-'
						 AND A.ITEM_ID IN (SELECT DISTINCT S.CHILD_ITEM_ID
												  FROM (SELECT V.DIVISION_ID, V.CHILD_ITEM_ID
														  FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V V WITH (NOLOCK)
														 WHERE DIVISION_ID = @p_division_id
														   AND MODEL_ID IN (select DISTINCT ITEM_ID
																			  from scm_mst_item_sn with (nolock)
																			 where division_id = @p_division_id
																			   and active_flag = 'Y'
																			   and nick_name like '%ISUZU%'
																			   AND ITEM_TYPE = 'P')
														) S
														INNER JOIN SCM_MST_ITEM_SN M WITH (NOLOCK)
													ON S.DIVISION_ID = M.DIVISION_ID
												    AND S.CHILD_ITEM_ID = M.ITEM_ID
													WHERE M.nick_name like '%ISUZU%'
													  AND M.ITEM_TYPE = 'P')
                     GROUP BY   A.DIVISION_ID             
                      , A.OPERATION_GROUP         
                      , A.ITEM_ID        
                      , A.SCM_SITE_ID  
                      , A.LINE_ID   
                      , M.COLUMN_NAME  
                      , A.YYYYMMDD       
                      , M.SORT_ORDER_NO									
			          , M.COLUMN_LABEL_NAME							
			          , A.OPERATION_ID	
					  , A.ATTRIBUTE10
							;
			END
			------------------------------------------------------------------------------------------------------------- end
                -- FG의 PROJECT_CODE 값이 다른 경우 UPDATE 로직 추가
                -- SCP_ANL_SHIPMENT_PLAN_FG SHIP_PLAN 입력 (FG) 로직으로 임시테이블 생성
                ------------------------------------------------------------------------------------------
                 IF OBJECT_ID('tempdb..#tmp_SCP_ANL_SHIPMENT_PLAN_FG')  IS NOT NULL       
		              DROP TABLE #tmp_SCP_ANL_SHIPMENT_PLAN_FG
              -- FG
                  SELECT DIVISION_ID                        
                      ,PLAN_START_YYYYMMDD                        
                      ,PLAN_TYPE                 
                      ,SEQ                        
                      ,MAX(OPERATION_GROUP)     AS OPERATION_GROUP                
                      ,ISNULL(PROJECT_CODE,'-') AS PROJECT_CODE                
                      ,ITEM_ID                        
                      ,TO_SITE                        
                      ,INCOTERMS                        
                      ,FROM_SITE                        
                      ,BOD_ID                        
                      ,TRANSPORT_MODE                        
                      ,MEASURE                        
                      ,YYYYMMDD                         
                      ,SUM(QTY) AS QTY                      -- sum     
                      ,'SCP_ANL_SHIPMENT_PLAN_FG' AS ATTRIBUTE1
                 INTO #tmp_SCP_ANL_SHIPMENT_PLAN_FG
                 FROM (                        
                                   
                       SELECT        
                              B.DIVISION_ID                        
                             ,B.PLAN_START_YYYYMMDD                      -- plan주의 월요일  ,dbo.FN_GET_BUCKET_YYYYMMDD(0)                         
                             ,B.PLAN_TYPE                        
                             ,B.SEQ                          
                             ,B.OPERATION_GROUP                        
                             ,A.PROJECT_CODE                        
                             ,B.ITEM_ID                        
                             ,B.TO_SITE                    
                              , (CASE WHEN B.INCOTERMS <> '-'  AND  B.INCOTERMS IS NOT NULL THEN B.INCOTERMS
                                     ELSE (SELECT TOP 1 X.INCOTERMS                      
                                             FROM SCP_MST_BOD_N_V X WITH(NOLOCK)              -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V          
                                            WHERE X.DIVISION_ID  = B.DIVISION_ID                        
                                              AND X.BOD_ID       = B.BOD_ID )  
                                     END ) AS INCOTERMS 

                             ,B.FROM_SITE                        
                             ,B.BOD_ID                         
                             ,B.TRANSPORT_MODE                        
                             ,B.MEASURE                 
                             ,B.YYYYMMDD                        
                             ,A.ALLOCATION_QTY         AS QTY   
                         FROM DBO.SCP_PLN_SHIPMENT_PLAN_PEGGING A WITH (NOLOCK)                         
                         LEFT OUTER JOIN  SCP_PLN_SHIPMENT_PLAN B WITH (NOLOCK)                   
                         ON 0 = 0                
                        AND A.DIVISION_ID           = B.DIVISION_ID                        
                         AND A.PLAN_START_YYYYMMDD   = B.PLAN_START_YYYYMMDD                
                         AND A.PLAN_TYPE             = B.PLAN_TYPE                          
                         AND A.SEQ                   = B.SEQ                               
                         AND A.ORDER_ID              = B.ORDER_ID                 
                         AND A.DIVISION_ID           = @p_division_id                
                         AND A.PLAN_START_YYYYMMDD   = @p_plan_start_yyyymmdd                    
                         AND A.PLAN_TYPE             = @p_plan_type                  
                         AND A.SEQ                   = @p_seq                      
                         AND B.MEASURE               = 'SHIP_PLAN'                
                         AND B.SEMI_YN               = 'N'                      
                         --AND A.ENG_DEMAND_ID        <> 'UNPEGGING' 
                         WHERE 1 = 1                        
                           AND A.DIVISION_ID         = @p_division_id                       
                           AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd                          
                           AND A.PLAN_TYPE           = @p_plan_type                        
                           AND A.SEQ                 = @p_seq                            
                           AND B.DIVISION_ID         is not null       
                    ) X                        
                 GROUP BY                        
                       DIVISION_ID                        
                      ,PLAN_START_YYYYMMDD                        
                      ,PLAN_TYPE                
                      ,SEQ                        
                      ,ISNULL(PROJECT_CODE,'-')                 
                      ,ITEM_ID                        
                      ,TO_SITE                        
                      ,INCOTERMS                        
                      ,FROM_SITE                        
                      ,TRANSPORT_MODE                        
                      ,BOD_ID                        
                      ,MEASURE                        
                      ,YYYYMMDD                     
                      ;

                ------------------------------------------------------------------------------------------
                -- PROJECT_CODE UPDATE
                ------------------------------------------------------------------------------------------
                  UPDATE X
                     SET X.PROJECT_CODE = Y.PROJECT_CODE
                    FROM #PSI_GLOBAL_SMALL_PACK X  WITH (NOLOCK)
                   INNER JOIN #tmp_SCP_ANL_SHIPMENT_PLAN_FG Y WITH (NOLOCK)
                      ON X.DIVISION_ID = Y.DIVISION_ID
                     AND X.ITEM_ID     = Y.ITEM_ID
                     AND X.TO_SITE     = Y.TO_SITE
                     AND X.FROM_SITE   = Y.FROM_SITE
                     AND X.YYYYMMDD    = Y.YYYYMMDD
                   WHERE 0 = 0
                     AND X.MEASURE     = 'PACK_SHIP_PLAN'
                     ;

            -- SSP입력(CELL_SHIP_PLAN_SSP)
               INSERT INTO #PSI_GLOBAL_SMALL_PACK	 
                SELECT   DISTINCT A.DIVISION_ID
                        ,A.BIZ_TYPE AS OPERATION_GROUP
                        ,A.ITEM_ID AS CELL_ITEM_ID
                        ,A.ITEM_ID
                        , ISNULL(NULLIF(A.TO_SITE, '') , '-') TO_SITE		
                        , '' AS PROJECT_CODE
			                  , 0 AS TO_BOH_QTY										
			                  , 0 AS FROM_BOH_QTY		
                        ,X.INCOTERMS
                        ,A.FROM_SITE
                        ,A.TRANSPORT_MODE AS TRANSPORT_MODE_LINE
                        ,A.TRANSPORT_MODE AS TRANSPORT_MODE
                        ,NULL AS PROD_LINE
                        ,M.COLUMN_NAME AS MEASURE
                        ,A.YYYYMMDD
                        ,ISNULL(A.QTY,0)     AS QTY  
                        ,M.SORT_ORDER_NO
                        ,M.COLUMN_LABEL_NAME 
                        ,A.BOD_ID
                        ,'SSP_ANL_SHIP_REQ' AS ATTRIBUTE1   
                        ,A.ATTRIBUTE9 -- operation_id
                        ,'3' AS ATTRIBUTE10  -- 3
                        , NULL AS WEEK_COLUMN
--                FROM SSP_ANL_SHIP_REQ A  WITH (NOLOCK)
                FROM SSP_ANL_SHIP_CONFIRM A  WITH (NOLOCK)
                INNER JOIN #MEASURE M WITH(NOLOCK)	 
                  ON  M.COLUMN_NAME        =  'CELL_SHIP_PLAN_SSP'
                INNER JOIN #PSI_GLOBAL_SMALL_PACK X WITH (NOLOCK)
                  ON  0 = 0
                  AND X.ITEM_ID             = A.ITEM_ID
                  AND X.FROM_SITE           = A.FROM_SITE
                  AND X.TO_SITE             = A.TO_SITE
                  AND X.OPERATION_GROUP     = 'A'
                WHERE 0 = 0
                  AND A.YYYYMMDD             >= @p_plan_start_yyyymmdd
                  AND A.TO_SITE              <> '-'
                  AND A.QTY                  > 0.0  -- 수량이 있는 경우에만 TRANSPORT_MODE가 있음.                 
				  AND A.CHANGE_TYPE = 'C' -- 250306, KSK, 승인은 'C', 승인전은 'N'


              -- SSP_ANL_SHIP_REQ 에서 가져온 CELL_SHIP_PLAN_SSP OPERATION_ID 추가
             UPDATE X
                SET X.ATTRIBUTE9 = SUBSTRING(Y.FLOW_ID,1,5) -- OPERATION_ID
                FROM #PSI_GLOBAL_SMALL_PACK X WITH (NOLOCK)
                INNER JOIN SCP_MST_FINAL_ITEM  Y WITH (NOLOCK)
                ON 0 = 0
                AND X.ITEM_ID     = Y.ITEM_ID
                AND X.DIVISION_ID = Y.DIVISION_ID
                WHERE X.ATTRIBUTE1  = 'SSP_ANL_SHIP_REQ'

              UPDATE X
                SET X.ATTRIBUTE9 = Y.PLANT_ID
                FROM #PSI_GLOBAL_SMALL_PACK X WITH (NOLOCK)
                INNER JOIN SCM_MST_SITE Y WITH(NOLOCK)
                ON 0 = 0
                AND Y.DIVISION_ID = X.DIVISION_ID
                AND Y.SCM_SITE_ID = X.FROM_SITE
                AND Y.OSP_YN      = 'Y'
                AND X.ATTRIBUTE1  = 'SSP_ANL_SHIP_REQ'

            
            -------------------------------------------------------------------------------------------------------------------------         
            -- SCP_MST_OUTSOURCING_CAPA --> PACK_PROD로 입력
            -------------------------------------------------------------------------------------------------------------------------  			
              INSERT INTO #PSI_GLOBAL_SMALL_PACK	
              SELECT X.DIVISION_ID
                  , 'P' AS OPERATION_GROUP
                  , (SELECT TOP 1 A.CELL_ITEM_ID FROM #PSI_GLOBAL_SMALL_PACK A WITH (NOLOCK) WHERE A.ITEM_ID = X.ITEM_ID) AS CELL_ITEM_ID
                  , X.ITEM_ID
                  ,  '-' AS TO_SITE
                  , '' AS PROJECT_CODE  -- 이후 UDPATE
                  , 0 AS TO_BOH_QTY
                  , 0 AS FROM_BOH_QTY
                  , '-' AS INCOTERMS
                  , X.PLANT_SITE_ID AS FROM_SITE
                  , '-'   AS TRANSPORT_MODE_LINE
                  , NULL  AS TRANSPORT_MODE
                  , NULL  AS PROD_LINE
                  , 'PACK_PROD' AS MEASURE
                  , C.BASIS_YYYYMMDD AS YYYYMMDD
                  , '0' AS QTY
                  , M.SORT_ORDER_NO SORT_ORDER_NO
                  , M.COLUMN_LABEL_NAME AS COLUMN_LABEL_NAME
                  , '-' AS BOD_ID
                  , 'SCP_MST_OUTSOURCING_CAPA' AS ATTRIBUTE1
                  , 'ATTRIBUTE9' AS ATTRIBUTE9    -- OPERATION_ID
                  , '1' AS ATTRIBUTE10
                  , NULL AS WEEK_COLUMN
            FROM SCP_MST_OUTSOURCING_CAPA X WITH (NOLOCK)
            INNER JOIN SCM_MST_SITE_ITEM_PRIORITY Y WITH (NOLOCK)   -- -- DIVISION_ID, PLANT_SITE_ID, ITEM_ID
                    ON X.DIVISION_ID  = Y.DIVISION_ID
                   AND X.ITEM_ID      = Y.ITEM_ID
                   AND X.PLANT_SITE_ID= Y.PLANT_SITE_ID
                   AND Y.VALID_YN     = 'Y'
            INNER JOIN #MEASURE M WITH(NOLOCK)	 
                    ON M.COLUMN_NAME  = 'PACK_PROD'
              INNER JOIN SCM_SYS_CALENDAR_M C   WITH (NOLOCK)
                    ON 0 = 0
                    AND C.BASIS_YYYYMMDD >=  @p_plan_start_yyyymmdd
		                AND C.BASIS_YYYYMMDD <=   @v_to_yyyymmdd --말일포함(KSK, 20240814)
            WHERE 0 = 0
            AND X.DIVISION_ID = @p_division_id
            AND X.ITEM_ID IN (
                              SELECT DISTINCT ITEM_ID 
                              FROM #PSI_GLOBAL_SMALL_PACK  WITH (NOLOCK)
                            )
		
            -- SCP_ANL_PSI_GLOBAL_SMALL, SCP_MST_OUTSOURCING_CAPA 중에 중복될 경우 삭제
            DELETE TBL FROM
	                (
	                        SELECT
	                               ROW_NUMBER() OVER (PARTITION BY OPERATION_GROUP, CELL_ITEM_ID,ITEM_ID,TO_SITE,INCOTERMS, FROM_SITE, MEASURE,YYYYMMDD
                                 ORDER BY ATTRIBUTE1) AS ROWNUM
--                                 ,*
	                        FROM #PSI_GLOBAL_SMALL_PACK
                          WHERE MEASURE IN ('PACK_PROD')
	                ) AS TBL
	                WHERE TBL.ROWNUM > 1

            -- SCP_MST_OUTSOURCING_CAPA 에서 가져온 PACK_PROD OPERATION_ID 추가
             UPDATE X
                SET X.ATTRIBUTE9 = SUBSTRING(Y.FLOW_ID,1,5) -- OPERATION_ID
                FROM #PSI_GLOBAL_SMALL_PACK X WITH (NOLOCK)
                INNER JOIN SCP_MST_FINAL_ITEM  Y WITH (NOLOCK)
                ON 0 = 0
                AND X.ITEM_ID     = Y.ITEM_ID
                AND X.DIVISION_ID = Y.DIVISION_ID
                WHERE X.ATTRIBUTE1  = 'SCP_MST_OUTSOURCING_CAPA'


              UPDATE X
                SET X.ATTRIBUTE9 = Y.PLANT_ID
                FROM #PSI_GLOBAL_SMALL_PACK X WITH (NOLOCK)
                INNER JOIN SCM_MST_SITE Y WITH(NOLOCK)
                ON 0 = 0
                AND Y.DIVISION_ID = X.DIVISION_ID
                AND Y.SCM_SITE_ID = X.FROM_SITE
                AND Y.OSP_YN      = 'Y'
                AND X.ATTRIBUTE1  = 'SCP_MST_OUTSOURCING_CAPA'

            -------------------------------------------------------------------------------------------------------------------------         
            -- MEASURE 추가 : PACK TO SITE별 
            /*
                            DM_MKT_FCST	          MKT FCST					10	PACK,TO_SITE    DB
							WHIN_TOTAL			  WH In						30	PACK,TO_SITE    CAL
							TO_SITE_BOH	          Model inventory(BOH)	80	PACK,TO_SITE    DB
                            TO_SITE_EOH	          Model inventory(EOH)	90	PACK,TO_SITE    DB

                            SHIP_REQ					Ship Req					20	PACK,TO_SITE    DB                          
                            SHIP_PLAN_TOTAL	      Ship Plan	            40	PACK,TO_SITE    CAL
                            INTRANSIT_TOTAL	      In transit				50	PACK,TO_SITE    CAL
                            BALANCE						Balance					60	PACK,TO_SITE    CAL
                            BALANCE_CUM	          Balance(cum)	        70	PACK,TO_SITE    CAL                            
            */
            -------------------------------------------------------------------------------------------------------------------------

            INSERT INTO #PSI_GLOBAL_SMALL_PACK
            SELECT  DISTINCT            
						DIVISION_ID								
			            , OPERATION_GROUP						
			            , CELL_ITEM_ID							
			            , ITEM_ID										
			            , TO_SITE
						, PROJECT_CODE
			            , TO_BOH_QTY										
			            , FROM_BOH_QTY									
			            , INCOTERMS 																
						, CASE WHEN MEASURE IN ('DM_MKT_FCST', 'WHIN_TOTAL', 'TO_SITE_BOH', 'TO_SITE_EOH') THEN '-' ELSE  FROM_SITE END					AS FROM_SITE	
						, CASE WHEN MEASURE IN ('DM_MKT_FCST', 'WHIN_TOTAL', 'TO_SITE_BOH', 'TO_SITE_EOH') THEN '-' ELSE  TRANSPORT_MODE_LINE END AS TRANSPORT_MODE_LINE	
						, CASE WHEN MEASURE IN ('DM_MKT_FCST', 'WHIN_TOTAL', 'TO_SITE_BOH', 'TO_SITE_EOH') THEN '-' ELSE  TRANSPORT_MODE END		AS TRANSPORT_MODE	
						, PROD_LINE
			            , MEASURE												
			            , YYYYMMDD	
						, 0    AS QTY
			            , SORT_ORDER_NO									
			            , COLUMN_LABEL_NAME											
						, CASE WHEN MEASURE IN ('DM_MKT_FCST', 'WHIN_TOTAL', 'TO_SITE_BOH', 'TO_SITE_EOH') THEN '-' ELSE  BOD_ID END		AS BOD_ID									
						, ATTRIBUTE1										
						, CASE WHEN MEASURE IN ('DM_MKT_FCST', 'WHIN_TOTAL', 'TO_SITE_BOH', 'TO_SITE_EOH') THEN NULL ELSE  ATTRIBUTE9 END		AS ATTRIBUTE9									
			            , ATTRIBUTE10			
						, NULL AS WEEK_COLUMN
                     FROM                 
                         (                
							-- 2021.04.06   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 0값 제거에 따른 로직보완 - DM_MKT_FCST, CELL_PKG_PLAN_IN 추가 - start
							SELECT    Z.DIVISION_ID								
									, Z.OPERATION_GROUP						
									, Z.CELL_ITEM_ID							
									, Z.ITEM_ID										
									, Z.TO_SITE
							        , Z.PROJECT_CODE
									, Z.TO_BOH_QTY										
									, Z.FROM_BOH_QTY									
									, Z.INCOTERMS 										
									, Z.FROM_SITE 										
									, Z.TRANSPORT_MODE_LINE			
							        , Z.TRANSPORT_MODE
							        , Z.PROD_LINE
									, Z.MEASURE
								    , C.YYYYMMDD	
									, Z.SORT_ORDER_NO								
									, Z.COLUMN_LABEL_NAME							
									, Z.BOD_ID						
							        , Z.ATTRIBUTE1										
									, Z.ATTRIBUTE9										
									, Z.ATTRIBUTE10	
							  FROM (
									SELECT  DISTINCT  X.DIVISION_ID								
														  , X.OPERATION_GROUP						
														  , X.CELL_ITEM_ID							
														  , X.ITEM_ID										
														  , X.TO_SITE
													, '' AS PROJECT_CODE
														  , X.TO_BOH_QTY										
														  , X.FROM_BOH_QTY									
														  , X.INCOTERMS 										
														  , X.FROM_SITE 										
														  , X.TRANSPORT_MODE_LINE			
													, X.TRANSPORT_MODE
													, X.PROD_LINE
														  , M.COLUMN_NAME AS MEASURE
																--, X.YYYYMMDD	
														  , M.SORT_ORDER_NO								
														  , M.COLUMN_LABEL_NAME							
														  , X.BOD_ID						
													, X.ATTRIBUTE1										
														  , X.ATTRIBUTE9										
														  , ATTRIBUTE10	
										FROM #PSI_GLOBAL_SMALL_PACK X WITH(NOLOCK)     
										LEFT OUTER JOIN #MEASURE M WITH (NOLOCK) 
										ON DIV ='C' AND GUBUN = 'TO'
									  WHERE 1=1          
									   AND X.MEASURE     = 'SHIP_REQ'
							       ) Z,
								   (SELECT BASIS_YYYYMMDD as YYYYMMDD 
									FROM SCM_SYS_CALENDAR_M WITH(NOLOCK) 
									WHERE BASIS_YYYYMMDD BETWEEN @p_plan_start_yyyymmdd AND @v_to_yyyymmdd) C
							-- 2021.04.06   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 0값 제거에 따른 로직보완 - DM_MKT_FCST, CELL_PKG_PLAN_IN 추가 - end
                         ) SUB                
                         WHERE 1=1                
                           AND NOT EXISTS (                
                                            SELECT 'X'                
                                              FROM #PSI_GLOBAL_SMALL_PACK Z WITH(NOLOCK)                
                                             WHERE 1=1                
                                               AND Z.DIVISION_ID          = SUB.DIVISION_ID                
                                               AND Z.OPERATION_GROUP      = SUB.OPERATION_GROUP                
                                               AND Z.CELL_ITEM_ID         = SUB.CELL_ITEM_ID                
                                               AND Z.ITEM_ID              = SUB.ITEM_ID                
                                               AND Z.TO_SITE              = SUB.TO_SITE                        
                                               AND Z.TO_BOH_QTY           = SUB.TO_BOH_QTY          
                                               AND Z.FROM_BOH_QTY         = SUB.FROM_BOH_QTY                
                                               AND Z.INCOTERMS            = SUB.INCOTERMS                
                                               AND Z.FROM_SITE            = SUB.FROM_SITE                
                                               AND Z.TRANSPORT_MODE_LINE  = SUB.TRANSPORT_MODE_LINE          
                                               AND Z.MEASURE              = SUB.MEASURE 
                                               AND Z.YYYYMMDD             = SUB.YYYYMMDD          
                                               AND Z.BOD_ID               = SUB.BOD_ID      
                                               AND Z.ATTRIBUTE1						=	SUB.ATTRIBUTE1					
			                                         AND Z.ATTRIBUTE9						=	SUB.ATTRIBUTE9					
			                                         AND Z.ATTRIBUTE10	        = SUB.ATTRIBUTE10	
                                          )      

                              AND SUB.MEASURE   <> 'SHIP_REQ'

            -------------------------------------------------------------------------------------------------------------------------         
            -- MEASURE 추가 : PACK TO SITE별 (DM_MKT_FCST)
            -------------------------------------------------------------------------------------------------------------------------

              IF OBJECT_ID('tempdb..#DM_MKT_FCST') IS NOT NULL	
	              DROP TABLE #DM_MKT_FCST

                DECLARE @p_dt1 NVARCHAR(100) = CONVERT(VARCHAR(8), DATEADD(day, 1, @p_plan_start_yyyymmdd), 112) -- 화요일
                DECLARE @p_dt2 NVARCHAR(100) = CONVERT(VARCHAR(8), DATEADD(day, -7, @p_plan_start_yyyymmdd), 112) -- 화요일-7(전주)
                DECLARE @p_version_no NVARCHAR(100) = ''

                  				--원본교체로 사용안함( KSK, 2024/11/12)
              --    SELECT @p_version_no = MAX(VERSION_NO)
              --    FROM  DBO.DM_PLN_MKT_FCST_C P WITH(NOLOCK)
              --    WHERE P.DIVISION_ID       = @p_division_id
              --      AND P.CUTOFF_TYPE       IN ('MF_W','MF_M')
              --      AND P.MEASURE           = 'MKT_FCST'
              --      AND P.CREATION_DATE   = (
              --                                SELECT MAX(X.CREATION_DATE) -- 강제 수정 DATA 일 경우 포함 하기 위해서
              --                                FROM   DBO.DM_PLN_MKT_FCST_C X WITH(NOLOCK)
              --                                WHERE  X.DIVISION_ID      = @p_division_id
              --                                  AND  X.CUTOFF_TYPE      IN ('MF_W','MF_M')
              --                                  AND  X.MEASURE          = 'MKT_FCST'
              --                                  AND  X.CUTOFF_YYYYMMDD <= @p_dt1 -- 화요일 --
              --                                  AND  X.CUTOFF_YYYYMMDD >= @p_dt2  -- 화요일-3일 --'20190219'
		            --                              GROUP BY  DIVISION_ID 
              --                                )
		            --GROUP BY  DIVISION_ID, CREATION_DATE

			-- 2023-01-13   KKH			소형팩 시뮬레이터 mkt_fcst수량 수정 (최종 월에 해당하는 값만 업데이트 -> 여러건을 group by에서 최종값 연결)
                SELECT X.yyyymmdd, X.DIVISION_ID,X.ITEM_ID, X.SCM_SITE_ID,X.INCOTERMS, SUM(X.QTY) as QTY
                   INTO #DM_MKT_FCST
                   FROM (
                          SELECT AA.DIVISION_ID		                          
                               , AA.PROJECT_CODE
                               , AA.SCM_SITE_ID
                               , AA.ITEM_ID
                               , AA.DOM_EXP
                               , AA.FCST_TYPE                    
                               , AA.INCOTERMS                        
                               , AA.PLANT_SITE_ID                    
                               , AA.YYYYMMDD                      
                               , AA.QTY        
    --                           , AA.MEASURE
                               , 'DM_MKT_FCST' AS MEASURE
						 --원본교체 DM_PLN_MKT_FCST_C => DM_PLN_MKT_FCST  ( KSK, 2024/11/12)
                          FROM   DM_PLN_MKT_FCST AA WITH (NOLOCK)
                                 -- VMI 비대상 SITE 조회
                                  INNER JOIN ( 
                                              SELECT DIVISION_ID, SCM_SITE_ID, VMI_YN , operation_group
                                              FROM   SCM_MST_SITE  WITH (NOLOCK)
                                              WHERE  DIVISION_ID = @p_division_id
                                              AND    VALID_YN    = 'Y'
                                             ) MSE
                                  ON   AA.DIVISION_ID = MSE.DIVISION_ID
                                 AND  AA.SCM_SITE_ID = MSE.SCM_SITE_ID 

                          WHERE  AA.DIVISION_ID     = @p_division_id--'81'
                           -- 2018.07.06 참고) DM_PLN_MKT_FCST 관련 수정 시 PR_SCP_ENG_IN_SP_SET_INVENTORY 프로시저의 DM_PLN_MKT_FCST 테이블 사용부분도 수정해야함
                           -- 2018.07.03   DEMAND 기준을 DAILY CUTOFF FCST에서 실시간 MKT FCST로 변경 : CUTOFF 조건 제거
                          --AND    AA.CUTOFF_TYPE   IN ('MF_W','MF_M')
                          --AND    AA.MEASURE       = 'MKT_FCST'
						  AND aa.measure = CASE WHEN ISNULL(MSE.operation_group, '') = 'W' THEN 'AS_In_Req' 
									WHEN MSE.vmi_yn = 'Y' THEN 'VMI_In_Req' 
									WHEN ISNULL(aa.attribute10, '') = '' THEN 'MKT_FCST' END
		                  AND    AA.FCST_TYPE     <> 'RMA'  -- 20181115 반품예정수량은 제외
                          AND    AA.QTY            >  0 
                          --AND    AA.version_no    = @p_version_no  

                      ) X
					  group by X.yyyymmdd, X.DIVISION_ID,X.ITEM_ID,X.SCM_SITE_ID,X.INCOTERMS ;


                UPDATE X
                SET X.QTY       = Y.QTY
                FROM #PSI_GLOBAL_SMALL_PACK X  WITH (NOLOCK)
                INNER JOIN #DM_MKT_FCST  Y WITH (NOLOCK)
                ON 0 = 0
                AND X.DIVISION_ID   = Y.DIVISION_ID
		            AND X.YYYYMMDD      = Y.YYYYMMDD
                AND X.ITEM_ID       = Y.ITEM_ID
                AND X.TO_SITE       = Y.SCM_SITE_ID
				AND X.INCOTERMS     = Y.INCOTERMS		-- 2022.07.20 Forcast 수량오류로 추가
                AND X.MEASURE       = 'DM_MKT_FCST'
            -------------------------------------------------------------------------------------------------------------------------         
            -- MEASURE 추가 : PACK FROM SITE별
            /*
                PACK_WHIN	          WH In	          210	PACK,TO_SITE,FROM_SITE	CALC
                PACK_INTRANSIT	    In transit	    220	PACK,TO_SITE,FROM_SITE	CALC
                PACK_INTRANSIT_ETA	In-Transit(ETA)	230	PACK,TO_SITE,FROM_SITE	DB
                PACK_SHIP_PLAN_ETA	Ship Plan(ETA)	240	PACK,TO_SITE,FROM_SITE	CALC
                PACK_SHIP_PLAN	    Ship Plan	      250	PACK,TO_SITE,FROM_SITE	DB
            */
            -------------------------------------------------------------------------------------------------------------------------
            INSERT INTO #PSI_GLOBAL_SMALL_PACK
            SELECT  DISTINCT            
                    DIVISION_ID								
			            , OPERATION_GROUP						
			            , CELL_ITEM_ID							
			            , ITEM_ID										
			            , TO_SITE
                  , PROJECT_CODE
			            , TO_BOH_QTY										
			            , FROM_BOH_QTY									
			            , INCOTERMS 										
			            , FROM_SITE 										
			            , TRANSPORT_MODE_LINE			
                  , TRANSPORT_MODE
                  , PROD_LINE
			            , MEASURE												
			            , YYYYMMDD	
                  , 0    AS QTY
			            , SORT_ORDER_NO									
			            , COLUMN_LABEL_NAME							
                  --, (CASE WHEN MEASURE = 'PACK_SHIP_PLAN' THEN BOD_ID  ELSE '-' END) AS BOD_ID 				
				  ,  BOD_ID 		
                  , ATTRIBUTE1										
			            , ATTRIBUTE9										
			            , ATTRIBUTE10			
                  , NULL AS WEEK_COLUMN
                     FROM                 
                         (                
                              
                            SELECT  DISTINCT  X.DIVISION_ID								
			                                      , X.OPERATION_GROUP						
			                                      , X.CELL_ITEM_ID							
			                                      , X.ITEM_ID										
			                                      , X.TO_SITE
                                            , '' AS PROJECT_CODE
			                                      , X.TO_BOH_QTY										
			                                      , X.FROM_BOH_QTY									
			                                      , X.INCOTERMS 										
			                                      , X.FROM_SITE 										
												, TRANSPORT_MODE_LINE			
												, TRANSPORT_MODE
                                            , '-' AS PROD_LINE
			                                      , M.COLUMN_NAME AS MEASURE
						                                , X.YYYYMMDD	
			                                      , M.SORT_ORDER_NO								
			                                      , M.COLUMN_LABEL_NAME							
			                                      , X.BOD_ID	                                            					
                                            , X.ATTRIBUTE1										
			                                      , X.ATTRIBUTE9										
			                                      , ATTRIBUTE10	
                                FROM #PSI_GLOBAL_SMALL_PACK X WITH(NOLOCK)     
                                LEFT OUTER JOIN #MEASURE M WITH (NOLOCK) 
                                ON DIV ='P' AND GUBUN = 'TO_FROM'				--PACK_SHIP_PLAN_ETA
                              WHERE 1=1          
                                AND X.MEASURE         = 'PACK_SHIP_PLAN'
                                AND X.OPERATION_GROUP = 'P'
            
                         ) SUB                
                         WHERE 1=1                
                           AND NOT EXISTS (                
                                            SELECT 'X'                
                                              FROM #PSI_GLOBAL_SMALL_PACK Z WITH(NOLOCK)                
                                             WHERE 1=1                
                                               AND Z.DIVISION_ID          = SUB.DIVISION_ID                
                                               AND Z.OPERATION_GROUP      = SUB.OPERATION_GROUP                
                                               AND Z.CELL_ITEM_ID         = SUB.CELL_ITEM_ID                
                                               AND Z.ITEM_ID              = SUB.ITEM_ID                
                                               AND Z.TO_SITE              = SUB.TO_SITE        
--                                               AND Z.PROJECT_CODE         = SUB.PROJECT_CODE                                                               
                                               AND Z.TO_BOH_QTY           = SUB.TO_BOH_QTY          
                                               AND Z.FROM_BOH_QTY         = SUB.FROM_BOH_QTY                
                                               AND Z.INCOTERMS            = SUB.INCOTERMS                
                                               AND Z.FROM_SITE            = SUB.FROM_SITE                
                                               AND Z.TRANSPORT_MODE_LINE  = SUB.TRANSPORT_MODE_LINE          
                                               --AND Z.TRANSPORT_MODE       = SUB.TRANSPORT_MODE          
                                               --AND Z.PROD_LINE            = SUB.PROD_LINE
                                               AND Z.MEASURE              = SUB.MEASURE 
                                               AND Z.YYYYMMDD             = SUB.YYYYMMDD          
                                               AND Z.BOD_ID               = SUB.BOD_ID      
                                               AND Z.ATTRIBUTE1						=	SUB.ATTRIBUTE1					
			                                         AND Z.ATTRIBUTE9						=	SUB.ATTRIBUTE9					
			                                         AND Z.ATTRIBUTE10	        = SUB.ATTRIBUTE10	
                                          )      

                    AND SUB.MEASURE   <> 'PACK_SHIP_PLAN'

				-- RTF관련	
				-------------------------------------------------------------------------------------------------------------------------
				INSERT INTO #PSI_GLOBAL_SMALL_PACK              
				SELECT  DISTINCT  X.DIVISION_ID								
			                                , X.OPERATION_GROUP						
			                                , X.CELL_ITEM_ID							
			                                , X.ITEM_ID										
			                                , X.TO_SITE

											, X.PROJECT_CODE 
			                                , X.TO_BOH_QTY										
			                                , X.FROM_BOH_QTY									
			                                ,  INCOTERMS 										
			                                ,  '-' AS  FROM_SITE 		
											
			                                , '-' TRANSPORT_MODE_LINE			
											, '-'  TRANSPORT_MODE
											, '-'  PROD_LINE
			                                , M.COLUMN_NAME AS MEASURE
						                    , X.YYYYMMDD	

											 , 0    AS QTY
			                                , M.SORT_ORDER_NO								
			                                , M.COLUMN_LABEL_NAME							
			                                , '-' AS  BOD_ID	                                            					
											, X.ATTRIBUTE1										
			                                , '-' AS ATTRIBUTE9										
			                                , X.ATTRIBUTE10	
											, NULL AS WEEK_COLUMN
                        FROM #PSI_GLOBAL_SMALL_PACK X WITH(NOLOCK)     
                        LEFT OUTER JOIN #MEASURE M WITH (NOLOCK) 
                        ON M.COLUMN_NAME IN ('ALLOCATION', 'FCST_RTF_GAP', 'FCST_RTF_ACC')
                        WHERE 1=1
                        AND X.MEASURE         = 'DM_MKT_FCST'
                        AND X.OPERATION_GROUP = 'P'

             -------------------------------------------------------------------------------------------------------------------------         
            -- MEASURE 추가 : PACK FROM SITE별
            /*
                PACK_PROD	      Production	          260	PACK,FROM_SITE	DB
                PACK_PROD_LOAD	Line Total Load	      270	PACK,FROM_SITE	DB
                PACK_BOH	      Model inventory(BOH)	280	PACK,FROM_SITE	DB,CALC
                PACK_EOH	      Model inventory(EOH)	290	PACK,FROM_SITE	CALC
            */
            -------------------------------------------------------------------------------------------------------------------------

            INSERT INTO  #PSI_GLOBAL_SMALL_PACK
            SELECT  DISTINCT            
                    DIVISION_ID								
			            , OPERATION_GROUP						
			            , CELL_ITEM_ID							
			            , ITEM_ID										
			            , TO_SITE
                  , PROJECT_CODE
			            , TO_BOH_QTY										
			            , FROM_BOH_QTY									
			            , INCOTERMS 										
			            , FROM_SITE 										
			            , TRANSPORT_MODE_LINE			
                  , TRANSPORT_MODE
                  , PROD_LINE
			            , MEASURE												
			            , YYYYMMDD	
                  , 0    AS QTY
			            , SORT_ORDER_NO									
			            , COLUMN_LABEL_NAME							
			            , BOD_ID						
                  , ATTRIBUTE1										
			            , ATTRIBUTE9										
			            , ATTRIBUTE10			
                  , NULL AS WEEK_COLUMN
                     FROM                 
                         (                
                              
                            SELECT  DISTINCT  X.DIVISION_ID								
			                                      , X.OPERATION_GROUP						
			                                      , X.CELL_ITEM_ID							
			                                      , X.ITEM_ID										
			                                      , '-' TO_SITE
                                            , '' AS PROJECT_CODE
			                                      , X.TO_BOH_QTY										
			                                      , X.FROM_BOH_QTY									
			                                      , '-' AS INCOTERMS 										
			                                      , X.FROM_SITE 										
			                                      , '-' AS TRANSPORT_MODE_LINE			
                                            , '-' AS TRANSPORT_MODE
                                            , '-' AS PROD_LINE
			                                      , M.COLUMN_NAME AS MEASURE
						                                , X.YYYYMMDD	
			                                      , M.SORT_ORDER_NO								
			                                      , M.COLUMN_LABEL_NAME							
			                                      , '-' AS BOD_ID						
                                            , X.ATTRIBUTE1										
			                                      , X.ATTRIBUTE9										
			                                      , ATTRIBUTE10	
                                FROM #PSI_GLOBAL_SMALL_PACK X WITH(NOLOCK)     
                                LEFT OUTER JOIN #MEASURE M WITH (NOLOCK) 
                                ON DIV ='P' AND GUBUN = 'FROM'
                              WHERE 1=1          
                                AND X.MEASURE         = 'PACK_PROD'
                                AND X.OPERATION_GROUP = 'P'
            
                         ) SUB                
                         WHERE 1=1                
                           AND NOT EXISTS (                
                                            SELECT 'X'                
                                              FROM #PSI_GLOBAL_SMALL_PACK Z WITH(NOLOCK)                
                                             WHERE 1=1                
                                               AND Z.DIVISION_ID          = SUB.DIVISION_ID                
                                               AND Z.OPERATION_GROUP      = SUB.OPERATION_GROUP                
                                               AND Z.CELL_ITEM_ID         = SUB.CELL_ITEM_ID  
                                               AND Z.ITEM_ID              = SUB.ITEM_ID                
                                               AND Z.TO_SITE              = SUB.TO_SITE        
--                                               AND Z.PROJECT_CODE         = SUB.PROJECT_CODE                
                                               AND Z.TO_BOH_QTY           = SUB.TO_BOH_QTY          
                                               AND Z.FROM_BOH_QTY         = SUB.FROM_BOH_QTY                
                                               AND Z.INCOTERMS            = SUB.INCOTERMS                
                                               AND Z.FROM_SITE            = SUB.FROM_SITE                
                                               AND Z.TRANSPORT_MODE_LINE  = SUB.TRANSPORT_MODE_LINE          
                                               --AND Z.TRANSPORT_MODE       = SUB.TRANSPORT_MODE          
                                               --AND Z.PROD_LINE            = SUB.PROD_LINE
                                               AND Z.MEASURE              = SUB.MEASURE 
                                               AND Z.YYYYMMDD             = SUB.YYYYMMDD          
                                               AND Z.BOD_ID               = SUB.BOD_ID      
                                               AND Z.ATTRIBUTE1						=	SUB.ATTRIBUTE1					
			                                         AND Z.ATTRIBUTE9						=	SUB.ATTRIBUTE9					
			                                         AND Z.ATTRIBUTE10	        = SUB.ATTRIBUTE10	
                                          )      

                    AND SUB.MEASURE   <> 'PACK_PROD'


            -------------------------------------------------------------------------------------------------------------------------         
            -- MEASURE 추가 : PACK FROM SITE별
            /*
                CELL_REQ	          Cell Requirement Total	410	CELL,TO_PACKER,FROM_SITE	CALC    TO
                CELL_BALANCE	      Balance	                420	CELL,TO_PACKER,FROM_SITE	CALC    TO
                CELL_WHIN	          WH In	                  430	CELL,TO_PACKER,FROM_SITE	CALC    TO

                CELL_INTRANSIT	    In transit	            440	CELL,TO_PACKER,FROM_SITE	CALC    FROM
                CELL_INTRANSIT_ETA	In-Transit(ETA)	        450	CELL,TO_PACKER,FROM_SITE	DB      FROM
                CELL_SHIP_PLAN_ETA	Ship Plan(ETA)	        460	CELL,TO_PACKER,FROM_SITE	CALC    FROM
                CELL_SHIP_PLAN      Ship Plan               470	CELL,TO_PACKER,FROM_SITE	DB      FROM
            */
            -------------------------------------------------------------------------------------------------------------------------

            INSERT INTO #PSI_GLOBAL_SMALL_PACK
            SELECT  DISTINCT            
                    DIVISION_ID								
			            , OPERATION_GROUP						
			            , CELL_ITEM_ID							
			            , ITEM_ID										
			            , TO_SITE
                  , PROJECT_CODE
			            , TO_BOH_QTY										
			            , FROM_BOH_QTY									
			            , INCOTERMS 										
			            , FROM_SITE 										
			            , TRANSPORT_MODE_LINE			
                  , TRANSPORT_MODE
                  , PROD_LINE
			            , MEASURE												
			            , YYYYMMDD	
                  , 0    AS QTY
			            , SORT_ORDER_NO									
			            , COLUMN_LABEL_NAME							
			            , BOD_ID						
                  , ATTRIBUTE1										
			            , ATTRIBUTE9										
			            , ATTRIBUTE10			
                  , NULL AS WEEK_COLUMN
                     FROM                 
                         (                
                              
                            SELECT  DISTINCT  X.DIVISION_ID								
			                                      , 'A' AS OPERATION_GROUP						
			                                      , X.CELL_ITEM_ID							
			                                      , X.ITEM_ID										
			                                      , X.TO_SITE
                                            , '' AS PROJECT_CODE
			                                      , X.TO_BOH_QTY										
			                                      , X.FROM_BOH_QTY									
			                                      , '-' AS INCOTERMS 										
			                                      , '-' AS FROM_SITE 										
			                                      , '-' AS TRANSPORT_MODE_LINE			
                                            , '-' AS TRANSPORT_MODE
                                            , '-' AS PROD_LINE
			                                      , M.COLUMN_NAME AS MEASURE
						                                , X.YYYYMMDD	
			                                      , M.SORT_ORDER_NO								
			                                      , M.COLUMN_LABEL_NAME							
			                                      , '-' AS BOD_ID						
                                            , X.ATTRIBUTE1										
			                                      , X.ATTRIBUTE9										
			                                      , ATTRIBUTE10	
                                FROM #PSI_GLOBAL_SMALL_PACK X WITH(NOLOCK)     
                                LEFT OUTER JOIN #MEASURE M WITH (NOLOCK) 
                                ON DIV ='A' AND GUBUN = 'TO'
                              WHERE 1=1          
--                                AND X.MEASURE         = 'CELL_SHIP_PLAN'   
                         ) SUB                
                         WHERE 1=1                
                           AND SUB.TO_SITE <> '-'
                           AND SUB.OPERATION_GROUP ='A'
                           AND NOT EXISTS (                
                                            SELECT 'X'                
                                              FROM #PSI_GLOBAL_SMALL_PACK Z WITH(NOLOCK)                
                                             WHERE 1=1                
                                               AND Z.DIVISION_ID          = SUB.DIVISION_ID                
                                               AND Z.OPERATION_GROUP      = SUB.OPERATION_GROUP                
                                               AND Z.CELL_ITEM_ID         = SUB.CELL_ITEM_ID                
                                               AND Z.ITEM_ID              = SUB.ITEM_ID                
                                               AND Z.TO_SITE              = SUB.TO_SITE          
                                               AND Z.PROJECT_CODE         = SUB.PROJECT_CODE                                                               
                                               AND Z.TO_BOH_QTY           = SUB.TO_BOH_QTY          
                                               AND Z.FROM_BOH_QTY         = SUB.FROM_BOH_QTY                
                                               AND Z.INCOTERMS            = SUB.INCOTERMS                
                                               AND Z.FROM_SITE            = SUB.FROM_SITE                
                                               AND Z.TRANSPORT_MODE_LINE  = SUB.TRANSPORT_MODE_LINE          
                                               AND Z.MEASURE              = SUB.MEASURE 
                                               AND Z.YYYYMMDD             = SUB.YYYYMMDD          
                                               AND Z.BOD_ID               = SUB.BOD_ID      
                                               AND Z.ATTRIBUTE1						=	SUB.ATTRIBUTE1					
			                                         AND Z.ATTRIBUTE9						=	SUB.ATTRIBUTE9					
			                                         AND Z.ATTRIBUTE10	        = SUB.ATTRIBUTE10	
                                          )      

                    AND SUB.MEASURE   <> 'CELL_SHIP_PLAN'
                    

            INSERT INTO #PSI_GLOBAL_SMALL_PACK
            SELECT  DISTINCT            
                    DIVISION_ID								
			            , OPERATION_GROUP						
			            , CELL_ITEM_ID							
			            , ITEM_ID										
			            , TO_SITE
                  , PROJECT_CODE
			            , TO_BOH_QTY										
			            , FROM_BOH_QTY									
			            , INCOTERMS 										
			            , FROM_SITE 										
			            , TRANSPORT_MODE_LINE			
                  , TRANSPORT_MODE
                  , PROD_LINE
			            , MEASURE												
			            , YYYYMMDD	
                  , 0    AS QTY
			            , SORT_ORDER_NO									
			            , COLUMN_LABEL_NAME							
			            , BOD_ID						
                  , ATTRIBUTE1										
			            , ATTRIBUTE9										
			            , ATTRIBUTE10			
                  , NULL AS WEEK_COLUMN
                     FROM                 
                         (                
							-- 2021.04.06   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 0값 제거에 따른 로직보완 - DM_MKT_FCST, CELL_PKG_PLAN_IN 추가 - start
							SELECT    Z.DIVISION_ID								
									, Z.OPERATION_GROUP						
									, Z.CELL_ITEM_ID							
									, Z.ITEM_ID										
									, Z.TO_SITE
							        , Z.PROJECT_CODE
									, Z.TO_BOH_QTY										
									, Z.FROM_BOH_QTY									
									, Z.INCOTERMS 										
									, Z.FROM_SITE 										
									, Z.TRANSPORT_MODE_LINE			
							        , Z.TRANSPORT_MODE
							        , Z.PROD_LINE
									, Z.MEASURE
									, C.YYYYMMDD
									, Z.SORT_ORDER_NO								
									, Z.COLUMN_LABEL_NAME							
									, Z.BOD_ID						
							        , Z.ATTRIBUTE1										
									, Z.ATTRIBUTE9										
									, Z.ATTRIBUTE10	
							  FROM (
									SELECT  DISTINCT  X.DIVISION_ID								
														  , X.OPERATION_GROUP						
														  , X.CELL_ITEM_ID							
														  , X.ITEM_ID										
														  , X.TO_SITE
													, '' AS PROJECT_CODE
														  , X.TO_BOH_QTY										
														  , X.FROM_BOH_QTY									
														  , '-' AS INCOTERMS 										
														  , X.FROM_SITE 										
														  , '-' AS TRANSPORT_MODE_LINE			
													, '-' AS TRANSPORT_MODE
													, '-' AS PROD_LINE
														  , M.COLUMN_NAME AS MEASURE
																--, X.YYYYMMDD	
														  , M.SORT_ORDER_NO								
														  , M.COLUMN_LABEL_NAME							
														  , '-' AS BOD_ID						
													, X.ATTRIBUTE1										
														  , X.ATTRIBUTE9										
														  , ATTRIBUTE10	
										FROM #PSI_GLOBAL_SMALL_PACK X WITH(NOLOCK)     
										LEFT OUTER JOIN #MEASURE M WITH (NOLOCK) 
										ON DIV ='A' AND GUBUN = 'FROM'
									  WHERE 1=1          
										AND X.MEASURE         = 'CELL_SHIP_PLAN'   
							       ) Z,
								   (SELECT BASIS_YYYYMMDD as YYYYMMDD FROM SCM_SYS_CALENDAR_M WITH(NOLOCK) WHERE BASIS_YYYYMMDD BETWEEN @p_plan_start_yyyymmdd AND @v_to_yyyymmdd) C---------DHJ


							-- 2021.04.06   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 0값 제거에 따른 로직보완 - DM_MKT_FCST, CELL_PKG_PLAN_IN 추가 - end

                         ) SUB                
                         WHERE 1=1                
                           AND NOT EXISTS (                
                                            SELECT 'X'                
                                              FROM #PSI_GLOBAL_SMALL_PACK Z WITH(NOLOCK)                
                                             WHERE 1=1                
                                               AND Z.DIVISION_ID          = SUB.DIVISION_ID                
                                               AND Z.OPERATION_GROUP      = SUB.OPERATION_GROUP                
                                               AND Z.CELL_ITEM_ID         = SUB.CELL_ITEM_ID                
                                               AND Z.ITEM_ID              = SUB.ITEM_ID                
                                               AND Z.TO_SITE              = SUB.TO_SITE          
                                               AND Z.PROJECT_CODE         = SUB.PROJECT_CODE                                                               
                                               AND Z.TO_BOH_QTY           = SUB.TO_BOH_QTY          
                                               AND Z.FROM_BOH_QTY         = SUB.FROM_BOH_QTY                
                                               AND Z.INCOTERMS            = SUB.INCOTERMS                
                                               AND Z.FROM_SITE            = SUB.FROM_SITE                
                                               AND Z.TRANSPORT_MODE_LINE  = SUB.TRANSPORT_MODE_LINE          
                                               --AND Z.TRANSPORT_MODE       = SUB.TRANSPORT_MODE          
                                               --AND Z.PROD_LINE            = SUB.PROD_LINE
                                               AND Z.MEASURE              = SUB.MEASURE 
                                               AND Z.YYYYMMDD             = SUB.YYYYMMDD          
                                               AND Z.BOD_ID               = SUB.BOD_ID      
                                               AND Z.ATTRIBUTE1						=	SUB.ATTRIBUTE1					
			                                         AND Z.ATTRIBUTE9						=	SUB.ATTRIBUTE9					
			                                         AND Z.ATTRIBUTE10	        = SUB.ATTRIBUTE10	
                                          )      

                    --AND SUB.MEASURE   <> 'CELL_SHIP_PLAN'
                    AND SUB.MEASURE   NOT IN ('CELL_SHIP_PLAN','CELL_SHIP_PLAN_SSP')
                    --AND SUB.MEASURE   NOT IN ('CELL_PKG_PLAN_IN','CELL_PKG_PLAN_OUT','CELL_FORMATION','CELL_BOH','CELL_EOH')



                    -- (OPERATION GROUP이 CELL이고, TO_SITE가 PLANT가 아닌것은 제외)
                    DELETE X
                      FROM #PSI_GLOBAL_SMALL_PACK X WITH (NOLOCK)
                      WHERE 0 = 0
                      AND X.MEASURE IN ('CELL_REQ','CELL_BALANCE','CELL_WHIN')
                      AND X.OPERATION_GROUP ='A'
                      AND X.TO_SITE IN (SELECT Y.SCM_SITE_ID 
                                        FROM SCM_MST_SITE Y WITH (NOLOCK) 
                                       WHERE Y.DIVISION_ID = X.DIVISION_ID 
                                         AND Y.SCM_SITE_ID = X.TO_SITE
                      --                   AND Y.SITE_TYPE    <> 'PLANT'
                                         AND Y.SITE_TYPE = 'SALES'
                                     ) 


            -------------------------------------------------------------------------------------------------------------------------         
            -- MEASURE 추가 : PACK FROM SITE별
                /*
                CELL_PKG_PLAN_IN	    PKG Plan_In	          490	  CELL,TO_PACKER,FROM_SITE	  DB
                CELL_PKG_PLAN_OUT	    PKG Plan_Out	        500	  CELL,TO_PACKER,FROM_SITE	  DB,CALC
                CELL_FORMATION	      Formation	            510	  CELL,TO_PACKER,FROM_SITE	  DB
                CELL_BOH	            Model inventory(BOH)	520	  CELL,TO_PACKER,FROM_SITE	  CALC
                CELL_EOH	            Model inventory(EOH)	530	  CELL,TO_PACKER,FROM_SITE	  CALC
                */
            -------------------------------------------------------------------------------------------------------------------------
             -- CELL_PKG_PLAN_IN 
             
              IF OBJECT_ID('tempdb..#CELL_PKG_PLAN_IN') IS NOT NULL	
	              DROP TABLE #CELL_PKG_PLAN_IN




             --INSERT INTO #PSI_GLOBAL_SMALL_PACK	 
             SELECT DISTINCT A.DIVISION_ID								
			            , A.OPERATION_GROUP						
			            , A.CELL_ITEM_ID							
			            , A.ITEM_ID										
			            , '-' AS  TO_SITE		
                  , '' AS PROJECT_CODE
			            , 0 AS TO_BOH_QTY										
			            , 0 AS FROM_BOH_QTY									
			            , A.INCOTERMS 										
			            , A.FROM_SITE 										
			            , NULL            AS TRANSPORT_MODE_LINE			
                  , NULL            AS TRANSPORT_MODE
                  , NULL            AS PROD_LINE
			            , M.COLUMN_NAME     AS MEASURE												
			            , A.YYYYMMDD        AS YYYYMMDD				
                  , SUM(ISNULL(QTY,0))  AS QTY 
			            , M.SORT_ORDER_NO									
			            , M.COLUMN_LABEL_NAME							
			            , A.BOD_ID						
                  , A.ATTRIBUTE1										
			            , A.ATTRIBUTE9										
			            , A.ATTRIBUTE10				
                  , NULL AS WEEK_COLUMN
                INTO #CELL_PKG_PLAN_IN
	               FROM SCP_ANL_PSI_GLOBAL_SMALL A WITH(NOLOCK)	
	               INNER JOIN #MEASURE M WITH(NOLOCK)	 
                      ON M.COLUMN_NAME        =  'CELL_PKG_PLAN_IN'
	                WHERE A.DIVISION_ID			    =  @p_division_id
		                AND A.PLAN_START_YYYYMMDD	  =  @p_plan_start_yyyymmdd
		                AND A.PLAN_TYPE				      =  @p_plan_type
		                AND A.SEQ					          =  @p_seq
		                AND A.YYYYMMDD             >=  @p_plan_start_yyyymmdd
		                AND A.YYYYMMDD             <=   @v_to_yyyymmdd --말일포함(KSK, 20240814)
                    AND A.MEASURE               = 'PRODUCTION'
                    AND A.OPERATION_GROUP       = 'A'
                GROUP BY A.DIVISION_ID								
			            , A.OPERATION_GROUP						
			            , A.CELL_ITEM_ID							
			            , A.ITEM_ID										
			            , A.INCOTERMS 										
			            , A.FROM_SITE 										
			            , M.COLUMN_NAME 
			            , A.YYYYMMDD
			            , M.SORT_ORDER_NO									
			            , M.COLUMN_LABEL_NAME							
			            , A.BOD_ID						
                  , A.ATTRIBUTE1										
			            , A.ATTRIBUTE9										
			            , A.ATTRIBUTE10		
                ;


                UPDATE X
                   SET X.QTY = ISNULL(Y.QTY,0)
                FROM #PSI_GLOBAL_SMALL_PACK X WITH (NOLOCK)
                INNER JOIN #CELL_PKG_PLAN_IN Y WITH (NOLOCK)
                        ON X.MEASURE      = Y.MEASURE 
                       AND X.CELL_ITEM_ID = Y.CELL_ITEM_ID
                       --AND X.ITEM_ID      = Y.ITEM_ID
                       AND X.FROM_SITE    = Y.FROM_SITE
                       AND X.YYYYMMDD     = Y.YYYYMMDD
                       AND X.MEASURE      ='CELL_PKG_PLAN_IN'
                WHERE X.MEASURE           ='CELL_PKG_PLAN_IN'


               
           
           /*
            INSERT INTO #PSI_GLOBAL_SMALL_PACK
            SELECT  DISTINCT            
                    DIVISION_ID								
			            , OPERATION_GROUP						
			            , CELL_ITEM_ID							
			            , ITEM_ID										
			            --, TO_SITE
               --   , PROJECT_CODE
                  , (CASE WHEN MEASURE IN ('CELL_PKG_PLAN_IN','CELL_PKG_PLAN_OUT','CELL_FORMATION','CELL_BOH','CELL_EOH') THEN '-' ELSE TO_SITE END )
                  , (CASE WHEN MEASURE IN ('CELL_PKG_PLAN_IN','CELL_PKG_PLAN_OUT','CELL_FORMATION','CELL_BOH','CELL_EOH') THEN '' ELSE PROJECT_CODE END )
			            , TO_BOH_QTY										
			            , FROM_BOH_QTY									
			            , INCOTERMS 										
			            , FROM_SITE 										
			            , TRANSPORT_MODE_LINE			
                  , TRANSPORT_MODE
                  , PROD_LINE
			            , MEASURE												
			            , YYYYMMDD	
                  , 0    AS QTY
			            , SORT_ORDER_NO									
			            , COLUMN_LABEL_NAME							
			            , BOD_ID						
                  , ATTRIBUTE1										
			            , ATTRIBUTE9										
			            , ATTRIBUTE10			
                  , NULL AS WEEK_COLUMN
                     FROM                 
                         (                
                              
                            SELECT  DISTINCT  X.DIVISION_ID								
			                                      , X.OPERATION_GROUP						
			                                      , X.CELL_ITEM_ID							
			                                      , X.ITEM_ID										
			                                      , X.TO_SITE
                                            , '' AS PROJECT_CODE
			                                      , X.TO_BOH_QTY										
			                                      , X.FROM_BOH_QTY									
			                                      , '-' AS INCOTERMS 										
			                                      , X.FROM_SITE 										
			                                      , '-' AS TRANSPORT_MODE_LINE			
                                            , '-' AS TRANSPORT_MODE
                                            , '-' AS PROD_LINE
			                                      , M.COLUMN_NAME AS MEASURE
						                                , X.YYYYMMDD	
			                                      , M.SORT_ORDER_NO								
			                                      , M.COLUMN_LABEL_NAME							
			                                      , '-' AS BOD_ID						
                                            , X.ATTRIBUTE1										
			                                      , X.ATTRIBUTE9										
			                                      , ATTRIBUTE10	
                                FROM #PSI_GLOBAL_SMALL_PACK X WITH(NOLOCK)     
                                LEFT OUTER JOIN #MEASURE M WITH (NOLOCK) 
                                ON DIV ='A' AND GUBUN = 'FROM'
                              WHERE 1=1          
                                AND X.MEASURE     = 'CELL_PKG_PLAN_IN'   
                                AND M.COLUMN_NAME IN ('CELL_PKG_PLAN_IN','CELL_PKG_PLAN_OUT','CELL_FORMATION','CELL_BOH','CELL_EOH')
                         ) SUB                
                         WHERE 1=1                
                           AND NOT EXISTS (                
                                            SELECT 'X'                
                                              FROM #PSI_GLOBAL_SMALL_PACK Z WITH(NOLOCK)                
                                             WHERE 1=1                
                                               AND Z.DIVISION_ID          = SUB.DIVISION_ID                
                                               AND Z.OPERATION_GROUP      = SUB.OPERATION_GROUP                
                                               AND Z.CELL_ITEM_ID         = SUB.CELL_ITEM_ID                
                                               AND Z.ITEM_ID              = SUB.ITEM_ID                
                                               --AND Z.TO_SITE              = SUB.TO_SITE          
                                               AND Z.PROJECT_CODE         = SUB.PROJECT_CODE                                                               
                                               AND Z.TO_BOH_QTY           = SUB.TO_BOH_QTY          
                                               AND Z.FROM_BOH_QTY         = SUB.FROM_BOH_QTY                
                                               AND Z.INCOTERMS            = SUB.INCOTERMS                
                                               AND Z.FROM_SITE            = SUB.FROM_SITE                
                                               AND Z.TRANSPORT_MODE_LINE  = SUB.TRANSPORT_MODE_LINE          
                                               --AND Z.TRANSPORT_MODE       = SUB.TRANSPORT_MODE          
                                               --AND Z.PROD_LINE            = SUB.PROD_LINE
                                               AND Z.MEASURE              = SUB.MEASURE 
                                               AND Z.YYYYMMDD             = SUB.YYYYMMDD          
                                               AND Z.BOD_ID               = SUB.BOD_ID      
                                               AND Z.ATTRIBUTE1						=	SUB.ATTRIBUTE1					
			                                         AND Z.ATTRIBUTE9						=	SUB.ATTRIBUTE9					
			                                         AND Z.ATTRIBUTE10	        = SUB.ATTRIBUTE10	
                                          )      

                      AND SUB.MEASURE   <> 'CELL_PKG_PLAN_IN'
                    --AND SUB.MEASURE   NOT IN ('CELL_SHIP_PLAN','CELL_SHIP_PLAN_SSP')
                    */
           -------------------------------------------------------------------------------------------------------------         
            -- CELL_FORMATION(SCP_XLS_BOH) FROM_BOH_QTY
            -------------------------------------------------------------------------------------------------------------         
               IF OBJECT_ID('tempdb..#SCP_XLS_BOH') IS NOT NULL	
	                DROP TABLE #SCP_XLS_BOH

                   SELECT X.CELL_ITEM_ID
                          --,X.SCM_SITE_ID
                          ,CONVERT(VARCHAR,X.AFTER_DTTM,112) AS YYYYMMDD
                          ,SUM(X.AFTER_QTY) AS QTY
                          ,(CASE WHEN CONVERT(VARCHAR,X.AFTER_DTTM,112) < @p_plan_start_yyyymmdd THEN 'CELL_BOH' ELSE 'CELL_FORMATION' END) AS MEASURE
                    INTO #SCP_XLS_BOH
                    FROM 
                    (
                    SELECT --SUB.*,
                            CELL_ITEM_ID,
                            SCM_SITE_ID,
                           ( CASE WHEN (OSP_YN='N' AND LOC='***' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%') THEN QTY * FORMATION_TOTAL_YIELD ELSE QTY END) AS AFTER_QTY,
                           ( CASE WHEN (OSP_YN='N' AND LOC='***' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='Y' ) --활성화 LT+ TOTAL TCO LT
                                  THEN DATEADD(D,TOTAL_LT_FORMATION+CELL_TO_TCO_TOTAL_BOD_LT,RECEIVING_DTTM) 
                                  WHEN (OSP_YN='N' AND LOC='***' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='N' ) --활성화 LT
                                  THEN DATEADD(D,TOTAL_LT_FORMATION,RECEIVING_DTTM) 
                                  WHEN (OSP_YN='N' AND LOC='001' AND  TCO_CELL_YN='N' AND DESCR LIKE 'FOR%' AND TCO_EXIST_YN ='Y' ) --TOTAL TCO LT
                                  THEN DATEADD(D,CELL_TO_TCO_TOTAL_BOD_LT,RECEIVING_DTTM)  
                                  WHEN (OSP_YN='N' AND LOC='001' AND  TCO_CELL_YN='N' AND DESCR LIKE 'FOR%' AND TCO_EXIST_YN ='N' ) --
                                  THEN RECEIVING_DTTM 
                                  WHEN (OSP_YN='N' AND LOC='001' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='Y' ) --TOTAL TCO LT
                                  THEN DATEADD(D,CELL_TO_TCO_TOTAL_BOD_LT,RECEIVING_DTTM) 
                                  WHEN (OSP_YN='N' AND LOC='001' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='N' ) --
                                  THEN RECEIVING_DTTM 
                                  WHEN (OSP_YN='N' AND LOC='002' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='Y' ) --TOTAL TCO LT
                                  THEN DATEADD(D,CELL_TO_TCO_TOTAL_BOD_LT,RECEIVING_DTTM) 
                                  WHEN (OSP_YN='N' AND LOC='002' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='N' ) --
                                  THEN RECEIVING_DTTM 
                                  WHEN (OSP_YN='N' AND LOC='003' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='Y' ) --
                                  THEN RECEIVING_DTTM
                                  WHEN (OSP_YN='N' AND LOC='003' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='N' ) --
                                  THEN RECEIVING_DTTM
                                  WHEN (OSP_YN='Y' AND LOC='***' AND  TCO_CELL_YN='N' AND DESCR LIKE 'INT%' AND TCO_EXIST_YN ='Y' ) --TCO_TO_CELL_BOD_LT
                                  THEN DATEADD(D,TCO_TO_CELL_BOD_LT,RECEIVING_DTTM) 
                                  WHEN (OSP_YN='Y' AND LOC='***' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='Y' ) --TCO_TO_CELL_BOD_LT
                                  THEN DATEADD(D,TCO_TO_CELL_BOD_LT,RECEIVING_DTTM) 
                                  WHEN (OSP_YN='Y' AND LOC='***' AND  TCO_CELL_YN='Y' AND DESCR LIKE 'WH%' ) --TCO_TO_CELL_BOD_LT
                                  THEN DATEADD(D,TCO_TO_CELL_BOD_LT,RECEIVING_DTTM) 
                                  WHEN (OSP_YN='N' AND LOC='002' AND  TCO_CELL_YN='Y' AND DESCR LIKE 'INT%' ) --
                                  THEN RECEIVING_DTTM 
                                  WHEN (OSP_YN='N' AND LOC='002' AND  TCO_CELL_YN='Y' AND DESCR LIKE 'WH%' ) --
                                  THEN RECEIVING_DTTM 
                                  WHEN (OSP_YN='N' AND LOC='003' AND  TCO_CELL_YN='Y' AND DESCR LIKE 'WH%' ) --
                                  THEN RECEIVING_DTTM 
                             ELSE RECEIVING_DTTM
                             END 
                           ) AS AFTER_DTTM
                      FROM SCP_XLS_BOH_SMALL_CELL AS SUB
                      WHERE DIVISION_ID           = @p_division_id
                        AND PLAN_START_YYYYMMDD   = @p_plan_start_yyyymmdd
                        AND PLAN_TYPE             = @p_plan_type
                        AND SEQ                   = @p_seq
                        AND DESCR                 <> 'INT' -- 해상재고 제외
                    ) X
                    GROUP BY X.CELL_ITEM_ID
                           -- ,X.SCM_SITE_ID
                            ,CONVERT(VARCHAR,X.AFTER_DTTM,112)

                /*
                UPDATE X
                  SET X.FROM_BOH_QTY = ISNULL(Y.QTY,0)
                 FROM #PSI_GLOBAL_SMALL_PACK X WITH (NOLOCK)
                 INNER JOIN #SCP_XLS_BOH Y WITH (NOLOCK)   
                  ON 0 = 0
                  --AND X.DIVISION_ID          = Y.DIVISION_ID      
                  --AND X.PLAN_START_YYYYMMDD  = Y.PLAN_START_YYYYMMDD      
                  --AND X.PLAN_TYPE            = Y.PLAN_TYPE      
                  --AND X.SEQ                  = Y.SEQ      
                  AND X.CELL_ITEM_ID         = Y.CELL_ITEM_ID    
                  AND X.MEASURE              = Y.MEASURE      
                  AND Y.MEASURE              =  'CELL_EOH'
                  */

                  UPDATE X
                  SET X.QTY = ISNULL(Y.QTY,0)
                 FROM #PSI_GLOBAL_SMALL_PACK X WITH (NOLOCK)
                 INNER JOIN #SCP_XLS_BOH Y WITH (NOLOCK)   
                  ON 0 = 0
                  --AND X.DIVISION_ID          = Y.DIVISION_ID      
                  --AND X.PLAN_START_YYYYMMDD  = Y.PLAN_START_YYYYMMDD      
                  --AND X.PLAN_TYPE            = Y.PLAN_TYPE      
                  --AND X.SEQ                  = Y.SEQ      
                  AND X.YYYYMMDD             = Y.YYYYMMDD
                  AND X.CELL_ITEM_ID         = Y.CELL_ITEM_ID    
                  AND X.MEASURE              = Y.MEASURE      
                  AND Y.MEASURE              =  'CELL_FORMATION'
                  

                  -- ETA_PAST QTY의 엔진시작일자 보다 큰 일자의 SUM
                 UPDATE X
                  SET X.FROM_BOH_QTY = Z.QTY
                 FROM #PSI_GLOBAL_SMALL_PACK X WITH (NOLOCK)
                 INNER JOIN 
                            (
                              SELECT CELL_ITEM_ID, SUM(ISNULL(Y.QTY,0)) AS QTY
                              FROM #SCP_XLS_BOH Y WITH (NOLOCK)   
                              WHERE 0 = 0
                                AND Y.MEASURE = 'CELL_BOH'  -- CELL_EOH
                              GROUP BY CELL_ITEM_ID
                            ) Z
                  ON 0 = 0
                  AND X.CELL_ITEM_ID         = Z.CELL_ITEM_ID  
                  AND X.MEASURE              =  'CELL_BOH'  -- CELL_EOH

            -------------------------------------------------------------------------------------------------------------         
            --  TRANSPORT_MODE_CODE와 LIEN_ID 반영
            -------------------------------------------------------------------------------------------------------------
              UPDATE X
                SET X.TRANSPORT_MODE = Y.SEGMENT1
               FROM #PSI_GLOBAL_SMALL_PACK X  WITH (NOLOCK)
               INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL Y WITH (NOLOCK) 
                  ON X.TRANSPORT_MODE_LINE = Y.SEGMENT1
              WHERE 0 = 0
                AND Y.LOOKUP_TYPE = 'TRANSPORT_MODE_CODE' 
                AND Y.VALID_YN    = 'Y'  
--                AND X.TRANSPORT_MODE IS NULL

              UPDATE X
                SET X.PROD_LINE = Y.LINE_ID
               FROM #PSI_GLOBAL_SMALL_PACK X  WITH (NOLOCK)
               INNER JOIN (SELECT DISTINCT A.DIVISION_ID,A.LINE_ID
		                         FROM dbo.SCM_MST_LINE_V A  WITH (NOLOCK)
                            WHERE A.DIVISION_ID = @p_division_id
                          ) Y 
                  ON X.TRANSPORT_MODE_LINE = Y.LINE_ID
               WHERE 0 = 0
                 AND Y.DIVISION_ID         = @p_division_id
                 AND X.TRANSPORT_MODE_LINE = Y.LINE_ID


            -------------------------------------------------------------------------------------------------------------         
            -- PROD, PROD_LOAD 0 채움
            -------------------------------------------------------------------------------------------------------------

            -------------------------------------------------------------------------------------------------------------         
            -- TACT TIME TEMP 생성  -- ESS 외주 Line별 생산 Target 관련 OSP_YN로직 수정            
            -------------------------------------------------------------------------------------------------------------         
            
             IF OBJECT_ID('tempdb..#tmp_SCP_MST_TACT_TIME') IS NOT NULL	
	              DROP TABLE #tmp_SCP_MST_TACT_TIME
             
             SELECT * 
             INTO #tmp_SCP_MST_TACT_TIME
             FROM 
             (
                SELECT DIVISION_ID,PLANT_SITE_ID,ITEM_ID,OPERATION_ID,LINE_ID,YIELD 
                FROM SCP_MST_TACT_TIME WITH(NOLOCK)
                WHERE DIVISION_ID =@p_division_id
                UNION ALL
                SELECT DIVISION_ID,PLANT_SITE_ID,ITEM_ID,OPERATION_ID,LINE_ID,YIELD 
                FROM SCP_MST_TACT_TIME_OSP WITH(NOLOCK)
                WHERE DIVISION_ID =@p_division_id
              ) X


             IF OBJECT_ID('tempdb..#MST_TACT_TIME') IS NOT NULL	
	              DROP TABLE #MST_TACT_TIME
                
                SELECT *
                INTO #MST_TACT_TIME
                FROM 
                  (
                  SELECT DISTINCT DIVISION_ID,PLANT_SITE_ID,LINE_ID,ITEM_ID, 'PACK_PROD' AS MEASURE
                  FROM #tmp_SCP_MST_TACT_TIME A  WITH (NOLOCK)
						-- [PJ20257329] 2025.08.01 Cell 완성 공정 하드코딩 변경 Start 
						  INNER HASH JOIN #SCP_CELL_FINAL_OPERATION CO
									   ON CO.OPERATION_ID = A.OPERATION_ID 
						-- [PJ20257329] 2025.08.01 Cell 완성 공정 하드코딩 변경 End 
                  WHERE 0 = 0
                  AND DIVISION_ID = '40'
                  -- [PJ20257329] 2025.08.01  변경전 AND OPERATION_ID         IN ( 'A3000','A9000')
                  AND ITEM_ID IN (SELECT DISTINCT ITEM_ID 
                                    FROM #PSI_GLOBAL_SMALL_PACK WITH (NOLOCK) 
                                   WHERE  0 = 0
                                     AND DIVISION_ID  = '40'
                                     AND MEASURE      = 'PACK_PROD'
                                  )
--                  UNION 
--                  SELECT DISTINCT DIVISION_ID,PLANT_SITE_ID,'-' AS LINE_ID,ITEM_ID, 'PACK_PROD' AS MEASURE   -- DAILY_CAPA_QTY
--                  --SELECT * 
--                  FROM SCP_MST_OUTSOURCING_CAPA WITH (NOLOCK)
--                  WHERE 0 = 0
--                  AND DIVISION_ID = '40'
--                  AND ITEM_ID IN (SELECT DISTINCT ITEM_ID 
--                                    FROM #PSI_GLOBAL_SMALL_PACK WITH (NOLOCK) 
--                                   WHERE  0 = 0
--                                     AND DIVISION_ID  = '40'
----                                     AND MEASURE      = 'PACK_PROD'
--                                  )
                  ) AS X



            -------------------------------------------------------------------------------------------------------------------------         
            -- PROD_LINE 추가 PACK_PROD,PACK_PROD_LOAD)
            -------------------------------------------------------------------------------------------------------------------------
            INSERT INTO #PSI_GLOBAL_SMALL_PACK
            SELECT  DISTINCT            
                    DIVISION_ID								
			            , OPERATION_GROUP						
			            , CELL_ITEM_ID							
			            , ITEM_ID										
			            , TO_SITE
                  , PROJECT_CODE
			            , TO_BOH_QTY										
			            , FROM_BOH_QTY									
			            , INCOTERMS 										
			            , FROM_SITE 										
			            , TRANSPORT_MODE_LINE			
                  , TRANSPORT_MODE
                  , PROD_LINE
			            , MEASURE												
			            , YYYYMMDD	
                  , 0    AS QTY
			            , SORT_ORDER_NO									
			            , COLUMN_LABEL_NAME							
			            , BOD_ID						
                  , ATTRIBUTE1										
			            , ATTRIBUTE9										
			            , ATTRIBUTE10			
                  , NULL AS WEEK_COLUMN
                     FROM                 
                         (             
                              
                            SELECT  DISTINCT  X.DIVISION_ID								
			                                      , X.OPERATION_GROUP						
			                                      , X.CELL_ITEM_ID							
			                                      , X.ITEM_ID										
			                                      , '-' AS TO_SITE
                                            , '' AS PROJECT_CODE
			                                      , '0' AS TO_BOH_QTY										
			                                      , '0' AS FROM_BOH_QTY									
			                                      , '-' AS INCOTERMS 										
			                                      , FROM_SITE 										
			                                      , '-' AS TRANSPORT_MODE_LINE			
                                            , '-' AS TRANSPORT_MODE
                                            , LINE_ID AS PROD_LINE
			                                      , Y.MEASURE
						                                , X.YYYYMMDD	
			                                      , X.SORT_ORDER_NO								
			                                      , X.COLUMN_LABEL_NAME							
			                                      , '-' AS BOD_ID						
                                            , X.ATTRIBUTE1										
			                                      , X.ATTRIBUTE9										
			                                      , X.ATTRIBUTE10	
                                FROM #PSI_GLOBAL_SMALL_PACK X WITH(NOLOCK)     
                                LEFT OUTER JOIN #MST_TACT_TIME Y WITH (NOLOCK) 
                                ON 0 = 0
                                AND X.MEASURE       IN ('PACK_PROD')
                              WHERE 1=1          
                                AND X.MEASURE       IN ('PACK_PROD')     
                                AND X.DIVISION_ID    = Y.DIVISION_ID
                                AND X.FROM_SITE      = Y.PLANT_SITE_ID
            --                  AND X.PROD_LINE     <> LINE_ID
                                AND X.ITEM_ID        = Y.ITEM_ID
                         ) SUB                
                         WHERE 1=1                
                           AND NOT EXISTS (                
                                            SELECT 'X'                
                                              FROM #PSI_GLOBAL_SMALL_PACK Z WITH(NOLOCK)                
                                             WHERE 1=1                
                                               AND Z.DIVISION_ID          = SUB.DIVISION_ID                
                                               AND Z.OPERATION_GROUP      = SUB.OPERATION_GROUP                
                                               AND Z.CELL_ITEM_ID         = SUB.CELL_ITEM_ID                
                                               AND Z.ITEM_ID              = SUB.ITEM_ID              
--                                               AND Z.PROJECT_CODE         = SUB.PROJECT_CODE
--                                               AND Z.TO_SITE              = SUB.TO_SITE                
--                                               AND Z.TO_BOH_QTY           = SUB.TO_BOH_QTY          
--                                               AND Z.FROM_BOH_QTY         = SUB.FROM_BOH_QTY                
                                               --AND Z.INCOTERMS            = SUB.INCOTERMS                
                                               AND Z.FROM_SITE            = SUB.FROM_SITE                
                                               --AND Z.TRANSPORT_MODE_LINE  = SUB.TRANSPORT_MODE_LINE          
                                               --AND Z.TRANSPORT_MODE       = SUB.TRANSPORT_MODE          
                                               AND Z.PROD_LINE            = SUB.PROD_LINE
                                               AND Z.MEASURE              = SUB.MEASURE 
                                               AND Z.YYYYMMDD             = SUB.YYYYMMDD          
--                                               AND Z.BOD_ID               = SUB.BOD_ID      
                                               AND Z.ATTRIBUTE1						=	SUB.ATTRIBUTE1					
			                                         AND Z.ATTRIBUTE9						=	SUB.ATTRIBUTE9					
			                                         AND Z.ATTRIBUTE10	        = SUB.ATTRIBUTE10	
                                          )      

--                    AND SUB.MEASURE   <> 'SEMI_SHIP_PLAN'
              

            -------------------------------------------------------------------------------------------------------------         
            -- INTRANSIT 반영
            -------------------------------------------------------------------------------------------------------------
                  SELECT 
                        DIVISION_ID 
                        ,PLAN_START_YYYYMMDD
                        ,PLAN_TYPE
                        ,SEQ
                        ,OPERATION_GROUP
                        ,ITEM_ID
                        ,TO_SITE
                        ,FROM_SITE
                        --,MEASURE
                        ,YYYYMMDD
                        ,SUM(QTY) AS QTY
                        ,ATTRIBUTE1
                        INTO #INTRANSIT
                  FROM (
                          SELECT                          
                                 @P_DIVISION_ID            AS DIVISION_ID
                                ,@P_PLAN_START_YYYYMMDD   AS PLAN_START_YYYYMMDD
                                ,@P_PLAN_TYPE             AS PLAN_TYPE 
                                ,@P_SEQ                   AS SEQ 
                                ,C.OPERATION_GROUP                        
                                ,A.ITEM_ID                        
                                ,(SUBSTRING(SITE_ID, 1, DBO.FN_CHARINDEX_REV(SITE_ID, '~', 0)-1))  AS TO_SITE   
                                ,(SUBSTRING(LOT_ID, DBO.FN_CHARINDEX_REV(LOT_ID, '::', 0)+2,100)) AS FROM_SITE   
                                --,'INTRANSIT_ALL' AS MEASURE                 
                                ,CONVERT(NVARCHAR(8), A.RECEIVING_DTTM,112) AS YYYYMMDD                 
                                ,(A.QTY)         AS QTY        
                                ,'TH_ENG_STOCK_PLAN_SN'  AS  ATTRIBUTE1 
                            FROM DBO.TH_ENG_STOCK_PLAN_SN A WITH (NOLOCK)             
                            INNER JOIN DBO.SCP_MST_FINAL_ITEM_V C  WITH (NOLOCK)           
                               ON 0 = 0
                               AND A.ITEM_ID      = C.ITEM_ID                                               
                            WHERE 1 = 1                        
                              AND A.MASTER_ID        = @p_master_id                    
                              AND A.PLAN_ID          = @p_engine_plan_id    
                              AND A.DESCR            = 'INT'       
                              --AND CONVERT(NVARCHAR(8), A.RECEIVING_DTTM,112) = @p_plan_start_yyyymmdd
                          ) X
                    GROUP BY DIVISION_ID 
                    ,PLAN_START_YYYYMMDD
                    ,PLAN_TYPE
                    ,SEQ
                    ,OPERATION_GROUP
                    ,ITEM_ID
                    ,TO_SITE
                    ,FROM_SITE
                    --,MEASURE
                    ,YYYYMMDD
                    ,ATTRIBUTE1
                    ;


                 UPDATE X
                    SET X.QTY = ISNULL(Y.QTY,0)
                   FROM #PSI_GLOBAL_SMALL_PACK X  WITH (NOLOCK)
                   INNER JOIN #INTRANSIT Y  WITH (NOLOCK)
                      ON X.ITEM_ID    = Y.ITEM_ID                        
                     AND X.TO_SITE    = Y.TO_SITE   
                     AND X.FROM_SITE  = Y.FROM_SITE
                     AND X.YYYYMMDD   = Y.YYYYMMDD 
                     AND X.MEASURE    = 'PACK_INTRANSIT_ETA'

                 UPDATE X
                    SET X.QTY = ISNULL(Y.QTY,0)
                   FROM #PSI_GLOBAL_SMALL_PACK X  WITH (NOLOCK)
                   INNER JOIN #INTRANSIT Y  WITH (NOLOCK)
                      ON X.ITEM_ID    = Y.ITEM_ID                        
                     AND X.TO_SITE    = Y.TO_SITE   
                     AND X.FROM_SITE  = Y.FROM_SITE
                     AND X.YYYYMMDD   = Y.YYYYMMDD 
                     AND X.MEASURE    = 'CELL_INTRANSIT_ETA'               

                 
                     

            -------------------------------------------------------------------------------------------------------------         
            -- BOH 반영(SCP_XLS_BOH)
            -------------------------------------------------------------------------------------------------------------         
               IF OBJECT_ID('tempdb..#BOH') IS NOT NULL	
	                DROP TABLE #BOH

                  SELECT DIVISION_ID
                         ,PLAN_START_YYYYMMDD
                         ,PLAN_TYPE
                         ,SEQ
                         ,SCM_SITE_ID
--                         ,INCOTERMS
                         ,(CASE WHEN INCOTERMS  = '' THEN '-' ELSE ISNULL(INCOTERMS,'-')  END) AS INCOTERMS
                         ,ITEM_ID
                         ,SUM(QTY)        AS QTY
                         ,ORIGIN_ITEM_ID
                         ,SUM(ORIGIN_QTY) AS ORIGIN_QTY
                   INTO #BOH
                   FROM SCP_XLS_BOH  WITH (NOLOCK)
                  WHERE DIVISION_ID           = @p_division_id
                    AND PLAN_START_YYYYMMDD   = @p_plan_start_yyyymmdd
                    AND PLAN_TYPE             = @p_plan_type
                    AND SEQ                   = @p_seq
                  GROUP BY DIVISION_ID
                         ,PLAN_START_YYYYMMDD
                         ,PLAN_TYPE
                         ,SEQ
                         ,SCM_SITE_ID
--                         ,INCOTERMS
                         ,(CASE WHEN INCOTERMS  = '' THEN '-' ELSE ISNULL(INCOTERMS,'-')  END) 
                         ,ITEM_ID
--                         ,QTY
                         ,ORIGIN_ITEM_ID
--                         ,ORIGIN_QTY


                UPDATE X
                  SET X.QTY = ISNULL(Y.QTY,0)
                 FROM #PSI_GLOBAL_SMALL_PACK X WITH (NOLOCK)
                 INNER JOIN #BOH Y WITH (NOLOCK)   
                  ON 0 = 0
                  --AND X.DIVISION_ID          = Y.DIVISION_ID      
                  --AND X.PLAN_START_YYYYMMDD  = Y.PLAN_START_YYYYMMDD      
                  --AND X.PLAN_TYPE            = Y.PLAN_TYPE      
                  --AND X.SEQ                  = Y.SEQ      
                  AND X.FROM_SITE            = Y.SCM_SITE_ID      
                  AND X.ITEM_ID              = Y.ITEM_ID    
                  AND X.INCOTERMS            = Y.INCOTERMS
                  AND X.YYYYMMDD             = @p_plan_start_yyyymmdd
                  AND X.MEASURE              = 'PACK_BOH'


                MERGE INTO #PSI_GLOBAL_SMALL_PACK AS X  
                  USING (SELECT DISTINCT
                                A.DIVISION_ID								
			                          , 'A' AS OPERATION_GROUP						
			                          , A.CELL_ITEM_ID							
			                          , A.CELL_ITEM_ID AS ITEM_ID										
			                          , B.SCM_SITE_ID  AS TO_SITE
                                , '' AS PROJECT_CODE
			                          , A.TO_BOH_QTY										
			                          , A.FROM_BOH_QTY									
			                          , '-' AS INCOTERMS 										
			                          , '-' AS FROM_SITE 										
			                          , '-' AS TRANSPORT_MODE_LINE			
                                , '-' AS TRANSPORT_MODE
                                , '-' AS PROD_LINE
			                          , M.COLUMN_NAME AS MEASURE
						                    , A.YYYYMMDD	
			                          , M.SORT_ORDER_NO								
			                          , M.COLUMN_LABEL_NAME							
			                          , '-' AS BOD_ID						
                                , A.ATTRIBUTE1										
			                          , A.ATTRIBUTE9										
			                          , A.ATTRIBUTE10	
                          FROM #PSI_GLOBAL_SMALL_PACK A WITH(NOLOCK)   
                          CROSS APPLY #MEASURE M WITH (NOLOCK) 
                          INNER JOIN #BOH B  WITH (NOLOCK)
                            ON A.CELL_ITEM_ID = B.ITEM_ID
                            AND B.SCM_SITE_ID LIKE '%-P'
                            WHERE 1=1          
                            AND M.DIV       ='A' 
                            AND M.GUBUN       = 'TO'
                            AND A.YYYYMMDD =@p_plan_start_yyyymmdd -- '20191118'
                            AND A.TO_SITE <> '-'
                        ) AS Y
                  ON 0 = 0
                  AND X.OPERATION_GROUP = Y.OPERATION_GROUP
                  AND X.CELL_ITEM_ID    = Y.CELL_ITEM_ID
                  AND X.ITEM_ID         = Y.ITEM_ID
                  AND X.TO_SITE         = Y.TO_SITE
                  AND X.PROJECT_CODE    = Y.PROJECT_CODE
                  AND X.INCOTERMS       = Y.INCOTERMS
                  AND X.FROM_SITE       = Y.FROM_SITE
                  AND X.BOD_ID          = Y.BOD_ID
                  AND X.MEASURE         = Y.MEASURE

                  WHEN NOT MATCHED  THEN 
                    INSERT (
                              DIVISION_ID								
			                      , OPERATION_GROUP						
			                      , CELL_ITEM_ID							
			                      , ITEM_ID										
			                      , TO_SITE
                            , PROJECT_CODE
			                      , TO_BOH_QTY										
			                      , FROM_BOH_QTY									
			                      , INCOTERMS 										
			                      , FROM_SITE 										
			                      , TRANSPORT_MODE_LINE			
                            , TRANSPORT_MODE
                            , PROD_LINE
			                      , MEASURE												
			                      , YYYYMMDD	
                            , QTY
			                      , SORT_ORDER_NO									
			                      , COLUMN_LABEL_NAME							
			                      , BOD_ID						
                            , ATTRIBUTE1										
			                      , ATTRIBUTE9										
			                      , ATTRIBUTE10			
                            , WEEK_COLUMN
                          )
                    VALUES (
                              Y.DIVISION_ID								
			                      , Y.OPERATION_GROUP						
			                      , Y.CELL_ITEM_ID							
			                      , Y.ITEM_ID										
			                      , Y.TO_SITE
                            , Y.PROJECT_CODE
			                      , Y.TO_BOH_QTY										
			                      , Y.FROM_BOH_QTY									
			                      , Y.INCOTERMS 										
			                      , Y.FROM_SITE 										
			                      , Y.TRANSPORT_MODE_LINE			
                            , Y.TRANSPORT_MODE
                            , Y.PROD_LINE
			                      , Y.MEASURE												
			                      , Y.YYYYMMDD	
                            , 0 
			                      , Y.SORT_ORDER_NO									
			                      , Y.COLUMN_LABEL_NAME							
			                      , Y.BOD_ID						
                            , Y.ATTRIBUTE1										
			                      , Y.ATTRIBUTE9										
			                      , Y.ATTRIBUTE10			
                            , 'A'
                          )

                          ;          


                UPDATE X
                 SET X.QTY = ISNULL(Y.QTY,0)      -- 임시로 100 
                 FROM #PSI_GLOBAL_SMALL_PACK X WITH (NOLOCK)
                 INNER JOIN #BOH Y WITH (NOLOCK)   
                  ON 0 = 0
                  AND X.TO_SITE               = Y.SCM_SITE_ID      
                  AND X.ITEM_ID               = Y.ITEM_ID    
                  AND X.YYYYMMDD              = @p_plan_start_yyyymmdd
                  AND X.MEASURE               = 'TO_SITE_BOH'
                  AND X.INCOTERMS             =  Y.INCOTERMS
                  

                UPDATE X
                  SET X.TO_BOH_QTY = ISNULL(Y.QTY,0)
                 FROM #PSI_GLOBAL_SMALL_PACK X WITH (NOLOCK)
                 INNER JOIN #BOH Y WITH (NOLOCK)   
                  ON 0 = 0
                  AND X.TO_SITE = Y.SCM_SITE_ID      
                  AND X.ITEM_ID = Y.ITEM_ID    
                  AND X.MEASURE = 'CELL_BALANCE'


-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
		

				  IF OBJECT_ID('tempdb..##PSI_GLOBAL_SMALL_PACK') IS NOT NULL      
	              DROP TABLE ##PSI_GLOBAL_SMALL_PACK;   
				                  
		            SELECT *
		            INTO ##PSI_GLOBAL_SMALL_PACK
		            FROM #PSI_GLOBAL_SMALL_PACK
		            ;

           	-------------------------------------------------------------------------------------------------------------         
            --  1년단위 표준저장프로시저 호출부
            -------------------------------------------------------------------------------------------------------------			

			DECLARE @rows INT;  
			DECLARE @v_create_from_yyyymmdd  NVARCHAR(0008);
			DECLARE @v_create_to_yyyymmdd    NVARCHAR(0008);
							
			SET @v_create_from_yyyymmdd = @p_plan_start_yyyymmdd;
			SET @v_create_to_yyyymmdd   = CONVERT(VARCHAR(8), DATEADD(day, 363, @v_create_from_yyyymmdd), 112);

			PRINT 'BEFORE PR_SCP_XLS_PSI_GLOBAL_SMALL_PACK_S'			
			EXEC @rows = PR_SCP_XLS_PSI_GLOBAL_SMALL_PACK_S_org       @p_plan_cycle             = @p_plan_cycle          
                                                                , @p_plan_start_yyyymmdd    = @p_plan_start_yyyymmdd          
                                                                , @p_plan_id                = @p_plan_id          
                                                                , @p_modeling_id            = @p_modeling_id          
                                                                , @p_seq                    = @p_seq          
                                                                , @p_plan_type              = @p_plan_type          
                                                                , @p_master_id              = @p_master_id          
                                                                , @p_division_id            = @p_division_id          
                                                                , @p_engine_plan_id         = @p_engine_plan_id        																
																, @p_create_from_yyyymmdd   = @v_create_from_yyyymmdd
																, @p_create_to_yyyymmdd     = @v_create_to_yyyymmdd
                                                                , @p_user_id                = @v_batch_user
																, @p_is_debug					=@p_is_debug
																;
				
            IF (@rows < 0)  GOTO _RETURN_ERR_CODE
			
			IF @v_bp_flag = 'Y'
			BEGIN
				-- 2 YEAR PIVOT DATS 생성
				SET @v_create_from_yyyymmdd = CONVERT(VARCHAR(8), DATEADD(day, 1, @v_create_to_yyyymmdd), 112);
				SET @v_create_to_yyyymmdd   = CONVERT(VARCHAR(8), DATEADD(day, 363, @v_create_from_yyyymmdd), 112);
			
			
				EXEC @rows = PR_SCP_XLS_PSI_GLOBAL_SMALL_PACK_S_org       @p_plan_cycle             = @p_plan_cycle          
																	, @p_plan_start_yyyymmdd    = @p_plan_start_yyyymmdd          
																	, @p_plan_id                = @p_plan_id          
																	, @p_modeling_id            = @p_modeling_id          
																	, @p_seq                    = @p_seq          
																	, @p_plan_type              = @p_plan_type          
																	, @p_master_id              = @p_master_id          
																	, @p_division_id            = @p_division_id          
																	, @p_engine_plan_id         = @p_engine_plan_id      																	
																	, @p_create_from_yyyymmdd   = @v_create_from_yyyymmdd
																	, @p_create_to_yyyymmdd     = @v_create_to_yyyymmdd
																	, @p_user_id                = @v_batch_user
																	, @p_is_debug					=@p_is_debug
																	;
																	
																	
				IF (@rows < 0)  GOTO _RETURN_ERR_CODE


				/* 20231010 강현준 수정*/
				-- 1년차는 100000 번째의 XLS_KEY1 생성
				UPDATE SCP_XLS_PSI_GLOBAL_SMALL_PACK
				SET XLS_KEY1 = XLS_KEY1 + 100000
				FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK
				WHERE DIVISION_ID = @p_division_id
				AND   PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd		
				AND   PLAN_TYPE = @p_plan_type
				AND   SEQ = @p_seq
				AND   CREATE_FROM_YYYYMMDD = @p_plan_start_yyyymmdd				-- 1년차이므로 @p_plan_start_yyyymmdd로 활용
				;


				-- 2년차는 1년차의 XLS_KEY1와 MAPPING 하여 생성
				UPDATE B
				SET B.XLS_KEY1 = A.XLS_KEY1
				FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK A,
					SCP_XLS_PSI_GLOBAL_SMALL_PACK B
				WHERE A.DIVISION_ID = @p_division_id
				AND   A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
				AND   A.PLAN_TYPE = @p_plan_type
				AND   A.SEQ = @p_seq
				AND   A.CREATE_FROM_YYYYMMDD = @p_plan_start_yyyymmdd			-- 1년차이므로 @p_plan_start_yyyymmdd로 활용
				AND   B.CREATE_FROM_YYYYMMDD = @v_create_from_yyyymmdd			-- 2년차이므로 @v_create_from_yyyymmdd로 활용
				AND   A.DIVISION_ID			= B.DIVISION_ID
				AND   A.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD
				AND   A.PLAN_TYPE			= B.PLAN_TYPE
				AND   A.SEQ					= B.SEQ
				AND   A.OPERATION_GROUP		= B.OPERATION_GROUP      
				AND   A.ITEM_ID				= B.ITEM_ID       
				AND   A.CELL_ITEM_ID		= B.CELL_ITEM_ID       
				AND   A.TO_SITE				= B.TO_SITE      
				AND   A.FROM_SITE			= B.FROM_SITE      
				AND   A.MEASURE				= B.MEASURE
				AND   A.BOD_ID				= B.BOD_ID
				AND   A.INCOTERMS			= B.INCOTERMS
				AND   A.PROJECT_CODE		= B.PROJECT_CODE

				-- 2년차에 신규 생성된것은 200000 대로 처리
				UPDATE SCP_XLS_PSI_GLOBAL_SMALL_PACK
				SET XLS_KEY1 = XLS_KEY1 + 200000
				WHERE DIVISION_ID = @p_division_id
				AND   PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
				AND   PLAN_TYPE = @p_plan_type
				AND   SEQ = @p_seq
				AND   CREATE_FROM_YYYYMMDD = @v_create_from_yyyymmdd			-- 2년차이므로 @v_create_from_yyyymmdd로 활용
				AND   XLS_KEY1 < 100000											-- 위의 UPDATE 로직 이외의 것은 100000 이하로 남아 있음.

			END


			
            -------------------------------------------------------------------------------------------------------------         
            -- 임시 TEMP  테이블 DROP  
            -------------------------------------------------------------------------------------------------------------
              IF OBJECT_ID('tempdb..#LineLoad')   IS NOT NULL
	              DROP TABLE #LineLoad

              IF OBJECT_ID('tempdb..#LineLoad_WEEK')   IS NOT NULL
	              DROP TABLE #LineLoad_WEEK

              IF OBJECT_ID('tempdb..#MEASURE')    IS NOT NULL	
		            DROP TABLE #MEASURE

              IF OBJECT_ID('tempdb..#INTRANSIT')  IS NOT NULL       
		            DROP TABLE #INTRANSIT

              IF OBJECT_ID('tempdb..#SCP_PLN_PLANT_ONHAND')   IS NOT NULL       
		            DROP TABLE #SCP_PLN_PLANT_ONHAND

	            IF OBJECT_ID('tempdb..#BOH')        IS NOT NULL       
		            DROP TABLE #BOH

	            IF OBJECT_ID('tempdb..#PSI_GLOBAL_SMALL_PACK') IS NOT NULL       
		            DROP TABLE #PSI_GLOBAL_SMALL_PACK     

              IF OBJECT_ID('tempdb..#SCP_XLS_PSI_GLOBAL_SMALL_PACK') IS NOT NULL       
		            DROP TABLE #SCP_XLS_PSI_GLOBAL_SMALL_PACK

              IF OBJECT_ID('tempdb..#WEEK_COLUMN') IS NOT NULL       
		            DROP TABLE #WEEK_COLUMN
	            
			IF OBJECT_ID('tempdb..##PSI_GLOBAL_SMALL_PACK') IS NOT NULL      
	              DROP TABLE ##PSI_GLOBAL_SMALL_PACK;   
                
        -----------------------------------------------------------      
        -- 실행 Logic END --      
        -----------------------------------------------------------      
      
        -- TXN LOG      
        SET @v_log_type     = N'TXN';        
        SET @n_log_count    = @@ROWCOUNT;      
        SET @v_log_message  = N'INSERT INTO '+@v_table_id;      
        SET @v_description  = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);      
        SET @d_event_date   = SYSDATETIME();      
       if @p_is_debug = 0
        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
                                  ,@p_log_type      = @v_log_type      
                                  ,@p_log_count     = @n_log_count       
                                  ,@p_log_message   = @v_log_message       
                                  ,@p_description   = @v_description       
                                  ,@p_event_date    = @d_event_date       
                                  ,@p_user_id       = @v_batch_user      
                                  ;            
      
    END      
    END TRY      
      
    BEGIN CATCH      

      SET @v_log_type     = N'ERROR';      
      SET @v_log_message  = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));      
      SET @v_description  = @v_program_name + N'ERROR_LINE : ' + STR(ERROR_LINE());   
      SET @d_event_date   = SYSDATETIME();      
	  if @p_is_debug = 0
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
                                ,@p_log_type      = @v_log_type      
                                ,@p_log_count     = @n_log_count       
                                ,@p_log_message   = @v_log_message       
                                ,@p_description   = @v_description       
                                ,@p_event_date    = @d_event_date       
                                ,@p_user_id       = @v_batch_user      
                                ;      
      return -1      
    END CATCH;      
      
  
-- 임시 운영반영시에 주석처리 할것.    
     SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
                          REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))     
       
    -- 종료 LOG          
    SET @v_log_type     = N'END';          
    SET @v_log_message  = N'########## END of procedure ##########';          
    SET @v_description  = N'['+@p_master_id+']['+@p_engine_plan_id+'][' + @v_exec_time + ']';                
    SET @d_event_date   = SYSDATETIME()  ;      
	if @p_is_debug = 0
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
                              ,@p_log_type      = @v_log_type      
                              ,@p_log_count     = @n_log_count       
                              ,@p_log_message   = @v_log_message       
                              ,@p_description   = @v_description       
                              ,@p_event_date    = @d_event_date       
                              ,@p_user_id       = @v_batch_user      
                              ;      
    return 1        

    _RETURN_ERR_CODE:                  
        BEGIN                  
             RETURN -1                  
        END;
		
  END;        
