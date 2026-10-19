                        
                          
                        
                          
                          
                        
/*                    
 * Program ID   : PR_SCP_ANL_PSI_PRODUCTION                      
 * Description  : PR_SCP_ANL_CREATE_DATA 에서 호출함.                    
 * OutTable     :                    
 * Execute      : EXEC PR_SCP_ANL_PSI_PRODUCTION      @p_division_id         = '81'       
                                                     ,@p_plan_start_yyyymmdd = '20180528'      
                                                     ,@p_plan_type           = 'PR'      
                                                     ,@p_seq                 = '2'      
                                                     ,@p_engine_plan_id      = '1028::PR::2'       
                                                     ,@p_master_id           = '81::WEEKLY'       
                                                     ,@p_user_id             = 'kth'      
 * Program History                    
 *===================================================================================================                    
 *   Date       In Charge      Description                    
 *===================================================================================================                    
 * 2018.03.05   KTH         Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트                    
 * 2018.04.19   YYDOK       PLANT_ONHAND.STOCK_TYPE 변경사항 반영.              
 * 2018.04.30   YYDOK       PLANT_ONHAND.STOCK_TYPE 변경사항 반영.(FOR_STOCKPLAN)              
 * 2018.05.08   KTH         ACTIVATE_PROGRESS,MODEL_INVENTORY 변경사항 반영          
 * 2018.05.16   KTH         DIO 추가          
 * 2018.05.21   KTH         Weekly 구간의 Balance 로직 변경, 주의 마지막 일자로 이동 주석처리        
 * 2018.05.23   KTH         전체 DIVISION_ID, FROM_SITE,ITEM_ID별 QTY가 0 인 데이터  삭제         
 * 2018.06.01   YYDOK       PACKER 생산계획 미생성오류 보완(라인 '-'제외->코멘트처리(팩커라인은 '-'임) 활성화공정 F1000,F6000 제외      
 * 2018.06.05   KTH         CHAR_AVAILABLE  (특성완료)= ('FORMED')   추가      
 * 2018.06.21   KTH         52주 364일 제한 로직 추가 AND YYYYMMDD < CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,@p_plan_start_yyyymmdd,112)),112)       
 * 2018.07.03   KTH         전극 SCP 반영(ORIGIN_FROM_DIVISION_ID,ORIGIN_TO_DIVISION_ID,ELECTRODE_TYPE) 추가                 
 * 2018.07.04   KTH         SCP_MST_FINAL_ITEM_V로 변경    
 * 2018.07.09   KTH         파라미터 변경 (PLN과 동일하게 변경)    
 * 2018.07.13   KTH         TO_SITE가 '-' 일 경우 ORIGIN_TO_DIVISION_ID 조회 로직 추가    
 * 2018.07.16   KTH         DIO ORIGIN_TO_DIVISION 로직 변경    
 * 2018.08.09   KTH         0 채움로직 변경  
 * 2018.08.14   KTH         소형후공정 CELL Model inventory Balance  보정 로직반영( 전일 EOH – 출하sum + PSI_TYPE ='P' (OPERATION_GROUP ='A' AND SUBSTRING(ITEM_ID,1,2) IN ('MI','MD','MT') ))  
 * 2018.08.27   KTH         소형후공정 CELL Model MODEL_INVENTORY 로직 수정(YY.DIVISION_ID = '40' AND SUBSTRING(YY.ITEM_ID,1,2) IN ('MI','MD','MT') ) 
 * 2018.08.30   KTH         전극,팩 EOH 재고 입력시 (A.OPERATION_GROUP       <> 'A' ) 조건 추가
 * 2018.09.11   KTH         소형사업부(40)에 대해서는 SHIPMENT를 출하지별로 여러라인으로 표현하지 않고 ‘-‘ 로 합계 표시 반영
 * 2018.11.09   KTH         소형사업부(40)에 대해서는 SHIPMENT를 출하지별로 ‘-‘ 해제
 * 2018.11.12   KTH         소형사업부(40)  사내 TCO 가상 출하 추가, TCO_CELL_YN 로직 반영
 * 2018.11.13   KTH         DIO로직변경(Formation Progress(ACTIVATE_PROGRESS)포함해서 계산)
 * 2018.11.19   KTH         Operation_ID(ATTRIBUTE9) 추가
 * 2018.11.26   KTH         UI SUBSUM 로직 반영
 * 2018.12.04   KTH         TCO 체크 로직 수정
 * 2018.12.05   KTH         ATTRIBUTE9 조건 변경
 * 2019.01.16   KTH         TEMPDB TABLE DROP 로직 추가 
 * 2019.01.28   KTH         외주PACKER의 업체코드 조회 로직 수정
 * 2019.06.25   KSG         '3. 소형사업부(40)  사내 TCO 가상 출하' :  S로 P 생성 시 YYYYMMDD 기준을 END DATE 로 변경   
 * 2020.11.04   KSW         PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : RACK biz. 대응
 * 2020.11.13   KSW         생산계획이 누락되는 오류수정 (ex) QTY 값(flag) = 0 인 data를 삭제하는 로직에서 group by sum 할때 -값과 - 값이 아닌 결과갯수가 동일한 경우 삭제되는 오류 
 * 2021.05.10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응
 * 2021.10.12   KSW         PJ20214997 LGES SCP 신규 Biz, 공정 추가에 따른 모델링 개선 - 자동차 이면서 P5200 일 경우 ATTRIBUTE9에 OPERATION_ID 셋팅
 * 2021.11.11   sclee.lee   튜닝개선안에 따른 일부 쿼리 변경
 * 2021.12.03   KSW         일별 BOH 추가 (활성화 완료 수량이 포함된 수량으로 Model inventory 오류를 수정)
 * 2022.02.11   KSW         Model inventory AC_SUM 수량은 소형 사업부 일 경우만 일별 BOH 적용
 * 2022.03.22   KSW         JV GM 반영
 * 2022.06.27   sclee.lee   PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 - isuzu관련 조회구문 변경
 * 2023.03.29   hrkim		PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 * 2023.07.25   hrkim		PJ20230691  LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화코드 분리 해외 오픈 대응
 * 2023.08.03	HRK			PJ20230692 SCM 역량 강화 위한 SCP 개선과제 이행 Phase2 : Model Inventory 보정 쿼리 셀모델 BOH 오류 수정 
 *									- P/S는 누적을 적용하는데, BOH는 전일 값을 적용하고 있음 (Y.BOH)
 *									- plan_start_yyyymmdd의 BOH을 적용하도록 수정 (X.BOH)
 * 2026.07.24   YMH         E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
 */                    
                     
CREATE PROCEDURE [dbo].[PR_SCP_ANL_PSI_PRODUCTION]              
(       
      @p_plan_cycle           NVARCHAR(150)              
    , @p_plan_start_yyyymmdd  NVARCHAR(8)     -- plan_name           
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
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_ANL_PSI_PRODUCTION';            
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...            
    DECLARE @n_log_count    INTEGER = 0;            
    DECLARE @v_log_message  NVARCHAR(1000);            
    DECLARE @v_description  NVARCHAR(500);          
    DECLARE @v_table_id     NVARCHAR(150) = N'SCM_SYS_LOG_BATC';         
    DECLARE @d_event_date   DATETIME;            
       
  -- 시작 LOG            
    SET @v_log_type = N'START';            
    SET @v_log_message = N'########## Start of procedure ##########';            
    SET @v_description = @v_program_name + ':' + N' SCP_ANL_PSI_PRODUCTION INSERT LOGIC';            
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
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'00:00';                
                
    BEGIN TRY                    
      BEGIN                    
--        BEGIN TRAN TX_PSI1                    
          -------------------------------------------------------------------------------------------------------------                     
          -- 0. temp 테이블 생성 : Measure까지 생성후 마지막에 한번에 입력하기 위해서                    
          -------------------------------------------------------------------------------------------------------------                     
          IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_PRODUCTION') IS NOT NULL                    
            DROP TABLE #tmp_SCP_ANL_PSI_PRODUCTION                    
                    
            CREATE TABLE #tmp_SCP_ANL_PSI_PRODUCTION                    
            (                    
              DIVISION_ID               nvarchar(030)                        
             ,PLAN_START_YYYYMMDD       nvarchar(008)                        
             ,PLAN_TYPE                 nvarchar(050)                        
             ,SEQ                       bigint                              
             ,OPERATION_GROUP           nvarchar(010)                        
             ,FROM_SITE                 nvarchar(030)                        
             ,ITEM_ID                   nvarchar(050)          
                     
             ,BOH                       numeric(20, 10)  -- MODEL_INVENTORY 계산을 위해서  추가 함 2018.05.21         
                                   
             ,PSI_TYPE                  nvarchar(001)    -- S,P,I                    
             ,PSI_VALUE                 nvarchar(100)    -- S: TO_SITE, P: PROD_LINE, I: MODEL_INVENTORY / ACTIVATE_COMPLETED(활성화완료) / ACTIVATE_PROGRESS(활성화진행중)                    
             ,TO_SITE                   nvarchar(030)                        
             ,PROD_LINE                 nvarchar(050)                        
             ,YYYYMMDD   nvarchar(008)                    
             ,QTY                       numeric(20, 10)                     
             ,INVENTORY_TYPE            nvarchar(050)                 
             ,ORIGIN_FROM_DIVISION_ID   nvarchar(030)     
             ,ORIGIN_TO_DIVISION_ID     nvarchar(030)     
             ,ELECTRODE_TYPE            nvarchar(030)            
             ,TO_SITE_ORG               nvarchar(030)   -- TO_SITE가 '-' 일 경우 ORIGIN_TO_DIVISION_ID 를 찾기 위해서    
--             ,TO_SITE_TYPE              NVARCHAR(10)    -- TO_SITE의 SITE_TYPE
             ,ATTRIBUTE7                nvarchar(150)   --- TCO_CELL_YN 추가 
             ,ATTRIBUTE9                nvarchar(150)   --- operation_id
             ,ATTRIBUTE10               nvarchar(150)   --- TCO 가상 출하 DATA 확인 
            );                    
                    
			-- * 2021.05.10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - start
			DECLARE @v_pet_date		NVARCHAR(12) = '';

			--  Plan End Date
			SELECT @v_pet_date = p.horizon_end_date
			FROM   dbo.scm_mst_plan p WITH(NOLOCK)
			WHERE  p.division_id = @p_division_id
			AND    p.plan_id     = @p_plan_id ;

			SET @v_pet_date = CONVERT(VARCHAR(8), DATEADD(DAY, 1, CONVERT(DATETIME, @v_pet_date, 112)), 112);
			-- * 2021-05-10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - end
                    
            -------------------------------------------------------------------------------------------------------------                     
            -- 1 SHIPMENT 입력 - SPI_TYPE ='S'                    
            -------------------------------------------------------------------------------------------------------------          
              INSERT INTO #tmp_SCP_ANL_PSI_PRODUCTION                    
                  (                    
                   DIVISION_ID                              
                  ,PLAN_START_YYYYMMDD                      
                  ,PLAN_TYPE                               
                  ,SEQ                                      
                  ,OPERATION_GROUP                          
                  ,FROM_SITE                                
                  ,ITEM_ID                                  
                  ,PSI_TYPE                                 
                  ,PSI_VALUE                                
                  ,TO_SITE                                  
                  ,PROD_LINE                                
                  ,YYYYMMDD                                 
                  ,QTY                                      
                  ,INVENTORY_TYPE        
                  ,ORIGIN_FROM_DIVISION_ID             
                  ,ORIGIN_TO_DIVISION_ID           
                  ,ELECTRODE_TYPE       
                  ,TO_SITE_ORG        
                   )                    
    
                  SELECT                     
                       A.DIVISION_ID                             
                      ,A.PLAN_START_YYYYMMDD                                       ,A.PLAN_TYPE                               
                      ,A.SEQ                                     
                      ,A.OPERATION_GROUP                         
                      ,A.FROM_SITE         AS FROM_SITE                    
                      ,A.ITEM_ID                                 
                      ,'S'                 AS PSI_TYPE            -- S,P,I                    
                      ,A.TO_SITE           AS PSI_VALUE                    
                      ,A.TO_SITE           AS TO_SITE                    
                      ,''                  AS PROD_LINE          
                      ,A.YYYYMMDD                       
                      ,SUM(ISNULL(A.COMPLETE_QTY,0)) AS QTY                                                  
                      ,''                  AS INVENTORY_TYPE          --재고구분        
                      ,A.ORIGIN_FROM_DIVISION_ID             
                      ,A.ORIGIN_TO_DIVISION_ID           
                      ,A.ELECTRODE_TYPE              
                      ,A.TO_SITE             
                 FROM SCP_PLN_SHIPMENT_PLAN A    WITH (NOLOCK)                
                WHERE 1 = 1                    
                  AND A.DIVISION_ID         = @p_division_id                    
                  AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd                    
                  AND A.PLAN_TYPE           = @p_plan_type                    
                  AND A.SEQ                 = @p_seq                    
--                  AND A.ITEM_ID           ='ECE0630N1-02'    
             GROUP BY                 
                     A.DIVISION_ID                             
                    ,A.PLAN_START_YYYYMMDD                     
                    ,A.PLAN_TYPE                               
                    ,A.SEQ                                     
                    ,A.OPERATION_GROUP                         
                    ,A.FROM_SITE                      
                    ,A.ITEM_ID                                 
                    ,A.TO_SITE                    
                    ,A.YYYYMMDD             
                    ,A.ORIGIN_FROM_DIVISION_ID             
                    ,A.ORIGIN_TO_DIVISION_ID           
                    ,A.ELECTRODE_TYPE       
                    ;                    

		-- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
        SET @v_log_message = N'########## log step ##########';
        SET @v_description = @v_program_name + ':' + N' 00100 ';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								    ,@p_log_type      = N'TXN'        
								    ,@p_log_count     = 0       
								    ,@p_log_message   = @v_log_message       
								    ,@p_description   = @v_description       
								    ,@p_event_date    = @d_event_date       
								    ,@p_user_id       = @v_batch_user      
                                    ;  

            -------------------------------------------------------------------------------------------------------------                     
            -- 2 PRODUCTION 입력 - SPI_TYPE ='P'                    
            -------------------------------------------------------------------------------------------------------------                     
                    
              INSERT INTO #tmp_SCP_ANL_PSI_PRODUCTION                    
             (                    
                   DIVISION_ID                              
                  ,PLAN_START_YYYYMMDD                      
                  ,PLAN_TYPE                                
                  ,SEQ                                      
                  ,OPERATION_GROUP                          
                  ,FROM_SITE                                
                  ,ITEM_ID                                  
                  ,PSI_TYPE                                 
                  ,PSI_VALUE                                
                  ,TO_SITE                                  
                  ,PROD_LINE                                
                  ,YYYYMMDD                                 
                  ,QTY                                      
                  ,INVENTORY_TYPE              
                  ,ORIGIN_FROM_DIVISION_ID             
                  ,ORIGIN_TO_DIVISION_ID           
                  ,ELECTRODE_TYPE      
                  ,ATTRIBUTE7    
                   )                    
              SELECT                     
                     A.DIVISION_ID                             
                    ,A.PLAN_START_YYYYMMDD                     
                    ,A.PLAN_TYPE                               
                    ,A.SEQ                                     
                    ,A.OPERATION_GROUP                         
                    ,A.SITE_ID              AS FROM_SITE                    
                    ,A.ITEM_ID                                 
                    ,'P'                    AS PSI_TYPE            -- S,P,I                    
                    ,A.RESOURCE_ID          AS PSI_VALUE                    
                    ,''                     AS TO_SITE                    
                    ,A.RESOURCE_ID          AS PROD_LINE                    
                    ,CONVERT(NVARCHAR(8), A.END_TIME,112)  AS YYYYMMDD                    
                    ,SUM(ISNULL(A.COMPLETE_QTY,0))   AS QTY                                                  
                    ,''                     AS INVENTORY_TYPE          --재고구분        
                    ,A.ORIGIN_DIVISION_ID   AS  ORIGIN_FROM_DIVISION_ID          
                    ,''                     AS ORIGIN_TO_DIVISION_ID           
                    ,A.ELECTRODE_TYPE      
                    ,A.ATTRIBUTE7         
              FROM SCP_PLN_PRODUCTION_PLAN A    WITH (NOLOCK)                
              WHERE 1 = 1                    
                AND A.DIVISION_ID            = @p_division_id                    
                AND A.PLAN_START_YYYYMMDD    = @p_plan_start_yyyymmdd                    
                AND A.PLAN_TYPE              = @p_plan_type                    
                AND A.SEQ                    = @p_seq                    
                AND ( LEFT(A.operation_id,5) IN (--LOOKUP_TYPE 'SCP_PLAN_OPERATION' 에 정의된 공정만 조회            
                                                    SELECT segment1 AS OPERATION_ID            
                                                             FROM scm_adm_lookup_master_detail WITH(NOLOCK)               
                                                            WHERE lookup_type = 'SCP_PLAN_OPERATION' 
                                                              AND valid_yn    = 'Y' 
														 )     
                               OR            

							   -- 2020.11.04   KSW         PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : RACK biz. 대응
							   -- old version
							   --
                               --A.operation_id        IN (--외주PACKER의 업체코드            
							   (CASE WHEN CHARINDEX('_', A.operation_id) > 0 THEN (SUBSTRING(A.operation_id, 1, DBO.FN_CHARINDEX_REV(A.operation_id, '_', 0)-1)) ELSE A.operation_id END) IN (--외주PACKER의 업체코드            
                                                           SELECT PLANT_ID  AS OPERATION_ID            
                                                            FROM SCM_MST_SITE WITH(NOLOCK)                  
                                                           WHERE 1=1            
--                                                             AND DIVISION_ID = A.division_id            
                                                             AND SITE_TYPE   = 'PLANT'            
                                                             AND OSP_YN      = 'Y'     
                                                             AND VALID_YN    = 'Y'          
                                                         )             
                               -- PJ20216891	
                               -- ISUZU item
                               OR (
                                   LEFT(A.operation_id,5) = 'P5000'
                                   AND EXISTS (
                                               SELECT 1
                                                 FROM dbo.SCM_MST_FINAL_ITEM_V A1 WITH(NOLOCK)
                                                INNER JOIN dbo.SCP_MST_FINAL_ITEM_V B1 WITH(NOLOCK) ON A1.ITEM_ID = B1.ITEM_ID
                                                WHERE A1.ITEM_ID = A.ITEM_ID
                                                  AND A1.IS_YN = 'Y'
                                              )
                                  )
                             )            
                AND A.OPERATION_ID NOT IN ('F1000','F6000') --활성화공정제외      
            GROUP BY                     
                     A.DIVISION_ID                             
                    ,A.PLAN_START_YYYYMMDD                     
                    ,A.PLAN_TYPE                               
                    ,A.SEQ                                     
                    ,A.OPERATION_GROUP                         
                    ,A.SITE_ID                      
                    ,A.ITEM_ID                                 
                    ,A.RESOURCE_ID                    
                    ,CONVERT(NVARCHAR(8), A.END_TIME,112)               
                    ,A.ORIGIN_DIVISION_ID             
                    ,A.ELECTRODE_TYPE  
                    ,A.ATTRIBUTE7         
                    ;                    

		-- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
        SET @v_log_message = N'########## log step ##########';
        SET @v_description = @v_program_name + ':' + N' 00200 ';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								    ,@p_log_type      = N'TXN'        
								    ,@p_log_count     = 0       
								    ,@p_log_message   = @v_log_message       
								    ,@p_description   = @v_description       
								    ,@p_event_date    = @d_event_date       
								    ,@p_user_id       = @v_batch_user      
                                    ;  

            -------------------------------------------------------------------------------------------------------------                     
            -- 3. 소형사업부(40)  사내 TCO 가상 출하                  
            ------------------------------------------------------------------------------------------------------------- 

             IF @p_division_id = '40'
              BEGIN

                 SELECT *
                 INTO #tmp_SCP_ANL_PSI_PRODUCTION_TCO
                 FROM (
                   SELECT  P.DIVISION_ID                              
                          ,P.PLAN_START_YYYYMMDD                      
                          ,P.PLAN_TYPE                               
                          ,P.SEQ    
                          ,P.OPERATION_GROUP  
                          ,P.FROM_SITE
                          ,ISNULL((
                             SELECT TOP 1 CHILD_ITEM_ID
                             FROM   dbo.SCM_MST_MODEL_FINAL_ITEM_BOM_V WITH (NOLOCK)
                             WHERE  DIVISION_ID         = P.DIVISION_ID
                             AND    MODEL_ID            = P.ITEM_ID
                             AND    OPERATION_GROUP_ID  = 'A'
                             AND    CELL_TYPE           = CASE WHEN S.OSP_YN = 'Y' -- 2023.07.25 활성화코드 분리 대응 
															   THEN 'CP'
															   ELSE 'CA2'  
														  END 
                             -- 2023.07.25 활성화코드 분리 대응 AND CHILD_ITEM_ID     LIKE '_C%'
                             ), '-') AS ITEM_ID -- CELL_ITEM_ID
                          ,'S'                 AS PSI_TYPE            -- S,P,I                             
                          ,P.FROM_SITE AS PSI_VALUE                                
                          ,P.TO_SITE                                  
  --                        ,'' AS PROD_LINE                                
                          ,P.FROM_SITE AS PROD_LINE
                          ,P.YYYYMMDD                                 
                          ,P.QTY                                      
                          ,'' AS INVENTORY_TYPE        
                          ,'40' AS ORIGIN_FROM_DIVISION_ID             
                          ,'40' AS ORIGIN_TO_DIVISION_ID           
                          ,P.ELECTRODE_TYPE       
                    FROM #tmp_SCP_ANL_PSI_PRODUCTION P WITH(NOLOCK)
                    INNER JOIN SCP_MST_FINAL_ITEM F WITH(NOLOCK)
                          ON   P.DIVISION_ID = F.DIVISION_ID
                          AND  P.ITEM_ID     = F.ITEM_ID
                          AND  F.TCO_CELL_YN = 'Y'
						  AND  F.ATTRIBUTE8  = 'CP'  -- 2023.07.28 활성화코드 분리 대응 (TCO.CP생산 계획 정보로 TCO.CA2(사내)/CP(사외)의 출하 정보를 생성함) 
                    INNER JOIN SCM_MST_SITE S WITH(NOLOCK)
                          ON   P.DIVISION_ID = S.DIVISION_ID
                          AND  P.FROM_SITE   = S.SCM_SITE_ID
                        -- AND  S.OSP_YN      ='Y'
                          AND  S.SCM_SITE_ID LIKE '%-A'
                          AND  S.SITE_TYPE   = 'PLANT'
                   WHERE 1=1
                     AND P.PSI_TYPE            = 'P' -- PRODUCTION

                    UNION ALL				  
                    -- 외주OSP CELL SITE에서 사내로 출하하는 TCO CELL정보로 사내 CELL SITE에 TCO CELL이 도착하는 것으로 생성(P)
				    -- 도착일자 기준             
                    SELECT   
                         A.DIVISION_ID                             
                        ,A.PLAN_START_YYYYMMDD                 
                        ,A.PLAN_TYPE                               
                        ,A.SEQ    
                        ,A.OPERATION_GROUP  
                        ,A.TO_SITE    AS FROM_SITE
                        ,A.ITEM_ID
                        ,'P'          AS PSI_TYPE            -- S,P,I                             
                        ,A.FROM_SITE  AS PSI_VALUE                                
                        ,A.TO_SITE                               
                        ,A.TO_SITE    AS PROD_LINE
                        ,CONVERT(CHAR(8), A.END_TIME, 112) AS YYYYMMDD
                        ,SUM(ISNULL(A.COMPLETE_QTY,0)) AS QTY                                     
                        ,'' AS INVENTORY_TYPE        
                        ,'40' AS ORIGIN_FROM_DIVISION_ID             
                        ,'40' AS ORIGIN_TO_DIVISION_ID           
                        ,A.ELECTRODE_TYPE       
          
                     FROM SCP_PLN_SHIPMENT_PLAN A    WITH (NOLOCK)     
                   
                      INNER JOIN SCP_MST_FINAL_ITEM F WITH(NOLOCK)
                          ON   A.DIVISION_ID      = F.DIVISION_ID
                          AND  A.ITEM_ID          = F.ITEM_ID
                          AND  F.OPERATION_GROUP  ='A'
                          AND  F.TCO_CELL_YN      ='Y'
                      INNER JOIN SCM_MST_SITE S WITH(NOLOCK)
                          ON   A.DIVISION_ID      = S.DIVISION_ID
                          AND  A.FROM_SITE        = S.SCM_SITE_ID
                          AND  S.OSP_YN           ='Y'
                          AND  S.SCM_SITE_ID    LIKE '%-A'
                          AND  S.SITE_TYPE      = 'PLANT'             
                      -- TO사이트는 사내 CELL SITE 조건추가
                      INNER JOIN SCM_MST_SITE S1 WITH(NOLOCK)
                          ON   A.DIVISION_ID    = S1.DIVISION_ID
                          AND  A.TO_SITE        = S1.SCM_SITE_ID
                          AND  S1.OSP_YN        ='N'
                          AND  S1.SCM_SITE_ID   LIKE '%-A'
                          AND  S1.SITE_TYPE     = 'PLANT'      
				  		      
                    WHERE 1 = 1                    
                    AND A.DIVISION_ID            = @p_division_id                    
                    AND A.PLAN_START_YYYYMMDD    = @p_plan_start_yyyymmdd                    
                    AND A.PLAN_TYPE              = @p_plan_type                    
                    AND A.SEQ                    = @p_seq    
                    AND A.TO_SITE               <> ''
				  
                    GROUP BY                 
                       A.DIVISION_ID                             
                      ,A.PLAN_START_YYYYMMDD                     
                      ,A.PLAN_TYPE                               
                      ,A.SEQ                                     
                      ,A.OPERATION_GROUP                         
                      ,A.FROM_SITE                      
                      ,A.ITEM_ID                                 
                      ,A.TO_SITE                      
                      ,CONVERT(CHAR(8), A.END_TIME, 112)             
                      ,A.ORIGIN_FROM_DIVISION_ID             
                      ,A.ORIGIN_TO_DIVISION_ID           
                      ,A.ELECTRODE_TYPE   
                      
                    UNION ALL  
                    -- 사내에서 외주OSP CELL SITE로 출하하는 정보로 외주OSP CELL SITE에 CELL이 도착하는 것으로 생성(P)
				    -- 도착일자 기준             
                    SELECT                     
                         A.DIVISION_ID                              
                        ,A.PLAN_START_YYYYMMDD                      
                        ,A.PLAN_TYPE                               
                        ,A.SEQ    
                        ,A.OPERATION_GROUP  
                        ,A.TO_SITE   AS FROM_SITE
                        ,A.ITEM_ID
                        ,'P'         AS PSI_TYPE            -- S,P,I                             
                        ,A.FROM_SITE AS PSI_VALUE                                
                        ,A.TO_SITE                               
                        ,A.TO_SITE   AS PROD_LINE
                        ,CONVERT(CHAR(8), A.END_TIME, 112)  AS YYYYMMDD                            
                        ,SUM(ISNULL(A.COMPLETE_QTY,0)) AS QTY                                     
                        ,'' AS INVENTORY_TYPE        
                        ,'40' AS ORIGIN_FROM_DIVISION_ID             
                        ,'40' AS ORIGIN_TO_DIVISION_ID           
                        ,A.ELECTRODE_TYPE   
          
                     FROM SCP_PLN_SHIPMENT_PLAN A    WITH (NOLOCK)     
                   
                      INNER JOIN SCP_MST_FINAL_ITEM F WITH(NOLOCK)
                          ON   A.DIVISION_ID      = F.DIVISION_ID
                          AND  A.ITEM_ID          = F.ITEM_ID
                          AND  F.OPERATION_GROUP  ='A'
                          AND  F.TCO_CELL_YN      ='N'
                      INNER JOIN SCM_MST_SITE S WITH(NOLOCK)
                          ON   A.DIVISION_ID      = S.DIVISION_ID
                          AND  A.FROM_SITE        = S.SCM_SITE_ID
                          AND  S.OSP_YN           ='N'
                          AND  S.SCM_SITE_ID    LIKE '%-A'
                          AND  S.SITE_TYPE      = 'PLANT'            
                      -- TO사이트는 외주OSP CELL SITE 조건추가
                      INNER JOIN SCM_MST_SITE S1 WITH(NOLOCK)
                          ON   A.DIVISION_ID    = S1.DIVISION_ID
                          AND  A.TO_SITE        = S1.SCM_SITE_ID
                          AND  S1.OSP_YN        ='Y'
                          AND  S1.SCM_SITE_ID   LIKE '%-A'
                          AND  S1.SITE_TYPE     = 'PLANT'      
				  		      
                    WHERE 1 = 1                    
                    AND A.DIVISION_ID            = @p_division_id                    
                    AND A.PLAN_START_YYYYMMDD    = @p_plan_start_yyyymmdd                    
                    AND A.PLAN_TYPE              = @p_plan_type                    
                    AND A.SEQ                    = @p_seq  
                    AND A.TO_SITE               <> ''
				  
                    GROUP BY                 
                       A.DIVISION_ID                             
                      ,A.PLAN_START_YYYYMMDD                     
                      ,A.PLAN_TYPE                               
                      ,A.SEQ                                     
                      ,A.OPERATION_GROUP                         
                      ,A.FROM_SITE                      
                      ,A.ITEM_ID                                 
                      ,A.TO_SITE                      
                      ,CONVERT(CHAR(8), A.END_TIME, 112)             
                      ,A.ORIGIN_FROM_DIVISION_ID             
                      ,A.ORIGIN_TO_DIVISION_ID           
                      ,A.ELECTRODE_TYPE   
                  ) X

		        -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
                SET @v_log_message = N'########## log step ##########';
                SET @v_description = @v_program_name + ':' + N' 00300 ';
                SET @d_event_date = SYSDATETIME();
		        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								            ,@p_log_type      = N'TXN'        
								            ,@p_log_count     = 0       
								            ,@p_log_message   = @v_log_message       
								            ,@p_description   = @v_description       
								            ,@p_event_date    = @d_event_date       
								            ,@p_user_id       = @v_batch_user      
                                            ;  
			  
      /* -- 20190625 ksg 주석 START
                 SELECT *
                 INTO #tmp_SCP_ANL_PSI_PRODUCTION_TCO
                 FROM (
                   SELECT  P.DIVISION_ID                              
                          ,P.PLAN_START_YYYYMMDD                      
                          ,P.PLAN_TYPE                               
                          ,P.SEQ    
                          ,P.OPERATION_GROUP  
                          ,P.FROM_SITE
                          ,(
                           SELECT TOP 1 CHILD_ITEM_ID
                        FROM dbo.SCM_MST_MODEL_FINAL_ITEM_BOM_V WITH (NOLOCK)
                            WHERE DIVISION_ID         = P.DIVISION_ID
                              AND MODEL_ID            = P.ITEM_ID
                              AND OPERATION_GROUP_ID  ='A'
                              AND CHILD_ITEM_ID     LIKE '_C%'
                           ) AS ITEM_ID -- CELL_ITEM_ID
                          ,'S'                 AS PSI_TYPE            -- S,P,I                             
                          ,P.FROM_SITE AS PSI_VALUE                                
                          ,P.TO_SITE                                  
  --                        ,'' AS PROD_LINE                                
                          ,P.FROM_SITE AS PROD_LINE
                          ,P.YYYYMMDD                                 
                          ,P.QTY                                      
                          ,'' AS INVENTORY_TYPE        
                          ,'40' AS ORIGIN_FROM_DIVISION_ID             
                          ,'40' AS ORIGIN_TO_DIVISION_ID           
                          ,P.ELECTRODE_TYPE       
                    FROM #tmp_SCP_ANL_PSI_PRODUCTION P WITH(NOLOCK)
                    INNER JOIN SCP_MST_FINAL_ITEM F WITH(NOLOCK)
                          ON   P.DIVISION_ID = F.DIVISION_ID
                          AND  P.ITEM_ID     = F.ITEM_ID
                          AND  F.TCO_CELL_YN ='Y'
                    INNER JOIN SCM_MST_SITE S WITH(NOLOCK)
                          ON   P.DIVISION_ID = S.DIVISION_ID
                          AND  P.FROM_SITE   = S.SCM_SITE_ID
                        -- AND  S.OSP_YN      ='Y'
                          AND  S.SCM_SITE_ID LIKE '%-A'
                          AND  S.SITE_TYPE   = 'PLANT'
                   WHERE 1=1
                     AND P.PSI_TYPE            = 'P' -- PRODUCTION

                    UNION ALL
                    -- 사내에서 외주OSP CELL SITE로 출하하는 정보로 외주OSP CELL SITE에 CELL이 도착하는 것으로 생성(P)
                    -- BOD L/T반영
                    SELECT  P.DIVISION_ID                              
                        ,P.PLAN_START_YYYYMMDD                      
                        ,P.PLAN_TYPE                               
                        ,P.SEQ    
                        ,P.OPERATION_GROUP  
                        ,P.PSI_VALUE AS FROM_SITE
                        ,P.ITEM_ID
                        ,'P'     AS PSI_TYPE            -- S,P,I                             
                        ,P.FROM_SITE AS PSI_VALUE                                
                        ,P.TO_SITE                               
                        ,P.TO_SITE AS PROD_LINE
                        ,P.YYYYMMDD                                 
                        ,P.QTY                                      
                        ,'' AS INVENTORY_TYPE        
                        ,'40' AS ORIGIN_FROM_DIVISION_ID             
                        ,'40' AS ORIGIN_TO_DIVISION_ID           
                        ,P.ELECTRODE_TYPE       
                  FROM #tmp_SCP_ANL_PSI_PRODUCTION P WITH(NOLOCK)
                  INNER JOIN SCP_MST_FINAL_ITEM F WITH(NOLOCK)
                        ON   P.DIVISION_ID      = F.DIVISION_ID
                        AND  P.ITEM_ID          = F.ITEM_ID
                        AND  F.OPERATION_GROUP  ='A'
                        AND  F.TCO_CELL_YN      ='Y'
                  INNER JOIN SCM_MST_SITE S WITH(NOLOCK)
                        ON   P.DIVISION_ID      = S.DIVISION_ID
                        AND  P.FROM_SITE        = S.SCM_SITE_ID
                        AND  S.OSP_YN           ='Y'
                        AND  S.SCM_SITE_ID    LIKE '%-A'
                        AND  S.SITE_TYPE      = 'PLANT'             
                  -- TO사이트는 사내 CELL SITE 조건추가
                  INNER JOIN SCM_MST_SITE S1 WITH(NOLOCK)
                        ON   P.DIVISION_ID    = S1.DIVISION_ID
                        AND  P.PSI_VALUE      = S1.SCM_SITE_ID
                        AND  S1.OSP_YN        ='N'
                        AND  S1.SCM_SITE_ID   LIKE '%-A'
                        AND  S1.SITE_TYPE     = 'PLANT'             
                  WHERE 1=1
                    AND P.PSI_TYPE            = 'S' -- PRODUCTION   
                    AND P.PSI_VALUE           <> ''   
                 UNION ALL
                 -- 외주OSP CELL SITE에서 사내로 출하하는 TCO CELL정보로 사내 CELL SITE에 TCO CELL이 도착하는 것으로 생성(P)
                 -- BOD L/T반영
                    SELECT  P.DIVISION_ID                              
                        ,P.PLAN_START_YYYYMMDD                      
                        ,P.PLAN_TYPE                               
                        ,P.SEQ    
                        ,P.OPERATION_GROUP  
                        ,P.PSI_VALUE AS FROM_SITE
                        ,P.ITEM_ID
                        ,'P'     AS PSI_TYPE            -- S,P,I                             
                        ,P.FROM_SITE AS PSI_VALUE                                
                        ,P.TO_SITE                               
                        ,P.TO_SITE AS PROD_LINE
                        ,P.YYYYMMDD                                 
                        ,P.QTY                                      
                        ,'' AS INVENTORY_TYPE        
                        ,'40' AS ORIGIN_FROM_DIVISION_ID             
                        ,'40' AS ORIGIN_TO_DIVISION_ID           
                        ,P.ELECTRODE_TYPE       
                  FROM #tmp_SCP_ANL_PSI_PRODUCTION P WITH(NOLOCK)
                  INNER JOIN SCP_MST_FINAL_ITEM F WITH(NOLOCK)
                        ON   P.DIVISION_ID      = F.DIVISION_ID
                        AND  P.ITEM_ID          = F.ITEM_ID
                        AND  F.OPERATION_GROUP  ='A'
                        AND  F.TCO_CELL_YN      ='N'
                  INNER JOIN SCM_MST_SITE S WITH(NOLOCK)
                        ON   P.DIVISION_ID      = S.DIVISION_ID
                        AND  P.FROM_SITE        = S.SCM_SITE_ID
                        AND  S.OSP_YN           ='N'
                        AND  S.SCM_SITE_ID    LIKE '%-A'
                        AND  S.SITE_TYPE      = 'PLANT'             
                  -- TO사이트는 사내 CELL SITE 조건추가
                  INNER JOIN SCM_MST_SITE S1 WITH(NOLOCK)
                        ON   P.DIVISION_ID    = S1.DIVISION_ID
                        AND  P.PSI_VALUE      = S1.SCM_SITE_ID
                        AND  S1.OSP_YN        ='Y'
                        AND  S1.SCM_SITE_ID   LIKE '%-A'
                        AND  S1.SITE_TYPE     = 'PLANT'             
                  WHERE 1=1
    --                AND P.ITEM_ID             = 'MTR496080A11'  --OSP TCO
                    AND P.PSI_TYPE            = 'S' -- PRODUCTION   
                    AND P.PSI_VALUE           <> ''   
                ) X
      */ -- 20190625 ksg 주석 END

            INSERT INTO #tmp_SCP_ANL_PSI_PRODUCTION                    
                      (                    
                       DIVISION_ID                              
                      ,PLAN_START_YYYYMMDD                      
                      ,PLAN_TYPE                               
                      ,SEQ                                      
                      ,OPERATION_GROUP                          
                      ,FROM_SITE                                
                      ,ITEM_ID                                  
                      ,PSI_TYPE                                 
                      ,PSI_VALUE                                
                      ,TO_SITE                                  
                      ,PROD_LINE                                
                      ,YYYYMMDD         
                      ,QTY                                     
                      ,INVENTORY_TYPE        
                      ,ORIGIN_FROM_DIVISION_ID             
                      ,ORIGIN_TO_DIVISION_ID           
                      ,ELECTRODE_TYPE       
                      --,ATTRIBUTE10      -- TCO 가상 출하 구분을 위해서    
                       )         
                  -- 외주 TCO CELL SITE의 TCO 생산 => 동일사이트 CELL 소비(SHIPMENT)
                  -- 사내 TCO 생산 => 동일사이트 CELL 소비(SHIPMENT)

                  SELECT DIVISION_ID                              
                      ,PLAN_START_YYYYMMDD                      
                      ,PLAN_TYPE                               
                      ,SEQ                                      
                      ,OPERATION_GROUP                          
                      ,FROM_SITE                                
                      ,ITEM_ID                                  
                      ,PSI_TYPE                                 
                      ,PSI_VALUE                                
                      ,TO_SITE                                  
                      ,PROD_LINE                                
                      ,YYYYMMDD                                 
                      ,QTY                                      
                      ,INVENTORY_TYPE        
                      ,ORIGIN_FROM_DIVISION_ID             
                      ,ORIGIN_TO_DIVISION_ID           
                      ,ELECTRODE_TYPE       
                      --,ATTRIBUTE10  
                  FROM #tmp_SCP_ANL_PSI_PRODUCTION_TCO WITH (NOLOCK)


              END

		    -- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
            SET @v_log_message = N'########## log step ##########';
            SET @v_description = @v_program_name + ':' + N' 00400 ';
            SET @d_event_date = SYSDATETIME();
		    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								        ,@p_log_type      = N'TXN'        
								        ,@p_log_count     = 0       
								        ,@p_log_message   = @v_log_message       
								        ,@p_description   = @v_description       
								        ,@p_event_date    = @d_event_date       
								        ,@p_user_id       = @v_batch_user      
                                        ;  
              

            -------------------------------------------------------------------------------------------------------------                     
            -- 4. STOCK 입력 - SPI_TYPE ='I'                    
            -------------------------------------------------------------------------------------------------------------                     
            -- I    ACTIVATE_COMPLETED  C   활성화 완료                    
            -- I    ACTIVATE_PROGRESS   P   활성화 진행중                    
            -- I    MODEL_INVENTORY     I                       
            -------------------------------------------------------------------------------------------------------------                  
      
              INSERT INTO #tmp_SCP_ANL_PSI_PRODUCTION                    
                  (                    
                   DIVISION_ID                              
                  ,PLAN_START_YYYYMMDD                      
                  ,PLAN_TYPE                                
                  ,SEQ                                      
                  ,OPERATION_GROUP                          
                  ,FROM_SITE                            
                  ,ITEM_ID                                  
                  ,PSI_TYPE                                 
                  ,PSI_VALUE                                
                  ,TO_SITE                                  
                  ,PROD_LINE                                
                  ,YYYYMMDD                                 
                  ,QTY                                      
                  ,INVENTORY_TYPE           
                  ,ORIGIN_FROM_DIVISION_ID             
                  ,ORIGIN_TO_DIVISION_ID           
                  ,ELECTRODE_TYPE         
                  )                
            -------------------------------------------------------------------------------------------------------------                     
            -- 4.1 전극,팩 EOH 재고                   
            -------------------------------------------------------------------------------------------------------------             
        
         
              SELECT       
                       A.DIVISION_ID                      
                      ,A.PLAN_START_YYYYMMDD                     
                      ,A.PLAN_TYPE                               
                      ,A.SEQ                                     
                      ,A.OPERATION_GROUP                         
                      ,A.SITE_ID              AS FROM_SITE                               
                      ,A.ITEM_ID                                 
                      ,'I'                    AS PSI_TYPE            -- S,P,I                    
                      ,'MODEL_INVENTORY'      AS PSI_VALUE                    
                      ,''                     AS TO_SITE                    
                      ,''                     AS PROD_LINE                               
                      ,A.YYYYMMDD                                
                      ,SUM(ISNULL(A.PSI_EOH_QTY,0))    AS QTY                                                  
                      ,'I'                    AS INVENTORY_TYPE          --재고구분             
                      ,A.ORIGIN_DIVISION_ID             
                      ,''                     AS ORIGIN_TO_DIVISION_ID           
                      ,A.ELECTRODE_TYPE             
                FROM SCP_PLN_PLANT_ONHAND A WITH(NOLOCK)                    
               WHERE 1 = 1                    
                 AND A.DIVISION_ID           = @p_division_id                    
                 AND A.PLAN_START_YYYYMMDD   = @p_plan_start_yyyymmdd                    
                 AND A.PLAN_TYPE             = @p_plan_type                    
                 AND A.SEQ                   = @p_seq              
                 AND A.SITE_ID               NOT LIKE '%-A' --CELL PLANT제외       
                 AND A.OPERATION_GROUP       <> 'A' --CELL PLANT제외                     
               GROUP BY                     
                       A.DIVISION_ID                             
                      ,A.PLAN_START_YYYYMMDD                     
                      ,A.PLAN_TYPE                               
                      ,A.SEQ                                     
                      ,A.OPERATION_GROUP                         
                      ,A.SITE_ID                      
                      ,A.ITEM_ID                              
                      ,A.YYYYMMDD        
                      ,A.ORIGIN_DIVISION_ID             
                      ,A.ELECTRODE_TYPE                     
               UNION ALL                    
           -------------------------------------------------------------------------------------------------------------                     
           -- 4.2 셀 EOH 특성완료재고(MODEL INVENTORY)=CHAR                
           -------------------------------------------------------------------------------------------------------------                
                
                SELECT A.DIVISION_ID                             
                      ,A.PLAN_START_YYYYMMDD                     
                      ,A.PLAN_TYPE                               
                      ,A.SEQ                                     
                      ,A.OPERATION_GROUP                         
                      ,A.SITE_ID              AS FROM_SITE                               
                      ,A.ITEM_ID                                 
                      ,'I'                    AS PSI_TYPE            -- S,P,I                    
                      ,'MODEL_INVENTORY'      AS PSI_VALUE                    
                      ,''                     AS TO_SITE                    
                      ,''                     AS PROD_LINE                               
                      ,A.YYYYMMDD                                
                      ,SUM(ISNULL(A.PSI_EOH_QTY,0))   AS QTY                                      
                      ,'I'                    AS INVENTORY_TYPE          --재고구분      
                      ,A.ORIGIN_DIVISION_ID             
                      ,''                     AS ORIGIN_TO_DIVISION_ID           
                      ,A.ELECTRODE_TYPE                    
                FROM SCP_PLN_PLANT_ONHAND A WITH(NOLOCK)                    
               WHERE 1 = 1                 
                 AND A.DIVISION_ID           = @p_division_id                    
                 AND A.PLAN_START_YYYYMMDD   = @p_plan_start_yyyymmdd                    
                 AND A.PLAN_TYPE             = @p_plan_type                    
                 AND A.SEQ                   = @p_seq                    
                 AND A.STOCK_TYPE            IN ( 'CHAR', 'A_MOVE_WH','A_OUT_WH')                   
               GROUP BY                     
                       A.DIVISION_ID                             
                      ,A.PLAN_START_YYYYMMDD                     
                      ,A.PLAN_TYPE                               
                      ,A.SEQ                                     
                      ,A.OPERATION_GROUP                         
                      ,A.SITE_ID                      
                      ,A.ITEM_ID                              
                      ,A.YYYYMMDD         
                      ,A.ORIGIN_DIVISION_ID             
                      ,A.ELECTRODE_TYPE                           
              UNION ALL            
                         
           -------------------------------------------------------------------------------------------------------------                     
           -- 4.3 셀 특성완료 생산계획=F6000 생산계획                  
           -------------------------------------------------------------------------------------------------------------                
                SELECT A.DIVISION_ID                             
                      ,A.PLAN_START_YYYYMMDD                     
                      ,A.PLAN_TYPE                               
                      ,A.SEQ                                     
                      ,A.OPERATION_GROUP                         
                      ,A.SITE_ID                AS FROM_SITE                         
                      ,A.ITEM_ID                                 
                      ,'I'                      AS PSI_TYPE            -- S,P,I                    
                      ,'ACTIVATE_COMPLETED'     AS PSI_VALUE                    
                      ,''                  AS TO_SITE                    
         ,''                       AS PROD_LINE                               
                      ,CONVERT(VARCHAR(8),A.END_TIME,112)   AS YYYYMMDD                                
--                      ,ROUND(SUM(ISNULL(A.COMPLETE_QTY,0)),0)  AS QTY                       
                      ,SUM(ISNULL(A.COMPLETE_QTY,0))  AS QTY                                                  
                      ,'C'                      AS INVENTORY_TYPE          --재고구분            
                       ,A.ORIGIN_DIVISION_ID             
                      ,''                       AS ORIGIN_TO_DIVISION_ID           
                      ,A.ELECTRODE_TYPE             
--                      ,A.ATTRIBUTE7
                FROM SCP_PLN_PRODUCTION_PLAN A WITH(NOLOCK)                    
               WHERE 1 = 1                    
                 AND A.DIVISION_ID           = @p_division_id                    
                 AND A.PLAN_START_YYYYMMDD   = @p_plan_start_yyyymmdd                 
                 AND A.PLAN_TYPE             = @p_plan_type                    
                 AND A.SEQ                   = @p_seq                    
                 AND A.OPERATION_ID          = 'F6000'                    
               GROUP BY        
                      A.DIVISION_ID                   
                     ,A.PLAN_START_YYYYMMDD                     
                     ,A.PLAN_TYPE                               
                     ,A.SEQ                                     
                     ,A.OPERATION_GROUP                         
                     ,A.SITE_ID                      
                     ,A.ITEM_ID                              
                     ,CONVERT(VARCHAR(8),A.END_TIME,112)          
                     ,A.ORIGIN_DIVISION_ID             
                     ,A.ELECTRODE_TYPE             
--                     ,A.ATTRIBUTE7          
              UNION ALL                    
           -------------------------------------------------------------------------------------------------------------        
           -- 4.4 셀 해당일자의 CHAR_AVAILABLE  (특성완료)= ('FORMED')         
           -------------------------------------------------------------------------------------------------------------                
                SELECT A.DIVISION_ID                             
                      ,A.PLAN_START_YYYYMMDD                     
                      ,A.PLAN_TYPE                               
                      ,A.SEQ                                     
                      ,A.OPERATION_GROUP                         
                      ,A.SITE_ID              AS FROM_SITE                               
                      ,A.ITEM_ID                                 
                      ,'I'                    AS PSI_TYPE            -- S,P,I                    
                      ,'CHAR_AVAILABLE'       AS PSI_VALUE                    
                      ,''                     AS TO_SITE                    
                      ,''                     AS PROD_LINE                               
                      ,A.YYYYMMDD     
                      ,SUM(ISNULL(A.PSI_EOH_QTY,0))   AS QTY                                                  
                      ,'P'                    AS INVENTORY_TYPE          --재고구분      
                      ,A.ORIGIN_DIVISION_ID             
                      ,''                     AS ORIGIN_TO_DIVISION_ID           
                      ,A.ELECTRODE_TYPE                           
                FROM SCP_PLN_PLANT_ONHAND A WITH(NOLOCK)                   
                 WHERE 1 = 1           
                  AND A.DIVISION_ID           = @p_division_id                    
                  AND A.PLAN_START_YYYYMMDD   = @p_plan_start_yyyymmdd                    
                  AND A.PLAN_TYPE             = @p_plan_type                    
                  AND A.SEQ                  = @p_seq                    
                  AND A.STOCK_TYPE            = 'FORMED'                    
                GROUP BY                     
                       A.DIVISION_ID                             
                      ,A.PLAN_START_YYYYMMDD                     
                      ,A.PLAN_TYPE                               
                      ,A.SEQ                                     
                      ,A.OPERATION_GROUP                         
                      ,A.SITE_ID                      
                      ,A.ITEM_ID                              
                      ,A.YYYYMMDD                 
                      ,A.ORIGIN_DIVISION_ID             
                      ,A.ELECTRODE_TYPE                
      
                UNION ALL      
           -------------------------------------------------------------------------------------------------------------                     
           -- 4.5 셀 해당일자의 활성화진행중(특성완료전)= ('ASSM','FORMING','FORMED','CHARING','FOR_STOCKPLAN')                   
           -------------------------------------------------------------------------------------------------------------            
                SELECT A.DIVISION_ID                             
                     ,A.PLAN_START_YYYYMMDD                     
                      ,A.PLAN_TYPE                               
                      ,A.SEQ                                     
                      ,A.OPERATION_GROUP                         
                      ,A.SITE_ID              AS FROM_SITE                               
                      ,A.ITEM_ID                                 
                      ,'I'                    AS PSI_TYPE            -- S,P,I                    
                      ,'ACTIVATE_PROGRESS'    AS PSI_VALUE                    
                      ,''                     AS TO_SITE                    
                      ,''                     AS PROD_LINE                               
                      ,A.YYYYMMDD                                
                      ,SUM(ISNULL(A.PSI_EOH_QTY,0))   AS QTY                                                  
                      ,'P'                    AS INVENTORY_TYPE          --재고구분          
                      ,A.ORIGIN_DIVISION_ID             
                      ,''                     AS ORIGIN_TO_DIVISION_ID           
                      ,A.ELECTRODE_TYPE                       
                FROM SCP_PLN_PLANT_ONHAND A WITH(NOLOCK)                   
                 WHERE 1 = 1           
                  AND A.DIVISION_ID           = @p_division_id                    
                  AND A.PLAN_START_YYYYMMDD   = @p_plan_start_yyyymmdd                    
                  AND A.PLAN_TYPE             = @p_plan_type                    
                  AND A.SEQ                   = @p_seq                    
                  AND A.STOCK_TYPE            IN ( 'ASSM','FORMING','FORMED','CHARING','FOR_STOCKPLAN' )                    
                GROUP BY                     
                       A.DIVISION_ID                             
                      ,A.PLAN_START_YYYYMMDD              
                      ,A.PLAN_TYPE                               
                      ,A.SEQ                       
                      ,A.OPERATION_GROUP                         
                      ,A.SITE_ID                      
                      ,A.ITEM_ID                              
                      ,A.YYYYMMDD                   
                      ,A.ORIGIN_DIVISION_ID             
                      ,A.ELECTRODE_TYPE              
--                order by ITEM_ID, YYYYMMDD                  
                      ;                         

		-- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
        SET @v_log_message = N'########## log step ##########';
        SET @v_description = @v_program_name + ':' + N' 00500 ';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								    ,@p_log_type      = N'TXN'        
								    ,@p_log_count     = 0       
								    ,@p_log_message   = @v_log_message       
								    ,@p_description   = @v_description       
								    ,@p_event_date    = @d_event_date       
								    ,@p_user_id       = @v_batch_user      
                                    ;  
                
         -------------------------------------------------------------------------------------------------------------                     
          -- 4.6 SCP_ANL_PSI_PRODUCTION MEASURE별 짝 맞추기 데이타 입력                     
          -------------------------------------------------------------------------------------------------------------                
           /*                
            * 재고 또는 생산이 존재하지만, 출하가 존재하지 않는 경우 0으로 SHIPMENT MEASURE 생성                
            */                           
           INSERT INTO  #tmp_SCP_ANL_PSI_PRODUCTION                 
                      ( DIVISION_ID                
                       ,PLAN_START_YYYYMMDD                
                       ,PLAN_TYPE                
                       ,SEQ                
                       ,OPERATION_GROUP                
                       ,FROM_SITE                
                       ,ITEM_ID                
                       ,PSI_TYPE                
                       ,PSI_VALUE                
                       ,YYYYMMDD                
--                       ,ELECTRODE_TYPE                
                       ,QTY                
                       ,TO_SITE                
                       ,PROD_LINE                
                       ,INVENTORY_TYPE                
             
              )                
                SELECT  DIVISION_ID                
                       ,PLAN_START_YYYYMMDD                
                       ,PLAN_TYPE                
                       ,SEQ                
                       ,OPERATION_GROUP                
                       ,FROM_SITE                
                       ,ITEM_ID                
                       ,'S'    AS PSI_TYPE                
                       ,''     AS PSI_VALUE                
                       ,YYYYMMDD                
                      -- ,ELECTRODE_TYPE                
                       ,0.0   AS QTY                
                       ,''    AS TO_SITE                
                       ,''    AS PROD_LINE                
                       ,''    AS INVENTORY_TYPE                
                  FROM                
                       (                
                          SELECT CONVERT(VARCHAR(8),START_DTTM,112) AS YYYYMMDD             
                            FROM TH_ENG_BUCKET_INFO_SN WITH(NOLOCK)                  
                           WHERE PLAN_ID    = @p_engine_plan_id --'1022::PR::1'                  
                            AND MASTER_ID   = @p_master_id      -- '81::WEEKLY'                
                       ) A,                
                       (                
                         SELECT DISTINCT DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,FROM_SITE,ITEM_ID--,ELECTRODE_TYPE                
                           FROM #tmp_SCP_ANL_PSI_PRODUCTION X WITH(NOLOCK)                
                          WHERE 1=1                
                            AND DIVISION_ID         = @p_division_id--'81'                
                            AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd--'20180416'                
                            AND PLAN_TYPE           = @p_plan_type--'PR'          
                            AND SEQ                 = @p_seq --1                
                            AND PSI_TYPE            IN ( 'I','P')                
                           -- AND INVENTORY_TYPE      IN ('I','C','P')                
                            AND NOT EXISTS (                
                                           SELECT 'X'                
                                             FROM #tmp_SCP_ANL_PSI_PRODUCTION Z WITH(NOLOCK)                
                                            WHERE 1=1                
                                              AND Z.DIVISION_ID         = X.DIVISION_ID                
                                              AND Z.PLAN_START_YYYYMMDD = X.PLAN_START_YYYYMMDD                
                                              AND Z.PLAN_TYPE           = X.PLAN_TYPE                
                                              AND Z.SEQ                 = X.SEQ                
                                              AND Z.PSI_TYPE            = 'S'                
                                              AND Z.ITEM_ID             = X.ITEM_ID                
                                              AND Z.FROM_SITE           = X.FROM_SITE                
                                           )                
                       ) B;                  
                
		-- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
        SET @v_log_message = N'########## log step ##########';
        SET @v_description = @v_program_name + ':' + N' 00600 ';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								    ,@p_log_type      = N'TXN'        
								    ,@p_log_count     = 0       
								    ,@p_log_message   = @v_log_message       
								    ,@p_description   = @v_description       
								    ,@p_event_date    = @d_event_date       
								    ,@p_user_id       = @v_batch_user      
                                    ;  


           /*                
            * 재고 또는 출하가  존재하지만, 생산이  존재하지 않는 경우 0으로 PRODUCTION MEASURE 생성                
            */                             
           INSERT INTO  #tmp_SCP_ANL_PSI_PRODUCTION                 
                      ( DIVISION_ID                
                       ,PLAN_START_YYYYMMDD                
                       ,PLAN_TYPE                
                       ,SEQ                
                       ,OPERATION_GROUP                
             ,FROM_SITE                
                       ,ITEM_ID                
                      ,PSI_TYPE                
                       ,PSI_VALUE                
                       ,YYYYMMDD                
--                       ,ELECTRODE_TYPE                
                       ,QTY                
                       ,TO_SITE                
                       ,PROD_LINE                
                       ,INVENTORY_TYPE                
              
                       )                
                SELECT  DIVISION_ID                
                       ,PLAN_START_YYYYMMDD                
                       ,PLAN_TYPE                
                       ,SEQ                
                       ,OPERATION_GROUP                
                       ,FROM_SITE                
                       ,ITEM_ID                
                       ,'P'    AS PSI_TYPE                
                       ,''     AS PSI_VALUE                
                       ,YYYYMMDD                
--                       ,ELECTRODE_TYPE                
                       ,0.0   AS QTY                
                       ,''    AS TO_SITE                
                       ,''    AS PROD_LINE                
                       ,''    AS INVENTORY_TYPE                
              
                  FROM                
                       (                
                          SELECT CONVERT(VARCHAR(8),START_DTTM,112) AS YYYYMMDD                  
                            FROM TH_ENG_BUCKET_INFO_SN WITH(NOLOCK)                  
                           WHERE PLAN_ID        = @p_engine_plan_id   --'1022::PR::1'                  
                            AND MASTER_ID       = @p_master_id        --'82::WEEKLY'                
                       ) A,                
                       (                
                         SELECT DISTINCT DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,FROM_SITE,ITEM_ID--,ELECTRODE_TYPE                
                           FROM #tmp_SCP_ANL_PSI_PRODUCTION X WITH(NOLOCK)                
                          WHERE 1=1                
                            AND DIVISION_ID         = @p_division_id          --'81'                
                            AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd  --'20180416'                
                            AND PLAN_TYPE           = @p_plan_type            --'PR'                
                            AND SEQ                 = @p_seq                  --1                
                            AND PSI_TYPE            IN ( 'I','S' )                
                            AND NOT EXISTS (                
                                           SELECT 'X'                
                                             FROM #tmp_SCP_ANL_PSI_PRODUCTION Z WITH(NOLOCK)                
                                            WHERE 1=1                
                                              AND Z.DIVISION_ID         = X.DIVISION_ID                
                                              AND Z.PLAN_START_YYYYMMDD = X.PLAN_START_YYYYMMDD                
                                              AND Z.PLAN_TYPE           = X.PLAN_TYPE                
                                              AND Z.SEQ                 = X.SEQ           
                                              AND Z.PSI_TYPE            = 'P'                
                                              AND Z.ITEM_ID             = X.ITEM_ID                
                                              AND Z.FROM_SITE           = X.FROM_SITE                
                                           )                
                       ) B;      
                       
		-- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
        SET @v_log_message = N'########## log step ##########';
        SET @v_description = @v_program_name + ':' + N' 00700 ';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								    ,@p_log_type      = N'TXN'        
								    ,@p_log_count     = 0       
								    ,@p_log_message   = @v_log_message       
								    ,@p_description   = @v_description       
								    ,@p_event_date    = @d_event_date       
								    ,@p_user_id       = @v_batch_user      
                                    ;  

                
           /*                
            * 출하가  존재하지만, 특정일자구간에 출하가 존재하지않는 경우 화면에 표현될 수 있도록 0으로 출하정보생성                
            */                            
INSERT INTO  #tmp_SCP_ANL_PSI_PRODUCTION                 
                      ( DIVISION_ID                
                       ,PLAN_START_YYYYMMDD                
                       ,PLAN_TYPE                
                       ,SEQ                
                       ,OPERATION_GROUP                
                       ,FROM_SITE                
                       ,ITEM_ID                
                       ,PSI_TYPE                
                       ,PSI_VALUE                
                       ,YYYYMMDD                
--                       ,ELECTRODE_TYPE                
                       ,QTY                
                       ,TO_SITE                
                       ,PROD_LINE                
                       ,INVENTORY_TYPE       
                       ,TO_SITE_ORG             
             
                       )                
                SELECT  DIVISION_ID                
                       ,PLAN_START_YYYYMMDD                
                       ,PLAN_TYPE                
                       ,SEQ                
                       ,OPERATION_GROUP                
                       ,FROM_SITE                
                       ,ITEM_ID                
                       ,PSI_TYPE                
                       ,PSI_VALUE                
                       ,YYYYMMDD                
--                       ,ELECTRODE_TYPE                
                       ,0.0   AS QTY                
                       ,''    AS TO_SITE                
                       ,''    AS PROD_LINE                
                       ,''    AS INVENTORY_TYPE                
                       ,TO_SITE    
            FROM                 
                (                
                    SELECT                 
                           B.PSI_VALUE,DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,FROM_SITE,ITEM_ID,PSI_TYPE,A.YYYYMMDD--,ELECTRODE_TYPE        
                           ,TO_SITE            
                     FROM                
                          (                
                             SELECT CONVERT(VARCHAR(8),START_DTTM,112) AS YYYYMMDD                  
                               FROM TH_ENG_BUCKET_INFO_SN WITH(NOLOCK)                  
                              WHERE PLAN_ID         = @p_engine_plan_id   --'1022::PR::1'                  
                               AND MASTER_ID        = @p_master_id        --'81::WEEKLY'          
                          ) A,                
                          (                
                            SELECT DISTINCT PSI_VALUE,DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,FROM_SITE,ITEM_ID,PSI_TYPE--,ELECTRODE_TYPE                
                                , TO_SITE    
                              FROM #tmp_SCP_ANL_PSI_PRODUCTION X WITH(NOLOCK)                
                             WHERE 1=1                
                               AND DIVISION_ID         = @p_division_id         --'81'                
                               AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd --'20180416'                
                               AND PLAN_TYPE           = @p_plan_type           --'PR'                
                               AND SEQ                 = @p_seq                 --1                
                               AND PSI_TYPE            = 'S'                
                               AND PSI_VALUE       <> ''                
                          ) B                
                ) SUB                
                WHERE 1=1                
                  AND NOT EXISTS (                
                                   SELECT 'X'                
             FROM #tmp_SCP_ANL_PSI_PRODUCTION Z WITH(NOLOCK)                
                                    WHERE 1=1                
                                      AND Z.DIVISION_ID         = SUB.DIVISION_ID                
                                      AND Z.PLAN_START_YYYYMMDD = SUB.PLAN_START_YYYYMMDD                
                                      AND Z.PLAN_TYPE           = SUB.PLAN_TYPE                
                                      AND Z.SEQ                 = SUB.SEQ                
                                      AND Z.PSI_TYPE            = SUB.PSI_TYPE                
                                      AND Z.ITEM_ID             = SUB.ITEM_ID                
                                      AND Z.FROM_SITE           = SUB.FROM_SITE                
                                      AND Z.PSI_VALUE           = SUB.PSI_VALUE                
                                      AND Z.YYYYMMDD            = SUB.YYYYMMDD                
                                      AND Z.TO_SITE             = SUB.TO_SITE         
                                 );             
                                       

		-- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
        SET @v_log_message = N'########## log step ##########';
        SET @v_description = @v_program_name + ':' + N' 00800 ';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								    ,@p_log_type      = N'TXN'        
								    ,@p_log_count     = 0       
								    ,@p_log_message   = @v_log_message       
								    ,@p_description   = @v_description       
								    ,@p_event_date    = @d_event_date       
								    ,@p_user_id       = @v_batch_user      
                                    ;  

                
           /*                
            * 생산이 존재하지만, 특정일자구간에 생산계획이 존재하지않는 경우 화면에 표현될 수 있도록 0으로 생산정보생성                
            */         
           INSERT INTO  #tmp_SCP_ANL_PSI_PRODUCTION                 
                      ( DIVISION_ID                
                       ,PLAN_START_YYYYMMDD                
                       ,PLAN_TYPE                
                       ,SEQ                
                       ,OPERATION_GROUP                
                        ,FROM_SITE                
                       ,ITEM_ID                
                       ,PSI_TYPE                
                       ,PSI_VALUE                
                       ,YYYYMMDD                
--                       ,ELECTRODE_TYPE                
                       ,QTY                
                       ,TO_SITE                
                       ,PROD_LINE                
                       ,INVENTORY_TYPE                
             
                       )                
                SELECT  DIVISION_ID                
                       ,PLAN_START_YYYYMMDD                
                       ,PLAN_TYPE                
                       ,SEQ                
                       ,OPERATION_GROUP                
                       ,FROM_SITE                
                       ,ITEM_ID           
                       ,PSI_TYPE                
                       ,PSI_VALUE                
                       ,YYYYMMDD                
--        ,ELECTRODE_TYPE                
                       ,0.0   AS QTY                
                       ,''    AS TO_SITE                
                       ,''    AS PROD_LINE                
                       ,''    AS INVENTORY_TYPE                
                                  
            FROM                
                (                
                    SELECT                 
                           B.PSI_VALUE,DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,FROM_SITE,ITEM_ID,PSI_TYPE,A.YYYYMMDD--,ELECTRODE_TYPE                
                     FROM                
                          (                
              SELECT CONVERT(VARCHAR(8),START_DTTM,112) AS YYYYMMDD                  
                               FROM TH_ENG_BUCKET_INFO_SN WITH(NOLOCK)                  
                              WHERE PLAN_ID       = @p_engine_plan_id   --'1021::PR::1'                  
                               AND MASTER_ID      = @p_master_id        --'81::WEEKLY'                
                          ) A,            
                          (         
                            SELECT DISTINCT PSI_VALUE,DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,FROM_SITE,ITEM_ID,PSI_TYPE--,ELECTRODE_TYPE                
                              FROM #tmp_SCP_ANL_PSI_PRODUCTION X WITH(NOLOCK)
                
                             WHERE 1=1                
                               AND DIVISION_ID         = @p_division_id         --'81'                
                               AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd --'20180416'                
                               AND PLAN_TYPE           = @p_plan_type           --'PR'                
                               AND SEQ                 = @p_seq                 --1                
                               AND PSI_TYPE            = 'P'                
                               AND PSI_VALUE           <> ''                
                          ) B                
                ) SUB                
                WHERE 1=1                
                  AND NOT EXISTS (                
                                   SELECT 'X'                
                                     FROM #tmp_SCP_ANL_PSI_PRODUCTION Z WITH(NOLOCK)                
                                    WHERE 1=1                
                                      AND Z.DIVISION_ID         = SUB.DIVISION_ID                
                                      AND Z.PLAN_START_YYYYMMDD = SUB.PLAN_START_YYYYMMDD                
                                   AND Z.PLAN_TYPE           = SUB.PLAN_TYPE                
                                      AND Z.SEQ                 = SUB.SEQ              
                                      AND Z.PSI_TYPE            = SUB.PSI_TYPE                
                                      AND Z.ITEM_ID             = SUB.ITEM_ID                
                                      AND Z.FROM_SITE           = SUB.FROM_SITE                
                                      AND Z.PSI_VALUE           = SUB.PSI_VALUE                
                                      AND Z.YYYYMMDD            = SUB.YYYYMMDD                
                                 );                
                
		-- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
        SET @v_log_message = N'########## log step ##########';
        SET @v_description = @v_program_name + ':' + N' 00900 ';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								    ,@p_log_type      = N'TXN'        
								    ,@p_log_count     = 0       
								    ,@p_log_message   = @v_log_message       
								    ,@p_description   = @v_description       
								    ,@p_event_date    = @d_event_date       
								    ,@p_user_id       = @v_batch_user      
                                    ;  


           /*                
            * 셀에 대하여 특정기간에 활성화완료계획이 존재하지 않으면, 0으로 특성완료 계획데이타 생성                
            */                                                   
          INSERT INTO  #tmp_SCP_ANL_PSI_PRODUCTION                 
                      ( DIVISION_ID                
                       ,PLAN_START_YYYYMMDD                
                       ,PLAN_TYPE    
                       ,SEQ                
                        ,OPERATION_GROUP                
                       ,FROM_SITE                
                       ,ITEM_ID                
                       ,PSI_TYPE                
                       ,PSI_VALUE                
                       ,YYYYMMDD                
--                       ,ELECTRODE_TYPE                
                       ,QTY                
                       ,TO_SITE                
                       ,PROD_LINE                
                       ,INVENTORY_TYPE                
                       )                                                 
                SELECT  DIVISION_ID                
                       ,PLAN_START_YYYYMMDD                
                       ,PLAN_TYPE                
                       ,SEQ                
                       ,OPERATION_GROUP                
                       ,FROM_SITE                
                       ,ITEM_ID                
                       ,'I'                  AS PSI_TYPE                
                       ,'ACTIVATE_COMPLETED' AS PSI_VALUE                
                       ,YYYYMMDD                
--                       ,ELECTRODE_TYPE                
                       ,0.0   AS QTY                
                       ,''    AS TO_SITE                
                       ,''    AS PROD_LINE                
                       ,'C'    AS INVENTORY_TYPE                
                 FROM                 
                     (                
                         SELECT                 
                                DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,FROM_SITE,ITEM_ID,A.YYYYMMDD--,ELECTRODE_TYPE                
                          FROM                
                               (                
                                  SELECT CONVERT(VARCHAR(8),START_DTTM,112) AS YYYYMMDD                  
                                    FROM TH_ENG_BUCKET_INFO_SN WITH(NOLOCK)                  
                                   WHERE PLAN_ID        = @p_engine_plan_id     --'1021::PR::1'                     
                                    AND MASTER_ID       = @p_master_id          --'81::WEEKLY'                          
                               ) A,                
                               (                
                                 SELECT DISTINCT DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,FROM_SITE,ITEM_ID--,ELECTRODE_TYPE                
                                   FROM #tmp_SCP_ANL_PSI_PRODUCTION X WITH(NOLOCK)                
                                  WHERE 1=1                
                                    AND DIVISION_ID         = @p_division_id          --'81'                                     
                                    AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd  --'20180416'                       
                                    AND PLAN_TYPE           = @p_plan_type            --'PR'                                       
                                    AND SEQ                 = @p_seq                  --1                                               
                                    AND OPERATION_GROUP     = 'A'                
                              ) B                
                     ) SUB                
                     WHERE 1=1                
                       AND NOT EXISTS (                
                                        SELECT 'X'                
                                          FROM #tmp_SCP_ANL_PSI_PRODUCTION Z WITH(NOLOCK)                
                                         WHERE 1=1                
                                           AND Z.DIVISION_ID         = SUB.DIVISION_ID                
                                           AND Z.PLAN_START_YYYYMMDD = SUB.PLAN_START_YYYYMMDD                
                                           AND Z.PLAN_TYPE           = SUB.PLAN_TYPE                
                                           AND Z.SEQ                 = SUB.SEQ                
                                           AND Z.PSI_TYPE            = 'I'                
                                           AND Z.ITEM_ID             = SUB.ITEM_ID                
                                           AND Z.FROM_SITE           = SUB.FROM_SITE                
                                           AND Z.PSI_VALUE           = 'ACTIVATE_COMPLETED'                
                                           AND Z.YYYYMMDD            = SUB.YYYYMMDD                
                                      );                
                
           /*                
            * 셀에 대하여 특정기간에 활성화진행중 수량이 이 존재하지 않으면, 0으로 활성화진행중 데이타 생성             
            */                 

		-- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
        SET @v_log_message = N'########## log step ##########';
        SET @v_description = @v_program_name + ':' + N' 01000 ';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								    ,@p_log_type      = N'TXN'        
								    ,@p_log_count     = 0       
								    ,@p_log_message   = @v_log_message       
								    ,@p_description   = @v_description       
								    ,@p_event_date    = @d_event_date       
								    ,@p_user_id       = @v_batch_user      
                                    ;  

          INSERT INTO  #tmp_SCP_ANL_PSI_PRODUCTION                 
                      ( DIVISION_ID                
                       ,PLAN_START_YYYYMMDD                
                       ,PLAN_TYPE                
                       ,SEQ                
                       ,OPERATION_GROUP                
                       ,FROM_SITE                
,ITEM_ID                
                       ,PSI_TYPE                
                       ,PSI_VALUE                
            ,YYYYMMDD                
--                       ,ELECTRODE_TYPE                
                       ,QTY                
                       ,TO_SITE                
                       ,PROD_LINE                
                       ,INVENTORY_TYPE                
                       )                 
                SELECT  DIVISION_ID                
                       ,PLAN_START_YYYYMMDD                
                       ,PLAN_TYPE                
                       ,SEQ           
                       ,OPERATION_GROUP                
                       ,FROM_SITE                
                       ,ITEM_ID                
                       ,'I'                  AS PSI_TYPE                
                      ,'ACTIVATE_PROGRESS' AS PSI_VALUE                
                       ,YYYYMMDD                
--                       ,ELECTRODE_TYPE                
                       ,0.0   AS QTY                
                       ,''    AS TO_SITE                
                       ,''    AS PROD_LINE                
                       ,'P'    AS INVENTORY_TYPE                
            
                 FROM                 
                     (                
                         SELECT                 
                                DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,FROM_SITE,ITEM_ID,A.YYYYMMDD--,ELECTRODE_TYPE                
                          FROM                
                        (                
                                  SELECT CONVERT(VARCHAR(8),START_DTTM,112) AS YYYYMMDD                  
                                    FROM TH_ENG_BUCKET_INFO_SN WITH(NOLOCK)                  
                                   WHERE PLAN_ID        = @p_engine_plan_id     --'1021::PR::1'                     
                                    AND MASTER_ID       = @p_master_id          --'81::WEEKLY'                          
                               ) A,                
                               (                
                                 SELECT DISTINCT DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,FROM_SITE,ITEM_ID--,ELECTRODE_TYPE                
                                   FROM #tmp_SCP_ANL_PSI_PRODUCTION X WITH(NOLOCK)                
                                  WHERE 1=1         
                                    AND DIVISION_ID         = @p_division_id          --'81'                  
                                    AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd  --'20180416'                       
                                    AND PLAN_TYPE           = @p_plan_type            --'PR'                                       
                                    AND SEQ                 = @p_seq                  --1                                               
                                    AND OPERATION_GROUP     = 'A'                
                              ) B                
                     ) SUB                
                     WHERE 1=1                
                       AND NOT EXISTS (                
                                        SELECT 'X'                
                                          FROM #tmp_SCP_ANL_PSI_PRODUCTION Z WITH(NOLOCK)          
                                         WHERE 1=1                
                                           AND Z.DIVISION_ID         = SUB.DIVISION_ID                
                                           AND Z.PLAN_START_YYYYMMDD = SUB.PLAN_START_YYYYMMDD                
                                           AND Z.PLAN_TYPE           = SUB.PLAN_TYPE                
                                           AND Z.SEQ  = SUB.SEQ                
                                           AND Z.PSI_TYPE            = 'I'                
          AND Z.ITEM_ID             = SUB.ITEM_ID                
                                           AND Z.FROM_SITE           = SUB.FROM_SITE                
                                           AND Z.PSI_VALUE           = 'ACTIVATE_PROGRESS'                
                                           AND Z.YYYYMMDD            = SUB.YYYYMMDD                
                                      );                                                 
                                                               

		-- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
        SET @v_log_message = N'########## log step ##########';
        SET @v_description = @v_program_name + ':' + N' 01100 ';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								    ,@p_log_type      = N'TXN'        
								    ,@p_log_count     = 0       
								    ,@p_log_message   = @v_log_message       
								    ,@p_description   = @v_description       
								    ,@p_event_date    = @d_event_date       
								    ,@p_user_id       = @v_batch_user      
                                    ;  
                            
           /*                
            * WEEKLY 구간의 EOH에 대해서 엔진에서 나오지 않은 날짜에 대하여 데이타생성                
            */                                                    
                
           INSERT INTO  #tmp_SCP_ANL_PSI_PRODUCTION       
                      ( DIVISION_ID                
                       ,PLAN_START_YYYYMMDD                
                       ,PLAN_TYPE                
                       ,SEQ                
                       ,OPERATION_GROUP                
                       ,FROM_SITE                
                       ,ITEM_ID                
                       ,PSI_TYPE                
                       ,PSI_VALUE                
                       ,YYYYMMDD                
--                       ,ELECTRODE_TYPE                
                       ,QTY                
                       ,TO_SITE                
                       ,PROD_LINE                
                       ,INVENTORY_TYPE                
                       )                
              SELECT  A.DIVISION_ID                
                       ,A.PLAN_START_YYYYMMDD                
                       ,A.PLAN_TYPE                
                       ,A.SEQ                
                       ,A.OPERATION_GROUP                
                       ,A.FROM_SITE                
                       ,A.ITEM_ID                
                       ,A.PSI_TYPE                
                       ,A.PSI_VALUE                
                       ,B.BASIS_YYYYMMDD AS YYYYMMDD                
--                       ,A.ELECTRODE_TYPE                
                       ,A.QTY                
                       ,''    AS TO_SITE                
                       ,''    AS PROD_LINE           
                       ,'I'   AS INVENTORY_TYPE                
                  FROM                
                      (                
                                 SELECT X.*                
                                   FROM #tmp_SCP_ANL_PSI_PRODUCTION X WITH(NOLOCK)                
                                  WHERE 1=1                
                                    AND X.DIVISION_ID         = @p_master_id            --'81'                                     
                                    AND X.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd  --'20180416'                       
                                    AND X.PLAN_TYPE           = @p_plan_type            --'PR'                                       
                                    AND X.SEQ                 = @p_seq                  --1                                               
                                    AND X.PSI_TYPE            = 'I'          
                                    AND X.INVENTORY_TYPE      = 'I'                
                                    AND X.YYYYMMDD IN ( SELECT CONVERT(VARCHAR,START_DTTM,112)                 
                                                        FROM TH_ENG_BUCKET_INFO_SN WITH(NOLOCK)                  
                                                       WHERE PLAN_ID      = @p_engine_plan_id   --'1022::PR::1'           
                                      AND MASTER_ID    = @p_master_id        --'81::WEEKLY'                 
                                                         AND BUCKET_TYPE  = 'WEEK' )                
                                  ) A,                
                                  (                
                                   SELECT CONVERT(VARCHAR,B.START_DTTM,112) AS YYYYMMDD,C.BASIS_YYYYMMDD                
                                   FROM TH_ENG_BUCKET_INFO_SN B WITH(NOLOCK),                
                                        SCM_SYS_CALENDAR_M    C WITH(NOLOCK)                  
                                  WHERE 1=1                
                                    AND B.PLAN_ID         = @p_engine_plan_id    --'1022::PR::1'                  
                                    AND B.MASTER_ID       = @p_master_id         --'81::WEEKLY'                
                                    AND C.BASIS_YYYYMMDD  > CONVERT(VARCHAR,B.START_DTTM,112)                
                                    AND C.BASIS_YYYYMMDD  < CONVERT(VARCHAR,B.END_DTTM,112)                
                                    AND B.BUCKET_TYPE     = 'WEEK'                
                                  ) B                
                WHERE 1=1                
                 AND A.YYYYMMDD = B.YYYYMMDD                
                                 ;                

		-- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
        SET @v_log_message = N'########## log step ##########';
        SET @v_description = @v_program_name + ':' + N' 01200 ';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								    ,@p_log_type      = N'TXN'        
								    ,@p_log_count     = 0       
								    ,@p_log_message   = @v_log_message       
								    ,@p_description   = @v_description       
								    ,@p_event_date    = @d_event_date       
								    ,@p_user_id       = @v_batch_user      
                                    ;  
                                                           
           -------------------------------------------------------------------------------------------------------------                     
           -- 5. 로직 보정  ACTIVATE_PROGRESS,MODEL_INVENTORY WEEK 값이 없는 경우 일별 값을 0으로 추가           
           -------------------------------------------------------------------------------------------------------------        
                               
              INSERT INTO  #tmp_SCP_ANL_PSI_PRODUCTION                 
                  ( DIVISION_ID                
                    ,PLAN_START_YYYYMMDD                
                    ,PLAN_TYPE                
                    ,SEQ                
                    ,OPERATION_GROUP                
                    ,FROM_SITE                
                    ,ITEM_ID                
                    ,PSI_TYPE                
                    ,PSI_VALUE              
                    ,YYYYMMDD                
--                       ,ELECTRODE_TYPE                
                    ,QTY                
                    ,TO_SITE                
                    ,PROD_LINE                
                    ,INVENTORY_TYPE                
            
                    )                 
            SELECT  DIVISION_ID                
                    ,PLAN_START_YYYYMMDD                
                    ,PLAN_TYPE                
                    ,SEQ                
                    ,OPERATION_GROUP                
                    ,FROM_SITE                
                    ,ITEM_ID                
                    ,'I'                  AS PSI_TYPE                
                    ,'ACTIVATE_PROGRESS' AS PSI_VALUE                
                    ,YYYYMMDD                
--                       ,ELECTRODE_TYPE                
                    ,0.0   AS QTY                
                    ,''    AS TO_SITE                
                    ,''    AS PROD_LINE                
                    ,'P'    AS INVENTORY_TYPE                
              FROM                 
                  (                
                      SELECT                 
                            DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,FROM_SITE,ITEM_ID,A.YYYYMMDD--,A.PARTIAL_WEEK_NAME, A.PARTIAL_YN,A.BASIS_START_DATE, A.BASIS_END_DATE            
                      FROM                
                            (                
                            SELECT C.BASIS_YYYYMMDD AS YYYYMMDD --,C.PARTIAL_WEEK_NAME, C.PARTIAL_YN,C.BASIS_START_DATE, C.BASIS_END_DATE            
         FROM SCM_SYS_CALENDAR_M    C WITH(NOLOCK)                   
                              WHERE 1=1                
                                AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd      
								
								-- * 2021.05.10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - start
                                --AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,@p_plan_start_yyyymmdd,112)),112)   
								--
								AND C.BASIS_YYYYMMDD <  @v_pet_date 
								-- * 2021.05.10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - end
            
                            ) A,                
                            (                
                              SELECT DISTINCT DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,FROM_SITE,ITEM_ID--,ELECTRODE_TYPE                
                                FROM #tmp_SCP_ANL_PSI_PRODUCTION X WITH(NOLOCK)                
                              WHERE 1=1                
                                AND DIVISION_ID         = @p_division_id          --'81'                                     
                                AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd  --'20180416'                       
                                AND PLAN_TYPE           = @p_plan_type            --'PR'                                       
                                AND SEQ                 = @p_seq                  --1                                               
                                AND OPERATION_GROUP     = 'A'                
--                         AND PSI_VALUE           = 'ACTIVATE_PROGRESS'            
                          ) B                
                  ) SUB                
                  WHERE 1=1                
                    AND NOT EXISTS (                
                                SELECT 'X'                
                                      FROM #tmp_SCP_ANL_PSI_PRODUCTION Z WITH(NOLOCK)                
                                      WHERE 1=1                
                                        AND Z.DIVISION_ID         = SUB.DIVISION_ID                
                                        AND Z.PLAN_START_YYYYMMDD = SUB.PLAN_START_YYYYMMDD                
                                        AND Z.PLAN_TYPE           = SUB.PLAN_TYPE                
                                        AND Z.SEQ                 = SUB.SEQ                
                                        AND Z.PSI_TYPE            = 'I'                
                                        AND Z.ITEM_ID             = SUB.ITEM_ID                
                                        AND Z.FROM_SITE           = SUB.FROM_SITE                
                                        AND Z.PSI_VALUE           = 'ACTIVATE_PROGRESS'                
                                        AND Z.YYYYMMDD            = SUB.YYYYMMDD                
                                  );               
                                  

		-- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
        SET @v_log_message = N'########## log step ##########';
        SET @v_description = @v_program_name + ':' + N' 01300 ';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								    ,@p_log_type      = N'TXN'        
								    ,@p_log_count     = 0       
								    ,@p_log_message   = @v_log_message       
								    ,@p_description   = @v_description       
								    ,@p_event_date    = @d_event_date       
								    ,@p_user_id       = @v_batch_user      
                                    ;  
                                                               
            INSERT INTO  #tmp_SCP_ANL_PSI_PRODUCTION                 
                          ( DIVISION_ID                
                           ,PLAN_START_YYYYMMDD                
                           ,PLAN_TYPE                
                           ,SEQ                
                           ,OPERATION_GROUP                
                           ,FROM_SITE                
                           ,ITEM_ID                
                           ,PSI_TYPE                
                           ,PSI_VALUE                
                           ,YYYYMMDD                
    --                       ,ELECTRODE_TYPE                
                           ,QTY                
                           ,TO_SITE                
                           ,PROD_LINE                
                           ,INVENTORY_TYPE                
                   
                          )                 
                    SELECT  DIVISION_ID                
                           ,PLAN_START_YYYYMMDD                
                          ,PLAN_TYPE                
                           ,SEQ                
                           ,OPERATION_GROUP                
                           ,FROM_SITE                
                           ,ITEM_ID                
                           ,'I'                  AS PSI_TYPE                
                           ,'MODEL_INVENTORY' AS PSI_VALUE                
                           ,YYYYMMDD                
    --                       ,ELECTRODE_TYPE                
                           ,0.0   AS QTY                
                           ,''    AS TO_SITE                
                           ,''    AS PROD_LINE                
                           ,'I'    AS INVENTORY_TYPE                
            
                     FROM                 
                         (                
                             SELECT                 
                                    DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,FROM_SITE,ITEM_ID,A.YYYYMMDD--,A.PARTIAL_WEEK_NAME, A.PARTIAL_YN,A.BASIS_START_DATE, A.BASIS_END_DATE            
                              FROM                
                                   (                
                                     SELECT C.BASIS_YYYYMMDD AS YYYYMMDD --,C.PARTIAL_WEEK_NAME, C.PARTIAL_YN,C.BASIS_START_DATE, C.BASIS_END_DATE            
                                       FROM SCM_SYS_CALENDAR_M    C WITH(NOLOCK)         
                                      WHERE 1=1                
                                        AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd   
										
										-- * 2021.05.10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - start
                                        --AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,@p_plan_start_yyyymmdd,112)),112)    
										--
										AND C.BASIS_YYYYMMDD <  @v_pet_date  
										-- * 2021.05.10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - end
            
                                   ) A,                
                                   (                
                                     SELECT DISTINCT DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,FROM_SITE,ITEM_ID--,ELECTRODE_TYPE                
                                       FROM #tmp_SCP_ANL_PSI_PRODUCTION X WITH(NOLOCK)                
                                      WHERE 1=1                
                                        AND DIVISION_ID         = @p_division_id          --'81'                                     
                                        AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd  --'20180416'                       
                                        AND PLAN_TYPE           = @p_plan_type            --'PR'                                       
                                        AND SEQ                 = @p_seq                  --1                                               
                                        --AND OPERATION_GROUP     = 'A'                
    --                                    AND PSI_VALUE           = 'MODEL_INVENTORY'            
                                  ) B                
                  ) SUB                
                         WHERE 1=1                
                           AND NOT EXISTS (                
                                            SELECT 'X'                
                                              FROM #tmp_SCP_ANL_PSI_PRODUCTION Z WITH(NOLOCK)                
                                             WHERE 1=1                
                                               AND Z.DIVISION_ID         = SUB.DIVISION_ID                
                                               AND Z.PLAN_START_YYYYMMDD = SUB.PLAN_START_YYYYMMDD                
                                               AND Z.PLAN_TYPE           = SUB.PLAN_TYPE                
                                               AND Z.SEQ                 = SUB.SEQ                
                                               AND Z.PSI_TYPE            = 'I'                
                                               AND Z.ITEM_ID             = SUB.ITEM_ID                
                                               AND Z.FROM_SITE           = SUB.FROM_SITE                
                                               AND Z.PSI_VALUE           = 'MODEL_INVENTORY'                
                                               AND Z.YYYYMMDD            = SUB.YYYYMMDD                
                                          );                
                                                             

		-- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
        SET @v_log_message = N'########## log step ##########';
        SET @v_description = @v_program_name + ':' + N' 01400 ';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								    ,@p_log_type      = N'TXN'        
								    ,@p_log_count     = 0       
								    ,@p_log_message   = @v_log_message       
								    ,@p_description   = @v_description       
								    ,@p_event_date    = @d_event_date       
								    ,@p_user_id       = @v_batch_user      
                                    ;  
          
               -- 전체 내역에서 일별 bucket에서 NULL을 0으로 채우기          
          
               INSERT INTO  #tmp_SCP_ANL_PSI_PRODUCTION                 
                          ( DIVISION_ID                
                           ,PLAN_START_YYYYMMDD                
                           ,PLAN_TYPE                
                           ,SEQ                
                           ,OPERATION_GROUP                
                           ,FROM_SITE                
                           ,ITEM_ID                
                           ,PSI_TYPE                
                           ,PSI_VALUE                
                           ,YYYYMMDD                
    --                       ,ELECTRODE_TYPE                
                           ,QTY                
                           ,TO_SITE                
                           ,PROD_LINE                
                           ,INVENTORY_TYPE                
            
                           )          
                
                    SELECT  DISTINCT            
                            DIVISION_ID                
                           ,PLAN_START_YYYYMMDD                
                           ,PLAN_TYPE                
                           ,SEQ                
                        ,OPERATION_GROUP                
                           ,FROM_SITE                
                           ,ITEM_ID                
                           ,PSI_TYPE                
                           ,PSI_VALUE                
                           ,YYYYMMDD                
    --         ,ELECTRODE_TYPE                
                           ,0.0   AS QTY                
                           ,NULL AS TO_SITE      
                           ,NULL AS PROD_LINE                
                           ,NULL AS INVENTORY_TYPE                
                     FROM                 
                         (                
                             SELECT                 
                                    DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,FROM_SITE,ITEM_ID,A.YYYYMMDD--,A.PARTIAL_WEEK_NAME, A.PARTIAL_YN,A.BASIS_START_DATE, A.BASIS_END_DATE            
                                     ,PSI_TYPE,PSI_VALUE,TO_SITE,PROD_LINE,INVENTORY_TYPE          
                              FROM                
                          (                
                                     SELECT C.BASIS_YYYYMMDD AS YYYYMMDD --,C.PARTIAL_WEEK_NAME, C.PARTIAL_YN,C.BASIS_START_DATE, C.BASIS_END_DATE            
                                       FROM SCM_SYS_CALENDAR_M    C WITH(NOLOCK)                   
                                      WHERE 1=1                
                                        AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd         
										
										-- * 2021.05.10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - start
                                        --AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,@p_plan_start_yyyymmdd,112)),112)   
										--
										AND C.BASIS_YYYYMMDD <  @v_pet_date 
										-- * 2021.05.10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - end

                                        --AND C.BASIS_YYYYMMDD >= (          
--       SELECT MIN(START_DTTM)           
                                        --      FROM TH_ENG_BUCKET_INFO_SN           
                                        --      WHERE PLAN_ID   = @p_engine_plan_id   -- 2018-08-20 00:00:00.000           
                                        --      AND BUCKET_TYPE = 'DAY'          
                                        --      )            
            
                                   ) A,                
                                   (                
                                     SELECT DISTINCT DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,FROM_SITE,ITEM_ID--,ELECTRODE_TYPE                
                                            ,PSI_TYPE,PSI_VALUE,TO_SITE,PROD_LINE,INVENTORY_TYPE          
                                       FROM #tmp_SCP_ANL_PSI_PRODUCTION X WITH(NOLOCK)                
                                      WHERE 1=1                
                                        AND DIVISION_ID         = @p_division_id          --'81'                                     
                                        AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd  --'20180416'                       
                                        AND PLAN_TYPE           = @p_plan_type            --'PR'                                       
                                        AND SEQ                 = @p_seq                  --1                                               
    --                                    AND OPERATION_GROUP     = 'A'                
    --                                    AND PSI_VALUE           = 'ACTIVATE_PROGRESS'            
                                  ) B                
                         ) SUB                
                         WHERE 1=1                
                           AND NOT EXISTS (                
                                            SELECT 'X'                
                                              FROM #tmp_SCP_ANL_PSI_PRODUCTION Z WITH(NOLOCK)                
                                             WHERE 1=1                
                                               AND Z.DIVISION_ID         = SUB.DIVISION_ID                
                                               AND Z.PLAN_START_YYYYMMDD = SUB.PLAN_START_YYYYMMDD                
                          AND Z.PLAN_TYPE           = SUB.PLAN_TYPE                
                                               AND Z.SEQ                 = SUB.SEQ                
                                               AND Z.PSI_TYPE      = SUB.PSI_TYPE                
                                               AND Z.ITEM_ID             = SUB.ITEM_ID          
                           AND Z.FROM_SITE           = SUB.FROM_SITE                
                                               AND Z.PSI_VALUE           = SUB.PSI_VALUE                
                                               AND Z.YYYYMMDD            = SUB.YYYYMMDD                
                                               --AND Z.TO_SITE             = SUB.TO_SITE          
                                               --AND Z.PROD_LINE           = SUB.PROD_LINE          
                                               --AND Z.INVENTORY_TYPE      = SUB.INVENTORY_TYPE          
                                          )            
                                          
		-- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
        SET @v_log_message = N'########## log step ##########';
        SET @v_description = @v_program_name + ':' + N' 01500 ';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								    ,@p_log_type      = N'TXN'        
								    ,@p_log_count     = 0       
								    ,@p_log_message   = @v_log_message       
								    ,@p_description   = @v_description       
								    ,@p_event_date    = @d_event_date       
								    ,@p_user_id       = @v_batch_user      
                                    ;            

          -------------------------------------------------------------------------------------------------------------                     
           --6. Model inventory Balance  보정        
           --    1)팩,전극        : 전일 EOH – 출하sum + 생산sum        
           --    2)일반 CELL      : 전일 EOH – 출하sum + Activate Completed   (일반 CELL)  
           --      소형후공정 CELL: 전일 EOH – 출하sum + PSI_TYPE ='P'   (소형후공정 CELL)    
           --                                            OPERATION_GROUP ='A' AND SUBSTRING(ITEM_ID,1,2) IN ('MI','MD','MT')   
           --                                                                     --> ATTRIBUTE7(TCO_CELL_YN)  = 'Y' 로 변경
           --    대상구간: 전구간 일자별로 생성         
     -------------------------------------------------------------------------------------------------------------          
               -- BOH 임시 테이블 생선        
               SELECT  SITE_ID  ,ITEM_ID, SUM(ISNULL(PSI_BOH_QTY,0)) AS BOH        
                INTO #BOH        
                FROM SCP_PLN_PLANT_ONHAND WITH(NOLOCK)                      
               WHERE DIVISION_ID               = @P_DIVISION_ID          
                 AND STOCK_TYPE    NOT IN ( 'ASSM','FOR_STOCKPLAN','FORMING','FORMED','CHARING','A_MOVE_WH')   --셀 특성완료이전 제외           
                 AND PLAN_START_YYYYMMDD       = @P_PLAN_START_YYYYMMDD           
                 AND PLAN_TYPE                 = @P_PLAN_TYPE           
                 AND SEQ                       = @P_SEQ          
                 --AND SITE_ID                   = @P_SCM_SITE_ID            
                 --AND ITEM_ID                   = @P_ITEM_ID            
                 AND YYYYMMDD                  = @P_PLAN_START_YYYYMMDD        
               GROUP BY SITE_ID  ,ITEM_ID        

		-- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
        SET @v_log_message = N'########## log step ##########';
        SET @v_description = @v_program_name + ':' + N' 01600 ';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								    ,@p_log_type      = N'TXN'        
								    ,@p_log_count     = 0       
								    ,@p_log_message   = @v_log_message       
								    ,@p_description   = @v_description       
								    ,@p_event_date    = @d_event_date       
								    ,@p_user_id       = @v_batch_user      
                                    ;   
        
              -- 임시테이블 BOH 반영         
              UPDATE X          
                 SET X.BOH = Y.BOH        
                FROM #tmp_SCP_ANL_PSI_PRODUCTION X with (nolock)          
                JOIN #BOH Y with (nolock)        
                  ON 0 = 0           
                 AND X.FROM_SITE        = Y.SITE_ID          
                 AND X.ITEM_ID          = Y.ITEM_ID          
                 ;

		-- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
        SET @v_log_message = N'########## log step ##########';
        SET @v_description = @v_program_name + ':' + N' 01700 ';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								    ,@p_log_type      = N'TXN'        
								    ,@p_log_count     = 0       
								    ,@p_log_message   = @v_log_message       
								    ,@p_description   = @v_description       
								    ,@p_event_date    = @d_event_date       
								    ,@p_user_id       = @v_batch_user      
                                    ; 
            
            --  TO_CELL_YN 반영 전 ORIGIN_FROM_DIVISION_ID 반영 
            UPDATE X    
               SET X.ORIGIN_FROM_DIVISION_ID = Y.DIVISION_ID    
              FROM #tmp_SCP_ANL_PSI_PRODUCTION X WITH (NOLOCK)  
				   INNER JOIN SCM_MST_DIVISION DM WITH(NOLOCK) -- 2023.03.29 HM JV 가상 사업부 추가 대응
						   ON DM.DIVISION_ID = X.DIVISION_ID
						  AND DM.VALID_YN	 = 'Y'
              LEFT OUTER JOIN DBO.SCM_MST_SITE Y  WITH (NOLOCK)       -- from   PLANT_SITE_ID    
                           ON 0 = 0    
--                          AND Y.SITE_TYPE   = 'PLANT'        
                          -- 2023.03.29 AND (CASE WHEN X.DIVISION_ID IN ('EE', 'EE_UC') THEN '0' ELSE X.DIVISION_ID END ) = (CASE WHEN X.DIVISION_ID IN ('EE', 'EE_UC') THEN '0' ELSE Y.DIVISION_ID END )    -- 2022.03.22 KSW JV GM 반영 EE_UC 추가 - 0 --> '0' 변경
						  AND Y.DIVISION_ID = CASE WHEN DM.ATTRIBUTE3 = 'EE' -- 2023.03.29 HM JV 가상 사업부 추가 대응
												   THEN Y.DIVISION_ID
												   ELSE X.DIVISION_ID
											  END 
                          AND Y.SCM_SITE_ID  = REPLACE(X.FROM_SITE,'-S','')    
                          AND Y.VALID_YN ='Y'       

		-- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
        SET @v_log_message = N'########## log step ##########';
        SET @v_description = @v_program_name + ':' + N' 01800 ';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								    ,@p_log_type      = N'TXN'        
								    ,@p_log_count     = 0       
								    ,@p_log_message   = @v_log_message       
								    ,@p_description   = @v_description       
								    ,@p_event_date    = @d_event_date       
								    ,@p_user_id       = @v_batch_user      
                                    ; 

/*
            --  TO_CELL_YN 반영
              UPDATE X
                 SET X.ATTRIBUTE7 = Y.TCO_CELL_YN         -- FROM TCO_CELL_YN
                FROM #tmp_SCP_ANL_PSI_PRODUCTION X WITH (NOLOCK)
                JOIN SCP_MST_FINAL_ITEM Y WITH (NOLOCK) 
                  ON 0 = 0
                  AND (CASE WHEN @p_division_id = 'EE' THEN X.ORIGIN_FROM_DIVISION_ID ELSE X.DIVISION_ID END) = Y.DIVISION_ID
                  AND X.ITEM_ID        = Y.ITEM_ID
*/
          IF @p_division_id = '40'
          BEGIN


            UPDATE X
                 SET X.ATTRIBUTE7 = Y.TCO_CELL_YN         -- FROM TCO_CELL_YN
                FROM #tmp_SCP_ANL_PSI_PRODUCTION X WITH (NOLOCK)
                JOIN SCP_MST_FINAL_ITEM Y WITH (NOLOCK) 
                  ON 0 = 0
                 AND '40'           = Y.DIVISION_ID
                 AND X.ITEM_ID      = Y.ITEM_ID
--                 AND X.ATTRIBUTE7   IS NULL

           END

		-- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
        SET @v_log_message = N'########## log step ##########';
        SET @v_description = @v_program_name + ':' + N' 01900 ';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								    ,@p_log_type      = N'TXN'        
								    ,@p_log_count     = 0       
								    ,@p_log_message   = @v_log_message       
								    ,@p_description   = @v_description       
								    ,@p_event_date    = @d_event_date       
								    ,@p_user_id       = @v_batch_user      
                                    ; 

		-----------------------------------------------
		-- 일별 BOH 추가 (활성화 완료 수량이 포함된 수량으로 Model inventory 오류를 수정) - 2021.12.03 KSW - start
		-----------------------------------------------
        IF OBJECT_ID('tempdb..#BOH_DAYS') IS NOT NULL
            DROP TABLE #BOH_DAYS

               SELECT  SITE_ID  ,ITEM_ID, SUM(ISNULL(PSI_BOH_QTY,0)) AS BOH, YYYYMMDD     
                INTO #BOH_DAYS       
                FROM SCP_PLN_PLANT_ONHAND WITH(NOLOCK)                      
               WHERE DIVISION_ID               = @P_DIVISION_ID          
                 AND STOCK_TYPE    NOT IN ( 'ASSM','FOR_STOCKPLAN','FORMING','FORMED','CHARING','A_MOVE_WH')   --셀 특성완료이전 제외           
                 AND PLAN_START_YYYYMMDD       = @P_PLAN_START_YYYYMMDD           
                 AND PLAN_TYPE                 = @P_PLAN_TYPE           
                 AND SEQ                       = @P_SEQ          
               GROUP BY SITE_ID  ,ITEM_ID , YYYYMMDD



		-- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
        SET @v_log_message = N'########## log step ##########';
        SET @v_description = @v_program_name + ':' + N' 02000 ';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								    ,@p_log_type      = N'TXN'        
								    ,@p_log_count     = 0       
								    ,@p_log_message   = @v_log_message       
								    ,@p_description   = @v_description       
								    ,@p_event_date    = @d_event_date       
								    ,@p_user_id       = @v_batch_user      
                                    ; 


           -- MODEL_INVENTORY UPDATE    
          --   UPDATE XX        
          --      SET XX.QTY   = (CASE  WHEN YY.OPERATION_GROUP  = 'A' THEN ( CASE  WHEN ( YY.DIVISION_ID = '40'  AND YY.ATTRIBUTE7 ='Y' )
          --                                                                        THEN  AC_SUM_TCOCELL  
          --                                                                        ELSE  AC_SUM END)  - S_SUM   
          --                            WHEN YY.OPERATION_GROUP <> 'A' THEN ( P_SUM - S_SUM)         
          --            ELSE 0 END)        
          --      FROM #tmp_SCP_ANL_PSI_PRODUCTION XX with (nolock)        
          --      INNER JOIN  (        
          --                     SELECT DISTINCT DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ        
          --                        , OPERATION_GROUP,FROM_SITE,ITEM_ID,'MODEL_INVENTORY' AS PSI_VALUE,YYYYMMDD
          --                        --,ATTRIBUTE7
								  --,ISNULL(ATTRIBUTE7, 'N') AS ATTRIBUTE7
          --                        --, ATTRIBUTE10
          --                        --,ORIGIN_FROM_DIVISION_ID,ISNULL(ORIGIN_TO_DIVISION_ID,'')  AS ORIGIN_TO_DIVISION_ID         
          --                     , SUM((CASE  WHEN PSI_TYPE ='S' 
          --                                  THEN ISNULL(QTY,0) ELSE 0 END)) OVER(PARTITION BY FROM_SITE,ITEM_ID ORDER BY FROM_SITE,ITEM_ID,YYYYMMDD)  AS S_SUM         
          --                     , SUM((CASE  WHEN PSI_TYPE ='P' AND OPERATION_GROUP <> 'A' 
          --                                  THEN ISNULL(QTY,0) ELSE 0 END)) OVER(PARTITION BY FROM_SITE,ITEM_ID ORDER BY FROM_SITE,ITEM_ID,YYYYMMDD) + ISNULL(BOH,0) AS P_SUM        
          --                     , SUM((CASE  WHEN PSI_TYPE ='I' AND OPERATION_GROUP  = 'A' AND  PSI_VALUE ='ACTIVATE_COMPLETED'             
          --                                  THEN ISNULL(QTY,0) ELSE 0 END)) OVER(PARTITION BY FROM_SITE,ITEM_ID ORDER BY FROM_SITE,ITEM_ID,YYYYMMDD) + ISNULL(BOH,0) AS AC_SUM      
          --                     , SUM((CASE  WHEN PSI_TYPE ='P' AND OPERATION_GROUP  = 'A'  AND  X.ATTRIBUTE7 ='Y'
          --                                  THEN ISNULL(QTY,0) ELSE 0 END)) OVER(PARTITION BY FROM_SITE,ITEM_ID ORDER BY FROM_SITE,ITEM_ID,YYYYMMDD) + ISNULL(BOH,0) AS AC_SUM_TCOCELL
          --                     FROM #tmp_SCP_ANL_PSI_PRODUCTION X with (nolock)         
          --                     WHERE 0 = 0        
          --                    -- AND (CASE WHEN (X.DIVISION_ID = '40' AND X.ATTRIBUTE7 = 'Y') THEN  X.ATTRIBUTE7 ELSE '0' END) = (CASE WHEN (X.DIVISION_ID = '40' AND X.ATTRIBUTE7 = 'Y') THEN 'Y' ELSE '0' END) 
          --                 ) YY        
          --             ON  XX.DIVISION_ID              = YY.DIVISION_ID                
          --             AND XX.PLAN_START_YYYYMMDD      = YY.PLAN_START_YYYYMMDD        
          --             AND XX.PLAN_TYPE                = YY.PLAN_TYPE                  
          --             AND XX.SEQ                      = YY.SEQ                        
          --             AND XX.OPERATION_GROUP          = YY.OPERATION_GROUP            
          --             AND XX.FROM_SITE                = YY.FROM_SITE                    
          --             AND XX.ITEM_ID                  = YY.ITEM_ID                    
          --             AND XX.YYYYMMDD                 = YY.YYYYMMDD        
          --             AND XX.PSI_VALUE                = YY.PSI_VALUE     


             UPDATE XX        
                SET XX.QTY   = (CASE  WHEN YY.OPERATION_GROUP  = 'A' THEN ( CASE  WHEN ( YY.DIVISION_ID = '40'  AND YY.ATTRIBUTE7 ='Y' )
                                                                                  THEN  AC_SUM_TCOCELL  
                                                                                  ELSE  AC_SUM END)  - S_SUM   
                                      WHEN YY.OPERATION_GROUP <> 'A' THEN ( P_SUM - S_SUM)         
                      ELSE 0 END)        
                FROM #tmp_SCP_ANL_PSI_PRODUCTION XX with (nolock)        
                INNER JOIN  (        
                               SELECT DISTINCT X.DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ        
                                  , OPERATION_GROUP,FROM_SITE, X.ITEM_ID,'MODEL_INVENTORY' AS PSI_VALUE, X.YYYYMMDD
                                  --,ATTRIBUTE7
								  ,ISNULL(X.ATTRIBUTE7, 'N') AS ATTRIBUTE7
                                  --, ATTRIBUTE10
                                  --,ORIGIN_FROM_DIVISION_ID,ISNULL(ORIGIN_TO_DIVISION_ID,'')  AS ORIGIN_TO_DIVISION_ID         
                               , SUM((CASE  WHEN PSI_TYPE ='S' 
                                            THEN ISNULL(QTY,0) ELSE 0 END)) OVER(PARTITION BY FROM_SITE, X.ITEM_ID ORDER BY FROM_SITE, X.ITEM_ID, X.YYYYMMDD)  AS S_SUM         
                               , SUM((CASE  WHEN PSI_TYPE ='P' AND OPERATION_GROUP <> 'A' 
                                            THEN ISNULL(QTY,0) ELSE 0 END)) OVER(PARTITION BY FROM_SITE, X.ITEM_ID ORDER BY FROM_SITE, X.ITEM_ID, X.YYYYMMDD) + ISNULL(X.BOH,0) AS P_SUM        
                               , SUM((CASE  WHEN PSI_TYPE ='I' AND OPERATION_GROUP  = 'A' AND  PSI_VALUE ='ACTIVATE_COMPLETED'             
                                            -- 2023.03.29 THEN ISNULL(QTY,0) ELSE 0 END)) OVER(PARTITION BY FROM_SITE, X.ITEM_ID ORDER BY FROM_SITE, X.ITEM_ID, X.YYYYMMDD) + (CASE WHEN DIVISION_ID IN ('81', '82', '81_UC') THEN ISNULL(X.BOH,0) ELSE ISNULL(Y.BOH,0) END) AS AC_SUM     -- 2022.02.11 소형일 경우만 일별 BOH 적용  (OLD) + ISNULL(Y.BOH,0) AS AC_SUM  -- 2022.03.22 KSW JV GM 반영 81_UC 추가 
                                            -- 2023.08.03 참조 BOH 임시 변경 (전일(Y.BOH) -> plan date(X.BOH)) THEN ISNULL(QTY,0) ELSE 0 END)) OVER(PARTITION BY FROM_SITE, X.ITEM_ID ORDER BY FROM_SITE, X.ITEM_ID, X.YYYYMMDD) + (CASE WHEN DM.ATTRIBUTE3 IN ('81', '82') THEN ISNULL(X.BOH,0) ELSE ISNULL(Y.BOH,0) END) AS AC_SUM     -- 2023.03.29 HM JV 가상 사업부 추가 대응 
                                            THEN ISNULL(QTY,0) ELSE 0 END)) OVER(PARTITION BY FROM_SITE, X.ITEM_ID ORDER BY FROM_SITE, X.ITEM_ID, X.YYYYMMDD) + (CASE WHEN DM.ATTRIBUTE3 IN ('81', '82') THEN ISNULL(X.BOH,0) ELSE ISNULL(X.BOH,0) END) AS AC_SUM     -- 2023.03.29 HM JV 가상 사업부 추가 대응 
                              , SUM((CASE  WHEN PSI_TYPE ='P' AND OPERATION_GROUP  = 'A'  AND  X.ATTRIBUTE7 ='Y'
                                            -- 2023.08.03 참조 BOH 임시 변경 (전일(Y.BOH) -> plan date(X.BOH)) THEN ISNULL(QTY,0) ELSE 0 END)) OVER(PARTITION BY FROM_SITE, X.ITEM_ID ORDER BY FROM_SITE, X.ITEM_ID, X.YYYYMMDD) + ISNULL(Y.BOH,0) AS AC_SUM_TCOCELL
                                           THEN ISNULL(QTY,0) ELSE 0 END)) OVER(PARTITION BY FROM_SITE, X.ITEM_ID ORDER BY FROM_SITE, X.ITEM_ID, X.YYYYMMDD) + ISNULL(X.BOH,0) AS AC_SUM_TCOCELL
							   , X.BOH
							   --, Y.BOH as BOH_DAYS
							   , SUM((CASE  WHEN PSI_TYPE ='I' AND OPERATION_GROUP  = 'A' AND  PSI_VALUE ='ACTIVATE_COMPLETED'             
                                            THEN ISNULL(QTY,0) ELSE 0 END)) OVER(PARTITION BY FROM_SITE, X.ITEM_ID ORDER BY FROM_SITE, X.ITEM_ID, X.YYYYMMDD) AS ACTIVATE_COMPLETED_SUM 
                               FROM #tmp_SCP_ANL_PSI_PRODUCTION X with (nolock)
									INNER JOIN SCM_MST_DIVISION DM WITH(NOLOCK)
											ON DM.DIVISION_ID = X.DIVISION_ID 
										   AND DM.VALID_YN	  = 'Y'
									,#BOH_DAYS Y
                               WHERE 0 = 0        
							     and Y.SITE_ID = X.FROM_SITE
								 and Y.ITEM_ID = X.ITEM_ID
								 and Y.YYYYMMDD = X.YYYYMMDD
                              -- AND (CASE WHEN (X.DIVISION_ID = '40' AND X.ATTRIBUTE7 = 'Y') THEN  X.ATTRIBUTE7 ELSE '0' END) = (CASE WHEN (X.DIVISION_ID = '40' AND X.ATTRIBUTE7 = 'Y') THEN 'Y' ELSE '0' END) 
                           ) YY        
                       ON  XX.DIVISION_ID              = YY.DIVISION_ID                
                       AND XX.PLAN_START_YYYYMMDD      = YY.PLAN_START_YYYYMMDD        
                       AND XX.PLAN_TYPE                = YY.PLAN_TYPE                  
                       AND XX.SEQ                      = YY.SEQ                        
                       AND XX.OPERATION_GROUP          = YY.OPERATION_GROUP            
                       AND XX.FROM_SITE                = YY.FROM_SITE                    
                       AND XX.ITEM_ID                  = YY.ITEM_ID                    
                       AND XX.YYYYMMDD                 = YY.YYYYMMDD        
                       AND XX.PSI_VALUE                = YY.PSI_VALUE  

		-- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
        SET @v_log_message = N'########## log step ##########';
        SET @v_description = @v_program_name + ':' + N' 02100 ';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								    ,@p_log_type      = N'TXN'        
								    ,@p_log_count     = 0       
								    ,@p_log_message   = @v_log_message       
								    ,@p_description   = @v_description       
								    ,@p_event_date    = @d_event_date       
								    ,@p_user_id       = @v_batch_user      
                                    ; 

		-- 일별 BOH 추가 (활성화 완료 수량이 포함된 수량으로 Model inventory 오류를 수정) - 2021.12.03 KSW - end

          -------------------------------------------------------------------------------------------------------------                     
          -- 7. DIO 생성                     
          -------------------------------------------------------------------------------------------------------------          
          -------------------------------------------------------------------------------------------------------------                 
          -- 7.1. DIO 임시 테이블 생성          
          -------------------------------------------------------------------------------------------------------------                 
          IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_PRODUCTION_DIO') IS NOT NULL                
              DROP TABLE #tmp_SCP_ANL_PSI_PRODUCTION_DIO                
                
            CREATE TABLE #tmp_SCP_ANL_PSI_PRODUCTION_DIO                
            (           
              DIVISION_ID   NVARCHAR(10) NOT NULL,             
              FROM_SITE     NVARCHAR(50) NOT NULL,          
              ITEM_ID       NVARCHAR(50) NOT NULL,          
              YYYYMMDD      NVARCHAR(8)  NOT NULL,          
              OUT_QTY       NUMERIC(30,10),          
              FORMATION_QTY NUMERIC(30,10),    
              EOH_QTY       NUMERIC(30,10),       
              INV_DAY       NUMERIC(30,10)                 
            );                
                
          
            INSERT INTO #tmp_SCP_ANL_PSI_PRODUCTION_DIO          
            (   DIVISION_ID           
               ,FROM_SITE             
               ,ITEM_ID               
               ,YYYYMMDD              
               ,OUT_QTY               
               ,FORMATION_QTY
               ,EOH_QTY  
               ,INV_DAY               
             )          
            SELECT DIVISION_ID          
                   ,FROM_SITE          
                   ,ITEM_ID          
                   ,YYYYMMDD          
                   ,SUM((CASE PSI_TYPE WHEN 'S' THEN ROUND(P.QTY,1) ELSE 0 END )) AS OUT_QTY          
                   ,SUM((CASE PSI_VALUE WHEN 'ACTIVATE_PROGRESS' THEN ROUND(P.QTY,1) ELSE 0 END)) AS FORMATION_QTY         
                   ,SUM((CASE PSI_VALUE WHEN 'MODEL_INVENTORY' THEN ROUND(P.QTY,1) ELSE 0 END)) AS EOH_QTY          
                   , 0          
              FROM #tmp_SCP_ANL_PSI_PRODUCTION P WITH(NOLOCK)          
             WHERE 1=1          
            GROUP BY  DIVISION_ID, FROM_SITE,ITEM_ID,YYYYMMDD          
            ORDER BY  DIVISION_ID, FROM_SITE,ITEM_ID,YYYYMMDD;             

		-- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
        SET @v_log_message = N'########## log step ##########';
        SET @v_description = @v_program_name + ':' + N' 02200 ';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								    ,@p_log_type      = N'TXN'        
								    ,@p_log_count     = 0       
								    ,@p_log_message   = @v_log_message       
								    ,@p_description   = @v_description       
								    ,@p_event_date    = @d_event_date       
								    ,@p_user_id       = @v_batch_user      
                                    ; 

            
                    
         -------------------------------------------------------------------------------------------------------------           
         -- 7.2. DIO 누적합계와 전일누적합계를  생성         #Tbl_DIO                                                                                                 
         -------------------------------------------------------------------------------------------------------------           
         SELECT  YYYYMMDD          
                ,FROM_SITE          
                ,ITEM_ID          
                ,OUT_QTY          
                ,FORMATION_QTY          
                ,EOH_QTY   
                ,OUT_QTY_SUM        
                ,LAG((CASE WHEN OUT_QTY_SUM < 0 THEN 0 ELSE OUT_QTY_SUM END),1,0) OVER (PARTITION BY FROM_SITE,ITEM_ID ORDER BY YYYYMMDD) LAG_OUT_QTY_SUM  -- 전일 누적합계          
          INTO #Tbl_DIO          
          FROM (          
                         
                SELECT FROM_SITE          
                      ,ITEM_ID          
                      ,YYYYMMDD          
                      ,SUM((CASE WHEN OUT_QTY < 0 THEN 0 ELSE OUT_QTY END)) AS OUT_QTY          
                      ,SUM((CASE WHEN FORMATION_QTY < 0 THEN 0 ELSE FORMATION_QTY END)) AS FORMATION_QTY    
                      ,SUM((CASE WHEN EOH_QTY < 0 THEN 0 ELSE EOH_QTY END)) AS EOH_QTY          
                      ,ROUND(SUM((CASE WHEN OUT_QTY < 0 THEN 0 ELSE OUT_QTY END)) OVER(PARTITION BY FROM_SITE,ITEM_ID ORDER BY FROM_SITE,ITEM_ID,YYYYMMDD),2) AS OUT_QTY_SUM  -- 누적합계          
                FROM (          
                       -- FROM_SITE,ITEM_ID,YYYYMMDD 기준으로 중복이 존재 ?          
                        SELECT FROM_SITE          
                              ,ITEM_ID          
                              ,YYYYMMDD          
                              ,SUM(OUT_QTY) AS OUT_QTY           
                              ,SUM(FORMATION_QTY) AS FORMATION_QTY          
                              ,SUM(EOH_QTY) AS EOH_QTY          
                         from #tmp_SCP_ANL_PSI_PRODUCTION_DIO P WITH(NOLOCK)          
                        WHERE 1=1          
                         GROUP BY FROM_SITE,ITEM_ID,YYYYMMDD          
                   ) SUB          
                  GROUP BY FROM_SITE          
                          ,ITEM_ID          
                          ,YYYYMMDD          
                          ,SUB.OUT_QTY          
                          ,SUB.FORMATION_QTY
                          ,SUB.EOH_QTY        
                ) AA          

		-- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
        SET @v_log_message = N'########## log step ##########';
        SET @v_description = @v_program_name + ':' + N' 02300 ';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								    ,@p_log_type      = N'TXN'        
								    ,@p_log_count     = 0       
								    ,@p_log_message   = @v_log_message       
								    ,@p_description   = @v_description       
								    ,@p_event_date    = @d_event_date       
								    ,@p_user_id       = @v_batch_user      
                                    ; 
          
         -------------------------------------------------------------------------------------------------------------           
         -- 7.3.구하고자 하는 재고일수의 일자를 기준으로 이후 일자의 OUT값의 누적값중 현재 재고값보다 최초로 큰값을 구함.          
         --                                   A. (OUT_QTY_SUM + EOH_QTY) 값과 X.OUT_QTY_SUM 비교          
         -------------------------------------------------------------------------------------------------------------          
          
          SELECT @p_division_id AS DIVISION_ID          
                ,YYYYMMDD            
                ,FROM_SITE           
                ,ITEM_ID           
                ,OUT_QTY          
                ,EOH_QTY          
                ,OUT_QTY_SUM          
--                        ,(A.OUT_QTY_SUM  + A.EOH_QTY )            
                , (SELECT TOP 1 YYYYMMDD           
                    FROM #Tbl_DIO X WITH (NOLOCK)          
                    WHERE X.FROM_SITE = A.FROM_SITE           
                      AND X.ITEM_ID   = A.ITEM_ID            
                      AND X.YYYYMMDD  > A.YYYYMMDD           
                      AND (A.OUT_QTY_SUM  + A.EOH_QTY + A.FORMATION_QTY ) <= X.OUT_QTY_SUM           
                    ) AS INV_YYYYMMDD          
          
                 ,(CASE WHEN EOH_QTY = 0.0 AND FORMATION_QTY = 0.0 THEN 0.0           
                       ELSE           
                            ISNULL((DATEDIFF(DD,CONVERT(DATETIME,A.YYYYMMDD ,112),CONVERT(DATETIME,((SELECT TOP 1 YYYYMMDD           
                                                                                     FROM #Tbl_DIO X  WITH (NOLOCK)          
                                                                                     WHERE X.FROM_SITE = A.FROM_SITE           
                                                                                       AND X.ITEM_ID   = A.ITEM_ID            
                                                                                       AND X.YYYYMMDD  > A.YYYYMMDD           
                                                                                       AND (A.OUT_QTY_SUM  + A.EOH_QTY + A.FORMATION_QTY ) <= X.OUT_QTY_SUM           
                                                                                     )),112))),999)          
                       END)                                                                   
                                                                                      AS DD          
            INTO #Tbl_SCP_ANL_PSI_PRODUCTION_DIO          
            FROM #Tbl_DIO A WITH (NOLOCK)            
                
		-- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
        SET @v_log_message = N'########## log step ##########';
        SET @v_description = @v_program_name + ':' + N' 02400 ';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								    ,@p_log_type      = N'TXN'        
								    ,@p_log_count     = 0       
								    ,@p_log_message   = @v_log_message       
								    ,@p_description   = @v_description       
								    ,@p_event_date    = @d_event_date       
								    ,@p_user_id       = @v_batch_user      
                                    ; 
                
             
                    
         -------------------------------------------------------------------------------------------------------------         
         -- 7.4. #tmp_SCP_ANL_PSI_PRODUCTION 입력          
         -- 'I'   AS PSI_TYPE                             
         -- 'DIO' AS PSI_VALUE                                           
         -- ROUND(DD-1) + (OUT_QTY/TOT_QTY),2)          
         -- SET @V_INV_DAY = ROUND( (@V_DAY-1) + (@C_EOH_QTY / @V_QTY) , 2)  -- QTY             
         -------------------------------------------------------------------------------------------------------------                   
          
         INSERT INTO  #tmp_SCP_ANL_PSI_PRODUCTION                 
                      ( DIVISION_ID                
                       ,PLAN_START_YYYYMMDD                
                       ,PLAN_TYPE                
                       ,SEQ                
                       ,OPERATION_GROUP                
                       ,FROM_SITE         
                       ,ITEM_ID                
                       ,PSI_TYPE                
                       ,PSI_VALUE                
                       ,YYYYMMDD                
--                       ,ELECTRODE_TYPE                
                       ,QTY              
                       ,TO_SITE                
                       ,PROD_LINE                
                       ,INVENTORY_TYPE      
                       ,ORIGIN_FROM_DIVISION_ID             
                       ,ORIGIN_TO_DIVISION_ID           
                       ,ELECTRODE_TYPE              
                       )          
               
             SELECT @P_DIVISION_ID                          
                   ,@P_PLAN_START_YYYYMMDD                  
                   ,@P_PLAN_TYPE                            
                   ,@P_SEQ                                  
                   ,Y.OPERATION_GROUP                      
                   ,X.FROM_SITE                
                   ,X.ITEM_ID                              
                   ,'I'   AS PSI_TYPE                             
                   ,'DIO' AS PSI_VALUE                            
                   ,X.YYYYMMDD                             
--                   , X.DD AS INV_DAY          
                   , (CASE WHEN X.DD = 0 THEN 0 ELSE X.DD END) AS QTY          
                   ,''  AS TO_SITE                
                   ,''    AS PROD_LINE               
                   ,''    AS INVENTORY_TYPE       
                   ,'' AS ORIGIN_FROM_DIVISION_ID             
                   ,'' AS ORIGIN_TO_DIVISION_ID                  
                   ,Y.ELECTRODE_TYPE     
              FROM #Tbl_SCP_ANL_PSI_PRODUCTION_DIO X WITH(NOLOCK)                
              INNER JOIN SCP_MST_FINAL_ITEM_V Y WITH (NOLOCK)                
                      ON 0 = 0            
                     AND X.ITEM_ID      = Y.ITEM_ID           
             WHERE 1 = 1                
             ;          

		-- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
        SET @v_log_message = N'########## log step ##########';
        SET @v_description = @v_program_name + ':' + N' 02500 ';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								    ,@p_log_type      = N'TXN'        
								    ,@p_log_count     = 0       
								    ,@p_log_message   = @v_log_message       
								    ,@p_description   = @v_description       
								    ,@p_event_date    = @d_event_date       
								    ,@p_user_id       = @v_batch_user      
                                    ; 
                
          -------------------------------------------------------------------------------------------------------------                     
          -- 8. 전체 DIVISION_ID, FROM_SITE,ITEM_ID별 QTY가 0 인 데이터  삭제                     
          --------------------------------------------------------------------------------------------------------------        
          
		  -- 2020.11.13   KSW         생산계획이 누락되는 오류수정 (ex) QTY 값(flag) = 0 인 data를 삭제하는 로직에서 group by sum 할때 -값과 - 값이 아닌 결과갯수가 동일한 경우 삭제되는 오류 - start
		  -- old version 에서 GROUP BY QTY 절이 문제를 일으킴
		  -- old version 
		  --
--          DELETE X      
--          --SELECT *      
--           FROM #tmp_SCP_ANL_PSI_PRODUCTION X WITH (NOLOCK)      
--           JOIN (      
--           SELECT DISTINCT DIVISION_ID      
--                , FROM_SITE      
--                , ITEM_ID      
--                , SUM(ISNULL(QTY,0)) OVER(PARTITION BY DIVISION_ID, FROM_SITE,ITEM_ID ORDER BY DIVISION_ID, FROM_SITE,ITEM_ID) AS flag      
--           FROM #tmp_SCP_ANL_PSI_PRODUCTION A WITH (NOLOCK)      
--          WHERE 0 = 0      
----            AND A.ITEM_ID ='ACEN1051I-A1'      
--          GROUP BY DIVISION_ID      
--                , FROM_SITE      
--                , ITEM_ID      
--                , QTY      
--          ) Y      
--          ON 0 = 0      
--          AND X.DIVISION_ID = Y.DIVISION_ID      
--          AND X.ITEM_ID     = Y.ITEM_ID      
--          AND X.FROM_SITE   = Y.FROM_SITE      
--          AND Y.flag = 0  

			DELETE X           
           FROM #tmp_SCP_ANL_PSI_PRODUCTION X WITH (NOLOCK)      
           JOIN (      
           SELECT DISTINCT DIVISION_ID      
                , FROM_SITE      
                , ITEM_ID      
                , SUM(ISNULL(QTY,0)) OVER(PARTITION BY DIVISION_ID, FROM_SITE,ITEM_ID) AS flag      
           FROM #tmp_SCP_ANL_PSI_PRODUCTION A WITH (NOLOCK)      
          WHERE 0 = 0                  
          ) Y      
          ON 0 = 0      
          AND X.DIVISION_ID = Y.DIVISION_ID      
          AND X.ITEM_ID     = Y.ITEM_ID      
          AND X.FROM_SITE   = Y.FROM_SITE      
          AND Y.flag = 0  		  

		-- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
        SET @v_log_message = N'########## log step ##########';
        SET @v_description = @v_program_name + ':' + N' 02600 ';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								    ,@p_log_type      = N'TXN'        
								    ,@p_log_count     = 0       
								    ,@p_log_message   = @v_log_message       
								    ,@p_description   = @v_description       
								    ,@p_event_date    = @d_event_date       
								    ,@p_user_id       = @v_batch_user      
                                    ; 

		   -- 2020.11.13   KSW         생산계획이 누락되는 오류수정 (ex) QTY 값(flag) = 0 인 data를 삭제하는 로직에서 group by sum 할때 -값과 - 값이 아닌 결과갯수가 동일한 경우 삭제되는 오류 - end
               
          -------------------------------------------------------------------------------------------------------------                     
          -- 9. ORIGIN_FROM_DIVISION_ID,ORIGIN_TO_DIVISION_ID 반영    
          --------------------------------------------------------------------------------------------------------------     
          UPDATE X    
               SET X.ORIGIN_FROM_DIVISION_ID = Y.DIVISION_ID    
              FROM #tmp_SCP_ANL_PSI_PRODUCTION X WITH (NOLOCK)
				   INNER JOIN SCM_MST_DIVISION DM WITH(NOLOCK)  -- 2023.03.29 HM JV 가상 사업부 추가 대응
						   ON DM.DIVISION_ID = X.DIVISION_ID
						  AND DM.VALID_YN	 = 'Y'
              LEFT OUTER JOIN DBO.SCM_MST_SITE Y  WITH (NOLOCK)       -- from   PLANT_SITE_ID    
                           ON 0 = 0    
--                          AND Y.SITE_TYPE   = 'PLANT'        
                          -- 2023.03.29 AND (CASE WHEN X.DIVISION_ID IN ('EE', 'EE_UC') THEN '0' ELSE X.DIVISION_ID END ) = (CASE WHEN X.DIVISION_ID IN ('EE', 'EE_UC') THEN '0' ELSE Y.DIVISION_ID END )    -- 2022.03.22 KSW JV GM 반영 EE_UC 추가 - 0 --> '0' 변경
						  AND Y.DIVISION_ID = CASE WHEN DM.ATTRIBUTE3 = 'EE'  -- 2023.03.29 HM JV 가상 사업부 추가 대응
												   THEN Y.DIVISION_ID
												   ELSE X.DIVISION_ID
											  END
                          AND Y.SCM_SITE_ID  = REPLACE(X.FROM_SITE,'-S','')    
                          AND Y.VALID_YN ='Y'       

		-- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
        SET @v_log_message = N'########## log step ##########';
        SET @v_description = @v_program_name + ':' + N' 02700 ';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								    ,@p_log_type      = N'TXN'        
								    ,@p_log_count     = 0       
								    ,@p_log_message   = @v_log_message       
								    ,@p_description   = @v_description       
								    ,@p_event_date    = @d_event_date       
								    ,@p_user_id       = @v_batch_user      
                                    ; 

    
            UPDATE X    
               SET X.ORIGIN_TO_DIVISION_ID = Y.DIVISION_ID    
              FROM #tmp_SCP_ANL_PSI_PRODUCTION X WITH (NOLOCK)    
				   INNER JOIN SCM_MST_DIVISION DM WITH(NOLOCK)  -- 2023.03.29 HM JV 가상 사업부 추가 대응
						   ON DM.DIVISION_ID = X.DIVISION_ID
						  AND DM.VALID_YN	 = 'Y'
              --LEFT OUTER JOIN DBO.SCM_MST_SITE Y  WITH (NOLOCK)       -- to   SALES_SITE_ID    
                   LEFT OUTER JOIN (SELECT MIN(DIVISION_ID) DIVISION_ID, SCM_SITE_ID, VALID_YN
				                    FROM   DBO.SCM_MST_SITE  WITH (NOLOCK)       -- to   SITE_ID
									WHERE  valid_yn = 'Y'
									GROUP BY SCM_SITE_ID, VALID_YN
								   ) Y
                           ON 0 = 0    
--                          AND Y.SITE_TYPE   = 'PLANT'        
                          -- 2023.03.29 AND (CASE WHEN X.DIVISION_ID IN ('EE', 'EE_UC') THEN '0' ELSE X.DIVISION_ID END ) = (CASE WHEN X.DIVISION_ID IN ('EE', 'EE_UC') THEN '0' ELSE Y.DIVISION_ID END )    -- 2022.03.22 KSW JV UC 반영 EE_UC 추가 - 0 --> '0' 변경
						  AND Y.DIVISION_ID = CASE WHEN DM.ATTRIBUTE3 = 'EE'  -- 2023.03.29 HM JV 가상 사업부 추가 대응
												   THEN Y.DIVISION_ID
												   ELSE X.DIVISION_ID
											  END
                          AND Y.SCM_SITE_ID  = REPLACE(X.TO_SITE_ORG,'-S','')    
                          AND Y.VALID_YN ='Y'           
                          
		-- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
        SET @v_log_message = N'########## log step ##########';
        SET @v_description = @v_program_name + ':' + N' 02800 ';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								    ,@p_log_type      = N'TXN'        
								    ,@p_log_count     = 0       
								    ,@p_log_message   = @v_log_message       
								    ,@p_description   = @v_description       
								    ,@p_event_date    = @d_event_date       
								    ,@p_user_id       = @v_batch_user      
                                    ; 

  
            UPDATE X  
               SET X.ORIGIN_TO_DIVISION_ID = X.DIVISION_ID  
              FROM #tmp_SCP_ANL_PSI_PRODUCTION X WITH (NOLOCK) 
				   INNER JOIN SCM_MST_DIVISION DM WITH(NOLOCK)  -- 2023.03.29 HM JV 가상 사업부 추가 대응
						   ON DM.DIVISION_ID = X.DIVISION_ID
						  AND DM.VALID_YN	 = 'Y'
            WHERE 0 = 0  
            AND X.PSI_TYPE = 'S'   
			AND DM.ATTRIBUTE3 != 'EE'	-- 2023.03.29 HM JV 가상 사업부 추가 대응
            -- 2023.03.29 AND X.DIVISION_ID NOT IN ('EE', 'EE_UC')		-- 2022.03.22 KSW JV GM 반영 EE_UC 추가 --AND X.DIVISION_ID <> 'EE'  

		-- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
        SET @v_log_message = N'########## log step ##########';
        SET @v_description = @v_program_name + ':' + N' 02900 ';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								    ,@p_log_type      = N'TXN'        
								    ,@p_log_count     = 0       
								    ,@p_log_message   = @v_log_message       
								    ,@p_description   = @v_description       
								    ,@p_event_date    = @d_event_date       
								    ,@p_user_id       = @v_batch_user      
                                    ; 

          -------------------------------------------------------------------------------------------------------------                     
          -- 10. Line Total Load (operaton_id) 추가                    
          --------------------------------------------------------------------------------------------------------------  
          UPDATE X
          SET X.ATTRIBUTE9 = SUBSTRING(Y.FLOW_ID,1,5)
          FROM #tmp_SCP_ANL_PSI_PRODUCTION X WITH (NOLOCK)
				INNER JOIN SCM_MST_DIVISION DM WITH(NOLOCK)  -- 2023.03.29 HM JV 가상 사업부 추가 대응
						ON DM.DIVISION_ID = X.DIVISION_ID
					   AND DM.VALID_YN	  = 'Y'
          INNER JOIN SCP_MST_FINAL_ITEM  Y WITH (NOLOCK)
          ON 0 = 0
          AND X.ITEM_ID               = Y.ITEM_ID
		  AND Y.DIVISION_ID = CASE WHEN DM.ATTRIBUTE3 = 'EE'  -- 2023.03.29 HM JV 가상 사업부 추가 대응
								   THEN Y.DIVISION_ID
								   ELSE X.DIVISION_ID
							  END
          -- 2023.03.29 AND (CASE WHEN X.DIVISION_ID IN ('EE', 'EE_UC') THEN '0' ELSE X.DIVISION_ID END ) = (CASE WHEN X.DIVISION_ID IN ('EE', 'EE_UC') THEN '0' ELSE Y.DIVISION_ID END )    -- 2022.03.22 KSW JV GM 반영 EE_UC 추가 - 0 --> '0' 변경

          -- 2020.11.04 KSW :: PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : RACK biz. 대응 - start
		  -- Rack 과 Rack 이 아닌것을 분리해서 업데이트 하는 것으로 변경한다.
		  -- old version
--          UPDATE X
--          SET X.ATTRIBUTE9 = (SELECT TOP 1 PLANT_ID
--                              FROM SCM_MST_SITE A WITH(NOLOCK)
--                             WHERE 0              = 0
--                               AND (CASE WHEN X.DIVISION_ID = 'EE' THEN 0 ELSE X.DIVISION_ID END ) = (CASE WHEN X.DIVISION_ID = 'EE' THEN 0 ELSE A.DIVISION_ID END )    
--                               AND A.SCM_SITE_ID  = X.FROM_SITE
--                               AND A.OSP_YN       ='Y')
--          FROM #tmp_SCP_ANL_PSI_PRODUCTION X WITH (NOLOCK)
----          WHERE X.ATTRIBUTE9 IS NULL

		-- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
        SET @v_log_message = N'########## log step ##########';
        SET @v_description = @v_program_name + ':' + N' 03000 ';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								    ,@p_log_type      = N'TXN'        
								    ,@p_log_count     = 0       
								    ,@p_log_message   = @v_log_message       
								    ,@p_description   = @v_description       
								    ,@p_event_date    = @d_event_date       
								    ,@p_user_id       = @v_batch_user      
                                    ; 

		  -- Rack 인것만
          UPDATE X
          SET X.ATTRIBUTE9 = (SELECT TOP 1 PLANT_ID + '_R1'
                              FROM SCM_MST_SITE A WITH(NOLOCK)
								   INNER JOIN SCM_MST_DIVISION DM WITH(NOLOCK)  -- 2023.03.29 HM JV 가상 사업부 추가 대응
										   ON DM.DIVISION_ID = A.DIVISION_ID
										  AND DM.VALID_YN	 = 'Y'
                             WHERE 0              = 0
                               -- 2023.03.29 AND (CASE WHEN X.DIVISION_ID IN ('EE', 'EE_UC') THEN '0' ELSE X.DIVISION_ID END ) = (CASE WHEN X.DIVISION_ID IN ('EE', 'EE_UC') THEN '0' ELSE A.DIVISION_ID END )    -- 2022.03.22 KSW JV GM 반영 EE_UC 추가 - 0 --> '0' 변경
							   AND A.DIVISION_ID = CASE WHEN DM.ATTRIBUTE3 = 'EE' -- 2023.03.29 HM JV 가상 사업부 추가 대응
													    THEN A.DIVISION_ID 
														ELSE X.DIVISION_ID
													END 
                               AND A.SCM_SITE_ID  = X.FROM_SITE
                               AND A.OSP_YN       ='Y')
          FROM #tmp_SCP_ANL_PSI_PRODUCTION X WITH (NOLOCK)
		  WHERE (SELECT DISTINCT ATTRIBUTE3
				   FROM SCP_MST_FINAL_ITEM F WITH (NOLOCK)
				  WHERE F.DIVISION_ID = X.DIVISION_ID
					AND F.ITEM_ID = X.ITEM_ID
				) = 'Y'
		  ;


		-- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
        SET @v_log_message = N'########## log step ##########';
        SET @v_description = @v_program_name + ':' + N' 03100 ';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								    ,@p_log_type      = N'TXN'        
								    ,@p_log_count     = 0       
								    ,@p_log_message   = @v_log_message       
								    ,@p_description   = @v_description       
								    ,@p_event_date    = @d_event_date       
								    ,@p_user_id       = @v_batch_user      
                                    ; 

		  -- Rack 아닌것만
          UPDATE X
          SET X.ATTRIBUTE9 = (SELECT TOP 1 PLANT_ID
                              FROM SCM_MST_SITE A WITH(NOLOCK)
								   INNER JOIN SCM_MST_DIVISION DM WITH(NOLOCK)  -- 2023.03.29 HM JV 가상 사업부 추가 대응
										   ON DM.DIVISION_ID = A.DIVISION_ID 
										  AND DM.VALID_YN	 = 'Y'
                             WHERE 0              = 0
                               -- 2203.03.29 AND (CASE WHEN X.DIVISION_ID IN ('EE', 'EE_UC') THEN '0' ELSE X.DIVISION_ID END ) = (CASE WHEN X.DIVISION_ID IN ('EE', 'EE_UC') THEN '0' ELSE A.DIVISION_ID END )    -- 2022.03.22 KSW JV GM 반영 EE_UC 추가 - 0 --> '0' 변경
							   AND A.DIVISION_ID = CASE WHEN DM.ATTRIBUTE3 = 'EE' -- 2023.03.29 HM JV 가상 사업부 추가 대응
													    THEN A.DIVISION_ID 
														ELSE X.DIVISION_ID
													END 
                               AND A.SCM_SITE_ID  = X.FROM_SITE
                               AND A.OSP_YN       ='Y')
          FROM #tmp_SCP_ANL_PSI_PRODUCTION X WITH (NOLOCK)
		  WHERE (SELECT DISTINCT ATTRIBUTE3
				   FROM SCP_MST_FINAL_ITEM F WITH (NOLOCK)
				  WHERE F.DIVISION_ID = X.DIVISION_ID
					AND F.ITEM_ID = X.ITEM_ID
				) <> 'Y'
		  ;

		-- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
        SET @v_log_message = N'########## log step ##########';
        SET @v_description = @v_program_name + ':' + N' 03200 ';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								    ,@p_log_type      = N'TXN'        
								    ,@p_log_count     = 0       
								    ,@p_log_message   = @v_log_message       
								    ,@p_description   = @v_description       
								    ,@p_event_date    = @d_event_date       
								    ,@p_user_id       = @v_batch_user      
                                    ; 

		  -- 2020.11.04 KSW :: PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : RACK biz. 대응 - end

		  -- PJ20214997 LGES SCP 신규 Biz, 공정 추가에 따른 모델링 개선 - 자동차 이면서 P5200 일 경우 ATTRIBUTE9에 OPERATION_ID 셋팅 - start
		  UPDATE X
          SET X.ATTRIBUTE9 = SUBSTRING(Y.FLOW_ID,1,5)
          FROM #tmp_SCP_ANL_PSI_PRODUCTION X WITH (NOLOCK)
				INNER JOIN SCM_MST_DIVISION DM WITH(NOLOCK)  -- 2023.03.29 HM JV 가상 사업부 추가 대응
						ON DM.DIVISION_ID = X.DIVISION_ID 
					   AND DM.ATTRIBUTE3  = '81' 
					   AND DM.VALID_YN	  = 'Y'
          INNER JOIN SCP_MST_FINAL_ITEM  Y WITH (NOLOCK)
          ON 0 = 0
          AND X.ITEM_ID               = Y.ITEM_ID
		  -- 2023.03.29 AND X.DIVISION_ID           IN ( '81', '81_UC' )    -- 2022.03.22 KSW JV GM 반영 81_UC 추가 
		  AND X.DIVISION_ID           = Y.DIVISION_ID
		  AND Y.FLOW_ID               = 'P5200'

		-- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
        SET @v_log_message = N'########## log step ##########';
        SET @v_description = @v_program_name + ':' + N' 03300 ';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								    ,@p_log_type      = N'TXN'        
								    ,@p_log_count     = 0       
								    ,@p_log_message   = @v_log_message       
								    ,@p_description   = @v_description       
								    ,@p_event_date    = @d_event_date       
								    ,@p_user_id       = @v_batch_user      
                                    ; 

		  -- PJ20214997 LGES SCP 신규 Biz, 공정 추가에 따른 모델링 개선 - 자동차 이면서 P5200 일 경우 ATTRIBUTE9에 OPERATION_ID 셋팅 - end

          -------------------------------------------------------------------------------------------------------------                     
          -- 11. P.S.I 소계 반영
          --          P ISSUM (P 전체 합)
          --          S ISSUM (S 전체 합)
          --          I ISSUM (I DIO + MODEL_INVENTORY) 
          --------------------------------------------------------------------------------------------------------------  
            INSERT INTO #tmp_SCP_ANL_PSI_PRODUCTION                    
              (                    
                 DIVISION_ID                              
                ,PLAN_START_YYYYMMDD                      
                ,PLAN_TYPE                               
                ,SEQ                                      
                ,OPERATION_GROUP                          
                ,FROM_SITE                                
                ,ITEM_ID                                  
                ,PSI_TYPE                                 
                ,PSI_VALUE               
              --,TO_SITE                                  
              --,PROD_LINE                                
                ,YYYYMMDD                                 
                ,QTY                                      
              --,INVENTORY_TYPE        
              --,ORIGIN_FROM_DIVISION_ID             
              --,ORIGIN_TO_DIVISION_ID           
              --,ELECTRODE_TYPE       
              --,TO_SITE_ORG        
                )    
            SELECT DIVISION_ID
                  ,PLAN_START_YYYYMMDD
                  ,PLAN_TYPE
                  ,SEQ        
                  ,OPERATION_GROUP
                  ,FROM_SITE
                  ,ITEM_ID
                  ,PSI_TYPE
                  ,'ISSUM' AS PSI_VALUE
                  ,YYYYMMDD
                  ,QTY
            FROM
            (
              SELECT   DIVISION_ID
                      ,PLAN_START_YYYYMMDD
                      ,PLAN_TYPE
                      ,SEQ        
                      ,OPERATION_GROUP
                      ,FROM_SITE
                      ,ITEM_ID
                      ,YYYYMMDD
                      ,SUM((CASE WHEN PSI_TYPE ='S'                                                          THEN ISNULL(QTY,0) ELSE 0 END))   AS S
                      ,SUM((CASE WHEN PSI_TYPE ='P'                                                          THEN ISNULL(QTY,0) ELSE 0 END))   AS P
                      ,SUM((CASE WHEN PSI_TYPE ='I'AND  PSI_VALUE IN ('ACTIVATE_PROGRESS','MODEL_INVENTORY') THEN ISNULL(QTY,0) ELSE 0 END))   AS I
                FROM #tmp_SCP_ANL_PSI_PRODUCTION  WITH (NOLOCK)
                GROUP BY DIVISION_ID
                        ,PLAN_START_YYYYMMDD
                        ,PLAN_TYPE
                        ,SEQ        
                        ,OPERATION_GROUP
                        ,FROM_SITE
                        ,ITEM_ID
                        ,YYYYMMDD
            ) X
            UNPIVOT
            ( 
              QTY FOR PSI_TYPE IN (S, P, I)
              )
            AS UNPVT

		-- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
        SET @v_log_message = N'########## log step ##########';
        SET @v_description = @v_program_name + ':' + N' 03400 ';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								    ,@p_log_type      = N'TXN'        
								    ,@p_log_count     = 0       
								    ,@p_log_message   = @v_log_message       
								    ,@p_description   = @v_description       
								    ,@p_event_date    = @d_event_date       
								    ,@p_user_id       = @v_batch_user      
                                    ; 


          -------------------------------------------------------------------------------------------------------------                     
          -- 11. SCP_ANL_PSI_PRODUCTION 삭제                     
          --------------------------------------------------------------------------------------------------------------                      
            --DELETE FROM SCP_ANL_PSI_PRODUCTION                      
            --WHERE DIVISION_ID = @p_division_id AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND PLAN_TYPE = @p_plan_type AND SEQ = @p_seq
            --;          

            --WHILE @@ROWCOUNT > 0  -- 상단의 UPDATE문 @@ROWCOUNT
            --BEGIN
            --  DELETE TOP (10000)
            --  FROM SCP_ANL_PSI_PRODUCTION                            
            --  WHERE DIVISION_ID = @p_division_id AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND PLAN_TYPE = @p_plan_type AND SEQ = @p_seq        
            --END

			-- 2021.11.11 튜닝개선안에 따른 삭제방식 변경
			BEGIN TRAN
				WHILE(1 = 1)
				BEGIN
				  DELETE TOP (10000)
				  FROM dbo.SCP_ANL_PSI_PRODUCTION                            
				  WHERE DIVISION_ID = @p_division_id AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND PLAN_TYPE = @p_plan_type AND SEQ = @p_seq;

				  IF(@@ROWCOUNT = 0)
				  BEGIN
				   BREAK;
				  END
				END       
			COMMIT

		-- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
        SET @v_log_message = N'########## log step ##########';
        SET @v_description = @v_program_name + ':' + N' 03500 ';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								    ,@p_log_type      = N'TXN'        
								    ,@p_log_count     = 0       
								    ,@p_log_message   = @v_log_message       
								    ,@p_description   = @v_description       
								    ,@p_event_date    = @d_event_date       
								    ,@p_user_id       = @v_batch_user      
                                    ; 
                  
          -------------------------------------------------------------------------------------------------------------                     
          -- 12. SCP_ANL_PSI_PRODUCTION 입력                     
          --------------------------------------------------------------------------------------------------------------                    
          INSERT INTO /* PR_SCP_ANL_PSI_PRODUCTION */ dbo.SCP_ANL_PSI_PRODUCTION       WITH (TABLOCK)                    
                (                    
                   DIVISION_ID                              
                  ,PLAN_START_YYYYMMDD                      
                  ,PLAN_TYPE                                
                  ,SEQ                                      
                  ,OPERATION_GROUP                          
                  ,FROM_SITE                                
          ,ITEM_ID                                  
                  ,PSI_TYPE                                 
                  ,PSI_VALUE                                
                  ,TO_SITE                                  
                  ,PROD_LINE                                
                  ,YYYYMMDD                                                 
                  ,QTY                                      
                  ,INVENTORY_TYPE                 
                  ,ORIGIN_FROM_DIVISION_ID        
                  ,ORIGIN_TO_DIVISION_ID        
                  ,ELECTRODE_TYPE                  
                  ,CREATED_BY                               
                  ,CREATION_DATE                            
                  ,LAST_UPDATED_BY                          
                  ,LAST_UPDATE_DATE                     
                  ,ATTRIBUTE7    
                  ,ATTRIBUTE9
                  ,ATTRIBUTE10    
                )                    
              
              SELECT                  
                    X.DIVISION_ID                              
                   ,X.PLAN_START_YYYYMMDD                      
                   ,X.PLAN_TYPE                                
                   ,X.SEQ                                      
                   ,X.OPERATION_GROUP                          
                   ,X.FROM_SITE                    
                   ,X.ITEM_ID                                  
                   ,X.PSI_TYPE                                 
                   ,X.PSI_VALUE                               
                   ,X.TO_SITE                            
                   --,(CASE WHEN X.DIVISION_ID ='40' AND X.PSI_TYPE = 'S' THEN '-' ELSE X.PSI_VALUE END) 
                   --,(CASE WHEN X.DIVISION_ID ='40' AND X.PSI_TYPE = 'S' THEN '-' ELSE X.TO_SITE   END) 
                   ,X.PROD_LINE                                
                   ,X.YYYYMMDD                                 
                   ,SUM(X.QTY) AS QTY
                   ,X.INVENTORY_TYPE                    
                   ,X.ORIGIN_FROM_DIVISION_ID        
                   ,ISNULL(X.ORIGIN_TO_DIVISION_ID,'') AS     ORIGIN_TO_DIVISION_ID    
                   ,Y.ELECTRODE_TYPE                 
                   ,@v_batch_user AS CREATED_BY          
                   ,GETDATE()     AS CREATION_DATE                    
                   ,@v_batch_user AS LAST_UPDATED_BY                    
                   ,GETDATE()     AS LAST_UPDATED_BY    
                   ,X.ATTRIBUTE7
                   ,X.ATTRIBUTE9
                   ,X.ATTRIBUTE10                
              FROM #tmp_SCP_ANL_PSI_PRODUCTION X WITH (NOLOCK)                    
              INNER JOIN SCP_MST_FINAL_ITEM_V Y  WITH (NOLOCK)                    
                      ON 0 = 0    
                     AND X.ITEM_ID      = Y.ITEM_ID                                  
             WHERE 1 = 1     
			 -- * 2021.05.10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - start
             --AND X.YYYYMMDD < CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,@p_plan_start_yyyymmdd,112)),112)  
			 --
			 AND X.YYYYMMDD < @v_pet_date
			 -- * 2021.05.10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - end

             GROUP BY
                    X.DIVISION_ID                              
                   ,X.PLAN_START_YYYYMMDD                      
                   ,X.PLAN_TYPE                                
                   ,X.SEQ                                      
                   ,X.OPERATION_GROUP                          
                   ,X.FROM_SITE                    
                   ,X.ITEM_ID                                  
                   ,X.PSI_TYPE                                 
                   ,X.PSI_VALUE                                
                   ,X.TO_SITE                    
                   --,(CASE WHEN X.DIVISION_ID ='40' AND X.PSI_TYPE = 'S' THEN '-' ELSE X.PSI_VALUE END) 
                   --,(CASE WHEN X.DIVISION_ID ='40' AND X.PSI_TYPE = 'S' THEN '-' ELSE X.TO_SITE   END) 
                   ,X.PROD_LINE                                
                   ,X.YYYYMMDD                                 
                   ,X.INVENTORY_TYPE                    
                   ,X.ORIGIN_FROM_DIVISION_ID        
                   ,ISNULL(X.ORIGIN_TO_DIVISION_ID,'') 
                   ,Y.ELECTRODE_TYPE        
                   ,X.ATTRIBUTE7
                   ,ATTRIBUTE9
                   ,X.ATTRIBUTE10
             ;      

		-- E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
        SET @v_log_message = N'########## log step ##########';
        SET @v_description = @v_program_name + ':' + N' 03600 ';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								    ,@p_log_type      = N'TXN'        
								    ,@p_log_count     = 0       
								    ,@p_log_message   = @v_log_message       
								    ,@p_description   = @v_description       
								    ,@p_event_date    = @d_event_date       
								    ,@p_user_id       = @v_batch_user      
                                    ; 
            
        -------------------------------------------------------------------------------------------------------------
        -- TEMPDB TABLE DROP
        -------------------------------------------------------------------------------------------------------------
        IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_PRODUCTION') IS NOT NULL
            DROP TABLE #tmp_SCP_ANL_PSI_PRODUCTION
            
        IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_PRODUCTION_TCO') IS NOT NULL
            DROP TABLE #tmp_SCP_ANL_PSI_PRODUCTION_TCO
            
        IF OBJECT_ID('tempdb..#BOH') IS NOT NULL
            DROP TABLE #BOH
            
        IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_PRODUCTION_DIO') IS NOT NULL
            DROP TABLE #tmp_SCP_ANL_PSI_PRODUCTION_DIO
            
        IF OBJECT_ID('tempdb..#Tbl_DIO') IS NOT NULL
            DROP TABLE #Tbl_DIO   

        IF OBJECT_ID('tempdb..#BOH_DAYS') IS NOT NULL
            DROP TABLE #BOH_DAYS

        -----------------------------------------------------------                    
        -- 실행 Logic END --                    
        -----------------------------------------------------------                    
        --IF @@TRANCOUNT > 0                    
        --  BEGIN                    
        --    COMMIT TRAN TX_PSI1;                    
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
      --  BEGIN            ROLLBACK TRAN TX_PSI1                    
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
                    
--     임시 운영반영시에 주석처리 할것.                
     SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +                 
                          REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))                 
                
    -- 종료 LOG                    
    SET @v_log_type = N'END';                    
    SET @v_log_message = N'########## END of procedure ##########';                    
    SET @v_description = N'['+@p_master_id+']['+@p_engine_plan_id+'][' + @v_exec_time + ']';                  
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
      

