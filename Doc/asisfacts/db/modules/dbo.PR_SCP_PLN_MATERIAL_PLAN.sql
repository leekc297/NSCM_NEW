      
        
          
          
/*              
 * Program ID   : PR_SCP_PLN_MATERIAL_PLAN                
 * Description  : PR_SCP_PLN_CREATE_DATA 에서 호출함.              
 * OutTable     :              
 * Execute      :          
  DELETE FROM SCM_SYS_LOG_BATCH where CREATED_BY ='kth'        
  EXEC PR_SCP_PLN_MATERIAL_PLAN        @p_plan_cycle          ='WEEKLY'        
                                     , @p_plan_start_yyyymmdd ='20180604'           
                                     , @p_plan_id             ='1029'           
                                     , @p_modeling_id         ='2'                  
                                     , @p_seq                 ='4'        
                                     , @p_plan_type           ='PR'            
                                     , @p_master_id           ='81::WEEKLY'         
                                     , @p_division_id         ='81'             
                                     , @p_engine_plan_id      ='1029::PR::4'        
                                     , @p_user_id             = 'KTH'        
 SELECT * FROM SCM_SYS_LOG_BATCH    WITH (NOLOCK)  WHERE CREATED_BY ='KTH' order by CREATION_DATE desc        
        
 * Program History              
 *===================================================================================================              
 *   Date       In Charge      Description              
 *===================================================================================================              
 * 2018.04.24   KTH         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트           
 * 2018.04.24   KTH         SCM_DNM_STOCK_V 중복제거        
 * 2018.06.08   YYDOK       속도이슈(OUT_VERSION_ID 조건추가반영)        
 * 2018.06.08   KTH         TRANSACTION 제거, SCM_DNM_STOCK_V WHERE 조건 수정        
 * 2018.06.12   KTH         속도개선(temp테이블로 수정),SCM_DNM_STOCK_V.QTY -> SCM_QTY        
 * 2018.06.26   KTH         재고 로직 삭제( SCM_DNM_STOCK_V.STOCK_QTY 삭제)      
 * 2018.06.27   KTH         전극 SCP 반영(ORIGIN_DIVISION_ID,ELECTRODE_TYPE) 추가    
 * 2018.07.04   KTH         SCP_MST_FINAL_ITEM_V로 변경  
 * 2022.03.23	KSW			GM JV 반영 :: EE_UC  추가
 * 2023.03.31	HRK			PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 */          
          
CREATE PROCEDURE [dbo].[PR_SCP_PLN_MATERIAL_PLAN]              
(               
      @p_plan_cycle            NVARCHAR(150)                
    , @p_plan_start_yyyymmdd  NVARCHAR(8)                
    , @p_plan_id              NVARCHAR(4000)                
    , @p_modeling_id          NVARCHAR(4000)                
    , @p_seq                  NVARCHAR(4000)                
    , @p_plan_type            NVARCHAR(4000)                
    , @p_master_id            NVARCHAR(4000)                
    , @p_division_id          NVARCHAR(30)                
    , @p_engine_plan_id       NVARCHAR(4000)                
    , @p_user_id              NVARCHAR(150)  = 'scp_batch'                
    ---- , @p_debug       INT OUTPUT              
)               
AS                
  BEGIN              
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;              
    SET NOCOUNT ON;              
    SET XACT_ABORT ON;              
    SET ANSI_WARNINGS OFF;              
              
    -- LOG 용 변수 설정              
    DECLARE @v_batch_user   NVARCHAR(150) = N'scp_batch';                
    SET @v_batch_user = @p_user_id              
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_PLN_MATERIAL_PLAN';              
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...              
    DECLARE @n_log_count    INTEGER = 0;              
    DECLARE @v_log_message  NVARCHAR(1000);              
    DECLARE @v_description  NVARCHAR(500);            
    DECLARE @v_table_id     NVARCHAR(150) = N'SCM_SYS_LOG_BATC';           
    DECLARE @d_event_date   DATETIME;              
          
  -- 시작 LOG              
    SET @v_log_type = N'START';              
    SET @v_log_message = N'########## Start of procedure ##########';              
    SET @v_description = @v_program_name + ':' + N' SCP_PLN_MATERIAL_PLAN INSERT LOGIC';              
    SET @d_event_date = SYSDATETIME();              
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name              
                              ,@p_log_type      =@v_log_type              
                ,@p_log_count     =@n_log_count               
                              ,@p_log_message   =@v_log_message               
                              ,@p_description   =@v_description               
                 ,@p_event_date    =@d_event_date               
                              ,@p_user_id       =@v_batch_user              
                              ;              
          
           
        -- 임시 실행시간 확인용          
    --DECLARE @v_start_time   DATETIME     = SYSDATETIME();          
    --DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';          
          
    BEGIN TRY              
      BEGIN              
        --BEGIN TRAN T1              
                        
         
            -------------------------------------------------------------------------------------------------------------               
            -- 1 SCP_PLN_MATERIAL_PLAN 입력               
            -------------------------------------------------------------------------------------------------------------               
        
              DELETE FROM dbo.SCP_PLN_MATERIAL_PLAN                
              WHERE DIVISION_ID = @p_division_id AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND PLAN_TYPE = @p_plan_type AND SEQ = @p_seq              
          
              INSERT INTO dbo.SCP_PLN_MATERIAL_PLAN              
              (              
                 MASTER_ID          
                ,PLAN_ID          
                ,OUT_VERSION_ID          
                ,DIVISION_ID          
                ,PLAN_START_YYYYMMDD          
                ,PLAN_TYPE          
                ,SEQ          
          
                ,ITEM_ID                    
                ,YYYYMMDD                   
                ,TO_SITE    
                ,ORIGIN_TO_DIVISION_ID    
                ,ELECTRODE_TYPE                    
                ,REQ_QTY                    
--                ,STOCK_QTY                  
                ,CREATED_BY              
                ,CREATION_DATE              
                ,LAST_UPDATED_BY              
                ,LAST_UPDATE_DATE              
              )              
        
                 SELECT  A.MASTER_ID            
                        ,A.PLAN_ID            
                        ,A.OUT_VERSION_ID            
                        ,A.DIVISION_ID            
                        ,A.PLAN_NAME              AS PLAN_START_YYYYMMDD         
                        ,A.PLAN_TYPE                  
                        ,A.SEQ                        
                        ,A.FROM_ITEM_ID           AS ITEM_ID            
                        ,CONVERT(VARCHAR(8), A.START_DATE,112)          AS YYYYMMDD            
--                        ,LEFT(A.TO_SITE_ID,6)     AS TO_SITE_ID        
                        ,SUBSTRING(A.TO_SITE_ID,1,(CASE WHEN CHARINDEX('~', A.TO_SITE_ID) = 0  THEN LEN(A.TO_SITE_ID) ELSE CHARINDEX('~', A.TO_SITE_ID)  -1 END))   AS TO_SITE_ID        
                        ,Y.DIVISION_ID            AS ORIGIN_TO_DIVISION_ID    
                        ,C.ELECTRODE_TYPE    
                        ,SUM(A.QTY)               AS REQ_QTY            
                        --,SUM(B.QTY)             AS STOCK_QTY      
                        ,@v_batch_user            AS CREATED_BY            
                        ,GETDATE()                AS CREATION_DATE            
                        ,@v_batch_user            AS LAST_UPDATED_BY            
                        ,GETDATE()                AS LAST_UPDATED_BY         
                  FROM  SCP_ENG_MATERIAL_PLAN_O_SN A   WITH (NOLOCK) 
						INNER JOIN SCM_MST_DIVISION DM WITH (NOLOCK) -- 2023.03.30 HM JV 가상 사업부 추가 대응
								ON DM.DIVISION_ID = A.DIVISION_ID
							   AND DM.VALID_YN	  = 'Y'
                  INNER JOIN DBO.SCP_MST_FINAL_ITEM_V C  WITH (NOLOCK)           
                           ON A.DIVISION_ID  = @p_division_id        
                          AND A.FROM_ITEM_ID = C.ITEM_ID        
                  --LEFT OUTER JOIN DBO.SCM_MST_SITE Y  WITH (NOLOCK)       -- to   TO_SITE_ID  
                   LEFT OUTER JOIN (SELECT MIN(DIVISION_ID) DIVISION_ID, SCM_SITE_ID, VALID_YN, MIN(OSP_YN) OSP_YN
				                    FROM   DBO.SCM_MST_SITE  WITH (NOLOCK)       -- to   SITE_ID
									WHERE  valid_yn = 'Y'
									GROUP BY SCM_SITE_ID, VALID_YN
								   ) Y   
                           ON 0 = 0
                          -- 2023.03.31 HM JV AND (CASE WHEN A.DIVISION_ID IN ('EE', 'EE_UC') THEN '0' ELSE A.DIVISION_ID END ) = (CASE WHEN Y.DIVISION_ID IN ('EE', 'EE_UC') THEN '0' ELSE Y.DIVISION_ID END )		-- 2022.03.23	KSW	GM JV 반영 :: EE_UC  추가
--                        AND Y.SITE_TYPE   = 'PLANT'    
						  AND Y.DIVISION_ID  = CASE WHEN DM.ATTRIBUTE3 = 'EE' -- 2023.03.30 HM JV 가상 사업부 추가 대응
													THEN Y.DIVISION_ID
													ELSE A.DIVISION_ID
												END 

                          AND Y.SCM_SITE_ID  = REPLACE(A.TO_SITE_ID,'-S','')
                          AND Y.VALID_YN ='Y'                   WHERE 0 = 0            
                  AND A.MASTER_ID           = @p_master_id            
                  AND A.PLAN_ID             = @p_plan_id -- @p_plan_id              
                  AND A.OUT_VERSION_ID      = @p_engine_plan_id          
                  AND A.DIVISION_ID         = @p_division_id            
                  AND A.PLAN_NAME           = @p_plan_start_yyyymmdd            
                  AND A.PLAN_TYPE           = @p_plan_type            
                  AND A.SEQ                 = @p_seq            
                  AND LEFT(A.FROM_ITEM_ID,5) IN (            
                                                'APCAN',  --음극 전지            
                                                'APCCA',  --양극 전지            
                                                'APCCS'   --양극 단면            
                                                 )             
              GROUP BY  A.MASTER_ID            
                        ,A.PLAN_ID            
                        ,A.OUT_VERSION_ID            
                        ,A.DIVISION_ID            
                        ,A.PLAN_NAME                
                        ,A.PLAN_TYPE                  
                        ,A.SEQ                        
                        ,A.FROM_ITEM_ID             
                        ,CONVERT(VARCHAR(8), A.START_DATE,112)      
--                        ,LEFT(A.TO_SITE_ID,6)       
                        ,SUBSTRING(A.TO_SITE_ID,1,(CASE WHEN CHARINDEX('~', A.TO_SITE_ID) = 0  THEN LEN(A.TO_SITE_ID) ELSE CHARINDEX('~', A.TO_SITE_ID)  -1 END)) 
                        ,Y.DIVISION_ID    
                        ,C.ELECTRODE_TYPE      
                 
        -----------------------------------------------------------              
        -- 실행 Logic END --              
        -----------------------------------------------------------              
        --IF @@TRANCOUNT > 0              
        --  BEGIN              
        --    COMMIT TRAN T1;              
        --  END;                     
              
              
        -- TXN LOG              
        SET @v_log_type = N'TXN';    -- 로그타입              
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
              
    END              
    END TRY              
              
    BEGIN CATCH              
      --IF @@TRANCOUNT > 0              
      --  BEGIN              
      --    ROLLBACK TRAN T1              
      --  END;              
                    
      -- ERROR LOG              
      SET @v_log_type = N'ERROR';              
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));              
      SET @v_description = @v_program_name + N'ERROR_LINE : ' + STR(ERROR_LINE());              
      SET @d_event_date = SYSDATETIME();              
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name              
                                ,@p_log_type      =@v_log_type              
                                ,@p_log_count     =@n_log_count               
                                ,@p_log_message   =@v_log_message               
                                ,@p_description   =@v_description               
                                ,@p_event_date    =@d_event_date               
                                ,@p_user_id       =@v_batch_user              
                                ;              
--      PRINT @@ERROR              
      return -1              
    END CATCH;              
              
          
         -- 임시 운영반영시에 주석처리 할것.          
    -- SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +                   
    --                      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))             
          
          
    -- 종료 LOG              
    SET @v_log_type = N'END';              
    SET @v_log_message = N'########## END of procedure ##########';              
    SET @v_description = N'';              
--    SET @v_description = N'['+@p_engine_plan_id+'][' + @v_exec_time + ']';            
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
        
      
    
  

