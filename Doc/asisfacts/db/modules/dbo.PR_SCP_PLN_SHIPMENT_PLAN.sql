    
        
        
    
        
        
/*        
 * Program ID   : PR_SCP_PLN_SHIPMENT_PLAN          
 * Description  : PR_SCP_PLN_CREATE_DATA 에서 호출함.        
 * OutTable     :        
 * Execute      :   
  EXEC PR_SCP_PLN_SHIPMENT_PLAN    @p_plan_cycle          ='WEEKLY'  
                                , @p_plan_start_yyyymmdd ='20180702'     
                                , @p_plan_id             ='1033'     
                                , @p_modeling_id         ='3'            
                                , @p_seq                 ='8'  
                                , @p_plan_type           ='PR'      
                                , @p_master_id           ='82::WEEKLY'   
                                , @p_division_id         ='82'       
                                , @p_engine_plan_id      ='1033::PR::8'    
                                , @p_user_id             = 'KWON'  
 * Program History        
 *===================================================================================================        
 *   Date       In Charge      Description        
 *===================================================================================================        
 * 2018.02.21   KTH         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트        
 * 2018.03.27   YYDOK       SUPPLY PLAN, SUPPLY REQ에 FCST TYPE,DOM_EXP 제거        
 * 2018.05.28   KTH         INCOTERMS 조회 변경    
 * 2018.05.28   KTH         'SHIP_REQ' MEASURE 수정    
 * 2018.06.07   KTH         TRANSACTION 삭제    
 * 2018.06.27   KTH         전극 SCP 반영(ORIGIN_FROM_DIVISION_ID,ORIGIN_TO_DIVISION_ID,ELECTRODE_TYPE) 추가  
 * 2018.07.04   KTH         SCP_MST_FINAL_ITEM_V로 변경  
 * 2018.07.05   KTH         변경된 SCP_PLN_DELIVERY_V 반영  
 * 2018.07.09   KTH         ATTRIBUTE1,2,3,4 추가  
 * 2018.07.11   KTH         SCP_ENG_DELIVERY_O_TEMP로 변경  
 * 2018.07.26   KTH         INCOTERMS 조회로직 변경(BOD_ID --> DEMAND_ID)   
 * 2018.08.15   YYDOK       EE TRANSPORT MODE 미생성오류수정(DIVISION_ID ->ORIGIN_FROM_DIVISION_ID)    
 * 2018.09.12   KTH         SCP_PLN_SHIPMENT_PLAN_PEGGING.ITEM_ID 컬럼 추가   ALTER TABLE SCP_PLN_SHIPMENT_PLAN_PEGGING  ADD ITEM_ID NVARCHAR(50)  
 * 2020.09.12   KTH         SCP_PLN_SHIPMENT_PLAN 입력시 START_TIME, END_TIME MIN() 처리 
 * 2021.02.26   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선
 *                            - ESS MOQ Lot Size별 출하로직(엔진 인바운드) 적용건에서 오류방지를 위한 선제적 조치 (ORDER ID 중복방지)
 * 2021.07.07   sclee       PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - 참조뷰 변경 및 조인조건 추가
 * 2022.03.22   KSW         GM JV 반영
 * 2023.03.31   HRK		    PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 */        
         
        
         
CREATE PROCEDURE [dbo].[PR_SCP_PLN_SHIPMENT_PLAN]
(         
     @p_plan_cycle            NVARCHAR(150)          
    , @p_plan_start_yyyymmdd  NVARCHAR(8)          
    , @p_plan_id              NVARCHAR(4000)          
    , @p_modeling_id          NVARCHAR(4000)          
    , @p_seq                  NVARCHAR(4000)          
    , @p_plan_type            NVARCHAR(4000)          
    , @p_master_id            NVARCHAR(4000)          
    , @p_division_id          NVARCHAR(30)          
    , @p_engine_plan_id       NVARCHAR(4000)          
    , @p_user_id              NVARCHAR(150)  = 'scp_batch'          
    ---- , @p_debug       INT OUTPUT        
)         
AS        
  BEGIN        
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;        
    SET NOCOUNT ON;        
    SET XACT_ABORT ON;        
    SET ANSI_WARNINGS OFF;        
        
    -- LOG 용 변수 설정        
    DECLARE @v_batch_user   NVARCHAR(150) = N'scp_batch';          
    SET @v_batch_user = @p_user_id        
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_PLN_SHIPMENT_PLAN';        
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...        
    DECLARE @n_log_count    INTEGER = 0;        
    DECLARE @v_log_message  NVARCHAR(1000);        
    DECLARE @v_description  NVARCHAR(500);         
    DECLARE @v_table_id     NVARCHAR(150) = N'SCM_SYS_LOG_BATC';     
    DECLARE @d_event_date   DATETIME;        
        
  -- 시작 LOG        
    SET @v_log_type = N'START';        
    SET @v_log_message = N'########## Start of procedure ##########';        
    SET @v_description = @v_program_name + ':' + N' SHIPMENT_PLAN INSERT LOGIC';        
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
      
    BEGIN TRY        
      BEGIN        
        --BEGIN TRAN T1        

            -------------------------------------------------------------------------------------------------------------         
            -- 임시 TABLE 생성
            -------------------------------------------------------------------------------------------------------------         
        
              -------------------------------------------------------------------------------------------------------------         
          IF OBJECT_ID('tempdb..#tmp_SCP_PLN_SHIPMENT_PLAN') IS NOT NULL        
              DROP TABLE #tmp_SCP_PLN_SHIPMENT_PLAN        
        
            CREATE TABLE #tmp_SCP_PLN_SHIPMENT_PLAN(        
              MASTER_ID               nvarchar(50)    NOT NULL,                      
              PLAN_ID                 nvarchar(50)    NOT NULL,                      
              OUT_VERSION_ID          nvarchar(50)    NOT NULL,        
              DIVISION_ID             nvarchar(30)    NOT NULL,                      
              PLAN_START_YYYYMMDD     nvarchar(08)    NOT NULL,                      
              PLAN_TYPE               nvarchar(50)    NOT NULL,                      
              SEQ                     bigint          NOT NULL,        
                      
              OPERATION_GROUP         nvarchar(10)    NULL,                          
              PROJECT_CODE            nvarchar(50)    NULL,                          
              ITEM_ID                 nvarchar(50)    NULL,                      
              TO_SITE                 nvarchar(30)    NULL,                      
              INCOTERMS               nvarchar(10)    NULL,                      
              FROM_SITE               nvarchar(30)    NULL,                      
              BOD_ID                  nvarchar(150)   NULL,                      
              MEASURE                 nvarchar(50)    NULL, --         
              LPST                    datetime        NULL,        
              EPST                    datetime        NULL,        
              OPERATION_QTY           numeric(20, 10) NULL,                      
              ALLOCATION_QTY          numeric(20, 10) NULL,        
              COMPLETE_QTY            numeric(20, 10) NULL,        
              ORDER_ID                nvarchar(2000)  NULL, -- ENGINE        
              START_TIME              datetime        NULL,        
              END_TIME                datetime        NULL,        
              DEMAND_ID               nvarchar(1000)  NULL,   --         
              ORG_DEMAND_ID           nvarchar(1000)  NULL,   --         
              TRANSPORT_MODE          nvarchar(50)    NULL, --  POL/POD/DEST Leadtime을 위해 추가        
              DEMAND_TYPE             nvarchar(50)    NULL,        
              SEMI_YN                 nvarchar(1)     NULL,  
              ORIGIN_FROM_DIVISION_ID nvarchar(30)    NULL,        
              ORIGIN_TO_DIVISION_ID   nvarchar(30)    NULL,        
              ELECTRODE_TYPE          nvarchar(30)    NULL        
                      
            )        
        
                
            -------------------------------------------------------------------------------------------------------------         
            -- 0 #tmp_SCP_PLN_SHIPMENT_PLAN insert        
            -------------------------------------------------------------------------------------------------------------         
        
            INSERT INTO #tmp_SCP_PLN_SHIPMENT_PLAN        
            SELECT          
                   A.MASTER_ID             
                  ,A.PLAN_ID               
                  ,A.OUT_VERSION_ID        
                  ,A.DIVISION_ID        
                  ,A.PLAN_NAME                                    
                  ,A.PLAN_TYPE        
                  ,A.SEQ          
                  ,A.OPERATION_GROUP AS OPERATION_GROUP        
                  ,ISNULL(dbo.FN_SCM_SPLIT(A.DEMAND_ID, 2,'::'),'-') AS PROJECT_CODE        
                  ,A.ITEM_ID        
                  ,A.SCM_TO_SITE_ID  AS TO_SITE   
                  ,(CASE WHEN A.DEMAND_ID = 'UNPEGGING' THEN '-' ELSE (SUBSTRING(A.DEMAND_ID,(CASE WHEN CHARINDEX('~', A.DEMAND_ID) = 0  THEN 0 ELSE CHARINDEX('~', A.DEMAND_ID) +1 END),CHARINDEX('::',SUBSTRING(A.DEMAND_ID,(CHARINDEX('~', A.DEMAND_ID) +1),LEN(A.DEMAND_ID))) -1)) END)  AS INCOTERMS        
                  ,SCM_FROM_SITE_ID AS FROM_SITE   
                  ,A.BOD_ID AS BOD_ID          
                  ,NULL     AS MEASURE                            -- 출하요청        
                  ,A.LPST                                         -- 출하요청일자        
                  ,A.EPST                                         --         
                  ,ISNULL(A.OPERATION_QTY,0)  AS OPERATION_QTY    -- 생산투입수량        
                  ,ISNULL(A.ALLOCATION_QTY,0) AS ALLOCATION_QTY   -- 출하계획수량        
                  ,ISNULL(A.COMPLETE_QTY,0)   AS COMPLETE_QTY     -- 출하요청수량        
                  ,A.ORDER_ID        
                  ,A.START_TIME        
                  ,A.END_TIME        
                  ,A.DEMAND_ID         
                  ,A.ORG_DEMAND_ID         
                  ,(SELECT TOP 1 E.TRANSPORT_MODE        
                      FROM DBO.scp_mst_bod_n_v E  WITH (NOLOCK)    -- 20210707 PJ20209643 scp_mst_bod_v 에서 scp_mst_bod_n_v로 변경
                     WHERE E.DIVISION_ID = A.ORIGIN_FROM_DIVISION_ID       
                       AND E.BOD_ID      = A.BOD_ID ) AS TRANSPORT_MODE          
                  ,ISNULL(dbo.FN_SCM_SPLIT(A.DEMAND_ID, 6,'::'),'-') AS DEMAND_TYPE            
                  , A.ATTRIBUTE1 AS SEMI_YN      
                  , A.ORIGIN_FROM_DIVISION_ID  AS ORIGIN_FROM_DIVISION_ID  
                  , A.ORIGIN_TO_DIVISION_ID  AS ORIGIN_TO_DIVISION_ID  
                  , A.ELECTRODE_TYPE  
            FROM DBO.SCP_ENG_DELIVERY_O_TEMP_SN A WITH (NOLOCK)                 
                WHERE 0 = 0        
                   AND A.MASTER_ID        = @p_master_id            --  '81::WEEKLY'        
                   AND A.PLAN_ID          = @p_plan_id              --  '1020'         
                   AND A.PLAN_TYPE        = @p_plan_type            --  'PR'        
                   AND A.PLAN_NAME        = @p_plan_start_yyyymmdd  --  '20180402'        
                   AND A.DIVISION_ID      = @p_division_id          --  '81'        
                   AND A.SEQ              = @p_seq                  --  '11'        
                   AND A.ATTRIBUTE2       = 'S'  -- SP_Flag  
                             
            -------------------------------------------------------------------------------------------------------------         
            -- 1 SHIP_PLAN 생성후 SITE_TYPE,OSP_YN,FROM SITE_ID, TO SITE_ID 생성   
            -------------------------------------------------------------------------------------------------------------    
  
            SELECT           
                 A.MASTER_ID             
                ,A.PLAN_ID               
                ,A.OUT_VERSION_ID        
                ,A.DIVISION_ID        
                ,A.PLAN_START_YYYYMMDD                              
                ,A.PLAN_TYPE        
                ,A.SEQ          
                ,'-' AS PROJECT_CODE            
                ,A.ORDER_ID        
                ,'' AS ORG_DEMAND_ID        
                ,A.OPERATION_GROUP        
                ,A.ITEM_ID        
                ,A.FROM_SITE         
                ,A.TO_SITE        
                ,MAX(A.INCOTERMS) AS INCOTERMS    
                ,'SHIP_PLAN' AS MEASURE   -- 출하계획        
                ,CONVERT(NVARCHAR(8), A.START_TIME, 112) AS YYYYMMDD  -- 출하계획일자    
				
				-- 2021.02.26   KSW         ESS MOQ Lot Size별 출하로직(엔진 인바운드) 적용건에서 오류방지를 위한 선제적 조치 (ORDER ID 중복방지) -- start
                --,START_TIME        
                --,END_TIME 

				,MIN(START_TIME) AS START_TIME
				,MIN(END_TIME)   AS END_TIME
				-- 2021.02.26   KSW         ESS MOQ Lot Size별 출하로직(엔진 인바운드) 적용건에서 오류방지를 위한 선제적 조치 (ORDER ID 중복방지) -- end

                ,MAX(ISNULL(A.OPERATION_QTY,0)) AS OPERATION_QTY        
                ,MAX(ISNULL(A.COMPLETE_QTY,0)) AS COMPLETE_QTY        
                ,A.BOD_ID        
                ,A.TRANSPORT_MODE                            
                ,A.SEMI_YN        
                ,A.ORIGIN_FROM_DIVISION_ID  
                ,A.ORIGIN_TO_DIVISION_ID  
                ,A.ELECTRODE_TYPE  
                ,CONVERT(NVARCHAR(30), NULL)  AS ATTRIBUTE1   --TS.SITE_TYPE    
                ,CONVERT(NVARCHAR(30), NULL)  AS ATTRIBUTE2   --TS.OSP_YN      
                ,CONVERT(NVARCHAR(30), NULL)  AS ATTRIBUTE3   --TS.SITE_ID   -- TEMP 복사시에 컬럼타입을 int로 인식하는 경우가 있음.   
                ,CONVERT(NVARCHAR(30), NULL)  AS ATTRIBUTE4   --FS.SITE_ID     
            INTO #tmp_SCP_PLN_SHIPMENT_PLAN_SHIP_PLAN   
            FROM #tmp_SCP_PLN_SHIPMENT_PLAN A WITH (NOLOCK)        
            GROUP BY        
                 A.MASTER_ID             
                ,A.PLAN_ID               
                ,A.OUT_VERSION_ID        
                ,A.DIVISION_ID        
                ,A.PLAN_START_YYYYMMDD                              
                ,A.PLAN_TYPE        
                ,A.SEQ          
                ,A.ORDER_ID        
 
                ,A.OPERATION_GROUP        
                ,A.ITEM_ID        
                ,A.FROM_SITE         
                ,A.TO_SITE        
                ,CONVERT(NVARCHAR(8), A.START_TIME, 112)       
				
				-- 2021.02.26   KSW         ESS MOQ Lot Size별 출하로직(엔진 인바운드) 적용건에서 오류방지를 위한 선제적 조치 (ORDER ID 중복방지) -- start
                --,A.START_TIME        
                --,A.END_TIME        
				-- 2021.02.26   KSW         ESS MOQ Lot Size별 출하로직(엔진 인바운드) 적용건에서 오류방지를 위한 선제적 조치 (ORDER ID 중복방지) -- end

                ,A.BOD_ID        
                ,A.TRANSPORT_MODE             
                ,A.SEMI_YN              
                ,A.ORIGIN_FROM_DIVISION_ID  
                ,A.ORIGIN_TO_DIVISION_ID  
                ,A.ELECTRODE_TYPE     
      
    
            UPDATE X  
               SET X.ORIGIN_FROM_DIVISION_ID = Y.DIVISION_ID  
                  ,X.ATTRIBUTE4              = CONVERT(NVARCHAR(30), Y.SITE_ID)       --TS.SITE_ID     
              FROM #tmp_SCP_PLN_SHIPMENT_PLAN_SHIP_PLAN X WITH (NOLOCK) 
				   INNER JOIN SCM_MST_DIVISION AS DM WITH(NOLOCK) -- 2023.03.31 HM JV 가상 사업부 추가 대응
						   ON DM.DIVISION_ID = X.DIVISION_ID 
						  AND DM.VALID_YN	 = 'Y'
              INNER JOIN DBO.SCM_MST_SITE Y  WITH (NOLOCK)       -- from   PLANT_SITE_ID  
                      ON 0 = 0  
  --                   AND Y.SITE_TYPE   = 'PLANT'      
                     -- 2023.03.31 HM JV AND (CASE WHEN X.DIVISION_ID IN ('EE', 'EE_UC') THEN '0' ELSE X.DIVISION_ID END ) = (CASE WHEN X.DIVISION_ID IN ('EE', 'EE_UC') THEN '0' ELSE Y.DIVISION_ID END )  -- 2022.03.22 KSW GM JV 반영 -- EE_UC 추가
					 AND Y.DIVISION_ID  = CASE WHEN DM.ATTRIBUTE3 = 'EE' -- 2023.03.31 HM JV 가상 사업부 추가 대응
											   THEN Y.DIVISION_ID
											   ELSE X.DIVISION_ID
										   END 
                     AND Y.SCM_SITE_ID  = REPLACE(X.FROM_SITE,'-S','')  
                     AND Y.VALID_YN ='Y'     
  
            UPDATE X  
               SET X.ORIGIN_TO_DIVISION_ID  = Z.DIVISION_ID  
                  ,X.ATTRIBUTE1             = CONVERT(NVARCHAR(30),Z.SITE_TYPE)     --TS.SITE_TYPE  
                  ,X.ATTRIBUTE2             = CONVERT(NVARCHAR(30),Z.OSP_YN)        --TS.OSP_YN      
                  ,X.ATTRIBUTE3             = CONVERT(NVARCHAR(30),Z.SITE_ID)       --TS.SITE_ID     
              FROM #tmp_SCP_PLN_SHIPMENT_PLAN_SHIP_PLAN X WITH (NOLOCK)  
				   INNER JOIN SCM_MST_DIVISION AS DM WITH(NOLOCK) -- 2023.03.31 HM JV 가상 사업부 추가 대응
						   ON DM.DIVISION_ID = X.DIVISION_ID
						  AND DM.VALID_YN	 = 'Y'
              --INNER JOIN DBO.SCM_MST_SITE Z  WITH (NOLOCK)       -- to   SALES_SITE_ID  
                   INNER JOIN (SELECT MIN(DIVISION_ID) DIVISION_ID, SCM_SITE_ID, VALID_YN, MIN(SITE_TYPE) SITE_TYPE, MIN(OSP_YN) OSP_YN, MIN(SITE_ID) SITE_ID
				                    FROM   DBO.SCM_MST_SITE  WITH (NOLOCK)       -- to   SITE_ID
									WHERE  valid_yn = 'Y'
									GROUP BY SCM_SITE_ID, VALID_YN
								   ) Z
                      ON 0 = 0  
                    -- 2023.03.31 HM JV AND (CASE WHEN X.DIVISION_ID IN ('EE', 'EE_UC') THEN '0' ELSE X.DIVISION_ID END ) = (CASE WHEN X.DIVISION_ID IN ('EE', 'EE_UC') THEN '0' ELSE Z.DIVISION_ID END )   -- 2022.03.22 KSW GM JV 반영 -- EE_UC 추가
--                     AND Y.SITE_TYPE   = 'PLANT'      
					 AND Z.DIVISION_ID  = CASE WHEN DM.ATTRIBUTE3 = 'EE' -- 2023.03.31 HM JV 가상 사업부 추가 대응
											   THEN Z.DIVISION_ID
											   ELSE X.DIVISION_ID
										   END 
                     AND Z.SCM_SITE_ID  = REPLACE(X.TO_SITE,'-S','')  
                     AND Z.VALID_YN ='Y'             
  
  
            -------------------------------------------------------------------------------------------------------------         
            -- 2 SHIP_PLAN 입력         
            -------------------------------------------------------------------------------------------------------------         
        
            DELETE FROM dbo.SCP_PLN_SHIPMENT_PLAN          
            WHERE DIVISION_ID = @p_division_id AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND PLAN_TYPE = @p_plan_type AND SEQ = @p_seq        
  
            DELETE FROM dbo.SCP_PLN_SHIPMENT_PLAN_PEGGING        
            WHERE DIVISION_ID = @p_division_id AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND PLAN_TYPE = @p_plan_type AND SEQ = @p_seq        
        
        
            INSERT INTO dbo.SCP_PLN_SHIPMENT_PLAN        
            (        
               MASTER_ID             
              ,PLAN_ID               
              ,OUT_VERSION_ID        
              ,DIVISION_ID        
              ,PLAN_START_YYYYMMDD        
              ,PLAN_TYPE        
              ,SEQ        
              ,PROJECT_CODE      
              ,ORDER_ID        
              ,ORG_DEMAND_ID        
              ,OPERATION_GROUP        
              ,ITEM_ID        
              ,FROM_SITE         
              ,TO_SITE        
              ,INCOTERMS        
              ,MEASURE        
              ,YYYYMMDD        
              ,START_TIME        
              ,END_TIME        
              ,OPERATION_QTY        
             -- ,ALLOCATION_QTY        
              ,COMPLETE_QTY        
              ,BOD_ID        
              ,TRANSPORT_MODE        
              ,CREATED_BY        
              ,CREATION_DATE        
              ,LAST_UPDATED_BY        
              ,LAST_UPDATE_DATE        
              ,SEMI_YN    
              ,ORIGIN_FROM_DIVISION_ID  
              ,ORIGIN_TO_DIVISION_ID  
              ,ELECTRODE_TYPE  
              ,ATTRIBUTE1  
              ,ATTRIBUTE2  
              ,ATTRIBUTE3  
              ,ATTRIBUTE4  
            )              
  
  
             SELECT           
                 A.MASTER_ID             
                ,A.PLAN_ID               
                ,A.OUT_VERSION_ID        
                ,A.DIVISION_ID        
                ,A.PLAN_START_YYYYMMDD                              
                ,A.PLAN_TYPE        
                ,A.SEQ          
                ,A.PROJECT_CODE            
                ,A.ORDER_ID        
                ,A.ORG_DEMAND_ID        
                ,A.OPERATION_GROUP        
                ,A.ITEM_ID        
                ,A.FROM_SITE    
                ,A.TO_SITE        
                ,A.INCOTERMS    
                ,A.MEASURE     
                ,A.YYYYMMDD    
                ,A.START_TIME        
                ,A.END_TIME        
                ,A.OPERATION_QTY        
                ,A.COMPLETE_QTY        
                ,A.BOD_ID        
                ,A.TRANSPORT_MODE                            
                ,@v_batch_user AS CREATED_BY        
                ,GETDATE()     AS CREATION_DATE        
                ,@v_batch_user AS LAST_UPDATED_BY        
                ,GETDATE()     AS LAST_UPDATED_DATE        
                ,A.SEMI_YN        
                ,A.ORIGIN_FROM_DIVISION_ID  
                ,A.ORIGIN_TO_DIVISION_ID  
                ,A.ELECTRODE_TYPE  
                ,A.ATTRIBUTE1        --TS.SITE_TYPE  
                ,A.ATTRIBUTE2        --TS.OSP_YN      
                ,A.ATTRIBUTE3        --TS.SITE_ID     
                ,A.ATTRIBUTE4        --FS.SITE_ID     
            FROM #tmp_SCP_PLN_SHIPMENT_PLAN_SHIP_PLAN A WITH (NOLOCK)        

            -------------------------------------------------------------------------------------------------------------         
            -- 3 SHIP_REQ 입력         
            -------------------------------------------------------------------------------------------------------------        
    
            INSERT INTO dbo.SCP_PLN_SHIPMENT_PLAN        
            (        
               MASTER_ID             
              ,PLAN_ID               
              ,OUT_VERSION_ID        
              ,DIVISION_ID        
              ,PLAN_START_YYYYMMDD        
              ,PLAN_TYPE        
              ,SEQ        
              ,PROJECT_CODE      
              ,ORDER_ID        
--              ,ENG_DEMAND_ID    
              ,ORG_DEMAND_ID        
              ,OPERATION_GROUP        
              ,ITEM_ID        
              ,FROM_SITE         
              ,TO_SITE        
              ,INCOTERMS        
              ,MEASURE        
              ,YYYYMMDD        
              ,START_TIME        
              ,END_TIME        
             -- ,OPERATION_QTY        
              ,ALLOCATION_QTY        
             -- ,COMPLETE_QTY        
              ,BOD_ID        
      
              ,TRANSPORT_MODE        
              ,CREATED_BY        
              ,CREATION_DATE        
              ,LAST_UPDATED_BY        
              ,LAST_UPDATE_DATE        
              ,SEMI_YN      
              ,ORIGIN_FROM_DIVISION_ID  
              ,ORIGIN_TO_DIVISION_ID  
              ,ELECTRODE_TYPE   
            )                 
    
             SELECT         
                 A.MASTER_ID             
                ,A.PLAN_ID               
                ,A.OUT_VERSION_ID        
                ,A.DIVISION_ID        
                ,A.PLAN_START_YYYYMMDD                              
                ,A.PLAN_TYPE        
                ,A.SEQ          
                ,A.PROJECT_CODE      
                ,A.ORDER_ID        
                ,'' AS ORG_DEMAND_ID        
                ,A.OPERATION_GROUP        
                ,A.ITEM_ID        
                ,A.FROM_SITE         
                ,A.TO_SITE        
                ,MAX(A.INCOTERMS) AS INCOTERMS  
                ,'SHIP_REQ' AS MEASURE   -- 출하요청        
                ,CONVERT(NVARCHAR(8), A.LPST, 112) AS YYYYMMDD  -- 출하계획일자        
                ,MIN(START_TIME) AS START_TIME        
                ,MIN(END_TIME) AS END_TIME
                ,SUM(ISNULL(A.ALLOCATION_QTY,0))  AS ALLOCATION_QTY        
                ,A.BOD_ID        
                ,A.TRANSPORT_MODE                            
                ,@v_batch_user AS CREATED_BY        
                ,GETDATE()     AS CREATION_DATE        
                ,@v_batch_user AS LAST_UPDATED_BY        
                ,GETDATE()     AS LAST_UPDATED_DATE        
                ,A.SEMI_YN        
                ,A.ORIGIN_FROM_DIVISION_ID  
                ,A.ORIGIN_TO_DIVISION_ID  
                ,A.ELECTRODE_TYPE  
            FROM #tmp_SCP_PLN_SHIPMENT_PLAN A WITH (NOLOCK)        
            GROUP BY        
                 A.MASTER_ID             
                ,A.PLAN_ID               
                ,A.OUT_VERSION_ID        
                ,A.DIVISION_ID        
                ,A.PLAN_START_YYYYMMDD                              
                ,A.PLAN_TYPE        
                ,A.SEQ          
                ,A.PROJECT_CODE      
                ,A.ORDER_ID        
                ,A.OPERATION_GROUP        
                ,A.ITEM_ID        
                ,A.FROM_SITE         
                ,A.TO_SITE        
                ,CONVERT(NVARCHAR(8), A.LPST, 112)    
                --,START_TIME        
                --,END_TIME        
                ,A.BOD_ID        
                ,A.TRANSPORT_MODE                            
                ,A.SEMI_YN      
                ,A.ORIGIN_FROM_DIVISION_ID  
                ,A.ORIGIN_TO_DIVISION_ID  
                ,A.ELECTRODE_TYPE    
    
            -------------------------------------------------------------------------------------------------------------         
            -- 3 SCP_PLN_SHIPMENT_PLAN_PEGGING 입력         
            -------------------------------------------------------------------------------------------------------------     
    
           SELECT         
                 A.MASTER_ID             
                ,A.PLAN_ID               
                ,A.OUT_VERSION_ID        
                ,A.DIVISION_ID        
                ,A.PLAN_START_YYYYMMDD                              
                ,A.PLAN_TYPE        
                ,A.SEQ          
                ,A.PROJECT_CODE      
                ,A.ORDER_ID        
                ,A.DEMAND_ID    
                ,ISNULL(A.ORG_DEMAND_ID, '-') AS ORG_DEMAND_ID        
                ,A.OPERATION_GROUP        
                ,A.ITEM_ID        
                ,A.FROM_SITE         
                ,A.TO_SITE        
                ,MAX(A.INCOTERMS) AS INCOTERMS  
                ,'SHIP_REQ' AS MEASURE   -- 출하요청        
                ,CONVERT(NVARCHAR(8), A.LPST, 112) AS YYYYMMDD  -- 출하계획일자        
                ,MIN(START_TIME) AS START_TIME        
                ,MIN(END_TIME) AS END_TIME        
                ,SUM(ISNULL(A.ALLOCATION_QTY,0))  AS ALLOCATION_QTY        
                ,A.BOD_ID        
                ,A.TRANSPORT_MODE                  
                ,@v_batch_user AS CREATED_BY        
                ,GETDATE()     AS CREATION_DATE        
                ,@v_batch_user AS LAST_UPDATED_BY        
                ,GETDATE()     AS LAST_UPDATED_DATE        
                ,A.SEMI_YN        
                ,A.LPST    
                ,A.EPST    
            INTO #SCP_PLN_SHIPMENT_PLAN_SHIP_REQ      
            FROM #tmp_SCP_PLN_SHIPMENT_PLAN A WITH (NOLOCK)        
            GROUP BY        
                 A.MASTER_ID             
                ,A.PLAN_ID               
                ,A.OUT_VERSION_ID        
                ,A.DIVISION_ID        
                ,A.PLAN_START_YYYYMMDD                              
                ,A.PLAN_TYPE        
                ,A.SEQ          
                ,A.PROJECT_CODE      
                ,A.ORDER_ID        
                ,A.DEMAND_ID    
                ,ISNULL(A.ORG_DEMAND_ID, '-')     
                ,A.OPERATION_GROUP        
                ,A.ITEM_ID        
                ,A.FROM_SITE         
                ,A.TO_SITE        
                ,CONVERT(NVARCHAR(8), A.LPST, 112)   
                --,START_TIME        
                --,END_TIME        
                ,A.BOD_ID        
                ,A.TRANSPORT_MODE                            
                ,A.SEMI_YN        
                ,A.LPST    
                ,A.EPST    
    


                  
          INSERT INTO dbo.SCP_PLN_SHIPMENT_PLAN_PEGGING(        
                 MASTER_ID                  
                ,PLAN_ID                    
                ,OUT_VERSION_ID                           
                ,DIVISION_ID                
                ,PLAN_START_YYYYMMDD        
                ,PLAN_TYPE                  
                ,SEQ                        
                ,ORDER_ID                   
                ,PROJECT_CODE   
                ,ITEM_ID   
                ,ENG_DEMAND_ID                  
                ,INCOTERMS                  
                ,FCST_TYPE                  
                ,DOM_EXP                    
                ,ENG_DEMAND_PRIORITY        
                ,ALLOCATION_QTY         
                ,LPST      
                ,EPST          
                ,CREATED_BY                 
                ,CREATION_DATE              
                ,LAST_UPDATED_BY            
                ,LAST_UPDATE_DATE           
            )        
    
            SELECT            
                  A.MASTER_ID             
                 ,A.PLAN_ID               
                 ,A.OUT_VERSION_ID        
                 ,A.DIVISION_ID        
                 ,A.PLAN_START_YYYYMMDD                              
                 ,A.PLAN_TYPE        
                 ,A.SEQ          
                 ,A.ORDER_ID                   
                 ,A.PROJECT_CODE     
                 ,A.ITEM_ID 
                 ,A.DEMAND_ID        
                 ,(CASE WHEN (A.ORG_DEMAND_ID = 'UNPEGGING' OR A.ORG_DEMAND_ID ='') THEN '-' ELSE A.INCOTERMS END )  AS INCOTERMS     
                 ,MAX(ISNULL(dbo.FN_SCM_SPLIT(A.ORG_DEMAND_ID, 5,'::'),'-')) AS FCST_TYPE                             
                 ,MAX(ISNULL(dbo.FN_SCM_SPLIT(A.ORG_DEMAND_ID, 4,'::'),'-')) AS DOM_EXP -- MARKET_TYPE (D/E)                  
                 ,ISNULL((SELECT TOP 1 ISNULL(X.PRIORITY,'') AS PRIORITY       
                            FROM TH_ENG_NET_DEMAND_SN X   WITH (NOLOCK)    
                           WHERE X.MASTER_ID = A.MASTER_ID AND SUBSTRING(X.PLAN_ID,1,4) = A.PLAN_ID AND X.DEMAND_ID = A.ORG_DEMAND_ID),'-') AS ENG_DEMAND_PRIORITY      
                 ,SUM(ISNULL(A.ALLOCATION_QTY,0)) AS ALLOCATION_QTY          
                 ,A.LPST      
                 ,A.EPST              
                 ,@v_batch_user         AS CREATED_BY        
                 ,GETDATE()             AS CREATION_DATE        
                 ,@v_batch_user         AS LAST_UPDATED_BY        
                 ,GETDATE()             AS LAST_UPDATED_DATE        
              FROM #SCP_PLN_SHIPMENT_PLAN_SHIP_REQ A WITH (NOLOCK)                   
            WHERE 1=1        
                   AND A.MEASURE             ='SHIP_REQ'        
            GROUP BY        
                 A.MASTER_ID             
                ,A.PLAN_ID               
                ,A.OUT_VERSION_ID        
                ,A.DIVISION_ID        
                ,A.PLAN_START_YYYYMMDD                              
                ,A.PLAN_TYPE        
                ,A.SEQ          
                ,A.ORDER_ID              
                ,A.PROJECT_CODE     
                ,A.ITEM_ID      
                ,A.DEMAND_ID      
                ,A.ORG_DEMAND_ID                  
                ,(CASE WHEN (A.ORG_DEMAND_ID = 'UNPEGGING' OR A.ORG_DEMAND_ID ='') THEN '-' ELSE A.INCOTERMS END )       
                ,A.LPST    
                ,A.EPST      
                ,A.LPST      
                ,A.EPST     
                ;
    
        -----------------------------------------------------------        
        -- 실행 Logic END --        
        -----------------------------------------------------------        
        --IF @@TRANCOUNT > 0        
        --  BEGIN        
        --    COMMIT TRAN T1;        
        --  END;       
        
        -----------------------------------------------------------
        -- 임시테이블 삭제
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#tmp_SCP_PLN_SHIPMENT_PLAN') IS NOT NULL        
            DROP TABLE #tmp_SCP_PLN_SHIPMENT_PLAN        
        
        IF OBJECT_ID('tempdb..#tmp_SCP_PLN_SHIPMENT_PLAN_SHIP_PLAN') IS NOT NULL        
            DROP TABLE #tmp_SCP_PLN_SHIPMENT_PLAN_SHIP_PLAN        
        
        IF OBJECT_ID('tempdb..#SCP_PLN_SHIPMENT_PLAN_SHIP_REQ') IS NOT NULL        
            DROP TABLE #SCP_PLN_SHIPMENT_PLAN_SHIP_REQ  
        
        -- TXN LOG        
        SET @v_log_type = N'TXN';        
        SET @n_log_count = @@ROWCOUNT;        
        SET @v_log_message = N'INSERT INTO '+@v_table_id;        
        SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);        
        SET @d_event_date = SYSDATETIME();        
        
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
      --IF @@TRANCOUNT > 0        
      --  BEGIN        
      --    ROLLBACK TRAN T1        
      --  END;        
              
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

     -- 임시 운영반영시에 주석처리 할것.            
     SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +             
                          REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))             

        
    -- 종료 LOG        
    SET @v_log_type = N'END';        
    SET @v_log_message = N'########## END of procedure ##########';        
    SET @v_description  = N'[' + @p_master_id + ']['+@p_engine_plan_id+'][' + @v_exec_time + ']';  
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
    

