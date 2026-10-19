        
          
/*          
 * Program ID   : PR_SCP_PLN_PLANT_ONHAND            
 * Description  : PR_SCP_PLN_CREATE_DATA 에서 호출함.          
 * OutTable     :          
 * Execute      :   EXEC PR_SCP_PLN_PLANT_ONHAND   @p_plan_cycle          ='WEEKLY'  
                                                 , @p_plan_start_yyyymmdd ='20180528'     
                                                 , @p_plan_id             ='1028'     
                                                 , @p_modeling_id         ='2'            
                                                 , @p_seq                 ='2'  
                                                 , @p_plan_type           ='PR'      
                                                 , @p_master_id           ='81::WEEKLY'   
                                                 , @p_division_id         ='81'       
                                                 , @p_engine_plan_id      ='1028::PR::2'        
 * Program History          
 *===================================================================================================          
 *   Date       In Charge      Description          
 *===================================================================================================          
 * 2018.03.09   KTH         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트          
 * 2018.03.27   YYDOK       특성완료 -> 특성완료계획수량이 아니라, 특성완료 재고수량으로 변경.          
 *                          활성화 완료 GROUP BY추가          
 * 2018.04.09   YYDOK       ELEC,CELL ~003 SITE추가에 따른 수정        
 * 2018.04.30   YYDOK       ENGINE INPUT STOCKPLAN의 FOR활성화완료예정수량에 대하여 활성화진행중정보를 생성      
 *                          ( FOR_STOCKPLAN )      
 * 2018.05.18   KTH         OPERATION_GROUP 함수에서 SCM_MST_FINAL_ITEM_V로 변경    
 * 2018.05.23   KTH         ASSM 조회 조건 변경   
 * 2018.05.29   KTH         활성화진행중 HOLD재고 누락개선 ('FOR::%'에서  'FOR%' 로 변경)   
 * 2018.05.30   KTH         전체로직 변경(속도 개선)  
 * 2018.06.11   YYDOK       STOCK_TYPE '-' 비대상제외 WHERE조건에 추가  
 * 2018.06.12   KTH         TRANSACTION 삭제, 주석정리, GROUP BY 절 수정  
 * 2018.06.27   KTH         전극 SCP 반영(ORIGIN_DIVISION_ID,ELECTRODE_TYPE) 추가
 * 2018.07.04   KTH         SCP_MST_FINAL_ITEM_V로 변경
 * 2018.07.10   KTH         SCP_ENG_PRODUCTION_PSI_O_TEMP_SN,SCP_ENG_DELIVERY_O_TEMP_SN 반영
 * 2018.07.17   KTH         P_OUT_WH(출하창고),P_MOVE_WH(BOH,EOH)(출하창고이전)
 * 2018.08.28   KTH         TCO_CELL 조건반영 
                                  COAT : OPERATION_GROUP ='E'   AND OSP_YN ='Y' 
                                  CHAR : OPERATION_GROUP ='A'   AND OSP_YN ='Y' 
                                  PACK : OPERATION_GROUP ='P'   AND OSP_YN ='Y' 
 * 2018.11.09   YYDOK       A_PACK (팩공장의 셀) BOH 생성로직 추가
 * 2021.07.20   KSW         일부 활성화 수량에 대한 불일치를 해결하기 위해서 TH_ENG_STOCK_PLAN_SN -> SCP_PLN_TH_ENG_STOCK_PLAN 으로 변경
 * 2021.11.11   sclee.lee   튜닝 개선안에 근거한 처리 로직 변경
 */  
         
CREATE PROCEDURE [dbo].[PR_SCP_PLN_PLANT_ONHAND]          
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
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_PLN_PLANT_ONHAND';            
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...            
    DECLARE @n_log_count    INTEGER = 0;            
    DECLARE @v_log_message  NVARCHAR(1000);            
    DECLARE @v_description  NVARCHAR(500);      --  상세설명             
    DECLARE @v_table_id     NVARCHAR(150) = N'SCP_PLN_PLANT_ONHAND'; --  테이블 필수            
    DECLARE @d_event_date   DATETIME;

	/* INSERT, DELETE시 걸리는 시간관련 변수 (20211111) */
    DECLARE @v_del_start    DATETIME;
    DECLARE @v_del_end      DATETIME;
    DECLARE @v_loop         INT = 0;
            
  -- 시작 LOG            
    SET @v_log_type = N'START';            
    SET @v_log_message = N'########## Start of procedure ##########';            
    SET @v_description = @v_program_name + ':' + N' SCP_PLN_PLANT_ONHAND INSERT LOGIC';            
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
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();    
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';    
                
            
    BEGIN TRY         
      BEGIN
            /* 튜닝 개선안에 근거한 처리 로직 변경 (20211111) */
            --PRINT('1 : ' + FORMAT(GETDATE(), 'yyyyMMdd HH:mm:ss'));
            -------------------------------------------------------------------------------------------------------------------------------------------     
            -- 0. 임시 테이블 생성     
            -- #CALENDAR_DT               : 달력    -- 활성화진행중 PSI데이타 생성을 위하여 BUCKET CALENDAR 적재            
            -- #tmp_SCP_PLN_PLANT_ONHAND  : SCP_ENG_PRODUCTION_PSI_O,TH_ENG_STOCK_PLAN_SN, SCP_ENG_DELIVERY_O 데이터가 입력 되는 temp 테이블    
            -------------------------------------------------------------------------------------------------------------------------------------------     
              IF OBJECT_ID('tempdb..#CALENDAR_DT') IS NOT NULL            
               DROP TABLE #CALENDAR_DT            
               -- ENGINE INPUT BUCKET(DAILY 16WEEKS,AFTER PARTIAL WEEK            
                  SELECT CONVERT(VARCHAR(8),START_DTTM,112) AS DT            
                   INTO #CALENDAR_DT            
                   FROM TH_ENG_BUCKET_INFO_SN WITH(NOLOCK)            
                  WHERE PLAN_ID       = @p_engine_plan_id --'1020::PR::1'           
                    AND MASTER_ID     = @p_master_id        
                ;              
                  
              IF OBJECT_ID('tempdb..#tmp_SCP_PLN_PLANT_ONHAND') IS NOT NULL            
                DROP TABLE #tmp_SCP_PLN_PLANT_ONHAND    
                    
                CREATE TABLE #tmp_SCP_PLN_PLANT_ONHAND    
                (    
                 --MASTER_ID           nvarchar(50) NOT NULL,    
                 --PLAN_ID             nvarchar(30) NOT NULL,    
                 --OUT_VERSION_ID      nvarchar(30) NOT NULL,    
                 --DIVISION_ID         nvarchar(30) NOT NULL,    
                 --PLAN_START_YYYYMMDD nvarchar(8) NOT NULL,    
                 --PLAN_TYPE           nvarchar(50) NOT NULL,    
                 --SEQ                 bigint NOT NULL,    
  
                 OPERATION_GROUP      nvarchar(10)    NOT NULL,    
                 ITEM_ID              nvarchar(50)    NOT NULL,    
                 SITE_ID              nvarchar(30)    NOT NULL,     
                 YYYYMMDD             nvarchar(8)     NOT NULL,    
                 STOCK_TYPE           nvarchar(50)    NOT NULL,    
                 ORIGIN_DIVISION_ID   nvarchar(30)    NULL,     
                 ELECTRODE_TYPE       nvarchar(30)    NULL,     
                 CATEGORY             nvarchar(50)    NOT NULL,    
                 QTY                  numeric(20, 10) NULL,    
                )        
                       
            
            -------------------------------------------------------------------------------------------------------------------------------------------     
            --  1. SCP_ENG_PRODUCTION_PSI_O_SN 추출    
            -------------------------------------------------------------------------------------------------------------------------------------------     
            --  1.1.COAT     : 전극 COATING완료  'COAT'     /CATEGORY/QTY  : AND B.OPERATION_GROUP ='E'  AND A.SITE_ID like '%***'      
            --  1.2.SLIT     : 전극 SLIT완료     'SLIT'     /CATEGORY/QTY  : AND B.OPERATION_GROUP ='E'  AND A.SITE_ID like '%002'      
            --  1.3.OUT_WH   : 전극 출하창고     'E_OUT_WH'  /CATEGORY/QTY  : AND B.OPERATION_GROUP ='E'  AND A.SITE_ID like '%003'     
            --  1.4.ASSM     : ASSM            'ASSM'      /CATEGORY/QTY  : AND B.OPERATION_GROUP ='A'  AND A.SITE_ID like '%-A~***'      
            --  1.5.CHAR     : 특성완료 A~002    'CHAR'     /CATEGORY/QTY  : AND B.OPERATION_GROUP ='A'   AND A.SITE_ID like '%002'     
            --  1.6.A_OUT_WH : 출하창고 A~003    'A_OUT_WH' /CATEGORY/QTY  : AND B.OPERATION_GROUP ='A'   AND A.SITE_ID like '%003'       
            --  1.7.A_PACK   : 팩공장의 셀       'A_PACK'    /CATEGORY/QTY  : AND B.OPERATION_GROUP ='A'  AND A.SITE_ID like '%-P~***'                   
            --  1.8.팩                          'PACK'     /CATEGORY/QTY  : AND B.OPERATION_GROUP ='P'        
            --  1.9 P_OUT_WH : 출하창고 P~003    'P_OUT_WH' /CATEGORY/QTY  : AND B.OPERATION_GROUP ='P'   AND A.SITE_ID like '%003'  

            --  외주 전극업체:                    'COAT' /CATEGORY/QTY  : AND B.OPERATION_GROUP ='E'   AND A.OSP_YN ='Y'
            --  외주 CELLER  :                    'CHAR' /CATEGORY/QTY  : AND B.OPERATION_GROUP ='A'   AND A.OSP_YN ='Y'
            --  외주PACKER   :  팩공장의 셀/TCO셀  'A_PACK' /CATEGORY/QTY  : AND B.OPERATION_GROUP ='A'   AND A.OSP_YN ='Y' AND A.SITE_ID like '%-P~***'          
            --  외주PACKER   :                    'PACK' /CATEGORY/QTY  : AND B.OPERATION_GROUP ='P'   AND A.OSP_YN ='Y'
            -------------------------------------------------------------------------------------------------------------------------------------------     
                INSERT INTO #tmp_SCP_PLN_PLANT_ONHAND  
                (  
                  OPERATION_GROUP,  
                  ITEM_ID,  
                  SITE_ID,  
                  YYYYMMDD,  
                  STOCK_TYPE,  
                  CATEGORY,  
                  QTY,  
--                  ORIGIN_DIVISION_ID,  
                  ELECTRODE_TYPE
                )    
                SELECT A.OPERATION_GROUP AS  OPERATION_GROUP     
                      ,A.ITEM_ID            
                      ,A.SCM_SITE_ID     AS  SITE_ID
                      ,CONVERT(NVARCHAR(8), A.START_DATE,112) AS YYYYMMDD            
                      ,(CASE WHEN (A.OPERATION_GROUP ='E'  AND A.ATTRIBUTE5  = 'N'  AND A.SITE_ID like '%***')        THEN 'COAT'     
                             WHEN (A.OPERATION_GROUP ='E'  AND A.ATTRIBUTE5  = 'N'  AND A.SITE_ID like '%002')        THEN 'SLIT'    
                             WHEN (A.OPERATION_GROUP ='E'  AND A.ATTRIBUTE5  = 'N'  AND A.SITE_ID like '%003')        THEN 'E_OUT_WH'     
                             WHEN (A.OPERATION_GROUP ='A'  AND A.ATTRIBUTE5  = 'N'  AND A.SITE_ID like '%-A~***')     THEN 'ASSM'       
                             WHEN (A.OPERATION_GROUP ='A'  AND A.ATTRIBUTE5  = 'N'  AND A.SITE_ID like '%002'  )      THEN 'CHAR'    
                             WHEN (A.OPERATION_GROUP ='A'  AND A.ATTRIBUTE5  = 'N'  AND A.SITE_ID like '%003'  )      THEN 'A_OUT_WH'   
                             WHEN (A.OPERATION_GROUP ='A'  AND A.ATTRIBUTE5  = 'N'  AND A.SITE_ID like '%-P~%')       THEN 'A_PACK'                                     
                             WHEN (A.OPERATION_GROUP ='P'  AND A.ATTRIBUTE5  = 'N'  AND A.SITE_ID like '%003'  )      THEN 'P_OUT_WH' 
                             WHEN (A.OPERATION_GROUP ='P'  AND A.ATTRIBUTE5  = 'N'  )                                 THEN 'PACK'                          

                             WHEN (A.OPERATION_GROUP ='E'  AND A.ATTRIBUTE5  = 'Y')  THEN 'COAT'
                             WHEN (A.OPERATION_GROUP ='A'  AND A.ATTRIBUTE5  = 'Y'  AND A.SITE_ID like '%-A~***')     THEN 'CHAR'
                             WHEN (A.OPERATION_GROUP ='A'  AND A.ATTRIBUTE5  = 'Y'  AND A.SITE_ID like '%-P~***')     THEN 'A_PACK'
                             WHEN (A.OPERATION_GROUP ='P'  AND A.ATTRIBUTE5  = 'Y')  THEN 'PACK'

                        ELSE '-' END) AS STOCK_TYPE     
                      ,A.CATEGORY             
                      ,ISNULL(A.QTY,0) AS QTY    
                      ,A.ELECTRODE_TYPE      
                 FROM SCP_ENG_PRODUCTION_PSI_O_TEMP_SN A WITH (NOLOCK)         
                WHERE 0 = 0            
                  AND A.MASTER_ID        = @p_master_id            -- '81::WEEKLY'            
                  AND A.PLAN_ID          = @p_plan_id              -- '1020'            
                  AND A.PLAN_TYPE        = @p_plan_type            -- 'PR'            
                  AND A.PLAN_NAME        = @p_plan_start_yyyymmdd  -- '20180402'            
                  AND A.DIVISION_ID      = @p_division_id          -- '81'            
                  AND A.SEQ              = @p_seq                  -- '11'            
                  AND ( (A.OPERATION_GROUP ='E' AND A.ATTRIBUTE5  = 'N'  AND A.SITE_ID like '%***')        OR    
                        (A.OPERATION_GROUP ='E' AND A.ATTRIBUTE5  = 'N'  AND A.SITE_ID like '%002')        OR    
                        (A.OPERATION_GROUP ='E' AND A.ATTRIBUTE5  = 'N'  AND A.SITE_ID like '%003')        OR    
                        (A.OPERATION_GROUP ='A' AND A.ATTRIBUTE5  = 'N'  AND A.SITE_ID like '%-A~***')     OR    
                        (A.OPERATION_GROUP ='A' AND A.ATTRIBUTE5  = 'N'  AND A.SITE_ID like '%002'  )      OR    
                        (A.OPERATION_GROUP ='A' AND A.ATTRIBUTE5  = 'N'  AND A.SITE_ID like '%003'  )      OR 
                        (A.OPERATION_GROUP ='A' AND A.ATTRIBUTE5  = 'N'  AND A.SITE_ID like '%-P~%')       OR   
                        (A.OPERATION_GROUP ='P' AND A.ATTRIBUTE5  = 'N'  AND A.SITE_ID like '%003'  )      OR    
                        (A.OPERATION_GROUP ='P' AND A.ATTRIBUTE5  = 'N'  )                                 OR
                        (A.OPERATION_GROUP ='E' AND A.ATTRIBUTE5  = 'Y')                                   OR
                        (A.OPERATION_GROUP ='A' AND A.ATTRIBUTE5  = 'Y'  AND A.SITE_ID like '%-A~***')     OR
                        (A.OPERATION_GROUP ='A' AND A.ATTRIBUTE5  = 'Y'  AND A.SITE_ID like '%-P~***')     OR
                        (A.OPERATION_GROUP ='P' AND A.ATTRIBUTE5  = 'Y')                                    
                       )      
            -------------------------------------------------------------------------------------------------------------------------------------------     
            --  1.8. FORMED              'FORMED'/CATEGORY/SUM(ISNULL(A.QTY,0)) : AND B.OPERATION_GROUP ='A' AND A.SITE_ID like '%A~001'    
            -------------------------------------------------------------------------------------------------------------------------------------------     
                UNION ALL    
                SELECT A.OPERATION_GROUP      AS OPERATION_GROUP         
                      ,A.ITEM_ID              
                      ,A.SCM_SITE_ID              
                      ,CONVERT(NVARCHAR(8), A.START_DATE,112) AS YYYYMMDD              
                      ,'FORMED' AS STOCK_TYPE              
                      ,A.CATEGORY               
                      ,SUM(ISNULL(A.QTY,0)) AS QTY     
                      ,A.ELECTRODE_TYPE  
              FROM SCP_ENG_PRODUCTION_PSI_O_TEMP_SN A WITH (NOLOCK)               
                WHERE 0 = 0              
                   AND A.MASTER_ID        = @p_master_id            -- '81::WEEKLY'          
                   AND A.PLAN_ID          = @p_plan_id              -- '1020'              
                   AND A.PLAN_TYPE        = @p_plan_type            -- 'PR'              
                   AND A.PLAN_NAME        = @p_plan_start_yyyymmdd  -- '20180402'              
                   AND A.DIVISION_ID      = @p_division_id          -- '81'              
                   AND A.SEQ              = @p_seq                  -- '11'              
                   AND A.OPERATION_GROUP ='A'              
                   AND A.SITE_ID          like '%A~001'               
                GROUP BY A.OPERATION_GROUP              
                        ,A.ITEM_ID              
                        ,A.SCM_SITE_ID              
                        ,CONVERT(NVARCHAR(8), A.START_DATE,112)              
                        ,A.CATEGORY  
                        ,A.ELECTRODE_TYPE   
            -------------------------------------------------------------------------------------------------------------------------------------------     
            --  2. TH_ENG_STOCK_PLAN_SN 추출    
            -------------------------------------------------------------------------------------------------------------------------------------------     
            --  2.1 FOR_STOCKPLAN: 셀 활성화완료예정수량(EOH)  'A' / 'FOR_STOCKPLAN' /'EOH'/    : AND A.SITE_ID    LIKE  '%A~001'     AND A.LOT_ID     LIKE  'FOR%'     
            -------------------------------------------------------------------------------------------------------------------------------------------     
                INSERT INTO #tmp_SCP_PLN_PLANT_ONHAND  
                (  
                  OPERATION_GROUP,  
                  ITEM_ID,  
                  SITE_ID,  
                  YYYYMMDD,  
                  STOCK_TYPE,  
                  CATEGORY,  
                  QTY,  
--                  ORIGIN_DIVISION_ID,  
                  ELECTRODE_TYPE
                )                      
                SELECT      
                      'A'        AS OPERATION_GROUP           
                      ,A.ITEM_ID            
                      ,SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1) AS SCM_SITE_ID            
                      ,B.DT AS YYYYMMDD            
                      ,'FOR_STOCKPLAN' AS STOCK_TYPE            
                      ,'EOH' AS CATEGORY            
                      , sum(           
                            ISNULL(           
                               (case when (CONVERT(VARCHAR(8),A.RECEIVING_DTTM,112) > B.DT ) then QTY              
                                    else 0            
                               end), 0          
                                  )                   
                            )  EOH_QTY   
                      , NULL AS ELECTRODE_TYPE           
                 FROM SCP_PLN_TH_ENG_STOCK_PLAN A WITH(NOLOCK)        -- 2021.07.20   KSW         일부 활성화 수량에 대한 불일치를 해결하기 위해서 TH_ENG_STOCK_PLAN_SN -> SCP_PLN_TH_ENG_STOCK_PLAN 으로 변경  
                 RIGHT OUTER JOIN #CALENDAR_DT B             
                               ON 0 = 0            
                 WHERE 0 = 0            
                     AND A.MASTER_ID        = @p_master_id     --'81::WEEKLY'        
                     AND A.PLAN_ID          = @p_engine_plan_id--'1024::PR::3'        
                     AND A.SITE_ID         LIKE  '%A~001'            
                     AND A.LOT_ID          LIKE  'FOR%'        
                GROUP BY             
                      A.ITEM_ID            
                     ,SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)            
                     ,B.DT      
                    
            -------------------------------------------------------------------------------------------------------------------------------------------     
            --  2.2.FOR_STOCKPLAN: 셀 활성화완료예정수량(BOH)    'A' / 'FOR_STOCKPLAN' /'BOH'/    : AND A.SITE_ID    LIKE  '%A~001'        AND A.LOT_ID     LIKE  'FOR%'     
            -------------------------------------------------------------------------------------------------------------------------------------------          
                UNION ALL                    
                SELECT      
                      'A'        AS OPERATION_GROUP           
                      ,A.ITEM_ID            
                      ,SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1) AS SCM_SITE_ID            
                      ,B.DT AS YYYYMMDD            
                      ,'FOR_STOCKPLAN' AS STOCK_TYPE            
                      ,'BOH' AS CATEGORY            
                      , sum(           
                            ISNULL(           
                               (case when (CONVERT(VARCHAR(8),A.RECEIVING_DTTM,112) >= B.DT ) then QTY              
                                    else 0            
                                end), 0          
                                  )                   
                            )  BOH_QTY        
                      , NULL AS ELECTRODE_TYPE
                 FROM SCP_PLN_TH_ENG_STOCK_PLAN A WITH(NOLOCK)          -- 2021.07.20   KSW         일부 활성화 수량에 대한 불일치를 해결하기 위해서 TH_ENG_STOCK_PLAN_SN -> SCP_PLN_TH_ENG_STOCK_PLAN 으로 변경
                 RIGHT OUTER JOIN #CALENDAR_DT B             
                               ON 0 = 0            
                 WHERE 0 = 0            
                     AND A.MASTER_ID        = @p_master_id     --'81::WEEKLY'        
                     AND A.PLAN_ID          = @p_engine_plan_id--'1024::PR::3'        
                     AND A.SITE_ID        LIKE  '%A~001'            
                     AND A.LOT_ID         LIKE  'FOR%'        
                GROUP BY             
                      A.ITEM_ID            
                     ,SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)            
                     ,B.DT      

            ------------------------------------------------------------------------------------------------------------------------------------------- START
			-- 2021.11.03 튜닝개선안에 따른 변경
			-------------------------------------------------------------------------------------------------------------------------------------------
			-- base table 생성 - QTY를 모두 0으로 초기화합니다
			IF OBJECT_ID('tempdb..#tmp_SCP_PLN_PLANT_ONHAND_temp') IS NOT NULL
				DROP TABLE #tmp_SCP_PLN_PLANT_ONHAND_temp

			CREATE TABLE #tmp_SCP_PLN_PLANT_ONHAND_temp (
				OPERATION_GROUP NVARCHAR(10) NOT NULL
				,ITEM_ID NVARCHAR(50) NOT NULL
				,scm_from_site_id NVARCHAR(30) NOT NULL
				,YYYYMMDD NVARCHAR(8) NOT NULL
				,STOCK_TYPE NVARCHAR(50) NOT NULL
				,CATEGORY NVARCHAR(50) NOT NULL
				,QTY NUMERIC(20, 10) NULL
				,ELECTRODE_TYPE NVARCHAR(30) NULL
				,
				)

			-- base table 생성 - EOH
			INSERT INTO #tmp_SCP_PLN_PLANT_ONHAND_temp
			SELECT operation_group
				,item_id
				,scm_from_site_id
				,b.dt AS YYYYMMDD
				,stock_type
				,category
				,qty
				,electrode_type
			FROM (
				SELECT DISTINCT A.OPERATION_GROUP
					,A.ITEM_ID
					,A.SCM_FROM_SITE_ID
                    ,(CASE  WHEN   (A.FROM_SITE_ID  like '_____E~***'  AND A.TO_SITE_ID    LIKE '%E~002')   THEN  'SLITTING'     
                            WHEN   (A.FROM_SITE_ID  like '_____E~002'  AND A.TO_SITE_ID    LIKE '%E~003')   THEN  'E_MOVE_WH'     
                            WHEN   (A.FROM_SITE_ID  like '%-A~***'  AND A.TO_SITE_ID    LIKE '%A~001')   THEN  'FORMING'     
                            WHEN   (A.FROM_SITE_ID  like '_____A~001'  AND A.TO_SITE_ID    LIKE '%A~002')   THEN  'CHARING'     
                            WHEN   (A.FROM_SITE_ID  like '_____A~002'  AND A.TO_SITE_ID    LIKE '%A~003')   THEN  'A_MOVE_WH'    
                            WHEN   (A.FROM_SITE_ID  like '_____P~***'  AND A.TO_SITE_ID    LIKE '%P~003')   THEN  'P_MOVE_WH'     
                            ELSE '-' END)  AS STOCK_TYPE   
					,'EOH' AS CATEGORY
					,convert(NUMERIC, 0) AS qty
					,A.ELECTRODE_TYPE
				FROM SCP_ENG_DELIVERY_O_TEMP_SN A WITH (NOLOCK)
				WHERE 0 = 0
					AND A.MASTER_ID = @p_master_id -- '81::WEEKLY'            
					AND A.PLAN_ID = @p_plan_id -- '1020'            
					AND A.PLAN_TYPE = @p_plan_type -- 'PR'            
					AND A.PLAN_NAME = @p_plan_start_yyyymmdd -- '20180402'            
					AND A.DIVISION_ID = @p_division_id -- '81'            
					AND A.SEQ = @p_seq -- '11'            
					AND A.SCM_FROM_SITE_ID = A.SCM_TO_SITE_ID
					AND (
						(
							A.FROM_SITE_ID LIKE '_____E~***'
							AND A.TO_SITE_ID LIKE '%E~002'
							)
						OR (
							A.FROM_SITE_ID LIKE '_____E~002'
							AND A.TO_SITE_ID LIKE '%E~003'
							)
						OR (
							A.FROM_SITE_ID LIKE '%-A~***'
							AND A.TO_SITE_ID LIKE '%A~001'
							)
						OR (
							A.FROM_SITE_ID LIKE '_____A~001'
							AND A.TO_SITE_ID LIKE '%A~002'
							)
						OR (
							A.FROM_SITE_ID LIKE '_____A~002'
							AND A.TO_SITE_ID LIKE '%A~003'
							)
						OR (
							A.FROM_SITE_ID LIKE '_____P~***'
							AND A.TO_SITE_ID LIKE '%P~003'
							)
						)
				) a
			CROSS JOIN #CALENDAR_DT B
			;

			-- base table 생성 - BOH
			INSERT INTO #tmp_SCP_PLN_PLANT_ONHAND_temp
			SELECT operation_group
				,item_id
				,scm_from_site_id
				,b.dt AS YYYYMMDD
				,stock_type
				,category
				,qty
				,electrode_type
			FROM (
				SELECT DISTINCT A.OPERATION_GROUP
					,A.ITEM_ID
					,A.SCM_FROM_SITE_ID
                    ,(CASE  WHEN   (A.FROM_SITE_ID  like '_____E~***'  AND A.TO_SITE_ID    LIKE '%E~002')   THEN  'SLITTING'     
                            WHEN   (A.FROM_SITE_ID  like '_____E~002'  AND A.TO_SITE_ID    LIKE '%E~003')   THEN  'E_MOVE_WH'     
                            WHEN   (A.FROM_SITE_ID  like '%-A~***'  AND A.TO_SITE_ID    LIKE '%A~001')   THEN  'FORMING'     
                            WHEN   (A.FROM_SITE_ID  like '_____A~001'  AND A.TO_SITE_ID    LIKE '%A~002')   THEN  'CHARING'     
                            WHEN   (A.FROM_SITE_ID  like '_____A~002'  AND A.TO_SITE_ID    LIKE '%A~003')   THEN  'A_MOVE_WH'    
                            WHEN   (A.FROM_SITE_ID  like '_____P~***'  AND A.TO_SITE_ID    LIKE '%P~003')   THEN  'P_MOVE_WH'     
                            ELSE '-' END)  AS STOCK_TYPE   
					,'BOH' AS CATEGORY
					,convert(NUMERIC, 0) AS qty
					,A.ELECTRODE_TYPE
				FROM SCP_ENG_DELIVERY_O_TEMP_SN A WITH (NOLOCK)
				WHERE 0 = 0
					AND A.MASTER_ID = @p_master_id -- '81::WEEKLY'            
					AND A.PLAN_ID = @p_plan_id -- '1020'            
					AND A.PLAN_TYPE = @p_plan_type -- 'PR'            
					AND A.PLAN_NAME = @p_plan_start_yyyymmdd -- '20180402'            
					AND A.DIVISION_ID = @p_division_id -- '81'            
					AND A.SEQ = @p_seq -- '11'            
					AND A.SCM_FROM_SITE_ID = A.SCM_TO_SITE_ID
					AND (
						(
							A.FROM_SITE_ID LIKE '_____E~***'
							AND A.TO_SITE_ID LIKE '%E~002'
							)
						OR (
							A.FROM_SITE_ID LIKE '_____E~002'
							AND A.TO_SITE_ID LIKE '%E~003'
							)
						OR (
							A.FROM_SITE_ID LIKE '%-A~***'
							AND A.TO_SITE_ID LIKE '%A~001'
							)
						OR (
							A.FROM_SITE_ID LIKE '_____A~001'
							AND A.TO_SITE_ID LIKE '%A~002'
							)
						OR (
							A.FROM_SITE_ID LIKE '_____A~002'
							AND A.TO_SITE_ID LIKE '%A~003'
							)
						OR (
							A.FROM_SITE_ID LIKE '_____P~***'
							AND A.TO_SITE_ID LIKE '%P~003'
							)
						)
				) a
			CROSS JOIN #CALENDAR_DT B
			;

			-- 조건을 만족하는 행만 SUM(QTY) 생성 - EOH
			INSERT INTO #tmp_SCP_PLN_PLANT_ONHAND_temp
			SELECT A.OPERATION_GROUP
				,A.ITEM_ID
				,A.SCM_FROM_SITE_ID
				,B.DT AS YYYYMMDD
				,(
					CASE 
						WHEN (
								A.FROM_SITE_ID LIKE '_____E~***'
								AND A.TO_SITE_ID LIKE '%E~002'
								)
							THEN 'SLITTING'
						WHEN (
								A.FROM_SITE_ID LIKE '_____E~002'
								AND A.TO_SITE_ID LIKE '%E~003'
								)
							THEN 'E_MOVE_WH'
						WHEN (
								A.FROM_SITE_ID LIKE '%-A~***'
								AND A.TO_SITE_ID LIKE '%A~001'
								)
							THEN 'FORMING'
						WHEN (
								A.FROM_SITE_ID LIKE '_____A~001'
								AND A.TO_SITE_ID LIKE '%A~002'
								)
							THEN 'CHARING'
						WHEN (
								A.FROM_SITE_ID LIKE '_____A~002'
								AND A.TO_SITE_ID LIKE '%A~003'
								)
							THEN 'A_MOVE_WH'
						WHEN (
								A.FROM_SITE_ID LIKE '_____P~***'
								AND A.TO_SITE_ID LIKE '%P~003'
								)
							THEN 'P_MOVE_WH'
						ELSE '-'
						END
					) AS STOCK_TYPE
				,'EOH' AS CATEGORY
				,sum(ISNULL((
							CASE 
								WHEN (
										CONVERT(VARCHAR(8), A.START_TIME, 112) <= B.DT
										AND CONVERT(VARCHAR(8), A.END_TIME, 112) > B.DT
										)
									THEN ALLOCATION_QTY
								ELSE 0
								END
							), 0)) QTY
				,A.ELECTRODE_TYPE
			FROM SCP_ENG_DELIVERY_O_TEMP_SN A WITH (NOLOCK)
			RIGHT OUTER JOIN #CALENDAR_DT B
				--ON 0 = 0
				ON CONVERT(VARCHAR(8), A.START_TIME, 112) <= B.DT
				AND CONVERT(VARCHAR(8), A.END_TIME, 112) > B.DT
			WHERE 0 = 0
				AND A.MASTER_ID = @p_master_id -- '81::WEEKLY'            
				AND A.PLAN_ID = @p_plan_id -- '1020'            
				AND A.PLAN_TYPE = @p_plan_type -- 'PR'            
				AND A.PLAN_NAME = @p_plan_start_yyyymmdd -- '20180402'            
				AND A.DIVISION_ID = @p_division_id -- '81'            
				AND A.SEQ = @p_seq -- '11'            
				AND A.SCM_FROM_SITE_ID = A.SCM_TO_SITE_ID
				AND (
					(
						A.FROM_SITE_ID LIKE '_____E~***'
						AND A.TO_SITE_ID LIKE '%E~002'
						)
					OR (
						A.FROM_SITE_ID LIKE '_____E~002'
						AND A.TO_SITE_ID LIKE '%E~003'
						)
					OR (
						A.FROM_SITE_ID LIKE '%-A~***'
						AND A.TO_SITE_ID LIKE '%A~001'
						)
					OR (
						A.FROM_SITE_ID LIKE '_____A~001'
						AND A.TO_SITE_ID LIKE '%A~002'
						)
					OR (
						A.FROM_SITE_ID LIKE '_____A~002'
						AND A.TO_SITE_ID LIKE '%A~003'
						)
					OR (
						A.FROM_SITE_ID LIKE '_____P~***'
						AND A.TO_SITE_ID LIKE '%P~003'
						)
					)
			GROUP BY A.OPERATION_GROUP
				,A.ITEM_ID
				,A.SCM_FROM_SITE_ID
				,B.DT
				,(
					CASE 
						WHEN (
								A.FROM_SITE_ID LIKE '_____E~***'
								AND A.TO_SITE_ID LIKE '%E~002'
								)
							THEN 'SLITTING'
						WHEN (
								A.FROM_SITE_ID LIKE '_____E~002'
								AND A.TO_SITE_ID LIKE '%E~003'
								)
							THEN 'E_MOVE_WH'
						WHEN (
								A.FROM_SITE_ID LIKE '%-A~***'
								AND A.TO_SITE_ID LIKE '%A~001'
								)
							THEN 'FORMING'
						WHEN (
								A.FROM_SITE_ID LIKE '_____A~001'
								AND A.TO_SITE_ID LIKE '%A~002'
								)
							THEN 'CHARING'
						WHEN (
								A.FROM_SITE_ID LIKE '_____A~002'
								AND A.TO_SITE_ID LIKE '%A~003'
								)
							THEN 'A_MOVE_WH'
						WHEN (
								A.FROM_SITE_ID LIKE '_____P~***'
								AND A.TO_SITE_ID LIKE '%P~003'
								)
							THEN 'P_MOVE_WH'
						ELSE '-'
						END
					)
				,A.ELECTRODE_TYPE
				;

			-- 조건을 만족하는 행만 SUM(QTY) 생성 - BOH
			INSERT INTO #tmp_SCP_PLN_PLANT_ONHAND_temp
			SELECT A.OPERATION_GROUP
				,A.ITEM_ID
				,A.SCM_FROM_SITE_ID
				,B.DT AS YYYYMMDD
				,(
					CASE 
						WHEN (
								A.FROM_SITE_ID LIKE '_____E~***'
								AND A.TO_SITE_ID LIKE '%E~002'
								)
							THEN 'SLITTING'
						WHEN (
								A.FROM_SITE_ID LIKE '_____E~002'
								AND A.TO_SITE_ID LIKE '%E~003'
								)
							THEN 'E_MOVE_WH'
						WHEN (
								A.FROM_SITE_ID LIKE '%-A~***'
								AND A.TO_SITE_ID LIKE '%A~001'
								)
							THEN 'FORMING'
						WHEN (
								A.FROM_SITE_ID LIKE '_____A~001'
								AND A.TO_SITE_ID LIKE '%A~002'
								)
							THEN 'CHARING'
						WHEN (
								A.FROM_SITE_ID LIKE '_____A~002'
								AND A.TO_SITE_ID LIKE '%A~003'
								)
							THEN 'A_MOVE_WH'
						WHEN (
								A.FROM_SITE_ID LIKE '_____P~***'
								AND A.TO_SITE_ID LIKE '%P~003'
								)
							THEN 'P_MOVE_WH'
						ELSE '-'
						END
					) AS STOCK_TYPE
				,'BOH' AS CATEGORY
				,sum(ISNULL((
							CASE 
								WHEN (
										CONVERT(VARCHAR(8), A.START_TIME, 112) < B.DT
										AND CONVERT(VARCHAR(8), A.END_TIME, 112) >= B.DT
										)
									THEN ALLOCATION_QTY
								ELSE 0
								END
							), 0)) QTY
				,A.ELECTRODE_TYPE
			FROM SCP_ENG_DELIVERY_O_TEMP_SN A WITH (NOLOCK)
			RIGHT OUTER JOIN #CALENDAR_DT B
				--ON 0 = 0
				ON CONVERT(VARCHAR(8), A.START_TIME, 112) <= B.DT
				AND CONVERT(VARCHAR(8), A.END_TIME, 112) > B.DT
			WHERE 0 = 0
				AND A.MASTER_ID = @p_master_id -- '81::WEEKLY'            
				AND A.PLAN_ID = @p_plan_id -- '1020'            
				AND A.PLAN_TYPE = @p_plan_type -- 'PR'            
				AND A.PLAN_NAME = @p_plan_start_yyyymmdd -- '20180402'            
				AND A.DIVISION_ID = @p_division_id -- '81'            
				AND A.SEQ = @p_seq -- '11'            
				AND A.SCM_FROM_SITE_ID = A.SCM_TO_SITE_ID
				AND (
					(
						A.FROM_SITE_ID LIKE '_____E~***'
						AND A.TO_SITE_ID LIKE '%E~002'
						)
					OR (
						A.FROM_SITE_ID LIKE '_____E~002'
						AND A.TO_SITE_ID LIKE '%E~003'
						)
					OR (
						A.FROM_SITE_ID LIKE '%-A~***'
						AND A.TO_SITE_ID LIKE '%A~001'
						)
					OR (
						A.FROM_SITE_ID LIKE '_____A~001'
						AND A.TO_SITE_ID LIKE '%A~002'
						)
					OR (
						A.FROM_SITE_ID LIKE '_____A~002'
						AND A.TO_SITE_ID LIKE '%A~003'
						)
					OR (
						A.FROM_SITE_ID LIKE '_____P~***'
						AND A.TO_SITE_ID LIKE '%P~003'
						)
					)
			GROUP BY A.OPERATION_GROUP
				,A.ITEM_ID
				,A.SCM_FROM_SITE_ID
				,B.DT
				,(
					CASE 
						WHEN (
								A.FROM_SITE_ID LIKE '_____E~***'
								AND A.TO_SITE_ID LIKE '%E~002'
								)
							THEN 'SLITTING'
						WHEN (
								A.FROM_SITE_ID LIKE '_____E~002'
								AND A.TO_SITE_ID LIKE '%E~003'
								)
							THEN 'E_MOVE_WH'
						WHEN (
								A.FROM_SITE_ID LIKE '%-A~***'
								AND A.TO_SITE_ID LIKE '%A~001'
								)
							THEN 'FORMING'
						WHEN (
								A.FROM_SITE_ID LIKE '_____A~001'
								AND A.TO_SITE_ID LIKE '%A~002'
								)
							THEN 'CHARING'
						WHEN (
								A.FROM_SITE_ID LIKE '_____A~002'
								AND A.TO_SITE_ID LIKE '%A~003'
								)
							THEN 'A_MOVE_WH'
						WHEN (
								A.FROM_SITE_ID LIKE '_____P~***'
								AND A.TO_SITE_ID LIKE '%P~003'
								)
							THEN 'P_MOVE_WH'
						ELSE '-'
						END
					)
				,A.ELECTRODE_TYPE
				;

			-- 중복 데이터 정리 및 #tmp_SCP_PLN_PLANT_ONHAND 테이블로 삽입
			INSERT INTO #tmp_SCP_PLN_PLANT_ONHAND (
				OPERATION_GROUP
				,ITEM_ID
				,SITE_ID
				,YYYYMMDD
				,STOCK_TYPE
				,CATEGORY
				,QTY
				,
				--                  ORIGIN_DIVISION_ID,  
				ELECTRODE_TYPE
				)
			SELECT operation_group
				,item_id
				,scm_from_site_id
				,YYYYMMDD
				,stock_type
				,category
				,sum(qty) AS qty
				,electrode_type
			FROM #tmp_SCP_PLN_PLANT_ONHAND_temp
			GROUP BY operation_group
				,item_id
				,scm_from_site_id
				,YYYYMMDD
				,stock_type
				,category
				,electrode_type

			------------------------------------------------------------------------------------------------------------------------------------------- END


         
            -------------------------------------------------------------------------------------------------------------------------------------------     
            -- 5. 전극 SCP 반영(ORIGIN_DIVISION_ID,ELECTRODE_TYPE) 추가         
            -------------------------------------------------------------------------------------------------------------------------------------------     
            --PRINT('2 : ' + FORMAT(GETDATE(), 'yyyyMMdd HH:mm:ss'));

            UPDATE X  
               SET X.ORIGIN_DIVISION_ID = Y.DIVISION_ID  
              FROM #tmp_SCP_PLN_PLANT_ONHAND X WITH (NOLOCK)  
              LEFT OUTER JOIN DBO.SCM_MST_SITE Y  WITH (NOLOCK)       -- from   SITE_ID  
                           ON Y.SITE_TYPE   = 'PLANT'      
                          AND Y.SCM_SITE_ID  = X.SITE_ID
                          AND Y.VALID_YN ='Y'     
            
            UPDATE X    
               SET X.ELECTRODE_TYPE = B.ELECTRODE_TYPE    
              FROM #tmp_SCP_PLN_PLANT_ONHAND X WITH (NOLOCK)    
              INNER JOIN DBO.SCP_MST_FINAL_ITEM_V B  WITH (NOLOCK)               
                    ON X.ITEM_ID          = B.ITEM_ID     
               WHERE X.ELECTRODE_TYPE IS NULL   -- TH_ENG_STOCK_PLAN_SN 추출건만
  
            -------------------------------------------------------------------------------------------------------------------------------------------    
            -- 6. SCP_PLN_PLANT_ONHAND 삭제    
            -------------------------------------------------------------------------------------------------------------------------------------------       

			------------------------------------------------------------------------------------------------------------------------------------------- start
			-- 2021.11.03 튜닝개선안에 따른 변경
			-------------------------------------------------------------------------------------------------------------------------------------------
			-- 변경전
            --DELETE FROM SCP_PLN_PLANT_ONHAND_TG              
            --WHERE DIVISION_ID = @p_division_id AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND PLAN_TYPE = @p_plan_type AND SEQ = @p_seq        
			
			--PRINT('3 : ' + FORMAT(GETDATE(), 'yyyyMMdd HH:mm:ss'));
			--SET @v_del_start = GETDATE();

			-- 변경후
			BEGIN TRAN
				WHILE (1=1)
				BEGIN
				    --SET @v_loop = @v_loop + 1;
					--PRINT('3-' + CAST(@v_loop AS varchar) + ' : ' + FORMAT(GETDATE(), 'yyyyMMdd HH:mm:ss'));

					DELETE TOP (10000) FROM SCP_PLN_PLANT_ONHAND
					 WHERE DIVISION_ID = @p_division_id AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND PLAN_TYPE = @p_plan_type AND SEQ = @p_seq

                    
                    IF(@@ROWCOUNT = 0)
					BEGIN
					 BREAK;
					END
				END
			COMMIT

			--SET @v_del_end = GETDATE();
			--PRINT(CAST(DATEDIFF(ss, @v_del_start, @v_del_end) AS varchar) + ' sec elapsed.');

			------------------------------------------------------------------------------------------------------------------------------------------- end

			--PRINT('4 : ' + FORMAT(GETDATE(), 'yyyyMMdd HH:mm:ss'));
			--SET @v_del_start = GETDATE();                
            -------------------------------------------------------------------------------------------------------------------------------------------            
            -- 7. CATEGORY구분에 따라 BOH/IN/OUT/EOH    PIVOT        
            -------------------------------------------------------------------------------------------------------------------------------------------             
			BEGIN TRAN -- 2021.11.03 튜닝개선안에 따른 추가
            INSERT INTO dbo.SCP_PLN_PLANT_ONHAND
            (            
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
              ,STOCK_TYPE            
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
                    @p_master_id            AS MASTER_ID                 
                   ,@p_plan_id              AS PLAN_ID                   
                   ,@p_engine_plan_id       AS OUT_VERSION_ID            
                   ,@p_division_id          AS DIVISION_ID            
                   ,@p_plan_start_yyyymmdd  AS PLAN_START_YYYYMMDD            
                   ,@p_plan_type            AS PLAN_TYPE            
                   ,@p_seq                  AS SEQ            
                   ,OPERATION_GROUP            
                   ,ITEM_ID            
                   ,SITE_ID            
                   ,YYYYMMDD            
                   ,STOCK_TYPE      
                   ,ORIGIN_DIVISION_ID  
                   ,ELECTRODE_TYPE    
                   ,ISNULL([BOH],0)         AS PSI_BOH_QTY            
                   ,ISNULL([IN],0)          AS PSI_IN_QTY            
                   ,ISNULL([OUT],0)         AS PSI_OUT_QTY            
                   ,ISNULL(EOH,0)           AS PSI_EOH_QTY            
                   ,@v_batch_user           AS CREATED_BY            
                   ,GETDATE()               AS CREATION_DATE            
                   ,@v_batch_user           AS LAST_UPDATED_BY            
                   ,GETDATE()               AS LAST_UPDATED_DATE            
              FROM            
              (       
                 SELECT  OPERATION_GROUP, ITEM_ID, SITE_ID, YYYYMMDD, STOCK_TYPE,ORIGIN_DIVISION_ID,ELECTRODE_TYPE, CATEGORY,QTY    
                   FROM  #tmp_SCP_PLN_PLANT_ONHAND with (nolock)    
                   WHERE STOCK_TYPE <> '-'   -- 조건에 제외 되는 데이터                        
               ) AS SourceTable             
              PIVOT            
              (            
                SUM(QTY)            
                  FOR CATEGORY IN ([BOH],[IN],[OUT],[EOH])            
              ) AS PivotTable   
			  
			  COMMIT -- 2021.11.03 튜닝개선안에 따른 추가
              ;

			--SET @v_del_end = GETDATE();
			--PRINT(CAST(DATEDIFF(ss, @v_del_start, @v_del_end) AS varchar) + ' sec elapsed.');
            
        -----------------------------------------------------------            
        -- 실행 Logic END --            
        -------------------------------------------------------------            
        --IF @@TRANCOUNT > 0            
        --  BEGIN            
        --    COMMIT TRAN T1;            
        --  END;            
        
        -----------------------------------------------------------
        -- 임시테이블 삭제
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#CALENDAR_DT') IS NOT NULL            
            DROP TABLE #CALENDAR_DT
                  
        IF OBJECT_ID('tempdb..#tmp_SCP_PLN_PLANT_ONHAND') IS NOT NULL            
            DROP TABLE #tmp_SCP_PLN_PLANT_ONHAND

        -- TXN LOG            
        SET @v_log_type = N'TXN';    --  로그타입            
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
     SET @v_exec_time  =  REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
                          REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))     

    -- 종료 LOG            
    SET @v_log_type = N'END';            
    SET @v_log_message = N'########## END of procedure ##########';            
    SET @v_description = N'[' + @p_master_id + ']['+@p_engine_plan_id+'][' + @v_exec_time + ']';       
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

