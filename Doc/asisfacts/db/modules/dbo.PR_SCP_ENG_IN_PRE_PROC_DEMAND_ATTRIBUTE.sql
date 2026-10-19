
/*              
 * Program ID   : PR_SCP_ENG_IN_PRE_PROC_DEMAND_ATTRIBUTE  
 * Description  : ODB의 Demand Attribute 에 적재되도록 한다.
          
        -----------------------------------------------------------
        -- 1. DEMAND 생성 (Demand Attribute 생성을 위한 최소한의 컬럼값만 생성함)
        -----------------------------------------------------------
            - 여기서는 Demand Attribute 생성을 위한 최소한의 컬럼값만 생성함 
              최종 th_eng_demand_sn테이블의 데이터 생성은 
              PR_SCP_ENG_IN_PRE_PROC_NET_DEMAND 프로시저에서 생성완료함
            
            - 전극 item 제외함(= scm_mst_item_sn.scp_operation_group <> 'E')
            - 상품/원자재 Demand는 엔진에 반영하지 않음 : 한 site의 Q/R이 다른 Site에서는 P/H일 수 있음 (scm_mst_item_sn.item_type 이 'Q', 'R' 제외시키면 됨)

            - 컬럼1) demand_id : dm_pln_net_demand 테이블의 
                                 1) item_id + '::' + 2) project_code + '::' + 3) scm_site_id
				                       + '~' + 4) incoterms + '::' + 5) dom_exp + '::' + 6) fcst_type
								       + '::' + 7) demand_type + '::' + 8) yyyymmdd + '::' + 9) plant_site_id
                                 
                                 =>3) scm_site_id   : SALES site 
                                 =>4) incoterms     : 위3) VMI 대상 site일때 incoterms를 'DAP'로 셋팅함 
                                 =>8) yyyymmdd      : dm_pln_net_demand.attribute1 값(dm_pln_net_demand.yyyymmdd로 별칭처리해서 사용) (참고) due date값, 처음에는 dm_pln_net_demand.yyyymmdd  값이  due date로 사용했음
                                 =>9) plant_site_id : 
                                                      -경우1) dm_pln_net_demand.plant_site_id 값이 존재할때
                                                              => dm_pln_net_demand.plant_site_id 값 그대로 사용함
                                                      
                                                      -경우2) dm_pln_net_demand.plant_site_id 값이 미존재 할때('', NULL, 'NOPLANT', 'NO PLANT' 일때)
                                                              - 자동차(81) 일때        : scm_mst_site_item_priority 테이블에 1) project_code, 2) sales_site_id, 3) item_id, 4) from_yyyymmdd <= due date, 5) to_yyyymmdd >= due date 가 일치하는 priority =1인 plant_site_id(여러개 존재시 랜덤선택함) 사용함
                                                              - 소형(40), ESS(82) 일때 : scm_mst_site_item_priority 테이블에 1) item_id, 2) from_yyyymmdd <= due date, 3) to_yyyymmdd >= due date 가 일치하는 priority =1인 plant_site_id(여러개 존재시 랜덤선택함) 사용함
                                 =>10) cell_prod_site_id : 소형 셀 생산지별 공급계획 수립 엔진기능 개발                      
            - 컬럼2) sales_model_id : dm_pln_net_demand.item_id + '^' + dm_pln_net_demand.scm_site_id + '~' + dm_pln_net_demand.incoterms + '^S'
            
            - 컬럼3) shipping_date  : dm_pln_net_demand.yyyymmdd (=dm_pln_net_demand.yyyymmdd_org 별칭처리해서 사용)
                                      => dm_pln_net_demand.yyyymmdd 값이 플랜시작일보다 작으면 플랜시작일(=@d_plan_name)값을 shipping_date 값으로 사용함) 
                                      => 최종 shipping_date는 scp_mst_bod_v.lt_total 일수만큼 차감한 값이 셋팅됨
                                      (참고 : scp_mst_bod_v.lt_total => division_id, from_site, to_site, incoterms 그룹핑값중 priority 제일작은값 사용 
                                       
            - 컬럼4) due_date       : dm_pln_net_demand.attribute1 값(dm_pln_net_demand.yyyymmdd로 별칭처리해서 사용) (참고) due date값, 처음에는 dm_pln_net_demand.yyyymmdd  값이  due date로 사용했음
            
            - 컬럼5) due_fence_date :  - 소형(40) 사업부 일때            : due_date 월의 마지막 일자 (단, due date가 플랜종료월일때는 플랜종료일(=@v_pet_date) )
			                                  ==> 20190725 변경 플랜종료일(=@v_pet_date) + 추가13주  
                                       - 자동차(81), ESS(82) 사업부 일때 : 플랜종료일(=@v_pet_date) + 추가13주  
            
            - 컬럼6) qty            :  dm_pln_net_demand.qty
            - 컬럼7) split_qty      :  dm_pln_net_demand.qty
            - 컬럼8) producing_type :  'EPST'

            - 컬럼9) priority_group_code : PROC_NET_DEMAND 처리시 최종 UPDATE됨
            - 컬럼10) priority           : PROC_NET_DEMAND 처리시 최종 UPDATE됨

            - 컬럼11) demand_group_id : 위) demand_id 와 동일값 

            - 컬럼12) late_type :  - 소형(40)            : 'SHIPMENT_LATE' 셋팅 (plan_type='TE'일때는 'FENCEDATE_OVERLAP'셋팅)
			                                  ==> 20190725 변경 'FENCEDATE_OVERLAP' 셋팅
                                   - 자동차(81), ESS(82) : 'FENCEDATE_OVERLAP' 셋팅
            
            - 컬럼13) cell_item_id : demand정보의 item이  셀item이면 dm_pln_net_demand.item_id  (팩일때는 BOM의 하위 셀item을 사용함, BOM에 정보가 없을경우 팩item 그대로사용함) 
            - 컬럼14) avg_setup_time : - demand정보의 셀item의 평균 setup time 값을 셋팅 (단, 팩일때는 BOM의 하위 셀item을 사용함, BOM에 정보가 없을경우 팩item 그대로사용함) 
                                         => 셀item에 해당되는 demand scm_mst_item_sn.setup_attribute(여러개 존재시 MAX값사용) 조회한 후
                                         => 위의 setup_attribute 값과 scm_mst_setup_matrix_sn.to_item_setup_group_id 값이 일치하는 scm_mst_setup_matrix_sn.setup_time 값사용함(setup_time 여러개일수 있으므로 AVG값 사용함) 

                                       - PROC_NET_DEMAND 처리시 priority(우선순위) 컬럼값 UPDATE시 사용함
            
            - 컬럼15) max_daily_capa  : - demand정보의 셀item (팩일때는 BOM의 하위 셀item을 사용함, BOM에 정보가 없을경우 팩item 그대로사용함) 의 DAILY CAPA 중 값이 가장작은 LINE의 값 사용함(max_daily_capa 컬럼명이 max인데 min값을 사용하는 이유는 최초컬럼생성시에는 max값만 사용했기때문임)
                                        - PROC_DPP_DEMAND 처리시 SPLIT 수량값으로 사용함
                                        
                                          
            - 참조 테이블1) dm_pln_net_demand (DM demand 정보)  (참고) plan_cycle='WEEKLY'일때는 dm_pln_net_demand테이블 사용, plan_cycle='DAILY' 일때는 dm_pln_mkt_fcst 테이블 사용)
                            => 조건1) cutoff_yyyymmdd 조건은 플랜시작일(=@d_plan_name)기준 3일 이내 존재하는 최신일자의 cutoff_yyyymmdd 사용함
                            => 조건2) version_no      조건은 위 cutoff_yyyymmdd 조건(3일 이내 존재하는 최신일자)에 해당데이터중 가장큰 version_no 사용함
                            => 조건3) scm_site_id     조건은 scm_mst_site.site_type = 'SALES'존재하는 SALES site


        -----------------------------------------------------------
        -- 2.  DEMAND ATTRIBUTE 생성
        -----------------------------------------------------------
               -  위 1에서 생성된 demend정보의 demand_id별로 item(모든 하위item포함)과 item(모든 하위item포함)생산지 정보 INSERT

               - 컬럼1) demand_id : 위1 에서 생성된 demand 정보사용함
               - 컬럼2) preference_product_id : Demand Item 과 연결된 모든 하위 Item 정보 생성(모든 item을 '##'으로 연결해서 입력함, ex) 'ACEN1053I-B1##APCLCCART-A1' )                      
                                                => BOM정보에 존재하는 모든 하위 item 정보
         
               - 컬럼3) preference_site_id  : Demand Item 과 연결된 하위 Item 의 생산지 정보 생성(모든 하위 item의 site정보를 '##'으로 연결해서 입력함, ex) 'A010-A~***##A010-A~001##A010-A~002##A010-A~003##G182-A~***##G182-A~001##G182-A~002##G182-A~003' )
                                              => 위 preference_product_id의 모든 item과 demand 정보를 이용해서 demandscm_mst_site_item_priority 테이블에서
                                                 - 자동차 일때   : division_id,item,project_code,scm_site_id 정보가 동일하면서 due_date가 from_yyyymmdd ~ to_yyyymmdd 에 포함된 모든 plant_site_id로 셋팅함
                                                 - 소형,ESS 일때 : division_id,item 정보가 동일하면서 due_date가 from_yyyymmdd ~ to_yyyymmdd 에 포함된 모든 plant_site_id로 셋팅함
               - 컬럼4) is_hard_preference : 'Y'로 셋팅 
                 
        -----------------------------------------------------------
        -- 3. th_eng_demand_sn 각종 정보 업데이트       
                - 1) 셀일때 Daily CAPA 정보 업데이트 (외주(TCO) 셀은 제외함)
                - 2) SETUP GROUP ID 관련 업데이트
                - 3) shipping_date 업데이트
        -----------------------------------------------------------
              -  Daily Capa 정보 및 평균setup time 정보 생성시 셀item 기준으로 처리함 (팩은 BOM의 하위 셀item 사용함, BOM정보가 없으면 팩item 그대로 사용함)   
              -  Daily Capa 값은 PROC_DPP_DEMAND 에서 split 수량으로 사용됨
              -  setup time 은 우선순위 생성시 사용됨

 * OutTable     : th_eng_demand_attribute
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.02.20   KSW         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 
 * 2018.05.23   KSW         1) NET DEMAND의 max_daily_capa 값 변경 (변경전 : 셀item의 max_daily_capa 값 그대로 사용, 변경후 : [max_daily_capa / bom상의 accumulated_child_qty] 을 max_daily_capa 값으로 사용        
                            2) DEMAND ATTRIBUTE의 preference_product_id 컬럼값에 전극item 제외
 * 2018.05.28   KSW         1) DEMAND ATTRIBUTE의 plant_site_id 대상 변경( scm_mst_site_item_priority 테이블에서 순위와 대상 plant_site_id 에 상관없이 item/(project_code, sales_site_id '81'만적용)/due_date 조건에 맞는 모든 plant_site_id 사용)
 * 2018.06.18   KSW         BOM 대상테이블변경 ( 변경전 : scm_mst_bom_sn, 변경후 : scm_mst_bom_effective_sn ) 
 * 2018.06.19   KSW         1) early_producing_term 컬럼값 수정(PR_SCP_ENG_IN_SP_PROC_NET_DEMAND 처리시 최종값 생성됨)
                            2) shipping_date 컬럼값 수정   참고) 주석3-4 
 * 2018.06.21   KSW         1) Demand의 item의 BOM상의 하위 item  정보처리시 accmulated_child_qty 값을 MIN값으로 변경 -- 주석2)-1-1
                            2) th_eng_demand 테이블의 demand_priority(DM의 우선순위) 컬럼추가 --주석1)-1
 * 2018.07.05   KSG         LATE TYPE 변경 / 13주 추가기간 설정
 * 2018.07.16   KSW         demand의 scm_site(To Site)가 VMI인 경우 Demand의 Incoterms 를 DAP 로 처리
 * 2018.07.17   KSW         팩분리(~***, ~003) 적용관련 수정
 * 2018.07.25   KSW         Avg_Setup_Time 조회시 cell_site_id 를 group by 에서 제외  (참고 주석3-2) )
 * 2018.08.16   KSW         소형 LATE_TYPE 수정( late_type => 소형(40) : 'SHIPMENT_LATE', 자동차(81) : FENCEDATE_OVERLAP, ESS(82) : FENCEDATE_OVERLAP )
 * 2018.08.22   KSW         외주 셀/팩 ***만 생성( 외주셀 : 001, 002, 003 생성제외, 외주팩 : 003 생성제외)
 * 2018.08.27   KSW         소형('40') 셀 물량분배 관련 수정
 * 2018.10.10   KSW         소형('40')일때 due_fence_date 값 수정(late_type = 'SHIPMENT_LATE' 일때 due_date이 플랜종료월(@v_pet_date)과 같을 경우 플랜종료일을 due_fence_date값으로 셋팅함) 참고)주석1-2
 * 2018.10.11   KSW         nlevel 조회조건 부분 수정 참고)주석2-1-1)
 * 2018.11.12   KSW         plant_type = 'TE' 일때 late_type 컬럼값 변경( 소형(40)이면서 plan_type = 'TE'일때 late_type = 'FENCEDATE_OVERLAP')
 * 2018.11.29   KSW         1) 속도개선 scm_mst_bom_effective_sn 테이블 힌트적용 참고)주석2-1-1)
                            2) nlevel 조회조건 수정참고)주석2-1-1) 
 * 2018.12.11   KSG         소형('40')이 아닌 경우 due_fence_date 값 수정 : 플랜종료월(@v_pet_date) + 추가 Bucket(13*7)  
 * 2018.12.26   KSW         1) 속도개선 : 월말 EOMONTH() 함수로 변경 (참고)주석1-2
                            2) 속도개선 : 조회조건변경 및 조인힌트적용  (참고)주석2-1-1
 * 2019.07.25   KSG         소형 전 구간 LATE 적용
 * 2020.03.23   KSG         [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - Hold VMI 대기 재고 Visibility 강화
 * 2020.05.19   KSG         C20200519-000150 [PI 합의] ESS인 경우 VMI 라도 'DAP' 처리 안 함
 * 2020.10.28   KSG         ESS인 VMI : 'DAP' 처리
 * 2021.03.12   KSG         PJ20209642 Digital SCM Level.3 달성을 위한 개선 : FP Tact Time Table 변경
 * 2021.04.08   SEO         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - SCP 대치BOM 적용
 * 2021.06.07   SEO			PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - ITEM BOD의 유효일자를 BOD의 유효일자로 대체
 * 2021.07.07   KKC			PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - bod View 변경(scp_mst_bod_v -> scp_mst_bod_n_v)
 * 2022.01.17   LHS			PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선: 사업부별 추가 계획수립기간을 lookup으로 설정하여 Engine Plan 기간으로 반영
 * 2022.03.02   LHS			PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선: 사업부별 추가 Demand 구간을  lookup으로 설정하여 반영
 * 2022.04.04   LHS         PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선: JV사업부 추가: 사업부 조건별 로직구현시 division_id 대신 속성값(attribute3) 기준으로 변경
                            ----------------------------------------------------------------
                                    구분                         자동차           전극
                            ==============================    =============   ==============
                              division_group(attribute3)  :        81              EE                
                            ------------------------------    -------------   --------------
                              division_id                 :     81 , 81_UC      EE , EE_UC  
                            ----------------------------------------------------------------
 * 2023.03.07   SHS         PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행: DEMAND SPLIT 옵션 추가
 * 2023.07.07   SHS         PJ20230691  SCM 역량 강화 위한 SCP 개선과제 이행: n-ERP 활성화 코드 분리
 * 2023.08.08   SHS         PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2 : 소형CAPA 분리 & 튜닝
 * 2023.09.12   KKC         PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2 : 소형CAPA 분리 & 튜닝 / Default MAX DAILY CAPA 수량 지정
                            너무 작은 단위의 Daily Capa 셋팅시 DEMAND SPLIT이 너무 많이 되어 계획 수립에 지대한 영향을 줌.
 * 2024.05.20   KKC         PJ20244573  LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성 : 자동차 판매/완제품 대치 모델링 추가
 * 2024.06.26   KKC         PJ20244573  LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성 : 자동차 판매/완제품 대치 모델링 추가 (JV도 포함)
 * 2024.12.16   KKC         PJ20249346  LGES SCP 개선과제 이행 : 속도지연 쿼리 일부 개선
 * 2025.04.10   KJJ         E20250310-000135 셀 생산지별 공급계획 수립 엔진기능 개발         
 * 2025.12.04   YMH			E20251027-000120 DEMAND GROUP MASTER ESS 사업부 추가
 */

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_IN_PRE_PROC_DEMAND_ATTRIBUTE] 
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

) 
AS
  BEGIN
    --SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    --SET XACT_ABORT ON;
    --SET ANSI_WARNINGS OFF;   

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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_IN_PRE_PROC_DEMAND_ATTRIBUTE';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'TH_ENG_DEMAND_ATTRIBUTE';
    DECLARE @d_event_date   DATETIME;

    DECLARE @n_pre_plan_id       INTEGER = 0;
    DECLARE @n_cur_plan_id       INTEGER = 0;
    DECLARE @n_pre_week_plan_id  INTEGER = 0;
    DECLARE @n_cur_week_plan_id  INTEGER = 0;
    
     -- DECLARE @v_division_id       NVARCHAR(30);
    DECLARE @v_cur_monday        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    DECLARE @v_demand_cutoff_day NVARCHAR(8) ; --= CONVERT(CHAR(8), DATEADD(DD, -6, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 화요일 YYYYMMDD
    DECLARE @v_pet_date          NVARCHAR(8) ; -- Plan End Date
    DECLARE @d_plan_name         DATETIME = CONVERT(DATETIME, @p_plan_name) ;
	DECLARE @v_add_pet_date      NVARCHAR(8) ; -- 추가기간 반영된 Plan End Date 
    
    DECLARE @v_division_group   NVARCHAR(30);  ---(2022.04.04) 변수추가 
    DECLARE @v_division_comp    NVARCHAR(30); 

    DECLARE @v_dm_max_version   NVARCHAR(200) ; --2024.12.16 추가

    /*------------------------------------------------------------------
        * Division Group 정의  (2022.04.04: Joint Venture 사업부 추가)
        - JV사업부 코드(81_UC, EE_UC)추가되면서 사업부별 로직분개시 division_id만으로는 구분값으로 활용 불가.
        - 40, 81, 82, EE 등 사업부별 로직전개에 사용할 기준값을 (attribute3)컬럼에 정의하고 변수 '@v_division_group'로 처리
        - 기존의 division_id 분개로직을 division_group 기준으로 대체하여 사용한다.
        - 예) division_group: 81 >> division_id: 81 , 81_UC >>  division_comp: LG , UC 
    ----------------------------------------------------------------------*/ 
    SELECT @v_division_group   =  di.attribute3  
         , @v_division_comp    =  di.attribute4   -- 회사코드
    FROM   scm_mst_division di WITH(NOLOCK)
    WHERE  di.valid_yn         =  'Y' 
    AND    di.division_id      =  @p_division_id    ; 

    /* Default MIN Daily Capa 수량 추가 */
    DECLARE @v_DEFAULT_MAX_DAILY_CAPA INTEGER = 10000;
    
    -- DEMAND 그룹핑
    -- 20180618 주석처리함 (사용안함)
    --DECLARE @n_demand_term INT = 28;--그룹핑 기준일자 : Net Demand(PR_SCP_ENG_IN_PRE_PROC_NET_DEMAND) 에도 동일 정보 있음

  -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN
       
        --  Plan End Date
        SELECT /** @v_pet_date      =   p.horizon_end_date  --> (2022.03.02) 이전 코드 주석처리 **/
               @v_pet_date      = CONVERT(NVARCHAR(8), DATEADD(dd, ISNULL(c.dm_add_day,0), CONVERT(DATETIME, P.horizon_end_date)), 112)   --- (2022.03.02) Demand 추가기간 반영
	        ,  @v_add_pet_date  = CONVERT(NVARCHAR(8), DATEADD(dd, ISNULL(B.add_day, (13*7)), CONVERT(DATETIME, P.HORIZON_END_DATE)), 112)   -- 추가기간이 NULL이면 디폴트 13주 설정 
        FROM   dbo.scm_mst_plan p WITH(NOLOCK)
        LEFT OUTER JOIN 
                (   /** (2022.01.17) 사업부별 추가계획기간 lookup으로 반영. 단위:week  **/ 
                SELECT a.SEGMENT1 as DIVISION_ID , a.segment2 as ADD_WEEK , A.segment2*7 AS ADD_DAY 
                FROM   scm_adm_lookup_master_detail a(nolock)
                WHERE  a.lookup_type = 'ADD_PLAN_PERIOD'
                and    a.valid_yn    = 'Y' 
                ) B
                ON ( 1=1
                AND  P.DIVISION_ID  =  B.DIVISION_ID )  
        LEFT OUTER JOIN 
                (   /** (2022.03.02) 사업부별 추가 Demand 반영구간을 Lookup에서 가져온다. 단위:week  **/
		        SELECT a.segment1 as division_id , a.segment2 as dm_add_week , a.segment2*7 as dm_add_day 
		        FROM   scm_adm_lookup_master_detail a(nolock)
		        WHERE  a.lookup_type = 'ADD_DEMAND_PERIOD'
		        and    a.valid_yn    = 'Y' 
                ) AS C 
                ON ( 1=1
                AND  p.division_id = c.division_id ) 
        WHERE  p.division_id = @p_division_id 
        AND    p.plan_id     = @p_plan_id 
        ; 

        -- 최근 3일 이내 최신 버전
	    SELECT @v_demand_cutoff_day = ISNULL(MAX(p.cutoff_yyyymmdd)
                                           , CONVERT(CHAR(8), DATEADD(DD, -6, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 당주 화요일 YYYYMMDD
                                            )
        FROM   dbo.dm_pln_net_demand p WITH(NOLOCK)
        WHERE  p.division_id      = @p_division_id 
        AND    p.cutoff_yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -3, @d_plan_name), 112) -- 최근 3일 이내
        ;

        /* DM의 max version 2024.12.16 추가 */
	    SELECT @v_dm_max_version = MAX(p.version_no)
          FROM dbo.dm_pln_net_demand p WITH(NOLOCK)
         WHERE p.division_id      = @p_division_id 
           AND p.cutoff_yyyymmdd  = @v_demand_cutoff_day
        ;

        -------------------------------------------------------------
        -- scm_mst_site_item_priority_v 정보 임시테이블 생성. 실행계획단순화, 2024.12.16 추가
        -------------------------------------------------------------
        IF OBJECT_ID('tempdb..#scm_mst_site_item_priority_v') IS NOT NULL
        BEGIN 
            DROP TABLE  #scm_mst_site_item_priority_v;
        END 
        
        SELECT  a.*
          INTO #scm_mst_site_item_priority_v
          FROM scm_mst_site_item_priority_v a WITH(NOLOCK)
        WHERE a.division_id   = @p_division_id  
          AND a.to_yyyymmdd   > @p_plan_name
        ; 

        -----------------------------------------------------------
        -- 1. DEMAND 생성 

        --    - 여기서는 demand_attribute 생성을 위한 th_eng_demand_sn 테이블의 초기값만 생성함 
        --      최종 th_eng_demand_sn테이블의 데이터 생성은 
        --      PR_SCP_ENG_IN_PRE_PROC_NET_DEMAND 프로시저에서 생성완료함             
        -----------------------------------------------------------
        
        DELETE /* PR_SCP_ENG_IN_PRE_PROC_DEMAND_ATTRIBUTE */
        FROM   th_eng_demand_sn
        WHERE  master_id = @p_master_id
        AND    plan_id   = @p_engine_plan_id 
        ;
        -----------------------------------------------------------
        
        -----------------------------------------------------------
        -- 1-1) 그룹핑 작업을 위한 임시테이블 생성
        -----------------------------------------------------------        
        IF OBJECT_ID('tempdb..#TH_ENG_NET_DEMAND_TEMP') IS NOT NULL
        BEGIN 
            DROP TABLE #TH_ENG_NET_DEMAND_TEMP;          
        END
        
        CREATE TABLE #TH_ENG_NET_DEMAND_TEMP(
	        MASTER_ID NVARCHAR(50) NOT NULL,
	        PLAN_ID NVARCHAR(50) NOT NULL,
	        DEMAND_ID NVARCHAR(200) NOT NULL, --20180827 NVARCHAR(100)-> NVARCHAR(200) 수정
	        SALES_MODEL_ID NVARCHAR(150) NULL,
	        SHIPPING_DATE DATETIME NOT NULL,
	        DUE_DATE DATETIME NULL,
	        DUE_FENCE_DATE DATETIME NULL,
	        EARLY_PRODUCING_TERM NUMERIC(20, 10) NULL,
	        EARLY_PRODUCING_TERM_UOM NVARCHAR(10) NULL DEFAULT ('DAY'),
	        QTY NUMERIC(20, 10) NOT NULL,
	        SPLIT_QTY NUMERIC(20, 10) NULL,
	        ORDER_TYPE NVARCHAR(10) NULL,
	        DEMAND_TYPE NVARCHAR(10) NULL,
	        PRODUCING_TYPE NVARCHAR(10) NULL DEFAULT ('EPST'),
	        PRIORITY_GROUP_CODE NVARCHAR(150) NULL,
	        PRIORITY NVARCHAR(200) NULL,
	        ATTRIBUTE_CHECKER_ID NVARCHAR(150) NULL,
	        DEMAND_GROUP_ID NVARCHAR(200) NULL,  --20180827 NVARCHAR(100)-> NVARCHAR(200) 수정
	        LATE_TYPE NVARCHAR(50) NULL,
	        DESCR NVARCHAR(2000) NULL,
	        MOVE_TIME_RATE NUMERIC(20, 10) NULL DEFAULT ((1)),
	        BUFFER_TIME_RATE NUMERIC(20, 10) NULL DEFAULT ((1)),
	        IS_EXCEPTION NVARCHAR(10) NULL DEFAULT ('N'),
	        --IS_CONSUME NVARCHAR(10) NULL DEFAULT ('Y'),
	        ITEM NVARCHAR(300) NULL,
	        SITE NVARCHAR(300) NULL,
	        SCM_SITE NVARCHAR(300) NULL            
          , PROJECT_CODE NVARCHAR(300) NULL                -- 20180322 추가 
          , PLANT_SITE_ID NVARCHAR(300) NUll               -- 20180312 추가    
          , ORG_CELL_SITE_ID NVARCHAR(300) NULL            -- 20180411 추가 (demand의 plant_site_id가 팩('P')사이트일때 팩사이트와 동일한 plant_id의 셀('A')사이트)
          , ORG_ELEC_SITE_ID NVARCHAR(300) NULL            -- 20180411 추가 (demand의 plant_site_id가 팩일때는 동일한 plant_id의 셀사이트의 site_id, 셀사이트일때 동일한 site_id의 전극사이트)           
          , AVG_SETUP_TIME   NUMERIC(20,10) NULL           -- 20180322 추가 동일 setup group id의 평균 setup time
          , CELL_SITE_SETUP_GROUP_ID NVARCHAR(300) NULL    -- 20180322 추가 CELL 선호 site의 setup group id                    
          , CELL_SITE_ID NvARCHAR(300) NULL                -- 20180322 추가 CELL 선호 site
          , CELL_ITEM_ID NVARCHAR(300) NULL                -- 20180322 추가 CELL 선호 site의 item id           
          , MAX_DAILY_CAPA   NUMERIC(18,4) NULL            -- 20180328 추가 daily_capa (cell_item_id에 해당되는 여러 lINE의 DAILY CAPA중 가장큰갑)          
          , MAX_DAILY_CAPA_PACK NUMERIC(18,4) NULL         -- 2023.03.07 추가 daily_capa (pack_item_id에 해당되는 여러 lINE의 DAILY CAPA중 가장큰값)
          , DEMAND_PRIORITY  NVARCHAR(20) NULL             -- 20180621 추가 DM의 우선순위(dm_pln_net_demand.priority값) 
        )
        ;
        
        -----------------------------------------------------------
        -- 1-2) 그룹핑 작업을 위한 임시테이블 데이터 생성
        -----------------------------------------------------------        
       INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_DEMAND_ATTRIBUTE */ #TH_ENG_NET_DEMAND_TEMP --th_eng_demand_sn 
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
	     --is_consume
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
         , demand_priority      -- 20180621 추가(DM의 우선순위) 
       )      
       SELECT  @p_master_id      AS master_id
             , @p_engine_plan_id AS plan_id
             /*
             , a.item_id + '::' + a.project_code + '::' + a.scm_site_id + '~' + a.incoterms
               + '::' + a.dom_exp + '::' + a.fcst_type + '::' + a.demand_type + '::' + a.yyyymmdd
			   + '::' + IIF( REPLACE(a.plant_site_id, ' ', '') = 'NOPLANT' OR RTRIM(a.plant_site_id) = '', ISNULL(a.plant_site_id_pr, 'NOPLANT'), a.plant_site_id) AS demand_id
			   */
			   --+ '::' + IIF( REPLACE(a.plant_site_id, ' ', '') = 'NOPLANT' OR RTRIM(a.plant_site_id) = '', ISNULL(c.plant_site_id, 'NOPLANT'), a.plant_site_id) AS demand_id   
			   -- 2025.04.10 셀 생산지별 공급계획 수립 엔진기능 개발 수정
             , a.item_id + '::' + a.project_code + '::' + a.scm_site_id + '~' + a.incoterms
               + '::' + a.dom_exp + '::' + a.fcst_type + '::' + a.demand_type + '::' + a.yyyymmdd
			   + '::' + IIF( REPLACE(a.plant_site_id, ' ', '') = 'NOPLANT' OR RTRIM(a.plant_site_id) = '', ISNULL(a.plant_site_id_pr, 'NOPLANT'), a.plant_site_id)
			   + '::' + IIF( REPLACE(a.cell_prod_site_id, ' ', '') = 'NOPLANT' OR RTRIM(a.cell_prod_site_id) = '', ISNULL(a.cell_prod_site_id, 'NOPLANT'), a.cell_prod_site_id) AS demand_id
             , a.item_id + '^' + a.scm_site_id + '~' + a.incoterms + '^S' AS sales_model_id             
             --, a.item_id + '^' + a.scm_site_id + '~' + a.incoterms + '^S'     AS sales_model_id             
             -- shipping_date가 플랜시작일자보다 작으면 shipping_date를 플랜시작일자로 사용함
             , IIF( @d_plan_name > CONVERT(DATE, a.yyyymmdd_org), @d_plan_name,CONVERT(DATE, a.yyyymmdd_org))    AS shipping_date --20180619 수정 dm_pln_net_demand.yyyymmdd값 (변경전 : , CONVERT(DATE, a.yyyymmdd) AS shpping_date --dm_pln_net_demand.attribute1 값  ) 
             
             , CONVERT(DATE, a.yyyymmdd)       AS due_date
			 , @v_add_pet_date                 AS due_fence_date   -- (2022.01.17) 사업부별 engine plan end date 설정
           /* -- Due Fence Date 설정 : ESS(82) - PET Date + 13주 / 자동차(81) - PET Date + 13주 / 소형(40) - PET Date + 13주
            , CASE WHEN @p_division_id = '81' THEN  DATEADD(DD, 13*7, CONVERT(DATE, @v_pet_date))
                    WHEN @p_division_id = '82' THEN  DATEADD(DD, 13*7, CONVERT(DATE, @v_pet_date))
                    -- 20190725 소형 전 구간 LATE 적용
                    WHEN @p_division_id = '40' THEN  DATEADD(DD, 13*7, CONVERT(DATE, @v_pet_date)) -- 월 Fence 로 처리 시 PR_SCP_ENG_IN_PRE_PROC_FIX_MISMATCHING 수정필요
                   /* -- 20190725 변경전 START
                    -- 20181010 추가  late_type = 'SHIPMENT_LATE' 일때 due_date이 플랜종료월(@v_pet_date)과 같을 경우 플랜종료일을 due_fence_date값으로 셋팅함
                    WHEN @p_division_id = '40' AND LEFT(a.yyyymmdd, 6) = LEFT(@v_pet_date, 6) THEN  @v_pet_date 
                     WHEN @p_division_id = '40' THEN EOMONTH(a.yyyymmdd) --20181226 수정 월말 일자
					*/-- 20190725 변경전 END
               END */ -- (2022.01.17 주석처리)
             -- 그룹핑 시작일자와 due_date의 차이일수를 입력한다. 
             -- ( 그룹핑시작일자 : 20180312일경우 due_date 20180313이면 => 1 이 들어감, 20180312일경우 due_date 20180314이면 => 2 들어감...)
             -- ksg 20180522 7일 추가 반영
             , NULL AS early_producing_term -- 20180618 수정 PR_SCP_ENG_IN_PRE_PROC_NET_DEMAND에서 값설정함 ( 변경전 : , DATEDIFF( d, CONVERT(DATETIME,@p_plan_name), CONVERT(DATE, a.yyyymmdd)) % @n_demand_term + 7 AS early_producing_term --20180522 수정 (변경전 : , DATEDIFF( d, CONVERT(DATETIME,@p_plan_name), CONVERT(DATE, a.yyyymmdd)) % @n_demand_term AS early_producing_term) )
             
             , 'DAY'            AS early_producing_term_uom
             , ISNULL(a.qty, 0) AS qty
             , ISNULL(a.qty, 0) AS split_qty
             
             , LEFT(a.fcst_type,10)   AS order_type  --참고) order_type(NVARCHAR(10) 인데 fact_type(NVARCHAR(20) 으로 10자리로 입력 )            
             
             , a.demand_type    AS demand_type
             
             , 'EPST'           AS producing_type        --  'LPST'  -- 20180212 티라 김동범수석 요청
             , '1'              AS priority_group_code
             , dbo.FN_ZERO_LPAD(ISNULL(a.demand_priority, 1), 10) AS priority
             , NULL AS attribute_checker_id

              --20180312 수정
			  /*
             , a.item_id + '::' + a.project_code + '::' + a.scm_site_id + '~' + a.incoterms
               + '::' + a.dom_exp + '::' + a.fcst_type + '::' + a.demand_type + '::' + a.yyyymmdd 
               + '::' + IIF( REPLACE(a.plant_site_id, ' ', '') = 'NOPLANT' OR RTRIM(a.plant_site_id) = '', ISNULL(a.plant_site_id_pr, 'NOPLANT'), a.plant_site_id) AS demand_group_id
			   */
               --+ '::' + IIF( REPLACE(a.plant_site_id, ' ', '') = 'NOPLANT' OR RTRIM(a.plant_site_id) = '', ISNULL(c.plant_site_id, 'NOPLANT'), a.plant_site_id) AS demand_group_id
             -- 2025.04.10 셀 생산지별 공급계획 수립 엔진기능 개발 수정
             , a.item_id + '::' + a.project_code + '::' + a.scm_site_id + '~' + a.incoterms
               + '::' + a.dom_exp + '::' + a.fcst_type + '::' + a.demand_type + '::' + a.yyyymmdd
			   + '::' + IIF( REPLACE(a.plant_site_id, ' ', '') = 'NOPLANT' OR RTRIM(a.plant_site_id) = '', ISNULL(a.plant_site_id_pr, 'NOPLANT'), a.plant_site_id)
			   + '::' + IIF( REPLACE(a.cell_prod_site_id, ' ', '') = 'NOPLANT' OR RTRIM(a.cell_prod_site_id) = '', ISNULL(a.cell_prod_site_id, 'NOPLANT'), a.cell_prod_site_id) AS demand_group_id
             --(2022.04.04) JV사업부 추가 건 변수변경 : p_division_id -> @v_division_group
             , CASE WHEN @v_division_group = '81' THEN 'FENCEDATE_OVERLAP' 
                    WHEN @v_division_group = '82' THEN 'FENCEDATE_OVERLAP'
                    -- 20190725 소형 전 구간 LATE 적용
                    WHEN @v_division_group = '40' THEN 'FENCEDATE_OVERLAP'  -- 'SHIPMENT_LATE' 로 처리 시 PR_SCP_ENG_IN_PRE_PROC_FIX_MISMATCHING 수정필요
               END  AS late_type

            /*  20220404 변경전
             , CASE WHEN @p_division_id = '81' THEN 'FENCEDATE_OVERLAP'    
                    WHEN @p_division_id = '82' THEN 'FENCEDATE_OVERLAP'
                    -- 20190725 소형 전 구간 LATE 적용
                    WHEN @p_division_id = '40' THEN 'FENCEDATE_OVERLAP' -- 'SHIPMENT_LATE' 로 처리 시 PR_SCP_ENG_IN_PRE_PROC_FIX_MISMATCHING 수정필요
				    /* -- 20190725 수정전 START
                    WHEN @p_plan_type <> 'TE' AND @p_division_id = '40' THEN 'SHIPMENT_LATE'     --20181112 수정 (변경전 : WHEN @p_division_id = '40' THEN 'SHIPMENT_LATE')
                    WHEN @p_plan_type =  'TE' AND @p_division_id = '40' THEN 'FENCEDATE_OVERLAP' --20181112 추가
			        */  -- 20190725 수정전 END
               END  AS late_type  */ 
             , a.dom_exp + '::' + a.fcst_type + '::' + a.demand_type AS descr --20180309 티라요청으로 수정
             , 1                                 AS move_time_rate
             , 1                                 AS buffer_time_rate
             , 'N'                               AS is_exception
             , a.item_id                         AS item
             , a.scm_site_id + '~' + a.incoterms AS site
             , a.scm_site_id                     AS scm_site
             
             , a.project_code AS project_code    -- 20180322 추가
           
             , IIF( REPLACE(a.plant_site_id, ' ', '') = 'NOPLANT' OR RTRIM(a.plant_site_id) = '', ISNULL(a.plant_site_id_pr, 'NOPLANT'), a.plant_site_id)  AS plant_site_id --20180312 추가
             --, IIF( REPLACE(a.plant_site_id, ' ', '') = 'NOPLANT' OR RTRIM(a.plant_site_id) = '', ISNULL(c.plant_site_id, 'NOPLANT'), a.plant_site_id)  AS plant_site_id --20180312 추가

             --, NULL AS org_cell_site_id          -- 20180411 추가 (demand의 plant_site_id가 팩('P')사이트일때 팩사이트와 동일한 plant_id의 셀('A')사이트)        
			 , a.cell_prod_site_id AS org_cell_site_id --2025.04.10 추가	
             , NULL AS org_elec_site_id          -- 20180411 추가 (demand의 plant_site_id가 팩일때는 동일한 plant_id의 셀사이트의 site_id, 셀사이트일때 동일한 site_id의 전극사이트) 

            
             , NULL AS avg_setup_time            -- 20180322 추가 동일 setup group id의 평균 setup time 
             , NULL AS cell_site_setup_group_id  -- 20180322 추가 CELL 선호 site의 setup group id
			 , NULL AS cell_site_id              -- 20180322 추가 CELL 선호 site
             , NULL AS cell_item_id      -- 20180322 추가 CELL 선호 site의 item id  
             , NULL AS max_daily_capa            -- 20180328 추가 cell_item_id 의 가장큰 Daily capa 값             
             , a.demand_priority AS demand_priority -- 20180621  추가(dm의 우선순위)
        FROM  (--------------------------------
		       -- 1. VMI 아닌 Site 
			   --------------------------------
		       SELECT aa.division_id
                    , aa.version_no
                    , aa.cutoff_yyyymmdd		                          
                    , aa.project_code					 
                    , aa.scm_site_id
                    , aa.item_id
                    , aa.dom_exp
                    , aa.fcst_type
                    , aa.incoterms  AS incoterms     -- 20180716수정( 변경전 : , aa.incoterms )                    
                    , aa.plant_site_id
                      --2024.12.16 테이블 변경
                    ,(SELECT TOP 1 plant_site_id
                        FROM #scm_mst_site_item_priority_v c -- 20180323 scm_mst_site_item_priority_v (scm_mst_site_item_priority 테이블의 valid_yn = 'Y'이면서 priority가  가장작은 데이터 조회됨)
                       WHERE aa.division_id  = c.division_id  
                      --(2022.04.04) JV사업부 추가 변수변경 :  p_division_id -> @v_division_group
                         AND IIF(@v_division_group IN ('82', '40'), '*', aa.project_code) = IIF(@v_division_group IN ('82', '40'), '*', c.project_code)
                         AND IIF(@v_division_group IN ('82', '40'), '*', aa.scm_site_id ) = IIF(@v_division_group IN ('82', '40'), '*', c.sales_site_id)
                         AND aa.item_id      = c.item_id 
                         -- 20180312 수정 =========================> ksg 로직정의후 추후 수정 필요함 ( 현재는 임시로 due_date 기준으로 처리함 )
                         AND c.from_yyyymmdd <= aa.attribute1    -- due_date
                         AND c.to_yyyymmdd   >= aa.attribute1 
                     ) AS plant_site_id_pr      
                    , aa.demand_type
                    , aa.attribute1  AS yyyymmdd -- 20180525 수정 (변경전 : , yyyymmdd )
                    , aa.demand_priority
                    , aa.qty                    
                    , aa.yyyymmdd AS yyyymmdd_org --20180619 추가
					, aa.cell_prod_site_id --2025.04.10 추가
                 FROM dbo.dm_pln_net_demand aa WITH (NOLOCK)
                   -- 20180716 추가 VMI 대상 site 조회
                  INNER JOIN ( -- VMI 대상 site 조회
                              SELECT division_id, scm_site_id, vmi_yn 
                                FROM scm_mst_site  WITH (NOLOCK)
                               WHERE  division_id = @p_division_id 
                                 AND site_type   = 'SALES' --2024.12.16 추가
                                 AND valid_yn    = 'Y'
                                 AND vmi_yn     <> 'Y'
                             ) mse
                    ON aa.division_id = mse.division_id
                   AND aa.scm_site_id = mse.scm_site_id 
                 WHERE aa.division_id     = @p_division_id
                   AND aa.cutoff_yyyymmdd = @v_demand_cutoff_day  -- @v_demand_cutoff_day 는 화요일 일자(YYYYMMDD)
                   AND aa.version_no      = @v_dm_max_version     -- 2024.12.16 추가
                   AND aa.attribute1     >= @p_plan_name          -- Plan 구간 내 Demand
                   AND aa.attribute1     <= @v_pet_date           -- Plan 구간 내 Demand
                   AND aa.qty            >  0     
				 --------------------------------
				 -- 2. VMI Site
				 --------------------------------
                 UNION
				 SELECT aa.division_id
                    , aa.version_no
                    , aa.cutoff_yyyymmdd		                          
                    , aa.project_code					 
                    , aa.scm_site_id
                    , aa.item_id
                    , aa.dom_exp
                    , aa.fcst_type
                    -- 20180716scm_site_id(to site) 가 vmi 일때 incoterms를 'DAP'로 설정함 ( 참고) DAP 처리시  inventory 'DAP'처리부분도 함께 수정해야 함) 
                    , 'DAP'                   AS incoterms     -- 20180716수정( 변경전 : , aa.incoterms )                    
                    , aa.plant_site_id
                      --테이블 변경, 2024.12.16
                    ,(SELECT TOP 1 plant_site_id
                        FROM #scm_mst_site_item_priority_v c -- 20180323 scm_mst_site_item_priority_v (scm_mst_site_item_priority 테이블의 valid_yn = 'Y'이면서 priority가  가장작은 데이터 조회됨)
                       WHERE aa.division_id  = c.division_id  
                      --(2022.04.04) JV사업부 추가 변수변경 :  p_division_id -> @v_division_group
                         AND IIF(@v_division_group IN ('82', '40'), '*', aa.project_code) = IIF(@v_division_group IN ('82', '40'), '*', c.project_code)
                         AND IIF(@v_division_group IN ('82', '40'), '*', aa.scm_site_id ) = IIF(@v_division_group IN ('82', '40'), '*', c.sales_site_id)
                         AND aa.item_id      = c.item_id 
                      -- 20180312 수정 =========================> ksg 로직정의후 추후 수정 필요함 ( 현재는 임시로 due_date 기준으로 처리함 )
                         AND c.from_yyyymmdd <= aa.attribute1    -- due_date
                         AND c.to_yyyymmdd   >= aa.attribute1 
                     ) AS plant_site_id_pr
                    , aa.demand_type
                    , aa.attribute1           AS yyyymmdd -- 20180525 수정 (변경전 : , yyyymmdd )
                    , MIN(aa.demand_priority) AS demand_priority
                    , SUM(aa.qty)             AS qty              
                    , MIN(aa.yyyymmdd)        AS yyyymmdd_org --20180619 추가
					, aa.cell_prod_site_id --2025.04.10 추가
                 FROM   dbo.dm_pln_net_demand aa WITH (NOLOCK)
                        -- 20180716 추가 VMI 대상 site 조회
                        INNER JOIN ( -- VMI 대상 site 조회
                                    SELECT division_id, scm_site_id, vmi_yn 
                                    FROM   scm_mst_site  WITH (NOLOCK)
                                    WHERE  division_id = @p_division_id 
                                      AND site_type   = 'SALES' --2024.12.16 추가
                                      AND  valid_yn    = 'Y'
                                      AND  vmi_yn      = 'Y'
                                   ) mse
                        ON   aa.division_id = mse.division_id
                        AND  aa.scm_site_id = mse.scm_site_id 
                 WHERE  aa.division_id     = @p_division_id 
                 --AND  aa.division_id    <> '82'                 -- 20201028 ESS 'DAP' 처리 -- C20200519-000150 20200519 [PI 합의] ESS는 'DAP' 처리 안 함
                   AND  aa.cutoff_yyyymmdd = @v_demand_cutoff_day -- @v_demand_cutoff_day 는 화요일 일자(YYYYMMDD)
                   AND  aa.version_no      = @v_dm_max_version    -- 2024.12.16 추가
                   AND  aa.attribute1     >= @p_plan_name         -- Plan 구간 내 Demand
                   AND  aa.attribute1     <= @v_pet_date          -- Plan 구간 내 Demand
                   AND  aa.qty            >  0      
				 GROUP BY aa.division_id, aa.version_no, aa.cutoff_yyyymmdd, aa.project_code, aa.scm_site_id
                        , aa.item_id, aa.dom_exp, aa.fcst_type, aa.plant_site_id, aa.demand_type, aa.attribute1
						, aa.cell_prod_site_id --2025.04.10 추가
               )  a
               /* 불필요한 테이블 join 제거. 2024.12.16
               INNER JOIN ( SELECT division_id, max(version_no) max_version_no
                            FROM   dbo.dm_pln_net_demand WITH(NOLOCK)
                            WHERE  division_id     = @p_division_id       
                            AND    cutoff_yyyymmdd = @v_demand_cutoff_day -- @v_demand_cutoff_day 는 화요일 일자(YYYYMMDD)
                            GROUP BY  division_id
                          ) b
               ON  a.division_id = b.division_id
               AND a.version_no  = b.max_version_no                 
               INNER JOIN dbo.scm_mst_site s WITH(NOLOCK)
               ON   a.division_id = s.division_id
               AND  a.scm_site_id = s.scm_site_id 
               AND  s.site_type   = 'SALES'
               AND  s.valid_yn    = 'Y'
               */
               --LEFT JOIN  scm_mst_site_item_priority_v c -- 20180323 scm_mst_site_item_priority_v (scm_mst_site_item_priority 테이블의 valid_yn = 'Y'이면서 priority가  가장작은 데이터 조회됨)
               --ON   a.division_id  = c.division_id  --@p_division_id
               --AND  IIF(@p_division_id IN ('82', '40'), '*', a.project_code) = IIF(@p_division_id IN ('82', '40'), '*', c.project_code)
               --AND  IIF(@p_division_id IN ('82', '40'), '*', a.scm_site_id ) = IIF(@p_division_id IN ('82', '40'), '*', c.sales_site_id)
               --AND  a.item_id      = c.item_id 
               ---- 20180312 수정 =========================> ksg 로직정의후 추후 수정 필요함 ( 현재는 임시로 due_date 기준으로 처리함 )
               --AND  c.from_yyyymmdd <= a.yyyymmdd    -- due_date
               --AND  c.to_yyyymmdd   >= a.yyyymmdd 			   
               -- 상품/원자재 Demand는 엔진에 반영하지 않음 : 한 site의 Q/R이 다른 Site에서는 P/H일 수 있음
               LEFT OUTER JOIN (SELECT DISTINCT division_id, item_id, MAX(item_type) AS item_type
                                FROM   dbo.scm_mst_item_sn WITH (NOLOCK)
                                WHERE  division_id = @p_division_id       
                                AND    item_type    NOT IN ('Q', 'R')
                                GROUP BY division_id, item_id
                               ) d
               ON  a.division_id = d.division_id
               AND a.item_id     = d.item_id			   
               -- 전극 모델은 제외 : ksg 20180517
               INNER JOIN (SELECT DISTINCT division_id, item_id
                           FROM   dbo.scm_mst_item_sn WITH (NOLOCK)
                           WHERE  division_id = @p_division_id       
                           AND    active_flag = 'Y' 
                           AND    scp_operation_group <> 'E' -- 전극제외
                          ) e
               ON  a.division_id = e.division_id
               AND a.item_id     = e.item_id
        WHERE  d.item_id        IS NOT NULL
        ;

        /* 자동차 판매/완제품 대치 모델링, 2024.05.20 추가
           SALES 모델ID를 사업부별 규칙에 맞게 재설정
           자동차   : PROJECT CODE + GROUP_CD + DM MODEL + SALES SITE
           자동차외 : DM MODEL + SALES SITE
         */
		 -- E20251027-000120 DEMAND GROUP MASTER 기존 81만에서 81 OR 82 로 82 추가.
        IF @v_division_group = '81' OR @v_division_group = '82'

        BEGIN
        ; WITH VW_ALT_PRODUCT AS (
                                  SELECT a.*
                                    FROM
                                       (
                                        SELECT a.project_code
                                             , a.group_id
                                             , a.item_id
                                             , COUNT(a.item_id) OVER(PARTITION BY a.project_code
                                                                                , a.group_id
                                                                    ) AS project_item_cnt      
                                          FROM SCP_MST_ITEM_GROUP_DETAIL a WITH (NOLOCK)
                                         WHERE a.division_id = @p_division_id --20240626 변경, JV추가
                                           AND a.valid_yn    = 'Y'
                                           AND EXISTS (SELECT 'x'
                                                         FROM SCP_MST_ITEM_GROUP x WITH (NOLOCK)
                                                        WHERE x.division_id = a.division_id
                                                          AND x.valid_yn    = 'Y'
                                                          AND x.group_id    = a.group_id
                                                      )
                                         ) a
                                 WHERE a.project_item_cnt > 1
                                ) 
        UPDATE a
           SET a.sales_model_id = CASE WHEN b.item_id IS NOT NULL THEN a.project_code +'::'+ b.group_id +'^'+ a.item + '^' + site + '^S'
                                       ELSE a.project_code+'::'+'NONE'+'^'+ a.item + '^' + site + '^S'
                                   END
          FROM #TH_ENG_NET_DEMAND_TEMP a
          LEFT OUTER JOIN VW_ALT_PRODUCT b
            ON a.project_code = b.project_code
           AND a.item         = b.item_id 
        ;
        END

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 1-2 END';
        SET @v_description = N'1-2. DM Demand 정보 INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id  ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
        -- 2.  DEMAND ATTRIBUTE 생성
        -----------------------------------------------------------
        
        DELETE /* PR_SCP_ENG_IN_PRE_PROC_DEMAND_ATTRIBUTE */
        FROM   th_eng_demand_attribute_sn
        WHERE  master_id = @p_master_id
        AND    plan_id   = @p_engine_plan_id 
        ;
        -----------------------------------------------------------       
	    -----------------------------------------------------------
        -- 2-1-1) Demand의 item의 BOM상의 하위 item  정보 임시테이블로 생성
        --> 2024.05.20
        --  ALTER PRODUCT 기준의 하위BOM까지 탐색하지말자~ 
        --  어차피 Final Item기준으로 재고Netting이 골자이고, 하위 계획은 Default 1순위만 수립하기로 했으니까?
        --  ALTER PRODUCT의 하위 BOM까지 찿으면 속도가 안 나오고, 대체로 수립하는 결과도 의미 없음
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#DEMAND_ITEM_BOM_TEMP') IS NOT NULL
        BEGIN 
            DROP TABLE  #DEMAND_ITEM_BOM_TEMP;
        END 
        
        SELECT DISTINCT 
                 dm.demand_id 
               , dm.project_code
               , dm.item
               , dm.scm_site 
               , CONVERT(NVARCHAR(8), dm.due_date, 112) AS due_date               
               , t.parent_item_id -- 20180618 추가
               , t.child_item_id
               , t.accumulated_child_qty --20180521 추가 
               , dm.plant_site_id
               , v.operation_group_id AS child_item_operation_group
               , dm.demand_item_operation_group
			   , dm.org_cell_site_id -- 2025.04.10 추가
          INTO   #DEMAND_ITEM_BOM_TEMP
          FROM 
                (SELECT DISTINCT
                        a.demand_id
                      , a.project_code -- 20180503 수정(변경전 : , dbo.fn_scm_split(demand_id, 2, '::') project_code )
                      --, dbo.fn_scm_split(plant_site_id, 2, '-') demand_item_operation_group --20180503 주석처리
                      --, dbo.fn_get_item_operation_group(@p_division_id, a.item) demand_item_operation_group --20180503 추가 ( demand의 plant_site_id가 팩사이트인데 실제로는 셀사이트인경우가 존재하기때문에 demand_item_operation_group 조회함)
                      , b.operation_group_id  AS demand_item_operation_group
                      , a.item
                      , a.scm_site  
                      , a.due_date                          
                      , a.plant_site_id --20180503추가     
					  , a.org_cell_site_id -- 2025.04.10 추가
                 FROM   #TH_ENG_NET_DEMAND_TEMP a --20180827 수정 (변경전 : --FROM   dbo.th_eng_demand_sn a WITH (NOLOCK) )
                        INNER JOIN (SELECT DISTINCT division_id, item_id, operation_group_id FROM scm_mst_final_item_v WITH (NOLOCK)) b
                        ON    a.item = b.item_id
                        AND   b.division_id = @p_division_id  
                ) dm               
               --20181226 속도개선 HASH힌트적용
               INNER HASH JOIN ( SELECT company_id, division_id, site_id, child_item_id, model_id, alt_priority --20180503 alt_priority 추가(alt_id 삭제)
                                 , parent_item_id -- 20180618 추가
                                 , MIN(accumulated_child_qty) AS accumulated_child_qty --20180621 수정 (변경전 : , accumulated_child_qty  --20180521 추가)
                            --FROM   scm_mst_bom_effective_sn x WITH(NOLOCK, INDEX(PK_SCM_MODEL_COMP_EFFECTIVE_DATE)) --20181129 힌트적용(변경전 : FROM   scm_mst_bom_effective_sn x WITH(NOLOCK) ) --20180615 수정 ( 변경전 : FROM   scm_mst_bom_sn  WITH (NOLOCK))
							FROM   scm_mst_bom_effective_sn_V x WITH(NOLOCK)	--2021.04.08 SCP 대치BOM 적용
                            WHERE  division_id = @p_division_id                             
                            --AND  eff_start_date <= @d_plan_name --20180618 추가 (미래구간의 BOM정보를 안가져오지 위해서)
                              AND  eff_end_date   >  @d_plan_name --20180618 추가
                              AND  alt_priority = 'Y'  -- 20230307 추가
							-- 상위가 END된 경우 그 하위 Item 은 제외(20181009수정, 팩->TCO셀->셀 일경우 셀의 상위인 TCO셀의 사용기간(EFF_END_DATE < @d_plan_name일경우)이 종료되었을경우 하위셀은 사용기간이 종료되어야 하는데 종료되지 않아서 아래조건 추가함)
                            /* 주석처리, SELF JOIN으로 LOOP를 안 수행해도, 누적소요량은 동일함. 2023.03.07 수정
							AND    nlevel =  (SELECT COUNT(DISTINCT c.concatenate_item)
                                              --FROM   scm_mst_bom_effective_sn c WITH(NOLOCK, INDEX(PK_SCM_MODEL_COMP_EFFECTIVE_DATE)) --20181129 힌트적용(변경전 : FROM   scm_mst_bom_effective_sn c with(nolock) )
											  FROM   scm_mst_bom_effective_sn_V c WITH(NOLOCK)	--2021.04.08 SCP 대치BOM 적용
                                              WHERE  x.company_id       = c.company_id   --20181011 추가
                                              AND    x.division_id      = c.division_id  --20181011 추가
                                              AND    x.site_id          = c.site_id      --20181011 추가
                                              AND    x.model_id         = c.model_id
                                              AND    x.plant_id         = c.plant_id
                                              AND    x.concatenate_item <>   c.concatenate_item
                                              AND    x.concatenate_item LIKE c.concatenate_item + '^%'
                                              AND    c.eff_end_date     >    @d_plan_name
                                              AND    x.nlevel           <>  c.nlevel  --20181129 추가( x.concatenate_item = 'AMVAGBV15-A1-B04^AMDAU0138A^ACEN1060I-A1-A01' 일경우 'AMVAGBV15-A1-B04^AMDAU0138A^ACEN1060I-A1'도 count에 포함되어 count가 +1 될수 있으므로 조건에 포함한다.)
                                            )
                            */
							--20180621 추가(model_id, parent_item_id, child_item 이 eff_start_date, eff_end_date가 다르면서 동일한 데이터가 존재할수 있으므로 GROUP BY 처리한다)
                            GROUP BY company_id, division_id, site_id, child_item_id, model_id, alt_priority 
                                   , parent_item_id
                           ) t
               ON  dm.item = t.model_id  --20181226 수정 ( 변경전 : ON  dm.item = IIF(dm.demand_item_operation_group = 'E' , t.child_item_id, t.model_id) -- (변경전 : ON     dm.item = t.model_id) )
               AND t.alt_priority = 'Y'  --20180503 수정 ( 변경전 : AND (t.alt_id IS NULL OR t.alt_id = '01') )
               INNER JOIN scm_mst_item_sn i WITH (NOLOCK)
               ON    t.company_id    = i.company_id 
               AND   t.division_id   = i.division_id 
               AND   t.site_id       = i.site_id 
               AND   t.child_item_id = i.item_id
               AND   i.item_type     <> 'R'
               AND   i.active_flag   = 'Y'        --20180525 추가
               AND   i.scp_operation_group <> 'E' --20180523 추가               
               INNER JOIN scm_mst_site_item s WITH (NOLOCK) 
               ON    t.division_id  = s.division_id 
               AND   t.model_id     = s.item_id                
               -- 20180827  아래 주석 내용 으로 대체 해야하나?? LEFT JOIN 변경후 81번일때만 데이터 존재로 변경해야 하나???
               AND   s.project_code = dm.project_code  --@p_project_code
               AND   s.scm_site_id  = dm.scm_site --
               INNER JOIN (SELECT DISTINCT division_id, item_id, operation_group_id FROM scm_mst_final_item_v WITH (NOLOCK)) v
               ON    t.division_id   = v.division_id  
               AND   t.child_item_id = v.item_id
               AND   v.operation_group_id <> 'E' --20180523 추가               
        ;
        
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 2-1-1 END';
        SET @v_description = N'2-1-1 Demand의 item의 BOM상의 하위 item  정보 INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        -----------------------------------------------------------
        -- 2-1-2) Demand의 item의 BOM상의 하위 item  정보 임시테이블로 생성2
        --        - accumulated_child_qty 합계값( 팩일경우 모듈이 여러개 존재할수 있으므로 sum해주어야 한다)

        /*
                참고) accumulated_child_qty 합계확인
                      SELECT accumulated_child_qty, * FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V  
                      WHERE  model_id = 'APPSAPHEV-A1'
                      AND    child_item_id = 'ACPN1038I-B1'
        */
        -----------------------------------------------------------
         IF OBJECT_ID('tempdb..#DEMAND_ITEM_BOM') IS NOT NULL
         BEGIN 
            DROP TABLE  #DEMAND_ITEM_BOM;
         END 
         
         SELECT demand_id, project_code, item, scm_site, due_date, child_item_id
              , plant_site_id, child_item_operation_group, demand_item_operation_group  
              , SUM(accumulated_child_qty) AS accumulated_child_qty
			  , org_cell_site_id -- 2025.04.10 추가
         INTO   #DEMAND_ITEM_BOM
         FROM   #DEMAND_ITEM_BOM_TEMP
         GROUP BY demand_id, project_code, item, scm_site, due_date, child_item_id
                , plant_site_id, child_item_operation_group, demand_item_operation_group
				, org_cell_site_id -- 2025.04.10 추가
         ;
         
          SET @n_log_count = @@ROWCOUNT;
          SET @v_log_type = 'TXN';
          SET @v_log_message = 'PART 2-1-2 END';
          SET @v_description = N'2-1-2 Demand의 item의 BOM상의 하위 item의 accumulated_child_qty 정보 INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
          SET @d_event_date = SYSDATETIME();
          EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date; 


          --DM ITEM에 대해, 완제품 Level에서만 ALT PRODUCT MODEL 추가 등록, 2024.05.20 추가
          --사업부별로 ALT PRODUCT 기준이 틀릴 수 있고, 운영상 영향성으로 자동차 한정해서 구현
          --2024.06.26 자동차 JV 포함으로 변경
		   -- E20251027-000120 DEMAND GROUP MASTER 기존 81만에서 81 OR 82 로 82 추가.
		  IF @v_division_group = '81' OR @v_division_group = '82'
          
          BEGIN

          ;WITH VW_ALT_GROUPPING_ITEM AS (
                                         /* 완제품 대치 모델링 대상 조회 */
                                         SELECT a.*
                                          FROM
                                             (
                                             SELECT a.project_code
                                                  , a.group_id
                                                  , a.item_id
                                                  , COUNT(a.item_id) OVER(PARTITION BY a.project_code
                                                                                     , a.group_id
                                                                         ) project_item_cnt      
                                               FROM SCP_MST_ITEM_GROUP_DETAIL a WITH (NOLOCK)
                                              WHERE a.division_id = @p_division_id --20240626 변경, JV추가
                                                AND a.valid_yn    = 'Y'
                                                AND EXISTS (SELECT 'x'
                                                              FROM SCP_MST_ITEM_GROUP x WITH (NOLOCK)
                                                             WHERE x.division_id = a.division_id
                                                               AND x.valid_yn    = 'Y'
                                                               AND x.group_id    = a.group_id
                                                             )
                                             ) a
                                         WHERE a.project_item_cnt > 1
                              )        
          INSERT INTO #DEMAND_ITEM_BOM
              (
                 demand_id  
               , project_code
               , item
               , scm_site
               , due_date
               , child_item_id
               , plant_site_id
               , child_item_operation_group
               , demand_item_operation_group
               , accumulated_child_qty
			   , org_cell_site_id -- 2025.04.10 추가
               )
          SELECT a.demand_id  
               , a.project_code
               , a.item
               , a.scm_site
               , a.due_date
               --, a.child_item_id
               , c.item_id as new_child_item_id
               , a.plant_site_id
               , a.child_item_operation_group
               , a.demand_item_operation_group
               , a.accumulated_child_qty
                /*
               , b.project_code
               , b.group_id
               , b.project_item_cnt
                */
			   , a.org_cell_site_id -- 2025.04.10 추가
            FROM #DEMAND_ITEM_BOM A
            JOIN VW_ALT_GROUPPING_ITEM B --DM ITEM의 PROJECT별 GROUP CODE 
              ON a.project_code = b.project_code
             AND a.item         = b.item_id
            JOIN VW_ALT_GROUPPING_ITEM c --alt product item
              ON a.project_code = c.project_code
             AND b.group_id     = c.group_id
             AND a.item         <> c.item_id
           WHERE a.item = a.child_item_id
          ; 

          END

          SET @n_log_count = @@ROWCOUNT;
          SET @v_log_type = 'TXN';
          SET @v_log_message = 'PART 2-1-3 END';
          SET @v_description = N'2-1-3 #DEMAND_ITEM_BOM 추가(자동차 완제품 대치 INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
          SET @d_event_date = SYSDATETIME();
          --EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date; 

        -----------------------------------------------------------
        --2-2)  Demand의 item의 BOM상의 하위 item 의 선호사이트 정보 임시테이블로 생성               
        -----------------------------------------------------------
        
        -----------------------------------------------------------
        --2-2)-1) Demand item의 BOM상의 선호사이트 정보 임시테이블로 생성(DEMEND item 기준 plant_site_id 셋팅)
                --  1) Demand의 Plant Site가 Site Item Priority(Item / (Pjt Code / Sales Site) / Due Date) 에 있으면 순위상관없이 모두사용
                
        -----------------------------------------------------------
          IF OBJECT_ID('tempdb..#DEMAND_ATTRIBUTE_SITE_PRIORITY_TEMP') IS NOT NULL
          BEGIN 
              DROP TABLE  #DEMAND_ATTRIBUTE_SITE_PRIORITY_TEMP;
          END 

          SELECT DISTINCT 
                 x.demand_id
               , x.child_item_id
               , x.accumulated_child_qty --20180521 추가  
               , x.plant_site_id  AS top_plant_site_id -- 최상위 plant_site_id ( 최상위 plant_site_id => demand item이  팩일때 : 팩사이트,  셀일때 : 셀사이트, 전극 : 전극사이트 )               
               , x.child_item_operation_group 
               , x.demand_item_operation_group
               , x.project_code
               , x.scm_site
               , x.due_date  --CONVERT(NVARCHAR(8), x.due_date , 112) AS due_date
               , x.item
			   , y.cell_type --2023.07.07 추가
			   , x.org_cell_site_id -- 2025.04.10 추가
          INTO #DEMAND_ATTRIBUTE_SITE_PRIORITY_TEMP
          FROM (   SELECT a.demand_id
                        , a.child_item_id
                        , a.accumulated_child_qty --20180521 추가                          
                         --20180525 수정
                        --, ISNULL(sip.plant_site_id, ISNULL(sip2.plant_site_id, a.plant_site_id)) AS plant_site_id 
                        , sip2.plant_site_id AS plant_site_id --20180525 수정 sip2.plant_site_id 이 NULL 이면 그냥 NULL입력한다.                        
                        , a.child_item_operation_group
                        , a.demand_item_operation_group 
                        , a.project_code 
                        , a.scm_site
                        , a.due_date 
                        , a.item                        
                        -- 20180525 주석처리
                        --, ROW_NUMBER() OVER (PARTITION BY a.demand_id, a.child_item_id, sip2.project_code, sip2.sales_site_id, sip2.item_id ORDER BY sip2.priority, sip2.from_yyyymmdd ) sip2_row_num --sip2 데이터가 여러건조회 될수 있음                        
						, a.org_cell_site_id -- 2025.04.10 추가
                   FROM  #DEMAND_ITEM_BOM a --20180525 수정 ( 변경전 : FROM #DEMAND_ITEM_BOM_TEMP a )
                   LEFT JOIN ( SELECT project_code, sales_site_id, from_yyyymmdd, to_yyyymmdd, item_id 
                                    , plant_site_id, priority                                
                               FROM   scm_mst_site_item_priority WITH (NOLOCK)
                               WHERE  division_id = @p_division_id
                               AND    valid_yn = 'Y'
                             ) sip2                   
                   ON   --(2022.04.04) JV사업부 추가 변수변경 :  p_division_id -> @v_division_group
                        IIF(@v_division_group IN ('82', '40'), '*', a.project_code) = IIF(@v_division_group IN ('82', '40'), '*', sip2.project_code)   -- ESS('82')사업부일때는 scm_mst_site_item_priority테이블에 project_code, sales_plant_id 정보가 없음
                   AND  IIF(@v_division_group IN ('82', '40'), '*', a.scm_site)     = IIF(@v_division_group IN ('82', '40'), '*', sip2.sales_site_id) 
                   AND  a.child_item_id  =  sip2.item_id --20180525 수정 ( 변경전 : AND  a.item        =  sip2.item_id  )
                   AND  a.due_date    >= sip2.from_yyyymmdd
                   AND  a.due_date    <= sip2.to_yyyymmdd
                ) x
            --2023.07.07, CELL TYPE 추가(활성화 코드 분리 관련)
            LEFT OUTER JOIN (SELECT DISTINCT y.item_id, y.cell_type FROM scm_mst_final_item_v y WITH(NOLOCK) WHERE y.division_id = @p_division_id) y
			  ON x.child_item_id = y.item_id
          --WHERE sip2_row_num = 1  --20180525 주석처리
          ;
        
          SET @n_log_count = @@ROWCOUNT;
          SET @v_log_type = 'TXN';
          SET @v_log_message = 'PART 2-2-1 END';
          SET @v_description = N'2-2-1 Demand의 item의 BOM상의 하위 item 의 선호사이트 정보 INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
          SET @d_event_date = SYSDATETIME();
          EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -------------------------------------------------------------
        ----2-3) Demand attribute 정보 임시테이블로 생성
        -------------------------------------------------------------
          IF OBJECT_ID('tempdb..#DEMAND_ATTRIBUTE_TEMP') IS NOT NULL
          BEGIN 
              DROP TABLE  #DEMAND_ATTRIBUTE_TEMP;
          END 
		  
          SELECT DISTINCT 
                 a.demand_id
              ,  a.plant_site_id AS  final_plant_site_id
              ,  mse.eng_scm_site_id 
              ,  a.operation_group --dbo.fn_scm_split(ISNULL(a.plant_site_id, b.plant_site_id), 2, '-') operation_group          
			  ,  a.org_cell_site_id -- 2025.04.10 추가
          INTO   #DEMAND_ATTRIBUTE_TEMP 
          FROM   ( SELECT DISTINCT 
                          demand_id                        
                        --20180525 수정
                        --, CASE WHEN demand_item_operation_group = child_item_operation_group THEN top_plant_site_id  
                        --       WHEN demand_item_operation_group = 'P'         AND  child_item_operation_group = 'A' THEN cell_plant_site_id 
                        --       WHEN demand_item_operation_group IN ('P', 'A') AND  child_item_operation_group = 'E' THEN elec_plant_site_id 
                        --  END  AS plant_site_id 
                       , top_plant_site_id AS plant_site_id --20180525 수정
					   , child_item_operation_group AS operation_group
					   , org_cell_site_id -- 2025.04.10 추가
                    FROM #DEMAND_ATTRIBUTE_SITE_PRIORITY_TEMP -- 20180525 수정 ( 변경전 : FROM   #DEMAND_ATTRIBUTE_SITE_PRIORITY_TEMP5 )
				    --2023.07.07 조건 비교 추가 (활성화 코드 분리 CELL ASSY는 제외)
                   WHERE ISNULL(cell_type, 'X') NOT LIKE 'CA%'
                 ) a                
               LEFT JOIN ( SELECT scm_site_id
                                , CASE WHEN b.gubun = '1' THEN scm_site_id + '~***'
                                       WHEN b.gubun = '2' THEN scm_site_id + '~001'
                                       WHEN b.gubun = '3' THEN scm_site_id + '~002'
                                       WHEN b.gubun = '4' THEN scm_site_id + '~003'
                                  END AS eng_scm_site_id
								, osp_yn  -- 2025.04.15 추가 보완
                           FROM scm_mst_site a WITH (NOLOCK)
                              , ( SELECT '1' gubun UNION ALL SELECT '2' UNION ALL SELECT '3' UNION ALL SELECT '4') b
                           WHERE a.division_id = @p_division_id 
                           AND   a.valid_yn = 'Y'    
                           AND   a.site_type = 'PLANT'
                           AND   ( (a.operation_group = 'E' AND b.gubun IN ( '1', '3', '4') )
                                   OR 
                                   (a.operation_group = 'A' AND ISNULL(a.osp_yn, 'N') = 'N' AND b.gubun IN ('3', '4') )  --2023.07.07 수정 (활성화 코드 분리, CELL PRODOCUT 모델링 기준)
                                   OR 
                                   (a.operation_group = 'A' AND ISNULL(a.osp_yn, 'N') = 'Y' AND b.gubun = '1')           --20180822 추가
                                   OR
                                   (a.operation_group = 'P' AND ISNULL(a.osp_yn, 'N') = 'N' AND b.gubun IN ( '1', '4') ) --20180822 수정 ( 변경전 : (a.operation_group = 'P' AND b.gubun IN ( '1', '4') ) )
                                   OR
                                   (a.operation_group = 'P' AND ISNULL(a.osp_yn, 'N') = 'Y' AND b.gubun = '1')           --20180822 추가  -- 20180717 팩분리(~***, ~003) 수정  (변경전 : a.operation_group = 'P' AND b.gubun = '1' )                                   
                                 )
                        ) mse
               ON   a.plant_site_id = mse.scm_site_id 
		  -- 2025.04.15 추가 보완
          WHERE (CASE WHEN '40' = '40' AND a.operation_group = 'A' and mse.osp_yn = 'N'
				      THEN CASE WHEN LEN(a.org_cell_site_id) < 4 
					            THEN a.plant_site_id
								ELSE a.org_cell_site_id
						   END
					  ELSE a.plant_site_id
                 END) = mse.scm_site_id 
         ;

         SET @n_log_count = @@ROWCOUNT;
         SET @v_log_type = 'TXN';
         SET @v_log_message = 'PART 2-3 END';
         SET @v_description = N'2-3 Demand attribute 기본 정보 INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
         SET @d_event_date = SYSDATETIME();
         EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        -----------------------------------------------------------
        -- 2-4)  Demand Attribue 정보 임시테이블로 생성
        -----------------------------------------------------------
         IF OBJECT_ID('tempdb..#DEMAND_ATTRIBUTE') IS NOT NULL
         BEGIN 
             DROP TABLE  #DEMAND_ATTRIBUTE;
         END 

         SELECT  demand_id  
          
              ,  ( SELECT ',' + x.eng_scm_site_id 
                     FROM #DEMAND_ATTRIBUTE_TEMP x 
                    WHERE x.demand_id  = a.demand_id
                   ORDER BY (CASE WHEN x.operation_group = 'P' THEN 1 
                                  WHEN x.operation_group = 'A' THEN 2
                                  WHEN x.operation_group = 'E' THEN 3 END), x.eng_scm_site_id
                   FOR XML PATH('') ) AS all_plant_site_id
              ,  ( SELECT DISTINCT ',' + x.child_item_id 
                     FROM #DEMAND_ITEM_BOM x--20180525 수정 ( 변경전 : FROM #DEMAND_ITEM_BOM_TEMP )
                   --2023.07.07, CELL TYPE 추가(활성화 코드 분리 관련)
                    LEFT OUTER JOIN (SELECT DISTINCT y.item_id 
                                       FROM scm_mst_final_item_v y WITH(NOLOCK) 
                                      WHERE y.division_id = @p_division_id
                                        AND y.cell_type IN ('CA1', 'CA2' )  --2023.07.07 CA는 제외.
                                     ) y
			           ON x.child_item_id = y.item_id
                    WHERE x.demand_id     = a.demand_id
                      AND y.item_id IS NULL
                   FOR XML PATH('') ) AS all_item_id
              ,  a.org_cell_site_id -- 2025.04.10 추가
          INTO   #DEMAND_ATTRIBUTE
          FROM   #TH_ENG_NET_DEMAND_TEMP a --20180827 수정 ( 변경전 : FROM   dbo.th_eng_demand_sn  a WITH (NOLOCK) )
         ;          

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 2-4 END';
        SET @v_description = N'2-4 Demand attribute 임시 정보 INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
        -----------------------------------------------------------
        -- 2-5)  Demand Attribue INSERT
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_DEMAND_ATTRIBUTE */ dbo.th_eng_demand_attribute_sn
          (master_id
         , plan_id
         , demand_group_id
         , preference_site_id
         , preference_route_id
         , preference_operation_id
         , preference_resource_id
         , preference_product_id
         , mix_flow_id
         , mix_load_id
         , kitting_id
         , input_start_dttm
         , is_hard_preference
         , descr
         , preference_route_resource_id
          )
          SELECT @p_master_id       AS master_id
               , @p_engine_plan_id  AS plan_id
               , demand_id
               --  , '*****' site_id  -- Demand의 Plant_site_id : 하위 Cell/Elec 의 1순위 생산 Site 전부 기록 : 'Pack::Cell_1::Cell_2::Elec_1::Elec_2'
               , REPLACE( STUFF(all_plant_site_id, 1, 1, '') , ',', '##') AS preference_site_id --20180423 티라요청으로 수정 (변경전 : , REPLACE( STUFF(all_plant_site_id, 1, 1, '') , ',', '::') AS preference_site_id)
               , NULL AS preference_route_id
               , NULL AS preference_operation_id
               , NULL AS preference_resource_id
                --  , preference_product_id -- Demand의 Item_id : 하위 Cell/Elec 의 1순위 생산 Item 전부 기록 : 'Pack::Cell_1::Cell_2::Elec_1::Elec_2'
               , REPLACE( STUFF(all_item_id, 1,1, ''), ',', '##') AS preference_product_id
               , NULL AS mix_flow_id
               , NULL AS mix_load_id
               , NULL AS kitting_id
               , NULL AS input_start_dttm
               , 'Y'  AS is_hard_preference -- Attribute에 설정된 From 사이트에서만 생성됨
               , NULL AS descr
               , NULL AS preference_route_resource_id
          FROM   #DEMAND_ATTRIBUTE
        ;
        
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 2-5 END';
        SET @v_description = N'2-5 Demand attribute 정보 INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        -----------------------------------------------------------
        -- 2-6)  is_hard_preference Update
        -----------------------------------------------------------
        UPDATE /* PR_SCP_ENG_IN_PRE_PROC_DEMAND_ATTRIBUTE */ dbo.th_eng_demand_attribute_sn
		SET    is_hard_preference = 'N'
		WHERE  master_id = @p_master_id
		AND    plan_id   = @p_engine_plan_id
		AND   (preference_site_id    IS NULL 
            OR preference_product_id IS NULL
              ) 
		;
        
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 2-6 END';
        SET @v_description = N'2-6 Demand attribute 정보 is_hard_preference UPDATE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        -----------------------------------------------------------
        --3 th_eng_demand_sn 테이블 업데이트
        -----------------------------------------------------------
        
        -----------------------------------------------------------
        --3-0)  소형CAPA분리를 포함한 임시테이블 생성, 2023.08.08 Start ~
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#SCM_MST_FP_TACT_TIME_TEMP') IS NOT NULL
        BEGIN 
            DROP TABLE  #SCM_MST_FP_TACT_TIME_TEMP;          
        END 

        --1. FP기준 CAPA정보 생성
        SELECT a.division_id       
	         , a.plant_id          
	         , a.plant_site_id     	
             , a.operation_id      
             , a.operation_group_id
             , a.item_id           
             , a.line_id           
	         , a.yyyymm             
             , a.lane_qty          
             , a.org_tact_time          
             , a.org_daily_capa 
             , a.tact_time          
             , a.daily_capa       
          INTO #SCM_MST_FP_TACT_TIME_TEMP  
          FROM
                (
                SELECT aa.division_id
                     , aa.plant_id
                     , aa.plant_site_id
                     , aa.operation_id
                     , CASE WHEN SUBSTRING(aa.operation_id, 1, 1) IN ('E', 'S')      THEN 'E'
                            WHEN SUBSTRING(aa.operation_id, 1, 1) IN ('A', 'B', 'F') THEN 'A'
                            WHEN SUBSTRING(aa.operation_id, 1, 1) IN ('P')           THEN 'P'
                            ELSE 'A'
                        END          AS operation_group_id
                     , aa.item_id
                     , aa.line_id
                     , aa.month      AS yyyymm
                     , aa.lane_qty    
                     , aa.tact_time  AS org_tact_time
	                 , aa.daily_capa AS org_daily_capa
                     , aa.tact_time  
	                 , aa.daily_capa  
                       /* item별 line별 월별 Daily Capa 가장 작은 값 */
                     , ROW_NUMBER() OVER(PARTITION BY aa.division_id
                                                    , aa.plant_id
                                                    , aa.operation_id
                                                    , aa.item_id
                                                    , aa.line_id
                                             ORDER BY aa.daily_capa, aa.month
                                         ) AS seq
                 FROM scm_mst_tact_time_ver_h_v aa WITH (NOLOCK)
                WHERE aa.division_id  = @p_division_id        --40 
                /* FP Tact Time 관리 기간 기준 (M0~M1) */ 
                  AND aa.month       >= LEFT(@p_plan_name,6)  
                  AND aa.month       <= CONVERT(NVARCHAR(6), DATEADD(m, 1, CONVERT(DATETIME,LEFT(@p_plan_name, 6) + '01')), 112) 
                  AND aa.daily_capa   > 0                            
                  AND aa.operation_id IN ( SELECT b.segment2 AS operation_id
  						                     FROM scm_adm_lookup_master_detail a WITH(NOLOCK)
  						                    INNER JOIN scm_adm_lookup_master_detail b WITH(NOLOCK)
  						                       ON a.segment1    = b.segment1
  						                      AND a.lookup_type = 'LOCATION_GROUP'
  						                      AND a.segment4    = 'Y'  -- Capa 공정 여부 
  						                    --AND a.segment5    = 'Y'  -- Line 별 Capa 적용 공정( Capa공정여부가 'N'이면  Line 별 Capa 적용 공정이 'Y'가 될수없음)
  						                      AND a.valid_yn    = 'Y'
  						                      AND b.lookup_type = 'LOCATION_GROUP_ROUTE'
  						                      AND b.valid_yn    = 'Y'
  						                    --AND b.segment3    = 'Y' -- Capa 세부 공정 여부  (P5000 공정을 포함하기 위해 주석) 
  						                      AND a.segment3    IN ('A', 'P')   -- 대상 공정만 
                                        )
                ) a
        WHERE a.seq = 1
        ;

        --2. SCP 소형 CAPA 관리 기준으로 UPDATE
        UPDATE a
           SET a.tact_time  = b.tact_time
             , a.daily_capa = b.daily_capa
          FROM #SCM_MST_FP_TACT_TIME_TEMP a WITH(NOLOCK)
          JOIN (
              SELECT b.division_id
                   , b.plant_id
                   , b.operation_id
                   , b.item_id
                   , b.line_id
                   , b.yyyymm
                     /* SCP Daily Capa 수량을 Tact Time(Sec)으로 변환 */
                   , ROUND((60 * 60 * 24)/b.value, 3) AS tact_time
                   , b.value                          AS daily_capa
                     /* item별 line별 Daily Capa 가장 작은 값 */
                    , ROW_NUMBER() OVER(PARTITION BY b.division_id
                                                   , b.plant_id
                                                   , b.operation_id
                                                   , b.item_id
                                                   , b.line_id
                                            ORDER BY b.value, b.yyyymm
                                        ) AS seq
                FROM SCP_MST_CAPA b WITH (NOLOCK)
               WHERE b.division_id  = @p_division_id --40       
                 /* FP Tact Time 관리 기간 기준 동일하게 적용 (M0~M1) */ 
                 AND b.yyyymm       >= LEFT(@p_plan_name,6)  
                 AND b.yyyymm       <= CONVERT(NVARCHAR(6), DATEADD(m, 1, CONVERT(DATETIME,LEFT(@p_plan_name, 6) + '01')), 112) 
                 AND b.value        > 0   
              ) b
         ON a.plant_id     = b.plant_id
        AND a.operation_id = b.operation_id
        AND a.item_id      = b.item_id
        AND a.line_id      = b.line_id
        AND b.seq          = 1
        ;

        -----------------------------------------------------------
        --3-0)  소형CAPA분리를 포함한 임시테이블 생성, 2023.08.08  ~ End
        -----------------------------------------------------------

        -----------------------------------------------------------
        --3-1)  demand의 item이 팩일때 하위셀 item / 셀일때 셀item의 Daily Capa 정보생성
        --      (단, demand의 item이 팩일때는 BOM상의 셀item 중에서 1000분 기준 MIN(Daily_Capa) 값을 가진 셀선호site, 셀item 정보를 임시테이블로 생성)
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#DEMAND_DAILY_CAPA_TEMP') IS NOT NULL
        BEGIN 
            DROP TABLE  #DEMAND_DAILY_CAPA_TEMP;
        END 
        
        SELECT x.demand_id  
            ,  x.child_item_id  --x.cell_item_id 
            ,  x.cell_site_id 
            ,  x.plant_id 
            ,  x.top_plant_site_id -- 최상위 plant_site_id ( 최상위 plant_site_id => demand item이  팩일때 : 팩사이트,  셀일때 : 셀사이트, 전극 : 전극사이트 )
            ,  x.child_item_operation_group 
            ,  x.demand_item_operation_group
            ,  x.project_code 
            ,  x.scm_site
            ,  x.due_date 
            ,  x.item_id            
            ,  x.max_daily_capa
            ,  x.max_daily_capa_org     --20180521 추가
            ,  x.accumulated_child_qty  --20180521 추가            
            --------------------------------------------------  
            ,  0 max_daily_capa_pack    --2023.03.07 추가
        INTO   #DEMAND_DAILY_CAPA_TEMP
        FROM   (
                   SELECT a.*
                       ,  CASE WHEN a.demand_item_operation_group  = 'P' AND a.child_item_operation_group = 'A' 
                                    THEN CEILING(b.max_daily_capa / a.accumulated_child_qty) 
                               ELSE b.max_daily_capa 
                          END  AS max_daily_capa --20180521 추가 --,  CEILING(b.max_daily_capa / a.accumulated_child_qty) AS max_daily_capa --20180521 추가                       
                       ,  b.max_daily_capa AS max_daily_capa_org  --20180521 수정 (변경전 : , b.max_daily_capa )                       
						   /* 2023.03.7 DEMAND SPLIT APPLY */
                          -- 외주셀(TCO셀) 제외시키기위해서 우선순위를 조정함
                       ,  ROW_NUMBER() OVER (PARTITION BY a.demand_id ORDER BY IIF(a.tco_cell_yn = 'Y', 1, 0)   
                                                                             , CASE WHEN a.cell_type = 'CA1' then 1  else 999 end  --2023.07.07 cell out item을 반영하기 위해 추가.
                                                                             , IIF(b.max_daily_capa IS NULL, 999999999, b.max_daily_capa)
                                                                             , a.child_item_id ) AS row_num                                                      
                   FROM  
                         ( 
                            SELECT a.demand_id
                                ,  a.child_item_id -- AS cell_item_id 
                                ,  a.accumulated_child_qty --20180521 추가
                                , a.top_plant_site_id AS cell_site_id -- 20180525 수정
                                ,  dbo.fn_scm_split( a.top_plant_site_id, 1, '-') AS plant_id   --20180525 수정                                                               
                                ,  a.top_plant_site_id -- 최상위 plant_site_id ( 최상위 plant_site_id => demand item이  팩일때 : 팩사이트,  셀일때 : 셀사이트, 전극 : 전극사이트 )
                                ,  a.child_item_operation_group 
                                ,  a.demand_item_operation_group
                                ,  a.project_code 
                                ,  a.scm_site
                                ,  a.due_date 
                                ,  a.item  AS item_id   
                                ,  b.tco_cell_yn  --20180827 추가 
                                ,  b.cell_type    --2023.07.07 추가 
                            FROM   #DEMAND_ATTRIBUTE_SITE_PRIORITY_TEMP a 
                                   LEFT OUTER JOIN (SELECT DISTINCT division_id, item_id, tco_cell_yn 
                                                         , cell_type    --~ 2023.07.07 'CA1' 타입을 반영하기 위해 cell_type 추가
								                    FROM   scm_mst_final_item_v 
													WHERE  division_id = @p_division_id
													AND    operation_group_id = 'A'           
												    ) b
							  ON  a.child_item_id = b.item_id 
                          ) a
                          LEFT OUTER JOIN ( /* 소형CAPA분리 적용. 2023.08.08 */
                                            SELECT division_id
                                                 , plant_id
                                                 , operation_id
                                                 , item_id
											     --, ROUND(MIN(daily_capa)*(1000/1440), 0) AS max_daily_capa  
                                                 --, ROUND(MIN(daily_capa), 0) AS max_daily_capa   --CELL조립 공정만, 완성 수량 기준 Daily Capa 그대로 사용, 2023.08.08
                                                 /* 비현실적인 너무 작은 DAILY CAPA 값인 경우, DEMAND SPLIT이 과도하게 되어 중대한 엔진 속도 문제 발생 방지, 2023.09.12 */
                                                 , CASE WHEN ROUND(MIN(daily_capa), 0) < @v_DEFAULT_MAX_DAILY_CAPA THEN @v_DEFAULT_MAX_DAILY_CAPA
                                                        ELSE ROUND(MIN(daily_capa), 0)
                                                     END AS max_daily_capa
                                               FROM #SCM_MST_FP_TACT_TIME_TEMP aa WITH (NOLOCK)  --임시 테이블로 변경(튜닝&소형CAPA이원화). 2023.08.08 
											  WHERE aa.division_id  = @p_division_id   
                                                AND aa.operation_group_id = 'A' --CELL CAPA 공정 
                                              GROUP 
											     BY division_id, plant_id, operation_id, item_id
                                            /* org : 2023.08.08 이전
                                            SELECT division_id, plant_id, operation_id, item_id
											     , ROUND(MIN(daily_capa)*1000/1440, 0) AS max_daily_capa  -- 2018.07.05 : 1000분 기준 MIN Capa 로 Split : Capa 적용 부분 확인 필요
											  FROM scm_mst_tact_time_ver_h_v aa WITH (NOLOCK)
    									     WHERE aa.division_id  = @p_division_id        
                                               AND aa.yyyymm       = LEFT(@p_plan_name,6)
                                               AND aa.daily_capa   <> 0                            
											   AND aa.operation_id IN ( SELECT b.segment2 AS operation_id
																		  FROM   scm_adm_lookup_master_detail a WITH(NOLOCK)
																		  INNER JOIN scm_adm_lookup_master_detail b WITH(NOLOCK)
																		  ON  a.segment1    = b.segment1
																		  AND a.lookup_type = 'LOCATION_GROUP'
																		  AND a.segment4    = 'Y' -- Capa 공정 여부 
																		  AND a.segment5    = 'Y' -- Line 별 Capa 적용 공정( Capa공정여부가 'N'이면  Line 별 Capa 적용 공정이 'Y'가 될수없음)
																		  AND a.valid_yn    = 'Y'
																		  AND a.segment3    = 'A' -- 셀 Capa  공정(A3000, A9000)
																		  AND b.lookup_type = 'LOCATION_GROUP_ROUTE'
																		  AND b.valid_yn    = 'Y'
																		  AND b.segment3    = 'Y' -- Capa 세부 공정 여부 
																		 ) 
										   GROUP 
											  BY division_id, plant_id, operation_id, item_id
                                           */
                                     ) b
                          ON   a.plant_id      = b.plant_id 
                          AND  a.child_item_id = b.item_id   --a.cell_item_id = b.item_id 
              ) x
        WHERE x.row_num = 1
        ;

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 3-1-1 END';
        SET @v_description = N'3-1 셀 Daily Capa 정보 INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        --PACK DAILY CAPA Update 
		UPDATE a
           /* 비현실적인 너무 작은 DAILY CAPA 값인 경우, DEMAND SPLIT이 과도하게 되어 중대한 엔진 속도 문제 발생 방지, 2023.09.12 */
--		   SET a.max_daily_capa_pack    = ISNULL(ISNULL(b.max_daily_capa, b.izu_max_daily_capa), b.osp_daily_capa)                                           
		   SET a.max_daily_capa_pack    = CASE WHEN ROUND(ISNULL(ISNULL(b.max_daily_capa, b.izu_max_daily_capa), b.osp_daily_capa),0) < @v_DEFAULT_MAX_DAILY_CAPA/2 THEN @v_DEFAULT_MAX_DAILY_CAPA/2
                                               ELSE ROUND(ISNULL(ISNULL(b.max_daily_capa, b.izu_max_daily_capa), b.osp_daily_capa),0)
                                            END                                      
		  FROM #DEMAND_DAILY_CAPA_TEMP a 
		  JOIN (
				SELECT  a.demand_id
						, a.plant_id
						, a.top_plant_site_id
						, a.child_item_operation_group 
						, a.demand_item_operation_group
						, a.project_code 
						, a.scm_site
						, a.due_date 
						, a.item_id 
						, b.max_daily_capa
						, c.max_daily_capa  izu_max_daily_capa 
						, d.osp_daily_capa
					FROM
					(
					SELECT a.demand_id
							, dbo.fn_scm_split( a.top_plant_site_id, 1, '-') AS plant_id  
							, a.top_plant_site_id
							, a.child_item_operation_group 
							, a.demand_item_operation_group
							, a.project_code 
							, a.scm_site
							, a.due_date 
							, a.item                                         AS item_id   
							, a.child_item_id  
						FROM #DEMAND_ATTRIBUTE_SITE_PRIORITY_TEMP a
					  WHERE a.demand_item_operation_group = 'P'
						AND a.child_item_operation_group = a.demand_item_operation_group
						AND a.item                       = a.child_item_id
					) a
					/* Noramal PACK DAILY CAPA */  
					LEFT OUTER JOIN (  
                                    /* 소형CAPA분리 적용. 2023.08.08 */
                                    SELECT division_id
                                        , plant_id
                                        , operation_id
                                        , item_id
										, ROUND(MIN(daily_capa)*1000/1440, 0) AS max_daily_capa  
                                     FROM #SCM_MST_FP_TACT_TIME_TEMP aa WITH (NOLOCK)  --임시 테이블로 변경(튜닝&소형CAPA이원화). 2023.08.08 
									WHERE aa.division_id  = @p_division_id   
                                      AND aa.operation_group_id = 'P' --PACK CAPA 공정 
                                    GROUP 
									  BY division_id, plant_id, operation_id, item_id 
                                      /* org : 2023.08.08 이전
                                      SELECT division_id, plant_id, operation_id, item_id
											, ROUND(MIN(daily_capa)*1000/1440, 0) AS max_daily_capa	
									    FROM scm_mst_tact_time_ver_h_v aa WITH (NOLOCK)
    								   WHERE aa.division_id  = @p_division_id        
									     AND aa.month        = LEFT(@p_plan_name,6)    
                                         AND aa.daily_capa   <> 0                            
										 AND aa.operation_id IN ( SELECT b.segment2 AS operation_id
																    FROM scm_adm_lookup_master_detail a WITH(NOLOCK)
																  INNER JOIN scm_adm_lookup_master_detail b WITH(NOLOCK)
																	 ON a.segment1    = b.segment1
																	AND a.lookup_type = 'LOCATION_GROUP'
																	AND a.segment4    = 'Y' -- Capa 공정 여부 
																	AND a.segment5    = 'Y' -- Line 별 Capa 적용 공정( Capa공정여부가 'N'이면  Line 별 Capa 적용 공정이 'Y'가 될수없음)
																	AND a.valid_yn    = 'Y'
																	AND a.segment3    = 'P' -- Pack Capa 공정
																	AND b.lookup_type = 'LOCATION_GROUP_ROUTE'
																	AND b.segment3    = 'Y' -- Capa 세부 공정 여부 
																	AND b.valid_yn    = 'Y'
																	) 
									GROUP 
										BY division_id, plant_id, operation_id, item_id
                                    */
								) b
					 ON a.plant_id = b.plant_id 
					AND a.item_id  = b.item_id   
					/* IZU PACK DAILY CAPA */  
					LEFT OUTER JOIN   ( 
                                       /* 소형CAPA분리 적용. 2023.08.08 */
                                       SELECT division_id
                                            , plant_id
                                            , operation_id
                                            , item_id
										    , ROUND(MIN(daily_capa)*1000/1440, 0) AS max_daily_capa  
                                        FROM #SCM_MST_FP_TACT_TIME_TEMP aa WITH (NOLOCK)  --임시 테이블로 변경(튜닝&소형CAPA이원화). 2023.08.08 
									   WHERE aa.division_id  = @p_division_id   
                                         AND aa.operation_group_id = 'P' --PACK CAPA 공정
                                         AND aa.operation_id IN ('P5000')
										 AND aa.item_id IN (SELECT item_id
										   					FROM scm_mst_final_item_v  WITH(NOLOCK)
										   					WHERE division_id = @p_division_id
										   					 AND is_yn = 'Y')
                                        GROUP 
										    BY division_id, plant_id, operation_id, item_id
                                       /* org : 2023.08.08 이전
                                       SELECT division_id, plant_id, operation_id, item_id
											, ROUND(MIN(daily_capa)*1000/1440, 0) AS max_daily_capa	
									     FROM scm_mst_tact_time_ver_h_v aa WITH (NOLOCK)
										WHERE aa.division_id = @p_division_id        
									     AND aa.month        = LEFT(@p_plan_name,6)  
                                         AND aa.daily_capa   <> 0                      
										 AND aa.item_id IN (SELECT item_id
										   					  FROM scm_mst_final_item_v  WITH(NOLOCK)
										   					 WHERE division_id = @p_division_id
										   					  AND is_yn = 'Y'
										   				    )
										 AND aa.operation_id IN (SELECT scp_flow_id
																	 FROM scm_mst_item_sn WITH(NOLOCK)
																	WHERE scp_flow_id IN ('P5000')
																   ) 
										GROUP 
											BY division_id, plant_id, operation_id, item_id
								        */
                                       ) c
					ON a.plant_id = c.plant_id 
				   AND a.item_id  = c.item_id 
					/* OSP(외주) PACK DAILY CAPA */  
				   LEFT OUTER JOIN (
									--scp_mst_outsourcing_capa
									SELECT o.division_id
									 	 , o.plant_site_id
										 , dbo.fn_scm_split(o.PLANT_SITE_ID, 1, '-') AS plant_id
										 , o.item_id
										 , ISNULL(o.daily_capa_qty,0)                AS osp_daily_capa
									  FROM scp_mst_outsourcing_capa o WITH(NOLOCK)
									 WHERE o.division_id = @p_division_id
									   AND o.VALID_YN = 'Y'
									   AND o.PLANT_SITE_ID LIKE '%-P'
									) d
					ON a.plant_id  = d.plant_id 
				   AND a.item_id   = d.item_id   
				) b
		   ON a.demand_id  = b.demand_id
		  AND a.item_id    = b.item_id
		WHERE a.demand_item_operation_group  = 'P'
		  AND ISNULL(ISNULL(b.max_daily_capa, b.izu_max_daily_capa), b.osp_daily_capa) > 0
		;

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 3-1-2 END';
        SET @v_description = N'3-2 PACK Daily Capa 정보 INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
        --3-2)  demand의 item이 팩일때 하위셀 item / 셀일때 셀item의 1) Setup Group ID, 2) Avg_Setup_Time 정보생성
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#DEMAND_SETUP_GROUP_TEMP') IS NOT NULL
        BEGIN 
            DROP TABLE  #DEMAND_SETUP_GROUP_TEMP;
        END 

        SELECT x.demand_id  
            ,  x.child_item_id  --cell_item_id 
            ,  x.cell_site_id 
            ,  x.plant_id                
            ,  x.top_plant_site_id -- 최상위 plant_site_id ( 최상위 plant_site_id => demand item이  팩일때 : 팩사이트,  셀일때 : 셀사이트, 전극 : 전극사이트 )
            --,  x.cell_plant_site_id
            --,  x.elec_plant_site_id
            --,  x.org_cell_site_id 
            --,  x.org_elec_site_id 
            ,  x.child_item_operation_group 
            ,  x.demand_item_operation_group
            ,  x.project_code 
            ,  x.scm_site
            ,  x.due_date 
            ,  x.item_id            
            ,  x.max_daily_capa
			,  x.max_daily_capa_pack  --2023.03.07 ADD            
            -- ksg 20180522 Setup Group 대신 Cell Item ID 사용
            ,  x.child_item_id AS setup_group_id -- (변경전 : ,  y.setup_group_id)                        
            ,  y.avg_setup_time
        INTO   #DEMAND_SETUP_GROUP_TEMP
        FROM   #DEMAND_DAILY_CAPA_TEMP x
               LEFT JOIN (
                            SELECT a.demand_id 
                                 --, a.cell_site_id  -- 20180725 주석처리
                                 , a.child_item_id --a.cell_item_id  
                                 , d.setup_attribute AS setup_group_id  
                                 , AVG(e.setup_time) AS avg_setup_time      
                            FROM  (
                                     SELECT demand_id  
                                         ,  child_item_id --cell_item_id 
                                         ,  cell_site_id 
                                         ,  plant_id 

                                         --,  top_plant_site_id -- 최상위 plant_site_id ( 최상위 plant_site_id => demand item이  팩일때 : 팩사이트,  셀일때 : 셀사이트, 전극 : 전극사이트 )
                                         --,  cell_plant_site_id
                                         --,  elec_plant_site_id
                                         --,  org_cell_site_id 
                                         --,  org_elec_site_id 
                                         --,  child_item_operation_group 
                                         --,  demand_item_operation_group
                                         --,  project_code 
                                         --,  scm_site
                                         --,  due_date 
                                         --,  item_id            
                                         --,  max_daily_capa
                                     FROM   #DEMAND_DAILY_CAPA_TEMP
                            
                                  ) a
                                 
                                  LEFT JOIN ( SELECT DISTINCT scm_site_id, plant_id, company_id, site_id 
                                              FROM   scm_mst_site b WITH (NOLOCK)
                                              WHERE  division_id = @p_division_id
                                              AND    valid_yn = 'Y'
                                             ) c
                                  ON  a.cell_site_id = c.scm_site_id 

                                  LEFT JOIN (SELECT i.item_id
                                                    , MAX(i.setup_attribute) AS setup_attribute                   
                                              FROM   dbo.scm_mst_item_sn i WITH(NOLOCK)
                                              WHERE  i.division_id = @p_division_id  
                                              AND    i.active_flag = 'Y'
                                              AND    i.setup_attribute IS NOT NULL
                                              AND    i.setup_attribute <> ''
                                              GROUP BY i.item_id 
                                              ) d
                                   ON a.child_item_id = d.item_id --ON a.cell_item_id = d.item_id
               
                                   LEFT JOIN scm_mst_setup_matrix_sn e
                                   --ON   a.cell_item_id = e.to_item_setup_group_id
                                   ON   d.setup_attribute = e.to_item_setup_group_id
                                   AND  c.company_id      = e.company_id
                                   AND  c.site_id         = e.site_id
                                   AND  c.plant_id        = e.plant_id 
                                   AND  e.division_id     = @p_division_id
                            -- 20180725 수정  cell_site_id  제외
                            --GROUP BY  a.demand_id , a.cell_site_id, a.child_item_id, d.setup_attribute 
                            GROUP BY  a.demand_id , a.child_item_id, d.setup_attribute                              
                          ) y
               ON    x.demand_id    = y.demand_id
               AND   x.child_item_id = y.child_item_id  --x.cell_item_id = y.cell_item_id
        ;

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 3-2 END';
        SET @v_description = N'3-2 셀 Setup Group 정보 INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        -----------------------------------------------------------
        --3-3)  th_eng_demand_sn 테이블 최종 UPDATE
        --      - 1) 팩/셀일때 cell_item_id
        --      - 2) 팩/셀일때 cell_site_id
        --      - 3) 팩/셀일때 cell_setup_group_id
        --      - 4) 팩/셀일때 avg_setup_time
        --      - 5) 팩/셀일때 max_daily_capa
        -----------------------------------------------------------
        UPDATE #TH_ENG_NET_DEMAND_TEMP  --20180827 수정 ( 변경전 : UPDATE th_eng_demand_sn )
        SET    cell_item_id             = b.child_item_id --cell_item_id
            ,  cell_site_id             = b.cell_site_id
            ,  cell_site_setup_group_id = b.setup_group_id
            ,  avg_setup_time           = b.avg_setup_time 
            ,  max_daily_capa           = b.max_daily_capa        
			-- 2023.03.07 DEMAND SPLIT ADD
			,  max_daily_capa_pack      = b.max_daily_capa_pack        
        FROM   #TH_ENG_NET_DEMAND_TEMP a --20180827 수정 ( 변경전 : FROM   th_eng_demand_sn a WITH (NOLOCK) )
               INNER JOIN #DEMAND_SETUP_GROUP_TEMP b 
               ON   a.demand_id = b.demand_id 
               AND  ( 
                      ( b.demand_item_operation_group = 'P' AND b.child_item_operation_group = 'A' )
                      OR
                      ( b.demand_item_operation_group = 'A' AND b.child_item_operation_group = 'A' )
                      --OR
                      --( b.demand_item_operation_group = 'E' AND b.child_item_operation_group = 'E' )
                    )
        --WHERE  a.master_id = @p_master_id
        --AND    a.plan_id   = @p_engine_plan_id 
        ;
		
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 3-3 END';
        SET @v_description = N'3-3 demand 정보 UPDATE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        -----------------------------------------------------------
        --3-4)  th_eng_demand_sn 테이블 shipping_date 변경
        --      -  shipping_date : ISNULL([due_date] - [BOD 우선순위 가장작은값의 L/T], shipping_date)
        --         ( 단, shipping_date 가 플랜시작일자보다 작으면 shipping_date는 플랜시작일자로 셋팅함 )
        --      참고) shipping_date  최초 생성시 dm_pln_net_demand.yyyymmdd으로 셋팅되어있음
        -----------------------------------------------------------
        UPDATE #TH_ENG_NET_DEMAND_TEMP   --20180827 수정 ( 변경전 : UPDATE th_eng_demand_sn )
        -- 20200323 [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - Hold VMI 대기 재고 Visibility 강화
        --            VMI 전진 검사 LT 추가 적용 : SCM_MST_SITE_ITEM 테이블의 SCP_VMI_LT 값 만큼 ETA에 더해 줌
        SET    shipping_date = IIF(  @d_plan_name >  IIF((ISNULL(b.lt_total, 0) + ISNULL(si.lt_day, 0)) = 0
                                                        , shipping_date
                                                        , DATEADD(d, (ISNULL(b.lt_total, 0) + ISNULL(si.lt_day, 0)) * -1, due_date) 
                                                        ) 
                                   , @d_plan_name
                                   ,  IIF((ISNULL(b.lt_total, 0) + ISNULL(si.lt_day, 0)) = 0
                                         , shipping_date
                                         , DATEADD(d, (ISNULL(b.lt_total, 0) + ISNULL(si.lt_day, 0)) * -1, due_date) 
                                         ) 
                                  ) -- shipping_date 가 플랜시작일자보다 작으면 shipping_date는 플랜시작일자로 셋팅함

     /*   SET    shipping_date = IIF(  @d_plan_name >  IIF(ISNULL(b.lt_total, 0) = 0, shipping_date, DATEADD(d, b.lt_total * -1, due_date) ) 
                                   , @d_plan_name
                                   ,  IIF(ISNULL(b.lt_total, 0) = 0, shipping_date, DATEADD(d, b.lt_total * -1, due_date) ) 
                                  ) -- shipping_date 가 플랜시작일자보다 작으면 shipping_date는 플랜시작일자로 셋팅함
     */

        FROM   #TH_ENG_NET_DEMAND_TEMP a --20180827 수정 ( 변경전 : FROM   th_eng_demand_sn a WITH (NOLOCK) )
      --         LEFT JOIN ( SELECT division_id, from_site, to_site, incoterms
      --                          , to_site + '~' + incoterms AS eng_to_site
      --                          , transport_mode
      --                          , priority 
      --                          , lt_total, ship_lt_total
      --                          , ROW_NUMBER() OVER (PARTITION BY division_id, from_site, to_site, incoterms ORDER BY priority) priority_row_num
      --                     FROM   scp_mst_bod_v 
      --                     WHERE  division_id = @p_division_id
      --                     AND    bod_valid_yn = 'Y'
      --                   ) b
      --         ON  a.plant_site_id    = b.from_site 
      --         AND a.site             = b.eng_to_site
      --         AND b.priority_row_num = 1 -- BOD의 우선순위 가장작은값
			   --2021.07.07 기간별 bod 고려
               LEFT JOIN ( SELECT a.demand_id
                                , b.lt_total
                                , ROW_NUMBER() OVER (PARTITION BY a.demand_id ORDER BY b.to_yyyymmdd, b.priority) priority_row_num
                             FROM scp_mst_bod_n_v b WITH(NOLOCK)
							 INNER JOIN #th_eng_net_demand_temp a WITH(NOLOCK)
							   ON a.plant_site_id = b.from_site 
							  AND a.site          = b.to_site + '~' + b.incoterms
							  AND DATEADD(DAY, -b.lt_total, a.due_date) < b.to_yyyymmdd
                            WHERE b.division_id = @p_division_id
                              AND b.bod_valid_yn = 'Y'
                         ) b
               ON  a.demand_id    = b.demand_id
               AND b.priority_row_num = 1 -- BOD의 우선순위 가장작은값
               -- 20200323 [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - Hold VMI 대기 재고 Visibility 강화
               --            VMI 전진 검사 LT 추가 적용 : SCM_MST_SITE_ITEM 테이블의 SCP_VMI_LT 값 만큼 ETA에 더해 줌
               LEFT OUTER JOIN (
                                SELECT s.scm_site_id, s.item_id
                                     , MAX(ISNULL(s.scp_vmi_lt, 0)) AS lt_day
                                FROM   scm_mst_site_item s WITH(NOLOCK)
                                       INNER JOIN scm_adm_lookup_master_detail md WITH(NOLOCK)

                                ON  s.division_id  = md.segment1
                                AND s.scm_site_id  = md.segment2
                                AND s.division_id  = @p_division_id
                                AND md.lookup_type = 'VMI_LT_SITE'
                                AND s.valid_yn     = 'Y'
                                AND md.valid_yn    = 'Y'
                                GROUP BY s.scm_site_id, s.item_id
                               ) si
               ON  a.scm_site = si.scm_site_id
               AND a.item     = si.item_id
        --WHERE  a.master_id = @p_master_id
        --AND    a.plan_id   = @p_engine_plan_id 
        ;   
        
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 3-4 END';
        SET @v_description = N'3-4 demand 정보 shipping_date UPDATE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
        -- 3-5 demand 정보 INSERT (demand 임시테이블 생성정보를 실 테이블에 INSERT)
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_EE_PRE_PROC_DEMAND_ATTRIBUTE */ th_eng_demand_sn 
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
	      --is_consume
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
		  -- 2023.03.07 DEMAND SPLIT ADD
		  , max_daily_capa_pack
          , demand_priority  -- 20180621 추가(DM의 우선순위)              
        )      
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
	      --is_consume
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
          , max_daily_capa_pack -- 2023.03.7 DEMAND SPLIT 추가
          , demand_priority     -- 20180621 추가(DM의 우선순위)              
        FROM #TH_ENG_NET_DEMAND_TEMP
        ;

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 3-5 END';
        SET @v_description = N'3-5 demand 정보 INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
       ------------------------------------------------------------
        --임시테이블 삭제
        ------------------------------------------------------------
        IF OBJECT_ID('tempdb..#TH_ENG_NET_DEMAND_TEMP') IS NOT NULL
        BEGIN 
            DROP TABLE  #TH_ENG_NET_DEMAND_TEMP;          
        END 
        
        IF OBJECT_ID('tempdb..#DEMAND_ITEM_BOM_TEMP') IS NOT NULL
        BEGIN 
            DROP TABLE  #DEMAND_ITEM_BOM_TEMP;
        END 
        
        IF OBJECT_ID('tempdb..#DEMAND_ITEM_BOM') IS NOT NULL
        BEGIN 
            DROP TABLE  #DEMAND_ITEM_BOM;
        END 
         
        IF OBJECT_ID('tempdb..#DEMAND_ATTRIBUTE_SITE_PRIORITY_TEMP') IS NOT NULL
        BEGIN 
            DROP TABLE  #DEMAND_ATTRIBUTE_SITE_PRIORITY_TEMP;
        END 

        IF OBJECT_ID('tempdb..#DEMAND_ATTRIBUTE_TEMP') IS NOT NULL
        BEGIN 
            DROP TABLE  #DEMAND_ATTRIBUTE_TEMP;
        END 
          
        IF OBJECT_ID('tempdb..#DEMAND_ATTRIBUTE') IS NOT NULL
        BEGIN 
            DROP TABLE  #DEMAND_ATTRIBUTE;
        END 
          
        IF OBJECT_ID('tempdb..#DEMAND_DAILY_CAPA_TEMP') IS NOT NULL
        BEGIN 
            DROP TABLE  #DEMAND_DAILY_CAPA_TEMP;
        END 
        
        IF OBJECT_ID('tempdb..#DEMAND_SETUP_GROUP_TEMP') IS NOT NULL
        BEGIN 
            DROP TABLE  #DEMAND_SETUP_GROUP_TEMP;
        END 

        --2023.08.08 추가
        IF OBJECT_ID('tempdb..#SCM_MST_FP_TACT_TIME_TEMP') IS NOT NULL
        BEGIN 
            DROP TABLE  #SCM_MST_FP_TACT_TIME_TEMP;
        END 

        --2024.12.16 추가
        IF OBJECT_ID('tempdb..#scm_mst_site_item_priority_v') IS NOT NULL
        BEGIN 
            DROP TABLE  #scm_mst_site_item_priority_v;
        END 

        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        -- TXN LOG
        SET @v_log_type = 'TXN';
        SET @n_log_count = @@ROWCOUNT;
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
