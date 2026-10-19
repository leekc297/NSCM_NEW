
  
/*      
 * Program ID   : PR_SCP_XLS_BOH        
 * Description  : PR_SCP_PLN_CREATE_DATA 에서 호출함.      
 * OutTable     :      
 * Execute      : 
    -- DELETE FROM SCM_SYS_LOG_BATCH where CREATED_BY ='kth'
    EXEC PR_SCP_XLS_BOH
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
 * 2019.01.08   KTH         Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트  
 * 2019.02.19   KTH         INCOTERMS 추가
 * 2020.04.14   KTH         조건변경 AND S.LOT_ID     LIKE 'WH::%' --> 'WH::%',  
                                    AND CONVERT(VARCHAR,RECEIVING_DTTM,112)  = @start_yyyymmdd --> = @start_yyyymmdd
 * 2020.08.11   KSW         SCM_MST_FINAL_ITEM_V 에서 Nick Name 이 없는 건이 존재함 - DISTINCT 추가
 * 2020.10.27   KSW         2020.08.11 추가된 DISTINCT를 SCM_MST_FINAL_ITEM_V 에 제한적으로 적용하는 것으로 변경 (자동차 TO_SITE_BOH 수량 누락보완)
 * 2021.03.29   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 대체 BOM 적용
 * 2021.09.15   KSW         PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - 전진검사
 * 2021.10.19   KSW         PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 [추가개선] - Pack BOH 수량에서 Hold 수량제외
 * 2024.04.30	   KSK		  81_JV 재고지원
 * 2026.04.20   YMH         E20260417-001923 시뮬레이터 내 BOH 중복 반영 건 FROM_SCM_SITE_ID 반영
 */    


--DROP PROC PR_SCP_XLS_BOH

CREATE PROCEDURE [dbo].[PR_SCP_XLS_BOH]
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
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_XLS_BOH';      
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
              DECLARE @start_yyyymmdd NVARCHAR(8) = CONVERT(VARCHAR,(DATEADD(day, -1, @p_plan_start_yyyymmdd)),112)

              DELETE FROM SCP_XLS_BOH                            
                    WHERE DIVISION_ID = @p_division_id -- AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND PLAN_TYPE = @p_plan_type AND SEQ = @p_seq    

              INSERT INTO SCP_XLS_BOH(
                                        DIVISION_ID
                                        ,PLAN_START_YYYYMMDD
                                        ,PLAN_TYPE
                                        ,SEQ
                                        ,SCM_SITE_ID
                                        ,INCOTERMS
                                        ,ITEM_ID
                                        ,QTY
                                        ,ORIGIN_ITEM_ID
                                        ,ORIGIN_QTY
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
              SELECT  DIVISION_ID
                    , @p_plan_start_yyyymmdd    AS PLAN_START_YYYYMMDD
                    , @p_plan_type              AS PLAN_TYPE
                    , @p_seq                    AS SEQ
                    , SCM_SITE_ID
                    , INCOTERMS
                    , ITEM_ID
                    , QTY
                    , ORIGIN_ITEM_ID
                    , ORIGIN_QTY
                    , @v_batch_user             AS CREATED_BY
                    , GETDATE()                 AS CREATION_DATE
                    , @v_batch_user             AS LAST_UPDATED_BY
                    , GETDATE()                 AS LAST_UPDATE_DATE
                    -- 2026.04.20 YMH E20260417-001923 시뮬레이터 내 BOH 중복 반영 건 FROM_SCM_SITE_ID 반영 기존로직 주석
                    --, NULL                      AS ATTRIBUTE1
                    -- 2026.04.20 YMH E20260417-001923 시뮬레이터 내 BOH 중복 반영 건 FROM_SCM_SITE_ID 반영 attribute1 에 반영.
                    , FROM_SCM_SITE_ID          AS ATTRIBUTE1
                    , NULL                      AS ATTRIBUTE2
                    , NULL                      AS ATTRIBUTE3
                    , NULL                      AS ATTRIBUTE4
                    , NULL                      AS ATTRIBUTE5
                    , NULL                      AS ATTRIBUTE6
                    , NULL                      AS ATTRIBUTE7
                    , NULL                      AS ATTRIBUTE8
                    , NULL                      AS ATTRIBUTE9
                    , DESCR                     AS ATTRIBUTE10			-- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 [추가개선] - Pack BOH 수량에서 Hold 수량제외(HOLD 확인을 위해 추가)
              FROM (
                    SELECT  A.DIVISION_ID,
                            A.SCM_SITE_ID,
                            A.INCOTERMS,
                            B.CHILD_ITEM_ID       AS ITEM_ID,
                            (A.QTY * B.CHILD_QTY) AS QTY,
                            A.ITEM_ID             AS ORIGIN_ITEM_ID,
                            A.QTY                 AS ORIGIN_QTY,
							A.DESCR		          ,  -- Pack BOH 수량에서 Hold 수량제외(HOLD 확인을 위해 추가)
                            A.FROM_SCM_SITE_ID    -- 2026.04.20 YMH E20260417-001923 시뮬레이터 내 BOH 중복 반영 건 FROM_SCM_SITE_ID 반영
                    FROM
                    (
                    SELECT 
                            @p_division_id AS DIVISION_ID
                           ,S.ITEM_ID
--                           ,dbo.FN_SCM_SPLIT(SITE_ID,1,'~') AS SCM_SITE_ID
                           ,SUBSTRING(S.SITE_ID,1,(CASE WHEN CHARINDEX('~', S.SITE_ID) = 0  THEN LEN(S.SITE_ID) ELSE CHARINDEX('~', S.SITE_ID)  -1 END)) AS SCM_SITE_ID
--                           ,SUBSTRING(S.SITE_ID,CHARINDEX('~', S.SITE_ID)+1,(CASE WHEN CHARINDEX('~',S.SITE_ID) = 0  THEN LEN(S.SITE_ID) ELSE CHARINDEX('~', S.SITE_ID)  -1 END)) AS INCOTERMS
                           ,(CASE WHEN T.SITE_TYPE = 'SALES' THEN SUBSTRING(S.SITE_ID,CHARINDEX('~', S.SITE_ID)+1,(CASE WHEN CHARINDEX('~', S.SITE_ID) = 0  THEN LEN(S.SITE_ID) ELSE CHARINDEX('~', S.SITE_ID)  -1 END)) ELSE ''  END)  AS INCOTERMS
                           , QTY        
						   , DESCR		-- Pack BOH 수량에서 Hold 수량제외(HOLD 확인을 위해 추가)
                           , DBO.FN_SCM_SPLIT(S.lot_id ,6,'::') AS FROM_SCM_SITE_ID -- 2026.04.20 YMH E20260417-001923 시뮬레이터 내 BOH 중복 반영 건 FROM_SCM_SITE_ID 반영
                      FROM dbo.SCP_PLN_TH_ENG_STOCK_PLAN S WITH(NOLOCK)
                          ,dbo.SCM_MST_SITE              T WITH(NOLOCK)
                     WHERE 1=1
                       AND S.MASTER_ID      = @p_master_id
                    --   AND S.PLAN_ID      ='1060'
                       AND S.PLAN_ID        = @p_engine_plan_id
                       AND S.LOT_ID       LIKE 'WH%'
                       AND S.ITEM_ID      LIKE 'AMDAU%'
                       AND CONVERT(VARCHAR,S.RECEIVING_DTTM,112) >= @start_yyyymmdd
                       AND dbo.FN_SCM_SPLIT(MASTER_ID,1,'::')   = T.DIVISION_ID
                       AND SUBSTRING(S.SITE_ID,1,(CASE WHEN CHARINDEX('~', S.SITE_ID) = 0  THEN LEN(S.SITE_ID) ELSE CHARINDEX('~', S.SITE_ID)  -1 END))  = T.SCM_SITE_ID
					   AND NOT ISNULL(S.INSP_TYPE, '') IN ('INSP_PRE', 'INSP_HOLD')		-- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - 전진검사
                    ) A,
                    (  SELECT DISTINCT DIVISION_ID,PARENT_ITEM_ID,CHILD_ITEM_ID,CHILD_QTY

					--  2021.03.29   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 대체 BOM 적용 - start
					-- SCM_MST_BOM_SN 에서 뷰로 변경됨
                         --FROM SCM_MST_BOM_SN WITH(NOLOCK)
						 FROM SCM_MST_BOM_SN_V WITH(NOLOCK)
					--  2021.03.29   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 대체 BOM 적용 - end

                        WHERE DIVISION_ID     =    @p_division_id
                          AND PARENT_ITEM_ID LIKE 'AMDAU%'
                          AND CHILD_ITEM_ID  LIKE 'ACE%'
                          AND ALT_PRIORITY    = 'Y'
                        --AND PARENT_ITEM_ID LIKE 'AMDAU0024N'
                      ) B
                    WHERE A.DIVISION_ID = B.DIVISION_ID
                      AND A.ITEM_ID     = B.PARENT_ITEM_ID
                    UNION ALL
                    -- * 2020.10.27   KSW         2020.08.11 추가된 DISTINCT를 SCM_MST_FINAL_ITEM_V 에 제한적으로 적용하는 것으로 변경 (자동차 TO_SITE_BOH 수량 누락보완) 
					--SELECT DISTINCT     -- KSW 2020-08-11 :: SCM_MST_FINAL_ITEM_V 에서 Nick Name 이 없는 건이 존재함 - DISTINCT 추가
					SELECT
                            @p_division_id  AS DIVISION_ID
                           ,SUBSTRING(S.SITE_ID,1,(CASE WHEN CHARINDEX('~', S.SITE_ID) = 0  THEN LEN(S.SITE_ID) ELSE CHARINDEX('~', S.SITE_ID)  -1 END)) AS SCM_SITE_ID
                           ,(CASE WHEN T.SITE_TYPE = 'SALES' THEN SUBSTRING(S.SITE_ID,CHARINDEX('~', S.SITE_ID)+1,(CASE WHEN CHARINDEX('~', S.SITE_ID) = 0  THEN LEN(S.SITE_ID) ELSE CHARINDEX('~', S.SITE_ID)  -1 END)) ELSE ''  END)  
                           ,S.ITEM_ID
                           , QTY      
                           ,NULL            AS ORIGIN_ITEM_ID
                           ,0               AS ORIGIN_QTY     
						   ,S.DESCR		-- Pack BOH 수량에서 Hold 수량제외(HOLD 확인을 위해 추가)
                           , DBO.FN_SCM_SPLIT(S.lot_id ,6,'::') AS FROM_SCM_SITE_ID -- 2026.04.20 YMH E20260417-001923 시뮬레이터 내 BOH 중복 반영 건 FROM_SCM_SITE_ID 반영
                      FROM dbo.SCP_PLN_TH_ENG_STOCK_PLAN  S WITH(NOLOCK)
					       -- * 2020.10.27   KSW         2020.08.11 추가된 DISTINCT를 SCM_MST_FINAL_ITEM_V 에 제한적으로 적용하는 것으로 변경 (자동차 TO_SITE_BOH 수량 누락보완)
                           --,dbo.SCM_MST_FINAL_ITEM_V      F WITH(NOLOCK)
						   ,(SELECT DISTINCT F.DIVISION_ID, F.ITEM_ID from dbo.SCM_MST_FINAL_ITEM_V      F WITH(NOLOCK) ) AS F    -- distinct 대상변경
                           ,dbo.SCM_MST_SITE              T WITH(NOLOCK)
                     WHERE 1=1
                       AND S.MASTER_ID  =   @p_master_id
                       --AND PLAN_ID    =   '1060'
                       AND S.PLAN_ID    =   @p_engine_plan_id
                       AND S.LOT_ID     LIKE 'WH%'
                       AND S.ITEM_ID    NOT LIKE 'AMDAU%'
                       AND CONVERT(VARCHAR,RECEIVING_DTTM,112)  >= @start_yyyymmdd --PLAN_START_YYYYMMDD -1일 
                       AND dbo.FN_SCM_SPLIT(MASTER_ID,1,'::')   = F.DIVISION_ID
                       AND S.ITEM_ID                            = F.ITEM_ID

                       AND dbo.FN_SCM_SPLIT(MASTER_ID,1,'::')   = T.DIVISION_ID
                       AND SUBSTRING(S.SITE_ID,1,(CASE WHEN CHARINDEX('~', S.SITE_ID) = 0  THEN LEN(S.SITE_ID) ELSE CHARINDEX('~', S.SITE_ID)  -1 END))  = T.SCM_SITE_ID
					   AND NOT ISNULL(S.INSP_TYPE, '') IN ('INSP_PRE', 'INSP_HOLD')		-- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - 전진검사
              ) X	;
      
	  --ADD 07/01/2023
-----------------------------------------------------------
-------------------------------------------------------------	  
DECLARE @V_IS_AUTO BIT = 0
SELECT @V_IS_AUTO = dbo.FN_IS_DIVISION( @p_division_id, 'CREATE', '81') 

;WITH VW_UPDATE_DATA AS
                    (
					SELECT A.*
					     , B.ITEM_ID_ASSY
						 , ROW_NUMBER() OVER(PARTITION BY A.DIVISION_ID, A.SCM_SITE_ID, A.ITEM_ID 
						                         ORDER BY B.ITEM_ID_ASSY) AS ROW_SEQ 
					  FROM  SCP_XLS_BOH A
					  JOIN SCP_MST_CELL_PROD_ASSY_MAP B WITH(NOLOCK)
						ON B.ITEM_ID_PROD = A.ITEM_ID
					   AND B.PLANT_ID+'-A' = A.SCM_SITE_ID
					WHERE A.DIVISION_ID = @p_division_id
					 --JV 재고 지원
					  AND ( A.DIVISION_ID = '82' or @V_IS_AUTO  = 1)
					  AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
					  AND A.PLAN_TYPE = @p_plan_type
					  AND A.SEQ       = @p_seq
					 )
UPDATE A
   SET A.ITEM_ID = B.ITEM_ID_ASSY
FROM SCP_XLS_BOH A
JOIN (SELECT B.* FROM VW_UPDATE_DATA B WHERE B.ROW_SEQ = 1) B
  ON A.SCM_SITE_ID = B.SCM_SITE_ID
  AND A.ITEM_ID    = B.ITEM_ID
WHERE A.DIVISION_ID = @p_division_id
   --JV 재고 지원
  AND ( A.DIVISION_ID = '82' or @V_IS_AUTO  = 1)
  AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
  AND A.PLAN_TYPE = @p_plan_type
  AND A.SEQ       = @p_seq
; 
-----------------------------------------------------------
-------------------------------------------------------------


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
  
