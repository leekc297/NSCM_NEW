
/*                  
 * Program ID   : PR_SCP_ENG_EE_FN_PROC_DEMAND_ATTRIBUTE
 * Description  : 
                -----------------------------------------------------------
                -- 1. DEMAND 생성 (Demand Attribute 생성을 위한 최소한의 컬럼값만 생성함)
                -----------------------------------------------------------
                    - 1) DM demand의 전극 demand 만 처리함(전극)
                    - 2) SCP의 Cell 생산 계획을 Demand로 반영(셀)

                    - 여기서는 Demand Attribute 생성을 위한 최소한의 컬럼값만 생성함 
                      최종 th_eng_demand_sn테이블의 데이터 생성은 
                      PR_SCP_ENG_EE_PRE_PROC_NET_DEMAND 프로시저에서 생성완료함  
        
                -----------------------------------------------------------
                -- 2.  DEMAND ATTRIBUTE 생성
                -----------------------------------------------------------
                    - 대상1) (전극)DM demand의 전극 demand 만 처리함
                    - 대상2) (셀) SCP의 Cell 생산 계획을 Demand로 반영
        
                    참고 컬럼1)  demand_group_id
                 
                         - 경우1 ( DM용demand  dm_pln_net_demand 테이블 )
                             ==> item_id + '::' + project_code + '::' + scm_site_id
		                         + '~' + incoterms + '::' + dom_exp + '::' + fcst_type
		         	             + '::' + demand_type + '::' + yyyymmdd + '::' + plant_site_id
                   
                                 ex) ACEN1021U-A1::A15FD3001::Ford_US_RDF~DDP::E::MPS::NF::20180806::A040-A


                         - 경우2 ( SCP의 Cell 생산 계획을 Demand )
                             ==> item_id + '::' + line_id + '::' + scm_site_id
		                         + '~' + incoterms('EXW' 하드코딩함) + '::' + dom_exp('D' 하드코딩함) + '::' + fcst_type('MPS'로 하드코딩함)
		         	             + '::' + demand_type('CF'하드코딩함) + '::' + yyyymmdd + '::' + plant_site_id
                   
                                 ex) APCAN0543A::E6D01::A041-E-S::D::MPS::CF::20180806::A041-E
         
                -----------------------------------------------------------
                -- 3. th_eng_demand_sn 업데이트       
                      - 셀일때 하위전극의 MIN Daily CAPA
                      - (처리안함, 셀일때 하위전극으로 처리하므로) SETUP GROUP ID 관련 정보 
                      - shipping_date
                -----------------------------------------------------------    

 * OutTable     : th_eng_demand_attribute
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.07.06   KSW         Initial Release  전지본부 GSCM(DM/SCP) 구축 프로젝트
 * 2018.08.08   KSW         기존 PR DEMAND 데이터 복사 -> DEMAND 데이터 신규생성으로 변경 ( scp_pln_elec_demand_cell_plan 테이블이 plan_type별로 데이터가 변경될수 있으므로 ) 
 * 2018.09.03   KSW         셀을 셀 하위 전극으로  split 하기위한 수정 
 * 2018.09.28   KSW         1) 전극 tact_time 계산시 사용되는 lane_qty 컬럼 대상 테이블 변경(scm_mst_item_lane_m_sn.lane_qty -> scm_mst_item_line_assign_sn.lane_qty)  참고) 주석3-1
                            2) 소형(40)이면서 전극일때 tact_time 처리부분 수정 ( 현재 전극의 tact_time 처리시 item_uom(단위)와 tact_time 불일치(item_uom : 'EA' 인데 tact_tiem 은 'M' 단위 일때의 값으로 셋팅되어있음 ) )  참고)주석3-1
 * 2018.10.01   KSW         외주 전극 ***만 생성( 외주전극 : 002, 003 생성제외)
 * 2018.10.11   KSW         nlevel 조회조건 부분 수정 참고)주석2-1-1)
 * 2018.11.29   KSW         1) 속도개선 scm_mst_bom_effective_sn 테이블 힌트적용 참고)주석2-1-1)
                            2) nlevel 조회조건 수정참고)주석2-1-1)
 * 2018.12.11   KSG         due_fence_date 값 수정 : 플랜종료월(@v_pet_date) + 추가 Bucket(13*7) 
 * 2019.09.17   KSG         전극 Model Allocation 적용
 * 2020.03.23   KSG         [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - Hold VMI 대기 재고 Visibility 강화
 * 2020.04.27   KSG         C20200403-000046 전극SCP 시뮬레이터 內 조립계획 I/F 기준 변경
 *                              : PR 이 아닌 경우 PR의 정보를 Copy하여 생성함
 *                              : Copy하지 않도록 하는 경우 PR_SCP_PLN_ELEC_DEMAND_CELL_PLAN 함께 수정 필요
 * 2020.07.14   KSG         [전지 공급 대응력 향상을 위한 SCM 관리 체계 개선] 전극 Main Plan 추가 및 Engine Run 기준 설정
 *                              : MA - Copy하지 않고 재처리 : 조립계획은 ELEC_DEMAND_CELL_PLAN 에서 PR외는 PR 정보 Copy하여 생성하므로 동일함
 *                                FN - MA 정보 Copy하여 사용
 * 2021.03.12   KSG         PJ20209642 Digital SCM Level.3 달성을 위한 개선 : FP Tact Time Table 변경
 * 2021.04.08   SEO         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - SCP 대치BOM 적용
 * 2021.06.07   SEO			PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - ITEM BOD의 유효일자를 BOD의 유효일자로 대체
 * 2021.07.07   KKC			PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - bod view 변경(scp_mst_bod_v -> scp_mst_bod_n_v)
 * 2021.08.12   KKC         PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선(Phase 2) - DEMAND MERGE 옵션 기능 구현
 * 2022.01.26   LHS			PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선: 사업부별 추가 계획수립기간을 lookup으로 설정하여 Engine Plan 기간으로 반영
 * 2022.03.02   LHS			PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선: 사업부별 추가 Demand 구간을  lookup으로 설정하여 반영
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

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_EE_FN_PROC_DEMAND_ATTRIBUTE]  
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
    
    DECLARE @p_pre_plan_type NVARCHAR(4000) = @p_pre_plan_type1;
    DECLARE @p_pre_plan_seq  NVARCHAR(4000) = @p_pre_plan_seq1;
    DECLARE @p_pre_engine_plan_id NVARCHAR(4000) = @p_pre_engine_plan_id1; 
    
    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_EE_FN_PROC_DEMAND_ATTRIBUTE';
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
	DECLARE @v_add_pet_date      NVARCHAR(8) ; -- 추가기간 반영된 Plan End Date (2022.01.26)

	DECLARE @v_merge_yn     NVARCHAR(1);                 --2021.08.12 추가, By KKC
    DECLARE @v_merge_days   INTEGER = 0;                 --2021.08.12 추가, By KKC
    DECLARE @v_merge_weekly_start_yyyymmdd NVARCHAR(8);  --2021.08.12 추가, By KKC

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
         , @v_division_comp    =  di.ATTRIBUTE4
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

    -------------------------------------------------------------------------------------
    -- [전지 공급 대응력 향상을 위한 SCM 관리 체계 개선] : FN이면 이전 Plan 정보 Copy
    -------------------------------------------------------------------------------------
    IF @p_plan_type = 'FN'
    BEGIN

        DELETE /* PR_SCP_ENG_EE_FN_PROC_DEMAND_ATTRIBUTE */
        FROM   th_eng_demand_attribute_sn
        WHERE  master_id = @p_master_id
        AND    plan_id   = @p_engine_plan_id 
        ;
        -----------------------------------------------------------
        
         INSERT INTO /* PR_SCP_ENG_EE_FN_PROC_DEMAND_ATTRIBUTE */ dbo.th_eng_demand_attribute_sn
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
          SELECT @p_master_id      AS master_id
              ,  @p_engine_plan_id AS plan_id
              ,  demand_group_id
              ,  preference_site_id
              ,  preference_route_id
              ,  preference_operation_id
              ,  preference_resource_id
              ,  preference_product_id
              ,  mix_flow_id
              ,  mix_load_id
              ,  kitting_id
              ,  input_start_dttm
              ,  is_hard_preference
              ,  descr
              ,  preference_route_resource_id
          FROM   th_eng_demand_attribute_sn WITH (NOLOCK)
          WHERE  master_id = @p_master_id
          AND    plan_id   = @p_pre_engine_plan_id
          ;

    END; --IF @p_plan_type = 'FN' THEN   

    -------------------------------------------------------------------------------------
    -- [전지 공급 대응력 향상을 위한 SCM 관리 체계 개선] : MA 이면 재처리
    -------------------------------------------------------------------------------------
    IF @p_plan_type = 'MA' or @p_plan_type = 'SE' -- 20250918 YMH 임시추가
    BEGIN

/*        --  Plan End Date
        SELECT @v_pet_date = p.horizon_end_date
        FROM   dbo.scm_mst_plan p WITH(NOLOCK)
        WHERE  p.division_id = @p_division_id 
        AND    p.plan_id     = @p_plan_id ;
*/ 

        --  Plan End Date ( 2022.01.26 )
        SELECT /* @v_pet_date      = p.horizon_end_date    --> (2022.03.02) 이전 코드 주석처리   */
               @v_pet_date      = CONVERT(NVARCHAR(8), DATEADD(dd, ISNULL(c.dm_add_day,0), CONVERT(DATETIME, P.horizon_end_date)), 112)   --- (2022.03.02) Demand 추가기간 반영
			,  @v_add_pet_date  = CONVERT(NVARCHAR(8), DATEADD(dd, ISNULL(B.add_day, (13*7)), CONVERT(DATETIME, P.HORIZON_END_DATE)), 112)   -- 추가기간이 NULL이면 디폴트 13주 설정 
        FROM   dbo.scm_mst_plan p WITH(NOLOCK)
		LEFT OUTER JOIN 
			  ( /** (2022.01.26) 사업부별 추가계획기간 lookup으로 반영. 단위:week  **/ 
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

        -----------------------------------------------------------
        -- 사업부별 demand cutoff 일자  --20180627 추가
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#DEMAND_CUTOFF_YYYYMMDD') IS NOT NULL
        BEGIN 
            DROP TABLE  #DEMAND_CUTOFF_YYYYMMDD          
        END 

        -- 최근 7일 이내 최신 버전
        SELECT division_id
             , ISNULL(MAX(p.cutoff_yyyymmdd)
                      , CONVERT(CHAR(8), DATEADD(DD, -6, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 당주 화요일 YYYYMMDD
                     ) AS demand_cutoff_yyyymmdd
        INTO   #DEMAND_CUTOFF_YYYYMMDD
        FROM   dbo.dm_pln_net_demand p WITH(NOLOCK)
        WHERE  p.cutoff_yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, @d_plan_name), 112) 
        --AND    p.division_id      = @p_division_id 
        GROUP BY division_id
		;

		-----------------------------------------------------------
		-- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선
		-- Merge 관련 변수 설정, 2021.08.12, By KKC
        -----------------------------------------------------------
		SELECT @v_merge_yn    = ISNULL(a.segment2, 'N') 
			 , @v_merge_days = ISNULL(CONVERT(INTEGER, a.segment3), 0)
		 FROM scm_adm_lookup_master_detail a(nolock)
		WHERE a.lookup_type = 'DEMAND_MERGE_YN'
          AND a.segment1         =  @p_division_id   ---2022.04.04 추가: 해당 DIVISION_ID의 MERGE여부 체크
          AND @v_division_group  = 'EE'              ---2022.04.04 전극 영역검색
		/* 20220404변경전 
          AND a.SEGMENT1 = 'EE' --@p_division_id    */ 
		;

		--Daily Merge Period 변수 Validation Check, 2021.08.12, By KKC
		IF @v_merge_days IS NULL
		   BEGIN
		       SET @v_merge_days = 0;
		   END

		IF @v_merge_yn IS NULL OR @v_merge_yn != 'Y'
		   BEGIN
		       SET @v_merge_yn = 'N';
		   END
        
		--merge weekly start yyyymmdd 설정
		IF @v_merge_days = 0
		   BEGIN
		       SET @v_merge_weekly_start_yyyymmdd = @p_plan_name;
		       SET @v_merge_yn = 'N';
		   END

        ELSE

		   BEGIN			   
			   SELECT @v_merge_weekly_start_yyyymmdd = CONVERT(VARCHAR, DATEADD(DAY, 1, CONVERT(DATETIME, MAX(B.YYYYMMDD))), 112)
			     FROM SCM_MST_BUCKET A WITH (NOLOCK)
					 , SCM_MST_BUCKET B WITH (NOLOCK)
				 WHERE A.YYYYMMDD = CONVERT(VARCHAR, DATEADD(DAY, @v_merge_days, CONVERT(DATETIME, @p_plan_name)), 112)
				   AND B.YYYYPW   = A.YYYYPW
				;
		   END   

        -----------------------------------------------------------
        -- 1. DEMAND 생성 

        --    - 여기서는 demand_attribute 생성을 위한 th_eng_demand_sn 테이블의 초기값만 생성함 
        --      최종 th_eng_demand_sn테이블의 데이터 생성은 
        --      PR_SCP_ENG_EE_FN_PROC_DPP_DEMAND 프로시저에서 생성완료함             
        -----------------------------------------------------------
        DELETE /* PR_SCP_ENG_EE_FN_PROC_DEMAND_ATTRIBUTE */
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
            DROP TABLE  #TH_ENG_NET_DEMAND_TEMP          
        END 
        CREATE TABLE #TH_ENG_NET_DEMAND_TEMP(
	        MASTER_ID NVARCHAR(50) NOT NULL,
	        PLAN_ID NVARCHAR(50) NOT NULL,
	        DEMAND_ID NVARCHAR(200) NOT NULL,  
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
	        DEMAND_GROUP_ID NVARCHAR(200) NULL, 
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
          , ORG_ELEC_SITE_ID NVARCHAR(300) NULL           -- 20180411 추가 (demand의 plant_site_id가 팩일때는 동일한 plant_id의 셀사이트의 site_id, 셀사이트일때 동일한 site_id의 전극사이트) 
          
          , AVG_SETUP_TIME   NUMERIC(20,10) NULL           -- 20180322 추가 동일 setup group id의 평균 setup time
          , CELL_SITE_SETUP_GROUP_ID NVARCHAR(300) NULL    -- 20180322 추가 CELL 선호 site의 setup group id
                    
          , CELL_SITE_ID NvARCHAR(300) NULL                -- 20180322 추가 CELL 선호 site
          , CELL_ITEM_ID NVARCHAR(300) NULL                -- 20180322 추가 CELL 선호 site의 item id  
         
          , MAX_DAILY_CAPA   NUMERIC(18,4) NULL            -- 20180328 추가 daily_capa (cell_item_id에 해당되는 여러 lINE의 DAILY CAPA중 가장큰갑)
          
          , DEMAND_PRIORITY  NVARCHAR(20) NULL             -- 20180621 추가 DM의 우선순위(dm_pln_net_demand.priority값) 
          , DIVISION_ID  NVARCHAR(30) NULL                 -- 20180627 추가 division_id 
          , LINE_ID  NVARCHAR(30) NULL                     -- 20190917 Model Alloc 추가  
        )
        ;
        
       
        -----------------------------------------------------------
        -- 1-2) (DM demand 데이터) 그룹핑 작업을 위한 임시테이블 데이터 생성
        -----------------------------------------------------------        
       INSERT INTO /* PR_SCP_ENG_EE_FN_PROC_DEMAND_ATTRIBUTE */ #TH_ENG_NET_DEMAND_TEMP --th_eng_demand_sn 
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
         
         , demand_priority  -- 20180621 추가(DM의 우선순위)     
         , division_id      -- 20180627 추가
		 , line_id          -- 20190917 Model Alloc 추가       
       )      
       SELECT  DISTINCT 
               @p_master_id      AS master_id
             , @p_engine_plan_id AS plan_id
             
             , a.item_id + '::' + a.project_code + '::' + a.scm_site_id + '~' + a.incoterms
               + '::' + a.dom_exp + '::' + a.fcst_type + '::' + a.demand_type + '::' + a.yyyymmdd
			   + '::' + IIF( REPLACE(a.plant_site_id, ' ', '') = 'NOPLANT' OR RTRIM(a.plant_site_id) = '', ISNULL(a.plant_site_id_pr, 'NOPLANT'), a.plant_site_id) AS demand_id
			   --+ '::' + IIF( REPLACE(a.plant_site_id, ' ', '') = 'NOPLANT' OR RTRIM(a.plant_site_id) = '', ISNULL(c.plant_site_id, 'NOPLANT'), a.plant_site_id) AS demand_id
             
             , a.item_id + '^' + a.scm_site_id + '~' + a.incoterms + '^S'     AS sales_model_id
             
             -- shipping_date가 플랜시작일자보다 작으면 shipping_date를 플랜시작일자로 사용함
             , IIF( @d_plan_name > CONVERT(DATE, a.yyyymmdd_org), @d_plan_name,CONVERT(DATE, a.yyyymmdd_org))    AS shipping_date --20180619 수정 dm_pln_net_demand.yyyymmdd값 (변경전 : , CONVERT(DATE, a.yyyymmdd) AS shpping_date --dm_pln_net_demand.attribute1 값  ) 
             
             , CONVERT(DATE, a.yyyymmdd)       AS due_date

             -- Due Fence Date 설정 : ESS(82) - PET Date / 자동차(81) - PET Date / 소형(40) - 월말 : 2018.06.05 ESS 월말에서 PET Date 로 변경
			 --                       전극(EE)  - PET Date 
             -- due_fence_date 값 수정 : 플랜종료월(@v_pet_date) + 추가 Bucket(13*7) 
             --, @v_pet_date  AS due_fence_date		
			 /** (2022.01.26) 사업부별 LOOKUP의 추가계획기간 반영 건 이전로직 주석처리하고 @v_add_pet_date 값을 due_fence_date로 반영한다. 
             , DATEADD(DD, 13*7, CONVERT(DATE, @v_pet_date)) AS due_fence_date    **/ 
			 , @v_add_pet_date                 AS due_fence_date    

              -- 그룹핑 시작일자와 due_date의 차이일수를 입력한다. 
              -- ( 그룹핑시작일자 : 20180312일경우 due_date 20180313이면 => 1 이 들어감, 20180312일경우 due_date 20180314이면 => 2 들어감...)
             -- ksg 20180522 7일 추가 반영
             , NULL AS early_producing_term -- 20180618 수정 PR_SCP_ENG_EE_FN_PROC_DPP_DEMAND에서 값설정함 ( 변경전 : , DATEDIFF( d, CONVERT(DATETIME,@p_plan_name), CONVERT(DATE, a.yyyymmdd)) % @n_demand_term + 7 AS early_producing_term --20180522 수정 (변경전 : , DATEDIFF( d, CONVERT(DATETIME,@p_plan_name), CONVERT(DATE, a.yyyymmdd)) % @n_demand_term AS early_producing_term) )
             
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
             , a.item_id + '::' + a.project_code + '::' + a.scm_site_id + '~' + a.incoterms
               + '::' + a.dom_exp + '::' + a.fcst_type + '::' + a.demand_type + '::' + a.yyyymmdd 
               + '::' + IIF( REPLACE(a.plant_site_id, ' ', '') = 'NOPLANT' OR RTRIM(a.plant_site_id) = '', ISNULL(a.plant_site_id_pr, 'NOPLANT'), a.plant_site_id) AS demand_group_id
               --+ '::' + IIF( REPLACE(a.plant_site_id, ' ', '') = 'NOPLANT' OR RTRIM(a.plant_site_id) = '', ISNULL(c.plant_site_id, 'NOPLANT'), a.plant_site_id) AS demand_group_id
             
             , 'FENCEDATE_OVERLAP'               AS late_type -- 2018.07.05 SHIPMENT_LATE => FENCEDATE_OVERLAP
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

             , NULL AS org_cell_site_id          -- 20180411 추가 (demand의 plant_site_id가 팩('P')사이트일때 팩사이트와 동일한 plant_id의 셀('A')사이트)        
             , NULL AS org_elec_site_id          -- 20180411 추가 (demand의 plant_site_id가 팩일때는 동일한 plant_id의 셀사이트의 site_id, 셀사이트일때 동일한 site_id의 전극사이트) 

            
             , NULL AS avg_setup_time            -- 20180322 추가 동일 setup group id의 평균 setup time 
             , NULL AS cell_site_setup_group_id  -- 20180322 추가 CELL 선호 site의 setup group id
             , NULL AS cell_site_id              -- 20180322 추가 CELL 선호 site
             , NULL AS cell_item_id      -- 20180322 추가 CELL 선호 site의 item id  
             , NULL AS max_daily_capa            -- 20180328 추가 cell_item_id 의 가장큰 Daily capa 값
             
             , a.demand_priority AS demand_priority -- 20180621  추가(dm의 우선순위)

             , a.division_id                        -- 20180627 추가
		     , a.line_id                            -- 20190917 Model Alloc 추가

        FROM   ( 
               --------------------------------------------------
               -- 1. VMI 아닌 Site 
               --------------------------------------------------
		       SELECT aa.division_id
                    , aa.version_no
                    , aa.cutoff_yyyymmdd
		                          
                    , aa.project_code

                    , aa.scm_site_id
                    , aa.item_id
                    , aa.dom_exp
                    , aa.fcst_type
                    
                    , aa.incoterms                      

                    , aa.plant_site_id
                    ,(SELECT TOP 1 plant_site_id
                      FROM   scm_mst_site_item_priority_v c -- 20180323 scm_mst_site_item_priority_v (scm_mst_site_item_priority 테이블의 valid_yn = 'Y'이면서 priority가  가장작은 데이터 조회됨)
                      WHERE  aa.division_id  = c.division_id  
                      AND    aa.item_id      = c.item_id 
                      -- 20180312 수정 =========================> ksg 로직정의후 추후 수정 필요함 ( 현재는 임시로 due_date 기준으로 처리함 )
                      AND    c.from_yyyymmdd <= aa.attribute1    -- due_date
                      AND    c.to_yyyymmdd   >= aa.attribute1 
                     ) AS plant_site_id_pr

                    , aa.demand_type
                    , aa.attribute1  AS yyyymmdd -- 20180525 수정 (변경전 : , yyyymmdd )
                    , aa.demand_priority
                    , aa.qty                    
                    , aa.yyyymmdd AS yyyymmdd_org --20180619 추가
		            , '-'         AS line_id      -- 20190917 Model Alloc 추가
                 FROM   dbo.dm_pln_net_demand  aa WITH (NOLOCK)
                        INNER JOIN #DEMAND_CUTOFF_YYYYMMDD b 
                        ON   aa.division_id     = b.division_id 
                        AND  aa.cutoff_yyyymmdd = b.demand_cutoff_yyyymmdd 

                        -- 20180712 추가 VMI 비대상 site 조회
                        INNER JOIN ( 
                                    SELECT division_id, scm_site_id, vmi_yn 
                                    FROM   scm_mst_site  WITH (NOLOCK)
                                    WHERE  valid_yn = 'Y'
                                    AND    vmi_yn  <> 'Y'
                                   ) mse
                        ON   aa.division_id = mse.division_id
                        AND  aa.scm_site_id = mse.scm_site_id

                 WHERE  aa.attribute1     >= @p_plan_name                -- Plan 구간 내 Demand
                 AND    aa.attribute1     <= @v_pet_date                 -- Plan 구간 내 Demand
                 --AND    aa.yyyymmdd       >= @p_plan_name                -- Plan 구간 내 Demand
                 --AND    aa.yyyymmdd       <= @v_pet_date                 -- Plan 구간 내 Demand
                 AND    aa.qty            >  0                

                 --AND    aa.division_id     = @p_division_id        --20180627 주석처리
                 --AND    aa.cutoff_yyyymmdd = @v_demand_cutoff_day  -- @v_demand_cutoff_day 는 화요일 일자(YYYYMMDD)
				 
                 --------------------------------------------------
                 -- 2. VMI Site 
                 --------------------------------------------------
                 UNION
				 SELECT aa.division_id
                    , aa.version_no
                    , aa.cutoff_yyyymmdd
		                          
                    , aa.project_code

                    , aa.scm_site_id
                    , aa.item_id
                    , aa.dom_exp
                    , aa.fcst_type
                    
                    , 'DAP' AS incoterms                      

                    , aa.plant_site_id
                    ,(SELECT TOP 1 plant_site_id
                      FROM   scm_mst_site_item_priority_v c -- 20180323 scm_mst_site_item_priority_v (scm_mst_site_item_priority 테이블의 valid_yn = 'Y'이면서 priority가  가장작은 데이터 조회됨)
                      WHERE  aa.division_id  = c.division_id   
                      AND    aa.item_id      = c.item_id 
                      -- 20180312 수정 =========================> ksg 로직정의후 추후 수정 필요함 ( 현재는 임시로 due_date 기준으로 처리함 )
                      AND    c.from_yyyymmdd <= aa.attribute1    -- due_date
                      AND    c.to_yyyymmdd   >= aa.attribute1 
                     ) AS plant_site_id_pr

                    , aa.demand_type
                    , aa.attribute1  AS yyyymmdd -- 20180525 수정 (변경전 : , yyyymmdd )
                    , MIN(aa.demand_priority) AS demand_priority
                    , SUM(aa.qty) AS qty
                    , MIN(aa.yyyymmdd) AS yyyymmdd_org --20180619 추가
		            , '-'         AS line_id           -- 20190917 Model Alloc 추가
                 FROM   dbo.dm_pln_net_demand  aa WITH (NOLOCK)
                        INNER JOIN #DEMAND_CUTOFF_YYYYMMDD b 
                        ON   aa.division_id     = b.division_id 
                        AND  aa.cutoff_yyyymmdd = b.demand_cutoff_yyyymmdd 

                        -- 20180712 추가 대상 site 조회
                        INNER JOIN ( 
                                    SELECT division_id, scm_site_id, vmi_yn 
                                    FROM   scm_mst_site  WITH (NOLOCK)
                                    WHERE  valid_yn = 'Y'
                                    AND    vmi_yn   = 'Y'
                                   ) mse
                        ON   aa.division_id = mse.division_id
                        AND  aa.scm_site_id = mse.scm_site_id

                 WHERE  aa.attribute1     >= @p_plan_name                  -- Plan 구간 내 Demand
                 AND    aa.attribute1     <= @v_pet_date                   -- Plan 구간 내 Demand
                 --AND    aa.yyyymmdd       >= @p_plan_name                  -- Plan 구간 내 Demand
                 --AND    aa.yyyymmdd       <= @v_pet_date                   -- Plan 구간 내 Demand
                 AND    aa.qty            >  0                

                 --AND    aa.division_id     = @p_division_id         --20180627 주석처리
                 --AND    aa.cutoff_yyyymmdd = @v_demand_cutoff_day   -- @v_demand_cutoff_day 는 화요일 일자(YYYYMMDD)
                      
				 GROUP BY aa.division_id, aa.version_no, aa.cutoff_yyyymmdd, aa.project_code, aa.scm_site_id
                        , aa.item_id, aa.dom_exp, aa.fcst_type, aa.plant_site_id, aa.demand_type, aa.attribute1            
        
               )  a
               INNER JOIN ( SELECT a.division_id, max(a.version_no) max_version_no
                            FROM   dbo.dm_pln_net_demand  a WITH(NOLOCK)
                                   INNER JOIN #DEMAND_CUTOFF_YYYYMMDD b 
                                   ON   a.division_id = b.division_id 
                                   AND  a.cutoff_yyyymmdd = b.demand_cutoff_yyyymmdd 
                            WHERE  1 = 1
                            --AND    a.cutoff_yyyymmdd = @v_demand_cutoff_day  -- @v_demand_cutoff_day 는 화요일 일자(YYYYMMDD)
                            --AND    a.division_id     = @p_division_id         
                            GROUP BY  a.division_id
                          ) b
               ON  a.division_id = b.division_id
               AND a.version_no  = b.max_version_no  
               
               INNER JOIN dbo.scm_mst_site s WITH(NOLOCK)
               ON   a.division_id = s.division_id
               AND  a.scm_site_id = s.scm_site_id 
               AND  s.site_type   = 'SALES'
               AND  s.valid_yn    = 'Y'

               --LEFT JOIN  scm_mst_site_item_priority_v c -- 20180323 scm_mst_site_item_priority_v (scm_mst_site_item_priority 테이블의 valid_yn = 'Y'이면서 priority가  가장작은 데이터 조회됨)
               --ON   a.division_id  = c.division_id  --@p_division_id  
               --AND  a.item_id      = c.item_id 
               ---- 20180312 수정 =========================> ksg 로직정의후 추후 수정 필요함 ( 현재는 임시로 due_date 기준으로 처리함 )
               --AND  c.from_yyyymmdd <= a.yyyymmdd    -- due_date
               --AND  c.to_yyyymmdd   >= a.yyyymmdd 

               -- 상품/원자재 Demand는 엔진에 반영하지 않음 : 한 site의 Q/R이 다른 Site에서는 P/H일 수 있음
               LEFT OUTER JOIN (SELECT division_id, item_id, MAX(item_type) AS item_type
                                FROM   dbo.scm_mst_item_sn WITH (NOLOCK)
                                WHERE  item_type    NOT IN ('Q', 'R')
                                --AND    division_id = @p_division_id       
                                GROUP BY division_id, item_id
                               ) d
               ON  a.division_id = d.division_id
               AND a.item_id     = d.item_id
			  
               -- 전극 모델
               INNER JOIN (SELECT DISTINCT division_id, item_id
                           FROM   dbo.scm_mst_item_sn WITH (NOLOCK)
                           WHERE  active_flag = 'Y' 
                           AND    scp_operation_group = 'E' -- 전극만 처리함
                           --AND    division_id = @p_division_id       
                          ) e
               ON  a.division_id = e.division_id
               AND a.item_id     = e.item_id

               INNER JOIN scm_mst_division f WITH (NOLOCK)
               ON   a.division_id = f.division_id 
               AND  f.valid_yn = 'Y'

        WHERE  d.item_id IS NOT NULL
        ;        
        
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 1-2 END';
        SET @v_description = N'1-2. DM 전극 Demand 임시정보 임시정보 INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        
        -----------------------------------------------------------
        -- 1-3) (SCP demand 데이터) 그룹핑 작업을 위한 임시테이블 데이터 생성
        -----------------------------------------------------------        
        INSERT INTO /* PR_SCP_ENG_EE_FN_PROC_DEMAND_ATTRIBUTE */ #TH_ENG_NET_DEMAND_TEMP --th_eng_demand_sn 
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
         
         , demand_priority  -- 20180621 추가(DM의 우선순위)     
         , division_id     
		 , line_id          -- 20190917 Model Alloc 추가         
       )      
       SELECT  @p_master_id      AS master_id
             , @p_engine_plan_id AS plan_id
             
             , a.eng_demand_id AS demand_id  -- item_id + '::' + line_id + '::' + (scm_site_id + '-S') + '~' + incoterms('EXW' 하드코딩함) + '::' + dom_exp('D' 하드코딩함 + '::' + fcst_type('MPS'로 하드코딩함) + '::' + demand_type('CF'하드코딩함) + '::' + yyyymmdd + '::' + scm_site_id(=plant_site_id)                   
             
             , a.item_id + '^' + (a.scm_site_id + '-S' ) + '~' + 'EXW' + '^S'     AS sales_model_id
             
             , CONVERT(DATE, a.yyyymmdd)       AS shipping_date 
             , CONVERT(DATE, a.yyyymmdd)       AS due_date

             -- Due Fence Date 설정 : ESS(82) - PET Date / 자동차(81) - PET Date / 소형(40) - 월말 : 2018.06.05 ESS 월말에서 PET Date 로 변경
			 --                       전극(EE)  - PET Date 
             -- due_fence_date 값 수정 : 플랜종료월(@v_pet_date) + 추가 Bucket(13*7) 
             --, @v_pet_date  AS due_fence_date			 
			 
			 /* (2022.01.26) 사업부별 LOOKUP의 추가계획기간 반영 건 이전로직 주석처리하고 @v_add_pet_date 값을 due_fence_date로 반영한다. 
             , DATEADD(DD, 13*7, CONVERT(DATE, @v_pet_date)) AS due_fence_date   */ 
		     , @v_add_pet_date                 AS due_fence_date  

              -- 그룹핑 시작일자와 due_date의 차이일수를 입력한다. 
              -- ( 그룹핑시작일자 : 20180312일경우 due_date 20180313이면 => 1 이 들어감, 20180312일경우 due_date 20180314이면 => 2 들어감...)
             -- ksg 20180522 7일 추가 반영
             , NULL AS early_producing_term -- 20180618 수정 PR_SCP_ENG_EE_FN_PROC_DPP_DEMAND에서 값설정함 ( 변경전 : , DATEDIFF( d, CONVERT(DATETIME,@p_plan_name), CONVERT(DATE, a.yyyymmdd)) % @n_demand_term + 7 AS early_producing_term --20180522 수정 (변경전 : , DATEDIFF( d, CONVERT(DATETIME,@p_plan_name), CONVERT(DATE, a.yyyymmdd)) % @n_demand_term AS early_producing_term) )
             
             , 'DAY'            AS early_producing_term_uom
             , ISNULL(a.qty, 0) AS qty
             , ISNULL(a.qty, 0) AS split_qty
             
             , 'MPS'   AS order_type  --참고) order_type(NVARCHAR(10) 인데 fact_type(NVARCHAR(20) 으로 10자리로 입력 )            
             
             , 'CF'    AS demand_type
             
             , 'EPST'           AS producing_type        --  'LPST'  -- 20180212 티라 김동범수석 요청
             , '1'              AS priority_group_code
             , dbo.FN_ZERO_LPAD(1, 10) AS priority
             , NULL AS attribute_checker_id

              
             , a.eng_demand_id AS demand_group_id
             
             , 'FENCEDATE_OVERLAP'               AS late_type -- 2018.07.05 SHIPMENT_LATE => FENCEDATE_OVERLAP
             , 'D' + '::' + 'MPS' + '::' + 'CF' AS descr 
             , 1                                 AS move_time_rate
             , 1                                 AS buffer_time_rate
             , 'N'                               AS is_exception
             , a.item_id                         AS item
             , a.scm_site_id + '-S' + '~' + 'EXW' AS site
             , a.scm_site_id + '-S'               AS scm_site
             
             , a.line_id      AS project_code  
           
             , a.scm_site_id  AS plant_site_id --20180312 추가

             , NULL AS org_cell_site_id          -- 20180411 추가 (demand의 plant_site_id가 팩('P')사이트일때 팩사이트와 동일한 plant_id의 셀('A')사이트)        
             , NULL AS org_elec_site_id          -- 20180411 추가 (demand의 plant_site_id가 팩일때는 동일한 plant_id의 셀사이트의 site_id, 셀사이트일때 동일한 site_id의 전극사이트) 
             , NULL AS avg_setup_time            -- 20180322 추가 동일 setup group id의 평균 setup time 
             , NULL AS cell_site_setup_group_id  -- 20180322 추가 CELL 선호 site의 setup group id
             , NULL AS cell_site_id              -- 20180322 추가 CELL 선호 site
             , NULL AS cell_item_id      -- 20180322 추가 CELL 선호 site의 item id  
             , NULL AS max_daily_capa            -- 20180328 추가 cell_item_id 의 가장큰 Daily capa 값
             
             , dbo.FN_ZERO_LPAD(1, 10) AS demand_priority -- 20180621  추가(dm의 우선순위)

             , a.origin_division_id   AS division_id 
		     , a.line_id  -- 20190917 Model Alloc 추가     
        
        FROM   scp_pln_elec_demand_cell_plan  a WITH (NOLOCK)

               INNER JOIN scm_mst_division f WITH (NOLOCK)
               ON   a.origin_division_id = f.division_id 
               AND  f.valid_yn = 'Y'

        WHERE  a.division_id         = @p_division_id  
        AND    a.plan_start_yyyymmdd = @p_plan_name    
        AND    a.plan_type           = @p_plan_type   -- 'MA' (또는 'SE', 'FN')      
        AND    a.yyyymmdd           >= @p_plan_name   -- Plan 구간 내 Demand
        AND    a.yyyymmdd           <= @v_pet_date    -- Plan 구간 내 Demand
       ;       
        
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 1-3 END';
        SET @v_description = N'1-3. 셀 생산계획 demand 임시정보 INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id  + ' / ' + @p_division_id + ' / ' + @p_plan_name + ' / ' + @p_plan_type  ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        -----------------------------------------------------------
        -- 2.  DEMAND ATTRIBUTE 생성
        -----------------------------------------------------------
        
        DELETE /* PR_SCP_ENG_EE_FN_PROC_DEMAND_ATTRIBUTE */
        FROM   th_eng_demand_attribute_sn
        WHERE  master_id = @p_master_id
        AND    plan_id   = @p_engine_plan_id 
        ;
        -----------------------------------------------------------
        
        -----------------------------------------------------------
        -- 2-1-1) Demand의 item의 BOM상의 하위 item  정보 임시테이블로 생성
        -----------------------------------------------------------
          IF OBJECT_ID('tempdb..#DEMAND_ITEM_BOM_TEMP') IS NOT NULL
          BEGIN 
              DROP TABLE  #DEMAND_ITEM_BOM_TEMP
          END 
          
          SELECT DISTINCT 
                 dm.demand_id 
               , dm.project_code
               , dm.item
               , dm.scm_site 
               , CONVERT(NVARCHAR(8), dm.due_date, 112) AS due_date
               
               , t.parent_item_id -- 20180618 추가
               , t.child_item_id
               , t.accumulated_child_qty --20180903 추가

               , dm.plant_site_id
               , v.operation_group_id AS child_item_operation_group
               , dm.demand_item_operation_group

               , dm.division_id   -- 20180627 추가
               , dm.line_id       -- 20190917 Model Alloc 추가 
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
                      
                      , a.division_id   -- 20180627 추가         
                      , a.line_id       -- 20190917 Model Alloc 추가  
                 FROM   #TH_ENG_NET_DEMAND_TEMP a
                 
                        --INNER JOIN scm_mst_final_item_v b WITH (NOLOCK)
                        INNER JOIN (SELECT DISTINCT division_id, item_id, operation_group_id FROM scm_mst_final_item_v WITH (NOLOCK)) b
                        ON    a.item = b.item_id
                        --AND   b.division_id = @p_division_id 
                        AND   a.division_id = b.division_id  -- 20180627 추가
                        
                 --WHERE  a.master_id   = @p_master_id 
                 --AND    a.plan_id     = @p_engine_plan_id 
                ) dm
               INNER HASH JOIN ( SELECT company_id, division_id, site_id, child_item_id, model_id, alt_priority -- 긴급반영. 20260709 YMH HASH 추가
                                 , parent_item_id -- 20180618 추가
                                 , MIN(accumulated_child_qty) AS accumulated_child_qty --20180903 추가
                            --FROM   scm_mst_bom_effective_sn x WITH(NOLOCK, INDEX(PK_SCM_MODEL_COMP_EFFECTIVE_DATE)) --20181129 힌트적용(변경전 : FROM   scm_mst_bom_effective_sn x WITH(NOLOCK) ) --20180615 수정 ( 변경전 : FROM   scm_mst_bom_sn  WITH (NOLOCK))
                            FROM   scm_mst_bom_effective_sn_V x WITH(NOLOCK)	--2021.04.08 SCP 대치BOM 적용
							WHERE  1=1
                            --AND    division_id = @p_division_id 
                            --AND    eff_start_date <= @d_plan_name --20180618 추가 (미래구간의 BOM정보를 안가져오지 위해서)
                            AND    eff_end_date   >  @d_plan_name --20180618 추가
							-- 상위가 END된 경우 그 하위 Item 은 제외(20181009수정, 팩->TCO셀->셀 일경우 셀의 상위인 TCO셀의 사용기간(EFF_END_DATE < @d_plan_name일경우)이 종료되었을경우 하위셀은 사용기간이 종료되어야 하는데 종료되지 않아서 아래조건 추가함)
                            /* 20181010 속도 개선위해 수정         
                            AND    NLEVEL =  (SELECT COUNT(DISTINCT C.CONCATENATE_ITEM)
												FROM  dbo.SCM_MST_BOM_EFFECTIVE_SN C with(nolock)
											   WHERE  X.MODEL_ID         = C.MODEL_ID
												 AND  X.PLANT_ID         = C.PLANT_ID
												 AND  X.CONCATENATE_ITEM != C.CONCATENATE_ITEM
												 AND  X.CONCATENATE_ITEM LIKE C.CONCATENATE_ITEM + '%'
												 AND  C.EFF_END_DATE     >  @d_plan_name
											 )
                            */
                          /* -- 2023.08.03  조건 제외
						  AND    nlevel =  (SELECT COUNT(DISTINCT c.concatenate_item)
                                              --FROM   scm_mst_bom_effective_sn c WITH(NOLOCK, INDEX(PK_SCM_MODEL_COMP_EFFECTIVE_DATE)) --20181129 힌트적용(변경전 : FROM   scm_mst_bom_effective_sn c with(nolock) )
											  FROM   scm_mst_bom_effective_sn_V c WITH(NOLOCK)	--2021.04.08 SCP 대치BOM 적용
                                              WHERE  x.company_id       = c.company_id   --20181011 추가
                                              AND    x.division_id      = c.division_id  --20181011 추가
                                              AND    x.site_id          = c.site_id      --20181011 추가
                                              AND    x.model_id         = c.model_id
                                              AND    x.plant_id         = c.plant_id
                                              AND    x.concatenate_item <>   c.concatenate_item
                                              AND    x.concatenate_item LIKE c.concatenate_item + '%'
                                              AND    c.eff_end_date     >    @d_plan_name

                                              AND    x.nlevel           <>  c.nlevel  --20181129 추가( x.concatenate_item = 'AMVAGBV15-A1-B04^AMDAU0138A^ACEN1060I-A1-A01' 일경우 'AMVAGBV15-A1-B04^AMDAU0138A^ACEN1060I-A1'도 count에 포함되어 count가 +1 될수 있으므로 조건에 포함한다.)
                                            )
											*/
                            
                            --20180621 추가(model_id, parent_item_id, child_item 이 eff_start_date, eff_end_date가 다르면서 동일한 데이터가 존재할수 있으므로 GROUP BY 처리한다)
                            GROUP BY company_id, division_id, site_id, child_item_id, model_id, alt_priority 
                                   , parent_item_id
                           ) t
               ON  dm.item = IIF(dm.demand_item_operation_group = 'E' , t.child_item_id, t.model_id) -- (변경전 : ON     dm.item = t.model_id)
               AND t.alt_priority = 'Y'  --20180503 수정 ( 변경전 : AND (t.alt_id IS NULL OR t.alt_id = '01') )
               AND dm.division_id = t.division_id -- 20180627 추가

               INNER JOIN scm_mst_item_sn i WITH (NOLOCK)
               ON    1 = 1
               --AND   t.company_id    = i.company_id    --20180725 주석처리 ( 전극은 company_id, division_id, site_id 상관없이 처리해야함)
               --AND   t.division_id   = i.division_id   --20180725 주석처리 ( 전극은 company_id, division_id, site_id 상관없이 처리해야함)
               --AND   t.site_id       = i.site_id       --20180725 주석처리 ( 전극은 company_id, division_id, site_id 상관없이 처리해야함) 
               AND   t.child_item_id = i.item_id
               AND   i.item_type     <> 'R'
               AND   i.active_flag   = 'Y'        --20180525 추가
               --AND   i.scp_operation_group <> 'E' --20180523 추가
               
               -- 20180627 주석처리(전극 처리시에는 조인조건에서 사용안함)
               --INNER JOIN scm_mst_site_item s WITH (NOLOCK) 
               --ON    t.division_id  = s.division_id 
               --AND   t.model_id     = s.item_id 
               --AND   s.project_code = dm.project_code --@p_project_code
               --AND   s.scm_site_id  = dm.scm_site --
                                                                                    
               --INNER JOIN scm_mst_final_item_v v WITH (NOLOCK)
               INNER JOIN (SELECT DISTINCT division_id, item_id, operation_group_id FROM scm_mst_final_item_v WITH (NOLOCK)) v
               ON    t.division_id   = v.division_id  ----------------> 20180725 조회조건에서 제외시켜야 하는지 확인???
               AND   t.child_item_id = v.item_id  
               AND   v.operation_group_id IN ('A', 'E') -- 20180903 속도개선위해서 조회조건 추가
        ;
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 2-1-1 END';
        SET @v_description = N'2-1-1 Demand의 item의 BOM상의 하위 item  정보 INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        
        
        -----------------------------------------------------------
        -- 2-1-2) Demand의 item의 BOM상의 하위 item  정보 임시테이블로 생성2
        --        - accumulated_child_qty 합계값( 셀은 ?? 참고)팩일경우 모듈이 여러개 존재할수 있으므로 sum해주어야 한다)

        --        참고) accumulated_child_qty 합계확인
        --              SELECT * FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V  
        --              WHERE  model_id = 'APPSAPHEV-A1'
        --              AND    child_item_id = 'ACPN1038I-B1'
        -----------------------------------------------------------
         IF OBJECT_ID('tempdb..#DEMAND_ITEM_BOM') IS NOT NULL
         BEGIN 
            DROP TABLE  #DEMAND_ITEM_BOM
         END 

         SELECT DISTINCT 
                a.demand_id, a.project_code, a.item, a.scm_site, a.due_date, a.child_item_id
              , a.plant_site_id, a.child_item_operation_group, a.demand_item_operation_group, a.division_id
              , ISNULL(b.accumulated_child_qty, 1) AS accumulated_child_qty --20181010수정(변경전 : b.accumulated_child_qty)
              , a.line_id       -- 20190917 Model Alloc 추가 
         INTO   #DEMAND_ITEM_BOM
         FROM   #DEMAND_ITEM_BOM_TEMP a
                LEFT JOIN ( SELECT division_id, model_id, child_item_id
                                 , MIN(accumulated_child_qty) AS accumulated_child_qty --plant_id 가 여러개 존재할수 있으므로 MIN 값사용
                            FROM   SCM_MST_MODEL_FINAL_ITEM_BOM_V 
                            WHERE  operation_group_id IN ('A', 'E')
                            AND    eff_end_date > @d_plan_name
                            GROUP BY division_id, model_id, child_item_id                            
                          ) b
                ON   a.division_id  = b.division_id
                AND  a.item         = b.model_id
                AND  a.child_item_id = b.child_item_id 
        
          ;
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

          --//분기 조건별 데이터 생성의 사유로 임시 테이블 생성, 2021.08.12, BY KKC
		  CREATE TABLE #DEMAND_ATTRIBUTE_SITE_PRIORITY_TEMP
				 (
					DEMAND_ID NVARCHAR(200), 
					CHILD_ITEM_ID NVARCHAR(150),
					ACCUMULATED_CHILD_QTY NUMERIC(20, 10),
					TOP_PLANT_SITE_ID NVARCHAR(300),
					CHILD_ITEM_OPERATION_GROUP NVARCHAR(300),
					DEMAND_ITEM_OPERATION_GROUP NVARCHAR(300),
					PROJECT_CODE NVARCHAR(300),
					SCM_SITE NVARCHAR(300),
					DUE_DATE NVARCHAR(8),
					ITEM NVARCHAR(300),
					DIVISION_ID  NVARCHAR(30)  
				)
		 ;

		 		  --//@v_merge_yn 옵션별 데이터 생성, 2021.08.12 By KKC
		  IF @v_merge_yn = 'N' 
			
			BEGIN 
          
              INSERT INTO #DEMAND_ATTRIBUTE_SITE_PRIORITY_TEMP
			      (
                      DEMAND_ID
					, CHILD_ITEM_ID
					, ACCUMULATED_CHILD_QTY
					, TOP_PLANT_SITE_ID
					, CHILD_ITEM_OPERATION_GROUP
					, DEMAND_ITEM_OPERATION_GROUP
					, PROJECT_CODE
					, SCM_SITE
					, DUE_DATE
					, ITEM
					, DIVISION_ID 
			      )
			  SELECT DISTINCT 
					 x.demand_id
				   , x.child_item_id
				   , x.accumulated_child_qty --20180903 추가  
				   , x.plant_site_id  AS top_plant_site_id -- 최상위 plant_site_id ( 최상위 plant_site_id => demand item이  팩일때 : 팩사이트,  셀일때 : 셀사이트, 전극 : 전극사이트 )               
				   , x.child_item_operation_group 
				   , x.demand_item_operation_group
				   , x.project_code
				   , x.scm_site
				   , x.due_date  --CONVERT(NVARCHAR(8), x.due_date , 112) AS due_date
				   , x.item               
				   , x.division_id   -- 20180627 추가
			  FROM (   SELECT a.demand_id
							, a.child_item_id
							, a.accumulated_child_qty --20180903 추가                          
							-- 20190917 Model Allocation 추가
							--, IIF(a.child_item_operation_group = 'A', REPLACE(a.scm_site, '-S', ''), sip2.plant_site_id) AS plant_site_id --20180627 수정 -- (변경전 : , sip2.plant_site_id AS plant_site_id --20180525 수정 sip2.plant_site_id 이 NULL 이면 그냥 NULL입력한다.)
							, IIF(a.child_item_operation_group = 'A', REPLACE(a.scm_site, '-S', '')
								, ISNULL(ma.elec_plant_site_id, sip2.plant_site_id) 
								 ) AS plant_site_id 
							, a.child_item_operation_group
							, a.demand_item_operation_group 
							, a.project_code 
							, a.scm_site
							, a.due_date 
							, a.item                         
							, a.division_id   -- 20180627 추가
							-- 20180525 주석처리
							--, ROW_NUMBER() OVER (PARTITION BY a.demand_id, a.child_item_id, sip2.project_code, sip2.sales_site_id, sip2.item_id ORDER BY sip2.priority, sip2.from_yyyymmdd ) sip2_row_num --sip2 데이터가 여러건조회 될수 있음                        
					   FROM #DEMAND_ITEM_BOM a                   
					   -- 20190917 Model Alloc 추가
					   LEFT JOIN ( SELECT division_id, cell_plant_site_id, cell_item_id, cell_line_id
										, elec_item_id, elec_plant_site_id, elec_line_id, tr_mode, yyyymmdd, valid_yn
										, CONVERT(DATETIME, yyyymmdd, 112)                 AS due_date
										, DATEADD(DD, 1, CONVERT(DATETIME, yyyymmdd, 112)) AS due_date2
								   FROM   scp_mst_model_allocation WITH (NOLOCK)
								   WHERE  1=1
								   AND    yyyymmdd >= @p_plan_name   -- Plan 구간 내 Demand
								   AND    yyyymmdd <= @v_pet_date    -- Plan 구간 내 Demand
								   AND    valid_yn  = 'Y'
								 ) ma
					   ON   a.division_id   = ma.division_id
					   AND  a.item          = ma.cell_item_id
					   AND  a.plant_site_id = ma.cell_plant_site_id
					   AND  a.line_id       = ma.cell_line_id
					   /* due_date이 varchar인데, date형으로 조건을 걸었을까? 조건 변경, 2021.08.12 BY KKC */
					   AND  a.due_date    = ma.yyyymmdd
					   /*
					   AND  a.due_date     >= ma.due_date
					   AND  a.due_date     <  ma.due_date2              
					   */
					   -- 20190917 Model Alloc 정보가 없는 경우 Plan 반영 안 되게 하려면 아래 sip2 는 제거 : 제거 시 실제 Sales Site의 Demand 처리 고민 필요
					   LEFT JOIN ( SELECT project_code, sales_site_id, from_yyyymmdd, to_yyyymmdd, item_id 
										, plant_site_id, priority
										, division_id  --20180627 추가                                
								   FROM   scm_mst_site_item_priority WITH (NOLOCK)
								   WHERE  valid_yn = 'Y'
								   --AND    division_id = @p_division_id
								 ) sip2
					   ON   a.child_item_id  =  sip2.item_id --20180525 수정 ( 변경전 : AND  a.item        =  sip2.item_id  )
					   AND  a.due_date      >= sip2.from_yyyymmdd
					   AND  a.due_date      <= sip2.to_yyyymmdd                   
					   -- 20180725 주석처리( 셀 하위의 전극이 division_id가 다를수 있으므로 조회조건 주석처리함, 참고) 셀은 82, 전극은 81번일수도 있음)
					   --AND  a.division_id  = sip2.division_id -- 20180627 추가                   
					   -- 20180720 주석처리 ( 전극이거나 division_id(사업부)가 82, 40 일때 SALES site, project_code가 scm_mst_site_item_priority에 없으므로 주석처리함)
					   --AND  IIF(a.division_id IN ('82', '40') OR a.demand_item_operation_group = 'E', '*', a.project_code) = IIF(a.division_id IN ('82', '40') OR a.demand_item_operation_group = 'E', '*', c.project_code)
					   --AND  IIF(a.division_id IN ('82', '40') OR a.demand_item_operation_group = 'E', '*', a.scm_site_id ) = IIF(a.division_id IN ('82', '40') OR a.demand_item_operation_group = 'E', '*', c.sales_site_id)
					) x
			  --WHERE sip2_row_num = 1  --20180525 주석처리
			  ;

			END
          
		  --//@v_merge_yn = 'Y'
		  ELSE
		    
			BEGIN
			  
			  --1) DAILY 구간 
              INSERT INTO #DEMAND_ATTRIBUTE_SITE_PRIORITY_TEMP
			      (
                      DEMAND_ID
					, CHILD_ITEM_ID
					, ACCUMULATED_CHILD_QTY
					, TOP_PLANT_SITE_ID
					, CHILD_ITEM_OPERATION_GROUP
					, DEMAND_ITEM_OPERATION_GROUP
					, PROJECT_CODE
					, SCM_SITE
					, DUE_DATE
					, ITEM
					, DIVISION_ID 
			      )
			  SELECT DISTINCT 
					 x.demand_id
				   , x.child_item_id
				   , x.accumulated_child_qty --20180903 추가  
				   , x.plant_site_id  AS top_plant_site_id -- 최상위 plant_site_id ( 최상위 plant_site_id => demand item이  팩일때 : 팩사이트,  셀일때 : 셀사이트, 전극 : 전극사이트 )               
				   , x.child_item_operation_group 
				   , x.demand_item_operation_group
				   , x.project_code
				   , x.scm_site
				   , x.due_date  --CONVERT(NVARCHAR(8), x.due_date , 112) AS due_date
				   , x.item               
				   , x.division_id   -- 20180627 추가
			  FROM (   SELECT a.demand_id
							, a.child_item_id
							, a.accumulated_child_qty --20180903 추가                          
							-- 20190917 Model Allocation 추가
							--, IIF(a.child_item_operation_group = 'A', REPLACE(a.scm_site, '-S', ''), sip2.plant_site_id) AS plant_site_id --20180627 수정 -- (변경전 : , sip2.plant_site_id AS plant_site_id --20180525 수정 sip2.plant_site_id 이 NULL 이면 그냥 NULL입력한다.)
							, IIF(a.child_item_operation_group = 'A', REPLACE(a.scm_site, '-S', '')
								, ISNULL(ma.elec_plant_site_id, sip2.plant_site_id) 
								 ) AS plant_site_id 
							, a.child_item_operation_group
							, a.demand_item_operation_group 
							, a.project_code 
							, a.scm_site
							, a.due_date 
							, a.item                         
							, a.division_id   -- 20180627 추가
							-- 20180525 주석처리
							--, ROW_NUMBER() OVER (PARTITION BY a.demand_id, a.child_item_id, sip2.project_code, sip2.sales_site_id, sip2.item_id ORDER BY sip2.priority, sip2.from_yyyymmdd ) sip2_row_num --sip2 데이터가 여러건조회 될수 있음                        
					   FROM #DEMAND_ITEM_BOM a                   
					   -- 20190917 Model Alloc 추가
					   LEFT JOIN ( SELECT division_id, cell_plant_site_id, cell_item_id, cell_line_id
										, elec_item_id, elec_plant_site_id, elec_line_id, tr_mode, yyyymmdd, valid_yn
										, CONVERT(DATETIME, yyyymmdd, 112)                 AS due_date
										, DATEADD(DD, 1, CONVERT(DATETIME, yyyymmdd, 112)) AS due_date2
								   FROM   scp_mst_model_allocation WITH (NOLOCK)
								   WHERE  1=1
								   AND    yyyymmdd >= @p_plan_name   -- Plan 구간 내 Demand
								   AND    yyyymmdd <= @v_pet_date    -- Plan 구간 내 Demand
								   AND    valid_yn  = 'Y'
								 ) ma
					   ON   a.division_id   = ma.division_id
					   AND  a.item          = ma.cell_item_id
					   AND  a.plant_site_id = ma.cell_plant_site_id
					   AND  a.line_id       = ma.cell_line_id
					   /* due_date이 varchar인데, date형으로 조건을 걸었을까? 조건 변경, 2021.08.12 BY KKC */
					   AND  a.due_date    = ma.yyyymmdd
					   /*
					   AND  a.due_date     >= ma.due_date
					   AND  a.due_date     <  ma.due_date2              
					   */
					   -- 20190917 Model Alloc 정보가 없는 경우 Plan 반영 안 되게 하려면 아래 sip2 는 제거 : 제거 시 실제 Sales Site의 Demand 처리 고민 필요
					   LEFT JOIN ( SELECT project_code, sales_site_id, from_yyyymmdd, to_yyyymmdd, item_id 
										, plant_site_id, priority
										, division_id  --20180627 추가                                
								   FROM   scm_mst_site_item_priority WITH (NOLOCK)
								   WHERE  valid_yn = 'Y'
								   --AND    division_id = @p_division_id
								 ) sip2
					   ON   a.child_item_id  =  sip2.item_id --20180525 수정 ( 변경전 : AND  a.item        =  sip2.item_id  )
					   AND  a.due_date      >= sip2.from_yyyymmdd
					   AND  a.due_date      <= sip2.to_yyyymmdd                   
					   -- 20180725 주석처리( 셀 하위의 전극이 division_id가 다를수 있으므로 조회조건 주석처리함, 참고) 셀은 82, 전극은 81번일수도 있음)
					   --AND  a.division_id  = sip2.division_id -- 20180627 추가                   
					   -- 20180720 주석처리 ( 전극이거나 division_id(사업부)가 82, 40 일때 SALES site, project_code가 scm_mst_site_item_priority에 없으므로 주석처리함)
					   --AND  IIF(a.division_id IN ('82', '40') OR a.demand_item_operation_group = 'E', '*', a.project_code) = IIF(a.division_id IN ('82', '40') OR a.demand_item_operation_group = 'E', '*', c.project_code)
					   --AND  IIF(a.division_id IN ('82', '40') OR a.demand_item_operation_group = 'E', '*', a.scm_site_id ) = IIF(a.division_id IN ('82', '40') OR a.demand_item_operation_group = 'E', '*', c.sales_site_id)
					 WHERE  a.due_date     <  @v_merge_weekly_start_yyyymmdd --Daily Period 구간
					) x
			  --WHERE sip2_row_num = 1  --20180525 주석처리
			  ;

			  --2) WEEKLY 구간 
			  WITH VW_WEEKLY_ALLOCAITON AS (
											   SELECT a.division_id
													, a.cell_plant_site_id
													, a.cell_item_id
													, a.cell_line_id
													, a.elec_item_id
													, a.elec_plant_site_id
													, a.elec_line_id
													, a.tr_mode
													, b.yyyypw
													, a.yyyymmdd
													, a.valid_yn
													, ROW_NUMBER() OVER(PARTITION BY a.division_id
																				   , a.cell_plant_site_id
																				   , a.cell_item_id
																				   , a.cell_line_id
																				   , a.elec_plant_site_id
																				   , b.yyyypw
																			ORDER BY b.yyyymmdd) AS SEQ 
													, MIN(b.yyyymmdd) OVER(PARTITION BY a.division_id
																					  , a.cell_plant_site_id
																					  , a.cell_item_id
																					  , a.cell_line_id
																					  , a.elec_plant_site_id
																					  , b.yyyypw) AS min_yyyymmdd 
													, MAX(b.yyyymmdd) OVER(PARTITION BY a.division_id
																					  , a.cell_plant_site_id
																					  , a.cell_item_id
																					  , a.cell_line_id
																					  , a.elec_plant_site_id
																					  , b.yyyypw) AS max_yyyymmdd 
													, CONVERT(DATETIME, a.yyyymmdd, 112)                 AS due_date
													, DATEADD(DD, 1, CONVERT(DATETIME, a.yyyymmdd, 112)) AS due_date2
												  FROM scp_mst_model_allocation a WITH (NOLOCK)
													 , scm_mst_bucket b WITH(NOLOCK) 
												 WHERE a.yyyymmdd  >= @v_merge_weekly_start_yyyymmdd   -- weekly start period
												   AND a.yyyymmdd  <= @v_pet_date    -- Plan 구간 내 Demand
												   AND a.valid_yn  = 'Y'
												   AND b.yyyymmdd  = a.yyyymmdd			                               
										   )
              INSERT INTO #DEMAND_ATTRIBUTE_SITE_PRIORITY_TEMP
			      (
                      DEMAND_ID
					, CHILD_ITEM_ID
					, ACCUMULATED_CHILD_QTY
					, TOP_PLANT_SITE_ID
					, CHILD_ITEM_OPERATION_GROUP
					, DEMAND_ITEM_OPERATION_GROUP
					, PROJECT_CODE
					, SCM_SITE
					, DUE_DATE
					, ITEM
					, DIVISION_ID 
			      )
			  SELECT DISTINCT 
					 x.demand_id
				   , x.child_item_id
				   , x.accumulated_child_qty --20180903 추가  
				   , x.plant_site_id  AS top_plant_site_id -- 최상위 plant_site_id ( 최상위 plant_site_id => demand item이  팩일때 : 팩사이트,  셀일때 : 셀사이트, 전극 : 전극사이트 )               
				   , x.child_item_operation_group 
				   , x.demand_item_operation_group
				   , x.project_code
				   , x.scm_site
				   , x.due_date  --CONVERT(NVARCHAR(8), x.due_date , 112) AS due_date
				   , x.item               
				   , x.division_id   -- 20180627 추가
			  FROM (   SELECT a.demand_id
							, a.child_item_id
							, a.accumulated_child_qty --20180903 추가                          
							-- 20190917 Model Allocation 추가
							--, IIF(a.child_item_operation_group = 'A', REPLACE(a.scm_site, '-S', ''), sip2.plant_site_id) AS plant_site_id --20180627 수정 -- (변경전 : , sip2.plant_site_id AS plant_site_id --20180525 수정 sip2.plant_site_id 이 NULL 이면 그냥 NULL입력한다.)
							, IIF(a.child_item_operation_group = 'A', REPLACE(a.scm_site, '-S', '')
								, ISNULL(ma.elec_plant_site_id, sip2.plant_site_id) 
								 ) AS plant_site_id 
							, a.child_item_operation_group
							, a.demand_item_operation_group 
							, a.project_code 
							, a.scm_site
							, a.due_date 
							, a.item                         
							, a.division_id   -- 20180627 추가
							-- 20180525 주석처리
							--, ROW_NUMBER() OVER (PARTITION BY a.demand_id, a.child_item_id, sip2.project_code, sip2.sales_site_id, sip2.item_id ORDER BY sip2.priority, sip2.from_yyyymmdd ) sip2_row_num --sip2 데이터가 여러건조회 될수 있음                        
					   FROM #DEMAND_ITEM_BOM a                   
					   -- 20190917 Model Alloc 추가
					   LEFT JOIN VW_WEEKLY_ALLOCAITON ma
					   ON   a.division_id   = ma.division_id
					   AND  a.item          = ma.cell_item_id
					   AND  a.plant_site_id = ma.cell_plant_site_id
					   AND  a.line_id       = ma.cell_line_id
					   AND  1               = ma.seq  --WEEK의 첫째날 요일만 선택
					   /* due_date이 varchar인데, date형으로 조건을 걸었을까? 조건 변경, 2021.08.12 BY KKC */
					   AND  a.due_date      = ma.max_yyyymmdd --납기는 주차의 마지막 요일 기준으로 비교
					   /*
					   AND  a.due_date     >= ma.due_date
					   AND  a.due_date     <  ma.due_date2              
					   */
					   -- 20190917 Model Alloc 정보가 없는 경우 Plan 반영 안 되게 하려면 아래 sip2 는 제거 : 제거 시 실제 Sales Site의 Demand 처리 고민 필요
					   LEFT JOIN ( SELECT project_code, sales_site_id, from_yyyymmdd, to_yyyymmdd, item_id 
										, plant_site_id, priority
										, division_id  --20180627 추가                                
								   FROM   scm_mst_site_item_priority WITH (NOLOCK)
								   WHERE  valid_yn = 'Y'
								   --AND    division_id = @p_division_id
								 ) sip2
					   ON   a.child_item_id  =  sip2.item_id --20180525 수정 ( 변경전 : AND  a.item        =  sip2.item_id  )
					   AND  a.due_date      >= sip2.from_yyyymmdd
					   AND  a.due_date      <= sip2.to_yyyymmdd                                 
					   -- 20180725 주석처리( 셀 하위의 전극이 division_id가 다를수 있으므로 조회조건 주석처리함, 참고) 셀은 82, 전극은 81번일수도 있음)
					   --AND  a.division_id  = sip2.division_id -- 20180627 추가                   
					   -- 20180720 주석처리 ( 전극이거나 division_id(사업부)가 82, 40 일때 SALES site, project_code가 scm_mst_site_item_priority에 없으므로 주석처리함)
					   --AND  IIF(a.division_id IN ('82', '40') OR a.demand_item_operation_group = 'E', '*', a.project_code) = IIF(a.division_id IN ('82', '40') OR a.demand_item_operation_group = 'E', '*', c.project_code)
					   --AND  IIF(a.division_id IN ('82', '40') OR a.demand_item_operation_group = 'E', '*', a.scm_site_id ) = IIF(a.division_id IN ('82', '40') OR a.demand_item_operation_group = 'E', '*', c.sales_site_id)
					 WHERE  a.due_date     >=  @v_merge_weekly_start_yyyymmdd --Weekly Period 구간
					) x
			  WHERE NOT EXISTS (
			                      SELECT 'X'
								    FROM #DEMAND_ATTRIBUTE_SITE_PRIORITY_TEMP y WITH(NOLOCK)
								  WHERE y.demand_id = x.demand_Id			  
			                    )
			  ;

			END	

		 /* OLD 소스 ~ 2021.08.12 
          SELECT DISTINCT 
                 x.demand_id
               , x.child_item_id
               , x.accumulated_child_qty --20180903 추가
               , x.plant_site_id  AS top_plant_site_id -- 최상위 plant_site_id ( 최상위 plant_site_id => demand item이  팩일때 : 팩사이트,  셀일때 : 셀사이트, 전극 : 전극사이트 )               
               , x.child_item_operation_group 
               , x.demand_item_operation_group
               , x.project_code
               , x.scm_site
               , x.due_date  --CONVERT(NVARCHAR(8), x.due_date , 112) AS due_date
               , x.item               
               , x.division_id   -- 20180627 추가
          INTO #DEMAND_ATTRIBUTE_SITE_PRIORITY_TEMP
          FROM (   SELECT a.demand_id
                        , a.child_item_id
                        , a.accumulated_child_qty --20180903 추가

                        -- 20190917 Model Allocation 추가
                        --, IIF(a.child_item_operation_group = 'A', REPLACE(a.scm_site, '-S', ''), sip2.plant_site_id) AS plant_site_id --20180627 수정 -- (변경전 : , sip2.plant_site_id AS plant_site_id --20180525 수정 sip2.plant_site_id 이 NULL 이면 그냥 NULL입력한다.)
					    , IIF(a.child_item_operation_group = 'A', REPLACE(a.scm_site, '-S', '')
                            , ISNULL(ma.elec_plant_site_id, sip2.plant_site_id) 
                             ) AS plant_site_id 

                        , a.child_item_operation_group
                        , a.demand_item_operation_group 

                        , a.project_code 
                        , a.scm_site
                        , a.due_date 
                        , a.item                         
                        , a.division_id   -- 20180627 추가
                        -- 20180525 주석처리
                        --, ROW_NUMBER() OVER (PARTITION BY a.demand_id, a.child_item_id, sip2.project_code, sip2.sales_site_id, sip2.item_id ORDER BY sip2.priority, sip2.from_yyyymmdd ) sip2_row_num --sip2 데이터가 여러건조회 될수 있음                        
                   FROM #DEMAND_ITEM_BOM a                     
			       -- 20190917 Model Alloc 추가
                   LEFT JOIN ( SELECT division_id, cell_plant_site_id, cell_item_id, cell_line_id
                                    , elec_item_id, elec_plant_site_id, elec_line_id, tr_mode, yyyymmdd, valid_yn
									, CONVERT(DATETIME, yyyymmdd, 112)                 AS due_date
									, DATEADD(DD, 1, CONVERT(DATETIME, yyyymmdd, 112)) AS due_date2
                               FROM   scp_mst_model_allocation WITH (NOLOCK)
							   WHERE  1=1
                               AND    yyyymmdd >= @p_plan_name   -- Plan 구간 내 Demand
                               AND    yyyymmdd <= @v_pet_date    -- Plan 구간 내 Demand
                               AND    valid_yn  = 'Y'
                             ) ma
                   ON   a.division_id   = ma.division_id
				   AND  a.item          = ma.cell_item_id
                   AND  a.plant_site_id = ma.cell_plant_site_id
                   AND  a.line_id       = ma.cell_line_id
                   AND  a.due_date     >= ma.due_date
                   AND  a.due_date     <  ma.due_date2
              
			       -- 20190917 Model Alloc 정보가 없는 경우 Plan 반영 안 되게 하려면 아래 sip2 는 제거 : 제거 시 실제 Sales Site의 Demand 처리 고민 필요
                   LEFT JOIN ( SELECT project_code, sales_site_id, from_yyyymmdd, to_yyyymmdd, item_id 
                                    , plant_site_id, priority
                                    , division_id  --20180627 추가                                
                               FROM   scm_mst_site_item_priority WITH (NOLOCK)
                               WHERE  valid_yn = 'Y'
                               --AND    division_id = @p_division_id
                             ) sip2
                   ON   a.child_item_id  =  sip2.item_id --20180525 수정 ( 변경전 : AND  a.item        =  sip2.item_id  )
                   AND  a.due_date      >= sip2.from_yyyymmdd
                   AND  a.due_date      <= sip2.to_yyyymmdd
                   
                   -- 20180725 주석처리( 셀 하위의 전극이 division_id가 다를수 있으므로 조회조건 주석처리함, 참고) 셀은 82, 전극은 81번일수도 있음)
                   --AND  a.division_id  = sip2.division_id -- 20180627 추가
                   
                   -- 20180720 주석처리 ( 전극이거나 division_id(사업부)가 82, 40 일때 SALES site, project_code가 scm_mst_site_item_priority에 없으므로 주석처리함)
                   --AND  IIF(a.division_id IN ('82', '40') OR a.demand_item_operation_group = 'E', '*', a.project_code) = IIF(a.division_id IN ('82', '40') OR a.demand_item_operation_group = 'E', '*', c.project_code)
                   --AND  IIF(a.division_id IN ('82', '40') OR a.demand_item_operation_group = 'E', '*', a.scm_site_id ) = IIF(a.division_id IN ('82', '40') OR a.demand_item_operation_group = 'E', '*', c.sales_site_id)

                ) x
          --WHERE sip2_row_num = 1  --20180525 주석처리
        ;
        */

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
              DROP TABLE  #DEMAND_ATTRIBUTE_TEMP
          END 

          SELECT DISTINCT 
                 a.demand_id
              ,  a.plant_site_id AS  final_plant_site_id
              ,  mse.eng_scm_site_id 
              ,  a.operation_group --dbo.fn_scm_split(ISNULL(a.plant_site_id, b.plant_site_id), 2, '-') operation_group
              
              ,  a.division_id -- 20180627 추가
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

                        , division_id -- 20180627 추가
                   FROM   #DEMAND_ATTRIBUTE_SITE_PRIORITY_TEMP -- 20180525 수정 ( 변경전 : FROM   #DEMAND_ATTRIBUTE_SITE_PRIORITY_TEMP5 )
                 ) a
                
               LEFT JOIN ( SELECT scm_site_id
                                , CASE WHEN b.gubun = '1' THEN scm_site_id + '~***'
                                       WHEN b.gubun = '2' THEN scm_site_id + '~001'
                                       WHEN b.gubun = '3' THEN scm_site_id + '~002'
                                       WHEN b.gubun = '4' THEN scm_site_id + '~003'
                                  END AS eng_scm_site_id
                                , division_id  -- 20180627 추가
                           FROM scm_mst_site a WITH (NOLOCK)
                              , ( SELECT '1' gubun UNION ALL SELECT '2' UNION ALL SELECT '3' UNION ALL SELECT '4') b
                           WHERE a.valid_yn = 'Y'    
                           --AND   a.division_id = @p_division_id 
                           AND   a.site_type = 'PLANT'
                           AND   ( a.operation_group = 'E'  AND ISNULL(a.osp_yn, 'N') = 'N' AND b.gubun IN ( '1', '3', '4') --20181001 수정
                                   OR
                                   a.operation_group = 'E'  AND ISNULL(a.osp_yn, 'N') = 'Y' AND b.gubun = '1'               --20181001 추가
                                   OR 
                                   a.operation_group = 'A' AND b.gubun = '1'
                                 )
                        ) mse
               ON   a.plant_site_id = mse.scm_site_id
               
               -- 20180725 주석처리( 셀 하위의 전극이 division_id가 다를수 있으므로 조회조건 주석처리함, 참고) 셀은 82, 전극은 81번일수도 있음)
               --AND  a.division_id   = mse.division_id  -- 20180627 추가
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
              DROP TABLE  #DEMAND_ATTRIBUTE
          END 
          SELECT  demand_id  
          
              ,  ( SELECT ',' + eng_scm_site_id  --SELECT DISTINCT ',' + plant_site_id  
                   FROM   #DEMAND_ATTRIBUTE_TEMP 
                   WHERE  demand_id  = a.demand_id
                   ORDER BY (CASE WHEN operation_group = 'P' THEN 1 
                                  WHEN operation_group = 'A' THEN 2
                                  WHEN operation_group = 'E' THEN 3 END), eng_scm_site_id
                   FOR XML PATH('') ) AS all_plant_site_id

              ,  ( SELECT DISTINCT ',' + child_item_id 
                   FROM #DEMAND_ITEM_BOM_TEMP --20180525 수정 ( 변경전 : FROM #DEMAND_ITEM_BOM_TEMP )
                   WHERE demand_id  = a.demand_id
                   FOR XML PATH('') ) AS all_item_id

          INTO   #DEMAND_ATTRIBUTE
          --FROM   dbo.th_eng_demand_sn  a WITH (NOLOCK) 
          FROM   #TH_ENG_NET_DEMAND_TEMP a
          --WHERE  master_id   = @p_master_id   
          --AND    plan_id     = @p_engine_plan_id 
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
          INSERT INTO /* PR_SCP_ENG_EE_FN_PROC_DEMAND_ATTRIBUTE */ dbo.th_eng_demand_attribute_sn
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
        UPDATE /* PR_SCP_ENG_EE_FN_PROC_DEMAND_ATTRIBUTE */ dbo.th_eng_demand_attribute_sn
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
        -- 전체공통 임시테이블 1) FP tact_time 
         /*
            --소형(40) 전극이면서, item_uom = 'EA' 일때  
            -- PJ20209642 scm_mst_tact_time_sn -> scm_mst_tact_time_ver_h_v 변경
              =>  FP) tact_time :  scm_mst_tact_time_ver_h_v.tact_time / scp_mst_tact_time.uom_convert_value
                  단) scp_mst_tact_time.uom_convert_value 가 NULL이거나 0 이면 1 로 처리
        */
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#scm_mst_tact_time_sn') IS NOT NULL
        BEGIN
            DROP TABLE #scm_mst_tact_time_sn
        END 
         
        SELECT tt.company_id, tt.division_id, tt.site_id, tt.plant_id, tt.factory_id
             , tt.operation_id, tt.line_id, tt.item_id, tt.month, tt.daily_capa
            
             , CONVERT(NUMERIC(18, 4), CASE WHEN tt.division_group = '40' AND ISNULL(stt.item_uom, 'X') = 'EA' AND ISNULL(stt.operation_group, 'X') = 'E'  --2022.04.04변경: division_id -> division_group 
                                                 THEN  tt.tact_time/stt.uom_convert_value
                                            ELSE tt.tact_time
                                       END  ) AS tact_time  --FP의  tact_time 데이터 형식 : numeric(18,4)
            
            , tt.tact_time AS tact_time_org
            , stt.item_uom
            , stt.uom_convert_value         
        INTO   #scm_mst_tact_time_sn  

        FROM  (  -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                SELECT tt.* , di.attribute3 AS division_group , di.attribute4 AS division_comp 
                FROM   dbo.scm_mst_tact_time_ver_h_v tt WITH (NOLOCK) -- PJ20209642
                     , scm_mst_division   di WITH(NOLOCK)
                WHERE  di.division_id    =  tt.division_id
                AND    di.valid_yn       = 'Y'
                AND    di.attribute4     = @v_division_comp    --회사코드
              ) tt

        /* 20220404 변경전
        FROM   dbo.scm_mst_tact_time_ver_h_v tt WITH (NOLOCK)  -- PJ20209642 
        --FROM   dbo.scm_mst_tact_time_sn tt WITH (NOLOCK)        
        */  
                LEFT JOIN  ( SELECT aa.division_id, aa.plant_site_id, aa.item_id, aa.operation_id
                                --, aa.tact_time
                                , aa.item_uom
                                , aa.line_id

                                --UOM_CONVERT_VALUE 가 NULL이거나 0 이면 1 로 처리
                                , CASE WHEN aa.uom_convert_value = 0  THEN 1
                                        ELSE ISNULL(aa.uom_convert_value, 1)  
                                    END AS uom_convert_value

                                , bb.plant_id, bb.site_id, bb.company_id
                                , bb.operation_group
                                                           
                            FROM   scp_mst_tact_time aa WITH (NOLOCK)  
                                    INNER JOIN ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group(attribute3) )
                                                SELECT a.division_id, a.scm_site_id
                                                     , a.plant_id, a.site_id, a.company_id 
                                                     , a.operation_group
                                                FROM   scm_mst_site         a WITH(NOLOCK)  -- 소형('40') 인 division 값을 사용해야 하기 때문에  scm_mst_site_eng (전극일때 모든 scm_mst_site_eng.divison_id = 'EE')가 아닌  scm_mst_site 를 사용해야 한다.
                                                     , scm_mst_division    di WITH(NOLOCK)
                                                WHERE  1=1        
                                                AND    a.site_type       = 'PLANT'
                                                AND    a.operation_group = 'E'
                                                AND    a.valid_yn        = 'Y'

                                                and    a.division_id     = di.division_id 
                                                and    di.valid_yn       = 'Y'
                                                and    di.attribute3     = '40'             -- 2020.04.04 '소형' 구분
                                                and    di.ATTRIBUTE4     = @v_division_comp -- 2020.04.04 같은회사 데이터만 가져오기.   
                                                
                                                  /* 20220404 변경전 
                                                SELECT division_id, scm_site_id
                                                    , plant_id, site_id, company_id 
                                                    , operation_group
                                                FROM scm_mst_site WITH (NOLOCK)  -- 소형('40') 인 division 값을 사용해야 하기 때문에  scm_mst_site_eng (전극일때 모든 scm_mst_site_eng.divison_id = 'EE')가 아닌  scm_mst_site 를 사용해야 한다.
                                                WHERE  division_id = '40'            
                                                AND    site_type   = 'PLANT'
                                                AND    operation_group = 'E'
                                                AND    valid_yn = 'Y'  */ 
                                            ) bb
                                    ON   aa.division_id   = bb.division_id
                                    AND  aa.plant_site_id = bb.scm_site_id
                                    AND  aa.item_uom    = 'EA'
                            WHERE   1 = 1
                            AND     aa.valid_yn = 'Y'

                        ) stt
                ON   tt.company_Id   = stt.company_id
                AND  tt.division_id  = stt.division_id
                AND  tt.site_id      = stt.site_id 
                AND  tt.plant_id     = stt.plant_id
                AND  tt.operation_id = stt.operation_id  
                AND  tt.item_id      = stt.item_id
                AND  tt.line_id      = stt.line_id
        WHERE LEFT(tt.operation_id, 1) IN ('E', 'S', 'F', 'A')
        ;
        -----------------------------------------------------------
        --3-1)  demand의 item이 팩일때 하위셀 item / 셀일때 셀item의 Daily Capa 정보생성
        --      (단, demand의 item이 팩일때는 BOM상의 셀item 중에서 1000분 기준 MIN(Daily_Capa) 값을 가진 셀선호site, 셀item 정보를 임시테이블로 생성)
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#DEMAND_DAILY_CAPA_TEMP') IS NOT NULL
        BEGIN 
            DROP TABLE  #DEMAND_DAILY_CAPA_TEMP
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

            ,  x.division_id  -- 20180627 추가

            --,  x.accumulated_child_qty  --20180521 추가
             
        INTO   #DEMAND_DAILY_CAPA_TEMP
        FROM   (
                   SELECT a.*
                       
                       ,  CASE WHEN a.demand_item_operation_group  = 'A' AND a.child_item_operation_group = 'E' 
                                    THEN CEILING(b.max_daily_capa / a.accumulated_child_qty) 
                               ELSE b.max_daily_capa 
                          END  AS max_daily_capa  -- 20180903  수정 ( 변경전 : ,  b.max_daily_capa )

                       ,  b.max_daily_capa AS max_daily_capa_org  --20180521 수정 (변경전 : , b.max_daily_capa )
                       
                       --,  ROW_NUMBER() OVER (PARTITION BY a.demand_id ORDER BY IIF(b.max_daily_capa IS NULL, 99999999, b.max_daily_capa), a.child_item_id) row_num -- 20180903 수정
                       ,  ROW_NUMBER() OVER (PARTITION BY a.demand_id ORDER BY IIF(b.max_daily_capa IS NULL, 99999999, b.max_daily_capa), IIF(child_item_operation_group = 'E', 0, 1), a.child_item_id) row_num -- 20180903 수정
                   FROM  
                         ( 
                            SELECT demand_id
                                ,  child_item_id -- AS cell_item_id 
                                ,  accumulated_child_qty  --20180903 추가

                                --20180525 수정
                                , top_plant_site_id AS cell_site_id -- 20180525 수정

                                -- 20180525 수정
                                , dbo.fn_scm_split( top_plant_site_id, 1, '-') AS plant_id   --20180525 수정
                                
                                
                                ,  top_plant_site_id -- 최상위 plant_site_id ( 최상위 plant_site_id => demand item이  팩일때 : 팩사이트,  셀일때 : 셀사이트, 전극 : 전극사이트 )
                                ,  child_item_operation_group 
                                ,  demand_item_operation_group
                                ,  project_code 
                                ,  scm_site
                                ,  due_date 
                                ,  item  AS item_id   

                                ,  division_id  -- 20180627 추가
                            FROM   #DEMAND_ATTRIBUTE_SITE_PRIORITY_TEMP --20180525 수정 ( 변경전 : FROM   #DEMAND_ATTRIBUTE_SITE_PRIORITY_TEMP5 )
                          ) a

                          LEFT JOIN (  
                                       /*  전극의 MIN DAILY CAPA 사용시
                                            - scm_mst_tact_time_sn.tact_time  :  NULL, 0 제외
                                            - scm_mst_item_lane_m_sn.lane_qty :  NULL, 0 제외
                                            - operation_id                    :  'E2000' 으로 시작하는 모든 operation_id
                                            - MIN (Daily Capa)  :  MIN (  (60초 / tact_time) * 1000분 * 레인개수  ) ==> 참고) tact_time : 1개 만드는 시간(단위:초)
                                              ( 주의) 컬럼명이 'max_daily_capy' 인 이유는 최초개발시 MAX(daily capa)값을 사용한다고 해서 컬럼명이 max_daily_capa로 되었음
                                                      차후 값이 MIN(daily_capa) 값으로 수정되었음 )

                                       */
                          
                                       SELECT aa.division_id, aa.plant_id, aa.operation_id, aa.item_id
                                            --20180903 1000분기준으로 MIN tact time(전극이므로 tact time사용) 로 split, 티라요청으로 max->min으로 변경함
											-- PJ20209642 Lane 수는 View에서 고려되어 있음
                                            , ROUND(MIN( (60.0 / aa.tact_time) * 1000), 0) AS max_daily_capa  
                                            --, ROUND(MIN( (60.0 / aa.tact_time) * 1000 * ISNULL(bb.lane_qty, 1)), 0) AS max_daily_capa  
                                            
                                       FROM   #scm_mst_tact_time_sn aa WITH(NOLOCK) --20180928 수정			 
									   
									   /*-- PJ20209642 Lane 수는 View에서 고려되어 있음
                                               --20180928 수정처리함 (scm_mst_item_lane_m_sn.lane_qty -> scm_mst_item_line_assign_sn.lane_qty 변경)
                                                LEFT JOIN (SELECT DISTINCT la.company_id, la.division_id, la.site_id
                                                                        , la.plant_id, la.factory_id, la.item_id
                                                                        , la.operation_id, la.line_id
                                                                        , IIF(la.lane_qty = 0, 1, ISNULL(la.lane_qty, 1)) AS lane_qty  -- 20180928 추가(scm_mst_item_lane_m_sn.lane_qty 값을 scm_mst_item_line_assign_sn.lane_qty 변경하기 위해서 추가함)                                                                        
                                                                        --, la.lane_qty AS lane_qty_org
                                                        FROM   dbo.scm_mst_item_line_assign_sn la WITH(NOLOCK)
                                                        WHERE  1=1
                                                        AND    la.active_flag = 'Y'
                                                        AND    la.priority    NOT IN ('0', '9') -- 0/9 는 FP에서 사용 안 하는 정보임
                                                        AND    la.month        >= SUBSTRING(@p_plan_name, 1, 6) 
                                                        --AND    la.division_id = @p_division_id -- 20180702 주석처리                        
                                                ) bb
                                                ON     aa.company_id   = bb.company_id
                                                AND    aa.division_id  = bb.division_id
                                                AND    aa.site_id      = bb.site_id
                                                AND    aa.plant_id     = bb.plant_id
                                                AND    aa.factory_id   = bb.factory_id
                                                AND    aa.operation_id = bb.operation_id
                                                AND    aa.line_id      = bb.line_id
                                                AND    aa.item_id      = bb.item_id
                                       */   
                                       
                                       WHERE  aa.month        = SUBSTRING(@p_plan_name, 1, 6)
                                       AND    aa.operation_id  LIKE 'E2000%' -- 전극만 처리
                                       AND    ISNULL(aa.tact_time, 0) <> 0
                                       GROUP BY aa.division_id, aa.plant_id, aa.operation_id, aa.item_id

                                    ) b
                          ON   a.plant_id      = b.plant_id 
                          AND  a.child_item_id = b.item_id   --a.cell_item_id = b.item_id                          
                          AND  a.division_id   = b.division_id -- 20180627 추가

              ) x
        where x.row_num = 1
        ;        
        
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 3-1 END';
        SET @v_description = N'3-1 셀 Daily Capa 정보 INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -- 20180903 주석처리 ( 셀은 하위 전극으로 처리하므로  setup group 관련처리는 필요없음)

        -----------------------------------------------------------
        --3-3)  th_eng_demand_sn 테이블 최종 UPDATE
        --      - 1) 팩/셀일때 cell_item_id
        --      - 2) 팩/셀일때 cell_site_id
        --      - 3) 팩/셀일때 cell_setup_group_id
        --      - 4) 팩/셀일때 avg_setup_time
        --      - 5) 팩/셀일때 max_daily_capa
        -----------------------------------------------------------
        UPDATE #TH_ENG_NET_DEMAND_TEMP --th_eng_demand_sn
        SET    cell_item_id             = b.child_item_id --cell_item_id
            ,  cell_site_id             = b.cell_site_id
            ,  max_daily_capa           = b.max_daily_capa        
        
        --FROM   th_eng_demand_sn a WITH (NOLOCK)
        FROM   #TH_ENG_NET_DEMAND_TEMP a
               INNER JOIN #DEMAND_DAILY_CAPA_TEMP b --20180903 수정 (셀은 하위전극으로 처리하므로 SETUP GROUP 관련부분(주석3-2부분)을 처리하지 않으므로 테이블 변경함) --(변경전 : INNER JOIN #DEMAND_SETUP_GROUP_TEMP b )
               ON   a.demand_id = b.demand_id 
               AND  ( 
                       ( b.demand_item_operation_group = 'A' AND b.child_item_operation_group = 'E' ) --신규추가
                    )
        ;
        
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 3-3 END';
        SET @v_description = N'3-3 demand 임시정보 UPDATE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        -----------------------------------------------------------
        --3-4)  th_eng_demand_sn 테이블 shipping_date 변경
        --      -  shipping_date : ISNULL([due_date] - [BOD 우선순위 가장작은값의 L/T], shipping_date)
        --         ( 단, shipping_date 가 플랜시작일자보다 작으면 shipping_date는 플랜시작일자로 셋팅함 )

        --      참고) 1) shipping_date  최초 생성시 dm_pln_net_demand.yyyymmdd으로 셋팅되어있음
        --            2) DM 의demand 건만 처리하면됨( SCP의 Cell 생산 계획을 Demand로 반영(셀) 은  L/T = 0 이므로 처리안해도 됨)
        -----------------------------------------------------------
        UPDATE #TH_ENG_NET_DEMAND_TEMP --th_eng_demand_sn
        -- 20200323 [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - Hold VMI 대기 재고 Visibility 강화
        --            VMI 전진 검사 LT 추가 적용 : SCM_MST_SITE_ITEM 테이블의 SCP_VMI_LT 값 만큼 ETA에 더해 줌
           SET shipping_date = IIF(  @d_plan_name >  IIF((ISNULL(b.lt_total, 0) + ISNULL(si.lt_day, 0)) = 0
                                                        , shipping_date
                                                        , DATEADD(d, (ISNULL(b.lt_total, 0) + ISNULL(si.lt_day, 0)) * -1, due_date) 
                                                        ) 
                                   , @d_plan_name
                                   ,  IIF((ISNULL(b.lt_total, 0) + ISNULL(si.lt_day, 0)) = 0
                                         , shipping_date
                                         , DATEADD(d, (ISNULL(b.lt_total, 0) + ISNULL(si.lt_day, 0)) * -1, due_date) 
                                         ) 
                                  ) -- shipping_date 가 플랜시작일자보다 작으면 shipping_date는 플랜시작일자로 셋팅함
        --FROM   th_eng_demand_sn a WITH (NOLOCK)
        FROM  #TH_ENG_NET_DEMAND_TEMP a       
        INNER JOIN scm_mst_site sms WITH ( NOLOCK) -- DM demand의 전극 모델만 처리하기위해서
        ON a.plant_site_id = sms.scm_site_id 
        AND  sms.operation_group = 'E'
        AND  sms.valid_yn = 'Y'
        AND  sms.site_type = 'PLANT'
		--2021.06.07 수정, Join 데이터 변경
        --LEFT JOIN ( SELECT division_id, from_site, to_site, incoterms
        --                 , to_site + '~' + incoterms AS eng_to_site
        --                 , transport_mode
        --                 , priority 
        --                 , lt_total, ship_lt_total
        --                 , ROW_NUMBER() OVER (PARTITION BY division_id, from_site, to_site, incoterms ORDER BY priority) priority_row_num
        --            FROM   scp_mst_bod_v 
        --            WHERE  bod_valid_yn = 'Y'
        --            --AND    division_id = @p_division_id
        --          ) b
        --ON  a.plant_site_id    = b.from_site 
        --AND a.site             = b.eng_to_site
        --AND b.priority_row_num = 1 -- BOD의 우선순위 가장작은값			   
		--2021.07.07 재수정, 기간별 bod view 테이블 변경
        LEFT JOIN ( SELECT a.demand_id
                        , b.lt_total
                        , ROW_NUMBER() OVER (PARTITION BY a.demand_id ORDER BY b.to_yyyymmdd, b.priority) priority_row_num
                        FROM scp_mst_bod_n_v b WITH(NOLOCK)
					INNER JOIN #th_eng_net_demand_temp a WITH(NOLOCK)
						ON a.plant_site_id = b.from_site 
						AND a.site          = b.to_site + '~' + b.incoterms
						AND DATEADD(DAY, -b.lt_total, a.due_date) < b.to_yyyymmdd
                    WHERE  1=1
						AND    b.bod_valid_yn = 'Y'
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
                        --AND s.division_id  = @p_division_id
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
        SET @v_description = N'3-4 demand 임시정보 shipping_date UPDATE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


        -----------------------------------------------------------
        -- 3-5 demand 정보 INSERT (demand 임시테이블 생성정보를 실 테이블에 INSERT)
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_EE_FN_PROC_DEMAND_ATTRIBUTE */ th_eng_demand_sn 
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
         
         , demand_priority  -- 20180621 추가(DM의 우선순위)     
         , division_id      -- 20180627 추가
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
         
         , demand_priority  -- 20180621 추가(DM의 우선순위)     
         , division_id      -- 20180627 추가
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
        IF OBJECT_ID('tempdb..#DEMAND_CUTOFF_YYYYMMDD') IS NOT NULL
        BEGIN 
            DROP TABLE  #DEMAND_CUTOFF_YYYYMMDD          
        END 

        IF OBJECT_ID('tempdb..#TH_ENG_NET_DEMAND_TEMP') IS NOT NULL
        BEGIN 
            DROP TABLE  #TH_ENG_NET_DEMAND_TEMP          
        END 
        
        IF OBJECT_ID('tempdb..#DEMAND_ITEM_BOM_TEMP') IS NOT NULL
        BEGIN 
            DROP TABLE  #DEMAND_ITEM_BOM_TEMP
        END 

        IF OBJECT_ID('tempdb..#DEMAND_ITEM_BOM') IS NOT NULL
        BEGIN 
            DROP TABLE  #DEMAND_ITEM_BOM
        END

        IF OBJECT_ID('tempdb..#DEMAND_ATTRIBUTE_SITE_PRIORITY_TEMP') IS NOT NULL
        BEGIN 
            DROP TABLE  #DEMAND_ATTRIBUTE_SITE_PRIORITY_TEMP
        END     

        IF OBJECT_ID('tempdb..#DEMAND_ATTRIBUTE_TEMP') IS NOT NULL
        BEGIN 
            DROP TABLE  #DEMAND_ATTRIBUTE_TEMP
        END 

        IF OBJECT_ID('tempdb..#DEMAND_ATTRIBUTE') IS NOT NULL
        BEGIN 
            DROP TABLE  #DEMAND_ATTRIBUTE
        END 

        IF OBJECT_ID('tempdb..#scm_mst_tact_time_sn') IS NOT NULL
        BEGIN
            DROP TABLE #scm_mst_tact_time_sn
        END 

        IF OBJECT_ID('tempdb..#DEMAND_DAILY_CAPA_TEMP') IS NOT NULL
        BEGIN 
            DROP TABLE  #DEMAND_DAILY_CAPA_TEMP
        END 

    END; --IF @p_plan_type = 'MA' THEN

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
