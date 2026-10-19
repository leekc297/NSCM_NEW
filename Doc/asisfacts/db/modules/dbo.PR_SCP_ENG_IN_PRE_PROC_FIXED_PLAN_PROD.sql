
/*
 * Program ID   : PR_SCP_ENG_IN_PRE_PROC_FIXED_PLAN_PROD
 * Description  : 확정 생산 정보
				  
                  -----------------------------------------------------------
                  --1-1) 확정 생산 계획  정보 Insert : Capa공정이면서 Line 모델링 비대상
                  -----------------------------------------------------------

                  -----------------------------------------------------------
                  --1-2)  FIX 확정 생산 계획  정보 Insert : Capa공정이면서 Line 모델링 비대상
                  --      - FP_Plan_Load 이후 구간의 FIX 값  
                  -----------------------------------------------------------
        
                  -----------------------------------------------------------
                  --2-1) 확정 생산 계획  정보 Insert : Line 모델링 대상
                  -----------------------------------------------------------
                  
                  -----------------------------------------------------------
                  --2)-2) FIX 확정 생산 계획  정보 Insert : Line 모델링 대상
                  --      - FP_Plan_Load 이후 구간의 FIX 값  
                  -----------------------------------------------------------        

                  ----------------------------------------------------------
                  -- 3)-1) 외주 OSP (scp_anl_production_plan 테이블의 전주 최종 plan_type의 최종plan_seq)
				  --       20200813 [Packer Visivility] SCS 대상 제외
                  ----------------------------------------------------------
                  ----------------------------------------------------------
                  -- 3)-1-2) 외주 OSP : SCS (SCM_DNM_SCS_PROD_PLAN 테이블)
				  --       20200813 [Packer Visivility] SCS 대상 추가
                  ----------------------------------------------------------

                  ----------------------------------------------------------
                  -- 3)-2) FIX 외주 OSP
                  --      - FP_Plan_Load 이후 구간의 FIX 값
                  ----------------------------------------------------------      

                  ----------------------------------------------------------
                  -- 4)-1) 외주 OSP_L (scp_anl_production_plan 테이블의 전주 최종 plan_type의 최종plan_seq) 
				  --       20200813 [Packer Visivility] SCS 대상 제외
                  ----------------------------------------------------------
                  ----------------------------------------------------------
                  -- 4)-1-2) 외주 OSP_L : SCS (SCM_DNM_SCS_PROD_PLAN 테이블)
				  --       20200813 [Packer Visivility] SCS 대상 추가
                  ----------------------------------------------------------

                  ----------------------------------------------------------
                  -- 4)-2) FIX 외주 OSP_L 
                  --      - FP_Plan_Load 이후 구간의 FIX 값
                  ----------------------------------------------------------
        
                  ----------------------------------------------------------
                  --     참고)  FIX정보(scp_anl_production_plan_fix 테이블)가 있는 Line/구간은 Working Time 을 0 으로 설정 : Bucket Res Capa 
                  --            PR_SCP_ENG_EE_PRE_PROC_BUCKET_RES_CAPA 의 work_time = 0 처리부분 수정해야함    
                  ----------------------------------------------------------

 * OutTable     :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.02.22   김성기         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.05.23   김상완         FIX 확정 생산 계획  정보 Insert 추가
 * 2018.06.01   김성기         BOM 정보 처리 수정
 * 2018.06.08   김성기         Work Order Seq Update 반영
 * 2018.07.05   KSG            CELL Biz Fix용 가상 BOD 형성
 * 2018.12.19   KSW            @v_pre_plan_start_yyyymmdd, @v_pre_plan_id 변수값 수정(전주에 배치 미실행했을경우 때문에  전주 -> confirm_flag='Y'인 이전데이터중 가장최근이전주로 변경) (참고)주석3-1
 * 2020.02.06   KSG            [OSP Line Plan] OSP이면서 Line별 Capa 적용 Site 확정 계획 추가
 * 2020.08.13   KSG            [Packer Visivility] OSP : SCS 대상 여부에 따른 로직 분기
 * 2021.05.26   KKC            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 : TE계획 일 경우 FP구간 이후 FIX 데이터 미생성
 * 2021.09.03   KKC            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 : TE계획 일 경우 전구간 확정계획 적용 여부 옵션화
 * 2024.10.07   KKC            PJ20249346   LGES SCP 개선과제 이행 : 자동차 해외법인 통합FP 52주 Daily 생산/출하계획 동기화 & 튜닝
                               관련 소스 정리 및 KEY값 중복 보완 (WORK_ORDER_ID)
 * 2025.12.05   kimcd	       [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : 가상 라인에 연계된 라인의 경우 fix 계획 삭제
 */
CREATE PROCEDURE  [dbo].[PR_SCP_ENG_IN_PRE_PROC_FIXED_PLAN_PROD]
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_IN_PRE_PROC_FIXED_PLAN_PROD';
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
        ;
		---------------------------------------
        -- 지난 주 확정계획 대상 plan 정보 설정
		---------------------------------------
        DECLARE @v_pre_plan_start_yyyymmdd NVARCHAR(8);  --전주 plan_name
        DECLARE @v_pre_plan_type           NVARCHAR(50); --전주 최종 plan_type
        DECLARE @n_pre_plan_seq            INTEGER;      --전주 최종 plan_seq
        DECLARE @v_pre_plan_id             NVARCHAR(8);  --전주 plan_id
		
        --1) 지난 주 Plan 정보 조회 
        --전주에 배치 미실행했을 경우 때문에 @v_pre_plan_start_yyyymmdd  데이터가 존재하는 최근 주
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
				
        --2) 이전 주 Confirm된 Plan 정보 조회 
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
                                         , plan_seq DESC) AS rownumber
                FROM   scm_mst_plan_detail WITH (NOLOCK)
                WHERE  division_id  = @p_division_id
                AND    plan_id      = @v_pre_plan_id
                AND    confirm_flag = 'Y'
               ) a
        WHERE  rownumber = 1
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

       /* 2024.10.07 주석 추가
          [WORK ORDER ID] 생성 채번 규칙 정리 
           WO::CAPA::~ 400000
           WO::CAPA_CFM::+fix_id 
           WO::LINE_CAPA::~ 500000
           WO::CAPA_CFM::+fix_id 

           WO::OSP::+100000000
           WO::OSP_S::+100000000
           WO::OSP_CFM::+fix_id 
           WO::OSP_L::~ 100000000 : 4)-1) 외주 OSP_L
           WO::OSP_L::~ 100000000 : 4)-1-2) 외주 OSP_L : SCS (SCM_DNM_SCS_PROD_PLAN 테이블)
           -> 이거 중복이 발생 가능
              WO::OSPL_S::~ 100000000로 변경하자~
           WO::OSPL_CFM::+fix_id
       */            

        -----------------------------------------------------------
	    -- PR_SCP_ENG_IN_PRE_PROC_FIXED_PLAN 에서 Delete 처리함        
        -----------------------------------------------------------
        --1-1) 확정 생산 계획  정보 Insert : Capa공정이면서 Line 모델링 비대상
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_FIXED_PLAN_PROD */ th_eng_fixed_plan_sn
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
             , 'WO::CAPA::' + CONVERT(NVARCHAR(10), 400000 + ROW_NUMBER() OVER (ORDER BY item_id)) AS work_order_id  -- 임의의 중복되지 않는값을 사용하기 위해서 row_number() 처리 함 
             , 1 AS work_order_seq
             , a.scm_site_id + '~***' AS site_id
             , b.route_id AS route_id  -- res의 route id
             , b.route_id AS operation_id
             , a.item_id
             , b.resource_id AS resource_id
             , NULL AS sub_resource_id
             , a.plan_date AS start_dttm
             , a.plan_date AS end_dttm
             , a.plan_in_qty AS operation_qty
             , a.plan_qty AS complete_qty
             , 'WO::CAPA::' + CONVERT(NVARCHAR(10), 400000 + ROW_NUMBER() OVER (ORDER BY item_id)) AS lot_id
             , 'N' AS is_fixed
             , 'Y' AS is_prev_schedule
             , 'START_FIX' AS keep_work_time_type
             , 'ALL_QTY_FIX' AS keep_qty_type
             , NULL AS sales_model_id
             , NULL AS attribute_set_id
             , NULL AS demand_id
             , 'WO::CAPA' AS descr
             , 'Y' AS is_noh_consume        
        -- 20180502 테이블 수정 ( 매주 월요일 기준으로 데이터를 가져오기 위해서  scm_dnm_plan_frozen_v => scm_dnm_fp_release_prod_plan_c 로 변경함)
        -- FROM  dbo.scm_dnm_plan_frozen_v     a WITH(NOLOCK)
          FROM scm_dnm_fp_release_prod_plan_c a WITH(NOLOCK)             
          INNER JOIN    (SELECT SUBSTRING(r.resource_group_id, dbo.FN_CHARINDEX_REV(r.resource_group_id, '::', 0)+2, 100) AS line_id
                                          , r.*
                             FROM th_eng_resource_sn r WITH(NOLOCK)
                            WHERE r.master_id = @p_master_id
                              AND r.plan_id   = @p_engine_plan_id
                          -- SCP Capa 공정이면서 Line Modeling 비대상 공정 
                              AND r.descr     = 'CAPA' 
                          ) b      
            ON b.site_id   = a.scm_site_id + '~***'
           -- Line Modeling 비대상
           AND b.route_id  LIKE a.operation_id + '%'
        -- AND b.line_id   = a.line_id
         INNER JOIN   ( SELECT scm_site_id, fp_plan_period   
                        FROM   dbo.scm_mst_site_eng WITH (NOLOCK)  
                        WHERE  modeling_id     = @p_modeling_id
                        AND    plan_id         = @p_plan_id
                        AND    plan_type       = @p_plan_type
                        AND    plan_seq        = @p_seq 
                        AND    division_id     = @p_division_id
                        AND    eng_scm_site_id = scm_site_id + '~***' 
                        AND    ISNULL(osp_yn, 'N') = 'N'   --외주 packer 아님 
                      ) c 
            ON a.plan_date    >= @d_plan_name --20180228 수정( @v_cur_monday 를 @p_plan_name로 변경함, plan_cycle 이 Daily 일경우도 처리되게 하기위함) (변경전 : AND    a.plan_date           >= CONVERT(DATETIME, @v_cur_monday))
           AND a.plan_date    <  DATEADD(DD, ISNULL(c.fp_plan_period, 0), @d_plan_name)
           AND a.scm_site_id  = c.scm_site_id			  
		   -- 2018.06.01 ksg DISTINCT 처리
         INNER JOIN   (SELECT DISTINCT SUBSTRING(bom.route_id, 1, 5) AS res_route_id
                            , bom.site_id, bom.parent_item_id, bom.route_id
                       FROM   th_eng_plan_bom_sn bom WITH (NOLOCK)
                       WHERE  master_id = @p_master_id --'81::WEEKLY'
                       AND    plan_id   = @p_engine_plan_id
                      ) e			  
            ON a.scm_site_id + '~***'  = e.site_id 
           AND a.item_id               = e.parent_item_id  
           AND b.route_id              = e.route_id			   
         WHERE 1=1
           AND a.division_id = @p_division_id  --'81'    
           AND a.yyyymmdd    = @p_plan_name    -- 월요일 기준
           AND a.plan_qty    > 0        
           AND a.plan_in_qty > 0
        ;
		
        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id; 
        SET @v_description = N'1-1) 확정 생산 계획 : Line 모델링 비대상...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;     

        -----------------------------------------------------------
        --1-2)  FIX 확정 생산 계획  정보 Insert : Capa공정이면서 Line 모델링 비대상
        --      - FP_Plan_Load 이후 구간의 FIX 값  
        -----------------------------------------------------------        
        INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_FIXED_PLAN_PROD */ th_eng_fixed_plan_sn
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
        FROM  scp_anl_production_plan_fix a WITH (NOLOCK)             
        INNER JOIN (SELECT SUBSTRING(r.resource_group_id, dbo.FN_CHARINDEX_REV(r.resource_group_id, '::', 0)+2, 100) AS line_id                                            , r.*
                      FROM th_eng_resource_sn r WITH(NOLOCK)
                     WHERE r.master_id = @p_master_id
                       AND r.plan_id   = @p_engine_plan_id
                    -- SCP Capa 공정이면서 Line Modeling 비대상 공정 
                       AND r.descr     = 'CAPA' 
                    ) b      
                ON (b.site_id   = a.scm_site_id + '~***'
              -- Line Modeling 비대상
               AND b.route_id  LIKE a.operation_id + '%')
              -- AND    b.line_id   = a.line_id
              INNER JOIN   ( SELECT scm_site_id, fp_plan_period   
                               FROM dbo.scm_mst_site_eng WITH (NOLOCK)  
                              WHERE modeling_id     = @p_modeling_id
                                AND plan_id         = @p_plan_id
                                AND plan_type       = @p_plan_type
                                AND plan_seq        = @p_seq 
                                AND division_id     = @p_division_id
                                AND eng_scm_site_id = scm_site_id + '~***' 
                                AND ISNULL(osp_yn, 'N') = 'N'   --외주 packer 아님 
                           ) c               
               ON (a.yyyymmdd    >= CONVERT(NVARCHAR(8), DATEADD(DD, ISNULL(c.fp_plan_period, 0), @d_plan_name), 112)
              AND a.yyyymmdd    <= @v_pet_date
              AND a.scm_site_id  = c.scm_site_id)			  
			  -- 2018.06.01 ksg DISTINCT 처리
              INNER JOIN   (SELECT DISTINCT SUBSTRING(bom.route_id, 1, 5) AS res_route_id
                                 , bom.site_id, bom.parent_item_id, bom.route_id
                              FROM th_eng_plan_bom_sn bom WITH (NOLOCK)
                             WHERE master_id = @p_master_id --'81::WEEKLY'
                               AND plan_id   = @p_engine_plan_id
                           ) e			  
               ON  (a.scm_site_id + '~***'  = e.site_id 
              AND  a.item_id               = e.parent_item_id  
              AND  b.route_id              = e.route_id)			   
        WHERE a.division_id = @p_division_id  --'81'    
          AND a.qty    > 0 
		  /* TE버전은 FP 이후 FIX 데이터 미생성, 2021.05.26, By KKC */
		  AND 1= CASE WHEN @p_plan_type = 'TE' AND @v_te_only_fp_yn = 'Y' THEN 0
					  ELSE 1
				  END

		;
		
        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id; 
        SET @v_description = N'1-2)  FIX : Line 모델링 비대상...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
        --2-1) 확정 생산 계획  정보 Insert : Line 모델링 대상
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_FIXED_PLAN_PROD */ th_eng_fixed_plan_sn
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
             , 'WO::LINE_CAPA::' + CONVERT(NVARCHAR(10), 500000 + ROW_NUMBER() OVER (ORDER BY item_id)) AS work_order_id  -- 임의의 중복되지 않는값을 사용하기 위해서 row_number() 처리 함 
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
             , 'WO::LINE_CAPA::' + CONVERT(NVARCHAR(10), 500000 + ROW_NUMBER() OVER (ORDER BY item_id)) AS lot_id
             , 'N' AS is_fixed
             , 'Y' AS is_prev_schedule
             , 'START_FIX' AS keep_work_time_type
             , 'ALL_QTY_FIX' AS keep_qty_type
             , NULL AS sales_model_id
             , NULL AS attribute_set_id
             , NULL AS demand_id
             , 'WO::LINE_CAPA' AS descr
             , 'Y' AS is_noh_consume        
        -- 20180502 테이블 수정 ( 매주 월요일 기준으로 데이터를 가져오기 위해서  scm_dnm_plan_frozen_v => scm_dnm_fp_release_prod_plan_c 로 변경함)
        -- FROM  dbo.scm_dnm_plan_frozen_v     a WITH(NOLOCK)
          FROM scm_dnm_fp_release_prod_plan_c a WITH(NOLOCK)              
         INNER JOIN  (SELECT SUBSTRING(r.resource_group_id, dbo.FN_CHARINDEX_REV(r.resource_group_id, '::', 0)+2, 100) AS line_id
                                     , r.*
                     FROM   th_eng_resource_sn r WITH(NOLOCK)
                     WHERE  r.master_id = @p_master_id
                     AND    r.plan_id   = @p_engine_plan_id
                     -- SCP Capa 공정이면서 Line Modeling 대상 공정 
                     AND    r.descr     = 'LINE_CAPA' 
                    ) b
            ON b.site_id   = a.scm_site_id + '~***'
           -- Line Modeling 대상
           AND b.route_id  = a.operation_id
           AND b.line_id   = a.line_id
         INNER JOIN   ( SELECT scm_site_id, fp_plan_period   
                        FROM   dbo.scm_mst_site_eng WITH (NOLOCK)  
                        WHERE  modeling_id     = @p_modeling_id
                        AND    plan_id         = @p_plan_id
                        AND    plan_type       = @p_plan_type
                        AND    plan_seq        = @p_seq 
                        AND    division_id     = @p_division_id
                        AND    eng_scm_site_id = scm_site_id + '~***' 
                        AND    ISNULL(osp_yn, 'N') = 'N'   --외주 packer 아님 
                      ) c 
            ON a.plan_date     >= @d_plan_name --20180228 수정( @v_cur_monday 를 @p_plan_name로 변경함, plan_cycle 이 Daily 일경우도 처리되게 하기위함) (변경전 : AND    a.plan_date           >= CONVERT(DATETIME, @v_cur_monday))
           AND a.plan_date     <  DATEADD(DD, ISNULL(c.fp_plan_period, 0), @d_plan_name)
           AND a.scm_site_id   = c.scm_site_id 			  
			  -- 2018.06.01 ksg DISTINCT 처리
         INNER JOIN   (SELECT DISTINCT SUBSTRING(bom.route_id, 1, 5) AS res_route_id
                            , bom.site_id, bom.parent_item_id, bom.route_id
                       FROM   th_eng_plan_bom_sn bom WITH (NOLOCK)
                       WHERE  master_id = @p_master_id --'81::WEEKLY'
                       AND    plan_id   = @p_engine_plan_id
                      ) e
            ON a.scm_site_id + '~***'  = e.site_id 
           AND a.item_id               = e.parent_item_id  
           AND b.route_id              = e.res_route_id			   
         WHERE  1=1
           AND a.division_id = @p_division_id  --'81'    
           AND a.yyyymmdd    = @p_plan_name    -- 월요일기준
           AND a.plan_qty    > 0
           AND a.plan_in_qty > 0
        ;
		
        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id; 
        SET @v_description = N'2-1) 확정 생산 계획 : Line 모델링 대상...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
        --2)-2) FIX 확정 생산 계획  정보 Insert : Line 모델링 대상
        --      - FP_Plan_Load 이후 구간의 FIX 값  
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_FIXED_PLAN_PROD */ th_eng_fixed_plan_sn
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
         FROM  scp_anl_production_plan_fix a WITH (NOLOCK)      
        INNER JOIN (SELECT SUBSTRING(r.resource_group_id, dbo.FN_CHARINDEX_REV(r.resource_group_id, '::', 0)+2, 100) AS line_id                                            , r.*
                      FROM th_eng_resource_sn r WITH(NOLOCK)
                     WHERE r.master_id = @p_master_id
                       AND r.plan_id   = @p_engine_plan_id
                       -- SCP Capa 공정이면서 Line Modeling 대상 공정 
                       AND r.descr     = 'LINE_CAPA' 
                    ) b
           -- Line Modeling 대상
           ON (b.site_id   = a.scm_site_id + '~***'
          AND b.route_id  = a.operation_id
          AND b.line_id   = a.line_id)
        INNER JOIN  ( SELECT scm_site_id, fp_plan_period   
                        FROM dbo.scm_mst_site_eng WITH (NOLOCK)  
                       WHERE modeling_id     = @p_modeling_id
                         AND plan_id         = @p_plan_id
                         AND plan_type       = @p_plan_type
                         AND plan_seq        = @p_seq 
                         AND division_id     = @p_division_id
                         AND eng_scm_site_id = scm_site_id + '~***' 
                         AND ISNULL(osp_yn, 'N') = 'N'   --외주 packer 아님 
                    ) c 
           ON (a.yyyymmdd    >= CONVERT(NVARCHAR(8), DATEADD(DD, ISNULL(c.fp_plan_period, 0), @d_plan_name), 112)
          AND a.yyyymmdd    <= @v_pet_date
          AND a.scm_site_id  = c.scm_site_id)			  
		  -- 2018.06.01 ksg DISTINCT 처리
        INNER JOIN  (SELECT DISTINCT SUBSTRING(bom.route_id, 1, 5) AS res_route_id
                          , bom.site_id, bom.parent_item_id, bom.route_id
                       FROM th_eng_plan_bom_sn bom WITH (NOLOCK)
                      WHERE master_id = @p_master_id --'81::WEEKLY'
                        AND plan_id   = @p_engine_plan_id
                    ) e
          ON (a.scm_site_id + '~***'  = e.site_id 
         AND a.item_id               = e.parent_item_id  
         AND b.route_id              = e.res_route_id)
       WHERE a.division_id = @p_division_id  --'81'    
         AND a.qty    > 0 
         /* TE버전은 FP 이후 FIX 데이터 미생성, 2021.05.26, By KKC */
		 AND 1= CASE WHEN @p_plan_type = 'TE' AND @v_te_only_fp_yn = 'Y' THEN 0
				 	 ELSE 1
				 END		
		;
		
        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id; 
        SET @v_description = N'2)-2) FIX : Line 모델링 대상...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        ----------------------------------------------------------
        -- 3-1) 외주 packer  CAPA 처리
        ----------------------------------------------------------    
        ----------------------------------------------------------
        -- 3)-1) 외주 : OSP (scp_anl_production_plan 테이블의 전주 최종 plan_type의 최종plan_seq)
        --       20200813 [Packer Visivility] SCS 대상 제외
        ----------------------------------------------------------                     
        INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_FIXED_PLAN_PROD */ th_eng_fixed_plan_sn
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
                , 'WO::OSP::' + CONVERT(NVARCHAR(10), 100000000 + ROW_NUMBER() OVER ( ORDER BY  a.yyyymmdd )) AS work_order_id
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
                , 'WO::OSP::' + CONVERT(NVARCHAR(10), 100000000 + ROW_NUMBER() OVER ( ORDER BY  a.yyyymmdd )) AS lot_id
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
                    WHERE  division_id         = @p_division_id  
                    AND    plan_start_yyyymmdd = @v_pre_plan_start_yyyymmdd 
                    AND    plan_type           = @v_pre_plan_type 
                    AND    seq                 = @n_pre_plan_seq 
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
                          
                INNER JOIN   (  SELECT scm_site_id, fp_plan_period   
                                FROM   dbo.scm_mst_site_eng WITH (NOLOCK)  
                                WHERE  1 =1
                                AND    modeling_id     = @p_modeling_id
                                AND    plan_id         = @p_plan_id
                                AND    plan_type       = @p_plan_type
                                AND    plan_seq        = @p_seq 
                                AND    division_id     = @p_division_id
                                AND    eng_scm_site_id = scm_site_id + '~***' 
                                AND    ISNULL(osp_yn, 'N') = 'Y'   --외주 packer 
                                AND    DBO.FN_SCM_SYS_NVL(attribute1, 'N') = 'N'   --외주 packer Line Capa 비대상
                                AND    DBO.FN_SCM_SYS_NVL(attribute2, 'N') = 'N'   --20200813 [Packer Visivility] SCS 대상 제외
                            ) c 
                ON    a.scm_site_id  = c.scm_site_id
                AND   a.yyyymmdd    >= @p_plan_name 
                AND   a.yyyymmdd    <  CONVERT(NVARCHAR(8), DATEADD(DD, ISNULL(c.fp_plan_period, 0), @d_plan_name), 112)
			  
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
        ;
		
        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id; 
        SET @v_description = N'3)-1) 외주 : OSP...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        ----------------------------------------------------------
        -- 3)-1-2) 외주 OSP : SCS (SCM_DNM_SCS_PROD_PLAN 테이블)
        --       20200813 [Packer Visivility] SCS 대상 추가
        ----------------------------------------------------------          
        INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_FIXED_PLAN_PROD */ th_eng_fixed_plan_sn
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
                , 'WO::OSP_S::' + CONVERT(NVARCHAR(10), 100000000 + ROW_NUMBER() OVER ( ORDER BY  a.yyyymmdd )) AS work_order_id
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
                , 'WO::OSP_S::' + CONVERT(NVARCHAR(10), 100000000 + ROW_NUMBER() OVER ( ORDER BY  a.yyyymmdd )) AS lot_id
                , 'N' AS is_fixed
                , 'Y' AS is_prev_schedule
                , 'START_FIX' AS keep_work_time_type
                , 'ALL_QTY_FIX' AS keep_qty_type
                , NULL AS sales_model_id
                , NULL AS attribute_set_id
                , NULL AS demand_id
                , 'WO::OSP_S' AS descr
                , 'Y' AS is_noh_consume
        
        FROM   ( SELECT division_id
                      , scm_site_id
                      , SUBSTRING(scm_site_id, 1, 8) AS operation_id
                      , item_id
                      , prod_date AS yyyymmdd
                      --, line_id
                      , SUM(prod_qty) AS qty
                 FROM   scm_dnm_scs_prod_plan WITH (NOLOCK)  
                 WHERE  1=1
                 --AND    division_id = @p_division_id 
                 AND    cutoff_date = @p_plan_name  -- 월요일 기준
                 AND    prod_qty    > 0
                 GROUP BY division_id, scm_site_id, item_id, prod_date--, line_id
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
                          
                INNER JOIN   (  SELECT scm_site_id, fp_plan_period   
                                FROM   dbo.scm_mst_site_eng WITH (NOLOCK)  
                                WHERE  1 =1
                                AND    modeling_id     = @p_modeling_id
                                AND    plan_id         = @p_plan_id
                                AND    plan_type       = @p_plan_type
                                AND    plan_seq        = @p_seq 
                                AND    division_id     = @p_division_id
                                AND    eng_scm_site_id = scm_site_id + '~***' 
                                AND    ISNULL(osp_yn, 'N') = 'Y'   --외주 packer 
                                AND    DBO.FN_SCM_SYS_NVL(attribute1, 'N') = 'N'   --외주 packer Line Capa 비대상
                                AND    DBO.FN_SCM_SYS_NVL(attribute2, 'N') = 'Y'   --20200813 [Packer Visivility] SCS 대상 추가
                            ) c 
                ON    a.scm_site_id  = c.scm_site_id
                AND   a.yyyymmdd    >= @p_plan_name 
                AND   a.yyyymmdd    <  CONVERT(NVARCHAR(8), DATEADD(DD, ISNULL(c.fp_plan_period, 0), @d_plan_name), 112)
			  
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
        ;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id; 
        SET @v_description = N'3)-1-2) 외주 OSP : SCS...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        ----------------------------------------------------------
        -- 3)-2) FIX 외주 OSP
        --      - FP_Plan_Load 이후 구간의 FIX 값
        ----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_FIXED_PLAN_PROD */ th_eng_fixed_plan_sn
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
            FROM  scp_anl_production_plan_fix a WITH (NOLOCK) -- PR_SCP_ENG_IN_PRE_PROC_BUCKET_RES_CAPA 의 work_time = 0 처리부분 수정해야함
           INNER JOIN (SELECT SUBSTRING(r.resource_group_id, dbo.FN_CHARINDEX_REV(r.resource_group_id, '::', 0)+2, 100) AS line_id
                                    , r.*
                         FROM th_eng_resource_sn r WITH(NOLOCK)
                        WHERE r.master_id = @p_master_id
                          AND r.plan_id   = @p_engine_plan_id
                          -- 외주 packer 
                          AND r.descr     = 'OSP'
                      ) b
              ON (b.site_id   = a.scm_site_id + '~***'
             AND  b.route_id  LIKE a.operation_id + '%' 
		  -- AND    b.line_id   = a.line_id
		         )                          
            INNER JOIN   (SELECT scm_site_id, fp_plan_period   
                            FROM dbo.scm_mst_site_eng WITH (NOLOCK)  
                           WHERE 1 =1
                             AND modeling_id     = @p_modeling_id
                             AND plan_id         = @p_plan_id
                             AND plan_type       = @p_plan_type
                             AND plan_seq        = @p_seq 
                             AND division_id     = @p_division_id
                             AND eng_scm_site_id = scm_site_id + '~***' 
                             AND ISNULL(osp_yn, 'N') = 'Y'   --외주 packer 
                             AND DBO.FN_SCM_SYS_NVL(attribute1, 'N') = 'N'   --외주 packer Line Capa 비대상
                        ) c 
                ON (a.yyyymmdd     >= CONVERT(NVARCHAR(8), DATEADD(DD, ISNULL(c.fp_plan_period, 0), @d_plan_name), 112)
               AND a.yyyymmdd    <= @v_pet_date
               AND a.scm_site_id  = c.scm_site_id)			  
		  	-- 2018.06.01 ksg DISTINCT 처리
            INNER JOIN   (SELECT DISTINCT SUBSTRING(bom.route_id, 1, 5) AS res_route_id
                                , bom.site_id, bom.parent_item_id, bom.route_id
                            FROM   th_eng_plan_bom_sn bom WITH (NOLOCK)
                           WHERE  master_id = @p_master_id --'81::WEEKLY'
                            AND    plan_id   = @p_engine_plan_id
                          ) e                          
               ON (a.scm_site_id + '~***'  = e.site_id 
              AND a.item_id               = e.parent_item_id  
              AND b.route_id              = e.route_id)
            WHERE a.division_id = @p_division_id  --'81'    
              AND a.qty    > 0 
              /* TE버전은 FP 이후 FIX 데이터 미생성, 2021.05.26, By KKC */
              AND 1= CASE WHEN @p_plan_type = 'TE' AND @v_te_only_fp_yn = 'Y' THEN 0
					      ELSE 1
					  END        
		;
		
        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id; 
        SET @v_description = N'3)-2) FIX 외주 OSP...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        ----------------------------------------------------------
        -- 4)-1) 외주 OSP_L (scp_anl_production_plan 테이블의 전주 최종 plan_type의 최종plan_seq)
        -- 2020.02.03  [OSP Line Plan] OSP이면서 Line별 Capa 적용 Site 확정계획 추가
        --       20200813 [Packer Visivility] SCS 대상 제외
        ----------------------------------------------------------             
        INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_FIXED_PLAN_PROD */ th_eng_fixed_plan_sn
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
                , 'WO::OSP_L::' + CONVERT(NVARCHAR(10), 100000000 + ROW_NUMBER() OVER ( ORDER BY  a.yyyymmdd )) AS work_order_id
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
                , 'WO::OSP_L::' + CONVERT(NVARCHAR(10), 100000000 + ROW_NUMBER() OVER ( ORDER BY  a.yyyymmdd )) AS lot_id
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
                    WHERE  division_id         = @p_division_id  
                    AND    plan_start_yyyymmdd = @v_pre_plan_start_yyyymmdd 
                    AND    plan_type           = @v_pre_plan_type 
                    AND    seq                 = @n_pre_plan_seq 
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
                          
                INNER JOIN   (  SELECT scm_site_id, fp_plan_period   
                                FROM   dbo.scm_mst_site_eng WITH (NOLOCK)  
                                WHERE  1 =1
                                AND    modeling_id     = @p_modeling_id
                                AND    plan_id         = @p_plan_id
                                AND    plan_type       = @p_plan_type
                                AND    plan_seq        = @p_seq 
                                AND    division_id     = @p_division_id
                                AND    eng_scm_site_id = scm_site_id + '~***' 
                                AND    ISNULL(osp_yn, 'N') = 'Y'   --외주 packer 
                                AND    DBO.FN_SCM_SYS_NVL(attribute1, 'N') = 'Y'   --외주 packer Line Capa 대상
                                AND    DBO.FN_SCM_SYS_NVL(attribute2, 'N') = 'N'   --20200813 [Packer Visivility] SCS 대상 제외
                            ) c 
                ON    a.scm_site_id  = c.scm_site_id
                AND   a.yyyymmdd    >= @p_plan_name 
                AND   a.yyyymmdd    <  CONVERT(NVARCHAR(8), DATEADD(DD, ISNULL(c.fp_plan_period, 0), @d_plan_name), 112)
			  
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
        ;
		
        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id; 
        SET @v_description = N'4)-1) 외주 OSP_L...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
        ----------------------------------------------------------
        -- 4)-1-2) 외주 OSP_L : SCS (SCM_DNM_SCS_PROD_PLAN 테이블)
        --       20200813 [Packer Visivility] SCS 대상 추가
        ----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_FIXED_PLAN_PROD */ th_eng_fixed_plan_sn
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
                /* WORK ORDER ID 중복 발생 가능으로 변경, 2024.10.07
                   WO::OSP_L::~ 100000000 : 4)-1) 외주 OSP_L
                   WO::OSP_L::~ 200000000 : 4)-1-2) 외주 OSP_L : SCS (SCM_DNM_SCS_PROD_PLAN 테이블)
                */
                , 'WO::OSP_L::' + CONVERT(NVARCHAR(10), 200000000 + ROW_NUMBER() OVER ( ORDER BY  a.yyyymmdd )) AS work_order_id
                --, 'WO::OSP_L::' + CONVERT(NVARCHAR(10), 100000000 + ROW_NUMBER() OVER ( ORDER BY  a.yyyymmdd )) AS work_order_id
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
                , 'WO::OSP_L::' + CONVERT(NVARCHAR(10), 200000000 + ROW_NUMBER() OVER ( ORDER BY  a.yyyymmdd )) AS lot_id
                , 'N' AS is_fixed
                , 'Y' AS is_prev_schedule
                , 'START_FIX' AS keep_work_time_type
                , 'ALL_QTY_FIX' AS keep_qty_type
                , NULL AS sales_model_id
                , NULL AS attribute_set_id
                , NULL AS demand_id
                , 'WO::OSP_L' AS descr
                , 'Y' AS is_noh_consume        
        FROM   ( SELECT division_id
                      , scm_site_id
                      , SUBSTRING(scm_site_id, 1, 8) AS operation_id
                      , item_id
                      , line_id
                      , prod_date AS yyyymmdd
                      , SUM(prod_qty) AS qty
                 FROM   scm_dnm_scs_prod_plan WITH (NOLOCK)  
                 WHERE  1=1
                 --AND    division_id = @p_division_id 
                 AND    cutoff_date = @p_plan_name -- 월요일 기준
                 AND    prod_qty    > 0
                 GROUP BY division_id, scm_site_id, item_id, line_id, prod_date
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
                          
                INNER JOIN   (  SELECT scm_site_id, fp_plan_period   
                                FROM   dbo.scm_mst_site_eng WITH (NOLOCK)  
                                WHERE  1 =1
                                AND    modeling_id     = @p_modeling_id
                                AND    plan_id         = @p_plan_id
                                AND    plan_type       = @p_plan_type
                                AND    plan_seq        = @p_seq 
                                AND    division_id     = @p_division_id
                                AND    eng_scm_site_id = scm_site_id + '~***' 
                                AND    ISNULL(osp_yn, 'N') = 'Y'   --외주 packer 
                                AND    DBO.FN_SCM_SYS_NVL(attribute1, 'N') = 'Y'   --외주 packer Line Capa 대상
                                AND    DBO.FN_SCM_SYS_NVL(attribute2, 'N') = 'Y'   --20200813 [Packer Visivility] SCS 대상 추가
                            ) c 
                ON    a.scm_site_id  = c.scm_site_id
                AND   a.yyyymmdd    >= @p_plan_name 
                AND   a.yyyymmdd    <  CONVERT(NVARCHAR(8), DATEADD(DD, ISNULL(c.fp_plan_period, 0), @d_plan_name), 112)
			  
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
        ;
		
        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id; 
        SET @v_description = N'4)-1-2) 외주 OSP_L : SCS...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
        ----------------------------------------------------------
        -- 4)-2) FIX 외주 OSP_L
        --      - FP_Plan_Load 이후 구간의 FIX 값
        -- 2020.02.03  [OSP Line Plan] OSP이면서 Line별 Capa 적용 Site 확정계획 추가
        ----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_FIXED_PLAN_PROD */ th_eng_fixed_plan_sn
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
        INNER JOIN (SELECT SUBSTRING(r.resource_group_id, dbo.FN_CHARINDEX_REV(r.resource_group_id, '::', 0)+2, 100) AS line_id
                         , r.*
                      FROM th_eng_resource_sn r WITH(NOLOCK)
                     WHERE r.master_id = @p_master_id
                       AND r.plan_id   = @p_engine_plan_id
                       -- 외주 packer Line Capa 대상
                       AND r.descr     = 'OSP_L'
                    ) b
          ON (b.site_id   = a.scm_site_id + '~***'
         AND b.route_id  = a.operation_id
         AND b.line_id   = a.line_id)                          
        INNER JOIN   ( SELECT scm_site_id, fp_plan_period   
                         FROM dbo.scm_mst_site_eng WITH (NOLOCK)  
                        WHERE 1 =1
                          AND modeling_id     = @p_modeling_id
                          AND plan_id         = @p_plan_id
                          AND plan_type       = @p_plan_type
                          AND plan_seq        = @p_seq 
                          AND division_id     = @p_division_id
                          AND eng_scm_site_id = scm_site_id + '~***' 
                          AND ISNULL(osp_yn, 'N') = 'Y'   --외주 packer 
                          AND DBO.FN_SCM_SYS_NVL(attribute1, 'N') = 'Y'   --외주 packer Line Capa 대상
                    ) c 
         ON (a.yyyymmdd    >= CONVERT(NVARCHAR(8), DATEADD(DD, ISNULL(c.fp_plan_period, 0), @d_plan_name), 112)
        AND a.yyyymmdd    <= @v_pet_date
        AND a.scm_site_id  = c.scm_site_id)			  
		-- 2018.06.01 ksg DISTINCT 처리
        INNER JOIN   (SELECT DISTINCT SUBSTRING(bom.route_id, 1, 5) AS res_route_id
                            , bom.site_id, bom.parent_item_id, bom.route_id
                        FROM th_eng_plan_bom_sn bom WITH (NOLOCK)
                       WHERE master_id = @p_master_id --'81::WEEKLY'
                         AND plan_id   = @p_engine_plan_id
                        ) e                          
         ON (a.scm_site_id + '~***'  = e.site_id 
        AND a.item_id               = e.parent_item_id  
        AND b.route_id              = e.route_id)
       WHERE a.division_id = @p_division_id  --'81'    
         AND a.qty    > 0 
         /* TE버전은 FP 이후 FIX 데이터 미생성, 2021.05.26, By KKC */
		 AND 1= CASE WHEN @p_plan_type = 'TE' AND @v_te_only_fp_yn = 'Y' THEN 0
				 	 ELSE 1
				 END
		;
		
        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id; 
        SET @v_description = N'4)-2) FIX 외주 OSP_L...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        ----------------------------------------------------------
        --     참고)  FIX정보(scp_anl_production_plan_fix 테이블)가 있는 Line/구간은 Working Time 을 0 으로 설정 : Bucket Res Capa 
        --            PR_SCP_ENG_EE_PRE_PROC_BUCKET_RES_CAPA 의 work_time = 0 처리부분 수정해야함    
        ----------------------------------------------------------  

        ---------------------------------------------------------------------------------------------------------------------------
        --5) 2025.12.05   kimcd	[PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : 가상 라인에 연계된 라인의 경우 fix 계획 삭제 시작
		--                                   계획이 ESS 가상 라인에서만 유지되도록 함
        ---------------------------------------------------------------------------------------------------------------------------
        DELETE    EFP
 		FROM      TH_ENG_FIXED_PLAN_SN EFP
				  INNER JOIN (SELECT CASE WHEN SUBSTRING(LN.OPERATION_ID, 1, 1) = 'A' THEN LN.PLANT_ID + '-A~***'
										  WHEN SUBSTRING(LN.OPERATION_ID, 1, 1) = 'P' THEN LN.PLANT_ID + '-P~***'
									 END  AS ENG_SCM_SITE_ID
								   , LN.OPERATION_ID
								   , LN.LINE_ID
								   , LN.OPERATION_ID + '::' + 
									 CASE WHEN SUBSTRING(LN.OPERATION_ID, 1, 1) = 'A' THEN LN.PLANT_ID + '-A~***'
										  WHEN SUBSTRING(LN.OPERATION_ID, 1, 1) = 'P' THEN LN.PLANT_ID + '-P~***'
									 END    + '::' + 
									 LN.LINE_ID AS RESOURCE_ID
							  FROM   DBO.SCM_MST_LINE_SN             LN  WITH(NOLOCK)
									 INNER JOIN DBO.SCM_MST_LINE_SN  LLN WITH(NOLOCK)
										 ON  LN.OPERATION_ID    = LLN.OPERATION_ID    
										 AND ln.LINE_ID         = LLN.LINK_LINE_ID
										 AND LN.ELECTRODE_TYPE  = LLN.ELECTRODE_TYPE
										 AND LLN.VIRTUAL_LINE_YN = 'Y'
										 AND LLN.ACTIVE_FLAG    = 'Y'
							  WHERE  LN.DIVISION_ID = @p_division_id
							  AND    LN.ACTIVE_FLAG = 'Y'
							  -- Capa 대상 + Line Modeling 대상 공정
							  AND    LN.OPERATION_ID IN ( 
														SELECT DISTINCT b.segment4
														FROM   scm_adm_lookup_master_detail a WITH(NOLOCK)
														INNER JOIN scm_adm_lookup_master_detail b WITH(NOLOCK)
														ON  a.segment1    = b.segment1
														AND a.lookup_type = 'LOCATION_GROUP'
														AND a.segment4    = 'Y' -- Capa 공정 여부 
														AND a.segment5    = 'Y' -- Line 별 Capa 적용 공정( Capa공정여부가 'N'이면  Line 별 Capa 적용 공정이 'Y'가 될수없음)
														AND a.valid_yn    = 'Y'
														AND b.lookup_type = 'LOCATION_GROUP_ROUTE'
														AND b.valid_yn    = 'Y'
														AND b.segment3    = 'Y' -- Capa 세부 공정 여부 
														)

							) LN
                  ON   EFP.SITE_ID = LN.ENG_SCM_SITE_ID
				  AND  EFP.ROUTE_ID = LN.OPERATION_ID
				  AND  EFP.RESOURCE_ID = LN.RESOURCE_ID
        WHERE  EFP.MASTER_ID = @p_master_id      
        AND    EFP.PLAN_ID   = @p_engine_plan_id 
        ;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'DELETE '+@v_table_id;
        SET @v_description = N'link virtual line plan...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ---------------------------------------------------------------------------------------------------------------------------
        --5) 2025.12.05   kimcd	[PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : 가상 라인에 연계된 라인의 경우 fix 계획 삭제 종료
		--                                   계획이 ESS 가상 라인에서만 유지되도록 함
        ---------------------------------------------------------------------------------------------------------------------------
        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------
       
        ----------------------------------------------------------
        -- * FIXED_PLAN 내 확정 W/O, D/O 의 WORKORDER_SEQ 생성 : 2018.06.07
		--   FIXED_PLAN 전체 생성뒤 마지막으로 처리함
        -- 2018.07.05   CELL Biz Fix용 가상 BOD 형성 : Fix Mismatching에서 처리하도록 수정함
        ----------------------------------------------------------
        
		SKIP1:

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

