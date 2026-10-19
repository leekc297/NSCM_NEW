
/*
 * Program ID   : PR_SCP_ENG_IN_PRE_PROC_NET_DEMAND
 * Description  : 
                  -------------------------------------------------
                  1. Demand Grouping
                  -------------------------------------------------   
                  
                  --------------------------------
                  --경우1) 자동차(81), ESS(82) 일때
                  --------------------------------
                  
                     1) priority_group_code : '그룹핑시작일자::cell_site_id' 형식
                  
                                             -참고1) 그룹핑 시작일자 : 해당 그룹핑의 시작일자( ex1) 그룹핑기준일 3일 이라면,  그룹핑시작일: '20180319' , demand의 shipping_date: 20180320, cell_site_id : 'A040-A'  ==> '20180319::A040-A' )
                                                                                             ( ex2) 그룹핑기준일 3일 이라면,  그룹핑시작일: '20180319' , demand의 shipping_date: 20180323, cell_site_id : 'A040-A'  ==> '20180322::A040-A' )
                                             -참고2) cell_site_id    : 해당 ITEM이 'P' 일때 BOM 상의 셀(여러개 존재시 임의의1개선택) 의 plant site id값
                                                                       해당 ITEM이 'E', 'A' 일때 demand의 plant site id값  

                     2) shipping_date : demend의 shipping_date 
                     3) Due Fence Date : Groupung이 아닌 각각의 Demand 기준으로 처리함

                     --자동차(81) / ESS(82) 일때 : 20190829 ESS 재적용                 
                     4) Priority :   (1) 그룹핑시작일자(fast shipping_date, 위 참고1)의 [그룹핑 시작일자] 값) + '::'   ( 참고: priority_group_code의 cell_site_id 제외한값)
                                   + (2) SetupGroupID 평균 setup time 제일작은순으 numbering (5 자리)
                                   
                                   + (3) fast_due_date (가장 빠른 due_date GROUP BY ISNULL(cell_item_id, item), 그룹핑시작일자 ) --20181203추가
                                   
                                   + (4) SetupGroupID (SetupGroupID 값은 cell_item_id 값으로 대체됨) 가 다른데 동일한 평균setup time 일때 numbering (5자리, (setup group id, cell_item_id, demand item순으로 numbering)) 
                                   + (5) 영업우선순위(10자리)
                                   + (6) Shipping Date(8자리) => Due_date로 변경
                                   + (7) qty (100000000 - qty, 보통8자리됨)   참고) qty 가 큰순으로 조회되게 하기위해서 100000000 - qty 값으로 셋팅되어있음, proiority가 오름차순으로 정렬되면 결과값이 작은게 먼저 조회되므로) 
                                   + (8) NUMBERING ( SetupGroupID 평균setuptime, 영업우선순위, shipping_date , qty DESC)                        
                     
                     5) early_producing_term : ([plan시작일자 기준 shipping_date 와의 일수 차] / demand_grouping_days) + 7  ( +7 은 티라요청)
                                                ==> 그룹핑시작일자와 shipping_date와 일수차 + 7
                  --------------------------------
                  --경우2) 소형(40) 일때
                  --------------------------------

                    1)  Priority :   (1) 그룹핑시작일자(fast shipping_date, 위 참고1)의 [그룹핑 시작일자] 값) + '::'   ( 참고: priority_group_code의 cell_site_id 제외한값)
                                   + (2) SetupGroupID 평균 setup time 제일작은순으로 numbering (5 자리)                                   
                                   + (3) fast_due_date (가장 빠른 due_date GROUP BY ISNULL(cell_item_id, item), 그룹핑시작일자 ) --20181203추가                                   
                                   --+ (4) SetupGroupID (SetupGroupID 값은 cell_item_id값으로 대체됨) 가 다른데 동일한 평균setup time 일때 numbering (5자리, (setup group id, cell_item_id, demand item순으로 numbering)) 
                                   2024.07.19 변경, DM의 모델ID까지 보면, 납기 순서가 역전 발생함
                                   + (4) SetupGroupID (SetupGroupID 값은 cell_item_id값으로 대체됨) 가 다른데 동일한 평균setup time 일때 numbering (5자리, (setup group id, cell_item_id순으로 numbering)) 
                                   --+ (5) DM priority (6자리) -- 20181130추가                                                                                                          
                                   + (5) '9999999999'(10자리)  --DM 영업우선순위를 의미없게 처리
                                   + (6) Due_date Date(8자리)
                                   + (7) (8자리)qty (100000000 - qty, 보통8자리됨)   참고) qty 가 큰순으로 조회되게 하기위해서 100000000 - qty 값으로 셋팅되어있음, proiority가 오름차순으로 정렬되면 결과값이 작은게 먼저 조회되므로) 
                                   + (8) (5자리)NUMBERING ( SetupGroupID 평균setuptime, 영업우선순위, shipping_date , qty DESC)
                                    
                    2) early_producing_term : [fast_due_date 기준 due_date 와의 일수 차] + 7  ( +7 은 티라요청)
					              ==> 20190715 소형 Grouping 안 하므로 0 처리

                  참고 컬럼1) demand_id : a.item_id + '::' + a.project_code + '::' + a.scm_site_id
				                   + '~' + a.incoterms + '::' + a.dom_exp + '::' + a.fcst_type
								   + '::' + a.demand_type + '::' + a.yyyymmdd + '::' + a.plant_site_id
								   
 * OutTable     : th_eng_demand
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.01.24   KSW         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.06.19   KSW         1) 그룹핑기준일자(@n_demand_term)를 scp_mst_final_item.demand_grouping_days 컬럼값으로 변경 
 * 2018.07.19   KSG         priority 에서 Plant Site 값 제거
 * 2018.08.24   KSG         priority : 영업우선순위 다음 Shipping Date 를 Due Date 로 변경
 * 2018.09.06   KSW         소형(40) priority 변경관련 수정
 * 2018.09.12   KSW         소형(40) 일때 early_producing_term 수정 ( early_producing_term : [fast_due_date 기준 due_date 와의 일수 차] + 7)  (참고)주석2
 * 2018.11.30   KSW         소형(40)일때 priority 변경(DM 우선순위 적용) (참고)주석2   
 * 2018.12.03   KSW         자동차(81), ESS(82) demand우선순위수정(fast_due_date 추가) (참고)주석1) 
 * 2018.12.18   KSW         ESS(82) 우선순위 수정(DM의 우선순위로 적용함) (참고)주석1
 * 2019.07.15   KSG         소형(40) priority : yyyymm (due_date기준) (6자리) 를 yyyymmdd (due_date기준) (8자리) 로 변경
 * 2019.08.29   KSG         ESS(82) demand우선순위수정(Grouping 적용) / ESS Default DEMAND 그룹핑값 변경 : 28 -> 1 
 * 2022.04.04   LHS         PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선: JV사업부 추가: 사업부 조건별 로직구현시 division_id 대신 속성값(attribute3) 기준으로 변경
                                ----------------------------------------------------------------
                                        구분                         자동차           전극
                                ==============================    =============   ==============
                                  division_group(attribute3)  :        81              EE                
                                ------------------------------    -------------   --------------
                                  division_id                 :     81 , 81_UC      EE , EE_UC  
                                ----------------------------------------------------------------
 * 2024.05.13   LJH         PJ20244781 LGES 시스템 기반 SCM 고도화(소형 시스템 Planning, oWMS 영역): 소형 Demand Priority Groupping 로직 적용
 * 2024.07.19   KKC         E20240725-001188: 소형 Demand Priority Group Rule 수정 부탁드립니다. : CSR 로직 변경
 *
 */

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_IN_PRE_PROC_NET_DEMAND]
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_IN_PRE_PROC_NET_DEMAND';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'TH_ENG_DEMAND';
    DECLARE @d_event_date   DATETIME;

    DECLARE @n_pre_plan_id       INTEGER = 0;
    DECLARE @n_cur_plan_id       INTEGER = 0;
    DECLARE @n_pre_week_plan_id  INTEGER = 0;
    DECLARE @n_cur_week_plan_id  INTEGER = 0;
    -- DECLARE @v_division_id       NVARCHAR(30);
    DECLARE @v_cur_monday        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    DECLARE @v_demand_cutoff_day NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -6, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 화요일 YYYYMMDD
    DECLARE @v_pet_date          NVARCHAR(8) ; -- Plan End Date
    DECLARE @d_plan_name         DATETIME;

    -- DEMAND 그룹핑 기본값 (scp_mst_final_item.demand_grouping_days( demand 그룹핑 일수)  값이 NULL경우 사용함)
    DECLARE @n_demand_grouping_default_days INT    = 1;--그룹핑 기준일자 기본값 
    DECLARE @n_demand_grouping_default_days_40 INT = 1;--소형 그룹핑 기준일자 기본값 설정

    DECLARE @v_division_group   NVARCHAR(30);  ---(2022.04.04) 변수추가 
    DECLARE @v_division_comp    NVARCHAR(30); 
    /*------------------------------------------------------------------
        * Division Group 정의  (2022.04.04: Joint Venture 사업부 추가)
        - JV사업부 코드(81_UC, EE_UC)추가되면서 사업부별 로직분개시 division_id만으로는 구분값으로 활용 불가.
        - 40, 81, 82, EE 등 사업부별 로직전개에 사용할 기준값을 (attribute3)컬럼에 정의하고 변수 '@v_division_group'로 처리
        - 기존의 division_id 분개로직을 division_group 기준으로 대체하여 사용한다.
        - 예) division_group: 81 >> division_id: 81 , 81_UC >>  division_comp: LG , UC 
    ----------------------------------------------------------------------*/ 
    SELECT @v_division_group   =  di.attribute3  
         , @v_division_comp    =  di.ATTRIBUTE4   -- 회사코드
    FROM   scm_mst_division di WITH(NOLOCK)
    WHERE  di.valid_yn         =  'Y' 
    AND    di.division_id      =  @p_division_id    ; 
    

	-- 20190829 ESS Default DEMAND 그룹핑값 변경 : 28 -> 1 
	IF @v_division_group  = '82'                --(2022.04.04) JV사업부 추가 변수변경: @p_division_id -> @v_division_group
	BEGIN
	    SET @n_demand_grouping_default_days = 1;
	END

  -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id  ; 
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN

	    SELECT @v_pet_date = p.horizon_end_date
        FROM   dbo.scm_mst_plan p WITH(NOLOCK)
        WHERE  p.division_id = @p_division_id 
        AND    p.plan_id     = @p_plan_id ;

        -----------------------------------------------------------
        -- th_eng_demand_sn 삭제는 PR_SCP_ENG_IN_PRE_PROC_DEMAND_ATTRIBUTE 에서 처리함
        -----------------------------------------------------------
        
        -----------------------------------------------------------
        -- 1) 자동차(81), ESS(82)  NET_DEMAND 최종 정보 UPDATE
        --    - 1) priority_group_code 컬럼 업데이트
        --    - 2) priority  컬럼 업데이트
        --    - 3) early_producing_term 컬럼 업데이트

        --    - 참고) Demand 정보 최초생성은 PR_SCP_ENG_IN_PRE_PROC_DEMAND_ATTRIBUTE 에서 처리함 
                        /*
                        -참고1) 그룹핑 시작일자 : 해당 그룹핑의 시작일자( ex1) 그룹핑기준일 3일 이라면,  그룹핑시작일: '20180319' , demand의 shipping_date: 20180320, cell_site_id : 'A040-A'  ==> '20180319::A040-A' )
                                                                        ( ex2) 그룹핑기준일 3일 이라면,  그룹핑시작일: '20180319' , demand의 shipping_date: 20180323, cell_site_id : 'A040-A'  ==> '20180322::A040-A' )
               
                        --참고2-1) 자동차(81) / ESS(82) 일때                          
                        Priority :   (1) 그룹핑시작일자(fast shipping_date, 위 참고1)의 [그룹핑 시작일자] 값) + '::'   ( 참고: priority_group_code의 cell_site_id 제외한값)
                                   + (2) SetupGroupID 평균 setup time 제일작은순으로 numbering (5 자리)                                   
                                   + (3) fast_due_date (가장 빠른 due_date GROUP BY ISNULL(cell_item_id, item), 그룹핑시작일자 ) --20181203추가                                   
                                   + (4) SetupGroupID (SetupGroupID 값은 cell_item_id 값으로 대체됨) 가 다른데 동일한 평균setup time 일때 numbering (5자리, (setup group id, cell_item_id, demand item순으로 numbering)) 
                                   + (5) 영업우선순위(10자리)
                                   + (6) Due_date Date(8자리)
                                   + (7) (8자리)qty (100000000 - qty, 보통8자리됨)   참고) qty 가 큰순으로 조회되게 하기위해서 100000000 - qty 값으로 셋팅되어있음, proiority가 오름차순으로 정렬되면 결과값이 작은게 먼저 조회되므로) 
                                   + (8) (5자리)NUMBERING ( SetupGroupID 평균setuptime, 영업우선순위, shipping_date , qty DESC)
                     */
        -----------------------------------------------------------
        IF @v_division_group IN ('81', '82')  --(2022.04.04) JV사업부 추가 변수변경 :  p_division_id -> @v_division_group
        BEGIN
            
            UPDATE th_eng_demand_sn 
               SET priority_group_code = y.priority_group_code
                ,  priority =  y.priority
                ,  early_producing_term = y.early_producing_term --20180618 추가
             FROM  th_eng_demand_sn x WITH (NOLOCK)
                   INNER JOIN (
                                SELECT   a.demand_id
                                       , a.early_producing_term
                                       , a.priority_group_code_grouping_start_date  + '::' + a.priority_group_code_site_id AS priority_group_code
                                       
                                       -- 20190829 변경 ( ESS(82) Grouping 재적용 : Default = 1 )
                                       ,  a.priority_group_code_grouping_start_date --순위1) 그룹핑시작일자(shipping_date 기준) (8자리)
                                        + '::'
                                        + a.avg_setup_time_numbering                --순위2) avg_setup_time 순위(5자리)
                                        + a.fast_due_date                           --순위3)fast_due_date(가장 빠른 due_date GROUP BY ISNULL(cell_item_id, item), 그룹핑시작일자) (8자리) --20181203추가
                                        + dbo.FN_ZERO_LPAD( dense_rank() OVER (PARTITION BY a.priority_group_code_grouping_start_date, a.avg_setup_time_numbering, a.fast_due_date ORDER BY ISNULL( a.cell_site_setup_group_id, a.cell_item_id), a.item  ) 
                                                        , 5)                        --순위4)setup group id 가 다른데 동일한 평균setup time 일때 numbering (5자리)
                                        + dbo.FN_ZERO_LPAD(ISNULL(a.demand_priority, 1), 10)           --순위5) 영업우선순위( dm_pln_net_demand 에 있는 priority 값) (10자리)
                                        + CONVERT(NVARCHAR(10), a.due_date , 112)                      --순위6) due_date(자리) 
                                        + CONVERT(NVARCHAR(10), 100000000- CONVERT(NUMERIC(10),a.qty)) --순위7) qty작은순 (100000000 - qty, 보통8자리됨)
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
                                                                                   ) / ISNULL(bb.demand_grouping_days,@n_demand_grouping_default_days)
                                                                        ) --DATEDIFF종료
                                                               , 0, 1) --ROUND종료
                                                               * ISNULL(bb.demand_grouping_days,@n_demand_grouping_default_days)
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
                                                                                                                                                           ) / ISNULL(bb.demand_grouping_days,@n_demand_grouping_default_days)
                                                                                                                                                ) --DATEDIFF종료
                                                                                                                                               , 0, 1) --ROUND종료
                                                                                                                                          * ISNULL(bb.demand_grouping_days,@n_demand_grouping_default_days)
                                                                                                                                        , CONVERT(DATETIME,@p_plan_name)
                                                                                                                                      ) --DATEADD종료
                                                                                                                        , 112)--CONVERT종료
                                                                                           ) --OVER종료
                                                        , 112) --첫번째 CONVERT종료 
                                                   AS fast_due_date  --fast_due_date (가장 빠른 due_date GROUP BY ISNULL(a.cell_item_id, a.item), 그룹핑시작일자) (8자리)
	                                             -- 20190829 ESS Default DEMAND 그룹핑값 변경 : 28 -> 1 
                                                 , CASE 
												     WHEN ISNULL(bb.demand_grouping_days,@n_demand_grouping_default_days) > 1
												       THEN DATEDIFF( d, CONVERT(DATETIME,@p_plan_name), aa.shipping_date) % ISNULL(bb.demand_grouping_days,@n_demand_grouping_default_days) + 7
                                                     ELSE 0 -- 1 이면 Grouping 안 하므로 0 처리
												   END AS early_producing_term
                                               --  , DATEDIFF( d, CONVERT(DATETIME,@p_plan_name), aa.shipping_date) % ISNULL(bb.demand_grouping_days,@n_demand_grouping_default_days) + 7 AS early_producing_term --20180522 수정 (변경전 : , DATEDIFF( d, CONVERT(DATETIME,@p_plan_name), CONVERT(DATE, a.yyyymmdd)) % @n_demand_term AS early_producing_term)
                                                 , dbo.FN_ZERO_LPAD( DENSE_RANK() OVER (ORDER BY CASE WHEN aa.avg_setup_time IS NULL THEN  999999999  
                                                                           ELSE aa.avg_setup_time 
                                                                       END)  
                                                            , 5) AS avg_setup_time_numbering
                                             FROM   th_eng_demand_sn aa WITH (NOLOCK)
                                                    LEFT JOIN ( SELECT division_id, item_id, demand_grouping_days   --20180618 조인조건추가( demand grouping 기준일 값 사용위해서)
                                                                FROM   scp_mst_final_item WITH (NOLOCK) 
                                                                WHERE  division_id = @p_division_id 
                                                                AND    operation_group = 'A' --셀만처리
                                                                AND    demand_grouping_days IS NOT NULL
                                                             ) bb
                                                    ON aa.cell_item_id = bb.item_id  
                                             WHERE   aa.master_id = @p_master_id
                                             AND     aa.plan_id   = @p_engine_plan_id 
                                    )a               
                             ) y
                  ON x.demand_id = y.demand_id  
            WHERE  x.master_id = @p_master_id 
            AND    x.plan_id   = @p_engine_plan_id 
            ;
        END

        -----------------------------------------------------------
        --2. 소형(40)일때 priroty 셋팅. 
        -- 자동차/ESS와 동일한 Demand Priority Rule 적용(2024.05.13)              
        -- 소형 일부 기준 변경( 2024.07.19)
        --   (단, 소형은 DM priority를 안 보게 Priority 생성(해당 구분 자릿수(10자리) : 일괄동일한값 설정'9999999999'
                    /*
                        --참고2-2) 소형(40)일때                          
                        Priority :   (1) 그룹핑시작일자(fast shipping_date, 위 참고1)의 [그룹핑 시작일자] 값) + '::'   ( 참고: priority_group_code의 cell_site_id 제외한값)
                                   + (2) SetupGroupID 평균 setup time 제일작은순으로 numbering (5 자리)                                   
                                   + (3) fast_due_date (가장 빠른 due_date GROUP BY ISNULL(cell_item_id, item), 그룹핑시작일자 ) --20181203추가                                   
                                   --+ (4) SetupGroupID (SetupGroupID 값은 cell_item_id값으로 대체됨) 가 다른데 동일한 평균setup time 일때 numbering (5자리, (setup group id, cell_item_id, demand item순으로 numbering)) 
                                   2024.07.19 변경, DM의 모델ID까지 보면, 납기 순서가 역전 발생함
                                   + (4) SetupGroupID (SetupGroupID 값은 cell_item_id값으로 대체됨) 가 다른데 동일한 평균setup time 일때 numbering (5자리, (setup group id, cell_item_id순으로 numbering)) 
                                   --+ (5) DM priority (6자리) -- 20181130추가                                                                                                          
                                   + (5) '9999999999'(10자리)  --DM 영업우선순위를 의미없게 처리
                                   + (6) Due_date Date(8자리)
                                   + (7) (8자리)qty (100000000 - qty, 보통8자리됨)   참고) qty 가 큰순으로 조회되게 하기위해서 100000000 - qty 값으로 셋팅되어있음, proiority가 오름차순으로 정렬되면 결과값이 작은게 먼저 조회되므로) 
                                   + (8) (5자리)NUMBERING ( SetupGroupID 평균setuptime, 영업우선순위, shipping_date , qty DESC)
                     */                                    
                    /* 2024.05.13 이전 ~
                     1) priority :   (1) 20190715 변경 : yyyymmdd (due_date기준) (8자리)  -- 20190715 변경 전 : yyyymm (due_date기준) (6자리)                                                             
                                   + (2) DM priority 앞2자리(DM의 Site 별 우선 순위 정보) (2자리) --20181130추가                                                                      
                                   + (3) item의 해당월별 가장빠른 due_date (8자리)
                                   + (4) item_id 해당월별 이름순으로 NUMBERING (5자리)                                   
                                   + (5) DM priority (6자리) -- 20181130추가                                                                       
                                   + (6) due_date (8자리)
                                   + (7) 위(1)~(6) 동일할 경우 대비 NUMBERING                                    
                                   (참고)  소형(40)일때 dm_pln_net_demand 테이블 1)demand_priority, 2) attribute3, 3)attribute4 컬럼 내용
                                         - demand_priority 컬럼(6자리) : 고객 Priority(2자리) + Demand Type(1자리 /  1:CF, 2:UF, 3:NF ) + Due Date Priority(3자리)
                                         - attribute3      컬럼(1자리) : Demand Type(1자리 /  1:CF, 2:UF, 3:NF ) 
                                         - attribute4      컬럼(2자리) : 고객 Priority(2자리)
                                   --20181130 변경전
                                     (1) yyyymm (due_date기준) (6자리)
                                   + (2) item의 해당월별 가장빠른 due_date (8자리)
                                   + (3) item_id 해당월별 이름순으로 NUMBERING (5자리)
                                   + (4) due_date (8자리)
                                   + (5) 위(1)~(4) 동일할 경우 대비 NUMBERING (5자리)
                     2)  early_producing_term : [fast_due_date 기준 due_date 와의 일수 차] + 7  ( +7 은 티라요청)
					              ==> 20190715 소형 Grouping 안 하므로 0 처리
           */
        ----------------------------------------------------------- 
        ELSE IF @v_division_group = '40' -- 소형(40)일때
        
        /* 2024.5.13. Initial 1차 요건은 공통적인 Priority Rule과 똑같이 해 달고 했으나, 추가 요건 나오면 로직을 추가하자~
           2024.7.19. 소형은 Groupping Priority내에서, 납기가 역전 발생하지 않도록 요청,
        */
        BEGIN 

            UPDATE th_eng_demand_sn 
               SET priority_group_code  = y.priority_group_code
                ,  priority             =  y.priority
                ,  early_producing_term = y.early_producing_term  --선행도 기존로직과 똑같이 하는게 좋을까??? / 진행상황을 보자
              FROM  th_eng_demand_sn x WITH (NOLOCK)
             INNER JOIN (
                          SELECT a.demand_id
                               , a.early_producing_term
                               , a.priority_group_code_grouping_start_date  + '::' + a.priority_group_code_site_id AS priority_group_code                               
                               -- 20190829 변경 ( ESS(82) Grouping 재적용 : Default = 1 )
                               ,  a.priority_group_code_grouping_start_date --순위1) 그룹핑시작일자(shipping_date 기준) (8자리)
                                + '::'
                                + a.avg_setup_time_numbering                --순위2) avg_setup_time 순위(5자리)
                                + a.fast_due_date                           --순위3)fast_due_date(가장 빠른 due_date GROUP BY ISNULL(cell_item_id, item), 그룹핑시작일자) (8자리) --20181203추가
                                /* 순위4) 기준변경 (DM Model순 -> DM Model순 제외),  2024.07.19 
                                   DM Model순을 포함하면, 납기가 역전 발생
                                */
                                + dbo.FN_ZERO_LPAD( dense_rank() OVER (PARTITION BY a.priority_group_code_grouping_start_date, a.avg_setup_time_numbering, a.fast_due_date ORDER BY ISNULL( a.cell_site_setup_group_id, a.cell_item_id)) 
                                                , 5)                                                                        
                                --+ dbo.FN_ZERO_LPAD( dense_rank() OVER (PARTITION BY a.priority_group_code_grouping_start_date, a.avg_setup_time_numbering, a.fast_due_date ORDER BY ISNULL( a.cell_site_setup_group_id, a.cell_item_id), a.item  ) 
                                --                , 5)                        --순위4)setup group id 가 다른데 동일한 평균setup time 일때 numbering (5자리)
                                /* 순위5) 기준변경 (영업우선순위 적용 -> 영업우선순위 제외),  2024.07.19 
                                   DM의 영업우선순위를 적용하면, 납기 역전 발생
                                */
                                + dbo.FN_ZERO_LPAD('9999999999', 10)        --순위5) 영업우선순위( dm_pln_net_demand 에 있는 priority 값) (10자리)
                                --+ dbo.FN_ZERO_LPAD(ISNULL(a.demand_priority, 1), 10)           
                                                                            --순위5) 영업우선순위( dm_pln_net_demand 에 있는 priority 값) (10자리)
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
                                                                                 --, a.demand_priority -- 2024.07.19 DM의 우선순위 안 보는 걸로 변경
                                                                                   , a.due_date        -- 2018.08.24  Shipping Date 를 Due Date 로 변경
                                                                                   , a.qty DESC)
                                                                        )
                                                , 5)  --순위8) 위 1)~7)동일할 경우 대비 Numbering(5자리)
                                 AS priority
                              FROM (SELECT aa.demand_id
                                        ,  aa.shipping_date  
                                        ,  aa.due_date
                                        ,  aa.cell_site_id
                                        ,  aa.item
                                        ,  aa.plant_site_id
                                        ,  aa.avg_setup_time
                                        ,  aa.cell_site_setup_group_id
                                        ,  aa.cell_item_id
                                        ,  aa.demand_priority
                                        ,  aa.qty
                                        ,  CONVERT(NVARCHAR(10),
                                               DATEADD(d, ROUND(
                                                              (  DATEDIFF(  d
                                                                          , CONVERT(DATETIME,@p_plan_name)
                                                                          , CONVERT(DATETIME, aa.shipping_date)
                                                                          ) / ISNULL(bb.demand_grouping_days,@n_demand_grouping_default_days_40)
                                                               ) --DATEDIFF종료
                                                      , 0, 1) --ROUND종료
                                                      * ISNULL(bb.demand_grouping_days,@n_demand_grouping_default_days_40)
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
                                                                                                                                                  ) / ISNULL(bb.demand_grouping_days,@n_demand_grouping_default_days_40)
                                                                                                                                       ) --DATEDIFF종료
                                                                                                                                      , 0, 1) --ROUND종료
                                                                                                                                 * ISNULL(bb.demand_grouping_days,@n_demand_grouping_default_days_40)
                                                                                                                               , CONVERT(DATETIME,@p_plan_name)
                                                                                                                             ) --DATEADD종료
                                                                                                               , 112)--CONVERT종료
                                                                                  ) --OVER종료
                                               , 112) --첫번째 CONVERT종료 
                                            AS fast_due_date  --fast_due_date (가장 빠른 due_date GROUP BY ISNULL(a.cell_item_id, a.item), 그룹핑시작일자) (8자리)                                         
	                                      -- 20190829 ESS Default DEMAND 그룹핑값 변경 : 28 -> 1 
                                          , CASE WHEN ISNULL(bb.demand_grouping_days,@n_demand_grouping_default_days_40) > 1
		 	                                          THEN DATEDIFF( d, CONVERT(DATETIME,@p_plan_name), aa.shipping_date) % ISNULL(bb.demand_grouping_days,@n_demand_grouping_default_days_40) + 7
                                                 ELSE 0 -- 1 이면 Grouping 안 하므로 0 처리
				                             END AS early_producing_term
                                          , dbo.FN_ZERO_LPAD( DENSE_RANK() OVER (ORDER BY CASE WHEN aa.avg_setup_time IS NULL THEN  999999999  
                                                                                               ELSE aa.avg_setup_time 
                                                                                          END)  
                                               , 5) AS avg_setup_time_numbering
                                       FROM th_eng_demand_sn aa WITH (NOLOCK)
                                       LEFT JOIN ( SELECT division_id, item_id, demand_grouping_days   --20180618 조인조건추가( demand grouping 기준일 값 사용위해서)
                                                     FROM scp_mst_final_item WITH (NOLOCK) 
                                                    WHERE division_id = @p_division_id 
                                                      AND operation_group = 'A' --셀만처리
                                                      AND demand_grouping_days IS NOT NULL
                                                 ) bb
                                         ON aa.cell_item_id = bb.item_id
                                      WHERE aa.master_id    = @p_master_id
                                        AND aa.plan_id      = @p_engine_plan_id
                                  )a           
                      ) y
            ON x.demand_id = y.demand_id  
         WHERE x.master_id = @p_master_id 
           AND x.plan_id   = @p_engine_plan_id 
            ;           

            /* OLD : 2024.05.13 이전
            UPDATE th_eng_demand_sn 
            SET   priority =  y.priority
		     20190715 소형 Grouping 안 하므로 0 처리
               ,  early_producing_term = 0
               --,  early_producing_term =  DATEDIFF( d, y.fast_due_date,  x.due_date) + 7  --20180912 추가( fast_due_date기준 due_date  일수 차 )
            
               ,  priority_group_code = y.priority_group_code -- 티라 확인 결과 엔진에서 사용 안 함
            FROM  th_eng_demand_sn x WITH (NOLOCK)
                  INNER JOIN  (
                                /* 20181130변경전
                                SELECT demand_id
                                    ,   CONVERT(NVARCHAR(6), a.due_date, 112) --1) yyyymm
                                      + CONVERT(NVARCHAR(8), MIN(a.due_date) OVER (PARTITION BY ISNULL(a.cell_item_id, a.item), CONVERT(NVARCHAR(6), a.due_date, 112) ) ,112) --2) item의 해당월중 가장빠른 due_date
                                      + dbo.fn_zero_lpad(DENSE_RANK() OVER (PARTITION BY CONVERT(NVARCHAR(6), a.due_date, 112) ORDER BY ISNULL(a.cell_item_id, a.item)), 5)    --3) item_id 이름순으로 NUMBERING
                                      + CONVERT(NVARCHAR(8), a.due_date, 112) --4) due_date
                                      + dbo.fn_zero_lpad(ROW_NUMBER() OVER (PARTITION BY a.due_date, ISNULL(a.cell_item_id, a.item) ORDER BY demand_id), 5) --(5) 위(1)~(4) 동일할 경우 대비 NUMBERING
                                      AS priority 
                                   
                                    , MIN(a.due_date) OVER (PARTITION BY ISNULL(a.cell_item_id, a.item), CONVERT(NVARCHAR(6), a.due_date, 112) )  AS fast_due_date --20180912 추가 
            
                                FROM   th_eng_demand_sn a WITH (NOLOCK)
                                WHERE  a.master_id = @p_master_id 
                                AND    a.plan_id   = @p_engine_plan_id 
                                */
            
                                SELECT demand_id
                                                                          
                                     , CONVERT(NVARCHAR(10),
                                                    DATEADD(d, ROUND(
                                                                   (  DATEDIFF(  d
                                                                               , CONVERT(DATETIME,@p_plan_name)
                                                                               , CONVERT(DATETIME, a.shipping_date)
                                                                               ) / ISNULL(b.demand_grouping_days,@n_demand_grouping_default_days_40)
                                                                    ) --DATEDIFF종료
                                                           , 0, 1) --ROUND종료
                                                           * ISNULL(b.demand_grouping_days,@n_demand_grouping_default_days_40)
                                                           , CONVERT(DATETIME,@p_plan_name)
                                                   ) --DATEADD종료
                                           , 112) --CONVERT 종료  --그룹핑시작일자(shipping_date 기준) (8자리)
                                      + '::' + ISNULL(a.cell_site_id, a.plant_site_id) -- 20180411 수정 (변경전 : + '::' + ISNULL(cell_site_id, plant_site_id) )
                                      AS priority_group_code --Demand별 Grouping 별로 동일한 Code 추가('그룹핑시작일자::cell_site_id' 형태)
                                     
		    			 
                                      -- 20190715 변경 yyyymmdd (due_date기준) (8자리)  -- 20190715 변경 전 : yyyymm (due_date기준) (6자리)   
                                     ,  CONVERT(NVARCHAR(8), due_date, 112)   --1) yyyymmdd -- ,  a.due_date_yyyymm       --1) yyyymm
                                      + a.demand_priority_site  --2) DM의 Site 별 우선 순위 정보(DM priority의 앞2자리)
                                      + CONVERT(NVARCHAR(8), a.fast_due_date, 112)  --3) item의 해당월중 가장빠른 due_date
                                      + dbo.fn_zero_lpad(DENSE_RANK() OVER (PARTITION BY a.due_date_yyyymm, a.demand_priority_site, a.fast_due_date ORDER BY ISNULL(a.cell_item_id, a.item)), 5) --4) 위(1)~(3) 동일할 경우 대비 item_id 이름순으로 NUMBERING
                                      
                                      --+ a.priority --5) DM priority(10자리, '0000'(4자리)+ dm 우선순위(6자리))
                                      + a.demand_priority --5) DM priority(6자리)
                                      
                                      + CONVERT(NVARCHAR(8), a.due_date, 112) --6) due_date
                                      + dbo.fn_zero_lpad(ROW_NUMBER() OVER (PARTITION BY a.demand_priority, a.due_date, ISNULL(a.cell_item_id, a.item) ORDER BY a.demand_id), 5) --(7) 위(1)~(6) 동일할 경우 대비 NUMBERING
                                      AS priority 
                                    
                                    , a.fast_due_date -- item의 해당월중 가장빠른 due_date (DATETIME 데이터형식)  
            
            
            
                                FROM   (SELECT demand_id
                                             , due_date
                                             , demand_priority
                                             , cell_item_id
                                             , item
                                             , priority
            
                                             , CONVERT(NVARCHAR(6), due_date, 112) AS due_date_yyyymm  -- due_date의 yyyymm
                                             , LEFT(demand_priority, 2) AS demand_priority_site        -- DM의 Site 별 우선 순위 정보 
                                             
                                             --, CONVERT(NVARCHAR(8), MIN(due_date) OVER (PARTITION BY ISNULL(cell_item_id, item), CONVERT(NVARCHAR(6), a.due_date, 112) ) ,112) --item의 해당월중 가장빠른 due_date (NVARCHAR 데이터형식)
                                             , MIN(due_date) OVER (PARTITION BY ISNULL(cell_item_id, item), CONVERT(NVARCHAR(6), due_date, 112) )  AS fast_due_date -- item의 해당월중 가장빠른 due_date (DATETIME 데이터형식)
                                              
                                             , shipping_date --20181203추가
                                             , cell_site_id  --20181203추가
                                             , plant_site_id --20181203추가
                                        FROM   th_eng_demand_sn  WITH (NOLOCK)
                                        WHERE  master_id = @p_master_id 
                                        AND    plan_id   = @p_engine_plan_id
                                       ) a
            
                                       LEFT JOIN ( SELECT division_id, item_id, demand_grouping_days   --20180618 조인조건추가( demand grouping 기준일 값 사용위해서)
                                                    FROM   scp_mst_final_item WITH (NOLOCK) 
                                                    WHERE  division_id = @p_division_id 
                                                    AND    operation_group = 'A' --셀만처리
                                                    AND    demand_grouping_days IS NOT NULL
                                                   ) b
                                       ON a.cell_item_id = b.item_id  
                                
                              ) y
                    ON  x.demand_id = y.demand_id
            
            WHERE  x.master_id = @p_master_id
            AND    x.plan_id   = @p_engine_plan_id 
            ;
            */

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
