
/*
 * Program ID   : PR_SCP_ENG_IN_FN_SET_SITE_ENG
 * Description  : SDB의 Site/Site Item 정보에 대하여 현재 Plan에 사용할 현재 시점의 Snapshot 정보를 SDB에 적재되도록 한다.

                  1. site Shapshot 정보(scm_mst_site_eng)
                     1-1. PLANT Site 데이터생성
                           
                           -1) 전극(operation_group ='E')  일때 : 3개의 데이터 생성 후        => "eng_scm_site_id" 값을  1) scm_site_id + '~***', 2) scm_site_id + '~002', 3) scm_site_id + '~003' 형태로 생성함
                           -2) 셀(operation_group = 'A')   일때 : 동일한 4개의 데이터 생성 후 => "eng_scm_site_id" 값을  1) scm_site_id + '~***', 2) scm_site_id + '~001', 3) scm_site_id + '~002', 4)scm_site_id + '~003' 형태로 생성함
                           -3) 팩(operation_group = 'P')   일때 : 2개의 데이터 생성           => "eng_scm_site_id" 값을  1) scm_site_id + '~***', 2) scm_site_id + '~003' 형태로 생성함

                           -예외사항)  scm_mst_site.osp_yn = 'Y' (외주팩, 외주셀 은 '~***'만존재함, 분리작업없음)
                            
                           -컬럼1) prod_frozen : 아래 소스 상 주석 참고
                                 참고) prod_frozen 컬럼수정시 PROC_RESOURCE(fixed_term컬럼), PROC_FIXED_PLAN_PROD(prod_frozen 컬럼사용부분) 프로시저도 검토해야함   

                           -컬럼2) ship_frozen : 아래 소스 상 주석 참고

                     1-2. SALES Site : Demand, Intransit 정보가 존재하는 Site 데이터생성
                                       (20180720추가) ssp_anl_ship_confirm, scp_anl_shipment_plan_fix, scp_anl_shipment_plan_fg 정보에 존재하는 SALES site 데이터생성                     

                  2. site item Shapshot 정보(scm_mst_site_item_eng)
                     2-1. SALES Site 데이터생성
                     2-2. PLANT Site 데이터생성
                     2-3. PLANT Site : 팩 SITE iTEM에 존재하지 않는 셀 SITE ITEM 정보추가
                                       - 1) 셀 site item 조회(eng_scm_site_id 가 '~***'인건만 조회)
                                       - 2) scp_eng_bomcomponents_i_sn 테이블에서 1)에서조회된 "셀 site item"과 " child_item_id" 가 동일한 "model_id" 및 "parent_item_id"조회
                                       - 3) 2)에서 조회된 "model_id" 또는 "parent_item_id"와 같은 팩 site의 item_id를 조회
                                       - 4) 3)에서 조회된 팩 site의 item_id를 1)에서조회된 셀site의 item_id 로 변경    
                     
                      2-4. PLANT Site : 외주셀 SITE iTEM에 존재하지 않는 셀 SITE ITEM 정보추가
                                       - 1) 셀 site item 조회(eng_scm_site_id 가 '~***'인건만 조회)
                                       - 2) scp_eng_bomcomponents_i_sn 테이블에서 1)에서조회된 "셀 site item"과 " child_item_id" 가 동일한 "model_id" 및 "parent_item_id"조회
                                       - 3) 2)에서 조회된 "model_id" 또는 "parent_item_id"와 같은 외주셀 site의 item_id를 조회
                                       - 4) 3)에서 조회된 외주셀 site의 item_id를 1)에서조회된 셀site의 item_id 로 변경    
                      
                      2-5. scm_mst_site_item_eng 테이블
					                   - 1) '~***', '~001' : 일반 셀site 에 생성된  TCO 셀 item 삭제  
					                   - 2) '~***', '~001', '~002' : 일반 셀site 에 생성된, OSP-A 에 Assign된 TCO 셀 item 삭제 (20181016 변경,  OSP-A에 BOD 연결된 From Site에 대해서만 삭제) 
                      
                      2-6. scm_mst_site_item_eng 최종 INSERT

                     (사용안함, 전극site는 처리하지 않으므로)2-5. PLANT Site : 셀 SITE iTEM에 존재하지 않는 전극 SITE ITEM 정보추가
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
 * 2017.12.08   정원식         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 주석 정리
 * 2021.03.29   KSG            C20210325-000284  [SCM PI] 소형 SCM Fixed Term 변경 요청 건
 * 2021.05.18   SEO            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 : 중장기 계획
 * 2021.05.18   KKC            [PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선] : SEMI 확정계획 누락 대상 Site Item 정보 추가
 * 2021.08.25   KKC            [PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선] : scp_mst_bod_v 변경 (scp_mst_bod_v -> scp_mst_bod_n_v)
 * 2021.10.13   KSG            [PJ20214907] LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 : AS
 * 2021.11.11   KKC            [PJ20214997] LGES SCP 신규 Biz, 공정 추가에 따른 모델링 개선 : DC Link Biz(외주Pack -> 외주Pack) 추가
 * 2022.01.06   KSG            PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 : 소형 OSP Pack Item 처리
 * 2022.04.04   LHS            PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선: JV사업부 추가: 사업부 조건별 로직구현시 division_id 대신 속성값(attribute3) 기준으로 변경
 * 2023.02.09   KSG            PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2: ESS Pack/Cell Prod Frozen 변경.
 * 2023.02.14   SHS            PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행: MA/SE 계획 추가 / 8주 FP확정계획 변경
 * 2023.02.23   SHS            PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행: MA/SE 계획 추가시 출하확정구간 재정의
 * 2023.03.13   KKC            PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행: 신규 DIVISION 공통화 및 불필요한 조건 정리 
 * 2023.03.27   LHS            E20230324-002563 [소형SCM] GSCM시스템의 FN RTF 정합화를 위한 MA~FN 구간 Fix term 변경 요청 : 소형 FN 확정구간 변경 (M+5 → 전구간)
 * 2023.04.18   KSG            PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 도전과제 계획
 * 2023.05.08   LHS            E20230504-001018 [소형SCM] SCS를 통한 팩커 타겟 운영을 위한 PR~MA 구간 Fix term 변경 요청 : 소형 MA /PACK Site 확정구간 변경 (M+5 → 전구간)
 * 2023.07.07   LHS            PJ20230691  SCM 역량 강화 위한 SCP 개선과제 이행: n-ERP 활성화 코드 분리: CELL TYPE 별 유효 SITE정의.
 * 2023.09.01   LHS            PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2: 소형, PLAN_TYPE= MA 일때 cell 생산 확정구간을 FP 반영구간(12주)으로 변경.
 * 2024.10.07   KKC            PJ20249346   LGES SCP 개선과제 이행 : 자동차 해외법인 통합FP 52주 Daily 생산/출하계획 동기화
                               1. 52주 통합fp 출하계획 동기화 frozen 추가(scm_mst_site_eng.attr03/attr04/attr07/attr08) 
                               2. ssp 동기화 테이블 변경 (ssp_anl_ship_confirm -> scm_dnm_ssp_plan_v)
 * 2025.04.17   kimcd     	   PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 - ESS 사업부 선적 확정 구간 52주로 변경
 *                             E20250417-001172 ESS 사업부 출하계획 MA 부터 전구간 확정구간 변경 요청
 * 2025.05.13   KJJ            E20250513-000544 소형 Main Plan 확정 구간 변경
 * 2026.03.30   YMH            E20260327-001884 ess사업부 scm_mst_site_item_eng 기준정보 추가 
 * 2026.04.17   YMH            E20260415-000945 ESS 대치코드 반제품 출하계획 입력 시 계획 사라지는 현상
 * 2026.05.15   kimcd          [PJ2026-50273] MI ESS LINK 공장 SCM(SCP/FP/PSCM ) 대응. from, to에서 사내 LINK 제품 유형 출하 가능하도록 수정
 */

CREATE PROCEDURE [dbo].[PR_SCP_ENG_IN_FN_SET_SITE_ENG]
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_IN_FN_SET_SITE_ENG';
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

    --20180720추가 확정계획 대상 plan 정보
    DECLARE @v_pre_plan_start_yyyymmdd NVARCHAR(8);  --plan_name
    DECLARE @v_pre_plan_type           NVARCHAR(50); --plan_type
    DECLARE @n_pre_plan_seq            INTEGER;      --plan_seq
    DECLARE @v_pre_plan_id             NVARCHAR(8); --plan_id

    DECLARE @v_pet_date          NVARCHAR(8) ; -- Plan End Date		--2021.05.18 중장기 계획
	DECLARE @v_plan_horizon      INTEGER = 0;  -- Plan Horizon		--2021.05.18 중장기 계획
    DECLARE @v_plan_group        NVARCHAR(100) = '-'; -- Plan Group : PJ20230691 도전과제 계획 	
    
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

    -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id  ; 
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    
    BEGIN TRY
      BEGIN
	    ---------------------------------------------
        -- PJ20230691 도전과제 계획 추가용 기간 설정
		---------------------------------------------
		SELECT @v_plan_group = ISNULL(segment5, '-')
		FROM   scm_adm_lookup_master_detail a(nolock)
		WHERE  a.lookup_type = 'PLAN_TYPE'
		AND    a.segment1    = @p_plan_type
		AND    a.valid_yn    = 'Y'

		--2021.05.18 중장기 계획
        -- 20230418 PJ20230691 도전과제 처리 부분 수정
	    SELECT @v_pet_date      = CASE WHEN @v_plan_group = 'BIZ' THEN p.attribute1
                                       ELSE p.horizon_end_date 
                                  END
	         , @v_plan_horizon  = CASE WHEN @v_plan_group = 'BIZ' THEN DATEDIFF(D,  CONVERT(DATE, plan_name), CONVERT(DATE, attribute1) ) + 1
                                       ELSE DATEDIFF(D,  CONVERT(DATE, plan_name), CONVERT(DATE, horizon_end_date) ) + 1
                                  END
	  	--SELECT @v_pet_date = p.horizon_end_date
			 --, @v_plan_horizon = DATEDIFF(D,  CONVERT(DATE, plan_name), CONVERT(DATE, horizon_end_date) ) + 1
        FROM   dbo.scm_mst_plan p WITH(NOLOCK)
        WHERE  p.division_id = @p_division_id 
        AND    p.plan_id     = @p_plan_id ;

       -----------------------------------------------------------
        -- 1.Site ENG
        -----------------------------------------------------------
        DELETE /* PR_SCP_ENG_IN_FN_SET_SITE_ENG */
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
              , @v_pre_plan_type          = @p_pre_plan_type
              , @n_pre_plan_seq           = @p_pre_plan_seq;

        -----------------------------------------------------------
        -- 소형(40)일때 prod_frozen 값셋팅  (20190604 추가)
        -----------------------------------------------------------
           /*
             - 소형(40)일때 (20190604 수정됨) 
               ==> "플랜시작일의 월+ 3개월의 말일" - "플랜시작일(@p_plan_name)" 의 일수 값으로 셋팅(플랜시작일포함됨)
                                                   
                    ex)  플랜시작일 : 20190506 일때  "플랜시작일의 월+ 3개월의 말일": 20190831
                          ==> prod_frozen :  118 셋팅됨 (20190831 - 20190506 + 1(플랜시작일포함되므로 +1 처리함) 일수값)  
                         --SELECT DATEDIFF(d, '20190506', '20190831') + 1 
           */
        -----------------------------------------------------------
        DECLARE @n_frozen_m3           INTEGER = 0; -- 플랜시작일의 월+ 3개월의 말일 : frozen 컬럼값
        DECLARE @n_frozen_m5           INTEGER = 0; -- 플랜시작일의 월+ 5개월의 말일 : frozen 컬럼값
        DECLARE @d_plan_name_add_3month_last_day DATETIME; -- 플랜시작일의 월+ 3개월의 말일
        DECLARE @d_plan_name_add_5month_last_day DATETIME; -- 플랜시작일의 월+ 5개월의 말일
        
        SET @d_plan_name_add_3month_last_day = EOMONTH(DATEADD(m, 3, CONVERT(DATETIME, LEFT(@p_plan_name, 6) + '01')))  --"플랜시작일의 월+ 3개월의 말일"
        SET @d_plan_name_add_5month_last_day = EOMONTH(DATEADD(m, 5, CONVERT(DATETIME, LEFT(@p_plan_name, 6) + '01')))  --"플랜시작일의 월+ 5개월의 말일"

        SET @n_frozen_m3 = DATEDIFF(d, CONVERT(DATETIME, @p_plan_name), @d_plan_name_add_3month_last_day) + 1  -- + 1 : 플랜시작일도 포함되므로
        SET @n_frozen_m5 = DATEDIFF(d, CONVERT(DATETIME, @p_plan_name), @d_plan_name_add_5month_last_day) + 1  -- + 1 : 플랜시작일도 포함되므로
       		
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 1 START';
        SET @v_description = '1. PLANT Site  INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        
       -----------------------------------------------------------
        -- 1-1). PLANT Site
        -----------------------------------------------------------
        --  1) 전극(operation_group ='E')  일때 : 3개의 데이터 생성 후       => "eng_scm_site_id" 값을  1) scm_site_id + '~***', 2) scm_site_id + '~002', 3) scm_site_id + '~003'형태로 생성함
        --  2) 셀(operation_group = 'A')   일때 : 동일한 4개의 데이터 생성 후 => "eng_scm_site_id" 값을  1) scm_site_id + '~***', 2) scm_site_id + '~001', 3) scm_site_id + '~002', 4) scm_site_id + '~003' 형태로 생성함
        --  3) 팩(operation_group = 'P')   일때 : 1개의 데이터 생성           => "eng_scm_site_id" 값을  1) scm_site_id + '~***' 형태로 생성함
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_IN_FN_SET_SITE_ENG */ scm_mst_site_eng
          (modeling_id, plan_id, plan_type, plan_seq
         , division_id, scm_site_id
         , eng_scm_site_id
         , site_description, site_type, city, country
         , plant_id, operation_group, dept_id, vmi_yn, valid_yn, new_yn
         , site_hrcy_id, osp_yn, ship_frozen, prod_frozen, end_customer, fp_plan_period
         , soldto_customer, build_ahead, company_id, site_id, logistic_plant_id
         , created_by, creation_date, last_updated_by, last_update_date
         , attribute1, attribute2, attribute3, attribute4, attribute5
         , attribute6, attribute7, attribute8, attribute9, attribute10
          )
        SELECT @p_modeling_id, @p_plan_id, @p_plan_type, @p_plan_seq
             , division_id, scm_site_id
             , CASE WHEN operation_group = 'E' AND b.gubun = 1 THEN  scm_site_id + '~***'
                    WHEN operation_group = 'E' AND b.gubun = 2 THEN  scm_site_id + '~002'
                    WHEN operation_group = 'E' AND b.gubun = 3 THEN  scm_site_id + '~003'
                    WHEN operation_group = 'A' AND b.gubun = 1 THEN  scm_site_id + '~***'
                    WHEN operation_group = 'A' AND b.gubun = 2 THEN  scm_site_id + '~001'
                    WHEN operation_group = 'A' AND b.gubun = 3 THEN  scm_site_id + '~002'
                    WHEN operation_group = 'A' AND b.gubun = 4 THEN  scm_site_id + '~003'                    
                    -- 20180717 수정 팩 site 분리(~***, ~003)
                    WHEN operation_group = 'P' AND b.gubun = 1 THEN  scm_site_id + '~***'
                    WHEN operation_group = 'P' AND b.gubun = 2 THEN  scm_site_id + '~003'
               END AS eng_scm_site_id 
             , site_description, site_type, city, country 
             , plant_id, operation_group, dept_id, vmi_yn, valid_yn, new_yn
             , site_hrcy_id, osp_yn            
			 --------------------------------------------------------------------------------------
		     -- ** 내부 Site 간 등 최종 Ship Fixed Term 조정은 Proc BOD에서 처리함 **
             --    20210224 특정한 상황에서 BOD Item별 확정 구간 설정은 BOD Item Eng 에 생성하여 BOD의 Fixed Term으로 연계함
		     -- 20190626 소형(40)/자동차(81) FN Plan 시 ship_frozen 값 변경
             -- 20190722 [C20190717_43113] 소형(40) Cell과 Pack 생산 Fix Term, Pack의 Shipment Plan의 고정 구간 변경 요청건
			 -- 소형(40)일때 (20190722 수정됨) 
			 -- 20200401 C20200318-000458 : 81/82 SE 14일 변경 시 PR_SCP_ENG_IN_FN_PROC_FIXED_PLAN 확인 필요함
             /*                     
			                       - 소형(40) :  * TCO 외주 업체 : 관련의 Fix Term은 모든 Plan에 Ship Frozen값 으로 설정
   			                          -----------------------------------------------------------------------------
   			                          Main       (Cell)   Ship Frozen값
   			                                     (Pack)   M+5
   			                          -----------------------------------------------------------------------------
   			                          Semi       (Cell)   Ship Frozen값
   			                                     (Pack)   M+5
   			                          -----------------------------------------------------------------------------
   			                          Final      (Cell)   364 : C20210325-000284
   			                                     (Pack)   M+5 : C20201026-000281 
   			                          -----------------------------------------------------------------------------

			                       - 자동차(81) : 
   			                          -----------------------------------------------------
   			                          Main       14                    : 20200714 C20200702-000043
   			                          ------------------------------------------------------
   			                          Semi       14                    : 20200401 C20200318-000458
   			                          ------------------------------------------------------
   			                          Final      364
   			                          ------------------------------------------------------

			                       - ESS(82) :
   			                          -----------------------------------------------------
   			                          Main       Ship Frozen값
   			                          ------------------------------------------------------
   			                          Semi       Ship Frozen값         : C20200520-000146
   			                          ------------------------------------------------------
   			                          Final      Ship Frozen값
   			                          ------------------------------------------------------
			 */
			 --------------------------------------------------------------------------------------
			 -- 2023.02.23 출하확정구간 재정의 : 81/82/40 MA/SE 추가시 PR_SCP_ENG_IN_FN_PROC_FIXED_PLAN 확인 필요함
             /*                     
			                       - 소형(40) : 
								      -----------------------------------------------------------------------------
   			                          Main       (Cell)   Ship Frozen값
   			                                     (Pack)   전구간 -> 2023.05.08 변경(M+5 → 전구간)
   			                          Final      (Cell)   전구간 
									             (Pack)   전구간 -> 2023.03.27 소형 FN 확정구간 변경(M+5 → 전구간)
                                      /* 소형은 Semi 계획없지만, 재정의한 기준 유지 */ 
                                      Semi(재추가) : Final과 같은 기준 재정의
   			                                     (Cell)   364 (전구간)
									             (Pack)   전구간
   			                          -----------------------------------------------------------------------------

			                       - 자동차(81) : 
   			                          -----------------------------------------------------
   			                          Final      364
                                      Main/Semi(재추가) : Final과 같은 기준 재정의
									             364
   			                          ------------------------------------------------------

			                       - ESS(82) :
   			                          -----------------------------------------------------
   			                          Main       Ship Frozen값
   			                          ------------------------------------------------------
   			                          Final      Ship Frozen값
                                      Semi(재추가) : Final과 같은 기준 재정의
   			                                     Ship Frozen값
   			                          ------------------------------------------------------
			 */
			 --------------------------------------------------------------------------------------
             , CASE ---2022.02.23 MA/SE 추가: 위 재정의한 기준으로 변경.
                    WHEN operation_group = 'E' AND b.gubun = 1 THEN IIF(@v_division_group IN ('81') AND @p_plan_type = 'FN', @v_plan_horizon, ship_frozen)		--2021.05.18 중장기 계획  
                    WHEN operation_group = 'E' AND b.gubun = 2 THEN IIF(@v_division_group IN ('81') AND @p_plan_type = 'FN', @v_plan_horizon, ship_frozen)		--2021.05.18 중장기 계획
                    WHEN operation_group = 'E' AND b.gubun = 3 THEN IIF(@v_division_group IN ('81') AND @p_plan_type = 'FN', @v_plan_horizon, ship_frozen)		--2021.05.18 중장기 계획					
					/* Cell Site */
					/* 2022.02.23 소형 : SE -> FN 기준으로 변경 */
					-- PJ20230691 도전과제 계획 추가
					/*WHEN operation_group = 'A' AND b.gubun = 1 AND @v_division_group  = '40' THEN IIF(@p_plan_type IN ('MA', 'TM'), ship_frozen, @v_plan_horizon)
					WHEN operation_group = 'A' AND b.gubun = 2 AND @v_division_group  = '40' THEN IIF(@p_plan_type IN ('MA', 'TM'), ship_frozen, @v_plan_horizon)
					WHEN operation_group = 'A' AND b.gubun = 3 AND @v_division_group  = '40' THEN IIF(@p_plan_type IN ('MA', 'TM'), ship_frozen, @v_plan_horizon)
					WHEN operation_group = 'A' AND b.gubun = 4 AND @v_division_group  = '40' THEN IIF(@p_plan_type IN ('MA', 'TM'), ship_frozen, @v_plan_horizon)					
					*/
					-- 2025.05.13 소형 Main Pla 확정 구간 변경
					WHEN operation_group = 'A' AND b.gubun = 1 AND @v_division_group  = '40' THEN @v_plan_horizon
					WHEN operation_group = 'A' AND b.gubun = 2 AND @v_division_group  = '40' THEN @v_plan_horizon
					WHEN operation_group = 'A' AND b.gubun = 3 AND @v_division_group  = '40' THEN @v_plan_horizon
					WHEN operation_group = 'A' AND b.gubun = 4 AND @v_division_group  = '40' THEN @v_plan_horizon
					-- 활성화 구간은 확정 없음 / OSP-A 구간
                    WHEN operation_group = 'A' AND b.gubun = 1 AND @v_division_group  = '81' THEN @v_plan_horizon --2023.02.23 MA/SE FN기준으로 동일하게 변경
					-- 특성 BOD용 선적 확정 구간
                    WHEN operation_group = 'A' AND b.gubun = 2 AND @v_division_group  = '81' THEN @v_plan_horizon --2023.02.23 MA/SE FN기준으로 동일하게 변경
                    WHEN operation_group = 'A' AND b.gubun = 3 AND @v_division_group  = '81' THEN @v_plan_horizon --2023.02.23 MA/SE FN기준으로 동일하게 변경					
					WHEN operation_group = 'A' AND b.gubun = 4 AND @v_division_group  = '81' THEN @v_plan_horizon --2023.02.23 MA/SE FN기준으로 동일하게 변경
					-- 2025.04.17 kimcd PJ20249548R, E20250417-001172 ESS 사업부 출하계획 MA 부터 전구간 확정구간 변경 시작
					WHEN operation_group = 'A' AND b.gubun = 1 AND @v_division_group  = '82' THEN @v_plan_horizon --ship_frozen 
                    WHEN operation_group = 'A' AND b.gubun = 2 AND @v_division_group  = '82' THEN @v_plan_horizon --ship_frozen 
                    WHEN operation_group = 'A' AND b.gubun = 3 AND @v_division_group  = '82' THEN @v_plan_horizon --ship_frozen 
                    WHEN operation_group = 'A' AND b.gubun = 4 AND @v_division_group  = '82' THEN @v_plan_horizon --ship_frozen
					-- 2025.04.17 kimcd PJ20249548R, E20250417-001172 ESS 사업부 출하계획 MA 부터 전구간 확정구간 변경 종료
					/* Pack Site */
					-- PJ20230691 도전과제 계획 추가
                    WHEN operation_group = 'P' AND b.gubun = 1 AND @v_division_group  = '40' THEN @v_plan_horizon
                    WHEN operation_group = 'P' AND b.gubun = 2 AND @v_division_group  = '40' THEN @v_plan_horizon /* 2023.05.08 소형 MA확정구간도(M+5 → 전구간) 으로 변경 
                    ---  230508수정전 코드  
                    WHEN operation_group = 'P' AND b.gubun = 1 AND @v_division_group  = '40' THEN IIF(@p_plan_type IN ('MA', 'TM'), @n_frozen_m5, @v_plan_horizon) --2023.03.27 소형 FN 확정구간 변경(M+5 → 전구간)  
                    WHEN operation_group = 'P' AND b.gubun = 2 AND @v_division_group  = '40' THEN IIF(@p_plan_type IN ('MA', 'TM'), @n_frozen_m5, @v_plan_horizon) --2023.03.27 소형 FN 확정구간 변경(M+5 → 전구간)   */
					WHEN operation_group = 'P' AND b.gubun = 1 AND @v_division_group  = '81' THEN @v_plan_horizon --2023.02.23 MA/SE FN기준으로 동일하게 변경
                    WHEN operation_group = 'P' AND b.gubun = 2 AND @v_division_group  = '81' THEN @v_plan_horizon --2023.02.23 MA/SE FN기준으로 동일하게 변경
					-- 2025.04.17 kimcd PJ20249548R, E20250417-001172 ESS 사업부 출하계획 MA 부터 전구간 확정구간 변경 시작
					WHEN operation_group = 'P' AND b.gubun = 1 AND @v_division_group  = '82' THEN @v_plan_horizon --ship_frozen
                    WHEN operation_group = 'P' AND b.gubun = 2 AND @v_division_group  = '82' THEN @v_plan_horizon --ship_frozen
					-- 2025.04.17 kimcd PJ20249548R, E20250417-001172 ESS 사업부 출하계획 MA 부터 전구간 확정구간 변경 종료
               END AS ship_frozen 
			 /*--------------------------------------------------------------------------------------
             -- prod_frozen : 20190722 [C20190717_43113] 소형(40) Cell과 Pack 생산 Fix Term, Pack의 Shipment Plan의 고정 구간 변경 요청건
             --  ==> "플랜시작일의 월+ 3개월의 말일" - "플랜시작일(@p_plan_name)" 의 일수 값으로 셋팅(플랜시작일포함됨) : @n_frozen_m3 사용 
             --  소형(40)일때 (20190722 수정됨) 
                                     * TCO 외주 업체 : 관련의 Fix Term은 모든 Plan에 Prod Frozen값 으로 설정
			                         * Production
				                      -----------------------------------------------------------------------------
				                      Main   Cell : FP반영구간(12w) --23.09.01 수정 (수정전: M+5) -- 20191007 : Cell 생산 Frozen 조정
				                      Main   Pack : 전구간 -- C20201026-000281 -> [E20230504-001018] 2023.05.08 소형MA 생산확정구간 변경(M+5 → 전구간) 
				                      -----------------------------------------------------------------------------
				                      Semi / Final
				                             Cell : 전구간
				                             Pack : 전구간 -- C20210325-000284 -> [E20230324-002563] 2023.03.27 소형 FN 확정구간 변경(M+5 → 전구간) 
				                      -----------------------------------------------------------------------------
             -- 자동차(81) : 전 구간
             -- ESS(82)    : 전 구간 : 20230209 PJ20216994 : ESS Pack/Cell 전 구간
			 --------------------------------------------------------------------------------------*/
             , CASE ---2022.04.04 JV사업부 추가: division_id대신 division_group으로 변경.
                    WHEN operation_group = 'E' AND b.gubun = 1 THEN IIF(@v_division_group = '40', @n_frozen_m3, @v_plan_horizon)						--2021.05.18 중장기 계획 
                    WHEN operation_group = 'E' AND b.gubun = 2 THEN 0
                    WHEN operation_group = 'E' AND b.gubun = 3 THEN 0					
					/*
                    WHEN operation_group = 'A' AND b.gubun = 1 AND @v_division_group  = '40' AND ISNULL(a.osp_yn, 'N') = 'Y'  THEN prod_frozen
                    WHEN operation_group = 'A' AND b.gubun = 1 AND @v_division_group  = '40' 
                        THEN IIF(@p_plan_type IN ('MA', 'TM') 
                                 , CASE WHEN  fp_plan_period <  7 THEN 0 when fp_plan_period >= 7 THEN fp_plan_period  END   --2023.09.01 소형 MA CELL 생산확정구간을 FP반영구간으로 변경함. (변경전: M+5)
                                 , @v_plan_horizon )  -- PJ20230691 도전과제 계획 추가     
					*/
					-- 2025.05.13 소형 Main Pla 확정 구간 변경
                    WHEN operation_group = 'A' AND b.gubun = 1 AND @v_division_group  = '40' THEN @v_plan_horizon
/* 230901 수정전 
                    WHEN operation_group = 'A' AND b.gubun = 1 AND @v_division_group  = '40' THEN IIF(@p_plan_type IN ('MA', 'TM'), @n_frozen_m5, @v_plan_horizon) -- PJ20230691 도전과제 계획 추가                      
*/
                    WHEN operation_group = 'A' AND b.gubun = 1 AND @v_division_group  = '81'                                  THEN @v_plan_horizon		--2021.05.18 중장기 계획
					WHEN operation_group = 'A' AND b.gubun = 1 AND @v_division_group  = '82'                                  THEN @v_plan_horizon		--2021.05.18 중장기 계획
                    WHEN operation_group = 'A' AND b.gubun = 2 THEN 0
                    WHEN operation_group = 'A' AND b.gubun = 3 THEN 0
                    WHEN operation_group = 'A' AND b.gubun = 4 THEN 0   
					
                    -- PJ20230691 도전과제 계획 추가
                    WHEN operation_group = 'P' AND b.gubun = 1 AND @v_division_group  = '40' THEN @v_plan_horizon --2023.05.08 소형MA 전구간 확정, 2023.03.27 소형 FN 전구간 확정.
                    WHEN operation_group = 'P' AND b.gubun = 1 AND @v_division_group  = '81' THEN @v_plan_horizon --2021.05.18 중장기 계획
					WHEN operation_group = 'P' AND b.gubun = 1 AND @v_division_group  = '82' THEN @v_plan_horizon -- prod_frozen -- 20230209 전 구간 적용
                    WHEN operation_group = 'P' AND b.gubun = 2 THEN 0 
               END AS prod_frozen
             , end_customer
			 /*--------------------------------------------------------------------------------------
               fp_plan_period 정의
			 -- 2018.06.07 FN 의 fp_plan_period은 Plan Type 에 따라 처리함
             -- 2023.02.14 : MA/SE/FN/TM fp_plan_period 변경
			                 (기존 : fp_plan_period -7 => 변경 : fp_plan_period) 
			 */
             , CASE WHEN @p_plan_type IN ('MA', 'SE', 'TM') AND fp_plan_period <  7 THEN 0
                    WHEN @p_plan_type IN ('MA', 'SE', 'TM') AND fp_plan_period >= 7 THEN fp_plan_period
                    ELSE fp_plan_period
               END AS fp_plan_period 			 
             , soldto_customer --20180326 수정 soldto_code 변경             
             , build_ahead, company_id, site_id, logistic_plant_id
             , 'scp_batch' AS created_by, GETDATE() AS creation_date, 'scp_batch' AS last_updated_by, GETDATE() AS last_update_date
             , [dbo].[FN_SCM_SYS_NVL](attribute1, 'N') AS attribute1 -- 2020.02.03 [OSP Line Plan] OSP Plant Site 의 Line별 Capa 적용 여부 정보
             , CASE WHEN ISNULL(p.segment2, 'N') = 'N' THEN 'N'
                    ELSE 'Y'
               END                                     AS attribute2-- 20200812 [Packer Visivility] SCS 정보 사용 대상 OSP 여부
               /* 해당 컬럼 엔진 로직 사용 및 NULL 처리(Garbage 데이터로 인한 오류 방지), 2024.10.07 
                  attribute3 : org ssp frozen(전극용 엔진모델링과 같이 사용하자)
                  attribute4 : 통합FP 52주 Daily 출하계획 동기화 구간 
               */ 
             , a.ship_frozen  AS attribute3
             , CASE WHEN a.attribute7 = 'Y' AND a.attribute8 > 0 THEN a.attribute8
                    ELSE NULL
                END           AS attribute4 
             , attribute5
             , attribute6
               /* org scm_mst_site.attribute7/attribute8 값, 2024.10.07 추가 */
             , CASE WHEN a.attribute7 IN ('Y', 'N') THEN a.attribute7
                    ELSE NULL
                END       AS attribute7 
             , CASE WHEN a.attribute8 > 0 THEN a.attribute8
                    ELSE NULL
                END       AS attribute8
             , attribute9, attribute10
        FROM   scm_mst_site a WITH (NOLOCK)  
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
        WHERE  division_id = @p_division_id
        AND    site_type   = 'PLANT'
        AND    valid_yn    = 'Y'
        AND    (( a.operation_group = 'E' AND b.gubun <= 3 )
                OR 
                ( a.operation_group = 'A' AND ISNULL(a.osp_yn, 'N') = 'N' AND b.gubun <= 4)
                OR 
                ( a.operation_group = 'A' AND ISNULL(a.osp_yn, 'N') = 'Y' AND b.gubun <= 1) --20180822 추가 외주셀 ***만 생성
                OR 
                ( a.operation_group = 'P' AND ISNULL(a.osp_yn, 'N') = 'N' AND b.gubun <= 2)
                OR 
                ( a.operation_group = 'P' AND ISNULL(a.osp_yn, 'N') = 'Y' AND b.gubun <= 1) --20180822 추가 외주팩 ***만 생성
                
               )  -- 20180717 수정 (변경전 : ( operation_group = 'P' AND b.gubun = 1 )) )
        
        -- 20180621 추가 전극제외처리
        AND    operation_group <> 'E' 
        ;
		
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 1-2 START';
        SET @v_description = '1-2. SALES Site  INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        
        -----------------------------------------------------------
        -- 1-2). SALES Site : Demand / Intransit / 확정 SP 가 존재하는 Site
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_IN_FN_SET_SITE_ENG */ scm_mst_site_eng
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
             , s.division_id, s.scm_site_id, d.site, s.site_description, s.site_type, s.city, s.country -- eng_scm_site_id 값 정리 필요
             , s.plant_id, s.operation_group, s.dept_id, s.vmi_yn, s.valid_yn, s.new_yn
             , s.site_hrcy_id, s.osp_yn, s.ship_frozen, s.prod_frozen, s.end_customer, s.fp_plan_period
             , s.soldto_customer --20180326 soldto_code 변경
             , s.build_ahead, s.company_id, s.site_id, s.logistic_plant_id
             , 'scp_batch' AS created_by, GETDATE() AS creation_date, 'scp_batch' AS last_updated_by, GETDATE() AS last_update_date			 
             , 'N'  AS attribute1 -- 20200203 [OSP Line Plan] Sales Site는 'N'
             , 'N'  AS attribute2 -- 20200812 [Packer Visivility] Sales Site는 'N'
               /* Sales Site의 (attribute3/attribute4) 값은 NULL 처리 (사용용도 없는 값), 2024.10.07 추가 */ 
             , NULL AS attribute3
             , NULL AS attribute4
             , s.attribute5
             , s.attribute6
               /* Sales Site의 (attribute7/attribute8) 값은 NULL 처리 (사용용도 없는 값), 2024.10.07 추가 */
             , NULL AS attribute7 
             , NULL AS attribute8
             , s.attribute9, s.attribute10
        FROM   scm_mst_site     s WITH (NOLOCK)  
             ,(-- Demand
               SELECT DISTINCT scm_site, site 
                 FROM th_eng_demand_sn WITH (NOLOCK)
                WHERE master_id   = @p_master_id
                  AND plan_id     = @p_engine_plan_id
                UNION -- Intransit
               SELECT DISTINCT org_to_scm_site_id AS scm_site, to_scm_site_id AS site
                FROM  scp_eng_intransitshpmnt_i_sn WITH (NOLOCK)
                WHERE modeling_id = @p_modeling_id
                  AND plan_id     = @p_plan_id
                  AND plan_type   = @p_plan_type
                  AND plan_seq    = @p_plan_seq
                  AND division_id = @p_division_id
                  AND result_date = @v_cutoff_day                
                  -- 20180720 추가   ssp_anl_ship_confirm, scp_anl_shipment_plan_fix, scp_anl_shipment_plan_fg 정보에 존재하는 SALES site 데이터생성
			      -- 20211013 [PJ20214907] AS : SSP의 'AS(WH-In 용) Plant Plan' 을 'AS(WH-In 용) Sales Plan' 으로 전환
                UNION -- 확정 SP
               /* 2024.10.07 ssp 기준 테이블 변경 :  ssp_anl_ship_confirm -> scm_dnm_ssp_plan_v */
               SELECT DISTINCT to_site AS scm_site, to_site + '~' + incoterms  AS site                         
                 FROM scm_dnm_ssp_plan_v WITH (NOLOCK)  --//기존 : ssp_anl_ship_confirm, 2024.10.07 변경
                WHERE division_id  = @p_division_id  
                  AND qty          > 0
                  AND yyyymmdd     >= @p_plan_name
               -- AND change_type  = 'C'     -- 20180716 추가   
                  AND ssp_type     = 'CFM'   -- 2024.10.07 변경   
               UNION -- 확정 SP
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
              SELECT DISTINCT to_site AS scm_site, to_site + '~' + incoterms  AS site 
                FROM scp_anl_shipment_plan_fix WITH (NOLOCK)
               WHERE division_id         =  @p_division_id  
                 AND qty                 >  0
                 AND yyyymmdd            >= @p_plan_name
                 AND incoterms           IS NOT NULL
               UNION 
              SELECT DISTINCT to_site AS scm_site, to_site + '~' + incoterms  AS site  
                FROM scp_anl_shipment_plan_fg WITH (NOLOCK) 
               WHERE division_id         = @p_division_id  
                 AND plan_start_yyyymmdd = @v_pre_plan_start_yyyymmdd
                 AND plan_type           = @v_pre_plan_type 
                 AND seq                 = @n_pre_plan_seq 
                 AND measure             = 'SHIP_PLAN_AMEND'
                 AND qty                 > 0
              ) d  
        WHERE s.division_id = @p_division_id
          AND s.site_type   = 'SALES'
          AND s.valid_yn    = 'Y'
          AND s.scm_site_id = d.scm_site
        ; 

        -----------------------------------------------------------
        -- 2.Site Item ENG
        -----------------------------------------------------------
        DELETE /* PR_SCP_ENG_IN_FN_SET_SITE_ENG */
        FROM  scm_mst_site_item_eng
        WHERE 1=1
        AND   plan_id     = @p_plan_id
        AND   modeling_id = @p_modeling_id
        AND   plan_type   = @p_plan_type
        AND   plan_seq    = @p_plan_seq
        ;		
		
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 2-1 START';
        SET @v_description = '2-1. SALES Site Item INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;        
        
        ----------------------------------------------------------- 
        -- 임시테이블 생성 (주석2-5 DELETE 처리 때문에) : 20181029
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#SCM_MST_SITE_ITEM_ENG_FINAL') IS NOT NULL
        BEGIN 
            DROP TABLE #SCM_MST_SITE_ITEM_ENG_FINAL
        END
        
         
        CREATE TABLE #SCM_MST_SITE_ITEM_ENG_FINAL
        (
	        MODELING_ID nvarchar(30) NOT NULL,
	        PLAN_ID nvarchar(30) NOT NULL,
	        PLAN_TYPE nvarchar(50) NOT NULL,
	        PLAN_SEQ int NOT NULL,
	        DIVISION_ID nvarchar(30) NOT NULL,
	        PROJECT_CODE nvarchar(50) NOT NULL,
	        SCM_SITE_ID nvarchar(30) NOT NULL,
	        ENG_SCM_SITE_ID nvarchar(50) NOT NULL,
	        SITE_DESCRIPTION nvarchar(max) NOT NULL,
	        ITEM_ID nvarchar(50) NOT NULL,
	        ITEM_NAME nvarchar(150) NULL,
	        CURRENCY nvarchar(10) NULL,
	        LIABILITY_PERIOD int NULL,
	        SALES_PLAN_ADJUST_YN nvarchar(1) NULL,
	        ITEM_HRCY_ID nvarchar(50) NULL,
	        PRIORITY int NULL,
	        VALID_YN nvarchar(1) NULL,
	        BPMS_EXIST nvarchar(1) NULL,
	        CREATED_BY nvarchar(150) NULL,
	        CREATION_DATE datetime NULL,
	        LAST_UPDATED_BY nvarchar(150) NULL,
	        LAST_UPDATE_DATE datetime NULL,
	        ATTRIBUTE1 nvarchar(150) NULL,
	        ATTRIBUTE2 nvarchar(150) NULL,
	        ATTRIBUTE3 nvarchar(150) NULL,
	        ATTRIBUTE4 nvarchar(150) NULL,
	        ATTRIBUTE5 nvarchar(150) NULL,
	        ATTRIBUTE6 nvarchar(150) NULL,
	        ATTRIBUTE7 nvarchar(150) NULL,
	        ATTRIBUTE8 nvarchar(150) NULL,
	        ATTRIBUTE9 nvarchar(150) NULL,
	        ATTRIBUTE10 nvarchar(150) NULL 
            
            -- PK 생성(INDEX 명을 셋팅하면 안됨, 아래 '주의) INDEX 생성' 주석참조)
            , PRIMARY KEY(  MODELING_ID ASC,
	                        PLAN_ID ASC,
	                        PLAN_TYPE ASC,
	                        PLAN_SEQ ASC,
	                        DIVISION_ID ASC,
	                        PROJECT_CODE ASC,
	                        SCM_SITE_ID ASC,
	                        ENG_SCM_SITE_ID ASC,
	                        ITEM_ID ASC
                          )
            
            /* 주의) INDEX 생성
            -- 참고) 아래경우처럼 INDEX명을 지정해주면 
            --       다른세션에서 동일프로시저를 실행할경우 
            --       임시테이블 생성시 아래인덱스 명이 동일하게 존재하므로 INDEX 중복오류발생함
            
               ,CONSTRAINT PK_SCM_MST_SITE_ITEM_ENG_FINAL_TEMP PRIMARY KEY CLUSTERED 
                (
	                MODELING_ID ASC,
	                PLAN_ID ASC,
	                PLAN_TYPE ASC,
	                PLAN_SEQ ASC,
	                DIVISION_ID ASC,
	                PROJECT_CODE ASC,
	                SCM_SITE_ID ASC,
	                ENG_SCM_SITE_ID ASC,
	                ITEM_ID ASC
                )
           */
        ) 
        ;

        ----------------------------------------------------------- 
        -- 2-1). SALES Site
        -----------------------------------------------------------
		INSERT INTO /* PR_SCP_ENG_IN_FN_SET_SITE_ENG */ #SCM_MST_SITE_ITEM_ENG_FINAL
		 	 (modeling_id, plan_id, plan_type, plan_seq
		 	, division_id, project_code, scm_site_id, eng_scm_site_id, site_description
		 	, item_id, item_name, currency
		 	, liability_period, sales_plan_adjust_yn, item_hrcy_id, priority, valid_yn, bpms_exist
		 	, created_by, creation_date, last_updated_by, last_update_date
		 	, attribute1, attribute2, attribute3, attribute4, attribute5
		 	, attribute6, attribute7, attribute8, attribute9, attribute10
		  )
		SELECT DISTINCT @p_modeling_id, @p_plan_id, @p_plan_type, @p_plan_seq
		     , smsi.division_id, smsi.project_code, smsi.scm_site_id, smse.eng_scm_site_id, smse.site_description
		     , smsi.item_id, smis.item_name, smsi.currency
		     , smsi.liability_period, smsi.sales_plan_adjust_yn, smsi.item_hrcy_id, 1 AS priority, smsi.valid_yn, smsi.bpms_exist
             , 'scp_batch' AS created_by, GETDATE() AS creation_date, 'scp_batch' AS last_updated_by, GETDATE() AS last_update_date
		     , smsi.attribute1, smsi.attribute2, smsi.attribute3, smsi.attribute4, smsi.attribute5
		     , smsi.attribute6, smsi.attribute7, smsi.attribute8, smsi.attribute9, smsi.attribute10
		FROM   scm_mst_site_item smsi WITH (NOLOCK)  
		     , scm_mst_site_eng  smse WITH (NOLOCK)
             ,(-- Demand / Intransit / 확정 SP 가 존재하는 Site Item
               SELECT DISTINCT scm_site, site, item
               FROM   th_eng_demand_sn WITH (NOLOCK)
               WHERE  master_id   = @p_master_id
               AND    plan_id     = @p_engine_plan_id
               UNION -- Intransit
               SELECT DISTINCT org_to_scm_site_id AS scm_site, to_scm_site_id AS site, a.item_id AS item
               FROM   scp_eng_intransitshpmnt_i_sn a WITH (NOLOCK)
               WHERE  modeling_id = @p_modeling_id
               AND    plan_id     = @p_plan_id
               AND    plan_type   = @p_plan_type
               AND    plan_seq    = @p_plan_seq
               AND    division_id = @p_division_id
               AND    result_date = @v_cutoff_day                
               -- 20180720 추가   ssp_anl_ship_confirm, scp_anl_shipment_plan_fix, scp_anl_shipment_plan_fg 정보에 존재하는 SALES site 데이터생성
			   -- 20211013 [PJ20214907] AS : SSP의 'AS(WH-In 용) Plant Plan' 을 'AS(WH-In 용) Sales Plan' 으로 전환
               UNION -- 확정 SP
               /* 2024.10.07 ssp 기준 테이블 변경 :  ssp_anl_ship_confirm -> scm_dnm_ssp_plan_v */
               SELECT DISTINCT s.to_site AS scm_site, s.to_site + '~' + s.incoterms  AS site
                    -- 20220106 PJ20209643 소형 OSP Pack Item 처리
                    , CASE WHEN ISNULL(fi.packer_plan_item_id, '') = '' THEN s.item_id
                           ELSE fi.packer_plan_item_id
                      END item
                    --, s.item_id AS item                         
                FROM scm_dnm_ssp_plan_v s WITH (NOLOCK)  --//기존:ssp_anl_ship_confirm, 2024.10.07 변경
               -- 20220106 PJ20209643 소형 OSP Pack Item 처리
                LEFT JOIN scp_mst_final_item fi WITH(NOLOCK) --2018.06.29
                  ON s.division_id = fi.division_id
                 AND s.item_id     = fi.item_id 
                 AND @v_division_group = '40'  --(2022.04.04) JV사업부 추가: division_id -> v_division_group 으로 변경                           
               WHERE s.division_id     = @p_division_id  
                 AND s.qty             > 0
                 AND s.yyyymmdd        >= @p_plan_name
               --AND s.change_type     = 'C'   -- 20180716 추가  			   
                 AND s.ssp_type        = 'CFM' -- 202410.07 변경 			   
               UNION -- 확정 SP
               SELECT DISTINCT md.segment1 AS scm_site
                   , md.segment1 + '~' + 'DAP'  AS site
                   -- 20220106 PJ20209643 소형 OSP Pack Item 처리
                   , CASE WHEN ISNULL(fi.packer_plan_item_id, '') = '' THEN sc.item_id
                          ELSE fi.packer_plan_item_id
                     END item
                 --, sc.item_id AS item
                FROM scm_dnm_ssp_plan_v sc WITH (NOLOCK)  --//기존:ssp_anl_ship_confirm, 2024.10.07 변경
               INNER JOIN scm_adm_lookup_master_detail md WITH(NOLOCK)
                  ON sc.division_id = md.segment3
                 AND sc.to_site     = md.segment2
                 AND md.lookup_type = 'AS_SITE_PLANT'
                 AND md.valid_yn    = 'Y'
                 -- 20220106 PJ20209643 소형 OSP Pack Item 처리
                LEFT JOIN scp_mst_final_item fi WITH(NOLOCK) --2018.06.29
                  ON sc.division_id = fi.division_id
                 AND sc.item_id     = fi.item_id 
                 AND @v_division_group = '40'     ---2022.04.04 JV사업부 추가: division_id -> v_division_group 으로 변경
               WHERE sc.division_id    = @p_division_id  
                 AND sc.qty            > 0
                 AND sc.yyyymmdd       >= @p_plan_name
               --AND sc.change_type    = 'C'   -- 20180716 추가  
                 AND sc.ssp_type       = 'CFM' -- 2024.10.07 변경 
               UNION 
               SELECT DISTINCT to_site AS scm_site, to_site + '~' + incoterms  AS site, item_id AS item 
               FROM   scp_anl_shipment_plan_fix WITH (NOLOCK)
               WHERE  division_id         =  @p_division_id  
               AND    qty                 >  0
               AND    yyyymmdd            >= @p_plan_name
               AND    incoterms           IS NOT NULL
               UNION 
               SELECT DISTINCT to_site AS scm_site, to_site + '~' + incoterms  AS site, item_id AS item  
               FROM   scp_anl_shipment_plan_fg WITH (NOLOCK) 
               WHERE  division_id         = @p_division_id  
               AND    plan_start_yyyymmdd = @v_pre_plan_start_yyyymmdd
               AND    plan_type           = @v_pre_plan_type 
               AND    seq                 = @n_pre_plan_seq 
               AND    measure             = 'SHIP_PLAN_AMEND'
               AND    qty                 > 0
              ) d
		     ,(SELECT division_id, item_id, MAX(item_name) AS item_name
		       FROM   scm_mst_item_sn WITH (NOLOCK)  
		       WHERE  division_id = @p_division_id
			   AND    active_flag = 'Y'
			   GROUP  BY division_id, item_id
		      ) smis
		WHERE  1 = 1
		AND    smse.modeling_id = @p_modeling_id
		AND    smse.plan_id     = @p_plan_id
		AND    smse.plan_type   = @p_plan_type
		AND    smse.plan_seq    = @p_plan_seq
        AND    d.site           = smse.eng_scm_site_id
        AND    d.item           = smsi.item_id
		AND    smse.division_id = smsi.division_id
		AND    smse.scm_site_id = smsi.scm_site_id
		AND    smsi.valid_yn    = 'Y'
		AND    smse.site_type   = 'SALES'
		AND    smsi.division_id = smis.division_id
		AND    smsi.item_id     = smis.item_id
		;
		        
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 2-2 START';
        SET @v_description = '2-2. PLANT Site Item INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;        

        -----------------------------------------------------------
        -- 2-2. PLANT Site
        -----------------------------------------------------------
		INSERT INTO /* PR_SCP_ENG_IN_FN_SET_SITE_ENG */ #SCM_MST_SITE_ITEM_ENG_FINAL
		 	 (modeling_id, plan_id, plan_type, plan_seq
		 	, division_id, project_code, scm_site_id, eng_scm_site_id, site_description
		 	, item_id, item_name, currency
		 	, liability_period, sales_plan_adjust_yn, item_hrcy_id, priority, valid_yn, bpms_exist
		 	, created_by, creation_date, last_updated_by, last_update_date
		 	, attribute1, attribute2, attribute3, attribute4, attribute5
		 	, attribute6, attribute7, attribute8, attribute9, attribute10
		  )
		SELECT @p_modeling_id, @p_plan_id, @p_plan_type, @p_plan_seq
		     , smsi.division_id, smsi.project_code, smsi.scm_site_id, smse.eng_scm_site_id, smse.site_description
		     , smsi.item_id, smis.item_name, smsi.currency
		     , smsi.liability_period, smsi.sales_plan_adjust_yn, smsi.item_hrcy_id, 1 AS priority, smsi.valid_yn, smsi.bpms_exist
             , 'scp_batch' AS created_by, GETDATE() AS creation_date, 'scp_batch' AS last_updated_by, GETDATE() AS last_update_date
		     , smsi.attribute1, smsi.attribute2, smsi.attribute3, smsi.attribute4, smsi.attribute5
		     , smsi.attribute6, smsi.attribute7, smsi.attribute8, smsi.attribute9, smsi.attribute10
		FROM   scm_mst_site_item smsi WITH (NOLOCK)  
             , (SELECT DISTINCT 
                       division_id, plant_site_id, item_id
                FROM   scm_mst_site_item_priority WITH (NOLOCK)
                WHERE  division_id = @p_division_id
                AND    valid_yn = 'Y'
                AND    to_yyyymmdd >= @p_plan_name --CONVERT(NVARCHAR(8), GETDATE(), 112) 
               ) sip  --20180417 추가 ( scm_mst_site_item_priority 테이블의 valid_yn = 'N' 일때 scm_mst_site_item 테이블의 valid_yn은 'Y'일수도 있음, 두테이블이 서로 동기화 되지 않을수 있으므로 scm_mst_site_item_priority 테이블 조인처리함)
		     , scm_mst_site_eng  smse WITH (NOLOCK)  
		     ,(SELECT division_id, item_id, MAX(item_name) AS item_name
		       FROM   scm_mst_item_sn WITH (NOLOCK)  
		       WHERE  division_id = @p_division_id
			   AND    active_flag = 'Y'
			   GROUP  BY division_id, item_id
		      ) smis
		WHERE  smse.modeling_id = @p_modeling_id
		AND    smse.plan_id     = @p_plan_id
		AND    smse.plan_type   = @p_plan_type
		AND    smse.plan_seq    = @p_plan_seq
        --20180417 추가
        AND    smsi.division_id = sip.division_id
        AND    smsi.scm_site_id = sip.plant_site_id
        AND    smsi.item_id     = sip.item_id
		AND    smse.division_id = smsi.division_id
		AND    smse.scm_site_id = smsi.scm_site_id
		AND    smsi.valid_yn    = 'Y'
		AND    smse.site_type   = 'PLANT'
		AND    smsi.division_id = smis.division_id
		AND    smsi.item_id     = smis.item_id
		;



        -----------------------------------------------------------
        --2021/05/18 SEMI 반제품 이동 공정 개선, By KKC
		--2-3. PLANT Site : 팩SITE ITEM에 존재하지 않는 셀 SITE ITEM 정보 추가
		--Case#1) 'A~003', 'P~***' : NORMAL CASE#로 SEMI 반제품 공정 (Pack BOM 존재)
		--Case#2) 'A~003', 'P~***' : 비정상적인 SEMI 반제품 공정 (Pack BOM 미존재)      
        -----------------------------------------------------------
		-- 2-3-1) Case#1
        -----------------------------------------------------------
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 2-3-1 START';
        SET @v_description = '2-3-1. PLANT Cell Site Item INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;        

        INSERT INTO /* PR_SCP_ENG_IN_FN_SET_SITE_ENG */ #SCM_MST_SITE_ITEM_ENG_FINAL
		(  modeling_id, plan_id, plan_type, plan_seq, division_id
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
             , NULL AS attribute9, 'A' AS attribute10 -- scm_mst_bod_item_eng 에서 제외대상건 'A'
        FROM (
                SELECT a.*
                        , b.operation_group, b.plant_id 
                FROM   #SCM_MST_SITE_ITEM_ENG_FINAL a WITH (NOLOCK)
                        INNER JOIN scm_mst_site_eng b  WITH (NOLOCK)
                        ON    a.modeling_id = b.modeling_id
                        AND   a.plan_id     = b.plan_id 
                        AND   a.plan_type   = b.plan_type 
                        AND   a.plan_seq    = b.plan_seq
                        AND   a.division_id = b.division_id
                        AND   a.eng_scm_site_id = b.eng_scm_site_id
                        AND   b.operation_group IN ( 'A', 'P') 
                        AND   b.site_type = 'PLANT'
                        AND   b.eng_scm_site_id = b.scm_site_id + '~***' --
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
                            FROM   (
                                    SELECT a.*
                                            , b.operation_group, b.plant_id 
                                    FROM   #SCM_MST_SITE_ITEM_ENG_FINAL a WITH (NOLOCK)
                                            INNER JOIN scm_mst_site_eng b  WITH (NOLOCK)
                                            ON    a.modeling_id = b.modeling_id
                                            AND   a.plan_id     = b.plan_id 
                                            AND   a.plan_type   = b.plan_type 
                                            AND   a.plan_seq    = b.plan_seq
                                            AND   a.division_id = b.division_id
                                            AND   a.eng_scm_site_id = b.eng_scm_site_id
                                            AND   b.operation_group IN ( 'A', 'P') 
                                            AND   b.site_type = 'PLANT'                                         
                                            AND   b.eng_scm_site_id = b.scm_site_id + '~***' 
                                            AND   EXISTS (  SELECT 1     /* 2023.07.07 cell code분리건: cell_product코드가 나오게 하기 위해서 */ 
                                                            FROM    scm_mst_final_item_v   fi  WITH(NOLOCK) 
                                                            WHERE   fi.DIVISION_ID =  @p_division_id    
                                                            and     fi.cell_type NOT LIKE 'CA%' -- = 'CP' -- 2026.05.15 kimcd [PJ2026-50273] MI ESS LINK 공장 SCM(SCP/FP/PSCM ) 대응. Pack 제품 포함하기 위해 조건 수정
                                                            AND     fi.ITEM_ID  = a.item_id ) 
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
                                   AND  aa.operation_group IN (  'A', 'P' ) -- 2026.05.15 kimcd [PJ2026-50273] MI ESS LINK 공장 SCM(SCP/FP/PSCM ) 대응. from, to에서 사내 LINK, Pack 공정군 제품 유형 출하 가능하도록 'P' 공정 추가
                          ) x
                          , ( SELECT 1 AS gubun UNION ALL SELECT 2  AS gubun)  y
                    ) b
        ON    a.operation_group = 'P'
        AND   a.item_id = b.model_parent_item_id
        WHERE NOT EXISTS ( SELECT 1 FROM #SCM_MST_SITE_ITEM_ENG_FINAL  WITH (NOLOCK)
                           WHERE  modeling_id     = a.modeling_id 
                           AND    plan_id         = a.plan_id 
                           AND    plan_type       = a.plan_type
                           AND    plan_seq        = a.plan_seq 
                           AND    division_id     = a.division_id 
                           AND    project_code    = b.project_code
                           AND    scm_site_id     = a.scm_site_id 
                           AND    item_id         = b.item_id
                          )
        ;

        -----------------------------------------------------------
		-- 2-3-2) Case#2
        -----------------------------------------------------------
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 2-3-2 START';
        SET @v_description = '2-3-2. PLANT Cell Site Item INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;        
        
		/* JV 공통화 및 조건 정리, 2023.03.13 
		   자동차만 수행
		*/
        IF @v_division_group = '81' or @v_division_group = '82' -- E20260327-001884 ess사업부 scm_mst_site_item_eng 기준정보 추가 
		
		BEGIN

			INSERT INTO /* PR_SCP_ENG_IN_FN_SET_SITE_ENG */ #SCM_MST_SITE_ITEM_ENG_FINAL
			(  modeling_id, plan_id, plan_type, plan_seq, division_id
			 , project_code, scm_site_id, eng_scm_site_id, site_description, item_id
			 , item_name, currency, liability_period, sales_plan_adjust_yn, item_hrcy_id
			 , priority, valid_yn, bpms_exist, created_by, creation_date
			 , last_updated_by, last_update_date, attribute1, attribute2, attribute3
			 , attribute4, attribute5, attribute6, attribute7, attribute8
			 , attribute9, attribute10
			  )
		   SELECT DISTINCT  
				  @p_modeling_id
				, @p_plan_id
				, @p_plan_type
				, @p_plan_seq
				, @p_division_id
				, '-'                as project_code
				, a.to_site          as scm_site_id
				, b.eng_scm_site_id  as eng_scm_site_id
				, b.site_description as site_descriotpion
				, a.item_id
				, (
				  SELECT TOP 1  
						 p.ITEM_NAME
					FROM scm_mst_item_sn p WITH(NOLOCK)
				   WHERE division_id = @p_division_id     --//Original Division별로 관리됨, 2023.03.10 주석 추가
					 AND active_flag = 'Y'
					 AND item_id = a.item_id
				  )                as item_name
				, 'KRW'            as currency
				, 0                as liability_period
				, 'N'              as sales_plan_adjust_yn
				, NULL             as item_hrcy_id
				, 99               as priority
				, 'Y'              as valid_yn
				, 'N'              as bpms_exist
				,'scp_batch'       as created_by
				, GETDATE()        as creation_date
				, 'scp_batch'      as last_updated_by
				, GETDATE()        as last_update_date
				, NULL             as attribute1
				, NULL             as attribute2
				, NULL             as attribute3
				, NULL             as attribute4
				, NULL             as attribute5
				, NULL             as attribute6
				, NULL             as attribute7
				, NULL             as attribute8
				, NULL             as attribute9
				, 'A'              as attribute10 -- scm_mst_bod_item_eng 에서 제외대상건 'A'	 
			FROM
				(
				/* SEMI 출하 FIX 계획 */
				SELECT a.to_site
					 , a.item_id
				  FROM scp_anl_shipment_plan_fix a WITH (NOLOCK)  
				 WHERE a.division_id     =  @p_division_id  -- 2022.04.04 조건추가 
				   AND qty               >  0
				   AND yyyymmdd          >= @p_plan_name
                   -- E20260415-000945 ESS 대치코드 반제품 출하계획 입력 시 계획 사라지는 현상 기존소스 주석처리
                   -- AND a.from_site         LIKE '%-A'
				   AND (a.from_site         LIKE '%-A' OR a.from_site LIKE '%-P') -- E20260415-000945  ESS 대치코드 반제품 출하계획 입력 시 계획 사라지는 현상
				   AND to_site     LIKE '%-P'
				   AND NOT EXISTS (SELECT 'X'
									 FROM #SCM_MST_SITE_ITEM_ENG_FINAL x(NOLOCK)
									WHERE x.item_id = a.item_id
									  AND x.scm_site_id = a.to_site)
				UNION 
				/* SEMI 출하 amend 계획 */
				SELECT a.to_site
					 , a.item_id
				  FROM scp_anl_shipment_plan_semi a WITH (NOLOCK)  
				 WHERE a.division_id       = @p_division_id    -- 2022.04.04 조건추가 
				   AND plan_start_yyyymmdd = @v_pre_plan_start_yyyymmdd
				   AND plan_type           = @v_pre_plan_type 
				   AND seq                 = @n_pre_plan_seq 
				   AND measure             = 'SHIP_PLAN_AMEND'
				   AND qty                 > 0
				   AND yyyymmdd            >= @p_plan_name
                   -- E20260415-000945 ESS 대치코드 반제품 출하계획 입력 시 계획 사라지는 현상 기존소스 주석처리
                   -- AND a.from_site         LIKE '%-A'
				   AND (a.from_site         LIKE '%-A' OR a.from_site LIKE '%-P') -- E20260415-000945  ESS 대치코드 반제품 출하계획 입력 시 계획 사라지는 현상
				   AND to_site   LIKE '%-P'
				   AND NOT EXISTS (SELECT 'X'
									 FROM #SCM_MST_SITE_ITEM_ENG_FINAL x(NOLOCK)
									WHERE x.item_id = a.item_id
									  AND x.scm_site_id = a.to_site
								  )
				UNION
				/* SSP 출하 확정계획 (SSP Confirm) */
                /* 2024.10.07 ssp 기준 테이블 변경 :  ssp_anl_ship_confirm -> scm_dnm_ssp_plan_v */
				SELECT a.to_site
					 , a.item_id
				  FROM scm_dnm_ssp_plan_v a WITH (NOLOCK) --//기존:ssp_anl_ship_confirm,  2024.10.07 변경
				 WHERE a.division_id  =  @p_division_id      -- 2022.04.04 조건추가 
				   AND a.qty          >  0
				   AND a.yyyymmdd     >= @p_plan_name
                   AND a.ssp_type     = 'CFM'   -- 2024.10.07 추가 
                   -- E20260415-000945 ESS 대치코드 반제품 출하계획 입력 시 계획 사라지는 현상 기존소스 주석처리
                   -- AND a.from_site         LIKE '%-A'
				   AND (a.from_site         LIKE '%-A' OR a.from_site LIKE '%-P') -- E20260415-000945  ESS 대치코드 반제품 출하계획 입력 시 계획 사라지는 현상
				   AND a.to_site      LIKE '%-P'
				   AND NOT EXISTS (SELECT 'X'
									 FROM #SCM_MST_SITE_ITEM_ENG_FINAL x(NOLOCK)
									WHERE x.item_id = a.item_id
									  AND x.scm_site_id = a.to_site
                                  ) 
				UNION
				/* SSP 출하 계획 */
				SELECT a.to_site
					 , a.item_id
				  FROM ssp_anl_ship_plan_all a WITH (NOLOCK)   
				 WHERE a.division_id       = @p_division_id    -- 2022.04.04 조건추가 
				   AND yyyymmdd           >= @p_plan_name
                   -- E20260415-000945 ESS 대치코드 반제품 출하계획 입력 시 계획 사라지는 현상 기존소스 주석처리
                   -- AND a.from_site         LIKE '%-A'
				   AND (a.from_site         LIKE '%-A' OR a.from_site LIKE '%-P') -- E20260415-000945  ESS 대치코드 반제품 출하계획 입력 시 계획 사라지는 현상
				   AND to_site   LIKE '%-P'
				   AND shipment_confirm_qty > 0
				   AND NOT EXISTS (SELECT 'X'
									 FROM #SCM_MST_SITE_ITEM_ENG_FINAL x(NOLOCK)
									WHERE x.item_id = a.item_id
									  AND x.scm_site_id = a.to_site)
				) a 
				, scm_mst_site_eng b WITH (NOLOCK)
			  WHERE b.division_id = @p_division_id      -- 2022.04.04 조건추가
				AND b.modeling_id = @p_modeling_id
				AND b.plan_id     = @p_plan_id
				AND b.plan_type   = @p_plan_type
				AND b.plan_seq    = @p_plan_seq
				AND b.scm_site_id = a.to_site
				AND b.eng_scm_site_id = b.scm_site_id+'~***'
				AND NOT EXISTS ( SELECT 'X'
								   FROM #SCM_MST_SITE_ITEM_ENG_FINAL  WITH (NOLOCK)
								  WHERE eng_scm_site_id = b.eng_scm_site_id  
									AND item_id         = a.item_id
								)
			;	

		END
				
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = N'PART 2-4 START';
        SET @v_description = N'2-4. PLANT Site : 외주셀 SITE ITEM에 존재하지 않는 셀 SITE ITEM 정보 추가' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        
		-----------------------------------------------------------
        --2-4. PLANT Site : 외주셀 SITE ITEM에 존재하지 않는 셀 SITE ITEM 정보 추가
        -----------------------------------------------------------
       INSERT INTO /* PR_SCP_ENG_IN_PRE_SET_SITE_ENG */ #SCM_MST_SITE_ITEM_ENG_FINAL
		(  modeling_id, plan_id, plan_type, plan_seq, division_id
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
             , NULL AS attribute9, 'A' AS attribute10 -- scm_mst_bod_item_eng 에서 제외대상건 'A'
        FROM (
                SELECT a.*
                        , b.operation_group, b.plant_id 
                FROM   #SCM_MST_SITE_ITEM_ENG_FINAL a WITH (NOLOCK)
                        INNER JOIN scm_mst_site_eng b  WITH (NOLOCK)
                        ON    a.modeling_id = b.modeling_id
                        AND   a.plan_id     = b.plan_id 
                        AND   a.plan_type   = b.plan_type 
                        AND   a.plan_seq    = b.plan_seq
                        AND   a.division_id = b.division_id
                        AND   a.eng_scm_site_id      = b.eng_scm_site_id
                        AND   b.operation_group      = 'A'
                        ANd   ISNULL(b.osp_yn, 'N')  = 'Y' --외주셀
                        AND   b.site_type = 'PLANT'
                        AND   b.eng_scm_site_id = b.scm_site_id + '~***' --
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
                            FROM   (
                                    SELECT a.*
                                            , b.operation_group, b.plant_id 
                                    FROM   #SCM_MST_SITE_ITEM_ENG_FINAL a WITH (NOLOCK)
                                            INNER JOIN scm_mst_site_eng b  WITH (NOLOCK)
                                            ON    a.modeling_id = b.modeling_id
                                            AND   a.plan_id     = b.plan_id 
                                            AND   a.plan_type   = b.plan_type 
                                            AND   a.plan_seq    = b.plan_seq
                                            AND   a.division_id = b.division_id
                                            AND   a.eng_scm_site_id = b.eng_scm_site_id
                                            AND   b.operation_group = 'A'
                                            AND   ISNULL(b.osp_yn, 'N') = 'N' --20180807 외주셀제외
                                            AND   b.site_type = 'PLANT'
                                            AND   b.eng_scm_site_id = b.scm_site_id + '~***' --
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
                                   AND  aa.operation_group = 'A'
                          ) x
                          , ( SELECT 1 AS gubun UNION ALL SELECT 2  AS gubun)  y
                    ) b
        ON    a.operation_group = 'A'
        AND   a.item_id = b.model_parent_item_id
        WHERE NOT EXISTS ( SELECT 1 FROM #SCM_MST_SITE_ITEM_ENG_FINAL  WITH (NOLOCK)
                           WHERE  modeling_id     = a.modeling_id 
                           AND    plan_id         = a.plan_id 
                           AND    plan_type       = a.plan_type
                           AND    plan_seq        = a.plan_seq 
                           AND    division_id     = a.division_id 
                           AND    project_code    = b.project_code
                           AND    scm_site_id     = a.scm_site_id 
                           AND    item_id         = b.item_id
                          )
        ;
		
		-----------------------------------------------------------
        --2-5. PLANT Site : 외주PACK SITE ITEM에 존재하지 않는 PACK SITE ITEM 정보 추가
		-- [PJ20214997] LGES SCP 신규 Biz, 공정 추가에 따른 모델링 개선
		-- 2021.11.11, JOBIL(DC LINK) BIZ Pack Site Item 추가
        -----------------------------------------------------------
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = N'PART 2-5 START';
        SET @v_description = N'2-5. PLANT Site : 외주PACK SITE ITEM에 존재하지 않는 PACK SITE ITEM 정보 추가' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        INSERT INTO /* PR_SCP_ENG_IN_FN_SET_SITE_ENG */ #SCM_MST_SITE_ITEM_ENG_FINAL
		(  modeling_id, plan_id, plan_type, plan_seq, division_id
         , project_code, scm_site_id, eng_scm_site_id, site_description, item_id
         , item_name, currency, liability_period, sales_plan_adjust_yn, item_hrcy_id
         , priority, valid_yn, bpms_exist, created_by, creation_date
         , last_updated_by, last_update_date, attribute1, attribute2, attribute3
         , attribute4, attribute5, attribute6, attribute7, attribute8
         , attribute9, attribute10
		  )
        SELECT DISTINCT
			   @p_modeling_id
			 , @p_plan_id
			 , @p_plan_type
			 , @p_plan_seq
			 , @p_division_id
			 , a.project_code
			 , a.scm_site_id
			 , a.eng_scm_site_id
			 , a.site_description
			 , b.child_item_id
			 , b.child_item_id
			 , 'KRW' AS currency
			 , 0     AS liability_period
			 , 'N'   AS sales_plan_adjust_yn
			 , NULL  AS item_hrcy_id
			 , 1     AS priority
			 , 'Y'   AS valid_yn
			 , 'N'   AS bpms_exist
			 ,'scp_batch'  AS created_by
			 , GETDATE()   AS creation_date
			 , 'scp_batch' AS last_updated_by
			 , GETDATE()   AS last_update_date
			 , NULL        AS attribute1
			 , NULL        AS attribute2
			 , NULL        AS attribute3
			 , NULL        AS attribute4
			 , NULL        AS attribute5
			 , NULL        AS attribute6
			 , NULL        AS attribute7
			 , NULL        AS attribute8
			 , NULL        AS attribute9
			 , 'P'         AS attribute10 -- scm_mst_bod_item_eng 에서 제외대상건 'A'
		FROM  (
			   SELECT a.*
					, b.operation_group, b.plant_id 
				FROM #SCM_MST_SITE_ITEM_ENG_FINAL a WITH (NOLOCK)
				INNER JOIN scm_mst_site_eng b  WITH (NOLOCK)
				ON a.modeling_id = b.modeling_id
				AND a.plan_id     = b.plan_id 
				AND a.plan_type   = b.plan_type 
				AND a.plan_seq    = b.plan_seq
				AND a.division_id = b.division_id
				AND a.eng_scm_site_id = b.eng_scm_site_id
				AND b.operation_group = 'P'
				AND b.osp_yn          = 'Y' 
				AND b.site_type = 'PLANT'
				AND b.eng_scm_site_id = b.scm_site_id + '~***' --
				WHERE a.modeling_id = @p_modeling_id
				AND a.plan_id     = @p_plan_id
				AND a.plan_type   = @p_plan_type
				AND a.plan_seq    = @p_plan_seq
				AND a.division_id = @p_division_id    
			) a
		INNER JOIN scp_eng_bomcomponents_i_sn b WITH (NOLOCK)
			ON  a.modeling_id     = b.modeling_id 
			AND a.plan_id         = b.plan_id 
			AND a.plan_type       = b.plan_type 
			AND a.plan_seq        = b.seq 
			AND a.division_id     = b.division_id 
			AND a.item_id         = b.parent_item_id 
			AND a.operation_group = 'P'
			AND EXISTS (SELECT 'X'
						  FROM SCP_MST_FINAL_ITEM X WITH(NOLOCK)
						WHERE x.division_id = a.division_id
						  AND x.operation_group = 'P'
						  AND x.item_id     = b.child_item_id
						)
			AND NOT EXISTS ( SELECT 1 FROM #SCM_MST_SITE_ITEM_ENG_FINAL  WITH (NOLOCK)
							  WHERE modeling_id     = a.modeling_id 
							   AND  plan_id         = a.plan_id 
							   AND  plan_type       = a.plan_type
							   AND  plan_seq        = a.plan_seq 
							   AND  division_id     = a.division_id 
							   AND  project_code    = A.project_code
							   AND  scm_site_id     = a.scm_site_id 
							   AND  item_id         = b.child_item_id
							)
	    ;

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = N'PART 2-5-1 START';
        SET @v_description = N'2-5-1. 일반 셀site 에 생성된  TCO 셀 item 삭제' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        -----------------------------------------------------------
        -- 2-5) scm_mst_site_item_eng 테이블 
		--			                   - 1) '~***', '~001' : 일반 셀site 에 생성된  TCO 셀 item 삭제  
		--			                   - 2) '~***', '~001', '~002' : 일반 셀site 에 생성된, OSP-A 에 Assign된 TCO 셀 item 삭제            
        -----------------------------------------------------------
		-- 2-5-1) TCO 셀 item 삭제
        -----------------------------------------------------------
        DELETE #SCM_MST_SITE_ITEM_ENG_FINAL
        FROM   #SCM_MST_SITE_ITEM_ENG_FINAL a              
              INNER JOIN ( SELECT * 
                            FROM   scm_mst_site_eng WITH (NOLOCK)
                            WHERE  division_id     = @p_division_id
                            AND    plan_id         = @p_plan_id
                            AND    plan_type       = @p_plan_type
                            AND    plan_seq        = @p_plan_seq 
                            AND    ISNULL(osp_yn, 'N')  = 'N'
                            AND    operation_group      = 'A'
                            AND    dbo.fn_scm_split(eng_scm_site_id, 2, '~') IN ( '***', '001')
                          ) b
               ON   a.eng_scm_site_id = b.eng_scm_site_id
               AND  a.division_id     = b.division_id 
               AND  a.plan_id         = b.plan_id
               AND  a.plan_seq        = b.plan_seq
               AND  a.plan_type       = b.plan_type               

              INNER JOIN (  SELECT aa.item_id
                            --FROM   scm_mst_final_item_v aa WITH (NOLOCK)
                            FROM   scp_mst_final_item aa WITH (NOLOCK)							
                            WHERE  aa.division_id        = @p_division_id
                            AND    aa.operation_group_id = 'A' -- CELL
                            AND    aa.tco_cell_yn        = 'Y'  -- TCO Cell
                          ) c
              ON   a.item_id         = c.item_id 

        WHERE  a.division_id = @p_division_id
        AND    a.plan_id     = @p_plan_id
        AND    a.plan_type   = @p_plan_type
        AND    a.plan_seq    = @p_plan_seq
        ;
		
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = N'PART 2-5-2 START';
        SET @v_description = N'2-5-2. 일반 셀site 에 생성된, OSP-A 에 Assign된 TCO 셀 item 삭제' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        -----------------------------------------------------------
		--2-5-2) OSP-A 에 Assign된 TCO 셀 item 삭제 
        -----------------------------------------------------------
        DELETE #SCM_MST_SITE_ITEM_ENG_FINAL
        FROM   #SCM_MST_SITE_ITEM_ENG_FINAL a              
              INNER JOIN ( SELECT * 
                            FROM   scm_mst_site_eng WITH (NOLOCK)
                            WHERE  division_id     = @p_division_id
                            AND    plan_id         = @p_plan_id
                            AND    plan_type       = @p_plan_type
                            AND    plan_seq        = @p_plan_seq 
                            AND    ISNULL(osp_yn, 'N')  = 'N'
                            AND    operation_group      = 'A'
                            AND    dbo.fn_scm_split(eng_scm_site_id, 2, '~') IN ( '***', '001', '002')
                          ) b
               ON   a.eng_scm_site_id = b.eng_scm_site_id
               AND  a.division_id     = b.division_id 
               AND  a.plan_id         = b.plan_id
               AND  a.plan_seq        = b.plan_seq
               AND  a.plan_type       = b.plan_type               
             --20181016 수정  OSP-A에 BOD 연결된 From Site에 대해서만 item 삭제로 변경하기위해서 수정
             INNER JOIN (  SELECT aa.item_id, aa.eng_scm_site_id
                               ,  cc.from_site 
                            FROM   #SCM_MST_SITE_ITEM_ENG_FINAL aa WITH (NOLOCK)                                    
                                    
                                   INNER JOIN scm_mst_site bb WITH (NOLOCK)
                                    ON   aa.scm_site_id = bb.scm_site_id   
                                    AND  bb.division_id = @p_division_id 
                                    AND  ISNULL(bb.osp_yn, 'N') = 'Y'
                                    AND  bb.operation_group     = 'A' 
                                    AND  bb.valid_yn            = 'Y'     
                                   INNER JOIN scp_mst_bod_n_v cc WITH (NOLOCK) --2021.08.25 기간별 view로 변경(scp_mst_bod_v -> scp_mst_bod_n_v)
                                   ON    bb.scm_site_id = cc.to_site
                                   AND   cc.division_id = @p_division_id 
                                   AND   cc.bod_valid_yn = 'Y'
                                   INNER JOIN scp_mst_bod_item dd WITH (NOLOCK)
                                   ON    cc.bod_id      = dd.bod_id
                                   AND   cc.division_id = dd.division_id 
                                   AND   dd.valid_yn    = 'Y'
                                   AND   aa.item_id     = dd.item_id                                                                                            
                            WHERE  aa.division_id = @p_division_id
                            AND    aa.plan_id     = @p_plan_id
                            AND    aa.plan_type   = @p_plan_type
                            AND    aa.plan_seq    = @p_plan_seq
                            AND   ( aa.attribute10 IS NULL OR aa.attribute10 = '' ) 
                          ) c
              ON    a.item_id         = c.item_id 
              AND   a.scm_site_id     = c.from_site --20181016 추가
        WHERE  a.division_id = @p_division_id
        AND    a.plan_id     = @p_plan_id
        AND    a.plan_type   = @p_plan_type
        AND    a.plan_seq    = @p_plan_seq
        ;
		

        -----------------------------------------------------------
        -- 2-6. Cell 품목코드 [특성] 전/후로 분리 건 (2023.07.07) 
        -- cell_assy (CA1) : 특성 전 cell item 지칭 ( A~*** , A~001, A~002 사이트 존재)
        -- tco_assy  (CA2) : TCO Model의 경우에만 존재             ( A~002 사이트 존재 )
        -- cell_product(CP): 특성 후 cell item 지칭                ( A~002 , A~003 사이트 존재)  
        -----------------------------------------------------------

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 2-6 START';
        SET @v_description = N'2-6. CA, CP: PLANT Site 정리시작' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        --    Cell_Assy 사이트 정리 : 정의되지 않은 사이트를 삭제함.  
        DELETE  #SCM_MST_SITE_ITEM_ENG_FINAL
        FROM    #SCM_MST_SITE_ITEM_ENG_FINAL   A  WITH(NOLOCK)
                INNER JOIN (---/ CELL ASSY ITEM /--- 
                        SELECT  a.division_id , a.item_id , a.operation_group_id 
                        FROM    scm_mst_final_item_v   A  WITH(NOLOCK)
                        WHERE   A.division_id        = @p_division_id
                        AND     A.operation_group_id = 'A'   --~ cell item group 
                        AND     a.cell_type       LIKE 'CA%' --~ CA1, CA2 모두 대상
                        ) fi
                ON      1=1
                AND     fi.division_id = a.division_id
                AND     fi.item_id     = a.item_id  

                INNER JOIN scm_mst_site_eng b  WITH (NOLOCK)
                ON    a.modeling_id = b.modeling_id
                AND   a.plan_id     = b.plan_id 
                AND   a.plan_type   = b.plan_type 
                AND   a.plan_seq    = b.plan_seq
                AND   a.division_id = b.division_id
                AND   a.eng_scm_site_id = b.eng_scm_site_id
                AND   b.operation_group = 'A'     --~ CELL SITE 
                AND   b.site_type       = 'PLANT'
                AND   SUBSTRING(b.eng_scm_site_id, CHARINDEX('~',b.eng_scm_site_id), 4 )  IN ('~003' )  --~삭제대상 사이트.
                AND   ISNULL(b.osp_yn, 'N')  = 'N'  --외주 제외

        WHERE   a.modeling_id   = @p_modeling_id
        AND     a.plan_id       = @p_plan_id
        AND     a.plan_type     = @p_plan_type
        AND     a.plan_seq      = @p_plan_seq
        AND     a.division_id   = @p_division_id
        ; 
   
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 2-6-1 END';
        SET @v_description = N'2-6 1) Cell_Assy. PLANT Site 정리' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


        --   Cell_Product 사이트 정리 : 정의되지 않은 사이트를 삭제함.  
        DELETE  #SCM_MST_SITE_ITEM_ENG_FINAL
        FROM    #SCM_MST_SITE_ITEM_ENG_FINAL   A  WITH(NOLOCK)
                INNER JOIN (---/ CELL PRODUCT ITEM /---           
                        SELECT  a.division_id , a.item_id , a.operation_group_id 
                        FROM    scm_mst_final_item_v   a  with(nolock)
                        WHERE   a.division_id        = @p_division_id
                        AND     a.operation_group_id = 'A'
                        AND     a.cell_type         IN ('CP', 'CA2')   --~ cell_product, tco_assy 구분   
                        ) fi 
                ON      1=1
                AND     fi.division_id = a.division_id
                AND     fi.item_id     = a.item_id  

                INNER JOIN scm_mst_site_eng b  WITH (NOLOCK)
                ON    a.modeling_id = b.modeling_id
                AND   a.plan_id     = b.plan_id 
                AND   a.plan_type   = b.plan_type 
                AND   a.plan_seq    = b.plan_seq
                AND   a.division_id = b.division_id
                AND   a.eng_scm_site_id = b.eng_scm_site_id
                AND   b.operation_group = 'A'      --~ CELL SITE 
                AND   b.site_type       = 'PLANT'
                AND   SUBSTRING(b.eng_scm_site_id, CHARINDEX('~',b.eng_scm_site_id), 4 ) IN ( '~***' , '~001' ) --~삭제대상 사이트.
                AND   ISNULL(b.osp_yn, 'N')  = 'N'  --외주 제외

        WHERE   a.modeling_id   = @p_modeling_id
        AND     a.plan_id       = @p_plan_id
        AND     a.plan_type     = @p_plan_type
        AND     a.plan_seq      = @p_plan_seq
        AND     a.division_id   = @p_division_id                    
        ; 
        
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 2-6-2 END ';
        SET @v_description = N'2-6 2) Cell_Product PLANT Site 정리' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;



        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = N'PART 2-7 START';
        SET @v_description = N'2-7. scm_mst_site_item_eng INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ----------------------------------------------------------- 
        -- 2-7). 최종 INSERT
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_IN_PRE_SET_SITE_ENG */ scm_mst_site_item_eng
		(     modeling_id, plan_id, plan_type, plan_seq
		 	, division_id, project_code, scm_site_id, eng_scm_site_id, site_description
		 	, item_id, item_name, currency
		 	, liability_period, sales_plan_adjust_yn, item_hrcy_id, priority, valid_yn, bpms_exist
		 	, created_by, creation_date, last_updated_by, last_update_date
		 	, attribute1, attribute2, attribute3, attribute4, attribute5
		 	, attribute6, attribute7, attribute8, attribute9, attribute10
		)
        SELECT modeling_id, plan_id, plan_type, plan_seq
		 	, division_id, project_code, scm_site_id, eng_scm_site_id, site_description
		 	, item_id, item_name, currency
		 	, liability_period, sales_plan_adjust_yn, item_hrcy_id, priority, valid_yn, bpms_exist
		 	, created_by, creation_date, last_updated_by, last_update_date
		 	, attribute1, attribute2, attribute3, attribute4, attribute5
		 	, attribute6, attribute7, attribute8, attribute9, attribute10
        FROM  #scm_mst_site_item_eng_final
        ;
		
        SET @n_log_count = @@ROWCOUNT;

        -----------------------------------------------------------
        -- 임시테이블 삭제
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#SCM_MST_SITE_ITEM_ENG_FINAL') IS NOT NULL
        BEGIN 
            DROP TABLE #SCM_MST_SITE_ITEM_ENG_FINAL
        END
		
        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        -- TXN LOG
        SET @v_log_type = 'TXN';
        --SET @n_log_count = @@ROWCOUNT;
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
