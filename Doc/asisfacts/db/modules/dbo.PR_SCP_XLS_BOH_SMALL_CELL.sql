  
/*      
 * Program ID   : PR_SCP_XLS_BOH_SMALL_CELL        
 * Description  : PR_SCP_PLN_CREATE_DATA 에서 호출함.      
 * OutTable     :      
 * Execute      : 
    -- DELETE FROM SCM_SYS_LOG_BATCH where CREATED_BY ='kth'
    EXEC PR_SCP_XLS_BOH_SMALL_CELL
                                 @p_plan_cycle          = 'WEEKLY'
                               , @p_plan_start_yyyymmdd = '20190107'
                               , @p_plan_id             = '1060'
                               , @p_modeling_id         = '2'
                               , @p_seq                 = '1'
                               , @p_plan_type           = 'PR'
                               , @p_master_id           = '81::WEEKLY'
                               , @p_division_id         = '81'
                               , @p_engine_plan_id      = '1060::PR::1'
                               , @p_user_id             = 'KTH' 
    SELECT * FROM SCM_SYS_LOG_BATCH  where CREATED_BY ='kth' order by CREATION_DATE desc

 * Program History      
 *===================================================================================================      
 *   Date       In Charge      Description      
 *===================================================================================================      
 * 2019.03.12   KTH         Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트  
 */    


--DROP PROC PR_SCP_XLS_BOH_CELL

CREATE PROCEDURE [dbo].[PR_SCP_XLS_BOH_SMALL_CELL]
(       
      @p_plan_cycle           NVARCHAR(0150)        
    , @p_plan_start_yyyymmdd  NVARCHAR(0008)        
    , @p_plan_id              NVARCHAR(4000)        
    , @p_modeling_id          NVARCHAR(4000)        
    , @p_seq                  NVARCHAR(4000)        
    , @p_plan_type            NVARCHAR(4000)        
    , @p_master_id            NVARCHAR(4000)        
    , @p_division_id          NVARCHAR(0030)        
    , @p_engine_plan_id       NVARCHAR(4000)        
    , @p_user_id              NVARCHAR(0150)  = 'SCP_batch'        
    ---- , @p_debug       INT OUTPUT      
)       
AS        
  BEGIN      
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;      
    SET NOCOUNT ON;      
    SET XACT_ABORT ON;      
    SET ANSI_WARNINGS OFF;      
      
    -- LOG 용 변수 설정      
    DECLARE @v_batch_user   NVARCHAR(150) = N'SCP_batch';        
    SET @v_batch_user                     = @p_user_id      
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_XLS_BOH_SMALL_CELL';      
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...      
    DECLARE @n_log_count    INTEGER = 0;      
    DECLARE @v_log_message  NVARCHAR(1000);      
    DECLARE @v_description  NVARCHAR(500);    
    DECLARE @v_table_id     NVARCHAR(150) = N'SCM_SYS_LOG_BATC';   
    DECLARE @d_event_date   DATETIME;      
  
  -- 시작 LOG      
    SET @v_log_type     = N'START';      
    SET @v_log_message  = N'########## Start of procedure ##########';      
    SET @v_description  = @v_program_name + ':' + N'INSERT LOGIC';      
    SET @d_event_date   = SYSDATETIME();      
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
                              ,@p_log_type      = @v_log_type      
                              ,@p_log_count     = @n_log_count       
                              ,@p_log_message   = @v_log_message       
                              ,@p_description   = @v_description       
                              ,@p_event_date    = @d_event_date       
                              ,@p_user_id       = @v_batch_user      
                              ;      
  
   
        -- 실행시간 확인용    
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();    
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'00:00';    

    --DECLARE @debug_mode            NVARCHAR(30) = 'T'
        BEGIN TRY        
          BEGIN        


            -------------------------------------------------------------------------------------------------------------         
            -- 1. BOH
            -------------------------------------------------------------------------------------------------------------     
              DELETE FROM SCP_XLS_BOH_SMALL_CELL                            
                    WHERE DIVISION_ID = @p_division_id -- AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND PLAN_TYPE = @p_plan_type AND SEQ = @p_seq    

              INSERT INTO SCP_XLS_BOH_SMALL_CELL(
                                        DIVISION_ID
                                        ,PLAN_START_YYYYMMDD
                                        ,PLAN_TYPE
                                        ,SEQ
                                        ,ITEM_ID
                                        ,SITE_ID
                                        ,SCM_SITE_ID
                                        ,LOC
                                        ,OSP_YN
                                        ,RECEIVING_DTTM
                                        ,QTY
                                        ,LOT_ID
                                        ,DESCR
                                        ,TCO_CELL_YN
                                        ,CELL_ITEM_ID
                                        ,TCO_EXIST_YN
                                        ,CELL_TO_TCO_BOD_LT
                                        ,TCO_TO_CELL_BOD_LT
                                        ,CELL_TO_TCO_TOTAL_BOD_LT
                                        ,FORMATION_TOTAL_YIELD
                                        ,TOTAL_LT_FORMATION
                                        ,CREATED_BY
                                        ,CREATION_DATE
                                        ,LAST_UPDATED_BY
                                        ,LAST_UPDATE_DATE
                                        ,ATTRIBUTE1
                                        ,ATTRIBUTE2
                                        ,ATTRIBUTE3
                                        ,ATTRIBUTE4
                                        ,ATTRIBUTE5
                                        ,ATTRIBUTE6
                                        ,ATTRIBUTE7
                                        ,ATTRIBUTE8
                                        ,ATTRIBUTE9
                                        ,ATTRIBUTE10
                                      )
              SELECT  @p_division_id            AS DIVISION_ID
                    , @p_plan_start_yyyymmdd    AS PLAN_START_YYYYMMDD
                    , @p_plan_type              AS PLAN_TYPE
                    , @p_seq                    AS SEQ
                    , ITEM_ID
                    , SITE_ID
                    , SCM_SITE_ID
                    , LOC
                    , OSP_YN
                    , RECEIVING_DTTM
                    , QTY
                    , LOT_ID
                    , DESCR
                    , TCO_CELL_YN                    
					, (CASE WHEN CELL_ITEM_ID = ITEM_ID_ASSY THEN ITEM_ID_PROD ELSE CELL_ITEM_ID END ) AS CELL_ITEM_ID--ADD DHJ...07/02/2023
                    , TCO_EXIST_YN
                    , CELL_TO_TCO_BOD_LT
                    , TCO_TO_CELL_BOD_LT
                    , CELL_TO_TCO_TOTAL_BOD_LT
                    , FORMATION_TOTAL_YIELD
                    , TOTAL_LT_FORMATION
                    , @v_batch_user             AS CREATED_BY
                    , GETDATE()                 AS CREATION_DATE
                    , @v_batch_user             AS LAST_UPDATED_BY
                    , GETDATE()                 AS LAST_UPDATE_DATE
                    , NULL                      AS ATTRIBUTE1
                    , NULL                      AS ATTRIBUTE2
                    , NULL                      AS ATTRIBUTE3
                    , NULL                      AS ATTRIBUTE4
                    , NULL                      AS ATTRIBUTE5
                    , NULL                      AS ATTRIBUTE6
                    , NULL                      AS ATTRIBUTE7
                    , NULL                      AS ATTRIBUTE8
                    , NULL                      AS ATTRIBUTE9
                    , NULL                      AS ATTRIBUTE10
              FROM (
                        SELECT A.ITEM_ID,A.SITE_ID,[dbo].[FN_SCM_SPLIT](A.SITE_ID,1,'~') AS SCM_SITE_ID,[dbo].[FN_SCM_SPLIT](A.SITE_ID,2,'~') AS LOC,
                         ( SELECT ISNULL(S.OSP_YN,'N')
                             FROM SCM_MST_SITE S WITH(NOLOCK)
                            WHERE S.DIVISION_ID=@p_division_id
                              AND S.SCM_SITE_ID =[dbo].[FN_SCM_SPLIT](A.SITE_ID,1,'~')
                          ) AS OSP_YN,
                         A.RECEIVING_DTTM,A.QTY,A.LOT_ID,A.DESCR,
                         Y.TCO_CELL_YN,
                         (CASE WHEN Y.TCO_CELL_YN = 'Y' THEN Y.ATTRIBUTE1 ELSE A.ITEM_ID END ) AS CELL_ITEM_ID,
						 Z.ITEM_ID_ASSY, Z.ITEM_ID_PROD ,---------------ADD DHJ...07/02/2023

                         ( SELECT CASE WHEN MAX(TCO_CELL_ITEM_ID) IS NULL THEN 'N' ELSE 'Y' END
                             FROM SCP_MST_CELL_TCO_RELATION_V V
                            WHERE 1=1
                              AND V.CELL_ITEM_ID = (CASE WHEN Y.TCO_CELL_YN = 'Y' THEN Y.ATTRIBUTE1 ELSE A.ITEM_ID END )
                          ) AS TCO_EXIST_YN,
                         ( SELECT MAX(CELL_TO_TCO_BOD_LT)
                             FROM SCP_MST_CELL_TCO_RELATION_V V
                            WHERE 1=1
                              AND V.CELL_ITEM_ID = (CASE WHEN Y.TCO_CELL_YN = 'Y' THEN Y.ATTRIBUTE1 ELSE A.ITEM_ID END )
                          ) AS CELL_TO_TCO_BOD_LT,
                          ( SELECT MAX(TCO_TO_CELL_BOD_LT)
                             FROM SCP_MST_CELL_TCO_RELATION_V V
                            WHERE 1=1
                              AND V.CELL_ITEM_ID = (CASE WHEN Y.TCO_CELL_YN = 'Y' THEN Y.ATTRIBUTE1 ELSE A.ITEM_ID END )
                          ) AS TCO_TO_CELL_BOD_LT,
                          ( SELECT MAX(CELL_TO_TCO_TOTAL_BOD_LT)
                             FROM SCP_MST_CELL_TCO_RELATION_V V
                            WHERE 1=1
                              AND V.CELL_ITEM_ID = (CASE WHEN Y.TCO_CELL_YN = 'Y' THEN Y.ATTRIBUTE1 ELSE A.ITEM_ID END )
                          ) AS CELL_TO_TCO_TOTAL_BOD_LT,
                          ( SELECT ISNULL(MAX(V.FORMATION_TOTAL_YIELD),1)
                              FROM [dbo].[SCP_MST_FORMATION_V] V
                             WHERE V.DIVISION_ID=@p_division_id
                               AND ITEM_ID= (CASE WHEN Y.TCO_CELL_YN = 'Y' THEN Y.ATTRIBUTE1 ELSE A.ITEM_ID END )
                           ) AS FORMATION_TOTAL_YIELD,
                          ( SELECT ISNULL(MAX(V.TOTAL_LT_FORMATION),0)
                              FROM [dbo].[SCP_MST_FORMATION_V] V
                             WHERE V.DIVISION_ID=@p_division_id
                               AND ITEM_ID= (CASE WHEN Y.TCO_CELL_YN = 'Y' THEN Y.ATTRIBUTE1 ELSE A.ITEM_ID END )
                           ) AS TOTAL_LT_FORMATION
                    FROM dbo.SCP_PLN_TH_ENG_STOCK_PLAN  A WITH(NOLOCK)
                    INNER JOIN SCP_MST_FINAL_ITEM Y WITH(NOLOCK)
                            ON 0 = 0
                          AND Y.DIVISION_ID =@p_division_id
                          AND A.ITEM_ID     = Y.ITEM_ID
                          AND Y.OPERATION_GROUP='A'

					LEFT OUTER JOIN SCP_MST_CELL_PROD_ASSY_MAP Z WITH(NOLOCK) --------ADD DHJ...07/02/2023
						ON [dbo].[FN_SCM_SPLIT](A.SITE_ID,1,'~') = Z.PLANT_ID+'-A' 
							AND (CASE WHEN Y.TCO_CELL_YN = 'Y' THEN Y.ATTRIBUTE1 ELSE A.ITEM_ID END ) = Z.ITEM_ID_ASSY
                  WHERE 1=1
                    AND A.MASTER_ID  =   @p_master_id
                    --AND PLAN_ID    =   '1060'
                    AND A.PLAN_ID    =   @p_engine_plan_id
                    AND A.SITE_ID    LIKE '%-A~%'

              ) X
      

        -----------------------------------------------------------      
        -- 실행 Logic END --      
        -----------------------------------------------------------      
        --IF @@TRANCOUNT > 0      
        --  BEGIN      
        --    COMMIT TRAN T1;      
        --  END;             
      
      
        -- TXN LOG      
        SET @v_log_type     = N'TXN';        
        SET @n_log_count    = @@ROWCOUNT;      
        SET @v_log_message  = N'INSERT INTO '+@v_table_id;      
        SET @v_description  = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);      
        SET @d_event_date   = SYSDATETIME();      
      
        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
                                  ,@p_log_type      = @v_log_type      
                                  ,@p_log_count     = @n_log_count       
                                  ,@p_log_message   = @v_log_message       
                                  ,@p_description   = @v_description       
                                  ,@p_event_date    = @d_event_date       
                                  ,@p_user_id       = @v_batch_user      
                                  ;            
      
    END      
    END TRY      
      
    BEGIN CATCH      
      --IF @@TRANCOUNT > 0      
      --  BEGIN      
      --    ROLLBACK TRAN T1      
      --  END;      
            
      -- ERROR LOG      
      SET @v_log_type     = N'ERROR';      
      SET @v_log_message  = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));      
      SET @v_description  = @v_program_name + N'ERROR_LINE : ' + STR(ERROR_LINE());      
      SET @d_event_date   = SYSDATETIME();      
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
                                ,@p_log_type      = @v_log_type      
                                ,@p_log_count     = @n_log_count       
                                ,@p_log_message   = @v_log_message       
                                ,@p_description   = @v_description       
                                ,@p_event_date    = @d_event_date       
                                ,@p_user_id       = @v_batch_user      
                                ;      
--      PRINT @@ERROR      
      return -1      
    END CATCH;      
      
  
-- 임시 운영반영시에 주석처리 할것.    
     SET @v_exec_time  =  REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
                          REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))     
       
    -- 종료 LOG          
    SET @v_log_type     = N'END';          
    SET @v_log_message  = N'########## END of procedure ##########';          
    SET @v_description  = N'['+@p_master_id+']['+@p_engine_plan_id+'][' + @v_exec_time + ']';                
    SET @d_event_date   = SYSDATETIME()  ;      
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
                              ,@p_log_type      = @v_log_type      
                              ,@p_log_count     = @n_log_count       
                              ,@p_log_message   = @v_log_message       
                              ,@p_description   = @v_description       
                              ,@p_event_date    = @d_event_date       
                              ,@p_user_id       = @v_batch_user      
                              ;      
    return 1        
      
  END;       
  
