
/*  
 * Program ID   : PR_SCP_ENG_IN_FN_PROC_OP_RES_GROUP_MAP_CAL
 * Description  :   
                    참고) 공통사항 : 
                              --1. 당월, 차월 일때 IS_USE = 'N' 처리
                                    경우1) tact_time = 0 일때
                                    경우2) line_assign의  priority IN (0, 9) 일때 
                                    경우3) scp_mst_tact_time_except.use_yn = 'N' 일때 (tact_time_start_date ~ tact_time_end_date 까지 is_use = 'N')
                                           ( 단, scp_mst_tact_time_except.use_yn = 'Y' 일때 : tact_time_start_date가 차월이전이라도 차월이후만 scp_mst_tact_time_except(tact_time_start_date ~ tact_time_end_date 기간만큼 scp_mst_tact_time_except.use_yn 값을 그대로 입력함 )
                                           ==>경우3)은 확정구간만큼만(scm_mst_site.fp_plan_period) tact_time 사용할때 ( 확정구간은 use_yn = 'Y' 나머지구간은 use_yn = 'N' 처리할때) 사용하면 됨

                              --2.  차월이후 해당월에 tact_time값이 없으면  th_eng_op_res_group_map_sn 의 값을 default 값으로 사용함

                    -----------------------------------------------------------
		            -- 1. Capa 공정 : Line Modeling 비대상 공정 ( th_eng_op_res_group_map_sn.descr 컬럼값이 'CAPA' 일때) 
                    --                - tact_time, yield값을 th_eng_bucket_info의 기간만큼 월별로 데이터 생성
                    -----------------------------------------------------------
                      - 1) tact_time 셋팅 
                            -1)-1) is_use 컬럼 'Y' 셋팅
                                   -1) 당월,차월은 FP의 tact_time 정보(86400(초) /scm_mst_tact_time_ver_h_v.daily_capa) 사용함
                                       ==> LINE모델링 비대상공정은 line_id 값이 존재하지 않으므로 
                                           eng_scm_site_id, flow_id, division_id, plant_id, item_id, month 그룹핑한 AVG(tact_time) 값을 사용함
                                       ==> 소숫점 4자리에서 반올림 처리함(=ROUND(86400 / scm_mst_tact_time_ver_h_v.daily_capa, 3))
                                       ==> 최종 tact_time 컬럼값) ISNULL(AVG(ROUND(86400 / scm_mst_tact_time_ver_h_v.daily_capa, 3)), ISNULL(AVG(scp_mst_tact_time.tact_time), th_eng_op_res_group_map_sn.tact_time))
                                                                  * 
                                                                  ISNULL(AVG(scm_mst_yield_ver_h_v.yield), ISNULL(MIN(scp_mst_tact_time.yield), th_eng_op_res_group_map_sn.yield ))  

                                                                  (참고) MIN(scp_mst_tact_time.yield) 값은 아래2)참조

                                   -2) 차월이후는 scp관리(scp_mst_tact_time.tact_time) tact_time 사용함
                                       ==> LINE모델링 비대상공정은 line_id 값이 존재하지 않으므로 
                                           division_id, plant_site_id, item_id, operation_id 그룹핑한 AVG(scp_mst_tact_time.tact_time), MIN(scp_mst_tact_time.yield) 값을 사용함
                                       
                                       ==> 최종 tact_time 컬럼값) AVG(ISNULL(scp_mst_tact_time.tact_time, th_eng_op_res_group_map_sn.tact_time))
                                                                  * 
                                                                  MIN(ISNULL(scp_mst_tact_time.yield, 1 ))
                                        
                            -1)-2) is_use 컬럼 'N' 셋팅
                                   -1) tact_time = 0 일때 is_use ='N' 처리 함
                                       ==> tact_time = 0인 경우1) 위1-1)의 처리결과 tact_time값이 0일 경우 
                                       ==> tact_time = 0인 경우2) 당월, 차월중 데이터 미존재시 미존재월의 데이터를 tact_time = 0으로 생성해줌
                                       ==> tact_time = 0인 경우3) th_eng_op_res_group_map_sn의 존재하고 scm_mst_tact_time_ver_h_v에 미존재하는 데이터를 tact_time =0 으로 생성해줌
                                  
                       - 2) yield 셋팅
                            -2)-1) 당월,차월은 FP의 yield정보(scm_mst_yield_ver_h_v.yield)
                                   ==> LINE모델링 비대상공정은 line_id 값이 존재하지 않으므로 
                                       eng_scm_site_id, flow_id, division_id, plant_id, item_id, month 그룹핑한 AVG(yield) 값을 사용함
                                   ==> 당월,차월의 FP정보가 없을경우 tact_time = 0값으로 신규생성함
                                   ==> 최종 yield 컬럼값)  ISNULL(scm_mst_yield_ver_h_v.yield, ISNULL(scp_mst_tact_time.yield, 1 )) 

                            -2)-2) 차월이후는 scp관리(scp_mst_tact_time.yield) yield사용함
                                   ==> LINE모델링 비대상공정은 line_id 값이 존재하지 않으므로 
                                       division_id, plant_site_id, item_id, operation_id 그룹핑한 MIN(scp_mst_tact_time.yield) 값을 사용함
                                   ==> 최종 yield 컬럼값)  ISNULL(scp_mst_tact_time.yield, 1) 

                            -2)-3) yield값이 NULL이거나, 0보다작거나, 1보다클때 1로 셋팅함 
                                   ==> 최종 yield 컬럼값)  1로  셋팅

                    -----------------------------------------------------------
		            -- 2. Capa 공정 : Line Modeling 대상 공정 ( th_eng_op_res_group_map_sn.descr 컬럼값이 'LINE CAPA' 일때) 
                    --                - tact_time, yield값을 th_eng_bucket_info의 기간만큼 월별로 데이터 생성
                    -----------------------------------------------------------
                       - 1) tact_time 셋팅 
                            -1)-1) is_use 컬럼 'Y' 셋팅
                                   -1) 당월,차월은 FP의 tact_time 정보(86400(초) / scm_mst_tact_time_ver_h_v.daily_capa) 사용함
                                       ==> 소숫점 4자리에서 반올림 처리함
                                       ==> 최종 tact_time 컬럼값) ISNULL( ROUND(86400 / scm_mst_tact_time_ver_h_v.daily_capa, 3), ISNULL(scp_mst_tact_time.tact_time, th_eng_op_res_group_map_sn.tact_time))
                                                                  * 
                                                                  ISNULL(scm_mst_yield_ver_h_v.yield, ISNULL(scp_mst_tact_time.yield, th_eng_op_res_group_map_sn.yield ))  
                                   
                                   -2) 차월이후는 scp관리(scp_mst_tact_time.tact_time) tact_time 사용함
                                       ==> 최종 tact_time 컬럼값) ISNULL(scp_mst_tact_time.tact_time, th_eng_op_res_group_map_sn.tact_time)
                                                                  * 
                                                                  ISNULL(scp_mst_tact_time.yield, 1 )  
                                        
                            -1)-2) is_use 컬럼 'N' 셋팅
                                   -1) tact_time = 0 일때 is_use ='N' 처리 함
                                       ==> tact_time = 0인 경우1) ISNULL(scm_mst_tact_time_ver_h_v.daily_capa, 0) = 0일 경우 
                                       ==> tact_time = 0인 경우2) 당월, 차월중 데이터 미존재시 미존재월의 데이터를 tact_time = 0으로 생성해줌
                                       ==> tact_time = 0인 경우3) th_eng_op_res_group_map_sn의 존재하고 scm_mst_tact_time_ver_h_v에 미존재하는 데이터를 tact_time =0 으로 생성해줌
                                   
                                   -2) line assig 정보의 priority IN (0,9) 일때 is_use = 'N' 처리함
                       
                       - 2) yield 셋팅
                            -2)-1) 당월,차월은 FP의 yield정보(scm_mst_yield_ver_h_v.yield)
                                   ==> 당월,차월의 FP정보가 없을경우 tact_time = 0값으로 신규생성함
                                   ==> 최종 yield 컬럼값)  ISNULL(scm_mst_yield_ver_h_v.yield, ISNULL(scp_mst_tact_time.yield, 1 )) 

                            -2)-2) 차월이후는 scp관리(scp_mst_tact_time.yield) yield사용함
                                   ==> 최종 yield 컬럼값)  ISNULL(scp_mst_tact_time.yield, 1) 

                            -2)-3) yield값이 NULL이거나, 0보다작거나, 1보다클때 1로 셋팅함 
                                   ==> 최종 yield 컬럼값)  1로  셋팅
                       
                       - 3) tact_time_except 적용(line 모델링 대상에만 적용함)
                            : 위 1), 2) 적용해서 생성된 th_eng_op_res_group_map_cal_sn 데이터중에서 
                              scp_mst_tact_time_except.tact_time_start_date ~ scp_mst_tact_time_except.tact_time_end_date 기간에 포함된 데이터의 
                              
                              th_eng_op_res_group_map_cal_sn.start_dttm  => scp_mst_tact_time_except.tact_time_start_date
                              th_eng_op_res_group_map_cal_sn.end_dttm    => scp_mst_tact_time_except.tact_time_end_date
                              th_eng_op_res_group_map_cal_sn.tact_time   => scp_mst_tact_time_except.tact_time
                              th_eng_op_res_group_map_cal_sn.yield       => scp_mst_tact_time_except.yield
                              th_eng_op_res_group_map_cal_sn.is_use      => scp_mst_tact_time_except.use_yn 값으로 대체함
                              
                              -3)-1) scp_mst_tact_time_except.use_yn = 'N'일때
                                     ==> scp_mst_tact_time_except.tact_time_start_date ~ scp_mst_tact_time_except.tact_time_end_date 까지 scp_mst_tact_time_except 값을 입력함
                                   
                              -3)-2) scp_mst_tact_time_except.use_yn = 'Y'일때
                                     ==> tact_time_start_date가 차월이전이라도 "차차월부터 ~ scp_mst_tact_time_except.tact_time_end_date" 기간만큼 scp_mst_tact_time_except 값을 입력함 

                              ex) 플랜시작일:2019-03-02
                                  th_eng_op_res_group_map_cal_sn.start_dttm : 2019-05-01 
                                  th_eng_op_res_group_map_cal_sn.end_dttm : 2019-06-01
                                  scp_mst_tact_time_except.tact_time_start_date : 2019-05-03 
                                  scp_mst_tact_time_except.tact_time_end_date : 2019-05-10 일경우
                                  
                                  except  적용하면=> th_eng_op_res_group_map_cal_sn.start_dttm: 2019-05-01
                                                     th_eng_op_res_group_map_cal_sn.end_dttm: 2019-05-03  ==> 데이터1) 기존 th_eng_op_res_group_map_cal_sn 데이터값 유지하면서 start_dttm, end_dttm 값만 변경됨 

                                                     th_eng_op_res_group_map_cal_sn.start_dttm: 2019-05-03
                                                     th_eng_op_res_group_map_cal_sn.end_dttm: 2019-05-10  ==> 데이터2) scp_mst_tact_time_except 데이터 값 적용

                                                     th_eng_op_res_group_map_cal_sn.start_dttm: 2019-05-10
                                                     th_eng_op_res_group_map_cal_sn.end_dttm: 2019-06-01  ==> 데이터3) 기존 th_eng_op_res_group_map_cal_sn 데이터값 유지하면서 start_dttm, end_dttm 값만 변경됨 

                                                     기존 1건의 데이터가 3건의 데이터로 변경됨        

                    -----------------------------------------------------------
                    -- 2.2 OSP_L 공정 : 외주 Line Capa 공정 ( th_eng_op_res_group_map_sn.descr 컬럼값이 'OSP_L' 일때) 
                    --                - tact_time, yield값을 th_eng_bucket_info의 기간만큼 월별로 데이터 생성
                    -----------------------------------------------------------
                       - 1) tact_time/ yield 셋팅 
                            -1)-1) is_use 컬럼 'Y' 셋팅
                                   -1) 전 구간 scp관리(scp_mst_tact_time_osp.tact_time / yield) tact_time/yield 사용함
                                       ==> 최종 tact_time 컬럼값) ISNULL(scp_mst_tact_time_osp.tact_time, 1)
                                                                  * 
                                                                  ISNULL(scp_mst_tact_time_osp.yield, 1 )
                       
                       - 2) tact_time_except 적용(line capa 대상에만 적용함) : 2-3 참고
                            : 위 1) 적용해서 생성된 th_eng_op_res_group_map_cal_sn 데이터중에서 
                              scp_mst_tact_time_except_osp.tact_time_start_date ~ scp_mst_tact_time_except_osp.tact_time_end_date 기간에 포함된 데이터의 값 대체

                    -----------------------------------------------------------
		            -- 3. th_eng_op_res_group 테이블의 컬럼값 UPDATE                          
                    -----------------------------------------------------------
                       - min_tact_time, avg_tact_time, max_tact_time 값을 
                         1)th_eng_op_res_group_map.tact_time, 2)th_eng_op_res_group_group_map_cal.tact_time 1),2)둘중 큰값으로 변경  

                    -----------------------------------------------------------
		            -- 참고사항
                    -----------------------------------------------------------
                    참고 테이블1)  tact_time 정보 : scm_mst_tact_time_ver_h_v 
                    참고 테이블2)  yield 정보     : scm_mst_yield_ver_h_v 
                    
                    참고 뷰1)      FP의 flow_id, operation_id 정보 :  scm_mst_operation_flow_v ( 참고 테이블1), 2)의 operation_id 정보로 flow_id(=route_id) 정보를 조회할때 사용됨)

 * OutTable     : TH_ENG_OP_RES_GROUP_MAP_CAL
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.01.18   KSW            전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.05.28   KSG            SCP_MST_TACT_TIME_EXCEPT USE_YN 적용
 * 2018.06.08   KSW            1)  LINE 모델링 대상일때 line assign IN (0, 9)  일때 is_use = 'N' 처리 추가 ( 참고 주석:2-3)-2)
                               2)  당월, 차월은 FP용 tact time 사용(tact time = 0 일때 is_use = 'N' 처리) 수정(참고 주석: 1-1-2 ~ 1-1-5, 2-1-2 ~ 2-1-5)
 * 2018.07.05   KSG            LATE TYPE 변경 / 13주 추가기간 설정
 *                             th_eng_bucket_info_sn 테이블 사용시 descr = 'PLAN' 조회조건 추가 (  th_eng_bucket_info_sn 테이블 생성시 plan종료일이후 13주가 추가 되었으므로 반드시 조건필요함)
 * 2018.09.04   KSW            operation_id 조인조건 수정 (참고 주석2-3-2)
 * 2018.09.17   KSW            scp_mst_tact_time_except 테이블의 use_yn = 'N'(단, use_yn = 'Y'일경우 기존처리방식 사용)일경우 당월,차월, 차월이후 상관없이 해당기간만큼 use_yn = 'N' 처리( 기존 : tact_time_start_date가 차월이전이라도 차월이후만 scp_mst_tact_time_except(tact_time_start_date ~ tact_time_end_date 기간만큼 scp_mst_tact_time_except.use_yn 값을 그대로 입력함) 참고)주석2-4-1
 * 2018.09.28   KSW            전극 tact_time 계산시 사용되는 lane_qty 컬럼 대상 테이블 변경(scm_mst_item_lane_m_sn.lane_qty -> scm_mst_item_line_assign_sn.lane_qty)  참고) 주석1-1, 주석2-1
 * 2018.10.04   KSW            operation_id 조회조건 수정(참고)주석1-3
 --반영보류
 * 2019.04.05(반영보류_차후사용시 주석해제후 사용하면됨)   KSW            scp_mst_tact_time_except 날짜겹침 방지처리 (참고)주석2-4-0 추가, 주석2-4-1)
 * 2019.07.22   KSG            티라 요청 : PET가 아니라 13주 추가 구간까지 CAL 생성 / th_eng_bucket_info_sn 테이블 사용시 descr = 'PLAN' 조회조건 제거
 * 2020.02.06   KSG            [OSP Line Plan] OSP이면서 Line별 Capa 적용 Site 정보 추가
 * 2020.11.02   KSG            PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : RACK
 * 2021.03.12   KSG            PJ20209642 Digital SCM Level.3 달성을 위한 개선 : FP Tact Time/Yield Table 변경
 * 2021.07.27   KSG            PJ20209643 Digital SCM Level.3 달성을 위한 개선(Phase 2) : line assign IN (0, 9) 일때 is_use = 'N' 처리 구간 변경
 * 2021.11.01   LHS            th_eng_op_res_group.TACT_TIME 값을 소형만 MAX에서 AVG값으로 변경
 * 2022.01.26   LHS			   PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선: 사업부별 추가 계획수립기간을 lookup으로 설정하여 Engine Plan 기간으로 반영
 * 2022.04.04   LHS            PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선: JV사업부 추가: 사업부 조건별 로직구현시 division_id 대신 속성값(attribute3) 기준으로 변경
                                ----------------------------------------------------------------
                                        구분                         자동차           전극
                                ==============================    =============   ==============
                                  division_group(attribute3)  :        81              EE                
                                ------------------------------    -------------   --------------
                                  division_id                 :     81 , 81_UC      EE , EE_UC  
                                ----------------------------------------------------------------
 * 2023.04.18   KSG            PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 도전과제 계획
 * 2023.08.24   KKC            PJ20230692 SCM 역량 강화 위한 SCP 개선과제 이행 Phase2 : 소형CAPA 분리
                               1) 재사용 데이터 공통화
                                  - FP  Tact Time / Yield (M0~M1) 
                                  - FP  Yield1 (M2~) 
                                  - SCP Tact Time / Yield 
                                  - 소형 CAPA Tact Time
                               2) 기존 기간별 Tact Time / Yield 생성 로직 정리. 2023.08.24
                                  2-1) M0~M1 구간은 FP의 Tact/Yield을 사용 (만일 없다면, SCP Tact/ Yiled, 그것도 없다면, Default Tact / Yield 사용)
                                  2-2) M2부터는 SCP Tact / Yield 사용      (만일 없다면, Default Tact / Yield 사용)
                               3) Line Assign 로직 보완 (해당 Line Assign에 아예 데이터가 없는 경우 추가)
                               4) Exception Tact Time 수정 (소형 Capa분리 공정은 SCP에서 관리하는 신규 소형 Capa 정보를 봐야함)   
                               5) 불필요 로직 정리 
 * 2023.10.10   KKC            PJ20230692 SCM 역량 강화 위한 SCP 개선과제 이행 Phase2 : 소형CAPA 분리 & TACT TIME 계산시 소숫점 3자리 절삭 처리 보완
 * 2023.11.23   KKC            PJ20230692 SCM 역량 강화 위한 SCP 개선과제 이행 Phase2 : 하드코딩값 적용 로직 수정/보완
 * 2024.05.20   LJH            PJ20244781 LGES 시스템 기반 SCM 고도화(소형 시스템 Planning, oWMS 영역): 월별 Line Priority 로직 적용
 *
 */

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_IN_FN_PROC_OP_RES_GROUP_MAP_CAL_0724_ORG]
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_IN_FN_PROC_OP_RES_GROUP_MAP_CAL';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'TH_ENG_OP_RES_GROUP_MAP_CAL';
    DECLARE @d_event_date   DATETIME;

    DECLARE @n_pre_plan_id       INTEGER = 0;
    DECLARE @n_cur_plan_id       INTEGER = 0;
    DECLARE @n_pre_week_plan_id  INTEGER = 0;
    DECLARE @n_cur_week_plan_id  INTEGER = 0;
    --DECLARE @v_division_id       NVARCHAR(30);
    --DECLARE @v_cur_monday        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    DECLARE @d_plan_name         DATETIME;
    DECLARE @v_pet_date          NVARCHAR(8) ; -- Plan End Date
	DECLARE @v_add_pet_date      NVARCHAR(8) ; -- Add Plan End Date (2022.01.26)
    DECLARE @v_plan_group        NVARCHAR(100) = '-'; -- Plan Group : PJ20230691 도전과제 계획 	

    DECLARE @v_division_group   NVARCHAR(30) ; ---(2022.04.04) 추가.
    DECLARE @v_division_comp    NVARCHAR(30); 

    DECLARE @n_capa_op_check_cnt INTEGER;       --CAPA대상이면서, LINE 비모델링 대상 여부, 2023.08.24 추가 

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
        -- PJ20230692 : 소형 CAPA 분리, 2023.08.24
        -- 임시 테이블 재정의 / 정리
		---------------------------------------------
 /*
--1. 1차 임시 테이블 정리
        [CAPA라인 관련]
        #tact_op_flow_temp_1 -> #tmp_capa_flow_tact_time
	    #tact_op_flow_temp_2 -> #tmp_capa_flow_no_tact_time
        #tact_op_flow_temp   -> #tmp_capa_flow_merge_tact_time
	    #th_eng_op_res_group_map_1 -> #th_eng_op_res_group_map_capa
	    #yield_op_flow_temp  -> #tmp_line_capa_flow_yield
	
	    [LINE CAPA] 
	    #tact_op_flow_temp2_temp -> #tmp_line_capa_flow_tact_time
	    #tact_op_flow_temp2_2    -> #tmp_line_capa_flow_no_tact_time
	    #tact_op_flow_temp2      -> #tmp_line_capa_flow_merge_tact_time	
	    #th_eng_op_res_group_map -> #th_eng_op_res_group_map_line_capa
	    #yield_op_flow_temp2     -> #tmp_line_capa_flow_yield
	
	    #TH_ENG_OP_RES_GROUP_MAP_CAL  -> #th_eng_op_res_group_map_line_capa_cal
	    #TH_ENG_OP_RES_GROUP_MAP_CAL2 -> #th_eng_op_res_group_map_line_capa_cal2

        --2. 1차 정리된 임시 테이블에 대해 2차 임시 테이블 공통화 
        #scm_mst_fp_tact_time_temp
        #scm_mst_fp_yield_temp
        #th_eng_op_res_group_map_cal_mst

        --3. 임시 테이블 규칙 통일 (소문자)         	
	    [기타]
	    #DIV_TH_ENG_OP_RES_GROUP_MAP_CAL -> #div_th_eng_op_res_group_map_cal	
	    #TH_ENG_OP_RES_GROUP_MAP_CAL_ADD -> #th_eng_op_res_group_map_cal_add	
	    #TH_ENG_OP_RES_GROUP_MAP_CAL_OSP_L -> #th_eng_op_res_group_map_cal_osp_l
	    #DIV_TH_ENG_OP_RES_GROUP_MAP_CAL_OSP_L  -> #div_th_eng_op_res_group_map_cal_osp_l
	    #TH_ENG_OP_RES_GROUP_MAP_CAL_ADD_OSP_L  -> #th_eng_op_res_group_map_cal_add_osp_l

        */

	    ---------------------------------------------
        -- PJ20230691 도전과제 계획 추가용 기간 설정
		---------------------------------------------
		SELECT @v_plan_group = ISNULL(segment5, '-')
		FROM   scm_adm_lookup_master_detail a(nolock)
		WHERE  a.lookup_type = 'PLAN_TYPE'
		AND    a.segment1    = @p_plan_type
		AND    a.valid_yn    = 'Y'  

        --  Plan End Date : PJ20230691 도전과제 계획 추가용 기간 설정
	    SELECT @v_pet_date      = CASE WHEN @v_plan_group = 'BIZ' THEN p.attribute1
                                       ELSE p.horizon_end_date
                                  END 
			,  @v_add_pet_date  = CASE WHEN @v_plan_group = 'BIZ' 
                                       THEN CONVERT(NVARCHAR(8), DATEADD(dd, ISNULL(B.add_day ,(13*7)), CONVERT(DATETIME, P.attribute1)), 112)
                                       ELSE CONVERT(NVARCHAR(8), DATEADD(dd, ISNULL(B.add_day ,(13*7)), CONVERT(DATETIME, P.horizon_end_date)), 112)   -- 추가기간이 NULL이면 디폴트 13주 설정 
                                  END	
	  --  SELECT @v_pet_date      = p.horizon_end_date 
			--,  @v_add_pet_date  = CONVERT(NVARCHAR(8), DATEADD(dd, ISNULL(B.add_day ,(13*7)), CONVERT(DATETIME, P.HORIZON_END_DATE)), 112)   -- 추가기간이 NULL이면 디폴트 13주 설정 
        FROM   dbo.scm_mst_plan p WITH(NOLOCK)
		/** 사업부별 추가계획기간 lookup으로 반영  **/ 
		LEFT OUTER JOIN 
			  (
				SELECT a.SEGMENT1 as DIVISION_ID 
                     , CASE WHEN @v_plan_group = 'BIZ' AND a.segment2 > 13 THEN 13
                            ELSE a.segment2 
                       END AS ADD_WEEK

                     , CASE WHEN @v_plan_group = 'BIZ' AND a.segment2 > 13 THEN (13*7)
                            ELSE (a.segment2 * 7)
                       END AS ADD_DAY
					 --, a.segment2 as ADD_WEEK , A.segment2*7 AS ADD_DAY 
				FROM   scm_adm_lookup_master_detail a(nolock)
				WHERE  a.lookup_type = 'ADD_PLAN_PERIOD'
				and    a.valid_yn    = 'Y' 
			  ) B
				ON ( 1=1
				AND  P.DIVISION_ID  =  B.DIVISION_ID )  
        WHERE  p.division_id = @p_division_id 
        AND    p.plan_id     = @p_plan_id 
		; 

        --CHECK 조건 추가, 2023.08.24 추가
        SELECT @n_capa_op_check_cnt = COUNT(b.segment2)
         FROM  scm_adm_lookup_master_detail a WITH(NOLOCK)
        INNER JOIN scm_adm_lookup_master_detail b WITH(NOLOCK)
           ON a.segment1= b.segment1
          AND a.lookup_type = 'LOCATION_GROUP'
          AND a.segment4    = 'Y' -- Capa 공정 여부 
          AND a.segment5    = 'N' -- Line 별 Capa 적용 공정( Capa공정여부가 'N'이면  Line 별 Capa 적용 공정이 'Y'가 될수없음)
          AND a.valid_yn    = 'Y'
          AND b.lookup_type = 'LOCATION_GROUP_ROUTE'
          AND b.valid_yn    = 'Y'
        --AND b.segment3    = 'Y' -- Capa 세부 공정 여부  (P5000 공정을 포함하기 위해 주석)   
        ;
        DELETE /* PR_SCP_ENG_IN_FN_PROC_OP_RES_GROUP_MAP_CAL */
		FROM   th_eng_op_res_group_map_cal_sn
		WHERE  master_id = @p_master_id 
		AND    plan_id   = @p_engine_plan_id 
		;

        -----------------------------------------------------------
		-- 1-0. 재사용 데이터 공통화 : 소형CAPA분리 & 튜닝, 2023.08.24 Start ~
        -- tact time / yield / bod cal mast 2023.08.24
        -----------------------------------------------------------
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 1-0 START';
        SET @v_description = N'1-0. 공통 임시 데이터 생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
        --1-1. fp tact time (M0~M1)
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
                  --월별 기간별 Tact Time 생성
                , ROW_NUMBER() OVER (PARTITION BY t.plant_id, t.operation_id, t.line_id, t.item_id, t.month ORDER BY t.tact_time ) row_num 
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
       --AND t.item_id = 'MACM348015A1-D03'
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

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 1-1 END';
        SET @v_description = N'1-1. FP T/T Temp 생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
        --1-2. fp yield (M0~M1)
        -----------------------------------------------------------
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
            , t.month    AS yyyymm 
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
        WHERE t.division_id  = @p_division_id 
          /* FP Tact Time 관리 기간 기준 (M0~M1) */ 
          AND t.month       >= LEFT(@p_plan_name,6)  
          AND t.month       <= CONVERT(NVARCHAR(6), DATEADD(m, 1, CONVERT(DATETIME,LEFT(@p_plan_name, 6) + '01')), 112) 
          /* 필요 데이터(계획 아이템)만 추출, 조건 추가, 2023.08.24 */
          AND t.item_id IN (SELECT x.item_id
                              FROM scm_mst_final_item_v x WITH(NOLOCK)
                             WHERE x.division_id = @p_division_id --40
                               AND x.operation_group_Id IN ('A', 'P')
                           )        
          /* 대상 CAPA 공정만 2023.08.24 */          
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
          BY op.flow_id, t.division_id, t.plant_id, t.line_id, t.item_id, t.month
        ;

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 1-2 END';
        SET @v_description = N'1-2. FP Yield(~M1) Temp 생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
        --1-3. fp yield (M2~) : 소형 CAPA 분리 공정만
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#scm_mst_fp_yield_temp1') IS NOT NULL
        BEGIN 
            DROP TABLE  #scm_mst_fp_yield_temp1;          
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
            , t.month    AS yyyymm 
            , MIN(CASE WHEN t.yield <= 0 THEN 1
                       WHEN t.yield > 1 THEN 1
                       ELSE ISNULL(t.yield, 1)
                    END
                    ) AS yield -- 누적수율은 곱해야 하나 일단 MIN 값으로 처리함  
         INTO #scm_mst_fp_yield_temp1 
         FROM dbo.scm_mst_yield_ver_h_v t     WITH (NOLOCK)    -- PJ20209642 변경  scm_mst_yield_sn
         JOIN dbo.scm_mst_operation_flow_v op WITH(NOLOCK)
           ON t.division_id  = op.division_id
          AND t.company_id   = op.company_id
          AND t.site_id      = op.site_id
          AND t.operation_id = op.operation_id
        WHERE t.division_id  = IIF(@p_division_id='40', '40', 'X') --소형만 CAPA분리 / 그것도 특정공정만
          /* 계획수립구간 조건 */ 
          AND t.month       > CONVERT(NVARCHAR(6), DATEADD(m, 1, CONVERT(DATETIME,LEFT(@p_plan_name, 6) + '01')), 112)    
          AND t.month       <= LEFT(@v_pet_date, 6) 
          /* 대상 공정/아이템 */ 
          AND t.operation_id IN ('A3000', 'A9000')          
          AND t.item_id IN (SELECT x.item_id
                              FROM scm_mst_final_item_v x WITH(NOLOCK)
                             WHERE x.division_id = @p_division_id
                               AND x.operation_group_Id IN ('A')
                           )        
        GROUP 
          BY op.flow_id, t.division_id, t.plant_id, t.line_id, t.item_id, t.month
        ;

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 1-3 END';
        SET @v_description = N'1-3. FP Yield(M2~) Temp 생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
		--1-0. 재사용 데이터 공통화 : 소형CAPA분리 & 튜닝, 2023.08.24 ~ End
        --1-4. eng bor cal master 
        -----------------------------------------------------------

        IF OBJECT_ID('tempdb..#th_eng_op_res_group_map_cal_mst') IS NOT NULL
        BEGIN 
            DROP TABLE  #th_eng_op_res_group_map_cal_mst;          
        END

        /* BOR Cal Master 생성,  2023.08.24
           하드코딩값 수정/보완, 2023.11.23
        */
        ;WITH VW_MONTH_PERIOD AS (
                                SELECT a.bucket_month   
                                     , a.bucket_type
                                     , CONVERT(VARCHAR(8), a.month_start_dttm, 112)                AS month_start_yyyymmdd
                                     , CONVERT(VARCHAR(8), DATEADD(day, 1, a.month_end_dttm), 112) AS month_end_yyyymmdd
                                     , a.bucket_descr
                                     , CASE WHEN a.bucket_month <= CONVERT(VARCHAR(6), DATEADD(m, 1, CONVERT(DATETIME, LEFT(@p_plan_name, 6) + '01')), 112) THEN  'FP'
                                            ELSE 'SCP'
                                        END tact_time_gubun
                                 FROM
                                    ( 
                                    SELECT a.bucket_seq
	                                     , b.yyyymm          AS bucket_month
	                                     , a.start_dttm      AS bucket_yyyymmdd
	                                     , a.bucket_type
                                         , MIN(a.start_dttm) OVER (PARTITION BY b.yyyymm) AS month_start_dttm 
                                         , MAX(a.start_dttm) OVER (PARTITION BY b.yyyymm) AS month_end_dttm 
                                         , ROW_NUMBER()      OVER (PARTITION BY b.yyyymm 
                                                                       ORDER BY a.start_dttm) AS month_seq 
                                         , descr             AS bucket_descr
                                    FROM th_eng_bucket_info_sn a WITH(NOLOCK)
                                    JOIN scm_mst_bucket        b WITH(NOLOCK) --month 구간 구하기
                                      ON a.start_dttm  = CONVERT(DATETIME, b.yyyymmdd)
                                   WHERE a.master_id   = @p_master_id
                                     AND a.plan_id     = @p_engine_plan_id
                                     AND a.descr       = 'PLAN'      
                                    ) a
                                WHERE a.month_seq = 1
                                )       
        SELECT b.division_id
             , a.master_id  
             , a.plan_id
             , b.plant_id
             , b.scm_site_id  AS plant_site_id
             , a.site_id 
             , a.route_id
             , a.operation_id
             , a.item_id
             , a.resource_map_id
             , a.resource_group_id
             , SUBSTRING(a.resource_group_id, dbo.FN_CHARINDEX_REV(a.resource_group_id, '::', 0)+2, 100) AS line_id
             , x.bucket_month
             , x.month_start_yyyymmdd
             , x.month_end_yyyymmdd
             , a.resource_map_level
             , a.alt_priority
             , a.tact_time     --defalut value 셋팅
             , a.tact_time_uom
             , 1 AS yield       --defalut value 셋팅
             , a.good_rate
             , a.batch_rate
             , a.descr
             , a.consume_res_rate
             , a.prepare_time_uom
             , x.tact_time_gubun
         INTO #th_eng_op_res_group_map_cal_mst
         FROM th_eng_op_res_group_map_sn a WITH(NOLOCK)
         JOIN scm_mst_site_eng           b WITH(NOLOCK)
           ON a.site_id = b.eng_scm_site_id
         JOIN (
              SELECT *
                FROM VW_MONTH_PERIOD x
               WHERE 1=1 --x.tact_time_gubun = 'FP'
             ) x
           ON 1=1
        WHERE a.master_id = @p_master_id
          AND a.plan_id   = @p_engine_plan_id
          AND a.descr IN ('CAPA', 'LINE_CAPA') 
          AND a.resource_map_level = 1
          AND b.modeling_id = @p_modeling_id
          AND b.plan_id     = @p_plan_id
          AND b.plan_type   = @p_plan_type
          AND b.plan_seq    = @p_seq
        --ORDER BY b.plant_id, a.operation_id, a.resource_group_id, a.item_id, x.month_start_yyyymmdd
        ;

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 1-4 END';
        SET @v_description = N'1-4. eng bor cal master Temp 생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
		-- 2-0. CAPA공정 (Line Modeling 비대상 공정)에 대해, 기간별 BOR 데이터 생성 CAPA분리 & 튜닝, 2023.08.24 Start ~
        -- tact time / yield / bod cal mast 2023.08.24
        -----------------------------------------------------------

        --대상 공정이 존재할때만, 로직 탈 수 있게 조건추가 2023.08.24
        IF @n_capa_op_check_cnt > 0

        BEGIN

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 2-0 START';
        SET @v_description = N'2-0. Capa 공정(Line Modling 비대상 공정의 기간별 BOR 생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		-----------------------------------------------------------
		-- 임시테이블 생성
        -----------------------------------------------------------

/***************************************************
공통화로 불필요 임시 테이블 및 로직 정리 , 2023.08.24

        [CAPA라인 관련 임시 테이블 정리 후 공통화]
        #tact_op_flow_temp_1       -> #tmp_capa_flow_tact_time
	    #tact_op_flow_temp_2       -> #tmp_capa_flow_no_tact_time
        #tact_op_flow_temp         -> #tmp_capa_flow_merge_tact_time
	    #th_eng_op_res_group_map_1 -> #th_eng_op_res_group_map_capa
	    #yield_op_flow_temp        -> #tmp_line_capa_flow_yield

        -----------------------------------------------------------
		-- 2. Capa 공정 : Line Modeling 비대상 공정
        --                Item별 평균 Tact Time 사용
        -----------------------------------------------------------
        -----------------------------------------------------------
		-- 2-1) 임시테이블 생성 ( scm_mst_tact_time_ver_h_v, scm_mst_operation_flow_v 조인테이블)
        -----------------------------------------------------------
        --  참고)  scm_mst_tact_time_ver_h_v의 'operation_id는 단일 공정의 값만 가지지만
        --         th_eng_op_res_group_map_sn의 route_id(=operation_id)값은 'A5000A6000'와 같이 여러공정값이 연결된값을 가지므로 
        --         scm_mst_tact_time_ver_h_v의 조인처리를 위해서 이작업이 필요함 
        --  임시 테이블 재정의 (#tact_op_flow_temp_1 -> #tmp_capa_flow_tact_time : 임시 CAPA공정(~M+2) tact time 생성 ), 2023.08.24
        -----------------------------------------------------------
        -----------------------------------------------------------
		-- 2-1)-2) 임시테이블 생성 (FP용 tact_time(scm_mst_tact_time테이블)에서 당월, 차월 데이터중 누락된 월 생성)
        --  임시 테이블 재정의 (#tact_op_flow_temp_2 -> #tmp_capa_flow_no_tact_time : 임시 CAPA공정 no tact time ), 2023.08.24
        -----------------------------------------------------------
        -----------------------------------------------------------
		-- 2-1)-3)  위 1-1)-1), 1-1)-2) 합치기
        --          - "FP용에서 당월, 차월 누락된 월 tact time정보" 와  "FP용 tact_time 당월, 차월 tact time정보"       
        --  임시 테이블 재정의 (#tact_op_flow_temp -> #tmp_capa_flow_merge_tact_time : 임시 CAPA공정 merge tact time ), 2023.08.24
        -----------------------------------------------------------        
        -----------------------------------------------------------
		-- 2-1)-4)  th_eng_op_res_group_map_sn 정보를 이용해서 month 당월, 차월 데이터 생성
        --  임시 테이블 재정의 (#th_eng_op_res_group_map_1 -> #th_eng_op_res_group_map_capa : CAPA공정 op res group map 생성 ), 2023.08.24
        -----------------------------------------------------------
        -----------------------------------------------------------
		-- 2-1)-5)  th_eng_op_res_group_map_sn 에만 존재하는 tact time 정보 추가 INSERET
        --         - FP용 tact time정보에 존재하지 않는 tact time 정보를 위 1-1)-3)에서 생성한 #tmp_capa_flow_merge_tact_time 테이블에 추가 INSERT
        -----------------------------------------------------------
        -----------------------------------------------------------
		-- 2-2) 임시테이블 생성 ( scm_mst_yield_ver_h_v, scm_mst_operation_flow_v 조인테이블)
        -----------------------------------------------------------
        --  참고)  scm_mst_yield_ver_h_v의 'operation_id는 단일 공정의 값만 가지지만
        --         th_eng_op_res_group_map_sn의 route_id(=operation_id)값은 'A5000A6000'와 같이 여러공정값이 연결된값을 가지므로 
        --         scm_mst_yield_ver_h_v의 조인처리를 위해서 이작업이 필요함   
        --  임시 테이블 재정의 (#yield_op_flow_temp -> #tmp_capa_flow_yield : CAPA공정 yield ), 2023.08.24
        -----------------------------------------------------------

 공통화로 불필요 임시 테이블 및 로직 정리 , 2023.08.24
 *****************************************************/
        -----------------------------------------------------------	
        -----------------------------------------------------------
		-- 2-1) CAPA 대상 / 라인 비대상 모델링 INSERT,  쿼리 튜닝 및 소형CAPA 분리 로직 수정/보완, 2023.08.24
        --      해당 공정/기간(FP 구간(~M1)에 대한 T/T, Yield 생성
        -----------------------------------------------------------	
        INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_OP_RES_GROUP_MAP_CAL */ th_eng_op_res_group_map_cal_sn
            (  master_id
    		 , plan_id
    		 , site_id
    		 , route_id
    		 , operation_id
    		 , item_id
             , resource_map_id
    		 , resource_group_id
             , start_dttm
    		 , end_dttm
             , sub_resource_map_id
    		 , resource_map_level
             , alt_priority
    		 , tact_time
    		 , tact_time_uom
    		 , yield
             , good_rate
    		 , batch_rate
             , is_use
             , descr
    		 , consume_res_rate
    		 , prepare_time
    		 , prepare_time_uom
            )
         SELECT @p_master_id
             , @p_engine_plan_id             
             --, a.plant_id
             , a.site_id
             , a.route_id
             , a.operation_id
             , a.item_id
             , a.resource_map_id
             , a.resource_group_id
             , a.month_start_yyyymmdd
             , a.month_end_yyyymmdd
             , NULL                 AS sub_resource_map_id
             , a.resource_map_level AS resource_map_level
             , a.alt_priority       AS alt_priority 
             , CASE /* 1. 소형 CAPA 분리 반영 (T/T : Tact Time)
                           [T/T  ] 1순위 : SCP 소형 CAPA T/T, 2순위 : FP T/T, 3순위 : SCP T/T, 4순위 : Default T/T 
                           [Yield] 1순위 : FP Yield, 2순위 : SCP Yield, 3순위 : Default Yield 
                      */
                    WHEN a.division_id  = '40' AND a.operation_id IN ('A3000', 'A9000') THEN 
                         /* 1순위 : SCP2 tact tiem. 2순위 : FP tact time, 3순위 : SCP tact time, 4순위 : 최신 fp tact time */           
                         --ISNULL(ISNULL(ISNULL(e.tact_time, b.tact_time), d.tact_time) * ISNULL(c.yield, ISNULL(d.yield, a.yield)), a.tact_time)  
                         ROUND(ISNULL(ISNULL(ISNULL(e.tact_time, b.tact_time), d.tact_time) * ISNULL(c.yield, ISNULL(d.yield, a.yield)), a.tact_time),3,1) --2023.10.10 수정
                    ELSE 
                    /* 2. 그외 기존 로직 그대로 */
                         ISNULL(ISNULL(b.tact_time, d.tact_time) * ISNULL(c.yield, ISNULL(d.yield, a.yield))
                                                                                                             , a.tact_time)
                END
                                    AS tact_time  --T/T(투입) 값 소숫점 세자리로 절삭 로직 추가 필요, (엔진에서 소숫점 3자리 1/1000초 단위 계산)                                       
             , a.tact_time_uom 
               /* 모든 값이 NULL이면, Default = 1로 셋팅 */
             , ISNULL(ISNULL(c.yield, ISNULL(d.yield, a.yield)),1)
                                    AS yield
             , a.good_rate
             , a.batch_rate
               /* 1. 소형 CAPA관리 공정(A3000/A9000)의 경우, T/T이 없으면 비가동구간으로 처리
                  2. 그외는 계산된 T/T이 0이면, N 처리
                */
             , CASE WHEN a.division_id  = '40' AND a.operation_id IN ('A3000', 'A9000') THEN CASE WHEN e.tact_time IS NULL THEN 'N'
                                                                                                  ELSE 'Y'
                                                                                              END
                    ELSE 
                          CASE WHEN ISNULL(ISNULL(b.tact_time, d.tact_time) * ISNULL(c.yield, ISNULL(d.yield, a.yield))
                                                                                                             , a.tact_time) = 0 THEN 'N'
                               ELSE 'Y'
                           END
                END
                                    AS is_use  --( N : 비가동 CAL)
             , a.descr              AS descr
             , a.consume_res_rate
             , NULL                 AS prepare_time
             , NULL                 AS prepare_time_uom
          FROM #th_eng_op_res_group_map_cal_mst a
          LEFT OUTER JOIN (
                          SELECT a.division_id
                               , a.eng_scm_site_id
                               , a.flow_id
                               , '-'              AS line_id
                               , a.item_id
                               , a.yyyymm
                               , AVG(a.tact_time) AS tact_time
                            FROM #scm_mst_fp_tact_time_temp a WITH(NOLOCK)
                           GROUP 
                              BY a.division_id
                               , a.eng_scm_site_id
                               , a.flow_id
                               , a.item_id
                               , a.yyyymm
                          ) b  --FP T/T
            ON a.site_id  = b.eng_scm_site_id
           AND a.route_id = b.flow_id
           AND a.item_id      = b.item_id
           AND a.bucket_month = b.yyyymm       
          LEFT OUTER JOIN (
                            SELECT a.division_id
                                 , a.eng_scm_site_id
                                 , a.flow_id
                                 , '-'              AS line_id
                                 , a.item_id
                                 , a.yyyymm
                                 , AVG(a.yield)     AS yield
                              FROM #scm_mst_fp_yield_temp a WITH(NOLOCK)
                             WHERE a.yield > '0'
                             GROUP 
                                BY a.division_id
                                 , a.eng_scm_site_id
                                 , a.flow_id
                                 , a.item_id
                                 , a.yyyymm
                          ) c     --FP Yiled
            ON a.site_id      = c.eng_scm_site_id
           AND a.route_Id     = c.flow_id
           AND a.item_id      = c.item_id
           AND a.bucket_month = c.yyyymm
          LEFT OUTER JOIN (
                            SELECT division_id
                                 , plant_site_id + '~***' AS eng_scm_site_id
                                 , item_id
                                 , operation_id
                                 , AVG(tact_time)         AS tact_time
                                 -- 수율 0 또는 NULL은 1로 처리함                                 
                                 ,  MIN(CASE WHEN yield <= 0 THEN 1
                                             WHEN yield > 1 THEN 1
                                             ELSE ISNULL(yield, 1)
                                         END
                                        )                 AS yield      
                                 FROM scp_mst_tact_time WITH (NOLOCK)
                                WHERE division_id = @p_division_id
                                  AND valid_yn    = 'Y'
                                  AND tact_time   > 0
                                GROUP 
                                   BY division_id
                                    , plant_site_id
                                    , item_id
                                    , operation_id
                          ) d --SCP Tact Time / Yield
            ON a.site_id      = d.eng_scm_site_id
           AND a.operation_id = d.operation_id
           AND a.item_id      = d.item_id    
          LEFT OUTER JOIN (
                           SELECT a.division_id
                                , a.plant_id
                                , a.operation_id
                                , CASE WHEN SUBSTRING(a.operation_id, 1, 1) = 'E' THEN a.plant_id + '-E~***'
                                       WHEN SUBSTRING(a.operation_id, 1, 1) = 'S' THEN a.plant_id + '-E~***' -- SRS => 전극
                                       WHEN SUBSTRING(a.operation_id, 1, 1) = 'A' THEN a.plant_id + '-A~***'
                                       WHEN SUBSTRING(a.operation_id, 1, 1) = 'F' THEN a.plant_id + '-A~***' -- 활성화 => CELL
                                       WHEN SUBSTRING(a.operation_id, 1, 1) = 'P' THEN a.plant_id + '-P~***'
                                  END  AS eng_scm_site_id
                                , a.item_id
                                , a.yyyymm
                                  /* SCP Daily Capa 수량을 Tact Time(Sec)으로 변환 */
                              --, AVG(ROUND((60 * 60 * 24)/a.value, 3))   AS tact_time
                                , AVG(ROUND((60 * 60 * 24)/a.value, 3,1)) AS tact_time --소숫점 3자리 절삭 로직으로 변경, 2023.10.10
                         FROM SCP_MST_CAPA a WITH (NOLOCK)
                        WHERE a.division_id  = '40'       
                          AND a.operation_id IN ('A3000', 'A9000')  --CELL 조립 생산공정만 적용
                          /* 계획수립구간 조건 */
                          AND a.yyyymm       >= LEFT(@p_plan_name, 6)   
                          AND a.yyyymm       <= LEFT(@v_pet_date, 6)
                          AND a.value        > 0
                        GROUP 
                           BY  a.division_id
                             , a.plant_id
                             , a.operation_id
                             , a.item_id
                             , a.yyyymm
                          ) e --SCP 소형 Tact Time
            ON a.site_id      = e.eng_scm_site_id
           AND a.operation_id = e.operation_id
           AND a.item_id      = e.item_id    
           AND a.bucket_month = e.yyyymm
         /* FP 기준정보 관리 구간 M0~M+1 */
         WHERE a.tact_time_gubun  =  'FP'
           AND a.descr = 'CAPA'
        ;           

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 2-1 END';
        SET @v_description = N'2-1. CAPA 대상 기간별(M0~M1) BOR 생성 ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
		-- 2-2) CAPA 대상 / 라인 비대상 모델링 INSERT,  쿼리 튜닝 및 소형CAPA 분리 로직 수정/보완, 2023.08.24
        --      해당 공정/기간(FP 구간外(M2~)에 대한 T/T, Yield 생성
        -----------------------------------------------------------	
        INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_OP_RES_GROUP_MAP_CAL */ th_eng_op_res_group_map_cal_sn
            (  master_id
    		 , plan_id
    		 , site_id
    		 , route_id
    		 , operation_id
    		 , item_id
             , resource_map_id
    		 , resource_group_id
             , start_dttm
    		 , end_dttm
             , sub_resource_map_id
    		 , resource_map_level
             , alt_priority
    		 , tact_time
    		 , tact_time_uom
    		 , yield
             , good_rate
    		 , batch_rate
             , is_use
             , descr
    		 , consume_res_rate
    		 , prepare_time
    		 , prepare_time_uom
            )
        SELECT @p_master_id
             , @p_engine_plan_id             
             --, a.plant_id
             , a.site_id
             , a.route_id
             , a.operation_id
             , a.item_id
             , a.resource_map_id
             , a.resource_group_id
             , a.month_start_yyyymmdd
             , a.month_end_yyyymmdd
             , NULL                 AS sub_resource_map_id
             , a.resource_map_level AS resource_map_level
             , a.alt_priority       AS alt_priority 
             , CASE  /* 1. 소형 CAPA 분리 반영 (T/T : Tact Time)
                           [T/T  ] 1순위 : SCP 소형 CAPA T/T, 2순위 : SCP T/T, 3순위 : Default T/T 
                           [Yield] 1순위 : FP Yield, 2순위 : SCP Yield, 3순위 : Default Yield 
                      */
                     WHEN a.division_id  = '40' AND a.operation_id IN ('A3000', 'A9000') THEN 
                         --ISNULL(ISNULL(c.tact_time, b.tact_time) * ISNULL(d.yield, ISNULL(b.yield, a.yield)) , a.tact_time) 
                         ROUND(ISNULL(ISNULL(c.tact_time, b.tact_time) * ISNULL(d.yield, ISNULL(b.yield, a.yield)) , a.tact_time),3,1) --2023.10.10 수정 
                     /* 2. 그외 기존 로직
                           [T/T  ] 1순위 : SCP T/T, 2순위 : 최신 Default T/T 
                           [Yield] 1순위 : SCP Yield, Default Yield 
                      */   
                     ELSE  
                         ISNULL(b.tact_time * ISNULL(b.yield, a.yield)
                                                                      , a.tact_time)
                END
                                    AS tact_time  --T/T(투입) 값 소숫점 세자리로 절삭 로직 추가 필요, (엔진에서 소숫점 3자리 1/1000초 단위 계산)                                     
             , a.tact_time_uom 
             , CASE WHEN a.division_id  = '40' AND a.operation_id IN ('A3000', 'A9000') THEN ISNULL(ISNULL(d.yield, ISNULL(b.yield, a.yield)),1)
                    ELSE ISNULL(ISNULL(b.yield, a.yield),1)
                 END                AS yield
             , a.good_rate
             , a.batch_rate
                /* 1. 소형 CAPA관리 공정(A3000/A9000)의 경우, T/T이 없으면 비가동구간으로 처리
                  2. 그외는 계산된 T/T이 0이면, N 처리
                */
             , CASE WHEN a.division_id  = '40' AND a.operation_id IN ('A3000', 'A9000') THEN CASE WHEN c.tact_time IS NULL THEN 'N'
                                                                                                  ELSE 'Y'
                                                                                              END
                    ELSE 
                          CASE WHEN ISNULL(b.tact_time * ISNULL(b.yield, a.yield)
                                                                      , a.tact_time) = 0 THEN 'N'
                               ELSE 'Y'
                           END
               END
                                    AS is_use  --( N : 비가동 CAL)
             , a.descr              AS descr
             , a.consume_res_rate
             , NULL                 AS prepare_time
             , NULL                 AS prepare_time_uom
          FROM #th_eng_op_res_group_map_cal_mst a
          LEFT OUTER JOIN (
                            SELECT division_id
                                 , plant_site_id + '~***' AS eng_scm_site_id
                                 , item_id
                                 , operation_id
                                 , AVG(tact_time)         AS tact_time
                                 -- 수율 0 또는 NULL은 1로 처리함                                 
                                 ,  MIN(CASE WHEN yield <= 0 THEN 1
                                             WHEN yield > 1 THEN 1
                                             ELSE ISNULL(yield, 1)
                                         END
                                        )                 AS yield      
                                 FROM scp_mst_tact_time WITH (NOLOCK)
                                WHERE division_id = @p_division_id
                                  AND valid_yn    = 'Y'
                                  AND tact_time   > 0
                                GROUP 
                                   BY division_id
                                    , plant_site_id
                                    , item_id
                                    , operation_id
                          ) b --SCP Tact Time / Yield
            ON a.site_id      = b.eng_scm_site_id
           AND a.operation_id = b.operation_id
           AND a.item_id      = b.item_id    
          LEFT OUTER JOIN (
                           SELECT a.division_id
                                , a.plant_id
                                , a.operation_id
                                , CASE WHEN SUBSTRING(a.operation_id, 1, 1) = 'E' THEN a.plant_id + '-E~***'
                                       WHEN SUBSTRING(a.operation_id, 1, 1) = 'S' THEN a.plant_id + '-E~***' -- SRS => 전극
                                       WHEN SUBSTRING(a.operation_id, 1, 1) = 'A' THEN a.plant_id + '-A~***'
                                       WHEN SUBSTRING(a.operation_id, 1, 1) = 'F' THEN a.plant_id + '-A~***' -- 활성화 => CELL
                                       WHEN SUBSTRING(a.operation_id, 1, 1) = 'P' THEN a.plant_id + '-P~***'
                                  END  AS eng_scm_site_id
                                , a.item_id
                                , a.yyyymm
                                  /* SCP Daily Capa 수량을 Tact Time(Sec)으로 변환 */
                              --, AVG(ROUND((60 * 60 * 24)/a.value, 3)) AS tact_time
                                , AVG(ROUND((60 * 60 * 24)/a.value, 3,1)) AS tact_time --소숫점 3자리 절삭 로직으로 변경, 2023.10.10
                         FROM SCP_MST_CAPA a WITH (NOLOCK)
                        WHERE a.division_id  = '40'       
                          AND a.operation_id IN ('A3000', 'A9000')  --CELL 조립 생산공정만 적용
                          /* 계획수립구간 조건 */
                          AND a.yyyymm       >= LEFT(@p_plan_name, 6)   
                          AND a.yyyymm       <= LEFT(@v_pet_date, 6)
                          AND a.value        > 0
                        GROUP 
                           BY  a.division_id
                             , a.plant_id
                             , a.operation_id
                             , a.item_id
                             , a.yyyymm
                          ) c --SCP 소형 Tact Time
            ON a.site_id      = c.eng_scm_site_id
           AND a.operation_id = c.operation_id
           AND a.item_id      = c.item_id    
           AND a.bucket_month = c.yyyymm
         LEFT OUTER JOIN (
                            SELECT a.division_id
                                 , a.eng_scm_site_id
                                 , a.flow_id
                                 , '-'              AS line_id
                                 , a.item_id
                                 , a.yyyymm
                                 , AVG(a.yield)     AS yield
                              FROM #scm_mst_fp_yield_temp1 a WITH(NOLOCK)
                             WHERE a.yield > '0'
                             GROUP 
                                BY a.division_id
                                 , a.eng_scm_site_id
                                 , a.flow_id
                                 , a.item_id
                                 , a.yyyymm
                          ) d     --FP Yield (소형 CAPA분리 공정만, M+2~)
            ON a.site_id      = d.eng_scm_site_id
           AND a.route_Id     = d.flow_id
           AND a.item_id      = d.item_id
           AND a.bucket_month = d.yyyymm  
         /* SCP 기준정보 관리 구간 M2~ */
         WHERE a.tact_time_gubun  =  'SCP'
           AND a.descr = 'CAPA'
           AND NOT EXISTS ( SELECT 'X'
                              FROM th_eng_op_res_group_map_cal_sn x WITH(NOLOCK) 
                             WHERE x.master_id         = @p_master_id
                               AND x.plan_id           = @p_engine_plan_id
                               AND x.site_id           = a.site_id 
                               AND x.route_id          = a.route_id 
                               AND x.operation_id      = a.operation_id 
                               AND x.item_id           = a.item_id 
                               AND x.resource_map_id   = a.resource_map_id 
                               AND x.resource_group_id = a.resource_group_id 
                               AND x.start_dttm        = a.month_start_yyyymmdd
                               AND x.end_dttm          = a.month_end_yyyymmdd
                        ) 
        ;

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 2-2 END';
        SET @v_description = N'2-2. CAPA 대상 기간별(M2~) BOR 생성 ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

/* ORG 소스 : ~ 2023.08.24
        INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_OP_RES_GROUP_MAP_CAL */ th_eng_op_res_group_map_cal_sn
        (  master_id
		 , plan_id
		 , site_id
		 , route_id
		 , operation_id
		 , item_id
         , resource_map_id
		 , resource_group_id
         , start_dttm
		 , end_dttm
         , sub_resource_map_id
		 , resource_map_level
         , alt_priority
		 , tact_time
		 , tact_time_uom
		 , yield
         , good_rate
		 , batch_rate
         , is_use
         , descr
		 , consume_res_rate
		 , prepare_time
		 , prepare_time_uom
        )
        SELECT res.master_id
		     , res.plan_id
			 , res.site_id
			 , res.route_id
			 , res.operation_id
			 , res.item_id
             , res.resource_map_id
			 , res.resource_group_id
             , ISNULL(tat.start_dttm, CONVERT(DATETIME, @p_plan_name))  AS start_dttm
             , ISNULL(tat.end_dttm, CONVERT(DATETIME, @v_add_pet_date)) AS end_dttm    -- 2022.01.17 @v_pet_date ->  @v_add_pet_date 으로 변경
             , res.sub_resource_map_id
			 , res.resource_map_level
             , res.alt_priority			 
             --, ISNULL(tat.tact_time, res.tact_time)
			 -- Input용 Tact Time은 수율을 곱해서 적용함
			 --20180405 수정 ( 당월,차월은 FP의 tact_time  및 yield정보, 그이후는 scp관리(scp_mst_tact_time의 tact_time,yield) yield사용함 )
             , ISNULL(CASE WHEN tat.start_dttm <  DATEADD(m, 2, CONVERT(DATETIME,LEFT(@p_plan_name, 6) + '01'))  
                                THEN ISNULL(ISNULL(tat.tact_time, smtt.tact_time) * ISNULL(yld.yield, ISNULL(smtt.yield, res.yield))
                                          , res.tact_time)
                           ELSE ISNULL(smtt.tact_time * ISNULL(smtt.yield,1)
                                     , res.tact_time)
                      END, res.tact_time)  AS tact_time --  (변경전 : , ISNULL(tat.tact_time, res.tact_time) * ISNULL(yld.yield, res.yield) )
             , res.tact_time_uom
              --20180405 수정 ( 당월,차월은 FP의 yield정보, 그이후는 scp관리(scp_mst_tact_time의 yield) yield사용함 )
             , CASE WHEN tat.start_dttm <  DATEADD(m, 2, CONVERT(DATETIME,LEFT(@p_plan_name, 6) + '01'))  THEN ISNULL(yld.yield, ISNULL(smtt.yield, res.yield))
                    ELSE ISNULL(smtt.yield, 1)
               END  AS yield -- 20180405 수정 (변경전 : , ISNULL(yld.yield, res.yield) AS yield  --20180313 수정 (변경전 : , res.yield) )
             , res.good_rate
			 , res.batch_rate
             , CASE WHEN ISNULL(CASE WHEN tat.start_dttm <  DATEADD(m, 2, CONVERT(DATETIME,LEFT(@p_plan_name, 6) + '01'))  
                                          THEN ISNULL(ISNULL(tat.tact_time, smtt.tact_time) * ISNULL(yld.yield, ISNULL(smtt.yield, res.yield))
                                                      , res.tact_time)
                                     ELSE ISNULL(smtt.tact_time * ISNULL(smtt.yield,1)
                                                 , res.tact_time)
                      END, res.tact_time) = 0 THEN 'N'  
                    ELSE 'Y'
               END AS is_use  --20180605 추가 (변경전 : , 'Y' AS is_use -- 뒤에서 추가 Update 처리함 )                
             , res.descr
			 , res.consume_res_rate
			 , res.prepare_time
			 , res.prepare_time_uom
        FROM  (SELECT g.*
                    , s.plant_id
                   -- Line Modeling 비대상 : Line 정보 제거
                   -- , SUBSTRING(g.resource_group_id, dbo.FN_CHARINDEX_REV(g.resource_group_id, '::', 0)+2, 100) AS line_id -- Line Capa 비대상이면 '-' 로 들어옴
               FROM   th_eng_op_res_group_map_sn g WITH(NOLOCK)
                    , scm_mst_site_eng           s WITH(NOLOCK)
               WHERE  g.master_id   = @p_master_id
               AND    g.plan_id     = @p_engine_plan_id
               AND    s.modeling_id = @p_modeling_id
               AND    s.plan_id     = @p_plan_id
               AND    s.plan_type   = @p_plan_type
               AND    s.plan_seq    = @p_seq
               AND    g.site_id     = s.eng_scm_site_id
               -- Capa 적용 대상 공정
               AND    g.descr       = 'CAPA'
              ) res
              LEFT OUTER JOIN 
                 (SELECT t.division_id
                       , t.plant_id
                       , t.flow_id --
                       , '-' AS line_id -- Line Capa 비대상이면 '-' 로 들어옴
                       , t.item_id
                       , t.month    -- Tact Time 존재 구간
                       , buc.start_dttm
                       , buc.end_dttm                       
                       , t.tact_time --
                       , t.eng_scm_site_id --
                  FROM   #tmp_capa_flow_merge_tact_time t WITH(NOLOCK)                  
				      , (				  
                         SELECT b.master_id, b.plan_id, b.month
                              , CASE WHEN b.seq = 1 THEN b.start_dttm -- 첫째 월   : Plan 시작일
                                     ELSE b.month_date                -- 둘째 이후 : 매월 1일
                                END start_dttm
                              , CASE WHEN b.seq_r = 1 AND b.month  = b.month_end THEN b.end_dttm                    -- 마지막 주가 Normal 인 경우  : Plan 종료일
                                     WHEN b.seq_r = 1 AND b.month <> b.month_end THEN DATEADD(MM, 1, b.month_date)  -- 마지막 주가 Partial 인 경우 : 차월 1일 : 아래 UNION 으로 마지막 월 정보 추가
                                     ELSE DATEADD(MM, 1, b.month_date)                                              --                             : 차월 1일
                                END end_dttm
                         FROM  (	
                                SELECT master_id
                                     , plan_id
                                     , CONVERT(CHAR(6), start_dttm, 112) AS month
                                     , CONVERT(CHAR(6), MAX(end_dttm), 112) AS month_end
                                     , CONVERT(DATETIME, CONVERT(CHAR(6), start_dttm, 112)+'01') AS month_date -- 당월 1일
                                     , MIN(start_dttm) AS start_dttm
                                     , MAX(end_dttm)   AS end_dttm
                                     , ROW_NUMBER() OVER(ORDER BY master_id, plan_id, CONVERT(CHAR(6), start_dttm, 112) DESC) AS seq_r
                                     , ROW_NUMBER() OVER(ORDER BY master_id, plan_id, CONVERT(CHAR(6), start_dttm, 112))      AS seq
                                FROM   th_eng_bucket_info_sn  WITH(NOLOCK)
                                WHERE  master_id = @p_master_id
                                AND    plan_id   = @p_engine_plan_id
                                GROUP BY master_id, plan_id, CONVERT(CHAR(6), start_dttm, 112)		
            				   ) b
                         -- 마지막 주가 Partial 인 경우 마지막 월 정보 추가
                         UNION 
                         SELECT b.master_id, b.plan_id, b.month
                              , CONVERT(DATETIME, month_end+'01') AS start_dttm
                              , b.end_dttm                        AS end_dttm
                         FROM  (	
                                SELECT master_id
                                     , plan_id
                                     , CONVERT(CHAR(6), start_dttm, 112) AS month
                                     , CONVERT(CHAR(6), MAX(DATEADD(DD, -1, end_dttm)), 112) AS month_end  -- 일요일 기준 월
                                     , CONVERT(DATETIME, CONVERT(CHAR(6), start_dttm, 112)+'01') AS month_date -- 당월 1일
                                     , MIN(start_dttm) AS start_dttm
                                     , MAX(end_dttm)   AS end_dttm
                                     , ROW_NUMBER() OVER(ORDER BY master_id, plan_id, CONVERT(CHAR(6), start_dttm, 112) DESC) AS seq_r
                                     , ROW_NUMBER() OVER(ORDER BY master_id, plan_id, CONVERT(CHAR(6), start_dttm, 112))      AS seq
                                FROM   th_eng_bucket_info_sn  WITH(NOLOCK)
                                WHERE  master_id = @p_master_id
                                AND    plan_id   = @p_engine_plan_id
                                GROUP BY master_id, plan_id, CONVERT(CHAR(6), start_dttm, 112)		
            		           ) b
                         WHERE  b.seq_r  = 1
                         AND    b.month <> b.month_end
                       ) buc                  
                  WHERE  t.division_id = @p_division_id
                  AND    t.month      >= SUBSTRING(@p_plan_name, 1, 6)
                  AND    t.month     <   CONVERT(NVARCHAR(6), DATEADD(m, 2, CONVERT(DATETIME,LEFT(@p_plan_name, 6) + '01')), 112) -- 20180425 추가 (당월, 차월 까지만 조회되게하기위해서)
                  AND    t.month     = buc.month
                  GROUP BY t.division_id, t.plant_id, t.flow_id, t.item_id, t.month    -- Tact Time 존재 구간
                         , buc.start_dttm, buc.end_dttm
                         , t.tact_time, t.eng_scm_site_id                  
				 -- 차월이후 부터는 SCP용 Tact Time 정보를 사용하기 위해서  tact_time 값을 NULL 처리함 ( 위 INSERT부분에서 SCP용 tact time값을 적용함, 차월이후는 bucket_info 월 기준으로 생성됨)
                  UNION
                  SELECT t.division_id
                       , t.plant_id
                       , t.flow_id --
                       , '-' AS line_id -- Line Capa 비대상이면 '-' 로 들어옴
                       , t.item_id
                       , buc.month    -- Tact Time 미존재 미래 구간
                       , buc.start_dttm
                       , buc.end_dttm
                       
                       , NULL AS tact_time  --20180425 수정 ( 차월이후는 scp의 tact_time(scp_mst_tact_time.tact_time) 정보 사용하면되므로 null 처리함) (변경전 : , t.tact_time)
                       , t.eng_scm_site_id  --
                  FROM   #tmp_capa_flow_merge_tact_time t WITH(NOLOCK)
				      , (SELECT t.division_id
                              , t.plant_id
                              , t.flow_id
                              , t.line_id
                              , t.item_id
                              , MAX(t.month) AS month
                         FROM   #tmp_capa_flow_merge_tact_time t WITH(NOLOCK)
                         WHERE  t.division_id = @p_division_id
                         AND    t.month      >= SUBSTRING(@p_plan_name, 1, 6)
                         GROUP BY t.division_id, t.plant_id, t.flow_id, t.line_id, t.item_id
                       ) tm
                  
				      , (				  
                         SELECT b.master_id, b.plan_id, b.month
                              , CASE WHEN b.seq = 1 THEN b.start_dttm -- 첫째 월   : Plan 시작일
                                     ELSE b.month_date                -- 둘째 이후 : 매월 1일
                                END start_dttm
                              , CASE WHEN b.seq_r = 1 AND b.month  = b.month_end THEN b.end_dttm                    -- 마지막 주가 Normal 인 경우  : Plan 종료일
                                     WHEN b.seq_r = 1 AND b.month <> b.month_end THEN DATEADD(MM, 1, b.month_date)  -- 마지막 주가 Partial 인 경우 : 차월 1일 : 아래 UNION 으로 마지막 월 정보 추가
                                     ELSE DATEADD(MM, 1, b.month_date)                                              --                             : 차월 1일
                                END end_dttm
                         FROM  (	
                                SELECT master_id
                                     , plan_id
                                     , CONVERT(CHAR(6), start_dttm, 112) AS month
                                     , CONVERT(CHAR(6), MAX(end_dttm), 112) AS month_end
                                     , CONVERT(DATETIME, CONVERT(CHAR(6), start_dttm, 112)+'01') AS month_date -- 당월 1일
                                     , MIN(start_dttm) AS start_dttm
                                     , MAX(end_dttm)   AS end_dttm
                                     , ROW_NUMBER() OVER(ORDER BY master_id, plan_id, CONVERT(CHAR(6), start_dttm, 112) DESC) AS seq_r
                                     , ROW_NUMBER() OVER(ORDER BY master_id, plan_id, CONVERT(CHAR(6), start_dttm, 112))      AS seq
                                FROM   th_eng_bucket_info_sn  WITH(NOLOCK)
                                WHERE  master_id = @p_master_id
                                AND    plan_id   = @p_engine_plan_id
                                GROUP BY master_id, plan_id, CONVERT(CHAR(6), start_dttm, 112)		
            				   ) b
                         -- 마지막 주가 Partial 인 경우 마지막 월 정보 추가
                         UNION 
                         SELECT b.master_id, b.plan_id, b.month
                              , CONVERT(DATETIME, month_end+'01') AS start_dttm
                              , b.end_dttm                        AS end_dttm
                         FROM  (	
                                SELECT master_id
                                     , plan_id
                                     , CONVERT(CHAR(6), start_dttm, 112) AS month
                                     , CONVERT(CHAR(6), MAX(DATEADD(DD, -1, end_dttm)), 112) AS month_end  -- 일요일 기준 월
                                     , CONVERT(DATETIME, CONVERT(CHAR(6), start_dttm, 112)+'01') AS month_date -- 당월 1일
                                     , MIN(start_dttm) AS start_dttm
                                     , MAX(end_dttm)   AS end_dttm
                                     , ROW_NUMBER() OVER(ORDER BY master_id, plan_id, CONVERT(CHAR(6), start_dttm, 112) DESC) AS seq_r
                                     , ROW_NUMBER() OVER(ORDER BY master_id, plan_id, CONVERT(CHAR(6), start_dttm, 112))      AS seq
                                FROM   th_eng_bucket_info_sn  WITH(NOLOCK)
                                WHERE  master_id = @p_master_id
                                AND    plan_id   = @p_engine_plan_id
                                GROUP BY master_id, plan_id, CONVERT(CHAR(6), start_dttm, 112)		
            		           ) b
                         WHERE  b.seq_r  = 1
                         AND    b.month <> b.month_end
                       ) buc
                  WHERE  t.division_id  = @p_division_id
                  AND    t.division_id  = tm.division_id
                  AND    t.plant_id     = tm.plant_id
                  AND    t.flow_id      = tm.flow_id --
                  AND    t.line_id      = tm.line_id
                  AND    t.item_id      = tm.item_id
                  AND    t.month        = tm.month
                  AND    buc.month      > t.month
                  GROUP BY t.division_id, t.plant_id, t.flow_id, t.item_id, buc.month    -- Tact Time 존재 구간
                         , buc.start_dttm, buc.end_dttm
                         , t.tact_time, t.eng_scm_site_id 
                 ) tat
               ON  res.site_id      = tat.eng_scm_site_id -- 
               AND res.route_id     = tat.flow_id  --     
              -- Line Modeling 비대상 : Line 정보 제거
              --   AND res.line_id      = tat.line_id
               AND res.item_id      = tat.item_id
              --20180313 YIELD 처리 추가
               LEFT OUTER JOIN 
                 (SELECT t.division_id
                       , t.plant_id
                       , t.flow_id --
                       , '-' AS line_id -- Line Capa 비대상이면 '-' 로 들어옴
                       , t.item_id
                       , t.month    -- yiled 존재 구간
                       , buc.start_dttm
                       , buc.end_dttm                       
                       , t.yield --
                       , t.eng_scm_site_id --
                  FROM  #tmp_capa_flow_yield t WITH(NOLOCK)                  
				      , (				  
                         SELECT b.master_id, b.plan_id, b.month
                              , CASE WHEN b.seq = 1 THEN b.start_dttm -- 첫째 월   : Plan 시작일
                                     ELSE b.month_date                -- 둘째 이후 : 매월 1일
                                END start_dttm
                              , CASE WHEN b.seq_r = 1 AND b.month  = b.month_end THEN b.end_dttm                    -- 마지막 주가 Normal 인 경우  : Plan 종료일
                                     WHEN b.seq_r = 1 AND b.month <> b.month_end THEN DATEADD(MM, 1, b.month_date)  -- 마지막 주가 Partial 인 경우 : 차월 1일 : 아래 UNION 으로 마지막 월 정보 추가
                                     ELSE DATEADD(MM, 1, b.month_date)                                              --                             : 차월 1일
                                END end_dttm
                         FROM  (	
                                SELECT master_id
                                     , plan_id
                                     , CONVERT(CHAR(6), start_dttm, 112) AS month
                                     , CONVERT(CHAR(6), MAX(end_dttm), 112) AS month_end
                                     , CONVERT(DATETIME, CONVERT(CHAR(6), start_dttm, 112)+'01') AS month_date -- 당월 1일
                                     , MIN(start_dttm) AS start_dttm
                                     , MAX(end_dttm)   AS end_dttm
                                     , ROW_NUMBER() OVER(ORDER BY master_id, plan_id, CONVERT(CHAR(6), start_dttm, 112) DESC) AS seq_r
                                     , ROW_NUMBER() OVER(ORDER BY master_id, plan_id, CONVERT(CHAR(6), start_dttm, 112))      AS seq
                                FROM   th_eng_bucket_info_sn  WITH(NOLOCK)
                                WHERE  master_id = @p_master_id
                                AND    plan_id   = @p_engine_plan_id
                                GROUP BY master_id, plan_id, CONVERT(CHAR(6), start_dttm, 112)		
            				   ) b
                         -- 마지막 주가 Partial 인 경우 마지막 월 정보 추가
                         UNION 
                         SELECT b.master_id, b.plan_id, b.month
                              , CONVERT(DATETIME, month_end+'01') AS start_dttm
                              , b.end_dttm                        AS end_dttm
                         FROM  (	
                                SELECT master_id
                                     , plan_id
                                     , CONVERT(CHAR(6), start_dttm, 112) AS month
                                     , CONVERT(CHAR(6), MAX(DATEADD(DD, -1, end_dttm)), 112) AS month_end  -- 일요일 기준 월
                                     , CONVERT(DATETIME, CONVERT(CHAR(6), start_dttm, 112)+'01') AS month_date -- 당월 1일
                                     , MIN(start_dttm) AS start_dttm
                                     , MAX(end_dttm)   AS end_dttm
                                     , ROW_NUMBER() OVER(ORDER BY master_id, plan_id, CONVERT(CHAR(6), start_dttm, 112) DESC) AS seq_r
                                     , ROW_NUMBER() OVER(ORDER BY master_id, plan_id, CONVERT(CHAR(6), start_dttm, 112))      AS seq
                                FROM   th_eng_bucket_info_sn  WITH(NOLOCK)
                                WHERE  master_id = @p_master_id
                                AND    plan_id   = @p_engine_plan_id
                                GROUP BY master_id, plan_id, CONVERT(CHAR(6), start_dttm, 112)		
            		           ) b
                         WHERE  b.seq_r  = 1
                         AND    b.month <> b.month_end
                       ) buc
                  WHERE  t.division_id = @p_division_id
                  AND    t.month      >= SUBSTRING(@p_plan_name, 1, 6)
                  AND    t.month      <  CONVERT(NVARCHAR(6), DATEADD(m, 2, CONVERT(DATETIME,LEFT(@p_plan_name, 6) + '01')), 112) -- 20180425 추가 (당월, 차월 까지만 조회되게하기위해서)
                  AND    t.month       = buc.month
                  GROUP BY t.division_id, t.plant_id, t.flow_Id, t.item_id, t.month    -- yield 존재 구간
                         , buc.start_dttm, buc.end_dttm
                         , t.yield, t.eng_scm_site_id 
				 -- 차월이후 부터는 SCP용 yield 정보를 사용하기 위해서  yield 값을 NULL 처리함 ( 위 INSERT부분에서 SCP용 yield 값을 적용함, 차월이후는 bucket_info 월 기준으로 생성됨)
                  UNION
                  SELECT t.division_id
                       , t.plant_id
                       , t.flow_id --
                       , '-' AS line_id -- Line Capa 비대상이면 '-' 로 들어옴
                       , t.item_id
                       , buc.month    -- yield 미존재 미래 구간
                       , buc.start_dttm
                       , buc.end_dttm                      
                       , NULL AS yield       --20180425 수정 ( 차월이후는 scp의 yield(scp_mst_tact_time.yield) 정보 사용하면되므로 null 처리함) (변경전 : , t.yield )
                       , t.eng_scm_site_id -- 
                  FROM  #tmp_capa_flow_yield t WITH(NOLOCK)
				      , (SELECT t.division_id
                              , t.plant_id
                              , t.flow_id --
                              , t.line_id
                              , t.item_id
                              , MAX(t.month) AS month
                         FROM   #tmp_capa_flow_yield t WITH(NOLOCK)
                         WHERE  t.division_id = @p_division_id
                         AND    t.month      >= SUBSTRING(@p_plan_name, 1, 6)
                         GROUP BY t.division_id, t.plant_id, t.flow_id, t.line_id, t.item_id
                       ) tm                  
				      , (				  
                         SELECT b.master_id, b.plan_id, b.month
                              , CASE WHEN b.seq = 1 THEN b.start_dttm -- 첫째 월   : Plan 시작일
                                     ELSE b.month_date                -- 둘째 이후 : 매월 1일
                                END start_dttm
                              , CASE WHEN b.seq_r = 1 AND b.month  = b.month_end THEN b.end_dttm                    -- 마지막 주가 Normal 인 경우  : Plan 종료일
                                     WHEN b.seq_r = 1 AND b.month <> b.month_end THEN DATEADD(MM, 1, b.month_date)  -- 마지막 주가 Partial 인 경우 : 차월 1일 : 아래 UNION 으로 마지막 월 정보 추가
                                     ELSE DATEADD(MM, 1, b.month_date)                                              --                             : 차월 1일
                                END end_dttm
                         FROM  (	
                                SELECT master_id
                                     , plan_id
                                     , CONVERT(CHAR(6), start_dttm, 112) AS month
                                     , CONVERT(CHAR(6), MAX(end_dttm), 112) AS month_end
                                     , CONVERT(DATETIME, CONVERT(CHAR(6), start_dttm, 112)+'01') AS month_date -- 당월 1일
                                     , MIN(start_dttm) AS start_dttm
                                     , MAX(end_dttm)   AS end_dttm
                                     , ROW_NUMBER() OVER(ORDER BY master_id, plan_id, CONVERT(CHAR(6), start_dttm, 112) DESC) AS seq_r
                                     , ROW_NUMBER() OVER(ORDER BY master_id, plan_id, CONVERT(CHAR(6), start_dttm, 112))      AS seq
                                FROM   th_eng_bucket_info_sn  WITH(NOLOCK)
                                WHERE  master_id = @p_master_id
                                AND    plan_id   = @p_engine_plan_id
                                GROUP BY master_id, plan_id, CONVERT(CHAR(6), start_dttm, 112)		
            				   ) b
                         -- 마지막 주가 Partial 인 경우 마지막 월 정보 추가
                         UNION 
                         SELECT b.master_id, b.plan_id, b.month
                              , CONVERT(DATETIME, month_end+'01') AS start_dttm
                              , b.end_dttm                        AS end_dttm
                         FROM  (	
                                SELECT master_id
                                     , plan_id
                                     , CONVERT(CHAR(6), start_dttm, 112) AS month
                                     , CONVERT(CHAR(6), MAX(DATEADD(DD, -1, end_dttm)), 112) AS month_end  -- 일요일 기준 월
                                     , CONVERT(DATETIME, CONVERT(CHAR(6), start_dttm, 112)+'01') AS month_date -- 당월 1일
                                     , MIN(start_dttm) AS start_dttm
                                     , MAX(end_dttm)   AS end_dttm
                                     , ROW_NUMBER() OVER(ORDER BY master_id, plan_id, CONVERT(CHAR(6), start_dttm, 112) DESC) AS seq_r
                                     , ROW_NUMBER() OVER(ORDER BY master_id, plan_id, CONVERT(CHAR(6), start_dttm, 112))      AS seq
                                FROM   th_eng_bucket_info_sn  WITH(NOLOCK)
                                WHERE  master_id = @p_master_id
                                AND    plan_id   = @p_engine_plan_id
                                GROUP BY master_id, plan_id, CONVERT(CHAR(6), start_dttm, 112)		
            		           ) b
                         WHERE  b.seq_r  = 1
                         AND    b.month <> b.month_end
                       ) buc
                  WHERE  t.division_id  = @p_division_id
                  AND    t.division_id  = tm.division_id
                  AND    t.plant_id     = tm.plant_id
                  AND    t.flow_id      = tm.flow_id --
                  AND    t.line_id      = tm.line_id
                  AND    t.item_id      = tm.item_id
                  AND    t.month        = tm.month
                  AND    buc.month      > t.month
                  GROUP BY t.division_id, t.plant_id, t.flow_id, t.item_id, buc.month    -- yield 존재 구간
                         , buc.start_dttm, buc.end_dttm
                         , t.yield, t.eng_scm_site_id --
                 ) yld
               --ON    res.plant_id     = yld.plant_id
              ON    res.site_id      = yld.eng_scm_site_id 
                AND res.route_id     = yld.flow_id --
                 -- Line Modeling 비대상 : Line 정보 제거
                 --   AND res.line_id      = yld.line_id
                AND res.item_id      = yld.item_id
                AND tat.start_dttm   = yld.start_dttm 
                AND tat.end_dttm     = yld.end_dttm               
              --20180405 추가 SCP 관리 tact_time, yield 정보
              LEFT JOIN ( SELECT division_id,  plant_site_id + '~***' AS eng_scm_site_id, item_id, operation_id
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
              ON  res.site_id      = smtt.eng_scm_site_id
              AND res.item_id      = smtt.item_id 
              AND res.operation_id LIKE smtt.operation_id + '%' --20181004 수정(변경전 : AND res.operation_id = smtt.operation_id)
        WHERE  res.resource_map_level = 1
		;
*/

        END  --//IF 조건 END (Capa 공정이면서, Line Modeling 비대상 CAPA 공정) 
        -----------------------------------------------------------
		-- 2-0. CAPA공정 (Line Modeling 비대상 공정)에 대해, 기간별 BOR 데이터 생성 CAPA분리 & 튜닝, ~ 2023.08.24 End ~
        -----------------------------------------------------------

        -----------------------------------------------------------
		-- 3. CAPA공정 (Line Modeling 대상 공정)에 대해, 기간별 BOR 데이터 생성 CAPA분리 & 튜닝,  2023.08.24 ~ Start
        --                Line/Item별 지정된 Tact Time 사용 => OP RES GROUP MAP에 반영되어 있으므로 CAL에서는 별도 처리하지 않음
        -----------------------------------------------------------
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 3-0 START';
        SET @v_description = N'3-0. Line Capa 대상 기간별 BOR 생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        
/***************************************************
공통화로 불필요 임시 테이블 및 로직 정리 , 2023.08.24

	    #tact_op_flow_temp2_temp -> #tmp_line_capa_flow_tact_time
	    #tact_op_flow_temp2_2    -> #tmp_line_capa_flow_no_tact_time
	    #tact_op_flow_temp2      -> #tmp_line_capa_flow_merge_tact_time	
	    #th_eng_op_res_group_map -> #th_eng_op_res_group_map_line_capa
	    #yield_op_flow_temp2     -> #tmp_line_capa_flow_yield
	
	    #TH_ENG_OP_RES_GROUP_MAP_CAL  -> #th_eng_op_res_group_map_line_capa_cal
	    #TH_ENG_OP_RES_GROUP_MAP_CAL2 -> #th_eng_op_res_group_map_line_capa_cal2
	
	    [기타]
	    #DIV_TH_ENG_OP_RES_GROUP_MAP_CAL -> #div_th_eng_op_res_group_map_cal	
	    #TH_ENG_OP_RES_GROUP_MAP_CAL_ADD -> #th_eng_op_res_group_map_cal_add	
	    #TH_ENG_OP_RES_GROUP_MAP_CAL_OSP_L -> #th_eng_op_res_group_map_cal_osp_l
	    #DIV_TH_ENG_OP_RES_GROUP_MAP_CAL_OSP_L  -> #div_th_eng_op_res_group_map_cal_osp_l
	    #TH_ENG_OP_RES_GROUP_MAP_CAL_ADD_OSP_L  -> #th_eng_op_res_group_map_cal_add_osp_l
      		-- 3-1)-1) 임시테이블 생성 ( scm_mst_tact_time_ver_h_v, scm_mst_operation_flow_v 조인테이블)
        --         - 당월, 차월의 셀,팩 데이터의 tact_time 생성함                     
        /*    
            1) 셀, 팩은 scm_mst_tact_time_ver_h_v.daily_capa 값 사용  (참고) daily_capa 하루동안 생산가능개수이므로 tact_time(1개 생산시간(초단위))으로 환산하기위해서는  "86400초(1일) / daily_capa(1일생산개수)"  처리함)
            2) 소숫점 4번째자리에서 반올림처리함   
            3) 비사용(비활성) LINE 사용제외 (비사용 LINE : scm_mst_item_line_assign_sn.priority IN (0, 9) )
            4) flow_id 구하기 위해서 scm_mst_tact_time_ver_h_v 과 scm_mst_operation_flow_v의 operation_id로 조인 
            5) scm_mst_tact_time_ver_h_v.month 당월(플랜시작월(=LEFT(@p_plan_name, 6)), 차월(플랜시작월+1개월) 데이터만 사용함
        */
        -----------------------------------------------------------
        --  참고)  scm_mst_tact_time_ver_h_v의 'operation_id는 단일 공정의 값만 가지지만
        --         th_eng_op_res_group_map_sn의 route_id(=operation_id)값은 'A5000A6000'와 같이 다중공정 값을 가지므로 
        --         scm_mst_tact_time_ver_h_v의 조인처리를 위해서 이작업이 필요함 
        --  임시 테이블 재정의 (#tact_op_flow_temp2_temp -> #tmp_line_capa_flow_tact_time : Line Capa공정에 대한 tact time ), 2023.08.24
        -----------------------------------------------------------
        -----------------------------------------------------------
		-- 3-1)-2) 임시테이블 생성 (FP용 tact_time(scm_mst_tact_time테이블)에서 당월, 차월 데이터중 누락된 월 생성)
        --  임시 테이블 재정의 (#tact_op_flow_temp2_2 -> #tmp_line_capa_flow_no_tact_time : Line Capa공정에 대한 no tact time ), 2023.08.24
        -----------------------------------------------------------
        -----------------------------------------------------------
		-- 3-1)-3)  위 2-1)-1), 2-1)-2) UNION ALL 처리한 임시테이블 생성
        --          - "FP용에서 당월, 차월 누락된 월 tact time정보" 와  "FP용 tact_time 당월, 차월 tact time정보"       
        --  임시 테이블 재정의 (#tact_op_flow_temp2 -> #tmp_line_capa_flow_merge_tact_time : Line Capa공정에 대한 merge tact time ), 2023.08.24
        -----------------------------------------------------------
        -----------------------------------------------------------
		-- 3-1)-4)  th_eng_op_res_group_map_sn 정보를 이용해서 month 당월, 차월 데이터 생성
        --  임시 테이블 재정의 (#th_eng_op_res_group_map -> #th_eng_op_res_group_map_line_capa : Line Capa공정에 대한 op res group ), 2023.08.24
        -----------------------------------------------------------
        -----------------------------------------------------------
		-- 3-1)-5)  th_eng_op_res_group_map_sn 에만 존재하는 tact time 정보 추가 INSERET
        --         - FP용 tact time정보에 존재하지 않는 tact time 정보를 위 2-1)-3)에서 생성한 #tmp_line_capa_flow_merge_tact_time 테이블에 추가 INSERT
        -----------------------------------------------------------
        -----------------------------------------------------------
		-- 3-2) 임시테이블 생성 ( scm_mst_yield_ver_h_v, scm_mst_operation_flow_v 조인테이블)
        -----------------------------------------------------------
        --  참고)  scm_mst_yield_ver_h_v의 'operation_id는 단일 공정의 값만 가지지만
        --         th_eng_op_res_group_map_sn의 route_id(=operation_id)값은 'A5000A6000'와 같이 여러공정값이 연결된값을 가지므로 
        --         scm_mst_yield_ver_h_v의 조인처리를 위해서 이작업이 필요함   
        --  임시 테이블 재정의 (#yield_op_flow_temp2 -> #tmp_line_capa_flow_yield : Line Capa공정에 대한 op res group ), 2023.08.24
        -----------------------------------------------------------

*/
		-----------------------------------------------------------
			-- 임시테이블 생성
        -- 임시 테이블 재정의 (#TH_ENG_OP_RES_GROUP_MAP_CAL  -> #th_eng_op_res_group_map_line_capa_cal : Line Capa공정에 대한 op res group cal ), 2023.08.24
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#th_eng_op_res_group_map_line_capa_cal') IS NOT NULL
        BEGIN 
            DROP TABLE  #th_eng_op_res_group_map_line_capa_cal;          
        END

        CREATE TABLE #th_eng_op_res_group_map_line_capa_cal
            (
	          MASTER_ID nvarchar(50) NOT NULL
	        , PLAN_ID nvarchar(50) NOT NULL
	        , SITE_ID nvarchar(50) NOT NULL
	        , ROUTE_ID nvarchar(50) NOT NULL
	        , OPERATION_ID nvarchar(50) NOT NULL
	        , ITEM_ID nvarchar(50) NOT NULL
	        , RESOURCE_MAP_ID nvarchar(80) NOT NULL
	        , RESOURCE_GROUP_ID nvarchar(80) NOT NULL
	        , START_DTTM datetime NOT NULL
	        , END_DTTM datetime NOT NULL
	        , SUB_RESOURCE_MAP_ID nvarchar(150) NULL
	        , RESOURCE_MAP_LEVEL numeric(20, 10) NULL DEFAULT ((1))
	        , ALT_PRIORITY numeric(20, 10) NULL
	        , TACT_TIME numeric(20, 10) NOT NULL
	        , TACT_TIME_UOM nvarchar(10) NULL DEFAULT ('SECOND')
	        , YIELD numeric(20, 10) NULL DEFAULT ((1))
	        , GOOD_RATE numeric(20, 10) NULL
	        , BATCH_RATE numeric(20, 10) NULL
	        , IS_USE nvarchar(1) NULL DEFAULT ('Y')
	        , DESCR nvarchar(2000) NULL
	        , CONSUME_RES_RATE numeric(20, 10) NULL
	        , PREPARE_TIME numeric(20, 10) NULL DEFAULT ((0))
	        , PREPARE_TIME_UOM nvarchar(10) NULL DEFAULT ('HOUR')
            --기존테이블에 없는 컬럼1(scp_mst_tact_time 사용여부)
            , SCP_TACT_TIME_USE_YN nvarchar(10) NULL  
            --기존테이블에 없는 컬럼2
            , LINE_ID nvarchar(10) NULL
	        , PLANT_SITE_ID nvarchar(50)  NULL
            )
        ;

        -----------------------------------------------------------
		-- 3. CAPA공정 (Line Modeling 대상 공정)에 대해, 기간별 BOR 데이터 생성 CAPA분리 & 튜닝
        -- 3-1.해당 공정/기간(FP 구간(~M1)에 대한 T/T, Yield 생성
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_OP_RES_GROUP_MAP_CAL */ #th_eng_op_res_group_map_line_capa_cal
                (  master_id
		         , plan_id
		         , site_id
		         , route_id
		         , operation_id
		         , item_id
                 , resource_map_id
		         , resource_group_id
                 , start_dttm
		         , end_dttm
                 , sub_resource_map_id
		         , resource_map_level
                 , alt_priority
		         , tact_time
		         , tact_time_uom
		         , yield
                 , good_rate
		         , batch_rate
                 , is_use
                 , descr
		         , consume_res_rate
		         , prepare_time
		         , prepare_time_uom
                 , scp_tact_time_use_yn --기존테이블에 없는 컬럼1
                 , line_id              --기존테이블에 없는 컬럼2
		         , plant_site_id
                )
        SELECT @p_master_id
             , @p_engine_plan_id             
             --, a.plant_id
             , a.site_id
             , a.route_id
             , a.operation_id
             , a.item_id
             , a.resource_map_id
             , a.resource_group_id
             , a.month_start_yyyymmdd
             , a.month_end_yyyymmdd
             , NULL                 AS sub_resource_map_id
             , a.resource_map_level AS resource_map_level
             , a.alt_priority       AS alt_priority 
             , CASE /* 1. 소형 CAPA 분리 반영 (T/T : Tact Time)
                           [T/T  ] 1순위 : SCP 소형 CAPA T/T, 2순위 : FP T/T, 3순위 : SCP T/T, 4순위 : Default T/T 
                           [Yield] 1순위 : FP Yield, 2순위 : SCP Yield, 3순위 : Default Yield 
                      */
                    WHEN @p_division_id  = '40' AND a.operation_id IN ('A3000', 'A9000') THEN 
                         /* 1순위 : SCP2 tact tiem. 2순위 : FP tact time, 3순위 : SCP tact time, 4순위 : 최신 fp tact time */           
                         ISNULL(ISNULL(ISNULL(e.tact_time, b.tact_time), d.tact_time) * ISNULL(c.yield, ISNULL(d.yield, a.yield))
                                                                                                                                 , a.tact_time)   
                    ELSE 
                    /* 2. 그외 기존 로직 그대로 */
                         ISNULL(ISNULL(b.tact_time, d.tact_time) * ISNULL(c.yield, ISNULL(d.yield, a.yield))
                                                                                                             , a.tact_time)
                END
                                    AS tact_time  
             , a.tact_time_uom 
             , ISNULL(c.yield, ISNULL(d.yield, a.yield))
                                    AS yield
             , a.good_rate
             , a.batch_rate
               /* 1. 소형 CAPA관리 공정(A3000/A9000)의 경우, T/T이 없으면 비가동구간으로 처리
                  2. 그외는 계산된 T/T이 0이면, N 처리
                */
             , CASE WHEN a.division_id  = '40' AND a.operation_id IN ('A3000', 'A9000') THEN CASE WHEN e.tact_time IS NULL THEN 'N'
                                                                                                  ELSE 'Y'
                                                                                              END
                    ELSE 
                          CASE WHEN ISNULL(ISNULL(b.tact_time, d.tact_time) * ISNULL(c.yield, ISNULL(d.yield, a.yield))
                                                                                                             , a.tact_time) = 0 THEN 'N'
                               ELSE 'Y'
                           END
                END
                                    AS is_use  --( N : 비가동 CAL)
             , a.descr              AS descr
             , a.consume_res_rate
             , NULL                 AS prepare_time
             , NULL                 AS prepare_time_uom
               /* scp_tact_time_use_yn = 'Y'는 SCP EXCEPTION T/T 재등록 대상 
                  M0~M1은 FP Monthly T/T 유지, FP T/T 없다면, EXCEPTION T/T 대상
               */
               , CASE WHEN a.division_id  = '40' AND a.operation_id IN ('A3000', 'A9000') THEN 'N'
                      ELSE IIF((b.tact_time IS NULL AND d.tact_time IS NOT NULL), 'Y', 'N')                                                        
                  END               AS scp_tact_time_use_yn  
             , a.line_id            
             , a.plant_site_id      AS plant_site_id
             /* 참조
             , a.bucket_month
             , b.tact_time  AS fp_tact_time
             , c.yield      AS fp_yield
             , d.tact_time  AS scp_tact_time
             , d.yield      AS scp_yield
             , e.tact_time  AS scp2_tact_time --소형 CAPA만 관리
             , a.tact_time  AS default_tact_time
             , a.yield      AS default_yield
             */
          FROM #th_eng_op_res_group_map_cal_mst a
          LEFT OUTER JOIN #scm_mst_fp_tact_time_temp b  --FP T/T
            ON a.site_id  = b.eng_scm_site_id
           AND a.route_id = b.flow_id
           AND a.line_id  = b.line_id
           AND a.item_id  = b.item_id
           AND a.bucket_month = b.yyyymm       
          LEFT OUTER JOIN #scm_mst_fp_yield_temp c     --FP Yiled
            ON a.site_id      = c.eng_scm_site_id
           AND a.route_id     = c.flow_id                  --원래 소스 그래도 route_id로 연결 
           AND a.line_id      = c.line_id
           AND a.item_id      = c.item_id
           AND a.bucket_month = c.yyyymm
          LEFT OUTER JOIN (
                            SELECT division_id
                                ,  plant_site_id + '~***' AS eng_scm_site_id
                                , item_id
                                , operation_id
                                , line_id 
                                ,  tact_time
                                -- 수율 0 또는 NULL은 1로 처리함                                 
                                ,  CASE WHEN yield <= 0 THEN 1
                                        WHEN yield > 1 THEN 1
                                        ELSE ISNULL(yield, 1)
                                    END  AS yield      
                                 FROM scp_mst_tact_time WITH (NOLOCK)
                                WHERE division_id = @p_division_id
                                  AND valid_yn    = 'Y'   
                          ) d --SCP Tact Time / Yield
            ON a.site_id      = d.eng_scm_site_id
           AND a.route_id     = d.operation_id     --원래 소스 그래도 route_id로 연결
           AND a.line_id      = d.line_id
           AND a.item_id      = d.item_id    
          LEFT OUTER JOIN (
                           SELECT a.division_id
                                , a.plant_id
                                , a.operation_id
                                , CASE WHEN SUBSTRING(a.operation_id, 1, 1) = 'E' THEN a.plant_id + '-E~***'
                                       WHEN SUBSTRING(a.operation_id, 1, 1) = 'S' THEN a.plant_id + '-E~***' -- SRS => 전극
                                       WHEN SUBSTRING(a.operation_id, 1, 1) = 'A' THEN a.plant_id + '-A~***'
                                       WHEN SUBSTRING(a.operation_id, 1, 1) = 'F' THEN a.plant_id + '-A~***' -- 활성화 => CELL
                                       WHEN SUBSTRING(a.operation_id, 1, 1) = 'P' THEN a.plant_id + '-P~***'
                                  END  AS eng_scm_site_id
                                , a.item_id
                                , a.line_id
                                , a.yyyymm
                                  /* SCP Daily Capa 수량을 Tact Time(Sec)으로 변환 */
                              --, ROUND((60 * 60 * 24)/a.value, 3)   AS tact_time
                                , ROUND((60 * 60 * 24)/a.value, 3,1) AS tact_time    --소숫점 3자리 절삭 로직으로 변경, 2023.10.10                                
                                , a.value                          AS daily_capa
                                  /* item별 line별 Daily Capa 가장 작은 값 */
                                , ROW_NUMBER() OVER(PARTITION BY  a.division_id
                                                                , a.plant_id
                                                                , a.operation_id
                                                                , a.item_id
                                                                , a.line_id
                                                                , a.yyyymm
                                                        ORDER BY a.value
                                                    ) AS seq
                         FROM SCP_MST_CAPA a WITH (NOLOCK)
                        WHERE a.division_id  = '40'         
                          AND a.operation_id IN ('A3000', 'A9000')  --CELL 조립 생산공정만 적용
                          /* 계획수립구간 조건 */
                          AND a.yyyymm       >= LEFT(@p_plan_name, 6)   
                          AND a.yyyymm       <= LEFT(@v_pet_date, 6)
                          AND a.value        > 0    
                          ) e --SCP 소형 Tact Time
            ON a.site_id      = e.eng_scm_site_id
           AND a.operation_id = e.operation_id
           AND a.line_id      = e.line_id
           AND a.item_id      = e.item_id    
           AND a.bucket_month = e.yyyymm
           AND e.seq          = 1 
         /* FP 기준정보 관리 구간 M0~M+1 */
         WHERE a.tact_time_gubun  =  'FP'
           AND a.descr = 'LINE_CAPA'
        ;

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 3-1 END';
        SET @v_description = N'3-1. Line Capa 대상 기간별(FP구간) BOR 임시 데이터 생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        
        -----------------------------------------------------------
		-- 3. CAPA공정 (Line Modeling 대상 공정)에 대해, 기간별 BOR 데이터 생성 CAPA분리 & 튜닝
        -- 3-2.해당 공정/기간(FP 구간外(M2~)에 대한 T/T, Yield 생성
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_OP_RES_GROUP_MAP_CAL */ #th_eng_op_res_group_map_line_capa_cal
                (  master_id
		         , plan_id
		         , site_id
		         , route_id
		         , operation_id
		         , item_id
                 , resource_map_id
		         , resource_group_id
                 , start_dttm
		         , end_dttm
                 , sub_resource_map_id
		         , resource_map_level
                 , alt_priority
		         , tact_time
		         , tact_time_uom
		         , yield
                 , good_rate
		         , batch_rate
                 , is_use
                 , descr
		         , consume_res_rate
		         , prepare_time
		         , prepare_time_uom
                 , scp_tact_time_use_yn --기존테이블에 없는 컬럼1
                 , line_id              --기존테이블에 없는 컬럼2
		         , plant_site_id
                )
        SELECT @p_master_id
             , @p_engine_plan_id             
             --, a.plant_id
             , a.site_id
             , a.route_id
             , a.operation_id
             , a.item_id
             , a.resource_map_id
             , a.resource_group_id
             , a.month_start_yyyymmdd
             , a.month_end_yyyymmdd
             , NULL                 AS sub_resource_map_id
             , a.resource_map_level AS resource_map_level
             , a.alt_priority       AS alt_priority 
             , CASE  /* 1. 소형 CAPA 분리 반영 (T/T : Tact Time)
                           [T/T  ] 1순위 : SCP 소형 CAPA T/T, 2순위 : SCP T/T, 3순위 : Default T/T 
                           [Yield] 1순위 : FP Yield, 2순위 : SCP Yield, 3순위 : Default Yield 
                      */
                     WHEN a.division_id  = '40' AND a.operation_id IN ('A3000', 'A9000') THEN ISNULL(ISNULL(c.tact_time, b.tact_time) * ISNULL(d.yield, ISNULL(b.yield, a.yield)) , a.tact_time) 
                     /* 2. 그외 기존 로직
                           [T/T  ] 1순위 : SCP T/T, 2순위 : 최신 Default T/T 
                           [Yield] 1순위 : SCP Yield, Default Yield 
                      */   
                     ELSE  
                         ISNULL(b.tact_time * ISNULL(b.yield, a.yield)
                                                                      , a.tact_time)
                END
                                    AS tact_time  --T/T(투입) 값 소숫점 세자리로 절삭 로직 추가 필요, (엔진에서 소숫점 3자리 1/1000초 단위 계산)                                       
             , a.tact_time_uom 
             , CASE WHEN a.division_id  = '40' AND a.operation_id IN ('A3000', 'A9000') THEN ISNULL(d.yield, ISNULL(b.yield, a.yield))
                    ELSE ISNULL(b.yield, a.yield)
                 END                AS yield
             , a.good_rate
             , a.batch_rate
               /* 1. 소형 CAPA관리 공정(A3000/A9000)의 경우, T/T이 없으면 비가동구간으로 처리
                  2. 그외는 계산된 T/T이 0이면, N 처리
                */
             , CASE WHEN a.division_id  = '40' AND a.operation_id IN ('A3000', 'A9000') THEN CASE WHEN c.tact_time IS NULL THEN 'N'
                                                                                                  ELSE 'Y'
                                                                                              END
                    ELSE 
                          CASE WHEN ISNULL(b.tact_time * ISNULL(b.yield, a.yield)
                                                                      , a.tact_time) = 0 THEN 'N'
                               ELSE 'Y'
                           END
               END
                                    AS is_use  --( N : 비가동 CAL)
             , a.descr              AS descr
             , a.consume_res_rate
             , NULL                 AS prepare_time
             , NULL                 AS prepare_time_uom
               /* scp_tact_time_use_yn = 'Y'는 SCP EXCEPTION T/T 재등록 대상 */
             , CASE WHEN a.division_id = '40' AND a.operation_id IN ('A3000', 'A9000') THEN 'N'
                    ELSE CASE WHEN b.tact_time IS NOT NULL THEN 'Y'
                              ELSE 'N'
                         END                            
                  END             AS scp_tact_time_use_yn 
             , a.line_id
             , a.plant_site_id    AS plant_site_id
             /* 참조
             , a.bucket_month
             , b.tact_time  AS scp_tact_time
             , b.yield      AS scp_yield
             , c.tact_time  AS scp2_tact_time --소형 CAPA만 관리
             , a.tact_time  AS default_tact_time
             , a.yield      AS default_yield
             */
          FROM #th_eng_op_res_group_map_cal_mst a
          LEFT OUTER JOIN (
                            SELECT division_id
                                ,  plant_site_id + '~***' AS eng_scm_site_id
                                , item_id
                                , operation_id
                                , line_id 
                                ,  tact_time
                                -- 수율 0 또는 NULL은 1로 처리함                                 
                                ,  CASE WHEN yield <= 0 THEN 1
                                        WHEN yield > 1 THEN 1
                                        ELSE ISNULL(yield, 1)
                                    END  AS yield      
                                 FROM scp_mst_tact_time WITH (NOLOCK)
                                WHERE division_id = @p_division_id
                                AND valid_yn    = 'Y'   
                          ) b --SCP Tact Time / Yield
            ON a.site_id      = b.eng_scm_site_id
           AND a.operation_id = b.operation_id
           AND a.line_id      = b.line_id
           AND a.item_id      = b.item_id    
          LEFT OUTER JOIN (
                           SELECT a.division_id
                                , a.plant_id
                                , a.operation_id
                                , CASE WHEN SUBSTRING(a.operation_id, 1, 1) = 'E' THEN a.plant_id + '-E~***'
                                       WHEN SUBSTRING(a.operation_id, 1, 1) = 'S' THEN a.plant_id + '-E~***' -- SRS => 전극
                                       WHEN SUBSTRING(a.operation_id, 1, 1) = 'A' THEN a.plant_id + '-A~***'
                                       WHEN SUBSTRING(a.operation_id, 1, 1) = 'F' THEN a.plant_id + '-A~***' -- 활성화 => CELL
                                       WHEN SUBSTRING(a.operation_id, 1, 1) = 'P' THEN a.plant_id + '-P~***'
                                  END  AS eng_scm_site_id
                                , a.item_id
                                , a.line_id
                                , a.yyyymm
                                  /* SCP Daily Capa 수량을 Tact Time(Sec)으로 변환 */
                              --, ROUND((60 * 60 * 24)/a.value, 3)   AS tact_time
                                , ROUND((60 * 60 * 24)/a.value, 3,1) AS tact_time  --소숫점 3자리 절삭 로직으로 변경, 2023.10.10
                                , a.value                          AS daily_capa
                                    /* item별 line별 Daily Capa 가장 작은 값 */
                                , ROW_NUMBER() OVER(PARTITION BY  a.division_id
                                                                , a.plant_id
                                                                , a.operation_id
                                                                , a.item_id
                                                                , a.line_id
                                                                , a.yyyymm
                                                        ORDER BY a.value
                                                    ) AS seq
                        FROM SCP_MST_CAPA a WITH (NOLOCK)
                        WHERE a.division_id  = '40' --소형 CAPA 분리      
                          AND a.operation_id IN ('A3000', 'A9000')  --CELL 조립 생산공정만 적용
                          /* 계획수립구간 조건 */
                          AND a.yyyymm       >= LEFT(@p_plan_name, 6)   
                          AND a.yyyymm       <= LEFT(@v_pet_date, 6)
                          AND a.value        > 0    
                          ) c --SCP 소형 Tact Time
            ON a.site_id      = c.eng_scm_site_id
           AND a.operation_id = c.operation_id
           AND a.line_id      = c.line_id
           AND a.item_id      = c.item_id    
           AND a.bucket_month = c.yyyymm
           AND c.seq          = 1 
          LEFT OUTER JOIN #scm_mst_fp_yield_temp1 d     --FP Yield (M2~ 소형CAPA 분리 공정만)
            ON a.site_id      = d.eng_scm_site_id
           AND a.route_id     = d.flow_id                
           AND a.line_id      = d.line_id
           AND a.item_id      = d.item_id
           AND a.bucket_month = d.yyyymm
         /* FP 기준정보 관리 구간외(M+2~) */
         WHERE a.tact_time_gubun =  'SCP'
           AND a.descr = 'LINE_CAPA'
        ;

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 3-2 END';
        SET @v_description = N'3-2. Line Capa 대상 기간별(FP外구간) BOR 임시 데이터 생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        
        ---------------------------------------------------------------
        -- 3-3. 기간별 Line Priority 적용, 2024.05.20
        -- line assign NOT IN (0, 9) 일때
        ---------------------------------------------------------------
        IF OBJECT_ID('tempdb..#scm_mst_fp_line_assign_temp') IS NOT NULL
        BEGIN 
            DROP TABLE  #scm_mst_fp_line_assign_temp;   
        END

        --기간별 FP Line Assign 임시 데이터 생성
        SELECT a.division_id
             , a.company_id
             , a.site_id_org
             , a.plant_id  
             , a.site_id
             , a.route_id
             , a.operation_id
             , a.item_id
             , a.resource_group_id
             , a.start_dttm
             , a.end_dttm
             , a.is_use
             , a.alt_priority
             , a.descr
             , b.priority AS new_priority
        INTO #scm_mst_fp_line_assign_temp
        FROM  (SELECT b.division_id
                    , b.company_id
                    , b.site_id AS site_id_org
                    , b.plant_id  
                    , a.site_id
                    , a.route_id
                    , a.operation_id
                    , a.item_id
                    , a.resource_group_id
                    , a.start_dttm
                    , a.end_dttm
                    , a.is_use
                    , a.alt_priority
                    , a.plant_site_id
                    , a.line_id
                    , a.descr
                FROM #th_eng_op_res_group_map_line_capa_cal a 
               INNER JOIN (
                          SELECT b.*
                            FROM scm_mst_site_eng b WITH(NOLOCK)
                           WHERE b.modeling_id = @p_modeling_id 
                             AND b.plan_id     = @p_plan_id
                             AND b.plan_type   = @p_plan_type 
                             AND b.plan_seq    = @p_seq
                             AND b.division_id = @p_division_id  
                          ) b
                   ON a.site_id = b.eng_scm_site_id 
                WHERE a.descr   = 'LINE_CAPA'     
                  AND a.is_use  = 'Y'
            ) a
        INNER JOIN 
        (
        SELECT DISTINCT 
               b.company_id
             , b.division_id
             , b.site_id
             , b.plant_id
             , b.factory_id
             , b.item_id
             , b.operation_id
             , b.line_id
             , b.month
             , b.priority
          FROM dbo.scm_mst_item_line_assign_sn b with(nolock)
         WHERE b.division_id = @p_division_id 
           AND b.active_flag = 'Y'
           AND b.month      >= SUBSTRING(@p_plan_name, 1, 6)
           AND b.priority NOT IN (0, 9)           
           /* 필요 데이터(계획 아이템)만 추출 */
           AND b.item_id IN (SELECT x.item_id
                               FROM scm_mst_final_item_v x WITH(NOLOCK)
                              WHERE x.division_id = @p_division_id
                                AND x.operation_group_id in ('A', 'P')
                            )        
           AND b.operation_id IN ( SELECT b.segment2 AS operation_id
  			  			             FROM scm_adm_lookup_master_detail a WITH(NOLOCK)
  			  			           INNER JOIN scm_adm_lookup_master_detail b WITH(NOLOCK)
  			  			              ON a.segment1    = b.segment1
  			  			             AND a.lookup_type = 'LOCATION_GROUP'
  			  			             AND a.segment4    = 'Y'      -- capa 공정 여부 
  			  			           --AND a.segment5    = 'Y'      -- line 별 capa 적용 공정( capa공정여부가 'n'이면  line 별 capa 적용 공정이 'y'가 될수없음)
  			  			             AND a.valid_yn    = 'Y'
  			  			             AND b.lookup_type = 'LOCATION_GROUP_ROUTE'
  			  			             AND b.valid_yn    = 'Y'
  			  			           --AND b.segment3    = 'Y' -- capa 세부 공정 여부  (p5000 공정을 포함하기 위해 주석) 
                                     AND a.segment3 in ('A', 'P') -- 전극공정 제외
                                )              
             ) b
          ON a.company_id   = b.company_id
         AND a.division_id  = b.division_id
         AND a.site_id_org  = b.site_id
         AND a.plant_id     = b.plant_id
         AND a.operation_id = b.operation_id
         AND a.item_id      = b.item_id
         AND a.line_id      = b.line_id
         AND CONVERT(VARCHAR(6), a.start_dttm, 112) <= b.month
         AND CONVERT(VARCHAR(6), a.end_dttm, 112)   >  b.month
        ;

        /* 엔진 모델링(BOR)에 기간별 Line Priority UPDATE 
           Line Assign 관리 기준(월별) */
        UPDATE a
           SET a.alt_priority = b.new_priority
          FROM #th_eng_op_res_group_map_line_capa_cal a
         INNER JOIN ( 
                     SELECT a.site_id
                          , a.route_id
                          , a.operation_id
                          , a.item_id
                          , a.resource_group_id
                          , a.start_dttm
                          , a.end_dttm
                          , a.alt_priority
                          , b.new_priority
                          , ROW_NUMBER() OVER(PARTITION BY a.site_id
                                                         , a.route_id
                                                         , a.operation_id
                                                         , a.item_id
                                                         , a.resource_group_id
                                                         , a.start_dttm
                                                  ORDER BY a.end_dttm
                                             ) AS seq
                       FROM #th_eng_op_res_group_map_line_capa_cal a 
                      INNER JOIN
                            #scm_mst_fp_line_assign_temp b
                        ON a.site_id = b.site_id
                       AND a.route_id = b.route_id
                       AND a.operation_id = b.operation_id
                       AND a.item_id      = b.item_id
                       AND a.resource_group_Id = b.resource_group_id
                       AND CONVERT(VARCHAR(6), a.start_dttm, 112) = CONVERT(VARCHAR(6), b.start_dttm, 112)
                       /*
                       ORDER BY a.site_id, a.operation_id, a.item_id, a.start_dttm, a.end_dttm
                              , alt_priority, priority, a.resource_group_id
                       */
                     ) b
            ON a.site_id  = b.site_id
           AND a.route_id = b.route_id
           AND a.operation_id = b.operation_id
           AND a.item_id      = b.item_id
           AND a.start_dttm   = b.start_dttm
           AND a.resource_group_id = b.resource_group_id
         WHERE b.seq = 1
        ;

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 3-3 END';
        SET @v_description = N'3-3. LINE CAPA 대상중 LINE ASSIGN 데이터생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        ---------------------------------------------------------------
        -- 3-4. line assign IN (0, 9) 일때 is_use = 'N' 처리
        -- 임시 테이블 재정의 (#TH_ENG_OP_RES_GROUP_MAP_CAL2  -> #th_eng_op_res_group_map_line_capa_cal2 : Line Capa공정에 대한 op res group cal = 'N'), 2023.08.24
        ---------------------------------------------------------------
        IF OBJECT_ID('tempdb..#th_eng_op_res_group_map_line_capa_cal2') IS NOT NULL
        BEGIN 
            DROP TABLE #th_eng_op_res_group_map_line_capa_cal2;          
        END

        --//임시 테이블 정의, 소형 CAPA 분리, 2023.08.24
        --//1. CASE1. 사용하지 않는 라인 : priority =: 0, 9
        --//2. CASE2. Line Assign 테이블에 Assign 데이터가 아예 없는 경우 : Data가 아예 없는 경우
        --//※ 소형CAPA 분리 공정외는 exception tact time 테이블에 Line Assign Data가 없는 경우, 데이터 생성하지만,
        --// 소형CAPA 분리 공정은 exception tact time 데이터를 안 보고, SCP 월별 CAPA정보 기반으로 Tact Time 산정
        CREATE TABLE #th_eng_op_res_group_map_line_capa_cal2
            (
	          MASTER_ID nvarchar(50) NOT NULL
	        , PLAN_ID nvarchar(50) NOT NULL
	        , SITE_ID nvarchar(50) NOT NULL
	        , ROUTE_ID nvarchar(50) NOT NULL
	        , OPERATION_ID nvarchar(50) NOT NULL
	        , ITEM_ID nvarchar(50) NOT NULL
	        , RESOURCE_MAP_ID nvarchar(80) NOT NULL
	        , RESOURCE_GROUP_ID nvarchar(80) NOT NULL
	        , START_DTTM datetime NOT NULL
	        , END_DTTM datetime NOT NULL
	        , SUB_RESOURCE_MAP_ID nvarchar(150) NULL
	        , RESOURCE_MAP_LEVEL numeric(20, 10) NULL DEFAULT ((1))
	        , ALT_PRIORITY numeric(20, 10) NULL
	        , TACT_TIME numeric(20, 10) NOT NULL
	        , TACT_TIME_UOM nvarchar(10) NULL DEFAULT ('SECOND')
	        , YIELD numeric(20, 10) NULL DEFAULT ((1))
	        , GOOD_RATE numeric(20, 10) NULL
	        , BATCH_RATE numeric(20, 10) NULL
	        , IS_USE nvarchar(1) NULL DEFAULT ('Y')
	        , DESCR nvarchar(2000) NULL
	        , CONSUME_RES_RATE numeric(20, 10) NULL
	        , PREPARE_TIME numeric(20, 10) NULL DEFAULT ((0))
	        , PREPARE_TIME_UOM nvarchar(10) NULL DEFAULT ('HOUR')
            --기존테이블에 없는 컬럼1(scp_mst_tact_time 사용여부)
            , SCP_TACT_TIME_USE_YN nvarchar(10) NULL  
            --기존테이블에 없는 컬럼2
            , LINE_ID nvarchar(10) NULL
	        , PLANT_SITE_ID nvarchar(50)  NULL
            )
        ;

        --CASE1. priority가 '0', '9'로 Un Assign정보로 존재할때, 
        INSERT INTO #th_eng_op_res_group_map_line_capa_cal2
          (
               master_id
		     , plan_id
		     , site_id
		     , route_id
		     , operation_id
		     , item_id
             , resource_map_id
		     , resource_group_id
             , start_dttm
		     , end_dttm
             , sub_resource_map_id
		     , resource_map_level
             , alt_priority
		     , tact_time
		     , tact_time_uom
		     , yield
             , good_rate
		     , batch_rate
             , is_use
             , descr
		     , consume_res_rate
		     , prepare_time
		     , prepare_time_uom
             , scp_tact_time_use_yn --기존테이블에 없는 컬럼1
             , line_id              --기존테이블에 없는 컬럼2
		     , plant_site_id        
           )
        SELECT b.master_id
		     , b.plan_id
		     , b.site_id
		     , b.route_id
		     , b.operation_id
		     , b.item_id
             , b.resource_map_id
		     , b.resource_group_id
             , b.start_dttm
		     , b.end_dttm
             , b.sub_resource_map_id
		     , b.resource_map_level
             , b.alt_priority
		     , b.tact_time
		     , b.tact_time_uom
		     , b.yield
             , b.good_rate
		     , b.batch_rate
             , 'N' AS is_use
             , b.descr
		     , b.consume_res_rate
		     , b.prepare_time
		     , b.prepare_time_uom
             , b.scp_tact_time_use_yn --기존테이블에 없는 컬럼1
             , b.line_id              --기존테이블에 없는 컬럼2
	         , b.plant_site_id 
        FROM   
                ( SELECT DISTINCT 
                      la.company_id, la.division_id, la.site_id
                    , la.plant_id, la.factory_id, la.item_id
                    , la.operation_id, la.line_id
                    , la.month
                FROM   dbo.scm_mst_item_line_assign_sn la WITH(NOLOCK) --[LGCE_FPDEV_TR].[DBO].[SCM_ITEM_LINE_ASSIGN_M]
                WHERE  la.division_id = @p_division_id 
                AND    la.active_flag = 'Y'
                AND    la.month    >= SUBSTRING(@p_plan_name, 1, 6) --SUBSTRING('201806', 1, 6)
                -- 20210727 PJ20209643 : 'N' 처리 구간 변경 => 2개월 => 전 구간
                --AND    la.month    <  CONVERT(NVARCHAR(6), DATEADD(m, 2, CONVERT(DATETIME, SUBSTRING(@p_plan_name, 1, 6) + '01')), 112) --CONVERT(NVARCHAR(6), DATEADD(m, 2, CONVERT(DATETIME, SUBSTRING('20180604', 1, 6) + '01')), 112)
                AND    la.priority IN (0, 9) -- 사용 안할때 0, 9로 세팅되어있음               
                ) a
                INNER JOIN  (
                             SELECT aa.*
                                    , bb.division_id, bb.company_id, bb.site_id AS site_id_org, bb.plant_id   
                              FROM  ( SELECT *
                                        FROM #th_eng_op_res_group_map_line_capa_cal
                                       WHERE descr = 'LINE_CAPA'                                        
                                    ) aa
                             INNER JOIN scm_mst_site_eng bb WITH (NOLOCK) -- modeling_id, plan_id, plan_type, plan_seq, division_id, scm_site_id, eng_scm_site_id
                                ON aa.site_id     = bb.eng_scm_site_id 
                               AND bb.modeling_id = @p_modeling_id 
                               AND bb.plan_id     = @p_plan_id
                               AND bb.plan_type   = @p_plan_type 
                               AND bb.plan_seq    = @p_seq
                               AND bb.division_id = @p_division_id                 
                        ) b
                ON   a.company_id   = b.company_id
                AND  a.division_id  = b.division_id
                AND  a.site_id      = b.site_id_org
                AND  a.plant_id     = b.plant_id
                AND  b.operation_id LIKE a.operation_id + '%' --20180904 수정 (변경전 : AND  a.operation_id = b.operation_id )
                AND  a.line_id      = b.line_id
                AND  a.item_id      = b.item_id
                AND  a.month        >= CONVERT(NVARCHAR(6), b.start_dttm, 112)
                AND  a.month        < CONVERT(NVARCHAR(6), b.end_dttm, 112)
        ; 

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 3-4 END';
        SET @v_description = N'3-4. LINE CAPA 대상중 LINE UN-ASSIGN IN (0, 9) 데이터생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


        --CASE2. Line Assign된 Line Data가 아예 없는 경우에 추가, 2023.08.24 
        --//소형 CAPA 관리 공정만 대상, 나머지는 exception time (scp_mst_tact_time_except)에서, 처리됨
        INSERT INTO #th_eng_op_res_group_map_line_capa_cal2
             (
               master_id
	    	 , plan_id
	    	 , site_id
	    	 , route_id
	    	 , operation_id
	    	 , item_id
             , resource_map_id
	    	 , resource_group_id
             , start_dttm
	    	 , end_dttm
             , sub_resource_map_id
	    	 , resource_map_level
             , alt_priority
	    	 , tact_time
	    	 , tact_time_uom
	    	 , yield
             , good_rate
	    	 , batch_rate
             , is_use
             , descr
	    	 , consume_res_rate
	    	 , prepare_time
	    	 , prepare_time_uom
             , scp_tact_time_use_yn --기존테이블에 없는 컬럼1
             , line_id              --기존테이블에 없는 컬럼2
	    	 , plant_site_id        
             )
      SELECT  a.master_id
	        , a.plan_id
	        , a.site_id
	        , a.route_id
	        , a.operation_id
	        , a.item_id
            , a.resource_map_id
	        , a.resource_group_id
            , a.start_dttm
	        , a.end_dttm
            , a.sub_resource_map_id
	        , a.resource_map_level
            , a.alt_priority
	        , a.tact_time
	        , a.tact_time_uom
	        , a.yield
            , a.good_rate
	        , a.batch_rate
            , 'N' AS is_use
            , a.descr
	        , a.consume_res_rate
	        , a.prepare_time
	        , a.prepare_time_uom
            , a.scp_tact_time_use_yn --기존테이블에 없는 컬럼1
            , a.line_id              --기존테이블에 없는 컬럼2
	        , a.plant_site_id 
        FROM ( SELECT aa.*
                    , bb.division_id, bb.company_id, bb.site_id AS site_id_org, bb.plant_id   
                FROM #th_eng_op_res_group_map_line_capa_cal aa
               INNER JOIN scm_mst_site_eng bb WITH (NOLOCK) -- modeling_id, plan_id, plan_type, plan_seq, division_id, scm_site_id, eng_scm_site_id
                  ON aa.site_id     = bb.eng_scm_site_id 
                 AND bb.modeling_id = @p_modeling_id 
                 AND bb.plan_id     = @p_plan_id
                 AND bb.plan_type   = @p_plan_type 
                 AND bb.plan_seq    = @p_seq
                 AND bb.division_id = @p_division_id                                         
             ) a
            LEFT OUTER JOIN 
            (
               SELECT DISTINCT la.company_id, la.division_id, la.site_id
                   , la.plant_id, la.factory_id, la.item_id
                   , la.operation_id, la.line_id
                   , la.month
                FROM dbo.scm_mst_item_line_assign_sn la WITH(NOLOCK) --[LGCE_FPDEV_TR].[DBO].[SCM_ITEM_LINE_ASSIGN_M]
               WHERE la.division_id = @p_division_id 
                 AND la.active_flag = 'Y'
                 AND la.month      >= SUBSTRING(@p_plan_name, 1, 6) --SUBSTRING('201806', 1, 6)
                 AND la.priority NOT IN (0, 9) 
            ) b
             ON a.company_id   = b.company_id
            AND a.division_id  = b.division_id
            AND a.site_id_org  = b.site_id
            AND a.plant_id     = b.plant_id
            AND a.operation_id LIKE b.operation_id + '%'
            AND a.line_id      = b.line_id
            AND a.item_id      = b.item_id
            AND CONVERT(NVARCHAR(6), a.start_dttm, 112) = b.month
          WHERE 1=1
            AND b.month IS NULL
            /* 소형 CAPA 관리 공정만 */
            AND EXISTS 
                (
                 SELECT 'x'
                   FROM SCP_MST_CAPA y WITH(NOLOCK)
                  WHERE y.division_id = a.division_id
                   AND y.operation_id IN ('A3000', 'A9000')
                   AND y.yyyymm  >= LEFT(@p_plan_name, 6)   
                   AND y.yyyymm  <= LEFT(@v_pet_date, 6)
                   AND y.operation_id = a.operation_id
               )
            /* 중복 방지 */
            AND NOT EXISTS (                                
                            SELECT 'X'
                              FROM #th_eng_op_res_group_map_line_capa_cal2 x
                             WHERE x.site_id           = a.site_id          
	    	                   AND x.route_id          = a.route_id         
	    	                   AND x.operation_id      = a.operation_id     
	    	                   AND x.item_id           = a.item_id          
                               AND x.resource_group_id = a.resource_group_id
                               AND x.START_DTTM        = a.START_DTTM   
                               AND x.END_DTTM          = a.END_DTTM
                           )
            --a.ITEM_ID IN ('MACM348015A1-D14', 'MACM348015A1-D08')
            --AND a.LINE_ID IN ('M7C29')
            --ORDER BY a.START_DTTM      
        ;
		
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 3-4 END';
        SET @v_description = N'3-3. LINE CAPA 대상중 LINE UN-ASSIGN IS NULL 데이터생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


        ---------------------------------------------------------------
        --3-5.  분할대상 생성       
        ---------------------------------------------------------------        
        /*(주석시작) 20190405 scp_mst_tact_time_except (날짜 겹치게 입력되어있을경우) 날짜겹칩 방지처리
           이후 주석 처리 불필요한 소스 정리, 2023.08.24
           ... ...
        */

        ---------------------------------------------------------------
        --3-5)-1) 분할대상 임시테이블생성 (except 처리)       
        -- 분할대상 : tact_time값을  scp_mst_tact_time 값 사용한 데이터 중 except 대상데이터
        -- 임시 테이블 정리 : #DIV_TH_ENG_OP_RES_GROUP_MAP_CAL -> #div_th_eng_op_res_group_map_cal, 2023.08.24
        ---------------------------------------------------------------
        IF OBJECT_ID('tempdb..#div_th_eng_op_res_group_map_cal') IS NOT NULL
        BEGIN 
            DROP TABLE  #div_th_eng_op_res_group_map_cal;          
        END

        SELECT x.*
             , DATEDIFF(d, x.start_dttm, x.except_start_date) AS start_date_diff -- 'scp_mst_tact_time_except의 tact_time_start_date' - 'th_eng_op_res_group_map_cal의start_dttm'  
             , DATEDIFF(d, x.except_end_date, x.end_dttm) AS end_date_diff -- 'th_eng_op_res_group_map_cal의 end_dttm' - 'scp_mst_tact_time_except의 tact_time_end_date'    
             , DATEDIFF(d, x.except_end_date, CONVERT(DATETIME, x.next_except_tact_time_start_date)) AS except_enddate_nextstartdate_diff  -- '다음행의 scp_mst_tact_time_except의 tact_time_start_date' -'현재행의 scp_mst_tact_time_except의 tact_time_end_date'  
        INTO   #div_th_eng_op_res_group_map_cal 
        FROM   (SELECT a.*
                        -- , b.plant_site_id
                        , CONVERT(DATETIME, b.tact_time_start_date) AS except_start_date
                        , CONVERT(DATETIME, b.tact_time_end_date) AS except_end_date
                        , b.tact_time AS except_tact_time
                        , b.use_yn    AS except_use_yn  -- 2018.05.28   KSG                        
                        , CASE WHEN b.yield <= 0 THEN 1
                               WHEN b.yield > 1 THEN 1
                               ELSE ISNULL(b.yield, 1)
                          END AS except_yield
                        --  master_id, plan_id, site_id, operation_id, item_id, resource_map_id, resource_group_id, start_dttm, route_id
                        , ROW_NUMBER()                     OVER (PARTITION BY a.master_id, a.plan_id, a.site_id, a.operation_id, a.item_id, a.resource_map_id, a.resource_group_id, a.start_dttm, a.route_id ORDER BY a.start_dttm, b.tact_time_start_date) row_num --그룹별 순번
                        , COUNT(*)                         OVER (PARTITION BY a.master_id, a.plan_id, a.site_id, a.operation_id, a.item_id, a.resource_map_id, a.resource_group_id, a.start_dttm, a.route_id ) cnt                              --그룹별 전체개수
                        , LEAD(b.tact_time_start_date, 1)  OVER (PARTITION BY a.master_id, a.plan_id, a.site_id, a.operation_id, a.item_id, a.resource_map_id, a.resource_group_id, a.start_dttm, a.route_id ORDER BY a.start_dttm, b.tact_time_start_date) next_except_tact_time_start_date  --다음행의 scp_mst_tact_time_except.tact_time_start_date               
                FROM    #th_eng_op_res_group_map_line_capa_cal a
                INNER JOIN (SELECT b.*
                              FROM scp_mst_tact_time_except b WITH (NOLOCK)
                             WHERE b.division_id = @p_division_id
                               AND LEFT(b.tact_time_start_date,6) >= LEFT(@p_plan_name, 6)   
                               AND LEFT(b.tact_time_start_date,6) <= LEFT(@v_pet_date, 6)
                               /* 소형CAPA분리 공정 제외. 2023.08.24 조건 추가 */
                               AND NOT EXISTS (
                                               SELECT 'X'
                                                 FROM SCP_MST_CAPA x WITH(NOLOCK)
                                                WHERE x.division_id = b.division_id
                                                  AND x.operation_id = b.operation_id
                                                  AND x.yyyymm >= LEFT(@p_plan_name, 6)   
                                                  AND x.yyyymm <= LEFT(@v_pet_date, 6)
                                              )
                           ) b
                  ON a.plant_site_id = b.plant_site_id 
                 AND a.item_id       = b.item_id 
                 AND a.route_id LIKE b.operation_id + '%'
                 AND a.line_id  = b.line_id 
                 AND (
                       ( a.start_dttm <= b.tact_time_start_date
                       AND  a.end_dttm   >  b.tact_time_start_date
                       )
                       OR
                       ( a.start_dttm <= b.tact_time_end_date
                       AND  a.end_dttm   >  b.tact_time_end_date
                       )
                       OR
                       ( a.start_dttm >= b.tact_time_start_date
                       AND a.end_dttm <= b.tact_time_end_date
                       )
                     )
              WHERE a.master_id = @p_master_id     
                AND a.plan_id   = @p_engine_plan_id 
                --20180917 수정
                -- 경우1) scp_mst_tact_time_except.use_yn = 'N' 일때 (tact_time_start_date ~ tact_time_end_date 까지 is_use = 'N')
                -- 경우2) scp_mst_tact_time_except.use_yn = 'Y' 일때 : tact_time_start_date가 차월이전이라도 차월이후만 scp_mst_tact_time_except(tact_time_start_date ~ tact_time_end_date 기간만큼 scp_mst_tact_time_except.is_use 값을 그대로 입력함 )
                AND IIF(b.use_yn = 'Y', a.scp_tact_time_use_yn, 'Y') = 'Y'  --20180917 수정(변경전 : AND   a.scp_tact_time_use_yn = 'Y')
                -- line assign 정보의 priority IN (0, 9) 대상(th_eng_op_res_group_map_cal INSERT시 is_use = 'N' 처리 대상) 들 제외
                AND   NOT EXISTS ( SELECT 1
                                   FROM   #th_eng_op_res_group_map_line_capa_cal2 
                                   WHERE  site_id = a.site_id 
                                   AND    operation_id = a.operation_id 
                                   AND    item_id      = a.item_id 
                                   AND    resource_map_id = a.resource_map_id 
                                   AND    resource_group_id = a.resource_group_id 
                                   AND    start_dttm        = a.start_dttm
                                   AND    route_id          = a.route_id 
                                )  
               ) x
        ;

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 3-5 END';
        SET @v_description = N'3-5. LINECAPA 대상중 분할대상 생성 데이터생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -------------------------------------------------------------------
        --3-6. 분할대상 except 일자별로 분리후 임시테이블에 생성
             --  참고1) th_eng_op_res_group_map_cal.end_dttm          end_dttm미포함 => th_eng_op_res_group_map_cal의 start_dttm( ex)20180501) ~ end_dttm( ex)20180512) 이라하면  20180501~20180511까지가 대상이다.)
             --      2) scp_mst_tact_time_except.tact_time_end_date  tact_time_end_date포함 => scp_mst_tact_time_except의 tact_time_start_date( ex)20180501) ~ formation_end_date( ex)20180512) 이라하면  20180501~20180512까지가 대상이다.)
        -- 임시 테이블 정리 : #TH_ENG_OP_RES_GROUP_MAP_CAL_ADD -> #th_eng_op_res_group_map_cal_add, 2023.08.24
        ---------------------------------------------------------------
        
        IF OBJECT_ID('tempdb..#th_eng_op_res_group_map_cal_add') IS NOT NULL
        BEGIN 
            DROP TABLE  #th_eng_op_res_group_map_cal_add;          
        END
        
        SELECT DISTINCT
               master_id
		     , plan_id
		     , site_id
		     , route_id
		     , operation_id
		     , item_id
             , resource_map_id
		     , resource_group_id         
             , CASE WHEN gubun = 1 THEN start_dttm                 
                    WHEN gubun = 2 AND start_dttm <= except_start_date THEN except_start_date  
                    WHEN gubun = 2 AND start_dttm > except_start_date THEN start_dttm  
                    WHEN gubun = 3 THEN DATEADD(d, 1, except_end_date) -- 포함시 DATEADD(d, 1, CONVERT(DATETIME,except_end_date)) --확인 필요 (except_end_date 까지 포함인지 미포함인지 확인필요함)
               END AS start_dttm         
             , CASE WHEN gubun = 1 THEN except_start_date                 
                    WHEN gubun = 2 AND end_dttm > except_end_date THEN DATEADD(d, 1, except_end_date) -- 포함시 DATEADD(d, 1, CONVERT(DATETIME,except_end_date)) --확인 필요 (except_end_date 까지 포함인지 미포함인지 확인필요함)  
                    WHEN gubun = 2 AND end_dttm <= except_end_date THEN end_dttm  -- 포함시 DATEADD(d, 1, CONVERT(DATETIME,except_end_date)) --확인 필요 (except_end_date 까지 포함인지 미포함인지 확인필요함)                  
                    WHEN gubun = 3 AND row_num <> cnt THEN next_except_tact_time_start_date 
                    WHEN gubun = 3 AND row_num =  cnt THEN end_dttm           
               END AS end_dttm         
             , sub_resource_map_id
		     , resource_map_level
             , alt_priority		     
             , CASE WHEN gubun = 1 THEN tact_time 
                    WHEN gubun = 2 THEN except_tact_time * ISNULL(except_yield , 1) 
                    WHEN gubun = 3 THEN tact_time 
               END tact_time             
             , tact_time_uom
             , CASE WHEN gubun = 1 THEN yield 
                    WHEN gubun = 2 THEN except_yield 
                    WHEN gubun = 3 THEN yield 
               END yield         
             , good_rate
		     , batch_rate
			   -- 2018.05.28   KSG
             , CASE WHEN gubun = 1 THEN is_use 
                    WHEN gubun = 2 THEN except_use_yn 
                    WHEN gubun = 3 THEN is_use 
               END is_use
             --, is_use
             , descr
		     , consume_res_rate
		     , prepare_time
		     , prepare_time_uom
             , scp_tact_time_use_yn --기존테이블에 없는 컬럼1
             , line_id              --기존테이블에 없는 컬럼2  
	         , plant_site_id        
        INTO  #th_eng_op_res_group_map_cal_add
        FROM (
                SELECT *
                FROM  #div_th_eng_op_res_group_map_cal a
                    , (SELECT 1 gubun UNION ALL SELECT 2 UNION ALL SELECT 3) b
                WHERE (
                        ( gubun = 1 AND  row_num =1 AND start_date_diff > 0)
                        OR
                        ( gubun = 2)
                        OR
                        ( gubun = 3 AND end_date_diff > 1 AND ISNULL(except_enddate_nextstartdate_diff, 99) <> 1)                    
                        )
                ) x
        ; 
		
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 3-6 END';
        SET @v_description = N'3-6. LINE CAPA 대상중 분할대상 일자별로 분리 생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        ---------------------------------------------------------------
        --3-7. LINE CAPA 대상 전체 INSERT ( except 비대상 + except 대상)        
        ---------------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_OP_RES_GROUP_MAP_CAL */ th_eng_op_res_group_map_cal_sn
        (  master_id
		 , plan_id
		 , site_id
		 , route_id
		 , operation_id
		 , item_id
         , resource_map_id
		 , resource_group_id
         , start_dttm
		 , end_dttm
         , sub_resource_map_id
		 , resource_map_level
         , alt_priority
		 , tact_time
		 , tact_time_uom
		 , yield
         , good_rate
		 , batch_rate
         , is_use
         , descr
		 , consume_res_rate
		 , prepare_time
		 , prepare_time_uom
        )
        SELECT master_id
		     , plan_id
		     , site_id
		     , route_id
		     , operation_id
		     , item_id
             , resource_map_id
		     , resource_group_id
             , start_dttm
		     , end_dttm
             , sub_resource_map_id
		     , resource_map_level
             , alt_priority
               /* 소숫점 3자리로 절삭 (엔진은 1/1000초로 시간계산)
                  ROUND함수(인수1,인수2,인수3) : 인수3번 값이 0이 아니면, 절삭
                  - 2023.08.24
                */
             --, tact_time
             , ROUND(tact_time, 3, 1) AS tact_time 
             , tact_time_uom
		     --Default = 1로 셋팅
             , ISNULL(yield,1)        AS yield
             , good_rate
		     , batch_rate             
             , CASE WHEN tact_time = 0 THEN 'N'  
                    ELSE is_use
               END AS is_use  --20180605 추가 (변경전 : , is_use )            
             , descr
		     , consume_res_rate
		     , prepare_time
		     , prepare_time_uom
        FROM   (   
                   --  scp_mst_tact_time_except 비대상 데이터
                   SELECT * 
                   FROM   #th_eng_op_res_group_map_line_capa_cal  a   -- select count(*) from #th_eng_op_res_group_map_line_capa_cal
                   WHERE  NOT EXISTS ( SELECT 1
                                       FROM   
                                            ( SELECT DISTINCT master_id, plan_id, site_id, operation_id, item_id, resource_map_id, resource_group_id, start_dttm, route_id
                                                FROM #div_th_eng_op_res_group_map_cal 
                                            ) x
                                       WHERE x.master_id       = a.master_id
                                       AND   x.plan_id         =  a.plan_id
                                       AND   x.site_id         =  a.site_id
                                       AND   x.operation_id    =  a.operation_id
                                       AND   x.item_id         =  a.item_id
                                       AND   x.resource_map_id =  a.resource_map_id
                                       AND   x.resource_group_id = a.resource_group_id
                                       AND   x.start_dttm        = a.start_dttm
                                       AND   x.route_id          = a.route_id
                                       ) 
                   AND   NOT EXISTS ( SELECT 1
                                      FROM   #th_eng_op_res_group_map_line_capa_cal2 --MASTER_ID, PLAN_ID, SITE_ID, OPERATION_ID, ITEM_ID, RESOURCE_MAP_ID, RESOURCE_GROUP_ID, START_DTTM, ROUTE_ID
                                      WHERE  site_id           = a.site_id 
                                      AND    operation_id      = a.operation_id 
                                      AND    item_id           = a.item_id 
                                      AND    resource_map_id   = a.resource_map_id 
                                      AND    resource_group_id = a.resource_group_id 
                                      AND    start_dttm        = a.start_dttm
                                      AND    route_id          = a.route_id 
                                ) 
                   UNION ALL  
                   SELECT * FROM #th_eng_op_res_group_map_line_capa_cal2 
                   UNION ALL
                   -- scp_mst_tact_time_except 대상(start_dttm, end_dttm 분할된 신규데이터)
                   SELECT * FROM #th_eng_op_res_group_map_cal_add 
               ) xx
        ;
		
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 3-7 END';
        SET @v_description = N'3-7. LINE CAPA 대상중 ENG BOR 생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
 
        -----------------------------------------------------------
		-- 3. CAPA공정 (Line Modeling 대상 공정)에 대해, 기간별 BOR 데이터 생성 CAPA분리 & 튜닝,  2023.08.24 ~ End
        -----------------------------------------------------------
 
        -----------------------------------------------------------
        -- 4. OSP_L 공정 : 외주 Line Capa 공정 ( th_eng_op_res_group_map_sn.descr 컬럼값이 'OSP_L' 일때) 
        --                - tact_time, yield값을 th_eng_bucket_info의 기간만큼 월별로 데이터 생성
		--  2020.02.03 [OSP Line Plan] OSP이면서 Line별 Capa 적용 Site
        -----------------------------------------------------------
        -----------------------------------------------------------
        -- 임시테이블 생성
        -- 임시 테이블 정리 : #TH_ENG_OP_RES_GROUP_MAP_CAL_OSP_L -> #th_eng_op_res_group_map_cal_osp_l, 2023.08.24
        -----------------------------------------------------------		
        IF OBJECT_ID('tempdb..#th_eng_op_res_group_map_cal_osp_l') IS NOT NULL
        BEGIN 
            DROP TABLE  #th_eng_op_res_group_map_cal_osp_l;          
        END

        CREATE TABLE #th_eng_op_res_group_map_cal_osp_l(
	       MASTER_ID nvarchar(50) NOT NULL
	      , PLAN_ID nvarchar(50) NOT NULL
	      , SITE_ID nvarchar(50) NOT NULL
	      , ROUTE_ID nvarchar(50) NOT NULL
	      , OPERATION_ID nvarchar(50) NOT NULL
	      , ITEM_ID nvarchar(50) NOT NULL
	      , RESOURCE_MAP_ID nvarchar(80) NOT NULL
	      , RESOURCE_GROUP_ID nvarchar(80) NOT NULL
	      , START_DTTM datetime NOT NULL
	      , END_DTTM datetime NOT NULL
	      , SUB_RESOURCE_MAP_ID nvarchar(150) NULL
	      , RESOURCE_MAP_LEVEL numeric(20, 10) NULL DEFAULT ((1))
	      , ALT_PRIORITY numeric(20, 10) NULL
	      , TACT_TIME numeric(20, 10) NOT NULL
	      , TACT_TIME_UOM nvarchar(10) NULL DEFAULT ('SECOND')
	      , YIELD numeric(20, 10) NULL DEFAULT ((1))
	      , GOOD_RATE numeric(20, 10) NULL
	      , BATCH_RATE numeric(20, 10) NULL
	      , IS_USE nvarchar(1) NULL DEFAULT ('Y')
	      , DESCR nvarchar(2000) NULL
	      , CONSUME_RES_RATE numeric(20, 10) NULL
	      , PREPARE_TIME numeric(20, 10) NULL DEFAULT ((0))
	      , PREPARE_TIME_UOM nvarchar(10) NULL DEFAULT ('HOUR')
          , SCP_TACT_TIME_USE_YN nvarchar(10) NULL  --기존테이블에 없는 컬럼(scp_mst_tact_time 사용여부)
          , LINE_ID nvarchar(10) NULL
	      , PLANT_SITE_ID nvarchar(50)  NULL
        )
        ;

        -----------------------------------------------------------
        -- 4-1. OSP_L tact_time/ yield 셋팅 : is_use 컬럼 'Y' 셋팅
        --        전 구간 scp관리(scp_mst_tact_time_osp.tact_time / yield) tact_time/yield 사용함
		--        임시테이블에 INSERT
        -----------------------------------------------------------		
        INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_OP_RES_GROUP_MAP_CAL */ #th_eng_op_res_group_map_cal_osp_l
        (  master_id
		 , plan_id
		 , site_id
		 , route_id
		 , operation_id
		 , item_id
         , resource_map_id
		 , resource_group_id
         , start_dttm
		 , end_dttm
         , sub_resource_map_id
		 , resource_map_level
         , alt_priority
		 , tact_time
		 , tact_time_uom
		 , yield
         , good_rate
		 , batch_rate
         , is_use
         , descr
		 , consume_res_rate
		 , prepare_time
		 , prepare_time_uom
         , scp_tact_time_use_yn --기존테이블에 없는 컬럼1
         , line_id              --기존테이블에 없는 컬럼2
		 , plant_site_id
        )        
        SELECT res.master_id
		     , res.plan_id
			 , res.site_id
			 , res.route_id
			 , res.operation_id
			 , res.item_id
             , res.resource_map_id
			 , res.resource_group_id
             , ISNULL(tat.start_dttm, CONVERT(DATETIME, @p_plan_name)) AS start_dttm
             --, ISNULL(tat.end_dttm, DATEADD(DD, 52*7 ,(CONVERT(DATETIME, '20200203'))))
             , ISNULL(tat.end_dttm, CONVERT(DATETIME, @v_add_pet_date))	 AS end_dttm   -- 2022.01.17 @v_pet_date ->  @v_add_pet_date 으로 변경
             , res.sub_resource_map_id
			 , res.resource_map_level
             , res.alt_priority
			 -- Input용 Tact Time은 수율을 곱해서 적용함
             --, ISNULL(tat.tact_time * ISNULL(tat.yield,1), res.tact_time)  
             , ROUND(ISNULL(tat.tact_time * ISNULL(tat.yield,1), res.tact_time),3,1)  --//소숫점 3자리로 절삭 (엔진은 1/1000초로 시간계산), 2023.08.24
                                                                         AS tact_time 
             , res.tact_time_uom

             , ISNULL(tat.yield, res.yield) AS yield -- 20180405 수정 (변경전 : , ISNULL(yld.yield, res.yield) AS yield  --20180313 수정 (변경전 : , res.yield) )

             , res.good_rate
			 , res.batch_rate
             , 'Y' AS is_use -- 뒤에서 추가 Update 처리함
             , res.descr
			 , res.consume_res_rate
			 , res.prepare_time
			 , res.prepare_time_uom

             -- scp tact_time 사용여부
             , IIF(tat.tact_time IS NOT NULL, 'Y', 'N') AS scp_tact_time_use_yn  --기존테이블에 없는 컬럼1
             , res.line_id              --기존테이블에 없는 컬럼2
			 , res.scm_sitE_id AS plant_site_id

        FROM  (SELECT g.*
                    , s.plant_id, s.scm_site_id
                    , SUBSTRING(g.resource_group_id, dbo.FN_CHARINDEX_REV(g.resource_group_id, '::', 0)+2, 100) AS line_id
               FROM   th_eng_op_res_group_map_sn g WITH(NOLOCK)
                    , scm_mst_site_eng           s WITH(NOLOCK)
               WHERE  g.master_id   = @p_master_id
               AND    g.plan_id     = @p_engine_plan_id
               AND    s.modeling_id = @p_modeling_id
               AND    s.plan_id     = @p_plan_id
               AND    s.plan_type   = @p_plan_type
               AND    s.plan_seq    = @p_seq
               AND    g.site_id     = s.eng_scm_site_id
               -- Line Capa 적용 대상 공정
               AND    g.descr       = 'OSP_L'
              ) res
              LEFT OUTER JOIN 
                 (SELECT t.division_id AS origin_division_id
                       --, t.plant_id
                       , t.operation_id --
                       , t.line_id
                       , t.item_id
                       , buc.month    -- Tact Time 존재 구간
                       , buc.start_dttm
                       , buc.end_dttm
                       
                       , t.tact_time
					   , t.yield
                       , t.plant_site_id + '~***' AS eng_scm_site_id 
                  FROM  scp_mst_tact_time_osp t WITH(NOLOCK)
                  
				      , (				  
                         SELECT b.master_id, b.plan_id, b.month
                              , CASE WHEN b.seq = 1 THEN b.start_dttm -- 첫째 월   : Plan 시작일
                                     ELSE b.month_date                -- 둘째 이후 : 매월 1일
                                END start_dttm
                              , CASE WHEN b.seq_r = 1 AND b.month  = b.month_end THEN b.end_dttm                    -- 마지막 주가 Normal 인 경우  : Plan 종료일
                                     WHEN b.seq_r = 1 AND b.month <> b.month_end THEN DATEADD(MM, 1, b.month_date)  -- 마지막 주가 Partial 인 경우 : 차월 1일 : 아래 UNION 으로 마지막 월 정보 추가
                                     ELSE DATEADD(MM, 1, b.month_date)                                              --                             : 차월 1일
                                END end_dttm
                         FROM  (	
                                SELECT master_id
                                     , plan_id
                                     , CONVERT(CHAR(6), start_dttm, 112) AS month
                                     , CONVERT(CHAR(6), MAX(end_dttm), 112) AS month_end
                                     , CONVERT(DATETIME, CONVERT(CHAR(6), start_dttm, 112)+'01') AS month_date -- 당월 1일
                                     , MIN(start_dttm) AS start_dttm
                                     , MAX(end_dttm)   AS end_dttm
                                     , ROW_NUMBER() OVER(ORDER BY master_id, plan_id, CONVERT(CHAR(6), start_dttm, 112) DESC) AS seq_r
                                     , ROW_NUMBER() OVER(ORDER BY master_id, plan_id, CONVERT(CHAR(6), start_dttm, 112))      AS seq
                                FROM   th_eng_bucket_info_sn  WITH(NOLOCK)
                                WHERE  master_id = @p_master_id
                                AND    plan_id   = @p_engine_plan_id
                                GROUP BY master_id, plan_id, CONVERT(CHAR(6), start_dttm, 112)		
            				   ) b
                         -- 마지막 주가 Partial 인 경우 마지막 월 정보 추가
                         UNION 
                         SELECT b.master_id, b.plan_id, b.month
                              , CONVERT(DATETIME, month_end+'01') AS start_dttm
                              , b.end_dttm                        AS end_dttm
                         FROM  (	
                                SELECT master_id
                                     , plan_id
                                     , CONVERT(CHAR(6), start_dttm, 112) AS month
                                     , CONVERT(CHAR(6), MAX(DATEADD(DD, -1, end_dttm)), 112) AS month_end  -- 일요일 기준 월
                                     , CONVERT(DATETIME, CONVERT(CHAR(6), start_dttm, 112)+'01') AS month_date -- 당월 1일
                                     , MIN(start_dttm) AS start_dttm
                                     , MAX(end_dttm)   AS end_dttm
                                     , ROW_NUMBER() OVER(ORDER BY master_id, plan_id, CONVERT(CHAR(6), start_dttm, 112) DESC) AS seq_r
                                     , ROW_NUMBER() OVER(ORDER BY master_id, plan_id, CONVERT(CHAR(6), start_dttm, 112))      AS seq
                                FROM   th_eng_bucket_info_sn  WITH(NOLOCK)
                                WHERE  master_id = @p_master_id
                                AND    plan_id   = @p_engine_plan_id
                                GROUP BY master_id, plan_id, CONVERT(CHAR(6), start_dttm, 112)		
            		           ) b
                         WHERE  b.seq_r  = 1
                         AND    b.month <> b.month_end
                       ) buc
                  WHERE t.division_id = @p_division_id
                 ) tat
               --ON    res.plant_id     = tat.plant_id
               ON  res.site_id      = tat.eng_scm_site_id
               AND res.route_id     = tat.operation_id
               AND res.line_id      = tat.line_id
               AND res.item_id      = tat.item_id

        WHERE  res.resource_map_level = 1
		;

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 4-1 END';
        SET @v_description = N'4-1. OSP_L tact_time/ yield 셋팅' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
        -----------------------------------------------------------
        -- 4-2. OSP_L tact_time_except 적용(line capa 대상에만 적용함) 
        --        적용해서 생성된 th_eng_op_res_group_map_cal_sn 데이터중에서 
        --        scp_mst_tact_time_except_osp.tact_time_start_date ~ scp_mst_tact_time_except_osp.tact_time_end_date 기간에 포함된 데이터의 값 대체  
        -----------------------------------------------------------		
        ---------------------------------------------------------------
        --4-2-1. 분할대상 임시테이블생성  (except 처리)      
        --      - 분할대상 : tact_time값을  scp_mst_tact_time_osp 값 사용한 데이터 중 except 대상데이터
        -- 임시 테이블 정리 : #DIV_TH_ENG_OP_RES_GROUP_MAP_CAL_OSP_L  -> #div_th_eng_op_res_group_map_cal_osp_l, 2023.08.24
        ---------------------------------------------------------------

        IF OBJECT_ID('tempdb..#div_th_eng_op_res_group_map_cal_osp_l') IS NOT NULL
        BEGIN 
            DROP TABLE  #div_th_eng_op_res_group_map_cal_osp_l;          
        END

        SELECT x.*
             , DATEDIFF(d, x.start_dttm, x.except_start_date) AS start_date_diff -- 'scp_mst_tact_time_except_osp의 tact_time_start_date' - 'th_eng_op_res_group_map_cal의start_dttm'  
             , DATEDIFF(d, x.except_end_date, x.end_dttm) AS end_date_diff -- 'th_eng_op_res_group_map_cal의 end_dttm' - 'scp_mst_tact_time_except_osp의 tact_time_end_date'    
             , DATEDIFF(d, x.except_end_date, CONVERT(DATETIME, x.next_except_tact_time_start_date)) AS except_enddate_nextstartdate_diff  -- '다음행의 scp_mst_tact_time_except_osp의 tact_time_start_date' -'현재행의 scp_mst_tact_time_except_osp의 tact_time_end_date'  
        INTO   #div_th_eng_op_res_group_map_cal_osp_l 
        FROM   (SELECT a.*
                        --, b.plant_site_id
                        , CONVERT(DATETIME, b.tact_time_start_date) AS except_start_date
                        , CONVERT(DATETIME, b.tact_time_end_date) AS except_end_date
                        , b.tact_time AS except_tact_time
                        , b.use_yn    AS except_use_yn  -- 2018.05.28   KSG                        
                        , CASE WHEN b.yield <= 0 THEN 1
                               WHEN b.yield > 1 THEN 1
                               ELSE ISNULL(b.yield, 1)
                          END AS except_yield
                        --  master_id, plan_id, site_id, operation_id, item_id, resource_map_id, resource_group_id, start_dttm, route_id
                        , ROW_NUMBER()                     OVER (PARTITION BY a.master_id, a.plan_id, a.site_id, a.operation_id, a.item_id, a.resource_map_id, a.resource_group_id, a.start_dttm, a.route_id ORDER BY a.start_dttm, b.tact_time_start_date) row_num --그룹별 순번
                        , COUNT(*)                         OVER (PARTITION BY a.master_id, a.plan_id, a.site_id, a.operation_id, a.item_id, a.resource_map_id, a.resource_group_id, a.start_dttm, a.route_id ) cnt                              --그룹별 전체개수
                        , LEAD(b.tact_time_start_date, 1)  OVER (PARTITION BY a.master_id, a.plan_id, a.site_id, a.operation_id, a.item_id, a.resource_map_id, a.resource_group_id, a.start_dttm, a.route_id ORDER BY a.start_dttm, b.tact_time_start_date) next_except_tact_time_start_date  --다음행의 scp_mst_tact_time_except_osp.tact_time_start_date               
                FROM    #th_eng_op_res_group_map_cal_osp_l a
                        INNER JOIN scp_mst_tact_time_except_osp b WITH (NOLOCK)
                        --ON   dbo.fn_scm_split(dbo.fn_scm_split(a.resource_group_id, 2, '::'), 1, '~') = b.plant_site_id 
                        ON   a.plant_site_id = b.plant_site_id 
                        AND  a.item_id  = b.item_id 
                        AND  a.route_id = b.operation_id -- 20201102 PJ20202001
                        --AND  a.route_id LIKE b.operation_id + '%'
                        AND  a.line_id  = b.line_id 
                        AND  (
                                ( a.start_dttm <= b.tact_time_start_date
                                AND  a.end_dttm   >  b.tact_time_start_date
                                )
                                OR
                                ( a.start_dttm <= b.tact_time_end_date
                                AND  a.end_dttm   >  b.tact_time_end_date
                                )
                                OR
                                ( a.start_dttm >= b.tact_time_start_date
                                  AND a.end_dttm <= b.tact_time_end_date
                                )
                            )
                        AND  b.division_id = @p_division_id
                WHERE a.master_id = @p_master_id      
                AND   a.plan_id   = @p_engine_plan_id  
                --20180917 수정
                -- 경우1) scp_mst_tact_time_except_osp.use_yn = 'N' 일때 (tact_time_start_date ~ tact_time_end_date 까지 is_use = 'N')
                -- 경우2) scp_mst_tact_time_except_osp.use_yn = 'Y' 일때 : tact_time_start_date가 차월이전이라도 차월이후만 scp_mst_tact_time_except_osp(tact_time_start_date ~ tact_time_end_date 기간만큼 scp_mst_tact_time_except_osp.is_use 값을 그대로 입력함 )
                AND   IIF(b.use_yn = 'Y', a.scp_tact_time_use_yn, 'Y') = 'Y'  --20180917 수정(변경전 : AND   a.scp_tact_time_use_yn = 'Y')                      
               ) x
        ;

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 4-2';
        SET @v_description = N'4-2. 분할대상 생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        ---------------------------------------------------------------
        --4-3. 분할대상 except 일자별로 분리후 임시테이블에 생성
             --  참고1) th_eng_op_res_group_map_cal.end_dttm          end_dttm미포함 => th_eng_op_res_group_map_cal의 start_dttm( ex)20180501) ~ end_dttm( ex)20180512) 이라하면  20180501~20180511까지가 대상이다.)
             --      2) scp_mst_tact_time_except_osp.tact_time_end_date  tact_time_end_date포함 => scp_mst_tact_time_except_osp의 tact_time_start_date( ex)20180501) ~ formation_end_date( ex)20180512) 이라하면  20180501~20180512까지가 대상이다.)
        -- 임시 테이블 정리 : #TH_ENG_OP_RES_GROUP_MAP_CAL_ADD_OSP_L  -> #th_eng_op_res_group_map_cal_add_osp_l, 2023.08.24
        ---------------------------------------------------------------
        IF OBJECT_ID('tempdb..#th_eng_op_res_group_map_cal_add_osp_l') IS NOT NULL
        BEGIN 
            DROP TABLE  #th_eng_op_res_group_map_cal_add_osp_l;          
        END
        
        SELECT DISTINCT
               master_id
		     , plan_id
		     , site_id
		     , route_id
		     , operation_id
		     , item_id
             , resource_map_id
		     , resource_group_id
         
             , CASE WHEN gubun = 1 THEN start_dttm
                 
                    WHEN gubun = 2 AND start_dttm <= except_start_date THEN except_start_date  
                    WHEN gubun = 2 AND start_dttm > except_start_date THEN start_dttm  

                    WHEN gubun = 3 THEN DATEADD(d, 1, except_end_date) -- 포함시 DATEADD(d, 1, CONVERT(DATETIME,except_end_date)) --확인 필요 (except_end_date 까지 포함인지 미포함인지 확인필요함)
               END AS start_dttm
         
             , CASE WHEN gubun = 1 THEN except_start_date 
                
                    WHEN gubun = 2 AND end_dttm > except_end_date THEN DATEADD(d, 1, except_end_date) -- 포함시 DATEADD(d, 1, CONVERT(DATETIME,except_end_date)) --확인 필요 (except_end_date 까지 포함인지 미포함인지 확인필요함)  
                    WHEN gubun = 2 AND end_dttm <= except_end_date THEN end_dttm  -- 포함시 DATEADD(d, 1, CONVERT(DATETIME,except_end_date)) --확인 필요 (except_end_date 까지 포함인지 미포함인지 확인필요함)  
                
                    WHEN gubun = 3 AND row_num <> cnt THEN next_except_tact_time_start_date 
                    WHEN gubun = 3 AND row_num =  cnt THEN end_dttm 
          
               END AS end_dttm
         
             , sub_resource_map_id
		     , resource_map_level
             , alt_priority
		     
             , CASE WHEN gubun = 1 THEN tact_time 
                    WHEN gubun = 2 THEN except_tact_time * ISNULL(except_yield , 1) 
                    WHEN gubun = 3 THEN tact_time 
               END tact_time
             
             , tact_time_uom

             , CASE WHEN gubun = 1 THEN yield 
                    WHEN gubun = 2 THEN except_yield 
                    WHEN gubun = 3 THEN yield 
               END yield
         
             , good_rate
		     , batch_rate
			   -- 2018.05.28   KSG
             , CASE WHEN gubun = 1 THEN is_use 
                    WHEN gubun = 2 THEN except_use_yn 
                    WHEN gubun = 3 THEN is_use 
               END is_use
             --, is_use

             , descr
		     , consume_res_rate
		     , prepare_time
		     , prepare_time_uom

             , scp_tact_time_use_yn --기존테이블에 없는 컬럼1
             , line_id              --기존테이블에 없는 컬럼2  
	         , plant_site_id 
        
        INTO  #th_eng_op_res_group_map_cal_add_osp_l
        FROM (
                SELECT *
                FROM  #div_th_eng_op_res_group_map_cal_osp_l a
                    , (SELECT 1 gubun UNION ALL SELECT 2 UNION ALL SELECT 3) b
                WHERE (
                        ( gubun = 1 AND  row_num =1 AND start_date_diff > 0)
                        OR
                        ( gubun = 2)
                        OR
                        ( gubun = 3 AND end_date_diff > 1 AND ISNULL(except_enddate_nextstartdate_diff, 99) <> 1)                    
                        )
                ) x
        ; 
		
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 4-3';
        SET @v_description = N'4-3. 분할대상 일자별로 분리 생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        ---------------------------------------------------------------
        --4-4. OSP LINE CAPA 대상 전체 INSERT ( except 비대상 + except 대상)        
        ---------------------------------------------------------------
		INSERT INTO /* PR_SCP_ENG_IN_FN_PROC_OP_RES_GROUP_MAP_CAL */ th_eng_op_res_group_map_cal_sn
        (  master_id
		 , plan_id
		 , site_id
		 , route_id
		 , operation_id
		 , item_id
         , resource_map_id
		 , resource_group_id
         , start_dttm
		 , end_dttm
         , sub_resource_map_id
		 , resource_map_level
         , alt_priority
		 , tact_time
		 , tact_time_uom
		 , yield
         , good_rate
		 , batch_rate
         , is_use
         , descr
		 , consume_res_rate
		 , prepare_time
		 , prepare_time_uom
        )
        SELECT master_id
		     , plan_id
		     , site_id
		     , route_id
		     , operation_id
		     , item_id
             , resource_map_id
		     , resource_group_id
             , start_dttm
		     , end_dttm
             , sub_resource_map_id
		     , resource_map_level
             , alt_priority
		       /* 소수점 3자리에서 절삭, 2023.08.24 수정 
                  엔진(자바)은 날짜값 계산을 1/1000초까지 하기 때문에
                  ROUND함수(인수1,인수2,인수3) : 인수3번 값이 0이 아니면, 절삭
                */
             --, tact_time
             , ROUND(tact_time, 3, 1) AS tact_time 
		     , tact_time_uom
		     --Default = 1로 셋팅
             , ISNULL(yield,1)        AS yield
             , good_rate
		     , batch_rate             
             , CASE WHEN tact_time = 0 THEN 'N'  
                    ELSE is_use
               END AS is_use  --20180605 추가 (변경전 : , is_use )               
             , descr
		     , consume_res_rate
		     , prepare_time
		     , prepare_time_uom
		FROM   (   
                   --  scp_mst_tact_time_except_osp 비대상 데이터
                   SELECT * 
                   FROM   #th_eng_op_res_group_map_cal_osp_l  a
                   WHERE  NOT EXISTS ( SELECT 1
                                       FROM   
                                            ( SELECT DISTINCT master_id, plan_id, site_id, operation_id, item_id, resource_map_id, resource_group_id, start_dttm, route_id
                                                FROM #div_th_eng_op_res_group_map_cal_osp_l 
                                            ) x
                                       WHERE x.master_id       = a.master_id
                                       AND   x.plan_id         =  a.plan_id
                                       AND   x.site_id         =  a.site_id
                                       AND   x.operation_id    =  a.operation_id
                                       AND   x.item_id         =  a.item_id
                                       AND   x.resource_map_id =  a.resource_map_id
                                       AND   x.resource_group_id = a.resource_group_id
                                       AND   x.start_dttm        = a.start_dttm
                                       AND   x.route_id          = a.route_id
                                       )                    
                   UNION ALL
                   -- scp_mst_tact_time_except_osp 대상(start_dttm, end_dttm 분할된 신규데이터)
                   SELECT * FROM #th_eng_op_res_group_map_cal_add_osp_l 
               ) xx
		;
		
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 4-4 ';
        SET @v_description = N'4-4. LINECAPA 대상 INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
		-- 5. th_eng_op_res_group 테이블의 1) min_tact_time, 2) avg_tact_time, 3) max_tact_time 컬럼값 UPDATE 
        --    - min_tact_time, avg_tact_time, max_tact_time 값을 
        --      1)th_eng_op_res_group_map.tact_time, 2)th_eng_op_res_group_group_map_cal.tact_time 1),2)둘중 큰값으로 변경
		-- (2021.11.01) 소형은 avg 값으로 적용, 그 외는 기존코드대로 max값 적용.
        -----------------------------------------------------------
        
		IF    @v_division_group in ( '40' )       -- (2022.04.04) JV사업부 추가 변수변경: @p_division_id -> @v_division_group
		  BEGIN

				UPDATE th_eng_op_res_group_sn
				SET    min_tact_time = b.AVG_tact_time 
					 , avg_tact_time = b.AVG_tact_time
					 , max_tact_time = b.AVG_tact_time        
				FROM   th_eng_op_res_group_sn a
					   INNER JOIN
								   (
									SELECT aa.master_id, aa.plan_id, aa.site_id, aa.operation_id, aa.item_id, aa.resource_map_id, aa.route_id
										 , AVG(aa.AVG_tact_time) AVG_tact_time
									FROM   (
											SELECT master_id, plan_id, site_id, operation_id, item_id, resource_map_id, route_id
												 , MAX(tact_time) max_tact_time
												 , AVG(tact_time) AVG_tact_time  
											FROM   th_eng_op_res_group_map_sn  WITH (NOLOCK)
											WHERE  master_id = @p_master_id 
											AND    plan_id   = @p_engine_plan_id
											AND    tact_time <> 0 
											GROUP BY master_id, plan_id, site_id, operation_id, item_id, resource_map_id,route_id                
											UNION ALL                
											SELECT master_id, plan_id, site_id, operation_id, item_id, resource_map_id, route_id
												 , MAX(tact_time) max_tact_time
												 , AVG(tact_time) AVG_tact_time
											FROM   th_eng_op_res_group_map_cal_sn WITH (NOLOCK)
											WHERE  master_id = @p_master_id 
											AND    plan_id   = @p_engine_plan_id 
											AND    start_dttm = CONVERT(DATETIME, @p_plan_name)
											AND    is_use = 'Y'
											and    tact_time <> 0
											GROUP BY master_id, plan_id, site_id, operation_id, item_id, resource_map_id, route_id                
											) aa
									GROUP BY aa.master_id, aa.plan_id, aa.site_id, aa.operation_id, aa.item_id, aa.resource_map_id, aa.route_id
								  ) b
					   ON  a.master_id       = b.master_id 
					   AND a.plan_id         = b.plan_id 
					   AND a.site_id         = b.site_id 
					   AND a.operation_id    = b.operation_id 
					   AND a.item_id         = b.item_id
					   AND a.resource_map_id = b.resource_map_id 
					   AND a.route_id        = b.route_id  
				WHERE  a.master_id = @p_master_id 
				AND    a.plan_id   = @p_engine_plan_id 
				;
		  END 
		ELSE    --- 그 외는 기존코드대로 max값 적용.
		  BEGIN      
				UPDATE th_eng_op_res_group_sn
				SET    min_tact_time = b.max_tact_time 
					 , avg_tact_time = b.max_tact_time
					 , max_tact_time = b.max_tact_time        
				FROM   th_eng_op_res_group_sn a
					   INNER JOIN
								   (
									SELECT aa.master_id, aa.plan_id, aa.site_id, aa.operation_id, aa.item_id, aa.resource_map_id, aa.route_id
										 , MAX(aa.max_tact_time) max_tact_time
									FROM   (
											SELECT master_id, plan_id, site_id, operation_id, item_id, resource_map_id, route_id
												 , MAX(tact_time) max_tact_time
											FROM   th_eng_op_res_group_map_sn  WITH (NOLOCK)
											WHERE  master_id = @p_master_id 
											AND    plan_id   = @p_engine_plan_id
											AND    tact_time <> 0 
											GROUP BY master_id, plan_id, site_id, operation_id, item_id, resource_map_id,route_id                
											UNION ALL                
											SELECT master_id, plan_id, site_id, operation_id, item_id, resource_map_id, route_id
												 , MAX(tact_time) max_tact_time
											FROM   th_eng_op_res_group_map_cal_sn WITH (NOLOCK)
											WHERE  master_id = @p_master_id 
											AND    plan_id   = @p_engine_plan_id 
											AND    start_dttm = CONVERT(DATETIME, @p_plan_name)
											AND    is_use = 'Y'
											and    tact_time <> 0
											GROUP BY master_id, plan_id, site_id, operation_id, item_id, resource_map_id, route_id                
											) aa
									GROUP BY aa.master_id, aa.plan_id, aa.site_id, aa.operation_id, aa.item_id, aa.resource_map_id, aa.route_id
								  ) b
					   ON  a.master_id       = b.master_id 
					   AND a.plan_id         = b.plan_id 
					   AND a.site_id         = b.site_id 
					   AND a.operation_id    = b.operation_id 
					   AND a.item_id         = b.item_id
					   AND a.resource_map_id = b.resource_map_id 
					   AND a.route_id        = b.route_id  
				WHERE  a.master_id = @p_master_id 
				AND    a.plan_id   = @p_engine_plan_id 
				;
		  END 

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 5-0 ';
        SET @v_description = N'5-0. th_eng_op_res_group_sn 테이블의 min/avg/max tact_time UPDATE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------
        --임시테이블 삭제
        ------------------------------------------------------------
 
        /* 임시 테이블 재정리 Start ~  , 2023.08.24
        	
	    --1. AS-IS OLD 임시 테이블
	    IF OBJECT_ID('tempdb..#tact_op_flow_temp_1') IS NOT NULL
        DROP TABLE #tact_op_flow_temp_1

        IF OBJECT_ID('tempdb..#tact_op_flow_temp_2') IS NOT NULL
        DROP TABLE #tact_op_flow_temp_2 

        IF OBJECT_ID('tempdb..#tact_op_flow_temp') IS NOT NULL
        DROP TABLE #tact_op_flow_temp

        IF OBJECT_ID('tempdb..#tact_op_flow_temp') IS NOT NULL
        DROP TABLE #tact_op_flow_temp

        IF OBJECT_ID('tempdb..#th_eng_op_res_group_map_1') IS NOT NULL
        DROP TABLE #th_eng_op_res_group_map_1

        IF OBJECT_ID('tempdb..#yield_op_flow_temp') IS NOT NULL
        DROP TABLE #yield_op_flow_temp

        IF OBJECT_ID('tempdb..#tact_op_flow_temp2_temp') IS NOT NULL
        DROP TABLE #tact_op_flow_temp2_temp
		
        IF OBJECT_ID('tempdb..#tact_op_flow_temp2_2') IS NOT NULL
        DROP TABLE #tact_op_flow_temp2_2 

        IF OBJECT_ID('tempdb..#tact_op_flow_temp2') IS NOT NULL
        DROP TABLE #tact_op_flow_temp2

        IF OBJECT_ID('tempdb..#th_eng_op_res_group_map') IS NOT NULL
        DROP TABLE #th_eng_op_res_group_map

        IF OBJECT_ID('tempdb..#yield_op_flow_temp2') IS NOT NULL
        DROP TABLE #yield_op_flow_temp2

        --2. 1차 정리 임시 테이블
        IF OBJECT_ID('tempdb..#tmp_capa_flow_tact_time') IS NOT NULL
        DROP TABLE #tmp_capa_flow_tact_time;

        IF OBJECT_ID('tempdb..#tmp_capa_flow_no_tact_time') IS NOT NULL
        DROP TABLE #tmp_capa_flow_no_tact_time; 

        IF OBJECT_ID('tempdb..#tmp_capa_flow_merge_tact_time') IS NOT NULL
        DROP TABLE #tmp_capa_flow_merge_tact_time;

        IF OBJECT_ID('tempdb..#th_eng_op_res_group_map_capa') IS NOT NULL
        DROP TABLE #th_eng_op_res_group_map_capa;

        IF OBJECT_ID('tempdb..#tmp_capa_flow_yield') IS NOT NULL
        DROP TABLE #tmp_capa_flow_yield;

        IF OBJECT_ID('tempdb..#tmp_line_capa_flow_tact_time') IS NOT NULL
        DROP TABLE #tmp_line_capa_flow_tact_time; 

        IF OBJECT_ID('tempdb..#tmp_line_capa_flow_no_tact_time') IS NOT NULL
        DROP TABLE #tmp_line_capa_flow_no_tact_time; 

        IF OBJECT_ID('tempdb..#tmp_line_capa_flow_merge_tact_time') IS NOT NULL
        DROP TABLE #tmp_line_capa_flow_merge_tact_time;

        IF OBJECT_ID('tempdb..#th_eng_op_res_group_map_line_capa') IS NOT NULL
        DROP TABLE #th_eng_op_res_group_map_line_capa;

        IF OBJECT_ID('tempdb..#tmp_line_capa_flow_yield') IS NOT NULL
        DROP TABLE #tmp_line_capa_flow_yield;

        임시 테이블 재정리 ~ End  , 2023.08.24 */

        /* 신규 공통 임시 테이블 추가 Start ~  , 2023.08.24 */
        IF OBJECT_ID('tempdb..#scm_mst_fp_tact_time_temp') IS NOT NULL
        BEGIN 
            DROP TABLE  #scm_mst_fp_tact_time_temp;          
        END

        IF OBJECT_ID('tempdb..#scm_mst_fp_yield_temp') IS NOT NULL
        BEGIN 
            DROP TABLE  #scm_mst_fp_yield_temp;          
        END

        IF OBJECT_ID('tempdb..#scm_mst_fp_yield_temp1') IS NOT NULL
        BEGIN 
            DROP TABLE  #scm_mst_fp_yield_temp1;          
        END 

        IF OBJECT_ID('tempdb..#th_eng_op_res_group_map_cal_mst') IS NOT NULL
        BEGIN 
            DROP TABLE  #th_eng_op_res_group_map_cal_mst;          
        END
        /* 신규 공통 임시 테이블 추가 ~ End  , 2023.08.24 */

        /* 기존 임시 테이블명 변경  , 2023.08.24 */
        IF OBJECT_ID('tempdb..#th_eng_op_res_group_map_line_capa_cal') IS NOT NULL
        BEGIN 
            DROP TABLE  #th_eng_op_res_group_map_line_capa_cal;          
        END

        IF OBJECT_ID('tempdb..#th_eng_op_res_group_map_line_capa_cal2') IS NOT NULL
        BEGIN 
            DROP TABLE  #th_eng_op_res_group_map_line_capa_cal2;          
        END

        IF OBJECT_ID('tempdb..#div_th_eng_op_res_group_map_cal') IS NOT NULL
        BEGIN 
            DROP TABLE  #div_th_eng_op_res_group_map_cal;          
        END

        IF OBJECT_ID('tempdb..#th_eng_op_res_group_map_cal_add') IS NOT NULL
        BEGIN 
            DROP TABLE  #th_eng_op_res_group_map_cal_add;         
        END
        
        IF OBJECT_ID('tempdb..#th_eng_op_res_group_map_cal_osp_l') IS NOT NULL
        BEGIN 
            DROP TABLE  #th_eng_op_res_group_map_cal_osp_l;          
        END

        IF OBJECT_ID('tempdb..#div_th_eng_op_res_group_map_cal_osp_l') IS NOT NULL
        BEGIN 
            DROP TABLE  #div_th_eng_op_res_group_map_cal_osp_l;          
        END

        IF OBJECT_ID('tempdb..#th_eng_op_res_group_map_cal_add_osp_l') IS NOT NULL
        BEGIN 
            DROP TABLE  #th_eng_op_res_group_map_cal_add_osp_l;          
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
