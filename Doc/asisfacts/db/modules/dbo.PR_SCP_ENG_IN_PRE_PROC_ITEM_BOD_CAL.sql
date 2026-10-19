
/*    
 * Program ID   : PR_SCP_ENG_IN_PRE_PROC_ITEM_BOD_CAL
 * Description  : ODB의 Item BOD Cal 정보를 ODB에 적재되도록 한다.
                  
             -----------------------------------------------------------
             -- 1-1. Plant 내부용 임시 BOD가 아닌 정상 BOD (is_use = 'N' 데이터만 적재)
             --    - scm_mst_site_item_priority(from_yyyymmdd ~ to_yyyymmdd)  이외 구간일때 IS_USE='N'처리
             -----------------------------------------------------------
                -- 1) 
                      - 기간1) th_eng_bucket_info테이블에서 master_id, plan_id 에 해당되는 데이터의 MIN(start_dttm)~MAX(end_dttm) 기간
                      - 기간2) scm_mst_site_item_priority의 a.division_id, a.scm_site_id, a.item_id GROUY BY한 min(from_yyyymmdd)~max(to_yyyymmdd) 기간
                      ==> 기간1)에서 기간2)를 제외한 부분을 is_use = 'N'으로 데이터 생성
                   
                      참고) 정상 BOD : 
                            - BOD 정보의 내부용 임시 BOD는 셀사이트의 '~001', '~002' site를  추가함으로써 발생  
                              경우1) from site가 '~***'로 끝나고, to site가 '~001'로끝남 
                              경우2) from site가 '~001'로 끝나고, to site가 '~002'로끝남 
                              ==> 경우1) 과 경우2)가 아닌 경우일때 정상BOD 이다
                            
                            - 정상 BOD 쿼리조건  :
                                         SUBSTRING(bod.from_site_id, 1, CHARINDEX('~', bod.from_site_id)-1)
                                         <> SUBSTRING(bod.to_site_id, 1, CHARINDEX('~', bod.to_site_id)-1)  
             
             -----------------------------------------------------------
             -- 1-2. Plant 내부용 임시 BOD가 아닌 정상 BOD (is_use = 'N' 데이터만 적재) --20180910 추가
             --    - scp_mst_bod_item(from_yyyymmdd ~ to_yyyymmdd)  이외 구간일때 IS_USE='N'처리
             -----------------------------------------------------------
                                                     
             -----------------------------------------------------------			
             -- 2-1. 항차고려한 IS USE = 'N' 인것만 처리(Y정보 필요 없음)
             --      - scm_mst_site_item_priority(from_yyyymmdd ~ to_yyyymmdd)  구간중 항차여부 'N'일때 IS_USE='N'처리
             -----------------------------------------------------------			
                -- 1) is_use = 'N' 데이터만 적재
                      - BOD 마스터의 항차정보 'N" 건을 is_use = 'N'으로 적재
                      - 항차여부가 'N' 요일이 연결되어이 있으면 요일별로 각각 데이터를 생성하지 않고 1개의 데이터로 생성함(자세한 사항은 아래 구현부분의 주석을 참고)
                      - start_dttm, end_dttm 일자를 항차 LeadTime(scp_mst_bod_v.ship_lt_total) 값만큼 차감한다
                      
                      - (20181019  추가) 항차적용 가능한 incoterms 조건 추가
                                         SELECT segment1 AS incoterms 
                                         FROM   scm_adm_lookup_master_detail WITH (NOLOCK)
                                         WHERE  lookup_type = 'INCOTERMS'
                                         AND    valid_yn = 'Y'
                                         AND    segment5 = 'Y'  -- 항차적용여부

             -----------------------------------------------------------			
             -- 2-2. 항차의 시작일과 종료일이 6일차이  데이터처리               
             -----------------------------------------------------------			
                -- 항차 와 휴무일(ssp_mst_ship_calendar)의 IS_USE = 'N' 처리후 모든일자가 IS_USE = 'N' 될수 있기때문에 처리필요
                -- 항차고려한 IS USE = 'N' 설정에서 start_dttm, end_dttm의 차이가 6일이면 
                   end_dttm 이하일자 중에 MAX(ssp_mst_ship_calendar.workday = 'Y') 일자를 end_dttm으로 셋팅
             
             -----------------------------------------------------------
             -- 3. Plant 내부용 임시 BOD가 아닌 정상 BOD 중 SSP_MST_SHIP_CALENDAR.workday_yn = 'N' 건 is_use = 'N' 처리
             -----------------------------------------------------------
                -- 1) 20180424 추가1)
                      - bod from site의 company_id로 SSP_MST_SHIP_CALENDAR 테이블과 조인해서 
                        SSP_MST_SHIP_CALENDAR 테이블의 'workday_yn' = 'N' 건을 is_use = 'N' 처리함 
                      
                      - 위 1, 2 와  start_dttm 겹치는 구간은 제외시킨다( 데이터 건수 즐이기 위해서)
                      - 동일 국가내 공장으로 나가는 거는 N 처리 제외시킨다.
                        ( 단, 동일국가내 공장으로 나가는 거지만 to 사이트가 외부packer(scm_mst_site_eng.osp_yn = 'Y') 일때는 is_use = 'N'처리 한다.)

                      참고) 정상 BOD : 
                            - BOD 정보의 내부용 임시 BOD는 셀사이트의 '~001', '~002' site를  추가함으로써 발생  
                              경우1) from site가 '~***'로 끝나고, to site가 '~001'로끝남 
                              경우2) from site가 '~001'로 끝나고, to site가 '~002'로끝남 
                              ==> 경우1) 과 경우2)가 아닌 경우일때 정상BOD 이다
                            
                            - 정상 BOD 쿼리조건  :
                                         SUBSTRING(bod.from_site_id, 1, CHARINDEX('~', bod.from_site_id)-1)
                                         <> SUBSTRING(bod.to_site_id, 1, CHARINDEX('~', bod.to_site_id)-1)  
             
             -----------------------------------------------------------
             -- 4. BOD alt_priority 1순위 데이터 생성
                   -- 1) BOD alt_priority 1순위 제외한 데이터 임시테이블 생성(start_dttm : plan 시작, end_dttm : plan 종료)
                   -- 2) BOD alt_priority 1순위 제외한 기생성된 데이터 삭제
                   -- 3) 위1)에서 생성한 임시테이블 INSERT
             -----------------------------------------------------------

             -----------------------------------------------------------			
             -- 5. 특성 BOD에 대하여 수율 설정
	         -----------------------------------------------------------			
                -- 1) F6000만 수율적용
                      - F6000 의 수율은 특성용 BOD(001 -> 002)에만 반영하고, IS_USE = 'Y'로 셋팅
                      - 당월, 차월은 FP용 yield 정보사용, 차월이후는   SCP용 yield 정보사용함
                        ( 단, 당월, 차월의 FP용 yield정보가 없을경우는 SCP용 yiled 정보사용함)
                         
                      - 외주셀(osp_yn = 'Y')이 아닐때만 처리함
                
                -- 2) F5300, F5500 수율적용 (20181109 추가)

                참고) FP용  수율 참조 테이블 : [dbo].[scm_mst_yield_ver_h_v]  
                      SCP용 수율 참조 테이블 : [dbo].[SCP_MST_FORMATION]

 * OutTable     : TH_ENG_ITEM_BOD_CAL
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.01.22   KSW         전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.05.24   KSW         IS_USE = 'N'일때 동일 start_dttm 건 제외
 * 2018.05.25   KSW         IS_USE = 'N'일때 2순위이상 데이터 처리부분 수정( 변경전 : 4-1)처리부분에서 th_eng_item_bod_cal_sn  테이블 조인처리, 변경후 :  th_eng_item_bod_cal_sn 테이블 조인부분에서 제외시킴)  
 * 2018.05.29   KSW         항차의 시작일과 종료일이 6일차이  데이터처리 추가(참고주석 2-2)
 * 2018.05.31   KSW         항차의 시작일과 종료일이 6일차이  데이터처리 end_dttm 조회조건 변경
 * 2018.07.05   KSG         LATE TYPE 변경 / 13주 추가기간 설정
 * 2018.08.07   KSW         외주셀(TCO 셀) 적용관련 수정 ( 주석5-1) 특성 BOD 대상 임시테이블생성 : A 사이트만 대상 : OSP 인 경우는 대상 아님)
 * 2018.08.08   KSW         BOD alt_priority 1순위 데이터 생성시 END_DTTM 일자값변경(th_eng_bucket_info.descr = 'ADD'의 [최종 END_DTTM] 일자로 변경)
 * 2018.09.10   KSW         BOD ITEM 자동생성 관련 수정 (참고)주석1-2)
 * 2018.10.17   KSW         th_eng_item_bod_cal_sn.end_dttm 컬럼 값 변경 ( 기존 : 플랜종료일(@p_pet_date) 를  th_eng_bucket_info_sn.end_dttm 종료일(th_eng_bucket_info_sn.descr = 'ADD'의 최종일) 로 변경)  (참고) 주석1-1, 주석1-2-1
 * 2018.10.19   KSW         항차적용 가능한 incoterms 조건 추가(참고)주석2-1
 * 2018.11.09   KSW         F5300, F5500 공정 수율적용(해당공정 하드코딩을 lookup 테이블조회로 변경) (참고)주석5-1
 * 2018.12.27   KSW         1) (속도개선) 조회조건 변경 (참고)주석2-1
                            2) scp_mst_formation.formation_yield(scp_mst_formation_except.formation_yield) 컬럼을 formation_total_yield로 변경( formation_yield컬럼 : 활성화수율, char_yield 컬럼 : 특성화수율, formation_total_yield : 활성화 * 특성화 수율) (참고)주석5전체
 * 2019.04.08   KSW         [전지고도화]특성 수율 사용 부분 수정 (기존은 당월,차월 일때는 FP특성수율(scm_mst_yield_ver_h_v.yield)을 사용중이었으나, 특성전체수율(활성수율*특성수율)로 변경됨에 따라 scm_mst_yield_ver_h_v.yield(특성수율) * scp_mst_formation.formation_yield(활성수율) 처리해야한다.) (참고)주석5전체
 * 2020.03.23   KSG         [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - Hold VMI 대기 재고 Visibility 강화
 *                             post_buffer_time : Null 적용을 전부 BOD Item의 post_buffer_time 값으로 적용
 * 2021.03.12   KSG         PJ20209642 Digital SCM Level.3 달성을 위한 개선 : FP Yield Table 변경
 * 2021.06.07   SEO			PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - ITEM BOD의 유효일자를 BOD의 유효일자로 대체
 * 2021.07.19   KKC			PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 1순위 BOD만 ITEM BOD Cal 생성
 * 2021.08.26   KKC			PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 기간별 우선순위별 Item Bod Cal 생성
                                                                                     (기간별 BOD 생성시 UI상 From Period 기준으로 1순위가 기간 중복 발생 가능)
 * 2023.01.30   LHS         PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2: BOD의 from site가 외주 Plant일 경우 일자별 출하여부(y/n) 반영하여 Item BOD Calendar 생성.
 * 2023.02.27   LHS         PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행: BOD의 from site가 외주 Plant일 경우 COMPANY별 휴무일 추가로직에서 제외.
 * 2023.08.07   LHS         PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2 : 속도개선 작업
 */

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_IN_PRE_PROC_ITEM_BOD_CAL]   
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_IN_PRE_PROC_ITEM_BOD_CAL';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'TH_ENG_ITEM_BOD_CAL';
    DECLARE @d_event_date   DATETIME;

    DECLARE @n_pre_plan_id       INTEGER = 0;
    DECLARE @n_cur_plan_id       INTEGER = 0;
    DECLARE @n_pre_week_plan_id  INTEGER = 0;
    DECLARE @n_cur_week_plan_id  INTEGER = 0;
    DECLARE @d_plan_name         DATETIME = CONVERT(DATETIME, @p_plan_name) ;   -- 당주 월요일 YYYYMMDD
    DECLARE @d_pet_date          DATETIME ; -- Plan End Date

    DECLARE @d_bucket_end_date   DATETIME ; --20180808추가  th_eng_bucket_info.descr = 'ADD'의 최종 END_DTTM-1

  -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ; 
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN
        
        -- plan 최종일
        SELECT @d_pet_date = CONVERT(DATETIME,p.horizon_end_date)
        FROM   dbo.scm_mst_plan p WITH(NOLOCK)
        WHERE  p.division_id = @p_division_id 
        AND    p.plan_id     = @p_plan_id ;
        ;

        -- bucket 최종일
        SELECT @d_bucket_end_date = max(end_dttm) 
        FROM   dbo.th_eng_bucket_info_sn WITH(NOLOCK)
        WHERE  master_id = @p_master_id
        AND    plan_id   = @p_engine_plan_id
        --AND    descr     = 'ADD'
        ;

        DELETE /* PR_SCP_ENG_IN_PRE_PROC_ITEM_BOD_CAL */
        FROM   th_eng_item_bod_cal_sn
        WHERE  master_id = @p_master_id
        AND    plan_id   = @p_engine_plan_id 
        ;		

        -----------------------------------------------------------
        -- 임시테이블 생성
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#TH_ENG_ITEM_BOD_CAL') IS NOT NULL
        BEGIN 
            DROP TABLE  #TH_ENG_ITEM_BOD_CAL          
        END

        CREATE TABLE #TH_ENG_ITEM_BOD_CAL(
	        master_id nvarchar(50) not null,
	        plan_id nvarchar(50) not null,
	        item_id nvarchar(50) not null,
	        bod_id nvarchar(150) not null,
	        alt_priority numeric(20, 10) null default ((1)),
	        alt_rate numeric(20, 10) null default ((1)),
	        start_dttm datetime not null,
	        end_dttm datetime not null,
	        transfer_lot_size numeric(20, 10) null,
	        is_prev_lot_size nvarchar(1) null default ('N'),
	        is_pull nvarchar(1) null default ('Y'),
	        pre_buffer_time numeric(20, 10) null,
	        post_buffer_time numeric(20, 10) null,
	        buffer_time_uom nvarchar(10) null default ('MINUTE'),
	        is_use nvarchar(1) null default ('Y'),
	        route_selector_id nvarchar(150) null,
	        safety_stock_term numeric(20, 10) null,
	        safety_stock_term_uom nvarchar(10) null,
	        safety_stock_qty numeric(20, 10) null,
	        descr nvarchar(2000) null,
	        early_producing_term numeric(20, 10) null,
	        early_producing_term_uom nvarchar(10) null default ('DAY'),
	        yield numeric(20, 10) null,
            --gubun numeric(20, 10) null
        )
        ;
        -----------------------------------------------------------
        -- 1-1. Plant 내부용 임시 BOD가 아닌 정상 BOD
        --   - scm_mst_site_item_priority(from_yyyymmdd ~ to_yyyymmdd) 이외의 구간을 IS_USE='N'처리
        -----------------------------------------------------------
        WITH with_select_query AS (
           SELECT ib.master_id              AS master_id
                 , ib.plan_id                AS plan_id
                 , ib.item_id                AS item_id
                 , ib.bod_id                 AS bod_id
                 , ib.alt_priority           AS alt_priority
                 , 1	                     AS alt_rate
             
                 --, bi.start_dttm             AS start_dttm
                 --, bi.end_dttm               AS end_dttm
             
                 , NULL                      AS transfer_lot_size
                 ,'N'                        AS is_prev_lot_size
                 ,'Y'                        AS is_pull
                 , ib.pre_buffer_time        AS pre_buffer_time 
                 , ib.post_buffer_time       AS post_buffer_time   -- 20200323 [전지 공급 대응력 향상을 위한 RTF 적확도 개선] : th_eng_item_bod_sn 값 적용
                 --, NULL                      AS post_buffer_time
                 , 'DAY'                     AS buffer_time_uom
                 , 'N'                       AS is_use
                 , ib.route_selector_id      AS route_selector_id
                 , ib.safety_stock_term      AS safety_stock_term      
                 , ib.safety_stock_term_uom  AS safety_stock_term_uom
                 , 0                         AS safety_stock_qty
                 , NULL                      AS descr
                 , 0                         AS early_producing_term
                 , 'DAY'                     AS early_producing_term_uom
                 , ib.yield                  AS yield 
                 
                 , sip.min_site_item_priority_from_yyyymmdd
                 , sip.max_site_item_priority_to_yyyymmdd
                 , bi.min_bucket_info_start_dttm
                 , bi.max_bucket_info_end_dttm

                        --insert_type 1) from_yyyymmdd 시작이 bucket 시작보다 작거나 같고, to_yyyymmdd 종료가 bucket 종료보다 작은경우
                 , CASE WHEN sip.min_site_item_priority_from_yyyymmdd <= bi.min_bucket_info_start_dttm
                             AND
                             sip.max_site_item_priority_to_yyyymmdd < bi.max_bucket_info_end_dttm
                             THEN 1
                        --insert_type 2) from_yyyymmdd 시작이 bucket 시작보다 크거나 같고, to_yyyymmdd 종료가 bucket 종료보다 작은경우
                        WHEN sip.min_site_item_priority_from_yyyymmdd >= bi.min_bucket_info_start_dttm
                             AND
                             sip.max_site_item_priority_to_yyyymmdd < bi.max_bucket_info_end_dttm
                             THEN 2
                        --insert_type 3) from_yyyymmdd 시작이 bucket 시작보다 크거나 같고, to_yyyymmdd 종료가 bucket 종료보다 같거나 큰 경우
                        WHEN sip.min_site_item_priority_from_yyyymmdd >= bi.min_bucket_info_start_dttm
                             AND
                             sip.max_site_item_priority_to_yyyymmdd >= bi.max_bucket_info_end_dttm
                             THEN 3
                   END insert_type
                 , copy_t_gubun 

            FROM   th_eng_item_bod_sn       ib  WITH(NOLOCK)
                   INNER JOIN th_eng_bod_sn bod WITH(NOLOCK)
                   ON  ib.master_id = bod.master_id
                   AND ib.plan_id   = bod.plan_id
                   AND ib.bod_id    = bod.bod_id
                
                   LEFT JOIN ( SELECT a.division_id, a.plant_site_id AS scm_site_id, a.item_id   -- 20180323 scm_site_id 컬럼명 변경으로 수정함(scm_site_id 없어지고 plant_site_id, sales_site_id 컬럼 생김)
                                    , min(a.from_yyyymmdd) min_site_item_priority_from_yyyymmdd
                                    , max(a.to_yyyymmdd) max_site_item_priority_to_yyyymmdd
                               FROM   scm_mst_site_item_priority a WITH (NOLOCK)
                               WHERE  a.division_id = @p_division_id  
                               AND    a.valid_yn = 'Y'
                               
                               GROUP BY a.division_id, a.plant_site_id, a.item_id) sip    -- 20180323 scm_site_id 컬럼명 변경으로 수정함(scm_site_id 없어지고 plant_site_id, sales_site_id 컬럼 생김)
                   ON  ib.item_id   = sip.item_id 
                   --20180409 수정 (셀  ~***, ~001, ~002, ~003 로 변경)  --20180308 수정 (전극 from_site, to_site ~002, ~003 삭제, 셀  from_site, to_site ~002, ~003, ~004 => ~001, ~002로 변경) (변경전 : --20180306 수정 (전극 from_site, to_site ~002, ~003 삭제, 셀  from_site, to_site ~002, ~003, ~004 => ~001로 변경))
                   AND (RTRIM(bod.from_site_id) = RTRIM(sip.scm_site_id)  + '~***'
                        OR 
                        RTRIM(bod.from_site_id) = RTRIM(sip.scm_site_id)  + '~001' 
                        OR 
                        RTRIM(bod.from_site_id) = RTRIM(sip.scm_site_id)  + '~002' --20180308 추가 
                        OR 
                        RTRIM(bod.from_site_id) = RTRIM(sip.scm_site_id)  + '~003' --20180409 추가 
                       )             

                   LEFT JOIN ( SELECT  @p_master_id         AS master_id
                                     , @p_engine_plan_id    AS plan_id 
                                     , MIN(start_dttm)      AS min_bucket_info_start_dttm
                                     , MAX(end_dttm)        AS max_bucket_info_end_dttm
                                FROM   th_eng_bucket_info_sn   WITH(NOLOCK)
                                WHERE  master_id = @p_master_id  
                                AND    plan_id   = @p_engine_plan_id 

                                --20181017 수정(th_eng_bucket_info_sn.end_dttm 최종값(descr='ADD'의 최종일) 변경하기 위해서 주석처리함)
                                --AND    descr     = 'PLAN'  -- 2018.07.05 추가 (  plan시작일~ plan종료일 : descr = 'PLAN' , plan종료일이후~ 13주 : descr = 'ADD')

                              ) bi
                   on   ib.master_id = bi.master_id
                   AND  ib.plan_id   = bi.plan_id

               ,  ( SELECT 1 copy_t_gubun UNION ALL SELECT 2 ) copy_t
            WHERE  ib.master_id = @p_master_id 
            AND    ib.plan_id   = @p_engine_plan_id  
		           -- Plant 내부용 임시 BOD가 아닌 정상 BOD
            AND    SUBSTRING(bod.from_site_id, 1, CHARINDEX('~', bod.from_site_id)-1)
                   <> SUBSTRING(bod.to_site_id, 1, CHARINDEX('~', bod.to_site_id)-1)
        
                  -- bucket_info 사용가능 기간내에  scm_mst_site_item_priority의 사용기간에 존재하는 데이터
            AND   ( 
                      ( sip.min_site_item_priority_from_yyyymmdd >= bi.min_bucket_info_start_dttm
                        AND 
                        sip.min_site_item_priority_from_yyyymmdd < bi.max_bucket_info_end_dttm
                      )
                      OR
                      ( sip.max_site_item_priority_to_yyyymmdd > bi.min_bucket_info_start_dttm 
                        AND
                        sip.max_site_item_priority_to_yyyymmdd <= bi.max_bucket_info_end_dttm
                      )
                  )
       ) --WITH 문  with_select_query  종료 
      
       INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_ITEM_BOD_CAL */ #TH_ENG_ITEM_BOD_CAL
        (   master_id
          , plan_id
          , item_id
          , bod_id
          , alt_priority
          , alt_rate
          , start_dttm
          , end_dttm
          , transfer_lot_size
          , is_prev_lot_size
          , is_pull
          , pre_buffer_time
          , post_buffer_time
          , buffer_time_uom
          , is_use
          , route_selector_id
          , safety_stock_term
          , safety_stock_term_uom
          , safety_stock_qty
          , descr
          , early_producing_term
          , early_producing_term_uom
          , yield
          --, gubun  -- 처리 구분을 위햐서 임의생성 컬럼(기존테이블에는 없는 컬럼)
        )
       SELECT master_id                 AS master_id
            , plan_id                   AS plan_id
            , item_id                   AS item_id
            , bod_id                    AS bod_id
            , alt_priority              AS alt_priority
            , 1	                        AS alt_rate
            
            , CASE WHEN copy_t_gubun=1 AND insert_type = 1 THEN DATEADD(d, 1, max_site_item_priority_to_yyyymmdd) 
                    
                   WHEN copy_t_gubun=1 AND insert_type = 2 THEN min_bucket_info_start_dttm
                   WHEN copy_t_gubun=2 AND insert_type = 2 THEN DATEADD(d, 1, max_site_item_priority_to_yyyymmdd) 
                    
                   WHEN copy_t_gubun=1 AND insert_type = 3 THEN min_bucket_info_start_dttm
              END  AS start_dttm
            
              -- is_use = 'N'일자 조회시 [start_dttm <= '해당일자' AND  "해당일자" < end_dttm] 이런식으로 사용되기 때문에 end_dttm 일자는 대상일(IS_USE='N')보다 +1일된 일자이다.(ex) is_use = 'N'일자 20180315일경우 ==> [start_dttm >= '20180315' AND end_dttm < '20180316'] 조건설정함)
            , CASE WHEN copy_t_gubun=1 AND insert_type = 1 THEN max_bucket_info_end_dttm --DATEADD(d, -1, max_bucket_info_end_dttm)
                    
                   WHEN copy_t_gubun=1 AND insert_type = 2 THEN min_site_item_priority_from_yyyymmdd  --DATEADD(d, -1, min_site_item_priority_from_yyyymmdd) 
                   WHEN copy_t_gubun=2 AND insert_type = 2 THEN max_bucket_info_end_dttm
                    
                   WHEN copy_t_gubun=1 AND insert_type = 3 THEN min_site_item_priority_from_yyyymmdd --DATEADD(d, -1, min_site_item_priority_from_yyyymmdd) 
              END  AS end_dttm
            
            , NULL                      AS transfer_lot_size
            , 'N'                       AS is_prev_lot_size
            , 'Y'                       AS is_pull
            , pre_buffer_time           AS pre_buffer_time 
            , post_buffer_time          AS post_buffer_time
            , 'DAY'                     AS buffer_time_uom
             
            , 'N'                       AS is_use

            , route_selector_id         AS route_selector_id
            , safety_stock_term         AS safety_stock_term      
            , safety_stock_term_uom     AS safety_stock_term_uom
            , 0                         AS safety_stock_qty
            , 'Site Item Priority'      AS descr
            , 0                         AS early_producing_term
            , 'DAY'                     AS early_producing_term_uom
            , yield                  AS yield  
            
            --, 1                      AS gubun  --20180515 추가
       FROM   with_select_query
       WHERE  ( insert_type = 2
                OR
                (insert_type IN (1, 3) AND copy_t_gubun = 1)
              )
        ;

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 1-1 END';
        SET @v_description = N'1-1. 정상 BOD (scm_mst_site_item_priority 이외 구간을 IS_USE=N 처리) INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        --------------------------------------------------------------------------------------------------------------------

        -----------------------------------------------------------
        -- 1-2. 정상 BOD
        --   - scp_mst_bod_item(from_yyyymmdd ~ to_yyyymmdd) 이외 구간을 IS_USE='N'처리
        -----------------------------------------------------------

        IF OBJECT_ID('tempdb..#SCP_MST_BOD_ITEM_EXCEPT') IS NOT NULL
        BEGIN 
            DROP TABLE  #SCP_MST_BOD_ITEM_EXCEPT           
        END
        DECLARE @v_pet_date NVARCHAR(8) = CONVERT(NVARCHAR(8), @d_pet_date, 112);
        DECLARE @v_bucket_end_date NVARCHAR(8) = CONVERT(NVARCHAR(8), @d_bucket_end_date, 112); --20181017 추가
           
        --------------------------------------------------------
        -- 1-2-1) scp_mst_bod_item의 from_yyyymmdd ~ to_yyyymmdd 이외 구간 임시테이블로 생성
        --------------------------------------------------------
		SELECT  a.division_id
			, a.bod_id_org
			, a.bod_id
			, a.item_id
			, a.priority
			, a.from_yyyymmdd
			, a.to_yyyymmdd   -- to_yyyymmdd 일까지 포함( ex) to_yyyymmdd : 20191231 => 20191231일까지 포함됨)
                   
			, a.group_cnt  --divsion_id, bod_id, item_id  별 개수
			, a.group_no  -- divsion_id, bod_id, item_id  별 순번
			, a.next_from_yyyymmdd --divsion_id, bod_id, item_id  별 다음행의 from_yyyymmdd
			, a.next_from_to_diff -- [다음행  from_yyyymmdd] - [현재행 to_yyyymmdd] 일자 수
                
		,  b.gubun
		   --20181017 수정 플랜종료일->bucket 종료일로 변경
		,  CASE WHEN a.group_no = 1 AND b.gubun = 1  AND @p_plan_name < a.from_yyyymmdd       THEN  CONVERT(DATETIME, @p_plan_name)
				WHEN a.group_no = 1 AND b.gubun = 2  AND ISNULL(a.next_from_to_diff, 0) > 1   THEN  DATEADD(d, 1, CONVERT(DATETIME, a.to_yyyymmdd))  --a.next_from_yyyymmdd
                        
				WHEN a.group_no > 1 AND b.gubun = 2  AND a.group_no <> a.group_cnt AND ISNULL(a.next_from_to_diff, 0) > 1 THEN  DATEADD(d, 1, CONVERT(DATETIME, a.to_yyyymmdd)) --a.next_from_yyyymmdd
                        
				WHEN                    b.gubun = 2  AND a.group_no = a.group_cnt  AND @v_bucket_end_date > a.to_yyyymmdd        THEN  DATEADD(d, 1, CONVERT(DATETIME, a.to_yyyymmdd)) 
                        
			END  AS start_dttm

		,  CASE WHEN a.group_no = 1 AND b.gubun = 1  AND @p_plan_name < a.from_yyyymmdd       THEN  CONVERT(DATETIME, a.from_yyyymmdd)
				WHEN a.group_no = 1 AND b.gubun = 2  AND ISNULL(a.next_from_to_diff, 0) > 1   THEN  CONVERT(DATETIME, a.next_from_yyyymmdd)
                        
				WHEN a.group_no > 1 AND b.gubun = 2  AND a.group_no <> a.group_cnt AND ISNULL(a.next_from_to_diff, 0) > 1 THEN  CONVERT(DATETIME, a.next_from_yyyymmdd)
                        
				WHEN                    b.gubun = 2  AND a.group_no = a.group_cnt  AND @v_bucket_end_date > a.to_yyyymmdd THEN  CONVERT(DATETIME, @v_bucket_end_date) 
			END  AS end_dttm

        INTO   #SCP_MST_BOD_ITEM_EXCEPT
        FROM   (    
                SELECT aa.division_id
                    , aa.bod_id AS bod_id_org
                    , aa.item_id + '::' + bod_id AS bod_id 
                    , aa.item_id
                    , aa.attribute1 AS priority          --scp_mst_bod_item.priority 값
                    , aa.eff_start_date AS from_yyyymmdd
                    , aa.eff_end_date   AS to_yyyymmdd   -- eff_end_date 일까지 포함( ex) eff_end_date : 20191231 => 20191231일까지 포함됨)

                    , COUNT(*) OVER (PARTITION BY aa.division_id, aa.bod_id, aa.item_id) AS group_cnt  --divsion_id, bod_id, item_id  별 개수
                    , ROW_NUMBER() OVER (PARTITION BY aa.division_id, aa.bod_id, aa.item_id ORDER BY aa.eff_start_date ) AS group_no  -- divsion_id, bod_id, item_id  별 순번
                    , LEAD(aa.eff_start_date) OVER (PARTITION BY aa.division_id, aa.bod_id, aa.item_id ORDER BY aa.eff_start_date ) AS next_from_yyyymmdd --divsion_id, bod_id, item_id  별 다음행의 from_yyyymmdd
                    , DATEDIFF(d, aa.eff_end_date, LEAD(aa.eff_start_date) OVER (PARTITION BY aa.division_id, aa.bod_id, aa.item_id ORDER BY aa.eff_start_date )) AS next_from_to_diff -- [다음행  from_yyyymmdd] - [현재행 to_yyyymmdd] 일자 수 
                FROM   scm_mst_bod_item_eng aa WITH (NOLOCK)
                WHERE  aa.modeling_id = @p_modeling_id      
                AND    aa.plan_id     = @p_plan_id           
                AND    aa.plan_type   = @p_plan_type          
                AND    aa.plan_seq    = @p_seq               
                AND    aa.division_id = @p_division_id        
                AND    dbo.fn_scm_split(aa.bod_id, 1, '::') <> 'x'  -- 정상 BOD 만 조회하기위해서

                ) a
            , (SELECT 1 gubun UNION ALL SELECT 2 gubun) b               
        WHERE  1 = 1
                --20181017 플랜종료일-> bucket 종료일로 변경
        AND    (CASE WHEN a.group_no = 1 AND b.gubun = 1  AND @p_plan_name < a.from_yyyymmdd       THEN  CONVERT(DATETIME, @p_plan_name)
                    WHEN a.group_no = 1 AND b.gubun = 2  AND ISNULL(a.next_from_to_diff, 0) > 1   THEN  DATEADD(d, 1, CONVERT(DATETIME, a.to_yyyymmdd)) 
                        
                    WHEN a.group_no > 1 AND b.gubun = 2  AND a.group_no <> a.group_cnt AND ISNULL(a.next_from_to_diff, 0) > 1 THEN  DATEADD(d, 1, CONVERT(DATETIME, a.to_yyyymmdd)) 
                        
                    WHEN                    b.gubun = 2  AND a.group_no = a.group_cnt  AND @v_bucket_end_date > a.to_yyyymmdd        THEN  DATEADD(d, 1, CONVERT(DATETIME, a.to_yyyymmdd)) 
                        
                END)  IS NOT NULL  --start_dttm IS NOT NULL 조회조건
           
        AND    (CASE WHEN a.group_no = 1 AND b.gubun = 1  AND @p_plan_name < a.from_yyyymmdd       THEN  CONVERT(DATETIME, a.from_yyyymmdd)
                    WHEN a.group_no = 1 AND b.gubun = 2  AND ISNULL(a.next_from_to_diff, 0) > 1   THEN  CONVERT(DATETIME, a.next_from_yyyymmdd)
                        
                    WHEN a.group_no > 1 AND b.gubun = 2  AND a.group_no <> a.group_cnt AND ISNULL(a.next_from_to_diff, 0) > 1 THEN  CONVERT(DATETIME, a.next_from_yyyymmdd)
                        
                    WHEN                    b.gubun = 2  AND a.group_no = a.group_cnt  AND @v_bucket_end_date > a.to_yyyymmdd THEN  CONVERT(DATETIME, @v_bucket_end_date) 
                END) IS NOT NULL  --end_dttm IS NOT NULL 조회조건
           
        ;

        --------------------------------------------------------
        --1-2-2) INSERT
        --       scp_mst_bod_item의 from_yyyymmdd ~ to_yyyymmdd 이외 구간 IS_USN = 'N' 처리
        --------------------------------------------------------
        INSERT INTO  /* PR_SCP_ENG_IN_PRE_PROC_ITEM_BOD_CAL */ #TH_ENG_ITEM_BOD_CAL
        (     master_id
            , plan_id
            , item_id
            , bod_id
            , alt_priority
            , alt_rate
            , start_dttm
            , end_dttm
            , transfer_lot_size
            , is_prev_lot_size
            , is_pull
            , pre_buffer_time
            , post_buffer_time
            , buffer_time_uom
            , is_use
            , route_selector_id
            , safety_stock_term
            , safety_stock_term_uom
            , safety_stock_qty
            , descr
            , early_producing_term
            , early_producing_term_uom
            , yield
        )
        SELECT 
                @p_master_id                AS master_id
                , @p_engine_plan_id         AS plan_id
                , ib.item_id                AS item_id
                , ib.bod_id                 AS bod_id
                , ib.alt_priority           AS alt_priority
                , 1	                        AS alt_rate
             
                , sbi.start_dttm            AS start_dttm
                , sbi.end_dttm              AS end_dttm
             
                , NULL                      AS transfer_lot_size
                ,'N'                        AS is_prev_lot_size
                ,'Y'                        AS is_pull
                , ib.pre_buffer_time        AS pre_buffer_time 
                , ib.post_buffer_time       AS post_buffer_time   -- 20200323 [전지 공급 대응력 향상을 위한 RTF 적확도 개선] : th_eng_item_bod_sn 값 적용
                --, NULL                      AS post_buffer_time
                , 'DAY'                     AS buffer_time_uom
                , 'N'                       AS is_use
                , ib.route_selector_id      AS route_selector_id
                , ib.safety_stock_term      AS safety_stock_term      
                , ib.safety_stock_term_uom  AS safety_stock_term_uom
                , 0                         AS safety_stock_qty
                , 'SCP_MST_BOD_ITEM_EXCEPT' AS descr						--2021.06.07 변경(뒷단에서 사용하기 때문에 변경하면 안됨!!!!!)
                , 0                         AS early_producing_term
                , 'DAY'                     AS early_producing_term_uom
                , ib.yield                  AS yield                 
            
        FROM   th_eng_item_bod_sn       ib  WITH(NOLOCK)
                INNER JOIN th_eng_bod_sn bod WITH(NOLOCK)
                ON  ib.master_id = bod.master_id
                AND ib.plan_id   = bod.plan_id
                AND ib.bod_id    = bod.bod_id
                AND ib.master_id = @p_master_id 
                AND ib.plan_id   = @p_engine_plan_id 

                INNER JOIN  #SCP_MST_BOD_ITEM_EXCEPT sbi
                ON   ib.bod_id = sbi.bod_id
                   
        WHERE  ib.master_id = @p_master_id
        AND    ib.plan_id   = @p_engine_plan_id 
        ;

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 1-2 END';
        SET @v_description = N'1-2. 정상 BOD (scp_mst_bod_item 이외 구간 IS_USE=N 처리) INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        --------------------------------------------------------------------------------------------------------------------



        -----------------------------------------------------------			
        -- 2-1) 항차고려한 IS USE = 'N' 설정
        --      - scm_mst_site_item_priority(from_yyyymmdd ~ to_yyyymmdd)  구간중 항차여부 'N'일때 IS_USE='N'처리
        /*    
            -1)
            scm_mst_bod_eng 테이블의period_shipsch_sun = 'N' 이면 start_dttm >= 일요일 AND end_dttm < 월요일 1개 레코드 데이터 생성
            scm_mst_bod_eng 테이블의period_shipsch_mon = 'N' 이면 start_dttm >= 월요일 AND end_dttm < 화요일 1개 레코드 데이터 생성 
            scm_mst_bod_eng 테이블의period_shipsch_tue = 'N' 이면 start_dttm >= 화요일 AND end_dttm < 수요일 1개 레코드 데이터 생성
            scm_mst_bod_eng 테이블의period_shipsch_wed = 'N' 이면 start_dttm >= 수요일 AND end_dttm < 목요일 1개 레코드 데이터 생성
            scm_mst_bod_eng 테이블의period_shipsch_thu = 'N' 이면 start_dttm >= 목요일 AND end_dttm < 금요일 1개 레코드 데이터 생성
            scm_mst_bod_eng 테이블의period_shipsch_fri = 'N' 이면 start_dttm >= 금요일 AND end_dttm < 토요일 1개 레코드 데이터 생성
            scm_mst_bod_eng 테이블의period_shipsch_sat = 'N' 이면 start_dttm >= 토요일 AND end_dttm < 일요일 1개 레코드 데이터 생성

            단, 항차여부'N'인 요일이 연결되어있을경우 데이터 건수를 줄이기 위해서 하나의 레코드 값으로 처리함
            ex) 화요일, 수요일, 목요일의 항차여부가 'N'이면 =>  sttart_dttm >= '화요일 일자', end_dttm < '금요일 일자'  로 1개의 데이터생성함
             
            -2) start_dttm, end_dttm 일자를 항차 LeadTime(scp_mst_bod_v.ship_lt_total) 값만큼 차감한다       
                
        */ 
        -----------------------------------------------------------

        IF OBJECT_ID('tempdb..#TH_ENG_ITEM_BOD_CAL_SHIPPERIOD') IS NOT NULL
        BEGIN 
            DROP TABLE  #TH_ENG_ITEM_BOD_CAL_SHIPPERIOD ;         
        END
        ;

        -- 항차여부가 'N'인 요일의 데이터를 일자별로 생성
        WITH with_scm_mst_bod_eng 
        AS (   SELECT bod_id
                    , period_shipsch_mon
                    , period_shipsch_tue
                    , period_shipsch_wed
                    , period_shipsch_thu
                    , period_shipsch_fri
                    , period_shipsch_sat
                    , period_shipsch_sun 
                    , CONVERT(INT, attribute9) AS ship_lt_total --20180402 추가  항차LeadTime 
                FROM   scm_mst_bod_eng WITH (NOLOCK)
                WHERE  modeling_id = @p_modeling_id 
                AND    plan_id     = @p_plan_id     
                AND    plan_type   = @p_plan_type   
                AND    plan_seq    = @p_seq          
                AND    (period_shipsch_mon = 'N'
                        OR 
                        period_shipsch_tue = 'N'
                        OR 
                        period_shipsch_wed = 'N'
                        OR 
                        period_shipsch_thu = 'N'
                        OR 
                        period_shipsch_fri = 'N'
                        OR 
                        period_shipsch_sat = 'N'
                        OR 
                        period_shipsch_sun = 'N'
                        )            
                --20181019 항차적용 가능한 incoterms 조건 추가
                AND    incoterms IN ( SELECT segment1 AS incoterms 
                                      FROM   scm_adm_lookup_master_detail WITH (NOLOCK)
                                      WHERE  lookup_type = 'INCOTERMS'
                                      AND    valid_yn = 'Y'
                                      AND    segment5 = 'Y'  -- 항차적용여부
                                    ) 
        ) 
        , with_select_query2 AS(
            
            SELECT ib.master_id              AS master_id
                 , ib.plan_id                AS plan_id
                 , ib.item_id                AS item_id
                 , ib.bod_id                 AS bod_id
                 , ib.alt_priority           AS alt_priority
                 , 1	                     AS alt_rate
             
                 , NULL                      AS transfer_lot_size
                 ,'N'                        AS is_prev_lot_size
                 ,'Y'                        AS is_pull
                 , ib.pre_buffer_time        AS pre_buffer_time 
                 , ib.post_buffer_time       AS post_buffer_time   -- 20200323 [전지 공급 대응력 향상을 위한 RTF 적확도 개선] : th_eng_item_bod_sn 값 적용
                 --, NULL                      AS post_buffer_time
                 , 'DAY'                     AS buffer_time_uom
             
                 , 'N'                       AS is_use

                 , ib.route_selector_id      AS route_selector_id
                 , ib.safety_stock_term      AS safety_stock_term      
                 , ib.safety_stock_term_uom  AS safety_stock_term_uom
                 , 0                         AS safety_stock_qty
                 , NULL                      AS descr
                 , 0                         AS early_producing_term
                 , 'DAY'                     AS early_producing_term_uom
                 , ib.yield                  AS yield 
             
                 , DATEADD(d, b.ship_lt_total * -1 , c.yyyymmdd) AS yyyymmdd -- -20180402 수정 항차 LeadTime  적용 (변경전 : ,c.yyyymmdd)
                 , DATEDIFF(d, LAG(c.yyyymmdd, 1, NULL) OVER (PARTITION BY ib.bod_id ORDER BY c.yyyymmdd), c.yyyymmdd ) AS pre_yyyymmdd_diff

            FROM   th_eng_item_bod_sn       ib  WITH(NOLOCK)
                   INNER JOIN th_eng_bod_sn bod WITH(NOLOCK)
                   ON  ib.master_id = bod.master_id
                   AND ib.plan_id   = bod.plan_id
                   AND ib.bod_id    = bod.bod_id
                   INNER JOIN with_scm_mst_bod_eng b --20181227 수정(속도개선:with 문으로 대체)
                   ON REPLACE(ib.bod_id, ib.item_id + '::', '') = b.bod_id
                   LEFT JOIN ( SELECT a.division_id, a.plant_site_id AS scm_site_id, a.item_id   -- 20180323 scm_site_id 컬럼명 변경으로 수정함(scm_site_id 없어지고 plant_site_id, sales_site_id 컬럼 생김)
                                    , min(a.from_yyyymmdd) min_site_item_priority_from_yyyymmdd
                                    , max(a.to_yyyymmdd) max_site_item_priority_to_yyyymmdd
                               FROM   scm_mst_site_item_priority a WITH (NOLOCK)
                               WHERE  a.division_id = @p_division_id  
                               AND    a.valid_yn = 'Y'                               
                               GROUP BY a.division_id, a.plant_site_id, a.item_id) sip -- 20180323 scm_site_id 컬럼명 변경으로 수정함(scm_site_id 없어지고 plant_site_id, sales_site_id 컬럼 생김)
                   ON  ib.item_id   = sip.item_id 
                       --20180409 수정 (셀  ~***, ~001, ~002, ~003 로 변경) --20180308 수정 (전극 from_site, to_site ~002, ~003 삭제, 셀  from_site, to_site ~002, ~003, ~004 => ~001, ~002로 변경) (변경전 : --20180306 수정 (전극 from_site, to_site ~002, ~003 삭제, 셀  from_site, to_site ~002, ~003, ~004 => ~001로 변경))
                   AND (RTRIM(bod.from_site_id) = RTRIM(sip.scm_site_id)  + '~***'
                        OR 
                        RTRIM(bod.from_site_id) = RTRIM(sip.scm_site_id)  + '~001' 
                        OR 
                        RTRIM(bod.from_site_id) = RTRIM(sip.scm_site_id)  + '~002' --20180308 추가 
                        OR 
                        RTRIM(bod.from_site_id) = RTRIM(sip.scm_site_id)  + '~003' --20180409 추가
                       )             
                   LEFT JOIN ( SELECT  @p_master_id         AS master_id
                                     , @p_engine_plan_id    AS plan_id 
                                     , MIN(start_dttm)      AS min_bucket_info_start_dttm
                                     , MAX(end_dttm)        AS max_bucket_info_end_dttm
                                FROM   th_eng_bucket_info_sn   WITH(NOLOCK)
                                WHERE  master_id = @p_master_id  
                                AND    plan_id   = @p_engine_plan_id  
                                AND    descr     = 'PLAN'  -- 2018.07.05 추가 (  plan시작일~ plan종료일 : descr = 'PLAN' , plan종료일이후~ 13주 : descr = 'ADD')
                              ) bi
                   ON   ib.master_id = bi.master_id
                   AND  ib.plan_id   = bi.plan_id
                ,  ( SELECT yyyymmdd, dayofweek 
                     FROM   dbo.scm_mst_bucket WITH (NOLOCK) 
                     WHERE  yyyymmdd >= @p_plan_name
                     AND    yyyymmdd <=  CONVERT(NVARCHAR(8), @d_pet_date, 112) 
                    ) c          
            WHERE  ib.master_id = @p_master_id   
            AND    ib.plan_id   = @p_engine_plan_id  
		           -- Plant 내부용 임시 BOD가 아닌 정상 BOD
            AND    SUBSTRING(bod.from_site_id, 1, CHARINDEX('~', bod.from_site_id)-1)
                   <> SUBSTRING(bod.to_site_id, 1, CHARINDEX('~', bod.to_site_id)-1)            
            AND    c.yyyymmdd >= (CASE WHEN sip.min_site_item_priority_from_yyyymmdd >= bi.min_bucket_info_start_dttm THEN sip.min_site_item_priority_from_yyyymmdd
                                       ELSE bi.min_bucket_info_start_dttm END )
            AND    c.yyyymmdd <= (CASE WHEN sip.max_site_item_priority_to_yyyymmdd >= DATEADD(d, -1, bi.max_bucket_info_end_dttm ) THEN DATEADD(d, -1, bi.max_bucket_info_end_dttm )
                                       ELSE sip.max_site_item_priority_to_yyyymmdd END )            
                --20181227 속도걔선위해서 EXISTS로 변경
           AND  EXISTS  (   SELECT 1
                            FROM  with_scm_mst_bod_eng  x
                            WHERE  x.bod_id = REPLACE(ib.bod_id, ib.item_id + '::', '')
                            AND    (
                                     c.dayofweek = (CASE WHEN x.period_shipsch_mon = 'N' THEN 'MON' END)
                                     OR
                                     c.dayofweek = (CASE WHEN x.period_shipsch_tue = 'N' THEN 'TUE' END)
                                     OR
                                     c.dayofweek = (CASE WHEN x.period_shipsch_wed = 'N' THEN 'WED' END)
                                     OR
                                     c.dayofweek = (CASE WHEN x.period_shipsch_thu = 'N' THEN 'THU' END)
                                     OR
                                     c.dayofweek = (CASE WHEN x.period_shipsch_fri = 'N' THEN 'FRI' END)
                                     OR
                                     c.dayofweek = (CASE WHEN x.period_shipsch_sat = 'N' THEN 'SAT' END)
                                     OR
                                     c.dayofweek = (CASE WHEN x.period_shipsch_sun = 'N' THEN 'SUN' END)
                                   ) 
                        ) --EXISTS 종료          
        ) -- with_select_query2 종료
        SELECT DISTINCT
               master_id                 AS master_id
             , plan_id                   AS plan_id
             , item_id                   AS item_id
             , bod_id                    AS bod_id
             , alt_priority              AS alt_priority
             , 1	                     AS alt_rate
             
             , CONVERT(DATETIME, fast_yyyymmdd) AS start_dttm
             , DATEADD(d, 1, MAX(yyyymmdd) OVER (PARTITION BY bod_Id, fast_yyyymmdd))  AS end_dttm
              
             , NULL                      AS transfer_lot_size
             ,'N'                        AS is_prev_lot_size
             ,'Y'                        AS is_pull
             , pre_buffer_time           AS pre_buffer_time 
             , post_buffer_time          AS post_buffer_time
             , 'DAY'                     AS buffer_time_uom
             
             , 'N'                       AS is_use

             , route_selector_id         AS route_selector_id
             , safety_stock_term         AS safety_stock_term      
             , safety_stock_term_uom     AS safety_stock_term_uom
             , 0                         AS safety_stock_qty
             , 'SHIP PERIOD'             AS descr
             , 0                         AS early_producing_term
             , 'DAY'                     AS early_producing_term_uom
             , yield                     AS yield 
             --, 2                      AS gubun --20180515 추가
        INTO  #TH_ENG_ITEM_BOD_CAL_SHIPPERIOD
        FROM
            (  
               -- 항차여부'N'인 요일이 연결되어있을경우 하나의 레코드 값으로 나타내기 위해서 fast_yyyymmdd 값을 구함
               SELECT * 
                    , CASE WHEN ISNULL(pre_yyyymmdd_diff, 99) > 1  THEN yyyymmdd -- 조회된 데이터의 가장 첫번째값의 pre_yyyymmdd_diff는  '99'로 셋팅
                           WHEN pre_yyyymmdd_diff = 1 AND ISNULL(LAG(pre_yyyymmdd_diff, 1) OVER (ORDER BY bod_id, yyyymmdd), 99) >  1 THEN LAG(yyyymmdd, 1) OVER (ORDER BY bod_id, yyyymmdd)
                           WHEN pre_yyyymmdd_diff = 1 AND ISNULL(LAG(pre_yyyymmdd_diff, 2) OVER (ORDER BY bod_id, yyyymmdd), 99) >  1 THEN LAG(yyyymmdd, 2) OVER (ORDER BY bod_id, yyyymmdd)
                           WHEN pre_yyyymmdd_diff = 1 AND ISNULL(LAG(pre_yyyymmdd_diff, 3) OVER (ORDER BY bod_id, yyyymmdd), 99) >  1 THEN LAG(yyyymmdd, 3) OVER (ORDER BY bod_id, yyyymmdd)
                           WHEN pre_yyyymmdd_diff = 1 AND ISNULL(LAG(pre_yyyymmdd_diff, 4) OVER (ORDER BY bod_id, yyyymmdd), 99) >  1 THEN LAG(yyyymmdd, 4) OVER (ORDER BY bod_id, yyyymmdd)
                           WHEN pre_yyyymmdd_diff = 1 AND ISNULL(LAG(pre_yyyymmdd_diff, 5) OVER (ORDER BY bod_id, yyyymmdd), 99) >  1 THEN LAG(yyyymmdd, 5) OVER (ORDER BY bod_id, yyyymmdd)
                           WHEN pre_yyyymmdd_diff = 1 AND ISNULL(LAG(pre_yyyymmdd_diff, 6) OVER (ORDER BY bod_id, yyyymmdd), 99) >  1 THEN LAG(yyyymmdd, 6) OVER (ORDER BY bod_id, yyyymmdd)
                           ELSE FIRST_VALUE(yyyymmdd) OVER (PARTITION BY bod_id ORDER BY yyyymmdd)  --모든 요일이 'N'일경우  --20180403 추가
                      END     AS fast_yyyymmdd -- 항차여부가 'N'인 요일이 연결되어있을경우 처음시작일( 화요일,수요일,목요일이 모두 항차여부가 'N'일때  fast_yyyymmdd은 화요일 일자임)                
                FROM with_select_query2
            ) a
        ;

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 2-1 END';
        SET @v_description = N'2-1. 항차고려한 IS USE = N' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		--------------------------------------------------------------------------------------------------------------------

        -----------------------------------------------------------			
        -- 2-2) 항차의 시작일과 종료일이 6일차이  데이터처리
               -- 항차 와 휴무일(ssp_mst_ship_calendar)의 IS_USE = 'N' 처리후 모든일자가 IS_USE = 'N' 될수 있기때문에 처리필요
        /*
                항차고려한 IS USE = 'N' 설정에서 start_dttm, end_dttm의 차이가 6일이면 
                start_dttm ~ end_dttm 사이일자 중에 MAX(ssp_mst_ship_calendar.workday = 'Y') 일자를 end_dttm으로 셋팅
                (단, MAX(ssp_mst_ship_calendar.workday = 'Y') 일자가 존재하지 않으면 기존  end_dttm으로 셋팅함)
         */
        -----------------------------------------------------------

        INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_ITEM_BOD_CAL */ #TH_ENG_ITEM_BOD_CAL
        (   master_id
          , plan_id
          , item_id
          , bod_id
          , alt_priority
          , alt_rate
          , start_dttm
          , end_dttm
          , transfer_lot_size
          , is_prev_lot_size
          , is_pull
          , pre_buffer_time
          , post_buffer_time
          , buffer_time_uom
          , is_use
          , route_selector_id
          , safety_stock_term
          , safety_stock_term_uom
          , safety_stock_qty
          , descr
          , early_producing_term
          , early_producing_term_uom
          , yield         
        )
        SELECT  DISTINCT
               x.master_id             AS master_id
             , x.plan_id               AS plan_id
             , x.item_id               AS item_id
             , x.bod_id                AS bod_id
             , x.alt_priority          AS alt_priority
             , 1	                   AS alt_rate             
             
             , x.start_dttm            AS start_dttm
             
               -- start_dttm, end_dttm의 차이가 6일이면 start_dttm ~ end_dttm 사이의 가장큰 영업일
             , CASE WHEN x.diff_start_end = 6  THEN ISNULL(x.max_start_end_workday, x.end_dttm)
                    ELSE x.end_dttm
               END                      AS end_dttm              

             , NULL                      AS transfer_lot_size
             ,'N'                        AS is_prev_lot_size
             ,'Y'                        AS is_pull
             , x.pre_buffer_time         AS pre_buffer_time 
             , x.post_buffer_time        AS post_buffer_time 
             --, NULL                      AS post_buffer_time
             , 'DAY'                     AS buffer_time_uom
             
             , 'N'                       AS is_use

             , x.route_selector_id       AS route_selector_id
             , x.safety_stock_term       AS safety_stock_term      
             , x.safety_stock_term_uom   AS safety_stock_term_uom
             , 0                         AS safety_stock_qty
             , 'SHIP PERIOD'             AS descr
             , 0                         AS early_producing_term
             , 'DAY'                     AS early_producing_term_uom
             , x.yield                   AS yield 			  
     
      FROM   ( SELECT  DISTINCT  
                       a.master_id, a.plan_id, a.bod_id, a.item_id, a.start_dttm, a.end_dttm   
                     , a.alt_priority, a.pre_buffer_time, a.post_buffer_time, a.route_selector_id, a.safety_stock_term, a.safety_stock_term_uom, a.yield 
                     
                     , DATEDIFF(d, a.start_dttm, a.end_dttm) AS diff_start_end
                     , MAX(msc.yyyymmdd) OVER (PARTITION BY a.master_id, a.plan_id, a.bod_id, a.item_id, a.start_dttm, a.end_dttm) AS max_start_end_workday -- max(start_dttm ~ end_dttm 사이의 가장큰 영업일)

                     --, a.next_start_dttm 
                     --, DATEDIFF(d, a.end_dttm, a.next_start_dttm) AS diff_end_nextstart
                    
               FROM 
                      ( SELECT  master_id, plan_id, bod_id, item_id, start_dttm, end_dttm   
                              , alt_priority, pre_buffer_time, post_buffer_time, route_selector_id, safety_stock_term, safety_stock_term_uom, yield 
                              --, LEAD(start_dttm, 1, NULL) OVER (PARTITION BY master_id, plan_id, bod_id, item_id ORDER BY start_dttm)  AS next_start_dttm 
                        FROM    #TH_ENG_ITEM_BOD_CAL_SHIPPERIOD
                      ) a

                      INNER JOIN th_eng_bod_sn bod WITH(NOLOCK) 
                      ON  a.master_id = bod.master_id
                      AND a.plan_id   = bod.plan_id
                      AND a.bod_id    = bod.bod_id
                                            
                      INNER JOIN scm_mst_site_eng mse WITH (NOLOCK)
                      ON  bod.from_site_id = mse.eng_scm_site_id
                      AND mse.division_id  = @p_division_id
                      AND mse.plan_id      = @p_plan_id
                      AND mse.plan_type    = @p_plan_type 
                      AND mse.plan_seq     = @p_seq
                      
                         /* 2023.01.30 수정: from site가 외주일 경우 plant_id별 출하여부를 검색하고 그 외(외주가 아니거나 외주인데 미등록인 경우)는 기존처럼 comapny_id만 보고 영업일 검색. */
                      LEFT JOIN  (      --~ 2023.01.30: 기존로직 COMPANY_ID별 WORKDAY 반영 
                                    SELECT company_id, division_id, CONVERT(DATETIME, yyyymmdd) AS yyyymmdd
                                        ,  '-' AS PLANT_ID      --~ 2023.01.30: OSP_YN=N 이면 plant_id 안보게 하려고 '-' 처리 함.
                                        ,  'N' AS OSP_YN              
                                    FROM   ssp_mst_ship_calendar WITH (NOLOCK) 
                                    WHERE  division_id =  @p_division_id
                                    AND    yyyymmdd    >= @p_plan_name
                                    AND    yyyymmdd    <= CONVERT(NVARCHAR(8), @d_pet_date, 112)
                                    AND    workday_yn  = 'Y' --영업일일때
                                    
                                    UNION ALL    
                                        --~ 2023.01.30: 외주 PLANT인 경우 PLANT_ID별 출하일자 반영
                                    SELECT  se.company_id, p.division_id, CONVERT(DATETIME, p.yyyymmdd) AS yyyymmdd 
                                        ,   se.scm_site_id  AS  plant_id  
                                        ,   se.osp_yn       AS  osp_yn 
                                    FROM    scp_mst_shipment_working_day_osp  P WITH(NOLOCK) 
                                    INNER JOIN  scm_mst_site_eng             se WITH(NOLOCK) 
                                            ON  ( 1=1 
                                            AND   se.division_id  =  @p_division_id
                                            AND   se.plan_id      =  @p_plan_id
                                            AND   se.plan_type    =  @p_plan_type
                                            AND   se.plan_seq     =  @p_seq
                                            AND   se.osp_yn       =  'Y'   ---외주 plant만 
                                            AND   se.site_type    =  'PLANT'   --~ 2023.02.27 plant type만 확실하게 필터링하려고 조건 추가함.
                                            AND   se.division_id  =  p.division_id
                                            AND   se.scm_site_id  =  p.plant_site_id                                            
                                                ) 
                                    WHERE  1 = 1
                                    AND    p.yyyymmdd     >=  @p_plan_name
                                    AND    p.yyyymmdd     <=  CONVERT(NVARCHAR(8), @d_pet_date , 112)
                                    AND    p.measure       =  'SHIPMENT WORKING DAY' 
                                    AND    p.shipment_yn   =  'Y' --영업일일때
                                    ) msc    
                      ON  msc.company_id   = mse.company_id 
                      AND msc.division_id  = mse.division_id
                      AND msc.yyyymmdd    >= a.start_dttm 
                      AND msc.yyyymmdd    <= a.end_dttm                               
                      AND msc.osp_yn       = ISNULL(mse.osp_yn,'N') 
                      AND ISNULL(msc.plant_id , '-')  = CASE WHEN ISNULL(mse.osp_yn,'N') = 'Y' AND  mse.site_type = 'PLANT' THEN mse.scm_site_id  ELSE '-' END   --~2023.02.27 외주 PLANT TYPE(osp_yn=Y)는 scp_mst_shipment_working_day_osp.yyyymmdd 확인.          
            
            ) x

/** 2023.01.30 수정전 
                      LEFT JOIN ( SELECT company_id, division_id, CONVERT(DATETIME, yyyymmdd) AS yyyymmdd
                                  FROM   ssp_mst_ship_calendar WITH (NOLOCK) 
                                  WHERE  division_id =  @p_division_id 
                                  AND    yyyymmdd    >= @p_plan_name
                                  AND    yyyymmdd    <= CONVERT(NVARCHAR(8), @d_pet_date, 112)
                                  AND    workday_yn  = 'Y' --영업일일때
                                ) msc
                       ON  msc.company_id  = mse.company_id 
                       AND msc.division_id = mse.division_id
                       AND msc.yyyymmdd    >= a.start_dttm 
                       AND msc.yyyymmdd    <= a.end_dttm  --20180531 수정(변경전 : AND msc.yyyymmdd    < a.end_dttm)
                       --AND msc.yyyymmdd    < ISNULL(a.next_start_dttm, a.end_dttm) -- max_start_nextstart_workday 사용시 주석해제(AND msc2.yyyymmdd    < a.end_dttm 부분 주석처리해야함)                
            ) x
**/

        ;

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 2-2 END';
        SET @v_description = N'2-2. 항차의 시작일과 종료일이 6일차이 데이터처리' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        --------------------------------------------------------------------------------------------------------------------


        -----------------------------------------------------------
        -- 3. Plant 내부용 임시 BOD가 아닌 정상 BOD 추가처리
              -- SSP_MST_SHIP_CALENDAR.workday_yn = 'N' 건 is_use = 'N' 처리
                /*~~  2023.01.30 수정사항:  영업일(yyyymmdd) 가져올때 
                (1) 출하site 출하일 등록한 외주 plant 일때 :  SCP_MST_SHIPMENT_WORKING_DAY_OSP.shipment_yn = 'N' 인 일자에 is_use = 'N' 처리 (로직추가)
                (2) 그 외 (기존로직) : SSP_MST_SHIP_CALENDAR 참조. company_id기준 처리  (기존유지)
                ~~*/  
              -- 동일국가내 공장으로 나가는 BOD는 is_use = 'N'처리 대상 아님

        -----------------------------------------------------------
        -------------------------------------------------------------------------------------------------
        -- 3.1 출하site 출하일 등록한 외주 plant 일때 :  SCP_MST_SHIPMENT_WORKING_DAY_OSP 참조  (2023.01.30 추가로직)
        -------------------------------------------------------------------------------------------------

        INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_ITEM_BOD_CAL */ #TH_ENG_ITEM_BOD_CAL
        (   master_id
          , plan_id
          , item_id
          , bod_id
          , alt_priority
          , alt_rate
          , start_dttm
          , end_dttm
          , transfer_lot_size
          , is_prev_lot_size
          , is_pull
          , pre_buffer_time
          , post_buffer_time
          , buffer_time_uom
          , is_use
          , route_selector_id
          , safety_stock_term
          , safety_stock_term_uom
          , safety_stock_qty
          , descr
          , early_producing_term
          , early_producing_term_uom
          , yield
        )
        SELECT ib.master_id              AS master_id
             , ib.plan_id                AS plan_id
             , ib.item_id                AS item_id
             , ib.bod_id                 AS bod_id
             , ib.alt_priority           AS alt_priority
             , 1	                     AS alt_rate

             , CONVERT(DATETIME, msc.yyyymmdd)  AS start_dttm
             , DATEADD(d, 1, CONVERT(DATETIME, msc.yyyymmdd))  AS end_dttm

             , NULL                      AS transfer_lot_size
             ,'N'                        AS is_prev_lot_size
             ,'Y'                        AS is_pull
             , ib.pre_buffer_time        AS pre_buffer_time 
             , ib.post_buffer_time       AS post_buffer_time   -- 20200323 [전지 공급 대응력 향상을 위한 RTF 적확도 개선] : th_eng_item_bod_sn 값 적용
             , 'DAY'                     AS buffer_time_uom
             , 'N'                       AS is_use
             , ib.route_selector_id      AS route_selector_id
             , ib.safety_stock_term      AS safety_stock_term      
             , ib.safety_stock_term_uom  AS safety_stock_term_uom
             , 0                         AS safety_stock_qty
             , 'SHIP CALENDAR(osp)'      AS descr               --~2023.01.30 osp plant의 shipment_yn = N 반영표시
             , 0                         AS early_producing_term
             , 'DAY'                     AS early_producing_term_uom
             , ib.yield                  AS yield 
        FROM   th_eng_item_bod_sn ib  WITH(NOLOCK)                 
               
               INNER JOIN th_eng_bod_sn bod WITH(NOLOCK)
               ON  ib.master_id = bod.master_id
               AND ib.plan_id   = bod.plan_id
               AND ib.bod_id    = bod.bod_id

               AND ib.master_id = @p_master_id        
               AND ib.plan_id   = @p_engine_plan_id  
		        -- Plant 내부용 임시 BOD가 아닌 정상 BOD
               AND SUBSTRING(bod.from_site_id, 1, CHARINDEX('~', bod.from_site_id)-1)
                   <> SUBSTRING(bod.to_site_id, 1, CHARINDEX('~', bod.to_site_id)-1)
               
               -- 20180426 추가 to site 가 동일국가공장이 아니거나, SALES site, 외부packer 일때만 is_use = 'N'처리대상이다.
               INNER JOIN scm_mst_bod_eng be WITH (NOLOCK)
               ON  REPLACE(ib.bod_id, ib.item_id + '::', '') = be.bod_id 
               AND be.division_id  = @p_division_id
               AND be.plan_id      = @p_plan_id
               AND be.plan_type    = @p_plan_type 
               AND be.plan_seq     = @p_seq
               ANd be.attribute1   = 'OUTER_SITE' -- 1) from site와 to site의 공장이 동일국가가 아니거나  2) to site가 SALES site 일때, 3) to site가 외주packer일때(scm_mst_site_eng.osp_yn = 'Y') ==> 'OUTER_SITE' 이다

               INNER JOIN scm_mst_site_eng mse WITH (NOLOCK)
               ON  bod.from_site_id = mse.eng_scm_site_id
               AND mse.division_id  = @p_division_id
               AND mse.plan_id      = @p_plan_id
               AND mse.plan_type    = @p_plan_type 
               AND mse.plan_seq     = @p_seq
               AND mse.osp_yn       = 'Y'     --~2023.02.27 외주인 경우.
               AND mse.site_type    = 'PLANT' --~2023.02.27 from site가 plant 인 경우.

               LEFT JOIN ( SELECT a.division_id, a.plant_site_id AS scm_site_id, a.item_id   -- 20180323 scm_site_id 컬럼명 변경으로 수정함(scm_site_id 없어지고 plant_site_id, sales_site_id 컬럼 생김)
                                , min(a.from_yyyymmdd) min_site_item_priority_from_yyyymmdd
                                , max(a.to_yyyymmdd) max_site_item_priority_to_yyyymmdd
                           FROM   scm_mst_site_item_priority a WITH (NOLOCK)
                           WHERE  a.division_id = @p_division_id  
                           AND    a.valid_yn = 'Y'                               
                           GROUP BY a.division_id, a.plant_site_id, a.item_id
                         ) sip 
               ON  ib.item_id   = sip.item_id 
               AND (RTRIM(bod.from_site_id) = RTRIM(sip.scm_site_id)  + '~***'
                    OR 
                    RTRIM(bod.from_site_id) = RTRIM(sip.scm_site_id)  + '~001' 
                    OR 
                    RTRIM(bod.from_site_id) = RTRIM(sip.scm_site_id)  + '~002' --20180308 추가 
                    OR 
                    RTRIM(bod.from_site_id) = RTRIM(sip.scm_site_id)  + '~003' --20180409 추가
                   )             

               LEFT JOIN ( SELECT  @p_master_id         AS master_id
                                 , @p_engine_plan_id    AS plan_id 
                                 , MIN(start_dttm)      AS min_bucket_info_start_dttm
                                 , MAX(end_dttm)        AS max_bucket_info_end_dttm
                           FROM   th_eng_bucket_info_sn   WITH(NOLOCK)
                           WHERE  master_id = @p_master_id     
                           AND    plan_id   = @p_engine_plan_id  
                           AND    descr     = 'PLAN'  -- 2018.07.05 추가 (  plan시작일~ plan종료일 : descr = 'PLAN' , plan종료일이후~ 13주 : descr = 'ADD')
                         ) bi
               ON   ib.master_id = bi.master_id
               AND  ib.plan_id   = bi.plan_id

               INNER JOIN (   /*~ 2023.01.30 외주 Plant의 출하여부 참조테이블  ~*/
                            SELECT  p.division_id , plant_site_id  , CONVERT(DATETIME, yyyymmdd) AS yyyymmdd                                 
                            FROM    scp_mst_shipment_working_day_osp  p WITH(NOLOCK)  
                            WHERE   p.division_id  =  @p_division_id
                            AND     p.yyyymmdd    >=  @p_plan_name   
                            AND     p.yyyymmdd    <=  CONVERT(NVARCHAR(8), @d_pet_date, 112)
                            AND     p.shipment_yn  =  'N'
                            AND     p.measure      =  'SHIPMENT WORKING DAY'
                          ) msc
               ON  1=1
               AND msc.division_id   = mse.division_id
               AND msc.plant_site_id = mse.scm_site_id 
               AND msc.yyyymmdd >= (CASE WHEN sip.min_site_item_priority_from_yyyymmdd >= bi.min_bucket_info_start_dttm THEN sip.min_site_item_priority_from_yyyymmdd
                                       ELSE bi.min_bucket_info_start_dttm END )
               AND msc.yyyymmdd <= (CASE WHEN sip.max_site_item_priority_to_yyyymmdd >= DATEADD(d, -1, bi.max_bucket_info_end_dttm ) THEN DATEADD(d, -1, bi.max_bucket_info_end_dttm )
                                       ELSE sip.max_site_item_priority_to_yyyymmdd END )
        WHERE NOT EXISTS ( SELECT 1 
                           FROM   #th_eng_item_bod_cal WITH (NOLOCK) --20180515 수정
                           WHERE  master_id = ib.master_id
                           AND    plan_id   = ib.plan_id 
                           AND    bod_id    = ib.bod_id
                           AND    item_id   = ib.item_id
                           AND    is_use    = 'N'
                           AND    start_dttm <= msc.yyyymmdd
                           AND    end_dttm   >  msc.yyyymmdd                         
                         )
        ;

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 3-1 END';
        SET @v_description = N'3-1. SCP_MST_SHIPMENT_WORKING_DAY_OSP.shipment_yn = N 건  IS USE = N' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        --------------------------------------------------------------------------------------------------------------------


        -------------------------------------------------------------------------------------------------------------
        -- 3.2  그 외의 경우 기존 로직을 따름 : SSP_MST_SHIP_CALENDAR 참조 (2023.01.30)
        --      from site가 외주가 아닌 경우로 조건 변경 (2023.02.27)
        -------------------------------------------------------------------------------------------------------------

        INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_ITEM_BOD_CAL */ #TH_ENG_ITEM_BOD_CAL
        (   master_id
          , plan_id
          , item_id
          , bod_id
          , alt_priority
          , alt_rate
          , start_dttm
          , end_dttm
          , transfer_lot_size
          , is_prev_lot_size
          , is_pull
          , pre_buffer_time
          , post_buffer_time
          , buffer_time_uom
          , is_use
          , route_selector_id
          , safety_stock_term
          , safety_stock_term_uom
          , safety_stock_qty
          , descr
          , early_producing_term
          , early_producing_term_uom
          , yield
          --, gubun  -- 20180515 추가
        )
        SELECT ib.master_id              AS master_id
             , ib.plan_id                AS plan_id
             , ib.item_id                AS item_id
             , ib.bod_id                 AS bod_id
             , ib.alt_priority           AS alt_priority
             , 1	                     AS alt_rate

             , CONVERT(DATETIME, msc.yyyymmdd)  AS start_dttm
             , DATEADD(d, 1, CONVERT(DATETIME, msc.yyyymmdd))  AS end_dttm

             , NULL                      AS transfer_lot_size
             ,'N'                        AS is_prev_lot_size
             ,'Y'                        AS is_pull
             , ib.pre_buffer_time        AS pre_buffer_time 
             , ib.post_buffer_time       AS post_buffer_time   -- 20200323 [전지 공급 대응력 향상을 위한 RTF 적확도 개선] : th_eng_item_bod_sn 값 적용
             --, NULL                      AS post_buffer_time
             , 'DAY'                     AS buffer_time_uom
             , 'N'                       AS is_use
             , ib.route_selector_id      AS route_selector_id
             , ib.safety_stock_term      AS safety_stock_term      
             , ib.safety_stock_term_uom  AS safety_stock_term_uom
             , 0                         AS safety_stock_qty
             , 'SHIP CALENDAR'           AS descr                  
             , 0                         AS early_producing_term
             , 'DAY'                     AS early_producing_term_uom
             , ib.yield                  AS yield 
             --, 3                         AS gubun
        FROM   th_eng_item_bod_sn ib  WITH(NOLOCK)                 
               
               INNER JOIN th_eng_bod_sn bod WITH(NOLOCK)
               ON  ib.master_id = bod.master_id
               AND ib.plan_id   = bod.plan_id
               AND ib.bod_id    = bod.bod_id

               AND ib.master_id = @p_master_id        
               AND ib.plan_id   = @p_engine_plan_id  
		           -- Plant 내부용 임시 BOD가 아닌 정상 BOD
               AND SUBSTRING(bod.from_site_id, 1, CHARINDEX('~', bod.from_site_id)-1)
                   <> SUBSTRING(bod.to_site_id, 1, CHARINDEX('~', bod.to_site_id)-1)
               
                   -- 20180426 추가 to site 가 동일국가공장이 아니거나, SALES site, 외부packer 일때만 is_use = 'N'처리대상이다.
               INNER JOIN scm_mst_bod_eng be WITH (NOLOCK)
               ON  REPLACE(ib.bod_id, ib.item_id + '::', '') = be.bod_id 
               AND be.division_id  = @p_division_id
               AND be.plan_id      = @p_plan_id
               AND be.plan_type    = @p_plan_type 
               AND be.plan_seq     = @p_seq
               ANd be.attribute1   = 'OUTER_SITE' -- 1) from site와 to site의 공장이 동일국가가 아니거나  2) to site가 SALES site 일때, 3) to site가 외주packer일때(scm_mst_site_eng.osp_yn = 'Y') ==> 'OUTER_SITE' 이다

               INNER JOIN scm_mst_site_eng mse WITH (NOLOCK)
               ON  bod.from_site_id = mse.eng_scm_site_id
               AND mse.division_id  = @p_division_id
               AND mse.plan_id      = @p_plan_id
               AND mse.plan_type    = @p_plan_type 
               AND mse.plan_seq     = @p_seq  
               AND ISNULL(mse.osp_yn ,'N')  = 'N'   --~ 2023.02.27 외주가 아닌 경우만 대상으로 함.  

               LEFT JOIN ( SELECT a.division_id, a.plant_site_id AS scm_site_id, a.item_id   -- 20180323 scm_site_id 컬럼명 변경으로 수정함(scm_site_id 없어지고 plant_site_id, sales_site_id 컬럼 생김)
                                , min(a.from_yyyymmdd) min_site_item_priority_from_yyyymmdd
                                , max(a.to_yyyymmdd) max_site_item_priority_to_yyyymmdd
                           FROM   scm_mst_site_item_priority a WITH (NOLOCK)
                           WHERE  a.division_id = @p_division_id  
                           AND    a.valid_yn = 'Y'                               
                           GROUP BY a.division_id, a.plant_site_id, a.item_id
                         ) sip 
               ON  ib.item_id   = sip.item_id 
               AND (RTRIM(bod.from_site_id) = RTRIM(sip.scm_site_id)  + '~***'
                    OR 
                    RTRIM(bod.from_site_id) = RTRIM(sip.scm_site_id)  + '~001' 
                    OR 
                    RTRIM(bod.from_site_id) = RTRIM(sip.scm_site_id)  + '~002' --20180308 추가 
                    OR 
                    RTRIM(bod.from_site_id) = RTRIM(sip.scm_site_id)  + '~003' --20180409 추가
                   )             

               LEFT JOIN ( SELECT  @p_master_id         AS master_id
                                 , @p_engine_plan_id    AS plan_id 
                                 , MIN(start_dttm)      AS min_bucket_info_start_dttm
                                 , MAX(end_dttm)        AS max_bucket_info_end_dttm
                           FROM   th_eng_bucket_info_sn   WITH(NOLOCK)
                           WHERE  master_id = @p_master_id     
                           AND    plan_id   = @p_engine_plan_id  
                           AND    descr     = 'PLAN'  -- 2018.07.05 추가 (  plan시작일~ plan종료일 : descr = 'PLAN' , plan종료일이후~ 13주 : descr = 'ADD')
                         ) bi
               ON   ib.master_id = bi.master_id
               AND  ib.plan_id   = bi.plan_id

               INNER JOIN ( SELECT company_id, division_id, yyyymmdd 
                            FROM   ssp_mst_ship_calendar WITH (NOLOCK) 
                            WHERE  division_id =  @p_division_id  
                            AND    yyyymmdd    >= @p_plan_name    
                            AND    yyyymmdd    <= CONVERT(NVARCHAR(8), @d_pet_date, 112)
                            AND    workday_yn  = 'N'
                          ) msc
               ON  msc.company_id  = mse.company_id 
               AND msc.division_id = mse.division_id
               AND msc.yyyymmdd >= (CASE WHEN sip.min_site_item_priority_from_yyyymmdd >= bi.min_bucket_info_start_dttm THEN sip.min_site_item_priority_from_yyyymmdd
                                       ELSE bi.min_bucket_info_start_dttm END )
               AND msc.yyyymmdd <= (CASE WHEN sip.max_site_item_priority_to_yyyymmdd >= DATEADD(d, -1, bi.max_bucket_info_end_dttm ) THEN DATEADD(d, -1, bi.max_bucket_info_end_dttm )
                                       ELSE sip.max_site_item_priority_to_yyyymmdd END )
        WHERE NOT EXISTS ( SELECT 1 
                           FROM   #th_eng_item_bod_cal WITH (NOLOCK) --20180515 수정
                           WHERE  master_id = ib.master_id
                           AND    plan_id   = ib.plan_id 
                           AND    bod_id    = ib.bod_id
                           AND    item_id   = ib.item_id
                           AND    is_use    = 'N'
                           AND    start_dttm <= msc.yyyymmdd
                           AND    end_dttm   >  msc.yyyymmdd                         
                         )
        ;
		
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 3-2 END';
        SET @v_description = N'3-2. SSP_MST_SHIP_CALENDAR.workday_yn = N 건  IS USE = N' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        --------------------------------------------------------------------------------------------------------------------
                     
        -----------------------------------------------------------
        -- 4-1) bod의 alt_priority 가장 낮은값을 제외한 데이터 임시테이블로 일괄생성
              -- start_dttm : plan 시작일 (@d_plan_name)
              -- end_dttm   : bucket 종료일 (@d_bucket_end_date)  --20180807  (변경전 : plan 종료일 (@d_pet_date) )
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#TH_ENG_ITEM_BOD_CAL_TEMP') IS NOT NULL
        BEGIN 
            DROP TABLE  #TH_ENG_ITEM_BOD_CAL_TEMP;          
        END
         
        /* 기간별 1순위 BOD 이외의 BOD CAL + 1순위 BOD 중 기간중첩 Cal 예외추가, 2021.08.26 ,By KKC */            
		;WITH vw_scm_mst_bod_item_eng AS (
								  SELECT *
									FROM
										(
										SELECT b.bod_id
											, a.item_id
											, b.eng_from_site
											, b.from_site
											, b.to_site
											, b.eng_to_site
											, b.incoterms
											, b.transport_mode
											, a.eff_start_date
											, a.eff_end_date
											, a.attribute1
											, a.attribute2
											, a.attribute3
											, a.attribute4
											, a.attribute5
											, a.attribute6
											, b.attribute10
											, LEAD(a.eff_start_date) OVER(PARTITION BY a.item_id
																						, b.from_site
																						, b.to_site
																						, b.incoterms
																				ORDER BY a.eff_start_date
																						, b.priority) next_start_date
											, LEAD(a.eff_end_date) OVER(PARTITION BY a.item_id
																					, b.from_site
																					, b.to_site
																					, b.incoterms
																			ORDER BY a.eff_start_date
																						, b.priority) next_end_date
											, LEAD(a.attribute6) OVER(PARTITION BY  a.item_id
																					, b.from_site
																					, b.to_site
																					, b.incoterms
																			ORDER BY a.eff_start_date
																					, b.priority) next_priority
										FROM scm_mst_bod_item_eng a WITH(NOLOCK)
											, scm_mst_bod_eng b WITH(NOLOCK)
										WHERE a.division_id = @p_division_id
										AND a.plan_id       = @p_plan_id
										AND a.plan_type     = @p_plan_type
										AND a.plan_seq      = @p_seq
										AND b.division_id   = a.division_id
										AND b.plan_id       = a.plan_id
										AND b.plan_type     = a.plan_type
										AND b.plan_seq      = a.plan_seq
										AND b.bod_id        = a.bod_id
										AND a.attribute5  = '1'
										) a
								/* eff_start_date 정렬시 더 늦는 eff_start_date의 1순위 bod가 구간 중첩시 */
								WHERE a.eff_start_date < a.next_start_date
								  AND a.eff_end_date   > a.next_end_date
								  AND a.attribute6     > a.next_priority 
						       )
			SELECT a.master_id
				 , a.plan_id
				 , a.item_id
				 , a.bod_id
				 , a.alt_priority
				 , a.alt_rate
				 , a.start_dttm
				 , a.end_dttm
				 , a.transfer_lot_size
				 , a.is_prev_lot_size
				 , a.is_pull
				 , a.pre_buffer_time
				 , a.post_buffer_time
				 , a.buffer_time_uom
				 , a.is_use
				 , a.route_selector_id
				 , a.safety_stock_term
				 , a.safety_stock_term_uom
				 , a.safety_stock_qty
				 , a.descr
				 , a.early_producing_term
				 , a.early_producing_term_uom
				 , a.yield
			INTO #th_eng_item_bod_cal_temp
			FROM
				(
				SELECT /* PR_SCP_ENG_IN_PRE_PROC_ITEM_BOD_CAL */ 
						  ib.master_id
						, ib.plan_id
						, ib.item_id
						, ib.bod_id 
						, ib.alt_priority
						, 1                        AS alt_rate     
						, @d_plan_name             AS start_dttm
						, @d_bucket_end_date       AS end_dttm     -- 20180808 수정 ( 변경전 : , DATEADD(d, 1, @d_pet_date)     AS end_dttm --20180524 수정 (변경전 : @d_pet_date ) )
						, NULL                     AS transfer_lot_size
						, 'N'                      AS is_prev_lot_size
						, 'Y'                      AS is_pull
						, ib.pre_buffer_time       AS pre_buffer_time
						, ib.post_buffer_time      AS post_buffer_time   -- 20200323 [전지 공급 대응력 향상을 위한 RTF 적확도 개선] : th_eng_item_bod_sn 값 적용
						--, NULL                      AS post_buffer_time
						, 'DAY'                    AS buffer_time_uom
						, 'N'                      AS is_use
						, ib.route_selector_id     AS route_selector_id
						, ib.safety_stock_term     AS safety_stock_term
						, ib.safety_stock_term_uom AS safety_stock_term_uom
						, 0                        AS safety_stock_qty
						, 'BOD ALT PRIORITY'       AS descr
						, 0                        AS early_producing_term
						, 'DAY'                    AS early_producing_term_uom
						, ib.yield                 AS yield
				 FROM th_eng_item_bod_sn ib WITH (NOLOCK)                                               
				INNER JOIN th_eng_bod_sn bod  WITH (NOLOCK)
				   ON ib.master_id  = bod.master_id
				  AND ib.plan_id    = bod.plan_id
				  AND ib.bod_id     = bod.bod_id
				--2021.07.19 수정
				INNER JOIN scm_mst_bod_item_eng eng  WITH (NOLOCK)
				   ON eng.modeling_id = @p_modeling_id        
				  AND eng.plan_id     = @p_plan_id            
				  AND eng.plan_type   = @p_plan_type          
				  AND eng.plan_seq    = @p_seq                
				  AND eng.division_id = @p_division_id         
				  --AND dbo.fn_scm_split(eng.bod_id, 1, '::') <> 'x'  -- --2021.07.19 수정, 정상 BOD 만 조회하기위해서
				  AND eng.bod_id      = REPLACE(ib.bod_id, ib.item_id + '::', '') --2021.07.19 수정
				  AND eng.item_id     = ib.item_id
				  /* 2021.07.19. 추가 (기간별 1순위 경로 이외의 BOD 조회 */ 
				  AND eng.attribute5 = 'X'
				WHERE ib.master_id  =  @p_master_id        
				  AND ib.plan_id    =  @p_engine_plan_id  
				UNION ALL
				SELECT    ib.master_id
						, ib.plan_id
						, ib.item_id
						, ib.bod_id  
						, ib.alt_priority
						, 1                        AS alt_rate     
						, eng.next_start_date      AS start_dttm
						, eng.next_end_date        AS end_dttm
						, NULL                     AS transfer_lot_size
						, 'N'                      AS is_prev_lot_size
						, 'Y'                      AS is_pull
						, ib.pre_buffer_time       AS pre_buffer_time
						, ib.post_buffer_time      AS post_buffer_time  
						, 'DAY'                    AS buffer_time_uom
						, 'N'                      AS is_use
						, ib.route_selector_id     AS route_selector_id
						, ib.safety_stock_term     AS safety_stock_term
						, ib.safety_stock_term_uom AS safety_stock_term_uom
						, 0                        AS safety_stock_qty
						, 'BOD ALT PRIORITY'       AS descr
						, 0                        AS early_producing_term
						, 'DAY'                    AS early_producing_term_uom
						, ib.yield                 AS yield
				FROM th_eng_item_bod_sn ib   WITH (NOLOCK)                                               
			   INNER JOIN th_eng_bod_sn bod  WITH (NOLOCK)
				  ON ib.master_id  = bod.master_id
				 AND ib.plan_id    = bod.plan_id
				 AND ib.bod_id     = bod.bod_id
				--2021.07.19 수정
			   INNER JOIN vw_scm_mst_bod_item_eng eng
				  ON eng.bod_id    = REPLACE(ib.bod_id, ib.item_id + '::', '') 
				 AND eng.item_id   = ib.item_id
			   WHERE ib.master_id  =  @p_master_id        
				 AND ib.plan_id    =  @p_engine_plan_id  
				) A
		;
		
		/* 기간별 1순위 BOD 이외의 BOD CAL, 2021.07.19, By KKC */            
/*
		SELECT /* PR_SCP_ENG_IN_PRE_PROC_ITEM_BOD_CAL */ 
						  ib.master_id
						, ib.plan_id
						, ib.item_id
						, ib.bod_id  --, x.from_site_id, x.to_site_id, x.transport_mode
						, ib.alt_priority
						, 1                        AS alt_rate     
						, @d_plan_name             AS start_dttm
						, @d_bucket_end_date       AS end_dttm     -- 20180808 수정 ( 변경전 : , DATEADD(d, 1, @d_pet_date)     AS end_dttm --20180524 수정 (변경전 : @d_pet_date ) )
						, NULL                     AS transfer_lot_size
						, 'N'                      AS is_prev_lot_size
						, 'Y'                      AS is_pull
						, ib.pre_buffer_time       AS pre_buffer_time
						, ib.post_buffer_time      AS post_buffer_time   -- 20200323 [전지 공급 대응력 향상을 위한 RTF 적확도 개선] : th_eng_item_bod_sn 값 적용
						--, NULL                      AS post_buffer_time
						, 'DAY'                    AS buffer_time_uom
						, 'N'                      AS is_use
						, ib.route_selector_id     AS route_selector_id
						, ib.safety_stock_term     AS safety_stock_term
						, ib.safety_stock_term_uom AS safety_stock_term_uom
						, 0                        AS safety_stock_qty
						, 'BOD ALT PRIORITY'       AS descr
						, 0                        AS early_producing_term
						, 'DAY'                    AS early_producing_term_uom
						, ib.yield                 AS yield
				 INTO #th_eng_item_bod_cal_temp
				 FROM th_eng_item_bod_sn ib WITH (NOLOCK)                                               
				INNER JOIN th_eng_bod_sn bod  WITH (NOLOCK)
				   ON ib.master_id  = bod.master_id
				  AND ib.plan_id    = bod.plan_id
				  AND ib.bod_id     = bod.bod_id
				--2021.07.19 수정
				INNER JOIN scm_mst_bod_item_eng eng  WITH (NOLOCK)
				   ON eng.modeling_id = @p_modeling_id       --'1'
				  AND eng.plan_id     = @p_plan_id           --'1043'
				  AND eng.plan_type   = @p_plan_type         --'PR'
				  AND eng.plan_seq    = @p_seq               --'1'
				  AND eng.division_id = @p_division_id       --'40' 
				  --AND dbo.fn_scm_split(eng.bod_id, 1, '::') <> 'x'  -- --2021.07.19 수정, 정상 BOD 만 조회하기위해서
				  AND eng.bod_id      = REPLACE(ib.bod_id, ib.item_id + '::', '') --2021.07.19 수정
				  AND eng.item_id     = ib.item_id
				  /* 2021.07.19. 추가 (기간별 1순위 경로 이외의 BOD 조회 */ 
				  AND eng.attribute5 = 'X'
				WHERE ib.master_id  =  @p_master_id       --'81::WEEKLY'
				  AND ib.plan_id    =  @p_engine_plan_id  --'1027::PR::6'
		;
		*/

        /* OLD 소스, ~ 2021.07.19
		SELECT /* PR_SCP_ENG_IN_PRE_PROC_ITEM_BOD_CAL */ 
               x.master_id
             , x.plan_id
             , x.item_id
             , x.bod_id  --, x.from_site_id, x.to_site_id, x.transport_mode
             , x.alt_priority
             , 1                    AS alt_rate     
             , @d_plan_name         AS start_dttm
             , @d_bucket_end_date   AS end_dttm     -- 20180808 수정 ( 변경전 : , DATEADD(d, 1, @d_pet_date)     AS end_dttm --20180524 수정 (변경전 : @d_pet_date ) )
             , NULL                 AS transfer_lot_size
             , 'N'                  AS is_prev_lot_size
             , 'Y'                  AS is_pull
             , x.pre_buffer_time    AS pre_buffer_time
             , x.post_buffer_time   AS post_buffer_time   -- 20200323 [전지 공급 대응력 향상을 위한 RTF 적확도 개선] : th_eng_item_bod_sn 값 적용
             --, NULL                      AS post_buffer_time
             , 'DAY'                AS buffer_time_uom
             , 'N'                  AS is_use
             , x.route_selector_id     AS route_selector_id
             , x.safety_stock_term     AS safety_stock_term
             , x.safety_stock_term_uom AS safety_stock_term_uom
             , 0                    AS safety_stock_qty
             , 'BOD ALT PRIORITY'   AS descr
             , 0                    AS early_producing_term
             , 'DAY'                AS early_producing_term_uom
             , x.yield              AS yield
             --, 4                    AS gubun
        INTO #th_eng_item_bod_cal_temp        
        FROM (
                  SELECT ib.master_id, ib.plan_id, ib.item_id, ib.bod_id
                       , ib.alt_priority, ib.pre_buffer_time, ib.post_buffer_time, ib.route_selector_id
                       , ib.safety_stock_term, ib.safety_stock_term_uom, ib.yield
					   --, MIN(ib.alt_priority) over(partition by ib.item_id, bod.from_site_id, bod.to_site_id) as min_alt_priority
                       , MIN(ib.alt_priority) over(partition by ib.item_id, bod.from_site_id, bod.to_site_id, eng.attribute4, eng.attribute5) as min_alt_priority	--2021.06.07 추가
                       , bod.from_site_id, bod.to_site_id, bod.transport_mode
                  
                  -- 20180525 수정 th_eng_item_bod_cal조인조건에서 제외시킴
                  --FROM  ( SELECT DISTINCT  master_id, plan_id, bod_id
                  --        FROM   #th_eng_item_bod_cal
                  --        --FROM   th_eng_item_bod_cal_sn WITH (NOLOCK) 
                  --        --WHERE  master_id = @p_master_id       --'81::WEEKLY'
                  --        --AND    plan_id   = @p_engine_plan_id  --'1025::PR::14T' 
                  --        ) ibc
                  --       INNER JOIN th_eng_item_bod_sn ib WITH (NOLOCK)                         
                  --       ON  ibc.master_id  = ib.master_id
                  --       AND ibc.plan_id    = ib.plan_id
                  --       AND ibc.bod_id     = ib.bod_id

                  --      INNER JOIN th_eng_bod_sn bod  WITH (NOLOCK)
                  --      ON  ib.master_id  = bod.master_id
                  --      AND ib.plan_id    = bod.plan_id
                  --      AND ib.bod_id     = bod.bod_id

                 FROM   th_eng_item_bod_sn ib WITH (NOLOCK)                                               
                        INNER JOIN th_eng_bod_sn bod  WITH (NOLOCK)
                        ON  ib.master_id  = bod.master_id
                        AND ib.plan_id    = bod.plan_id
                        AND ib.bod_id     = bod.bod_id

						--2021.06.07 추가
						INNER JOIN scm_mst_bod_eng eng  WITH (NOLOCK)
                        ON  eng.modeling_id = @p_modeling_id       --'1'
					    AND eng.plan_id     = @p_plan_id           --'1043'
					    AND eng.plan_type   = @p_plan_type         --'PR'
					    AND eng.plan_seq    = @p_seq               --'1'
					    AND eng.division_id = @p_division_id       --'40' 
						AND eng.bod_id      = ib.bod_id

				 WHERE  1=1
                 AND    ib.master_id  =  @p_master_id       --'81::WEEKLY'
                 AND    ib.plan_id    =  @p_engine_plan_id  --'1027::PR::6' 
                  
             ) x          
        WHERE  x.alt_priority <> x.min_alt_priority
        ORDER BY item_id, from_site_id, to_site_id
        ;
*/
		

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 4-1 END';
        SET @v_description = N'4-1. ITEM BOD alt_priority 1순위 제외한 데이터 임시테이블로 일괄생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        --------------------------------------------------------------------------------------------------------------------

		-----------------------------------------------------------
        -- 4-2) 위1,2,3에서 생성된 데이터 중 위4-1) 생성한 데이터와 
        --      동일한 item_id, from_site, to_site 값을 가지는 데이터 삭제                        
        -----------------------------------------------------------
        
        /* 2021.08.26 수정/보완 */
		/* 1순위 이하 경로 항차 Calendar 생성 데이터 삭제 */
		DELETE #th_eng_item_bod_cal       
        FROM   #th_eng_item_bod_cal ibc   
        WHERE  master_id  = @p_master_id       
        AND    plan_id    = @p_engine_plan_id   
        AND    EXISTS
				   ( SELECT 'X'
					   FROM #th_eng_item_bod_cal_temp x WITH(NOLOCK)
					  WHERE ibc.bod_id    = x.bod_id
						AND ibc.item_id   = x.item_id 
						AND ibc.start_dttm >= x.start_dttm
						AND ibc.end_dttm   <= x.end_dttm
				  )
        ;

		/* 2021.07.19 수정 */
		/* bod start dttm보다 작은 Calendar 데이터 삭제 */
		DELETE #th_eng_item_bod_cal       
		  FROM #th_eng_item_bod_cal ibc   
		 WHERE EXISTS (SELECT 'X'
						 FROM th_eng_bod_sn x WITH(NOLOCK)
						WHERE x.master_id = @p_master_id
						  AND x.plan_id   = @p_engine_plan_id
						  AND x.bod_id    = ibc.bod_id
						  AND x.bod_start_dttm > ibc.end_dttm
						 )

		;

		/* OLD, ~ 2021.07.19
		DELETE #th_eng_item_bod_cal      -- th_eng_item_bod_cal_sn
        FROM   #th_eng_item_bod_cal ibc  -- th_eng_item_bod_cal_sn ibc
        WHERE  master_id  = @p_master_id       --'81::WEEKLY'
        AND    plan_id    = @p_engine_plan_id  --'1026::PR::5'
        AND    EXISTS
               (SELECT 1
                FROM 
                    (SELECT  master_id, plan_id, item_id, bod_id 
                    FROM   
                           (SELECT ib.master_id, ib.plan_id, ib.item_id, ib.bod_id
                                 , ib.alt_priority --, bod.from_site_id, bod.to_site_id, bod.transport_mode
                                 --, MIN(ib.alt_priority) over(partition by ib.item_id, bod.from_site_id, bod.to_site_id) as min_alt_priority         
								 , MIN(ib.alt_priority) over(partition by ib.item_id, bod.from_site_id, bod.to_site_id, eng.attribute4, eng.attribute5) as min_alt_priority	--2021.06.07 추가        
                       
                            FROM  th_eng_item_bod_sn ib WITH (NOLOCK)
                                , th_eng_bod_sn bod  WITH (NOLOCK)
								, scm_mst_bod_eng eng WITH(NOLOCK)	--2021.06.07 추가  
                            WHERE ib.master_id  = @p_master_id      --'81::WEEKLY'
                            AND   ib.plan_id    = @p_engine_plan_id --'1026::PR::5'
                            AND   ib.master_id  = bod.master_id
                            AND   ib.plan_id    = bod.plan_id
                            AND   ib.bod_id     = bod.bod_id

							--2021.06.07 추가
							AND    eng.modeling_id = @p_modeling_id
							AND    eng.plan_id     = @p_plan_id
							AND    eng.plan_type   = @p_plan_type
							AND    eng.plan_seq    = @p_seq
							AND    eng.division_id = @p_division_id
							AND    eng.bod_id      = REPLACE(ib.bod_id, ib.item_id + '::', '') --2021.07.19 수정
                          ) a
                    WHERE  a.alt_priority <> a.min_alt_priority         
                    ) x 
               WHERE  ibc.master_id = x.master_id 
               AND    ibc.plan_id   = x.plan_id 
               AND    ibc.bod_id    = x.bod_id
               AND    ibc.item_id   = x.item_id 
              )
        ;
		*/

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 4-2 END';
        SET @v_description = N'4-2. ITEM BOD alt_priority 1순위 제외한 데이터 삭제' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        --------------------------------------------------------------------------------------------------------------------


		-----------------------------------------------------------
        -- 4-2-1) SCP_MST_BOD_ITEM_EXCEPT 생성하면서 만들어진 중복 날짜 삭제                      
        -----------------------------------------------------------		
		--2021.06.07 추가
        DELETE #th_eng_item_bod_cal
        FROM   #th_eng_item_bod_cal ibc 
        WHERE  master_id         =  @p_master_id 
        AND    plan_id           =  @p_engine_plan_id
		AND    ISNULL(descr,'-') <> 'SCP_MST_BOD_ITEM_EXCEPT'
		AND    is_use            =  'N'
        AND    EXISTS
               (SELECT 1
                FROM 
                    (
						SELECT b.master_id, b.plan_id, b.bod_id, b.item_id, b.start_dttm, b.end_dttm
						FROM
						(
							SELECT a.master_id, a.plan_id, a.bod_id, a.item_id, a.start_dttm, a.end_dttm
							FROM #th_eng_item_bod_cal a WITH(NOLOCK)
							WHERE 1=1
							AND a.master_id         = @p_master_id
							AND a.plan_id           = @p_engine_plan_id
							AND ISNULL(a.descr,'-') = 'SCP_MST_BOD_ITEM_EXCEPT'
							AND a.is_use            = 'N'
						) A 
						INNER JOIN 
						(
							SELECT a.master_id, a.plan_id, a.bod_id, a.item_id, a.start_dttm, a.end_dttm
							FROM #th_eng_item_bod_cal a WITH(NOLOCK)
							WHERE 1=1
							AND a.master_id         =  @p_master_id
							AND a.plan_id           =  @p_engine_plan_id
							AND ISNULL(a.descr,'-') <> 'SCP_MST_BOD_ITEM_EXCEPT'
							AND a.is_use            =  'N'
						)  as b 
						ON  a.master_id  =  b.master_id 
						AND a.plan_id    =  b.plan_id 
						AND a.item_id    =  b.item_id 
						AND a.bod_id     =  b.bod_id 
						AND a.start_dttm <= b.start_dttm 
						AND a.end_dttm   >= b.end_dttm
                    ) x 
               WHERE  ibc.master_id  = x.master_id 
               AND    ibc.plan_id    = x.plan_id 
               AND    ibc.bod_id     = x.bod_id
               AND    ibc.item_id    = x.item_id 
			   AND    ibc.start_dttm = x.start_dttm
			   AND    ibc.end_dttm   = x.end_dttm
              )
        ;

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 4-2-1 END';
        SET @v_description = N'4-2-1. 임시테이블을 th_eng_item_bod_cal에 DELETE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        --------------------------------------------------------------------------------------------------------------------

        -----------------------------------------------------------
        -- 4-2-2) SCP_MST_BOD_ITEM_EXCEPT 생성하면서 만들어진 상위END/하위START 날짜가 중복되어 있는 경우 업데이트                      
        -----------------------------------------------------------
		--2021.06.07 추가
        UPDATE a
		SET    a.start_dttm = b.end_dttm
        FROM   #th_eng_item_bod_cal a
					INNER JOIN (
						SELECT a.master_id, a.plan_id, a.bod_id, a.item_id, a.start_dttm, a.end_dttm
						FROM #th_eng_item_bod_cal a WITH(NOLOCK)
						WHERE 1=1
						AND a.master_id         = @p_master_id
						AND a.plan_id           = @p_engine_plan_id
						AND ISNULL(a.descr,'-') = 'SCP_MST_BOD_ITEM_EXCEPT'
						AND a.is_use            = 'N'
					) AS b
					ON  a.master_id  = b.master_id 
					AND a.plan_id    = b.plan_id 
					AND a.item_id    = b.item_id 
					AND a.bod_id     = b.bod_id 
					AND a.start_dttm < b.end_dttm	
					AND a.end_dttm   > b.end_dttm	
        WHERE  a.master_id         =  @p_master_id
        AND    a.plan_id           =  @p_engine_plan_id
		AND    ISNULL(a.descr,'-') <> 'SCP_MST_BOD_ITEM_EXCEPT'
		AND    a.is_use            =  'N'
        ;
		
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 4-2-2 END';
        SET @v_description = N'4-2-2. 임시테이블을 th_eng_item_bod_cal에 UPDATE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        --------------------------------------------------------------------------------------------------------------------


        -----------------------------------------------------------
        -- 4-3) 위4-1)에서 생성된 임시테이블 테이터 INSERT              
        -----------------------------------------------------------
        INSERT INTO  /* PR_SCP_ENG_IN_PRE_PROC_ITEM_BOD_CAL */ th_eng_item_bod_cal_sn --테이블 컬럼 확인(ODS 테이블정의서의 컬럼목록과 비교(사용여부도 확인))
        (   master_id
          , plan_id
          , item_id
          , bod_id
          , alt_priority
          , alt_rate
          , start_dttm
          , end_dttm
          , transfer_lot_size
          , is_prev_lot_size
          , is_pull
          , pre_buffer_time
          , post_buffer_time
          , buffer_time_uom
          , is_use
          , route_selector_id
          , safety_stock_term
          , safety_stock_term_uom
          , safety_stock_qty
          , descr
          , early_producing_term
          , early_producing_term_uom
          , yield
        )
        SELECT DISTINCT
              master_id
            , plan_id
            , item_id
            , bod_id
            , alt_priority
            , alt_rate
            , start_dttm
            , end_dttm
            , transfer_lot_size
            , is_prev_lot_size
            , is_pull
            , pre_buffer_time
            , post_buffer_time
            , buffer_time_uom
            , is_use
            , route_selector_id
            , safety_stock_term
            , safety_stock_term_uom
            , safety_stock_qty
            , descr
            , early_producing_term
            , early_producing_term_uom
            , yield 
        FROM  ( SELECT  master_id
                        , plan_id
                        , item_id
                        , bod_id
                        , alt_priority
                        , alt_rate
                        , start_dttm
                        , end_dttm
                        , transfer_lot_size
                        , is_prev_lot_size
                        , is_pull
                        , pre_buffer_time
                        , post_buffer_time
                        , buffer_time_uom
                        , is_use
                        , route_selector_id
                        , safety_stock_term
                        , safety_stock_term_uom
                        , safety_stock_qty
                        , descr
                        , early_producing_term
                        , early_producing_term_uom
                        , yield 
                        , ROW_NUMBER() OVER (PARTITION BY a.master_id, a.plan_id, a.item_id, a.bod_id, a.start_dttm ORDER BY day_diff DESC) row_num 
                 FROM
                    ( SELECT master_id
                            , plan_id
                            , item_id
                            , bod_id
                            , alt_priority
                            , alt_rate
                            , start_dttm
                            , end_dttm
                            , transfer_lot_size
                            , is_prev_lot_size
                            , is_pull
                            , pre_buffer_time
                            , post_buffer_time
                            , buffer_time_uom
                            , is_use
                            , route_selector_id
                            , safety_stock_term
                            , safety_stock_term_uom
                            , safety_stock_qty
                            , descr
                            , early_producing_term
                            , early_producing_term_uom
                            , yield 
                            , DATEDIFF(d, start_dttm, end_dttm) day_diff
                        FROM #th_eng_item_bod_cal_temp
                        UNION ALL 
                        SELECT master_id
                            , plan_id
                            , item_id
                            , bod_id
                            , alt_priority
                            , alt_rate
                            , start_dttm
                            , end_dttm
                            , transfer_lot_size
                            , is_prev_lot_size
                            , is_pull
                            , pre_buffer_time
                            , post_buffer_time
                            , buffer_time_uom
                            , is_use
                            , route_selector_id
                            , safety_stock_term
                            , safety_stock_term_uom
                            , safety_stock_qty
                            , descr
                            , early_producing_term
                            , early_producing_term_uom
                            , yield                            
                            , DATEDIFF(d, start_dttm, end_dttm) day_diff 
                        FROM #th_eng_item_bod_cal 
                ) a
               
              ) x  
        where  row_num = 1
        ;

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 4-3 END';
        SET @v_description = N'4-3. 임시테이블을 th_eng_item_bod_cal에 INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        --------------------------------------------------------------------------------------------------------------------


        -----------------------------------------------------------			
        -- 5. 특성 BOD에 대하여 수율 설정
	    --     F6000 의 수율은 특성용 BOD(001 -> 002)에 반영 : [dbo].[scm_mst_yield_ver_h_v] 
        --     IS_USE = 'Y'로 셋팅
        
        --     F5300, F5500 수율적용 (20181109추가)
        -----------------------------------------------------------

        ---------------------------------------------------------------
        --5-1) 특성 BOD 대상 임시테이블생성 (특성 BOD 대상 :  from site A~001 -> to site A~002)
        --2023.08.07 속도개선작업 :  temp #tmp_ib , #total_yld  생성.
        ---------------------------------------------------------------

        --- temp 1 --- 
        IF OBJECT_ID('tempdb..#tmp_ib') IS NOT NULL
        BEGIN 
            DROP TABLE  #tmp_ib       
        END

        SELECT  IB.*  
                , bod.from_site_id , bod.to_site_id 
                , mse.company_id  , mse.division_id , mse.site_id , mse.plant_id    
        INTO    #tmp_ib  

        FROM    th_eng_item_bod_sn       ib  WITH(NOLOCK)
               
                INNER JOIN th_eng_bod_sn   bod WITH(NOLOCK)   --~특성 bod 검색
                ON   ib.master_id = bod.master_id
                AND  ib.plan_id   = bod.plan_id
                AND  ib.bod_id    = bod.bod_id             
                AND  ib.master_id = @p_master_id      
                AND  ib.plan_id   = @p_engine_plan_id 
                AND  bod.from_site_id LIKE '%~001'
                AND  bod.to_site_id   LIKE '%~002' 
             
                INNER JOIN ( --~사내 조립인 from stie 검색.
                        SELECT  scm_site_id, eng_scm_site_id, plant_id
                                , company_id, site_id , division_id
                                , ISNULL(osp_yn, 'N') AS osp_yn -- 20180807 추가 외주셀처리를 위해서  
                        FROM   scm_mst_site_eng WITH (NOLOCK)
                        WHERE  modeling_id = @p_modeling_id  
                        AND    plan_id     = @p_plan_id        
                        AND    plan_type   = @p_plan_type      
                        AND    plan_seq    = @p_seq           
                        AND    division_id = @p_division_id   
                        AND    operation_group     = 'A'
                        AND    ISNULL(osp_yn, 'N') = 'N'    --20180807 추가 외주셀 제외
                        ) mse
                ON  bod.from_site_id = mse.eng_scm_site_id     
        ; 

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type  = 'TXN';
        SET @v_log_message = 'PART 5-1 (1) END';
        SET @v_description = N'5-1. (1) #tmp_ib 생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date  = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


        --- temp 2 --- 
        IF OBJECT_ID('tempdb..#total_yld') IS NOT NULL
        BEGIN 
            DROP TABLE  #total_yld       
        END

        SELECT  A.* 
        INTO    #total_yld 
        FROM    ( --20180418 INNER JOIN 에서 LEFT JOIN으로 수정
                -- 1) 당월, 차월 yield정보(당월, 차월은 FP용 yield 정보사용, 정보가없으면 SCP용 yield 정보사용함) 
                SELECT yld.company_id  AS company_id
                    , yld.division_id AS division_id
                    , yld.site_id     AS site_id
                    , yld.plant_id    AS plant_id
                    , yld.item_id     AS item_id
                    , yld.month       AS month
                    , yld.yield       AS yield
                    , buc.start_dttm  AS start_dttm
                    , buc.end_dttm    AS end_dttm
                FROM   (SELECT company_id, division_id, site_id, plant_id, item_id, month
                            -- 수율 0 또는 NULL은 1로 처리함
                            , MAX(  CASE WHEN yield = 0 THEN 1
                                        WHEN yield > 1 THEN 1
                                    ELSE ISNULL(yield, 1)
                                    END
                                  ) AS yield -- 누적수율은 곱해야 하나 일단 MIN 값으로 처리함										   
                        FROM   dbo.scm_mst_yield_ver_h_v WITH (NOLOCK)    -- PJ20209642 변경  scm_mst_yield_sn
                        WHERE  division_id  = @p_division_id  
                                 
                        AND   operation_id IN ( SELECT segment1 AS operation_id FROM scm_adm_lookup_master_detail WITH (NOLOCK)
		                                        WHERE lookup_type = 'OPERATION_CHAR'
		                                        AND   segment3    = 'Y'  -- Tact Time / yield 적용 대상 공정
		                                        AND   valid_yn    = 'Y' 
                                            ) -- 20181109 수정 ( 변경전 : AND   operation_id IN ('F5300', 'F5500', 'F6000') --20181109 수정 ( 변경전 : AND   operation_id = 'F6000') )
                                 
                        AND   month        >= SUBSTRING(@p_plan_name, 1, 6)
                        AND   month         < CONVERT(NVARCHAR(6), DATEADD(m, 2, CONVERT(DATETIME,LEFT(@p_plan_name, 6) + '01')), 112) -- 20180425 추가 (당월, 차월 까지만 조회되게하기위해서)
                        GROUP BY company_id, division_id, site_id, plant_id, item_id, month 
                        ) yld       
                    
                        INNER JOIN (
                                SELECT b.master_id
                                    , b.plan_id
                                    , CONVERT(CHAR(6), b.start_dttm, 112) AS month
                                    , MIN(b.start_dttm) AS start_dttm
                                    , MAX(b.end_dttm)   AS end_dttm
                                FROM   th_eng_bucket_info_sn b WITH(NOLOCK)
                                WHERE  b.master_id   = @p_master_id           
                                AND    b.plan_id     = @p_engine_plan_id       
                                AND    b.descr       = 'PLAN'  -- 2018.07.05 추가 (  plan시작일~ plan종료일 : descr = 'PLAN' , plan종료일이후~ 13주 : descr = 'ADD')
                                GROUP BY b.master_id, b.plan_id, CONVERT(CHAR(6), b.start_dttm, 112)
                                ) buc
                        ON yld.month = buc.month
                         
                -- 2) 차월이후일때는 SCP용 yield정보 사용함
                UNION 
                SELECT  yld.company_id   AS company_id
                    , yld.division_id  AS division_id
                    , yld.site_id      AS site_id
                    , yld.plant_id     AS plant_id
                    , yld.item_id      AS item_id
                    , buc.month        AS month
                               
                    , NULL AS yield       --20180425 수정 ( 차월이후는 scp의 yield(scp_mst_formation.formation_total_yield) 정보 사용하면되므로 null 처리함) (변경전 : , yld.yield AS yield )

                    , buc.start_dttm   AS start_dttm
                    , buc.end_dttm     AS end_dttm
                         
                FROM   ( SELECT company_id, division_id, site_id, plant_id, item_id
                            , MAX(month) month -- yield  정보가 있는 마지막 월
                                      
                        FROM   dbo.scm_mst_yield_ver_h_v WITH (NOLOCK)    -- PJ20209642 변경  scm_mst_yield_sn
                        WHERE  division_id  = @p_division_id  
                                  
                        AND   operation_id IN ( SELECT segment1 AS operation_id FROM scm_adm_lookup_master_detail WITH (NOLOCK)
		                                        WHERE lookup_type = 'OPERATION_CHAR'
		                                        AND   segment3    = 'Y'  -- Tact Time / yield 적용 대상 공정
		                                        AND   valid_yn    = 'Y' 
                                            ) -- 20181109 수정 ( 변경전 : AND   operation_id IN ('F5300', 'F5500', 'F6000') --20181109 수정 ( 변경전 : AND   operation_id = 'F6000') )
                                  
                        AND    month        >= SUBSTRING(@p_plan_name, 1, 6)
                        AND    month         < CONVERT(NVARCHAR(6), DATEADD(m, 2, CONVERT(DATETIME,LEFT(@p_plan_name, 6) + '01')), 112) -- 20180425 추가 (당월, 차월 까지만 조회되게하기위해서)
                        GROUP BY company_id, division_id, site_id, plant_id, item_id
                        ) yld     
               
                    , (SELECT b.master_id
                            , b.plan_id
                            , CONVERT(CHAR(6), b.start_dttm, 112) AS month
                            , MIN(b.start_dttm) AS start_dttm
                            , MAX(b.end_dttm)   AS end_dttm
                        FROM   th_eng_bucket_info_sn b WITH(NOLOCK)
                        WHERE  b.master_id   = @p_master_id          
                        AND    b.plan_id     = @p_engine_plan_id     
                        AND    b.descr       = 'PLAN'  -- 2018.07.05 추가 (  plan시작일~ plan종료일 : descr = 'PLAN' , plan종료일이후~ 13주 : descr = 'ADD')
                        GROUP BY b.master_id, b.plan_id, CONVERT(CHAR(6), b.start_dttm, 112)
                        ) buc
                WHERE buc.month > yld.month                       
                )  A
                ; 

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type  = 'TXN';
        SET @v_log_message = 'PART 5-1 (2) END';
        SET @v_description = N'5-1. (2) #total_yld 생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date  = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        
        
        --- FOR BOD에 대하여 Yield 설정 메인 --- 
        IF OBJECT_ID('tempdb..#TH_ENG_ITEM_BOD_CAL_TEMP2') IS NOT NULL
        BEGIN 
            DROP TABLE  #TH_ENG_ITEM_BOD_CAL_TEMP2          
        END

        SELECT ib.master_id              AS master_id
             , ib.plan_id                AS plan_id
             , ib.item_id                AS item_id
             , ib.bod_id                 AS bod_id
             , ib.alt_priority           AS alt_priority
             , 1	                     AS alt_rate
             
             , ISNULL(total_yld.start_dttm, smf.start_dttm)  AS start_dttm
             , ISNULL(total_yld.end_dttm, smf.end_dttm)   AS end_dttm
              
             , NULL                      AS transfer_lot_size
             ,'N'                        AS is_prev_lot_size
             ,'Y'                        AS is_pull
             , ib.pre_buffer_time        AS pre_buffer_time 
             , ib.post_buffer_time       AS post_buffer_time   -- 20200323 [전지 공급 대응력 향상을 위한 RTF 적확도 개선] : th_eng_item_bod_sn 값 적용
             , 'DAY'                     AS buffer_time_uom
             
             , 'Y'                       AS is_use   -- 여기는 'Y' 

             , ib.route_selector_id      AS route_selector_id
             , ib.safety_stock_term      AS safety_stock_term      
             , ib.safety_stock_term_uom  AS safety_stock_term_uom
             , 0                         AS safety_stock_qty

             
             , ISNULL(CASE WHEN total_yld.start_dttm <  DATEADD(m, 2, CONVERT(DATETIME,LEFT(@p_plan_name, 6) + '01'))  THEN IIF(total_yld.yield IS NULL AND smf.formation_total_yield IS NOT NULL,  'FORMATION_USE_Y','FORMATION_USE_N')
                           ELSE IIF(smf.formation_total_yield IS NOT NULL, 'FORMATION_USE_Y', 'FORMATION_USE_N' )
                      END, 'FORMATION_USE_N')  AS descr -- 20180516 수정 (변경전 : , NULL AS descr )

             , 0                         AS early_producing_term
             , 'DAY'                     AS early_producing_term_uom
             
             --20180405 수정 ( 당월,차월은 FP의 yield정보, 그이후는 scp관리(scp_mst_formation.formation_total_yield) yield사용함 )
             --20190408 수정 (기존은 당월,차월 일때는 FP특성수율(scm_mst_yield_ver_h_v.yield)을 사용중이었으나, 특성전체수율(활성수율*특성수율)로 변경됨에 따라 scm_mst_yield_ver_h_v.yield(특성수율) * scp_mst_formation.formation_yield(활성수율) 처리해야한다.)
             , ISNULL(CASE WHEN total_yld.start_dttm <  DATEADD(m, 2, CONVERT(DATETIME,LEFT(@p_plan_name, 6) + '01'))  THEN ISNULL(total_yld.yield * ISNULL(smf.formation_yield, 1), ISNULL(smf.formation_total_yield, 1))
                           ELSE ISNULL(smf.formation_total_yield, 1)
                      END, 1)  AS yield              
        
        INTO #TH_ENG_ITEM_BOD_CAL_TEMP2
        -- 2023.08.07  temp table로 변경함.
        FROM    #tmp_ib   AS  ib

                LEFT JOIN  #total_yld  AS  total_yld          
                ON   total_yld.company_id  = ib.company_id 
                AND  total_yld.division_id = ib.division_id 
                AND  total_yld.site_id     = ib.site_id 
                AND  total_yld.plant_id    = ib.plant_id 
                AND  total_yld.item_id     = ib.item_id 

                -- 20180405 추가 ( 당월,차월은 FP의 yield정보, 그이후는 scp관리(scp_mst_formation.formation_total_yield) yield사용함 )
                LEFT JOIN ( --: smf 
                        SELECT  division_id
                            , plant_site_id + '~001' AS eng_from_site_id
                            , plant_site_id + '~002' AS eng_to_site_id
                            , item_id
                            , CASE  WHEN formation_total_yield = 0 THEN 1
                                    WHEN formation_total_yield > 1 THEN 1
                                    ELSE ISNULL(formation_total_yield, 1)
                                    END  AS formation_total_yield 
                                --20190408 추가
                            , CASE  WHEN formation_yield = 0 THEN 1
                                    WHEN formation_yield > 1 THEN 1
                                    ELSE ISNULL(formation_yield, 1)
                                    END  AS formation_yield     
                            , CONVERT(DATETIME, @p_plan_name) AS start_dttm
                            , DATEADD(d, 1, @d_pet_date) AS end_dttm  -- 20180524 (변경전 : @d_pet_date AS end_dttm )                    
                        FROM   scp_mst_formation WITH (NOLOCK)
                        WHERE  division_id = @p_division_id  
                        ) smf
                ON   ib.item_id = smf.item_id
                AND  ib.from_site_id = smf.eng_from_site_id
                AND  ib.to_site_id   = smf.eng_to_site_id
        --20180418 WHERE절추가 ( total_yld inner join => left join 변경 때문에 추가함)
        WHERE ( total_yld.company_id IS NOT NULL 
                OR
                smf.division_id IS NOT NULL  )         
        ; 

/*  2023.08.07 수정 전 소스 
        FROM th_eng_item_bod_sn       ib  WITH(NOLOCK)
             INNER JOIN th_eng_bod_sn bod WITH(NOLOCK)
             ON   ib.master_id = bod.master_id
             AND  ib.plan_id   = bod.plan_id
             AND  ib.bod_id    = bod.bod_id
             
             AND  ib.master_id = @p_master_id      
             AND  ib.plan_id   = @p_engine_plan_id 
             AND  bod.from_site_id LIKE '%~001'
             AND  bod.to_site_id   LIKE '%~002' 
             
             INNER JOIN ( SELECT scm_site_id, eng_scm_site_id, plant_id
                               , company_id, site_id , division_id
                               , ISNULL(osp_yn, 'N') AS osp_yn -- 20180807 추가 외주셀처리를 위해서  
                          FROM   scm_mst_site_eng WITH (NOLOCK)
                          WHERE  modeling_id = @p_modeling_id  
                          AND    plan_id     = @p_plan_id        
                          AND    plan_type   = @p_plan_type      
                          AND    plan_seq    = @p_seq           
                          AND    division_id = @p_division_id   
                          AND    operation_group     = 'A'
                          AND    ISNULL(osp_yn, 'N') = 'N'    --20180807 추가 외주셀 제외
                        ) mse
             ON  bod.from_site_id = mse.eng_scm_site_id               

             LEFT JOIN ( --20180418 INNER JOIN 에서 LEFT JOIN으로 수정
                         -- 1) 당월, 차월 yield정보(당월, 차월은 FP용 yield 정보사용, 정보가없으면 SCP용 yield 정보사용함) 
                         SELECT yld.company_id  AS company_id
                              , yld.division_id AS division_id
                              , yld.site_id     AS site_id
                              , yld.plant_id    AS plant_id
                              , yld.item_id     AS item_id
                              , yld.month       AS month
                              , yld.yield       AS yield
                              , buc.start_dttm  AS start_dttm
                              , buc.end_dttm    AS end_dttm
                         FROM   (SELECT company_id, division_id, site_id, plant_id, item_id, month
                                     -- 수율 0 또는 NULL은 1로 처리함
                                      , MAX(CASE WHEN yield = 0 THEN 1
                                                 WHEN yield > 1 THEN 1
                                                 ELSE ISNULL(yield, 1)
                                            END
                                           ) AS yield -- 누적수율은 곱해야 하나 일단 MIN 값으로 처리함
										   
                                 FROM   dbo.scm_mst_yield_ver_h_v WITH (NOLOCK)    -- PJ20209642 변경  scm_mst_yield_sn
                                 WHERE division_id  = @p_division_id  
                                 
                                 AND   operation_id IN ( SELECT segment1 AS operation_id FROM scm_adm_lookup_master_detail WITH (NOLOCK)
		                                                 WHERE lookup_type = 'OPERATION_CHAR'
		                                                 AND   segment3    = 'Y'  -- Tact Time / yield 적용 대상 공정
		                                                 AND   valid_yn    = 'Y' 
                                                       ) -- 20181109 수정 ( 변경전 : AND   operation_id IN ('F5300', 'F5500', 'F6000') --20181109 수정 ( 변경전 : AND   operation_id = 'F6000') )
                                 
                                 AND   month        >= SUBSTRING(@p_plan_name, 1, 6)
                                 AND   month         < CONVERT(NVARCHAR(6), DATEADD(m, 2, CONVERT(DATETIME,LEFT(@p_plan_name, 6) + '01')), 112) -- 20180425 추가 (당월, 차월 까지만 조회되게하기위해서)
                                 GROUP BY company_id, division_id, site_id, plant_id, item_id, month 
                                ) yld       
                    
                                INNER JOIN (SELECT b.master_id
                                                 , b.plan_id
                                                 , CONVERT(CHAR(6), b.start_dttm, 112) AS month
                                                 , MIN(b.start_dttm) AS start_dttm
                                                 , MAX(b.end_dttm)   AS end_dttm
                                            FROM   th_eng_bucket_info_sn b WITH(NOLOCK)
                                            WHERE  b.master_id   = @p_master_id           
                                            AND    b.plan_id     = @p_engine_plan_id       
                                            AND    b.descr       = 'PLAN'  -- 2018.07.05 추가 (  plan시작일~ plan종료일 : descr = 'PLAN' , plan종료일이후~ 13주 : descr = 'ADD')
                                            GROUP BY b.master_id, b.plan_id, CONVERT(CHAR(6), b.start_dttm, 112)
                                          ) buc
                                ON yld.month = buc.month
                         
                         -- 2) 차월이후일때는 SCP용 yield정보 사용함
                         UNION 
                         SELECT  yld.company_id   AS company_id
                               , yld.division_id  AS division_id
                               , yld.site_id      AS site_id
                               , yld.plant_id     AS plant_id
                               , yld.item_id      AS item_id
                               , buc.month        AS month
                               
                               , NULL AS yield       --20180425 수정 ( 차월이후는 scp의 yield(scp_mst_formation.formation_total_yield) 정보 사용하면되므로 null 처리함) (변경전 : , yld.yield AS yield )

                               , buc.start_dttm   AS start_dttm
                               , buc.end_dttm     AS end_dttm
                         
                         FROM   ( SELECT company_id, division_id, site_id, plant_id, item_id
                                       , MAX(month) month -- yield  정보가 있는 마지막 월
                                      
                                  FROM   dbo.scm_mst_yield_ver_h_v WITH (NOLOCK)    -- PJ20209642 변경  scm_mst_yield_sn
                                  WHERE  division_id  = @p_division_id  
                                  
                                  AND   operation_id IN ( SELECT segment1 AS operation_id FROM scm_adm_lookup_master_detail WITH (NOLOCK)
		                                                  WHERE lookup_type = 'OPERATION_CHAR'
		                                                  AND   segment3    = 'Y'  -- Tact Time / yield 적용 대상 공정
		                                                  AND   valid_yn    = 'Y' 
                                                       ) -- 20181109 수정 ( 변경전 : AND   operation_id IN ('F5300', 'F5500', 'F6000') --20181109 수정 ( 변경전 : AND   operation_id = 'F6000') )
                                  
                                  AND    month        >= SUBSTRING(@p_plan_name, 1, 6)
                                  AND    month         < CONVERT(NVARCHAR(6), DATEADD(m, 2, CONVERT(DATETIME,LEFT(@p_plan_name, 6) + '01')), 112) -- 20180425 추가 (당월, 차월 까지만 조회되게하기위해서)
                                  GROUP BY company_id, division_id, site_id, plant_id, item_id
                                ) yld     
               
                                , (SELECT b.master_id
                                        , b.plan_id
                                        , CONVERT(CHAR(6), b.start_dttm, 112) AS month
                                        , MIN(b.start_dttm) AS start_dttm
                                        , MAX(b.end_dttm)   AS end_dttm
                                   FROM   th_eng_bucket_info_sn b WITH(NOLOCK)
                                   WHERE  b.master_id   = @p_master_id          
                                   AND    b.plan_id     = @p_engine_plan_id     
                                   AND    b.descr       = 'PLAN'  -- 2018.07.05 추가 (  plan시작일~ plan종료일 : descr = 'PLAN' , plan종료일이후~ 13주 : descr = 'ADD')
                                   GROUP BY b.master_id, b.plan_id, CONVERT(CHAR(6), b.start_dttm, 112)
                                  ) buc
                         WHERE buc.month > yld.month 
                      
                      ) AS total_yld

             ON   total_yld.company_id  = mse.company_id 
             AND  total_yld.division_id = mse.division_id 
             AND  total_yld.site_id     = mse.site_id 
             AND  total_yld.plant_id    = mse.plant_id 
             AND  ib.item_id            = total_yld.item_id 
 
             -- 20180405 추가 ( 당월,차월은 FP의 yield정보, 그이후는 scp관리(scp_mst_formation.formation_total_yield) yield사용함 )
             LEFT JOIN ( SELECT division_id
                              , plant_site_id + '~001' AS eng_from_site_id
                              , plant_site_id + '~002' AS eng_to_site_id
                              , item_id
                              , CASE WHEN formation_total_yield = 0 THEN 1
                                     WHEN formation_total_yield > 1 THEN 1
                                     ELSE ISNULL(formation_total_yield, 1)
                                 END AS formation_total_yield                 
                              
                              --20190408 추가
                              , CASE WHEN formation_yield = 0 THEN 1
                                     WHEN formation_yield > 1 THEN 1
                                     ELSE ISNULL(formation_yield, 1)
                                 END AS formation_yield     

                              , CONVERT(DATETIME, @p_plan_name) AS start_dttm
                              , DATEADD(d, 1, @d_pet_date) AS end_dttm  -- 20180524 (변경전 : @d_pet_date AS end_dttm )                    
                         FROM   scp_mst_formation WITH (NOLOCK)
                         WHERE  division_id = @p_division_id  ) smf
             ON   ib.item_id = smf.item_id
             AND  bod.from_site_id = smf.eng_from_site_id
             AND  bod.to_site_id   = smf.eng_to_site_id
        
        --20180418 WHERE절추가 ( total_yld inner join => left join 변경 때문에 추가함)
        WHERE (total_yld.company_id IS NOT NULL 
               OR
               smf.division_id IS NOT NULL )
               ;
*/
        
		
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 5-1 END';
        SET @v_description = N'5-1. FOR BOD에 대하여 Yield 설정' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        --------------------------------------------------------------------------------------------------------------------



        ---------------------------------------------------------------
        --5-2) 분할대상 임시테이블생성
        --     - 분할대상 : yield값이 scp_mst_formation.yiled값 사용한 데이터
        ---------------------------------------------------------------
        IF OBJECT_ID('tempdb..#DIV_TH_ENG_ITEM_BOD_CAL') IS NOT NULL
        BEGIN 
            DROP TABLE  #DIV_TH_ENG_ITEM_BOD_CAL          
        END

        SELECT x.*
             , DATEDIFF(d, start_dttm, formation_start_date) AS start_date_diff -- 'formation의 formation_start_date' - 'th_eng_item_bod_cal의start_dttm'  

             , DATEDIFF(d, formation_end_date, end_dttm) AS end_date_diff -- 'th_eng_item_bod_cal의 end_dttm' - 'formation의 formation_end_date'    

             , DATEDIFF(d, formation_end_date, CONVERT(DATETIME, next_formation_start_date)) AS formation_enddate_nextstartdate_diff  -- '다음행의 formation의 start_date' -'현재행의 formation의 end_date'  
        INTO   #DIV_TH_ENG_ITEM_BOD_CAL 
        FROM   (SELECT a.*
                        , b.plant_site_id, CONVERT(DATETIME, b.formation_start_date) AS formation_start_date, CONVERT(DATETIME, b.formation_end_date) AS formation_end_date
                        
                        , CASE WHEN b.formation_total_yield = 0 THEN 1
                               WHEN b.formation_total_yield > 1 THEN 1
                               ELSE ISNULL(b.formation_total_yield, 1)
                          END AS formation_total_yield                           

                        , ROW_NUMBER()  OVER (PARTITION BY a.master_id, a.plan_id, a.item_id, a.bod_id, a.start_dttm ORDER BY a.start_dttm, b.formation_start_date) row_num --그룹별 순번
                        , COUNT(*)  OVER (PARTITION BY a.master_id, a.plan_id, a.item_id, a.bod_id, a.start_dttm ) cnt                              --그룹별 전체개수
                        , LEAD(b.formation_start_date, 1)  OVER (PARTITION BY a.master_id, a.plan_id, a.item_id, a.bod_id, a.start_dttm ORDER BY a.start_dttm) next_formation_start_date  --다음행의 scp_mst_formation_except.fromation_start_date
                FROM    #TH_ENG_ITEM_BOD_CAL_TEMP2 a
                        INNER JOIN scp_mst_formation_except b WITH (NOLOCK)
                        ON   b.division_id = @p_division_id --'81'
                        AND  dbo.fn_scm_split(dbo.fn_scm_split(a.bod_id, 3, '::'), 1, '~') = b.plant_site_id 
                        AND  a.item_id  = b.item_id 
                        AND  (
                                ( a.start_dttm <= b.formation_start_date
                                AND  a.end_dttm   >  b.formation_start_date 
                                )
                                OR
                                ( a.start_dttm <= b.formation_end_date 
                                AND  a.end_dttm   >  b.formation_end_date 
                                )
                                OR
                                ( a.start_dttm >= b.formation_start_date 
                                  AND a.end_dttm <= b.formation_end_date
                                )
                            )
                WHERE a.master_id = @p_master_id        
                AND   a.plan_id   = @p_engine_plan_id   
                AND   a.descr = 'FORMATION_USE_Y'                
               ) x
        ;
		
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 5-2 END';
        SET @v_description = N'5-2. 분할대상 임시테이블생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        --------------------------------------------------------------------------------------------------------------------


        
        ---------------------------------------------------------------
        --5-3) formation yield 전체 대상 임시테이블에 생성
             --  참고1) th_eng_item_bod_cal.end_dttm          end_dttm미포함 => th_eng_item_bod_cal의 start_dttm( ex)20180501) ~ end_dttm( ex)20180512) 이라하면  20180501~20180511까지가 대상이다.)
             --      2) scp_mst_formation.formation_end_date  formation_end_date포함 => scp_mst_formation의 formation_start_date( ex)20180501) ~ formation_end_date( ex)20180512) 이라하면  20180501~20180512까지가 대상이다.)
        ---------------------------------------------------------------
        IF OBJECT_ID('tempdb..#TH_ENG_ITEM_BOD_CAL_ADD') IS NOT NULL
        BEGIN 
            DROP TABLE  #TH_ENG_ITEM_BOD_CAL_ADD           
        END
    
        SELECT  master_id
              , plan_id
              , item_id
              , bod_id
              , alt_priority
              , alt_rate
          
              , CASE WHEN gubun = 1 THEN start_dttm
                 
                     WHEN gubun = 2 AND start_dttm <= formation_start_date THEN formation_start_date  
                     WHEN gubun = 2 AND start_dttm > formation_start_date THEN start_dttm  

                     WHEN gubun = 3 THEN DATEADD(d, 1, formation_end_date) -- 포함시 DATEADD(d, 1, CONVERT(DATETIME,formation_end_date)) --확인 필요 (formation_end_date 까지 포함인지 미포함인지 확인필요함)
                END AS start_dttm
              , CASE WHEN gubun = 1 THEN formation_start_date
                 
                     WHEN gubun = 2 AND end_dttm > formation_end_date THEN DATEADD(d, 1, formation_end_date) -- 포함시 DATEADD(d, 1, CONVERT(DATETIME,formation_end_date)) --확인 필요 (formation_end_date 까지 포함인지 미포함인지 확인필요함)  
                     WHEN gubun = 2 AND end_dttm <= formation_end_date THEN end_dttm  -- 포함시 DATEADD(d, 1, CONVERT(DATETIME,formation_end_date)) --확인 필요 (formation_end_date 까지 포함인지 미포함인지 확인필요함)  
                 
                     WHEN gubun = 3 AND row_num <> cnt THEN next_formation_start_date 
                     WHEN gubun = 3 AND row_num =  cnt THEN end_dttm 
          
                END AS end_dttm
          
              , transfer_lot_size
              , is_prev_lot_size
              , is_pull
              , pre_buffer_time
              , post_buffer_time
              , buffer_time_uom
              , is_use
              , route_selector_id
              , safety_stock_term
              , safety_stock_term_uom
              , safety_stock_qty
              , descr
              , early_producing_term
              , early_producing_term_uom
              , CASE WHEN gubun = 1 THEN yield 
                     WHEN gubun = 2 THEN formation_total_yield 
                     WHEN gubun = 3 THEN yield 
                END yield

        INTO  #TH_ENG_ITEM_BOD_CAL_ADD

        FROM (
                SELECT *
                FROM  #DIV_TH_ENG_ITEM_BOD_CAL a
                    , (SELECT 1 gubun UNION ALL SELECT 2 UNION ALL SELECT 3) b
                WHERE (
                        ( gubun = 1 AND  row_num =1 AND start_date_diff > 0)
                        OR
                        ( gubun = 2)
                        OR
                        ( gubun = 3 AND end_date_diff > 1 AND ISNULL(formation_enddate_nextstartdate_diff, 99) <> 1)                    
                      )
             ) x
        ; 
		
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 5-3 END';
        SET @v_description = N'5-3. formation yield 전체 대상 임시테이블에 생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        --------------------------------------------------------------------------------------------------------------------

        ---------------------------------------------------------------
        --5-4) 전체 INSERT         
        ---------------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_ITEM_BOD_CAL */ th_eng_item_bod_cal_sn --테이블 컬럼 확인(ODS 테이블정의서의 컬럼목록과 비교(사용여부도 확인))
        (   master_id
            , plan_id
            , item_id
            , bod_id
            , alt_priority
            , alt_rate
            , start_dttm
            , end_dttm
            , transfer_lot_size
            , is_prev_lot_size
            , is_pull
            , pre_buffer_time
            , post_buffer_time
            , buffer_time_uom
            , is_use
            , route_selector_id
            , safety_stock_term
            , safety_stock_term_uom
            , safety_stock_qty
            , descr
            , early_producing_term
            , early_producing_term_uom
            , yield
        )
        SELECT master_id
             , plan_id
             , item_id
             , bod_id
             , alt_priority
             , alt_rate
             , start_dttm
             , end_dttm
             , transfer_lot_size
             , is_prev_lot_size
             , is_pull
             , pre_buffer_time
             , post_buffer_time
             , buffer_time_uom
             , is_use
             , route_selector_id
             , safety_stock_term
             , safety_stock_term_uom
             , safety_stock_qty
             , descr
             , early_producing_term
             , early_producing_term_uom
             , yield
        FROM   (   
                   --  scp_mst_formation_except 비대상 데이터
                   SELECT * 
                   FROM   #TH_ENG_ITEM_BOD_CAL_TEMP2 a
                   WHERE  NOT EXISTS ( SELECT 1
                                       FROM   
                                            ( SELECT DISTINCT master_id, plan_id, item_id, bod_id, start_dttm 
                                                FROM #DIV_TH_ENG_ITEM_BOD_CAL
                                            ) x
                                       WHERE x.master_id = a.master_id 
                                       AND   plan_id   = a.plan_id 
                                       AND   item_id   = a.item_id
                                       AND   bod_id    = a.bod_id
                                       AND   start_dttm = a.start_dttm
                                       ) 
                   UNION ALL

                   -- scp_mst_formation_except 대상(start_dttm, end_dttm 분할된 신규데이터)
                   SELECT * FROM #TH_ENG_ITEM_BOD_CAL_ADD
               ) xx
        ;
		
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 5-4 END';
        SET @v_description = N'5-4. INSERT ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        --------------------------------------------------------------------------------------------------------------------

		--2021.06.07 추가
        ---------------------------------------------------------------
        --5-5) PST 이전 데이터 삭제   
        ---------------------------------------------------------------
		DELETE th_eng_item_bod_cal_sn
		WHERE 1=1
		  AND master_id = @p_master_id
		  AND plan_id = @p_engine_plan_id
		  AND end_dttm <= @d_plan_name		--Plan 시작일
		;
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 5-5 END';
        SET @v_description = N'5-5. DELETE ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        --------------------------------------------------------------------------------------------------------------------


        -----------------------------------------------------------
        -- 임시테이블 삭제
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#TH_ENG_ITEM_BOD_CAL') IS NOT NULL
        BEGIN 
            DROP TABLE  #TH_ENG_ITEM_BOD_CAL
        END

        IF OBJECT_ID('tempdb..#SCP_MST_BOD_ITEM_EXCEPT') IS NOT NULL
        BEGIN 
            DROP TABLE  #SCP_MST_BOD_ITEM_EXCEPT
        END
        
        IF OBJECT_ID('tempdb..#TH_ENG_ITEM_BOD_CAL_SHIPPERIOD') IS NOT NULL
        BEGIN 
            DROP TABLE  #TH_ENG_ITEM_BOD_CAL_SHIPPERIOD          
        END

        IF OBJECT_ID('tempdb..#TH_ENG_ITEM_BOD_CAL_TEMP') IS NOT NULL
        BEGIN 
            DROP TABLE  #TH_ENG_ITEM_BOD_CAL_TEMP          
        END

        IF OBJECT_ID('tempdb..#TH_ENG_ITEM_BOD_CAL_TEMP2') IS NOT NULL
        BEGIN 
            DROP TABLE  #TH_ENG_ITEM_BOD_CAL_TEMP2          
        END
        
        IF OBJECT_ID('tempdb..#DIV_TH_ENG_ITEM_BOD_CAL') IS NOT NULL
        BEGIN 
            DROP TABLE  #DIV_TH_ENG_ITEM_BOD_CAL          
        END
                 
        IF OBJECT_ID('tempdb..#TH_ENG_ITEM_BOD_CAL_ADD') IS NOT NULL
        BEGIN 
            DROP TABLE  #TH_ENG_ITEM_BOD_CAL_ADD           
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
