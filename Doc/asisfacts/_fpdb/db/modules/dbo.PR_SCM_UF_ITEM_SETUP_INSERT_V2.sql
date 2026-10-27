CREATE PROCEDURE [dbo].[PR_SCM_UF_ITEM_SETUP_INSERT_V2]
   @p_instance       nvarchar(max) = '-',
   @p_operation     nvarchar(max) = '-',
   @p_level         nvarchar(max) = '-',
   @p_category      nvarchar(max) = '-',
   @p_key           nvarchar(max) = '-',
   @p_ref_operation nvarchar(max) = '-',
   @p_calculation   nvarchar(max) = '-',
   @p_usert_id      nvarchar(max) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_UF_ITEM_SETUP_INSERT_V2                                               **/
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
/** 2016.08.22    LJH          최초 작성                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_SCM_UF_ITEM_SETUP_INSERT
*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_company        nvarchar(30)
  DECLARE @v_division       nvarchar(30)
  DECLARE @v_corporation    nvarchar(30)
  DECLARE @v_plant          nvarchar(30)
  DECLARE @v_master_id      nvarchar(30)
  DECLARE @v_plan_id        nvarchar(30)
  DECLARE @plan_start_time  datetime
  DECLARE @plan_end_time    datetime

  DECLARE  @instance       nvarchar(max) = @p_instance,
           @operation     nvarchar(max) = @p_operation,
           @level         nvarchar(max) = @p_level,
           @category      nvarchar(max) = @p_category,
           @key           nvarchar(max) = @p_key,
           @ref_operation nvarchar(max) = @p_ref_operation,
           @calculation   nvarchar(max) = @p_calculation,
           @usert_id      nvarchar(max) = @p_usert_id
  

  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_UF_ITEM_SETUP_INSERT'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code       nvarchar(10)
  
  DECLARE @sysdate          DATETIME2 = GETDATE()

  DECLARE @v_temp1          nvarchar(1000)
  DECLARE @v_temp2          nvarchar(1000)
  
  SET @v_master_id  = 'UI_INTERFACE'
  SET @v_plan_id    = 'UI_INTERFACE'
  
  SET @v_temp1 = 'S' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  SET @v_temp2 = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  
  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

  SET @v_table_name = 'INPUT-DATA'
  --LOG 생성
  SET @v_message = '@instance : ' + @instance
  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXECUTE PR_LOG_PROCESS  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

  --LOG 생성
  SET @v_message = '@operation : ' + @operation
  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXECUTE PR_LOG_PROCESS  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

  --LOG 생성
  SET @v_message = '@level : ' + ISNULL(CONVERT(nvarchar, @level), 'NULL')
  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXECUTE PR_LOG_PROCESS  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

  --LOG 생성
  SET @v_message = '@category : ' + @category
  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXECUTE PR_LOG_PROCESS  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

  --LOG 생성
  SET @v_message = '@key : ' + @key
  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXECUTE PR_LOG_PROCESS  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
  
  --LOG 생성
  SET @v_message = '@ref_operation : ' + @ref_operation
  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXECUTE PR_LOG_PROCESS  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
  
  --LOG 생성
  SET @v_message = '@calculation : ' + @calculation
  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXECUTE PR_LOG_PROCESS  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
  
  --LOG 생성
  SET @v_message = '@usert_id : ' + @usert_id
  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXECUTE PR_LOG_PROCESS  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

  BEGIN TRY
    
    BEGIN
    
      SET @v_table_name = 'FP_ITEM_SETUP_GROUP_M'

      SET @level = 0
      
      -- 기존 데이터가 존재하는지 찾아서 level 을 가지고 온다
      select @level = ISNULL(MAX(LEVEL),0)
      from   FP_ITEM_SETUP_GROUP_M
      where  instance_id         = @instance
      and    OPERATION_ID       = @operation
      and    SETUP_CATEGORY_ID  = @category
      and    SETUP_KEY_ID       = @key
      
      -- 기존 데이터가 없으면 동일 operation 의 max 값을 가지고 온다.
      if @level = 0 OR ISNULL(@LEVEL, 0) = 0
        begin      
          SELECT @level = ISNULL(MAX(LEVEL),0) + 1
          FROM   FP_ITEM_SETUP_GROUP_M
          where  instance_id         = @instance
          and    OPERATION_ID       = @operation
          --and    SETUP_CATEGORY_ID  = @category
          --and    SETUP_KEY_ID       = @key
        end
        
      -- 그래도 없으면 level 을 1로 설정한다.
      if @level = 0 OR ISNULL(@LEVEL, 0) = 0
        set @level = 1

      --LOG 생성
      SET @v_message = '@level : ' + CONVERT(nvarchar, @level)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE PR_LOG_PROCESS  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

      IF UPPER(@category) = 'ITEM'
        BEGIN
        
          delete from   FP_ITEM_SETUP_GROUP_M
          where  instance_id         = @instance
          and    OPERATION_ID       = @operation
          and    SETUP_CATEGORY_ID  = @category
          and    SETUP_KEY_ID       = @key

          INSERT INTO FP_ITEM_SETUP_GROUP_M
              (
                INSTANCE_ID
              , OPERATION_ID
              , SETUP_CATEGORY_ID
              , SETUP_KEY_ID
              , LEVEL
              , REFERANCE_OPERATION_ID
              , CALCULATION
              , DESCRIPTION
              , INSERT_ID
              , INSERT_TIME
              , UPDATE_ID
              , UPDATE_TIME
              )
          select  @instance        AS INSTANCE_ID
                , @operation      AS OPERATION_ID
                , @category       AS SETUP_CATEGORY_ID
                , @key            AS SETUP_KEY_ID
                --, '-'             AS ITEM_SETUP_GROUP_ID
                , @level          AS LEVEL
                , @ref_operation  AS REFERANCE_OPERATION_ID
                , @calculation    AS CALCULATION
                , NULL            AS DESCRIPTION
                , @usert_id       AS INSERT_ID
                , GETDATE()       AS INSERT_TIME
                , @v_proc_name    AS UPDATE_ID
                , GETDATE()       AS UPDATE_TIME
        
          SET @n_row_count = @@ROWCOUNT
          
        END
      
      IF UPPER(@category) = 'MATERIAL'
        BEGIN
          delete from   FP_ITEM_SETUP_GROUP_M
          where  INSTANCE_ID        = @instance
          and    OPERATION_ID       = @operation
          and    SETUP_CATEGORY_ID  = @category
          and    SETUP_KEY_ID       = @key


          INSERT INTO FP_ITEM_SETUP_GROUP_M
              (
                INSTANCE_ID
              , OPERATION_ID
              , SETUP_CATEGORY_ID
              , SETUP_KEY_ID
              --, ITEM_SETUP_GROUP_ID
              , LEVEL
              , REFERANCE_OPERATION_ID
              , CALCULATION
              , DESCRIPTION
              , INSERT_ID
              , INSERT_TIME
              , UPDATE_ID
              , UPDATE_TIME
              )
          select  @instance       AS INSTANCE_ID
                , @operation      AS OPERATION_ID
                , @category       AS SETUP_CATEGORY_ID
                , @key            AS SETUP_KEY_ID
                --, B.SEGMENT4      AS ITEM_SETUP_GROUP_ID
                , @level          AS LEVEL
                , @ref_operation  AS REFERANCE_OPERATION_ID
                , @calculation    AS CALCULATION
                , '-'
                , @usert_id       AS INSERT_ID
                , GETDATE()       AS INSERT_TIME
                , @v_proc_name    AS UPDATE_ID
                , GETDATE()       AS UPDATE_TIME
          --from   SCM_SYS_LOOKUP_TYPE_M A,
          --       SCM_SYS_LOOKUP_VALUE B
          --WHERE  A.lookup_type_code = 'ITEM_ATTRIBUTE_COMBINE'
          --AND    A.lookup_type_code = B.lookup_type_code
          --AND    B.SEGMENT1 = @division
          --AND    B.SEGMENT2 = @site
          --AND    B.SEGMENT3 = @key

          SET @n_row_count = @@ROWCOUNT
          
          IF @n_row_count = 0 
            BEGIN

              INSERT INTO FP_ITEM_SETUP_GROUP_M
                  (
                  --  COMPANY_ID
                  --, DIVISION_ID
                  --, SITE_ID
				  INSTANCE_ID
                  , OPERATION_ID
                  , SETUP_CATEGORY_ID
                  , SETUP_KEY_ID
                  --, ITEM_SETUP_GROUP_ID
                  , LEVEL
                  , REFERANCE_OPERATION_ID
                  , CALCULATION
                  , DESCRIPTION
                  , INSERT_ID
                  , INSERT_TIME
                  , UPDATE_ID
                  , UPDATE_TIME
                  )
              select  @instance        AS INSTANCE_ID
                    , @operation      AS OPERATION_ID
                    , @category       AS SETUP_CATEGORY_ID
                    , @key            AS SETUP_KEY_ID
                    --, B.SEGMENT4      AS ITEM_SETUP_GROUP_ID
                    , @level          AS LEVEL
                    , @ref_operation  AS REFERANCE_OPERATION_ID
                    , @calculation    AS CALCULATION
                    , '-'
                    , @usert_id       AS INSERT_ID
                    , GETDATE()       AS INSERT_TIME
                    , @v_proc_name    AS UPDATE_ID
                    , GETDATE()       AS UPDATE_TIME
              --from   SCM_SYS_LOOKUP_TYPE_M A,
              --       SCM_SYS_LOOKUP_VALUE B
              --WHERE  A.lookup_type_code = 'ITEM_ATTRIBUTE'
              --AND    A.lookup_type_code = B.lookup_type_code
              --AND    B.SEGMENT1 = @division
              --AND    B.SEGMENT2 = @site
              --AND    B.SEGMENT3 = @key
            
              SET @n_row_count = @@ROWCOUNT
              
              IF @n_row_count = 0 
                BEGIN

                  INSERT INTO FP_ITEM_SETUP_GROUP_M
                      (
                        INSTANCE_ID
                      --, DIVISION_ID
                      --, SITE_ID
                      , OPERATION_ID
                      , SETUP_CATEGORY_ID
                      , SETUP_KEY_ID
                      --, ITEM_SETUP_GROUP_ID
                      , LEVEL
                      , REFERANCE_OPERATION_ID
                      , CALCULATION
                      , DESCRIPTION
                      , INSERT_ID
                      , INSERT_TIME
                      , UPDATE_ID
                      , UPDATE_TIME
                      )
                  select  @instance        AS INSTANCE_ID
                        --, @division       AS DIVISION_ID
                        --, @site           AS SITE_ID
                        , @operation      AS OPERATION_ID
                        , @category       AS SETUP_CATEGORY_ID
                        , @key            AS SETUP_KEY_ID
                        --, '-'             AS ITEM_SETUP_GROUP_ID
                        , @level          AS LEVEL
                        , @ref_operation  AS REFERANCE_OPERATION_ID
                        , @calculation    AS CALCULATION
                        , NULL            AS DESCRIPTION
                        , @usert_id       AS INSERT_ID
                        , GETDATE()       AS INSERT_TIME
                        , @v_proc_name    AS UPDATE_ID
                        , GETDATE()       AS UPDATE_TIME
                
                  SET @n_row_count = @@ROWCOUNT

                END
          
            END

        END

      IF UPPER(@category) = 'ATTRIBUTE'
        BEGIN
        
          delete from   FP_ITEM_SETUP_GROUP_M
          where  instance_id         = @instance
          and    OPERATION_ID       = @operation
          and    SETUP_CATEGORY_ID  = @category
          and    SETUP_KEY_ID       = @key


          INSERT INTO FP_ITEM_SETUP_GROUP_M
              (
                INSTANCE_ID
              --, DIVISION_ID
              --, SITE_ID
              , OPERATION_ID
              , SETUP_CATEGORY_ID
              , SETUP_KEY_ID
              --, ITEM_SETUP_GROUP_ID
              , LEVEL
              , REFERANCE_OPERATION_ID
              , CALCULATION
              , DESCRIPTION
              , INSERT_ID
              , INSERT_TIME
              , UPDATE_ID
              , UPDATE_TIME
              )
          select  @instance        AS INSTANCE_ID
                , @operation      AS OPERATION_ID
                , @category       AS SETUP_CATEGORY_ID
                , @key            AS SETUP_KEY_ID
                --, B.SEGMENT4      AS ITEM_SETUP_GROUP_ID
                , @level          AS LEVEL
                , @ref_operation  AS REFERANCE_OPERATION_ID
                , @calculation    AS CALCULATION
                , '-'--A.LOOKUP_DESCRIPTION
                , @usert_id       AS INSERT_ID
                , GETDATE()       AS INSERT_TIME
                , @v_proc_name    AS UPDATE_ID
                , GETDATE()       AS UPDATE_TIME
          --from   SCM_SYS_LOOKUP_TYPE_M A,
          --       SCM_SYS_LOOKUP_VALUE B
          --WHERE  A.lookup_type_code = 'SETUP_ATTRIBUTE'
          --AND    A.lookup_type_code = B.lookup_type_code
          --AND    B.SEGMENT1 = @division
          --AND    B.SEGMENT2 = @site
          --AND    B.SEGMENT3 = @operation
        
          SET @n_row_count = @@ROWCOUNT
          
          IF @n_row_count = 0 
            BEGIN

              INSERT INTO FP_ITEM_SETUP_GROUP_M
                  (
                    INSTANCE_ID
                  , OPERATION_ID
                  , SETUP_CATEGORY_ID
                  , SETUP_KEY_ID
                  --, ITEM_SETUP_GROUP_ID
                  , LEVEL
                  , REFERANCE_OPERATION_ID
                  , CALCULATION
                  , DESCRIPTION
                  , INSERT_ID
                  , INSERT_TIME
                  , UPDATE_ID
                  , UPDATE_TIME
                  )
              select  @instance        AS COMPANY_ID
                    --, @division       AS DIVISION_ID
                    --, @site           AS SITE_ID
                    , @operation      AS OPERATION_ID
                    , @category       AS SETUP_CATEGORY_ID
                    , @key            AS SETUP_KEY_ID
                    --, '-'             AS ITEM_SETUP_GROUP_ID
                    , @level          AS LEVEL
                    , @ref_operation  AS REFERANCE_OPERATION_ID
                    , @calculation    AS CALCULATION
                    , NULL            AS DESCRIPTION
                    , @usert_id       AS INSERT_ID
                    , GETDATE()       AS INSERT_TIME
                    , @v_proc_name    AS UPDATE_ID
                    , GETDATE()       AS UPDATE_TIME
            
              SET @n_row_count = @@ROWCOUNT

            END
        
        END
        
      IF UPPER(@category) = 'FORM ATTRIBUTE'
        BEGIN
        
          delete from   FP_ITEM_SETUP_GROUP_M
          where  INSTANCE_ID         = @instance
          and    OPERATION_ID       = @operation
          and    SETUP_CATEGORY_ID  = @category
          and    SETUP_KEY_ID       = @key


          INSERT INTO FP_ITEM_SETUP_GROUP_M
              (
                INSTANCE_ID
              , OPERATION_ID
              , SETUP_CATEGORY_ID
              , SETUP_KEY_ID
              --, ITEM_SETUP_GROUP_ID
              , LEVEL
              , REFERANCE_OPERATION_ID
              , CALCULATION
              , DESCRIPTION
              , INSERT_ID
              , INSERT_TIME
              , UPDATE_ID
              , UPDATE_TIME
              )
          select  @instance        AS INSTANCE_ID
                , @operation      AS OPERATION_ID
                , @category       AS SETUP_CATEGORY_ID
                , @key            AS SETUP_KEY_ID
                --, B.SEGMENT5      AS ITEM_SETUP_GROUP_ID
                , @level          AS LEVEL
                , @ref_operation  AS REFERANCE_OPERATION_ID
                , @calculation    AS CALCULATION
                , '-'--A.LOOKUP_DESCRIPTION
                , @usert_id       AS INSERT_ID
                , GETDATE()       AS INSERT_TIME
                , @v_proc_name    AS UPDATE_ID
                , GETDATE()       AS UPDATE_TIME
          --from   SCM_SYS_LOOKUP_TYPE_M A,
          --       SCM_SYS_LOOKUP_VALUE B
          --WHERE  A.lookup_type_code = 'SETUP_ATTRIBUTE'
          --AND    A.lookup_type_code = B.lookup_type_code
          --AND    B.SEGMENT1 = @division
          --AND    B.SEGMENT2 = @site
          --AND    B.SEGMENT3 = @operation
        
          SET @n_row_count = @@ROWCOUNT
          
          IF @n_row_count = 0 
            BEGIN

              INSERT INTO FP_ITEM_SETUP_GROUP_M
                  (
                    INSTANCE_ID
                  , OPERATION_ID
                  , SETUP_CATEGORY_ID
                  , SETUP_KEY_ID
                  , LEVEL
                  , REFERANCE_OPERATION_ID
                  , CALCULATION
                  , DESCRIPTION
                  , INSERT_ID
                  , INSERT_TIME
                  , UPDATE_ID
                  , UPDATE_TIME
                  )
              select  @instance        AS INSTANCE_ID
                    , @operation      AS OPERATION_ID
                    , @category       AS SETUP_CATEGORY_ID
                    , @key            AS SETUP_KEY_ID
                    --, '-'             AS ITEM_SETUP_GROUP_ID
                    , @level          AS LEVEL
                    , @ref_operation  AS REFERANCE_OPERATION_ID
                    , @calculation    AS CALCULATION
                    , NULL            AS DESCRIPTION
                    , @usert_id       AS INSERT_ID
                    , GETDATE()       AS INSERT_TIME
                    , @v_proc_name    AS UPDATE_ID
                    , GETDATE()       AS UPDATE_TIME
            
              SET @n_row_count = @@ROWCOUNT

            END
        
        END

      --LOG 생성
      SET @v_message = @n_row_count
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE PR_LOG_PROCESS  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
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
