--USE [LGCE_FP_TR]

CREATE PROCEDURE [dbo].[PR_SCM_SIMULATION_DATA_DELETE]
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_SIMULATION_DATA_DELETE                                            **/
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
/** 2021.10.06    CYS          최초 작성                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_SCM_SIMULATION_DATA_DELETE
*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_master_id      nvarchar(30)
  DECLARE @v_plan_id        nvarchar(30)  

  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_SIMULATION_DATA_DELETE'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code       nvarchar(10)
  
  DECLARE @sysdate          DATETIME2 = GETDATE()
  DECLARE @key_date         nvarchar(8)
  DECLARE @period           int = 7        -- 보관 기간 설정
  DECLARE @v_seq            nvarchar(1000)
  
  DECLARE @n_amend_period   int =  1       -- 보관 기간 설정
        , @n_release_period int = 30       -- 보관 기간 설정    -- 2018.10.15 : 14일 > 30일로 변경
        , @n_backup_period  int = 30       -- 보관 기간 설정

  DECLARE @n_h_amend_period   int =  1       -- History 테이블의  Amend Data   보관 기간 설정
        , @n_h_release_period int = 30       -- History 테이블의  Release Data 보관 기간 설정
        , @n_r_amend_period   int =  1       -- Amend UI 테이블의 Amend Data   보관 기간 설정
        , @n_r_release_period int = -1       -- Amend UI 테이블의 Release Data 보관 기간 설정 : History 테이블로 바로 저장.

  DECLARE @v_temp1          nvarchar(1000)
  DECLARE @v_temp2          nvarchar(1000)
  
  SET @v_temp1 = 'S' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  SET @v_temp2 = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  
  -- PLAN 설정 안되면 DEFAULT 값으로 설정한다.
  SET @v_master_id  = 'PL_INSTANCE'
  SET @v_plan_id    = @v_master_id + '-' + CONVERT(NVARCHAR, GETDATE(), 112)
  
	-- Start 로그는 무조건 남김
  SET @n_log_count = @n_log_count + 1

  EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', @n_log_count, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

  SET @sysdate = GETDATE()
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

  BEGIN TRY
    
    ------------------------------------------------------------------------------------------
    -- INSTANCE DATA 삭제
    ------------------------------------------------------------------------------------------
    --IF CHARINDEX('DEV', USER) = 0
    BEGIN
      
     

    ------------------------------------------------------------------------------------------
    -- AMEND 테이블 BACKUP 및 삭제
    ------------------------------------------------------------------------------------------
    BEGIN

      DECLARE @n_loop             int
            , @v_fr_table         nvarchar(50)
            , @v_to_table         nvarchar(50)
            , @v_column_name      nvarchar(50)
            , @v_column_list      nvarchar(MAX)
            , @v_sqltext          nvarchar(MAX)
            , @v_nation_id        nvarchar(10) = SUBSTRING(@v_master_id, 1, 2)
            , @v_amend_date       nvarchar(10) = CONVERT(NVARCHAR, DATEADD(DAY, @n_amend_period   * -1, CONVERT(DATE, GETDATE())), 112)
            , @v_release_date     nvarchar(10) = CONVERT(NVARCHAR, DATEADD(DAY, @n_release_period * -1, CONVERT(DATE, GETDATE())), 112)
            , @v_backup_date      nvarchar(10) = CONVERT(NVARCHAR, DATEADD(DAY, @n_backup_period  * -1, CONVERT(DATE, GETDATE())), 112)
            , @n_before_count     int
            , @n_after_count      int
            ---------------------------------
            , @v_h_amend_date     nvarchar(10) = CONVERT(NVARCHAR, DATEADD(DAY, @n_h_amend_period   * -1, CONVERT(DATE, GETDATE())), 112)
            , @v_h_release_date   nvarchar(10) = CONVERT(NVARCHAR, DATEADD(DAY, @n_h_release_period * -1, CONVERT(DATE, GETDATE())), 112)
            , @v_r_amend_date     nvarchar(10) = CONVERT(NVARCHAR, DATEADD(DAY, @n_r_amend_period   * -1, CONVERT(DATE, GETDATE())), 112)
            , @v_r_release_date   nvarchar(10) = CONVERT(NVARCHAR, DATEADD(DAY, @n_r_release_period * -1, CONVERT(DATE, GETDATE())), 112)
    
      -- PSI AMEND 테이블 선언
      DECLARE @v_fr_table_001 nvarchar(50) = 'FP_SIM_MATERIAL_PACK_R'        , @v_to_table_001 nvarchar(50) = 'FP_SIM_MATERIAL_PACK_H'
            

      --LOG 생성
      SET @v_message = '@v_nation_id : ' + @v_nation_id
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'AMEND-TABLE-BACKUP', 'SELECT', @n_log_count, null, @v_message, null

      --LOG 생성
      SET @v_message = '@v_amend_date : ' + @v_amend_date + ' , @v_release_date : ' + @v_release_date
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'AMEND-TABLE-BACKUP', 'SELECT', @n_log_count, null, @v_message, null

      --LOG 생성
      SET @v_message = '@v_backup_date : ' + @v_backup_date
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'AMEND-TABLE-BACKUP', 'SELECT', @n_log_count, null, @v_message, null

      --LOG 생성
      SET @v_message = '@v_h_amend_date : ' + @v_h_amend_date + ' , @v_h_release_date : ' + @v_h_release_date
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'HISTORY-TABLE', 'SELECT', @n_log_count, null, @v_message, null

      SET @v_message = '@v_r_amend_date : ' + @v_r_amend_date + ' , @v_r_release_date : ' + @v_r_release_date
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'AMEND-TABLE', 'SELECT', @n_log_count, null, @v_message, null
      
      BEGIN
      
        SET @n_loop = 0
        
        WHILE 1 = 1
        BEGIN
        
          SET @n_loop = @n_loop + 1

          SELECT @v_fr_table = (
                                CASE @n_loop -- PSI AMEND 테이블
                                             WHEN  1 THEN @v_fr_table_001
                                                     ELSE 'NULL'
           END
                               )
               , @v_to_table = (
                                CASE @n_loop -- PSI AMEND 테이블
                                             WHEN  1 THEN @v_to_table_001
                                                     ELSE 'NULL'
                                END
                               )
                               
          IF @v_fr_table = 'NULL'
            BREAK
            
          SET @v_column_list = ''
          
          DECLARE C_COLUMN CURSOR FOR
            SELECT COLUMN_NAME
            FROM   INFORMATION_SCHEMA.COLUMNS WHERE 1=1
            AND    TABLE_NAME = @v_to_table
            ORDER  BY TABLE_NAME, ORDINAL_POSITION    
            
          OPEN C_COLUMN
          
          WHILE 1 = 1
          BEGIN
            
            FETCH C_COLUMN
            INTO  @v_column_name
        
            IF @@FETCH_STATUS <> 0					-- FETCH 레코드 없으면 LOOP 탈출
              BREAK

            IF @v_column_list = ''
              SET @v_column_list = @v_column_name
            ELSE
              SET @v_column_list = @v_column_list + ',' +@v_column_name
              
          END
          CLOSE C_COLUMN	
          
          DEALLOCATE C_COLUMN
          
          BEGIN
            
            -- 기존 수량 COUNT
            SET @v_sqltext = 'SELECT @v_return = COUNT(1) FROM ' + @v_to_table + ' '
                      
            EXEC sp_executesql @v_sqltext, N'@v_return AS INTEGER OUTPUT', @v_return=@n_before_count OUTPUT

            -- History 테이블에 INSERT
            SET @v_sqltext = 'INSERT INTO  ' + @v_to_table + ' '
                      + '(' + @v_column_list + ') '
                          + ' SELECT ' + @v_column_list + ' '
                           + 'FROM   ' + @v_fr_table + ' A '
                           + 'WHERE  EXISTS ( '
                           + '               SELECT 1 '
                           + '               FROM   ( '
                           + '                       SELECT INSTANCE_ID, SIM_PLAN_ID '
                           + '                       FROM   ( '
                           + '                               SELECT INSTANCE_ID, SIM_PLAN_ID '
                           + '                               FROM   FP_SIM_PLAN_H '
                           + '                               WHERE  1=1 '
						   + '                               AND    PROGRAM_TYPE = ''PACK_SIMUL'' '
						   + '                               AND    HISTORY_YN = ''N'' '
						   + '								 AND    PLAN_START_TIME < CONVERT(DATE, '''+@v_r_amend_date+''' ) '
                           + '                              ) A '
                           + '                      ) X '
                           + '               WHERE  X.INSTANCE_ID  = A.INSTANCE_ID '
                           + '               AND    X.SIM_PLAN_ID      = A.SIM_PLAN_ID '
                           + '              ) '

            EXEC sp_executesql @v_sqltext, N'@v_return AS INTEGER OUTPUT', @v_return=@n_row_count OUTPUT


			-- PLAN 정보 테이블에 history 여부 저장
			SET @v_sqltext = 'UPDATE A	'
                           + 'SET	HISTORY_YN = ''Y'' '
			               + 'FROM	FP_SIM_PLAN_H A		'																			
						   + '      ,(   SELECT INSTANCE_ID, SIM_PLAN_ID '												
                           + '           FROM   ( '																		
                           + '                  SELECT INSTANCE_ID, SIM_PLAN_ID '										
                           + '                  FROM   FP_SIM_PLAN_H '													
                           + '                  WHERE  1=1 '															
						   + '                  AND    PROGRAM_TYPE = ''PACK_SIMUL'' '									
						   + '                  AND    HISTORY_YN = ''N'' 	'
						   + '					AND    PLAN_START_TIME < CONVERT(DATE, '''+@v_r_amend_date+''' ) '		
                           + '                 ) A '																	
                           + '       ) X '
						   + 'WHERE  X.INSTANCE_ID  = A.INSTANCE_ID '
                           + 'AND    X.SIM_PLAN_ID  = A.SIM_PLAN_ID '
            
			EXEC sp_executesql @v_sqltext, N'@v_return AS INTEGER OUTPUT', @v_return=@n_row_count OUTPUT
			

            -- Amend 테이블에 DELETE
            SET @v_sqltext = 'DELETE FROM A '
                           + 'FROM   ' + @v_fr_table + ' A '
                           + 'WHERE  EXISTS ( '
                           + '               SELECT 1 '
                           + '               FROM   ( '
                           + '                       SELECT INSTANCE_ID, SIM_PLAN_ID '
                           + '                       FROM   ( '
                           + '                               SELECT INSTANCE_ID, SIM_PLAN_ID '
                           + '                               FROM   FP_SIM_PLAN_H '
                           + '                               WHERE  1=1 '
						   + '                               AND    PROGRAM_TYPE = ''PACK_SIMUL'' '
						   + '								 AND    PLAN_START_TIME < CONVERT(DATE, '''+@v_r_amend_date+''' ) '
                           + '                              ) A '
                           + '                      ) X '
                           + '               WHERE  X.INSTANCE_ID  = A.INSTANCE_ID '
                           + '               AND    X.SIM_PLAN_ID      = A.SIM_PLAN_ID '
                           + '              ) '
            
            EXEC sp_executesql @v_sqltext, N'@v_return AS INTEGER OUTPUT', @v_return=@n_row_count OUTPUT


            -- INSERT 하고 난 후의 COUNT
            SET @v_sqltext = 'SELECT @v_return = COUNT(1) FROM ' + @v_to_table + ' '
                      
            EXEC sp_executesql @v_sqltext, N'@v_return AS INTEGER OUTPUT', @v_return=@n_after_count OUTPUT

            
            SET @v_table_name = @v_to_table
            
            --LOG 생성
            SET @v_message = @v_fr_table + ' : ' + convert(nvarchar, @n_after_count - @n_before_count)
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

			/*
            -- History 테이블에 DELETE
            SET @v_sqltext = 'DELETE FROM A '
                           + 'FROM   ' + @v_to_table + ' A '
                           + 'WHERE  EXISTS ( '
                           + '               SELECT 1 '
                           + '               FROM   ( '
                           + '                       SELECT INSTANCE_ID, SIM_PLAN_ID '
                           + '                       FROM   ( '
                           + '                               SELECT INSTANCE_ID, SIM_PLAN_ID '
                           + '                               FROM   FP_SIM_PLAN_H '
                           + '                               WHERE  1=1 '
						   + '                               AND    PROGRAM_TYPE = ''PACK_SIMUL'' '
						   + '								 AND    PLAN_START_TIME < CONVERT(DATE, '''+@v_r_release_date+''' ) '
                           + '                              ) A '
                           + '                      ) X '
                           + '               WHERE  X.INSTANCE_ID  = A.INSTANCE_ID '
                           + '               AND    X.SIM_PLAN_ID      = A.SIM_PLAN_ID '
                           + '              ) '
            
            EXEC sp_executesql @v_sqltext, N'@v_return AS INTEGER OUTPUT', @v_return=@n_row_count OUTPUT

			*/
		END
        
        END
      
      END

    END

	END

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

  EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   999999, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
  
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

END
