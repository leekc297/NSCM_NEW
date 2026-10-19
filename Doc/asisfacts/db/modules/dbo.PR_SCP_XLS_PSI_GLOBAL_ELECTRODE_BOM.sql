/*      
 * Program ID   : PR_SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM        
 * Description  : PR_SCP_XLS_CREATE_DATA 에서 호출함.      
 * OutTable     :      
 * Execute      : 
    -- DELETE FROM SCM_SYS_LOG_BATCH where CREATED_BY ='KTH'
    EXEC PR_SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM
       @p_plan_cycle          = 'WEEKLY'
     , @p_plan_start_yyyymmdd = '20191230'
     , @p_plan_id             = '1111'
	 , @p_modeling_id         = '4'
     , @p_seq                 = '1'
     , @p_plan_type           = 'FN'
     , @p_master_id           = 'EE::WEEKLY'
     , @p_division_id         = 'EE'
     , @p_engine_plan_id      = '1111::FN::1'
     , @p_user_id             = 'KTH'
 
     SELECT * FROM SCM_SYS_LOG_BATCH  where PROGRAM_NAME ='PR_SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM' order by CREATION_DATE desc

 * Program History      
 *===================================================================================================      
 *   Date       In Charge      Description      
 *===================================================================================================      
 * 2020.01.09   KTH         Initial Release [PJ20189106] 전지.GSCM 고도화 이행
 * 2020.01.30   KTH         SCM_DNM_STOCK_V TEMP 로직으로 반영
 * 2020.02.11   KTH         FROM SITE 보정
 * 2020.02.14   KTH         FROM SITE 로직 추가 CODE 1 
 * 2020.02.17   KTH         FROM SITE 로직 추가 CODE 3
 * 2020.02.24   KTH         LVL 3 로직 수정
 * 2020.04.27   KTH         반제품 재고의 Nick Name → Model Allocation에 검색 로직으로 변경
 * 2020.04.27   KTH         INTRANSIT 로직 변경, FROM CODE 1,4 로직 변경
 * 2020.05.20   KTH         FROM SITE 로직 변경 CODE 1 
 * 2020.07.29   KSW         일부 재고중복오류 수정 (ex: AFCFC0804A) STOCK_TYPE = 'INVENTORY'   
 *                          --> #TBL 에서 SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM 을 생성할 때 Group By 추가 (중복제거)
 * 2020.07.29   KSW         기준정보 SCM_DNM_STOCK_V.STORAGE_ID = 'MES' --> 'MES_DEP' 으로 변경
 * 2021.07.12   KSW         FROM_SITE 업데이트 쿼리추가
 * 2021.07.13   KSW         C20210702-000348 - 전극 시뮬레이터 내 BOH 보류재고 반영 로직 수정 요청의 건 - available_date(가용예상일자) 컬럼추가
 * 2021.07.28   KSW         SCP_MST_MODEL_ALLOCATION 에서 FROM_SITE_ID 를 찾을 경우 YYYYMMDD 조건절 추가 (일부누락로직 보완)
 * 2022.01.11   KSW         PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : scm_dnm_stock_v --> scm_dnm_stock 테이블로 변경
 * 2022.03.21   KSW         GM JV 반영
 * 2022.06.23   KSW			SCM_DNM_STOCK_V, SCM_DNM_INTRANSIT_V UC, LG 사업부 구분, UC, LG 사업부별 삭제조건 추가
 * 2023.03.13   HRK			[PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 
 *							 - SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM(BOH) 테이블 PK 컬럼 추가 반영 (ELEC_DIVISION_ID : EE/EE_UC) 
 * 2023.03.13   KKH         기준정보 SCM_DNM_STOCK_V.STORAGE_ID = 'MES_DEP' --> in ('MES_DEP','MES')   으로 변경
 * 2023.04.27   KKH         SCP_XLS_PSI_GLOBAL_ELECTRODE 문의 SCM_DNM_STOCK 테이블의 available_date를 참조
 * 2025.08.01   hrkim	    PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 : Cell 완성 공정 하드코딩 변경
 */    

-- SELECT * INTO SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM_20200420 FROM SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM WITH (NOLOCK)

CREATE PROCEDURE [dbo].[PR_SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM]
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
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM';      
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...      
    DECLARE @n_log_count    INTEGER = 0;      
    DECLARE @v_log_message  NVARCHAR(1000);      
    DECLARE @v_description  NVARCHAR(500);    
    DECLARE @v_table_id     NVARCHAR(150) = N'SCM_SYS_LOG_BATC';   
    DECLARE @d_event_date   DATETIME;      

	------------------------------------------------------------------------------------------------------------------
	-- [PJ20257329] 2025.08.01  Cell 완성 공정 하드코딩 변경 
	print  convert(varchar(30), getdate(), 121) + N' SCP Cell Final 공정 정보 - Cell Packaging/Assembly' 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#SCP_CELL_FINAL_OPERATION') IS NOT NULL DROP TABLE #SCP_CELL_FINAL_OPERATION
	SELECT DISTINCT SEGMENT1 AS OPERATION_ID
	  INTO #SCP_CELL_FINAL_OPERATION
	  FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
	 WHERE 1=1
	   AND LK.LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
	   AND LK.SEGMENT3	  = 'A'	 -- 공정그룹 (Cell)
	   AND LK.ATTRIBUTE1  = 'Y'	 -- Final Operation
	------------------------------------------------------------------------------------------------------------------

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

    DECLARE @p_program_id   NVARCHAR(30) = 'XLSPSI05'          
    DECLARE @p_to_yyyymmdd  VARCHAR(8)   =  CONVERT(VARCHAR(8), DATEADD(day, 364, @p_plan_start_yyyymmdd), 112)
    DECLARE @p_cutoff_date  VARCHAR(8)   =  CONVERT(VARCHAR(8), DATEADD(day,  -1, @p_plan_start_yyyymmdd), 112)

    --DECLARE @debug_mode            NVARCHAR(30) = 'T'
        BEGIN TRY        
          BEGIN        

            -------------------------------------------------------------------------------------------------------------         
            -- 조회 조건용 #tmp_SCM_ITEM_CLASS_M 임시테이블 생성
            -------------------------------------------------------------------------------------------------------------              
	            IF OBJECT_ID('tempdb..#tmp_SCM_ITEM_CLASS_M') IS NOT NULL	
	              DROP TABLE #tmp_SCM_ITEM_CLASS_M

  	          SELECT LEVEL_3_CODE,SCP_FLOW_ID,LEVEL_2_ID,USE_FLAG
                INTO #tmp_SCM_ITEM_CLASS_M
                FROM SCM_MST_ITEM_CLASS_SN  WITH (NOLOCK)
               WHERE USE_FLAG ='Y'

            -------------------------------------------------------------------------------------------------------------         
            --  임시테이블 생성 SCP_ENG_BOMCOMPONENTS_I_SN
            -------------------------------------------------------------------------------------------------------------     
              IF OBJECT_ID('tempdb..#tmp_SCP_ENG_BOMCOMPONENTS_I_SN') IS NOT NULL      
	              DROP TABLE #tmp_SCP_ENG_BOMCOMPONENTS_I_SN;        


                CREATE TABLE dbo.#tmp_SCP_ENG_BOMCOMPONENTS_I_SN(
	                  PLAN_ID           NVARCHAR(030)   NOT NULL,
	                  PLAN_TYPE         NVARCHAR(200)   NOT NULL,
	                  MODELING_ID       NVARCHAR(022)   NOT NULL,
	                  SEQ               NVARCHAR(022)   NOT NULL,
	                  ENTERPRISE        NVARCHAR(040)   NOT NULL,
	                  COMPANY_ID        NVARCHAR(030)   NOT NULL,
	                  DIVISION_ID       NVARCHAR(030)   NOT NULL,
	                  SITE_ID           NVARCHAR(030)   NOT NULL,
	                  PLANT_ID          NVARCHAR(030)   NOT NULL,
	                  MODEL_ID          NVARCHAR(255)   NOT NULL,
	                  PARENT_ITEM_ID    NVARCHAR(050)   NOT NULL,
	                  CHILD_ITEM_ID     NVARCHAR(050)   NOT NULL,
                  	--BOM_VERSION_ID  NVARCHAR(050)   NOT NULL,
	                  FLOW_ID           NVARCHAR(150)   NOT NULL,
                    --KEY_DATE        NVARCHAR(012)   NOT NULL,
                    --BOM_VERSION_LINE  NVARCHAR(050)     NULL,
	                  PARENT_QTY        NUMERIC(20, 10) NOT NULL,
                  	--PARENT_UOM        NVARCHAR(010) NOT NULL,
	                  CHILD_QTY         NUMERIC(20, 10) NOT NULL,
	                  --CHILD_UOM         NVARCHAR(10)  NOT NULL,
                    BOM_RN            INT
              );


            -------------------------------------------------------------------------------------------------------------------------         
            -- 반영될 최종 PLAN 대상 임시테이블 생성
            -------------------------------------------------------------------------------------------------------------------------

             IF OBJECT_ID('tempdb..#PLAN_CYCLE') IS NOT NULL      
	              DROP TABLE #PLAN_CYCLE;  

                SELECT *
                  INTO #PLAN_CYCLE
                  FROM (
                        SELECT       
                              M.PLAN_CYCLE
                              ,P.PLAN_NAME AS PLAN_START_YYYYMMDD
                              ,P.PLAN_ID
                              ,M.MODELING_ID
                              ,D.PLAN_SEQ
                              ,D.PLAN_TYPE
                              ,D.DIVISION_ID+'::'+M.PLAN_CYCLE AS MASTER_ID
                              ,D.DIVISION_ID
                              ,P.PLAN_ID+'::'+D.PLAN_TYPE+'::'+CONVERT(VARCHAR,D.PLAN_SEQ) AS ENG_PLAN_ID
       
                              ,D.UI_DISPLAY_YN
                              ,D.ACTIVE_FLAG
                              ,D.PLAN_STATUS
                              ,D.CREATION_DATE
                              ,ROW_NUMBER() OVER(PARTITION BY  D.DIVISION_ID
                                                    ORDER BY  D.DIVISION_ID
                                                            ,P.PLAN_NAME DESC
                                                            ,(CASE D.PLAN_TYPE  WHEN 'PR' THEN '1' 
                                                                                WHEN 'MA' THEN '2' 
                                                                                WHEN 'SE' THEN '3' 
                                                                                WHEN 'FN' THEN '4' ELSE '0' END) DESC
                                                            ,D.PLAN_SEQ  DESC
                                                            ,D.CREATION_DATE DESC) AS RN
                              ,D.CONFIRM_FLAG
                              ,D.CONFIRM_DATE
                        FROM SCM_MST_PLAN_DETAIL D WITH(NOLOCK),        
                              SCM_MST_PLAN        P WITH(NOLOCK),        
                            SCM_MST_MODELING    M WITH(NOLOCK)        
                        WHERE 1=1        
                          AND M.MODELING_ID   = D.MODELING_ID        
                          AND M.DIVISION_ID   = D.DIVISION_ID        
                          AND M.MODELING_ID   = D.MODELING_ID        
                          AND P.DIVISION_ID   = D.DIVISION_ID        
                          AND P.PLAN_CYCLE    = M.PLAN_CYCLE        
                          AND P.PLAN_ID       = D.PLAN_ID     
                          AND P.PLAN_CYCLE    ='WEEKLY'
                          --AND D.DIVISION_ID NOT LIKE 'EE%'		-- 2022.03.21 GM JV 반영
						  AND 'Y' = (CASE WHEN @p_division_id = 'EE'    AND D.DIVISION_ID IN ('81', '82', '40') THEN 'Y' 
						                  WHEN @p_division_id = 'EE_UC' AND D.DIVISION_ID = '81_UC' THEN 'Y'
						                  WHEN @p_division_id = 'EE_HM' AND D.DIVISION_ID = '81_HM' THEN 'Y'
										  ELSE 'N' END)
--                          AND D.CONFIRM_FLAG  ='Y'
                          AND D.PLAN_STATUS   ='1'
                          AND P.PLAN_NAME     = @p_plan_start_yyyymmdd
                    ) XX
                  WHERE XX.RN = 1

              INSERT INTO #tmp_SCP_ENG_BOMCOMPONENTS_I_SN
              SELECT   X.PLAN_ID       
                      ,X.PLAN_TYPE     
                      ,X.MODELING_ID   
                      ,X.SEQ           
                      ,X.ENTERPRISE    
                      ,X.COMPANY_ID    
                      ,X.DIVISION_ID   
                      ,X.SITE_ID       
                      ,X.PLANT_ID      
                      ,X.MODEL_ID      
                      ,X.PARENT_ITEM_ID
                      ,X.CHILD_ITEM_ID 
                      ,X.FLOW_ID       
                      ,X.PARENT_QTY    
                      ,X.CHILD_QTY
                      ,CONVERT(INT,ROW_NUMBER() OVER(ORDER BY (SELECT NULL))) AS BOM_RN
                FROM SCP_ENG_BOMCOMPONENTS_I_SN X WITH (NOLOCK)
                INNER JOIN #PLAN_CYCLE  Y WITH (NOLOCK)
                       ON 0 = 0
                      AND X.PLAN_TYPE   = Y.PLAN_TYPE
                      AND X.ENTERPRISE  = Y.MASTER_ID
                      AND X.SEQ         = Y.PLAN_SEQ
                      AND X.MODEL_ID    = PARENT_ITEM_ID  -- AFCFC0845A
                      AND X.PLAN_ID     = Y.PLAN_ID
                WHERE 0 = 0
                  AND LEFT(X.MODEL_ID,5) IN (
                                                    SELECT LEVEL_3_CODE
                                                    FROM  #tmp_SCM_ITEM_CLASS_M WITH (NOLOCK)
                                                    WHERE USE_FLAG = 'Y'
                                                    AND   SCP_FLOW_ID IS NOT NULL
                                                    AND   SCP_FLOW_ID LIKE 'A%'
                                                    -- [PJ20257329] 2025.08.01  ASIS와 동일 결과를 위해 주석처리-김춘동 책임님 confirm (기존 조건이 무의미함). AND   NOT(SCP_FLOW_ID IN (SELECT OPERATION_ID FROM #SCP_CELL_FINAL_OPERATION ))		-- [PJ20257329] 2025.08.01  Cell Final 공정 하드코딩 변경 
                                                    -- [PJ20257329] 2025.08.01  변경전 AND   NOT(SCP_FLOW_ID IN ('A9000
                                                    -- [PJ20257329] 2025.08.01  변경전 A3000'))
                                                )
                  AND LEFT(X.CHILD_ITEM_ID,5) IN (   
								                                  SELECT LEVEL_3_CODE
                                                    FROM #tmp_SCM_ITEM_CLASS_M WITH (NOLOCK)
                                                    WHERE USE_FLAG = 'Y'
                                                    AND   SCP_FLOW_ID IS NOT NULL
                                                    AND   (SCP_FLOW_ID LIKE 'A%' OR LEVEL_2_ID = 'ES03')
                                                    AND   NOT(SCP_FLOW_ID IN (SELECT OPERATION_ID FROM #SCP_CELL_FINAL_OPERATION ))		-- [PJ20257329] 2025.08.01  Cell Final 공정 하드코딩 변경 
                                                    -- [PJ20257329] 2025.08.01  변경전 AND   NOT(SCP_FLOW_ID IN ('A9000','A3000'))
								                    )
                --AND PLANT_ID ='G382'
                ORDER BY  MODEL_ID,PLANT_ID--,KEY_DATE 

                --SELECT DISTINCT DIVISION_ID, FLOW_ID FROM #tmp_SCP_ENG_BOMCOMPONENTS_I_SN WITH (NOLOCK)

            -------------------------------------------------------------------------------------------------------------------------         
            -- SCM_DNM_STOCK_V 임시테이블 생성
            -------------------------------------------------------------------------------------------------------------------------
            IF OBJECT_ID('tempdb..#tmp_SCM_DNM_STOCK_V') IS NOT NULL	
              DROP TABLE #tmp_SCM_DNM_STOCK_V

              SELECT DIVISION_ID
                    ,PLANT_ID
                    ,FACTORY_ID
                    ,ITEM_ID
                    ,STOCK_TYPE
                    ,SCM_SITE_ID
                    ,STORAGE_ID
                    ,OPERATION_ID
                    ,MES_MAP_SLOC
                    ,SCM_QTY
                    ,LEFT(SCM_SITE_ID,4) AS PLANT_ID2
                    ,LINE_ID
					--,AVAILABLE_DATE		-- KSW 2021.07.13 C20210702-000348 - 전극 시뮬레이터 내 BOH 보류재고 반영 로직 수정 요청의 건 - available_date(가용예상일자) 컬럼추가
					--2023.04.27   KKH
					,   CASE WHEN ISNULL(wiphold_yn, '') = ''          THEN CONVERT(DATETIME, dateadd(day,-1,@p_plan_start_yyyymmdd))
								WHEN wiphold_yn = 'N'                       THEN CONVERT(DATETIME, dateadd(day,-1,@p_plan_start_yyyymmdd))
								WHEN CONVERT(CHAR(8), available_date, 112) <=  dateadd(day,-1,@p_plan_start_yyyymmdd) THEN CONVERT(DATETIME, dateadd(day,-1,@p_plan_start_yyyymmdd))
								ELSE  CONVERT(DATE, CONVERT(CHAR(8), available_date, 112))  END AS AVAILABLE_DATE
                    ,CONVERT(INT,ROW_NUMBER() OVER(ORDER BY (SELECT NULL))) AS STOCK_RN
               INTO #tmp_SCM_DNM_STOCK_V 
               FROM DBO.SCM_DNM_STOCK WITH(NOLOCK)		-- 2022.01.11   KSW        PJ20216891 scm_dnm_stock_v --> scm_dnm_stock 테이블로 변경
              WHERE 1 = 1 
			    AND 'Y' = (CASE WHEN @p_division_id = 'EE'    AND DIVISION_ID IN ('81', '82', '40') THEN 'Y'	--> *** 2022.06.23 :: SCM_DNM_STOCK_V UC, LG 사업부 구분
						        WHEN @p_division_id = 'EE_UC' AND DIVISION_ID = '81_UC' THEN 'Y'
						        WHEN @p_division_id = 'EE_HM' AND DIVISION_ID = '81_HM' THEN 'Y'
								ELSE 'N' END)
                AND SCM_SITE_ID IS NOT NULL
                AND CUTOFF_DATE  = @p_cutoff_date
                AND LEFT(ITEM_ID,5) IN (   
								                          SELECT LEVEL_3_CODE
                                            FROM #tmp_SCM_ITEM_CLASS_M WITH (NOLOCK)
                                           WHERE USE_FLAG = 'Y'
                                             AND SCP_FLOW_ID IS NOT NULL
                                             AND (SCP_FLOW_ID LIKE 'A%' OR LEVEL_2_ID = 'ES03')
                                             AND NOT(SCP_FLOW_ID IN (SELECT OPERATION_ID FROM #SCP_CELL_FINAL_OPERATION ))		-- [PJ20257329] 2025.08.01  Cell Final 공정 하드코딩 변경 
                                             -- [PJ20257329] 2025.08.01  변경전 AND NOT(SCP_FLOW_ID IN ('A9000','A3000'))
								                      )

            -------------------------------------------------------------------------------------------------------------------------         
            -- ROOT 검색 NLEVEL = 3 --> 4도 있는데?
            -- WHILE 보다 속도가 빠름.
            -------------------------------------------------------------------------------------------------------------------------
              IF OBJECT_ID('tempdb..#TREE_MODEL') IS NOT NULL	
                DROP TABLE #TREE_MODEL

                ;
                WITH TREE_MODEL
                AS
                (
                  SELECT  A.SITE_ID
                        , A.PLANT_ID
                        , CONVERT(NUMERIC,B.SCM_QTY) AS SCM_QTY
                        , A.PARENT_ITEM_ID
                        , A.PARENT_QTY
                        , A.CHILD_ITEM_ID
                        , A.CHILD_QTY
                        , 1 AS NLEVEL
                        , CONVERT(NVARCHAR(200), A.PARENT_ITEM_ID + '^' + A.CHILD_ITEM_ID)  AS TREE_PATH
                        , CONVERT(INT,ROW_NUMBER() OVER( ORDER BY (SELECT NULL))) AS Rn
                        , A.BOM_RN
                        , B.STOCK_RN
                        , B.SCM_SITE_ID
						, B.AVAILABLE_DATE		-- KSW 2021.07.13 C20210702-000348 - 전극 시뮬레이터 내 BOH 보류재고 반영 로직 수정 요청의 건 - available_date(가용예상일자) 컬럼추가
                   FROM #tmp_SCP_ENG_BOMCOMPONENTS_I_SN A WITH (NOLOCK)
                  INNER JOIN  #tmp_SCM_DNM_STOCK_V B WITH (NOLOCK)
                     ON A.MODEL_ID = B.ITEM_ID
                  WHERE 0 = 0
                    AND A.PLANT_ID = B.PLANT_ID
                    AND B.SCM_QTY > 0.0
                UNION ALL
                 SELECT   A.SITE_ID
                        , A.PLANT_ID
                        , CONVERT(NUMERIC,(B.SCM_QTY * (B.CHILD_QTY/(CASE WHEN A.PARENT_QTY  = 0 THEN 1 ELSE A.PARENT_QTY END) ) ))
                        , A.PARENT_ITEM_ID
                        , A.PARENT_QTY
                        , A.CHILD_ITEM_ID
                        , A.CHILD_QTY
                        , NLEVEL+1 AS NLEVEL
                        , CONVERT(NVARCHAR(200), B.TREE_PATH  + '^' + A.CHILD_ITEM_ID) AS TREE_PATH
                        , Rn
                        , B.BOM_RN
                        , B.STOCK_RN
                        , B.SCM_SITE_ID
						, B.AVAILABLE_DATE		-- KSW 2021.07.13 C20210702-000348 - 전극 시뮬레이터 내 BOH 보류재고 반영 로직 수정 요청의 건 - available_date(가용예상일자) 컬럼추가
                 FROM #tmp_SCP_ENG_BOMCOMPONENTS_I_SN A  WITH (NOLOCK)
                 INNER JOIN TREE_MODEL  B  --WITH (NOLOCK)
                 ON A.PARENT_ITEM_ID = B.CHILD_ITEM_ID
                )

                --DROP TABLE #TREE_MODEL3
                SELECT DISTINCT *
                     , X.CHILD_QTY/(CASE WHEN X.PARENT_QTY  = 0 THEN 1 ELSE X.PARENT_QTY END) AS RATIO
                     , CONVERT(NVARCHAR(150)  ,NULL)  AS ELEC_ITEM_ID
                     , CONVERT(NUMERIC (20,10),NULL)  AS CONVERT_QTY_CELL
                     , CONVERT(NVARCHAR(150)  ,NULL)  AS FROM_SITE_ID
                     , CONVERT(NVARCHAR(150)  ,NULL)  AS CELL_ITEM_ID
                INTO #TREE_MODEL
                FROM  TREE_MODEL X  WITH (NOLOCK)
                WHERE 0 = 0
                --AND  TREE_PATH LIKE '%AFCFC0845A%'
                --AND  TREE_PATH LIKE '%AMCSA0021A%'
                --AND STOCK_RN ='1457'
                AND LEFT(X.SCM_SITE_ID,4) = X.PLANT_ID
                ORDER BY NLEVEL,STOCK_RN,BOM_RN  --

                Option (MaxRecursion 7)
                ;

                IF OBJECT_ID('tempdb..#ITEM_ID_LVL1') IS NOT NULL	
                  DROP TABLE #ITEM_ID_LVL1

                  SELECT DISTINCT MAX(NLEVEL) AS LVL ,
                          LEFT(TREE_PATH, PATINDEX('%^%',TREE_PATH)-1) AS ITEM_ID
                  INTO #ITEM_ID_LVL1
                  FROM #TREE_MODEL WITH (NOLOCK)
                  WHERE 0 = 0
                  --AND  TREE_PATH LIKE '%AFCFC0845A%'
                  --AND  TREE_PATH LIKE '%AMCSA0021A%'
                  --AND STOCK_RN ='1457'
                  GROUP BY STOCK_RN,LEFT(TREE_PATH, PATINDEX('%^%',TREE_PATH)-1)
                  --HAVING MAX(NLEVEL) = 3
                  --ORDER BY 2,1


            -------------------------------------------------------------------------------------------------------------------------         
            -- LOOP 작업 LEVEL 1
            -------------------------------------------------------------------------------------------------------------------------
             IF OBJECT_ID('tempdb..#TREE_MODEL1') IS NOT NULL	
              DROP TABLE #TREE_MODEL1

              ;
              WITH TREE_MODEL
              AS
              (
                SELECT  A.SITE_ID
                      , A.PLANT_ID
                      , CONVERT(NUMERIC,B.SCM_QTY) AS SCM_QTY
                      , A.PARENT_ITEM_ID
                      , A.PARENT_QTY
                      , A.CHILD_ITEM_ID
                      , A.CHILD_QTY
                      , 1 AS NLEVEL
                      , CONVERT(NVARCHAR(200), A.PARENT_ITEM_ID + '^' + A.CHILD_ITEM_ID)  AS TREE_PATH
                      , CONVERT(INT,ROW_NUMBER() OVER( ORDER BY (SELECT NULL))) AS Rn
                      , A.BOM_RN
                      , B.STOCK_RN
                      , B.SCM_SITE_ID
					  , B.AVAILABLE_DATE		-- KSW 2021.07.13 C20210702-000348 - 전극 시뮬레이터 내 BOH 보류재고 반영 로직 수정 요청의 건 - available_date(가용예상일자) 컬럼추가
                 FROM #tmp_SCP_ENG_BOMCOMPONENTS_I_SN A WITH (NOLOCK)
                INNER JOIN  #tmp_SCM_DNM_STOCK_V B WITH (NOLOCK)
                   ON A.MODEL_ID = B.ITEM_ID
                WHERE 0 = 0
                  --AND A.FLOW_ID  LIKE 'A8%'   -- A8000, 40은 A81000
                  AND A.PARENT_ITEM_ID IN (SELECT ITEM_ID FROM #ITEM_ID_LVL1  WITH (NOLOCK) WHERE LVL = 3)
                  AND A.PLANT_ID = B.PLANT_ID
                  AND B.SCM_QTY > 0.0
              UNION ALL
               SELECT   A.SITE_ID
                      , A.PLANT_ID
                      , CONVERT(NUMERIC,(B.SCM_QTY * (B.CHILD_QTY/(CASE WHEN A.PARENT_QTY  = 0 THEN 1 ELSE A.PARENT_QTY END) ) ))
                      , A.PARENT_ITEM_ID
                      , A.PARENT_QTY
                      , A.CHILD_ITEM_ID
                      , A.CHILD_QTY
                      , NLEVEL+1 AS NLEVEL
                      , CONVERT(NVARCHAR(200), B.TREE_PATH  + '^' + A.CHILD_ITEM_ID) AS TREE_PATH
                      , Rn
                      , B.BOM_RN
                      , B.STOCK_RN
                      , B.SCM_SITE_ID
					  , B.AVAILABLE_DATE		-- KSW 2021.07.13 C20210702-000348 - 전극 시뮬레이터 내 BOH 보류재고 반영 로직 수정 요청의 건 - available_date(가용예상일자) 컬럼추가
               FROM #tmp_SCP_ENG_BOMCOMPONENTS_I_SN A  WITH (NOLOCK)
               INNER JOIN TREE_MODEL  B  --WITH (NOLOCK)
               ON A.PARENT_ITEM_ID = B.CHILD_ITEM_ID
              WHERE  0 = 0
              --   AND A.MODEL_ID      = 'AFCFC0845A' 
              )

              --DROP TABLE #TREE_MODEL3
              SELECT DISTINCT *
                   , X.CHILD_QTY/(CASE WHEN X.PARENT_QTY  = 0 THEN 1 ELSE X.PARENT_QTY END) AS RATIO
                   , CONVERT(NVARCHAR(150)  ,NULL)  AS ELEC_ITEM_ID
                   , CONVERT(NUMERIC (20,10),NULL)  AS CONVERT_QTY_CELL
                   , CONVERT(NVARCHAR(150)  ,NULL)  AS FROM_SITE_ID
                   , CONVERT(NVARCHAR(150)  ,NULL)  AS CELL_ITEM_ID
              INTO #TREE_MODEL1
              FROM  TREE_MODEL X  WITH (NOLOCK)
              WHERE 0 = 0
              --AND  TREE_PATH LIKE 'AFCFC0845A%'
              AND LEFT(X.SCM_SITE_ID,4) = X.PLANT_ID
              ORDER BY TREE_PATH,NLEVEL  --

              Option (MaxRecursion 4)


            -------------------------------------------------------------------------------------------------------------------------         
            -- 그룹핑 기준 데이터 생성 외 ELEC_ITEM_ID,CONVERT_QTY_CELL,FROM_SITE_ID
            -------------------------------------------------------------------------------------------------------------------------

              UPDATE X
                 SET X.CONVERT_QTY_CELL = ISNULL(Y.CONVERT_QTY_CELL,1) 
                    ,X.CELL_ITEM_ID     =Y.CELL_ITEM_ID
                FROM #TREE_MODEL1 X WITH (NOLOCK)
                INNER JOIN SCP_MST_FINAL_ITEM Y WITH (NOLOCK) 
                   ON 0 = 0
                  AND Y.ITEM_ID = X.CHILD_ITEM_ID
                  --AND X.DIVISION_ID = Y.DIVISION_ID
                  AND X.NLEVEL  = 3
                  AND Y.OPERATION_GROUP ='E'


              UPDATE X
                 SET X.ELEC_ITEM_ID     = Y.CHILD_ITEM_ID 
                FROM #TREE_MODEL1 X WITH (NOLOCK)
               INNER JOIN #TREE_MODEL1 Y WITH (NOLOCK)
                  ON 0 = 0
                 AND X.SITE_ID       = Y.SITE_ID
                --AND X.ITEM_ID     = Y.ITEM_ID
                --AND X.STOCK_TYPE  = Y.STOCK_TYPE
                 AND X.RN            = Y.RN
                 AND Y.NLEVEL        = 3
                 AND X.BOM_RN        = Y.BOM_RN
                 AND X.STOCK_RN      = Y.STOCK_RN
                 AND X.PLANT_ID      = Y.PLANT_ID
                 AND X.NLEVEL        = 2
                 AND X.CHILD_ITEM_ID = Y.PARENT_ITEM_ID

              UPDATE X
                 SET X.ELEC_ITEM_ID = (SELECT TOP 1 Z.CHILD_ITEM_ID 
                                      FROM #TREE_MODEL1  Z WITH (NOLOCK)
                                     WHERE 0 = 0
                                       AND X.SITE_ID       = Z.SITE_ID
                                       AND X.RN            = Z.RN
                                       AND 3               = Z.NLEVEL
                                       AND X.BOM_RN        = Z.BOM_RN
                                       AND X.STOCK_RN      = Z.STOCK_RN
                                       AND X.PLANT_ID      = Z.PLANT_ID
                                       --AND X.CHILD_ITEM_ID = Z.PARENT_ITEM_ID
                                 )
                FROM #TREE_MODEL1 X WITH (NOLOCK)
                WHERE X.NLEVEL = 1

            -------------------------------------------------------------------------------------------------------------------------         
            -- 그룹핑 L1,L2,L3,L1_QTY,L2_QTY,L3_QTY
            -------------------------------------------------------------------------------------------------------------------------
              IF OBJECT_ID('tempdb..#GROUP_TBL1') IS NOT NULL	
                DROP TABLE #GROUP_TBL1

                SELECT MAX(Y.PLAN_ID)       AS PLAN_ID
                      ,MAX(Y.PLAN_TYPE)     AS PLAN_TYPE
                      ,MAX(Y.DIVISION_ID)   AS DIVISION_ID
                      ,MAX(X.PLANT_ID)      AS PLANT_ID
                --      ,X.PLANT_ID
                      ,Y.MODEL_ID           AS ITEM_ID
                      ,MAX(Z.STOCK_TYPE)    AS STOCK_TYPE
                      ,NULL                 AS STORAGE_DESCRIPTION
                      ,MAX(Z.SCM_SITE_ID)   AS SCM_SITE_ID
                      ,MAX(Z.STORAGE_ID)    AS STORAGE_ID
                      ,MAX(Z.OPERATION_ID)  AS OPERATION_ID
                      ,MAX(Z.MES_MAP_SLOC)  AS MES_MAP_SLOC
                --      ,MAX(X.SCM_QTY)       AS SCM_QTY
                      ,MAX(CASE WHEN NLEVEL = 1 THEN X.SCM_QTY            ELSE NULL         END) AS SCM_QTY
                      ,MAX(CASE WHEN NLEVEL = 1 THEN X.CHILD_ITEM_ID      ELSE NULL         END) AS L1
                      ,SUM(CASE WHEN NLEVEL = 1 THEN X.SCM_QTY * X.RATIO  ELSE NULL         END) AS L1_QTY
                      ,MAX(CASE WHEN NLEVEL = 2 THEN X.CHILD_ITEM_ID      ELSE NULL         END) AS L2
                      ,SUM(CASE WHEN NLEVEL = 2 THEN X.SCM_QTY * X.RATIO  ELSE NULL         END) AS L2_QTY
                      ,MAX(CASE WHEN NLEVEL = 3 THEN X.CHILD_ITEM_ID      ELSE NULL         END) AS L3
                      ,SUM(CASE WHEN NLEVEL = 3 THEN X.SCM_QTY * X.RATIO  ELSE NULL         END) AS L3_QTY
                      ,MAX(CASE WHEN NLEVEL = 3 THEN X.CHILD_ITEM_ID      ELSE X.ELEC_ITEM_ID  END) AS ELEC_ITEM_ID
                      ,NULL AS CONVERT_QTY
                      ,FROM_SITE_ID
                      ,Z.SCM_SITE_ID AS TO_SITE_ID
                      ,X.RN
                      ,X.BOM_RN
                      ,X.STOCK_RN
                      ,X.NLEVEL
                      ,X.PARENT_ITEM_ID
                      ,X.CHILD_ITEM_ID
                      ,X.CONVERT_QTY_CELL
                      ,X.CELL_ITEM_ID
					  ,X.AVAILABLE_DATE		-- KSW 2021.07.13 C20210702-000348 - 전극 시뮬레이터 내 BOH 보류재고 반영 로직 수정 요청의 건 - available_date(가용예상일자) 컬럼추가
                INTO #GROUP_TBL1
                FROM #TREE_MODEL1 X WITH (NOLOCK)
               INNER JOIN #tmp_SCP_ENG_BOMCOMPONENTS_I_SN Y WITH (NOLOCK)
                  ON X.BOM_RN = Y.BOM_RN
               INNER JOIN #tmp_SCM_DNM_STOCK_V Z WITH (NOLOCK)
                  ON X.STOCK_RN = Z.STOCK_RN
               WHERE 0 = 0
                --AND X.BOM_RN     = '1032'
                --AND X.STOCK_RN   = '3054'
                --AND X.PLANT_ID   = 'G382'
               GROUP BY Y.MODEL_ID
                       ,X.CHILD_ITEM_ID
                --     ,NULL AS Convert_Qty
                       ,FROM_SITE_ID
                       ,Z.SCM_SITE_ID 
                       ,X.RN
                       ,X.BOM_RN
                       ,X.STOCK_RN
                       ,X.NLEVEL
                       ,X.PARENT_ITEM_ID
                       ,X.CONVERT_QTY_CELL
                --     ,X.RATIO
--                       ,X.PLANT_ID
                       ,X.CELL_ITEM_ID
					   ,X.AVAILABLE_DATE		-- KSW 2021.07.13 C20210702-000348 - 전극 시뮬레이터 내 BOH 보류재고 반영 로직 수정 요청의 건 - available_date(가용예상일자) 컬럼추가

            -------------------------------------------------------------------------------------------------------------------------         
            -- 그룹핑2 MERSEGE 처리
            -------------------------------------------------------------------------------------------------------------------------
              IF OBJECT_ID('tempdb..#BOM1') IS NOT NULL	
                DROP TABLE #BOM1

                SELECT PLAN_ID	
                      ,PLAN_TYPE	
                      ,DIVISION_ID	
                      ,PLANT_ID	
                      ,ITEM_ID	
                      ,STOCK_TYPE	
                      ,CONVERT(NVARCHAR(150), STORAGE_DESCRIPTION	) AS STORAGE_DESCRIPTION
                      ,SCM_SITE_ID	
                      ,STORAGE_ID	
                      ,OPERATION_ID	
                      ,CONVERT(NVARCHAR(150), MES_MAP_SLOC) AS MES_MAP_SLOC	
                      ,SUM(ISNULL(SCM_QTY,0))   AS SCM_QTY	
                      ,MAX(CONVERT(NVARCHAR(150), L1)) AS L1
                      ,SUM(ISNULL(L1_QTY,0))    AS L1_QTY
                      ,MAX(CONVERT(NVARCHAR(150), L2))                  AS L2
                      ,SUM(ISNULL(L2_QTY,0))    AS L2_QTY
                      ,MAX(CONVERT(NVARCHAR(150), L3))                  AS L3
                      ,SUM(ISNULL(L3_QTY,0))    AS L3_QTY
                      ,ELEC_ITEM_ID	
                      ,SUM(ISNULL(L3_QTY,0)) * MAX(X.CONVERT_QTY_CELL) AS CONVERT_QTY	
                      ,MAX(X.CONVERT_QTY_CELL)  AS CONVERT_QTY_CELL
                      ,MAX(X.CELL_ITEM_ID) AS CELL_ITEM_ID
                      ,FROM_SITE_ID
                      ,TO_SITE_ID	
                      ,X.RN
                      ,X.BOM_RN
                      ,X.STOCK_RN
                      ,'1' AS LVL
					  ,X.AVAILABLE_DATE		-- KSW 2021.07.13 C20210702-000348 - 전극 시뮬레이터 내 BOH 보류재고 반영 로직 수정 요청의 건 - available_date(가용예상일자) 컬럼추가
               INTO #BOM1
               FROM #GROUP_TBL1 X WITH (NOLOCK)
              WHERE 0 = 0
              --AND X.BOM_RN     = '1032'
              --AND X.STOCK_RN   = '3054'
              GROUP BY PLAN_ID	
                      ,PLAN_TYPE	
                      ,DIVISION_ID	
                      ,PLANT_ID
                      ,ITEM_ID	
                      ,STOCK_TYPE	
                      ,STORAGE_DESCRIPTION
                      ,SCM_SITE_ID	
                      ,STORAGE_ID	
                      ,OPERATION_ID	
                      ,MES_MAP_SLOC	
            --          ,SCM_QTY	
                      ,ELEC_ITEM_ID	
            --          ,Convert_Qty	
                      ,FROM_SITE_ID
                      ,TO_SITE_ID	
                      ,X.RN
                      ,X.BOM_RN
                      ,X.STOCK_RN
					  ,X.AVAILABLE_DATE		-- KSW 2021.07.13 C20210702-000348 - 전극 시뮬레이터 내 BOH 보류재고 반영 로직 수정 요청의 건 - available_date(가용예상일자) 컬럼추가



            -------------------------------------------------------------------------------------------------------------------------         
            -- LOOP 작업 LEVEL 2
            -------------------------------------------------------------------------------------------------------------------------
             IF OBJECT_ID('tempdb..#TREE_MODEL2') IS NOT NULL	
              DROP TABLE #TREE_MODEL2

              ;
              WITH TREE_MODEL
              AS
              (
                SELECT  A.SITE_ID
                      , A.PLANT_ID
                      , CONVERT(NUMERIC,B.SCM_QTY) AS SCM_QTY
                      , A.PARENT_ITEM_ID
                      , A.PARENT_QTY
                      , A.CHILD_ITEM_ID
                      , A.CHILD_QTY
                      , 1 AS NLEVEL
                      , CONVERT(NVARCHAR(200), A.PARENT_ITEM_ID + '^' + A.CHILD_ITEM_ID)  AS TREE_PATH
                      , CONVERT(INT,ROW_NUMBER() OVER( ORDER BY (SELECT NULL))) AS Rn
                      , A.BOM_RN
                      , B.STOCK_RN
                      , B.SCM_SITE_ID
					  , B.AVAILABLE_DATE		-- KSW 2021.07.13 C20210702-000348 - 전극 시뮬레이터 내 BOH 보류재고 반영 로직 수정 요청의 건 - available_date(가용예상일자) 컬럼추가
                 FROM #tmp_SCP_ENG_BOMCOMPONENTS_I_SN A WITH (NOLOCK)
                INNER JOIN  #tmp_SCM_DNM_STOCK_V B WITH (NOLOCK)
                   ON A.MODEL_ID = B.ITEM_ID
                WHERE 0 = 0
                  AND A.PARENT_ITEM_ID IN (SELECT ITEM_ID FROM #ITEM_ID_LVL1  WITH (NOLOCK) WHERE LVL = 2)
                  AND A.PLANT_ID = B.PLANT_ID
                  AND B.SCM_QTY > 0.0
              --   AND A.MODEL_ID = 'AFCFC0845A'    
                 --AND A.PLANT_ID ='G382'
              UNION ALL
               SELECT   A.SITE_ID
                      , A.PLANT_ID
                      , CONVERT(NUMERIC,(B.SCM_QTY * (B.CHILD_QTY/(CASE WHEN A.PARENT_QTY  = 0 THEN 1 ELSE A.PARENT_QTY END) ) ))
                      , A.PARENT_ITEM_ID
                      , A.PARENT_QTY
                      , A.CHILD_ITEM_ID
                      , A.CHILD_QTY
                      , NLEVEL+1 AS NLEVEL
                      , CONVERT(NVARCHAR(200), B.TREE_PATH  + '^' + A.CHILD_ITEM_ID) AS TREE_PATH
                      , Rn
                      , B.BOM_RN
                      , B.STOCK_RN
                      , B.SCM_SITE_ID
					  , B.AVAILABLE_DATE		-- KSW 2021.07.13 C20210702-000348 - 전극 시뮬레이터 내 BOH 보류재고 반영 로직 수정 요청의 건 - available_date(가용예상일자) 컬럼추가
               FROM #tmp_SCP_ENG_BOMCOMPONENTS_I_SN A  WITH (NOLOCK)
               INNER JOIN TREE_MODEL  B  --WITH (NOLOCK)
               ON A.PARENT_ITEM_ID = B.CHILD_ITEM_ID
              WHERE  0 = 0
              --   AND A.MODEL_ID      = 'AFCFC0845A' 
              )

              --DROP TABLE #TREE_MODEL3
              SELECT DISTINCT *
                   , X.CHILD_QTY/(CASE WHEN X.PARENT_QTY  = 0 THEN 1 ELSE X.PARENT_QTY END) AS RATIO
                   , CONVERT(NVARCHAR(150)  ,NULL)  AS ELEC_ITEM_ID
                   , CONVERT(NUMERIC (20,10),NULL)  AS CONVERT_QTY_CELL
                   , CONVERT(NVARCHAR(150)  ,NULL)  AS FROM_SITE_ID
                   , CONVERT(NVARCHAR(150)  ,NULL)  AS CELL_ITEM_ID
              INTO #TREE_MODEL2
              FROM  TREE_MODEL X  WITH (NOLOCK)
              WHERE 0 = 0
              --AND  TREE_PATH LIKE 'AFCFC0845A%'
              AND LEFT(X.SCM_SITE_ID,4) = X.PLANT_ID
              ORDER BY TREE_PATH,NLEVEL  --

              Option (MaxRecursion 4)

              
            -------------------------------------------------------------------------------------------------------------------------         
            -- 그룹핑 기준 데이터 생성 외 ELEC_ITEM_ID,CONVERT_QTY_CELL,FROM_SITE_ID
            -------------------------------------------------------------------------------------------------------------------------

              UPDATE X
                 SET X.CONVERT_QTY_CELL = ISNULL(Y.CONVERT_QTY_CELL,1) 
                    ,X.CELL_ITEM_ID     =Y.CELL_ITEM_ID
                FROM #TREE_MODEL2 X WITH (NOLOCK)
                INNER JOIN SCP_MST_FINAL_ITEM Y WITH (NOLOCK) 
                   ON 0 = 0
                  AND Y.ITEM_ID = X.CHILD_ITEM_ID
                  --AND X.DIVISION_ID = Y.DIVISION_ID
                  AND X.NLEVEL  = 2
                  AND Y.OPERATION_GROUP ='E'


              UPDATE X
                 SET X.ELEC_ITEM_ID     = Y.CHILD_ITEM_ID 
                FROM #TREE_MODEL2 X WITH (NOLOCK)
               INNER JOIN #TREE_MODEL2 Y WITH (NOLOCK)
                  ON 0 = 0
                 AND X.SITE_ID       = Y.SITE_ID
                --AND X.ITEM_ID     = Y.ITEM_ID
                --AND X.STOCK_TYPE  = Y.STOCK_TYPE
                 AND X.RN            = Y.RN
                 AND Y.NLEVEL        = 2
                 AND X.BOM_RN        = Y.BOM_RN
                 AND X.STOCK_RN      = Y.STOCK_RN
                 AND X.PLANT_ID      = Y.PLANT_ID
                 AND X.NLEVEL        = 1
                 AND X.CHILD_ITEM_ID = Y.PARENT_ITEM_ID
              /*
              UPDATE X
                 SET X.ELEC_ITEM_ID = (SELECT TOP 1 Z.CHILD_ITEM_ID 
                                      FROM #TREE_MODEL2  Z WITH (NOLOCK)
                                     WHERE 0 = 0
                                       AND X.SITE_ID       = Z.SITE_ID
                                       AND X.RN            = Z.RN
                                       AND 2               = Z.NLEVEL
                                       AND X.BOM_RN        = Z.BOM_RN
                                       AND X.STOCK_RN      = Z.STOCK_RN
                                       AND X.PLANT_ID      = Z.PLANT_ID
                                       --AND X.CHILD_ITEM_ID = Z.PARENT_ITEM_ID
                                 )
                FROM #TREE_MODEL2 X WITH (NOLOCK)
                WHERE X.NLEVEL = 1
                */

            -------------------------------------------------------------------------------------------------------------------------         
            -- 그룹핑 L1,L2,L3,L1_QTY,L2_QTY,L3_QTY
            -------------------------------------------------------------------------------------------------------------------------
              IF OBJECT_ID('tempdb..#GROUP_TBL2') IS NOT NULL	
                DROP TABLE #GROUP_TBL2

                SELECT MAX(Y.PLAN_ID)       AS PLAN_ID
                      ,MAX(Y.PLAN_TYPE)     AS PLAN_TYPE
                      ,MAX(Y.DIVISION_ID)   AS DIVISION_ID
                      ,MAX(X.PLANT_ID)      AS PLANT_ID
                --      ,X.PLANT_ID
                      ,Y.MODEL_ID           AS ITEM_ID
                      ,MAX(Z.STOCK_TYPE)    AS STOCK_TYPE
                      ,NULL                 AS STORAGE_DESCRIPTION
                      ,MAX(Z.SCM_SITE_ID)   AS SCM_SITE_ID
                      ,MAX(Z.STORAGE_ID)    AS STORAGE_ID
                      ,MAX(Z.OPERATION_ID)  AS OPERATION_ID
                      ,MAX(Z.MES_MAP_SLOC)  AS MES_MAP_SLOC
                --      ,MAX(X.SCM_QTY)       AS SCM_QTY
                      ,MAX(CASE WHEN NLEVEL = 1 THEN X.SCM_QTY            ELSE NULL         END) AS SCM_QTY
                      ,MAX(CASE WHEN NLEVEL = 1 THEN X.CHILD_ITEM_ID      ELSE NULL         END) AS L1
                      ,SUM(CASE WHEN NLEVEL = 1 THEN X.SCM_QTY * X.RATIO  ELSE NULL         END) AS L1_QTY
                      ,MAX(CASE WHEN NLEVEL = 2 THEN X.CHILD_ITEM_ID      ELSE NULL         END) AS L2
                      ,SUM(CASE WHEN NLEVEL = 2 THEN X.SCM_QTY * X.RATIO  ELSE NULL         END) AS L2_QTY
                      ,MAX(CASE WHEN NLEVEL = 3 THEN X.CHILD_ITEM_ID      ELSE NULL         END) AS L3
                      ,SUM(CASE WHEN NLEVEL = 3 THEN X.SCM_QTY * X.RATIO  ELSE NULL         END) AS L3_QTY
                      ,MAX(CASE WHEN NLEVEL = 2 THEN X.CHILD_ITEM_ID      ELSE X.ELEC_ITEM_ID  END) AS ELEC_ITEM_ID
                      ,NULL AS CONVERT_QTY
                      ,FROM_SITE_ID
                      ,Z.SCM_SITE_ID AS TO_SITE_ID
                      ,X.RN
                      ,X.BOM_RN
                      ,X.STOCK_RN
                      ,X.NLEVEL
                      ,X.PARENT_ITEM_ID
                      ,X.CHILD_ITEM_ID
                      ,X.CONVERT_QTY_CELL
                      ,X.CELL_ITEM_ID
					  ,X.AVAILABLE_DATE		-- KSW 2021.07.13 C20210702-000348 - 전극 시뮬레이터 내 BOH 보류재고 반영 로직 수정 요청의 건 - available_date(가용예상일자) 컬럼추가
                INTO #GROUP_TBL2
                FROM #TREE_MODEL2 X WITH (NOLOCK)
               INNER JOIN #tmp_SCP_ENG_BOMCOMPONENTS_I_SN Y WITH (NOLOCK)
                  ON X.BOM_RN = Y.BOM_RN
               INNER JOIN #tmp_SCM_DNM_STOCK_V Z WITH (NOLOCK)
                  ON X.STOCK_RN = Z.STOCK_RN
               WHERE 0 = 0
                --AND X.BOM_RN     = '1032'
                --AND X.STOCK_RN   = '3054'
                --AND X.PLANT_ID   = 'G382'
               GROUP BY Y.MODEL_ID
                       ,X.CHILD_ITEM_ID
                --     ,NULL AS Convert_Qty
                       ,FROM_SITE_ID
                       ,Z.SCM_SITE_ID 
                       ,X.RN
                       ,X.BOM_RN
                       ,X.STOCK_RN
                       ,X.NLEVEL
                       ,X.PARENT_ITEM_ID
                       ,X.CONVERT_QTY_CELL
                --     ,X.RATIO
                       --,X.PLANT_ID
                       ,X.CELL_ITEM_ID
					   ,X.AVAILABLE_DATE		-- KSW 2021.07.13 C20210702-000348 - 전극 시뮬레이터 내 BOH 보류재고 반영 로직 수정 요청의 건 - available_date(가용예상일자) 컬럼추가

            -------------------------------------------------------------------------------------------------------------------------         
            -- 그룹핑2 MERSEGE 처리
            -------------------------------------------------------------------------------------------------------------------------
              IF OBJECT_ID('tempdb..#BOM2') IS NOT NULL	
                DROP TABLE #BOM2

                SELECT PLAN_ID	
                      ,PLAN_TYPE	
                      ,DIVISION_ID	
                      ,PLANT_ID	
                      ,ITEM_ID	
                      ,STOCK_TYPE	
                      ,CONVERT(NVARCHAR(150), STORAGE_DESCRIPTION	) AS STORAGE_DESCRIPTION
                      ,SCM_SITE_ID	
                      ,STORAGE_ID	
                      ,OPERATION_ID	
                      ,CONVERT(NVARCHAR(150), MES_MAP_SLOC) AS MES_MAP_SLOC	
                      ,SUM(ISNULL(SCM_QTY,0))   AS SCM_QTY	
                      ,MAX(CONVERT(NVARCHAR(150), L1)) AS L1
                      ,SUM(ISNULL(L1_QTY,0))    AS L1_QTY
                      ,MAX(CONVERT(NVARCHAR(150), L2)) AS L2
                      ,SUM(ISNULL(L2_QTY,0))    AS L2_QTY
                      ,MAX(CONVERT(NVARCHAR(150), L3)) AS L3
                      ,SUM(ISNULL(L3_QTY,0))    AS L3_QTY
                      ,ELEC_ITEM_ID	
                      ,SUM(ISNULL(L2_QTY,0)) * MAX(X.CONVERT_QTY_CELL) AS CONVERT_QTY	
                      ,MAX(X.CONVERT_QTY_CELL)  AS CONVERT_QTY_CELL
                      ,MAX(X.CELL_ITEM_ID)      AS CELL_ITEM_ID 
                      ,FROM_SITE_ID
                      ,TO_SITE_ID	
                      ,X.RN
                      ,X.BOM_RN
                      ,X.STOCK_RN
                      ,'2' AS LVL
					  ,X.AVAILABLE_DATE		-- KSW 2021.07.13 C20210702-000348 - 전극 시뮬레이터 내 BOH 보류재고 반영 로직 수정 요청의 건 - available_date(가용예상일자) 컬럼추가
               INTO #BOM2
               FROM #GROUP_TBL2 X WITH (NOLOCK)
              WHERE 0 = 0
              --AND X.BOM_RN     = '1032'
              --AND X.STOCK_RN   = '3054'
              GROUP BY PLAN_ID	
                      ,PLAN_TYPE	
                      ,DIVISION_ID	
                      ,PLANT_ID
                      ,ITEM_ID	
                      ,STOCK_TYPE	
                      ,STORAGE_DESCRIPTION	
                      ,SCM_SITE_ID	
                      ,STORAGE_ID	
                      ,OPERATION_ID	
                      ,MES_MAP_SLOC	
            --          ,SCM_QTY	
                      ,ELEC_ITEM_ID	
            --          ,Convert_Qty	
                      ,FROM_SITE_ID
                      ,TO_SITE_ID	
                      ,X.RN
                      ,X.BOM_RN
                      ,X.STOCK_RN
					  ,X.AVAILABLE_DATE		-- KSW 2021.07.13 C20210702-000348 - 전극 시뮬레이터 내 BOH 보류재고 반영 로직 수정 요청의 건 - available_date(가용예상일자) 컬럼추가

            -------------------------------------------------------------------------------------------------------------------------         
            -- LOOP 작업 LEVEL 3
            -------------------------------------------------------------------------------------------------------------------------
             IF OBJECT_ID('tempdb..#TREE_MODEL3') IS NOT NULL	
              DROP TABLE #TREE_MODEL3

              ;
              WITH TREE_MODEL
              AS
              (
                SELECT  A.SITE_ID
                      , A.PLANT_ID
                      , CONVERT(NUMERIC,B.SCM_QTY) AS SCM_QTY
                      , A.PARENT_ITEM_ID
                      , A.PARENT_QTY
                      , A.CHILD_ITEM_ID
                      , A.CHILD_QTY
                      , 1 AS NLEVEL
                      , CONVERT(NVARCHAR(200), A.PARENT_ITEM_ID + '^' + A.CHILD_ITEM_ID)  AS TREE_PATH
                      , CONVERT(INT,ROW_NUMBER() OVER( ORDER BY (SELECT NULL))) AS Rn
                      , A.BOM_RN
                      , B.STOCK_RN
                      , B.SCM_SITE_ID
					  , B.AVAILABLE_DATE		-- KSW 2021.07.13 C20210702-000348 - 전극 시뮬레이터 내 BOH 보류재고 반영 로직 수정 요청의 건 - available_date(가용예상일자) 컬럼추가
                 FROM #tmp_SCP_ENG_BOMCOMPONENTS_I_SN A WITH (NOLOCK)
                INNER JOIN  #tmp_SCM_DNM_STOCK_V B WITH (NOLOCK)
                   ON A.MODEL_ID = B.ITEM_ID
                WHERE 0 = 0
                  AND A.PARENT_ITEM_ID IN (SELECT ITEM_ID FROM #ITEM_ID_LVL1  WITH (NOLOCK) WHERE LVL = 1)
                  AND A.PLANT_ID = B.PLANT_ID
                  AND B.SCM_QTY > 0.0
              --   AND A.MODEL_ID = 'AFCFC0845A'    
                 --AND A.PLANT_ID ='G382'
              UNION ALL
               SELECT   A.SITE_ID
                      , A.PLANT_ID
                      , CONVERT(NUMERIC,(B.SCM_QTY * (B.CHILD_QTY/(CASE WHEN A.PARENT_QTY  = 0 THEN 1 ELSE A.PARENT_QTY END) ) ))
                      , A.PARENT_ITEM_ID
                      , A.PARENT_QTY
                      , A.CHILD_ITEM_ID
                      , A.CHILD_QTY
                      , NLEVEL+1 AS NLEVEL
                      , CONVERT(NVARCHAR(200), B.TREE_PATH  + '^' + A.CHILD_ITEM_ID) AS TREE_PATH
                      , Rn
                      , B.BOM_RN
                      , B.STOCK_RN
                      , B.SCM_SITE_ID
					  , B.AVAILABLE_DATE		-- KSW 2021.07.13 C20210702-000348 - 전극 시뮬레이터 내 BOH 보류재고 반영 로직 수정 요청의 건 - available_date(가용예상일자) 컬럼추가
               FROM #tmp_SCP_ENG_BOMCOMPONENTS_I_SN A  WITH (NOLOCK)
               INNER JOIN TREE_MODEL  B  --WITH (NOLOCK)
               ON A.PARENT_ITEM_ID = B.CHILD_ITEM_ID
              WHERE  0 = 0
              --   AND A.MODEL_ID      = 'AFCFC0845A' 
              )

              --DROP TABLE #TREE_MODEL3
              SELECT DISTINCT *
                   , X.CHILD_QTY/(CASE WHEN X.PARENT_QTY  = 0 THEN 1 ELSE X.PARENT_QTY END) AS RATIO
                   , CONVERT(NVARCHAR(150)  ,NULL)  AS ELEC_ITEM_ID
                   , CONVERT(NUMERIC (20,10),NULL)  AS CONVERT_QTY_CELL
                   , CONVERT(NVARCHAR(150)  ,NULL)  AS FROM_SITE_ID
                   , CONVERT(NVARCHAR(150)  ,NULL)  AS CELL_ITEM_ID
              INTO #TREE_MODEL3
              FROM  TREE_MODEL X  WITH (NOLOCK)
              WHERE 0 = 0
              --AND  TREE_PATH LIKE 'AFCFC0845A%'
              AND LEFT(X.SCM_SITE_ID,4) = X.PLANT_ID
              ORDER BY TREE_PATH,NLEVEL  --

              Option (MaxRecursion 4)

              
            -------------------------------------------------------------------------------------------------------------------------         
            -- 그룹핑 기준 데이터 생성 외 ELEC_ITEM_ID,CONVERT_QTY_CELL,FROM_SITE_ID
            -------------------------------------------------------------------------------------------------------------------------

              UPDATE X
                 SET X.CONVERT_QTY_CELL = ISNULL(Y.CONVERT_QTY_CELL,1) 
                    ,X.CELL_ITEM_ID     = Y.CELL_ITEM_ID
                FROM #TREE_MODEL2 X WITH (NOLOCK)
                INNER JOIN SCP_MST_FINAL_ITEM Y WITH (NOLOCK) 
                   ON 0 = 0
                  AND Y.ITEM_ID = X.CHILD_ITEM_ID
                  --AND X.DIVISION_ID = Y.DIVISION_ID
                  AND X.NLEVEL  = 1
                  AND Y.OPERATION_GROUP ='E'

              /*
              UPDATE X
                 SET X.ELEC_ITEM_ID     = Y.CHILD_ITEM_ID 
                FROM #TREE_MODEL2 X WITH (NOLOCK)
               INNER JOIN #TREE_MODEL2 Y WITH (NOLOCK)
                  ON 0 = 0
                 AND X.SITE_ID       = Y.SITE_ID
                --AND X.ITEM_ID     = Y.ITEM_ID
                --AND X.STOCK_TYPE  = Y.STOCK_TYPE
                 AND X.RN            = Y.RN
                 AND Y.NLEVEL        = 2
                 AND X.BOM_RN        = Y.BOM_RN
                 AND X.STOCK_RN      = Y.STOCK_RN
                 AND X.PLANT_ID      = Y.PLANT_ID
                 AND X.NLEVEL        = 1
                 AND X.CHILD_ITEM_ID = Y.PARENT_ITEM_ID
              */
              /*
              UPDATE X
                 SET X.ELEC_ITEM_ID = (SELECT TOP 1 Z.CHILD_ITEM_ID 
                                      FROM #TREE_MODEL2  Z WITH (NOLOCK)
                                     WHERE 0 = 0
                                       AND X.SITE_ID       = Z.SITE_ID
                                       AND X.RN            = Z.RN
                                       AND 2               = Z.NLEVEL
                                       AND X.BOM_RN        = Z.BOM_RN
                                       AND X.STOCK_RN      = Z.STOCK_RN
                                       AND X.PLANT_ID      = Z.PLANT_ID
                                       --AND X.CHILD_ITEM_ID = Z.PARENT_ITEM_ID
                                 )
                FROM #TREE_MODEL2 X WITH (NOLOCK)
                WHERE X.NLEVEL = 1
                */

            -------------------------------------------------------------------------------------------------------------------------         
            -- 그룹핑 L1,L2,L3,L1_QTY,L2_QTY,L3_QTY
            -------------------------------------------------------------------------------------------------------------------------
              IF OBJECT_ID('tempdb..#GROUP_TBL3') IS NOT NULL	
                DROP TABLE #GROUP_TBL3

                SELECT MAX(Y.PLAN_ID)       AS PLAN_ID
                      ,MAX(Y.PLAN_TYPE)     AS PLAN_TYPE
                      ,MAX(Y.DIVISION_ID)   AS DIVISION_ID
                      ,MAX(X.PLANT_ID)      AS PLANT_ID
                --      ,X.PLANT_ID
                      ,Y.MODEL_ID           AS ITEM_ID
                      ,MAX(Z.STOCK_TYPE)    AS STOCK_TYPE
                      ,NULL                 AS STORAGE_DESCRIPTION
                      ,MAX(Z.SCM_SITE_ID)   AS SCM_SITE_ID
                      ,MAX(Z.STORAGE_ID)    AS STORAGE_ID
                      ,MAX(Z.OPERATION_ID)  AS OPERATION_ID
                      ,MAX(Z.MES_MAP_SLOC)  AS MES_MAP_SLOC
                --      ,MAX(X.SCM_QTY)       AS SCM_QTY
                      ,MAX(CASE WHEN NLEVEL = 1 THEN X.SCM_QTY            ELSE NULL         END) AS SCM_QTY
                      ,MAX(CASE WHEN NLEVEL = 1 THEN X.CHILD_ITEM_ID      ELSE NULL         END) AS L1
                      ,SUM(CASE WHEN NLEVEL = 1 THEN X.SCM_QTY * X.RATIO  ELSE NULL         END) AS L1_QTY
                      ,MAX(CASE WHEN NLEVEL = 2 THEN X.CHILD_ITEM_ID      ELSE NULL         END) AS L2
                      ,SUM(CASE WHEN NLEVEL = 2 THEN X.SCM_QTY * X.RATIO  ELSE NULL         END) AS L2_QTY
                      ,MAX(CASE WHEN NLEVEL = 3 THEN X.CHILD_ITEM_ID      ELSE NULL         END) AS L3
                      ,SUM(CASE WHEN NLEVEL = 3 THEN X.SCM_QTY * X.RATIO  ELSE NULL         END) AS L3_QTY
                      ,MAX(CASE WHEN NLEVEL = 1 THEN X.CHILD_ITEM_ID      ELSE X.ELEC_ITEM_ID  END) AS ELEC_ITEM_ID
                      ,NULL AS CONVERT_QTY
                      ,FROM_SITE_ID
                      ,Z.SCM_SITE_ID AS TO_SITE_ID
                      ,X.RN
                      ,X.BOM_RN
                      ,X.STOCK_RN
                      ,X.NLEVEL
                      ,X.PARENT_ITEM_ID
                      ,X.CHILD_ITEM_ID
                      ,X.CONVERT_QTY_CELL
                      ,X.CELL_ITEM_ID
					  ,X.AVAILABLE_DATE		-- KSW 2021.07.13 C20210702-000348 - 전극 시뮬레이터 내 BOH 보류재고 반영 로직 수정 요청의 건 - available_date(가용예상일자) 컬럼추가
                INTO #GROUP_TBL3
                FROM #TREE_MODEL3 X WITH (NOLOCK)
               INNER JOIN #tmp_SCP_ENG_BOMCOMPONENTS_I_SN Y WITH (NOLOCK)
                  ON X.BOM_RN = Y.BOM_RN
               INNER JOIN #tmp_SCM_DNM_STOCK_V Z WITH (NOLOCK)
                  ON X.STOCK_RN = Z.STOCK_RN
               WHERE 0 = 0
                --AND X.BOM_RN     = '1032'
                --AND X.STOCK_RN   = '3054'
                --AND X.PLANT_ID   = 'G382'
               GROUP BY Y.MODEL_ID
                       ,X.CHILD_ITEM_ID
                --     ,NULL AS Convert_Qty
                       ,FROM_SITE_ID
                       ,Z.SCM_SITE_ID 
                       ,X.RN
                       ,X.BOM_RN
                       ,X.STOCK_RN
                       ,X.NLEVEL
                       ,X.PARENT_ITEM_ID
                       ,X.CONVERT_QTY_CELL
                --     ,X.RATIO
--                       ,X.PLANT_ID
                       ,X.CELL_ITEM_ID
					   ,X.AVAILABLE_DATE		-- KSW 2021.07.13 C20210702-000348 - 전극 시뮬레이터 내 BOH 보류재고 반영 로직 수정 요청의 건 - available_date(가용예상일자) 컬럼추가

            -------------------------------------------------------------------------------------------------------------------------         
            -- 그룹핑2 MERSEGE 처리
            -------------------------------------------------------------------------------------------------------------------------
              IF OBJECT_ID('tempdb..#BOM3') IS NOT NULL	
                DROP TABLE #BOM3

                SELECT PLAN_ID	
                      ,PLAN_TYPE	
                      ,DIVISION_ID	
                      ,PLANT_ID	
                      ,ITEM_ID	
                      ,STOCK_TYPE	
                      ,CONVERT(NVARCHAR(150), STORAGE_DESCRIPTION	) AS STORAGE_DESCRIPTION
                      ,SCM_SITE_ID	
                      ,STORAGE_ID	
                      ,OPERATION_ID	
                      ,CONVERT(NVARCHAR(150), MES_MAP_SLOC) AS MES_MAP_SLOC	
                      ,SUM(ISNULL(SCM_QTY,0))   AS SCM_QTY	
                      ,MAX(CONVERT(NVARCHAR(150), L1)) AS L1
                      ,SUM(ISNULL(L1_QTY,0))    AS L1_QTY
                      ,MAX(CONVERT(NVARCHAR(150), L2)) AS L2
                      ,SUM(ISNULL(L2_QTY,0))    AS L2_QTY
                      ,MAX(CONVERT(NVARCHAR(150), L3)) AS L3
                      ,SUM(ISNULL(L3_QTY,0))    AS L3_QTY
                      ,ELEC_ITEM_ID	
                      ,SUM(ISNULL(L1_QTY,0)) * MAX(X.CONVERT_QTY_CELL) AS CONVERT_QTY	
                      ,MAX(X.CONVERT_QTY_CELL)  AS CONVERT_QTY_CELL
                      ,MAX(X.CELL_ITEM_ID)      AS CELL_ITEM_ID
                      ,FROM_SITE_ID
                      ,TO_SITE_ID	
                      ,X.RN
                      ,X.BOM_RN
                      ,X.STOCK_RN
                      ,'3' AS LVL
					  ,X.AVAILABLE_DATE		-- KSW 2021.07.13 C20210702-000348 - 전극 시뮬레이터 내 BOH 보류재고 반영 로직 수정 요청의 건 - available_date(가용예상일자) 컬럼추가
               INTO #BOM3
               FROM #GROUP_TBL3 X WITH (NOLOCK)
              WHERE 0 = 0
              --AND X.BOM_RN     = '1032'
              --AND X.STOCK_RN   = '3054'
              GROUP BY PLAN_ID	
                      ,PLAN_TYPE	
                      ,DIVISION_ID	
                      ,PLANT_ID
                      ,ITEM_ID	
                      ,STOCK_TYPE	
                      ,STORAGE_DESCRIPTION	
                      ,SCM_SITE_ID	
                      ,STORAGE_ID	
                      ,OPERATION_ID	
                      ,MES_MAP_SLOC	
            --          ,SCM_QTY	
                      ,ELEC_ITEM_ID	
            --          ,Convert_Qty	
                      ,FROM_SITE_ID
                      ,TO_SITE_ID	
                      ,X.RN
                      ,X.BOM_RN
                      ,X.STOCK_RN
					  ,X.AVAILABLE_DATE		-- KSW 2021.07.13 C20210702-000348 - 전극 시뮬레이터 내 BOH 보류재고 반영 로직 수정 요청의 건 - available_date(가용예상일자) 컬럼추가


            -------------------------------------------------------------------------------------------------------------------------         
            -- 그룹핑 MERSEGE 처리
            -------------------------------------------------------------------------------------------------------------------------
              IF OBJECT_ID('tempdb..#BOM4') IS NOT NULL	
                DROP TABLE #BOM4


                SELECT 
                      @p_plan_id AS PLAN_ID
                      ,@p_plan_type AS PLAN_TYPE
                      ,X.DIVISION_ID
                      ,X.PLANT_ID
                      ,X.ITEM_ID
                      ,X.STOCK_TYPE
                      ,CONVERT(NVARCHAR(150),Y.STORAGE_DESCRIPTION) AS STORAGE_DESCRIPTION
                      ,X.SCM_SITE_ID
                      ,X.STORAGE_ID
                      ,X.OPERATION_ID
                      ,CONVERT(NVARCHAR(150), MES_MAP_SLOC) AS MES_MAP_SLOC
                      ,X.SCM_QTY
                      ,CONVERT(NVARCHAR(150), NULL) AS L1
                      ,NULL AS L1_QTY
                      ,CONVERT(NVARCHAR(150), NULL) AS L2
                      ,NULL AS L2_QTY
                      ,CONVERT(NVARCHAR(150), NULL) AS L3
                      ,NULL AS L3_QTY
                      ,X.ITEM_ID AS ELEC_ITEM_ID
                      ,(X.SCM_QTY * ISNULL(Z.CONVERT_QTY_CELL,1)) AS CONVERT_QTY
                      ,ISNULL(Z.CONVERT_QTY_CELL,1)  AS CONVERT_QTY_CELL
                      ,Z.CELL_ITEM_ID AS CELL_ITEM_ID
                      ,X.SCM_SITE_ID AS FROM_SITE_ID
                      ,X.SCM_SITE_ID AS TO_SITE_ID
                      ,9999 AS RN
                      ,9999 AS BOM_RN
                      ,9999 AS STOCK_RN
                      ,'4' AS LVL
					  ,X.AVAILABLE_DATE		-- KSW 2021.07.13 C20210702-000348 - 전극 시뮬레이터 내 BOH 보류재고 반영 로직 수정 요청의 건 - available_date(가용예상일자) 컬럼추가
                INTO #BOM4
--                FROM SCM_DNM_STOCK_V  X WITH (NOLOCK) 
                FROM #tmp_SCM_DNM_STOCK_V  X WITH (NOLOCK) 
                LEFT OUTER JOIN SCM_MST_SLOC Y WITH (NOLOCK) 
                  ON  X.DIVISION_ID  = Y.DIVISION_ID
                  AND X.STORAGE_ID   = Y.STORAGE_ID
                  AND X.PLANT_ID     = Y.PLANT_ID
                INNER JOIN SCP_MST_FINAL_ITEM Z WITH (NOLOCK) 
                  ON 0 = 0
                  AND Z.ITEM_ID = X.ITEM_ID
                  AND Z.OPERATION_GROUP ='E'
                  AND X.DIVISION_ID = Z.DIVISION_ID
                WHERE 1 = 1 
            --     AND DIVISION_ID = '81'
                  AND X.SCM_SITE_ID IS NOT NULL
                 -- AND X.CUTOFF_DATE  = @p_cutoff_date
                  AND LEFT(X.ITEM_ID,5) IN ('APCAN','APCCA','APCCS')
--                       AND X.ITEM_ID ='APCAN0001A'   -- 

                --SELECT * INTO ##BOM3 FROM #BOM3
                --SELECT * INTO ##BOM4 FROM #BOM4


            -------------------------------------------------------------------------------------------------------------------------         
            -- 전극에 반영될 최종 PLAN 대상 임시테이블 생성
            -------------------------------------------------------------------------------------------------------------------------

              IF OBJECT_ID('tempdb..#TBL') IS NOT NULL	
                DROP TABLE #TBL

                SELECT * 
                INTO #TBL
                FROM 
                (
                  SELECT * 
                    FROM #BOM1 WITH (NOLOCK)
                    WHERE 0 = 0
--                         AND ITEM_ID = 'AFCFC0845A'
--                       ORDER BY LVL,RN,STOCK_RN, BOM_Rn,L1 DESC
                  UNION ALL
                  SELECT * 
                    FROM #BOM2 WITH (NOLOCK)
                    WHERE 0 = 0
--                         AND ITEM_ID = 'ABCAT0869A'
--                       ORDER BY LVL,RN,STOCK_RN, BOM_Rn,L1 DESC
                  UNION ALL
                  SELECT * 
                    FROM #BOM3 WITH (NOLOCK)
                    WHERE 0 = 0
--                         AND ITEM_ID = 'ANPAN0922A'
                  UNION ALL
                  SELECT * 
                    FROM #BOM4 WITH (NOLOCK)
                    WHERE 0 = 0
----                         AND ITEM_ID = 'APCAN0001A'
                ) X
                  ORDER BY LVL,RN,STOCK_RN, BOM_Rn,L1 DESC                      

            

            -------------------------------------------------------------------------------------------------------------------------         
            -- SCP_MST_MODEL_ALLOCATION에 NIC_NAME NVARCHAR(150) 컬럼 추가한 tmp 테이블 생성
            -------------------------------------------------------------------------------------------------------------------------
            IF OBJECT_ID('tempdb..#tmp_SCP_MST_MODEL_ALLOCATION') IS NOT NULL	
	              DROP TABLE #tmp_SCP_MST_MODEL_ALLOCATION
               
               SELECT DIVISION_ID,CELL_ITEM_ID,CELL_PLANT_SITE_ID,CELL_LINE_ID,ELEC_PLANT_SITE_ID,YYYYMMDD,VALID_YN, CONVERT(NVARCHAR(150) , NULL) AS NICK_NAME 
                INTO #tmp_SCP_MST_MODEL_ALLOCATION
                 FROM SCP_MST_MODEL_ALLOCATION  WITH (NOLOCK)
                WHERE VALID_YN ='Y'

              -- NICK_NAME UPDATE 
               UPDATE X
                SET X.NICK_NAME = Y.NICK_NAME
                FROM #tmp_SCP_MST_MODEL_ALLOCATION X  WITH (NOLOCK)
               INNER JOIN SCP_MST_FINAL_ITEM Y  WITH (NOLOCK)
                  ON X.DIVISION_ID = Y.DIVISION_ID
                 AND X.CELL_ITEM_ID= Y.ITEM_ID              



            -------------------------------------------------------------------------------------------------------------------------         
            -- 전극에 반영될 최종 PLAN 대상 임시테이블 생성
            -------------------------------------------------------------------------------------------------------------------------
             
               UPDATE X
                  SET X.FROM_SITE_ID = Y.ELEC_PLANT_SITE_ID
                  FROM #TBL X WITH (NOLOCK)
                  LEFT OUTER JOIN SCP_MST_MODEL_ALLOCATION Y WITH (NOLOCK)
                    ON 0 = 0
                   AND X.DIVISION_ID = Y.DIVISION_ID
                   AND X.SCM_SITE_ID = Y.CELL_PLANT_SITE_ID
                   AND X.CELL_ITEM_ID= Y.CELL_ITEM_ID
                   --AND X.LINE_ID     = Y.CELL_LINE_ID
                   --AND X.YYYYMMDD    = Y.YYYYMMDD
				   and Y.YYYYMMDD    = @p_plan_start_yyyymmdd -- SCP_MST_MODEL_ALLOCATION 에서 FROM_SITE_ID 를 찾을 경우 YYYYMMDD 조건절 추가 (일부누락로직 보완) KSW 2021.07.28 추가
                   AND Y.VALID_YN    ='Y'
                 LEFT OUTER JOIN SCM_MST_MODEL_FINAL_ITEM_BOM_V V WITH (NOLOCK)
                   ON 0 = 0
                  AND V.MODEL_ID            =  X.ITEM_ID 
                  AND V.PLANT_ID            = LEFT(X.SCM_SITE_ID,4)
                  AND V.OPERATION_GROUP_ID  = 'E'


              -- SCP_MST_MODEL_ALLOCATION VALID_YN이 Y인 data가 2건 이상일때
              IF OBJECT_ID('tempdb..#SCP_MST_MODEL_ALLOCATION_MULTI') IS NOT NULL      
	              DROP TABLE #SCP_MST_MODEL_ALLOCATION_MULTI;

                 SELECT *
                  INTO #SCP_MST_MODEL_ALLOCATION_MULTI
                  FROM (
                      SELECT DIVISION_ID,CELL_ITEM_ID,CELL_PLANT_SITE_ID,CELL_LINE_ID,ELEC_PLANT_SITE_ID,YYYYMMDD
                      ,ROW_NUMBER() OVER(PARTITION BY DIVISION_ID,CELL_ITEM_ID,CELL_PLANT_SITE_ID,CELL_LINE_ID,YYYYMMDD ORDER BY ELEC_PLANT_SITE_ID) AS Rn
                      FROM SCP_MST_MODEL_ALLOCATION A WITH (NOLOCK)
                  WHERE 0 = 0
                     AND VALID_YN ='Y'
                  ) XX
                  WHERE 0 = 0
                  AND XX.rn > 1


               UPDATE X
                  SET X.FROM_SITE_ID = P.PLANT_SITE_ID
                FROM #TBL X WITH (NOLOCK)
                INNER JOIN #SCP_MST_MODEL_ALLOCATION_MULTI M WITH (NOLOCK)
                   ON 0 = 0
                  AND X.DIVISION_ID  = M.DIVISION_ID
                  AND X.CELL_ITEM_ID = M.CELL_ITEM_ID
                  AND X.TO_SITE_ID   = M.CELL_PLANT_SITE_ID
                  --AND X.PROD_LINE    = M.CELL_LINE_ID
                  --AND X.YYYYMMDD     = M.YYYYMMDD  
				  and M.YYYYMMDD = @p_plan_start_yyyymmdd -- SCP_MST_MODEL_ALLOCATION 에서 FROM_SITE_ID 를 찾을 경우 YYYYMMDD 조건절 추가 (일부누락로직 보완) KSW 2021.07.28 추가
                INNER JOIN SCM_MST_SITE_ITEM_PRIORITY P WITH (NOLOCK)
                  ON 0 = 0
                  AND P.DIVISION_ID  = X.DIVISION_ID
                  AND P.ITEM_ID      = X.ITEM_ID            
                  --AND X.YYYYMMDD     >= P.FROM_YYYYMMDD 
                  --AND X.YYYYMMDD     <= P.TO_YYYYMMDD
                  AND P.PRIORITY      = '1'


                UPDATE X
                SET X.FROM_SITE_ID = TO_SITE_ID
                FROM #TBL X  WITH (NOLOCK)
                WHERE LVL = '4'
                  AND X.TO_SITE_ID NOT LIKE '%-A'

                UPDATE X
                   SET X.CELL_ITEM_ID     = Z.CELL_ITEM_ID
                      ,X.CONVERT_QTY      = (X.L1_QTY * ISNULL(Z.CONVERT_QTY_CELL,1)) 
                      ,X.CONVERT_QTY_CELL = ISNULL(Z.CONVERT_QTY_CELL,1) 
                 FROM #TBL X  WITH (NOLOCK)
                 INNER JOIN SCP_MST_FINAL_ITEM Z WITH (NOLOCK) 
                  ON 0 = 0
                  AND Z.ITEM_ID         = X.ELEC_ITEM_ID
                  --AND X.DIVISION_ID = Z.DIVISION_ID
                  AND Z.OPERATION_GROUP = 'E'
                  AND LVL               = 3



                 -- Y가 1건인 DATA중 ALLOCATION 값이 2건 이상으로 반영된 DATA 삭제
                 /*
                 DELETE FROM  X
                 FROM #PSI_GLOBAL X WITH (NOLOCK)
                    INNER JOIN #SCP_MST_MODEL_ALLOCATION_MULTI M WITH (NOLOCK)
                      ON X.DIVISION_ID  = M.DIVISION_ID
                     AND X.CELL_ITEM_ID = M.CELL_ITEM_ID
                     AND X.TO_SITE_ID   = M.CELL_PLANT_SITE_ID
                     AND X.PROD_LINE    = M.CELL_LINE_ID
                     AND X.YYYYMMDD     = M.YYYYMMDD 
                 WHERE X.ATTRIBUTE7 = '1'   -- Y가 1인건

            */



            -------------------------------------------------------------------------------------------------------------         
            --  삭제 후 입력
            -------------------------------------------------------------------------------------------------------------
              -- 2022.06.23 UC, LG 사업부별 삭제조건 추가
              DELETE FROM SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM
			   WHERE ELEC_DIVISION_ID = @p_division_id  -- [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 - PK 컬럼 추가 반영 (ELEC_DIVISION_ID : EE/EE_UC)

			  -- 2020.07.29   KSW         일부 재고중복오류 수정 -- start
			  -- --> #TBL 에서 SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM 을 생성할 때 Group By 추가 (중복제거)
			  -- 변경전 -- 2020.08.10 변경전 소스로 원복

              INSERT INTO SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM
                SELECT  PLAN_ID
                        ,PLAN_TYPE
                        ,DIVISION_ID
                        ,PLANT_ID
                        ,ITEM_ID
                        ,STOCK_TYPE
                        ,STORAGE_DESCRIPTION
                        ,SCM_SITE_ID
                        ,STORAGE_ID
                        ,OPERATION_ID
                        ,MES_MAP_SLOC
                        ,SCM_QTY
                        ,L1
                        ,L1_QTY
                        ,L2
                        ,L2_QTY
                        ,L3
                        ,L3_QTY
                        ,ELEC_ITEM_ID
                        ,CONVERT_QTY
                        ,CONVERT_QTY_CELL
                        ,CELL_ITEM_ID
                        ,FROM_SITE_ID
                        ,TO_SITE_ID
                        ,CONVERT(INT,ROW_NUMBER() OVER(ORDER BY (SELECT NULL))) AS XLS_KEY
                        ,@v_batch_user  AS CREATED_BY
                        ,GETDATE()      AS CREATION_DATE
                        ,@v_batch_user  AS LAST_UPDATED_BY
                        ,GETDATE()      AS LAST_UPDATE_DATE
                        ,NULL AS ATTRIBUTE1
                        ,NULL AS ATTRIBUTE2
                        ,NULL AS ATTRIBUTE3
                        ,NULL AS ATTRIBUTE4
                        ,NULL AS ATTRIBUTE5
                        ,NULL AS ATTRIBUTE6
                        ,NULL AS ATTRIBUTE7
                        ,NULL AS ATTRIBUTE8
                        ,NULL AS ATTRIBUTE9
                        ,NULL AS ATTRIBUTE10
                        ,RN
                        ,BOM_RN
                        ,STOCK_RN
                        ,LVL 
						,AVAILABLE_DATE		-- KSW 2021.07.13 C20210702-000348 - 전극 시뮬레이터 내 BOH 보류재고 반영 로직 수정 요청의 건 - available_date(가용예상일자) 컬럼추가
						,@p_division_id		-- [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 - PK 컬럼 추가 반영 (ELEC_DIVISION_ID : EE/EE_UC)
                --INTO ##SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM
                FROM #TBL WITH (NOLOCK)
                ORDER BY LVL,RN,STOCK_RN, BOM_Rn,L1 DESC 


			---- 변경후
   --           INSERT INTO SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM
			--    SELECT PLAN_ID
			--			,PLAN_TYPE
			--			,DIVISION_ID
			--			,PLANT_ID
			--			,ITEM_ID
			--			,STOCK_TYPE
			--			,STORAGE_DESCRIPTION
			--			,SCM_SITE_ID
			--			,STORAGE_ID
			--			,OPERATION_ID
			--			,MES_MAP_SLOC
			--			,SCM_QTY
			--			,L1
			--			,L1_QTY
			--			,L2
			--			,L2_QTY
			--			,L3
			--			,L3_QTY
			--			,ELEC_ITEM_ID
			--			,CONVERT_QTY
			--			,CONVERT_QTY_CELL
			--			,CELL_ITEM_ID
			--			,FROM_SITE_ID
			--			,TO_SITE_ID
			--			,CONVERT(INT,ROW_NUMBER() OVER(ORDER BY (SELECT NULL))) AS XLS_KEY
			--			,@v_batch_user  AS CREATED_BY
			--			,GETDATE()      AS CREATION_DATE
			--			,@v_batch_user  AS LAST_UPDATED_BY
			--			,GETDATE()      AS LAST_UPDATE_DATE
			--			,NULL AS ATTRIBUTE1
			--			,NULL AS ATTRIBUTE2
			--			,NULL AS ATTRIBUTE3
			--			,NULL AS ATTRIBUTE4
			--			,NULL AS ATTRIBUTE5
			--			,NULL AS ATTRIBUTE6
			--			,NULL AS ATTRIBUTE7
			--			,NULL AS ATTRIBUTE8
			--			,NULL AS ATTRIBUTE9
			--			,NULL AS ATTRIBUTE10
			--			,RN
			--			,BOM_RN
			--			,STOCK_RN
			--			,LVL 
			--	  FROM (SELECT  PLAN_ID
			--					,PLAN_TYPE
			--					,DIVISION_ID
			--					,PLANT_ID
			--					,ITEM_ID
			--					,STOCK_TYPE
			--					,STORAGE_DESCRIPTION
			--					,SCM_SITE_ID
			--					,STORAGE_ID
			--					,OPERATION_ID
			--					,MES_MAP_SLOC
			--					,SCM_QTY
			--					,MAX(L1)           AS L1   --L1
			--					,L1_QTY
			--					,L2
			--					,L2_QTY
			--					,L3
			--					,L3_QTY
			--					,ELEC_ITEM_ID
			--					,CONVERT_QTY
			--					,CONVERT_QTY_CELL
			--					,CELL_ITEM_ID
			--					,FROM_SITE_ID
			--					,TO_SITE_ID
			--					,MAX(RN)           AS RN
			--					,MAX(BOM_RN)       AS BOM_RN
			--					,STOCK_RN
			--					,LVL 
			--			FROM #TBL WITH (NOLOCK)
			--		GROUP BY PLAN_ID
			--				,PLAN_TYPE
			--				,DIVISION_ID
			--				,PLANT_ID
			--				,ITEM_ID
			--				,STOCK_TYPE
			--				,STORAGE_DESCRIPTION
			--				,SCM_SITE_ID
			--				,STORAGE_ID
			--				,OPERATION_ID
			--				,MES_MAP_SLOC
			--				,SCM_QTY
			--				--,L1
			--				,L1_QTY
			--				,L2
			--				,L2_QTY
			--				,L3
			--				,L3_QTY
			--				,ELEC_ITEM_ID
			--				,CONVERT_QTY
			--				,CONVERT_QTY_CELL
			--				,CELL_ITEM_ID
			--				,FROM_SITE_ID
			--				,TO_SITE_ID
			--				,STOCK_RN
			--				,LVL 
			--		) X
			--	ORDER BY X.LVL, X.RN, X.STOCK_RN, X.BOM_RN, X.L1 DESC
			--	;

			---- 2020.07.29   KSW         일부 재고중복오류 수정 -- end

			-- 2021.09.03   KSW CELL_ITEM_ID 오류 수정 - start
			-- 변경전
			--
			-- 2021.07.12   KSW         FROM_SITE 업데이트 쿼리추가 - start
			-- BOM 에서 CELL_ITEM_ID UPDATE
			--UPDATE X
			--   SET X.CELL_ITEM_ID = (SELECT TOP 1 MODEL_ID--, CONCATENATE_ITEM
			--							FROM SCM_MST_BOM_SN_V V WITH (NOLOCK)
			--							WHERE V.DIVISION_ID     = X.DIVISION_ID
			--							AND V.PLANT_ID        = LEFT(X.SCM_SITE_ID,4)
			--							AND V.CHILD_ITEM_ID   = X.ELEC_ITEM_ID
			--							AND V.CONCATENATE_ITEM LIKE '%' + X.ITEM_ID + '%'
			--	                    )
			-- FROM (SELECT * FROM SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM WITH (NOLOCK) WHERE FROM_SITE_ID IS NULL) X

			-- 변경후
			UPDATE X
			   SET X.CELL_ITEM_ID = (SELECT TOP 1 V.MODEL_ID
									  FROM SCM_MST_BOM_SN_V V WITH (NOLOCK)
											,[DBO].[SCM_MST_ITEM_SN] M WITH(NOLOCK)
									WHERE V.DIVISION_ID     = X.DIVISION_ID
									AND V.PLANT_ID        = LEFT(X.SCM_SITE_ID,4)
									AND V.CHILD_ITEM_ID   = X.ELEC_ITEM_ID
									AND V.CONCATENATE_ITEM LIKE '%' + X.ITEM_ID + '%'
									AND M.COMPANY_ID    = V.COMPANY_ID
									AND M.SITE_ID       = V.SITE_ID
									AND M.DIVISION_ID   = V.DIVISION_ID
									AND M.ITEM_ID       = V.PARENT_ITEM_ID
									AND M.APPLIED_MODEL = V.MODEL_ID
				                    )
			 FROM (SELECT * FROM SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM WITH (NOLOCK) WHERE ELEC_DIVISION_ID = @p_division_id AND FROM_SITE_ID IS NULL) X  -- PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 - PK 컬럼 추가 반영 (ELEC_DIVISION_ID : EE/EE_UC)

			UPDATE X
			   SET X.CELL_ITEM_ID = (SELECT TOP 1 APPLIED_MODEL 
			                           FROM [DBO].[SCM_MST_ITEM_SN] V WITH (NOLOCK)
									  WHERE 1 =1
									    AND V.ITEM_ID = X.ITEM_ID
				                    )
			 FROM (SELECT * FROM SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM WITH (NOLOCK) WHERE ELEC_DIVISION_ID = @p_division_id AND FROM_SITE_ID IS NULL AND CELL_ITEM_ID IS NULL) X -- PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 - PK 컬럼 추가 반영 (ELEC_DIVISION_ID : EE/EE_UC)
			 -- 2021.09.03   KSW CELL_ITEM_ID 오류 수정 - end

			-------------------------------------------------------------------------------------------------------------------------
            -- FROM_SITE_ID 업데이트 보완
            -------------------------------------------------------------------------------------------------------------------------
               UPDATE X
                  SET X.FROM_SITE_ID = Y.ELEC_PLANT_SITE_ID
                  FROM (SELECT * FROM SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM WITH (NOLOCK) WHERE ELEC_DIVISION_ID = @p_division_id AND FROM_SITE_ID IS NULL) X -- PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 - PK 컬럼 추가 반영 (ELEC_DIVISION_ID : EE/EE_UC)
                  LEFT OUTER JOIN SCP_MST_MODEL_ALLOCATION Y WITH (NOLOCK)
                    ON 0 = 0
                   AND X.DIVISION_ID = Y.DIVISION_ID
                   AND X.SCM_SITE_ID = Y.CELL_PLANT_SITE_ID
                   AND X.CELL_ITEM_ID= Y.CELL_ITEM_ID
                   --AND X.LINE_ID     = Y.CELL_LINE_ID
                   --AND X.YYYYMMDD    = Y.YYYYMMDD
				   and Y.YYYYMMDD    = @p_plan_start_yyyymmdd -- SCP_MST_MODEL_ALLOCATION 에서 FROM_SITE_ID 를 찾을 경우 YYYYMMDD 조건절 추가 (일부누락로직 보완) KSW 2021.07.28 추가
                   AND Y.VALID_YN    ='Y'
                 LEFT OUTER JOIN SCM_MST_MODEL_FINAL_ITEM_BOM_V V WITH (NOLOCK)
                   ON 0 = 0
                  AND V.MODEL_ID            =  X.CELL_ITEM_ID    -- ksw X.ITEM_ID 
                  AND V.PLANT_ID            = LEFT(X.SCM_SITE_ID,4)
                  AND V.OPERATION_GROUP_ID  = 'E'

			-- 2021.07.12   KSW         FROM_SITE 업데이트 쿼리추가 - end



             -- LOOKUP TEMP 생성 ELECTRODE_SLOC 
                IF OBJECT_ID('tempdb..#ELECTRODE_SLOC') IS NOT NULL      
	                  DROP TABLE #ELECTRODE_SLOC;

                SELECT A.SEGMENT1 AS PLANT_SITE_ID
                      ,A.SEGMENT2 AS STORAGE_ID
                      ,A.ATTRIBUTE1 AS FROM_CODE 
                INTO #ELECTRODE_SLOC
                FROM SCM_ADM_LOOKUP_MASTER_DETAIL A WITH (NOLOCK)
                WHERE  0 = 0
                AND A.LOOKUP_TYPE = 'ELECTRODE_SLOC'
                --AND A.ATTRIBUTE1  ='1'
                --AND A.SEGMENT1 ='G182-A'
                --AND A.SEGMENT2 ='350N'
                ORDER BY DISPLAY_SEQ 

            -------------------------------------------------------------------------------------------------------------         
            --  FROM SITE 보정
            -------------------------------------------------------------------------------------------------------------
           
                -- ELECTRODE_SLOC 구분코드 (FROM_CODE) 반영
                 UPDATE A
                    SET A.ATTRIBUTE3 = B.FROM_CODE
                    --SELECT * 
                    FROM SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM A WITH (NOLOCK)  
                    INNER JOIN #ELECTRODE_SLOC B  WITH (NOLOCK)
                       ON 0 = 0
                      AND A.TO_SITE_ID  = B.PLANT_SITE_ID
                      AND A.STORAGE_ID  = B.STORAGE_ID
				    WHERE A.ELEC_DIVISION_ID = @p_division_id -- PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 - PK 컬럼 추가 반영 (ELEC_DIVISION_ID : EE/EE_UC)

                -- MES는 ELECTRODE_SLOC 구분코드 (FROM_CODE) 1로 반영
                 UPDATE A
                    SET A.ATTRIBUTE3 = '1'
                    --SELECT * 
                    FROM SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM A WITH (NOLOCK)  
                    WHERE STORAGE_ID in ('MES_DEP', 'MES')			--> in ('MES_DEP', 'MES') 으로 변경
				      AND A.ELEC_DIVISION_ID = @p_division_id -- PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 - PK 컬럼 추가 반영 (ELEC_DIVISION_ID : EE/EE_UC)

                 -- NICK_NAME UPDATE 
                 UPDATE X
                   SET X.ATTRIBUTE4  = Y.NICK_NAME
                  FROM SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM X  WITH (NOLOCK)
                 INNER JOIN SCP_MST_FINAL_ITEM Y  WITH (NOLOCK)
                    ON X.DIVISION_ID = Y.DIVISION_ID
                   AND X.ITEM_ID     = Y.ITEM_ID             
				 WHERE X.ELEC_DIVISION_ID = @p_division_id -- PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 - PK 컬럼 추가 반영 (ELEC_DIVISION_ID : EE/EE_UC)
                   
                   /*
                UPDATE X
                   SET X.ATTRIBUTE4  = Y.NICK_NAME
                  FROM SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM X  WITH (NOLOCK)
                 INNER JOIN SCP_MST_FINAL_ITEM Y  WITH (NOLOCK)
                    ON X.DIVISION_ID = Y.DIVISION_ID
                   AND X.ELEC_ITEM_ID= Y.ITEM_ID  
                   */


                    --SELECT * INTO SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM_20200420_FN  FROM SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM WITH (NOLOCK)
                    --RETURN;
            -------------------------------------------------------------------------------------------------------------         
            --  FROM CODE 1 : 조립생산팀 창고에 위치한 경우
            -------------------------------------------------------------------------------------------------------------         
            --  SCP_MST_MODEL_ALLOCATION.VALID_YN ='Y'가 2개 이상일 경우 
            --                CELL_ITEM_ID로 BOM 테이블을 조회 하여 ELEC_ITEM_ID 값으로 
            --                  SCM_MST_SITE_ITEM_PRIORITY.ITEM_ID를 조회하여 
            --                  SCM_MST_SITE_ITEM_PRIORITY.PLANT_SITE_ID를 반영한다.
            -------------------------------------------------------------------------------------------------------------
            -- 1. Attribute3에 "1" Model Allocation을 보는 대상은 Nick Name이다. 


            -- SCP_MST_MODEL_ALLOCATION VALID_YN이 Y인 data가 2건 이상일때
              IF OBJECT_ID('tempdb..#SCP_MST_MODEL_ALLOCATION_MULTI_CODE') IS NOT NULL      
	              DROP TABLE #SCP_MST_MODEL_ALLOCATION_MULTI_CODE;

                  SELECT *, CONVERT(NVARCHAR(150) , NULL) AS NICK_NAME 
                  INTO #SCP_MST_MODEL_ALLOCATION_MULTI_CODE
                  FROM (
                      SELECT DIVISION_ID,CELL_ITEM_ID,CELL_PLANT_SITE_ID,ELEC_PLANT_SITE_ID,VALID_YN
                        ,ROW_NUMBER() OVER(PARTITION BY DIVISION_ID,CELL_ITEM_ID,CELL_PLANT_SITE_ID,VALID_YN ORDER BY CELL_PLANT_SITE_ID) AS RN
                        FROM (
                              SELECT DISTINCT DIVISION_ID,CELL_ITEM_ID,CELL_PLANT_SITE_ID,ELEC_PLANT_SITE_ID,VALID_YN
                                FROM SCP_MST_MODEL_ALLOCATION A WITH (NOLOCK)
                               WHERE 0 = 0
                                AND VALID_YN ='Y'
                                AND YYYYMMDD = @p_plan_start_yyyymmdd
                              ) X
                    ) XX
                  WHERE 0 = 0
                  AND XX.RN > 1


               -- NICK_NAME UPDATE 
               UPDATE X
                SET X.NICK_NAME = Y.NICK_NAME
                FROM #SCP_MST_MODEL_ALLOCATION_MULTI_CODE X  WITH (NOLOCK)
               INNER JOIN SCP_MST_FINAL_ITEM Y  WITH (NOLOCK)
                  ON X.DIVISION_ID = Y.DIVISION_ID
                 AND X.CELL_ITEM_ID= Y.ITEM_ID   

                UPDATE A
                SET A.FROM_SITE_ID = D.PLANT_SITE_ID
                    , A.ATTRIBUTE1 = B.FROM_CODE  -- 구분을 위해서 
                    , A.ATTRIBUTE2 = N'2건 이상일 경우'
                FROM SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM A WITH (NOLOCK)  
                INNER JOIN #ELECTRODE_SLOC B  WITH (NOLOCK)
                   ON A.TO_SITE_ID  = B.PLANT_SITE_ID
                  AND A.STORAGE_ID  = B.STORAGE_ID
                  AND B.FROM_CODE   = '1' 
                INNER JOIN #SCP_MST_MODEL_ALLOCATION_MULTI_CODE C WITH (NOLOCK)
                   ON 0 = 0
                  AND A.ATTRIBUTE4 = C.NICK_NAME
                  AND C.CELL_PLANT_SITE_ID = A.SCM_SITE_ID
                  --AND A.CELL_ITEM_ID = C.CELL_ITEM_ID
                  AND A.FROM_SITE_ID IS NULL
                INNER JOIN  SCM_MST_SITE_ITEM_PRIORITY D WITH (NOLOCK) 
                   ON 0 = 0
                  AND D.PRIORITY = 1
                  AND D.FROM_YYYYMMDD  <= @p_plan_start_yyyymmdd
                  AND D.TO_YYYYMMDD    >= @p_plan_start_yyyymmdd
                --AND @p_plan_start_yyyymmdd BETWEEN FROM_YYYYMMDD AND TO_YYYYMMDD
                  AND A.ELEC_ITEM_ID =  D.ITEM_ID
                WHERE A.ELEC_DIVISION_ID = @p_division_id -- PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 - PK 컬럼 추가 반영 (ELEC_DIVISION_ID : EE/EE_UC)

            -------------------------------------------------------------------------------------------------------------         
            --  SCP_MST_MODEL_ALLOCATION.VALID_YN ='Y'가 1개일 경우 
            --                CELL_ITEM_ID로 BOM 테이블을 조회 하여 
            --                SCP_MST_MODEL_ALLOCATION.ELEC_PLANT_SITE_ID 로 FROM_SITE를 반영한다.
            -------------------------------------------------------------------------------------------------------------               

                UPDATE A
                  SET A.FROM_SITE_ID = C.ELEC_PLANT_SITE_ID
                    , A.ATTRIBUTE1 = B.FROM_CODE  -- 구분을 위해서 
                    , A.ATTRIBUTE2 = N'1건 일 경우'
                FROM SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM A WITH (NOLOCK)   -- ELEC_ITEM_ID
                INNER JOIN #ELECTRODE_SLOC B  WITH (NOLOCK)
                   ON A.TO_SITE_ID  = B.PLANT_SITE_ID
                  AND A.STORAGE_ID  = B.STORAGE_ID
                  AND B.FROM_CODE   = '1'
                  AND A.FROM_SITE_ID IS NULL    -- 2개 이상인건 제외됨
                INNER JOIN #tmp_SCP_MST_MODEL_ALLOCATION  C WITH (NOLOCK)   -- ELEC_ITEM_ID 
                   ON 0 = 0
                  --AND C.CELL_ITEM_ID  = A.CELL_ITEM_ID
                  --AND C.DIVISION_ID   = A.DIVISION_ID
                  AND A.ATTRIBUTE4    = C.NICK_NAME
                  AND A.SCM_SITE_ID   = C.CELL_PLANT_SITE_ID 
                  AND C.YYYYMMDD      = @p_plan_start_yyyymmdd
                  AND C.VALID_YN      ='Y'
                WHERE A.ELEC_DIVISION_ID = @p_division_id -- PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 - PK 컬럼 추가 반영 (ELEC_DIVISION_ID : EE/EE_UC)
                  AND A.FROM_SITE_ID IS NULL
                  AND A.STORAGE_ID not in ('MES_DEP', 'MES')			--> not in ('MES_DEP', 'MES') 으로 변경

           
                -- STORAGE_ID가 'MES' 일때
                UPDATE A
                  SET A.FROM_SITE_ID = C.ELEC_PLANT_SITE_ID
                    , A.ATTRIBUTE1 = '1 MES'  -- 구분을 위해서 
                    , A.ATTRIBUTE2 = N'1건 일 경우'
                FROM SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM A WITH (NOLOCK)   
                INNER JOIN #tmp_SCP_MST_MODEL_ALLOCATION  C WITH (NOLOCK)   
                   ON 0 = 0
                  --AND C.CELL_ITEM_ID      = A.CELL_ITEM_ID
                  --AND C.DIVISION_ID       = A.DIVISION_ID
                  AND A.ATTRIBUTE4    = C.NICK_NAME
                  --AND A.SCM_SITE_ID   = C.CELL_PLANT_SITE_ID 
                  AND C.CELL_PLANT_SITE_ID= A.TO_SITE_ID    
                  AND C.YYYYMMDD          = @p_plan_start_yyyymmdd
                  AND C.VALID_YN          ='Y'
                WHERE A.ELEC_DIVISION_ID = @p_division_id -- PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 - PK 컬럼 추가 반영 (ELEC_DIVISION_ID : EE/EE_UC)
                  AND A.FROM_SITE_ID    IS NULL
                  AND A.STORAGE_ID  in ('MES_DEP', 'MES')			--> in ('MES_DEP', 'MES') 으로 변경

              

               -- 그외               
               UPDATE X
                  SET X.FROM_SITE_ID = P.PLANT_SITE_ID
                      ,X.ATTRIBUTE2 = 'ETC'
               FROM SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM X WITH (NOLOCK)
                INNER JOIN SCM_MST_SITE_ITEM_PRIORITY P WITH (NOLOCK)
                  ON 0 = 0
                 AND P.DIVISION_ID  = X.DIVISION_ID
                 AND P.ITEM_ID      = X.ELEC_ITEM_ID            
                  AND @p_plan_start_yyyymmdd >= P.FROM_YYYYMMDD 
                  AND @p_plan_start_yyyymmdd <= P.TO_YYYYMMDD
                 AND P.PRIORITY      = '1'
               WHERE X.ELEC_DIVISION_ID = @p_division_id -- PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 - PK 컬럼 추가 반영 (ELEC_DIVISION_ID : EE/EE_UC)
                 AND X.FROM_SITE_ID IS NULL
                 AND X.ATTRIBUTE3     = '1'
                 --AND X.STORAGE_ID    ='MES'


                UPDATE X
                   SET X.ATTRIBUTE4  = Y.NICK_NAME
                  FROM SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM X  WITH (NOLOCK)
                 INNER JOIN SCP_MST_FINAL_ITEM Y  WITH (NOLOCK)
                    ON X.DIVISION_ID = Y.DIVISION_ID
                   AND X.ELEC_ITEM_ID= Y.ITEM_ID  
                 WHERE X.ELEC_DIVISION_ID = @p_division_id -- PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 - PK 컬럼 추가 반영 (ELEC_DIVISION_ID : EE/EE_UC)

                UPDATE A
                  SET A.FROM_SITE_ID = C.ELEC_PLANT_SITE_ID
                FROM SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM A WITH (NOLOCK)   -- ELEC_ITEM_ID
                INNER JOIN #tmp_SCP_MST_MODEL_ALLOCATION  C WITH (NOLOCK)   -- ELEC_ITEM_ID 
                   ON 0 = 0
                  --AND C.CELL_ITEM_ID  = A.CELL_ITEM_ID
                  --AND C.DIVISION_ID   = A.DIVISION_ID
                  AND A.ATTRIBUTE4    = C.NICK_NAME
                  AND A.SCM_SITE_ID   = C.CELL_PLANT_SITE_ID 
                  AND C.YYYYMMDD      = @p_plan_start_yyyymmdd
                  AND C.VALID_YN      ='Y'
                WHERE A.ELEC_DIVISION_ID = @p_division_id -- PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 - PK 컬럼 추가 반영 (ELEC_DIVISION_ID : EE/EE_UC)
                  AND A.ATTRIBUTE2 = 'ETC'


            -------------------------------------------------------------------------------------------------------------         
            --  FROM CODE 3 : 구매팀 창고에 위치한 경우 (ELECTRODE_SLOC = 3)
            -------------------------------------------------------------------------------------------------------------         
            --  SCP_MST_MODEL_ALLOCATION.VALID_YN ='Y'가 2개 이상일 경우 
            --    'SITE_MAPPING' 값으로 반영
            --    SCP_MST_MODEL_ALLOCATION.CELL_PLANT_SITE_ID, ELEC_PLANT_SITE_ID와 
            --    SCM_ADM_LOOKUP_MASTER_DETAIL.SEGMENT1, SEGMENT2 가 같지 않은거
            -------------------------------------------------------------------------------------------------------------
            -- G182-A --> G183-E   LOOKUP_TYPE = 'SITE_MAPPING' 찾아서  G183-E ,  G183-E제외한 값이 1면 A011-e  2개 이상이면 프로젝트 라우트에서 가져온다.

            --SELECT A.FROM_SITE_ID , C.SEGMENT2,A.SCM_SITE_ID--,--*
            --           ,Y.CELL_PLANT_SITE_ID,Y.ELEC_PLANT_SITE_ID

            --SELECT * INTO ##SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM1 FROM SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM WITH (NOLOCK)
            --RETURN;

               UPDATE A
                   SET A.FROM_SITE_ID = Y.ELEC_PLANT_SITE_ID
                      ,A.ATTRIBUTE1   = B.FROM_CODE  -- 구분을 위해서 
                      ,A.ATTRIBUTE2   = N'2건 이상일 경우'
                FROM SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM A  WITH (NOLOCK)
                INNER JOIN #ELECTRODE_SLOC B WITH (NOLOCK)
                        ON B.PLANT_SITE_ID= A.TO_SITE_ID
                       AND B.STORAGE_ID   = A.STORAGE_ID
                       AND B.FROM_CODE    = '3'
                       AND A.FROM_SITE_ID IS NULL
                INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH (NOLOCK)   -- G182-A	G183-E
                        ON C.LOOKUP_TYPE = 'SITE_MAPPING'
                       AND A.TO_SITE_ID = C.SEGMENT1
                INNER JOIN  #tmp_SCP_MST_MODEL_ALLOCATION Y WITH (NOLOCK)
                  ON 0 = 0
                    AND A.ATTRIBUTE4         = Y.NICK_NAME
                    AND Y.YYYYMMDD           = @p_plan_start_yyyymmdd
                    AND Y.CELL_PLANT_SITE_ID =  C.SEGMENT1  
                    AND Y.ELEC_PLANT_SITE_ID <> C.SEGMENT2 
                 WHERE A.ELEC_DIVISION_ID = @p_division_id -- PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 - PK 컬럼 추가 반영 (ELEC_DIVISION_ID : EE/EE_UC)
				   AND A.FROM_SITE_ID IS NULL
                   AND A.ATTRIBUTE3 ='3'
--                   AND A.ITEM_ID ='APCAN1347A'

                UPDATE A
                  SET A.FROM_SITE_ID = Y.ELEC_PLANT_SITE_ID    
                     ,A.ATTRIBUTE1   = B.FROM_CODE  -- 구분을 위해서 
                     ,A.ATTRIBUTE2   = N'1건 일 경우'
                FROM SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM A  WITH (NOLOCK)
                INNER JOIN #ELECTRODE_SLOC B WITH (NOLOCK)
                        ON B.PLANT_SITE_ID  = A.TO_SITE_ID
                       AND B.STORAGE_ID     = A.STORAGE_ID
                       AND B.FROM_CODE      = '3'
                       AND A.FROM_SITE_ID IS NULL
                INNER JOIN  #tmp_SCP_MST_MODEL_ALLOCATION Y WITH (NOLOCK)
                  ON 0 = 0
                    AND A.ATTRIBUTE4    = Y.NICK_NAME
                    AND YYYYMMDD        = @p_plan_start_yyyymmdd
                    AND A.FROM_SITE_ID IS NULL 
                 WHERE A.ELEC_DIVISION_ID = @p_division_id -- PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 - PK 컬럼 추가 반영 (ELEC_DIVISION_ID : EE/EE_UC)

                  -- 그외               
               UPDATE X
                  SET X.FROM_SITE_ID = P.PLANT_SITE_ID
               FROM SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM X WITH (NOLOCK)
                INNER JOIN SCM_MST_SITE_ITEM_PRIORITY P WITH (NOLOCK)
                  ON 0 = 0
                 AND P.DIVISION_ID  = X.DIVISION_ID
                 AND P.ITEM_ID      = X.ELEC_ITEM_ID            
                  AND @p_plan_start_yyyymmdd >= P.FROM_YYYYMMDD 
                  AND @p_plan_start_yyyymmdd <= P.TO_YYYYMMDD
                 AND P.PRIORITY      = '1'
               WHERE X.ELEC_DIVISION_ID = @p_division_id -- PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 - PK 컬럼 추가 반영 (ELEC_DIVISION_ID : EE/EE_UC)
                 AND X.FROM_SITE_ID IS NULL
                 AND X.ATTRIBUTE3     = '3'


                /*
                -- 2개 이상일 경우 
                UPDATE A
                   SET A.FROM_SITE_ID = C.SEGMENT2
                      ,A.ATTRIBUTE1   = B.FROM_CODE  -- 구분을 위해서 
                      ,A.ATTRIBUTE2   = N'2건 이상일 경우'
                FROM SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM A  WITH (NOLOCK)
                INNER JOIN #ELECTRODE_SLOC B WITH (NOLOCK)
                        ON B.PLANT_SITE_ID= A.TO_SITE_ID
                       AND B.STORAGE_ID   = A.STORAGE_ID
                       AND B.FROM_CODE    = '3'
                       AND A.FROM_SITE_ID IS NULL
                INNER JOIN (
                              SELECT SEGMENT1,SEGMENT2
                              FROM SCM_ADM_LOOKUP_MASTER_DETAIL Y WITH (NOLOCK)   -- G182-A	G183-E
                              WHERE 0 = 0
                              AND Y.LOOKUP_TYPE = 'SITE_MAPPING'
                              AND NOT EXISTS (        
                                                    SELECT 'X'        
                                                      FROM #SCP_MST_MODEL_ALLOCATION_MULTI_CODE Z WITH(NOLOCK)        
                                                    WHERE 1=1        
                                                      AND Z.CELL_PLANT_SITE_ID  = Y.SEGMENT1                                
                                                      AND Z.ELEC_PLANT_SITE_ID  = Y.SEGMENT2                        
                                                ) 

                            ) C
                        ON A.TO_SITE_ID = C.SEGMENT1
                     WHERE A.FROM_SITE_ID IS NULL
                       AND A.CELL_ITEM_ID IN (SELECT CELL_ITEM_ID FROM #SCP_MST_MODEL_ALLOCATION_MULTI_CODE WITH (NOLOCK))
                
                      
               UPDATE A
                  SET A.FROM_SITE_ID = C.ELEC_PLANT_SITE_ID    
                     ,A.ATTRIBUTE1   = B.FROM_CODE  -- 구분을 위해서 
                     ,A.ATTRIBUTE2   = N'1건 일 경우'
                FROM SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM A  WITH (NOLOCK)
                INNER JOIN #ELECTRODE_SLOC B WITH (NOLOCK)
                        ON B.PLANT_SITE_ID  = A.TO_SITE_ID
                       AND B.STORAGE_ID     = A.STORAGE_ID
                       AND B.FROM_CODE      = '3'
                       AND A.FROM_SITE_ID IS NULL
                INNER JOIN  SCP_MST_MODEL_ALLOCATION  C WITH (NOLOCK)   -- ELEC_ITEM_ID 
                        ON 0 = 0
                       AND C.CELL_ITEM_ID  = A.CELL_ITEM_ID
                       AND YYYYMMDD        = @p_plan_start_yyyymmdd
                       AND A.FROM_SITE_ID IS NULL 
                
                  -- 그외               
               UPDATE X
                  SET X.FROM_SITE_ID = P.PLANT_SITE_ID
               FROM SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM X WITH (NOLOCK)
                INNER JOIN SCM_MST_SITE_ITEM_PRIORITY P WITH (NOLOCK)
                  ON 0 = 0
                 AND P.DIVISION_ID  = X.DIVISION_ID
                 AND P.ITEM_ID      = X.ELEC_ITEM_ID            
                  AND @p_plan_start_yyyymmdd >= P.FROM_YYYYMMDD 
                  AND @p_plan_start_yyyymmdd <= P.TO_YYYYMMDD
                 AND P.PRIORITY      = '1'
               WHERE 0 = 0
                 AND X.FROM_SITE_ID IS NULL
                 AND X.ATTRIBUTE3     = '3'
              */

            -------------------------------------------------------------------------------------------------------------         
            --  FROM CODE 4 : 물류창고에 위치한 경우
            -------------------------------------------------------------------------------------------------------------         
            --  SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM.TO_SITE_ID 와 
            --  SCM_ADM_LOOKUP_MASTER_DETAIL.SEGMENT1과 같은 값의 SEGMENT2 --> from site
            -------------------------------------------------------------------------------------------------------------
            UPDATE A
                  SET A.FROM_SITE_ID = C.SEGMENT2    
                     ,A.ATTRIBUTE1   = B.FROM_CODE  -- 구분을 위해서 
                     ,A.ATTRIBUTE2   = N'1건 일 경우'
                FROM SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM A  WITH (NOLOCK)
                INNER JOIN #ELECTRODE_SLOC B WITH (NOLOCK)
                        ON B.PLANT_SITE_ID  = A.TO_SITE_ID
                       AND B.STORAGE_ID     = A.STORAGE_ID
                       AND B.FROM_CODE      = '4'
                       AND A.FROM_SITE_ID IS NULL
                INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH (NOLOCK)   -- G182-A	G183-E
                        ON 0 = 0
                       AND C.LOOKUP_TYPE = 'SITE_MAPPING'
                       AND C.SEGMENT1    = A.TO_SITE_ID
                WHERE A.ELEC_DIVISION_ID = @p_division_id -- PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 - PK 컬럼 추가 반영 (ELEC_DIVISION_ID : EE/EE_UC)
                  AND A.FROM_SITE_ID IS NULL

                

            -------------------------------------------------------------------------------------------------------------         
            --  INTRANSIT : 
            -------------------------------------------------------------------------------------------------------------         
             -- LOOKUP_TYPE ='SITE_MAPPING'의 FROM_SCM_SITE_ID가 SEGMENT1 같은 경우 SEGMENT2, NULL 일경우 SEGMENT1
            -------------------------------------------------------------------------------------------------------------

             DECLARE @xls_key int
             SELECT @xls_key = ISNULL(MAX(XLS_KEY),1) 
			   FROM SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM WITH (NOLOCK)
			  WHERE ELEC_DIVISION_ID = @p_division_id -- PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 - PK 컬럼 추가 반영 (ELEC_DIVISION_ID : EE/EE_UC)

             INSERT INTO SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM
              SELECT  @p_plan_id    AS PLAN_ID
                    , @p_plan_type  AS PLAN_TYPE
                    ,A.DIVISION_ID
                    ,A.PLANT_ID
                    ,A.ITEM_ID
                    ,'INTRANSIT' AS STOCK_TYPE
                    , NULL AS STORAGE_DESCRIPTION
                    --, A.FROM_SCM_SITE_ID AS SCM_SITE_ID
                    ,(CASE WHEN A.FROM_SCM_SITE_ID = Y.SEGMENT1 THEN Y.SEGMENT2
	                          ELSE A.FROM_SCM_SITE_ID
	                      END) AS SCM_SITE_ID
                    ,'INTRANSIT' AS STORAGE_ID
                    ,'-' AS OPERATION_ID
                    , NULL AS MES_MAP_SLOC
                    ,A.DELIVERY_QTY AS SCM_QTY
                    ,NULL AS L1
                    ,NULL AS L1_QTY
                    ,NULL AS L2
                    ,NULL AS L2_QTY
                    ,NULL AS L3
                    ,NULL AS L3_QTY
                    ,A.ITEM_ID AS ELEC_ITEM_ID
                    ,A.DELIVERY_QTY * ISNULL(B.CONVERT_QTY_CELL,1)  AS CONVERT_QTY
                    ,ISNULL(B.CONVERT_QTY_CELL,1) AS CONVERT_QTY_CELL
                    ,B.CELL_ITEM_ID AS CELL_ITEM_ID
--                    ,A.FROM_SCM_SITE_ID AS TO_SITE_ID
                     ,(CASE WHEN A.FROM_SCM_SITE_ID = Y.SEGMENT1 THEN Y.SEGMENT2
	                          ELSE A.FROM_SCM_SITE_ID
	                      END) AS FROM_SITE_ID
                    ,A.TO_SCM_SITE_ID AS TO_SITE_ID
--                    ,NULL AS XLS_KEY
                    ,@xls_key + (ROW_NUMBER() OVER (ORDER BY (SELECT NULL))) AS  XLS_KEY
                    ,@p_user_id AS CREATED_BY
                    ,GETDATE() AS CREATION_DATE
                    ,@p_user_id AS LAST_UPDATED_BY
                    ,GETDATE() AS LAST_UPDATE_DATE
                    ,NULL AS ATTRIBUTE1
                    ,NULL AS ATTRIBUTE2
                    ,'SCM_DNM_INTRANSIT_V' AS ATTRIBUTE3
                    ,NULL AS ATTRIBUTE4
                    ,NULL AS ATTRIBUTE5
                    ,NULL AS ATTRIBUTE6
                    ,NULL AS ATTRIBUTE7
                    ,NULL AS ATTRIBUTE8
                    ,NULL AS ATTRIBUTE9
                    ,NULL AS ATTRIBUTE10
                    ,NULL AS RN
                    ,NULL AS BOM_RN
                    ,NULL AS STOCK_RN
                    ,NULL AS LVL
					,convert(date, '1999-01-01') AS AVAILABLE_DATE		-- KSW 2021.07.13 C20210702-000348 - 전극 시뮬레이터 내 BOH 보류재고 반영 로직 수정 요청의 건 - available_date(가용예상일자) 컬럼추가
					,@p_division_id										-- PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 - PK 컬럼 추가 반영 (ELEC_DIVISION_ID : EE/EE_UC)
              FROM SCM_DNM_INTRANSIT_V A WITH (NOLOCK)
              INNER JOIN SCP_MST_FINAL_ITEM B WITH (NOLOCK)
                 ON A.ITEM_ID      = B.ITEM_ID
                AND A.DIVISION_ID = B.DIVISION_ID
                LEFT OUTER JOIN  SCM_ADM_LOOKUP_MASTER_DETAIL Y WITH (NOLOCK)   -- G182-A	G183-E
                ON 0 = 0
               AND Y.LOOKUP_TYPE = 'SITE_MAPPING'
               AND A.FROM_SCM_SITE_ID = SEGMENT1 
              WHERE 0 = 0
                AND RESULT_DATE = @p_cutoff_date
                AND RESULT_TYPE IN ('I','S','C')
                AND B.OPERATION_GROUP_ID ='E'
                AND A.FROM_SCM_SITE_ID IS NOT NULL
				AND 'Y' = (CASE WHEN @p_division_id = 'EE'    AND A.DIVISION_ID IN ('81', '82', '40') THEN 'Y'	--> *** 2022.06.23 :: SCM_DNM_INTRANSIT_V UC, LG 사업부 구분
						        WHEN @p_division_id = 'EE_UC' AND A.DIVISION_ID = '81_UC' THEN 'Y'
						        WHEN @p_division_id = 'EE_HM' AND A.DIVISION_ID = '81_HM' THEN 'Y'
								ELSE 'N' END)
				;
               



            -------------------------------------------------------------------------------------------------------------         
            -- 임시 TEMP  테이블 DROP  
            -------------------------------------------------------------------------------------------------------------

              IF OBJECT_ID('tempdb..#tmp_SCM_ITEM_CLASS_M') IS NOT NULL	
	              DROP TABLE #tmp_SCM_ITEM_CLASS_M

	            IF OBJECT_ID('tempdb..#tmp_SCP_ENG_BOMCOMPONENTS_I_SN') IS NOT NULL      
	              DROP TABLE #tmp_SCP_ENG_BOMCOMPONENTS_I_SN;

              IF OBJECT_ID('tempdb..#PLAN_CYCLE') IS NOT NULL      
	              DROP TABLE #PLAN_CYCLE;       

              IF OBJECT_ID('tempdb..#tmp_SCM_DNM_STOCK_V') IS NOT NULL	
                DROP TABLE #tmp_SCM_DNM_STOCK_V

              IF OBJECT_ID('tempdb..#TREE_MODEL1') IS NOT NULL	
                DROP TABLE #TREE_MODEL1

              IF OBJECT_ID('tempdb..#GROUP_TBL1') IS NOT NULL	
                DROP TABLE #GROUP_TBL1  

              IF OBJECT_ID('tempdb..#BOM1') IS NOT NULL	
                DROP TABLE #BOM1                                       
                
              IF OBJECT_ID('tempdb..#TREE_MODEL2') IS NOT NULL	
                DROP TABLE #TREE_MODEL2

              IF OBJECT_ID('tempdb..#GROUP_TBL2') IS NOT NULL	
                DROP TABLE #GROUP_TBL2
                
              IF OBJECT_ID('tempdb..#BOM2') IS NOT NULL	
                DROP TABLE #BOM2
                
              IF OBJECT_ID('tempdb..#TREE_MODEL3') IS NOT NULL	
                DROP TABLE #TREE_MODEL3

              IF OBJECT_ID('tempdb..#GROUP_TBL3') IS NOT NULL	
                DROP TABLE #GROUP_TBL3
                
              IF OBJECT_ID('tempdb..#BOM3') IS NOT NULL	
                DROP TABLE #BOM3

              IF OBJECT_ID('tempdb..#BOM4') IS NOT NULL	
                DROP TABLE #BOM4
                

              IF OBJECT_ID('tempdb..#TBL') IS NOT NULL	
                DROP TABLE #TBL

              IF OBJECT_ID('tempdb..#SCP_MST_MODEL_ALLOCATION_MULTI') IS NOT NULL	
                DROP TABLE #SCP_MST_MODEL_ALLOCATION_MULTI

              IF OBJECT_ID('tempdb..#SCP_MST_MODEL_ALLOCATION_MULTI_CODE') IS NOT NULL	
                DROP TABLE #SCP_MST_MODEL_ALLOCATION_MULTI_CODE


              
              

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
      
  
  
     SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
                          REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))     
       
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
  
  

