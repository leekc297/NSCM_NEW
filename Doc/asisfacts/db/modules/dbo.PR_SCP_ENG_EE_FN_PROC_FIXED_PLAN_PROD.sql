
/*
 * Program ID   : PR_SCP_ENG_EE_FN_PROC_FIXED_PLAN_PROD
 * Description  : 
                  -------------------------------------------------------------
                  --1. 확정 생산 계획  정보 Insert (PLAN_TYPE : 전체, 확정구간 내, scp_anl_production_plan)
                  -------------------------------------------------------------
                    -  1-1)  Capa공정이면서 Line 모델링 비대상 
                             - 참조 테이블 : scp_anl_production_plan (이전PLAN_TYPE 데이터사용)                           
                    -  1-2)  Capa공정이면서 Line 모델링 대상 
                             - 참조 테이블 : scp_anl_production_plan (이전PLAN_TYPE 데이터사용)                    
                    -  1-3)  OSP 대상 : Line Capa 비대상
                             - 참조 테이블 : scp_anl_production_plan (이전PLAN_TYPE 데이터사용)                    
                    -  1-4)  OSP_L 대상 : Line Capa 대상
                             - 참조 테이블 : scp_anl_production_plan (이전PLAN_TYPE 데이터사용)

                  -------------------------------------------------------------
                  --2. FIX 정보 공통적용 : [전지 공급 대응력 향상을 위한 SCM 관리 체계 개선] 전체 추가
                      - 구간 : 플랜시작일+prod_frozen 이후,  참조테이블 : scp_anl_production_plan_fix
                  -------------------------------------------------------------
                        -  2-1)  Capa공정이면서 Line 모델링 비대상
                                 - 참조 테이블 : scp_anl_production_plan_fix
                        -  2-2)  Capa공정이면서 Line 모델링 대상
                                 - 참조 테이블 : scp_anl_production_plan_fix								 
                        -  2-3)  OSP 
                                 - 참조 테이블 : scp_anl_production_plan_fix								 
                        -  2-4)  [OSP Line Plan] OSP_L Line Capa 대상 
                                 - 참조 테이블 : scp_anl_production_plan_fix
                  
                  -------------------------------------------------------------
                  --3. MA, SE, FN  공통적용 
                  -------------------------------------------------------------
                       -2-1) operation_qty 값에 수율 적용
                          -- [th_eng_fixed_plan_sn.operation_qty] = [CEILING(th_eng_fixed_plan_sn.complete_qty / th_eng_op_res_group_map_sn.yield)]  올림값을 셋팅
   
 * OutTable     :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.02.22   김성기         Initial Release  전지본부 GSCM(DM/SCP) 구축 프로젝트
 * 2018.06.01   김성기         BOM 정보 처리 수정
 * 2018.06.08   김성기         Work Order Seq Update 반영
 * 2018.06.18   KSW            FN처리를 SE처리와 동일하게 변경(SE처리조건에 FN추가)
 * 2018.07.05   KSG            CELL Biz Fix용 가상 BOD 형성
 * 2018.09.05   KSW            OPERATION_QTY 값에 수율 적용 (참고)주석3-1)
 * 2018.10.11   KSW            확정구간변경(전구간에서 fp_plan_period 기간 값으로 변경)
 * 2018.11.15   KSW            plan_type = 'TM' (시뮬레이션용으로 'MA'와 동일하게 처리됨) (참고)주석1
 * 2018.12.06   KSW            (20181011수정내용 원복처리) 확정구간변경(fp_plan_period -> 전구간(364) 값으로 변경) (참고)전체소수부분수정(  주석1-1), 주석1-2), 주석1-3), 2-1)-1), 2-2-1주석헤제, 2-2-2주석해제 )
 * 2019.02.11   KSW            'SE', 'FN' 일때도 기존 MA처럼(scp_anl_production_plan 전구간) 실행되게 변경함 (참고)주석1, 주석2(전체주석처리함)
 * 2020.02.06   KSG            [OSP Line Plan] OSP이면서 Line별 Capa 적용 Site 확정 계획 추가
 * 2020.07.14   KSG            [전지 공급 대응력 향상을 위한 SCM 관리 체계 개선] 전극 Main Plan 추가 및 Engine Run 기준 설정
 * 2020.08.12   KSG            [Packer Visivility] OSP : SCS 대상 여부에 따른 로직 분기
                                  현재 MA/SE/FN 에서 모두 이전 Plan의 생산계획 정보 사용하므로 FN용은 로직 수정은 하지 않음
								  => 향후 변경 시 로직 처리해야함
 * 2021.05.18   SEO            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 : 중장기 계획
 * 2021.05.26   KKC            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 : TM버전에 대해서는 FIX 데이터 미생성
 * 2024.10.07   KKC            PJ20249346  LGES SCP 개선과제 이행 : 자동차 해외법인 통합FP 52주 Daily 생산/출하계획 동기화
                               1. 관련 소스 정리 및 KEY값 중복 보완 (WORK_ORDER_ID)
                               2. 로직 분기 및 fp 동기화(scm_mst_site_eng.attr07 : 52주fp plant 적용여부 기준)
                                  1)52주 통합fp plant外 
                                    - scp amend 기준
                                  2)52주 통합fp plant 
                                    - ~ fp period frozen(fp 테이블 : 실적+계획)
                                    - fp period frozen ~ prod period frozen (scp amend기준) 
                                  3)공통
                                    - 기존 로직 유지
 */

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_EE_FN_PROC_FIXED_PLAN_PROD]
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_EE_FN_PROC_FIXED_PLAN_PROD';
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
    DECLARE @v_cur_wednesday     NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'WED')), 112); -- 당주 수요일 YYYYMMDD
    DECLARE @d_plan_name         DATETIME = CONVERT(DATETIME,@p_plan_name);
    DECLARE @v_pet_date          NVARCHAR(8) ; -- Plan End Date
	DECLARE @v_plan_horizon      INTEGER = 0;  -- Plan Horizon		--20201.05.18 중장기 계획

  -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN

	    SELECT @v_pet_date = p.horizon_end_date
			 , @v_plan_horizon = DATEDIFF(D,  CONVERT(DATE, plan_name), CONVERT(DATE, horizon_end_date) ) + 1	--2021.05.18 중장기 계획
        FROM   dbo.scm_mst_plan p WITH(NOLOCK)
        WHERE  p.division_id = @p_division_id 
        AND    p.plan_id     = @p_plan_id ;
	  
        -----------------------------------------------------------
	    -- PR_SCP_ENG_EE_FN_PROC_FIXED_PLAN 에서 Delete 처리함        
        -----------------------------------------------------------
        
        --공통 사용 데이터 Cutoff 생성.튜닝은 나중에 시간되면 충분히 고민하고 하자 2024.10.07
        /*
        IF OBJECT_ID('tempdb..#tmp_scp_anl_production_plan') IS NOT NULL
        	BEGIN 
        		DROP TABLE  #tmp_scp_anl_production_plan;          
        	END 
        
        SELECT a.*
          INTO #tmp_scp_anl_production_plan
          FROM
             	(
             	--1. CAPA/ OSP
             	SELECT a.division_id
             		, a.plan_start_yyyymmdd
             		, a.operation_group
             		, a.scm_site_id
             		, a.item_id
             		, a.line_id
             		, a.operation_id
             		, a.yyyymmdd
             		, a.qty
             		, b.descr              AS eng_res_descr
             		, b.site_id            AS eng_site_id
             		, b.route_id           AS eng_route_id
             		, b.resource_id        AS eng_resource_id
             	FROM scp_anl_production_plan a WITH(NOLOCK)
             	INNER JOIN 
             		(
             		SELECT SUBSTRING(r.resource_group_id, dbo.FN_CHARINDEX_REV(r.resource_group_id, '::', 0)+2, 100) AS line_id
             				, REPLACE(r.site_id, '~***', '') AS scm_site_id
             				, r.route_id
             				, r.resource_id
             				, r.descr
             				, r.site_id 
             			FROM th_eng_resource_sn r WITH(NOLOCK)
             		WHERE r.master_id = @p_master_id
             			AND r.plan_id = @p_engine_plan_id
             			AND r.descr     IN ('CAPA', 'OSP')
             		) b
             		ON b.scm_site_id  = a.scm_site_id
             		AND b.route_id  LIKE a.operation_id + '%' 
             	WHERE a.division_id         = @p_division_id  
             		AND a.plan_start_yyyymmdd = @p_plan_name 
             		AND a.plan_type           = @p_pre_plan_type 
             		AND a.seq                 = @p_pre_plan_seq 
             		AND a.measure             = 'PROD_PLAN_AMEND'
             		AND a.yyyymmdd            >= @p_plan_name
             		AND a.yyyymmdd            <= @v_pet_date
             		AND a.qty                 > 0
             	UNION ALL
             	--2. LINE_CAPA / OSP_L
             	SELECT a.division_id
             		, a.plan_start_yyyymmdd
             		, a.operation_group
             		, a.scm_site_id
             		, a.item_id
             		, a.line_id
             		, a.operation_id
             		, a.yyyymmdd
             		, a.qty
             		, b.descr              AS eng_res_descr
             		, b.site_id            AS eng_site_id
             		, b.route_id           AS eng_route_id
             		, b.resource_id        AS eng_resource_id
             	FROM scp_anl_production_plan a WITH(NOLOCK)
             	INNER JOIN 
             		(
             		SELECT SUBSTRING(r.resource_group_id, dbo.FN_CHARINDEX_REV(r.resource_group_id, '::', 0)+2, 100) AS line_id
             				, REPLACE(r.site_id, '~***', '') AS scm_site_id
             				, r.route_id
             				, r.resource_id
             				, r.descr
             				, r.site_id 
             			FROM th_eng_resource_sn r WITH(NOLOCK)
             		WHERE r.master_id = @p_master_id
             			AND r.plan_id   = @p_engine_plan_id
             			AND r.descr     IN ('LINE_CAPA', 'OSP_L')
             		) b
             		ON b.scm_site_id  = a.scm_site_id
             		AND b.route_id     = a.operation_id
             		AND b.line_Id      = a.line_id 
             	WHERE a.division_id         = @p_division_id  
             		AND a.plan_start_yyyymmdd = @p_plan_name 
             		AND a.plan_type           = @p_pre_plan_type 
             		AND a.seq                 = @p_pre_plan_seq 
             		AND a.measure             = 'PROD_PLAN_AMEND'
             		AND a.yyyymmdd            >= @p_plan_name
             		AND a.yyyymmdd            <= @v_pet_date
             		AND a.qty                 > 0
        	) a
        ;	  
        */
        
       /* 2024.10.07 주석 추가
           [WORK ORDER ID] 생성 채번 규칙 정리 
           --52fp통합 plant외 대상
           WO::CAPA::~ 900000
           WO::LINE_CAPA::~ 900000
           --52fp통합 plant 대상
           --~fp frozen
           WO::CAPA::~ 100000
           WO::LINE_CAPA::~ 100000
           --~fp frozen ~ prod frozen
           WO::CAPA::~ 200000
           WO::LINE_CAPA::~ 200000
       
           --~fp frozen ~ prod frozen    
           --공통 plant 대상
           WO::OSP::~100000000
           WO::OSP_L::~100000000
           WO::CAPA_CFM::+fix_id 
           WO::LINE_CAPA_CFM::+fix_id
           이하 생략
       */

        -----------------------------------------------------------		
        --1. 확정 생산 계획  정보 Insert (PLAN_TYPE : 전체, 확정구간 내, scp_anl_production_plan)
        --    20181115 수정 plan_type = 'TM'(시뮬레이션용으로 'MA'와 동일하게 처리됨)
        -----------------------------------------------------------
        IF (@p_plan_type IN ( 'MA', 'TM', 'SE', 'FN'))  
        
        BEGIN

        /**********************************************************
        1. 52fp통합 plant 대상外, 2024.10.07
        -- scp amend 기준으로 생성
        ***********************************************************/

        ----------------------------------------------------------
        --1-1) CAPA  공정(Line 모델링 비대상)
        ----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_EE_FN_PROC_FIXED_PLAN_PROD */ th_eng_fixed_plan_sn
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
                     /* WORK_ORDER_ID 채번 규칙 변경 (100000000 -> 900000), 2024.10.17 */
                     , 'WO::CAPA::' + CONVERT(NVARCHAR(10), 900000 + ROW_NUMBER() OVER ( ORDER BY  YYYYMMDD )) AS work_order_id
                     --, 'WO::CAPA::' + CONVERT(NVARCHAR(10), 100000000 + ROW_NUMBER() OVER ( ORDER BY  YYYYMMDD )) AS work_order_id
                     , 1 AS work_order_seq
                     , a.scm_site_id + '~***' AS site_id
                     , b.route_id AS route_id  -- res의 route id
                     , b.route_id AS operation_id
                     , a.item_id
                     , b.resource_id AS resource_id -- , b.route_id + '::' + a.scm_site_id + '~***' + '::' + '-' AS resource_id
                     , NULL AS sub_resource_id
                     , a.yyyymmdd  AS start_dttm
                     , a.yyyymmdd  AS end_dttm  --, DATEADD(d, 1, a.yyyymmdd) AS end_dttm
                     , a.qty AS operation_qty
                     , a.qty AS complete_qty
                     , 'WO::CAPA::' + CONVERT(NVARCHAR(10), 900000 + ROW_NUMBER() OVER ( ORDER BY  YYYYMMDD )) AS lot_id
                     , 'N' AS is_fixed
                     , 'Y' AS is_prev_schedule
                     , 'START_FIX' AS keep_work_time_type
                     , 'ALL_QTY_FIX' AS keep_qty_type
                     , NULL AS sales_model_id
                     , NULL AS attribute_set_id
                     , NULL AS demand_id
                     , 'WO::CAPA' AS descr
                     , 'Y' AS is_noh_consume        
                FROM   ( SELECT * 
                         FROM   scp_anl_production_plan WITH (NOLOCK)  
                         WHERE  division_id         = @p_division_id    -- 'EE'
                         AND    plan_start_yyyymmdd = @p_plan_name 
                         AND    plan_type           = @p_pre_plan_type 
                         AND    seq                 = @p_pre_plan_seq 
                         AND    measure             = 'PROD_PLAN_AMEND'
                         AND    qty                 > 0
                        ) a     
                      INNER JOIN  (SELECT SUBSTRING(r.resource_group_id, dbo.FN_CHARINDEX_REV(r.resource_group_id, '::', 0)+2, 100) AS line_id
                                                    , r.*
                                    FROM   th_eng_resource_sn r WITH(NOLOCK)
                                    WHERE  r.master_id = @p_master_id
                                    AND    r.plan_id   = @p_engine_plan_id
                                    -- SCP Capa 공정(Line Modeling 비대상) 
                                    AND    r.descr     IN ('CAPA')
                                    ) b
                      ON     b.site_id   = a.scm_site_id + '~***'
                      AND    b.route_id  LIKE a.operation_id + '%' -- AND    b.line_id   = a.line_id 
                      INNER JOIN   ( SELECT a.scm_site_id
                                          , a.fp_plan_period   
                                          , ISNULL(a.prod_frozen, 0) AS prod_frozen
                                       FROM dbo.scm_mst_site_eng a WITH (NOLOCK)  
                                      WHERE a.modeling_id     = @p_modeling_id
                                        AND a.plan_id         = @p_plan_id
                                        AND a.plan_type       = @p_plan_type
                                        AND a.plan_seq        = @p_seq 
                                        AND a.division_id     = @p_division_id
                                        AND a.eng_scm_site_id = a.scm_site_id + '~***' 
                                        AND ISNULL(a.osp_yn, 'N') = 'N'       --외주 packer 아님 
                                        AND ISNULL(a.attribute7, 'N') = 'N'   --52주통합plant 적용 대상 제외, 2024.10.07 추가
                                   ) c 
                      ON    a.scm_site_id  = c.scm_site_id                      
                      AND   a.yyyymmdd    >= @p_plan_name 
					  -- [전지 공급 대응력 향상을 위한 SCM 관리 체계 개선] 364인 경우와 아닌 경우 분리
                      --AND   a.yyyymmdd    <= CASE WHEN c.prod_frozen = 364 THEN @v_pet_date
					  AND   a.yyyymmdd    <= CASE WHEN c.prod_frozen = @v_plan_horizon THEN @v_pet_date		--2021.05.18 중장기 계획
                                                  ELSE CONVERT(NVARCHAR(8), DATEADD(DD, c.prod_frozen-1, @d_plan_name), 112) -- <= 조건이므로 (prod_frozen-1)처리
                                             END			  
			          -- 2018.06.01 ksg DISTINCT 처리
                      INNER JOIN   (SELECT DISTINCT SUBSTRING(bom.route_id, 1, 5) AS res_route_id
                                         , bom.site_id, bom.parent_item_id, bom.route_id
                                    FROM   th_eng_plan_bom_sn bom WITH (NOLOCK)
                                    WHERE  master_id = @p_master_id --'81::WEEKLY'
                                    AND    plan_id   = @p_engine_plan_id
                                   ) e
                      ON   a.scm_site_id + '~***'  = e.site_id 
                      AND  a.item_id               = e.parent_item_id  
                      AND  b.route_id              = e.route_id
                OPTION (HASH JOIN) --20190211 추가
        ;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id;
        SET @v_description = N'1-1) CAPA  공정...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
         
        ----------------------------------------------------------
        --1-2) Line 모델링 대상
        ----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_EE_FN_PROC_FIXED_PLAN_PROD */ th_eng_fixed_plan_sn
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
                       /* WORK_ORDER_ID 채번 규칙 변경 (100000000 -> 900000), 2024.10.17 */
                     , 'WO::LINE_CAPA::' + CONVERT(NVARCHAR(10), 900000 + ROW_NUMBER() OVER ( ORDER BY  YYYYMMDD )) AS work_order_id
                     --, 'WO::LINE_CAPA::' + CONVERT(NVARCHAR(10), 100000000 + ROW_NUMBER() OVER ( ORDER BY  YYYYMMDD )) AS work_order_id
                     , 1 AS work_order_seq
                     , a.scm_site_id + '~***' AS site_id                     
                     , e.route_id  AS route_id  --bom의 route id
                     , e.route_id  AS operation_id                    
                     , a.item_id
                     , b.resource_id AS resource_id -- , b.route_id + '::' + a.scm_site_id + '~***' + '::' + a.line_id AS resource_id
                     , NULL AS sub_resource_id
                     , a.yyyymmdd  AS start_dttm
                     , a.yyyymmdd  AS end_dttm  --, DATEADD(d, 1, a.yyyymmdd) AS end_dttm
                     , a.qty AS operation_qty
                     , a.qty AS complete_qty
                     , 'WO::LINE_CAPA::' + CONVERT(NVARCHAR(10), 900000 + ROW_NUMBER() OVER ( ORDER BY  YYYYMMDD )) AS lot_id
                     , 'N' AS is_fixed
                     , 'Y' AS is_prev_schedule
                     , 'START_FIX' AS keep_work_time_type
                     , 'ALL_QTY_FIX' AS keep_qty_type
                     , NULL AS sales_model_id
                     , NULL AS attribute_set_id
                     , NULL AS demand_id
                     , 'WO::LINE_CAPA' AS descr
                     , 'Y' AS is_noh_consume        
                FROM   ( SELECT * 
                         FROM   scp_anl_production_plan WITH (NOLOCK)  
                         WHERE  division_id         = @p_division_id   -- 'EE'
                         AND    plan_start_yyyymmdd = @p_plan_name 
                         AND    plan_type           = @p_pre_plan_type 
                         AND    seq                 = @p_pre_plan_seq 
                         AND    measure             = 'PROD_PLAN_AMEND'
                         AND    qty                 > 0
                        ) a     
                      INNER JOIN    (SELECT SUBSTRING(r.resource_group_id, dbo.FN_CHARINDEX_REV(r.resource_group_id, '::', 0)+2, 100) AS line_id
                                                    , r.*
                                    FROM   th_eng_resource_sn r WITH(NOLOCK)
                                    WHERE  r.master_id = @p_master_id
                                    AND    r.plan_id   = @p_engine_plan_id
                                    -- SCP Capa 공정(Line Modeling 대상 포함) 
                                    AND    r.descr     IN ('LINE_CAPA')
                                    ) b
                      ON     b.site_id   = a.scm_site_id + '~***'
                      AND    b.route_id  = a.operation_id
                      AND    b.line_id   = a.line_id 
                      INNER JOIN   ( SELECT a.scm_site_id
                                          , a.fp_plan_period   
                                          , ISNULL(a.prod_frozen, 0) AS prod_frozen
                                       FROM dbo.scm_mst_site_eng a WITH (NOLOCK)  
                                      WHERE a.modeling_id    = @p_modeling_id
                                        AND a.plan_id         = @p_plan_id
                                        AND a.plan_type       = @p_plan_type
                                        AND a.plan_seq        = @p_seq 
                                        AND a.division_id     = @p_division_id
                                        AND a.eng_scm_site_id = a.scm_site_id + '~***' 
                                        AND ISNULL(osp_yn, 'N') = 'N'   --외주 packer 아님 
                                        AND ISNULL(a.attribute7, 'N')  = 'N'   --52주통합plant 적용 대상 제외, 2024.10.07 추가
                                   ) c 
                      ON    a.scm_site_id  = c.scm_site_id                      
                      AND   a.yyyymmdd    >= @p_plan_name 
					  -- [전지 공급 대응력 향상을 위한 SCM 관리 체계 개선] 364인 경우와 아닌 경우 분리
                      --AND   a.yyyymmdd    <= CASE WHEN c.prod_frozen = 364 THEN @v_pet_date
					  AND   a.yyyymmdd    <= CASE WHEN c.prod_frozen = @v_plan_horizon THEN @v_pet_date		--2021.05.18 중장기 계획
                                                  ELSE CONVERT(NVARCHAR(8), DATEADD(DD, c.prod_frozen-1, @d_plan_name), 112) -- <= 조건이므로 (prod_frozen-1)처리
                                             END			  
			          -- 2018.06.01 ksg DISTINCT 처리
                      INNER JOIN   (SELECT DISTINCT SUBSTRING(bom.route_id, 1, 5) AS res_route_id
                                         , bom.site_id, bom.parent_item_id, bom.route_id
                                    FROM   th_eng_plan_bom_sn bom WITH (NOLOCK)
                                    WHERE  master_id = @p_master_id --'81::WEEKLY'
                                    AND    plan_id   = @p_engine_plan_id
                                   ) e                      
                      ON   a.scm_site_id + '~***'  = e.site_id 
                      AND  a.item_id               = e.parent_item_id  
                      AND  b.route_id              = e.res_route_id
                OPTION (HASH JOIN) --20190211 추가
        ;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id;
        SET @v_description = N'1-2) Line 모델링 대상...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        /**********************************************************
        2. 52fp통합 plant 대상, 2024.10.07 추가
        -- ~ fp frozen 구간내
        -- fp frozen 구간 ~ prod frozen 구간내
        -- prod frozen 구간 이후
        ***********************************************************/
        ----------------------------------------------------------
        --2-1) ~ fp frozen 구간 
        ----------------------------------------------------------

        -----------------------------------------------------------
        --2-1-1)  FIX 확정 생산 계획  정보 Insert : Capa공정이면서 Line 모델링 비대상
        --      - FP_Plan_Load 구간내
        -----------------------------------------------------------        
        INSERT INTO /* PR_SCP_ENG_EE_FN_PROC_FIXED_PLAN_PROD */ th_eng_fixed_plan_sn
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
                    , 'WO::CAPA::' + CONVERT(NVARCHAR(10), 100000 + ROW_NUMBER() OVER (ORDER BY item_id)) AS work_order_id  -- 임의의 중복되지 않는값을 사용하기 위해서 row_number() 처리 함 
                    , 1 AS work_order_seq
                    , a.scm_site_id + '~***' AS site_id
                    , b.route_id AS route_id  -- res의 route id
                    , b.route_id AS operation_id
                    , a.item_id
                   -- , b.route_id + '::' + a.scm_site_id + '~***' + '::' + '-' AS resource_id
                    , b.resource_id AS resource_id
                    , NULL AS sub_resource_id
                    , a.plan_date AS start_dttm
                    , a.plan_date AS end_dttm
                    , a.plan_in_qty AS operation_qty
                    , a.plan_qty AS complete_qty
                    , 'WO::CAPA::' + CONVERT(NVARCHAR(10), 100000 + ROW_NUMBER() OVER (ORDER BY item_id)) AS lot_id
                    , 'N' AS is_fixed
                    , 'Y' AS is_prev_schedule
                    , 'START_FIX' AS keep_work_time_type
                    , 'ALL_QTY_FIX' AS keep_qty_type
                    , NULL AS sales_model_id
                    , NULL AS attribute_set_id
                    , NULL AS demand_id
                    , 'WO::CAPA' AS descr
                    , 'Y' AS is_noh_consume        
                FROM  scm_dnm_week_plan_frozen_v a WITH(NOLOCK) -- 실적+계획, View 속도가 문제될지 검토 필요, 2024.10.07   
               INNER JOIN    (SELECT SUBSTRING(r.resource_group_id, dbo.FN_CHARINDEX_REV(r.resource_group_id, '::', 0)+2, 100) AS line_id
                                             , r.*
                                FROM th_eng_resource_sn r WITH(NOLOCK)
                               WHERE r.master_id = @p_master_id
                                 AND r.plan_id   = @p_engine_plan_id                           
                                 AND r.descr     = 'CAPA' --SCP Capa 공정이면서 Line Modeling 비대상 공정
                             ) b      
                 ON b.site_id   = a.scm_site_id + '~***'
                -- Line Modeling 비대상
                AND b.route_id  LIKE a.operation_id + '%'
             -- AND b.line_id   = a.line_id
               INNER JOIN   ( SELECT a.scm_site_id
                                   , a.fp_plan_period   
                                FROM dbo.scm_mst_site_eng a WITH (NOLOCK)  
                               WHERE a.modeling_id     = @p_modeling_id
                                 AND a.plan_id         = @p_plan_id
                                 AND a.plan_type       = @p_plan_type
                                 AND a.plan_seq        = @p_seq 
                                 AND a.division_id     = @p_division_id
                                 AND a.eng_scm_site_id = a.scm_site_id + '~***' 
                                 AND ISNULL(a.osp_yn, 'N') = 'N'       --외주 packer 아님 
                                 AND ISNULL(a.attribute7, 'N')  = 'Y'  --52주통합plant 적용 대상
                            ) c 
                  ON a.plan_date    >= @d_plan_name --20180228 수정( @v_cur_monday 를 @p_plan_name로 변경함, plan_cycle 이 Daily 일경우도 처리되게 하기위함) (변경전 : AND    a.plan_date           >= CONVERT(DATETIME, @v_cur_monday))
                 AND a.plan_date    <  DATEADD(DD, ISNULL(c.fp_plan_period, 0), @d_plan_name)
                 AND a.scm_site_id  = c.scm_site_id			  
       		-- 2018.06.01 ksg DISTINCT 처리
               INNER JOIN   (SELECT DISTINCT SUBSTRING(bom.route_id, 1, 5) AS res_route_id
                                  , bom.site_id, bom.parent_item_id, bom.route_id
                               FROM th_eng_plan_bom_sn bom WITH (NOLOCK)
                              WHERE master_id = @p_master_id --'81::WEEKLY'
                                AND plan_id   = @p_engine_plan_id
                               ) e			  
                  ON a.scm_site_id + '~***'  = e.site_id 
                 AND a.item_id               = e.parent_item_id  
                 AND b.route_id              = e.route_id			   
               WHERE 1=1
                 AND a.plan_qty    > 0      
                 AND a.plan_in_qty > 0       
        ;
        
        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id; 
        SET @v_description = N'2-1-1)  확정 생산 계획 : Line 모델링 비대상...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        
        -----------------------------------------------------------
        --2-1-2) 확정 생산 계획  정보 Insert : Line 모델링 대상
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_EE_FN_PROC_FIXED_PLAN_PROD */ th_eng_fixed_plan_sn
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
                        @p_master_id
                      , @p_engine_plan_id
                      , 'WO::LINE_CAPA::' + CONVERT(NVARCHAR(10), 100000 + ROW_NUMBER() OVER (ORDER BY item_id)) AS work_order_id  -- 임의의 중복되지 않는값을 사용하기 위해서 row_number() 처리 함 
                      , 1 AS work_order_seq
                      , a.scm_site_id + '~***' AS site_id
                      , e.route_id AS route_id   -- bom의 route id
                      , e.route_id AS operation_id
                      , a.item_id
                    --  , b.route_id + '::' + a.scm_site_id + '~***' + '::' + a.line_id AS resource_id -- res는 여러 Route에 동시에 사용 가능함
                      , b.resource_id AS resource_id
                      , NULL AS sub_resource_id
                      , a.plan_date AS start_dttm
                      , a.plan_date AS end_dttm
                      , a.plan_in_qty AS operation_qty
                      , a.plan_qty AS complete_qty
                      , 'WO::LINE_CAPA::' + CONVERT(NVARCHAR(10), 100000 + ROW_NUMBER() OVER (ORDER BY item_id)) AS lot_id
                      , 'N' AS is_fixed
                      , 'Y' AS is_prev_schedule
                      , 'START_FIX' AS keep_work_time_type
                      , 'ALL_QTY_FIX' AS keep_qty_type
                      , NULL AS sales_model_id
                      , NULL AS attribute_set_id
                      , NULL AS demand_id
                      , 'WO::LINE_CAPA' AS descr
                      , 'Y' AS is_noh_consume        
                 FROM  scm_dnm_week_plan_frozen_v a WITH(NOLOCK) --PR이후는 실적+FP계획           
                       INNER  JOIN  (SELECT SUBSTRING(r.resource_group_id, dbo.FN_CHARINDEX_REV(r.resource_group_id, '::', 0)+2, 100) AS line_id
                                                     , r.*
                                     FROM   th_eng_resource_sn r WITH(NOLOCK)
                                     WHERE  r.master_id = @p_master_id
                                     AND    r.plan_id   = @p_engine_plan_id
                                     -- SCP Capa 공정이면서 Line Modeling 대상 공정 
                                     AND    r.descr     = 'LINE_CAPA' 
                                    ) b
                       ON     b.site_id   = a.scm_site_id + '~***'
                       -- Line Modeling 대상
                       AND    b.route_id  = a.operation_id
                       AND    b.line_id   = a.line_id
                       INNER JOIN   ( SELECT a.scm_site_id 
                                           , a.fp_plan_period   
                                        FROM dbo.scm_mst_site_eng a WITH (NOLOCK)  
                                       WHERE a.modeling_id     = @p_modeling_id
                                         AND a.plan_id         = @p_plan_id
                                         AND a.plan_type       = @p_plan_type
                                         AND a.plan_seq        = @p_seq 
                                         AND a.division_id     = @p_division_id
                                         AND a.eng_scm_site_id = a.scm_site_id + '~***' 
                                         AND ISNULL(a.osp_yn, 'N') = 'N'   --외주 packer 아님 
                                         AND ISNULL(a.attribute7, 'N')  = 'Y'  --52주통합plant 적용 대상
                                    ) c 
                       ON    a.plan_date     >= @d_plan_name --20180228 수정( @v_cur_monday 를 @p_plan_name로 변경함, plan_cycle 이 Daily 일경우도 처리되게 하기위함) (변경전 : AND    a.plan_date           >= CONVERT(DATETIME, @v_cur_monday))
                       AND   a.plan_date     <  DATEADD(DD, ISNULL(c.fp_plan_period, 0), @d_plan_name)
                       AND   a.scm_site_id   = c.scm_site_id 			  
	         		  -- 2018.06.01 ksg DISTINCT 처리
                       INNER JOIN   (SELECT DISTINCT SUBSTRING(bom.route_id, 1, 5) AS res_route_id
                                          , bom.site_id, bom.parent_item_id, bom.route_id
                                     FROM   th_eng_plan_bom_sn bom WITH (NOLOCK)
                                     WHERE  master_id = @p_master_id --'81::WEEKLY'
                                     AND    plan_id   = @p_engine_plan_id
                                    ) e
                       ON    a.scm_site_id + '~***'  = e.site_id 
                       AND   a.item_id               = e.parent_item_id  
                       AND   b.route_id              = e.res_route_id			   
                 WHERE  1=1
                 --AND    a.division_id = @p_division_id  --'81'    -- 20180702 주석처리
                 AND    a.plan_qty    > 0
                 AND    a.plan_in_qty > 0     
        ;
       	
        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id; 
        SET @v_description = N'2-1-2) 확정 생산 계획 : Line 모델링 대상...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        ----------------------------------------------------------
        --2-2) fp frozen 구간 ~ prod frozen 
        ----------------------------------------------------------
        ----------------------------------------------------------
        --2-2-1) CAPA  공정(Line 모델링 비대상)
        ----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_EE_FN_PROC_FIXED_PLAN_PROD */ th_eng_fixed_plan_sn
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
                     , 'WO::CAPA::' + CONVERT(NVARCHAR(10), 200000 + ROW_NUMBER() OVER ( ORDER BY  YYYYMMDD )) AS work_order_id
                     , 1 AS work_order_seq
                     , a.scm_site_id + '~***' AS site_id
                     , b.route_id AS route_id  -- res의 route id
                     , b.route_id AS operation_id
                     , a.item_id
                     , b.resource_id AS resource_id -- , b.route_id + '::' + a.scm_site_id + '~***' + '::' + '-' AS resource_id
                     , NULL AS sub_resource_id
                     , a.yyyymmdd  AS start_dttm
                     , a.yyyymmdd  AS end_dttm  --, DATEADD(d, 1, a.yyyymmdd) AS end_dttm
                     , a.qty AS operation_qty
                     , a.qty AS complete_qty
                     , 'WO::CAPA::' + CONVERT(NVARCHAR(10), 200000 + ROW_NUMBER() OVER ( ORDER BY  YYYYMMDD )) AS lot_id
                     , 'N' AS is_fixed
                     , 'Y' AS is_prev_schedule
                     , 'START_FIX' AS keep_work_time_type
                     , 'ALL_QTY_FIX' AS keep_qty_type
                     , NULL AS sales_model_id
                     , NULL AS attribute_set_id
                     , NULL AS demand_id
                     , 'WO::CAPA' AS descr
                     , 'Y' AS is_noh_consume        
                FROM   ( SELECT * 
                         FROM   scp_anl_production_plan WITH (NOLOCK)  
                         WHERE  division_id         = @p_division_id    -- 'EE'
                         AND    plan_start_yyyymmdd = @p_plan_name 
                         AND    plan_type           = @p_pre_plan_type 
                         AND    seq                 = @p_pre_plan_seq 
                         AND    measure             = 'PROD_PLAN_AMEND'
                         AND    qty                 > 0
                        ) a     
                      INNER JOIN  (SELECT SUBSTRING(r.resource_group_id, dbo.FN_CHARINDEX_REV(r.resource_group_id, '::', 0)+2, 100) AS line_id
                                                    , r.*
                                    FROM   th_eng_resource_sn r WITH(NOLOCK)
                                    WHERE  r.master_id = @p_master_id
                                    AND    r.plan_id   = @p_engine_plan_id
                                    -- SCP Capa 공정(Line Modeling 비대상) 
                                    AND    r.descr     IN ('CAPA')
                                    ) b
                      ON     b.site_id   = a.scm_site_id + '~***'
                      AND    b.route_id  LIKE a.operation_id + '%' -- AND    b.line_id   = a.line_id 
                      INNER JOIN   ( SELECT a.scm_site_id
                                          , a.fp_plan_period   
                                          , ISNULL(a.prod_frozen, 0) AS prod_frozen
                                       FROM dbo.scm_mst_site_eng a WITH (NOLOCK)  
                                      WHERE a.modeling_id     = @p_modeling_id
                                        AND a.plan_id         = @p_plan_id
                                        AND a.plan_type       = @p_plan_type
                                        AND a.plan_seq        = @p_seq 
                                        AND a.division_id     = @p_division_id
                                        AND a.eng_scm_site_id = a.scm_site_id + '~***' 
                                        AND ISNULL(a.osp_yn, 'N') = 'N'       --외주 packer 아님 
                                        AND ISNULL(a.attribute7, 'N') = 'Y'   --52주통합plant 적용 대상
                                   ) c 
                      ON    a.scm_site_id  = c.scm_site_id                      
                      AND   a.yyyymmdd    >= CONVERT(NVARCHAR(8), DATEADD(DD, c.fp_plan_period, @d_plan_name), 112) -- FP_Plan_Load 이후 구간 
					  AND   a.yyyymmdd    <= CASE WHEN c.prod_frozen = @v_plan_horizon THEN @v_pet_date		--2021.05.18 중장기 계획
                                                  ELSE CONVERT(NVARCHAR(8), DATEADD(DD, c.prod_frozen-1, @d_plan_name), 112) -- <= 조건이므로 (prod_frozen-1)처리
                                              END			  
			          -- 2018.06.01 ksg DISTINCT 처리
                      INNER JOIN   (SELECT DISTINCT SUBSTRING(bom.route_id, 1, 5) AS res_route_id
                                         , bom.site_id, bom.parent_item_id, bom.route_id
                                    FROM   th_eng_plan_bom_sn bom WITH (NOLOCK)
                                    WHERE  master_id = @p_master_id --'81::WEEKLY'
                                    AND    plan_id   = @p_engine_plan_id
                                   ) e
                      ON   a.scm_site_id + '~***'  = e.site_id 
                      AND  a.item_id               = e.parent_item_id  
                      AND  b.route_id              = e.route_id
                OPTION (HASH JOIN) --20190211 추가
        ;
        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id;
        SET @v_description = N'2-2-1) Line 모델링 대상...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        ----------------------------------------------------------
        --2-2-2) Line 모델링 대상
        ----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_EE_FN_PROC_FIXED_PLAN_PROD */ th_eng_fixed_plan_sn
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
                     , 'WO::LINE_CAPA::' + CONVERT(NVARCHAR(10), 200000 + ROW_NUMBER() OVER ( ORDER BY  YYYYMMDD )) AS work_order_id
                     , 1 AS work_order_seq
                     , a.scm_site_id + '~***' AS site_id                     
                     , e.route_id  AS route_id  --bom의 route id
                     , e.route_id  AS operation_id                    
                     , a.item_id
                     , b.resource_id AS resource_id -- , b.route_id + '::' + a.scm_site_id + '~***' + '::' + a.line_id AS resource_id
                     , NULL AS sub_resource_id
                     , a.yyyymmdd  AS start_dttm
                     , a.yyyymmdd  AS end_dttm  --, DATEADD(d, 1, a.yyyymmdd) AS end_dttm
                     , a.qty AS operation_qty
                     , a.qty AS complete_qty
                     , 'WO::LINE_CAPA::' + CONVERT(NVARCHAR(10), 200000 + ROW_NUMBER() OVER ( ORDER BY  YYYYMMDD )) AS lot_id
                     , 'N' AS is_fixed
                     , 'Y' AS is_prev_schedule
                     , 'START_FIX' AS keep_work_time_type
                     , 'ALL_QTY_FIX' AS keep_qty_type
                     , NULL AS sales_model_id
                     , NULL AS attribute_set_id
                     , NULL AS demand_id
                     , 'WO::LINE_CAPA' AS descr
                     , 'Y' AS is_noh_consume        
                FROM   ( SELECT * 
                         FROM   scp_anl_production_plan WITH (NOLOCK)  
                         WHERE  division_id         = @p_division_id   -- 'EE'
                         AND    plan_start_yyyymmdd = @p_plan_name 
                         AND    plan_type           = @p_pre_plan_type 
                         AND    seq                 = @p_pre_plan_seq 
                         AND    measure             = 'PROD_PLAN_AMEND'
                         AND    qty                 > 0
                        ) a     
                      INNER JOIN    (SELECT SUBSTRING(r.resource_group_id, dbo.FN_CHARINDEX_REV(r.resource_group_id, '::', 0)+2, 100) AS line_id
                                                    , r.*
                                    FROM   th_eng_resource_sn r WITH(NOLOCK)
                                    WHERE  r.master_id = @p_master_id
                                    AND    r.plan_id   = @p_engine_plan_id
                                    -- SCP Capa 공정(Line Modeling 대상 포함) 
                                    AND    r.descr     IN ('LINE_CAPA')
                                    ) b
                      ON     b.site_id   = a.scm_site_id + '~***'
                      AND    b.route_id  = a.operation_id
                      AND    b.line_id   = a.line_id 
                      INNER JOIN   ( SELECT a.scm_site_id
                                          , a.fp_plan_period   
                                          , ISNULL(a.prod_frozen, 0) AS prod_frozen
                                       FROM dbo.scm_mst_site_eng a WITH (NOLOCK)  
                                      WHERE a.modeling_id    = @p_modeling_id
                                        AND a.plan_id         = @p_plan_id
                                        AND a.plan_type       = @p_plan_type
                                        AND a.plan_seq        = @p_seq 
                                        AND a.division_id     = @p_division_id
                                        AND a.eng_scm_site_id = a.scm_site_id + '~***' 
                                        AND ISNULL(osp_yn, 'N') = 'N'        --외주 packer 아님 
                                        AND ISNULL(a.attribute7, 'N')  = 'Y' --52주통합plant 적용 대상
                                   ) c 
                      ON    a.scm_site_id  = c.scm_site_id                      
                      AND   a.yyyymmdd    >= CONVERT(NVARCHAR(8), DATEADD(DD, c.fp_plan_period, @d_plan_name), 112) -- FP_Plan_Load 이후 구간
					  AND   a.yyyymmdd    <= CASE WHEN c.prod_frozen = @v_plan_horizon THEN @v_pet_date		--2021.05.18 중장기 계획
                                                  ELSE CONVERT(NVARCHAR(8), DATEADD(DD, c.prod_frozen-1, @d_plan_name), 112) -- <= 조건이므로 (prod_frozen-1)처리
                                             END			  
			          -- 2018.06.01 ksg DISTINCT 처리
                      INNER JOIN   (SELECT DISTINCT SUBSTRING(bom.route_id, 1, 5) AS res_route_id
                                         , bom.site_id, bom.parent_item_id, bom.route_id
                                    FROM   th_eng_plan_bom_sn bom WITH (NOLOCK)
                                    WHERE  master_id = @p_master_id --'81::WEEKLY'
                                    AND    plan_id   = @p_engine_plan_id
                                   ) e                      
                      ON   a.scm_site_id + '~***'  = e.site_id 
                      AND  a.item_id               = e.parent_item_id  
                      AND  b.route_id              = e.res_route_id
                OPTION (HASH JOIN) --20190211 추가
        ;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id;
        SET @v_description = N'2-2-2) Line 모델링 대상...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        /**********************************************************
        3. 공통 plant 대상, 주석만 추가 2024.10.07
        --OSP / OSP_L 등등 기존로직 유지
        ***********************************************************/

        ----------------------------------------------------------
        --3-1) OSP : Line Capa 비대상
        ----------------------------------------------------------                  
        INSERT INTO /* PR_SCP_ENG_EE_FN_PROC_FIXED_PLAN_PROD */ th_eng_fixed_plan_sn
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
                     , 'WO::OSP::' + CONVERT(NVARCHAR(10), 100000000 + ROW_NUMBER() OVER ( ORDER BY  YYYYMMDD )) AS work_order_id
                     , 1 AS work_order_seq
                     , a.scm_site_id + '~***' AS site_id
                     , b.route_id AS route_id  -- res의 route id
                     , b.route_id AS operation_id
                     , a.item_id
                     , b.resource_id AS resource_id -- , b.route_id + '::' + a.scm_site_id + '~***' + '::' + '-' AS resource_id
                     , NULL AS sub_resource_id
                     , a.yyyymmdd  AS start_dttm
                     , a.yyyymmdd  AS end_dttm  --, DATEADD(d, 1, a.yyyymmdd) AS end_dttm
                     , a.qty AS operation_qty
                     , a.qty AS complete_qty
                     , 'WO::OSP::' + CONVERT(NVARCHAR(10), 100000000 + ROW_NUMBER() OVER ( ORDER BY  YYYYMMDD )) AS lot_id
                     , 'N' AS is_fixed
                     , 'Y' AS is_prev_schedule
                     , 'START_FIX' AS keep_work_time_type
                     , 'ALL_QTY_FIX' AS keep_qty_type
                     , NULL AS sales_model_id
                     , NULL AS attribute_set_id
                     , NULL AS demand_id
                     , 'WO::OSP' AS descr
                     , 'Y' AS is_noh_consume        
                FROM   ( SELECT * 
                         FROM   scp_anl_production_plan WITH (NOLOCK)  
                         WHERE  division_id         = @p_division_id    -- 'EE'
                         AND    plan_start_yyyymmdd = @p_plan_name 
                         AND    plan_type           = @p_pre_plan_type 
                         AND    seq                 = @p_pre_plan_seq 
                         AND    measure             = 'PROD_PLAN_AMEND'
                         AND    qty                 > 0
                        ) a     
                      INNER JOIN    (SELECT SUBSTRING(r.resource_group_id, dbo.FN_CHARINDEX_REV(r.resource_group_id, '::', 0)+2, 100) AS line_id
                                                    , r.*
                                    FROM   th_eng_resource_sn r WITH(NOLOCK)
                                    WHERE  r.master_id = @p_master_id
                                    AND    r.plan_id   = @p_engine_plan_id
                                    -- 외주 packer 
                                    AND    r.descr     = 'OSP'
                                    ) b
                      ON     b.site_id   = a.scm_site_id + '~***'
                      AND    b.route_id  LIKE a.operation_id + '%' -- AND    b.line_id   = a.line_id 
                      INNER JOIN   ( SELECT scm_site_id, fp_plan_period   
                                         ,  ISNULL(prod_frozen, 0) AS prod_frozen
                                     FROM   dbo.scm_mst_site_eng WITH (NOLOCK)  
                                     WHERE  modeling_id     = @p_modeling_id
                                     AND    plan_id         = @p_plan_id
                                     AND    plan_type       = @p_plan_type
                                     AND    plan_seq        = @p_seq 
                                     AND    division_id     = @p_division_id
                                     AND    eng_scm_site_id = scm_site_id + '~***' 
                                     AND    ISNULL(osp_yn, 'N')                 = 'Y'  --외주 packer  
                                     AND    DBO.FN_SCM_SYS_NVL(attribute1, 'N') = 'N'  --외주 packer Line Capa 비대상
                                   ) c 
                      ON    a.scm_site_id  = c.scm_site_id                    
                      AND   a.yyyymmdd    >= @p_plan_name 
					  -- [전지 공급 대응력 향상을 위한 SCM 관리 체계 개선] 364인 경우와 아닌 경우 분리
                      --AND   a.yyyymmdd    <= CASE WHEN c.prod_frozen = 364 THEN @v_pet_date
					  AND   a.yyyymmdd    <= CASE WHEN c.prod_frozen = @v_plan_horizon THEN @v_pet_date		--2021.05.18 중장기 계획
                                                  ELSE CONVERT(NVARCHAR(8), DATEADD(DD, c.prod_frozen-1, @d_plan_name), 112) -- <= 조건이므로 (prod_frozen-1)처리
                                             END
			          -- 2018.06.01 ksg DISTINCT 처리
                      INNER JOIN   (SELECT DISTINCT SUBSTRING(bom.route_id, 1, 5) AS res_route_id
                                         , bom.site_id, bom.parent_item_id, bom.route_id
                                    FROM   th_eng_plan_bom_sn bom WITH (NOLOCK)
                                    WHERE  master_id = @p_master_id --'81::WEEKLY'
                                    AND    plan_id   = @p_engine_plan_id
                                   ) e
                      ON   a.scm_site_id + '~***'  = e.site_id 
                      AND  a.item_id               = e.parent_item_id  
                      AND  b.route_id              = e.route_id
                
                OPTION (HASH JOIN) --20190211 추가
        ;           

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id;
        SET @v_description = N'3-1) OSP...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        ----------------------------------------------------------
        --3-2) OSP_L : Line Capa 대상
        -- 2020.02.03  [OSP Line Plan] OSP이면서 Line별 Capa 적용 Site 확정계획 추가
        ----------------------------------------------------------       
        INSERT INTO /* PR_SCP_ENG_EE_FN_PROC_FIXED_PLAN_PROD */ th_eng_fixed_plan_sn
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
                     , 'WO::OSP_L::' + CONVERT(NVARCHAR(10), 100000000 + ROW_NUMBER() OVER ( ORDER BY  YYYYMMDD )) AS work_order_id
                     , 1 AS work_order_seq
                     , a.scm_site_id + '~***' AS site_id
                     , b.route_id AS route_id  -- res의 route id
                     , b.route_id AS operation_id
                     , a.item_id
                     , b.resource_id AS resource_id -- , b.route_id + '::' + a.scm_site_id + '~***' + '::' + '-' AS resource_id
                     , NULL AS sub_resource_id

                     , a.yyyymmdd  AS start_dttm
                     , a.yyyymmdd  AS end_dttm  --, DATEADD(d, 1, a.yyyymmdd) AS end_dttm

                     , a.qty AS operation_qty
                     , a.qty AS complete_qty
                     , 'WO::OSP_L::' + CONVERT(NVARCHAR(10), 100000000 + ROW_NUMBER() OVER ( ORDER BY  YYYYMMDD )) AS lot_id
                     , 'N' AS is_fixed
                     , 'Y' AS is_prev_schedule
                     , 'START_FIX' AS keep_work_time_type
                     , 'ALL_QTY_FIX' AS keep_qty_type
                     , NULL AS sales_model_id
                     , NULL AS attribute_set_id
                     , NULL AS demand_id
                     , 'WO::OSP_L' AS descr
                     , 'Y' AS is_noh_consume
        
                FROM   ( SELECT * 
                         FROM   scp_anl_production_plan WITH (NOLOCK)  
                         WHERE  division_id         = @p_division_id    -- 'EE'
                         AND    plan_start_yyyymmdd = @p_plan_name 
                         AND    plan_type           = @p_pre_plan_type 
                         AND    seq                 = @p_pre_plan_seq 
                         AND    measure             = 'PROD_PLAN_AMEND'
                         AND    qty                 > 0
                        ) a     

                      INNER JOIN    (SELECT SUBSTRING(r.resource_group_id, dbo.FN_CHARINDEX_REV(r.resource_group_id, '::', 0)+2, 100) AS line_id
                                                    , r.*
                                    FROM   th_eng_resource_sn r WITH(NOLOCK)
                                    WHERE  r.master_id = @p_master_id
                                    AND    r.plan_id   = @p_engine_plan_id
                                    -- 외주 packer Line Capa 대상
                                    AND    r.descr     = 'OSP_L'
                                    ) b

                      ON     b.site_id   = a.scm_site_id + '~***'
                      AND    b.route_id  = a.operation_id
                      AND    b.line_id   = a.line_id
 
                      INNER JOIN   ( SELECT scm_site_id, fp_plan_period   
                                         ,  ISNULL(prod_frozen, 0) AS prod_frozen
                                     FROM   dbo.scm_mst_site_eng WITH (NOLOCK)  
                                     WHERE  modeling_id     = @p_modeling_id
                                     AND    plan_id         = @p_plan_id
                                     AND    plan_type       = @p_plan_type
                                     AND    plan_seq        = @p_seq 
                                     AND    division_id     = @p_division_id
                                     AND    eng_scm_site_id = scm_site_id + '~***' 
                                     AND    ISNULL(osp_yn, 'N')                 = 'Y'  --외주 packer  
                                     AND    DBO.FN_SCM_SYS_NVL(attribute1, 'N') = 'Y'  --외주 packer Line Capa 대상
                                   ) c 
                      ON    a.scm_site_id  = c.scm_site_id
                    
                      AND   a.yyyymmdd    >= @p_plan_name 
					  -- [전지 공급 대응력 향상을 위한 SCM 관리 체계 개선] 364인 경우와 아닌 경우 분리
                      --AND   a.yyyymmdd    <= CASE WHEN c.prod_frozen = 364 THEN @v_pet_date
					  AND   a.yyyymmdd    <= CASE WHEN c.prod_frozen = @v_plan_horizon THEN @v_pet_date		--2021.05.18 중장기 계획
                                                  ELSE CONVERT(NVARCHAR(8), DATEADD(DD, c.prod_frozen-1, @d_plan_name), 112) -- <= 조건이므로 (prod_frozen-1)처리
                                             END

			          -- 2018.06.01 ksg DISTINCT 처리
                      INNER JOIN   (SELECT DISTINCT SUBSTRING(bom.route_id, 1, 5) AS res_route_id
                                         , bom.site_id, bom.parent_item_id, bom.route_id
                                    FROM   th_eng_plan_bom_sn bom WITH (NOLOCK)
                                    WHERE  master_id = @p_master_id --'81::WEEKLY'
                                    AND    plan_id   = @p_engine_plan_id
                                   ) e

                      ON   a.scm_site_id + '~***'  = e.site_id 
                      AND  a.item_id               = e.parent_item_id  
                      AND  b.route_id              = e.route_id
                
                OPTION (HASH JOIN) --20190211 추가
        ;        

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id;
        SET @v_description = N'3-2) OSP_L...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
             
        END;        
		
        -------------------------------------------------------------
        --4. FIX 정보 공통적용 : [전지 공급 대응력 향상을 위한 SCM 관리 체계 개선] 전체 추가
        --   구간 : 플랜시작일+prod_frozen 이후,  참조테이블 : scp_anl_production_plan_fix
        -------------------------------------------------------------
        -------------------------------------------------------------
        -- 4-1)  Capa공정이면서 Line 모델링 비대상 - 참조 테이블 : scp_anl_production_plan_fix
        -------------------------------------------------------------
        INSERT INTO /*PR_SCP_ENG_EE_FN_PROC_FIXED_PLAN_PROD*/ th_eng_fixed_plan_sn
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
                     , 'WO::CAPA_CFM::' + a.fix_id  AS work_order_id -- , 'WO::CAPA_CFM::' + CONVERT(NVARCHAR(10), 400000 + ROW_NUMBER() OVER (ORDER BY a.item_id)) AS work_order_id  -- 임의의 중복되지 않는값을 사용하기 위해서 row_number() 처리 함 
                     , 1 AS work_order_seq
                     , a.scm_site_id + '~***' AS site_id
                     , b.route_id AS route_id  -- res의 route id
                     , b.route_id AS operation_id
                     , a.item_id
                     , b.resource_id AS resource_id
                     , NULL AS sub_resource_id
                     , a.yyyymmdd AS start_dttm
                     , a.yyyymmdd AS end_dttm
                     , a.qty AS operation_qty
                     , a.qty AS complete_qty
                     , 'WO::CAPA_CFM::' + a.fix_id AS lot_id --, 'WO::CAPA_FIX::' + CONVERT(NVARCHAR(10), 400000 + ROW_NUMBER() OVER (ORDER BY item_id)) AS lot_id
                     , 'N' AS is_fixed
                     , 'Y' AS is_prev_schedule
                     , 'START_FIX' AS keep_work_time_type
                     , 'ALL_QTY_FIX' AS keep_qty_type
                     , NULL AS sales_model_id
                     , NULL AS attribute_set_id
                     , NULL AS demand_id
                     , 'WO::CAPA_CFM' AS descr
                     , 'Y' AS is_noh_consume        
                 FROM scp_anl_production_plan_fix a WITH (NOLOCK)             
                -- Line Modeling 비대상
                INNER JOIN (SELECT SUBSTRING(r.resource_group_id, dbo.FN_CHARINDEX_REV(r.resource_group_id, '::', 0)+2, 100) AS line_id
                                    , r.*
							FROM th_eng_resource_sn r WITH(NOLOCK)
							WHERE r.master_id = @p_master_id
							AND r.plan_id   = @p_engine_plan_id
							-- SCP Capa 공정이면서 Line Modeling 비대상 공정 
							AND r.descr     = 'CAPA' 
						) b      
                      ON b.site_id   = a.scm_site_id + '~***'
                      AND    b.route_id  LIKE a.operation_id + '%'
                   -- AND    b.line_id   = a.line_id
                INNER JOIN   ( SELECT scm_site_id, ISNULL(fp_plan_period, 0) AS fp_plan_period
                                    ,  ISNULL(prod_frozen, 0) AS prod_frozen 
                                 FROM dbo.scm_mst_site_eng WITH (NOLOCK)  
                                WHERE modeling_id     = @p_modeling_id
                                  AND plan_id         = @p_plan_id
                                  AND plan_type       = @p_plan_type
                                  AND plan_seq        = @p_seq 
                                  AND division_id     = @p_division_id
                                  AND eng_scm_site_id = scm_site_id + '~***' 
                                  AND ISNULL(osp_yn, 'N') = 'N'   --외주 packer 아님 
                            ) c               
                    -- 364인 경우와 아닌 경우 분리
                    --ON a.yyyymmdd >= CASE WHEN c.prod_frozen = 364 THEN DATEADD(DD, 1, @v_pet_date)
					  ON a.yyyymmdd >= CASE WHEN c.prod_frozen = @v_plan_horizon THEN DATEADD(DD, 1, @v_pet_date)		--2021.05.18 중장기 계획
                                            ELSE CONVERT(NVARCHAR(8), DATEADD(DD, c.prod_frozen, @d_plan_name), 112)
                                        END            
                     AND a.yyyymmdd <= @v_pet_date        
                     AND a.scm_site_id = c.scm_site_id			
			         -- 2018.06.01 ksg DISTINCT 처리
                INNER JOIN (SELECT DISTINCT SUBSTRING(bom.route_id, 1, 5) AS res_route_id
                                 , bom.site_id, bom.parent_item_id, bom.route_id
                              FROM th_eng_plan_bom_sn bom WITH (NOLOCK)
                             WHERE master_id = @p_master_id --'81::WEEKLY'
                               AND plan_id   = @p_engine_plan_id
                            ) e			  
                      ON   a.scm_site_id + '~***'  = e.site_id 
                      AND  a.item_id               = e.parent_item_id  
                      AND  b.route_id              = e.route_id			   
                WHERE a.division_id = @p_division_id  --'81'    
                  AND a.qty    > 0 
				  /* TM버전은 FIX 데이터 미생성, 2021/05/26, By KKC */
				  AND 1= CASE WHEN @p_plan_type = 'TM' THEN 0
					          ELSE 1
						  END
        ; 

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id;
        SET @v_description = N'4-1) CAPA...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
        -------------------------------------------------------------
		-- 4-2)  Capa공정이면서 Line 모델링 대상 - 참조 테이블 : scp_anl_production_plan_fix
        -------------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_EE_FN_PROC_FIXED_PLAN_PROD */ th_eng_fixed_plan_sn
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
                       @p_master_id
                     , @p_engine_plan_id
                     , 'WO::LINE_CAPA_CFM::' + a.fix_id AS work_order_id  -- 임의의 중복되지 않는값을 사용하기 위해서 row_number() 처리 함  --, 'WO::LINE_CAPA::' + CONVERT(NVARCHAR(10), 500000 + ROW_NUMBER() OVER (ORDER BY item_id)) AS work_order_id  -- 임의의 중복되지 않는값을 사용하기 위해서 row_number() 처리 함 
                     , 1 AS work_order_seq
                     , a.scm_site_id + '~***' AS site_id
                     , e.route_id AS route_id   -- bom의 route id
                     , e.route_id AS operation_id
                     , a.item_id
                   --  , b.route_id + '::' + a.scm_site_id + '~***' + '::' + a.line_id AS resource_id -- res는 여러 Route에 동시에 사용 가능함
                     , b.resource_id AS resource_id
                     , NULL AS sub_resource_id
                     , a.yyyymmdd AS start_dttm
                     , a.yyyymmdd AS end_dttm
                     , a.qty AS operation_qty
                     , a.qty AS complete_qty
                     , 'WO::LINE_CAPA_CFM::' + a.fix_id  AS lot_id --, 'WO::LINE_CAPA_FIX::' + CONVERT(NVARCHAR(10), 500000 + ROW_NUMBER() OVER (ORDER BY item_id)) AS lot_id
                     , 'N' AS is_fixed
                     , 'Y' AS is_prev_schedule
                     , 'START_FIX' AS keep_work_time_type
                     , 'ALL_QTY_FIX' AS keep_qty_type
                     , NULL AS sales_model_id
                     , NULL AS attribute_set_id
                     , NULL AS demand_id
                     , 'WO::LINE_CAPA_CFM' AS descr
                     , 'Y' AS is_noh_consume        
                FROM   scp_anl_production_plan_fix a WITH (NOLOCK)      
                      INNER  JOIN  (SELECT SUBSTRING(r.resource_group_id, dbo.FN_CHARINDEX_REV(r.resource_group_id, '::', 0)+2, 100) AS line_id
                                                    , r.*
                                    FROM   th_eng_resource_sn r WITH(NOLOCK)
                                    WHERE  r.master_id = @p_master_id
                                    AND    r.plan_id   = @p_engine_plan_id
                                    -- SCP Capa 공정이면서 Line Modeling 대상 공정 
                                    AND    r.descr     = 'LINE_CAPA' 
                                   ) b
                      ON     b.site_id   = a.scm_site_id + '~***'
                      -- Line Modeling 대상
                      AND    b.route_id  = a.operation_id
                      AND    b.line_id   = a.line_id
                      INNER JOIN   ( SELECT scm_site_id, ISNULL(fp_plan_period, 0) AS fp_plan_period
                                         ,  ISNULL(prod_frozen, 0) AS prod_frozen
                                     FROM   dbo.scm_mst_site_eng WITH (NOLOCK)  
                                     WHERE  modeling_id     = @p_modeling_id
                                     AND    plan_id         = @p_plan_id
                                     AND    plan_type       = @p_plan_type
                                     AND    plan_seq        = @p_seq 
                                     AND    division_id     = @p_division_id
                                     AND    eng_scm_site_id = scm_site_id + '~***' 
                                     AND    ISNULL(osp_yn, 'N') = 'N'   --외주 packer 아님 
                                   ) c 
                      -- 364인 경우와 아닌 경우 분리
                      --ON     a.yyyymmdd    >= CASE WHEN c.prod_frozen = 364 THEN DATEADD(DD, 1, @v_pet_date)
					  ON   a.yyyymmdd    >= CASE WHEN c.prod_frozen = @v_plan_horizon THEN DATEADD(DD, 1, @v_pet_date)		--2021.05.18 중장기 계획
                                                   ELSE CONVERT(NVARCHAR(8), DATEADD(DD, c.prod_frozen, @d_plan_name), 112)
                                              END            
                      AND    a.yyyymmdd    <= @v_pet_date               
                      AND    a.scm_site_id  = c.scm_site_id			  
			          -- 2018.06.01 ksg DISTINCT 처리
                      INNER JOIN   (SELECT DISTINCT SUBSTRING(bom.route_id, 1, 5) AS res_route_id
                                         , bom.site_id, bom.parent_item_id, bom.route_id
                                    FROM   th_eng_plan_bom_sn bom WITH (NOLOCK)
                                    WHERE  master_id = @p_master_id --'81::WEEKLY'
                                    AND    plan_id   = @p_engine_plan_id
                                   ) e
                      ON    a.scm_site_id + '~***'  = e.site_id 
                      AND   a.item_id               = e.parent_item_id  
                      AND   b.route_id              = e.res_route_id             			   
               WHERE a.division_id = @p_division_id  --'81'    
                 AND a.qty    > 0
				 /* TM버전은 FIX 데이터 미생성, 2021/05/26, By KKC */
				 AND 1= CASE WHEN @p_plan_type = 'TM' THEN 0
					         ELSE 1
						 END
        ;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id;
        SET @v_description = N'4-2) LINE CAPA...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
        -------------------------------------------------------------
        -- 4-3)  OSP  - 참조 테이블 : scp_anl_production_plan_fix
        -------------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_EE_FN_PROC_FIXED_PLAN_PROD */ th_eng_fixed_plan_sn
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
                        , 'WO::OSP_CFM::' + a.fix_id AS work_order_id --, 'WO::OSP_FIX::' + CONVERT(NVARCHAR(10), 100000000 + ROW_NUMBER() OVER ( ORDER BY  a.yyyymmdd )) AS work_order_id
                        , 1 AS work_order_seq
                        , a.scm_site_id + '~***' AS site_id
                        , b.route_id AS route_id  -- res의 route id
                        , b.route_id AS operation_id
                        , a.item_id
                        , b.resource_id AS resource_id -- , b.route_id + '::' + a.scm_site_id + '~***' + '::' + '-' AS resource_id
                        , NULL AS sub_resource_id

                        , a.yyyymmdd  AS start_dttm
                        , a.yyyymmdd  AS end_dttm  --, DATEADD(d, 1, a.yyyymmdd) AS end_dttm

                        , a.qty AS operation_qty
                        , a.qty AS complete_qty
                        , 'WO::OSP_CFM::' + a.fix_id AS lot_id --, 'WO::OSP_FIX::' + CONVERT(NVARCHAR(10), 100000000 + ROW_NUMBER() OVER ( ORDER BY  a.yyyymmdd )) AS lot_id
                        , 'N' AS is_fixed
                        , 'Y' AS is_prev_schedule
                        , 'START_FIX' AS keep_work_time_type
                        , 'ALL_QTY_FIX' AS keep_qty_type
                        , NULL AS sales_model_id
                        , NULL AS attribute_set_id
                        , NULL AS demand_id
                        , 'WO::OSP_CFM' AS descr
                        , 'Y' AS is_noh_consume
        
                FROM   scp_anl_production_plan_fix a WITH (NOLOCK) -- PR_SCP_ENG_IN_PRE_PROC_BUCKET_RES_CAPA 의 work_time = 0 처리부분 수정해야함
                        INNER JOIN    (SELECT SUBSTRING(r.resource_group_id, dbo.FN_CHARINDEX_REV(r.resource_group_id, '::', 0)+2, 100) AS line_id
                                                    , r.*
                                    FROM   th_eng_resource_sn r WITH(NOLOCK)
                                    WHERE  r.master_id = @p_master_id
                                    AND    r.plan_id   = @p_engine_plan_id
                                    -- 외주 packer 
                                    AND    r.descr     = 'OSP'
                                    ) b
                        ON     b.site_id   = a.scm_site_id + '~***'
                        AND    b.route_id  LIKE a.operation_id + '%' -- AND    b.line_id   = a.line_id                          
                        INNER JOIN   (  SELECT scm_site_id, ISNULL(fp_plan_period, 0) AS fp_plan_period
                                            ,  ISNULL(prod_frozen, 0) AS prod_frozen 
                                        FROM   dbo.scm_mst_site_eng WITH (NOLOCK)  
                                        WHERE  1 =1
                                        AND    modeling_id     = @p_modeling_id
                                        AND    plan_id         = @p_plan_id
                                        AND    plan_type       = @p_plan_type
                                        AND    plan_seq        = @p_seq 
                                        AND    division_id     = @p_division_id
                                        AND    eng_scm_site_id = scm_site_id + '~***' 
                                        AND    ISNULL(osp_yn, 'N')                 = 'Y'  --외주 packer
                                        AND    DBO.FN_SCM_SYS_NVL(attribute1, 'N') = 'N'  --외주 packer Line Capa 비대상
                                    ) c 
                        -- 364인 경우와 아닌 경우 분리
                        --ON     a.yyyymmdd   >= CASE WHEN c.prod_frozen = 364 THEN DATEADD(DD, 1, @v_pet_date)
						ON   a.yyyymmdd    >= CASE WHEN c.prod_frozen = @v_plan_horizon THEN DATEADD(DD, 1, @v_pet_date)		--2021.05.18 중장기 계획
                                                    ELSE CONVERT(NVARCHAR(8), DATEADD(DD, c.prod_frozen, @d_plan_name), 112)
                                               END            
                        AND   a.yyyymmdd    <= @v_pet_date
                        AND   a.scm_site_id  = c.scm_site_id			  
		  	            -- 2018.06.01 ksg DISTINCT 처리
                        INNER JOIN   (SELECT DISTINCT SUBSTRING(bom.route_id, 1, 5) AS res_route_id
                                           , bom.site_id, bom.parent_item_id, bom.route_id
                                      FROM   th_eng_plan_bom_sn bom WITH (NOLOCK)
                                      WHERE  master_id = @p_master_id --'81::WEEKLY'
                                      AND    plan_id   = @p_engine_plan_id
                                     ) e
                        ON   a.scm_site_id + '~***'  = e.site_id 
                        AND  a.item_id               = e.parent_item_id  
                        AND  b.route_id              = e.route_id
              WHERE a.division_id = @p_division_id  --'81'    
                AND a.qty    > 0 
				/* TM버전은 FIX 데이터 미생성, 2021/05/26, By KKC */
				AND 1= CASE WHEN @p_plan_type = 'TM' THEN 0
					        ELSE 1
						END
        ;          

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id;
        SET @v_description = N'4-3) OSP...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
        -------------------------------------------------------------
        -- 4-4)  [OSP Line Plan] OSP_L Line Capa 대상  - 참조 테이블 : scp_anl_production_plan_fix
        -------------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_EE_FN_PROC_FIXED_PLAN_PROD */ th_eng_fixed_plan_sn
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
                        , 'WO::OSP_L_CFM::' + a.fix_id AS work_order_id --, 'WO::OSP_FIX::' + CONVERT(NVARCHAR(10), 100000000 + ROW_NUMBER() OVER ( ORDER BY  a.yyyymmdd )) AS work_order_id
                        , 1 AS work_order_seq
                        , a.scm_site_id + '~***' AS site_id
                        , b.route_id AS route_id  -- res의 route id
                        , b.route_id AS operation_id
                        , a.item_id
                        , b.resource_id AS resource_id -- , b.route_id + '::' + a.scm_site_id + '~***' + '::' + '-' AS resource_id
                        , NULL AS sub_resource_id

                        , a.yyyymmdd  AS start_dttm
                        , a.yyyymmdd  AS end_dttm  --, DATEADD(d, 1, a.yyyymmdd) AS end_dttm

                        , a.qty AS operation_qty
                        , a.qty AS complete_qty
                        , 'WO::OSP_L_CFM::' + a.fix_id AS lot_id --, 'WO::OSP_FIX::' + CONVERT(NVARCHAR(10), 100000000 + ROW_NUMBER() OVER ( ORDER BY  a.yyyymmdd )) AS lot_id
                        , 'N' AS is_fixed
                        , 'Y' AS is_prev_schedule
                        , 'START_FIX' AS keep_work_time_type
                        , 'ALL_QTY_FIX' AS keep_qty_type
                        , NULL AS sales_model_id
                        , NULL AS attribute_set_id
                        , NULL AS demand_id
                        , 'WO::OSP_L_CFM' AS descr
                        , 'Y' AS is_noh_consume        
                FROM   scp_anl_production_plan_fix a WITH (NOLOCK) -- PR_SCP_ENG_IN_PRE_PROC_BUCKET_RES_CAPA 의 work_time = 0 처리부분 수정해야함
                        INNER JOIN    (SELECT SUBSTRING(r.resource_group_id, dbo.FN_CHARINDEX_REV(r.resource_group_id, '::', 0)+2, 100) AS line_id
                                                    , r.*
                                    FROM   th_eng_resource_sn r WITH(NOLOCK)
                                    WHERE  r.master_id = @p_master_id
                                    AND    r.plan_id   = @p_engine_plan_id
                                    -- 외주 packer 
                                    AND    r.descr     = 'OSP_L'
                                    ) b
                        ON     b.site_id   = a.scm_site_id + '~***'
                        AND    b.route_id  = a.operation_id
                        AND    b.line_id   = a.line_id                          
                        INNER JOIN   (  SELECT scm_site_id, ISNULL(fp_plan_period, 0) AS fp_plan_period
                                            ,  ISNULL(prod_frozen, 0) AS prod_frozen 
                                        FROM   dbo.scm_mst_site_eng WITH (NOLOCK)  
                                        WHERE  1 =1
                                        AND    modeling_id     = @p_modeling_id
                                        AND    plan_id         = @p_plan_id
                                        AND    plan_type       = @p_plan_type
                                        AND    plan_seq        = @p_seq 
                                        AND    division_id     = @p_division_id
                                        AND    eng_scm_site_id = scm_site_id + '~***' 
                                        AND    ISNULL(osp_yn, 'N')                 = 'Y'  --외주 packer
                                        AND    DBO.FN_SCM_SYS_NVL(attribute1, 'N') = 'Y'  --외주 packer Line Capa 대상
                                    ) c 
                        -- 364인 경우와 아닌 경우 분리
                        --ON     a.yyyymmdd   >= CASE WHEN c.prod_frozen = 364 THEN DATEADD(DD, 1, @v_pet_date)
						ON   a.yyyymmdd    >= CASE WHEN c.prod_frozen = @v_plan_horizon THEN DATEADD(DD, 1, @v_pet_date)		--2021.05.18 중장기 계획
                                                    ELSE CONVERT(NVARCHAR(8), DATEADD(DD, c.prod_frozen, @d_plan_name), 112)
                                               END 
                        AND   a.yyyymmdd    <= @v_pet_date
                        AND   a.scm_site_id  = c.scm_site_id			  
		  	            -- 2018.06.01 ksg DISTINCT 처리
                        INNER JOIN   (SELECT DISTINCT SUBSTRING(bom.route_id, 1, 5) AS res_route_id
                                           , bom.site_id, bom.parent_item_id, bom.route_id
                                      FROM   th_eng_plan_bom_sn bom WITH (NOLOCK)
                                      WHERE  master_id = @p_master_id --'81::WEEKLY'
                                      AND    plan_id   = @p_engine_plan_id
                                     ) e
                        ON   a.scm_site_id + '~***'  = e.site_id 
                        AND  a.item_id               = e.parent_item_id  
                        AND  b.route_id              = e.route_id
              WHERE a.division_id = @p_division_id  --'81'    
                AND a.qty    > 0 
			    /* TM버전은 FIX 데이터 미생성, 2021/05/26, By KKC */
				AND 1= CASE WHEN @p_plan_type = 'TM' THEN 0
							ELSE 1
						END                
        ;          

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id;
        SET @v_description = N'4-4) OSP_L...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -------------------------------------------------------------
        --3. MA, SE, FN  공통적용 
        -------------------------------------------------------------        
        -------------------------------------------------------------    
        --3-1) operation_qty 값에 수율 적용
                -- [th_eng_fixed_plan_sn.operation_qty] 
                --     = [CEILING(th_eng_fixed_plan_sn.complete_qty / th_eng_op_res_group_map_sn.yield)]  올림값으로 셋팅
        -------------------------------------------------------------
        UPDATE th_eng_fixed_plan_sn 
        SET    operation_qty = ROUND(a.complete_qty / ISNULL(bb.yield, b.yield), 5)
        --SET    operation_qty = ROUND(a.complete_qty / b.yield, 5)               
        FROM   th_eng_fixed_plan_sn a
               INNER JOIN ( SELECT master_id
                                 , plan_id
                                 , item_id                                                                 
                                 , CASE WHEN yield = 0 THEN 1
                                        WHEN yield > 1 THEN 1
                                        ELSE ISNULL(yield, 1)
                                   END AS yield
                                 , resource_group_id
                            FROM  th_eng_op_res_group_map_sn WITH (NOLOCK)
                            WHERE  master_id = @p_master_id --'81::WEEKLY'
                            AND    plan_id   = @p_engine_plan_id --'1042::MA::1'   
                            --AND    descr     = 'LINE_CAPA'                       
                          ) b
               ON  a.master_id    = b.master_id 
               AND a.plan_id      = b.plan_id 
               AND a.item_id      = b.item_id 
               AND a.resource_id  = b.resource_group_id			   

               LEFT JOIN  ( SELECT master_id
                                 , plan_id
                                 , item_id
                                 , CASE WHEN yield = 0 THEN 1
                                        WHEN yield > 1 THEN 1
                                        ELSE ISNULL(yield, 1)
                                   END AS yield
                                 , resource_group_id
								 , start_dttm
								 , end_dttm
                            FROM  th_eng_op_res_group_map_cal_sn WITH (NOLOCK)
                            WHERE  master_id = @p_master_id      --'81::WEEKLY'
                            AND    plan_id   = @p_engine_plan_id --'1042::MA::1'   
                            --AND    descr     = 'LINE_CAPA'                       
                          ) bb
               ON  a.master_id    = bb.master_id 
               AND a.plan_id      = bb.plan_id 
               AND a.item_id      = bb.item_id 
               AND a.resource_id  = bb.resource_group_id
               AND a.end_dttm    >= bb.start_dttm
               AND a.end_dttm    <  bb.end_dttm
        WHERE  a.master_id = @p_master_id      --'81::WEEKLY'
        AND    a.plan_id   = @p_engine_plan_id -- '1042::MA::1'
        --AND    a.descr     = 'WO::LINE_CAPA'
        ;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'UPDATE '+@v_table_id;
        SET @v_description = N'Operation_qty...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------
       
        ----------------------------------------------------------
        -- * FIXED_PLAN 내 확정 W/O, D/O 의 WORKORDER_SEQ 생성 : 2018.06.07
		--   FIXED_PLAN 전체 생성뒤 마지막으로 처리함
        -- 2018.07.05   CELL Biz Fix용 가상 BOD 형성 : Fix Mismatching에서 처리하도록 수정함
        ----------------------------------------------------------
        
        --공통 사용 데이터 Cutoff 생성. 2024.10.07
        /*
        IF OBJECT_ID('tempdb..#tmp_scp_anl_production_plan') IS NOT NULL
        	BEGIN 
        		DROP TABLE  #tmp_scp_anl_production_plan;          
        	END 
        */

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id;
        SET @v_description = N'Process Complete...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
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
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    return 1

  END;
