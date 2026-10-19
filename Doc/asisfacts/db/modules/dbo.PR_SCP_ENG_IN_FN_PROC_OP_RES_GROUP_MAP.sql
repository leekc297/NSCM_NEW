
/*
 * Program ID   : PR_SCP_ENG_IN_FN_PROC_OP_RES_GROUP_MAP
 * Description  : ODB의 Op Res Group Map 정보를 ODB에 적재되도록 한다.
 
                  -----------------------------------------------------------
                  -- 1. Capa 비대상 / 라인 모델링 비대상
                  -----------------------------------------------------------
                        -  대상 : th_eng_op_res_group_sn.descr = 'NO_CAPA'                         
                        -  컬럼1) tact_time :  0.0000000001 셋팅(티라요청사항)
                           컬럼2) yield     :  - 셀공정일때   : 1 셋팅
                                               - 셀공정아닐때 : 값1) (FP yield) => FP yield 값의 평균값사용( eng_scm_site_id, flow_id, division_id, plant_id, item_id GROUP BY 평균값 사용함 (참고) CAPA비대상일경우line_id가 존재하지 않으므로 AVG값 사용함)
                                                                값2) (SCP yield) => 값1 미존재시 SCP yield 값의 MIN값사용( division_id, plant_site_id, item_id, operation_id GROUP BY MIN값 사용함 (참고) CAPA비대상일경우line_id가 존재하지 않으므로 AVG값 사용함)
                                                                값3) (th_eng_op_res_group_sn.yield) => 값1, 값2 미존재시 1 셋팅(th_eng_op_res_group_sn.yield이 1로 하드코딩되어있음)
                           컬럼3) is_first_setup : 'N' 셋팅
                           컬럼4) descr          : th_eng_op_res_group_sn.descr 값셋팅
                  -----------------------------------------------------------
                  -- 2.1 CAPA : 라인 모델링 비대상 : FP Tact Time 사용
                  -- (참고 : 2.1은 실행하지 않아도 됨, 현재 CAPA공정이면 모두 라인모델링대상 공정만 존재하므로 라인모델링비대상 데이터는 존재하지 않는다. 차후 CAPA공정이면서 라인모델링비대상 데이터 존재할때를 대비해서 생성하였음) 
                  -----------------------------------------------------------
                        -  대상 : th_eng_op_res_group_sn.descr = 'CAPA'이면서 "FP tact time 존재건"                        
                        -  컬럼1) tact_time : [FP tact time] * [ISNULL(FP yield, ISNULL(SCP yield, th_eng_op_res_group_sn.yield))] (참고)th_eng_op_res_group_sn.yield 값은 1로 하드코딩되어있음
                                              ==> FP tact time : 팩,셀은 당월(플랜시작일의 yyyymm사용) scm_mst_tact_time_ver_h_v.daily_capa (daily_capa :하루 생산가능 수량)컬럼값사용함
                                                                 "tact time" 은 1개생산시 걸리는 시간(단위 : 초) 이므로 
                                                                 ==> ROUND(86400(초) / ISNULL(daily_capa,0),3) (소숫점4째자리에서 반올림처리함)
                           컬럼2) yield     :  [ISNULL(FP yield, ISNULL(SCP yield, th_eng_op_res_group_sn.yield))] (참고)th_eng_op_res_group_sn.yield 값은 1로 하드코딩되어있음
                                               ==>값1) (FP yield) => FP yield 값의 평균값사용( eng_scm_site_id, flow_id, division_id, plant_id, item_id GROUP BY 평균값 사용함 (참고) CAPA비대상일경우line_id가 존재하지 않으므로 AVG값 사용함)
                                               ==>값2) (SCP yield) => 값1 미존재시 SCP yield 값의 MIN값사용( division_id, plant_site_id, item_id, operation_id GROUP BY MIN값 사용함 (참고) CAPA비대상일경우line_id가 존재하지 않으므로 AVG값 사용함)
                                               ==>값3) (th_eng_op_res_group_sn.yield) => 값1, 값2 미존재시 1 셋팅(th_eng_op_res_group_sn.yield이 1로 하드코딩되어있음)
                           컬럼3) is_first_setup : 'N' 셋팅
                           컬럼4) descr          : th_eng_op_res_group_sn.descr 값셋팅

                        -  참고테이블1) scm_mst_tact_time_ver_h_v : FP tact time정보
                           참고테이블2) scm_mst_yield_ver_h_v     : FP yield 정보
                           참고테이블3) scp_mst_tact_time    : SCP tact time, SCP yield 정보
                  -----------------------------------------------------------
                  -- 2.2 CAPA : 라인 모델링 비대상 : SCP 정보 사용
                  -- (참고 : 2.2는 실행하지 않아도 됨, 현재 CAPA공정이면 모두 라인모델링대상 공정만 존재하므로 라인모델링비대상 데이터는 존재하지 않는다. 차후 CAPA공정이면서 라인모델링비대상 데이터 존재할때를 대비해서 생성하였음) 
                  -----------------------------------------------------------
                        -  대상 : th_eng_op_res_group_sn.descr = 'CAPA'이면서  "2.1 에서 생성된 데이터 제외한 데이터중 SCP tact time 존재건"                        
                        -  컬럼1) tact_time : [SCP tact time] * [ISNULL(FP yield, ISNULL(SCP yield, th_eng_op_res_group_sn.yield))] (참고)th_eng_op_res_group_sn.yield 값은 1로 하드코딩되어있음
                           컬럼2) yield     :  [ISNULL(FP yield, ISNULL(SCP yield, th_eng_op_res_group_sn.yield))] (참고)th_eng_op_res_group_sn.yield 값은 1로 하드코딩되어있음
                                               ==>값1) (FP yield) => FP yield 값의 평균값사용( eng_scm_site_id, flow_id, division_id, plant_id, item_id GROUP BY 평균값 사용함 (참고) CAPA비대상일경우line_id가 존재하지 않으므로 AVG값 사용함)
                                               ==>값2) (SCP yield) => 값1 미존재시 SCP yield 값의 MIN값사용( division_id, plant_site_id, item_id, operation_id GROUP BY MIN값 사용함 (참고) CAPA비대상일경우line_id가 존재하지 않으므로 AVG값 사용함)
                                               ==>값3) (th_eng_op_res_group_sn.yield) => 값1, 값2 미존재시 1 셋팅(th_eng_op_res_group_sn.yield이 1로 하드코딩되어있음)
                           컬럼3) is_first_setup : 'N' 셋팅
                           컬럼4) descr          : th_eng_op_res_group_sn.descr 값셋팅
                  
                        -  참고테이블1) scm_mst_tact_time_ver_h_v : FP tact time정보
                           참고테이블2) scm_mst_yield_ver_h_v     : FP yield 정보
                           참고테이블3) scp_mst_tact_time    : SCP tact time, SCP yield 정보
                  -----------------------------------------------------------
                  -- 3.1 OSP : Line Capa 비대상
                  -----------------------------------------------------------
                        -  대상 : th_eng_op_res_group_sn.descr = 'OSP'
                        -  컬럼1) tact_time : 0 셋팅 (참고) PROC_PRODUCT_MIX 사용시 0 설정함 
                           컬럼2) yield     : 1 셋팅 
                           컬럼3) is_first_setup : 'N' 셋팅
                           컬럼4) descr          : th_eng_op_res_group_sn.descr 값셋팅
                  -----------------------------------------------------------
                  -- 3.2 OSP_L : Line Capa 대상
                  -----------------------------------------------------------
                        -  대상 : th_eng_op_res_group_sn.descr = 'OSP_L'
                        -  컬럼1) tact_time : scp_mst_tact_time_osp 정보 사용
                           컬럼2) yield     : scp_mst_tact_time_osp 정보 사용(NULL 이면 1 처리)
                           컬럼3) is_first_setup : 'N' 셋팅
                           컬럼4) descr          : th_eng_op_res_group_sn.descr 값셋팅
                  -----------------------------------------------------------
                  -- 4.1 라인 모델링 대상 : Item이 Assign 된 Line 정보 연결 : FP Tact Time 사용
                  -----------------------------------------------------------
                        -  대상 : th_eng_op_res_group_sn.descr = 'LINE_CAPA'이면서 "FP tact time 존재건"                        
                        -  컬럼1) tact_time : [FP tact time] * [ISNULL(FP yield, ISNULL(SCP yield, th_eng_op_res_group_sn.yield))] (참고)th_eng_op_res_group_sn.yield 값은 1로 하드코딩되어있음
                                              ==> FP tact time : 팩,셀은 당월(플랜시작일의 yyyymm사용) scm_mst_tact_time_ver_h_v.daily_capa (daily_capa :하루 생산가능 수량)컬럼값사용함
                                                                 "tact time" 은 1개생산시 걸리는 시간(단위 : 초) 이므로 
                                                                 ==> ROUND(86400(초) / ISNULL(daily_capa,0),3) (소숫점4째자리에서 반올림처리함)
                           컬럼2) yield     :  [ISNULL(FP yield, ISNULL(SCP yield, th_eng_op_res_group_sn.yield))] (참고)th_eng_op_res_group_sn.yield 값은 1로 하드코딩되어있음
                                               ==>값1) (FP yield) => FP yield 값사용
                                               ==>값2) (SCP yield) => 값1 미존재시 SCP yield 값사용
                                               ==>값3) (th_eng_op_res_group_sn.yield) => 값1, 값2 미존재시 1 셋팅(th_eng_op_res_group_sn.yield이 1로 하드코딩되어있음)
                           컬럼3) is_first_setup : 'N' 셋팅
                           컬럼4) descr          : th_eng_op_res_group_sn.descr 값셋팅

                        -  참고테이블1) scm_mst_tact_time_ver_h_v : FP tact time정보
                           참고테이블2) scm_mst_yield_ver_h_v     : FP yield 정보
                           참고테이블3) scp_mst_tact_time    : SCP tact time, SCP yield 정보
                  -----------------------------------------------------------
                  -- 4.2 라인 모델링 대상 : Item이 Assign 된 Line 정보 연결 : SCP 정보 사용
                  -----------------------------------------------------------
                         -  대상 : th_eng_op_res_group_sn.descr = 'LINE_CAPA'이면서 "4.1에서 생성된 데이터를 제외한 데이터중 SCP tact time 존재건"                        
                         -  컬럼1) tact_time : [SCP tact time] * [ISNULL(FP yield, ISNULL(SCP yield, th_eng_op_res_group_sn.yield))] (참고)th_eng_op_res_group_sn.yield 값은 1로 하드코딩되어있음
                            컬럼2) yield     :  [ISNULL(FP yield, ISNULL(SCP yield, th_eng_op_res_group_sn.yield))] (참고)th_eng_op_res_group_sn.yield 값은 1로 하드코딩되어있음
                                                ==> 값1) (FP yield) => FP yield 값사용
                                                ==> 값2) (SCP yield) => 값1 미존재시 SCP yield 값사용
                                                ==> 값3) (th_eng_op_res_group_sn.yield) => 값1, 값2 미존재시 1 셋팅(th_eng_op_res_group_sn.yield이 1로 하드코딩되어있음)
                            컬럼3) is_first_setup : 'N' 셋팅
                            컬럼4) descr          : th_eng_op_res_group_sn.descr 값셋팅

                         -  참고테이블1) scm_mst_tact_time_ver_h_v : FP tact time정보
                            참고테이블2) scm_mst_yield_ver_h_v     : FP yield 정보
                            참고테이블3) scp_mst_tact_time    : SCP tact time, SCP yield 정보
                  -----------------------------------------------------------
                  --(현재사용안함) 5.1 JIG 대상일때 sub_resource_map_id UPDATE
                  -----------------------------------------------------------
                          - "JIG  정보(scp_mst_jig)"가 있는 "JIG item 정보(scp_mst_jig_item)" 중 th_eng_op_res_group_map_sn과 일치하는 item, operation_id, plant site가 있을경우 
                             th_eng_op_res_group_map.sub_resource_map_id  = th_eng_op_res_group_map.resource_map_id + '_JIG' 로 UPDATE처리
                             
                          - 참고테이블1) scp_mst_jig : JIG 정보
                          - 참고테이블2) scp_mst_jig_item :JIG item 정보
                  -----------------------------------------------------------
                  --(현재사용안함) 5.2 JIG 대상 INSERT
                  -----------------------------------------------------------
                          - th_eng_op_res_group_map.sub_resource_map_id 컬럼에 resource_map_id + '_JIG'형태 값존재하는 item에 대해서 INSERT  (참고) 위5.1에서 UPDATE된(sub_resource_map_id IS NOT NULL, resource_map_id + '_JIG'형태의 값이있는경우)  데이터
                          -컬럼1) resource_map_id    : th_eng_op_res_group_map_sn.resource_map_id + '_JIG'
                          -컬럼2) resource_group_id  : scp_mst_jig.operation_id + '::' + scp_mst_jig.scm_site_id + '~***' + '::' + CONVERT(NVARCHAR(10), scp_mst_jig.jig_seq) 
                          -컬럼3) resource_map_level : 2  셋팅
                          -컬럼4) descr              : 'JIG' 셋팅

 * OutTable     : TH_ENG_OP_RES_GROUP_MAP
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.01.18   KSW            전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.05.31   KSG            Product Mix 사용에 따른 OSP 정보 수정
 * 2018.07.23   KSW            CAPA 비대상일때 tact_time 0을 0.0000000001 로 변경
 * 2018.09.28   KSW            전극 tact_time 계산시 사용되는 lane_qty 컬럼 대상 테이블 변경(scm_mst_item_lane_m_sn.lane_qty -> scm_mst_item_line_assign_sn.lane_qty)  참고) 주석2-1, 주석4-1
 * 2018.10.04   KSW            operation_id 조회조건 수정(참고)주석1
 * 2018.10.31   KSW            JIG 처리 추가 (참고)주석5 전체
 * 2018.12.13   KSW            속도개선 : 조인힌트적용 (참고)주석4.1
 * 2019.01.24   KSW            1) CAPA 비대상 셀공정 yield값 1로 셋팅 (참고)주석1
                               2) NOT IN문을 NOT EXISTS로 변경 (참고)주석2.2, 주석4.2
 * 2019.10.21   KSG            [IT서비스 요청번호:G20191025_000509] [CSR]GSCM 생산라인 우선순위 Logic 적용 요청
                               '라인 모델링 대상' Line 우선 순위 적용 : Input은 전 사업부 생성 => 엔진 설정으로 소형사업부만 적용함 : Default = '99'
 * 2020.02.06   KSG            [OSP Line Plan] OSP이면서 Line별 Capa 적용 Site 구분자 추가
 * 2020.11.02   KSG            PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : RACK
 * 2021.03.12   KSG            PJ20209642 Digital SCM Level.3 달성을 위한 개선 : FP Tact Time/Yield Table 변경
 * 2023.08.08   SHS            PJ20230692 SCM 역량 강화 위한 SCP 개선과제 이행 Phase2 : 소형CAPA 분리 & 로직 튜닝
 * 2023.10.10   KKC            PJ20230692 SCM 역량 강화 위한 SCP 개선과제 이행 Phase2 : 소형CAPA 분리 & TACT TIME 계산시 소숫점 3자리 절삭 처리 보완
 *
 */

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_IN_FN_PROC_OP_RES_GROUP_MAP]
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_IN_FN_PROC_OP_RES_GROUP_MAP';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'TH_ENG_OP_RES_GROUP_MAP';
    DECLARE @d_event_date   DATETIME;

    DECLARE @n_pre_plan_id       INTEGER = 0;
    DECLARE @n_cur_plan_id       INTEGER = 0;
    DECLARE @n_pre_week_plan_id  INTEGER = 0;
    DECLARE @n_cur_week_plan_id  INTEGER = 0;
    --DECLARE @v_division_id       NVARCHAR(30);
    --DECLARE @v_cur_monday        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    DECLARE @d_plan_name         DATETIME;

  -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN
		
		DELETE /* PR_SCP_ENG_IN_FN_PROC_OP_RES_GROUP_MAP */
		FROM   th_eng_op_res_group_map_sn
		WHERE  master_id = @p_master_id 
		AND    plan_id   = @p_engine_plan_id 
		;
        -----------------------------------------------------------
        -----------------------------------------------------------
        --3-0)  소형CAPA분리를 포함한 임시테이블 생성, 2023.08.08 Start ~
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#scm_mst_fp_tact_time_temp') IS NOT NULL
        BEGIN 
            DROP TABLE  #scm_mst_fp_tact_time_temp;          
        END 

        SELECT t.division_id
             , t.plant_id
             , t.eng_scm_site_id
             , op.flow_id
             , t.line_id
             , t.item_id
             , t.month                   AS yyyymm
             , MAX(t.operation_id)       AS operation_id
             , MAX(t.operation_group_id) AS operation_group_id
             , SUM(t.tact_time)          AS org_tact_time  
             , SUM(t.tact_time)          AS tact_time  
        INTO #scm_mst_fp_tact_time_temp
        FROM
        (
        SELECT t.division_id
                , t.company_id
                , t.site_id
                , t.operation_id
                , CASE WHEN SUBSTRING(t.operation_id, 1, 1) = 'E' THEN 'E'
                    WHEN SUBSTRING(t.operation_id, 1, 1) = 'S' THEN 'E' -- SRS => 전극
                    WHEN SUBSTRING(t.operation_id, 1, 1) = 'A' THEN 'A'
                    WHEN SUBSTRING(t.operation_id, 1, 1) = 'F' THEN 'A' -- 활성화 => CELL
                    WHEN SUBSTRING(t.operation_id, 1, 1) = 'P' THEN 'P'
                END
                    AS operation_group_id
                , CASE WHEN SUBSTRING(t.operation_id, 1, 1) = 'E' THEN t.plant_id + '-E~***'
                    WHEN SUBSTRING(t.operation_id, 1, 1) = 'S' THEN t.plant_id + '-E~***' -- SRS => 전극
                    WHEN SUBSTRING(t.operation_id, 1, 1) = 'A' THEN t.plant_id + '-A~***'
                    WHEN SUBSTRING(t.operation_id, 1, 1) = 'F' THEN t.plant_id + '-A~***' -- 활성화 => CELL
                    WHEN SUBSTRING(t.operation_id, 1, 1) = 'P' THEN t.plant_id + '-P~***'
                END  AS eng_scm_site_id
                , t.plant_id
                , t.line_id
                , t.item_id
                , t.month    -- Tact Time 존재 구간
                , t.tact_time
                , ROW_NUMBER() OVER (PARTITION BY t.plant_id, t.operation_id, t.line_id, t.item_id ORDER BY t.month ) row_num 
            FROM dbo.scm_mst_tact_time_ver_h_v t WITH (NOLOCK)
           WHERE t.division_id  = @p_division_id        --40 
             /* FP Tact Time 관리 기간 기준 (M0~M1) */ 
             AND t.month       >= LEFT(@p_plan_name,6)  
             AND t.month       <= CONVERT(NVARCHAR(6), DATEADD(m, 1, CONVERT(DATETIME,LEFT(@p_plan_name, 6) + '01')), 112) 
             AND t.tact_time   > 0
             --AND t.item_id = 'AAEH1072I-A1-200'
             AND t.operation_id IN ( SELECT b.segment2 AS operation_id
  			  			              FROM scm_adm_lookup_master_detail a WITH(NOLOCK)
  			  			             INNER JOIN scm_adm_lookup_master_detail b WITH(NOLOCK)
  			  			                ON a.segment1    = b.segment1
  			  			               AND a.lookup_type = 'LOCATION_GROUP'
  			  			               AND a.segment4    = 'Y'      -- Capa 공정 여부 
  			  			             --AND a.segment5    = 'Y'      -- Line 별 Capa 적용 공정( Capa공정여부가 'N'이면  Line 별 Capa 적용 공정이 'Y'가 될수없음)
  			  			               AND a.valid_yn    = 'Y'
  			  			               AND b.lookup_type = 'LOCATION_GROUP_ROUTE'
  			  			               AND b.valid_yn    = 'Y'
  			  			             --AND b.segment3    = 'Y' -- Capa 세부 공정 여부  (P5000 공정을 포함하기 위해 주석) 
                                       AND a.segment3 IN ('A', 'P') -- 전극공정 제외
                                )              
        ) t
        JOIN scm_mst_operation_flow_v op WITH(NOLOCK)
        ON t.division_id  = op.division_id
        AND t.company_id   = op.company_id
        AND t.site_id      = op.site_id
        AND t.operation_id = op.operation_id
        WHERE t.row_num = 1
        --  AND t.item_id = 'MACM348015A1-D03'
        GROUP 
           BY t.division_id
            , t.company_id
            , t.site_id
            , t.plant_id
            , t.eng_scm_site_id
            , op.flow_id
            , t.line_id
            , t.item_id
            , t.month
        ;

        --2. SCP 소형 CAPA 관리 기준으로 UPDATE
        UPDATE a
           SET a.tact_time  = b.tact_time
          FROM #scm_mst_fp_tact_time_temp a WITH(NOLOCK)
          JOIN (
              SELECT b.division_id
                   , b.plant_id
                   , b.operation_id
                   , b.item_id
                   , b.line_id
                   , b.yyyymm
                     /* SCP Daily Capa 수량을 Tact Time(Sec)으로 변환 */
                   --, ROUND((60 * 60 * 24)/b.value, 3)  AS tact_time
                   , ROUND((60 * 60 * 24)/b.value, 3, 1) AS tact_time  --소숫점 3자리 절삭값으로, 2023.10.10 수정
                   , b.value                             AS daily_capa
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

        --3. FP기준 공통 Yield정보 생성
        IF OBJECT_ID('tempdb..#scm_mst_fp_yield_temp') IS NOT NULL
        BEGIN 
            DROP TABLE  #scm_mst_fp_yield_temp;          
        END 

        SELECT CASE WHEN SUBSTRING(op.flow_id, 1, 1) = 'E' THEN t.plant_id + '-E~***'
                    WHEN SUBSTRING(op.flow_id, 1, 1) = 'S' THEN t.plant_id + '-E~***' -- SRS => 전극
                    WHEN SUBSTRING(op.flow_id, 1, 1) = 'A' THEN t.plant_id + '-A~***'
                    WHEN SUBSTRING(op.flow_id, 1, 1) = 'F' THEN t.plant_id + '-A~***' -- 활성화 => CELL
                    WHEN SUBSTRING(op.flow_id, 1, 1) = 'P' THEN t.plant_id + '-P~***'
                END  AS eng_scm_site_id
            , op.flow_id
            , t.division_id
            , t.plant_id
            , t.line_id
            , t.item_id
            , t.month    -- yield 존재 구간
            -- 수율 0 또는 NULL은 1로 처리함
            , MIN(CASE WHEN t.yield <= 0 THEN 1
                        WHEN t.yield > 1 THEN 1
                        ELSE ISNULL(t.yield, 1)
                    END
                    ) AS yield -- 누적수율은 곱해야 하나 일단 MIN 값으로 처리함  
         INTO #scm_mst_fp_yield_temp 
         FROM dbo.scm_mst_yield_ver_h_v t     WITH (NOLOCK)    -- PJ20209642 변경  scm_mst_yield_sn
         JOIN dbo.scm_mst_operation_flow_v op WITH(NOLOCK)
           ON t.division_id  = op.division_id
          AND t.company_id   = op.company_id
          AND t.site_id      = op.site_id
          AND t.operation_id = op.operation_id
		  /* 2025-10-24 ymh 개발에서만 임시 테스트 로직추가 시작 */
		inner hash join scm_mst_final_item_v as x with(nolock)
		on x.division_id = @p_division_id
		and x.operation_group_Id IN ('A', 'P')
		and t.item_id = x.item_id
		/* 2025-10-24 ymh 개발에서만 임시 테스트 로직추가 끝 */
        WHERE t.division_id  = @p_division_id 
          /* 원래As-Is 로직이 당월만 대상으로 함 */ 
          AND t.month        = LEFT(@p_plan_name,6)  
          /* 필요 데이터(계획 아이템)만 추출, 조건 추가, 2023.08.08 */
		  /* 2025-10-24 ymh 개발에서만 임시 테스트 */
		  /* 아래 주석처리 */
          /*
          AND t.item_id IN (SELECT x.item_id
                              FROM scm_mst_final_item_v x WITH(NOLOCK)
                             WHERE x.division_id = @p_division_id --40
                               AND x.operation_group_Id IN ('A', 'P')
                           )        
		  */
		  /* 위 주석처리 */
		  /* 2025-10-24 ymh 개발에서만 임시 테스트 */  
          /* 대상 CAPA 공정만 2023.08.08 */          
          AND t.operation_id IN (
                                 SELECT b.segment2 AS operation_id
  			  			           FROM scm_adm_lookup_master_detail a WITH(NOLOCK)
  			  			          INNER JOIN scm_adm_lookup_master_detail b WITH(NOLOCK)
  			  			             ON a.segment1    = b.segment1
  			  			            AND a.lookup_type = 'LOCATION_GROUP'
  			  			            AND a.segment4    = 'Y'      -- Capa 공정 여부 
  			  			          --AND a.segment5    = 'Y'      -- Line 별 Capa 적용 공정( Capa공정여부가 'N'이면  Line 별 Capa 적용 공정이 'Y'가 될수없음)
  			  			            AND a.valid_yn    = 'Y'
  			  			            AND b.lookup_type = 'LOCATION_GROUP_ROUTE'
  			  			            AND b.valid_yn    = 'Y'
                                  --AND b.segment3    = 'Y' -- Capa 세부 공정 여부  (P5000 공정을 포함하기 위해 주석)
                                    AND a.segment3 IN ('A', 'P') -- 전극공정 제외
                               )
        GROUP 
          BY 
             t.division_id
           , t.plant_id
           , op.flow_id
           , t.line_id
           , t.item_id
           , t.month
        ;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;  
        SET @v_log_type = 'TXN';
        SET @v_log_message = N'INSERT INTO : 0. [공통]FP T/T Yield Data Cutoff ';
        SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        -----------------------------------------------------------
        -- 1. Capa 비대상
        -----------------------------------------------------------
		INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_OP_RES_GROUP_MAP */ th_eng_op_res_group_map_sn
		(   master_id
		  , plan_id
          , site_id
		  , route_id
		  , operation_id
		  , item_id
		  , resource_map_id
          , resource_group_id
		  , sub_resource_map_id
		  , resource_map_level
          , alt_priority
		  , tact_time
		  , tact_time_uom
          , yield
		  , is_first_setup
          , good_rate
		  , batch_rate
		  , descr
		  , consume_res_rate
          , prepare_time
		  , prepare_time_uom
        )
        SELECT a.master_id
		     , a.plan_id
             , a.site_id
			 , a.route_id
			 , a.operation_id
			 , a.item_id
			 , a.resource_map_id
             , b.resource_group_id  AS resource_group_id
			 , NULL                 AS sub_resource_map_id
			 , a.resource_map_level
             , 99                   AS alt_priority -- 20191021 Line 우선 순위 적용 : NULL -> 99
             
             -- Capa 대상인 경우만 tact_time 등록 필요 나머지는 0
             , 0.0000000001         AS tact_time -- 20180723 수정(티라요청) (변경전 : , 0  AS tact_time)               
                
             , a.tact_time_uom      AS tact_time_uom 

             --20190124 수정 CAPA공정이 아닌 셀공정의 YIELD를 1로셋팅
             , CASE WHEN LEFT(a.operation_id, 1) = 'A' THEN 1
                    ELSE ISNULL(y.yield, ISNULL(smtt.yield, a.yield)) 
               END  AS yield   --20190124수정 (변경전 : , ISNULL(y.yield, ISNULL(smtt.yield, a.yield)) AS yield   --20180405 수정 ISNULL(FP 수율, ISNULL(scp 관리수율), 기본값)) 변경함 (변경전 : , ISNULL(y.yield, a.yield) AS yield ) )

			 , 'N'                  AS is_first_setup
             , NULL                 AS good_rate
			 , NULL                 AS batch_rate
			 , a.descr              AS descr
			 , NULL                 AS consume_res_rate
             , NULL                 AS prepare_time
			 , NULL                 AS prepare_time_uom
        FROM   th_eng_op_res_group_sn a WITH(NOLOCK)
               INNER JOIN (SELECT SUBSTRING(r.resource_group_id, dbo.FN_CHARINDEX_REV(r.resource_group_id, '::', 0)+2, 100) AS line_id
                                , r.*
                           FROM   th_eng_resource_sn r WITH(NOLOCK)
                           WHERE  r.master_id = @p_master_id
                           AND    r.plan_id   = @p_engine_plan_id
                          ) b
               ON   a.master_id = b.master_id
               AND  a.plan_id   = b.plan_id
               AND  a.site_id   = b.site_id
               AND  a.route_id  = b.route_id
               -- 라인 모델링 비대상 : yield
               LEFT OUTER JOIN   (
                                  /* 소형 CAPA 분리 & 튜닝, 2023.08.08 */
                                  SELECT tt.eng_scm_site_id
                                       , tt.flow_id
                                       , tt.division_id
                                       , tt.plant_id
                                       , '-' AS line_id
                                       , tt.item_id
                                       , AVG(tt.yield) AS yield
                                   FROM  #scm_mst_fp_yield_temp tt
                                  GROUP 
                                     BY tt.eng_scm_site_id, tt.flow_id, tt.division_id, tt.plant_id, tt.item_id
                                  /* org : ~ 2023.08.08
                                  SELECT tt.eng_scm_site_id
                                       , tt.flow_id
                                       , tt.division_id
                                       , tt.plant_id
                                       , '-' AS line_id
                                       , tt.item_id
                                       , AVG(tt.yield) AS yield
                                  FROM  (
                                         SELECT CASE WHEN SUBSTRING(op.flow_id, 1, 1) = 'E' THEN t.plant_id + '-E~***'
                                                     WHEN SUBSTRING(op.flow_id, 1, 1) = 'S' THEN t.plant_id + '-E~***' -- SRS => 전극
                                                     WHEN SUBSTRING(op.flow_id, 1, 1) = 'A' THEN t.plant_id + '-A~***'
                                                     WHEN SUBSTRING(op.flow_id, 1, 1) = 'F' THEN t.plant_id + '-A~***' -- 활성화 => CELL
                                                     WHEN SUBSTRING(op.flow_id, 1, 1) = 'P' THEN t.plant_id + '-P~***'
                                                END  AS eng_scm_site_id
                                              , op.flow_id
                                              , t.division_id
                                              , t.plant_id
                                              , t.line_id
                                              , t.item_id
                                              , t.month    -- yield 존재 구간
                                              -- 수율 0 또는 NULL은 1로 처리함                                 
                                              , MIN(CASE WHEN t.yield <= 0 THEN 1
                                                         WHEN t.yield > 1 THEN 1
                                                         ELSE ISNULL(t.yield, 1)
                                                    END
                                                   ) AS yield -- 누적수율은 곱해야 하나 일단 MIN 값으로 처리함
                                     
                                         FROM   dbo.scm_mst_yield_ver_h_v t WITH (NOLOCK)    -- PJ20209642 변경  scm_mst_yield_sn
                                              , dbo.scm_mst_operation_flow_v op WITH(NOLOCK)
	                                     WHERE  t.division_id  = @p_division_id
                                         AND    t.month        = SUBSTRING(@p_plan_name, 1, 6)
                                         AND    t.division_id  = op.division_id
                                         AND    t.company_id   = op.company_id
                                         AND    t.site_id      = op.site_id
                                         AND    t.operation_id = op.operation_id
                                         GROUP BY op.flow_id, t.division_id, t.plant_id, t.line_id, t.item_id, t.month
                                        ) tt
                                  GROUP BY tt.eng_scm_site_id, tt.flow_id, tt.division_id, tt.plant_id, tt.item_id
                                  */
                                  ) y
               ON   a.site_id  = y.eng_scm_site_id
               AND  a.route_id = y.flow_id
               AND  b.line_id  = y.line_id
               AND  a.item_id  = y.item_id

               --20180405 추가 SCP 관리 yield 정보
               LEFT JOIN ( SELECT division_id,  plant_site_id + '~***' AS eng_scm_site_id, item_id, operation_id
                              --,   AVG(ISNULL(tact_time,0))  AS tact_time
                              -- 수율 0 또는 NULL은 1로 처리함                                 
                              ,   MIN(CASE WHEN yield <= 0 THEN 1
                                           WHEN yield > 1 THEN 1
                                           ELSE ISNULL(yield, 1)
                                      END) AS yield      
                           FROM   scp_mst_tact_time WITH (NOLOCK)
                           WHERE  division_id = @p_division_id 
                           AND    valid_yn    = 'Y'
                           GROUP BY division_id, plant_site_id, item_id, operation_id                           
                         ) smtt
               ON  a.site_id      = smtt.eng_scm_site_id
               AND a.item_id      = smtt.item_id 
               AND a.operation_id LIKE smtt.operation_id + '%'  -- 20181004 수정 ( 변경전 : AND a.operation_id = smtt.operation_id )               
                             
        WHERE  a.master_id = @p_master_id
        AND    a.plan_id   = @p_engine_plan_id
        AND    a.descr     = 'NO_CAPA' -- Capa 비대상
        ;
		
        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;  
        SET @v_log_type = 'TXN';
        SET @v_log_message = N'INSERT INTO : 1. Capa 비대상';
        SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
        -- 2.1 CAPA : 라인 모델링 비대상 : FP Tact Time 사용
        -----------------------------------------------------------
		INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_OP_RES_GROUP_MAP */ th_eng_op_res_group_map_sn
		(   master_id
		  , plan_id
          , site_id
		  , route_id
		  , operation_id
		  , item_id
		  , resource_map_id
          , resource_group_id
		  , sub_resource_map_id
		  , resource_map_level
          , alt_priority
		  , tact_time
		  , tact_time_uom
          , yield
		  , is_first_setup
          , good_rate
		  , batch_rate
		  , descr
		  , consume_res_rate
          , prepare_time
		  , prepare_time_uom
        )
        SELECT a.master_id
		     , a.plan_id
             , a.site_id
			 , a.route_id
			 , a.operation_id
			 , a.item_id
			 , a.resource_map_id
             , b.resource_group_id  AS resource_group_id
			 , NULL                 AS sub_resource_map_id
			 , a.resource_map_level
             , 99                   AS alt_priority -- 20191021 Line 우선 순위 적용 : NULL -> 99
             
             -- Capa 대상인 경우만 tact_time 등록 필요 나머지는 0
			 -- Input용 Tact Time은 수율을 곱해서 적용함
             --, d.tact_time * ISNULL(y.yield, ISNULL(smtt.yield, a.yield))    -- 라인 모델링 비대상일때
             , ROUND(d.tact_time * ISNULL(y.yield, ISNULL(smtt.yield, a.yield)), 3, 1) -- 소숫점 3자리로 절삭 (엔진은 1/1000초로 시간계산), 2023.08.08 수정
                                    AS tact_time                                
             , a.tact_time_uom      AS tact_time_uom 

             , ISNULL(y.yield, ISNULL(smtt.yield, a.yield)) AS yield   --20180405 수정 ISNULL(FP 수율, ISNULL(scp 관리수율), 기본값)) 변경함 (변경전 : , ISNULL(y.yield, a.yield) AS yield )

			 , 'N'                  AS is_first_setup
             , NULL                 AS good_rate
			 , NULL                 AS batch_rate
			 , a.descr              AS descr
			 , NULL                 AS consume_res_rate
             , NULL                 AS prepare_time
			 , NULL                 AS prepare_time_uom
        FROM   th_eng_op_res_group_sn a WITH(NOLOCK)
               INNER JOIN (SELECT SUBSTRING(r.resource_group_id, dbo.FN_CHARINDEX_REV(r.resource_group_id, '::', 0)+2, 100) AS line_id
                                , r.*
                           FROM   th_eng_resource_sn r WITH(NOLOCK)
                           WHERE  r.master_id = @p_master_id
                           AND    r.plan_id   = @p_engine_plan_id
                          ) b
               ON   a.master_id = b.master_id
               AND  a.plan_id   = b.plan_id
               AND  a.site_id   = b.site_id
               AND  a.route_id  = b.route_id
               -- 라인 모델링 비대상 : tt
               INNER JOIN       ( 
	                              /* 소형CAPA분리 및 튜닝 2023.08.08 */ 
                                  SELECT tt.eng_scm_site_id
                                       , tt.flow_id
                                       , tt.division_id
                                       , tt.plant_id
                                       , '-' AS line_id
                                       , tt.item_id
                                       , AVG(tt.tact_time) AS tact_time
                                   FROM  #scm_mst_fp_tact_time_temp tt WITH(NOLOCK)
                                  WHERE  1=1 --tt.tact_time <> 0
                                  GROUP 
                                     BY tt.eng_scm_site_id
                                      , tt.flow_id
                                      , tt.division_id
                                      , tt.plant_id
                                      , tt.item_id               
                                  /* old
                                  SELECT tt.eng_scm_site_id
                                       , tt.flow_id
                                       , tt.division_id
                                       , tt.plant_id
                                       , '-' AS line_id
                                       , tt.item_id
                                       , AVG(tt.tact_time) AS tact_time
                                  FROM  (
                                         SELECT CASE WHEN SUBSTRING(op.flow_id, 1, 1) = 'E' THEN t.plant_id + '-E~***'
                                                     WHEN SUBSTRING(op.flow_id, 1, 1) = 'S' THEN t.plant_id + '-E~***' -- SRS => 전극
                                                     WHEN SUBSTRING(op.flow_id, 1, 1) = 'A' THEN t.plant_id + '-A~***'
                                                     WHEN SUBSTRING(op.flow_id, 1, 1) = 'F' THEN t.plant_id + '-A~***' -- 활성화 => CELL
                                                     WHEN SUBSTRING(op.flow_id, 1, 1) = 'P' THEN t.plant_id + '-P~***'
                                                END  AS eng_scm_site_id
                                              , op.flow_id
                                              , t.division_id
                                              , t.plant_id
                                              , t.line_id
                                              , t.item_id
                                              , t.month    -- Tact Time 존재 구간
                                              , SUM(ISNULL(t.tact_time, 0)) AS tact_time
                                              , ROW_NUMBER() OVER (PARTITION BY t.plant_id, op.flow_id, t.line_id, t.item_id ORDER BY t.month ) row_num
					      
                                         FROM   dbo.scm_mst_tact_time_ver_h_v t WITH (NOLOCK)    -- PJ20209642 변경  scm_mst_tact_time_sn

                                         INNER JOIN dbo.scm_mst_operation_flow_v op WITH(NOLOCK)
										 ON     t.division_id  = op.division_id
                                         AND    t.company_id   = op.company_id
                                         AND    t.site_id      = op.site_id
                                         AND    t.operation_id = op.operation_id										 
	                                     WHERE  t.division_id  = @p_division_id
                                         AND    t.month       >= SUBSTRING(@p_plan_name, 1, 6)
                                         GROUP BY op.flow_id, t.division_id, t.plant_id, t.line_id, t.item_id, t.month
                                         HAVING SUM(ISNULL(t.tact_time, 0)) > 0
                                        ) tt
                                  WHERE  1=1 --tt.tact_time <> 0
                                  AND    tt.row_num = 1
                                  GROUP BY tt.eng_scm_site_id, tt.flow_id, tt.division_id, tt.plant_id, tt.item_id
                                  */
                                ) d
               ON   a.site_id  = d.eng_scm_site_id
               AND  a.route_id = d.flow_id
               AND  b.line_id  = d.line_id
               AND  a.item_id  = d.item_id
               -- 라인 모델링 비대상 : yield
	          LEFT OUTER JOIN   (
                                  /* 소형CAPA분리 및 튜닝 2023.08.08 */ 
                                  SELECT tt.eng_scm_site_id
                                       , tt.flow_id
                                       , tt.division_id
                                       , tt.plant_id
                                       , '-'           AS line_id
                                       , tt.item_id
                                       , AVG(tt.yield) AS yield
                                   FROM  #scm_mst_fp_yield_temp tt
                                  GROUP 
                                     BY tt.eng_scm_site_id, tt.flow_id, tt.division_id, tt.plant_id, tt.item_id                                 
                                  /* org : ~ 2023.08.08
                                  SELECT tt.eng_scm_site_id
                                       , tt.flow_id
                                       , tt.division_id
                                       , tt.plant_id
                                       , '-' AS line_id
                                       , tt.item_id
                                       , AVG(tt.yield) AS yield
	                          FROM  (
                                         SELECT CASE WHEN SUBSTRING(op.flow_id, 1, 1) = 'E' THEN t.plant_id + '-E~***'
                                                     WHEN SUBSTRING(op.flow_id, 1, 1) = 'S' THEN t.plant_id + '-E~***' -- SRS => 전극
                                                     WHEN SUBSTRING(op.flow_id, 1, 1) = 'A' THEN t.plant_id + '-A~***'
                                                     WHEN SUBSTRING(op.flow_id, 1, 1) = 'F' THEN t.plant_id + '-A~***' -- 활성화 => CELL
                                                     WHEN SUBSTRING(op.flow_id, 1, 1) = 'P' THEN t.plant_id + '-P~***'
                                                END  AS eng_scm_site_id
                                              , op.flow_id
                                              , t.division_id
                                              , t.plant_id
                                              , t.line_id
                                              , t.item_id
                                              , t.month    -- yield 존재 구간
                                              -- 수율 0 또는 NULL은 1로 처리함                                 
                                              , MIN(CASE WHEN t.yield <= 0 THEN 1
                                                         WHEN t.yield > 1 THEN 1
                                                         ELSE ISNULL(t.yield, 1)
                                                    END
                                                   ) AS yield -- 누적수율은 곱해야 하나 일단 MIN 값으로 처리함         
                                         FROM   dbo.scm_mst_yield_ver_h_v t WITH (NOLOCK)    -- PJ20209642 변경  scm_mst_yield_sn 
                                              , dbo.scm_mst_operation_flow_v op WITH(NOLOCK)
	                                     WHERE  t.division_id  = @p_division_id
                                         AND    t.month        = SUBSTRING(@p_plan_name, 1, 6)
                                         AND    t.division_id  = op.division_id
                                         AND    t.company_id   = op.company_id
                                         AND    t.site_id      = op.site_id
                                         AND    t.operation_id = op.operation_id
                                         GROUP BY op.flow_id, t.division_id, t.plant_id, t.line_id, t.item_id, t.month
                                        ) tt
                                  GROUP BY tt.eng_scm_site_id, tt.flow_id, tt.division_id, tt.plant_id, tt.item_id
				                  */
                                 ) y
               ON   a.site_id  = y.eng_scm_site_id
               AND  a.route_id = y.flow_id
               AND  b.line_id  = y.line_id
               AND  a.item_id  = y.item_id    
               --20180405 추가 SCP 관리 yield 정보
               LEFT JOIN ( SELECT division_id,  plant_site_id + '~***' AS eng_scm_site_id, item_id, operation_id
                              --,   AVG(ISNULL(tact_time,0))  AS tact_time
                              -- 수율 0 또는 NULL은 1로 처리함                                 
                              ,   MIN(CASE WHEN yield <= 0 THEN 1
                                           WHEN yield > 1 THEN 1
                                           ELSE ISNULL(yield, 1)
                                      END) AS yield      
                           FROM scp_mst_tact_time WITH (NOLOCK)
                           WHERE division_id = @p_division_id
                           AND   valid_yn    = 'Y' 
                           GROUP BY division_id, plant_site_id, item_id, operation_id                           
                           ) smtt
               ON  a.site_id  = smtt.eng_scm_site_id
               AND a.item_id  = smtt.item_id 
               AND a.route_id LIKE smtt.operation_id + '%'                               
        WHERE  a.master_id = @p_master_id
        AND    a.plan_id   = @p_engine_plan_id
        AND    a.descr     = 'CAPA'  -- 라인 모델링 비대상
        ;
		
        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = N'INSERT INTO : 2.1 CAPA : 라인 모델링 비대상 : FP Tact Time 사용';
        SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
        -- 2.2 CAPA : 라인 모델링 비대상 : FP Tact Time 없는 경우 SCP 관리 정보 사용
        -----------------------------------------------------------
		INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_OP_RES_GROUP_MAP */ th_eng_op_res_group_map_sn
		(   master_id
		  , plan_id
          , site_id
		  , route_id
		  , operation_id
		  , item_id
		  , resource_map_id
          , resource_group_id
		  , sub_resource_map_id
		  , resource_map_level
          , alt_priority
		  , tact_time
		  , tact_time_uom
          , yield
		  , is_first_setup
          , good_rate
		  , batch_rate
		  , descr
		  , consume_res_rate
          , prepare_time
		  , prepare_time_uom
        )
        SELECT a.master_id
		     , a.plan_id
             , a.site_id
			 , a.route_id
			 , a.operation_id
			 , a.item_id
			 , a.resource_map_id
             , b.resource_group_id  AS resource_group_id
			 , NULL                 AS sub_resource_map_id
			 , a.resource_map_level
             , 99                   AS alt_priority -- 20191021 Line 우선 순위 적용 : NULL -> 99             
             -- Capa 대상인 경우만 tact_time 등록 필요 나머지는 0
			 -- Input용 Tact Time은 수율을 곱해서 적용함
             --, smtt.tact_time * ISNULL(y.yield, ISNULL(smtt.yield, a.yield))    -- 라인 모델링 비대상일때
             , ROUND(smtt.tact_time * ISNULL(y.yield, ISNULL(smtt.yield, a.yield)), 3,1)    --소숫점 3자리로 절삭 (엔진은 1/1000초로 시간계산), 2023.08.08 수정
                                    AS tact_time                
             , a.tact_time_uom      AS tact_time_uom 
             , ISNULL(y.yield, ISNULL(smtt.yield, a.yield)) AS yield   --20180405 수정 ISNULL(FP 수율, ISNULL(scp 관리수율), 기본값)) 변경함 (변경전 : , ISNULL(y.yield, a.yield) AS yield )
			 , 'N'                  AS is_first_setup
             , NULL                 AS good_rate
			 , NULL                 AS batch_rate
			 , a.descr              AS descr
			 , NULL                 AS consume_res_rate
             , NULL                 AS prepare_time
			 , NULL                 AS prepare_time_uom
        FROM   th_eng_op_res_group_sn a WITH(NOLOCK)
               INNER JOIN (SELECT SUBSTRING(r.resource_group_id, dbo.FN_CHARINDEX_REV(r.resource_group_id, '::', 0)+2, 100) AS line_id
                                , r.*
                           FROM   th_eng_resource_sn r WITH(NOLOCK)
                           WHERE  r.master_id = @p_master_id
                           AND    r.plan_id   = @p_engine_plan_id
                          ) b
               ON   a.master_id = b.master_id
               AND  a.plan_id   = b.plan_id
               AND  a.site_id   = b.site_id
               AND  a.route_id  = b.route_id
	       -- 라인 모델링 비대상 : yield
	       LEFT OUTER JOIN   (
	                          /* 소형CAPA분리 및 튜닝 2023.08.08 */ 
	                          SELECT tt.eng_scm_site_id
                                       , tt.flow_id
                                       , tt.division_id
                                       , tt.plant_id
                                       , '-' AS line_id
                                       , tt.item_id
                                       , AVG(tt.yield) AS yield
                                  FROM  #scm_mst_fp_yield_temp tt
                                  GROUP 
                                    BY tt.eng_scm_site_id, tt.flow_id, tt.division_id, tt.plant_id, tt.item_id                                  
                                  /* org : ~ 2023.08.08
                                  SELECT tt.eng_scm_site_id
                                       , tt.flow_id
                                       , tt.division_id
                                       , tt.plant_id
                                       , '-' AS line_id
                                       , tt.item_id
                                       , AVG(tt.yield) AS yield
                                  FROM  (
                                         SELECT CASE WHEN SUBSTRING(op.flow_id, 1, 1) = 'E' THEN t.plant_id + '-E~***'
                                                     WHEN SUBSTRING(op.flow_id, 1, 1) = 'S' THEN t.plant_id + '-E~***' -- SRS => 전극
                                                     WHEN SUBSTRING(op.flow_id, 1, 1) = 'A' THEN t.plant_id + '-A~***'
                                                     WHEN SUBSTRING(op.flow_id, 1, 1) = 'F' THEN t.plant_id + '-A~***' -- 활성화 => CELL
                                                     WHEN SUBSTRING(op.flow_id, 1, 1) = 'P' THEN t.plant_id + '-P~***'
                                                END  AS eng_scm_site_id
                                              , op.flow_id
                                              , t.division_id
                                              , t.plant_id
                                              , t.line_id
                                              , t.item_id
                                              , t.month    -- yield 존재 구간
                                              -- 수율 0 또는 NULL은 1로 처리함                                 
                                              , MIN(CASE WHEN t.yield <= 0 THEN 1
                                                         WHEN t.yield > 1 THEN 1
                                                         ELSE ISNULL(t.yield, 1)
                                                    END
                                                   ) AS yield -- 누적수율은 곱해야 하나 일단 MIN 값으로 처리함
                                         FROM   dbo.scm_mst_yield_ver_h_v t WITH (NOLOCK)    -- PJ20209642 변경  scm_mst_yield_sn
                                              , dbo.scm_mst_operation_flow_v op WITH(NOLOCK)
	                                     WHERE  t.division_id  = @p_division_id
                                         AND    t.month        = SUBSTRING(@p_plan_name, 1, 6)
                                         AND    t.division_id  = op.division_id
                                         AND    t.company_id   = op.company_id
                                         AND    t.site_id      = op.site_id
                                         AND    t.operation_id = op.operation_id
                                         GROUP BY op.flow_id, t.division_id, t.plant_id, t.line_id, t.item_id, t.month
                                        ) tt
                                  GROUP BY tt.eng_scm_site_id, tt.flow_id, tt.division_id, tt.plant_id, tt.item_id
                                  */
                                 ) y
               ON   a.site_id  = y.eng_scm_site_id
               AND  a.route_id = y.flow_id
               AND  b.line_id  = y.line_id
               AND  a.item_id  = y.item_id    
               --20180405 추가 SCP 관리 tact_time, yield 정보
               INNER JOIN (SELECT division_id,  plant_site_id + '~***' AS eng_scm_site_id, item_id, operation_id
                              ,   AVG(ISNULL(tact_time,0))  AS tact_time
                              -- 수율 0 또는 NULL은 1로 처리함                                 
                              ,   MIN(CASE WHEN yield <= 0 THEN 1
                                           WHEN yield > 1 THEN 1
                                           ELSE ISNULL(yield, 1)
                                      END) AS yield      
                           FROM scp_mst_tact_time WITH (NOLOCK)
                           WHERE division_id = @p_division_id
                           AND   valid_yn    = 'Y' 
                           GROUP BY division_id, plant_site_id, item_id, operation_id                           
                          ) smtt
               ON  a.site_id  = smtt.eng_scm_site_id
               AND a.item_id  = smtt.item_id 
               AND a.route_id LIKE smtt.operation_id + '%'                               
        WHERE  a.master_id = @p_master_id
        AND    a.plan_id   = @p_engine_plan_id
        AND    a.descr     = 'CAPA'  -- 라인 모델링 비대상
        AND     NOT EXISTS (SELECT 1
                            FROM  (SELECT master_id
                                       ,  plan_id 
                                       ,  site_id 
                                       ,  route_id
                                       ,  operation_id 
                                       ,  item_id 
                                       ,  resource_map_id
                                       ,  resource_group_id
                                   FROM   th_eng_op_res_group_map_sn WITH(NOLOCK)
                                   WHERE  master_id = @p_master_id
                                   AND    plan_id   = @p_engine_plan_id
                                   AND    descr     = 'CAPA'  -- 라인 모델링
                                  ) c
                            WHERE  a.master_id        = c.master_id 
                            AND  a.plan_id            = c.plan_id 
                            AND  a.site_id            = c.site_id 
                            AND  a.route_id           = c.route_id 
                            AND  a.operation_id       = c.operation_id 
                            AND  a.item_id            = c.item_id 
                            AND  a.resource_map_id    = c.resource_map_id 
                            AND  b.resource_group_id  = c.resource_group_id  )
        ;
		
        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = N'INSERT INTO : 2.2 CAPA : 라인 모델링 비대상 : FP Tact Time 없는 경우 SCP 관리 정보 사용';
        SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
        -- 3.1 OSP 
        -----------------------------------------------------------
		INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_OP_RES_GROUP_MAP */ th_eng_op_res_group_map_sn
		(   master_id
		  , plan_id
          , site_id
		  , route_id
		  , operation_id
		  , item_id
		  , resource_map_id
          , resource_group_id
		  , sub_resource_map_id
		  , resource_map_level
          , alt_priority
		  , tact_time
		  , tact_time_uom
          , yield
		  , is_first_setup
          , good_rate
		  , batch_rate
		  , descr
		  , consume_res_rate
          , prepare_time
		  , prepare_time_uom
        )
        SELECT a.master_id
		     , a.plan_id
             , a.site_id
			 , a.route_id
			 , a.operation_id
			 , a.item_id
			 , a.resource_map_id
             , b.resource_group_id  AS resource_group_id
			 , NULL                 AS sub_resource_map_id
			 , a.resource_map_level
             , 99                   AS alt_priority -- 20191021 Line 우선 순위 적용 : NULL -> 99
             
             , 0                    AS tact_time -- 2018.05.31 KSG Product Mix 사용 시 0 설정
             --, smtt.tact_time       AS tact_time                
             , a.tact_time_uom      AS tact_time_uom 

             , 1                    AS yield   --20180405 수정 ISNULL(FP 수율, ISNULL(scp 관리수율), 기본값)) 변경함 (변경전 : , ISNULL(y.yield, a.yield) AS yield )

			 , 'N'                  AS is_first_setup
             , NULL                 AS good_rate
			 , NULL                 AS batch_rate
			 , a.descr              AS descr
			 , NULL                 AS consume_res_rate
             , NULL                 AS prepare_time
			 , NULL                 AS prepare_time_uom
        FROM   th_eng_op_res_group_sn a WITH(NOLOCK)
               INNER JOIN (SELECT SUBSTRING(r.resource_group_id, dbo.FN_CHARINDEX_REV(r.resource_group_id, '::', 0)+2, 100) AS line_id
                                , r.*
                           FROM   th_eng_resource_sn r WITH(NOLOCK)
                           WHERE  r.master_id = @p_master_id
                           AND    r.plan_id   = @p_engine_plan_id
                          ) b
               ON   a.master_id = b.master_id
               AND  a.plan_id   = b.plan_id
               AND  a.site_id   = b.site_id
               AND  a.route_id  = b.route_id
			   
               --20180405 추가 SCP 관리 tact_time, yield 정보
               INNER JOIN (SELECT division_id,  plant_site_id + '~***' AS eng_scm_site_id, item_id
                                , ROUND((24 * 60 * 60) / AVG(CONVERT(FLOAT, daily_capa_qty)), 6) AS tact_time
                           FROM scp_mst_outsourcing_capa WITH (NOLOCK)
                           WHERE division_id    = @p_division_id
                           AND   valid_yn       = 'Y' 
                           AND   daily_capa_qty > 0
                           GROUP BY division_id, plant_site_id, item_id                           
                          ) smtt
               ON  a.site_id = smtt.eng_scm_site_id
               AND a.item_id = smtt.item_id                
                             
        WHERE  a.master_id = @p_master_id
        AND    a.plan_id   = @p_engine_plan_id
        AND    a.descr     = 'OSP' -- OSP 
        ;
		
        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = N'INSERT INTO : 3.1 OSP';
        SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
        -- 3.2 OSP_L : Line Capa 대상 
        -- 2020.02.03  [OSP Line Plan] OSP이면서 Line별 Capa 적용 Site 확정계획 추가
        -----------------------------------------------------------
		INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_OP_RES_GROUP_MAP */ th_eng_op_res_group_map_sn
		(   master_id
		  , plan_id
          , site_id
		  , route_id
		  , operation_id
		  , item_id
		  , resource_map_id
          , resource_group_id
		  , sub_resource_map_id
		  , resource_map_level
          , alt_priority
		  , tact_time
		  , tact_time_uom
          , yield
		  , is_first_setup
          , good_rate
		  , batch_rate
		  , descr
		  , consume_res_rate
          , prepare_time
		  , prepare_time_uom
        )
        SELECT a.master_id
		     , a.plan_id
             , a.site_id
			 , a.route_id
			 , a.operation_id
			 , a.item_id
			 , a.resource_map_id
             , b.resource_group_id  AS resource_group_id
			 , NULL                 AS sub_resource_map_id
			 , a.resource_map_level
             , ISNULL(smtt.priority, 99) AS alt_priority -- 20191021 Line 우선 순위 적용 : NULL -> ISNULL(smtt.priority, 99)
             
             -- Capa 대상인 경우만 tact_time 등록 필요 나머지는 0
			 -- Input용 Tact Time은 수율을 곱해서 적용함
             --, smtt.tact_time * ISNULL(smtt.yield, a.yield)
             , ROUND(smtt.tact_time * ISNULL(smtt.yield, a.yield), 3,1) -- 소숫점 3자리로 절삭 (엔진은 1/1000초로 시간 계산), 2023.08.08 수정
                                    AS tact_time

             , a.tact_time_uom      AS tact_time_uom 
             
             , ISNULL(smtt.yield, a.yield) AS yield 

             , 'N'                  AS is_first_setup
             , NULL                 AS good_rate
			 , NULL                 AS batch_rate
			 , a.descr              AS descr
			 , NULL                 AS consume_res_rate
             , NULL                 AS prepare_time
			 , NULL                 AS prepare_time_uom
        FROM   th_eng_op_res_group_sn a WITH(NOLOCK)
               INNER JOIN (SELECT SUBSTRING(r.resource_group_id, dbo.FN_CHARINDEX_REV(r.resource_group_id, '::', 0)+2, 100) AS line_id
                                , r.*
                           FROM   th_eng_resource_sn r WITH(NOLOCK)
                           WHERE  r.master_id = @p_master_id
                           AND    r.plan_id   = @p_engine_plan_id
                          ) b
               ON   a.master_id = b.master_id
               AND  a.plan_id   = b.plan_id
               AND  a.site_id   = b.site_id
               AND  a.route_id  LIKE b.route_id + '%'
             --  AND  a.route_id  = b.route_id

               -- SCP 관리 tact time/yield 정보
               INNER JOIN ( SELECT division_id, plant_site_id + '~***' AS eng_scm_site_id, item_id, operation_id, line_id
                              ,   priority -- 20191021 Line 우선 순위 적용
                              ,   tact_time
                              -- 수율 0 또는 NULL은 1로 처리함                                 
                              ,   (CASE WHEN yield <= 0 THEN 1
                                        WHEN yield > 1 THEN 1
                                        ELSE ISNULL(yield, 1)
                                   END) AS yield      
                           FROM   scp_mst_tact_time_osp WITH (NOLOCK)
                           WHERE  division_id = @p_division_id
                           AND    valid_yn    = 'Y'                            
                           ) smtt
               ON  a.site_id  = smtt.eng_scm_site_id
               AND a.item_id  = smtt.item_id 
               AND b.line_id  = smtt.line_id
               AND a.route_id = smtt.operation_id -- 20201102 PJ20202001
               --AND a.route_id LIKE smtt.operation_id + '%'

        WHERE  a.master_id = @p_master_id
        AND    a.plan_id   = @p_engine_plan_id
        AND    a.descr     = 'OSP_L' -- OSP Line Capa 대상
        ;
		
        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = N'INSERT INTO : 3.2 OSP_L : Line Capa 대상';
        SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
        -- 4.1 라인 모델링 대상 : Item이 Assign 된 Line 정보 연결 : FP 정보 사용
        -----------------------------------------------------------
		INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_OP_RES_GROUP_MAP */ th_eng_op_res_group_map_sn
		(   master_id
		  , plan_id
          , site_id
		  , route_id
		  , operation_id
		  , item_id
		  , resource_map_id
          , resource_group_id
		  , sub_resource_map_id
		  , resource_map_level
          , alt_priority
		  , tact_time
		  , tact_time_uom
          , yield
		  , is_first_setup
          , good_rate
		  , batch_rate
		  , descr
		  , consume_res_rate
          , prepare_time
		  , prepare_time_uom
        )
        SELECT a.master_id
		     , a.plan_id
             , a.site_id
			 , a.route_id
			 , a.operation_id
			 , a.item_id
			 , a.resource_map_id
             , b.resource_group_id  AS resource_group_id
			 , NULL                 AS sub_resource_map_id
			 , a.resource_map_level
             , ISNULL(smtt.priority, 99) AS alt_priority -- 20191021 Line 우선 순위 적용 : NULL -> ISNULL(smtt.priority, 99)
             
             -- Capa 대상인 경우만 tact_time 등록 필요 나머지는 0
			 -- Input용 Tact Time은 수율을 곱해서 적용함
             --, c.tact_time * ISNULL(y.yield, ISNULL(smtt.yield, a.yield)) AS tact_time  -- 20180405 수정 ISNULL(FP 수율, ISNULL(scp 관리수율), 기본값)), ISNULL(FP tact_time, ISNULL(scp 관리 tact_time), 기본값))  변경함 (변경전 :  , ISNULL(c.tact_time,0) * ISNULL(y.yield, a.yield) AS tact_time )
             , ROUND(c.tact_time * ISNULL(y.yield, ISNULL(smtt.yield, a.yield)),3,1) AS tact_time  -- 소숫점 3자리로 절삭 (엔진은 1/1000초로 시간계산), 2023.08.08 수정

             , a.tact_time_uom      AS tact_time_uom 
             
             , ISNULL(y.yield, ISNULL(smtt.yield, a.yield)) AS yield --20180405 수정 ISNULL(FP 수율, ISNULL(scp 관리수율), 기본값)) 변경함 (변경전 : , ISNULL(y.yield, a.yield) AS yield)

             , 'N'                  AS is_first_setup
             , NULL                 AS good_rate
			 , NULL                 AS batch_rate
			 , a.descr              AS descr
			 , NULL                 AS consume_res_rate
             , NULL                 AS prepare_time
			 , NULL                 AS prepare_time_uom
        FROM   th_eng_op_res_group_sn a WITH(NOLOCK)
               INNER JOIN (SELECT SUBSTRING(r.resource_group_id, dbo.FN_CHARINDEX_REV(r.resource_group_id, '::', 0)+2, 100) AS line_id
                                , r.*
                           FROM   th_eng_resource_sn r WITH(NOLOCK)
                           WHERE  r.master_id = @p_master_id
                           AND    r.plan_id   = @p_engine_plan_id
                          ) b
               ON   a.master_id = b.master_id
               AND  a.plan_id   = b.plan_id
               AND  a.site_id   = b.site_id
               AND  a.route_id  LIKE b.route_id + '%'
             --  AND  a.route_id  = b.route_id
               
               -- 라인 모델링 대상 : Item이 Assign 된 Line 정보 연결               --20180418 수정 INNER JOIN => LEFT JOIN으로 변경
               INNER JOIN        (/* 소형CAPA분리 및 튜닝 2023.08.08 */    
                                  SELECT t.eng_scm_site_id
                                       , t.flow_id
                                       , t.division_id
                                       , t.plant_id
                                       , t.line_id
                                       , t.item_id
                                       , t.yyyymm    -- 최신월
                                       , t.tact_time
                                    FROM #scm_mst_fp_tact_time_temp t WITH (NOLOCK)    -- PJ20209642 변경  scm_mst_tact_time_sn
                                 /* org : 2023.08.08 이전 소스
                                 SELECT CASE WHEN SUBSTRING(op.flow_id, 1, 1) = 'E' THEN t.plant_id + '-E~***'
                                              WHEN SUBSTRING(op.flow_id, 1, 1) = 'S' THEN t.plant_id + '-E~***' -- SRS => 전극
                                              WHEN SUBSTRING(op.flow_id, 1, 1) = 'A' THEN t.plant_id + '-A~***'
                                              WHEN SUBSTRING(op.flow_id, 1, 1) = 'F' THEN t.plant_id + '-A~***' -- 활성화 => CELL
                                              WHEN SUBSTRING(op.flow_id, 1, 1) = 'P' THEN t.plant_id + '-P~***'
                                         END  AS eng_scm_site_id
                                       , op.flow_id
                                       , t.division_id
                                       , t.plant_id
                                       , t.line_id
                                       , t.item_id
                                       , t.month    -- Tact Time 존재 구간
                                       , SUM(ISNULL(t.tact_time, 0)) AS tact_time
                                       , ROW_NUMBER() OVER (PARTITION BY t.plant_id, op.flow_id, t.line_id, t.item_id ORDER BY t.month ) row_num 
                                 
                                      /*   -- PJ20209642 Lane 수는 View에서 고려되어 있음                                  
                                       -- 전극은 FP에서 Tact Time으로 관리, 나머지는 Capa 로 관리하므로 Tact Time으로 전환 : OP RES GRAUP MAP / OP RES GRAUP MAP CAL / BUCKET RES CAPA 에 동일 로직
                                       , CASE -- 셀, 팩일때
                                              
                                              --20180514 FN_GET_ITEM_OPERATION_GROUP 함수제거 
                                              --WHEN DBO.FN_GET_ITEM_OPERATION_GROUP(@p_division_id,t.item_id) <> 'E' THEN
                                              WHEN  SUBSTRING(op.flow_id, 1, 1)  NOT IN ('E', 'S')  THEN
                                                   IIF( SUM(ISNULL(t.daily_capa,0)) = 0 , 0, ROUND((60 * 60 * 24)/SUM(ISNULL(t.daily_capa,0)),3) ) 
							                  
                                              --전극일때
                                              /* 20180928 수정 (scm_mst_item_lane_m_sn.lane_qty ->scm_mst_item_line_assign_sn.lane_qty 변경)
                                                WHEN MAX(ISNULL(l.lane_qty, 0)) = 0 THEN SUM(ISNULL(t.tact_time, 0))
                                                ELSE SUM(ISNULL(t.tact_time, 0)) / MAX(ISNULL(l.lane_qty, 0))
                                              */
                                              WHEN MAX(ISNULL(li.lane_qty, 0)) = 0 THEN SUM(ISNULL(t.tact_time, 0))
                                              ELSE SUM(ISNULL(t.tact_time, 0)) / MAX(ISNULL(li.lane_qty, 0))

                                         END AS tact_time
                                      */
                                  FROM   dbo.scm_mst_tact_time_ver_h_v t WITH (NOLOCK)    -- PJ20209642 변경  scm_mst_tact_time_sn

                                  INNER JOIN dbo.scm_mst_operation_flow_v op WITH(NOLOCK)
                                  ON     t.division_id  = op.division_id
                                  AND    t.company_id   = op.company_id
                                  AND    t.site_id      = op.site_id
                                  AND    t.operation_id = op.operation_id								  
                                /*   -- PJ20209642 Lane 수는 View에서 고려되어 있음   
                                  -- Item이 Assign 된 Line 정보 연결
                                  INNER JOIN (SELECT DISTINCT la.company_id, la.division_id, la.site_id
                                                            , la.plant_id, la.factory_id, la.item_id
                                                            , la.operation_id, la.line_id
                                                            , la.lane_qty  -- 20180928 추가(scm_mst_item_lane_m_sn.lane_qty 값을 scm_mst_item_line_assign_sn.lane_qty 변경하기 위해서 추가함)
                                              FROM   dbo.scm_mst_item_line_assign_sn la WITH(NOLOCK)
                                              WHERE  1=1
                                              AND    la.division_id = @p_division_id
                                              AND    la.active_flag = 'Y'
                                              AND    la.priority    NOT IN ('0', '9') -- 0/9 는 FP에서 사용 안 하는 정보임
                                              AND    la.month      >= SUBSTRING(@p_plan_name, 1, 6)
                                         ) li
                                  ON     t.company_id   = li.company_id
                                  AND    t.division_id  = li.division_id
                                  AND    t.site_id      = li.site_id
                                  AND    t.plant_id     = li.plant_id
                                  AND    t.factory_id   = li.factory_id
                                  AND    t.operation_id = li.operation_id
                                  AND    t.line_id      = li.line_id
                                  AND    t.item_id      = li.item_id
                                */
	                              WHERE  t.division_id  = @p_division_id
                                  AND    t.month       >= SUBSTRING(@p_plan_name, 1, 6)
                                  GROUP BY op.flow_id, t.division_id, t.plant_id, t.line_id, t.item_id, t.month
                                  HAVING SUM(ISNULL(t.tact_time, 0)) > 0
                                  */
                                 ) c 
               ON   a.site_id    = c.eng_scm_site_id
               AND  a.route_id   = c.flow_id
               AND  b.line_id    = c.line_id
               AND  a.item_id    = c.item_id 
             --AND  c.row_num    = 1

               -- 라인 모델링 비대상 : yield
               -- 20181213 HASH 힌트적용
               LEFT HASH JOIN   ( /* 소형CAPA분리 및 튜닝 2023.08.08 */ 
                                  SELECT a.*
                                    FROM #scm_mst_fp_yield_temp a                                  
                                  /* org : ~ 2023.08.08
                                  SELECT CASE WHEN SUBSTRING(op.flow_id, 1, 1) = 'E' THEN t.plant_id + '-E~***'
                                              WHEN SUBSTRING(op.flow_id, 1, 1) = 'S' THEN t.plant_id + '-E~***' -- SRS => 전극
                                              WHEN SUBSTRING(op.flow_id, 1, 1) = 'A' THEN t.plant_id + '-A~***'
                                              WHEN SUBSTRING(op.flow_id, 1, 1) = 'F' THEN t.plant_id + '-A~***' -- 활성화 => CELL
                                              WHEN SUBSTRING(op.flow_id, 1, 1) = 'P' THEN t.plant_id + '-P~***'
                                         END  AS eng_scm_site_id
                                       , op.flow_id
                                       , t.division_id
                                       , t.plant_id
                                       , t.line_id
                                       , t.item_id
                                       , t.month    -- yield 존재 구간
                                       -- 수율 0 또는 NULL은 1로 처리함                                 
                                       , MIN(CASE WHEN t.yield <= 0 THEN 1
                                                  WHEN t.yield > 1 THEN 1
                                                  ELSE ISNULL(t.yield, 1)
                                             END
                                            ) AS yield -- 누적수율은 곱해야 하나 일단 MIN 값으로 처리함
                                     
                                  FROM   dbo.scm_mst_yield_ver_h_v t WITH (NOLOCK)    -- PJ20209642 변경  scm_mst_yield_sn
                                       , dbo.scm_mst_operation_flow_v op WITH(NOLOCK)
	                              WHERE  t.division_id  = @p_division_id
                                  AND    t.month        = SUBSTRING(@p_plan_name, 1, 6)
                                  AND    t.division_id  = op.division_id
                                  AND    t.company_id   = op.company_id
                                  AND    t.site_id      = op.site_id
                                  AND    t.operation_id = op.operation_id
                                  GROUP BY op.flow_id, t.division_id, t.plant_id, t.line_id, t.item_id, t.month
                                  */
                                 ) y 
               ON   a.site_id  = y.eng_scm_site_id
               AND  a.route_id = y.flow_id
               AND  b.line_id  = y.line_id
               AND  a.item_id  = y.item_id 

               --20180405 추가 SCP 관리 yield 정보
               LEFT JOIN ( SELECT division_id, plant_site_id + '~***' AS eng_scm_site_id, item_id, operation_id, line_id
                              ,   priority -- 20191021 Line 우선 순위 적용
                              --,   tact_time
                              -- 수율 0 또는 NULL은 1로 처리함                                 
                              ,   (CASE WHEN yield <= 0 THEN 1
                                        WHEN yield > 1 THEN 1
                                        ELSE ISNULL(yield, 1)
                                   END) AS yield      
                           FROM scp_mst_tact_time WITH (NOLOCK)
                           WHERE division_id = @p_division_id
                           AND   valid_yn = 'Y'                            
                           ) smtt
               ON  a.site_id  = smtt.eng_scm_site_id
               AND a.item_id  = smtt.item_id 
               AND b.line_id  = smtt.line_id
               AND a.route_id LIKE smtt.operation_id + '%'

        WHERE  a.master_id = @p_master_id
        AND    a.plan_id   = @p_engine_plan_id
        AND    a.descr     = 'LINE_CAPA' -- 라인 모델링 대상
        ;
		
        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = N'INSERT INTO : 4.1 라인 모델링 대상 : Item이 Assign 된 Line 정보 연결 : FP 정보 사용';
        SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
        -- 4.2 라인 모델링 대상 : Item이 Assign 된 Line 정보 연결 : SCP 정보 사용
        -----------------------------------------------------------
		INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_OP_RES_GROUP_MAP */ th_eng_op_res_group_map_sn
		(   master_id
		  , plan_id
          , site_id
		  , route_id
		  , operation_id
		  , item_id
		  , resource_map_id
          , resource_group_id
		  , sub_resource_map_id
		  , resource_map_level
          , alt_priority
		  , tact_time
		  , tact_time_uom
          , yield
		  , is_first_setup
          , good_rate
		  , batch_rate
		  , descr
		  , consume_res_rate
          , prepare_time
		  , prepare_time_uom
        )
        SELECT a.master_id
		     , a.plan_id
             , a.site_id
			 , a.route_id
			 , a.operation_id
			 , a.item_id
			 , a.resource_map_id
             , b.resource_group_id  AS resource_group_id
			 , NULL                 AS sub_resource_map_id
			 , a.resource_map_level
             , ISNULL(smtt.priority, 99) AS alt_priority -- 20191021 Line 우선 순위 적용 : NULL -> ISNULL(smtt.priority, 99)
             
             -- Capa 대상인 경우만 tact_time 등록 필요 나머지는 0
			 -- Input용 Tact Time은 수율을 곱해서 적용함
             , smtt.tact_time * ISNULL(y.yield, ISNULL(smtt.yield, a.yield)) AS tact_time  -- 20180405 수정 ISNULL(FP 수율, ISNULL(scp 관리수율), 기본값)), ISNULL(FP tact_time, ISNULL(scp 관리 tact_time), 기본값))  변경함 (변경전 :  , ISNULL(c.tact_time,0) * ISNULL(y.yield, a.yield) AS tact_time )

             , a.tact_time_uom      AS tact_time_uom 
             
             , ISNULL(y.yield, ISNULL(smtt.yield, a.yield)) AS yield --20180405 수정 ISNULL(FP 수율, ISNULL(scp 관리수율), 기본값)) 변경함 (변경전 : , ISNULL(y.yield, a.yield) AS yield)

             , 'N'                  AS is_first_setup
             , NULL                 AS good_rate
			 , NULL                 AS batch_rate
			 , a.descr              AS descr
			 , NULL                 AS consume_res_rate
             , NULL                 AS prepare_time
			 , NULL                 AS prepare_time_uom
        FROM   th_eng_op_res_group_sn a WITH(NOLOCK)
               INNER JOIN (SELECT SUBSTRING(r.resource_group_id, dbo.FN_CHARINDEX_REV(r.resource_group_id, '::', 0)+2, 100) AS line_id
                                , r.*
                           FROM   th_eng_resource_sn r WITH(NOLOCK)
                           WHERE  r.master_id = @p_master_id
                           AND    r.plan_id   = @p_engine_plan_id
                          ) b
               ON   a.master_id = b.master_id
               AND  a.plan_id   = b.plan_id
               AND  a.site_id   = b.site_id
               AND  a.route_id  LIKE b.route_id + '%'
             --  AND  a.route_id  = b.route_id
               
               -- 라인 모델링 비대상 : yield
	       LEFT OUTER JOIN   (
	                           /* 소형CAPA분리 및 튜닝 2023.08.08 */ 
                                  SELECT a.*
                                    FROM #scm_mst_fp_yield_temp a
                                  /* org : ~ 2023.08.08
                                  SELECT CASE WHEN SUBSTRING(op.flow_id, 1, 1) = 'E' THEN t.plant_id + '-E~***'
                                              WHEN SUBSTRING(op.flow_id, 1, 1) = 'S' THEN t.plant_id + '-E~***' -- SRS => 전극
                                              WHEN SUBSTRING(op.flow_id, 1, 1) = 'A' THEN t.plant_id + '-A~***'
                                              WHEN SUBSTRING(op.flow_id, 1, 1) = 'F' THEN t.plant_id + '-A~***' -- 활성화 => CELL
                                              WHEN SUBSTRING(op.flow_id, 1, 1) = 'P' THEN t.plant_id + '-P~***'
                                         END  AS eng_scm_site_id
                                       , op.flow_id
                                       , t.division_id
                                       , t.plant_id
                                       , t.line_id
                                       , t.item_id
                                       , t.month    -- yield 존재 구간
                                       -- 수율 0 또는 NULL은 1로 처리함                                 
                                       , MIN(CASE WHEN t.yield <= 0 THEN 1
                                                  WHEN t.yield > 1 THEN 1
                                                  ELSE ISNULL(t.yield, 1)
                                             END
                                            ) AS yield -- 누적수율은 곱해야 하나 일단 MIN 값으로 처리함
                                     
                                  FROM   dbo.scm_mst_yield_ver_h_v t WITH (NOLOCK)    -- PJ20209642 변경  scm_mst_yield_sn
                                       , dbo.scm_mst_operation_flow_v op WITH(NOLOCK)
	                              WHERE  t.division_id  = @p_division_id
                                  AND    t.month        = SUBSTRING(@p_plan_name, 1, 6)
                                  AND    t.division_id  = op.division_id
                                  AND    t.company_id   = op.company_id
                                  AND    t.site_id      = op.site_id
                                  AND    t.operation_id = op.operation_id
                                  GROUP BY op.flow_id, t.division_id, t.plant_id, t.line_id, t.item_id, t.month
                                  */
                                 ) y 
               ON   a.site_id  = y.eng_scm_site_id
               AND  a.route_id = y.flow_id
               AND  b.line_id  = y.line_id
               AND  a.item_id  = y.item_id 
               --20180405 추가 SCP 관리 tact_time, yield 정보
               INNER JOIN (SELECT division_id, plant_site_id + '~***' AS eng_scm_site_id, item_id, operation_id, line_id
                              ,   priority -- 20191021 Line 우선 순위 적용
                              ,   tact_time
                              -- 수율 0 또는 NULL은 1로 처리함                                 
                              ,   (CASE WHEN yield <= 0 THEN 1
                                        WHEN yield > 1 THEN 1
                                        ELSE ISNULL(yield, 1)
                                   END) AS yield      
                           FROM scp_mst_tact_time WITH (NOLOCK)
                           WHERE division_id = @p_division_id
                           AND   valid_yn = 'Y'                            
                           ) smtt
               ON  a.site_id  = smtt.eng_scm_site_id
               AND a.item_id  = smtt.item_id 
               AND b.line_id  = smtt.line_id
               AND a.route_id LIKE smtt.operation_id + '%'

        WHERE  a.master_id = @p_master_id
        AND    a.plan_id   = @p_engine_plan_id
        AND    a.descr     = 'LINE_CAPA' -- 라인 모델링 대상
		-- FP Tact Time 없는 경우        
        /* 20190124 수정 속도문제로 NOT EXISTS 로 변경함
        AND   (a.master_id + ':' + a.plan_id + ':' + a.site_id + ':' + a.route_id + ':' + a.operation_id + ':' + a.item_id + ':' + a.resource_map_id + ':' + b.resource_group_id)
            NOT IN
              (SELECT master_id + ':' + plan_id + ':' + site_id + ':' + route_id + ':' + operation_id + ':' + item_id + ':' + resource_map_id + ':' + resource_group_id
               FROM   th_eng_op_res_group_map_sn a WITH(NOLOCK)
               WHERE  master_id = @p_master_id
               AND    plan_id   = @p_engine_plan_id
               AND    descr     = 'LINE_CAPA'  -- 라인 모델링
              )
        */ 
        AND     NOT EXISTS (SELECT 1
                            FROM  (SELECT master_id
                                       ,  plan_id 
                                       ,  site_id 
                                       ,  route_id
                                       ,  operation_id 
                                       ,  item_id 
                                       ,  resource_map_id
                                       ,  resource_group_id
                                   FROM   th_eng_op_res_group_map_sn WITH(NOLOCK)
                                   WHERE  master_id = @p_master_id
                                   AND    plan_id   = @p_engine_plan_id
                                   AND    descr     = 'LINE_CAPA'  -- 라인 모델링
                                  ) c
                            WHERE  a.master_id        = c.master_id 
                            AND  a.plan_id            = c.plan_id 
                            AND  a.site_id            = c.site_id 
                            AND  a.route_id           = c.route_id 
                            AND  a.operation_id       = c.operation_id 
                            AND  a.item_id            = c.item_id 
                            AND  a.resource_map_id    = c.resource_map_id 
                            AND  b.resource_group_id  = c.resource_group_id  )
        ;
		
        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = N'INSERT INTO : 4.2 라인 모델링 대상 : Item이 Assign 된 Line 정보 연결 : SCP 정보 사용';
        SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

 /* -- JIG 비활성화 : Start

        -----------------------------------------------------------
        -- 5. JIG 대상 처리
        -----------------------------------------------------------
        -----------------------------------------------------------
        -- 5-1. JIG 대상일때 sub_resource_map_id UPDATE
        --      -  sub_resource_map_id : resource_map_id + '_JIG'
        -----------------------------------------------------------
        -- TXN LOG
        SET @v_log_type = 'TXN';
        SET @v_log_message = N'INSERT INTO : 5-1. JIG 대상 sub_resource_map_id UPDATE';
        SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        
        UPDATE th_eng_op_res_group_map_sn 
        SET    sub_resource_map_id  = x.resource_map_id + '_JIG'
        FROM   th_eng_op_res_group_map_sn x
               INNER JOIN   (SELECT a.division_id
                                  , a.scm_site_id + '~***' AS eng_scm_site_id
                                  , a.jig_seq
                                  , a.operation_id
                                  , c.item_id
                             FROM  scp_mst_jig a WITH (NOLOCK)
                                   --INNER JOIN ( SELECT division_id, scm_site_id, operation_group, osp_yn
                                   --             FROM   dbo.scm_mst_site_eng WITH(NOLOCK)
                                   --             WHERE  modeling_id = @p_modeling_id
                                   --             AND    plan_id     = @p_plan_id
                                   --             AND    plan_seq    = @p_seq
                                   --             AND    plan_type   = @p_plan_type
                                   --             AND    site_type   = 'PLANT'
                                   --             AND    operation_group = 'A'                                                
                                   --           ) b
                                   --ON   a.division_id = b.division_id 
                                   --AND  a.site_id     = b.scm_site_id
                                   --AND  a.division_id = @p_division_id --'40'
                                   --AND  a.valid_yn    = 'Y'
  
                                   INNER JOIN scp_mst_jig_item c WITH (NOLOCK)
                                   ON   a.jig_seq  = c.jig_seq
                                   AND  c.valid_yn = 'Y' 
                             
                             WHERE a.division_id = @p_division_id
                             AND   a.valid_yn    = 'Y' 
                           ) y
               ON   x.item_id      = y.item_id
               AND  x.operation_id = y.operation_id
               AND  x.site_id      = y.eng_scm_site_id 
               
        WHERE  master_id = @p_master_id
        AND    plan_id   = @p_engine_plan_id 
        --AND    descr     = 'LINE_CAPA'
        ;
        
        -----------------------------------------------------------
        -- 5-2. JIG 대상 INSERT
        -----------------------------------------------------------
        -- TXN LOG
        SET @v_log_type = 'TXN';
        SET @v_log_message = N'INSERT INTO : 5-2. JIG 대상 INSERT';
        SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ; 
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		INSERT INTO /* PR_SCP_ENG_IN_PRE_PROC_OP_RES_GROUP_MAP */ th_eng_op_res_group_map_sn
		(   master_id
		  , plan_id
          , site_id
		  , route_id
		  , operation_id
		  , item_id
		  , resource_map_id
          , resource_group_id
		  , sub_resource_map_id
		  , resource_map_level
          , alt_priority
		  , tact_time
		  , tact_time_uom
          , yield
		  , is_first_setup
          , good_rate
		  , batch_rate
		  , descr
		  , consume_res_rate
          , prepare_time
		  , prepare_time_uom
        )
        SELECT DISTINCT
               a.master_id
		     , a.plan_id
             , a.site_id
			 , a.route_id
			 , a.operation_id			 
             , a.item_id
			 
             , a.resource_map_id + '_JIG' AS resource_map_id
             
             , b.operation_id + '::' + b.eng_scm_site_id + '::' + CONVERT(NVARCHAR(10), b.jig_seq)  AS resource_group_id  --, a.resource_group_id  AS resource_group_id
             
			 , NULL                 AS sub_resource_map_id
			 
             , 2                    AS resource_map_level  --JIG 일때 2로 설정
             , 99                   AS alt_priority -- 20191021 Line 우선 순위 적용 : NULL -> 99
             
             -- Capa 대상인 경우만 tact_time 등록 필요 나머지는 0
             -- , 0.0000000001         AS tact_time -- 20180723 수정(티라요청) (변경전 : , 0  AS tact_time)               
              , 0.00000001          AS tact_time  --JIG 일때 0.00000001 설정
                
             , a.tact_time_uom      AS tact_time_uom 

             , 1                    AS yield    --JIG 일때 수율은 1로 설정

			 , 'N'                  AS is_first_setup
             , NULL                 AS good_rate
			 , NULL                 AS batch_rate
			 
             , 'JIG'                AS descr
			 
             , NULL                 AS consume_res_rate
             , NULL                 AS prepare_time
			 , NULL                 AS prepare_time_uom
        FROM   ( SELECT DISTINCT 
                        master_id
                    ,   plan_id
                    ,   site_id
                    ,   route_id
                    ,   operation_id
                    ,   item_id
                    ,   resource_map_id
                   
                    ,   tact_time_uom
                    
                 FROM   th_eng_op_res_group_map_sn WITH (NOLOCK) -- select distinct site_id, route_id, operation_id, resource_map_id, resource_group_id from th_eng_op_res_group_map_sn WITH (NOLOCK) 
                 WHERE  master_id = @p_master_id
                 AND    plan_id   = @p_engine_plan_id
                 AND    sub_resource_map_id IS NOT NULL                 
              ) a
              INNER JOIN   (SELECT aa.division_id
                                 , aa.scm_site_id + '~***' AS eng_scm_site_id
                                 , aa.jig_seq
                                 , aa.operation_id
                                 , cc.item_id
                             FROM  scp_mst_jig aa WITH (NOLOCK)
                                   --INNER JOIN ( SELECT division_id, scm_site_id, operation_group, osp_yn
                                   --             FROM   dbo.scm_mst_site_eng WITH(NOLOCK)
                                   --             WHERE  modeling_id = @p_modeling_id
                                   --             AND    plan_id     = @p_plan_id
                                   --             AND    plan_seq    = @p_seq
                                   --             AND    plan_type   = @p_plan_type
                                   --             AND    site_type   = 'PLANT'
                                   --             AND    operation_group = 'A'   
                                   --             AND    eng_scm_site_id = scm_site_id + '~***'                                             
                                   --           ) bb
                                   --ON   aa.division_id = bb.division_id 
                                   --AND  aa.site_id     = bb.scm_site_id
                                   --AND  aa.division_id = @p_division_id --'40'
                                   --AND  aa.valid_yn    = 'Y'
  
                                   INNER JOIN scp_mst_jig_item cc WITH (NOLOCK)
                                   ON   aa.jig_seq  = cc.jig_seq
                                   AND  cc.valid_yn = 'Y' 
                             
                             WHERE aa.division_id = @p_division_id
                             AND   aa.valid_yn = 'Y' 
                           ) b
               ON   a.item_id      = b.item_id
               AND  a.operation_id = b.operation_id
               AND  a.site_id      = b.eng_scm_site_id 
                      
        --WHERE  a.master_id = @p_master_id
        --AND    a.plan_id   = @p_engine_plan_id
        --AND    a.descr     = 'LINE_CAPA'
        ;
               
 */ -- JIG 비활성화 : End       

         -----------------------------------------------------------
        -- 임시테이블 삭제. 2023.08.08
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#scm_mst_fp_tact_time_temp') IS NOT NULL
        BEGIN 
            DROP TABLE  #scm_mst_fp_tact_time_temp;          
        END 

        IF OBJECT_ID('tempdb..#scm_mst_fp_yield_temp') IS NOT NULL
        BEGIN 
            DROP TABLE  #scm_mst_fp_yield_temp;          
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

