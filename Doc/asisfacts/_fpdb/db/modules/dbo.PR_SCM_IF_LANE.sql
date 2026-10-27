CREATE PROCEDURE [dbo].[PR_SCM_IF_LANE]
   @p_master_id nvarchar(max) = '-',
   @p_plan_id nvarchar(max) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_IF_LANE                                                            **/
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
  EXEC PR_SCM_IF_LANE
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
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_IF_LANE'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code        nvarchar(10)
  
  DECLARE @sysdate          DATETIME2 = GETDATE()
  DECLARE @key_date         nvarchar(8)
  DECLARE @v_instance_type  nvarchar(10)

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
              @plan_end_time   = PLAN_END_DTTM,
              @key_date = PLAN_DATE
      FROM   (
              SELECT PLAN_START_DTTM,
                     CASE WHEN PLAN_HORIZON_UOM = 'DAY'   THEN DATEADD(DD, PLAN_HORIZON,     PLAN_START_DTTM)
                          WHEN PLAN_HORIZON_UOM = 'WEEK'  THEN DATEADD(DD, PLAN_HORIZON * 7, PLAN_START_DTTM)
                          WHEN PLAN_HORIZON_UOM = 'MONTH' THEN DATEADD(MM, PLAN_HORIZON ,    PLAN_START_DTTM)
                     END  PLAN_END_DTTM,
                     PLAN_DATE
              FROM   TH_MST_PLAN
              WHERE  MASTER_ID = @v_master_id
              AND    PLAN_ID = @v_plan_id
             ) A
             
             
      --LOG 생성
      SET @v_message = 'PST : ' + CONVERT(nvarchar, @plan_start_time, 112) + ' / PET : ' + CONVERT(nvarchar, @plan_end_time, 112)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

      SELECT @v_instance_type = MAX(INSTANCE_TYPE)
      FROM   SY_FP_INSTANCE_FACTORY_M
      WHERE  INSTANCE_ID = @v_master_id
      AND    ACTIVE_FLAG = 'Y'


      --LOG 생성
      SET @v_message = '@v_instance_type : ' + @v_instance_type
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
      
    END;
    
    IF @v_instance_type = 'E2'
    BEGIN
      
      BEGIN
      
        SET @v_table_name = 'TH_MST_ITEM_LANE_CAL'
        
        DELETE FROM TH_MST_ITEM_LANE_CAL
        WHERE   MASTER_ID   = @v_master_id
        AND     PLAN_ID     = @v_plan_id
        
        INSERT INTO TH_MST_ITEM_LANE_CAL
              (
                MASTER_ID
              , PLAN_ID
              , COMPANY_ID
              , DIVISION_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , ITEM_ID
              , LINE_ID
              , OPERATION_ID
              , OPERATION_SEQ
              , ELECTRODE_TYPE
              , LANE_QTY
              , MAIN_LANE_QTY
              , SUB_LANE_QTY
              , PATTERN_QTY
              , HALF_SLIT_FLAG              
              , LINE_LANE_QTY
              , ITEM_LANE_QTY
              , START_TIME
              , END_TIME
              , PRIORITY
              , TACT_TIME
              , TACT_TIME_UOM
              , YIELD
              , COATED_LENGTH
              , UNCOATED_LENGTH
              , LENGTH_UOM
              , SLURRY_LOSS_RATE
              , LANE_TACT_QTY
              , LANE_TACT_TIME
              , KEY_DATE
              , INSERT_ID
              , INSERT_DTTM
              , UPDATE_ID
              , UPDATE_DTTM              
              )
        SELECT DISTINCT 
               AA.MASTER_ID, AA.PLAN_ID,
               AA.COMPANY_ID, AA.DIVISION_ID, AA.SITE_ID, AA.PLANT_ID, AA.FACTORY_ID, AA.ITEM_ID, 
               AA.LINE_ID, AA.OPERATION_ID, AA.OPERATION_SEQ, AA.ELECTRODE_TYPE, 
               AA.LANE_QTY, AA.MAIN_LANE_QTY, AA.SUB_LANE_QTY, AA.PATTERN_QTY, AA.HALF_SLIT_FLAG,
               AA.LINE_LANE_QTY, AA.ITEM_LANE_QTY,
               DATEADD(SS, DATEDIFF(SS, CONVERT(DATE, @plan_start_time), @plan_start_time), CONVERT(DATETIME, CONVERT(DATE, MONTH + '01'))) AS START_DATE,
               DATEADD(SS, DATEDIFF(SS, CONVERT(DATE, @plan_start_time), @plan_start_time), CONVERT(DATETIME, DATEADD(MM, 1, CONVERT(DATE, MONTH + '01')))) AS END_DATE,
               AA.PRIORITY,
               CASE WHEN @V_MASTER_ID = 'PL_E_POST' AND AA.ITEM_ID LIKE 'APCCA%' THEN AA.TACT_TIME * 2 ELSE AA.TACT_TIME END AS TACT_TIME,
               AA.TACT_TIME_UOM,
               AA.YIELD,
               BB.COATED_LENGTH,
               BB.UNCOATED_LENGTH,
               BB.LENGTH_UOM,
               BB.SLURRY_LOSS_RATE,
               --TACT_TIME * (
               --                 CASE WHEN (ISNULL(BB.COATED_LENGTH,0) + ISNULL(BB.UNCOATED_LENGTH, 0)) = 0 THEN 1
               --                      ELSE (ISNULL(BB.COATED_LENGTH,0) + ISNULL(BB.UNCOATED_LENGTH, 0))
               --                 END
               --             )
               --          / (CASE WHEN LINE_LANE_QTY IS NULL OR LINE_LANE_QTY = 0 THEN ITEM_LANE_QTY ELSE LINE_LANE_QTY END) -- 총 LANE 수
               --          / (CASE WHEN PATTERN_QTY IS NULL OR PATTERN_QTY = 0 THEN 1.0 ELSE PATTERN_QTY END)               -- LANE 당 수량
               --       AS  LANE_TACT_TIME
               AA.LANE_TACT_QTY,
               CASE WHEN @v_instance_type = 'E2' AND UPPER(BB.ITEM_UOM) != 'M'
                    THEN AA.TACT_TIME 
                         --/ (CASE WHEN A.LANE_QTY IS NULL OR A.LANE_QTY = 0 THEN 1.0 ELSE A.LANE_QTY END) 
                         --/ (CASE WHEN AA.LINE_LANE_QTY IS NULL OR AA.LINE_LANE_QTY = 0 THEN AA.ITEM_LANE_QTY ELSE AA.LINE_LANE_QTY END)
                         / AA.LANE_TACT_QTY
                         * CASE WHEN (ISNULL(BB.COATED_LENGTH,0) + ISNULL(BB.UNCOATED_LENGTH, 0)) = 0 THEN 1
                                ELSE (ISNULL(BB.COATED_LENGTH,0) + ISNULL(BB.UNCOATED_LENGTH, 0))
                                         / CASE UPPER(BB.LENGTH_UOM) WHEN 'M'  THEN 1
                                                                     WHEN 'CM' THEN 100
                                                                     WHEN 'MM' THEN 1000
                                                                               ELSE 1 
                                           END                                
                           END
                         / ISNULL(AA.PATTERN_QTY,1)
                         * CASE AA.TACT_TIME_UOM WHEN 'SECOND' THEN 1
                                                 WHEN 'MINUTE' THEN 60
                                                 WHEN 'MIN'    THEN 60
                                                 WHEN 'HOUR'   THEN 3600
                                                               ELSE 1 
                            END
                    WHEN @v_instance_type = 'E2' AND UPPER(BB.ITEM_UOM) = 'M'
                    THEN AA.TACT_TIME 
                         --/ (CASE WHEN A.LANE_QTY IS NULL OR A.LANE_QTY = 0 THEN 1.0 ELSE A.LANE_QTY END) 
                         --/ (CASE WHEN AA.LINE_LANE_QTY IS NULL OR AA.LINE_LANE_QTY = 0 THEN AA.ITEM_LANE_QTY ELSE AA.LINE_LANE_QTY END)
                         / AA.LANE_TACT_QTY
                         * CASE AA.TACT_TIME_UOM WHEN 'SECOND' THEN 1
                                                 WHEN 'MINUTE' THEN 60
                                                 WHEN 'MIN'    THEN 60
                                                 WHEN 'HOUR'   THEN 3600
                                                               ELSE 1
                                                 END 
                         * (CASE WHEN @V_MASTER_ID IN ('PL_E_POST') AND AA.ITEM_ID LIKE 'APCCA%' THEN 2 ELSE 1 END)
                    ELSE AA.TACT_TIME * CASE AA.TACT_TIME_UOM WHEN 'SECOND' THEN 1
                                                              WHEN 'MINUTE' THEN 60
                                                              WHEN 'MIN'    THEN 60
                                                              WHEN 'HOUR'   THEN 3600
                                                                            ELSE 1
                                        END                               
                         * (CASE WHEN @V_MASTER_ID IN ('PL_E_POST') AND AA.ITEM_ID LIKE 'APCCA%' THEN 2 ELSE 1 END)
                END AS LANE_TACT_TIME
                , @key_date AS KEY_DATE
                , @v_proc_name as INSERT_ID
                , GETDATE() as INSERT_DTTM
                , @v_proc_name as UPDATE_ID
                , getdate() as UPDATE_DTTM
        FROM   (
                SELECT A.MASTER_ID, A.PLAN_ID,
                       A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, B.FACTORY_ID, A.ITEM_ID, 
                       B.LINE_ID, A.OPERATION_ID, A.OPERATION_SEQ, B.ELECTRODE_TYPE, 
                       A.LANE_QTY, A.MAIN_LANE_QTY, A.SUB_LANE_QTY, A.PATTERN_QTY, A.HALF_SLIT_FLAG,
                       B.LANE_QTY AS LINE_LANE_QTY,     -- SCM_ITEM_LINE_ASSIGN_M 의 LANE_QTY
                       A.ITEM_LANE_QTY,                 -- SCM_ITEM_LANE_M 의 LANE_QTY
                       B.MONTH,
                       B.PRIORITY,
                       C.TACT_TIME,
                       C.TACT_TIME_UOM,
    				   ISNULL(D.YIELD, 1) YIELD,
                       -- 실제 반영될 LANE QTY 산출
                       CASE WHEN B.LANE_QTY      IS NULL OR B.LANE_QTY      = 0 THEN A.ITEM_LANE_QTY
                            WHEN A.ITEM_LANE_QTY IS NULL OR A.ITEM_LANE_QTY = 0 THEN B.LANE_QTY
                            WHEN B.LANE_QTY      < A.ITEM_LANE_QTY              THEN B.LANE_QTY
                            ELSE A.ITEM_LANE_QTY 
                       END  AS LANE_TACT_QTY
                FROM   (
                        SELECT B.MASTER_ID, B.PLAN_ID,
                               A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, B.OPERATION_ID, B.OPERATION_SEQ,
                               CASE WHEN A.LANE_QTY = 0 THEN 1 ELSE A.LANE_QTY END LANE_QTY, 
                               CASE WHEN A.LANE_QTY = 0 THEN 1 ELSE A.MAIN_LANE_QTY END MAIN_LANE_QTY, 
                               CASE WHEN A.LANE_QTY = 0 THEN 0 ELSE A.SUB_LANE_QTY END SUB_LANE_QTY,
                               A.PATTERN_QTY, A.HALF_SLIT_FLAG,
                               CASE WHEN A.ITEM_LANE_QTY = 0 THEN 1 ELSE A.ITEM_LANE_QTY END ITEM_LANE_QTY,
                               B.CAPA_TYPE
                        FROM   (-- 전극 전공정은 LANE_QTY 총 수량으로
                                SELECT DISTINCT
                                       A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.LANE_QTY, A.MAIN_LANE_QTY, A.SUB_LANE_QTY,
                                       A.PATTERN_QTY, A.HALF_SLIT_FLAG,
                                       A.LANE_QTY AS ITEM_LANE_QTY
                                FROM   SY_SCM_ITEM_LANE_M A,
                                       (
                                        SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, 
                                               MAX(LANE_QTY) AS LANE_QTY,
                                               MAX(MAIN_LANE_QTY) AS MAIN_LANE_QTY
                                        FROM   SY_SCM_ITEM_LANE_M A
                                        WHERE  A.ACTIVE_FLAG = 'Y'
                                        AND    @v_instance_type IN ('E1','S')        -- 전공정과 후공정의 처리가 다르다.   
                                        GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID
                                       ) B
                                WHERE  A.ACTIVE_FLAG = 'Y'
                                AND    A.COMPANY_ID = B.COMPANY_ID
                                AND    A.DIVISION_ID = B.DIVISION_ID
                                AND    A.SITE_ID = B.SITE_ID
                                AND    A.PLANT_ID = B.PLANT_ID
                                AND    A.FACTORY_ID = B.FACTORY_ID
                                AND    A.ITEM_ID = B.ITEM_ID
                                AND    A.LANE_QTY = B.LANE_QTY
                                AND    A.MAIN_LANE_QTY = B.MAIN_LANE_QTY
                                UNION  ALL  
                                -- 전극 후공정은 전극전공정 완료 후 투입되므로, 
                                -- LANE 이 나오는 수, 즉 MAIN_LANE_QTY, SUB_LANE_QTY 수량 기준임..
                                SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, LANE_QTY, MAIN_LANE_QTY, SUB_LANE_QTY,
                                       PATTERN_QTY, HALF_SLIT_FLAG,
                                       ITEM_LANE_QTY
                                FROM   (
                                        SELECT DISTINCT
                                               COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, LANE_QTY, MAIN_LANE_QTY, SUB_LANE_QTY,
                                               PATTERN_QTY, HALF_SLIT_FLAG,
                                               CASE WHEN R = 1 THEN MAIN_LANE_QTY ELSE SUB_LANE_QTY END ITEM_LANE_QTY
                                        FROM  SY_SCM_ITEM_LANE_M A,
                                               (SELECT 1 R UNION ALL
                                                SELECT 2 R ) B  
                                        WHERE  A.ACTIVE_FLAG = 'Y'       
                                       ) A
                                WHERE  ITEM_LANE_QTY > 0
                                AND    @v_instance_type = 'E2'        -- 전공정과 후공정의 처리가 다르다.  
                               ) A,
                               TH_MST_INSTANCE_FLOW B
                        WHERE  A.COMPANY_ID = B.COMPANY_ID
                        AND    A.DIVISION_ID = B.DIVISION_ID
                        AND    A.SITE_ID = B.SITE_ID
                        AND    A.PLANT_ID = B.PLANT_ID
                        AND    A.FACTORY_ID = B.FACTORY_ID
                        AND    A.ITEM_ID = B.ITEM_ID
                        AND    B.CAPA_TYPE = 'TACT'                  -- TACT 에 해당하는 것만 처리
                        AND    B.MASTER_ID = @v_master_id
                        AND    B.PLAN_ID = @v_plan_id
                       ) A
                     , SY_SCM_ITEM_LINE_ASSIGN_M B
                        LEFT  OUTER JOIN SY_SCM_TACT_TIME_M C
                              ON     B.COMPANY_ID = C.COMPANY_ID
                              AND    B.DIVISION_ID = C.DIVISION_ID
                              AND    B.SITE_ID = C.SITE_ID
                              AND    B.PLANT_ID = C.PLANT_ID
                              AND    B.ITEM_ID = C.ITEM_ID
                              AND    B.OPERATION_ID = C.OPERATION_ID
                              AND    B.FACTORY_ID = C.FACTORY_ID
                              AND    B.LINE_ID = C.LINE_ID
                              AND    B.ELECTRODE_TYPE = C.ELECTRODE_TYPE
                              AND    B.MONTH = C.MONTH
                        LEFT  OUTER JOIN SY_SCM_YIELD_M D
                              ON     1=1
                              AND    B.COMPANY_ID = D.COMPANY_ID
                              AND    B.DIVISION_ID = D.DIVISION_ID
                              AND    B.SITE_ID = D.SITE_ID
                              AND    B.PLANT_ID = D.PLANT_ID
                              AND    B.ITEM_ID = D.ITEM_ID
                              AND    B.OPERATION_ID = D.OPERATION_ID
                              AND    B.FACTORY_ID = D.FACTORY_ID
                              AND    B.LINE_ID = D.LINE_ID
                              AND    B.MONTH = D.MONTH
                WHERE  1=1
                AND    A.COMPANY_ID = B.COMPANY_ID
                AND    A.DIVISION_ID = B.DIVISION_ID
                AND    A.SITE_ID = B.SITE_ID
                AND    A.PLANT_ID = B.PLANT_ID
                AND    A.FACTORY_ID = B.FACTORY_ID
                AND    A.ITEM_ID = B.ITEM_ID
                AND    A.OPERATION_ID = B.OPERATION_ID
                AND    B.ACTIVE_FLAG = 'Y'
                AND    B.MONTH BETWEEN CONVERT(nvarchar(6), CONVERT(DATE, @plan_start_time), 112) 
                                   AND CONVERT(nvarchar(6), CONVERT(DATE, @plan_end_time), 112)
               ) AA,
               SY_SCM_ITEM_M BB
        WHERE  AA.COMPANY_ID = BB.COMPANY_ID
        AND    AA.DIVISION_ID = BB.DIVISION_ID
        AND    AA.SITE_ID = BB.SITE_ID
        AND    AA.ITEM_ID = BB.ITEM_ID
        AND    AA.TACT_TIME IS NOT NULL

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null


        INSERT INTO TH_MST_ITEM_LANE_CAL
              (
                MASTER_ID
              , PLAN_ID
              , COMPANY_ID
              , DIVISION_ID
              , SITE_ID
              , PLANT_ID
              , FACTORY_ID
              , ITEM_ID
              , LINE_ID
              , OPERATION_ID
              , OPERATION_SEQ
              , ELECTRODE_TYPE
              , LANE_QTY
              , MAIN_LANE_QTY
              , SUB_LANE_QTY
              , PATTERN_QTY
              , HALF_SLIT_FLAG              
              , LINE_LANE_QTY
              , ITEM_LANE_QTY
              , START_TIME
              , END_TIME
              , PRIORITY
              , TACT_TIME
              , TACT_TIME_UOM
              , YIELD
              , COATED_LENGTH
              , UNCOATED_LENGTH
              , LENGTH_UOM
              , SLURRY_LOSS_RATE
              , LANE_TACT_QTY
              , LANE_TACT_TIME
              , KEY_DATE
              , INSERT_ID
              , INSERT_DTTM
              , UPDATE_ID
              , UPDATE_DTTM              
              )
        SELECT DISTINCT
               AA.MASTER_ID, AA.PLAN_ID,
               AA.COMPANY_ID, AA.DIVISION_ID, AA.SITE_ID, AA.PLANT_ID, AA.FACTORY_ID, AA.ITEM_ID, 
               AA.LINE_ID, AA.OPERATION_ID, AA.OPERATION_SEQ, AA.ELECTRODE_TYPE, 
               AA.LANE_QTY, AA.MAIN_LANE_QTY, AA.SUB_LANE_QTY, AA.PATTERN_QTY, AA.HALF_SLIT_FLAG, 
               AA.LINE_LANE_QTY, AA.ITEM_LANE_QTY,
               DATEADD(SS, DATEDIFF(SS, CONVERT(DATE, @plan_start_time), @plan_start_time), CONVERT(DATETIME, CONVERT(DATE, MONTH + '01'))) AS START_DATE,
               DATEADD(SS, DATEDIFF(SS, CONVERT(DATE, @plan_start_time), @plan_start_time), CONVERT(DATETIME, DATEADD(MM, 1, CONVERT(DATE, MONTH + '01')))) AS END_DATE,
               AA.PRIORITY,
               0.0000000001 AS TACT_TIME,
               'SECOND'     AS TACT_TIME_UOM,
               AA.YIELD,
               BB.COATED_LENGTH,
               BB.UNCOATED_LENGTH,
               BB.LENGTH_UOM,
               BB.SLURRY_LOSS_RATE,
               AA.LANE_TACT_QTY,
               0.0000000001 AS LANE_TACT_TIME
                , @key_date AS KEY_DATE
                , @v_proc_name as INSERT_ID
                , GETDATE() as INSERT_DTTM
                , @v_proc_name as UPDATE_ID
                , getdate() as UPDATE_DTTM
        FROM   (
                SELECT A.MASTER_ID, A.PLAN_ID,
                       A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, 
                       B.LINE_ID, A.OPERATION_ID, A.OPERATION_SEQ, B.ELECTRODE_TYPE, 
                       A.LANE_QTY, A.MAIN_LANE_QTY, A.SUB_LANE_QTY, A.PATTERN_QTY, A.HALF_SLIT_FLAG,
                       B.LANE_QTY AS LINE_LANE_QTY,     -- SCM_ITEM_LINE_ASSIGN_M 의 LANE_QTY
                       A.ITEM_LANE_QTY,                 -- SCM_ITEM_LANE_M 의 LANE_QTY
                       B.MONTH,
                       B.PRIORITY,
                       C.TACT_TIME,
                       C.TACT_TIME_UOM,
                       ISNULL(D.YIELD, 1) YIELD,
                       -- 실제 반영될 LANE QTY 산출
                       CASE WHEN B.LANE_QTY      IS NULL OR B.LANE_QTY      = 0 THEN A.ITEM_LANE_QTY
                            WHEN A.ITEM_LANE_QTY IS NULL OR A.ITEM_LANE_QTY = 0 THEN B.LANE_QTY
                            WHEN B.LANE_QTY      < A.ITEM_LANE_QTY              THEN B.LANE_QTY
                            ELSE A.ITEM_LANE_QTY 
                       END  AS LANE_TACT_QTY
                FROM   (
                        SELECT B.MASTER_ID, B.PLAN_ID,
                               A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, B.OPERATION_ID, B.OPERATION_SEQ,
                               A.LANE_QTY, A.MAIN_LANE_QTY, A.SUB_LANE_QTY,
                               A.PATTERN_QTY, A.HALF_SLIT_FLAG,
                               A.ITEM_LANE_QTY,
                               B.CAPA_TYPE
                        FROM   (-- 전극 전공정은 LANE_QTY 총 수량으로 >> MAX 수량으로
                                SELECT DISTINCT
                                       A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.LANE_QTY, A.MAIN_LANE_QTY, A.SUB_LANE_QTY,
                                       A.PATTERN_QTY, A.HALF_SLIT_FLAG,
                                       A.LANE_QTY AS ITEM_LANE_QTY
                                FROM   SY_SCM_ITEM_LANE_M A,
                                       (
                                        SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, 
                                               MAX(LANE_QTY) AS LANE_QTY,
                                               MAX(MAIN_LANE_QTY) AS MAIN_LANE_QTY
                                        FROM   SY_SCM_ITEM_LANE_M A
                                        WHERE  A.ACTIVE_FLAG = 'Y'
                                        AND    @v_instance_type IN ('E1','S')        -- 전공정과 후공정의 처리가 다르다.   
                                        GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID
                                       ) B
                                WHERE  A.ACTIVE_FLAG = 'Y'
                                AND    A.COMPANY_ID = B.COMPANY_ID
                                AND    A.DIVISION_ID = B.DIVISION_ID
                                AND    A.SITE_ID = B.SITE_ID
                                AND    A.PLANT_ID = B.PLANT_ID
                                AND    A.FACTORY_ID = B.FACTORY_ID
                                AND    A.ITEM_ID = B.ITEM_ID
                                AND    A.LANE_QTY = B.LANE_QTY
                                AND    A.MAIN_LANE_QTY = B.MAIN_LANE_QTY
                                UNION  ALL  
                                -- 전극 후공정은 전극전공정 완료 후 투입되므로, 
                                -- LANE 이 나오는 수, 즉 MAIN_LANE_QTY, SUB_LANE_QTY 수량 기준임..
                                SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, LANE_QTY, MAIN_LANE_QTY, SUB_LANE_QTY,
                                       PATTERN_QTY, HALF_SLIT_FLAG,
                                       ITEM_LANE_QTY
                                FROM   (
                                        SELECT DISTINCT
                                               COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, LANE_QTY, MAIN_LANE_QTY, SUB_LANE_QTY,
                                               PATTERN_QTY, HALF_SLIT_FLAG,
                                               CASE WHEN HALF_SLIT_FLAG = 'Y' AND R = 1 THEN MAIN_LANE_QTY 
                                                    WHEN HALF_SLIT_FLAG = 'Y' AND R = 2 THEN  SUB_LANE_QTY 
                                                    ELSE LANE_QTY 
                                               END  ITEM_LANE_QTY
                                        FROM   SY_SCM_ITEM_LANE_M A,
                                               (SELECT 1 R UNION ALL
                                                SELECT 2 R ) B  
                                        WHERE  A.ACTIVE_FLAG = 'Y'       
                                       ) A
                                WHERE  ITEM_LANE_QTY > 0
                                AND    @v_instance_type = 'E2'        -- 전공정과 후공정의 처리가 다르다.  
                               ) A,
                               TH_MST_INSTANCE_FLOW B
                        WHERE  A.COMPANY_ID = B.COMPANY_ID
                        AND    A.DIVISION_ID = B.DIVISION_ID
                        AND    A.SITE_ID = B.SITE_ID
                        AND    A.PLANT_ID = B.PLANT_ID
                        AND    A.FACTORY_ID = B.FACTORY_ID
                        AND    A.ITEM_ID = B.ITEM_ID
                        AND    B.CAPA_TYPE LIKE 'TAT%'                -- TAT 에 해당하는 것만 처리
                        AND    B.MASTER_ID = @v_master_id
                        AND    B.PLAN_ID = @v_plan_id
) A
                     , SY_SCM_ITEM_LINE_ASSIGN_M B
                        LEFT  OUTER JOIN SY_SCM_TACT_TIME_M C
                              ON     B.COMPANY_ID = C.COMPANY_ID
                              AND    B.DIVISION_ID = C.DIVISION_ID
                              AND    B.SITE_ID = C.SITE_ID
                              AND    B.PLANT_ID = C.PLANT_ID
                              AND    B.ITEM_ID = C.ITEM_ID
                              AND    B.OPERATION_ID = C.OPERATION_ID
                              AND    B.FACTORY_ID = C.FACTORY_ID
                              AND    B.LINE_ID = C.LINE_ID
                              AND    B.ELECTRODE_TYPE = B.ELECTRODE_TYPE
                              AND    B.MONTH = C.MONTH
                        LEFT  OUTER JOIN SY_SCM_YIELD_M D
                              ON     1=1
                              AND    B.COMPANY_ID = D.COMPANY_ID
                              AND    B.DIVISION_ID = D.DIVISION_ID
                              AND    B.SITE_ID = D.SITE_ID
                              AND    B.PLANT_ID = D.PLANT_ID
                              AND    B.ITEM_ID = D.ITEM_ID
                              AND    B.OPERATION_ID = D.OPERATION_ID
                              AND    B.FACTORY_ID = D.FACTORY_ID
                              AND    B.LINE_ID = D.LINE_ID
                              AND    B.MONTH = D.MONTH
                WHERE  1=1
                AND    A.COMPANY_ID = B.COMPANY_ID
                AND    A.DIVISION_ID = B.DIVISION_ID
                AND    A.SITE_ID = B.SITE_ID
                AND    A.PLANT_ID = B.PLANT_ID
                AND    A.FACTORY_ID = B.FACTORY_ID
                AND    A.ITEM_ID = B.ITEM_ID
                AND    A.OPERATION_ID = B.OPERATION_ID
                AND    B.ACTIVE_FLAG = 'Y'
                AND    B.MONTH BETWEEN CONVERT(nvarchar(6), CONVERT(DATE, @plan_start_time), 112) 
                                   AND CONVERT(nvarchar(6), CONVERT(DATE, @plan_end_time), 112)
               ) AA,
               SY_SCM_ITEM_M BB
        WHERE  AA.COMPANY_ID = BB.COMPANY_ID
        AND    AA.DIVISION_ID = BB.DIVISION_ID
        AND    AA.SITE_ID = BB.SITE_ID
        AND    AA.ITEM_ID = BB.ITEM_ID

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END

      BEGIN
      
        SET @v_table_name = 'TH_MST_ITEM_LANE'
        
        DELETE FROM TH_MST_ITEM_LANE
        WHERE   MASTER_ID   = @v_master_id
        AND     PLAN_ID     = @v_plan_id
        
        INSERT INTO TH_MST_ITEM_LANE
              (
               MASTER_ID,PLAN_ID,COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,FACTORY_ID,
               ITEM_ID,LINE_ID,OPERATION_ID,OPERATION_SEQ,ELECTRODE_TYPE,LANE_QTY,MAIN_LANE_QTY,SUB_LANE_QTY,
               PATTERN_QTY,HALF_SLIT_FLAG,
               LINE_LANE_QTY, ITEM_LANE_QTY,
               PRIORITY,
               TACT_TIME,
               TACT_TIME_UOM,
               YIELD,
               COATED_LENGTH,UNCOATED_LENGTH,LENGTH_UOM,
               SLURRY_LOSS_RATE,
               LANE_TACT_QTY,
               LANE_TACT_TIME
              , KEY_DATE
              , INSERT_ID
              , INSERT_DTTM
              , UPDATE_ID
              , UPDATE_DTTM
              )
        SELECT MASTER_ID,PLAN_ID,COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,FACTORY_ID,
               ITEM_ID,LINE_ID,OPERATION_ID,OPERATION_SEQ,ELECTRODE_TYPE,LANE_QTY,MAIN_LANE_QTY,SUB_LANE_QTY,
               PATTERN_QTY,HALF_SLIT_FLAG,
               MAX(LINE_LANE_QTY) AS LINE_LANE_QTY, 
               MAX(ITEM_LANE_QTY) AS ITEM_LANE_QTY,
               MIN(PRIORITY) AS PRIORITY,
               MAX(TACT_TIME) AS TACT_TIME,
               MAX(TACT_TIME_UOM) AS TACT_TIME_UOM,
               MIN(YIELD) AS YIELD,
               MAX(COATED_LENGTH) AS COATED_LENGTH,
               MAX(UNCOATED_LENGTH) AS UNCOATED_LENGTH,
               MAX(LENGTH_UOM) AS LENGTH_UOM,
               MAX(SLURRY_LOSS_RATE) AS SLURRY_LOSS_RATE,
               MAX(LANE_TACT_QTY) AS LANE_TACT_QTY,
               MAX(LANE_TACT_TIME) AS LANE_TACT_TIME
              , @key_date AS KEY_DATE
              , @v_proc_name as INSERT_ID
              , GETDATE() as INSERT_DTTM
              , @v_proc_name as UPDATE_ID
              , getdate() as UPDATE_DTTM
        FROM   TH_MST_ITEM_LANE_CAL
        WHERE  1=1
        AND    MASTER_ID = @v_master_id
        AND    PLAN_ID = @v_plan_id
        GROUP  BY MASTER_ID,PLAN_ID,COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,FACTORY_ID,
                  ITEM_ID,LINE_ID,OPERATION_ID,OPERATION_SEQ,ELECTRODE_TYPE,LANE_QTY,MAIN_LANE_QTY,SUB_LANE_QTY,
                  PATTERN_QTY,HALF_SLIT_FLAG

        SET @n_row_count = @@ROWCOUNT
              
        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END

      -- 투입공정이 동일 OPERATION 의 다른 INSTANCE 일 경우 해당 정보 설정
      -- 해당 item 에 대해 자재 설정 및 item bod 설정 (?)
      -- site 설정, item_bod 설정 등을 해보자. ㅋ
      /*
      
      SELECT *
      FROM   (
              SELECT A.*,
                     ROW_NUMBER() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID
                                          ORDER   BY A.OPERATION_SEQ DESC) SEQ
              FROM   TH_MST_INSTANCE_FLOW A,
                     (
                      SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, MIN(OPERATION_SEQ) AS OPERATION_SEQ
                      FROM   TH_MST_ITEM_LANE A
                      WHERE  A.MASTER_ID = @v_master_id
                      AND    A.PLAN_ID = @v_plan_id
                      GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID
                     ) B
              WHERE  1=1
              AND    A.MASTER_ID = @V_MASTER_ID
              AND    A.PLAN_ID = @V_PLAN_ID
              AND    A.COMPANY_ID = B.COMPANY_ID
              AND    A.DIVISION_ID = B.DIVISION_ID
              AND    A.SITE_ID = B.SITE_ID
              AND    A.PLANT_ID = B.PLANT_ID
              AND    A.FACTORY_ID = B.FACTORY_ID
              AND    A.ITEM_ID = B.ITEM_ID
              AND    A.OPERATION_SEQ < B.OPERATION_SEQ
             ) A
      WHERE  SEQ = 1

      */
      
          
    END;
    
    IF @@TRANCOUNT > 0
      COMMIT WORK 
      
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
