

/*
 * Program ID   : PR_SCM_KPI_CREATE
 * Description  : KPI Summary/Detail 데이타 생성
 * OutTable     :
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.10.04   Kim Jihye      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.11.07   yydok          summary에 accumulated_yn column add
 * 2018.11.20   YYDOK          ITEM TYPE COLUMN ADD (P 제품,H 반제품, Q 상품,R 원자재)
 * 2018.11.30   YYDOK          PR_SCM_KPI_PTCR_SUMMARY ADD
 * 2018.12.07   YYDOK          Detail SALES(매출실적) 
 *                             planning_week_offset =0 과거 12주구간중 매출실적이 없는 경우0추가(KPI산출목적) 
 * 2018.12.10   YYDOK          Detail CUST_FCST,MKT_FCST,RTF 0 ADD
 *                             매출실적이 존재하는 경우 과거12주 계획중에 데이타 없으면 계획 0추가(KPI산출목적)  
 * 2018.12.10   YYDOK          Detail SALES 0 DATA ADD
 *                             매출계획이 하나라도 존재하는데, 실적정보가 없는 경우 0추가(KPI산출목적)  
 * 2018.12.13   YYDOK          데이타 채우기 로직보완 (12*12)
 * 2019.01.04   YYDOK          not in ('LGCDJ', 'LGCPI') --연구소를 대상에서 제외(허준성,20190104)
 * 2019.01.11   YYDOK          FCST TYPE이 'SDF', 'SMF', 'TST'인 것은 제외(김성은,20190110)
 * 2019.01.16   YYDOK          FCST TYPE이 'ASF'인 것은 제외(김성은,20190116) 
 * 2019.06.19   KSG            [요청번호:C20190618_20099] GSCM - RTF 준수율 산식 변경 건 [CSR ID:4020099] DW 요청 : 음수 매출실적 제외 : 'SALES'  measure
 */
 
CREATE PROCEDURE [dbo].[PR_SCM_KPI_CREATE]
(
   @p_basis_yyyymmdd  NVARCHAR(8)
 )
 AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'scm_batch';
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCM_KPI_CREATE';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      
    DECLARE @v_table_id     NVARCHAR(150) = N'SCM_KPI_SUMMARY/DETAIL'; 
    DECLARE @d_event_date   DATETIME;

    -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SCM_KPI_SUMMARY/DETAIL INSERT LOGIC';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                              ,@p_log_type      = @v_log_type
                              ,@p_log_count     = @n_log_count 
                              ,@p_log_message   = @v_log_message 
                              ,@p_description   = @v_description 
                              ,@p_event_date    = @d_event_date 
                              ,@p_user_id       = @v_batch_user
                              ;
    

  -- 업무용 변수
  DECLARE @v_basis_yyyymmdd  NVARCHAR(8);  -- 기준 일자
  DECLARE @v_yyyymmdd        NVARCHAR(8);  -- 변동 일자  
  DECLARE @v_del_yyyymmdd    NVARCHAR(8);  -- 삭제 기준 일자 

  DECLARE @v_kpi_type        NVARCHAR(30); -- KPI 유형
  DECLARE @v_measure_plan    NVARCHAR(50); -- Plan Measure
  DECLARE @v_measure_result  NVARCHAR(50); -- Result Measure

  DECLARE @n_planning_week_offset INT;
  DECLARE @n_period               INT = 12;
  
  DECLARE @rows INT;            
  

  -- Rate 까지 계산해서 DW 로 전송하는 대상 KPI
/*
  DECLARE cur_kpi CURSOR FOR
      SELECT segment1 AS kpi_type
            ,segment2 AS measure_plan
            ,segment3 AS measure_result
      FROM   scm_adm_lookup_master_detail WITH(NOLOCK)
      WHERE  lookup_type = 'KPI_CALC'
      AND    valid_yn = 'Y'
      ORDER BY display_seq
    ;
*/    
    BEGIN TRY
      BEGIN
      -- 기준일자 설정, Default 전주차 KPI 생성
        IF @p_basis_yyyymmdd IS NOT NULL
          BEGIN
            SET @v_basis_yyyymmdd = @p_basis_yyyymmdd;

          END
        ELSE
          BEGIN
            SET @v_basis_yyyymmdd = DBO.FN_GET_BUCKET_YYYYMMDD(-1); -- 전주차의 월요일(W-1)
          END
          ;

        SET @v_del_yyyymmdd = DBO.FN_GET_BUCKET_YYYYMMDD(-12); -- 12주 이전 월요일

    ------------------------------------------------------------------------------------
    -- Detail 생성 : CUST_FCST, MKT_FCST, RTF, SALES(매출실적) 
    -- 매주 Cutoff 된 최신 Version Data 를 월요일 일자로 Sum 하여 적재한다. 
    ------------------------------------------------------------------------------------

    DELETE 
    FROM   scm_kpi_detail
    WHERE  plan_start_yyyymmdd = @v_basis_yyyymmdd
    AND    measure IN ('CUST_FCST', 'MKT_FCST', 'RTF','SALES');


    INSERT INTO scm_kpi_detail (
           division_id
          ,project_code
          ,sales_site_id
          ,item_id
          ,plan_start_yyyymmdd
          ,plan_week
          ,yyyymmdd
          ,planning_week_offset
          ,measure
          ,qty
          ,item_type   -- 2018.11.20 add yydok
          ,valid_yn
          ,created_by
          ,creation_date
          ,last_updated_by
          ,last_update_date)
    SELECT kpi.division_id
          ,kpi.project_code
          ,kpi.scm_site_id
          ,kpi.item_id
          ,kpi.plan_start_yyyymmdd
          ,cm.week_name
          ,kpi.yyyymmdd
          ,kpi.planning_week_offset
          ,kpi.measure
          ,kpi.qty
          ,( SELECT 
                    case  min( 
                               case when T1.item_type = 'P' then 1
                                    when T1.item_type = 'H' then 2
                                    when T1.item_type = 'Q' then 3
                                    else 4 
                               end
                              )  
                    when 1 then 'P' 
                    when 2 then 'H'
                    when 3 then 'Q'
                    else 'R' 
                    end
               FROM dbo.SCM_MST_ITEM_SN T1 WITH(NOLOCK)
              WHERE t1.division_id  = kpi.division_id
                and t1.item_id      = kpi.item_id              
            )
          ,'Y'           AS valid_yn
          ,@v_batch_user AS created_by
          ,GETDATE()     AS creation_date
          ,@v_batch_user AS last_updated_by
          ,GETDATE()     AS last_update_date
    FROM (SELECT fc.division_id
                ,fc.project_code
                ,fc.scm_site_id
                ,fc.item_id
                ,version_no.week_day AS plan_start_yyyymmdd
                -- 해당 주차의 일자별 Data 를 그 주차의 월요일 Data 로 Sum 하여 반영
                ,CONVERT(VARCHAR(08), DATEADD(WW, -1, DBO.FN_NEXT_DAY(fc.yyyymmdd, 'MON')), 112) AS yyyymmdd
                ,fc.measure
                -- Plan 주차와 차이나는 주차
                ,DATEDIFF(WK, version_no.week_day, CONVERT(VARCHAR(08), DATEADD(WW, -1, DBO.FN_NEXT_DAY(fc.yyyymmdd, 'MON')), 112)) AS planning_week_offset
                ,SUM(qty) qty 
           FROM dm_pln_mkt_fcst_c fc WITH(NOLOCK)              
              ,(SELECT division_id
                      ,version_type
                      ,CONVERT(VARCHAR(08), DATEADD(WW, -1, DBO.FN_NEXT_DAY(yyyymmdd, 'MON')), 112) AS week_day
                      ,MAX(version_no) AS version_no
                FROM   dm_mst_version WITH(NOLOCK)
                WHERE  version_type = 'MF_W'
                GROUP BY division_id
                        ,version_type
                        ,CONVERT(VARCHAR(08), DATEADD(WW, -1, DBO.FN_NEXT_DAY(yyyymmdd, 'MON')), 112)
               ) version_no -- 주별 제일 마지막으로 cutoff 된 version_no
        WHERE  fc.division_id = version_no.division_id
        AND    fc.version_no  = version_no.version_no
        AND    fc.yyyymmdd    >= version_no.week_day
        AND    fc.yyyymmdd    < CONVERT(VARCHAR(08), DATEADD(WW, 11, DBO.FN_NEXT_DAY(version_no.week_day, 'MON')), 112)
        AND    fc.measure     IN ('CUST_FCST', 'MKT_FCST', 'RTF')
        AND    left(fc.scm_site_id,5) not in ('LGCDJ', 'LGCPI') --연구소를 대상에서 제외(허준성,20190104)
        AND    FC.FCST_TYPE NOT IN ( 'SDF', 'SMF', 'TST','ASF' ) --제외할 SALES_TYPE_CODE LOOKUP
        GROUP BY fc.division_id
                ,fc.scm_site_id
                ,fc.project_code
                ,fc.item_id
                ,version_no.week_day
                ,CONVERT(VARCHAR(08), DATEADD(WW, -1, DBO.FN_NEXT_DAY(fc.yyyymmdd, 'MON')), 112)
                ,measure
        UNION ALL
        SELECT rc.division_id
              ,rc.project_code
              ,rc.scm_site_id
              ,rc.item_id
              ,version_no.week_day AS plan_start_yyyymmdd
              ,CONVERT(VARCHAR(08), DATEADD(WW, -1, DBO.FN_NEXT_DAY(rc.yyyymmdd, 'MON')), 112) AS yyyymmdd
              ,'SALES'  AS measure
              ,0  AS planning_week_offset -- 매출 실적은 그 주차 Data 만 존재
              ,SUM(qty) AS qty 
        FROM   dm_pln_mkt_fcst_result_c rc WITH(NOLOCK)
             ,(SELECT division_id
                     ,version_type
                     ,CONVERT(VARCHAR(08), DATEADD(WW, -2, DBO.FN_NEXT_DAY(yyyymmdd, 'MON')), 112) AS week_day  -- 실적은 cutoff 일자 기준 1주 전 Data 생성됨
                     ,MAX(version_no) AS version_no
                 FROM dm_mst_version WITH(NOLOCK)
                WHERE version_type = 'MF_W'
                GROUP BY division_id
                     ,version_type
                     ,CONVERT(VARCHAR(08), DATEADD(WW, -2, DBO.FN_NEXT_DAY(yyyymmdd, 'MON')), 112)
              ) version_no
        WHERE  rc.division_id  = version_no.division_id
        AND    rc.version_no   = version_no.version_no
        AND    rc.measure      = 'RTF'
        AND    rc.qty          >= 0  -- 20190618 조건 추가
        AND    rc.yyyymmdd     >= CONVERT(VARCHAR(08), DATEADD(WW, -11, CONVERT(DATE, version_no.week_day, 112)), 112) -- basis 일자 기준 -12 주간 실적
        AND    left(rc.scm_site_id,5) not in ('LGCDJ', 'LGCPI') --연구소를 대상에서 제외(허준성,20190104)        
        AND    RC.FCST_TYPE NOT IN ( 'SDF', 'SMF', 'TST','ASF' ) --제외할 SALES_TYPE_CODE LOOKUP
        GROUP BY rc.division_id
                ,rc.scm_site_id
                ,rc.project_code
                ,rc.item_id
                ,version_no.week_day
                ,CONVERT(VARCHAR(08), DATEADD(WW, -1, DBO.FN_NEXT_DAY(rc.yyyymmdd, 'MON')), 112)
                ,measure
        ) kpi
    JOIN   scm_mst_site_item si  WITH(NOLOCK) -- garbage 데이타가 있어, Site Item 에 Setup 된 Item 만 대상으로 함
           ON     kpi.division_id       = si.division_id
           AND    kpi.project_code      = si.project_code
           AND    kpi.scm_site_id       = si.scm_site_id
           AND    kpi.item_id           = si.item_id
           AND    si.valid_yn           = 'Y'
    JOIN   scm_mst_site s        WITH(NOLOCK)
           ON     kpi.division_id       = s.division_id
           AND    kpi.scm_site_id       = s.scm_site_id
           AND    s.valid_yn            = 'Y'
    JOIN   scm_sys_calendar_m cm WITH(NOlOCK)
           ON     kpi.plan_start_yyyymmdd = cm.basis_yyyymmdd
    WHERE  kpi.plan_start_yyyymmdd = @v_basis_yyyymmdd
    ;

       

    ------------------------------------------------------------------------------------
    -- Detail 생성 : SALES판매수량 생성 
    -- 계획의 과거 12주구간계획수립시 기준일자에 계획이 하나라도 있는  경우
    -- SALES실적이 없으면  0 으로 데이타 만들기
    -- 계획: CUST_FCST, MKT_FCST, RTF
    ------------------------------------------------------------------------------------
SET @v_yyyymmdd = @v_basis_yyyymmdd;
DECLARE @LOOP_CNT INT;
DECLARE @SALES_VERSION_NO_81 NVARCHAR(100);
DECLARE @SALES_VERSION_NO_82 NVARCHAR(100);
DECLARE @SALES_VERSION_NO_40 NVARCHAR(100);

    SELECT @SALES_VERSION_NO_81 = MAX(version_no) 
      FROM dm_mst_version WITH(NOLOCK)
     WHERE version_type = 'MF_W'
       and CONVERT(VARCHAR(08), DATEADD(WW, -2, DBO.FN_NEXT_DAY(yyyymmdd, 'MON')), 112) =@v_basis_yyyymmdd
       and division_id ='81';

    SELECT @SALES_VERSION_NO_82 = MAX(version_no) 
      FROM dm_mst_version WITH(NOLOCK)
     WHERE version_type = 'MF_W'
       and CONVERT(VARCHAR(08), DATEADD(WW, -2, DBO.FN_NEXT_DAY(yyyymmdd, 'MON')), 112) =@v_basis_yyyymmdd
       and division_id ='82';
              
    SELECT @SALES_VERSION_NO_40 = MAX(version_no) 
      FROM dm_mst_version WITH(NOLOCK)
     WHERE version_type = 'MF_W'
       and CONVERT(VARCHAR(08), DATEADD(WW, -2, DBO.FN_NEXT_DAY(yyyymmdd, 'MON')), 112) =@v_basis_yyyymmdd
       and division_id ='40';
       

SET @LOOP_CNT = 1;

WHILE @LOOP_CNT <= 12
BEGIN
  
          SET @v_yyyymmdd = CONVERT(VARCHAR(08), DATEADD(WW, @LOOP_CNT - 12, CONVERT(DATE, @v_basis_yyyymmdd, 112)), 112);
    
          WITH SUB AS
          (
          SELECT  distinct
                  P.DIVISION_ID         
                 ,P.PROJECT_CODE        
                 ,P.SALES_SITE_ID       
                 ,P.ITEM_ID             
               --  ,P.YYYYMMDD 
            FROM 
                 SCM_KPI_DETAIL P WITH(NOLOCK)
           WHERE MEASURE ='CUST_FCST'
             AND PLAN_START_YYYYMMDD >  CONVERT(VARCHAR(08), DATEADD(WW, -12, CONVERT(DATE, @v_basis_yyyymmdd, 112)), 112)
             AND PLAN_START_YYYYMMDD <=@v_basis_yyyymmdd
             --AND YYYYMMDD =@v_yyyymmdd
             AND QTY > 0
             AND NOT EXISTS (
                                     SELECT 'X'
                                       FROM scm_kpi_detail XX WITH(NOLOCK)  --계획
                                      WHERE XX.DIVISION_ID          = P.DIVISION_ID         
                                        AND XX.PROJECT_CODE         = P.PROJECT_CODE        
                                        AND XX.SALES_SITE_ID        = P.SALES_SITE_ID       
                                        AND XX.ITEM_ID              = P.ITEM_ID             
                                        AND XX.PLAN_START_YYYYMMDD  = @v_basis_yyyymmdd       
                                        AND XX.PLANNING_WEEK_OFFSET = 0
                                        AND XX.YYYYMMDD             = @v_yyyymmdd        
                                        AND XX.MEASURE              = 'SALES'             
                              )
          UNION 
          SELECT  distinct
                  P.DIVISION_ID         
                 ,P.PROJECT_CODE        
                 ,P.SALES_SITE_ID       
                 ,P.ITEM_ID             
             --    ,P.YYYYMMDD 
            FROM 
                 SCM_KPI_DETAIL P WITH(NOLOCK)
           WHERE MEASURE ='MKT_FCST'
             AND PLAN_START_YYYYMMDD >  CONVERT(VARCHAR(08), DATEADD(WW, -12, CONVERT(DATE, @v_basis_yyyymmdd, 112)), 112)
             AND PLAN_START_YYYYMMDD <=@v_basis_yyyymmdd
            -- AND YYYYMMDD =@v_yyyymmdd
             AND QTY > 0
             AND NOT EXISTS (
                                     SELECT 'X'
                                       FROM scm_kpi_detail XX WITH(NOLOCK)  --계획
                                      WHERE XX.DIVISION_ID          = P.DIVISION_ID         
                                        AND XX.PROJECT_CODE         = P.PROJECT_CODE        
                                        AND XX.SALES_SITE_ID        = P.SALES_SITE_ID       
                                        AND XX.ITEM_ID              = P.ITEM_ID             
                                        AND XX.PLAN_START_YYYYMMDD  = @v_basis_yyyymmdd  
                                        AND XX.PLANNING_WEEK_OFFSET = 0     
                                        AND XX.YYYYMMDD             = @v_yyyymmdd       
                                        AND XX.MEASURE              = 'SALES'             
                              )
          UNION
          SELECT  distinct
                  P.DIVISION_ID         
                 ,P.PROJECT_CODE        
                 ,P.SALES_SITE_ID       
                 ,P.ITEM_ID             
               --  ,P.YYYYMMDD 
            FROM 
                 SCM_KPI_DETAIL P WITH(NOLOCK)
           WHERE MEASURE ='RTF'
             AND PLAN_START_YYYYMMDD >  CONVERT(VARCHAR(08), DATEADD(WW, -12, CONVERT(DATE, @v_basis_yyyymmdd, 112)), 112)
             AND PLAN_START_YYYYMMDD <=@v_basis_yyyymmdd
          --   AND YYYYMMDD =@v_yyyymmdd
             AND QTY > 0
             AND NOT EXISTS (
                                     SELECT 'X'
                                       FROM scm_kpi_detail XX WITH(NOLOCK)  --계획
                                      WHERE XX.DIVISION_ID          = P.DIVISION_ID         
                                        AND XX.PROJECT_CODE         = P.PROJECT_CODE        
                                        AND XX.SALES_SITE_ID        = P.SALES_SITE_ID       
                                        AND XX.ITEM_ID              = P.ITEM_ID             
                                        AND XX.PLAN_START_YYYYMMDD  = @v_basis_yyyymmdd 
                                        AND XX.PLANNING_WEEK_OFFSET = 0      
                                        AND XX.YYYYMMDD             = @v_yyyymmdd       
                                        AND XX.MEASURE              = 'SALES'             
                              )
          )  -- END OF SUB
              INSERT INTO scm_kpi_detail (
                     division_id
                    ,project_code
                    ,sales_site_id
                    ,item_id
                    ,plan_start_yyyymmdd
                    ,plan_week
                    ,yyyymmdd
                    ,planning_week_offset
                    ,measure
                    ,qty
                    ,item_type   
                    ,valid_yn
                    ,created_by
                    ,creation_date
                    ,last_updated_by
                    ,last_update_date)
                 SELECT --*
                        SUB.division_id
                       ,SUB.project_code
                       ,SUB.sales_site_id
                       ,SUB.item_id
                       ,@v_basis_yyyymmdd AS plan_start_yyyymmdd
                       ,(SELECT TOP 1 CM.WEEK_NAME
                           FROM scm_sys_calendar_m cm WITH(NOlOCK)
                          WHERE @v_basis_yyyymmdd = cm.basis_yyyymmdd 
                          )      AS PLAN_WEEK  
                       ,@v_yyyymmdd AS YYYYMMDD
                       ,0        AS planning_week_offset
                       ,'SALES'  AS measure                           
                      -- ,0        AS QTY
                       , (
                           select ISNULL(SUM(ISNULL(RC.QTY,0)),0)
                             from dm_pln_mkt_fcst_result_c rc WITH(NOLOCK)
                            where 1=1
                              AND RC.MEASURE      = 'RTF'
                              and RC.VERSION_NO   = ( CASE SUB.DIVISION_ID WHEN '81' THEN @SALES_VERSION_NO_81
                                                                           WHEN '82' THEN @SALES_VERSION_NO_82
                                                                           WHEN '40' THEN @SALES_VERSION_NO_40
                                                      END 
                                                     )                              
                              AND RC.DIVISION_ID  = SUB.DIVISION_ID   --'40'
                              AND RC.ITEM_ID      = SUB.ITEM_ID       --'MTP2896A2A12'
                              AND RC.PROJECT_CODE = SUB.PROJECT_CODE
                              AND RC.SCM_SITE_ID  = SUB.SALES_SITE_ID --'Celxpert_CN_KUS'
                              AND RC.YYYYMMDD     = @v_yyyymmdd       --'20181126'

                         ) AS QTY
                       ,( SELECT 
                                 case  min( 
                                            case when T1.item_type = 'P' then 1
                                                 when T1.item_type = 'H' then 2
                                                 when T1.item_type = 'Q' then 3
                                                 else 4 
                                            end
                                           )  
                                 when 1 then 'P' 
                                 when 2 then 'H'
                                 when 3 then 'Q'
                                 else 'R' 
                                 end
                            FROM dbo.SCM_MST_ITEM_SN T1 WITH(NOLOCK)
                           WHERE t1.division_id  = SUB.division_id
                             and t1.item_id      = SUB.item_id              
                         )
                       ,'Y'           AS valid_yn
                       ,@v_batch_user AS created_by
                       ,GETDATE()     AS creation_date
                       ,@v_batch_user AS last_updated_by
                       ,GETDATE()     AS last_update_date  
          FROM SUB
          ;
          
    SET @LOOP_CNT = @LOOP_CNT + 1;      
          
END       --END OF LOOP   
;


    ------------------------------------------------------------------------------------
    -- Detail 생성 : SALES판매수량이 >0 이면 
    -- 계획의 과거 12주구간계획수립시 기준일자에 계획이 없는 경우 0 채우기
    -- 계획: CUST_FCST, MKT_FCST, RTF
    ------------------------------------------------------------------------------------
    
DECLARE @V_PLAN_VERSION_NO_81 NVARCHAR(100);
DECLARE @V_PLAN_VERSION_NO_82 NVARCHAR(100);
DECLARE @V_PLAN_VERSION_NO_40 NVARCHAR(100);
DECLARE @V_PLAN_START_YYYYMMDD NVARCHAR(8);

SET @LOOP_CNT = 1;

WHILE @LOOP_CNT <= 12
BEGIN
  
          SET @V_PLAN_START_YYYYMMDD = CONVERT(VARCHAR(08), DATEADD(WW, @LOOP_CNT - 12, CONVERT(DATE, @v_basis_yyyymmdd, 112)), 112);       

          
              SELECT @V_PLAN_VERSION_NO_81 = MAX(version_no) 
                FROM dm_mst_version WITH(NOLOCK)
               WHERE version_type = 'MF_W'
                 and CONVERT(VARCHAR(08), DATEADD(WW, -1, DBO.FN_NEXT_DAY(yyyymmdd, 'MON')), 112) =@V_PLAN_START_YYYYMMDD
                 and division_id ='81';
          
              SELECT @V_PLAN_VERSION_NO_82 = MAX(version_no) 
                FROM dm_mst_version WITH(NOLOCK)
               WHERE version_type = 'MF_W'
                 and CONVERT(VARCHAR(08), DATEADD(WW, -1, DBO.FN_NEXT_DAY(yyyymmdd, 'MON')), 112) =@V_PLAN_START_YYYYMMDD
                 and division_id ='82';
                        
              SELECT @V_PLAN_VERSION_NO_40 = MAX(version_no) 
                FROM dm_mst_version WITH(NOLOCK)
               WHERE version_type = 'MF_W'
                 and CONVERT(VARCHAR(08), DATEADD(WW, -1, DBO.FN_NEXT_DAY(yyyymmdd, 'MON')), 112) =@V_PLAN_START_YYYYMMDD
                 and division_id ='40';
              
          WITH X AS
          (
          SELECT DISTINCT
                 DIVISION_ID,
                 PROJECT_CODE,
                 SALES_SITE_ID,
                 ITEM_ID,
                 YYYYMMDD         --과거 12주
            FROM SCM_KPI_DETAIL S WITH(NOLOCK)
           WHERE MEASURE             ='SALES'
             AND PLAN_START_YYYYMMDD =@v_basis_yyyymmdd --돌리는 기준주차
             AND YYYYMMDD            =@V_PLAN_START_YYYYMMDD 
          -- AND DIVISION_ID='40'
          -- AND PROJECT_CODE='Asus'
          -- AND SALES_SITE_ID ='Celxpert_CN_KUS'
          -- AND ITEM_ID ='MTP2896A2A12'
          )
              INSERT INTO scm_kpi_detail (
                     division_id
                    ,project_code
                    ,sales_site_id
                    ,item_id
                    ,plan_start_yyyymmdd
                    ,plan_week
                    ,yyyymmdd
                    ,planning_week_offset
                    ,measure
                    ,qty
                    ,item_type   
                    ,valid_yn
                    ,created_by
                    ,creation_date
                    ,last_updated_by
                    ,last_update_date)
                 SELECT --*
                        SUB.division_id
                       ,SUB.project_code
                       ,SUB.sales_site_id
                       ,SUB.item_id
                       ,SUB.plan_start_yyyymmdd
                       ,(SELECT TOP 1 CM.WEEK_NAME
                           FROM scm_sys_calendar_m cm WITH(NOlOCK)
                          WHERE SUB.plan_start_yyyymmdd = cm.basis_yyyymmdd 
                          )  AS PLAN_WEEK  
                       ,SUB.YYYYMMDD
                       ,DATEDIFF(WK, SUB.plan_start_yyyymmdd,SUB.YYYYMMDD ) AS planning_week_offset
                       ,SUB.MEASURE                           
                     /*  ,(
                                     select ISNULL(SUM(ISNULL(RC.QTY,0)),0)
                                       from dm_pln_mkt_fcst_result_c rc WITH(NOLOCK)
                                      where 1=1
                                        AND RC.MEASURE      = SUB.MEASURE --'CUST_FCST'
                                        and RC.VERSION_NO   = ( CASE SUB.DIVISION_ID WHEN '81' THEN @V_PLAN_VERSION_NO_81
                                                                                     WHEN '82' THEN @V_PLAN_VERSION_NO_82
                                                                                     WHEN '40' THEN @V_PLAN_VERSION_NO_40
                                                                END 
                                                               )                              
                                        AND RC.DIVISION_ID  = SUB.DIVISION_ID   
                                        AND RC.PROJECT_CODE = SUB.PROJECT_CODE
                                        AND RC.SCM_SITE_ID  = SUB.SALES_SITE_ID 
                                        AND RC.ITEM_ID      = SUB.ITEM_ID       
                                        AND RC.YYYYMMDD     = SUB.YYYYMMDD
          
                        ) AS QTY
                        */
                       ,0 AS QTY
                       ,( SELECT 
                                 case  min( 
                                            case when T1.item_type = 'P' then 1
                                                 when T1.item_type = 'H' then 2
                                                 when T1.item_type = 'Q' then 3
                                                 else 4 
                                            end
                                           )  
                                 when 1 then 'P' 
                                 when 2 then 'H'
                                 when 3 then 'Q'
                                 else 'R' 
                                 end
                            FROM dbo.SCM_MST_ITEM_SN T1 WITH(NOLOCK)
                           WHERE t1.division_id  = SUB.division_id
                             and t1.item_id      = SUB.item_id              
                         )
                       ,'Y'           AS valid_yn
                       ,@v_batch_user AS created_by
                       ,GETDATE()     AS creation_date
                       ,@v_batch_user AS last_updated_by
                       ,GETDATE()     AS last_update_date  
          FROM                       
          (          
          -----------------------------
          -- CUST_FCST
          -----------------------------
            SELECT X.division_id
                  ,X.project_code
                  ,X.sales_site_id
                  ,X.item_id
                  ,'CUST_FCST' AS MEASURE
                  ,@V_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD
                  ,C.BASIS_YYYYMMDD  AS YYYYMMDD
              FROM ( SELECT BASIS_YYYYMMDD
                     FROM scm_sys_calendar_m WITH(NOLOCK)
                    WHERE BASIS_YYYYMMDD > CONVERT(VARCHAR(08), DATEADD(WW, -12, CONVERT(DATE, @v_basis_yyyymmdd, 112)), 112)
                      AND BASIS_YYYYMMDD <= @v_basis_yyyymmdd
                      AND DAYOFWEEK_NO =2 --MON 
                     ) C
                  CROSS APPLY
                   X
          WHERE 1=1
            AND C.BASIS_YYYYMMDD >= @V_PLAN_START_YYYYMMDD  --X.YYYYMMDD
            AND    NOT EXISTS (
                                     SELECT 'X'
                                       FROM scm_kpi_detail XX WITH(NOLOCK)  --계획
                                      WHERE XX.DIVISION_ID          = X.DIVISION_ID         
                                        AND XX.PROJECT_CODE         = X.PROJECT_CODE        
                                        AND XX.SALES_SITE_ID        = X.SALES_SITE_ID       
                                        AND XX.ITEM_ID              = X.ITEM_ID             
                                        AND XX.PLAN_START_YYYYMMDD  = @V_PLAN_START_YYYYMMDD
                                        AND XX.YYYYMMDD             = C.BASIS_YYYYMMDD         
                                        AND XX.MEASURE              = 'CUST_FCST'             
                               )
          --ORDER BY PLAN_START_YYYYMMDD,YYYYMMDD
          -----------------------------
          -- MKT_FCST
          -----------------------------
          UNION ALL
            SELECT X.division_id
                  ,X.project_code
                  ,X.sales_site_id
                  ,X.item_id
                  ,'MKT_FCST' AS MEASURE
                  ,@V_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD
                  ,C.BASIS_YYYYMMDD  AS YYYYMMDD
              FROM ( SELECT BASIS_YYYYMMDD
                     FROM scm_sys_calendar_m WITH(NOLOCK)
                    WHERE BASIS_YYYYMMDD > CONVERT(VARCHAR(08), DATEADD(WW, -12, CONVERT(DATE, @v_basis_yyyymmdd, 112)), 112)
                      AND BASIS_YYYYMMDD <= @v_basis_yyyymmdd
                      AND DAYOFWEEK_NO =2 --MON 
                     ) C
                  CROSS APPLY
                   X
          WHERE 1=1
            AND C.BASIS_YYYYMMDD >= @V_PLAN_START_YYYYMMDD  --X.YYYYMMDD
            AND    NOT EXISTS (
                                     SELECT 'X'
                                       FROM scm_kpi_detail XX WITH(NOLOCK)  --계획
                                      WHERE XX.DIVISION_ID          = X.DIVISION_ID         
                                        AND XX.PROJECT_CODE         = X.PROJECT_CODE        
                                        AND XX.SALES_SITE_ID        = X.SALES_SITE_ID       
                                        AND XX.ITEM_ID              = X.ITEM_ID             
                                        AND XX.PLAN_START_YYYYMMDD  = @V_PLAN_START_YYYYMMDD
                                        AND XX.YYYYMMDD             = C.BASIS_YYYYMMDD         
                                        AND XX.MEASURE              = 'MKT_FCST'             
                               )
          --ORDER BY PLAN_START_YYYYMMDD,YYYYMMDD
          -----------------------------
          -- RTF
          -----------------------------
          UNION ALL
            SELECT X.division_id
                  ,X.project_code
                  ,X.sales_site_id
                  ,X.item_id
                  ,'RTF' AS MEASURE
                  ,@V_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD
                  ,C.BASIS_YYYYMMDD  AS YYYYMMDD
              FROM ( SELECT BASIS_YYYYMMDD
                     FROM scm_sys_calendar_m WITH(NOLOCK)
                    WHERE BASIS_YYYYMMDD > CONVERT(VARCHAR(08), DATEADD(WW, -12, CONVERT(DATE, @v_basis_yyyymmdd, 112)), 112)
                      AND BASIS_YYYYMMDD <= @v_basis_yyyymmdd
                      AND DAYOFWEEK_NO =2 --MON 
                     ) C
                  CROSS APPLY
                   X
          WHERE 1=1
            AND C.BASIS_YYYYMMDD >= @V_PLAN_START_YYYYMMDD  --X.YYYYMMDD
            AND    NOT EXISTS (
                                     SELECT 'X'
                                       FROM scm_kpi_detail XX WITH(NOLOCK)  --계획
                                      WHERE XX.DIVISION_ID          = X.DIVISION_ID         
                                        AND XX.PROJECT_CODE         = X.PROJECT_CODE        
                                        AND XX.SALES_SITE_ID        = X.SALES_SITE_ID       
                                        AND XX.ITEM_ID              = X.ITEM_ID             
                                        AND XX.PLAN_START_YYYYMMDD  = @V_PLAN_START_YYYYMMDD
                                        AND XX.YYYYMMDD             = C.BASIS_YYYYMMDD         
                                        AND XX.MEASURE              = 'RTF'             
                               )
          --ORDER BY PLAN_START_YYYYMMDD,YYYYMMDD
          ) SUB
          ;     

    SET @LOOP_CNT = @LOOP_CNT + 1;      
          
END       --END OF LOOP   
;
                                
    ------------------------------------------------------------------------------------
    -- Summary 생성 (Rate 까지 계산해서 DW 로 전송하는 KPI)
    ------------------------------------------------------------------------------------

        -----------------------------------------------------------
        -- KPI_TYPE: RFCR --(SCP)
        -----------------------------------------------------------
        --EXEC @ROWS = PR_SCM_KPI_RFCR_SUMMARY           @p_basis_yyyymmdd = @v_basis_yyyymmdd

        --IF (@rows < 0 )  GOTO _RETURN_ERR_CODE           

        -----------------------------------------------------------
        -- KPI_TYPE: SFA --(DM)
        -----------------------------------------------------------
        EXEC @ROWS = PR_SCM_KPI_SFA_SUMMARY           @p_basis_yyyymmdd = @v_basis_yyyymmdd

        IF (@rows < 0 )  GOTO _RETURN_ERR_CODE           


        -----------------------------------------------------------
        -- KPI_TYPE: CFA --(DM)
        -----------------------------------------------------------
        --EXEC @ROWS = PR_SCM_KPI_CFA_SUMMARY           @p_basis_yyyymmdd = @v_basis_yyyymmdd

        --IF (@rows < 0 )  GOTO _RETURN_ERR_CODE           

        -----------------------------------------------------------
        -- KPI_TYPE: PTCR --(SCP)
        -----------------------------------------------------------
        EXEC @ROWS = PR_SCM_KPI_PTCR_SUMMARY           @p_basis_yyyymmdd = @v_basis_yyyymmdd

        IF (@rows < 0 )  GOTO _RETURN_ERR_CODE
          
        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

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

      END;

    END TRY

    BEGIN CATCH
        
      
      -- ERROR LOG
      SET @v_log_type = N'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                ,@p_log_type      =@v_log_type
                                ,@p_log_count     =@n_log_count 
                                ,@p_log_message   =@v_log_message 
                                ,@p_description   =@v_description 
                                ,@p_event_date    =@d_event_date 
                                ,@p_user_id       =@v_batch_user
                                ;

      return -1 
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description = N'';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;
/*							  
    DELETE 
    FROM   scm_kpi_summary
    WHERE  basis_yyyymmdd < @v_del_yyyymmdd ;

    DELETE 
    FROM   scm_kpi_detail
    WHERE  plan_start_yyyymmdd < @v_del_yyyymmdd ;
*/
    return 1 

    _RETURN_ERR_CODE:          
        BEGIN          
             RETURN -1          
        END;  

  END;
