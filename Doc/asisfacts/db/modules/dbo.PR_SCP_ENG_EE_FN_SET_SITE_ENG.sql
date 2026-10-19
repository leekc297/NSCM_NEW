
/*
 * Program ID   : PR_SCP_ENG_EE_FN_SET_SITE_ENG
 * Description  : SDB의 Site/Site Item 정보에 대하여 현재 Plan에 사용할 현재 시점의 Snapshot 정보를 SDB에 적재되도록 한다.

                  1. site Shapshot 정보(scm_mst_site_eng)
                     1-1. PLANT Site + 가상 SALES site 데이터생성
                           
                           - PLANT Site 
                             -1) 전극(operation_group ='E')  일때 : 3개의 데이터 생성 후        => "eng_scm_site_id" 값을  1) scm_site_id + '~***', 2) scm_site_id + '~002', 3) scm_site_id + '~003' 형태로 생성함
                             -2) 셀(operation_group = 'A')   일때 : scm_site_id + '~***' 형태로 생성함 ( 단, 외주셀 site 제외)
                           
                           - 가상 SALES site
                             -1)  scm_site_id : 셀 PLANT site + '-S' , eng_scm_site_id : 셀 PLANT site + '-S~EXW' ( 단, 외주셀 site 제외)
                           
                           -예외사항)  scm_mst_site.osp_yn = 'Y' (외주전극 은 '~***'만존재함, 분리작업없음) --20181001 추가
                  
                     1-2. SALES Site : Demand / Intransit / 확정 SP 가 존재하는 Site                     

                  2. site item Shapshot 정보(scm_mst_site_item_eng)
                     2-1. SALES Site 데이터생성
                     2-2. 가상 SALES Site 데이터생성
                     2-3. PLANT Site 데이터생성   
                     2-4. PLANT Site : 셀 SITE iTEM에 존재하지 않는 전극 SITE ITEM 정보추가
                                       - 1) 전극 site item 조회(eng_scm_site_id 가 '~***'인건만 조회)
                                       - 2) scp_eng_bomcomponents_i_sn 테이블에서 1)에서조회된 "전극site item"과 " child_item_id" 가 동일한 "model_id" 및 "parent_item_id"조회
                                       - 3) 2)에서 조회된 "model_id" 또는 "parent_item_id"와 같은 셀 site의 item_id를 조회
                                       - 4) 3)에서 조회된 셀site의 item_id를 1)에서조회된 전극site의 item_id 로 변경            
                  
                  주의사항) 순차적으로 데이터를 생성하게 되어있으므로 위 개발순서를 변경시키면 안됨, 

 * OutTable     : SCM_MST_SITE_ENG, SCM_MST_SITE_ITEM_ENG
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017.12.08   정원식         Initial Release  전지본부 GSCM(DM/SCP) 구축 프로젝트
 * 2018.06.07   KSG            Prod Frozen 조정
 * 2018.06.21   KSW            전극 제외 처리 
 * 2018.07.20   KSW            ssp_anl_ship_confirm, scp_anl_shipment_plan_fix, scp_anl_shipment_plan_fg 정보에 존재하는 SALES site 데이터생성
 * 2018.10.01   KSW            외주전극 분리작업 제외처리(외주전극 : *** 만 생성, 외주전극: 002, 003 분리제외시킴)
 * 2018.10.11   KSW            prod_frozen 컬럼부분 수정( 364(전구간 -> scm_mst_site.prod_frozen 으로 변경) 참고)주석1-1
 * 2018.11.15   KSW            plan_type = 'TM' (시뮬레이션용으로 'MA'와 동일하게 처리됨) (참고)주석1-1
 * 2018.12.06   KSW            (20181011수정내용 원복처리) prod_frozen 컬럼부분 수정( scm_mst_site.prod_frozen -> 364(전구간) 변경 ) 참고)주석1-1
 * 2019.03.05   KSW            [재료본부 전지재료 GSCM 구축 프로젝트] 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가 (전지재료('44') 사업부추가로 인한 조건추가) 
 * 2020.02.06   KSG            [OSP Line Plan] Attribute1 정보 추가
 * 2020.07.14   KSG            [전지 공급 대응력 향상을 위한 SCM 관리 체계 개선] 전극 Main Plan 추가 및 Engine Run 기준 설정
 * 2020.08.12   KSG            [Packer Visivility] : SCS Packer 대상 Site 정보 추가
 * 2021.05.18   SEO            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 : 중장기 계획
 * 2021.10.13   KSG            [PJ20214907] LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 : AS
 * 2022.04.04   LHS            PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선: JV사업부 추가: 사업부 조건별 로직구현시 division_id 대신 속성값(attribute3) 기준으로 변경
                                ----------------------------------------------------------------
                                        구분                         자동차           전극
                                ==============================    =============   ==============
                                  division_group(attribute3)  :        81              EE                
                                ------------------------------    -------------   --------------
                                  division_id                 :     81 , 81_UC      EE , EE_UC  
                                ----------------------------------------------------------------
 * 2023.03.06   KKC         PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행: 전극 MA -> FN 기준으로 변경(생산 전구간 확정)
 * 2023.03.08   KKC         PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행: 전극 MA/FN 계획 수립시 출하확정구간 재정의(전구간)
 * 2023.08.25   LHS         PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2: 1-2) 동일 scm_site_id가 n개의 division에 등록된 경우 key중복 에러 회피목적으로 max값을 취함.
 * 2024.08.12   KKC         PJ20244573  LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성 : 전극 MA 계획 수립시, 전체 출하확정구간(52주) 중 Plant별 Ship Frozon구간내는 SSP 확정계획으로 동기화 요청
                            SHIP FROZON 구간 유지 / SSP FROZON 구간 별도 구분 로직 구현
 * 2024.10.07   KKC         PJ20249346   LGES SCP 개선과제 이행 : 자동차 해외법인 통합FP 52주 Daily 생산/출하계획 동기화
                            1. 52주 통합fp 출하계획 동기화 frozen 추가(scm_mst_site_eng.attr03/attr04/attr07/attr08) 
                            -> scm_mst_site_eng.attr03은 기존 PJ20244573 요청으로 사용 중(--2024.08.12)
                            2. ssp 동기화 테이블 변경 (ssp_anl_ship_confirm -> scm_dnm_ssp_plan_v)
 */

CREATE PROCEDURE [dbo].[PR_SCP_ENG_EE_FN_SET_SITE_ENG]
    ( @p_plan_cycle1  NVARCHAR(150)
    , @p_plan_name1   NVARCHAR(4000)
    , @p_plan_id1     NVARCHAR(4000)
    , @p_modeling_id1 NVARCHAR(4000)
    , @p_plan_seq1    NVARCHAR(4000)
    , @p_plan_type1   NVARCHAR(4000)
    , @p_master_id1   NVARCHAR(4000)
    , @p_division_id1 NVARCHAR(30)
    , @p_engine_plan_id1 NVARCHAR(4000)

    , @p_pre_plan_type1 NVARCHAR(4000)
    , @p_pre_plan_seq1  NVARCHAR(4000)
    , @p_pre_engine_plan_id1 NVARCHAR(4000)    
) 
AS
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
    DECLARE @p_plan_seq    NVARCHAR(4000)   = @p_plan_seq1 ;
    DECLARE @p_plan_type   NVARCHAR(4000)   = @p_plan_type1 ;
    DECLARE @p_master_id   NVARCHAR(4000)   = @p_master_id1 ;
    DECLARE @p_division_id NVARCHAR(30)     = @p_division_id1 ; 
    DECLARE @p_engine_plan_id NVARCHAR(4000) = @p_engine_plan_id1 ; 

    DECLARE @p_pre_plan_type NVARCHAR(4000) = @p_pre_plan_type1;
    DECLARE @p_pre_plan_seq  NVARCHAR(4000) = @p_pre_plan_seq1;
    DECLARE @p_pre_engine_plan_id NVARCHAR(4000) = @p_pre_engine_plan_id1;    

    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_EE_FN_SET_SITE_ENG';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'SCM_MST_SITE_ENG, SCM_MST_SITE_ITEM_ENG';
    DECLARE @d_event_date   DATETIME;

    DECLARE @n_pre_plan_id       INTEGER = 0;
    DECLARE @n_cur_plan_id       INTEGER = 0;
    DECLARE @n_pre_week_plan_id  INTEGER = 0;
    DECLARE @n_cur_week_plan_id  INTEGER = 0;
    -- DECLARE @v_division_id       NVARCHAR(30);
    DECLARE @v_cur_monday        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    DECLARE @v_cutoff_day        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'SUN')), 112); -- 지난주 일요일 YYYYMMDD
    DECLARE @d_plan_name         DATETIME;

    --20180720 추가 확정계획 대상 plan 정보
    DECLARE @v_pre_plan_start_yyyymmdd NVARCHAR(8);  --plan_name
    DECLARE @v_pre_plan_type           NVARCHAR(50); --plan_type
    DECLARE @n_pre_plan_seq            INTEGER;      --plan_seq
    DECLARE @v_pre_plan_id             NVARCHAR(8); --plan_id

    DECLARE @v_pet_date          NVARCHAR(8) ; -- Plan End Date		--2021.05.18 중장기 계획
	DECLARE @v_plan_horizon      INTEGER = 0;  -- Plan Horizon		--2021.05.18 중장기 계획

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
         , @v_division_comp    =  di.attribute4  -- 회사코드
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

		--2021.05.18 중장기 계획
	  	SELECT @v_pet_date = p.horizon_end_date
			 , @v_plan_horizon = DATEDIFF(D,  CONVERT(DATE, plan_name), CONVERT(DATE, horizon_end_date) ) + 1
        FROM   dbo.scm_mst_plan p WITH(NOLOCK)
        WHERE  p.division_id = @p_division_id 
        AND    p.plan_id     = @p_plan_id ;

       -----------------------------------------------------------
        -- 1.Site ENG
        -----------------------------------------------------------
        DELETE /* PR_SCP_ENG_EE_FN_SET_SITE_ENG */
        FROM  scm_mst_site_eng
        WHERE 1=1
        AND   plan_id     = @p_plan_id
        AND   modeling_id = @p_modeling_id
        AND   plan_type   = @p_plan_type
        AND   plan_seq    = @p_plan_seq
        ;
		
        -----------------------------------------------------------
        --20180720 추가 scp_anl_shipment_plan_fg 테이블의  최종입력 데이터의 plan 정보 조회 
        SELECT @v_pre_plan_start_yyyymmdd = @p_plan_name 
             , @v_pre_plan_type           = @p_pre_plan_type
             , @n_pre_plan_seq            = @p_pre_plan_seq;
			         
       -----------------------------------------------------------
        -- 1-1). PLANT Site  + 가상 SALES site (scm_site_id : 셀사이트 + '-S' , eng_scm_site_id : 셀사이트 + '-S~EXW')
        -----------------------------------------------------------
        --  PLANT site
        --  1) 전극(operation_group ='E')  일때 : 3개의 데이터 생성 후        => "eng_scm_site_id" 값을  1) scm_site_id + '~***', 2) scm_site_id + '~002', 3) scm_site_id + '~003'형태로 생성함
        --  2) 셀(operation_group = 'A')   일때 : 1) scm_site_id + '~***' 형태로 생성함
        
        --  가상 SALES site
        --  1) scm_site_id : 셀 PLANT site + '-S' , eng_scm_site_id : 셀 PLANT site + '-S~EXW'
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_EE_FN_SET_SITE_ENG */ scm_mst_site_eng
          (modeling_id, plan_id, plan_type, plan_seq
         , division_id
         , scm_site_id
         , eng_scm_site_id
         , site_description
         , site_type
         , city, country
         , plant_id, operation_group, dept_id, vmi_yn, valid_yn, new_yn
         , site_hrcy_id, osp_yn, ship_frozen, prod_frozen, end_customer, fp_plan_period
         , soldto_customer, build_ahead, company_id, site_id, logistic_plant_id
         , created_by, creation_date, last_updated_by, last_update_date
         , attribute1, attribute2, attribute3, attribute4, attribute5
         , attribute6, attribute7, attribute8, attribute9, attribute10
          )
        SELECT @p_modeling_id, @p_plan_id, @p_plan_type, @p_plan_seq
             , @P_division_id AS division_id
             , CASE WHEN operation_group = 'A' AND b.gubun = 2 THEN  scm_site_id + '-S'
                    ELSE scm_site_id                     
               END AS scm_site_id
             , CASE WHEN operation_group = 'E' AND b.gubun = 1 THEN  scm_site_id + '~***'
                    WHEN operation_group = 'E' AND b.gubun = 2 THEN  scm_site_id + '~002' 
                    WHEN operation_group = 'E' AND b.gubun = 3 THEN  scm_site_id + '~003'
                    WHEN operation_group = 'A' AND b.gubun = 1 THEN  scm_site_id + '~***'
                    WHEN operation_group = 'A' AND b.gubun = 2 THEN  scm_site_id + '-S~EXW'
               END AS eng_scm_site_id  
             , site_description
             , CASE WHEN operation_group = 'A' AND b.gubun = 2 THEN  'SALES'
                    ELSE site_type 
               END  AS site_type
             , city, country 
             , plant_id, operation_group, dept_id, vmi_yn, valid_yn, new_yn
             , site_hrcy_id, osp_yn           
		       -- 2023.03.08 Ship Frozen은 전구간으로 적용
			 , CASE WHEN operation_group = 'E' AND b.gubun = 1 THEN  @v_plan_horizon  
			        WHEN operation_group = 'E' AND b.gubun = 2 THEN  @v_plan_horizon   
					WHEN operation_group = 'E' AND b.gubun = 3 THEN  @v_plan_horizon
					WHEN operation_group = 'A' AND b.gubun = 1 THEN  0          
               END AS ship_frozen              
             /* OLD
			 , CASE WHEN operation_group = 'E' AND b.gubun = 1 THEN  ship_frozen   -- IIF(@p_plan_type IN ('MA', 'TM') , ship_frozen, 364) --'SE, FN'은 364
                    WHEN operation_group = 'E' AND b.gubun = 2 THEN  ship_frozen   -- IIF(@p_plan_type IN ('MA', 'TM') , ship_frozen, 364) --'SE, FN'은 364
                    WHEN operation_group = 'E' AND b.gubun = 3 THEN  ship_frozen   -- IIF(@p_plan_type IN ('MA', 'TM') , ship_frozen, 364) --'SE, FN'은 364
                    WHEN operation_group = 'A' AND b.gubun = 1 THEN  0          
               END AS ship_frozen              
             */
			 --20181206 수정 prod_frozen -> 전구간(364) 으로변경   -- 20181011 주석처리함 
			 --20200714 [전지 공급 대응력 향상을 위한 SCM 관리 체계 개선] MA 일 때 12주 설정
			 --20230306 전극 MA도 SE/FN처럼, 전구간 변경 요청
             , CASE WHEN operation_group = 'E' AND b.gubun = 1 THEN  @v_plan_horizon --2023.03.06 전극 MA도 SE/FN처럼, 전구간 변경 요청
			        --WHEN operation_group = 'E' AND b.gubun = 1 AND @p_plan_type IN ('MA', 'TM') THEN  12*7
                    --WHEN operation_group = 'E' AND b.gubun = 1 AND @p_plan_type IN ('SE', 'FN') THEN  364
					--WHEN operation_group = 'E' AND b.gubun = 1 AND @p_plan_type IN ('SE', 'FN') THEN  @v_plan_horizon		--2021.05.18 중장기 계획
                    WHEN operation_group = 'E' AND b.gubun = 2 THEN  0
                    WHEN operation_group = 'E' AND b.gubun = 3 THEN  0
                    WHEN operation_group = 'A' AND b.gubun = 1 THEN  0                    
               END AS prod_frozen
             , end_customer
			 -- 2018.06.07 FN 의 fp_plan_period은 Plan Type 에 따라 처리함
			 -- MA : 설정값-7, SE/FN : 설정값
             --20181115 수정 plan_type = 'TM'('TM'는 테스트 시뮬레이션용으로 MA로 동일하게 실행됨, 'TE'는 'PR'동일하게 처리됨)
             /*
			 -- 2023.03.06 : MA/SE/FN/TM fp_plan_period 변경
			                 (기존 : fp_plan_period -7 => 변경 : fp_plan_period) 
			 */
			 , CASE WHEN operation_group = 'E' AND @p_plan_type IN ('MA', 'TM') AND fp_plan_period <  7 THEN 0
                    WHEN operation_group = 'E' AND @p_plan_type IN ('MA', 'TM') AND fp_plan_period >= 7 THEN fp_plan_period
                    WHEN operation_group = 'A'                                                          THEN 0
                    ELSE fp_plan_period
               END AS fp_plan_period
			   /* OLD
			 , CASE WHEN operation_group = 'E' AND @p_plan_type IN ('MA', 'TM') AND fp_plan_period <  7 THEN 0
                    WHEN operation_group = 'E' AND @p_plan_type IN ('MA', 'TM') AND fp_plan_period >= 7 THEN fp_plan_period - 7
                    WHEN operation_group = 'A'                                                          THEN 0
                    ELSE fp_plan_period
               END AS fp_plan_period
			   */
             , soldto_customer --20180326 수정 soldto_code 변경                          
             --, build_ahead
             , CASE WHEN operation_group = 'E' AND b.gubun = 1 THEN build_ahead
                    WHEN operation_group = 'E' AND b.gubun = 2 THEN build_ahead
                    WHEN operation_group = 'E' AND b.gubun = 3 THEN build_ahead                    
                    WHEN operation_group = 'A' AND b.gubun = 1 THEN 0                    
               END AS build_ahead                 
             , company_id, site_id, logistic_plant_id
             , 'scp_batch' AS created_by, GETDATE() AS creation_date, 'scp_batch' AS last_updated_by, GETDATE() AS last_update_date
             , [dbo].[FN_SCM_SYS_NVL](attribute1, 'N') AS attribute1 -- 2020.02.03 [OSP Line Plan] OSP Plant Site 의 Line별 Capa 적용 여부 정보
             , CASE WHEN ISNULL(p.segment2, 'N') = 'N' THEN 'N'
                    ELSE 'Y'
               END                                     AS attribute2-- 20200812 [Packer Visivility] SCS 정보 사용 대상 OSP 여부
              /* 해당 컬럼 엔진 로직 사용 및 NULL 처리(Garbage 데이터로 인한 오류 방지), 2024.10.07 
                  attribute3 : org ssp frozen(기존 전극 FN 엔진에서 사용 중)
                  attribute4 : 통합FP 52주 Daily 출하계획 동기화 구간 
               */ 
             , a.ship_frozen                           AS attribute3
               /* 통합FP 52주 Daily 출하계획 동기화 구간, 2024.10.07 변경 */
             , CASE WHEN a.operation_group = 'A' THEN NULL --Cell Plant (전극 엔진모델링에서 NLFP 공정은 NO CAPA/무제약)는 제외
                    ELSE 
                         CASE WHEN a.attribute7 = 'Y' AND a.attribute8 > 0 THEN a.attribute8
                              ELSE NULL
                          END
                END       AS attribute4 
             , attribute5
             , attribute6
               /* org (attribute7/attribute8) 정리된 값, 2024.10.07 추가 */
             , CASE WHEN a.attribute7 IN ('Y', 'N') THEN a.attribute7
                    ELSE NULL
                END       AS attribute7 --2024.10.07
             , CASE WHEN a.attribute8 > 0 THEN a.attribute8
                    ELSE NULL
                END       AS attribute8
             , attribute9, attribute10        
        FROM  ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                SELECT A.*  , di.attribute3 AS division_group , di.attribute4 AS division_comp 
                FROM   scm_mst_site      a WITH (NOLOCK)
                     , scm_mst_division  di WITH(NOLOCK)
                WHERE  di.division_id    =  a.division_id
                AND    di.valid_yn       = 'Y' 
                AND    di.attribute4     = @v_division_comp -- 같은 회사 검색
              ) a         
		       -- 20200812 [Packer Visivility] SCS 정보 사용 대상 OSP 여부
			   LEFT OUTER JOIN (
                                SELECT segment1 -- division_id
                                     , segment2 -- scm_site_id
                                FROM   SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                                WHERE  lookup_type = 'PACKER_SCS'
                                AND    valid_yn    = 'Y'
                               ) p
               ON  a.division_id = p.segment1
               AND a.scm_site_id = p.segment2
            ,  ( SELECT 1 gubun UNION ALL SELECT 2 gubun UNION ALL SELECT 3 gubun UNION ALL SELECT 4 gubun) b
        WHERE  site_type   = 'PLANT'
        AND    valid_yn    = 'Y'
        AND    (
                ( operation_group = 'E' AND ISNULL(a.osp_yn, 'N') = 'N' AND b.gubun <= 3 ) -- 20181001 추가 => AND ISNULL(a.osp_yn, 'N') = 'N'
                OR 
                ( operation_group = 'E' AND ISNULL(a.osp_yn, 'N') = 'Y' AND b.gubun <= 1 ) -- 20181001 추가 외주셀 ***만 생성                
                OR 
                ( operation_group = 'A' AND b.gubun <= 2 AND ISNULL(osp_yn, 'N') = 'N')  -- 20180807 수정 (변경전 : ( operation_group = 'A' AND b.gubun <= 2)  )
               )
        AND    a.division_group  IN ( '40', '81', '82')  -- 2020.04.04 컬럼변경, 20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)
        /*  20220404 변경전
        AND    a.division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)  */ 
        ;

		SET @n_log_count = @@ROWCOUNT; 
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 1-1 END';
        SET @v_description = N'1-1. PLANT Site / 가상 SALES site INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
                
        -----------------------------------------------------------
        -- 1-2). SALES Site : Demand / Intransit / 확정 SP 가 존재하는 Site
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_EE_FN_SET_SITE_ENG */ scm_mst_site_eng
          (modeling_id, plan_id, plan_type, plan_seq
         , division_id, scm_site_id, eng_scm_site_id, site_description, site_type, city, country
         , plant_id, operation_group, dept_id, vmi_yn, valid_yn, new_yn
         , site_hrcy_id, osp_yn, ship_frozen, prod_frozen, end_customer, fp_plan_period
         , soldto_customer, build_ahead, company_id, site_id, logistic_plant_id
         , created_by, creation_date, last_updated_by, last_update_date
         , attribute1, attribute2, attribute3, attribute4, attribute5
         , attribute6, attribute7, attribute8, attribute9, attribute10
          )
        SELECT DISTINCT @p_modeling_id, @p_plan_id, @p_plan_type, @p_plan_seq
             , @p_division_id AS division_id
             , s.scm_site_id, d.site
              -- 2023.08.25 동일 scm_site_id가 n개의 division에 등록된 경우 key중복 에러 회피목적으로 max값을 취함.
             , MAX(s.site_description) AS site_description,  MAX(s.site_type) AS site_type, MAX(s.city) AS city, MAX(s.country ) AS country 
             , MAX(s.plant_id) AS plant_id,  MAX(s.operation_group) AS operation_group,  MAX(s.dept_id) AS dept_id,  MAX(s.vmi_yn) AS vmi_yn,  MAX(s.valid_yn) AS valid_yn,  MAX(s.new_yn) AS new_yn                   
             , MAX(s.site_hrcy_id) AS site_hrcy_id,  MAX(s.osp_yn) AS osp_yn,  MAX(s.ship_frozen) AS ship_frozen,  MAX(s.prod_frozen) AS prod_frozen,  MAX(s.end_customer) AS end_customer,  MAX(s.fp_plan_period) AS fp_plan_period 
             , MAX(s.soldto_customer) AS soldto_customer
             , MAX(s.build_ahead) AS build_ahead,  MAX(s.company_id) AS company_id,  MAX(s.site_id) AS site_id,  MAX(s.logistic_plant_id) AS logistic_plant_id            
             , 'scp_batch' AS created_by, GETDATE() AS creation_date, 'scp_batch' AS last_updated_by, GETDATE() AS last_update_date
             , 'N'  AS attribute1 -- 20200203 [OSP Line Plan] Sales Site는 'N'
             , 'N'  AS attribute2 -- 20200812 [Packer Visivility] Sales Site는 'N'             
               /* Sales Site의 (attribute3/attribute4) 값은 NULL 처리 (사용용도 없는 값), 2024.10.07 추가 */ 
             , NULL AS attribute3
             , NULL AS attribute4
             , MAX(s.attribute5) AS attribute5
             , MAX(s.attribute6) AS attribute6  
               /* Sales Site의 (attribute7/attribute8) 값은 NULL 처리 (사용용도 없는 값), 2024.10.07 추가 */
             , NULL AS attribute7 
             , NULL AS attribute8
             , MAX(s.attribute9) AS attribute9  , MAX(s.attribute10) AS attribute10 
/* 2023.08.25 수정 전
             , s.site_description, s.site_type, s.city, s.country -- eng_scm_site_id 값 정리 필요
             , s.plant_id, s.operation_group, s.dept_id, s.vmi_yn, s.valid_yn, s.new_yn
             , s.site_hrcy_id, s.osp_yn, s.ship_frozen, s.prod_frozen, s.end_customer, s.fp_plan_period
             , s.soldto_customer --20180326 soldto_code 변경
             , s.build_ahead, s.company_id, s.site_id, s.logistic_plant_id
             , 'scp_batch' AS created_by, GETDATE() AS creation_date, 'scp_batch' AS last_updated_by, GETDATE() AS last_update_date
			 
             , 'N' AS attribute1 -- 20200203 [OSP Line Plan] Sales Site는 'N'
             , 'N' AS attribute2 -- 20200812 [Packer Visivility] Sales Site는 'N'

             , s.attribute3, s.attribute4, s.attribute5
             , s.attribute6, s.attribute7, s.attribute8, s.attribute9, s.attribute10
*/ 
        FROM  (-- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                SELECT A.*  , di.attribute3 AS division_group , di.attribute4 AS division_comp 
                FROM   scm_mst_site      a WITH (NOLOCK)
                        , scm_mst_division  di WITH(NOLOCK)
                WHERE  di.division_id    =  a.division_id
                AND    di.valid_yn       = 'Y' 
                AND    di.attribute4     =  @v_division_comp -- 같은 회사 검색
              ) s 
             ,(
               -- Demand
               SELECT DISTINCT scm_site
                    , site 
                 FROM th_eng_demand_sn WITH (NOLOCK)
                WHERE master_id   = @p_master_id
                  AND plan_id     = @p_engine_plan_id
                UNION 
                -- Intransit
               SELECT DISTINCT org_to_scm_site_id AS scm_site
                    , to_scm_site_id AS site
                 FROM scp_eng_intransitshpmnt_i_sn WITH (NOLOCK)
                WHERE modeling_id = @p_modeling_id
                  AND plan_id     = @p_plan_id
                  AND plan_type   = @p_plan_type
                  AND plan_seq    = @p_plan_seq
                  AND division_id = @p_division_id
                  AND result_date = @v_cutoff_day                
               -- 20180720 추가 ssp_anl_ship_confirm, scp_anl_shipment_plan_fix, scp_anl_shipment_plan_fg 정보에 존재하는 SALES site 데이터생성
			   -- 20211013 [PJ20214907] AS : SSP의 'AS(WH-In 용) Plant Plan' 을 'AS(WH-In 용) Sales Plan' 으로 전환
                UNION 
               -- 확정 SP
               /* 2024.10.07 ssp 기준 테이블 변경 :  ssp_anl_ship_confirm -> scm_dnm_ssp_plan_v */
               SELECT DISTINCT to_site AS scm_site
                    , to_site + '~' + incoterms  AS site                         
                 FROM scm_dnm_ssp_plan_v WITH (NOLOCK)  --//기존:ssp_anl_ship_confirm, 2024.10.07 변경
                WHERE division_id  = @p_division_id  
                  AND qty          > 0
                  AND yyyymmdd     >= @p_plan_name
               -- AND change_type  = 'C'     -- 20180716 추가   
                  AND ssp_type     = 'CFM'   -- 2024.10.07 변경 
                UNION 
               -- 확정 SP (AS_SITE_PLANT)
	           /* 2024.10.07 ssp 기준 테이블 변경 :  ssp_anl_ship_confirm -> scm_dnm_ssp_plan_v */
               SELECT DISTINCT md.segment1 AS scm_site
                    , md.segment1 + '~' + 'DAP'  AS site
                 FROM scm_dnm_ssp_plan_v sc WITH (NOLOCK)  --//2024.10.07 ssp 기준 테이블 변경
                INNER JOIN scm_adm_lookup_master_detail md WITH(NOLOCK)
                   ON sc.division_id = md.segment3
                  AND sc.to_site     = md.segment2
                  AND md.lookup_type = 'AS_SITE_PLANT'
                  AND md.valid_yn    = 'Y'
                WHERE sc.division_id = @p_division_id  
                  AND sc.qty         > 0
                  AND sc.yyyymmdd    >= @p_plan_name
               -- AND sc.change_type = 'C'    -- 20180716 추가   
                  AND sc.ssp_type     = 'CFM' -- 2024.10.07 변경
                UNION
               -- SCP FIX
               SELECT DISTINCT to_site AS scm_site
                    , to_site + '~' + incoterms  AS site 
                 FROM scp_anl_shipment_plan_fix WITH (NOLOCK)
                WHERE division_id         =  @p_division_id  
                  AND qty                 >  0
                  AND yyyymmdd            >= @p_plan_name
                  AND incoterms           IS NOT NULL
                UNION 
               SELECT DISTINCT to_site AS scm_site, to_site + '~' + incoterms  AS site  
                 FROM scp_anl_shipment_plan_fg WITH (NOLOCK) 
               WHERE  division_id         = @p_division_id  
                 AND  plan_start_yyyymmdd = @v_pre_plan_start_yyyymmdd
                 AND  plan_type           = @v_pre_plan_type 
                 AND  seq                 = @n_pre_plan_seq 
                 AND  measure             = 'SHIP_PLAN_AMEND'
                 AND  qty                 > 0
              ) d  
        WHERE s.site_type   = 'SALES'
          AND s.valid_yn    = 'Y'
          AND s.scm_site_id = d.scm_site
          AND s.division_group  IN ( '40', '81', '82')  -- 2022.04.04 변경, 20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가) 
        GROUP 
           BY s.scm_site_id
            , d.site   --20230825 Add.
        ; 

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 1-2 END';
        SET @v_description = '1-2. SALES Site  INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date; 
        -----------------------------------------------------------
        -- 2.Site Item ENG
        -----------------------------------------------------------
        DELETE /* PR_SCP_ENG_EE_FN_SET_SITE_ENG */
        FROM  scm_mst_site_item_eng
        WHERE 1=1
        AND   plan_id     = @p_plan_id
        AND   modeling_id = @p_modeling_id
        AND   plan_type   = @p_plan_type
        AND   plan_seq    = @p_plan_seq
        ;		

        ----------------------------------------------------------- 
        -- 2-1). SALES Site
        -----------------------------------------------------------
		INSERT INTO /* PR_SCP_ENG_EE_FN_SET_SITE_ENG */ scm_mst_site_item_eng
		 	 (modeling_id, plan_id, plan_type, plan_seq
		 	, division_id, project_code, scm_site_id, eng_scm_site_id, site_description
		 	, item_id, item_name, currency
		 	, liability_period, sales_plan_adjust_yn, item_hrcy_id, priority, valid_yn, bpms_exist
		 	, created_by, creation_date, last_updated_by, last_update_date
		 	, attribute1, attribute2, attribute3, attribute4, attribute5
		 	, attribute6, attribute7, attribute8, attribute9, attribute10
		  )
		SELECT DISTINCT @p_modeling_id, @p_plan_id, @p_plan_type, @p_plan_seq
		     , @p_division_id AS division_id
		     , smsi.project_code, smsi.scm_site_id, smse.eng_scm_site_id, smse.site_description
		     , smsi.item_id, smis.item_name, smsi.currency
		     , smsi.liability_period, smsi.sales_plan_adjust_yn, smsi.item_hrcy_id, 1 AS priority, smsi.valid_yn, smsi.bpms_exist
             , 'scp_batch' AS created_by, GETDATE() AS creation_date, 'scp_batch' AS last_updated_by, GETDATE() AS last_update_date
		     , smsi.attribute1, smsi.attribute2, smsi.attribute3, smsi.attribute4, smsi.attribute5
		     , smsi.attribute6, smsi.attribute7, smsi.attribute8, smsi.attribute9, smsi.attribute10

		FROM  ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                SELECT s.*  
                      , di.attribute3 AS division_group         
                      , di.attribute4 AS division_comp 
                FROM   scm_mst_site_item   s WITH(NOLOCK)
                     , scm_mst_division   di WITH(NOLOCK)
                WHERE  di.division_id = s.division_id
                AND    di.valid_yn    = 'Y' 
                AND    di.attribute4  = @v_division_comp  -- 같은회사 검색
              ) smsi 
        /* 20220404 변경전
		FROM   scm_mst_site_item smsi WITH (NOLOCK)    */
		     , scm_mst_site_eng  smse WITH (NOLOCK)
             ,(-- Demand / Intransit / 확정 SP 가 존재하는 Site Item
              SELECT DISTINCT scm_site, site, item
                FROM th_eng_demand_sn WITH (NOLOCK)
               WHERE master_id   = @p_master_id
                 AND plan_id     = @p_engine_plan_id
               UNION -- Intransit
              SELECT DISTINCT org_to_scm_site_id AS scm_site, to_scm_site_id AS site, a.item_id AS item
                FROM scp_eng_intransitshpmnt_i_sn a WITH (NOLOCK)
               WHERE modeling_id = @p_modeling_id
                 AND plan_id     = @p_plan_id
                 AND plan_type   = @p_plan_type
                 AND plan_seq    = @p_plan_seq
                 AND division_id = @p_division_id
                 AND result_date = @v_cutoff_day 
               -- 20180720 추가   ssp_anl_ship_confirm, scp_anl_shipment_plan_fix, scp_anl_shipment_plan_fg 정보에 존재하는 SALES site 데이터생성
			   -- 20211013 [PJ20214907] AS : SSP의 'AS(WH-In 용) Plant Plan' 을 'AS(WH-In 용) Sales Plan' 으로 전환
               UNION 
               -- 확정 SP
               /* 2024.10.07 ssp 기준 테이블 변경 :  ssp_anl_ship_confirm -> scm_dnm_ssp_plan_v */
			  SELECT DISTINCT to_site AS scm_site
                   , to_site + '~' + incoterms  AS site
                   , item_id AS item                         
			    FROM scm_dnm_ssp_plan_v WITH (NOLOCK)
			   WHERE division_id  = @p_division_id  
			     AND qty          > 0
			     AND yyyymmdd     >= @p_plan_name
			   --AND change_type  = 'C'  --  20180716 추가  			   
			     AND ssp_type     = 'CFM' -- 202410.07 변경 			   
               UNION 
               -- 확정 SP (AS SITE)
               /* 2024.10.07 ssp 기준 테이블 변경 :  ssp_anl_ship_confirm -> scm_dnm_ssp_plan_v */
			  SELECT DISTINCT md.segment1 AS scm_site
			  	   , md.segment1 + '~' + 'DAP'  AS site
			  	   , sc.item_id AS item
			   FROM scm_dnm_ssp_plan_v sc WITH(NOLOCK)
			  INNER JOIN scm_adm_lookup_master_detail md WITH(NOLOCK)
			     ON sc.division_id = md.segment3
			    AND sc.to_site     = md.segment2
			    AND md.lookup_type = 'AS_SITE_PLANT'
			    AND md.valid_yn    = 'Y'
			  WHERE sc.division_id = @p_division_id  
			    AND sc.qty         > 0
			    AND sc.yyyymmdd    >= @p_plan_name
			  --AND sc.change_type = 'C'   -- 20180716 추가  
                AND sc.ssp_type    = 'CFM' -- 202410.07 변경
               -- SCP FIX
              UNION 
             SELECT DISTINCT to_site AS scm_site, to_site + '~' + incoterms  AS site, item_id AS item 
               FROM scp_anl_shipment_plan_fix WITH (NOLOCK)
              WHERE division_id         =  @p_division_id  
                AND qty                 >  0
                AND yyyymmdd            >= @p_plan_name
                AND incoterms           IS NOT NULL
              UNION 
             SELECT DISTINCT to_site AS scm_site, to_site + '~' + incoterms  AS site, item_id AS item  
               FROM scp_anl_shipment_plan_fg WITH (NOLOCK) 
              WHERE division_id         = @p_division_id  
                AND plan_start_yyyymmdd = @v_pre_plan_start_yyyymmdd
                AND plan_type           = @v_pre_plan_type 
                AND seq                 = @n_pre_plan_seq 
                AND measure             = 'SHIP_PLAN_AMEND'
                AND qty                 > 0
              ) d
		     ,(  -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group(attribute3) ) 
                SELECT a.division_id, a.item_id, MAX(a.item_name) AS item_name
                  FROM scm_mst_item_sn       a WITH (NOLOCK)  
                     , scm_mst_division  di WITH(NOLOCK)
                 WHERE a.active_flag  = 'Y'
                   AND a.division_id  =  di.division_id
                   AND di.valid_yn    = 'Y'
                   AND di.attribute3  IN ( '40', '81', '82') -- 2022.04.04 컬럼변경, 20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)
                   AND di.attribute4  = @v_division_comp  -- 같은회사 검색
                 GROUP  
                    BY a.division_id, a.item_id                 
              ) smis
		WHERE  1 = 1
		AND    smse.modeling_id = @p_modeling_id
		AND    smse.plan_id     = @p_plan_id
		AND    smse.plan_type   = @p_plan_type
		AND    smse.plan_seq    = @p_plan_seq
        AND    d.site           = smse.eng_scm_site_id
        AND    d.item           = smsi.item_id
		--AND    smse.division_id = smsi.division_id -- 20180706 주석처리
		AND    smse.scm_site_id = smsi.scm_site_id
		AND    smsi.valid_yn    = 'Y'
		AND    smse.site_type   = 'SALES'
		AND    smsi.division_id = smis.division_id
		AND    smsi.item_id     = smis.item_id
        and    smsi.division_group IN ( '40', '81', '82') -- 2022.04.04 컬럼변경
        /* 20220404 변경전 
        AND    smsi.division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)  */ 
		;
		
        SET @n_log_count = @@ROWCOUNT; 
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 2-1 END';
        SET @v_description = N'2-1. SALES Site Item INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
              
        ----------------------------------------------------------- 
        -- 2-2). 가상 SALES Site
        -----------------------------------------------------------
		INSERT INTO /* PR_SCP_ENG_EE_PRE_SET_SITE_ENG */ scm_mst_site_item_eng
         	 (modeling_id, plan_id, plan_type, plan_seq
		 	, division_id, project_code, scm_site_id, eng_scm_site_id, site_description
		 	, item_id, item_name, currency
		 	, liability_period, sales_plan_adjust_yn, item_hrcy_id, priority, valid_yn, bpms_exist
		 	, created_by, creation_date, last_updated_by, last_update_date
		 	, attribute1, attribute2, attribute3, attribute4, attribute5
		 	, attribute6, attribute7, attribute8, attribute9, attribute10
		  )
		SELECT DISTINCT @p_modeling_id AS modeling_id, @p_plan_id AS plan_id, @p_plan_type AS plan_type, @p_plan_seq AS plan_seq 
		     , @p_division_id AS division_id -- smsi.division_id
             , smsi.project_code
             , smsi.scm_site_id + '-S' AS scm_site_id                                     
             , smse.eng_scm_site_id, smse.site_description
		     , smsi.item_id, smis.item_name, smsi.currency
		     , smsi.liability_period, smsi.sales_plan_adjust_yn, smsi.item_hrcy_id, 1 AS priority, smsi.valid_yn, smsi.bpms_exist
             , 'scp_batch' AS created_by, GETDATE() AS creation_date, 'scp_batch' AS last_updated_by, GETDATE() AS last_update_date
		     , smsi.attribute1, smsi.attribute2, smsi.attribute3, smsi.attribute4, smsi.attribute5
		     , smsi.attribute6, smsi.attribute7, smsi.attribute8, smsi.attribute9, smsi.attribute10
		
        FROM  ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                SELECT smsi.*  , di.attribute3 AS division_group  , di.attribute4 AS division_comp 
                FROM   scm_mst_site_item smsi WITH (NOLOCK) 
                     , scm_mst_division di WITH(NOLOCK)
                WHERE  di.division_id = smsi.division_id
                AND    di.valid_yn    = 'Y' 
                AND    di.attribute4  = @v_division_comp   -- 같은 회사 검색
              ) smsi 

        /* 20220404 변경전
        FROM   scm_mst_site_item smsi WITH (NOLOCK)  */ 
               
               INNER JOIN scm_mst_site_eng  smse WITH (NOLOCK)
               ON    smse.scm_site_id = smsi.scm_site_id + '-S'
               AND   smsi.valid_yn    = 'Y'
               AND   smse.site_type   = 'SALES'
               AND   smse.modeling_id = @p_modeling_id
  		       AND   smse.plan_id     = @p_plan_id
		       AND   smse.plan_type   = @p_plan_type
    		   AND   smse.plan_seq    = @p_plan_seq
               --AND   smse.division_id = smsi.division_id
               
               INNER JOIN ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group(attribute3) )
                           SELECT a.division_id, a.item_id, MAX(a.item_name) AS item_name
		                   FROM   scm_mst_item_sn    a WITH (NOLOCK)  
		                        , scm_mst_division  di WITH(NOLOCK)
                           WHERE  a.active_flag = 'Y'
                           AND    a.division_id  =  di.division_id
                           AND    di.valid_yn    = 'Y'
                           AND    di.attribute3  IN ( '40', '81', '82')  --2022.04.04 컬럼변경.--20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)
                           AND    di.attribute4  = @v_division_comp   -- 같은 회사 검색
			               GROUP  BY a.division_id, a.item_id
		                  ) smis
               ON     smsi.division_id = smis.division_id
		       AND    smsi.item_id     = smis.item_id
		WHERE  1 = 1 
        AND    smsi.division_group  IN ( '40', '81', '82') -- 2022.04.04 컬럼변경, 20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)
        /*  20220404 변경전
        AND    smsi.division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)   */ 
        ;
        
        SET @n_log_count = @@ROWCOUNT; 
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 2-2 END';
        SET @v_description = N'2-2. 가상 SALES Site Item INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        
        -----------------------------------------------------------
        -- 2-3. PLANT Site
        -----------------------------------------------------------
		INSERT INTO /* PR_SCP_ENG_EE_FN_SET_SITE_ENG */ scm_mst_site_item_eng
		 	 (modeling_id, plan_id, plan_type, plan_seq
		 	, division_id, project_code, scm_site_id, eng_scm_site_id, site_description
		 	, item_id, item_name, currency
		 	, liability_period, sales_plan_adjust_yn, item_hrcy_id, priority, valid_yn, bpms_exist
		 	, created_by, creation_date, last_updated_by, last_update_date
		 	, attribute1, attribute2, attribute3, attribute4, attribute5
		 	, attribute6, attribute7, attribute8, attribute9, attribute10
		  )
		SELECT @p_modeling_id, @p_plan_id, @p_plan_type, @p_plan_seq
		     , @p_division_id AS division_id
		     
		     , smsi.project_code, smsi.scm_site_id, smse.eng_scm_site_id, smse.site_description
		     , smsi.item_id, smis.item_name, smsi.currency
		     , smsi.liability_period, smsi.sales_plan_adjust_yn, smsi.item_hrcy_id, 1 AS priority, smsi.valid_yn, smsi.bpms_exist
             , 'scp_batch' AS created_by, GETDATE() AS creation_date, 'scp_batch' AS last_updated_by, GETDATE() AS last_update_date
		     , smsi.attribute1, smsi.attribute2, smsi.attribute3, smsi.attribute4, smsi.attribute5
		     , smsi.attribute6, smsi.attribute7, smsi.attribute8, smsi.attribute9, smsi.attribute10

		FROM  (  -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group ) 
                select smsi.*  
                     , di.attribute3 AS division_group  , di.attribute4 AS division_comp 
                FROM   scm_mst_site_item smsi WITH (NOLOCK)  
                     , scm_mst_division    di WITH(NOLOCK)
                where 1=1
                AND   smsi.division_id  =  di.division_id
                AND   di.valid_yn       = 'Y' 
                AND   di.attribute4     =  @v_division_comp   -- 같은 회사 검색
              ) smsi   
        /* 20220404 변경전
        FROM   scm_mst_site_item smsi WITH (NOLOCK)    */ 

             , ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group(attribute3) )
                SELECT DISTINCT 
                       a.division_id, a.plant_site_id, a.item_id
                FROM   scm_mst_site_item_priority  a  WITH (NOLOCK)
                     , scm_mst_division           di WITH(NOLOCK)
                WHERE  a.valid_yn = 'Y'
                AND    a.to_yyyymmdd >= @p_plan_name --CONVERT(NVARCHAR(8), GETDATE(), 112) 
                AND    a.division_id  =  di.division_id
                AND    di.valid_yn    = 'Y' 
                AND    di.attribute4  =  @v_division_comp   -- 같은 회사 검색
                AND    di.attribute3  IN ( '40', '81', '82') -- 2022.04.04 컬럼변경, 20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)   
                 /* 20220404 변경전
                SELECT DISTINCT 
                       division_id, plant_site_id, item_id
                FROM   scm_mst_site_item_priority WITH (NOLOCK)
                WHERE  valid_yn = 'Y'
                AND    to_yyyymmdd >= @p_plan_name --CONVERT(NVARCHAR(8), GETDATE(), 112) 
                --AND    division_id = @p_division_id  -- 20180706 주석처리
                AND    division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)   */ 
               ) sip  --20180417 추가 ( scm_mst_site_item_priority 테이블의 valid_yn = 'N' 일때 scm_mst_site_item 테이블의 valid_yn은 'Y'일수도 있음, 두테이블이 서로 동기화 되지 않을수 있으므로 scm_mst_site_item_priority 테이블 조인처리함)
		     
             , scm_mst_site_eng  smse WITH (NOLOCK)  

		     ,( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group(attribute3)  )
               SELECT a.division_id, a.item_id, MAX(a.item_name) AS item_name
		       FROM   scm_mst_item_sn      a WITH (NOLOCK)  
                    , scm_mst_division    di WITH(NOLOCK)
		       WHERE  a.active_flag = 'Y'
               AND    a.DIVISION_ID  =  di.DIVISION_ID
               AND    di.VALID_YN    = 'Y'
		       AND    di.ATTRIBUTE4  =  @v_division_comp   
               AND    di.attribute3  IN ( '40', '81', '82')  --2022.04.04 컬럼변경, 20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)  
			   GROUP  BY a.division_id, a.item_id
               /* 20220404 변경전
               SELECT division_id, item_id, MAX(item_name) AS item_name
		       FROM   scm_mst_item_sn WITH (NOLOCK)  
		       WHERE  active_flag = 'Y'
		       --AND    division_id = @p_division_id  -- 20180706 주석처리
               AND    division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)      
			   GROUP  BY division_id, item_id  */ 
		      ) smis

		WHERE  smse.modeling_id = @p_modeling_id
		AND    smse.plan_id     = @p_plan_id
		AND    smse.plan_type   = @p_plan_type
		AND    smse.plan_seq    = @p_plan_seq
        AND    smsi.division_group  IN ( '40', '81', '82') -- 2022.04.04 컬럼변경, 20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)
        /* 20220404 변경전
        AND    smsi.division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)  */ 

        --20180417 추가
        AND    smsi.division_id = sip.division_id
        AND    smsi.scm_site_id = sip.plant_site_id
        AND    smsi.item_id     = sip.item_id

		--AND    smse.division_id = smsi.division_id  -- 20180706 주석처리
		AND    smse.scm_site_id = smsi.scm_site_id
		AND    smsi.valid_yn    = 'Y'
		AND    smse.site_type   = 'PLANT'
		AND    smsi.division_id = smis.division_id
		AND    smsi.item_id     = smis.item_id
		;
		
        SET @n_log_count = @@ROWCOUNT; 
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 2-3 END';
        SET @v_description = '2-3. PLANT Site Item INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        
        -----------------------------------------------------------
        --2-4. PLANT Site : 셀 SITE iTEM에 존재하지 않는 전극 SITE ITEM 정보추가
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_EE_PRE_SET_SITE_ENG */ scm_mst_site_item_eng
		(   modeling_id, plan_id, plan_type, plan_seq, division_id
          , project_code, scm_site_id, eng_scm_site_id, site_description, item_id
          , item_name, currency, liability_period, sales_plan_adjust_yn, item_hrcy_id
          , priority, valid_yn, bpms_exist, created_by, creation_date
          , last_updated_by, last_update_date, attribute1, attribute2, attribute3
          , attribute4, attribute5, attribute6, attribute7, attribute8
          , attribute9, attribute10
		)
        SELECT DISTINCT
               @p_modeling_id, @p_plan_id, @p_plan_type, @p_plan_seq, @p_division_id
             , b.project_code, a.scm_site_id, a.eng_scm_site_id, a.site_description, b.item_id
             , b.item_name, 'KRW' AS currency, 0 AS liability_period, 'N' AS sales_plan_adjust_yn, NULL AS item_hrcy_id
             , 1 AS priority, 'Y' AS valid_yn, 'N' AS bpms_exist,'scp_batch' AS created_by, GETDATE() AS creation_date
             , 'scp_batch' AS last_updated_by, GETDATE() AS last_update_date, NULL AS attribute1, NULL AS attribute2, NULL AS attribute3
             , NULL AS attribute4, NULL AS attribute5, NULL AS attribute6, NULL AS attribute7, NULL AS attribute8
             , NULL AS attribute9, 'E' AS attribute10 -- scm_mst_bod_item_eng 에서 제외대상건 'E'
        FROM (SELECT a.*
                 , b.operation_group, b.plant_id 
            FROM   scm_mst_site_item_eng a WITH (NOLOCK)
            INNER JOIN scm_mst_site_eng b WITH (NOLOCK)
            ON    a.eng_scm_site_id = b.eng_scm_site_id 
            AND   a.modeling_id = b.modeling_id
            AND   a.plan_id     = b.plan_id 
            AND   a.plan_type   = b.plan_type 
            AND   a.plan_seq    = b.plan_seq
            AND   a.division_id = b.division_id
            AND   b.operation_group IN ( 'E', 'A') 
            AND   b.eng_scm_site_id = b.scm_site_id + '~***' --
            AND   b.site_type = 'PLANT'
            WHERE a.modeling_id = @p_modeling_id
            AND   a.plan_id     = @p_plan_id
            AND   a.plan_type   = @p_plan_type
            AND   a.plan_seq    = @p_plan_seq
            AND   a.division_id = @p_division_id
        ) a

        INNER JOIN ( 
                     SELECT DISTINCT 
                            iif( y.gubun = 1, x.model_id, x.parent_item_id) AS model_parent_item_id
                         ,  x.item_id, x.item_name, x.project_code   
                     FROM (
                            SELECT bb.model_id, bb.parent_item_id, aa.item_id, aa.item_name, aa.project_code   
                            FROM (SELECT a.*
                                       , b.operation_group, b.plant_id 
                                  FROM   scm_mst_site_item_eng a WITH (NOLOCK)
                                  INNER JOIN scm_mst_site_eng b WITH (NOLOCK)
                                  ON    a.eng_scm_site_id = b.eng_scm_site_id
                                  AND   a.modeling_id = b.modeling_id
                                  AND   a.plan_id     = b.plan_id 
                                  AND   a.plan_type   = b.plan_type 
                                  AND   a.plan_seq    = b.plan_seq
                                  AND   a.division_id = b.division_id
                                  AND   b.operation_group IN ( 'E', 'A') 
                                  AND   b.eng_scm_site_id = b.scm_site_id + '~***' --
                                  AND   b.site_type = 'PLANT'
                                  WHERE a.modeling_id = @p_modeling_id
                                  AND   a.plan_id     = @p_plan_id
                                  AND   a.plan_type   = @p_plan_type
                                  AND   a.plan_seq    = @p_plan_seq
                                  AND   a.division_id = @p_division_id
                                ) aa
                                  INNER JOIN scp_eng_bomcomponents_i_sn bb WITH (NOLOCK)
                                  ON   aa.modeling_id     = bb.modeling_id 
                                  AND  aa.plan_id         = bb.plan_id 
                                  AND  aa.plan_type       = bb.plan_type  --20180321 plan_type 추가
                                  AND  aa.plan_seq        = bb.seq 
                                  AND  aa.division_id     = bb.division_id 
                                  AND  aa.item_id         = bb.child_item_id 
                                  AND  aa.operation_group = 'E'
                          ) x
                          , ( SELECT 1 AS gubun UNION ALL SELECT 2  AS gubun)  y                 
                    ) b
        ON    a.operation_group = 'A'
        AND   a.item_id = b.model_parent_item_id        
        WHERE NOT EXISTS ( SELECT 1 FROM scm_mst_site_item_eng  WITH (NOLOCK)
                           WHERE modeling_id     = a.modeling_id 
                           AND   plan_id         = a.plan_id 
                           AND   plan_type       = a.plan_type
                           AND   plan_seq        = a.plan_seq 
                           AND   division_id     = a.division_id 
                           AND   project_code    = b.project_code 
                           AND   scm_site_id     = a.scm_site_id 
                           AND   item_id         = b.item_id
                           )        
        ;

        SET @n_log_count = @@ROWCOUNT; 
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 2-4 END';
        SET @v_description = '2-4. PLANT Site Elec Item INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

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
