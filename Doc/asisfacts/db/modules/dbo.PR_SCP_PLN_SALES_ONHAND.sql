
  
/*  
 * Program ID   : PR_SCP_PLN_SALES_ONHAND    
 * Description  : PR_SCP_PLN_CREATE_DATA 에서 호출함.  
 * OutTable     :  
 * Execute      : 
 EXEC PR_SCP_PLN_SALES_ONHAND    @p_plan_cycle          ='WEEKLY'
                              , @p_plan_start_yyyymmdd ='20180618'   
                              , @p_plan_id             ='1031'   
                              , @p_modeling_id         ='2'          
                              , @p_seq                 ='7'
                              , @p_plan_type           ='PR'    
                              , @p_master_id           ='81::WEEKLY' 
                              , @p_division_id         ='81'     
                              , @p_engine_plan_id      ='1031::PR::7'
                              , @p_user_id             = 'KTH'
 * Program History  
 *===================================================================================================  
 *   Date       In Charge      Description  
 *===================================================================================================  
 * 2018.03.15  KTH         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트  
 * 2018.03.27  YYDOK       SALES PSI 첫째날 BOH에 INT수량반영되는 문제해결 쿼리수정 및 해당 쿼리 코멘트처리  
 * 2018.05.14  KTH         FN_GET_ITEM_OPERATION_GROUP --> JOIN으로 변경  
 * 2018.06.07  KTH         TRANSACTION 삭제  
 * 2018.06.27  KTH         전극 SCP 반영(ORIGIN_DIVISION_ID,ELECTRODE_TYPE) 추가
 * 2018.07.04  KTH         SCP_MST_FINAL_ITEM_V로 변경
 * 2018.07.11  KTH         SITE_TYPE   = 'PLANT' 주석 처리
 * 2022.03.22  KSW         JV GM 반영
 * 2023.03.31  HRK		   PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 */   
  
   
CREATE PROCEDURE [dbo].[PR_SCP_PLN_SALES_ONHAND]  
    (   
      @p_plan_cycle           NVARCHAR(150)    
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
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_PLN_SALES_ONHAND';  
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...  
    DECLARE @n_log_count    INTEGER = 0;  
    DECLARE @v_log_message  NVARCHAR(1000);  
    DECLARE @v_description  NVARCHAR(500);       
    DECLARE @v_table_id     NVARCHAR(150) = N'SCM_SYS_LOG_BATC';   
    DECLARE @d_event_date   DATETIME;      
  
  
  -- 시작 LOG  
      
    SET @v_log_type = N'START';  
    SET @v_log_message = N'########## Start of procedure ##########';  
    SET @v_description = @v_program_name + ':' + N' SCP_PLN_SALES_ONHAND INSERT LOGIC';  
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
            /*  
             -- 52주 ITEM_ID 기준 임시테이블 생성  
             -- DECLARE @p_plan_start_yyyymmdd NVARCHAR(8) ='20180312'  
              IF OBJECT_ID('tempdb..#CALENDAR_DT') IS NOT NULL  
              DROP TABLE #CALENDAR_DT  
  
             SELECT A.BASIS_YYYYMMDD AS DT  
               INTO #CALENDAR_DT   
               FROM SCM_SYS_CALENDAR_M A WITH(NOLOCK)   
              WHERE 1=1  
                AND BASIS_YYYYMMDD >= CONVERT(CHAR(8),@p_plan_start_yyyymmdd ,112)  
                AND BASIS_YYYYMMDD < CONVERT(CHAR(8),DATEADD(DD,52*7,@p_plan_start_yyyymmdd),112)  
            */  
  
             
            -------------------------------------------------------------------------------------------------------------------------------------------  
            -- 1 CATEGORY 구분에 따라 BOH/IN/OUT/EOH  
            -------------------------------------------------------------------------------------------------------------------------------------------   
  
            DELETE FROM SCP_PLN_SALES_ONHAND    
                  WHERE DIVISION_ID = @p_division_id AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND PLAN_TYPE = @p_plan_type AND SEQ = @p_seq  
              
            INSERT INTO dbo.SCP_PLN_SALES_ONHAND(  
              MASTER_ID  
              ,PLAN_ID  
              ,OUT_VERSION_ID  
              ,DIVISION_ID  
              ,PLAN_START_YYYYMMDD  
              ,PLAN_TYPE  
              ,SEQ  
              ,OPERATION_GROUP  
              ,ITEM_ID  
              ,SITE_ID  
              ,YYYYMMDD  
              ,ORIGIN_DIVISION_ID
              ,ELECTRODE_TYPE
              ,PSI_BOH_QTY  
              ,PSI_IN_QTY  
              ,PSI_OUT_QTY  
              ,PSI_EOH_QTY  
              ,CREATED_BY  
              ,CREATION_DATE  
              ,LAST_UPDATED_BY  
              ,LAST_UPDATE_DATE  
            )              
              
            SELECT   
               MASTER_ID       
              ,PLAN_ID         
              ,OUT_VERSION_ID  
              ,DIVISION_ID  
              ,PLAN_NAME      AS PLAN_START_YYYYMMDD  
              ,PLAN_TYPE  
              ,SEQ  
              ,OPERATION_GROUP  
              ,ITEM_ID  
              ,SITE_ID  
              ,YYYYMMDD  
              ,ORIGIN_DIVISION_ID
              ,ELECTRODE_TYPE
              ,[BOH]          AS PSI_BOH_QTY  
              ,[IN]           AS PSI_IN_QTY  
              ,[OUT]          AS PSI_OUT_QTY  
              ,[EOH]          AS PSI_EOH_QTY  
              ,@v_batch_user  AS CREATED_BY  
              ,GETDATE()      AS CREATION_DATE  
              ,@v_batch_user  AS LAST_UPDATED_BY  
              ,GETDATE()      AS LAST_UPDATED_DATE  
              FROM  
              (  
                SELECT  A.MASTER_ID  
                      , A.PLAN_ID  
                      , A.OUT_VERSION_ID  
                      , A.DIVISION_ID  
                      , A.PLAN_NAME  
                      , A.PLAN_TYPE  
                      , A.SEQ  
                      , B.OPERATION_GROUP AS   OPERATION_GROUP  
                      , A.ITEM_ID  
                      , SUBSTRING(A.SITE_ID,1,(CASE WHEN CHARINDEX('~', A.SITE_ID) = 0  THEN LEN(A.SITE_ID) ELSE CHARINDEX('~', A.SITE_ID)  -1 END))  AS SITE_ID  
                      , CONVERT(NVARCHAR(8), A.START_DATE,112) AS YYYYMMDD  
                      , Y.DIVISION_ID   AS ORIGIN_DIVISION_ID
                      , B.ELECTRODE_TYPE
                      , A.CATEGORY   
                      , A.QTY  
                  FROM SCP_ENG_SALES_PSI_O_SN A          WITH (NOLOCK) 
					   INNER JOIN SCM_MST_DIVISION AS DM WITH(NOLOCK)  -- 2023.03.31 HM JV 가상 사업부 추가 대응
							   ON DM.DIVISION_ID = A.DIVISION_ID 
							  AND DM.VALID_YN	 = 'Y'
                  INNER JOIN DBO.SCP_MST_FINAL_ITEM_V B  WITH (NOLOCK)         
                          ON  A.ITEM_ID          = B.ITEM_ID   
                   --LEFT OUTER JOIN DBO.SCM_MST_SITE Y  WITH (NOLOCK)       -- to   SITE_ID
                   LEFT OUTER JOIN (SELECT MIN(DIVISION_ID) DIVISION_ID, SCM_SITE_ID, VALID_YN
				                    FROM   DBO.SCM_MST_SITE  WITH (NOLOCK)       -- to   SITE_ID
									WHERE  valid_yn = 'Y'
									GROUP BY SCM_SITE_ID, VALID_YN
								   ) Y
                                ON 0 = 0 
--                          AND Y.SITE_TYPE   = 'PLANT'   
                          -- 2023.03.31 HM JV AND (CASE WHEN A.DIVISION_ID IN ('EE', 'EE_UC') THEN '0' ELSE A.DIVISION_ID END ) = (CASE WHEN A.DIVISION_ID IN ('EE', 'EE_UC') THEN '0' ELSE Y.DIVISION_ID END )		-- 2022.03.22 JV GM 반영 EE_UC 추가 - 0 --> '0' 변경
						  AND Y.DIVISION_ID = CASE WHEN DM.ATTRIBUTE3 = 'EE' -- 2023.03.31 HM JV 가상 사업부 추가 대응
												   THEN Y.DIVISION_ID
												   ELSE A.DIVISION_ID
											  END 
                          AND Y.SCM_SITE_ID  = REPLACE(SUBSTRING(A.SITE_ID,1,(CASE WHEN CHARINDEX('~', A.SITE_ID) = 0  THEN LEN(A.SITE_ID) ELSE CHARINDEX('~', A.SITE_ID)  -1 END)),'-S','') 
                          AND Y.VALID_YN ='Y'   
                  WHERE 0 = 0  
                    AND A.MASTER_ID        = @p_master_id            
                    AND A.PLAN_ID          = @p_plan_id              
                    AND A.PLAN_TYPE        = @p_plan_type            
                    AND A.OUT_VERSION_ID   = @p_engine_plan_id       
                    AND A.PLAN_NAME        = @p_plan_start_yyyymmdd  
                    AND A.DIVISION_ID      = @p_division_id          
                    AND A.SEQ              = @p_seq                  
                
              ) AS SourceTable   
              PIVOT  
              (  
                SUM(QTY)  
                FOR CATEGORY IN ([BOH],[IN],[OUT],[EOH])  
              ) AS PivotTable  
--              order by YYYYMMDD              
  
        --  SALES PSI의 첫째날 BOH에 INT수량이 반영되는 문제를 티라에서 보완하기로   
        --  하였음. 로직 코멘트 처리함. YYDOK 2018.03.27  
          
/*          
        -- ENGINE OUTPUT SALES PSI에 첫째날 BOH에 INT재고가 반영되는 문제를 IN 수량으로 반영하고자   
        -- 데이타를 보정.  
        UPDATE X  
          SET  X.BOH  = X.BOH  - Z.QTY  
              ,X.[IN] = X.[IN] + Z.QTY  
          --SELECT X.YYYYMMDD, Z.YYYYMMDD, X.BOH, X.[IN], X.BOH- Z.QTY, X.[IN] + Z.QTY, *  
          FROM SCP_PLN_SALES_ONHAND X  
          INNER JOIN   
          (  
                  SELECT  Y.MASTER_ID, Y.PLAN_ID, Y.ITEM_ID  
                        , SUBSTRING(Y.SITE_ID, 1, CHARINDEX('~',Y.SITE_ID)-1) AS SITE_ID  
                        , CONVERT(NVARCHAR(8), Y.RECEIVING_DTTM,112) AS YYYYMMDD, SUM(QTY) AS QTY  
                     FROM TH_ENG_STOCK_PLAN_SN Y WITH (NOLOCK)   
                    WHERE DESCR = 'INT'  
                 GROUP BY Y.MASTER_ID, Y.PLAN_ID, Y.ITEM_ID  
                        , SUBSTRING(Y.SITE_ID, 1, CHARINDEX('~',Y.SITE_ID)-1)  
                        , CONVERT(NVARCHAR(8), Y.RECEIVING_DTTM,112)   
          ) Z  
            ON  0 = 0   
            AND X.MASTER_ID             = Z.MASTER_ID  
--            AND X.PLAN_ID               = Z.PLAN_ID               -- '1017::PR::13'  
            AND X.PLAN_ID               = @p_plan_id               -- '1017'  
            AND Z.PLAN_ID               = @p_engine_plan_id        -- '1017::PR::13'  
            AND X.YYYYMMDD              = Z.YYYYMMDD  
            AND X.ITEM_ID               = Z.ITEM_ID               -- 'ACEN1021U-A1'  
            AND X.SITE_ID               = Z.SITE_ID               -- 'Ford_US_RDF~DDP'  
          WHERE 0 = 0  
            AND X.MASTER_ID             = @p_master_id            -- '81::WEEKLY'  
            AND X.PLAN_ID               = @p_plan_id              -- '1018'  
--            AND X.OUT_VERSION_ID        = @p_plan_id              -- '1017::PR::13'  
            AND X.PLAN_START_YYYYMMDD   = @p_plan_start_yyyymmdd  -- '2018031'  
            AND X.PLAN_TYPE             = @p_plan_type            -- 'PR'  
            AND X.DIVISION_ID           = @p_division_id          -- '81'  
            AND X.SEQ                   = @p_seq                  -- '11'  
            AND X.YYYYMMDD              = Z.YYYYMMDD  
            AND X.BOH                   > 0;  
  
*/  
  
        -----------------------------------------------------------  
        -- 실행 Logic END --  
        -----------------------------------------------------------  
        --IF @@TRANCOUNT > 0  
        --  BEGIN  
        --    COMMIT TRAN T1;  
        --  END;         
  
  
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
     --SET @v_exec_time  =  REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +   
     --                     REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))   
  
  
    -- 종료 LOG  
    SET @v_log_type = N'END';  
    SET @v_log_message = N'########## END of procedure ##########';  
    SET @v_description = N'['+@p_engine_plan_id+']'--[' + @v_exec_time + ']';    
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
  
  

