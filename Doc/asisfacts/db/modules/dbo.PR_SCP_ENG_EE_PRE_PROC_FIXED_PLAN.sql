
/*
 * Program ID   : PR_SCP_ENG_EE_PRE_PROC_FIXED_PLAN
 * Description  :
                  -----------------------------------------------------------
                  --1-1) (FIX) SSP대상 출하계획 확정정보 Insert (ship_frozen 기간내)
                  -----------------------------------------------------------
                      - SSP 출하계획 확정정보(ssp_anl_ship_confirm) 중 ship_frozen기간내의 데이터만 INSERT
                      
                      - 참고 테이블) ssp_anl_ship_confirm : SSP 출하계획 확정정보
                  
                  -----------------------------------------------------------
                  --1-2) (FIX) SSP, SCP 출하계획 확정정보 Insert (ship_frozen 기간이후)
                  -----------------------------------------------------------
				     20190624) SCP 출하계획 확정정보만 사용 : 확정구간(ship_frozen) 이후는 SSP 출하계획 확정정보 사용 안 함
					              scp qty, scp fix_id

				     OLD : Start)
                      1. SSP qty <= SCP qty 이면 scp qty , scp fix_id
                      2. SSP qty >  SCP qty 이면 
                                  1) scp qty 유지, scp fix_id
                                  2) ssp qty - scp qty : 신규 Fixed Plan으로 Insert, ssp confirm_id
				     OLD : End)                
                  
                     - (20181220 수정 키중복방지)      ssp_anl_ship_confirm 테이블에 동일정보에 여러건의 데이터가 존재하므로 SUM(수량) 처리함 ( Confirm_id는 'C' + 임의의값("ROW_NUMBER(ORDER BY ssp.item_id)") 형식으로 생성함)
                     - (20190104 수정 조인조건 컬럼값) site_type = 'PLANT'일때 1) project_code = '-', 2) incoterms = '-' 처리함  ( site_type='PLANT'일때 SCP(scp_anl_shipment_plan_fix), SSP(ssp_anl_ship_confirm) 같은정보인데 project_code, incoterms 값이 존재하는건도 있고 없는건도 존재해서 조인처리시 서로다른건으로 인식되므로 '-'로 셋팅함)
                       
                  
                     - 참고 테이블1) scp_anl_shipment_plan_fix : SCP 출하계획 확정정보
                     - 참고 테이블2) ssp_anl_ship_confirm      : SSP 출하계획 확정정보

                  --(주석시작)20181207
                  -----------------------------------------------------------
                  --2. SSP비대상 확정 출하 계획 정보 Insert (ship_frozen 기간내)
                  -----------------------------------------------------------
                      - scp_anl_shipment_plan_semi 테이블의 최종생성(전주 최종생성된 데이터)된 plan_id의 seq
                        데이터중 BOD가 공장내부이면서, yyyymmdd >= @p_plan_name AND yyyymmdd < DATEADD(d, ship_frozen, @d_plan_name) 인 데이터만 INSERT                      

                      - SSP 대상이 아닌 경우 : [To Site가 Plant이고, From/To 가 같은 국가이면서, To Site 가 OSP_YN = 'Y' 가 아닌 경우]
                      - 공장내부 : BOD 의 from site와 to site가  같은 site_id (또는 같은company_id)이고 to_site 가 sales site 아닐때
                                   (참조 컬럼 : scm_mst_bod_eng.attribute1 ( 공장내부 : 'INNER_SITE', 'INNER_SITE_001', 'INNER_SITE_002', 공장외부 : 'OUTER_SITE')
                  --(주석종료)20181207
                                        
 * OutTable     :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017.12.01   정원식         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.05.28   KSW            선적 FIX plan 처리부분 추가 (1-2) 참고)
 * 2018.06.26   KSG            특성 계획 3주 반영 : 수정 시 Proc BOD도 동시 반영 필요
 * 2018.07.11   KSW            ssp_anl_ship_confirm 테이블 사용시 change_type = 'C' 조건추가
 * 2018.12.07   KSW            "SSP비대상 확정 출하 계획 정보 Insert" 처리부분 주석처리함 : 이부분 수정시 PROC_BOD의 fixed_term 컬럼 처리부분도 수정검토필요함 (참고)주석2 
 * 2018.12.19   KSW            @v_pre_plan_start_yyyymmdd, @v_pre_plan_id 변수값 수정(전주에 배치 미실행했을경우 때문에  전주 -> confirm_flag='Y'인 이전데이터중 가장최근이전주로 변경)
 * 2018.12.20   KSW            키중복오류관련 수정 (DISTINCT처리함) (참고)주석1-2
 * 2019.01.04   KSW            (FIX) 확정 출하 계획 정보 Insert 부분수정 (참고)주석1-2  (  scp_anl_shipment_plan_fix테이블은 to site가 PLANT 일때 project_code, incoterms컬럼모두 NULL 인데  ssp_anl_ship_confirm 테이블은     to site가 PLANT 일때도 project_code, incoterms컬럼 둘다 값을 가지고 있어서  조인이 안되므로 to site가  PLANT 일때 두테이블의 project_code, incoterms 컬럼의 값을 '-'로 셋팅함 )
 * 2019.01.22   KSW            (속도개선) (FIX) 확정 출하 계획 정보 Insert처리부분 조인방법변경 (참고)주석1-2
 * 2019.06.24   KSG            [C20190621_23161] 확정구간(ship_frozen) 이후는 SSP 출하계획 확정정보 사용 안 함
 * 2021.05.10   SEO            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 : SSP출하확정계획의 END_TIME을 SSP에 있는 정보 그대로 사용
 * 2021.05.26   KKC            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 : TE계획 일 경우 FP구간 이후 FIX 데이터 미생성
 * 2021.09.03   KKC            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 : TE계획 일 경우 전구간 확정계획 적용 여부 옵션화
 * 2021.10.14   KSG            PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 : AS
 * 2024.10.07   KKC            PJ20249346  LGES SCP 개선과제 이행 : 자동차 해외법인 통합FP 52주 Daily 생산/출하계획 동기화 및 튜닝
                               1. 52주fp통합 관련 전극은 출하계획 기존로직 유지(변경x)
                               3. ssp 동기화 테이블 변경 (ssp_anl_ship_confirm -> scm_dnm_ssp_plan_v)
 */

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_EE_PRE_PROC_FIXED_PLAN]
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_EE_PRE_PROC_FIXED_PLAN';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'TH_ENG_FIXED_PLAN';
    DECLARE @d_event_date   DATETIME;

    DECLARE @v_cur_monday   NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    DECLARE @d_plan_name    DATETIME = CONVERT(DATETIME,@p_plan_name);
    DECLARE @v_pet_date     NVARCHAR(8) ; -- Plan End Date

    -- 확정계획 대상 plan 정보
    DECLARE @v_pre_plan_start_yyyymmdd NVARCHAR(8);  --plan_name
    DECLARE @v_pre_plan_type           NVARCHAR(50); --plan_type
    DECLARE @n_pre_plan_seq            INTEGER;      --plan_seq
    DECLARE @v_pre_plan_id             NVARCHAR(8); --plan_id

    DECLARE @v_te_frozen_yn  NVARCHAR(1);  --2021.09.03 추가
    DECLARE @v_te_only_fp_yn NVARCHAR(1);  --2021.09.03 추가

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
	    -- PR_SCP_ENG_EE_PRE_PROC_FIXED_PLAN_PROD 에서는 Delete 하지 않음      
        -----------------------------------------------------------         
        DELETE /* PR_SCP_ENG_EE_PRE_PROC_FIXED_PLAN */ 
        FROM   th_eng_fixed_plan_sn
        WHERE  master_id = @p_master_id
        AND    plan_id   = @p_engine_plan_id 
        ;
        -----------------------------------------------------------
        --1) 지난 주 Plan 정보 조회 
        /* 20181219 변경 ( 전주 -> 데이터가존재하는 최근이전주로 변경)
        SELECT @v_pre_plan_start_yyyymmdd = plan_name
             , @v_pre_plan_id             = plan_id                       
        FROM   scm_mst_plan WITH (NOLOCK)
        WHERE  division_id = @p_division_id 
        AND    plan_cycle  = @p_plan_cycle
        AND    plan_name   = CONVERT(CHAR(8), DATEADD(DD, -7, @d_plan_name), 112)
        */
        --20181219 수정 ( 전주에 배치 미실행했을경우 때문에 @v_pre_plan_start_yyyymmdd 전주 -> 데이터가존재하는 최근이전주로 변경 )
        SELECT @v_pre_plan_start_yyyymmdd = pre_plan_start_yyyymmdd
             , @v_pre_plan_id             = pre_plan_id
        FROM ( 
                SELECT a.plan_name AS pre_plan_start_yyyymmdd
                     , a.plan_id   AS pre_plan_id
                     , ROW_NUMBER() OVER (ORDER BY a.plan_id DESC) row_num                  
                
                FROM   scm_mst_plan a WITH (NOLOCK)
                       INNER JOIN scm_mst_plan_detail b WITH (NOLOCK)
                       ON  a.division_id  = b.division_id
                       AND a.plan_id      = b.plan_id 
                       AND b.confirm_flag = 'Y'

                WHERE  a.division_id =  @p_division_id 
                AND    a.plan_cycle  =  @p_plan_cycle
                AND    a.plan_name   >= CONVERT(CHAR(8), DATEADD(DD, -7 * 4, @d_plan_name), 112)
                AND    a.plan_name   <  @d_plan_name
            ) x
        WHERE x.row_num = 1
		;

        --2) 지난 주 Confirm된 Plan 정보 조회 
		SELECT @v_pre_plan_type = a.plan_type
             , @n_pre_plan_seq  = a.plan_seq
        FROM   (
                SELECT plan_type, plan_seq
                     , ROW_NUMBER() OVER (ORDER BY CASE WHEN plan_type = 'FN' THEN 1
                                                        WHEN plan_type = 'SE' THEN 2
                                                        WHEN plan_type = 'MA' THEN 3
                                                        WHEN plan_type = 'PR' THEN 4
                                                        ELSE 9 -- 20181115 추가 'TE', 'TM' 때문에 추가함 (주의 ELSE 처리안하면 TE, TM 가장최근에 실행되었으면  TE, TM이 NULL로 처리되어서 첫번째로 조회될수 있음)  ('TE' : 시뮬레이션용 'PR'과 동일하게 처리됨, 'TM': 시뮬레이션용 'MA'동일하게 처리됨) 
                                                   END
                                         ) AS rownumber
                FROM   scm_mst_plan_detail WITH (NOLOCK)
                WHERE  division_id  = @p_division_id
                AND    plan_id      = @v_pre_plan_id
                AND    confirm_flag = 'Y'
               ) a
        WHERE  rownumber = 1
        ;
        -----------------------------------------------------------
        
        /***********************************************************
        현재 미사용 변수 정리, 2024.10.07 
        DECLARE @v_pre_plan_start_yyyymmdd_daily NVARCHAR(8);  --plan_name
        DECLARE @v_pre_plan_type_daily           NVARCHAR(50); --plan_type
        DECLARE @n_pre_plan_seq_daily            INTEGER;      --plan_seq
        DECLARE @v_pre_plan_id_daily             NVARCHAR(8); --plan_id
               	
        -- 1) Daily는 SP Type만 존재함
        SET @v_pre_plan_type_daily = 'SP';
        
        -- 2) 최종 plan_id, plan_seq              
        SELECT @v_pre_plan_id_daily = MAX(plan_id)
        FROM   scm_mst_plan_detail WITH (NOLOCK)
        WHERE  division_id = @p_division_id --'81'
        AND    plan_type   = @v_pre_plan_type_daily
        AND    plan_status = 1
        ;

        SELECT @n_pre_plan_seq_daily = MAX(plan_seq)
        FROM   scm_mst_plan_detail WITH (NOLOCK)
        WHERE  division_id = @p_division_id --'81'
        AND    plan_id     = @v_pre_plan_id_daily
        AND    plan_type   = @v_pre_plan_type_daily
        AND    plan_status = 1
        ;

        -- 3) plan_name
        SELECT @v_pre_plan_start_yyyymmdd_daily = plan_name
        FROM   scm_mst_plan WITH (NOLOCK)
        WHERE  division_id = @p_division_id 
        AND    plan_id     = @v_pre_plan_id_daily
        ;    
        */


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
        
        /*********************************************************************************
		Froze(TE) 여부 체크 및 None Froze 일 경우는 FIXED PLAN 모두 미생성, 2021.09.03 By KKC		
		**********************************************************************************/
		--1. frozen(TE) 여부 Check
		SELECT @v_te_frozen_yn  = ISNULL(a.segment3, 'N') 
		     , @v_te_only_fp_yn = ISNULL(a.segment4, 'N')
		  FROM scm_adm_lookup_master_detail a(nolock)
		 WHERE a.lookup_type = 'SCP_FROZEN_APPLY_YN'
		   AND a.SEGMENT1 = @p_division_id
		   AND a.SEGMENT2 = @p_plan_type
		;

		--2. frozen(TE) 변수 Validation Check
		IF @v_te_frozen_yn IS NULL OR @v_te_frozen_yn != 'N'
			BEGIN
				SET @v_te_frozen_yn = 'Y';
			END

        --3. frozen = N 인 경우는 FIXED PLAN 모두 미생성
		IF @v_te_frozen_yn = 'N'
			BEGIN
			  GOTO SKIP1;
			END

        -----------------------------------------------------------
        --1-1) SSP대상 확정 출하 계획 정보 Insert  (ship_frozen 기간내)   
        --     -  SSP 출하계획 확정정보(ssp_anl_ship_confirm) 중 ship_frozen기간내의 데이터만 INSERT
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_EE_PRE_PROC_FIXED_PLAN */ th_eng_fixed_plan_sn
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
             , a.confirm_id  AS work_order_id             
             , 1 AS work_order_seq
             , be.eng_to_site   AS site_id --(변경전 : , a.to_site_id  AS site_id)
             , a.item_id + '::' + a.bod_id + '::x::x' AS route_id
             , a.item_id + '::' + a.bod_id + '::x::x' AS operation_id
             , a.item_id
             , a.item_id + '::' + a.bod_id + '::x::x' AS resource_id
             , NULL AS sub_resource_id             
             , CONVERT(DATETIME, a.yyyymmdd) AS start_dttm
             --, DATEADD(d, be.bod_lead_time, CONVERT(DATETIME,a.yyyymmdd)) AS end_dttm		
			 , a.eta_date AS end_dttm														--2021.05.10 변경             
             , a.qty AS operation_qty
             , a.qty AS complete_qty             
             , a.confirm_id AS lot_id
             , 'N' AS is_fixed
             , 'Y' AS is_prev_schedule
             , 'START_FIX' AS keep_work_time_type
             , 'ALL_QTY_FIX' AS keep_qty_type
             , NULL AS sales_model_id
             , NULL AS attribute_set_id
             , NULL AS demand_id
             , 'DO::SSP' AS descr
             , 'Y' AS is_noh_consume	
        -- 20211013 [PJ20214907] AS : SSP의 'AS(WH-In 용) Plant Plan' 을 'AS(WH-In 용) Sales Plan' 으로 전환	
		-- SSP에서 BOD ID까지 전환하므로 원래 BOD ID로 전환	 
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
                  FROM #scm_dnm_ssp_plan_v_temp sc WITH (NOLOCK)  --ssp 테이블 변경(기존:ssp_anl_ship_confirm), 2024.10.07 
                  LEFT OUTER JOIN scm_adm_lookup_master_detail md WITH(NOLOCK)
                    ON sc.division_id = md.segment3
                   AND sc.to_site     = md.segment2
                   AND md.lookup_type = 'AS_SITE_PLANT'
                   AND md.valid_yn    = 'Y'
                 WHERE 1=1 -- division_id  = @p_division_id  -- 전극 'EE' 사업부 없음
               ) a              
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
               INNER JOIN ( SELECT dbo.FN_SCM_SPLIT(bod_id, 1, '::')  AS bod_id
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
        WHERE  a.yyyymmdd >= @p_plan_name --@v_cur_monday
        AND    a.yyyymmdd <  CONVERT(NVARCHAR(8), DATEADD(d, ISNULL(mse.ship_frozen, 0), @d_plan_name), 112)
        ;
        
        -----------------------------------------------------------
        --1-2) (FIX) SSP, SCP 출하계획 확정정보 Insert (ship_frozen 기간이후)
        
        /*
		    1. (20190624) SCP 출하계획 확정정보만 사용 : 확정구간(ship_frozen) 이후는 SSP 출하계획 확정정보 사용 안 함

            OLD : Start) 
            1. SSP qty <= SCP qty 이면 scp qty , scp fix_id
            2. SSP qty >  SCP qty 이면 
                        1) scp qty 유지, scp fix_id
                        2) ssp qty - scp qty : 신규 Fixed Plan으로 Insert, ssp confirm_id
            OLD : End) 
                  
            - (20181220 수정 키중복방지)      ssp_anl_ship_confirm 테이블에 동일정보에 여러건의 데이터가 존재하므로 SUM(수량) 처리함 ( Confirm_id는 'C' + 임의의값("ROW_NUMBER(ORDER BY ssp.item_id)") 형식으로 생성함)
            - (20190104 수정 조인조건 컬럼값) site_type = 'PLANT'일때 1) project_code = '-', 2) incoterms = '-' 처리함  ( site_type='PLANT'일때 SCP(scp_anl_shipment_plan_fix), SSP(ssp_anl_ship_confirm) 같은정보인데 project_code, incoterms 값이 존재하는건도 있고 없는건도 존재해서 조인처리시 서로다른건으로 인식되므로 '-'로 셋팅함)
                       
                  
            - 참고 테이블1) scp_anl_shipment_plan_fix : SCP 출하계획 확정정보
            - 참고 테이블2) ssp_anl_ship_confirm      : SSP 출하계획 확정정보
        */        
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_EE_PRE_PROC_FIXED_PLAN */ th_eng_fixed_plan_sn
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
        FROM   (           SELECT 
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
                                  ON (f.division_id = mse.division_id
			                     AND f.to_site     = mse.scm_site_id)
                               WHERE f.division_id   = @p_division_id -- '81'  
                                 AND f.qty           >  0
                                 AND f.yyyymmdd      >= @p_plan_name  --'20190103'
								 /* TE버전은 FP 이후 FIX 데이터 미생성, 2021.05.26, By KKC */
								 AND 1= CASE WHEN @p_plan_type = 'TE' AND @v_te_only_fp_yn = 'Y'THEN 0
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
                         WHERE  division_id         =  @p_division_id  --'EE'
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
                       --             FROM   ssp_anl_ship_confirm WITH (NOLOCK) --'EE'
                       --             WHERE  division_id         =  @p_division_id  
                       --             AND    qty                 >  0
                       --             AND    yyyymmdd            >= @p_plan_name  
                       --             AND    change_type         = 'C' --20180712 추가                                  
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

        /*(주석시작)20181207 주석처리함 : PROC_BOD의 fixed_term이 내부 site는 "0"처리되므로 ssp_anl_shipment_plan_semi(내부site 처리) 사용부분은 주석처리함) : 이부분처리시 PROC_BOD의 fixed_term컬럼부분 처리검토 필요함        
        -----------------------------------------------------------
        --2. SSP비대상 확정 출하 계획 정보 Insert
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_EE_PRE_PROC_FIXED_PLAN */ th_eng_fixed_plan_sn
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
             
             , 'DO::DELIVERY::' + CONVERT(NVARCHAR(10), 100000 + ROW_NUMBER() OVER (ORDER BY a.item_id)) AS work_order_id  -- 임의의 중복되지 않는값을 사용하기 위해서 row_number() 처리 함 
             
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
             
             , 'DO::DELIVERY::' + CONVERT(NVARCHAR(10), 100000 + ROW_NUMBER() OVER (ORDER BY a.item_id)) AS lot_id
             , 'N' AS is_fixed
             , 'Y' AS is_prev_schedule
             , 'START_FIX' AS keep_work_time_type
             , 'ALL_QTY_FIX' AS keep_qty_type
             , NULL AS sales_model_id
             , NULL AS attribute_set_id
             , NULL AS demand_id
             , 'DO::DELIVERY' AS descr
             , 'Y' AS is_noh_consume
        FROM  ( SELECT * 
                 FROM   scp_anl_shipment_plan_semi WITH (NOLOCK)  
                 WHERE  division_id         = @p_division_id  
                 AND    plan_start_yyyymmdd = @v_pre_plan_start_yyyymmdd
                 AND    plan_type           = @v_pre_plan_type 
                 AND    seq                 = @n_pre_plan_seq 
                 AND    measure             = 'SHIP_PLAN_AMEND'
                 AND    qty                 > 0
               ) a -- 내부 공장만 사용함

              INNER JOIN ( SELECT dbo.FN_SCM_SPLIT(bod_id, 1, '::')  AS bod_id    --bod_id
                                 , CONVERT(NUMERIC(18,3),attribute10) AS bod_lead_time
                                 , eng_to_site                                  
                            FROM   scm_mst_bod_eng a WITH (NOLOCK)                                 
                            WHERE  a.modeling_id = @p_modeling_id
                            AND    a.plan_id     = @p_plan_id
                            AND    a.plan_type   = @p_plan_type
                            AND    a.plan_seq    = @p_seq
                            AND    a.division_id = @p_division_id 
                            AND    attribute1    = 'INNER_SITE'  -- 공장내부(정상BOD만) 일때
                          ) be
               ON   a.bod_id = be.bod_id 
              
               INNER JOIN ( SELECT ship_frozen, scm_site_id, eng_scm_site_id 
                            FROM   scm_mst_site_eng WITH (NOLOCK)
                            WHERE  modeling_id = @p_modeling_id
                            AND    plan_id     = @p_plan_id
                            AND    plan_type   = @p_plan_type
                            AND    plan_seq    = @p_seq
                            AND    division_id = @p_division_id
                            AND    eng_scm_site_id = scm_site_id + '~***'                                                                         
                         )  mse
               ON a.from_site = mse.scm_site_id  
			   
        WHERE  a.yyyymmdd >= @p_plan_name --@v_cur_monday
        AND    a.yyyymmdd <  CONVERT(NVARCHAR(8), DATEADD(d, ISNULL(mse.ship_frozen, 0), @d_plan_name), 112)
        ;
        (주석종료)20181207 주석처리함 : PROC_BOD의 fixed_term이 내부 site는 "0"처리되므로 ssp_anl_shipment_plan_semi(내부site 처리) 사용부분은 주석처리함) : 이부분처리시 PROC_BOD의 fixed_term컬럼부분 처리검토 필요함*/

        /* 20180702 주석처리  ( 셀은 ~*** 까지만 처리하므로 특성 BOD는 처리하지 않아도됨)
        -----------------------------------------------------------
        --3. 특성 BOD : FP 생산 계획을 Fixed Plan(001 -> 002)로 반영
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_EE_PRE_PROC_FIXED_PLAN */ th_eng_fixed_plan_sn
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
        SELECT DISTINCT
               @p_master_id AS master_id
             , @p_engine_plan_id AS plan_id 
             , 'DO::FOR::' + CONVERT(NVARCHAR(10), 300000 + ROW_NUMBER() OVER (ORDER BY item_id)) AS work_order_id  -- 임의의 중복되지 않는값을 사용하기 위해서 row_number() 처리 함 
             , 1 AS work_order_seq
             , a.scm_site_id + '~002' AS site_id
             , a.item_id + '::' + b.bod_id AS route_id
             , a.item_id + '::' + b.bod_id AS operation_id
             , a.item_id
             , a.item_id + '::' + b.bod_id AS resource_id
             , NULL AS sub_resource_id
             , a.plan_date AS start_dttm
             , a.plan_date AS end_dttm
             , a.plan_in_qty AS operation_qty
             , a.plan_qty AS complete_qty
             , 'DO::FOR::' + CONVERT(NVARCHAR(10), 300000 + ROW_NUMBER() OVER (ORDER BY item_id)) AS lot_id
             , 'N' AS is_fixed
             , 'Y' AS is_prev_schedule
             , 'START_FIX' AS keep_work_time_type
             , 'ALL_QTY_FIX' AS keep_qty_type
             , NULL AS sales_model_id
             , NULL AS attribute_set_id
             , NULL AS demand_id
             , 'DO::FOR' AS descr
             , 'Y' AS is_noh_consume

        FROM   dbo.scm_dnm_plan_frozen_v     a WITH(NOLOCK)    

               INNER JOIN  dbo.scm_mst_bod_eng b WITH(NOLOCK) 
               ON   a.division_id      = b.division_id
               AND    a.scm_site_id    = b.from_site
               AND    b.eng_from_site  = b.from_site + '~001'
               AND    b.eng_to_site    = b.to_site + '~002'
               AND    b.plan_id        = @p_plan_id
               AND    b.plan_type      = @p_plan_type
               AND    b.plan_seq       = @p_seq
               AND    b.valid_yn       = 'Y'   

               INNER JOIN  ( SELECT eng_scm_site_id, fp_plan_period, ship_frozen, prod_frozen
                             FROM   dbo.scm_mst_site_eng WITH (NOLOCK)  
                             WHERE  modeling_id     = @p_modeling_id
                             AND    plan_id         = @p_plan_id
                             AND    plan_type       = @p_plan_type
                             AND    plan_seq        = @p_seq 
                             AND    division_id     = @p_division_id
                             AND    site_type       = 'PLANT' )  c 
               ON   a.scm_site_id + '~001' = c.eng_scm_site_id
			   
        WHERE  1=1
        AND    a.division_id  = @p_division_id  --'81'         
        AND    a.operation_id = 'F6000' -- 활성화 FP 생산 공정
        AND    a.plan_date   >= @d_plan_name --20180228 수정( @v_cur_monday 를 @p_plan_name로 변경함, plan_cycle 이 Daily 일경우도 처리되게 하기위함)
        AND    a.plan_date   <  DATEADD(DD, 21, @d_plan_name) -- 2018.06.26 3주 반영 : 변경 시 Proc BOD 도 수정 필요함
        --AND    a.plan_date   <  DATEADD(DD, ISNULL(c.ship_frozen, 0), @d_plan_name) -- Ship Frozen 기간 기준으로 생성함
        ;  
        */
        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------
		/* TE버전은 옵션값에 따라 전 FIX 데이터 미생성, 2021.09.03, By KKC */ 		
		SKIP1:

        /* 임시 테이블 정리, 2024.10.07 */
        IF OBJECT_ID('tempdb..#scm_dnm_ssp_plan_v_temp') IS NOT NULL
        BEGIN 
            DROP TABLE  #scm_dnm_ssp_plan_v_temp;   
        END 

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

