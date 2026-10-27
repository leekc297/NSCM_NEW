CREATE PROCEDURE [dbo].[PR_SCM_MF_LANE_ROUTE_ENG]
   @p_master_id nvarchar(max) = '-',
   @p_plan_id nvarchar(max) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_MF_LANE_ROUTE_ENG                                                  **/
/** 프로그램 명   :                                                                           **/
/** 설 명         :                                                                           **/
/** Version       : 1.0.0                                                                     **/
/**                                                                                           **/
/** Argument                                                                                  **/
/**                                                                                           **/
/**  [검색 조건]                                                                              **/
/**                                                                                           **/
/** [Biz Logic]                                                                               **/
/**                                                                                           **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                                    **/
/**===========================================================================================**/
/** 2016.08.17    LJH          최초 작성                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_SCM_MF_LANE_ROUTE_ENG
  
  ITEM_ID 가 들어 있는 부분에 대해 변경작업 처리한다.

  TH_ENG_ITEM                     -- INSERT 
  TH_ENG_ITEM_CAL                 -- INSERT 
  TH_ENG_PLAN_BOM                 -- INSERT 
  TH_ENG_PLAN_BOM                             -- UPDATE 
  TH_ENG_PLAN_BOM_CAL                         -- UPDATE 
  TH_ENG_ITEM_ROUTE_SITE                      -- UPDATE 
  TH_ENG_OP_RES_GROUP                         -- UPDATE 
  TH_ENG_OP_RES_GROUP_CAL                     -- UPDATE 
  TH_ENG_OP_RES_GROUP_MAP                     -- UPDATE 
  TH_ENG_OP_RES_GROUP_MAP_CAL                 -- UPDATE 
  TH_ENG_PRODUCT_MIX_MAP                      -- UPDATE   
  TH_ENG_SALES_PRODUCT_MAP                    -- UPDATE   
  TH_ENG_SALES_PRODUCT_MAP_CAL                -- UPDATE   
  TH_ENG_FIXED_PLAN                           -- UPDATE 
  TH_ENG_STOCK_PLAN                           -- UPDATE
  TH_ENG_WIP                                  -- UPDATE
  
*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_master_id      nvarchar(30)
  DECLARE @v_plan_id        nvarchar(30)
  DECLARE @plan_start_time  datetime
  DECLARE @plan_end_time    datetime

  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_MF_LANE_ROUTE_ENG'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code        nvarchar(10)

  DECLARE @v_lane_master_id nvarchar(30)
  DECLARE @v_lane_plan_id   nvarchar(30)
  
  DECLARE @sysdate          DATETIME2 = GETDATE()

  DECLARE @v_temp1          nvarchar(1000)
  DECLARE @v_temp2          nvarchar(1000)
  
  SET @v_master_id  = @p_master_id
  SET @v_plan_id    = @p_plan_id
  
  SET @v_temp1 = 'S' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  SET @v_temp2 = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  
  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

  BEGIN TRY
    
    -- 필수 DATA 쿼리.. 반듯이 있어야 함.
    BEGIN
    
      --LOG 생성
      SET @v_table_name = 'TH_MST_PLAN'
      SELECT  @plan_start_time = PLAN_START_DTTM,
              @plan_end_time   = PLAN_END_DTTM
      FROM   (
              SELECT PLAN_START_DTTM,
                     CASE WHEN PLAN_HORIZON_UOM = 'DAY'   THEN DATEADD(DD, PLAN_HORIZON,     PLAN_START_DTTM)
                          WHEN PLAN_HORIZON_UOM = 'WEEK'  THEN DATEADD(DD, PLAN_HORIZON * 7, PLAN_START_DTTM)
                          WHEN PLAN_HORIZON_UOM = 'MONTH' THEN DATEADD(MM, PLAN_HORIZON ,    PLAN_START_DTTM)
                     END  PLAN_END_DTTM
              FROM   TH_MST_PLAN
              WHERE  MASTER_ID = @v_master_id
              AND    PLAN_ID = @v_plan_id
             ) A
             
             
      --LOG 생성
      SET @v_message = 'PST : ' + CONVERT(nvarchar, @plan_start_time, 112) + ' / PET : ' + CONVERT(nvarchar, @plan_end_time, 112)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
      
    END;
    
    BEGIN
      
      BEGIN
      
        SET @v_table_name = 'SY_FP_BUF_SCM_LANE_SITE'
        
        DELETE FROM SY_FP_BUF_SCM_LANE_SITE
        WHERE  MASTER_ID = @v_master_id
        AND    PLAN_ID = @v_plan_id
                
        INSERT INTO SY_FP_BUF_SCM_LANE_SITE
              (
               MASTER_ID
              ,PLAN_ID
              ,ITEM_ID
              ,SITE_ID
              ,ROUTE_ID
              ,OPERATION_ID
              ,OPERATION_SEQ
              ,ERP_OPERATION_ID
              ,LANE_QTY
              ,MAIN_LANE_QTY
              ,SUB_LANE_QTY
              ,LANE_TACT_QTY
              ,LANE_TACT_TIME
              ,NEW_ITEM_ID
              ,NEW_SITE_ID 
              ,NEW_ROUTE_ID
              ,NEW_OPERATION_ID
              ,SEQ
              )
        SELECT A.MASTER_ID
              ,A.PLAN_ID
              ,A.ITEM_ID
              ,A.SITE_ID
              ,A.ROUTE_ID
              ,A.OPERATION_ID
              ,A.OPERATION_SEQ
              ,A.ERP_OPERATION_ID
              ,A.LANE_QTY
              ,A.MAIN_LANE_QTY
              ,A.SUB_LANE_QTY
              ,A.LANE_TACT_QTY
              ,A.LANE_TACT_TIME
              ,A.ITEM_ID  + '_LANE' + CASE WHEN A.LANE_TACT_QTY < 10 THEN '0' ELSE '' END + CONVERT(nvarchar, A.LANE_TACT_QTY) AS NEW_ITEM_ID
              ,A.SITE_ID  + '_LANE' + CASE WHEN A.LANE_TACT_QTY < 10 THEN '0' ELSE '' END + CONVERT(nvarchar, A.LANE_TACT_QTY) AS NEW_SITE_ID 
              ,A.ROUTE_ID + '_LANE' + CASE WHEN A.LANE_TACT_QTY < 10 THEN '0' ELSE '' END + CONVERT(nvarchar, A.LANE_TACT_QTY) AS NEW_ROUTE_ID
              ,A.OPERATION_ID   AS NEW_OPERATION_ID
              ,DENSE_RANK() OVER (PARTITION BY A.MASTER_ID, A.PLAN_ID, A.ITEM_ID, A.SITE_ID, A.ROUTE_ID
                                  ORDER BY A.OPERATION_SEQ) SEQ
        FROM   (
                SELECT DISTINCT
                       A.MASTER_ID
                      ,A.PLAN_ID
                      ,A.ITEM_ID
                      ,A.FACTORY_ID AS SITE_ID
                      ,A.LINE_ID AS ROUTE_ID
                      ,B.OPERATION_ID
                      ,B.OPERATION_SEQ
                      ,B.ERP_OPERATION_ID
                      ,A.LANE_QTY
                      ,CASE WHEN B.ERP_OPERATION_ID = 'HS' THEN A.MAIN_LANE_QTY ELSE NULL END AS MAIN_LANE_QTY
                      ,CASE WHEN B.ERP_OPERATION_ID = 'HS' THEN A.SUB_LANE_QTY  ELSE NULL END AS SUB_LANE_QTY
                      ,CEILING(A.LANE_TACT_QTY) AS LANE_TACT_QTY
                      ,A.LANE_TACT_TIME
                FROM   TH_MST_ITEM_LANE A,
                       TH_MST_INSTANCE_FLOW B
                WHERE  A.MASTER_ID = @v_master_id
                AND    A.PLAN_ID = @v_plan_id
                AND    A.MASTER_ID = B.MASTER_ID
                AND    A.PLAN_ID = B.PLAN_ID
                AND    A.COMPANY_ID = B.COMPANY_ID
                AND    A.DIVISION_ID = B.DIVISION_ID
                AND    A.SITE_ID = B.SITE_ID
                AND    A.PLANT_ID = B.PLANT_ID
                AND    A.FACTORY_ID = B.FACTORY_ID
                AND    A.ITEM_ID = B.ITEM_ID
                AND    A.OPERATION_ID = B.OPERATION_ID
                UNION  ALL
                SELECT DISTINCT
                       A.MASTER_ID
                      ,A.PLAN_ID
                      ,A.ITEM_ID
                      ,A.FACTORY_ID AS SITE_ID
                      ,A.LINE_ID AS ROUTE_ID
                      ,B.OPERATION_ID
                      ,B.OPERATION_SEQ
                      ,B.ERP_OPERATION_ID
                      ,A.LANE_QTY
                      ,CASE WHEN B.ERP_OPERATION_ID = 'HS' THEN A.MAIN_LANE_QTY ELSE NULL END AS MAIN_LANE_QTY
                      ,CASE WHEN B.ERP_OPERATION_ID = 'HS' THEN A.SUB_LANE_QTY  ELSE NULL END AS SUB_LANE_QTY
                      ,CEILING(A.LANE_TACT_QTY) AS LANE_TACT_QTY
                      ,A.LANE_TACT_TIME
                FROM   TH_MST_ITEM_LANE A,
                       TH_MST_INSTANCE_FLOW B
                WHERE  A.MASTER_ID = @v_master_id
                AND    A.PLAN_ID = @v_plan_id
                AND    A.MASTER_ID = B.MASTER_ID
                AND    A.PLAN_ID = B.PLAN_ID
                AND    A.COMPANY_ID = B.COMPANY_ID
                AND    A.DIVISION_ID = B.DIVISION_ID
                AND    A.SITE_ID = B.SITE_ID
                AND    A.PLANT_ID = B.PLANT_ID
                AND    A.FACTORY_ID = B.FACTORY_ID
                AND    A.ITEM_ID = B.ITEM_ID + '_' + B.OPERATION_ID    -- E2300 모델링 적용부분  
                AND    A.OPERATION_ID = B.OPERATION_ID
               ) A
              
        /*
        SELECT A.MASTER_ID
              ,A.PLAN_ID
              ,A.ITEM_ID
              ,A.FACTORY_ID AS SITE_ID
              ,A.LINE_ID AS ROUTE_ID
              ,B.OPERATION_ID
              ,B.OPERATION_SEQ
              ,B.ERP_OPERATION_ID
              ,A.LANE_QTY
              ,A.ITEM_ID    + '_LANE' + CASE WHEN LANE_QTY < 10 THEN '0' ELSE '' END + CONVERT(nvarchar, LANE_QTY) AS NEW_ITEM_ID
              ,A.FACTORY_ID + '_LANE' + CASE WHEN LANE_QTY < 10 THEN '0' ELSE '' END + CONVERT(nvarchar, LANE_QTY) AS NEW_SITE_ID 
              ,A.LINE_ID    + '_LANE' + CASE WHEN LANE_QTY < 10 THEN '0' ELSE '' END + CONVERT(nvarchar, LANE_QTY) AS NEW_ROUTE_ID
              ,B.OPERATION_ID   AS NEW_OPERATION_ID
              ,DENSE_RANK() OVER (PARTITION BY A.MASTER_ID, A.PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.LINE_ID
                                  ORDER BY B.OPERATION_SEQ) SEQ
        FROM   (
                SELECT MASTER_ID, PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, LINE_ID, CONVERT(INT, MAX(LANE_QTY)) AS LANE_QTY 
                FROM   TH_MST_ITEM_LANE
                WHERE  MASTER_ID = @v_master_id
                AND    PLAN_ID = @v_plan_id
                GROUP  BY MASTER_ID, PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, LINE_ID
               ) A,
               TH_MST_INSTANCE_FLOW B
        WHERE  A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.COMPANY_ID = B.COMPANY_ID
        AND    A.DIVISION_ID = B.DIVISION_ID
        AND    A.SITE_ID = B.SITE_ID
        AND    A.PLANT_ID = B.PLANT_ID
        AND    A.ITEM_ID = B.ITEM_ID
        */

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END
      /*
      BEGIN
      
        SET @v_table_name = 'TH_ENG_ROUTE'

        INSERT INTO TH_ENG_ROUTE
        SELECT DISTINCT 
               A.MASTER_ID
              ,A.PLAN_ID
              ,B.NEW_ROUTE_ID
              ,A.ROUTE_LEVEL
              ,A.MIN_TAT
              ,A.AVG_TAT
              ,A.MAX_TAT
              ,A.TAT_UOM
              ,A.IS_EARLY_PRODUCING_BUCKET
              ,A.IS_PREV_EPST
              ,A.IS_FORWARD_BUCKET
              ,A.DESCR
        FROM   TH_ENG_ROUTE A,
               SY_FP_BUF_SCM_LANE_SITE B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.ROUTE_ID = B.ROUTE_ID

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END
      */
      /*
      -- BOD 가 BOM 보다 먼저 실행되어야 한다. BOM 은 등록 후 기존 데이터를 삭제하기 때문에      
      BEGIN
      
        SET @v_table_name = 'TH_ENG_BOD'

        INSERT INTO TH_ENG_BOD
              (
               MASTER_ID
              ,PLAN_ID
              ,BOD_ID
              ,FROM_SITE_ID
              ,TO_SITE_ID
              ,TRANSPORT_TIME
              ,TRANSPORT_TIME_UOM
              ,TRANSPORT_MODE
              ,BOD_START_DTTM
              ,BOD_PATTERN_ID
              ,FIXED_TERM
              ,FIXED_TERM_UOM
              )              
        SELECT DISTINCT
               A.MASTER_ID
              ,A.PLAN_ID
              ,B.SITE_ID +'_'+ B.NEW_SITE_ID AS BOD_ID
              ,B.SITE_ID    AS FROM_SITE_ID
              ,B.NEW_SITE_ID AS TO_SITE_ID
              ,0 AS TRANSPORT_TIME
              ,'MINUTE' AS TRANSPORT_TIME_UOM
              ,'-' AS TRANSPORT_MODE
              ,@plan_start_time AS BOD_START_DTTM
              ,'DX' AS BOD_PATTERN_ID
              ,0 AS FIXED_TERM
              ,'DAY' AS FIXED_TERM_UOM
        FROM   TH_ENG_PLAN_BOM A,
               SY_FP_BUF_SCM_LANE_SITE B,
               TH_ENG_ITEM C
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.PARENT_ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID
        AND    A.ROUTE_ID = B.ROUTE_ID
        AND    A.OPERATION_ID = B.OPERATION_ID
        AND    A.MASTER_ID = C.MASTER_ID
        AND    A.PLAN_ID = C.PLAN_ID
        AND    A.CHILD_ITEM_ID = C.ITEM_ID
        AND    C.ITEM_TYPE = 'H'
        UNION  ALL
        SELECT DISTINCT   -- 전극 후 공정 관련 부분
               A.MASTER_ID
              ,A.PLAN_ID
              ,C.NEW_SITE_ID +'_'+ B.SITE_ID AS BOD_ID
              ,C.NEW_SITE_ID AS FROM_SITE_ID
              ,B.SITE_ID AS TO_SITE_ID
              ,0 AS TRANSPORT_TIME
              ,'MINUTE' AS TRANSPORT_TIME_UOM
              ,'-' AS TRANSPORT_MODE
              ,@plan_start_time AS BOD_START_DTTM
              ,'DX' AS BOD_PATTERN_ID
              ,0 AS FIXED_TERM
              ,'DAY' AS FIXED_TERM_UOM
        FROM   TH_ENG_PLAN_BOM A,
               TH_ENG_PLAN_BOM B,
               SY_FP_BUF_SCM_LANE_SITE C
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.CHILD_ITEM_ID = B.PARENT_ITEM_ID
        AND    1=1
        AND    B.MASTER_ID = C.MASTER_ID
        AND    B.PLAN_ID = C.PLAN_ID
        AND    B.PARENT_ITEM_ID = C.ITEM_ID
        AND    B.SITE_ID = C.SITE_ID
        AND    B.ROUTE_ID = C.ROUTE_ID
        AND    B.OPERATION_ID = C.OPERATION_ID


        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END
      
      BEGIN
      
        SET @v_table_name = 'TH_ENG_ITEM_BOD'

        INSERT INTO TH_ENG_ITEM_BOD
              (
               MASTER_ID
              ,PLAN_ID
              ,BOD_ID
              ,ITEM_ID
              )              
        SELECT DISTINCT     -- 전극 전 공정 관련 부분
               A.MASTER_ID
              ,A.PLAN_ID
              ,B.SITE_ID +'_'+ B.NEW_SITE_ID AS BOD_ID
              ,A.CHILD_ITEM_ID AS ITEM_ID 
        FROM   TH_ENG_PLAN_BOM A,
               SY_FP_BUF_SCM_LANE_SITE B,
               TH_ENG_ITEM C
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.PARENT_ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID
        AND    A.ROUTE_ID = B.ROUTE_ID
        AND    A.OPERATION_ID = B.OPERATION_ID
        AND    A.MASTER_ID = C.MASTER_ID
        AND    A.PLAN_ID = C.PLAN_ID
        AND    A.CHILD_ITEM_ID = C.ITEM_ID
        AND    C.ITEM_TYPE = 'H'
        UNION  ALL
        SELECT DISTINCT   -- 전극 후 공정 관련 부분
               A.MASTER_ID
              ,A.PLAN_ID
              ,C.NEW_SITE_ID +'_'+ B.SITE_ID AS BOD_ID
              ,A.CHILD_ITEM_ID
        FROM   TH_ENG_PLAN_BOM A,
               TH_ENG_PLAN_BOM B,
               SY_FP_BUF_SCM_LANE_SITE C
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.CHILD_ITEM_ID = B.PARENT_ITEM_ID
        AND    1=1
        AND    B.MASTER_ID = C.MASTER_ID
        AND    B.PLAN_ID = C.PLAN_ID
        AND    B.PARENT_ITEM_ID = C.ITEM_ID
        AND    B.SITE_ID = C.SITE_ID
        AND    B.ROUTE_ID = C.ROUTE_ID
        AND    B.OPERATION_ID = C.OPERATION_ID
        

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END
      */
      
      BEGIN
      
        SET @v_table_name = 'TH_ENG_ITEM'

        INSERT INTO TH_ENG_ITEM
                (
                  MASTER_ID
                , PLAN_ID
                , ITEM_ID
                , ITEM_TYPE
                , ITEM_UOM
                , FLOW_ID
                , ITEM_GROUP_ID
                , SETUP_GROUP_ID
                , IS_FINITE
                , FINITE_TERM
                , FINITE_TERM_UOM
                , SAFETY_STOCK_QTY
                , MAX_STOCK_QTY
                , MIN_SAFETY_TERM
                , MIN_SAFETY_TERM_UOM
                , BUFFER_TIME
                , BUFFER_TIME_UOM
                , MIN_LOT_SIZE
                , MAX_LOT_SIZE
                , INCREMENT_LOT_SIZE
                , ATTRIBUTE_SET_ID
                , DESCR
                , ITEM_UOM_RATE
                )
        SELECT  DISTINCT
                  A.MASTER_ID
                , A.PLAN_ID
                , B.NEW_ITEM_ID AS ITEM_ID
                , 'H' ITEM_TYPE
                , A.ITEM_UOM
                , A.FLOW_ID
                , A.ITEM_GROUP_ID
                , A.SETUP_GROUP_ID
                , A.IS_FINITE
                --,'N'            AS IS_FINITE
                , A.FINITE_TERM
                , A.FINITE_TERM_UOM
                , A.SAFETY_STOCK_QTY
                , A.MAX_STOCK_QTY
                , A.MIN_SAFETY_TERM
                , A.MIN_SAFETY_TERM_UOM
                , A.BUFFER_TIME
                , A.BUFFER_TIME_UOM
                , A.MIN_LOT_SIZE
                , A.MAX_LOT_SIZE
                , A.INCREMENT_LOT_SIZE
                , A.ATTRIBUTE_SET_ID
                , A.DESCR
                , A.ITEM_UOM_RATE
        FROM    TH_ENG_ITEM A,
                SY_FP_BUF_SCM_LANE_SITE B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.MASTER_ID = B.MASTER_ID
        AND     A.PLAN_ID = B.PLAN_ID
        AND     A.ITEM_ID = B.ITEM_ID
        AND     B.SEQ = 1

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
/*
        DELETE  FROM A
        FROM    TH_ENG_ITEM A,
                SY_FP_BUF_SCM_LANE_SITE B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.MASTER_ID = B.MASTER_ID
        AND     A.PLAN_ID = B.PLAN_ID
        AND     A.ITEM_ID = B.ITEM_ID
        AND     B.SEQ = 1

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null
*/
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_ITEM_CAL'

        INSERT INTO TH_ENG_ITEM_CAL
                (
                  MASTER_ID
                , PLAN_ID
                , ITEM_ID
                , START_DTTM
                , END_DTTM
                , IS_USE
                , DESCR
                )
        SELECT    
                  A.MASTER_ID
                , A.PLAN_ID
                , B.NEW_ITEM_ID AS ITEM_ID
                , A.START_DTTM
                , A.END_DTTM
                , A.IS_USE
                , A.DESCR
        FROM    TH_ENG_ITEM_CAL A,
                SY_FP_BUF_SCM_LANE_SITE B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.MASTER_ID = B.MASTER_ID
        AND     A.PLAN_ID = B.PLAN_ID
        AND     A.ITEM_ID = B.ITEM_ID
        AND     B.SEQ = 1
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        DELETE  FROM A
        FROM    TH_ENG_ITEM_CAL A,
                SY_FP_BUF_SCM_LANE_SITE B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.MASTER_ID = B.MASTER_ID
        AND     A.PLAN_ID = B.PLAN_ID
        AND     A.ITEM_ID = B.ITEM_ID
        AND     B.SEQ = 1

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null
      
      END
      
      BEGIN
      
        SET @v_table_name = 'TH_ENG_PLAN_BOM'

        INSERT INTO TH_ENG_PLAN_BOM
        SELECT  DISTINCT
                  A.MASTER_ID
                , A.PLAN_ID
                , B.NEW_ITEM_ID AS PARENT_ITEM_ID
                , A.CHILD_ITEM_ID
                , A.SITE_ID
                , A.ROUTE_ID
                , A.OPERATION_ID
                , A.BINNING_ID
                , 'Y' PRODUCTION_FLAG
                , A.BOM_VERSION_ID
                , A.PARENT_ITEM_RATE
                , A.CHILD_ITEM_RATE
                , A.ALT_ID
                , A.ALT_PRIORITY
                , A.ALT_RATE
                , A.IN_MOVE_TIME
                , A.OUT_MOVE_TIME
                , A.MOVE_TIME_UOM
                , A.DESCR
        FROM   TH_ENG_PLAN_BOM A,
               SY_FP_BUF_SCM_LANE_SITE B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.PARENT_ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID
        AND    A.ROUTE_ID = B.ROUTE_ID
        AND    A.OPERATION_ID = B.OPERATION_ID

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        -- 1차 LANE 관련 모델링 부분처리
        UPDATE TH_ENG_PLAN_BOM
        SET    TH_ENG_PLAN_BOM.CHILD_ITEM_ID = B.NEW_ITEM_ID 
        FROM   TH_ENG_PLAN_BOM A,
               SY_FP_BUF_SCM_LANE_SITE B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.CHILD_ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID
        AND    A.ROUTE_ID = B.ROUTE_ID
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        DELETE FROM A        
        FROM   TH_ENG_PLAN_BOM A,
               SY_FP_BUF_SCM_LANE_SITE B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.PARENT_ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID
        AND    A.ROUTE_ID = B.ROUTE_ID
        AND    A.OPERATION_ID = B.OPERATION_ID
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null
      
        -- 2차 E2300 관련 모델링 부분 처리
        UPDATE TH_ENG_PLAN_BOM
        SET    TH_ENG_PLAN_BOM.CHILD_ITEM_ID = B.NEW_ITEM_ID 
        FROM   TH_ENG_PLAN_BOM A,
               SY_FP_BUF_SCM_LANE_SITE B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.CHILD_ITEM_ID = B.ITEM_ID
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

      END
      
      BEGIN
      
        SET @v_table_name = 'TH_ENG_ITEM_BOD'

        UPDATE TH_ENG_ITEM_BOD
        SET    TH_ENG_ITEM_BOD.ITEM_ID = C.NEW_ITEM_ID
        FROM   TH_ENG_ITEM_BOD A,
               TH_ENG_BOD B,
               SY_FP_BUF_SCM_LANE_SITE C
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.BOD_ID = B.BOD_ID
        AND    A.MASTER_ID = C.MASTER_ID
        AND    A.PLAN_ID = C.PLAN_ID
        AND    A.ITEM_ID = C.ITEM_ID
        AND    B.FROM_SITE_ID = C.SITE_ID
      
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_PLAN_BOM_CAL'

        INSERT INTO TH_ENG_PLAN_BOM_CAL
        SELECT  DISTINCT
                  A.MASTER_ID
                , A.PLAN_ID
                , B.NEW_ITEM_ID AS PARENT_ITEM_ID
                , A.CHILD_ITEM_ID
                , A.SITE_ID
                , A.ROUTE_ID
                , A.OPERATION_ID
                , A.BINNING_ID
                , A.PRODUCTION_FLAG
                , A.START_DTTM
                , A.END_DTTM
                , A.BOM_VERSION_ID
                , A.PARENT_ITEM_RATE
                , A.CHILD_ITEM_RATE
                , A.ALT_ID
                , A.ALT_PRIORITY
                , A.ALT_RATE
                , A.IN_MOVE_TIME
                , A.OUT_MOVE_TIME
                , A.MOVE_TIME_UOM
                , A.IS_USE
                , A.DESCR        
        FROM   TH_ENG_PLAN_BOM_CAL A,
               SY_FP_BUF_SCM_LANE_SITE B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.PARENT_ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID
        AND    A.ROUTE_ID = B.ROUTE_ID
        AND    A.OPERATION_ID = B.OPERATION_ID

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        DELETE FROM A        
        FROM   TH_ENG_PLAN_BOM_CAL A,
               SY_FP_BUF_SCM_LANE_SITE B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.PARENT_ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID
        AND    A.ROUTE_ID = B.ROUTE_ID
        AND    A.OPERATION_ID = B.OPERATION_ID
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null
      
      END

      BEGIN
      
        
        SET @v_table_name = 'TH_ENG_ITEM_ROUTE_SITE'

        INSERT INTO TH_ENG_ITEM_ROUTE_SITE        
        SELECT  DISTINCT
                  A.MASTER_ID
                , A.PLAN_ID
                , B.NEW_ITEM_ID AS ITEM_ID
                , A.SITE_ID
                , A.ROUTE_ID
                , A.ROUTE_LEVEL
                , A.OPERATION_ID
                , A.OPERATION_SEQ
                , A.FLOW_ID
                , A.MIN_TAT
                , A.AVG_TAT
                , A.MAX_TAT
                , A.TAT_UOM
                , A.YIELD
                , A.MIN_LOT_SIZE
                , A.MAX_LOT_SIZE
                , A.INCREMENT_LOT_SIZE
                , A.IN_MOVING_LOT_SIZE
                , A.OUT_MOVING_LOT_SIZE
                , A.IN_MOVE_TIME
                , A.OUT_MOVE_TIME
                , A.MOVE_TIME_UOM
                , A.EARLY_PRODUCING_TERM
                , A.EARLY_PRODUCING_TERM_UOM
                , A.OPERATION_TYPE
                , A.BUFFER_TIME
                , A.BUFFER_TIME_UOM
                , A.DESCR
                , A.TRANSFER_BATCH_SIZE        
        FROM   TH_ENG_ITEM_ROUTE_SITE A,
               SY_FP_BUF_SCM_LANE_SITE B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID
        AND    A.ROUTE_ID = B.ROUTE_ID
        AND    A.OPERATION_ID = B.OPERATION_ID

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        
        DELETE FROM A        
        FROM   TH_ENG_ITEM_ROUTE_SITE A,
               SY_FP_BUF_SCM_LANE_SITE B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID
        AND    A.ROUTE_ID = B.ROUTE_ID
        AND    A.OPERATION_ID = B.OPERATION_ID

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_OP_RES_GROUP'

        INSERT INTO TH_ENG_OP_RES_GROUP
        SELECT  DISTINCT
                  A.MASTER_ID
                , A.PLAN_ID
                , A.SITE_ID
                , A.ROUTE_ID
                , A.OPERATION_ID
                , B.NEW_ITEM_ID AS ITEM_ID
                , A.RESOURCE_MAP_ID
                , A.RESOURCE_MAP_LEVEL
                , B.LANE_TACT_TIME AS MIN_TACT_TIME
                , B.LANE_TACT_TIME AS AVG_TACT_TIME
                , B.LANE_TACT_TIME AS MAX_TACT_TIME
                , A.TACT_TIME_UOM
                , A.YIELD
                , A.RESOURCE_SELECTOR_ID
                , A.DESCR        
        FROM   TH_ENG_OP_RES_GROUP A,
               SY_FP_BUF_SCM_LANE_SITE B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID
        AND    A.ROUTE_ID = B.ROUTE_ID
        AND    A.OPERATION_ID = B.OPERATION_ID
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
        DELETE FROM A        
        FROM   TH_ENG_OP_RES_GROUP A,
               SY_FP_BUF_SCM_LANE_SITE B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID
        AND    A.ROUTE_ID = B.ROUTE_ID
        AND    A.OPERATION_ID = B.OPERATION_ID

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_OP_RES_GROUP_MAP'

        INSERT INTO TH_ENG_OP_RES_GROUP_MAP
        SELECT  DISTINCT
                  A.MASTER_ID
                , A.PLAN_ID
                , A.SITE_ID
                , A.ROUTE_ID
                , A.OPERATION_ID
                , B.NEW_ITEM_ID AS ITEM_ID
                , A.RESOURCE_MAP_ID
                , A.RESOURCE_GROUP_ID
                , A.SUB_RESOURCE_MAP_ID
                , A.RESOURCE_MAP_LEVEL
                , A.ALT_PRIORITY
                , B.LANE_TACT_TIME AS TACT_TIME
                , A.TACT_TIME_UOM
                , A.YIELD
                , A.IS_FIRST_SETUP
                , A.GOOD_RATE
                , A.BATCH_RATE
                , A.DESCR
                , A.CONSUME_RES_RATE
                , A.PREPARE_TIME
                , A.PREPARE_TIME_UOM        
        FROM   TH_ENG_OP_RES_GROUP_MAP A,
               SY_FP_BUF_SCM_LANE_SITE B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID
        AND    A.ROUTE_ID = B.ROUTE_ID
        AND    A.OPERATION_ID = B.OPERATION_ID
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
        DELETE FROM A        
        FROM   TH_ENG_OP_RES_GROUP_MAP A,
               SY_FP_BUF_SCM_LANE_SITE B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID
        AND    A.ROUTE_ID = B.ROUTE_ID
        AND    A.OPERATION_ID = B.OPERATION_ID

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_OP_RES_GROUP_CAL'

        INSERT INTO TH_ENG_OP_RES_GROUP_CAL        
        SELECT  DISTINCT
                  A.MASTER_ID
                , A.PLAN_ID
                , A.SITE_ID
                , A.ROUTE_ID
                , A.OPERATION_ID
                , B.NEW_ITEM_ID AS ITEM_ID
                , A.RESOURCE_MAP_ID
                , A.START_DTTM
                , A.END_DTTM
                , A.YIELD
                , A.RESOURCE_SELECTOR_ID
                , A.IS_USE
                , A.DESCR
        FROM   TH_ENG_OP_RES_GROUP_CAL A,
               SY_FP_BUF_SCM_LANE_SITE B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID
        AND    A.ROUTE_ID = B.ROUTE_ID
        AND    A.OPERATION_ID = B.OPERATION_ID
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
        DELETE FROM A        
        FROM   TH_ENG_OP_RES_GROUP_CAL A,
               SY_FP_BUF_SCM_LANE_SITE B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID
        AND    A.ROUTE_ID = B.ROUTE_ID
        AND    A.OPERATION_ID = B.OPERATION_ID

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_OP_RES_GROUP_MAP_CAL'

        INSERT INTO TH_ENG_OP_RES_GROUP_MAP_CAL  
        SELECT  DISTINCT
                  A.MASTER_ID
                , A.PLAN_ID
                , A.SITE_ID
                , A.ROUTE_ID
                , A.OPERATION_ID
                , B.NEW_ITEM_ID AS ITEM_ID
                , A.RESOURCE_MAP_ID
                , A.RESOURCE_GROUP_ID
                , A.START_DTTM
                , A.END_DTTM
                , A.SUB_RESOURCE_MAP_ID
                , A.RESOURCE_MAP_LEVEL
                , A.ALT_PRIORITY
                , B.LANE_TACT_TIME AS TACT_TIME
                , A.TACT_TIME_UOM
                , A.YIELD
                , A.GOOD_RATE
                , A.BATCH_RATE
                , A.IS_USE
                , A.DESCR
                , A.CONSUME_RES_RATE
                , A.PREPARE_TIME
                , A.PREPARE_TIME_UOM        
        FROM   TH_ENG_OP_RES_GROUP_MAP_CAL A,
               SY_FP_BUF_SCM_LANE_SITE B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID
        AND    A.ROUTE_ID = B.ROUTE_ID
        AND    A.OPERATION_ID = B.OPERATION_ID

        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
        DELETE FROM A        
        FROM   TH_ENG_OP_RES_GROUP_MAP_CAL A,
               SY_FP_BUF_SCM_LANE_SITE B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID
        AND    A.ROUTE_ID = B.ROUTE_ID
        AND    A.OPERATION_ID = B.OPERATION_ID

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_PRODUCT_MIX_MAP'

        INSERT INTO TH_ENG_PRODUCT_MIX_MAP
        SELECT  DISTINCT
                  A.MASTER_ID
                , A.PLAN_ID
                , A.SITE_ID
                , A.ROUTE_ID
                , A.OPERATION_ID
                , A.PRODUCT_MIX_ID
                , B.NEW_ITEM_ID AS ITEM_ID
                , A.DESCR
        FROM   TH_ENG_PRODUCT_MIX_MAP A,
               SY_FP_BUF_SCM_LANE_SITE B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID
        AND    A.ROUTE_ID = B.ROUTE_ID
        AND    A.OPERATION_ID = B.OPERATION_ID

        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
        DELETE FROM A        
        FROM   TH_ENG_PRODUCT_MIX_MAP A,
               SY_FP_BUF_SCM_LANE_SITE B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID
        AND    A.ROUTE_ID = B.ROUTE_ID
        AND    A.OPERATION_ID = B.OPERATION_ID

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_SALES_PRODUCT_MAP'

        INSERT INTO TH_ENG_SALES_PRODUCT_MAP          
        SELECT  DISTINCT
                  A.MASTER_ID
                , A.PLAN_ID
                , A.SALES_MODEL_ID
                , B.NEW_ITEM_ID AS PRODUCT_ITEM_ID
                , A.SITE_ID
                , A.ALT_PRIORITY
                , A.ALT_RATE
                , A.DESCR        
        FROM   TH_ENG_SALES_PRODUCT_MAP A,
               SY_FP_BUF_SCM_LANE_SITE B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.PRODUCT_ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID
        
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
        DELETE FROM A        
        FROM   TH_ENG_SALES_PRODUCT_MAP A,
               SY_FP_BUF_SCM_LANE_SITE B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.PRODUCT_ITEM_ID = B.ITEM_ID
        --AND    A.SITE_ID = B.SITE_ID

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_SALES_PRODUCT_MAP_CAL'

        INSERT INTO TH_ENG_SALES_PRODUCT_MAP_CAL  
        SELECT  DISTINCT
                  A.MASTER_ID
                , A.PLAN_ID
                , A.SALES_MODEL_ID
                , B.NEW_ITEM_ID AS PRODUCT_ITEM_ID
                , A.SITE_ID
                , A.START_DTTM
                , A.END_DTTM
                , A.ALT_PRIORITY
                , A.ALT_RATE
                , A.IS_USE
                , A.DESCR        
        FROM   TH_ENG_SALES_PRODUCT_MAP_CAL A,
               SY_FP_BUF_SCM_LANE_SITE B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.PRODUCT_ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID

        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
      
        DELETE FROM A        
        FROM   TH_ENG_SALES_PRODUCT_MAP_CAL A,
               SY_FP_BUF_SCM_LANE_SITE B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.PRODUCT_ITEM_ID = B.ITEM_ID
        --AND    A.SITE_ID = B.SITE_ID
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_FIXED_PLAN'

        /*
        INSERT INTO TH_ENG_FIXED_PLAN  
        SELECT  DISTINCT
                  A.MASTER_ID
                , A.PLAN_ID
                , A.WORK_ORDER_ID
                , A.WORK_ORDER_SEQ
                , A.SITE_ID
                , A.ROUTE_ID
                , A.OPERATION_ID
                , B.NEW_ITEM_ID AS ITEM_ID
                , A.RESOURCE_ID
                , A.SUB_RESOURCE_ID
                , A.START_DTTM
                , A.END_DTTM
                , A.OPERATION_QTY
                , A.COMPLETE_QTY
                , A.LOT_ID
                , A.IS_FIXED
                , A.IS_PREV_SCHEDULE
                , A.KEEP_WORK_TIME_TYPE
                , A.KEEP_QTY_TYPE
                , A.SALES_MODEL_ID
                , A.ATTRIBUTE_SET_ID
                , A.DEMAND_ID
                , A.DESCR
                , A.IS_NOH_CONSUME                
        FROM   TH_ENG_FIXED_PLAN A,
               SY_FP_BUF_SCM_LANE_SITE B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID
        AND    A.ROUTE_ID = B.ROUTE_ID
        AND    A.OPERATION_ID = B.OPERATION_ID

        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
        DELETE FROM A        
        FROM   TH_ENG_FIXED_PLAN A,
               SY_FP_BUF_SCM_LANE_SITE B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID
        AND    A.ROUTE_ID = B.ROUTE_ID
        AND    A.OPERATION_ID = B.OPERATION_ID
        */

        UPDATE TH_ENG_FIXED_PLAN
        SET    TH_ENG_FIXED_PLAN.ITEM_ID = B.NEW_ITEM_ID
        FROM   TH_ENG_FIXED_PLAN A,
               SY_FP_BUF_SCM_LANE_SITE B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID
        AND    A.ROUTE_ID = B.ROUTE_ID
        AND    A.OPERATION_ID = B.OPERATION_ID
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
        
      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_STOCK_PLAN'
        /*
        INSERT INTO TH_ENG_STOCK_PLAN  
        SELECT  DISTINCT
                  A.MASTER_ID
                , A.PLAN_ID
                , A.STOCK_SEQ
                , B.NEW_ITEM_ID AS ITEM_ID
                , A.SITE_ID
                , A.ROUTE_ID
                , A.OPERATION_ID
                , A.RECEIVING_DTTM
                , A.QTY
                , A.LOT_ID
                , A.WORK_ORDER_ID
                , A.DEMAND_ID
                , A.STOCK_STATUS
                , A.ATTRIBUTE_SET_ID
                , A.DESCR
        FROM   TH_ENG_STOCK_PLAN A,
               SY_FP_BUF_SCM_LANE_SITE B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID
        AND    A.ROUTE_ID = B.ROUTE_ID
        AND    A.OPERATION_ID = B.OPERATION_ID
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
        DELETE FROM A        
        FROM   TH_ENG_STOCK_PLAN A,
               SY_FP_BUF_SCM_LANE_SITE B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID
        AND    A.ROUTE_ID = B.ROUTE_ID
        AND    A.OPERATION_ID = B.OPERATION_ID
        */
        
        SET @v_table_name = 'TH_ENG_STOCK_PLAN - ROUTE_ID IS NOT NULL'

        UPDATE TH_ENG_STOCK_PLAN
        SET    TH_ENG_STOCK_PLAN.ITEM_ID = B.NEW_ITEM_ID
        FROM   TH_ENG_STOCK_PLAN A,
               SY_FP_BUF_SCM_LANE_SITE B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID
        AND    A.ROUTE_ID = B.ROUTE_ID          -- ROUTE 가 안맞아서 UPDATE 안되는 케이스 발생
        AND    A.OPERATION_ID = B.OPERATION_ID
        AND    CONVERT(INT, A.DESCR) = B.LANE_TACT_QTY
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null


        SET @v_table_name = 'TH_ENG_STOCK_PLAN - ROUTE_ID IS NULL'

        UPDATE TH_ENG_STOCK_PLAN
        SET    TH_ENG_STOCK_PLAN.ITEM_ID = B.NEW_ITEM_ID
        FROM   TH_ENG_STOCK_PLAN A,
               SY_FP_BUF_SCM_LANE_SITE B
        WHERE  A.MASTER_ID    = @v_master_id
        AND    A.PLAN_ID      = @v_plan_id
        AND    A.MASTER_ID    = B.MASTER_ID
        AND    A.PLAN_ID      = B.PLAN_ID
        AND    A.ITEM_ID      = B.ITEM_ID
        AND    A.SITE_ID      = B.SITE_ID
        AND    A.OPERATION_ID = B.OPERATION_ID
        AND    ISNULL(A.ROUTE_ID, '-')     = '-'
        AND    CONVERT(INT, A.DESCR) = B.LANE_TACT_QTY

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        SET @v_table_name = 'TH_ENG_STOCK_PLAN - ROUTE_ID IS NULL'

        UPDATE TH_ENG_STOCK_PLAN
        SET    TH_ENG_STOCK_PLAN.ITEM_ID = B.NEW_ITEM_ID
        FROM   TH_ENG_STOCK_PLAN A,
               SY_FP_BUF_SCM_LANE_SITE B
        WHERE  A.MASTER_ID    = @v_master_id
        AND    A.PLAN_ID      = @v_plan_id
        AND    A.MASTER_ID    = B.MASTER_ID
        AND    A.PLAN_ID      = B.PLAN_ID
        AND    A.ITEM_ID      = B.ITEM_ID
        AND    A.OPERATION_ID = B.OPERATION_ID
        AND    ISNULL(A.SITE_ID , '-')     = '-'
        AND    ISNULL(A.ROUTE_ID, '-')     = '-'
        AND    CONVERT(INT, A.DESCR) = B.LANE_TACT_QTY

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_WIP'

        /*
        INSERT INTO TH_ENG_WIP  
        SELECT  DISTINCT
                  A.MASTER_ID
                , A.PLAN_ID
                , A.WIP_SEQ
                , B.NEW_ITEM_ID AS ITEM_ID
                , A.ROUTE_ID
                , A.SITE_ID
                , A.OPERATION_ID
                , A.RESOURCE_ID
                , A.SUB_RESOURCE_ID
                , A.START_DTTM
                , A.END_DTTM
                , A.QTY
                , A.WORK_ORDER_ID
                , A.DEMAND_ID
                , A.LOT_ID
                , A.ATTRIBUTE_SET_ID
                , A.WIP_STATUS
                , A.RELEASE_DTTM
                , A.DESCR                                
        FROM   TH_ENG_WIP A,
               SY_FP_BUF_SCM_LANE_SITE B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID
        AND    A.ROUTE_ID = B.ROUTE_ID
        AND    A.OPERATION_ID = B.OPERATION_ID
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
        DELETE FROM A        
        FROM   TH_ENG_WIP A,
               SY_FP_BUF_SCM_LANE_SITE B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID
        AND    A.ROUTE_ID = B.ROUTE_ID
        AND    A.OPERATION_ID = B.OPERATION_ID
        */
        
        UPDATE TH_ENG_WIP
        SET    TH_ENG_WIP.ITEM_ID = B.NEW_ITEM_ID
        FROM   TH_ENG_WIP A,
               SY_FP_BUF_SCM_LANE_SITE B
        WHERE  A.MASTER_ID = @v_master_id
        AND    A.PLAN_ID = @v_plan_id
        AND    A.MASTER_ID = B.MASTER_ID
        AND    A.PLAN_ID = B.PLAN_ID
        AND    A.ITEM_ID = B.ITEM_ID
        AND    A.SITE_ID = B.SITE_ID
        AND    A.ROUTE_ID = B.ROUTE_ID
        AND    A.OPERATION_ID = B.OPERATION_ID
        
        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

      END

      BEGIN
      
        SET @v_table_name = 'TH_ENG_BATCH_INFO'


        INSERT INTO dbo.TH_ENG_BATCH_INFO
             (
              MASTER_ID,
              PLAN_ID,
              BATCH_RES_GROUP_ID,
              BATCH_GROUP_ID,
              ITEM_ID,
              MAX_BATCH_QTY,
              BATCH_TIME,
              BATCH_TIME_UOM,
              PREFER_RATIO,
              WAIT_TOLERANCE_TIME,
              WAIT_TOLERANCE_TIME_UOM,
              DESCR
             )
        SELECT DISTINCT 
              a.MASTER_ID,
              a.PLAN_ID,
              a.BATCH_RES_GROUP_ID,
              a.BATCH_GROUP_ID,
              B.NEW_ITEM_ID,
              a.MAX_BATCH_QTY,
              a.BATCH_TIME,
              a.BATCH_TIME_UOM,
              a.PREFER_RATIO,
              a.WAIT_TOLERANCE_TIME,
              a.WAIT_TOLERANCE_TIME_UOM,
              a.SITE_ID AS DESCR            
        FROM  TH_MST_BATCH_INFO A,
              SY_FP_BUF_SCM_LANE_SITE B
        WHERE A.MASTER_ID = @v_master_id
        AND   A.PLAN_ID = @v_plan_id
        AND   A.MASTER_ID = B.MASTER_ID
        AND   A.PLAN_ID = B.PLAN_ID
        AND   A.SITE_ID = B.SITE_ID
        AND   A.ITEM_ID = B.ITEM_ID

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        SET @n_row_count = @@ROWCOUNT
              
        DELETE FROM A
        FROM   TH_ENG_BATCH_INFO A,
               (
                SELECT DISTINCT
                       A.BATCH_RES_GROUP_ID,A.BATCH_GROUP_ID,A.ITEM_ID
                FROM   TH_MST_BATCH_INFO A,
                       SY_FP_BUF_SCM_LANE_SITE B
                WHERE  A.MASTER_ID = @v_master_id
                AND    A.PLAN_ID = @v_plan_id
                AND    A.MASTER_ID = B.MASTER_ID
                AND    A.PLAN_ID = B.PLAN_ID
                AND    A.SITE_ID = B.SITE_ID
                AND    A.ITEM_ID = B.ITEM_ID
               ) B
        WHERE   A.MASTER_ID = @v_master_id
        AND     A.PLAN_ID = @v_plan_id
        AND     A.BATCH_RES_GROUP_ID = B.BATCH_RES_GROUP_ID
        AND     A.BATCH_GROUP_ID = B.BATCH_GROUP_ID
        AND     A.ITEM_ID = B.ITEM_ID

        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

      END

      --------------------------------------------------------------------------------------------------------------------------------
      --------------------------------------------------------------------------------------------------------------------------------
      -- 전공정 자재 투입 제약
      --------------------------------------------------------------------------------------------------------------------------------
      --------------------------------------------------------------------------------------------------------------------------------

      DELETE FROM TH_BUF_SCM_LANE_BOM
      WHERE  MASTER_ID = @v_master_id
      AND    PLAN_ID = @v_plan_id
      
      
      IF CHARINDEX('POST', @v_master_id) > 0 --AND 1=0    -- 전공정 완성 -> 후공정 투입 모델링 주석처리
        BEGIN

          -- INSTANCE 간 연결을 끊는다...
          /*          
          SELECT @v_lane_master_id = A.INSTANCE_ID
                ,@v_lane_plan_id = MAX(A.PLAN_ID)
          FROM   SY_SCM_FP_PLAN_H A,
                 (
                  SELECT REPLACE(MASTER_ID, 'POST','PRE') AS MASTER_ID,
                         PLAN_START_DTTM
                  FROM   TH_MST_PLAN
                  WHERE  MASTER_ID = @v_master_id
                  and    PLAN_ID = @v_plan_id
                 ) B
          WHERE  1=1
          AND    A.INSTANCE_ID = B.MASTER_ID
          --AND    A.PLAN_START_TIME = B.PLAN_START_DTTM
          AND    A.PLAN_TYPE IN ('PRE','SYNC')
          AND    EXISTS (
                          SELECT 1
                          FROM   SY_FP_BUF_SCM_LANE_SITE X
                          WHERE  A.INSTANCE_ID = X.MASTER_ID
                          AND    A.PLAN_ID     = X.PLAN_ID
                        )
          GROUP  BY A.INSTANCE_ID
        
          SET @v_table_name = '----------------------'
          SET @v_message = ' LANE INSTANCE MODELING - PLAN_ID : ' + @v_lane_plan_id
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

        
          SET @v_table_name = 'TH_BUF_SCM_LANE_BOM'

          -- BOM 변경할 대상을 찾는다.
          INSERT INTO TH_BUF_SCM_LANE_BOM
          SELECT A.MASTER_ID,
                 A.PLAN_ID,
                 A.NEW_ITEM_ID    AS PARENT_ITEM_ID,
                 A.SITE_ID        AS PARENT_SITE_ID,
                 A.ROUTE_ID       AS PARENT_ROUTE_ID,
                 A.OPERATION_ID   AS PARENT_OPERATION_ID,
                 A.LANE_TACT_QTY  AS PARENT_LANE_QTY,
                 B.ITEM_ID        AS CHILD_ITEM_ID,
                 B.SITE_ID        AS CHILD_SITE_ID,
                 B.ROUTE_ID       AS CHILD_ROUTE_ID,
                 B.OPERATION_ID   AS CHILD_OPERATION_ID,
                 B.LANE_QTY       AS CHILD_LANE_QTY,
                 B.ITEM_ID 
                           + '_' + 'LANE' + CASE WHEN B.LANE_QTY < 10 THEN '0' ELSE '' END
                                           + CONVERT(NVARCHAR, CEILING(B.LANE_QTY))
                           + '_' + B.SITE_ID
                           + '_' + B.OPERATION_ID
                           + '_R'
                   AS NEW_CHILD_ITEM_ID,
                 C.BOD_ID
          FROM   (
                  SELECT *
                  FROM   (
                          SELECT A.*,
                                 DENSE_RANK() OVER (PARTITION BY ITEM_ID, SITE_ID ORDER BY OPERATION_SEQ) OP_SEQ
                          FROM   SY_FP_BUF_SCM_LANE_SITE A
                          WHERE  A.MASTER_ID = @v_master_id
                          AND    A.PLAN_ID   = @v_plan_id
                         ) A
                  WHERE  OP_SEQ = 1
                 ) A,
                 (
                  SELECT DISTINCT
                         MASTER_ID, PLAN_ID, ITEM_ID, SITE_ID, ROUTE_ID, OPERATION_ID, ERP_OPERATION_ID
                       , CASE WHEN R = 1 THEN ISNULL(MAIN_LANE_QTY, LANE_TACT_QTY)
                                         ELSE ISNULL(SUB_LANE_QTY,  LANE_TACT_QTY)
                         END  LANE_QTY
                  FROM   (
                          SELECT *
                          FROM   (
                                  SELECT A.*,
                                         DENSE_RANK() OVER (PARTITION BY ITEM_ID, SITE_ID ORDER BY OPERATION_SEQ DESC) OP_SEQ
                                  FROM   SY_FP_BUF_SCM_LANE_SITE A
                                  WHERE  A.MASTER_ID = @v_lane_master_id
                                  AND    A.PLAN_ID   = @v_lane_plan_id
                                 ) A
                          WHERE  OP_SEQ = 1
                         ) A,
                         (SELECT 1 R UNION ALL
                          SELECT 2 R ) B
                 ) B,
                 TH_MST_BOD C
          WHERE  A.ITEM_ID = B.ITEM_ID
          AND    A.MASTER_ID = C.MASTER_ID
          AND    A.PLAN_ID = C.PLAN_ID
          AND    A.SITE_ID = C.TO_SITE_ID
          AND    B.SITE_ID = C.FROM_SITE_ID
          AND    C.TRANSPORT_MODE = B.OPERATION_ID +'#' + A.OPERATION_ID
          AND    A.LANE_TACT_QTY >= B.LANE_QTY
          
          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
          */
          
          SET @v_table_name = '----------------------'
          SET @v_message = ' LANE INSTANCE MODELING Starting...'
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null


          SET @v_table_name = 'TH_BUF_SCM_LANE_BOM'

          -- BOM 변경할 대상을 찾는다.
          INSERT INTO TH_BUF_SCM_LANE_BOM
               (
                 MASTER_ID
               , PLAN_ID
               , PARENT_ITEM_ID
               , PARENT_SITE_ID
               , PARENT_ROUTE_ID
               , PARENT_OPERATION_ID
               , PARENT_LANE_QTY
               , CHILD_ITEM_ID
               , CHILD_SITE_ID
               , CHILD_ROUTE_ID
               , CHILD_OPERATION_ID
               , CHILD_LANE_QTY
               , NEW_CHILD_ITEM_ID
               , BOD_ID                 
               )
          SELECT A.MASTER_ID,
                 A.PLAN_ID,
                 A.NEW_ITEM_ID    AS PARENT_ITEM_ID,
                 A.SITE_ID        AS PARENT_SITE_ID,
                 A.ROUTE_ID       AS PARENT_ROUTE_ID,
                 A.OPERATION_ID   AS PARENT_OPERATION_ID,
                 A.LANE_TACT_QTY  AS PARENT_LANE_QTY,
                 B.ITEM_ID        AS CHILD_ITEM_ID,
                 B.SITE_ID        AS CHILD_SITE_ID,
                 B.ROUTE_ID       AS CHILD_ROUTE_ID,
                 B.OPERATION_ID   AS CHILD_OPERATION_ID,
                 B.LANE_QTY       AS CHILD_LANE_QTY,
                 B.ITEM_ID 
                           + '_' + 'LANE' + CASE WHEN B.LANE_QTY < 10 THEN '0' ELSE '' END
                                           + CONVERT(NVARCHAR, CEILING(B.LANE_QTY))
                           + '_' + B.SITE_ID
                           + '_' + B.OPERATION_ID
                           + '_R'
                   AS NEW_CHILD_ITEM_ID,
                 C.BOD_ID
          FROM   (
                  SELECT *
                  FROM   (
                          SELECT A.*,
                                 DENSE_RANK() OVER (PARTITION BY ITEM_ID, SITE_ID ORDER BY OPERATION_SEQ) OP_SEQ
                          FROM   SY_FP_BUF_SCM_LANE_SITE A
                          WHERE  A.MASTER_ID = @v_master_id
                          AND    A.PLAN_ID   = @v_plan_id
                         ) A
                  WHERE  OP_SEQ = 1
                 ) A,
                 (
                  SELECT *
                  FROM   (
                          SELECT DISTINCT
                                 ITEM_ID, FACTORY_ID AS SITE_ID, '-' ROUTE_ID, OPERATION_ID, ERP_OPERATION_ID
                               , CASE WHEN R = 1 THEN MAIN_LANE_QTY
                                                 ELSE SUB_LANE_QTY
                                 END  LANE_QTY
                          FROM   (
                                  SELECT A.ITEM_ID, A.FACTORY_ID, B.OPERATION_ID, B.ERP_OPERATION_ID
                                        , CASE WHEN A.MAIN_LANE_QTY IS NULL THEN 0 ELSE A.MAIN_LANE_QTY END MAIN_LANE_QTY
                                        , CASE WHEN A.SUB_LANE_QTY  IS NULL THEN 0 ELSE A.SUB_LANE_QTY  END SUB_LANE_QTY
                                  FROM   
                                          SY_SCM_ITEM_LANE_M A,
                                          SY_SCM_OPERATION_M B
                                  WHERE  A.COMPANY_ID     = B.COMPANY_ID
                                  AND    A.DIVISION_ID    = B.DIVISION_ID
                                  AND    A.SITE_ID        = B.SITE_ID
                                  AND    B.INSTANCE_TYPE  = 'E1'       -- 전극 전공정
                                  AND    A.ACTIVE_FLAG    = 'Y'
                                  AND    B.ACTIVE_FLAG    = 'Y'
                                  AND    B.OPERATION_ID   = (CASE WHEN A.HALF_SLIT_FLAG = 'Y' THEN 'E2500' 
                                                                                              ELSE 'E2000' 
                                                             END)
                                  AND    EXISTS (
                                                  SELECT 1
                                                  FROM   TH_MST_INSTANCE_FLOW X
                                                  WHERE  X.MASTER_ID    = @v_master_id
                                                  AND    X.PLAN_ID      = @v_plan_id
                                                  AND    X.COMPANY_ID   = A.COMPANY_ID
                                                  AND    X.DIVISION_ID  = A.DIVISION_ID
                                                  AND    X.SITE_ID      = A.SITE_ID
                                                  AND    X.FACTORY_ID   = A.FACTORY_ID
                                                  AND    X.ITEM_ID      = A.ITEM_ID
                                                )
                                 ) A,
                                 (SELECT 1 R UNION ALL
                                  SELECT 2 R ) B
                         ) A
                  WHERE  LANE_QTY > 0
                 ) B,
                 TH_MST_BOD C
          WHERE  A.ITEM_ID = B.ITEM_ID
          AND    A.MASTER_ID = C.MASTER_ID
          AND    A.PLAN_ID = C.PLAN_ID
          AND    A.SITE_ID = C.TO_SITE_ID
          AND    B.SITE_ID = C.FROM_SITE_ID
          AND    C.TRANSPORT_MODE = B.OPERATION_ID +'#' + A.OPERATION_ID
          AND    A.LANE_TACT_QTY >= B.LANE_QTY
          
          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
          

          BEGIN
          
            DELETE FROM A
            FROM   TH_BUF_SCM_LANE_BOM A,
                   (
                    SELECT PARENT_ITEM_ID, MIN(PARENT_OPERATION_ID) AS MIN_OPERATION_ID
                    FROM   TH_BUF_SCM_LANE_BOM
                    WHERE  MASTER_ID  = @v_master_id
                    AND    PLAN_ID    = @v_plan_id
                    GROUP  BY PARENT_ITEM_ID
                    HAVING MIN(PARENT_OPERATION_ID) <> MAX(PARENT_OPERATION_ID)
                   ) B
            WHERE  A.MASTER_ID  = @v_master_id
            AND    A.PLAN_ID    = @v_plan_id
            AND    A.PARENT_ITEM_ID       = B.PARENT_ITEM_ID
            AND    A.PARENT_OPERATION_ID  > MIN_OPERATION_ID
          
          END

          SET @v_table_name = 'TH_ENG_ITEM'
        
          INSERT INTO TH_ENG_ITEM
                (
                 MASTER_ID
                ,PLAN_ID
                ,ITEM_ID
                ,ITEM_TYPE
                ,FINITE_TERM
                ,FINITE_TERM_UOM
                )
          SELECT DISTINCT 
                 A.MASTER_ID
                ,A.PLAN_ID
                ,B.NEW_CHILD_ITEM_ID  AS ITEM_ID
                ,'H'                  AS ITEM_TYPE
                ,0                    AS FINITE_TERM
                ,'DAY'                AS FINITE_TERM_UOM
          FROM   TH_ENG_ITEM A, 
                 TH_BUF_SCM_LANE_BOM B
          WHERE  A.MASTER_ID = @v_master_id
          AND    A.PLAN_ID = @v_plan_id
          AND    A.MASTER_ID = B.MASTER_ID
          AND    A.PLAN_ID = B.PLAN_ID
          AND    A.ITEM_ID = B.CHILD_ITEM_ID
          UNION  ALL
          SELECT @v_master_id AS MASTER_ID
                ,@v_plan_id   AS PLAN_ID
                ,'DUMMY_LANE' AS ITEM_ID
                ,'R'          AS ITEM_TYPE
                ,0            AS FINITE_TERM          -- 나중에 자재 제약 설정하기 - 14일로
                ,'DAY'        AS FINITE_TERM_UOM 
                
          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

          SET @v_table_name = 'TH_ENG_ROUTE'

          INSERT INTO TH_ENG_ROUTE
                (
                 MASTER_ID
                ,PLAN_ID
                ,ROUTE_ID
                ,ROUTE_LEVEL
                )
          SELECT @v_master_id   AS MASTER_ID
                ,@v_plan_id     AS PLAN_ID
                ,'VIRTUAL_LANE' AS ROUTE_ID
                ,1              AS ROUTE_LEVEL
          
          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

          SET @v_table_name = 'TH_ENG_RESOURCE'
          
          
          INSERT INTO TH_ENG_RESOURCE
                (
                 MASTER_ID
                ,PLAN_ID
                ,RESOURCE_ID
                ,RESOURCE_TYPE
                ,SITE_ID
                ,ROUTE_ID
                ,MULTI_PORT_COUNT
                ,RESOURCE_GROUP_ID
                ,BATCH_TYPE
                )
          SELECT @v_master_id     AS MASTER_ID
                ,@v_plan_id       AS PLAN_ID
                ,'RES_LANE_DUMMY' AS RESOURCE_ID
                ,'MAIN'           AS RESOURCE_TYPE
                ,'VIRTUAL_LANE'   AS SITE_ID
                ,'VIRTUAL_LANE'   AS ROUTE_ID
                ,1                AS MULTI_PORT_COUNT
                ,'RES_LANE_DUMMY' AS RESOURCE_GROUP_ID
                ,'N'              AS BATCH_TYPE

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

          

          SET @v_table_name = 'TH_ENG_ITEM_ROUTE_SITE'

          INSERT INTO TH_ENG_ITEM_ROUTE_SITE
                (
                 MASTER_ID
                ,PLAN_ID
                ,ITEM_ID
                ,SITE_ID
                ,ROUTE_ID
                ,ROUTE_LEVEL
                ,OPERATION_ID
                ,OPERATION_SEQ
                ,YIELD
                ,EARLY_PRODUCING_TERM
                ,EARLY_PRODUCING_TERM_UOM
                ,OPERATION_TYPE
                )
          SELECT DISTINCT
                 A.MASTER_ID
                ,A.PLAN_ID
                ,A.NEW_CHILD_ITEM_ID  AS ITEM_ID
                ,'VIRTUAL_LANE'       AS SITE_ID
                ,'VIRTUAL_LANE'       AS ROUTE_ID
                ,1                    AS ROUTE_LEVEL
                ,A.CHILD_OPERATION_ID AS OPERATION_ID
                --,'VIRTUAL_LANE'       AS OPERATION_ID
                ,1                    AS OPERATION_SEQ
                ,1                    AS YIELD
                ,0                    AS EARLY_PRODUCING_TERM
                ,'DAY'                AS EARLY_PRODUCING_TERM_UOM
                ,'PULL'               AS OPERATION_TYPE
          FROM   TH_BUF_SCM_LANE_BOM A
          WHERE  A.MASTER_ID = @v_master_id
          AND    A.PLAN_ID = @v_plan_id

          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

          
          SET @v_table_name = 'TH_ENG_PLAN_BOM'

          INSERT INTO TH_ENG_PLAN_BOM
          SELECT  DISTINCT
                    A.MASTER_ID
                  , A.PLAN_ID
                  , A.PARENT_ITEM_ID
                  , B.NEW_CHILD_ITEM_ID AS CHILD_ITEM_ID
                  , A.SITE_ID
                  , A.ROUTE_ID
                  , A.OPERATION_ID
                  , A.BINNING_ID
                  , 'Y' PRODUCTION_FLAG
                  , A.BOM_VERSION_ID
                  , 1 PARENT_ITEM_RATE
                  , 1 CHILD_ITEM_RATE
                  , A.PARENT_ITEM_ID AS ITEM_ID
                  , 1 ALT_PRIORITY
                  , 1 ALT_RATE
                  , 0 IN_MOVE_TIME
                  , 0 OUT_MOVE_TIME
                  , 'MINUTE' MOVE_TIME_UOM
                  , A.DESCR
          FROM    TH_ENG_PLAN_BOM A,
                  TH_BUF_SCM_LANE_BOM B
          WHERE   A.MASTER_ID       = @v_master_id
          AND     A.PLAN_ID         = @v_plan_id
          AND     A.MASTER_ID       = B.MASTER_ID
          AND     A.PLAN_ID         = B.PLAN_ID
          AND     A.PARENT_ITEM_ID  = B.PARENT_ITEM_ID
          AND     A.SITE_ID         = B.PARENT_SITE_ID
          AND     A.ROUTE_ID        = B.PARENT_ROUTE_ID
          AND     A.OPERATION_ID    = B.PARENT_OPERATION_ID
          UNION   ALL
          SELECT  DISTINCT
                    A.MASTER_ID
                  , A.PLAN_ID
                  , B.NEW_CHILD_ITEM_ID   AS PARENT_ITEM_ID
                  , 'DUMMY_LANE'          AS CHILD_ITEM_ID
                  , 'VIRTUAL_LANE'        AS SITE_ID
                  , 'VIRTUAL_LANE'        AS ROUTE_ID
                  , B.CHILD_OPERATION_ID  AS OPERATION_ID
                  , A.BINNING_ID
                  , 'Y'                   AS PRODUCTION_FLAG
                  , '-'                   AS BOM_VERSION_ID
                  , 1                     AS PARENT_ITEM_RATE
                  , 1                     AS CHILD_ITEM_RATE
                  , NULL                  AS ALT_ID
                  , NULL                  AS ALT_PRIORITY
                  , NULL                  AS ALT_RATE
                  , 0                     AS IN_MOVE_TIME
                  , 0                     AS OUT_MOVE_TIME
                  , 'MINUTE'              AS MOVE_TIME_UOM
                  , A.DESCR
          FROM    TH_ENG_PLAN_BOM A,
                  TH_BUF_SCM_LANE_BOM B
          WHERE   A.MASTER_ID       = @v_master_id
          AND     A.PLAN_ID         = @v_plan_id
          AND     A.MASTER_ID       = B.MASTER_ID
          AND     A.PLAN_ID         = B.PLAN_ID
          AND     A.PARENT_ITEM_ID  = B.PARENT_ITEM_ID
          AND     A.SITE_ID         = B.PARENT_SITE_ID
          AND     A.ROUTE_ID        = B.PARENT_ROUTE_ID
          AND     A.OPERATION_ID    = B.PARENT_OPERATION_ID

          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
          

          SET @v_table_name = 'TH_ENG_OP_RES_GROUP'

          INSERT INTO TH_ENG_OP_RES_GROUP
                (
                 MASTER_ID
                ,PLAN_ID
                ,SITE_ID
                ,ROUTE_ID
                ,OPERATION_ID
                ,ITEM_ID
                ,RESOURCE_MAP_ID
                ,RESOURCE_MAP_LEVEL
                ,MIN_TACT_TIME
                ,AVG_TACT_TIME
                ,MAX_TACT_TIME
                ,TACT_TIME_UOM
                ,YIELD
                )
          SELECT DISTINCT
                 A.MASTER_ID
                ,A.PLAN_ID
                ,'VIRTUAL_LANE'       AS SITE_ID
                ,'VIRTUAL_LANE'       AS ROUTE_ID
                ,A.CHILD_OPERATION_ID AS OPERATION_ID
                ,A.NEW_CHILD_ITEM_ID  AS ITEM_ID
                ,A.NEW_CHILD_ITEM_ID +'_'+ 'VIRTUAL_LANE' AS RESOURCE_MAP_ID
                ,1                    AS RESOURCE_MAP_LEVEL
                ,0.0000000001         AS MIN_TACT_TIME
                ,0.0000000001         AS AVG_TACT_TIME
                ,0.0000000001         AS MAX_TACT_TIME
                ,'SECOND'             AS TACT_TIME_UOM
                ,1                    AS YIELD
          FROM   TH_BUF_SCM_LANE_BOM A
          WHERE  A.MASTER_ID = @v_master_id
          AND    A.PLAN_ID = @v_plan_id
          
          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        

          SET @v_table_name = 'TH_ENG_OP_RES_GROUP_MAP'

          INSERT INTO TH_ENG_OP_RES_GROUP_MAP
                (
                 MASTER_ID
                ,PLAN_ID
                ,SITE_ID
                ,ROUTE_ID
                ,OPERATION_ID
                ,ITEM_ID
                ,RESOURCE_MAP_ID
                ,RESOURCE_GROUP_ID
                ,TACT_TIME
                ,TACT_TIME_UOM
                ,YIELD
                ,ALT_PRIORITY
                ,PREPARE_TIME
                ,CONSUME_RES_RATE
                )
          SELECT DISTINCT
                 A.MASTER_ID
                ,A.PLAN_ID
                ,'VIRTUAL_LANE'       AS SITE_ID
                ,'VIRTUAL_LANE'       AS ROUTE_ID
                ,A.CHILD_OPERATION_ID AS OPERATION_ID
                ,A.NEW_CHILD_ITEM_ID  AS ITEM_ID
                ,A.NEW_CHILD_ITEM_ID +'_'+ 'VIRTUAL_LANE' AS RESOURCE_MAP_ID
                ,'RES_LANE_DUMMY'     AS RESOURCE_GROUP_ID
                ,0.0000000001         AS TACT_TIME
                ,'SECOND'             AS TACT_TIME_UOM
                ,1                    AS YIELD
                ,1                    AS ALT_PRIORITY
                ,NULL                 AS PREPARE_TIME
                ,1                    AS CONSUME_RES_RATE
          FROM   TH_BUF_SCM_LANE_BOM A
          WHERE  A.MASTER_ID = @v_master_id
          AND    A.PLAN_ID = @v_plan_id
          
          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

          SET @v_table_name = 'TH_ENG_BOD'

          INSERT INTO TH_ENG_BOD
                (
                  MASTER_ID
                 ,PLAN_ID
                 ,BOD_ID
                 ,FROM_SITE_ID
                 ,TO_SITE_ID
                 ,TRANSPORT_MODE
                 ,TRANSPORT_TIME
                 ,TRANSPORT_TIME_UOM
                 ,BOD_START_DTTM
                 ,BOD_PATTERN_ID
                 ,FIXED_TERM
                 ,FIXED_TERM_UOM                
                )
          SELECT  DISTINCT
                  A.MASTER_ID
                 ,A.PLAN_ID
                 ,'VIRTUAL_LANE' + '_' + A.CHILD_SITE_ID AS BOD_ID
                 ,'VIRTUAL_LANE'    AS FROM_SITE_ID
                 ,A.CHILD_SITE_ID   AS TO_SITE_ID
                 ,'-'               AS TRANSPORT_MODE
                 ,0                 AS TRANSPORT_TIME
                 ,'MINUTE'          AS TRANSPORT_TIME_UOM
                 ,@plan_start_time  AS BOD_START_DTTM
                 ,'DX'              AS BOD_PATTERN_ID
                 ,0                 AS FIXED_TERM
                 ,'DAY'             AS FIXED_TERM_UOM                 
          FROM    TH_BUF_SCM_LANE_BOM A
          WHERE   A.MASTER_ID = @v_master_id
          AND     A.PLAN_ID   = @v_plan_id
          
          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

          SET @v_table_name = 'TH_ENG_ITEM_BOD'

          INSERT INTO TH_ENG_ITEM_BOD
                (
                  MASTER_ID
                 ,PLAN_ID
                 ,BOD_ID
                 ,ITEM_ID
                 ,EARLY_PRODUCING_TERM
                )
          SELECT  DISTINCT
                  A.MASTER_ID
                 ,A.PLAN_ID
                 ,'VIRTUAL_LANE' + '_' + A.CHILD_SITE_ID BOD_ID
                 ,A.NEW_CHILD_ITEM_ID AS ITEM_ID
                 ,0 EARLY_PRODUCING_TERM
          FROM    TH_BUF_SCM_LANE_BOM A
          WHERE   A.MASTER_ID = @v_master_id
          AND     A.PLAN_ID   = @v_plan_id
        
          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
          
          SET @v_table_name = 'TH_ENG_PLAN_BOM'

          DELETE FROM A
          FROM   TH_ENG_PLAN_BOM A,
                 (
                  SELECT  A.PARENT_ITEM_ID, A.CHILD_ITEM_ID, A.SITE_ID, A.ROUTE_ID, A.OPERATION_ID
                  FROM    TH_ENG_PLAN_BOM A,
                          TH_BUF_SCM_LANE_BOM B
                  WHERE   A.MASTER_ID       = @v_master_id
                  AND     A.PLAN_ID         = @v_plan_id
                  AND     A.MASTER_ID       = B.MASTER_ID
                  AND     A.PLAN_ID         = B.PLAN_ID
                  AND     A.PARENT_ITEM_ID  = B.PARENT_ITEM_ID
                  AND     A.SITE_ID         = B.PARENT_SITE_ID
                  AND     A.ROUTE_ID        = B.PARENT_ROUTE_ID
                  AND     A.OPERATION_ID    = B.PARENT_OPERATION_ID
                  EXCEPT
                  SELECT  A.PARENT_ITEM_ID, A.CHILD_ITEM_ID, A.SITE_ID, A.ROUTE_ID, A.OPERATION_ID
                  FROM    TH_ENG_PLAN_BOM A,
                          TH_BUF_SCM_LANE_BOM B
                  WHERE   A.MASTER_ID       = @v_master_id
                  AND     A.PLAN_ID         = @v_plan_id
                  AND     A.MASTER_ID       = B.MASTER_ID
                  AND     A.PLAN_ID         = B.PLAN_ID
                  AND     A.PARENT_ITEM_ID  = B.PARENT_ITEM_ID
                  AND     A.SITE_ID         = B.PARENT_SITE_ID
                  AND     A.ROUTE_ID        = B.PARENT_ROUTE_ID
                  AND     A.OPERATION_ID    = B.PARENT_OPERATION_ID
                  AND     A.CHILD_ITEM_ID   = B.NEW_CHILD_ITEM_ID
                 ) B
          WHERE   A.MASTER_ID       = @v_master_id
          AND     A.PLAN_ID         = @v_plan_id
          AND     A.PARENT_ITEM_ID  = B.PARENT_ITEM_ID
          AND     A.CHILD_ITEM_ID   = B.CHILD_ITEM_ID
          AND     A.SITE_ID         = B.SITE_ID
          AND     A.ROUTE_ID        = B.ROUTE_ID
          AND     A.OPERATION_ID    = B.OPERATION_ID
                 

          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null


          SET @v_table_name = 'TH_ENG_STOCK_PLAN'

          UPDATE TH_ENG_STOCK_PLAN
          SET    TH_ENG_STOCK_PLAN.ITEM_ID = B.NEW_CHILD_ITEM_ID
          FROM   TH_ENG_STOCK_PLAN A,
                 (
                  SELECT DISTINCT
                         MASTER_ID,
                         PLAN_ID,
                         CHILD_ITEM_ID, 
                         CHILD_SITE_ID, 
                         CHILD_OPERATION_ID, 
                         CHILD_LANE_QTY, 
                         NEW_CHILD_ITEM_ID
                  FROM   TH_BUF_SCM_LANE_BOM
                  WHERE  MASTER_ID = @v_master_id
                  AND    PLAN_ID   = @v_plan_id
                 ) B
          WHERE  A.MASTER_ID    = @v_master_id
          AND    A.PLAN_ID      = @v_plan_id
          AND    A.MASTER_ID    = B.MASTER_ID
          AND    A.PLAN_ID      = B.PLAN_ID
          AND    A.ITEM_ID      = B.CHILD_ITEM_ID
          AND    A.SITE_ID      = B.CHILD_SITE_ID
          AND    A.OPERATION_ID = B.CHILD_OPERATION_ID
          AND    A.DESCR        = CONVERT(NVARCHAR, CEILING(CHILD_LANE_QTY))

          SET @n_row_count = @@ROWCOUNT
                
          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null

        END

      IF @@TRANCOUNT > 0
        COMMIT WORK 
    END;
    
  END TRY

  BEGIN CATCH
    --ROLLBACK

    SET @v_descr = ERROR_MESSAGE()
    SET @sysdate = GETDATE()

    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_temp2, null, @v_descr
    commit;
  END CATCH

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

END
