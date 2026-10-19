
/* 
 * Program ID   : PR_SCP_ENG_IN_PRE_PROC_FIXED_PLAN
 * Description  :
                  -----------------------------------------------------------
                  --1-1) (FIX) SSP 출하계획 확정정보 Insert (ship_frozen 기간이내)
                  -----------------------------------------------------------
                      - SSP 출하계획 확정정보(ssp_anl_ship_confirm) 중 ship_frozen 기간 내의 데이터 INSERT
                      - 참고 테이블) ssp_anl_ship_confirm : SSP 출하계획 확정정보
        
                  -----------------------------------------------------------
                  --1-1) (FIX) SSP Ship Req 대상 출하계획 정보 Insert (ship_frozen 이후 ESS 동기화 기간이내)
                               : 이 구간의 값은 SSP confirm 값과 상관없이 추가함
                  -----------------------------------------------------------
                      - 참고 테이블) SSP_ANL_SHIP_PLAN_ALL (SSP confirm + 출하계획정보)
                  
                  -----------------------------------------------------------
                  --1-2) (FIX) SSP, SCP 출하계획(동일 공장 외) 확정정보 Insert (ISNULL(ESS 동기화, ship_frozen) 기간이후)
                  -----------------------------------------------------------
				     20190624) SCP 출하계획 확정정보만 사용 : 확정구간(ship_frozen) 이후는 SSP 출하계획 확정정보 사용 안 함
					              scp qty, scp fix_id             

                     - (20181220 수정 키중복방지)      ssp_anl_ship_confirm 테이블에 동일정보에 여러건의 데이터가 존재하므로 SUM(수량) 처리함 ( Confirm_id는 'C' + 임의의값("ROW_NUMBER(ORDER BY ssp.item_id)") 형식으로 생성함)
                     - (20190104 수정 조인조건 컬럼값) site_type = 'PLANT'일때 1) project_code = '-', 2) incoterms = '-' 처리함  ( site_type='PLANT'일때 SCP(scp_anl_shipment_plan_fix), SSP(ssp_anl_ship_confirm) 같은정보인데 project_code, incoterms 값이 존재하는건도 있고 없는건도 존재해서 조인처리시 서로다른건으로 인식되므로 '-'로 셋팅함)
                  
                     - 참고 테이블1) scp_anl_shipment_plan_fix : SCP 출하계획 확정정보

                  --(주석시작)20181207 주석처리함 : PROC_BOD의 fixed_term이 내부 site는 "0"처리되므로 ssp_anl_shipment_plan_semi(내부site 처리) 사용부분은 주석처리함) : 이부분처리시 PROC_BOD의 fixed_term컬럼부분 처리검토 필요함  
                  -----------------------------------------------------------
                  --(주석처리함)2. SSP비대상 출하계획 확정정보 Insert (ship_frozen 기간이내)
                  -----------------------------------------------------------
                      - scp_anl_shipment_plan_semi 테이블의 최종생성(전주 최종생성된 데이터)된 plan_id의 seq
                        데이터중 BOD가 공장내부이면서, yyyymmdd >= @p_plan_name AND yyyymmdd < DATEADD(d, ship_frozen, @d_plan_name) 인 데이터만 INSERT                      

                      - SSP 대상이 아닌 경우 : [To Site가 Plant이고, From/To 가 같은 국가이면서, To Site 가 OSP_YN = 'Y' 가 아닌 경우]
                      - 공장내부 : BOD 의 from site와 to site가  같은 site_id (또는 같은company_id)이고 to_site 가 sales site 아닐때
                                   (참조 컬럼 : scm_mst_bod_eng.attribute1 ( 공장내부 : 'INNER_SITE', 'INNER_SITE_001', 'INNER_SITE_002', 공장외부 : 'OUTER_SITE')

                      - 참고 테이블) scp_eng_delivery_o_sn -> scp_anl_shipment_plan_semi (SCP SEMI 출하계획 정보)  변경                                            
                  --(주석종료)20181207 주석처리함 : PROC_BOD의 fixed_term이 내부 site는 "0"처리되므로 ssp_anl_shipment_plan_semi(내부site 처리) 사용부분은 주석처리함) : 이부분처리시 PROC_BOD의 fixed_term컬럼부분 처리검토 필요함  
				  
                  -----------------------------------------------------------
                  --3. 특성 BOD : FP 생산계획중 특성공정을 Fixed Plan(001 -> 002)로 반영
                       참고) 변경시 PROC_BOD, ITEM_BOD_CAL 의 특성 처리부분도 수정검토필요함
                  -----------------------------------------------------------
                      - FP 생산계획의 자동차(81), ESS(82)사업부의 특성공정(F6000공정) 정보를 INSERT
                      
                      - 컬럼1) site_id         : scm_dnm_plan_frozen_v.scm_site_id + '~002' 형태로 입력됨
                      - 컬럼2) route_id        : 'CHAR::' + scm_mst_bod_eng.bod_id --20190218수정 특성CAPA처리(변경전 : scm_dnm_plan_frozen_v.item_id + '::' + scm_mst_bod_eng.bod_id)
                      - 컬럼3) operation_id    : 'CHAR::' + scm_mst_bod_eng.bod_id --20190218수정 특성CAPA처리(변경전 : scm_dnm_plan_frozen_v.item_id + '::' + scm_mst_bod_eng.bod_id)
                      - 컬럼4) resource_id     : 'CHAR::' + scm_mst_bod_eng.bod_id --20190218수정 특성CAPA처리(변경전 : scm_dnm_plan_frozen_v.item_id + '::' + scm_mst_bod_eng.bod_id)

                      - 참고 뷰)  : scm_dnm_plan_frozen_v : FP 생산계획 정보
                      - 참고) SSP(plan_cycle = 'DAILY')일 경우
                              -- 1) 자동차(81), ESS(82) : F6000 공정만 특성계획 6주 처리함
                              -- 2) 소형(40)            : 오창(plant_id : A010) 이면서 F5300, F5500, F5600, F6000 공정만 특성계획 6주 처리함(20181101 추가)                                                  
                                                          참고) 오창(plant_id = 'A010') - F6000
                                                                남경(plant_id = 'G182') - F5300(원/각), F5500(파우치), F5600(파우치 - 수작업 : 실적만)

                  -----------------------------------------------------------
                  --4. (20190702) 동일 공장 내 Cell -> Pack 확정선적계획 : Fixed Plan(A~002 -> P~***)으로 반영
                  -----------------------------------------------------------
                      - FP 정보 IF하여 확정 DO로 반영 : Fix Plan
                      - Fixed Term : Term 없음
                      - CATEGORY : MOVING
                      - from_site / to_site 는 Plant ID 에 존재하는 Cell/Pack Site 로 처리

 * OutTable     :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017.12.01   정원식         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.05.28   KSW            선적 FIX plan 처리부분 추가 (1-2) 참고)
 * 2018.06.26   KSG            특성 계획 3주 반영 : 수정 시 Proc BOD도 동시 반영 필요
 * 2018.07.16   KSW            ssp_anl_ship_confirm 테이블 사용시 change_type = 'C' 조건추가
 * 2018.09.28   KSG            특성 계획 6주 반영 : 소형은 적용 안 함 : 수정 시 Proc BOD도 동시 반영 필요
 * 2018.11.09   KSW            하드코딩부분 lookup테이블로 변경 (특성화공정 F5300, F5500, F5600, F6000 -> lookup테이블 조회로 변경) (참고)주석3
 * 2018.12.06   KSW            특성 계획 6주 반영안함(주석3 부분 주석처리함) : 수정 시 PROC_BOD 도 동시 반영 필요  (참고)주석3  (참고2) SP(DAILY)는 특성계획 반영함
 * 2018.12.07   KSW            "SSP비대상 확정 출하 계획 정보 Insert" 처리부분 주석처리함 : 이부분 수정시 PROC_BOD의 fixed_term 컬럼 처리부분도 수정검토필요함 (참고)주석2 
 * 2018.12.11   KSW            (2018.12.06 수정내용 원복) 특성 계획 6주 반영함 : 수정 시 Fixed Plan 도 동시 반영 필요  (참고)주석3
 * 2018.12.17   KSW            scm_dnm_plan_frozen_v.plan_qty > 0 조건추가 (참고)주석3
 * 2018.12.19   KSW            @v_pre_plan_start_yyyymmdd, @v_pre_plan_id 변수값 수정(전주에 배치 미실행했을경우 때문에  전주 -> confirm_flag='Y'인 이전데이터중 가장최근이전주로 변경)
 * 2018.12.20   KSW            키중복오류관련 수정 (DISTINCT처리함) (참고)주석1-2
 * 2019.01.04   KSW            (FIX) 확정 출하 계획 정보 Insert 부분수정 (참고)주석1-2  (  scp_anl_shipment_plan_fix테이블은 to site가 PLANT 일때 project_code, incoterms컬럼모두 NULL 인데  ssp_anl_ship_confirm 테이블은     to site가 PLANT 일때도 project_code, incoterms컬럼 둘다 값을 가지고 있어서  조인이 안되므로 to site가  PLANT 일때 두테이블의 project_code, incoterms 컬럼의 값을 '-'로 셋팅함 )
 * 2019.01.22   KSW            (속도개선) (FIX) 확정 출하 계획 정보 Insert처리부분 조인방법변경 (참고)주석1-2
 * 2019.02.18   KSW            특성 CAPA 반영 관련 수정 (참고)주석3 (이부분 수정시 1)PROC_BOD, 2)PROC_ITEM_BOD, 3)PROC_FIXED_PLAN, 4)PROC_PRODUCT_MIX, 5)PROC_PRODUCT_MIX_MAP 수정검토필요함)
 * 2019.06.24   KSG            [C20190621_23161] 확정구간(ship_frozen) 이후는 SSP 출하계획 확정정보 사용 안 함
 * 2019.07.02   KSG            [C20190621_23209] GSCM 시스템 개선 요청 - 특성 출하계획 반영 : 동일 공장 내 Cell -> Pack 확정선적계획
 * 2021.01.28   KSG            C20210128-000112 SCP - FP 특성계획 동기화 구간 변경 : 기존 6주 → 변경 7주
 * 2021.03.03   KSG            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 : ESS 주택용팀 SSP↔SCP 동기화 구간 설정
 *                               ESS 동기화 구간에 따른 확정 계획 조정
 * 2021.05.10   SEO            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 : SSP출하확정계획의 END_TIME을 SSP에 있는 정보 그대로 사용
 * 2021.05.26   KKC            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 : TE계획 일 경우 FP구간 이후 FIX 데이터 미생성
 * 2021.09.03   KKC            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 : TE계획 일 경우 전구간 확정계획 적용 여부 옵션화
 * 2021.10.14   KSG            PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 : AS
 * 2022.01.06   KSG            PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 : 소형 OSP Pack Item 처리
 * 2022.04.04   LHS            PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선: JV사업부 추가: 사업부 조건별 로직구현시 division_id 대신 속성값(attribute3) 기준으로 변경
                                ----------------------------------------------------------------
                                        구분                         자동차           전극
                                ==============================    =============   ==============
                                  division_group(attribute3)  :        81              EE                
                                ------------------------------    -------------   --------------
                                  division_id                 :     81 , 81_UC      EE , EE_UC  
                                ----------------------------------------------------------------
 * 2022.04.29   LHS            PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선: 소형/ESS 출하확정계획 Project code 유지 건 ( SSP의 고객향 계획만 대상 )
 * 2022.08.17   LHS            PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2: BUSINESS_TYPE검색로직 보완( AS_SITE_PLANT 대체코드 인식 )
 * 2024.10.07   KKC            PJ20249346   LGES SCP 개선과제 이행 : 자동차 해외법인 통합FP 52주 Daily 생산/출하계획 동기화 및 튜닝
                               1. 52주 통합fp 생산계획(특성포함) 동기화
                               2. ssp 테이블 변경 & 튜닝 & 동기화 (ssp_anl_ship_confirm -> scm_dnm_ssp_plan_v)
                                  scm_mst_site_eng.attr03 : org ssp frozen 
                                  scm_mst_site_eng.attr04 : 52주fp ssp frozen
                                  scm_mst_site_eng.attr07 : 52주fp plant 적용여부
                               3. 분기 로직 추가 / 정리
                                  1) ~ org ssp confirm frozen (기존 로직 유지)
                                  2) org ssp frozen ~ 52주fp ssp frozen (81사업부에 대해 신규 추가)
                                  3) org ssp frozen/52주fp ssp frozen ~ pet (로직 변경)
                                  
 */

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_IN_PRE_PROC_FIXED_PLAN]
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
    --SET ANSI_WARNINGS OFF;
    SET ANSI_WARNINGS ON;
    SET ANSI_NULLS ON;

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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_IN_PRE_PROC_FIXED_PLAN';
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
	 
    DECLARE @v_division_group   NVARCHAR(30);   ---(2022.04.04) 추가.
    DECLARE @v_division_comp    NVARCHAR(30); 
    /*------------------------------------------------------------------
     * Division Group 정의  (2022.04.04: Joint Venture 사업부 추가) 
        - JV사업부 코드(81_UC, EE_UC)추가되면서 division_id만으로는 사업부별 로직분개시 구분값으로 활용 불가.
        - 40, 81, 82, EE 등 사업부별 로직전개에 사용할 기준값을 (attribute3)컬럼에 정의하고 변수 '@v_division_group'로 처리
        - 기존의 division_id 분개로직을 division_group 기준으로 대체하여 사용한다.
        - 예) division_group: 81 >> division_id: 81 , 81_UC  >>  division_comp: LG , UC
    ----------------------------------------------------------------------*/                        
    SELECT @v_division_group   =  di.attribute3
          , @v_division_comp   =  di.attribute4  -- 회사코드
    FROM   scm_mst_division di WITH(NOLOCK)
    WHERE  di.valid_yn         =  'Y' 
    AND    di.division_id      =  @p_division_id ; 


    /*~(2022.04.29) Project code 유지여부 설정 변수 정의. * division_id, plan_type별 가부(Y/N)을 lookup에서 등록한다. ~*/ 
    DECLARE @v_hp_pjt_code_yn        NVARCHAR(30) = 'N'   ;   

	SELECT @v_hp_pjt_code_yn =            
           CASE WHEN  @p_plan_type = 'PR'  THEN (CASE WHEN ISNULL(SEGMENT2 ,'-') = 'Y' THEN 'Y' ELSE 'N' END )
                WHEN  @p_plan_type = 'MA'  THEN (CASE WHEN ISNULL(SEGMENT3 ,'-') = 'Y' THEN 'Y' ELSE 'N' END )
                WHEN  @p_plan_type = 'FN'  THEN (CASE WHEN ISNULL(SEGMENT4 ,'-') = 'Y' THEN 'Y' ELSE 'N' END )
                WHEN  @p_plan_type = 'TE'  THEN (CASE WHEN ISNULL(SEGMENT5 ,'-') = 'Y' THEN 'Y' ELSE 'N' END )   
           END  
	FROM   scm_adm_lookup_master_detail a WITH(NOLOCK) 
	WHERE  a.lookup_type = 'HP_PJT_CODE_YN'
    AND    a.segment1    =  @p_division_id    
    AND    a.valid_yn    = 'Y' ;   

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
	    -- PR_SCP_ENG_IN_PRE_PROC_FIXED_PLAN_PROD 에서는 Delete 하지 않음      
        -----------------------------------------------------------         
        DELETE /* PR_SCP_ENG_IN_PRE_PROC_FIXED_PLAN */ 
        FROM   th_eng_fixed_plan_sn
        WHERE  master_id = @p_master_id
        AND    plan_id   = @p_engine_plan_id 
        ;
	    
		-----------------------------------------------------------
        --1) 지난 주 Plan 정보 조회 
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
                                                        ELSE 9   -- 20181115 추가 'TE', 'TM' 때문에 추가함 (주의 ELSE 처리안하면 TE, TM 가장최근에 실행되었으면  TE, TM이 NULL로 처리되어서 첫번째로 조회될수 있음)  ('TE' : 시뮬레이션용 'PR'과 동일하게 처리됨, 'TM': 시뮬레이션용 'MA'동일하게 처리됨) 
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
        WHERE  division_id = @p_division_id 
        AND    plan_type   = @v_pre_plan_type_daily
        AND    plan_status = 1
        ;

        SELECT @n_pre_plan_seq_daily = MAX(plan_seq)
        FROM   scm_mst_plan_detail WITH (NOLOCK)
        WHERE  division_id = @p_division_id 
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
        ***************************************************************/
        
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
           DO::SSPR::~ 100000  //ESS만을 위한 SSP FROZEN 구간 존재시(LOOKUP으로 관리)
           DO::FOR::~ 300000
           SSP CONFIRM ID 그대로 일련번호 (ex.CXXX~)
           SCP FIX ID 그대로 일련번호(ex.FXXX~)
         */

        -----------------------------------------------------------
        --SSP 동기화 데이터 공용화, 2024.10.07 추가
        --SSP View 테이블으로 JOIN처리시 속도 저하 방지 및 재사용 공용화
        --View 데이터 정제화 : ssp frozen 구간내는 Conifrm SSP /이후는 REQ SSP
        --scm_mst_site_eng.attr03 : org ssp frozen 기준으로 구분 
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#scm_dnm_ssp_plan_v_temp') IS NOT NULL
        BEGIN 
            DROP TABLE  #scm_dnm_ssp_plan_v_temp;   
        END 

        SELECT a.*
          INTO #scm_dnm_ssp_plan_v_temp
          FROM scm_dnm_ssp_plan_v a WITH (NOLOCK)  -- 테이블 변경 (ssp_anl_ship_confirm -> scm_dnm_ssp_plan_v)
          JOIN (
                 SELECT a.division_id
                     , a.scm_site_id
                     , CASE WHEN MAX(a.attribute3) > 0 THEN CONVERT(INT, MAX(a.attribute3))
                             ELSE 0
                         END AS org_ship_frozen
                     , DATEADD(DAY, CASE WHEN MAX(a.attribute3) > 0 THEN CONVERT(INT, MAX(a.attribute3))
                                         ELSE 0
                                     END
                                         , CONVERT(DATETIME, @p_plan_name)
                                     )
                             AS ssp_confirm_date
                   FROM scm_mst_site_eng a WITH(NOLOCK)
                  WHERE 1=1
                    AND a.modeling_id = @p_modeling_id
                    AND a.plan_id     = @p_plan_id
                    AND a.plan_type   = @p_plan_type
                    AND a.plan_seq    = @p_seq                        
                  GROUP 
                     BY a.division_id
                      , a.scm_site_id
               ) b
            ON a.division_id = b.division_id
           AND a.from_site   = b.scm_site_id
         WHERE a.division_id  = @p_division_id
           AND a.qty          > 0
           AND a.yyyymmdd     >= @p_plan_name
           AND a.yyyymmdd     <= @v_pet_date
           AND a.ssp_type     IN ('CFM', 'REQ')  
           AND a.biz_type     <> 'E'  --전극 제외 (전극은 전극 프로시져에서 사용)
           /*
           AND a.from_site = 'G671-A'
           AND a.to_site   = 'GM_US_BQN'
           AND a.bod_id    = '9917'
           AND a.yyyymmdd  = '20241014' --@p_plan_name
           */
           AND a.ssp_type = CASE WHEN a.yyyymmdd >= CONVERT(VARCHAR, b.ssp_confirm_date, 112) THEN 'REQ'
                                 ELSE 'CFM'
                             END  
        ;

        --1-1) (FIX) SSP Confirm 대상 출하계획 확정정보 Insert (ship_frozen 기간이내)
        --     - ssp_anl_ship_confirm (SSP 출하 확정정보)
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_FIXED_PLAN */ th_eng_fixed_plan_sn
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
        , project_code    --~(2022.04.29) 추가.
        , business_type   --~(2022.04.29) 추가.
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
             , NULL AS sub_resource_id             
             , CONVERT(DATETIME, a.yyyymmdd) AS start_dttm
             --, DATEADD(d, be.bod_lead_time, CONVERT(DATETIME,a.yyyymmdd)) AS end_dttm		
			 , a.eta_date AS end_dttm														--2021.05.10 변경             
             , a.qty AS operation_qty
             , a.qty AS complete_qty             
             , a.confirm_id AS lot_id
             , 'N' AS is_fixed
             , 'Y' AS is_prev_schedule
             , 'START_FIX'  AS keep_work_time_type
             --, 'DURATION_FIX' AS keep_work_time_type  --//keep_work_time_type 변경 고민 필요
			 , 'ALL_QTY_FIX'  AS keep_qty_type
             , NULL AS sales_model_id
             , NULL AS attribute_set_id
             , NULL AS demand_id
             , 'DO::SSP' AS descr
             , 'Y' AS is_noh_consume
             , a.project_code AS project_code      -- 2022.04.29 참고용으로 추가함.
               /*~(2022.04.29) lookup의 설정여부에 따라 business_type값 정의: SALES 사이트에 LOOKUP=Y이면 project_code값을, 그 외는 'ALL'로 설정 ~*/ 
             , CASE WHEN @v_hp_pjt_code_yn = 'Y'  AND a.project_code2 != '-'  THEN a.project_code2
                    ELSE 'ALL' 
               END  AS business_type 				 
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
                        /*~(2022.04.29)project_code2추가: to_site가 'SALES'일 때만 project code를 가져온다  ~*/ 
                      , CASE WHEN ISNULL(mse.site_type, '-') != 'SALES'  THEN  '-'
                             ELSE ISNULL(sc.project_code, '-') 
					    END  AS project_code2 
                      -- 20220106 PJ20209643 소형 OSP Pack Item 처리
                      , CASE WHEN ISNULL(fi.packer_plan_item_id, '') = '' THEN sc.item_id
                             ELSE fi.packer_plan_item_id
                        END item_id
                      --, sc.item_id
                      , sc.yyyymmdd
                      , IIF(ISNULL(sc.eta_date, '') = '', CONVERT(DATETIME, sc.yyyymmdd), sc.eta_date) AS eta_date
                      , sc.qty
                 FROM #scm_dnm_ssp_plan_v_temp sc WITH (NOLOCK) --ssp 테이블 변경(기존:ssp_anl_ship_confirm), 2024.10.07 
                 LEFT OUTER JOIN scm_adm_lookup_master_detail md WITH(NOLOCK)
                   ON sc.division_id = md.segment3
                  AND sc.to_site     = md.segment2
                  AND md.lookup_type = 'AS_SITE_PLANT'
                  AND md.valid_yn    = 'Y'						  
                  -- 20220106 PJ20209643 소형 OSP Pack Item 처리
                 LEFT JOIN scp_mst_final_item fi WITH(NOLOCK) --2018.06.29
                   ON sc.division_id    = fi.division_id
                  AND sc.item_id        = fi.item_id 
                  AND @v_division_group = '40'   ---2022.04.04 JV사업부 추가: division_id대신 division_group으로 변경.
                 LEFT OUTER JOIN (  /*~(2022.04.29) to_site의 site_type을 가져오기위해 조인추가  ~*/     
                                  SELECT DISTINCT se.division_id, se.scm_site_id , se.site_type
                                    FROM scm_mst_site_eng se WITH (NOLOCK) 
                                   WHERE se.modeling_id = @p_modeling_id
                                     AND se.plan_id     = @p_plan_id
                                     AND se.plan_type   = @p_plan_type
                                     AND se.plan_seq    = @p_seq
                                     AND se.division_id = @p_division_id
                                ) mse 
                    ON  ( 1=1
                   AND mse.scm_site_id =  ISNULL(md.segment1, sc.to_site)  /*~ 22.08.17 수정
                   AND mse.scm_site_id =  sc.to_site           --220817 수정전 코드 주석처리  ~*/ 
                   AND mse.division_id =  sc.division_id)
                 WHERE sc.ssp_type     = 'CFM' -- 조건변경 및 정리 2024.10.07  
               ) a          
              /* 52주FP통합 출하계획 동기화 2024.10.07 */ 
              INNER JOIN ( SELECT a.ship_frozen 
                                , a.scm_site_id 
                             FROM scm_mst_site_eng a WITH (NOLOCK)
                            WHERE a.modeling_id = @p_modeling_id
                              AND a.plan_id     = @p_plan_id
                              AND a.plan_type   = @p_plan_type
                              AND a.plan_seq    = @p_seq
                              AND a.division_id = @p_division_id
                              AND a.eng_scm_site_id = a.scm_site_id + '~***'    --scp_anl_shipment_plan_semi 는 BOD가  from site (plant site) ->  to site (plant site)
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
		WHERE a.yyyymmdd >= @p_plan_name --@v_cur_monday
		  AND a.yyyymmdd <  CONVERT(NVARCHAR(8), DATEADD(d, ISNULL(mse.ship_frozen, 0), @d_plan_name), 112)
		-- 20210303 PJ20209642  ESS 동기화 구간까지의 Confirm 정보 전체
		--AND    a.yyyymmdd <  CONVERT(NVARCHAR(8), DATEADD(d, ISNULL(bie.frozen_period, ISNULL(mse.ship_frozen, 0)), @d_plan_name), 112)
		;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id; 
        SET @v_description = N'1-1) (FIX) SSP Comfirm 대상 출하계획 확정정보 Insert' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
        -----------------------------------------------------------
		-- 20210303 PJ20209642 추가
        --1-1) (FIX) SSP Ship Req 대상 출하계획 정보 Insert (ship_frozen 이후 ESS 동기화 기간이내)
        --   SSP_ANL_SHIP_PLAN_ALL (SSP confirm + 출하계획정보)
        -----------------------------------------------------------

        /* ESS 기존 로직 유지 */
        IF @v_division_group = '82'

        BEGIN
         
        INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_FIXED_PLAN */ th_eng_fixed_plan_sn
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
        , project_code    --~(2022.04.29) 추가.
        , business_type   --~(2022.04.29) 추가.
        )
        SELECT @p_master_id AS master_id
             , @p_engine_plan_id AS plan_id              
             , 'DO::SSPR::' + CONVERT(NVARCHAR(10), 100000 + ROW_NUMBER() OVER (ORDER BY a.item_id)) AS work_order_id             
             , 1 AS work_order_seq
             , be.eng_to_site   AS site_id --(변경전 : , a.to_site_id  AS site_id)
             , a.item_id + '::' + a.bod_id + '::x::x' AS route_id
             , a.item_id + '::' + a.bod_id + '::x::x' AS operation_id
             , a.item_id
             , a.item_id + '::' + a.bod_id + '::x::x' AS resource_id
             , NULL AS sub_resource_id             
             , CONVERT(DATETIME, a.yyyymmdd) AS start_dttm
             --, DATEADD(d, be.bod_lead_time, CONVERT(DATETIME,a.yyyymmdd)) AS end_dttm
			 , a.eta AS end_dttm																--2021.05.10 변경             
             , a.shipment_confirm_qty AS operation_qty
             , a.shipment_confirm_qty AS complete_qty             
             , 'DO::SSPR::' + CONVERT(NVARCHAR(10), 100000 + ROW_NUMBER() OVER (ORDER BY a.item_id)) AS lot_id
             , 'N' AS is_fixed
             , 'Y' AS is_prev_schedule
             , 'START_FIX'  AS keep_work_time_type
           --, 'DURATION_FIX' AS keep_work_time_type  --//keep_work_time_type 변경 고민 필요
             , 'ALL_QTY_FIX'  AS keep_qty_type
             , NULL AS sales_model_id
             , NULL AS attribute_set_id
             , NULL AS demand_id
             , 'DO::SSPR' AS descr
             , 'Y' AS is_noh_consume
             , project_code AS project_code   -- 2022.04.29 추가
               /*~(2022.04.29) lookup의 설정여부에 따라 business_type값 정의: SALES 사이트에 LOOKUP=Y이면 project_code값을, 그 외는 'ALL'로 설정  ~*/ 
            , CASE WHEN @v_hp_pjt_code_yn = 'Y'  AND project_code2 != '-'  THEN project_code2
                   ELSE 'ALL' 
              END  AS  business_type 
        -- 20211013 [PJ20214907] AS : SSP의 'AS(WH-In 용) Plant Plan' 을 'AS(WH-In 용) Sales Plan' 으로 전환
		-- SSP에서 BOD ID까지 전환하므로 원래 BOD ID로 전환
        /*FROM   ( SELECT sr.* 
                 FROM   ssp_anl_ship_plan_all sr WITH (NOLOCK)

                        INNER JOIN (SELECT sr.division_id, sr.company_id, MAX(sr.plan_start_yyyymmdd) AS plan_start_yyyymmdd
                                    FROM   ssp_anl_ship_plan_all sr WITH (NOLOCK)
                                    WHERE  1 = 1
                                    AND    sr.division_id = '82' -- @p_division_id  -- ESS 사업부 대상
                                    GROUP BY sr.division_id, sr.company_id
                                   )  srv
                        ON  sr.division_id         = srv.division_id
                        AND sr.company_id          = srv.company_id
                        AND sr.plan_start_yyyymmdd = srv.plan_start_yyyymmdd
                 WHERE  1 = 1
                 AND    sr.shipment_confirm_qty  >  0
               ) a*/
        FROM   ( SELECT sr.division_id, sr.from_site
                      , ISNULL((SELECT TOP 1 b.bod_id 
								  FROM scp_mst_bod_n_v b
								 WHERE b.division_id    = sr.division_id
								   AND b.from_site      = sr.from_site
								   AND b.to_site        = md.segment1
								   AND b.incoterms      = 'DAP' --sr.incoterms
								   AND b.transport_mode = sr.transport_mode
								   AND sr.yyyymmdd      BETWEEN b.from_yyyymmdd AND b.to_yyyymmdd
								   AND b.bod_valid_yn   = 'Y'
								 ORDER BY b.priority
							   ) 
                             , sr.bod_id)               AS bod_id
                      , ISNULL(md.segment1, sr.to_site) AS to_site
                      , sr.incoterms, sr.transport_mode, sr.change_type
                      , sr.project_code, sr.fcst_type                        
                      , ISNULL(sr.project_code, '-') as project_code2  /*~(2022.04.29)project_code2추가: scm_mst_site 와 조인 시 to_site가 'SALES'만 가져오므로 여기서는 ISNULL처리만 한다 ~*/ 
                      , sr.item_id
                      , sr.yyyymmdd
                      , IIF(ISNULL(sr.eta, '') = '', CONVERT(DATETIME, sr.yyyymmdd), sr.eta) AS eta
                      , sr.shipment_confirm_qty
                 FROM   ssp_anl_ship_plan_all sr WITH (NOLOCK)  --//기존 로직 유지(대상 사업부 아님), 2024.10.07 
                        INNER JOIN (
                                    SELECT sr.division_id, sr.company_id, MAX(sr.plan_start_yyyymmdd) AS plan_start_yyyymmdd
                                    FROM   ssp_anl_ship_plan_all sr WITH (NOLOCK)
                                    WHERE  1 = 1
                                    AND    @v_division_group = '82' -- @p_division_id  -- ESS 사업부 대상, (2022.04.04) JV사업부 추가: division_id대신 division_group으로 변경
                                    AND    sr.division_id    =  @p_division_id
                                    GROUP BY sr.division_id, sr.company_id
                                    /* 20220404 변경전 
                                    SELECT sr.division_id, sr.company_id, MAX(sr.plan_start_yyyymmdd) AS plan_start_yyyymmdd
                                    FROM   ssp_anl_ship_plan_all sr WITH (NOLOCK)
                                    WHERE  1 = 1
                                    AND    sr.division_id = '82' -- @p_division_id  -- ESS 사업부 대상
                                    GROUP BY sr.division_id, sr.company_id    */ 
                                   )  srv
                        ON  sr.division_id         = srv.division_id
                        AND sr.company_id          = srv.company_id
                        AND sr.plan_start_yyyymmdd = srv.plan_start_yyyymmdd

                        LEFT OUTER JOIN scm_adm_lookup_master_detail md WITH(NOLOCK)
                        ON   sr.division_id = md.segment3
                        AND  sr.to_site     = md.segment2
                        AND  md.lookup_type = 'AS_SITE_PLANT'
                        AND  md.valid_yn    = 'Y'
                 WHERE  1 = 1
                 AND    sr.shipment_confirm_qty  >  0
               ) a			   
               INNER JOIN scm_mst_site s
               ON  a.division_id = s.division_id
               AND a.to_site     = s.scm_site_id
               AND s.site_type    = 'SALES'
               AND s.valid_yn     = 'Y'
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
			   -- 20210303 PJ20209642 BOD Item 추가
               LEFT OUTER JOIN 
                          ( SELECT dbo.FN_SCM_SPLIT(bod_id, 1, '::')  AS bod_id
                                 , item_id                            AS item_id
                                 , frozen_period                      AS frozen_period -- ESS 동기화 구간 : BOD Fixed Term으로 적용됨
                                 , CONVERT(INT, attribute3)           AS ship_frozen   -- Plant Site의 Ship Frozen 설정값 : SSP Confirm 값을 확정계획으로 반영
                            FROM   scm_mst_bod_item_eng WITH (NOLOCK)
                            WHERE  plan_id     = @p_plan_id
                            AND    plan_type   = @p_plan_type
                            AND    plan_seq    = @p_seq
                            AND    division_id = @p_division_id          
                          ) bie
               ON   a.bod_id  = bie.bod_id
               AND  a.item_id = bie.item_id
        WHERE  a.yyyymmdd >= CONVERT(NVARCHAR(8), DATEADD(d, ISNULL(mse.ship_frozen, 0), @d_plan_name), 112) -- CONVERT(NVARCHAR(8), DATEADD(d, ISNULL(bie.ship_frozen, ISNULL(mse.ship_frozen, 0)), @d_plan_name), 112)
        AND    a.yyyymmdd <  CONVERT(NVARCHAR(8), DATEADD(d, ISNULL(bie.frozen_period, ISNULL(mse.ship_frozen, 0)), @d_plan_name), 112)
        ;

        END

        /* 81 : 신규로직 추가 (52주fp통합 출하계획 : ship frozen이후 ssp ship req 동기화) */
        IF @v_division_group = '81'

        BEGIN

        INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_FIXED_PLAN */ th_eng_fixed_plan_sn
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
        , project_code    --~(2022.04.29) 추가.
        , business_type   --~(2022.04.29) 추가.
        )
        SELECT @p_master_id      AS master_id
             , @p_engine_plan_id AS plan_id              
             --, a.confirm_id      AS work_order_id             
             , 'DO::SSPR::' + CONVERT(NVARCHAR(10), 100000 + ROW_NUMBER() OVER (ORDER BY a.item_id)) AS work_order_id 
             , 1                 AS work_order_seq
             , be.eng_to_site    AS site_id --(변경전 : , a.to_site_id  AS site_id)
             , a.item_id + '::' + a.bod_id + '::x::x' AS route_id
             , a.item_id + '::' + a.bod_id + '::x::x' AS operation_id
             , a.item_id
             , a.item_id + '::' + a.bod_id + '::x::x' AS resource_id
             , NULL                                   AS sub_resource_id             
             , CONVERT(DATETIME, a.yyyymmdd)          AS start_dttm
             , a.eta_date                             AS end_dttm	
             , a.qty                                  AS operation_qty
             , a.qty                                  AS complete_qty             
             , a.confirm_id                           AS lot_id
             , 'N'                                    AS is_fixed
             , 'Y'                                    AS is_prev_schedule
             , 'START_FIX'                            AS keep_work_time_type
			 , 'ALL_QTY_FIX'                          AS keep_qty_type
             , NULL                                   AS sales_model_id
             , NULL                                   AS attribute_set_id
             , NULL                                   AS demand_id
             , 'DO::SSPR'                             AS descr
             , 'Y'                                    AS is_noh_consume
             , a.project_code                         AS project_code 
               /*~(2022.04.29) lookup의 설정여부에 따라 business_type값 정의: SALES 사이트에 LOOKUP=Y이면 project_code값을, 그 외는 'ALL'로 설정 ~*/ 
             , CASE WHEN @v_hp_pjt_code_yn = 'Y'  AND a.project_code2 != '-'  THEN a.project_code2
                    ELSE 'ALL' 
               END                                    AS business_type 				   
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
                        /*~(2022.04.29)project_code2추가: to_site가 'SALES'일 때만 project code를 가져온다  ~*/ 
                      , CASE WHEN ISNULL(mse.site_type, '-') != 'SALES'  THEN  '-'
                             ELSE ISNULL(sc.project_code, '-') 
					    END  AS project_code2 
                      , sc.item_id 
                      , sc.yyyymmdd
                      , IIF(ISNULL(sc.eta_date, '') = '', CONVERT(DATETIME, sc.yyyymmdd), sc.eta_date) AS eta_date
                      , sc.qty
                 FROM #scm_dnm_ssp_plan_v_temp sc WITH (NOLOCK)  --ssp req
                 LEFT OUTER JOIN scm_adm_lookup_master_detail md WITH(NOLOCK)
                   ON sc.division_id = md.segment3
                  AND sc.to_site     = md.segment2
                  AND md.lookup_type = 'AS_SITE_PLANT'
                  AND md.valid_yn    = 'Y'						  
                 LEFT OUTER JOIN (  /*~(2022.04.29) to_site의 site_type을 가져오기위해 조인추가  ~*/     
                                  SELECT DISTINCT se.division_id, se.scm_site_id , se.site_type
                                    FROM scm_mst_site_eng se WITH (NOLOCK) 
                                   WHERE se.modeling_id = @p_modeling_id
                                     AND se.plan_id     = @p_plan_id
                                     AND se.plan_type   = @p_plan_type
                                     AND se.plan_seq    = @p_seq
                                     AND se.division_id = @p_division_id
                               ) mse 
                    ON  ( 1=1
                   AND  mse.scm_site_id =  ISNULL(md.segment1, sc.to_site)  
                   /*~ 22.08.17 수정
                   AND  mse.scm_site_id =  sc.to_site           --220817 수정전 코드 주석처리  ~*/ 
                   AND  mse.division_id =  sc.division_id)
                 WHERE  sc.ssp_type     = 'REQ'  
               ) a          
              /* 52주FP통합 출하계획 동기화 2024.10.07 */ 
              INNER JOIN ( SELECT a.ship_frozen AS confirm_ship_frozen
                                , a.scm_site_id 
                                  /* 52주fp통합 ssp 동기화 기간 */ 
                                , CONVERT(INT,attribute4) AS  req_ship_frozen
                             FROM scm_mst_site_eng a WITH (NOLOCK)
                            WHERE a.modeling_id = @p_modeling_id
                              AND a.plan_id     = @p_plan_id
                              AND a.plan_type   = @p_plan_type
                              AND a.plan_seq    = @p_seq
                              AND a.division_id = @p_division_id
                              AND a.eng_scm_site_id = a.scm_site_id + '~***'    --scp_anl_shipment_plan_semi 는 BOD가  from site (plant site) ->  to site (plant site)
                              AND CONVERT(INT, a.attribute4) > 0 
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
		/* SSP CONFRIM부터 ~ SSP REQ까지 */
        WHERE a.yyyymmdd >= CONVERT(NVARCHAR(8), DATEADD(d, ISNULL(mse.confirm_ship_frozen, 0), @d_plan_name), 112)
		  AND a.yyyymmdd <  CONVERT(NVARCHAR(8), DATEADD(d, ISNULL(mse.req_ship_frozen, 0), @d_plan_name), 112)
		;

        END

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id; 
        SET @v_description = N'1-1) (FIX) SSP Req 대상 출하계획 확정정보 Insert' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        
        -----------------------------------------------------------
        --1-2) (FIX) SSP, SCP 출하계획(동일 공장 외) 확정정보 Insert (ISNULL(ESS 동기화, ship_frozen) 기간이후)
        /*
		    1. (20190624) SCP 출하계획 확정정보만 사용 : 확정구간(ship_frozen) 이후는 SSP 출하계획 확정정보 사용 안 함
                  
            - (20181220 수정 키중복방지)      ssp_anl_ship_confirm 테이블에 동일정보에 여러건의 데이터가 존재하므로 SUM(수량) 처리함 ( Confirm_id는 'C' + 임의의값("ROW_NUMBER(ORDER BY ssp.item_id)") 형식으로 생성함)
            - (20190104 수정 조인조건 컬럼값) site_type = 'PLANT'일때 1) project_code = '-', 2) incoterms = '-' 처리함  ( site_type='PLANT'일때 SCP(scp_anl_shipment_plan_fix), SSP(ssp_anl_ship_confirm) 같은정보인데 project_code, incoterms 값이 존재하는건도 있고 없는건도 존재해서 조인처리시 서로다른건으로 인식되므로 '-'로 셋팅함)
                 
            - 참고 테이블1) scp_anl_shipment_plan_fix : SCP 출하계획 확정정보
        */
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_FIXED_PLAN */ th_eng_fixed_plan_sn
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
        , project_code    --~(2022.04.29) 참고용으로 추가.
        , business_type   --~(2022.04.29) 추가.
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
             , project_code  AS project_code   --~(2022.04.29) 추가. 
               /*~(2022.04.29) lookup의 설정여부에 따라 business_type값 정의: SALES 사이트에 LOOKUP=Y이면 project_code값을, 그 외는 'ALL'로 설정 ~*/ 
             , CASE WHEN @v_hp_pjt_code_yn = 'Y'  AND  a.project_code2 != '-'  THEN  a.project_code2
                    ELSE 'ALL' 
               END  AS  business_type   
		-- (20190624) SCP 출하계획 확정정보만 사용 : 확정구간(ship_frozen) 이후는 SSP 출하계획 확정정보 사용 안 함
        FROM   (          
		       SELECT scp.fix_id     AS id 
					, scp.item_id    AS item_id
					, scp.bod_id     AS bod_id
					, scp.yyyymmdd   AS yyyymmdd
					, scp.from_site  AS from_site
					, scp.qty        AS qty    
                    , scp.project_code  AS  project_code  --~(2022.04.29) 추가. 
                    , scp.project_code2 AS  project_code2 --~(2022.04.29) 추가. 
				FROM 
					( SELECT  f.division_id, f.yyyymmdd, f.biz_type, f.item_id 
							, f.from_site, f.to_site
							, CASE WHEN mse.site_type = 'PLANT' THEN '-'
								   ELSE f.project_code
							   END project_code
							, CASE WHEN mse.site_type = 'PLANT' THEN '-'
								   ELSE f.incoterms
							   END incoterms
							, f.bod_id, f.fix_id, f.qty
                              /*~(2022.04.29) project_code2추가: to_site가 'SALES'일 때만 project code를 가져온다  ~*/ 
				            , CASE WHEN ISNULL(mse.site_type, '-') != 'SALES'  THEN '-'
                                ELSE ISNULL(f.project_code, '-') 
					          END  AS  project_code2
					   FROM  scp_anl_shipment_plan_fix f WITH (NOLOCK)
					 INNER JOIN (  SELECT DISTINCT division_id, scm_site_id, site_type
									 FROM scm_mst_site_eng WITH (NOLOCK)
								    WHERE modeling_id = @p_modeling_id 
									  AND plan_id     = @p_plan_id     
									  AND plan_type   = @p_plan_type  
									  AND plan_seq    = @p_seq        
									  AND division_id = @p_division_id
								)  mse
					 ON f.division_id = mse.division_id
					AND f.to_site     = mse.scm_site_id
				  WHERE f.division_id = @p_division_id
					AND f.qty         >  0
					AND f.yyyymmdd    >= @p_plan_name 
					/* TE버전은 FP 이후 FIX 데이터 미생성, 2021.05.26, By KKC */
					AND 1= CASE WHEN @p_plan_type = 'TE' AND @v_te_only_fp_yn = 'Y' THEN 0
					            ELSE 1
						    END
					) scp 
               ) a  				 
              INNER JOIN (    /* 52주 fp통합 ssp 동기화 기간 관련 변경, 2024.10.07 수정 */                                 
                               SELECT a.ship_frozen AS org_ship_frozen
                                    , a.scm_site_id 
                                    , CASE WHEN CONVERT(INT, a.attribute4) > 0 THEN 'Y'
                                           ELSE 'N'
                                        END         AS new_ssp_frozen_yn
                                    , CASE WHEN ISNULL(CONVERT(INT, a.attribute4), 0) > 0 THEN 
                                                CASE WHEN a.ship_frozen < ISNULL(CONVERT(INT, a.attribute4), 0) THEN CONVERT(INT,attribute4)
                                                     ELSE a.ship_frozen
                                                  END
                                           ELSE a.ship_frozen
                                       END          AS ship_frozen
                            FROM   scm_mst_site_eng a WITH (NOLOCK)
                            WHERE  a.modeling_id = @p_modeling_id
                            AND    a.plan_id     = @p_plan_id
                            AND    a.plan_type   = @p_plan_type
                            AND    a.plan_seq    = @p_seq
                            AND    a.division_id = @p_division_id
                            AND    a.eng_scm_site_id = a.scm_site_id + '~***'    --scp_anl_shipment_plan_semi 는 BOD가  from site (plant site) ->  to site (plant site)
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
                            AND    attribute1  = 'OUTER_SITE'  -- 공장외부 일때  
                          ) be
               ON   a.bod_id = be.bod_id
			   -- 20210303 PJ20209642 BOD Item 추가
               LEFT OUTER JOIN 
                          ( SELECT dbo.FN_SCM_SPLIT(a.bod_id, 1, '::')  AS bod_id
                                 , a.item_id                            AS item_id
                                 , a.frozen_period                      AS frozen_period -- ESS 동기화 구간 : BOD Fixed Term으로 적용됨
                                 , CONVERT(INT, a.attribute3)           AS ship_frozen   -- Plant Site의 Ship Frozen 설정값 : SSP Confirm 값을 확정계획으로 반영
                              FROM scm_mst_bod_item_eng a WITH (NOLOCK)
                             WHERE a.plan_id     = @p_plan_id
                               AND a.plan_type   = @p_plan_type
                               AND a.plan_seq    = @p_seq
                               AND a.division_id = @p_division_id          
                          ) bie
               ON   a.bod_id  = bie.bod_id
               AND  a.item_id = bie.item_id
        -- -- 20210303 PJ20209642 
        --WHERE  a.yyyymmdd >=  CONVERT(NVARCHAR(8), DATEADD(d, ISNULL(mse.ship_frozen, 0), @d_plan_name), 112) --확정구간 이후
        /* 52주FP통합 관련 분기 조건 추가, 2024.10.07 */
        WHERE  a.yyyymmdd >= CASE WHEN mse.new_ssp_frozen_yn = 'Y' THEN CONVERT(NVARCHAR(8), DATEADD(d, ISNULL(mse.ship_frozen, 0), @d_plan_name), 112)
                                  ELSE CONVERT(NVARCHAR(8), DATEADD(d, ISNULL(bie.frozen_period, ISNULL(mse.ship_frozen, 0)), @d_plan_name), 112)
                             END
        AND    a.yyyymmdd <= @v_pet_date
        AND    be.bod_id IS NOT NULL --20190122 추가 (속도개선)INNER JOIN을 LEFT JOIN으로 수정하면서 INNER JOIN과 같은결과를 얻기위해서 추가함
        ;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id; 
        SET @v_description = N'1-2) (FIX) 확정 출하계획(공장외부) 정보 Insert : 확정 구간외' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -- 20181207 삭제 처리함 : PROC_BOD의 fixed_term이 내부 site는 "0"처리되므로 ssp_anl_shipment_plan_semi(내부site 처리) 사용부분은 주석처리함) : 이부분처리시 PROC_BOD의 fixed_term컬럼부분 처리검토 필요함
                
        --20181211 주석해제(20181206 수정내용 원복처리) /* (주석시작)20181206 주석처리함 ( 특성 계획 6주 반영안함 : 수정 시 PROC_BOD 도 동시 반영 필요 (참고) SP(DAILY)는 특성계획 반영함
        -----------------------------------------------------------
        --3. 특성 BOD : FP 생산계획중 특성공정 정보를 Fixed Plan(001 -> 002)로 반영
        --     20210128 C20210128-000112 특성계획 동기화 구간 변경 : 기존 6주 → 변경 7주
        -- 
        --   - 컬럼1) site_id         : scm_dnm_plan_frozen_v.scm_site_id + '~002' 형태로 입력됨
        --   - 컬럼2) route_id        : 'CHAR::' + scm_mst_bod_eng.bod_id --20190218수정(변경전 : scm_dnm_plan_frozen_v.item_id + '::' + scm_mst_bod_eng.bod_id)
        --   - 컬럼3) operation_id    : 'CHAR::' + scm_mst_bod_eng.bod_id --20190218수정(변경전 : scm_dnm_plan_frozen_v.item_id + '::' + scm_mst_bod_eng.bod_id)
        --   - 컬럼4) resource_id     : 'CHAR::' + scm_mst_bod_eng.bod_id --20190218수정(변경전 : scm_dnm_plan_frozen_v.item_id + '::' + scm_mst_bod_eng.bod_id)
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_FIXED_PLAN */ th_eng_fixed_plan_sn
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
             ------------------------------------------------------
             --특성 CAPA 관련 (20190104 주석시작)
             ------------------------------------------------------
             --특성CAPA관련수정시 1)PROC_BOD, 2)PROC_ITEM_BOD, 3)PROC_FIXED_PLAN, 4)PROC_PRODUCT_MIX, 5)PROC_PRODUCT_MIX_MAP 검토필요
             --20190218 수정 특성CAPA반영관련수정( 특성BOD일때(A~001 -> A~002)일때 'CHAR' + '::' + be.bod_id 로 변경) 
             , 'CHAR::' + b.bod_id AS route_id     --20190218 수정(변경전 : a.item_id + '::' + b.bod_id AS route_id)
             , 'CHAR::' + b.bod_id AS operation_id --20190218수정(변경전:a.item_id + '::' + b.bod_id AS operation_id)
             , a.item_id
             , 'CHAR::' + b.bod_id AS resource_id --20190218수정(변경전:a.item_id + '::' + b.bod_id AS resource_id)
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
        FROM   (  
                 SELECT division_id
                      , item_id
                      , scm_site_id
                      , plan_date
                      , plan_in_qty
                      , plan_qty
                      , operation_id
                      , plant_id
                 FROM   dbo.scm_dnm_plan_frozen_v WITH(NOLOCK)   
                 WHERE  division_id = @p_division_id 
                 AND    plan_date   >= @d_plan_name
                 AND    plan_qty     > 0 --20181217 추가
                 AND    plan_in_qty  > 0 --20190626 추가
				 -- 소형은 SSP/오창만 특성계획반영 중, SCP에는 반영 안 함
                 AND    @v_division_group  IN ('81', '82')      ---(2022.04.04) JV사업부 추가: division_id 대신 division_group으로 변경
                 --   (참고) division_id <> '40' 일때는 'F6000' 데이터만 존재하므로 operation_id 조건에'F5300', 'F5500', 'F5600' 도 포함시켜도 상관없음                      
                 AND    operation_id IN ( SELECT segment1 AS operation_id FROM scm_adm_lookup_master_detail WITH (NOLOCK)
		                                  WHERE  lookup_type = 'OPERATION_CHAR'
		                                  AND    valid_yn = 'Y'
                                        ) --20181109 수정 ( 하드코딩에서 lookup테이블로 변경 )                             
               ) a
               LEFT JOIN  dbo.scm_mst_bod_eng b WITH(NOLOCK) -- 20181109 수정 속도개선을 위해서 INNER조인을 LEFT조인으로 변경함  
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
        AND    a.division_id  = @p_division_id   
        AND    a.plan_date   >= @d_plan_name --20180228 수정( @v_cur_monday 를 @p_plan_name로 변경함, plan_cycle 이 Daily 일경우도 처리되게 하기위함)
        /* 특성계획 동기화 구간 변경 : 7주 -> fp plan period 기준으로 통일, 2024.10.07 */ 
        AND    a.plan_date   <  DATEADD(DD, ISNULL(c.fp_plan_period,0), @d_plan_name) -- 2018.09.28 6주 반영 : 변경 시 Proc BOD 도 수정 필요함        
        -- 20210128 C20210128-000112 특성계획 동기화 구간 변경 : 기존 6주 → 변경 7주
      --AND    a.plan_date   <  DATEADD(DD, 7*7, @d_plan_name) -- 2018.09.28 6주 반영 : 변경 시 Proc BOD 도 수정 필요함        
        AND    b.division_id IS NOT NULL  --20181109 추가 (속도개선을 위해서INNER조인을 LEFT조인으로 변경시 INNER조인과 같은 조회값을 위해서 조건추가함)
        ;  

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id; 
        SET @v_description = N'3. 특성 BOD' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;        
		
        -----------------------------------------------------------
        --4. (20190702) 동일 공장 내 Cell -> Pack 확정선적계획 : Fixed Plan(A~002 -> P~***)으로 반영
        -----------------------------------------------------------		 
        INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_FIXED_PLAN */ th_eng_fixed_plan_sn
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
             , 'DO::INH' AS descr
             , 'Y' AS is_noh_consume                      
        FROM   ( SELECT 
                         -- 1. MOV 존재하면 MOV, 존재하지 않으면 SCP 데이터를 입력한다.      
                          CASE WHEN mov.qty IS NULL THEN scp.fix_id
                               ELSE 'DO::INH::' + CONVERT(NVARCHAR(10), 400000 + ROW_NUMBER() OVER (ORDER BY mov.item_id))
                          END AS id 
                        , ISNULL(mov.item_id, scp.item_id) AS item_id
                        , ISNULL(mov.bod_id, scp.bod_id)   AS bod_id
                        , ISNULL(mov.yyyymmdd, scp.yyyymmdd) AS yyyymmdd
                        , ISNULL(mov.from_site, scp.from_site) AS from_site
                        , ISNULL(mov.to_site, scp.to_site) AS to_site     
                        , ISNULL(mov.qty, scp.qty) AS qty                    
                 FROM 
                      ( SELECT f.division_id, f.yyyymmdd, f.biz_type, f.item_id 
							   , f.from_site, f.to_site
						       , '-' AS project_code
						       , '-' AS incoterms
                               , f.bod_id, f.fix_id, f.qty
                        FROM   scp_anl_shipment_plan_fix f WITH (NOLOCK)
                               INNER JOIN (  SELECT DISTINCT division_id, scm_site_id, site_type
                                             FROM   scm_mst_site_eng WITH (NOLOCK)
                                             WHERE  modeling_id = @p_modeling_id 
                                             AND    plan_id     = @p_plan_id    
                                             AND    plan_type   = @p_plan_type  
                                             AND    plan_seq    = @p_seq        
                                             AND    division_id = @p_division_id 
											 AND    site_type   = 'PLANT' -- 20180114 (FIX) SSP는 To Site가 PLANT인 경우만 FIX 적용
                                          )  mse
                               ON  f.division_id = mse.division_id
			                   AND f.to_site     = mse.scm_site_id
                        WHERE  f.division_id   = @p_division_id 
                        AND    f.qty           >  0
                        AND    f.yyyymmdd      >= @p_plan_name   
						/* TE버전은 FP 이후 FIX 데이터 미생성, 2021.05.26, By KKC */
						AND    1= CASE WHEN @p_plan_type = 'TE' AND @v_te_only_fp_yn = 'Y' THEN 0
								   	   ELSE 1
								  END
                        ) scp              
                        FULL OUTER JOIN 
                                ( SELECT a.division_id, a.yyyymmdd, a.biz_type, a.item_id
                                        , a.from_site
                                        , a.to_site
                                        , '-' AS project_code
                                        , '-' AS incoterms
                                        , b.bod_id, a.qty
                                  FROM  (
                                         SELECT p.division_id, CONVERT(VARCHAR(8), p.plan_date, 112) AS yyyymmdd
										      , fs.operation_group AS biz_type, p.item_id
                                              , fs.scm_site_id AS from_site
                                              , ts.scm_site_id AS to_site
                                              , p.qty
                                         FROM   scm_dnm_cell_inhouse_plan_sn p WITH(NOLOCK)
                                              , scm_mst_site fs WITH(NOLOCK)
                                              , scm_mst_site ts WITH(NOLOCK)
                                         WHERE  1=1
                                         AND    p.division_id      = @p_division_id
                                         AND    p.division_id      = fs.division_id
                                         AND    p.plant_id         = fs.plant_id
                                         AND    p.category         = 'MOVING'
                                         AND    p.plan_date       >= @p_plan_name
                                         AND    p.qty             >  0
                                         AND    fs.operation_group = 'A'
                                         AND    fs.site_type       = 'PLANT'  
                                         AND    fs.osp_yn          = 'N'
                                         AND    fs.valid_yn        = 'Y'
                                         AND    p.division_id      = ts.division_id
                                         AND    p.plant_id         = ts.plant_id
                                         AND    ts.operation_group = 'P'
                                         AND    ts.site_type       = 'PLANT'  
                                         AND    ts.osp_yn          = 'N'
                                         AND    ts.valid_yn        = 'Y'
                                        ) a
                                        INNER JOIN (
                                                    SELECT dbo.FN_SCM_SPLIT(b.bod_id, 1, '::')  AS bod_id  --20190122 수정(변경전 : INNER JOIN ( SELECT dbo.FN_SCM_SPLIT(bod_id, 1, '::')  AS bod_id )
                                                         , b.from_site, b.to_site
                                                    FROM scm_mst_bod_eng b WITH (NOLOCK)
                                        				 INNER JOIN (SELECT eng_from_site, eng_to_site, MIN(priority) AS priority
                                                                     FROM   scm_mst_bod_eng WITH (NOLOCK)
                                                                     WHERE  plan_id     = @p_plan_id
                                                                     AND    plan_type   = @p_plan_type
                                                                     AND    plan_seq    = @p_seq
                                                                     AND    division_id = @p_division_id        
                                                                     AND    attribute1  = 'INNER_SITE'  -- 공장내부 일때  
                                                                     GROUP BY eng_from_site, eng_to_site
                                         				            ) bm
                                                         ON  b.eng_from_site = bm.eng_from_site
                                                         AND b.eng_to_site   = bm.eng_to_site
                                                         AND b.priority      = bm.priority
                                                    WHERE  b.plan_id     = @p_plan_id
                                                    AND    b.plan_type   = @p_plan_type
                                                    AND    b.plan_seq    = @p_seq
                                                    AND    b.division_id = @p_division_id        
                                                    AND    b.attribute1  = 'INNER_SITE'  -- 공장내부 일때  
                                        ) b
                                        ON  a.from_site = b.from_site
                                        AND a.to_site   = b.to_site						                               
                                ) mov
                        ON   scp.division_id  = mov.division_id 
                        AND  scp.yyyymmdd     = mov.yyyymmdd
                        AND  scp.biz_type     = mov.biz_type 
                        AND  scp.item_id      = mov.item_id
                        AND  scp.project_code = mov.project_code
                        AND  scp.to_site      = mov.to_site
                        AND  scp.incoterms    = mov.incoterms 
                        AND  scp.from_site    = mov.from_site
                        AND  scp.bod_id       = mov.bod_id                   
              ) a
               --20190122 수정 (속도개선)INNER JOIN을 LEFT JOIN으로 수정
               LEFT JOIN ( SELECT dbo.FN_SCM_SPLIT(bod_id, 1, '::')  AS bod_id  --20190122 수정(변경전 : INNER JOIN ( SELECT dbo.FN_SCM_SPLIT(bod_id, 1, '::')  AS bod_id )
                                 , CONVERT(NUMERIC(18,3),attribute10) AS bod_lead_time
                                 , eng_from_site, eng_to_site
                            FROM   scm_mst_bod_eng WITH (NOLOCK)
                            WHERE  plan_id     = @p_plan_id
                            AND    plan_type   = @p_plan_type
                            AND    plan_seq    = @p_seq
                            AND    division_id = @p_division_id        
                            AND    attribute1  = 'INNER_SITE'  -- 공장내부 일때  
                          ) be
               ON   a.bod_id = be.bod_id               
               LEFT JOIN (
                  SELECT fixed_term AS ship_frozen
                        , SUBSTRING(from_site_id, 1, CHARINDEX('~', from_site_id)-1) AS from_site 
                        , SUBSTRING(to_site_id, 1, CHARINDEX('~', from_site_id)-1) AS to_site 
                        , SUBSTRING(bod_id, 1, CHARINDEX('::', bod_id)-1) AS item_id 
                        , bod_id AS eng_bod_id 
						--,*
                   FROM   th_eng_bod_sn WITH (NOLOCK)
                   WHERE  master_id       = @p_master_id
                   AND    plan_id         = @p_engine_plan_id
                   AND    from_site_id LIKE '%~002'  --내부 출하 BOD
                   AND    to_site_id   LIKE '%~***'  --내부 출하 BOD
                  )  b
               ON  a.from_site   = b.from_site
               AND a.to_site     = b.to_site
               AND a.item_id     = b.item_id
               AND b.eng_bod_id  LIKE '%' + a.bod_id + '%'
        WHERE  a.yyyymmdd >=  CONVERT(NVARCHAR(8), DATEADD(d, ISNULL(b.ship_frozen, 0), @d_plan_name), 112) --확정구간 이후
        AND    a.yyyymmdd <=  @v_pet_date
        AND    be.bod_id IS NOT NULL --20190122 추가 (속도개선)INNER JOIN을 LEFT JOIN으로 수정하면서 INNER JOIN과 같은결과를 얻기위해서 추가함
        AND    b.eng_bod_id IS NOT NULL  --(속도개선을 위해서INNER조인을 LEFT조인으로 변경시 INNER조인과 같은 조회값을 위해서 조건추가함)
        ;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id; 
        SET @v_description = N'4. 동일 공장 내 Cell -> Pack 확정선적계획' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        
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

