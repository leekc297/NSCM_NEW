
/* 
 * Program ID   : PR_SCP_ENG_IN_PRE_PROC_DPP_DEMAND
 * Description  : demand 정보를 적재
                    
                  -----------------------------------------------------------
                  --1-1.demand 데이터 임시테이블 생성
                  ----------------------------------------------------------- 
                      - th_eng_demand_sn 에 생성된 데이터를 임시테이블에 생성

                  -----------------------------------------------------------
                  --1-2.(소형 분배대상 item 처리)  split  비대상/대상 demand 정보를 INSERT (소형일때만 처리됨, 자동차(81), ESS(82)은 이부분 처리안됨)
                  ----------------------------------------------------------- 
                      - 참고1) 소형분배대상 : DM_MST_CAPACITY_ALLOCATION 테이블에 존재하는 셀item
                               --  참고) dm_mst_capacity_allocation 테이블 해당월에 물량분배대상item이 없더라도 테이블 자체에 한번이라도 존재하면 물량분배 대상 item으로 셋팅함   
                  
                      - 참고2) priority : 1) yyyymmdd (due_date기준) (8자리)  -- 20190715 변경
                                            -- 20190715 변경 전  DM_MST_CAPACITY_ALLOCATION.yyyymm (해당 demand의 due_date 에서 해당월 사용)  (6자리)
                                     
                                     + 2) DM priority 앞2자리(DM의 Site 별 우선 순위 정보) (2자리) --20181130추가
                                     
                                     + 3) item의 해당월중 가장빠른 due_date (8자리)
                                     + 4) item_id 이름순으로 NUMBERING (5자리) 
                                     
                                     + 5) DM priority (6자리) --20181130추가  (참고) 고객 Priority(2자리) + Demand Type(1자리 /  1:CF, 2:UF, 3:NF ) + Due Date Priority(3자리)
                                     
                                     + 6) 내부 우선순위 (=DM_MST_CAPACITY_ALLOCATION 의 item_id, end_customer, scm_site_id 별 우선순위) : 내부우선순위는 아래 3) split 부분 참고 (6자리)
                                     + 7) DM_MST_CAPACITY_ALLOCATION.capacity_rate 작은순으로 Numbering (10자리)
                                     + 8) due_date (8자리)

                                      --20181130 변경전
                                       1) DM_MST_CAPACITY_ALLOCATION.yyyymm (해당 demand의 due_date 에서 해당월 사용)  (6자리)
                                     + 2) item의 해당월중 가장빠른 due_date (8자리)
                                     + 3) item_id 이름순으로 NUMBERING (5자리) 
                                     + 4) 내부 우선순위 (=DM_MST_CAPACITY_ALLOCATION 의 item_id, end_customer, scm_site_id 별 우선순위) : 내부우선순위는 아래 3) split 부분 참고 (6자리)
                                     + 5) DM_MST_CAPACITY_ALLOCATION.capacity_rate 작은순으로 Numbering (10자리)
                                     + 6) due_date (8자리)

                      - 참고3) split
                                   ; 위1)의 소형분배대상 셀item 만 처리됨

                                   1) SPLIT 대상 조회
                                      : DM_MST_CAPACITY_ALLOCATION 테이블의 item_id, end_customer, scm_site_id, yyyymm 해당되는 demand 데이터 
                                   
                                   2) '팩item일때 하위 셀item'/ '셀item' 에 해당되는 ([max_daily_capa]/[소요량]) 값을 구한다. (참고) 소요량 나누는 이유는 팩 하위 셀 일경우 팩단위로 daily capa룰 구하기 위해서 임)
                                   
                                   3) 분배대상 item의 sales site, end_customer별 분배수량(=해당 demend의 최대 가능 SPLIT 수량) 값을 구한다.
                                      :  ([분배대상 item의 sales site, end_customer별 해당월의 분배비율] / [분배대상 item의 해당월의 Max 분배비율]) 
                                          * 
                                         ( [분배대상 item의 MAX(Daily_Capa)] / [셀의 소요량] )
                                         => 최종값은 소숫점 올림처리함

                                         EX) 1) 분배대상item : DM_MST_CAPACITY_ALLOCATION.item_id 에 존재하는 item
                                             2) item의 sales site, end_customer별 해당월의 분배비율(DM_MST_CAPACITY_ALLOCATION.capacity_rate) : 10 
                                             3) 해당 item의 MAX(DM_MST_CAPACITY_ALLOCATION.capacity_rate) : 35
                                             4) 해당 item의 MAX Daily Capa /소요량       : 1000
                                        
                                             ==> 5) 분배대상 item의 sales site, end_customer별 해당월의 분배수량 : (10 / 35) * 1000 => (=위2 / 위3) * 위4
                                   
                                   4) 내부우선순위 기준
                                      : item, sales site, end_customer, yyyymm 별로 처리됨

                                   5) "SPLIT" 및 "내부우선순위"
                                      : 해당item의 모든 sales site, end_customer, yyyymm 별로 생성
                                        
                      
                                         --참고1) (전체 6자리중) 첫째자리가 '1' 로 시작일때  : 정상 split 대상인경우 
                                                                            '2' 로 시작일때  : 소형분배대상 item 의 해당월에 아래 경우에 포함될 경우
                                                                                               경우1) scm_mst_tact_time_sn 테이블에 daily capa 정보가 없을때 
                                                                                               경우2) DM_MST_CAPACITY_ALLOCATION.capacity_rate 값이 0, NULL 일때 
                                                                                               ==> 뒷 5자리 : 첫번째자리 '2'일때는 내부우선순위는 due_data 순으로 numbering
                                                                                                                        

                                        EX) -1) item의 sales site, end_customer별 해당월의 분배비율(DM_MST_CAPACITY_ALLOCATION.capacity_rate) : 8 
                                            -2) 해당 item의 demend정보에 존재하는 end_customer, sales site , yyyymm(due_date 기준) 중 MAX(DM_MST_CAPACITY_ALLOCATION.capacity_rate) : 10
                                            -3) 해당 item의 MAX Daily Capa /소요량       : 1000
                                            ==> 분배대상 item의 sales site, end_customer별 해당월의 분배수량 :  select (8 / 10.0) * 1000.0 = 800 => (=위2 / 위3) * 위4
                                                아래 참조) 800 개단위로  split 한다.


                                      due_date	      demand qty	 split개수     split qty	     내부우선순위
                                    2018-08-04	          1000	        2	          800	              1        ( 1번째 800 개포함, demand1)  
                                       	    		                                  200	              2        ( 2번째 800 개포함, demand1)
                                    2018-08-05 	           500	        1	          500	              2        ( 2번째 800 개포함, demand2)
                                    2018-08-06	           100	        1	          100	              2        ( 2번째 800 개포함, demand3) 
                                    2018-08-07	           300	        1	          300	              3        ( 3번째 800 개포함, demand4)  
                                    2018-08-15	          1000	        2	          500	              3        ( 3번째 800 개포함, demand5) 
                                                                                      500                 4        ( 4번째 800 개포함, demand5)  
                                    2018-08-16	          1500	        3	          300	              4        ( 4번째 800 개포함, demand6)
                                                                                      800	              5        ( 5번째 800 개포함, demand6)
                                                                                      400	              6        ( 6번째 800 개포함, demand6)
                                    2018-08-25	           100	        1	          100	              6        ( 6번째 800 개포함, demand7) 
                                    2018-08-30	          1700.225      3	          300	              6        ( 6번째 800 개포함, demand8) 
                                                                                      800	              7        ( 7번째 800 개포함, demand8)
                                                                                      600.225             8        ( 8번째 800 개포함, demand8) 참고) 마지막은 800개 보다작을때는 나머지 모든 qty


                      참고 테이블 및 뷰) 1) DM_MST_CAPACITY_ALLOCATION     : 소형 분배대상 item(셀만존재함)
                                         2) SCM_MST_MODEL_FINAL_ITEM_BOM_V : '팩 하위 셀'/'셀'의 소요량(accumulated_child_qty) 조회
                  -----------------------------------------------------------
                  --2-1. split 비대상 demand 정보를 INSERT
                  ----------------------------------------------------------- 
                    - 전극일때 split 비대상
                    - 팩은 BOM 상의 선호 셀이 없을경우 split 비대상

                  -----------------------------------------------------------
                  --2-2. split 대상 demand 정보를 INSERT
                  -----------------------------------------------------------
                    - 셀 일때 split 대상
                      ==> th_eng_demand_sn.max_daily_capa 수량으로 split (값이 없을경우 default : 10000개 수량으로 split)
                    - 팩은 BOM 상의 선호 셀이 있을경우 split 대상
                      ==> th_eng_demand_sn.max_daily_capa 수량으로 split (값이 없을경우 default : 10000개 수량으로 split)
 * OutTable     :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.01.26   KSW         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.06.21   KSW         demand_priority 컬럼추가
 * 2018.08.27   KSW         소형 물량분배 관련 수정
 * 2018.09.06   KSW         소형 물량분배 대상 item  priority 수정 (소형물량분배대상 정보( DM_MST_CAPACITY_ALLOCATION)에 존재하는 모든 item은 특정월에 데이터가 없더라도 소형물량분배대상으로 처리함)  참고)주석1-2-1
 * 2018.10.01   KSW         소형 물량분배 대상 팩개수보정 부분 수정(참고)주석1-2-7
 * 2018.11.14   KSW         소형분배 대상 조회 조건 추가(dm_mst_capacity_allocation.yyyymm >= LEFT(@p_plan_name)) (참고)주석1-2-1
 * 2018.11.30   KSW         소형(40)일때 priority 변경(DM 우선순위 적용) (참고)주석1-2-8
 * 2019.07.15   KSG         소형(40) priority : yyyymm (due_date기준) (6자리) 를 yyyymmdd (due_date기준) (8자리) 로 변경
 * 2020.06.02   KSG         전지 공급 대응력 향상을 위한 RTF 적확도 개선 : 전극 Simulation 고도화(ESS - Partail Plan 적용)
 * 2021.02.15   SDS         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - MOQ(출하Lot Size)단위의 Completed 출하계획 적용(ESS)
 * 2021.03.12   KSG         PJ20209642 Digital SCM Level.3 달성을 위한 개선 : 소형 분배 로직 삭제
 * 2021.05.26   KKC         PJ20209642 Digital SCM Level.3 달성을 위한 개선 : DEMAND SPLIT 옵션화
 * 2021.07.21   KKC         PJ20209642 Digital SCM Level.3 달성을 위한 개선 : DEMAND QTY < 1 데이터 소숫점 처리(계획수립시 무한루프 방지) 및 BUSINESS_TYPE 추가
 * 2022.04.04   LHS         PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선: JV사업부 추가: 사업부 조건별 로직구현시 division_id 대신 속성값(attribute3) 기준으로 변경
                                ----------------------------------------------------------------
                                        구분                         자동차           전극
                                ==============================    =============   ==============
                                  division_group(attribute3)  :        81              EE                
                                ------------------------------    -------------   --------------
                                  division_id                 :     81 , 81_UC      EE , EE_UC  
                                ----------------------------------------------------------------
 * 2022.04.29   LHS         PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선: 소형/ESS 출하확정계획 Project code 유지 건으로 NET_DEMAND 에 BUSINESS_TYPE값을 PROJECT_CODE로 설정.
 * 2023.03.07   SHS         PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행: DEMAND SPLIT 옵션 추가
 * 2023.04.18   KSG         PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 도전과제 계획
 * 2025.04.21   KJJ         E20250310-000135 셀 생산지별 공급계획 수립 엔진기능 개발         
 */

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_IN_PRE_PROC_DPP_DEMAND]
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_IN_PRE_PROC_DPP_DEMAND';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'TH_ENG_NET_DEMAND'; --'TH_ENG_NET_DEMAND/TH_DPP_NET_DEMAND';
    DECLARE @d_event_date   DATETIME;

    DECLARE @n_pre_plan_id       INTEGER = 0;
    DECLARE @n_cur_plan_id       INTEGER = 0;
    DECLARE @n_pre_week_plan_id  INTEGER = 0;
    DECLARE @n_cur_week_plan_id  INTEGER = 0;
    -- DECLARE @v_division_id       NVARCHAR(30);
    DECLARE @v_cur_monday        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    DECLARE @d_plan_name         DATETIME;

    DECLARE @n_split_count       NUMERIC(20,10) = 1.0; -- demand split count
    DECLARE @default_daily_capa  NUMERIC(5) = 10000; -- daily_capa 값이 없을경우 기본값 --20180827 추가

    DECLARE @v_split_yn          NVARCHAR(1);  --2021/05/26 추가, By KKC

    DECLARE @v_division_group   NVARCHAR(30);  ---(2022.04.04) 변수추가 
    DECLARE @v_division_comp    NVARCHAR(30); 

	/* DEMAND SPLIT 변수 추가,. 2023.03.07 */
	DECLARE @v_pack_capa_apply_yn NVARCHAR(30) = 'N';
	DECLARE @v_default_split_qty NUMERIC(5);
	DECLARE @v_to_daily_capa_apply DATETIME;
	DECLARE @v_weekly_capa_working_day NUMERIC(5);

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

    /*~(2022.04.29) Project code 유지여부 설정 변수 정의. * division_id, plan_type별 가부(Y/N)을 lookup에서 등록한다. ~*/ 
    DECLARE @v_hp_pjt_code_yn        NVARCHAR(30) = 'N'   ;   
	
    -- 20230418 PJ20230691 도전과제 처리 부분 수정 : BP/BF 추가
	SELECT @v_hp_pjt_code_yn =            
           CASE WHEN  @p_plan_type IN ('PR', 'BP') THEN (CASE WHEN ISNULL(SEGMENT2 ,'-') = 'Y' THEN 'Y' ELSE 'N' END )
                WHEN  @p_plan_type IN ('MA'      ) THEN (CASE WHEN ISNULL(SEGMENT3 ,'-') = 'Y' THEN 'Y' ELSE 'N' END )
                WHEN  @p_plan_type IN ('SE'      ) THEN (CASE WHEN ISNULL(SEGMENT4 ,'-') = 'Y' THEN 'Y' ELSE 'N' END )
                WHEN  @p_plan_type IN ('FN', 'BF') THEN (CASE WHEN ISNULL(SEGMENT5 ,'-') = 'Y' THEN 'Y' ELSE 'N' END )
                WHEN  @p_plan_type IN ('TE'      ) THEN (CASE WHEN ISNULL(ATTRIBUTE1 ,'-') = 'Y' THEN 'Y' ELSE 'N' END )   
           END  
	FROM   scm_adm_lookup_master_detail a WITH(NOLOCK) 
	WHERE  a.lookup_type = 'HP_PJT_CODE_YN'
    AND    a.segment1    =  @p_division_id
    AND    a.valid_yn    = 'Y' 
    ; 

	-- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id  ; 
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN
      
        DELETE /* PR_SCP_ENG_IN_PRE_PROC_DPP_DEMAND */
        FROM   th_eng_net_demand_sn 
        WHERE  master_id = @p_master_id 
        AND    plan_id   = @p_engine_plan_id 
        ;
                
		-----------------------------------------------------------
		-- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선
		-- Split 여부 옵션화, 2021/05/26, By KKC
        -----------------------------------------------------------
		/*
		SELECT @v_split_yn = ISNULL(a.segment2, 'N')   
		  FROM scm_adm_lookup_master_detail a(nolock)
		 WHERE a.lookup_type = 'DEMAND_DAILY_CAPA_SPLIT_YN'
		   AND a.SEGMENT1 = @p_division_id
		;
		*/

		-- 2023.03.07 DEMAND SPLIT APPLY ( DEMAND SPLIT OPTION ) 
		SELECT	@v_split_yn                = a.split_yn 							   -- DEMAND SPLIT 여부
			  , @v_default_split_qty       = ISNULL(a.default_split_qty,10000)	       -- DEFAULT SPLIT 수량
			  , @v_pack_capa_apply_yn      = ISNULL(a.pack_capa_apply_yn, 'N')		   -- PACK CAPA 적용 여부
			  , @v_to_daily_capa_apply     = DATEADD(WEEK,  ISNULL(a.daily_capa_apply_week,0), CONVERT(DATE, @p_plan_name))  
																					   -- 일 CAPA 적용구간(~To Period)
  			  , @v_weekly_capa_working_day =ISNULL(a.weekly_capa_working_day,0)	       -- 주간 WORKING DAY
		FROM	
				(
				 SELECT	b.segment1                 AS division_id 
					  , CONVERT(INT, b.segment2)   AS default_split_qty
					  , b.segment3                 AS pack_capa_apply_yn
					  , CONVERT(INT, b.segment4)   AS daily_capa_apply_week
					  , CONVERT(INT, b.segment5)   AS weekly_capa_working_day
					  , b.valid_yn                 AS split_yn	
				  FROM	scm_adm_lookup_master a WITH(NOLOCK) 	
				  JOIN	scm_adm_lookup_master_detail b WITH(NOLOCK)	
					ON	a.lookup_type = b.lookup_type	
				 WHERE	a.lookup_type = 'SCP_ENG_DEMAND_SPLIT'
				   AND	b.valid_yn = 'Y'
				) a
		WHERE a.division_id = @p_division_id
		;

		--Split여부 변수 Validation Check
		IF @v_split_yn IS NULL OR @v_split_yn != 'Y'
		   BEGIN
		       SET @v_split_yn = 'N';
		   END;

		-----------------------------------------------------------
		-- 2021.02.15 PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선
		--    MOQ(출하Lot Size)단위의 Completed 출하계획 적용(ESS))
        -----------------------------------------------------------
		BEGIN
			-----------------------------------------------------------
			--A-1. Lot Size 단위의 Split 대상 Demand 임시테이블로 생성
			-----------------------------------------------------------
			IF OBJECT_ID('tempdb..#demand_lot_size') IS NOT NULL 
			 BEGIN
				DROP TABLE #demand_lot_size
			 END

			SELECT a.demand_id
				 , a.qty 
				 , b.lot_size
				 , a.qty%b.lot_size AS remainder_qty		--나머지 수량
				 , CEILING(a.qty/b.lot_size) AS split_cnt	--SPLIT 횟수(나머지 수량을 고려하여 반드시 올림처리할 것)
			INTO #demand_lot_size
			FROM th_eng_demand_sn a WITH(NOLOCK)
                    INNER JOIN ( --(2022.04.04) JV사업부 추가: divisin_id대신 division속성값인 attribute3으로 변경.
                                SELECT c.*
                                FROM   scm_mst_site_item  c WITH(NOLOCK) 
                                    ,  scm_mst_division  di WITH(NOLOCK)
                                WHERE  c.division_id     =  di.division_id 
                                AND    di.valid_yn       = 'Y' 
                                AND    di.attribute3     = '82'   --ESS 사업부만 대상으로 한다.  
                                AND    di.attribute4     = @v_division_comp -- 같은회사 데이터만 가져오기
                                AND    c.partial_plan_yn = 'N'  
                    ) c
                    ON  1=1
                    AND c.scm_site_id  = a.scm_site
                    AND c.project_code = a.project_code
                    AND c.item_id      = a.item

			      /* 20220404 변경전  
                    INNER JOIN scm_mst_site_item c WITH(NOLOCK) 
					ON  c.division_id = '82'					--ESS 사업부만 대상으로 한다.  
					AND c.partial_plan_yn = 'N'   
					AND c.scm_site_id = a.scm_site
					AND c.project_code = a.project_code
					AND c.item_id = a.item 
                  */ 

					INNER JOIN ( --(2022.04.04) JV사업부 추가: divisin_id대신 division속성값인 attribute3으로 변경.
                                SELECT b.item_id
									 , b.to_site
									 , MAX(b.lot_size) as lot_size	--to_site 기준 최대값
								FROM   scp_mst_shipment_lot_size b WITH(NOLOCK)
                                     , scm_mst_division         di WITH(NOLOCK)
								WHERE  b.division_id  = di.division_id
								AND    di.valid_yn    = 'Y' 
                                AND    di.attribute3  = '82'
                                AND    di.attribute4  = @v_division_comp -- 같은회사 데이터만 가져오기
                                AND    b.valid_yn     = 'Y'
								AND    ISNULL(b.lot_size,0) > 0
                                GROUP BY b.item_id, b.to_site 
                             /* 20220404 변경 전 
								SELECT item_id
									 , to_site
									 , MAX(lot_size) as lot_size	--to_site 기준 최대값
								FROM   scp_mst_shipment_lot_size b WITH(NOLOCK)
								WHERE  division_id = '82'
								AND    valid_yn = 'Y'
								AND    ISNULL(lot_size,0) > 0
								GROUP BY item_id, to_site       */ 
					) b
					ON	b.item_id = a.item				
					AND b.to_site = a.scm_site
					AND b.lot_size < a.qty		-- SPLIT 대상만 
			WHERE a.master_id = @p_master_id	
			AND   a.plan_id   = @p_engine_plan_id	
			;
		
			-----------------------------------------------------------
			--A-2. 임시테이블 #copy_t_lot 생성
			-----------------------------------------------------------
			DECLARE @max_split_cnt NUMERIC(5)
			SELECT @max_split_cnt = ISNULL(MAX(split_cnt), 0)
			FROM   #demand_lot_size
			WHERE  1=1
			;

			IF OBJECT_ID('tempdb..#copy_t_lot') IS NOT NULL 
			 BEGIN
				DROP TABLE #copy_t_lot 
			 END
		 
			-- 1 ~ @max_split_cnt 값이 들어간 임시테이블 생성
			;WITH copy_t AS (
			   SELECT 1 no 
			   UNION ALL
			   SELECT no + 1
			   FROM   copy_t 
			   WHERE  no < @max_split_cnt --1000 이면  1000번까지 생성됨
			)
			SELECT * 
			INTO  #copy_t_lot
			FROM copy_t OPTION (MAXRECURSION 0)	--0은 제한이 없음을 의미함(lot size가 1일 경우를 대비해서 0으로 설정함)
			;
		
			-----------------------------------------------------------
			--A-3. Lot Size 단위의 Split Demand를 임시테이블로 생성
			-----------------------------------------------------------
			IF OBJECT_ID('tempdb..#demand_lot_size_split') IS NOT NULL 
			 BEGIN
				DROP TABLE #demand_lot_size_split 
			 END

			 SELECT a.demand_id
				 , a.qty 
				 , CONVERT(VARCHAR,b.no) as str  
				 , a.split_cnt
				 , a.demand_id+'^L'+REPLICATE('0', LEN(CONVERT(VARCHAR,@max_split_cnt))-LEN(CONVERT(VARCHAR,b.no))) + CONVERT(VARCHAR,b.no) AS lot_size_split_demand_id
				 , REPLICATE('0', LEN(CONVERT(VARCHAR,@max_split_cnt))-LEN(CONVERT(VARCHAR,b.no))) + CONVERT(VARCHAR,b.no) AS lot_size_split_char
				 , CASE 
						WHEN a.remainder_qty = 0 THEN a.lot_size	--나머지 수량이 0일 경우
						ELSE										--나머지 수량이 0보다 클 경우
							CASE 
								WHEN b.no = a.split_cnt THEN a.remainder_qty	--나머지 수량이 0보다 클 경우 마지막 수량을 나머지 수량으로
								ELSE a.lot_size									--LOT SIZE 수량
							END
				  END AS lot_size_split_qty
			INTO #demand_lot_size_split
			FROM #demand_lot_size a 

				INNER JOIN #copy_t_lot b WITH(NOLOCK)
				ON a.split_cnt >= b.no

			WHERE 1=1
			ORDER BY a.demand_id, b.no
			 ;
		END --2021.02.15 MOQ(출하Lot Size)단위의 Completed 출하계획 적용(ESS)) 종료

        -----------------------------------------------------------
        --1-1. 대상 demand 데이터 임시테이블로 생성
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#th_eng_demand') IS NOT NULL 
         BEGIN
            DROP TABLE #th_eng_demand
         END

        SELECT a.master_id
	     , a.plan_id
		 --2021.02.15 Lot Size로 Split된 Demand의 DEMAND_ID
	     , ISNULL(lot.lot_size_split_demand_id, a.demand_id) AS demand_id	--a.demand_id AS demand_id(수정 전)
	     , a.sales_model_id
	     , a.shipping_date
	     , a.due_date
	     , a.due_fence_date
	     , a.early_producing_term
	     , a.early_producing_term_uom
		 --2021.02.15 Lot Size로 Split된 Demand 수량
	     , ISNULL(lot.lot_size_split_qty, a.qty) AS qty					--a.qty AS qty(수정 전)
		 , ISNULL(lot.lot_size_split_qty, a.split_qty) AS split_qty		--a.split_qty AS split_qty(수정 전)
	     , a.order_type
	     , a.demand_type
	     , a.producing_type
	     , a.priority_group_code
		 --2021.02.15 Lot Size로 Split된 Demand 우선순위
		 --a.priority(수정 전)
         , CASE WHEN @v_division_group = '82' THEN              --(2022.04.04) JV사업부 추가 변수변경: @p_division_id -> @v_division_group 
                  CASE 
				    WHEN lot.lot_size_split_char IS NULL THEN	--Lot Size Split 대상이 아닐 경우
					  a.priority + REPLICATE('0', LEN(CONVERT(VARCHAR,@max_split_cnt))) + '1'	--예)001 or 0001 or 00001....
				    ELSE										--Lot Size Split 대상일 경우
					  a.priority + lot.lot_size_split_char
                  END

				ELSE a.priority
			END AS priority
	     , a.attribute_checker_id
	     , a.demand_group_id
	     , a.late_type
	     , a.descr
	     , a.move_time_rate
	     , a.buffer_time_rate
	     , a.is_exception
	     , a.is_consume
	     , a.item
	     , a.site
	     , a.scm_site         
         , a.project_code                
         , a.plant_site_id
         , a.org_cell_site_id
         , a.org_elec_site_id           
         , a.avg_setup_time
         , a.cell_site_setup_group_id          
         , a.cell_site_id
         , a.cell_item_id         
		 --, ISNULL(a.max_daily_capa, @default_daily_capa) AS max_daily_capa         
		 -- 2023.03.07	DEMAND SPLIT APPLY
         , CASE WHEN @v_pack_capa_apply_yn = 'Y' THEN 
		            CASE WHEN a.max_daily_capa_pack IS NOT NULL THEN 
																	  CASE WHEN a.max_daily_capa_pack = 0 THEN  CASE WHEN a.max_daily_capa = 0 THEN @v_default_split_qty
																	                                                 ELSE ISNULL(a.max_daily_capa , @v_default_split_qty)
																												 END
																		   WHEN a.max_daily_capa > a.max_daily_capa_pack THEN a.max_daily_capa_pack
																		   WHEN a.max_daily_capa = 0  THEN a.max_daily_capa_pack
																	       ELSE ISNULL(ISNULL(a.max_daily_capa, a.max_daily_capa_pack), @v_default_split_qty)
																		END
                         WHEN a.max_daily_capa = 0              THEN  @v_default_split_qty
						 ELSE ISNULL(a.max_daily_capa , @v_default_split_qty)
					 END
				ELSE							
					 CASE WHEN a.max_daily_capa = 0 THEN @v_default_split_qty
					      ELSE ISNULL(a.max_daily_capa , @v_default_split_qty)
					  END
			END max_daily_capa 
		, a.demand_priority  -- 20180621 추가(DM의 우선순위)              
		 --2021.02.15 Lot Size로 Split된 Demand의 max_div_count
         --, ceiling(a.qty/ISNULL(a.max_daily_capa, @default_daily_capa)) AS max_div_count  -- split 개수(수정 전)
		 --, ceiling(ISNULL(lot.lot_size_split_qty, a.qty)/ISNULL(a.max_daily_capa, @default_daily_capa)) AS max_div_count  -- split 개수     
		 -- 2023.03.07	DEMAND SPLIT 수정
		, CEILING(ISNULL(lot.lot_size_split_qty, a.qty)
				/	 CASE WHEN @v_pack_capa_apply_yn = 'Y' THEN 
								CASE WHEN a.max_daily_capa_pack IS NOT NULL THEN 
																					CASE WHEN a.max_daily_capa_pack = 0 THEN  CASE WHEN a.max_daily_capa = 0 THEN @v_default_split_qty
																																	ELSE ISNULL(a.max_daily_capa , @v_default_split_qty)
																																END
																						WHEN a.max_daily_capa > a.max_daily_capa_pack THEN a.max_daily_capa_pack
																						WHEN a.max_daily_capa = 0  THEN a.max_daily_capa_pack
																						ELSE ISNULL(ISNULL(a.max_daily_capa, a.max_daily_capa_pack), @v_default_split_qty)
																					END
										WHEN a.max_daily_capa = 0              THEN  @v_default_split_qty
										ELSE ISNULL(a.max_daily_capa , @v_default_split_qty)
									END
							ELSE							
									CASE WHEN a.max_daily_capa = 0 THEN @v_default_split_qty
										ELSE ISNULL(a.max_daily_capa , @v_default_split_qty)
									END
						END
			) AS max_div_count  -- split 개수         
         , 'N' AS demand_allocation_yn                             --20180827 추가 소형물량분배때문에 추가함
         , CONVERT(NVARCHAR(6), due_date, 112) AS due_date_yyyymm  --20180827 추가 소형물량분배때문에 추가함
		 -- 20200602 ESS - 통합 Shipment Plan 적용 : 'N'이면 합치는 계획 수립
		 --   completed_shipping_id : Demand ID 에서 NF/UF/CF 항목 제거함
		 /*(수정 전)
   		 , CASE WHEN par.partial_plan_yn = 'N' 
                  THEN a.item + '::' +  a.project_code  + '::' +  a.site  
                       + '::' + SUBSTRING(a.descr, 1, DBO.FN_CHARINDEX_REV(a.descr, '::', 0)-1) 
                       + '::' + CONVERT(CHAR(8), a.due_date, 112) 
                       + '::' + a.plant_site_id
                    --THEN REPLACE(
                    --             REPLACE(
                    --                     REPLACE(a.demand_id, '::CF::', '::')
                    --                   , '::UF::', '::')
                    --           , '::NF::', '::')
                ELSE NULL  -- 엔진 Defalut 는 Partial 계획임
           END completed_shipping_id
		   */
		   -- 2021.02.15 Lot Size로 Split된 Demand의 completed_shipping_id
		  , CASE 
				WHEN par.partial_plan_yn = 'N' THEN 
					CASE 
						WHEN lot.lot_size_split_char is null THEN 
						       a.item + '::' +  a.project_code  + '::' +  a.site  
							   + '::' + SUBSTRING(a.descr, 1, DBO.FN_CHARINDEX_REV(a.descr, '::', 0)-1) 
							   + '::' + CONVERT(CHAR(8), a.due_date, 112) 
							   + '::' + a.plant_site_id
						ELSE
						       a.item + '::' +  a.project_code  + '::' +  a.site  
							   + '::' + SUBSTRING(a.descr, 1, DBO.FN_CHARINDEX_REV(a.descr, '::', 0)-1) 
							   + '::' + CONVERT(CHAR(8), a.due_date, 112) 
							   + '::' + a.plant_site_id
							   + '::' + 'L'+lot.lot_size_split_char 	--MOQ(출하Lot Size)단위의 Completed 출하계획 대상 DEMAND 적용
					END 
                ELSE NULL  -- 엔진 Defalut 는 Partial 계획임
		    END completed_shipping_id
        INTO  #th_eng_demand
        FROM  th_eng_demand_sn a WITH (NOLOCK)        
		 -- 20200602 ESS - 통합 Shipment Plan 적용
        LEFT OUTER JOIN ( --(2022.04.04) JV사업부 추가: divisin_id대신 division속성값인 attribute3으로 변경.
                         SELECT c.division_id, c.scm_site_id, c.project_code, c.item_id, c.partial_plan_yn
                         FROM   scm_mst_site_item  c WITH(NOLOCK) 
                             ,  scm_mst_division  di WITH(NOLOCK)
                         WHERE  c.division_id       =  di.division_id 
                         AND    di.valid_yn         = 'Y' 
                         AND    di.attribute3       = '82' -- ESS만 대상 
                         AND    di.attribute4       = @v_division_comp  -- 같은회사 데이터만 가져오기
                         AND    c.partial_plan_yn   = 'N'  -- 통합 Shipment Plan 적용 대상
                       /* 20220404 변경전 
                         SELECT division_id, scm_site_id, project_code, item_id, partial_plan_yn
                         FROM   scm_mst_site_item WITH(NOLOCK) 
                         WHERE  division_id     = '82' -- ESS만 대상        
                         AND    partial_plan_yn = 'N'  -- 통합 Shipment Plan 적용 대상   */ 
                        ) par        
        ON    a.scm_site     = par.scm_site_id
        AND   a.project_code = par.project_code
        AND   a.item         = par.item_id
		-- 2021.02.15 ESS MOQ(출하Lot Size)단위의 Completed 출하계획 대상 Demand
		LEFT OUTER JOIN #demand_lot_size_split AS lot
		ON	a.demand_id = lot.demand_id
        WHERE a.master_id = @p_master_id  
        AND   a.plan_id   = @p_engine_plan_id 
        ;
		
        -----------------------------------------------------------
        --2-1. split 대상 demand 정보 INSERT
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_DPP_DEMAND */ th_eng_net_demand_sn 
        ( master_id
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
        , is_consume
        , item
        , site
        , scm_site
        , demand_priority        -- 20180621 추가        
		, completed_shipping_id  -- 20200602 ESS - Partail Plan 적용
        , project_code           -- 20210122 추가
		, business_type          -- 20210721 추가
		, attr05                 -- 2023.03.07 추가 (엔진 Split 수량 기준)
		, plant_type			 -- 2025.04.21 추가
        )
        SELECT master_id
             , plan_id
             , demand_id
             , sales_model_id
             --20180514 수정 yyyymmdd => yyyymmdd 23::59::59 변경
             --, shipping_date
             --, due_date
             --, due_fence_date
             , DATEADD(ss,86399, CONVERT(DATETIME, shipping_date))  AS shipping_date
             , DATEADD(ss,86399, CONVERT(DATETIME, due_date))       AS due_date
             , DATEADD(ss,86399, CONVERT(DATETIME, due_fence_date)) AS due_fence_date             
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
             , is_consume
             , item
             , site
             , scm_site           
             , demand_priority -- 20180621 추가
			 , completed_shipping_id  -- 20200602 ESS - Partail Plan 적용
             , project_code    -- 20210122 추가
              /*~(2022.04.29) lookup의 설정여부에 따라 business_type값 정의: SALES 사이트에 LOOKUP=Y이면 project_code값을, 그 외는 'ALL'로 설정 ~*/ 
            , CASE WHEN @v_hp_pjt_code_yn = 'Y'  AND project_code != '-'  THEN project_code
                   ELSE 'ALL' 
              END  AS business_type 
			 -- 2023.03.07	DEMAND SPLIT APPLY
			 , CASE	WHEN @v_split_yn = 'N'            THEN qty
			        WHEN max_daily_capa IS NULL       THEN qty
			        WHEN max_daily_capa = 0           THEN qty
					ELSE 
						CASE WHEN due_date < @v_to_daily_capa_apply THEN max_daily_capa
							 ELSE max_daily_capa * @v_weekly_capa_working_day
						END
				END AS eng_split_qty	
			, CASE WHEN LEN(org_cell_site_id) < 4 THEN NULL
			       ELSE org_cell_site_id
			  END AS plant_type --2025.04.21 추가	
         FROM  #th_eng_demand
		/* 2023.03.07 Engine Custom Split으로 주석처리
		/* Split 여부 옵션화, 2021/05/26, By KKC */
        WHERE	1 = CASE WHEN @v_split_yn = 'N' THEN 1
						ELSE 
						     CASE WHEN ISNULL(dbo.fn_scm_split(dbo.fn_scm_split(priority_group_code, 2, '::'), 2, '-'), 'N') <> 'A' THEN 1
		                          ELSE 0
							   END
					END
        AND		demand_allocation_yn = 'N' --20180827 소형물량분배 비대상건 조회
		*/
        ;
				
        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id; 
        SET @v_description = N'split 대상...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        
		/***********************************************************
		   --2023.03.07 
		   DEMAND SPLIT DATA 생성 로직 주석 처리 Start ~
		 : Engine Custom에서 SPLIT_QTY 기준으로 SPLIT하는 로직 구현 
		-----------------------------------------------------------
		-- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선
		-- Split 여부 옵션화, 2021/05/26, By KKC
        -----------------------------------------------------------
        IF @v_split_yn = 'N'
		BEGIN
		      GOTO SKIP1;
		END
		
		-----------------------------------------------------------
        --2-2. split 대상(셀('A')만 대상임) demand 정보를 INSERT        
        -----------------------------------------------------------

        -----------------------------------------------------------
        --2-2-1. copy_t 임시 테이블 생성
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#copy_t') IS NOT NULL 
         BEGIN
            DROP TABLE #copy_t
         END

        DECLARE @max_div_count NUMERIC(5)
        SELECT @max_div_count = MAX(ceiling(qty/ISNULL(max_daily_capa, @default_daily_capa)))
        FROM   #th_eng_demand
        WHERE  dbo.fn_scm_split(dbo.fn_scm_split(priority_group_code, 2, '::'), 2, '-') = 'A' --셀일때 
        AND    demand_allocation_yn = 'N' --20180827 소형물량분배 비대상건 조회
        ;

        -- 1 ~ @max_div_count 값이 들어간 임시테이블 생성
        ;WITH copy_t AS (
           SELECT 1 no 
           UNION ALL
           SELECT no + 1
           FROM   copy_t 
           WHERE  no < @max_div_count --1000 이면  1000번까지 생성됨
        )
        SELECT * 
        INTO  #copy_t
        FROM copy_t OPTION (MAXRECURSION 32767)
        ;

        -----------------------------------------------------------
        --2-2-2) split 대상 demand 정보를 임시테이블로 생성
             -- split 대상 : 팩(BOM 상의 선호 셀로 처리)/셀 
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_DPP_DEMAND */ th_eng_net_demand_sn
        ( master_id
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
        , is_consume
        , item
        , site
        , scm_site  
        , demand_priority        -- 20180621 추가        
		, completed_shipping_id  -- 20200602 ESS - Partail Plan 적용
        , project_code           -- 20210122 추가
		, business_type          -- 20210721 추가
        )
        SELECT a.master_id
            ,  a.plan_id
            ,  CASE WHEN a.max_div_count <> 1 THEN a.demand_id + '^S_' + CONVERT(NVARCHAR(10), b.no)
                    ELSE a.demand_id 
               END  AS demand_id
                        
            , a.sales_model_id

            --20180514 수정 yyyymmdd => yyyymmdd 23::59::59 변경
            , DATEADD(ss,86399, CONVERT(DATETIME, a.shipping_date))  AS shipping_date
            , DATEADD(ss,86399, CONVERT(DATETIME, a.due_date))       AS due_date
            , DATEADD(ss,86399, CONVERT(DATETIME, a.due_fence_date)) AS due_fence_date

            , a.early_producing_term
            , a.early_producing_term_uom
            
             , CASE WHEN a.max_div_count <> b.no  THEN a.max_daily_capa --a.qty  --AND a.qty <= a.max_daily_capa 
                    WHEN a.max_div_count = b.no   THEN IIF(a.qty % a.max_daily_capa = 0, a.max_daily_capa, a.qty % a.max_daily_capa)
               END  AS qty
            
             , CASE WHEN a.max_div_count <> b.no  THEN a.max_daily_capa --a.qty  --AND a.qty <= a.max_daily_capa 
                    WHEN a.max_div_count = b.no   THEN IIF(a.qty % a.max_daily_capa = 0, a.max_daily_capa, a.qty % a.max_daily_capa)
               END  AS split_qty

            , a.order_type
            , a.demand_type
            , a.producing_type
            , a.priority_group_code
            , a.priority + dbo.FN_ZERO_LPAD( b.no, 5) AS priority

            , a.attribute_checker_id
            , a.demand_group_id
            , a.late_type
            , a.descr
            , a.move_time_rate
            , a.buffer_time_rate
            , a.is_exception
            , a.is_consume
            , a.item
            , a.site
            , a.scm_site
            , a.demand_priority        -- 20180621 추가          
			, a.completed_shipping_id  -- 20200602 ESS - Partail Plan 적용
            , a.project_code           -- 20210122 추가
              /*~(2022.04.29) lookup의 설정여부에 따라 business_type값 정의: SALES 사이트에 LOOKUP=Y이면 project_code값을, 그 외는 'ALL'로 설정 ~*/ 
            , CASE WHEN @v_hp_pjt_code_yn = 'Y'  AND project_code != '-'  THEN project_code
                   ELSE 'ALL' 
              END  AS business_type 
			  /* 20220429 변경전
            , 'ALL'                    -- 20210721 추가  
			  */
        FROM  (SELECT master_id
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
	                , is_consume
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
                    , max_div_count    -- split 개수
					, completed_shipping_id  -- 20200602 ESS - Partail Plan 적용
                FROM   #th_eng_demand 
                WHERE  dbo.fn_scm_split(dbo.fn_scm_split(priority_group_code, 2, '::'), 2, '-') = 'A' --셀일때
                AND    demand_allocation_yn = 'N' --20180827 소형물량분배 비대상건 조회
              ) a
           ,  #copy_t b
        WHERE  b.no <= a.max_div_count 
        ;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id; 
        SET @v_description = N'split 대상...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        
		-----------------------------------------------------------
		-- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선
		-- Split 여부 옵션화, 2021/05/26, By KKC
        -----------------------------------------------------------
		SKIP1:

		   DEMAND SPLIT DATA 생성 로직 주석 처리 ~ End
		 : Engine Custom에서 SPLIT_QTY 기준으로 SPLIT하는 로직 구현 
		2023.03.07 -----------------------------------------------------------*/

        /* 1이하 소숫점 처리, 2021.07.21 추가 */
        DELETE a
		  FROM th_eng_net_demand_sn  a
         WHERE a.master_id = @p_master_id 
           AND a.plan_id   = @p_engine_plan_id 
		   AND CONVERT(NUMERIC, a.qty) = 0
        ;

        UPDATE a
		   SET a.qty = 1
		  FROM th_eng_net_demand_sn a 
         WHERE a.master_id = @p_master_id 
           AND a.plan_id   = @p_engine_plan_id 
		   AND a.qty < 1
		   AND CONVERT(NUMERIC, a.qty) = 1
        ;

        ------------------------------------------------------------
        --임시테이블 삭제
        ------------------------------------------------------------
		IF OBJECT_ID('tempdb..#demand_lot_size') IS NOT NULL 
			BEGIN
			DROP TABLE #demand_lot_size
			END

		IF OBJECT_ID('tempdb..#copy_t_lot') IS NOT NULL 
			BEGIN
			DROP TABLE #copy_t_lot 
			END			

		IF OBJECT_ID('tempdb..#demand_lot_size_split') IS NOT NULL 
			BEGIN
			DROP TABLE #demand_lot_size_split 
			END

        IF OBJECT_ID('tempdb..#th_eng_demand') IS NOT NULL 
         BEGIN
            DROP TABLE #th_eng_demand
         END

        IF OBJECT_ID('tempdb..#demand_allocation') IS NOT NULL 
        BEGIN
            DROP TABLE #demand_allocation
        END

        IF OBJECT_ID('tempdb..#demand_accumulated') IS NOT NULL
        BEGIN 
            DROP TABLE  #demand_accumulated
        END

        IF OBJECT_ID('tempdb..#demand_allocation_daily_capa') IS NOT NULL
        BEGIN 
            DROP TABLE  #demand_allocation_daily_capa
        END

        IF OBJECT_ID('tempdb..#demand_split_temp1') IS NOT NULL 
        BEGIN
            DROP TABLE #demand_split_temp1
        END

        IF OBJECT_ID('tempdb..#demand_split_temp2') IS NOT NULL 
        BEGIN
            DROP TABLE #demand_split_temp2
        END

        IF OBJECT_ID('tempdb..#allocation_copy_t') IS NOT NULL 
         BEGIN
            DROP TABLE #allocation_copy_t
         END

        IF OBJECT_ID('tempdb..#demand_split') IS NOT NULL 
        BEGIN
            DROP TABLE #demand_split
        END

        IF OBJECT_ID('tempdb..#demand_inner_priority_temp') IS NOT NULL
        BEGIN 
            DROP TABLE  #demand_inner_priority_temp
        END

        IF OBJECT_ID('tempdb..#demand_inner_priority') IS NOT NULL
        BEGIN 
            DROP TABLE  #demand_inner_priority
        END

        IF OBJECT_ID('tempdb..#copy_t') IS NOT NULL 
         BEGIN
            DROP TABLE #copy_t
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
