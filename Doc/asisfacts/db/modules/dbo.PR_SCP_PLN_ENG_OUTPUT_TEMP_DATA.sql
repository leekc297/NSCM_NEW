
/*        
 * Program ID   : PR_SCP_PLN_ENG_OUTPUT_TEMP_DATA          
 * Description  : PR_SCP_PLN_CREATE_DATA 에서 호출함.        
 * OutTable     :        
 * Execute      :   
 * Program History        
 *===================================================================================================        
 *   Date       In Charge      Description        
 *===================================================================================================        
 * 2018.07.06   KTH         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 
 * 2018.07.11   KTH         BOD_ID 추출 수정
 * 2018.07.18   KTH         FN_GET_SEMI_YN 파라미터 수정
 * 2018.07.23   KTH         SCP_ENG_DELIVERY_O_TEMP_SN 생성로직 수정
 * 2018.08.16   KTH         TCO_CELL 유무 FLAG ATTRIBUTE5에 추가
 * 2018.08.28   KTH         ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8 반영(FROM OSP_YN,TO OSP_YN, FROM TCO_CELL, TO TCO_CELL)
 * 2018.09.14   KTH         SCP_ENG_PEGGING_INFO_O_TEMP_SN (PLAN_DEPTH 컬럼 반영)
 * 2018.10.10   KTH         출하조건 반영 (A.ATTRIBUTE5 = 'Y')   -- 출하  FROM_OSP_YN = 'Y'
 * 2019.07.02   KTH         FN_GET_SEMI_YN 파라미터 수정( @p_from_division_id, @p_to_division_id 로 변경)
 * 2020.09.22   KSG         PR_SCP_PLN_ENG_OUTPUT_TEMP_DATA 통합 : 전체 주석 처리 후 LOG만 남김
 *                             PR_SCP_ENG_OUT_**** 에서 각자 처리함
 */                
         
CREATE PROCEDURE [dbo].[PR_SCP_PLN_ENG_OUTPUT_TEMP_DATA]        
(         
      @p_plan_cycle           NVARCHAR(150)          
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
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_PLN_ENG_OUTPUT_TEMP_DATA';        
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...        
    DECLARE @n_log_count    INTEGER = 0;        
    DECLARE @v_log_message  NVARCHAR(1000);        
    DECLARE @v_description  NVARCHAR(500);         
    DECLARE @v_table_id     NVARCHAR(150) = N'SCM_SYS_LOG_BATC';     
    DECLARE @d_event_date   DATETIME;        
        
  -- 시작 LOG        
    SET @v_log_type = N'START';        
    SET @v_log_message = N'########## Start of procedure ##########';        
    SET @v_description = @v_program_name + ':' + N' TEMP INSERT LOGIC';        
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

        ----------------------------------------------------------------------------------------------------------------
        -- 0. TEMP 생성(#temp_scp_eng_pegging_info_o_sn,#temp_scp_eng_unpegging_info_o_sn,#temp_scp_eng_work_order_o_sn)
        ----------------------------------------------------------------------------------------------------------------
        ----------------------------------------------------------------------------------------------------------------      
        -- 0.1. #temp_scp_eng_production_psi_o_sn 생성
        -----------------------------------------------------------------------------------------------------------------   
   /*       SELECT A.PLAN_ID
          ,A.MODELING_ID
          ,A.SEQ
          ,A.PLAN_NAME
          ,A.MASTER_ID
          ,A.OUT_VERSION_ID
          ,A.DIVISION_ID
          ,A.PLAN_TYPE
          ,A.SITE_ID
          ,A.ITEM_ID
          ,A.CATEGORY
          ,A.START_DATE
          ,A.QTY 
          ,NULL AS ORIGIN_DIVISION_ID
          ,B.ELECTRODE_TYPE
          ,B.OPERATION_GROUP
          ,SUBSTRING(A.SITE_ID,1,(CASE WHEN CHARINDEX('~', A.SITE_ID) = 0  THEN LEN(A.SITE_ID) ELSE CHARINDEX('~', A.SITE_ID)  -1 END))  AS SCM_SITE_ID
          ,A.ATTRIBUTE5   AS  ATTRIBUTE5    -- FROM OSP_YN
          ,B.TCO_CELL_YN  AS  ATTRIBUTE7    -- FROM TCO_CELL
          INTO #temp_scp_eng_production_psi_o_sn
          FROM SCP_ENG_PRODUCTION_PSI_O_SN A WITH (NOLOCK)  
          INNER JOIN SCP_MST_FINAL_ITEM_V AS B WITH(NOLOCK) 
                  ON  0 = 0
                  AND A.PLAN_ID         = @p_plan_id 
                  AND A.MODELING_ID     = @p_modeling_id
                  AND A.SEQ             = @p_seq
                  AND A.PLAN_NAME       = @p_plan_start_yyyymmdd
                  AND A.MASTER_ID       = @p_master_id    
                  AND A.OUT_VERSION_ID  = @p_engine_plan_id   
                  AND A.DIVISION_ID     = @p_division_id
                  AND A.PLAN_TYPE       = @p_plan_type                  
                  AND A.ITEM_ID         = B.item_id
          WHERE 1=1
            AND A.PLAN_ID         = @p_plan_id
            AND A.MODELING_ID     = @p_modeling_id
            AND A.SEQ             = @p_seq
            AND A.PLAN_NAME       = @p_plan_start_yyyymmdd
            AND A.MASTER_ID       = @p_master_id    
            AND A.OUT_VERSION_ID  = @p_engine_plan_id  
            AND A.DIVISION_ID     = @p_division_id
            AND A.PLAN_TYPE       = @p_plan_type     
            AND A.ITEM_ID         = B.item_id
	*/
    /*    
        ----------------------------------------------------------------------------------------------------------------      
        -- 0.2. #tmp_scp_eng_delivery_o_sn 생성
        -----------------------------------------------------------------------------------------------------------------  
          SELECT 
           A.PLAN_ID
          ,A.MODELING_ID
          ,A.SEQ
          ,A.PLAN_NAME
          ,A.MASTER_ID
          ,A.OUT_VERSION_ID
          ,A.DIVISION_ID
          ,A.PLAN_TYPE
          ,A.FROM_SITE_ID
          ,A.TO_SITE_ID
          ,A.ITEM_ID
          ,A.START_TIME
          ,A.ORDER_ID
          ,A.DEMAND_ID
          ,A.ORG_DEMAND_ID
          ,A.OPERATION_QTY
          ,A.COMPLETE_QTY
          ,A.ALLOCATION_QTY
          ,A.END_TIME
--          ,A.BOD_ID
          ,(CASE WHEN dbo.FN_SCM_SPLIT(A.BOD_ID, 2,'::') = 'x' THEN NULL ELSE dbo.FN_SCM_SPLIT(A.BOD_ID, 2,'::') END) AS BOD_ID
          ,A.FIX_TYPE
          ,A.DEMAND_TYPE
          ,ISNULL(A.LPST, A.EPST)  AS LPST
          ,ISNULL(A.EPST, A.LPST)  AS EPST
          ,NULL AS ORIGIN_FROM_DIVISION_ID
          ,NULL AS ORIGIN_TO_DIVISION_ID
          ,B.ELECTRODE_TYPE
          ,B.OPERATION_GROUP
          ,SUBSTRING(A.FROM_SITE_ID,1,(CASE WHEN CHARINDEX('~', A.FROM_SITE_ID) = 0  THEN LEN(A.FROM_SITE_ID) ELSE CHARINDEX('~', A.FROM_SITE_ID)  -1 END))  AS SCM_FROM_SITE_ID
          ,SUBSTRING(A.TO_SITE_ID,1,(CASE WHEN CHARINDEX('~', A.TO_SITE_ID) = 0  THEN LEN(A.TO_SITE_ID) ELSE CHARINDEX('~', A.TO_SITE_ID)  -1 END))  AS SCM_TO_SITE_ID
          ,A.ATTRIBUTE5   AS  ATTRIBUTE5     -- FROM OSP_YN
          ,A.ATTRIBUTE6   AS  ATTRIBUTE6     -- TO   OSP_YN
          ,B.TCO_CELL_YN  AS  ATTRIBUTE7     -- FROM TCO_CELL
          INTO #tmp_scp_eng_delivery_o_sn
          FROM SCP_ENG_DELIVERY_O_SN A WITH (NOLOCK) 
          INNER JOIN SCP_MST_FINAL_ITEM_V AS B WITH(NOLOCK) 
                  ON  0 = 0
                 AND A.PLAN_ID         = @p_plan_id 
                 AND A.MODELING_ID     = @p_modeling_id
                 AND A.SEQ             = @p_seq
                 AND A.PLAN_NAME       = @p_plan_start_yyyymmdd
                 AND A.MASTER_ID       = @p_master_id    
                 AND A.OUT_VERSION_ID  = @p_engine_plan_id   
                 AND A.DIVISION_ID     = @p_division_id
                 AND A.PLAN_TYPE       = @p_plan_type                  
                 AND A.ITEM_ID         = B.item_id
    */

        ----------------------------------------------------------------------------------------------------------------      
        -- 0.3. #temp_scp_eng_pegging_info_o_sn 생성
        -----------------------------------------------------------------------------------------------------------------   
       /*
        SELECT A.PLAN_ID
              ,A.MODELING_ID
              ,A.SEQ
              ,A.PLAN_NAME
              ,A.MASTER_ID
              ,A.OUT_VERSION_ID
              ,A.DEMAND_ID
              ,A.ORG_DEMAND_ID
              ,A.TRACK_SEQ
              ,A.DIVISION_ID
              ,A.PLAN_TYPE
              ,A.DEMAND_PRIORITY
              ,A.DUE_DATE
              ,A.PEGGING_TYPE
              ,A.BOD_ID
              ,A.ROUTE_ID
              ,A.QTY
              ,A.DELIVERY_ORDER_ID
              ,A.WORK_ORDER_ID
              ,A.STOCK_PLAN_LOT_ID
              ,A.START_DTTM
              ,A.END_DTTM
              ,NULL AS  ORIGIN_FROM_DIVISION_ID
              ,A.FROM_SITE_ID
              ,SUBSTRING(A.FROM_SITE_ID,1,(CASE WHEN CHARINDEX('~', A.FROM_SITE_ID) = 0  THEN LEN(A.FROM_SITE_ID) ELSE CHARINDEX('~', A.FROM_SITE_ID)  -1 END))  AS SCM_FROM_SITE_ID
              ,A.FROM_ITEM_ID
              ,NULL AS  ORIGIN_TO_DIVISION_ID
              ,A.TO_SITE_ID
              ,SUBSTRING(A.TO_SITE_ID,1,(CASE WHEN CHARINDEX('~', A.TO_SITE_ID) = 0  THEN LEN(A.TO_SITE_ID) ELSE CHARINDEX('~', A.TO_SITE_ID)  -1 END))  AS SCM_TO_SITE_ID
              ,A.TO_ITEM_ID
              ,A.TO_DELIVERY_ORDER_ID
              ,A.TO_WORK_ORDER_ID
              ,A.TO_REQUEST_QTY
              ,A.PLAN_DEPTH
              ,B.ELECTRODE_TYPE
              ,B.OPERATION_GROUP
              ,A.ATTRIBUTE1
              ,A.ATTRIBUTE2
              ,A.ATTRIBUTE3
              ,A.ATTRIBUTE4
              ,A.ATTRIBUTE5   AS  ATTRIBUTE5     -- FROM   OSP_YN
              ,A.ATTRIBUTE6   AS  ATTRIBUTE6     -- TO   OSP_YN
              ,B.TCO_CELL_YN  AS  ATTRIBUTE7     -- FROM TCO_CELL
              ,A.ATTRIBUTE8   AS  ATTRIBUTE8     -- TO   TCO_CELL
        INTO  #temp_scp_eng_pegging_info_o_sn
        FROM SCP_ENG_PEGGING_INFO_O_SN  AS A WITH(NOLOCK)
        INNER JOIN SCP_MST_FINAL_ITEM_V AS B WITH(NOLOCK) 
                ON  0 = 0
                AND A.PLAN_ID         = @p_plan_id 
                AND A.MODELING_ID     = @p_modeling_id
                AND A.SEQ             = @p_seq
                AND A.PLAN_NAME       = @p_plan_start_yyyymmdd
                AND A.MASTER_ID       = @p_master_id    
                AND A.OUT_VERSION_ID  = @p_engine_plan_id   
                AND A.DIVISION_ID     = @p_division_id
                AND A.PLAN_TYPE       = @p_plan_type                  
                AND A.FROM_ITEM_ID    = B.ITEM_ID
        WHERE 1=1
          AND A.PLAN_ID         = @p_plan_id
          AND A.MODELING_ID     = @p_modeling_id
          AND A.SEQ             = @p_seq
          AND A.PLAN_NAME       = @p_plan_start_yyyymmdd
          AND A.MASTER_ID       = @p_master_id    
          AND A.OUT_VERSION_ID  = @p_engine_plan_id  
          AND A.DIVISION_ID     = @p_division_id
          AND A.PLAN_TYPE       = @p_plan_type     
          AND A.FROM_ITEM_ID    = B.ITEM_ID
   */
        ----------------------------------------------------------------------------------------------------------------
        -- 0.4. #temp_scp_eng_unpegging_info_o_sn 생성
        ----------------------------------------------------------------------------------------------------------------
 /*
        SELECT A.PLAN_ID
              ,A.MODELING_ID
              ,A.SEQ
              ,A.PLAN_NAME
              ,A.MASTER_ID
              ,A.OUT_VERSION_ID
              ,A.DIVISION_ID
              ,A.PLAN_TYPE
              ,A.DELIVERY_ORDER_ID
              ,A.WORK_ORDER_ID
              ,A.BOD_ID
              ,A.ROUTE_ID
              ,A.SITE_ID
              ,A.ITEM_ID
              ,A.OPERATION_QTY
              ,A.COMPLETE_QTY
              ,A.START_DTTM
              ,A.END_DTTM
              ,A.FROM_SITE_ID
              ,NULL AS  ORIGIN_DIVISION_ID
              ,B.ELECTRODE_TYPE
              ,B.OPERATION_GROUP
              ,SUBSTRING(A.FROM_SITE_ID,1,(CASE WHEN CHARINDEX('~', A.FROM_SITE_ID) = 0  THEN LEN(A.FROM_SITE_ID) ELSE CHARINDEX('~', A.FROM_SITE_ID)  -1 END))   AS FROM_SCM_SITE_ID
              ,SUBSTRING(A.SITE_ID,1,(CASE WHEN CHARINDEX('~', A.SITE_ID) = 0  THEN LEN(A.SITE_ID) ELSE CHARINDEX('~', A.SITE_ID)  -1 END))   AS TO_SCM_SITE_ID
              ,A.ATTRIBUTE5    AS  ATTRIBUTE5      -- FROM OSP_YN
              ,A.ATTRIBUTE6    AS  ATTRIBUTE6      --   TO OSP_YN
              ,B.TCO_CELL_YN   AS  ATTRIBUTE8      --   TO TCO_CELL
        INTO #temp_scp_eng_unpegging_info_o_sn
        FROM SCP_ENG_UNPEGGING_INFO_O_SN AS A WITH(NOLOCK)
        INNER JOIN SCP_MST_FINAL_ITEM_V AS B WITH(NOLOCK) 
                ON  0 = 0
                AND A.PLAN_ID         = @p_plan_id 
                AND A.MODELING_ID     = @p_modeling_id
                AND A.SEQ             = @p_seq
                AND A.PLAN_NAME       = @p_plan_start_yyyymmdd
                AND A.MASTER_ID       = @p_master_id    
                AND A.OUT_VERSION_ID  = @p_engine_plan_id   
                AND A.DIVISION_ID     = @p_division_id
                AND A.PLAN_TYPE       = @p_plan_type                  
                AND A.ITEM_ID         = B.ITEM_ID
        WHERE 1=1
          AND A.PLAN_ID         = @p_plan_id
          AND A.MODELING_ID     = @p_modeling_id
          AND A.SEQ             = @p_seq
          AND A.PLAN_NAME       = @p_plan_start_yyyymmdd
          AND A.MASTER_ID       = @p_master_id    
          AND A.OUT_VERSION_ID  = @p_engine_plan_id  
          AND A.DIVISION_ID     = @p_division_id
          AND A.PLAN_TYPE       = @p_plan_type   
          AND A.ITEM_ID         = B.ITEM_ID
  */
        ----------------------------------------------------------------------------------------------------------------
        -- 0.5. #temp_scp_eng_work_order_o_sn 생성
        ----------------------------------------------------------------------------------------------------------------
 /*         SELECT A.PLAN_ID
            ,A.MODELING_ID
            ,A.SEQ
            ,A.PLAN_NAME
            ,A.MASTER_ID
            ,A.OUT_VERSION_ID
            ,A.WORK_ORDER_ID
            ,A.RESOURCE_ID
            ,A.DIVISION_ID
            ,A.PLAN_TYPE
            ,A.ITEM_ID
            ,A.SITE_ID
            ,A.ROUTE_ID
            ,A.OPERATION_ID
            ,A.START_TIME
            ,A.END_TIME
            ,A.OPERATION_TIME
            ,A.TOTAL_WORKING_TIME
            ,A.OPERATION_QTY
            ,A.COMPLETE_QTY
            ,A.BATCH_QTY
            ,A.LPST
            ,A.EPST
            ,NULL AS ORIGIN_DIVISION_ID
            ,B.ELECTRODE_TYPE
            ,B.OPERATION_GROUP
            ,SUBSTRING(A.SITE_ID,1,(CASE WHEN CHARINDEX('~', A.SITE_ID) = 0  THEN LEN(A.SITE_ID) ELSE CHARINDEX('~', A.SITE_ID)  -1 END))  AS SCM_SITE_ID
            ,A.ATTRIBUTE5       AS  ATTRIBUTE5     -- FROM OSP_YN
            ,B.TCO_CELL_YN      AS  ATTRIBUTE7     -- FROM TCO_CELL
        INTO #temp_scp_eng_work_order_o_sn
        FROM SCP_ENG_WORK_ORDER_O_SN AS A WITH(NOLOCK)
        INNER JOIN SCP_MST_FINAL_ITEM_V AS B WITH(NOLOCK) 
          ON  0 = 0
          AND A.PLAN_ID         = @p_plan_id 
          AND A.MODELING_ID     = @p_modeling_id
          AND A.SEQ             = @p_seq
          AND A.PLAN_NAME       = @p_plan_start_yyyymmdd
          AND A.MASTER_ID       = @p_master_id    
          AND A.OUT_VERSION_ID  = @p_engine_plan_id   
          AND A.DIVISION_ID     = @p_division_id
          AND A.PLAN_TYPE       = @p_plan_type                 
          AND A.ITEM_ID         = B.ITEM_ID
        WHERE 1=1
          AND A.PLAN_ID         = @p_plan_id
          AND A.MODELING_ID     = @p_modeling_id
          AND A.SEQ             = @p_seq
          AND A.PLAN_NAME       = @p_plan_start_yyyymmdd
          AND A.MASTER_ID       = @p_master_id    
          AND A.OUT_VERSION_ID  = @p_engine_plan_id  
          AND A.DIVISION_ID     = @p_division_id
          AND A.PLAN_TYPE       = @p_plan_type    
          AND A.ITEM_ID         = B.ITEM_ID
*/

        ----------------------------------------------------------------------------------------------------------------             
        -- 1.ORIGIN_FROM_DIVISION_ID,ORIGIN_TO_DIVISION_ID 반영
        ----------------------------------------------------------------------------------------------------------------
        ----------------------------------------------------------------------------------------------------------------             
        -- 1.1. #temp_scp_eng_production_psi_o_sn ORIGIN_DIVISION_ID 반영
        ----------------------------------------------------------------------------------------------------------------
  /*        UPDATE X
               SET X.ORIGIN_DIVISION_ID = Y.DIVISION_ID
                  ,X.ATTRIBUTE5         = Y.OSP_YN       --FROM OSP_YN
              FROM #temp_scp_eng_production_psi_o_sn X WITH (NOLOCK)
              INNER  JOIN DBO.SCM_MST_SITE Y  WITH (NOLOCK)       
                       ON 0 = 0 
                      AND (CASE WHEN X.DIVISION_ID = 'EE' THEN 0 ELSE X.DIVISION_ID END ) = (CASE WHEN X.DIVISION_ID = 'EE' THEN 0 ELSE Y.DIVISION_ID END )
                      AND Y.SCM_SITE_ID  = REPLACE(X.SCM_SITE_ID,'-S','')   -- 속도는?
                      AND Y.VALID_YN ='Y'   
*/
        ----------------------------------------------------------------------------------------------------------------              
        -- 1.2. #tmp_scp_eng_delivery_o_sn ORIGIN_FROM_DIVISION_ID,ORIGIN_TO_DIVISION_ID 반영
        ----------------------------------------------------------------------------------------------------------------
  /*          UPDATE X
               SET X.ORIGIN_FROM_DIVISION_ID = Y.DIVISION_ID
                  ,X.ATTRIBUTE5         = Y.OSP_YN       --FROM OSP_YN
              FROM #tmp_scp_eng_delivery_o_sn X WITH (NOLOCK)
              INNER JOIN DBO.SCM_MST_SITE Y  WITH (NOLOCK)       -- from   PLANT_SITE_ID
                      ON 0 = 0
                     AND (CASE WHEN X.DIVISION_ID = 'EE' THEN 0 ELSE X.DIVISION_ID END ) = (CASE WHEN X.DIVISION_ID = 'EE' THEN 0 ELSE Y.DIVISION_ID END )
                     AND Y.SCM_SITE_ID  = REPLACE(X.SCM_FROM_SITE_ID,'-S','') -- 속도는?
                     AND Y.VALID_YN ='Y'   

            UPDATE X
               SET X.ORIGIN_TO_DIVISION_ID  = Z.DIVISION_ID
               ,X.ATTRIBUTE6         = Z.OSP_YN       --TO   OSP_YN
              FROM #tmp_scp_eng_delivery_o_sn X WITH (NOLOCK)
              INNER JOIN DBO.SCM_MST_SITE Z  WITH (NOLOCK)       -- to   SALES_SITE_ID
                      ON 0 = 0  
                     AND (CASE WHEN X.DIVISION_ID = 'EE' THEN 0 ELSE X.DIVISION_ID END ) = (CASE WHEN X.DIVISION_ID = 'EE' THEN 0 ELSE Z.DIVISION_ID END )
                     AND Z.SCM_SITE_ID  = REPLACE(X.SCM_TO_SITE_ID,'-S','') -- 속도는?
                     AND Z.VALID_YN ='Y'    
	 */				 
        ----------------------------------------------------------------------------------------------------------------              
        -- 1.3. #temp_scp_eng_pegging_info_o_sn ORIGIN_FROM_DIVISION_ID,ORIGIN_TO_DIVISION_ID 반영
        ----------------------------------------------------------------------------------------------------------------
  /*          UPDATE X
               SET X.ORIGIN_FROM_DIVISION_ID = Y.DIVISION_ID
                  ,X.ATTRIBUTE4         = Y.SITE_ID      --TS.SITE_ID   
                  ,X.ATTRIBUTE5         = Y.OSP_YN       --FROM OSP_YN
              FROM #temp_scp_eng_pegging_info_o_sn X WITH (NOLOCK)
              INNER JOIN DBO.SCM_MST_SITE Y  WITH (NOLOCK)       -- from   PLANT_SITE_ID
                      ON 0 = 0
                     AND (CASE WHEN X.DIVISION_ID = 'EE' THEN 0 ELSE X.DIVISION_ID END ) = (CASE WHEN X.DIVISION_ID = 'EE' THEN 0 ELSE Y.DIVISION_ID END )
                     AND Y.SCM_SITE_ID  = REPLACE(X.SCM_FROM_SITE_ID,'-S','')
                     AND Y.VALID_YN ='Y'   

            UPDATE X
               SET X.ORIGIN_TO_DIVISION_ID  = Z.DIVISION_ID
                  ,X.ATTRIBUTE1             = Z.SITE_TYPE     --TS.SITE_TYPE
                  ,X.ATTRIBUTE2             = Z.OSP_YN        --TS.OSP_YN    
                  ,X.ATTRIBUTE3             = Z.SITE_ID       --TS.SITE_ID   
                  ,X.ATTRIBUTE6             = Z.OSP_YN        --TO OSP_YN
              FROM #temp_scp_eng_pegging_info_o_sn X WITH (NOLOCK)
              INNER JOIN DBO.SCM_MST_SITE Z  WITH (NOLOCK)       -- to   SALES_SITE_ID
                      ON 0 = 0
                    AND (CASE WHEN X.DIVISION_ID = 'EE' THEN 0 ELSE X.DIVISION_ID END ) = (CASE WHEN X.DIVISION_ID = 'EE' THEN 0 ELSE Z.DIVISION_ID END )
                     AND Z.SCM_SITE_ID  = REPLACE(X.SCM_TO_SITE_ID,'-S','')
                     AND Z.VALID_YN ='Y'         
                     
            UPDATE X
               SET X.ATTRIBUTE8         = B.TCO_CELL_YN   -- TO TCO_CELL
              FROM #temp_scp_eng_pegging_info_o_sn X WITH (NOLOCK)
               INNER JOIN SCP_MST_FINAL_ITEM_V AS B WITH(NOLOCK) 
                  ON  0 = 0
                  AND X.PLAN_ID         = @p_plan_id 
                  AND X.MODELING_ID     = @p_modeling_id
                  AND X.SEQ             = @p_seq
                  AND X.PLAN_NAME       = @p_plan_start_yyyymmdd
                  AND X.MASTER_ID       = @p_master_id    
                  AND X.OUT_VERSION_ID  = @p_engine_plan_id   
                  AND X.DIVISION_ID     = @p_division_id
                  AND X.PLAN_TYPE       = @p_plan_type                  
                  AND X.TO_ITEM_ID      = B.ITEM_ID
	*/
        ----------------------------------------------------------------------------------------------------------------             
        -- 1.4. #temp_scp_eng_unpegging_info_o_sn ORIGIN_DIVISION_ID 반영
        ----------------------------------------------------------------------------------------------------------------
            /*UPDATE X
               SET X.ORIGIN_DIVISION_ID = Y.DIVISION_ID
                  ,X.ATTRIBUTE5         = Y.OSP_YN       --FROM OSP_YN
              FROM #temp_scp_eng_unpegging_info_o_sn X WITH (NOLOCK)
              INNER  JOIN DBO.SCM_MST_SITE Y  WITH (NOLOCK)       
                       ON 0 = 0
                      AND (CASE WHEN X.DIVISION_ID = 'EE' THEN 0 ELSE X.DIVISION_ID END ) = (CASE WHEN X.DIVISION_ID = 'EE' THEN 0 ELSE Y.DIVISION_ID END )
                      AND Y.SCM_SITE_ID  = REPLACE(X.FROM_SCM_SITE_ID,'-S','')
                      AND Y.VALID_YN ='Y'  
                      
            UPDATE X
              SET X.ORIGIN_DIVISION_ID = Y.DIVISION_ID
                 ,X.ATTRIBUTE6         = Y.OSP_YN       --FROM OSP_YN
             FROM #temp_scp_eng_unpegging_info_o_sn X WITH (NOLOCK)
             INNER  JOIN DBO.SCM_MST_SITE Y  WITH (NOLOCK)       
                      ON 0 = 0 
                     AND (CASE WHEN X.DIVISION_ID = 'EE' THEN 0 ELSE X.DIVISION_ID END ) = (CASE WHEN X.DIVISION_ID = 'EE' THEN 0 ELSE Y.DIVISION_ID END )
                     AND Y.SCM_SITE_ID  = REPLACE(X.TO_SCM_SITE_ID,'-S','')
                     AND Y.VALID_YN ='Y'   
    */
        ----------------------------------------------------------------------------------------------------------------            
        -- 1.5. #temp_scp_eng_work_order_o_sn ORIGIN_DIVISION_ID 반영
        ----------------------------------------------------------------------------------------------------------------
    /*        UPDATE X
               SET X.ORIGIN_DIVISION_ID = Y.DIVISION_ID
                  ,X.ATTRIBUTE5         = Y.OSP_YN       --FROM OSP_YN
              FROM #temp_scp_eng_work_order_o_sn X WITH (NOLOCK)
              INNER  JOIN DBO.SCM_MST_SITE Y  WITH (NOLOCK)        
                       ON 0 = 0
                      AND (CASE WHEN X.DIVISION_ID = 'EE' THEN 0 ELSE X.DIVISION_ID END ) = (CASE WHEN X.DIVISION_ID = 'EE' THEN 0 ELSE Y.DIVISION_ID END )
                      AND Y.SCM_SITE_ID  = REPLACE(X.SCM_SITE_ID,'-S','')
                      AND Y.VALID_YN ='Y'   
	*/
        ----------------------------------------------------------------------------------------------------------------
        -- 2. ENG OUT -> OUT_TEMP 테이블 데이터 적재
        ----------------------------------------------------------------------------------------------------------------
          --DELETE FROM SCP_ENG_PRODUCTION_PSI_O_TEMP_SN  WHERE division_id = @p_division_id     --'81'
          --DELETE FROM SCP_ENG_DELIVERY_O_TEMP_SN        WHERE division_id = @p_division_id     --'81'
          --DELETE FROM SCP_ENG_PEGGING_INFO_O_TEMP_SN    WHERE division_id = @p_division_id     --'81'
          --DELETE FROM SCP_ENG_UNPEGGING_INFO_O_TEMP_SN  WHERE division_id = @p_division_id     --'81'
          --DELETE FROM SCP_ENG_WORK_ORDER_O_TEMP_SN      WHERE division_id = @p_division_id     --'81'
/*
          INSERT INTO SCP_ENG_PRODUCTION_PSI_O_TEMP_SN 
              (
                 PLAN_ID
                ,MODELING_ID
                ,SEQ
                ,PLAN_NAME
                ,MASTER_ID
                ,OUT_VERSION_ID
                ,DIVISION_ID
                ,PLAN_TYPE
                ,SITE_ID
                ,ITEM_ID
                ,CATEGORY
                ,START_DATE
                ,QTY
                ,ORIGIN_DIVISION_ID
                ,ELECTRODE_TYPE
                ,OPERATION_GROUP
                ,SCM_SITE_ID
                ,CREATED_BY
                ,CREATION_DATE
                ,LAST_UPDATED_BY
                ,LAST_UPDATE_DATE 
                ,ATTRIBUTE5    -- FROM OSP_YN
                ,ATTRIBUTE7    -- FROM TCO_CELL
              )

        SELECT A.PLAN_ID
              ,A.MODELING_ID
              ,A.SEQ
              ,A.PLAN_NAME
              ,A.MASTER_ID
              ,A.OUT_VERSION_ID
              ,A.DIVISION_ID
              ,A.PLAN_TYPE
              ,A.SITE_ID
              ,A.ITEM_ID
              ,A.CATEGORY
              ,A.START_DATE
              ,A.QTY 
              ,A.ORIGIN_DIVISION_ID
              ,ISNULL(A.ELECTRODE_TYPE,'')  AS ELECTRODE_TYPE
              ,ISNULL(A.OPERATION_GROUP,'') AS OPERATION_GROUP
              ,A.SCM_SITE_ID  
              ,@v_batch_user                AS CREATED_BY      
              ,GETDATE()                    AS CREATION_DATE      
              ,@v_batch_user                AS LAST_UPDATED_BY      
              ,GETDATE()                    AS LAST_UPDATED_DATE   
              ,ISNULL(A.ATTRIBUTE5 ,'')     AS ATTRIBUTE5         -- FROM OSP_YN
              ,ISNULL(A.ATTRIBUTE7 ,'')     AS ATTRIBUTE7         -- FROM TCO_CELL

           FROM #temp_scp_eng_production_psi_o_sn A WITH (NOLOCK)  
          WHERE 1=1
            AND A.PLAN_ID         = @p_plan_id
            AND A.MODELING_ID     = @p_modeling_id
            AND A.SEQ             = @p_seq
            AND A.PLAN_NAME       = @p_plan_start_yyyymmdd
            AND A.MASTER_ID       = @p_master_id    
            AND A.OUT_VERSION_ID  = @p_engine_plan_id  
            AND A.DIVISION_ID     = @p_division_id
            AND A.PLAN_TYPE       = @p_plan_type   
*/
/*
          INSERT INTO SCP_ENG_DELIVERY_O_TEMP_SN
              (
               PLAN_ID
              ,MODELING_ID
              ,SEQ
              ,PLAN_NAME
              ,MASTER_ID
              ,OUT_VERSION_ID
              ,DIVISION_ID
              ,PLAN_TYPE
              ,FROM_SITE_ID
              ,TO_SITE_ID
              ,ITEM_ID
              ,START_TIME
              ,ORDER_ID
              ,DEMAND_ID
              ,ORG_DEMAND_ID
              ,OPERATION_QTY
              ,COMPLETE_QTY
              ,ALLOCATION_QTY
              ,END_TIME
              ,BOD_ID
              ,FIX_TYPE
              ,DEMAND_TYPE
              ,LPST
              ,EPST
              ,ORIGIN_FROM_DIVISION_ID
              ,ORIGIN_TO_DIVISION_ID
              ,ELECTRODE_TYPE
              ,OPERATION_GROUP
              ,SCM_FROM_SITE_ID
              ,SCM_TO_SITE_ID
              ,CREATED_BY
              ,CREATION_DATE
              ,LAST_UPDATED_BY
              ,LAST_UPDATE_DATE 
              ,ATTRIBUTE1           -- SEMI_YN
              ,ATTRIBUTE2           -- SP_Flag
              ,ATTRIBUTE3           -- P_Flag 
              ,ATTRIBUTE5           -- FROM OSP_YN
              ,ATTRIBUTE6           -- TO OSP_YN     
              ,ATTRIBUTE7           -- FROM TCO_CELL     
              )
          SELECT 
               A.PLAN_ID
              ,A.MODELING_ID
              ,A.SEQ
              ,A.PLAN_NAME
              ,A.MASTER_ID
              ,A.OUT_VERSION_ID
              ,A.DIVISION_ID
              ,A.PLAN_TYPE
              ,A.FROM_SITE_ID
              ,A.TO_SITE_ID
              ,A.ITEM_ID
              ,A.START_TIME
              ,A.ORDER_ID
              ,A.DEMAND_ID
              ,A.ORG_DEMAND_ID
              ,A.OPERATION_QTY
              ,A.COMPLETE_QTY
              ,A.ALLOCATION_QTY
              ,A.END_TIME
              ,A.BOD_ID
              ,A.FIX_TYPE
              ,A.DEMAND_TYPE
              ,A.LPST
              ,A.EPST
              ,A.ORIGIN_FROM_DIVISION_ID
              ,A.ORIGIN_TO_DIVISION_ID
              ,ISNULL(A.ELECTRODE_TYPE ,'')  AS ELECTRODE_TYPE
              ,ISNULL(A.OPERATION_GROUP ,'') AS OPERATION_GROUP
              ,A.SCM_FROM_SITE_ID
              ,A.SCM_TO_SITE_ID
              ,@v_batch_user                 AS CREATED_BY      
              ,GETDATE()                     AS CREATION_DATE      
              ,@v_batch_user                 AS LAST_UPDATED_BY      
              ,GETDATE()                     AS LAST_UPDATED_DATE 
              ,ISNULL(dbo.FN_GET_SEMI_YN(A.ORIGIN_FROM_DIVISION_ID, A.SCM_FROM_SITE_ID, A.ORIGIN_TO_DIVISION_ID, A.SCM_TO_SITE_ID) ,'') AS ATTRIBUTE1  --SEMI_YN
              ,ISNULL((CASE  WHEN SUBSTRING(TO_SITE_ID,CHARINDEX('~', A.TO_SITE_ID)+1,3) NOT IN ('001','002','003') THEN 'S'  -- 출하
                             WHEN (A.ATTRIBUTE5 = 'Y' /* AND A.ATTRIBUTE7 ='Y'*/ )                                       THEN 'S'  -- 출하  FROM_OSP_YN <> 'N' , TCO_CELL_YN(FROM) ='Y'
--                             WHEN (A.FROM_SITE_ID LIKE '____-P%')                                                 THEN 'S'  -- 팩일 경우 무조건 출하
                             WHEN SUBSTRING(A.TO_SITE_ID,CHARINDEX('~', A.TO_SITE_ID)-1 ,6) IN ('A~001','A~002')    THEN 'P'  -- 생산 
                             ELSE '-' END) ,'') AS ATTRIBUTE2 --SP_Flag     -- 출하계획/생산계획구분  
              ,ISNULL(SUBSTRING(TO_SITE_ID,CHARINDEX('~', TO_SITE_ID)-1,6) ,'') AS ATTRIBUTE3 -- P_Flag
              ,ISNULL(A.ATTRIBUTE5 ,'')     AS ATTRIBUTE5   -- FROM OSP_YN
              ,ISNULL(A.ATTRIBUTE6 ,'')     AS ATTRIBUTE6   -- TO OSP_YN    
              ,ISNULL(A.ATTRIBUTE7 ,'')     AS ATTRIBUTE7   -- FROM TCO_CELL
          FROM #tmp_scp_eng_delivery_o_sn A WITH (NOLOCK) 
          WHERE 1=1
            AND A.PLAN_ID         = @p_plan_id
            AND A.MODELING_ID     = @p_modeling_id
            AND A.SEQ             = @p_seq
            AND A.PLAN_NAME       = @p_plan_start_yyyymmdd
            AND A.MASTER_ID       = @p_master_id    
            AND A.OUT_VERSION_ID  = @p_engine_plan_id  
            AND A.DIVISION_ID     = @p_division_id
            AND A.PLAN_TYPE       = @p_plan_type     
*/
/*
          INSERT INTO SCP_ENG_PEGGING_INFO_O_TEMP_SN
                (
                 PLAN_ID
                ,MODELING_ID
                ,SEQ
                ,PLAN_NAME
                ,MASTER_ID
                ,OUT_VERSION_ID
                ,DEMAND_ID
                ,ORG_DEMAND_ID
                ,TRACK_SEQ
                ,DIVISION_ID
                ,PLAN_TYPE
                ,DEMAND_PRIORITY
                ,DUE_DATE
                ,PEGGING_TYPE
                ,BOD_ID
                ,ROUTE_ID
                ,QTY
                ,DELIVERY_ORDER_ID
                ,WORK_ORDER_ID
                ,STOCK_PLAN_LOT_ID
                ,START_DTTM
                ,END_DTTM
                --,DEMAND_SITE_ID
                --,DEMAND_ITEM_ID
                ,ORIGIN_FROM_DIVISION_ID
                ,FROM_SITE_ID
                ,SCM_FROM_SITE_ID
                ,FROM_ITEM_ID
                ,ORIGIN_TO_DIVISION_ID
                ,TO_SITE_ID
                ,SCM_TO_SITE_ID
                ,TO_ITEM_ID
                ,TO_DELIVERY_ORDER_ID
                ,TO_WORK_ORDER_ID
                ,TO_REQUEST_QTY
                ,PLAN_DEPTH
--                ,PLAN_PATH
                ,ELECTRODE_TYPE
                ,OPERATION_GROUP
                ,CREATED_BY
                ,CREATION_DATE
                ,LAST_UPDATED_BY
                ,LAST_UPDATE_DATE            
                ,ATTRIBUTE1  --TS.SITE_TYPE
                ,ATTRIBUTE2  --TS.OSP_YN
                ,ATTRIBUTE3  --TS.SITE_ID
                ,ATTRIBUTE4  --FS.SITE_ID
                ,ATTRIBUTE5  -- FROM   OSP_YN
                ,ATTRIBUTE6  -- TO   OSP_YN
                ,ATTRIBUTE7  -- FROM TCO_CELL
                ,ATTRIBUTE8  -- TO   TCO_CELL
                )

          SELECT A.PLAN_ID
                ,A.MODELING_ID
                ,A.SEQ
                ,A.PLAN_NAME
                ,A.MASTER_ID
                ,A.OUT_VERSION_ID
                ,A.DEMAND_ID
                ,A.ORG_DEMAND_ID
                ,A.TRACK_SEQ
                ,A.DIVISION_ID
                ,A.PLAN_TYPE
                ,A.DEMAND_PRIORITY
                ,A.DUE_DATE
                ,A.PEGGING_TYPE
                ,A.BOD_ID
                ,A.ROUTE_ID
                ,A.QTY
                ,A.DELIVERY_ORDER_ID
                ,A.WORK_ORDER_ID
                ,A.STOCK_PLAN_LOT_ID
                ,A.START_DTTM
                ,A.END_DTTM
                ,A.ORIGIN_FROM_DIVISION_ID
                ,A.FROM_SITE_ID
                ,A.SCM_FROM_SITE_ID
                ,A.FROM_ITEM_ID
                ,A.ORIGIN_TO_DIVISION_ID
                ,A.TO_SITE_ID
                ,A.SCM_TO_SITE_ID
                ,A.TO_ITEM_ID
                ,A.TO_DELIVERY_ORDER_ID
                ,A.TO_WORK_ORDER_ID
                ,A.TO_REQUEST_QTY
                ,A.PLAN_DEPTH
--                ,A.PLAN_PATH
                ,ISNULL(A.ELECTRODE_TYPE ,'')  AS ELECTRODE_TYPE
                ,ISNULL(A.OPERATION_GROUP ,'') AS OPERATION_GROUP
                ,@v_batch_user                 AS CREATED_BY      
                ,GETDATE()                     AS CREATION_DATE      
                ,@v_batch_user                 AS LAST_UPDATED_BY      
                ,GETDATE()                     AS LAST_UPDATED_DATE   
                ,ISNULL(A.ATTRIBUTE1 ,'')      AS ATTRIBUTE1        --TS.SITE_TYPE
                ,ISNULL(A.ATTRIBUTE2 ,'')      AS ATTRIBUTE2        --TS.OSP_YN    
                ,ISNULL(A.ATTRIBUTE3 ,'')      AS ATTRIBUTE3        --TS.SITE_ID   
                ,ISNULL(A.ATTRIBUTE4 ,'')      AS ATTRIBUTE4        --FS.SITE_ID   
                ,ISNULL(A.ATTRIBUTE5 ,'')      AS ATTRIBUTE5        --FROM   OSP_YN
                ,ISNULL(A.ATTRIBUTE6 ,'')      AS ATTRIBUTE6        --TO   OSP_YN
                ,ISNULL(A.ATTRIBUTE7 ,'')      AS ATTRIBUTE7        --FROM TCO_CELL
                ,ISNULL(A.ATTRIBUTE8 ,'')      AS ATTRIBUTE8        --TO   TCO_CELL
          FROM #temp_scp_eng_pegging_info_o_sn  AS A WITH(NOLOCK)
          WHERE 1=1
            AND A.PLAN_ID         = @p_plan_id
            AND A.MODELING_ID     = @p_modeling_id
            AND A.SEQ             = @p_seq
            AND A.PLAN_NAME       = @p_plan_start_yyyymmdd
            AND A.MASTER_ID       = @p_master_id    
            AND A.OUT_VERSION_ID  = @p_engine_plan_id  
            AND A.DIVISION_ID     = @p_division_id
            AND A.PLAN_TYPE       = @p_plan_type     
	*/
	/*
          INSERT INTO SCP_ENG_UNPEGGING_INFO_O_TEMP_SN
              (
               PLAN_ID
              ,MODELING_ID
              ,SEQ
              ,PLAN_NAME
              ,MASTER_ID
              ,OUT_VERSION_ID
              ,DIVISION_ID
              ,PLAN_TYPE
              ,DELIVERY_ORDER_ID
              ,WORK_ORDER_ID
              ,BOD_ID
              ,ROUTE_ID
              ,SITE_ID
              ,ITEM_ID
              ,OPERATION_QTY
              ,COMPLETE_QTY
              ,START_DTTM
              ,END_DTTM
              ,FROM_SITE_ID
              ,ORIGIN_DIVISION_ID
              ,ELECTRODE_TYPE
              ,OPERATION_GROUP
              ,SCM_SITE_ID          --TO_SCM_SITE_ID
              ,CREATED_BY
              ,CREATION_DATE
              ,LAST_UPDATED_BY
              ,LAST_UPDATE_DATE
              ,ATTRIBUTE5
              ,ATTRIBUTE6
              ,ATTRIBUTE8
              ) 

          SELECT A.PLAN_ID
                ,A.MODELING_ID
                ,A.SEQ
                ,A.PLAN_NAME
                ,A.MASTER_ID
                ,A.OUT_VERSION_ID
                ,A.DIVISION_ID
                ,A.PLAN_TYPE
                ,A.DELIVERY_ORDER_ID
                ,A.WORK_ORDER_ID
                ,A.BOD_ID
                ,A.ROUTE_ID
                ,A.SITE_ID
                ,A.ITEM_ID
                ,A.OPERATION_QTY
                ,A.COMPLETE_QTY
                ,A.START_DTTM
                ,A.END_DTTM
                ,A.FROM_SITE_ID
                ,A.ORIGIN_DIVISION_ID
                ,ISNULL(A.ELECTRODE_TYPE ,'')  AS ELECTRODE_TYPE
                ,ISNULL(A.OPERATION_GROUP ,'') AS OPERATION_GROUP
                ,A.TO_SCM_SITE_ID
                ,@v_batch_user                 AS CREATED_BY      
                ,GETDATE()                     AS CREATION_DATE      
                ,@v_batch_user                 AS LAST_UPDATED_BY      
                ,GETDATE()                     AS LAST_UPDATED_DATE   
                ,ISNULL(A.ATTRIBUTE5 ,'')      AS ATTRIBUTE5        -- FROM OSP_YN
                ,ISNULL(A.ATTRIBUTE6 ,'')      AS ATTRIBUTE6        --   TO OSP_YN
                ,ISNULL(A.ATTRIBUTE8 ,'')      AS ATTRIBUTE8        --   TO TCO_CELL
          FROM #temp_scp_eng_unpegging_info_o_sn AS A WITH(NOLOCK)
          WHERE 1=1
            AND A.PLAN_ID         = @p_plan_id
            AND A.MODELING_ID     = @p_modeling_id
            AND A.SEQ             = @p_seq
            AND A.PLAN_NAME       = @p_plan_start_yyyymmdd
            AND A.MASTER_ID       = @p_master_id    
            AND A.OUT_VERSION_ID  = @p_engine_plan_id  
            AND A.DIVISION_ID     = @p_division_id
            AND A.PLAN_TYPE       = @p_plan_type   
 */
 /*
          INSERT INTO SCP_ENG_WORK_ORDER_O_TEMP_SN
          (
               PLAN_ID
              ,MODELING_ID
              ,SEQ
              ,PLAN_NAME
              ,MASTER_ID
              ,OUT_VERSION_ID
              ,WORK_ORDER_ID
              ,RESOURCE_ID
              ,DIVISION_ID
              ,PLAN_TYPE
              ,ITEM_ID
              ,SITE_ID
              ,ROUTE_ID
              ,OPERATION_ID
              ,START_TIME
              ,END_TIME
              ,OPERATION_TIME
              ,TOTAL_WORKING_TIME
              ,OPERATION_QTY
              ,COMPLETE_QTY
              ,BATCH_QTY
              ,LPST
              ,EPST
              ,ORIGIN_DIVISION_ID
              ,ELECTRODE_TYPE
              ,OPERATION_GROUP
              ,SCM_SITE_ID
              ,CREATED_BY
              ,CREATION_DATE
              ,LAST_UPDATED_BY
              ,LAST_UPDATE_DATE
              ,ATTRIBUTE5
              ,ATTRIBUTE7
          )

        SELECT A.PLAN_ID
              ,A.MODELING_ID
              ,A.SEQ
              ,A.PLAN_NAME
              ,A.MASTER_ID
              ,A.OUT_VERSION_ID
              ,A.WORK_ORDER_ID
              ,A.RESOURCE_ID
              ,A.DIVISION_ID
              ,A.PLAN_TYPE
              ,A.ITEM_ID
              ,A.SITE_ID
              ,A.ROUTE_ID
              ,A.OPERATION_ID
              ,A.START_TIME
              ,A.END_TIME
              ,A.OPERATION_TIME
              ,A.TOTAL_WORKING_TIME
              ,A.OPERATION_QTY
              ,A.COMPLETE_QTY
              ,A.BATCH_QTY
              ,A.LPST
              ,A.EPST
              ,A.ORIGIN_DIVISION_ID
              ,ISNULL(A.ELECTRODE_TYPE ,'')  AS ELECTRODE_TYPE
              ,ISNULL(A.OPERATION_GROUP ,'') AS OPERATION_GROUP
              ,A.SCM_SITE_ID
              ,@v_batch_user                 AS CREATED_BY      
              ,GETDATE()                     AS CREATION_DATE      
              ,@v_batch_user                 AS LAST_UPDATED_BY      
              ,GETDATE()                     AS LAST_UPDATED_DATE   
              ,ISNULL(A.ATTRIBUTE5 ,'')      AS ATTRIBUTE5           -- FROM OSP_YN
              ,ISNULL(A.ATTRIBUTE7 ,'')      AS ATTRIBUTE7           -- FROM TCO_CELL
          FROM #temp_scp_eng_work_order_o_sn AS A WITH(NOLOCK)
          WHERE 1=1
            AND A.PLAN_ID         = @p_plan_id
            AND A.MODELING_ID     = @p_modeling_id
            AND A.SEQ             = @p_seq
            AND A.PLAN_NAME       = @p_plan_start_yyyymmdd
            AND A.MASTER_ID       = @p_master_id    
            AND A.OUT_VERSION_ID  = @p_engine_plan_id  
            AND A.DIVISION_ID     = @p_division_id
            AND A.PLAN_TYPE       = @p_plan_type    
   */
        -----------------------------------------------------------        
        -- 실행 Logic END --        
        -----------------------------------------------------------        
        --IF @@TRANCOUNT > 0        
        --  BEGIN        
        --    COMMIT TRAN T1;        
        --  END;               
        
        
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
 

