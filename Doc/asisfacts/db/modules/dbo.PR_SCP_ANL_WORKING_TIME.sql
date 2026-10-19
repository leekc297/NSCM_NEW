
/*
 * Program ID   : PR_SCP_ANL_WORKING_TIME
 * Description  : CREATE DAILY WORKING TIME WITH FP INPUT ENGINE LOGIC
 * OutTable     :
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.04.27   YYDOK         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.05.25   YYDOK         외주PACKER는 OUTSOURCING CAPA의 TOTAL을 일CAPA로 반영
 * 2020.02.05   KTH           ESS 외주 Line별 생산 Target 관련 OSP_YN로직 수정
 * 2021.03.15   KSG           PJ20209642 Digital SCM Level.3 달성을 위한 개선 : Work Time 변경
 */
 
CREATE PROCEDURE [dbo].[PR_SCP_ANL_WORKING_TIME]
    ( @P_DIVISION_ID   NVARCHAR(30) )
 AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'';  
    SET     @v_batch_user = 'SCP'
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_ANL_WORKING_TIME';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      
    DECLARE @v_table_id     NVARCHAR(150) = N'SCP_ANL_WORKING_TIME'; 
    DECLARE @d_event_date   DATETIME;
    
    DECLARE @V_DB_NAME      NVARCHAR(1000);    

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SCP_ANL_WORKING_TIME INSERT LOGIC';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                              ,@p_log_type      = @v_log_type
                              ,@p_log_count     = @n_log_count 
                              ,@p_log_message   = @v_log_message 
                              ,@p_description   = @v_description 
                              ,@p_event_date    = @d_event_date 
                              ,@p_user_id       = @v_batch_user
                              ;
      
    BEGIN TRY
      BEGIN  
    
        BEGIN TRANSACTION; 

        ----------------------------------------------------------- 
        -- 1. SCP_ANL_WORKING_TIME 삭제 (당주월요일이후)
        ----------------------------------------------------------- 
        DELETE SCP_ANL_WORKING_TIME WITH(TABLOCK)
        WHERE 1=1
          AND YYYYMMDD >= [dbo].[FN_GET_BUCKET_YYYYMMDD](0)
          AND DIVISION_ID = @P_DIVISION_ID
          ;

        ----------------------------------------------------------- 
        -- 2. SCP_ANL_WORKING_TIME 입력 (outsourcing packer 제외)
        -----------------------------------------------------------
        INSERT SCP_ANL_WORKING_TIME 
             ( DIVISION_ID
             , SCM_SITE_ID
             , OPERATION_ID
             , LINE_ID
             , YYYYMMDD
             , WORKING_TIME
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
              )
             SELECT A.DIVISION_ID
                   ,A.PLANT_SITE_ID AS SCM_SITE_ID
                   ,A.OPERATION_ID
                   ,A.LINE_ID
                   ,A.YYYYMMDD 
	            -- PJ20209642 전 공정 View에서 Daily Capa 사용하여 Tact Time 으로 전환 / Loss Time Except 생성 시 비율 적용되어 있음
                --   Daily Capa 사용 시 : 형교환 Loss만 반영
                --   Tact Time 사용 시 : 전체 Loss 반영
                   ,(
                      CASE WHEN c.loss_start_date IS NOT NULL THEN a.working_time - ROUND(ISNULL(c.setup_loss_time_min, 0), 0, 1) 
                      ELSE a.working_time - ROUND( (a.working_time_rate * ISNULL(b.setup_loss_time_min, 0)), 0, 1) 
                      END
                    ) AS WORKING_TIME
				/*
                   ,(
                      CASE LEFT(A.OPERATION_ID,1) WHEN 'E'  THEN
                                                                 CASE WHEN c.loss_start_date IS NOT NULL THEN a.working_time - ROUND( (a.working_time_rate * (ISNULL(c.loss_time_min, 0) + ISNULL(c.setup_loss_time_min, 0))), 0, 1) 
                                                                      ELSE a.working_time - ROUND( (a.working_time_rate * (ISNULL(b.loss_time_min, 0) + ISNULL(b.setup_loss_time_min, 0))), 0, 1) 
                                                                 END  --tact_work_time
                      ELSE 
                                 CASE WHEN c.loss_start_date IS NOT NULL THEN a.working_time - ROUND( (a.working_time_rate *  ISNULL(c.setup_loss_time_min, 0)), 0, 1) 
                                      ELSE a.working_time - ROUND( (a.working_time_rate *  ISNULL(b.setup_loss_time_min, 0)), 0, 1) 
                                 END  -- capa_work_time
                      END
                    ) AS WORKING_TIME
				*/
                    , 'SCP_BATCH'
                    , GETDATE()
                    , 'SCP_BATCH'
                    , GETDATE()
               FROM  (
                       SELECT w.*
                           ,  w.working_time / 1440.0 AS working_time_rate
                       FROM  scp_mst_working_time W WITH (NOLOCK)
                            ,scm_mst_site         s with (nolock)
                       WHERE w.division_id = @P_DIVISION_ID
                         and w.division_id = s.division_id
                         and w.plant_site_id = s.scm_site_id
                         --and s.osp_yn      <> 'Y'
                         AND (s.osp_yn  <> 'Y' OR (S.OSP_YN = 'Y' AND ISNULL(S.ATTRIBUTE1, 'N')  = 'Y'))  -- ESS 외주 Line별 생산 Target 관련 OSP_YN로직 수정
                         AND W.LINE_ID <> '-'
                     ) a
                     LEFT JOIN ( SELECT *
                                  FROM   scp_mst_loss_time WITH (NOLOCK) --loss_time_min 값은 work time이 1440(=1일)분 기준으로 입력되어 있으므로 사용할때 [ ('work time' / 1440) * 'loss_time_min') ] 비율계산된 값으로사용해야 한다.   
                                  WHERE  division_id = @P_DIVISION_ID
                                ) b
                     ON   a.division_id   = b.division_id
                     AND  a.plant_site_id = b.plant_site_id
                     AND  a.factory_id    = b.factory_id
                     AND  a.operation_id  = b.operation_id
                     AND  a.line_id       = b.line_id 

                     LEFT JOIN ( SELECT division_id, plant_site_id, factory_id, operation_id, line_id
                                      , loss_start_date, loss_end_date, loss_time_min, setup_loss_time_min
                                 FROM   scp_mst_loss_time_except WITH (NOLOCK) --loss_time_min 값은 work time이 1440(=1일)분 기준으로 입력되어 있으므로 사용할때 [ ('work time' / 1440) * 'loss_time_min') ] 비율계산된 값으로사용해야 한다.   
                                 WHERE  division_id = @P_DIVISION_ID
                               ) c
                     ON   a.division_id   = c.division_id
                     AND  a.plant_site_id = c.plant_site_id
                     AND  a.factory_id    = c.factory_id
                     AND  a.operation_id  = c.operation_id
                     AND  a.line_id       = c.line_id 
                     AND  a.yyyymmdd      >= c.loss_start_date
                     AND  a.yyyymmdd      <= c.loss_end_date
               WHERE 1=1
                 AND A.YYYYMMDD >= [dbo].[FN_GET_BUCKET_YYYYMMDD](0)                                 
              ;  

        ----------------------------------------------------------- 
        -- 3. SCP_ANL_WORKING_TIME 입력 (outsourcing packer )
        -----------------------------------------------------------
        INSERT SCP_ANL_WORKING_TIME 
             ( DIVISION_ID
             , SCM_SITE_ID
             , OPERATION_ID
             , LINE_ID
             , YYYYMMDD
             , WORKING_TIME
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
              )
             SELECT A.DIVISION_ID
                   ,A.PLANT_SITE_ID AS SCM_SITE_ID
                   ,A.OPERATION_ID
                   ,A.LINE_ID
                   ,A.YYYYMMDD 
                   ,( SELECT ISNULL(SUM(ISNULL(C.DAILY_CAPA_QTY,0)),0)
                        FROM SCP_MST_OUTSOURCING_CAPA  C WITH(NOLOCK)
                       WHERE C.DIVISION_ID   = A.DIVISION_ID
                         AND C.PLANT_SITE_ID = A.PLANT_SITE_ID
                         AND C.ITEM_ID       = '-' 
                    ) AS WORKING_TIME
                    , 'SCP_BATCH'
                    , GETDATE()
                    , 'SCP_BATCH'
                    , GETDATE()
               FROM  (
                       SELECT w.*
                           ,  w.working_time / 1440.0 AS working_time_rate
                       FROM  scp_mst_working_time W WITH (NOLOCK)
                            ,scm_mst_site         s with (nolock)
                       WHERE w.division_id = @P_DIVISION_ID
                         and w.division_id = s.division_id
                         and w.plant_site_id = s.scm_site_id
                         --and s.osp_yn      = 'Y'
                         AND S.OSP_YN = 'Y' 
                         AND ISNULL(S.ATTRIBUTE1, 'N')  IN ('N','')  --    ESS 외주 Line별 생산 Target 관련 OSP_YN로직 수정
                         AND W.LINE_ID = '-'
                     ) a
               WHERE 1=1
                 AND A.YYYYMMDD >= [dbo].[FN_GET_BUCKET_YYYYMMDD](0)                                 
              ;
        
        PRINT N'프로시저 종료'

        ----------------------------------------------------------- 
        -- 9. 종료 처리
        -----------------------------------------------------------
        IF @@TRANCOUNT > 0 
          BEGIN
            COMMIT WORK;
          END;
        
        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

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

      END;

    END TRY

    BEGIN CATCH
        
      IF @@TRANCOUNT > 0 
        BEGIN
          ROLLBACK;
        END;
      
      -- ERROR LOG
      SET @v_log_type = N'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                ,@p_log_type      =@v_log_type
                                ,@p_log_count     =@n_log_count 
                                ,@p_log_message   =@v_log_message 
                                ,@p_description   =@v_description 
                                ,@p_event_date    =@d_event_date 
                                ,@p_user_id       =@v_batch_user
                                ;

      return -1 
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description = N'';    
    SET @d_event_date = SYSDATETIME();
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

