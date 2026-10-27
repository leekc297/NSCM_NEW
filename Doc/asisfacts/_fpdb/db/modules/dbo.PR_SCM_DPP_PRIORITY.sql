CREATE PROCEDURE [dbo].[PR_SCM_DPP_PRIORITY]
   @p_master_id nvarchar(max) = '-',
   @p_plan_id nvarchar(max) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_DPP_PRIORITY                                                       **/
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
  EXEC PR_SCM_DPP_PRIORITY
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
  DECLARE @v_daydiff        Integer
  

  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_DPP_PRIORITY'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code        nvarchar(10)
  
  DECLARE @sysdate          DATETIME2 = GETDATE()

  DECLARE @v_temp1        nvarchar(1000)
  DECLARE @v_temp2        nvarchar(1000)

  DECLARE @v_dpp_config_set_id  nvarchar(30)
  
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

      SET @v_table_name = 'TH_MST_PLAN'
      SELECT  @plan_start_time = PLAN_START_DTTM,
              @plan_end_time   = PLAN_END_DTTM,
              @v_daydiff       = DAYDIFF,
              @v_dpp_config_set_id = DPP_CONFIG_SET_ID
      FROM   (
              SELECT PLAN_START_DTTM,
                     CASE WHEN PLAN_HORIZON_UOM = 'DAY'   THEN DATEADD(DD, PLAN_HORIZON,     PLAN_START_DTTM)
                          WHEN PLAN_HORIZON_UOM = 'WEEK'  THEN DATEADD(DD, PLAN_HORIZON * 7, PLAN_START_DTTM)
                          WHEN PLAN_HORIZON_UOM = 'MONTH' THEN DATEADD(MM, PLAN_HORIZON ,    PLAN_START_DTTM)
                     END  PLAN_END_DTTM,
                     DATEDIFF(MINUTE,CONVERT(DATE,PLAN_START_DTTM), PLAN_START_DTTM) AS DAYDIFF,
                     DPP_CONFIG_SET_ID
              FROM   TH_MST_PLAN
              WHERE  MASTER_ID = @v_master_id
              AND    PLAN_ID = @v_plan_id
             ) A
             
      --LOG 생성
      SET @v_message  = 'PST : ' + CONVERT(nvarchar, @plan_start_time, 112) + ' / PET : ' + CONVERT(nvarchar, @plan_end_time, 112)
      SET @v_message += ' / day minute : ' + CONVERT(nvarchar, @v_daydiff)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
      
    END;

    BEGIN
    
      SET @v_table_name = 'TH_BUF_SCM_DEMAND'
      SET @n_row_count = 0

      UPDATE TH_BUF_SCM_DEMAND
      SET    PRIORITY = NULL
      WHERE  DPP_PLAN_ID = @v_plan_id

      SET @n_row_count += @@ROWCOUNT

      --LOG 생성
      SET @v_message = '000 - INIT : ' + CONVERT(NVARCHAR, @n_row_count)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
    
    END
    
    BEGIN
    
      SET @v_table_name = 'TH_BUF_SCM_DEMAND'
      SET @n_row_count = 0

      DECLARE
        @c_pr$comparator_id nvarchar(max), 
        @c_pr$apply_order nvarchar(max)
      
      DECLARE
        C_PRIORITY_RULE CURSOR LOCAL FOR 
          SELECT A.SELECTOR_ID AS COMPARATOR_ID, 
                 DBO.FN_LPAD_NVARCHAR(RANK() OVER(ORDER BY APPLY_ORDER), 3, '0')/* @@@ DENSE_RANK @@@*/ AS APPLY_ORDER
          FROM 
                (
                 SELECT A.KEY_VALUE AS SELECTOR_ID
                      , MIN(A.KEY_PRIORITY) AS APPLY_ORDER
                 FROM   SY_FP_INSTANCE_CONFIG_M  AS A
                 WHERE  A.INSTANCE_ID = @v_master_id 
                 AND    A.CATEGORY_ID = 'DPP_CONFIG' 
                 AND    A.KEY_ID = 'DEMAND_PRIORITY' 
                 GROUP  BY A.KEY_VALUE
                )  AS A
          ORDER BY APPLY_ORDER

      OPEN C_PRIORITY_RULE

      WHILE 1 = 1
     
        BEGIN
        
          SET @n_row_count = 0

          FETCH C_PRIORITY_RULE
           INTO @C_PR$COMPARATOR_ID, @C_PR$APPLY_ORDER

            IF @@FETCH_STATUS <> 0
              BREAK

            IF (@c_pr$comparator_id = 'FIX_TYPE')
              BEGIN

                UPDATE TH_BUF_SCM_DEMAND
                SET    PRIORITY = RTRIM(LTRIM(ISNULL(PRIORITY, '') + ':' + 'FT' + ISNULL(
                          CASE DEMAND_TYPE
                             WHEN 'FIX' THEN '1'
                             WHEN 'NCP' THEN '2'
                             ELSE '3'
                          END, '')))
                WHERE  DPP_PLAN_ID = @v_plan_id

                SET @n_row_count += @@ROWCOUNT

              END

            ELSE IF (@c_pr$comparator_id = 'FIX_SEQ')
              BEGIN

                UPDATE TH_BUF_SCM_DEMAND
                SET    PRIORITY = RTRIM(LTRIM(ISNULL(PRIORITY, '') + ':' + 'FS99999'))
                WHERE  DPP_PLAN_ID = @v_plan_id
                AND    DEMAND_TYPE = 'NOR'

                SET @n_row_count += @@ROWCOUNT
                
                UPDATE TH_BUF_SCM_DEMAND
                SET    PRIORITY = RTRIM(LTRIM(ISNULL(PRIORITY, '') + ':' + 'FS11111'))
                WHERE  DPP_PLAN_ID = @v_plan_id
                AND    DEMAND_TYPE = 'FIX'
                
                SET @n_row_count += @@ROWCOUNT

              END
            
            ELSE IF (@c_pr$comparator_id = 'MFG_WEEK')
              BEGIN

                UPDATE TH_BUF_SCM_DEMAND
                SET    PRIORITY = RTRIM(LTRIM(ISNULL(PRIORITY, '') + ':' + 'MW'))
                                + RTRIM(LTRIM(ISNULL(MFG_WEEK, '999999')))
                WHERE  DPP_PLAN_ID = @v_plan_id

                SET @n_row_count += @@ROWCOUNT

              END

            ELSE IF (@c_pr$comparator_id = 'FIX_SETUP')
            
              BEGIN
                SET @n_log_count = @n_log_count
              END

            ELSE IF (@c_pr$comparator_id = 'SETUP_GROUP')
              BEGIN
                
                UPDATE TH_BUF_SCM_DEMAND
                SET    PRIORITY += ':' + 'SG' + CASE WHEN B.SEQ < 10 THEN '000'
                                                     WHEN B.SEQ < 100 THEN '00'
                                                     WHEN B.SEQ < 1000 THEN '0'
                                                                        ELSE ''
                                                END + CONVERT(NVARCHAR, B.SEQ)
                                                 
                FROM   TH_BUF_SCM_DEMAND A,
                       (
                        SELECT A.FP_DEMAND_ID,
                               DENSE_RANK() OVER (ORDER BY SETUP_GROUP_ID) AS SEQ
                        FROM   TH_BUF_SCM_DEMAND A,
                               (
                                SELECT ITEM_ID, 
                                       CASE WHEN SETUP_GROUP_ID IS NULL THEN 'ZZZZZZZZ'
                                            WHEN SETUP_GROUP_ID = ''    THEN 'ZZZZZZZZ'
                                            ELSE SETUP_GROUP_ID
                                       END  SETUP_GROUP_ID
                                FROM   TH_MST_ITEM B
                                WHERE  MASTER_ID = @v_master_id
                                AND    PLAN_ID   = @v_plan_id
                               ) B
                        WHERE  A.DPP_PLAN_ID = @v_plan_id
                        AND    A.ITEM_ID = B.ITEM_ID
                       ) B
                WHERE  A.DPP_PLAN_ID = @v_plan_id
                AND    A.FP_DEMAND_ID = B.FP_DEMAND_ID
                /*
                UPDATE TH_BUF_SCM_DEMAND
                SET    PRIORITY += ':' + 'SG' +B.SETUP_GROUP
                FROM   TH_BUF_SCM_DEMAND A,
                       (
                        SELECT A.FP_DEMAND_ID, 
                               CASE WHEN B.SETUP_GROUP_ID_1 IS NULL THEN DBO.FN_LPAD_NVARCHAR(ISNULL(NULL, 999), 3, '0') 
                                                                    ELSE DBO.FN_LPAD_NVARCHAR(ISNULL(B.SETUP_GROUP, 999), 3, '0') 
                               END  AS SETUP_GROUP                    
                        FROM   TH_BUF_SCM_DEMAND  AS A 
                               LEFT OUTER JOIN 
                                (
                                 SELECT FCI.FP_DEMAND_ID, FCI.SETUP_GROUP_ID_1,
                                        RANK() OVER(PARTITION BY FCI.DPP_PLAN_ID, FCI.FIX_SETUP_FACTOR
                                                    ORDER BY FCI.RES_CNT, (FCI.SETUP_GROUP_QTY * FCI.FIX_SETUP_FACTOR))/* @@@ DENSE_RANK @@@*/ AS SETUP_GROUP
                                 FROM  (
                                        SELECT FCI.DPP_PLAN_ID, 
                                               FCI.FP_DEMAND_ID, 
                                               FCI.SETUP_GROUP_ID_1, 
                                               FCI.ITEM_ID, 
                                               FCI.FIX_SETUP_FACTOR AS FIX_SETUP_FACTOR, 
                                               FCI.RES_CNT AS RES_CNT, 
                                               SUM(FCI.QTY) OVER(PARTITION BY FCI.FIX_SETUP_FACTOR, FCI.SETUP_GROUP_ID_1) AS SETUP_GROUP_QTY, 
                                               SUM(FCI.QTY) OVER(PARTITION BY FCI.FIX_SETUP_FACTOR, FCI.ITEM_ID) AS ITEM_QTY
                                        FROM  (
                                               SELECT A.DPP_PLAN_ID, 
                                                      A.FP_DEMAND_ID, 
                                                      B.SETUP_GROUP_ID_1, 
                                                      A.ITEM_ID, 
                                                      (MFG_QTY - (OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY)) AS QTY, 
                                                      ISNULL(C.RES_CNT, 1) AS RES_CNT, 
                                                      CASE CHARINDEX(A.PRIORITY, 'FSP1')
                                                           WHEN 0 THEN -1
                                                           ELSE 1
                                                      END AS FIX_SETUP_FACTOR
                                               FROM   TH_BUF_SCM_DEMAND  AS A 
                                                      LEFT OUTER JOIN 
                                                      (
                                                        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, 
                                                               A.ITEM_ID, COUNT_BIG(DISTINCT A.OPERATION_ID+A.LINE_ID) AS RES_CNT 
                                                        FROM   SY_SCM_TACT_TIME_M A,
                                                               SY_SCM_ITEM_LINE_ASSIGN_M B
                                                        WHERE  A.COMPANY_ID = B.COMPANY_ID
                                                        AND    A.DIVISION_ID = B.DIVISION_ID
                                                        AND    A.SITE_ID = B.SITE_ID
                                                        AND    A.PLANT_ID = B.PLANT_ID
                                                        AND    A.FACTORY_ID = B.FACTORY_ID
                                                        --AND    A.SHOP_ID = B.SHOP_ID
                                                        AND    A.OPERATION_ID = B.OPERATION_ID
                                                        AND    A.LINE_ID = B.LINE_ID
                                                        AND    A.ITEM_ID = B.ITEM_ID
                                                        AND    A."MONTH" = B."MONTH"
                                                        AND    B.ACTIVE_FLAG = 'Y'
                                                        GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,
                                                                  A.ITEM_ID
                                                       )  AS C 
                                                       ON    A.ITEM_ID = C.ITEM_ID
                                                       AND   A.COMPANY_ID = C.COMPANY_ID
                                                       AND   A.DIVISION_ID = C.DIVISION_ID
                                                       AND   A.SITE_ID = C.SITE_ID
                                                       AND   A.PLANT_ID = C.PLANT_ID
                                                     , SY_SCM_ITEM_M  AS B
                                               WHERE   A.COMPANY_ID = B.COMPANY_ID 
                                               AND     A.DIVISION_ID = B.DIVISION_ID 
                                               AND     A.SITE_ID = B.SITE_ID 
                                               --AND     A.PLANT_ID = B.PLANT_ID 
                                               AND     A.ITEM_ID = B.ITEM_ID 
                                               AND     A.DPP_PLAN_ID = @v_plan_id
                                              )  AS FCI
                                        WHERE FCI.QTY > 0
                                       )  AS FCI
                              )  AS B 
                              ON A.FP_DEMAND_ID = B.FP_DEMAND_ID
                        WHERE A.DPP_PLAN_ID = @v_plan_id
                       ) B
                WHERE  A.DPP_PLAN_ID = @v_plan_id
                AND    A.FP_DEMAND_ID = B.FP_DEMAND_ID
                */
                
                SET @n_row_count += @@ROWCOUNT
                
              END

            ELSE IF (@c_pr$comparator_id = 'SETUP_ITEM')
            
              BEGIN
              
                UPDATE TH_BUF_SCM_DEMAND
                SET    PRIORITY += ':' + 'SI' +B.SETUP_ITEM
                FROM   TH_BUF_SCM_DEMAND A,
                       (
                        SELECT A.FP_DEMAND_ID, 
                               CASE WHEN B.ITEM_GROUP_ID IS NULL THEN DBO.FN_LPAD_NVARCHAR(ISNULL(NULL, 999), 3, '0') 
                                                                 ELSE DBO.FN_LPAD_NVARCHAR(ISNULL(B.SETUP_ITEM, 999), 3, '0') 
                               END  AS SETUP_ITEM
                        FROM   TH_BUF_SCM_DEMAND  AS A 
                               LEFT OUTER JOIN 
                                (
                                 SELECT FCI.FP_DEMAND_ID, FCI.ITEM_GROUP_ID,
                                        RANK() OVER(PARTITION BY FCI.DPP_PLAN_ID, FCI.FIX_SETUP_FACTOR
                                                    ORDER BY FCI.RES_CNT, (FCI.ITEM_QTY * FCI.FIX_SETUP_FACTOR))/* @@@ DENSE_RANK @@@*/ AS SETUP_ITEM
                                 FROM  (
                                        SELECT FCI.DPP_PLAN_ID, 
                                               FCI.FP_DEMAND_ID, 
                                               FCI.ITEM_GROUP_ID, 
                                               FCI.ITEM_ID, 
                                               FCI.FIX_SETUP_FACTOR AS FIX_SETUP_FACTOR, 
                                               FCI.RES_CNT AS RES_CNT, 
                                               SUM(FCI.QTY) OVER(PARTITION BY FCI.FIX_SETUP_FACTOR, FCI.ITEM_GROUP_ID) AS ITEM_GROUP_QTY, 
                                               SUM(FCI.QTY) OVER(PARTITION BY FCI.FIX_SETUP_FACTOR, FCI.ITEM_ID) AS ITEM_QTY
                                        FROM  (
                                               SELECT A.DPP_PLAN_ID, 
                                                      A.FP_DEMAND_ID, 
                                                      B.ITEM_GROUP_ID, 
                                                      A.ITEM_ID, 
                                                      (MFG_QTY - (OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY)) AS QTY, 
                                                      ISNULL(C.RES_CNT, 1) AS RES_CNT, 
                                                      CASE CHARINDEX(A.PRIORITY, 'FSP1')
                                                           WHEN 0 THEN -1
                                                           ELSE 1
                                                      END AS FIX_SETUP_FACTOR
                                               FROM   TH_BUF_SCM_DEMAND  AS A 
                                                      LEFT OUTER JOIN 
                                                      (
                                                        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, 
                                                               A.ITEM_ID, COUNT_BIG(DISTINCT A.OPERATION_ID+A.LINE_ID) AS RES_CNT 
                                                        FROM   SY_SCM_TACT_TIME_M A,
                                                               SY_SCM_ITEM_LINE_ASSIGN_M B
                                                        WHERE  A.COMPANY_ID = B.COMPANY_ID
                                                        AND    A.DIVISION_ID = B.DIVISION_ID
                                                        AND    A.SITE_ID = B.SITE_ID
                                                        AND    A.PLANT_ID = B.PLANT_ID
                                                        AND    A.FACTORY_ID = B.FACTORY_ID
                                                        --AND    A.SHOP_ID = B.SHOP_ID
                                                        AND    A.OPERATION_ID = B.OPERATION_ID
                                                        AND    A.LINE_ID = B.LINE_ID
                                                        AND    A.ITEM_ID = B.ITEM_ID
                                                        AND    A."MONTH" = B."MONTH"
                                                        AND    B.ACTIVE_FLAG = 'Y'
                                                        GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,
                                                                  A.ITEM_ID
                                                       )  AS C 
                                                       ON    A.ITEM_ID = C.ITEM_ID
                                                       AND   A.COMPANY_ID = C.COMPANY_ID
                                                       AND   A.DIVISION_ID = C.DIVISION_ID
                                                       AND   A.SITE_ID = C.SITE_ID
                                                       AND   A.PLANT_ID = C.PLANT_ID
                                                      ,SY_SCM_ITEM_M  AS B
                                               WHERE   A.COMPANY_ID = B.COMPANY_ID 
                                               AND     A.DIVISION_ID = B.DIVISION_ID 
                                               AND     A.SITE_ID = B.SITE_ID 
                                               --AND     A.PLANT_ID = B.PLANT_ID 
                                               AND     A.ITEM_ID = B.ITEM_ID 
                                               AND     A.DPP_PLAN_ID = @v_plan_id
                                              )  AS FCI
                                        WHERE FCI.QTY > 0
                                       )  AS FCI
                              )  AS B 
                              ON A.FP_DEMAND_ID = B.FP_DEMAND_ID
                        WHERE A.DPP_PLAN_ID = @v_plan_id
                       ) B
                WHERE  A.DPP_PLAN_ID = @v_plan_id
                AND    A.FP_DEMAND_ID = B.FP_DEMAND_ID

                SET @n_row_count += @@ROWCOUNT

              END

            ELSE IF (@c_pr$comparator_id = 'ITEM_GROUP')
              BEGIN

                UPDATE TH_BUF_SCM_DEMAND
                SET    PRIORITY += ':' + 'IG' + CASE WHEN B.SEQ < 10 THEN '000'
                                                     WHEN B.SEQ < 100 THEN '00'
                                                     WHEN B.SEQ < 1000 THEN '0'
                                                                        ELSE ''
                                                END + CONVERT(NVARCHAR, B.SEQ)
                                                 
                FROM   TH_BUF_SCM_DEMAND A,
                       (
                        SELECT A.FP_DEMAND_ID,
                               DENSE_RANK() OVER (ORDER BY ITEM_GROUP_ID) AS SEQ
                        FROM   TH_BUF_SCM_DEMAND A,
                               (
                                SELECT ITEM_ID, 
                                       CASE WHEN ITEM_GROUP_ID IS NULL                THEN 'ZZZZZZZZ'
                                            WHEN SUBSTRING(ITEM_GROUP_ID, 1,1) = 'A'  THEN 'Z'+ ITEM_GROUP_ID
                                            ELSE ITEM_GROUP_ID
                                       END  ITEM_GROUP_ID
                                FROM   TH_MST_ITEM B
                                WHERE  MASTER_ID = @v_master_id
                                AND    PLAN_ID   = @v_plan_id
                               ) B
                        WHERE  A.DPP_PLAN_ID = @v_plan_id
                        AND    A.ITEM_ID = B.ITEM_ID
                       ) B
                WHERE  A.DPP_PLAN_ID = @v_plan_id
                AND    A.FP_DEMAND_ID = B.FP_DEMAND_ID
                
              END
            ELSE IF (@c_pr$comparator_id = 'ITEM')
            
              BEGIN
              
                UPDATE TH_BUF_SCM_DEMAND
                SET    PRIORITY += ':' + 'IT' +B.ITEM_QTY
                FROM   TH_BUF_SCM_DEMAND A,
                       (
                        SELECT A.FP_DEMAND_ID, DBO.FN_LPAD_NVARCHAR(ISNULL(A.ITEM_QTY, 999), 3, '0') AS ITEM_QTY
                        FROM   (
                                 SELECT FP_DEMAND_ID, 
                                        RANK() OVER(PARTITION BY DEMAND_TYPE, MFG_WEEK
                                                    ORDER BY ITEM_QTY DESC, ITEM_ID)/* @@@ DENSE_RANK @@@*/ AS ITEM_QTY
                                 FROM  (                                        
                                        SELECT FP_DEMAND_ID, ITEM_ID, DEMAND_TYPE, MFG_WEEK,
                                               SUM(MFG_QTY - ( OFFSET_INVENTORY_QTY + OFFSET_GI_QTY + OFFSET_FIX_QTY )) 
                                                  OVER(PARTITION BY ITEM_ID, DEMAND_TYPE, MFG_WEEK) AS ITEM_QTY
                                        FROM   TH_BUF_SCM_DEMAND 
                                        WHERE  DPP_PLAN_ID = @v_plan_id
                                       ) AS A
                               ) AS A 
                       ) B
                WHERE  A.DPP_PLAN_ID = @v_plan_id
                AND    A.FP_DEMAND_ID = B.FP_DEMAND_ID

                SET @n_row_count += @@ROWCOUNT

              END

            ELSE IF (@c_pr$comparator_id = 'ORDER_TYPE')

              BEGIN

                UPDATE TH_BUF_SCM_DEMAND
                SET    PRIORITY += ':' + 'OT' + PRODUCTION_TYPE_SEQ
                FROM   TH_BUF_SCM_DEMAND A,
                       (
                        SELECT A.FP_DEMAND_ID,
                               DBO.FN_LPAD_NVARCHAR(ISNULL(KEY_VALUE, 999), 3, '0') PRODUCTION_TYPE_SEQ
                        FROM   TH_BUF_SCM_DEMAND A
                               LEFT OUTER JOIN (
                                                SELECT KEY_ID, KEY_VALUE
                                                FROM   SY_FP_INSTANCE_CONFIG_M
                                                WHERE  INSTANCE_ID = 'COMMON'
                                                AND    CATEGORY_ID = 'DEMAND_TYPE'
                                               ) B
                                     ON ISNULL(A.PRODUCTION_TYPE, 'MASS') = KEY_ID
                        WHERE  A.DPP_PLAN_ID = @v_plan_id
                       ) B
                WHERE  A.DPP_PLAN_ID = @v_plan_id
                AND    A.FP_DEMAND_ID = B.FP_DEMAND_ID
                
                SET @n_row_count += @@ROWCOUNT

              END

            ELSE IF (@c_pr$comparator_id = 'SOP_WEEK')
            
              BEGIN
                SET @n_log_count = @n_log_count
              END

            ELSE IF (@c_pr$comparator_id = 'DUE_DATE')
            
              BEGIN
              
                UPDATE TH_BUF_SCM_DEMAND
                SET    PRIORITY += ':' + 'DD' +due_date_seq
                FROM   TH_BUF_SCM_DEMAND A,
                       (
                        SELECT A.*,
                               dbo.FN_LPAD_NVARCHAR(dense_rank() OVER(PARTITION BY a.DPP_PLAN_ID
                                                                      ORDER     BY a.due_date), 3, '0') AS due_date_seq                                  
                        FROM   TH_BUF_SCM_DEMAND  AS a
                        WHERE  a.DPP_PLAN_ID = @v_plan_id
                       ) B
                WHERE  A.DPP_PLAN_ID = @v_plan_id
                AND    A.FP_DEMAND_ID = B.FP_DEMAND_ID

                SET @n_row_count += @@ROWCOUNT

              END  
                  
            ELSE IF (@c_pr$comparator_id = 'TO_SITE')
            
              BEGIN
              
                UPDATE TH_BUF_SCM_DEMAND
                SET    PRIORITY += ':' + 'TS' + TO_SITE_SEQ
                FROM   TH_BUF_SCM_DEMAND A,
                       (
                        SELECT A.*,
                               dbo.FN_LPAD_NVARCHAR(dense_rank() OVER(PARTITION BY a.DPP_PLAN_ID
                                                                      ORDER     BY ISNULL(A.TO_SITE_ID, '*NULL*')), 3, '0') AS TO_SITE_SEQ                                  
                        FROM   TH_BUF_SCM_DEMAND  AS a
                        WHERE  a.DPP_PLAN_ID = @v_plan_id
                       ) B
                WHERE  A.DPP_PLAN_ID = @v_plan_id
                AND    A.FP_DEMAND_ID = B.FP_DEMAND_ID
                
                SET @n_row_count += @@ROWCOUNT

              END

            ELSE IF (@c_pr$comparator_id = 'MARKET')
            
              BEGIN
              
                UPDATE TH_BUF_SCM_DEMAND
                SET    TH_BUF_SCM_DEMAND.PRIORITY = A.PRIORITY + ':' + 'MK' + ISNULL(SEGMENT3, '9')
                FROM   TH_BUF_SCM_DEMAND A
                       LEFT OUTER JOIN SY_SCM_SYS_LOOKUP_VALUE B
                            ON    A.MARKET = B.SEGMENT1
                            AND   B.LOOKUP_TYPE_CODE = 'DEMAND_MARKET_TYPE'
                WHERE  DPP_PLAN_ID = @v_plan_id
                
                SET @n_row_count += @@ROWCOUNT

              END

          --LOG 생성
          SET @v_message = @C_PR$APPLY_ORDER + ' - ' + @C_PR$COMPARATOR_ID + ' : ' + CONVERT(NVARCHAR, @n_row_count)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

        END
        
      CLOSE c_priority_rule

      DEALLOCATE c_priority_rule

      BEGIN
      
        UPDATE TH_BUF_SCM_DEMAND
        SET    PRIORITY = SUBSTRING(PRIORITY, 2, LEN(PRIORITY)-1)
        WHERE  DPP_PLAN_ID = @v_plan_id
        AND    SUBSTRING(PRIORITY, 1, 1) = ':'

        --LOG 생성
        SET @v_message = 'PRIORITY SUBSTRING : ' + CONVERT(NVARCHAR, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
        
      END
      
    END



  END TRY

  BEGIN CATCH
    --ROLLBACK

    SET @v_descr = ERROR_MESSAGE()

    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_temp2, null, @v_descr
    commit;
  END CATCH

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

END
