CREATE PROCEDURE [dbo].[PR_SCM_IF_SETUP]
   @p_master_id nvarchar(max) = '-',
   @p_plan_id nvarchar(max) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_IF_SETUP                                                           **/
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
  EXEC PR_SCM_IF_SETUP
  
  SETUP 관련 TABLE
  1. SETUP CATEGORY 
      select * from SY_SCM_SYS_LOOKUP_TYPE_M where lookup_type_code = 'SETUP_CATEGORY'
      select * from SY_SCM_SYS_LOOKUP_VALUE  where lookup_type_code = 'SETUP_CATEGORY' ORDER BY SORT_ORDER
  2. ITEM ATTRIBUTE
      select * from SY_SCM_SYS_LOOKUP_TYPE_M where lookup_type_code = 'ITEM_ATTRIBUTE'
      select * from SY_SCM_SYS_LOOKUP_VALUE  where lookup_type_code = 'ITEM_ATTRIBUTE'
  3. SETUP ATTRIBUTE
      select * from SY_SCM_SYS_LOOKUP_TYPE_M where lookup_type_code = 'SETUP_ATTRIBUTE'
      select * from SY_SCM_SYS_LOOKUP_VALUE  where lookup_type_code = 'SETUP_ATTRIBUTE'
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
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_IF_SETUP'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code        nvarchar(10)
  
  DECLARE @sysdate          DATETIME2 = GETDATE()
  DECLARE @key_date         nvarchar(8)

  DECLARE @v_temp1        nvarchar(1000)
  DECLARE @v_temp2        nvarchar(1000)
  
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
              @v_daydiff = DAYDIFF,
              @key_date = PLAN_DATE
      FROM   (
              SELECT PLAN_START_DTTM,
                     CASE WHEN PLAN_HORIZON_UOM = 'DAY'   THEN DATEADD(DD, PLAN_HORIZON,     PLAN_START_DTTM)
                          WHEN PLAN_HORIZON_UOM = 'WEEK'  THEN DATEADD(DD, PLAN_HORIZON * 7, PLAN_START_DTTM)
                          WHEN PLAN_HORIZON_UOM = 'MONTH' THEN DATEADD(MM, PLAN_HORIZON ,    PLAN_START_DTTM)
                     END  PLAN_END_DTTM,
                     DATEDIFF(MINUTE,CONVERT(DATE,PLAN_START_DTTM), PLAN_START_DTTM) AS DAYDIFF,
                     PLAN_DATE
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
    
      SET @v_table_name = 'TH_BUF_SCM_SETUP_BOM'
      SET @n_row_count = 0
      
      /* 
      SETUP CATEGORY 가 MATERIAL 일 경우 BOM 을 전개해야함.
      SETUP 을 설정해야할 OPERATION 과 SETUP 정보를 참조할 참조 OPERATION 이 다르게 때문이다.
      그래서 BOM 을 1차 전개한 정보를 TH_BUF_SCM_SETUP_BOM 에 넣고, 이걸 재귀참고하여 참조OPERATION 을 찾는다.
      */
      DELETE FROM TH_BUF_SCM_SETUP_BOM
      
      INSERT INTO TH_BUF_SCM_SETUP_BOM
      SELECT DISTINCT
             A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, 
             A.PARENT_ITEM_ID, B.OPERATION_ID, A.CHILD_ITEM_ID, C.ITEM_TYPE, 
             D.LEVEL_2_CODE AS SETUP_KEY_ID, C.SETUP_ATTRIBUTE, C.ITEM_ATTRIBUTE
      FROM   (
              SELECT DISTINCT
                     AA.COMPANY_ID, AA.DIVISION_ID, AA.SITE_ID, AA.PARENT_ITEM_ID, AA.CHILD_ITEM_ID
              FROM   SY_SCM_BOM_M AA,
                     (
                      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID,
                             MAX(KEY_DATE) AS KEY_DATE
                      FROM   SY_SCM_BOM_M         A,
                             SY_SCM_ITEM_M        B,
                             SY_SCM_ITEM_CLASS_M  C
                      WHERE  1=1
                      AND    A.ACTIVE_FLAG    = 'Y'
                      AND    A.COMPANY_ID     = B.COMPANY_ID
                      AND    A.DIVISION_ID    = B.DIVISION_ID
                      AND    A.SITE_ID        = B.SITE_ID
                      AND    A.CHILD_ITEM_ID  = B.ITEM_ID  
                      AND    B.ACTIVE_FLAG    = 'Y'
                      AND    B.ITEM_CLASS     = C.CLASS_ID  
                      AND    C.USE_FLAG       = 'Y'      
                      AND    A.BOM_VERSION_ID = '1'
                      AND    A.EFF_END_DATE   >  GETDATE()
                      GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID
                     ) BB
              WHERE  AA.COMPANY_ID      = BB.COMPANY_ID
              AND    AA.DIVISION_ID     = BB.DIVISION_ID
              AND    AA.SITE_ID         = BB.SITE_ID
              AND    AA.PLANT_ID        = BB.PLANT_ID
              AND    AA.PARENT_ITEM_ID  = BB.PARENT_ITEM_ID
              AND    AA.CHILD_ITEM_ID   = BB.CHILD_ITEM_ID
              AND    AA.KEY_DATE        = BB.KEY_DATE
              AND    AA.ACTIVE_FLAG     = 'Y'
              AND    AA.BOM_VERSION_ID = '1'
              AND    AA.EFF_END_DATE   >  GETDATE()
             ) A,
             TH_MST_INSTANCE_FLOW B,
             SY_SCM_ITEM_M        C,
             SY_SCM_ITEM_CLASS_M  D
      WHERE  1=1
      AND    B.MASTER_ID = @v_master_id
      AND    B.PLAN_ID = @v_plan_id
      AND    A.COMPANY_ID = B.COMPANY_ID
      AND    A.DIVISION_ID = B.DIVISION_ID
      AND    A.SITE_ID = B.SITE_ID
      AND    A.PARENT_ITEM_ID = B.ITEM_ID 
      AND    A.COMPANY_ID = C.COMPANY_ID
      AND    A.DIVISION_ID = C.DIVISION_ID
      AND    A.SITE_ID = C.SITE_ID
      AND    A.CHILD_ITEM_ID = C.ITEM_ID
      AND    C.ACTIVE_FLAG = 'Y'
      AND    C.ITEM_CLASS = D.CLASS_ID
      AND    D.USE_FLAG = 'Y'
      AND    EXISTS ( SELECT 1
                      FROM   TH_MST_INSTANCE_FLOW X
                      WHERE  X.MASTER_ID = @v_master_id
                      AND    X.PLAN_ID = @v_plan_id
                      AND    A.COMPANY_ID = X.COMPANY_ID
                      AND    A.DIVISION_ID = X.DIVISION_ID
                      AND    A.SITE_ID = X.SITE_ID
                      --AND    A.PLANT_ID = X.PLANT_ID
                      AND    A.PARENT_ITEM_ID = X.ITEM_ID
                      AND    B.OPERATION_ID = X.OPERATION_ID)

      SET @n_row_count += @@ROWCOUNT

      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
    
    END
    
    -- setup category 가 MATERIAL 인 것에 대해 data 추출
    -- bom 을 전개하여 실제 setup 반영될 item attribute list 정보를 추출하는 부분
    BEGIN

      SET @v_table_name = 'TH_BUF_SCM_SETUP_ITEM_LIST'
      SET @n_row_count = 0
      
      DELETE FROM TH_BUF_SCM_SETUP_ITEM_LIST

      INSERT INTO TH_BUF_SCM_SETUP_ITEM_LIST
      SELECT DISTINCT
             A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.SETUP_CATEGORY_ID,
             A.SETUP_KEY_ID, A.LEVEL, 
             A.KEY_ITEM_ID, 
             A.KEY_OPERATION_ID,
             A.CALCULATION,
             '' SETUP_ATTRIBUTE,
             A.ITEM_ATTRIBUTE
      FROM   (
              SELECT AA.COMPANY_ID, AA.DIVISION_ID, AA.SITE_ID, 
                     AA.SETUP_CATEGORY_ID, AA.SETUP_KEY_ID, AA.LEVEL, 
                     AA.REFERANCE_OPERATION_ID, AA.CALCULATION, AA.SORT_ORDER,
                     AA.KEY_ITEM_ID, AA.KEY_OPERATION_ID,
                     CASE WHEN OPERATION_ID_1 = AA.REFERANCE_OPERATION_ID THEN SETUP_ATTRIBUTE_2
                          WHEN OPERATION_ID_2 = AA.REFERANCE_OPERATION_ID THEN SETUP_ATTRIBUTE_3
                          ELSE ''
                     END  SETUP_ATTRIBUTE,
                     CASE WHEN OPERATION_ID_1 = AA.REFERANCE_OPERATION_ID THEN ITEM_ATTRIBUTE_2
                          WHEN OPERATION_ID_2 = AA.REFERANCE_OPERATION_ID THEN ITEM_ATTRIBUTE_3
                          ELSE ''
                     END  ITEM_ATTRIBUTE
              FROM   (
                      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, 
                             A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, 
                             A.REFERANCE_OPERATION_ID, A.CALCULATION, A.SORT_ORDER,
                             A.KEY_ITEM_ID, A.KEY_OPERATION_ID, 
                             A.ITEM_ID_1, A.OPERATION_ID_1, A.ITEM_TYPE_1, A.SETUP_ATTRIBUTE_1, A.ITEM_ATTRIBUTE_1,
                             A.ITEM_ID_2, C.OPERATION_ID AS OPERATION_ID_2, A.ITEM_TYPE_2, A.SETUP_ATTRIBUTE_2, A.ITEM_ATTRIBUTE_2,
                             C.CHILD_ITEM_ID ITEM_ID_3, C.ITEM_TYPE ITEM_TYPE_3, C.SETUP_ATTRIBUTE SETUP_ATTRIBUTE_3, C.ITEM_ATTRIBUTE ITEM_ATTRIBUTE_3
                      FROM   (                
                              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, 
                                     A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, 
                                     A.REFERANCE_OPERATION_ID, A.CALCULATION, A.SORT_ORDER,
                                     A.KEY_ITEM_ID, A.KEY_OPERATION_ID, A.ITEM_ID_1, B.OPERATION_ID OPERATION_ID_1, A.ITEM_TYPE_1, A.SETUP_ATTRIBUTE_1, A.ITEM_ATTRIBUTE_1,
                                     B.CHILD_ITEM_ID ITEM_ID_2, B.ITEM_TYPE ITEM_TYPE_2, B.SETUP_ATTRIBUTE SETUP_ATTRIBUTE_2, B.ITEM_ATTRIBUTE ITEM_ATTRIBUTE_2
                              FROM   (
                                      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, 
                                             B.SETUP_CATEGORY_ID, B.SETUP_KEY_ID, B.LEVEL, 
                                             B.REFERANCE_OPERATION_ID, B.CALCULATION, B.SORT_ORDER,                                
                                             A.PARENT_ITEM_ID AS KEY_ITEM_ID, 
                                             A.OPERATION_ID AS KEY_OPERATION_ID, 
                                             -- OPERATION_ID 와 REFERANCE_OPERATION_ID 가 동일할 경우 발생
                                             CASE B.OPERATION_ID 
                                                WHEN B.REFERANCE_OPERATION_ID THEN A.PARENT_ITEM_ID
                                                                              ELSE A.CHILD_ITEM_ID 
                                             END  ITEM_ID_1, 
                                             A.ITEM_TYPE ITEM_TYPE_1, A.SETUP_ATTRIBUTE SETUP_ATTRIBUTE_1, A.ITEM_ATTRIBUTE ITEM_ATTRIBUTE_1
                                      FROM   TH_BUF_SCM_SETUP_BOM A,
                                             (
                                              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, 
                                                     A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, 
                                                     A.REFERANCE_OPERATION_ID, A.CALCULATION, B.SORT_ORDER
                                              FROM   SY_SCM_ITEM_SETUP_GROUP_M  A,
                                                     SY_SCM_SYS_LOOKUP_VALUE    B
                                              WHERE  B.LOOKUP_TYPE_CODE = 'SETUP_CATEGORY'
                                              AND    UPPER(A.SETUP_CATEGORY_ID) = UPPER('MATERIAL')
                                              AND    A.SETUP_CATEGORY_ID = B.SEGMENT1
                                              --AND    A.OPERATION_ID != A.REFERANCE_OPERATION_ID
                                              GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, 
                                                        A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, 
                                                        A.REFERANCE_OPERATION_ID, A.CALCULATION, B.SORT_ORDER
                                             ) B
                                      WHERE  A.COMPANY_ID = B.COMPANY_ID
                                      AND    A.DIVISION_ID = B.DIVISION_ID
                                      AND    A.SITE_ID = B.SITE_ID
                                      AND    A.OPERATION_ID = B.OPERATION_ID             -- 
                                     ) A
                                     LEFT OUTER JOIN TH_BUF_SCM_SETUP_BOM B
                                          ON     1=1
                                          AND    A.COMPANY_ID = B.COMPANY_ID
                                          AND    A.DIVISION_ID = B.DIVISION_ID
                                          AND    A.SITE_ID = B.SITE_ID
                                          AND    A.ITEM_ID_1 = B.PARENT_ITEM_ID
                                          AND    A.SETUP_KEY_ID = B.SETUP_KEY_ID    
                             ) A
                             LEFT OUTER JOIN TH_BUF_SCM_SETUP_BOM C
                                  ON     1=1
                                  AND    A.COMPANY_ID = C.COMPANY_ID
                                  AND    A.DIVISION_ID = C.DIVISION_ID
                                  AND    A.SITE_ID = C.SITE_ID
                                  AND    A.ITEM_ID_2 = C.PARENT_ITEM_ID
                                  AND    A.SETUP_KEY_ID = C.SETUP_KEY_ID
                     ) AA
             ) A
        WHERE  EXISTS (
                        SELECT 1
                        FROM   SY_SCM_SYS_LOOKUP_VALUE B
                        WHERE  B.LOOKUP_TYPE_CODE = 'ITEM_ATTRIBUTE'
                        AND    A.SETUP_KEY_ID = B.SEGMENT3
                        AND    A.DIVISION_ID = B.SEGMENT1
                        AND    A.SITE_ID = B.SEGMENT2
                        AND    A.ITEM_ATTRIBUTE = B.SEGMENT4
                      )
    
      SET @n_row_count += @@ROWCOUNT

      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
    END
    
    /* 각각 item 에 대해 item_attribute_combine 정보를 추출하는 부분
    */
    BEGIN

      SET @v_table_name = 'TH_BUF_SCM_SETUP_ITEM_COMBINE'
      SET @n_row_count = 0
      
      DELETE FROM TH_BUF_SCM_SETUP_ITEM_COMBINE

      insert into TH_BUF_SCM_SETUP_ITEM_COMBINE
      SELECT DISTINCT
             A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, 
             A.ITEM_ID, A.OPERATION_ID, A.CALCULATION, A.ITEM_SETUP_GROUP_ID
      FROM   (
              SELECT DISTINCT
                     A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, 
                     A.ITEM_ID, A.OPERATION_ID, A.CALCULATION,
                     B.SEGMENT4 AS ITEM_SETUP_GROUP_ID,
                     A.CNT, A.SEQ, B.SEGMENT4_CNT, SEGMENT4_SEQ,
                     COUNT(1) OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.SETUP_KEY_ID, 
                                                 A.LEVEL, A.ITEM_ID, A.OPERATION_ID, A.CALCULATION, B.SEGMENT4) COMBINE_CNT
              FROM   (
                      SELECT A.*,
                             COUNT(1) OVER (PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID, ITEM_ID, SETUP_KEY_ID) CNT,
                             ROW_NUMBER() OVER (PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID, ITEM_ID, SETUP_KEY_ID ORDER BY ITEM_ATTRIBUTE) SEQ       
                      FROM   TH_BUF_SCM_SETUP_ITEM_LIST A
                     ) A,
                     (
                      SELECT A.*,
                             COUNT(1) OVER (PARTITION BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4) SEGMENT4_CNT,
                             ROW_NUMBER() OVER (PARTITION BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4 ORDER BY ITEM_ATTRIBUTE) SEGMENT4_SEQ
                      FROM   (
                              select SEGMENT1,
                                     SEGMENT2,
                                     SEGMENT3,
                                     SEGMENT4,
                                     CASE WHEN INT = 1 THEN CASE WHEN ISNULL(LTRIM(RTRIM(ATTRIBUTE1)),'') = '' THEN '' ELSE ATTRIBUTE1 END
                                          WHEN INT = 2 THEN CASE WHEN ISNULL(LTRIM(RTRIM(ATTRIBUTE2)),'') = '' THEN '' ELSE ATTRIBUTE2 END
                                          WHEN INT = 3 THEN CASE WHEN ISNULL(LTRIM(RTRIM(ATTRIBUTE3)),'') = '' THEN '' ELSE ATTRIBUTE3 END
                                          WHEN INT = 4 THEN CASE WHEN ISNULL(LTRIM(RTRIM(ATTRIBUTE4)),'') = '' THEN '' ELSE ATTRIBUTE4 END
                                          WHEN INT = 5 THEN CASE WHEN ISNULL(LTRIM(RTRIM(ATTRIBUTE5)),'') = '' THEN '' ELSE ATTRIBUTE5 END
                                          ELSE ''
                                     END  ITEM_ATTRIBUTE
                              from   SY_SCM_SYS_LOOKUP_VALUE A,
                                     COPYT B
                              where  lookup_type_code = 'ITEM_ATTRIBUTE_COMBINE'
                              AND    INT <= 5
                             ) A
                      WHERE  ITEM_ATTRIBUTE != ''
                     ) B
              WHERE  A.DIVISION_ID = B.SEGMENT1
              AND    A.SITE_ID = B.SEGMENT2
              AND    A.SETUP_KEY_ID = B.SEGMENT3
              AND    A.ITEM_ATTRIBUTE = B.ITEM_ATTRIBUTE
              AND    A.CNT = B.SEGMENT4_CNT
              AND    A.SEQ = B.SEGMENT4_SEQ    
             ) A
      WHERE  SEGMENT4_CNT = COMBINE_CNT
    
      SET @n_row_count = @@ROWCOUNT

      --LOG 생성
      SET @v_message = 'SETUP_CATEGORY_ID : MATERIAL (COMBINE) - INSERT COUNT : ' + CONVERT(nvarchar, @n_row_count)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      insert into TH_BUF_SCM_SETUP_ITEM_COMBINE
      SELECT DISTINCT
             A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, 
             A.ITEM_ID, A.OPERATION_ID, A.CALCULATION,
             A.ITEM_ATTRIBUTE AS ITEM_SETUP_GROUP_ID      
      FROM   TH_BUF_SCM_SETUP_ITEM_LIST A
      WHERE  A.ITEM_ATTRIBUTE != ''
      AND    NOT EXISTS (
                          SELECT 1
                          FROM   TH_BUF_SCM_SETUP_ITEM_COMBINE B
                          WHERE  A.COMPANY_ID = B.COMPANY_ID
                          AND    A.DIVISION_ID = B.DIVISION_ID
                          AND    A.SITE_ID = B.SITE_ID
                          AND    A.SETUP_CATEGORY_ID = B.SETUP_CATEGORY_ID
                          AND    A.SETUP_KEY_ID = B.SETUP_KEY_ID
                          AND    A.ITEM_ID = B.ITEM_ID
                          AND    A.OPERATION_ID = B.OPERATION_ID
                        )
                        
                        
      SET @n_row_count = @@ROWCOUNT

      --LOG 생성
      SET @v_message = 'SETUP_CATEGORY_ID : MATERIAL (SINGLE) - INSERT COUNT : ' + CONVERT(nvarchar, @n_row_count)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

      
      INSERT INTO TH_BUF_SCM_SETUP_ITEM_COMBINE
      SELECT DISTINCT A.*
      FROM   (
              SELECT DISTINCT
                     A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, 
                     A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, 
                     B.ITEM_ID, B.OPERATION_ID, A.CALCULATION,
                     C.SETUP_ATTRIBUTE AS ITEM_SETUP_GROUP_ID         
              FROM   (
                      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, 
                             A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, 
                             A.REFERANCE_OPERATION_ID, A.CALCULATION, B.SORT_ORDER
                      FROM   SY_SCM_ITEM_SETUP_GROUP_M  A,
                             SY_SCM_SYS_LOOKUP_VALUE    B
                      WHERE  B.LOOKUP_TYPE_CODE = 'SETUP_CATEGORY'
                      AND    UPPER(A.SETUP_CATEGORY_ID) = UPPER('ATTRIBUTE')
                      AND    A.SETUP_CATEGORY_ID = B.SEGMENT1
                      AND    A.OPERATION_ID != A.REFERANCE_OPERATION_ID
                      GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, 
                                A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, 
                                A.REFERANCE_OPERATION_ID, A.CALCULATION, B.SORT_ORDER
                     ) A,
                     SY_SCM_ITEM_FLOW_V B,
                     SY_SCM_ITEM_M      C
              WHERE  A.COMPANY_ID = B.COMPANY_ID
              AND    A.DIVISION_ID = B.DIVISION_ID
              AND    A.SITE_ID = B.SITE_ID
              AND    A.OPERATION_ID = B.OPERATION_ID
              AND    A.COMPANY_ID = C.COMPANY_ID
              AND    A.DIVISION_ID = C.DIVISION_ID
              AND    A.SITE_ID = C.SITE_ID
              AND    B.ITEM_ID = C.ITEM_ID
              AND    ISNULL(C.SETUP_ATTRIBUTE, '') != ''
              AND    C.ACTIVE_FLAG = 'Y'
             ) A
      WHERE  1=1
      AND    EXISTS ( SELECT 1
                      FROM   TH_MST_INSTANCE_FLOW X
                      WHERE  1=1
                      AND    X.MASTER_ID = @v_master_id
                      AND    X.PLAN_ID = @v_plan_id
                      AND    A.COMPANY_ID = X.COMPANY_ID
                      AND    A.DIVISION_ID = X.DIVISION_ID
                      AND    A.SITE_ID = X.SITE_ID
                      AND    A.ITEM_ID = X.ITEM_ID
                      AND    A.OPERATION_ID = X.OPERATION_ID)

      SET @n_row_count = @@ROWCOUNT

      --LOG 생성
      SET @v_message = 'SETUP_CATEGORY_ID : ATTRIBUTE - INSERT COUNT : ' + CONVERT(nvarchar, @n_row_count)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null


      INSERT INTO TH_BUF_SCM_SETUP_ITEM_COMBINE
      SELECT DISTINCT A.*
      FROM   (
              SELECT DISTINCT
                     A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, 
                     A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, 
                     B.ITEM_ID, B.OPERATION_ID, A.CALCULATION,
                     B.ITEM_ID AS ITEM_SETUP_GROUP_ID         
              FROM   (
                      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, 
                             A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, 
                             A.REFERANCE_OPERATION_ID, A.CALCULATION, B.SORT_ORDER
                      FROM   SY_SCM_ITEM_SETUP_GROUP_M  A,
                             SY_SCM_SYS_LOOKUP_VALUE    B
                      WHERE  B.LOOKUP_TYPE_CODE = 'SETUP_CATEGORY'
                      AND    UPPER(A.SETUP_CATEGORY_ID) = UPPER('ITEM')
                      AND    A.SETUP_CATEGORY_ID = B.SEGMENT1
                      AND    A.OPERATION_ID != A.REFERANCE_OPERATION_ID
                      GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, 
                                A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, 
                                A.REFERANCE_OPERATION_ID, A.CALCULATION, B.SORT_ORDER
                     ) A,
                     SY_SCM_ITEM_FLOW_V B
              WHERE  A.COMPANY_ID = B.COMPANY_ID
              AND    A.DIVISION_ID = B.DIVISION_ID
              AND    A.SITE_ID = B.SITE_ID
              AND    A.OPERATION_ID = B.OPERATION_ID
             ) A
      WHERE  1=1
      AND    EXISTS ( SELECT 1
                      FROM   TH_MST_INSTANCE_FLOW X
                      WHERE  1=1
                      AND    X.MASTER_ID = @v_master_id
                      AND    X.PLAN_ID = @v_plan_id
                      AND    A.COMPANY_ID = X.COMPANY_ID
                      AND    A.DIVISION_ID = X.DIVISION_ID
                      AND    A.SITE_ID = X.SITE_ID
                      AND    A.ITEM_ID = X.ITEM_ID
                      AND    A.OPERATION_ID = X.OPERATION_ID)

      SET @n_row_count = @@ROWCOUNT

      --LOG 생성
      SET @v_message = 'SETUP_CATEGORY_ID : ITEM      - INSERT COUNT : ' + CONVERT(nvarchar, @n_row_count)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

    END

    /* 위 COMBIME 테이블 정보를 기준으로 LEVEL 순서대로 SETUP 정보를 GROUPING 한다. */
    BEGIN


      SET @v_table_name = 'TH_BUF_SCM_SETUP_ITEM'
      SET @n_row_count = 0
      
      DELETE FROM TH_BUF_SCM_SETUP_ITEM

      INSERT INTO TH_BUF_SCM_SETUP_ITEM
            (
             COMPANY_ID, DIVISION_ID, SITE_ID, ITEM_ID, OPERATION_ID, LINE_SETUP_GROUP_ID, SETUP_GROUP_ID,
             S_GRP_01, S_GRP_02, S_GRP_03, S_GRP_04, S_GRP_05, S_GRP_06, S_GRP_07, S_GRP_08, S_GRP_09, S_GRP_10,
             S_CAT_01, S_CAT_02, S_CAT_03, S_CAT_04, S_CAT_05, S_CAT_06, S_CAT_07, S_CAT_08, S_CAT_09, S_CAT_10,
             S_KEY_01, S_KEY_02, S_KEY_03, S_KEY_04, S_KEY_05, S_KEY_06, S_KEY_07, S_KEY_08, S_KEY_09, S_KEY_10,
             S_CAL_01, S_CAL_02, S_CAL_03, S_CAL_04, S_CAL_05, S_CAL_06, S_CAL_07, S_CAL_08, S_CAL_09, S_CAL_10             
            )
      SELECT DISTINCT
             A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
             (  CASE WHEN MAX_LEVEL >=  1 THEN S_GRP_01 ELSE '' END + CASE WHEN MAX_LEVEL >  1 THEN '##' ELSE '' END
              + CASE WHEN MAX_LEVEL >=  2 THEN S_GRP_02 ELSE '' END + CASE WHEN MAX_LEVEL >  2 THEN '##' ELSE '' END
              + CASE WHEN MAX_LEVEL >=  3 THEN S_GRP_03 ELSE '' END + CASE WHEN MAX_LEVEL >  3 THEN '##' ELSE '' END
              + CASE WHEN MAX_LEVEL >=  4 THEN S_GRP_04 ELSE '' END + CASE WHEN MAX_LEVEL >  4 THEN '##' ELSE '' END
              + CASE WHEN MAX_LEVEL >=  5 THEN S_GRP_05 ELSE '' END + CASE WHEN MAX_LEVEL >  5 THEN '##' ELSE '' END
              + CASE WHEN MAX_LEVEL >=  6 THEN S_GRP_06 ELSE '' END + CASE WHEN MAX_LEVEL >  6 THEN '##' ELSE '' END
              + CASE WHEN MAX_LEVEL >=  7 THEN S_GRP_07 ELSE '' END + CASE WHEN MAX_LEVEL >  7 THEN '##' ELSE '' END
              + CASE WHEN MAX_LEVEL >=  8 THEN S_GRP_08 ELSE '' END + CASE WHEN MAX_LEVEL >  8 THEN '##' ELSE '' END
              + CASE WHEN MAX_LEVEL >=  9 THEN S_GRP_09 ELSE '' END + CASE WHEN MAX_LEVEL >  9 THEN '##' ELSE '' END
              + CASE WHEN MAX_LEVEL >= 10 THEN S_GRP_10 ELSE '' END + CASE WHEN MAX_LEVEL > 10 THEN '##' ELSE '' END
             ) AS SETUP_GROUP_ID,
             S_GRP_01, S_GRP_02, S_GRP_03, S_GRP_04, S_GRP_05, S_GRP_06, S_GRP_07, S_GRP_08, S_GRP_09, S_GRP_10,
             S_CAT_01, S_CAT_02, S_CAT_03, S_CAT_04, S_CAT_05, S_CAT_06, S_CAT_07, S_CAT_08, S_CAT_09, S_CAT_10,
             S_KEY_01, S_KEY_02, S_KEY_03, S_KEY_04, S_KEY_05, S_KEY_06, S_KEY_07, S_KEY_08, S_KEY_09, S_KEY_10,
             S_CAL_01, S_CAL_02, S_CAL_03, S_CAL_04, S_CAL_05, S_CAL_06, S_CAL_07, S_CAL_08, S_CAL_09, S_CAL_10             
      FROM   (
              select A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.OPERATION_ID, A.LINE_SETUP_GROUP_ID, A.MAX_LEVEL, 
                     MAX(S_GRP_01) AS S_GRP_01,
                     MAX(S_GRP_02) AS S_GRP_02,
                     MAX(S_GRP_03) AS S_GRP_03,
                     MAX(S_GRP_04) AS S_GRP_04,
                     MAX(S_GRP_05) AS S_GRP_05,
                     MAX(S_GRP_06) AS S_GRP_06,
                     MAX(S_GRP_07) AS S_GRP_07,
                     MAX(S_GRP_08) AS S_GRP_08,
                     MAX(S_GRP_09) AS S_GRP_09,
                     MAX(S_GRP_10) AS S_GRP_10,
                     --
                     MAX(S_CAT_01) AS S_CAT_01,
                     MAX(S_CAT_02) AS S_CAT_02,
                     MAX(S_CAT_03) AS S_CAT_03,
                     MAX(S_CAT_04) AS S_CAT_04,
                     MAX(S_CAT_05) AS S_CAT_05,
                     MAX(S_CAT_06) AS S_CAT_06,
                     MAX(S_CAT_07) AS S_CAT_07,
                     MAX(S_CAT_08) AS S_CAT_08,
                     MAX(S_CAT_09) AS S_CAT_09,
                     MAX(S_CAT_10) AS S_CAT_10,
                     --
                     MAX(S_KEY_01) AS S_KEY_01,
                     MAX(S_KEY_02) AS S_KEY_02,
                     MAX(S_KEY_03) AS S_KEY_03,
                     MAX(S_KEY_04) AS S_KEY_04,
                     MAX(S_KEY_05) AS S_KEY_05,
                     MAX(S_KEY_06) AS S_KEY_06,
                     MAX(S_KEY_07) AS S_KEY_07,
                     MAX(S_KEY_08) AS S_KEY_08,
                     MAX(S_KEY_09) AS S_KEY_09,
                     MAX(S_KEY_10) AS S_KEY_10,
                     --
                     MAX(S_CAL_01) AS S_CAL_01,
                     MAX(S_CAL_02) AS S_CAL_02,
                     MAX(S_CAL_03) AS S_CAL_03,
                     MAX(S_CAL_04) AS S_CAL_04,
                     MAX(S_CAL_05) AS S_CAL_05,
                     MAX(S_CAL_06) AS S_CAL_06,
                     MAX(S_CAL_07) AS S_CAL_07,
                     MAX(S_CAL_08) AS S_CAL_08,
                     MAX(S_CAL_09) AS S_CAL_09,
                     MAX(S_CAL_10) AS S_CAL_10                     
              from   (
                      SELECT A.*, INT,
                             CASE WHEN INT =  1 THEN ITEM_SETUP_GROUP_ID ELSE '' END S_GRP_01,
                             CASE WHEN INT =  2 THEN ITEM_SETUP_GROUP_ID ELSE '' END S_GRP_02,
                             CASE WHEN INT =  3 THEN ITEM_SETUP_GROUP_ID ELSE '' END S_GRP_03,
                             CASE WHEN INT =  4 THEN ITEM_SETUP_GROUP_ID ELSE '' END S_GRP_04,
                             CASE WHEN INT =  5 THEN ITEM_SETUP_GROUP_ID ELSE '' END S_GRP_05,
                             CASE WHEN INT =  6 THEN ITEM_SETUP_GROUP_ID ELSE '' END S_GRP_06,
                             CASE WHEN INT =  7 THEN ITEM_SETUP_GROUP_ID ELSE '' END S_GRP_07,
                             CASE WHEN INT =  8 THEN ITEM_SETUP_GROUP_ID ELSE '' END S_GRP_08,
                             CASE WHEN INT =  9 THEN ITEM_SETUP_GROUP_ID ELSE '' END S_GRP_09,
                             CASE WHEN INT = 10 THEN ITEM_SETUP_GROUP_ID ELSE '' END S_GRP_10,
                             --
                             CASE WHEN INT =  1 THEN SETUP_CATEGORY_ID ELSE '' END S_CAT_01,
                             CASE WHEN INT =  2 THEN SETUP_CATEGORY_ID ELSE '' END S_CAT_02,
                             CASE WHEN INT =  3 THEN SETUP_CATEGORY_ID ELSE '' END S_CAT_03,
                             CASE WHEN INT =  4 THEN SETUP_CATEGORY_ID ELSE '' END S_CAT_04,
                             CASE WHEN INT =  5 THEN SETUP_CATEGORY_ID ELSE '' END S_CAT_05,
                             CASE WHEN INT =  6 THEN SETUP_CATEGORY_ID ELSE '' END S_CAT_06,
                             CASE WHEN INT =  7 THEN SETUP_CATEGORY_ID ELSE '' END S_CAT_07,
                             CASE WHEN INT =  8 THEN SETUP_CATEGORY_ID ELSE '' END S_CAT_08,
                             CASE WHEN INT =  9 THEN SETUP_CATEGORY_ID ELSE '' END S_CAT_09,
                             CASE WHEN INT = 10 THEN SETUP_CATEGORY_ID ELSE '' END S_CAT_10,
                             --
                             CASE WHEN INT =  1 THEN SETUP_KEY_ID ELSE '' END S_KEY_01,
                             CASE WHEN INT =  2 THEN SETUP_KEY_ID ELSE '' END S_KEY_02,
                             CASE WHEN INT =  3 THEN SETUP_KEY_ID ELSE '' END S_KEY_03,
                             CASE WHEN INT =  4 THEN SETUP_KEY_ID ELSE '' END S_KEY_04,
                             CASE WHEN INT =  5 THEN SETUP_KEY_ID ELSE '' END S_KEY_05,
                             CASE WHEN INT =  6 THEN SETUP_KEY_ID ELSE '' END S_KEY_06,
                             CASE WHEN INT =  7 THEN SETUP_KEY_ID ELSE '' END S_KEY_07,
                             CASE WHEN INT =  8 THEN SETUP_KEY_ID ELSE '' END S_KEY_08,
                             CASE WHEN INT =  9 THEN SETUP_KEY_ID ELSE '' END S_KEY_09,
                             CASE WHEN INT = 10 THEN SETUP_KEY_ID ELSE '' END S_KEY_10,
                             --
                             CASE WHEN INT =  1 THEN CALCULATION ELSE '' END S_CAL_01,
                             CASE WHEN INT =  2 THEN CALCULATION ELSE '' END S_CAL_02,
                             CASE WHEN INT =  3 THEN CALCULATION ELSE '' END S_CAL_03,
                             CASE WHEN INT =  4 THEN CALCULATION ELSE '' END S_CAL_04,
                             CASE WHEN INT =  5 THEN CALCULATION ELSE '' END S_CAL_05,
                             CASE WHEN INT =  6 THEN CALCULATION ELSE '' END S_CAL_06,
                             CASE WHEN INT =  7 THEN CALCULATION ELSE '' END S_CAL_07,
                             CASE WHEN INT =  8 THEN CALCULATION ELSE '' END S_CAL_08,
                             CASE WHEN INT =  9 THEN CALCULATION ELSE '' END S_CAL_09,
                             CASE WHEN INT = 10 THEN CALCULATION ELSE '' END S_CAL_10                          
                      FROM   (
                              SELECT A.*, B.LINE_SETUP_GROUP_ID,
                                     MAX(LEVEL) OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID) MAX_LEVEL
                              FROM   TH_BUF_SCM_SETUP_ITEM_COMBINE A,
                                     (
                                     SELECT DISTINCT
                                             A.*, B.SETUP_CATEGORY_ID, SETUP_KEY_ID
                                      FROM   (
                                              SELECT COMPANY_ID, DIVISION_ID, SITE_ID, LINE_SETUP_GROUP_ID, OPERATION_ID 
                                              FROM   SY_SCM_SETUP_MATRIX_M
                                              GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, LINE_SETUP_GROUP_ID, OPERATION_ID 
                                             ) A,
                                             (
                                              SELECT COMPANY_ID, DIVISION_ID, SITE_ID, SETUP_CATEGORY_ID, SETUP_KEY_ID, OPERATION_ID 
                                              FROM   SY_SCM_SETUP_MATRIX_M
                                              GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, SETUP_CATEGORY_ID, SETUP_KEY_ID, OPERATION_ID
                                             ) B
                                      WHERE  A.COMPANY_ID = B.COMPANY_ID
                                      AND    A.DIVISION_ID = B.DIVISION_ID
                                      AND    A.SITE_ID = B.SITE_ID
                                      AND    A.OPERATION_ID = B.OPERATION_ID
                                     /*
                                      SELECT COMPANY_ID, DIVISION_ID, SITE_ID, LINE_SETUP_GROUP_ID, SETUP_CATEGORY_ID, SETUP_KEY_ID, OPERATION_ID 
                                      FROM   SY_SCM_SETUP_MATRIX_M
                                      GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, LINE_SETUP_GROUP_ID, SETUP_CATEGORY_ID, SETUP_KEY_ID, OPERATION_ID
                                     */
                                     ) B
                              WHERE  A.COMPANY_ID = B.COMPANY_ID
                              AND    A.DIVISION_ID = B.DIVISION_ID
                              AND    A.SITE_ID = B.SITE_ID
                              AND    A.SETUP_CATEGORY_ID = B.SETUP_CATEGORY_ID
                              AND    A.SETUP_KEY_ID = B.SETUP_KEY_ID
                              AND    A.OPERATION_ID = B.OPERATION_ID
                             ) A,
                             COPYT B
                      WHERE  A.LEVEL = B.INT       
                     ) a
              GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.OPERATION_ID, A.LINE_SETUP_GROUP_ID, A.MAX_LEVEL
             ) A
      --/*
      WHERE  EXISTS ( -- TACT 이 존재하는 ITEM, LINE 만..
                      SELECT 1
                      FROM   (
                              SELECT A.ITEM_ID, A.OPERATION_ID, B.RESOURCE_SETUP_GROUP_ID
                              FROM   TH_MST_OP_RESOURCE A,
                                     TH_MST_RESOURCE B
                              WHERE  A.MASTER_ID    = B.MASTER_ID
                              AND    A.PLAN_ID      = B.PLAN_ID
                              AND    A.RESOURCE_ID  = B.RESOURCE_ID
                              AND    A.MASTER_ID    = @v_master_id
                              AND    A.PLAN_ID      = @v_plan_id
                             ) X
                      WHERE  X.ITEM_ID = A.ITEM_ID
                      AND    X.OPERATION_ID = A.OPERATION_ID
                      AND    X.RESOURCE_SETUP_GROUP_ID = A.LINE_SETUP_GROUP_ID      
                    )             
      --*/
      
      SET @n_row_count += @@ROWCOUNT

      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

    END
    
    BEGIN
        
        -- STEP 1.  SETUP_ITEM 을 CROSS JOIN 하여, FROM, TO 가 발생할 수 있는 모든 CASE 를 추출한다.
        --          각 LEVEL 별로 구분하여 10개의 LEVEL 이 있다는 전제조건에서 각각에 대한 SETUP ID 를 다시 추출한다.
        --          해당 SETUP ID 를 기준으로 SETUP 시간을 구하기 위해 FROM, TO 관계를 유지한다.
        --          이때 SETUP 시간에 대한 MAX, SUM 구분을 TO 기준으로 설정한다.
        BEGIN

          SET @v_table_name = 'TH_BUF_SCM_SETUP_MATRIX_01'
          SET @n_row_count = 0
          
          DELETE FROM TH_BUF_SCM_SETUP_MATRIX_01

          INSERT INTO TH_BUF_SCM_SETUP_MATRIX_01
                (
                 COMPANY_ID, DIVISION_ID, SITE_ID, OPERATION_ID, LINE_SETUP_GROUP_ID,
                 FROM_SETUP_GROUP_ID, TO_SETUP_GROUP_ID,
                 FROM_SG_01, TO_SG_01, 
                 FROM_SG_02, TO_SG_02,
                 FROM_SG_03, TO_SG_03,
                 FROM_SG_04, TO_SG_04,
                 FROM_SG_05, TO_SG_05,
                 FROM_SG_06, TO_SG_06,
                 FROM_SG_07, TO_SG_07,
                 FROM_SG_08, TO_SG_08,
                 FROM_SG_09, TO_SG_09,
                 FROM_SG_10, TO_SG_10,
                 CATE_01, CATE_02, CATE_03, CATE_04, CATE_05, CATE_06, CATE_07, CATE_08, CATE_09, CATE_10,
                 KEY_01,  KEY_02,  KEY_03,  KEY_04,  KEY_05,  KEY_06,  KEY_07,  KEY_08,  KEY_09,  KEY_10,
                 TCAL_01, TCAL_02, TCAL_03, TCAL_04, TCAL_05, TCAL_06, TCAL_07, TCAL_08, TCAL_09, TCAL_10
                )
          SELECT DISTINCT
                 A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
                 A.SETUP_GROUP_ID AS FROM_SETUP_GROUP_ID,
                 B.SETUP_GROUP_ID AS TO_SETUP_GROUP_ID,
                 A.S_GRP_01 AS FROM_SG_01, B.S_GRP_01 AS TO_SG_01, 
                 A.S_GRP_02 AS FROM_SG_02, B.S_GRP_02 AS TO_SG_02,
                 A.S_GRP_03 AS FROM_SG_03, B.S_GRP_03 AS TO_SG_03,
                 A.S_GRP_04 AS FROM_SG_04, B.S_GRP_04 AS TO_SG_04,
                 A.S_GRP_05 AS FROM_SG_05, B.S_GRP_05 AS TO_SG_05,
                 A.S_GRP_06 AS FROM_SG_06, B.S_GRP_06 AS TO_SG_06,
                 A.S_GRP_07 AS FROM_SG_07, B.S_GRP_07 AS TO_SG_07,
                 A.S_GRP_08 AS FROM_SG_08, B.S_GRP_08 AS TO_SG_08,
                 A.S_GRP_09 AS FROM_SG_09, B.S_GRP_09 AS TO_SG_09,
                 A.S_GRP_10 AS FROM_SG_10, B.S_GRP_10 AS TO_SG_10,
                 CASE WHEN B.S_CAT_01 = '' THEN A.S_CAT_01 ELSE B.S_CAT_01 END SETUP_CATEGORY_01,
                 CASE WHEN B.S_CAT_02 = '' THEN A.S_CAT_02 ELSE B.S_CAT_02 END SETUP_CATEGORY_02,
                 CASE WHEN B.S_CAT_03 = '' THEN A.S_CAT_03 ELSE B.S_CAT_03 END SETUP_CATEGORY_03,
                 CASE WHEN B.S_CAT_04 = '' THEN A.S_CAT_04 ELSE B.S_CAT_04 END SETUP_CATEGORY_04,
                 CASE WHEN B.S_CAT_05 = '' THEN A.S_CAT_05 ELSE B.S_CAT_05 END SETUP_CATEGORY_05,
                 CASE WHEN B.S_CAT_06 = '' THEN A.S_CAT_06 ELSE B.S_CAT_06 END SETUP_CATEGORY_06,
                 CASE WHEN B.S_CAT_07 = '' THEN A.S_CAT_07 ELSE B.S_CAT_07 END SETUP_CATEGORY_07,
                 CASE WHEN B.S_CAT_08 = '' THEN A.S_CAT_08 ELSE B.S_CAT_08 END SETUP_CATEGORY_08,
                 CASE WHEN B.S_CAT_09 = '' THEN A.S_CAT_09 ELSE B.S_CAT_09 END SETUP_CATEGORY_09,
                 CASE WHEN B.S_CAT_10 = '' THEN A.S_CAT_10 ELSE B.S_CAT_10 END SETUP_CATEGORY_10,
                 CASE WHEN B.S_KEY_01 = '' THEN A.S_KEY_01 ELSE B.S_KEY_01 END SETUP_KEY_01,
                 CASE WHEN B.S_KEY_02 = '' THEN A.S_KEY_02 ELSE B.S_KEY_02 END SETUP_KEY_02,
                 CASE WHEN B.S_KEY_03 = '' THEN A.S_KEY_03 ELSE B.S_KEY_03 END SETUP_KEY_03,
                 CASE WHEN B.S_KEY_04 = '' THEN A.S_KEY_04 ELSE B.S_KEY_04 END SETUP_KEY_04,
                 CASE WHEN B.S_KEY_05 = '' THEN A.S_KEY_05 ELSE B.S_KEY_05 END SETUP_KEY_05,
                 CASE WHEN B.S_KEY_06 = '' THEN A.S_KEY_06 ELSE B.S_KEY_06 END SETUP_KEY_06,
                 CASE WHEN B.S_KEY_07 = '' THEN A.S_KEY_07 ELSE B.S_KEY_07 END SETUP_KEY_07,
                 CASE WHEN B.S_KEY_08 = '' THEN A.S_KEY_08 ELSE B.S_KEY_08 END SETUP_KEY_08,
                 CASE WHEN B.S_KEY_09 = '' THEN A.S_KEY_09 ELSE B.S_KEY_09 END SETUP_KEY_09,
                 CASE WHEN B.S_KEY_10 = '' THEN A.S_KEY_10 ELSE B.S_KEY_10 END SETUP_KEY_10,
                 CASE WHEN B.S_CAL_01 = '' THEN A.S_CAL_01 ELSE B.S_CAL_01 END SETUP_CALCULATION_01,
                 CASE WHEN B.S_CAL_02 = '' THEN A.S_CAL_02 ELSE B.S_CAL_02 END SETUP_CALCULATION_02,
                 CASE WHEN B.S_CAL_03 = '' THEN A.S_CAL_03 ELSE B.S_CAL_03 END SETUP_CALCULATION_03,
                 CASE WHEN B.S_CAL_04 = '' THEN A.S_CAL_04 ELSE B.S_CAL_04 END SETUP_CALCULATION_04,
                 CASE WHEN B.S_CAL_05 = '' THEN A.S_CAL_05 ELSE B.S_CAL_05 END SETUP_CALCULATION_05,
                 CASE WHEN B.S_CAL_06 = '' THEN A.S_CAL_06 ELSE B.S_CAL_06 END SETUP_CALCULATION_06,
                 CASE WHEN B.S_CAL_07 = '' THEN A.S_CAL_07 ELSE B.S_CAL_07 END SETUP_CALCULATION_07,
                 CASE WHEN B.S_CAL_08 = '' THEN A.S_CAL_08 ELSE B.S_CAL_08 END SETUP_CALCULATION_08,
                 CASE WHEN B.S_CAL_09 = '' THEN A.S_CAL_09 ELSE B.S_CAL_09 END SETUP_CALCULATION_09,
                 CASE WHEN B.S_CAL_10 = '' THEN A.S_CAL_10 ELSE B.S_CAL_10 END SETUP_CALCULATION_10                         
          FROM   TH_BUF_SCM_SETUP_ITEM A,
                 TH_BUF_SCM_SETUP_ITEM B
          WHERE  A.COMPANY_ID = B.COMPANY_ID
          AND    A.DIVISION_ID = B.DIVISION_ID
          AND    A.SITE_ID = B.SITE_ID
          AND    A.OPERATION_ID = B.OPERATION_ID
          AND    A.LINE_SETUP_GROUP_ID = B.LINE_SETUP_GROUP_ID
          AND    A.SETUP_GROUP_ID != B.SETUP_GROUP_ID
                  
          /*          
          SELECT DISTINCT
                 A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
                 A.FROM_SETUP_GROUP_ID,
                 A.TO_SETUP_GROUP_ID,
                 A.FROM_SG_01, A.TO_SG_01, TSG_01.SETUP_CATEGORY_ID, TSG_01.SETUP_KEY_ID, ISNULL(TSG_01.CALCULATION, 'MAX') AS TCAL_01,
                 A.FROM_SG_02, A.TO_SG_02, TSG_02.SETUP_CATEGORY_ID, TSG_02.SETUP_KEY_ID, ISNULL(TSG_02.CALCULATION, 'MAX') AS TCAL_02,
                 A.FROM_SG_03, A.TO_SG_03, TSG_03.SETUP_CATEGORY_ID, TSG_03.SETUP_KEY_ID, ISNULL(TSG_03.CALCULATION, 'MAX') AS TCAL_03,
                 A.FROM_SG_04, A.TO_SG_04, TSG_04.SETUP_CATEGORY_ID, TSG_04.SETUP_KEY_ID, ISNULL(TSG_04.CALCULATION, 'MAX') AS TCAL_04,
                 A.FROM_SG_05, A.TO_SG_05, TSG_05.SETUP_CATEGORY_ID, TSG_05.SETUP_KEY_ID, ISNULL(TSG_05.CALCULATION, 'MAX') AS TCAL_05,
                 A.FROM_SG_06, A.TO_SG_06, TSG_06.SETUP_CATEGORY_ID, TSG_06.SETUP_KEY_ID, ISNULL(TSG_06.CALCULATION, 'MAX') AS TCAL_06,
                 A.FROM_SG_07, A.TO_SG_07, TSG_07.SETUP_CATEGORY_ID, TSG_07.SETUP_KEY_ID, ISNULL(TSG_07.CALCULATION, 'MAX') AS TCAL_07,
                 A.FROM_SG_08, A.TO_SG_08, TSG_08.SETUP_CATEGORY_ID, TSG_08.SETUP_KEY_ID, ISNULL(TSG_08.CALCULATION, 'MAX') AS TCAL_08,
                 A.FROM_SG_09, A.TO_SG_09, TSG_09.SETUP_CATEGORY_ID, TSG_09.SETUP_KEY_ID, ISNULL(TSG_09.CALCULATION, 'MAX') AS TCAL_09,
                 A.FROM_SG_10, A.TO_SG_10, TSG_10.SETUP_CATEGORY_ID, TSG_10.SETUP_KEY_ID, ISNULL(TSG_10.CALCULATION, 'MAX') AS TCAL_10   
          FROM   (
                  SELECT DISTINCT
                         A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
                         A.SETUP_GROUP_ID AS FROM_SETUP_GROUP_ID,
                         B.SETUP_GROUP_ID AS TO_SETUP_GROUP_ID,
                         A.S_GRP_01 AS FROM_SG_01, B.S_GRP_01 AS TO_SG_01,
                         A.S_GRP_02 AS FROM_SG_02, B.S_GRP_02 AS TO_SG_02,
                         A.S_GRP_03 AS FROM_SG_03, B.S_GRP_03 AS TO_SG_03,
                         A.S_GRP_04 AS FROM_SG_04, B.S_GRP_04 AS TO_SG_04,
                         A.S_GRP_05 AS FROM_SG_05, B.S_GRP_05 AS TO_SG_05,
                         A.S_GRP_06 AS FROM_SG_06, B.S_GRP_06 AS TO_SG_06,
                         A.S_GRP_07 AS FROM_SG_07, B.S_GRP_07 AS TO_SG_07,
                         A.S_GRP_08 AS FROM_SG_08, B.S_GRP_08 AS TO_SG_08,
                         A.S_GRP_09 AS FROM_SG_09, B.S_GRP_09 AS TO_SG_09,
                         A.S_GRP_10 AS FROM_SG_10, B.S_GRP_10 AS TO_SG_10    
                  FROM   TH_BUF_SCM_SETUP_ITEM A,
                         TH_BUF_SCM_SETUP_ITEM B
                  WHERE  A.COMPANY_ID = B.COMPANY_ID
                  AND    A.DIVISION_ID = B.DIVISION_ID
                  AND    A.SITE_ID = B.SITE_ID
                  AND    A.OPERATION_ID = B.OPERATION_ID
                  AND    A.LINE_SETUP_GROUP_ID = B.LINE_SETUP_GROUP_ID
                  AND    A.SETUP_GROUP_ID != B.SETUP_GROUP_ID
                 ) A
                 LEFT OUTER JOIN (
                                  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, OPERATION_ID, 
                                         SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID, CALCULATION
                                  FROM   TH_BUF_SCM_SETUP_ITEM_COMBINE
                                  WHERE  LEVEL = 1
                                  GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, OPERATION_ID, 
                                            SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID, CALCULATION
                                 ) TSG_01
                      ON  A.COMPANY_ID    = TSG_01.COMPANY_ID
                      AND A.DIVISION_ID   = TSG_01.DIVISION_ID
                      AND A.SITE_ID       = TSG_01.SITE_ID
                      AND A.OPERATION_ID  = TSG_01.OPERATION_ID
                      AND A.TO_SG_01      = TSG_01.ITEM_SETUP_GROUP_ID
                 LEFT OUTER JOIN (
                                  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, OPERATION_ID, 
                                         SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID, CALCULATION
                                  FROM   TH_BUF_SCM_SETUP_ITEM_COMBINE
                                  WHERE  LEVEL = 2
                                  GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, OPERATION_ID, 
                                            SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID, CALCULATION
                                 ) TSG_02
                      ON  A.COMPANY_ID    = TSG_02.COMPANY_ID
                      AND A.DIVISION_ID   = TSG_02.DIVISION_ID
                      AND A.SITE_ID       = TSG_02.SITE_ID
                      AND A.OPERATION_ID  = TSG_02.OPERATION_ID
                      AND A.TO_SG_02      = TSG_02.ITEM_SETUP_GROUP_ID
                 LEFT OUTER JOIN (
                                  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, OPERATION_ID, 
                                         SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID, CALCULATION
                                  FROM   TH_BUF_SCM_SETUP_ITEM_COMBINE
                                  WHERE  LEVEL = 3
                                  GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, OPERATION_ID, 
                                            SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID, CALCULATION
                                 ) TSG_03
                      ON  A.COMPANY_ID    = TSG_03.COMPANY_ID
                      AND A.DIVISION_ID   = TSG_03.DIVISION_ID
                      AND A.SITE_ID       = TSG_03.SITE_ID
                      AND A.OPERATION_ID  = TSG_03.OPERATION_ID
                      AND A.TO_SG_03      = TSG_03.ITEM_SETUP_GROUP_ID
                 LEFT OUTER JOIN (
                                  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, OPERATION_ID, 
                                         SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID, CALCULATION
                                  FROM   TH_BUF_SCM_SETUP_ITEM_COMBINE
                                  WHERE  LEVEL = 4
                                  GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, OPERATION_ID, 
                                            SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID, CALCULATION
                                 ) TSG_04
                      ON  A.COMPANY_ID    = TSG_04.COMPANY_ID
                      AND A.DIVISION_ID   = TSG_04.DIVISION_ID
                      AND A.SITE_ID       = TSG_04.SITE_ID
                      AND A.OPERATION_ID  = TSG_04.OPERATION_ID
                      AND A.TO_SG_04      = TSG_04.ITEM_SETUP_GROUP_ID
                 LEFT OUTER JOIN (
                                  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, OPERATION_ID, 
                                         SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID, CALCULATION
                                  FROM   TH_BUF_SCM_SETUP_ITEM_COMBINE
                                  WHERE  LEVEL = 5
                                  GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, OPERATION_ID, 
                                            SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID, CALCULATION
                                 ) TSG_05
                      ON  A.COMPANY_ID    = TSG_05.COMPANY_ID
                      AND A.DIVISION_ID   = TSG_05.DIVISION_ID
                      AND A.SITE_ID       = TSG_05.SITE_ID
                      AND A.OPERATION_ID  = TSG_05.OPERATION_ID
                      AND A.TO_SG_05      = TSG_05.ITEM_SETUP_GROUP_ID
                 LEFT OUTER JOIN (
                                  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, OPERATION_ID, 
                                         SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID, CALCULATION
                                  FROM   TH_BUF_SCM_SETUP_ITEM_COMBINE
                                  WHERE  LEVEL = 6
                                  GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, OPERATION_ID, 
                                            SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID, CALCULATION
                                 ) TSG_06
                      ON  A.COMPANY_ID    = TSG_06.COMPANY_ID
                      AND A.DIVISION_ID   = TSG_06.DIVISION_ID
                      AND A.SITE_ID       = TSG_06.SITE_ID
                      AND A.OPERATION_ID  = TSG_06.OPERATION_ID
                      AND A.TO_SG_06      = TSG_06.ITEM_SETUP_GROUP_ID
                 LEFT OUTER JOIN (
                                  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, OPERATION_ID, 
                                         SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID, CALCULATION
                                  FROM   TH_BUF_SCM_SETUP_ITEM_COMBINE
                                  WHERE  LEVEL = 7
                                  GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, OPERATION_ID, 
                                            SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID, CALCULATION
                                 ) TSG_07
                      ON  A.COMPANY_ID    = TSG_07.COMPANY_ID
                      AND A.DIVISION_ID   = TSG_07.DIVISION_ID
                      AND A.SITE_ID       = TSG_07.SITE_ID
                      AND A.OPERATION_ID  = TSG_07.OPERATION_ID
                      AND A.TO_SG_07      = TSG_07.ITEM_SETUP_GROUP_ID
                 LEFT OUTER JOIN (
                                  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, OPERATION_ID, 
                                         SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID, CALCULATION
                                  FROM   TH_BUF_SCM_SETUP_ITEM_COMBINE
                                  WHERE  LEVEL = 8
                                  GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, OPERATION_ID, 
                                            SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID, CALCULATION
                                 ) TSG_08
                      ON  A.COMPANY_ID    = TSG_08.COMPANY_ID
                      AND A.DIVISION_ID   = TSG_08.DIVISION_ID
                      AND A.SITE_ID       = TSG_08.SITE_ID
                      AND A.OPERATION_ID  = TSG_08.OPERATION_ID
                      AND A.TO_SG_08      = TSG_08.ITEM_SETUP_GROUP_ID
                 LEFT OUTER JOIN (
                                  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, OPERATION_ID, 
                                         SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID, CALCULATION
                                  FROM   TH_BUF_SCM_SETUP_ITEM_COMBINE
                                  WHERE  LEVEL = 9
                                  GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, OPERATION_ID, 
                                            SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID, CALCULATION
                                 ) TSG_09
                      ON  A.COMPANY_ID    = TSG_09.COMPANY_ID
                      AND A.DIVISION_ID   = TSG_09.DIVISION_ID
                      AND A.SITE_ID       = TSG_09.SITE_ID
                      AND A.OPERATION_ID  = TSG_09.OPERATION_ID
                      AND A.TO_SG_09      = TSG_09.ITEM_SETUP_GROUP_ID
                 LEFT OUTER JOIN (
                                  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, OPERATION_ID, 
                                         SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID, CALCULATION
                                  FROM   TH_BUF_SCM_SETUP_ITEM_COMBINE
                                  WHERE  LEVEL = 10
                                  GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, OPERATION_ID, 
                                            SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID, CALCULATION
                                 ) TSG_10
                      ON  A.COMPANY_ID    = TSG_10.COMPANY_ID
                      AND A.DIVISION_ID   = TSG_10.DIVISION_ID
                      AND A.SITE_ID       = TSG_10.SITE_ID
                      AND A.OPERATION_ID  = TSG_10.OPERATION_ID
                      AND A.TO_SG_10      = TSG_10.ITEM_SETUP_GROUP_ID
          */
          
          SET @n_row_count += @@ROWCOUNT

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
        END

        -- STEP 2. 위에서 LEVEL 별로 FROM , TO 에 대한 실질적인 SETUP TIME 을 가지고 온다.
        --         단위는 분단위로 통일한다.
        BEGIN

          SET @v_table_name = 'TH_BUF_SCM_SETUP_MATRIX_02'
          SET @n_row_count = 0
          
          DELETE FROM TH_BUF_SCM_SETUP_MATRIX_02

          INSERT INTO TH_BUF_SCM_SETUP_MATRIX_02
               (
                 COMPANY_ID, DIVISION_ID, SITE_ID, OPERATION_ID, LINE_SETUP_GROUP_ID,
                 FROM_SETUP_GROUP_ID, TO_SETUP_GROUP_ID     
               )
          SELECT COMPANY_ID, DIVISION_ID, SITE_ID, OPERATION_ID, LINE_SETUP_GROUP_ID,
                 FROM_SETUP_GROUP_ID, TO_SETUP_GROUP_ID
          FROM   TH_BUF_SCM_SETUP_MATRIX_01

          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

          -- 01
          UPDATE TH_BUF_SCM_SETUP_MATRIX_02
          SET    TH_BUF_SCM_SETUP_MATRIX_02.S01_SETUP_TIME  = B.S01_SETUP_TIME
               , TH_BUF_SCM_SETUP_MATRIX_02.S01_CALCULATION = B.S01_CALCULATION
          FROM   TH_BUF_SCM_SETUP_MATRIX_02 A,
                 (
                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
                         A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
                         S01_SETUP_TIME * (CASE S01_SETUP_TIME_UOM    
                                                WHEN 'HOUR'   THEN 60
                                                WHEN 'SECOND' THEN 1/06
                                                WHEN 'DAY'    THEN 1440  
                                                              ELSE 1 END ) S01_SETUP_TIME, 
                         TCAL_01 AS S01_CALCULATION
                  FROM   (
                          SELECT *
                          FROM   (
                                  SELECT A.*,
                                         DENSE_RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID
                                                                       , A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID
                                                            ORDER     BY SETUP_SEQ) AS SEQ
                                  FROM   (
                                          SELECT A.*,
                                                 ISNULL(S01.SETUP_TIME,0) AS S01_SETUP_TIME, ISNULL(S01.SETUP_TIME_UOM, 'MINUTE') AS S01_SETUP_TIME_UOM,
                                                 CASE WHEN S01.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S01.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 1
                                                      WHEN S01.FROM_ITEM_SETUP_GROUP_ID  = 'ALL' AND S01.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 2
                                                      WHEN S01.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S01.TO_ITEM_SETUP_GROUP_ID  = 'ALL'  THEN 3
                                                                                                                                          ELSE 4
                                                 END  SETUP_SEQ
                                          FROM   TH_BUF_SCM_SETUP_MATRIX_01 A
                                                 LEFT OUTER JOIN SY_SCM_SETUP_MATRIX_M S01
                                                      ON  A.FROM_SG_01    = CASE WHEN S01.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_01 ELSE S01.FROM_ITEM_SETUP_GROUP_ID END 
                                                      AND A.TO_SG_01      = CASE WHEN S01.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_01   ELSE S01.TO_ITEM_SETUP_GROUP_ID   END 
                                                      AND A.COMPANY_ID    = S01.COMPANY_ID
                                                      AND A.DIVISION_ID   = S01.DIVISION_ID
                                                      AND A.SITE_ID       = S01.SITE_ID
                                                      AND A.OPERATION_ID  = S01.OPERATION_ID
                                                      AND A.CATE_01       = S01.SETUP_CATEGORY_ID
                                                      AND A.KEY_01        = S01.SETUP_KEY_ID
                                                      AND A.LINE_SETUP_GROUP_ID = S01.LINE_SETUP_GROUP_ID
                                          WHERE  A.CATE_01 != ''
                                          AND    A.FROM_SG_01 != A.TO_SG_01   -- 동일 SETUP 은 반영 금지
                                         ) A
                                 ) A
                          WHERE  SEQ = 1
                         ) A
                 ) B
          WHERE  A.COMPANY_ID          = B.COMPANY_ID
          AND    A.DIVISION_ID         = B.DIVISION_ID
          AND    A.SITE_ID             = B.SITE_ID
          AND    A.OPERATION_ID        = B.OPERATION_ID
          AND    A.LINE_SETUP_GROUP_ID = B.LINE_SETUP_GROUP_ID
          AND    A.FROM_SETUP_GROUP_ID = B.FROM_SETUP_GROUP_ID
          AND    A.TO_SETUP_GROUP_ID   = B.TO_SETUP_GROUP_ID
          
          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = 'SETUP_GROUP_01 : ' + CONVERT(NVARCHAR, @n_row_count)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
          
          
          -- 02
          UPDATE TH_BUF_SCM_SETUP_MATRIX_02
          SET    TH_BUF_SCM_SETUP_MATRIX_02.S02_SETUP_TIME  = B.S02_SETUP_TIME
               , TH_BUF_SCM_SETUP_MATRIX_02.S02_CALCULATION = B.S02_CALCULATION
          FROM   TH_BUF_SCM_SETUP_MATRIX_02 A,
                 (
                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
                         A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
                         S02_SETUP_TIME * (CASE S02_SETUP_TIME_UOM    
                                                WHEN 'HOUR'   THEN 60
                                                WHEN 'SECOND' THEN 1/06
                                                WHEN 'DAY'    THEN 1440  
                                                              ELSE 1 END ) S02_SETUP_TIME, 
                         TCAL_02 AS S02_CALCULATION
                  FROM   (
                          SELECT *
                          FROM   (
                                  SELECT A.*,
                                         DENSE_RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID
                                                                       , A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID
                                                            ORDER     BY SETUP_SEQ) AS SEQ
                                  FROM   (
                                          SELECT A.*,
                                                 ISNULL(S02.SETUP_TIME,0) AS S02_SETUP_TIME, ISNULL(S02.SETUP_TIME_UOM, 'MINUTE') AS S02_SETUP_TIME_UOM,
                                                 CASE WHEN S02.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S02.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 1
                                                      WHEN S02.FROM_ITEM_SETUP_GROUP_ID  = 'ALL' AND S02.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 2
                                                      WHEN S02.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S02.TO_ITEM_SETUP_GROUP_ID  = 'ALL'  THEN 3
                                                                                                                                          ELSE 4
                                                 END  SETUP_SEQ
                                          FROM   TH_BUF_SCM_SETUP_MATRIX_01 A
                                                 LEFT OUTER JOIN SY_SCM_SETUP_MATRIX_M S02
                                                      ON  A.FROM_SG_02    = CASE WHEN S02.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_02 ELSE S02.FROM_ITEM_SETUP_GROUP_ID END 
                                                      AND A.TO_SG_02      = CASE WHEN S02.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_02   ELSE S02.TO_ITEM_SETUP_GROUP_ID   END 
                                                      AND A.COMPANY_ID    = S02.COMPANY_ID
                                                      AND A.DIVISION_ID   = S02.DIVISION_ID
                                                      AND A.SITE_ID       = S02.SITE_ID
                                                      AND A.OPERATION_ID  = S02.OPERATION_ID
                                                      AND A.CATE_02       = S02.SETUP_CATEGORY_ID
                                                      AND A.KEY_02        = S02.SETUP_KEY_ID
                                                      AND A.LINE_SETUP_GROUP_ID = S02.LINE_SETUP_GROUP_ID 
                                          WHERE  A.CATE_02 != ''
                                          AND    A.FROM_SG_02 != A.TO_SG_02   -- 동일 SETUP 은 반영 금지
                                         ) A
                                 ) A
                          WHERE  SEQ = 1
                         ) A
                 ) B
          WHERE  A.COMPANY_ID          = B.COMPANY_ID
          AND    A.DIVISION_ID         = B.DIVISION_ID
          AND    A.SITE_ID             = B.SITE_ID
          AND    A.OPERATION_ID        = B.OPERATION_ID
          AND    A.LINE_SETUP_GROUP_ID = B.LINE_SETUP_GROUP_ID
          AND    A.FROM_SETUP_GROUP_ID = B.FROM_SETUP_GROUP_ID
          AND    A.TO_SETUP_GROUP_ID   = B.TO_SETUP_GROUP_ID

          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = 'SETUP_GROUP_02 : ' + CONVERT(NVARCHAR, @n_row_count)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

          -- 03
          UPDATE TH_BUF_SCM_SETUP_MATRIX_02
          SET    TH_BUF_SCM_SETUP_MATRIX_02.S03_SETUP_TIME  = B.S03_SETUP_TIME
               , TH_BUF_SCM_SETUP_MATRIX_02.S03_CALCULATION = B.S03_CALCULATION
          FROM   TH_BUF_SCM_SETUP_MATRIX_02 A,
                 (
                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
                         A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
                         S03_SETUP_TIME * (CASE S03_SETUP_TIME_UOM    
                                                WHEN 'HOUR'   THEN 60
                                                WHEN 'SECOND' THEN 1/06
                                                WHEN 'DAY'    THEN 1440  
                                                              ELSE 1 END ) S03_SETUP_TIME, 
                         TCAL_03 AS S03_CALCULATION
                  FROM   (
                          SELECT *
                          FROM   (
                                  SELECT A.*,
                                         DENSE_RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID
                                                                       , A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID
                                                            ORDER     BY SETUP_SEQ) AS SEQ
                                  FROM   (
                                          SELECT A.*,
                                                 ISNULL(S03.SETUP_TIME,0) AS S03_SETUP_TIME, ISNULL(S03.SETUP_TIME_UOM, 'MINUTE') AS S03_SETUP_TIME_UOM,
                                                 CASE WHEN S03.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S03.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 1
                                                      WHEN S03.FROM_ITEM_SETUP_GROUP_ID  = 'ALL' AND S03.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 2
                                                      WHEN S03.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S03.TO_ITEM_SETUP_GROUP_ID  = 'ALL'  THEN 3
                                                                                                                                          ELSE 4
                                                 END  SETUP_SEQ
                                          FROM   TH_BUF_SCM_SETUP_MATRIX_01 A
                                                 LEFT OUTER JOIN SY_SCM_SETUP_MATRIX_M S03
                                                      ON  A.FROM_SG_03    = CASE WHEN S03.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_03 ELSE S03.FROM_ITEM_SETUP_GROUP_ID END 
                                                      AND A.TO_SG_03      = CASE WHEN S03.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_03   ELSE S03.TO_ITEM_SETUP_GROUP_ID   END 
                                                      AND A.COMPANY_ID    = S03.COMPANY_ID
                                                      AND A.DIVISION_ID   = S03.DIVISION_ID
                                                      AND A.SITE_ID       = S03.SITE_ID
                                                      AND A.OPERATION_ID  = S03.OPERATION_ID
                                                      AND A.CATE_03       = S03.SETUP_CATEGORY_ID
                                                      AND A.KEY_03        = S03.SETUP_KEY_ID
                                                      AND A.LINE_SETUP_GROUP_ID = S03.LINE_SETUP_GROUP_ID 
                                          WHERE  A.CATE_03 != ''
                                          AND    A.FROM_SG_03 != A.TO_SG_03   -- 동일 SETUP 은 반영 금지
                                         ) A
                                 ) A
                          WHERE  SEQ = 1
                         ) A
                 ) B
          WHERE  A.COMPANY_ID          = B.COMPANY_ID
          AND    A.DIVISION_ID         = B.DIVISION_ID
          AND    A.SITE_ID             = B.SITE_ID
          AND    A.OPERATION_ID        = B.OPERATION_ID
          AND    A.LINE_SETUP_GROUP_ID = B.LINE_SETUP_GROUP_ID
          AND    A.FROM_SETUP_GROUP_ID = B.FROM_SETUP_GROUP_ID
          AND    A.TO_SETUP_GROUP_ID   = B.TO_SETUP_GROUP_ID

          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = 'SETUP_GROUP_03 : ' + CONVERT(NVARCHAR, @n_row_count)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null


          -- 04
          UPDATE TH_BUF_SCM_SETUP_MATRIX_02
          SET    TH_BUF_SCM_SETUP_MATRIX_02.S04_SETUP_TIME  = B.S04_SETUP_TIME
               , TH_BUF_SCM_SETUP_MATRIX_02.S04_CALCULATION = B.S04_CALCULATION
          FROM   TH_BUF_SCM_SETUP_MATRIX_02 A,
                 (
                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
                         A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
                         S04_SETUP_TIME * (CASE S04_SETUP_TIME_UOM    
                                                WHEN 'HOUR'   THEN 60
                                                WHEN 'SECOND' THEN 1/06
                                                WHEN 'DAY'    THEN 1440  
                                                              ELSE 1 END ) S04_SETUP_TIME, 
                         TCAL_04 AS S04_CALCULATION
                  FROM   (
                          SELECT *
                          FROM   (
                                  SELECT A.*,
                                         DENSE_RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID
                                                                       , A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID
                                                            ORDER     BY SETUP_SEQ) AS SEQ
                                  FROM   (
                                          SELECT A.*,
                                                 ISNULL(S04.SETUP_TIME,0) AS S04_SETUP_TIME, ISNULL(S04.SETUP_TIME_UOM, 'MINUTE') AS S04_SETUP_TIME_UOM,
                                                 CASE WHEN S04.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S04.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 1
                                                      WHEN S04.FROM_ITEM_SETUP_GROUP_ID  = 'ALL' AND S04.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 2
                                                      WHEN S04.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S04.TO_ITEM_SETUP_GROUP_ID  = 'ALL'  THEN 3
                                                                                                                                          ELSE 4
                                                 END  SETUP_SEQ
                                          FROM   TH_BUF_SCM_SETUP_MATRIX_01 A
                                                 LEFT OUTER JOIN SY_SCM_SETUP_MATRIX_M S04
                                                      ON  A.FROM_SG_04    = CASE WHEN S04.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_04 ELSE S04.FROM_ITEM_SETUP_GROUP_ID END 
                                                      AND A.TO_SG_04      = CASE WHEN S04.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_04   ELSE S04.TO_ITEM_SETUP_GROUP_ID   END 
                                                      AND A.COMPANY_ID    = S04.COMPANY_ID
                                                      AND A.DIVISION_ID   = S04.DIVISION_ID
                                                      AND A.SITE_ID       = S04.SITE_ID
                                                      AND A.OPERATION_ID  = S04.OPERATION_ID
                                                      AND A.CATE_04       = S04.SETUP_CATEGORY_ID
                                                      AND A.KEY_04        = S04.SETUP_KEY_ID
                                                      AND A.LINE_SETUP_GROUP_ID = S04.LINE_SETUP_GROUP_ID 
                                          WHERE  A.CATE_04 != ''
                                          AND    A.FROM_SG_04 != A.TO_SG_04   -- 동일 SETUP 은 반영 금지
                                         ) A
                                 ) A
                          WHERE  SEQ = 1
                         ) A
                 ) B
          WHERE  A.COMPANY_ID          = B.COMPANY_ID
          AND    A.DIVISION_ID         = B.DIVISION_ID
          AND    A.SITE_ID             = B.SITE_ID
          AND    A.OPERATION_ID        = B.OPERATION_ID
          AND    A.LINE_SETUP_GROUP_ID = B.LINE_SETUP_GROUP_ID
          AND    A.FROM_SETUP_GROUP_ID = B.FROM_SETUP_GROUP_ID
          AND    A.TO_SETUP_GROUP_ID   = B.TO_SETUP_GROUP_ID
          
          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = 'SETUP_GROUP_04 : ' + CONVERT(NVARCHAR, @n_row_count)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

          
          -- 05
          UPDATE TH_BUF_SCM_SETUP_MATRIX_02
          SET    TH_BUF_SCM_SETUP_MATRIX_02.S05_SETUP_TIME  = B.S05_SETUP_TIME
               , TH_BUF_SCM_SETUP_MATRIX_02.S05_CALCULATION = B.S05_CALCULATION
          FROM   TH_BUF_SCM_SETUP_MATRIX_02 A,
                 (
                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
                         A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
                         S05_SETUP_TIME * (CASE S05_SETUP_TIME_UOM    
                                                WHEN 'HOUR'   THEN 60
                                                WHEN 'SECOND' THEN 1/06
                                                WHEN 'DAY'    THEN 1440  
                                                              ELSE 1 END ) S05_SETUP_TIME, 
                         TCAL_05 AS S05_CALCULATION
                  FROM   (
                          SELECT *
                          FROM   (
                                  SELECT A.*,
                                         DENSE_RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID
                                                                       , A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID
                                                            ORDER     BY SETUP_SEQ) AS SEQ
                                  FROM   (
                                          SELECT A.*,
                                                 ISNULL(S05.SETUP_TIME,0) AS S05_SETUP_TIME, ISNULL(S05.SETUP_TIME_UOM, 'MINUTE') AS S05_SETUP_TIME_UOM,
                                                 CASE WHEN S05.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S05.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 1
                                                      WHEN S05.FROM_ITEM_SETUP_GROUP_ID  = 'ALL' AND S05.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 2
                                                      WHEN S05.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S05.TO_ITEM_SETUP_GROUP_ID  = 'ALL'  THEN 3
                                                                                                                                          ELSE 4
                                                 END  SETUP_SEQ
                                          FROM   TH_BUF_SCM_SETUP_MATRIX_01 A
                                                 LEFT OUTER JOIN SY_SCM_SETUP_MATRIX_M S05
                                                      ON  A.FROM_SG_05    = CASE WHEN S05.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_05 ELSE S05.FROM_ITEM_SETUP_GROUP_ID END 
                                                      AND A.TO_SG_05      = CASE WHEN S05.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_05   ELSE S05.TO_ITEM_SETUP_GROUP_ID   END 
                                                      AND A.COMPANY_ID    = S05.COMPANY_ID
                                                      AND A.DIVISION_ID   = S05.DIVISION_ID
                                                      AND A.SITE_ID       = S05.SITE_ID
                                                      AND A.OPERATION_ID  = S05.OPERATION_ID
                                                      AND A.CATE_05       = S05.SETUP_CATEGORY_ID
                                                      AND A.KEY_05        = S05.SETUP_KEY_ID
                                                      AND A.LINE_SETUP_GROUP_ID = S05.LINE_SETUP_GROUP_ID 
                                          WHERE  A.CATE_05 != ''
                                          AND    A.FROM_SG_05 != A.TO_SG_05   -- 동일 SETUP 은 반영 금지
                                         ) A
                                 ) A
                          WHERE  SEQ = 1
                         ) A
                 ) B
          WHERE  A.COMPANY_ID          = B.COMPANY_ID
          AND    A.DIVISION_ID         = B.DIVISION_ID
          AND    A.SITE_ID             = B.SITE_ID
          AND    A.OPERATION_ID        = B.OPERATION_ID
          AND    A.LINE_SETUP_GROUP_ID = B.LINE_SETUP_GROUP_ID
          AND    A.FROM_SETUP_GROUP_ID = B.FROM_SETUP_GROUP_ID
          AND    A.TO_SETUP_GROUP_ID   = B.TO_SETUP_GROUP_ID
          
          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = 'SETUP_GROUP_05 : ' + CONVERT(NVARCHAR, @n_row_count)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

          
          -- 06
          UPDATE TH_BUF_SCM_SETUP_MATRIX_02
          SET    TH_BUF_SCM_SETUP_MATRIX_02.S06_SETUP_TIME  = B.S06_SETUP_TIME
               , TH_BUF_SCM_SETUP_MATRIX_02.S06_CALCULATION = B.S06_CALCULATION
          FROM   TH_BUF_SCM_SETUP_MATRIX_02 A,
                 (
                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
                         A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
                         S06_SETUP_TIME * (CASE S06_SETUP_TIME_UOM    
                                                WHEN 'HOUR'   THEN 60
                                                WHEN 'SECOND' THEN 1/06
                                                WHEN 'DAY'    THEN 1440  
                                                              ELSE 1 END ) S06_SETUP_TIME, 
                         TCAL_06 AS S06_CALCULATION
                  FROM   (
                          SELECT *
                          FROM   (
                                  SELECT A.*,
                                         DENSE_RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID
                                                                       , A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID
                                                            ORDER     BY SETUP_SEQ) AS SEQ
                                  FROM   (
                                          SELECT A.*,
                                                 ISNULL(S06.SETUP_TIME,0) AS S06_SETUP_TIME, ISNULL(S06.SETUP_TIME_UOM, 'MINUTE') AS S06_SETUP_TIME_UOM,
                                                 CASE WHEN S06.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S06.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 1
                                                      WHEN S06.FROM_ITEM_SETUP_GROUP_ID  = 'ALL' AND S06.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 2
                                                      WHEN S06.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S06.TO_ITEM_SETUP_GROUP_ID  = 'ALL'  THEN 3
                                                                                                                                          ELSE 4
                                                 END  SETUP_SEQ
                                          FROM   TH_BUF_SCM_SETUP_MATRIX_01 A
                                                 LEFT OUTER JOIN SY_SCM_SETUP_MATRIX_M S06
                                                      ON  A.FROM_SG_06    = CASE WHEN S06.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_06 ELSE S06.FROM_ITEM_SETUP_GROUP_ID END 
                                                      AND A.TO_SG_06      = CASE WHEN S06.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_06   ELSE S06.TO_ITEM_SETUP_GROUP_ID   END 
                                                      AND A.COMPANY_ID    = S06.COMPANY_ID
                                                      AND A.DIVISION_ID   = S06.DIVISION_ID
                                                      AND A.SITE_ID       = S06.SITE_ID
                                                      AND A.OPERATION_ID  = S06.OPERATION_ID
                                                      AND A.CATE_06       = S06.SETUP_CATEGORY_ID
                                                      AND A.KEY_06        = S06.SETUP_KEY_ID
                                                      AND A.LINE_SETUP_GROUP_ID = S06.LINE_SETUP_GROUP_ID 
                                          WHERE  A.CATE_06 != ''
                                          AND    A.FROM_SG_06 != A.TO_SG_06   -- 동일 SETUP 은 반영 금지
                                         ) A
                                 ) A
                          WHERE  SEQ = 1
                         ) A
                 ) B
          WHERE  A.COMPANY_ID          = B.COMPANY_ID
          AND    A.DIVISION_ID         = B.DIVISION_ID
          AND    A.SITE_ID             = B.SITE_ID
          AND    A.OPERATION_ID        = B.OPERATION_ID
          AND    A.LINE_SETUP_GROUP_ID = B.LINE_SETUP_GROUP_ID
          AND    A.FROM_SETUP_GROUP_ID = B.FROM_SETUP_GROUP_ID
          AND    A.TO_SETUP_GROUP_ID   = B.TO_SETUP_GROUP_ID

          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = 'SETUP_GROUP_06 : ' + CONVERT(NVARCHAR, @n_row_count)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

          
          -- 07
          UPDATE TH_BUF_SCM_SETUP_MATRIX_02
          SET    TH_BUF_SCM_SETUP_MATRIX_02.S07_SETUP_TIME  = B.S07_SETUP_TIME
               , TH_BUF_SCM_SETUP_MATRIX_02.S07_CALCULATION = B.S07_CALCULATION
          FROM   TH_BUF_SCM_SETUP_MATRIX_02 A,
                 (
                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
                         A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
                         S07_SETUP_TIME * (CASE S07_SETUP_TIME_UOM    
                                                WHEN 'HOUR'   THEN 60
                                                WHEN 'SECOND' THEN 1/06
                                                WHEN 'DAY'    THEN 1440  
                                                              ELSE 1 END ) S07_SETUP_TIME, 
                         TCAL_07 AS S07_CALCULATION
                  FROM   (
                          SELECT *
                          FROM   (
                                  SELECT A.*,
                                         DENSE_RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID
                                                                       , A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID
                                                            ORDER     BY SETUP_SEQ) AS SEQ
                                  FROM   (
                                          SELECT A.*,
                                                 ISNULL(S07.SETUP_TIME,0) AS S07_SETUP_TIME, ISNULL(S07.SETUP_TIME_UOM, 'MINUTE') AS S07_SETUP_TIME_UOM,
                                                 CASE WHEN S07.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S07.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 1
                                                      WHEN S07.FROM_ITEM_SETUP_GROUP_ID  = 'ALL' AND S07.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 2
                                                      WHEN S07.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S07.TO_ITEM_SETUP_GROUP_ID  = 'ALL'  THEN 3
                                                                                                                                          ELSE 4
                                                 END  SETUP_SEQ
                                          FROM   TH_BUF_SCM_SETUP_MATRIX_01 A
                                                 LEFT OUTER JOIN SY_SCM_SETUP_MATRIX_M S07
                                                      ON  A.FROM_SG_07    = CASE WHEN S07.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_07 ELSE S07.FROM_ITEM_SETUP_GROUP_ID END 
                                                      AND A.TO_SG_07      = CASE WHEN S07.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_07   ELSE S07.TO_ITEM_SETUP_GROUP_ID   END 
                                                      AND A.COMPANY_ID    = S07.COMPANY_ID
                                                      AND A.DIVISION_ID   = S07.DIVISION_ID
                                                      AND A.SITE_ID       = S07.SITE_ID
                                                      AND A.OPERATION_ID  = S07.OPERATION_ID
                                                      AND A.CATE_07       = S07.SETUP_CATEGORY_ID
                                                      AND A.KEY_07        = S07.SETUP_KEY_ID
                                                      AND A.LINE_SETUP_GROUP_ID = S07.LINE_SETUP_GROUP_ID 
                                          WHERE  A.CATE_07 != ''
                                          AND    A.FROM_SG_07 != A.TO_SG_07   -- 동일 SETUP 은 반영 금지
                                         ) A
                                 ) A
                          WHERE  SEQ = 1
                         ) A
                 ) B
          WHERE  A.COMPANY_ID          = B.COMPANY_ID
          AND    A.DIVISION_ID         = B.DIVISION_ID
          AND    A.SITE_ID             = B.SITE_ID
          AND    A.OPERATION_ID        = B.OPERATION_ID
          AND    A.LINE_SETUP_GROUP_ID = B.LINE_SETUP_GROUP_ID
          AND    A.FROM_SETUP_GROUP_ID = B.FROM_SETUP_GROUP_ID
          AND    A.TO_SETUP_GROUP_ID   = B.TO_SETUP_GROUP_ID

          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = 'SETUP_GROUP_07 : ' + CONVERT(NVARCHAR, @n_row_count)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

          
          -- 08
          UPDATE TH_BUF_SCM_SETUP_MATRIX_02
          SET    TH_BUF_SCM_SETUP_MATRIX_02.S08_SETUP_TIME  = B.S08_SETUP_TIME
               , TH_BUF_SCM_SETUP_MATRIX_02.S08_CALCULATION = B.S08_CALCULATION
          FROM   TH_BUF_SCM_SETUP_MATRIX_02 A,
                 (
                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
                         A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
                         S08_SETUP_TIME * (CASE S08_SETUP_TIME_UOM    
                                                WHEN 'HOUR'   THEN 60
                                                WHEN 'SECOND' THEN 1/06
                                                WHEN 'DAY'    THEN 1440  
                                                              ELSE 1 END ) S08_SETUP_TIME, 
                         TCAL_08 AS S08_CALCULATION
                  FROM   (
                          SELECT *
                          FROM   (
                                  SELECT A.*,
                                         DENSE_RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID
                                                                       , A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID
                                                            ORDER     BY SETUP_SEQ) AS SEQ
                                  FROM   (
                                          SELECT A.*,
                                                 ISNULL(S08.SETUP_TIME,0) AS S08_SETUP_TIME, ISNULL(S08.SETUP_TIME_UOM, 'MINUTE') AS S08_SETUP_TIME_UOM,
                                                 CASE WHEN S08.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S08.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 1
                                                      WHEN S08.FROM_ITEM_SETUP_GROUP_ID  = 'ALL' AND S08.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 2
                                                      WHEN S08.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S08.TO_ITEM_SETUP_GROUP_ID  = 'ALL'  THEN 3
                                                                                                                                          ELSE 4
                                                 END  SETUP_SEQ
                                          FROM   TH_BUF_SCM_SETUP_MATRIX_01 A
                                                 LEFT OUTER JOIN SY_SCM_SETUP_MATRIX_M S08
                                                      ON  A.FROM_SG_08    = CASE WHEN S08.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_08 ELSE S08.FROM_ITEM_SETUP_GROUP_ID END 
                                                      AND A.TO_SG_08      = CASE WHEN S08.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_08   ELSE S08.TO_ITEM_SETUP_GROUP_ID   END 
                                                      AND A.COMPANY_ID    = S08.COMPANY_ID
                                                      AND A.DIVISION_ID   = S08.DIVISION_ID
                                                      AND A.SITE_ID       = S08.SITE_ID
                                                      AND A.OPERATION_ID  = S08.OPERATION_ID
                                                      AND A.CATE_08       = S08.SETUP_CATEGORY_ID
                                                      AND A.KEY_08        = S08.SETUP_KEY_ID
                                                      AND A.LINE_SETUP_GROUP_ID = S08.LINE_SETUP_GROUP_ID 
                                          WHERE  A.CATE_08 != ''
                                          AND    A.FROM_SG_08 != A.TO_SG_08   -- 동일 SETUP 은 반영 금지
                                         ) A
                                 ) A
                          WHERE  SEQ = 1
                         ) A
                 ) B
          WHERE  A.COMPANY_ID          = B.COMPANY_ID
          AND    A.DIVISION_ID         = B.DIVISION_ID
          AND    A.SITE_ID             = B.SITE_ID
          AND    A.OPERATION_ID        = B.OPERATION_ID
          AND    A.LINE_SETUP_GROUP_ID = B.LINE_SETUP_GROUP_ID
          AND    A.FROM_SETUP_GROUP_ID = B.FROM_SETUP_GROUP_ID
          AND    A.TO_SETUP_GROUP_ID   = B.TO_SETUP_GROUP_ID

          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = 'SETUP_GROUP_08 : ' + CONVERT(NVARCHAR, @n_row_count)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

          
          -- 09
          UPDATE TH_BUF_SCM_SETUP_MATRIX_02
          SET    TH_BUF_SCM_SETUP_MATRIX_02.S09_SETUP_TIME  = B.S09_SETUP_TIME
               , TH_BUF_SCM_SETUP_MATRIX_02.S09_CALCULATION = B.S09_CALCULATION
          FROM   TH_BUF_SCM_SETUP_MATRIX_02 A,
                 (
                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
                         A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
                         S09_SETUP_TIME * (CASE S09_SETUP_TIME_UOM    
                                                WHEN 'HOUR'   THEN 60
                                                WHEN 'SECOND' THEN 1/06
                                                WHEN 'DAY'    THEN 1440  
                                                              ELSE 1 END ) S09_SETUP_TIME, 
                         TCAL_09 AS S09_CALCULATION
                  FROM   (
                          SELECT *
                          FROM   (
                                  SELECT A.*,
                                         DENSE_RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID
                                                                       , A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID
                                                            ORDER     BY SETUP_SEQ) AS SEQ
                                  FROM   (
                                          SELECT A.*,
                                                 ISNULL(S09.SETUP_TIME,0) AS S09_SETUP_TIME, ISNULL(S09.SETUP_TIME_UOM, 'MINUTE') AS S09_SETUP_TIME_UOM,
                                                 CASE WHEN S09.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S09.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 1
                                                      WHEN S09.FROM_ITEM_SETUP_GROUP_ID  = 'ALL' AND S09.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 2
                                                      WHEN S09.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S09.TO_ITEM_SETUP_GROUP_ID  = 'ALL'  THEN 3
                                                                                                                                          ELSE 4
                                                 END  SETUP_SEQ
                                          FROM   TH_BUF_SCM_SETUP_MATRIX_01 A
                                                 LEFT OUTER JOIN SY_SCM_SETUP_MATRIX_M S09
                                                      ON  A.FROM_SG_09    = CASE WHEN S09.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_09 ELSE S09.FROM_ITEM_SETUP_GROUP_ID END 
                                                      AND A.TO_SG_09      = CASE WHEN S09.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_09   ELSE S09.TO_ITEM_SETUP_GROUP_ID   END 
                                                      AND A.COMPANY_ID    = S09.COMPANY_ID
                                                      AND A.DIVISION_ID   = S09.DIVISION_ID
                                                      AND A.SITE_ID       = S09.SITE_ID
                                                      AND A.OPERATION_ID  = S09.OPERATION_ID
                                                      AND A.CATE_09       = S09.SETUP_CATEGORY_ID
                                                      AND A.KEY_09        = S09.SETUP_KEY_ID
                                                      AND A.LINE_SETUP_GROUP_ID = S09.LINE_SETUP_GROUP_ID 
                                          WHERE  A.CATE_09 != ''
                                          AND    A.FROM_SG_09 != A.TO_SG_09   -- 동일 SETUP 은 반영 금지
                                         ) A
                                 ) A
                          WHERE  SEQ = 1
                         ) A
                 ) B
          WHERE  A.COMPANY_ID          = B.COMPANY_ID
          AND    A.DIVISION_ID         = B.DIVISION_ID
          AND    A.SITE_ID             = B.SITE_ID
          AND    A.OPERATION_ID        = B.OPERATION_ID
          AND    A.LINE_SETUP_GROUP_ID = B.LINE_SETUP_GROUP_ID
          AND    A.FROM_SETUP_GROUP_ID = B.FROM_SETUP_GROUP_ID
          AND    A.TO_SETUP_GROUP_ID   = B.TO_SETUP_GROUP_ID

          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = 'SETUP_GROUP_09 : ' + CONVERT(NVARCHAR, @n_row_count)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

          
          -- 10
          UPDATE TH_BUF_SCM_SETUP_MATRIX_02
          SET    TH_BUF_SCM_SETUP_MATRIX_02.S10_SETUP_TIME  = B.S10_SETUP_TIME
               , TH_BUF_SCM_SETUP_MATRIX_02.S10_CALCULATION = B.S10_CALCULATION
          FROM   TH_BUF_SCM_SETUP_MATRIX_02 A,
                 (
                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
                         A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
                         S10_SETUP_TIME * (CASE S10_SETUP_TIME_UOM    
                                                WHEN 'HOUR'   THEN 60
                                                WHEN 'SECOND' THEN 1/06
                                                WHEN 'DAY'    THEN 1440  
                                                              ELSE 1 END ) S10_SETUP_TIME, 
                         TCAL_10 AS S10_CALCULATION
                  FROM   (
                          SELECT *
                          FROM   (
                                  SELECT A.*,
                                         DENSE_RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID
                                                                       , A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID
                                                            ORDER     BY SETUP_SEQ) AS SEQ
                                  FROM   (
                                          SELECT A.*,
                                                 ISNULL(S10.SETUP_TIME,0) AS S10_SETUP_TIME, ISNULL(S10.SETUP_TIME_UOM, 'MINUTE') AS S10_SETUP_TIME_UOM,
                                                 CASE WHEN S10.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S10.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 1
                                                      WHEN S10.FROM_ITEM_SETUP_GROUP_ID  = 'ALL' AND S10.TO_ITEM_SETUP_GROUP_ID != 'ALL'  THEN 2
                                                      WHEN S10.FROM_ITEM_SETUP_GROUP_ID != 'ALL' AND S10.TO_ITEM_SETUP_GROUP_ID  = 'ALL'  THEN 3
                                                                                                                                          ELSE 4
                                                 END  SETUP_SEQ
                                          FROM   TH_BUF_SCM_SETUP_MATRIX_01 A
                                                 LEFT OUTER JOIN SY_SCM_SETUP_MATRIX_M S10
                                                      ON  A.FROM_SG_10    = CASE WHEN S10.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_10 ELSE S10.FROM_ITEM_SETUP_GROUP_ID END 
                                                      AND A.TO_SG_10      = CASE WHEN S10.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_10   ELSE S10.TO_ITEM_SETUP_GROUP_ID   END 
                                                      AND A.COMPANY_ID    = S10.COMPANY_ID
                                                      AND A.DIVISION_ID   = S10.DIVISION_ID
                                                      AND A.SITE_ID       = S10.SITE_ID
                                                      AND A.OPERATION_ID  = S10.OPERATION_ID
                                                      AND A.CATE_10       = S10.SETUP_CATEGORY_ID
                                                      AND A.KEY_10        = S10.SETUP_KEY_ID
                                                      AND A.LINE_SETUP_GROUP_ID = S10.LINE_SETUP_GROUP_ID 
                                          WHERE  A.CATE_10 != ''
                                          AND    A.FROM_SG_10 != A.TO_SG_10   -- 동일 SETUP 은 반영 금지
                                         ) A
                                 ) A
                          WHERE  SEQ = 1
                         ) A
                 ) B
          WHERE  A.COMPANY_ID          = B.COMPANY_ID
          AND    A.DIVISION_ID         = B.DIVISION_ID
          AND    A.SITE_ID             = B.SITE_ID
          AND    A.OPERATION_ID        = B.OPERATION_ID
          AND    A.LINE_SETUP_GROUP_ID = B.LINE_SETUP_GROUP_ID
          AND    A.FROM_SETUP_GROUP_ID = B.FROM_SETUP_GROUP_ID
          AND    A.TO_SETUP_GROUP_ID   = B.TO_SETUP_GROUP_ID

          SET @n_row_count = @@ROWCOUNT

          --LOG 생성
          SET @v_message = 'SETUP_GROUP_10 : ' + CONVERT(NVARCHAR, @n_row_count)
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

          /*
          INSERT INTO TH_BUF_SCM_SETUP_MATRIX_02
          SELECT DISTINCT
                 A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
                 A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
                 S01_SETUP_TIME * (CASE S01_SETUP_TIME_UOM    WHEN 'HOUR'   THEN 60
                                                              WHEN 'SECOND' THEN 1/06
                                                              WHEN 'DAY'    THEN 1440  ELSE 1 END ) S01_SETUP_TIME, TCAL_01 AS S01_CALCULATION,
                 S02_SETUP_TIME * (CASE S02_SETUP_TIME_UOM    WHEN 'HOUR'   THEN 60
                                                              WHEN 'SECOND' THEN 1/06
                                                              WHEN 'DAY'    THEN 1440  ELSE 1 END ) S02_SETUP_TIME, TCAL_02 AS S02_CALCULATION,
                 S03_SETUP_TIME * (CASE S03_SETUP_TIME_UOM    WHEN 'HOUR'   THEN 60
                                                              WHEN 'SECOND' THEN 1/06
                                                              WHEN 'DAY'    THEN 1440  ELSE 1 END ) S03_SETUP_TIME, TCAL_03 AS S03_CALCULATION,
                 S04_SETUP_TIME * (CASE S04_SETUP_TIME_UOM    WHEN 'HOUR'   THEN 60
                                                              WHEN 'SECOND' THEN 1/06
                                                              WHEN 'DAY'    THEN 1440  ELSE 1 END ) S04_SETUP_TIME, TCAL_04 AS S04_CALCULATION,
                 S05_SETUP_TIME * (CASE S05_SETUP_TIME_UOM    WHEN 'HOUR'   THEN 60
                                                              WHEN 'SECOND' THEN 1/06
                                                              WHEN 'DAY'    THEN 1440  ELSE 1 END ) S05_SETUP_TIME, TCAL_05 AS S05_CALCULATION,
                 S06_SETUP_TIME * (CASE S06_SETUP_TIME_UOM    WHEN 'HOUR'   THEN 60
                                                              WHEN 'SECOND' THEN 1/06
                                                              WHEN 'DAY'    THEN 1440  ELSE 1 END ) S06_SETUP_TIME, TCAL_06 AS S06_CALCULATION,
                 S07_SETUP_TIME * (CASE S07_SETUP_TIME_UOM    WHEN 'HOUR'   THEN 60
                                                              WHEN 'SECOND' THEN 1/06
                                                              WHEN 'DAY'    THEN 1440  ELSE 1 END ) S07_SETUP_TIME, TCAL_07 AS S07_CALCULATION,
                 S08_SETUP_TIME * (CASE S08_SETUP_TIME_UOM    WHEN 'HOUR'   THEN 60
                                                              WHEN 'SECOND' THEN 1/06
                                                              WHEN 'DAY'    THEN 1440  ELSE 1 END ) S08_SETUP_TIME, TCAL_08 AS S08_CALCULATION,
                 S09_SETUP_TIME * (CASE S09_SETUP_TIME_UOM    WHEN 'HOUR'   THEN 60
                                                              WHEN 'SECOND' THEN 1/06
                                                              WHEN 'DAY'    THEN 1440  ELSE 1 END ) S09_SETUP_TIME, TCAL_09 AS S09_CALCULATION,
                 S10_SETUP_TIME * (CASE S10_SETUP_TIME_UOM    WHEN 'HOUR'   THEN 60
                                                              WHEN 'SECOND' THEN 1/06
                                                              WHEN 'DAY'    THEN 1440  ELSE 1 END ) S10_SETUP_TIME, TCAL_10 AS S10_CALCULATION
          FROM   (
                  SELECT DISTINCT
                         A.*,
                         ISNULL(S01.SETUP_TIME,0) AS S01_SETUP_TIME, ISNULL(S01.SETUP_TIME_UOM, 'MINUTE') AS S01_SETUP_TIME_UOM,
                         ISNULL(S02.SETUP_TIME,0) AS S02_SETUP_TIME, ISNULL(S02.SETUP_TIME_UOM, 'MINUTE') AS S02_SETUP_TIME_UOM,
                         ISNULL(S03.SETUP_TIME,0) AS S03_SETUP_TIME, ISNULL(S03.SETUP_TIME_UOM, 'MINUTE') AS S03_SETUP_TIME_UOM,
                         ISNULL(S04.SETUP_TIME,0) AS S04_SETUP_TIME, ISNULL(S04.SETUP_TIME_UOM, 'MINUTE') AS S04_SETUP_TIME_UOM,
                         ISNULL(S05.SETUP_TIME,0) AS S05_SETUP_TIME, ISNULL(S05.SETUP_TIME_UOM, 'MINUTE') AS S05_SETUP_TIME_UOM,
                         ISNULL(S06.SETUP_TIME,0) AS S06_SETUP_TIME, ISNULL(S06.SETUP_TIME_UOM, 'MINUTE') AS S06_SETUP_TIME_UOM,
                         ISNULL(S07.SETUP_TIME,0) AS S07_SETUP_TIME, ISNULL(S07.SETUP_TIME_UOM, 'MINUTE') AS S07_SETUP_TIME_UOM,
                         ISNULL(S08.SETUP_TIME,0) AS S08_SETUP_TIME, ISNULL(S08.SETUP_TIME_UOM, 'MINUTE') AS S08_SETUP_TIME_UOM,
                         ISNULL(S09.SETUP_TIME,0) AS S09_SETUP_TIME, ISNULL(S09.SETUP_TIME_UOM, 'MINUTE') AS S09_SETUP_TIME_UOM,
                         ISNULL(S10.SETUP_TIME,0) AS S10_SETUP_TIME, ISNULL(S10.SETUP_TIME_UOM, 'MINUTE') AS S10_SETUP_TIME_UOM 
                  FROM   TH_BUF_SCM_SETUP_MATRIX_01 A
                         LEFT OUTER JOIN SY_SCM_SETUP_MATRIX_M S01
                              ON  A.FROM_SG_01    = CASE WHEN S01.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_01 ELSE S01.FROM_ITEM_SETUP_GROUP_ID END 
                              AND A.TO_SG_01      = CASE WHEN S01.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_01   ELSE S01.TO_ITEM_SETUP_GROUP_ID   END 
                              AND A.COMPANY_ID    = S01.COMPANY_ID
                              AND A.DIVISION_ID   = S01.DIVISION_ID
                              AND A.SITE_ID       = S01.SITE_ID
                              AND A.PLANT_ID      = S01.PLANT_ID
                              AND A.OPERATION_ID  = S01.OPERATION_ID
                              AND A.CATE_01       = S01.SETUP_CATEGORY_ID
                              AND A.KEY_01        = S01.SETUP_KEY_ID
                              AND A.LINE_SETUP_GROUP_ID = S01.LINE_SETUP_GROUP_ID
                         LEFT OUTER JOIN SY_SCM_SETUP_MATRIX_M S02
                              ON  A.FROM_SG_02    = CASE WHEN S02.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_02 ELSE S02.FROM_ITEM_SETUP_GROUP_ID END 
                              AND A.TO_SG_02      = CASE WHEN S02.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_02   ELSE S02.TO_ITEM_SETUP_GROUP_ID   END 
                              AND A.COMPANY_ID    = S02.COMPANY_ID
                              AND A.DIVISION_ID   = S02.DIVISION_ID
                              AND A.SITE_ID       = S02.SITE_ID
                              AND A.PLANT_ID      = S02.PLANT_ID
                              AND A.OPERATION_ID  = S02.OPERATION_ID
                              AND A.CATE_02       = S02.SETUP_CATEGORY_ID
                              AND A.KEY_02        = S02.SETUP_KEY_ID
                              AND A.LINE_SETUP_GROUP_ID   = S02.LINE_SETUP_GROUP_ID
                         LEFT OUTER JOIN SY_SCM_SETUP_MATRIX_M S03
                              ON  A.FROM_SG_03    = CASE WHEN S03.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_03 ELSE S03.FROM_ITEM_SETUP_GROUP_ID END 
                              AND A.TO_SG_03      = CASE WHEN S03.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_03   ELSE S03.TO_ITEM_SETUP_GROUP_ID   END 
                              AND A.COMPANY_ID    = S03.COMPANY_ID
                              AND A.DIVISION_ID   = S03.DIVISION_ID
                              AND A.SITE_ID       = S03.SITE_ID
                              AND A.PLANT_ID      = S03.PLANT_ID
                              AND A.OPERATION_ID  = S03.OPERATION_ID
                              AND A.LINE_SETUP_GROUP_ID   = S03.LINE_SETUP_GROUP_ID
                         LEFT OUTER JOIN SY_SCM_SETUP_MATRIX_M S04
                              ON  A.FROM_SG_04    = CASE WHEN S04.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_04 ELSE S04.FROM_ITEM_SETUP_GROUP_ID END 
                              AND A.TO_SG_04      = CASE WHEN S04.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_04   ELSE S04.TO_ITEM_SETUP_GROUP_ID   END 
                              AND A.COMPANY_ID    = S04.COMPANY_ID
                              AND A.DIVISION_ID   = S04.DIVISION_ID
                              AND A.SITE_ID       = S04.SITE_ID
                              AND A.PLANT_ID      = S04.PLANT_ID
                              AND A.OPERATION_ID  = S04.OPERATION_ID
                              AND A.LINE_SETUP_GROUP_ID   = S04.LINE_SETUP_GROUP_ID
                         LEFT OUTER JOIN SY_SCM_SETUP_MATRIX_M S05
                              ON  A.FROM_SG_05    = CASE WHEN S05.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_05 ELSE S05.FROM_ITEM_SETUP_GROUP_ID END 
                              AND A.TO_SG_05      = CASE WHEN S05.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_05   ELSE S05.TO_ITEM_SETUP_GROUP_ID   END 
                              AND A.COMPANY_ID    = S05.COMPANY_ID
                              AND A.DIVISION_ID   = S05.DIVISION_ID
                              AND A.SITE_ID       = S05.SITE_ID
                              AND A.PLANT_ID      = S05.PLANT_ID
                              AND A.OPERATION_ID  = S05.OPERATION_ID
                              AND A.LINE_SETUP_GROUP_ID   = S05.LINE_SETUP_GROUP_ID
                         LEFT OUTER JOIN SY_SCM_SETUP_MATRIX_M S06
                              ON  A.FROM_SG_06    = CASE WHEN S06.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_06 ELSE S06.FROM_ITEM_SETUP_GROUP_ID END 
                              AND A.TO_SG_06      = CASE WHEN S06.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_06   ELSE S06.TO_ITEM_SETUP_GROUP_ID   END 
                              AND A.COMPANY_ID    = S06.COMPANY_ID
                              AND A.DIVISION_ID   = S06.DIVISION_ID
                              AND A.SITE_ID       = S06.SITE_ID
                              AND A.PLANT_ID      = S06.PLANT_ID
                              AND A.OPERATION_ID  = S06.OPERATION_ID
                              AND A.LINE_SETUP_GROUP_ID   = S06.LINE_SETUP_GROUP_ID
                         LEFT OUTER JOIN SY_SCM_SETUP_MATRIX_M S07
                              ON  A.FROM_SG_07    = CASE WHEN S07.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_07 ELSE S07.FROM_ITEM_SETUP_GROUP_ID END 
                              AND A.TO_SG_07      = CASE WHEN S07.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_07   ELSE S07.TO_ITEM_SETUP_GROUP_ID   END 
                              AND A.COMPANY_ID    = S07.COMPANY_ID
                              AND A.DIVISION_ID   = S07.DIVISION_ID
                              AND A.SITE_ID       = S07.SITE_ID
                              AND A.PLANT_ID      = S07.PLANT_ID
                              AND A.OPERATION_ID  = S07.OPERATION_ID
                              AND A.LINE_SETUP_GROUP_ID   = S07.LINE_SETUP_GROUP_ID
                         LEFT OUTER JOIN SY_SCM_SETUP_MATRIX_M S08
                              ON  A.FROM_SG_08    = CASE WHEN S08.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_08 ELSE S08.FROM_ITEM_SETUP_GROUP_ID END 
                              AND A.TO_SG_08      = CASE WHEN S08.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_08   ELSE S08.TO_ITEM_SETUP_GROUP_ID   END 
                              AND A.COMPANY_ID    = S08.COMPANY_ID
                              AND A.DIVISION_ID   = S08.DIVISION_ID
                              AND A.SITE_ID       = S08.SITE_ID
                              AND A.PLANT_ID      = S08.PLANT_ID
                              AND A.OPERATION_ID  = S08.OPERATION_ID
                              AND A.LINE_SETUP_GROUP_ID   = S08.LINE_SETUP_GROUP_ID
                         LEFT OUTER JOIN SY_SCM_SETUP_MATRIX_M S09
                              ON  A.FROM_SG_09    = CASE WHEN S09.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_09 ELSE S09.FROM_ITEM_SETUP_GROUP_ID END 
                              AND A.TO_SG_09      = CASE WHEN S09.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_09   ELSE S09.TO_ITEM_SETUP_GROUP_ID   END 
                              AND A.COMPANY_ID    = S09.COMPANY_ID
                              AND A.DIVISION_ID   = S09.DIVISION_ID
                              AND A.SITE_ID       = S09.SITE_ID
                              AND A.PLANT_ID      = S09.PLANT_ID
                              AND A.OPERATION_ID  = S09.OPERATION_ID
                              AND A.LINE_SETUP_GROUP_ID   = S09.LINE_SETUP_GROUP_ID
                         LEFT OUTER JOIN SY_SCM_SETUP_MATRIX_M S10
                              ON  A.FROM_SG_10    = CASE WHEN S10.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_10 ELSE S10.FROM_ITEM_SETUP_GROUP_ID END 
                              AND A.TO_SG_10      = CASE WHEN S10.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_10   ELSE S10.TO_ITEM_SETUP_GROUP_ID   END 
                              AND A.COMPANY_ID    = S10.COMPANY_ID
                              AND A.DIVISION_ID   = S10.DIVISION_ID
                              AND A.SITE_ID       = S10.SITE_ID
                              AND A.PLANT_ID      = S10.PLANT_ID
                              AND A.OPERATION_ID  = S10.OPERATION_ID
                              AND A.LINE_SETUP_GROUP_ID   = S10.LINE_SETUP_GROUP_ID   
                 ) A
        
          SET @n_row_count += @@ROWCOUNT

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
          */
          
        END
        
        -- STEP 3. 동일한 FROM_SETUP_GROUP_ID, TO_SETUP_GROUP_ID 를 기준으로 1차 MAX SETUP 시간을 계산하고,
        --         해당 MAX SETUP 시간과 SUM 대상이 되는 SETUP 시간을 같이 더한다.
        --         = ( MAX (A,B,C) + SUM( D,E,F ) )
        BEGIN

          SET @v_table_name = 'TH_BUF_SCM_SETUP_MATRIX'
          SET @n_row_count = 0
          
          DELETE FROM TH_BUF_SCM_SETUP_MATRIX

          INSERT INTO TH_BUF_SCM_SETUP_MATRIX
          SELECT DISTINCT
                 A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
                 A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
                 SUM(SETUP_TIME) AS SETUP_TIME,
                 'MINUTE' AS SETUP_TIME_UOM
          FROM   (
                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
                         A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
                         MAX(SETUP_TIME) AS SETUP_TIME
                  FROM   (
                          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
                                 A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
                                 B.INT AS LEVEL,
                                 CASE INT WHEN  1 THEN S01_SETUP_TIME
                                          WHEN  2 THEN S02_SETUP_TIME
                                          WHEN  3 THEN S03_SETUP_TIME
                                          WHEN  4 THEN S04_SETUP_TIME
                                          WHEN  5 THEN S05_SETUP_TIME
                                          WHEN  6 THEN S06_SETUP_TIME
                                          WHEN  7 THEN S07_SETUP_TIME
                                          WHEN  8 THEN S08_SETUP_TIME
                                          WHEN  9 THEN S09_SETUP_TIME
                                          WHEN 10 THEN S10_SETUP_TIME
                                                  ELSE 0
                                  END  SETUP_TIME
                          FROM   TH_BUF_SCM_SETUP_MATRIX_02 A,
                                 (
                                  SELECT INT, 'MAX' AS CALCULATION 
                                  FROM   COPYT
                                  WHERE  INT <= 10
                                 ) B
                          WHERE  B.CALCULATION =    ( 
                                                     CASE INT WHEN  1 THEN S01_CALCULATION
                                                              WHEN  2 THEN S02_CALCULATION
                                                              WHEN  3 THEN S03_CALCULATION
                                                              WHEN  4 THEN S04_CALCULATION
                                                              WHEN  5 THEN S05_CALCULATION
                                                              WHEN  6 THEN S06_CALCULATION
                                                              WHEN  7 THEN S07_CALCULATION
                                                              WHEN  8 THEN S08_CALCULATION
                                                              WHEN  9 THEN S09_CALCULATION
                                                              WHEN 10 THEN S10_CALCULATION
                                                                      ELSE 'MAX'
                                                      END
                                                     )
                         ) A
                  GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
                            A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID
                  UNION  ALL
                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
                         A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
                         CASE INT WHEN  1 THEN S01_SETUP_TIME
                                  WHEN  2 THEN S02_SETUP_TIME
                                  WHEN  3 THEN S03_SETUP_TIME
                                  WHEN  4 THEN S04_SETUP_TIME
                                  WHEN  5 THEN S05_SETUP_TIME
                                  WHEN  6 THEN S06_SETUP_TIME
                                  WHEN  7 THEN S07_SETUP_TIME
                                  WHEN  8 THEN S08_SETUP_TIME
                                  WHEN  9 THEN S09_SETUP_TIME
                                  WHEN 10 THEN S10_SETUP_TIME
                                          ELSE 0
                          END  SETUP_TIME
                  FROM   TH_BUF_SCM_SETUP_MATRIX_02 A,
                         (
                          SELECT INT, 'SUM' AS CALCULATION 
                          FROM   COPYT
                          WHERE  INT <= 10
                         ) B
                  WHERE  B.CALCULATION =    ( 
                                             CASE INT WHEN  1 THEN S01_CALCULATION
                                                      WHEN  2 THEN S02_CALCULATION
                                                      WHEN  3 THEN S03_CALCULATION
                                                      WHEN  4 THEN S04_CALCULATION
                                                      WHEN  5 THEN S05_CALCULATION
                                                      WHEN  6 THEN S06_CALCULATION
                                                      WHEN  7 THEN S07_CALCULATION
                                                      WHEN  8 THEN S08_CALCULATION
                                                      WHEN  9 THEN S09_CALCULATION
                                                      WHEN 10 THEN S10_CALCULATION
                                                              ELSE 'MAX'
                                              END
                                             )
                 ) A
          GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
                    A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID       
        
          SET @n_row_count += @@ROWCOUNT

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
          EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

        END
    
    END
    
    -- 위에서 설정되어진 
    -- 1. TH_BUF_SCM_SETUP_ITEM   은 TH_MST_ITEM 의 SETUP_GROUP_ID 로 MAPPING 하고
    -- 2. TH_BUF_SCM_SETUP_MATRIX 는 TH_MST_SETUP_CATEGORY, TH_MST_SETUP_TIME 을 설정한다...
    --                               LINE_SETUP_GROUP_ID 는 TH_MST_RESOURCE 의 RESOURCE_SETUP_GROUP_ID 로 설정될 수 있게 한다.
    
    BEGIN

      SET @v_table_name = 'TH_MST_ITEM'
      SET @n_row_count = 0

      UPDATE TH_MST_ITEM
      SET    TH_MST_ITEM.SETUP_GROUP_ID = B.SETUP_GROUP_ID
      FROM   TH_MST_ITEM A,
             TH_BUF_SCM_SETUP_ITEM B
      WHERE  A.MASTER_ID = @v_master_id
      AND    A.PLAN_ID = @v_plan_id
      AND    A.ITEM_ID = B.ITEM_ID    
      
      SET @n_row_count += @@ROWCOUNT

      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

      SET @v_table_name = 'TH_MST_ITEM'
      SET @n_row_count = 0

      UPDATE TH_MST_ITEM_ROUTE_SITE
      SET    TH_MST_ITEM_ROUTE_SITE.IRS_ATTB_2 = B.SETUP_GROUP_ID
      FROM   TH_MST_ITEM_ROUTE_SITE A,
             TH_BUF_SCM_SETUP_ITEM B
      WHERE  A.MASTER_ID = @v_master_id
      AND    A.PLAN_ID = @v_plan_id
      AND    A.ITEM_ID = B.ITEM_ID
      AND    A.OPERATION_ID = B.OPERATION_ID
      AND    A.IRS_ATTB_11 = B.COMPANY_ID
      AND    A.IRS_ATTB_12 = B.DIVISION_ID
      AND    A.IRS_ATTB_13 = B.SITE_ID
      
      SET @n_row_count += @@ROWCOUNT

      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

    END
    /*
    BEGIN

      SET @v_table_name = 'TH_MST_RESOURCE'
      SET @n_row_count = 0

      UPDATE TH_MST_RESOURCE
      SET    TH_MST_RESOURCE.RESOURCE_SETUP_GROUP_ID = B.RES_SETUP + '_SG'
      FROM   TH_MST_RESOURCE A,
             (
              SELECT DISTINCT LINE_SETUP_GROUP_ID + '_' + OPERATION_ID AS RES_SETUP
              FROM   TH_BUF_SCM_SETUP_MATRIX 
             )B
      WHERE  A.MASTER_ID = @v_master_id
      AND    A.PLAN_ID = @v_plan_id
      AND    A.RESOURCE_ID = B.RES_SETUP
      
      SET @n_row_count += @@ROWCOUNT

      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null

    END
    */

    BEGIN

      SET @v_table_name = 'TH_MST_SETUP_CATEGORY'
      SET @n_row_count = 0
      
      DELETE FROM TH_MST_SETUP_CATEGORY
      WHERE  MASTER_ID = @v_master_id
      AND    PLAN_ID = @v_plan_id

      INSERT INTO TH_MST_SETUP_CATEGORY
              (
                MASTER_ID
              , PLAN_ID
              , SETUP_CATEGORY_ID
              , SETUP_LEVEL
              , DESCR
              , KEY_DATE
              , INSERT_ID
              , INSERT_DTTM
              , UPDATE_ID
              , UPDATE_DTTM              
              )      
      SELECT 
                @v_master_id AS MASTER_ID
              , @v_plan_id AS PLAN_ID
              , LINE_SETUP_GROUP_ID AS SETUP_CATEGORY_ID
              , 1 AS SETUP_LEVEL
              , NULL AS DESCR
              , @key_date AS KEY_DATE
              , @v_proc_name AS INSERT_ID
              , GETDATE() AS INSERT_DTTM
              , @v_proc_name AS UPDATE_ID
              , GETDATE() AS UPDATE_DTTM
      FROM   (
              SELECT  LINE_SETUP_GROUP_ID
              FROM    TH_BUF_SCM_SETUP_MATRIX
              WHERE   SETUP_TIME > 0
              GROUP   BY LINE_SETUP_GROUP_ID
              UNION   ALL
              SELECT  LINE_SETUP_GROUP_ID
              FROM    SY_SCM_SETUP_MATRIX_M A
              WHERE   A.SETUP_TIME > 0
              AND     A.FROM_ITEM_SETUP_GROUP_ID = 'ALL'
              AND     A.TO_ITEM_SETUP_GROUP_ID = 'ALL'
              AND     EXISTS (SELECT 1
                              FROM   TH_MST_INSTANCE_FLOW X
                              WHERE  X.MASTER_ID = @v_master_id
                              AND    X.PLAN_ID = @v_plan_id
                              AND    A.COMPANY_ID = X.COMPANY_ID
                              AND    A.DIVISION_ID = X.DIVISION_ID
                              AND    A.SITE_ID = X.SITE_ID
                              AND    A.OPERATION_ID = X.OPERATION_ID)
             ) A
      GROUP  BY  LINE_SETUP_GROUP_ID

      SET @n_row_count += @@ROWCOUNT

      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
    
    END
    
    BEGIN

      SET @v_table_name = 'TH_MST_SETUP_TIME'
      SET @n_row_count = 0
      
      DELETE FROM TH_MST_SETUP_TIME
      WHERE  MASTER_ID = @v_master_id
      AND    PLAN_ID = @v_plan_id

      INSERT INTO TH_MST_SETUP_TIME
              (
                MASTER_ID
              , PLAN_ID
              , RESOURCE_SETUP_GROUP_ID
              , SETUP_CATEGORY_ID
              , FROM_SETUP_ID
              , TO_SETUP_ID
              , SETUP_TIME
              , FIRST_SETUP_TIME
              , SETUP_TIME_UOM
              , DESCR
              , KEY_DATE
              , INSERT_ID
              , INSERT_DTTM
              , UPDATE_ID
              , UPDATE_DTTM
              )
      SELECT 
                @v_master_id        AS MASTER_ID
              , @v_plan_id          AS PLAN_ID
              , LINE_SETUP_GROUP_ID AS RESOURCE_SETUP_GROUP_ID
              , LINE_SETUP_GROUP_ID AS SETUP_CATEGORY_ID
              , FROM_SETUP_GROUP_ID AS FROM_SETUP_ID
              , TO_SETUP_GROUP_ID   AS TO_SETUP_ID
              , MAX(SETUP_TIME)     AS SETUP_TIME
              , 0                   AS FIRST_SETUP_TIME
              , SETUP_TIME_UOM
              , NULL                AS DESCR
              , @key_date           AS KEY_DATE
              , @v_proc_name        AS INSERT_ID
              , GETDATE()      AS INSERT_DTTM
              , @v_proc_name        AS UPDATE_ID
              , GETDATE()           AS UPDATE_DTTM
      FROM   (
              SELECT  A.LINE_SETUP_GROUP_ID
                    , A.FROM_SETUP_GROUP_ID
                    , A.TO_SETUP_GROUP_ID
                    , A.SETUP_TIME
                    , A.SETUP_TIME_UOM
              FROM    TH_BUF_SCM_SETUP_MATRIX A
              WHERE   SETUP_TIME > 0
              UNION   ALL
              SELECT  A.LINE_SETUP_GROUP_ID
                    , A.FROM_ITEM_SETUP_GROUP_ID  AS FROM_SETUP_GROUP_ID
                    , A.TO_ITEM_SETUP_GROUP_ID    AS TO_SETUP_GROUP_ID
                    , A.SETUP_TIME
                    , A.SETUP_TIME_UOM
              FROM    SY_SCM_SETUP_MATRIX_M A
              WHERE   A.SETUP_TIME > 0
              AND     A.FROM_ITEM_SETUP_GROUP_ID  = 'ALL'
              AND     A.TO_ITEM_SETUP_GROUP_ID    = 'ALL'
              AND     EXISTS (SELECT 1
                              FROM   TH_MST_INSTANCE_FLOW X
                              WHERE  X.MASTER_ID = @v_master_id
                              AND    X.PLAN_ID = @v_plan_id
                              AND    A.COMPANY_ID = X.COMPANY_ID
                              AND    A.DIVISION_ID = X.DIVISION_ID
                              AND    A.SITE_ID = X.SITE_ID
                              AND    A.OPERATION_ID = X.OPERATION_ID)
             ) A
      GROUP  BY A.LINE_SETUP_GROUP_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID, A.SETUP_TIME_UOM
    
      SET @n_row_count += @@ROWCOUNT
            
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

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
