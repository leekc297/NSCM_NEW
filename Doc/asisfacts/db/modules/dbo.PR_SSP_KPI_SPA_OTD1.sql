/*
 * Program ID   : PR_SSP_KPI_SPA_OTD1  
 * Description  : KPI 출하 준수율 SPA (OTD1) DW용 데이터 생성 
 * Execute      : EXEC PR_SSP_KPI_SPA_OTD1 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021.09.06   SSP Pjt.       Create.
 *                             계획 : 월요일 01시
 *                             실적 : 월요일 06시-22시 (법인별 시업시간 기준 생성) 
 * 2022.04.01   SSP Pjt.       JV DIVISION_ID 적용	
 */

CREATE PROCEDURE [dbo].[PR_SSP_KPI_SPA_OTD1]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'ssp_batch';  
    SET     @v_batch_user = 'ssp_batch' ; -- @p_user_id
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SSP_KPI_SPA_OTD1';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N'SSP_KPI_SPA_OTD1'; -- ▶ 테이블 필수
    DECLARE @d_event_date   DATETIME;

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SSP_KPI_SPA_OTD1 INSERT LOGIC';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;
    -- 임시 실행시간 확인용
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';


    DECLARE @v_r_start_yyyymmdd  NVARCHAR(8) = '';
    DECLARE @v_r_end_yyyymmdd    NVARCHAR(8) = '';

    DECLARE @v_p_start_yyyymmdd  NVARCHAR(8) = '';
    DECLARE @v_p_end_yyyymmdd    NVARCHAR(8) = '';

	DECLARE @TAB_SSP_KPI_SPA_OTD1 TABLE
    (
	    TID								INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
		[COMPANY_ID]                    [nvarchar](30),
	    [DIVISION_ID]					[nvarchar](30),
	    [PLANT_ID]						[nvarchar](30),
	    [OPERATION_GROUP]				[nvarchar](10),
	    [FROM_SITE]						[nvarchar](30),
	    [TO_SITE]						[nvarchar](30),
	    [ITEM_ID]						[nvarchar](50),
	    [YYYYMMDD]						[nvarchar](50),
		[YYYYMM]                        [nvarchar](6),
		[YYYYWW]                        [nvarchar](6),
	    [PLAN_QTY]						[numeric](20, 10),
	    [RESULT_QTY]					[numeric](20, 10)
    );

	DECLARE @TAB_COMPANY TABLE
    (
	    TID								INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
		[COMPANY_ID]                    [nvarchar](30)
    );

    BEGIN TRY
      BEGIN
        BEGIN TRAN TX_SH

		------------------------------------------------------------------------------------------------------------- 
		-- 0. 구간 
		-- 계획(금주 월요일 ~ 일요일)  VERSION_TYPE : PLAN
		-- 실적(전주 월요일 ~ 일요일)  VERSION_TYPE : RESULT
		------------------------------------------------------------------------------------------------------------- 
		SET  @v_p_start_yyyymmdd = CONVERT(VARCHAR(8),DATEADD(WK,DATEDIFF(D,0,getdate())/7,0), 112) ; -- 금주월요일   
		SET  @v_p_end_yyyymmdd   = CONVERT(VARCHAR(8),DATEADD(WK,DATEDIFF(D,0,getdate())/7,6), 112) ; 

		SET  @v_r_start_yyyymmdd = CONVERT(VARCHAR(8),DATEADD(WK,DATEDIFF(D,0,getdate())/7,-7), 112) ; -- 전주월요일   
		SET  @v_r_end_yyyymmdd   = CONVERT(VARCHAR(8),DATEADD(WK,DATEDIFF(D,0,getdate())/7,-1), 112) ; 

		------------------------------------------------------------------------------------------------------------- 
		-- 1. 금주 계획 생성
		-------------------------------------------------------------------------------------------------------------
		IF (datepart(DW, getdate()) = 2) AND format(getdate(), 'HH') = '01'				--매주 월요일 01시 수행
		BEGIN

			IF (SELECT COUNT(*)
			      FROM SSP_KPI_SPA_OTD1_C WITH(NOLOCK)
			     WHERE VERSION_TYPE = 'PLAN'
			      AND YYYYMMDD BETWEEN @v_p_start_yyyymmdd AND  @v_p_end_yyyymmdd 
			   ) = 0
			BEGIN

				INSERT INTO [dbo].[SSP_KPI_SPA_OTD1_C] (
					   VERSION_TYPE
					  ,CONFIRM_ID  
					  ,DIVISION_ID       
					  ,PLANT_ID          
					  ,OPERATION_GROUP   
					  ,FROM_SITE         
					  ,TO_SITE           
					  ,ITEM_ID           
					  ,YYYYMMDD          
					  ,RESULT_QTY        
					  ,PLAN_QTY  
					  ,CREATED_BY                      
					  ,CREATION_DATE    
					  ,LAST_UPDATED_BY  
					  ,LAST_UPDATE_DATE 				  ) 
				SELECT 'PLAN'
					  ,SPA.CONFIRM_iD
					  ,SPA.DIVISION_ID           
					  ,SPA.PLANT_ID              
					  ,SPA.OPERATION_GROUP       
					  ,SPA.FROM_SITE             
					  ,SPA.TO_SITE               
					  ,SPA.ITEM_ID               
					  ,SPA.YYYYMMDD               
					  ,0                     AS RESULT_QTY
					  ,SUM(SPA.PLAN_QTY)     AS PLAN_QTY
					  ,@v_batch_user  -- created_by                     
					  ,getdate()      -- creation_date    
					  ,@v_batch_user  -- last_updated_by
					  ,getdate()      -- last_update_date 
				  FROM (
					   SELECT T.CONFIRM_ID
							 ,T.DIVISION_ID 
							 ,CASE WHEN FS.OSP_YN = 'N' THEN FS.PLANT_ID 
			         			   ELSE FS.LOGISTIC_PLANT_ID  END
								   AS PLANT_ID                                     
							 ,FS.OPERATION_GROUP   AS OPERATION_GROUP
							 ,T.FROM_SITE 
							 ,T.TO_SITE
							 ,T.ITEM_ID
							 ,T.YYYYMMDD
							 ,ISNULL(T.PLAN_QTY ,0) AS PLAN_QTY 
						 FROM (
							  SELECT C.CONFIRM_ID                       
									,C.DIVISION_ID     
									,C.FROM_SITE                        
									,C.TO_SITE                          
									,C.ITEM_ID                          
									,C.YYYYMMDD                         
									,C.ORIGIN_FROM_DIVISION_ID          
									,C.ORIGIN_TO_DIVISION_ID            
									,SUM(C.QTY )             AS PLAN_QTY 
								FROM SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK) 
							   WHERE 1 = 1 
								 AND C.CONFIRM_ID LIKE 'C%'
								 AND C.CHANGE_TYPE = 'C'  
								 AND C.YYYYMMDD  BETWEEN @v_p_start_yyyymmdd   AND  @v_p_end_yyyymmdd
								 AND C.QTY > 0
							GROUP BY C.CONFIRM_ID   
									,C.DIVISION_ID                  
									,C.FROM_SITE                       
									,C.TO_SITE                         
									,C.ITEM_ID    
									,C.YYYYMMDD                     
									,C.ORIGIN_FROM_DIVISION_ID 
									,C.ORIGIN_TO_DIVISION_ID   
							  ) T
							  JOIN SCM_MST_SITE FS WITH(NOLOCK)
						   ON FS.DIVISION_ID	= T.DIVISION_ID 
						  AND FS.SCM_SITE_ID	= T.FROM_SITE 
						  AND FS.OPERATION_GROUP != 'E'
							  JOIN SCM_MST_SITE TS WITH(NOLOCK)
						   ON TS.DIVISION_ID	= T.DIVISION_ID  
						  AND TS.SCM_SITE_ID	= T.TO_SITE  
					   ) SPA 
				 WHERE 1 = 1
				 GROUP BY
					   SPA.CONFIRM_ID
					  ,SPA.DIVISION_ID           
					  ,SPA.PLANT_ID              
					  ,SPA.OPERATION_GROUP       
					  ,SPA.FROM_SITE             
					  ,SPA.TO_SITE               
					  ,SPA.ITEM_ID               
					  ,SPA.YYYYMMDD               
 					   ;
			END
		END

		------------------------------------------------------------------------------------------------------------- 
		-- 2. 전주 실적 생성 
		-------------------------------------------------------------------------------------------------------------
		IF (datepart(DW, getdate()) = 2) AND format(getdate(), 'HH') BETWEEN '06' AND '21'    --매주 월요일 법인별 시업시간 기준 수행
	    BEGIN

			INSERT INTO @TAB_COMPANY (
			       COMPANY_ID
				   )
			SELECT DISTINCT X.COMPANY_ID
			  FROM (
			       SELECT CONVERT(varchar, [LGCE_FP_TR].dbo.[FN_SITE_TIME] (L.SEGMENT1), 112) AS YYYYMMDD
			            , CONVERT(varchar, [LGCE_FP_TR].dbo.[FN_SITE_TIME] (L.SEGMENT1), 108) AS HHMISS
			            , L.SEGMENT1 AS AREA_ID
			            , L2.SEGMENT1 AS PLANT_ID
			            , L2.SEGMENT4 AS COMPANY_ID
			            , L2.SEGMENT2 AS START_TIME
				     FROM [LGCE_FP_TR].[DBO].[SCM_SYS_LOOKUP_VALUE] L WITH(NOLOCK) 
			         JOIN SCM_MST_SITE S WITH(NOLOCK) 
			           ON S.SITE_ID = L.SEGMENT1
			         JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L2 WITH(NOLOCK)  
			           ON L2.SEGMENT1 = S.PLANT_ID
			          AND L2.SEGMENT4 = S.COMPANY_ID
			          AND REPLACE(L2.SEGMENT2,':','') = L.SEGMENT2 -- 시업시간 
			          AND L2.LOOKUP_TYPE = 'BASIS_START_TIME_PLANT'
				    WHERE L.LOOKUP_TYPE_CODE = 'AUTO_PLAN_CALL_FLAG'
				      AND L.ACTIVE_FLAG = 'Y'
				      AND L2.VALID_YN = 'Y'
				      AND CONVERT(varchar, [LGCE_FP_TR].dbo.[FN_SITE_TIME] (L.SEGMENT1), 112) = convert(varchar, getdate(), 112)
				      AND CONVERT(varchar, [LGCE_FP_TR].dbo.[FN_SITE_TIME] (L.SEGMENT1), 108) >= L2.SEGMENT2
			       ) AS X	
			 WHERE X.COMPANY_ID NOT IN (
			                           SELECT DISTINCT COMPANY_ID
			                             FROM SSP_KPI_SPA_OTD1 WITH(NOLOCK)
			                            WHERE 1 = 1
			                              AND YYYYMMDD BETWEEN @v_r_start_yyyymmdd   AND  @v_r_end_yyyymmdd
                                       )
				   ;

			-- 출하 실적 수량 
			-- ERP 출하실적 SCM_DNM_EXFACTORY_RESULT
			WITH ERP_R AS (
				 -- ERP 출하실적에서 CONFIRM_ID 존재, SSP_TYPE 대상 
				 SELECT E.CONFIRM_ID
				       ,E.COMPANY_ID
					   ,E.DIVISION_ID				
					   ,E.EXFACTORY_DATE			AS YYYYMMDD
					   ,SUM(E.EXFACTORY_QTY )		AS RESULT_QTY 
				   FROM SCM_DNM_EXFACTORY_RESULT AS E WITH(NOLOCK)
			 			JOIN SCM_ADM_LOOKUP_MASTER_DETAIL AS L WITH(NOLOCK)
					 ON L.LOOKUP_TYPE = 'ERP_SSP_TYPE' -- LOOKUP에 등록된 SSP TYPE 
			 		AND L.VALID_YN = 'Y'
			 		AND L.SEGMENT1    = E.SSP_TYPE 
				  WHERE 1 = 1
					AND ISNULL(E.EXFACTORY_STATUS,'D90') NOT IN ('D90' ,'D10') -- D90: DO삭제 , D10:DO생성 
					AND E.CONFIRM_ID LIKE 'C%'
					AND E.EXFACTORY_DATE BETWEEN @v_r_start_yyyymmdd  AND  @v_r_end_yyyymmdd  
			 	
				  GROUP BY 
						E.CONFIRM_ID
					   ,E.COMPANY_ID
					   ,E.DIVISION_ID 
					   ,E.EXFACTORY_DATE  
				 )

			INSERT INTO [dbo].[SSP_KPI_SPA_OTD1_C] (        
				   VERSION_TYPE
				  ,CONFIRM_ID
				  ,DIVISION_ID       
				  ,PLANT_ID          
				  ,OPERATION_GROUP   
				  ,FROM_SITE         
				  ,TO_SITE           
				  ,ITEM_ID           
				  ,YYYYMMDD          
				  ,RESULT_QTY        
				  ,PLAN_QTY 
			      ,CREATED_BY                      
			      ,CREATION_DATE    
			      ,LAST_UPDATED_BY  
			      ,LAST_UPDATE_DATE 				  
				  ) 
			SELECT 'RESULT'
				  ,R.CONFIRM_ID
				  ,R.DIVISION_ID 
				  ,CASE WHEN FS.OSP_YN = 'N' THEN FS.PLANT_ID 
		       			ELSE  FS.LOGISTIC_PLANT_ID  
					END					AS PLANT_ID 
				  ,FS.OPERATION_GROUP 			   
				  ,R.FROM_SITE
				  ,R.TO_SITE
				  ,R.ITEM_ID 
				  ,R.YYYYMMDD
				  ,SUM(R.RESULT_QTY)	AS RESULT_QTY 
				  ,0					AS PLAN_QTY
		          ,@v_batch_user             
		          ,getdate()      
		          ,@v_batch_user  
		          ,getdate()      
		      FROM (
				   SELECT P.CONFIRM_ID
				         ,R.COMPANY_ID
						 ,P.DIVISION_ID				
						 ,P.FROM_SITE				                                                                  
						 ,P.TO_SITE					
						 ,P.ITEM_ID					
						 ,R.YYYYMMDD				
						 ,0							AS PLAN_QTY 
						 ,SUM(R.RESULT_QTY )		AS RESULT_QTY  
					 FROM [DBO].[SSP_ANL_SHIP_CONFIRM] AS P WITH(NOLOCK)
			   			  JOIN ERP_R R 
			   		   ON R.CONFIRM_ID		= P.CONFIRM_ID 
			   		  AND P.CHANGE_TYPE		= 'C'
					  AND P.QTY				> 0 
				   WHERE 1 = 1
				   GROUP BY
						 P.CONFIRM_ID
						,R.COMPANY_ID
						,P.DIVISION_ID 
						,P.FROM_SITE                                                                           
						,P.TO_SITE 
						,P.ITEM_ID   
						,R.YYYYMMDD 

				   UNION ALL 

				   -- ERP 출하실적에서 CONFIRM_ID 없는 실적  
				   /* 대상 ORDER_TYPE : LOOKUP_TYPE = 'ERP_ORDER_TYPE' 등록  
						ZEF  :수출 무상-Shipment용
						ZEFC :수출 무상-Claim용
						ZEML :수출 무상사급 주문
						ZEMM :수출 유상사급 주문
						ZEX  :Export Order(수출주문)
						ZFD  :Deliv.Free of Charge(무상 주문-견본)
						ZFR  :수출 무상주문
						ZKB  :위탁품보충
						ZMM  :내수유상사급
						ZOR  :Standard Order(내수오더) 
						ZFDC : Free of Charge
						ZKM  :Consign Fill-up(POD)
					  제외 창고 : ('6000' ,'799A')
					  제외 상태 : D90: DO삭제 , D10:DO생성 
					*/
				  SELECT '-'                       AS CONFIRM_ID
				        ,E.COMPANY_ID
						,E.DIVISION_ID             
						,E.FROM_SCM_SITE_ID        AS FROM_SITE   
						,ISNULL(L3.SEGMENT4, E.TO_SCM_SITE_ID)     
												   AS TO_SITE     				                                                                 
						,E.ITEM_ID                 AS ITEM_ID
						,E.EXFACTORY_DATE          AS YYYYMMDD
						,0                         AS PLAN_QTY 
						,SUM(E.EXFACTORY_QTY )     AS RESULT_QTY  
					FROM SCM_DNM_EXFACTORY_RESULT E WITH(NOLOCK)
					     JOIN SCP_MST_FINAL_ITEM F WITH(NOLOCK) 
			          ON F.ITEM_ID		= E.ITEM_ID
			         AND F.DIVISION_ID	= E.DIVISION_ID  	
			    		 JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
					  ON L.LOOKUP_TYPE	= 'ERP_ORDER_TYPE' -- LOOKUP에 등록된 ORDER_TYPE 
					 AND L.VALID_YN		= 'Y'
					 AND L.SEGMENT1		= E.ORDER_TYPE_CODE
			    		 LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L3 WITH(NOLOCK)
	    			  ON L3.LOOKUP_TYPE = 'SHIP_RESULT_TO_SITE_MAPPING' --SOLDTO, SHIPTO 과 MAPPING되는 TO_SITE 
					 AND L3.SEGMENT1    = E.DIVISION_ID 
					 AND L3.SEGMENT2    = E.SOLDTO_CODE
					 AND L3.SEGMENT3    = E.SHIPTO_CODE
				   WHERE 1 = 1
					 AND ISNULL(E.EXFACTORY_STATUS,'D90') NOT IN ('D90' ,'D10') -- D90: DO삭제 , D10:DO생성 
					 AND ISNULL(E.CONFIRM_ID,'') NOT LIKE  'C%'
					 AND E.EXFACTORY_DATE BETWEEN @v_r_start_yyyymmdd  AND  @v_r_end_yyyymmdd  
					 AND E.FROM_SCM_SITE_ID IS NOT NULL 
					 AND E.TO_SCM_SITE_ID IS NOT NULL 
					 AND E.STORAGE_ID NOT IN ('6000' ,'799A') --상품창고제외
					 AND E.STORAGE_ID NOT IN (SELECT SEGMENT1 
			    								FROM SCM_ADM_LOOKUP_MASTER_DETAIL 
			    							   WHERE LOOKUP_TYPE = 'SSP_SHIP_RESULT_EXCEPT_STORAGE'
			    								 AND VALID_YN = 'Y'
			    							  )	-- 사외 창고 제외 LOOKUP 관리
			         AND E.EXFACTORY_QTY > 0
				   GROUP BY
				         E.COMPANY_ID
						,E.DIVISION_ID 
						,E.FROM_SCM_SITE_ID                                                                           
						,ISNULL(L3.SEGMENT4, E.TO_SCM_SITE_ID)
						,E.ITEM_ID   
						,E.EXFACTORY_DATE  
				   ) R
				   JOIN SCM_MST_SITE FS WITH(NOLOCK)
				ON FS.DIVISION_ID  = R.DIVISION_ID
  			   AND FS.SCM_SITE_ID  = R.FROM_SITE  
			   AND FS.OPERATION_GROUP != 'E'
			 WHERE R.COMPANY_ID IN (SELECT COMPANY_ID FROM @TAB_COMPANY)
			 GROUP BY 
				   R.CONFIRM_ID
				  ,R.DIVISION_ID 
				  ,R.FROM_SITE
				  ,R.TO_SITE
				  ,R.ITEM_ID 
				  ,R.YYYYMMDD
				  ,CASE WHEN FS.OSP_YN = 'N' THEN FS.PLANT_ID 
		       			ELSE  FS.LOGISTIC_PLANT_ID  END
				  ,FS.OPERATION_GROUP 
				  ;

			------------------------------------------------------------------------------------------------------------- 
			-- 3. SSP_KPI_SPA_OTD1
			-------------------------------------------------------------------------------------------------------------

			INSERT INTO @TAB_SSP_KPI_SPA_OTD1 (
				   COMPANY_ID
				  ,DIVISION_ID       
				  ,PLANT_ID          
				  ,OPERATION_GROUP   
				  ,FROM_SITE         
				  ,TO_SITE           
				  ,ITEM_ID           
				  ,YYYYMMDD   
				  ,YYYYMM            
				  ,YYYYWW        
				  ,RESULT_QTY        
				  ,PLAN_QTY  
				  )
			SELECT
				   FS.COMPANY_ID 
				  ,SPA.DIVISION_ID           
				  ,SPA.PLANT_ID              
				  ,SPA.OPERATION_GROUP       
				  ,SPA.FROM_SITE             
				  ,SPA.TO_SITE               
				  ,SPA.ITEM_ID               
				  ,SPA.YYYYMMDD 
				  ,C.BASIS_YYYYMM
				  ,C.ISO_YYYYWW
				  ,SUM(SPA.RESULT_QTY) 
				  ,SUM(SPA.PLAN_QTY)
			  FROM ( 
		 		   SELECT 
						  DIVISION_ID           
						 ,PLANT_ID              
						 ,OPERATION_GROUP       
						 ,FROM_SITE             
						 ,TO_SITE               
						 ,ITEM_ID               
						 ,YYYYMMDD               
						 ,PLAN_QTY AS PLAN_QTY 
						 ,0        AS RESULT_QTY
					 FROM SSP_KPI_SPA_OTD1_C WITH(NOLOCK) 
					WHERE YYYYMMDD  BETWEEN @v_r_start_yyyymmdd AND  @v_r_end_yyyymmdd
					  AND VERSION_TYPE  = 'PLAN'
					  AND PLAN_QTY > 0
					UNION ALL 
				   SELECT 
						  DIVISION_ID           
						 ,PLANT_ID              
						 ,OPERATION_GROUP       
						 ,FROM_SITE             
						 ,TO_SITE               
						 ,ITEM_ID               
						 ,YYYYMMDD               
						 ,0            AS PLAN_QTY 
						 ,RESULT_QTY   AS RESULT_QTY
					 FROM SSP_KPI_SPA_OTD1_C WITH(NOLOCK) 
					WHERE YYYYMMDD  BETWEEN @v_r_start_yyyymmdd AND @v_r_end_yyyymmdd
					  AND VERSION_TYPE  = 'RESULT'
					  AND RESULT_QTY > 0
				   ) SPA 
				   INNER JOIN SCM_SYS_CALENDAR_M AS C WITH(NOLOCK)
				ON C.BASIS_YYYYMMDD  = SPA.YYYYMMDD 
				   INNER JOIN SCM_MST_SITE AS FS WITH(NOLOCK)
				ON SPA.DIVISION_ID = FS.DIVISION_ID
			   AND SPA.FROM_SITE   = FS.SCM_SITE_ID
             WHERE FS.COMPANY_ID IN (SELECT COMPANY_ID FROM @TAB_COMPANY)
			 GROUP BY
				   FS.COMPANY_ID
				  ,SPA.DIVISION_ID           
				  ,SPA.PLANT_ID              
				  ,SPA.OPERATION_GROUP       
				  ,SPA.FROM_SITE             
				  ,SPA.TO_SITE               
				  ,SPA.ITEM_ID               
				  ,SPA.YYYYMMDD  
				  ,C.BASIS_YYYYMM
				  ,C.ISO_YYYYWW
				  ;

			INSERT INTO SSP_KPI_SPA_OTD1 (
				   COMPANY_ID
				  ,DIVISION_ID       
				  ,PLANT_ID          
				  ,OPERATION_GROUP   
				  ,FROM_SITE         
				  ,TO_SITE           
				  ,ITEM_ID           
				  ,YYYYMMDD   
				  ,ITEM_DOE
				  ,PACK_GROUP
				  ,CELL_GROUP
				  ,YYYYMM            
				  ,YYYYWW        
				  ,RESULT_QTY        
				  ,PLAN_QTY  
				  ,RESULT_CELL_QTY
				  ,PLAN_CELL_QTY
				  ,CREATED_BY                      
				  ,CREATION_DATE    
				  ,LAST_UPDATED_BY  
				  ,LAST_UPDATE_DATE 
				  ,ATTRIBUTE1
				  )
			SELECT
				   T.COMPANY_ID
				  --,T.DIVISION_ID     
				  ,D.ATTRIBUTE3
				  ,T.PLANT_ID              
				  ,T.OPERATION_GROUP       
				  ,T.FROM_SITE             
				  ,T.TO_SITE               
				  ,T.ITEM_ID               
				  ,T.YYYYMMDD 
				  ,ISNULL(M.DOE, T.ITEM_ID) AS ITEM_DOE
				  ,F.GROUP_CODE1
				  ,F.GROUP_CODE2
				  ,T.YYYYMM                 
				  ,T.YYYYWW   
				  ,MAX(T.RESULT_QTY) AS RESULT_QTY 
				  ,MAX(T.PLAN_QTY)   AS PLAN_QTY
				  ,SUM(T.RESULT_QTY * BM.ACCUMULATED_CHILD_QTY) AS RESULT_CELL_QTY
				  ,SUM(T.PLAN_QTY   * BM.ACCUMULATED_CHILD_QTY) AS PLAN_CELL_QTY 
				  ,@v_batch_user                
				  ,getdate()      
				  ,@v_batch_user  
				  ,getdate()      
				  ,COUNT(*)       -- CHILD ITEM 수
			  FROM @TAB_SSP_KPI_SPA_OTD1 AS T
			       INNER JOIN SCM_MST_ITEM_SN AS M WITH(NOLOCK)
				ON T.COMPANY_ID		= M.COMPANY_ID
			   AND T.DIVISION_ID	= M.DIVISION_ID
			   AND T.ITEM_ID		= M.ITEM_ID
			       JOIN SCM_MST_DIVISION AS D WITH(NOLOCK)
				ON T.DIVISION_ID    = D.DIVISION_ID
			   AND D.ATTRIBUTE3     IN ('40','81','82')

			       LEFT OUTER JOIN SCP_MST_FINAL_ITEM AS F WITH(NOLOCK)
			    ON T.DIVISION_ID	= F.DIVISION_ID
			   AND T.ITEM_ID		= F.ITEM_ID
                   INNER JOIN  (SELECT BM.DIVISION_ID, BM.MODEL_ID, BM.CHILD_ITEM_ID, MAX(ACCUMULATED_CHILD_QTY) as ACCUMULATED_CHILD_QTY
                                  FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V AS BM
                                       INNER JOIN SCM_MST_PLANT_SN AS MP
	                                ON BM.DIVISION_ID	= MP.DIVISION_ID
	                               AND BM.PLANT_ID		= MP.PLANT_ID
	                                   INNER JOIN SCM_MST_ITEM_SN AS MI WITH(NOLOCK)
                                    ON BM.DIVISION_ID   = MI.DIVISION_ID
                                   AND BM.CHILD_ITEM_ID = MI.ITEM_ID
	                               AND MP.COMPANY_ID    = MI.COMPANY_ID
	                               --AND MI.DIVISION_ID IN ('40', '81', '82')
                                   AND MI.SCP_OPERATION_GROUP = 'A'
                                   AND MI.SCP_FLOW_ID IN ('A3000', 'A9000')
								       JOIN SCM_MST_DIVISION AS D WITH(NOLOCK)
									ON MI.DIVISION_ID = D.DIVISION_ID
								   AND D.ATTRIBUTE3 IN ('40', '81', '82')
                                 WHERE BM.OPERATION_GROUP_ID = 'A'
                                   AND BM.TCO_CELL_YN        = 'N'
			                     GROUP BY BM.DIVISION_ID, BM.MODEL_ID, BM.CHILD_ITEM_ID) AS BM
			    ON T.DIVISION_ID	= BM.DIVISION_ID
			   AND T.ITEM_ID		= BM.MODEL_ID
             WHERE 1 = 1
			 GROUP BY
                   T.COMPANY_ID
                  --,T.DIVISION_ID 
				  ,D.ATTRIBUTE3
                  ,T.PLANT_ID       
                  ,T.OPERATION_GROUP
                  ,T.FROM_SITE      
                  ,T.TO_SITE        
                  ,T.ITEM_ID        
                  ,T.YYYYMMDD 
                  ,ISNULL(M.DOE, T.ITEM_ID) 
                  ,F.GROUP_CODE1
                  ,F.GROUP_CODE2
                  ,T.YYYYMM         
                  ,T.YYYYWW   

	    END

        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------
        IF @@TRANCOUNT > 0
          BEGIN
            COMMIT TRAN TX_SH;
          END;       


        -- TXN LOG
        SET @v_log_type = N'TXN';    -- ▶ 로그타입
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = N'INSERT INTO '+@v_table_id;
        SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
        SET @d_event_date =  SYSDATETIME();

        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                  ,@p_log_type      =@v_log_type
                                  ,@p_log_count     =@n_log_count 
                                  ,@p_log_message   =@v_log_message 
                                  ,@p_description   =@v_description 
                                  ,@p_event_date    =@d_event_date 
                                  ,@p_user_id       =@v_batch_user
                                  ;      

    END
    END TRY

    BEGIN CATCH
      IF @@TRANCOUNT > 0
        BEGIN
          ROLLBACK TRAN TX_SH


        END;
      
      -- ERROR LOG
      SET @v_log_type = N'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = @v_program_name + N'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                ,@p_log_type      =@v_log_type
                                ,@p_log_count     =@n_log_count 
                                ,@p_log_message   =@v_log_message 
                                ,@p_description   =@v_description 
                                ,@p_event_date    =@d_event_date 
                                ,@p_user_id       =@v_batch_user
                                ;
--      PRINT @@ERROR
      return -1
    END CATCH;

     --임시 운영반영시에 주석처리 할것.
     SET @v_exec_time  =  REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' + 
                          REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) 


    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description = N'['++'][' + @v_exec_time + ']';  
    SET @d_event_date = SYSDATETIME()  ;
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;
   
    return 1  

  END; 
