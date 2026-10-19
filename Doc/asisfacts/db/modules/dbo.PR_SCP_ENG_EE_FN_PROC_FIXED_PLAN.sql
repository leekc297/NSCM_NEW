
/*
 * Program ID   : PR_SCP_ENG_EE_FN_PROC_FIXED_PLAN
 * Description  : 
           1.(주석처리됨) PLAN_TYPE = 'MA' 일때
            (20181219 주석처리함 (PR 수정안됨-> PR수정가능으로 변경되면서 "MA, TM"처리도 "SE, FN"과 동일하게 수정함으로 주석처리함) 
              - 동일 plan_id의 이전 plan_type의 최종seq의 데이터 사용(descr IN ('DO::SSP', 'DO::DELIVERY', 'DO::CFM'))

           2. (20181219수정) PLAN_TYPE = 'SE', 'FN', 'MA', 'TM' 일때 (변경전 : PLAN_TYPE = 'SE', 'FN' 일때)
                  -----------------------------------------------------------
                  --1. SEMI 출하계획 정보 Insert (확정구간내(scm_mst_site_eng.ship_frozen))
                  -----------------------------------------------------------
                      - scp_anl_shipment_plan_semi 테이블의 동일 plan_id의 이전 plan_type의 최종seq 데이터로 데이터생성함
                       
                      - 참고 테이블) scp_anl_shipment_plan_semi : SEMI 출하계획정보                        

                  -----------------------------------------------------------
                  --2. FG 출하계획 정보 Insert (확정구간내(scm_mst_site_eng.ship_frozen))
                  -----------------------------------------------------------
                      - scp_anl_shipment_plan_fg 테이블의 동일 plan_id의 이전 plan_type의 최종seq 데이터로 데이터생성함
                        
                      - 참고 테이블) scp_anl_shipment_plan_fg : FG 출하계획  정보     
                   
                -----------------------------------------------------------
                  --3. (FIX) SSP, SCP 출하계획 확정정보 Insert (확정구간(ship_frozen) 이후구간)
                  -----------------------------------------------------------
				     20190624) SCP 출하계획 확정정보만 사용 : 확정구간(ship_frozen) 이후는 SSP 출하계획 확정정보 사용 안 함
					              scp qty, scp fix_id

				     OLD : Start)
                       -1. SCP qty >= SSP qty 이면 scp qty , scp fix_id
                       -2. SCP qty <  SSP qty 이면 
                                         1) scp qty 유지, scp fix_id
                                         2) ssp qty - scp qty : 신규 Fixed Plan으로 Insert, ssp confirm_id    
				     OLD : End)                
                       
                       - (20181220 수정 키중복방지)      ssp_anl_ship_confirm 테이블에 동일정보에 여러건의 데이터가 존재하므로 SUM(수량) 처리함 ( Confirm_id는 'C' + 임의의값("ROW_NUMBER(ORDER BY ssp.item_id)") 형식으로 생성함)
                       - (20190104 수정 조인조건 컬럼값) site_type = 'PLANT'일때 1) project_code = '-', 2) incoterms = '-' 처리함  ( site_type='PLANT'일때 SCP(scp_anl_shipment_plan_fix), SSP(ssp_anl_ship_confirm) 같은정보인데 project_code, incoterms 값이 존재하는건도 있고 없는건도 존재해서 조인처리시 서로다른건으로 인식되므로 '-'로 셋팅함)

                       - 참고 테이블) 1) scp_anl_shipment_plan_fix : SCP 출하계획 확정정보
                                      2) ssp_anl_ship_confirm      : SSP 출하계획 확정정보
 
 * OutTable     :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017.12.01   정원식         Initial Release  전지본부 GSCM(DM/SCP) 구축 프로젝트
 * 2018.05.25   KSW            plan type = 'MA' 일때  descr 조회조건 변경 ( 변경후 : descr IN ('DO::SSP', 'DO::DELIVERY'),  변경전 : descr IN ('DO::SEMI', 'DO::FG') )
 * 2018.05.28   KSW            plan type = 'MA' 일때  선적 FIX plan 추가로 인한 descr 조회조건 변경 ( 변경후 : descr IN ('DO::SSP', 'DO::DELIVERY', 'DO::CFM'),  변경전 : descr IN ('DO::SSP', 'DO::DELIVERY') )
 * 2018.07.11   KSW            ssp_anl_ship_confirm 테이블 사용시 change_type = 'C' 조건추가
 * 2018.11.15   KSW            plan_type = 'TM' (시뮬레이션용으로 'MA'와 동일하게 처리됨) (참고)주석1
 * 2018.12.07   KSW            SE/FN의 "SEMI 확정 출하 계획 정보 Insert" 처리부분 조회조건 추가 (외부site일때만 처리하기 위해서 조회조건추가)  : 이부분 수정시 PROC_BOD의 fixed_term 컬럼 처리부분 검토 필요함 (참고)SE/FN처리의 주석1
 * 2018.12.19   KSW            MA, TE 처리부분 수정 (PR 수정안됨-> PR수정가능으로 변경되면서 "MA, TM"처리도 "SE, FN"과 동일하게 수정)  (참고)주석1
 * 2018.12.20   KSW            키중복오류관련 수정 (DISTINCT처리함) (참고)주석3
 * 2019.01.04   KSW            (FIX) 확정 출하 계획 정보 Insert 부분수정 (참고)주석3  (  scp_anl_shipment_plan_fix테이블은 to site가 PLANT 일때 project_code, incoterms컬럼모두 NULL 인데  ssp_anl_ship_confirm 테이블은     to site가 PLANT 일때도 project_code, incoterms컬럼 둘다 값을 가지고 있어서  조인이 안되므로 to site가  PLANT 일때 두테이블의 project_code, incoterms 컬럼의 값을 '-'로 셋팅함 )
 * 2019.01.22   KSW            (속도개선) (FIX) 확정 출하 계획 정보 Insert처리부분 조인방법변경 (참고)주석3
 * 2019.06.24   KSG            [C20190621_23161] 확정구간(ship_frozen) 이후는 SSP 출하계획 확정정보 사용 안 함
 * 2021.05.26   KKC            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 : TM버전에 대해서는 FIX 데이터 미생성
 * 2024.08.12   KKC            PJ20244573  LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성 : 전극 MA 계획 수립시, 전체 출하확정구간(52주) 중 Plant별 Ship Frozon구간내는 SSP 확정계획으로 동기화 요청
                               SHIP FROZON 구간 유지 / SSP FROZON 구간 별도 구분 로직 구현
 * 2024.10.07   KKC            PJ20249346  LGES SCP 개선과제 이행 : 자동차 해외법인 통합FP 52주 Daily 생산/출하계획 동기화 및 튜닝
                               1. 52주fp통합 관련 전극은 출하계획 기존로직 유지(변경x)
                               3. ssp 동기화 테이블 변경 (ssp_anl_ship_confirm -> scm_dnm_ssp_plan_v)
 *
 */

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_EE_FN_PROC_FIXED_PLAN]
    ( @p_plan_cycle1  NVARCHAR(150)
    , @p_plan_name1   NVARCHAR(4000)
    , @p_plan_id1     NVARCHAR(4000)
    , @p_modeling_id1 NVARCHAR(4000)
    , @p_seq1         NVARCHAR(4000)
    , @p_plan_type1   NVARCHAR(4000)
    , @p_master_id1   NVARCHAR(4000)
    , @p_division_id1 NVARCHAR(30)
    , @p_engine_plan_id1 NVARCHAR(4000)

    , @p_pre_plan_type1 NVARCHAR(4000)
    , @p_pre_plan_seq1  NVARCHAR(4000)
    , @p_pre_engine_plan_id1 NVARCHAR(4000)
    
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
    
    DECLARE @p_pre_plan_type NVARCHAR(4000) = @p_pre_plan_type1;
    DECLARE @p_pre_plan_seq  NVARCHAR(4000) = @p_pre_plan_seq1;
    DECLARE @p_pre_engine_plan_id NVARCHAR(4000) = @p_pre_engine_plan_id1; 

    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_EE_FN_PROC_FIXED_PLAN';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'TH_ENG_FIXED_PLAN';
    DECLARE @d_event_date   DATETIME;

    DECLARE @n_pre_plan_id       INTEGER = 0;
    DECLARE @n_cur_plan_id       INTEGER = 0;
    DECLARE @n_pre_week_plan_id  INTEGER = 0;
    DECLARE @n_cur_week_plan_id  INTEGER = 0;
    -- DECLARE @v_division_id       NVARCHAR(30);
    DECLARE @v_cur_monday        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    DECLARE @d_plan_name         DATETIME = CONVERT(DATETIME,@p_plan_name);
    DECLARE @v_pet_date          NVARCHAR(8) ; -- Plan End Date

    -- 확정계획 대상 plan 정보
    DECLARE @v_pre_plan_start_yyyymmdd NVARCHAR(8);  --plan_name
    DECLARE @v_pre_plan_type           NVARCHAR(50); --plan_type
    DECLARE @n_pre_plan_seq            INTEGER;      --plan_seq
    DECLARE @v_pre_plan_id             NVARCHAR(8); --plan_id

  -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN

        SELECT @v_pet_date = p.horizon_end_date
        FROM   dbo.scm_mst_plan p WITH(NOLOCK)
        WHERE  p.division_id = @p_division_id 
        AND    p.plan_id     = @p_plan_id ;

        -----------------------------------------------------------
        --SSP 동기화 데이터 공용화, 2024.10.07 추가
        --SSP View 테이블으로 JOIN처리시 속도 저하 방지 및 재사용 공용화
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#scm_dnm_ssp_plan_v_temp') IS NOT NULL
        BEGIN 
            DROP TABLE  #scm_dnm_ssp_plan_v_temp;   
        END 

        SELECT *
          INTO #scm_dnm_ssp_plan_v_temp
          FROM scm_dnm_ssp_plan_v a WITH (NOLOCK)  -- 테이블 변경 (ssp_anl_ship_confirm -> scm_dnm_ssp_plan_v)
         WHERE 1=1 --a.division_id  = @p_division_id --전극은 공통사업부
           AND a.qty          > 0
           AND a.yyyymmdd     >= @p_plan_name
           AND a.yyyymmdd     <= @v_pet_date
           AND a.ssp_type     = 'CFM'  
           AND a.biz_type     = 'E'  --전극만
        ;
       
        DELETE /* PR_SCP_ENG_EE_FN_PROC_FIXED_PLAN */ 
        FROM   th_eng_fixed_plan_sn
        WHERE  master_id = @p_master_id
        AND    plan_id   = @p_engine_plan_id 
        ;
        -----------------------------------------------------------
        --1) scp_anl_shipment_plan_semi 테이블의  최종입력 데이터의 plan 정보 조회 
        SELECT @v_pre_plan_start_yyyymmdd = @p_plan_name 
             , @v_pre_plan_type           = @p_pre_plan_type
             , @n_pre_plan_seq            = @p_pre_plan_seq;

               
        /* 전극 MA 생성 기준 변경, 2024.08.12 */
        IF @p_plan_type IN ( 'MA', 'TM') --20181115 수정 plan_type = 'TM'(시뮬레이션용으로 'MA'와 동일하게 처리됨)  (변경전 : IF @p_plan_type = 'MA')
        BEGIN

        -----------------------------------------------------------
        --2) SSP대상 확정 출하 계획 정보 Insert  (ssp_plan_period 기간내)   
        -- SSP 출하계획 확정정보(ssp_anl_ship_confirm) 중 ssp_frozen기간내의 데이터만 INSERT
        -- 전극 PR SSP 동기화 기준 재사용, 2024.08.12
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_EE_FN_PROC_FIXED_PLAN */ th_eng_fixed_plan_sn
        ( master_id
        , plan_id
        , work_order_id
        , work_order_seq
        , site_id
        , route_id
        , operation_id
        , item_id
        , resource_id
        , sub_resource_id
        , start_dttm
        , end_dttm
        , operation_qty
        , complete_qty
        , lot_id
        , is_fixed
        , is_prev_schedule
        , keep_work_time_type
        , keep_qty_type
        , sales_model_id
        , attribute_set_id
        , demand_id
        , descr
        , is_noh_consume
        )
        SELECT @p_master_id      AS master_id
             , @p_engine_plan_id AS plan_id              
             , a.confirm_id      AS work_order_id             
             , 1                 AS work_order_seq
             , be.eng_to_site    AS site_id --(변경전 : , a.to_site_id  AS site_id)
             , a.item_id + '::' + a.bod_id + '::x::x' AS route_id
             , a.item_id + '::' + a.bod_id + '::x::x' AS operation_id
             , a.item_id
             , a.item_id + '::' + a.bod_id + '::x::x' AS resource_id
             , NULL              AS sub_resource_id             
             , CONVERT(DATETIME, a.yyyymmdd) AS start_dttm
             , a.eta_date        AS end_dttm														
             , a.qty             AS operation_qty
             , a.qty             AS complete_qty             
             , a.confirm_id      AS lot_id
             , 'N'               AS is_fixed 
             , 'Y'               AS is_prev_schedule
             , 'START_FIX'       AS keep_work_time_type
             , 'ALL_QTY_FIX'     AS keep_qty_type
             , NULL              AS sales_model_id
             , NULL              AS attribute_set_id
             , NULL              AS demand_id
             , 'DO::SSP'         AS descr
             , 'Y'               AS is_noh_consume	       
        FROM   ( SELECT sc.division_id, sc.confirm_id, sc.from_site
                      , ISNULL((SELECT TOP 1 b.bod_id 
								  FROM scp_mst_bod_n_v b
								 WHERE b.division_id    = sc.division_id
								   AND b.from_site      = sc.from_site
								   AND b.to_site        = md.segment1
								   AND b.incoterms      = 'DAP' --sc.incoterms
								   AND b.transport_mode = sc.transport_mode
								   AND sc.yyyymmdd      BETWEEN b.from_yyyymmdd AND b.to_yyyymmdd
								   AND b.bod_valid_yn   = 'Y'
								 ORDER BY b.priority
							   ) 
                             , sc.bod_id)               AS bod_id
                      , ISNULL(md.segment1, sc.to_site) AS to_site
                      , sc.incoterms, sc.transport_mode, sc.change_type, sc.biz_type
                      , sc.project_code, sc.fcst_type
                      , sc.item_id, sc.yyyymmdd
                      , IIF(ISNULL(sc.eta_date, '') = '', CONVERT(DATETIME, sc.yyyymmdd), sc.eta_date) AS eta_date
                      , sc.qty
                 FROM #scm_dnm_ssp_plan_v_temp sc WITH (NOLOCK) --ssp 테이블 변경(기존:ssp_anl_ship_confirm), 2024.10.07
                 LEFT OUTER JOIN scm_adm_lookup_master_detail md WITH(NOLOCK)
                   ON sc.division_id = md.segment3
                  AND sc.to_site     = md.segment2
                  AND md.lookup_type = 'AS_SITE_PLANT'
                  AND md.valid_yn    = 'Y'
                WHERE 1=1 -- division_id  = @p_division_id  -- 전극 'EE' 사업부 없음
               ) a              
              INNER JOIN ( SELECT scm_site_id
                                , ship_frozen
                                --, attribute3   AS ssp_frozen
                                /* ssp frozen 정의 
                                   ssp frozen > scp frozen이면, scp frozen 기준 
                                 */
                                , CASE WHEN attribute3 > ship_frozen THEN ship_frozen
                                       ELSE attribute3
                                    END        AS ssp_frozen
                            FROM  scm_mst_site_eng WITH (NOLOCK)
                            WHERE modeling_id = @p_modeling_id
                              AND plan_id     = @p_plan_id
                              AND plan_type   = @p_plan_type
                              AND plan_seq    = @p_seq
                              AND division_id = @p_division_id
                              AND eng_scm_site_id = scm_site_id + '~***'    --scp_anl_shipment_plan_semi 는 BOD가  from site (plant site) ->  to site (plant site)
                         )  mse
               ON a.from_site = mse.scm_site_id
            INNER JOIN ( SELECT dbo.FN_SCM_SPLIT(bod_id, 1, '::')  AS bod_id
                              , CONVERT(NUMERIC(18,3),attribute10) AS bod_lead_time
                              , eng_to_site
                           FROM scm_mst_bod_eng WITH (NOLOCK)
                          WHERE plan_id     = @p_plan_id
                            AND plan_type   = @p_plan_type
                            AND plan_seq    = @p_seq
                            AND division_id = @p_division_id        
                          --AND attribute1  = 'OUTER_SITE'  -- 공장외부 일때  
                          ) be
              ON a.bod_id = be.bod_id
           WHERE a.yyyymmdd >= @p_plan_name --@v_cur_monday
             AND a.yyyymmdd <  CONVERT(NVARCHAR(8), DATEADD(d, ISNULL(mse.ssp_frozen, 0), @d_plan_name), 112)
        ;

        -----------------------------------------------------------
        --3) ssp_frozen ~ ship frozen
        -----------------------------------------------------------
        -----------------------------------------------------------
        --3-1) SEMI 출하계획 정보 Insert
        --SEMI 출하계획 정보(scp_anl_shipment_plan_semi)에서 이전 plan_type 정보 사용
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_EE_FN_PROC_FIXED_PLAN */ th_eng_fixed_plan_sn
                ( master_id
                , plan_id
                , work_order_id
                , work_order_seq
                , site_id
                , route_id
                , operation_id
                , item_id
                , resource_id
                , sub_resource_id
                , start_dttm
                , end_dttm
                , operation_qty
                , complete_qty
                , lot_id
                , is_fixed
                , is_prev_schedule
                , keep_work_time_type
                , keep_qty_type
                , sales_model_id
                , attribute_set_id
                , demand_id
                , descr
                , is_noh_consume
                )
            SELECT    @p_master_id AS master_id
                    , @p_engine_plan_id AS plan_id              
                    , 'DO::SEMI::' + CONVERT(NVARCHAR(10), 100000 + ROW_NUMBER() OVER (ORDER BY item_id)) AS work_order_id  -- 임의의 중복되지 않는값을 사용하기 위해서 row_number() 처리 함              
                    , 1 AS work_order_seq
                    , a.to_site + '~***' AS site_id
                    , a.item_id + '::' + a.bod_id + '::x::x' AS route_id
                    , a.item_id + '::' + a.bod_id + '::x::x' AS operation_id
                    , a.item_id
                    , a.item_id + '::' + a.bod_id + '::x::x' AS resource_id
                    , NULL AS sub_resource_id             
                    , CONVERT(DATETIME, a.yyyymmdd) AS start_dttm
                    , DATEADD(d, be.bod_lead_time, CONVERT(DATETIME,a.yyyymmdd)) AS end_dttm             
                    , a.qty AS operation_qty
                    , a.qty AS complete_qty             
                    , 'DO::SEMI::' + CONVERT(NVARCHAR(10), 100000 + ROW_NUMBER() OVER (ORDER BY item_id)) AS lot_id
                    , 'N' AS is_fixed
                    , 'Y' AS is_prev_schedule
                    , 'START_FIX' AS keep_work_time_type
                    , 'ALL_QTY_FIX' AS keep_qty_type
                    , NULL AS sales_model_id
                    , NULL AS attribute_set_id
                    , NULL AS demand_id
                    , 'DO::SEMI' AS descr
                    , 'Y' AS is_noh_consume
            FROM ( SELECT * 
                     FROM scp_anl_shipment_plan_semi WITH (NOLOCK)  
                    WHERE division_id         = @p_division_id             -- 'EE'
                      AND plan_start_yyyymmdd = @v_pre_plan_start_yyyymmdd
                      AND plan_type           = @v_pre_plan_type 
                      AND seq                 = @n_pre_plan_seq 
                      AND measure             = 'SHIP_PLAN_AMEND'
                      AND qty                 > 0
                  ) a               
          INNER HASH JOIN (  
                      SELECT ship_frozen
                           , scm_site_id
                           --, attribute3   AS ssp_frozen
                           /* ssp frozen 정의 
                              ssp frozen > scp frozen이면, scp frozen 기준 
                            */
                           , CASE WHEN attribute3 > ship_frozen THEN ship_frozen
                                  ELSE attribute3
                               END        AS ssp_frozen
                        FROM scm_mst_site_eng WITH (NOLOCK)
                       WHERE modeling_id = @p_modeling_id
                         AND plan_id     = @p_plan_id
                         AND plan_type   = @p_plan_type
                         AND plan_seq    = @p_seq
                         AND division_id = @p_division_id
                         AND eng_scm_site_id = scm_site_id + '~***'    --scp_anl_shipment_plan_semi 는 BOD가  from site (plant site) ->  to site (plant site)
                        )  mse
            ON a.from_site = mse.scm_site_id
         INNER JOIN ( SELECT dbo.FN_SCM_SPLIT(bod_id, 1, '::')  AS bod_id
                           , CONVERT(NUMERIC(18,3),attribute10) AS bod_lead_time
                       FROM scm_mst_bod_eng WITH (NOLOCK)
                      WHERE modeling_id = @p_modeling_id
                        AND plan_id     = @p_plan_id
                        AND plan_type   = @p_plan_type
                        AND plan_seq    = @p_seq
                        AND division_id = @p_division_id 
                        AND attribute1  = 'OUTER_SITE'  -- 20181207 추가 PROC_BOD의 fixed_term컬럼값이 외부site일때만(내부site일때는 fixed_term=0) 존재하므로 조건추가함 :이부분수정시 PROC_BOD의 fixed_term 부분검토필요함
                    ) be
           ON a.bod_id = be.bod_id
        /* ssp_frozen >= ship frozen이면, 이런 데이터가 생성이 필요없다 */
        WHERE a.yyyymmdd >= CONVERT(NVARCHAR(8), DATEADD(d, ISNULL(mse.ssp_frozen, 0), @d_plan_name), 112)
          AND a.yyyymmdd <  CONVERT(NVARCHAR(8), DATEADD(d, ISNULL(mse.ship_frozen, 0), @d_plan_name), 112)  -- SE, FN ship_frozen : 364 ( 참고 : PR_SCP_ENG_EE_FN_SET_SITE_ENG의 ship_frozen 컬럼 생성부분)
        ;

        -----------------------------------------------------------
        --3-2) FG 출하계획 정보 Insert 
        --FG 출하계획 정보(scp_anl_shipment_plan_fg)에서 이전 plan_type 정보 사용
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_EE_FN_PROC_FIXED_PLAN */ th_eng_fixed_plan_sn
        ( master_id
        , plan_id
        , work_order_id
        , work_order_seq
        , site_id
        , route_id
        , operation_id
        , item_id
        , resource_id
        , sub_resource_id
        , start_dttm
        , end_dttm
        , operation_qty
        , complete_qty
        , lot_id
        , is_fixed
        , is_prev_schedule
        , keep_work_time_type
        , keep_qty_type
        , sales_model_id
        , attribute_set_id
        , demand_id
        , descr
        , is_noh_consume
        )
        SELECT @p_master_id AS master_id
                , @p_engine_plan_id AS plan_id              
                , 'DO::FG::' + CONVERT(NVARCHAR(10), 200000 + ROW_NUMBER() OVER (ORDER BY item_id)) AS work_order_id  -- 임의의 중복되지 않는값을 사용하기 위해서 row_number() 처리 함              
                , 1 AS work_order_seq
                , a.to_site + '~' + a.incoterms AS site_id
                , a.item_id + '::' + a.bod_id + '::x::x' AS route_id
                , a.item_id + '::' + a.bod_id + '::x::x' AS operation_id
                , a.item_id
                , a.item_id + '::' + a.bod_id + '::x::x' AS resource_id
                , NULL AS sub_resource_id             
                , CONVERT(DATETIME,a.yyyymmdd) AS start_dttm
                , DATEADD(d, be.bod_lead_time, CONVERT(DATETIME,a.yyyymmdd)) AS end_dttm             
                , a.qty AS operation_qty
                , a.qty AS complete_qty                         
                , 'DO::FG::' + CONVERT(NVARCHAR(10), 200000 + ROW_NUMBER() OVER (ORDER BY item_id)) AS lot_id
                , 'N' AS is_fixed
                , 'Y' AS is_prev_schedule
                , 'START_FIX' AS keep_work_time_type
                , 'ALL_QTY_FIX' AS keep_qty_type
                , NULL AS sales_model_id
                , NULL AS attribute_set_id
                , NULL AS demand_id
                , 'DO::FG' AS descr
                , 'Y' AS is_noh_consume
        FROM (   SELECT * 
                  FROM scp_anl_shipment_plan_fg WITH (NOLOCK)
                  WHERE division_id         = @p_division_id              -- 'EE'
                    AND plan_start_yyyymmdd = @v_pre_plan_start_yyyymmdd
                    AND plan_type           = @v_pre_plan_type
                    AND seq                 = @n_pre_plan_seq
                    AND measure             = 'SHIP_PLAN_AMEND'
                    AND qty                 > 0
                ) a               
            INNER HASH JOIN (  SELECT ship_frozen
                                    , scm_site_id
                                    --, attribute3   AS ssp_frozen
                                    /* ssp frozen 정의 
                                       ssp frozen > scp frozen이면, scp frozen 기준 
                                     */
                                    , CASE WHEN attribute3 > ship_frozen THEN ship_frozen
                                           ELSE attribute3
                                        END        AS ssp_frozen
                                 FROM scm_mst_site_eng WITH (NOLOCK)
                                WHERE modeling_id = @p_modeling_id
                                  AND plan_id     = @p_plan_id
                                  AND plan_type   = @p_plan_type
                                  AND plan_seq    = @p_seq
                                  AND division_id = @p_division_id                                            
                                  AND eng_scm_site_id = scm_site_id + '~***' 
                           )  mse
            ON a.from_site = mse.scm_site_id  --scp_anl_shipment_plan_fg 는 BOD가  from site (plant site) ->  to site (sales site)
            INNER JOIN ( SELECT dbo.FN_SCM_SPLIT(bod_id, 1, '::')  AS bod_id
                               , CONVERT(NUMERIC(18,3),attribute10) AS bod_lead_time
                            FROM scm_mst_bod_eng WITH (NOLOCK)
                           WHERE modeling_id = @p_modeling_id
                             AND plan_id     = @p_plan_id
                             AND plan_type   = @p_plan_type
                             AND plan_seq    = @p_seq
                             AND division_id = @p_division_id
                              -- AND    attribute1  = 'INNER_SITE'  -- 공장내부 일때 : FG는 전부 외부임                         
                        ) be
           ON a.bod_id = be.bod_id			   
        /* ssp_frozen >= ship frozen이면, 이런 데이터가 생성이 필요없다 */
        WHERE a.yyyymmdd >= CONVERT(NVARCHAR(8), DATEADD(d, ISNULL(mse.ssp_frozen, 0), @d_plan_name), 112)
          AND a.yyyymmdd <  CONVERT(NVARCHAR(8), DATEADD(d, ISNULL(mse.ship_frozen, 0), @d_plan_name), 112)  -- SE, FN ship_frozen : 364 ( 참고 : PR_SCP_ENG_EE_FN_SET_SITE_ENG의 ship_frozen 컬럼 생성부분)
        ;

        -----------------------------------------------------------
        --3-3) ship frozen 구간외 fix
         -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_EE_FN_PROC_FIXED_PLAN */ th_eng_fixed_plan_sn
                ( master_id
                , plan_id
                , work_order_id
                , work_order_seq
                , site_id
                , route_id
                , operation_id
                , item_id
                , resource_id
                , sub_resource_id
                , start_dttm
                , end_dttm
                , operation_qty
                , complete_qty
                , lot_id
                , is_fixed
                , is_prev_schedule
                , keep_work_time_type
                , keep_qty_type
                , sales_model_id
                , attribute_set_id
                , demand_id
                , descr
                , is_noh_consume
                )
                SELECT DISTINCT --20181220 distinct 추가 (ssp_anl_ship_confirm 아래조인시 중복건 존재 -> division_id= '81', confirm_id : C20181217342707, C20181217342708, C20181217342709)
                       @p_master_id              AS master_id
                     , @p_engine_plan_id         AS plan_id             
                     , a.id                      AS work_order_id             
                     , 1                         AS work_order_seq
                     , be.eng_to_site            AS site_id --(변경전 : , a.to_site_id  AS site_id)
                     , a.item_id + '::' + a.bod_id + '::x::x' AS route_id
                     , a.item_id + '::' + a.bod_id + '::x::x' AS operation_id
                     , a.item_id
                     , a.item_id + '::' + a.bod_id + '::x::x' AS resource_id
                     , NULL                                   AS sub_resource_id             
                     , CONVERT(DATETIME, a.yyyymmdd)          AS start_dttm
                     , DATEADD(d, be.bod_lead_time, CONVERT(DATETIME,a.yyyymmdd)) 
                                                              AS end_dttm             
                     , a.qty                                  AS operation_qty
                     , a.qty                                  AS complete_qty             
                     , a.id                                   AS lot_id
                     , 'N'                                    AS is_fixed
                     , 'Y'                                    AS is_prev_schedule
                     , 'START_FIX'                            AS keep_work_time_type
                     , 'ALL_QTY_FIX'                          AS keep_qty_type
                     , NULL                                   AS sales_model_id
                     , NULL                                   AS attribute_set_id
                     , NULL                                   AS demand_id
                     , 'DO::CFM'                              AS descr
                     , 'Y'                                    AS is_noh_consume
				-- Start : (20190624) SCP 출하계획 확정정보만 사용 : 확정구간(ship_frozen) 이후는 SSP 출하계획 확정정보 사용 안 함
                FROM   (SELECT scp.fix_id     AS id 
                             , scp.item_id    AS item_id
                             , scp.bod_id     AS bod_id
                             , scp.yyyymmdd   AS yyyymmdd
                             , scp.from_site  AS from_site
                             , scp.qty        AS qty    
                         FROM 
                            ( SELECT f.division_id, f.yyyymmdd, f.biz_type, f.item_id 
			                       , f.from_site, f.to_site
			                       , CASE WHEN mse.site_type = 'PLANT' THEN '-'
			                              ELSE f.project_code
			                          END project_code
			                       , CASE WHEN mse.site_type = 'PLANT' THEN '-'
			                              ELSE f.incoterms
			                          END incoterms
                                   , f.bod_id, f.fix_id, f.qty
                               FROM scp_anl_shipment_plan_fix f WITH (NOLOCK)
                              INNER JOIN ( SELECT DISTINCT division_id, scm_site_id, site_type
                                             FROM scm_mst_site_eng WITH (NOLOCK)
                                            WHERE modeling_id = @p_modeling_id --'201'
                                              AND plan_id     = @p_plan_id     --'105904'
                                              AND plan_type   = @p_plan_type   --'SP'
                                              AND plan_seq    = @p_seq         --'1'
                                              AND division_id = @p_division_id --'81'
                                         )  mse
                                ON f.division_id = mse.division_id
			                   AND f.to_site     = mse.scm_site_id
                             WHERE f.division_id   = @p_division_id -- '81'  
                               AND f.qty           >  0
                               AND f.yyyymmdd      >= @p_plan_name  --'20190103'
			                   /* TM버전은 FIX 데이터 미생성, 2021/05/26, By KKC */
			                   AND 1= CASE WHEN @p_plan_type = 'TM' THEN 0
			                   	           ELSE 1
			                           END
                             ) scp 
                       ) a  
                   INNER JOIN (  SELECT scm_site_id
                                      , ship_frozen
                                    --, attribute3   AS ssp_frozen
                                    /* ssp frozen 정의 
                                       ssp frozen > scp frozen이면, scp frozen 기준 
                                     */
                                      , CASE WHEN attribute3 > ship_frozen THEN ship_frozen
                                             ELSE attribute3
                                         END        AS ssp_frozen
                                  FROM  scm_mst_site_eng WITH (NOLOCK)
                                 WHERE  modeling_id = @p_modeling_id
                                   AND  plan_id     = @p_plan_id
                                   AND  plan_type   = @p_plan_type
                                   AND  plan_seq    = @p_seq
                                   AND  division_id = @p_division_id
                                   AND  eng_scm_site_id = scm_site_id + '~***'    --scp_anl_shipment_plan_semi 는 BOD가  from site (plant site) ->  to site (plant site)
                              )  mse
                    ON a.from_site = mse.scm_site_id
                    --20190122 수정 (속도개선)INNER JOIN을 LEFT JOIN으로 수정
                    LEFT JOIN ( SELECT dbo.FN_SCM_SPLIT(bod_id, 1, '::')  AS bod_id  --20190122 수정(변경전 : INNER JOIN ( SELECT dbo.FN_SCM_SPLIT(bod_id, 1, '::')  AS bod_id )                                                                                                         
                                      , CONVERT(NUMERIC(18,3),attribute10) AS bod_lead_time
                                      , eng_to_site
                                  FROM  scm_mst_bod_eng WITH (NOLOCK)
                                 WHERE  plan_id     = @p_plan_id
                                   AND  plan_type   = @p_plan_type
                                   AND  plan_seq    = @p_seq
                                   AND  division_id = @p_division_id        
                                 --AND  attribute1  = 'OUTER_SITE'  -- 공장외부 일때  
                               ) be
           ON a.bod_id = be.bod_id
        WHERE a.yyyymmdd >=  CONVERT(NVARCHAR(8), DATEADD(d, ISNULL(mse.ship_frozen, 0), @d_plan_name), 112) --확정구간 이후
          AND a.yyyymmdd <= @v_pet_date
          AND be.bod_id IS NOT NULL --20190122 추가 (속도개선)INNER JOIN을 LEFT JOIN으로 수정하면서 INNER JOIN과 같은결과를 얻기위해서 추가함
        ;

        END


        ELSE
        --나머지 PLAN TYPE은 유지, 2024.08.12
        --IF @p_plan_type NOT IN ( 'MA', 'TM')        
        BEGIN

                -----------------------------------------------------------
                --1. SEMI 출하계획 정보 Insert (Ship Frozen 구간 내)
                --   - SEMI 출하계획 정보(scp_anl_shipment_plan_semi)에서 이전 plan_type 정보 사용
                -----------------------------------------------------------
                INSERT INTO /* PR_SCP_ENG_EE_FN_PROC_FIXED_PLAN */ th_eng_fixed_plan_sn
                ( master_id
                , plan_id
                , work_order_id
                , work_order_seq
                , site_id
                , route_id
                , operation_id
                , item_id
                , resource_id
                , sub_resource_id
                , start_dttm
                , end_dttm
                , operation_qty
                , complete_qty
                , lot_id
                , is_fixed
                , is_prev_schedule
                , keep_work_time_type
                , keep_qty_type
                , sales_model_id
                , attribute_set_id
                , demand_id
                , descr
                , is_noh_consume
                )
                SELECT    @p_master_id AS master_id
                        , @p_engine_plan_id AS plan_id              
                        , 'DO::SEMI::' + CONVERT(NVARCHAR(10), 100000 + ROW_NUMBER() OVER (ORDER BY item_id)) AS work_order_id  -- 임의의 중복되지 않는값을 사용하기 위해서 row_number() 처리 함              
                        , 1 AS work_order_seq
                        , a.to_site + '~***' AS site_id
                        , a.item_id + '::' + a.bod_id + '::x::x' AS route_id
                        , a.item_id + '::' + a.bod_id + '::x::x' AS operation_id
                        , a.item_id
                        , a.item_id + '::' + a.bod_id + '::x::x' AS resource_id
                        , NULL AS sub_resource_id             
                        , CONVERT(DATETIME, a.yyyymmdd) AS start_dttm
                        , DATEADD(d, be.bod_lead_time, CONVERT(DATETIME,a.yyyymmdd)) AS end_dttm             
                        , a.qty AS operation_qty
                        , a.qty AS complete_qty             
                        , 'DO::SEMI::' + CONVERT(NVARCHAR(10), 100000 + ROW_NUMBER() OVER (ORDER BY item_id)) AS lot_id
                        , 'N' AS is_fixed
                        , 'Y' AS is_prev_schedule
                        , 'START_FIX' AS keep_work_time_type
                        , 'ALL_QTY_FIX' AS keep_qty_type
                        , NULL AS sales_model_id
                        , NULL AS attribute_set_id
                        , NULL AS demand_id
                        , 'DO::SEMI' AS descr
                        , 'Y' AS is_noh_consume
                FROM   ( SELECT * 
                            FROM   scp_anl_shipment_plan_semi WITH (NOLOCK)  
                            WHERE  division_id         = @p_division_id             -- 'EE'
                            AND    plan_start_yyyymmdd = @v_pre_plan_start_yyyymmdd
                            AND    plan_type           = @v_pre_plan_type 
                            AND    seq                 = @n_pre_plan_seq 
                            AND    measure             = 'SHIP_PLAN_AMEND'
                            AND    qty                 > 0
                        ) a               
                        INNER HASH JOIN (  SELECT ship_frozen, scm_site_id 
                                    FROM   scm_mst_site_eng WITH (NOLOCK)
                                    WHERE  modeling_id = @p_modeling_id
                                    AND    plan_id     = @p_plan_id
                                    AND    plan_type   = @p_plan_type
                                    AND    plan_seq    = @p_seq
                                    AND    division_id = @p_division_id
                                    AND    eng_scm_site_id = scm_site_id + '~***'    --scp_anl_shipment_plan_semi 는 BOD가  from site (plant site) ->  to site (plant site)
                                    )  mse
                        ON a.from_site = mse.scm_site_id
                        INNER JOIN ( SELECT dbo.FN_SCM_SPLIT(bod_id, 1, '::')  AS bod_id
                                            , CONVERT(NUMERIC(18,3),attribute10) AS bod_lead_time
                                    FROM   scm_mst_bod_eng WITH (NOLOCK)
                                    WHERE  modeling_id = @p_modeling_id
                                    AND    plan_id     = @p_plan_id
                                    AND    plan_type   = @p_plan_type
                                    AND    plan_seq    = @p_seq
                                    AND    division_id = @p_division_id 
                                    AND    attribute1  = 'OUTER_SITE'  -- 20181207 추가 PROC_BOD의 fixed_term컬럼값이 외부site일때만(내부site일때는 fixed_term=0) 존재하므로 조건추가함 :이부분수정시 PROC_BOD의 fixed_term 부분검토필요함
                                    ) be
                        ON   a.bod_id = be.bod_id
                WHERE  a.yyyymmdd >= @p_plan_name --@v_cur_monday
                AND    a.yyyymmdd <  CONVERT(NVARCHAR(8), DATEADD(d, ISNULL(mse.ship_frozen, 0), @d_plan_name), 112)  -- SE, FN ship_frozen : 364 ( 참고 : PR_SCP_ENG_EE_FN_SET_SITE_ENG의 ship_frozen 컬럼 생성부분)
                ;

                -----------------------------------------------------------
                --2. FG 출하계획 정보 Insert  (Ship Frozen 구간 내)
                --   - FG 출하계획 정보(scp_anl_shipment_plan_fg)에서 이전 plan_type 정보 사용
                -----------------------------------------------------------
                INSERT INTO /* PR_SCP_ENG_EE_FN_PROC_FIXED_PLAN */ th_eng_fixed_plan_sn
                ( master_id
                , plan_id
                , work_order_id
                , work_order_seq
                , site_id
                , route_id
                , operation_id
                , item_id
                , resource_id
                , sub_resource_id
                , start_dttm
                , end_dttm
                , operation_qty
                , complete_qty
                , lot_id
                , is_fixed
                , is_prev_schedule
                , keep_work_time_type
                , keep_qty_type
                , sales_model_id
                , attribute_set_id
                , demand_id
                , descr
                , is_noh_consume
                )
                SELECT @p_master_id AS master_id
                     , @p_engine_plan_id AS plan_id              
                     , 'DO::FG::' + CONVERT(NVARCHAR(10), 200000 + ROW_NUMBER() OVER (ORDER BY item_id)) AS work_order_id  -- 임의의 중복되지 않는값을 사용하기 위해서 row_number() 처리 함              
                     , 1 AS work_order_seq
                     , a.to_site + '~' + a.incoterms AS site_id
                     , a.item_id + '::' + a.bod_id + '::x::x' AS route_id
                     , a.item_id + '::' + a.bod_id + '::x::x' AS operation_id
                     , a.item_id
                     , a.item_id + '::' + a.bod_id + '::x::x' AS resource_id
                     , NULL AS sub_resource_id             
                     , CONVERT(DATETIME,a.yyyymmdd) AS start_dttm
                     , DATEADD(d, be.bod_lead_time, CONVERT(DATETIME,a.yyyymmdd)) AS end_dttm             
                     , a.qty AS operation_qty
                     , a.qty AS complete_qty             
            
                     , 'DO::FG::' + CONVERT(NVARCHAR(10), 200000 + ROW_NUMBER() OVER (ORDER BY item_id)) AS lot_id
                     , 'N' AS is_fixed
                     , 'Y' AS is_prev_schedule
                     , 'START_FIX' AS keep_work_time_type
                     , 'ALL_QTY_FIX' AS keep_qty_type
                     , NULL AS sales_model_id
                     , NULL AS attribute_set_id
                     , NULL AS demand_id
                     , 'DO::FG' AS descr
                     , 'Y' AS is_noh_consume
                FROM   ( SELECT * 
                         FROM   scp_anl_shipment_plan_fg WITH (NOLOCK)
                         WHERE  division_id         = @p_division_id              -- 'EE'
                         AND    plan_start_yyyymmdd = @v_pre_plan_start_yyyymmdd
                         AND    plan_type           = @v_pre_plan_type
                         AND    seq                 = @n_pre_plan_seq
                         AND    measure             = 'SHIP_PLAN_AMEND'
                         AND    qty                 > 0
                       ) a               
                      INNER HASH JOIN (  SELECT ship_frozen, scm_site_id 
                                    FROM   scm_mst_site_eng WITH (NOLOCK)
                                    WHERE  modeling_id = @p_modeling_id
                                    AND    plan_id     = @p_plan_id
                                    AND    plan_type   = @p_plan_type
                                    AND    plan_seq    = @p_seq
                                    AND    division_id = @p_division_id                                            
                                    AND    eng_scm_site_id = scm_site_id + '~***' 
                                 )  mse
                       ON a.from_site = mse.scm_site_id  --scp_anl_shipment_plan_fg 는 BOD가  from site (plant site) ->  to site (sales site)
                       INNER JOIN ( SELECT dbo.FN_SCM_SPLIT(bod_id, 1, '::')  AS bod_id
                                         , CONVERT(NUMERIC(18,3),attribute10) AS bod_lead_time
                                    FROM   scm_mst_bod_eng WITH (NOLOCK)
                                    WHERE  modeling_id = @p_modeling_id
                                    AND    plan_id     = @p_plan_id
                                    AND    plan_type   = @p_plan_type
                                    AND    plan_seq    = @p_seq
                                    AND    division_id = @p_division_id
                                     -- AND    attribute1  = 'INNER_SITE'  -- 공장내부 일때 : FG는 전부 외부임                         
                                  ) be

                       ON   a.bod_id = be.bod_id
			   
                WHERE  a.yyyymmdd >= @p_plan_name --@v_cur_monday
                AND    a.yyyymmdd <  CONVERT(NVARCHAR(8), DATEADD(d, ISNULL(mse.ship_frozen, 0), @d_plan_name), 112)  -- SE, FN ship_frozen : 364 ( 참고 : PR_SCP_ENG_EE_FN_SET_SITE_ENG의 ship_frozen 컬럼 생성부분)
                ;

                -----------------------------------------------------------
                --3. (FIX) SSP, SCP 출하계획 확정정보 (Ship Frozen 구간 외) INSERT -- 2018.06.06 추가                
                /*
		            1. (20190624) SCP 출하계획 확정정보만 사용 : 확정구간(ship_frozen) 이후는 SSP 출하계획 확정정보 사용 안 함

                    OLD : Start)
                    -1. SCP qty >= SSP qty 이면 scp qty , scp fix_id
                    -2. SCP qty <  SSP qty 이면 
                                        1) scp qty 유지, scp fix_id
                                        2) ssp qty - scp qty : 신규 Fixed Plan으로 Insert, ssp confirm_id      
                    OLD : End)              
                       
                    - (20181220 수정 키중복방지)      ssp_anl_ship_confirm 테이블에 동일정보에 여러건의 데이터가 존재하므로 SUM(수량) 처리함 ( Confirm_id는 'C' + 임의의값("ROW_NUMBER(ORDER BY ssp.item_id)") 형식으로 생성함)
                    - (20190104 수정 조인조건 컬럼값) site_type = 'PLANT'일때 1) project_code = '-', 2) incoterms = '-' 처리함  ( site_type='PLANT'일때 SCP(scp_anl_shipment_plan_fix), SSP(ssp_anl_ship_confirm) 같은정보인데 project_code, incoterms 값이 존재하는건도 있고 없는건도 존재해서 조인처리시 서로다른건으로 인식되므로 '-'로 셋팅함)

                    - 참고 테이블) 1) scp_anl_shipment_plan_fix : SCP 출하계획 확정정보
                                    2) ssp_anl_ship_confirm      : SSP 출하계획 확정정보
                */
                -----------------------------------------------------------
                INSERT INTO /* PR_SCP_ENG_EE_FN_PROC_FIXED_PLAN */ th_eng_fixed_plan_sn
                ( master_id
                , plan_id
                , work_order_id
                , work_order_seq
                , site_id
                , route_id
                , operation_id
                , item_id
                , resource_id
                , sub_resource_id
                , start_dttm
                , end_dttm
                , operation_qty
                , complete_qty
                , lot_id
                , is_fixed
                , is_prev_schedule
                , keep_work_time_type
                , keep_qty_type
                , sales_model_id
                , attribute_set_id
                , demand_id
                , descr
                , is_noh_consume
                )
                SELECT DISTINCT --20181220 distinct 추가 (ssp_anl_ship_confirm 아래조인시 중복건 존재 -> division_id= '81', confirm_id : C20181217342707, C20181217342708, C20181217342709)
                       @p_master_id AS master_id
                     , @p_engine_plan_id AS plan_id             
                     , a.id AS work_order_id             
                     , 1 AS work_order_seq
                     , be.eng_to_site   AS site_id --(변경전 : , a.to_site_id  AS site_id)
                     , a.item_id + '::' + a.bod_id + '::x::x' AS route_id
                     , a.item_id + '::' + a.bod_id + '::x::x' AS operation_id
                     , a.item_id
                     , a.item_id + '::' + a.bod_id + '::x::x' AS resource_id
                     , NULL AS sub_resource_id             
                     , CONVERT(DATETIME, a.yyyymmdd) AS start_dttm
                     , DATEADD(d, be.bod_lead_time, CONVERT(DATETIME,a.yyyymmdd)) AS end_dttm             
                     , a.qty AS operation_qty
                     , a.qty AS complete_qty             
                     , a.id AS lot_id
                     , 'N' AS is_fixed
                     , 'Y' AS is_prev_schedule
                     , 'START_FIX' AS keep_work_time_type
                     , 'ALL_QTY_FIX' AS keep_qty_type
                     , NULL AS sales_model_id
                     , NULL AS attribute_set_id
                     , NULL AS demand_id
                     , 'DO::CFM' AS descr
                     , 'Y' AS is_noh_consume
				-- Start : (20190624) SCP 출하계획 확정정보만 사용 : 확정구간(ship_frozen) 이후는 SSP 출하계획 확정정보 사용 안 함
                FROM   (   SELECT 
                                  scp.fix_id     AS id 
                                , scp.item_id    AS item_id
                                , scp.bod_id     AS bod_id
                                , scp.yyyymmdd   AS yyyymmdd
                                , scp.from_site  AS from_site
                                , scp.qty        AS qty    
                            FROM 
                              ( SELECT   f.division_id, f.yyyymmdd, f.biz_type, f.item_id 
							           , f.from_site, f.to_site
						               , CASE WHEN mse.site_type = 'PLANT' THEN '-'
							                  ELSE f.project_code
							             END project_code
						               , CASE WHEN mse.site_type = 'PLANT' THEN '-'
							                  ELSE f.incoterms
							             END incoterms
                                       , f.bod_id, f.fix_id, f.qty
                                FROM   scp_anl_shipment_plan_fix f WITH (NOLOCK)
                                       INNER JOIN (  SELECT DISTINCT division_id, scm_site_id, site_type
                                                     FROM   scm_mst_site_eng WITH (NOLOCK)
                                                     WHERE  modeling_id = @p_modeling_id --'201'
                                                     AND    plan_id     = @p_plan_id     --'105904'
                                                     AND    plan_type   = @p_plan_type   --'SP'
                                                     AND    plan_seq    = @p_seq         --'1'
                                                     AND    division_id = @p_division_id --'81'
                                                  )  mse
                                       ON  f.division_id = mse.division_id
			                           AND f.to_site     = mse.scm_site_id
                                WHERE f.division_id   = @p_division_id -- '81'  
                                  AND f.qty           >  0
                                  AND f.yyyymmdd      >= @p_plan_name  --'20190103'
								  /* TM버전은 FIX 데이터 미생성, 2021/05/26, By KKC */
								  AND 1= CASE WHEN @p_plan_type = 'TM' THEN 0
											  ELSE 1
										 END
                                ) scp 
                      ) a  
	 			   -- End : (20190624) SCP 출하계획 확정정보만 사용 : 확정구간(ship_frozen) 이후는 SSP 출하계획 확정정보 사용 안 함 
                      INNER JOIN (  SELECT ship_frozen, scm_site_id 
                                    FROM   scm_mst_site_eng WITH (NOLOCK)
                                    WHERE  modeling_id = @p_modeling_id
                                    AND    plan_id     = @p_plan_id
                                    AND    plan_type   = @p_plan_type
                                    AND    plan_seq    = @p_seq
                                    AND    division_id = @p_division_id
                                    AND    eng_scm_site_id = scm_site_id + '~***'    --scp_anl_shipment_plan_semi 는 BOD가  from site (plant site) ->  to site (plant site)
                                 )  mse
                       ON a.from_site = mse.scm_site_id
                       --20190122 수정 (속도개선)INNER JOIN을 LEFT JOIN으로 수정
                       LEFT JOIN ( SELECT dbo.FN_SCM_SPLIT(bod_id, 1, '::')  AS bod_id  --20190122 수정(변경전 : INNER JOIN ( SELECT dbo.FN_SCM_SPLIT(bod_id, 1, '::')  AS bod_id )                                                                                                         
                                         , CONVERT(NUMERIC(18,3),attribute10) AS bod_lead_time
                                         , eng_to_site
                                    FROM   scm_mst_bod_eng WITH (NOLOCK)
                                    WHERE  plan_id     = @p_plan_id
                                    AND    plan_type   = @p_plan_type
                                    AND    plan_seq    = @p_seq
                                    AND    division_id = @p_division_id        
                                    --AND    attribute1  = 'OUTER_SITE'  -- 공장외부 일때  
                                  ) be
                       ON   a.bod_id = be.bod_id
                WHERE  a.yyyymmdd >=  CONVERT(NVARCHAR(8), DATEADD(d, ISNULL(mse.ship_frozen, 0), @d_plan_name), 112) --확정구간 이후
                AND    a.yyyymmdd <= @v_pet_date
                AND    be.bod_id IS NOT NULL --20190122 추가 (속도개선)INNER JOIN을 LEFT JOIN으로 수정하면서 INNER JOIN과 같은결과를 얻기위해서 추가함
                ;
        END

        --2024.08.12 ORG ~
        --20181219수정 'MA', 'TM' 추가  (PR 수정안됨-> PR수정가능으로 변경되면서 "MA, TM"처리도 "SE, FN"과 동일하게 수정함으로 주석처리함) 
        /*
        IF @p_plan_type IN ('MA', 'TM', 'SE', 'FN') --20181219수정 (변경전 : ELSE IF @p_plan_type IN ('SE', 'FN') )
        BEGIN
                -----------------------------------------------------------
                --1. SEMI 출하계획 정보 Insert (Ship Frozen 구간 내)
                --   - SEMI 출하계획 정보(scp_anl_shipment_plan_semi)에서 이전 plan_type 정보 사용
                -----------------------------------------------------------
                INSERT INTO /* PR_SCP_ENG_EE_FN_PROC_FIXED_PLAN */ th_eng_fixed_plan_sn
                ( master_id
                , plan_id
                , work_order_id
                , work_order_seq
                , site_id
                , route_id
                , operation_id
                , item_id
                , resource_id
                , sub_resource_id
                , start_dttm
                , end_dttm
                , operation_qty
                , complete_qty
                , lot_id
                , is_fixed
                , is_prev_schedule
                , keep_work_time_type
                , keep_qty_type
                , sales_model_id
                , attribute_set_id
                , demand_id
                , descr
                , is_noh_consume
                )
                SELECT    @p_master_id AS master_id
                        , @p_engine_plan_id AS plan_id 
             
                        , 'DO::SEMI::' + CONVERT(NVARCHAR(10), 100000 + ROW_NUMBER() OVER (ORDER BY item_id)) AS work_order_id  -- 임의의 중복되지 않는값을 사용하기 위해서 row_number() 처리 함 
             
                        , 1 AS work_order_seq
                        , a.to_site + '~***' AS site_id
                        , a.item_id + '::' + a.bod_id + '::x::x' AS route_id
                        , a.item_id + '::' + a.bod_id + '::x::x' AS operation_id
                        , a.item_id
                        , a.item_id + '::' + a.bod_id + '::x::x' AS resource_id
                        , NULL AS sub_resource_id
             
                        , CONVERT(DATETIME, a.yyyymmdd) AS start_dttm
                        , DATEADD(d, be.bod_lead_time, CONVERT(DATETIME,a.yyyymmdd)) AS end_dttm
             
                        , a.qty AS operation_qty
                        , a.qty AS complete_qty
             
                        , 'DO::SEMI::' + CONVERT(NVARCHAR(10), 100000 + ROW_NUMBER() OVER (ORDER BY item_id)) AS lot_id
                        , 'N' AS is_fixed
                        , 'Y' AS is_prev_schedule
                        , 'START_FIX' AS keep_work_time_type
                        , 'ALL_QTY_FIX' AS keep_qty_type
                        , NULL AS sales_model_id
                        , NULL AS attribute_set_id
                        , NULL AS demand_id
                        , 'DO::SEMI' AS descr
                        , 'Y' AS is_noh_consume

                FROM   ( SELECT * 
                            FROM   scp_anl_shipment_plan_semi WITH (NOLOCK)  
                            WHERE  division_id         = @p_division_id             -- 'EE'
                            AND    plan_start_yyyymmdd = @v_pre_plan_start_yyyymmdd
                            AND    plan_type           = @v_pre_plan_type 
                            AND    seq                 = @n_pre_plan_seq 
                            AND    measure             = 'SHIP_PLAN_AMEND'
                            AND    qty                 > 0
                        ) a
               
                        INNER HASH JOIN (  SELECT ship_frozen, scm_site_id 
                                    FROM   scm_mst_site_eng WITH (NOLOCK)
                                    WHERE  modeling_id = @p_modeling_id
                                    AND    plan_id     = @p_plan_id
                                    AND    plan_type   = @p_plan_type
                                    AND    plan_seq    = @p_seq
                                    AND    division_id = @p_division_id
                                    AND    eng_scm_site_id = scm_site_id + '~***'    --scp_anl_shipment_plan_semi 는 BOD가  from site (plant site) ->  to site (plant site)
                                    )  mse
                        ON a.from_site = mse.scm_site_id

                        INNER JOIN ( SELECT dbo.FN_SCM_SPLIT(bod_id, 1, '::')  AS bod_id
                                            , CONVERT(NUMERIC(18,3),attribute10) AS bod_lead_time
                                    FROM   scm_mst_bod_eng WITH (NOLOCK)
                                    WHERE  modeling_id = @p_modeling_id
                                    AND    plan_id     = @p_plan_id
                                    AND    plan_type   = @p_plan_type
                                    AND    plan_seq    = @p_seq
                                    AND    division_id = @p_division_id 
                                    AND    attribute1  = 'OUTER_SITE'  -- 20181207 추가 PROC_BOD의 fixed_term컬럼값이 외부site일때만(내부site일때는 fixed_term=0) 존재하므로 조건추가함 :이부분수정시 PROC_BOD의 fixed_term 부분검토필요함
                                    ) be

                        ON   a.bod_id = be.bod_id

                WHERE  a.yyyymmdd >= @p_plan_name --@v_cur_monday
                AND    a.yyyymmdd <  CONVERT(NVARCHAR(8), DATEADD(d, ISNULL(mse.ship_frozen, 0), @d_plan_name), 112)  -- SE, FN ship_frozen : 364 ( 참고 : PR_SCP_ENG_EE_FN_SET_SITE_ENG의 ship_frozen 컬럼 생성부분)
                ;

                -----------------------------------------------------------
                --2. FG 출하계획 정보 Insert  (Ship Frozen 구간 내)
                --   - FG 출하계획 정보(scp_anl_shipment_plan_fg)에서 이전 plan_type 정보 사용
                -----------------------------------------------------------
                INSERT INTO /* PR_SCP_ENG_EE_FN_PROC_FIXED_PLAN */ th_eng_fixed_plan_sn
                ( master_id
                , plan_id
                , work_order_id
                , work_order_seq
                , site_id
                , route_id
                , operation_id
                , item_id
                , resource_id
                , sub_resource_id
                , start_dttm
                , end_dttm
                , operation_qty
                , complete_qty
                , lot_id
                , is_fixed
                , is_prev_schedule
                , keep_work_time_type
                , keep_qty_type
                , sales_model_id
                , attribute_set_id
                , demand_id
                , descr
                , is_noh_consume
                )
                SELECT @p_master_id AS master_id
                     , @p_engine_plan_id AS plan_id 
             
                     , 'DO::FG::' + CONVERT(NVARCHAR(10), 200000 + ROW_NUMBER() OVER (ORDER BY item_id)) AS work_order_id  -- 임의의 중복되지 않는값을 사용하기 위해서 row_number() 처리 함 
             
                     , 1 AS work_order_seq
                     , a.to_site + '~' + a.incoterms AS site_id
                     , a.item_id + '::' + a.bod_id + '::x::x' AS route_id
                     , a.item_id + '::' + a.bod_id + '::x::x' AS operation_id
                     , a.item_id
                     , a.item_id + '::' + a.bod_id + '::x::x' AS resource_id
                     , NULL AS sub_resource_id
             
                     , CONVERT(DATETIME,a.yyyymmdd) AS start_dttm
                     , DATEADD(d, be.bod_lead_time, CONVERT(DATETIME,a.yyyymmdd)) AS end_dttm
             
                     , a.qty AS operation_qty
                     , a.qty AS complete_qty             
            
                     , 'DO::FG::' + CONVERT(NVARCHAR(10), 200000 + ROW_NUMBER() OVER (ORDER BY item_id)) AS lot_id
                     , 'N' AS is_fixed
                     , 'Y' AS is_prev_schedule
                     , 'START_FIX' AS keep_work_time_type
                     , 'ALL_QTY_FIX' AS keep_qty_type
                     , NULL AS sales_model_id
                     , NULL AS attribute_set_id
                     , NULL AS demand_id
                     , 'DO::FG' AS descr
                     , 'Y' AS is_noh_consume

                FROM   ( SELECT * 
                         FROM   scp_anl_shipment_plan_fg WITH (NOLOCK)
                         WHERE  division_id         = @p_division_id              -- 'EE'
                         AND    plan_start_yyyymmdd = @v_pre_plan_start_yyyymmdd
                         AND    plan_type           = @v_pre_plan_type
                         AND    seq                 = @n_pre_plan_seq
                         AND    measure             = 'SHIP_PLAN_AMEND'
                         AND    qty                 > 0
                       ) a
               
                      INNER HASH JOIN (  SELECT ship_frozen, scm_site_id 
                                    FROM   scm_mst_site_eng WITH (NOLOCK)
                                    WHERE  modeling_id = @p_modeling_id
                                    AND    plan_id     = @p_plan_id
                                    AND    plan_type   = @p_plan_type
                                    AND    plan_seq    = @p_seq
                                    AND    division_id = @p_division_id                                            
                                    AND    eng_scm_site_id = scm_site_id + '~***' 
                                 )  mse
                       ON a.from_site = mse.scm_site_id  --scp_anl_shipment_plan_fg 는 BOD가  from site (plant site) ->  to site (sales site)

                       INNER JOIN ( SELECT dbo.FN_SCM_SPLIT(bod_id, 1, '::')  AS bod_id
                                         , CONVERT(NUMERIC(18,3),attribute10) AS bod_lead_time
                                    FROM   scm_mst_bod_eng WITH (NOLOCK)
                                    WHERE  modeling_id = @p_modeling_id
                                    AND    plan_id     = @p_plan_id
                                    AND    plan_type   = @p_plan_type
                                    AND    plan_seq    = @p_seq
                                    AND    division_id = @p_division_id
                                     -- AND    attribute1  = 'INNER_SITE'  -- 공장내부 일때 : FG는 전부 외부임                         
                                  ) be

                       ON   a.bod_id = be.bod_id
			   
                WHERE  a.yyyymmdd >= @p_plan_name --@v_cur_monday
                AND    a.yyyymmdd <  CONVERT(NVARCHAR(8), DATEADD(d, ISNULL(mse.ship_frozen, 0), @d_plan_name), 112)  -- SE, FN ship_frozen : 364 ( 참고 : PR_SCP_ENG_EE_FN_SET_SITE_ENG의 ship_frozen 컬럼 생성부분)
                ;

                -----------------------------------------------------------
                --3. (FIX) SSP, SCP 출하계획 확정정보 (Ship Frozen 구간 외) INSERT -- 2018.06.06 추가                
                /*
		            1. (20190624) SCP 출하계획 확정정보만 사용 : 확정구간(ship_frozen) 이후는 SSP 출하계획 확정정보 사용 안 함

                    OLD : Start)
                    -1. SCP qty >= SSP qty 이면 scp qty , scp fix_id
                    -2. SCP qty <  SSP qty 이면 
                                        1) scp qty 유지, scp fix_id
                                        2) ssp qty - scp qty : 신규 Fixed Plan으로 Insert, ssp confirm_id      
                    OLD : End)              
                       
                    - (20181220 수정 키중복방지)      ssp_anl_ship_confirm 테이블에 동일정보에 여러건의 데이터가 존재하므로 SUM(수량) 처리함 ( Confirm_id는 'C' + 임의의값("ROW_NUMBER(ORDER BY ssp.item_id)") 형식으로 생성함)
                    - (20190104 수정 조인조건 컬럼값) site_type = 'PLANT'일때 1) project_code = '-', 2) incoterms = '-' 처리함  ( site_type='PLANT'일때 SCP(scp_anl_shipment_plan_fix), SSP(ssp_anl_ship_confirm) 같은정보인데 project_code, incoterms 값이 존재하는건도 있고 없는건도 존재해서 조인처리시 서로다른건으로 인식되므로 '-'로 셋팅함)

                    - 참고 테이블) 1) scp_anl_shipment_plan_fix : SCP 출하계획 확정정보
                                    2) ssp_anl_ship_confirm      : SSP 출하계획 확정정보
                */
                -----------------------------------------------------------
                INSERT INTO /* PR_SCP_ENG_EE_FN_PROC_FIXED_PLAN */ th_eng_fixed_plan_sn
                ( master_id
                , plan_id
                , work_order_id
                , work_order_seq
                , site_id
                , route_id
                , operation_id
                , item_id
                , resource_id
                , sub_resource_id
                , start_dttm
                , end_dttm
                , operation_qty
                , complete_qty
                , lot_id
                , is_fixed
                , is_prev_schedule
                , keep_work_time_type
                , keep_qty_type
                , sales_model_id
                , attribute_set_id
                , demand_id
                , descr
                , is_noh_consume
                )
                SELECT DISTINCT --20181220 distinct 추가 (ssp_anl_ship_confirm 아래조인시 중복건 존재 -> division_id= '81', confirm_id : C20181217342707, C20181217342708, C20181217342709)
                       @p_master_id AS master_id
                     , @p_engine_plan_id AS plan_id 
             
                     , a.id AS work_order_id
             
                     , 1 AS work_order_seq
                     , be.eng_to_site   AS site_id --(변경전 : , a.to_site_id  AS site_id)
                     , a.item_id + '::' + a.bod_id + '::x::x' AS route_id
                     , a.item_id + '::' + a.bod_id + '::x::x' AS operation_id
                     , a.item_id
                     , a.item_id + '::' + a.bod_id + '::x::x' AS resource_id
                     , NULL AS sub_resource_id
             
                     , CONVERT(DATETIME, a.yyyymmdd) AS start_dttm
                     , DATEADD(d, be.bod_lead_time, CONVERT(DATETIME,a.yyyymmdd)) AS end_dttm
             
                     , a.qty AS operation_qty
                     , a.qty AS complete_qty
             
                     , a.id AS lot_id
                     , 'N' AS is_fixed
                     , 'Y' AS is_prev_schedule
                     , 'START_FIX' AS keep_work_time_type
                     , 'ALL_QTY_FIX' AS keep_qty_type
                     , NULL AS sales_model_id
                     , NULL AS attribute_set_id
                     , NULL AS demand_id
                     , 'DO::CFM' AS descr
                     , 'Y' AS is_noh_consume

				-- Start : (20190624) SCP 출하계획 확정정보만 사용 : 확정구간(ship_frozen) 이후는 SSP 출하계획 확정정보 사용 안 함
                FROM   (   SELECT 
                                  scp.fix_id     AS id 
                                , scp.item_id    AS item_id
                                , scp.bod_id     AS bod_id
                                , scp.yyyymmdd   AS yyyymmdd
                                , scp.from_site  AS from_site
                                , scp.qty        AS qty    
                            FROM 
                              ( SELECT   f.division_id, f.yyyymmdd, f.biz_type, f.item_id 
							           , f.from_site, f.to_site
						               , CASE WHEN mse.site_type = 'PLANT' THEN '-'
							                  ELSE f.project_code
							             END project_code
						               , CASE WHEN mse.site_type = 'PLANT' THEN '-'
							                  ELSE f.incoterms
							             END incoterms
                                       , f.bod_id, f.fix_id, f.qty
                                FROM   scp_anl_shipment_plan_fix f WITH (NOLOCK)
                                       INNER JOIN (  SELECT DISTINCT division_id, scm_site_id, site_type
                                                     FROM   scm_mst_site_eng WITH (NOLOCK)
                                                     WHERE  modeling_id = @p_modeling_id --'201'
                                                     AND    plan_id     = @p_plan_id     --'105904'
                                                     AND    plan_type   = @p_plan_type   --'SP'
                                                     AND    plan_seq    = @p_seq         --'1'
                                                     AND    division_id = @p_division_id --'81'
                                                  )  mse
                                       ON  f.division_id = mse.division_id
			                           AND f.to_site     = mse.scm_site_id
                                WHERE f.division_id   = @p_division_id -- '81'  
                                  AND f.qty           >  0
                                  AND f.yyyymmdd      >= @p_plan_name  --'20190103'
								  /* TM버전은 FIX 데이터 미생성, 2021/05/26, By KKC */
								  AND 1= CASE WHEN @p_plan_type = 'TM' THEN 0
											  ELSE 1
										 END
                                ) scp 
                      ) a  
				-- End : (20190624) SCP 출하계획 확정정보만 사용 : 확정구간(ship_frozen) 이후는 SSP 출하계획 확정정보 사용 안 함 
					 
			    -- 주석 Start : (20190624) SCP 출하계획 확정정보만 사용 : 확정구간(ship_frozen) 이후는 SSP 출하계획 확정정보 사용 안 함
				/*
                FROM   (   SELECT 
                                 /*
                                    1. SCP qty >= SSP qty 이면 scp qty , scp fix_id
                                    2. SCP qty <  SSP qty 이면 
                                                   1) scp qty 유지, scp fix_id
                                                   2) ssp qty - scp qty : 신규 Fixed Plan으로 Insert, ssp confirm_id   
                                 */
                                  CASE WHEN ISNULL(scp.qty, 0) >= ISNULL(ssp.qty, 0) THEN scp.fix_id
                                       WHEN ISNULL(scp.qty, 0) <  ISNULL(ssp.qty, 0) AND gubun = 1 THEN scp.fix_id
                                       -- 20181220 동일 정보에 여러 SO No로 존재하여 SUM 처리     
                                       WHEN ISNULL(scp.qty, 0) <  ISNULL(ssp.qty, 0) AND gubun = 2 THEN 'C' + CONVERT(NVARCHAR(10), 400000 + ROW_NUMBER() OVER (ORDER BY ssp.item_id))
                                       --WHEN ISNULL(scp.qty, 0) <  ISNULL(ssp.qty, 0) AND gubun = 2 THEN ssp.confirm_id
                                  END AS id 
                                , ISNULL(scp.item_id, ssp.item_id) AS item_id
                                , ISNULL(scp.bod_id, ssp.bod_id)   AS bod_id
                                , ISNULL(scp.yyyymmdd, ssp.yyyymmdd) AS yyyymmdd
                                , ISNULL(scp.from_site, ssp.from_site) AS from_site

                                , CASE WHEN ISNULL(scp.qty, 0) >= ISNULL(ssp.qty, 0) THEN scp.qty
                                       WHEN ISNULL(scp.qty, 0) <  ISNULL(ssp.qty, 0) AND gubun = 1 THEN scp.qty
                                       WHEN ISNULL(scp.qty, 0) <  ISNULL(ssp.qty, 0) AND gubun = 2 THEN ISNULL(ssp.qty, 0) - ISNULL(scp.qty, 0)
                                  END AS qty                        
                           
                           /* 20190104 수정 
                              -- scp_anl_shipment_plan_fix테이블은 to site가 PLANT 일때 project_code, incoterms컬럼모두 NULL 인데
                                 ssp_anl_ship_confirm 테이블은     to site가 PLANT 일때도 project_code, incoterms컬럼 둘다 값을 가지고 있어서 
                                 조인이 안되므로 to site가  PLANT 일때 두테이블의 project_code, incoterms 컬럼의 값을 '-'로 셋팅함

                           FROM 
                               ( SELECT * 
                                 FROM   scp_anl_shipment_plan_fix WITH (NOLOCK)
                                 WHERE  division_id         =  @p_division_id   -- 'EE'
                                 AND    qty                 >  0
                                 AND    yyyymmdd            >= @p_plan_name
                         
                               ) scp                 
                               -- 20181220 동일 정보에 여러 SO No로 존재하여 SUM 처리                                         
                               FULL OUTER JOIN 
                                        ( SELECT division_id, yyyymmdd, biz_type, item_id, project_code, to_site, incoterms, from_site, bod_id
                                               , SUM(ISNULL(qty, 0)) AS qty  
                                          FROM   ssp_anl_ship_confirm WITH (NOLOCK)
                                          WHERE  division_id         =  @p_division_id  
                                          AND    qty                 >  0
                                          AND    yyyymmdd            >= @p_plan_name  
                                          AND    change_type         = 'C'  --  20180716 추가          
                                          GROUP BY division_id, yyyymmdd, biz_type, item_id, project_code, to_site, incoterms, from_site, bod_id
                                        ) ssp     

                               --FULL OUTER JOIN 
                               --         ( SELECT * 
                               --             FROM   ssp_anl_ship_confirm WITH (NOLOCK)
                               --             WHERE  division_id         =  @p_division_id  -- 'EE'
                               --             AND    qty                 >  0
                               --             AND    yyyymmdd            >= @p_plan_name
                               --             AND    change_type         = 'C'  --  20180711 추가                                    
                               --         ) ssp
                               ON   scp.division_id = ssp.division_id 
                               AND  scp.yyyymmdd    = ssp.yyyymmdd
                               AND  scp.biz_type    = ssp.biz_type 
                               AND  scp.item_id     = ssp.item_id
                               AND  scp.project_code = ssp.project_code
                               AND  scp.to_site      = ssp.to_site
                               AND  scp.incoterms    = ssp.incoterms 
                               AND  scp.from_site    = ssp.from_site
                               AND  scp.bod_id       = ssp.bod_id 
                            */
                            FROM 
                              ( SELECT   f.division_id, f.yyyymmdd, f.biz_type, f.item_id 
							           , f.from_site, f.to_site
						               , CASE WHEN mse.site_type = 'PLANT' THEN '-'
							                  ELSE f.project_code
							             END project_code
						               , CASE WHEN mse.site_type = 'PLANT' THEN '-'
							                  ELSE f.incoterms
							             END incoterms
                                       , f.bod_id, f.fix_id, f.qty
                                FROM   scp_anl_shipment_plan_fix f WITH (NOLOCK)
                                       INNER JOIN (  SELECT DISTINCT division_id, scm_site_id, site_type
                                                     FROM   scm_mst_site_eng WITH (NOLOCK)
                                                     WHERE  modeling_id = @p_modeling_id --'201'
                                                     AND    plan_id     = @p_plan_id     --'105904'
                                                     AND    plan_type   = @p_plan_type   --'SP'
                                                     AND    plan_seq    = @p_seq         --'1'
                                                     AND    division_id = @p_division_id --'81'
                                                  )  mse
                                       ON  f.division_id = mse.division_id
			                           AND f.to_site     = mse.scm_site_id

                                WHERE  f.division_id   = @p_division_id -- '81'  
                                AND    f.qty           >  0
                                AND    f.yyyymmdd      >= @p_plan_name  --'20190103'
                                ) scp              
                                FULL OUTER JOIN 
                                        ( SELECT  c.division_id, c.yyyymmdd, c.biz_type, c.item_id 
							                    , c.from_site, c.to_site
						                        , CASE WHEN mse.site_type = 'PLANT' THEN '-'
							                           ELSE c.project_code
							                      END project_code
						                        , CASE WHEN mse.site_type = 'PLANT' THEN '-'
							                           ELSE c.incoterms
							                      END incoterms
                                                , c.bod_id
                                                --, c.confirm_id
                                                , SUM(ISNULL(c.qty, 0)) AS qty 
                                          FROM   ssp_anl_ship_confirm c WITH (NOLOCK)
                                                 INNER JOIN (  SELECT DISTINCT division_id, scm_site_id, site_type
                                                               FROM   scm_mst_site_eng WITH (NOLOCK)
                                                               WHERE  modeling_id = @p_modeling_id --'201'
                                                               AND    plan_id     = @p_plan_id     --'105904'
                                                               AND    plan_type   = @p_plan_type   --'SP'
                                                               AND    plan_seq    = @p_seq         --'1'
                                                               AND    division_id = @p_division_id --'81'
                                                            )  mse
                                                 ON  c.division_id = mse.division_id
			                                     AND c.to_site     = mse.scm_site_id
                                  
                                          WHERE  c.division_id         =  @p_division_id  
                                          AND    c.qty                 >  0
                                          AND    c.yyyymmdd            >= @p_plan_name                                     
                                          AND    c.change_type         = 'C'  --  20180716 추가
                                          GROUP BY c.division_id, c.yyyymmdd, c.biz_type, c.item_id
                                                 , c.to_site, c.from_site, c.bod_id 
                                                 , CASE WHEN mse.site_type = 'PLANT' THEN '-'
							                            ELSE c.project_code
							                       END 
						                        ,  CASE WHEN mse.site_type = 'PLANT' THEN '-'
							                            ELSE c.incoterms
							                       END 
                                        ) ssp
                                ON   scp.division_id = ssp.division_id 
                                AND  scp.yyyymmdd    = ssp.yyyymmdd
                                AND  scp.biz_type    = ssp.biz_type 
                                AND  scp.item_id     = ssp.item_id
                                AND  scp.project_code = ssp.project_code
                                AND  scp.to_site      = ssp.to_site
                                AND  scp.incoterms    = ssp.incoterms 
                                AND  scp.from_site    = ssp.from_site
                                AND  scp.bod_id       = ssp.bod_id

                             , (SELECT 1 gubun  UNION ALL SELECT 2 gubun) cc
                   
                           -- 1. SCP qty >= SSP qty 이면 scp qty , scp fix_id
                           -- 2. SCP qty <  SSP qty 이면 
                           --                1) scp qty 유지, scp fix_id
                           --                2) ssp qty - scp qty : 신규 Fixed Plan으로 Insert, ssp confirm_id 
                           WHERE cc.gubun  
                                        = ( CASE WHEN ISNULL(scp.qty, 0) >= ISNULL(ssp.qty, 0) THEN 1
                                                 WHEN ISNULL(scp.qty, 0) <  ISNULL(ssp.qty, 0) THEN cc.gubun
                                            END )
                           AND   ( ( cc.gubun = 1 AND  scp.qty  IS NOT NULL )
                                   OR
                                   cc.gubun = 2 ) 
                      ) a
					*/
			    -- 주석 End : (20190624) SCP 출하계획 확정정보만 사용 : 확정구간(ship_frozen) 이후는 SSP 출하계획 확정정보 사용 안 함

                      INNER JOIN (  SELECT ship_frozen, scm_site_id 
                                    FROM   scm_mst_site_eng WITH (NOLOCK)
                                    WHERE  modeling_id = @p_modeling_id
                                    AND    plan_id     = @p_plan_id
                                    AND    plan_type   = @p_plan_type
                                    AND    plan_seq    = @p_seq
                                    AND    division_id = @p_division_id
                                    AND    eng_scm_site_id = scm_site_id + '~***'    --scp_anl_shipment_plan_semi 는 BOD가  from site (plant site) ->  to site (plant site)
                                 )  mse
                       ON a.from_site = mse.scm_site_id

                       --20190122 수정 (속도개선)INNER JOIN을 LEFT JOIN으로 수정
                       LEFT JOIN ( SELECT dbo.FN_SCM_SPLIT(bod_id, 1, '::')  AS bod_id  --20190122 수정(변경전 : INNER JOIN ( SELECT dbo.FN_SCM_SPLIT(bod_id, 1, '::')  AS bod_id )                                                                                                         
                                         , CONVERT(NUMERIC(18,3),attribute10) AS bod_lead_time
                                         , eng_to_site
                                    FROM   scm_mst_bod_eng WITH (NOLOCK)
                                    WHERE  plan_id     = @p_plan_id
                                    AND    plan_type   = @p_plan_type
                                    AND    plan_seq    = @p_seq
                                    AND    division_id = @p_division_id        
                                    --AND    attribute1  = 'OUTER_SITE'  -- 공장외부 일때  
                                  ) be

                       ON   a.bod_id = be.bod_id

                WHERE  a.yyyymmdd >=  CONVERT(NVARCHAR(8), DATEADD(d, ISNULL(mse.ship_frozen, 0), @d_plan_name), 112) --확정구간 이후
                AND    a.yyyymmdd <= @v_pet_date
                AND    be.bod_id IS NOT NULL --20190122 추가 (속도개선)INNER JOIN을 LEFT JOIN으로 수정하면서 INNER JOIN과 같은결과를 얻기위해서 추가함
                ;

        END    -- IF @p_plan_type IN ('MA', 'TM', 'SE', 'FN')
        */

        /* 임시 테이블 정리, 2024.10.07 */
        IF OBJECT_ID('tempdb..#scm_dnm_ssp_plan_v_temp') IS NOT NULL
        BEGIN 
            DROP TABLE  #scm_dnm_ssp_plan_v_temp;   
        END 
        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
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


