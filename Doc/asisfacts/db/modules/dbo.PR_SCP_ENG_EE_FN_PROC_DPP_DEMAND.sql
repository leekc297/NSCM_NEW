
/*
 * Program ID   : PR_SCP_ENG_EE_FN_PROC_DPP_DEMAND
 * Description  : 
                  ----------------------------------------------------------------------------
                  1. TH_ENG_DEMAND 최종생성 
                  ----------------------------------------------------------------------------
                  -------------------------------------------------
                  --1-1. Demand Grouping
                  -------------------------------------------------   
                     --20180326 수정
                     1) priority_group_code : '그룹핑시작일자::cell_site_id' 형식
                                             -참고1) 그룹핑 시작일자 : 해당 그룹핑의 시작일자( ex1) 그룹핑기준일 3일 이라면,  그룹핑시작일: '20180319' , demand의 shipping_date: 20180320, cell_site_id : 'A040-A'  ==> '20180319::A040-A' )
                                                                                             ( ex2) 그룹핑기준일 3일 이라면,  그룹핑시작일: '20180319' , demand의 shipping_date: 20180323, cell_site_id : 'A040-A'  ==> '20180322::A040-A' )
                                             -참고2) cell_site_id    : 해당 ITEM이 'P' 일때 BOM 상의 셀(여러개 존재시 임의의1개선택) 의 plant site id값
                                                                       해당 ITEM이 'E', 'A' 일때 demand의 plant site id값  

                     2) shipping_date : demend의 shipping_date 
                     3) Due Fence Date : Groupung이 아닌 각각의 Demand 기준으로 처리함
                     
                     
                     4) Priority :   (1) 그룹핑시작일자(fast shipping_date, 위1)의 [그룹핑 시작일자] 값) + '::'   ( 참고: priority_group_code의 cell_site_id 제외한값)
                                   + (2) SetupGroupID 평균 setup time 제일작은순으 numbering (5 자리)
                                   
                                   + (3) fast_due_date (가장 빠른 due_date GROUP BY ISNULL(cell_item_id, item), 그룹핑시작일자(shipping_date기준) ) --20181203 추가
                                   
                                   + (4) SetupGroupID (SetupGroupID 값은 cell_item_id 값으로 대체됨) 가 다른데 동일한 평균setup time 일때 numbering (5자리, (setup group id, cell_item_id, demand item순으로 numbering)) 
                                   + (5) 영업우선순위(10자리)
                                   + (6) Shipping Date(8자리) => Due_date로 변경
                                   + (7) qty (100000000 - qty, 보통8자리됨)   참고) qty 가 큰순으로 조회되게 하기위해서 100000000 - qty 값으로 셋팅되어있음, proiority가 오름차순으로 정렬되면 결과값이 작은게 먼저 조회되므로) 
                                   + (8) NUMBERING ( SetupGroupID 평균setuptime, 영업우선순위, shipping_date , qty DESC)
                      
                      -- 20181203 변경전
                      4) Priority :   (1) 그룹핑시작일자(fast shipping_date, 위1)의 [그룹핑 시작일자] 값) + '::'   ( 참고: priority_group_code의 cell_site_id 제외한값)
                                   + (2) SetupGroupID 평균 setup time 제일작은순으 numbering (5 자리)
                                   + (3) SetupGroupID (SetupGroupID 값은 cell_item_id 값으로 대체됨) 가 다른데 동일한 평균setup time 일때 numbering (5자리, (setup group id, cell_item_id, demand item순으로 numbering)) 
                                   + (4) 영업우선순위(10자리)
                                   + (5) Shipping Date(8자리) => Due_date로 변경
                                   + (6) qty (100000000 - qty, 보통8자리됨)   참고) qty 가 큰순으로 조회되게 하기위해서 100000000 - qty 값으로 셋팅되어있음, proiority가 오름차순으로 정렬되면 결과값이 작은게 먼저 조회되므로) 
                                   + (7) NUMBERING ( SetupGroupID 평균setuptime, 영업우선순위, shipping_date , qty DESC)
                     
                  
                  --------------------------------------------------------------------------
                  2. (DPP DEMAND)TH_ENG_NET_DEMAND 생성 
                  --------------------------------------------------------------------------
                  -----------------------------------------------------------
                  --2-1. 대상 demand 정보를 임시테이블에 INSERT
                  ----------------------------------------------------------- 
                    
                  -----------------------------------------------------------
                  --2-2-1. split 비대상 demand 정보를 INSERT
                  ----------------------------------------------------------- 
                    - 전극아닐때 split 비대상
                    

                  -----------------------------------------------------------
                  --2-2-2. split 대상 demand 정보를 INSERT
                  -----------------------------------------------------------
                    - 전극 일때 split 대상
                      ==> th_eng_demand_sn.max_daily_capa 수량으로 split (값이 없을경우 default : 10000개 수량으로 split) 

 * OutTable     :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.01.26   KSW         Initial Release  전지본부 GSCM(DM/SCP) 구축 프로젝트
 * 2018.06.21   KSG         MA/SE/FN : priority_group_code 적용 안 함 / priority 는 DM의 demand_priority 사용
 *                            => 06.29 ksg 반영 보류로 원복
 * 2018.08.08   KSW         기존 PR DEMAND, NET_DEMAND 데이터 복사 -> DEMAND, NET_DEMAND 데이터 신규생성으로 변경 ( scp_pln_elec_demand_cell_plan 테이블이 plan_type별로 데이터가 변경될수 있으므로 )
 * 2018.08.24   KSG         priority : 영업우선순위 다음 Shipping Date 를 Due Date 로 변경
 * 2018.09.07   KSW         셀하위 전극 및 전극 split 관련수정
 * 2018.12.03   KSW         자동차(81), ESS(82) demand우선순위수정(fast_due_date 추가) (참고)주석1)
 * 2019.03.05   KSW         [재료본부 전지재료 GSCM 구축 프로젝트] 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가 (전지재료('44') 사업부추가로 인한 조건추가) 
 * 2019.06.26   KSG         전극은 Demand Grouping 제거
 * 2020.04.27   KSG         C20200403-000046 전극SCP 시뮬레이터 內 조립계획 I/F 기준 변경
 *                              : PR 이 아닌 경우 PR의 정보를 Copy하여 생성함
 *                              : Copy하지 않도록 하는 경우 PR_SCP_PLN_ELEC_DEMAND_CELL_PLAN 함께 수정 필요
 * 2020.07.14   KSG         [전지 공급 대응력 향상을 위한 SCM 관리 체계 개선] 전극 Main Plan 추가 및 Engine Run 기준 설정
 *                              : MA - Copy하지 않고 재처리 : 조립계획은 ELEC_DEMAND_CELL_PLAN 에서 PR외는 PR 정보 Copy하여 생성하므로 동일함
 *                                FN - MA 정보 Copy하여 사용
 * 2021.05.26   KKC         PJ20209642 Digital SCM Level.3 달성을 위한 개선 : DEMAND SPLIT 옵션화
 * 2021.07.21   KKC         PJ20209642 Digital SCM Level.3 달성을 위한 개선 : DEMAND QTY < 1 데이터 소숫점 처리(계획수립시 무한루프 방지) 및 BUSINESS_TYPE 추가
 * 2023.03.07   SHS         PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행: DEMAND SPLIT 옵션 추가
 *
 */

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_EE_FN_PROC_DPP_DEMAND]
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_EE_FN_PROC_DPP_DEMAND';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'TH_ENG_NET_DEMAND'; 
    DECLARE @d_event_date   DATETIME;

    DECLARE @n_pre_plan_id       INTEGER = 0;
    DECLARE @n_cur_plan_id       INTEGER = 0;
    DECLARE @n_pre_week_plan_id  INTEGER = 0;
    DECLARE @n_cur_week_plan_id  INTEGER = 0;
    
    DECLARE @n_split_count       NUMERIC(20,10) = 1.0; -- demand split count

    --DECLARE @v_division_id       NVARCHAR(30);
    --DECLARE @v_cur_monday        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    --DECLARE @v_demand_cutoff_day NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -6, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 화요일 YYYYMMDD
    DECLARE @v_pet_date          NVARCHAR(8) ; -- Plan End Date
    DECLARE @d_plan_name         DATETIME;

    -- DEMAND 그룹핑 기본값 (scp_mst_final_item.demand_grouping_days( demand 그룹핑 일수)  값이 NULL경우 사용함)
    DECLARE @n_demand_grouping_default_days INT = 1;--그룹핑 기준일자 기본값 : 20190626 전극은 Demand Grouping 제거 28 -> 1 로 처리

    DECLARE @default_daily_capa  NUMERIC(5) = 10000;   -- 20180717 추가 daily_capa 값이 없을경우 기본값

	DECLARE @v_split_yn          NVARCHAR(1);  --2021/05/26 추가, By KKC

	/* DEMAND SPLIT 변수 추가,. 2023.03.07 */
	DECLARE @v_pack_capa_apply_yn NVARCHAR(30) = 'N';
	DECLARE @v_default_split_qty NUMERIC(5);
	DECLARE @v_to_daily_capa_apply DATETIME;
	DECLARE @v_weekly_capa_working_day NUMERIC(5);


    -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN	  

	  	-----------------------------------------------------------
		-- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선
		-- Split 여부 옵션화, 2021/05/26, By KKC
        -----------------------------------------------------------
		/*
		SELECT @v_split_yn = ISNULL(a.segment2, 'N')   
		  FROM scm_adm_lookup_master_detail a(nolock)
		 WHERE a.lookup_type = 'DEMAND_DAILY_CAPA_SPLIT_YN'
		   AND a.SEGMENT1 = @p_division_id
		;
		*/
		
		-- 2023.03.07 DEMAND SPLIT APPLY ( DEMAND SPLIT OPTION ) 
		SELECT	@v_split_yn                = a.split_yn 							   -- DEMAND SPLIT 여부
			  , @v_default_split_qty       = ISNULL(a.default_split_qty,10000)	       -- DEFAULT SPLIT 수량
			  , @v_pack_capa_apply_yn      = ISNULL(a.pack_capa_apply_yn, 'N')		   -- PACK CAPA 적용 여부
			  , @v_to_daily_capa_apply     = DATEADD(WEEK,  ISNULL(a.daily_capa_apply_week,0), CONVERT(DATE, @p_plan_name))  
																					   -- 일 CAPA 적용구간(~To Period)
  			  , @v_weekly_capa_working_day =ISNULL(a.weekly_capa_working_day,0)	       -- 주간 WORKING DAY
		FROM	
				(
				 SELECT	b.segment1                 AS division_id 
					  , CONVERT(INT, b.segment2)   AS default_split_qty
					  , b.segment3                 AS pack_capa_apply_yn
					  , CONVERT(INT, b.segment4)   AS daily_capa_apply_week
					  , CONVERT(INT, b.segment5)   AS weekly_capa_working_day
					  , b.valid_yn                 AS split_yn	
				  FROM	scm_adm_lookup_master a WITH(NOLOCK) 	
				  JOIN	scm_adm_lookup_master_detail b WITH(NOLOCK)	
					ON	a.lookup_type = b.lookup_type	
				 WHERE	a.lookup_type = 'SCP_ENG_DEMAND_SPLIT'
				   AND	b.valid_yn = 'Y'
				) a
		WHERE a.division_id = @p_division_id
		;

		--Split여부 변수 Validation Check
		IF @v_split_yn IS NULL OR @v_split_yn != 'N'
		   BEGIN
		       SET @v_split_yn = 'Y';
		   END

		-------------------------------------------------------------------------------------
		-- [전지 공급 대응력 향상을 위한 SCM 관리 체계 개선] : FN이면 이전 Plan 정보 Copy
		-------------------------------------------------------------------------------------
		IF @p_plan_type = 'FN'
		BEGIN

			DELETE /* PR_SCP_ENG_EE_FN_PROC_DPP_DEMAND */
			FROM   th_eng_demand_sn 
			WHERE  master_id = @p_master_id 
			AND    plan_id   = @p_engine_plan_id 
			;
       
			DELETE /* PR_SCP_ENG_EE_FN_PROC_DPP_DEMAND */
			FROM   th_eng_net_demand_sn 
			WHERE  master_id = @p_master_id 
			AND    plan_id   = @p_engine_plan_id 
			;

			-----------------------------------------------------------
			-- th_eng_demand_sn
			-----------------------------------------------------------
			INSERT INTO /* PR_SCP_ENG_EE_FN_PROC_DPP_DEMAND */ th_eng_demand_sn 
			( master_id
			, plan_id
			, demand_id
			, sales_model_id
			, shipping_date
			, due_date
			, due_fence_date
			, early_producing_term
			, early_producing_term_uom
			, qty
			, split_qty
			, order_type
			, demand_type
			, producing_type
			, priority_group_code
			, priority
			, attribute_checker_id
			, demand_group_id
			, late_type
			, descr
			, move_time_rate
			, buffer_time_rate
			, is_exception
			, item
			, site
			, scm_site
		
			, project_code
			, plant_site_id 
			, org_cell_site_id
			, org_elec_site_id
			, avg_setup_time 
			, cell_site_setup_group_id 
			, cell_site_id
			, cell_item_id 
			, max_daily_capa
			, demand_priority  -- 2018.06.21 추가   
			, division_id      -- 20180627 추가
			)
		   SELECT @p_master_id          AS master_id
				, @p_engine_plan_id     AS plan_id
				, demand_id
				, sales_model_id
				, shipping_date
				, due_date
				, due_fence_date
				, early_producing_term
				, early_producing_term_uom
				, qty
				, split_qty
				, order_type
				, demand_type
				, producing_type
				, priority_group_code
				, priority
				, attribute_checker_id
				, demand_group_id
				, late_type
				, descr
				, move_time_rate
				, buffer_time_rate
				, is_exception
				, item
				, site
				, scm_site
		        
				, project_code
				, plant_site_id 
				, org_cell_site_id
				, org_elec_site_id
				, avg_setup_time 
				, cell_site_setup_group_id 
				, cell_site_id
				, cell_item_id 
				, max_daily_capa
				, demand_priority  -- 2018.06.21 추가   
				, division_id      -- 20180627 추가
			FROM  th_eng_demand_sn WITH (NOLOCK)
			WHERE  master_id = @p_master_id
			AND    plan_id   = @p_pre_engine_plan_id
			;
		
			-----------------------------------------------------------
			-- th_eng_net_demand_sn
			-----------------------------------------------------------
			INSERT INTO /* PR_SCP_ENG_EE_FN_PROC_DPP_DEMAND */ th_eng_net_demand_sn 
			(   master_id
			  , plan_id
			  , demand_id
			  , sales_model_id
			  , shipping_date
			  , due_date
			  , due_fence_date
			  , early_producing_term
			  , early_producing_term_uom
			  , qty
			  , split_qty
			  , order_type
			  , demand_type
			  , producing_type
			  , priority_group_code
			  , priority
			  , attribute_checker_id
			  , demand_group_id
			  , late_type
			  , descr
			  , move_time_rate
			  , buffer_time_rate
			  , is_exception
			  , is_consume
			  , item
			  , site
			  , scm_site          
			  , demand_priority -- 2018.06.21 추가
			  , project_code    -- 20210122 추가
			  , business_type   -- 20210721 추가
			  , attr01          -- 2023.03.07 추가    
			  , attr02          -- 2023.03.07 추가    
			  , attr03          -- 2023.03.07 추가    
			  , attr04          -- 2023.03.07 추가    
			  , attr05          -- 2023.03.07 추가    
			)
		   SELECT @p_master_id          AS master_id
				, @p_engine_plan_id     AS plan_id
				, demand_id
				, sales_model_id
				, shipping_date
				, due_date
				, due_fence_date
				, early_producing_term
				, early_producing_term_uom
				, qty
				, split_qty
				, order_type
				, demand_type
				, producing_type
				, priority_group_code
				, priority
				, attribute_checker_id
				, demand_group_id
				, late_type
				, descr
				, move_time_rate
				, buffer_time_rate
				, is_exception
				, is_consume
				, item
				, site
				, scm_site
				, demand_priority -- 20180621 추가
				, project_code    -- 20210122 추가
				, business_type   -- 20210721 추가(business type : default = ALL)
				, attr01          -- 2023.03.07 추가    
				, attr02          -- 2023.03.07 추가    
				, attr03          -- 2023.03.07 추가    
				, attr04          -- 2023.03.07 추가    
				, attr05          -- 2023.03.07 추가    
			FROM  th_eng_net_demand_sn WITH (NOLOCK)
			WHERE  master_id = @p_master_id
			AND    plan_id   = @p_pre_engine_plan_id
			;

			SET @n_log_count = @@ROWCOUNT;

		END; --IF @p_plan_type = 'FN' THEN   

		-------------------------------------------------------------------------------------
		-- [전지 공급 대응력 향상을 위한 SCM 관리 체계 개선] : MA 이면 재처리
		-------------------------------------------------------------------------------------
		IF @p_plan_type = 'MA' or @p_plan_type = 'SE' -- 20250918 YMH 임시추가
		BEGIN
	
			SELECT @v_pet_date = p.horizon_end_date
			FROM   dbo.scm_mst_plan p WITH(NOLOCK)
			WHERE  p.division_id = @p_division_id 
			AND    p.plan_id     = @p_plan_id ;

			-----------------------------------------------------------
			-- th_eng_demand_sn 삭제는 PR_SCP_ENG_EE_FN_PROC_DEMAND_ATTRIBUTE 에서 처리함
			-----------------------------------------------------------
        
			-----------------------------------------------------------
			-- 1) NET_DEMAND 최종 정보 UPDATE : 20190626 전극은 Demand Grouping 제거
			--    - 1) priority_group_code 컬럼 업데이트
			--    - 2) priority  컬럼 업데이트

			--    - 참고) Demand 정보 최초생성은 PR_SCP_ENG_EE_FN_PROC_DEMAND_ATTRIBUTE 에서 처리함 

					/*
					-참고1) 그룹핑 시작일자 : 해당 그룹핑의 시작일자( ex1) 그룹핑기준일 3일 이라면,  그룹핑시작일: '20180319' , demand의 shipping_date: 20180320, cell_site_id : 'A040-A'  ==> '20180319::A040-A' )
																	( ex2) 그룹핑기준일 3일 이라면,  그룹핑시작일: '20180319' , demand의 shipping_date: 20180323, cell_site_id : 'A040-A'  ==> '20180322::A040-A' )

					Priority :   (1) 그룹핑시작일자(fast shipping_date, 위 참고1)의 [그룹핑 시작일자] 값) + '::'   ( 참고: priority_group_code의 cell_site_id 제외한값)
								+ (2) SetupGroupID 평균 setup time 제일작은순으 numbering (5 자리)
                                   
								+ (3) fast_due_date (가장 빠른 due_date GROUP BY ISNULL(cell_item_id, item), 그룹핑시작일자(shipping_date기준) ) --20181203추가
                                   
								+ (4) SetupGroupID (SetupGroupID 값은 cell_item_id 값으로 대체됨) 가 다른데 동일한 평균setup time 일때 numbering (5자리, (setup group id, cell_item_id, demand item순으로 numbering)) 
								+ (5) 영업우선순위(10자리)
								+ (6) Shipping Date(8자리) => Due_date로 변경
								+ (7) qty (100000000 - qty, 보통8자리됨)   참고) qty 가 큰순으로 조회되게 하기위해서 100000000 - qty 값으로 셋팅되어있음, proiority가 오름차순으로 정렬되면 결과값이 작은게 먼저 조회되므로) 
								+ (8) NUMBERING ( SetupGroupID 평균setuptime, 영업우선순위, shipping_date , qty DESC)
					*/  
			-----------------------------------------------------------
			 UPDATE   th_eng_demand_sn 
				SET   priority_group_code = y.priority_group_code
				   ,  priority =  y.priority
				   ,  early_producing_term = y.early_producing_term --20180618 추가
				FROM  th_eng_demand_sn x WITH (NOLOCK)
					  INNER JOIN (
									SELECT   a.demand_id
										   , a.early_producing_term
										   , a.priority_group_code_grouping_start_date  + '::' + a.priority_group_code_site_id AS priority_group_code
                                       
										   ,    a.priority_group_code_grouping_start_date --순위1) 그룹핑시작일자(shipping_date 기준) (8자리)
											  + '::'
											  + a.avg_setup_time_numbering              --순위2) avg_setup_time 순위(5자리)
											  + a.fast_due_date                         --순위3)fast_due_date(가장 빠른 due_date GROUP BY ISNULL(cell_item_id, item), 그룹핑시작일자(shipping_date기준)) (8자리) --20181203추가
											  + dbo.FN_ZERO_LPAD( dense_rank() OVER (PARTITION BY a.priority_group_code_grouping_start_date, a.avg_setup_time_numbering, a.fast_due_date ORDER BY ISNULL( a.cell_site_setup_group_id, a.cell_item_id), a.item  ) 
																, 5)                    --순위4)setup group id 가 다른데 동일한 평균setup time 일때 numbering (5자리)
											  + dbo.FN_ZERO_LPAD(ISNULL(a.demand_priority, 1), 10)           --순위5) 영업우선순위( dm_pln_net_demand 에 있는 priority 값) (10자리)
											  + CONVERT(NVARCHAR(10), a.due_date , 112)                      --순위6) due_date(자리) -- 2018.08.24  Shipping Date 를 Due Date 로 변경 (변경전 : + CONVERT(NVARCHAR(10), a.shipping_date , 112) )
											  + CONVERT(NVARCHAR(10), 100000000- CONVERT(NUMERIC(10),a.qty)) --순위7) ty (100000000 - qty, 보통8자리됨)
											  + dbo.FN_ZERO_LPAD(CONVERT(NVARCHAR(5)
																 ,ROW_NUMBER() OVER (PARTITION BY a.priority_group_code_grouping_start_date --그룹핑시작일자(shipping_date 기준) (8자리)
																								 , a.avg_setup_time_numbering
																								 , a.fast_due_date --(가장 빠른 due_date GROUP BY ISNULL(cell_item_id, item), 그룹핑시작일자(shpping_date기준) ) (8자리) --20181203추가
																								 , a.demand_priority
																								 , a.due_date      -- 2018.08.24  Shipping Date 를 Due Date 로 변경
																								 , a.qty

																					  ORDER BY  a.priority_group_code_grouping_start_date --그룹핑시작일자(shipping_date 기준) (8자리)
																							  , a.avg_setup_time_numbering
																							  , a.fast_due_date --(가장 빠른 due_date GROUP BY ISNULL(cell_item_id, item), 그룹핑시작일자(shpping_date기준) ) (8자리) --20181203추가
																							  , a.demand_priority
																							  , a.due_date      -- 2018.08.24  Shipping Date 를 Due Date 로 변경
																							  , a.qty DESC)
																					 )
																, 5)  --순위8) 위 1)~7)동일할 경우 대비 Numbering(5자리)
											 AS priority
										FROM    (SELECT aa.demand_id
													 ,  aa.shipping_date  
													 ,  aa.due_date
													 ,  aa.cell_site_id
													 ,  aa.item
													 ,  aa.plant_site_id
													 ,  aa.avg_setup_time
													 ,  aa.cell_site_setup_group_id
													 ,  aa.cell_item_id
													 ,  aa.demand_priority
													 --,  a.priority
													 ,  aa.qty

													 ,  CONVERT(NVARCHAR(10),
															DATEADD(d, ROUND(
																		   (  DATEDIFF(  d
																					   , CONVERT(DATETIME,@p_plan_name)
																					   , CONVERT(DATETIME, aa.shipping_date)
																					   ) / @n_demand_grouping_default_days
																			) --DATEDIFF종료
																   , 0, 1) --ROUND종료
																   * @n_demand_grouping_default_days
																   , CONVERT(DATETIME,@p_plan_name)
														   ) --DATEADD종료
													  , 112) --CONVERT 종료  --그룹핑시작일자(shipping_date 기준) (8자리)
														AS priority_group_code_grouping_start_date --그룹핑시작일자

													 , ISNULL(aa.cell_site_id, aa.plant_site_id) AS priority_group_code_site_id --'그룹핑시작일자::cell_site_id' 형태에 사용될 cell_site_id값
                                                 
                                                 
													 , CONVERT(NVARCHAR(8), MIN(aa.due_date) OVER (PARTITION BY ISNULL(aa.cell_item_id, aa.item)
																										   , CONVERT(NVARCHAR(10),
																																   DATEADD(d, ROUND(
																																					(  DATEDIFF(  d
																																								, CONVERT(DATETIME,@p_plan_name)
																																								, CONVERT(DATETIME, aa.shipping_date)
																																							   ) / @n_demand_grouping_default_days
																																					) --DATEDIFF종료
																																				   , 0, 1) --ROUND종료
																																			  * @n_demand_grouping_default_days
																																			, CONVERT(DATETIME,@p_plan_name)
																																		  ) --DATEADD종료
																															, 112)--CONVERT종료
																							   ) --OVER종료
															, 112) --첫번째 CONVERT종료 
													   AS fast_due_date  --fast_due_date (가장 빠른 due_date GROUP BY ISNULL(a.cell_item_id, a.item), 그룹핑시작일자) (8자리)
                                                 

													 , DATEDIFF( d, CONVERT(DATETIME,@p_plan_name), aa.shipping_date) % @n_demand_grouping_default_days AS early_producing_term --20180522 수정 (변경전 : , DATEDIFF( d, CONVERT(DATETIME,@p_plan_name), CONVERT(DATE, a.yyyymmdd)) % @n_demand_term AS early_producing_term)
                                                 
													 , dbo.FN_ZERO_LPAD( DENSE_RANK() OVER (ORDER BY CASE WHEN aa.avg_setup_time IS NULL THEN  999999999  
																			   ELSE aa.avg_setup_time 
																		   END)  
																, 5) AS avg_setup_time_numbering

												 FROM   th_eng_demand_sn aa WITH (NOLOCK)
												 WHERE  aa.master_id = @p_master_id
												 AND    aa.plan_id   = @p_engine_plan_id 
										)a               
								 ) y
					  ON x.demand_id = y.demand_id  

				WHERE  x.master_id = @p_master_id 
				AND    x.plan_id   = @p_engine_plan_id 
			 ;
			 
			-- 20190626 : 전극은 Demand Grouping 제거

			-----------------------------------------------------------
			--2. DPP_DEMAND
			-----------------------------------------------------------
			DELETE /* PR_SCP_ENG_EE_FN_PROC_DPP_DEMAND */
			FROM   th_eng_net_demand_sn 
			WHERE  master_id = @p_master_id 
			AND    plan_id   = @p_engine_plan_id 
			;
        
			-----------------------------------------------------------
			--2-1. 대상 demand 데이터 임시테이블로 생성
			-----------------------------------------------------------
			IF OBJECT_ID('tempdb..#th_eng_demand') IS NOT NULL 
			 BEGIN
				DROP TABLE #th_eng_demand
			 END

			SELECT master_id
			 , plan_id 
			 , demand_id 
			 , sales_model_id
			 , shipping_date
			 , due_date
			 , due_fence_date
			 , early_producing_term
			 , early_producing_term_uom
			 , qty
			 , split_qty
			 , order_type
			 , demand_type
			 , producing_type
			 , priority_group_code
			 , priority
			 , attribute_checker_id
			 , demand_group_id
			 , late_type
			 , descr
			 , move_time_rate
			 , buffer_time_rate
			 , is_exception
			 , is_consume
			 , item
			 , site
			 , scm_site
			 , project_code                 
			 , plant_site_id
			 , org_cell_site_id
			 , org_elec_site_id         
			 , avg_setup_time
			 , cell_site_setup_group_id
			 , cell_site_id
			 , cell_item_id         
			 , ISNULL(max_daily_capa, @default_daily_capa) AS max_daily_capa         
			 , demand_priority  -- 20180621 추가(DM의 우선순위)     
			 , division_id         
			 , ceiling(qty/ISNULL(max_daily_capa, @default_daily_capa)) AS max_div_count  -- split 개수           
			INTO  #th_eng_demand
			FROM  th_eng_demand_sn WITH (NOLOCK)
			WHERE master_id = @p_master_id --'81::WEEKLY'
			AND   plan_id   = @p_engine_plan_id --'1034::PR::6'
			;

			-----------------------------------------------------------
			--2-2-1. split 비대상 demand 정보 INSERT
			-----------------------------------------------------------
		   INSERT INTO /* PR_SCP_ENG_EE_FN_PROC_DPP_DEMAND */ th_eng_net_demand_sn 
			( master_id
			, plan_id
			, demand_id
			, sales_model_id
			, shipping_date
			, due_date
			, due_fence_date
			, early_producing_term
			, early_producing_term_uom
			, qty
			, split_qty
			, order_type
			, demand_type
			, producing_type
			, priority_group_code
			, priority
			, attribute_checker_id
			, demand_group_id
			, late_type
			, descr
			, move_time_rate
			, buffer_time_rate
			, is_exception
			, is_consume
			, item
			, site
			, scm_site
			, demand_priority -- 20180621 추가   
			, project_code    -- 20210122 추가   
			, business_type   -- 20210721 추가
			, attr05          -- 2023.03.07 end_split_qty 추가  
			)
			SELECT master_id
				 , plan_id
				 , demand_id
				 , sales_model_id
				 --20180514 수정 yyyymmdd => yyyymmdd 23::59::59 변경
				 --, shipping_date
				 --, due_date
				 --, due_fence_date
				 , DATEADD(ss,86399, CONVERT(DATETIME, shipping_date))  AS shipping_date
				 , DATEADD(ss,86399, CONVERT(DATETIME, due_date))       AS due_date
				 , DATEADD(ss,86399, CONVERT(DATETIME, due_fence_date)) AS due_fence_date             
				 , early_producing_term
				 , early_producing_term_uom
				 , qty
				 , qty
				 , order_type
				 , demand_type
				 , producing_type
				 , priority_group_code
				 , priority
				 , attribute_checker_id
				 , demand_group_id
				 , late_type
				 , descr
				 , move_time_rate
				 , buffer_time_rate
				 , is_exception
				 , is_consume
				 , item
				 , site
				 , scm_site           
				 , demand_priority -- 20180621 추가   
				 , project_code    -- 20210122 추가   
				 , 'ALL'           -- 20210721 추가 Default = ALL
				   -- 2023.03.07	DEMAND SPLIT APPLY
				 , CASE	WHEN @v_split_yn = 'N'      THEN  qty
						WHEN max_daily_capa IS NULL THEN  qty
						WHEN max_daily_capa = 0     THEN  qty					
						ELSE 
							CASE WHEN due_date < @v_to_daily_capa_apply THEN max_daily_capa
								 ELSE max_daily_capa * @v_weekly_capa_working_day
							END
					END AS split_qty	             
			FROM   #th_eng_demand a
--			WHERE  ISNULL(dbo.fn_scm_split(dbo.fn_scm_split(priority_group_code, 2, '::'), 2, '-'), 'N') <> 'E' --전극이 아닐때
			/* 2023.03.07 Engine Custom Split으로 주석처리
			/* Split 여부 옵션화, 2021/05/26, By KKC */
			/(
			WHERE  1 = CASE WHEN @v_split_yn = 'N' THEN 1
							ELSE 
								 CASE WHEN ISNULL(dbo.fn_scm_split(dbo.fn_scm_split(priority_group_code, 2, '::'), 2, '-'), 'N') <> 'E' THEN 1
									  ELSE 0
								   END
						END
			*/
			;
		
			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = 'INSERT INTO '+@v_table_id; 
			SET @v_description = N'split 비대상...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        
			/***********************************************************
			   --2023.03.07 
			   DEMAND SPLIT DATA 생성 로직 주석 처리 Start ~
			 : Engine Custom에서 SPLIT_QTY 기준으로 SPLIT하는 로직 구현 
			-----------------------------------------------------------
			-- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선
			-- Split 여부 옵션화, 2021/05/26, By KKC
			-----------------------------------------------------------
			IF @v_split_yn = 'N'
			BEGIN
				  GOTO SKIP1;
			END

			-----------------------------------------------------------
			--2-2-2. split 대상(셀('A')만 대상임) demand 정보를 split INSERT        
			-----------------------------------------------------------

			-----------------------------------------------------------
			--2-2-2-1. copy_t 임시 테이블 생성
			-----------------------------------------------------------
			IF OBJECT_ID('tempdb..#copy_t') IS NOT NULL 
			 BEGIN
				DROP TABLE #copy_t
			 END
         

			DECLARE @max_div_count NUMERIC(5)
			SELECT @max_div_count = MAX(ceiling(qty/ISNULL(max_daily_capa, @default_daily_capa)))
			FROM   #th_eng_demand
			WHERE  dbo.fn_scm_split(dbo.fn_scm_split(priority_group_code, 2, '::'), 2, '-') = 'E' --전극일때 
			;

			-- 1 ~ @max_div_count 값이 들어간 임시테이블 생성
			;WITH copy_t AS (
			   SELECT 1 no 
			   UNION ALL
			   SELECT no + 1
			   FROM   copy_t 
			   WHERE  no < @max_div_count --1000 이면  1000번까지 생성됨
			)
			SELECT * 
			INTO  #copy_t
			FROM copy_t OPTION (MAXRECURSION 32767)
			;
        
			-----------------------------------------------------------
			--2-2-2-2) split 대상 demand 정보를 임시테이블로 생성
				 -- split 대상 : 팩(BOM 상의 선호 셀로 처리)/셀 
			-----------------------------------------------------------
			INSERT INTO /* PR_SCP_ENG_EE_FN_PROC_DPP_DEMAND */ th_eng_net_demand_sn
			( master_id
			, plan_id
			, demand_id
			, sales_model_id
			, shipping_date
			, due_date
			, due_fence_date
			, early_producing_term
			, early_producing_term_uom
			, qty
			, split_qty
			, order_type
			, demand_type
			, producing_type
			, priority_group_code
			, priority
			, attribute_checker_id
			, demand_group_id
			, late_type
			, descr
			, move_time_rate
			, buffer_time_rate
			, is_exception
			, is_consume
			, item
			, site
			, scm_site  
			, demand_priority -- 20180621 추가    
			, project_code    -- 20210122 추가    
			, business_type   -- 20210721 추가
			)
			SELECT a.master_id
				,  a.plan_id
				,  CASE WHEN a.max_div_count <> 1 THEN a.demand_id + '^S_' + CONVERT(NVARCHAR(10), b.no)
						ELSE a.demand_id 
				   END  AS demand_id
                        
				,  a.sales_model_id

				--20180514 수정 yyyymmdd => yyyymmdd 23::59::59 변경
				--, a.shipping_date
				--, a.due_date
				--, a.due_fence_date

				, DATEADD(ss,86399, CONVERT(DATETIME, a.shipping_date))  AS shipping_date
				, DATEADD(ss,86399, CONVERT(DATETIME, a.due_date))       AS due_date
				, DATEADD(ss,86399, CONVERT(DATETIME, a.due_fence_date)) AS due_fence_date

				, a.early_producing_term
				, a.early_producing_term_uom
            
				, CASE WHEN a.max_div_count <> b.no  THEN a.max_daily_capa --a.qty  --AND a.qty <= a.max_daily_capa 
					   WHEN a.max_div_count = b.no   THEN IIF(a.qty % a.max_daily_capa = 0, a.max_daily_capa, a.qty % a.max_daily_capa)
				  END  AS qty
            
				, CASE WHEN a.max_div_count <> b.no  THEN a.max_daily_capa --a.qty  --AND a.qty <= a.max_daily_capa 
					   WHEN a.max_div_count = b.no   THEN IIF(a.qty % a.max_daily_capa = 0, a.max_daily_capa, a.qty % a.max_daily_capa)
				  END  AS split_qty

				, a.order_type
				, a.demand_type
				, a.producing_type
				, a.priority_group_code
				, a.priority + dbo.FN_ZERO_LPAD( b.no, 5) AS priority

				, a.attribute_checker_id
				, a.demand_group_id
				, a.late_type
				, a.descr
				, a.move_time_rate
				, a.buffer_time_rate
				, a.is_exception
				, a.is_consume
				, a.item
				, a.site
				, a.scm_site
				, a.demand_priority -- 20180621 추가       
				, a.project_code    -- 20210122 추가   
				 , 'ALL'            -- 20210721 추가 Default = ALL        
			FROM  (SELECT master_id
						, plan_id 
						, demand_id 
						, sales_model_id
						, shipping_date
						, due_date
						, due_fence_date
						, early_producing_term
						, early_producing_term_uom
						, qty
						, split_qty
						, order_type
						, demand_type
						, producing_type
						, priority_group_code
						, priority
						, attribute_checker_id
						, demand_group_id
						, late_type
						, descr
						, move_time_rate
						, buffer_time_rate
						, is_exception
						, is_consume
						, item
						, site
						, scm_site

						, project_code
                 
						, plant_site_id
						, org_cell_site_id
						, org_elec_site_id
         
						, avg_setup_time
						, cell_site_setup_group_id

						, cell_site_id
						, cell_item_id
         
						, max_daily_capa
         
						, demand_priority  -- 20180621 추가(DM의 우선순위)     
						, division_id
         
						, max_div_count  -- split 개수

					FROM   #th_eng_demand
					WHERE  dbo.fn_scm_split(dbo.fn_scm_split(priority_group_code, 2, '::'), 2, '-') = 'E' --전극일때
				  ) a
			   ,  #copy_t b
			WHERE  b.no <= a.max_div_count 
			;
		
			-- TXN LOG
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'TXN';
			SET @v_log_message = 'INSERT INTO '+@v_table_id; 
			SET @v_description = N'split 대상...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			-----------------------------------------------------------
			-- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선
			-- Split 여부 옵션화, 2021/05/26, By KKC
			-----------------------------------------------------------
			SKIP1:

		   DEMAND SPLIT DATA 생성 로직 주석 처리 ~ End
		 : Engine Custom에서 SPLIT_QTY 기준으로 SPLIT하는 로직 구현 
			2023.03.07 -----------------------------------------------------------*/

			/* 1이하 소숫점 처리, 2021.07.21 추가 */
			DELETE a
			  FROM th_eng_net_demand_sn a 
			 WHERE a.master_id = @p_master_id 
			   AND a.plan_id   = @p_engine_plan_id 
			   AND CONVERT(NUMERIC, a.qty) = 0
			;

			UPDATE a
			   SET a.qty = 1
			  FROM th_eng_net_demand_sn a 
			 WHERE a.master_id = @p_master_id 
			   AND a.plan_id   = @p_engine_plan_id 
			   AND a.qty < 1
			   AND CONVERT(NUMERIC, a.qty) = 1
		   ;
			 
		END; --IF @p_plan_type = 'MA' THEN
		
       ------------------------------------------------------------
        --임시테이블 삭제
        ------------------------------------------------------------
        IF OBJECT_ID('tempdb..#th_eng_demand') IS NOT NULL 
         BEGIN
            DROP TABLE #th_eng_demand;
         END
         
        IF OBJECT_ID('tempdb..#copy_t') IS NOT NULL 
         BEGIN
            DROP TABLE #copy_t;
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



