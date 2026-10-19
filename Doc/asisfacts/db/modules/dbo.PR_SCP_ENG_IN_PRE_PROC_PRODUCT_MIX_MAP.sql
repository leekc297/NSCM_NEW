
/*
 * Program ID   : PR_SCP_ENG_IN_PRE_PROC_PRODUCT_MIX_MAP
 * Description  : 
                  -------------------------------------------------
                  --1. OUTSOURCING CAPA 정보 INSERT
                  -------------------------------------------------
                    -1) scp_mst_outsourcing_capa.plant_site_id가 외주 SITE만 적용됨( scp_mst_outsourcing_capa테이블에 기본적으로 외주SITE 만 입력되어있음)
                    
                    -2) 컬럼값 설정 
                        -컬럼1) product_mix_id
                            - TOTAL 일때 (scp_mst_outsourcing_capa.item_id 가 '-' 일때) : scp_mst_outsourcing_capa.plant_site_id + '_' + 'TOTAL' 
                               ==> plant_site_id 별 전체item 개수만큼 데이터 생성됨( ex) plant_site_id가 'KR013131_81-P'인 item이 10개 존재시 => product_mix_id가 'KR013131_81-P_TOTAL' 인 10개의 데이터가 생성됨)
                            - TOTAL 아닐때(scp_mst_outsourcing_capa.item_id 가 '-' 아닐때) : scp_mst_outsourcing_capa.plant_site_id + '_' + scp_mst_outsourcing_capa.item_id                        
                        -컬럼2) descr : 'OSP' 셋팅  
                        -컬럼3) product_mix_rate : 1 로 셋팅                     
                    
                    - 참조 테이블 : scp_mst_outsourcing_capa (OUTSOURCING CAPA 정보)

                  -------------------------------------------------
                  --2. 특성 CAPA 정보 INSERT
                  -------------------------------------------------
                  -1) scp_mst_char_capa.plant_site_id가 외주SITE가 아닌 셀SITE만 적용
                      
                  -2) 컬럼값 설정 
                      -컬럼1) product_mix_id
                             - TOTAL 일때 (scp_mst_char_capa.item_id 가 '-' 일때) : scp_mst_char_capa.plant_site_id + '_' + 'TOTAL' 
                               ==> plant_site_id 별 전체item 개수만큼 데이터 생성됨( ex) plant_site_id가 'AO40-A'인 item이 10개 존재시 => product_mix_id가 'KR013131_81-P_TOTAL' 인 10개의 데이터가 생성됨)
                             - TOTAL 아닐때(scp_mst_char_capa.item_id 가 '-' 아닐때) : scp_mst_char_capa.plant_site_id + '_' + scp_mst_char_capa.item_id                        
                      -컬럼2) descr : 'CHAR' 셋팅  
                      -컬럼3) product_mix_rate : 1 로 셋팅
                      -컬럼4) route_id     : 'CHAR::' + bod_id
                      -컬럼5) operation_id : 'CHAR::' + bod_id
            
                   - 참조 테이블 : scp_mst_char_capa (특성 CAPA 정보) 

 * OutTable     : TH_ENG_PRODUCT_MIX_MAP
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.05.21   KSW         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 
 * 2018.07.19   KSW         가상 plant site 생성 제외
 * 2018.09.13   KSG         product_mix_id 변경 : OSP 중 동일 route_id를 가지는 다른 사이트 존재하여 Site_id로 변경
 * 2019.02.18   KSW         1) 특성 CAPA 반영 (참고)주석2 (특성CAPA관련수정시 1)PROC_BOD, 2)PROC_ITEM_BOD, 3)PROC_FIXED_PLAN, 4)PROC_PRODUCT_MIX, 5)PROC_PRODUCT_MIX_MAP, 6) PROC_FIX_MISMATCHING 동시수정 검토필요)
                            2) descr 컬럼값 변경(특성CAPA반영분은 PROC_FIX_MISMATCHING의 "4. Production Lot Size 설정" 처리부분에서 제외시키기위해서 descr값셋팅함) (참고)주석1, 주석2
 * 2020.02.06   KSG         [OSP Line Plan] OSP이면서 Line별 Capa 적용 Site 제외
 * 2023.10.10   KKC         PJ20230692 SCM 역량 강화 위한 SCP 개선과제 이행 Phase2 : 소형 CAPA 계획 개선 (P-MIX 기능 업그이드/ 완성수량 기준으로 설비별 Daily 완성수량 제약 등록)
 * 2023.10.24   KKC         PJ20230692 SCM 역량 강화 위한 SCP 개선과제 이행 Phase2 : 유한Capa 구간 변경 (기존 52주 : 변경 : 52주 + ADD_DEMAND_PERIOD)  
                            -> 소형만 1차 적용
 * 2023.11.07   KKC         PJ20230692 SCM 역량 강화 위한 SCP 개선과제 이행 Phase2 :  소형 Line Capa공정별 MAX Daily 완성수량 제약 추가
 * 2024.07.16   KKC         E20240806-000434 소형 Daily 완성 수량 Cell 전 모델 확산 적용 요청의 건
 *
 */

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_IN_PRE_PROC_PRODUCT_MIX_MAP]
    ( @p_plan_cycle1  NVARCHAR(150)
    , @p_plan_name1   NVARCHAR(4000)
    , @p_plan_id1     NVARCHAR(4000)
    , @p_modeling_id1 NVARCHAR(4000)
    , @p_seq1         NVARCHAR(4000)
    , @p_plan_type1   NVARCHAR(4000)
    , @p_master_id1   NVARCHAR(4000)
    , @p_division_id1 NVARCHAR(30)
    , @p_engine_plan_id1 NVARCHAR(4000)
    -- , @p_debug       INT OUTPUT
) AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    --20180228 프로시저 속도 개선을 위해서 입력변수를 일반변수로 변경함
    DECLARE @p_plan_cycle  NVARCHAR(150)    = @p_plan_cycle1;
    DECLARE @p_plan_name   NVARCHAR(4000)   = @p_plan_name1;
    DECLARE @p_plan_id     NVARCHAR(4000)   = @p_plan_id1;
    DECLARE @p_modeling_id NVARCHAR(4000)   = @p_modeling_id1 ;
    DECLARE @p_seq         NVARCHAR(4000)   = @p_seq1 ;
    DECLARE @p_plan_type   NVARCHAR(4000)   = @p_plan_type1 ;
    DECLARE @p_master_id   NVARCHAR(4000)   = @p_master_id1 ;
    DECLARE @p_division_id NVARCHAR(30)     = @p_division_id1 ; 
    DECLARE @p_engine_plan_id NVARCHAR(4000) = @p_engine_plan_id1 ; 

    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_IN_PRE_PROC_PRODUCT_MIX_MAP';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'TH_ENG_PRODUCT_MIX_MAP';
    DECLARE @d_event_date   DATETIME;

    DECLARE @n_pre_plan_id       INTEGER = 0;
    DECLARE @n_cur_plan_id       INTEGER = 0;
    DECLARE @n_pre_week_plan_id  INTEGER = 0;
    DECLARE @n_cur_week_plan_id  INTEGER = 0;
    -- DECLARE @v_division_id       NVARCHAR(30);
    DECLARE @v_cur_monday        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    DECLARE @d_plan_name         DATETIME = CONVERT(DATETIME,@p_plan_name);

    DECLARE @d_pet_date          DATETIME ; -- Plan End Date
    DECLARE @d_add_dm_pet        DATETIME ; -- Add Demand Cutoff Date, 2023.10.24 추가

  -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ; 
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN
        
        /* DM ADD 구간으로 유한CAPA 생성, 소형만 적용, 2023.10.24 */
        SELECT @d_pet_date      = CONVERT(DATETIME, p.horizon_end_date)
	        ,  @d_add_dm_pet    = CASE WHEN @p_division_id = '40' THEN  
                                                                       DATEADD(DAY, ISNULL(b.add_dm_day, 0), CONVERT(DATETIME, p.horizon_end_date))
                                       ELSE
                                            CONVERT(DATETIME, p.horizon_end_date)
                                  END 
         FROM dbo.scm_mst_plan p WITH (NOLOCK)
         LEFT OUTER JOIN 
		      (
		        SELECT a.segment1 AS division_id , a.segment2 AS add_dm_week , a.segment2*7 AS add_dm_day 
		          FROM scm_adm_lookup_master_detail a WITH (NOLOCK)
		         WHERE a.lookup_type = 'ADD_DEMAND_PERIOD'
		          AND a.valid_yn    = 'Y' 
                  AND a.segment1    = @p_division_id
		      ) b
           ON 1=1
        WHERE p.division_id = @p_division_id 
          AND p.plan_id     = @p_plan_id 
        ;

        /* ORG
        SELECT @d_pet_date = CONVERT(DATETIME, p.horizon_end_date)
        FROM   dbo.scm_mst_plan p WITH(NOLOCK)
        WHERE  p.division_id = @p_division_id 
        AND    p.plan_id     = @p_plan_id ;
        ;
        */
        
		DELETE 
		FROM   th_eng_product_mix_map_sn
        WHERE plan_id   = @p_engine_plan_id
        AND   master_id = @p_master_id
		;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 1-0 START';
        SET @v_description = N'1-0. 변수설정/데이터 초기화' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
        --1. OSP
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_PRODUCT_MIX_MAP */th_eng_product_mix_map_sn   
        ( master_id
        , plan_id
        , site_id
        , route_id
        , operation_id
        , product_mix_id
        , pmix_res_group_Id --2023.10.10 추가
        , item_id
        , descr
        , product_mix_rate
        )
        SELECT @p_master_id        AS master_id
            ,  @p_engine_plan_id   AS plan_id 
            ,  b.eng_scm_site_id   AS site_id
            ,  c.route_id          AS route_id
            ,  c.route_id          AS operation_id
            -- 2018.09.13 product_mix_id 변경 : OSP 중 동일 route_id를 가지는 다른 사이트 존재하여 Site_id로 변경
            ,  b.scm_site_id + '_' + ( CASE WHEN a.item_id = '-' THEN 'TOTAL' ELSE a.item_id END ) AS product_mix_id 
            -- 생산 공정의 pmix_res_group_Id는 설비기준이지만, 공정 전체 제약시에는 ALL로 등록, 2023.10.10
            ,  'ALL'                      AS pmix_res_group_Id
            ,  CASE WHEN a.item_id = '-' THEN  a.item_id2
                    ELSE a.item_id 
               END AS item_id  
            ,  'OSP'                AS descr --20190218 수정 (변경전 : , NULL AS descr)
            ,  1                    AS product_mix_rate
        FROM   ( --union all 1)TOTAL 아닐떄(=item_id 가 '-' 아닐때)
                 SELECT a.division_id, a.plant_site_id, a.item_id, NULL item_id2
                 FROM   scp_mst_outsourcing_capa a WITH (NOLOCK)
                 WHERE  a.division_id  = @p_division_id
                 AND    a.valid_yn   = 'Y'
                 AND    a.item_id    <> '-'
                 UNION ALL 
                 --union all 1)TOTAL 일때(=item_id 가 '-' 일때) 
                 --            - plant_site_id별 전체item개수 만큼 TOTAL 데이터 생성
                 SELECT a.division_id, a.plant_site_id, a.item_id, b.item_id AS item_id2
                 FROM   scp_mst_outsourcing_capa a WITH (NOLOCK)
                      , scp_mst_outsourcing_capa b WITH (NOLOCK)
                 WHERE  a.division_id  = @p_division_id
                 AND    a.valid_yn   = 'Y'
                 AND    a.division_id  = b.division_id 
                 AND    a.plant_site_id = b.plant_site_id 
                 AND    a.item_id    = '-'
                 AND    b.item_id    <> '-'
                 AND    b.valid_yn   = 'Y'                 
               ) a
               INNER JOIN  (SELECT scm_site_id, eng_scm_site_id 
                            FROM   scm_mst_site_eng WITH (NOLOCK) 
                            WHERE  division_id = @p_division_id 
                            AND    plan_id     = @p_plan_id 
                            AND    plan_type   = @p_plan_type 
                            AND    plan_seq    = @p_seq                           
                            AND    osp_yn      = 'Y'    --외주
                            AND    DBO.FN_SCM_SYS_NVL(attribute1, 'N') = 'N'  --  2020.02.03 [OSP Line Plan] OSP이면서 Line별 Capa 적용 Site 제외
                            AND    eng_scm_site_id LIKE '%~***' -- 20180719 추가 (가상 plant site 생성 제외)
                        ) b
               ON   a.plant_site_id = b.scm_site_id                              
              , (SELECT DISTINCT master_id, plan_id, site_id, route_id                                         
                             FROM   th_eng_resource_sn WITH (NOLOCK) 
                             WHERE  master_id = @p_master_id        
                             AND    plan_id   = @p_engine_plan_id   
                 ) c
        WHERE b.eng_scm_site_id = c.site_id 
        ;


        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 2-0 START';
        SET @v_description = N'2-0. P-MIX MAP 생성(OSP)' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
        --2. 특성 CAPA 반영 (20190218 추가)
        --   - 특성(A~001 -> A~002) BOD 

        -- 특성CAPA관련수정시 1)PROC_BOD, 2)PROC_ITEM_BOD, 3)PROC_FIXED_PLAN, 4)PROC_PRODUCT_MIX, 5)PROC_PRODUCT_MIX_MAP, 6) PROC_FIX_MISMATCHING 동시수정 검토필요
        -----------------------------------------------------------        
        INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_PRODUCT_MIX_MAP */ th_eng_product_mix_map_sn 
        ( master_id
        , plan_id
        , site_id
        , route_id
        , operation_id
        , product_mix_id
        , pmix_res_group_Id   --2023.10.10 추가
        , item_id
        , descr
        , product_mix_rate
        )
        SELECT @p_master_id        AS master_id
            ,  @p_engine_plan_id   AS plan_id 
            ,  b.eng_scm_site_id   AS site_id
            ,  'CHAR::' + d.bod_id AS route_id
            ,  'CHAR::' + d.bod_id AS operation_id            
            ,  b.scm_site_id + '_' + ( CASE WHEN a.item_id = '-' THEN 'TOTAL' ELSE a.item_id END ) AS product_mix_id 
            -- 2023.10.10 pmix_res_group_Id 추가 (설비별 p-mix제약 업그레이드)로 컬럼 추가
            -- BOD공정은 pmix_res_group_Id 매핑 정보 불필요
            ,  NULL                       AS pmix_res_group_Id
            ,  CASE WHEN a.item_id = '-' THEN  a.item_id2
                    ELSE a.item_id 
               END AS item_id  
            ,  'CHAR'               AS descr
            ,  1                    AS product_mix_rate
        FROM   ( --union all 1)TOTAL 아닐떄(=item_id 가 '-' 아닐때)
                 SELECT a.division_id, a.plant_site_id, a.item_id, NULL item_id2
                 FROM   scp_mst_char_capa a WITH (NOLOCK)
                 WHERE  a.division_id  = @p_division_id
                 AND    a.valid_yn   = 'Y'
                 AND    a.item_id    <> '-'
                 UNION ALL 
                 --union all 1)TOTAL 일때(=item_id 가 '-' 일때) 
                 --            - plant_site_id별 전체item개수 만큼 TOTAL 데이터 생성
                 SELECT a.division_id, a.plant_site_id, a.item_id, b.item_id AS item_id2
                 FROM   scp_mst_char_capa a WITH (NOLOCK)
                      , scp_mst_char_capa b WITH (NOLOCK)
                 WHERE  a.division_id   = @p_division_id
                 AND    a.valid_yn      = 'Y'
                 AND    a.division_id   = b.division_id 
                 AND    a.plant_site_id = b.plant_site_id 
                 AND    a.item_id       = '-'
                 AND    b.item_id       <> '-'
                 AND    b.valid_yn      = 'Y'                 
               ) a
               INNER JOIN  (SELECT scm_site_id, eng_scm_site_id 
                            FROM   scm_mst_site_eng WITH (NOLOCK) 
                            WHERE  division_id = @p_division_id 
                            AND    plan_id     = @p_plan_id 
                            AND    plan_type   = @p_plan_type 
                            AND    plan_seq    = @p_seq                           
                            --AND    ISNULL(osp_yn, 'N')      = 'N'    --외주는 특성BOD가 없음
                            AND    eng_scm_site_id LIKE '%~002' -- 20180719 추가 (가상 plant site 생성 제외)
                        ) b
               ON   a.plant_site_id = b.scm_site_id                
               INNER JOIN ( SELECT division_id
                                 , from_site
                                 , to_site
                                 , bod_id  --dbo.fn_scm_split(bod_id , 2, '::') AS bod_id
                            FROM   scm_mst_bod_eng WITH (NOLOCK)
                            WHERE  division_id = @p_division_id 
                            AND    plan_id     = @p_plan_id 
                            AND    plan_type   = @p_plan_type 
                            AND    plan_seq    = @p_seq
                            AND    attribute1  = 'INNER_SITE_A_002' -- 특성BOD(A~001 -> A~002)             
                          ) d
               ON   a.division_id   = d.division_id
               AND  a.plant_site_id = d.from_site
               AND  a.plant_site_id = d.to_site  
        WHERE 1 = 1
        --ORDER BY site_id, product_mix_id desc
        ;


        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 3-0 START';
        SET @v_description = N'3-0. P-MIX MAP 생성(특성:CHAR)' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        
        -----------------------------------------------------------
		-- 3. 설비별 아이템별 Daily 생산수량 제약 등록(완성 기준) (소형 CELL PKG 공정만 대상), 2023.10.10
        -----------------------------------------------------------
        IF @p_division_id  =  '40'             
        
        BEGIN
        
        --//1. 공정별/설비별/아이템별 Daily 완성수량 제약 생성
        --특정IM모델에서 전모델 확산 : 2024.07.16 수정
        INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_PRODUCT_MIX_MAP */ th_eng_product_mix_map_sn
                ( master_id
                , plan_id
                , site_id
                , route_id
                , operation_id
                , product_mix_id
                , pmix_res_group_Id
                , item_id
                , descr
                , product_mix_rate
                )   
           SELECT DISTINCT 
                  @p_master_id         AS master_id
                , @p_engine_plan_id    AS plan_id 
                , b.eng_scm_site_id    AS site_id
                , a.operation_id       AS route_id
                , a.operation_id       AS operation_id
                , a.operation_id + '::' + b.eng_scm_site_id + '::' + a.line_id + '::' + a.item_id AS product_mix_id 
                , a.operation_id + '::' + b.eng_scm_site_id + '::' + a.line_id + '^_G'            AS pmix_res_group_id
                , a.item_id            AS item_id
                , 'LINE'               AS descr 
                ,  1                   AS product_mix_rate
             FROM scp_mst_capa a WITH (NOLOCK)  --//월별로 관리됨. 기준 변경시 생성 쿼리 변경 필요
            INNER JOIN  (SELECT scm_site_id, eng_scm_site_id, plant_id, operation_group 
                           FROM scm_mst_site_eng WITH (NOLOCK) 
                          WHERE division_id = @p_division_id 
                            AND plan_id     = @p_plan_id 
                            AND plan_type   = @p_plan_type 
                            AND plan_seq    = @p_seq                           
                            AND osp_yn      = 'N'    --사내 
                            AND eng_scm_site_id LIKE '%~***'
                        ) b
              ON a.plant_id     = b.plant_id
             AND SUBSTRING(a.operation_id, 1,1)  = b.operation_group
           /* CELL 전모델 P-MIX 적용 확산, 
              하드코딩 쿼리등 정리. 2024.07.16 */
           WHERE a.division_id = @p_division_id
             AND a.value  > 0
             AND a.yyyymm >= LEFT(@p_plan_name, 6)
             AND a.yyyymm <= LEFT(CONVERT(VARCHAR, @d_add_dm_pet, 112), 6)  --@d_pet_date ->@d_add_dm_pet. 2023.10.24 변경
             AND EXISTS (
                          SELECT 'X' 
                            FROM th_eng_resource_sn x WITH (NOLOCK) 
                           WHERE x.master_id = @p_master_id 
                             AND x.plan_id   = @p_engine_plan_id  
                             AND x.site_id   = b.eng_scm_site_id
                             AND x.route_id  = a.operation_id
                             AND x.resource_id LIKE '%'+a.line_id
                        )
        ;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 4-0 START';
        SET @v_description = N'4-1. P-MIX 생성(소형 LINE별/아이템별 Daily 완성수량 제약)' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        
        --//2. 공정별/설비별 MAX Daily 완성수량 제약 생성, 2023.11.07 추가
        INSERT INTO th_eng_product_mix_map_sn
              (
                master_id
              , plan_id
              , site_id
              , route_id
              , operation_id
              , product_mix_id
              , pmix_res_group_id
              , item_id
              , product_mix_rate
              , descr
              )
        SELECT  DISTINCT 
                a.master_id
              , a.plan_id
              , a.site_id
              , a.route_id
              , a.operation_id
        --	  , a.product_mix_id                               AS org_product_mix_id
	          , REPLACE(a.pmix_res_group_id, '^_G', '::TOTAL') AS product_mix_id
              , a.pmix_res_group_id
              , a.item_id
              , a.product_mix_rate
              , a.descr
          FROM th_eng_product_mix_map_sn a WITH(NOLOCK)
         WHERE a.master_id = @p_master_id
           AND a.plan_id   = @p_engine_plan_id
           AND a.descr = 'LINE'
        ;
        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 4-0 START';
        SET @v_description = N'4-2. P-MIX 생성(소형 LINE별 MAX Daily 완성수량 제약)' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
        --4. LINE별 P-MIX 제약 매핑 정보 UPDATE, 2023.10.10 추가
        -----------------------------------------------------------        
        UPDATE a
           SET a.pmix_res_group_id = b.pmix_res_group_id
          FROM th_eng_resource_sn    a WITH(NOLOCK)
          JOIN th_eng_product_mix_sn b WITH(NOLOCK)
            ON a.master_id   = b.master_id
           AND a.plan_id     = b.plan_id    
           AND a.resource_id+'^_G' =  b.pmix_res_group_id 
        WHERE a.master_id = @p_master_id
          AND a.plan_id   = @p_engine_plan_id
        ;

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 5-0 START';
        SET @v_description = N'5-0. RESOURCE.P-MIX GROUP 매핑' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        END --//@p_division_id  =  '40'  END

        -----------------------------------------------------------

        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        -- TXN LOG
        --SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id; 
        SET @v_description = 'Process Complete...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        IF @@TRANCOUNT > 0
          BEGIN
            COMMIT WORK;
          END;

      END;

    END TRY

    BEGIN CATCH
      -- ROLLBACK
      -- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000)); 
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE()) + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
      return -1
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ; 
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    return 1

  END;

