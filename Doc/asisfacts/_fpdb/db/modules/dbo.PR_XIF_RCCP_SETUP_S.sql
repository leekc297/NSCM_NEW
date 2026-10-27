
--CREATE PROCEDURE [dbo].[PR_XIF_RCCP_SETUP_S]
CREATE PROCEDURE [dbo].[PR_XIF_RCCP_SETUP_S]
--    @P_SITE_ID  NVARCHAR(50)
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_XIF_RCCP_SETUP_TYPE_S		             					          **/
/** 프로그램 명   :											                                  **/
/** 설 명         :											                                  **/
/** Version       : 1.0.0                                                                     **/
/**                 			                                                              **/
/** Argument     										        							  **/
/**                 			                                                              **/
/**	[검색 조건]																				  **/
/**                 			                                                              **/
/** [Biz Logic]										        								  **/
/**                 			                                                              **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자		작 성 자			사	   유											  **/
/**===========================================================================================**/
/** 2016.12.14		KIMCD				최초 작성											  **/
/***********************************************************************************************/
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
	SET XACT_ABORT ON;

  -- LOG 용 변수 설정
	DECLARE @v_proc_name		nvarchar(100) = 'PR_XIF_RCCP_SETUP_S'
	DECLARE @v_table_name		nvarchar(100)
	DECLARE @v_message			nvarchar(250)
	DECLARE @v_descr			nvarchar(250)
	DECLARE @n_row_count		Integer	= 0
	DECLARE @n_log_count  		Integer	= 0
	DECLARE @IF_SEQ             NVARCHAR(50)
	DECLARE @IF_TYPE            NVARCHAR(1)
	DECLARE @IF_ID              NVARCHAR(50)
	DECLARE @IF_INS_DATE        DATETIME
	DECLARE @IF_FLAG            NVARCHAR(1)
	DECLARE @IF_SND_DATE        DATETIME
	DECLARE @DIVISION_CODE      NVARCHAR(10)
	DECLARE @SITE_CODE          NVARCHAR(40)
	DECLARE @ITEM_CODE          NVARCHAR(40)
	DECLARE @ITEM_NAME          NVARCHAR(100)
	DECLARE @SETUP_TYPE         NVARCHAR(40)
	DECLARE @CREATE_USER_ID     VARCHAR(50)
	DECLARE @CREATE_DATE        DATETIME
	DECLARE @MODIFY_USER_ID     VARCHAR(50)
	DECLARE @MODIFY_DATE        DATETIME
	DECLARE @FROM_SETUP_TYPE    NVARCHAR(40)
	DECLARE @TO_SETUP_TYPE      NVARCHAR(40)
	DECLARE @SETUP_TIME         NUMERIC(18, 3)

	
	DECLARE @sysdate			DATETIME2 = GETDATE()
	DECLARE @key_date			nvarchar(8)

	DECLARE @v_temp1			nvarchar(1000)
	DECLARE @v_temp2			nvarchar(1000)
  
	SET @v_temp1 = 'S' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
	SET @v_temp2 = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  
  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate       

  BEGIN TRY
  BEGIN TRANSACTION;
    
    --LOG 생성
    SET @sysdate = GETDATE()
    SET @v_temp1 = 'XIF_RCCP_SCM_SETUP_BOM'
    
    BEGIN
    
      SET @v_table_name = '[dbo].[SY_XIF_RCCP_SCM_SETUP_BOM'
      SET @n_row_count = 0
      
      /* 
      SETUP CATEGORY 가 MATERIAL 일 경우 BOM 을 전개해야함.
      SETUP 을 설정해야할 OPERATION 과 SETUP 정보를 참조할 참조 OPERATION 이 다르게 때문이다.
      그래서 BOM 을 1차 전개한 정보를 [dbo].[SY_XIF_RCCP_SCM_SETUP_BOM 에 넣고, 이걸 재귀참고하여 참조OPERATION 을 찾는다.
      */
      DELETE FROM [dbo].[SY_XIF_RCCP_SCM_SETUP_BOM];
      
      INSERT INTO [dbo].[SY_XIF_RCCP_SCM_SETUP_BOM]
      SELECT DISTINCT
             A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, 
             A.PARENT_ITEM_ID, B.OPERATION_ID, A.CHILD_ITEM_ID, C.ITEM_TYPE, 
             D.LEVEL_2_CODE AS SETUP_KEY_ID, C.SETUP_ATTRIBUTE, C.ITEM_ATTRIBUTE
      FROM   (
              SELECT AA.* 
              FROM   LGCE_FPDEV_TR.DBO.SCM_BOM_M AA WITH(NOLOCK),
                     (
                      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID,
                             MAX(KEY_DATE) AS KEY_DATE
                      FROM   LGCE_FPDEV_TR.DBO.SCM_BOM_M         A WITH(NOLOCK),
                             LGCE_FPDEV_TR.DBO.SCM_ITEM_M        B WITH(NOLOCK),
                             LGCE_FPDEV_TR.DBO.SCM_ITEM_CLASS_M  C WITH(NOLOCK)
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
                      AND    A.EFF_END_DATE   >  CONVERT(DATE, @sysdate)
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
              AND    AA.EFF_END_DATE   >  CONVERT(DATE, @sysdate)
             ) A,
             LGCE_FPDEV_TR.DBO.SCM_ITEM_FLOW_V   B WITH(NOLOCK),
             LGCE_FPDEV_TR.DBO.SCM_ITEM_M        C WITH(NOLOCK),
             LGCE_FPDEV_TR.DBO.SCM_ITEM_CLASS_M  D WITH(NOLOCK)
      WHERE  1=1 --A.INSERT_ID = 'THIRAUTECH'
      AND    A.ACTIVE_FLAG = 'Y'
      AND    A.COMPANY_ID = B.COMPANY_ID
      AND    A.DIVISION_ID = B.DIVISION_ID
      AND    A.SITE_ID = B.SITE_ID
      --AND    A.PLANT_ID = B.PLANT_ID
      AND    A.PARENT_ITEM_ID = B.ITEM_ID 
      AND    A.COMPANY_ID = C.COMPANY_ID
      AND    A.DIVISION_ID = C.DIVISION_ID
      AND    A.SITE_ID = C.SITE_ID
      AND    A.CHILD_ITEM_ID = C.ITEM_ID
      AND    C.ACTIVE_FLAG = 'Y'
      AND    C.ITEM_CLASS = D.CLASS_ID
      AND    D.USE_FLAG = 'Y'


      SET @n_row_count += @@ROWCOUNT

      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()

      INSERT [LGCE_INFDEV].[dbo].[XIF_LOG_HISTORY](
			  PROC_NAME, 
              TABLE_NAME, 
              LOG_TYPE, 
              LOG_COUNT, 
              LOG_CODE, 
              MESSAGE, 
              DESCR,
			  EVENT_DTTM)
       VALUES (
              @v_proc_name,    -- 1 
              NULL,            -- 2
              'INSERT',        -- 3
              @n_log_count,    -- 4
              @v_temp1,        -- 5
              @v_message,      -- 6
              'INSERT [dbo].[SY_XIF_RCCP_SCM_SETUP_BOM]',      -- 7
			  SYSDATETIME());

    END
    
    -- setup category 가 MATERIAL 인 것에 대해 data 추출
    -- bom 을 전개하여 실제 setup 반영될 item attribute list 정보를 추출하는 부분
    BEGIN

      SET @v_table_name = '[dbo].[SY_XIF_RCCP_SCM_SETUP_ITEM_LIST'
      SET @n_row_count = 0
      
      DELETE FROM [dbo].[SY_XIF_RCCP_SCM_SETUP_ITEM_LIST];

      INSERT INTO [dbo].[SY_XIF_RCCP_SCM_SETUP_ITEM_LIST]
      SELECT DISTINCT
             A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.SETUP_CATEGORY_ID,
             A.SETUP_KEY_ID, A.LEVEL, 
             A.KEY_ITEM_ID, 
             A.KEY_OPERATION_ID,
             A.CALCULATION,
             NULL SETUP_ATTRIBUTE,
             A.ITEM_ATTRIBUTE
      FROM   (
              SELECT AA.COMPANY_ID, AA.DIVISION_ID, AA.SITE_ID, AA.PLANT_ID, 
                     AA.SETUP_CATEGORY_ID, AA.SETUP_KEY_ID, AA.LEVEL, 
                     AA.REFERANCE_OPERATION_ID, AA.CALCULATION, AA.SORT_ORDER,
                     AA.KEY_ITEM_ID, AA.KEY_OPERATION_ID,
                     CASE WHEN OPERATION_ID_1 = AA.REFERANCE_OPERATION_ID THEN SETUP_ATTRIBUTE_2
                          WHEN OPERATION_ID_2 = AA.REFERANCE_OPERATION_ID THEN SETUP_ATTRIBUTE_3
                          ELSE NULL
                     END  SETUP_ATTRIBUTE,
                     CASE WHEN OPERATION_ID_1 = AA.REFERANCE_OPERATION_ID THEN ITEM_ATTRIBUTE_2
                          WHEN OPERATION_ID_2 = AA.REFERANCE_OPERATION_ID THEN ITEM_ATTRIBUTE_3
                          ELSE NULL
                     END  ITEM_ATTRIBUTE
              FROM   (
                      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, 
                             A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, 
                             A.REFERANCE_OPERATION_ID, A.CALCULATION, A.SORT_ORDER,
                             A.KEY_ITEM_ID, A.KEY_OPERATION_ID, 
                             A.ITEM_ID_1, A.OPERATION_ID_1, A.ITEM_TYPE_1, A.SETUP_ATTRIBUTE_1, A.ITEM_ATTRIBUTE_1,
                             A.ITEM_ID_2, C.OPERATION_ID AS OPERATION_ID_2, A.ITEM_TYPE_2, A.SETUP_ATTRIBUTE_2, A.ITEM_ATTRIBUTE_2,
                             C.CHILD_ITEM_ID ITEM_ID_3, C.ITEM_TYPE ITEM_TYPE_3, C.SETUP_ATTRIBUTE SETUP_ATTRIBUTE_3, C.ITEM_ATTRIBUTE ITEM_ATTRIBUTE_3
                      FROM   (                
                              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, 
                                     A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, 
                                     A.REFERANCE_OPERATION_ID, A.CALCULATION, A.SORT_ORDER,
                                     A.KEY_ITEM_ID, A.KEY_OPERATION_ID, A.ITEM_ID_1, B.OPERATION_ID OPERATION_ID_1, A.ITEM_TYPE_1, A.SETUP_ATTRIBUTE_1, A.ITEM_ATTRIBUTE_1,
                                     B.CHILD_ITEM_ID ITEM_ID_2, B.ITEM_TYPE ITEM_TYPE_2, B.SETUP_ATTRIBUTE SETUP_ATTRIBUTE_2, B.ITEM_ATTRIBUTE ITEM_ATTRIBUTE_2
                              FROM   (
                                      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, 
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
                                      FROM   [dbo].[SY_XIF_RCCP_SCM_SETUP_BOM] A WITH(NOLOCK),
                                             (
                                              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, 
                                                     A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, 
                                                     A.REFERANCE_OPERATION_ID, A.CALCULATION, B.SORT_ORDER
                                              FROM   LGCE_FPDEV_TR.DBO.SCM_ITEM_SETUP_GROUP_M  A WITH(NOLOCK),
                                                     LGCE_FPDEV_TR.DBO.SCM_SYS_LOOKUP_VALUE    B WITH(NOLOCK)
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
                                      --AND    A.SETUP_KEY_ID = B.SETUP_KEY_ID  -- 2016.12.08 주석처리
                                     ) A
                                     LEFT OUTER JOIN [dbo].[SY_XIF_RCCP_SCM_SETUP_BOM] B WITH(NOLOCK)
                                          ON     1=1
                                          AND    A.COMPANY_ID = B.COMPANY_ID
                                          AND    A.DIVISION_ID = B.DIVISION_ID
                                          AND    A.SITE_ID = B.SITE_ID
                                          --AND    A.PLANT_ID = B.PLANT_ID        -- 2016.12.08 주석처리
                                          AND    A.ITEM_ID_1 = B.PARENT_ITEM_ID
                                          AND    A.SETUP_KEY_ID = B.SETUP_KEY_ID    
                             ) A
                             LEFT OUTER JOIN [dbo].[SY_XIF_RCCP_SCM_SETUP_BOM] C WITH(NOLOCK)
                                  ON     1=1
                                  AND    A.COMPANY_ID = C.COMPANY_ID
                                  AND    A.DIVISION_ID = C.DIVISION_ID
                                  AND    A.SITE_ID = C.SITE_ID
                                  --AND    A.PLANT_ID = C.PLANT_ID                -- 2016.12.08 주석처리
                                  AND    A.ITEM_ID_2 = C.PARENT_ITEM_ID
                                  AND    A.SETUP_KEY_ID = C.SETUP_KEY_ID
                     ) AA
             ) A,
             LGCE_FPDEV_TR.DBO.SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK)
      WHERE  B.LOOKUP_TYPE_CODE = 'ITEM_ATTRIBUTE'
      AND    A.SETUP_KEY_ID = B.SEGMENT3
      AND    A.DIVISION_ID = B.SEGMENT1
      AND    A.SITE_ID = B.SEGMENT2
      AND    A.ITEM_ATTRIBUTE = B.SEGMENT4
    
      SET @n_row_count += @@ROWCOUNT

      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      INSERT [LGCE_INFDEV].[dbo].[XIF_LOG_HISTORY](
			  PROC_NAME, 
              TABLE_NAME, 
              LOG_TYPE, 
              LOG_COUNT, 
              LOG_CODE, 
              MESSAGE, 
              DESCR,
			  EVENT_DTTM)
       VALUES (
              @v_proc_name,    -- 1 
              NULL,            -- 2
              'INSERT',        -- 3
              @n_log_count,    -- 4
              'XIF_RCCP_SCM_SETUP_ITEM_LIST', -- @v_temp1,        -- 5
              @v_message,      -- 6
              'INSERT [dbo].[SY_XIF_RCCP_SCM_SETUP_ITEM_LIST]',      -- 7
			  SYSDATETIME());
      
    END
    
    /* 각각 item 에 대해 item_attribute_combine 정보를 추출하는 부분
    */
    BEGIN

      SET @v_table_name = '[dbo].[SY_XIF_RCCP_SCM_SETUP_ITEM_COMBINE'
      SET @n_row_count = 0
      
      DELETE FROM [dbo].[SY_XIF_RCCP_SCM_SETUP_ITEM_COMBINE];

      insert into [dbo].[SY_XIF_RCCP_SCM_SETUP_ITEM_COMBINE]
      SELECT DISTINCT
             A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, 
             A.ITEM_ID, A.OPERATION_ID, A.CALCULATION, A.ITEM_SETUP_GROUP_ID
      FROM   (
              SELECT DISTINCT
                     A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, 
                     A.ITEM_ID, A.OPERATION_ID, A.CALCULATION,
                     B.SEGMENT4 AS ITEM_SETUP_GROUP_ID,
                     A.CNT, A.SEQ, B.SEGMENT4_CNT, SEGMENT4_SEQ,
                     COUNT(1) OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, A.SETUP_KEY_ID, 
                                                 A.LEVEL, A.ITEM_ID, A.OPERATION_ID, A.CALCULATION, B.SEGMENT4) COMBINE_CNT
              FROM   (
                      SELECT A.*,
                             COUNT(1) OVER (PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, SETUP_KEY_ID) CNT,
                             ROW_NUMBER() OVER (PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, SETUP_KEY_ID ORDER BY ITEM_ATTRIBUTE) SEQ       
                      FROM   [dbo].[SY_XIF_RCCP_SCM_SETUP_ITEM_LIST] A WITH(NOLOCK)
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
                                     CASE WHEN INT = 1 THEN CASE WHEN ISNULL(LTRIM(RTRIM(ATTRIBUTE1)),'') = '' THEN NULL ELSE ATTRIBUTE1 END
                                          WHEN INT = 2 THEN CASE WHEN ISNULL(LTRIM(RTRIM(ATTRIBUTE2)),'') = '' THEN NULL ELSE ATTRIBUTE2 END
                                          WHEN INT = 3 THEN CASE WHEN ISNULL(LTRIM(RTRIM(ATTRIBUTE3)),'') = '' THEN NULL ELSE ATTRIBUTE3 END
                                          WHEN INT = 4 THEN CASE WHEN ISNULL(LTRIM(RTRIM(ATTRIBUTE4)),'') = '' THEN NULL ELSE ATTRIBUTE4 END
                                          WHEN INT = 5 THEN CASE WHEN ISNULL(LTRIM(RTRIM(ATTRIBUTE5)),'') = '' THEN NULL ELSE ATTRIBUTE5 END
                                          ELSE NULL
                                     END  ITEM_ATTRIBUTE
                              from   LGCE_FPDEV_TR.DBO.SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK),
                                     COPYT B WITH(NOLOCK)
                              where  lookup_type_code = 'ITEM_ATTRIBUTE_COMBINE'
                              AND    INT <= 5
                             ) A
                      WHERE  ITEM_ATTRIBUTE IS NOT NULL       
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
      -- EXEC PR_XIF_LOG @v_proc_name, NULL, 'INSERT', @n_row_count, @v_message, @n_log_count, 'INSERT [dbo].[SY_XIF_RCCP_SCM_SETUP_ITEM_COMBINE 1', @sysdate
      INSERT [LGCE_INFDEV].[dbo].[XIF_LOG_HISTORY](
			  PROC_NAME, 
              TABLE_NAME, 
              LOG_TYPE, 
              LOG_COUNT, 
              LOG_CODE, 
              MESSAGE, 
              DESCR,
			  EVENT_DTTM)
       VALUES (
              @v_proc_name,    -- 1 
              NULL,            -- 2
              'INSERT',        -- 3
              @n_row_count,    -- 4
              @n_log_count,    -- 5
              @v_message,      -- 6
              'INSERT [dbo].[SY_XIF_RCCP_SCM_SETUP_ITEM_COMBINE 1',      -- 7
			  SYSDATETIME());

      insert into [dbo].[SY_XIF_RCCP_SCM_SETUP_ITEM_COMBINE]
      SELECT DISTINCT
             A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, 
             A.ITEM_ID, A.OPERATION_ID, A.CALCULATION,
             A.ITEM_ATTRIBUTE AS ITEM_SETUP_GROUP_ID      
      FROM   [dbo].[SY_XIF_RCCP_SCM_SETUP_ITEM_LIST] A WITH(NOLOCK)
      WHERE  A.ITEM_ATTRIBUTE IS NOT NULL
      AND    NOT EXISTS (
                          SELECT 1
                          FROM   [dbo].[SY_XIF_RCCP_SCM_SETUP_ITEM_COMBINE] B WITH(NOLOCK)
                          WHERE  A.COMPANY_ID = B.COMPANY_ID
                          AND    A.DIVISION_ID = B.DIVISION_ID
                          AND    A.SITE_ID = B.SITE_ID
                          AND    A.PLANT_ID = B.PLANT_ID
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
      -- EXEC PR_XIF_LOG @v_proc_name, NULL, 'INSERT', @n_row_count, @v_message, @n_log_count, 'INSERT [dbo].[SY_XIF_RCCP_SCM_SETUP_ITEM_COMBINE 2', @sysdate
      INSERT [LGCE_INFDEV].[dbo].[XIF_LOG_HISTORY](
			  PROC_NAME, 
              TABLE_NAME, 
              LOG_TYPE, 
              LOG_COUNT, 
              LOG_CODE, 
              MESSAGE, 
              DESCR,
			  EVENT_DTTM)
       VALUES (
              @v_proc_name,    -- 1 
              NULL,            -- 2
              'INSERT',        -- 3
              @n_row_count,    -- 4
              @n_log_count,    -- 5
              @v_message,      -- 6
              'INSERT [dbo].[SY_XIF_RCCP_SCM_SETUP_ITEM_COMBINE 2',      -- 7
			  SYSDATETIME());

      
      INSERT INTO [dbo].[SY_XIF_RCCP_SCM_SETUP_ITEM_COMBINE]
      SELECT DISTINCT A.*
      FROM   (
              SELECT DISTINCT
                     A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, B.PLANT_ID,
                     A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, 
                     B.ITEM_ID, B.OPERATION_ID, A.CALCULATION,
                     C.SETUP_ATTRIBUTE AS ITEM_SETUP_GROUP_ID         
              FROM   (
                      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, 
                             A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, 
                             A.REFERANCE_OPERATION_ID, A.CALCULATION, B.SORT_ORDER
                      FROM   LGCE_FPDEV_TR.DBO.SCM_ITEM_SETUP_GROUP_M  A WITH(NOLOCK),
                             LGCE_FPDEV_TR.DBO.SCM_SYS_LOOKUP_VALUE    B WITH(NOLOCK)
                      WHERE  B.LOOKUP_TYPE_CODE = 'SETUP_CATEGORY'
                      AND    UPPER(A.SETUP_CATEGORY_ID) = UPPER('ATTRIBUTE')
                      AND    A.SETUP_CATEGORY_ID = B.SEGMENT1
                      AND    A.OPERATION_ID != A.REFERANCE_OPERATION_ID
                      GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, 
                                A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, 
                                A.REFERANCE_OPERATION_ID, A.CALCULATION, B.SORT_ORDER
                     ) A,
                     LGCE_FPDEV_TR.DBO.SCM_ITEM_FLOW_V B WITH(NOLOCK),
                     LGCE_FPDEV_TR.DBO.SCM_ITEM_M      C WITH(NOLOCK)
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

      SET @n_row_count = @@ROWCOUNT

      --LOG 생성
      SET @v_message = 'SETUP_CATEGORY_ID : ATTRIBUTE - INSERT COUNT : ' + CONVERT(nvarchar, @n_row_count)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      -- EXEC PR_XIF_LOG @v_proc_name, NULL, 'INSERT', @n_row_count, @v_message, @n_log_count, 'INSERT [dbo].[SY_XIF_RCCP_SCM_SETUP_ITEM_COMBINE 3', @sysdate
      INSERT [LGCE_INFDEV].[dbo].[XIF_LOG_HISTORY](
			  PROC_NAME, 
              TABLE_NAME, 
              LOG_TYPE, 
              LOG_COUNT, 
              LOG_CODE, 
              MESSAGE, 
              DESCR,
			  EVENT_DTTM)
       VALUES (
              @v_proc_name,    -- 1 
              NULL,            -- 2
              'INSERT',        -- 3
              @n_row_count,    -- 4
              @n_log_count,    -- 5
			  @v_message,      -- 6
			  'INSERT [dbo].[SY_XIF_RCCP_SCM_SETUP_ITEM_COMBINE 3',      -- 7
			  SYSDATETIME());

      INSERT INTO [dbo].[SY_XIF_RCCP_SCM_SETUP_ITEM_COMBINE]
      SELECT DISTINCT A.*
      FROM   (
              SELECT DISTINCT
                     A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, B.PLANT_ID,
                     A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, 
                     B.ITEM_ID, B.OPERATION_ID, A.CALCULATION,
                     B.ITEM_ID AS ITEM_SETUP_GROUP_ID         
              FROM   (
                      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, 
                             A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, 
                             A.REFERANCE_OPERATION_ID, A.CALCULATION, B.SORT_ORDER
                      FROM   LGCE_FPDEV_TR.DBO.SCM_ITEM_SETUP_GROUP_M  A WITH(NOLOCK),
                             LGCE_FPDEV_TR.DBO.SCM_SYS_LOOKUP_VALUE    B WITH(NOLOCK)
                      WHERE  B.LOOKUP_TYPE_CODE = 'SETUP_CATEGORY'
                      AND    UPPER(A.SETUP_CATEGORY_ID) = UPPER('ITEM')
                      AND    A.SETUP_CATEGORY_ID = B.SEGMENT1
                      AND    A.OPERATION_ID != A.REFERANCE_OPERATION_ID
                      GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, 
                                A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.LEVEL, 
                                A.REFERANCE_OPERATION_ID, A.CALCULATION, B.SORT_ORDER
                     ) A,
                     LGCE_FPDEV_TR.DBO.SCM_ITEM_FLOW_V B WITH(NOLOCK)
              WHERE  A.COMPANY_ID = B.COMPANY_ID
              AND    A.DIVISION_ID = B.DIVISION_ID
              AND    A.SITE_ID = B.SITE_ID
              AND    A.OPERATION_ID = B.OPERATION_ID
             ) A
      WHERE  1=1


      SET @n_row_count = @@ROWCOUNT

      --LOG 생성
      SET @v_message = 'SETUP_CATEGORY_ID : ITEM      - INSERT COUNT : ' + CONVERT(nvarchar, @n_row_count)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      --EXEC PR_XIF_LOG @v_proc_name, NULL, 'INSERT', @n_row_count, @v_message, @n_log_count, 'INSERT [dbo].[SY_XIF_RCCP_SCM_SETUP_ITEM_COMBINE 4', @sysdate
      INSERT [LGCE_INFDEV].[dbo].[XIF_LOG_HISTORY](
			  PROC_NAME, 
              TABLE_NAME, 
              LOG_TYPE, 
              LOG_COUNT, 
              LOG_CODE, 
              MESSAGE, 
              DESCR,
			  EVENT_DTTM)
       VALUES (
              @v_proc_name,    -- 1 
              NULL,            -- 2
              'INSERT',        -- 3
              @n_row_count,    -- 4
              @n_log_count,    -- 5
              @v_message,      -- 6
              'INSERT [dbo].[SY_XIF_RCCP_SCM_SETUP_ITEM_COMBINE 4',      -- 7
			  SYSDATETIME());

    END

    /* 위 COMBIME 테이블 정보를 기준으로 LEVEL 순서대로 SETUP 정보를 GROUPING 한다. */
    BEGIN


      SET @v_table_name = '[dbo].[SY_XIF_RCCP_SCM_SETUP_ITEM'
      SET @n_row_count = 0
      
      DELETE FROM [dbo].[SY_XIF_RCCP_SCM_SETUP_ITEM];

      INSERT INTO [dbo].[SY_XIF_RCCP_SCM_SETUP_ITEM]
      SELECT DISTINCT
             A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
             (  CASE WHEN MAX_LEVEL >=  1 THEN SG_01 ELSE '' END + CASE WHEN MAX_LEVEL >  1 THEN '##' ELSE '' END
              + CASE WHEN MAX_LEVEL >=  2 THEN SG_02 ELSE '' END + CASE WHEN MAX_LEVEL >  2 THEN '##' ELSE '' END
              + CASE WHEN MAX_LEVEL >=  3 THEN SG_03 ELSE '' END + CASE WHEN MAX_LEVEL >  3 THEN '##' ELSE '' END
              + CASE WHEN MAX_LEVEL >=  4 THEN SG_04 ELSE '' END + CASE WHEN MAX_LEVEL >  4 THEN '##' ELSE '' END
              + CASE WHEN MAX_LEVEL >=  5 THEN SG_05 ELSE '' END + CASE WHEN MAX_LEVEL >  5 THEN '##' ELSE '' END
              + CASE WHEN MAX_LEVEL >=  6 THEN SG_06 ELSE '' END + CASE WHEN MAX_LEVEL >  6 THEN '##' ELSE '' END
              + CASE WHEN MAX_LEVEL >=  7 THEN SG_07 ELSE '' END + CASE WHEN MAX_LEVEL >  7 THEN '##' ELSE '' END
              + CASE WHEN MAX_LEVEL >=  8 THEN SG_08 ELSE '' END + CASE WHEN MAX_LEVEL >  8 THEN '##' ELSE '' END
              + CASE WHEN MAX_LEVEL >=  9 THEN SG_09 ELSE '' END + CASE WHEN MAX_LEVEL >  9 THEN '##' ELSE '' END
              + CASE WHEN MAX_LEVEL >= 10 THEN SG_10 ELSE '' END + CASE WHEN MAX_LEVEL > 10 THEN '##' ELSE '' END
             ) AS SETUP_GROUP_ID,
             SG_01, SG_02, SG_03, SG_04, SG_05, SG_06, SG_07, SG_08, SG_09, SG_10
      FROM   (
              select A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, A.OPERATION_ID, A.LINE_SETUP_GROUP_ID, A.MAX_LEVEL, 
                     MAX(SG_01) AS SG_01,
                     MAX(SG_02) AS SG_02,
                     MAX(SG_03) AS SG_03,
                     MAX(SG_04) AS SG_04,
                     MAX(SG_05) AS SG_05,
                     MAX(SG_06) AS SG_06,
                     MAX(SG_07) AS SG_07,
                     MAX(SG_08) AS SG_08,
                     MAX(SG_09) AS SG_09,
                     MAX(SG_10) AS SG_10
              from   (
                      SELECT A.*, INT,
                             CASE WHEN INT =  1 THEN ITEM_SETUP_GROUP_ID ELSE NULL END SG_01,
                             CASE WHEN INT =  2 THEN ITEM_SETUP_GROUP_ID ELSE NULL END SG_02,
                             CASE WHEN INT =  3 THEN ITEM_SETUP_GROUP_ID ELSE NULL END SG_03,
                             CASE WHEN INT =  4 THEN ITEM_SETUP_GROUP_ID ELSE NULL END SG_04,
                             CASE WHEN INT =  5 THEN ITEM_SETUP_GROUP_ID ELSE NULL END SG_05,
                             CASE WHEN INT =  6 THEN ITEM_SETUP_GROUP_ID ELSE NULL END SG_06,
                             CASE WHEN INT =  7 THEN ITEM_SETUP_GROUP_ID ELSE NULL END SG_07,
                             CASE WHEN INT =  8 THEN ITEM_SETUP_GROUP_ID ELSE NULL END SG_08,
                             CASE WHEN INT =  9 THEN ITEM_SETUP_GROUP_ID ELSE NULL END SG_09,
                             CASE WHEN INT = 10 THEN ITEM_SETUP_GROUP_ID ELSE NULL END SG_10
                      FROM   (
                              SELECT A.*, B.LINE_SETUP_GROUP_ID,
                                     MAX(LEVEL) OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID) MAX_LEVEL
                              FROM   [dbo].[SY_XIF_RCCP_SCM_SETUP_ITEM_COMBINE] A WITH(NOLOCK),
                                     (                                
                                      SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, LINE_SETUP_GROUP_ID, SETUP_CATEGORY_ID, SETUP_KEY_ID, OPERATION_ID 
                                      FROM   LGCE_FPDEV_TR.DBO.SCM_SETUP_MATRIX_M WITH(NOLOCK)
                                      GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, LINE_SETUP_GROUP_ID, SETUP_CATEGORY_ID, SETUP_KEY_ID, OPERATION_ID
                                     ) B
                              WHERE  A.COMPANY_ID = B.COMPANY_ID
                              AND    A.DIVISION_ID = B.DIVISION_ID
                              AND    A.SITE_ID = B.SITE_ID
                              AND    A.PLANT_ID = B.PLANT_ID
                              AND    A.SETUP_CATEGORY_ID = B.SETUP_CATEGORY_ID
                              AND    A.SETUP_KEY_ID = B.SETUP_KEY_ID
                              AND    A.OPERATION_ID = B.OPERATION_ID
                             ) A,
                             COPYT B WITH(NOLOCK)
                      WHERE  A.LEVEL = B.INT       
                     ) a
              GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, A.OPERATION_ID, A.LINE_SETUP_GROUP_ID, A.MAX_LEVEL
             ) A    

      SET @n_row_count += @@ROWCOUNT

      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      -- EXEC PR_XIF_LOG @v_proc_name, NULL, 'INSERT', @n_row_count, @v_message, @n_log_count, 'INSERT [dbo].[SY_XIF_RCCP_SCM_SETUP_ITEM', @sysdate
      INSERT [LGCE_INFDEV].[dbo].[XIF_LOG_HISTORY](
			  PROC_NAME, 
              TABLE_NAME, 
              LOG_TYPE, 
              LOG_COUNT, 
              LOG_CODE, 
              MESSAGE, 
              DESCR,
			  EVENT_DTTM)
       VALUES (
              @v_proc_name,    -- 1 
              NULL,            -- 2
              'INSERT',        -- 3
              @n_row_count,    -- 4
              @n_log_count,    -- 5
              @v_message,      -- 6
              'INSERT [dbo].[SY_XIF_RCCP_SCM_SETUP_ITEM',      -- 7
			  SYSDATETIME());

    END
    
    BEGIN
    
        -- STEP 1.  SETUP_ITEM 을 CROSS JOIN 하여, FROM, TO 가 발생할 수 있는 모든 CASE 를 추출한다.
        --          각 LEVEL 별로 구분하여 10개의 LEVEL 이 있다는 전제조건에서 각각에 대한 SETUP ID 를 다시 추출한다.
        --          해당 SETUP ID 를 기준으로 SETUP 시간을 구하기 위해 FROM, TO 관계를 유지한다.
        --          이때 SETUP 시간에 대한 MAX, SUM 구분을 TO 기준으로 설정한다.
        BEGIN

          SET @v_table_name = ' LGCE_INFDEV.DBO.XIF_RCCP_SCM_SETUP_MATRIX_01'
          SET @n_row_count = 0
          
          DELETE FROM  LGCE_INFDEV.DBO.XIF_RCCP_SCM_SETUP_MATRIX_01;

          INSERT INTO  LGCE_INFDEV.DBO.XIF_RCCP_SCM_SETUP_MATRIX_01
          SELECT DISTINCT
                 A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
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
                         A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
                         A.SETUP_GROUP_ID AS FROM_SETUP_GROUP_ID,
                         B.SETUP_GROUP_ID AS TO_SETUP_GROUP_ID,
                         A.SG_01 AS FROM_SG_01, B.SG_01 AS TO_SG_01,
                         A.SG_02 AS FROM_SG_02, B.SG_02 AS TO_SG_02,
                         A.SG_03 AS FROM_SG_03, B.SG_03 AS TO_SG_03,
                         A.SG_04 AS FROM_SG_04, B.SG_04 AS TO_SG_04,
                         A.SG_05 AS FROM_SG_05, B.SG_05 AS TO_SG_05,
                         A.SG_06 AS FROM_SG_06, B.SG_06 AS TO_SG_06,
                         A.SG_07 AS FROM_SG_07, B.SG_07 AS TO_SG_07,
                         A.SG_08 AS FROM_SG_08, B.SG_08 AS TO_SG_08,
                         A.SG_09 AS FROM_SG_09, B.SG_09 AS TO_SG_09,
                         A.SG_10 AS FROM_SG_10, B.SG_10 AS TO_SG_10               
                  FROM   [dbo].[SY_XIF_RCCP_SCM_SETUP_ITEM] A WITH(NOLOCK),
                         [dbo].[SY_XIF_RCCP_SCM_SETUP_ITEM] B WITH(NOLOCK)
                  WHERE  A.COMPANY_ID = B.COMPANY_ID
                  AND    A.DIVISION_ID = B.DIVISION_ID
                  AND    A.SITE_ID = B.SITE_ID
                  AND    A.PLANT_ID = B.PLANT_ID
                  AND    A.OPERATION_ID = B.OPERATION_ID
                  AND    A.LINE_SETUP_GROUP_ID = B.LINE_SETUP_GROUP_ID
                  AND    A.SETUP_GROUP_ID != B.SETUP_GROUP_ID
                 ) A
                 LEFT OUTER JOIN (
                                  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, 
                                         SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID, CALCULATION
                                  FROM   [dbo].[SY_XIF_RCCP_SCM_SETUP_ITEM_COMBINE] WITH(NOLOCK)
                                  WHERE  LEVEL = 1
                                  GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, 
                                            SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID, CALCULATION
                                 ) TSG_01
                      ON  A.COMPANY_ID    = TSG_01.COMPANY_ID
                      AND A.DIVISION_ID   = TSG_01.DIVISION_ID
                      AND A.SITE_ID       = TSG_01.SITE_ID
                      AND A.PLANT_ID      = TSG_01.PLANT_ID
                      AND A.OPERATION_ID  = TSG_01.OPERATION_ID
                      AND A.TO_SG_01      = TSG_01.ITEM_SETUP_GROUP_ID
                 LEFT OUTER JOIN (
                                  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, 
                                         SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID, CALCULATION
                                  FROM   [dbo].[SY_XIF_RCCP_SCM_SETUP_ITEM_COMBINE] WITH(NOLOCK)
                                  WHERE  LEVEL = 2
                                  GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, 
                                            SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID, CALCULATION
                                 ) TSG_02
                      ON  A.COMPANY_ID    = TSG_02.COMPANY_ID
                      AND A.DIVISION_ID   = TSG_02.DIVISION_ID
                      AND A.SITE_ID       = TSG_02.SITE_ID
                      AND A.PLANT_ID      = TSG_02.PLANT_ID
                      AND A.OPERATION_ID  = TSG_02.OPERATION_ID
                      AND A.TO_SG_02      = TSG_02.ITEM_SETUP_GROUP_ID
                 LEFT OUTER JOIN (
                                  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, 
                                         SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID, CALCULATION
                                  FROM   [dbo].[SY_XIF_RCCP_SCM_SETUP_ITEM_COMBINE] WITH(NOLOCK)
                                  WHERE  LEVEL = 3
                                  GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, 
                                            SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID, CALCULATION
                                 ) TSG_03
                      ON  A.COMPANY_ID    = TSG_03.COMPANY_ID
                      AND A.DIVISION_ID   = TSG_03.DIVISION_ID
                      AND A.SITE_ID       = TSG_03.SITE_ID
                      AND A.PLANT_ID      = TSG_03.PLANT_ID
                      AND A.OPERATION_ID  = TSG_03.OPERATION_ID
                      AND A.TO_SG_03      = TSG_03.ITEM_SETUP_GROUP_ID
                 LEFT OUTER JOIN (
                                  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, 
                                         SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID, CALCULATION
                                  FROM   [dbo].[SY_XIF_RCCP_SCM_SETUP_ITEM_COMBINE] WITH(NOLOCK)
                                  WHERE  LEVEL = 4
                                  GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, 
                                            SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID, CALCULATION
                                 ) TSG_04
                      ON  A.COMPANY_ID    = TSG_04.COMPANY_ID
                      AND A.DIVISION_ID   = TSG_04.DIVISION_ID
                      AND A.SITE_ID       = TSG_04.SITE_ID
                      AND A.PLANT_ID      = TSG_04.PLANT_ID
                      AND A.OPERATION_ID  = TSG_04.OPERATION_ID
                      AND A.TO_SG_04      = TSG_04.ITEM_SETUP_GROUP_ID
                 LEFT OUTER JOIN (
                                  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, 
                                         SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID, CALCULATION
                                  FROM   [dbo].[SY_XIF_RCCP_SCM_SETUP_ITEM_COMBINE] WITH(NOLOCK)
                                  WHERE  LEVEL = 5
                                  GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, 
                                            SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID, CALCULATION
                                 ) TSG_05
                      ON  A.COMPANY_ID    = TSG_05.COMPANY_ID
                      AND A.DIVISION_ID   = TSG_05.DIVISION_ID
                      AND A.SITE_ID       = TSG_05.SITE_ID
                      AND A.PLANT_ID      = TSG_05.PLANT_ID
                      AND A.OPERATION_ID  = TSG_05.OPERATION_ID
                      AND A.TO_SG_05      = TSG_05.ITEM_SETUP_GROUP_ID
                 LEFT OUTER JOIN (
                                  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, 
                                         SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID, CALCULATION
                                  FROM   [dbo].[SY_XIF_RCCP_SCM_SETUP_ITEM_COMBINE] WITH(NOLOCK)
                                  WHERE  LEVEL = 6
                                  GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, 
                                            SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID, CALCULATION
                                 ) TSG_06
                      ON  A.COMPANY_ID    = TSG_06.COMPANY_ID
                      AND A.DIVISION_ID   = TSG_06.DIVISION_ID
                      AND A.SITE_ID       = TSG_06.SITE_ID
                      AND A.PLANT_ID      = TSG_06.PLANT_ID
                      AND A.OPERATION_ID  = TSG_06.OPERATION_ID
                      AND A.TO_SG_06      = TSG_06.ITEM_SETUP_GROUP_ID
                 LEFT OUTER JOIN (
                                  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, 
                                         SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID, CALCULATION
                                  FROM   [dbo].[SY_XIF_RCCP_SCM_SETUP_ITEM_COMBINE] WITH(NOLOCK)
                                  WHERE  LEVEL = 7
                                  GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, 
                                            SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID, CALCULATION
                                 ) TSG_07
                      ON  A.COMPANY_ID    = TSG_07.COMPANY_ID
                      AND A.DIVISION_ID   = TSG_07.DIVISION_ID
                      AND A.SITE_ID       = TSG_07.SITE_ID
                      AND A.PLANT_ID      = TSG_07.PLANT_ID
                      AND A.OPERATION_ID  = TSG_07.OPERATION_ID
                      AND A.TO_SG_07      = TSG_07.ITEM_SETUP_GROUP_ID
                 LEFT OUTER JOIN (
                                  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, 
                                         SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID, CALCULATION
                                  FROM   [dbo].[SY_XIF_RCCP_SCM_SETUP_ITEM_COMBINE] WITH(NOLOCK)
                                  WHERE  LEVEL = 8
                                  GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, 
                                            SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID, CALCULATION
                                 ) TSG_08
                      ON  A.COMPANY_ID    = TSG_08.COMPANY_ID
                      AND A.DIVISION_ID   = TSG_08.DIVISION_ID
                      AND A.SITE_ID       = TSG_08.SITE_ID
                      AND A.PLANT_ID      = TSG_08.PLANT_ID
                      AND A.OPERATION_ID  = TSG_08.OPERATION_ID
                      AND A.TO_SG_08      = TSG_08.ITEM_SETUP_GROUP_ID
                 LEFT OUTER JOIN (
                                  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, 
                                         SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID, CALCULATION
                                  FROM   [dbo].[SY_XIF_RCCP_SCM_SETUP_ITEM_COMBINE] WITH(NOLOCK)
                                  WHERE  LEVEL = 9
                                  GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, 
                                            SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID, CALCULATION
                                 ) TSG_09
                      ON  A.COMPANY_ID    = TSG_09.COMPANY_ID
                      AND A.DIVISION_ID   = TSG_09.DIVISION_ID
                      AND A.SITE_ID       = TSG_09.SITE_ID
                      AND A.PLANT_ID      = TSG_09.PLANT_ID
                      AND A.OPERATION_ID  = TSG_09.OPERATION_ID
                      AND A.TO_SG_09      = TSG_09.ITEM_SETUP_GROUP_ID
                 LEFT OUTER JOIN (
                                  SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, 
                                         SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID, CALCULATION
                                  FROM   [dbo].[SY_XIF_RCCP_SCM_SETUP_ITEM_COMBINE] WITH(NOLOCK)
                                  WHERE  LEVEL = 10
                                  GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, 
                                            SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID, CALCULATION
                                 ) TSG_10
                      ON  A.COMPANY_ID    = TSG_10.COMPANY_ID
                      AND A.DIVISION_ID   = TSG_10.DIVISION_ID
                      AND A.SITE_ID       = TSG_10.SITE_ID
                      AND A.PLANT_ID      = TSG_10.PLANT_ID
                      AND A.OPERATION_ID  = TSG_10.OPERATION_ID
                      AND A.TO_SG_10      = TSG_10.ITEM_SETUP_GROUP_ID
        
          SET @n_row_count += @@ROWCOUNT

          --LOG 생성
          SET @v_message = @n_row_count
          SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
		  --EXEC PR_XIF_LOG @v_proc_name, NULL, 'INSERT', @n_row_count, @v_message, @n_log_count, 'INSERT  LGCE_INF.DBO.XIF_RCCP_SCM_SETUP_MATRIX_01', @sysdate
		  INSERT [LGCE_INFDEV].[dbo].[XIF_LOG_HISTORY](
				  PROC_NAME, 
				  TABLE_NAME, 
				  LOG_TYPE, 
				  LOG_COUNT, 
				  LOG_CODE, 
				  MESSAGE, 
				  DESCR,
				  EVENT_DTTM)
		   VALUES (
				  @v_proc_name,    -- 1 
				  NULL,            -- 2
				  'INSERT',        -- 3
				  @n_row_count,    -- 4
				  @n_log_count,    -- 5
				  @v_message,      -- 6
				  'INSERT  LGCE_INF.DBO.XIF_RCCP_SCM_SETUP_MATRIX_01',      -- 7
				  SYSDATETIME());

        
        END

        -- STEP 2. 위에서 LEVEL 별로 FROM , TO 에 대한 실질적인 SETUP TIME 을 가지고 온다.
        --         단위는 분단위로 통일한다.
        BEGIN

          SET @v_table_name = ' LGCE_INF.DBO.XIF_RCCP_SCM_SETUP_MATRIX_02'
          SET @n_row_count = 0
          
          DELETE FROM  LGCE_INFDEV.DBO.XIF_RCCP_SCM_SETUP_MATRIX_02

          INSERT INTO  LGCE_INFDEV.DBO.XIF_RCCP_SCM_SETUP_MATRIX_02
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
                  FROM    LGCE_INFDEV.DBO.XIF_RCCP_SCM_SETUP_MATRIX_01 A WITH(NOLOCK)
                         LEFT OUTER JOIN LGCE_FPDEV_TR.DBO.SCM_SETUP_MATRIX_M S01 WITH(NOLOCK)
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
                         LEFT OUTER JOIN LGCE_FPDEV_TR.DBO.SCM_SETUP_MATRIX_M S02 WITH(NOLOCK)
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
                         LEFT OUTER JOIN LGCE_FPDEV_TR.DBO.SCM_SETUP_MATRIX_M S03 WITH(NOLOCK)
                              ON  A.FROM_SG_03    = CASE WHEN S03.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_03 ELSE S03.FROM_ITEM_SETUP_GROUP_ID END 
                              AND A.TO_SG_03      = CASE WHEN S03.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_03   ELSE S03.TO_ITEM_SETUP_GROUP_ID   END 
                              AND A.COMPANY_ID    = S03.COMPANY_ID
                              AND A.DIVISION_ID   = S03.DIVISION_ID
                              AND A.SITE_ID       = S03.SITE_ID
                              AND A.PLANT_ID      = S03.PLANT_ID
                              AND A.OPERATION_ID  = S03.OPERATION_ID
                              AND A.LINE_SETUP_GROUP_ID   = S03.LINE_SETUP_GROUP_ID
                         LEFT OUTER JOIN LGCE_FPDEV_TR.DBO.SCM_SETUP_MATRIX_M S04 WITH(NOLOCK)
                              ON  A.FROM_SG_04    = CASE WHEN S04.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_04 ELSE S04.FROM_ITEM_SETUP_GROUP_ID END 
                              AND A.TO_SG_04      = CASE WHEN S04.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_04   ELSE S04.TO_ITEM_SETUP_GROUP_ID   END 
                              AND A.COMPANY_ID    = S04.COMPANY_ID
                              AND A.DIVISION_ID   = S04.DIVISION_ID
                              AND A.SITE_ID       = S04.SITE_ID
                              AND A.PLANT_ID      = S04.PLANT_ID
                              AND A.OPERATION_ID  = S04.OPERATION_ID
                              AND A.LINE_SETUP_GROUP_ID   = S04.LINE_SETUP_GROUP_ID
                         LEFT OUTER JOIN LGCE_FPDEV_TR.DBO.SCM_SETUP_MATRIX_M S05 WITH(NOLOCK)
                              ON  A.FROM_SG_05    = CASE WHEN S05.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_05 ELSE S05.FROM_ITEM_SETUP_GROUP_ID END 
                              AND A.TO_SG_05      = CASE WHEN S05.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_05   ELSE S05.TO_ITEM_SETUP_GROUP_ID   END 
                              AND A.COMPANY_ID    = S05.COMPANY_ID
                              AND A.DIVISION_ID   = S05.DIVISION_ID
                              AND A.SITE_ID       = S05.SITE_ID
                              AND A.PLANT_ID      = S05.PLANT_ID
                              AND A.OPERATION_ID  = S05.OPERATION_ID
                              AND A.LINE_SETUP_GROUP_ID   = S05.LINE_SETUP_GROUP_ID
                         LEFT OUTER JOIN LGCE_FPDEV_TR.DBO.SCM_SETUP_MATRIX_M S06 WITH(NOLOCK)
                              ON  A.FROM_SG_06    = CASE WHEN S06.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_06 ELSE S06.FROM_ITEM_SETUP_GROUP_ID END 
                              AND A.TO_SG_06      = CASE WHEN S06.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_06   ELSE S06.TO_ITEM_SETUP_GROUP_ID   END 
                              AND A.COMPANY_ID    = S06.COMPANY_ID
                              AND A.DIVISION_ID   = S06.DIVISION_ID
                              AND A.SITE_ID       = S06.SITE_ID
                              AND A.PLANT_ID      = S06.PLANT_ID
                              AND A.OPERATION_ID  = S06.OPERATION_ID
                              AND A.LINE_SETUP_GROUP_ID   = S06.LINE_SETUP_GROUP_ID
                         LEFT OUTER JOIN LGCE_FPDEV_TR.DBO.SCM_SETUP_MATRIX_M S07 WITH(NOLOCK)
                              ON  A.FROM_SG_07    = CASE WHEN S07.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_07 ELSE S07.FROM_ITEM_SETUP_GROUP_ID END 
                              AND A.TO_SG_07      = CASE WHEN S07.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_07   ELSE S07.TO_ITEM_SETUP_GROUP_ID   END 
                              AND A.COMPANY_ID    = S07.COMPANY_ID
                              AND A.DIVISION_ID   = S07.DIVISION_ID
                              AND A.SITE_ID       = S07.SITE_ID
                              AND A.PLANT_ID      = S07.PLANT_ID
                              AND A.OPERATION_ID  = S07.OPERATION_ID
                              AND A.LINE_SETUP_GROUP_ID   = S07.LINE_SETUP_GROUP_ID
                         LEFT OUTER JOIN LGCE_FPDEV_TR.DBO.SCM_SETUP_MATRIX_M S08 WITH(NOLOCK)
                              ON  A.FROM_SG_08    = CASE WHEN S08.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_08 ELSE S08.FROM_ITEM_SETUP_GROUP_ID END 
                              AND A.TO_SG_08      = CASE WHEN S08.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_08   ELSE S08.TO_ITEM_SETUP_GROUP_ID   END 
                              AND A.COMPANY_ID    = S08.COMPANY_ID
                              AND A.DIVISION_ID   = S08.DIVISION_ID
                              AND A.SITE_ID       = S08.SITE_ID
                              AND A.PLANT_ID      = S08.PLANT_ID
                              AND A.OPERATION_ID  = S08.OPERATION_ID
                              AND A.LINE_SETUP_GROUP_ID   = S08.LINE_SETUP_GROUP_ID
                         LEFT OUTER JOIN LGCE_FPDEV_TR.DBO.SCM_SETUP_MATRIX_M S09 WITH(NOLOCK)
                              ON  A.FROM_SG_09    = CASE WHEN S09.FROM_ITEM_SETUP_GROUP_ID = 'ALL' THEN A.FROM_SG_09 ELSE S09.FROM_ITEM_SETUP_GROUP_ID END 
                              AND A.TO_SG_09      = CASE WHEN S09.TO_ITEM_SETUP_GROUP_ID   = 'ALL' THEN A.TO_SG_09   ELSE S09.TO_ITEM_SETUP_GROUP_ID   END 
                              AND A.COMPANY_ID    = S09.COMPANY_ID
                              AND A.DIVISION_ID   = S09.DIVISION_ID
                              AND A.SITE_ID       = S09.SITE_ID
                              AND A.PLANT_ID      = S09.PLANT_ID
                              AND A.OPERATION_ID  = S09.OPERATION_ID
                              AND A.LINE_SETUP_GROUP_ID   = S09.LINE_SETUP_GROUP_ID
                         LEFT OUTER JOIN LGCE_FPDEV_TR.DBO.SCM_SETUP_MATRIX_M S10 WITH(NOLOCK)
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
		  -- EXEC PR_XIF_LOG @v_proc_name, NULL, 'INSERT', @n_row_count, @v_message, @n_log_count, 'INSERT [dbo].[SY_XIF_RCCP_SCM_SETUP_MATRIX_02', @sysdate
		  INSERT [LGCE_INFDEV].[dbo].[XIF_LOG_HISTORY](
				  PROC_NAME, 
				  TABLE_NAME, 
				  LOG_TYPE, 
				  LOG_COUNT, 
				  LOG_CODE, 
				  MESSAGE, 
				  DESCR,
				  EVENT_DTTM)
		   VALUES (
				  @v_proc_name,    -- 1 
				  NULL,            -- 2
				  'INSERT',        -- 3
				  @n_row_count,    -- 4
				  @n_log_count,    -- 5
				  @v_message,      -- 6
				  'INSERT [dbo].[SY_XIF_RCCP_SCM_SETUP_MATRIX_02',      -- 7
				  SYSDATETIME());

        END
        
        -- STEP 3. 동일한 FROM_SETUP_GROUP_ID, TO_SETUP_GROUP_ID 를 기준으로 1차 MAX SETUP 시간을 계산하고,
        --         해당 MAX SETUP 시간과 SUM 대상이 되는 SETUP 시간을 같이 더한다.
        --         = ( MAX (A,B,C) + SUM( D,E,F ) )
        BEGIN

          SET @v_table_name = '[dbo].[SY_XIF_RCCP_SCM_SETUP_MATRIX'
          SET @n_row_count = 0
          
          DELETE FROM  LGCE_INFDEV.DBO.XIF_RCCP_SCM_SETUP_MATRIX;

          INSERT INTO  LGCE_INFDEV.DBO.XIF_RCCP_SCM_SETUP_MATRIX
          SELECT DISTINCT
                 A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
                 A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
                 SUM(SETUP_TIME) AS SETUP_TIME,
                 'MINUTE' AS SETUP_TIME_UOM
          FROM   (
                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
                         A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID,
                         MAX(SETUP_TIME) AS SETUP_TIME
                  FROM   (
                          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
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
                          FROM    LGCE_INFDEV.DBO.XIF_RCCP_SCM_SETUP_MATRIX_02 A WITH(NOLOCK),
                                 (
                                  SELECT INT, 'MAX' AS CALCULATION 
                                  FROM   COPYT WITH(NOLOCK)
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
                  GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
                            A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID
                  UNION  ALL
                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
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
                  FROM   LGCE_INFDEV.DBO.XIF_RCCP_SCM_SETUP_MATRIX_02 A WITH(NOLOCK),
                         (
                          SELECT INT, 'SUM' AS CALCULATION 
                          FROM   COPYT WITH(NOLOCK)
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
          GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID, A.LINE_SETUP_GROUP_ID,
                    A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID       
        
          SET @n_row_count += @@ROWCOUNT

          --LOG 생성
          SET @v_message = @n_row_count
		  SET @n_log_count = @n_log_count + 1
          SET @sysdate = GETDATE()
		  --EXEC PR_XIF_LOG @v_proc_name, NULL, 'INSERT', @n_row_count, @v_message, @n_log_count, 'INSERT  LGCE_INF.DBO.XIF_RCCP_SCM_SETUP_MATRIX', @sysdate
		  INSERT [LGCE_INFDEV].[dbo].[XIF_LOG_HISTORY](
				  PROC_NAME, 
				  TABLE_NAME, 
				  LOG_TYPE, 
				  LOG_COUNT, 
				  LOG_CODE, 
				  MESSAGE, 
				  DESCR,
				  EVENT_DTTM)
		   VALUES (
				  @v_proc_name,    -- 1 
				  NULL,            -- 2
				  'INSERT',        -- 3
				  @n_row_count,    -- 4
				  @n_log_count,    -- 5
				  @v_message,      -- 6
				  'INSERT  LGCE_INF.DBO.XIF_RCCP_SCM_SETUP_MATRIX',      -- 7
				  SYSDATETIME());
        END
    
    END
    
    -- 위에서 설정되어진 
    -- 1. [dbo].[SY_XIF_RCCP_SCM_SETUP_ITEM   은 TH_MST_ITEM 의 SETUP_GROUP_ID 로 MAPPING 하고
    -- 2. [dbo].[SY_XIF_RCCP_SCM_SETUP_MATRIX 는 TH_MST_SETUP_CATEGORY, TH_MST_SETUP_TIME 을 설정한다...
    --                               LINE_SETUP_GROUP_ID 는 TH_MST_RESOURCE 의 RESOURCE_SETUP_GROUP_ID 로 설정될 수 있게 한다.
	COMMIT TRANSACTION;
    END TRY

	BEGIN CATCH
		--ROLLBACK
		ROLLBACK TRANSACTION;

		SET @v_descr = ERROR_MESSAGE()

	    EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_descr, NULL, @v_table_name, @sysdate

		commit;
	END CATCH

    BEGIN TRY
	BEGIN TRANSACTION;    
    BEGIN
		DECLARE C_SETUP_TYPE CURSOR FOR
		      SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [LGCE_INFDEV].[dbo].[XIF_RCCP_SEND_SEQ])) + CAST( NEXT VALUE FOR [LGCE_INFDEV].[dbo].[XIF_RCCP_SEND_SEQ] AS NVARCHAR) AS [IF_SEQ],
 					 'S'             AS [IF_TYPE],
					 'OFP0_ORCP_FP_SETUP_TYPE' AS [IF_ID],
					 GETDATE()       AS [IF_INS_DATE],
					 'N'             AS [IF_FLAG],
					 A.[DIVISION_ID] AS [DIVISION_CODE],
					 A.[SITE_ID]     AS [SITE_CODE],
					 A.[ITEM_ID]     AS [ITEM_CODE],
					 MAX(B.[ITEM_NAME])      AS [ITEM_NAME],
					 MAX(A.[SETUP_GROUP_ID]) AS [SETUP_TYPE],
					 @v_proc_name    AS [CREATE_USER_ID],
					 GETDATE()       AS [CREATE_DATE],
					 @v_proc_name    AS [MODIFY_USER_ID],
					 GETDATE()       AS [MODIFY_DATE]
			  FROM    LGCE_INFDEV.DBO.XIF_RCCP_SCM_SETUP_ITEM  A WITH(NOLOCK)
			        ,LGCE_FPDEV_TR.DBO.SCM_ITEM_M             B WITH(NOLOCK)
			        ,LGCE_FPDEV_TR.DBO.SCM_SYS_LOOKUP_VALUE   C WITH(NOLOCK)
			  WHERE  A.COMPANY_ID   = B.COMPANY_ID
			  AND    A.DIVISION_ID  = B.DIVISION_ID
			  AND    A.SITE_ID      = B.SITE_ID
			  AND    A.ITEM_ID      = B.ITEM_ID
			  AND    C.LOOKUP_TYPE_CODE = 'RCCP_CALENDAR_OPERATION'
			  AND    A.OPERATION_ID = C.SEGMENT1
			  AND    C.ACTIVE_FLAG  = 'Y'
			  GROUP  BY A.[DIVISION_ID]
					   ,A.[SITE_ID] 
					   ,A.[ITEM_ID];



  	  SET @IF_SEQ = REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),GETDATE(),121),'-',''),':',''),' ','') 

      SET @v_table_name = '[dbo].[SY_XIF_RCCP_SETUP_TYPE_S]'
      SET @n_row_count = 0

	  OPEN C_SETUP_TYPE
	  FETCH NEXT FROM C_SETUP_TYPE INTO  @IF_SEQ,
 										 @IF_TYPE,
										 @IF_ID,
										 @IF_INS_DATE,
										 @IF_FLAG,
										 @DIVISION_CODE,
										 @SITE_CODE,
										 @ITEM_CODE,
										 @ITEM_NAME,
										 @SETUP_TYPE,
										 @CREATE_USER_ID,
										 @CREATE_DATE,
										 @MODIFY_USER_ID,
										 @MODIFY_DATE;


	  WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
	  BEGIN      
				MERGE INTO [dbo].[SY_XIF_RCCP_SETUP_TYPE_S] RST
				USING ( SELECT  @IF_SEQ         AS IF_SEQ,
 								@IF_TYPE        AS IF_TYPE,
								@IF_ID          AS IF_ID,
								@IF_INS_DATE    AS IF_INS_DATE,
								@IF_FLAG        AS IF_FLAG,
								@DIVISION_CODE  AS DIVISION_CODE,
								@SITE_CODE      AS SITE_CODE,
								@ITEM_CODE      AS ITEM_CODE,
								@ITEM_NAME      AS ITEM_NAME,
								@SETUP_TYPE     AS SETUP_TYPE,
								@CREATE_USER_ID AS CREATE_USER_ID,
								@CREATE_DATE    AS CREATE_DATE,
								@MODIFY_USER_ID AS MODIFY_USER_ID,
								@MODIFY_DATE    AS MODIFY_DATE ) XXX
				ON    (     RST.[DIVISION_CODE]  = XXX.DIVISION_CODE
						AND RST.[SITE_CODE]      = XXX.SITE_CODE
						AND RST.[ITEM_CODE]      = XXX.ITEM_CODE )
				WHEN MATCHED THEN
					UPDATE SET [IF_SEQ]          = XXX.[IF_SEQ],
							   [IF_INS_DATE]     = XXX.[IF_INS_DATE],
							   [IF_FLAG]         = XXX.[IF_FLAG],
							   [IF_SND_DATE]     = NULL,
							   [ITEM_NAME]       = XXX.[ITEM_NAME],
							   [SETUP_TYPE]      = XXX.[SETUP_TYPE],
							   [MODIFY_USER_ID]  = XXX.[MODIFY_USER_ID],
							   [MODIFY_DATE]     = XXX.[MODIFY_DATE]
				WHEN NOT MATCHED THEN
					INSERT ( [IF_SEQ]
							,[IF_TYPE]
							,[IF_ID]
							,[IF_INS_DATE]
							,[IF_FLAG]
							,[DIVISION_CODE]
							,[SITE_CODE]
							,[ITEM_CODE]
							,[ITEM_NAME]
							,[SETUP_TYPE]
							,[CREATE_USER_ID]
							,[CREATE_DATE]
							,[MODIFY_USER_ID]
							,[MODIFY_DATE]
							)
					VALUES ( XXX.[IF_SEQ]
							,XXX.[IF_TYPE]
							,XXX.[IF_ID]
							,XXX.[IF_INS_DATE]
							,XXX.[IF_FLAG]
							,XXX.[DIVISION_CODE]
							,XXX.[SITE_CODE]
							,XXX.[ITEM_CODE]
							,XXX.[ITEM_NAME]
							,XXX.[SETUP_TYPE]
							,XXX.[CREATE_USER_ID]
							,XXX.[CREATE_DATE]
							,XXX.[MODIFY_USER_ID]
							,XXX.[MODIFY_DATE]
							);

				SET @n_row_count += 1;
			  FETCH NEXT FROM C_SETUP_TYPE INTO  @IF_SEQ,
 												 @IF_TYPE,
												 @IF_ID,
												 @IF_INS_DATE,
												 @IF_FLAG,
												 @DIVISION_CODE,
												 @SITE_CODE,
												 @ITEM_CODE,
												 @ITEM_NAME,
												 @SETUP_TYPE,
												 @CREATE_USER_ID,
												 @CREATE_DATE,
												 @MODIFY_USER_ID,
												 @MODIFY_DATE;

		END; -- C_SETUP_TYPE
		CLOSE C_SETUP_TYPE;
		DEALLOCATE C_SETUP_TYPE;   -- 메모리 해제

      --LOG 생성
      SET @v_message = @n_row_count
	  SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
	  --EXEC PR_XIF_LOG @v_proc_name, NULL, 'INSERT', @n_row_count, @v_message, @n_log_count, 'INSERT [dbo].[SY_XIF_RCCP_SETUP_TYPE_S', @sysdate
	  INSERT [LGCE_INFDEV].[dbo].[XIF_LOG_HISTORY](
			PROC_NAME, 
			TABLE_NAME, 
			LOG_TYPE, 
			LOG_COUNT, 
			LOG_CODE, 
			MESSAGE, 
			DESCR,
			EVENT_DTTM)
	  VALUES (
			@v_proc_name,    -- 1 
			NULL,            -- 2
			'INSERT',        -- 3
			@n_row_count,    -- 4
			@n_log_count,    -- 5
			@v_message,      -- 6
			'INSERT [dbo].[SY_XIF_RCCP_SETUP_TYPE_S',      -- 7
			SYSDATETIME());

    END
	COMMIT TRANSACTION;
	END TRY

	BEGIN CATCH
		--ROLLBACK
		ROLLBACK TRANSACTION;

		SET @v_descr = ERROR_MESSAGE()

	    EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_descr, NULL, @v_table_name, @sysdate

		commit;
	END CATCH

    BEGIN TRY
	BEGIN TRANSACTION;
    BEGIN
		DECLARE C_SETUP_TIME CURSOR FOR
			  SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [LGCE_INFDEV].[dbo].[XIF_RCCP_SEND_SEQ])) + CAST( NEXT VALUE FOR [LGCE_INFDEV].[dbo].[XIF_RCCP_SEND_SEQ] AS NVARCHAR) AS [IF_SEQ],
 					 'S'                   AS [IF_TYPE],
					 'OFP0_ORCP_FP_SETUP_TIME' AS [IF_ID],
					 GETDATE()             AS [IF_INS_DATE],
					 'N'                   AS [IF_FLAG],
                     A.DIVISION_ID         AS [DIVISION_CODE],
	                 A.SITE_ID             AS [SITE_CODE],
                     A.FROM_SETUP_GROUP_ID AS [FROM_SETUP_TYPE],
                     A.TO_SETUP_GROUP_ID   AS [TO_SETUP_TYPE],
	                 MAX(A.SETUP_TIME)/60.0  AS [SETUP_TIME],
					 @v_proc_name          AS [CREATE_USER_ID],
					 GETDATE()             AS [CREATE_DATE],
					 @v_proc_name          AS [MODIFY_USER_ID],
					 GETDATE()             AS [MODIFY_DATE]
			  FROM   (SELECT  A.DIVISION_ID
							, A.SITE_ID
							, A.LINE_SETUP_GROUP_ID
							, A.FROM_SETUP_GROUP_ID
							, A.TO_SETUP_GROUP_ID
							, A.SETUP_TIME
					  FROM     LGCE_INFDEV.DBO.XIF_RCCP_SCM_SETUP_MATRIX A WITH(NOLOCK)
 		  			        , LGCE_FPDEV_TR.DBO.SCM_SYS_LOOKUP_VALUE   C WITH(NOLOCK)
					  WHERE   C.LOOKUP_TYPE_CODE = 'RCCP_CALENDAR_OPERATION'
			          AND     A.OPERATION_ID = C.SEGMENT1
			          AND     C.ACTIVE_FLAG  = 'Y'
					  AND     A.SETUP_TIME   > 0
					  UNION   ALL
					  SELECT  A.DIVISION_ID
							, A.SITE_ID
							, A.LINE_SETUP_GROUP_ID
							, A.FROM_ITEM_SETUP_GROUP_ID  AS FROM_SETUP_GROUP_ID
							, A.TO_ITEM_SETUP_GROUP_ID    AS TO_SETUP_GROUP_ID
							, A.SETUP_TIME
					  FROM    LGCE_FPDEV_TR.DBO.SCM_SETUP_MATRIX_M A WITH(NOLOCK)
					        , LGCE_FPDEV_TR.DBO.SCM_SYS_LOOKUP_VALUE   C WITH(NOLOCK)
					  WHERE   C.LOOKUP_TYPE_CODE = 'RCCP_CALENDAR_OPERATION'
			          AND     A.OPERATION_ID = C.SEGMENT1
			          AND     C.ACTIVE_FLAG  = 'Y'
					  AND     A.SETUP_TIME   > 0
					  AND     A.FROM_ITEM_SETUP_GROUP_ID  = 'ALL'
					  AND     A.TO_ITEM_SETUP_GROUP_ID    = 'ALL'
					 ) A
			  GROUP  BY A.DIVISION_ID, A.SITE_ID, A.FROM_SETUP_GROUP_ID, A.TO_SETUP_GROUP_ID;

  	  SET @IF_SEQ = REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),GETDATE(),121),'-',''),':',''),' ','') 
      SET @v_table_name = 'XIF_RCCP_SETUP_TIME_S'
      SET @n_row_count = 0

	  OPEN C_SETUP_TIME
	  FETCH NEXT FROM C_SETUP_TIME INTO @IF_SEQ,
 										@IF_TYPE,
										@IF_ID,
										@IF_INS_DATE,
										@IF_FLAG,
										@DIVISION_CODE,
										@SITE_CODE,
										@FROM_SETUP_TYPE,
										@TO_SETUP_TYPE,
										@SETUP_TIME,
										@CREATE_USER_ID,
										@CREATE_DATE,
										@MODIFY_USER_ID,
										@MODIFY_DATE;

	  WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
	  BEGIN 
      
			  MERGE INTO [dbo].[SY_XIF_RCCP_SETUP_TIME_S] RST
			  USING ( SELECT  @IF_SEQ             AS IF_SEQ,
 							  @IF_TYPE            AS IF_TYPE,
							  @IF_ID              AS IF_ID,
							  @IF_INS_DATE        AS IF_INS_DATE,
							  @IF_FLAG            AS IF_FLAG,
							  @DIVISION_CODE      AS DIVISION_CODE,
							  @SITE_CODE          AS SITE_CODE,
							  @FROM_SETUP_TYPE    AS FROM_SETUP_TYPE,
							  @TO_SETUP_TYPE      AS TO_SETUP_TYPE,
							  @SETUP_TIME         AS SETUP_TIME,
							  @CREATE_USER_ID     AS CREATE_USER_ID,
							  @CREATE_DATE        AS CREATE_DATE,
							  @MODIFY_USER_ID     AS MODIFY_USER_ID,
							  @MODIFY_DATE        AS MODIFY_DATE ) XXX
				ON    (     RST.[DIVISION_CODE]   = XXX.[DIVISION_CODE]
						AND RST.[SITE_CODE]       = XXX.[SITE_CODE]
						AND RST.[FROM_SETUP_TYPE] = XXX.[FROM_SETUP_TYPE]
						AND RST.[TO_SETUP_TYPE]   = XXX.[TO_SETUP_TYPE] )
				WHEN MATCHED THEN
					UPDATE SET [IF_SEQ]          = XXX.[IF_SEQ],
							   [IF_INS_DATE]     = XXX.[IF_INS_DATE],
							   [IF_FLAG]         = XXX.[IF_FLAG],
							   [IF_SND_DATE]     = NULL,
							   [SETUP_TIME]      = XXX.[SETUP_TIME],
							   [MODIFY_USER_ID]  = XXX.[MODIFY_USER_ID],
							   [MODIFY_DATE]     = XXX.[MODIFY_DATE]
				WHEN NOT MATCHED THEN
					INSERT ( [IF_SEQ]
							,[IF_TYPE]
							,[IF_ID]
							,[IF_INS_DATE]
							,[IF_FLAG]
							,[DIVISION_CODE]
							,[SITE_CODE]
							,[FROM_SETUP_TYPE]
							,[TO_SETUP_TYPE]
							,[SETUP_TIME]
							,[CREATE_USER_ID]
							,[CREATE_DATE]
							,[MODIFY_USER_ID]
							,[MODIFY_DATE]
							)
					VALUES ( XXX.[IF_SEQ]
							,XXX.[IF_TYPE]
							,XXX.[IF_ID]
							,XXX.[IF_INS_DATE]
							,XXX.[IF_FLAG]
							,XXX.[DIVISION_CODE]
							,XXX.[SITE_CODE]
							,XXX.[FROM_SETUP_TYPE]
							,XXX.[TO_SETUP_TYPE]
							,XXX.[SETUP_TIME]
							,XXX.[CREATE_USER_ID]
							,XXX.[CREATE_DATE]
							,XXX.[MODIFY_USER_ID]
							,XXX.[MODIFY_DATE]
							);
			  SET @n_row_count += 1;
			  FETCH NEXT FROM C_SETUP_TIME INTO @IF_SEQ,
 												@IF_TYPE,
												@IF_ID,
												@IF_INS_DATE,
												@IF_FLAG,
												@DIVISION_CODE,
												@SITE_CODE,
												@FROM_SETUP_TYPE,
												@TO_SETUP_TYPE,
												@SETUP_TIME,
												@CREATE_USER_ID,
												@CREATE_DATE,
												@MODIFY_USER_ID,
												@MODIFY_DATE;

		END; -- C_SETUP_TIME
		CLOSE C_SETUP_TIME;
		DEALLOCATE C_SETUP_TIME;   -- 메모리 해제

            
      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
	  --EXEC PR_XIF_LOG @v_proc_name, NULL, 'INSERT', @n_row_count, @v_message, @n_log_count, 'INSERT [dbo].[SY_XIF_RCCP_SETUP_TIME_S', @sysdate
	  INSERT [LGCE_INFDEV].[dbo].[XIF_LOG_HISTORY](
			PROC_NAME, 
			TABLE_NAME, 
			LOG_TYPE, 
			LOG_COUNT, 
			LOG_CODE, 
			MESSAGE, 
			DESCR,
			EVENT_DTTM)
	  VALUES (
			@v_proc_name,    -- 1 
			NULL,            -- 2
			'INSERT',        -- 3
			@n_row_count,    -- 4
			@n_log_count,    -- 5
			@v_message,      -- 6
			'INSERT [dbo].[SY_XIF_RCCP_SETUP_TIME_S',      -- 7
			SYSDATETIME());

    END
	COMMIT TRANSACTION;
    END TRY

	BEGIN CATCH
		--ROLLBACK
		ROLLBACK TRANSACTION;

		SET @v_descr = ERROR_MESSAGE()

	    EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_descr, NULL, @v_table_name, @sysdate

		commit;
	END CATCH


  SET @n_log_count = @n_log_count + 1
  EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @n_row_count, @v_message, 999999, '############### End of procedure ###############', @sysdate

END
