
/*
 * Program ID   : PR_SSP_KPI_SPA_SHIPPING_PLAN_ACCURACY  
 * Description  : KPI 출하 준수율 SPA (SHIPPING_PLAN_ACCURACY ) DW 전송(08시) 
 *                매주 월요일 11:20 수행( BATCH JOB : JOB.PR_SSP_KPI_SPA_SHIPPING_PLAN_ACCURACY ) 
 *                SSP_KPI_SPA_SHIPPING_PLAN_ACCURACY_C에 계획/실적 생성 후 전주의 계획/실적을 취합함 
 *                 -계획 : 금주의 확정 수량(차주 실적 취합시 계획으로) 한주전에 변경전 확정수량을 계획으로 설정   
 *                 -실적 : 전주의 출하지시 수량(SSP_KPI_DIA_DELIVERY_INSTRUCTION_ACCURACY.EXFACTORY_QTY : 출하수량) 
 *                 EX) 금주월요일(W45) 수행시 수행시점의 W45에 대한 확정수량을 계획수량으로 사전 생성, W44에 대한 확정수량을 실적 
 *                     차주월요일(W46) 수행시 지난주 생성된 계획(W45) 대비 차주 생성될 실적(W45)기준으로 계획/실적 수량을 취함   
 * Execute      : EXEC PR_SSP_KPI_SPA_SHIPPING_PLAN_ACCURACY 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.09.03   LJH            Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트    
 * 2018.12.04   LJH            실적기준 변경 
 *                              - 기존 : 전주의 계획 확정 수량 (SSP_ANL_SHIP_CONFIRM.QTY)  
 *                              - 변경 : 전주의 출하지시 실적 수량 (SSP_KPI_DIA_DELIVERY_INSTRUCTION_ACCURACY.EXFACTORY_QTY : 출하수량) 
 * 2018.12.20   LJH            소형 집계 제외 ( division_id = 40) (reqeusted by 지준혁-20181219)
 * 2019.01.10   LJH		       FROM_SITE, TO_SITE가 Packer인 경우 대상 제외(reqeusted by 지준혁-20190110) 
 * 2019.05.27   AYJ            [CSR ID:4001447] [KPI] 소형 사업부 출하계획 준수율 Data 수집 및 제공 요청[소형 집계 추가 ( division_id = 40) ]  
 * 2019.10.07   LJH            출하실적 추출 로직 변경 - [PJ20189106] 전지.GSCM 고도화 이행 
 *                             ERP출하실적 중 SSP에서 연계된 출하(CONFIRM_ID존재) + ERP출하실적 중 SSP에서 연계되지 않은 실적  
 * 2020.03.16   LJH            [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선  
                               - ESS Packer 출하 적용으로 Packer제외 로직 삭제 
 * 2020.05.06	KIMYONGHO      [C20200403-000062] [GSCM PI] SSP 출하 실적 집계 중 사외 창고 제외 로직 추가 건 
 * 2020.09.18   kim bok ki     lookup_type = 'ERP_ORDER_TYPE' 제거
 * 2021.04.15   SSP Pjt.       lookup_type = 'ERP_ORDER_TYPE' 재적용
 * 2021.04.30   SSP Pjt.       SSP_KPI_SPA_SHIPPING_PLAN_ACCURACY.attribute1에 ISOYYYYWW 값 적용
 * 2021.09.06   SSP Pjt.       계획과 실적 로직 분리 
 * 2022.04.01   SSP Pjt.       JV DIVISION_ID 적용
 * 2024.10.01   KHJ            NERP_SSP
 */
 CREATE PROCEDURE [dbo].[PR_SSP_KPI_SPA_SHIPPING_PLAN_ACCURACY]
--( 
--	--  @p_division_id        NVARCHAR(30)
--) 
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'ssp_batch';  
    SET     @v_batch_user = 'ssp_batch' ; -- @p_user_id
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SSP_KPI_SPA_SHIPPING_PLAN_ACCURACY';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N'SSP_KPI_SPA_SHIPPING_PLAN_ACCURACY'; -- ▶ 테이블 필수
    DECLARE @d_event_date   DATETIME;

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SHIP_CONFIRM INSERT LOGIC';
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


    BEGIN TRY
      BEGIN
        BEGIN TRAN TX_SH

      	------------------------------------------------------------------------------------------------------------- 
		-- 0. 실적(현재일 기준 전주 월요일 ~ 일요일)  VERSION_TYPE : RESULT ( 현재 실적 ) 
		------------------------------------------------------------------------------------------------------------- 
		-- 현재일 기준 전주 월요일  
		SET  @v_r_start_yyyymmdd = CONVERT(VARCHAR(8),DATEADD(WK,DATEDIFF(D,0,GETDATE())/7,-7), 112) ; -- 전주월요일   
		SET  @v_r_end_yyyymmdd  =  CONVERT(VARCHAR(8),DATEADD(WK,DATEDIFF(D,0,GETDATE())/7,-1), 112) ; -- 전주일요일

		------------------------------------------------------------------------------------------------------------- 
		-- 0. 계획(현재일 기준 금주 월요일 ~ 일요일)  VERSION_TYPE : PLAN ( 현재 실적 ) --> 추주에 실적 비교하기 위한 계획기준
		--   
		------------------------------------------------------------------------------------------------------------- 
		-- 현재일 기준 전주 월요일  
		SET  @v_p_start_yyyymmdd = CONVERT(VARCHAR(8),DATEADD(WK,DATEDIFF(D,0,GETDATE())/7,0), 112) ; -- 금주월요일   
		SET  @v_p_end_yyyymmdd  =  CONVERT(VARCHAR(8),DATEADD(WK,DATEDIFF(D,0,GETDATE())/7,6), 112) ; -- 금주일요일


		------------------------------------------------------------------------------------------------------------- 
		-- 1. 전수 실적 생성(BATCH 월요일 수행 기준 전주 월요일 ~ 전주 일요일 ) 
		-------------------------------------------------------------------------------------------------------------
        DELETE 
		FROM  SSP_KPI_SPA_SHIPPING_PLAN_ACCURACY_C
		WHERE VERSION_TYPE = 'RESULT'
		AND   YYYYMMDD BETWEEN @v_r_start_yyyymmdd   AND  @v_r_end_yyyymmdd ;

		-- 출하 실적 수량 
		-- ERP 출하실적 SCM_DNM_EXFACTORY_RESULT
		WITH ERP_R AS (
			 -- ERP 출하실적에서 CONFIRM_ID 존재, SSP_TYPE 대상 
			 SELECT E.DIVISION_ID				AS DIVISION_ID
			       ,E.CONFIRM_ID				AS CONFIRM_ID 
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
			        E.DIVISION_ID 
			       ,E.CONFIRM_ID 
			       ,E.EXFACTORY_DATE  
			 )

		INSERT INTO SSP_KPI_SPA_SHIPPING_PLAN_ACCURACY_C (        
			   VERSION_TYPE
              ,CONFIRM_ID
			  ,DIVISION_ID       
			  ,PLANT_ID          
			  ,OPERATION_GROUP   
			  ,FROM_SITE         
			  ,TO_SITE           
			  ,ITEM_ID           
			  ,YYYYMMDD          
			  ,YYYYMM            
			  ,WEEK_NAME         
			  ,RESULT_QTY        
			  ,PLAN_QTY   
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
		SELECT 'RESULT'				AS VERSION_TYPE
		      ,R.CONFIRM_ID			AS CONFIRM_ID
		      ,R.DIVISION_ID
		      ,CASE WHEN FS.OSP_YN = 'N' THEN FS.PLANT_ID 
		       	    ELSE  FS.LOGISTIC_PLANT_ID  
				END					AS PLANT_ID 
		      ,FS.OPERATION_GROUP 			   
		      ,R.FROM_SITE
		      ,R.TO_SITE
		      ,R.ITEM_ID 
		      ,R.YYYYMMDD
		      ,SUBSTRING (R.YYYYMMDD ,1,6)  AS YYYYMM
		      ,C.WEEK_NAME
		      ,SUM(R.RESULT_QTY)	AS RESULT_QTY 
		      ,0					AS PLAN_QTY
		      ,@v_batch_user		-- CREATED_BY                     
		      ,GETDATE()			-- CREATION_DATE    
		      ,@v_batch_user		-- LAST_UPDATED_BY
		      ,GETDATE()			-- LAST_UPDATE_DATE 
		      ,NULL					-- ATTRIBUTE1       
		      ,NULL					-- ATTRIBUTE2       
		      ,NULL					-- ATTRIBUTE3       
		      ,NULL					-- ATTRIBUTE4       
		      ,NULL					-- ATTRIBUTE5       
		      ,NULL					-- ATTRIBUTE6       
		      ,NULL					-- ATTRIBUTE7       
		      ,NULL					-- ATTRIBUTE8       
		      ,NULL					-- ATTRIBUTE9       
		      ,NULL					-- ATTRIBUTE10    
		  FROM (
			   SELECT P.DIVISION_ID				AS DIVISION_ID
			         ,R.CONFIRM_ID				AS CONFIRM_ID
			         ,P.FROM_SITE				AS FROM_SITE                                                                    
			         ,P.TO_SITE					AS TO_SITE
			         ,P.ITEM_ID					AS ITEM_ID
			         ,R.YYYYMMDD				AS YYYYMMDD
			         ,0							AS PLAN_QTY 
			         ,SUM(R.RESULT_QTY )		AS RESULT_QTY  
			         ,'C-EXIT'					AS TYPE
			     FROM [DBO].[SSP_ANL_SHIP_CONFIRM] AS P WITH(NOLOCK)
			   	      JOIN ERP_R R 
			   	   ON R.DIVISION_ID		= P.DIVISION_ID 
			   	  AND R.CONFIRM_ID		= P.CONFIRM_ID 
			   	  AND P.CHANGE_TYPE		= 'C'
		          AND P.QTY				> 0 
			   WHERE 1 = 1
			   GROUP BY 
			         P.DIVISION_ID 
			        ,P.FROM_SITE                                                                           
			        ,P.TO_SITE 
			        ,P.ITEM_ID   
			        ,R.YYYYMMDD 
			        ,R.CONFIRM_ID

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
			  SELECT E.DIVISION_ID             AS DIVISION_ID
			        ,'-'                       AS CONFIRM_ID
			        ,E.FROM_SCM_SITE_ID        AS FROM_SITE   
			        ,ISNULL(L3.SEGMENT4, E.TO_SCM_SITE_ID)     
											   AS TO_SITE     				                                                                 
			        ,E.ITEM_ID                 AS ITEM_ID
			        ,E.EXFACTORY_DATE          AS YYYYMMDD
			        ,0                         AS PLAN_QTY 
			        ,SUM(E.EXFACTORY_QTY )     AS RESULT_QTY  
			        ,'NONE'                    AS TYPE
			    FROM SCM_DNM_EXFACTORY_RESULT E WITH(NOLOCK)
			         JOIN SCP_MST_FINAL_ITEM F WITH(NOLOCK) 
			      ON F.ITEM_ID		= E.ITEM_ID
			     AND F.DIVISION_ID	= E.DIVISION_ID  
			    
			     -- 2020.09.18 김광희 책임 요청으로 주석처리
			     -- 2021.04.15 김광희 책임 요청으로 주석해제
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
--			     AND E.STORAGE_ID NOT IN ('6000' ,'799A') --상품창고제외
			     AND E.STORAGE_ID NOT IN (select CODE FROM dbo.FN_LIST_LOOKUP_VALUE('PR_SSP_KPI_SPA_SHIPPING_PLAN_ACCURACY','PRODUCT_STORAGE')) --상품창고제외
			     --[C20200403-000062]
			     AND E.STORAGE_ID NOT IN (SELECT SEGMENT1 
			    						    FROM SCM_ADM_LOOKUP_MASTER_DETAIL 
			    						   WHERE LOOKUP_TYPE = 'SSP_SHIP_RESULT_EXCEPT_STORAGE'
			    							 AND VALID_YN = 'Y'
			    						  )	-- 사외 창고 제외 LOOKUP 관리
			   GROUP BY 
			         E.DIVISION_ID 
			        ,E.FROM_SCM_SITE_ID                                                                           
			        ,E.TO_SCM_SITE_ID 
			        ,E.ITEM_ID   
			        ,E.EXFACTORY_DATE  
			        ,L3.SEGMENT4
			   ) R
		       JOIN SCM_MST_SITE FS WITH(NOLOCK)
			ON FS.DIVISION_ID  = R.DIVISION_ID
  		   AND FS.SCM_SITE_ID  = R.FROM_SITE  
		       JOIN SCM_SYS_CALENDAR_M C WITH(NOLOCK)
			ON C.BASIS_YYYYMMDD  = R.YYYYMMDD 
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
		      ,C.WEEK_NAME
		      ;
		   
		------------------------------------------------------------------------------------------------------------- 
		-- 2. 금주 시점의 계획 생성 (SNAP_SHOT , BATCH 월요일 수행 기준 금주 월요일 ~ 금주 일요일) 기준 수량  --> 차주 실적과 비교하기 위한 계획  
		-------------------------------------------------------------------------------------------------------------
        DELETE 
		FROM  SSP_KPI_SPA_SHIPPING_PLAN_ACCURACY_C
		WHERE VERSION_TYPE = 'PLAN'
		AND   YYYYMMDD BETWEEN @v_p_start_yyyymmdd   AND  @v_p_end_yyyymmdd ;


		INSERT INTO SSP_KPI_SPA_SHIPPING_PLAN_ACCURACY_C
		(        
				 VERSION_TYPE
                ,CONFIRM_ID  
				,DIVISION_ID       
				,PLANT_ID          
				,OPERATION_GROUP   
				,FROM_SITE         
				,TO_SITE           
				,ITEM_ID           
				,YYYYMMDD          
				,YYYYMM            
				,WEEK_NAME         
				,RESULT_QTY        
				,PLAN_QTY  
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
		  SELECT     'PLAN'
		            ,SPA.CONFIRM_ID
					,SPA.DIVISION_ID 
					,SPA.PLANT_ID              
					,SPA.OPERATION_GROUP       
					,SPA.FROM_SITE             
					,SPA.TO_SITE               
					,SPA.ITEM_ID               
					,SPA.YYYYMMDD               
					,SPA.YYYYMM                 
					,SPA.WEEK_NAME             
					,0                     AS RESULT_QTY
					,SUM(SPA.PLAN_QTY)     AS PLAN_QTY
					,@v_batch_user  -- CREATED_BY                     
					,GETDATE()      -- CREATION_DATE    
					,@v_batch_user  -- LAST_UPDATED_BY
					,GETDATE()      -- LAST_UPDATE_DATE 
					,NULL           -- ATTRIBUTE1       
					,NULL			-- ATTRIBUTE2       
					,NULL			-- ATTRIBUTE3       
					,NULL			-- ATTRIBUTE4       
					,NULL			-- ATTRIBUTE5       
					,NULL			-- ATTRIBUTE6       
					,NULL			-- ATTRIBUTE7       
					,NULL			-- ATTRIBUTE8       
					,NULL			-- ATTRIBUTE9       
					,NULL			-- ATTRIBUTE10    
		  FROM (
			SELECT T.DIVISION_ID 
			,      T.CONFIRM_ID
			,      CASE WHEN FS.OSP_YN = 'N' THEN FS.PLANT_ID 
						ELSE  FS.LOGISTIC_PLANT_ID  END		   AS PLANT_ID                                     
			,      FS.OPERATION_GROUP   AS OPERATION_GROUP
			,      T.FROM_SITE 
			,      T.TO_SITE
			,      T.ITEM_ID
			,      T.YYYYMMDD
			,      T.YYYYMM
			,      T.WEEK_NAME 
			,      ISNULL(T.PLAN_QTY ,0) AS PLAN_QTY 
			FROM   (
					SELECT CASE WHEN C.DIVISION_ID ='EE' THEN  C.ORIGIN_FROM_DIVISION_ID  ELSE C.DIVISION_ID END    AS DIVISION_ID
					,      C.CONFIRM_ID                       AS CONFIRM_iD
					,      C.FROM_SITE                        AS FROM_SITE
					,      C.TO_SITE                          AS TO_SITE
					,      C.ITEM_ID                          AS ITEM_ID
					,      C.YYYYMMDD                         AS YYYYMMDD
					,      SUBSTRING (A.BASIS_YYYYMMDD ,1,6)  AS YYYYMM
					,      A.WEEK_NAME                        AS WEEK_NAME
					,      C.ORIGIN_FROM_DIVISION_ID          AS ORIGIN_FROM_DIVISION_ID
					,      C.ORIGIN_TO_DIVISION_ID            AS ORIGIN_TO_DIVISION_ID
					,      SUM(C.QTY )                        AS PLAN_QTY 
					FROM SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK) 
					 JOIN SCM_SYS_CALENDAR_M A WITH(NOLOCK)
					   ON A.BASIS_YYYYMMDD  = C.YYYYMMDD 
                    WHERE 1=1 
					AND   C.CONFIRM_ID LIKE 'C%'
					AND   C.CHANGE_TYPE = 'C'  
					AND   C.YYYYMMDD  BETWEEN @v_p_start_yyyymmdd   AND  @v_p_end_yyyymmdd
					GROUP BY C.DIVISION_ID   
					,        C.CONFIRM_ID                  
					,        C.FROM_SITE                       
					,        C.TO_SITE                         
					,        C.ITEM_ID    
					,        C.YYYYMMDD                     
					,        SUBSTRING (A.BASIS_YYYYMMDD ,1,6) 
					,        A.WEEK_NAME   
					,        C.ORIGIN_FROM_DIVISION_ID 
					,        C.ORIGIN_TO_DIVISION_ID   

				  ) T
			 JOIN SCM_MST_DIVISION D WITH(NOLOCK)
			   ON D.DIVISION_ID  = CASE WHEN T.DIVISION_ID ='EE' THEN ORIGIN_FROM_DIVISION_ID ELSE T.DIVISION_ID END 

			 JOIN SCM_MST_SITE FS WITH(NOLOCK)
			   ON FS.DIVISION_ID  = CASE WHEN T.DIVISION_ID ='EE' THEN ORIGIN_FROM_DIVISION_ID ELSE T.DIVISION_ID END 
			  AND FS.SCM_SITE_ID  = T.FROM_SITE  

			 JOIN SCM_MST_SITE TS WITH(NOLOCK)
			   ON TS.DIVISION_ID  = CASE WHEN T.DIVISION_ID ='EE' THEN ORIGIN_TO_DIVISION_ID ELSE T.DIVISION_ID END 
			  AND TS.SCM_SITE_ID  = T.TO_SITE  
			  ) SPA 
			  GROUP BY
			         SPA.CONFIRM_ID
					,SPA.DIVISION_ID 
					,SPA.PLANT_ID              
					,SPA.OPERATION_GROUP       
					,SPA.FROM_SITE             
					,SPA.TO_SITE               
					,SPA.ITEM_ID               
					,SPA.YYYYMMDD               
					,SPA.YYYYMM                 
					,SPA.WEEK_NAME  
 			   ;

		------------------------------------------------------------------------------------------------------------- 
		-- 2. KPI_SPA_SHIPPING_PLAN_ACCURACY
		-------------------------------------------------------------------------------------------------------------
		DELETE 
		FROM SSP_KPI_SPA_SHIPPING_PLAN_ACCURACY
		WHERE YYYYMMDD BETWEEN @v_r_start_yyyymmdd  AND  @v_r_end_yyyymmdd ;

		
		INSERT INTO SSP_KPI_SPA_SHIPPING_PLAN_ACCURACY (
			        DIVISION_ID       
			       ,PLANT_ID          
			       ,OPERATION_GROUP   
			       ,FROM_SITE         
			       ,TO_SITE           
			       ,ITEM_ID           
			       ,YYYYMMDD          
			       ,YYYYMM            
			       ,WEEK_NAME         
			       ,RESULT_QTY        
			       ,PLAN_QTY          
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
		            --SPA.DIVISION_ID 
		            D.ATTRIBUTE3 AS DIVISION_ID
		           ,SPA.PLANT_ID              
		           ,SPA.OPERATION_GROUP       
		           ,SPA.FROM_SITE             
		           ,SPA.TO_SITE               
		           ,SPA.ITEM_ID               
		           ,SPA.YYYYMMDD               
		           ,SPA.YYYYMM                 
		           ,SPA.WEEK_NAME   
		           ,SUM(SPA.RESULT_QTY) 
		           ,SUM(SPA.PLAN_QTY) 
		           ,@v_batch_user  -- CREATED_BY                     
		           ,GETDATE()      -- CREATION_DATE    
		           ,@v_batch_user  -- LAST_UPDATED_BY
		           ,GETDATE()      -- LAST_UPDATE_DATE 
		           ,C.ISO_YYYYWW   -- ATTRIBUTE1       
		           ,NULL			-- ATTRIBUTE2       
		           ,NULL			-- ATTRIBUTE3       
		           ,NULL			-- ATTRIBUTE4       
		           ,NULL			-- ATTRIBUTE5       
		           ,NULL			-- ATTRIBUTE6       
		           ,NULL			-- ATTRIBUTE7       
		           ,NULL			-- ATTRIBUTE8       
		           ,NULL			-- ATTRIBUTE9       
		           ,NULL			-- ATTRIBUTE10              
		       FROM (
		 	        SELECT 
			               DIVISION_ID           
			              ,PLANT_ID              
			              ,OPERATION_GROUP       
			              ,FROM_SITE             
			              ,TO_SITE               
			              ,ITEM_ID               
			              ,YYYYMMDD               
			              ,YYYYMM                 
			              ,WEEK_NAME 
			              ,PLAN_QTY AS PLAN_QTY 
			              ,0        AS RESULT_QTY
			          FROM SSP_KPI_SPA_SHIPPING_PLAN_ACCURACY_C WITH(NOLOCK) 
			         WHERE YYYYMMDD  BETWEEN @v_r_start_yyyymmdd   AND  @v_r_end_yyyymmdd
			           AND VERSION_TYPE  = 'PLAN'
		             UNION ALL 
			        SELECT 
			               DIVISION_ID           
			              ,PLANT_ID              
			              ,OPERATION_GROUP       
			              ,FROM_SITE             
			              ,TO_SITE               
			              ,ITEM_ID               
			              ,YYYYMMDD               
			              ,YYYYMM                 
			              ,WEEK_NAME 
			              ,0            AS PLAN_QTY 
			              ,RESULT_QTY   AS RESULT_QTY
			          FROM SSP_KPI_SPA_SHIPPING_PLAN_ACCURACY_C WITH(NOLOCK) 
			         WHERE YYYYMMDD  BETWEEN @v_r_start_yyyymmdd   AND  @v_r_end_yyyymmdd
			           AND VERSION_TYPE  = 'RESULT'
		            ) SPA 
		            JOIN SCM_MST_DIVISION D WITH(NOLOCK)
		         ON SPA.DIVISION_ID	= D.DIVISION_ID

		            JOIN SCM_SYS_CALENDAR_M C WITH(NOLOCK)
		         ON C.BASIS_YYYYMMDD  = SPA.YYYYMMDD 
		   GROUP BY 
		         --SPA.DIVISION_ID 
		         D.ATTRIBUTE3
		        ,SPA.PLANT_ID              
		        ,SPA.OPERATION_GROUP       
		        ,SPA.FROM_SITE             
		        ,SPA.TO_SITE               
		        ,SPA.ITEM_ID               
		        ,SPA.YYYYMMDD               
		        ,SPA.YYYYMM                 
		        ,SPA.WEEK_NAME   
		        ,C.ISO_YYYYWW
		        ;

		-- 계획/실적둘다 0인것은 제외 
		DELETE 
		FROM SSP_KPI_SPA_SHIPPING_PLAN_ACCURACY 
		WHERE YYYYMMDD BETWEEN @v_r_start_yyyymmdd  AND  @v_r_end_yyyymmdd
		AND   ( RESULT_QTY = 0 AND PLAN_QTY = 0 )
		;

       	-- 소형 집계 제외 ( division_id = 40) (reqeusted by 지준혁-20181219)  
		-- 이후 소형 추가시 해당 내용 주석처리 필요
		-- 소형 추가로 주석처리 함(20190527)
/*
		DELETE 
		FROM  SSP_KPI_SPA_SHIPPING_PLAN_ACCURACY 
		WHERE YYYYMMDD BETWEEN @v_r_start_yyyymmdd  AND  @v_r_end_yyyymmdd
		AND   DIVISION_ID = '40' 
		;
*/

/*
        -- FROM_SITE, TO_SITE가 Packer인 경우 대상 제외(reqeusted by 지준혁-20190110)  
		-- TO_SITE가 Packer인 경우 대상 포함 (reqeusted by 지준혁-20190920)  
        --[PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선(20200316)  
        --  ESS Packer 출하 적용으로 Packer제외 로직 삭제
		DELETE FROM SSP_KPI_SPA_SHIPPING_PLAN_ACCURACY  
		FROM SSP_KPI_SPA_SHIPPING_PLAN_ACCURACY  SPA
		JOIN  SCM_MST_SITE FS WITH(NOLOCK)
			ON FS.SCM_SITE_ID = SPA.FROM_SITE 
		   AND FS.DIVISION_ID = SPA.DIVISION_ID 
		WHERE  FS.OSP_YN = 'Y' 
		AND    SPA.YYYYMMDD BETWEEN @v_r_start_yyyymmdd  AND  @v_r_end_yyyymmdd
		;
*/
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
      SET @v_description = @v_program_name + N' ERROR_LINE : ' + STR(ERROR_LINE());
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
