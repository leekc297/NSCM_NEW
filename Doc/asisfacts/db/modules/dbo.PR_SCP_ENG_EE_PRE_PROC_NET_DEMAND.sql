
/*
 * Program ID   : PR_SCP_ENG_EE_PRE_PROC_NET_DEMAND
 * Description  : SDB의 DM Demand 정보를 ODB의 DM Demand 에 적재되도록 한다.
                   
                  -------------------------------------------------
                  1. 엔진용 DM Demand 정보 생성
                  -------------------------------------------------
                    - 동일 키(project_code, scm_site_id, item_id, dom_exp, fcst_type, incoterms, demand_type, yyyymmdd)값중 
                       version_no값이 MAX인 dm_pln_net_demand(DM Demand정보)를 이용해서 데이터생성 
                  
                  -------------------------------------------------
                  2. Demand Grouping
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
                     
                 
                  참고 컬럼1) demand_id : a.item_id + '::' + a.project_code + '::' + a.scm_site_id
				                   + '~' + a.incoterms + '::' + a.dom_exp + '::' + a.fcst_type
								   + '::' + a.demand_type + '::' + a.yyyymmdd + '::' + a.plant_site_id

                  
                  

 * EXEC :
                --select * from scm_mst_plan order by last_update_date desc
                --select * from scm_mst_plan_detail order by last_update_date desc
               
              DECLARE  @p_plan_cycle  NVARCHAR(150)   = 'WEEKLY'
               , @p_plan_name   nvarchar(4000)  = '20180625'
               , @p_plan_id     nvarchar(4000)  = '1032'
               , @p_modeling_id nvarchar(4000)  = '4'
               , @p_seq         nvarchar(4000)  = '1'
               , @p_plan_type   nvarchar(4000)  = 'PR'
               , @p_master_id   nvarchar(4000)  = 'EE::WEEKLY'
               , @p_division_id nvarchar(30)    = 'EE'
               , @p_engine_plan_id nvarchar(4000) = '1032::PR::1'
	
	          EXEC PR_SCP_ENG_EE_PRE_PROC_NET_DEMAND @p_plan_cycle, @p_plan_name, @p_plan_id, @p_modeling_id, @p_seq, @p_plan_type, @p_master_id, @p_division_id, @p_engine_plan_id             

              SELECT * FROM th_eng_demand_sn
              where  master_id = 'EE::WEEKLY' --@p_master_id
              and    plan_id   = '1032::PR::1'

 * OutTable     : th_eng_demand
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.01.24   KSW         Initial Release 전지본부 GSCM(DM/SCP) 구축 프로젝트
 * 2018.06.19   KSW         1) 그룹핑기준일자(@n_demand_term)를 scp_mst_final_item.demand_grouping_days 컬럼값으로 변경 
                            2) early_producing_term, priority_gubun_code, priority 컬럼값 생성시 due_date -> shipping_date 변경
 * 2018.07.19   KSG         priority 에서 Plant Site 값 제거
 * 2018.08.24   KSG         priority : 영업우선순위 다음 Shipping Date 를 Due Date 로 변경
 * 2018.12.03   KSW         자동차(81), ESS(82) demand우선순위수정(fast_due_date 추가) (참고)주석1)
 * 2019.03.05   KSW         [재료본부 전지재료 GSCM 구축 프로젝트] 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가 (전지재료('44') 사업부추가로 인한 조건추가) 
 * 2019.06.26   KSG         전극은 Demand Grouping 제거
 * 2022.04.04   LHS         PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선: JV사업부 추가: 사업부 조건별 로직구현시 division_id 대신 속성값(attribute3) 기준으로 변경
                                ----------------------------------------------------------------
                                        구분                         자동차           전극
                                ==============================    =============   ==============
                                  division_group(attribute3)  :        81              EE                
                                ------------------------------    -------------   --------------
                                  division_id                 :     81 , 81_UC      EE , EE_UC  
                                ----------------------------------------------------------------
 *
 */

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_EE_PRE_PROC_NET_DEMAND]
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_EE_PRE_PROC_NET_DEMAND';
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
    DECLARE @n_demand_grouping_default_days INT = 1;--그룹핑 기준일자 기본값 : 20190626 전극은 Demand Grouping 제거 28 -> 1 로 처리

     ---(2022.04.04) 추가.
    DECLARE @v_division_group   NVARCHAR(30);    
    DECLARE @v_division_comp    NVARCHAR(30); 
    /*------------------------------------------------------------------
     * Division Group 정의  (2022.04.04: Joint Venture 사업부 추가) 
        - JV사업부 코드(81_UC, EE_UC)추가되면서 division_id만으로는 사업부별 로직분개시 구분값으로 활용 불가.
        - 40, 81, 82, EE 등 사업부별 로직전개에 사용할 기준값을 (attribute3)컬럼에 정의하고 변수 '@v_division_group'로 처리
        - 기존의 division_id 분개로직을 division_group 기준으로 대체하여 사용한다.
        - 예) division_group: 81 >> division_id: 81 , 81_UC >>  division_comp: LG , UC 
    ----------------------------------------------------------------------*/   
    SELECT @v_division_group   =  di.attribute3 
         , @v_division_comp    =  di.ATTRIBUTE4    -- 회사코드
    FROM   scm_mst_division di WITH(NOLOCK)
    WHERE  di.valid_yn         =  'Y' 
    AND    di.division_id      =  @p_division_id  ; 

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
        -- th_eng_demand_sn 삭제는 PR_SCP_ENG_EE_PRE_PROC_DEMAND_ATTRIBUTE 에서 처리함
        -----------------------------------------------------------
        
        -----------------------------------------------------------
        -- 1) NET_DEMAND 최종 정보 UPDATE : 20190626 전극은 Demand Grouping 제거
        --    - 1) priority_group_code 컬럼 업데이트
        --    - 2) priority  컬럼 업데이트

        --    - 참고) Demand 정보 최초생성은 PR_SCP_ENG_EE_PRE_PROC_DEMAND_ATTRIBUTE 에서 처리함 

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
            
            UPDATE th_eng_demand_sn 
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
                                                    -- 2022.04.04 JV사업부 추가: 사업부검색컬럼을 division_id -> division_group(attribute3) 변경 
                                                    LEFT JOIN ( SELECT fi.division_id, fi.item_id, fi.demand_grouping_days   --20180618 조인조건추가( demand grouping 기준일 값 사용위해서)
                                                                FROM   scp_mst_final_item fi WITH (NOLOCK) 
                                                                     , scm_mst_division   di WITH(NOLOCK)
                                                                WHERE  fi.operation_group = 'A' --셀만처리
                                                                AND    fi.demand_grouping_days IS NOT NULL  
                                                                AND    fi.DIVISION_ID     =  di.DIVISION_ID 
                                                                AND    di.valid_yn        =  'Y' 
                                                                AND    di.attribute4      =  @v_division_comp  -- 같은회사 검색
                                                                AND    di.attribute3     IN ( '40', '81', '82') --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)
                                                             ) bb
                                                  /* 20220404 변경전 
                                                    LEFT JOIN ( SELECT division_id, item_id, demand_grouping_days   --20180618 조인조건추가( demand grouping 기준일 값 사용위해서)
                                                                FROM   scp_mst_final_item WITH (NOLOCK) 
                                                                WHERE  operation_group = 'A' --셀만처리
                                                                AND    demand_grouping_days IS NOT NULL
                                                                --AND    division_id = @p_division_id  --전극은 'EE'므로 주석처리함                                                                
                                                                AND    division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)   --++(220328) 수정대상
                                                             ) bb   */ 
                                                    ON   aa.cell_item_id = bb.item_id  
                                                    AND  aa.division_id  = bb.division_id   -- 20180704 추가 

                                             WHERE   aa.master_id = @p_master_id
                                             AND     aa.plan_id   = @p_engine_plan_id 
                                    )a 
              
                             ) y
                  ON x.demand_id = y.demand_id  

            WHERE  x.master_id = @p_master_id 
            AND    x.plan_id   = @p_engine_plan_id 
            ; 
        
            /* -- 20190626 : 전극은 Demand Grouping 제거 : 주석 START
            UPDATE th_eng_demand_sn 
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
                                                 

                                                 , DATEDIFF( d, CONVERT(DATETIME,@p_plan_name), aa.shipping_date) % ISNULL(bb.demand_grouping_days,@n_demand_grouping_default_days) + 7 AS early_producing_term --20180522 수정 (변경전 : , DATEDIFF( d, CONVERT(DATETIME,@p_plan_name), CONVERT(DATE, a.yyyymmdd)) % @n_demand_term AS early_producing_term)
                                                 
                                                 , dbo.FN_ZERO_LPAD( DENSE_RANK() OVER (ORDER BY CASE WHEN aa.avg_setup_time IS NULL THEN  999999999  
                                                                           ELSE aa.avg_setup_time 
                                                                       END)  
                                                            , 5) AS avg_setup_time_numbering

                                             FROM   th_eng_demand_sn aa WITH (NOLOCK)
                                                    LEFT JOIN ( SELECT division_id, item_id, demand_grouping_days   --20180618 조인조건추가( demand grouping 기준일 값 사용위해서)
                                                                FROM   scp_mst_final_item WITH (NOLOCK) 
                                                                WHERE  operation_group = 'A' --셀만처리
                                                                AND    demand_grouping_days IS NOT NULL
                                                                --AND    division_id = @p_division_id  --전극은 'EE'므로 주석처리함                                                                
                                                                AND    division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)
                                                             ) bb
                                                    ON   aa.cell_item_id = bb.item_id  
                                                    AND  aa.division_id  = bb.division_id   -- 20180704 추가

                                             WHERE   aa.master_id = @p_master_id
                                             AND     aa.plan_id   = @p_engine_plan_id 
                                    )a 
              
                             ) y
                  ON x.demand_id = y.demand_id  

            WHERE  x.master_id = @p_master_id 
            AND    x.plan_id   = @p_engine_plan_id 
            ; */ -- 20190626 : 전극은 Demand Grouping 제거 : 주석 END

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

