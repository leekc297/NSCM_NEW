
/*
 * Program ID   : PR_SCP_ENG_IN_FN_PROC_FIXED_PLAN_PROD
 * Description  : 확정 생산 정보
                  
                  -------------------------------------------------------------
                  --1. (자동차/ESS 'MA'만 처리) 확정 생산 계획  정보 Insert
                       - DIVISION_ID IN ('81', '82') AND PLAN_TYPE = 'MA'일때만 실행 : 참조테이블 : scp_anl_production_plan
                       - 20200713 C20200702-000043 FN 추가
                       -   . 구간 : Prod Frozen 기준
                       -       1) 364 인 경우 PET까지(플랜시작일~플랜종료일) 대상
                       -       2) 364 가 아닌 경우 : prod_frozen 까지 
                  -------------------------------------------------------------                    
                        -  1-1)  Capa공정이면서 Line 모델링 비대상
                                 - 참조 테이블 : scp_anl_production_plan (이전PLAN_TYPE 데이터사용)                            
                        -  1-2)  Capa공정이면서 Line 모델링 대상
                                 - 참조 테이블 : scp_anl_production_plan (이전PLAN_TYPE 데이터사용)                   
                        -  1-3)  OSP
                                 - 참조 테이블 : scp_anl_production_plan (이전PLAN_TYPE 데이터사용)                  
                        -  1-4)  OSP_L :    
                                 - 참조 테이블 : scp_anl_production_plan (이전PLAN_TYPE 데이터사용)

                  -------------------------------------------------------------
                  --2. (자동차/ESS 'SE','FN'만 처리) 확정 생산 계획  정보 Insert
                       - DIVISION_ID IN ('81', '82') AND PLAN_TYPE IN ('SE', 'FN') 일때만 실행 : 참조테이블 : scm_dnm_frozen_v / scp_anl_production_plan
                       - 20200713 C20200702-000043 FN 제외
                       -   . 구간 : Prod Frozen 기준
                       -       1) 364 인 경우 PET까지(플랜시작일~플랜종료일) 대상
                       -       2) 364 가 아닌 경우 : prod_frozen 까지 
                  -------------------------------------------------------------                    
                    -  2-1) FP 비대상 ( 외주 packer  일때 FP 비대상, 전구간(scp_anl_production_plan) 대상)
                            -2-1-1)  Capa공정이면서 Line 모델링 비대상 (전구간 : 플랜시작일~플랜종료일)
                                     - 참조 테이블 : scp_anl_production_plan(이전PLAN_TYPE 데이터사용) 
                            -2-1-2) [OSP Line Plan] OSP_L Line Capa 대상 (전구간 : 플랜시작일~플랜종료일)
                                     - 참조 테이블 : scp_anl_production_plan(이전PLAN_TYPE 데이터사용) 

                   -   2-2) FP 대상 ( 구간별 처리)                         
                            - 2-2-1) Capa공정이면서 Line 모델링 비대상 (FP_PLAN_LOAD 구간 이후)
                                     - 참조 테이블 : scp_anl_production_plan(이전PLAN_TYPE 데이터사용) 
                            - 2-2-2) Capa공정이면서 Line 모델링 대상   (FP_PLAN_LOAD 구간 이후)
                                     - 참조 테이블 : scp_anl_production_plan(이전PLAN_TYPE 데이터사용) 
                            - 2-2-3) Capa공정이면서 Line 모델링 비대상 (FP_PLAN_LOAD 구간)
                                     - 참조 테이블 : scm_dnm_frozen_v
                            - 2-2-4) Capa공정이면서 Line 모델링 대상   (FP_PLAN_LOAD 구간)
                                     - 참조 테이블 : scm_dnm_frozen_v  

                  -------------------------------------------------------------
                  --3. (소형 'MA', 'SE', 'FN' 만 처리) 확정 생산 계획  정보 Insert 
                      - DIVISION_ID IN ('40') AND PLAN_TYPE IN ('MA', 'TM', 'SE', 'FN') 일때만 실행
                      - 구간 1 : 플랜시작일 ~ (플랜시작일+prod_frozen),   참조테이블 : scp_anl_production_plan
                  -------------------------------------------------------------                    
                        -  3-1)  Capa공정이면서 Line 모델링 비대상 (소형(40)일때: 플랜시작일 ~ (플랜시작일+prod_frozen)  )
                                 - 참조 테이블 : scp_anl_production_plan (이전PLAN_TYPE 데이터사용) 
                        
                        -  3-2)  Capa공정이면서 Line 모델링 대상 (소형(40)일때: 플랜시작일 ~ (플랜시작일+prod_frozen)  )
                                 - 참조 테이블 : scp_anl_production_plan (이전PLAN_TYPE 데이터사용)
                        
                        -  3-3)  OSP (소형(40)일때: 플랜시작일 ~ (플랜시작일+prod_frozen)  )
                                 - 참조 테이블 : scp_anl_production_plan (이전PLAN_TYPE 데이터사용)
                        
                        -  3-4)  [OSP Line Plan] OSP_L Line Capa 대상 (소형(40)일때: 플랜시작일 ~ (플랜시작일+prod_frozen)  )
                                 - 참조 테이블 : scp_anl_production_plan (이전PLAN_TYPE 데이터사용)
                  
                  -------------------------------------------------------------
                  --4. FIX 정보 공통적용 
                      - 구간 : 플랜시작일+prod_frozen 이후,  참조테이블 : scp_anl_production_plan_fix
                  -------------------------------------------------------------
                        -  4-1)  Capa공정이면서 Line 모델링 비대상 (소형(40)일때: :"플랜시작일+3개월의 말일(플랜시작일+prod_frozen)" 이후기간 )
                                 - 참조 테이블 : scp_anl_production_plan_fix

                        -  4-2)  Capa공정이면서 Line 모델링 대상 (소형(40)일때: :"플랜시작일+3개월의 말일(플랜시작일+prod_frozen)" 이후기간 )
                                 - 참조 테이블 : scp_anl_production_plan_fix
								 
                        -  4-3)  OSP (소형(40)일때: :"플랜시작일+3개월의 말일(플랜시작일+prod_frozen)" 이후기간 )
                                 - 참조 테이블 : scp_anl_production_plan_fix
								 
                        -  4-4)  [OSP Line Plan] OSP_L Line Capa 대상 (소형(40)일때: :"플랜시작일+3개월의 말일(플랜시작일+prod_frozen)" 이후기간 )
                                 - 참조 테이블 : scp_anl_production_plan_fix

                  -------------------------------------------------------------
                  --5. MA, SE, FN  공통적용 
                  -------------------------------------------------------------
                       -5-1)  operation_qty 값에 수율 적용
                          -- [th_eng_fixed_plan_sn.operation_qty] = [CEILING(th_eng_fixed_plan_sn.complete_qty / th_eng_op_res_group_map_sn.yield)]  올림값을 셋팅
        
 * OutTable     : TH_ENG_FIXED_PLAN
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.02.22   김성기         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.06.01   김성기         BOM 정보 처리 수정
 * 2018.06.08   김성기         Work Order Seq Update 반영
 * 2018.06.18   KSW            FN처리를 SE처리와 동일하게 변경(SE처리조건에 FN추가)
 * 2018.07.05   KSG            CELL Biz Fix용 가상 BOD 형성
 * 2018.09.05   KSW            OPERATION_QTY 값에 수율 적용 (참고)주석4-1)
 * 2018.11.15   KSW            plan_type = 'TM' (시뮬레이션용으로 'MA'와 동일하게 처리됨) (참고)주석1
 * 2018.11.30   KSW            속도개선 (INNER JOIN시 HASH 힌트 적용)
 * 2019.02.11   KSW            소형(40)이면서 plan_type IN ('SE', 'FN') 일때 기존 MA처럼(scp_anl_production_plan 전구간) 실행되게 변경함 (참고)주석1, 주석2 
 * 2019.06.04   KSW            소형(40)일때 확정구간 변경 ( 기존 "전구간(플랜시작일~플랜종료일)" => "플랜시작일 ~ (플랜시작일+ prod_frozen)" 으로 변경)  참고)주석1-1, 주석1-2, 주석1-3
                               1) 소형(40) 처리부분 (ELSE IF문으로 분리)별도분리처리 추가 참고)주석3-1-1, 주석3-1-2, 주석3-2-1, 주석3-2-2, 주석3-3-1, 주석3-3-2
                               2) FIX 데이터처리부분 추가("플랜시작일+3개월의 말일 이후일자" 처리) 참고) 주석3-1-2, 주석3-2-2, 주석3-3-2
 * 2020.02.06   KSG            [OSP Line Plan] OSP이면서 Line별 Capa 적용 Site 확정 계획 추가
 * 2020.03.23   KSG            C20200304-000426 ESS 시뮬레이터 버전별 52주 Rolling 요청 건
 * 2020.07.13   KSG            C20200702-000043 [SCM PI] GSCM Weekly Timeline 변경 건 : FN 일때 FP 정보 사용하는 IF를 MA와 같이 이전 Plan 타도록 수정
 * 2020.08.12   KSG            [Packer Visivility] OSP : SCS 대상 여부에 따른 로직 분기
                                  현재 MA/FN 에서는 모두 이전 Plan의 생산계획 정보 사용하고, SE는 수행하지 않으므로 FN용은 로직 수정은 하지 않음
								  => 향후 변경 시 로직 처리해야함
 * 2021.05.18   SEO            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 : 중장기 계획
 * 2021.05.26   KKC            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 : TM버전에 대해서는 FIX 데이터 미생성
 * 2022.04.04   LHS            PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선: JV사업부 추가: 사업부 조건별 로직구현시 division_id 대신 속성값(attribute3) 기준으로 변경
                                ----------------------------------------------------------------
                                        구분                         자동차           전극
                                ==============================    =============   ==============
                                  division_group(attribute3)  :        81              EE                
                                ------------------------------    -------------   --------------
                                  division_id                 :     81 , 81_UC      EE , EE_UC  
                                ----------------------------------------------------------------
 * 2023.02.14   SHS            PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행: MA/SE 계획 추가 
                               1. SE Plan시 8주 FP확정계획 재동기화
							   2. 공통 사용 계획 Cutoff 테이블 생성(Hash Join 삭제 / 쿼리 속도 문제 개선)
 * 2023.02.23   SHS            PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행: FP 중복값 제거 조건 추가 
 * 2023.02.24   SHS            PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행: 소형은 MA에서 FP계획 재동기화
 * 2023.03.13   KKC            PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행: FP 동기화 테이블 변경
                               scm_dnm_plan_frozen_v → scm_dnm_week_plan_frozen_v(실적포함되지 않은 fp plan)                               
 * 2024.10.07   KKC            PJ20249346   LGES SCP 개선과제 이행 : 자동차 해외법인 통합FP 52주 Daily 생산/출하계획 동기화 및 튜닝
                               1. 관련 소스 정리 및 KEY값 중복 보완 (WORK_ORDER_ID)
                               2. 로직 분기 및 fp 동기화(scm_mst_site_eng.attr07 : 52주fp plant 적용여부 기준)
                                  1)52주 통합fp plant外 
                                    - scp amend 기준
                                  2)52주 통합fp plant (81/FN 限)
                                    - ~ fp period frozen(fp 테이블 : 실적+계획)
                                    - fp period frozen ~ prod period frozen (scp amend기준) 
                                  3)공통
                                    - 기존 로직 유지
 * 2024.11.26   KKC            PJ20249346   LGES SCP 개선과제 이행 : 소형 Semi Plan 추가

 * 2025.08.01	YMH				CSR : E20250724-001388 소형 SE 제거 , MA 에서 FP계획 -> SCP AMEND 로 변경
 * 2025.12.05   kimcd	       [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : JV 가상 라인에 연계된 라인의 경우 fix 계획 삭제
 *
 */
CREATE PROCEDURE  [dbo].[PR_SCP_ENG_IN_FN_PROC_FIXED_PLAN_PROD]
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_IN_FN_PROC_FIXED_PLAN_PROD';
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
    DECLARE @v_cur_wednesday     NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'WED')), 112); -- 당주 수요일 YYYYMMDD
    DECLARE @d_plan_name         DATETIME    = CONVERT(DATETIME,@p_plan_name);
    DECLARE @v_pet_date          NVARCHAR(8) ; -- Plan End Date
	DECLARE @v_plan_horizon      INTEGER = 0;  -- Plan Horizon		--20201.05.18 중장기 계획

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
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN
	    
		SELECT @v_pet_date = p.horizon_end_date
			 , @v_plan_horizon = DATEDIFF(D,  CONVERT(DATE, plan_name), CONVERT(DATE, horizon_end_date) ) + 1		--20201.05.18 중장기 계획
        FROM   dbo.scm_mst_plan p WITH(NOLOCK)
        WHERE  p.division_id = @p_division_id 
        AND    p.plan_id     = @p_plan_id 
	    ;

		--공통 사용 데이터 Cutoff 생성. 2023.02.14
		IF OBJECT_ID('tempdb..#tmp_scp_anl_production_plan') IS NOT NULL
			BEGIN 
				DROP TABLE  #tmp_scp_anl_production_plan;          
			END 

		SELECT a.*
		  INTO #tmp_scp_anl_production_plan
		  FROM
			(
			--1. CAPA/ OSP
			SELECT a.division_id
				, a.plan_start_yyyymmdd
				, a.operation_group
				, a.scm_site_id
				, a.item_id
				, a.line_id
				, a.operation_id
				, a.yyyymmdd
				, a.qty
				, b.descr              AS eng_res_descr
				, b.site_id            AS eng_site_id
				, b.route_id           AS eng_route_id
				, b.resource_id        AS eng_resource_id
			FROM scp_anl_production_plan a WITH(NOLOCK)
			INNER JOIN 
				(
				SELECT SUBSTRING(r.resource_group_id, dbo.FN_CHARINDEX_REV(r.resource_group_id, '::', 0)+2, 100) AS line_id
					 , REPLACE(r.site_id, '~***', '') AS scm_site_id
					 , r.route_id
					 , r.resource_id
					 , r.descr
					 , r.site_id 
				 FROM th_eng_resource_sn r WITH(NOLOCK)
				WHERE r.master_id = @p_master_id
				  AND r.plan_id   = @p_engine_plan_id
				  AND r.descr     IN ('CAPA', 'OSP')
				) b
			   ON b.scm_site_id  = a.scm_site_id
			  AND b.route_id  LIKE a.operation_id + '%' 
			WHERE a.division_id         = @p_division_id  
			  AND a.plan_start_yyyymmdd = @p_plan_name 
			  AND a.plan_type           = @p_pre_plan_type 
			  AND a.seq                 = @p_pre_plan_seq 
			  AND a.measure             = 'PROD_PLAN_AMEND'
			  AND a.yyyymmdd            >= @p_plan_name
			  AND a.yyyymmdd            <= @v_pet_date
			  AND a.qty                 > 0
			UNION ALL
			--2. LINE_CAPA / OSP_L
			SELECT a.division_id
				, a.plan_start_yyyymmdd
				, a.operation_group
				, a.scm_site_id
				, a.item_id
				, a.line_id
				, a.operation_id
				, a.yyyymmdd
				, a.qty
				, b.descr              AS eng_res_descr
				, b.site_id            AS eng_site_id
				, b.route_id           AS eng_route_id
				, b.resource_id        AS eng_resource_id
			FROM scp_anl_production_plan a WITH(NOLOCK)
			INNER JOIN 
				(
				SELECT SUBSTRING(r.resource_group_id, dbo.FN_CHARINDEX_REV(r.resource_group_id, '::', 0)+2, 100) AS line_id
					 , REPLACE(r.site_id, '~***', '') AS scm_site_id
					 , r.route_id
					 , r.resource_id
					 , r.descr
					 , r.site_id 
				 FROM th_eng_resource_sn r WITH(NOLOCK)
				WHERE r.master_id = @p_master_id
				  AND r.plan_id   = @p_engine_plan_id
				  AND r.descr     IN ('LINE_CAPA', 'OSP_L')
				) b
			   ON b.scm_site_id  = a.scm_site_id
			  AND b.route_id     = a.operation_id
			  AND b.line_Id      = a.line_id 
			WHERE a.division_id         = @p_division_id  
			  AND a.plan_start_yyyymmdd = @p_plan_name 
			  AND a.plan_type           = @p_pre_plan_type 
			  AND a.seq                 = @p_pre_plan_seq 
			  AND a.measure             = 'PROD_PLAN_AMEND'
			  AND a.yyyymmdd            >= @p_plan_name
			  AND a.yyyymmdd            <= @v_pet_date
			  AND a.qty                 > 0
			) a
	    ;	  

        -----------------------------------------------------------
	    -- PR_SCP_ENG_IN_FN_PROC_FIXED_PLAN 에서 Delete 처리함        
        -----------------------------------------------------------

        /*
            -----------------------------------------------------  
            [WORK ORDER ID] 생성 채번 규칙 정리, 2024.10.07              
            -----------------------------------------------------  
            
            -----------------------------------------------------  
            [81/82 : MA/FN]&&[40 : FN]
            -----------------------------------------------------  
            WO::CAPA::+100000000
            WO::LINE_CAPA::+100000000
            WO::OSP::+100000000
            WO::OSP_L::+100000000
            -----------------------
            (신규)52주FP통합 PLANT
            --fp period 구간
            WO::LINE_CAPA::+600000000
            WO::CAPA::+500000000
            --fp period 구간이후
            WO::CAPA::+300000000
            WO::LINE_CAPA::+400000000

            -----------------------------------------------------  
            [81/82 : SE]&&[40 : MA]
            -----------------------------------------------------  
            [FP대상]
            --fp period 구간
            WO::LINE_CAPA::+600000000
            WO::CAPA::+500000000
            
            --fp period 구간이후
            WO::CAPA::+300000000
            WO::LINE_CAPA::+400000000
            
            [FP비대상]
            WO::OSP::+100000000
            WO::OSP_L::+100000000

            [공통]
            WO::CAPA_CFM:: +fix_id
            WO::LINE_CAPA_CFM:: +fix_id
            WO::OSP_CFM:: +fix_id
            WO::OSP_L_CFM:: +fix_id
        -----------------------------------------------------  
            */
        --20181115 수정 plan_type = 'TM'(시뮬레이션용으로 'MA'와 동일하게 처리됨)  (변경전 : IF @p_plan_type = 'MA')
        --20190211 수정 소형(40)이면서 plan_type IN ( 'SE', 'FN')일때도 실행되게 수정함 (변경전 : IF @p_plan_type IN ( 'MA', 'TM') )
        --20190604 수정 소형(40)이면서 plan_type IN ( 'MA', 'SE', 'FN') 일때 확정구간변경(기존 "전구간(플랜시작일~플랜종료일)" => "플랜시작일~ (플랜시작일 + prod_frozen)")
        --         수정 소형(40)부분   ELSE IF문으로 별도분리 
        --20200713 C20200702-000043 FN 추가
        /* 20200713 C20200702-000043 FN 추가
		   IF @p_division_id IN ('81', '82')  AND @p_plan_type IN ( 'MA', 'TM', 'FN')  */ 
        /* 20220404 JV건으로 수정함 
        IF @v_division_group IN ('81', '82')  AND @p_plan_type IN ( 'MA', 'TM', 'FN')  */ 
		/* 2023.02.14 소형도 공통으로 추가         
		--IF @v_division_group IN ('81', '82', '40')  AND @p_plan_type IN ( 'MA', 'TM', 'FN')  */
        /* 2023.02.24 소형은 FN만 해당 분기 공통으로 수행 */
        /* 2024.11.26 소형 SE 추가 */
		/* 2025.08.01 소형 SE -> MA로 변경 CSR : E20250724-001388 */
		IF (@v_division_group IN ('81', '82')  AND @p_plan_type IN ( 'MA', 'TM', 'FN'))
		OR (@v_division_group IN ('40') AND @p_plan_type IN ('MA', 'FN')) 
        BEGIN
                
                /**********************************************************
                1. 52fp통합 plant 대상外, 2024.10.07
                -- scp amend 기준으로 생성
                ***********************************************************/
                ----------------------------------------------------------
                --1-1) CAPA  공정(Line 모델링 비대상)
                ----------------------------------------------------------                  
                INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_FIXED_PLAN_PROD */ th_eng_fixed_plan_sn
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
                SELECT --DISTINCT  /* ROW_NUMBER 사용으로 불필요 2023.02.14 수정 */
                       @p_master_id           AS master_id
                     , @p_engine_plan_id      AS plan_id 
                     , 'WO::CAPA::' + CONVERT(NVARCHAR(10), 100000000 + ROW_NUMBER() OVER ( ORDER BY  YYYYMMDD )) AS work_order_id
                     , 1                      AS work_order_seq
                     , a.scm_site_id + '~***' AS site_id
                     , a.eng_route_id         AS route_id  -- res의 route id
                     , a.eng_route_id         AS operation_id
                     , a.item_id
                     , a.eng_resource_id      AS resource_id -- , b.route_id + '::' + a.scm_site_id + '~***' + '::' + '-' AS resource_id
                     , NULL                   AS sub_resource_id								              
                     , a.yyyymmdd             AS start_dttm
                     , a.yyyymmdd             AS end_dttm  --, DATEADD(d, 1, a.yyyymmdd) AS end_dttm
                     , a.qty                  AS operation_qty
                     , a.qty                  AS complete_qty
                     , 'WO::CAPA::' + CONVERT(NVARCHAR(10), 100000000 + ROW_NUMBER() OVER ( ORDER BY  YYYYMMDD )) AS lot_id
                     , 'N'                    AS is_fixed
                     , 'Y'                    AS is_prev_schedule
                     , 'START_FIX'            AS keep_work_time_type
                     , 'ALL_QTY_FIX'          AS keep_qty_type
                     , NULL                   AS sales_model_id
                     , NULL                   AS attribute_set_id
                     , NULL                   AS demand_id
                     , 'WO::CAPA'             AS descr
                     , 'Y'                    AS is_noh_consume        
                FROM   #tmp_scp_anl_production_plan a --속도문제로 Cutoff 테이블 사용. 2023.02.14
               INNER JOIN   ( SELECT a.scm_site_id
                                   , ISNULL(a.fp_plan_period, 0) AS fp_plan_period
                                   , ISNULL(a.prod_frozen, 0)    AS prod_frozen --20190604 추가  
                              FROM dbo.scm_mst_site_eng a WITH (NOLOCK)  
                             WHERE a.modeling_id     = @p_modeling_id
                               AND a.plan_id         = @p_plan_id
                               AND a.plan_type       = @p_plan_type
                               AND a.plan_seq        = @p_seq 
                               AND a.division_id     = @p_division_id
                               AND a.eng_scm_site_id = a.scm_site_id + '~***' 
                               AND ISNULL(a.osp_yn, 'N') = 'N'   --외주 packer 아님 
                               AND ISNULL(a.attribute7, 'N') = 'N'   --52주통합plant 적용 대상 제외, 2024.10.07 추가
                          ) c 
                  ON a.eng_res_descr = 'CAPA'
				 AND a.scm_site_id  = c.scm_site_id
                 AND a.yyyymmdd    >= @p_plan_name
				 AND a.yyyymmdd    <= CASE WHEN c.prod_frozen = @v_plan_horizon THEN @v_pet_date		--2021.05.18 중장기 계획					  
                                           ELSE CONVERT(NVARCHAR(8), DATEADD(DD, c.prod_frozen-1, @d_plan_name), 112) -- <= 조건이므로 (prod_frozen-1)처리
                                       END			  
			     -- 2018.06.01 ksg DISTINCT 처리
                 INNER JOIN   (SELECT DISTINCT SUBSTRING(bom.route_id, 1, 5) AS res_route_id
                                    , bom.site_id, bom.parent_item_id, bom.route_id
                               FROM   th_eng_plan_bom_sn bom WITH (NOLOCK)
                               WHERE  master_id = @p_master_id --'81::WEEKLY'
                               AND    plan_id   = @p_engine_plan_id
                              ) e
                  ON a.scm_site_id + '~***'  = e.site_id 
                 AND a.item_id               = e.parent_item_id  
                 AND a.eng_route_id          = e.route_id
                --OPTION (HASH JOIN) --20190211 추가 =>  HASH JOIN 제거 - 2023.02.14
                ;

                -- TXN LOG
                SET @n_log_count = @@ROWCOUNT;
                SET @v_log_type = 'TXN';
                SET @v_log_message = 'INSERTINTO '+@v_table_id;
                SET @v_description = N'1-1) CAPA  공정...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
                SET @d_event_date = SYSDATETIME();
                EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
                 
                ----------------------------------------------------------
                --1-2) Line 모델링 대상
                ----------------------------------------------------------
                INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_FIXED_PLAN_PROD */ th_eng_fixed_plan_sn
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
                SELECT --DISTINCT /* 불필요한 DISTINCT절 주석처리, 2023.02.14 */
                       @p_master_id           AS master_id
                     , @p_engine_plan_id      AS plan_id 
                     , 'WO::LINE_CAPA::' + CONVERT(NVARCHAR(10), 100000000 + ROW_NUMBER() OVER ( ORDER BY  YYYYMMDD )) AS work_order_id
                     , 1                      AS work_order_seq
                     , a.scm_site_id + '~***' AS site_id                     
                     , a.eng_route_id         AS route_id  --bom의 route id
                     , a.eng_route_id         AS operation_id
                     , a.item_id
                     , a.eng_resource_id      AS resource_id -- , b.route_id + '::' + a.scm_site_id + '~***' + '::' + a.line_id AS resource_id
                     , NULL                   AS sub_resource_id
                     , a.yyyymmdd             AS start_dttm
                     , a.yyyymmdd             AS end_dttm  --, DATEADD(d, 1, a.yyyymmdd) AS end_dttm
                     , a.qty                  AS operation_qty
                     , a.qty                  AS complete_qty
                     , 'WO::LINE_CAPA::' + CONVERT(NVARCHAR(10), 100000000 + ROW_NUMBER() OVER ( ORDER BY  YYYYMMDD )) AS lot_id
                     , 'N'                    AS is_fixed
                     , 'Y'                    AS is_prev_schedule
                     , 'START_FIX'            AS keep_work_time_type
                     , 'ALL_QTY_FIX'          AS keep_qty_type
                     , NULL                   AS sales_model_id
                     , NULL                   AS attribute_set_id
                     , NULL                   AS demand_id
                     , 'WO::LINE_CAPA'        AS descr
                     , 'Y'                    AS is_noh_consume        
                FROM   #tmp_scp_anl_production_plan a --속도문제로 Cutoff 테이블 사용. 2023.02.14
                      INNER JOIN   ( SELECT a.scm_site_id
                                          , ISNULL(a.fp_plan_period, 0) AS fp_plan_period
                                          , ISNULL(a.prod_frozen, 0)    AS prod_frozen --20190604 추가  
                                      FROM dbo.scm_mst_site_eng a WITH (NOLOCK)  
                                     WHERE a.modeling_id     = @p_modeling_id
                                       AND a.plan_id         = @p_plan_id
                                       AND a.plan_type       = @p_plan_type
                                       AND a.plan_seq        = @p_seq 
                                       AND a.division_id     = @p_division_id
                                       AND a.eng_scm_site_id = a.scm_site_id + '~***' 
                                       AND ISNULL(a.osp_yn, 'N') = 'N'   --외주 packer 아님
                                       AND ISNULL(a.attribute7, 'N') = 'N'   --52주통합plant 적용 대상 제외, 2024.10.07 추가
                                   ) c 
                       ON a.eng_res_descr = 'LINE_CAPA'  
					  AND a.scm_site_id   = c.scm_site_id
                      AND a.yyyymmdd     >= @p_plan_name 
					  AND a.yyyymmdd     <= CASE WHEN c.prod_frozen = @v_plan_horizon THEN @v_pet_date		--2021.05.18 중장기 계획
                                                 ELSE CONVERT(NVARCHAR(8), DATEADD(DD, c.prod_frozen-1, @d_plan_name), 112) -- <= 조건이므로 (prod_frozen-1)처리
                                             END 
			          -- 2018.06.01 ksg DISTINCT 처리
                      INNER JOIN   (SELECT DISTINCT SUBSTRING(bom.route_id, 1, 5) AS res_route_id
                                         , bom.site_id, bom.parent_item_id, bom.route_id
                                    FROM   th_eng_plan_bom_sn bom WITH (NOLOCK)
                                    WHERE  master_id = @p_master_id --'81::WEEKLY'
                                    AND    plan_id   = @p_engine_plan_id
                                   ) e                      
                       ON a.scm_site_id + '~***'  = e.site_id 
                      AND a.item_id               = e.parent_item_id  
                      AND a.eng_route_id          = e.res_route_id
                --OPTION (HASH JOIN) --20190211 추가 => HASH JOIN 제거 - 2023.02.14
                ;

                -- TXN LOG
                SET @n_log_count = @@ROWCOUNT;
                SET @v_log_type = 'TXN';
                SET @v_log_message = 'INSERTINTO '+@v_table_id;
                SET @v_description = N'1-2) Line 모델링 대상...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
                SET @d_event_date = SYSDATETIME();
                EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

                ----------------------------------------------------------
                --1-3) OSP
                ----------------------------------------------------------                  
                INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_FIXED_PLAN_PROD */ th_eng_fixed_plan_sn
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
                SELECT --DISTINCT /* 불필요한 DISTINCT절 주석처리, 2023.02.14 */
                       @p_master_id            AS master_id
                     , @p_engine_plan_id       AS plan_id 
                     , 'WO::OSP::' + CONVERT(NVARCHAR(10), 100000000 + ROW_NUMBER() OVER ( ORDER BY  YYYYMMDD )) AS work_order_id
                     , 1                       AS work_order_seq
                     , a.scm_site_id + '~***'  AS site_id
                     , a.eng_route_id          AS route_id  -- res의 route id
                     , a.eng_route_id          AS operation_id
                     , a.item_id
                     , a.eng_resource_id       AS resource_id -- , b.route_id + '::' + a.scm_site_id + '~***' + '::' + '-' AS resource_id
                     , NULL                    AS sub_resource_id
                     , a.yyyymmdd              AS start_dttm
                     , a.yyyymmdd              AS end_dttm  --, DATEADD(d, 1, a.yyyymmdd) AS end_dttm
                     , a.qty                   AS operation_qty
                     , a.qty                   AS complete_qty
                     , 'WO::OSP::' + CONVERT(NVARCHAR(10), 100000000 + ROW_NUMBER() OVER ( ORDER BY  YYYYMMDD )) AS lot_id
                     , 'N'                     AS is_fixed
                     , 'Y'                     AS is_prev_schedule
                     , 'START_FIX'             AS keep_work_time_type
                     , 'ALL_QTY_FIX'           AS keep_qty_type
                     , NULL                    AS sales_model_id
                     , NULL                    AS attribute_set_id
                     , NULL                    AS demand_id
                     , 'WO::OSP'               AS descr
                     , 'Y'                     AS is_noh_consume        
                FROM  #tmp_scp_anl_production_plan a --속도문제로 Cutoff 테이블 사용. 2023.02.14
               INNER JOIN   ( SELECT a.scm_site_id
                                   , ISNULL(a.fp_plan_period, 0) AS fp_plan_period
                                   , ISNULL(a.prod_frozen, 0)    AS prod_frozen --20190604 추가  
                                FROM dbo.scm_mst_site_eng a WITH (NOLOCK)  
                               WHERE a.modeling_id     = @p_modeling_id
                                 AND a.plan_id         = @p_plan_id
                                 AND a.plan_type       = @p_plan_type
                                 AND a.plan_seq        = @p_seq 
                                 AND a.division_id     = @p_division_id
                                 AND a.eng_scm_site_id = a.scm_site_id + '~***' 
                                 AND ISNULL(a.osp_yn, 'N')                 = 'Y'  --외주 packer
                                 AND DBO.FN_SCM_SYS_NVL(a.attribute1, 'N') = 'N'  --외주 packer Line Capa 비대상
                                 AND ISNULL(a.attribute7, 'N') = 'N'   --52주통합plant 적용 대상 제외, 2024.10.07 추가
                            ) c 
                  ON a.eng_res_descr = 'OSP'
				 AND a.scm_site_id   = c.scm_site_id
                 AND a.yyyymmdd     >= @p_plan_name 
				 AND a.yyyymmdd     <= CASE WHEN c.prod_frozen = @v_plan_horizon THEN @v_pet_date		--2021.05.18 중장기 계획
                                                ELSE CONVERT(NVARCHAR(8), DATEADD(DD, c.prod_frozen-1, @d_plan_name), 112) -- <= 조건이므로 (prod_frozen-1)처리
                                        END 
			   -- 2018.06.01 ksg DISTINCT 처리
               INNER JOIN   (SELECT DISTINCT SUBSTRING(bom.route_id, 1, 5) AS res_route_id
                                  , bom.site_id, bom.parent_item_id, bom.route_id
                             FROM   th_eng_plan_bom_sn bom WITH (NOLOCK)
                             WHERE  master_id = @p_master_id --'81::WEEKLY'
                             AND    plan_id   = @p_engine_plan_id
                            ) e
                  ON a.scm_site_id + '~***'  = e.site_id 
                 AND a.item_id               = e.parent_item_id  
                 AND a.eng_route_id          = e.route_id
                --OPTION (HASH JOIN) --20190211 추가 => HASH JOIN 제거 - 2023.02.14
                ;      

                -- TXN LOG
                SET @n_log_count = @@ROWCOUNT;
                SET @v_log_type = 'TXN';
                SET @v_log_message = 'INSERTINTO '+@v_table_id;
                SET @v_description = N'1-3) OSP...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
                SET @d_event_date = SYSDATETIME();
                EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

                ----------------------------------------------------------
                --1-4) OSP_L : 2020.02.03  [OSP Line Plan] OSP이면서 Line별 Capa 적용 Site 확정계획 추가      
                ----------------------------------------------------------                  
                INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_FIXED_PLAN_PROD */ th_eng_fixed_plan_sn
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
                SELECT --DISTINCT /* 불필요한 DISTINCT절 주석처리, 2023.02.14 */
                       @p_master_id           AS master_id
                     , @p_engine_plan_id      AS plan_id 
                     , 'WO::OSP_L::' + CONVERT(NVARCHAR(10), 100000000 + ROW_NUMBER() OVER ( ORDER BY  YYYYMMDD )) AS work_order_id
                     , 1                      AS work_order_seq
                     , a.scm_site_id + '~***' AS site_id
                     , a.eng_route_id         AS route_id  -- res의 route id
                     , a.eng_route_id         AS operation_id
                     , a.item_id		      
                     , a.eng_resource_id      AS resource_id -- , b.route_id + '::' + a.scm_site_id + '~***' + '::' + '-' AS resource_id
                     , NULL                   AS sub_resource_id
                     , a.yyyymmdd             AS start_dttm
                     , a.yyyymmdd             AS end_dttm  --, DATEADD(d, 1, a.yyyymmdd) AS end_dttm
                     , a.qty                  AS operation_qty
                     , a.qty                  AS complete_qty
                     , 'WO::OSP_L::' + CONVERT(NVARCHAR(10), 100000000 + ROW_NUMBER() OVER ( ORDER BY  YYYYMMDD )) AS lot_id
                     , 'N'                    AS is_fixed
                     , 'Y'                    AS is_prev_schedule
                     , 'START_FIX'            AS keep_work_time_type
                     , 'ALL_QTY_FIX'          AS keep_qty_type
                     , NULL                   AS sales_model_id
                     , NULL                   AS attribute_set_id
                     , NULL                   AS demand_id
                     , 'WO::OSP_L'            AS descr
                     , 'Y'                    AS is_noh_consume        
                FROM  #tmp_scp_anl_production_plan a --속도문제로 Cutoff 테이블 사용. 2023.02.14
				    /* 
				      ( SELECT * 
                         FROM   scp_anl_production_plan WITH (NOLOCK)  
                         WHERE  division_id         = @p_division_id  
                         AND    plan_start_yyyymmdd = @p_plan_name 
                         AND    plan_type           = @p_pre_plan_type 
                         AND    seq                 = @p_pre_plan_seq 
                         AND    measure             = 'PROD_PLAN_AMEND'
                         AND    qty                 > 0
                        ) a     
                      INNER JOIN    (SELECT SUBSTRING(r.resource_group_id, dbo.FN_CHARINDEX_REV(r.resource_group_id, '::', 0)+2, 100) AS line_id
                                                    , r.*
                                    FROM   th_eng_resource_sn r WITH(NOLOCK)
                                    WHERE  r.master_id = @p_master_id
                                    AND    r.plan_id   = @p_engine_plan_id
                                    -- 외주 packer 
                                    AND    r.descr     = 'OSP_L'
                                    ) b
                      ON     b.site_id   = a.scm_site_id + '~***'
                      AND    b.route_id  = a.operation_id 
                      AND    b.line_id   = a.line_id
                      */
                      INNER JOIN   ( SELECT a.scm_site_id, ISNULL(a.fp_plan_period, 0) AS fp_plan_period
                                         ,  ISNULL(a.prod_frozen, 0) AS prod_frozen --20190604 추가  
                                      FROM dbo.scm_mst_site_eng a WITH (NOLOCK)  
                                     WHERE a.modeling_id     = @p_modeling_id
                                       AND a.plan_id         = @p_plan_id
                                       AND a.plan_type       = @p_plan_type
                                       AND a.plan_seq        = @p_seq 
                                       AND a.division_id     = @p_division_id
                                       AND a.eng_scm_site_id = a.scm_site_id + '~***' 
                                       AND ISNULL(a.osp_yn, 'N')                 = 'Y'  --외주 packer
                                       AND DBO.FN_SCM_SYS_NVL(a.attribute1, 'N') = 'Y'  --외주 packer Line Capa 대상
                                       AND ISNULL(a.attribute7, 'N') = 'N'   --52주통합plant 적용 대상 제외, 2024.10.07 추가
                                   ) c 
                       ON a.eng_res_descr = 'OSP_L'  
					  AND a.scm_site_id   = c.scm_site_id
                      AND a.yyyymmdd     >= @p_plan_name 
					  AND a.yyyymmdd     <= CASE WHEN c.prod_frozen = @v_plan_horizon THEN @v_pet_date		--2021.05.18 중장기 계획
                                                 ELSE CONVERT(NVARCHAR(8), DATEADD(DD, c.prod_frozen-1, @d_plan_name), 112) -- <= 조건이므로 (prod_frozen-1)처리
                                             END 
			          -- 2018.06.01 ksg DISTINCT 처리
                      INNER JOIN   (SELECT DISTINCT SUBSTRING(bom.route_id, 1, 5) AS res_route_id
                                         , bom.site_id, bom.parent_item_id, bom.route_id
                                    FROM   th_eng_plan_bom_sn bom WITH (NOLOCK)
                                    WHERE  master_id = @p_master_id --'81::WEEKLY'
                                    AND    plan_id   = @p_engine_plan_id
                                   ) e
                      ON   a.scm_site_id + '~***'  = e.site_id 
                      AND  a.item_id               = e.parent_item_id  
                      AND  a.eng_route_id          = e.route_id
                ---OPTION (HASH JOIN) --20190211 추가 =>  HASH JOIN 제거 - 2023.02.14
                ;                

                -- TXN LOG
                SET @n_log_count = @@ROWCOUNT;
                SET @v_log_type = 'TXN';
                SET @v_log_message = 'INSERTINTO '+@v_table_id;
                SET @v_description = N'1-4) OSP_L...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
                SET @d_event_date = SYSDATETIME();
                EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
             
                /**********************************************************
                2. 52fp통합 plant 대상, 2024.10.07
                -- ~ fp frozen 구간내
                -- fp frozen 구간 ~ prod frozen 구간내
                -- prod frozen 구간 이후
                   자동차(해외법인포함)만 고려
                ***********************************************************/
				/*
					 2-1-1) FP_Plan_Load 구간(Line 모델링 비대상) 
                         -- 기준/테이블 변경 : scm_dnm_plan_frozen_v (FP 실적+생산계획) → scm_dnm_week_plan_frozen_v(최신fp계획)                      
					 2-1-2) FP_Plan_Load 구간(Line 모델링 대상)
                     	 -- 기준/테이블 변경 : scm_dnm_plan_frozen_v (FP 실적+생산계획) → scm_dnm_week_plan_frozen_v(최신fp계획) 
					 2-1-3) FP_Plan_Load 이후 구간(Line 모델링 비대상): SE일때 당주 Main plan  수정, FN일때 당주 Semi plan 수정 
						  -- scp_anl_production_plan (생산계획)                     
					 2-1-4) FP_Plan_Load 이후 구간(Line 모델링 대상): SE일때 당주 Main plan  수정, FN일때 당주 Semi plan 수정 
						  -- scp_anl_production_plan (생산계획)                     
				*/

				IF @v_division_group =  '81'

                BEGIN
            
				----------------------------------------------------------
				--2-1-1) CAPA  공정(Line 모델링 대상)
			    -- FP_Plan_Load 구간
			    -- FP계획 테이블 : scm_dnm_week_plan_frozen_v(실적+생산계획) 
				----------------------------------------------------------
                INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_FIXED_PLAN_PROD */ th_eng_fixed_plan_sn
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
				SELECT @p_master_id
					 , @p_engine_plan_id
					 , 'WO::LINE_CAPA::' + CONVERT(NVARCHAR(10), 600000000 + ROW_NUMBER() OVER ( ORDER BY  a.plan_date )) AS work_order_id
					 , 1                      AS work_order_seq
					 , a.scm_site_id + '~***' AS site_id                     
					 , e.route_id             AS route_id   -- bom의 route id
					 , e.route_id             AS operation_id
					 , a.item_id
					 , b.resource_id          AS resource_id --  , b.route_id + '::' + a.scm_site_id + '~***' + '::' + a.line_id AS resource_id -- res는 여러 Route에 동시에 사용 가능함
					 , NULL                   AS sub_resource_id
					 , a.plan_date            AS start_dttm
					 , a.plan_date            AS end_dttm
					 , a.plan_in_qty          AS operation_qty
					 , a.plan_qty             AS complete_qty
					 , 'WO::LINE_CAPA::' + CONVERT(NVARCHAR(10), 600000000 + ROW_NUMBER() OVER ( ORDER BY  a.plan_date )) AS lot_id
					 , 'N'                    AS is_fixed
					 , 'Y'                    AS is_prev_schedule
					 , 'START_FIX'            AS keep_work_time_type
					 , 'ALL_QTY_FIX'          AS keep_qty_type
					 , NULL                   AS sales_model_id
					 , NULL                   AS attribute_set_id
					 , NULL                   AS demand_id
					 , 'WO::LINE_CAPA'        AS descr
					 , 'Y'                    AS is_noh_consume
				  FROM dbo.scm_dnm_week_plan_frozen_v a WITH(NOLOCK) --PR이후는 실적+FP계획
                  --20180430  속도개선을 위해서 inner join => left join으로 변경
				  LEFT JOIN  (SELECT SUBSTRING(r.resource_group_id, dbo.FN_CHARINDEX_REV(r.resource_group_id, '::', 0)+2, 100) AS line_id
												, r.*
							   FROM th_eng_resource_sn r WITH(NOLOCK)
							  WHERE r.master_id = @p_master_id
								AND r.plan_id   = @p_engine_plan_id
								-- SCP Capa 공정이면서 Line Modeling 대상 공정 
								AND r.descr     = 'LINE_CAPA' 
							   ) b
				   ON b.site_id   = a.scm_site_id + '~***'
				  -- Line Modeling 대상
				  AND b.route_id  = a.operation_id
				  AND b.line_id   = a.line_id
				INNER JOIN   ( SELECT a.scm_site_id
				                    , ISNULL(a.fp_plan_period, 0) AS fp_plan_period
                                    , ISNULL(a.prod_frozen, 0)    AS prod_frozen --20190604 추가  
                                 FROM dbo.scm_mst_site_eng a WITH (NOLOCK)  
							    WHERE a.modeling_id     = @p_modeling_id
							      AND a.plan_id         = @p_plan_id
							      AND a.plan_type       = @p_plan_type
							      AND a.plan_seq        = @p_seq 
							      AND a.division_id     = @p_division_id
							      AND a.eng_scm_site_id = a.scm_site_id + '~***'
							      AND ISNULL(a.osp_yn, 'N') = 'N'   --외주 packer 아님 
                                  AND ISNULL(a.attribute7, 'N') = 'Y'
                            ) c 
				  ON a.plan_date    >= @d_plan_name
                 AND a.plan_date    <  DATEADD(DD, c.fp_plan_period, @d_plan_name)
				 AND a.scm_site_id  = c.scm_site_id 			  
			   INNER JOIN (SELECT DISTINCT SUBSTRING(bom.route_id, 1, 5) AS res_route_id
			  				    , bom.site_id, bom.parent_item_id, bom.route_id
			  			     FROM th_eng_plan_bom_sn bom WITH (NOLOCK)
			  			    WHERE master_id = @p_master_id --'81::WEEKLY'
			  			      AND plan_id   = @p_engine_plan_id
			  		      ) e
			       ON a.scm_site_id + '~***'  = e.site_id 
				  AND a.item_id               = e.parent_item_id  
				  AND b.route_id              = e.res_route_id 
				WHERE 1=1
				  AND a.division_id  = @p_division_id   
				  AND a.plan_qty     > 0
				  AND a.plan_in_qty  > 0
				  AND b.site_id IS NOT NULL 
                ;

			    -- TXN LOG
			    SET @n_log_count = @@ROWCOUNT;
			    SET @v_log_type = 'TXN';
			    SET @v_log_message = 'INSERTINTO '+@v_table_id;
			    SET @v_description = N'2-1-1) CAPA  공정(Line 모델링 대상)...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
			    SET @d_event_date = SYSDATETIME();
			    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

                ---------------------------------------------------------
				--2-1-2) CAPA  공정(Line 모델링 비대상)
				-- FP_Plan_Load 구간
				-- FP계획 테이블 : scm_dnm_week_plan_frozen_v(실적+생산계획) 
				----------------------------------------------------------
				INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_FIXED_PLAN_PROD */ th_eng_fixed_plan_sn
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
			  SELECT --DISTINCT /* 불필요한 DISTINCT절 주석처리, 2023.02.14 */
			  	      @p_master_id           AS master_id
			  	    , @p_engine_plan_id      AS plan_id 
			  	    , 'WO::CAPA::' + CONVERT(NVARCHAR(10), 500000000 + ROW_NUMBER() OVER ( ORDER BY  a.plan_date )) AS work_order_id
			  	    , 1                      AS work_order_seq
			  	    , a.scm_site_id + '~***' AS site_id
			  	    , b.route_id             AS route_id  -- res의 route id
			  	    , b.route_id             AS operation_id
			  	    , a.item_id
			  	    , b.resource_id          AS resource_id -- , b.route_id + '::' + a.scm_site_id + '~***' + '::' + '-' AS resource_id
			  	    , NULL                   AS sub_resource_id
			  	    , a.plan_date            AS start_dttm
			  	    , a.plan_date            AS end_dttm
			  	    , a.plan_in_qty          AS operation_qty
			  	    , a.plan_qty             AS complete_qty
			  	    ,  'WO::CAPA::' + CONVERT(NVARCHAR(10), 500000000 + ROW_NUMBER() OVER ( ORDER BY  a.plan_date )) AS lot_id
			  	    , 'N'                    AS is_fixed
			  	    , 'Y'                    AS is_prev_schedule
			  	    , 'START_FIX'            AS keep_work_time_type
			  	    , 'ALL_QTY_FIX'          AS keep_qty_type
			  	    , NULL                   AS sales_model_id
			  	    , NULL                   AS attribute_set_id
			  	    , NULL                   AS demand_id
			  	    , 'WO::CAPA'             AS descr
			  	    , 'Y'                    AS is_noh_consume        
			    FROM scm_dnm_week_plan_frozen_v a WITH(NOLOCK)  --2023.03.13 재변경
			      --20180430  속도개선을 위해서 inner join => left join으로 변경  
			  	LEFT JOIN(SELECT SUBSTRING(r.resource_group_id, dbo.FN_CHARINDEX_REV(r.resource_group_id, '::', 0)+2, 100) AS line_id
			  						  	 , r.*
			  			    FROM th_eng_resource_sn r WITH(NOLOCK)
			  			   WHERE r.master_id = @p_master_id
			  				AND  r.plan_id   = @p_engine_plan_id
			  				-- SCP Capa 공정이면서 Line Modeling 비대상 공정 
			  				AND  r.descr     = 'CAPA' 
			  				) b      
			  	  ON b.site_id   = a.scm_site_id + '~***'
			  	 -- Line Modeling 비대상
			  	 AND b.route_id  LIKE a.operation_id + '%'  -- AND    b.line_id   = a.line_id                     
			   INNER JOIN   ( SELECT a.scm_site_id
			  	                   , ISNULL(a.fp_plan_period, 0) AS fp_plan_period
                                   , ISNULL(a.prod_frozen, 0)    AS prod_frozen --20190604 추가  
			  					 FROM dbo.scm_mst_site_eng a WITH (NOLOCK)  
			  					WHERE a.modeling_id     = @p_modeling_id
			  					  AND a.plan_id         = @p_plan_id
			  					  AND a.plan_type       = @p_plan_type
			  					  AND a.plan_seq        = @p_seq 
			  					  AND a.division_id     = @p_division_id
			  					  AND a.eng_scm_site_id = a.scm_site_id + '~***' 
			  					  AND ISNULL(a.osp_yn, 'N') = 'N'
                                  AND ISNULL(a.attribute7, 'N') = 'Y'   --52주통합plant 적용 대상, 2024.10.07 추가
			  				) c 
			  	 ON a.plan_date    >= @d_plan_name --20180228 수정( @v_cur_monday 를 @p_plan_name로 변경함, plan_cycle 이 Daily 일경우도 처리되게 하기위함) (변경전 : AND    a.plan_date           >= CONVERT(DATETIME, @v_cur_monday))
			  	AND a.plan_date    <  DATEADD(DD, c.fp_plan_period, @d_plan_name)
			  	AND a.scm_site_id   = c.scm_site_id
			  INNER JOIN   (SELECT DISTINCT SUBSTRING(bom.route_id, 1, 5) AS res_route_id
			  		    		 , bom.site_id, bom.parent_item_id, bom.route_id
			  				  FROM th_eng_plan_bom_sn bom WITH (NOLOCK)
			  				 WHERE master_id = @p_master_id --'81::WEEKLY'
			  				   AND plan_id   = @p_engine_plan_id
			  				) e			  
			  	  ON a.scm_site_id + '~***'  = e.site_id 
			     AND a.item_id               = e.parent_item_id  
			     AND b.route_id              = e.route_id			   
			   WHERE 1=1
				 AND a.division_id  = @p_division_id
                 AND a.plan_qty     > 0
				 AND a.plan_in_qty  > 0
				 AND b.site_id IS NOT NULL --20180430 a,b 테이블  inner join => left join 변경시키기위해서 조건 추가함(속도 개선 때문에 조인 방법 변경함)
				;

				-- TXN LOG
				SET @n_log_count = @@ROWCOUNT;
				SET @v_log_type = 'TXN';
				SET @v_log_message = 'INSERTINTO '+@v_table_id;
				SET @v_description = N'2-1-2) CAPA  공정(Line 모델링 비대상)...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
				SET @d_event_date = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

                /* fp_plan_period 구간 이후 fix 추가 */
				----------------------------------------------------------
				-- 2-1-3) CAPA  공정(Line 모델링 비대상)
				-- FP_Plan_Load 이후 구간
				-- scp_anl_production_plan (SCP 생산계획)
				----------------------------------------------------------
				INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_FIXED_PLAN_PROD */ th_eng_fixed_plan_sn
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
					SELECT --DISTINCT /* 불필요한 DISTINCT절 주석처리, 2023.02.14 */
						   @p_master_id           AS master_id
						 , @p_engine_plan_id      AS plan_id 
						 , 'WO::CAPA::' + CONVERT(NVARCHAR(10), 300000000 + ROW_NUMBER() OVER ( ORDER BY  a.yyyymmdd )) AS work_order_id
						 , 1                      AS work_order_seq
						 , a.scm_site_id + '~***' AS site_id
						 , a.eng_route_id         AS route_id  -- res의 route id
						 , a.eng_route_id         AS operation_id
						 , a.item_id
						 , a.eng_resource_id      AS resource_id -- , b.route_id + '::' + a.scm_site_id + '~***' + '::' + '-' AS resource_id
						 , NULL                   AS sub_resource_id
						 , a.yyyymmdd             AS start_dttm
						 , a.yyyymmdd             AS end_dttm  --, DATEADD(d, 1, a.yyyymmdd) AS end_dttm
						 , a.qty                  AS operation_qty
						 , a.qty                  AS complete_qty
						 , 'WO::CAPA::' + CONVERT(NVARCHAR(10), 300000000 + ROW_NUMBER() OVER ( ORDER BY  a.yyyymmdd )) AS lot_id
						 , 'N'                    AS is_fixed
						 , 'Y'                    AS is_prev_schedule
						 , 'START_FIX'            AS keep_work_time_type
						 , 'ALL_QTY_FIX'          AS keep_qty_type
						 , NULL                   AS sales_model_id
						 , NULL                   AS attribute_set_id
						 , NULL                   AS demand_id
						 , 'WO::CAPA'             AS descr
						 , 'Y'                    AS is_noh_consume       
					FROM  #tmp_scp_anl_production_plan a  --속도문제로 Cutoff 테이블 사용. 2023.02.14
					INNER JOIN   ( SELECT a.scm_site_id
                                        , ISNULL(a.fp_plan_period, 0) AS fp_plan_period
                                        , ISNULL(a.prod_frozen, 0)    AS prod_frozen --20190604 추가  
									FROM   dbo.scm_mst_site_eng a WITH (NOLOCK)  
									WHERE  a.modeling_id     = @p_modeling_id
									AND    a.plan_id         = @p_plan_id
									AND    a.plan_type       = @p_plan_type
									AND    a.plan_seq        = @p_seq 
									AND    a.division_id     = @p_division_id
									AND    a.eng_scm_site_id = scm_site_id + '~***' 
									AND    ISNULL(a.osp_yn, 'N') = 'N'   --외주 packer 아님
                                    AND    ISNULL(a.attribute7, 'N') = 'Y'   --52주통합plant 적용 대상
								) c 
					  ON a.eng_res_descr =  'CAPA'  
					 AND a.scm_site_id   = c.scm_site_id
					 AND a.yyyymmdd     >=  CONVERT(NVARCHAR(8), DATEADD(DD, c.fp_plan_period, @d_plan_name), 112) -- FP_Plan_Load 이후 구간
					 AND a.yyyymmdd     <= CASE WHEN c.prod_frozen = @v_plan_horizon THEN @v_pet_date		--2021.05.18 중장기 계획
					 						    ELSE CONVERT(NVARCHAR(8), DATEADD(DD, c.prod_frozen-1, @d_plan_name), 112) -- <= 조건이므로 (prod_frozen-1)처리
					 						END 			  
					-- 2018.06.01 ksg DISTINCT 처리
					INNER JOIN   (SELECT DISTINCT SUBSTRING(bom.route_id, 1, 5) AS res_route_id
										, bom.site_id, bom.parent_item_id, bom.route_id
								FROM   th_eng_plan_bom_sn bom WITH (NOLOCK)
								WHERE  master_id = @p_master_id  
								AND    plan_id   = @p_engine_plan_id
								) e                      
					   ON a.scm_site_id + '~***'  = e.site_id 
					  AND a.item_id               = e.parent_item_id  
					  AND a.eng_route_id          = e.route_id
				;

				-- TXN LOG
				SET @n_log_count = @@ROWCOUNT;
				SET @v_log_type = 'TXN';
				SET @v_log_message = 'INSERTINTO '+@v_table_id;
				SET @v_description = N'2-1-3) CAPA  공정(Line 모델링 비대상)...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
				SET @d_event_date = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

				----------------------------------------------------------
				--2-1-4) CAPA  공정(Line 모델링 대상)
				-- FP_Plan_Load 이후 구간
				-- scp_anl_production_plan (생산계획)
				----------------------------------------------------------
				INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_FIXED_PLAN_PROD */ th_eng_fixed_plan_sn
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
					SELECT --DISTINCT /* 불필요한 DISTINCT절 주석처리, 2023.02.14 */
						   @p_master_id           AS master_id
						 , @p_engine_plan_id      AS plan_id 
						 , 'WO::LINE_CAPA::' + CONVERT(NVARCHAR(10), 400000000 + ROW_NUMBER() OVER ( ORDER BY  a.yyyymmdd )) AS work_order_id
						 , 1                      AS work_order_seq
						 , a.scm_site_id + '~***' AS site_id                     
						 , a.eng_route_id         AS route_id   -- bom의 route id
						 , a.eng_route_id         AS operation_id
						 , a.item_id
						 , a.eng_resource_id      AS resource_id  -- , b.route_id + '::' + a.scm_site_id + '~***' + '::' + a.line_id AS resource_id
						 , NULL                   AS sub_resource_id
						 , a.yyyymmdd             AS start_dttm
						 , a.yyyymmdd             AS end_dttm  --, DATEADD(d, 1, a.yyyymmdd) AS end_dttm
						 , a.qty                  AS operation_qty
						 , a.qty                  AS complete_qty
						 , 'WO::LINE_CAPA::' + CONVERT(NVARCHAR(10), 400000000 + ROW_NUMBER() OVER ( ORDER BY a.yyyymmdd )) AS lot_id
						 , 'N'                    AS is_fixed
						 , 'Y'                    AS is_prev_schedule
						 , 'START_FIX'            AS keep_work_time_type
						 , 'ALL_QTY_FIX'          AS keep_qty_type
						 , NULL                   AS sales_model_id
						 , NULL                   AS attribute_set_id
						 , NULL                   AS demand_id
						 , 'WO::LINE_CAPA'        AS descr
						 , 'Y'                    AS is_noh_consume        
					FROM #tmp_scp_anl_production_plan a --속도문제로 Cutoff 테이블 사용. 2023.02.14					    
						  INNER  JOIN   ( SELECT a.scm_site_id
                                               , ISNULL(a.fp_plan_period, 0) AS fp_plan_period
                                               , ISNULL(a.prod_frozen, 0)    AS prod_frozen --20190604 추가  
										  FROM  dbo.scm_mst_site_eng a WITH (NOLOCK)  
										 WHERE  a.modeling_id     = @p_modeling_id
										   AND  a.plan_id         = @p_plan_id
										   AND  a.plan_type       = @p_plan_type
										   AND  a.plan_seq        = @p_seq 
										   AND  a.division_id     = @p_division_id
										   AND  a.eng_scm_site_id = a.scm_site_id + '~***' 
										   AND  ISNULL(a.osp_yn, 'N') = 'N'   --외주 packer 아님
                                           AND  ISNULL(a.attribute7, 'N') = 'Y' --52주통합plant 적용 대상
									   ) c 
						   ON a.eng_res_descr = 'LINE_CAPA'
						  AND a.scm_site_id   = c.scm_site_id
						  AND a.yyyymmdd     >=  CONVERT(NVARCHAR(8), DATEADD(DD, c.fp_plan_period, @d_plan_name), 112) -- FP_Plan_Load 이후 구간
						  AND a.yyyymmdd     <= CASE WHEN c.prod_frozen = @v_plan_horizon THEN @v_pet_date		--2021.05.18 중장기 계획
											     	 ELSE CONVERT(NVARCHAR(8), DATEADD(DD, c.prod_frozen-1, @d_plan_name), 112) -- <= 조건이므로 (prod_frozen-1)처리
												 END
						  -- 2018.06.01 ksg DISTINCT 처리
						  INNER JOIN   (SELECT DISTINCT SUBSTRING(bom.route_id, 1, 5) AS res_route_id
											 , bom.site_id, bom.parent_item_id, bom.route_id
										FROM   th_eng_plan_bom_sn bom WITH (NOLOCK)
										WHERE  master_id = @p_master_id  
										AND    plan_id   = @p_engine_plan_id
									   ) e                      
						  ON   a.scm_site_id + '~***'  = e.site_id 
						  AND  a.item_id               = e.parent_item_id  
						  AND  a.eng_route_id          = e.res_route_id   
				;

				-- TXN LOG
				SET @n_log_count = @@ROWCOUNT;
				SET @v_log_type = 'TXN';
				SET @v_log_message = 'INSERTINTO '+@v_table_id;
				SET @v_description = N'2-1-4) CAPA  공정(Line 모델링 대상)...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
				SET @d_event_date = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

                END --//@v_division_group =  '81'


        END;        
        
        --20180618 수정 FN 추가  (변경전 : ELSE IF @p_plan_type =  'SE')
        --20190211 수정 자동차(81), ESS(82) SE, FN만 실행되게 변경함 (변경전 : ELSE IF @p_plan_type IN  ('SE', 'FN') )
        --20200713 C20200702-000043 FN 제외
        --ELSE IF @p_division_id IN ( '81', '82') AND @p_plan_type IN  ('SE')    
		--ELSE IF @v_division_group IN ( '81', '82') AND @p_plan_type IN  ('SE') --2022.04.04 JV건으로 수정.
		--ELSE IF @v_division_group IN ( '81', '82', '40') AND @p_plan_type IN  ('SE') --소형 공통 기준으로 추가, 2023.02.14.
		--소형은 MAIN때 실행, 2023.02.24 수정 (MA -> SE 대치시 변경 필요)
        
        /* 로직 순서 재정리 
           81/81_UC 포함 FN에 대해서만 고려하기 때문에, SE 로직 변경 불필요 , 2024.10.07
        */
		/* 2025.08.01 소형 SE -> MA로 변경에 '[OR(@v_division_group IN ( '40') AND @p_plan_type IN  ('MA', 'TM'))]' 주석처리 CSR : E20250724-001388 */
		ELSE IF (@v_division_group IN ( '81', '82') AND @p_plan_type IN  ('SE'))
		      --OR(@v_division_group IN ( '40') AND @p_plan_type IN  ('MA', 'TM')) 
		BEGIN
                   ----------------------------------------------------------
				--2-1) FP 대상
				/*
					 2-1-1) FP_Plan_Load 구간(Line 모델링 비대상) : 2023.03.13
							 -- 기준/테이블 변경 : scm_dnm_plan_frozen_v (FP 실적+생산계획) → scm_dnm_week_plan_frozen_v(최신fp계획)                      
					 2-1-2) FP_Plan_Load 구간(Line 모델링 대상) : 2023.03.13
							 -- 기준/테이블 변경 : scm_dnm_plan_frozen_v (FP 실적+생산계획) → scm_dnm_week_plan_frozen_v(최신fp계획) 
					 2-1-3) FP_Plan_Load 이후 구간(Line 모델링 비대상): SE일때 당주 Main plan  수정, FN일때 당주 Semi plan 수정 
							 -- scp_anl_production_plan (생산계획)                     
					 2-1-4) FP_Plan_Load 이후 구간(Line 모델링 대상): SE일때 당주 Main plan  수정, FN일때 당주 Semi plan 수정 
							 -- scp_anl_production_plan (생산계획)                     
				*/
				----------------------------------------------------------
                   /* fp_plan_period 구간 동기화 */
				----------------------------------------------------------
				--2-1-1) CAPA  공정(Line 모델링 대상)
						 -- FP_Plan_Load 구간
						 -- FP계획 테이블 : scm_dnm_plan_frozen_v (FP 실적+생산계획) → scm_dnm_week_plan_frozen_v(최신fp계획) 
						                 -- scm_dnm_fp_release_prod_plan_c(Cutoff일자 : yyyymmdd별 FP계획)
						 -- 2023.03.13 재변경
				----------------------------------------------------------
				INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_FIXED_PLAN_PROD */ th_eng_fixed_plan_sn
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
					SELECT --DISTINCT /* 불필요한 DISTINCT절 주석처리, 2023.02.14 */
						   @p_master_id
						 , @p_engine_plan_id
						 , 'WO::LINE_CAPA::' + CONVERT(NVARCHAR(10), 600000000 + ROW_NUMBER() OVER ( ORDER BY  a.plan_date )) AS work_order_id
						 , 1                      AS work_order_seq
						 , a.scm_site_id + '~***' AS site_id                     
						 , e.route_id             AS route_id   -- bom의 route id
						 , e.route_id             AS operation_id
						 --, b.route_id AS route_id
						 --, b.route_id AS operation_id                     
						 , a.item_id
						 , b.resource_id          AS resource_id --  , b.route_id + '::' + a.scm_site_id + '~***' + '::' + a.line_id AS resource_id -- res는 여러 Route에 동시에 사용 가능함
						 , NULL                   AS sub_resource_id
						 , a.plan_date            AS start_dttm
						 , a.plan_date            AS end_dttm
						 , a.plan_in_qty          AS operation_qty
						 , a.plan_qty             AS complete_qty
						 , 'WO::LINE_CAPA::' + CONVERT(NVARCHAR(10), 600000000 + ROW_NUMBER() OVER ( ORDER BY  a.plan_date )) AS lot_id
						 , 'N'                    AS is_fixed
						 , 'Y'                    AS is_prev_schedule
						 , 'START_FIX'            AS keep_work_time_type
						 , 'ALL_QTY_FIX'          AS keep_qty_type
						 , NULL                   AS sales_model_id
						 , NULL                   AS attribute_set_id
						 , NULL                   AS demand_id
						 , 'WO::LINE_CAPA'        AS descr
						 , 'Y'                    AS is_noh_consume
					--FROM dbo.scm_dnm_plan_frozen_v  a WITH(NOLOCK) 
					  FROM dbo.scm_dnm_week_plan_frozen_v     a WITH(NOLOCK) --2023.03.13 재변경
                        --20180430  속도개선을 위해서 inner join => left join으로 변경
						  LEFT  JOIN  (SELECT SUBSTRING(r.resource_group_id, dbo.FN_CHARINDEX_REV(r.resource_group_id, '::', 0)+2, 100) AS line_id
														, r.*
										FROM   th_eng_resource_sn r WITH(NOLOCK)
										WHERE  r.master_id = @p_master_id
										AND    r.plan_id   = @p_engine_plan_id
										-- SCP Capa 공정이면서 Line Modeling 대상 공정 
										AND    r.descr     = 'LINE_CAPA' 
									   ) b
						  ON     b.site_id   = a.scm_site_id + '~***'
						  -- Line Modeling 대상
						  AND    b.route_id  = a.operation_id
						  AND    b.line_id   = a.line_id
						  INNER JOIN   ( SELECT scm_site_id
						                      , ISNULL(fp_plan_period, 0) AS fp_plan_period
											  , ISNULL(prod_frozen, 0) AS prod_frozen
										   FROM dbo.scm_mst_site_eng WITH (NOLOCK)  
										  WHERE modeling_id     = @p_modeling_id
										    AND plan_id         = @p_plan_id
										    AND plan_type       = @p_plan_type
										    AND plan_seq        = @p_seq 
										    AND division_id     = @p_division_id
										    AND eng_scm_site_id = scm_site_id + '~***'
										    AND ISNULL(osp_yn, 'N') = 'N'   --외주 packer 아님 
									   ) c 
						  ON    a.plan_date     >= @d_plan_name --20180228 수정( @v_cur_monday 를 @p_plan_name로 변경함, plan_cycle 이 Daily 일경우도 처리되게 하기위함) (변경전 : AND    a.plan_date           >= CONVERT(DATETIME, @v_cur_monday))
						  AND   a.plan_date     <  DATEADD(DD, c.fp_plan_period, @d_plan_name)
						  AND   a.plan_date    <= CASE WHEN c.prod_frozen = @v_plan_horizon THEN @v_pet_date		--2021.05.18 중장기 계획
														ELSE DATEADD(DD, c.prod_frozen-1, @d_plan_name) -- <= 조건이므로 (prod_frozen-1)처리
												   END
						  AND   a.scm_site_id    = c.scm_site_id 			  
						  -- 2018.06.01 ksg DISTINCT 처리
						  INNER JOIN   (SELECT DISTINCT SUBSTRING(bom.route_id, 1, 5) AS res_route_id
											 , bom.site_id, bom.parent_item_id, bom.route_id
										FROM   th_eng_plan_bom_sn bom WITH (NOLOCK)
										WHERE  master_id = @p_master_id --'81::WEEKLY'
										AND    plan_id   = @p_engine_plan_id
									   ) e
						  ON    a.scm_site_id + '~***'  = e.site_id 
						  AND   a.item_id               = e.parent_item_id  
						  AND   b.route_id              = e.res_route_id 
					   -- AND   b.route_id              = e.route_id			   
					WHERE  1=1
					AND    a.division_id  = @p_division_id   
					AND    a.plan_qty     > 0
					AND    a.plan_in_qty  > 0
					AND    b.site_id IS NOT NULL --20180430 a,b 테이블  inner join => left join 변경시키기위해서 조건 추가함(속도 개선 때문에 조인 방법 변경함)                     
				;

				-- TXN LOG
				SET @n_log_count = @@ROWCOUNT;
				SET @v_log_type = 'TXN';
				SET @v_log_message = 'INSERTINTO '+@v_table_id;
				SET @v_description = N'2-1-1) CAPA  공정(Line 모델링 대상)...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
				SET @d_event_date = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

                   ---------------------------------------------------------
				--2-1-2) CAPA  공정(Line 모델링 비대상)
						 -- FP_Plan_Load 구간
						 -- FP계획 테이블 : scm_dnm_plan_frozen_v (FP 실적+생산계획) → scm_dnm_week_plan_frozen_v(최신fp계획) 
						                 -- scm_dnm_fp_release_prod_plan_c(Cutoff일자 : yyyymmdd별 FP계획)
						 -- 2023.03.13 재변경
				----------------------------------------------------------
				INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_FIXED_PLAN_PROD */ th_eng_fixed_plan_sn
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
					SELECT --DISTINCT /* 불필요한 DISTINCT절 주석처리, 2023.02.14 */
						   @p_master_id           AS master_id
						 , @p_engine_plan_id      AS plan_id 
						 , 'WO::CAPA::' + CONVERT(NVARCHAR(10), 500000000 + ROW_NUMBER() OVER ( ORDER BY  a.plan_date )) AS work_order_id
						 , 1                      AS work_order_seq
						 , a.scm_site_id + '~***' AS site_id
						 , b.route_id             AS route_id  -- res의 route id
						 , b.route_id             AS operation_id
						 , a.item_id
						 , b.resource_id          AS resource_id -- , b.route_id + '::' + a.scm_site_id + '~***' + '::' + '-' AS resource_id
						 , NULL                   AS sub_resource_id
						 , a.plan_date            AS start_dttm
						 , a.plan_date            AS end_dttm
						 , a.plan_in_qty          AS operation_qty
						 , a.plan_qty             AS complete_qty
						 ,  'WO::CAPA::' + CONVERT(NVARCHAR(10), 500000000 + ROW_NUMBER() OVER ( ORDER BY  a.plan_date )) AS lot_id
						 , 'N'                    AS is_fixed
						 , 'Y'                    AS is_prev_schedule
						 , 'START_FIX'            AS keep_work_time_type
						 , 'ALL_QTY_FIX'          AS keep_qty_type
						 , NULL                   AS sales_model_id
						 , NULL                   AS attribute_set_id
						 , NULL                   AS demand_id
						 , 'WO::CAPA'             AS descr
						 , 'Y'                    AS is_noh_consume        
					  --FROM scm_dnm_plan_frozen_v a WITH(NOLOCK)
					    FROM scm_dnm_week_plan_frozen_v a WITH(NOLOCK)  --2023.03.13 재변경
					    --20180430  속도개선을 위해서 inner join => left join으로 변경  
						  LEFT JOIN    (SELECT SUBSTRING(r.resource_group_id, dbo.FN_CHARINDEX_REV(r.resource_group_id, '::', 0)+2, 100) AS line_id
														, r.*
										FROM   th_eng_resource_sn r WITH(NOLOCK)
										WHERE  r.master_id = @p_master_id
										AND    r.plan_id   = @p_engine_plan_id
										-- SCP Capa 공정이면서 Line Modeling 비대상 공정 
										AND    r.descr     = 'CAPA' 
										) b      
						  ON     b.site_id   = a.scm_site_id + '~***'
						  -- Line Modeling 비대상
						  AND    b.route_id  LIKE a.operation_id + '%'  -- AND    b.line_id   = a.line_id                     
						  INNER JOIN   ( SELECT scm_site_id
						                      , ISNULL(fp_plan_period, 0) AS fp_plan_period
											  , ISNULL(prod_frozen, 0) AS prod_frozen
										   FROM dbo.scm_mst_site_eng WITH (NOLOCK)  
										  WHERE modeling_id     = @p_modeling_id
										    AND plan_id         = @p_plan_id
										    AND plan_type       = @p_plan_type
										    AND plan_seq        = @p_seq 
										    AND division_id     = @p_division_id
										    AND eng_scm_site_id = scm_site_id + '~***' 
										    AND ISNULL(osp_yn, 'N') = 'N'
									   ) c 
						  ON    a.plan_date    >= @d_plan_name --20180228 수정( @v_cur_monday 를 @p_plan_name로 변경함, plan_cycle 이 Daily 일경우도 처리되게 하기위함) (변경전 : AND    a.plan_date           >= CONVERT(DATETIME, @v_cur_monday))
						  AND   a.plan_date    <  DATEADD(DD, c.fp_plan_period, @d_plan_name)
						  AND   a.plan_date    <= CASE WHEN c.prod_frozen = @v_plan_horizon THEN @v_pet_date		--2021.05.18 중장기 계획
													   ELSE DATEADD(DD, c.prod_frozen-1, @d_plan_name) -- <= 조건이므로 (prod_frozen-1)처리
												   END
						  AND    a.scm_site_id   = c.scm_site_id
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
					WHERE  1=1
					AND    a.division_id  = @p_division_id
                    AND    a.plan_qty     > 0
					AND    a.plan_in_qty  > 0
					AND    b.site_id IS NOT NULL --20180430 a,b 테이블  inner join => left join 변경시키기위해서 조건 추가함(속도 개선 때문에 조인 방법 변경함)
				;

				-- TXN LOG
				SET @n_log_count = @@ROWCOUNT;
				SET @v_log_type = 'TXN';
				SET @v_log_message = 'INSERTINTO '+@v_table_id;
				SET @v_description = N'2-1-2) CAPA  공정(Line 모델링 비대상)...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
				SET @d_event_date = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

                   /* fp_plan_period 구간 이후 fix 추가 */
				----------------------------------------------------------
				-- 2-1-3) CAPA  공정(Line 모델링 비대상)
						 -- FP_Plan_Load 이후 구간
						 -- scp_anl_production_plan (SCP 생산계획)
				----------------------------------------------------------
				INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_FIXED_PLAN_PROD */ th_eng_fixed_plan_sn
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
					SELECT --DISTINCT /* 불필요한 DISTINCT절 주석처리, 2023.02.14 */
						   @p_master_id           AS master_id
						 , @p_engine_plan_id      AS plan_id 
						 , 'WO::CAPA::' + CONVERT(NVARCHAR(10), 300000000 + ROW_NUMBER() OVER ( ORDER BY  a.yyyymmdd )) AS work_order_id
						 , 1                      AS work_order_seq
						 , a.scm_site_id + '~***' AS site_id
						 , a.eng_route_id         AS route_id  -- res의 route id
						 , a.eng_route_id         AS operation_id
						 , a.item_id
						 , a.eng_resource_id      AS resource_id -- , b.route_id + '::' + a.scm_site_id + '~***' + '::' + '-' AS resource_id
						 , NULL                   AS sub_resource_id
						 , a.yyyymmdd             AS start_dttm
						 , a.yyyymmdd             AS end_dttm  --, DATEADD(d, 1, a.yyyymmdd) AS end_dttm
						 , a.qty                  AS operation_qty
						 , a.qty                  AS complete_qty
						 , 'WO::CAPA::' + CONVERT(NVARCHAR(10), 300000000 + ROW_NUMBER() OVER ( ORDER BY  a.yyyymmdd )) AS lot_id
						 , 'N'                    AS is_fixed
						 , 'Y'                    AS is_prev_schedule
						 , 'START_FIX'            AS keep_work_time_type
						 , 'ALL_QTY_FIX'          AS keep_qty_type
						 , NULL                   AS sales_model_id
						 , NULL                   AS attribute_set_id
						 , NULL                   AS demand_id
						 , 'WO::CAPA'             AS descr
						 , 'Y'                    AS is_noh_consume       
					FROM  #tmp_scp_anl_production_plan a  --속도문제로 Cutoff 테이블 사용. 2023.02.14
					/* ( SELECT * 
                         FROM   scp_anl_production_plan WITH (NOLOCK)  
                         WHERE  division_id         = @p_division_id  
                         AND    plan_start_yyyymmdd = @p_plan_name 
                         AND    plan_type           = @p_pre_plan_type   
                         AND    seq                 = @p_pre_plan_seq 
                         AND    measure             = 'PROD_PLAN_AMEND'
                         AND    qty                 > 0
                        ) a     
                      INNER JOIN    (SELECT SUBSTRING(r.resource_group_id, dbo.FN_CHARINDEX_REV(r.resource_group_id, '::', 0)+2, 100) AS line_id
                                                    , r.*
                                    FROM   th_eng_resource_sn r WITH(NOLOCK)
                                    WHERE  r.master_id = @p_master_id
                                    AND    r.plan_id   = @p_engine_plan_id
                                    -- SCP Capa 공정(Line Modeling 비대상) 
                                    AND    r.descr     IN ('CAPA')
                                    ) b
                      ON     b.site_id   = a.scm_site_id + '~***'
                      AND    b.route_id  LIKE a.operation_id + '%' -- AND    b.line_id   = a.line_id                       
					*/
					INNER JOIN   ( SELECT scm_site_id, ISNULL(fp_plan_period, 0) AS fp_plan_period
										,  ISNULL(prod_frozen, 0) AS prod_frozen   -- 201081130  HASH 추가
									FROM   dbo.scm_mst_site_eng WITH (NOLOCK)  
									WHERE  modeling_id     = @p_modeling_id
									AND    plan_id         = @p_plan_id
									AND    plan_type       = @p_plan_type
									AND    plan_seq        = @p_seq 
									AND    division_id     = @p_division_id
									AND    eng_scm_site_id = scm_site_id + '~***' 
									AND    ISNULL(osp_yn, 'N') = 'N'   --외주 packer 아님
								) c 
					ON  a.eng_res_descr =  'CAPA'  
					AND a.scm_site_id   = c.scm_site_id
					AND a.yyyymmdd     >=  CONVERT(NVARCHAR(8), DATEADD(DD, c.fp_plan_period, @d_plan_name), 112) -- FP_Plan_Load 이후 구간
					AND a.yyyymmdd     <= CASE WHEN c.prod_frozen = @v_plan_horizon THEN @v_pet_date		--2021.05.18 중장기 계획
											   ELSE CONVERT(NVARCHAR(8), DATEADD(DD, c.prod_frozen-1, @d_plan_name), 112) -- <= 조건이므로 (prod_frozen-1)처리
											END 			  
					-- 2018.06.01 ksg DISTINCT 처리
					INNER JOIN   (SELECT DISTINCT SUBSTRING(bom.route_id, 1, 5) AS res_route_id
										, bom.site_id, bom.parent_item_id, bom.route_id
								FROM   th_eng_plan_bom_sn bom WITH (NOLOCK)
								WHERE  master_id = @p_master_id  
								AND    plan_id   = @p_engine_plan_id
								) e                      
					ON   a.scm_site_id + '~***'  = e.site_id 
					AND  a.item_id               = e.parent_item_id  
					AND  a.eng_route_id          = e.route_id
				;

				-- TXN LOG
				SET @n_log_count = @@ROWCOUNT;
				SET @v_log_type = 'TXN';
				SET @v_log_message = 'INSERTINTO '+@v_table_id;
				SET @v_description = N'2-1-3) CAPA  공정(Line 모델링 비대상)...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
				SET @d_event_date = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

				----------------------------------------------------------
				--2-1-4) CAPA  공정(Line 모델링 대상)
						 -- FP_Plan_Load 이후 구간
						 -- scp_anl_production_plan (생산계획)
				----------------------------------------------------------
				INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_FIXED_PLAN_PROD */ th_eng_fixed_plan_sn
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
					SELECT --DISTINCT /* 불필요한 DISTINCT절 주석처리, 2023.02.14 */
						   @p_master_id           AS master_id
						 , @p_engine_plan_id      AS plan_id 
						 , 'WO::LINE_CAPA::' + CONVERT(NVARCHAR(10), 400000000 + ROW_NUMBER() OVER ( ORDER BY  a.yyyymmdd )) AS work_order_id
						 , 1                      AS work_order_seq
						 , a.scm_site_id + '~***' AS site_id                     
						 , a.eng_route_id         AS route_id   -- bom의 route id
						 , a.eng_route_id         AS operation_id
						 , a.item_id
						 , a.eng_resource_id      AS resource_id  -- , b.route_id + '::' + a.scm_site_id + '~***' + '::' + a.line_id AS resource_id
						 , NULL                   AS sub_resource_id
						 , a.yyyymmdd             AS start_dttm
						 , a.yyyymmdd             AS end_dttm  --, DATEADD(d, 1, a.yyyymmdd) AS end_dttm
						 , a.qty                  AS operation_qty
						 , a.qty                  AS complete_qty
						 , 'WO::LINE_CAPA::' + CONVERT(NVARCHAR(10), 400000000 + ROW_NUMBER() OVER ( ORDER BY a.yyyymmdd )) AS lot_id
						 , 'N'                    AS is_fixed
						 , 'Y'                    AS is_prev_schedule
						 , 'START_FIX'            AS keep_work_time_type
						 , 'ALL_QTY_FIX'          AS keep_qty_type
						 , NULL                   AS sales_model_id
						 , NULL                   AS attribute_set_id
						 , NULL                   AS demand_id
						 , 'WO::LINE_CAPA'        AS descr
						 , 'Y'                    AS is_noh_consume        
					FROM #tmp_scp_anl_production_plan a --속도문제로 Cutoff 테이블 사용. 2023.02.14
					     /*  
						 ( SELECT * 
							 FROM   scp_anl_production_plan WITH (NOLOCK)  
							 WHERE  division_id         = @p_division_id  
							 AND    plan_start_yyyymmdd = @p_plan_name 
							 AND    plan_type           = @p_pre_plan_type 
							 AND    seq                 = @p_pre_plan_seq 
							 AND    measure             = 'PROD_PLAN_AMEND'
							 AND    qty                 > 0
							) a     
						  INNER JOIN    (SELECT SUBSTRING(r.resource_group_id, dbo.FN_CHARINDEX_REV(r.resource_group_id, '::', 0)+2, 100) AS line_id
														, r.*
										FROM   th_eng_resource_sn r WITH(NOLOCK)
										WHERE  r.master_id = @p_master_id
										AND    r.plan_id   = @p_engine_plan_id
										-- SCP Capa 공정(Line Modeling 대상 포함) 
										AND    r.descr     IN ('LINE_CAPA')
										) b
						  ON     b.site_id   = a.scm_site_id + '~***'
						  AND    b.route_id  = a.operation_id
						  AND    b.line_id   = a.line_id  
                          */  
						  INNER  JOIN   ( SELECT scm_site_id, ISNULL(fp_plan_period, 0) AS fp_plan_period
											 ,  ISNULL(prod_frozen, 0) AS prod_frozen   -- 201081130  HASH 추가
										 FROM   dbo.scm_mst_site_eng WITH (NOLOCK)  
										 WHERE  modeling_id     = @p_modeling_id
										 AND    plan_id         = @p_plan_id
										 AND    plan_type       = @p_plan_type
										 AND    plan_seq        = @p_seq 
										 AND    division_id     = @p_division_id
										 AND    eng_scm_site_id = scm_site_id + '~***' 
										 AND    ISNULL(osp_yn, 'N') = 'N'   --외주 packer 아님
									   ) c 
						  ON  a.eng_res_descr = 'LINE_CAPA'
						  AND a.scm_site_id   = c.scm_site_id
						  AND a.yyyymmdd     >=  CONVERT(NVARCHAR(8), DATEADD(DD, c.fp_plan_period, @d_plan_name), 112) -- FP_Plan_Load 이후 구간
						  AND a.yyyymmdd     <= CASE WHEN c.prod_frozen = @v_plan_horizon THEN @v_pet_date		--2021.05.18 중장기 계획
											     	 ELSE CONVERT(NVARCHAR(8), DATEADD(DD, c.prod_frozen-1, @d_plan_name), 112) -- <= 조건이므로 (prod_frozen-1)처리
												 END
						  -- 2018.06.01 ksg DISTINCT 처리
						  INNER JOIN   (SELECT DISTINCT SUBSTRING(bom.route_id, 1, 5) AS res_route_id
											 , bom.site_id, bom.parent_item_id, bom.route_id
										FROM   th_eng_plan_bom_sn bom WITH (NOLOCK)
										WHERE  master_id = @p_master_id  
										AND    plan_id   = @p_engine_plan_id
									   ) e                      
						  ON   a.scm_site_id + '~***'  = e.site_id 
						  AND  a.item_id               = e.parent_item_id  
						  AND  a.eng_route_id          = e.res_route_id                      
				;

				-- TXN LOG
				SET @n_log_count = @@ROWCOUNT;
				SET @v_log_type = 'TXN';
				SET @v_log_message = 'INSERTINTO '+@v_table_id;
				SET @v_description = N'2-1-4) CAPA  공정(Line 모델링 대상)...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
				SET @d_event_date = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

                ----------------------------------------------------------
                --2-2) FP 비대상 ( 외주 packer )
                ----------------------------------------------------------
                ----------------------------------------------------------
                --2-2-1) OSP Line Capa 비대상 
                ----------------------------------------------------------                  
                INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_FIXED_PLAN_PROD */ th_eng_fixed_plan_sn
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
                    SELECT --DISTINCT  /* 불필요한 DISTINCT절 주석처리, 2023.02.14 */
                           @p_master_id           AS master_id
                         , @p_engine_plan_id      AS plan_id 
                         , 'WO::OSP::' + CONVERT(NVARCHAR(10), 100000000 + ROW_NUMBER() OVER ( ORDER BY  a.yyyymmdd )) AS work_order_id
                         , 1                      AS work_order_seq
                         , a.eng_site_id          AS site_id
                         , a.eng_route_id		  AS route_id  -- res의 route id
                         , a.eng_route_id		  AS operation_id
                         , a.item_id
                         , a.eng_resource_id      AS resource_id -- , b.route_id + '::' + a.scm_site_id + '~***' + '::' + '-' AS resource_id
                         , NULL					  AS sub_resource_id
                         , a.yyyymmdd			  AS start_dttm
                         , a.yyyymmdd			  AS end_dttm  --, DATEADD(d, 1, a.yyyymmdd) AS end_dttm
                         , a.qty				  AS operation_qty
                         , a.qty				  AS complete_qty
                         , 'WO::OSP::' + CONVERT(NVARCHAR(10), 100000000 + ROW_NUMBER() OVER ( ORDER BY  a.yyyymmdd )) AS lot_id
                         , 'N'					  AS is_fixed
                         , 'Y'					  AS is_prev_schedule
                         , 'START_FIX'			  AS keep_work_time_type
                         , 'ALL_QTY_FIX'		  AS keep_qty_type
                         , NULL					  AS sales_model_id
                         , NULL					  AS attribute_set_id
                         , NULL					  AS demand_id
                         , 'WO::OSP'			  AS descr
                         , 'Y'				      AS is_noh_consume        
                      FROM #tmp_scp_anl_production_plan a  --속도문제로 Cutoff 테이블 사용. 2023.02.14
				     /* 
					  ( SELECT * 
                             FROM   scp_anl_production_plan WITH (NOLOCK)  
                             WHERE  division_id         = @p_division_id  
                             AND    plan_start_yyyymmdd = @p_plan_name 
                             AND    plan_type           = @p_pre_plan_type 
                             AND    seq                 = @p_pre_plan_seq 
                             AND    measure             = 'PROD_PLAN_AMEND'
                             AND    qty                 > 0
                            ) a     
                          INNER JOIN    (SELECT SUBSTRING(r.resource_group_id, dbo.FN_CHARINDEX_REV(r.resource_group_id, '::', 0)+2, 100) AS line_id
                                                        , r.*
                                        FROM   th_eng_resource_sn r WITH(NOLOCK)
                                        WHERE  r.master_id = @p_master_id
                                        AND    r.plan_id   = @p_engine_plan_id
                                        --외주 packer
                                        AND    r.descr     = 'OSP'
                                        ) b
                          ON     b.site_id   = a.scm_site_id + '~***'
                          AND    b.route_id  LIKE a.operation_id + '%' -- AND    b.line_id   = a.line_id                         
                     */
					 INNER JOIN ( SELECT scm_site_id
						               , ISNULL(fp_plan_period, 0) AS fp_plan_period
                                       , ISNULL(prod_frozen, 0)    AS prod_frozen --20190604 추가     -- 201081130  HASH 추가
								    FROM dbo.scm_mst_site_eng WITH (NOLOCK)  
								   WHERE 1 =1
									 AND modeling_id     = @p_modeling_id
									 AND plan_id         = @p_plan_id
									 AND plan_type       = @p_plan_type
									 AND plan_seq        = @p_seq 
									 AND division_id     = @p_division_id
									 AND eng_scm_site_id = scm_site_id + '~***' 
									 AND ISNULL(osp_yn, 'N')                 = 'Y'  --외주 packer
									 AND DBO.FN_SCM_SYS_NVL(attribute1, 'N') = 'N'  --외주 packer Line Capa 비대상
								) c 
                           ON a.eng_res_descr = 'OSP'
						  AND a.scm_site_id  = c.scm_site_id
                          AND a.yyyymmdd    >= @p_plan_name 
                          AND a.yyyymmdd    <= CASE WHEN c.prod_frozen = @v_plan_horizon THEN @v_pet_date		--2021.05.18 중장기 계획
                                                    ELSE CONVERT(NVARCHAR(8), DATEADD(DD, c.prod_frozen-1, @d_plan_name), 112) -- <= 조건이므로 (prod_frozen-1)처리
                                               END 			  
			              -- 2018.06.01 ksg DISTINCT 처리
                          INNER JOIN   (SELECT DISTINCT SUBSTRING(bom.route_id, 1, 5) AS res_route_id
                                             , bom.site_id, bom.parent_item_id, bom.route_id
                                        FROM   th_eng_plan_bom_sn bom WITH (NOLOCK)
                                        WHERE  master_id = @p_master_id --'81::WEEKLY'
                                        AND    plan_id   = @p_engine_plan_id
                                       ) e                          
                          ON   a.scm_site_id + '~***'  = e.site_id 
                          AND  a.item_id               = e.parent_item_id  
                          AND  a.eng_route_id              = e.route_id                          
                ;

                -- TXN LOG
                SET @n_log_count = @@ROWCOUNT;
                SET @v_log_type = 'TXN';
                SET @v_log_message = 'INSERTINTO '+@v_table_id;
                SET @v_description = N'2-2-1) OSP Line Capa 비대상...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
                SET @d_event_date = SYSDATETIME();
                EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

                ----------------------------------------------------------
                --2-2-2) OSP_L Line Capa 대상 : 2020.02.03  [OSP Line Plan] OSP이면서 Line별 Capa 적용 Site 확정계획 추가     
                ----------------------------------------------------------                  
                INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_FIXED_PLAN_PROD */ th_eng_fixed_plan_sn
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
                    SELECT --DISTINCT /* 불필요한 DISTINCT절 주석처리, 2023.02.14 */
                           @p_master_id           AS master_id
                         , @p_engine_plan_id      AS plan_id 
                         , 'WO::OSP_L::' + CONVERT(NVARCHAR(10), 100000000 + ROW_NUMBER() OVER ( ORDER BY  a.yyyymmdd )) AS work_order_id
                         , 1                      AS work_order_seq
                         , a.scm_site_id + '~***' AS site_id
                         , a.eng_route_id		  AS route_id  -- res의 route id
                         , a.eng_route_id		  AS operation_id
                         , a.item_id
                         , a.eng_resource_id      AS resource_id -- , b.route_id + '::' + a.scm_site_id + '~***' + '::' + '-' AS resource_id
                         , NULL                   AS sub_resource_id
                         , a.yyyymmdd			  AS start_dttm
                         , a.yyyymmdd			  AS end_dttm  --, DATEADD(d, 1, a.yyyymmdd) AS end_dttm
                         , a.qty                  AS operation_qty
                         , a.qty                  AS complete_qty
                         , 'WO::OSP_L::' + CONVERT(NVARCHAR(10), 100000000 + ROW_NUMBER() OVER ( ORDER BY  a.yyyymmdd )) AS lot_id
                         , 'N'                    AS is_fixed
                         , 'Y'                    AS is_prev_schedule
                         , 'START_FIX'            AS keep_work_time_type
                         , 'ALL_QTY_FIX'          AS keep_qty_type
                         , NULL                   AS sales_model_id
                         , NULL                   AS attribute_set_id
                         , NULL                   AS demand_id
                         , 'WO::OSP_L'            AS descr
                         , 'Y'                    AS is_noh_consume        
                     FROM   #tmp_scp_anl_production_plan a  --속도문제로 Cutoff 테이블 사용. 2023.02.14   
                     /*
					 ( SELECT * 
                             FROM   scp_anl_production_plan WITH (NOLOCK)  
                             WHERE  division_id         = @p_division_id  
                             AND    plan_start_yyyymmdd = @p_plan_name 
                             AND    plan_type           = @p_pre_plan_type 
                             AND    seq                 = @p_pre_plan_seq 
                             AND    measure             = 'PROD_PLAN_AMEND'
                             AND    qty                 > 0
                            ) a     
                          INNER JOIN    (SELECT SUBSTRING(r.resource_group_id, dbo.FN_CHARINDEX_REV(r.resource_group_id, '::', 0)+2, 100) AS line_id
                                                        , r.*
                                        FROM   th_eng_resource_sn r WITH(NOLOCK)
                                        WHERE  r.master_id = @p_master_id
                                        AND    r.plan_id   = @p_engine_plan_id
                                        --외주 packer
                                        AND    r.descr     = 'OSP_L'
                                        ) b
                          ON     b.site_id   = a.scm_site_id + '~***'
                          AND    b.route_id  = a.operation_id 
                          AND    b.line_id   = a.line_id                      
                     */
					 INNER JOIN   ( SELECT scm_site_id
					 	                , ISNULL(fp_plan_period, 0) AS fp_plan_period
                                        , ISNULL(prod_frozen, 0) AS prod_frozen  -- 201081130  HASH 추가
					 				 FROM dbo.scm_mst_site_eng WITH (NOLOCK)  
					 				WHERE 1 =1
					 				  AND modeling_id     = @p_modeling_id
					 				  AND plan_id         = @p_plan_id
					 				  AND plan_type       = @p_plan_type
					 				  AND plan_seq        = @p_seq 
					 				  AND division_id     = @p_division_id
					 				  AND eng_scm_site_id = scm_site_id + '~***' 
					 				  AND ISNULL(osp_yn, 'N')                 = 'Y'  --외주 packer
					 				  AND DBO.FN_SCM_SYS_NVL(attribute1, 'N') = 'Y'  --외주 packer Line Capa 대상
                                 ) c 
                      ON a.eng_res_descr = 'OSP_L'
					 AND a.scm_site_id  = c.scm_site_id
                     AND a.yyyymmdd    >= @p_plan_name 
					 AND a.yyyymmdd    <= CASE WHEN c.prod_frozen = @v_plan_horizon THEN @v_pet_date		--2021.05.18 중장기 계획
                                               ELSE CONVERT(NVARCHAR(8), DATEADD(DD, c.prod_frozen-1, @d_plan_name), 112) -- <= 조건이므로 (prod_frozen-1)처리
                                           END 			  
			         -- 2018.06.01 ksg DISTINCT 처리
                     INNER JOIN  (SELECT DISTINCT SUBSTRING(bom.route_id, 1, 5) AS res_route_id
                                       , bom.site_id, bom.parent_item_id, bom.route_id
                                 FROM   th_eng_plan_bom_sn bom WITH (NOLOCK)
                                 WHERE  master_id = @p_master_id --'81::WEEKLY'
                                 AND    plan_id   = @p_engine_plan_id
                                 ) e                          
                      ON a.scm_site_id + '~***'  = e.site_id 
                     AND a.item_id               = e.parent_item_id  
                     AND a.eng_route_id          = e.route_id                          
                 ;

                -- TXN LOG
                SET @n_log_count = @@ROWCOUNT;
                SET @v_log_type = 'TXN';
                SET @v_log_message = 'INSERTINTO '+@v_table_id;
                SET @v_description = N'2-2-2) OSP_L Line Capa 대상...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
                SET @d_event_date = SYSDATETIME();
                EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        END
     
        -------------------------------------------------------------
        --3. FIX 정보 공통적용 
        --  구간 : 플랜시작일+prod_frozen 이후,  참조테이블 : scp_anl_production_plan_fix
        --  이 로직은 그냥 유지해도 문제 없을 것 같은데, 좀 더 고민을 해 보자~, 2024.10.07 
        -------------------------------------------------------------
        
        ----------------------------------------------------------
        -- 3-1) FIX : Capa공정이면서 Line 모델링 비대상
        ----------------------------------------------------------        
		INSERT INTO /*PR_SCP_ENG_IN_FN_PROC_FIXED_PLAN_PROD*/ th_eng_fixed_plan_sn
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
        FROM   scp_anl_production_plan_fix a WITH (NOLOCK)             
                INNER JOIN    (SELECT SUBSTRING(r.resource_group_id, dbo.FN_CHARINDEX_REV(r.resource_group_id, '::', 0)+2, 100) AS line_id
                                            , r.*
                            FROM   th_eng_resource_sn r WITH(NOLOCK)
                            WHERE  r.master_id = @p_master_id
                            AND    r.plan_id   = @p_engine_plan_id
                            -- SCP Capa 공정이면서 Line Modeling 비대상 공정 
                            AND    r.descr     = 'CAPA' 
                            ) b      
                ON     b.site_id   = a.scm_site_id + '~***'
                -- Line Modeling 비대상
                AND    b.route_id  LIKE a.operation_id + '%'
                -- AND    b.line_id   = a.line_id
                INNER JOIN   ( SELECT scm_site_id, ISNULL(fp_plan_period, 0) AS fp_plan_period
                                    ,  ISNULL(prod_frozen, 0) AS prod_frozen 
                                FROM   dbo.scm_mst_site_eng WITH (NOLOCK)  
                                WHERE  modeling_id     = @p_modeling_id
                                AND    plan_id         = @p_plan_id
                                AND    plan_type       = @p_plan_type
                                AND    plan_seq        = @p_seq 
                                AND    division_id     = @p_division_id
                                AND    eng_scm_site_id = scm_site_id + '~***' 
                                AND    ISNULL(osp_yn, 'N') = 'N'   --외주 packer 아님 
                            ) c               
                --ON     a.yyyymmdd    >= CONVERT(NVARCHAR(8), DATEADD(DD, c.prod_frozen, @d_plan_name), 112)  
				-- [C20200304-000426] 364인 경우와 아닌 경우 분리
                --ON     a.yyyymmdd    >= CASE WHEN c.prod_frozen = 364 THEN DATEADD(DD, 1, @v_pet_date)
				ON   a.yyyymmdd    >= CASE WHEN c.prod_frozen = @v_plan_horizon THEN DATEADD(DD, 1, @v_pet_date)		--2021.05.18 중장기 계획
                                            ELSE CONVERT(NVARCHAR(8), DATEADD(DD, c.prod_frozen, @d_plan_name), 112)
                                        END            
                AND    a.yyyymmdd    <= @v_pet_date        
                AND    a.scm_site_id  = c.scm_site_id			  
			    -- 2018.06.01 ksg DISTINCT 처리
                INNER JOIN   (SELECT DISTINCT SUBSTRING(bom.route_id, 1, 5) AS res_route_id
                                    , bom.site_id, bom.parent_item_id, bom.route_id
                            FROM   th_eng_plan_bom_sn bom WITH (NOLOCK)
                            WHERE  master_id = @p_master_id  
                            AND    plan_id   = @p_engine_plan_id
                            ) e			  
                ON   a.scm_site_id + '~***'  = e.site_id 
                AND  a.item_id               = e.parent_item_id  
                AND  b.route_id              = e.route_id			   
        WHERE  1=1
        AND    a.division_id = @p_division_id   
        AND    a.qty    > 0 
		/* TM버전은 FIX 데이터 미생성, 2021/05/26, By KKC */
		AND 1= CASE WHEN @p_plan_type = 'TM' THEN 0
					ELSE 1
				END
        ; 

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERTINTO '+@v_table_id;
        SET @v_description = N'3-1) FIX CAPA  공정(Line 모델링 비대상)...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
				
        ----------------------------------------------------------
        -- 3-2) FIX : Capa공정이면서 Line 모델링 대상
        ----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_FIXED_PLAN_PROD */ th_eng_fixed_plan_sn
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
        FROM   scp_anl_production_plan_fix a WITH (NOLOCK)      
                INNER  JOIN  (SELECT SUBSTRING(r.resource_group_id, dbo.FN_CHARINDEX_REV(r.resource_group_id, '::', 0)+2, 100) AS line_id
                                            , r.*
                            FROM   th_eng_resource_sn r WITH(NOLOCK)
                            WHERE  r.master_id = @p_master_id
                            AND    r.plan_id   = @p_engine_plan_id
                            -- SCP Capa 공정이면서 Line Modeling 대상 공정 
                            AND    r.descr     = 'LINE_CAPA' 
                            ) b
                ON     b.site_id   = a.scm_site_id + '~***'
                -- Line Modeling 대상
                AND    b.route_id  = a.operation_id
                AND    b.line_id   = a.line_id
                INNER JOIN   ( SELECT scm_site_id, ISNULL(fp_plan_period, 0) AS fp_plan_period
                                    ,  ISNULL(prod_frozen, 0) AS prod_frozen
                                FROM   dbo.scm_mst_site_eng WITH (NOLOCK)  
                                WHERE  modeling_id     = @p_modeling_id
                                AND    plan_id         = @p_plan_id
                                AND    plan_type       = @p_plan_type
                                AND    plan_seq        = @p_seq 
                                AND    division_id     = @p_division_id
                                AND    eng_scm_site_id = scm_site_id + '~***' 
                                AND    ISNULL(osp_yn, 'N') = 'N'   --외주 packer 아님 
                            ) c 
                --ON     a.yyyymmdd    >= CONVERT(NVARCHAR(8), DATEADD(DD, c.prod_frozen, @d_plan_name), 112)       
				-- [C20200304-000426] 364인 경우와 아닌 경우 분리
                --ON     a.yyyymmdd    >= CASE WHEN c.prod_frozen = 364 THEN DATEADD(DD, 1, @v_pet_date)
				ON   a.yyyymmdd    >= CASE WHEN c.prod_frozen = @v_plan_horizon THEN DATEADD(DD, 1, @v_pet_date)		--2021.05.18 중장기 계획
                                            ELSE CONVERT(NVARCHAR(8), DATEADD(DD, c.prod_frozen, @d_plan_name), 112)
                                    END            
                AND    a.yyyymmdd    <= @v_pet_date               
                AND    a.scm_site_id  = c.scm_site_id			  
			    -- 2018.06.01 ksg DISTINCT 처리
                INNER JOIN   (SELECT DISTINCT SUBSTRING(bom.route_id, 1, 5) AS res_route_id
                                    , bom.site_id, bom.parent_item_id, bom.route_id
                            FROM   th_eng_plan_bom_sn bom WITH (NOLOCK)
                            WHERE  master_id = @p_master_id  
                            AND    plan_id   = @p_engine_plan_id
                            ) e
                ON    a.scm_site_id + '~***'  = e.site_id 
                AND   a.item_id               = e.parent_item_id  
                AND   b.route_id              = e.res_route_id             			   
        WHERE a.division_id = @p_division_id   
            AND a.qty    > 0
			/* TM버전은 FIX 데이터 미생성, 2021/05/26, By KKC */
			AND 1= CASE WHEN @p_plan_type = 'TM' THEN 0
						ELSE 1
					END

        ;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERTINTO '+@v_table_id;
        SET @v_description = N'3-2) FIX  Line 모델링 대상...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
								 
        ----------------------------------------------------------
        -- 3-3) FIX : OSP 
        ----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_FIXED_PLAN_PROD */ th_eng_fixed_plan_sn
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
        FROM   scp_anl_production_plan_fix a WITH (NOLOCK) -- PR_SCP_ENG_IN_PRE_PROC_BUCKET_RES_CAPA 의 work_time = 0 처리부분 수정해야함
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
                INNER JOIN   (  SELECT scm_site_id, ISNULL(fp_plan_period, 0) AS fp_plan_period
                                    ,  ISNULL(prod_frozen, 0) AS prod_frozen 
                                FROM   dbo.scm_mst_site_eng WITH (NOLOCK)  
                                WHERE  1 =1
                                AND    modeling_id     = @p_modeling_id
                                AND    plan_id         = @p_plan_id
                                AND    plan_type       = @p_plan_type
                                AND    plan_seq        = @p_seq 
                                AND    division_id     = @p_division_id
                                AND    eng_scm_site_id = scm_site_id + '~***' 
                                AND    ISNULL(osp_yn, 'N')                 = 'Y'  --외주 packer
                                AND    DBO.FN_SCM_SYS_NVL(attribute1, 'N') = 'N'  --외주 packer Line Capa 비대상
                            ) c 
                --ON    a.yyyymmdd    >= CONVERT(NVARCHAR(8), DATEADD(DD, c.prod_frozen, @d_plan_name), 112)
				-- [C20200304-000426] 364인 경우와 아닌 경우 분리
                --ON     a.yyyymmdd   >= CASE WHEN c.prod_frozen = 364 THEN DATEADD(DD, 1, @v_pet_date)
				ON   a.yyyymmdd    >= CASE WHEN c.prod_frozen = @v_plan_horizon THEN DATEADD(DD, 1, @v_pet_date)		--2021.05.18 중장기 계획
                                            ELSE CONVERT(NVARCHAR(8), DATEADD(DD, c.prod_frozen, @d_plan_name), 112)
                                        END            
                AND   a.yyyymmdd    <= @v_pet_date
                AND   a.scm_site_id  = c.scm_site_id			  
		  	    -- 2018.06.01 ksg DISTINCT 처리
                INNER JOIN   (SELECT DISTINCT SUBSTRING(bom.route_id, 1, 5) AS res_route_id
                                    , bom.site_id, bom.parent_item_id, bom.route_id
                                FROM   th_eng_plan_bom_sn bom WITH (NOLOCK)
                                WHERE  master_id = @p_master_id  
                                AND    plan_id   = @p_engine_plan_id
                                ) e
                ON   a.scm_site_id + '~***'  = e.site_id 
                AND  a.item_id               = e.parent_item_id  
                AND  b.route_id              = e.route_id
        WHERE a.division_id = @p_division_id     
            AND a.qty    > 0 
			/* TM버전은 FIX 데이터 미생성, 2021/05/26, By KKC */
			AND 1= CASE WHEN @p_plan_type = 'TM' THEN 0
					  	ELSE 1
					END

        ;          

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERTINTO '+@v_table_id;
        SET @v_description = N'3-3) FIX OSP...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
								 
		----------------------------------------------------------
		-- 3-4) FIX : [OSP Line Plan] OSP_L Line Capa 대상
		-- 2020.02.03  [OSP Line Plan] OSP이면서 Line별 Capa 적용 Site 확정계획 추가
		----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_FIXED_PLAN_PROD */ th_eng_fixed_plan_sn
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
                INNER JOIN    (SELECT SUBSTRING(r.resource_group_id, dbo.FN_CHARINDEX_REV(r.resource_group_id, '::', 0)+2, 100) AS line_id
                                            , r.*
                            FROM   th_eng_resource_sn r WITH(NOLOCK)
                            WHERE  r.master_id = @p_master_id
                            AND    r.plan_id   = @p_engine_plan_id
                            -- 외주 packer 
                            AND    r.descr     = 'OSP_L'
                            ) b
                ON     b.site_id   = a.scm_site_id + '~***'
                AND    b.route_id  = a.operation_id
                AND    b.line_id   = a.line_id                          
                INNER JOIN   (  SELECT scm_site_id, ISNULL(fp_plan_period, 0) AS fp_plan_period
                                    ,  ISNULL(prod_frozen, 0) AS prod_frozen 
                                FROM   dbo.scm_mst_site_eng WITH (NOLOCK)  
                                WHERE  1 =1
                                AND    modeling_id     = @p_modeling_id
                                AND    plan_id         = @p_plan_id
                                AND    plan_type       = @p_plan_type
                                AND    plan_seq        = @p_seq 
                                AND    division_id     = @p_division_id
                                AND    eng_scm_site_id = scm_site_id + '~***' 
                                AND    ISNULL(osp_yn, 'N')                 = 'Y'  --외주 packer
                                AND    DBO.FN_SCM_SYS_NVL(attribute1, 'N') = 'Y'  --외주 packer Line Capa 대상
                            ) c 
                --ON    a.yyyymmdd    >= CONVERT(NVARCHAR(8), DATEADD(DD, c.prod_frozen, @d_plan_name), 112)
				-- [C20200304-000426] 364인 경우와 아닌 경우 분리
                --ON     a.yyyymmdd   >= CASE WHEN c.prod_frozen = 364 THEN DATEADD(DD, 1, @v_pet_date)
				ON   a.yyyymmdd    >= CASE WHEN c.prod_frozen = @v_plan_horizon THEN DATEADD(DD, 1, @v_pet_date)		--2021.05.18 중장기 계획
                                            ELSE CONVERT(NVARCHAR(8), DATEADD(DD, c.prod_frozen, @d_plan_name), 112)
                                        END 
                AND   a.yyyymmdd    <= @v_pet_date
                AND   a.scm_site_id  = c.scm_site_id			  
		  	    -- 2018.06.01 ksg DISTINCT 처리
                INNER JOIN   (SELECT DISTINCT SUBSTRING(bom.route_id, 1, 5) AS res_route_id
                                    , bom.site_id, bom.parent_item_id, bom.route_id
                                FROM   th_eng_plan_bom_sn bom WITH (NOLOCK)
                                WHERE  master_id = @p_master_id  
                                AND    plan_id   = @p_engine_plan_id
                                ) e
                ON   a.scm_site_id + '~***'  = e.site_id 
                AND  a.item_id               = e.parent_item_id  
                AND  b.route_id              = e.route_id
        WHERE a.division_id = @p_division_id   
            AND a.qty    > 0 
 			/* TM버전은 FIX 데이터 미생성, 2021/05/26, By KKC */
			AND 1= CASE WHEN @p_plan_type = 'TM' THEN 0
						ELSE 1
					END
        ;          

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERTINTO '+@v_table_id;
        SET @v_description = N'3-4) FIX OSP_L Line CAPA 대상...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;             

        -------------------------------------------------------------
        --4. MA, SE, FN  공통적용 
        -------------------------------------------------------------
        
        -------------------------------------------------------------    
        --4-1) operation_qty 값에 수율 적용
                -- [th_eng_fixed_plan_sn.operation_qty] = [CEILING(th_eng_fixed_plan_sn.complete_qty / th_eng_op_res_group_map_sn.yield)]  올림값을 셋팅
        -------------------------------------------------------------
        UPDATE th_eng_fixed_plan_sn 
          SET  operation_qty = ROUND(a.complete_qty / ISNULL(bb.yield, b.yield), 5)
        --SET    operation_qty = ROUND(a.complete_qty / b.yield, 5)               
         FROM th_eng_fixed_plan_sn a
              INNER JOIN ( SELECT master_id
                                , plan_id
                                , item_id
                                , CASE WHEN yield = 0 THEN 1
                                    WHEN yield > 1 THEN 1
                                    ELSE ISNULL(yield, 1)
                                END AS yield
                                , resource_group_id
                        FROM  th_eng_op_res_group_map_sn WITH (NOLOCK)
                        WHERE  master_id = @p_master_id 
                        AND    plan_id   = @p_engine_plan_id  
                        --AND    descr     = 'LINE_CAPA'                       
                        ) b
            ON  a.master_id    = b.master_id 
            AND a.plan_id      = b.plan_id 
            AND a.item_id      = b.item_id 
            AND a.resource_id  = b.resource_group_id
        LEFT JOIN  ( SELECT master_id
                            , plan_id
                            , item_id
                            , CASE WHEN yield = 0 THEN 1
                                WHEN yield > 1 THEN 1
                                ELSE ISNULL(yield, 1)
                            END AS yield
                            , resource_group_id
							, start_dttm
							, end_dttm
                    FROM  th_eng_op_res_group_map_cal_sn WITH (NOLOCK)
                    WHERE  master_id = @p_master_id       
                    AND    plan_id   = @p_engine_plan_id  
                    --AND    descr     = 'LINE_CAPA'                       
                    ) bb
        ON  a.master_id    = bb.master_id 
        AND a.plan_id      = bb.plan_id 
        AND a.item_id      = bb.item_id 
        AND a.resource_id  = bb.resource_group_id
        AND a.end_dttm    >= bb.start_dttm
        AND a.end_dttm    <  bb.end_dttm
        WHERE  a.master_id = @p_master_id      
        AND    a.plan_id   = @p_engine_plan_id 
        --AND    a.descr     = 'WO::LINE_CAPA'
        ;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'UPDATE '+@v_table_id;
        SET @v_description = N'Operation_qty...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

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
        --     참고)  FIX정보(scp_anl_production_plan_fix 테이블)가 있는 Line/구간은 Working Time 을 0 으로 설정 : Bucket Res Capa 
        --            PR_SCP_ENG_IN_PRE_PROC_BUCKET_RES_CAPA 의 work_time = 0 처리부분 수정해야함    
        ----------------------------------------------------------

        ----------------------------------------------------------
        -- * FIXED_PLAN 내 확정 W/O, D/O 의 WORKORDER_SEQ 생성 : 2018.06.07
		--   FIXED_PLAN 전체 생성뒤 마지막으로 처리함
        -- 2018.07.05   CELL Biz Fix용 가상 BOD 형성 : Fix Mismatching에서 처리하도록 수정함
        ----------------------------------------------------------

		--TMP테이블 정리
		IF OBJECT_ID('tempdb..#tmp_scp_anl_production_plan') IS NOT NULL
			BEGIN 
				DROP TABLE  #tmp_scp_anl_production_plan;          
			END 

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id;
        SET @v_description = N'Process Complete...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
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
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    return 1

  END;
