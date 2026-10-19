
/*
 * Program ID   : PR_SCP_ENG_IN_PRE_SET_SITE_ENG
 * Description  : SDB의 Site/Site Item 정보에 대하여 현재 Plan에 사용할 현재 시점의 Snapshot 정보를 SDB에 적재되도록 한다.

                  1. site Shapshot 정보(scm_mst_site_eng)
                     1-1. PLANT Site 데이터생성
                           
                           -1) 전극(operation_group ='E')  일때 : 3개의 데이터 생성 후        => "eng_scm_site_id" 값을  1) scm_site_id + '~***', 2) scm_site_id + '~002', 3) scm_site_id + '~003' 형태로 생성함
                           -2) 셀(operation_group = 'A')   일때 : 동일한 4개의 데이터 생성 후 => "eng_scm_site_id" 값을  1) scm_site_id + '~***', 2) scm_site_id + '~001', 3) scm_site_id + '~002', 4)scm_site_id + '~003' 형태로 생성함
                           -3) 팩(operation_group = 'P')   일때 : 2개의 데이터 생성           => "eng_scm_site_id" 값을  1) scm_site_id + '~***', 2) scm_site_id + '~003' 형태로 생성함
                           
                           -예외사항)  scm_mst_site.osp_yn = 'Y' (외주팩, 외주셀 은 '~***'만존재함, 분리작업없음)

                     1-2. SALES Site : Demand, Intransit 정보가 존재하는 Site 데이터생성
                                       (20180720추가) ssp_anl_ship_confirm, scp_anl_shipment_plan_fix 정보에 존재하는 SALES site 데이터생성                                       

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
					                   - 2) '~***', '~001', '~002' : 일반 셀site 에 생성된, OSP-A 에 Assign된 TCO 셀 item 삭제  (20181016 변경,  OSP-A에 BOD 연결된 From Site에 대해서만 삭제)

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
 * 2018.06.07   KSG            Prod Frozen 조정
 * 2018.06.21   KSW            전극 제외 처리 
 * 2018.07.17   KSW            팩분리(~***, ~003) 적용관련 수정
 * 2018.07.20   KSW            ssp_anl_ship_confirm, scp_anl_shipment_plan_fix 정보에 존재하는 SALES site, SALES site item 데이터생성
 * 2018.08.07   KSW            외주셀(TCO 셀) 적용관련 수정
 * 2018.08.22   KSW            외주셀러, 외주팩커 분리작업 제외처리(외주셀/팩 : *** 만 생성, 외주셀:001, 002, 003, 외주팩:001 분리제외시킴)
 * 2018.08.23   KSW            scm_mst_site_item_eng 테이블 '~***', '~001' 일반 셀site 에 생성된  TCO 셀 item 삭제  
 * 2018.10.16   KSW            OSP-A에 BOD 연결된 From Site에 대해서만 item 삭제로 변경 (참고)주석2-5 
 * 2018.10.29   KSW            1) #scm_mst_site_item_eng_final 임시테이블 생성 (참고)주석2 
                               2) scm_mst_site_item_eng 테이블 임시테이블(#scm_mst_site_item_eng_final)로 변경 (참고)주석2 전체
                               3) 최종 scm_mst_site_item_eng  INSERT부분 추가 (참고)주석2-6
 * 2020.02.06   KSG            [OSP Line Plan] Attribute1 정보 추가
 * 2020.08.12   KSG            [Packer Visivility] : SCS Packer 대상 Site 정보 추가
 * 2021.05.18   KKC            [PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선] : SEMI 확정계획 누락 대상 Site Item 정보 추가
 * 2021.08.25   KKC            [PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선] : scp_mst_bod_v 변경 (scp_mst_bod_v -> scp_mst_bod_n_v)
 * 2021.10.13   KSG            [PJ20214907] LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 : AS
 * 2021.11.03   KKC            [PJ20214997] LGES SCP 신규 Biz, 공정 추가에 따른 모델링 개선 : DC Link Biz(외주Pack -> 외주Pack) 추가
 * 2022.01.06   KSG            PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 : 소형 OSP Pack Item 처리
 * 2022.04.04   LHS            PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선: JV사업부 추가: 사업부 조건별 로직구현시 division_id 대신 속성값(attribute3) 기준으로 변경
                                ----------------------------------------------------------------
                                        구분                         자동차           전극
                                ==============================    =============   ==============
                                  division_group(attribute3)  :        81              EE                
                                ------------------------------    -------------   --------------
                                  division_id                 :     81 , 81_UC      EE , EE_UC  
                                ----------------------------------------------------------------
 * 2023.03.13   KKC            PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행: 신규 DIVISION 공통화 및 불필요한 조건 정리 
 * 2023.07.07   LHS            PJ20230691   SCM 역량 강화 위한 SCP 개선과제 이행: n-ERP 활성화 코드 분리: CELL TYPE 별 유효 SITE정의.
 * 2024.10.07   KKC            PJ20249346   LGES SCP 개선과제 이행 : 자동차 해외법인 통합FP 52주 Daily 생산/출하계획 동기화
                               1. 52주 통합fp 출하계획 동기화 frozen 추가(scm_mst_site_eng.attr03/attr04/attr07/attr08) 
                               2. ssp 동기화 테이블 변경 (ssp_anl_ship_confirm -> scm_dnm_ssp_plan_v)
 * 2026.03.30   YMH            E20260327-001884 ess사업부 scm_mst_site_item_eng 기준정보 추가 
 * 2026.04.17   YMH            E20260415-000945 ESS 대치코드 반제품 출하계획 입력 시 계획 사라지는 현상
 * 2026.05.15   kimcd          [PJ2026-50273] MI ESS LINK 공장 SCM(SCP/FP/PSCM ) 대응. from, to에서 사내 LINK 제품 유형 출하 가능하도록 수정
 */

CREATE PROCEDURE [dbo].[PR_SCP_ENG_IN_PRE_SET_SITE_ENG]   
    ( @p_plan_cycle1  NVARCHAR(150)
    , @p_plan_name1   NVARCHAR(4000)
    , @p_plan_id1     NVARCHAR(4000)
    , @p_modeling_id1 NVARCHAR(4000)
    , @p_plan_seq1    NVARCHAR(4000)
    , @p_plan_type1   NVARCHAR(4000)
    , @p_master_id1   NVARCHAR(4000)
    , @p_division_id1 NVARCHAR(30)
    , @p_engine_plan_id1 NVARCHAR(4000)
    -- , @p_debug       INT OUTPUT
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

    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_IN_PRE_SET_SITE_ENG';
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

	--2021/05/18 추가, By KKC
    DECLARE @v_pre_plan_start_yyyymmdd NVARCHAR(8);    --plan_name
    DECLARE @v_pre_plan_type           NVARCHAR(50);   --plan_type
    DECLARE @n_pre_plan_seq            INTEGER;        --plan_seq
    DECLARE @v_pre_plan_id             NVARCHAR(4000); --plan_id
    
    DECLARE @v_division_group   NVARCHAR(30);   ---(2022.04.04) 추가. 
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
        -----------------------------------------------------------
        -- 0.변수설정 추가, 2021/05/18 추가, By KKC
        -----------------------------------------------------------
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
                AND    a.plan_name   >= CONVERT(CHAR(8), DATEADD(DD, -7 * 4, @p_plan_name), 112) --//4주내의 과거 Confirm  계획버전 조회
                AND    a.plan_name   <  @p_plan_name
            ) x 
        WHERE x.row_num = 1
		;
				
		SELECT @v_pre_plan_type = a.plan_type
             , @n_pre_plan_seq  = a.plan_seq
        FROM   (
                SELECT plan_type, plan_seq
                     , ROW_NUMBER() OVER (ORDER BY CASE WHEN plan_type = 'FN' THEN 1
                                                        WHEN plan_type = 'SE' THEN 2
                                                        WHEN plan_type = 'MA' THEN 3
                                                        WHEN plan_type = 'PR' THEN 4
                                                        ELSE 9   
														-- 주의 ELSE 처리안하면 TE, TM 가장최근에 실행되었으면  TE, TM이 NULL로 처리되어서 첫번째로 조회될수 있음)  ('TE' : 시뮬레이션용 'PR'과 동일하게 처리됨, 'TM': 시뮬레이션용 'MA'동일하게 처리됨) 
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
        -- 1.Site ENG
        -----------------------------------------------------------
        DELETE /* PR_SCP_ENG_IN_PRE_SET_SITE_ENG */
        FROM  scm_mst_site_eng
        WHERE 1=1
        AND   plan_id     = @p_plan_id
        AND   modeling_id = @p_modeling_id
        AND   plan_type   = @p_plan_type
        AND   plan_seq    = @p_plan_seq
        ;
		
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 1-1 START';
        SET @v_description = '1-1. PLANT Site  INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        
       -----------------------------------------------------------
        -- 1-1). PLANT Site
        -----------------------------------------------------------
        --  1) 전극(operation_group ='E')  일때 : 3개의 데이터 생성 후        => "eng_scm_site_id" 값을  1) scm_site_id + '~***', 2) scm_site_id + '~002', 3) scm_site_id + '~003'형태로 생성함
        --  2) 셀(operation_group = 'A')   일때 : 동일한 4개의 데이터 생성 후 => "eng_scm_site_id" 값을  1) scm_site_id + '~***', 2) scm_site_id + '~001', 3) scm_site_id + '~002', 4) scm_site_id + '~003' 형태로 생성함
        --  3) 팩(operation_group = 'P')   일때 : 2개의 데이터 생성           => "eng_scm_site_id" 값을  1) scm_site_id + '~***', 2) scm_site_id + '~003' 형태로 생성함
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_IN_PRE_SET_SITE_ENG */ scm_mst_site_eng
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
             , ship_frozen -- 20210224 특정한 상황에서 BOD Item별 확정 구간 설정은 BOD Item Eng 에 생성하여 BOD의 Fixed Term으로 연계함
			 -- 2018.06.07 PRE 의 Prod Frozen은 화면 설정값 - 7 로 처리함
             , CASE WHEN operation_group = 'E' AND b.gubun = 1 AND prod_frozen <  7 THEN 0
                    WHEN operation_group = 'E' AND b.gubun = 1 AND prod_frozen >= 7 THEN prod_frozen-7
                    WHEN operation_group = 'E' AND b.gubun = 2                      THEN 0
                    WHEN operation_group = 'E' AND b.gubun = 3                      THEN 0                                       
                    WHEN operation_group = 'A' AND b.gubun = 1 AND prod_frozen <  7  THEN 0    
                    WHEN operation_group = 'A' AND b.gubun = 1 AND prod_frozen >= 7  THEN prod_frozen-7
                    WHEN operation_group = 'A' AND b.gubun = 2                       THEN 0
                    WHEN operation_group = 'A' AND b.gubun = 3                       THEN 0
                    WHEN operation_group = 'A' AND b.gubun = 4                       THEN 0                    
                    -- 20180717 수정 팩 site 분리(~***, ~003)
                    WHEN operation_group = 'P' AND b.gubun = 1 AND prod_frozen <  7 THEN 0
                    WHEN operation_group = 'P' AND b.gubun = 1 AND prod_frozen >= 7 THEN prod_frozen-7
                    WHEN operation_group = 'P' AND b.gubun = 2                      THEN 0
               END AS prod_frozen 
             , end_customer
			 -- 2018.06.07 PRE 의 fp_plan_period은 화면 설정값 - 7 로 처리함
             , CASE WHEN fp_plan_period <  7 THEN 0
                    WHEN fp_plan_period >= 7 THEN fp_plan_period - 7
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
             , a.ship_frozen                           AS attribute3
             , CASE WHEN a.attribute7 = 'Y' AND a.attribute8 > 0 THEN a.attribute8
                    ELSE NULL
                END                                    AS attribute4 
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
        INSERT INTO /* PR_SCP_ENG_IN_PRE_SET_SITE_ENG */ scm_mst_site_eng
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
             , 'N' AS attribute1 -- 20200203 [OSP Line Plan] Sales Site는 'N'
             , 'N' AS attribute2 -- 20200812 [Packer Visivility] Sales Site는 'N'
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
                FROM scp_eng_intransitshpmnt_i_sn WITH (NOLOCK)
               WHERE modeling_id = @p_modeling_id
                 AND plan_id     = @p_plan_id
                 AND plan_type   = @p_plan_type
                 AND plan_seq    = @p_plan_seq
                 AND division_id = @p_division_id
                 AND result_date = @v_cutoff_day                
               -- 20180720 추가   ssp_anl_ship_confirm, scp_anl_shipment_plan_fix 정보에 존재하는 SALES site 데이터생성
			   -- 20211013 [PJ20214907] AS : SSP의 'AS(WH-In 용) Plant Plan' 을 'AS(WH-In 용) Sales Plan' 으로 전환
               UNION -- 확정 SP
               /* 2024.10.07 ssp 기준 테이블 변경 :  ssp_anl_ship_confirm -> scm_dnm_ssp_plan_v */
              SELECT DISTINCT to_site AS scm_site, to_site + '~' + incoterms  AS site                         
                FROM scm_dnm_ssp_plan_v WITH (NOLOCK)  --//기존:ssp_anl_ship_confirm, 2024.10.07 변경
               WHERE division_id  = @p_division_id  
                 AND qty          > 0
                 AND yyyymmdd     >= @p_plan_name
              -- AND change_type  = 'C'     -- 20180716 추가   
                 AND ssp_type     = 'CFM'   -- 2024.10.07 변경 
               UNION -- 확정 SP (AS_SITE_PLANT)
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
               FROM   scp_anl_shipment_plan_fix WITH (NOLOCK)
               WHERE  division_id         =  @p_division_id  
               AND    qty                 >  0
               AND    yyyymmdd            >= @p_plan_name
               AND    incoterms           IS NOT NULL
              ) d  
        WHERE s.division_id = @p_division_id
         AND  s.site_type   = 'SALES'
         AND  s.valid_yn    = 'Y'
         AND  s.scm_site_id = d.scm_site
        ; 

        -----------------------------------------------------------
        -- 2.Site Item ENG
        -----------------------------------------------------------
        DELETE /* PR_SCP_ENG_IN_PRE_SET_SITE_ENG */
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
		INSERT INTO /* PR_SCP_ENG_IN_PRE_SET_SITE_ENG */ #SCM_MST_SITE_ITEM_ENG_FINAL
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
               -- 20180720 추가   ssp_anl_ship_confirm, scp_anl_shipment_plan_fix 정보에 존재하는 SALES site 데이터생성
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
                 ON  s.division_id = fi.division_id
                AND  s.item_id     = fi.item_id 
                AND  @v_division_group = '40'  --(2022.04.04) JV사업부 추가: division_id -> v_division_group 으로 변경                           
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
               SELECT DISTINCT s.to_site AS scm_site, s.to_site + '~' + s.incoterms  AS site
                             , s.item_id AS item  
               FROM   ssp_anl_ship_plan_all s WITH (NOLOCK)                   
               WHERE  s.division_id          =  @p_division_id    
               AND    @v_division_group      = '82' -- ESS 만 대상, 2022.04.04 JV사업부 추가:division_id -> v_division_group 으로 변경
               AND    s.shipment_confirm_qty >  0
               AND    s.yyyymmdd             >= @p_plan_name
               UNION
               SELECT DISTINCT md.segment1 AS scm_site
                             , md.segment1 + '~' + 'DAP'  AS site
                             , s.item_id AS item  
               FROM   ssp_anl_ship_plan_all s WITH (NOLOCK)
                      INNER JOIN scm_adm_lookup_master_detail md WITH(NOLOCK)
                      ON   s.division_id  = md.segment3
                      AND  s.to_site      = md.segment2
                      AND  md.lookup_type = 'AS_SITE_PLANT'
                      AND  md.valid_yn    = 'Y'           
                WHERE  s.division_id          =  @p_division_id 
                AND    @v_division_group      = '82' -- ESS 만 대상, 2022.04.04 JV사업부 추가: division_id -> v_division_group 으로 변경
                AND    s.shipment_confirm_qty >  0
                AND    s.yyyymmdd             >= @p_plan_name
               UNION 
               SELECT DISTINCT to_site AS scm_site, to_site + '~' + incoterms  AS site, item_id AS item 
               FROM   scp_anl_shipment_plan_fix WITH (NOLOCK)
               WHERE  division_id         =  @p_division_id  
               AND    qty                 >  0
               AND    yyyymmdd            >= @p_plan_name
               AND    incoterms           IS NOT NULL
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
		INSERT INTO /* PR_SCP_ENG_IN_PRE_SET_SITE_ENG */ #SCM_MST_SITE_ITEM_ENG_FINAL
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
        SET @v_description = '2-3-1. PLANT Site Cell Item INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

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
                        AND   a.eng_scm_site_id = b.eng_scm_site_id
                        AND   b.operation_group = 'P' --AND   b.operation_group IN ( 'A', 'P')                         
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
                                            AND   b.operation_group IN (  'A', 'P' ) -- 2026.05.15 kimcd [PJ2026-50273] MI ESS LINK 공장 SCM(SCP/FP/PSCM ) 대응. from, to에서 사내 LINK, Pack 공정군 제품 유형 출하 가능하도록 'P' 공정 추가
                                            AND   b.site_type = 'PLANT'
                                            AND   b.eng_scm_site_id = b.scm_site_id + '~***' 
                                            AND   EXISTS (  SELECT 1     /* 2023.07.07 cell code분리건: cell_product코드가 나오게 하기 위해서 */ 
                                                            FROM    scm_mst_final_item_v   fi  WITH(NOLOCK) 
                                                            WHERE   fi.DIVISION_ID =  @p_division_id    
                                                            and     fi.cell_type  NOT LIKE 'CA%' -- = 'CP' -- 2026.05.15 kimcd [PJ2026-50273] MI ESS LINK 공장 SCM(SCP/FP/PSCM ) 대응. Pack 제품 포함하기 위해 조건 수정
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
		-- 2021/05/18 SEMI 반제품 이동 공정 개선, By KKC (자동차 사업부만 적용)
        -----------------------------------------------------------
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = N'PART 2-3-2 START';
        SET @v_description = '2-3-2. PLANT Site Cell Item INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

       	/* JV 공통화 및 조건 정리, 2023.03.13 
	       자동차만 수행
		*/
        IF @v_division_group = '81' OR @v_division_group = '82' -- E20260327-001884 ess사업부 scm_mst_site_item_eng 기준정보 추가 
		
		BEGIN

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
				   WHERE division_id = @p_division_id      --//Original Division별로 관리됨, 2023.03.10 주석 추가
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
				 WHERE a.division_id     =  @p_division_id -- 2022.04.04 조건추가 
				   AND a.qty             >  0
				   AND a.yyyymmdd        >= @p_plan_name
                   -- E20260415-000945 ESS 대치코드 반제품 출하계획 입력 시 계획 사라지는 현상 기존 소스 주석
                   -- AND a.from_site     LIKE '%-A'
                   -- E20260415-000945 ESS 대치코드 반제품 출하계획 입력 시 계획 사라지는 현상
				   AND (a.from_site     LIKE '%-A' OR a.from_site LIKE '%-P')
				   AND a.to_site       LIKE '%-P' 
				   AND NOT EXISTS (SELECT 'X'
									 FROM #SCM_MST_SITE_ITEM_ENG_FINAL x(NOLOCK)
									WHERE x.item_id = a.item_id
									  AND x.scm_site_id = a.to_site)
				UNION 
				/* SEMI 출하 amend 계획 */
				SELECT a.to_site
					 , a.item_id
				  FROM scp_anl_shipment_plan_semi a WITH (NOLOCK)  
				 WHERE a.division_id         = @p_division_id       -- 2022.04.04 조건추가 
				   AND a.plan_start_yyyymmdd = @v_pre_plan_start_yyyymmdd
				   AND a.plan_type           = @v_pre_plan_type 
				   AND a.seq                 = @n_pre_plan_seq 
				   AND a.measure             = 'SHIP_PLAN_AMEND'
				   AND a.qty                 > 0
				   AND a.yyyymmdd            >= @p_plan_name
                   -- E20260415-000945 ESS 대치코드 반제품 출하계획 입력 시 계획 사라지는 현상 기존 소스 주석
                   -- AND a.from_site     LIKE '%-A'
                   -- E20260415-000945 ESS 대치코드 반제품 출하계획 입력 시 계획 사라지는 현상
				   AND (a.from_site     LIKE '%-A' OR a.from_site LIKE '%-P')
				   AND a.to_site           LIKE '%-P'
				   AND NOT EXISTS (SELECT 'X'
									 FROM #SCM_MST_SITE_ITEM_ENG_FINAL x(NOLOCK)
									WHERE x.item_id = a.item_id
									  AND x.scm_site_id = a.to_site) 
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
                   -- E20260415-000945 ESS 대치코드 반제품 출하계획 입력 시 계획 사라지는 현상 기존 소스 주석
                   -- AND a.from_site     LIKE '%-A'
                   -- E20260415-000945 ESS 대치코드 반제품 출하계획 입력 시 계획 사라지는 현상
				   AND (a.from_site     LIKE '%-A' OR a.from_site LIKE '%-P')
				   AND a.to_site      LIKE '%-P'
				   AND NOT EXISTS (SELECT 'X'
									 FROM #SCM_MST_SITE_ITEM_ENG_FINAL x(NOLOCK)
									WHERE x.item_id = a.item_id
									  AND x.scm_site_id = a.to_site
                                  ) 
				UNION
				/* SSP 출하 계획 (ESS Ship Req) */
				SELECT a.to_site
					 , a.item_id 
				  FROM ssp_anl_ship_plan_all a WITH (NOLOCK)
				 WHERE a.division_id         =  @p_division_id      -- 2022.04.04 조건추가   
				   AND a.yyyymmdd            >= @p_plan_name
                   -- E20260415-000945 ESS 대치코드 반제품 출하계획 입력 시 계획 사라지는 현상 기존 소스 주석
                   -- AND a.from_site     LIKE '%-A'
                   -- E20260415-000945 ESS 대치코드 반제품 출하계획 입력 시 계획 사라지는 현상
				   AND (a.from_site         LIKE '%-A' OR a.from_site LIKE '%-P')
				   AND a.to_site            LIKE '%-P'
				   AND a.shipment_confirm_qty  > 0  
				   AND NOT EXISTS (SELECT 'X'
									 FROM #SCM_MST_SITE_ITEM_ENG_FINAL x(NOLOCK)
									WHERE x.item_id = a.item_id
									  AND x.scm_site_id = a.to_site)
				) a 
				, scm_mst_site_eng b WITH (NOLOCK)   
			WHERE b.division_id     = @p_division_id
			  AND b.modeling_id = @p_modeling_id
			  AND b.plan_id     = @p_plan_id
			  AND b.plan_type   = @p_plan_type
			  AND b.plan_seq    = @p_plan_seq
			  AND b.scm_site_id = a.to_site
			  AND b.eng_scm_site_id = b.scm_site_id+'~***'
			  /* 중복에러가 나지 않게 한번 더 Check */
			  AND NOT EXISTS ( SELECT 'X'
								 FROM #SCM_MST_SITE_ITEM_ENG_FINAL  WITH (NOLOCK)
								WHERE eng_scm_site_id   = b.eng_scm_site_id  
								  AND item_id           = a.item_id
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
        --~외주cell_site 품목의 자품목(사내)을 외주cell_site에 추가.
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
		--[PJ20214997] LGES SCP 신규 Biz, 공정 추가에 따른 모델링 개선
		-- 2021.11.03, JOBIL(DC LINK) BIZ Pack Site Item 추가
        -----------------------------------------------------------
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = N'PART 2-5 START';
        SET @v_description = N'2-5. PLANT Site : 외주PACK SITE ITEM에 존재하지 않는 PACK SITE ITEM 정보 추가' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

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
			   @p_modeling_id
			 , @p_plan_id
			 , @p_plan_type
			 , @p_plan_seq
			 , @p_division_id
			 , a.project_code
			 , a.scm_site_id
			 , a.eng_scm_site_id
			 , a.site_description
			 , b.child_item_id     --~Pack Site내 pack 자품목
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
        --~{Cell 사내~003 外 --> 외주 cell site}인 경우 from_site , item_id를 삭제하는 로직. => 외주cell 품목은 사내생산 사이트가 없어지게 됨. 
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
                                   --INNER JOIN scp_mst_bod_v cc WITH (NOLOCK)
                                   INNER JOIN scp_mst_bod_n_v cc WITH (NOLOCK) ----2021.08.25 기간별 view로 변경(scp_mst_bod_v -> scp_mst_bod_n_v)
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
                            AND   ( aa.attribute10 IS NULL OR aa.attribute10 = '' ) --~위 로직에서 case 미정의.
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

        --  Cell_Assy 사이트 정리 : 정의되지 않은 사이트를 삭제함.  
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

        --  Cell_Product 사이트 정리 : 정의되지 않은 사이트를 삭제함.  
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

        /* 20180621 주석처리함( 전극과 셀사이 연결필요 없으므로)
        
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 2-4 START';
        SET @v_description = '2-4. PLANT Site Elec Item INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
        --2-5. PLANT Site : 셀 SITE iTEM에 존재하지 않는 전극 SITE ITEM 정보추가
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_IN_PRE_SET_SITE_ENG */ scm_mst_site_item_eng
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
        */
        -----------------------------------------------------------

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
