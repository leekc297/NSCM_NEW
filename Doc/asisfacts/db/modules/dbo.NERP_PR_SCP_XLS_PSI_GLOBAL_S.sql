



/*      
 * Program ID   : PR_SCP_XLS_PSI_GLOBAL_S        
 * Description  : PR_SCP_XLS_PSI_GLOBAL 에서 호출함.      
 * OutTable     :      
 * Execute      : 
 * Program History      
 *===================================================================================================      
 *   Date       In Charge      Description      
 *===================================================================================================      
 * 2021.05.20   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전으로 신규생성
                            - 구 버전에서 PIVOT 생성단계 이후 단계를 호출하는 로직으로 분리함 (1 YEAR 구간별 생성 :: 중장기 구현시 컬럼 및 행 SIZE 제약 해결)
 * 2021.05.27   KSW         NICK NAME 누락오류 수정
 * 2021.08.10   KSW         PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - CAPA. 형교환 입력(Load Ratio 표시) 및 저장기능 구현
 * 2021.08.17   KSW         PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V
 * 2021.09.08   KSW         PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - 전진검사 LT 적용
 * 2021.10.19   KSW         PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 [추가개선] - Pack BOH 수량에서 Hold 수량제외
 * 2021.10.28   KSW         튜닝 개선안 적용
 * 2022.03.02   KSW         BOD 정보가 없는 SEMI_SHIP_PLAN UPDATE (BOD_ID, ATTRIBUTE3, LT_DAY)
 * 2022.03.23	KSW	        GM JV 반영
 * 2022.07.29   KSW         DIO Report에서 사용되는 GRO_STD_DIO, MIN_STD_DIO 으로 대체
 * 2022.08.30   KSW			Cell 재고 개선건
 *							1) PACK_CELL_BOH	Cell BOH measure 에서 HOLD 수량제외
 *							2) Cell BOH(Hold) new measure 에 주차별 표시, FROM_BOH_QTY 에 (플랜범위이전 + 플랜범위초과) 영역의 수량 표시
 *							3) CELL_FORM_HOLD_AFTER	After Form. Hold Release measure 에서 FROM_BOH_QTY 에 (플랜범위이전 + 플랜범위초과) 영역의 수량 표시
 * 2022.10.14	KSW			불필요한 생산계획 생성을 차단
 * 2022.10.11	KSW			W01 ~ W08 주차 합산 생산계획이 0 일 경우 1 추가 건에 대한 처리
 * 2023.07.01  DHJ/KSK	    PJ20230691  SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화 분리
 ---------------------------------------------------------------------------------------------------
     -- DELETE FROM SCM_SYS_LOG_BATCH where CREATED_BY ='kth'
      EXEC PR_SCP_XLS_PSI_GLOBAL_S
               @p_plan_cycle          = 'WEEKLY'
             , @p_plan_start_yyyymmdd = '20210429'
             , @p_plan_id             = '1071'
             , @p_modeling_id         = '2'
             , @p_seq                 = '1'
             , @p_plan_type           = 'PR'
             , @p_master_id           = '81::WEEKLY'
             , @p_division_id         = '81'
             , @p_engine_plan_id      = '1071::PR::1'
		     , @p_create_from_yyyymmdd  = '20210429'
	         , @p_create_to_yyyymmdd    = '20220428'
             , @p_user_id             = 'KSW'
 
    SELECT * FROM SCM_SYS_LOG_BATCH  where PROGRAM_NAME ='PR_SCP_XLS_PSI_GLOBAL_S' order by CREATION_DATE desc
--DROP PROC dbo.PR_SCP_XLS_PSI_GLOBAL_S
 */    


CREATE PROCEDURE [dbo].[NERP_PR_SCP_XLS_PSI_GLOBAL_S]
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
	, @p_create_from_yyyymmdd  NVARCHAR(0008)
	, @p_create_to_yyyymmdd   NVARCHAR(0008)
    , @p_user_id              NVARCHAR(0150)  = 'SCP_batch'        
    ---- , @p_debug       INT OUTPUT      
)       
AS  
  BEGIN      
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;      
    SET NOCOUNT ON;      
    SET XACT_ABORT ON;      
    --SET ANSI_WARNINGS OFF;      
	SET ANSI_WARNINGS ON;     
    SET ANSI_NULLS ON;
      
    -- LOG 용 변수 설정      
    DECLARE @v_batch_user   NVARCHAR(150) = N'SCP_batch';        
    SET @v_batch_user                     = @p_user_id      
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_XLS_PSI_GLOBAL_S';      
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

    DECLARE @p_program_id   NVARCHAR(30) = 'XLSPSI01'          
    ----DECLARE @p_to_yyyymmdd  VARCHAR(8)   =  CONVERT(VARCHAR(8), DATEADD(day, 364, @p_plan_start_yyyymmdd), 112)
    ----DECLARE @p_cutoff_date  VARCHAR(8)   =  CONVERT(VARCHAR(8), DATEADD(day,  -1, @p_plan_start_yyyymmdd), 112)

    --DECLARE @debug_mode            NVARCHAR(30) = 'T'
        BEGIN TRY        
          BEGIN        

              -------------------------------------------------------------------------------------------------------------         
              -- Line Load 율 - #LineLoad 를 1 YEAR 단위로 처리하기 위해서 다시 생성함
              -------------------------------------------------------------------------------------------------------------


	              IF OBJECT_ID('tempdb..#LineLoad') IS NOT NULL      
	                DROP TABLE #LineLoad;  
  	
                SELECT /*DISTINCT */
						          A.DIVISION_ID
					          , A.SCM_SITE_ID 
                    , A.OPERATION_GROUP
		                , A.OPERATION_ID
		                , A.LINE_ID
                    , (CASE WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND  A.OPERATION_GROUP ='P' THEN 'PACK_PROD_LOAD' WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND  A.OPERATION_GROUP ='A'  THEN 'CELL_PROD_LOAD' END ) AS MEASURE
                    , CASE WHEN D.WORKING_TIME <= 0.0 THEN 0 ELSE ISNULL( ( ( ROUND(SUM(A.QTY * (E.TACT_TIME/60)),0) / D.WORKING_TIME ) ) ,0 ) *100  END AS QTY
					          , ISNULL(ROUND(SUM(A.QTY * (E.TACT_TIME/60)),0), 0) AS CAPA_TACT
					          , ISNULL( D.WORKING_TIME ,0 ) AS WORKING_TIME
                    , A.YYYYMMDD AS YYYYMMDD
                    , C.ISO_YYYYWW AS ISO_YYYYWW
					, M.TIME_TERM		-- 형교환(Model Change)
                    ,'WQTY' + REPLICATE('0', 2 - LEN(DENSE_RANK()  OVER(PARTITION BY  A.LINE_ID ORDER BY C.ISO_YYYYWW) )) + CONVERT(NVARCHAR,DENSE_RANK()  OVER(PARTITION BY  A.LINE_ID ORDER BY C.ISO_YYYYWW))  AS WEEK_COLUMN
                INTO #LineLoad
			          FROM SCP_ANL_PRODUCTION_PLAN A WITH (NOLOCK)
                INNER JOIN SCM_SYS_CALENDAR_M C   WITH (NOLOCK)
                        ON A.YYYYMMDD = C.BASIS_YYYYMMDD
			          LEFT OUTER JOIN #LINE_WORKINGTIME_BY_LOSS D  WITH (NOLOCK)
                     ON   A.DIVISION_ID   = D.DIVISION_ID 
                      AND A.OPERATION_ID  = D.OPERATION_ID 
					            AND A.SCM_SITE_ID   = D.SCM_SITE_ID 
					            AND A.LINE_ID       = D.LINE_ID 
					            AND A.YYYYMMDD      = D.YYYYMMDD
			          LEFT OUTER JOIN SCP_ANL_TACT_TIME E WITH(NOLOCK)	
                      ON A.DIVISION_ID    = E.DIVISION_ID 
                     AND A.OPERATION_ID   = E.OPERATION_ID 
				             AND A.SCM_SITE_ID    = E.SCM_SITE_ID  
				             AND A.LINE_ID        = E.LINE_ID 
                     AND A.ITEM_ID        = E.ITEM_ID 
				             AND A.YYYYMMDD       = E.YYYYMMDD
				-- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - CAPA. 형교환 입력(Load Ratio 표시) 및 저장기능 구현
				-- 형교환(Model Change) 적용 - start
				  LEFT OUTER JOIN SCM_WORK_CALENDAR_M_SN M  WITH (NOLOCK)
				    ON A.DIVISION_ID           = M.DIVISION_ID
			      --AND LEFT(A.SCM_SITE_ID, 4) = M.PLANT_ID
                    AND CASE 
						WHEN CHARINDEX('-', A.SCM_SITE_ID) > 0
						THEN SUBSTRING(A.SCM_SITE_ID, 0,CHARINDEX('-', A.SCM_SITE_ID))
						ELSE A.SCM_SITE_ID
						END = M.PLANT_ID
					AND A.OPERATION_ID         = M.OPERATION_ID
					AND convert(datetime, A.YYYYMMDD)             = M.WORK_DATE
					AND A.LINE_ID              = M.LINE_ID
					AND M.LOSS_CODE            = 'XC031'
				-- 형교환(Model Change) 적용 - end
			          WHERE 1=1 
                   AND A.DIVISION_ID         = @p_division_id
                  AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
                  AND A.PLAN_TYPE           = @p_plan_type
                  AND A.SEQ                 = @p_seq
			            AND A.YYYYMMDD           >= @p_create_from_yyyymmdd
	                AND A.YYYYMMDD           <=  @p_create_to_yyyymmdd
--	                AND A.MEASURE             IN ('CELL_PROD','PACK_PROD')
                  AND A.MEASURE             IN ('PROD_PLAN_AMEND')                  
              GROUP BY A.DIVISION_ID, A.SCM_SITE_ID ,A.OPERATION_ID ,A.LINE_ID, A.YYYYMMDD, D.WORKING_TIME,  C.ISO_YYYYWW,A.OPERATION_GROUP
                      ,(CASE WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND  A.OPERATION_GROUP ='P' THEN 'PACK_PROD_LOAD' WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND  A.OPERATION_GROUP ='A'  THEN 'CELL_PROD_LOAD' END ) 
					  , M.TIME_TERM		-- 형교환(Model Change)
					  ;
					  


            -------------------------------------------------------------------------------------------------------------         
            -- 전체 임시 테이블 생성  (#SCP_XLS_PSI_GLOBAL_AUTO)
            -------------------------------------------------------------------------------------------------------------  
                IF OBJECT_ID('tempdb..#SCP_XLS_PSI_GLOBAL_AUTO') IS NOT NULL	
	                  DROP TABLE #SCP_XLS_PSI_GLOBAL_AUTO

              --DROP TABLE #SCP_XLS_PSI_GLOBAL_AUTO
              CREATE TABLE #SCP_XLS_PSI_GLOBAL_AUTO(
	              DIVISION_ID           NVARCHAR(030)     NULL,
	              PLAN_START_YYYYMMDD   NVARCHAR(008)     NULL,
	              PLAN_TYPE             NVARCHAR(050)     NULL,
	              SEQ                   BIGINT            NULL,
	              OPERATION_GROUP       NVARCHAR(010)     NULL,
	              OPERATION_GROUP_NAME  NVARCHAR(100)     NULL,   -- 신규
	              CELL_ITEM_ID          NVARCHAR(150)     NULL,
	              ITEM_ID               NVARCHAR(050)     NULL,
	              NICK_NAME             NVARCHAR(200)     NULL,
	              CELL_QTY_PACK         NUMERIC (20,10)   NULL,   -- 신규
	              TO_SITE               NVARCHAR(030)     NULL,
	              TO_SITE_DESCRIPTION   NVARCHAR(150)     NULL,   -- SCM_SITE_DESCRIPTION
                PROJECT_CODE          NVARCHAR(050)     NULL,   -- FG 때문에 추가
	              FROM_BOH_QTY          NUMERIC(20, 10)   NULL,
	              TO_BOH_QTY            NUMERIC(20, 10)   NULL,
	              INCOTERMS             NVARCHAR(010)     NULL,
	              FROM_SITE             NVARCHAR(030)     NULL,
	              FROM_SITE_DESCRIPTION NVARCHAR(150)     NULL,   -- SCM_SITE_DESCRIPTION
                TRANSPORT_MODE        NVARCHAR(050)     NULL,
                PROD_LINE             NVARCHAR(050)     NULL,
	              LT_DAY                INT               NULL,
	              BOD_ID                NVARCHAR(150)     NULL,
	              MEASURE               NVARCHAR(050)     NULL,
	              MEASURE_LABEL         NVARCHAR(150)     NULL,   -- COLUMN_LABEL_NAME
	              XLS_KEY1              NVARCHAR(200)     NULL,
	              XLS_KEY2              NVARCHAR(200)     NULL,
	              XLS_KEY3              NVARCHAR(200)     NULL,
	              XLS_KEY4              NVARCHAR(200)     NULL,
	              XLS_KEY5              NVARCHAR(200)     NULL,
	              XLS_ATTRIBUTE1        NVARCHAR(200)     NULL,
	              XLS_ATTRIBUTE2        NVARCHAR(200)     NULL,
	              XLS_ATTRIBUTE3        NVARCHAR(200)     NULL,
	              XLS_ATTRIBUTE4        NVARCHAR(200)     NULL,
	              XLS_ATTRIBUTE5        NVARCHAR(200)     NULL,
	              SORT_ORDER_NO         INT               NULL,
	              
                QTY001  NUMERIC (20,10) NULL, QTY002  NUMERIC (20,10) NULL, QTY003  NUMERIC (20,10) NULL, QTY004 NUMERIC (20,10) NULL,  QTY005  NUMERIC (20,10) NULL, -- 신규
	            QTY006  NUMERIC (20,10) NULL,	QTY007  NUMERIC (20,10) NULL, QTY008  NUMERIC (20,10) NULL, QTY009 NUMERIC (20,10) NULL,  QTY010  NUMERIC (20,10) NULL,
	            QTY011  NUMERIC (20,10) NULL, QTY012  NUMERIC (20,10) NULL, QTY013  NUMERIC (20,10) NULL, QTY014 NUMERIC (20,10) NULL,  QTY015  NUMERIC (20,10) NULL,
	            QTY016  NUMERIC (20,10) NULL,	QTY017  NUMERIC (20,10) NULL, QTY018  NUMERIC (20,10) NULL, QTY019 NUMERIC (20,10) NULL,  QTY020  NUMERIC (20,10) NULL,
                QTY021  NUMERIC (20,10) NULL, QTY022  NUMERIC (20,10) NULL, QTY023  NUMERIC (20,10) NULL, QTY024 NUMERIC (20,10) NULL,  QTY025  NUMERIC (20,10) NULL,
	            QTY026  NUMERIC (20,10) NULL,	QTY027  NUMERIC (20,10) NULL, QTY028  NUMERIC (20,10) NULL, QTY029 NUMERIC (20,10) NULL,  QTY030  NUMERIC (20,10) NULL,
                QTY031  NUMERIC (20,10) NULL, QTY032  NUMERIC (20,10) NULL, QTY033  NUMERIC (20,10) NULL, QTY034 NUMERIC (20,10) NULL,  QTY035  NUMERIC (20,10) NULL,
	            QTY036  NUMERIC (20,10) NULL,	QTY037  NUMERIC (20,10) NULL, QTY038  NUMERIC (20,10) NULL, QTY039 NUMERIC (20,10) NULL,  QTY040  NUMERIC (20,10) NULL,
                QTY041  NUMERIC (20,10) NULL, QTY042  NUMERIC (20,10) NULL, QTY043  NUMERIC (20,10) NULL, QTY044 NUMERIC (20,10) NULL,  QTY045  NUMERIC (20,10) NULL,
	            QTY046  NUMERIC (20,10) NULL,	QTY047  NUMERIC (20,10) NULL, QTY048  NUMERIC (20,10) NULL, QTY049 NUMERIC (20,10) NULL,  QTY050  NUMERIC (20,10) NULL,

                QTY051  NUMERIC (20,10) NULL, QTY052  NUMERIC (20,10) NULL, QTY053  NUMERIC (20,10) NULL, QTY054 NUMERIC (20,10) NULL,  QTY055  NUMERIC (20,10) NULL,
	            QTY056  NUMERIC (20,10) NULL,	QTY057  NUMERIC (20,10) NULL, QTY058  NUMERIC (20,10) NULL, QTY059 NUMERIC (20,10) NULL,  QTY060  NUMERIC (20,10) NULL,
                QTY061  NUMERIC (20,10) NULL, QTY062  NUMERIC (20,10) NULL, QTY063  NUMERIC (20,10) NULL, QTY064 NUMERIC (20,10) NULL,  QTY065  NUMERIC (20,10) NULL,
	            QTY066  NUMERIC (20,10) NULL,	QTY067  NUMERIC (20,10) NULL, QTY068  NUMERIC (20,10) NULL, QTY069 NUMERIC (20,10) NULL,  QTY070  NUMERIC (20,10) NULL,
                QTY071  NUMERIC (20,10) NULL, QTY072  NUMERIC (20,10) NULL, QTY073  NUMERIC (20,10) NULL, QTY074 NUMERIC (20,10) NULL,  QTY075  NUMERIC (20,10) NULL,
	            QTY076  NUMERIC (20,10) NULL,	QTY077  NUMERIC (20,10) NULL, QTY078  NUMERIC (20,10) NULL, QTY079 NUMERIC (20,10) NULL,  QTY080  NUMERIC (20,10) NULL,
                QTY081  NUMERIC (20,10) NULL, QTY082  NUMERIC (20,10) NULL, QTY083  NUMERIC (20,10) NULL, QTY084 NUMERIC (20,10) NULL,  QTY085  NUMERIC (20,10) NULL,
	            QTY086  NUMERIC (20,10) NULL,	QTY087  NUMERIC (20,10) NULL, QTY088  NUMERIC (20,10) NULL, QTY089 NUMERIC (20,10) NULL,  QTY090  NUMERIC (20,10) NULL,
                QTY091  NUMERIC (20,10) NULL, QTY092  NUMERIC (20,10) NULL, QTY093  NUMERIC (20,10) NULL, QTY094 NUMERIC (20,10) NULL,  QTY095  NUMERIC (20,10) NULL,
	            QTY096  NUMERIC (20,10) NULL,	QTY097  NUMERIC (20,10) NULL, QTY098  NUMERIC (20,10) NULL, QTY099 NUMERIC (20,10) NULL,  QTY100  NUMERIC (20,10) NULL,

                QTY101  NUMERIC (20,10) NULL, QTY102  NUMERIC (20,10) NULL, QTY103  NUMERIC (20,10) NULL, QTY104 NUMERIC (20,10) NULL,  QTY105  NUMERIC (20,10) NULL,
	            QTY106  NUMERIC (20,10) NULL,	QTY107  NUMERIC (20,10) NULL, QTY108  NUMERIC (20,10) NULL, QTY109 NUMERIC (20,10) NULL,  QTY110  NUMERIC (20,10) NULL,
	            QTY111  NUMERIC (20,10) NULL, QTY112  NUMERIC (20,10) NULL, QTY113  NUMERIC (20,10) NULL, QTY114 NUMERIC (20,10) NULL,  QTY115  NUMERIC (20,10) NULL,
	            QTY116  NUMERIC (20,10) NULL,	QTY117  NUMERIC (20,10) NULL, QTY118  NUMERIC (20,10) NULL, QTY119 NUMERIC (20,10) NULL,  QTY120  NUMERIC (20,10) NULL,
                QTY121  NUMERIC (20,10) NULL, QTY122  NUMERIC (20,10) NULL, QTY123  NUMERIC (20,10) NULL, QTY124 NUMERIC (20,10) NULL,  QTY125  NUMERIC (20,10) NULL,
	            QTY126  NUMERIC (20,10) NULL,	QTY127  NUMERIC (20,10) NULL, QTY128  NUMERIC (20,10) NULL, QTY129 NUMERIC (20,10) NULL,  QTY130  NUMERIC (20,10) NULL,
                QTY131  NUMERIC (20,10) NULL, QTY132  NUMERIC (20,10) NULL, QTY133  NUMERIC (20,10) NULL, QTY134 NUMERIC (20,10) NULL,  QTY135  NUMERIC (20,10) NULL,
	            QTY136  NUMERIC (20,10) NULL,	QTY137  NUMERIC (20,10) NULL, QTY138  NUMERIC (20,10) NULL, QTY139 NUMERIC (20,10) NULL,  QTY140  NUMERIC (20,10) NULL,
                QTY141  NUMERIC (20,10) NULL, QTY142  NUMERIC (20,10) NULL, QTY143  NUMERIC (20,10) NULL, QTY144 NUMERIC (20,10) NULL,  QTY145  NUMERIC (20,10) NULL,
	            QTY146  NUMERIC (20,10) NULL,	QTY147  NUMERIC (20,10) NULL, QTY148  NUMERIC (20,10) NULL, QTY149 NUMERIC (20,10) NULL,  QTY150  NUMERIC (20,10) NULL,

                QTY151 NUMERIC (20,10) NULL, QTY152  NUMERIC (20,10) NULL, QTY153  NUMERIC (20,10) NULL, QTY154 NUMERIC (20,10) NULL,  QTY155  NUMERIC (20,10) NULL,
	            QTY156  NUMERIC (20,10) NULL,	QTY157  NUMERIC (20,10) NULL, QTY158  NUMERIC (20,10) NULL, QTY159 NUMERIC (20,10) NULL,  QTY160  NUMERIC (20,10) NULL,
                QTY161  NUMERIC (20,10) NULL, QTY162  NUMERIC (20,10) NULL, QTY163  NUMERIC (20,10) NULL, QTY164 NUMERIC (20,10) NULL,  QTY165  NUMERIC (20,10) NULL,
	            QTY166  NUMERIC (20,10) NULL,	QTY167  NUMERIC (20,10) NULL, QTY168  NUMERIC (20,10) NULL, QTY169 NUMERIC (20,10) NULL,  QTY170  NUMERIC (20,10) NULL,
                QTY171  NUMERIC (20,10) NULL, QTY172  NUMERIC (20,10) NULL, QTY173  NUMERIC (20,10) NULL, QTY174 NUMERIC (20,10) NULL,  QTY175  NUMERIC (20,10) NULL,
	            QTY176  NUMERIC (20,10) NULL,	QTY177  NUMERIC (20,10) NULL, QTY178  NUMERIC (20,10) NULL, QTY179 NUMERIC (20,10) NULL,  QTY180  NUMERIC (20,10) NULL,
                QTY181  NUMERIC (20,10) NULL, QTY182  NUMERIC (20,10) NULL, QTY183  NUMERIC (20,10) NULL, QTY184 NUMERIC (20,10) NULL,  QTY185  NUMERIC (20,10) NULL,
	            QTY186  NUMERIC (20,10) NULL,	QTY187  NUMERIC (20,10) NULL, QTY188  NUMERIC (20,10) NULL, QTY189 NUMERIC (20,10) NULL,  QTY190  NUMERIC (20,10) NULL,
                QTY191  NUMERIC (20,10) NULL, QTY192  NUMERIC (20,10) NULL, QTY193  NUMERIC (20,10) NULL, QTY194 NUMERIC (20,10) NULL,  QTY195  NUMERIC (20,10) NULL,
	            QTY196  NUMERIC (20,10) NULL,	QTY197  NUMERIC (20,10) NULL, QTY198  NUMERIC (20,10) NULL, QTY199 NUMERIC (20,10) NULL,  QTY200  NUMERIC (20,10) NULL,

                QTY201  NUMERIC (20,10) NULL, QTY202  NUMERIC (20,10) NULL, QTY203  NUMERIC (20,10) NULL, QTY204 NUMERIC (20,10) NULL,  QTY205  NUMERIC (20,10) NULL,
	            QTY206  NUMERIC (20,10) NULL,	QTY207  NUMERIC (20,10) NULL, QTY208  NUMERIC (20,10) NULL, QTY209 NUMERIC (20,10) NULL,  QTY210  NUMERIC (20,10) NULL,
	            QTY211  NUMERIC (20,10) NULL, QTY212  NUMERIC (20,10) NULL, QTY213  NUMERIC (20,10) NULL, QTY214 NUMERIC (20,10) NULL,  QTY215  NUMERIC (20,10) NULL,
	            QTY216  NUMERIC (20,10) NULL,	QTY217  NUMERIC (20,10) NULL, QTY218  NUMERIC (20,10) NULL, QTY219 NUMERIC (20,10) NULL,  QTY220  NUMERIC (20,10) NULL,
                QTY221  NUMERIC (20,10) NULL, QTY222  NUMERIC (20,10) NULL, QTY223  NUMERIC (20,10) NULL, QTY224 NUMERIC (20,10) NULL,  QTY225  NUMERIC (20,10) NULL,
	            QTY226  NUMERIC (20,10) NULL,	QTY227  NUMERIC (20,10) NULL, QTY228  NUMERIC (20,10) NULL, QTY229 NUMERIC (20,10) NULL,  QTY230  NUMERIC (20,10) NULL,
                QTY231  NUMERIC (20,10) NULL, QTY232  NUMERIC (20,10) NULL, QTY233  NUMERIC (20,10) NULL, QTY234 NUMERIC (20,10) NULL,  QTY235  NUMERIC (20,10) NULL,
	            QTY236  NUMERIC (20,10) NULL,	QTY237  NUMERIC (20,10) NULL, QTY238  NUMERIC (20,10) NULL, QTY239 NUMERIC (20,10) NULL,  QTY240  NUMERIC (20,10) NULL,
                QTY241  NUMERIC (20,10) NULL, QTY242  NUMERIC (20,10) NULL, QTY243  NUMERIC (20,10) NULL, QTY244 NUMERIC (20,10) NULL,  QTY245  NUMERIC (20,10) NULL,
	            QTY246  NUMERIC (20,10) NULL,	QTY247  NUMERIC (20,10) NULL, QTY248  NUMERIC (20,10) NULL, QTY249 NUMERIC (20,10) NULL,  QTY250  NUMERIC (20,10) NULL,

                QTY251  NUMERIC (20,10) NULL, QTY252  NUMERIC (20,10) NULL, QTY253  NUMERIC (20,10) NULL, QTY254 NUMERIC (20,10) NULL,  QTY255  NUMERIC (20,10) NULL,
	            QTY256  NUMERIC (20,10) NULL,	QTY257  NUMERIC (20,10) NULL, QTY258  NUMERIC (20,10) NULL, QTY259 NUMERIC (20,10) NULL,  QTY260  NUMERIC (20,10) NULL,
                QTY261  NUMERIC (20,10) NULL, QTY262  NUMERIC (20,10) NULL, QTY263  NUMERIC (20,10) NULL, QTY264 NUMERIC (20,10) NULL,  QTY265  NUMERIC (20,10) NULL,
	            QTY266  NUMERIC (20,10) NULL,	QTY267  NUMERIC (20,10) NULL, QTY268  NUMERIC (20,10) NULL, QTY269 NUMERIC (20,10) NULL,  QTY270  NUMERIC (20,10) NULL,
                QTY271  NUMERIC (20,10) NULL, QTY272  NUMERIC (20,10) NULL, QTY273  NUMERIC (20,10) NULL, QTY274 NUMERIC (20,10) NULL,  QTY275  NUMERIC (20,10) NULL,
	            QTY276  NUMERIC (20,10) NULL,	QTY277  NUMERIC (20,10) NULL, QTY278  NUMERIC (20,10) NULL, QTY279 NUMERIC (20,10) NULL,  QTY280  NUMERIC (20,10) NULL,
                QTY281  NUMERIC (20,10) NULL, QTY282  NUMERIC (20,10) NULL, QTY283  NUMERIC (20,10) NULL, QTY284 NUMERIC (20,10) NULL,  QTY285  NUMERIC (20,10) NULL,
	            QTY286  NUMERIC (20,10) NULL,	QTY287  NUMERIC (20,10) NULL, QTY288  NUMERIC (20,10) NULL, QTY289 NUMERIC (20,10) NULL,  QTY290  NUMERIC (20,10) NULL,
                QTY291  NUMERIC (20,10) NULL, QTY292  NUMERIC (20,10) NULL, QTY293  NUMERIC (20,10) NULL, QTY294 NUMERIC (20,10) NULL,  QTY295  NUMERIC (20,10) NULL,
	            QTY296  NUMERIC (20,10) NULL,	QTY297  NUMERIC (20,10) NULL, QTY298  NUMERIC (20,10) NULL, QTY299 NUMERIC (20,10) NULL,  QTY300  NUMERIC (20,10) NULL,

                QTY301  NUMERIC (20,10) NULL, QTY302  NUMERIC (20,10) NULL, QTY303  NUMERIC (20,10) NULL, QTY304 NUMERIC (20,10) NULL,  QTY305  NUMERIC (20,10) NULL,
	            QTY306  NUMERIC (20,10) NULL,	QTY307  NUMERIC (20,10) NULL, QTY308  NUMERIC (20,10) NULL, QTY309 NUMERIC (20,10) NULL,  QTY310  NUMERIC (20,10) NULL,
	            QTY311  NUMERIC (20,10) NULL, QTY312  NUMERIC (20,10) NULL, QTY313  NUMERIC (20,10) NULL, QTY314 NUMERIC (20,10) NULL,  QTY315  NUMERIC (20,10) NULL,
	            QTY316  NUMERIC (20,10) NULL,	QTY317  NUMERIC (20,10) NULL, QTY318  NUMERIC (20,10) NULL, QTY319 NUMERIC (20,10) NULL,  QTY320  NUMERIC (20,10) NULL,
                QTY321  NUMERIC (20,10) NULL, QTY322  NUMERIC (20,10) NULL, QTY323  NUMERIC (20,10) NULL, QTY324 NUMERIC (20,10) NULL,  QTY325  NUMERIC (20,10) NULL,
	            QTY326  NUMERIC (20,10) NULL,	QTY327  NUMERIC (20,10) NULL, QTY328  NUMERIC (20,10) NULL, QTY329 NUMERIC (20,10) NULL,  QTY330  NUMERIC (20,10) NULL,
                QTY331  NUMERIC (20,10) NULL, QTY332  NUMERIC (20,10) NULL, QTY333  NUMERIC (20,10) NULL, QTY334 NUMERIC (20,10) NULL,  QTY335  NUMERIC (20,10) NULL,
	            QTY336  NUMERIC (20,10) NULL,	QTY337  NUMERIC (20,10) NULL, QTY338  NUMERIC (20,10) NULL, QTY339 NUMERIC (20,10) NULL,  QTY340  NUMERIC (20,10) NULL,
                QTY341  NUMERIC (20,10) NULL, QTY342  NUMERIC (20,10) NULL, QTY343  NUMERIC (20,10) NULL, QTY344 NUMERIC (20,10) NULL,  QTY345  NUMERIC (20,10) NULL,
	            QTY346  NUMERIC (20,10) NULL,	QTY347  NUMERIC (20,10) NULL, QTY348  NUMERIC (20,10) NULL, QTY349 NUMERIC (20,10) NULL,  QTY350  NUMERIC (20,10) NULL,

                QTY351  NUMERIC (20,10) NULL, QTY352  NUMERIC (20,10) NULL, QTY353  NUMERIC (20,10) NULL, QTY354 NUMERIC (20,10) NULL,  QTY355  NUMERIC (20,10) NULL,
	            QTY356  NUMERIC (20,10) NULL,	QTY357  NUMERIC (20,10) NULL, QTY358  NUMERIC (20,10) NULL, QTY359 NUMERIC (20,10) NULL,  QTY360  NUMERIC (20,10) NULL,
                QTY361  NUMERIC (20,10) NULL, QTY362  NUMERIC (20,10) NULL, QTY363  NUMERIC (20,10) NULL, QTY364 NUMERIC (20,10) NULL,
--                CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
                ATTRIBUTE1            NVARCHAR(150) NULL,
                ATTRIBUTE2            NVARCHAR(150) NULL,
                ATTRIBUTE3            NVARCHAR(150) NULL,
                ATTRIBUTE4            NVARCHAR(150) NULL,
                ATTRIBUTE5            NVARCHAR(150) NULL,
                ATTRIBUTE6            NVARCHAR(150) NULL,
                ATTRIBUTE7            NVARCHAR(150) NULL,
                ATTRIBUTE8            NVARCHAR(150) NULL,
                ATTRIBUTE9            NVARCHAR(150) NULL,       -- OPERATION_ID
                ATTRIBUTE10           NVARCHAR(150) NULL
              )  
              

            -------------------------------------------------------------------------------------------------------------       
            --  364일 데이터 생성(PIVOIT 대상 날짜문자열 생성)
            -------------------------------------------------------------------------------------------------------------         
              DECLARE @mQry_sum NVARCHAR(MAX);      
   
		          SET     @mQry_sum = '';
		          SELECT  @mQry_sum = @mQry_sum+','+       
			          CASE  
                      WHEN 1 = 1 THEN  ' SUM(CASE WHEN YYYYMMDD = '''+YYYYMMDD+'''    THEN QTY ELSE 0 END ) AS ' + 'QTY' + REPLICATE('0', 3 - LEN(ROW_NUMBER() OVER(ORDER BY YYYYMMDD) )) + CONVERT(NVARCHAR,ROW_NUMBER() OVER(ORDER BY YYYYMMDD))        
			          END +''+CHAR(10)      
		          FROM (       
			          SELECT A.BASIS_YYYYMMDD                    AS YYYYMMDD    
                      , A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 31) AS SORT_ORDER_NO      
  	  	          FROM DBO.SCM_SYS_CALENDAR_M A  WITH(NOLOCK)	     
	 		           WHERE A.BASIS_YYYYMMDD     >= @p_create_from_yyyymmdd 
                   AND A.BASIS_YYYYMMDD     <=  @p_create_to_yyyymmdd     
			           GROUP BY A.BASIS_YYYYMMDD       
		          ) AS A      
		          ORDER BY SORT_ORDER_NO  ;       


            -------------------------------------------------------------------------------------------------------------         
            -- 전체 DATA 생성 (#PSI_GLOBAL_AUTO --> #SCP_XLS_PSI_GLOBAL_AUTO) PIVOT
            -------------------------------------------------------------------------------------------------------------
              DECLARE @mEXEC NVARCHAR(MAX);

		          SET @mEXEC = '';
              SET @mEXEC = @mEXEC + ' INSERT INTO #SCP_XLS_PSI_GLOBAL_AUTO WITH (TABLOCK)  '+CHAR(10);	

		          SET @mEXEC = @mEXEC + ' SELECT A.DIVISION_ID														
                                            , ''' + @p_plan_start_yyyymmdd +'''	  AS PLAN_START_YYYYMMDD
                                            , ''' + @p_plan_type +'''	            AS PLAN_TYPE
                                            , ''' + @p_seq +'''	                  AS SEQ
                              		          , A.OPERATION_GROUP						
                              		          , (SELECT TOP 1 SEGMENT2 NAME FROM SCM_ADM_LOOKUP_MASTER_DETAIL X WITH (NOLOCK) WHERE X.LOOKUP_TYPE = ''OPERATION_GROUP'' AND X.SEGMENT1 = A.OPERATION_GROUP ) AS OPERATION_GROUP_NAME    
                              		          , A.CELL_ITEM_ID				
                              		          , A.ITEM_ID							
                              		          , (SELECT TOP 1 (CASE WHEN X.NICK_NAME IS NULL THEN ''-''  WHEN X.NICK_NAME = ''''    THEN ''-''  ELSE X.NICK_NAME END) FROM DBO.SCM_MST_ITEM_SN X WITH (NOLOCK)  WHERE  X.ITEM_ID  = A.ITEM_ID AND X.NICK_NAME IS NOT NULL) AS NICK_NAME	
                              		          , 0 AS CELL_QTY_PACK									
                              		          , A.TO_SITE							
                              		          , ISNULL(NULLIF( (SELECT TOP 1 M.SITE_DESCRIPTION FROM SCM_MST_SITE M  WITH (NOLOCK) WHERE M.SCM_SITE_ID=A.TO_SITE), '''') , ''-'') AS TO_SITE_DESCRIPTION	
                                            , A.PROJECT_CODE		
                              		          , A.FROM_BOH_QTY												
                              		          , A.TO_BOH_QTY													
                              		          , ISNULL(NULLIF( A.INCOTERMS, '''') , ''-'') AS INCOTERMS	
                              		          , A.FROM_SITE								
                              		          , ISNULL(NULLIF( (SELECT TOP 1 M.SITE_DESCRIPTION FROM SCM_MST_SITE M  WITH (NOLOCK) WHERE M.SCM_SITE_ID=A.FROM_SITE), '''') , ''-'') AS FROM_SITE_DESCRIPTION	
                                            , ISNULL(A.TRANSPORT_MODE,''-'') AS   TRANSPORT_MODE 
                                            , ISNULL(A.PROD_LINE,''-'')  AS      PROD_LINE   
                              		          , (CASE WHEN A.BOD_ID=''-'' THEN ''-'' ELSE CONVERT(NVARCHAR(50), (B.LT_TOTAL_BY_WEEK)) END)  AS LT_DAY
                                            , A.BOD_ID			
                       		                  , A.MEASURE
                                            , A.COLUMN_LABEL_NAME           AS MEASURE_LABEL '+CHAR(10);	
              SET @mEXEC = @mEXEC + ' 		  , CONVERT(NVARCHAR(200), NULL)  AS XLS_KEY1
                                            , CONVERT(NVARCHAR(200), NULL)  AS XLS_KEY2
                                            , CONVERT(NVARCHAR(200), NULL)  AS XLS_KEY3
                                            , CONVERT(NVARCHAR(200), NULL)  AS XLS_KEY4
                                            , CONVERT(NVARCHAR(200), NULL)  AS XLS_KEY5
                                            , CONVERT(NVARCHAR(200), NULL)  AS XLS_ATTRIBUTE1
                                            , CONVERT(NVARCHAR(200), NULL)  AS XLS_ATTRIBUTE2
                                            , CONVERT(NVARCHAR(200), NULL)  AS XLS_ATTRIBUTE3
                                            , CONVERT(NVARCHAR(200), NULL)  AS XLS_ATTRIBUTE4
                                            , CONVERT(NVARCHAR(200), NULL)  AS XLS_ATTRIBUTE5
                                            , A.SORT_ORDER_NO									'+CHAR(10);	
		          SET @mEXEC = @mEXEC + ' 				' + @mQry_sum +'									'+CHAR(10);	
		          SET @mEXEC = @mEXEC + '       , A.ATTRIBUTE1'+CHAR(10);	
              SET @mEXEC = @mEXEC + '       , NULL AS ATTRIBUTE2, NULL AS ATTRIBUTE3, NULL AS ATTRIBUTE4, NULL AS ATTRIBUTE5, NULL AS ATTRIBUTE6, NULL AS ATTRIBUTE7, NULL AS ATTRIBUTE8'+CHAR(10);	
              SET @mEXEC = @mEXEC + '       , A.ATTRIBUTE9, NULL AS ATTRIBUTE10		'+CHAR(10);	
  	          SET @mEXEC = @mEXEC + ' 		FROM #PSI_GLOBAL_AUTO A WITH (NOLOCK)	'+CHAR(10);		
	          SET @mEXEC = @mEXEC + '       LEFT OUTER JOIN #SCP_MST_BOD_V B WITH (NOLOCK)	'+CHAR(10);
	          SET @mEXEC = @mEXEC + '         ON 0 = 0	'+CHAR(10);
	          SET @mEXEC = @mEXEC + '        AND B.DIVISION_ID = A.DIVISION_ID 	'+CHAR(10);
	          SET @mEXEC = @mEXEC + '        AND B.BOD_ID      = A.BOD_ID		'+CHAR(10);
	          SET @mEXEC = @mEXEC + '        AND B.FROM_SITE   = A.FROM_SITE	'+CHAR(10);
              SET @mEXEC = @mEXEC + '        AND B.TO_SITE     = A.TO_SITE		'+CHAR(10);
              SET @mEXEC = @mEXEC + '        AND B.INCOTERMS   = A.INCOTERMS	'+CHAR(10);
			  SET @mEXEC = @mEXEC + '	     AND A.YYYYMMDD    >= ''' + @p_create_from_yyyymmdd + ''''+CHAR(10);
			  SET @mEXEC = @mEXEC + '	     AND A.YYYYMMDD    <= ''' + @p_create_to_yyyymmdd   + ''''+CHAR(10);

			  -- 튜닝 - start
			  --SET @mEXEC = @mEXEC + '	   WHERE A.YYYYMMDD    = ''' + @p_create_from_yyyymmdd  + ''''+CHAR(10);		-- 52 구간별 처리
			  SET @mEXEC = @mEXEC + '	   WHERE A.YYYYMMDD BETWEEN ''' + @p_create_from_yyyymmdd  + ''' AND ''' + @p_create_to_yyyymmdd + ''''+CHAR(10);		-- 52 구간별 처리
			  --SET @mEXEC = @mEXEC + '	      OR A.QTY         <> 0 '+CHAR(10);
			  -- 튜닝 - end
	          SET @mEXEC = @mEXEC + '      GROUP BY  A.DIVISION_ID							
	                            			              , A.OPERATION_GROUP							
	                      			                    , A.CELL_ITEM_ID								
	                            			              , A.ITEM_ID											
	                            			              , A.TO_SITE			
                                                  , A.PROJECT_CODE
	                            			              , A.TO_BOH_QTY									
	                            			              , A.FROM_BOH_QTY								
	                            			              , A.INCOTERMS									
	                            			              , A.FROM_SITE									
                                                  , ISNULL(A.TRANSPORT_MODE,''-'')
                                                  , ISNULL(A.PROD_LINE,''-'') 
	                            			              , A.BOD_ID										
	                            			              , A.MEASURE										
	                            			              , A.SORT_ORDER_NO							
	                            			              , A.COLUMN_LABEL_NAME			
                              			              , (CASE WHEN A.BOD_ID=''-'' THEN ''-'' ELSE CONVERT(NVARCHAR(50), (B.LT_TOTAL_BY_WEEK)) END)  
                                                  , A.ATTRIBUTE1
                                                  --, A.ATTRIBUTE2
                                                  --, A.ATTRIBUTE3
                                                  --, A.ATTRIBUTE4
                                                  --, A.ATTRIBUTE5
                                                  --, A.ATTRIBUTE6
                                                  --, A.ATTRIBUTE7
                                                  --, A.ATTRIBUTE8
                                                    , A.ATTRIBUTE9
                                                  --, A.ATTRIBUTE10  
                                                  '+CHAR(10);

            EXEC sp_executesql @mEXEC;
        
        /*
            DECLARE @POS int
            DECLARE @LEN NVARCHAR(max)
				    SET @POS =1;
				    SET @LEN =LEN(@mEXEC);
				    WHILE @POS <= @LEN
					    BEGIN
						    PRINT SUBSTRING(@mEXEC,@POS,4000);
						    SET @POS = @POS+4000;
					    END;
          */                  
		     

            -------------------------------------------------------------------------------------------------------------         
            -- TRANSPORT_MODE 추가
            -------------------------------------------------------------------------------------------------------------
            -- 'SHIP_PLAN'의 TRANSPORT_MODE 종류 별 추가 

            IF OBJECT_ID('tempdb..#TRANSPORT_MODE') IS NOT NULL      
	                DROP TABLE #TRANSPORT_MODE;

                SELECT DISTINCT X.DIVISION_ID,X.FROM_SITE,X.TO_SITE,X.INCOTERMS,X.TRANSPORT_MODE,X.LT_TOTAL, X.BOD_ID,Y.PROJECT_CODE , X.LT_TOTAL_BY_WEEK
                INTO #TRANSPORT_MODE
                FROM #SCP_MST_BOD_V X
                LEFT OUTER JOIN #SCP_XLS_PSI_GLOBAL_AUTO Y
                ON X.DIVISION_ID  = Y.DIVISION_ID
                AND X.FROM_SITE   = Y.FROM_SITE
                AND X.TO_SITE     = Y.TO_SITE
                AND X.INCOTERMS   = Y.INCOTERMS
				AND X.BOD_ID	  = Y.BOD_ID	-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 BOD_ID 추가
                AND Y.PROJECT_CODE <> '-'
--                WHERE ISNULL(Y.PROJECT_CODE ,'') <> ''



            INSERT #SCP_XLS_PSI_GLOBAL_AUTO
            SELECT DIVISION_ID
                      ,PLAN_START_YYYYMMDD
                      ,PLAN_TYPE
                      ,SEQ
                      ,OPERATION_GROUP
                      ,OPERATION_GROUP_NAME
                      ,CELL_ITEM_ID
                      ,ITEM_ID
                      ,NICK_NAME
                      ,CELL_QTY_PACK
                      ,TO_SITE
                      ,TO_SITE_DESCRIPTION
                      ,PROJECT_CODE
                      ,FROM_BOH_QTY
                      ,TO_BOH_QTY
                      ,INCOTERMS
                      ,FROM_SITE
                      ,FROM_SITE_DESCRIPTION
                      ,TRANSPORT_MODE
                      ,PROD_LINE
                      ,LT_DAY
                      ,BOD_ID
                      ,MEASURE
                      ,MEASURE_LABEL
                      ,XLS_KEY1
                      ,XLS_KEY2
                      ,XLS_KEY3
                      ,XLS_KEY4
                      ,XLS_KEY5
                      ,XLS_ATTRIBUTE1
                      ,XLS_ATTRIBUTE2
                      ,XLS_ATTRIBUTE3
                      ,XLS_ATTRIBUTE4
                      ,XLS_ATTRIBUTE5
                      ,SORT_ORDER_NO
                      ,0  AS QTY001 ,0  AS QTY002,0  AS QTY003,0  AS QTY004,0  AS QTY005,0  AS QTY006 ,0  AS QTY007,0  AS QTY008,0  AS QTY009,0  AS QTY010
                      ,0  AS QTY011 ,0  AS QTY012,0  AS QTY013,0  AS QTY014,0  AS QTY015,0  AS QTY016 ,0  AS QTY017,0  AS QTY018,0  AS QTY019,0  AS QTY020
                      ,0  AS QTY021 ,0  AS QTY022,0  AS QTY023,0  AS QTY024,0  AS QTY025,0  AS QTY026 ,0  AS QTY027,0  AS QTY028,0  AS QTY029,0  AS QTY030
                      ,0  AS QTY031 ,0  AS QTY032,0  AS QTY033,0  AS QTY034,0  AS QTY035,0  AS QTY036 ,0  AS QTY037,0  AS QTY038,0  AS QTY039,0  AS QTY040
                      ,0  AS QTY041 ,0  AS QTY042,0  AS QTY043,0  AS QTY044,0  AS QTY045,0  AS QTY046 ,0  AS QTY047,0  AS QTY048,0  AS QTY049,0  AS QTY050
                      ,0  AS QTY051 ,0  AS QTY052,0  AS QTY053,0  AS QTY054,0  AS QTY055,0  AS QTY056 ,0  AS QTY057,0  AS QTY058,0  AS QTY059,0  AS QTY060
                      ,0  AS QTY061 ,0  AS QTY062,0  AS QTY063,0  AS QTY064,0  AS QTY065,0  AS QTY066 ,0  AS QTY067,0  AS QTY068,0  AS QTY069,0  AS QTY070
                      ,0  AS QTY071 ,0  AS QTY072,0  AS QTY073,0  AS QTY074,0  AS QTY075,0  AS QTY076 ,0  AS QTY077,0  AS QTY078,0  AS QTY079,0  AS QTY080
                      ,0  AS QTY081 ,0  AS QTY082,0  AS QTY083,0  AS QTY084,0  AS QTY085,0  AS QTY086 ,0  AS QTY087,0  AS QTY088,0  AS QTY089,0  AS QTY090
                      ,0  AS QTY091 ,0  AS QTY092,0  AS QTY093,0  AS QTY094,0  AS QTY095,0  AS QTY096 ,0  AS QTY097,0  AS QTY098,0  AS QTY099,0  AS QTY100

                      ,0  AS QTY101 ,0  AS QTY102,0  AS QTY103,0  AS QTY104,0  AS QTY105,0  AS QTY106 ,0  AS QTY107,0  AS QTY108,0  AS QTY109,0  AS QTY110
                      ,0  AS QTY111 ,0  AS QTY112,0  AS QTY113,0  AS QTY114,0  AS QTY115,0  AS QTY116 ,0  AS QTY117,0  AS QTY118,0  AS QTY119,0  AS QTY120
                      ,0  AS QTY121 ,0  AS QTY122,0  AS QTY123,0  AS QTY124,0  AS QTY125,0  AS QTY126 ,0  AS QTY127,0  AS QTY128,0  AS QTY129,0  AS QTY130
                      ,0  AS QTY131 ,0  AS QTY132,0  AS QTY133,0  AS QTY134,0  AS QTY135,0  AS QTY136 ,0  AS QTY137,0  AS QTY138,0  AS QTY139,0  AS QTY140
                      ,0  AS QTY141 ,0  AS QTY142,0  AS QTY143,0  AS QTY144,0  AS QTY145,0  AS QTY146 ,0  AS QTY147,0  AS QTY148,0  AS QTY149,0  AS QTY150
                      ,0  AS QTY151 ,0  AS QTY152,0  AS QTY153,0  AS QTY154,0  AS QTY155,0  AS QTY156 ,0  AS QTY157,0  AS QTY158,0  AS QTY159,0  AS QTY160
                      ,0  AS QTY161 ,0  AS QTY162,0  AS QTY163,0  AS QTY164,0  AS QTY165,0  AS QTY166 ,0  AS QTY167,0  AS QTY168,0  AS QTY169,0  AS QTY170
                      ,0  AS QTY171 ,0  AS QTY172,0  AS QTY173,0  AS QTY174,0  AS QTY175,0  AS QTY176 ,0  AS QTY177,0  AS QTY178,0  AS QTY179,0  AS QTY180
                      ,0  AS QTY181 ,0  AS QTY182,0  AS QTY183,0  AS QTY184,0  AS QTY185,0  AS QTY186 ,0  AS QTY187,0  AS QTY188,0  AS QTY189,0  AS QTY190
                      ,0  AS QTY191 ,0  AS QTY192,0  AS QTY193,0  AS QTY194,0  AS QTY195,0  AS QTY196 ,0  AS QTY197,0  AS QTY198,0  AS QTY199,0  AS QTY200

                      ,0  AS QTY201 ,0  AS QTY202,0  AS QTY203,0  AS QTY204,0  AS QTY205,0  AS QTY206 ,0  AS QTY207,0  AS QTY208,0  AS QTY209,0  AS QTY210
                      ,0  AS QTY211 ,0  AS QTY212,0  AS QTY213,0  AS QTY214,0  AS QTY215,0  AS QTY216 ,0  AS QTY217,0  AS QTY218,0  AS QTY219,0  AS QTY220
                      ,0  AS QTY221 ,0  AS QTY222,0  AS QTY223,0  AS QTY224,0  AS QTY225,0  AS QTY226 ,0  AS QTY227,0  AS QTY228,0  AS QTY229,0  AS QTY230
                      ,0  AS QTY231 ,0  AS QTY232,0  AS QTY233,0  AS QTY234,0  AS QTY235,0  AS QTY236 ,0  AS QTY237,0  AS QTY238,0  AS QTY239,0  AS QTY240
                      ,0  AS QTY241 ,0  AS QTY242,0  AS QTY243,0  AS QTY244,0  AS QTY245,0  AS QTY246 ,0  AS QTY247,0  AS QTY248,0  AS QTY249,0  AS QTY250
                      ,0  AS QTY251 ,0  AS QTY252,0  AS QTY253,0  AS QTY254,0  AS QTY255,0  AS QTY256 ,0  AS QTY257,0  AS QTY258,0  AS QTY259,0  AS QTY260
                      ,0  AS QTY261 ,0  AS QTY262,0  AS QTY263,0  AS QTY264,0  AS QTY265,0  AS QTY266 ,0  AS QTY267,0  AS QTY268,0  AS QTY269,0  AS QTY270
                      ,0  AS QTY271 ,0  AS QTY272,0  AS QTY273,0  AS QTY274,0  AS QTY275,0  AS QTY276 ,0  AS QTY277,0  AS QTY278,0  AS QTY279,0  AS QTY280
                      ,0  AS QTY281 ,0  AS QTY282,0  AS QTY283,0  AS QTY284,0  AS QTY285,0  AS QTY286 ,0  AS QTY287,0  AS QTY288,0  AS QTY289,0  AS QTY290
                      ,0  AS QTY291 ,0  AS QTY292,0  AS QTY293,0  AS QTY294,0  AS QTY295,0  AS QTY296 ,0  AS QTY297,0  AS QTY298,0  AS QTY299,0  AS QTY300

                      ,0  AS QTY301 ,0  AS QTY302,0  AS QTY303,0  AS QTY304,0  AS QTY305,0  AS QTY306 ,0  AS QTY307,0  AS QTY308,0  AS QTY309,0  AS QTY310
                      ,0  AS QTY311 ,0  AS QTY312,0  AS QTY313,0  AS QTY314,0  AS QTY315,0  AS QTY316 ,0  AS QTY317,0  AS QTY318,0  AS QTY319,0  AS QTY320
                      ,0  AS QTY321 ,0  AS QTY322,0  AS QTY323,0  AS QTY324,0  AS QTY325,0  AS QTY326 ,0  AS QTY327,0  AS QTY328,0  AS QTY329,0  AS QTY330
                      ,0  AS QTY331 ,0  AS QTY332,0  AS QTY333,0  AS QTY334,0  AS QTY335,0  AS QTY336 ,0  AS QTY337,0  AS QTY338,0  AS QTY339,0  AS QTY340
                      ,0  AS QTY341 ,0  AS QTY342,0  AS QTY343,0  AS QTY344,0  AS QTY345,0  AS QTY346 ,0  AS QTY347,0  AS QTY348,0  AS QTY349,0  AS QTY350
                      ,0  AS QTY351 ,0  AS QTY352,0  AS QTY353,0  AS QTY354,0  AS QTY355,0  AS QTY356 ,0  AS QTY357,0  AS QTY358,0  AS QTY359,0  AS QTY360
                      ,0  AS QTY361 ,0  AS QTY362,0  AS QTY363,0  AS QTY364                  
                      --,X.CREATED_BY
                      --,X.CREATION_DATE
                      --,X.LAST_UPDATED_BY
                      --,X.LAST_UPDATE_DATE
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
                     FROM                 
                         (                
                              
                            SELECT DISTINCT  X.DIVISION_ID
                                  ,PLAN_START_YYYYMMDD
                                  ,PLAN_TYPE
                                  ,SEQ
                                  ,OPERATION_GROUP
                                  ,OPERATION_GROUP_NAME
                                  ,CELL_ITEM_ID
                                  ,ITEM_ID
                                  ,NICK_NAME
                                  ,CELL_QTY_PACK
                                  ,X.TO_SITE
                                  ,TO_SITE_DESCRIPTION
                                  ,X.PROJECT_CODE
                                  ,FROM_BOH_QTY
                                  ,TO_BOH_QTY
                                  ,X.INCOTERMS
                                  ,X.FROM_SITE
                                  ,FROM_SITE_DESCRIPTION
                                  ,Y.TRANSPORT_MODE
                                  ,PROD_LINE
                                  ,Y.LT_TOTAL_BY_WEEK AS LT_DAY
                                  ,Y.BOD_ID
                                  ,MEASURE
                                  ,MEASURE_LABEL
                                  ,XLS_KEY1
                                  ,XLS_KEY2
                                  ,XLS_KEY3
                                  ,XLS_KEY4
                                  ,XLS_KEY5
                                  ,XLS_ATTRIBUTE1
                                  ,XLS_ATTRIBUTE2
                                  ,XLS_ATTRIBUTE3
                                  ,XLS_ATTRIBUTE4
                                  ,XLS_ATTRIBUTE5
                                  ,SORT_ORDER_NO
                                  --,X.CREATED_BY
                                  --,X.CREATION_DATE
                                  --,X.LAST_UPDATED_BY
                                  --,X.LAST_UPDATE_DATE
                                  ,X.ATTRIBUTE1
                                  ,X.ATTRIBUTE2
                                  ,X.ATTRIBUTE3
                                  ,X.ATTRIBUTE4
                                  ,X.ATTRIBUTE5
                                  ,X.ATTRIBUTE6
                                  ,X.ATTRIBUTE7
                                  ,X.ATTRIBUTE8
                                  ,X.ATTRIBUTE9
                                  ,X.ATTRIBUTE10
                                FROM #SCP_XLS_PSI_GLOBAL_AUTO X WITH(NOLOCK)     
                                LEFT OUTER JOIN #TRANSPORT_MODE Y WITH (NOLOCK) 
                                  ON 0 = 0
                                AND X.DIVISION_ID     = Y.DIVISION_ID
                                AND X.FROM_SITE       = Y.FROM_SITE
                                AND X.TO_SITE         = Y.TO_SITE
                                AND X.INCOTERMS       = Y.INCOTERMS
                                AND X.PROJECT_CODE    = Y.PROJECT_CODE
								AND X.BOD_ID          = Y.BOD_ID		-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 BOD_ID 추가
                                AND X.MEASURE         = 'SHIP_PLAN'
--                                AND X.TRANSPORT_MODE  <> Y.TRANSPORT_MODE  
                         ) SUB                
                         WHERE 1=1                
                           AND NOT EXISTS (                
                                            SELECT 'X'                
                                              FROM #SCP_XLS_PSI_GLOBAL_AUTO Z WITH(NOLOCK)                
                                             WHERE 1=1                
                                               AND Z.DIVISION_ID          = SUB.DIVISION_ID                
                                               AND Z.OPERATION_GROUP      = SUB.OPERATION_GROUP                
                                               AND Z.CELL_ITEM_ID         = SUB.CELL_ITEM_ID                
                                               AND Z.ITEM_ID              = SUB.ITEM_ID              
                                               AND Z.PROJECT_CODE         = SUB.PROJECT_CODE
                                               AND Z.TO_SITE              = SUB.TO_SITE                
                                               AND Z.INCOTERMS            = SUB.INCOTERMS                
                                               AND Z.FROM_SITE            = SUB.FROM_SITE                
                                               AND Z.TRANSPORT_MODE       = SUB.TRANSPORT_MODE          
                                               AND Z.MEASURE              = SUB.MEASURE 
                                               AND Z.MEASURE              ='SHIP_PLAN'
                                               AND Z.BOD_ID               = SUB.BOD_ID      
                                               AND Z.ATTRIBUTE1						=	SUB.ATTRIBUTE1					
--			                                         AND Z.ATTRIBUTE9						=	SUB.ATTRIBUTE9					
                                          )      
                  AND SUB.MEASURE              ='SHIP_PLAN'
                  AND SUB.TRANSPORT_MODE  IS NOT NULL




                  INSERT #SCP_XLS_PSI_GLOBAL_AUTO
                SELECT DIVISION_ID
                          ,PLAN_START_YYYYMMDD
                          ,PLAN_TYPE
                          ,SEQ
                          ,OPERATION_GROUP
                          ,OPERATION_GROUP_NAME
                          ,CELL_ITEM_ID
                          ,ITEM_ID
                          ,NICK_NAME
                          ,CELL_QTY_PACK
                          ,TO_SITE
                          ,TO_SITE_DESCRIPTION
                          ,PROJECT_CODE
                          ,FROM_BOH_QTY
                          ,TO_BOH_QTY
                          ,INCOTERMS
                          ,FROM_SITE
                          ,FROM_SITE_DESCRIPTION
                          ,TRANSPORT_MODE
                          ,PROD_LINE
                          ,LT_DAY
                          ,BOD_ID
                          ,MEASURE
                          ,MEASURE_LABEL
                          ,XLS_KEY1
                          ,XLS_KEY2
                          ,XLS_KEY3
                          ,XLS_KEY4
                          ,XLS_KEY5
                          ,XLS_ATTRIBUTE1
                          ,XLS_ATTRIBUTE2
                          ,XLS_ATTRIBUTE3
                          ,XLS_ATTRIBUTE4
                          ,XLS_ATTRIBUTE5
                          ,SORT_ORDER_NO
                          ,0  AS QTY001 ,0  AS QTY002,0  AS QTY003,0  AS QTY004,0  AS QTY005,0  AS QTY006 ,0  AS QTY007,0  AS QTY008,0  AS QTY009,0  AS QTY010
                          ,0  AS QTY011 ,0  AS QTY012,0  AS QTY013,0  AS QTY014,0  AS QTY015,0  AS QTY016 ,0  AS QTY017,0  AS QTY018,0  AS QTY019,0  AS QTY020
                          ,0  AS QTY021 ,0  AS QTY022,0  AS QTY023,0  AS QTY024,0  AS QTY025,0  AS QTY026 ,0  AS QTY027,0  AS QTY028,0  AS QTY029,0  AS QTY030
                          ,0  AS QTY031 ,0  AS QTY032,0  AS QTY033,0  AS QTY034,0  AS QTY035,0  AS QTY036 ,0  AS QTY037,0  AS QTY038,0  AS QTY039,0  AS QTY040
                          ,0  AS QTY041 ,0  AS QTY042,0  AS QTY043,0  AS QTY044,0  AS QTY045,0  AS QTY046 ,0  AS QTY047,0  AS QTY048,0  AS QTY049,0  AS QTY050
                          ,0  AS QTY051 ,0  AS QTY052,0  AS QTY053,0  AS QTY054,0  AS QTY055,0  AS QTY056 ,0  AS QTY057,0  AS QTY058,0  AS QTY059,0  AS QTY060
                          ,0  AS QTY061 ,0  AS QTY062,0  AS QTY063,0  AS QTY064,0  AS QTY065,0  AS QTY066 ,0  AS QTY067,0  AS QTY068,0  AS QTY069,0  AS QTY070
                          ,0  AS QTY071 ,0  AS QTY072,0  AS QTY073,0  AS QTY074,0  AS QTY075,0  AS QTY076 ,0  AS QTY077,0  AS QTY078,0  AS QTY079,0  AS QTY080
                          ,0  AS QTY081 ,0  AS QTY082,0  AS QTY083,0  AS QTY084,0  AS QTY085,0  AS QTY086 ,0  AS QTY087,0  AS QTY088,0  AS QTY089,0  AS QTY090
                          ,0  AS QTY091 ,0  AS QTY092,0  AS QTY093,0  AS QTY094,0  AS QTY095,0  AS QTY096 ,0  AS QTY097,0  AS QTY098,0  AS QTY099,0  AS QTY100

                          ,0  AS QTY101 ,0  AS QTY102,0  AS QTY103,0  AS QTY104,0  AS QTY105,0  AS QTY106 ,0  AS QTY107,0  AS QTY108,0  AS QTY109,0  AS QTY110
                          ,0  AS QTY111 ,0  AS QTY112,0  AS QTY113,0  AS QTY114,0  AS QTY115,0  AS QTY116 ,0  AS QTY117,0  AS QTY118,0  AS QTY119,0  AS QTY120
                          ,0  AS QTY121 ,0  AS QTY122,0  AS QTY123,0  AS QTY124,0  AS QTY125,0  AS QTY126 ,0  AS QTY127,0  AS QTY128,0  AS QTY129,0  AS QTY130
                          ,0  AS QTY131 ,0  AS QTY132,0  AS QTY133,0  AS QTY134,0  AS QTY135,0  AS QTY136 ,0  AS QTY137,0  AS QTY138,0  AS QTY139,0  AS QTY140
                          ,0  AS QTY141 ,0  AS QTY142,0  AS QTY143,0  AS QTY144,0  AS QTY145,0  AS QTY146 ,0  AS QTY147,0  AS QTY148,0  AS QTY149,0  AS QTY150
                          ,0  AS QTY151 ,0  AS QTY152,0  AS QTY153,0  AS QTY154,0  AS QTY155,0  AS QTY156 ,0  AS QTY157,0  AS QTY158,0  AS QTY159,0  AS QTY160
                          ,0  AS QTY161 ,0  AS QTY162,0  AS QTY163,0  AS QTY164,0  AS QTY165,0  AS QTY166 ,0  AS QTY167,0  AS QTY168,0  AS QTY169,0  AS QTY170
                          ,0  AS QTY171 ,0  AS QTY172,0  AS QTY173,0  AS QTY174,0  AS QTY175,0  AS QTY176 ,0  AS QTY177,0  AS QTY178,0  AS QTY179,0  AS QTY180
                          ,0  AS QTY181 ,0  AS QTY182,0  AS QTY183,0  AS QTY184,0  AS QTY185,0  AS QTY186 ,0  AS QTY187,0  AS QTY188,0  AS QTY189,0  AS QTY190
                          ,0  AS QTY191 ,0  AS QTY192,0  AS QTY193,0  AS QTY194,0  AS QTY195,0  AS QTY196 ,0  AS QTY197,0  AS QTY198,0  AS QTY199,0  AS QTY200

                          ,0  AS QTY201 ,0  AS QTY202,0  AS QTY203,0  AS QTY204,0  AS QTY205,0  AS QTY206 ,0  AS QTY207,0  AS QTY208,0  AS QTY209,0  AS QTY210
                          ,0  AS QTY211 ,0  AS QTY212,0  AS QTY213,0  AS QTY214,0  AS QTY215,0  AS QTY216 ,0  AS QTY217,0  AS QTY218,0  AS QTY219,0  AS QTY220
                          ,0  AS QTY221 ,0  AS QTY222,0  AS QTY223,0  AS QTY224,0  AS QTY225,0  AS QTY226 ,0  AS QTY227,0  AS QTY228,0  AS QTY229,0  AS QTY230
                          ,0  AS QTY231 ,0  AS QTY232,0  AS QTY233,0  AS QTY234,0  AS QTY235,0  AS QTY236 ,0  AS QTY237,0  AS QTY238,0  AS QTY239,0  AS QTY240
                          ,0  AS QTY241 ,0  AS QTY242,0  AS QTY243,0  AS QTY244,0  AS QTY245,0  AS QTY246 ,0  AS QTY247,0  AS QTY248,0  AS QTY249,0  AS QTY250
                          ,0 AS QTY251 ,0  AS QTY252,0  AS QTY253,0  AS QTY254,0  AS QTY255,0  AS QTY256 ,0  AS QTY257,0  AS QTY258,0  AS QTY259,0  AS QTY260
                          ,0  AS QTY261 ,0  AS QTY262,0  AS QTY263,0  AS QTY264,0  AS QTY265,0  AS QTY266 ,0  AS QTY267,0  AS QTY268,0  AS QTY269,0  AS QTY270
                          ,0  AS QTY271 ,0  AS QTY272,0  AS QTY273,0  AS QTY274,0  AS QTY275,0  AS QTY276 ,0  AS QTY277,0  AS QTY278,0  AS QTY279,0  AS QTY280
                          ,0  AS QTY281 ,0  AS QTY282,0  AS QTY283,0  AS QTY284,0  AS QTY285,0  AS QTY286 ,0  AS QTY287,0  AS QTY288,0  AS QTY289,0  AS QTY290
                          ,0  AS QTY291 ,0  AS QTY292,0  AS QTY293,0  AS QTY294,0  AS QTY295,0  AS QTY296 ,0  AS QTY297,0  AS QTY298,0  AS QTY299,0  AS QTY300

                          ,0  AS QTY301 ,0  AS QTY302,0  AS QTY303,0  AS QTY304,0  AS QTY305,0  AS QTY306 ,0  AS QTY307,0  AS QTY308,0  AS QTY309,0  AS QTY310
                          ,0  AS QTY311 ,0  AS QTY312,0  AS QTY313,0  AS QTY314,0  AS QTY315,0  AS QTY316 ,0  AS QTY317,0  AS QTY318,0  AS QTY319,0  AS QTY320
                          ,0  AS QTY321 ,0  AS QTY322,0  AS QTY323,0  AS QTY324,0  AS QTY325,0  AS QTY326 ,0  AS QTY327,0  AS QTY328,0  AS QTY329,0  AS QTY330
                          ,0  AS QTY331 ,0  AS QTY332,0  AS QTY333,0  AS QTY334,0  AS QTY335,0  AS QTY336 ,0  AS QTY337,0  AS QTY338,0  AS QTY339,0  AS QTY340
                          ,0  AS QTY341 ,0  AS QTY342,0  AS QTY343,0  AS QTY344,0  AS QTY345,0  AS QTY346 ,0  AS QTY347,0  AS QTY348,0  AS QTY349,0  AS QTY350
                          ,0  AS QTY351 ,0  AS QTY352,0  AS QTY353,0  AS QTY354,0  AS QTY355,0  AS QTY356 ,0  AS QTY357,0  AS QTY358,0  AS QTY359,0  AS QTY360
                          ,0  AS QTY361 ,0  AS QTY362,0  AS QTY363,0  AS QTY364                  
                          --,X.CREATED_BY
                          --,X.CREATION_DATE
                          --,X.LAST_UPDATED_BY
                          --,X.LAST_UPDATE_DATE
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
                         FROM                 
                             (                
                              
                                SELECT DISTINCT  X.DIVISION_ID
                                      ,PLAN_START_YYYYMMDD
                                      ,PLAN_TYPE
                                      ,SEQ
                                      ,OPERATION_GROUP
                                      ,OPERATION_GROUP_NAME
                                      ,CELL_ITEM_ID
                                      ,ITEM_ID
                                      ,NICK_NAME
                                      ,CELL_QTY_PACK
                                      ,X.TO_SITE
                                      ,TO_SITE_DESCRIPTION
                                      ,X.PROJECT_CODE
                                      ,FROM_BOH_QTY
                                      ,TO_BOH_QTY
                                      ,X.INCOTERMS
                                      ,X.FROM_SITE
                                      ,FROM_SITE_DESCRIPTION
                                      ,Y.TRANSPORT_MODE
                                      ,PROD_LINE
                                      ,Y.LT_TOTAL_BY_WEEK AS LT_DAY
                                      ,Y.BOD_ID
                                      ,MEASURE
                                      ,MEASURE_LABEL
                                      ,XLS_KEY1
                                      ,XLS_KEY2
                                      ,XLS_KEY3
                                      ,XLS_KEY4
                                      ,XLS_KEY5
                                      ,XLS_ATTRIBUTE1
                                      ,XLS_ATTRIBUTE2
                                      ,XLS_ATTRIBUTE3
                                      ,XLS_ATTRIBUTE4
                                      ,XLS_ATTRIBUTE5
                                      ,SORT_ORDER_NO
                                      --,X.CREATED_BY
                                      --,X.CREATION_DATE
                                      --,X.LAST_UPDATED_BY
                                      --,X.LAST_UPDATE_DATE
                                      ,X.ATTRIBUTE1
                                      ,X.ATTRIBUTE2
                                      ,X.ATTRIBUTE3
                                      ,X.ATTRIBUTE4
                                      ,X.ATTRIBUTE5
                                      ,X.ATTRIBUTE6
                                      ,X.ATTRIBUTE7
                                      ,X.ATTRIBUTE8
                                      ,X.ATTRIBUTE9
                                      ,X.ATTRIBUTE10
                                    FROM #SCP_XLS_PSI_GLOBAL_AUTO X WITH(NOLOCK)     
                                    LEFT OUTER JOIN #TRANSPORT_MODE Y WITH (NOLOCK) 
                                    ON 0 = 0
                                    AND X.DIVISION_ID     = Y.DIVISION_ID
                                    AND X.FROM_SITE       = Y.FROM_SITE
                                    AND X.TO_SITE         = Y.TO_SITE
--                                    AND X.INCOTERMS       = Y.INCOTERMS
                                    AND X.PROJECT_CODE    =  ISNULL(Y.PROJECT_CODE,'-')
									AND X.BOD_ID          = Y.BOD_ID						-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 BOD_ID 추가
                                    AND X.MEASURE         = 'SEMI_SHIP_PLAN'
    --                                AND X.TRANSPORT_MODE  <> Y.TRANSPORT_MODE  
                             ) SUB                
                             WHERE 1=1                
                               AND NOT EXISTS (                
                                                SELECT 'X'                
                                                  FROM #SCP_XLS_PSI_GLOBAL_AUTO Z WITH(NOLOCK)                
                                                 WHERE 1=1                
                                                   AND Z.DIVISION_ID          = SUB.DIVISION_ID                
                                                   AND Z.OPERATION_GROUP      = SUB.OPERATION_GROUP                
                                                   AND Z.CELL_ITEM_ID         = SUB.CELL_ITEM_ID                
                                                   AND Z.ITEM_ID              = SUB.ITEM_ID              
                                                   AND Z.PROJECT_CODE         = SUB.PROJECT_CODE
                                                   AND Z.TO_SITE              = SUB.TO_SITE                
                                                   AND Z.INCOTERMS            = SUB.INCOTERMS                
                                                   AND Z.FROM_SITE            = SUB.FROM_SITE                
                                                   AND Z.TRANSPORT_MODE       = SUB.TRANSPORT_MODE          
                                                   AND Z.MEASURE              = SUB.MEASURE 
                                                   AND Z.MEASURE              ='SEMI_SHIP_PLAN'
                                                   AND Z.BOD_ID               = SUB.BOD_ID      
                                                   AND Z.ATTRIBUTE1						=	SUB.ATTRIBUTE1					
    --			                                         AND Z.ATTRIBUTE9						=	SUB.ATTRIBUTE9					
                                              )      
                                  AND SUB.MEASURE              ='SEMI_SHIP_PLAN'


            -------------------------------------------------------------------------------------------------------------         
            -- TACT TIME TEMP 생성  -- ESS 외주 Line별 생산 Target 관련 OSP_YN로직 수정
            -------------------------------------------------------------------------------------------------------------            
             IF OBJECT_ID('tempdb..#tmp_SCP_MST_TACT_TIME') IS NOT NULL	
	              DROP TABLE #tmp_SCP_MST_TACT_TIME
             
             SELECT * 
             INTO #tmp_SCP_MST_TACT_TIME
             FROM 
             (
                SELECT DIVISION_ID,PLANT_SITE_ID,ITEM_ID,OPERATION_ID,LINE_ID,YIELD 
                FROM SCP_MST_TACT_TIME WITH(NOLOCK)
                WHERE DIVISION_ID =@p_division_id
                UNION ALL
                SELECT DIVISION_ID,PLANT_SITE_ID,ITEM_ID,OPERATION_ID,LINE_ID,YIELD 
                FROM SCP_MST_TACT_TIME_OSP WITH(NOLOCK)
                WHERE DIVISION_ID =@p_division_id
              ) X

-- 주석처리 : 2022.10.14 - 불필요한 생산계획 생성을 차단
            ---------------------------------------------------------------------------------------------------------------         
            ---- LINE_ID 추가
            ---------------------------------------------------------------------------------------------------------------            
            ---- 'SHIP_PLAN'의 LINE_ID 종류 별 추가 
            --   INSERT INTO #SCP_XLS_PSI_GLOBAL_AUTO                          
            --          SELECT DISTINCT X.DIVISION_ID
            --          ,X.PLAN_START_YYYYMMDD
            --          ,X.PLAN_TYPE
            --          ,X.SEQ
            --          ,X.OPERATION_GROUP
            --          ,X.OPERATION_GROUP_NAME
            --          ,X.CELL_ITEM_ID
            --          ,X.ITEM_ID
            --          ,X.NICK_NAME
            --          ,X.CELL_QTY_PACK
            --          ,TO_SITE
            --          ,TO_SITE_DESCRIPTION
            --          ,PROJECT_CODE
            --          ,FROM_BOH_QTY
            --          ,TO_BOH_QTY
            --          ,INCOTERMS
            --          ,FROM_SITE
            --          ,FROM_SITE_DESCRIPTION
            --          ,TRANSPORT_MODE
            --          ,Y.LINE_ID AS PROD_LINE
            --          ,LT_DAY
            --          ,BOD_ID
            --          ,X.MEASURE
            --          ,X.MEASURE_LABEL
            --          ,X.XLS_KEY1
            --          ,X.XLS_KEY2
            --          ,X.XLS_KEY3
            --          ,X.XLS_KEY4
            --          ,X.XLS_KEY5
            --          ,X.XLS_ATTRIBUTE1
            --          ,X.XLS_ATTRIBUTE2
            --          ,X.XLS_ATTRIBUTE3
            --          ,X.XLS_ATTRIBUTE4
            --          ,X.XLS_ATTRIBUTE5
            --          ,X.SORT_ORDER_NO
            --          ,0  AS QTY001 ,0  AS QTY002,0  AS QTY003,0  AS QTY004,0  AS QTY005,0  AS QTY006 ,0  AS QTY007,0  AS QTY008,0  AS QTY009,0  AS QTY010
            --          ,0  AS QTY011 ,0  AS QTY012,0  AS QTY013,0  AS QTY014,0  AS QTY015,0  AS QTY016 ,0  AS QTY017,0  AS QTY018,0  AS QTY019,0  AS QTY020
            --          ,0  AS QTY021 ,0  AS QTY022,0  AS QTY023,0  AS QTY024,0  AS QTY025,0  AS QTY026 ,0  AS QTY027,0  AS QTY028,0  AS QTY029,0  AS QTY030
            --          ,0  AS QTY031 ,0  AS QTY032,0  AS QTY033,0  AS QTY034,0  AS QTY035,0  AS QTY036 ,0  AS QTY037,0  AS QTY038,0  AS QTY039,0  AS QTY040
            --          ,0  AS QTY041 ,0  AS QTY042,0  AS QTY043,0  AS QTY044,0  AS QTY045,0  AS QTY046 ,0  AS QTY047,0  AS QTY048,0  AS QTY049,0  AS QTY050
            --          ,0  AS QTY051 ,0  AS QTY052,0  AS QTY053,0  AS QTY054,0  AS QTY055,0  AS QTY056 ,0  AS QTY057,0  AS QTY058,0  AS QTY059,0  AS QTY060
            --          ,0  AS QTY061 ,0  AS QTY062,0  AS QTY063,0  AS QTY064,0  AS QTY065,0  AS QTY066 ,0  AS QTY067,0  AS QTY068,0  AS QTY069,0  AS QTY070
            --          ,0  AS QTY071 ,0  AS QTY072,0  AS QTY073,0  AS QTY074,0  AS QTY075,0  AS QTY076 ,0  AS QTY077,0  AS QTY078,0  AS QTY079,0  AS QTY080
            --          ,0  AS QTY081 ,0  AS QTY082,0  AS QTY083,0  AS QTY084,0  AS QTY085,0  AS QTY086 ,0  AS QTY087,0  AS QTY088,0  AS QTY089,0  AS QTY090
            --          ,0  AS QTY091 ,0  AS QTY092,0  AS QTY093,0  AS QTY094,0  AS QTY095,0  AS QTY096 ,0  AS QTY097,0  AS QTY098,0  AS QTY099,0  AS QTY100

            --          ,0  AS QTY101 ,0  AS QTY102,0  AS QTY103,0  AS QTY104,0  AS QTY105,0  AS QTY106 ,0  AS QTY107,0  AS QTY108,0  AS QTY109,0  AS QTY110
            --          ,0  AS QTY111 ,0  AS QTY112,0  AS QTY113,0  AS QTY114,0  AS QTY115,0  AS QTY116 ,0  AS QTY117,0  AS QTY118,0  AS QTY119,0  AS QTY120
            --          ,0  AS QTY121 ,0  AS QTY122,0  AS QTY123,0  AS QTY124,0  AS QTY125,0  AS QTY126 ,0  AS QTY127,0  AS QTY128,0  AS QTY129,0  AS QTY130
            --          ,0  AS QTY131 ,0  AS QTY132,0  AS QTY133,0  AS QTY134,0  AS QTY135,0  AS QTY136 ,0  AS QTY137,0  AS QTY138,0  AS QTY139,0  AS QTY140
            --          ,0  AS QTY141 ,0  AS QTY142,0  AS QTY143,0  AS QTY144,0  AS QTY145,0  AS QTY146 ,0  AS QTY147,0  AS QTY148,0  AS QTY149,0  AS QTY150
            --          ,0  AS QTY151 ,0  AS QTY152,0  AS QTY153,0  AS QTY154,0  AS QTY155,0  AS QTY156 ,0  AS QTY157,0  AS QTY158,0  AS QTY159,0  AS QTY160
            --          ,0  AS QTY161 ,0  AS QTY162,0  AS QTY163,0  AS QTY164,0  AS QTY165,0  AS QTY166 ,0  AS QTY167,0  AS QTY168,0  AS QTY169,0  AS QTY170
            --          ,0  AS QTY171 ,0  AS QTY172,0  AS QTY173,0  AS QTY174,0  AS QTY175,0  AS QTY176 ,0  AS QTY177,0  AS QTY178,0  AS QTY179,0  AS QTY180
            --          ,0  AS QTY181 ,0  AS QTY182,0  AS QTY183,0  AS QTY184,0  AS QTY185,0  AS QTY186 ,0  AS QTY187,0  AS QTY188,0  AS QTY189,0  AS QTY190
            --          ,0  AS QTY191 ,0  AS QTY192,0  AS QTY193,0  AS QTY194,0  AS QTY195,0  AS QTY196 ,0  AS QTY197,0  AS QTY198,0  AS QTY199,0  AS QTY200

            --          ,0  AS QTY201 ,0  AS QTY202,0  AS QTY203,0  AS QTY204,0  AS QTY205,0  AS QTY206 ,0  AS QTY207,0  AS QTY208,0  AS QTY209,0  AS QTY210
            --          ,0  AS QTY211 ,0  AS QTY212,0  AS QTY213,0  AS QTY214,0  AS QTY215,0  AS QTY216 ,0  AS QTY217,0  AS QTY218,0  AS QTY219,0  AS QTY220
            --          ,0  AS QTY221 ,0  AS QTY222,0  AS QTY223,0  AS QTY224,0  AS QTY225,0  AS QTY226 ,0  AS QTY227,0  AS QTY228,0  AS QTY229,0  AS QTY230
            --          ,0  AS QTY231 ,0  AS QTY232,0  AS QTY233,0  AS QTY234,0  AS QTY235,0  AS QTY236 ,0  AS QTY237,0  AS QTY238,0  AS QTY239,0  AS QTY240
            --          ,0  AS QTY241 ,0  AS QTY242,0  AS QTY243,0  AS QTY244,0  AS QTY245,0  AS QTY246 ,0  AS QTY247,0  AS QTY248,0  AS QTY249,0  AS QTY250
            --          ,0  AS QTY251 ,0  AS QTY252,0  AS QTY253,0  AS QTY254,0  AS QTY255,0  AS QTY256 ,0  AS QTY257,0  AS QTY258,0  AS QTY259,0  AS QTY260
            --          ,0  AS QTY261 ,0  AS QTY262,0  AS QTY263,0  AS QTY264,0  AS QTY265,0  AS QTY266 ,0  AS QTY267,0  AS QTY268,0  AS QTY269,0  AS QTY270
            --          ,0  AS QTY271 ,0  AS QTY272,0  AS QTY273,0  AS QTY274,0  AS QTY275,0  AS QTY276 ,0  AS QTY277,0  AS QTY278,0  AS QTY279,0  AS QTY280
            --          ,0  AS QTY281 ,0  AS QTY282,0  AS QTY283,0  AS QTY284,0  AS QTY285,0  AS QTY286 ,0  AS QTY287,0  AS QTY288,0  AS QTY289,0  AS QTY290
            --          ,0  AS QTY291 ,0  AS QTY292,0  AS QTY293,0  AS QTY294,0  AS QTY295,0  AS QTY296 ,0  AS QTY297,0  AS QTY298,0  AS QTY299,0  AS QTY300

            --          ,0  AS QTY301 ,0  AS QTY302,0  AS QTY303,0  AS QTY304,0  AS QTY305,0  AS QTY306 ,0  AS QTY307,0  AS QTY308,0  AS QTY309,0  AS QTY310
            --          ,0  AS QTY311 ,0  AS QTY312,0  AS QTY313,0  AS QTY314,0  AS QTY315,0  AS QTY316 ,0  AS QTY317,0  AS QTY318,0  AS QTY319,0  AS QTY320
            --          ,0  AS QTY321 ,0  AS QTY322,0  AS QTY323,0  AS QTY324,0  AS QTY325,0  AS QTY326 ,0  AS QTY327,0  AS QTY328,0  AS QTY329,0  AS QTY330
            --          ,0  AS QTY331 ,0  AS QTY332,0  AS QTY333,0  AS QTY334,0  AS QTY335,0  AS QTY336 ,0  AS QTY337,0  AS QTY338,0  AS QTY339,0  AS QTY340
            --          ,0 AS QTY341 ,0  AS QTY342,0  AS QTY343,0  AS QTY344,0  AS QTY345,0  AS QTY346 ,0  AS QTY347,0  AS QTY348,0  AS QTY349,0  AS QTY350
            --          ,0  AS QTY351 ,0  AS QTY352,0  AS QTY353,0  AS QTY354,0  AS QTY355,0  AS QTY356 ,0  AS QTY357,0  AS QTY358,0  AS QTY359,0  AS QTY360
            --          ,0  AS QTY361 ,0  AS QTY362,0  AS QTY363,0  AS QTY364                  
            --          --,X.CREATED_BY
            --          --,X.CREATION_DATE
            --          --,X.LAST_UPDATED_BY
            --          --,X.LAST_UPDATE_DATE
            --          ,X.ATTRIBUTE1
            --          ,X.ATTRIBUTE2
            --          ,X.ATTRIBUTE3
            --          ,X.ATTRIBUTE4
            --          ,X.ATTRIBUTE5
            --          ,X.ATTRIBUTE6
            --          ,X.ATTRIBUTE7
            --          ,X.ATTRIBUTE8
            --          ,X.ATTRIBUTE9
            --          ,X.ATTRIBUTE10
            --          FROM #SCP_XLS_PSI_GLOBAL_AUTO X WITH (NOLOCK) 
            --          CROSS APPLY #tmp_SCP_MST_TACT_TIME Y  WITH (NOLOCK)
            --          WHERE 0 = 0
            --          AND X.DIVISION_ID   = Y.DIVISION_ID
            --          AND X.ITEM_ID       = Y.ITEM_ID
            --          AND X.FROM_SITE     = Y.PLANT_SITE_ID
            --          AND X.MEASURE       IN  ('CELL_PROD','PACK_PROD')
            --          AND NOT EXISTS (                
            --                                SELECT 'X'                
            --                                  FROM #SCP_XLS_PSI_GLOBAL_AUTO Z WITH(NOLOCK)                
            --                                 WHERE 1=1                
            --                                   AND Z.DIVISION_ID          = X.DIVISION_ID                
            --                                   AND Z.CELL_ITEM_ID         = X.CELL_ITEM_ID    
            --                                   AND Z.ITEM_ID              = X.ITEM_ID              
            --                                   AND Z.MEASURE              = X.MEASURE 
            --                                   AND Z.FROM_SITE            = Y.PLANT_SITE_ID
            --                                   AND Z.PROD_LINE            = Y.LINE_ID
            --                                   AND Z.MEASURE              IN ('CELL_PROD','PACK_PROD')
            --                                   )

            --  UNION 
            --        SELECT DISTINCT X.DIVISION_ID
            --          ,X.PLAN_START_YYYYMMDD
            --          ,X.PLAN_TYPE
            --          ,X.SEQ
            --          ,X.OPERATION_GROUP
            --          ,X.OPERATION_GROUP_NAME
            --          ,X.CELL_ITEM_ID
            --          ,X.ITEM_ID
            --          ,X.NICK_NAME
            --          ,X.CELL_QTY_PACK
            --          ,X.TO_SITE
            --          ,X.TO_SITE_DESCRIPTION
            --          ,X.PROJECT_CODE
            --          ,X.FROM_BOH_QTY
            --          ,X.TO_BOH_QTY
            --          ,X.INCOTERMS
            --          ,X.FROM_SITE
            --          ,X.FROM_SITE_DESCRIPTION
            --          ,X.TRANSPORT_MODE
            --          ,Y.LINE_ID AS PROD_LINE
            --          ,X.LT_DAY
            --          ,X.BOD_ID
            --          ,(CASE  WHEN X.MEASURE = 'PACK_PROD' THEN 'PACK_PROD_LOAD' 
            --                  WHEN X.MEASURE = 'CELL_PROD' THEN 'CELL_PROD_LOAD' END ) AS MEASURE
            --          ,(CASE  WHEN X.MEASURE = 'PACK_PROD' THEN 'Load Ratio(%)' 
            --                  WHEN X.MEASURE = 'CELL_PROD' THEN 'Load Ratio(%)' END ) AS MEASURE_LABEL
            --          ,X.XLS_KEY1
            --          ,X.XLS_KEY2
            --          ,X.XLS_KEY3
            --          ,X.XLS_KEY4
            --          ,X.XLS_KEY5
            --          ,X.XLS_ATTRIBUTE1
            --          ,X.XLS_ATTRIBUTE2
            --          ,X.XLS_ATTRIBUTE3
            --          ,X.XLS_ATTRIBUTE4
            --          ,X.XLS_ATTRIBUTE5
            --          ,X.SORT_ORDER_NO
            --          ,0  AS QTY001 ,0  AS QTY002,0  AS QTY003,0  AS QTY004,0  AS QTY005,0  AS QTY006 ,0  AS QTY007,0  AS QTY008,0  AS QTY009,0  AS QTY010
            --          ,0  AS QTY011 ,0  AS QTY012,0  AS QTY013,0  AS QTY014,0  AS QTY015,0  AS QTY016 ,0  AS QTY017,0  AS QTY018,0  AS QTY019,0  AS QTY020
            --          ,0  AS QTY021 ,0  AS QTY022,0  AS QTY023,0  AS QTY024,0  AS QTY025,0  AS QTY026 ,0  AS QTY027,0  AS QTY028,0  AS QTY029,0  AS QTY030
            --          ,0  AS QTY031 ,0  AS QTY032,0  AS QTY033,0  AS QTY034,0  AS QTY035,0  AS QTY036 ,0  AS QTY037,0  AS QTY038,0  AS QTY039,0  AS QTY040
            --          ,0  AS QTY041 ,0  AS QTY042,0  AS QTY043,0  AS QTY044,0  AS QTY045,0  AS QTY046 ,0  AS QTY047,0  AS QTY048,0  AS QTY049,0  AS QTY050
            --          ,0  AS QTY051 ,0  AS QTY052,0  AS QTY053,0  AS QTY054,0  AS QTY055,0  AS QTY056 ,0  AS QTY057,0  AS QTY058,0  AS QTY059,0  AS QTY060
            --          ,0  AS QTY061 ,0  AS QTY062,0  AS QTY063,0  AS QTY064,0  AS QTY065,0  AS QTY066 ,0  AS QTY067,0  AS QTY068,0  AS QTY069,0  AS QTY070
            --          ,0  AS QTY071 ,0  AS QTY072,0  AS QTY073,0  AS QTY074,0  AS QTY075,0  AS QTY076 ,0  AS QTY077,0  AS QTY078,0  AS QTY079,0  AS QTY080
            --          ,0  AS QTY081 ,0  AS QTY082,0  AS QTY083,0  AS QTY084,0  AS QTY085,0  AS QTY086 ,0  AS QTY087,0  AS QTY088,0  AS QTY089,0  AS QTY090
            --          ,0  AS QTY091 ,0  AS QTY092,0  AS QTY093,0  AS QTY094,0  AS QTY095,0  AS QTY096 ,0  AS QTY097,0  AS QTY098,0  AS QTY099,0  AS QTY100

            --          ,0  AS QTY101 ,0  AS QTY102,0  AS QTY103,0  AS QTY104,0  AS QTY105,0  AS QTY106 ,0  AS QTY107,0  AS QTY108,0  AS QTY109,0  AS QTY110
            --          ,0  AS QTY111 ,0  AS QTY112,0  AS QTY113,0  AS QTY114,0  AS QTY115,0  AS QTY116 ,0  AS QTY117,0  AS QTY118,0  AS QTY119,0  AS QTY120
            --          ,0  AS QTY121 ,0  AS QTY122,0  AS QTY123,0  AS QTY124,0  AS QTY125,0  AS QTY126 ,0  AS QTY127,0  AS QTY128,0  AS QTY129,0  AS QTY130
            --          ,0  AS QTY131 ,0  AS QTY132,0  AS QTY133,0  AS QTY134,0  AS QTY135,0  AS QTY136 ,0  AS QTY137,0  AS QTY138,0  AS QTY139,0  AS QTY140
            --          ,0  AS QTY141 ,0  AS QTY142,0  AS QTY143,0  AS QTY144,0  AS QTY145,0  AS QTY146 ,0  AS QTY147,0  AS QTY148,0  AS QTY149,0  AS QTY150
            --          ,0  AS QTY151 ,0  AS QTY152,0  AS QTY153,0  AS QTY154,0  AS QTY155,0  AS QTY156 ,0  AS QTY157,0  AS QTY158,0  AS QTY159,0  AS QTY160
            --          ,0  AS QTY161 ,0  AS QTY162,0  AS QTY163,0  AS QTY164,0  AS QTY165,0  AS QTY166 ,0  AS QTY167,0  AS QTY168,0  AS QTY169,0  AS QTY170
            --          ,0  AS QTY171 ,0  AS QTY172,0  AS QTY173,0  AS QTY174,0  AS QTY175,0  AS QTY176 ,0  AS QTY177,0  AS QTY178,0  AS QTY179,0  AS QTY180
            --          ,0  AS QTY181 ,0  AS QTY182,0  AS QTY183,0  AS QTY184,0  AS QTY185,0  AS QTY186 ,0  AS QTY187,0  AS QTY188,0  AS QTY189,0  AS QTY190
            --          ,0  AS QTY191 ,0  AS QTY192,0  AS QTY193,0  AS QTY194,0  AS QTY195,0  AS QTY196 ,0  AS QTY197,0  AS QTY198,0  AS QTY199,0  AS QTY200

            --          ,0  AS QTY201 ,0  AS QTY202,0  AS QTY203,0  AS QTY204,0  AS QTY205,0  AS QTY206 ,0  AS QTY207,0  AS QTY208,0  AS QTY209,0  AS QTY210
            --          ,0  AS QTY211 ,0  AS QTY212,0  AS QTY213,0  AS QTY214,0  AS QTY215,0  AS QTY216 ,0  AS QTY217,0  AS QTY218,0  AS QTY219,0  AS QTY220
            --          ,0  AS QTY221 ,0  AS QTY222,0  AS QTY223,0  AS QTY224,0  AS QTY225,0  AS QTY226 ,0  AS QTY227,0  AS QTY228,0  AS QTY229,0  AS QTY230
            --          ,0  AS QTY231 ,0  AS QTY232,0  AS QTY233,0  AS QTY234,0  AS QTY235,0  AS QTY236 ,0  AS QTY237,0  AS QTY238,0  AS QTY239,0  AS QTY240
            --          ,0  AS QTY241 ,0  AS QTY242,0  AS QTY243,0  AS QTY244,0  AS QTY245,0  AS QTY246 ,0  AS QTY247,0  AS QTY248,0  AS QTY249,0  AS QTY250
            --          ,0  AS QTY251 ,0  AS QTY252,0  AS QTY253,0  AS QTY254,0  AS QTY255,0  AS QTY256 ,0  AS QTY257,0  AS QTY258,0  AS QTY259,0  AS QTY260
            --          ,0  AS QTY261 ,0  AS QTY262,0  AS QTY263,0  AS QTY264,0  AS QTY265,0  AS QTY266 ,0  AS QTY267,0  AS QTY268,0  AS QTY269,0  AS QTY270
            --          ,0  AS QTY271 ,0  AS QTY272,0  AS QTY273,0  AS QTY274,0  AS QTY275,0  AS QTY276 ,0  AS QTY277,0  AS QTY278,0  AS QTY279,0  AS QTY280
            --          ,0  AS QTY281 ,0  AS QTY282,0  AS QTY283,0  AS QTY284,0  AS QTY285,0  AS QTY286 ,0  AS QTY287,0  AS QTY288,0  AS QTY289,0  AS QTY290
            --          ,0  AS QTY291 ,0  AS QTY292,0  AS QTY293,0  AS QTY294,0  AS QTY295,0  AS QTY296 ,0  AS QTY297,0  AS QTY298,0  AS QTY299,0  AS QTY300

            --          ,0  AS QTY301 ,0  AS QTY302,0  AS QTY303,0  AS QTY304,0  AS QTY305,0  AS QTY306 ,0  AS QTY307,0  AS QTY308,0  AS QTY309,0  AS QTY310
            --          ,0  AS QTY311 ,0  AS QTY312,0  AS QTY313,0  AS QTY314,0  AS QTY315,0  AS QTY316 ,0  AS QTY317,0  AS QTY318,0  AS QTY319,0  AS QTY320
            --          ,0  AS QTY321 ,0  AS QTY322,0  AS QTY323,0  AS QTY324,0  AS QTY325,0  AS QTY326 ,0  AS QTY327,0  AS QTY328,0  AS QTY329,0  AS QTY330
            --          ,0  AS QTY331 ,0  AS QTY332,0  AS QTY333,0  AS QTY334,0  AS QTY335,0  AS QTY336 ,0  AS QTY337,0  AS QTY338,0  AS QTY339,0  AS QTY340
            --          ,0  AS QTY341 ,0  AS QTY342,0  AS QTY343,0  AS QTY344,0  AS QTY345,0  AS QTY346 ,0  AS QTY347,0  AS QTY348,0  AS QTY349,0  AS QTY350
            --          ,0  AS QTY351 ,0  AS QTY352,0  AS QTY353,0  AS QTY354,0  AS QTY355,0  AS QTY356 ,0  AS QTY357,0  AS QTY358,0  AS QTY359,0  AS QTY360
            --          ,0  AS QTY361 ,0  AS QTY362,0  AS QTY363,0  AS QTY364                  
            --          --,X.CREATED_BY
            --          --,X.CREATION_DATE
            --          --,X.LAST_UPDATED_BY
            --          --,X.LAST_UPDATE_DATE
            --          ,X.ATTRIBUTE1
            --          ,X.ATTRIBUTE2
            --          ,X.ATTRIBUTE3
            --          ,X.ATTRIBUTE4
            --          ,X.ATTRIBUTE5
            --          ,X.ATTRIBUTE6
            --          ,X.ATTRIBUTE7
            --          ,X.ATTRIBUTE8
            --          ,X.ATTRIBUTE9
            --          ,X.ATTRIBUTE10
            --          FROM #SCP_XLS_PSI_GLOBAL_AUTO X WITH (NOLOCK) 
            --          CROSS APPLY #tmp_SCP_MST_TACT_TIME Y  WITH (NOLOCK)
            --          WHERE 0 = 0
            --          AND X.DIVISION_ID   = Y.DIVISION_ID
            --          AND X.ITEM_ID       = Y.ITEM_ID
            --          AND X.FROM_SITE     = Y.PLANT_SITE_ID
            --          AND X.MEASURE       IN  ('CELL_PROD','PACK_PROD')
            --          AND NOT EXISTS (                
            --                                SELECT 'X'                
            --                                  FROM #SCP_XLS_PSI_GLOBAL_AUTO Z WITH(NOLOCK)                
            --                                 WHERE 1=1                
            --                                   AND Z.DIVISION_ID          = X.DIVISION_ID                
            --                                   AND Z.CELL_ITEM_ID         = X.CELL_ITEM_ID    
            --                                   AND Z.ITEM_ID              = X.ITEM_ID              
            --                                   AND Z.MEASURE              = X.MEASURE 
            --                                   AND Z.FROM_SITE            = Y.PLANT_SITE_ID
            --                                   AND Z.PROD_LINE            = Y.LINE_ID
            --                                   AND Z.MEASURE              IN ('CELL_PROD','PACK_PROD')
            --                                   )



            -------------------------------------------------------------------------------------------------------------         
            --  MEASURE 추가 : ITEM_ID별 (MKT_FCST_CELL_TOTAL)
            -------------------------------------------------------------------------------------------------------------           
               INSERT INTO #SCP_XLS_PSI_GLOBAL_AUTO                          
                      SELECT DISTINCT X.DIVISION_ID
                      ,X.PLAN_START_YYYYMMDD
                      ,X.PLAN_TYPE
                      ,X.SEQ
                      ,X.OPERATION_GROUP
                      ,'CELL' AS OPERATION_GROUP_NAME
                      ,X.CELL_ITEM_ID
                      ,'-' AS ITEM_ID
                      ,'-' AS NICK_NAME
                      ,'0' AS CELL_QTY_PACK
                      ,'-' AS TO_SITE
                      ,'-' AS TO_SITE_DESCRIPTION
                      ,'-' AS PROJECT_CODE
                      ,'0' AS FROM_BOH_QTY
                      ,'0' AS TO_BOH_QTY
                      ,'-' AS INCOTERMS
                      ,'-' AS FROM_SITE
                      ,'-' AS FROM_SITE_DESCRIPTION
                      ,'-' AS TRANSPORT_MODE
                      ,'-' AS PROD_LINE
                      ,'-' AS LT_DAY
                      ,'-' AS BOD_ID
                      ,M.COLUMN_NAME AS MEASURE
                      ,M.COLUMN_LABEL_NAME AS MEASURE_LABEL
                      ,X.XLS_KEY1
                      ,X.XLS_KEY2
                      ,X.XLS_KEY3
                      ,X.XLS_KEY4
                      ,X.XLS_KEY5
                      ,X.XLS_ATTRIBUTE1
                      ,X.XLS_ATTRIBUTE2
                      ,X.XLS_ATTRIBUTE3
                      ,X.XLS_ATTRIBUTE4
                      ,X.XLS_ATTRIBUTE5
                      ,M.SORT_ORDER_NO
                      ,0  AS QTY001 ,0  AS QTY002,0  AS QTY003,0  AS QTY004,0  AS QTY005,0  AS QTY006 ,0  AS QTY007,0  AS QTY008,0  AS QTY009,0  AS QTY010
                      ,0  AS QTY011 ,0  AS QTY012,0  AS QTY013,0  AS QTY014,0  AS QTY015,0  AS QTY016 ,0  AS QTY017,0  AS QTY018,0  AS QTY019,0  AS QTY020
                      ,0  AS QTY021 ,0  AS QTY022,0  AS QTY023,0  AS QTY024,0  AS QTY025,0  AS QTY026 ,0  AS QTY027,0  AS QTY028,0  AS QTY029,0  AS QTY030
                      ,0  AS QTY031 ,0  AS QTY032,0  AS QTY033,0  AS QTY034,0  AS QTY035,0  AS QTY036 ,0  AS QTY037,0  AS QTY038,0  AS QTY039,0  AS QTY040
                      ,0  AS QTY041 ,0  AS QTY042,0  AS QTY043,0  AS QTY044,0  AS QTY045,0  AS QTY046 ,0  AS QTY047,0  AS QTY048,0  AS QTY049,0  AS QTY050
                      ,0  AS QTY051 ,0  AS QTY052,0  AS QTY053,0  AS QTY054,0  AS QTY055,0  AS QTY056 ,0  AS QTY057,0  AS QTY058,0  AS QTY059,0  AS QTY060
                      ,0  AS QTY061 ,0  AS QTY062,0  AS QTY063,0  AS QTY064,0  AS QTY065,0  AS QTY066 ,0  AS QTY067,0  AS QTY068,0  AS QTY069,0  AS QTY070
                      ,0  AS QTY071 ,0  AS QTY072,0  AS QTY073,0  AS QTY074,0  AS QTY075,0  AS QTY076 ,0  AS QTY077,0  AS QTY078,0  AS QTY079,0  AS QTY080
                      ,0  AS QTY081 ,0  AS QTY082,0  AS QTY083,0  AS QTY084,0  AS QTY085,0  AS QTY086 ,0  AS QTY087,0  AS QTY088,0  AS QTY089,0  AS QTY090
                      ,0  AS QTY091 ,0  AS QTY092,0  AS QTY093,0  AS QTY094,0  AS QTY095,0  AS QTY096 ,0  AS QTY097,0  AS QTY098,0  AS QTY099,0  AS QTY100

                      ,0  AS QTY101 ,0  AS QTY102,0  AS QTY103,0  AS QTY104,0  AS QTY105,0  AS QTY106 ,0  AS QTY107,0  AS QTY108,0  AS QTY109,0  AS QTY110
                      ,0  AS QTY111 ,0  AS QTY112,0  AS QTY113,0  AS QTY114,0  AS QTY115,0  AS QTY116 ,0  AS QTY117,0  AS QTY118,0  AS QTY119,0  AS QTY120
                      ,0  AS QTY121 ,0  AS QTY122,0  AS QTY123,0  AS QTY124,0  AS QTY125,0  AS QTY126 ,0  AS QTY127,0  AS QTY128,0  AS QTY129,0  AS QTY130
                      ,0  AS QTY131 ,0  AS QTY132,0  AS QTY133,0  AS QTY134,0  AS QTY135,0  AS QTY136 ,0  AS QTY137,0  AS QTY138,0  AS QTY139,0  AS QTY140
                      ,0  AS QTY141 ,0  AS QTY142,0  AS QTY143,0  AS QTY144,0  AS QTY145,0  AS QTY146 ,0  AS QTY147,0  AS QTY148,0  AS QTY149,0  AS QTY150
                      ,0  AS QTY151 ,0  AS QTY152,0  AS QTY153,0  AS QTY154,0  AS QTY155,0  AS QTY156 ,0  AS QTY157,0  AS QTY158,0  AS QTY159,0  AS QTY160
                      ,0  AS QTY161 ,0  AS QTY162,0  AS QTY163,0  AS QTY164,0  AS QTY165,0  AS QTY166 ,0  AS QTY167,0  AS QTY168,0  AS QTY169,0  AS QTY170
                      ,0  AS QTY171 ,0  AS QTY172,0  AS QTY173,0  AS QTY174,0  AS QTY175,0  AS QTY176 ,0  AS QTY177,0  AS QTY178,0  AS QTY179,0  AS QTY180
                      ,0  AS QTY181 ,0  AS QTY182,0  AS QTY183,0  AS QTY184,0  AS QTY185,0  AS QTY186 ,0  AS QTY187,0  AS QTY188,0  AS QTY189,0  AS QTY190
                      ,0  AS QTY191 ,0  AS QTY192,0  AS QTY193,0  AS QTY194,0  AS QTY195,0  AS QTY196 ,0  AS QTY197,0  AS QTY198,0  AS QTY199,0  AS QTY200

                      ,0  AS QTY201 ,0  AS QTY202,0  AS QTY203,0  AS QTY204,0  AS QTY205,0  AS QTY206 ,0  AS QTY207,0  AS QTY208,0  AS QTY209,0  AS QTY210
                      ,0  AS QTY211 ,0  AS QTY212,0  AS QTY213,0  AS QTY214,0  AS QTY215,0  AS QTY216 ,0  AS QTY217,0  AS QTY218,0  AS QTY219,0  AS QTY220
                      ,0  AS QTY221 ,0  AS QTY222,0  AS QTY223,0  AS QTY224,0  AS QTY225,0  AS QTY226 ,0  AS QTY227,0  AS QTY228,0  AS QTY229,0  AS QTY230
                      ,0  AS QTY231 ,0  AS QTY232,0  AS QTY233,0  AS QTY234,0  AS QTY235,0  AS QTY236 ,0  AS QTY237,0  AS QTY238,0  AS QTY239,0  AS QTY240
                      ,0  AS QTY241 ,0  AS QTY242,0  AS QTY243,0  AS QTY244,0  AS QTY245,0  AS QTY246 ,0  AS QTY247,0  AS QTY248,0  AS QTY249,0  AS QTY250
                      ,0  AS QTY251 ,0  AS QTY252,0  AS QTY253,0  AS QTY254,0  AS QTY255,0  AS QTY256 ,0  AS QTY257,0  AS QTY258,0  AS QTY259,0  AS QTY260
                      ,0  AS QTY261 ,0  AS QTY262,0  AS QTY263,0  AS QTY264,0  AS QTY265,0  AS QTY266 ,0  AS QTY267,0  AS QTY268,0  AS QTY269,0  AS QTY270
                      ,0  AS QTY271 ,0  AS QTY272,0  AS QTY273,0  AS QTY274,0  AS QTY275,0  AS QTY276 ,0  AS QTY277,0  AS QTY278,0  AS QTY279,0  AS QTY280
                      ,0  AS QTY281 ,0  AS QTY282,0  AS QTY283,0  AS QTY284,0  AS QTY285,0  AS QTY286 ,0  AS QTY287,0  AS QTY288,0  AS QTY289,0  AS QTY290
                      ,0  AS QTY291 ,0  AS QTY292,0  AS QTY293,0  AS QTY294,0  AS QTY295,0  AS QTY296 ,0  AS QTY297,0  AS QTY298,0  AS QTY299,0  AS QTY300

                      ,0  AS QTY301 ,0  AS QTY302,0  AS QTY303,0  AS QTY304,0  AS QTY305,0  AS QTY306 ,0  AS QTY307,0  AS QTY308,0  AS QTY309,0  AS QTY310
                      ,0  AS QTY311 ,0  AS QTY312,0  AS QTY313,0  AS QTY314,0  AS QTY315,0  AS QTY316 ,0  AS QTY317,0  AS QTY318,0  AS QTY319,0  AS QTY320
                      ,0  AS QTY321 ,0  AS QTY322,0  AS QTY323,0  AS QTY324,0  AS QTY325,0  AS QTY326 ,0  AS QTY327,0  AS QTY328,0  AS QTY329,0  AS QTY330
                      ,0  AS QTY331 ,0  AS QTY332,0  AS QTY333,0  AS QTY334,0  AS QTY335,0  AS QTY336 ,0  AS QTY337,0  AS QTY338,0  AS QTY339,0  AS QTY340
                      ,0  AS QTY341 ,0  AS QTY342,0  AS QTY343,0  AS QTY344,0  AS QTY345,0  AS QTY346 ,0  AS QTY347,0  AS QTY348,0  AS QTY349,0  AS QTY350
                      ,0  AS QTY351 ,0  AS QTY352,0  AS QTY353,0  AS QTY354,0  AS QTY355,0  AS QTY356 ,0  AS QTY357,0  AS QTY358,0  AS QTY359,0  AS QTY360
                      ,0  AS QTY361 ,0  AS QTY362,0  AS QTY363,0  AS QTY364                  
                      --,X.CREATED_BY
                      --,X.CREATION_DATE
                      --,X.LAST_UPDATED_BY
                      --,X.LAST_UPDATE_DATE
                      , (CASE WHEN M.COLUMN_NAME = 'MKT_FCST_CELL_TOTAL' THEN 'MKT_FCST_CELL_TOTAL' ELSE 'DIO' END) AS ATTRIBUTE1
                      ,X.ATTRIBUTE2
                      ,X.ATTRIBUTE3
                      ,X.ATTRIBUTE4
                      ,X.ATTRIBUTE5
                      ,X.ATTRIBUTE6
                      ,X.ATTRIBUTE7
                      ,X.ATTRIBUTE8
                      ,NULL AS ATTRIBUTE9
                      ,X.ATTRIBUTE10
                      FROM #SCP_XLS_PSI_GLOBAL_AUTO X WITH (NOLOCK) 
                      CROSS APPLY #MEASURE M  WITH (NOLOCK)
                       WHERE 1=1          
                        AND M.GUBUN       = 'CELL_ITEM_ID'
                        AND M.COLUMN_NAME = 'MKT_FCST_CELL_TOTAL'
                        AND X.OPERATION_GROUP = 'A'

            -------------------------------------------------------------------------------------------------------------         
            --  DIO 계산용 MEASURE 추가(MKT_FCST_TOTAL,ALLOCATION_TOTAL,EOH_TOTAL,MKT_FCST_DIO,ALLOCATION_DIO)
            -------------------------------------------------------------------------------------------------------------           
               INSERT INTO #SCP_XLS_PSI_GLOBAL_AUTO                          
                      SELECT DISTINCT X.DIVISION_ID
                      ,X.PLAN_START_YYYYMMDD
                      ,X.PLAN_TYPE
                      ,X.SEQ
                      ,'A' AS OPERATION_GROUP
                      ,'CELL' AS OPERATION_GROUP_NAME
                      ,X.CELL_ITEM_ID
                      ,'-' AS ITEM_ID
                      ,'-' AS NICK_NAME
                      ,'0' AS CELL_QTY_PACK
                      ,'-' AS TO_SITE
                      ,'-' AS TO_SITE_DESCRIPTION
                      ,'-' AS PROJECT_CODE
                      ,'0' AS FROM_BOH_QTY
                      ,'0' AS TO_BOH_QTY
                      ,'-' AS INCOTERMS
                      ,'-' AS FROM_SITE
                      ,'-' AS FROM_SITE_DESCRIPTION
                      ,'-' AS TRANSPORT_MODE
                      ,'-' AS PROD_LINE
                      ,'-' AS LT_DAY
                      ,'-' AS BOD_ID
                      ,M.COLUMN_NAME AS MEASURE
                      ,M.COLUMN_LABEL_NAME AS MEASURE_LABEL
                      ,X.XLS_KEY1
                      ,X.XLS_KEY2
                      ,X.XLS_KEY3
                      ,X.XLS_KEY4
                      ,X.XLS_KEY5
                      ,X.XLS_ATTRIBUTE1
                      ,X.XLS_ATTRIBUTE2
                      ,X.XLS_ATTRIBUTE3
                      ,X.XLS_ATTRIBUTE4
                      ,X.XLS_ATTRIBUTE5
                      ,M.SORT_ORDER_NO
                      ,0  AS QTY001 ,0  AS QTY002,0  AS QTY003,0  AS QTY004,0  AS QTY005,0  AS QTY006 ,0  AS QTY007,0  AS QTY008,0  AS QTY009,0  AS QTY010
                      ,0  AS QTY011 ,0  AS QTY012,0  AS QTY013,0  AS QTY014,0  AS QTY015,0  AS QTY016 ,0  AS QTY017,0  AS QTY018,0  AS QTY019,0  AS QTY020
                      ,0  AS QTY021 ,0  AS QTY022,0  AS QTY023,0  AS QTY024,0  AS QTY025,0  AS QTY026 ,0  AS QTY027,0  AS QTY028,0  AS QTY029,0  AS QTY030
                      ,0  AS QTY031 ,0  AS QTY032,0  AS QTY033,0  AS QTY034,0  AS QTY035,0  AS QTY036 ,0  AS QTY037,0  AS QTY038,0  AS QTY039,0  AS QTY040
                      ,0  AS QTY041 ,0  AS QTY042,0  AS QTY043,0  AS QTY044,0  AS QTY045,0  AS QTY046 ,0  AS QTY047,0  AS QTY048,0  AS QTY049,0  AS QTY050
                      ,0  AS QTY051 ,0  AS QTY052,0  AS QTY053,0  AS QTY054,0  AS QTY055,0  AS QTY056 ,0  AS QTY057,0  AS QTY058,0  AS QTY059,0  AS QTY060
                      ,0  AS QTY061 ,0  AS QTY062,0  AS QTY063,0  AS QTY064,0  AS QTY065,0  AS QTY066 ,0  AS QTY067,0  AS QTY068,0  AS QTY069,0  AS QTY070
                      ,0  AS QTY071 ,0  AS QTY072,0  AS QTY073,0  AS QTY074,0  AS QTY075,0  AS QTY076 ,0  AS QTY077,0  AS QTY078,0  AS QTY079,0  AS QTY080
                      ,0  AS QTY081 ,0  AS QTY082,0  AS QTY083,0  AS QTY084,0  AS QTY085,0  AS QTY086 ,0  AS QTY087,0  AS QTY088,0  AS QTY089,0  AS QTY090
                      ,0  AS QTY091 ,0  AS QTY092,0  AS QTY093,0  AS QTY094,0  AS QTY095,0  AS QTY096 ,0  AS QTY097,0  AS QTY098,0  AS QTY099,0  AS QTY100

                      ,0  AS QTY101 ,0  AS QTY102,0  AS QTY103,0  AS QTY104,0  AS QTY105,0  AS QTY106 ,0  AS QTY107,0  AS QTY108,0  AS QTY109,0  AS QTY110
                      ,0  AS QTY111 ,0  AS QTY112,0  AS QTY113,0  AS QTY114,0  AS QTY115,0  AS QTY116 ,0  AS QTY117,0  AS QTY118,0  AS QTY119,0  AS QTY120
                      ,0  AS QTY121 ,0  AS QTY122,0  AS QTY123,0  AS QTY124,0  AS QTY125,0  AS QTY126 ,0  AS QTY127,0  AS QTY128,0  AS QTY129,0  AS QTY130
                      ,0  AS QTY131 ,0  AS QTY132,0  AS QTY133,0  AS QTY134,0  AS QTY135,0  AS QTY136 ,0  AS QTY137,0  AS QTY138,0  AS QTY139,0  AS QTY140
                      ,0  AS QTY141 ,0  AS QTY142,0  AS QTY143,0  AS QTY144,0  AS QTY145,0  AS QTY146 ,0  AS QTY147,0  AS QTY148,0  AS QTY149,0  AS QTY150
                      ,0  AS QTY151 ,0  AS QTY152,0  AS QTY153,0  AS QTY154,0  AS QTY155,0  AS QTY156 ,0  AS QTY157,0  AS QTY158,0  AS QTY159,0  AS QTY160
                      ,0  AS QTY161 ,0  AS QTY162,0  AS QTY163,0  AS QTY164,0  AS QTY165,0  AS QTY166 ,0  AS QTY167,0  AS QTY168,0  AS QTY169,0  AS QTY170
                      ,0  AS QTY171 ,0  AS QTY172,0  AS QTY173,0  AS QTY174,0  AS QTY175,0  AS QTY176 ,0  AS QTY177,0  AS QTY178,0  AS QTY179,0  AS QTY180
                      ,0  AS QTY181 ,0  AS QTY182,0  AS QTY183,0  AS QTY184,0  AS QTY185,0  AS QTY186 ,0  AS QTY187,0  AS QTY188,0  AS QTY189,0  AS QTY190
                      ,0  AS QTY191 ,0  AS QTY192,0  AS QTY193,0  AS QTY194,0  AS QTY195,0  AS QTY196 ,0  AS QTY197,0  AS QTY198,0  AS QTY199,0  AS QTY200

                      ,0  AS QTY201 ,0  AS QTY202,0  AS QTY203,0  AS QTY204,0  AS QTY205,0  AS QTY206 ,0  AS QTY207,0  AS QTY208,0  AS QTY209,0  AS QTY210
                      ,0  AS QTY211 ,0  AS QTY212,0  AS QTY213,0  AS QTY214,0  AS QTY215,0  AS QTY216 ,0  AS QTY217,0  AS QTY218,0  AS QTY219,0  AS QTY220
                      ,0  AS QTY221 ,0  AS QTY222,0  AS QTY223,0  AS QTY224,0  AS QTY225,0  AS QTY226 ,0  AS QTY227,0  AS QTY228,0  AS QTY229,0  AS QTY230
                      ,0  AS QTY231 ,0  AS QTY232,0  AS QTY233,0  AS QTY234,0  AS QTY235,0  AS QTY236 ,0  AS QTY237,0  AS QTY238,0  AS QTY239,0  AS QTY240
                      ,0  AS QTY241 ,0  AS QTY242,0  AS QTY243,0  AS QTY244,0  AS QTY245,0  AS QTY246 ,0  AS QTY247,0  AS QTY248,0  AS QTY249,0  AS QTY250
                      ,0  AS QTY251 ,0  AS QTY252,0  AS QTY253,0  AS QTY254,0  AS QTY255,0  AS QTY256 ,0  AS QTY257,0  AS QTY258,0  AS QTY259,0  AS QTY260
                      ,0  AS QTY261 ,0  AS QTY262,0  AS QTY263,0  AS QTY264,0  AS QTY265,0  AS QTY266 ,0  AS QTY267,0  AS QTY268,0  AS QTY269,0  AS QTY270
                      ,0  AS QTY271 ,0  AS QTY272,0  AS QTY273,0  AS QTY274,0  AS QTY275,0  AS QTY276 ,0  AS QTY277,0  AS QTY278,0  AS QTY279,0  AS QTY280
                      ,0  AS QTY281 ,0  AS QTY282,0  AS QTY283,0  AS QTY284,0  AS QTY285,0  AS QTY286 ,0  AS QTY287,0  AS QTY288,0  AS QTY289,0  AS QTY290
                      ,0  AS QTY291 ,0  AS QTY292,0  AS QTY293,0  AS QTY294,0  AS QTY295,0  AS QTY296 ,0  AS QTY297,0  AS QTY298,0  AS QTY299,0  AS QTY300

                      ,0  AS QTY301 ,0  AS QTY302,0  AS QTY303,0  AS QTY304,0  AS QTY305,0  AS QTY306 ,0  AS QTY307,0  AS QTY308,0  AS QTY309,0  AS QTY310
                      ,0  AS QTY311 ,0  AS QTY312,0  AS QTY313,0  AS QTY314,0  AS QTY315,0  AS QTY316 ,0  AS QTY317,0  AS QTY318,0  AS QTY319,0  AS QTY320
                      ,0  AS QTY321 ,0  AS QTY322,0  AS QTY323,0  AS QTY324,0  AS QTY325,0  AS QTY326 ,0  AS QTY327,0  AS QTY328,0  AS QTY329,0  AS QTY330
                      ,0  AS QTY331 ,0  AS QTY332,0  AS QTY333,0  AS QTY334,0  AS QTY335,0  AS QTY336 ,0  AS QTY337,0  AS QTY338,0  AS QTY339,0  AS QTY340
                      ,0  AS QTY341 ,0  AS QTY342,0  AS QTY343,0  AS QTY344,0  AS QTY345,0  AS QTY346 ,0  AS QTY347,0  AS QTY348,0  AS QTY349,0  AS QTY350
                      ,0  AS QTY351 ,0  AS QTY352,0  AS QTY353,0  AS QTY354,0  AS QTY355,0  AS QTY356 ,0  AS QTY357,0  AS QTY358,0  AS QTY359,0  AS QTY360
                      ,0  AS QTY361 ,0  AS QTY362,0  AS QTY363,0  AS QTY364                  
                      --,X.CREATED_BY
                      --,X.CREATION_DATE
                      --,X.LAST_UPDATED_BY
                      --,X.LAST_UPDATE_DATE
                      , (CASE WHEN M.COLUMN_NAME = 'MKT_FCST_CELL_TOTAL' THEN 'MKT_FCST_CELL_TOTAL' ELSE 'DIO' END) AS ATTRIBUTE1
                      ,X.ATTRIBUTE2
                      ,X.ATTRIBUTE3
                      ,X.ATTRIBUTE4
                      ,X.ATTRIBUTE5
                      ,X.ATTRIBUTE6
                      ,X.ATTRIBUTE7
                      ,X.ATTRIBUTE8
                      ,NULL AS ATTRIBUTE9
                      ,X.ATTRIBUTE10
                      FROM #SCP_XLS_PSI_GLOBAL_AUTO X WITH (NOLOCK) 
                      CROSS APPLY #MEASURE M  WITH (NOLOCK)
                       WHERE 1=1          
                        AND M.GUBUN       = 'CELL_ITEM_ID'
                        AND M.COLUMN_NAME <> 'MKT_FCST_CELL_TOTAL'
            
            

            -------------------------------------------------------------------------------------------------------------         
            --  보정
            -------------------------------------------------------------------------------------------------------------
              UPDATE X
                 SET X.LT_DAY = 0
                FROM #SCP_XLS_PSI_GLOBAL_AUTO  X WITH (NOLOCK)
               WHERE TRANSPORT_MODE = '-'
			   
            -------------------------------------------------------------------------------------------------------------         
            --  삭제 후 입력
            -------------------------------------------------------------------------------------------------------------
              
              --DELETE FROM SCP_XLS_PSI_GLOBAL                            
              --      WHERE DIVISION_ID = @p_division_id -- AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND PLAN_TYPE = @p_plan_type AND SEQ = @p_seq              
			  
			  IF OBJECT_ID('TEMPDB..#GLOBAL_XLS_KEY') IS NOT NULL
				DROP TABLE #GLOBAL_XLS_KEY 

			  SELECT DIVISION_ID
			        ,PLAN_START_YYYYMMDD
					,@p_create_from_yyyymmdd AS create_from_yyyymmdd 
					,@p_create_to_yyyymmdd  AS create_to_yyyymmdd
			        ,PLAN_TYPE,SEQ
                    ,OPERATION_GROUP,OPERATION_GROUP_NAME,CELL_ITEM_ID,ITEM_ID,NICK_NAME,CELL_QTY_PACK,TO_SITE,TO_SITE_DESCRIPTION
                    ,(CASE WHEN LEN(PROJECT_CODE) = 0 THEN '-' ELSE PROJECT_CODE END) AS PROJECT_CODE
                    ,FROM_BOH_QTY,TO_BOH_QTY,INCOTERMS,FROM_SITE,FROM_SITE_DESCRIPTION
                    ,TRANSPORT_MODE,PROD_LINE
                    ,LT_DAY
                    ,BOD_ID,MEASURE,MEASURE_LABEL
                    ,ROW_NUMBER() OVER(ORDER BY   DIVISION_ID
												, OPERATION_GROUP DESC
                                                 ,CELL_ITEM_ID												 
												  -- 동일한 CELL ITEM ID 인경우 CELL 공정에서는 CP 해당 품목을 위에 표시
												 , CASE WHEN OPERATION_GROUP = 'P' THEN '0'
															WHEN OPERATION_GROUP = 'A' THEN  DBO.FN_GET_FINAL_ITEM(DIVISION_ID,  ITEM_ID, 'CELL_SORT') 
															ELSE '9' END
                                                 ,(CASE WHEN ATTRIBUTE1 ='DIO' THEN '-' ELSE OPERATION_GROUP END) DESC
                                                 ,ITEM_ID
--                                                 ,TO_SITE desc 
                                                 ,(CASE WHEN (TO_SITE = '-'  AND MEASURE = 'MKT_FCST_PACK_TOTAL' ) THEN 'ZZZ' 
                                                        WHEN (TO_SITE = '-'  AND MEASURE = 'MKT_FCST_CELL_TOTAL' ) THEN 'AAA' 
                                                        ELSE TO_SITE END) DESC
                                                 ,ITEM_ID
                                                 ,INCOTERMS
                                                 ,(CASE WHEN (FROM_SITE = '-'  AND MEASURE LIKE 'CELL%' ) THEN 'AAA' 
                                                   ELSE FROM_SITE END)
                                                 ,PROJECT_CODE
                                                 ,ATTRIBUTE10
                                                 ,(CASE WHEN MEASURE IN ('PACK_CELL_BOH','PACK_CELL_EOH') THEN 'ZZZ' ELSE PROD_LINE END)
                                                 ,SORT_ORDER_NO
                                                 ,TRANSPORT_MODE
                                                 ,MEASURE_LABEL DESC
                                      )  AS XLS_KEY1

                    ,XLS_KEY2
                    ,XLS_KEY3
                    ,XLS_KEY4,XLS_KEY5
                    ,XLS_ATTRIBUTE1,XLS_ATTRIBUTE2,XLS_ATTRIBUTE3,XLS_ATTRIBUTE4,XLS_ATTRIBUTE5
                    ,SORT_ORDER_NO

                    ,QTY001,QTY002,QTY003,QTY004,QTY005,QTY006,QTY007,QTY008,QTY009,QTY010,QTY011,QTY012,QTY013,QTY014,QTY015,QTY016,QTY017,QTY018,QTY019,QTY020,QTY021,QTY022,QTY023,QTY024,QTY025
                    ,QTY026,QTY027,QTY028,QTY029,QTY030,QTY031,QTY032,QTY033,QTY034,QTY035,QTY036,QTY037,QTY038,QTY039,QTY040,QTY041,QTY042,QTY043,QTY044,QTY045,QTY046,QTY047,QTY048,QTY049,QTY050
                    ,QTY051,QTY052,QTY053,QTY054,QTY055,QTY056,QTY057,QTY058,QTY059,QTY060,QTY061,QTY062,QTY063,QTY064,QTY065,QTY066,QTY067,QTY068,QTY069,QTY070,QTY071,QTY072,QTY073,QTY074,QTY075
                    ,QTY076,QTY077,QTY078,QTY079,QTY080,QTY081,QTY082,QTY083,QTY084,QTY085,QTY086,QTY087,QTY088,QTY089,QTY090,QTY091,QTY092,QTY093,QTY094,QTY095,QTY096,QTY097,QTY098,QTY099,QTY100

                    ,QTY101,QTY102,QTY103,QTY104,QTY105,QTY106,QTY107,QTY108,QTY109,QTY110,QTY111,QTY112,QTY113,QTY114,QTY115,QTY116,QTY117,QTY118,QTY119,QTY120,QTY121,QTY122,QTY123,QTY124,QTY125
                    ,QTY126,QTY127,QTY128,QTY129,QTY130,QTY131,QTY132,QTY133,QTY134,QTY135,QTY136,QTY137,QTY138,QTY139,QTY140,QTY141,QTY142,QTY143,QTY144,QTY145,QTY146,QTY147,QTY148,QTY149,QTY150
                    ,QTY151,QTY152,QTY153,QTY154,QTY155,QTY156,QTY157,QTY158,QTY159,QTY160,QTY161,QTY162,QTY163,QTY164,QTY165,QTY166,QTY167,QTY168,QTY169,QTY170,QTY171,QTY172,QTY173,QTY174,QTY175
                    ,QTY176,QTY177,QTY178,QTY179,QTY180,QTY181,QTY182,QTY183,QTY184,QTY185,QTY186,QTY187,QTY188,QTY189,QTY190,QTY191,QTY192,QTY193,QTY194,QTY195,QTY196,QTY197,QTY198,QTY199,QTY200

                    ,QTY201,QTY202,QTY203,QTY204,QTY205,QTY206,QTY207,QTY208,QTY209,QTY210,QTY211,QTY212,QTY213,QTY214,QTY215,QTY216,QTY217,QTY218,QTY219,QTY220,QTY221,QTY222,QTY223,QTY224,QTY225
                    ,QTY226,QTY227,QTY228,QTY229,QTY230,QTY231,QTY232,QTY233,QTY234,QTY235,QTY236,QTY237,QTY238,QTY239,QTY240,QTY241,QTY242,QTY243,QTY244,QTY245,QTY246,QTY247,QTY248,QTY249,QTY250
                    ,QTY251,QTY252,QTY253,QTY254,QTY255,QTY256,QTY257,QTY258,QTY259,QTY260,QTY261,QTY262,QTY263,QTY264,QTY265,QTY266,QTY267,QTY268,QTY269,QTY270,QTY271,QTY272,QTY273,QTY274,QTY275
                    ,QTY276,QTY277,QTY278,QTY279,QTY280,QTY281,QTY282,QTY283,QTY284,QTY285,QTY286,QTY287,QTY288,QTY289,QTY290,QTY291,QTY292,QTY293,QTY294,QTY295,QTY296,QTY297,QTY298,QTY299,QTY300

                    ,QTY301,QTY302,QTY303,QTY304,QTY305,QTY306,QTY307,QTY308,QTY309,QTY310,QTY311,QTY312,QTY313,QTY314,QTY315,QTY316,QTY317,QTY318,QTY319,QTY320,QTY321,QTY322,QTY323,QTY324,QTY325
                    ,QTY326,QTY327,QTY328,QTY329,QTY330,QTY331,QTY332,QTY333,QTY334,QTY335,QTY336,QTY337,QTY338,QTY339,QTY340,QTY341,QTY342,QTY343,QTY344,QTY345,QTY346,QTY347,QTY348,QTY349,QTY350
                    ,QTY351,QTY352,QTY353,QTY354,QTY355,QTY356,QTY357,QTY358,QTY359,QTY360,QTY361,QTY362,QTY363,QTY364

                    --,WQTY01,WQTY02,WQTY03,WQTY04,WQTY05,WQTY06,WQTY07,WQTY08,WQTY09,WQTY10,WQTY11,WQTY12,WQTY13,WQTY14,WQTY15,WQTY16,WQTY17,WQTY18,WQTY19,WQTY20,WQTY21,WQTY22,WQTY23,WQTY24,WQTY25
                    --,WQTY26,WQTY27,WQTY28,WQTY29,WQTY30,WQTY31,WQTY32,WQTY33,WQTY34,WQTY35,WQTY36,WQTY37,WQTY38,WQTY39,WQTY40,WQTY41,WQTY42,WQTY43,WQTY44,WQTY45,WQTY46,WQTY47,WQTY48,WQTY49,WQTY50
                    --,WQTY51,WQTY52
                    ,@p_user_id AS CREATED_BY,GETDATE() AS CREATION_DATE,@p_user_id AS LAST_UPDATED_BY,GETDATE() AS  LAST_UPDATE_DATE
                    ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9, ATTRIBUTE10
					INTO #GLOBAL_XLS_KEY
              FROM #SCP_XLS_PSI_GLOBAL_AUTO X WITH (NOLOCK)
			  
              INSERT INTO SCP_XLS_PSI_GLOBAL WITH (TABLOCK)            
              (
                DIVISION_ID,PLAN_START_YYYYMMDD
					,CREATE_FROM_YYYYMMDD
					,CREATE_TO_YYYYMMDD
				    ,PLAN_TYPE,SEQ
                    ,OPERATION_GROUP,OPERATION_GROUP_NAME,CELL_ITEM_ID,ITEM_ID,NICK_NAME,CELL_QTY_PACK,TO_SITE,TO_SITE_DESCRIPTION
                    ,PROJECT_CODE
                    ,FROM_BOH_QTY,TO_BOH_QTY,INCOTERMS,FROM_SITE,FROM_SITE_DESCRIPTION
                    ,TRANSPORT_MODE,PROD_LINE
                    ,LT_DAY
                    ,BOD_ID,MEASURE,MEASURE_LABEL
                    ,XLS_KEY1
                    ,XLS_KEY2
                    ,XLS_KEY3
                    ,XLS_KEY4,XLS_KEY5
                    ,XLS_ATTRIBUTE1,XLS_ATTRIBUTE2,XLS_ATTRIBUTE3,XLS_ATTRIBUTE4,XLS_ATTRIBUTE5
                    ,SORT_ORDER_NO

                    ,QTY001,QTY002,QTY003,QTY004,QTY005,QTY006,QTY007,QTY008,QTY009,QTY010,QTY011,QTY012,QTY013,QTY014,QTY015,QTY016,QTY017,QTY018,QTY019,QTY020,QTY021,QTY022,QTY023,QTY024,QTY025
                    ,QTY026,QTY027,QTY028,QTY029,QTY030,QTY031,QTY032,QTY033,QTY034,QTY035,QTY036,QTY037,QTY038,QTY039,QTY040,QTY041,QTY042,QTY043,QTY044,QTY045,QTY046,QTY047,QTY048,QTY049,QTY050
                    ,QTY051,QTY052,QTY053,QTY054,QTY055,QTY056,QTY057,QTY058,QTY059,QTY060,QTY061,QTY062,QTY063,QTY064,QTY065,QTY066,QTY067,QTY068,QTY069,QTY070,QTY071,QTY072,QTY073,QTY074,QTY075
                    ,QTY076,QTY077,QTY078,QTY079,QTY080,QTY081,QTY082,QTY083,QTY084,QTY085,QTY086,QTY087,QTY088,QTY089,QTY090,QTY091,QTY092,QTY093,QTY094,QTY095,QTY096,QTY097,QTY098,QTY099,QTY100

                    ,QTY101,QTY102,QTY103,QTY104,QTY105,QTY106,QTY107,QTY108,QTY109,QTY110,QTY111,QTY112,QTY113,QTY114,QTY115,QTY116,QTY117,QTY118,QTY119,QTY120,QTY121,QTY122,QTY123,QTY124,QTY125
                    ,QTY126,QTY127,QTY128,QTY129,QTY130,QTY131,QTY132,QTY133,QTY134,QTY135,QTY136,QTY137,QTY138,QTY139,QTY140,QTY141,QTY142,QTY143,QTY144,QTY145,QTY146,QTY147,QTY148,QTY149,QTY150
                    ,QTY151,QTY152,QTY153,QTY154,QTY155,QTY156,QTY157,QTY158,QTY159,QTY160,QTY161,QTY162,QTY163,QTY164,QTY165,QTY166,QTY167,QTY168,QTY169,QTY170,QTY171,QTY172,QTY173,QTY174,QTY175
                    ,QTY176,QTY177,QTY178,QTY179,QTY180,QTY181,QTY182,QTY183,QTY184,QTY185,QTY186,QTY187,QTY188,QTY189,QTY190,QTY191,QTY192,QTY193,QTY194,QTY195,QTY196,QTY197,QTY198,QTY199,QTY200

                    ,QTY201,QTY202,QTY203,QTY204,QTY205,QTY206,QTY207,QTY208,QTY209,QTY210,QTY211,QTY212,QTY213,QTY214,QTY215,QTY216,QTY217,QTY218,QTY219,QTY220,QTY221,QTY222,QTY223,QTY224,QTY225
                    ,QTY226,QTY227,QTY228,QTY229,QTY230,QTY231,QTY232,QTY233,QTY234,QTY235,QTY236,QTY237,QTY238,QTY239,QTY240,QTY241,QTY242,QTY243,QTY244,QTY245,QTY246,QTY247,QTY248,QTY249,QTY250
                    ,QTY251,QTY252,QTY253,QTY254,QTY255,QTY256,QTY257,QTY258,QTY259,QTY260,QTY261,QTY262,QTY263,QTY264,QTY265,QTY266,QTY267,QTY268,QTY269,QTY270,QTY271,QTY272,QTY273,QTY274,QTY275
                    ,QTY276,QTY277,QTY278,QTY279,QTY280,QTY281,QTY282,QTY283,QTY284,QTY285,QTY286,QTY287,QTY288,QTY289,QTY290,QTY291,QTY292,QTY293,QTY294,QTY295,QTY296,QTY297,QTY298,QTY299,QTY300

                    ,QTY301,QTY302,QTY303,QTY304,QTY305,QTY306,QTY307,QTY308,QTY309,QTY310,QTY311,QTY312,QTY313,QTY314,QTY315,QTY316,QTY317,QTY318,QTY319,QTY320,QTY321,QTY322,QTY323,QTY324,QTY325
                    ,QTY326,QTY327,QTY328,QTY329,QTY330,QTY331,QTY332,QTY333,QTY334,QTY335,QTY336,QTY337,QTY338,QTY339,QTY340,QTY341,QTY342,QTY343,QTY344,QTY345,QTY346,QTY347,QTY348,QTY349,QTY350
                    ,QTY351,QTY352,QTY353,QTY354,QTY355,QTY356,QTY357,QTY358,QTY359,QTY360,QTY361,QTY362,QTY363,QTY364

                    --,WQTY01,WQTY02,WQTY03,WQTY04,WQTY05,WQTY06,WQTY07,WQTY08,WQTY09,WQTY10,WQTY11,WQTY12,WQTY13,WQTY14,WQTY15,WQTY16,WQTY17,WQTY18,WQTY19,WQTY20,WQTY21,WQTY22,WQTY23,WQTY24,WQTY25
                    --,WQTY26,WQTY27,WQTY28,WQTY29,WQTY30,WQTY31,WQTY32,WQTY33,WQTY34,WQTY35,WQTY36,WQTY37,WQTY38,WQTY39,WQTY40,WQTY41,WQTY42,WQTY43,WQTY44,WQTY45,WQTY46,WQTY47,WQTY48,WQTY49,WQTY50
                    --,WQTY51,WQTY52
                    ,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
                    ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9, ATTRIBUTE10

              ) 
			  SELECT * FROM #GLOBAL_XLS_KEY
              

			-- 불필요한 TEMP 테이블 삭제
			IF OBJECT_ID('tempdb..#SCP_XLS_PSI_GLOBAL_AUTO') IS NOT NULL       
		            DROP TABLE #SCP_XLS_PSI_GLOBAL_AUTO   


            -------------------------------------------------------------------------------------------------------------         
            --  YIELD(CELL_CHAR_AVAILABLE), LT UPDATE 
            ------------------------------------------------------------------------------------------------------------- 
              
              UPDATE X
                 SET X.YIELD      = (CASE WHEN ISNULL(Y.SSP_MODIFY_YIELD,0) > 0.0 THEN ISNULL(Y.SSP_MODIFY_YIELD,0) ELSE ISNULL(Y.FORMATION_TOTAL_YIELD,0) END)
               FROM SCP_XLS_PSI_GLOBAL X WITH (NOLOCK)
               INNER JOIN (
                            SELECT  ITEM_ID
                                    ,PLANT_SITE_ID
                                    ,MAX(FORMATION_TOTAL_YIELD) AS FORMATION_TOTAL_YIELD
                                    ,SSP_MODIFY_YIELD
                              FROM dbo.SCP_MST_FORMATION_V Z  WITH (NOLOCK)
                              WHERE Z.DIVISION_ID = @p_division_id   
                              GROUP BY ITEM_ID 
                                    ,PLANT_SITE_ID
                                    ,SSP_MODIFY_YIELD
                          ) Y
                ON X.CELL_ITEM_ID = Y.ITEM_ID
               AND X.FROM_SITE    = Y.PLANT_SITE_ID
			   AND X.DIVISION_ID  = @p_division_id						-- 2022.03.23	KSW	        GM JV 반영
			   AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
                WHERE MEASURE   = 'CELL_CHAR_AVAILABLE'               

            -------------------------------------------------------------------------------------------------------------         
            --  PACK PROD : YIELD 
            ------------------------------------------------------------------------------------------------------------- 

              UPDATE X
                 SET X.YIELD      = ISNULL(Y.YIELD,0)
            --  SELECT X.CELL_ITEM_ID, X.ITEM_ID, X.FROM_SITE, X.TO_SITE, X.YIELD,X.MEASURE,X.PROD_LINE,Y.LINE_ID, (CASE WHEN X.PROD_LINE = Y.LINE_ID THEN 'O' ELSE 'X' END )  AS chk,Y.ITEM_ID, Y.PLANT_SITE_ID,Y.YIELD
                FROM SCP_XLS_PSI_GLOBAL X WITH (NOLOCK)
                INNER JOIN (
                             SELECT PLANT_SITE_ID,ITEM_ID,OPERATION_ID,LINE_ID,MAX(YIELD) AS YIELD
                              FROM #tmp_SCP_MST_TACT_TIME WITH(NOLOCK)
                             WHERE DIVISION_ID =@p_division_id
                               AND OPERATION_ID IN ('P9500','P5500', 'P5200')		-- PJ20214997 LGES SCP 신규 Biz, 공정 추가에 따른 모델링 개선 - MEB biz. 적용 - P5200 추가
                              GROUP BY PLANT_SITE_ID,ITEM_ID,OPERATION_ID,LINE_ID
                          ) Y
                ON X.ITEM_ID      = Y.ITEM_ID
               AND X.FROM_SITE    = Y.PLANT_SITE_ID
               AND X.ATTRIBUTE9   = Y.OPERATION_ID
               AND X.PROD_LINE    = Y.LINE_ID
			   AND X.DIVISION_ID  = @p_division_id						-- 2022.03.23	KSW	        GM JV 반영
			   AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
             WHERE MEASURE        = 'PACK_PROD'



            -------------------------------------------------------------------------------------------------------------         
            -- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - 전진검사 LT 적용 - START
            ------------------------------------------------------------------------------------------------------------- 
			-- 중장기 :: 첫 1 YEAR 만 적용
			--
			IF (@p_plan_start_yyyymmdd = @p_create_from_yyyymmdd)
			BEGIN   
			  -- 0값으로 초기화 (하이픈을 0 으로 통일)
              UPDATE X
                 SET X.LT_DAY = 0
               FROM SCP_XLS_PSI_GLOBAL X WITH (NOLOCK)
			   WHERE X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
			    AND X.DIVISION_ID  = @p_division_id						-- 2022.03.23	KSW	        GM JV 반영
                AND MEASURE   = 'PACK_BOH' 
			
			  -- 실제값으로 Update
              UPDATE X
                 SET X.LT_DAY = CEILING(Y.LT_DAY / 7.0)				-- Y.LT_DAY :: 2022.05.31 일수에서 주수로 변경
               FROM SCP_XLS_PSI_GLOBAL X WITH (NOLOCK)
               INNER JOIN (
                            SELECT LT_DAY, SCM_SITE_ID, ITEM_ID
							  FROM SCP_MST_OPERATION_LT WITH (NOLOCK) 
							 WHERE DIVISION_ID = @p_division_id
							   AND LT_OPERATION = 'PRE_INSP'
                          ) Y
                ON X.ITEM_ID    = Y.ITEM_ID
               AND X.FROM_SITE  = Y.SCM_SITE_ID
			   AND X.DIVISION_ID  = @p_division_id						-- 2022.03.23	KSW	        GM JV 반영
			   AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
                WHERE MEASURE   = 'PACK_BOH'  
			END 
			-- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - 전진검사 LT 적용 - START


             /*
            -------------------------------------------------------------------------------------------------------------    
            -- SCP_ANL_PSI_GLOBAL.MODEL_INVENTORY --> SCP_XLS_PSI_GLOBAL.PACK_BOH
            -------------------------------------------------------------------------------------------------------------    
               SELECT DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,CELL_ITEM_ID,ITEM_ID,FROM_SITE,QTY
                INTO #SCP_XLS_PSI_GLOBAL_AUTO_MODEL_INVENTORY
                FROM SCP_ANL_PSI_GLOBAL X  WITH (NOLOCK)
                 WHERE X.DIVISION_ID			    =  @p_division_id
		                AND X.PLAN_START_YYYYMMDD	=  @p_plan_start_yyyymmdd
		                AND X.PLAN_TYPE				    =  @p_plan_type
		                AND X.SEQ					        =  @p_seq
                    AND X.MEASURE             = 'MODEL_INVENTORY'
                    AND X.YYYYMMDD            = @p_plan_start_yyyymmdd

              UPDATE X
                SET X.QTY001            = Y.QTY
                FROM SCP_XLS_PSI_GLOBAL X  WITH (NOLOCK)
                INNER JOIN #SCP_XLS_PSI_GLOBAL_AUTO_MODEL_INVENTORY Y WITH (NOLOCK)
                ON X.DIVISION_ID   = Y.DIVISION_ID
                AND X.FROM_SITE    = Y.FROM_SITE
                AND X.ITEM_ID      = Y.ITEM_ID
                AND X.MEASURE      ='PACK_BOH'
            */

            -------------------------------------------------------------------------------------------------------------         
            --  UPDATE
            -------------------------------------------------------------------------------------------------------------     

                UPDATE X
                   SET ITEM_ID      = ( SELECT TOP 1 CHILD_ITEM_ID
                                               FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V AS Y WITH (NOLOCK)
                                              WHERE Y.DIVISION_ID        = X.DIVISION_ID
                                                AND Y.MODEL_ID           = X.ITEM_ID
                                                AND Y.OPERATION_GROUP_ID = 'A'
												/* 2023.07.01 추가 */
												AND Y.CELL_TYPE          = 'CP'    
												)
                      ,TO_SITE                = '-'
                      ,TO_SITE_DESCRIPTION    = '-'
                      ,PROJECT_CODE           = '-'
                      ,INCOTERMS              = '-'
                      ,PROD_LINE              = '-'
                FROM SCP_XLS_PSI_GLOBAL X  WITH (NOLOCK)
                 WHERE OPERATION_GROUP   = 'P'
                 AND MEASURE IN ('PACK_CELL_BOH','PACK_CELL_EOH')
				 AND DIVISION_ID  = @p_division_id						-- 2022.03.23	KSW	        GM JV 반영
				 AND CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가

                 UPDATE X
                   SET X.NICK_NAME = (SELECT TOP 1 (CASE WHEN Y.NICK_NAME IS NULL THEN '-'  WHEN Y.NICK_NAME = ''    THEN '-'  ELSE Y.NICK_NAME END) 
                                        FROM DBO.SCM_MST_ITEM_SN Y WITH (NOLOCK)  WHERE  Y.ITEM_ID  = X.ITEM_ID AND Y.NICK_NAME IS NOT NULL)			-- 2021.05.27   KSW         NICK NAME 누락오류 수정 :: AND Y.NICK_NAME IS NOT NULL 추가
                 FROM SCP_XLS_PSI_GLOBAL X  WITH (NOLOCK)
                 WHERE OPERATION_GROUP   = 'P'
                 AND MEASURE IN ('PACK_CELL_BOH','PACK_CELL_EOH')  
				 AND DIVISION_ID  = @p_division_id						-- 2022.03.23	KSW	        GM JV 반영				 
				 AND CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
              
			-------------------------------------------------------------------------------------------------------------         
            --- 활성화코드 PACK의 CELL ASSAY는 CP로 표기::2023.06.20, KSK
            -------------------------------------------------------------------------------------------------------------
				UPDATE  SCP_XLS_PSI_GLOBAL 
				 SET ITEM_ID  =  CELL_ITEM_ID
				WHERE OPERATION_GROUP   = 'P'
				AND DBO.FN_GET_FINAL_ITEM(DIVISION_ID, ITEM_ID, 'IS_CA') = 'Y' ;             
                 
               UPDATE X
                  SET X.CELL_QTY_PACK = (SELECT TOP 1 CONVERT(NVARCHAR(50), CEILING(V.ACCUMULATED_CHILD_QTY))
                              	          FROM DBO.SCM_MST_MODEL_FINAL_ITEM_BOM_V V WITH (NOLOCK)					
                                          WHERE V.DIVISION_ID         = X.DIVISION_ID 
                                	          AND V.OPERATION_GROUP_ID  = 'A'
                                	          AND V.MODEL_ID            = X.ITEM_ID
                                	          AND V.CHILD_ITEM_ID       = X.CELL_ITEM_ID
                                         )
                 FROM SCP_XLS_PSI_GLOBAL  X WITH (NOLOCK)
                  WHERE 0 = 0
                  AND X.OPERATION_GROUP='P'
				  AND X.DIVISION_ID  = @p_division_id						-- 2022.03.23	KSW	        GM JV 반영
				  AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
			
				              							 
                  DELETE TBL FROM
	                (
	                        SELECT
	                               ROW_NUMBER() OVER (PARTITION BY CELL_ITEM_ID, ITEM_ID,FROM_SITE   ORDER BY XLS_KEY1 desc ) AS ROWNUM
	                        FROM SCP_XLS_PSI_GLOBAL  WITH (NOLOCK)
                          WHERE MEASURE IN ('PACK_CELL_BOH')
						  AND DIVISION_ID          = @p_division_id						-- 2022.03.23	KSW	        GM JV 반영
						  AND CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
	                ) AS TBL
	                WHERE TBL.ROWNUM > 1


                   DELETE TBL FROM
	                (
	                        SELECT
	                               ROW_NUMBER() OVER (PARTITION BY CELL_ITEM_ID, ITEM_ID,FROM_SITE  ORDER BY XLS_KEY1 desc) AS ROWNUM
	                        FROM SCP_XLS_PSI_GLOBAL
                          WHERE MEASURE IN ('PACK_CELL_EOH')
						  AND DIVISION_ID          = @p_division_id						-- 2022.03.23	KSW	        GM JV 반영
						  AND CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
	                ) AS TBL
	                WHERE TBL.ROWNUM > 1
                  
                  --SEMI_SHIP_PLAN 해상재고 추가로 인한 중복 발생을 제거 하기 위해서
                  DELETE TBL FROM
	                (
	                        SELECT
	                               ROW_NUMBER() OVER (PARTITION BY CELL_ITEM_ID, ITEM_ID,TO_SITE,FROM_SITE,TRANSPORT_MODE, BOD_ID   ORDER BY BOD_ID desc ) AS ROWNUM		-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 BOD_ID 추가
	                        FROM SCP_XLS_PSI_GLOBAL  WITH (NOLOCK)
                         WHERE MEASURE IN ('SEMI_SHIP_PLAN')
						 AND DIVISION_ID          = @p_division_id						-- 2022.03.23	KSW	        GM JV 반영
						 AND CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
	                ) AS TBL

	                WHERE TBL.ROWNUM > 1

                  --UPDATE X
                  --   SET X.LT_DAY = Y.LT_FORMATION + CONVERT(INT, ISNULL(Y.ATTRIBUTE1, '0')) -- AS LT_FORMATION
                  --   --SELECT Y.LT_FORMATION + CONVERT(INT, ISNULL(Y.ATTRIBUTE1, '0')) AS LT_FORMATION,*
                  --    FROM SCP_XLS_PSI_GLOBAL X  WITH (NOLOCK)
                  --   INNER JOIN SCP_MST_FORMATION Y WITH (NOLOCK)
                  --   ON X.DIVISION_ID   = Y.DIVISION_ID
                  --   AND X.FROM_SITE    = Y.PLANT_SITE_ID
                  --   AND X.ITEM_ID      = Y.ITEM_ID
                  --   AND X.MEASURE      ='CELL_PROD'          


                  DELETE FROM SCP_XLS_PSI_GLOBAL
                  WHERE MEASURE ='SHIP_PLAN' 
                    AND TRANSPORT_MODE = '-'
					AND DIVISION_ID    = @p_division_id						-- 2022.03.23	KSW	        GM JV 반영
					AND CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가


            -------------------------------------------------------------------------------------------------------------         
            -- BOH 반영(SCP_XLS_BOH)
            -------------------------------------------------------------------------------------------------------------       
			-- 중장기 :: 첫 1 YEAR 만 적용
			--
			IF (@p_plan_start_yyyymmdd = @p_create_from_yyyymmdd)
			BEGIN

               IF OBJECT_ID('tempdb..#BOH') IS NOT NULL	
	                DROP TABLE #BOH

                  SELECT DIVISION_ID
                         ,PLAN_START_YYYYMMDD
                         ,PLAN_TYPE
                         ,SEQ
                         ,SCM_SITE_ID
                         ,INCOTERMS
                         ,ITEM_ID
                         ,SUM(QTY)        AS QTY
                       --  ,ORIGIN_ITEM_ID
                       --  ,SUM(ORIGIN_QTY) AS ORIGIN_QTY
                   INTO #BOH
                   FROM SCP_XLS_BOH  WITH (NOLOCK)
                  WHERE DIVISION_ID           = @p_division_id
                    AND PLAN_START_YYYYMMDD   = @p_plan_start_yyyymmdd
                    AND PLAN_TYPE             = @p_plan_type
                    AND SEQ                   = @p_seq
                    AND ISNULL(ORIGIN_ITEM_ID,'') = ''  
                  GROUP BY DIVISION_ID
                         ,PLAN_START_YYYYMMDD
                         ,PLAN_TYPE
                         ,SEQ
                         ,SCM_SITE_ID
                         ,INCOTERMS
                         ,ITEM_ID
                       --  ,ORIGIN_ITEM_ID

			   -- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 [추가개선] - Pack BOH 수량에서 Hold 수량제외 - start
			   -- HOLD 가 포함되지 않음 - PACK HOLD 만 해당
               IF OBJECT_ID('tempdb..#BOH_NHOLD') IS NOT NULL	
	                DROP TABLE #BOH_NHOLD

                  SELECT DIVISION_ID
                         ,PLAN_START_YYYYMMDD
                         ,PLAN_TYPE
                         ,SEQ
                         ,SCM_SITE_ID
                         ,INCOTERMS
                         ,ITEM_ID
                         ,SUM(QTY)        AS QTY
                       --  ,ORIGIN_ITEM_ID
                       --  ,SUM(ORIGIN_QTY) AS ORIGIN_QTY
                   INTO #BOH_NHOLD
                   FROM SCP_XLS_BOH  WITH (NOLOCK)
                  WHERE DIVISION_ID           = @p_division_id
                    AND PLAN_START_YYYYMMDD   = @p_plan_start_yyyymmdd
                    AND PLAN_TYPE             = @p_plan_type
                    AND SEQ                   = @p_seq
                    AND ISNULL(ORIGIN_ITEM_ID,'') = ''  
					AND NOT ATTRIBUTE10       LIKE '%HOLD'			-- Pack BOH 수량에서 Hold 수량제외
                  GROUP BY DIVISION_ID
                         ,PLAN_START_YYYYMMDD
                         ,PLAN_TYPE
                         ,SEQ
                         ,SCM_SITE_ID
                         ,INCOTERMS
                         ,ITEM_ID

                UPDATE X
                  SET X.QTY001 = ISNULL(Y.QTY,0)
                 FROM SCP_XLS_PSI_GLOBAL X WITH (NOLOCK)
                 INNER JOIN #BOH_NHOLD Y WITH (NOLOCK)   
                  ON 0 = 0
                  AND X.FROM_SITE            = Y.SCM_SITE_ID      
                  AND X.ITEM_ID              = Y.ITEM_ID    
                  AND X.MEASURE              = 'PACK_BOH'
				  AND X.DIVISION_ID          = @p_division_id						-- 2022.03.23	KSW	        GM JV 반영
				  AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가

			   -- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 [추가개선] - Pack BOH 수량에서 Hold 수량제외 - end


                UPDATE X
                  SET X.QTY001 = ISNULL(Y.QTY,0)
                 FROM SCP_XLS_PSI_GLOBAL X WITH (NOLOCK)
                 INNER JOIN #BOH Y WITH (NOLOCK)   
                  ON 0 = 0
                  AND X.FROM_SITE            = Y.SCM_SITE_ID      
                  AND X.ITEM_ID              = Y.ITEM_ID    
				  -- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 [추가개선] - Pack BOH 수량에서 Hold 수량제외
                  --AND X.MEASURE              IN ('PACK_BOH','CELL_BOH','PACK_CELL_BOH')
				  AND X.MEASURE              IN ('CELL_BOH','PACK_CELL_BOH')
				  AND X.DIVISION_ID          = @p_division_id						-- 2022.03.23	KSW	        GM JV 반영
				  AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가



                 -- -- 보류중 해제일자가 없는수량
                 UPDATE X
                  SET X.QTY001 = ISNULL(X.QTY001,0) - ISNULL(Y.QTY,0)
                 FROM SCP_XLS_PSI_GLOBAL X WITH (NOLOCK)
                 INNER JOIN (SELECT ITEM_ID, FROM_SITE, SUM(Y.QTY) AS QTY
                                 FROM #PLN_TH_ENG_STOCK_PLAN Y  WITH (NOLOCK)
                                WHERE DESCR ='WH_HOLD'
                                GROUP BY ITEM_ID,FROM_SITE
                             )   Y    
                  ON 0 = 0
                  AND X.FROM_SITE            = Y.FROM_SITE      
                  AND X.ITEM_ID              = Y.ITEM_ID    
                  AND X.MEASURE              IN ('CELL_BOH','PACK_CELL_BOH')		-- 2022.08.30   KSW	Cell 재고 개선건 - PACK_CELL_BOH	Cell BOH measure 에서 HOLD 수량제외
				  AND X.DIVISION_ID          = @p_division_id						-- 2022.03.23	KSW	        GM JV 반영
				  AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
                


                UPDATE X
                 SET X.QTY001 = ISNULL(Y.QTY,0)      
                 FROM SCP_XLS_PSI_GLOBAL X WITH (NOLOCK)
                 INNER JOIN #BOH Y WITH (NOLOCK)   
                  ON 0 = 0
                  AND X.TO_SITE               = Y.SCM_SITE_ID      
                  AND X.ITEM_ID               = Y.ITEM_ID    
                  AND X.MEASURE               = 'TO_SITE_BOH'
                  AND X.INCOTERMS             = Y.INCOTERMS    
				  AND X.DIVISION_ID           = @p_division_id						-- 2022.03.23	KSW	        GM JV 반영
                  AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가

			-------------------------------------------------------------------------------------------------------------
			-- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - Pack BOH(Wait for Inspection) 추가 - start
			-------------------------------------------------------------------------------------------------------------
                 UPDATE X
                    SET X.QTY001 = ISNULL(Z.QTY,0)
                   FROM SCP_XLS_PSI_GLOBAL X WITH (NOLOCK)
                   INNER JOIN (SELECT ITEM_ID, FROM_SITE, SUM(Y.QTY) AS QTY
                                FROM #PLN_TH_ENG_STOCK_PLAN_INSP Y WITH (NOLOCK)
                               WHERE Y.INSP_TYPE = 'INSP_PRE'
							     --AND Y.YYYYMMDD < DATEADD(day, 7, CONVERT(DATE, @p_plan_start_yyyymmdd))
                               GROUP BY Y.ITEM_ID, Y.FROM_SITE
                              ) Z  
                      ON X.ITEM_ID    = Z.ITEM_ID                        
                     AND X.FROM_SITE  = Z.FROM_SITE 
                     AND X.MEASURE    = 'PACK_BOH_WAIT_FOR_INSP'
					 AND X.DIVISION_ID          = @p_division_id						-- 2022.03.23	KSW	        GM JV 반영
					 AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd
			-- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - Pack BOH(Wait for Inspection) 추가 - end
 


            --/*
			-- 2022.07.29   KSW         DIO Report에서 사용되는 GRO_STD_DIO, MIN_STD_DIO 으로 대체 - start
            -------------------------------------------------------------------------------------------------------------         
            --  DIO 관련 시뮬레이션 추가 
            --  2020.06.25   KTH         DIO 수정 관련
            ------------------------------------------------------------------------------------------------------------- 
              IF OBJECT_ID('tempdb..#tmp_SCP_MST_DIO_OLD') IS NOT NULL	
	              DROP TABLE #tmp_SCP_MST_DIO_OLD

			-- 변경전 주석처리
			-- 81 (자동차) 사업부만 해당
			IF @p_division_id <> '81'
			BEGIN

              SELECT a.DIVISION_ID, a.PLANT_ID, ITEM_ID,a.GRO_STD_DIO,MIN_STD_DIO
                INTO #tmp_SCP_MST_DIO_OLD
                FROM   SCP_MST_DIO A WITH(NOLOCK) 
                INNER JOIN (SELECT DIVISION_ID, PLANT_ID, MAX(YYYYQ) AS YYYYQ
                            FROM   SCP_MST_DIO WITH(NOLOCK) 
                            WHERE  DIVISION_ID IS NOT NULL
                            GROUP BY DIVISION_ID, PLANT_ID
                          ) B
                ON  A.DIVISION_ID = B.DIVISION_ID
                AND A.PLANT_ID    = B.PLANT_ID
                AND A.YYYYQ      = B.YYYYQ
                AND A.DIVISION_ID = @p_division_id
                --and a.YYYYMM      like '201912' -- @p_plan_start_yyyymmdd -- 


              UPDATE X
                 SET X.ATTRIBUTE4   = Z.GRO_STD_DIO
                    ,X.ATTRIBUTE5   = Z.MIN_STD_DIO
               FROM SCP_XLS_PSI_GLOBAL X WITH (NOLOCK)
               INNER JOIN #tmp_SCP_MST_DIO_OLD Z  WITH (NOLOCK)
                ON X.CELL_ITEM_ID   = Z.ITEM_ID
               -- AND X.FROM_SITE   = Z.PLANT_ID
			   AND X.DIVISION_ID    = @p_division_id						-- 2022.03.23	KSW	        GM JV 반영
			   AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
                WHERE MEASURE       = 'ALLOCATION_DIO'
			END


			IF @p_division_id = '81'
			BEGIN

              IF OBJECT_ID('tempdb..#tmp_SCP_MST_DIO') IS NOT NULL	
	              DROP TABLE #tmp_SCP_MST_DIO

				-- 변경후
				declare @p_get_plan_start_yyyymmdd		nvarchar(20) = '';
				declare @p_get_seq						nvarchar(20) = '';
				declare @p_get_ver						nvarchar(20) = '';
				declare @p_get_plan_type				nvarchar(20) = 'FN';

				-- FN 플랜중에서 최신건
				SELECT @p_get_plan_start_yyyymmdd = A.PLAN_START_YYYYMMDD 
					  ,@p_get_seq = MAX(A.SEQ)
					  ,@p_get_ver = MAX(A.VER)
				  FROM SCP_ANL_DIO_REPORT A with (nolock)
				 WHERE A.DIVISION_ID         = @p_division_id
				   AND A.PLAN_START_YYYYMMDD = (SELECT MAX(B.PLAN_START_YYYYMMDD) FROM SCP_ANL_DIO_REPORT B WITH (NOLOCK) WHERE B.DIVISION_ID = @p_division_id AND B.PLAN_TYPE = 'FN')
				   AND A.PLAN_TYPE           = 'FN'
				 GROUP BY A.PLAN_START_YYYYMMDD
				;

				-- PLAN_START_YYYYMMDD 기준으로 전주차 FN 이 없을 경우 --> 최신건
				IF @p_get_plan_start_yyyymmdd <> CONVERT(VARCHAR(8), DATEADD(day, -7, @p_plan_start_yyyymmdd), 112)
				BEGIN
					SET @p_get_plan_start_yyyymmdd = '';
					SET @p_get_seq = '';
					SET @p_get_ver = '';
					SET @p_get_plan_type = '';

					SELECT @p_get_plan_start_yyyymmdd = A.PLAN_START_YYYYMMDD 
						  ,@p_get_seq = MAX(A.SEQ)
						  ,@p_get_ver = MAX(A.VER)
						  ,@p_get_plan_type = A.PLAN_TYPE
					  FROM SCP_ANL_DIO_REPORT A with (nolock)
					 WHERE A.DIVISION_ID         = @p_division_id
					   AND A.PLAN_START_YYYYMMDD = (SELECT MAX(PLAN_START_YYYYMMDD) FROM SCP_ANL_DIO_REPORT B with (nolock) WHERE DIVISION_ID = '81')
					 GROUP BY A.PLAN_START_YYYYMMDD, A.PLAN_TYPE
				;
				END 

				-- 시뮬레이터에 적용할 경우, cell_item_id 기준으로 CELL 만 존재하는 건과 PACK/CELL 이 모두 있는 건으로 나누어서 업데이트 필요 !!!
				SELECT DIVISION_ID
					  ,ROUND(CELL_SUM + PACK_SUM + DEPARTURE_DAYS_INTRANSIT_VMI2 + SAFETY_STOCK_SUM + PRODUCTION_CYCLE_SUM, 2) AS GRO_STD_DIO
					  ,ROUND(CELL_SUM + PACK_SUM + DEPARTURE_DAYS_INTRANSIT_VMI2, 2) AS MIN_STD_DIO
					  ,FROM_SITE
					  ,NICK_NAME
					  ,CELL_ITEM_ID
					  ,ITEM_ID
					  ,TO_SITE
				  INTO #tmp_SCP_MST_DIO
				  FROM (
						SELECT RTRIM(DIVISION_ID)				AS DIVISION_ID
							  ,RTRIM(FROM_SITE) AS FROM_SITE
							  ,FROM_SITE_DESCRIPTION
							  ,RTRIM(ITEM_ID)	AS ITEM_ID
							  ,CELL_ITEM_ID
							  ,TO_SITE
							  ,NICK_NAME

							  ,ISNULL(CELL_AGING_LT, 0)			AS CELL_AGING_LT
							  ,ISNULL(CELL_EOL_SHIPPING_LOT, 0) AS CELL_EOL_SHIPPING_LOT
							  ,ISNULL(CELL_AGING_LT, 0) + ISNULL(CELL_EOL_SHIPPING_LOT, 0)	AS CELL_SUM

							  ,ISNULL(PACK_INCOMMING, 0)        AS PACK_INCOMMING
							  ,ISNULL(PACK_OPERATION_LT, 0)     AS PACK_OPERATION_LT
							  ,ISNULL(PACK_INCOMMING, 0) + ISNULL(PACK_OPERATION_LT, 0)		AS PACK_SUM

							  ,ISNULL(SHIPMENT_CELL_INSPECTION_LOAD, 0)
							  + ISNULL(SHIPMENT_CELL_INSPECTION_WAITING, 0)
							  + ISNULL(SHIPMENT_PACK_INSPECTION_LOAD, 0)
							  + ISNULL(SHIPMENT_PACK_INSPECTION_WAITING, 0)
							  + ISNULL(DNI_CELL_DEPARTURE_DAYS, 0) 
							  + ISNULL(DNI_CELL_DEPARTURE_INLAND, 0) 
							  + ISNULL(DNI_CELL_WAITING_FOR_SHIPPING, 0) 
							  + ISNULL(DNI_CELL_VOYAGE, 0) 
							  + ISNULL(DNI_CELL_LAY_OFF_CUSTOMS_CLEARANCE, 0) 
							  + ISNULL(DNI_CELL_ARRIVAL_INLAND, 0) 
							  + ISNULL(DNI_PACK_DEPARTURE_DAYS, 0)
							  + ISNULL(DNI_PACK_DEPARTURE_INLAND, 0)
							  + ISNULL(DNI_PACK_WAITING_FOR_SHIPPING, 0)
							  + ISNULL(DNI_PACK_VOYAGE, 0) 
							  + ISNULL(DNI_PACK_LAY_OFF_CUSTOMS_CLEARANCE, 0)
							  + ISNULL(DNI_PACK_ARRIVAL_INLAND, 0)
							  + ISNULL(PRE_INSPECTION_CELL, 0)
							  + ISNULL(PRE_INSPECTION_PACK, 0)
							  + ISNULL(VMI_CELL, 0)
							  + ISNULL(VMI_PACK, 0)
							  + ISNULL(FOREIGN_CORP, 0)
							  + ISNULL(RACK_BIZ, 0)
							  + ISNULL(DEPARTURE_INTRANSIT_VMI, 0) AS DEPARTURE_DAYS_INTRANSIT_VMI

							  ,ISNULL(SAFETY_STOCK_CELL, 0) AS SAFETY_STOCK_CELL
							  ,ISNULL(SAFETY_STOCK_PACK, 0) AS SAFETY_STOCK_PACK
							  ,ISNULL(SAFETY_STOCK_CELL, 0) + ISNULL(SAFETY_STOCK_PACK, 0)	AS SAFETY_STOCK_SUM

							  ,ISNULL(PRODUCTION_CYCLE_CELL, 0) AS PRODUCTION_CYCLE_CELL
							  ,ISNULL(PRODUCTION_CYCLE_PACK, 0) AS PRODUCTION_CYCLE_PACK
							  ,ISNULL(PRODUCTION_CYCLE_CELL, 0) + ISNULL(PRODUCTION_CYCLE_PACK, 0)	AS PRODUCTION_CYCLE_SUM

							  ,ISNULL(STANDARD_DIO, 0) AS STANDARD_DIO_AUTO		-- 현업 사용자가 수정한 값
							  ,ISNULL(DEPARTURE_INTRANSIT_VMI, 0) AS DEPARTURE_DAYS_INTRANSIT_VMI2

						  FROM SCP_ANL_DIO_REPORT A WITH (NOLOCK)
						 WHERE A.DIVISION_ID			= @p_division_id
						   AND A.PLAN_START_YYYYMMDD	= @p_get_plan_start_yyyymmdd
						   AND A.PLAN_TYPE				= @p_get_plan_type
						   AND A.SEQ					= @p_get_seq
						   AND A.VER					= @p_get_ver
					   ) AA
					   ;

				-- NICK NAME 
				  IF OBJECT_ID('tempdb..#tmp_NICK_NAME') IS NOT NULL	
					  DROP TABLE #tmp_NICK_NAME

				SELECT  --ISNULL(ISNULL(LEVEL4, CELL_GROUP), ISNULL(BASIC_NICKNAME_CELL, ISNULL(NICK_NAME, ITEM_ID) )) AS NICK_NAME2
					   DISTINCT ITEM_ID, NICK_NAME
				  INTO #tmp_NICK_NAME
				  FROM (
						SELECT F.DIVISION_ID
							, F.ITEM_ID 
							, F.GROUP_CODE5	AS LEVEL4
							, F.GROUP_CODE1	AS CELL_GROUP
			
							, CASE WHEN F.OPERATION_GROUP = 'P' THEN 
										(SELECT NICK_NAME 
										   FROM SCP_MST_FINAL_ITEM B WITH(NOLOCK) 
										  WHERE B.DIVISION_ID = F.DIVISION_ID 
											AND B.ITEM_ID = (SELECT TOP 1 DOE 
															   FROM SCM_MST_ITEM_SN B WITH(NOLOCK) 
															  WHERE B.DIVISION_ID = F.DIVISION_ID 
																AND B.ITEM_ID = F.ATTRIBUTE1 
																AND B.DOE IS NOT NULL
															 )
										) 
								   ELSE (SELECT NICK_NAME 
										  FROM SCP_MST_FINAL_ITEM B WITH(NOLOCK)
										  WHERE B.DIVISION_ID = F.DIVISION_ID 
											AND B.ITEM_ID = (SELECT TOP 1 DOE 
															   FROM SCM_MST_ITEM_SN B WITH(NOLOCK) 
															  WHERE B.DIVISION_ID = F.DIVISION_ID 
																AND B.ITEM_ID = F.ITEM_ID 
																AND B.DOE IS NOT NULL
															  )
										 ) 
									END AS BASIC_NICKNAME_CELL
							, F.NICK_NAME
						FROM SCP_MST_FINAL_ITEM F WITH (NOLOCK)
					   WHERE F.DIVISION_ID = @p_division_id
				) AA
				;

				-- PSI UPDATE
				/*
				  UPDATE X
					 SET X.ATTRIBUTE4   = Z.GRO_STD_DIO
						,X.ATTRIBUTE5   = Z.MIN_STD_DIO
				   FROM SCP_XLS_PSI_GLOBAL X WITH (NOLOCK)
				   INNER JOIN #tmp_NICK_NAME N
					ON X.CELL_ITEM_ID         = N.ITEM_ID
				   INNER JOIN #tmp_SCP_MST_DIO Z  WITH (NOLOCK)
					ON N.NICK_NAME            = Z.NICK_NAME		
				 WHERE X.DIVISION_ID          = @p_division_id
				   AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd
				   AND X.MEASURE              = 'ALLOCATION_DIO'
				   ;
				   */

				-- PSI UPDATE :: SCP_MST_FINAL_ITEM.GROUP_CODE1 적용버전
				  UPDATE X
					 SET X.ATTRIBUTE4   = Z.GRO_STD_DIO
						,X.ATTRIBUTE5   = Z.MIN_STD_DIO
				   FROM SCP_XLS_PSI_GLOBAL X WITH (NOLOCK)
				  INNER JOIN DBO.SCP_MST_FINAL_ITEM N WITH (NOLOCK)
					 ON X.DIVISION_ID         = N.DIVISION_ID
					AND X.CELL_ITEM_ID        = N.ITEM_ID
				   INNER JOIN #tmp_SCP_MST_DIO Z  WITH (NOLOCK)
					ON N.GROUP_CODE1          = Z.NICK_NAME		
				 WHERE X.DIVISION_ID          = @p_division_id
				   AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd
				   AND X.MEASURE              = 'ALLOCATION_DIO'
				   ;
			END
			-- 2022.07.29   KSW         DIO Report에서 사용되는 GRO_STD_DIO, MIN_STD_DIO 으로 대체 - end

			END		-- IF (@p_plan_start_yyyymmdd = @p_create_from_yyyymmdd)		중장기 :: 첫 1 YEAR 만 적용

			-------------------------------------------------------------------------------------------------------------
			-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계- start
			-- BOD_ID에 대한 from_yyyymmdd, to_yyyymmdd 추가 --> ATTRIBUTE3
			-------------------------------------------------------------------------------------------------------------
			UPDATE X
                 SET X.ATTRIBUTE3   = Z.FROM_YYYYMMDD + ',' + Z.TO_YYYYMMDD
               FROM SCP_XLS_PSI_GLOBAL X WITH (NOLOCK)
               INNER JOIN DBO.SCP_MST_BOD_N_V Z  WITH (NOLOCK)
                ON X.BOD_ID   = Z.BOD_ID
				AND X.DIVISION_ID  = @p_division_id						-- 2022.03.23	KSW	        GM JV 반영
                WHERE MEASURE IN ('SHIP_PLAN', 'SEMI_SHIP_PLAN')
			-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계- end

           
            -------------------------------------------------------------------------------------------------------------         
            --  52주 데이터 SCRIPT 생성후 UPDATE 
            -------------------------------------------------------------------------------------------------------------     
            
             IF OBJECT_ID('tempdb..#Rn') IS NOT NULL	
	            DROP TABLE #Rn

                 CREATE TABLE #Rn
                  ( 
                     WEEK_COLUMN NVARCHAR(6)
                    ,Rn INT
                  )

                  INSERT INTO #Rn
                  SELECT 'WQTY01',	1	  UNION ALL	SELECT 'WQTY01',	2	  UNION ALL	SELECT 'WQTY01',	3	  UNION ALL	SELECT 'WQTY01',	4	  UNION ALL	SELECT 'WQTY01',	5	  UNION ALL	SELECT 'WQTY01',	6	  UNION ALL	SELECT 'WQTY01',	7	  UNION ALL
                  SELECT 'WQTY02',	8	  UNION ALL	SELECT 'WQTY02',	9	  UNION ALL	SELECT 'WQTY02',	10	UNION ALL	SELECT 'WQTY02',	11	UNION ALL	SELECT 'WQTY02',	12	UNION ALL	SELECT 'WQTY02',	13	UNION ALL	SELECT 'WQTY02',	14	UNION ALL
                  SELECT 'WQTY03',	15	UNION ALL	SELECT 'WQTY03',	16	UNION ALL	SELECT 'WQTY03',	17	UNION ALL	SELECT 'WQTY03',	18	UNION ALL	SELECT 'WQTY03',	19	UNION ALL	SELECT 'WQTY03',	20	UNION ALL	SELECT 'WQTY03',	21	UNION ALL
                  SELECT 'WQTY04',	22	UNION ALL	SELECT 'WQTY04',	23	UNION ALL	SELECT 'WQTY04',	24	UNION ALL	SELECT 'WQTY04',	25	UNION ALL	SELECT 'WQTY04',	26	UNION ALL	SELECT 'WQTY04',	27	UNION ALL	SELECT 'WQTY04',	28	UNION ALL
                  SELECT 'WQTY05',	29	UNION ALL	SELECT 'WQTY05',	30	UNION ALL	SELECT 'WQTY05',	31	UNION ALL	SELECT 'WQTY05',	32	UNION ALL	SELECT 'WQTY05',	33	UNION ALL	SELECT 'WQTY05',	34	UNION ALL	SELECT 'WQTY05',	35	UNION ALL
                  SELECT 'WQTY06',	36	UNION ALL	SELECT 'WQTY06',	37	UNION ALL	SELECT 'WQTY06',	38	UNION ALL	SELECT 'WQTY06',	39	UNION ALL	SELECT 'WQTY06',	40	UNION ALL	SELECT 'WQTY06',	41	UNION ALL	SELECT 'WQTY06',	42	UNION ALL
                  SELECT 'WQTY07',	43	UNION ALL	SELECT 'WQTY07',	44	UNION ALL	SELECT 'WQTY07',	45	UNION ALL	SELECT 'WQTY07',	46	UNION ALL	SELECT 'WQTY07',	47	UNION ALL	SELECT 'WQTY07',	48	UNION ALL	SELECT 'WQTY07',	49	UNION ALL
                  SELECT 'WQTY08',	50	UNION ALL	SELECT 'WQTY08',	51	UNION ALL	SELECT 'WQTY08',	52	UNION ALL	SELECT 'WQTY08',	53	UNION ALL	SELECT 'WQTY08',	54	UNION ALL	SELECT 'WQTY08',	55	UNION ALL	SELECT 'WQTY08',	56	UNION ALL
                  SELECT 'WQTY09',	57	UNION ALL	SELECT 'WQTY09',	58	UNION ALL	SELECT 'WQTY09',	59	UNION ALL	SELECT 'WQTY09',	60	UNION ALL	SELECT 'WQTY09',	61	UNION ALL	SELECT 'WQTY09',	62	UNION ALL	SELECT 'WQTY09',	63	UNION ALL
                  SELECT 'WQTY10',	64	UNION ALL	SELECT 'WQTY10',	65	UNION ALL	SELECT 'WQTY10',	66	UNION ALL	SELECT 'WQTY10',	67	UNION ALL	SELECT 'WQTY10',	68	UNION ALL	SELECT 'WQTY10',	69	UNION ALL	SELECT 'WQTY10',	70	UNION ALL
                  SELECT 'WQTY11',	71	UNION ALL	SELECT 'WQTY11',	72	UNION ALL	SELECT 'WQTY11',	73	UNION ALL	SELECT 'WQTY11',	74	UNION ALL	SELECT 'WQTY11',	75	UNION ALL	SELECT 'WQTY11',	76	UNION ALL	SELECT 'WQTY11',	77	UNION ALL
                  SELECT 'WQTY12',	78	UNION ALL	SELECT 'WQTY12',	79	UNION ALL	SELECT 'WQTY12',	80	UNION ALL	SELECT 'WQTY12',	81	UNION ALL	SELECT 'WQTY12',	82	UNION ALL	SELECT 'WQTY12',	83	UNION ALL	SELECT 'WQTY12',	84	UNION ALL
                  SELECT 'WQTY13',	85	UNION ALL	SELECT 'WQTY13',	86	UNION ALL	SELECT 'WQTY13',	87	UNION ALL	SELECT 'WQTY13',	88	UNION ALL	SELECT 'WQTY13',	89	UNION ALL	SELECT 'WQTY13',	90	UNION ALL	SELECT 'WQTY13',	91	UNION ALL
                  SELECT 'WQTY14',	92	UNION ALL	SELECT 'WQTY14',	93	UNION ALL	SELECT 'WQTY14',	94	UNION ALL	SELECT 'WQTY14',	95	UNION ALL	SELECT 'WQTY14',	96	UNION ALL	SELECT 'WQTY14',	97	UNION ALL	SELECT 'WQTY14',	98	UNION ALL
                  SELECT 'WQTY15',	99	UNION ALL	SELECT 'WQTY15',	100	UNION ALL	SELECT 'WQTY15',	101	UNION ALL	SELECT 'WQTY15',	102	UNION ALL	SELECT 'WQTY15',	103	UNION ALL	SELECT 'WQTY15',	104	UNION ALL	SELECT 'WQTY15',	105	UNION ALL
                  SELECT 'WQTY16',	106	UNION ALL	SELECT 'WQTY16',	107	UNION ALL	SELECT 'WQTY16',	108	UNION ALL	SELECT 'WQTY16',	109	UNION ALL	SELECT 'WQTY16',	110	UNION ALL	SELECT 'WQTY16',	111	UNION ALL	SELECT 'WQTY16',	112	UNION ALL
                  SELECT 'WQTY17',	113	UNION ALL	SELECT 'WQTY17',	114	UNION ALL	SELECT 'WQTY17',	115	UNION ALL	SELECT 'WQTY17',	116	UNION ALL	SELECT 'WQTY17',	117	UNION ALL	SELECT 'WQTY17',	118	UNION ALL	SELECT 'WQTY17',	119	UNION ALL
                  SELECT 'WQTY18',	120	UNION ALL	SELECT 'WQTY18',	121	UNION ALL	SELECT 'WQTY18',	122	UNION ALL	SELECT 'WQTY18',	123	UNION ALL	SELECT 'WQTY18',	124	UNION ALL	SELECT 'WQTY18',	125	UNION ALL	SELECT 'WQTY18',	126	UNION ALL
                  SELECT 'WQTY19',	127	UNION ALL	SELECT 'WQTY19',	128	UNION ALL	SELECT 'WQTY19',	129	UNION ALL	SELECT 'WQTY19',	130	UNION ALL	SELECT 'WQTY19',	131	UNION ALL	SELECT 'WQTY19',	132	UNION ALL	SELECT 'WQTY19',	133	UNION ALL
                  SELECT 'WQTY20',	134	UNION ALL	SELECT 'WQTY20',	135	UNION ALL	SELECT 'WQTY20',	136	UNION ALL	SELECT 'WQTY20',	137	UNION ALL	SELECT 'WQTY20',	138	UNION ALL	SELECT 'WQTY20',	139	UNION ALL	SELECT 'WQTY20',	140	UNION ALL
                  SELECT 'WQTY21',	141	UNION ALL	SELECT 'WQTY21',	142	UNION ALL	SELECT 'WQTY21',	143	UNION ALL	SELECT 'WQTY21',	144	UNION ALL	SELECT 'WQTY21',	145	UNION ALL	SELECT 'WQTY21',	146	UNION ALL	SELECT 'WQTY21',	147	UNION ALL
                  SELECT 'WQTY22',	148	UNION ALL	SELECT 'WQTY22',	149	UNION ALL	SELECT 'WQTY22',	150	UNION ALL	SELECT 'WQTY22',	151	UNION ALL	SELECT 'WQTY22',	152	UNION ALL	SELECT 'WQTY22',	153	UNION ALL	SELECT 'WQTY22',	154	UNION ALL
                  SELECT 'WQTY23',	155	UNION ALL	SELECT 'WQTY23',	156	UNION ALL	SELECT 'WQTY23',	157	UNION ALL	SELECT 'WQTY23',	158	UNION ALL	SELECT 'WQTY23',	159	UNION ALL	SELECT 'WQTY23',	160	UNION ALL	SELECT 'WQTY23',	161	UNION ALL
                  SELECT 'WQTY24',	162	UNION ALL	SELECT 'WQTY24',	163	UNION ALL	SELECT 'WQTY24',	164	UNION ALL	SELECT 'WQTY24',	165	UNION ALL	SELECT 'WQTY24',	166	UNION ALL	SELECT 'WQTY24',	167	UNION ALL	SELECT 'WQTY24',	168	UNION ALL
                  SELECT 'WQTY25',	169	UNION ALL	SELECT 'WQTY25',	170	UNION ALL	SELECT 'WQTY25',	171	UNION ALL	SELECT 'WQTY25',	172	UNION ALL	SELECT 'WQTY25',	173	UNION ALL	SELECT 'WQTY25',	174	UNION ALL	SELECT 'WQTY25',	175	UNION ALL
                  SELECT 'WQTY26',	176	UNION ALL	SELECT 'WQTY26',	177	UNION ALL	SELECT 'WQTY26',	178	UNION ALL	SELECT 'WQTY26',	179	UNION ALL	SELECT 'WQTY26',	180	UNION ALL	SELECT 'WQTY26',	181	UNION ALL	SELECT 'WQTY26',	182	UNION ALL
                  SELECT 'WQTY27',	183	UNION ALL	SELECT 'WQTY27',	184	UNION ALL	SELECT 'WQTY27',	185	UNION ALL	SELECT 'WQTY27',	186	UNION ALL	SELECT 'WQTY27',	187	UNION ALL	SELECT 'WQTY27',	188	UNION ALL	SELECT 'WQTY27',	189	UNION ALL
                  SELECT 'WQTY28',	190	UNION ALL	SELECT 'WQTY28',	191	UNION ALL	SELECT 'WQTY28',	192	UNION ALL	SELECT 'WQTY28',	193	UNION ALL	SELECT 'WQTY28',	194	UNION ALL	SELECT 'WQTY28',	195	UNION ALL	SELECT 'WQTY28',	196	UNION ALL
                  SELECT 'WQTY29',	197	UNION ALL	SELECT 'WQTY29',	198	UNION ALL	SELECT 'WQTY29',	199	UNION ALL	SELECT 'WQTY29',	200	UNION ALL	SELECT 'WQTY29',	201	UNION ALL	SELECT 'WQTY29',	202	UNION ALL	SELECT 'WQTY29',	203	UNION ALL
                  SELECT 'WQTY30',	204	UNION ALL	SELECT 'WQTY30',	205	UNION ALL	SELECT 'WQTY30',	206	UNION ALL	SELECT 'WQTY30',	207	UNION ALL	SELECT 'WQTY30',	208	UNION ALL	SELECT 'WQTY30',	209	UNION ALL	SELECT 'WQTY30',	210	UNION ALL
                  SELECT 'WQTY31',	211	UNION ALL	SELECT 'WQTY31',	212	UNION ALL	SELECT 'WQTY31',	213	UNION ALL	SELECT 'WQTY31',	214	UNION ALL	SELECT 'WQTY31',	215	UNION ALL	SELECT 'WQTY31',	216	UNION ALL	SELECT 'WQTY31',	217	UNION ALL
                  SELECT 'WQTY32',	218	UNION ALL	SELECT 'WQTY32',	219	UNION ALL	SELECT 'WQTY32',	220	UNION ALL	SELECT 'WQTY32',	221	UNION ALL	SELECT 'WQTY32',	222	UNION ALL	SELECT 'WQTY32',	223	UNION ALL	SELECT 'WQTY32',	224	UNION ALL
                  SELECT 'WQTY33',	225	UNION ALL	SELECT 'WQTY33',	226	UNION ALL	SELECT 'WQTY33',	227	UNION ALL	SELECT 'WQTY33',	228	UNION ALL	SELECT 'WQTY33',	229	UNION ALL	SELECT 'WQTY33',	230	UNION ALL	SELECT 'WQTY33',	231	UNION ALL
                  SELECT 'WQTY34',	232	UNION ALL	SELECT 'WQTY34',	233	UNION ALL	SELECT 'WQTY34',	234	UNION ALL	SELECT 'WQTY34',	235	UNION ALL	SELECT 'WQTY34',	236	UNION ALL	SELECT 'WQTY34',	237	UNION ALL	SELECT 'WQTY34',	238	UNION ALL
                  SELECT 'WQTY35',	239	UNION ALL	SELECT 'WQTY35',	240	UNION ALL	SELECT 'WQTY35',	241	UNION ALL	SELECT 'WQTY35',	242	UNION ALL	SELECT 'WQTY35',	243	UNION ALL	SELECT 'WQTY35',	244	UNION ALL	SELECT 'WQTY35',	245	UNION ALL
                  SELECT 'WQTY36',	246	UNION ALL	SELECT 'WQTY36',	247	UNION ALL	SELECT 'WQTY36',	248	UNION ALL	SELECT 'WQTY36',	249	UNION ALL	SELECT 'WQTY36',	250	UNION ALL	SELECT 'WQTY36',	251	UNION ALL	SELECT 'WQTY36',	252	UNION ALL
                  SELECT 'WQTY37',	253	UNION ALL	SELECT 'WQTY37',	254	UNION ALL	SELECT 'WQTY37',	255	UNION ALL	SELECT 'WQTY37',	256	UNION ALL	SELECT 'WQTY37',	257	UNION ALL	SELECT 'WQTY37',	258	UNION ALL	SELECT 'WQTY37',	259	UNION ALL
                  SELECT 'WQTY38',	260	UNION ALL	SELECT 'WQTY38',	261	UNION ALL	SELECT 'WQTY38',	262	UNION ALL	SELECT 'WQTY38',	263	UNION ALL	SELECT 'WQTY38',	264	UNION ALL	SELECT 'WQTY38',	265	UNION ALL	SELECT 'WQTY38',	266	UNION ALL
                  SELECT 'WQTY39',	267	UNION ALL	SELECT 'WQTY39',	268	UNION ALL	SELECT 'WQTY39',	269	UNION ALL	SELECT 'WQTY39',	270	UNION ALL	SELECT 'WQTY39',	271	UNION ALL	SELECT 'WQTY39',	272	UNION ALL	SELECT 'WQTY39',	273	UNION ALL
                  SELECT 'WQTY40',	274	UNION ALL	SELECT 'WQTY40',	275	UNION ALL	SELECT 'WQTY40',	276	UNION ALL	SELECT 'WQTY40',	277	UNION ALL	SELECT 'WQTY40',	278	UNION ALL	SELECT 'WQTY40',	279	UNION ALL	SELECT 'WQTY40',	280	UNION ALL
                  SELECT 'WQTY41',	281	UNION ALL	SELECT 'WQTY41',	282	UNION ALL	SELECT 'WQTY41',	283	UNION ALL	SELECT 'WQTY41',	284	UNION ALL	SELECT 'WQTY41',	285	UNION ALL	SELECT 'WQTY41',	286	UNION ALL	SELECT 'WQTY41',	287	UNION ALL
                  SELECT 'WQTY42',	288	UNION ALL	SELECT 'WQTY42',	289	UNION ALL	SELECT 'WQTY42',	290	UNION ALL	SELECT 'WQTY42',	291	UNION ALL	SELECT 'WQTY42',	292	UNION ALL	SELECT 'WQTY42',	293	UNION ALL	SELECT 'WQTY42',	294	UNION ALL
                  SELECT 'WQTY43',	295	UNION ALL	SELECT 'WQTY43',	296	UNION ALL	SELECT 'WQTY43',	297	UNION ALL	SELECT 'WQTY43',	298	UNION ALL	SELECT 'WQTY43',	299	UNION ALL	SELECT 'WQTY43',	300	UNION ALL	SELECT 'WQTY43',	301	UNION ALL
                  SELECT 'WQTY44',	302	UNION ALL	SELECT 'WQTY44',	303	UNION ALL	SELECT 'WQTY44',	304	UNION ALL	SELECT 'WQTY44',	305	UNION ALL	SELECT 'WQTY44',	306	UNION ALL	SELECT 'WQTY44',	307	UNION ALL	SELECT 'WQTY44',	308	UNION ALL
                  SELECT 'WQTY45',	309	UNION ALL	SELECT 'WQTY45',	310	UNION ALL	SELECT 'WQTY45',	311	UNION ALL	SELECT 'WQTY45',	312	UNION ALL	SELECT 'WQTY45',	313	UNION ALL	SELECT 'WQTY45',	314	UNION ALL	SELECT 'WQTY45',	315	UNION ALL
                  SELECT 'WQTY46',	316	UNION ALL	SELECT 'WQTY46',	317	UNION ALL	SELECT 'WQTY46',	318	UNION ALL	SELECT 'WQTY46',	319	UNION ALL	SELECT 'WQTY46',	320	UNION ALL	SELECT 'WQTY46',	321	UNION ALL	SELECT 'WQTY46',	322	UNION ALL
                  SELECT 'WQTY47',	323	UNION ALL	SELECT 'WQTY47',	324	UNION ALL	SELECT 'WQTY47',	325	UNION ALL	SELECT 'WQTY47',	326	UNION ALL	SELECT 'WQTY47',	327	UNION ALL	SELECT 'WQTY47',	328	UNION ALL	SELECT 'WQTY47',	329	UNION ALL
                  SELECT 'WQTY48',	330	UNION ALL	SELECT 'WQTY48',	331	UNION ALL	SELECT 'WQTY48',	332	UNION ALL	SELECT 'WQTY48',	333	UNION ALL	SELECT 'WQTY48',	334	UNION ALL	SELECT 'WQTY48',	335	UNION ALL	SELECT 'WQTY48',	336	UNION ALL
                  SELECT 'WQTY49',	337	UNION ALL	SELECT 'WQTY49',	338	UNION ALL	SELECT 'WQTY49',	339	UNION ALL	SELECT 'WQTY49',	340	UNION ALL	SELECT 'WQTY49',	341	UNION ALL	SELECT 'WQTY49',	342	UNION ALL	SELECT 'WQTY49',	343	UNION ALL
                  SELECT 'WQTY50',	344	UNION ALL	SELECT 'WQTY50',	345	UNION ALL	SELECT 'WQTY50',	346	UNION ALL	SELECT 'WQTY50',	347	UNION ALL	SELECT 'WQTY50',	348	UNION ALL	SELECT 'WQTY50',	349	UNION ALL	SELECT 'WQTY50',	350	UNION ALL
                  SELECT 'WQTY51',	351	UNION ALL	SELECT 'WQTY51',	352	UNION ALL	SELECT 'WQTY51',	353	UNION ALL	SELECT 'WQTY51',	354	UNION ALL	SELECT 'WQTY51',	355	UNION ALL	SELECT 'WQTY51',	356	UNION ALL	SELECT 'WQTY51',	357	UNION ALL
                  SELECT 'WQTY52',	358	UNION ALL	SELECT 'WQTY52',	359	UNION ALL	SELECT 'WQTY52',	360	UNION ALL	SELECT 'WQTY52',	361	UNION ALL	SELECT 'WQTY52',	362	UNION ALL	SELECT 'WQTY52',	363	UNION ALL	SELECT 'WQTY52',	364	



              --  SELECT 'WQTY' + A.ISO_WEEK     AS WEEK_COLUMN    
              --  , ROW_NUMBER() OVER (ORDER BY ISO_WEEK) AS Rn
              --  INTO #Rn
  	           -- FROM DBO.SCM_SYS_CALENDAR_M A  WITH(NOLOCK)	     
	 		          --WHERE A.BASIS_YYYYMMDD     >= @p_plan_start_yyyymmdd 
              --    AND A.BASIS_YYYYMMDD     <  @p_to_yyyymmdd  

                   
	          IF OBJECT_ID('tempdb..#CALENDAR') IS NOT NULL	
	            DROP TABLE #CALENDAR

	            SELECT 'D_'+A.BASIS_YYYYMMDD   AS D_YYYYMMDD
                      ,'QTY' + REPLICATE('0', 3 - LEN(ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD) )) + CONVERT(NVARCHAR,ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD)) AS YYYYMMDD_COLUMN
                      , MAX('W_' + A.BASIS_YYYYMM + ISO_WEEK) AS W_YYYY_WEEK 
                      , MAX('M_' + A.BASIS_YYYYMM) AS M_YYYYMM 
                      , MAX(ISO_WEEK) AS ISO_WEEK 
                      , ROW_NUMBER() OVER (ORDER BY A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 31) ) AS Rn
					            , A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 31) AS SORT_ORDER_NO
                  INTO #CALENDAR
						      FROM DBO.SCM_SYS_CALENDAR_M A
					      WHERE A.BASIS_YYYYMMDD  >= @p_create_from_yyyymmdd 
                  AND A.BASIS_YYYYMMDD  <= @p_create_to_yyyymmdd
					      GROUP BY A.BASIS_YYYYMMDD--,ISO_WEEK--,A.BASIS_YYYYMM,ISO_WEEK

	          IF OBJECT_ID('tempdb..#HEADER') IS NOT NULL	
	            DROP TABLE #HEADER
                  SELECT YYYYMMDD_COLUMN, WEEK_COLUMN, W_YYYY_WEEK,M_YYYYMM,ISO_WEEK, SORT_ORDER_NO, X.Rn
                  INTO #HEADER
                  FROM #CALENDAR X
                  INNER JOIN #Rn Y ON X.Rn = Y.Rn
                  order by x.rn

    
              DECLARE @mQry_sumWeek NVARCHAR(MAX);      
   
                SET @mQry_sumWeek = 'UPDATE X '+CHAR(10)
                SELECT @mQry_sumWeek = @mQry_sumWeek + 'SET '+CHAR(10) 
                SELECT @mQry_sumWeek = @mQry_sumWeek + '' + WSUM + ','+CHAR(10)  
             FROM (SELECT DISTINCT WEEK_COLUMN, WEEK_COLUMN +' = (' + 
                         STUFF((
                              SELECT '+' + YYYYMMDD_COLUMN
                              FROM   #HEADER
                              WHERE  WEEK_COLUMN = A.WEEK_COLUMN
                              ORDER BY SORT_ORDER_NO
                              FOR XML PATH('')
                         ),1,1,'') +')'  AS WSUM
                         , MIN(SORT_ORDER_NO)-1 AS SORT_ORDER_NO
                        FROM  #HEADER AS A
                        GROUP BY WEEK_COLUMN
                        ) A 
                ORDER BY WEEK_COLUMN

              SET @mQry_sumWeek = LEFT(@mQry_sumWeek, LEN(@mQry_sumWeek) -2)
              SELECT @mQry_sumWeek = @mQry_sumWeek + CHAR(10) +   ' FROM SCP_XLS_PSI_GLOBAL X WITH (NOLOCK) WHERE X.CREATE_FROM_YYYYMMDD = ''' + @p_create_from_yyyymmdd + ''''+CHAR(10)  -- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
			  SELECT @mQry_sumWeek = @mQry_sumWeek + CHAR(10) +   '  AND X.DIVISION_ID  = ''' + @p_division_id + ''''+CHAR(10)					-- 2022.03.23	KSW	        GM JV 반영

--              PRINT @mQry_sumWeek
              EXEC sp_executesql @mQry_sumWeek;


              
--          -------------------------------------------------------------------------------------------------------------         
            --  WEEK SUM PIVOT 생성 후 UPDATE
            -------------------------------------------------------------------------------------------------------------         
              IF OBJECT_ID('tempdb..#LineLoad_WEEK') IS NOT NULL      
	              DROP TABLE #LineLoad_WEEK;   

                SELECT   A.DIVISION_ID
                        ,A.SCM_SITE_ID  AS SITE_ID
                        ,A.OPERATION_ID
                        ,A.LINE_ID AS PROD_LINE
                        ,A.MEASURE
                        ,CASE WHEN SUM(A.WORKING_TIME) <= 0.0   THEN 0 
							  -- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - CAPA. 형교환 입력(Load Ratio 표시) 및 저장기능 구현 - start
							  -- 변경전
							  --
                             --ELSE ISNULL( ( ROUND(SUM(A.CAPA_TACT),0) / SUM(A.WORKING_TIME) ) ,0 ) *100
							 --
							 ELSE ISNULL( ( ROUND(SUM(A.CAPA_TACT),0) / (SUM(A.WORKING_TIME)-ISNULL(SUM(A.TIME_TERM),0)) ) ,0 ) *100
							 -- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - CAPA. 형교환 입력(Load Ratio 표시) 및 저장기능 구현 - end
                         END AS WQTY
                        ,A.ISO_YYYYWW
                        ,A.WEEK_COLUMN
                 INTO #LineLoad_WEEK
                  FROM #LineLoad A WITH (NOLOCK)
                GROUP BY A.DIVISION_ID
                        ,A.SCM_SITE_ID
                        ,A.OPERATION_ID
                        ,A.LINE_ID
                        ,A.MEASURE
                        ,A.ISO_YYYYWW
                        ,A.WEEK_COLUMN

                IF OBJECT_ID('tempdb..#LineLoad_WEEK_PIVOT') IS NOT NULL      
	                DROP TABLE #LineLoad_WEEK_PIVOT; 

                  SELECT *
                  INTO #LineLoad_WEEK_PIVOT
                  FROM
                    (
                    SELECT DIVISION_ID, SITE_ID, OPERATION_ID, PROD_LINE, MEASURE,WQTY,WEEK_COLUMN
                     FROM #LineLoad_WEEK WITH (NOLOCK) 
                     ) AS SourceTable  
                  PIVOT 
                      (
                       MIN(WQTY)
                       FOR  WEEK_COLUMN IN ( [WQTY01],[WQTY02],[WQTY03],[WQTY04],[WQTY05],[WQTY06],[WQTY07],[WQTY08],[WQTY09],[WQTY10],
                                             [WQTY11],[WQTY12],[WQTY13],[WQTY14],[WQTY15],[WQTY16],[WQTY17],[WQTY18],[WQTY19],[WQTY20],
                                             [WQTY21],[WQTY22],[WQTY23],[WQTY24],[WQTY25],[WQTY26],[WQTY27],[WQTY28],[WQTY29],[WQTY30],
                                             [WQTY31],[WQTY32],[WQTY33],[WQTY34],[WQTY35],[WQTY36],[WQTY37],[WQTY38],[WQTY39],[WQTY40],
                                             [WQTY41],[WQTY42],[WQTY43],[WQTY44],[WQTY45],[WQTY46],[WQTY47],[WQTY48],[WQTY49],[WQTY50],
                                             [WQTY51],[WQTY52]
                                            )  
                       ) X


                UPDATE X 
                  SET   X.WQTY01 = Y.WQTY01 ,X.WQTY02 = Y.WQTY02  ,X.WQTY03 = Y.WQTY03  ,X.WQTY04 = Y.WQTY04  ,X.WQTY05 = Y.WQTY05
                      , X.WQTY06 = Y.WQTY06 ,X.WQTY07 = Y.WQTY07  ,X.WQTY08 = Y.WQTY08  ,X.WQTY09 = Y.WQTY09  ,X.WQTY10 = Y.WQTY10
                      , X.WQTY11 = Y.WQTY11 ,X.WQTY12 = Y.WQTY12  ,X.WQTY13 = Y.WQTY13  ,X.WQTY14 = Y.WQTY14  ,X.WQTY15 = Y.WQTY15
                      , X.WQTY16 = Y.WQTY16 ,X.WQTY17 = Y.WQTY17  ,X.WQTY18 = Y.WQTY18  ,X.WQTY19 = Y.WQTY19  ,X.WQTY20 = Y.WQTY20
                      , X.WQTY21 = Y.WQTY21 ,X.WQTY22 = Y.WQTY22  ,X.WQTY23 = Y.WQTY23  ,X.WQTY24 = Y.WQTY24  ,X.WQTY25 = Y.WQTY25
                      , X.WQTY26 = Y.WQTY26 ,X.WQTY27 = Y.WQTY27  ,X.WQTY28 = Y.WQTY28  ,X.WQTY29 = Y.WQTY29  ,X.WQTY30 = Y.WQTY30
                      , X.WQTY31 = Y.WQTY31 ,X.WQTY32 = Y.WQTY32  ,X.WQTY33 = Y.WQTY33  ,X.WQTY34 = Y.WQTY34  ,X.WQTY35 = Y.WQTY35
                      , X.WQTY36 = Y.WQTY36 ,X.WQTY37 = Y.WQTY37  ,X.WQTY38 = Y.WQTY38  ,X.WQTY39 = Y.WQTY39  ,X.WQTY40 = Y.WQTY40
                      , X.WQTY41 = Y.WQTY41 ,X.WQTY42 = Y.WQTY42  ,X.WQTY43 = Y.WQTY43  ,X.WQTY44 = Y.WQTY44  ,X.WQTY45 = Y.WQTY45
                      , X.WQTY46 = Y.WQTY46 ,X.WQTY47 = Y.WQTY47  ,X.WQTY48 = Y.WQTY48  ,X.WQTY49 = Y.WQTY49  ,X.WQTY50 = Y.WQTY50
                      , X.WQTY51 = Y.WQTY51 ,X.WQTY52 = Y.WQTY52
                   FROM SCP_XLS_PSI_GLOBAL X WITH (NOLOCK)
                   INNER JOIN #LineLoad_WEEK_PIVOT Y WITH (NOLOCK)
                      ON Y.PROD_LINE    = X.PROD_LINE 
                     AND X.DIVISION_ID  = Y.DIVISION_ID
					 AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
                     AND X.FROM_SITE    = Y.SITE_ID
                     AND X.ATTRIBUTE9   = Y.OPERATION_ID
                   WHERE X.MEASURE IN ('PACK_PROD_LOAD','CELL_PROD_LOAD') 

              -- LT_TOTAL_BY_WEEK
              -- BOD LT (SHIP_PLAN/SEMI_SHIP_PLAN) : BOD L/T 계산시 1~7일 구간은 반올림, 이후 구간은 올림 처리
           /*
              UPDATE X
                 SET X.LT_DAY = (CASE WHEN (Y.LT_TOTAL/7.0) < 1   THEN ROUND ((Y.LT_TOTAL/7.0),0,0) ELSE CEILING((Y.LT_TOTAL/7.0))  END) 
                FROM SCP_XLS_PSI_GLOBAL X  WITH (NOLOCK)
                INNER JOIN SCP_MST_BOD_V  Y WITH (NOLOCK)
                ON X.DIVISION_ID    = Y.DIVISION_ID
                AND X.FROM_SITE     = Y.FROM_SITE
                AND X.TO_SITE       = Y.TO_SITE
                AND X.TRANSPORT_MODE= Y.TRANSPORT_MODE
                AND X.BOD_ID        = Y.BOD_ID
              */
              


			  -- LT_DAY 업데이트 - 2021.08.10 KSW - start
			  -- 중장기 :: 첫 1 YEAR 만 적용
			  --
			  IF (@p_plan_start_yyyymmdd = @p_create_from_yyyymmdd)
			  BEGIN

				  UPDATE X
					 SET X.LT_DAY = Y.LT_TOTAL,
					     X.ATTRIBUTE10 = 'NO_LT_DIVIDE'		-- 2022.05.24 LT오류반영
					FROM SCP_XLS_PSI_GLOBAL X  WITH (NOLOCK)
					INNER JOIN SCP_MST_BOD_N_V  Y WITH (NOLOCK)	-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V
					ON X.DIVISION_ID    = Y.DIVISION_ID
					AND X.FROM_SITE     = Y.FROM_SITE
					AND X.TO_SITE       = Y.TO_SITE
					AND X.TRANSPORT_MODE= Y.TRANSPORT_MODE
					AND X.BOD_ID        = Y.BOD_ID
					AND X.DIVISION_ID   = @p_division_id						-- 2022.03.23	KSW	        GM JV 반영
					AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
					;

			  -- LT_DAY 업데이트 - 2022.03.02 - BOD 정보가 없는 SEMI_SHIP_PLAN UPDATE - START
				  UPDATE X
					 SET X.LT_DAY = Y.LT_TOTAL,
					     X.BOD_ID = Y.BOD_ID,
						 X.ATTRIBUTE3   = Y.FROM_YYYYMMDD + ',' + Y.TO_YYYYMMDD,
						 X.ATTRIBUTE10 = 'NO_LT_DIVIDE'								-- 2022.05.24 LT오류반영
					FROM SCP_XLS_PSI_GLOBAL X  WITH (NOLOCK)
					INNER JOIN SCP_MST_BOD_N_V  Y WITH (NOLOCK)	-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V
					ON X.DIVISION_ID    = Y.DIVISION_ID
					AND X.FROM_SITE     = Y.FROM_SITE
					AND X.TO_SITE       = Y.TO_SITE
					AND X.TRANSPORT_MODE= Y.TRANSPORT_MODE
					AND X.DIVISION_ID   = @p_division_id						-- 2022.03.23	KSW	        GM JV 반영
					AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
					WHERE X.BOD_ID =  '-'
					  AND X.MEASURE = 'SEMI_SHIP_PLAN'
					  ;

			  -- SEMI_SHIP_PLAN 에서 TRANSPORT_MODE, BOD_ID 가 NULL 인건 삭제
				DELETE SCP_XLS_PSI_GLOBAL
				 WHERE MEASURE = 'SEMI_SHIP_PLAN'
				   AND BOD_ID IS NULL
				   AND TRANSPORT_MODE IS NULL
				   AND DIVISION_ID  = @p_division_id						-- 2022.03.23	KSW	        GM JV 반영
				   ;
			  -- LT_DAY 업데이트 - 2022.03.02 - BOD 정보가 없는 SEMI_SHIP_PLAN UPDATE - END
                

					-- 20200323 [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - Hold VMI 대기 재고 Visibility 강화
					-- VMI 전진 검사 LT 추가 적용 : SCM_MST_SITE_ITEM 테이블의 SCP_VMI_LT 값 만큼 더해 줌
					-- 2022.05.24 LT오류반영
					UPDATE X
					 SET X.LT_DAY = (CASE WHEN ((ISNULL(X.LT_DAY,0)+ISNULL(Y.LT_DAY,0))/7.0) < 1   THEN ROUND (((ISNULL(X.LT_DAY,0)+ISNULL(Y.LT_DAY,0))/7.0),0,0) ELSE CEILING(((ISNULL(X.LT_DAY,0)+ISNULL(Y.LT_DAY,0))/7.0))  END) ,
					     X.ATTRIBUTE10 = NULL
					FROM SCP_XLS_PSI_GLOBAL X  WITH (NOLOCK)
					INNER JOIN (
									  SELECT S.DIVISION_ID
											,S.SCM_SITE_ID
											,S.ITEM_ID
											,MAX(ISNULL(S.SCP_VMI_LT, 0)) AS LT_DAY
										FROM SCM_MST_SITE_ITEM S WITH(NOLOCK)
									   INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL MD WITH(NOLOCK)
										  ON S.DIVISION_ID  = MD.SEGMENT1
										 AND S.SCM_SITE_ID  = MD.SEGMENT2
										 AND MD.LOOKUP_TYPE = 'VMI_LT_SITE'
										 AND S.VALID_YN     = 'Y'
										 AND MD.VALID_YN    = 'Y'
									   GROUP BY S.DIVISION_ID
											   ,S.SCM_SITE_ID
											   ,S.ITEM_ID
					) Y
					ON X.DIVISION_ID    = Y.DIVISION_ID
					AND X.TO_SITE       = Y.SCM_SITE_ID
					AND X.ITEM_ID       = Y.ITEM_ID
					AND X.DIVISION_ID   = @p_division_id						-- 2022.03.23	KSW	        GM JV 반영
					WHERE X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
					  AND X.DIVISION_ID   = @p_division_id
					  ;


					-- 2022.05.24 LT오류반영 - start
					-- VMI LT 업데이트에서 누락된 모든 LT를 7로 나눈값을 적용한다
					UPDATE X
					 SET X.LT_DAY = (CASE WHEN X.LT_DAY < 7.0 THEN ROUND(X.LT_DAY/7.0, 0) ELSE CEILING(X.LT_DAY/7.0) END),		-- 2022.06.02 7일 이내는 ROUND, 7일 이상은 CEILING 으로 변경
					     X.ATTRIBUTE10 = NULL
					FROM SCP_XLS_PSI_GLOBAL X  WITH (NOLOCK)
					WHERE X.DIVISION_ID   = @p_division_id						-- 2022.03.23	KSW	        GM JV 반영
					  AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
				      AND X.ATTRIBUTE10 = 'NO_LT_DIVIDE'
					;					
					-- 2022.05.24 LT오류반영 - end

					--SELECT * INTO ##SCP_XLS_PSI_GLOBAL2  FROM SCP_XLS_PSI_GLOBAL WITH (NOLOCK)
					--RETURN;

					-- * 2020.03.31   KTH         CELL_PROD LT로직 변경 
					  UPDATE X
						 SET X.LT_DAY = (CEILING(ISNULL(Y.LT_FORMATION + CONVERT(INT, ISNULL(Y.ATTRIBUTE1, '0')),0) /7.0))
								--,Y.LT_FORMATION + CONVERT(INT, ISNULL(Y.ATTRIBUTE1, '0')) AS LT_FORMATION
								--,Y.LT_FORMATION,ISNULL(Y.ATTRIBUTE1, '0'), *
						  FROM SCP_XLS_PSI_GLOBAL X  WITH (NOLOCK)
						 INNER JOIN SCP_MST_FORMATION Y WITH (NOLOCK)
						 ON X.DIVISION_ID   = Y.DIVISION_ID
						 AND X.FROM_SITE    = Y.PLANT_SITE_ID
						 AND X.ITEM_ID      = Y.ITEM_ID
						 AND X.MEASURE      ='CELL_PROD'       
						 WHERE X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
						   AND X.DIVISION_ID  = @p_division_id						-- 2022.03.23	KSW	        GM JV 반영

					-- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 [추가개선] - FROM_BOH_QTY 컬럼에 Pack BOH (Hold) 통합수량 update - start
					UPDATE X
						SET X.FROM_BOH_QTY = ISNULL(Y.QTY,0)
						FROM SCP_XLS_PSI_GLOBAL X WITH (NOLOCK)
						INNER JOIN (SELECT ITEM_ID, FROM_SITE, SUM(QTY) AS QTY 
									FROM #PLN_TH_ENG_STOCK_PLAN_INSP WITH (NOLOCK)   
									WHERE (INSP_TYPE = 'INSP_HOLD' OR DESCR LIKE '%HOLD')
							          AND NOT INSP_TYPE = 'INSP_PRE'
									GROUP BY ITEM_ID, FROM_SITE
								) Y
						ON 0 = 0
						AND X.FROM_SITE            = Y.FROM_SITE      
						AND X.ITEM_ID              = Y.ITEM_ID    
						AND X.MEASURE              = 'PACK_BOH_HOLD'
						AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd
						AND X.DIVISION_ID          = @p_division_id						-- 2022.03.23	KSW	        GM JV 반영
					-- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 [추가개선] - FROM_BOH_QTY 컬럼에 Pack BOH (Hold) 통합수량 update - end
			  END
			  -- 중장기 :: 첫 1 YEAR 만 적용
			  -- LT_DAY 업데이트 - 2021.08.10 KSW - end


                -- 중복 오류 보정 
                 DELETE TBL 
                --  SELECT * 
                  FROM
	                (
	                        SELECT
	                               ROW_NUMBER() OVER (PARTITION BY CELL_ITEM_ID,ITEM_ID,NICK_NAME,TO_SITE,PROJECT_CODE,INCOTERMS,FROM_SITE,TRANSPORT_MODE,PROD_LINE, BOD_ID  ORDER BY BOD_ID DESC) AS ROWNUM	-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 중복제거시 BOD_ID 추가
--                                 ,*
	                        FROM SCP_XLS_PSI_GLOBAL  WITH (NOLOCK)
                          WHERE MEASURE IN ('SEMI_SHIP_PLAN', 'SHIP_PLAN')			-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 SHIP_PLAN 추가
						    AND CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
							AND DIVISION_ID          = @p_division_id						-- 2022.03.23	KSW	        GM JV 반영

	                ) AS TBL
	                WHERE TBL.ROWNUM > 1


-- 2022.08.30   KSW			Cell 재고 개선건 :: PR_SCP_XLS_PSI_GLOBAL 에서 수량을 보정하지 않아도 처리할 수 있도록 수정
				---- CELL_FORM_HOLD_AFTER(After Form. Hold Release) Measure 값 보완 - start
				---- 52주 첫회전 일 경우 (CREATE_FROM_YYYYMMDD = PLAN_START_YYYYMMDD)
				--IF (@p_plan_start_yyyymmdd = @p_create_from_yyyymmdd)
				--BEGIN 
    --              UPDATE X
    --              SET X.FROM_BOH_QTY = ISNULL(X.FROM_BOH_QTY,0) -   
    --                                  (ISNULL(WQTY01,0)+ISNULL(WQTY02,0)+ISNULL(WQTY03,0)+ISNULL(WQTY04,0)+ISNULL(WQTY05,0)+ISNULL(WQTY06,0)+ISNULL(WQTY07,0)+ISNULL(WQTY08,0)+ISNULL(WQTY09,0)+ISNULL(WQTY10,0)
    --                                                        +ISNULL(WQTY11,0)+ISNULL(WQTY12,0)+ISNULL(WQTY13,0)+ISNULL(WQTY14,0)+ISNULL(WQTY15,0)+ISNULL(WQTY16,0)+ISNULL(WQTY17,0)+ISNULL(WQTY18,0)+ISNULL(WQTY19,0)+ISNULL(WQTY20,0)
    --                                                        +ISNULL(WQTY21,0)+ISNULL(WQTY22,0)+ISNULL(WQTY23,0)+ISNULL(WQTY24,0)+ISNULL(WQTY25,0)+ISNULL(WQTY26,0)+ISNULL(WQTY27,0)+ISNULL(WQTY28,0)+ISNULL(WQTY29,0)+ISNULL(WQTY30,0)
    --                                                        +ISNULL(WQTY31,0)+ISNULL(WQTY32,0)+ISNULL(WQTY33,0)+ISNULL(WQTY34,0)+ISNULL(WQTY35,0)+ISNULL(WQTY36,0)+ISNULL(WQTY37,0)+ISNULL(WQTY38,0)+ISNULL(WQTY39,0)+ISNULL(WQTY40,0)
    --                                                        +ISNULL(WQTY41,0)+ISNULL(WQTY42,0)+ISNULL(WQTY43,0)+ISNULL(WQTY44,0)+ISNULL(WQTY45,0)+ISNULL(WQTY46,0)+ISNULL(WQTY47,0)+ISNULL(WQTY48,0)+ISNULL(WQTY49,0)+ISNULL(WQTY50,0)
    --                                                        +ISNULL(WQTY51,0)+ISNULL(WQTY52,0)
    --                                   )                     
    --              FROM SCP_XLS_PSI_GLOBAL X  WITH (NOLOCK)
    --              WHERE MEASURE ='CELL_FORM_HOLD_AFTER'
				--  AND CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
				--  AND DIVISION_ID  = @p_division_id						-- 2022.03.23	KSW	        GM JV 반영

				--END      
				
-- 2022.08.30   KSW			Cell 재고 개선건 :: PR_SCP_XLS_PSI_GLOBAL 에서 수량을 보정하지 않아도 처리할 수 있도록 수정
				---- 중장기 52주 이후 구간은 30주 구간의 합산 - 추후 플랜기간이 늘어날 경우 대비  --> 52주로 변경 2022.08.29
				--IF (@p_plan_start_yyyymmdd <> @p_create_from_yyyymmdd)
				--BEGIN 
				--	DECLARE @p_real_to_yyyymmdd		nvarchar(12) = CONVERT(VARCHAR(8), DATEADD(day, 52*7, @p_create_from_yyyymmdd), 112);		-- 30주 --> 52주로 변경 2022.08.29

				--	  SET     @mQry_sum = 'ISNULL(WQTY01,0)';
				--	  SELECT  @mQry_sum = @mQry_sum+      
				--		  CASE  
				--		  WHEN 1 = 1 THEN  '+ISNULL('+A.WEEK_NO+',0)'
				--		  END +''+CHAR(10)      
				--	  FROM (       
				--			SELECT 'WQTY'+RIGHT('0'+CONVERT(VARCHAR(2), ROW_NUMBER() OVER(ORDER BY A.BASIS_YYYYMMDD)),2) AS WEEK_NO  
  	 -- 				  FROM DBO.SCM_SYS_CALENDAR_M A  WITH(NOLOCK)	     
	 		--			   WHERE A.BASIS_YYYYMMDD     >= @p_create_from_yyyymmdd 
				--	   AND A.BASIS_YYYYMMDD     <=  @p_real_to_yyyymmdd     
				--	   and A.DAYOFWEEK = 'SUN'     
				--	  ) AS A     
				--	  WHERE A.WEEK_NO <> 'WQTY01'
				--	;  

				--	--select @mQry_sum;

				--	SET @mEXEC = '';
				--	SET @mEXEC = 'UPDATE X '+CHAR(10)
				--	SET @mEXEC = @mEXEC + 'SET X.FROM_BOH_QTY = (' + @mQry_sum + ') ' + CHAR(10)
				--	SET @mEXEC = @mEXEC + 'FROM SCP_XLS_PSI_GLOBAL X  WITH (NOLOCK) ' + CHAR(10)
				--	SET @mEXEC = @mEXEC + 'WHERE X.MEASURE = ''CELL_FORM_HOLD_AFTER'''  + CHAR(10)
				--	SET @mEXEC = @mEXEC + '  AND X.CREATE_FROM_YYYYMMDD = ''' + @p_create_from_yyyymmdd + '''' + CHAR(10)
				--	SET @mEXEC = @mEXEC + '  AND X.DIVISION_ID          = ''' + @p_division_id + '''' + CHAR(10)					-- 2022.03.23	KSW	        GM JV 반영
				
				--	--select @mEXEC;
				--	EXEC sp_executesql @mEXEC;
				--END   
				---- CELL_FORM_HOLD_AFTER(After Form. Hold Release) Measure 값 보완 - end

				-- ITEM_ID 없는 PACK_CELL_BOH, PACK_CELL_EOH 삭제 - 2021.11.17 KSW
				DELETE SCP_XLS_PSI_GLOBAL
				 WHERE CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd
				   AND DIVISION_ID          = @p_division_id						-- 2022.03.23	KSW	        GM JV 반영
				   AND MEASURE IN ('PACK_CELL_BOH', 'PACK_CELL_EOH')
				   AND ITEM_ID IS NULL
				   ;

				-- PACK 영역에 추가된 SEMI 삭제 - 2021.11.17 KSW
				DELETE SCP_XLS_PSI_GLOBAL
				 WHERE CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd
				   AND DIVISION_ID          = @p_division_id						-- 2022.03.23	KSW	        GM JV 반영
				   AND MEASURE IN ('SEMI_WHIN','SEMI_INTRANSIT','SEMI_INTRANSIT_ETA','SEMI_SHIP_PLAN_ETA','SEMI_SHIP_PLAN')
				   AND OPERATION_GROUP = 'P'
				   ;

				-- PACK_CELL_BOH_HOLD 단독으로 존재하는 모델 PACK_CELL_BOH_HOLD 삭제 - 2022.08.30   KSW			Cell 재고 개선건
				DELETE Y
				  FROM (
						SELECT S.CELL_ITEM_ID, S.ITEM_ID, S.FROM_SITE, SUM(S.CNT) AS CNT
						  FROM (
								SELECT  CELL_ITEM_ID, ITEM_ID, FROM_SITE
									   ,(CASE WHEN MEASURE = 'PACK_CELL_BOH' THEN 1 ELSE 2 END) CNT
								  FROM SCP_XLS_PSI_GLOBAL A with (nolock)
								 WHERE A.DIVISION_ID = @p_division_id
								   AND A.MEASURE IN ('PACK_CELL_BOH_HOLD', 'PACK_CELL_BOH')
							   ) S
						 GROUP BY S.CELL_ITEM_ID, S.ITEM_ID, S.FROM_SITE
					   ) X
				 INNER JOIN SCP_XLS_PSI_GLOBAL Y with (nolock)
					ON X.CELL_ITEM_ID = Y.CELL_ITEM_ID
				   AND X.ITEM_ID      = Y.ITEM_ID
				   AND X.FROM_SITE    = Y.FROM_SITE
				 WHERE X.CNT = 2
				   AND Y.DIVISION_ID  = @p_division_id
				   AND Y.MEASURE      = 'PACK_CELL_BOH_HOLD'
				   ;

				   IF OBJECT_ID('TEMPDB..#PSI_GLOBAL_FINAL') IS NOT NULL
					DROP TABLE #PSI_GLOBAL_FINAL


				  SELECT   Y.DIVISION_ID
						,Y.PLAN_START_YYYYMMDD
						,Y.CREATE_FROM_YYYYMMDD
						,Y.CREATE_TO_YYYYMMDD
						,Y.PLAN_TYPE,SEQ
						,Y.OPERATION_GROUP
						,Y.OPERATION_GROUP_NAME
						,Y.CELL_ITEM_ID
						,Y.ITEM_ID
						,Y.NICK_NAME
						,Y.CELL_QTY_PACK
						,Y.TO_SITE
						,Y.TO_SITE_DESCRIPTION
						,Y.PROJECT_CODE
						,Y.FROM_BOH_QTY
						,Y.TO_BOH_QTY
						,Y.INCOTERMS
						,Y.FROM_SITE
						,Y.FROM_SITE_DESCRIPTION
						,Y.TRANSPORT_MODE
						,Y.PROD_LINE
						,Y.LT_DAY
						,Y.BOD_ID
						,'PACK_CELL_BOH_HOLD'	AS MEASURE
						,'Cell BOH(Hold)'		AS MEASURE_LABEL
					--	,Y.XLS_KEY1  100*10000         AS XLS_KEY1  -- 레코드 추가시의 충돌오류 회피를 위해  키값에  백만을 곱하기
						,Y.XLS_KEY1 + 1000000         AS XLS_KEY1  -- 레코드 추가시의 충돌오류 회피를 위해  키값에  백만을 곱하기
						,Y.XLS_KEY2
						,Y.XLS_KEY3
						,Y.XLS_KEY4,XLS_KEY5
						,Y.XLS_ATTRIBUTE1,Y.XLS_ATTRIBUTE2,Y.XLS_ATTRIBUTE3,Y.XLS_ATTRIBUTE4,Y.XLS_ATTRIBUTE5
						,B.SORT_ORDER_NO + 5	AS SORT_ORDER_NO

						,0 AS QTY001, 0 AS QTY002, 0 AS QTY003, 0 AS QTY004, 0 AS QTY005, 0 AS QTY006, 0 AS QTY007, 0 AS QTY008, 0 AS QTY009, 0 AS QTY010
						,0 AS QTY011, 0 AS QTY012, 0 AS QTY013, 0 AS QTY014, 0 AS QTY015, 0 AS QTY016, 0 AS QTY017, 0 AS QTY018, 0 AS QTY019, 0 AS QTY020
						,0 AS QTY021, 0 AS QTY022, 0 AS QTY023, 0 AS QTY024, 0 AS QTY025, 0 AS QTY026, 0 AS QTY027, 0 AS QTY028, 0 AS QTY029, 0 AS QTY030
						,0 AS QTY031, 0 AS QTY032, 0 AS QTY033, 0 AS QTY034, 0 AS QTY035, 0 AS QTY036, 0 AS QTY037, 0 AS QTY038, 0 AS QTY039, 0 AS QTY040
						,0 AS QTY041, 0 AS QTY042, 0 AS QTY043, 0 AS QTY044, 0 AS QTY045, 0 AS QTY046, 0 AS QTY047, 0 AS QTY048, 0 AS QTY049, 0 AS QTY050
						,0 AS QTY051, 0 AS QTY052, 0 AS QTY053, 0 AS QTY054, 0 AS QTY055, 0 AS QTY056, 0 AS QTY057, 0 AS QTY058, 0 AS QTY059, 0 AS QTY060
						,0 AS QTY061, 0 AS QTY062, 0 AS QTY063, 0 AS QTY064, 0 AS QTY065, 0 AS QTY066, 0 AS QTY067, 0 AS QTY068, 0 AS QTY069, 0 AS QTY070
						,0 AS QTY071, 0 AS QTY072, 0 AS QTY073, 0 AS QTY074, 0 AS QTY075, 0 AS QTY076, 0 AS QTY077, 0 AS QTY078, 0 AS QTY079, 0 AS QTY080
						,0 AS QTY081, 0 AS QTY082, 0 AS QTY083, 0 AS QTY084, 0 AS QTY085, 0 AS QTY086, 0 AS QTY087, 0 AS QTY088, 0 AS QTY089, 0 AS QTY090
						,0 AS QTY091, 0 AS QTY092, 0 AS QTY093, 0 AS QTY094, 0 AS QTY095, 0 AS QTY096, 0 AS QTY097, 0 AS QTY098, 0 AS QTY099, 0 AS QTY100
						,0 AS QTY101, 0 AS QTY102, 0 AS QTY103, 0 AS QTY104, 0 AS QTY105, 0 AS QTY106, 0 AS QTY107, 0 AS QTY108, 0 AS QTY109, 0 AS QTY110
						,0 AS QTY111, 0 AS QTY112, 0 AS QTY113, 0 AS QTY114, 0 AS QTY115, 0 AS QTY116, 0 AS QTY117, 0 AS QTY118, 0 AS QTY119, 0 AS QTY120
						,0 AS QTY121, 0 AS QTY122, 0 AS QTY123, 0 AS QTY124, 0 AS QTY125, 0 AS QTY126, 0 AS QTY127, 0 AS QTY128, 0 AS QTY129, 0 AS QTY130
						,0 AS QTY131, 0 AS QTY132, 0 AS QTY133, 0 AS QTY134, 0 AS QTY135, 0 AS QTY136, 0 AS QTY137, 0 AS QTY138, 0 AS QTY139, 0 AS QTY140
						,0 AS QTY141, 0 AS QTY142, 0 AS QTY143, 0 AS QTY144, 0 AS QTY145, 0 AS QTY146, 0 AS QTY147, 0 AS QTY148, 0 AS QTY149, 0 AS QTY150
						,0 AS QTY151, 0 AS QTY152, 0 AS QTY153, 0 AS QTY154, 0 AS QTY155, 0 AS QTY156, 0 AS QTY157, 0 AS QTY158, 0 AS QTY159, 0 AS QTY160
						,0 AS QTY161, 0 AS QTY162, 0 AS QTY163, 0 AS QTY164, 0 AS QTY165, 0 AS QTY166, 0 AS QTY167, 0 AS QTY168, 0 AS QTY169, 0 AS QTY170
						,0 AS QTY171, 0 AS QTY172, 0 AS QTY173, 0 AS QTY174, 0 AS QTY175, 0 AS QTY176, 0 AS QTY177, 0 AS QTY178, 0 AS QTY179, 0 AS QTY180
						,0 AS QTY181, 0 AS QTY182, 0 AS QTY183, 0 AS QTY184, 0 AS QTY185, 0 AS QTY186, 0 AS QTY187, 0 AS QTY188, 0 AS QTY189, 0 AS QTY190
						,0 AS QTY191, 0 AS QTY192, 0 AS QTY193, 0 AS QTY194, 0 AS QTY195, 0 AS QTY196, 0 AS QTY197, 0 AS QTY198, 0 AS QTY199, 0 AS QTY200
						,0 AS QTY201, 0 AS QTY202, 0 AS QTY203, 0 AS QTY204, 0 AS QTY205, 0 AS QTY206, 0 AS QTY207, 0 AS QTY208, 0 AS QTY209, 0 AS QTY210
						,0 AS QTY211, 0 AS QTY212, 0 AS QTY213, 0 AS QTY214, 0 AS QTY215, 0 AS QTY216, 0 AS QTY217, 0 AS QTY218, 0 AS QTY219, 0 AS QTY220
						,0 AS QTY221, 0 AS QTY222, 0 AS QTY223, 0 AS QTY224, 0 AS QTY225, 0 AS QTY226, 0 AS QTY227, 0 AS QTY228, 0 AS QTY229, 0 AS QTY230
						,0 AS QTY231, 0 AS QTY232, 0 AS QTY233, 0 AS QTY234, 0 AS QTY235, 0 AS QTY236, 0 AS QTY237, 0 AS QTY238, 0 AS QTY239, 0 AS QTY240
						,0 AS QTY241, 0 AS QTY242, 0 AS QTY243, 0 AS QTY244, 0 AS QTY245, 0 AS QTY246, 0 AS QTY247, 0 AS QTY248, 0 AS QTY249, 0 AS QTY250
						,0 AS QTY251, 0 AS QTY252, 0 AS QTY253, 0 AS QTY254, 0 AS QTY255, 0 AS QTY256, 0 AS QTY257, 0 AS QTY258, 0 AS QTY259, 0 AS QTY260
						,0 AS QTY261, 0 AS QTY262, 0 AS QTY263, 0 AS QTY264, 0 AS QTY265, 0 AS QTY266, 0 AS QTY267, 0 AS QTY268, 0 AS QTY269, 0 AS QTY270
						,0 AS QTY271, 0 AS QTY272, 0 AS QTY273, 0 AS QTY274, 0 AS QTY275, 0 AS QTY276, 0 AS QTY277, 0 AS QTY278, 0 AS QTY279, 0 AS QTY280
						,0 AS QTY281, 0 AS QTY282, 0 AS QTY283, 0 AS QTY284, 0 AS QTY285, 0 AS QTY286, 0 AS QTY287, 0 AS QTY288, 0 AS QTY289, 0 AS QTY290
						,0 AS QTY291, 0 AS QTY292, 0 AS QTY293, 0 AS QTY294, 0 AS QTY295, 0 AS QTY296, 0 AS QTY297, 0 AS QTY298, 0 AS QTY299, 0 AS QTY300
						,0 AS QTY301, 0 AS QTY302, 0 AS QTY303, 0 AS QTY304, 0 AS QTY305, 0 AS QTY306, 0 AS QTY307, 0 AS QTY308, 0 AS QTY309, 0 AS QTY310
						,0 AS QTY311, 0 AS QTY312, 0 AS QTY313, 0 AS QTY314, 0 AS QTY315, 0 AS QTY316, 0 AS QTY317, 0 AS QTY318, 0 AS QTY319, 0 AS QTY320
						,0 AS QTY321, 0 AS QTY322, 0 AS QTY323, 0 AS QTY324, 0 AS QTY325, 0 AS QTY326, 0 AS QTY327, 0 AS QTY328, 0 AS QTY329, 0 AS QTY330
						,0 AS QTY331, 0 AS QTY332, 0 AS QTY333, 0 AS QTY334, 0 AS QTY335, 0 AS QTY336, 0 AS QTY337, 0 AS QTY338, 0 AS QTY339, 0 AS QTY340
						,0 AS QTY341, 0 AS QTY342, 0 AS QTY343, 0 AS QTY344, 0 AS QTY345, 0 AS QTY346, 0 AS QTY347, 0 AS QTY348, 0 AS QTY349, 0 AS QTY350
						,0 AS QTY351, 0 AS QTY352, 0 AS QTY353, 0 AS QTY354, 0 AS QTY355, 0 AS QTY356, 0 AS QTY357, 0 AS QTY358, 0 AS QTY359, 0 AS QTY360
						,0 AS QTY361, 0 AS QTY362, 0 AS QTY363, 0 AS QTY364

						,0 AS WQTY01, 0 AS WQTY02, 0 AS WQTY03, 0 AS WQTY04, 0 AS WQTY05, 0 AS WQTY06, 0 AS WQTY07, 0 AS WQTY08, 0 AS WQTY09, 0 AS WQTY10
						,0 AS WQTY11, 0 AS WQTY12, 0 AS WQTY13, 0 AS WQTY14, 0 AS WQTY15, 0 AS WQTY16, 0 AS WQTY17, 0 AS WQTY18, 0 AS WQTY19, 0 AS WQTY20
						,0 AS WQTY21, 0 AS WQTY22, 0 AS WQTY23, 0 AS WQTY24, 0 AS WQTY25, 0 AS WQTY26, 0 AS WQTY27, 0 AS WQTY28, 0 AS WQTY29, 0 AS WQTY30
						,0 AS WQTY31, 0 AS WQTY32, 0 AS WQTY33, 0 AS WQTY34, 0 AS WQTY35, 0 AS WQTY36, 0 AS WQTY37, 0 AS WQTY38, 0 AS WQTY39, 0 AS WQTY40
						,0 AS WQTY41, 0 AS WQTY42, 0 AS WQTY43, 0 AS WQTY44, 0 AS WQTY45, 0 AS WQTY46, 0 AS WQTY47, 0 AS WQTY48, 0 AS WQTY49, 0 AS WQTY50
						,0 AS WQTY51, 0 AS WQTY52
						,Y.CREATED_BY,Y.CREATION_DATE,Y.LAST_UPDATED_BY,Y.LAST_UPDATE_DATE
						,Y.ATTRIBUTE1,Y.ATTRIBUTE2,Y.ATTRIBUTE3,Y.ATTRIBUTE4,Y.ATTRIBUTE5,Y.ATTRIBUTE6,Y.ATTRIBUTE7,Y.ATTRIBUTE8,Y.ATTRIBUTE9, Y.ATTRIBUTE10
						INTO #PSI_GLOBAL_FINAL
				  FROM (
						SELECT S.CELL_ITEM_ID, S.ITEM_ID, S.FROM_SITE, SUM(S.CNT) AS CNT
						  FROM (
								SELECT  CELL_ITEM_ID, ITEM_ID, FROM_SITE
									   ,(CASE WHEN MEASURE = 'PACK_CELL_BOH' THEN 1 ELSE 2 END) CNT
								  FROM SCP_XLS_PSI_GLOBAL A with (nolock)
								 WHERE A.DIVISION_ID			= @p_division_id
								   AND A.CREATE_FROM_YYYYMMDD	= @p_create_from_yyyymmdd
								   AND A.MEASURE				IN ('PACK_CELL_BOH_HOLD', 'PACK_CELL_BOH')
								   AND A.CELL_ITEM_ID IS NOT NULL
							   ) S
						 GROUP BY S.CELL_ITEM_ID, S.ITEM_ID, S.FROM_SITE
					   ) X
				 INNER JOIN SCP_XLS_PSI_GLOBAL Y with (nolock)
					ON X.CELL_ITEM_ID = Y.CELL_ITEM_ID
				   AND X.ITEM_ID      = Y.ITEM_ID
				   AND X.FROM_SITE    = Y.FROM_SITE
				 INNER JOIN (SELECT * FROM SCM_MST_SHEET_MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'PACK_CELL_BOH' AND PROGRAM_ID = 'XLSPSI01') B
					ON Y.MEASURE	  = B.COLUMN_NAME
				 WHERE X.CNT = 1
				   AND Y.DIVISION_ID			= @p_division_id
				   AND Y.CREATE_FROM_YYYYMMDD	= @p_create_from_yyyymmdd
				   AND Y.MEASURE				= 'PACK_CELL_BOH'
				   AND Y.CELL_ITEM_ID IS NOT NULL
				   ;

				-- 2022.08.30   KSW			Cell 재고 개선건
				-- PACK_CELL_BOH_HOLD measure가 없는 PACK_CELL_BOH 그룹에 PACK_CELL_BOH_HOLD 추가
				INSERT   SCP_XLS_PSI_GLOBAL
						(DIVISION_ID
						,PLAN_START_YYYYMMDD
						,CREATE_FROM_YYYYMMDD
						,CREATE_TO_YYYYMMDD
						,PLAN_TYPE,SEQ
						,OPERATION_GROUP
						,OPERATION_GROUP_NAME
						,CELL_ITEM_ID
						,ITEM_ID
						,NICK_NAME
						,CELL_QTY_PACK
						,TO_SITE
						,TO_SITE_DESCRIPTION
						,PROJECT_CODE
						,FROM_BOH_QTY
						,TO_BOH_QTY
						,INCOTERMS
						,FROM_SITE
						,FROM_SITE_DESCRIPTION
						,TRANSPORT_MODE
						,PROD_LINE
						,LT_DAY
						,BOD_ID
						,MEASURE
						,MEASURE_LABEL
						,XLS_KEY1
						,XLS_KEY2
						,XLS_KEY3
						,XLS_KEY4,XLS_KEY5
						,XLS_ATTRIBUTE1,XLS_ATTRIBUTE2,XLS_ATTRIBUTE3,XLS_ATTRIBUTE4,XLS_ATTRIBUTE5
						,SORT_ORDER_NO

						,QTY001,QTY002,QTY003,QTY004,QTY005,QTY006,QTY007,QTY008,QTY009,QTY010
						,QTY011,QTY012,QTY013,QTY014,QTY015,QTY016,QTY017,QTY018,QTY019,QTY020
						,QTY021,QTY022,QTY023,QTY024,QTY025,QTY026,QTY027,QTY028,QTY029,QTY030
						,QTY031,QTY032,QTY033,QTY034,QTY035,QTY036,QTY037,QTY038,QTY039,QTY040
						,QTY041,QTY042,QTY043,QTY044,QTY045,QTY046,QTY047,QTY048,QTY049,QTY050
						,QTY051,QTY052,QTY053,QTY054,QTY055,QTY056,QTY057,QTY058,QTY059,QTY060
						,QTY061,QTY062,QTY063,QTY064,QTY065,QTY066,QTY067,QTY068,QTY069,QTY070
						,QTY071,QTY072,QTY073,QTY074,QTY075,QTY076,QTY077,QTY078,QTY079,QTY080
						,QTY081,QTY082,QTY083,QTY084,QTY085,QTY086,QTY087,QTY088,QTY089,QTY090
						,QTY091,QTY092,QTY093,QTY094,QTY095,QTY096,QTY097,QTY098,QTY099,QTY100

						,QTY101,QTY102,QTY103,QTY104,QTY105,QTY106,QTY107,QTY108,QTY109,QTY110
						,QTY111,QTY112,QTY113,QTY114,QTY115,QTY116,QTY117,QTY118,QTY119,QTY120
						,QTY121,QTY122,QTY123,QTY124,QTY125,QTY126,QTY127,QTY128,QTY129,QTY130
						,QTY131,QTY132,QTY133,QTY134,QTY135,QTY136,QTY137,QTY138,QTY139,QTY140
						,QTY141,QTY142,QTY143,QTY144,QTY145,QTY146,QTY147,QTY148,QTY149,QTY150
						,QTY151,QTY152,QTY153,QTY154,QTY155,QTY156,QTY157,QTY158,QTY159,QTY160
						,QTY161,QTY162,QTY163,QTY164,QTY165,QTY166,QTY167,QTY168,QTY169,QTY170
						,QTY171,QTY172,QTY173,QTY174,QTY175,QTY176,QTY177,QTY178,QTY179,QTY180
						,QTY181,QTY182,QTY183,QTY184,QTY185,QTY186,QTY187,QTY188,QTY189,QTY190
						,QTY191,QTY192,QTY193,QTY194,QTY195,QTY196,QTY197,QTY198,QTY199,QTY200

						,QTY201,QTY202,QTY203,QTY204,QTY205,QTY206,QTY207,QTY208,QTY209,QTY210
						,QTY211,QTY212,QTY213,QTY214,QTY215,QTY216,QTY217,QTY218,QTY219,QTY220
						,QTY221,QTY222,QTY223,QTY224,QTY225,QTY226,QTY227,QTY228,QTY229,QTY230
						,QTY231,QTY232,QTY233,QTY234,QTY235,QTY236,QTY237,QTY238,QTY239,QTY240
						,QTY241,QTY242,QTY243,QTY244,QTY245,QTY246,QTY247,QTY248,QTY249,QTY250
						,QTY251,QTY252,QTY253,QTY254,QTY255,QTY256,QTY257,QTY258,QTY259,QTY260
						,QTY261,QTY262,QTY263,QTY264,QTY265,QTY266,QTY267,QTY268,QTY269,QTY270
						,QTY271,QTY272,QTY273,QTY274,QTY275,QTY276,QTY277,QTY278,QTY279,QTY280
						,QTY281,QTY282,QTY283,QTY284,QTY285,QTY286,QTY287,QTY288,QTY289,QTY290
						,QTY291,QTY292,QTY293,QTY294,QTY295,QTY296,QTY297,QTY298,QTY299,QTY300

						,QTY301,QTY302,QTY303,QTY304,QTY305,QTY306,QTY307,QTY308,QTY309,QTY310
						,QTY311,QTY312,QTY313,QTY314,QTY315,QTY316,QTY317,QTY318,QTY319,QTY320
						,QTY321,QTY322,QTY323,QTY324,QTY325,QTY326,QTY327,QTY328,QTY329,QTY330
						,QTY331,QTY332,QTY333,QTY334,QTY335,QTY336,QTY337,QTY338,QTY339,QTY340
						,QTY341,QTY342,QTY343,QTY344,QTY345,QTY346,QTY347,QTY348,QTY349,QTY350
						,QTY351,QTY352,QTY353,QTY354,QTY355,QTY356,QTY357,QTY358,QTY359,QTY360
						,QTY361,QTY362,QTY363,QTY364

						,WQTY01,WQTY02,WQTY03,WQTY04,WQTY05,WQTY06,WQTY07,WQTY08,WQTY09,WQTY10
						,WQTY11,WQTY12,WQTY13,WQTY14,WQTY15,WQTY16,WQTY17,WQTY18,WQTY19,WQTY20
						,WQTY21,WQTY22,WQTY23,WQTY24,WQTY25,WQTY26,WQTY27,WQTY28,WQTY29,WQTY30
						,WQTY31,WQTY32,WQTY33,WQTY34,WQTY35,WQTY36,WQTY37,WQTY38,WQTY39,WQTY40
						,WQTY41,WQTY42,WQTY43,WQTY44,WQTY45,WQTY46,WQTY47,WQTY48,WQTY49,WQTY50
						,WQTY51,WQTY52
						,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
						,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9, ATTRIBUTE10
						)
				SELECT * FROM #PSI_GLOBAL_FINAL


				-- 2022.10.11	KSW			W01 ~ W08 주차 합산 생산계획이 0 일 경우 1 추가 건에 대한 처리 - START
				-- W01 ~ W08 주차 0 엔진계획이 0 값 모델 리스트
				IF @p_plan_type = 'PR' AND @p_create_from_yyyymmdd = @p_plan_start_yyyymmdd
				BEGIN
					IF OBJECT_ID('tempdb..#tmp_W1W8_ZERO_MODEL') IS NOT NULL	
						  DROP TABLE #tmp_W1W8_ZERO_MODEL

					SELECT ITEM_ID, SCM_SITE_ID, LINE_ID
					  INTO #tmp_W1W8_ZERO_MODEL
					  FROM (
							SELECT ITEM_ID, SCM_SITE_ID, LINE_ID, SUM(QTY) AS S_QTY
							  FROM SCP_ANL_PRODUCTION_PLAN WITH (NOLOCK)
							 WHERE DIVISION_ID			= @p_division_id
							   AND PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
							   AND PLAN_TYPE			= @p_plan_type
							   AND SEQ					= @p_seq
							   AND MEASURE				= 'PROD_PLAN_AMEND'
							   --AND YYYYMMDD BETWEEN @p_plan_start_yyyymmdd AND CONVERT(VARCHAR(8), DATEADD(day,  7 * 8, @p_plan_start_yyyymmdd), 112)
							   AND YYYYMMDD BETWEEN @p_plan_start_yyyymmdd AND @p_create_to_yyyymmdd	-- 8주에서 전체 플랜구간
							 GROUP BY ITEM_ID, SCM_SITE_ID, LINE_ID
						   ) S
					 WHERE S.S_QTY = 0
					 ;

					UPDATE X
					   SET X.XLS_ATTRIBUTE1 = 'A_SET'
					      --,X.QTY001			= 1		-- 저장할 때 1값 저장하는 것으로 변경
						  --,X.WQTY01			= 1
					  FROM SCP_XLS_PSI_GLOBAL X
					 INNER JOIN #tmp_W1W8_ZERO_MODEL Z WITH (NOLOCK)
						ON X.ITEM_ID	= Z.ITEM_ID
					   AND X.FROM_SITE	= Z.SCM_SITE_ID
					   AND X.PROD_LINE	= Z.LINE_ID
					 WHERE X.DIVISION_ID			= @p_division_id
					   AND X.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
					   AND X.CREATE_FROM_YYYYMMDD	= @p_create_from_yyyymmdd
					   AND X.PLAN_TYPE				= @p_plan_type
					   AND X.SEQ					= @p_seq
					   AND X.MEASURE				IN ('PACK_PROD', 'CELL_PROD')
					   ;

					IF OBJECT_ID('tempdb..#tmp_W1W8_ZERO_MODEL') IS NOT NULL	
						  DROP TABLE #tmp_W1W8_ZERO_MODEL
				 END
				 -- 2022.10.11	KSW			W01 ~ W08 주차 합산 생산계획이 0 일 경우 1 추가 건에 대한 처리 - END

      
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
                                ,@p_log_message  = @v_log_message       
                                ,@p_description   = @v_description       
                                ,@p_event_date    = @d_event_date       
                                ,@p_user_id       = @v_batch_user      
                                ;      
--      PRINT @@ERROR      
      return -1      
    END CATCH;      
      
  
-- 임시 운영반영시에 주석처리 할것.    
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
