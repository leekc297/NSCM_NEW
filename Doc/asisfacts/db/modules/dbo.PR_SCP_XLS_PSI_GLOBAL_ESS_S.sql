

/*      
 * Program ID   : PR_SCP_XLS_PSI_GLOBAL_ESS_S        
 * Description  : PR_SCP_XLS_CREATE_DATA 에서 호출함.      
 * OutTable     :      
 * Execute      : 
    -- DELETE FROM SCM_SYS_LOG_BATCH where CREATED_BY ='kth'
      EXEC PR_SCP_XLS_PSI_GLOBAL_ESS_S
               @p_plan_cycle          = 'WEEKLY'
             , @p_plan_start_yyyymmdd = '20190325'
             , @p_plan_id             = '1071'
             , @p_modeling_id         = '2'
             , @p_seq                 = '1'
             , @p_plan_type           = 'PR'
             , @p_master_id           = '81::WEEKLY'
             , @p_division_id         = '81'
             , @p_engine_plan_id      = '1071::PR::1'
             , @p_user_id             = 'KTH'
 
    SELECT * FROM SCM_SYS_LOG_BATCH  where PROGRAM_NAME ='PR_SCP_XLS_PSI_GLOBAL_ESS_S' order by CREATION_DATE desc

 * Program History      
 *===================================================================================================      
 *   Date       In Charge      Description      
 *===================================================================================================      
 * 2021.05.25   KSW         NICK_NAME 누락방지
 * 2021.06.02   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전으로 신규생성
                            - 구 버전에서 PIVOT 생성단계 이후 단계를 호출하는 로직으로 분리함 (1 YEAR 구간별 생성 :: 중장기 구현시 컬럼 및 행 SIZE 제약 해결)
 * 2021.08.23   KSW         PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V
 * 2021.11.15   KSW         튜닝개선 - 0값 제거 및 쿼리재조정
 * 2021.12.22   KSW			DC.Link 적용 - ATTRIBUTE6 update
 * 2021.04.01   KSW         DC LINK 공용모델 적용
 * 2022.05.12   KSW         복수 BOD 수립관련건 적용
 * 2022.07.01	KSK		    PJ20230691  SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화 분리
 * 2025.08.12	KSK         E20250805-000724	ess 사업부 시뮬레이터 특정 모델 저장 안되는 이슈
 * 2025.09.02	kimcd		속도 개선 HASH 추가 
 * 2026.06.19   ymh         E20260618-001229 ESS 시뮬레이터 중복 키값 호출 로직 추가 시작 - dc link 코드목록 넣는부분 item_code 순서대로 넣음.
 */    

 

CREATE PROCEDURE [dbo].[PR_SCP_XLS_PSI_GLOBAL_ESS_S]
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
	, @p_is_debug				 bit = 0 --0 : RELEASE, 1 : DEBUG
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
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_XLS_PSI_GLOBAL_ESS_S';      
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

    DECLARE @p_program_id   NVARCHAR(30) = 'XLSPSI14'          
    --DECLARE @p_to_yyyymmdd  VARCHAR(8)   =  CONVERT(VARCHAR(8), DATEADD(day, 364, @p_plan_start_yyyymmdd), 112)
    --DECLARE @p_cutoff_date  VARCHAR(8)   =  CONVERT(VARCHAR(8), DATEADD(day,  -1, @p_plan_start_yyyymmdd), 112)

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

            
 

            -------------------------------------------------------------------------------------------------------------         
            -- 전체 임시 테이블 생성  (#SCP_XLS_PSI_GLOBAL_ESS)
            -------------------------------------------------------------------------------------------------------------  
                IF OBJECT_ID('tempdb..#SCP_XLS_PSI_GLOBAL_ESS') IS NOT NULL	
	                  DROP TABLE #SCP_XLS_PSI_GLOBAL_ESS

              --DROP TABLE #SCP_XLS_PSI_GLOBAL_ESS
              CREATE TABLE #SCP_XLS_PSI_GLOBAL_ESS(
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
	              
				 QTY001 NUMERIC(20,10) DEFAULT(0),QTY002 NUMERIC(20,10) DEFAULT(0),QTY003 NUMERIC(20,10) DEFAULT(0),QTY004 NUMERIC(20,10) DEFAULT(0),QTY005 NUMERIC(20,10) DEFAULT(0),QTY006 NUMERIC(20,10) DEFAULT(0),QTY007 NUMERIC(20,10) DEFAULT(0),QTY008 NUMERIC(20,10) DEFAULT(0),QTY009 NUMERIC(20,10) DEFAULT(0),QTY010 NUMERIC(20,10) DEFAULT(0),QTY011 NUMERIC(20,10) DEFAULT(0),QTY012 NUMERIC(20,10) DEFAULT(0),QTY013 NUMERIC(20,10) DEFAULT(0),QTY014 NUMERIC(20,10) DEFAULT(0),QTY015 NUMERIC(20,10) DEFAULT(0),QTY016 NUMERIC(20,10) DEFAULT(0),QTY017 NUMERIC(20,10) DEFAULT(0),QTY018 NUMERIC(20,10) DEFAULT(0),QTY019 NUMERIC(20,10) DEFAULT(0),QTY020 NUMERIC(20,10) DEFAULT(0),QTY021 NUMERIC(20,10) DEFAULT(0),QTY022 NUMERIC(20,10) DEFAULT(0),QTY023 NUMERIC(20,10) DEFAULT(0),QTY024 NUMERIC(20,10) DEFAULT(0),QTY025 NUMERIC(20,10) DEFAULT(0),QTY026 NUMERIC(20,10) DEFAULT(0),QTY027 NUMERIC(20,10) DEFAULT(0),QTY028 NUMERIC(20,10) DEFAULT(0),QTY029 NUMERIC(20,10) DEFAULT(0),QTY030 NUMERIC(20,10) DEFAULT(0),QTY031 NUMERIC(20,10) DEFAULT(0),QTY032 NUMERIC(20,10) DEFAULT(0),QTY033 NUMERIC(20,10) DEFAULT(0),QTY034 NUMERIC(20,10) DEFAULT(0),QTY035 NUMERIC(20,10) DEFAULT(0),QTY036 NUMERIC(20,10) DEFAULT(0),QTY037 NUMERIC(20,10) DEFAULT(0),QTY038 NUMERIC(20,10) DEFAULT(0),QTY039 NUMERIC(20,10) DEFAULT(0),QTY040 NUMERIC(20,10) DEFAULT(0),QTY041 NUMERIC(20,10) DEFAULT(0),QTY042 NUMERIC(20,10) DEFAULT(0),QTY043 NUMERIC(20,10) DEFAULT(0),QTY044 NUMERIC(20,10) DEFAULT(0),QTY045 NUMERIC(20,10) DEFAULT(0),QTY046 NUMERIC(20,10) DEFAULT(0),QTY047 NUMERIC(20,10) DEFAULT(0),QTY048 NUMERIC(20,10) DEFAULT(0),QTY049 NUMERIC(20,10) DEFAULT(0),QTY050 NUMERIC(20,10) DEFAULT(0),QTY051 NUMERIC(20,10) DEFAULT(0),QTY052 NUMERIC(20,10) DEFAULT(0),QTY053 NUMERIC(20,10) DEFAULT(0),QTY054 NUMERIC(20,10) DEFAULT(0),QTY055 NUMERIC(20,10) DEFAULT(0),QTY056 NUMERIC(20,10) DEFAULT(0),QTY057 NUMERIC(20,10) DEFAULT(0),QTY058 NUMERIC(20,10) DEFAULT(0),QTY059 NUMERIC(20,10) DEFAULT(0),QTY060 NUMERIC(20,10) DEFAULT(0),QTY061 NUMERIC(20,10) DEFAULT(0),QTY062 NUMERIC(20,10) DEFAULT(0),QTY063 NUMERIC(20,10) DEFAULT(0),QTY064 NUMERIC(20,10) DEFAULT(0),QTY065 NUMERIC(20,10) DEFAULT(0),QTY066 NUMERIC(20,10) DEFAULT(0),QTY067 NUMERIC(20,10) DEFAULT(0),QTY068 NUMERIC(20,10) DEFAULT(0),QTY069 NUMERIC(20,10) DEFAULT(0),QTY070 NUMERIC(20,10) DEFAULT(0),QTY071 NUMERIC(20,10) DEFAULT(0),QTY072 NUMERIC(20,10) DEFAULT(0),QTY073 NUMERIC(20,10) DEFAULT(0),QTY074 NUMERIC(20,10) DEFAULT(0),QTY075 NUMERIC(20,10) DEFAULT(0),QTY076 NUMERIC(20,10) DEFAULT(0),QTY077 NUMERIC(20,10) DEFAULT(0),QTY078 NUMERIC(20,10) DEFAULT(0),QTY079 NUMERIC(20,10) DEFAULT(0),QTY080 NUMERIC(20,10) DEFAULT(0),QTY081 NUMERIC(20,10) DEFAULT(0),QTY082 NUMERIC(20,10) DEFAULT(0),QTY083 NUMERIC(20,10) DEFAULT(0),QTY084 NUMERIC(20,10) DEFAULT(0),QTY085 NUMERIC(20,10) DEFAULT(0),QTY086 NUMERIC(20,10) DEFAULT(0),QTY087 NUMERIC(20,10) DEFAULT(0),QTY088 NUMERIC(20,10) DEFAULT(0),QTY089 NUMERIC(20,10) DEFAULT(0),QTY090 NUMERIC(20,10) DEFAULT(0),QTY091 NUMERIC(20,10) DEFAULT(0),QTY092 NUMERIC(20,10) DEFAULT(0),QTY093 NUMERIC(20,10) DEFAULT(0),QTY094 NUMERIC(20,10) DEFAULT(0),QTY095 NUMERIC(20,10) DEFAULT(0),QTY096 NUMERIC(20,10) DEFAULT(0),QTY097 NUMERIC(20,10) DEFAULT(0),QTY098 NUMERIC(20,10) DEFAULT(0),QTY099 NUMERIC(20,10) DEFAULT(0),QTY100 NUMERIC(20,10) DEFAULT(0),QTY101 NUMERIC(20,10) DEFAULT(0),QTY102 NUMERIC(20,10) DEFAULT(0),QTY103 NUMERIC(20,10) DEFAULT(0),QTY104 NUMERIC(20,10) DEFAULT(0),QTY105 NUMERIC(20,10) DEFAULT(0),QTY106 NUMERIC(20,10) DEFAULT(0),QTY107 NUMERIC(20,10) DEFAULT(0),QTY108 NUMERIC(20,10) DEFAULT(0),QTY109 NUMERIC(20,10) DEFAULT(0),QTY110 NUMERIC(20,10) DEFAULT(0),QTY111 NUMERIC(20,10) DEFAULT(0),QTY112 NUMERIC(20,10) DEFAULT(0),QTY113 NUMERIC(20,10) DEFAULT(0),QTY114 NUMERIC(20,10) DEFAULT(0),QTY115 NUMERIC(20,10) DEFAULT(0),QTY116 NUMERIC(20,10) DEFAULT(0),QTY117 NUMERIC(20,10) DEFAULT(0),QTY118 NUMERIC(20,10) DEFAULT(0),QTY119 NUMERIC(20,10) DEFAULT(0),QTY120 NUMERIC(20,10) DEFAULT(0),QTY121 NUMERIC(20,10) DEFAULT(0),QTY122 NUMERIC(20,10) DEFAULT(0),QTY123 NUMERIC(20,10) DEFAULT(0),QTY124 NUMERIC(20,10) DEFAULT(0),QTY125 NUMERIC(20,10) DEFAULT(0),QTY126 NUMERIC(20,10) DEFAULT(0),QTY127 NUMERIC(20,10) DEFAULT(0),QTY128 NUMERIC(20,10) DEFAULT(0),QTY129 NUMERIC(20,10) DEFAULT(0),QTY130 NUMERIC(20,10) DEFAULT(0),QTY131 NUMERIC(20,10) DEFAULT(0),QTY132 NUMERIC(20,10) DEFAULT(0),QTY133 NUMERIC(20,10) DEFAULT(0),QTY134 NUMERIC(20,10) DEFAULT(0),QTY135 NUMERIC(20,10) DEFAULT(0),QTY136 NUMERIC(20,10) DEFAULT(0),QTY137 NUMERIC(20,10) DEFAULT(0),QTY138 NUMERIC(20,10) DEFAULT(0),QTY139 NUMERIC(20,10) DEFAULT(0),QTY140 NUMERIC(20,10) DEFAULT(0),QTY141 NUMERIC(20,10) DEFAULT(0),QTY142 NUMERIC(20,10) DEFAULT(0),QTY143 NUMERIC(20,10) DEFAULT(0),QTY144 NUMERIC(20,10) DEFAULT(0),QTY145 NUMERIC(20,10) DEFAULT(0),QTY146 NUMERIC(20,10) DEFAULT(0),QTY147 NUMERIC(20,10) DEFAULT(0),QTY148 NUMERIC(20,10) DEFAULT(0),QTY149 NUMERIC(20,10) DEFAULT(0),QTY150 NUMERIC(20,10) DEFAULT(0),QTY151 NUMERIC(20,10) DEFAULT(0),QTY152 NUMERIC(20,10) DEFAULT(0),QTY153 NUMERIC(20,10) DEFAULT(0),QTY154 NUMERIC(20,10) DEFAULT(0),QTY155 NUMERIC(20,10) DEFAULT(0),QTY156 NUMERIC(20,10) DEFAULT(0),QTY157 NUMERIC(20,10) DEFAULT(0),QTY158 NUMERIC(20,10) DEFAULT(0),QTY159 NUMERIC(20,10) DEFAULT(0),QTY160 NUMERIC(20,10) DEFAULT(0),QTY161 NUMERIC(20,10) DEFAULT(0),QTY162 NUMERIC(20,10) DEFAULT(0),QTY163 NUMERIC(20,10) DEFAULT(0),QTY164 NUMERIC(20,10) DEFAULT(0),QTY165 NUMERIC(20,10) DEFAULT(0),QTY166 NUMERIC(20,10) DEFAULT(0),QTY167 NUMERIC(20,10) DEFAULT(0),QTY168 NUMERIC(20,10) DEFAULT(0),QTY169 NUMERIC(20,10) DEFAULT(0),QTY170 NUMERIC(20,10) DEFAULT(0),QTY171 NUMERIC(20,10) DEFAULT(0),QTY172 NUMERIC(20,10) DEFAULT(0),QTY173 NUMERIC(20,10) DEFAULT(0),QTY174 NUMERIC(20,10) DEFAULT(0),QTY175 NUMERIC(20,10) DEFAULT(0),QTY176 NUMERIC(20,10) DEFAULT(0),QTY177 NUMERIC(20,10) DEFAULT(0),QTY178 NUMERIC(20,10) DEFAULT(0),QTY179 NUMERIC(20,10) DEFAULT(0),QTY180 NUMERIC(20,10) DEFAULT(0),QTY181 NUMERIC(20,10) DEFAULT(0),QTY182 NUMERIC(20,10) DEFAULT(0),QTY183 NUMERIC(20,10) DEFAULT(0),QTY184 NUMERIC(20,10) DEFAULT(0),QTY185 NUMERIC(20,10) DEFAULT(0),QTY186 NUMERIC(20,10) DEFAULT(0),QTY187 NUMERIC(20,10) DEFAULT(0),QTY188 NUMERIC(20,10) DEFAULT(0),QTY189 NUMERIC(20,10) DEFAULT(0),QTY190 NUMERIC(20,10) DEFAULT(0),QTY191 NUMERIC(20,10) DEFAULT(0),QTY192 NUMERIC(20,10) DEFAULT(0),QTY193 NUMERIC(20,10) DEFAULT(0),QTY194 NUMERIC(20,10) DEFAULT(0),QTY195 NUMERIC(20,10) DEFAULT(0),QTY196 NUMERIC(20,10) DEFAULT(0),QTY197 NUMERIC(20,10) DEFAULT(0),QTY198 NUMERIC(20,10) DEFAULT(0),QTY199 NUMERIC(20,10) DEFAULT(0),QTY200 NUMERIC(20,10) DEFAULT(0),QTY201 NUMERIC(20,10) DEFAULT(0),QTY202 NUMERIC(20,10) DEFAULT(0),QTY203 NUMERIC(20,10) DEFAULT(0),QTY204 NUMERIC(20,10) DEFAULT(0),QTY205 NUMERIC(20,10) DEFAULT(0),QTY206 NUMERIC(20,10) DEFAULT(0),QTY207 NUMERIC(20,10) DEFAULT(0),QTY208 NUMERIC(20,10) DEFAULT(0),QTY209 NUMERIC(20,10) DEFAULT(0),QTY210 NUMERIC(20,10) DEFAULT(0),QTY211 NUMERIC(20,10) DEFAULT(0),QTY212 NUMERIC(20,10) DEFAULT(0),QTY213 NUMERIC(20,10) DEFAULT(0),QTY214 NUMERIC(20,10) DEFAULT(0),QTY215 NUMERIC(20,10) DEFAULT(0),QTY216 NUMERIC(20,10) DEFAULT(0),QTY217 NUMERIC(20,10) DEFAULT(0),QTY218 NUMERIC(20,10) DEFAULT(0),QTY219 NUMERIC(20,10) DEFAULT(0),QTY220 NUMERIC(20,10) DEFAULT(0),QTY221 NUMERIC(20,10) DEFAULT(0),QTY222 NUMERIC(20,10) DEFAULT(0),QTY223 NUMERIC(20,10) DEFAULT(0),QTY224 NUMERIC(20,10) DEFAULT(0),QTY225 NUMERIC(20,10) DEFAULT(0),QTY226 NUMERIC(20,10) DEFAULT(0),QTY227 NUMERIC(20,10) DEFAULT(0),QTY228 NUMERIC(20,10) DEFAULT(0),QTY229 NUMERIC(20,10) DEFAULT(0),QTY230 NUMERIC(20,10) DEFAULT(0),QTY231 NUMERIC(20,10) DEFAULT(0),QTY232 NUMERIC(20,10) DEFAULT(0),QTY233 NUMERIC(20,10) DEFAULT(0),QTY234 NUMERIC(20,10) DEFAULT(0),QTY235 NUMERIC(20,10) DEFAULT(0),QTY236 NUMERIC(20,10) DEFAULT(0),QTY237 NUMERIC(20,10) DEFAULT(0),QTY238 NUMERIC(20,10) DEFAULT(0),QTY239 NUMERIC(20,10) DEFAULT(0),QTY240 NUMERIC(20,10) DEFAULT(0),QTY241 NUMERIC(20,10) DEFAULT(0),QTY242 NUMERIC(20,10) DEFAULT(0),QTY243 NUMERIC(20,10) DEFAULT(0),QTY244 NUMERIC(20,10) DEFAULT(0),QTY245 NUMERIC(20,10) DEFAULT(0),QTY246 NUMERIC(20,10) DEFAULT(0),QTY247 NUMERIC(20,10) DEFAULT(0),QTY248 NUMERIC(20,10) DEFAULT(0),QTY249 NUMERIC(20,10) DEFAULT(0),QTY250 NUMERIC(20,10) DEFAULT(0),QTY251 NUMERIC(20,10) DEFAULT(0),QTY252 NUMERIC(20,10) DEFAULT(0),QTY253 NUMERIC(20,10) DEFAULT(0),QTY254 NUMERIC(20,10) DEFAULT(0),QTY255 NUMERIC(20,10) DEFAULT(0),QTY256 NUMERIC(20,10) DEFAULT(0),QTY257 NUMERIC(20,10) DEFAULT(0),QTY258 NUMERIC(20,10) DEFAULT(0),QTY259 NUMERIC(20,10) DEFAULT(0),QTY260 NUMERIC(20,10) DEFAULT(0),QTY261 NUMERIC(20,10) DEFAULT(0),QTY262 NUMERIC(20,10) DEFAULT(0),QTY263 NUMERIC(20,10) DEFAULT(0),QTY264 NUMERIC(20,10) DEFAULT(0),QTY265 NUMERIC(20,10) DEFAULT(0),QTY266 NUMERIC(20,10) DEFAULT(0),QTY267 NUMERIC(20,10) DEFAULT(0),QTY268 NUMERIC(20,10) DEFAULT(0),QTY269 NUMERIC(20,10) DEFAULT(0),QTY270 NUMERIC(20,10) DEFAULT(0),QTY271 NUMERIC(20,10) DEFAULT(0),QTY272 NUMERIC(20,10) DEFAULT(0),QTY273 NUMERIC(20,10) DEFAULT(0),QTY274 NUMERIC(20,10) DEFAULT(0),QTY275 NUMERIC(20,10) DEFAULT(0),QTY276 NUMERIC(20,10) DEFAULT(0),QTY277 NUMERIC(20,10) DEFAULT(0),QTY278 NUMERIC(20,10) DEFAULT(0),QTY279 NUMERIC(20,10) DEFAULT(0),QTY280 NUMERIC(20,10) DEFAULT(0),QTY281 NUMERIC(20,10) DEFAULT(0),QTY282 NUMERIC(20,10) DEFAULT(0),QTY283 NUMERIC(20,10) DEFAULT(0),QTY284 NUMERIC(20,10) DEFAULT(0),QTY285 NUMERIC(20,10) DEFAULT(0),QTY286 NUMERIC(20,10) DEFAULT(0),QTY287 NUMERIC(20,10) DEFAULT(0),QTY288 NUMERIC(20,10) DEFAULT(0),QTY289 NUMERIC(20,10) DEFAULT(0),QTY290 NUMERIC(20,10) DEFAULT(0),QTY291 NUMERIC(20,10) DEFAULT(0),QTY292 NUMERIC(20,10) DEFAULT(0),QTY293 NUMERIC(20,10) DEFAULT(0),QTY294 NUMERIC(20,10) DEFAULT(0),QTY295 NUMERIC(20,10) DEFAULT(0),QTY296 NUMERIC(20,10) DEFAULT(0),QTY297 NUMERIC(20,10) DEFAULT(0),QTY298 NUMERIC(20,10) DEFAULT(0),QTY299 NUMERIC(20,10) DEFAULT(0),QTY300 NUMERIC(20,10) DEFAULT(0),QTY301 NUMERIC(20,10) DEFAULT(0),QTY302 NUMERIC(20,10) DEFAULT(0),QTY303 NUMERIC(20,10) DEFAULT(0),QTY304 NUMERIC(20,10) DEFAULT(0),QTY305 NUMERIC(20,10) DEFAULT(0),QTY306 NUMERIC(20,10) DEFAULT(0),QTY307 NUMERIC(20,10) DEFAULT(0),QTY308 NUMERIC(20,10) DEFAULT(0),QTY309 NUMERIC(20,10) DEFAULT(0),QTY310 NUMERIC(20,10) DEFAULT(0),QTY311 NUMERIC(20,10) DEFAULT(0),QTY312 NUMERIC(20,10) DEFAULT(0),QTY313 NUMERIC(20,10) DEFAULT(0),QTY314 NUMERIC(20,10) DEFAULT(0),QTY315 NUMERIC(20,10) DEFAULT(0),QTY316 NUMERIC(20,10) DEFAULT(0),QTY317 NUMERIC(20,10) DEFAULT(0),QTY318 NUMERIC(20,10) DEFAULT(0),QTY319 NUMERIC(20,10) DEFAULT(0),QTY320 NUMERIC(20,10) DEFAULT(0),QTY321 NUMERIC(20,10) DEFAULT(0),QTY322 NUMERIC(20,10) DEFAULT(0),QTY323 NUMERIC(20,10) DEFAULT(0),QTY324 NUMERIC(20,10) DEFAULT(0),QTY325 NUMERIC(20,10) DEFAULT(0),QTY326 NUMERIC(20,10) DEFAULT(0),QTY327 NUMERIC(20,10) DEFAULT(0),QTY328 NUMERIC(20,10) DEFAULT(0),QTY329 NUMERIC(20,10) DEFAULT(0),QTY330 NUMERIC(20,10) DEFAULT(0),QTY331 NUMERIC(20,10) DEFAULT(0),QTY332 NUMERIC(20,10) DEFAULT(0),QTY333 NUMERIC(20,10) DEFAULT(0),QTY334 NUMERIC(20,10) DEFAULT(0),QTY335 NUMERIC(20,10) DEFAULT(0),QTY336 NUMERIC(20,10) DEFAULT(0),QTY337 NUMERIC(20,10) DEFAULT(0),QTY338 NUMERIC(20,10) DEFAULT(0),QTY339 NUMERIC(20,10) DEFAULT(0),QTY340 NUMERIC(20,10) DEFAULT(0),QTY341 NUMERIC(20,10) DEFAULT(0),QTY342 NUMERIC(20,10) DEFAULT(0),QTY343 NUMERIC(20,10) DEFAULT(0),QTY344 NUMERIC(20,10) DEFAULT(0),QTY345 NUMERIC(20,10) DEFAULT(0),QTY346 NUMERIC(20,10) DEFAULT(0),QTY347 NUMERIC(20,10) DEFAULT(0),QTY348 NUMERIC(20,10) DEFAULT(0),QTY349 NUMERIC(20,10) DEFAULT(0),QTY350 NUMERIC(20,10) DEFAULT(0),QTY351 NUMERIC(20,10) DEFAULT(0),QTY352 NUMERIC(20,10) DEFAULT(0),QTY353 NUMERIC(20,10) DEFAULT(0),QTY354 NUMERIC(20,10) DEFAULT(0),QTY355 NUMERIC(20,10) DEFAULT(0),QTY356 NUMERIC(20,10) DEFAULT(0),QTY357 NUMERIC(20,10) DEFAULT(0),QTY358 NUMERIC(20,10) DEFAULT(0),QTY359 NUMERIC(20,10) DEFAULT(0),QTY360 NUMERIC(20,10) DEFAULT(0),QTY361 NUMERIC(20,10) DEFAULT(0),QTY362 NUMERIC(20,10) DEFAULT(0),QTY363 NUMERIC(20,10) DEFAULT(0)
				 ,QTY364 NUMERIC(20,10) DEFAULT(0),

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
                      WHEN 1 = 1 THEN  ' SUM(CASE WHEN YYYYMMDD = '''+YYYYMMDD+'''    THEN ISNULL(QTY, 0) ELSE 0 END ) AS ' + 'QTY' + REPLICATE('0', 3 - LEN(ROW_NUMBER() OVER(ORDER BY YYYYMMDD) )) + CONVERT(NVARCHAR,ROW_NUMBER() OVER(ORDER BY YYYYMMDD))        
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
            --  364일 데이터 생성(PIVOIT 대상 날짜문자열 생성) - 중장기 대응전 소스에서 LT_DAY 를 조인하면 중복으로 조회되는 오류보완
            -------------------------------------------------------------------------------------------------------------         

				  DECLARE @mQry_sum2 NVARCHAR(MAX);      
   
		          SET     @mQry_sum2 = '';
		          SELECT  @mQry_sum2 = @mQry_sum2+','+       
			          CASE  
                      WHEN 1 = 1 THEN  'ISNULL(QTY' + REPLICATE('0', 3 - LEN(ROW_NUMBER() OVER(ORDER BY YYYYMMDD) )) + CONVERT(NVARCHAR,ROW_NUMBER() OVER(ORDER BY YYYYMMDD))        
			          END +',0)'+CHAR(10)      
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
            -- 전체 DATA 생성 (#PSI_GLOBAL_ESS --> #SCP_XLS_PSI_GLOBAL_ESS) PIVOT
            -------------------------------------------------------------------------------------------------------------
              DECLARE @mEXEC NVARCHAR(MAX);

		          SET @mEXEC = '';
              SET @mEXEC = @mEXEC + ' INSERT INTO #SCP_XLS_PSI_GLOBAL_ESS WITH (TABLOCK)  '+CHAR(10);	

		   --       SET @mEXEC = @mEXEC + ' SELECT A.DIVISION_ID														
     --                                       , ''' + @p_plan_start_yyyymmdd +'''	  AS PLAN_START_YYYYMMDD
     --                                       , ''' + @p_plan_type +'''	            AS PLAN_TYPE
     --                                       , ''' + @p_seq +'''	                  AS SEQ
     --                         		          , A.OPERATION_GROUP						
     --                         		          , (SELECT TOP 1 SEGMENT2 NAME FROM SCM_ADM_LOOKUP_MASTER_DETAIL X WITH (NOLOCK) WHERE X.LOOKUP_TYPE = ''OPERATION_GROUP'' AND X.SEGMENT1 = A.OPERATION_GROUP ) AS OPERATION_GROUP_NAME    
     --                         		          , A.CELL_ITEM_ID				
     --                         		          , A.ITEM_ID							
     --                         		          , (SELECT TOP 1 (CASE WHEN X.NICK_NAME IS NULL THEN ''-''  WHEN X.NICK_NAME = ''''    THEN ''-''  ELSE X.NICK_NAME END) FROM DBO.SCM_MST_ITEM_SN X WITH (NOLOCK)  WHERE  X.ITEM_ID  = A.ITEM_ID AND X.DIVISION_ID = ''82'') AS NICK_NAME	
     --                         		          , 0 AS CELL_QTY_PACK					
     --                                       , A.TO_SITE AS TO_SITE
     --                                       , ISNULL(NULLIF( (SELECT TOP 1 M.SITE_DESCRIPTION FROM SCM_MST_SITE M  WITH (NOLOCK) WHERE M.SCM_SITE_ID=A.TO_SITE), '''') , ''-'') AS TO_SITE_DESCRIPTION	
     --                                       , A.PROJECT_CODE		
     --                         		          , A.FROM_BOH_QTY												
     --                         		          , SUM(A.TO_BOH_QTY) AS TO_BOH_QTY
     --                                       , ISNULL(A.INCOTERMS,''-'') AS INCOTERMS	
     --                         		          , A.FROM_SITE								
     --                         		          , ISNULL(NULLIF( (SELECT TOP 1 M.SITE_DESCRIPTION FROM SCM_MST_SITE M  WITH (NOLOCK) WHERE M.SCM_SITE_ID=A.FROM_SITE), '''') , ''-'') AS FROM_SITE_DESCRIPTION	
     --                                       ,ISNULL(A.TRANSPORT_MODE,''-'') AS   TRANSPORT_MODE 
     --                                       ,ISNULL(A.PROD_LINE,''-'') AS      PROD_LINE   
     --                         		          ,ISNULL((CASE WHEN A.BOD_ID=''-'' THEN ''-'' ELSE CONVERT(NVARCHAR(50), (B.LT_TOTAL_BY_WEEK)) END),''0'')   AS LT_DAY
     --                                       ,ISNULL(A.BOD_ID,''-'')  AS BOD_ID
     --                         		          , A.MEASURE
     --                                       , A.COLUMN_LABEL_NAME           AS MEASURE_LABEL '+CHAR(10);	
     --         SET @mEXEC = @mEXEC + ' 		  , CONVERT(NVARCHAR(200), NULL)  AS XLS_KEY1
     --                                       , CONVERT(NVARCHAR(200), NULL)  AS XLS_KEY2
     --                                       , CONVERT(NVARCHAR(200), NULL)  AS XLS_KEY3
     --                                       , CONVERT(NVARCHAR(200), NULL)  AS XLS_KEY4
     --                                       , CONVERT(NVARCHAR(200), NULL)  AS XLS_KEY5
     --                                       , CONVERT(NVARCHAR(200), NULL)  AS XLS_ATTRIBUTE1
     --                                       , CONVERT(NVARCHAR(200), NULL)  AS XLS_ATTRIBUTE2
     --                                       , CONVERT(NVARCHAR(200), NULL)  AS XLS_ATTRIBUTE3
     --                                       , CONVERT(NVARCHAR(200), NULL)  AS XLS_ATTRIBUTE4
     --                                       , CONVERT(NVARCHAR(200), NULL)  AS XLS_ATTRIBUTE5
     --                                       , A.SORT_ORDER_NO									'+CHAR(10);	
		   --       SET @mEXEC = @mEXEC + ' 				' + @mQry_sum +'									'+CHAR(10);	
		   --       SET @mEXEC = @mEXEC + '       , MAX(A.ATTRIBUTE1) AS ATTRIBUTE1'+CHAR(10);	
     --         SET @mEXEC = @mEXEC + '       , NULL AS ATTRIBUTE2'+CHAR(10);	
     --         SET @mEXEC = @mEXEC + '       , NULL AS ATTRIBUTE3, NULL AS ATTRIBUTE4, NULL AS ATTRIBUTE5, NULL AS ATTRIBUTE6, NULL AS ATTRIBUTE7, NULL AS ATTRIBUTE8'+CHAR(10);	
     --         SET @mEXEC = @mEXEC + '       , A.ATTRIBUTE9, NULL AS ATTRIBUTE10                 '+CHAR(10);	
  	  --        SET @mEXEC = @mEXEC + ' 		FROM #PSI_GLOBAL_ESS A WITH (NOLOCK)		        '+CHAR(10);
	    --      SET @mEXEC = @mEXEC + '         LEFT OUTER JOIN #SCP_MST_BOD_V B WITH (NOLOCK)	'+CHAR(10);
	    --      SET @mEXEC = @mEXEC + '             ON 0 = 0 	                                    '+CHAR(10);
	    --      SET @mEXEC = @mEXEC + '             AND B.DIVISION_ID = A.DIVISION_ID 	        '+CHAR(10);
	    --      SET @mEXEC = @mEXEC + '           AND B.BOD_ID      = A.BOD_ID                    '+CHAR(10);
	    --      SET @mEXEC = @mEXEC + '             AND B.FROM_SITE   = A.FROM_SITE               '+CHAR(10);
     --         SET @mEXEC = @mEXEC + '         AND B.TO_SITE     = A.TO_SITE                     '+CHAR(10);
     --         SET @mEXEC = @mEXEC + '         AND B.INCOTERMS   = A.INCOTERMS                   '+CHAR(10);
			  --SET @mEXEC = @mEXEC + '	     AND A.YYYYMMDD    >= ''' + @p_create_from_yyyymmdd + ''''+CHAR(10);
			  --SET @mEXEC = @mEXEC + '	     AND A.YYYYMMDD    <= ''' + @p_create_to_yyyymmdd   + ''''+CHAR(10);
	    --      SET @mEXEC = @mEXEC + '         GROUP BY  A.DIVISION_ID							
	    --                        			              , A.OPERATION_GROUP							
	    --                  			                    , A.CELL_ITEM_ID								
	    --                        			              , A.ITEM_ID											
	    --                        			              , A.TO_SITE
     --                                             , A.PROJECT_CODE
	    --                        			              , A.FROM_BOH_QTY								
	    --                        			              , ISNULL(A.INCOTERMS,''-'')
	    --                        			              , A.FROM_SITE									
     --                                             ,  ISNULL(A.TRANSPORT_MODE ,''-'') 
     --                                             ,  ISNULL(A.PROD_LINE,''-'') 
     --                                             ,  ISNULL(A.BOD_ID,''-'') 
	    --                        			              , A.MEASURE										
	    --                        			              , A.SORT_ORDER_NO							
	    --                        			              , A.COLUMN_LABEL_NAME			
     --                         			              , (CASE WHEN A.BOD_ID=''-'' THEN ''-'' ELSE CONVERT(NVARCHAR(50), (B.LT_TOTAL_BY_WEEK)) END)  
     --                                             , A.ATTRIBUTE9
     --                                             '+CHAR(10);


	          SET @mEXEC = @mEXEC + 'SELECT  DIVISION_ID          '+CHAR(10);
			  SET @mEXEC = @mEXEC + '       ,PLAN_START_YYYYMMDD  '+CHAR(10);
			  SET @mEXEC = @mEXEC + '       ,PLAN_TYPE            '+CHAR(10);
			  SET @mEXEC = @mEXEC + '       ,SEQ                  '+CHAR(10);
			  SET @mEXEC = @mEXEC + '       ,OPERATION_GROUP      '+CHAR(10);
			  SET @mEXEC = @mEXEC + '       ,OPERATION_GROUP_NAME '+CHAR(10);
			  SET @mEXEC = @mEXEC + '       ,CELL_ITEM_ID         '+CHAR(10);
			  SET @mEXEC = @mEXEC + '       ,ITEM_ID              '+CHAR(10);
			  SET @mEXEC = @mEXEC + '       ,NICK_NAME            '+CHAR(10);
			  SET @mEXEC = @mEXEC + '       ,CELL_QTY_PACK        '+CHAR(10);
			  SET @mEXEC = @mEXEC + '       ,TO_SITE              '+CHAR(10);
			  SET @mEXEC = @mEXEC + '       ,TO_SITE_DESCRIPTION  '+CHAR(10);
			  SET @mEXEC = @mEXEC + '       ,PROJECT_CODE         '+CHAR(10);
			  SET @mEXEC = @mEXEC + '       ,FROM_BOH_QTY         '+CHAR(10);
			  SET @mEXEC = @mEXEC + '       ,TO_BOH_QTY           '+CHAR(10);
			  SET @mEXEC = @mEXEC + '       ,INCOTERMS            '+CHAR(10);
			  SET @mEXEC = @mEXEC + '       ,FROM_SITE            '+CHAR(10);
			  SET @mEXEC = @mEXEC + '       ,FROM_SITE_DESCRIPTION'+CHAR(10);
			  SET @mEXEC = @mEXEC + '       ,TRANSPORT_MODE       '+CHAR(10);
			  SET @mEXEC = @mEXEC + '       ,PROD_LINE            '+CHAR(10);
			  SET @mEXEC = @mEXEC + '      	,ISNULL((SELECT TOP 1 LT_TOTAL_BY_WEEK                  '+CHAR(10);
			  SET @mEXEC = @mEXEC + '	               FROM #SCP_MST_BOD_V B WITH (NOLOCK)          '+CHAR(10);
			  SET @mEXEC = @mEXEC + '		          WHERE B.DIVISION_ID = XX.DIVISION_ID          '+CHAR(10);
			  SET @mEXEC = @mEXEC + '			        AND B.BOD_ID      = XX.BOD_ID               '+CHAR(10);
			  SET @mEXEC = @mEXEC + '			        AND B.FROM_SITE   = XX.FROM_SITE            '+CHAR(10);
			  SET @mEXEC = @mEXEC + '			        AND B.TO_SITE     = XX.TO_SITE              '+CHAR(10);
		      SET @mEXEC = @mEXEC + '			        AND B.INCOTERMS   = XX.INCOTERMS), 0) AS LT_DAY '+CHAR(10);
			  SET @mEXEC = @mEXEC + '       ,BOD_ID       '+CHAR(10);
			  SET @mEXEC = @mEXEC + '       ,MEASURE      '+CHAR(10);
			  SET @mEXEC = @mEXEC + '       ,MEASURE_LABEL'+CHAR(10);
			  SET @mEXEC = @mEXEC + '       ,XLS_KEY1'+CHAR(10);
			  SET @mEXEC = @mEXEC + '       ,XLS_KEY2'+CHAR(10);
			  SET @mEXEC = @mEXEC + '       ,XLS_KEY3'+CHAR(10);
			  SET @mEXEC = @mEXEC + '       ,XLS_KEY4'+CHAR(10);
			  SET @mEXEC = @mEXEC + '       ,XLS_KEY5'+CHAR(10);
			  SET @mEXEC = @mEXEC + '       ,XLS_ATTRIBUTE1'+CHAR(10);
			  SET @mEXEC = @mEXEC + '       ,XLS_ATTRIBUTE2'+CHAR(10);
			  SET @mEXEC = @mEXEC + '       ,XLS_ATTRIBUTE3'+CHAR(10);
			  SET @mEXEC = @mEXEC + '       ,XLS_ATTRIBUTE4'+CHAR(10);
			  SET @mEXEC = @mEXEC + '       ,XLS_ATTRIBUTE5'+CHAR(10);
			  SET @mEXEC = @mEXEC + '       ,SORT_ORDER_NO '+CHAR(10);
			  SET @mEXEC = @mEXEC + ' 				' + @mQry_sum2 +'									'+CHAR(10);	
			  SET @mEXEC = @mEXEC + '       ,ATTRIBUTE1'+CHAR(10);
			  SET @mEXEC = @mEXEC + '       ,ATTRIBUTE2'+CHAR(10);
			  SET @mEXEC = @mEXEC + '       ,ATTRIBUTE3'+CHAR(10);
			  SET @mEXEC = @mEXEC + '       ,ATTRIBUTE4'+CHAR(10);
			  SET @mEXEC = @mEXEC + '       ,ATTRIBUTE5'+CHAR(10);
			  SET @mEXEC = @mEXEC + '       ,ATTRIBUTE6'+CHAR(10);
			  SET @mEXEC = @mEXEC + '       ,ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10'+CHAR(10);
			  SET @mEXEC = @mEXEC + '  FROM (  '+CHAR(10);	

		          SET @mEXEC = @mEXEC + ' SELECT A.DIVISION_ID														
                                            , ''' + @p_plan_start_yyyymmdd +'''	  AS PLAN_START_YYYYMMDD
                                            , ''' + @p_plan_type +'''	            AS PLAN_TYPE
                                            , ''' + @p_seq +'''	                  AS SEQ
                              		          , A.OPERATION_GROUP						
                              		          , (SELECT TOP 1 SEGMENT2 NAME FROM SCM_ADM_LOOKUP_MASTER_DETAIL X WITH (NOLOCK) WHERE X.LOOKUP_TYPE = ''OPERATION_GROUP'' AND X.SEGMENT1 = A.OPERATION_GROUP ) AS OPERATION_GROUP_NAME    
                              		          , A.CELL_ITEM_ID				
                              		          , A.ITEM_ID							
                              		          , (SELECT TOP 1 (CASE WHEN X.NICK_NAME IS NULL THEN ''-''  WHEN X.NICK_NAME = ''''    THEN ''-''  ELSE X.NICK_NAME END) FROM DBO.SCM_MST_ITEM_SN X WITH (NOLOCK)  WHERE  X.ITEM_ID  = A.ITEM_ID AND X.DIVISION_ID = ''82'') AS NICK_NAME	
                              		          , 0 AS CELL_QTY_PACK					
                                            , A.TO_SITE AS TO_SITE
                                            , ISNULL(NULLIF( (SELECT TOP 1 M.SITE_DESCRIPTION FROM SCM_MST_SITE M  WITH (NOLOCK) WHERE M.SCM_SITE_ID=A.TO_SITE), '''') , ''-'') AS TO_SITE_DESCRIPTION	
                                            , A.PROJECT_CODE		
                              		          , A.FROM_BOH_QTY												
                              		          , SUM(A.TO_BOH_QTY) AS TO_BOH_QTY
                                            , ISNULL(A.INCOTERMS,''-'') AS INCOTERMS	
                              		          , A.FROM_SITE								
                              		          , ISNULL(NULLIF( (SELECT TOP 1 M.SITE_DESCRIPTION FROM SCM_MST_SITE M  WITH (NOLOCK) WHERE M.SCM_SITE_ID=A.FROM_SITE), '''') , ''-'') AS FROM_SITE_DESCRIPTION	
                                            ,ISNULL(A.TRANSPORT_MODE,''-'') AS   TRANSPORT_MODE 
                                            ,ISNULL(A.PROD_LINE,''-'') AS      PROD_LINE   
                                            ,A.BOD_ID
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
		          SET @mEXEC = @mEXEC + '       , MAX(A.ATTRIBUTE1) AS ATTRIBUTE1'+CHAR(10);	
              SET @mEXEC = @mEXEC + '       , NULL AS ATTRIBUTE2'+CHAR(10);	
              SET @mEXEC = @mEXEC + '       , NULL AS ATTRIBUTE3, NULL AS ATTRIBUTE4, NULL AS ATTRIBUTE5, NULL AS ATTRIBUTE6, NULL AS ATTRIBUTE7, NULL AS ATTRIBUTE8'+CHAR(10);	
              SET @mEXEC = @mEXEC + '       , A.ATTRIBUTE9, NULL AS ATTRIBUTE10                   '+CHAR(10);	
  	          SET @mEXEC = @mEXEC + ' 		FROM #PSI_GLOBAL_ESS A WITH (NOLOCK)		          '+CHAR(10);
			  SET @mEXEC = @mEXEC + '	      WHERE A.YYYYMMDD    >= ''' + @p_create_from_yyyymmdd + ''''+CHAR(10);
			  SET @mEXEC = @mEXEC + '	        AND A.YYYYMMDD    <= ''' + @p_create_to_yyyymmdd   + ''''+CHAR(10);
	          SET @mEXEC = @mEXEC + '         GROUP BY  A.DIVISION_ID							
	                            			              , A.OPERATION_GROUP							
	                      			                    , A.CELL_ITEM_ID								
	                            			              , A.ITEM_ID											
	                            			              , A.TO_SITE
                                                  , A.PROJECT_CODE
	                            			              , A.FROM_BOH_QTY								
	                            			              , ISNULL(A.INCOTERMS,''-'')
	                            			              , A.FROM_SITE									
                                                  ,  ISNULL(A.TRANSPORT_MODE ,''-'') 
                                                  ,  ISNULL(A.PROD_LINE,''-'') 
                                                  ,  A.BOD_ID
	                            			              , A.MEASURE										
	                            			              , A.SORT_ORDER_NO							
	                            			              , A.COLUMN_LABEL_NAME			 
                                                  , A.ATTRIBUTE9
                                                  '+CHAR(10);

			SET @mEXEC = @mEXEC + ') XX '+CHAR(10);

            EXEC sp_executesql @mEXEC;
			
			--SELECT  'SCP_XLS_PSI_GLOBAL_ESS_CREATE' TN, * FROM  SCP_XLS_PSI_GLOBAL_ESS WITH (NOLOCK)--TEST

        
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

                SELECT DISTINCT X.DIVISION_ID,X.FROM_SITE,X.TO_SITE,X.INCOTERMS,X.TRANSPORT_MODE,X.LT_TOTAL, X.BOD_ID,ISNULL(Y.PROJECT_CODE,'-') AS PROJECT_CODE, X.LT_TOTAL_BY_WEEK
                INTO #TRANSPORT_MODE
                FROM #SCP_MST_BOD_V X
                LEFT OUTER JOIN #SCP_XLS_PSI_GLOBAL_ESS Y
                ON X.DIVISION_ID  = Y.DIVISION_ID
                AND X.FROM_SITE   = Y.FROM_SITE
                AND X.TO_SITE     = Y.TO_SITE
                AND X.INCOTERMS   = Y.INCOTERMS
                AND Y.PROJECT_CODE <> '-'
				AND X.BOD_ID          = Y.BOD_ID					-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 BOD_ID 추가
--                WHERE ISNULL(Y.PROJECT_CODE ,'') <> ''


                --SELECT * INTO ##TRANSPORT_MODE FROM #TRANSPORT_MODE WITH (NOLOCK)
                --SELECT * INTO ##SCP_XLS_PSI_GLOBAL_ESS FROM #SCP_XLS_PSI_GLOBAL_ESS WITH (NOLOCK)
                --return;



            INSERT #SCP_XLS_PSI_GLOBAL_ESS
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
                                  ,(CASE WHEN OPERATION_GROUP = 'P' THEN '-' ELSE ISNULL(Y.TRANSPORT_MODE,'-') END)  AS TRANSPORT_MODE
                                  ,PROD_LINE
                                  ,(CASE WHEN OPERATION_GROUP = 'P' THEN '0' ELSE ISNULL(Y.LT_TOTAL_BY_WEEK,0)  END) AS LT_DAY
                                  ,(CASE WHEN OPERATION_GROUP = 'P' THEN '-' ELSE ISNULL(Y.BOD_ID,'-')  END)  AS BOD_ID
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
                                FROM #SCP_XLS_PSI_GLOBAL_ESS X WITH(NOLOCK)     
                                LEFT OUTER JOIN #TRANSPORT_MODE Y WITH (NOLOCK) 
                                ON 0 = 0
                                AND X.DIVISION_ID     = Y.DIVISION_ID
                                AND X.FROM_SITE       = Y.FROM_SITE
                                AND X.TO_SITE         = Y.TO_SITE
                                AND X.INCOTERMS       = Y.INCOTERMS
                                AND X.PROJECT_CODE    = Y.PROJECT_CODE
								AND X.BOD_ID          = Y.BOD_ID					-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 BOD_ID 추가
                                AND X.MEASURE         = 'SHIP_PLAN'
--                                AND X.TRANSPORT_MODE  <> Y.TRANSPORT_MODE  
                         ) SUB                
                         WHERE 1=1                
                           AND NOT EXISTS (                
                                            SELECT 'X'                
                                              FROM #SCP_XLS_PSI_GLOBAL_ESS Z WITH(NOLOCK)                
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
                                               --AND Z.ATTRIBUTE1						=	SUB.ATTRIBUTE1					
--			                                         AND Z.ATTRIBUTE9						=	SUB.ATTRIBUTE9					
                                          )      
                  AND SUB.MEASURE              ='SHIP_PLAN'


  

                  INSERT #SCP_XLS_PSI_GLOBAL_ESS
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
                                 FROM #SCP_XLS_PSI_GLOBAL_ESS X WITH(NOLOCK)     
                                    LEFT OUTER JOIN #TRANSPORT_MODE Y WITH (NOLOCK) 
                                    ON 0 = 0
                                    AND X.DIVISION_ID     = Y.DIVISION_ID
                                    AND X.FROM_SITE       = Y.FROM_SITE
                                    AND X.TO_SITE         = Y.TO_SITE
--                                    AND X.INCOTERMS       = Y.INCOTERMS
                                    AND X.PROJECT_CODE    =  ISNULL(Y.PROJECT_CODE,'-')
									AND X.BOD_ID          = Y.BOD_ID					-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 BOD_ID 추가
                                    AND X.MEASURE         = 'SEMI_SHIP_PLAN'
    --                                AND X.TRANSPORT_MODE  <> Y.TRANSPORT_MODE  
                             ) SUB                
                             WHERE 1=1                
                               AND NOT EXISTS (                
                                                SELECT 'X'                
                                                  FROM #SCP_XLS_PSI_GLOBAL_ESS Z WITH(NOLOCK)                
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
			-- 튜닝 -- PR_SCP_XLS_PSI_GLOBAL_ESS 으로 이동
             --IF OBJECT_ID('tempdb..#tmp_SCP_MST_TACT_TIME') IS NOT NULL	
	            --  DROP TABLE #tmp_SCP_MST_TACT_TIME
             
             --SELECT * 
             --INTO #tmp_SCP_MST_TACT_TIME
             --FROM 
             --(
             --   SELECT DIVISION_ID,PLANT_SITE_ID,ITEM_ID,OPERATION_ID,LINE_ID,YIELD 
             --   FROM SCP_MST_TACT_TIME WITH(NOLOCK)
             --   WHERE DIVISION_ID =@p_division_id
             --   -- AND OPERATION_ID IN ('P9500','P5500')
             --   UNION ALL
             --   SELECT DIVISION_ID,PLANT_SITE_ID,ITEM_ID,OPERATION_ID,LINE_ID,YIELD 
             --   FROM SCP_MST_TACT_TIME_OSP WITH(NOLOCK)
             --   WHERE DIVISION_ID =@p_division_id
             -- -- AND OPERATION_ID IN ('P9500','P5500')
             -- ) X


            -------------------------------------------------------------------------------------------------------------         
            -- LINE_ID 추가
            -------------------------------------------------------------------------------------------------------------            
            -- 'SHIP_PLAN'의 LINE_ID 종류 별 추가 
               INSERT INTO #SCP_XLS_PSI_GLOBAL_ESS                
                      SELECT DISTINCT X.DIVISION_ID
                      ,X.PLAN_START_YYYYMMDD
                      ,X.PLAN_TYPE
                      ,X.SEQ
                      ,X.OPERATION_GROUP
                      ,X.OPERATION_GROUP_NAME
                      ,X.CELL_ITEM_ID
                      ,X.ITEM_ID
                      ,X.NICK_NAME
                      ,X.CELL_QTY_PACK
                      ,TO_SITE
                      ,TO_SITE_DESCRIPTION
                      ,PROJECT_CODE
                      ,FROM_BOH_QTY
                      ,TO_BOH_QTY
                      ,INCOTERMS
                      ,FROM_SITE
                      ,FROM_SITE_DESCRIPTION
                      ,TRANSPORT_MODE
                      ,Y.LINE_ID AS PROD_LINE
                      ,LT_DAY
                      ,BOD_ID
                      ,X.MEASURE
                      ,X.MEASURE_LABEL
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
                      ,X.SORT_ORDER_NO
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
                      FROM #SCP_XLS_PSI_GLOBAL_ESS X WITH (NOLOCK) 
                      CROSS APPLY #tmp_SCP_MST_TACT_TIME Y  WITH (NOLOCK)
                      WHERE 0 = 0
                      AND X.DIVISION_ID   = Y.DIVISION_ID
                      AND X.ITEM_ID       = Y.ITEM_ID
                      AND X.FROM_SITE     = Y.PLANT_SITE_ID
                      AND X.MEASURE       IN  ('CELL_PROD','PACK_PROD')
                      AND NOT EXISTS (                
                                            SELECT 'X'                
                                              FROM #SCP_XLS_PSI_GLOBAL_ESS Z WITH(NOLOCK)                
                                             WHERE 1=1                
                                               AND Z.DIVISION_ID          = X.DIVISION_ID                
                                               AND Z.CELL_ITEM_ID         = X.CELL_ITEM_ID    
                                               AND Z.ITEM_ID              = X.ITEM_ID              
                                               AND Z.MEASURE              = X.MEASURE 
                                               AND Z.FROM_SITE            = Y.PLANT_SITE_ID
                                               AND Z.PROD_LINE            = Y.LINE_ID
                                               AND Z.MEASURE              IN ('CELL_PROD','PACK_PROD')
                                               )

              UNION 
                    SELECT DISTINCT X.DIVISION_ID
                      ,X.PLAN_START_YYYYMMDD
                      ,X.PLAN_TYPE
                      ,X.SEQ
                      ,X.OPERATION_GROUP
                      ,X.OPERATION_GROUP_NAME
                      ,X.CELL_ITEM_ID
                      ,X.ITEM_ID
                      ,X.NICK_NAME
                      ,X.CELL_QTY_PACK
                      ,X.TO_SITE
                      ,X.TO_SITE_DESCRIPTION
                      ,X.PROJECT_CODE
                      ,X.FROM_BOH_QTY
                      ,X.TO_BOH_QTY
                      ,X.INCOTERMS
                      ,X.FROM_SITE
                      ,X.FROM_SITE_DESCRIPTION
                      ,X.TRANSPORT_MODE
                      ,Y.LINE_ID AS PROD_LINE
                      ,X.LT_DAY
                      ,X.BOD_ID
                      ,(CASE  WHEN X.MEASURE = 'PACK_PROD' THEN 'PACK_PROD_LOAD' 
                              WHEN X.MEASURE = 'CELL_PROD' THEN 'CELL_PROD_LOAD' END ) AS MEASURE
                      ,(CASE  WHEN X.MEASURE = 'PACK_PROD' THEN 'Load Ratio(%)' 
                              WHEN X.MEASURE = 'CELL_PROD' THEN 'Load Ratio(%)' END ) AS MEASURE_LABEL
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
                      ,X.SORT_ORDER_NO
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
                      FROM #SCP_XLS_PSI_GLOBAL_ESS X WITH (NOLOCK) 
                      CROSS APPLY #tmp_SCP_MST_TACT_TIME Y  WITH (NOLOCK)
                      WHERE 0 = 0
                      AND X.DIVISION_ID   = Y.DIVISION_ID
                      AND X.ITEM_ID       = Y.ITEM_ID
                      AND X.FROM_SITE     = Y.PLANT_SITE_ID
                      AND X.MEASURE       IN  ('CELL_PROD','PACK_PROD')
                      AND NOT EXISTS (                
                                            SELECT 'X'                
                                              FROM #SCP_XLS_PSI_GLOBAL_ESS Z WITH(NOLOCK)                
                                             WHERE 1=1                
                                               AND Z.DIVISION_ID          = X.DIVISION_ID                
                                               AND Z.CELL_ITEM_ID         = X.CELL_ITEM_ID    
                                               AND Z.ITEM_ID              = X.ITEM_ID              
                                               AND Z.MEASURE              = X.MEASURE 
                                               AND Z.FROM_SITE            = Y.PLANT_SITE_ID
                                               AND Z.PROD_LINE            = Y.LINE_ID
                                               AND Z.MEASURE              IN ('CELL_PROD','PACK_PROD')
                                               )



            -------------------------------------------------------------------------------------------------------------         
            -- TACT TIME 정보 반영
            -------------------------------------------------------------------------------------------------------------
              IF OBJECT_ID('tempdb..#TACT_TIME_WEEK') IS NOT NULL	
	                    DROP TABLE #TACT_TIME_WEEK

                    SELECT 
                          XX.DIVISION_ID, XX.OPERATION_GROUP,XX.SCM_SITE_ID, XX.PROD_LINE, XX.ITEM_ID, XX.OPERATION_ID
                          --,(QTY001 + QTY002 +  QTY003 +  QTY004 +  QTY005 +  QTY006 +  QTY007) / 7 AS WQTY01
                          --,(QTY008 + QTY009 +  QTY010 +  QTY011 +  QTY012 +  QTY013 +  QTY014) / 7 AS WQTY02
                          --,(QTY015 + QTY016 +  QTY017 +  QTY018 +  QTY019 +  QTY020 +  QTY021) / 7 AS WQTY03
                          --,(QTY022 + QTY023 +  QTY024 +  QTY025 +  QTY026 +  QTY027 +  QTY028) / 7 AS WQTY04
                          --,(QTY029 + QTY030 +  QTY031 +  QTY032 +  QTY033 +  QTY034 +  QTY035) / 7 AS WQTY05
                          --,(QTY036 + QTY037 +  QTY038 +  QTY039 +  QTY040 +  QTY041 +  QTY042) / 7 AS WQTY06
                          --,(QTY043 + QTY044 +  QTY045 +  QTY046 +  QTY047 +  QTY048 +  QTY049) / 7 AS WQTY07
                          --,(QTY050 + QTY051 +  QTY052 +  QTY053 +  QTY054 +  QTY055 +  QTY056) / 7 AS WQTY08
                          --,(QTY057 + QTY058 +  QTY059 +  QTY060 +  QTY061 +  QTY062 +  QTY063) / 7 AS WQTY09
                          --,(QTY064 + QTY065 +  QTY066 +  QTY067 +  QTY068 +  QTY069 +  QTY070) / 7 AS WQTY10

                          --,(QTY071 + QTY072 +  QTY073 +  QTY074 +  QTY075 +  QTY076 +  QTY077) / 7 AS WQTY11
                          --,(QTY078 + QTY079 +  QTY080 +  QTY081 +  QTY082 +  QTY083 +  QTY084) / 7 AS WQTY12
                          --,(QTY085 + QTY086 +  QTY087 +  QTY088 +  QTY089 +  QTY090 +  QTY091) / 7 AS WQTY13
                          --,(QTY092 + QTY093 +  QTY094 +  QTY095 +  QTY096 +  QTY097 +  QTY098) / 7 AS WQTY14
                          --,(QTY099 + QTY100 +  QTY101 +  QTY102 +  QTY103 +  QTY104 +  QTY105) / 7 AS WQTY15
                          --,(QTY106 + QTY107 +  QTY108 +  QTY109 +  QTY110 +  QTY111 +  QTY112) / 7 AS WQTY16
                          --,(QTY113 + QTY114 +  QTY115 +  QTY116 +  QTY117 +  QTY118 +  QTY119) / 7 AS WQTY17
                          --,(QTY120 + QTY121 +  QTY122 +  QTY123 +  QTY124 +  QTY125 +  QTY126) / 7 AS WQTY18
                          --,(QTY127 + QTY128 +  QTY129 +  QTY130 +  QTY131 +  QTY132 +  QTY133) / 7 AS WQTY19
                          --,(QTY134 + QTY135 +  QTY136 +  QTY137 +  QTY138 +  QTY139 +  QTY140) / 7 AS WQTY20

                          --,(QTY141 + QTY142 +  QTY143 +  QTY144 +  QTY145 +  QTY146 +  QTY147) / 7 AS WQTY21
                          --,(QTY148 + QTY149 +  QTY150 +  QTY151 +  QTY152 +  QTY153 +  QTY154) / 7 AS WQTY22
                          --,(QTY155 + QTY156 +  QTY157 +  QTY158 +  QTY159 +  QTY160 +  QTY161) / 7 AS WQTY23
                          --,(QTY162 + QTY163 +  QTY164 +  QTY165 +  QTY166 +  QTY167 +  QTY168) / 7 AS WQTY24
                          --,(QTY169 + QTY170 +  QTY171 +  QTY172 +  QTY173 +  QTY174 +  QTY175) / 7 AS WQTY25
                          --,(QTY176 + QTY177 +  QTY178 +  QTY179 +  QTY180 +  QTY181 +  QTY182) / 7 AS WQTY26
                          --,(QTY183 + QTY184 +  QTY185 +  QTY186 +  QTY187 +  QTY188 +  QTY189) / 7 AS WQTY27
                          --,(QTY190 + QTY191 +  QTY192 +  QTY193 +  QTY194 +  QTY195 +  QTY196) / 7 AS WQTY28
                          --,(QTY197 + QTY198 +  QTY199 +  QTY200 +  QTY201 +  QTY202 +  QTY203) / 7 AS WQTY29
                          --,(QTY204 + QTY205 +  QTY206 +  QTY207 +  QTY208 +  QTY209 +  QTY210) / 7 AS WQTY30

                          --,(QTY211 + QTY212 +  QTY213 +  QTY214 +  QTY215 +  QTY216 +  QTY217) / 7 AS WQTY31
                          --,(QTY218 + QTY219 +  QTY220 +  QTY221 +  QTY222 +  QTY223 +  QTY224) / 7 AS WQTY32
                          --,(QTY225 + QTY226 +  QTY227 +  QTY228 +  QTY229 +  QTY230 +  QTY231) / 7 AS WQTY33
                          --,(QTY232 + QTY233 +  QTY234 +  QTY235 +  QTY236 +  QTY237 +  QTY238) / 7 AS WQTY34
                          --,(QTY239 + QTY240 +  QTY241 +  QTY242 +  QTY243 +  QTY244 +  QTY245) / 7 AS WQTY35
                          --,(QTY246 + QTY247 +  QTY248 +  QTY249 +  QTY250 +  QTY251 +  QTY252) / 7 AS WQTY36
                          --,(QTY253 + QTY254 +  QTY255 +  QTY256 +  QTY257 +  QTY258 +  QTY259) / 7 AS WQTY37
                          --,(QTY260 + QTY261 +  QTY262 +  QTY263 +  QTY264 +  QTY265 +  QTY266) / 7 AS WQTY38
                          --,(QTY267 + QTY268 +  QTY269 +  QTY270 +  QTY271 +  QTY272 +  QTY273) / 7 AS WQTY39
                          --,(QTY274 + QTY275 +  QTY276 +  QTY277 +  QTY278 +  QTY279 +  QTY280) / 7 AS WQTY40

                          --,(QTY281 + QTY282 +  QTY283 +  QTY284 +  QTY285 +  QTY286 +  QTY287) / 7 AS WQTY41
                          --,(QTY288 + QTY289 +  QTY290 +  QTY291 +  QTY292 +  QTY293 +  QTY294) / 7 AS WQTY42
                          --,(QTY295 + QTY296 +  QTY297 +  QTY298 +  QTY299 +  QTY300 +  QTY301) / 7 AS WQTY43
                          --,(QTY302 + QTY303 +  QTY304 +  QTY305 +  QTY306 +  QTY307 +  QTY308) / 7 AS WQTY44
                          --,(QTY309 + QTY310 +  QTY311 +  QTY312 +  QTY313 +  QTY314 +  QTY315) / 7 AS WQTY45
                          --,(QTY316 + QTY317 +  QTY318 +  QTY319 +  QTY320 +  QTY321 +  QTY322) / 7 AS WQTY46
                          --,(QTY323 + QTY324 +  QTY325 +  QTY326 +  QTY327 +  QTY328 +  QTY329) / 7 AS WQTY47
                          --,(QTY330 + QTY331 +  QTY332 +  QTY333 +  QTY334 +  QTY335 +  QTY336) / 7 AS WQTY48
                          --,(QTY337 + QTY338 +  QTY339 +  QTY340 +  QTY341 +  QTY342 +  QTY343) / 7 AS WQTY49
                          --,(QTY344 + QTY345 +  QTY346 +  QTY347 +  QTY348 +  QTY349 +  QTY350) / 7 AS WQTY50

                          --,(QTY351 + QTY352 +  QTY353 +  QTY354 +  QTY355 +  QTY356 +  QTY357) / 7 AS WQTY51
                          --,(QTY358 + QTY359 +  QTY360 +  QTY361 +  QTY362 +  QTY363 +  QTY364) / 7 AS WQTY52
                          ,[QTY001], [QTY002], [QTY003], [QTY004], [QTY005],[QTY006], [QTY007], [QTY008], [QTY009], [QTY010]
                          ,[QTY011], [QTY012], [QTY013], [QTY014], [QTY015],[QTY016], [QTY017], [QTY018], [QTY019], [QTY020]
                          ,[QTY021], [QTY022], [QTY023], [QTY024], [QTY025],[QTY026], [QTY027], [QTY028], [QTY029], [QTY030]
                          ,[QTY031], [QTY032], [QTY033], [QTY034], [QTY035],[QTY036], [QTY037], [QTY038], [QTY039], [QTY040]
                          ,[QTY041], [QTY042], [QTY043], [QTY044], [QTY045],[QTY046], [QTY047], [QTY048], [QTY049], [QTY050]
                          ,[QTY051], [QTY052], [QTY053], [QTY054], [QTY055],[QTY056], [QTY057], [QTY058], [QTY059], [QTY060]
                          ,[QTY061], [QTY062], [QTY063], [QTY064], [QTY065],[QTY066], [QTY067], [QTY068], [QTY069], [QTY070]
                          ,[QTY071], [QTY072], [QTY073], [QTY074], [QTY075],[QTY076], [QTY077], [QTY078], [QTY079], [QTY080]
                          ,[QTY081], [QTY082], [QTY083], [QTY084], [QTY085],[QTY086], [QTY087], [QTY088], [QTY089], [QTY090]
                          ,[QTY091], [QTY092], [QTY093], [QTY094], [QTY095],[QTY096], [QTY097], [QTY098], [QTY099], [QTY100]

                          ,[QTY101], [QTY102], [QTY103], [QTY104], [QTY105],[QTY106], [QTY107], [QTY108], [QTY109], [QTY110]
                          ,[QTY111], [QTY112], [QTY113], [QTY114], [QTY115],[QTY116], [QTY117], [QTY118], [QTY119], [QTY120]
                          ,[QTY121], [QTY122], [QTY123], [QTY124], [QTY125],[QTY126], [QTY127], [QTY128], [QTY129], [QTY130]
                          ,[QTY131], [QTY132], [QTY133], [QTY134], [QTY135],[QTY136], [QTY137], [QTY138], [QTY139], [QTY140]
                          ,[QTY141], [QTY142], [QTY143], [QTY144], [QTY145],[QTY146], [QTY147], [QTY148], [QTY149], [QTY150]
                          ,[QTY151], [QTY152], [QTY153], [QTY154], [QTY155],[QTY156], [QTY157], [QTY158], [QTY159], [QTY160]
                          ,[QTY161], [QTY162], [QTY163], [QTY164], [QTY165],[QTY166], [QTY167], [QTY168], [QTY169], [QTY170]
                          ,[QTY171], [QTY172], [QTY173], [QTY174], [QTY175],[QTY176], [QTY177], [QTY178], [QTY179], [QTY180]
                          ,[QTY181], [QTY182], [QTY183], [QTY184], [QTY185],[QTY186], [QTY187], [QTY188], [QTY189], [QTY190]
                          ,[QTY191], [QTY192], [QTY193], [QTY194], [QTY195],[QTY196], [QTY197], [QTY198], [QTY199], [QTY200]

                          ,[QTY201], [QTY202], [QTY203], [QTY204], [QTY205],[QTY206], [QTY207], [QTY208], [QTY209], [QTY210]
                          ,[QTY211], [QTY212], [QTY213], [QTY214], [QTY215],[QTY216], [QTY217], [QTY218], [QTY219], [QTY220]
                          ,[QTY221], [QTY222], [QTY223], [QTY224], [QTY225],[QTY226], [QTY227], [QTY228], [QTY229], [QTY230]
                          ,[QTY231], [QTY232], [QTY233], [QTY234], [QTY235],[QTY236], [QTY237], [QTY238], [QTY239], [QTY240]
                          ,[QTY241], [QTY242], [QTY243], [QTY244], [QTY245],[QTY246], [QTY247], [QTY248], [QTY249], [QTY250]
                          ,[QTY251], [QTY252], [QTY253], [QTY254], [QTY255],[QTY256], [QTY257], [QTY258], [QTY259], [QTY260]
                          ,[QTY261], [QTY262], [QTY263], [QTY264], [QTY265],[QTY266], [QTY267], [QTY268], [QTY269], [QTY270]
                          ,[QTY271], [QTY272], [QTY273], [QTY274], [QTY275],[QTY276], [QTY277], [QTY278], [QTY279], [QTY280]
                          ,[QTY281], [QTY282], [QTY283], [QTY284], [QTY285],[QTY286], [QTY287], [QTY288], [QTY289], [QTY290]
                          ,[QTY291], [QTY292], [QTY293], [QTY294], [QTY295],[QTY296], [QTY297], [QTY298], [QTY299], [QTY300]

                          ,[QTY301], [QTY302], [QTY303], [QTY304], [QTY305],[QTY306], [QTY307], [QTY308], [QTY309], [QTY310]
                          ,[QTY311], [QTY312], [QTY313], [QTY314], [QTY315],[QTY316], [QTY317], [QTY318], [QTY319], [QTY320]
                          ,[QTY321], [QTY322], [QTY323], [QTY324], [QTY325],[QTY326], [QTY327], [QTY328], [QTY329], [QTY330]
                          ,[QTY331], [QTY332], [QTY333], [QTY334], [QTY335],[QTY336], [QTY337], [QTY338], [QTY339], [QTY340]
                          ,[QTY341], [QTY342], [QTY343], [QTY344], [QTY345],[QTY346], [QTY347], [QTY348], [QTY349], [QTY350]
                          ,[QTY351], [QTY352], [QTY353], [QTY354], [QTY355],[QTY356], [QTY357], [QTY358], [QTY359], [QTY360]
                          ,[QTY361], [QTY362], [QTY363], [QTY364]
                  INTO #TACT_TIME_WEEK
                  FROM
                    (
                                  SELECT  X.DIVISION_ID
                                        , X.OPERATION_GROUP
                                        , Z.SCM_SITE_ID
                                        , X.PROD_LINE
                                      --, Y.YYYYMMDD
                                        , X.YYYYMMDD_COLUMN
                                        --, Z.LINE_ID
                                        , Z.ITEM_ID
                                        , Z.OPERATION_ID
                                        , Z.TACT_TIME
                                  FROM
                                    (
                                    SELECT * 
                                     FROM #SCP_XLS_PSI_GLOBAL_ESS WITH (NOLOCK) 
                                     WHERE 0 = 0
                                       AND MEASURE IN ('PACK_PROD','CELL_PROD')
                                      --AND DIVISION_ID         = @p_division_id
                                      --AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
                                      --AND SEQ                 = @p_seq
                                      --AND XLS_KEY1            = @p_xls_key1 --43 
                                     ) AS SourceTable  
                                  UNPIVOT 
                                      (
                                       QTY FOR  YYYYMMDD_COLUMN IN (
                                                             [QTY001], [QTY002], [QTY003], [QTY004], [QTY005],[QTY006], [QTY007], [QTY008], [QTY009], [QTY010]
                                                            ,[QTY011], [QTY012], [QTY013], [QTY014], [QTY015],[QTY016], [QTY017], [QTY018], [QTY019], [QTY020]
                                                            ,[QTY021], [QTY022], [QTY023], [QTY024], [QTY025],[QTY026], [QTY027], [QTY028], [QTY029], [QTY030]
                                                            ,[QTY031], [QTY032], [QTY033], [QTY034], [QTY035],[QTY036], [QTY037], [QTY038], [QTY039], [QTY040]
                                                            ,[QTY041], [QTY042], [QTY043], [QTY044], [QTY045],[QTY046], [QTY047], [QTY048], [QTY049], [QTY050]
                                                            ,[QTY051], [QTY052], [QTY053], [QTY054], [QTY055],[QTY056], [QTY057], [QTY058], [QTY059], [QTY060]
                                                            ,[QTY061], [QTY062], [QTY063], [QTY064], [QTY065],[QTY066], [QTY067], [QTY068], [QTY069], [QTY070]
                                                            ,[QTY071], [QTY072], [QTY073], [QTY074], [QTY075],[QTY076], [QTY077], [QTY078], [QTY079], [QTY080]
                                                            ,[QTY081], [QTY082], [QTY083], [QTY084], [QTY085],[QTY086], [QTY087], [QTY088], [QTY089], [QTY090]
                                                            ,[QTY091], [QTY092], [QTY093], [QTY094], [QTY095],[QTY096], [QTY097], [QTY098], [QTY099], [QTY100]

                                                            ,[QTY101], [QTY102], [QTY103], [QTY104], [QTY105],[QTY106], [QTY107], [QTY108], [QTY109], [QTY110]
                                                            ,[QTY111], [QTY112], [QTY113], [QTY114], [QTY115],[QTY116], [QTY117], [QTY118], [QTY119], [QTY120]
                                                            ,[QTY121], [QTY122], [QTY123], [QTY124], [QTY125],[QTY126], [QTY127], [QTY128], [QTY129], [QTY130]
                                                            ,[QTY131], [QTY132], [QTY133], [QTY134], [QTY135],[QTY136], [QTY137], [QTY138], [QTY139], [QTY140]
                                                            ,[QTY141], [QTY142], [QTY143], [QTY144], [QTY145],[QTY146], [QTY147], [QTY148], [QTY149], [QTY150]
                                                            ,[QTY151], [QTY152], [QTY153], [QTY154], [QTY155],[QTY156], [QTY157], [QTY158], [QTY159], [QTY160]
                                                            ,[QTY161], [QTY162], [QTY163], [QTY164], [QTY165],[QTY166], [QTY167], [QTY168], [QTY169], [QTY170]
                                                            ,[QTY171], [QTY172], [QTY173], [QTY174], [QTY175],[QTY176], [QTY177], [QTY178], [QTY179], [QTY180]
                                                            ,[QTY181], [QTY182], [QTY183], [QTY184], [QTY185],[QTY186], [QTY187], [QTY188], [QTY189], [QTY190]
                                                            ,[QTY191], [QTY192], [QTY193], [QTY194], [QTY195],[QTY196], [QTY197], [QTY198], [QTY199], [QTY200]

                                                            ,[QTY201], [QTY202], [QTY203], [QTY204], [QTY205],[QTY206], [QTY207], [QTY208], [QTY209], [QTY210]
                                                            ,[QTY211], [QTY212], [QTY213], [QTY214], [QTY215],[QTY216], [QTY217], [QTY218], [QTY219], [QTY220]
                                                            ,[QTY221], [QTY222], [QTY223], [QTY224], [QTY225],[QTY226], [QTY227], [QTY228], [QTY229], [QTY230]
                                                            ,[QTY231], [QTY232], [QTY233], [QTY234], [QTY235],[QTY236], [QTY237], [QTY238], [QTY239], [QTY240]
                                                            ,[QTY241], [QTY242], [QTY243], [QTY244], [QTY245],[QTY246], [QTY247], [QTY248], [QTY249], [QTY250]
                                                            ,[QTY251], [QTY252], [QTY253], [QTY254], [QTY255],[QTY256], [QTY257], [QTY258], [QTY259], [QTY260]
                                                            ,[QTY261], [QTY262], [QTY263], [QTY264], [QTY265],[QTY266], [QTY267], [QTY268], [QTY269], [QTY270]
                                                            ,[QTY271], [QTY272], [QTY273], [QTY274], [QTY275],[QTY276], [QTY277], [QTY278], [QTY279], [QTY280]
                                                            ,[QTY281], [QTY282], [QTY283], [QTY284], [QTY285],[QTY286], [QTY287], [QTY288], [QTY289], [QTY290]
                                                            ,[QTY291], [QTY292], [QTY293], [QTY294], [QTY295],[QTY296], [QTY297], [QTY298], [QTY299], [QTY300]

                                                            ,[QTY301], [QTY302], [QTY303], [QTY304], [QTY305],[QTY306], [QTY307], [QTY308], [QTY309], [QTY310]
                                                            ,[QTY311], [QTY312], [QTY313], [QTY314], [QTY315],[QTY316], [QTY317], [QTY318], [QTY319], [QTY320]
                                                            ,[QTY321], [QTY322], [QTY323], [QTY324], [QTY325],[QTY326], [QTY327], [QTY328], [QTY329], [QTY330]
                                                            ,[QTY331], [QTY332], [QTY333], [QTY334], [QTY335],[QTY336], [QTY337], [QTY338], [QTY339], [QTY340]
                                                            ,[QTY341], [QTY342], [QTY343], [QTY344], [QTY345],[QTY346], [QTY347], [QTY348], [QTY349], [QTY350]
                                                            ,[QTY351], [QTY352], [QTY353], [QTY354], [QTY355],[QTY356], [QTY357], [QTY358], [QTY359], [QTY360]
                                                            ,[QTY361], [QTY362], [QTY363], [QTY364]

                                                            ) 
                                  ) AS X
                                  INNER JOIN (SELECT A.BASIS_YYYYMMDD AS YYYYMMDD    
                                                    ,'QTY' + REPLICATE('0', 3 - LEN(ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD) )) + CONVERT(NVARCHAR,ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD)) AS YYYYMMDD_COLUMN
                                                FROM DBO.SCM_SYS_CALENDAR_M A  WITH(NOLOCK)	     
                                                WHERE A.BASIS_YYYYMMDD     >= @p_create_from_yyyymmdd
                                                  AND A.BASIS_YYYYMMDD     <=  @p_create_to_yyyymmdd
                                              ) Y
                                  ON X.YYYYMMDD_COLUMN = Y.YYYYMMDD_COLUMN
                                  INNER JOIN SCP_ANL_TACT_TIME Z WITH (NOLOCK)
                                  ON Y.YYYYMMDD = Z.YYYYMMDD
                                  AND X.PROD_LINE = Z.LINE_ID
                                  AND X.ITEM_ID = Z.ITEM_ID
                                  AND Z.DIVISION_ID = X.DIVISION_ID
                                   AND Z.YYYYMMDD >= @p_create_from_yyyymmdd
                                   AND Z.YYYYMMDD <= @p_create_to_yyyymmdd    
                                   --AND Z.LINE_ID ='C1P01'
                                   --AND Z.ITEM_ID ='EM048063P3N3'
                     ) AS SourceTable  
                  PIVOT 
                      (
                       SUM(TACT_TIME)
                       FOR  YYYYMMDD_COLUMN IN ( [QTY001], [QTY002], [QTY003], [QTY004], [QTY005],[QTY006], [QTY007], [QTY008], [QTY009], [QTY010]
                                                ,[QTY011], [QTY012], [QTY013], [QTY014], [QTY015],[QTY016], [QTY017], [QTY018], [QTY019], [QTY020]
                                                ,[QTY021], [QTY022], [QTY023], [QTY024], [QTY025],[QTY026], [QTY027], [QTY028], [QTY029], [QTY030]
                                                ,[QTY031], [QTY032], [QTY033], [QTY034], [QTY035],[QTY036], [QTY037], [QTY038], [QTY039], [QTY040]
                                                ,[QTY041], [QTY042], [QTY043], [QTY044], [QTY045],[QTY046], [QTY047], [QTY048], [QTY049], [QTY050]
                                                ,[QTY051], [QTY052], [QTY053], [QTY054], [QTY055],[QTY056], [QTY057], [QTY058], [QTY059], [QTY060]
                                                ,[QTY061], [QTY062], [QTY063], [QTY064], [QTY065],[QTY066], [QTY067], [QTY068], [QTY069], [QTY070]
                                                ,[QTY071], [QTY072], [QTY073], [QTY074], [QTY075],[QTY076], [QTY077], [QTY078], [QTY079], [QTY080]
                                                ,[QTY081], [QTY082], [QTY083], [QTY084], [QTY085],[QTY086], [QTY087], [QTY088], [QTY089], [QTY090]
                                                ,[QTY091], [QTY092], [QTY093], [QTY094], [QTY095],[QTY096], [QTY097], [QTY098], [QTY099], [QTY100]

                                                ,[QTY101], [QTY102], [QTY103], [QTY104], [QTY105],[QTY106], [QTY107], [QTY108], [QTY109], [QTY110]
                                                ,[QTY111], [QTY112], [QTY113], [QTY114], [QTY115],[QTY116], [QTY117], [QTY118], [QTY119], [QTY120]
                                                ,[QTY121], [QTY122], [QTY123], [QTY124], [QTY125],[QTY126], [QTY127], [QTY128], [QTY129], [QTY130]
                                                ,[QTY131], [QTY132], [QTY133], [QTY134], [QTY135],[QTY136], [QTY137], [QTY138], [QTY139], [QTY140]
                                                ,[QTY141], [QTY142], [QTY143], [QTY144], [QTY145],[QTY146], [QTY147], [QTY148], [QTY149], [QTY150]
                                                ,[QTY151], [QTY152], [QTY153], [QTY154], [QTY155],[QTY156], [QTY157], [QTY158], [QTY159], [QTY160]
                                                ,[QTY161], [QTY162], [QTY163], [QTY164], [QTY165],[QTY166], [QTY167], [QTY168], [QTY169], [QTY170]
                                                ,[QTY171], [QTY172], [QTY173], [QTY174], [QTY175],[QTY176], [QTY177], [QTY178], [QTY179], [QTY180]
                                                ,[QTY181], [QTY182], [QTY183], [QTY184], [QTY185],[QTY186], [QTY187], [QTY188], [QTY189], [QTY190]
                                                ,[QTY191], [QTY192], [QTY193], [QTY194], [QTY195],[QTY196], [QTY197], [QTY198], [QTY199], [QTY200]

                                                ,[QTY201], [QTY202], [QTY203], [QTY204], [QTY205],[QTY206], [QTY207], [QTY208], [QTY209], [QTY210]
                                                ,[QTY211], [QTY212], [QTY213], [QTY214], [QTY215],[QTY216], [QTY217], [QTY218], [QTY219], [QTY220]
                                                ,[QTY221], [QTY222], [QTY223], [QTY224], [QTY225],[QTY226], [QTY227], [QTY228], [QTY229], [QTY230]
                                                ,[QTY231], [QTY232], [QTY233], [QTY234], [QTY235],[QTY236], [QTY237], [QTY238], [QTY239], [QTY240]
                                                ,[QTY241], [QTY242], [QTY243], [QTY244], [QTY245],[QTY246], [QTY247], [QTY248], [QTY249], [QTY250]
                                                ,[QTY251], [QTY252], [QTY253], [QTY254], [QTY255],[QTY256], [QTY257], [QTY258], [QTY259], [QTY260]
                                                ,[QTY261], [QTY262], [QTY263], [QTY264], [QTY265],[QTY266], [QTY267], [QTY268], [QTY269], [QTY270]
                                                ,[QTY271], [QTY272], [QTY273], [QTY274], [QTY275],[QTY276], [QTY277], [QTY278], [QTY279], [QTY280]
                                                ,[QTY281], [QTY282], [QTY283], [QTY284], [QTY285],[QTY286], [QTY287], [QTY288], [QTY289], [QTY290]
                                                ,[QTY291], [QTY292], [QTY293], [QTY294], [QTY295],[QTY296], [QTY297], [QTY298], [QTY299], [QTY300]

                                                ,[QTY301], [QTY302], [QTY303], [QTY304], [QTY305],[QTY306], [QTY307], [QTY308], [QTY309], [QTY310]
                                                ,[QTY311], [QTY312], [QTY313], [QTY314], [QTY315],[QTY316], [QTY317], [QTY318], [QTY319], [QTY320]
                                                ,[QTY321], [QTY322], [QTY323], [QTY324], [QTY325],[QTY326], [QTY327], [QTY328], [QTY329], [QTY330]
                                                ,[QTY331], [QTY332], [QTY333], [QTY334], [QTY335],[QTY336], [QTY337], [QTY338], [QTY339], [QTY340]
                                                ,[QTY341], [QTY342], [QTY343], [QTY344], [QTY345],[QTY346], [QTY347], [QTY348], [QTY349], [QTY350]
                                                ,[QTY351], [QTY352], [QTY353], [QTY354], [QTY355],[QTY356], [QTY357], [QTY358], [QTY359], [QTY360]
                                                ,[QTY361], [QTY362], [QTY363], [QTY364]
                                            )  
                       ) XX

            INSERT INTO #SCP_XLS_PSI_GLOBAL_ESS    
                    SELECT DISTINCT X.DIVISION_ID
                      ,X.PLAN_START_YYYYMMDD
                      ,X.PLAN_TYPE
                      ,X.SEQ
                      ,X.OPERATION_GROUP
                      ,X.OPERATION_GROUP_NAME
                      ,X.CELL_ITEM_ID
                      ,X.ITEM_ID
                      ,X.NICK_NAME
                      ,X.CELL_QTY_PACK
                      ,X.TO_SITE
                      ,X.TO_SITE_DESCRIPTION
                      ,X.PROJECT_CODE
                      ,X.FROM_BOH_QTY
                      ,X.TO_BOH_QTY
                      ,X.INCOTERMS
                      ,X.FROM_SITE
                      ,X.FROM_SITE_DESCRIPTION
                      ,X.TRANSPORT_MODE
                      ,Y.PROD_LINE AS PROD_LINE
                      ,X.LT_DAY
                      ,X.BOD_ID
                      ,X.MEASURE
                      ,X.MEASURE_LABEL
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
                      ,X.SORT_ORDER_NO
                      ,ISNULL(Y.QTY001,0), ISNULL(Y.QTY002,0), ISNULL(Y.QTY003,0) ,ISNULL(Y.QTY004,0), ISNULL(Y.QTY005,0), ISNULL(Y.QTY006,0), ISNULL(Y.QTY007,0), ISNULL(Y.QTY008,0), ISNULL(Y.QTY009,0), ISNULL(Y.QTY010,0)
                      ,ISNULL(Y.QTY011,0), ISNULL(Y.QTY012,0), ISNULL(Y.QTY013,0) ,ISNULL(Y.QTY014,0), ISNULL(Y.QTY015,0), ISNULL(Y.QTY016,0), ISNULL(Y.QTY017,0), ISNULL(Y.QTY018,0), ISNULL(Y.QTY019,0), ISNULL(Y.QTY020,0)
                      ,ISNULL(Y.QTY021,0), ISNULL(Y.QTY022,0), ISNULL(Y.QTY023,0) ,ISNULL(Y.QTY024,0), ISNULL(Y.QTY025,0), ISNULL(Y.QTY026,0), ISNULL(Y.QTY027,0), ISNULL(Y.QTY028,0), ISNULL(Y.QTY029,0), ISNULL(Y.QTY030,0)
                      ,ISNULL(Y.QTY031,0), ISNULL(Y.QTY032,0), ISNULL(Y.QTY033,0) ,ISNULL(Y.QTY034,0), ISNULL(Y.QTY035,0), ISNULL(Y.QTY036,0), ISNULL(Y.QTY037,0), ISNULL(Y.QTY038,0), ISNULL(Y.QTY039,0), ISNULL(Y.QTY040,0)
                      ,ISNULL(Y.QTY041,0), ISNULL(Y.QTY042,0), ISNULL(Y.QTY043,0) ,ISNULL(Y.QTY044,0), ISNULL(Y.QTY045,0), ISNULL(Y.QTY046,0), ISNULL(Y.QTY047,0), ISNULL(Y.QTY048,0), ISNULL(Y.QTY049,0), ISNULL(Y.QTY050,0)
                      ,ISNULL(Y.QTY051,0), ISNULL(Y.QTY052,0), ISNULL(Y.QTY053,0) ,ISNULL(Y.QTY054,0), ISNULL(Y.QTY055,0), ISNULL(Y.QTY056,0), ISNULL(Y.QTY057,0), ISNULL(Y.QTY058,0), ISNULL(Y.QTY059,0), ISNULL(Y.QTY060,0)
                      ,ISNULL(Y.QTY061,0), ISNULL(Y.QTY062,0), ISNULL(Y.QTY063,0) ,ISNULL(Y.QTY064,0), ISNULL(Y.QTY065,0), ISNULL(Y.QTY066,0), ISNULL(Y.QTY067,0), ISNULL(Y.QTY068,0), ISNULL(Y.QTY069,0), ISNULL(Y.QTY070,0)
                      ,ISNULL(Y.QTY071,0), ISNULL(Y.QTY072,0), ISNULL(Y.QTY073,0) ,ISNULL(Y.QTY074,0), ISNULL(Y.QTY075,0), ISNULL(Y.QTY076,0), ISNULL(Y.QTY077,0), ISNULL(Y.QTY078,0), ISNULL(Y.QTY079,0), ISNULL(Y.QTY080,0)
                      ,ISNULL(Y.QTY081,0), ISNULL(Y.QTY082,0), ISNULL(Y.QTY083,0) ,ISNULL(Y.QTY084,0), ISNULL(Y.QTY085,0), ISNULL(Y.QTY086,0), ISNULL(Y.QTY087,0), ISNULL(Y.QTY088,0), ISNULL(Y.QTY089,0), ISNULL(Y.QTY090,0)
                      ,ISNULL(Y.QTY091,0), ISNULL(Y.QTY092,0), ISNULL(Y.QTY093,0) ,ISNULL(Y.QTY094,0), ISNULL(Y.QTY095,0), ISNULL(Y.QTY096,0), ISNULL(Y.QTY097,0), ISNULL(Y.QTY098,0), ISNULL(Y.QTY099,0), ISNULL(Y.QTY100,0)
                      ,ISNULL(Y.QTY101,0), ISNULL(Y.QTY102,0), ISNULL(Y.QTY103,0) ,ISNULL(Y.QTY104,0), ISNULL(Y.QTY105,0), ISNULL(Y.QTY106,0), ISNULL(Y.QTY107,0), ISNULL(Y.QTY108,0), ISNULL(Y.QTY109,0), ISNULL(Y.QTY110,0)
                      ,ISNULL(Y.QTY111,0), ISNULL(Y.QTY112,0), ISNULL(Y.QTY113,0) ,ISNULL(Y.QTY114,0), ISNULL(Y.QTY115,0), ISNULL(Y.QTY116,0), ISNULL(Y.QTY117,0), ISNULL(Y.QTY118,0), ISNULL(Y.QTY119,0), ISNULL(Y.QTY120,0)
                      ,ISNULL(Y.QTY121,0), ISNULL(Y.QTY122,0), ISNULL(Y.QTY123,0) ,ISNULL(Y.QTY124,0), ISNULL(Y.QTY125,0), ISNULL(Y.QTY126,0), ISNULL(Y.QTY127,0), ISNULL(Y.QTY128,0), ISNULL(Y.QTY129,0), ISNULL(Y.QTY130,0)
                      ,ISNULL(Y.QTY131,0), ISNULL(Y.QTY132,0), ISNULL(Y.QTY133,0) ,ISNULL(Y.QTY134,0), ISNULL(Y.QTY135,0), ISNULL(Y.QTY136,0), ISNULL(Y.QTY137,0), ISNULL(Y.QTY138,0), ISNULL(Y.QTY139,0), ISNULL(Y.QTY140,0)
                      ,ISNULL(Y.QTY141,0), ISNULL(Y.QTY142,0), ISNULL(Y.QTY143,0) ,ISNULL(Y.QTY144,0), ISNULL(Y.QTY145,0), ISNULL(Y.QTY146,0), ISNULL(Y.QTY147,0), ISNULL(Y.QTY148,0), ISNULL(Y.QTY149,0), ISNULL(Y.QTY150,0)
                      ,ISNULL(Y.QTY151,0), ISNULL(Y.QTY152,0), ISNULL(Y.QTY153,0) ,ISNULL(Y.QTY154,0), ISNULL(Y.QTY155,0), ISNULL(Y.QTY156,0), ISNULL(Y.QTY157,0), ISNULL(Y.QTY158,0), ISNULL(Y.QTY159,0), ISNULL(Y.QTY160,0)
                      ,ISNULL(Y.QTY161,0), ISNULL(Y.QTY162,0), ISNULL(Y.QTY163,0) ,ISNULL(Y.QTY164,0), ISNULL(Y.QTY165,0), ISNULL(Y.QTY166,0), ISNULL(Y.QTY167,0), ISNULL(Y.QTY168,0), ISNULL(Y.QTY169,0), ISNULL(Y.QTY170,0)
                      ,ISNULL(Y.QTY171,0), ISNULL(Y.QTY172,0), ISNULL(Y.QTY173,0) ,ISNULL(Y.QTY174,0), ISNULL(Y.QTY175,0), ISNULL(Y.QTY176,0), ISNULL(Y.QTY177,0), ISNULL(Y.QTY178,0), ISNULL(Y.QTY179,0), ISNULL(Y.QTY180,0)
                      ,ISNULL(Y.QTY181,0), ISNULL(Y.QTY182,0), ISNULL(Y.QTY183,0) ,ISNULL(Y.QTY184,0), ISNULL(Y.QTY185,0), ISNULL(Y.QTY186,0), ISNULL(Y.QTY187,0), ISNULL(Y.QTY188,0), ISNULL(Y.QTY189,0), ISNULL(Y.QTY190,0)
                      ,ISNULL(Y.QTY191,0), ISNULL(Y.QTY192,0), ISNULL(Y.QTY193,0) ,ISNULL(Y.QTY194,0), ISNULL(Y.QTY195,0), ISNULL(Y.QTY196,0), ISNULL(Y.QTY197,0), ISNULL(Y.QTY198,0), ISNULL(Y.QTY199,0), ISNULL(Y.QTY200,0)
                      ,ISNULL(Y.QTY201,0), ISNULL(Y.QTY202,0), ISNULL(Y.QTY203,0) ,ISNULL(Y.QTY204,0), ISNULL(Y.QTY205,0), ISNULL(Y.QTY206,0), ISNULL(Y.QTY207,0), ISNULL(Y.QTY208,0), ISNULL(Y.QTY209,0), ISNULL(Y.QTY210,0)
                      ,ISNULL(Y.QTY211,0), ISNULL(Y.QTY212,0), ISNULL(Y.QTY213,0) ,ISNULL(Y.QTY214,0), ISNULL(Y.QTY215,0), ISNULL(Y.QTY216,0), ISNULL(Y.QTY217,0), ISNULL(Y.QTY218,0), ISNULL(Y.QTY219,0), ISNULL(Y.QTY220,0)
                      ,ISNULL(Y.QTY221,0), ISNULL(Y.QTY222,0), ISNULL(Y.QTY223,0) ,ISNULL(Y.QTY224,0), ISNULL(Y.QTY225,0), ISNULL(Y.QTY226,0), ISNULL(Y.QTY227,0), ISNULL(Y.QTY228,0), ISNULL(Y.QTY229,0), ISNULL(Y.QTY230,0)
                      ,ISNULL(Y.QTY231,0), ISNULL(Y.QTY232,0), ISNULL(Y.QTY233,0) ,ISNULL(Y.QTY234,0), ISNULL(Y.QTY235,0), ISNULL(Y.QTY236,0), ISNULL(Y.QTY237,0), ISNULL(Y.QTY238,0), ISNULL(Y.QTY239,0), ISNULL(Y.QTY240,0)
                      ,ISNULL(Y.QTY241,0), ISNULL(Y.QTY242,0), ISNULL(Y.QTY243,0) ,ISNULL(Y.QTY244,0), ISNULL(Y.QTY245,0), ISNULL(Y.QTY246,0), ISNULL(Y.QTY247,0), ISNULL(Y.QTY248,0), ISNULL(Y.QTY249,0), ISNULL(Y.QTY250,0)
                      ,ISNULL(Y.QTY251,0), ISNULL(Y.QTY252,0), ISNULL(Y.QTY253,0) ,ISNULL(Y.QTY254,0), ISNULL(Y.QTY255,0), ISNULL(Y.QTY256,0), ISNULL(Y.QTY257,0), ISNULL(Y.QTY258,0), ISNULL(Y.QTY259,0), ISNULL(Y.QTY260,0)
                      ,ISNULL(Y.QTY261,0), ISNULL(Y.QTY262,0), ISNULL(Y.QTY263,0) ,ISNULL(Y.QTY264,0), ISNULL(Y.QTY265,0), ISNULL(Y.QTY266,0), ISNULL(Y.QTY267,0), ISNULL(Y.QTY268,0), ISNULL(Y.QTY269,0), ISNULL(Y.QTY270,0)
                      ,ISNULL(Y.QTY271,0), ISNULL(Y.QTY272,0), ISNULL(Y.QTY273,0) ,ISNULL(Y.QTY274,0), ISNULL(Y.QTY275,0), ISNULL(Y.QTY276,0), ISNULL(Y.QTY277,0), ISNULL(Y.QTY278,0), ISNULL(Y.QTY279,0), ISNULL(Y.QTY280,0)
                      ,ISNULL(Y.QTY281,0), ISNULL(Y.QTY282,0), ISNULL(Y.QTY283,0) ,ISNULL(Y.QTY284,0), ISNULL(Y.QTY285,0), ISNULL(Y.QTY286,0), ISNULL(Y.QTY287,0), ISNULL(Y.QTY288,0), ISNULL(Y.QTY289,0), ISNULL(Y.QTY290,0)
                      ,ISNULL(Y.QTY291,0), ISNULL(Y.QTY292,0), ISNULL(Y.QTY293,0) ,ISNULL(Y.QTY294,0), ISNULL(Y.QTY295,0), ISNULL(Y.QTY296,0), ISNULL(Y.QTY297,0), ISNULL(Y.QTY298,0), ISNULL(Y.QTY299,0), ISNULL(Y.QTY300,0)
                      ,ISNULL(Y.QTY301,0), ISNULL(Y.QTY302,0), ISNULL(Y.QTY303,0) ,ISNULL(Y.QTY304,0), ISNULL(Y.QTY305,0), ISNULL(Y.QTY306,0), ISNULL(Y.QTY307,0), ISNULL(Y.QTY308,0), ISNULL(Y.QTY309,0), ISNULL(Y.QTY310,0)
                      ,ISNULL(Y.QTY311,0), ISNULL(Y.QTY312,0), ISNULL(Y.QTY313,0) ,ISNULL(Y.QTY314,0), ISNULL(Y.QTY315,0), ISNULL(Y.QTY316,0), ISNULL(Y.QTY317,0), ISNULL(Y.QTY318,0), ISNULL(Y.QTY319,0), ISNULL(Y.QTY320,0)
                      ,ISNULL(Y.QTY321,0), ISNULL(Y.QTY322,0), ISNULL(Y.QTY323,0) ,ISNULL(Y.QTY324,0), ISNULL(Y.QTY325,0), ISNULL(Y.QTY326,0), ISNULL(Y.QTY327,0), ISNULL(Y.QTY328,0), ISNULL(Y.QTY329,0), ISNULL(Y.QTY330,0)
                      ,ISNULL(Y.QTY331,0), ISNULL(Y.QTY332,0), ISNULL(Y.QTY333,0) ,ISNULL(Y.QTY334,0), ISNULL(Y.QTY335,0), ISNULL(Y.QTY336,0), ISNULL(Y.QTY337,0), ISNULL(Y.QTY338,0), ISNULL(Y.QTY339,0), ISNULL(Y.QTY340,0)
                      ,ISNULL(Y.QTY341,0), ISNULL(Y.QTY342,0), ISNULL(Y.QTY343,0) ,ISNULL(Y.QTY344,0), ISNULL(Y.QTY345,0), ISNULL(Y.QTY346,0), ISNULL(Y.QTY347,0), ISNULL(Y.QTY348,0), ISNULL(Y.QTY349,0), ISNULL(Y.QTY350,0)
                      ,ISNULL(Y.QTY351,0), ISNULL(Y.QTY352,0), ISNULL(Y.QTY353,0) ,ISNULL(Y.QTY354,0), ISNULL(Y.QTY355,0), ISNULL(Y.QTY356,0), ISNULL(Y.QTY357,0), ISNULL(Y.QTY358,0), ISNULL(Y.QTY359,0), ISNULL(Y.QTY360,0)
                      ,ISNULL(Y.QTY361,0), ISNULL(Y.QTY362,0), ISNULL(Y.QTY363,0) ,ISNULL(Y.QTY364,0)                   
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
                      FROM #SCP_XLS_PSI_GLOBAL_ESS X WITH (NOLOCK) 
                      CROSS APPLY #TACT_TIME_WEEK Y  WITH (NOLOCK)
                      WHERE 0 = 0
                      AND X.DIVISION_ID   = Y.DIVISION_ID
                      AND X.ITEM_ID       = Y.ITEM_ID
                      AND X.FROM_SITE     = Y.SCM_SITE_ID
                      AND X.MEASURE       IN  ('PACK_TACT_TIME','CELL_TACT_TIME')
                      AND NOT EXISTS (                
                                            SELECT 'X'                
                                              FROM #SCP_XLS_PSI_GLOBAL_ESS Z WITH(NOLOCK)                
                                             WHERE 1=1                
                                               AND Z.DIVISION_ID          = X.DIVISION_ID                
                                               AND Z.CELL_ITEM_ID         = X.CELL_ITEM_ID    
                                               AND Z.ITEM_ID              = X.ITEM_ID              
                                               AND Z.MEASURE              = X.MEASURE 
                                               AND Z.FROM_SITE            = Y.SCM_SITE_ID
                                               AND Z.PROD_LINE            = Y.PROD_LINE
                                               AND Z.MEASURE              IN ('PACK_TACT_TIME','CELL_TACT_TIME')
                                               )

                    /*
                    IF OBJECT_ID('tempdb..##SCP_XLS_PSI_GLOBAL_ESS') IS NOT NULL	
	                    DROP TABLE ##SCP_XLS_PSI_GLOBAL_ESS

                      SELECT * INTO ##SCP_XLS_PSI_GLOBAL_ESS  FROM #SCP_XLS_PSI_GLOBAL_ESS WITH (NOLOCK)

                    IF OBJECT_ID('tempdb..##PSI_GLOBAL') IS NOT NULL	
	                    DROP TABLE ##PSI_GLOBAL

                     SELECT * INTO ##PSI_GLOBAL FROM #PSI_GLOBAL WITH (NOLOCK)

                     IF OBJECT_ID('tempdb..##PSI_GLOBAL_ESS') IS NOT NULL	
	                    DROP TABLE ##PSI_GLOBAL_ESS

                     SELECT * INTO ##PSI_GLOBAL_ESS  FROM #PSI_GLOBAL_ESS WITH (NOLOCK)
                     return;
                     */



            -------------------------------------------------------------------------------------------------------------         
            -- TACT TIME UPDATE
            -------------------------------------------------------------------------------------------------------------
            IF OBJECT_ID('tempdb..#PROD_TACT_TIME_PIVOT') IS NOT NULL
	              DROP TABLE #PROD_TACT_TIME_PIVOT
   
                 SELECT DIVISION_ID
                      ,SCM_SITE_ID
                      ,OPERATION_ID
					  ,ITEM_ID
                      ,LINE_ID
                      ,MAX(QTY001) AS QTY001, MAX(QTY002) AS QTY002, MAX(QTY003) AS QTY003, MAX(QTY004) AS QTY004, MAX(QTY005) AS QTY005,MAX(QTY006) AS QTY006, MAX(QTY007) AS QTY007, MAX(QTY008) AS QTY008, MAX(QTY009) AS QTY009, MAX(QTY010) AS QTY010
                      ,MAX(QTY011) AS QTY011, MAX(QTY012) AS QTY012, MAX(QTY013) AS QTY013, MAX(QTY014) AS QTY014, MAX(QTY015) AS QTY015,MAX(QTY016) AS QTY016, MAX(QTY017) AS QTY017, MAX(QTY018) AS QTY018, MAX(QTY019) AS QTY019, MAX(QTY020) AS QTY020
                      ,MAX(QTY021) AS QTY021, MAX(QTY022) AS QTY022, MAX(QTY023) AS QTY023, MAX(QTY024) AS QTY024, MAX(QTY025) AS QTY025,MAX(QTY026) AS QTY026, MAX(QTY027) AS QTY027, MAX(QTY028) AS QTY028, MAX(QTY029) AS QTY029, MAX(QTY030) AS QTY030
                      ,MAX(QTY031) AS QTY031, MAX(QTY032) AS QTY032, MAX(QTY033) AS QTY033, MAX(QTY034) AS QTY034, MAX(QTY035) AS QTY035,MAX(QTY036) AS QTY036, MAX(QTY037) AS QTY037, MAX(QTY038) AS QTY038, MAX(QTY039) AS QTY039, MAX(QTY040) AS QTY040
                      ,MAX(QTY041) AS QTY041, MAX(QTY042) AS QTY042, MAX(QTY043) AS QTY043, MAX(QTY044) AS QTY044, MAX(QTY045) AS QTY045,MAX(QTY046) AS QTY046, MAX(QTY047) AS QTY047, MAX(QTY048) AS QTY048, MAX(QTY049) AS QTY049, MAX(QTY050) AS QTY050
                      ,MAX(QTY051) AS QTY051, MAX(QTY052) AS QTY052, MAX(QTY053) AS QTY053, MAX(QTY054) AS QTY054, MAX(QTY055) AS QTY055,MAX(QTY056) AS QTY056, MAX(QTY057) AS QTY057, MAX(QTY058) AS QTY058, MAX(QTY059) AS QTY059, MAX(QTY060) AS QTY060
                      ,MAX(QTY061) AS QTY061, MAX(QTY062) AS QTY062, MAX(QTY063) AS QTY063, MAX(QTY064) AS QTY064, MAX(QTY065) AS QTY065,MAX(QTY066) AS QTY066, MAX(QTY067) AS QTY067, MAX(QTY068) AS QTY068, MAX(QTY069) AS QTY069, MAX(QTY070) AS QTY070
                      ,MAX(QTY071) AS QTY071, MAX(QTY072) AS QTY072, MAX(QTY073) AS QTY073, MAX(QTY074) AS QTY074, MAX(QTY075) AS QTY075,MAX(QTY076) AS QTY076, MAX(QTY077) AS QTY077, MAX(QTY078) AS QTY078, MAX(QTY079) AS QTY079, MAX(QTY080) AS QTY080
                      ,MAX(QTY081) AS QTY081, MAX(QTY082) AS QTY082, MAX(QTY083) AS QTY083, MAX(QTY084) AS QTY084, MAX(QTY085) AS QTY085,MAX(QTY086) AS QTY086, MAX(QTY087) AS QTY087, MAX(QTY088) AS QTY088, MAX(QTY089) AS QTY089, MAX(QTY090) AS QTY090
                      ,MAX(QTY091) AS QTY091, MAX(QTY092) AS QTY092, MAX(QTY093) AS QTY093, MAX(QTY094) AS QTY094, MAX(QTY095) AS QTY095,MAX(QTY096) AS QTY096, MAX(QTY097) AS QTY097, MAX(QTY098) AS QTY098, MAX(QTY099) AS QTY099, MAX(QTY100) AS QTY100
                      ,MAX(QTY101) AS QTY101, MAX(QTY102) AS QTY102, MAX(QTY103) AS QTY103, MAX(QTY104) AS QTY104, MAX(QTY105) AS QTY105,MAX(QTY106) AS QTY106, MAX(QTY107) AS QTY107, MAX(QTY108) AS QTY108, MAX(QTY109) AS QTY109, MAX(QTY110) AS QTY110
                      ,MAX(QTY111) AS QTY111, MAX(QTY112) AS QTY112, MAX(QTY113) AS QTY113, MAX(QTY114) AS QTY114, MAX(QTY115) AS QTY115,MAX(QTY116) AS QTY116, MAX(QTY117) AS QTY117, MAX(QTY118) AS QTY118, MAX(QTY119) AS QTY119, MAX(QTY120) AS QTY120
                      ,MAX(QTY121) AS QTY121, MAX(QTY122) AS QTY122, MAX(QTY123) AS QTY123, MAX(QTY124) AS QTY124, MAX(QTY125) AS QTY125,MAX(QTY126) AS QTY126, MAX(QTY127) AS QTY127, MAX(QTY128) AS QTY128, MAX(QTY129) AS QTY129, MAX(QTY130) AS QTY130
                      ,MAX(QTY131) AS QTY131, MAX(QTY132) AS QTY132, MAX(QTY133) AS QTY133, MAX(QTY134) AS QTY134, MAX(QTY135) AS QTY135,MAX(QTY136) AS QTY136, MAX(QTY137) AS QTY137, MAX(QTY138) AS QTY138, MAX(QTY139) AS QTY139, MAX(QTY140) AS QTY140
                      ,MAX(QTY141) AS QTY141, MAX(QTY142) AS QTY142, MAX(QTY143) AS QTY143, MAX(QTY144) AS QTY144, MAX(QTY145) AS QTY145,MAX(QTY146) AS QTY146, MAX(QTY147) AS QTY147, MAX(QTY148) AS QTY148, MAX(QTY149) AS QTY149, MAX(QTY150) AS QTY150
                      ,MAX(QTY151) AS QTY151, MAX(QTY152) AS QTY152, MAX(QTY153) AS QTY153, MAX(QTY154) AS QTY154, MAX(QTY155) AS QTY155,MAX(QTY156) AS QTY156, MAX(QTY157) AS QTY157, MAX(QTY158) AS QTY158, MAX(QTY159) AS QTY159, MAX(QTY160) AS QTY160
                      ,MAX(QTY161) AS QTY161, MAX(QTY162) AS QTY162, MAX(QTY163) AS QTY163, MAX(QTY164) AS QTY164, MAX(QTY165) AS QTY165,MAX(QTY166) AS QTY166, MAX(QTY167) AS QTY167, MAX(QTY168) AS QTY168, MAX(QTY169) AS QTY169, MAX(QTY170) AS QTY170
                      ,MAX(QTY171) AS QTY171, MAX(QTY172) AS QTY172, MAX(QTY173) AS QTY173, MAX(QTY174) AS QTY174, MAX(QTY175) AS QTY175,MAX(QTY176) AS QTY176, MAX(QTY177) AS QTY177, MAX(QTY178) AS QTY178, MAX(QTY179) AS QTY179, MAX(QTY180) AS QTY180
                      ,MAX(QTY181) AS QTY181, MAX(QTY182) AS QTY182, MAX(QTY183) AS QTY183, MAX(QTY184) AS QTY184, MAX(QTY185) AS QTY185,MAX(QTY186) AS QTY186, MAX(QTY187) AS QTY187, MAX(QTY188) AS QTY188, MAX(QTY189) AS QTY189, MAX(QTY190) AS QTY190
                      ,MAX(QTY191) AS QTY191, MAX(QTY192) AS QTY192, MAX(QTY193) AS QTY193, MAX(QTY194) AS QTY194, MAX(QTY195) AS QTY195,MAX(QTY196) AS QTY196, MAX(QTY197) AS QTY197, MAX(QTY198) AS QTY198, MAX(QTY199) AS QTY199, MAX(QTY200) AS QTY200
                      ,MAX(QTY201) AS QTY201, MAX(QTY202) AS QTY202, MAX(QTY203) AS QTY203, MAX(QTY204) AS QTY204, MAX(QTY205) AS QTY205,MAX(QTY206) AS QTY206, MAX(QTY207) AS QTY207, MAX(QTY208) AS QTY208, MAX(QTY209) AS QTY209, MAX(QTY210) AS QTY210
                      ,MAX(QTY211) AS QTY211, MAX(QTY212) AS QTY212, MAX(QTY213) AS QTY213, MAX(QTY214) AS QTY214, MAX(QTY215) AS QTY215,MAX(QTY216) AS QTY216, MAX(QTY217) AS QTY217, MAX(QTY218) AS QTY218, MAX(QTY219) AS QTY219, MAX(QTY220) AS QTY220
                      ,MAX(QTY221) AS QTY221, MAX(QTY222) AS QTY222, MAX(QTY223) AS QTY223, MAX(QTY224) AS QTY224, MAX(QTY225) AS QTY225,MAX(QTY226) AS QTY226, MAX(QTY227) AS QTY227, MAX(QTY228) AS QTY228, MAX(QTY229) AS QTY229, MAX(QTY230) AS QTY230
                      ,MAX(QTY231) AS QTY231, MAX(QTY232) AS QTY232, MAX(QTY233) AS QTY233, MAX(QTY234) AS QTY234, MAX(QTY235) AS QTY235,MAX(QTY236) AS QTY236, MAX(QTY237) AS QTY237, MAX(QTY238) AS QTY238, MAX(QTY239) AS QTY239, MAX(QTY240) AS QTY240
                      ,MAX(QTY241) AS QTY241, MAX(QTY242) AS QTY242, MAX(QTY243) AS QTY243, MAX(QTY244) AS QTY244, MAX(QTY245) AS QTY245,MAX(QTY246) AS QTY246, MAX(QTY247) AS QTY247, MAX(QTY248) AS QTY248, MAX(QTY249) AS QTY249, MAX(QTY250) AS QTY250
                      ,MAX(QTY251) AS QTY251, MAX(QTY252) AS QTY252, MAX(QTY253) AS QTY253, MAX(QTY254) AS QTY254, MAX(QTY255) AS QTY255,MAX(QTY256) AS QTY256, MAX(QTY257) AS QTY257, MAX(QTY258) AS QTY258, MAX(QTY259) AS QTY259, MAX(QTY260) AS QTY260
                      ,MAX(QTY261) AS QTY261, MAX(QTY262) AS QTY262, MAX(QTY263) AS QTY263, MAX(QTY264) AS QTY264, MAX(QTY265) AS QTY265,MAX(QTY266) AS QTY266, MAX(QTY267) AS QTY267, MAX(QTY268) AS QTY268, MAX(QTY269) AS QTY269, MAX(QTY270) AS QTY270
                      ,MAX(QTY271) AS QTY271, MAX(QTY272) AS QTY272, MAX(QTY273) AS QTY273, MAX(QTY274) AS QTY274, MAX(QTY275) AS QTY275,MAX(QTY276) AS QTY276, MAX(QTY277) AS QTY277, MAX(QTY278) AS QTY278, MAX(QTY279) AS QTY279, MAX(QTY280) AS QTY280
                      ,MAX(QTY281) AS QTY281, MAX(QTY282) AS QTY282, MAX(QTY283) AS QTY283, MAX(QTY284) AS QTY284, MAX(QTY285) AS QTY285,MAX(QTY286) AS QTY286, MAX(QTY287) AS QTY287, MAX(QTY288) AS QTY288, MAX(QTY289) AS QTY289, MAX(QTY290) AS QTY290
                      ,MAX(QTY291) AS QTY291, MAX(QTY292) AS QTY292, MAX(QTY293) AS QTY293, MAX(QTY294) AS QTY294, MAX(QTY295) AS QTY295,MAX(QTY296) AS QTY296, MAX(QTY297) AS QTY297, MAX(QTY298) AS QTY298, MAX(QTY299) AS QTY299, MAX(QTY300) AS QTY300
                      ,MAX(QTY301) AS QTY301, MAX(QTY302) AS QTY302, MAX(QTY303) AS QTY303, MAX(QTY304) AS QTY304, MAX(QTY305) AS QTY305,MAX(QTY306) AS QTY306, MAX(QTY307) AS QTY307, MAX(QTY308) AS QTY308, MAX(QTY309) AS QTY309, MAX(QTY310) AS QTY310
                      ,MAX(QTY311) AS QTY311, MAX(QTY312) AS QTY312, MAX(QTY313) AS QTY313, MAX(QTY314) AS QTY314, MAX(QTY315) AS QTY315,MAX(QTY316) AS QTY316, MAX(QTY317) AS QTY317, MAX(QTY318) AS QTY318, MAX(QTY319) AS QTY319, MAX(QTY320) AS QTY320
                      ,MAX(QTY321) AS QTY321, MAX(QTY322) AS QTY322, MAX(QTY323) AS QTY323, MAX(QTY324) AS QTY324, MAX(QTY325) AS QTY325,MAX(QTY326) AS QTY326, MAX(QTY327) AS QTY327, MAX(QTY328) AS QTY328, MAX(QTY329) AS QTY329, MAX(QTY330) AS QTY330
                      ,MAX(QTY331) AS QTY331, MAX(QTY332) AS QTY332, MAX(QTY333) AS QTY333, MAX(QTY334) AS QTY334, MAX(QTY335) AS QTY335,MAX(QTY336) AS QTY336, MAX(QTY337) AS QTY337, MAX(QTY338) AS QTY338, MAX(QTY339) AS QTY339, MAX(QTY340) AS QTY340
                      ,MAX(QTY341) AS QTY341, MAX(QTY342) AS QTY342, MAX(QTY343) AS QTY343, MAX(QTY344) AS QTY344, MAX(QTY345) AS QTY345,MAX(QTY346) AS QTY346, MAX(QTY347) AS QTY347, MAX(QTY348) AS QTY348, MAX(QTY349) AS QTY349, MAX(QTY350) AS QTY350
                      ,MAX(QTY351) AS QTY351, MAX(QTY352) AS QTY352, MAX(QTY353) AS QTY353, MAX(QTY354) AS QTY354, MAX(QTY355) AS QTY355,MAX(QTY356) AS QTY356, MAX(QTY357) AS QTY357, MAX(QTY358) AS QTY358, MAX(QTY359) AS QTY359, MAX(QTY360) AS QTY360
                      ,MAX(QTY361) AS QTY361, MAX(QTY362) AS QTY362, MAX(QTY363) AS QTY363, MAX(QTY364) AS QTY364 
                INTO #PROD_TACT_TIME_PIVOT
                 FROM
                    (
                       SELECT   D.DIVISION_ID
					          , D.OPERATION_ID
                              , D.SCM_SITE_ID
							  , D.ITEM_ID
					          , D.LINE_ID
						      , D.TACT_TIME AS VAL
                              , D.YYYYMMDD
                              , Y.YYYYMMDD_COLUMN
                        FROM SCP_ANL_TACT_TIME D WITH(NOLOCK)
                        CROSS APPLY (SELECT C.BASIS_YYYYMMDD AS YYYYMMDD      
										  ,'QTY' + REPLICATE('0', 3 - LEN(ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD) )) + CONVERT(NVARCHAR,ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD)) AS YYYYMMDD_COLUMN
									  FROM SCM_SYS_CALENDAR_M    C WITH(NOLOCK)     
									WHERE 1=1  
									  AND C.BASIS_YYYYMMDD BETWEEN @p_create_from_yyyymmdd AND @p_create_to_yyyymmdd) Y
                        WHERE 0 = 0
						  AND D.DIVISION_ID = @p_division_id
                          AND D.YYYYMMDD BETWEEN @p_create_from_yyyymmdd AND @p_create_to_yyyymmdd
                          AND D.YYYYMMDD = Y.YYYYMMDD

                ) AS SourceTable  
                  PIVOT 
                      (
                       SUM(VAL)
                       FOR  YYYYMMDD_COLUMN IN ( [QTY001], [QTY002], [QTY003], [QTY004], [QTY005],[QTY006], [QTY007], [QTY008], [QTY009], [QTY010]
                                                ,[QTY011], [QTY012], [QTY013], [QTY014], [QTY015],[QTY016], [QTY017], [QTY018], [QTY019], [QTY020]
                                                ,[QTY021], [QTY022], [QTY023], [QTY024], [QTY025],[QTY026], [QTY027], [QTY028], [QTY029], [QTY030]
                                                ,[QTY031], [QTY032], [QTY033], [QTY034], [QTY035],[QTY036], [QTY037], [QTY038], [QTY039], [QTY040]
                                                ,[QTY041], [QTY042], [QTY043], [QTY044], [QTY045],[QTY046], [QTY047], [QTY048], [QTY049], [QTY050]
                                                ,[QTY051], [QTY052], [QTY053], [QTY054], [QTY055],[QTY056], [QTY057], [QTY058], [QTY059], [QTY060]
                                                ,[QTY061], [QTY062], [QTY063], [QTY064], [QTY065],[QTY066], [QTY067], [QTY068], [QTY069], [QTY070]
                                                ,[QTY071], [QTY072], [QTY073], [QTY074], [QTY075],[QTY076], [QTY077], [QTY078], [QTY079], [QTY080]
                                                ,[QTY081], [QTY082], [QTY083], [QTY084], [QTY085],[QTY086], [QTY087], [QTY088], [QTY089], [QTY090]
                                                ,[QTY091], [QTY092], [QTY093], [QTY094], [QTY095],[QTY096], [QTY097], [QTY098], [QTY099], [QTY100]

                                                ,[QTY101], [QTY102], [QTY103], [QTY104], [QTY105],[QTY106], [QTY107], [QTY108], [QTY109], [QTY110]
                                                ,[QTY111], [QTY112], [QTY113], [QTY114], [QTY115],[QTY116], [QTY117], [QTY118], [QTY119], [QTY120]
                                                ,[QTY121], [QTY122], [QTY123], [QTY124], [QTY125],[QTY126], [QTY127], [QTY128], [QTY129], [QTY130]
                                                ,[QTY131], [QTY132], [QTY133], [QTY134], [QTY135],[QTY136], [QTY137], [QTY138], [QTY139], [QTY140]
                                                ,[QTY141], [QTY142], [QTY143], [QTY144], [QTY145],[QTY146], [QTY147], [QTY148], [QTY149], [QTY150]
                                                ,[QTY151], [QTY152], [QTY153], [QTY154], [QTY155],[QTY156], [QTY157], [QTY158], [QTY159], [QTY160]
                                                ,[QTY161], [QTY162], [QTY163], [QTY164], [QTY165],[QTY166], [QTY167], [QTY168], [QTY169], [QTY170]
                                                ,[QTY171], [QTY172], [QTY173], [QTY174], [QTY175],[QTY176], [QTY177], [QTY178], [QTY179], [QTY180]
                                                ,[QTY181], [QTY182], [QTY183], [QTY184], [QTY185],[QTY186], [QTY187], [QTY188], [QTY189], [QTY190]
                                                ,[QTY191], [QTY192], [QTY193], [QTY194], [QTY195],[QTY196], [QTY197], [QTY198], [QTY199], [QTY200]

                                                ,[QTY201], [QTY202], [QTY203], [QTY204], [QTY205],[QTY206], [QTY207], [QTY208], [QTY209], [QTY210]
                                                ,[QTY211], [QTY212], [QTY213], [QTY214], [QTY215],[QTY216], [QTY217], [QTY218], [QTY219], [QTY220]
                                                ,[QTY221], [QTY222], [QTY223], [QTY224], [QTY225],[QTY226], [QTY227], [QTY228], [QTY229], [QTY230]
                                                ,[QTY231], [QTY232], [QTY233], [QTY234], [QTY235],[QTY236], [QTY237], [QTY238], [QTY239], [QTY240]
                                                ,[QTY241], [QTY242], [QTY243], [QTY244], [QTY245],[QTY246], [QTY247], [QTY248], [QTY249], [QTY250]
                                                ,[QTY251], [QTY252], [QTY253], [QTY254], [QTY255],[QTY256], [QTY257], [QTY258], [QTY259], [QTY260]
                                                ,[QTY261], [QTY262], [QTY263], [QTY264], [QTY265],[QTY266], [QTY267], [QTY268], [QTY269], [QTY270]
                                                ,[QTY271], [QTY272], [QTY273], [QTY274], [QTY275],[QTY276], [QTY277], [QTY278], [QTY279], [QTY280]
                                                ,[QTY281], [QTY282], [QTY283], [QTY284], [QTY285],[QTY286], [QTY287], [QTY288], [QTY289], [QTY290]
                                                ,[QTY291], [QTY292], [QTY293], [QTY294], [QTY295],[QTY296], [QTY297], [QTY298], [QTY299], [QTY300]

                                                ,[QTY301], [QTY302], [QTY303], [QTY304], [QTY305],[QTY306], [QTY307], [QTY308], [QTY309], [QTY310]
                                                ,[QTY311], [QTY312], [QTY313], [QTY314], [QTY315],[QTY316], [QTY317], [QTY318], [QTY319], [QTY320]
                                                ,[QTY321], [QTY322], [QTY323], [QTY324], [QTY325],[QTY326], [QTY327], [QTY328], [QTY329], [QTY330]
                                                ,[QTY331], [QTY332], [QTY333], [QTY334], [QTY335],[QTY336], [QTY337], [QTY338], [QTY339], [QTY340]
                                                ,[QTY341], [QTY342], [QTY343], [QTY344], [QTY345],[QTY346], [QTY347], [QTY348], [QTY349], [QTY350]
                                                ,[QTY351], [QTY352], [QTY353], [QTY354], [QTY355],[QTY356], [QTY357], [QTY358], [QTY359], [QTY360]
                                                ,[QTY361], [QTY362], [QTY363], [QTY364]
                                            )  
                ) XX

                GROUP BY  DIVISION_ID
                        ,SCM_SITE_ID
                        ,OPERATION_ID
                        ,LINE_ID
						,ITEM_ID

                UPDATE X
                  SET  X.QTY001 = ISNULL(Y.QTY001,0), QTY002 = ISNULL(Y.QTY002,0), X.QTY003 = ISNULL(Y.QTY003,0), X.QTY004 = ISNULL(Y.QTY004,0), X.QTY005 = ISNULL(Y.QTY005,0), X.QTY006 = ISNULL(Y.QTY006,0), X.QTY007 = ISNULL(Y.QTY007,0)
                      ,X.QTY008 = ISNULL(Y.QTY008,0), QTY009 = ISNULL(Y.QTY009,0), X.QTY010 = ISNULL(Y.QTY010,0), X.QTY011 = ISNULL(Y.QTY011,0), X.QTY012 = ISNULL(Y.QTY012,0), X.QTY013 = ISNULL(Y.QTY013,0), X.QTY014 = ISNULL(Y.QTY014,0)
                      ,X.QTY015 = ISNULL(Y.QTY015,0), QTY016 = ISNULL(Y.QTY016,0), X.QTY017 = ISNULL(Y.QTY017,0), X.QTY018 = ISNULL(Y.QTY018,0), X.QTY019 = ISNULL(Y.QTY019,0), X.QTY020 = ISNULL(Y.QTY020,0), X.QTY021 = ISNULL(Y.QTY021,0)
                      ,X.QTY022 = ISNULL(Y.QTY022,0), QTY023 = ISNULL(Y.QTY023,0), X.QTY024 = ISNULL(Y.QTY024,0), X.QTY025 = ISNULL(Y.QTY025,0), X.QTY026 = ISNULL(Y.QTY026,0), X.QTY027 = ISNULL(Y.QTY027,0), X.QTY028 = ISNULL(Y.QTY028,0)
                      ,X.QTY029 = ISNULL(Y.QTY029,0), QTY030 = ISNULL(Y.QTY030,0), X.QTY031 = ISNULL(Y.QTY031,0), X.QTY032 = ISNULL(Y.QTY032,0), X.QTY033 = ISNULL(Y.QTY033,0), X.QTY034 = ISNULL(Y.QTY034,0), X.QTY035 = ISNULL(Y.QTY035,0)
                      ,X.QTY036 = ISNULL(Y.QTY036,0), QTY037 = ISNULL(Y.QTY037,0), X.QTY038 = ISNULL(Y.QTY038,0), X.QTY039 = ISNULL(Y.QTY039,0), X.QTY040 = ISNULL(Y.QTY040,0), X.QTY041 = ISNULL(Y.QTY041,0), X.QTY042 = ISNULL(Y.QTY042,0)
                      ,X.QTY043 = ISNULL(Y.QTY043,0), QTY044 = ISNULL(Y.QTY044,0), X.QTY045 = ISNULL(Y.QTY045,0), X.QTY046 = ISNULL(Y.QTY046,0), X.QTY047 = ISNULL(Y.QTY047,0), X.QTY048 = ISNULL(Y.QTY048,0), X.QTY049 = ISNULL(Y.QTY049,0)
                      ,X.QTY050 = ISNULL(Y.QTY050,0), QTY051 = ISNULL(Y.QTY051,0), X.QTY052 = ISNULL(Y.QTY052,0), X.QTY053 = ISNULL(Y.QTY053,0), X.QTY054 = ISNULL(Y.QTY054,0), X.QTY055 = ISNULL(Y.QTY055,0), X.QTY056 = ISNULL(Y.QTY056,0)
                      ,X.QTY057 = ISNULL(Y.QTY057,0), QTY058 = ISNULL(Y.QTY058,0), X.QTY059 = ISNULL(Y.QTY059,0), X.QTY060 = ISNULL(Y.QTY060,0), X.QTY061 = ISNULL(Y.QTY061,0), X.QTY062 = ISNULL(Y.QTY062,0), X.QTY063 = ISNULL(Y.QTY063,0)
                      ,X.QTY064 = ISNULL(Y.QTY064,0), QTY065 = ISNULL(Y.QTY065,0), X.QTY066 = ISNULL(Y.QTY066,0), X.QTY067 = ISNULL(Y.QTY067,0), X.QTY068 = ISNULL(Y.QTY068,0), X.QTY069 = ISNULL(Y.QTY069,0), X.QTY070 = ISNULL(Y.QTY070,0)
                      ,X.QTY071 = ISNULL(Y.QTY071,0), QTY072 = ISNULL(Y.QTY072,0), X.QTY073 = ISNULL(Y.QTY073,0), X.QTY074 = ISNULL(Y.QTY074,0), X.QTY075 = ISNULL(Y.QTY075,0), X.QTY076 = ISNULL(Y.QTY076,0), X.QTY077 = ISNULL(Y.QTY077,0)
                      ,X.QTY078 = ISNULL(Y.QTY078,0), QTY079 = ISNULL(Y.QTY079,0), X.QTY080 = ISNULL(Y.QTY080,0), X.QTY081 = ISNULL(Y.QTY081,0), X.QTY082 = ISNULL(Y.QTY082,0), X.QTY083 = ISNULL(Y.QTY083,0), X.QTY084 = ISNULL(Y.QTY084,0)
                      ,X.QTY085 = ISNULL(Y.QTY085,0), QTY086 = ISNULL(Y.QTY086,0), X.QTY087 = ISNULL(Y.QTY087,0), X.QTY088 = ISNULL(Y.QTY088,0), X.QTY089 = ISNULL(Y.QTY089,0), X.QTY090 = ISNULL(Y.QTY090,0), X.QTY091 = ISNULL(Y.QTY091,0)
                      ,X.QTY092 = ISNULL(Y.QTY092,0), QTY093 = ISNULL(Y.QTY093,0), X.QTY094 = ISNULL(Y.QTY094,0), X.QTY095 = ISNULL(Y.QTY095,0), X.QTY096 = ISNULL(Y.QTY096,0), X.QTY097 = ISNULL(Y.QTY097,0), X.QTY098 = ISNULL(Y.QTY098,0)
                      ,X.QTY099 = ISNULL(Y.QTY099,0), QTY100 = ISNULL(Y.QTY100,0), X.QTY101 = ISNULL(Y.QTY101,0), X.QTY102 = ISNULL(Y.QTY102,0), X.QTY103 = ISNULL(Y.QTY103,0), X.QTY104 = ISNULL(Y.QTY104,0), X.QTY105 = ISNULL(Y.QTY105,0)
                      ,X.QTY106 = ISNULL(Y.QTY106,0), QTY107 = ISNULL(Y.QTY107,0), X.QTY108 = ISNULL(Y.QTY108,0), X.QTY109 = ISNULL(Y.QTY109,0), X.QTY110 = ISNULL(Y.QTY110,0), X.QTY111 = ISNULL(Y.QTY111,0), X.QTY112 = ISNULL(Y.QTY112,0)
                      ,X.QTY113 = ISNULL(Y.QTY113,0), QTY114 = ISNULL(Y.QTY114,0), X.QTY115 = ISNULL(Y.QTY115,0), X.QTY116 = ISNULL(Y.QTY116,0), X.QTY117 = ISNULL(Y.QTY117,0), X.QTY118 = ISNULL(Y.QTY118,0), X.QTY119 = ISNULL(Y.QTY119,0)
                      ,X.QTY120 = ISNULL(Y.QTY120,0), QTY121 = ISNULL(Y.QTY121,0), X.QTY122 = ISNULL(Y.QTY122,0), X.QTY123 = ISNULL(Y.QTY123,0), X.QTY124 = ISNULL(Y.QTY124,0), X.QTY125 = ISNULL(Y.QTY125,0), X.QTY126 = ISNULL(Y.QTY126,0)
                      ,X.QTY127 = ISNULL(Y.QTY127,0), QTY128 = ISNULL(Y.QTY128,0), X.QTY129 = ISNULL(Y.QTY129,0), X.QTY130 = ISNULL(Y.QTY130,0), X.QTY131 = ISNULL(Y.QTY131,0), X.QTY132 = ISNULL(Y.QTY132,0), X.QTY133 = ISNULL(Y.QTY133,0)
                      ,X.QTY134 = ISNULL(Y.QTY134,0), QTY135 = ISNULL(Y.QTY135,0), X.QTY136 = ISNULL(Y.QTY136,0), X.QTY137 = ISNULL(Y.QTY137,0), X.QTY138 = ISNULL(Y.QTY138,0), X.QTY139 = ISNULL(Y.QTY139,0), X.QTY140 = ISNULL(Y.QTY140,0)
                      ,X.QTY141 = ISNULL(Y.QTY141,0), QTY142 = ISNULL(Y.QTY142,0), X.QTY143 = ISNULL(Y.QTY143,0), X.QTY144 = ISNULL(Y.QTY144,0), X.QTY145 = ISNULL(Y.QTY145,0), X.QTY146 = ISNULL(Y.QTY146,0), X.QTY147 = ISNULL(Y.QTY147,0)
                      ,X.QTY148 = ISNULL(Y.QTY148,0), QTY149 = ISNULL(Y.QTY149,0), X.QTY150 = ISNULL(Y.QTY150,0), X.QTY151 = ISNULL(Y.QTY151,0), X.QTY152 = ISNULL(Y.QTY152,0), X.QTY153 = ISNULL(Y.QTY153,0), X.QTY154 = ISNULL(Y.QTY154,0)
                      ,X.QTY155 = ISNULL(Y.QTY155,0), QTY156 = ISNULL(Y.QTY156,0), X.QTY157 = ISNULL(Y.QTY157,0), X.QTY158 = ISNULL(Y.QTY158,0), X.QTY159 = ISNULL(Y.QTY159,0), X.QTY160 = ISNULL(Y.QTY160,0), X.QTY161 = ISNULL(Y.QTY161,0)
                      ,X.QTY162 = ISNULL(Y.QTY162,0), QTY163 = ISNULL(Y.QTY163,0), X.QTY164 = ISNULL(Y.QTY164,0), X.QTY165 = ISNULL(Y.QTY165,0), X.QTY166 = ISNULL(Y.QTY166,0), X.QTY167 = ISNULL(Y.QTY167,0), X.QTY168 = ISNULL(Y.QTY168,0)
                      ,X.QTY169 = ISNULL(Y.QTY169,0), QTY170 = ISNULL(Y.QTY170,0), X.QTY171 = ISNULL(Y.QTY171,0), X.QTY172 = ISNULL(Y.QTY172,0), X.QTY173 = ISNULL(Y.QTY173,0), X.QTY174 = ISNULL(Y.QTY174,0), X.QTY175 = ISNULL(Y.QTY175,0)
                      ,X.QTY176 = ISNULL(Y.QTY176,0), QTY177 = ISNULL(Y.QTY177,0), X.QTY178 = ISNULL(Y.QTY178,0), X.QTY179 = ISNULL(Y.QTY179,0), X.QTY180 = ISNULL(Y.QTY180,0), X.QTY181 = ISNULL(Y.QTY181,0), X.QTY182 = ISNULL(Y.QTY182,0)
                      ,X.QTY183 = ISNULL(Y.QTY183,0), QTY184 = ISNULL(Y.QTY184,0), X.QTY185 = ISNULL(Y.QTY185,0), X.QTY186 = ISNULL(Y.QTY186,0), X.QTY187 = ISNULL(Y.QTY187,0), X.QTY188 = ISNULL(Y.QTY188,0), X.QTY189 = ISNULL(Y.QTY189,0)
                      ,X.QTY190 = ISNULL(Y.QTY190,0), QTY191 = ISNULL(Y.QTY191,0), X.QTY192 = ISNULL(Y.QTY192,0), X.QTY193 = ISNULL(Y.QTY193,0), X.QTY194 = ISNULL(Y.QTY194,0), X.QTY195 = ISNULL(Y.QTY195,0), X.QTY196 = ISNULL(Y.QTY196,0)
                      ,X.QTY197 = ISNULL(Y.QTY197,0), QTY198 = ISNULL(Y.QTY198,0), X.QTY199 = ISNULL(Y.QTY199,0), X.QTY200 = ISNULL(Y.QTY200,0), X.QTY201 = ISNULL(Y.QTY201,0), X.QTY202 = ISNULL(Y.QTY202,0), X.QTY203 = ISNULL(Y.QTY203,0)
                      ,X.QTY204 = ISNULL(Y.QTY204,0), QTY205 = ISNULL(Y.QTY205,0), X.QTY206 = ISNULL(Y.QTY206,0), X.QTY207 = ISNULL(Y.QTY207,0), X.QTY208 = ISNULL(Y.QTY208,0), X.QTY209 = ISNULL(Y.QTY209,0), X.QTY210 = ISNULL(Y.QTY210,0)
                      ,X.QTY211 = ISNULL(Y.QTY211,0), QTY212 = ISNULL(Y.QTY212,0), X.QTY213 = ISNULL(Y.QTY213,0), X.QTY214 = ISNULL(Y.QTY214,0), X.QTY215 = ISNULL(Y.QTY215,0), X.QTY216 = ISNULL(Y.QTY216,0), X.QTY217 = ISNULL(Y.QTY217,0)
                      ,X.QTY218 = ISNULL(Y.QTY218,0), QTY219 = ISNULL(Y.QTY219,0), X.QTY220 = ISNULL(Y.QTY220,0), X.QTY221 = ISNULL(Y.QTY221,0), X.QTY222 = ISNULL(Y.QTY222,0), X.QTY223 = ISNULL(Y.QTY223,0), X.QTY224 = ISNULL(Y.QTY224,0)
                      ,X.QTY225 = ISNULL(Y.QTY225,0), QTY226 = ISNULL(Y.QTY226,0), X.QTY227 = ISNULL(Y.QTY227,0), X.QTY228 = ISNULL(Y.QTY228,0), X.QTY229 = ISNULL(Y.QTY229,0), X.QTY230 = ISNULL(Y.QTY230,0), X.QTY231 = ISNULL(Y.QTY231,0)
                      ,X.QTY232 = ISNULL(Y.QTY232,0), QTY233 = ISNULL(Y.QTY233,0), X.QTY234 = ISNULL(Y.QTY234,0), X.QTY235 = ISNULL(Y.QTY235,0), X.QTY236 = ISNULL(Y.QTY236,0), X.QTY237 = ISNULL(Y.QTY237,0), X.QTY238 = ISNULL(Y.QTY238,0)
                      ,X.QTY239 = ISNULL(Y.QTY239,0), QTY240 = ISNULL(Y.QTY240,0), X.QTY241 = ISNULL(Y.QTY241,0), X.QTY242 = ISNULL(Y.QTY242,0), X.QTY243 = ISNULL(Y.QTY243,0), X.QTY244 = ISNULL(Y.QTY244,0), X.QTY245 = ISNULL(Y.QTY245,0)
                      ,X.QTY246 = ISNULL(Y.QTY246,0), QTY247 = ISNULL(Y.QTY247,0), X.QTY248 = ISNULL(Y.QTY248,0), X.QTY249 = ISNULL(Y.QTY249,0), X.QTY250 = ISNULL(Y.QTY250,0), X.QTY251 = ISNULL(Y.QTY251,0), X.QTY252 = ISNULL(Y.QTY252,0)
                      ,X.QTY253 = ISNULL(Y.QTY253,0), QTY254 = ISNULL(Y.QTY254,0), X.QTY255 = ISNULL(Y.QTY255,0), X.QTY256 = ISNULL(Y.QTY256,0), X.QTY257 = ISNULL(Y.QTY257,0), X.QTY258 = ISNULL(Y.QTY258,0), X.QTY259 = ISNULL(Y.QTY259,0)
                      ,X.QTY260 = ISNULL(Y.QTY260,0), QTY261 = ISNULL(Y.QTY261,0), X.QTY262 = ISNULL(Y.QTY262,0), X.QTY263 = ISNULL(Y.QTY263,0), X.QTY264 = ISNULL(Y.QTY264,0), X.QTY265 = ISNULL(Y.QTY265,0), X.QTY266 = ISNULL(Y.QTY266,0)
                      ,X.QTY267 = ISNULL(Y.QTY267,0), QTY268 = ISNULL(Y.QTY268,0), X.QTY269 = ISNULL(Y.QTY269,0), X.QTY270 = ISNULL(Y.QTY270,0), X.QTY271 = ISNULL(Y.QTY271,0), X.QTY272 = ISNULL(Y.QTY272,0), X.QTY273 = ISNULL(Y.QTY273,0)
                      ,X.QTY274 = ISNULL(Y.QTY274,0), QTY275 = ISNULL(Y.QTY275,0), X.QTY276 = ISNULL(Y.QTY276,0), X.QTY277 = ISNULL(Y.QTY277,0), X.QTY278 = ISNULL(Y.QTY278,0), X.QTY279 = ISNULL(Y.QTY279,0), X.QTY280 = ISNULL(Y.QTY280,0)
                      ,X.QTY281 = ISNULL(Y.QTY281,0), QTY282 = ISNULL(Y.QTY282,0), X.QTY283 = ISNULL(Y.QTY283,0), X.QTY284 = ISNULL(Y.QTY284,0), X.QTY285 = ISNULL(Y.QTY285,0), X.QTY286 = ISNULL(Y.QTY286,0), X.QTY287 = ISNULL(Y.QTY287,0)
                      ,X.QTY288 = ISNULL(Y.QTY288,0), QTY289 = ISNULL(Y.QTY289,0), X.QTY290 = ISNULL(Y.QTY290,0), X.QTY291 = ISNULL(Y.QTY291,0), X.QTY292 = ISNULL(Y.QTY292,0), X.QTY293 = ISNULL(Y.QTY293,0), X.QTY294 = ISNULL(Y.QTY294,0)
                      ,X.QTY295 = ISNULL(Y.QTY295,0), QTY296 = ISNULL(Y.QTY296,0), X.QTY297 = ISNULL(Y.QTY297,0), X.QTY298 = ISNULL(Y.QTY298,0), X.QTY299 = ISNULL(Y.QTY299,0), X.QTY300 = ISNULL(Y.QTY300,0), X.QTY301 = ISNULL(Y.QTY301,0)
                      ,X.QTY302 = ISNULL(Y.QTY302,0), QTY303 = ISNULL(Y.QTY303,0), X.QTY304 = ISNULL(Y.QTY304,0), X.QTY305 = ISNULL(Y.QTY305,0), X.QTY306 = ISNULL(Y.QTY306,0), X.QTY307 = ISNULL(Y.QTY307,0), X.QTY308 = ISNULL(Y.QTY308,0)
                      ,X.QTY309 = ISNULL(Y.QTY309,0), QTY310 = ISNULL(Y.QTY310,0), X.QTY311 = ISNULL(Y.QTY311,0), X.QTY312 = ISNULL(Y.QTY312,0), X.QTY313 = ISNULL(Y.QTY313,0), X.QTY314 = ISNULL(Y.QTY314,0), X.QTY315 = ISNULL(Y.QTY315,0)
                      ,X.QTY316 = ISNULL(Y.QTY316,0), QTY317 = ISNULL(Y.QTY317,0), X.QTY318 = ISNULL(Y.QTY318,0), X.QTY319 = ISNULL(Y.QTY319,0), X.QTY320 = ISNULL(Y.QTY320,0), X.QTY321 = ISNULL(Y.QTY321,0), X.QTY322 = ISNULL(Y.QTY322,0)
                      ,X.QTY323 = ISNULL(Y.QTY323,0), QTY324 = ISNULL(Y.QTY324,0), X.QTY325 = ISNULL(Y.QTY325,0), X.QTY326 = ISNULL(Y.QTY326,0), X.QTY327 = ISNULL(Y.QTY327,0), X.QTY328 = ISNULL(Y.QTY328,0), X.QTY329 = ISNULL(Y.QTY329,0)
                      ,X.QTY330 = ISNULL(Y.QTY330,0), QTY331 = ISNULL(Y.QTY331,0), X.QTY332 = ISNULL(Y.QTY332,0), X.QTY333 = ISNULL(Y.QTY333,0), X.QTY334 = ISNULL(Y.QTY334,0), X.QTY335 = ISNULL(Y.QTY335,0), X.QTY336 = ISNULL(Y.QTY336,0)
                      ,X.QTY337 = ISNULL(Y.QTY337,0), QTY338 = ISNULL(Y.QTY338,0), X.QTY339 = ISNULL(Y.QTY339,0), X.QTY340 = ISNULL(Y.QTY340,0), X.QTY341 = ISNULL(Y.QTY341,0), X.QTY342 = ISNULL(Y.QTY342,0), X.QTY343 = ISNULL(Y.QTY343,0)
                      ,X.QTY344 = ISNULL(Y.QTY344,0), QTY345 = ISNULL(Y.QTY345,0), X.QTY346 = ISNULL(Y.QTY346,0), X.QTY347 = ISNULL(Y.QTY347,0), X.QTY348 = ISNULL(Y.QTY348,0), X.QTY349 = ISNULL(Y.QTY349,0), X.QTY350 = ISNULL(Y.QTY350,0)
                      ,X.QTY351 = ISNULL(Y.QTY351,0), QTY352 = ISNULL(Y.QTY352,0), X.QTY353 = ISNULL(Y.QTY353,0), X.QTY354 = ISNULL(Y.QTY354,0), X.QTY355 = ISNULL(Y.QTY355,0), X.QTY356 = ISNULL(Y.QTY356,0), X.QTY357 = ISNULL(Y.QTY357,0)
                      ,X.QTY358 = ISNULL(Y.QTY358,0), QTY359 = ISNULL(Y.QTY359,0), X.QTY360 = ISNULL(Y.QTY360,0), X.QTY361 = ISNULL(Y.QTY361,0), X.QTY362 = ISNULL(Y.QTY362,0), X.QTY363 = ISNULL(Y.QTY363,0), X.QTY364 = ISNULL(Y.QTY364,0)
                    FROM #SCP_XLS_PSI_GLOBAL_ESS X  WITH (NOLOCK)
                    INNER JOIN #PROD_TACT_TIME_PIVOT Y  WITH (NOLOCK)
                      ON 0 = 0
                     AND X.ATTRIBUTE9    = Y.OPERATION_ID 
					 AND X.FROM_SITE     = Y.SCM_SITE_ID 
					 AND X.PROD_LINE     = Y.LINE_ID 
					 AND X.ITEM_ID       = Y.ITEM_ID
                   WHERE X.MEASURE       IN ('PACK_TACT_TIME', 'CELL_TACT_TIME')
				   ;

           

            -------------------------------------------------------------------------------------------------------------         
            --  MEASURE 추가 : ITEM_ID별 (MKT_FCST_CELL_TOTAL)  ,  (SHIP_REQ_CELL_TOTAL)
            -------------------------------------------------------------------------------------------------------------           
               INSERT INTO #SCP_XLS_PSI_GLOBAL_ESS                      
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
                      , (CASE WHEN M.COLUMN_NAME = 'MKT_FCST_CELL_TOTAL' THEN 'MKT_FCST_CELL_TOTAL' 
                              WHEN M.COLUMN_NAME = 'SHIP_REQ_CELL_TOTAL' THEN 'SHIP_REQ_CELL_TOTAL'
                                ELSE 'DIO' END) AS ATTRIBUTE1
                      ,X.ATTRIBUTE2
                      ,X.ATTRIBUTE3
                      ,X.ATTRIBUTE4
                      ,X.ATTRIBUTE5
                      ,X.ATTRIBUTE6
                      ,X.ATTRIBUTE7
                      ,X.ATTRIBUTE8
                      ,NULL AS ATTRIBUTE9
                      ,X.ATTRIBUTE10
                      FROM #SCP_XLS_PSI_GLOBAL_ESS X WITH (NOLOCK) 
                      CROSS APPLY #MEASURE M  WITH (NOLOCK)
                       WHERE 1=1          
                        AND M.GUBUN       = 'CELL_ITEM_ID'
                        AND M.COLUMN_NAME IN ( 'MKT_FCST_CELL_TOTAL','SHIP_REQ_CELL_TOTAL')
                        AND X.OPERATION_GROUP = 'A'



            -------------------------------------------------------------------------------------------------------------         
            --  DIO 계산용 MEASURE 추가(MKT_FCST_TOTAL,ALLOCATION_TOTAL,EOH_TOTAL,MKT_FCST_DIO,ALLOCATION_DIO)
            -------------------------------------------------------------------------------------------------------------           
               INSERT INTO #SCP_XLS_PSI_GLOBAL_ESS                    
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
                      , (CASE WHEN M.COLUMN_NAME = 'MKT_FCST_CELL_TOTAL' THEN 'MKT_FCST_CELL_TOTAL' 
                              WHEN M.COLUMN_NAME = 'SHIP_REQ_CELL_TOTAL' THEN 'SHIP_REQ_CELL_TOTAL'
                                ELSE 'DIO' END) AS ATTRIBUTE1
                      ,X.ATTRIBUTE2
                      ,X.ATTRIBUTE3
                      ,X.ATTRIBUTE4
                      ,X.ATTRIBUTE5
                      ,X.ATTRIBUTE6
                      ,X.ATTRIBUTE7
                      ,X.ATTRIBUTE8
                      ,NULL AS ATTRIBUTE9
                      ,X.ATTRIBUTE10
                      FROM #SCP_XLS_PSI_GLOBAL_ESS X WITH (NOLOCK) 
                      CROSS APPLY #MEASURE M  WITH (NOLOCK)
                       WHERE 1=1          
                        AND M.GUBUN       = 'CELL_ITEM_ID'
                        AND M.COLUMN_NAME NOT IN ('MKT_FCST_CELL_TOTAL','SHIP_REQ_CELL_TOTAL')
            
            
            -------------------------------------------------------------------------------------------------------------         
            --  CELL_WORKING_TIME 생성
            -------------------------------------------------------------------------------------------------------------           

             INSERT INTO #SCP_XLS_PSI_GLOBAL_ESS                      
                      SELECT DISTINCT X.DIVISION_ID
                      ,X.PLAN_START_YYYYMMDD
                      ,X.PLAN_TYPE
                      ,X.SEQ
                      ,X.OPERATION_GROUP
                      ,X.OPERATION_GROUP_NAME
                      ,X.CELL_ITEM_ID
                      ,X.ITEM_ID
                      ,X.NICK_NAME
                      ,X.CELL_QTY_PACK
                      ,X.TO_SITE
                      ,X.TO_SITE_DESCRIPTION
                      ,X.PROJECT_CODE
                      ,X.FROM_BOH_QTY
                      ,X.TO_BOH_QTY
                      ,X.INCOTERMS
                      ,X.FROM_SITE
                      ,X.FROM_SITE_DESCRIPTION
                      ,X.TRANSPORT_MODE
                      ,X.PROD_LINE
                      ,X.LT_DAY
                      ,X.BOD_ID
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
                      FROM #SCP_XLS_PSI_GLOBAL_ESS X WITH (NOLOCK) 
                      CROSS APPLY #MEASURE M  WITH (NOLOCK)
                       WHERE 1=1          
                        AND X.MEASURE IN ( 'CELL_PROD')
                        AND M.COLUMN_NAME IN ( 'CELL_WORKING_TIME')
                        AND X.OPERATION_GROUP = 'A'
			
            -------------------------------------------------------------------------------------------------------------         
            -- WORKING TIME 정보 반영
            -------------------------------------------------------------------------------------------------------------
              IF OBJECT_ID('tempdb..#WORKING_TIME') IS NOT NULL	
	                    DROP TABLE #WORKING_TIME


                      SELECT 
                          XX.DIVISION_ID, XX.OPERATION_GROUP,XX.SCM_SITE_ID, XX.PROD_LINE, XX.OPERATION_ID
                          
                          ,[QTY001], [QTY002], [QTY003], [QTY004], [QTY005],[QTY006], [QTY007], [QTY008], [QTY009], [QTY010]
                          ,[QTY011], [QTY012], [QTY013], [QTY014], [QTY015],[QTY016], [QTY017], [QTY018], [QTY019], [QTY020]
                          ,[QTY021], [QTY022], [QTY023], [QTY024], [QTY025],[QTY026], [QTY027], [QTY028], [QTY029], [QTY030]
                          ,[QTY031], [QTY032], [QTY033], [QTY034], [QTY035],[QTY036], [QTY037], [QTY038], [QTY039], [QTY040]
                          ,[QTY041], [QTY042], [QTY043], [QTY044], [QTY045],[QTY046], [QTY047], [QTY048], [QTY049], [QTY050]
                          ,[QTY051], [QTY052], [QTY053], [QTY054], [QTY055],[QTY056], [QTY057], [QTY058], [QTY059], [QTY060]
                          ,[QTY061], [QTY062], [QTY063], [QTY064], [QTY065],[QTY066], [QTY067], [QTY068], [QTY069], [QTY070]
                          ,[QTY071], [QTY072], [QTY073], [QTY074], [QTY075],[QTY076], [QTY077], [QTY078], [QTY079], [QTY080]
                          ,[QTY081], [QTY082], [QTY083], [QTY084], [QTY085],[QTY086], [QTY087], [QTY088], [QTY089], [QTY090]
                          ,[QTY091], [QTY092], [QTY093], [QTY094], [QTY095],[QTY096], [QTY097], [QTY098], [QTY099], [QTY100]

                          ,[QTY101], [QTY102], [QTY103], [QTY104], [QTY105],[QTY106], [QTY107], [QTY108], [QTY109], [QTY110]
                          ,[QTY111], [QTY112], [QTY113], [QTY114], [QTY115],[QTY116], [QTY117], [QTY118], [QTY119], [QTY120]
                          ,[QTY121], [QTY122], [QTY123], [QTY124], [QTY125],[QTY126], [QTY127], [QTY128], [QTY129], [QTY130]
                          ,[QTY131], [QTY132], [QTY133], [QTY134], [QTY135],[QTY136], [QTY137], [QTY138], [QTY139], [QTY140]
                          ,[QTY141], [QTY142], [QTY143], [QTY144], [QTY145],[QTY146], [QTY147], [QTY148], [QTY149], [QTY150]
                          ,[QTY151], [QTY152], [QTY153], [QTY154], [QTY155],[QTY156], [QTY157], [QTY158], [QTY159], [QTY160]
                          ,[QTY161], [QTY162], [QTY163], [QTY164], [QTY165],[QTY166], [QTY167], [QTY168], [QTY169], [QTY170]
                          ,[QTY171], [QTY172], [QTY173], [QTY174], [QTY175],[QTY176], [QTY177], [QTY178], [QTY179], [QTY180]
                          ,[QTY181], [QTY182], [QTY183], [QTY184], [QTY185],[QTY186], [QTY187], [QTY188], [QTY189], [QTY190]
                          ,[QTY191], [QTY192], [QTY193], [QTY194], [QTY195],[QTY196], [QTY197], [QTY198], [QTY199], [QTY200]

                          ,[QTY201], [QTY202], [QTY203], [QTY204], [QTY205],[QTY206], [QTY207], [QTY208], [QTY209], [QTY210]
                          ,[QTY211], [QTY212], [QTY213], [QTY214], [QTY215],[QTY216], [QTY217], [QTY218], [QTY219], [QTY220]
                          ,[QTY221], [QTY222], [QTY223], [QTY224], [QTY225],[QTY226], [QTY227], [QTY228], [QTY229], [QTY230]
                          ,[QTY231], [QTY232], [QTY233], [QTY234], [QTY235],[QTY236], [QTY237], [QTY238], [QTY239], [QTY240]
                          ,[QTY241], [QTY242], [QTY243], [QTY244], [QTY245],[QTY246], [QTY247], [QTY248], [QTY249], [QTY250]
                          ,[QTY251], [QTY252], [QTY253], [QTY254], [QTY255],[QTY256], [QTY257], [QTY258], [QTY259], [QTY260]
                          ,[QTY261], [QTY262], [QTY263], [QTY264], [QTY265],[QTY266], [QTY267], [QTY268], [QTY269], [QTY270]
                          ,[QTY271], [QTY272], [QTY273], [QTY274], [QTY275],[QTY276], [QTY277], [QTY278], [QTY279], [QTY280]
                          ,[QTY281], [QTY282], [QTY283], [QTY284], [QTY285],[QTY286], [QTY287], [QTY288], [QTY289], [QTY290]
                          ,[QTY291], [QTY292], [QTY293], [QTY294], [QTY295],[QTY296], [QTY297], [QTY298], [QTY299], [QTY300]

                          ,[QTY301], [QTY302], [QTY303], [QTY304], [QTY305],[QTY306], [QTY307], [QTY308], [QTY309], [QTY310]
                          ,[QTY311], [QTY312], [QTY313], [QTY314], [QTY315],[QTY316], [QTY317], [QTY318], [QTY319], [QTY320]
                          ,[QTY321], [QTY322], [QTY323], [QTY324], [QTY325],[QTY326], [QTY327], [QTY328], [QTY329], [QTY330]
                          ,[QTY331], [QTY332], [QTY333], [QTY334], [QTY335],[QTY336], [QTY337], [QTY338], [QTY339], [QTY340]
                          ,[QTY341], [QTY342], [QTY343], [QTY344], [QTY345],[QTY346], [QTY347], [QTY348], [QTY349], [QTY350]
                          ,[QTY351], [QTY352], [QTY353], [QTY354], [QTY355],[QTY356], [QTY357], [QTY358], [QTY359], [QTY360]
                          ,[QTY361], [QTY362], [QTY363], [QTY364]
                  INTO #WORKING_TIME
                  FROM
                    (
                                  SELECT  X.DIVISION_ID
                                        , X.OPERATION_GROUP
                                        , Z.SCM_SITE_ID
                                        , X.PROD_LINE
                                      --, Y.YYYYMMDD
                                        , X.YYYYMMDD_COLUMN
                                        --, Z.LINE_ID
                                        --, Z.ITEM_ID
                                        , Z.OPERATION_ID
                                        , Z.WORKING_TIME
                                  FROM
                                    (
                                    SELECT * 
                                     FROM #SCP_XLS_PSI_GLOBAL_ESS WITH (NOLOCK) 
                                     WHERE 0 = 0
                                       AND MEASURE IN ('PACK_WORKING_TIME','CELL_WORKING_TIME')
                                     ) AS SourceTable  
                                  UNPIVOT 
                                      (
                                       QTY FOR  YYYYMMDD_COLUMN IN (
                                                             [QTY001], [QTY002], [QTY003], [QTY004], [QTY005],[QTY006], [QTY007], [QTY008], [QTY009], [QTY010]
                                                            ,[QTY011], [QTY012], [QTY013], [QTY014], [QTY015],[QTY016], [QTY017], [QTY018], [QTY019], [QTY020]
                                                            ,[QTY021], [QTY022], [QTY023], [QTY024], [QTY025],[QTY026], [QTY027], [QTY028], [QTY029], [QTY030]
                                                            ,[QTY031], [QTY032], [QTY033], [QTY034], [QTY035],[QTY036], [QTY037], [QTY038], [QTY039], [QTY040]
                                                            ,[QTY041], [QTY042], [QTY043], [QTY044], [QTY045],[QTY046], [QTY047], [QTY048], [QTY049], [QTY050]
                                                            ,[QTY051], [QTY052], [QTY053], [QTY054], [QTY055],[QTY056], [QTY057], [QTY058], [QTY059], [QTY060]
                                                            ,[QTY061], [QTY062], [QTY063], [QTY064], [QTY065],[QTY066], [QTY067], [QTY068], [QTY069], [QTY070]
                                                            ,[QTY071], [QTY072], [QTY073], [QTY074], [QTY075],[QTY076], [QTY077], [QTY078], [QTY079], [QTY080]
                                                            ,[QTY081], [QTY082], [QTY083], [QTY084], [QTY085],[QTY086], [QTY087], [QTY088], [QTY089], [QTY090]
                                                            ,[QTY091], [QTY092], [QTY093], [QTY094], [QTY095],[QTY096], [QTY097], [QTY098], [QTY099], [QTY100]

                                                            ,[QTY101], [QTY102], [QTY103], [QTY104], [QTY105],[QTY106], [QTY107], [QTY108], [QTY109], [QTY110]
                                                            ,[QTY111], [QTY112], [QTY113], [QTY114], [QTY115],[QTY116], [QTY117], [QTY118], [QTY119], [QTY120]
                                                            ,[QTY121], [QTY122], [QTY123], [QTY124], [QTY125],[QTY126], [QTY127], [QTY128], [QTY129], [QTY130]
                                                            ,[QTY131], [QTY132], [QTY133], [QTY134], [QTY135],[QTY136], [QTY137], [QTY138], [QTY139], [QTY140]
                                                            ,[QTY141], [QTY142], [QTY143], [QTY144], [QTY145],[QTY146], [QTY147], [QTY148], [QTY149], [QTY150]
                                                            ,[QTY151], [QTY152], [QTY153], [QTY154], [QTY155],[QTY156], [QTY157], [QTY158], [QTY159], [QTY160]
                                                            ,[QTY161], [QTY162], [QTY163], [QTY164], [QTY165],[QTY166], [QTY167], [QTY168], [QTY169], [QTY170]
                                                            ,[QTY171], [QTY172], [QTY173], [QTY174], [QTY175],[QTY176], [QTY177], [QTY178], [QTY179], [QTY180]
                                                            ,[QTY181], [QTY182], [QTY183], [QTY184], [QTY185],[QTY186], [QTY187], [QTY188], [QTY189], [QTY190]
                                                            ,[QTY191], [QTY192], [QTY193], [QTY194], [QTY195],[QTY196], [QTY197], [QTY198], [QTY199], [QTY200]

                                                            ,[QTY201], [QTY202], [QTY203], [QTY204], [QTY205],[QTY206], [QTY207], [QTY208], [QTY209], [QTY210]
                                                            ,[QTY211], [QTY212], [QTY213], [QTY214], [QTY215],[QTY216], [QTY217], [QTY218], [QTY219], [QTY220]
                                                            ,[QTY221], [QTY222], [QTY223], [QTY224], [QTY225],[QTY226], [QTY227], [QTY228], [QTY229], [QTY230]
                                                            ,[QTY231], [QTY232], [QTY233], [QTY234], [QTY235],[QTY236], [QTY237], [QTY238], [QTY239], [QTY240]
                                                            ,[QTY241], [QTY242], [QTY243], [QTY244], [QTY245],[QTY246], [QTY247], [QTY248], [QTY249], [QTY250]
                                                            ,[QTY251], [QTY252], [QTY253], [QTY254], [QTY255],[QTY256], [QTY257], [QTY258], [QTY259], [QTY260]
                                                            ,[QTY261], [QTY262], [QTY263], [QTY264], [QTY265],[QTY266], [QTY267], [QTY268], [QTY269], [QTY270]
                                                            ,[QTY271], [QTY272], [QTY273], [QTY274], [QTY275],[QTY276], [QTY277], [QTY278], [QTY279], [QTY280]
                                                            ,[QTY281], [QTY282], [QTY283], [QTY284], [QTY285],[QTY286], [QTY287], [QTY288], [QTY289], [QTY290]
                                                            ,[QTY291], [QTY292], [QTY293], [QTY294], [QTY295],[QTY296], [QTY297], [QTY298], [QTY299], [QTY300]

                                                            ,[QTY301], [QTY302], [QTY303], [QTY304], [QTY305],[QTY306], [QTY307], [QTY308], [QTY309], [QTY310]
                                                            ,[QTY311], [QTY312], [QTY313], [QTY314], [QTY315],[QTY316], [QTY317], [QTY318], [QTY319], [QTY320]
                                                            ,[QTY321], [QTY322], [QTY323], [QTY324], [QTY325],[QTY326], [QTY327], [QTY328], [QTY329], [QTY330]
                                                            ,[QTY331], [QTY332], [QTY333], [QTY334], [QTY335],[QTY336], [QTY337], [QTY338], [QTY339], [QTY340]
                                                            ,[QTY341], [QTY342], [QTY343], [QTY344], [QTY345],[QTY346], [QTY347], [QTY348], [QTY349], [QTY350]
                                                            ,[QTY351], [QTY352], [QTY353], [QTY354], [QTY355],[QTY356], [QTY357], [QTY358], [QTY359], [QTY360]
                                                            ,[QTY361], [QTY362], [QTY363], [QTY364]

                                                            ) 
                                  ) AS X
                                  INNER JOIN (SELECT A.BASIS_YYYYMMDD AS YYYYMMDD    
                                                    ,'QTY' + REPLICATE('0', 3 - LEN(ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD) )) + CONVERT(NVARCHAR,ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD)) AS YYYYMMDD_COLUMN
                                                FROM DBO.SCM_SYS_CALENDAR_M A  WITH(NOLOCK)	     
                                                WHERE A.BASIS_YYYYMMDD     >= @p_create_from_yyyymmdd
                                                  AND A.BASIS_YYYYMMDD     <=  @p_create_to_yyyymmdd
                                              ) Y
                                  ON X.YYYYMMDD_COLUMN = Y.YYYYMMDD_COLUMN
                                  INNER JOIN #LINE_WORKINGTIME_BY_LOSS Z WITH (NOLOCK)
                                  ON Y.YYYYMMDD = Z.YYYYMMDD
                                  AND X.PROD_LINE = Z.LINE_ID
                                  AND Z.DIVISION_ID = X.DIVISION_ID
                                  AND X.ATTRIBUTE9  = Z.OPERATION_ID 
	                                AND X.FROM_SITE   = Z.SCM_SITE_ID 
					                        AND Z.YYYYMMDD    >=  @p_create_from_yyyymmdd
                                  AND Z.YYYYMMDD    <=   @p_create_to_yyyymmdd
                     ) AS SourceTable  
                  PIVOT 
                      (
                       MIN(WORKING_TIME)
                       FOR  YYYYMMDD_COLUMN IN ( [QTY001], [QTY002], [QTY003], [QTY004], [QTY005],[QTY006], [QTY007], [QTY008], [QTY009], [QTY010]
                                                ,[QTY011], [QTY012], [QTY013], [QTY014], [QTY015],[QTY016], [QTY017], [QTY018], [QTY019], [QTY020]
                                                ,[QTY021], [QTY022], [QTY023], [QTY024], [QTY025],[QTY026], [QTY027], [QTY028], [QTY029], [QTY030]
                                                ,[QTY031], [QTY032], [QTY033], [QTY034], [QTY035],[QTY036], [QTY037], [QTY038], [QTY039], [QTY040]
                                                ,[QTY041], [QTY042], [QTY043], [QTY044], [QTY045],[QTY046], [QTY047], [QTY048], [QTY049], [QTY050]
                                                ,[QTY051], [QTY052], [QTY053], [QTY054], [QTY055],[QTY056], [QTY057], [QTY058], [QTY059], [QTY060]
                                                ,[QTY061], [QTY062], [QTY063], [QTY064], [QTY065],[QTY066], [QTY067], [QTY068], [QTY069], [QTY070]
                                                ,[QTY071], [QTY072], [QTY073], [QTY074], [QTY075],[QTY076], [QTY077], [QTY078], [QTY079], [QTY080]
                                                ,[QTY081], [QTY082], [QTY083], [QTY084], [QTY085],[QTY086], [QTY087], [QTY088], [QTY089], [QTY090]
                                                ,[QTY091], [QTY092], [QTY093], [QTY094], [QTY095],[QTY096], [QTY097], [QTY098], [QTY099], [QTY100]

                                                ,[QTY101], [QTY102], [QTY103], [QTY104], [QTY105],[QTY106], [QTY107], [QTY108], [QTY109], [QTY110]
                                                ,[QTY111], [QTY112], [QTY113], [QTY114], [QTY115],[QTY116], [QTY117], [QTY118], [QTY119], [QTY120]
                                                ,[QTY121], [QTY122], [QTY123], [QTY124], [QTY125],[QTY126], [QTY127], [QTY128], [QTY129], [QTY130]
                                                ,[QTY131], [QTY132], [QTY133], [QTY134], [QTY135],[QTY136], [QTY137], [QTY138], [QTY139], [QTY140]
                                                ,[QTY141], [QTY142], [QTY143], [QTY144], [QTY145],[QTY146], [QTY147], [QTY148], [QTY149], [QTY150]
                                                ,[QTY151], [QTY152], [QTY153], [QTY154], [QTY155],[QTY156], [QTY157], [QTY158], [QTY159], [QTY160]
                                                ,[QTY161], [QTY162], [QTY163], [QTY164], [QTY165],[QTY166], [QTY167], [QTY168], [QTY169], [QTY170]
                                                ,[QTY171], [QTY172], [QTY173], [QTY174], [QTY175],[QTY176], [QTY177], [QTY178], [QTY179], [QTY180]
                                                ,[QTY181], [QTY182], [QTY183], [QTY184], [QTY185],[QTY186], [QTY187], [QTY188], [QTY189], [QTY190]
                                                ,[QTY191], [QTY192], [QTY193], [QTY194], [QTY195],[QTY196], [QTY197], [QTY198], [QTY199], [QTY200]

                                                ,[QTY201], [QTY202], [QTY203], [QTY204], [QTY205],[QTY206], [QTY207], [QTY208], [QTY209], [QTY210]
                                                ,[QTY211], [QTY212], [QTY213], [QTY214], [QTY215],[QTY216], [QTY217], [QTY218], [QTY219], [QTY220]
                                                ,[QTY221], [QTY222], [QTY223], [QTY224], [QTY225],[QTY226], [QTY227], [QTY228], [QTY229], [QTY230]
                                                ,[QTY231], [QTY232], [QTY233], [QTY234], [QTY235],[QTY236], [QTY237], [QTY238], [QTY239], [QTY240]
                                                ,[QTY241], [QTY242], [QTY243], [QTY244], [QTY245],[QTY246], [QTY247], [QTY248], [QTY249], [QTY250]
                                                ,[QTY251], [QTY252], [QTY253], [QTY254], [QTY255],[QTY256], [QTY257], [QTY258], [QTY259], [QTY260]
                                                ,[QTY261], [QTY262], [QTY263], [QTY264], [QTY265],[QTY266], [QTY267], [QTY268], [QTY269], [QTY270]
                                                ,[QTY271], [QTY272], [QTY273], [QTY274], [QTY275],[QTY276], [QTY277], [QTY278], [QTY279], [QTY280]
                                                ,[QTY281], [QTY282], [QTY283], [QTY284], [QTY285],[QTY286], [QTY287], [QTY288], [QTY289], [QTY290]
                                                ,[QTY291], [QTY292], [QTY293], [QTY294], [QTY295],[QTY296], [QTY297], [QTY298], [QTY299], [QTY300]

                                                ,[QTY301], [QTY302], [QTY303], [QTY304], [QTY305],[QTY306], [QTY307], [QTY308], [QTY309], [QTY310]
                                                ,[QTY311], [QTY312], [QTY313], [QTY314], [QTY315],[QTY316], [QTY317], [QTY318], [QTY319], [QTY320]
                                                ,[QTY321], [QTY322], [QTY323], [QTY324], [QTY325],[QTY326], [QTY327], [QTY328], [QTY329], [QTY330]
                                                ,[QTY331], [QTY332], [QTY333], [QTY334], [QTY335],[QTY336], [QTY337], [QTY338], [QTY339], [QTY340]
                                                ,[QTY341], [QTY342], [QTY343], [QTY344], [QTY345],[QTY346], [QTY347], [QTY348], [QTY349], [QTY350]
                                                ,[QTY351], [QTY352], [QTY353], [QTY354], [QTY355],[QTY356], [QTY357], [QTY358], [QTY359], [QTY360]
                                                ,[QTY361], [QTY362], [QTY363], [QTY364]
                                            )  
                       ) XX


                    UPDATE X
                  SET  X.QTY001 = ISNULL(Y.QTY001,0), QTY002 = ISNULL(Y.QTY002,0), X.QTY003 = ISNULL(Y.QTY003,0), X.QTY004 = ISNULL(Y.QTY004,0), X.QTY005 = ISNULL(Y.QTY005,0), X.QTY006 = ISNULL(Y.QTY006,0), X.QTY007 = ISNULL(Y.QTY007,0)
                      ,X.QTY008 = ISNULL(Y.QTY008,0), QTY009 = ISNULL(Y.QTY009,0), X.QTY010 = ISNULL(Y.QTY010,0), X.QTY011 = ISNULL(Y.QTY011,0), X.QTY012 = ISNULL(Y.QTY012,0), X.QTY013 = ISNULL(Y.QTY013,0), X.QTY014 = ISNULL(Y.QTY014,0)
                      ,X.QTY015 = ISNULL(Y.QTY015,0), QTY016 = ISNULL(Y.QTY016,0), X.QTY017 = ISNULL(Y.QTY017,0), X.QTY018 = ISNULL(Y.QTY018,0), X.QTY019 = ISNULL(Y.QTY019,0), X.QTY020 = ISNULL(Y.QTY020,0), X.QTY021 = ISNULL(Y.QTY021,0)
                      ,X.QTY022 = ISNULL(Y.QTY022,0), QTY023 = ISNULL(Y.QTY023,0), X.QTY024 = ISNULL(Y.QTY024,0), X.QTY025 = ISNULL(Y.QTY025,0), X.QTY026 = ISNULL(Y.QTY026,0), X.QTY027 = ISNULL(Y.QTY027,0), X.QTY028 = ISNULL(Y.QTY028,0)
                      ,X.QTY029 = ISNULL(Y.QTY029,0), QTY030 = ISNULL(Y.QTY030,0), X.QTY031 = ISNULL(Y.QTY031,0), X.QTY032 = ISNULL(Y.QTY032,0), X.QTY033 = ISNULL(Y.QTY033,0), X.QTY034 = ISNULL(Y.QTY034,0), X.QTY035 = ISNULL(Y.QTY035,0)
                      ,X.QTY036 = ISNULL(Y.QTY036,0), QTY037 = ISNULL(Y.QTY037,0), X.QTY038 = ISNULL(Y.QTY038,0), X.QTY039 = ISNULL(Y.QTY039,0), X.QTY040 = ISNULL(Y.QTY040,0), X.QTY041 = ISNULL(Y.QTY041,0), X.QTY042 = ISNULL(Y.QTY042,0)
                      ,X.QTY043 = ISNULL(Y.QTY043,0), QTY044 = ISNULL(Y.QTY044,0), X.QTY045 = ISNULL(Y.QTY045,0), X.QTY046 = ISNULL(Y.QTY046,0), X.QTY047 = ISNULL(Y.QTY047,0), X.QTY048 = ISNULL(Y.QTY048,0), X.QTY049 = ISNULL(Y.QTY049,0)
                      ,X.QTY050 = ISNULL(Y.QTY050,0), QTY051 = ISNULL(Y.QTY051,0), X.QTY052 = ISNULL(Y.QTY052,0), X.QTY053 = ISNULL(Y.QTY053,0), X.QTY054 = ISNULL(Y.QTY054,0), X.QTY055 = ISNULL(Y.QTY055,0), X.QTY056 = ISNULL(Y.QTY056,0)
                      ,X.QTY057 = ISNULL(Y.QTY057,0), QTY058 = ISNULL(Y.QTY058,0), X.QTY059 = ISNULL(Y.QTY059,0), X.QTY060 = ISNULL(Y.QTY060,0), X.QTY061 = ISNULL(Y.QTY061,0), X.QTY062 = ISNULL(Y.QTY062,0), X.QTY063 = ISNULL(Y.QTY063,0)
                      ,X.QTY064 = ISNULL(Y.QTY064,0), QTY065 = ISNULL(Y.QTY065,0), X.QTY066 = ISNULL(Y.QTY066,0), X.QTY067 = ISNULL(Y.QTY067,0), X.QTY068 = ISNULL(Y.QTY068,0), X.QTY069 = ISNULL(Y.QTY069,0), X.QTY070 = ISNULL(Y.QTY070,0)
                      ,X.QTY071 = ISNULL(Y.QTY071,0), QTY072 = ISNULL(Y.QTY072,0), X.QTY073 = ISNULL(Y.QTY073,0), X.QTY074 = ISNULL(Y.QTY074,0), X.QTY075 = ISNULL(Y.QTY075,0), X.QTY076 = ISNULL(Y.QTY076,0), X.QTY077 = ISNULL(Y.QTY077,0)
                      ,X.QTY078 = ISNULL(Y.QTY078,0), QTY079 = ISNULL(Y.QTY079,0), X.QTY080 = ISNULL(Y.QTY080,0), X.QTY081 = ISNULL(Y.QTY081,0), X.QTY082 = ISNULL(Y.QTY082,0), X.QTY083 = ISNULL(Y.QTY083,0), X.QTY084 = ISNULL(Y.QTY084,0)
                      ,X.QTY085 = ISNULL(Y.QTY085,0), QTY086 = ISNULL(Y.QTY086,0), X.QTY087 = ISNULL(Y.QTY087,0), X.QTY088 = ISNULL(Y.QTY088,0), X.QTY089 = ISNULL(Y.QTY089,0), X.QTY090 = ISNULL(Y.QTY090,0), X.QTY091 = ISNULL(Y.QTY091,0)
                      ,X.QTY092 = ISNULL(Y.QTY092,0), QTY093 = ISNULL(Y.QTY093,0), X.QTY094 = ISNULL(Y.QTY094,0), X.QTY095 = ISNULL(Y.QTY095,0), X.QTY096 = ISNULL(Y.QTY096,0), X.QTY097 = ISNULL(Y.QTY097,0), X.QTY098 = ISNULL(Y.QTY098,0)
                      ,X.QTY099 = ISNULL(Y.QTY099,0), QTY100 = ISNULL(Y.QTY100,0), X.QTY101 = ISNULL(Y.QTY101,0), X.QTY102 = ISNULL(Y.QTY102,0), X.QTY103 = ISNULL(Y.QTY103,0), X.QTY104 = ISNULL(Y.QTY104,0), X.QTY105 = ISNULL(Y.QTY105,0)
                      ,X.QTY106 = ISNULL(Y.QTY106,0), QTY107 = ISNULL(Y.QTY107,0), X.QTY108 = ISNULL(Y.QTY108,0), X.QTY109 = ISNULL(Y.QTY109,0), X.QTY110 = ISNULL(Y.QTY110,0), X.QTY111 = ISNULL(Y.QTY111,0), X.QTY112 = ISNULL(Y.QTY112,0)
                      ,X.QTY113 = ISNULL(Y.QTY113,0), QTY114 = ISNULL(Y.QTY114,0), X.QTY115 = ISNULL(Y.QTY115,0), X.QTY116 = ISNULL(Y.QTY116,0), X.QTY117 = ISNULL(Y.QTY117,0), X.QTY118 = ISNULL(Y.QTY118,0), X.QTY119 = ISNULL(Y.QTY119,0)
                      ,X.QTY120 = ISNULL(Y.QTY120,0), QTY121 = ISNULL(Y.QTY121,0), X.QTY122 = ISNULL(Y.QTY122,0), X.QTY123 = ISNULL(Y.QTY123,0), X.QTY124 = ISNULL(Y.QTY124,0), X.QTY125 = ISNULL(Y.QTY125,0), X.QTY126 = ISNULL(Y.QTY126,0)
                      ,X.QTY127 = ISNULL(Y.QTY127,0), QTY128 = ISNULL(Y.QTY128,0), X.QTY129 = ISNULL(Y.QTY129,0), X.QTY130 = ISNULL(Y.QTY130,0), X.QTY131 = ISNULL(Y.QTY131,0), X.QTY132 = ISNULL(Y.QTY132,0), X.QTY133 = ISNULL(Y.QTY133,0)
                      ,X.QTY134 = ISNULL(Y.QTY134,0), QTY135 = ISNULL(Y.QTY135,0), X.QTY136 = ISNULL(Y.QTY136,0), X.QTY137 = ISNULL(Y.QTY137,0), X.QTY138 = ISNULL(Y.QTY138,0), X.QTY139 = ISNULL(Y.QTY139,0), X.QTY140 = ISNULL(Y.QTY140,0)
                      ,X.QTY141 = ISNULL(Y.QTY141,0), QTY142 = ISNULL(Y.QTY142,0), X.QTY143 = ISNULL(Y.QTY143,0), X.QTY144 = ISNULL(Y.QTY144,0), X.QTY145 = ISNULL(Y.QTY145,0), X.QTY146 = ISNULL(Y.QTY146,0), X.QTY147 = ISNULL(Y.QTY147,0)
                      ,X.QTY148 = ISNULL(Y.QTY148,0), QTY149 = ISNULL(Y.QTY149,0), X.QTY150 = ISNULL(Y.QTY150,0), X.QTY151 = ISNULL(Y.QTY151,0), X.QTY152 = ISNULL(Y.QTY152,0), X.QTY153 = ISNULL(Y.QTY153,0), X.QTY154 = ISNULL(Y.QTY154,0)
                      ,X.QTY155 = ISNULL(Y.QTY155,0), QTY156 = ISNULL(Y.QTY156,0), X.QTY157 = ISNULL(Y.QTY157,0), X.QTY158 = ISNULL(Y.QTY158,0), X.QTY159 = ISNULL(Y.QTY159,0), X.QTY160 = ISNULL(Y.QTY160,0), X.QTY161 = ISNULL(Y.QTY161,0)
                      ,X.QTY162 = ISNULL(Y.QTY162,0), QTY163 = ISNULL(Y.QTY163,0), X.QTY164 = ISNULL(Y.QTY164,0), X.QTY165 = ISNULL(Y.QTY165,0), X.QTY166 = ISNULL(Y.QTY166,0), X.QTY167 = ISNULL(Y.QTY167,0), X.QTY168 = ISNULL(Y.QTY168,0)
                      ,X.QTY169 = ISNULL(Y.QTY169,0), QTY170 = ISNULL(Y.QTY170,0), X.QTY171 = ISNULL(Y.QTY171,0), X.QTY172 = ISNULL(Y.QTY172,0), X.QTY173 = ISNULL(Y.QTY173,0), X.QTY174 = ISNULL(Y.QTY174,0), X.QTY175 = ISNULL(Y.QTY175,0)
                      ,X.QTY176 = ISNULL(Y.QTY176,0), QTY177 = ISNULL(Y.QTY177,0), X.QTY178 = ISNULL(Y.QTY178,0), X.QTY179 = ISNULL(Y.QTY179,0), X.QTY180 = ISNULL(Y.QTY180,0), X.QTY181 = ISNULL(Y.QTY181,0), X.QTY182 = ISNULL(Y.QTY182,0)
                      ,X.QTY183 = ISNULL(Y.QTY183,0), QTY184 = ISNULL(Y.QTY184,0), X.QTY185 = ISNULL(Y.QTY185,0), X.QTY186 = ISNULL(Y.QTY186,0), X.QTY187 = ISNULL(Y.QTY187,0), X.QTY188 = ISNULL(Y.QTY188,0), X.QTY189 = ISNULL(Y.QTY189,0)
                      ,X.QTY190 = ISNULL(Y.QTY190,0), QTY191 = ISNULL(Y.QTY191,0), X.QTY192 = ISNULL(Y.QTY192,0), X.QTY193 = ISNULL(Y.QTY193,0), X.QTY194 = ISNULL(Y.QTY194,0), X.QTY195 = ISNULL(Y.QTY195,0), X.QTY196 = ISNULL(Y.QTY196,0)
                      ,X.QTY197 = ISNULL(Y.QTY197,0), QTY198 = ISNULL(Y.QTY198,0), X.QTY199 = ISNULL(Y.QTY199,0), X.QTY200 = ISNULL(Y.QTY200,0), X.QTY201 = ISNULL(Y.QTY201,0), X.QTY202 = ISNULL(Y.QTY202,0), X.QTY203 = ISNULL(Y.QTY203,0)
                      ,X.QTY204 = ISNULL(Y.QTY204,0), QTY205 = ISNULL(Y.QTY205,0), X.QTY206 = ISNULL(Y.QTY206,0), X.QTY207 = ISNULL(Y.QTY207,0), X.QTY208 = ISNULL(Y.QTY208,0), X.QTY209 = ISNULL(Y.QTY209,0), X.QTY210 = ISNULL(Y.QTY210,0)
                      ,X.QTY211 = ISNULL(Y.QTY211,0), QTY212 = ISNULL(Y.QTY212,0), X.QTY213 = ISNULL(Y.QTY213,0), X.QTY214 = ISNULL(Y.QTY214,0), X.QTY215 = ISNULL(Y.QTY215,0), X.QTY216 = ISNULL(Y.QTY216,0), X.QTY217 = ISNULL(Y.QTY217,0)
                      ,X.QTY218 = ISNULL(Y.QTY218,0), QTY219 = ISNULL(Y.QTY219,0), X.QTY220 = ISNULL(Y.QTY220,0), X.QTY221 = ISNULL(Y.QTY221,0), X.QTY222 = ISNULL(Y.QTY222,0), X.QTY223 = ISNULL(Y.QTY223,0), X.QTY224 = ISNULL(Y.QTY224,0)
                      ,X.QTY225 = ISNULL(Y.QTY225,0), QTY226 = ISNULL(Y.QTY226,0), X.QTY227 = ISNULL(Y.QTY227,0), X.QTY228 = ISNULL(Y.QTY228,0), X.QTY229 = ISNULL(Y.QTY229,0), X.QTY230 = ISNULL(Y.QTY230,0), X.QTY231 = ISNULL(Y.QTY231,0)
                      ,X.QTY232 = ISNULL(Y.QTY232,0), QTY233 = ISNULL(Y.QTY233,0), X.QTY234 = ISNULL(Y.QTY234,0), X.QTY235 = ISNULL(Y.QTY235,0), X.QTY236 = ISNULL(Y.QTY236,0), X.QTY237 = ISNULL(Y.QTY237,0), X.QTY238 = ISNULL(Y.QTY238,0)
                      ,X.QTY239 = ISNULL(Y.QTY239,0), QTY240 = ISNULL(Y.QTY240,0), X.QTY241 = ISNULL(Y.QTY241,0), X.QTY242 = ISNULL(Y.QTY242,0), X.QTY243 = ISNULL(Y.QTY243,0), X.QTY244 = ISNULL(Y.QTY244,0), X.QTY245 = ISNULL(Y.QTY245,0)
                      ,X.QTY246 = ISNULL(Y.QTY246,0), QTY247 = ISNULL(Y.QTY247,0), X.QTY248 = ISNULL(Y.QTY248,0), X.QTY249 = ISNULL(Y.QTY249,0), X.QTY250 = ISNULL(Y.QTY250,0), X.QTY251 = ISNULL(Y.QTY251,0), X.QTY252 = ISNULL(Y.QTY252,0)
                      ,X.QTY253 = ISNULL(Y.QTY253,0), QTY254 = ISNULL(Y.QTY254,0), X.QTY255 = ISNULL(Y.QTY255,0), X.QTY256 = ISNULL(Y.QTY256,0), X.QTY257 = ISNULL(Y.QTY257,0), X.QTY258 = ISNULL(Y.QTY258,0), X.QTY259 = ISNULL(Y.QTY259,0)
                      ,X.QTY260 = ISNULL(Y.QTY260,0), QTY261 = ISNULL(Y.QTY261,0), X.QTY262 = ISNULL(Y.QTY262,0), X.QTY263 = ISNULL(Y.QTY263,0), X.QTY264 = ISNULL(Y.QTY264,0), X.QTY265 = ISNULL(Y.QTY265,0), X.QTY266 = ISNULL(Y.QTY266,0)
                      ,X.QTY267 = ISNULL(Y.QTY267,0), QTY268 = ISNULL(Y.QTY268,0), X.QTY269 = ISNULL(Y.QTY269,0), X.QTY270 = ISNULL(Y.QTY270,0), X.QTY271 = ISNULL(Y.QTY271,0), X.QTY272 = ISNULL(Y.QTY272,0), X.QTY273 = ISNULL(Y.QTY273,0)
                      ,X.QTY274 = ISNULL(Y.QTY274,0), QTY275 = ISNULL(Y.QTY275,0), X.QTY276 = ISNULL(Y.QTY276,0), X.QTY277 = ISNULL(Y.QTY277,0), X.QTY278 = ISNULL(Y.QTY278,0), X.QTY279 = ISNULL(Y.QTY279,0), X.QTY280 = ISNULL(Y.QTY280,0)
                      ,X.QTY281 = ISNULL(Y.QTY281,0), QTY282 = ISNULL(Y.QTY282,0), X.QTY283 = ISNULL(Y.QTY283,0), X.QTY284 = ISNULL(Y.QTY284,0), X.QTY285 = ISNULL(Y.QTY285,0), X.QTY286 = ISNULL(Y.QTY286,0), X.QTY287 = ISNULL(Y.QTY287,0)
                      ,X.QTY288 = ISNULL(Y.QTY288,0), QTY289 = ISNULL(Y.QTY289,0), X.QTY290 = ISNULL(Y.QTY290,0), X.QTY291 = ISNULL(Y.QTY291,0), X.QTY292 = ISNULL(Y.QTY292,0), X.QTY293 = ISNULL(Y.QTY293,0), X.QTY294 = ISNULL(Y.QTY294,0)
                      ,X.QTY295 = ISNULL(Y.QTY295,0), QTY296 = ISNULL(Y.QTY296,0), X.QTY297 = ISNULL(Y.QTY297,0), X.QTY298 = ISNULL(Y.QTY298,0), X.QTY299 = ISNULL(Y.QTY299,0), X.QTY300 = ISNULL(Y.QTY300,0), X.QTY301 = ISNULL(Y.QTY301,0)
                      ,X.QTY302 = ISNULL(Y.QTY302,0), QTY303 = ISNULL(Y.QTY303,0), X.QTY304 = ISNULL(Y.QTY304,0), X.QTY305 = ISNULL(Y.QTY305,0), X.QTY306 = ISNULL(Y.QTY306,0), X.QTY307 = ISNULL(Y.QTY307,0), X.QTY308 = ISNULL(Y.QTY308,0)
                      ,X.QTY309 = ISNULL(Y.QTY309,0), QTY310 = ISNULL(Y.QTY310,0), X.QTY311 = ISNULL(Y.QTY311,0), X.QTY312 = ISNULL(Y.QTY312,0), X.QTY313 = ISNULL(Y.QTY313,0), X.QTY314 = ISNULL(Y.QTY314,0), X.QTY315 = ISNULL(Y.QTY315,0)
                      ,X.QTY316 = ISNULL(Y.QTY316,0), QTY317 = ISNULL(Y.QTY317,0), X.QTY318 = ISNULL(Y.QTY318,0), X.QTY319 = ISNULL(Y.QTY319,0), X.QTY320 = ISNULL(Y.QTY320,0), X.QTY321 = ISNULL(Y.QTY321,0), X.QTY322 = ISNULL(Y.QTY322,0)
                      ,X.QTY323 = ISNULL(Y.QTY323,0), QTY324 = ISNULL(Y.QTY324,0), X.QTY325 = ISNULL(Y.QTY325,0), X.QTY326 = ISNULL(Y.QTY326,0), X.QTY327 = ISNULL(Y.QTY327,0), X.QTY328 = ISNULL(Y.QTY328,0), X.QTY329 = ISNULL(Y.QTY329,0)
                      ,X.QTY330 = ISNULL(Y.QTY330,0), QTY331 = ISNULL(Y.QTY331,0), X.QTY332 = ISNULL(Y.QTY332,0), X.QTY333 = ISNULL(Y.QTY333,0), X.QTY334 = ISNULL(Y.QTY334,0), X.QTY335 = ISNULL(Y.QTY335,0), X.QTY336 = ISNULL(Y.QTY336,0)
                      ,X.QTY337 = ISNULL(Y.QTY337,0), QTY338 = ISNULL(Y.QTY338,0), X.QTY339 = ISNULL(Y.QTY339,0), X.QTY340 = ISNULL(Y.QTY340,0), X.QTY341 = ISNULL(Y.QTY341,0), X.QTY342 = ISNULL(Y.QTY342,0), X.QTY343 = ISNULL(Y.QTY343,0)
                      ,X.QTY344 = ISNULL(Y.QTY344,0), QTY345 = ISNULL(Y.QTY345,0), X.QTY346 = ISNULL(Y.QTY346,0), X.QTY347 = ISNULL(Y.QTY347,0), X.QTY348 = ISNULL(Y.QTY348,0), X.QTY349 = ISNULL(Y.QTY349,0), X.QTY350 = ISNULL(Y.QTY350,0)
                      ,X.QTY351 = ISNULL(Y.QTY351,0), QTY352 = ISNULL(Y.QTY352,0), X.QTY353 = ISNULL(Y.QTY353,0), X.QTY354 = ISNULL(Y.QTY354,0), X.QTY355 = ISNULL(Y.QTY355,0), X.QTY356 = ISNULL(Y.QTY356,0), X.QTY357 = ISNULL(Y.QTY357,0)
                      ,X.QTY358 = ISNULL(Y.QTY358,0), QTY359 = ISNULL(Y.QTY359,0), X.QTY360 = ISNULL(Y.QTY360,0), X.QTY361 = ISNULL(Y.QTY361,0), X.QTY362 = ISNULL(Y.QTY362,0), X.QTY363 = ISNULL(Y.QTY363,0), X.QTY364 = ISNULL(Y.QTY364,0)
                    FROM #SCP_XLS_PSI_GLOBAL_ESS X  WITH (NOLOCK) 
                    INNER JOIN #WORKING_TIME Y WITH (NOLOCK)
                       ON  Y.DIVISION_ID       = X.DIVISION_ID
                      AND Y.OPERATION_GROUP   = X.OPERATION_GROUP
                      AND Y.SCM_SITE_ID       = X.FROM_SITE
                      AND Y.PROD_LINE         = X.PROD_LINE
                      AND Y.OPERATION_ID      = X.ATTRIBUTE9
                    WHERE X.MEASURE           IN ('PACK_WORKING_TIME','CELL_WORKING_TIME')

            -------------------------------------------------------------------------------------------------------------         
            --  보정
            -------------------------------------------------------------------------------------------------------------
              UPDATE X
                 SET X.LT_DAY = 0
                FROM #SCP_XLS_PSI_GLOBAL_ESS  X WITH (NOLOCK)
               WHERE TRANSPORT_MODE = '-'

        

		    -------------------------------------------------------------------------------------------------------------         
            --  SEMI_PACK_PROD_CELL 누락분 추가
            ------------------------------------------------------------------------------------------------------------- 
			
			----------------------------------------------------------------------------------------------------------         
            ----  SEMI_PACK_PROD_CELL 추가로직에   패커사의 팩조립계획 추가 반영(KSK, 20240907)
            ----------------------------------------------------------------------------------------------------------- 
			INSERT #SCP_XLS_PSI_GLOBAL_ESS
				( PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ
					, DIVISION_ID, XLS_KEY1, OPERATION_GROUP, OPERATION_GROUP_NAME
					,CELL_ITEM_ID, ITEM_ID, NICK_NAME, ATTRIBUTE9
					, TO_SITE, TO_SITE_DESCRIPTION,  FROM_SITE,  FROM_SITE_DESCRIPTION
					, PROJECT_CODE, FROM_BOH_QTY, TO_BOH_QTY, INCOTERMS, CELL_QTY_PACK
					, TRANSPORT_MODE, PROD_LINE, LT_DAY, BOD_ID
					, MEASURE, MEASURE_LABEL, SORT_ORDER_NO
					--, CREATE_FROM_YYYYMMDD, CREATE_TO_YYYYMMDD
					--, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE	
				)
				  SELECT @p_plan_start_yyyymmdd , @p_plan_type,  @p_seq

							, DIVISION_ID
				  			, 1 AS XLS_KEY1
							, 'A' AS OPERATION_GROUP
							, (SELECT TOP 1 SEGMENT2 NAME FROM SCM_ADM_LOOKUP_MASTER_DETAIL X WITH (NOLOCK) WHERE X.LOOKUP_TYPE = 'OPERATION_GROUP' AND X.SEGMENT1 = 'A' ) AS OPERATION_GROUP_NAME     

							, CELL_ITEM_ID
							, X.CELL_ITEM_ID AS ITEM_ID
							, (SELECT TOP 1  M.NICK_NAME  FROM DBO.SCM_MST_ITEM_SN M WITH (NOLOCK)  WHERE  M.ITEM_ID  = X.CELL_ITEM_ID AND M.DIVISION_ID = X.DIVISION_ID) AS NICK_NAME	
							, 'F6000' AS OPERATION_ID
						
							, X.FROM_SITE AS TO_SITE
							, (SELECT TOP 1 M.SITE_DESCRIPTION FROM SCM_MST_SITE M  WITH (NOLOCK) WHERE M.SCM_SITE_ID=X.FROM_SITE)
							, '-' FROM_SITE
							, '-'

							, '-', 0, 0, '-', 0  -- PROJECT_CODE...
							, '-', '-', 0,  '-' --TRANSPORT_MODE...

							, 'SEMI_PACK_PROD_CELL' AS MEASURE
							, M.COLUMN_LABEL_NAME  AS MEASURE_LABEL
							, M.SORT_ORDER_NO

							--, @p_create_from_yyyymmdd , @p_create_to_yyyymmdd																					
							--, @p_user_id, GETDATE(), @p_user_id, GETDATE()

				  FROM #SCP_XLS_PSI_GLOBAL_ESS X WITH(NOLOCK)     
				  LEFT JOIN  ( SELECT TOP 1 COLUMN_NAME, COLUMN_LABEL_NAME , SORT_ORDER_NO
								FROM SCM_MST_SHEET_MEASURE M WITH(NOLOCK) 
								WHERE COLUMN_NAME = 'SEMI_PACK_PROD_CELL' ) M
					ON  M.COLUMN_NAME = 'SEMI_PACK_PROD_CELL'
				  WHERE 1=1                        
					AND X.MEASURE = 'PACK_PROD' 					AND CELL_ITEM_ID IS NOT NULL
					AND NOT EXISTS (SELECT * FROM #SCP_XLS_PSI_GLOBAL_ESS S WITH (NOLOCK)
												WHERE MEASURE = 'SEMI_PACK_PROD_CELL' 
												--AND CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd
												AND S.ITEM_ID = X.CELL_ITEM_ID
												)
					GROUP BY DIVISION_ID, CELL_ITEM_ID, ITEM_ID, FROM_SITE
						,  M.COLUMN_LABEL_NAME, M.SORT_ORDER_NO

					
            -------------------------------------------------------------------------------
			 --최초입력             
              INSERT INTO SCP_XLS_PSI_GLOBAL_ESS WITH (TABLOCK)            
              (
                     DIVISION_ID
					 ,PLAN_START_YYYYMMDD
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

              SELECT DIVISION_ID
			        ,PLAN_START_YYYYMMDD
					,@p_create_from_yyyymmdd
					,@p_create_to_yyyymmdd
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
                                                 ,(CASE WHEN (TO_SITE = '-'  AND MEASURE = 'MKT_FCST_PACK_TOTAL' )    THEN 'ZZZ' 
                                                        WHEN (TO_SITE = '-'  AND MEASURE = 'SHIP_REQ_PACK_TOTAL' )    THEN 'ZZZ' 
                                                        WHEN (TO_SITE = '-'  AND MEASURE = 'MKT_FCST_CELL_TOTAL' )    THEN 'AAA' 
                                                        WHEN (TO_SITE = '-'  AND MEASURE = 'SHIP_REQ_CELL_TOTAL' )    THEN 'AAA' 
                                                        WHEN (TO_SITE = '-'  AND MEASURE = 'PACK_SHIP_PLAN_TOTAL' )   THEN 'AAA' 
                                                        WHEN (TO_SITE = '-'  AND MEASURE = 'CELL_SHIP_PLAN_TOTAL' )   THEN 'AAA' 
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
                                      )  AS XLS_KEY1 --정렬순서임에 유의(KSK)
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
              FROM #SCP_XLS_PSI_GLOBAL_ESS  WITH (NOLOCK)
			

			 --SELECT  'ESS_INSERT' TN, * FROM  SCP_XLS_PSI_GLOBAL_ESS WITH (NOLOCK)--TEST
	 					  
            -------------------------------------------------------------------------------------------------------------         
            --  YIELD(CELL_CHAR_AVAILABLE), LT UPDATE 
            ------------------------------------------------------------------------------------------------------------- 
              -- SET X.YIELD      = (CASE WHEN Y.SSP_MODIFY_YIELD > 0.0 THEN Y.SSP_MODIFY_YIELD ELSE Y.FORMATION_TOTAL_YIELD END)
              UPDATE X
                 --SET X.YIELD      = Y.FORMATION_TOTAL_YIELD
                 SET X.YIELD      = (CASE WHEN Y.SSP_MODIFY_YIELD > 0.0 THEN Y.SSP_MODIFY_YIELD ELSE Y.FORMATION_TOTAL_YIELD END)
               FROM SCP_XLS_PSI_GLOBAL_ESS X WITH (NOLOCK)
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
			   AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
                WHERE MEASURE = 'CELL_CHAR_AVAILABLE'                      


            -------------------------------------------------------------------------------------------------------------         
            --  PACK PROD : YIELD 
            ------------------------------------------------------------------------------------------------------------- 

              UPDATE X
                 SET X.YIELD      = Y.YIELD
            --  SELECT X.CELL_ITEM_ID, X.ITEM_ID, X.FROM_SITE, X.TO_SITE, X.YIELD,X.MEASURE,X.PROD_LINE,Y.LINE_ID, (CASE WHEN X.PROD_LINE = Y.LINE_ID THEN 'O' ELSE 'X' END )  AS chk,Y.ITEM_ID, Y.PLANT_SITE_ID,Y.YIELD
                FROM SCP_XLS_PSI_GLOBAL_ESS X WITH (NOLOCK)
                INNER JOIN (
                             SELECT PLANT_SITE_ID,ITEM_ID,OPERATION_ID,LINE_ID,MAX(YIELD) AS YIELD
                              FROM #tmp_SCP_MST_TACT_TIME WITH(NOLOCK)
                             WHERE DIVISION_ID =@p_division_id
--                               AND OPERATION_ID IN ('P9500','P5500')
                              GROUP BY PLANT_SITE_ID,ITEM_ID,OPERATION_ID,LINE_ID
                          ) Y
                ON X.ITEM_ID      = Y.ITEM_ID
               AND X.FROM_SITE    = Y.PLANT_SITE_ID
               AND X.ATTRIBUTE9   = Y.OPERATION_ID
               AND X.PROD_LINE    = Y.LINE_ID
			   AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
             WHERE MEASURE        = 'PACK_PROD'

            -------------------------------------------------------------------------------------------------------------    
            -- SCP_ANL_PSI_GLOBAL.MODEL_INVENTORY --> SCP_XLS_PSI_GLOBAL.PACK_BOH
            -------------------------------------------------------------------------------------------------------------    
               SELECT DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,CELL_ITEM_ID,ITEM_ID,FROM_SITE,FROM_BOH_QTY
                INTO #SCP_XLS_PSI_GLOBAL_ESS_MODEL_INVENTORY
                FROM SCP_ANL_PSI_GLOBAL X  WITH (NOLOCK)
                 WHERE X.DIVISION_ID			    =  @p_division_id
		                AND X.PLAN_START_YYYYMMDD	=  @p_plan_start_yyyymmdd
		                AND X.PLAN_TYPE				    =  @p_plan_type
		                AND X.SEQ					        =  @p_seq
                    AND X.MEASURE             = 'MODEL_INVENTORY'
                    AND X.YYYYMMDD            = @p_plan_start_yyyymmdd

              UPDATE X
                SET X.QTY001            = Y.FROM_BOH_QTY
                FROM SCP_XLS_PSI_GLOBAL_ESS X  WITH (NOLOCK)
                INNER JOIN #SCP_XLS_PSI_GLOBAL_ESS_MODEL_INVENTORY Y WITH (NOLOCK)
                ON X.DIVISION_ID   = Y.DIVISION_ID
				AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
                AND X.FROM_SITE    = Y.FROM_SITE
                AND X.ITEM_ID      = Y.ITEM_ID
                AND X.MEASURE      ='PACK_BOH'

            -------------------------------------------------------------------------------------------------------------         
            --  UPDATE
            -------------------------------------------------------------------------------------------------------------     

                UPDATE X
                   SET ITEM_ID      = ( SELECT TOP 1 CHILD_ITEM_ID
                                               FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V AS Y WITH (NOLOCK)
                                              WHERE Y.DIVISION_ID        = X.DIVISION_ID
                                                AND Y.MODEL_ID           = X.ITEM_ID
                                                AND Y.OPERATION_GROUP_ID = 'A'
												/* 활성화 코드 관련 조건 추가::2023.07.01, KSK */
												AND Y.CELL_TYPE          = 'CP'  
												)
                      ,TO_SITE                = '-'
                      ,TO_SITE_DESCRIPTION    = '-'
                      ,PROJECT_CODE           = '-'
                      ,INCOTERMS              = '-'
                      ,PROD_LINE              = '-'
                FROM SCP_XLS_PSI_GLOBAL_ESS X  WITH (NOLOCK)
                 WHERE OPERATION_GROUP   = 'P'
                 AND MEASURE IN ('PACK_CELL_BOH','PACK_CELL_EOH','PACK_CELL_EOH_TOTAL')
				 AND CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가

                 UPDATE X
                   SET X.NICK_NAME = (SELECT TOP 1 (CASE WHEN Y.NICK_NAME IS NULL THEN '-'  WHEN Y.NICK_NAME = ''    THEN '-'  ELSE Y.NICK_NAME END) 
                                        FROM DBO.SCM_MST_ITEM_SN Y WITH (NOLOCK)  WHERE  Y.ITEM_ID  = X.ITEM_ID AND Y.DIVISION_ID = '82')		-- 2021.05.25 NICK_NAME 누락방지
                 FROM SCP_XLS_PSI_GLOBAL_ESS X  WITH (NOLOCK)
                 WHERE OPERATION_GROUP   = 'P'
                 AND MEASURE IN ('PACK_CELL_BOH','PACK_CELL_EOH','PACK_CELL_EOH_TOTAL')           
				 AND CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
                 
                 
               UPDATE X
                  SET X.CELL_QTY_PACK = (SELECT TOP 1 CONVERT(NVARCHAR(50), CEILING(V.ACCUMULATED_CHILD_QTY))
                              	          FROM DBO.SCM_MST_MODEL_FINAL_ITEM_BOM_V V WITH (NOLOCK)					
                                          WHERE V.DIVISION_ID         = X.DIVISION_ID 
                                	          AND V.OPERATION_GROUP_ID  = 'A'
                                	          AND V.MODEL_ID            = X.ITEM_ID
                                	          AND V.CHILD_ITEM_ID       = X.CELL_ITEM_ID
                                         )
                 FROM SCP_XLS_PSI_GLOBAL_ESS  X WITH (NOLOCK)
                  WHERE 0 = 0
                  AND X.OPERATION_GROUP='P'
				  AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
                  --AND X.MEASURE NOT IN  ('CELL_SHIP_PLAN_TOTAL','PACK_SHIP_PLAN_TOTAL')

                         
                  DELETE TBL FROM
	                (
	                        SELECT
	                               ROW_NUMBER() OVER (PARTITION BY CELL_ITEM_ID, ITEM_ID,FROM_SITE   ORDER BY XLS_KEY1 desc ) AS ROWNUM
	                        FROM SCP_XLS_PSI_GLOBAL_ESS  WITH (NOLOCK)
                          WHERE MEASURE IN ('PACK_CELL_BOH')
						    AND CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
	                ) AS TBL
	                WHERE TBL.ROWNUM > 1


                   DELETE TBL FROM
	                (
	                        SELECT
	                               ROW_NUMBER() OVER (PARTITION BY CELL_ITEM_ID, ITEM_ID,FROM_SITE  ORDER BY XLS_KEY1 desc) AS ROWNUM
	                        FROM SCP_XLS_PSI_GLOBAL_ESS
                          WHERE MEASURE IN ('PACK_CELL_EOH')
						    AND CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
	                ) AS TBL
	                WHERE TBL.ROWNUM > 1

                   DELETE TBL FROM
	                (
	                        SELECT
	                               ROW_NUMBER() OVER (PARTITION BY CELL_ITEM_ID, ITEM_ID,FROM_SITE  ORDER BY XLS_KEY1 desc) AS ROWNUM
	                        FROM SCP_XLS_PSI_GLOBAL_ESS
                          WHERE MEASURE IN ('PACK_CELL_EOH_TOTAL')
						    AND CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
	                ) AS TBL
	                WHERE TBL.ROWNUM > 1


                  

                  DELETE FROM SCP_XLS_PSI_GLOBAL_ESS
                  WHERE MEASURE ='SHIP_PLAN'
                  AND BOD_ID ='-'
				  AND CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가


                  DELETE FROM SCP_XLS_PSI_GLOBAL_ESS
                  WHERE MEASURE IN ('CELL_PROD','CELL_PROD_LOAD')
                  AND PROD_LINE ='-'
				  AND CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가

                  


                  UPDATE X
                     SET X.LT_DAY = Y.LT_FORMATION + CONVERT(INT, ISNULL(Y.ATTRIBUTE1, '0')) -- AS LT_FORMATION
                     --SELECT Y.LT_FORMATION + CONVERT(INT, ISNULL(Y.ATTRIBUTE1, '0')) AS LT_FORMATION,*
                      FROM SCP_XLS_PSI_GLOBAL_ESS X  WITH (NOLOCK)
                     INNER JOIN SCP_MST_FORMATION Y WITH (NOLOCK)
                     ON X.DIVISION_ID   = Y.DIVISION_ID
					 AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
                     AND X.FROM_SITE    = Y.PLANT_SITE_ID
                     AND X.ITEM_ID      = Y.ITEM_ID
                     AND X.MEASURE      ='CELL_PROD'          



                  DELETE TBL FROM
	                (
	                        SELECT
	                               ROW_NUMBER() OVER (PARTITION BY CELL_ITEM_ID, ITEM_ID,FROM_SITE  ORDER BY XLS_KEY1 desc) AS ROWNUM
	                        FROM SCP_XLS_PSI_GLOBAL_ESS
                          WHERE MEASURE IN ('PACK_SHIP_PLAN_TOTAL')
						    AND CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
	                ) AS TBL
	                WHERE TBL.ROWNUM > 1

                   DELETE TBL FROM
	                (
	                        SELECT
	                               ROW_NUMBER() OVER (PARTITION BY CELL_ITEM_ID, ITEM_ID,FROM_SITE  ORDER BY XLS_KEY1 desc) AS ROWNUM
	                        FROM SCP_XLS_PSI_GLOBAL_ESS
                          WHERE MEASURE IN ('CELL_SHIP_PLAN_TOTAL')
						    AND CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
	                ) AS TBL
	                WHERE TBL.ROWNUM > 1

                  DELETE FROM SCP_XLS_PSI_GLOBAL_ESS
                  WHERE MEASURE ='PACK_SHIP_PLAN_TOTAL'
				  AND CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
                  AND OPERATION_GROUP = 'A'

                  --DELETE FROM SCP_XLS_PSI_GLOBAL_ESS
                  --WHERE FROM_SITE = '-'

                  --DELETE FROM SCP_XLS_PSI_GLOBAL_ESS
                  --WHERE 0 = 0
                  --AND OPERATION_GROUP ='P'
                  --AND PROD_LINE = '-'





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


                UPDATE X
                  SET X.QTY001 = ISNULL(Y.QTY,0)
                 FROM SCP_XLS_PSI_GLOBAL_ESS X WITH (NOLOCK)
                 INNER JOIN #BOH Y WITH (NOLOCK)   
                  ON 0 = 0
                  AND X.FROM_SITE            = Y.SCM_SITE_ID      
                  AND X.ITEM_ID              = Y.ITEM_ID    
                  AND X.MEASURE              IN ('PACK_BOH','CELL_BOH','PACK_CELL_BOH')
				  AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가



                  -- -- 보류중 해제일자가 없는수량
                 UPDATE X
                  SET X.QTY001 = ISNULL(X.QTY001,0) - ISNULL(Y.QTY,0)
                 FROM SCP_XLS_PSI_GLOBAL_ESS X WITH (NOLOCK)
                 INNER JOIN (SELECT ITEM_ID, FROM_SITE, SUM(Y.QTY) AS QTY
                                 FROM #PLN_TH_ENG_STOCK_PLAN Y  WITH (NOLOCK)
                                WHERE DESCR ='WH_HOLD'
                                GROUP BY ITEM_ID,FROM_SITE
                             )   Y    
                  ON 0 = 0
                  AND X.FROM_SITE            = Y.FROM_SITE      
                  AND X.ITEM_ID              = Y.ITEM_ID    
                  AND X.MEASURE              ='CELL_BOH'
				  AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가


                UPDATE X
                 SET X.QTY001 = ISNULL(Y.QTY,0)      
                 FROM SCP_XLS_PSI_GLOBAL_ESS X WITH (NOLOCK)
                 INNER JOIN #BOH Y WITH (NOLOCK)   
                  ON 0 = 0
                  AND X.TO_SITE               = Y.SCM_SITE_ID      
                  AND X.ITEM_ID               = Y.ITEM_ID    
                  AND X.MEASURE               = 'TO_SITE_BOH'
                  AND X.INCOTERMS             = Y.INCOTERMS    
				  AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
                  
			END



            --/*
            -------------------------------------------------------------------------------------------------------------         
            --  DIO 관련 시뮬레이션 추가 
            --  2020.06.25   KTH         DIO 수정 관련
			--  2020.07.01   KSW         자동차 로직을 ESS 에 적용
            ------------------------------------------------------------------------------------------------------------- 
              IF OBJECT_ID('tempdb..#tmp_SCP_MST_DIO') IS NOT NULL	
	              DROP TABLE #tmp_SCP_MST_DIO

              SELECT a.DIVISION_ID, a.PLANT_ID, ITEM_ID,a.GRO_STD_DIO,MIN_STD_DIO
                INTO #tmp_SCP_MST_DIO
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
               FROM SCP_XLS_PSI_GLOBAL_ESS X WITH (NOLOCK)
               INNER JOIN #tmp_SCP_MST_DIO Z  WITH (NOLOCK)
                ON X.CELL_ITEM_ID   = Z.ITEM_ID
               -- AND X.FROM_SITE   = Z.PLANT_ID
			   AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
                WHERE MEASURE       = 'ALLOCATION_DIO'
            --*/

			-------------------------------------------------------------------------------------------------------------
			-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계- start
			-- BOD_ID에 대한 from_yyyymmdd, to_yyyymmdd 추가 --> ATTRIBUTE3
			-------------------------------------------------------------------------------------------------------------
			UPDATE X
                 SET X.ATTRIBUTE3   = Z.FROM_YYYYMMDD + ',' + Z.TO_YYYYMMDD
               FROM SCP_XLS_PSI_GLOBAL_ESS X WITH (NOLOCK)
               INNER JOIN DBO.SCP_MST_BOD_N_V Z  WITH (NOLOCK)
                ON X.BOD_ID   = Z.BOD_ID
                WHERE MEASURE IN ('SHIP_PLAN', 'SEMI_SHIP_PLAN')
			-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계- end
			
 



          
            -------------------------------------------------------------------------------------------------------------         
            --  52주 데이터 SCRIPT 생성후 UPDATE 
            -------------------------------------------------------------------------------------------------------------     
            
             IF OBJECT_ID('tempdb..#Rn') IS NOT NULL	
	            DROP TABLE #Rn
              --  SELECT 'WQTY' + A.ISO_WEEK     AS WEEK_COLUMN    
              --  , ROW_NUMBER() OVER (ORDER BY ISO_WEEK) AS Rn
              --  INTO #Rn
  	           -- FROM DBO.SCM_SYS_CALENDAR_M A  WITH(NOLOCK)	     
	 		          --WHERE A.BASIS_YYYYMMDD     >= @p_plan_start_yyyymmdd 
              --    AND A.BASIS_YYYYMMDD     <  @p_to_yyyymmdd
              
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
              SELECT @mQry_sumWeek = @mQry_sumWeek + CHAR(10) +   ' FROM SCP_XLS_PSI_GLOBAL_ESS X WITH (NOLOCK) WHERE X.CREATE_FROM_YYYYMMDD = ''' + @p_create_from_yyyymmdd + ''''+CHAR(10)  -- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 

			  
			  --PRINT @mQry_sumWeek --TEST

              EXEC sp_executesql @mQry_sumWeek;

--          -------------------------------------------------------------------------------------------------------------         
            --  PACK_PROD_LOAD 중복삭제
            -------------------------------------------------------------------------------------------------------------  
                DELETE TBL FROM
	                (
	                        SELECT
	                               ROW_NUMBER() OVER (PARTITION BY CELL_ITEM_ID, ITEM_ID, FROM_SITE, PROD_LINE   ORDER BY XLS_KEY1 desc ) AS ROWNUM
	                        FROM SCP_XLS_PSI_GLOBAL_ESS  WITH (NOLOCK)
                          WHERE MEASURE IN ('PACK_PROD_LOAD')
						    AND CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
	                ) AS TBL
	                WHERE TBL.ROWNUM > 1
					;

				DELETE SCP_XLS_PSI_GLOBAL_ESS
				 WHERE CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd
				   AND ITEM_ID      = '-'
				   AND CELL_ITEM_ID IS NULL
				   ;

			    DELETE TBL FROM
					(
					SELECT * 
					  FROM SCP_XLS_PSI_GLOBAL_ESS X WITH (NOLOCK)
					 WHERE X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd
					   AND X.MEASURE IN ('PACK_PROD_LOAD_TOTAL')
					   AND ISNULL((SELECT DISTINCT 'Y' 
							  FROM SCP_XLS_PSI_GLOBAL_ESS A WITH (NOLOCK)
							 WHERE A.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd
							   AND A.FROM_SITE    = X.FROM_SITE
							   --AND A.PROD_LINE    = X.PROD_LINE
							   AND A.MEASURE      = 'PACK_PROD'
						   ),'N') = 'N'
					) AS TBL
				   ;

			    DELETE TBL FROM
					(
					SELECT * 
					  FROM SCP_XLS_PSI_GLOBAL_ESS X WITH (NOLOCK)
					 WHERE X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd
					   AND X.MEASURE IN ('PACK_PROD_LOAD_TOTAL')
					   AND ISNULL((SELECT DISTINCT 'Y' 
							  FROM SCP_XLS_PSI_GLOBAL_ESS A WITH (NOLOCK)
							 WHERE A.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd
							   AND A.ITEM_ID      = X.ITEM_ID
							   AND A.FROM_SITE    = X.FROM_SITE
							   AND A.PROD_LINE    = X.PROD_LINE
							   AND A.MEASURE      = 'PACK_PROD'
						   ),'N') = 'N'
					) AS TBL
				   ;

			    DELETE TBL FROM
					(
					SELECT * 
					  FROM SCP_XLS_PSI_GLOBAL_ESS X WITH (NOLOCK)
					 WHERE X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd
					   AND X.MEASURE IN ('PACK_PROD_LOAD', 'PACK_WORKING_TIME', 'PACK_TACT_TIME')
					   AND ISNULL((SELECT DISTINCT 'Y' 
							  FROM SCP_XLS_PSI_GLOBAL_ESS A WITH (NOLOCK)
							 WHERE A.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd
							   AND A.ITEM_ID      = X.ITEM_ID
							   AND A.CELL_ITEM_ID = X.CELL_ITEM_ID
							   AND A.FROM_SITE    = X.FROM_SITE
							   AND A.PROD_LINE    = X.PROD_LINE
							   AND A.MEASURE      = 'PACK_PROD'
						   ),'N') = 'N'
					) AS TBL
				   ;


			    DELETE TBL FROM
					(
					SELECT * 
					  FROM SCP_XLS_PSI_GLOBAL_ESS X WITH (NOLOCK)
					 WHERE X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd
					   AND X.MEASURE IN ('PACK_PROD_TOTAL', 'PACK_DIO')
					   AND ISNULL((SELECT DISTINCT 'Y' 
							  FROM SCP_XLS_PSI_GLOBAL_ESS A WITH (NOLOCK)
							 WHERE A.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd
							   AND A.ITEM_ID      = X.ITEM_ID
							   AND A.CELL_ITEM_ID = X.CELL_ITEM_ID
							   AND A.FROM_SITE    = X.FROM_SITE
							   --AND A.PROD_LINE    = X.PROD_LINE
							   AND A.MEASURE      = 'PACK_PROD'
						   ),'N') = 'N'
					) AS TBL
				   ;


			    DELETE TBL FROM
					(
					SELECT * 
					  FROM SCP_XLS_PSI_GLOBAL_ESS X WITH (NOLOCK)
					 WHERE X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd
					   AND X.MEASURE = 'CELL_TACT_TIME'
					   AND ISNULL((SELECT DISTINCT 'Y' 
							  FROM SCP_XLS_PSI_GLOBAL_ESS A WITH (NOLOCK)
							 WHERE A.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd
							   AND A.ITEM_ID      = X.ITEM_ID
							   AND A.CELL_ITEM_ID = X.CELL_ITEM_ID
							   AND A.FROM_SITE    = X.FROM_SITE
							   AND A.PROD_LINE    = X.PROD_LINE
							   AND A.MEASURE      = 'CELL_PROD'
						   ),'N') = 'N'
					) AS TBL
				   ;

			    DELETE TBL FROM
					(
					SELECT * 
					  FROM SCP_XLS_PSI_GLOBAL_ESS X WITH (NOLOCK)
					 WHERE X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd
					   AND X.MEASURE IN ('CELL_PROD_LOAD', 'CELL_WORKING_TIME')
					   AND ISNULL((SELECT DISTINCT 'Y' 
							  FROM SCP_XLS_PSI_GLOBAL_ESS A WITH (NOLOCK)
							 WHERE A.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd
							   AND A.FROM_SITE    = X.FROM_SITE
							   AND A.PROD_LINE    = X.PROD_LINE
							   AND A.MEASURE      = 'CELL_PROD'
						   ),'N') = 'N'
					) AS TBL
				   ;

			    DELETE TBL FROM
					(
					SELECT * 
					  FROM SCP_XLS_PSI_GLOBAL_ESS X WITH (NOLOCK)
					 WHERE X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd
					   AND X.MEASURE IN ('MKT_FCST_DIO', 'ALLOCATION_DIO', 'ALLOCATION_GAP_STD_DIO', 'ALLOCATION_GAP_MIN_DIO')
					   AND ISNULL((SELECT DISTINCT 'Y' 
							  FROM SCP_XLS_PSI_GLOBAL_ESS A WITH (NOLOCK)
							 WHERE A.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd
							   AND A.ITEM_ID      <> '-'
							   AND A.CELL_ITEM_ID = X.CELL_ITEM_ID
						   ),'N') = 'N'
					) AS TBL
				   ;
              
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
                              ELSE ISNULL( ( ROUND(SUM(A.CAPA_TACT),0) / SUM(A.WORKING_TIME) ) ,0 ) *100
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
                   FROM SCP_XLS_PSI_GLOBAL_ESS X WITH (NOLOCK)
                   INNER JOIN #LineLoad_WEEK_PIVOT Y WITH (NOLOCK)

                      ON Y.PROD_LINE    = X.PROD_LINE 
                     AND X.DIVISION_ID  = Y.DIVISION_ID
					 AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
                     AND X.FROM_SITE    = Y.SITE_ID
                     AND X.ATTRIBUTE9   = Y.OPERATION_ID
                   WHERE X.MEASURE IN ('PACK_PROD_LOAD','CELL_PROD_LOAD') 

              
              -- LT_TOTAL_BY_WEEK
              -- BOD LT (SHIP_PLAN/SEMI_SHIP_PLAN) : BOD L/T 계산시 1~7일 구간은 반올림, 이후 구간은 올림 처리
 
              UPDATE X
                 SET X.LT_DAY = (CASE WHEN (Y.LT_TOTAL/7.0) < 1   THEN ROUND ((Y.LT_TOTAL/7.0),0,0) ELSE CEILING((Y.LT_TOTAL/7.0))  END) 
                    ,X.ATTRIBUTE2 = Y.lt_total
                FROM SCP_XLS_PSI_GLOBAL_ESS X  WITH (NOLOCK)
                INNER JOIN SCP_MST_BOD_N_V  Y WITH (NOLOCK)		-- BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V
                ON X.DIVISION_ID      = Y.DIVISION_ID
				AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
                AND X.FROM_SITE       = Y.FROM_SITE
                AND X.TO_SITE         = Y.TO_SITE
                AND X.TRANSPORT_MODE  = Y.TRANSPORT_MODE
                AND X.BOD_ID          = Y.BOD_ID
            

                UPDATE X
                SET X.LT_DAY = (CEILING(X.LT_DAY /7.0)) 
                    , X.ATTRIBUTE2 = X.LT_DAY 
                FROM SCP_XLS_PSI_GLOBAL_ESS X  WITH (NOLOCK)
                WHERE 0 = 0
				AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
                AND X.MEASURE      ='CELL_PROD'

                -- LINE 추가시 여유를 위해서 
                UPDATE X
                SET X.XLS_KEY1 = XLS_KEY1 * 1000
                FROM SCP_XLS_PSI_GLOBAL_ESS X  WITH (NOLOCK)
				WHERE X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
				
				--SELECT  'SCP_XLS_PSI_GLOBAL_ESS_KEY1000' TN, * FROM  SCP_XLS_PSI_GLOBAL_ESS WITH (NOLOCK)--TEST

            -------------------------------------------------------------------------------------------------------------         
            -- PROJECT NAME 반영 ATTRIBUTE8 반영
            -------------------------------------------------------------------------------------------------------------
             UPDATE X
                SET X.ATTRIBUTE8 = Y.PROJECT_NAME
                FROM SCP_XLS_PSI_GLOBAL_ESS X  WITH (NOLOCK)
                INNER JOIN 
                          (
                              SELECT PROJECT_CODE
                                    ,PROJECT_NAME
                                    ,ROW_NUMBER() OVER (PARTITION BY PROJECT_CODE ORDER BY PROJECT_VER_SEQ DESC ) AS Rn
                                    ,DIVISION_ID
                              FROM SCM_MST_PROJECT X WITH (NOLOCK)
                          ) Y
                   ON X.PROJECT_CODE = Y.PROJECT_CODE
				   AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
                WHERE Y.Rn = 1

            -------------------------------------------------------------------------------------------------------------         
            --  보정
            -------------------------------------------------------------------------------------------------------------
            DELETE FROM SCP_XLS_PSI_GLOBAL_ESS  
             WHERE MEASURE IN ('CELL_WORKING_TIME','PACK_WORKING_TIME')
               AND PROD_LINE ='-'           
			   AND CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가

		     -- 저장시의 UNPIVOT 지원위해 널데이터 초기화(E20250805-000724	ess 사업부 시뮬레이터 특정 모델 저장 안되는 이슈)
			 UPDATE SCP_XLS_PSI_GLOBAL_ESS 
				SET QTY001=ISNULL(QTY001,0),QTY002=ISNULL(QTY002,0),QTY003=ISNULL(QTY003,0),QTY004=ISNULL(QTY004,0),QTY005=ISNULL(QTY005,0),QTY006=ISNULL(QTY006,0),QTY007=ISNULL(QTY007,0),QTY008=ISNULL(QTY008,0),QTY009=ISNULL(QTY009,0),QTY010=ISNULL(QTY010,0),QTY011=ISNULL(QTY011,0),QTY012=ISNULL(QTY012,0),QTY013=ISNULL(QTY013,0),QTY014=ISNULL(QTY014,0),QTY015=ISNULL(QTY015,0),QTY016=ISNULL(QTY016,0),QTY017=ISNULL(QTY017,0),QTY018=ISNULL(QTY018,0),QTY019=ISNULL(QTY019,0),QTY020=ISNULL(QTY020,0),QTY021=ISNULL(QTY021,0),QTY022=ISNULL(QTY022,0),QTY023=ISNULL(QTY023,0),QTY024=ISNULL(QTY024,0),QTY025=ISNULL(QTY025,0),QTY026=ISNULL(QTY026,0),QTY027=ISNULL(QTY027,0),QTY028=ISNULL(QTY028,0),QTY029=ISNULL(QTY029,0),QTY030=ISNULL(QTY030,0),QTY031=ISNULL(QTY031,0),QTY032=ISNULL(QTY032,0),QTY033=ISNULL(QTY033,0),QTY034=ISNULL(QTY034,0),QTY035=ISNULL(QTY035,0),QTY036=ISNULL(QTY036,0),QTY037=ISNULL(QTY037,0),QTY038=ISNULL(QTY038,0),QTY039=ISNULL(QTY039,0),QTY040=ISNULL(QTY040,0),QTY041=ISNULL(QTY041,0),QTY042=ISNULL(QTY042,0),QTY043=ISNULL(QTY043,0),QTY044=ISNULL(QTY044,0),QTY045=ISNULL(QTY045,0),QTY046=ISNULL(QTY046,0),QTY047=ISNULL(QTY047,0),QTY048=ISNULL(QTY048,0),QTY049=ISNULL(QTY049,0),QTY050=ISNULL(QTY050,0),QTY051=ISNULL(QTY051,0),QTY052=ISNULL(QTY052,0),QTY053=ISNULL(QTY053,0),QTY054=ISNULL(QTY054,0),QTY055=ISNULL(QTY055,0),QTY056=ISNULL(QTY056,0),QTY057=ISNULL(QTY057,0),QTY058=ISNULL(QTY058,0),QTY059=ISNULL(QTY059,0),QTY060=ISNULL(QTY060,0),QTY061=ISNULL(QTY061,0),QTY062=ISNULL(QTY062,0),QTY063=ISNULL(QTY063,0),QTY064=ISNULL(QTY064,0),QTY065=ISNULL(QTY065,0),QTY066=ISNULL(QTY066,0),QTY067=ISNULL(QTY067,0),QTY068=ISNULL(QTY068,0),QTY069=ISNULL(QTY069,0),QTY070=ISNULL(QTY070,0),QTY071=ISNULL(QTY071,0),QTY072=ISNULL(QTY072,0),QTY073=ISNULL(QTY073,0),QTY074=ISNULL(QTY074,0),QTY075=ISNULL(QTY075,0),QTY076=ISNULL(QTY076,0),QTY077=ISNULL(QTY077,0),QTY078=ISNULL(QTY078,0),QTY079=ISNULL(QTY079,0),QTY080=ISNULL(QTY080,0),QTY081=ISNULL(QTY081,0),QTY082=ISNULL(QTY082,0),QTY083=ISNULL(QTY083,0),QTY084=ISNULL(QTY084,0),QTY085=ISNULL(QTY085,0),QTY086=ISNULL(QTY086,0),QTY087=ISNULL(QTY087,0),QTY088=ISNULL(QTY088,0),QTY089=ISNULL(QTY089,0),QTY090=ISNULL(QTY090,0),QTY091=ISNULL(QTY091,0),QTY092=ISNULL(QTY092,0),QTY093=ISNULL(QTY093,0),QTY094=ISNULL(QTY094,0),QTY095=ISNULL(QTY095,0),QTY096=ISNULL(QTY096,0),QTY097=ISNULL(QTY097,0),QTY098=ISNULL(QTY098,0),QTY099=ISNULL(QTY099,0),QTY100=ISNULL(QTY100,0),QTY101=ISNULL(QTY101,0),QTY102=ISNULL(QTY102,0),QTY103=ISNULL(QTY103,0),QTY104=ISNULL(QTY104,0),QTY105=ISNULL(QTY105,0),QTY106=ISNULL(QTY106,0),QTY107=ISNULL(QTY107,0),QTY108=ISNULL(QTY108,0),QTY109=ISNULL(QTY109,0),QTY110=ISNULL(QTY110,0),QTY111=ISNULL(QTY111,0),QTY112=ISNULL(QTY112,0),QTY113=ISNULL(QTY113,0),QTY114=ISNULL(QTY114,0),QTY115=ISNULL(QTY115,0),QTY116=ISNULL(QTY116,0),QTY117=ISNULL(QTY117,0),QTY118=ISNULL(QTY118,0),QTY119=ISNULL(QTY119,0),QTY120=ISNULL(QTY120,0),QTY121=ISNULL(QTY121,0),QTY122=ISNULL(QTY122,0),QTY123=ISNULL(QTY123,0),QTY124=ISNULL(QTY124,0),QTY125=ISNULL(QTY125,0),QTY126=ISNULL(QTY126,0),QTY127=ISNULL(QTY127,0),QTY128=ISNULL(QTY128,0),QTY129=ISNULL(QTY129,0),QTY130=ISNULL(QTY130,0),QTY131=ISNULL(QTY131,0),QTY132=ISNULL(QTY132,0),QTY133=ISNULL(QTY133,0),QTY134=ISNULL(QTY134,0),QTY135=ISNULL(QTY135,0),QTY136=ISNULL(QTY136,0),QTY137=ISNULL(QTY137,0),QTY138=ISNULL(QTY138,0),QTY139=ISNULL(QTY139,0),QTY140=ISNULL(QTY140,0),QTY141=ISNULL(QTY141,0),QTY142=ISNULL(QTY142,0),QTY143=ISNULL(QTY143,0),QTY144=ISNULL(QTY144,0),QTY145=ISNULL(QTY145,0),QTY146=ISNULL(QTY146,0),QTY147=ISNULL(QTY147,0),QTY148=ISNULL(QTY148,0),QTY149=ISNULL(QTY149,0),QTY150=ISNULL(QTY150,0),QTY151=ISNULL(QTY151,0),QTY152=ISNULL(QTY152,0),QTY153=ISNULL(QTY153,0),QTY154=ISNULL(QTY154,0),QTY155=ISNULL(QTY155,0),QTY156=ISNULL(QTY156,0),QTY157=ISNULL(QTY157,0),QTY158=ISNULL(QTY158,0),QTY159=ISNULL(QTY159,0),QTY160=ISNULL(QTY160,0),QTY161=ISNULL(QTY161,0),QTY162=ISNULL(QTY162,0),QTY163=ISNULL(QTY163,0),QTY164=ISNULL(QTY164,0),QTY165=ISNULL(QTY165,0),QTY166=ISNULL(QTY166,0),QTY167=ISNULL(QTY167,0),QTY168=ISNULL(QTY168,0),QTY169=ISNULL(QTY169,0),QTY170=ISNULL(QTY170,0),QTY171=ISNULL(QTY171,0),QTY172=ISNULL(QTY172,0),QTY173=ISNULL(QTY173,0),QTY174=ISNULL(QTY174,0),QTY175=ISNULL(QTY175,0),QTY176=ISNULL(QTY176,0),QTY177=ISNULL(QTY177,0),QTY178=ISNULL(QTY178,0),QTY179=ISNULL(QTY179,0),QTY180=ISNULL(QTY180,0),QTY181=ISNULL(QTY181,0),QTY182=ISNULL(QTY182,0),QTY183=ISNULL(QTY183,0),QTY184=ISNULL(QTY184,0),QTY185=ISNULL(QTY185,0),QTY186=ISNULL(QTY186,0),QTY187=ISNULL(QTY187,0),QTY188=ISNULL(QTY188,0),QTY189=ISNULL(QTY189,0),QTY190=ISNULL(QTY190,0),QTY191=ISNULL(QTY191,0),QTY192=ISNULL(QTY192,0),QTY193=ISNULL(QTY193,0),QTY194=ISNULL(QTY194,0),QTY195=ISNULL(QTY195,0),QTY196=ISNULL(QTY196,0),QTY197=ISNULL(QTY197,0),QTY198=ISNULL(QTY198,0),QTY199=ISNULL(QTY199,0),QTY200=ISNULL(QTY200,0),QTY201=ISNULL(QTY201,0),QTY202=ISNULL(QTY202,0),QTY203=ISNULL(QTY203,0),QTY204=ISNULL(QTY204,0),QTY205=ISNULL(QTY205,0),QTY206=ISNULL(QTY206,0),QTY207=ISNULL(QTY207,0),QTY208=ISNULL(QTY208,0),QTY209=ISNULL(QTY209,0),QTY210=ISNULL(QTY210,0),QTY211=ISNULL(QTY211,0),QTY212=ISNULL(QTY212,0),QTY213=ISNULL(QTY213,0),QTY214=ISNULL(QTY214,0),QTY215=ISNULL(QTY215,0),QTY216=ISNULL(QTY216,0),QTY217=ISNULL(QTY217,0),QTY218=ISNULL(QTY218,0),QTY219=ISNULL(QTY219,0),QTY220=ISNULL(QTY220,0),QTY221=ISNULL(QTY221,0),QTY222=ISNULL(QTY222,0),QTY223=ISNULL(QTY223,0),QTY224=ISNULL(QTY224,0),QTY225=ISNULL(QTY225,0),QTY226=ISNULL(QTY226,0),QTY227=ISNULL(QTY227,0),QTY228=ISNULL(QTY228,0),QTY229=ISNULL(QTY229,0),QTY230=ISNULL(QTY230,0),QTY231=ISNULL(QTY231,0),QTY232=ISNULL(QTY232,0),QTY233=ISNULL(QTY233,0),QTY234=ISNULL(QTY234,0),QTY235=ISNULL(QTY235,0),QTY236=ISNULL(QTY236,0),QTY237=ISNULL(QTY237,0),QTY238=ISNULL(QTY238,0),QTY239=ISNULL(QTY239,0),QTY240=ISNULL(QTY240,0),QTY241=ISNULL(QTY241,0),QTY242=ISNULL(QTY242,0),QTY243=ISNULL(QTY243,0),QTY244=ISNULL(QTY244,0),QTY245=ISNULL(QTY245,0),QTY246=ISNULL(QTY246,0),QTY247=ISNULL(QTY247,0),QTY248=ISNULL(QTY248,0),QTY249=ISNULL(QTY249,0),QTY250=ISNULL(QTY250,0),QTY251=ISNULL(QTY251,0),QTY252=ISNULL(QTY252,0),QTY253=ISNULL(QTY253,0),QTY254=ISNULL(QTY254,0),QTY255=ISNULL(QTY255,0),QTY256=ISNULL(QTY256,0),QTY257=ISNULL(QTY257,0),QTY258=ISNULL(QTY258,0),QTY259=ISNULL(QTY259,0),QTY260=ISNULL(QTY260,0),QTY261=ISNULL(QTY261,0),QTY262=ISNULL(QTY262,0),QTY263=ISNULL(QTY263,0),QTY264=ISNULL(QTY264,0),QTY265=ISNULL(QTY265,0),QTY266=ISNULL(QTY266,0),QTY267=ISNULL(QTY267,0),QTY268=ISNULL(QTY268,0),QTY269=ISNULL(QTY269,0),QTY270=ISNULL(QTY270,0),QTY271=ISNULL(QTY271,0),QTY272=ISNULL(QTY272,0),QTY273=ISNULL(QTY273,0),QTY274=ISNULL(QTY274,0),QTY275=ISNULL(QTY275,0),QTY276=ISNULL(QTY276,0),QTY277=ISNULL(QTY277,0),QTY278=ISNULL(QTY278,0),QTY279=ISNULL(QTY279,0),QTY280=ISNULL(QTY280,0),QTY281=ISNULL(QTY281,0),QTY282=ISNULL(QTY282,0),QTY283=ISNULL(QTY283,0),QTY284=ISNULL(QTY284,0),QTY285=ISNULL(QTY285,0),QTY286=ISNULL(QTY286,0),QTY287=ISNULL(QTY287,0),QTY288=ISNULL(QTY288,0),QTY289=ISNULL(QTY289,0),QTY290=ISNULL(QTY290,0),QTY291=ISNULL(QTY291,0),QTY292=ISNULL(QTY292,0),QTY293=ISNULL(QTY293,0),QTY294=ISNULL(QTY294,0),QTY295=ISNULL(QTY295,0),QTY296=ISNULL(QTY296,0),QTY297=ISNULL(QTY297,0),QTY298=ISNULL(QTY298,0),QTY299=ISNULL(QTY299,0),QTY300=ISNULL(QTY300,0),QTY301=ISNULL(QTY301,0),QTY302=ISNULL(QTY302,0),QTY303=ISNULL(QTY303,0),QTY304=ISNULL(QTY304,0),QTY305=ISNULL(QTY305,0),QTY306=ISNULL(QTY306,0),QTY307=ISNULL(QTY307,0),QTY308=ISNULL(QTY308,0),QTY309=ISNULL(QTY309,0),QTY310=ISNULL(QTY310,0),QTY311=ISNULL(QTY311,0),QTY312=ISNULL(QTY312,0),QTY313=ISNULL(QTY313,0),QTY314=ISNULL(QTY314,0),QTY315=ISNULL(QTY315,0),QTY316=ISNULL(QTY316,0),QTY317=ISNULL(QTY317,0),QTY318=ISNULL(QTY318,0),QTY319=ISNULL(QTY319,0),QTY320=ISNULL(QTY320,0),QTY321=ISNULL(QTY321,0),QTY322=ISNULL(QTY322,0),QTY323=ISNULL(QTY323,0),QTY324=ISNULL(QTY324,0),QTY325=ISNULL(QTY325,0),QTY326=ISNULL(QTY326,0),QTY327=ISNULL(QTY327,0),QTY328=ISNULL(QTY328,0),QTY329=ISNULL(QTY329,0),QTY330=ISNULL(QTY330,0),QTY331=ISNULL(QTY331,0),QTY332=ISNULL(QTY332,0),QTY333=ISNULL(QTY333,0),QTY334=ISNULL(QTY334,0),QTY335=ISNULL(QTY335,0),QTY336=ISNULL(QTY336,0),QTY337=ISNULL(QTY337,0),QTY338=ISNULL(QTY338,0),QTY339=ISNULL(QTY339,0),QTY340=ISNULL(QTY340,0),QTY341=ISNULL(QTY341,0),QTY342=ISNULL(QTY342,0),QTY343=ISNULL(QTY343,0),QTY344=ISNULL(QTY344,0),QTY345=ISNULL(QTY345,0),QTY346=ISNULL(QTY346,0),QTY347=ISNULL(QTY347,0),QTY348=ISNULL(QTY348,0),QTY349=ISNULL(QTY349,0),QTY350=ISNULL(QTY350,0),QTY351=ISNULL(QTY351,0),QTY352=ISNULL(QTY352,0),QTY353=ISNULL(QTY353,0),QTY354=ISNULL(QTY354,0),QTY355=ISNULL(QTY355,0),QTY356=ISNULL(QTY356,0),QTY357=ISNULL(QTY357,0),QTY358=ISNULL(QTY358,0),QTY359=ISNULL(QTY359,0),QTY360=ISNULL(QTY360,0),QTY361=ISNULL(QTY361,0),QTY362=ISNULL(QTY362,0),QTY363=ISNULL(QTY363,0),QTY364=ISNULL(QTY364,0)
			 WHERE QTY001 IS NULL

			

--			-- 중복 오류 보정 :: PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 추가 - start
--            DELETE TBL 
--                --  SELECT * 
--                  FROM
--	                (
--	                        SELECT
--	                               ROW_NUMBER() OVER (PARTITION BY CELL_ITEM_ID,ITEM_ID,NICK_NAME,TO_SITE,PROJECT_CODE,INCOTERMS,FROM_SITE,TRANSPORT_MODE,PROD_LINE  ORDER BY BOD_ID DESC) AS ROWNUM
----                                 ,*
--	                        FROM SCP_XLS_PSI_GLOBAL_ESS  WITH (NOLOCK)
--                          WHERE MEASURE IN ('SHIP_REQ', 'SHIP_PLAN')		        -- * 2021.06.03   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 SHIP_PLAN 추가
--						    AND CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.06.03   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가

--	                ) AS TBL
--	                WHERE TBL.ROWNUM > 1
--			-- 중복 오류 보정 :: PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 추가 - end

            UPDATE X
                  SET X.FROM_BOH_QTY = ISNULL(X.FROM_BOH_QTY,0) -   
                                      (ISNULL(WQTY01,0)+ISNULL(WQTY02,0)+ISNULL(WQTY03,0)+ISNULL(WQTY04,0)+ISNULL(WQTY05,0)+ISNULL(WQTY06,0)+ISNULL(WQTY07,0)+ISNULL(WQTY08,0)+ISNULL(WQTY09,0)+ISNULL(WQTY10,0)
                                                            +ISNULL(WQTY11,0)+ISNULL(WQTY12,0)+ISNULL(WQTY13,0)+ISNULL(WQTY14,0)+ISNULL(WQTY15,0)+ISNULL(WQTY16,0)+ISNULL(WQTY17,0)+ISNULL(WQTY18,0)+ISNULL(WQTY19,0)+ISNULL(WQTY20,0)
                                                            +ISNULL(WQTY21,0)+ISNULL(WQTY22,0)+ISNULL(WQTY23,0)+ISNULL(WQTY24,0)+ISNULL(WQTY25,0)+ISNULL(WQTY26,0)+ISNULL(WQTY27,0)+ISNULL(WQTY28,0)+ISNULL(WQTY29,0)+ISNULL(WQTY30,0)
                                                            +ISNULL(WQTY31,0)+ISNULL(WQTY32,0)+ISNULL(WQTY33,0)+ISNULL(WQTY34,0)+ISNULL(WQTY35,0)+ISNULL(WQTY36,0)+ISNULL(WQTY37,0)+ISNULL(WQTY38,0)+ISNULL(WQTY39,0)+ISNULL(WQTY40,0)
                                                            +ISNULL(WQTY41,0)+ISNULL(WQTY42,0)+ISNULL(WQTY43,0)+ISNULL(WQTY44,0)+ISNULL(WQTY45,0)+ISNULL(WQTY46,0)+ISNULL(WQTY47,0)+ISNULL(WQTY48,0)+ISNULL(WQTY49,0)+ISNULL(WQTY50,0)
                                                            +ISNULL(WQTY51,0)+ISNULL(WQTY52,0)
                                       )                     
                  FROM SCP_XLS_PSI_GLOBAL_ESS X  WITH (NOLOCK)
                  WHERE MEASURE ='CELL_FORM_HOLD_AFTER'
				  AND CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.04.30   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가


      

				----------------------------------------------------
				-- DC.Link 적용 - ATTRIBUTE6 update - start
				----------------------------------------------------
				UPDATE SCP_XLS_PSI_GLOBAL_ESS
				   SET ATTRIBUTE6 = NULL
				 WHERE ATTRIBUTE6 IS NOT NULL
				   AND CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- 2022.08.23  :: 중장기 플랜에서 +52 주에만 ATTRIBUTE6 에 dc link 정보가 세팅되는 오류 수정
				 ;

				UPDATE X
				   SET X.ATTRIBUTE6 = (CASE WHEN X.ITEM_ID = Z.MODULE_ID THEN '1' ELSE '2' END) + '::' + Z.MODULE_ID
				  FROM SCP_XLS_PSI_GLOBAL_ESS X WITH (NOLOCK)
				INNER JOIN (
                            SELECT * FROM 
                            (
                              SELECT distinct z.model_id as item_id, z.child_item_id as cell_item_id, z.accumulated_child_qty as cell_qty_pack, y.module_id, y.module_qty_pack
                              -- E20260618-001229 ESS 시뮬레이터 중복 키값 호출 로직 추가 시작
                              , ROW_NUMBER() OVER(PARTITION BY Z.CHILD_ITEM_ID   ORDER BY Z.CHILD_ITEM_ID , MODULE_ID  ) AS RN
                              -- E20260618-001229 ESS 시뮬레이터 중복 키값 호출 로직 추가 끝
							  FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V z WITH(NOLOCK),
								   ( SELECT x.DIVISION_ID, x.model_id, x.child_item_id as module_id, x.child_qty as module_qty_pack
									   FROM dbo.scm_mst_bom_sn_V x WITH(NOLOCK)	--2021-03-09	SCP 대치 BOM 적용
											INNER JOIN dbo.scm_mst_item_sn i WITH(NOLOCK)
											ON  x.child_division_id = i.division_id
											AND x.child_item_id     = i.item_id
											--AND I.FLOW_ID = 'P5200'
											AND x.child_company_id  = i.company_id -- A002 빈강 추가 따른 조건 추가
											AND x.child_site_id     = i.site_id
											AND i.active_flag       = 'Y'           
									  WHERE 1=1
										AND x.child_item_id IN (SELECT DISTINCT ITEM_ID 
															  FROM SCM_MST_FINAL_ITEM_V with (nolock)
															 WHERE DIVISION_ID = @p_division_id
															   AND OPERATION_GROUP_ID = 'P'
															   AND DC_YN = 'Y'
															   AND ITEM_ID IN (SELECT DISTINCT ITEM_ID FROM SCP_XLS_PSI_GLOBAL_ESS X WITH (NOLOCK) WHERE MEASURE = 'PACK_PROD'))
									) Y
							 WHERE z.DIVISION_ID        = Y.DIVISION_ID
								AND z.MODEL_ID           = Y.model_id
								AND z.OPERATION_GROUP_ID = 'P'
                           -- E20260618-001229 ESS 시뮬레이터 중복 키값 호출 로직 추가 시작
                           ) AS Z_R WHERE RN = 1
                           -- E20260618-001229 ESS 시뮬레이터 중복 키값 호출 로직 추가 끝
						   ) Z
					 ON X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd
					AND X.OPERATION_GROUP    = 'P'
					--AND Z.MODULE_ID IN (SELECT DISTINCT ITEM_ID 
					--					  FROM SCM_MST_FINAL_ITEM_V with (nolock)
					--					 WHERE DIVISION_ID = @p_division_id
					--					   AND OPERATION_GROUP_ID = 'P'
					--					   AND DC_YN = 'Y'
					--					   AND ITEM_ID IN (SELECT DISTINCT ITEM_ID FROM SCP_XLS_PSI_GLOBAL_ESS X WITH (NOLOCK) WHERE MEASURE = 'PACK_PROD'))
					AND X.ITEM_ID   = Z.cell_item_id			    
				;

				-- DC.Link 적용 - ATTRIBUTE6 update :: 동종 모델을 사용하는 DC link 모델 추가
				-- 2022.05.24 동종모델 건수만큼 반복수행
				DECLARE @v_dc_cnt		integer = 0;
				DECLARE @v_add_cnt   	integer = 0;

				SELECT @v_dc_cnt = COUNT(ITEM_ID)
				  FROM (
						SELECT DISTINCT ITEM_ID 
						  FROM SCM_MST_FINAL_ITEM_V with (nolock)
						 WHERE DIVISION_ID = @p_division_id
						   AND OPERATION_GROUP_ID = 'P'
						   AND DC_YN = 'Y'
						   AND ITEM_ID IN (SELECT DISTINCT ITEM_ID FROM SCP_XLS_PSI_GLOBAL_ESS X WITH (NOLOCK) WHERE MEASURE = 'PACK_PROD')
						) X
						;

				IF @V_DC_CNT > 8 
				BEGIN
				   SET @V_DC_CNT = 8
				END

				WHILE @v_add_cnt < @v_dc_cnt
				BEGIN
					UPDATE X
					   SET X.ATTRIBUTE6 = (CASE WHEN X.ATTRIBUTE6 IS NULL THEN (CASE WHEN X.ITEM_ID = Z.MODULE_ID THEN '1' ELSE '2' END) + '::' + Z.MODULE_ID
												ELSE X.ATTRIBUTE6 + '|' + (CASE WHEN X.ITEM_ID = Z.MODULE_ID THEN '1' ELSE '2' END) + '::' + Z.MODULE_ID
										   END)
					  FROM SCP_XLS_PSI_GLOBAL_ESS X WITH (NOLOCK)
					  -- 2025.09.02	kimcd		속도 개선 HASH 추가
					INNER HASH JOIN (SELECT distinct z.model_id as item_id, z.child_item_id as cell_item_id, z.accumulated_child_qty as cell_qty_pack, y.module_id, y.module_qty_pack
								  FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V z WITH(NOLOCK),
									   ( SELECT x.DIVISION_ID, x.model_id, x.child_item_id as module_id, x.child_qty as module_qty_pack
										   FROM dbo.scm_mst_bom_sn_V x WITH(NOLOCK)	--2021-03-09	SCP 대치 BOM 적용
												INNER JOIN dbo.scm_mst_item_sn i WITH(NOLOCK)
												ON  x.child_division_id = i.division_id
												AND x.child_item_id     = i.item_id
												--AND I.FLOW_ID = 'P5200'
												AND x.child_company_id  = i.company_id -- A002 빈강 추가 따른 조건 추가
												AND x.child_site_id     = i.site_id
												AND i.active_flag       = 'Y'           
										  WHERE 1=1
											AND x.child_item_id IN (SELECT DISTINCT ITEM_ID 
																  FROM SCM_MST_FINAL_ITEM_V with (nolock)
																 WHERE DIVISION_ID = @p_division_id
																   AND OPERATION_GROUP_ID = 'P'
																   AND DC_YN = 'Y'
																   AND ITEM_ID IN (SELECT DISTINCT ITEM_ID FROM SCP_XLS_PSI_GLOBAL_ESS X WITH (NOLOCK) WHERE MEASURE = 'PACK_PROD'))
										) Y
								 WHERE z.DIVISION_ID        = Y.DIVISION_ID
									AND z.MODEL_ID           = Y.model_id
									AND z.OPERATION_GROUP_ID = 'P'
							   ) Z
						 ON X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd
						AND X.OPERATION_GROUP    = 'P'
						--AND Z.MODULE_ID IN (SELECT DISTINCT ITEM_ID 
						--					  FROM SCM_MST_FINAL_ITEM_V with (nolock)
						--					 WHERE DIVISION_ID = @p_division_id
						--					   AND OPERATION_GROUP_ID = 'P'
						--					   AND DC_YN = 'Y'
						--					   AND ITEM_ID IN (SELECT DISTINCT ITEM_ID FROM SCP_XLS_PSI_GLOBAL_ESS X WITH (NOLOCK) WHERE MEASURE = 'PACK_PROD'))
						AND X.ITEM_ID   = Z.cell_item_id		
						AND LEFT(X.ATTRIBUTE6, 1) <> '1'
						AND CHARINDEX( ((CASE WHEN X.ITEM_ID = Z.MODULE_ID THEN '1' ELSE '2' END) + '::' + Z.MODULE_ID), X.ATTRIBUTE6, 1) = 0

					SET @v_add_cnt = @v_add_cnt + 1;
								
				END;

				-- DC. Link 고객향 semi intransit 삭제
				DELETE X
				  FROM SCP_XLS_PSI_GLOBAL_ESS X WITH (NOLOCK),
					   SCM_MST_SITE M WITH (NOLOCK)
				 WHERE X.MEASURE IN ('SEMI_INTRANSIT_ETA', 'SEMI_INTRANSIT')
				   AND X.OPERATION_GROUP = 'P'
				   AND X.ATTRIBUTE6 IS NOT NULL
				   AND M.SCM_SITE_ID = X.TO_SITE
				   AND M.SITE_TYPE = 'SALES'
				   ;
				-- DC.Link 적용 - ATTRIBUTE6 update - end

				-- 복수 BOD 수립관련건 적용 :: 2022.04.18 - SHIP_REQ 삭제 - START
				DELETE X
				  FROM SCP_XLS_PSI_GLOBAL_ESS X WITH (NOLOCK),
					   #BOD_OTHER_SHIP_PLAN B WITH (NOLOCK)
				 WHERE X.ITEM_ID      = B.ITEM_ID
				   AND X.FROM_SITE    = B.FROM_SITE
				   AND X.TO_SITE      = B.TO_SITE
				   AND X.BOD_ID       = B.BOD_ID
				   AND X.PROJECT_CODE = B.PROJECT_CODE
				   AND X.INCOTERMS    = B.INCOTERMS
				   AND X.MEASURE      = 'SHIP_REQ'
				   AND X.OPERATION_GROUP = 'P'
				   ;
				-- 복수 BOD 수립관련건 적용 :: 2022.04.18 - SHIP_REQ 삭제 - END


      
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
