  
/*      
 * Program ID   : PR_SCP_XLS_PSI_GLOBAL_SMALL_CELL_S        
 * Description  : PR_SCP_XLS_CREATE_DATA 에서 호출함.      
 * OutTable     :      
 * Execute      : 
    -- DELETE FROM SCM_SYS_LOG_BATCH where CREATED_BY ='kth'
    EXEC PR_SCP_XLS_PSI_GLOBAL_SMALL_CELL_S
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
    SELECT * FROM SCM_SYS_LOG_BATCH  where PROGRAM_NAME ='PR_SCP_XLS_PSI_GLOBAL_SMALL_CELL_S' order by CREATION_DATE desc

 * Program History      
 *===================================================================================================      
 *   Date       In Charge      Description      
 *===================================================================================================      
 * 2021.05.25   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전으로 신규생성
                            - 구 버전에서 PIVOT 생성단계 이후 단계를 호출하는 로직으로 분리함 (1 YEAR 구간별 생성 :: 중장기 구현시 컬럼 및 행 SIZE 제약 해결)
 * 2026.07.24   YMH         E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
 */    

--DROP PROC dbo.PR_SCP_XLS_PSI_GLOBAL_SMALL_CELL_S
CREATE PROCEDURE [dbo].[PR_SCP_XLS_PSI_GLOBAL_SMALL_CELL_S]
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
    , @p_update               NVARCHAR(4000)  = 'N'
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
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_XLS_PSI_GLOBAL_SMALL_CELL_S';      
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

    DECLARE @p_program_id   NVARCHAR(30) = 'XLSPSI03'          
    --DECLARE @p_to_yyyymmdd  VARCHAR(8)   =  CONVERT(VARCHAR(8), DATEADD(day, 364, @p_plan_start_yyyymmdd), 112)
    --DECLARE @p_cutoff_date  VARCHAR(8)   =  CONVERT(VARCHAR(8), DATEADD(day,  -1, @p_plan_start_yyyymmdd), 112)

    DECLARE @v_Max_xls_key1 INTEGER = 0;  -- @p_update가 'Y' 일경우  전체 xls_key1 MAX

    IF @p_update = 'Y'
      BEGIN
        SELECT @v_Max_xls_key1 = ISNULL(MAX(xls_key1),0) +1
          FROM SCP_XLS_PSI_GLOBAL_SMALL_CELL  WITH (NOLOCK)
      END

    --DECLARE @debug_mode            NVARCHAR(30) = 'T'
        BEGIN TRY        
          BEGIN        

            -------------------------------------------------------------------------------------------------------------         
            -- Line Load 율 - 1 YEAR 단위로 분리하기가 어려워 개발 생성 처리한다.
            -------------------------------------------------------------------------------------------------------------            
              IF OBJECT_ID('tempdb..#LineLoad') IS NOT NULL     
	              DROP TABLE #LineLoad;   

			          SELECT /*DISTINCT */
						          A.DIVISION_ID
					          , A.SCM_SITE_ID AS SITE_ID
                    , A.OPERATION_GROUP
		                , A.OPERATION_ID
		                , A.LINE_ID AS PROD_LINE
					          , 'PROD_LOAD' AS MEASURE
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
	                AND A.MEASURE             = 'PROD_PLAN_AMEND'
                  AND A.OPERATION_GROUP     = 'A'
              GROUP BY A.DIVISION_ID, A.SCM_SITE_ID ,A.OPERATION_ID ,A.LINE_ID, A.YYYYMMDD, D.WORKING_TIME,  C.ISO_YYYYWW,A.OPERATION_GROUP
			   

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
            -- 전체 임시 테이블 생성  (#SCP_XLS_PSI_GLOBAL_SMALL_CELL)
            -------------------------------------------------------------------------------------------------------------  
                IF OBJECT_ID('tempdb..#SCP_XLS_PSI_GLOBAL_SMALL_CELL') IS NOT NULL	
	                  DROP TABLE #SCP_XLS_PSI_GLOBAL_SMALL_CELL

              --DROP TABLE #SCP_XLS_PSI_GLOBAL_SMALL_CELLL
              CREATE TABLE #SCP_XLS_PSI_GLOBAL_SMALL_CELL(
	              DIVISION_ID           NVARCHAR(030)     NULL,
	              PLAN_START_YYYYMMDD   NVARCHAR(008)     NULL,
	              PLAN_TYPE             NVARCHAR(050)     NULL,
	              SEQ                   BIGINT            NULL,
                CELL_TYPE_GROUP_CODE  NVARCHAR(001)     NULL,
                CELL_ITEM_ID          NVARCHAR(050)     NULL,
	              NICK_NAME             NVARCHAR(200)     NULL,
                MEASURE               NVARCHAR(050)     NULL,
	              MEASURE_LABEL         NVARCHAR(150)     NULL,   -- COLUMN_LABEL_NAME
	              SITE_ID               NVARCHAR(030)     NULL,
	              SITE_DESCRIPTION      NVARCHAR(150)     NULL,   -- SCM_SITE_DESCRIPTION
                PROD_LINE             NVARCHAR(050)     NULL,
	              YIELD                 NUMERIC(20, 10)   NULL,
	              LT_WEEK               NUMERIC(20, 10)   NULL,
                BOH                   NUMERIC(20, 10)   NULL,
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

                QTY151  NUMERIC (20,10) NULL, QTY152  NUMERIC (20,10) NULL, QTY153  NUMERIC (20,10) NULL, QTY154 NUMERIC (20,10) NULL,  QTY155  NUMERIC (20,10) NULL,
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
            -- 전체 DATA 생성 (#PSI_GLOBAL_SMALL_CELL --> #SCP_XLS_PSI_GLOBAL_SMALL_CELL) PIVOT
            -------------------------------------------------------------------------------------------------------------
              DECLARE @mEXEC NVARCHAR(MAX);

		          SET @mEXEC = '';
              SET @mEXEC = @mEXEC + ' INSERT INTO #SCP_XLS_PSI_GLOBAL_SMALL_CELL WITH (TABLOCK)  '+CHAR(10);	

		          SET @mEXEC = @mEXEC + ' SELECT A.DIVISION_ID														
                                            , ''' + @p_plan_start_yyyymmdd +'''	  AS PLAN_START_YYYYMMDD
                                            , ''' + @p_plan_type +'''	            AS PLAN_TYPE
                                            , ''' + @p_seq +'''	                  AS SEQ
                              		          , A.CELL_TYPE_GROUP_CODE						
                                            , A.CELL_ITEM_ID							
                                            , (SELECT TOP 1 (CASE WHEN X.NICK_NAME IS NULL THEN ''-''  WHEN X.NICK_NAME = ''''    THEN ''-''  ELSE X.NICK_NAME END) FROM DBO.SCM_MST_ITEM_SN X WITH (NOLOCK)  WHERE  X.ITEM_ID  = A.CELL_ITEM_ID) AS NICK_NAME
	
                                            , A.MEASURE
                                            , A.COLUMN_LABEL_NAME           AS MEASURE_LABEL 
                              		          , A.SITE_ID							
                              		          , ISNULL(NULLIF( (SELECT TOP 1 M.SITE_DESCRIPTION FROM SCM_MST_SITE M WITH (NOLOCK) WHERE M.SCM_SITE_ID=A.SITE_ID), '''') , ''-'') AS SITE_DESCRIPTION	
                                            , ISNULL(A.PROD_LINE,''-'')  AS      PROD_LINE    
                                            , ISNULL(A.YIELD,''0'')     AS      YIELD     
                              		          , ''0'' AS LT_WEEK
                                            , A.BOH '+CHAR(10);	
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
              SET @mEXEC = @mEXEC + '       , NULL AS ATTRIBUTE2, 0 AS ATTRIBUTE3, NULL AS ATTRIBUTE4, NULL AS ATTRIBUTE5, NULL AS ATTRIBUTE6, NULL AS ATTRIBUTE7, NULL AS ATTRIBUTE8'+CHAR(10);	
              SET @mEXEC = @mEXEC + '       , A.ATTRIBUTE9, NULL AS ATTRIBUTE10    '+CHAR(10);	
  	          SET @mEXEC = @mEXEC + ' 		FROM #PSI_GLOBAL_SMALL_CELL A WITH (NOLOCK)		'+CHAR(10);
			  SET @mEXEC = @mEXEC + '	   WHERE A.YYYYMMDD    >= ''' + @p_create_from_yyyymmdd + ''''+CHAR(10);
			  SET @mEXEC = @mEXEC + '	     AND A.YYYYMMDD    <= ''' + @p_create_to_yyyymmdd   + ''''+CHAR(10);
	          SET @mEXEC = @mEXEC + '         GROUP BY  A.DIVISION_ID							
	                            			              , A.CELL_TYPE_GROUP_CODE							
                                                  , A.CELL_ITEM_ID	
	                            			              , A.MEASURE			
	                            			              , A.COLUMN_LABEL_NAME						
	                            			              , A.SITE_ID									
                                                  , ISNULL(A.PROD_LINE,''-'') 
                                                  , A.YIELD
	                            			              , A.MEASURE										
	                            			              , A.SORT_ORDER_NO							
                                                  , A.BOH							
                                                  , A.ATTRIBUTE1
                                                  , A.ATTRIBUTE9
                                                  '+CHAR(10);

            EXEC sp_executesql @mEXEC;          
            
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
            -- LINE_ID 추가
            -------------------------------------------------------------------------------------------------------------            
            -- 'SHIP_PLAN'의 LINE_ID 종류 별 추가 
               INSERT INTO #SCP_XLS_PSI_GLOBAL_SMALL_CELL                          
                      SELECT DISTINCT X.DIVISION_ID
                      ,X.PLAN_START_YYYYMMDD
                      ,X.PLAN_TYPE
                      ,X.SEQ
                      ,X.CELL_TYPE_GROUP_CODE
                      ,X.CELL_ITEM_ID
                      ,X.NICK_NAME
                      ,X.MEASURE
                      ,X.MEASURE_LABEL
                      ,Y.PLANT_SITE_ID AS SITE_ID
                      , ISNULL(NULLIF( (SELECT TOP 1 M.SITE_DESCRIPTION FROM SCM_MST_SITE M  WITH (NOLOCK) WHERE M.SCM_SITE_ID=Y.PLANT_SITE_ID), '') , '-') AS SITE_DESCRIPTION	
                      ,Y.LINE_ID AS PROD_LINE
                      ,X.YIELD
                      ,X.LT_WEEK
                      ,X.BOH
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
                      FROM #SCP_XLS_PSI_GLOBAL_SMALL_CELL X WITH (NOLOCK) 
                      CROSS APPLY #MST_TACT_TIME Y  WITH (NOLOCK)
                      WHERE 0 = 0
                      AND X.DIVISION_ID   = Y.DIVISION_ID
                      AND X.CELL_ITEM_ID  = Y.ITEM_ID
                      AND X.MEASURE       = 'PROD'
                      AND NOT EXISTS (                
                                            SELECT 'X'                
                                              FROM #SCP_XLS_PSI_GLOBAL_SMALL_CELL Z WITH(NOLOCK)                
                                             WHERE 1=1                
                                               AND Z.DIVISION_ID          = X.DIVISION_ID                
                                               AND Z.CELL_ITEM_ID         = X.CELL_ITEM_ID              
                                               AND Z.MEASURE              = X.MEASURE 
                                               AND Z.SITE_ID              = Y.PLANT_SITE_ID
                                               AND Z.PROD_LINE            = Y.LINE_ID
                                               AND Z.MEASURE              ='PROD'
                                               )
                    UNION 
                    SELECT DISTINCT X.DIVISION_ID
                      ,X.PLAN_START_YYYYMMDD
                      ,X.PLAN_TYPE
                      ,X.SEQ
                      ,X.CELL_TYPE_GROUP_CODE
                      ,X.CELL_ITEM_ID
                      ,X.NICK_NAME
                      ,'PROD_LOAD' AS MEASURE
                      ,'Load Rate' AS MEASURE_LABEL
                      ,Y.PLANT_SITE_ID AS  SITE_ID
                      , ISNULL(NULLIF( (SELECT TOP 1 M.SITE_DESCRIPTION FROM SCM_MST_SITE M  WITH (NOLOCK) WHERE M.SCM_SITE_ID=Y.PLANT_SITE_ID), '') , '-') AS SITE_DESCRIPTION	
                      ,Y.LINE_ID AS PROD_LINE
                      ,X.YIELD
                      ,X.LT_WEEK
                      ,X.BOH
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
                      ,0  AS QTY001 ,0  AS QTY002,0  AS QTY003,0  AS QTY004,0  AS QTY005,0  AS QTY006 ,0 AS QTY007,0  AS QTY008,0  AS QTY009,0  AS QTY010
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
                      ,'PROD_LOAD' AS ATTRIBUTE10
                     FROM #SCP_XLS_PSI_GLOBAL_SMALL_CELL X WITH (NOLOCK) 
                      CROSS APPLY #MST_TACT_TIME Y  WITH (NOLOCK)
                      WHERE 0 = 0
                      AND X.DIVISION_ID   = Y.DIVISION_ID
                      AND X.CELL_ITEM_ID  = Y.ITEM_ID
                      AND X.MEASURE       = 'PROD'
                      AND NOT EXISTS (                
                                            SELECT 'X'                
                                              FROM #SCP_XLS_PSI_GLOBAL_SMALL_CELL Z WITH(NOLOCK)                
                                             WHERE 1=1                
                                               AND Z.DIVISION_ID          = X.DIVISION_ID                
                                               AND Z.CELL_ITEM_ID         = X.CELL_ITEM_ID              
                                               AND Z.MEASURE              = X.MEASURE 
                                               AND Z.SITE_ID              = Y.PLANT_SITE_ID
                                               AND Z.PROD_LINE            = Y.LINE_ID
                                               AND Z.MEASURE              ='PROD'     
                                               )
                      
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
            --  보정 추가된 PROD_LOAD 반영
            -------------------------------------------------------------------------------------------------------------
            -------------------------------------------------------------------------------------------------------------         
            -- PROD_LOAD PIVOT 테이블 생성
            -------------------------------------------------------------------------------------------------------------  
                IF OBJECT_ID('tempdb..#LineLoad_Pivot') IS NOT NULL	
	                  DROP TABLE #LineLoad_Pivot

                    --DROP TABLE #LineLoad_Pivot
                    CREATE TABLE #LineLoad_Pivot(
	                    DIVISION_ID           NVARCHAR(030)     NULL,
	                    SITE_ID               NVARCHAR(030)     NULL,
	                    OPERATION_ID          NVARCHAR(030)     NULL,
                      PROD_LINE             NVARCHAR(050)     NULL,
	                    MEASURE               NVARCHAR(200)     NULL,
                      QTY001  NUMERIC (20,10) NULL, QTY002  NUMERIC (20,10) NULL, QTY003  NUMERIC (20,10) NULL, QTY004 NUMERIC (20,10) NULL,  QTY005  NUMERIC (20,10) NULL, 
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

                      QTY151  NUMERIC (20,10) NULL, QTY152  NUMERIC (20,10) NULL, QTY153  NUMERIC (20,10) NULL, QTY154 NUMERIC (20,10) NULL,  QTY155  NUMERIC (20,10) NULL,
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
                    ) 

--                    DECLARE @mEXEC NVARCHAR(MAX);
                    SET @mEXEC = '';
                    SET @mEXEC = @mEXEC + ' INSERT INTO #LineLoad_Pivot WITH (TABLOCK)  '+CHAR(10);	

	                  SET @mEXEC = @mEXEC + ' SELECT A.DIVISION_ID	, A.SITE_ID, A.OPERATION_ID,A.PROD_LINE, A.MEASURE	 '+CHAR(10);	
                    SET @mEXEC = @mEXEC + ' 				' + @mQry_sum +'									'+CHAR(10);	
                    SET @mEXEC = @mEXEC + ' 		FROM #LineLoad A WITH (NOLOCK)			'+CHAR(10);	
                    SET @mEXEC = @mEXEC + '  GROUP BY A.DIVISION_ID	, A.SITE_ID, A.OPERATION_ID,A.PROD_LINE, A.MEASURE								'+CHAR(10);	

                    --PRINT @mEXEC 
                    EXEC sp_executesql @mEXEC;

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

                    UPDATE X
                    SET 
                         X.QTY001 = Y.QTY001 ,X.QTY002  = Y.QTY002 ,X.QTY003 = Y.QTY003 ,X.QTY004 = Y.QTY004 ,X.QTY005  = Y.QTY005 ,X.QTY006  = Y.QTY006  ,X.QTY007 = Y.QTY007
                        ,X.QTY008 = Y.QTY008 ,X.QTY009  = Y.QTY009 ,X.QTY010 = Y.QTY010 ,X.QTY011 = Y.QTY011 ,X.QTY012  = Y.QTY012 ,X.QTY013  = Y.QTY013  ,X.QTY014 = Y.QTY014
                        ,X.QTY015 = Y.QTY015 ,X.QTY016  = Y.QTY016 ,X.QTY017 = Y.QTY017 ,X.QTY018 = Y.QTY018 ,X.QTY019  = Y.QTY019 ,X.QTY020  = Y.QTY020  ,X.QTY021 = Y.QTY021
                        ,X.QTY022 = Y.QTY022 ,X.QTY023  = Y.QTY023 ,X.QTY024 = Y.QTY024 ,X.QTY025 = Y.QTY025 ,X.QTY026  = Y.QTY026 ,X.QTY027  = Y.QTY027  ,X.QTY028 = Y.QTY028
                        ,X.QTY029 = Y.QTY029 ,X.QTY030  = Y.QTY030 ,X.QTY031 = Y.QTY031 ,X.QTY032 = Y.QTY032 ,X.QTY033  = Y.QTY033 ,X.QTY034  = Y.QTY034  ,X.QTY035 = Y.QTY035
                        ,X.QTY036 = Y.QTY036 ,X.QTY037  = Y.QTY037 ,X.QTY038 = Y.QTY038 ,X.QTY039 = Y.QTY039 ,X.QTY040  = Y.QTY040 ,X.QTY041  = Y.QTY041  ,X.QTY042 = Y.QTY042
                        ,X.QTY043 = Y.QTY043 ,X.QTY044  = Y.QTY044 ,X.QTY045 = Y.QTY045 ,X.QTY046 = Y.QTY046 ,X.QTY047  = Y.QTY047 ,X.QTY048  = Y.QTY048  ,X.QTY049 = Y.QTY049
                        ,X.QTY050 = Y.QTY050 ,X.QTY051  = Y.QTY051 ,X.QTY052 = Y.QTY052 ,X.QTY053 = Y.QTY053 ,X.QTY054  = Y.QTY054 ,X.QTY055  = Y.QTY055  ,X.QTY056 = Y.QTY056
                        ,X.QTY057 = Y.QTY057 ,X.QTY058  = Y.QTY058 ,X.QTY059 = Y.QTY059 ,X.QTY060 = Y.QTY060 ,X.QTY061  = Y.QTY061 ,X.QTY062  = Y.QTY062  ,X.QTY063 = Y.QTY063
                        ,X.QTY064 = Y.QTY064 ,X.QTY065  = Y.QTY065 ,X.QTY066 = Y.QTY066 ,X.QTY067 = Y.QTY067 ,X.QTY068  = Y.QTY068 ,X.QTY069  = Y.QTY069  ,X.QTY070 = Y.QTY070
                        ,X.QTY071 = Y.QTY071 ,X.QTY072  = Y.QTY072 ,X.QTY073 = Y.QTY073 ,X.QTY074 = Y.QTY074 ,X.QTY075  = Y.QTY075 ,X.QTY076  = Y.QTY076  ,X.QTY077 = Y.QTY077
                        ,X.QTY078 = Y.QTY078 ,X.QTY079  = Y.QTY079 ,X.QTY080 = Y.QTY080 ,X.QTY081 = Y.QTY081 ,X.QTY082  = Y.QTY082 ,X.QTY083  = Y.QTY083  ,X.QTY084 = Y.QTY084
                        ,X.QTY085 = Y.QTY085 ,X.QTY086  = Y.QTY086 ,X.QTY087 = Y.QTY087 ,X.QTY088 = Y.QTY088 ,X.QTY089  = Y.QTY089 ,X.QTY090  = Y.QTY090  ,X.QTY091 = Y.QTY091
                        ,X.QTY092 = Y.QTY092 ,X.QTY093  = Y.QTY093 ,X.QTY094 = Y.QTY094 ,X.QTY095 = Y.QTY095 ,X.QTY096  = Y.QTY096 ,X.QTY097  = Y.QTY097  ,X.QTY098 = Y.QTY098
                        ,X.QTY099 = Y.QTY099 ,X.QTY100  = Y.QTY100 ,X.QTY101 = Y.QTY101 ,X.QTY102 = Y.QTY102 ,X.QTY103  = Y.QTY103 ,X.QTY104  = Y.QTY104  ,X.QTY105 = Y.QTY105
                        ,X.QTY106 = Y.QTY106 ,X.QTY107  = Y.QTY107 ,X.QTY108 = Y.QTY108 ,X.QTY109 = Y.QTY109 ,X.QTY110  = Y.QTY110 ,X.QTY111  = Y.QTY111  ,X.QTY112 = Y.QTY112
                        ,X.QTY113 = Y.QTY113 ,X.QTY114  = Y.QTY114 ,X.QTY115 = Y.QTY115 ,X.QTY116 = Y.QTY116 ,X.QTY117  = Y.QTY117 ,X.QTY118  = Y.QTY118  ,X.QTY119 = Y.QTY119
                        ,X.QTY120 = Y.QTY120 ,X.QTY121  = Y.QTY121 ,X.QTY122 = Y.QTY122 ,X.QTY123 = Y.QTY123 ,X.QTY124  = Y.QTY124 ,X.QTY125  = Y.QTY125  ,X.QTY126 = Y.QTY126
                        ,X.QTY127 = Y.QTY127 ,X.QTY128  = Y.QTY128 ,X.QTY129 = Y.QTY129 ,X.QTY130 = Y.QTY130 ,X.QTY131  = Y.QTY131 ,X.QTY132  = Y.QTY132  ,X.QTY133 = Y.QTY133
                        ,X.QTY134 = Y.QTY134 ,X.QTY135  = Y.QTY135 ,X.QTY136 = Y.QTY136 ,X.QTY137 = Y.QTY137 ,X.QTY138  = Y.QTY138 ,X.QTY139  = Y.QTY139  ,X.QTY140 = Y.QTY140
                        ,X.QTY141 = Y.QTY141 ,X.QTY142  = Y.QTY142 ,X.QTY143 = Y.QTY143 ,X.QTY144 = Y.QTY144 ,X.QTY145  = Y.QTY145 ,X.QTY146  = Y.QTY146  ,X.QTY147 = Y.QTY147
                        ,X.QTY148 = Y.QTY148 ,X.QTY149  = Y.QTY149 ,X.QTY150 = Y.QTY150 ,X.QTY151 = Y.QTY151 ,X.QTY152  = Y.QTY152 ,X.QTY153  = Y.QTY153  ,X.QTY154 = Y.QTY154
                        ,X.QTY155 = Y.QTY155 ,X.QTY156  = Y.QTY156 ,X.QTY157 = Y.QTY157 ,X.QTY158 = Y.QTY158 ,X.QTY159  = Y.QTY159 ,X.QTY160  = Y.QTY160  ,X.QTY161 = Y.QTY161
                        ,X.QTY162 = Y.QTY162 ,X.QTY163  = Y.QTY163 ,X.QTY164 = Y.QTY164 ,X.QTY165 = Y.QTY165 ,X.QTY166  = Y.QTY166 ,X.QTY167  = Y.QTY167  ,X.QTY168 = Y.QTY168
                        ,X.QTY169 = Y.QTY169 ,X.QTY170  = Y.QTY170 ,X.QTY171 = Y.QTY171 ,X.QTY172 = Y.QTY172 ,X.QTY173  = Y.QTY173 ,X.QTY174  = Y.QTY174  ,X.QTY175 = Y.QTY175
                        ,X.QTY176 = Y.QTY176 ,X.QTY177  = Y.QTY177 ,X.QTY178 = Y.QTY178 ,X.QTY179 = Y.QTY179 ,X.QTY180  = Y.QTY180 ,X.QTY181  = Y.QTY181  ,X.QTY182 = Y.QTY182
                        ,X.QTY183 = Y.QTY183 ,X.QTY184  = Y.QTY184 ,X.QTY185 = Y.QTY185 ,X.QTY186 = Y.QTY186 ,X.QTY187  = Y.QTY187 ,X.QTY188  = Y.QTY188  ,X.QTY189 = Y.QTY189
                        ,X.QTY190 = Y.QTY190 ,X.QTY191  = Y.QTY191 ,X.QTY192 = Y.QTY192 ,X.QTY193 = Y.QTY193 ,X.QTY194  = Y.QTY194 ,X.QTY195  = Y.QTY195  ,X.QTY196 = Y.QTY196
                        ,X.QTY197 = Y.QTY197 ,X.QTY198  = Y.QTY198 ,X.QTY199 = Y.QTY199 ,X.QTY200 = Y.QTY200 ,X.QTY201  = Y.QTY201 ,X.QTY202  = Y.QTY202  ,X.QTY203 = Y.QTY203
                        ,X.QTY204 = Y.QTY204 ,X.QTY205  = Y.QTY205 ,X.QTY206 = Y.QTY206 ,X.QTY207 = Y.QTY207 ,X.QTY208  = Y.QTY208 ,X.QTY209  = Y.QTY209  ,X.QTY210 = Y.QTY210
                        ,X.QTY211 = Y.QTY211 ,X.QTY212  = Y.QTY212 ,X.QTY213 = Y.QTY213 ,X.QTY214 = Y.QTY214 ,X.QTY215  = Y.QTY215 ,X.QTY216  = Y.QTY216  ,X.QTY217 = Y.QTY217
                        ,X.QTY218 = Y.QTY218 ,X.QTY219  = Y.QTY219 ,X.QTY220 = Y.QTY220 ,X.QTY221 = Y.QTY221 ,X.QTY222  = Y.QTY222 ,X.QTY223  = Y.QTY223  ,X.QTY224 = Y.QTY224
                        ,X.QTY225 = Y.QTY225 ,X.QTY226  = Y.QTY226 ,X.QTY227 = Y.QTY227 ,X.QTY228 = Y.QTY228 ,X.QTY229  = Y.QTY229 ,X.QTY230  = Y.QTY230  ,X.QTY231 = Y.QTY231
                        ,X.QTY232 = Y.QTY232 ,X.QTY233  = Y.QTY233 ,X.QTY234 = Y.QTY234 ,X.QTY235 = Y.QTY235 ,X.QTY236  = Y.QTY236 ,X.QTY237  = Y.QTY237  ,X.QTY238 = Y.QTY238
                        ,X.QTY239 = Y.QTY239 ,X.QTY240  = Y.QTY240 ,X.QTY241 = Y.QTY241 ,X.QTY242 = Y.QTY242 ,X.QTY243  = Y.QTY243 ,X.QTY244  = Y.QTY244  ,X.QTY245 = Y.QTY245
                        ,X.QTY246 = Y.QTY246 ,X.QTY247  = Y.QTY247 ,X.QTY248 = Y.QTY248 ,X.QTY249 = Y.QTY249 ,X.QTY250  = Y.QTY250 ,X.QTY251  = Y.QTY251  ,X.QTY252 = Y.QTY252
                        ,X.QTY253 = Y.QTY253 ,X.QTY254  = Y.QTY254 ,X.QTY255 = Y.QTY255 ,X.QTY256 = Y.QTY256 ,X.QTY257  = Y.QTY257 ,X.QTY258  = Y.QTY258  ,X.QTY259 = Y.QTY259
                        ,X.QTY260 = Y.QTY260 ,X.QTY261  = Y.QTY261 ,X.QTY262 = Y.QTY262 ,X.QTY263 = Y.QTY263 ,X.QTY264  = Y.QTY264 ,X.QTY265  = Y.QTY265  ,X.QTY266 = Y.QTY266
                        ,X.QTY267 = Y.QTY267 ,X.QTY268  = Y.QTY268 ,X.QTY269 = Y.QTY269 ,X.QTY270 = Y.QTY270 ,X.QTY271  = Y.QTY271 ,X.QTY272  = Y.QTY272  ,X.QTY273 = Y.QTY273
                        ,X.QTY274 = Y.QTY274 ,X.QTY275  = Y.QTY275 ,X.QTY276 = Y.QTY276 ,X.QTY277 = Y.QTY277 ,X.QTY278  = Y.QTY278 ,X.QTY279  = Y.QTY279  ,X.QTY280 = Y.QTY280
                        ,X.QTY281 = Y.QTY281 ,X.QTY282  = Y.QTY282 ,X.QTY283 = Y.QTY283 ,X.QTY284 = Y.QTY284 ,X.QTY285  = Y.QTY285 ,X.QTY286  = Y.QTY286  ,X.QTY287 = Y.QTY287
                        ,X.QTY288 = Y.QTY288 ,X.QTY289  = Y.QTY289 ,X.QTY290 = Y.QTY290 ,X.QTY291 = Y.QTY291 ,X.QTY292  = Y.QTY292 ,X.QTY293  = Y.QTY293  ,X.QTY294 = Y.QTY294
                        ,X.QTY295 = Y.QTY295 ,X.QTY296  = Y.QTY296 ,X.QTY297 = Y.QTY297 ,X.QTY298 = Y.QTY298 ,X.QTY299  = Y.QTY299 ,X.QTY300  = Y.QTY300  ,X.QTY301 = Y.QTY301
                        ,X.QTY302 = Y.QTY302 ,X.QTY303  = Y.QTY303 ,X.QTY304 = Y.QTY304 ,X.QTY305 = Y.QTY305 ,X.QTY306  = Y.QTY306 ,X.QTY307  = Y.QTY307  ,X.QTY308 = Y.QTY308
                        ,X.QTY309 = Y.QTY309 ,X.QTY310  = Y.QTY310 ,X.QTY311 = Y.QTY311 ,X.QTY312 = Y.QTY312 ,X.QTY313  = Y.QTY313 ,X.QTY314  = Y.QTY314  ,X.QTY315 = Y.QTY315
                        ,X.QTY316 = Y.QTY316 ,X.QTY317  = Y.QTY317 ,X.QTY318 = Y.QTY318 ,X.QTY319 = Y.QTY319 ,X.QTY320  = Y.QTY320 ,X.QTY321  = Y.QTY321  ,X.QTY322 = Y.QTY322
                        ,X.QTY323 = Y.QTY323 ,X.QTY324  = Y.QTY324 ,X.QTY325 = Y.QTY325 ,X.QTY326 = Y.QTY326 ,X.QTY327  = Y.QTY327 ,X.QTY328  = Y.QTY328  ,X.QTY329 = Y.QTY329
                        ,X.QTY330 = Y.QTY330 ,X.QTY331  = Y.QTY331 ,X.QTY332 = Y.QTY332 ,X.QTY333 = Y.QTY333 ,X.QTY334  = Y.QTY334 ,X.QTY335  = Y.QTY335  ,X.QTY336 = Y.QTY336
                        ,X.QTY337 = Y.QTY337 ,X.QTY338  = Y.QTY338 ,X.QTY339 = Y.QTY339 ,X.QTY340 = Y.QTY340 ,X.QTY341  = Y.QTY341 ,X.QTY342  = Y.QTY342  ,X.QTY343 = Y.QTY343
                        ,X.QTY344 = Y.QTY344 ,X.QTY345  = Y.QTY345 ,X.QTY346 = Y.QTY346 ,X.QTY347 = Y.QTY347 ,X.QTY348  = Y.QTY348 ,X.QTY349  = Y.QTY349  ,X.QTY350 = Y.QTY350
                        ,X.QTY351 = Y.QTY351 ,X.QTY352  = Y.QTY352 ,X.QTY353 = Y.QTY353 ,X.QTY354 = Y.QTY354 ,X.QTY355  = Y.QTY355 ,X.QTY356  = Y.QTY356  ,X.QTY357 = Y.QTY357
                        ,X.QTY358 = Y.QTY358 ,X.QTY359  = Y.QTY359 ,X.QTY360 = Y.QTY360 ,X.QTY361 = Y.QTY361 ,X.QTY362  = Y.QTY362 ,X.QTY363  = Y.QTY363  ,X.QTY364 = Y.QTY364
                  FROM #SCP_XLS_PSI_GLOBAL_SMALL_CELL X WITH (NOLOCK)
                  INNER JOIN #LineLoad_Pivot Y WITH (NOLOCK)
                  ON 0 = 0
                  AND X.DIVISION_ID    =  Y.DIVISION_ID  
                  AND X.SITE_ID        =  Y.SITE_ID      
                  AND X.ATTRIBUTE9     =  Y.OPERATION_ID 
                  AND X.PROD_LINE      =  Y.PROD_LINE    
                  AND X.MEASURE        =  Y.MEASURE    
                  AND X.ATTRIBUTE10    = 'PROD_LOAD'
                  AND X.MEASURE        = 'PROD_LOAD'


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

            -------------------------------------------------------------------------------------------------------------         
            --  삭제 후 입력
            -------------------------------------------------------------------------------------------------------------
            --IF @p_update ='Y'
            --  BEGIN
            --    DELETE FROM SCP_XLS_PSI_GLOBAL_SMALL_CELL                            
            --          WHERE DIVISION_ID = @p_division_id 
            --          AND CELL_ITEM_ID IN (SELECT DISTINCT ITEM_ID FROM SCP_XLS_CELL_PROD_Line_V WITH (NOLOCK) )
            --  END
            --ELSE
            --  BEGIN
            --    DELETE FROM SCP_XLS_PSI_GLOBAL_SMALL_CELL                            
            --        WHERE DIVISION_ID = @p_division_id -- AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND PLAN_TYPE = @p_plan_type AND SEQ = @p_seq                        
            --  END

              INSERT INTO SCP_XLS_PSI_GLOBAL_SMALL_CELL WITH (TABLOCK)
              (
                    DIVISION_ID
					,PLAN_START_YYYYMMDD
					,CREATE_FROM_YYYYMMDD
					,CREATE_TO_YYYYMMDD
					,PLAN_TYPE,SEQ
                    ,CELL_TYPE_GROUP_CODE
                    ,CELL_ITEM_ID
                    ,NICK_NAME
                    ,MEASURE
                    ,MEASURE_LABEL
                    ,SITE_ID,SITE_DESCRIPTION
                    ,PROD_LINE
                    ,YIELD
                    ,LT_WEEK
                    ,BOH
                    ,XLS_KEY1
                    ,XLS_KEY2
                    ,XLS_KEY3
                    ,XLS_KEY4,XLS_KEY5,XLS_ATTRIBUTE1,XLS_ATTRIBUTE2,XLS_ATTRIBUTE3,XLS_ATTRIBUTE4,XLS_ATTRIBUTE5
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
              SELECT  DIVISION_ID
					,PLAN_START_YYYYMMDD
					,@p_create_from_yyyymmdd
					,@p_create_to_yyyymmdd
					,PLAN_TYPE,SEQ
                    ,CELL_TYPE_GROUP_CODE
                    ,CELL_ITEM_ID
                    ,NICK_NAME
                    ,MEASURE
                    ,MEASURE_LABEL
                    ,SITE_ID,SITE_DESCRIPTION
                    ,PROD_LINE
                    ,YIELD
                    ,LT_WEEK
                    ,BOH
                    ,ROW_NUMBER() OVER(ORDER BY  DIVISION_ID
                                                ,CELL_TYPE_GROUP_CODE DESC
                                                ,CELL_ITEM_ID
                                                ,(CASE WHEN (SITE_ID = '-' ) THEN 'ZZZ' ELSE SITE_ID END) ASC
                                                ,PROD_LINE
                                                ,SORT_ORDER_NO
                                                ,MEASURE_LABEL DESC) + @v_Max_xls_key1 AS XLS_KEY1
                    ,XLS_KEY2
                    ,XLS_KEY3
                    ,XLS_KEY4,XLS_KEY5,XLS_ATTRIBUTE1,XLS_ATTRIBUTE2,XLS_ATTRIBUTE3,XLS_ATTRIBUTE4,XLS_ATTRIBUTE5
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
              FROM #SCP_XLS_PSI_GLOBAL_SMALL_CELL  WITH (NOLOCK)

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

            -------------------------------------------------------------------------------------------------------------         
            --  YIELD,LEAD TIME UPDATE
            ------------------------------------------------------------------------------------------------------------- 
              -- LT_WEEK   반올림 로직 반영
              /*
              UPDATE X
                 SET X.YIELD      = Y.FORMATION_TOTAL_YIELD
                    ,X.LT_WEEK    = CONVERT(int, Y.TOTAL_LT_FORMATION/7) + (CASE WHEN (TOTAL_LT_FORMATION%7 > 0) THEN 1 ELSE 0 END) 
               FROM SCP_XLS_PSI_GLOBAL_SMALL_CELL X WITH (NOLOCK)
               INNER JOIN (
                              SELECT  ITEM_ID
--                                     ,PLANT_SITE_ID
                                     ,MAX(FORMATION_TOTAL_YIELD) AS FORMATION_TOTAL_YIELD
                                     ,MAX(TOTAL_LT_FORMATION)    AS TOTAL_LT_FORMATION
                                FROM dbo.SCP_MST_FORMATION_V Z  WITH (NOLOCK)
                                WHERE Z.DIVISION_ID = @p_division_id   -- '40'
                                GROUP BY ITEM_ID 
                                        --,PLANT_SITE_ID
                          ) Y
                ON X.CELL_ITEM_ID = Y.ITEM_ID
  --              AND X.SITE_ID     = Y.PLANT_SITE_ID
                WHERE MEASURE = 'PROD_TOTAL'              
                */
                UPDATE XX
                 SET 
                    XX.LT_WEEK    = CONVERT(BIGINT, YY.TOTAL_LT_FORMATION/7) + (CASE WHEN (YY.TOTAL_LT_FORMATION%7 > 0) THEN 1 ELSE 0 END) 
                    --,XX.YIELD      = YY.FORMATION_TOTAL_YIELD
                   ,XX.ATTRIBUTE3 = YY.TOTAL_LT_FORMATION
                 FROM SCP_XLS_PSI_GLOBAL_SMALL_CELL XX WITH (NOLOCK)
                 INNER JOIN (
                            SELECT MAX(Y.TOTAL_LT_FORMATION)  AS TOTAL_LT_FORMATION, AVG(FORMATION_TOTAL_YIELD) AS FORMATION_TOTAL_YIELD,CELL_ITEM_ID
                             FROM SCP_XLS_PSI_GLOBAL_SMALL_CELL X WITH (NOLOCK)
                             INNER JOIN (
                                            SELECT  ITEM_ID
                                                   ,PLANT_SITE_ID
                                                   ,MAX(FORMATION_TOTAL_YIELD) AS FORMATION_TOTAL_YIELD
                                                   ,MAX(TOTAL_LT_FORMATION)    AS TOTAL_LT_FORMATION
                                                   ,ROW_NUMBER() OVER(PARTITION BY ITEM_ID ORDER BY MAX(TOTAL_LT_FORMATION) DESC) AS Rn
                                              FROM dbo.SCP_MST_FORMATION_V Z  WITH (NOLOCK)
                                              WHERE Z.DIVISION_ID = '40'                                
                                              GROUP BY ITEM_ID 
                                                      ,PLANT_SITE_ID
                                        ) Y
                              ON X.CELL_ITEM_ID = Y.ITEM_ID
							 AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.05.20   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
                             -- AND X.SITE_ID     = Y.PLANT_SITE_ID
                              WHERE 0 = 0
                                AND MEASURE = 'PROD'       
                                AND Y.Rn = 1
                            GROUP BY CELL_ITEM_ID--,FORMATION_TOTAL_YIELD
                        ) YY
                      ON XX.CELL_ITEM_ID = YY.CELL_ITEM_ID
					 AND XX.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.05.20   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
                    WHERE MEASURE = 'PROD_TOTAL'            

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


                -- SSP_MODIFY_YIELD가 0이거나 100 이면, 0이나 100을 제외한 SSP_MODIFY_YIELD의 평균값
                UPDATE XX
                  SET XX.YIELD = YY.SSP_MODIFY_YIELD_AVG
                 FROM SCP_XLS_PSI_GLOBAL_SMALL_CELL XX WITH (NOLOCK)
                 INNER JOIN (
                            SELECT  ITEM_ID
                                    --,PLANT_SITE_ID
                                    --,MAX(FORMATION_TOTAL_YIELD) AS FORMATION_TOTAL_YIELD
                                    --,SSP_MODIFY_YIELD
                                    --,COUNT(*) AS CNT
                                    ,AVG(SSP_MODIFY_YIELD) AS SSP_MODIFY_YIELD_AVG
                              FROM dbo.SCP_MST_FORMATION_V Z  WITH (NOLOCK)
                              WHERE 0 = 0
                                AND Z.DIVISION_ID = '40'
                                AND Z.SSP_MODIFY_YIELD <> 0.0
                                AND Z.SSP_MODIFY_YIELD <> 1.0         
                              GROUP BY ITEM_ID 
                          ) YY
                      ON XX.CELL_ITEM_ID = YY.ITEM_ID
					 AND XX.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.05.20   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
                    WHERE MEASURE = 'PROD_TOTAL'

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



                -- SSP_MODIFY_YIELD가 0일 경우 소형 전체 SSP_MODIFY_YIELD 값의 평균 값으로 UPDATE
               DECLARE @v_SSP_MODIFY_YIELD NUMERIC (20,10) = 0.0
               SELECT @v_SSP_MODIFY_YIELD = AVG(SSP_MODIFY_YIELD) 
                 FROM dbo.SCP_MST_FORMATION_V Z  WITH (NOLOCK)
                WHERE 0 = 0
                  AND Z.DIVISION_ID = '40'
                  AND Z.SSP_MODIFY_YIELD <> 0.0
                  AND Z.SSP_MODIFY_YIELD <> 1.0                           

               UPDATE XX
                  SET XX.YIELD = @v_SSP_MODIFY_YIELD
                 FROM SCP_XLS_PSI_GLOBAL_SMALL_CELL XX WITH (NOLOCK)
                WHERE XX.MEASURE = 'PROD_TOTAL'
				  AND XX.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.05.20   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
                  AND XX.YIELD = 0.0 
				  

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



            --/*
            -------------------------------------------------------------------------------------------------------------         
            --  DIO 관련 시뮬레이션 추가 
            --  2020.07.06   KSW         DIO 수정 관련
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
                AND A.YYYYQ       = B.YYYYQ
                AND A.DIVISION_ID = @p_division_id
                --and a.YYYYMM      like '201912' -- @p_plan_start_yyyymmdd -- 

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


              UPDATE X
                 SET X.ATTRIBUTE4   = Z.GRO_STD_DIO
                    ,X.ATTRIBUTE5   = Z.MIN_STD_DIO
               FROM SCP_XLS_PSI_GLOBAL_SMALL_CELL X WITH (NOLOCK)
               INNER JOIN #tmp_SCP_MST_DIO Z  WITH (NOLOCK)
                ON X.CELL_ITEM_ID   = Z.ITEM_ID
               -- AND X.FROM_SITE   = Z.PLANT_ID
                WHERE MEASURE       = 'DIO'
				  AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.05.20   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
            --*/
			
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
              SELECT @mQry_sumWeek = @mQry_sumWeek + CHAR(10) +   ' FROM SCP_XLS_PSI_GLOBAL_SMALL_CELL X WITH (NOLOCK) WHERE X.CREATE_FROM_YYYYMMDD = ''' + @p_create_from_yyyymmdd + ''''+CHAR(10)  -- * 2021.05.25   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가

--              PRINT @mQry_sumWeek
              EXEC sp_executesql @mQry_sumWeek;

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


--           
            -------------------------------------------------------------------------------------------------------------         
            --  WEEK SUM PIVOT 생성 후 UPDATE
            -------------------------------------------------------------------------------------------------------------         
              IF OBJECT_ID('tempdb..#LineLoad_WEEK') IS NOT NULL      
	              DROP TABLE #LineLoad_WEEK;   

                SELECT   A.DIVISION_ID
                        ,A.SITE_ID
                        ,A.OPERATION_ID
                        ,A.PROD_LINE
                        ,A.MEASURE
                        ,CASE WHEN SUM(A.WORKING_TIME) <= 0.0   THEN 0 
                              ELSE ISNULL( ( ROUND(SUM(A.CAPA_TACT),0) / SUM(A.WORKING_TIME) ) ,0 ) *100
                         END AS WQTY
                        ,A.ISO_YYYYWW
                        ,A.WEEK_COLUMN
                 INTO #LineLoad_WEEK
                  FROM #LineLoad A WITH (NOLOCK)
                GROUP BY A.DIVISION_ID
                        ,A.SITE_ID
                        ,A.OPERATION_ID
                        ,A.PROD_LINE
                        ,A.MEASURE
                        ,A.ISO_YYYYWW
                        ,A.WEEK_COLUMN

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
                   FROM SCP_XLS_PSI_GLOBAL_SMALL_CELL X WITH (NOLOCK)
                   INNER JOIN #LineLoad_WEEK_PIVOT Y WITH (NOLOCK)
                      ON Y.PROD_LINE    = X.PROD_LINE 
                     AND X.DIVISION_ID  = Y.DIVISION_ID
					 AND X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.05.20   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
                     AND X.SITE_ID      = Y.SITE_ID
                     AND X.ATTRIBUTE9 = Y.OPERATION_ID
                   WHERE X.MEASURE IN ('PROD_LOAD') 

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




              UPDATE X
              SET X.ATTRIBUTE2 ='N'
              --SELECT * 
              FROM SCP_XLS_PSI_GLOBAL_SMALL_CELL X  WITH (NOLOCK)
              WHERE X.CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd		-- * 2021.05.20   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가
			    AND X.ATTRIBUTE2 ='Y'
                AND X.MEASURE    = 'PROD'
                         
        
      
      
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


