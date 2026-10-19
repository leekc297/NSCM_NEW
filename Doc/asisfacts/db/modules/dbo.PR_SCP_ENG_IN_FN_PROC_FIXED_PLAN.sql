
/*
 * Program ID   : PR_SCP_ENG_IN_FN_PROC_FIXED_PLAN
 * Description  : 
           1. PLAN_TYPE = 'MA' 일때 (주석처리됨)
              (20181219 주석처리함 (PR 수정안됨-> PR수정가능으로 변경되면서 "MA, TM"처리도 "SE, FN"과 동일하게 수정함으로 주석처리함) 
              - 동일 plan_id의 이전 plan_type의 최종seq의 데이터 사용(descr IN ('DO::SSP', 'DO::DELIVERY', 'DO::CFM'))

           2. 20200401 C20200318-000458 (40 : 'SE', 'FN', 'MA', 'TM', 81/82 : 'FN', 'MA', 'TM') : 81/82 SE 제외
              20200527 C20200520-000146 : 82 / SE : 추가
		        OLD) (20181219수정) PLAN_TYPE = 'SE', 'FN', 'MA', 'TM' 일때  (변경전 : PLAN_TYPE = 'SE', 'FN' 일때) 
              20200713 C20200702-000043 자동차 MA 제외
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
                  --3. (FIX) SSP, SCP 출하계획(동일 공장 외) 확정정보 Insert (확정구간(ship_frozen) 이후구간)
                  -----------------------------------------------------------
				     20190624) SCP 출하계획 확정정보만 사용 : 확정구간(ship_frozen) 이후는 SSP 출하계획 확정정보 사용 안 함
					              scp qty, scp fix_id   
                       
                       - (20181220 수정 키중복방지)      ssp_anl_ship_confirm 테이블에 동일정보에 여러건의 데이터가 존재하므로 SUM(수량) 처리함 ( Confirm_id는 'C' + 임의의값("ROW_NUMBER(ORDER BY ssp.item_id)") 형식으로 생성함)
                       - (20190104 수정 조인조건 컬럼값) site_type = 'PLANT'일때 1) project_code = '-', 2) incoterms = '-' 처리함  ( site_type='PLANT'일때 SCP(scp_anl_shipment_plan_fix), SSP(ssp_anl_ship_confirm) 같은정보인데 project_code, incoterms 값이 존재하는건도 있고 없는건도 존재해서 조인처리시 서로다른건으로 인식되므로 '-'로 셋팅함)

                       - 참고 테이블) 1) scp_anl_shipment_plan_fix : SCP 출하계획 확정정보
                                      2) ssp_anl_ship_confirm      : SSP 출하계획 확정정보 
		   
		   3. [C20200318-000458] (81 :  'SE' / 82  'SE' ) : Ship Frozen 구간(14일)에 SSP 정보 반영, 13/14일 째인 토/일은 0으로 처리
              20200527 C20200520-000146 : 82/SE 제외
              20200713 C20200702-000043 : 자동차 MA 를 SE처럼 SSP 정보 사용하도록 조정, MA도 SE처럼 13/14일째 0처리
             -----------------------------------------------------------
             --3-1) (FIX) SSP 출하계획 확정정보 Insert (ship_frozen 기간이내)
             -----------------------------------------------------------
               - SSP 출하계획 확정정보(ssp_anl_ship_confirm) 중 ship_frozen기간내의 데이터만 INSERT       
               - 참고 테이블) ssp_anl_ship_confirm : SSP 출하계획 확정정보   
             -----------------------------------------------------------
             --3-2) (FIX) SSP, SCP 출하계획(동일 공장 외) 확정정보 Insert (ship_frozen 기간이후)                  
             -----------------------------------------------------------
               20190624) SCP 출하계획 확정정보만 사용 : 확정구간(ship_frozen) 이후는 SSP 출하계획 확정정보 사용 안 함
                        scp qty, scp fix_id     
   
              - 참고 테이블1) scp_anl_shipment_plan_fix : SCP 출하계획 확정정보
              - 참고 테이블2) ssp_anl_ship_confirm      : SSP 출하계획 확정정보          

           -----------------------------------------------------------
		   3.2 FN 인 경우 동일 공장 내 Cell -> Pack 이동 정보도 Fixed Plan으로 반영 : 확정구간 이내
		       -- PR_SCP_ENG_IN_FN_PROC_BOD 의 fixed_term 적용 부분과 연동
           -----------------------------------------------------------    

           -----------------------------------------------------------
           4. 특성 BOD : FP 생산계획중 특성공정을 Fixed Plan(001 -> 002)로 반영              
                       - (20181211변경) PR처럼 데이터 생성으로 변경함, PR과 동일한소스 반영함 (20181211 변경전 :  PLAN TYPE 'MA'/'SE'/'FN' 일때 : PRE  PLAN  데이터 사용함(th_eng_fixed_plan.descr : 'DO::FOR' 데이터만 사용) )

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
           --5. (20190702) 동일 공장 내 Cell -> Pack 확정선적계획 : Fixed Plan(A~002 -> P~***)으로 반영 : 확정구간 이후
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
 * 2018.05.25   KSW            plan type = 'MA' 일때  descr 조회조건 변경 ( 변경후 : descr IN ('DO::SSP', 'DO::DELIVERY'),  변경전 : descr IN ('DO::SEMI', 'DO::FG') )
 * 2018.05.28   KSW            plan type = 'MA' 일때  선적 FIX plan 추가로 인한 descr 조회조건 변경 ( 변경후 : descr IN ('DO::SSP', 'DO::DELIVERY', 'DO::CFM'),  변경전 : descr IN ('DO::SSP', 'DO::DELIVERY') )
 * 2018.07.16   KSW            ssp_anl_ship_confirm 테이블 사용시 change_type = 'C' 조건추가
 * 2018.11.15   KSW            plan_type = 'TM' (시뮬레이션용으로 'MA'와 동일하게 처리됨) 
 * 2018.12.07   KSW            SE/FN의 "SEMI 확정 출하 계획 정보 Insert" 처리부분 조회조건 추가 (외부site일때만 처리하기 위해서 조회조건추가)  : 이부분 수정시 PROC_BOD의 fixed_term 컬럼 처리부분 검토 필요함 (참고)SE/FN처리의 주석1
 * 2018.12.11   KSW            특성 BOD 생성부분 수정( 기존 PR 데이터복사 -> PR처럼 데이터 생성으로 변경함, PR과 동일한소스 반영함) (참고)주석4
 * 2018.12.17   KSW            scm_dnm_plan_frozen_v.plan_qty > 0 조건추가 (참고)주석4
 * 2018.12.19   KSW            MA, TE 처리부분 수정 (PR 수정안됨-> PR수정가능으로 변경되면서 "MA, TM"처리도 "SE, FN"과 동일하게 수정)  (참고)주석1  
 * 2018.12.20   KSW            키중복오류관련 수정 (DISTINCT처리함) (참고)주석3
 * 2019.01.04   KSW            (FIX) 확정 출하 계획 정보 Insert 부분수정 (참고)주석3  (  scp_anl_shipment_plan_fix테이블은 to site가 PLANT 일때 project_code, incoterms컬럼모두 NULL 인데  ssp_anl_ship_confirm 테이블은     to site가 PLANT 일때도 project_code, incoterms컬럼 둘다 값을 가지고 있어서  조인이 안되므로 to site가  PLANT 일때 두테이블의 project_code, incoterms 컬럼의 값을 '-'로 셋팅함 )
 * 2019.01.22   KSW            (속도개선) (FIX) 확정 출하 계획 정보 Insert처리부분 조인방법변경 (참고)주석3
 * 2019.02.18   KSW            특성 CAPA 반영 관련 수정 (참고)주석4 (이부분 수정시 1)PROC_BOD, 2)PROC_ITEM_BOD, 3)PROC_FIXED_PLAN, 4)PROC_PRODUCT_MIX, 5)PROC_PRODUCT_MIX_MAP 수정검토필요함)
 * 2019.06.24   KSG            [C20190621_23161] 확정구간(ship_frozen) 이후는 SSP 출하계획 확정정보 사용 안 함
 * 2019.07.02   KSG            [C20190621_23209] GSCM 시스템 개선 요청 - 특성 출하계획 반영 : 동일 공장 내 Cell -> Pack 확정선적계획
 * 2020.04.01   KSG            C20200318-000458 GSCM 출하확정계획(SSP) 반영시점 변경요청 (월 →수)
 * 2020.05.27   KSG            C20200520-000146  [SCM PI팀] SSP 변경내용의 SCP 반영버전을 기존 Pre버전으로 원복요청
 * 2020.07.13   KSG            C20200702-000043 [SCM PI] GSCM Weekly Timeline 변경 건 : 
 *                             자동차 MA 를 SE처럼 SSP 정보 사용하도록 조정, MA도 SE처럼 13/14일째 0처리
 * 2021.01.28   KSG            C20210128-000112 SCP - FP 특성계획 동기화 구간 변경 : 기존 6주 → 변경 7주
 * 2021.03.03   KSG            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 : ESS 주택용팀 SSP↔SCP 동기화 구간 설정
 *                               ESS 동기화 구간에 따른 확정 계획 조정
 * 2021.05.10   SEO            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 : SSP출하확정계획의 END_TIME을 SSP에 있는 정보 그대로 사용
 * 2021.05.26   KKC            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 : TM버전에 대해서는 FIX 데이터 미생성
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
 * 2023.02.14   SHS            PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행: MA/SE 계획 추가 / 8주 FP확정계획 변경
 * 2023.02.23   SHS            PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행: MA/SE 계획 추가시 출하확정구간 재정의
 * 2024.10.07   KKC            PJ20249346   LGES SCP 개선과제 이행 : 자동차 해외법인 통합FP 52주 Daily 생산/출하계획 동기화 및 튜닝
                               1. 52주 통합fp 생산계획(특성포함) 동기화
                               2. ssp 테이블 변경 & 튜닝 & 동기화 (ssp_anl_ship_confirm -> scm_dnm_ssp_plan_v)
                                  scm_mst_site_eng.attr03 : org ssp frozen 
                                  scm_mst_site_eng.attr04 : 52주fp ssp frozen
                                  scm_mst_site_eng.attr07 : 52주fp plant 적용여부
                               3. 분기 로직 추가 
                                  3-1. 52주fp 적용 plant외 (기존 로직 유지)
                                      . semi/fg scp amend 적용
                                  3-2. 52주fp 적용 plant (신규)
                                      . ~ 52주fp ssp frozen
                                      . 52주fp ssp frozen ~ ship frozen
                                      . ship frozen ~
                                  3-3. 공통 (기존로직 유지)                                      
 * 2024.11.26   KKC				PJ20249346   LGES SCP 개선과제 이행 : 소형 Semi Plan 추가
 * 2025.08.01	YMH				CSR : E20250724-001388 소형 SE 제거 , MA 에서 FP계획 -> SCP AMEND 로 변경
 */
CREATE PROCEDURE  [dbo].[PR_SCP_ENG_IN_FN_PROC_FIXED_PLAN]
    ( @p_plan_cycle1  NVARCHAR(150)
    , @p_plan_name1   NVARCHAR(4000)
    , @p_plan_id1     NVARCHAR(4000)
    , @p_modeling_id1 NVARCHAR(4000)
    , @p_seq1         NVARCHAR(4000)
    , @p_plan_type1   NVARCHAR(4000)
    , @p_master_id1   NVARCHAR(4000)
    , @p_division_id1 NVARCHAR(30)
    , @p_engine_plan_id1 NVARCHAR(4000)
    --
    , @p_pre_plan_type1 NVARCHAR(4000)
    , @p_pre_plan_seq1  NVARCHAR(4000)
    , @p_pre_engine_plan_id1 NVARCHAR(4000)
    
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
    
    DECLARE @p_pre_plan_type NVARCHAR(4000) = @p_pre_plan_type1;
    DECLARE @p_pre_plan_seq  NVARCHAR(4000) = @p_pre_plan_seq1;
    DECLARE @p_pre_engine_plan_id NVARCHAR(4000) = @p_pre_engine_plan_id1; 

    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_IN_FN_PROC_FIXED_PLAN';
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

    DECLARE @v_division_group   NVARCHAR(30);   ---(2022.04.04) 추가
    DECLARE @v_division_comp    NVARCHAR(30); 
    /*------------------------------------------------------------------
     * Division Group 정의  (2022.04.04: Joint Venture 사업부 추가) 
        - JV사업부 코드(81_UC, EE_UC)추가되면서 division_id만으로는 사업부별 로직분개시 구분값으로 활용 불가.
        - 40, 81, 82, EE 등 사업부별 로직전개에 사용할 기준값을 (attribute3)컬럼에 정의하고 변수 '@v_division_group'로 처리
        - 기존의 division_id 분개로직을 division_group 기준으로 대체하여 사용한다.
        - 예) division_group: 81 >> division_id: 81 , 81_UC >>  division_comp: LG , UC 
    ----------------------------------------------------------------------*/   
    SELECT @v_division_group   =  di.attribute3 
         , @v_division_comp    =  di.attribute4  -- 회사코드
    FROM   scm_mst_division di WITH(NOLOCK)
    WHERE  di.valid_yn         =  'Y' 
    AND    di.division_id      =  @p_division_id  ; 
    
    /*~(2022.04.29) Project code 유지여부 설정 변수 정의. * division_id, plan_type별 가부(Y/N)을 lookup에서 등록한다. ~*/ 
    DECLARE @v_hp_pjt_code_yn        NVARCHAR(30) = 'N'   ;   

	/* SE 추가, 2023.02.14 */
	SELECT @v_hp_pjt_code_yn =            
           CASE WHEN  @p_plan_type = 'PR'  THEN (CASE WHEN ISNULL(SEGMENT2 ,'-') = 'Y' THEN 'Y' ELSE 'N' END )
                WHEN  @p_plan_type = 'MA'  THEN (CASE WHEN ISNULL(SEGMENT3 ,'-') = 'Y' THEN 'Y' ELSE 'N' END )
                WHEN  @p_plan_type = 'SE'  THEN (CASE WHEN ISNULL(SEGMENT4 ,'-') = 'Y' THEN 'Y' ELSE 'N' END )
                WHEN  @p_plan_type = 'FN'  THEN (CASE WHEN ISNULL(SEGMENT5 ,'-') = 'Y' THEN 'Y' ELSE 'N' END )
                WHEN  @p_plan_type = 'TE'  THEN (CASE WHEN ISNULL(ATTRIBUTE1 ,'-') = 'Y' THEN 'Y' ELSE 'N' END )   
           END  
	FROM   scm_adm_lookup_master_detail a WITH(NOLOCK) 
	WHERE  a.lookup_type = 'HP_PJT_CODE_YN'
    AND    a.segment1    =  @p_division_id
    AND    a.valid_yn    = 'Y' 
    ; 

	/* ERROR 방지 코드 추가, 2023.02.14 */
	IF @v_hp_pjt_code_yn  IS NULL
		BEGIN
			SET @v_hp_pjt_code_yn = 'N';
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
        --SSP 동기화 데이터 공용화, 2024.10.07 추가
        --SSP View 테이블으로 JOIN처리시 속도 저하 방지 및 재사용 공용화
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
           AND a.ssp_type = CASE WHEN a.yyyymmdd >= CONVERT(VARCHAR, b.ssp_confirm_date, 112) THEN 'REQ'
                                 ELSE 'CFM'
                             END  
        ;

        DELETE /* PR_SCP_ENG_IN_FN_PROC_FIXED_PLAN */ 
        FROM   th_eng_fixed_plan_sn
        WHERE  master_id = @p_master_id
        AND    plan_id   = @p_engine_plan_id 
        ;
        -----------------------------------------------------------
        --1) scp_anl_shipment_plan_semi 테이블의  최종입력 데이터의 plan 정보 조회 
          SELECT @v_pre_plan_start_yyyymmdd = @p_plan_name 
               , @v_pre_plan_type           = @p_pre_plan_type
               , @n_pre_plan_seq            = @p_pre_plan_seq;        
        
        -- 20181219 주석처리함 (PR 수정안됨-> PR수정가능으로 변경되면서 "MA, TM"처리도 "SE, FN"과 동일하게 수정함으로 주석처리함)
        -- 20181219수정 'MA', 'TM' 추가  (PR 수정안됨-> PR수정가능으로 변경되면서 "MA, TM"처리도 "SE, FN"과 동일하게 수정함으로 주석처리함) 
		-- 20200401 C20200318-000458 (40 : 'SE', 'FN', 'MA', 'TM', 81/82 : 'FN', 'MA', 'TM') : 81/82 SE 제외
		-- 20200527 C20200520-000146 82 SE 추가
        -- 20200713 C20200702-000043 자동차 MA 제외
		-- 2023.02.23 자동차/ESS/소형 동일 분기 조건으로 변경.
		IF    ( @v_division_group = '40' AND @p_plan_type IN ('MA', 'TM', 'SE', 'FN') ) 
		   OR ( @v_division_group = '81' AND @p_plan_type IN ('MA', 'TM', 'SE', 'FN') ) 
		   OR ( @v_division_group = '82' AND @p_plan_type IN ('MA', 'TM', 'SE', 'FN') )
        /* 2023023 변경전 
		IF    ( @v_division_group = '40' AND @p_plan_type IN ('MA', 'TM', 'SE', 'FN') )     ---2022.04.04 JV사업부 추가: division_id대신 division_group으로 변경.
		   OR ( @v_division_group = '81' AND @p_plan_type IN ('FN') ) -- ('MA', 'TM', 'FN') )
		   OR ( @v_division_group = '82' AND @p_plan_type IN ('MA', 'TM', 'SE', 'FN') )
         */
		/* 20220404 변경전 
        IF    ( @p_division_id = '40' AND @p_plan_type IN ('MA', 'TM', 'SE', 'FN') )   
		   OR ( @p_division_id = '81' AND @p_plan_type IN ('FN') ) -- ('MA', 'TM', 'FN') )
		   OR ( @p_division_id = '82' AND @p_plan_type IN ('MA', 'TM', 'SE', 'FN') )    */
        --IF @p_plan_type IN ('MA', 'TM', 'SE', 'FN') 



        BEGIN

            /* 2024.10.07
               [WORK ORDER ID] 생성 채번 규칙 정리 
               
               [52주fp통합plant外]
               [~ ship frozen내]
               DO::SEMI::  ~ 100000
               DO::FG::    ~ 100000
               
               [52주fp통합plant]
               [~ ssp frozen내] 
               DO::SSP/SSPR::+500000 (신규)
               DO::SEMI::  ~ 200000
               DO::FG::    ~ 200000

               [공통plant]
               DO::CFG::+scp fix id
               DO::SEMI::  ~ 300000 (자가 Plant 반제품 이동(동일법인)              
               --특성
               DO::FOR::~
             */
            
             /**********************************************************
             1. 52fp통합 plant 대상 제외, 2024.10.07
                ENG Ship Frozen구간내  scp amend 기준 출하확정계획생성
             ***********************************************************/
            -----------------------------------------------------------
            --1-1. SEMI 출하계획 정보 Insert (Ship Frozen 구간 내)
            --   scp_anl_shipment_plan_semi 이전 plan_type 정보 사용 
            -----------------------------------------------------------
            INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_FIXED_PLAN */ th_eng_fixed_plan_sn
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
                        WHERE  division_id         = @p_division_id  
                        AND    plan_start_yyyymmdd = @v_pre_plan_start_yyyymmdd
                        AND    plan_type           = @v_pre_plan_type 
                        AND    seq                 = @n_pre_plan_seq 
                        AND    measure             = 'SHIP_PLAN_AMEND'
                        AND    qty                 > 0
                    ) a               
                    INNER HASH JOIN (  
                               SELECT  a.ship_frozen
                                     , a.scm_site_id 
                                 FROM  scm_mst_site_eng a WITH (NOLOCK)
                                WHERE  a.modeling_id = @p_modeling_id
                                  AND  a.plan_id     = @p_plan_id
                                  AND  a.plan_type   = @p_plan_type
                                  AND  a.plan_seq    = @p_seq
                                  AND  a.division_id = @p_division_id
                                  AND  a.eng_scm_site_id = a.scm_site_id + '~***'    --scp_anl_shipment_plan_semi 는 BOD가  from site (plant site) ->  to site (plant site)
                                  AND  ISNULL(a.attribute7, 'N') = 'N'   --52주통합plant 적용 대상 제외, 2024.10.07 추가
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
            AND    a.yyyymmdd <  CONVERT(NVARCHAR(8), DATEADD(d, ISNULL(mse.ship_frozen, 0), @d_plan_name), 112)  -- SE, FN ship_frozen : 364 ( 참고 : PR_SCP_ENG_IN_FN_SET_SITE_ENG의 ship_frozen 컬럼 생성부분)
            ;

            -- TXN LOG
            SET @n_log_count = @@ROWCOUNT;
            SET @v_log_type = 'TXN';
            SET @v_log_message = 'INSERT INTO '+@v_table_id; 
            SET @v_description = N'1-1. [fp52주통합plant外]SEMI 출하계획 정보 Insert (Ship Frozen 구간 내)' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
            SET @d_event_date = SYSDATETIME();
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

            -----------------------------------------------------------
            --1-2. FG 출하계획 정보 Insert (Ship Frozen 구간 내)
            --  scp_anl_shipment_plan_fg 이전 plan_type 정보사용
            -----------------------------------------------------------
            INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_FIXED_PLAN */ th_eng_fixed_plan_sn
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
               SELECT @p_master_id AS master_id
                    , @p_engine_plan_id AS plan_id    
                    , 'DO::FG::' + CONVERT(NVARCHAR(10), 100000 + ROW_NUMBER() OVER (ORDER BY a.item_id)) AS work_order_id  -- 임의의 중복되지 않는값을 사용하기 위해서 row_number() 처리 함              
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
                    , 'DO::FG::' + CONVERT(NVARCHAR(10), 200000 + ROW_NUMBER() OVER (ORDER BY a.item_id)) AS lot_id
                    , 'N' AS is_fixed
                    , 'Y' AS is_prev_schedule
                    , 'START_FIX' AS keep_work_time_type
                    , 'ALL_QTY_FIX' AS keep_qty_type
                    , NULL AS sales_model_id
                    , NULL AS attribute_set_id
                    , NULL AS demand_id
                    , 'DO::FG' AS descr
                    , 'Y' AS is_noh_consume
                    , a.project_code   AS project_code    -- 2022.04.29 ADD
                    /*~(2022.04.29) lookup의 설정여부에 따라 business_type값 정의: SALES 사이트에 LOOKUP=Y이면 project_code값을, 그 외는 'ALL'로 설정 ~*/ 
                    , CASE WHEN ISNULL(@v_hp_pjt_code_yn, 'N') = 'Y' AND a.project_code2 != '-' THEN  a.project_code2
                        ELSE 'ALL' 
                    END  AS  business_type 
            FROM   ( SELECT f.*
                            /*~(2022.04.29) project_code2추가: to_site가 'SALES'일 때만 project code를 가져온다  ~*/ 
							, CASE WHEN ISNULL(mse.site_type, '-') != 'SALES'  THEN '-'
                                    ELSE ISNULL(f.project_code, '-') 
							END project_code2
                        FROM   scp_anl_shipment_plan_fg f WITH (NOLOCK)                          
                        LEFT OUTER JOIN (   /*~(2022.04.29) to_site의 site_type을 가져오기위해 조인추가  ~*/ 
                                SELECT DISTINCT division_id, scm_site_id, site_type
                                FROM   scm_mst_site_eng WITH (NOLOCK)
                                WHERE  modeling_id = @p_modeling_id 
                                AND    plan_id     = @p_plan_id     
                                AND    plan_type   = @p_plan_type  
                                AND    plan_seq    = @p_seq        
                                AND    division_id = @p_division_id
                                )  mse
                            ON (f.division_id = mse.division_id
                            AND f.to_site     = mse.scm_site_id)

                        WHERE  f.division_id         = @p_division_id  
                        AND    f.plan_start_yyyymmdd = @v_pre_plan_start_yyyymmdd
                        AND    f.plan_type           = @v_pre_plan_type
                        AND    f.seq                 = @n_pre_plan_seq
                        AND    f.measure             = 'SHIP_PLAN_AMEND'
                        AND    f.qty                 > 0
                    ) a               
                    INNER HASH JOIN (  SELECT a.ship_frozen
                                            , a.scm_site_id 
                                         FROM scm_mst_site_eng a WITH (NOLOCK)
                                        WHERE a.modeling_id = @p_modeling_id
                                          AND a.plan_id     = @p_plan_id
                                          AND a.plan_type   = @p_plan_type
                                          AND a.plan_seq    = @p_seq
                                          AND a.division_id = @p_division_id                                            
                                          AND a.eng_scm_site_id = a.scm_site_id + '~***' 
                                          AND ISNULL(a.attribute7, 'N') = 'N'   --52주통합plant 적용 대상 제외, 2024.10.07 추가
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
            WHERE  a.yyyymmdd >= @p_plan_name --@v_cur_monday
            AND    a.yyyymmdd <  CONVERT(NVARCHAR(8), DATEADD(d, ISNULL(bie.frozen_period, ISNULL(mse.ship_frozen, 0)), @d_plan_name), 112)
            --AND    a.yyyymmdd <  CONVERT(NVARCHAR(8), DATEADD(d, ISNULL(mse.ship_frozen, 0), @d_plan_name), 112)  -- SE, FN ship_frozen : 364 ( 참고 : PR_SCP_ENG_IN_FN_SET_SITE_ENG의 ship_frozen 컬럼 생성부분)
            ;

            -- TXN LOG
            SET @n_log_count = @@ROWCOUNT;
            SET @v_log_type = 'TXN';
            SET @v_log_message = 'INSERT INTO '+@v_table_id; 
            SET @v_description = N'1-2. [fp52주통합plant外]FG 출하계획 정보 Insert (Ship Frozen 구간 내)' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
            SET @d_event_date = SYSDATETIME();
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

             /**********************************************************
             2. 52fp통합 plant 대상, 2024.10.07
                2-1. ~ 52주fp ssp frozen (신규 ssp view : CFG + REQ)
                2-2. 52주fp ssp frozen ~ eng scp froen
                2-2-1. SEMI
                2-2-2. FG
                -> 자동차만 대상 (기존 운영계획 영향성 최소화)
                   " 타사업부는 생성 기준 및 분기로직이 상이
             ***********************************************************/
            IF @v_division_group = '81'
            
            BEGIN

            -----------------------------------------------------------
            --2-1. SSP 출하계획 정보 Insert (~ ssp Frozen 구간 내)
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
             , project_code  
             , business_type
             )
            SELECT @p_master_id      AS master_id
                 , @p_engine_plan_id AS plan_id              
                 , (CASE WHEN a.ssp_type = 'CFM' THEN 'DO::SSP::'
                        ELSE
                             'DO::SSPR::'
                    END) + CONVERT(NVARCHAR(10), 500000 + ROW_NUMBER() OVER (PARTITION BY a.ssp_type
                                                                                ORDER BY a.yyyymmdd
                                                                                       , a.item_id)) AS work_order_id 
                 , 1                 AS work_order_seq
                 , be.eng_to_site    AS site_id
                 , a.item_id + '::' + a.bod_id + '::x::x' AS route_id
                 , a.item_id + '::' + a.bod_id + '::x::x' AS operation_id
                 , a.item_id
                 , a.item_id + '::' + a.bod_id + '::x::x' AS resource_id
                 , NULL                          AS sub_resource_id             
                 , CONVERT(DATETIME, a.yyyymmdd) AS start_dttm
			     , a.eta_date                    AS end_dttm
                 , a.qty                         AS operation_qty
                 , a.qty                         AS complete_qty             
                 , a.confirm_id                  AS lot_id
                 , 'N'                           AS is_fixed
                 , 'Y'                           AS is_prev_schedule
                 , 'START_FIX'                   AS keep_work_time_type
                 , 'ALL_QTY_FIX'                 AS keep_qty_type
                 , NULL                          AS sales_model_id
                 , NULL                          AS attribute_set_id
                 , NULL                          AS demand_id
                 , 'SSP'                         AS descr
                 , 'Y'                           AS is_noh_consume
                 , a.project_code                AS project_code
                   /*~(2022.04.29) lookup의 설정여부에 따라 business_type값 정의: SALES 사이트에 LOOKUP=Y이면 project_code값을, 그 외는 'ALL'로 설정 ~*/ 
                 , CASE WHEN @v_hp_pjt_code_yn = 'Y'  AND a.project_code2 != '-'  THEN a.project_code2
                        ELSE 'ALL' 
                    END                          AS business_type 				 
              FROM ( SELECT sc.division_id
                          , sc.ssp_type
                          , sc.confirm_id
                          , sc.from_site
                          , ISNULL((SELECT TOP 1 b.bod_id 
						        FROM scp_mst_bod_n_v b
						       WHERE b.division_id    = sc.division_id
						         AND b.from_site      = sc.from_site
						         AND b.to_site        = md.segment1
						         AND b.incoterms      = 'DAP' --sc.incoterms
						         AND b.transport_mode = sc.transport_mode
						         AND sc.yyyymmdd      BETWEEN b.from_yyyymmdd AND b.to_yyyymmdd
						         AND b.bod_valid_yn   = 'Y'
						       ORDER BY b.PRIORITY
						      ) 
                                 , sc.bod_id)         AS bod_id
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
                          , sc.yyyymmdd
                          , IIF(ISNULL(sc.eta_date, '') = '', CONVERT(DATETIME, sc.yyyymmdd), sc.eta_date) AS eta_date
                          , sc.qty
                  FROM #scm_dnm_ssp_plan_v_temp sc WITH (NOLOCK)  --ssp 테이블 변경(기존:ssp_anl_ship_confirm), 2024.10.07 
                  LEFT OUTER JOIN scm_adm_lookup_master_detail md WITH(NOLOCK)
                    ON  sc.division_id = md.segment3
                   AND  sc.to_site     = md.segment2
                   AND  md.lookup_type = 'AS_SITE_PLANT'
                   AND  md.valid_yn    = 'Y'						  
                   -- 20220106 PJ20209643 소형 OSP Pack Item 처리
                  LEFT JOIN scp_mst_final_item fi WITH(NOLOCK) --2018.06.29
                    ON  sc.division_id    = fi.division_id
                   AND  sc.item_id        = fi.item_id 
                   AND  @v_division_group = '40'   ---2022.04.04 JV사업부 추가: division_id대신 division_group으로 변경.
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
                   AND  mse.division_id =  sc.division_id)
                 WHERE 1=1
               ) a          
             /* 52주FP통합 출하계획 동기화 2024.10.07*/ 
             INNER JOIN ( SELECT  a.ship_frozen AS org_ship_frozen
                                , a.scm_site_id 
                                  /* 52주fp통합 ssp 동기화 기간 */ 
                                , CONVERT(INT, a.attribute4) AS ssp_frozen
                             FROM scm_mst_site_eng a WITH (NOLOCK)
                            WHERE a.modeling_id = @p_modeling_id
                              AND a.plan_id     = @p_plan_id
                              AND a.plan_type   = @p_plan_type
                              AND a.plan_seq    = @p_seq
                              AND a.division_id = @p_division_id
                              AND a.eng_scm_site_id = a.scm_site_id + '~***'    --scp_anl_shipment_plan_semi 는 BOD가  from site (plant site) ->  to site (plant site)
                              AND ISNULL(a.attribute7, 'N') = 'Y'   --52주통합plant 적용 대상
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
		    WHERE a.yyyymmdd >= @p_plan_name --@v_cur_monday
		      AND a.yyyymmdd <  CONVERT(NVARCHAR(8), DATEADD(d, ISNULL(mse.ssp_frozen, 0), @d_plan_name), 112)
		    ;            

            -- TXN LOG
            SET @n_log_count = @@ROWCOUNT;
            SET @v_log_type = 'TXN';
            SET @v_log_message = 'INSERT INTO '+@v_table_id; 
            SET @v_description = N'2-1. [fp52주통합plant]SSP 출하계획 정보 Insert (52주 SSP Frozen 구간 내)' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
            SET @d_event_date = SYSDATETIME();
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
            

            -----------------------------------------------------------
            --2-2. SEMI 출하계획 정보 Insert (ssp Frozen ~ ship Frozen 구간 내)
            --   scp_anl_shipment_plan_semi 이전 plan_type 정보 사용 
            -----------------------------------------------------------
            INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_FIXED_PLAN */ th_eng_fixed_plan_sn
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
                    , 'DO::SEMI::' + CONVERT(NVARCHAR(10), 200000 + ROW_NUMBER() OVER (ORDER BY item_id)) AS work_order_id  -- 임의의 중복되지 않는값을 사용하기 위해서 row_number() 처리 함              
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
                        WHERE  division_id         = @p_division_id  
                        AND    plan_start_yyyymmdd = @v_pre_plan_start_yyyymmdd
                        AND    plan_type           = @v_pre_plan_type 
                        AND    seq                 = @n_pre_plan_seq 
                        AND    measure             = 'SHIP_PLAN_AMEND'
                        AND    qty                 > 0
                    ) a               
                    INNER HASH JOIN (  
                                  SELECT a.scm_site_id 
                                         /* 52주fp통합 ssp 동기화 기간 */ 
                                       , CONVERT(INT, a.attribute4) AS ssp_frozen 
                                       , a.ship_frozen
                                    FROM scm_mst_site_eng a WITH (NOLOCK)
                                   WHERE a.modeling_id = @p_modeling_id
                                     AND a.plan_id     = @p_plan_id
                                     AND a.plan_type   = @p_plan_type
                                     AND a.plan_seq    = @p_seq
                                     AND a.division_id = @p_division_id
                                     AND a.eng_scm_site_id = a.scm_site_id + '~***'    --scp_anl_shipment_plan_semi 는 BOD가  from site (plant site) ->  to site (plant site)
                                     AND ISNULL(a.attribute7, 'N') = 'Y'   --52주통합plant 적용 대상 제외, 2024.10.07 추가
                                     AND CONVERT(INT, a.attribute4) < a.ship_frozen
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
                    ON   a.bod_id = be.bod_id
            WHERE  a.yyyymmdd >= CONVERT(NVARCHAR(8), DATEADD(d, ISNULL(mse.ssp_frozen, 0), @d_plan_name), 112)  
            AND    a.yyyymmdd <  CONVERT(NVARCHAR(8), DATEADD(d, ISNULL(mse.ship_frozen, 0), @d_plan_name), 112)
            ;
            
            -- TXN LOG
            SET @n_log_count = @@ROWCOUNT;
            SET @v_log_type = 'TXN';
            SET @v_log_message = 'INSERT INTO '+@v_table_id; 
            SET @v_description = N'2-2. [fp52주통합plant]SEMI 출하계획 정보 Insert (SSP Frozen ~ Ship Frozen내)' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
            SET @d_event_date = SYSDATETIME();
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
            
            -----------------------------------------------------------
            --2-2. FG 출하계획 정보 Insert (ssp Frozen ~ ship Frozen 구간 내)
            --   scp_anl_shipment_plan_fg 이전 plan_type 정보 사용 
            -----------------------------------------------------------
            INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_FIXED_PLAN */ th_eng_fixed_plan_sn
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
                SELECT @p_master_id AS master_id
                    , @p_engine_plan_id AS plan_id      
                    , 'DO::FG::' + CONVERT(NVARCHAR(10), 200000 + ROW_NUMBER() OVER (ORDER BY a.item_id)) AS work_order_id  -- 임의의 중복되지 않는값을 사용하기 위해서 row_number() 처리 함              
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
                    , 'DO::FG::' + CONVERT(NVARCHAR(10), 200000 + ROW_NUMBER() OVER (ORDER BY a.item_id)) AS lot_id
                    , 'N' AS is_fixed
                    , 'Y' AS is_prev_schedule
                    , 'START_FIX' AS keep_work_time_type
                    , 'ALL_QTY_FIX' AS keep_qty_type
                    , NULL AS sales_model_id
                    , NULL AS attribute_set_id
                    , NULL AS demand_id
                    , 'DO::FG' AS descr
                    , 'Y' AS is_noh_consume
                    , a.project_code   AS project_code    -- 2022.04.29 ADD
                    /*~(2022.04.29) lookup의 설정여부에 따라 business_type값 정의: SALES 사이트에 LOOKUP=Y이면 project_code값을, 그 외는 'ALL'로 설정 ~*/ 
                    , CASE WHEN ISNULL(@v_hp_pjt_code_yn, 'N') = 'Y' AND a.project_code2 != '-' THEN  a.project_code2
                        ELSE 'ALL' 
                    END  AS  business_type 
            FROM   ( SELECT f.*
                            /*~(2022.04.29) project_code2추가: to_site가 'SALES'일 때만 project code를 가져온다  ~*/ 
            				, CASE WHEN ISNULL(mse.site_type, '-') != 'SALES'  THEN '-'
                                    ELSE ISNULL(f.project_code, '-') 
            				END project_code2
                        FROM   scp_anl_shipment_plan_fg f WITH (NOLOCK)                          
                        LEFT OUTER JOIN (   /*~(2022.04.29) to_site의 site_type을 가져오기위해 조인추가  ~*/ 
                                SELECT DISTINCT division_id, scm_site_id, site_type
                                FROM   scm_mst_site_eng WITH (NOLOCK)
                                WHERE  modeling_id = @p_modeling_id 
                                AND    plan_id     = @p_plan_id     
                                AND    plan_type   = @p_plan_type  
                                AND    plan_seq    = @p_seq        
                                AND    division_id = @p_division_id
                                )  mse
                            ON (f.division_id = mse.division_id
                            AND f.to_site     = mse.scm_site_id)
            
                        WHERE  f.division_id         = @p_division_id  
                        AND    f.plan_start_yyyymmdd = @v_pre_plan_start_yyyymmdd
                        AND    f.plan_type           = @v_pre_plan_type
                        AND    f.seq                 = @n_pre_plan_seq
                        AND    f.measure             = 'SHIP_PLAN_AMEND'
                        AND    f.qty                 > 0
                    ) a               
                    INNER HASH JOIN (  SELECT a.scm_site_id 
                                         /* 52주fp통합 ssp 동기화 기간 */ 
                                            , CONVERT(INT, a.attribute4) AS ssp_frozen 
                                            , a.ship_frozen
                                         FROM scm_mst_site_eng a WITH (NOLOCK)
                                        WHERE a.modeling_id = @p_modeling_id
                                          AND a.plan_id     = @p_plan_id
                                          AND a.plan_type   = @p_plan_type
                                          AND a.plan_seq    = @p_seq
                                          AND a.division_id = @p_division_id
                                          AND a.eng_scm_site_id = a.scm_site_id + '~***'    --scp_anl_shipment_plan_semi 는 BOD가  from site (plant site) ->  to site (plant site)
                                          AND ISNULL(a.attribute7, 'N') = 'Y'   --52주통합plant 적용 대상 제외, 2024.10.07 추가
                                          AND CONVERT(INT, a.attribute4) < a.ship_frozen
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
            WHERE  a.yyyymmdd >= CONVERT(NVARCHAR(8), DATEADD(d, ISNULL(mse.ssp_frozen, 0), @d_plan_name), 112)  
            AND    a.yyyymmdd <  CONVERT(NVARCHAR(8), DATEADD(d, ISNULL(mse.ship_frozen, 0), @d_plan_name), 112)
            ;
            
            -- TXN LOG
            SET @n_log_count = @@ROWCOUNT;
            SET @v_log_type = 'TXN';
            SET @v_log_message = 'INSERT INTO '+@v_table_id; 
            SET @v_description = N'2-3. [fp52주통합plant]FG 출하계획 정보 Insert (SSP Frozen ~ Ship Frozen내)' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
            SET @d_event_date = SYSDATETIME();
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


            END

            -----------------------------------------------------------
            --3. (FIX) SSP, SCP 출하계획(동일 공장 외) 확정정보 Insert (Ship Frozen 구간 외) -- 2018.06.06 추가
            /*
		        1. (20190624) SCP 출하계획 확정정보만 사용 : 확정구간(ship_frozen) 이후는 SSP 출하계획 확정정보 사용 안 함  
            */

            --  - (20181220 수정 키중복방지)      ssp_anl_ship_confirm 테이블에 동일정보에 여러건의 데이터가 존재하므로 SUM(수량) 처리함 ( Confirm_id는 'C' + 임의의값("ROW_NUMBER(ORDER BY ssp.item_id)") 형식으로 생성함)
            --  - (20190104 수정 조인조건 컬럼값) site_type = 'PLANT'일때 1) project_code = '-', 2) incoterms = '-' 처리함  ( site_type='PLANT'일때 SCP(scp_anl_shipment_plan_fix), SSP(ssp_anl_ship_confirm) 같은정보인데 project_code, incoterms 값이 존재하는건도 있고 없는건도 존재해서 조인처리시 서로다른건으로 인식되므로 '-'로 셋팅함)

            --  - 참고 테이블) 1) scp_anl_shipment_plan_fix : SCP 출하계획 확정정보                
            -----------------------------------------------------------
            INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_FIXED_PLAN */ th_eng_fixed_plan_sn
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
                    , a.project_code  AS project_code   -- 2022.04.29 Add 
                    /*~(2022.04.29) lookup의 설정여부에 따라 business_type값 정의: SALES 사이트에 LOOKUP=Y이면 project_code값을, 그 외는 'ALL'로 설정 ~*/ 
                    , CASE WHEN @v_hp_pjt_code_yn = 'Y'  AND  a.project_code2 != '-'  THEN  a.project_code2
                        ELSE 'ALL' 
                    END  AS  business_type 
			       -- Start : (20190624) SCP 출하계획 확정정보만 사용 : 확정구간(ship_frozen) 이후는 SSP 출하계획 확정정보 사용 안 함
            FROM   (   SELECT 
                              scp.fix_id     AS id 
                            , scp.item_id    AS item_id
                            , scp.bod_id     AS bod_id
                            , scp.yyyymmdd   AS yyyymmdd
                            , scp.from_site  AS from_site
                            , scp.qty        AS qty    
                            , scp.project_code  AS project_code    -- 2022.04.29 Add 
                            , scp.project_code2 AS project_code2   -- 2022.04.29 Add 
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
                                        /*~(2022.04.29) to_site가 'SALES'일 때만 project code를 가져온다  ~*/ 
							        , CASE WHEN ISNULL(mse.site_type, '-') != 'SALES'  THEN '-'
                                            ELSE ISNULL(f.project_code, '-') 
							            END  AS  project_code2
                            FROM   scp_anl_shipment_plan_fix f WITH (NOLOCK)
                            INNER JOIN (  SELECT DISTINCT division_id, scm_site_id, site_type
                                            FROM   scm_mst_site_eng WITH (NOLOCK)
                                            WHERE  modeling_id = @p_modeling_id  
                                            AND    plan_id     = @p_plan_id      
                                            AND    plan_type   = @p_plan_type   
                                            AND    plan_seq    = @p_seq          
                                            AND    division_id = @p_division_id  
                                        )  mse
                            ON (f.division_id = mse.division_id
			                AND f.to_site     = mse.scm_site_id)
                            WHERE f.division_id  = @p_division_id   
                            AND f.qty          >  0
                            AND f.yyyymmdd    >= @p_plan_name   
							/* TM버전은 FIX 데이터 미생성, 2021/05/26, By KKC */
							AND 1= CASE WHEN @p_plan_type = 'TM' THEN 0
										ELSE 1
									END
                            ) scp 
                    ) a
			        -- End : (20190624) SCP 출하계획 확정정보만 사용 : 확정구간(ship_frozen) 이후는 SSP 출하계획 확정정보 사용 안 함 
                    INNER JOIN ( 
                                 SELECT a.ship_frozen AS ship_frozen
                                      , a.scm_site_id
                                        /* 52주fp통합 plant 대상 여부, 2024.10.07 추가 */
                                      , CASE WHEN CONVERT(INT, a.attribute4) > 0 THEN 'Y'
                                             ELSE 'N'
                                         END         AS new_ssp_frozen_yn
                                   FROM scm_mst_site_eng a WITH (NOLOCK)
                                  WHERE a.modeling_id = @p_modeling_id
                                    AND a.plan_id     = @p_plan_id
                                    AND a.plan_type   = @p_plan_type
                                    AND a.plan_seq    = @p_seq
                                    AND a.division_id = @p_division_id
                                    AND a.eng_scm_site_id = a.scm_site_id + '~***'    --scp_anl_shipment_plan_semi 는 BOD가  from site (plant site) ->  to site (plant site)
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
            /* 52주fp통합 plant 대상이면 무조건 ship frozen 이후, 2024.10.07 추가 */
            WHERE  a.yyyymmdd >=  CASE WHEN mse.new_ssp_frozen_yn = 'Y' THEN CONVERT(NVARCHAR(8), DATEADD(d, ISNULL(mse.ship_frozen, 0), @d_plan_name), 112)
                                       ELSE CONVERT(NVARCHAR(8), DATEADD(d, ISNULL(bie.frozen_period, ISNULL(mse.ship_frozen, 0)), @d_plan_name), 112)
                                   END
              AND  a.yyyymmdd <= @v_pet_date
              AND  be.bod_id IS NOT NULL --20190122 추가 (속도개선)INNER JOIN을 LEFT JOIN으로 수정하면서 INNER JOIN과 같은결과를 얻기위해서 추가함
            ;

            -- TXN LOG
            SET @n_log_count = @@ROWCOUNT;
            SET @v_log_type = 'TXN';
            SET @v_log_message = 'INSERT INTO '+@v_table_id; 
            SET @v_description = N'3 [공통plant](FIX) SSP, SCP 출하계획(공장외부) 확정정보 Insert (Ship Frozen 구간 외)' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
            SET @d_event_date = SYSDATETIME();
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        END    -- IF @p_plan_type IN ('MA', 'TM', 'SE', 'FN')		
		   
        ---------------------------------------------------------------------------------------------
        -- 3. [C20200318-000458] (81 :  'SE' / 82  'SE' ) : Ship Frozen 구간(14일)에 SSP 정보 반영
		--    13/14일 째인 토/일은 0으로 처리 : Site Eng 에서 SE의 Ship Frozen(14일)을 변경하는 경우 조정 여부 확인 필요함
		--    20200527 C20200520-000146 82 SE 제외
        --    20200713 C20200702-000043 : 자동차 MA 를 SE처럼 SSP 정보 사용하도록 조정, MA도 SE처럼 13/14일째 0처리
        ---------------------------------------------------------------------------------------------
        /* 자동차만의 분기 조건 주석 처리. 2023.02.23
		IF  @v_division_group IN ('81') AND @p_plan_type IN ('MA', 'TM', 'SE')     ---2022.04.04 JV사업부 추가: @p_division_id -> @v_division_group 으로 변경.
        BEGIN

            -----------------------------------------------------------
            -- 3-1) (FIX) SSP 출하계획 확정정보 Insert (ship_frozen 기간이내)
               -- SSP 출하계획 확정정보(ssp_anl_ship_confirm) 중 ship_frozen기간내의 데이터만 INSERT       
               -- 참고 테이블) ssp_anl_ship_confirm : SSP 출하계획 확정정보   
            -----------------------------------------------------------
            INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_FIXED_PLAN */ th_eng_fixed_plan_sn
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
				 , a.eta_date as end_dttm		--2021.05.10 변경                 
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
                 , a.project_code   -- 2022.04.29 Add 
                   /*~(2022.04.29) lookup의 설정여부에 따라 business_type값 정의: SALES 사이트에 LOOKUP=Y이면 project_code값을, 그 외는 'ALL'로 설정 ~*/ 
                 , CASE WHEN @v_hp_pjt_code_yn = 'Y' AND project_code2 != '-' THEN project_code2
                        ELSE 'ALL' 
                   END  AS  business_type 
            -- 20211013 [PJ20214907] AS : SSP의 'AS(WH-In 용) Plant Plan' 을 'AS(WH-In 용) Sales Plan' 으로 전환	
		    -- SSP에서 BOD ID까지 전환하므로 원래 BOD ID로 전환
            /*FROM   ( SELECT * 
                     FROM   ssp_anl_ship_confirm WITH (NOLOCK)
                     WHERE  division_id         = @p_division_id  
                     AND    qty                 > 0
                     AND    yyyymmdd            >= @p_plan_name
                     AND    change_type         = 'C'  -- 20180716 추가
                   ) a  */ 
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
                            /*~(2022.04.29) project_code2추가: to_site가 'SALES'일 때만 project code를 가져온다  ~*/ 
                          , CASE WHEN ISNULL(mse.site_type, '-') != 'SALES'  THEN '-'
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
                     FROM   ssp_anl_ship_confirm sc WITH (NOLOCK)
                          LEFT OUTER JOIN scm_adm_lookup_master_detail md WITH(NOLOCK)
                          ON   sc.division_id = md.segment3
                          AND  sc.to_site     = md.segment2
                          AND  md.lookup_type = 'AS_SITE_PLANT'
                          AND  md.valid_yn    = 'Y'						  
                          -- 20220106 PJ20209643 소형 OSP Pack Item 처리
                          LEFT JOIN scp_mst_final_item fi WITH(NOLOCK) --2018.06.29
                          ON   sc.division_id = fi.division_id
                          AND  sc.item_id     = fi.item_id 
                          AND  @v_division_group = '40'      ---2022.04.04 JV사업부 추가: division_id대신 division_group으로 변경.
                         /* 20220404 변경전 
                          LEFT JOIN scp_mst_final_item fi WITH(NOLOCK) --2018.06.29
                          ON   sc.division_id = fi.division_id
                          AND  sc.item_id     = fi.item_id 
                          AND  fi.division_id = '40'    */    
                          LEFT OUTER JOIN (  /*~(2022.04.29) to_site의 site_type을 가져오기위해 조인추가  ~*/     
                                        SELECT DISTINCT se.division_id, se.scm_site_id , se.site_type
                                        FROM   scm_mst_site_eng se WITH (NOLOCK) 
                                        WHERE  se.modeling_id = @p_modeling_id
                                        AND    se.plan_id     = @p_plan_id
                                        AND    se.plan_type   = @p_plan_type
                                        AND    se.plan_seq    = @p_seq
                                        AND    se.division_id = @p_division_id
                                        ) mse 
                          ON  ( 1=1
                          AND  mse.scm_site_id =  ISNULL(md.segment1, sc.to_site)  /*~ 22.08.17 수정
                          AND  mse.scm_site_id =  sc.to_site           --220817 수정전 코드 주석처리  ~*/ 
                          AND  mse.division_id =  sc.division_id)
                     WHERE  sc. division_id        = @p_division_id
                     AND    sc.qty                 > 0
                     AND    sc.yyyymmdd            >= @p_plan_name
                     AND    sc.change_type         = 'C'  --  20180716 추가
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
            -- 13/14일 째인 토/일은 0으로 처리 : ship_frozen-2
            -- 20200713 C20200702-000043 : 자동차 MA 를 SE처럼 SSP 정보 사용하도록 조정, MA도 SE처럼 13/14일째 0처리
            AND    a.yyyymmdd < CASE WHEN @p_plan_type IN ('MA', 'TM', 'SE')
                                         THEN CONVERT(NVARCHAR(8), DATEADD(d, ISNULL(mse.ship_frozen-2, 0), @d_plan_name), 112)
                                     ELSE CONVERT(NVARCHAR(8), DATEADD(d, ISNULL(mse.ship_frozen, 0), @d_plan_name), 112)
                                END
            ;

            -- TXN LOG
            SET @n_log_count = @@ROWCOUNT;
            SET @v_log_type = 'TXN';
            SET @v_log_message = 'INSERT INTO '+@v_table_id; 
            SET @v_description = N'3-1) (FIX) SSP 출하계획 확정정보 Insert (ship_frozen 기간이내)' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
            SET @d_event_date = SYSDATETIME();
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

            -----------------------------------------------------------
            -- -2) (FIX) SSP, SCP 출하계획(동일 공장 외) 확정정보 Insert (ship_frozen 기간이후)
               -- 20190624) SCP 출하계획 확정정보만 사용 : 확정구간(ship_frozen) 이후는 SSP 출하계획 확정정보 사용 안 함
               -- 참고 테이블) scp_anl_shipment_plan_fix : SCP 출하계획 확정정보
               -- 참고 테이블) ssp_anl_ship_confirm : SSP 출하계획 확정정보
            -----------------------------------------------------------
            INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_FIXED_PLAN */ th_eng_fixed_plan_sn
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
				-- Start : (20190624) SCP 출하계획 확정정보만 사용 : 확정구간(ship_frozen) 이후는 SSP 출하계획 확정정보 사용 안 함
                FROM   (   SELECT 
                                  scp.fix_id     AS id 
                                , scp.item_id    AS item_id
                                , scp.bod_id     AS bod_id
                                , scp.yyyymmdd   AS yyyymmdd
                                , scp.from_site  AS from_site
                                , scp.qty        AS qty    
                                , scp.project_code  AS  project_code  --~(2022.04.29) 추가. 
                                , scp.project_code2 AS  project_code2 --~(2022.04.29) 추가. 
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
                                         /*~(2022.04.29) project_code2추가: to_site가 'SALES'일 때만 project code를 가져온다  ~*/ 
				                       , CASE WHEN ISNULL(mse.site_type, '-') != 'SALES'  THEN '-'
                                         ELSE ISNULL(f.project_code, '-') 
					                     END  AS  project_code2
                                FROM   scp_anl_shipment_plan_fix f WITH (NOLOCK)
                                INNER JOIN (  SELECT DISTINCT division_id, scm_site_id, site_type
                                                FROM   scm_mst_site_eng WITH (NOLOCK)
                                                WHERE  modeling_id = @p_modeling_id  
                                                AND    plan_id     = @p_plan_id     
                                                AND    plan_type   = @p_plan_type   
                                                AND    plan_seq    = @p_seq          
                                                AND    division_id = @p_division_id  
                                            )  mse
                                 ON (f.division_id = mse.division_id
			                    AND f.to_site     = mse.scm_site_id)
                              WHERE f.division_id  = @p_division_id  
                                AND f.qty          >  0
                                AND f.yyyymmdd    >= @p_plan_name   
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
                                    AND    attribute1  = 'OUTER_SITE'  -- 공장외부 일때  
                                  ) be
                  ON (a.bod_id = be.bod_id)
               WHERE a.yyyymmdd >= CONVERT(NVARCHAR(8), DATEADD(d, ISNULL(mse.ship_frozen, 0), @d_plan_name), 112) --확정구간 이후
                AND  a.yyyymmdd <= @v_pet_date
                AND  be.bod_id IS NOT NULL --20190122 추가 (속도개선)INNER JOIN을 LEFT JOIN으로 수정하면서 INNER JOIN과 같은결과를 얻기위해서 추가함
            ;

            -- TXN LOG
            SET @n_log_count = @@ROWCOUNT;
            SET @v_log_type = 'TXN';
            SET @v_log_message = 'INSERT INTO '+@v_table_id; 
            SET @v_description = N'3-2) (FIX) SSP, SCP 출하계획(동일 공장 외) 확정정보 Insert (ship_frozen 기간이후)' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
            SET @d_event_date = SYSDATETIME();
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        END    -- IF @p_division_id IN ('81', '82') AND @p_plan_type = 'SE'
		*/

		-- 20190701 : FN 인 경우 동일 공장 내 Cell -> Pack 이동 정보도 Fixed Plan으로 반영
		-- PR_SCP_ENG_IN_FN_PROC_BOD 의 fixed_term 적용 부분과 연동
        /* 소형 SE 로직을 FN과 같은 기준으로 변경, 2024.11.26 */
		/* 소형 SE 로직제거에 따른 SE -> MA 변경 CSR : E20250724-001388 */
        IF ( @v_division_group  = '40' AND @p_plan_type IN ('MA', 'FN'))
        OR ( @v_division_group <> '40' AND @p_plan_type = 'FN')
--      IF @p_plan_type IN ('FN') 
        BEGIN
                -----------------------------------------------------------
                --1. SEMI 출하계획 정보 Insert (Ship Frozen 구간 내)
                -- 자가이동은 기존로직 유지, 2024.10.07 주석추가 (52주통합fp에서는 수립x)
                -----------------------------------------------------------
                INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_FIXED_PLAN */ th_eng_fixed_plan_sn
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
                          /* WORK_ORDER_ID 생성 채번 규칙 변경, 중복방지를 위해 2024.10.07 */
                        , 'DO::SEMI::' + CONVERT(NVARCHAR(10), 400000 + ROW_NUMBER() OVER (ORDER BY a.item_id)) AS work_order_id  -- 임의의 중복되지 않는값을 사용하기 위해서 row_number() 처리 함              
--                        , 'DO::SEMI::' + CONVERT(NVARCHAR(10), 300000 + ROW_NUMBER() OVER (ORDER BY a.item_id)) AS work_order_id  -- 임의의 중복되지 않는값을 사용하기 위해서 row_number() 처리 함              
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
                        , 'DO::SEMI::' + CONVERT(NVARCHAR(10), 300000 + ROW_NUMBER() OVER (ORDER BY a.item_id)) AS lot_id
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
                            WHERE  division_id         = @p_division_id  
                            AND    plan_start_yyyymmdd = @v_pre_plan_start_yyyymmdd
                            AND    plan_type           = @v_pre_plan_type 
                            AND    seq                 = @n_pre_plan_seq 
                            AND    measure             = 'SHIP_PLAN_AMEND'
                            AND    qty                 > 0
                        ) a
                        INNER HASH JOIN (  SELECT fixed_term AS ship_frozen
	  				                        , SUBSTRING(from_site_id, 1, CHARINDEX('~', from_site_id)-1) AS scm_site_id 
	  				                        , SUBSTRING(bod_id, 1, CHARINDEX('::', bod_id)-1) AS item_id 
                                    FROM   th_eng_bod_sn WITH (NOLOCK)
                                    WHERE  master_id       = @p_master_id
                                    AND    plan_id         = @p_engine_plan_id
                                    AND    from_site_id LIKE '%~002'  --내부 출하 BOD
                                    AND    to_site_id   LIKE '%~***'  --내부 출하 BOD
                                    )  mse
                        ON  a.from_site = mse.scm_site_id
						AND a.item_id   = mse.item_id
                        INNER JOIN ( SELECT dbo.FN_SCM_SPLIT(bod_id, 1, '::')  AS bod_id
                                            , CONVERT(NUMERIC(18,3),attribute10) AS bod_lead_time
                                    FROM   scm_mst_bod_eng WITH (NOLOCK)
                                    WHERE  modeling_id = @p_modeling_id
                                    AND    plan_id     = @p_plan_id
                                    AND    plan_type   = @p_plan_type
                                    AND    plan_seq    = @p_seq
                                    AND    division_id = @p_division_id 
                                    AND    attribute1  = 'INNER_SITE'  -- 이부분수정시 PROC_BOD의 fixed_term 부분검토 필요함
                                    ) be
                        ON   a.bod_id = be.bod_id
                WHERE  a.yyyymmdd >= @p_plan_name --@v_cur_monday
                AND    a.yyyymmdd <  CONVERT(NVARCHAR(8), DATEADD(d, ISNULL(mse.ship_frozen, 0), @d_plan_name), 112)  -- FN ship_frozen : 364 ( 참고 : PR_SCP_ENG_IN_FN_SET_SITE_ENG의 ship_frozen 컬럼 생성부분)
                ;

            -- TXN LOG
            SET @n_log_count = @@ROWCOUNT;
            SET @v_log_type = 'TXN';
            SET @v_log_message = 'INSERT INTO '+@v_table_id; 
            SET @v_description = N'3.2 동일 공장 내 Cell -> Pack 이동 정보' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
            SET @d_event_date = SYSDATETIME();
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        END    -- IF @p_plan_type = 'FN'

        -------------------------------------------------------------
        --4. 특성 BOD : FP 생산계획중 특성공정을 Fixed Plan(001 -> 002)로 반영
        --     20210128 C20210128-000112 특성계획 동기화 구간 변경 : 기존 6주 → 변경 7주
        --   - 자동차(81), ESS(82) 사업부의 FP 생산계획중 특성(F6000) 공정 계획 반영   (참고) 소형(40)사업부는 제외

        --   참고 뷰) scm_dnm_plan_frozen_v : FP 생산계획 정보

        --   (참고) (20181211변경) PR처럼 데이터 생성으로 변경함, PR과 동일한소스 반영함 (20181211 변경전 :  PLAN TYPE 'MA'/'SE'/'FN' 일때 : PRE  PLAN  데이터 사용함(th_eng_fixed_plan.descr : 'DO::FOR' 데이터만 사용) )     
        -------------------------------------------------------------


        /* 2024.10.07 변경
           특성계획 반영 관련 변경 요청사항/요건 정의 : 
           52주fp통합 plant 대상외는 fp period frozen으로 변경(기존 : 하드코딩 7주)
           ->fp통합 plant 대상는 fp period frozne을 52주로 기준정보 변경 반영 
         */              
        INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_FIXED_PLAN */ th_eng_fixed_plan_sn
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
             /* 변경전 -- 아직 운영에는 미반영되어있으므로 운영반영시 아래주석내용 사용할껏
             , a.item_id + '::' + b.bod_id AS route_id
             , a.item_id + '::' + b.bod_id AS operation_id
             , a.item_id
             , a.item_id + '::' + b.bod_id AS resource_id
             */
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
        FROM   ( SELECT division_id
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
                 /* 20181109 변경
                   AND  division_id <> '40'
                   AND  operation_id = 'F6000'
                 */
				 -- 소형은 SSP/오창만 특성계획반영 중, SCP에는 반영 안 함
                 AND    @v_division_group  IN ('81', '82')        -- 2022.04.04 JV사업부추가: division_id -> @v_division_group 으로 변경
                 --   (참고) division_id <> '40' 일때는 'F6000' 데이터만 존재하므로 operation_id 조건에'F5300', 'F5500', 'F5600' 도 포함시켜도 상관없음                      
                 AND    operation_id IN ( SELECT segment1 AS operation_id FROM scm_adm_lookup_master_detail WITH (NOLOCK)
		                                  WHERE  lookup_type = 'OPERATION_CHAR'
		                                  AND    valid_yn = 'Y'
                                        ) --20181109 수정 ( 하드코딩에서 lookup테이블로 변경 )
               ) a         
               --INNER JOIN  dbo.scm_mst_bod_eng b WITH(NOLOCK)
               LEFT JOIN  dbo.scm_mst_bod_eng b WITH(NOLOCK) -- 20181109 수정 속도개선을 위해서 INNER조인을 LEFT조인으로 변경함  
               ON   a.division_id      = b.division_id
               AND    a.scm_site_id    = b.from_site
               AND    b.eng_from_site  = b.from_site + '~001'
               AND    b.eng_to_site    = b.to_site + '~002'
               AND    b.plan_id        = @p_plan_id
               AND    b.plan_type      = @p_plan_type
               AND    b.plan_seq       = @p_seq
               AND    b.valid_yn       = 'Y'   
               INNER JOIN  ( SELECT a.eng_scm_site_id
                                  , a.fp_plan_period 
                                  , a.ship_frozen
                                  , a.prod_frozen
                              FROM   dbo.scm_mst_site_eng a WITH (NOLOCK)  
                             WHERE  a.modeling_id     = @p_modeling_id
                             AND    a.plan_id         = @p_plan_id
                             AND    a.plan_type       = @p_plan_type
                             AND    a.plan_seq        = @p_seq 
                             AND    a.division_id     = @p_division_id
                             AND    a.site_type       = 'PLANT' 
                            )  c 
               ON   a.scm_site_id + '~001' = c.eng_scm_site_id			   
        WHERE  1=1
        AND    a.division_id  = @p_division_id 
        /*     20181109 주석처리함  (조회조건을 위 scm_dnm_plan_frozen_v 조회시 조건으로 추가하였음)       
        AND    a.division_id <> '40'  -- 2018.09.28 소형 제외
        AND    a.operation_id = 'F6000' -- 활성화 FP 생산 공정
        */
        AND    a.plan_date   >= @d_plan_name --20180228 수정( @v_cur_monday 를 @p_plan_name로 변경함, plan_cycle 이 Daily 일경우도 처리되게 하기위함)
        --     20210128 C20210128-000112 특성계획 동기화 구간 변경 : 기존 6주 → 변경 7주
        /*     52주fp 통합관련 로직변경, 2024.10.07 */
        AND    a.plan_date   <  DATEADD(DD, c.fp_plan_period, @d_plan_name) -- 2018.09.28 6주 반영 : 변경 시 Proc BOD 도 수정 필요함        
        --AND    a.plan_date   <  DATEADD(DD, 7*7, @d_plan_name) -- 2018.09.28 6주 반영 : 변경 시 Proc BOD 도 수정 필요함        
        AND    b.division_id IS NOT NULL  --20181109 추가 (속도개선을 위해서INNER조인을 LEFT조인으로 변경시 INNER조인과 같은 조회값을 위해서 조건추가함)
        ;  

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id; 
        SET @v_description = N'4. 특성 BOD' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
        -----------------------------------------------------------
        --5. (20190702) 동일 공장 내 Cell -> Pack 확정선적계획 : Fixed Plan(A~002 -> P~***)으로 반영
        /* 자가이동계획은 변경 검토 없음
           2024.10.07 주석만 추가
         */
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_FIXED_PLAN */ th_eng_fixed_plan_sn
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
                        FROM scp_anl_shipment_plan_fix f WITH (NOLOCK)
					   INNER JOIN (  SELECT DISTINCT division_id, scm_site_id, site_type
									   FROM scm_mst_site_eng WITH (NOLOCK)
									  WHERE modeling_id = @p_modeling_id  
										AND plan_id     = @p_plan_id      
										AND plan_type   = @p_plan_type    
										AND plan_seq    = @p_seq         
										AND division_id = @p_division_id  
										AND site_type   = 'PLANT' -- 20180114 (FIX) SSP는 To Site가 PLANT인 경우만 FIX 적용
									)  mse
						 ON (f.division_id = mse.division_id
						AND f.to_site     = mse.scm_site_id)
                      WHERE f.division_id   = @p_division_id  
                        AND f.qty           >  0
                        AND f.yyyymmdd      >= @p_plan_name   
						/* TM버전은 FIX 데이터 미생성, 2021/05/26, By KKC */
					    AND 1= CASE WHEN @p_plan_type = 'TM' THEN 0
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
        SET @v_description = N'5. 동일 공장 내 Cell -> Pack 확정선적계획' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

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


