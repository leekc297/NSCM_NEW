
/*
 * Program ID   : PR_SSP_ANL_SHIP_PLAN_40_RUN
 * Description  : 소형사업부 재고 PSI 정보 생성 (HQ)
 * OutTable     : s
 * Execute      : EXEC PR_SSP_ANL_SHIP_PLAN_40_RUN
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2025.10.30   chkim.68       생성 / PR_SSP_ANL_SHIP_PLAN_40 '40', 'HQ00'
								CompanyID를 프로시저에 전달하는 방식, 룩업으로부터 호출하도록 개선
*/
CREATE PROCEDURE [dbo].[PR_SSP_ANL_SHIP_PLAN_40_RUN]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS ON;
	DECLARE @p_division_id   NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @p_company_id   NVARCHAR(30) = '';

    SET @p_division_id = '40'
	select top 1 @p_company_id=SEGMENT2 from  scm_code_lookup_value with(nolock)
    where lookup_type_code = 'PR_SSP_ANL_SHIP_PLAN_40_RUN'
    and [SEGMENT1] = 'HeadQuarter'
    and active_flag = 'Y'

    --print @p_company_id

    --insert into scm_code_lookup_value   ([LOOKUP_TYPE_CODE]      ,[SEGMENT1]      ,[SEGMENT2]      ,[SEGMENT3]      ,[SEGMENT4]      ,[SEGMENT5]
    --      ,[SORT_ORDER]      ,[ACTIVE_FLAG]      ,[VALUE_DESCRIPTION]      ,[CREATE_USER_ID]      ,[CREATE_DATE]      ,[MODIFY_USER_ID]      ,[MODIFY_DATE]
    --      ,[ATTRIBUTE1]      ,[ATTRIBUTE2]      ,[ATTRIBUTE3]      ,[ATTRIBUTE4]      ,[ATTRIBUTE5]
    --      ,[ATTRIBUTE6]      ,[ATTRIBUTE7]      ,[ATTRIBUTE8]      ,[ATTRIBUTE9]      ,[ATTRIBUTE10]
    --      ,[ATTRIBUTE11]      ,[ATTRIBUTE12]      ,[ATTRIBUTE13]      ,[ATTRIBUTE14]      ,[ATTRIBUTE15]
    --      ,[PLANT_ID])
    --      select
    --       'PR_SSP_ANL_SHIP_PLAN_40_RUN' as [LOOKUP_TYPE_CODE]
    --      ,'HQ00' as [SEGMENT1]
    --      ,'HQ00' as [SEGMENT2]
    --      ,'' as [SEGMENT3]      ,'' as [SEGMENT4]      ,'' as [SEGMENT5]
    --      ,0 as [SORT_ORDER]      ,'Y' as [ACTIVE_FLAG]      ,'' as [VALUE_DESCRIPTION]      ,'chkim.68' as [CREATE_USER_ID]      ,GetDate() as [CREATE_DATE]      ,'chkim.68' as [MODIFY_USER_ID]      ,GetDate() as [MODIFY_DATE]
    --      ,'' as [ATTRIBUTE1]      ,'' as [ATTRIBUTE2]      ,'' as [ATTRIBUTE3]      ,'' as [ATTRIBUTE4]      ,'' as [ATTRIBUTE5]
    --      ,'' as [ATTRIBUTE6]      ,'' as [ATTRIBUTE7]      ,'' as [ATTRIBUTE8]      ,'' as [ATTRIBUTE9]      ,'' as [ATTRIBUTE10]
    --      ,'' as [ATTRIBUTE11]      ,'' as [ATTRIBUTE12]      ,'' as [ATTRIBUTE13]      ,'' as [ATTRIBUTE14]      ,'' as [ATTRIBUTE15]
    --      ,'' as [PLANT_ID]

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'scm_batch';  
    SET     @v_batch_user = 'scm_batch' ; -- @p_user_id
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SSP_ANL_SHIP_PLAN_40_RUN';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N''; -- ▶ 테이블 필수
    DECLARE @d_event_date   DATETIME;

    -- 임시 실행시간 확인용
    DECLARE @v_start_time				DATETIME     = SYSDATETIME();
    DECLARE @v_exec_time				NVARCHAR(10) = ''--'[00:00]';

    -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = N'['++'][division_id :' + @p_division_id + '][company_id :' + @p_company_id + '][' + @v_exec_time + ']'   ; 
    SET @d_event_date = SYSDATETIME();


    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user

    if isnull(@p_company_id,'') = '' begin
      SET @v_log_type = N'ERROR';
      SET @v_log_message = N'Company ID is not provided';
      SET @v_description = @v_program_name +'- division_id :'+ @p_division_id+'-'+'company_id :' + @p_company_id + ':'+ + N'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                ,@p_log_type      =@v_log_type
                                ,@p_log_count     =@n_log_count 
                                ,@p_log_message   =@v_log_message 
                                ,@p_description   =@v_description 
                                ,@p_event_date    =@d_event_date 
                                ,@p_user_id       =@v_batch_user
        return -1
    end

    BEGIN TRY
    
        SET @v_log_type = N'TXN';
        SET @v_log_message = N'[PR_SSP_ANL_SHIP_PLAN_40]';
        SET @v_description = @v_program_name +'[division_id :'+ @p_division_id+']['+'company_id :' + @p_company_id + ']'
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                ,@p_log_type      =@v_log_type
                                ,@p_log_count     =@n_log_count 
                                ,@p_log_message   =@v_log_message 
                                ,@p_description   =@v_description 
                                ,@p_event_date    =@d_event_date 
                                ,@p_user_id       =@v_batch_user
        EXEC [dbo].[PR_SSP_ANL_SHIP_PLAN_40] @p_division_id, @p_company_id
    
    END TRY              

    BEGIN CATCH

      SET @v_log_type = N'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = @v_program_name +'- division_id :'+ @p_division_id+'-'+'company_id :' + @p_company_id + ':'+ + N'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                ,@p_log_type      =@v_log_type
                                ,@p_log_count     =@n_log_count 
                                ,@p_log_message   =@v_log_message 
                                ,@p_description   =@v_description 
                                ,@p_event_date    =@d_event_date 
                                ,@p_user_id       =@v_batch_user
        return -1
    END CATCH
        
    SET @v_exec_time  =  REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' + 
                          REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) 


    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description = N'['++'][division_id :' + @p_division_id + '][company_id :' + @p_company_id + '][' + @v_exec_time + ']'   ; 
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
