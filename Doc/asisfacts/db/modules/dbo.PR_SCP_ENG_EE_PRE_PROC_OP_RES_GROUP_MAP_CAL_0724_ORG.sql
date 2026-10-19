

/*
 * Program ID   : PR_SCP_ENG_EE_PRE_PROC_OP_RES_GROUP_MAP_CAL
 * Description  :
                    참고) 공통사항 : 
                              --1. 당월, 차월 일때 IS_USE = 'N' 처리
                                    경우1) tact_time = 0 일때
                                    경우2) line_assign의  priority IN (0, 9) 일때 
                                    경우3) scp_mst_tact_time_except.use_yn = 'N' 일때 (tact_time_start_date ~ tact_time_end_date 까지 is_use = 'N')
                                           ( 단, scp_mst_tact_time_except.use_yn = 'Y' 일때 : tact_time_start_date가 차월이전이라도 차월이후만 scp_mst_tact_time_except(tact_time_start_date ~ tact_time_end_date 기간만큼 scp_mst_tact_time_except.use_yn 값을 그대로 입력함 )
                                           ==>경우3)은 확정구간만큼만(scm_mst_site.fp_plan_period) tact_time 사용할때 ( 확정구간은 use_yn = 'Y' 나머지구간은 use_yn = 'N' 처리할때) 사용하면 됨

                              --2.  차월이후 해당월에 tact_time값이 없으면  th_eng_op_res_group_map_sn 의 값을 default 값으로 사용함

                              --3.  소형(40) 전극 item 일때 item_uom(단위)와 tact_time 불일치로 인한 tact_time 값변경(item_uom : 'EA' 인데 tact_tiem 은 'M' 단위 일때의 값으로 셋팅되어있음)
                                    -FP tact time) scm_mst_tact_time_ver_h_v 과 scp_mst_tact_time 테이블을 조인해서 
                                                   scp_mst_tact_time.item_uom = 'EA'일경우 =>  FP) tact_time :  "scm_mst_tact_time_ver_h_v.tact_time / scp_mst_tact_time.uom_convert_value" (단) scp_mst_tact_time.uom_convert_value 가 NULL이거나 0 이면 1 로 처리)
                                    -SCP tact time) scp_mst_tact_time.item_uom = 'EA'일경우 => SCP) tact_time :  "scp_mst_tact_time.tact_time / scp_mst_tact_time.uom_convert_value" (단) scp_mst_tact_time.uom_convert_value 가 NULL이거나 0 이면 1 로 처리)                                                                                 

                    -----------------------------------------------------------
		            -- 1. Capa 공정 : Line Modeling 비대상 공정 ( th_eng_op_res_group_map_sn.descr 컬럼값이 'CAPA' 일때) 
                    --                - tact_time, yield값을 th_eng_bucket_info의 기간만큼 월별로 데이터 생성
                    -----------------------------------------------------------
                      - 1) tact_time 셋팅 
                            -1)-1) is_use 컬럼 'Y' 셋팅
                                   -1) 당월,차월은 FP의 tact_time 정보(scm_mst_tact_time_ver_h_v.tact_time/ scm_mst_item_line_assign_sn.lane_qty) 사용함
                                       ==> LINE모델링 비대상공정은 line_id 값이 존재하지 않으므로 
                                           eng_scm_site_id, flow_id, division_id, plant_id, item_id, month 그룹핑한 AVG(tact_time) 값을 사용함
                                       ==> 최종 tact_time 컬럼값) ISNULL(AVG(scm_mst_tact_time_ver_h_v.tact_time/scm_mst_item_line_assign_sn.lane_qty), ISNULL(AVG(scp_mst_tact_time.tact_time), th_eng_op_res_group_map_sn.tact_time))
                                                                  * 
                                                                  ISNULL(AVG(scm_mst_yield_ver_h_v.yield), ISNULL(MIN(scp_mst_tact_time.yield), th_eng_op_res_group_map_sn.yield ))

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
                                   -1) 당월,차월은 FP의 tact_time 정보(scm_mst_tact_time_ver_h_v.tact_time/scm_mst_item_line_assign_sn.lane_qty) 사용함
                                       ==> 최종 tact_time 컬럼값) ISNULL( scm_mst_tact_time_ver_h_v.tact_time/scm_mst_item_line_assign_sn.lane_qty, ISNULL(scp_mst_tact_time.tact_time, th_eng_op_res_group_map_sn.tact_time))
                                                                  * 
                                                                  ISNULL(scm_mst_yield_ver_h_v.yield, ISNULL(scp_mst_tact_time.yield, th_eng_op_res_group_map_sn.yield ))  
                                   
                                   -2) 차월이후는 scp관리(scp_mst_tact_time.tact_time) tact_time 사용함
                                       ==> 최종 tact_time 컬럼값) ISNULL(scp_mst_tact_time.tact_time, 1)
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
		            -- 3. 20200330 [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - 전극 수율 개선 : Cell 총 수율을 P 공정에 설정              
                    -----------------------------------------------------------
                       - descr = 'NO_CAPA' 이면서 operation_id가 A3000/A9000 인 경우 Tact Time Except 테이블 정보를 시용하여 yield 생성
                         SCP_MST_TACT_TIME_EXCEPT의 수율 일괄 반영 : Operation_id = 'Z_A00T', Line_id = '-'

                    -----------------------------------------------------------
		            -- 4. th_eng_op_res_group 테이블의 컬럼값 UPDATE                          
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
 * 2018.06.20   KSW            th_eng_bucket_info_sn 테이블 사용시 descr = 'PLAN' 조회조건 추가 (  th_eng_bucket_info_sn 테이블 생성시 plan종료일이후 13주가 추가 되었으므로 반드시 조건필요함)
 * 2018.09.04   KSW            1) divisin_id 조회조건 주석처리 (참고 주석2-1-1)
                               2) operation_id 조인조건 수정 (참고 주석2-3-2)
 * 2018.09.17   KSW            1) 소형(40)이면서 전극일때 tact_time 처리부분 수정 ( 현재 전극의 tact_time 처리시 item_uom(단위)와 tact_time 불일치(item_uom : 'EA' 인데 tact_tiem 은 'M' 단위 일때의 값으로 셋팅되어있음 ) )  참고)주석1-1, 주석1-3, 주석2-1, 주석2-3
                               2) scp_mst_tact_time_except 테이블의 use_yn = 'N'(단, use_yn = 'Y'일경우 기존처리방식 사용)일경우 당월,차월, 차월이후 상관없이 해당기간만큼 use_yn = 'N' 처리( 기존 : tact_time_start_date가 차월이전이라도 차월이후만 scp_mst_tact_time_except(tact_time_start_date ~ tact_time_end_date 기간만큼 scp_mst_tact_time_except.use_yn 값을 그대로 입력함) 참고)주석2-4-1
 * 2018.09.28   KSW            전극 tact_time 계산시 사용되는 lane_qty 컬럼 대상 테이블 변경(scm_mst_item_lane_m_sn.lane_qty -> scm_mst_item_line_assign_sn.lane_qty)  참고) 주석1-1, 주석2-1
 * 2018.10.04   KSW            operation_id 조회조건 수정(참고)주석1-3
 * 2019.03.05   KSW            [재료본부 전지재료 GSCM 구축 프로젝트] 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가 (전지재료('44') 사업부추가로 인한 조건추가) 
 --반영보류
 * 2019.04.05(반영보류_차후사용시 주석해제후 사용하면됨)   KSW            scp_mst_tact_time_except 날짜겹침 방지처리 (참고)주석2-4-0 추가, 주석2-4-1)
 * 2019.07.22   KSG            티라 요청 : PET가 아니라 13주 추가 구간까지 CAL 생성 / th_eng_bucket_info_sn 테이블 사용시 descr = 'PLAN' 조회조건 제거
 * 2020.02.06   KSG            [OSP Line Plan] OSP이면서 Line별 Capa 적용 Site 정보 추가
 * 2020.03.30   KSG            [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - 전극 수율 개선 : Cell 총 수율을 P 공정에 설정
 * 2021.03.12   KSG            PJ20209642 Digital SCM Level.3 달성을 위한 개선 : FP Tact Time/Yield Table 변경
 * 2021.07.27   KSG            PJ20209643 Digital SCM Level.3 달성을 위한 개선(Phase 2) : line assign IN (0, 9) 일때 is_use = 'N' 처리 구간 변경
 * 2022.01.26   LHS			   PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선: 사업부별 추가 계획수립기간을 lookup으로 설정하여 Engine Plan 기간으로 반영
 * 2022.04.04   LHS            PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선: JV사업부 추가: 사업부 조건별 로직구현시 division_id 대신 속성값(attribute3) 기준으로 변경
                                ----------------------------------------------------------------
                                        구분                         자동차           전극
                                ==============================    =============   ==============
                                  division_group(attribute3)  :        81              EE                
                                ------------------------------    -------------   --------------
                                  division_id                 :     81 , 81_UC      EE , EE_UC  
                                ----------------------------------------------------------------
 *
 */

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_EE_PRE_PROC_OP_RES_GROUP_MAP_CAL_0724_ORG]
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

    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_EE_PRE_PROC_OP_RES_GROUP_MAP_CAL';
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
    -- DECLARE @v_division_id       NVARCHAR(30);
    --DECLARE @v_cur_monday        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    DECLARE @d_plan_name         DATETIME = CONVERT(DATETIME, @p_plan_name)  ;
    DECLARE @v_pet_date          NVARCHAR(8) ; -- Plan End Date
	DECLARE @v_add_pet_date      NVARCHAR(8) ; -- Add Plan End Date (2022.01.26)

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
         , @v_division_comp    =  di.ATTRIBUTE4  -- 회사코드
    FROM   scm_mst_division di WITH(NOLOCK)
    WHERE  di.valid_yn         =  'Y' 
    AND    di.division_id      =  @p_division_id    ; 

  -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id  ;  
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN
	  
/*	    -- 20190722 : 13주 추가 구간까지 CAL 생성
	    --SELECT @v_pet_date = p.horizon_end_date
	    SELECT @v_pet_date = CONVERT(NVARCHAR(8), DATEADD(DD, 13*7, CONVERT(DATE, p.horizon_end_date)), 112)
        FROM   dbo.scm_mst_plan p WITH(NOLOCK)
        WHERE  p.division_id = @p_division_id 
        AND    p.plan_id     = @p_plan_id ;
*/  -- lookup 반영전 코드.

        --  Plan End Date (2022.01.26) 
	    SELECT @v_pet_date      = p.horizon_end_date 
			,  @v_add_pet_date  = CONVERT(NVARCHAR(8), DATEADD(dd, ISNULL(B.add_day,(13*7)), CONVERT(DATETIME, P.HORIZON_END_DATE)), 112) -- 추가기간이 NULL이면 디폴트 13주 설정 
        FROM   dbo.scm_mst_plan p WITH(NOLOCK)
		/** 사업부별 추가계획기간 lookup으로 반영  **/ 
		LEFT OUTER JOIN 
			  (
				SELECT a.SEGMENT1 as DIVISION_ID , a.segment2 as ADD_WEEK , A.segment2*7 AS ADD_DAY 
				FROM   scm_adm_lookup_master_detail a(nolock)
				WHERE  a.lookup_type = 'ADD_PLAN_PERIOD'
				and    a.valid_yn    = 'Y' 
			  ) B
				ON ( 1=1
				AND  P.DIVISION_ID  =  B.DIVISION_ID )  
        WHERE  p.division_id = @p_division_id 
        AND    p.plan_id     = @p_plan_id 
		; 

        DELETE /* PR_SCP_ENG_EE_PRE_PROC_OP_RES_GROUP_MAP_CAL */
		FROM   th_eng_op_res_group_map_cal_sn
		WHERE  master_id = @p_master_id 
		AND    plan_id   = @p_engine_plan_id 
		;

        -----------------------------------------------------------
        -- 전체공통 임시테이블 1) FP tact_time 
         /*
            --소형(40) 전극이면서, item_uom = 'EA' 일때  
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

            , CONVERT(NUMERIC(18, 4), CASE WHEN tt.division_group = '40' AND ISNULL(stt.item_uom, 'X') = 'EA' AND ISNULL(stt.operation_group, 'X') = 'E'  --2022.04.04 JV건: tt.division_id -> tt.division_group
                                                 THEN  tt.tact_time/stt.uom_convert_value
                                            ELSE tt.tact_time
                                       END  ) AS tact_time  --FP의  tact_time 데이터 형식 : numeric(18,4)
            
            , tt.tact_time AS tact_time_org
            , stt.item_uom
            , stt.uom_convert_value         
        INTO   #scm_mst_tact_time_sn  

        FROM  (  -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                SELECT tt.* , di.attribute3 AS division_group , di.attribute4 AS division_comp 
                FROM   dbo.scm_mst_tact_time_ver_h_v tt WITH (NOLOCK)
                     , scm_mst_division              di WITH(NOLOCK)
                WHERE  di.division_id    =  tt.division_id
                AND    di.valid_yn       = 'Y'
                AND    di.attribute4     =  @v_division_comp -- 같은회사만 검색
              ) tt
        /* 20220404 변경전
        FROM   dbo.scm_mst_tact_time_ver_h_v tt WITH (NOLOCK)    -- PJ20209642 변경  scm_mst_tact_time_sn  */
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
                            FROM  ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                                    SELECT a.* , di.attribute3 AS division_group , di.attribute4 AS division_comp 
                                    FROM   scp_mst_tact_time  a WITH(NOLOCK) 
                                         , scm_mst_division   di WITH(NOLOCK)
                                    WHERE  di.division_id  =  a.division_id
                                    AND    di.valid_yn     = 'Y'
                                    AND    di.ATTRIBUTE4   = @v_division_comp -- 같은회사 데이터만 가져오기.     
                                  ) aa         
                             /* 20220404 변경전
                            FROM   scp_mst_tact_time aa WITH (NOLOCK)  */
                                    INNER JOIN ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                                                SELECT a.division_id, a.scm_site_id
                                                     , a.plant_id, a.site_id, a.company_id 
                                                     , a.operation_group
                                                FROM   scm_mst_site         a WITH(NOLOCK)  -- 소형('40') 인 division 값을 사용해야 하기 때문에  scm_mst_site_eng (전극일때 모든 scm_mst_site_eng.divison_id = 'EE')가 아닌  scm_mst_site 를 사용해야 한다.
                                                     , scm_mst_division    di WITH(NOLOCK)
                                                WHERE  1=1        
                                                AND    a.site_type       = 'PLANT'
                                                AND    a.operation_group = 'E'
                                                AND    a.valid_yn        = 'Y'
                                                and    di.division_id     = a.division_id 
                                                and    di.valid_yn       = 'Y'
                                                and    di.attribute3     = '40'             -- 2022.04.04 '소형' 구분 컬럼변경
                                                and    di.ATTRIBUTE4     = @v_division_comp -- 2022.04.04 같은회사 데이터만 가져오기.      
                                                
                                                 /* 20220404 변경전
                                                SELECT division_id, scm_site_id
                                                    , plant_id, site_id, company_id 
                                                    , operation_group
                                                FROM scm_mst_site WITH (NOLOCK)  -- 소형('40') 인 division 값을 사용해야 하기 때문에  scm_mst_site_eng (전극일때 모든 scm_mst_site_eng.divison_id = 'EE')가 아닌  scm_mst_site 를 사용해야 한다.
                                                WHERE  division_id = '40'       
                                                AND    site_type   = 'PLANT'
                                                AND    operation_group = 'E'
                                                AND    valid_yn = 'Y' */
                                            ) bb
                                    ON   aa.division_id   = bb.division_id
                                    AND  aa.plant_site_id = bb.scm_site_id
                                    AND  aa.item_uom    = 'EA'
                            WHERE   1 = 1
                            AND     aa.valid_yn = 'Y'
                            AND     aa.division_group IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가), 2022.04.04 수정
                            
                            /* 20220404 변경전
                            AND     aa.division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가) */

                        ) stt
                ON   tt.company_Id    = stt.company_id
                AND  tt.division_id   = stt.division_id
                AND  tt.site_id      = stt.site_id 
                AND  tt.plant_id     = stt.plant_id
                AND  tt.operation_id = stt.operation_id  
                AND  tt.item_id      = stt.item_id
                AND  tt.line_id      = stt.line_id
        WHERE LEFT(tt.operation_id, 1) IN ('E', 'S', 'F', 'A')
        AND   tt.division_group  IN ( '40', '81', '82') --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가), 2022.04.04 수정
        /* 20220404 변경전
        AND   tt.division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가) */
        ;

        -----------------------------------------------------------
        -- 전체공통 임시테이블 2) SCP tact_time 
        /*
            --소형(40) 전극이면서, item_uom = 'EA' 일때  
              => SCP) tact_time :  scp_mst_tact_time.tact_time / scp_mst_tact_time.uom_convert_value
                 단) scp_mst_tact_time.uom_convert_value 가 NULL이거나 0 이면 1 로 처리
        */
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#scp_mst_tact_time') IS NOT NULL
        BEGIN
            DROP TABLE #scp_mst_tact_time
        END 

        SELECT a.division_id, a.plant_site_id, a.item_id, a.operation_id
            ,  a.line_id

            ,  CONVERT(NUMERIC(20, 10), CASE WHEN a.division_group ='40' AND ISNULL(a.item_uom, 'X') = 'EA' AND ISNULL(b.operation_group, 'X') = 'E'  --(2022.04.04)수정: division_id -> division_group
                                                  THEN  a.tact_time /  (CASE WHEN a.uom_convert_value = 0  THEN 1
                                                                             ELSE ISNULL(a.uom_convert_value, 1)  
                                                                        END) --UOM_CONVERT_VALUE 가 NULL이거나 0 이면 1 로 처리
                                             ELSE  a.tact_time
                                        END ) AS tact_time -- SCP의  tact_time 데이터 형식 : numeric(20,10)
            
            ,  a.tact_time AS tact_time_org                                         
            ,  a.yield
            ,  a.valid_yn                                                                     
        
        INTO #scp_mst_tact_time  
        FROM (  -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                SELECT a.* , di.attribute3 AS division_group , di.attribute4 AS division_comp 
                FROM   scp_mst_tact_time  a WITH(NOLOCK) 
                     , scm_mst_division   di WITH(NOLOCK)
                WHERE  di.division_id  =  a.division_id
                AND    di.valid_yn     = 'Y'
                AND    di.attribute4   = @v_division_comp 
              ) a 
             LEFT JOIN ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                        SELECT A.*  , di.attribute3 AS division_group , di.attribute4 AS division_comp 
                        FROM   scm_mst_site      a WITH (NOLOCK)
                                , scm_mst_division  di WITH(NOLOCK)
                        WHERE  di.division_id    =  a.division_id
                        AND    di.valid_yn       = 'Y' 
                        AND    di.attribute4     =  @v_division_comp 
                       ) b
             ON   a.division_id     = b.division_id
             AND  a.plant_site_id   = b.scm_site_id
             AND  b.valid_yn        = 'Y'
             AND  b.division_group  = '40'      --(2022.04.04)컬럼변경
             AND  b.site_type       = 'PLANT'
             AND  b.operation_group = 'E'
        WHERE a.valid_yn = 'Y'
        AND   a.division_group  IN ( '40', '81', '82') --(2022.04.04)컬럼변경. 20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)   
        
        /* 20220404 변경전 
        FROM scp_mst_tact_time a WITH (NOLOCK) 
             LEFT JOIN scm_mst_site b WITH (NOLOCK)
             ON   a.division_id     = b.division_id
             AND  a.plant_site_id   = b.scm_site_id
             AND  b.valid_yn        = 'Y'
             AND  b.division_id     = '40'             
             AND  b.site_type       = 'PLANT'
             AND  b.operation_group = 'E'
        WHERE a.valid_yn = 'Y'
        AND   a.division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가) */ 
        ;
        -----------------------------------------------------------
		-- 1. Capa 공정 : Line Modeling 비대상 공정
        --                Item별 평균 Tact Time 사용
        -----------------------------------------------------------
		--SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 1-1 START';
        SET @v_description = N'1-1. tact_op_flow_temp 생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        -----------------------------------------------------------
		-- 1-1) 임시테이블 생성 ( scm_mst_tact_time_ver_h_v, scm_mst_operation_flow_v 조인테이블)
        -----------------------------------------------------------
        --  참고)  scm_mst_tact_time_ver_h_v의 'operation_id는 단일 공정의 값만 가지지만
        --         th_eng_op_res_group_map_sn의 route_id(=operation_id)값은 'A5000A6000'와 같이 여러공정값이 연결된값을 가지므로 
        --         scm_mst_tact_time_ver_h_v의 조인처리를 위해서 이작업이 필요함   
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#tact_op_flow_temp_1') IS NOT NULL
        DROP TABLE #tact_op_flow_temp_1

        SELECT tt.eng_scm_site_id
             , tt.flow_id
             , tt.origin_division_id
             , tt.plant_id
             , '-' AS line_id
             , tt.item_id
             , tt.month --
             , AVG(tt.tact_time) AS tact_time
        INTO #tact_op_flow_temp_1
        FROM  (
               SELECT CASE WHEN SUBSTRING(op.flow_id, 1, 1) = 'E' THEN t.plant_id + '-E~***'
                           WHEN SUBSTRING(op.flow_id, 1, 1) = 'S' THEN t.plant_id + '-E~***' -- SRS => 전극
                           WHEN SUBSTRING(op.flow_id, 1, 1) = 'A' THEN t.plant_id + '-A~***'
                           WHEN SUBSTRING(op.flow_id, 1, 1) = 'F' THEN t.plant_id + '-A~***' -- 활성화 => CELL
                           WHEN SUBSTRING(op.flow_id, 1, 1) = 'P' THEN t.plant_id + '-P~***'
                      END  AS eng_scm_site_id
                    , op.flow_id
                    , t.division_id AS origin_division_id 
                    , t.plant_id
                    , t.line_id
                    , t.item_id
                    , t.month    -- Tact Time 존재 구간
                                 
                    -- PJ20209642 Lane 수는 View에서 고려되어 있음 
                    , SUM(ISNULL(t.tact_time, 0))  AS tact_time

                 /*   -- 전극은 FP에서 Tact Time으로 관리, 나머지는 Capa 로 관리하므로 Tact Time으로 전환 : OP RES GRAUP MAP / OP RES GRAUP MAP CAL / BUCKET RES CAPA 에 동일 로직
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
               FROM   #scm_mst_tact_time_sn t WITH(NOLOCK) --20180917 수정 

               INNER JOIN ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group(attribute3) )
                            SELECT t.* , di.attribute3 AS division_group , di.attribute4 AS division_comp 
                            FROM   dbo.scm_mst_operation_flow_v    t WITH(NOLOCK)
                                , scm_mst_division               di WITH(NOLOCK)
                            WHERE  di.division_id    =  t.division_id
                            AND    di.valid_yn       = 'Y'
                            AND    di.attribute4     = @v_division_comp  -- 같은회사 검색
                          ) op 
                /* 20220404 변경전 
               INNER JOIN dbo.scm_mst_operation_flow_v op WITH(NOLOCK) */

               ON     t.division_id  = op.division_id
               AND    t.company_id   = op.company_id
               AND    t.site_id      = op.site_id
               AND    t.operation_id = op.operation_id
               AND   op.division_group  IN ( '40', '81', '82')  --2022.04.04 컬럼변경. 20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)

               /* 20220404 변경전 
               AND    op.division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가) 
               */ 
               -- PJ20209642 Lane 수는 View에서 고려되어 있음 
               --20180928 수정처리함 (scm_mst_item_lane_m_sn.lane_qty -> scm_mst_item_line_assign_sn.lane_qty 변경)
                /* -- PJ20209642 Lane 수는 View에서 고려되어 있음 
                LEFT JOIN (SELECT DISTINCT la.company_id, la.division_id, la.site_id
                                        , la.plant_id, la.factory_id, la.item_id
                                        , la.operation_id, la.line_id
                                        , la.lane_qty  -- 20180928 추가(scm_mst_item_lane_m_sn.lane_qty 값을 scm_mst_item_line_assign_sn.lane_qty 변경하기 위해서 추가함)
                                        , la.month     -- 20180928 추가(scm_mst_item_lane_m_sn.lane_qty 값을 scm_mst_item_line_assign_sn.lane_qty 변경하기 위해서 추가함) 
                        FROM   dbo.scm_mst_item_line_assign_sn la WITH(NOLOCK)
                        WHERE  1=1
                        AND    la.active_flag = 'Y'
                        AND    la.priority    NOT IN ('0', '9') -- 0/9 는 FP에서 사용 안 하는 정보임
                        
                        --AND    la.division_id = @p_division_id -- 20180702 주석처리
                        AND    la.division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)                        
                ) li
                ON     t.company_id   = li.company_id
                AND    t.division_id  = li.division_id
                AND    t.site_id      = li.site_id
                AND    t.plant_id     = li.plant_id
                AND    t.factory_id   = li.factory_id
                AND    t.operation_id = li.operation_id
                AND    t.line_id      = li.line_id
                AND    t.item_id      = li.item_id
                AND    t.month        = li.month
               */
               WHERE  t.month       >= SUBSTRING(@p_plan_name, 1, 6)
               AND    t.month       <  CONVERT(NVARCHAR(6), DATEADD(m, 2, CONVERT(DATETIME,LEFT(@p_plan_name, 6) + '01')), 112) -- 20180425 추가 (당월, 차월 까지만 조회되게하기위해서)
               --AND    t.division_id  = @p_division_id --'81'  -- 20180702 주석처리 
               
               GROUP BY op.flow_id, t.division_id, t.plant_id, t.line_id, t.item_id, t.month                                   
              ) tt
        --WHERE  tt.tact_time <> 0 --20180605 주석처리함 ( tact_time = 0 건 INSERT 할때 is_use = 'N' 처리함)
        GROUP BY tt.eng_scm_site_id, tt.flow_id, tt.origin_division_id, tt.plant_id, tt.item_id, tt.month
        ;

        -----------------------------------------------------------
		-- 1-1)-2) 임시테이블 생성 (FP용 tact_time(scm_mst_tact_time테이블)에서 당월, 차월 데이터중 누락된 월 생성)
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#tact_op_flow_temp_2') IS NOT NULL
        DROP TABLE #tact_op_flow_temp_2 

        -- FP tact_time 은 당월과 차월만 사용하는데 두달중 누락된 월을 tact_time = 0 으로 생성해줌( tact_time =0 인건들은 최종데이터 생성부분에서 is_use = 'N'처리됨)
        SELECT a.eng_scm_site_id, a.flow_id, a.origin_division_id, a.plant_id, '-' AS line_id, a.item_id 
             , CASE WHEN a.max_month  = LEFT(@p_plan_name, 6)  THEN CONVERT(NVARCHAR(6), DATEADD(m, 1, CONVERT(DATETIME, LEFT(@p_plan_name, 6) + '01')), 112)
                    ELSE LEFT(@p_plan_name, 6)
               END AS month 
             , 0.0 AS tact_time 
        INTO   #tact_op_flow_temp_2
        FROM   ( SELECT eng_scm_site_id, flow_id, origin_division_id, plant_id, item_id
                      , count(*)   AS cnt
                      , max(month) AS max_month
                 FROM   #tact_op_flow_temp_1 a             
                 GROUP BY eng_scm_site_id, flow_id,origin_division_id, plant_id, item_id 
                 HAVING count(*) = 1
                 ) a
             --, ( SELECT LEFT(@p_plan_name, 6) AS month
             --    UNION ALL SELECT  CONVERT(NVARCHAR(6), DATEADD(m, 1, CONVERT(DATETIME, LEFT(@p_plan_name, 6) + '01')), 112) AS month  ) b
        ;

        -----------------------------------------------------------
		-- 1-1)-3)  위 2-1)-1), 2-1)-2) 합치기
        --          - "FP용에서 당월, 차월 누락된 월 tact time정보" 와  "FP용 tact_time 당월, 차월 tact time정보"       
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#tact_op_flow_temp') IS NOT NULL
        DROP TABLE #tact_op_flow_temp

        SELECT eng_scm_site_id, flow_id, origin_division_id, plant_id, line_id, item_id
            ,  month, tact_time
        INTO   #tact_op_flow_temp
        FROM (
               -- 당월, 차월 누락된 월 생성
               SELECT eng_scm_site_id, flow_id, origin_division_id, plant_id, line_id, item_id
                   ,  month, tact_time
               FROM   #tact_op_flow_temp_2 
               
               UNION ALL
               
               -- FP용 tact_time 당월, 차월 정보
               SELECT * FROM #tact_op_flow_temp_1 
             ) x
        ;
        
        -----------------------------------------------------------
		-- 1-1)-4)  th_eng_op_res_group_map_sn 정보를 이용해서 month 당월, 차월 데이터 생성
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#th_eng_op_res_group_map_1') IS NOT NULL
        DROP TABLE #th_eng_op_res_group_map_1

        SELECT res.site_id AS eng_scm_site_id
             , res.route_id
             , res.origin_division_id 
             , res.plant_id, '-' AS line_id
             , res.item_id
             , b.month
        INTO   #th_eng_op_res_group_map_1
        FROM   
        (
               SELECT g.*
                    , s.plant_id, s.origin_division_id 
               FROM   th_eng_op_res_group_map_sn g WITH(NOLOCK)
                    
                    -- 20180702 수정
                    --, scm_mst_site_eng           s WITH(NOLOCK)
                    , ( SELECT b.division_id AS  origin_division_id
                             , a.company_id, a.eng_scm_site_id, a.plant_id 
                             , a.modeling_id, a.plan_id, a.plan_type, a.plan_seq    
                        FROM scm_mst_site_eng a WITH (NOLOCK) 
                             INNER JOIN scm_mst_site b WITH (NOLOCK)
                             ON a.scm_site_id = b.scm_site_id  
                             AND a.division_id  = @p_division_id 
                             AND a.plan_id      = @p_plan_id
                             AND a.plan_type    = @p_plan_type 
                             AND a.plan_seq     = @p_seq
                             AND a.site_type    = 'PLANT'
                             AND b.valid_yn     = 'Y'
                      ) s                        

               WHERE  g.master_id   = @p_master_id
               AND    g.plan_id     = @p_engine_plan_id
               --AND    s.modeling_id = @p_modeling_id
               --AND    s.plan_id     = @p_plan_id
               --AND    s.plan_type   = @p_plan_type
               --AND    s.plan_seq    = @p_seq
               AND    g.site_id     = s.eng_scm_site_id
               -- Line Capa 적용 대상 공정
               AND    g.descr       = 'CAPA'
              
        ) res
        , ( SELECT LEFT(@p_plan_name, 6) AS month
            UNION ALL SELECT  CONVERT(NVARCHAR(6), DATEADD(m, 1, CONVERT(DATETIME, LEFT(@p_plan_name, 6) + '01')), 112) AS month  ) b

        -----------------------------------------------------------
		-- 1-1)-5)  th_eng_op_res_group_map_sn 에만 존재하는 tact time 정보 추가 INSERET
        --         - FP용 tact time정보에 존재하지 않는 tact time 정보를 위 1-1)-3)에서 생성한 #tact_op_flow_temp 테이블에 추가 INSERT
        -----------------------------------------------------------
        INSERT INTO #tact_op_flow_temp
        (
           eng_scm_site_id 
        ,  flow_id
        ,  origin_division_id
        ,  plant_id
        ,  line_id 
        ,  item_id
        ,  month
        ,  tact_time 
        )
        SELECT a.eng_scm_site_id
            , a.route_id
            , a.origin_division_id  -- 20180702 수정 ( 변경전 : , a.division_id ) 
            , a.plant_id
            , a.line_id
            , a.item_id
            ,  a.month
            ,  0.0 AS tact_time 
         
        FROM  #th_eng_op_res_group_map_1 a
              LEFT JOIN #tact_op_flow_temp b
              ON   a.eng_scm_site_id     = b.eng_scm_site_id 
              AND  a.route_id            = b.flow_id
              AND  a.origin_division_id  = b.origin_division_id -- 20180702 수정 ( 변경전 : AND  a.division_id     = b.division_id )
              AND  a.plant_id            = b.plant_id              
              AND  a.item_id             = b.item_id 
        WHERE b.origin_division_id IS NULL
		;
		
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 1-1 END';
        SET @v_description = N'1-1. tact_op_flow_temp 생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
		-- 1-2) 임시테이블 생성 ( scm_mst_yield_ver_h_v, scm_mst_operation_flow_v 조인테이블)
        -----------------------------------------------------------
        --  참고)  scm_mst_yield_ver_h_v의 'operation_id는 단일 공정의 값만 가지지만
        --         th_eng_op_res_group_map_sn의 route_id(=operation_id)값은 'A5000A6000'와 같이 여러공정값이 연결된값을 가지므로 
        --         scm_mst_yield_ver_h_v의 조인처리를 위해서 이작업이 필요함   
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#yield_op_flow_temp') IS NOT NULL
        DROP TABLE #yield_op_flow_temp

        SELECT tt.eng_scm_site_id
             , tt.flow_id
             , tt.origin_division_id
             , tt.plant_id
             , '-' AS line_id
             , tt.item_id
             , tt.month --
             , AVG(tt.yield) AS yield
        INTO #yield_op_flow_temp
        FROM  (
               SELECT CASE WHEN SUBSTRING(op.flow_id, 1, 1) = 'E' THEN t.plant_id + '-E~***'
                           WHEN SUBSTRING(op.flow_id, 1, 1) = 'S' THEN t.plant_id + '-E~***' -- SRS => 전극
                           WHEN SUBSTRING(op.flow_id, 1, 1) = 'A' THEN t.plant_id + '-A~***'
                           WHEN SUBSTRING(op.flow_id, 1, 1) = 'F' THEN t.plant_id + '-A~***' -- 활성화 => CELL
                           WHEN SUBSTRING(op.flow_id, 1, 1) = 'P' THEN t.plant_id + '-P~***'
                      END  AS eng_scm_site_id
                    , op.flow_id
                    , t.division_id AS origin_division_id
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

               FROM  ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group(attribute3) )
                        SELECT t.* , di.attribute3 AS division_group , di.attribute4 AS division_comp 
                        FROM   dbo.scm_mst_yield_ver_h_v t  WITH(NOLOCK)    -- PJ20209642 변경  scm_mst_yield_sn
                            , scm_mst_division          di  WITH(NOLOCK)
                        WHERE  di.division_id    =  t.division_id
                        AND    di.valid_yn       = 'Y'
                        AND    di.attribute4     = @v_division_comp   --회사코드
                      ) t 
                    , ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group(attribute3) )
                        SELECT op.* , di.attribute3 AS division_group , di.attribute4 AS division_comp 
                        FROM   dbo.scm_mst_operation_flow_v op WITH(NOLOCK)
                            , scm_mst_division              di WITH(NOLOCK)
                        WHERE  di.division_id    =  op.division_id
                        AND    di.valid_yn       = 'Y'
                        AND    di.attribute4     = @v_division_comp  --회사코드
                      ) op
               WHERE  t.division_id       = op.division_id
               AND    t.company_id        = op.company_id
               AND    t.site_id           = op.site_id
               AND    t.operation_id      = op.operation_id
               AND    t.month             >= SUBSTRING(@p_plan_name, 1, 6)
               AND    t.month             <  CONVERT(NVARCHAR(6), DATEADD(m, 2, CONVERT(DATETIME,LEFT(@p_plan_name, 6) + '01')), 112) -- 20180425 추가 (당월, 차월 까지만 조회되게하기위해서)
               AND    t.division_group  IN ( '40', '81', '82')  --2022.04.04 컬럼변경. 20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)    
               AND   op.division_group  IN ( '40', '81', '82')  --2022.04.04 컬럼변경. 20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)                 
               /* 20220404 변경전
               FROM   dbo.scm_mst_yield_ver_h_v t WITH (NOLOCK)    -- PJ20209642 변경  scm_mst_yield_sn
                    , dbo.scm_mst_operation_flow_v op WITH(NOLOCK)
               WHERE  t.division_id       = op.division_id
               AND    t.company_id        = op.company_id
               AND    t.site_id           = op.site_id
               AND    t.operation_id      = op.operation_id
               AND    t.month             >= SUBSTRING(@p_plan_name, 1, 6)
               AND    t.month             <  CONVERT(NVARCHAR(6), DATEADD(m, 2, CONVERT(DATETIME,LEFT(@p_plan_name, 6) + '01')), 112) -- 20180425 추가 (당월, 차월 까지만 조회되게하기위해서)
               --AND    t.division_id       = @p_division_id --'81'  -- 20180702 수정
               AND    t.division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)    
               AND    op.division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)  
               */ 
               GROUP BY op.flow_id, t.division_id, t.plant_id, t.line_id, t.item_id, t.month                                   
              ) tt
        GROUP BY tt.eng_scm_site_id, tt.flow_id, tt.origin_division_id, tt.plant_id, tt.item_id, tt.month
        ;
		
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 1-2';
        SET @v_description = N'1-2. yield_op_flow_temp 생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
		-- 1-3) CAPA 대상 INSERT
        -----------------------------------------------------------		
        INSERT INTO /* PR_SCP_ENG_EE_PRE_PROC_OP_RES_GROUP_MAP_CAL */ th_eng_op_res_group_map_cal_sn
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
             --, ISNULL(tat.end_dttm, DATEADD(DD, 52*7 ,(CONVERT(DATETIME, @p_plan_name))))
             , ISNULL(tat.end_dttm, CONVERT(DATETIME, @v_add_pet_date)) AS end_dttm   -- (2022.01.26) @v_pet_date ->  @v_add_pet_date 으로 변경
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
                    
                    -- 20180702 수정
                    --, scm_mst_site_eng           s WITH(NOLOCK)
                    , ( SELECT b.division_id AS  origin_division_id
                             , a.company_id, a.eng_scm_site_id, a.plant_id 
                             , a.modeling_id, a.plan_id, a.plan_type, a.plan_seq    
                        FROM scm_mst_site_eng a WITH (NOLOCK) 
                             INNER JOIN scm_mst_site b WITH (NOLOCK)
                             ON a.scm_site_id = b.scm_site_id  
                             AND a.division_id  = @p_division_id 
                             AND a.plan_id      = @p_plan_id
                             AND a.plan_type    = @p_plan_type 
                             AND a.plan_seq     = @p_seq
                             AND a.site_type    = 'PLANT'
                             AND b.valid_yn     = 'Y'
                      ) s                        

               WHERE  g.master_id   = @p_master_id
               AND    g.plan_id     = @p_engine_plan_id
               --AND    s.modeling_id = @p_modeling_id
               --AND    s.plan_id     = @p_plan_id
               --AND    s.plan_type   = @p_plan_type
               --AND    s.plan_seq    = @p_seq
               AND    g.site_id     = s.eng_scm_site_id
               -- Capa 적용 대상 공정
               AND    g.descr       = 'CAPA'
              ) res
              LEFT OUTER JOIN 
                 (SELECT t.origin_division_id
                       , t.plant_id
                       , t.flow_id --
                       , '-' AS line_id -- Line Capa 비대상이면 '-' 로 들어옴
                       , t.item_id
                       , t.month    -- Tact Time 존재 구간
                       , buc.start_dttm
                       , buc.end_dttm
                       
                       , t.tact_time --
                       , t.eng_scm_site_id --

                  FROM   #tact_op_flow_temp t WITH(NOLOCK)
                  
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
                  
				      --, (SELECT b.master_id
          --                    , b.plan_id
          --                    , CONVERT(CHAR(6), b.start_dttm, 112) AS month
          --                    , MIN(b.start_dttm) AS start_dttm
          --                    , MAX(b.end_dttm)   AS end_dttm
          --               FROM   th_eng_bucket_info_sn b WITH(NOLOCK)
          --               WHERE  b.master_id   = @p_master_id
          --               AND    b.plan_id     = @p_engine_plan_id
          --               -- 20190722 : 13주 추가 구간까지 CAL 생성
          --               --AND    b.descr       = 'PLAN'  -- 20180620 추가 (  plan시작일~ plan종료일 : descr = 'PLAN' , plan종료일이후~ 13주 : descr = 'ADD')
          --               GROUP BY b.master_id, b.plan_id, CONVERT(CHAR(6), b.start_dttm, 112)
          --             ) buc
                  WHERE  t.month      >= SUBSTRING(@p_plan_name, 1, 6)
                  AND    t.month     <   CONVERT(NVARCHAR(6), DATEADD(m, 2, CONVERT(DATETIME,LEFT(@p_plan_name, 6) + '01')), 112) -- 20180425 추가 (당월, 차월 까지만 조회되게하기위해서)
                  AND    t.month     = buc.month
                  --AND    t.origin_division_id = @p_division_id  -- 20180702 수정
                  
                  GROUP BY t.origin_division_id, t.plant_id, t.flow_id, t.item_id, t.month    -- Tact Time 존재 구간
                         , buc.start_dttm, buc.end_dttm
                         , t.tact_time, t.eng_scm_site_id 
                 
                 --/*
				 -- 차월이후 부터는 SCP용 Tact Time 정보를 사용하기 위해서  tact_time 값을 NULL 처리함 ( 위 INSERT부분에서 SCP용 tact time값을 적용함, 차월이후는 bucket_info 월 기준으로 생성됨)
                  UNION
                  SELECT t.origin_division_id
                       , t.plant_id
                       , t.flow_id --
                       , '-' AS line_id -- Line Capa 비대상이면 '-' 로 들어옴
                       , t.item_id
                       , buc.month    -- Tact Time 미존재 미래 구간
                       , buc.start_dttm
                       , buc.end_dttm
                       
                       , NULL AS tact_time  --20180425 수정 ( 차월이후는 scp의 tact_time(scp_mst_tact_time.tact_time) 정보 사용하면되므로 null 처리함) (변경전 : , t.tact_time)
                       , t.eng_scm_site_id  --
                  FROM   #tact_op_flow_temp t WITH(NOLOCK)
				      , (SELECT t.origin_division_id
                              , t.plant_id
                              , t.flow_id
                              , t.line_id
                              , t.item_id
                              , MAX(t.month) AS month
                         FROM   #tact_op_flow_temp t WITH(NOLOCK)
                         WHERE  t.month      >= SUBSTRING(@p_plan_name, 1, 6)
                         --AND    t.origin_division_id = @p_division_id  -- 20180702 수정
                         
                         GROUP BY t.origin_division_id, t.plant_id, t.flow_id, t.line_id, t.item_id
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
				      --, (SELECT b.master_id
          --                    , b.plan_id
          --                    , CONVERT(CHAR(6), b.start_dttm, 112) AS month
          --                    , MIN(b.start_dttm) AS start_dttm
          --                    , MAX(b.end_dttm)   AS end_dttm
          --               FROM   th_eng_bucket_info_sn b WITH(NOLOCK)
          --               WHERE  b.master_id   = @p_master_id
          --               AND    b.plan_id     = @p_engine_plan_id
          --               -- 20190722 : 13주 추가 구간까지 CAL 생성
          --               --AND    b.descr       = 'PLAN'  -- 20180620 추가 (  plan시작일~ plan종료일 : descr = 'PLAN' , plan종료일이후~ 13주 : descr = 'ADD')
          --               GROUP BY b.master_id, b.plan_id, CONVERT(CHAR(6), b.start_dttm, 112)
          --             ) buc
                  WHERE  t.origin_division_id  = tm.origin_division_id
                  AND    t.plant_id     = tm.plant_id
                  AND    t.flow_id      = tm.flow_id --
                  AND    t.line_id      = tm.line_id
                  AND    t.item_id      = tm.item_id
                  AND    t.month        = tm.month
                  AND    buc.month      > t.month
                  --AND    t.origin_division_id  = @p_division_id  -- 20180702 수정
                  
                  GROUP BY t.origin_division_id, t.plant_id, t.flow_id, t.item_id, buc.month    -- Tact Time 존재 구간
                         , buc.start_dttm, buc.end_dttm
                         , t.tact_time, t.eng_scm_site_id 
                 --*/
                 ) tat
               --ON  res.plant_id      = tat.plant_id    --   
               ON  res.site_id      = tat.eng_scm_site_id -- 
               AND res.route_id     = tat.flow_id  --     
              -- Line Modeling 비대상 : Line 정보 제거
              --   AND res.line_id      = tat.line_id
               AND res.item_id      = tat.item_id

              --20180313 YIELD 처리 추가
               LEFT OUTER JOIN 
                 (SELECT t.origin_division_id
                       , t.plant_id
                       , t.flow_id --
                       , '-' AS line_id -- Line Capa 비대상이면 '-' 로 들어옴
                       , t.item_id
                       , t.month    -- yiled 존재 구간
                       , buc.start_dttm
                       , buc.end_dttm
                       
                       , t.yield --
                       , t.eng_scm_site_id --

                  FROM  #yield_op_flow_temp t WITH(NOLOCK)
                  
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
				      --, (SELECT b.master_id
          --                    , b.plan_id
          --                    , CONVERT(CHAR(6), b.start_dttm, 112) AS month
          --                    , MIN(b.start_dttm) AS start_dttm
          --                    , MAX(b.end_dttm)   AS end_dttm
          --               FROM   th_eng_bucket_info_sn b WITH(NOLOCK)
          --               WHERE  b.master_id   = @p_master_id
          --               AND    b.plan_id     = @p_engine_plan_id
          --               -- 20190722 : 13주 추가 구간까지 CAL 생성
          --               --AND    b.descr       = 'PLAN'  -- 20180620 추가 (  plan시작일~ plan종료일 : descr = 'PLAN' , plan종료일이후~ 13주 : descr = 'ADD')
          --               GROUP BY b.master_id, b.plan_id, CONVERT(CHAR(6), b.start_dttm, 112)
          --             ) buc
                  WHERE  t.month      >= SUBSTRING(@p_plan_name, 1, 6)
                  AND    t.month      <  CONVERT(NVARCHAR(6), DATEADD(m, 2, CONVERT(DATETIME,LEFT(@p_plan_name, 6) + '01')), 112) -- 20180425 추가 (당월, 차월 까지만 조회되게하기위해서)
                  AND    t.month       = buc.month
                  --AND    t.origin_division_id = @p_division_id
                  
                  GROUP BY t.origin_division_id, t.plant_id, t.flow_Id, t.item_id, t.month    -- yield 존재 구간
                         , buc.start_dttm, buc.end_dttm
                         , t.yield, t.eng_scm_site_id 
                  
                  --/*
				 -- 차월이후 부터는 SCP용 yield 정보를 사용하기 위해서  yield 값을 NULL 처리함 ( 위 INSERT부분에서 SCP용 yield 값을 적용함, 차월이후는 bucket_info 월 기준으로 생성됨)
                  UNION
                  SELECT t.origin_division_id
                       , t.plant_id
                       , t.flow_id --
                       , '-' AS line_id -- Line Capa 비대상이면 '-' 로 들어옴
                       , t.item_id
                       , buc.month    -- yield 미존재 미래 구간
                       , buc.start_dttm
                       , buc.end_dttm
                      
                       , NULL AS yield       --20180425 수정 ( 차월이후는 scp의 yield(scp_mst_tact_time.yield) 정보 사용하면되므로 null 처리함) (변경전 : , t.yield )
                       , t.eng_scm_site_id -- 

                  FROM  #yield_op_flow_temp t WITH(NOLOCK)
				      , (SELECT t.origin_division_id
                              , t.plant_id
                              , t.flow_id --
                              , t.line_id
                              , t.item_id
                              , MAX(t.month) AS month
                         FROM   #yield_op_flow_temp t WITH(NOLOCK)
                         WHERE t.month      >= SUBSTRING(@p_plan_name, 1, 6)
                         --AND   t.origin_division_id = @p_division_id  -- 20180702 수정
                         
                         GROUP BY t.origin_division_id, t.plant_id, t.flow_id, t.line_id, t.item_id
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
				      --, (SELECT b.master_id
          --                    , b.plan_id
          --                    , CONVERT(CHAR(6), b.start_dttm, 112) AS month
          --                    , MIN(b.start_dttm) AS start_dttm
          --                    , MAX(b.end_dttm)   AS end_dttm
          --               FROM   th_eng_bucket_info_sn b WITH(NOLOCK)
          --               WHERE  b.master_id   = @p_master_id
          --               AND    b.plan_id     = @p_engine_plan_id
          --               -- 20190722 : 13주 추가 구간까지 CAL 생성
          --               --AND    b.descr       = 'PLAN'  -- 20180620 추가 (  plan시작일~ plan종료일 : descr = 'PLAN' , plan종료일이후~ 13주 : descr = 'ADD')
          --               GROUP BY b.master_id, b.plan_id, CONVERT(CHAR(6), b.start_dttm, 112)
          --             ) buc
                  WHERE  t.origin_division_id  = tm.origin_division_id
                  AND    t.plant_id     = tm.plant_id
                  AND    t.flow_id      = tm.flow_id --
                  AND    t.line_id      = tm.line_id
                  AND    t.item_id      = tm.item_id
                  AND    t.month        = tm.month
                  AND    buc.month      > t.month
                  --AND    t.origin_division_id  = @p_division_id       20180702 수정
                  
                  GROUP BY t.origin_division_id, t.plant_id, t.flow_id, t.item_id, buc.month    -- yield 존재 구간
                         , buc.start_dttm, buc.end_dttm
                         , t.yield, t.eng_scm_site_id --
                  --*/
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
                          FROM #scp_mst_tact_time WITH (NOLOCK) --20180917 수정 ( 변경전 : FROM scp_mst_tact_time WITH (NOLOCK))
                          WHERE valid_yn    = 'Y'
                          --AND   division_id = @p_division_id  -- 20180702 수정
                          
                          GROUP BY division_id, plant_site_id, item_id, operation_id                           
                        ) smtt
              ON  res.site_id      = smtt.eng_scm_site_id
              AND res.item_id      = smtt.item_id 
              AND res.operation_id LIKE smtt.operation_id + '%' --20181004 수정(변경전 : AND res.operation_id = smtt.operation_id)

        WHERE  res.resource_map_level = 1
		;
        
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 1-3';
        SET @v_description = N'1-3. CAPA 대상 INSERT ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
		-- 2. Capa 공정 : Line Modeling 대상 공정
        --                Line/Item별 지정된 Tact Time 사용 => OP RES GROUP MAP에 반영되어 있으므로 CAL에서는 별도 처리하지 않음
        -----------------------------------------------------------
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 2-1-1 START';
        SET @v_description = N'2-1-1. tact_op_flow_temp2 생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        -----------------------------------------------------------
		-- 2-1)-1) 임시테이블 생성 ( scm_mst_tact_time_ver_h_v, scm_mst_operation_flow_v 조인테이블)
        -----------------------------------------------------------
        --  참고)  scm_mst_tact_time_ver_h_v의 'operation_id는 단일 공정의 값만 가지지만
        --         th_eng_op_res_group_map_sn의 route_id(=operation_id)값은 'A5000A6000'와 같이 여러공정값이 연결된값을 가지므로 
        --         scm_mst_tact_time_ver_h_v의 조인처리를 위해서 이작업이 필요함   
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#tact_op_flow_temp2_temp') IS NOT NULL
        DROP TABLE #tact_op_flow_temp2_temp 

        SELECT eng_scm_site_id
             , flow_id
             , origin_division_id
             , plant_id
             , line_id
             , item_id
             , month
			 , tact_time
        INTO #tact_op_flow_temp2_temp     
        FROM (
              SELECT CASE WHEN SUBSTRING(op.flow_id, 1, 1) = 'E' THEN t.plant_id + '-E~***'
                          WHEN SUBSTRING(op.flow_id, 1, 1) = 'S' THEN t.plant_id + '-E~***' -- SRS => 전극
                          WHEN SUBSTRING(op.flow_id, 1, 1) = 'A' THEN t.plant_id + '-A~***'
                          WHEN SUBSTRING(op.flow_id, 1, 1) = 'F' THEN t.plant_id + '-A~***' -- 활성화 => CELL
                          WHEN SUBSTRING(op.flow_id, 1, 1) = 'P' THEN t.plant_id + '-P~***'
                     END  AS eng_scm_site_id
                   , op.flow_id
                   , t.division_id AS origin_division_id
                   , t.plant_id
                   , t.line_id
                   , t.item_id
                   , t.month    -- Tact Time 존재 구간
                                 
                    -- PJ20209642 Lane 수는 View에서 고려되어 있음 
                    , SUM(ISNULL(t.tact_time, 0))  AS tact_time
                                 
                 /*  -- 전극은 FP에서 Tact Time으로 관리, 나머지는 Capa 로 관리하므로 Tact Time으로 전환 : OP RES GRAUP MAP / OP RES GRAUP MAP CAL / BUCKET RES CAPA 에 동일 로직
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
              FROM   #scm_mst_tact_time_sn t WITH(NOLOCK) --20180917 수정 
              INNER JOIN ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                          select op.* , di.attribute3 AS division_group , di.attribute4 AS division_comp 
                          from   dbo.scm_mst_operation_flow_v op WITH(NOLOCK)
                               , scm_mst_division             di WITH(NOLOCK)
                          WHERE  di.division_id    =  op.division_id
                          AND    di.valid_yn       = 'Y'
                          AND    di.attribute4     = @v_division_comp  --회사코드
                        ) op 
              /* 20220404 변경전
              INNER JOIN dbo.scm_mst_operation_flow_v op WITH(NOLOCK)   */
                      ON     t.division_id  = op.division_id
                      AND    t.company_id   = op.company_id
                      AND    t.site_id      = op.site_id
                      AND    t.operation_id = op.operation_id
                      AND   op.division_group  IN ( '40', '81', '82') --2022.04.04 컬럼변경. 20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)
              /* 20220404 변경전
              AND    op.division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가) 
	          */
              --20180928 수정처리함 (scm_mst_item_lane_m_sn.lane_qty -> scm_mst_item_line_assign_sn.lane_qty 변경)
              /* -- PJ20209642 Lane 수는 View에서 고려되어 있음 
              LEFT JOIN (SELECT DISTINCT la.company_id, la.division_id, la.site_id
                                       , la.plant_id, la.factory_id, la.item_id
                                       , la.operation_id, la.line_id
                                       , la.lane_qty  -- 20180928 추가(scm_mst_item_lane_m_sn.lane_qty 값을 scm_mst_item_line_assign_sn.lane_qty 변경하기 위해서 추가함)
                                       , la.month     -- 20180928 추가(scm_mst_item_lane_m_sn.lane_qty 값을 scm_mst_item_line_assign_sn.lane_qty 변경하기 위해서 추가함)
                         FROM   dbo.scm_mst_item_line_assign_sn la WITH(NOLOCK)
                         WHERE  1=1
                         AND    la.active_flag = 'Y'
                         AND    la.priority    NOT IN ('0', '9') -- 0/9 는 FP에서 사용 안 하는 정보임
                         
                         --AND    la.division_id = @p_division_id -- 20180702 주석처리
                         AND    la.division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)
                ) li
                ON     t.company_id   = li.company_id
                AND    t.division_id  = li.division_id
                AND    t.site_id      = li.site_id
                AND    t.plant_id     = li.plant_id
                AND    t.factory_id   = li.factory_id
                AND    t.operation_id = li.operation_id
                AND    t.line_id      = li.line_id
                AND    t.item_id      = li.item_id
                AND    t.month        = li.month 
              */
              WHERE  t.month       >= SUBSTRING(@p_plan_name, 1, 6)
              AND    t.month       <  CONVERT(NVARCHAR(6), DATEADD(m, 2, CONVERT(DATETIME,LEFT(@p_plan_name, 6) + '01')), 112) -- 20180425 추가 (당월, 차월 까지만 조회되게하기위해서)
              --AND    t.division_id = @p_division_id --'81' --20180904 주석처리
              GROUP BY op.flow_id, t.division_id, t.plant_id, t.line_id, t.item_id, t.month 
             ) a
        --WHERE  a.tact_time <> 0 --20180605 주석처리함 ( tact_time = 0 건 INSERT 할때 is_use = 'N' 처리함)
        ;


        -----------------------------------------------------------
		-- 2-1)-2) 임시테이블 생성 (FP용 tact_time(scm_mst_tact_time테이블)에서 당월, 차월 데이터중 누락된 월 생성)
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#tact_op_flow_temp2_2') IS NOT NULL
        DROP TABLE #tact_op_flow_temp2_2 

        -- FP tact_time 은 당월과 차월만 사용하는데 두달중 누락된 월을 tact_time = 0 으로 생성해줌( tact_time =0 인건들은 최종데이터 생성부분에서 is_use = 'N'처리됨)
        SELECT a.eng_scm_site_id, a.flow_id, a.origin_division_id, a.plant_id, a.line_id, a.item_id 
             , CASE WHEN a.max_month  = LEFT(@p_plan_name, 6)  THEN CONVERT(NVARCHAR(6), DATEADD(m, 1, CONVERT(DATETIME, LEFT(@p_plan_name, 6) + '01')), 112)
                    ELSE LEFT(@p_plan_name, 6)
               END AS month 
             , 0.0 AS tact_time 
        INTO   #tact_op_flow_temp2_2
        FROM   ( SELECT eng_scm_site_id, flow_id, origin_division_id, plant_id, line_id, item_id
                      , count(*)   AS cnt
                      , max(month) AS max_month
                 FROM   #tact_op_flow_temp2_temp a             
                 GROUP BY eng_scm_site_id, flow_id, origin_division_id, plant_id, line_id, item_id 
                 HAVING count(*) = 1
                 ) a
             --, ( SELECT LEFT(@p_plan_name, 6) AS month
             --    UNION ALL SELECT  CONVERT(NVARCHAR(6), DATEADD(m, 1, CONVERT(DATETIME, LEFT(@p_plan_name, 6) + '01')), 112) AS month  ) b
        ;

        -----------------------------------------------------------
		-- 2-1)-3)  위 2-1)-1), 2-1)-2) UNION ALL 처리한 임시테이블 생성
        --          - "FP용에서 당월, 차월 누락된 월 tact time정보" 와  "FP용 tact_time 당월, 차월 tact time정보"       
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#tact_op_flow_temp2') IS NOT NULL
        DROP TABLE #tact_op_flow_temp2

        SELECT eng_scm_site_id, flow_id, origin_division_id, plant_id, line_id, item_id
            ,  month, tact_time
        INTO   #tact_op_flow_temp2
        FROM (
               -- 당월, 차월 누락된 월 생성
               SELECT eng_scm_site_id, flow_id, origin_division_id, plant_id, line_id, item_id
                   ,  month, tact_time
               FROM   #tact_op_flow_temp2_2 
               
               UNION ALL
               
               -- FP용 tact_time 당월, 차월 정보
               SELECT * FROM #tact_op_flow_temp2_temp 
             ) x
        ;

        -----------------------------------------------------------
		-- 2-1)-4)  th_eng_op_res_group_map_sn 정보를 이용해서 month 당월, 차월 데이터 생성
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#th_eng_op_res_group_map') IS NOT NULL
        DROP TABLE #th_eng_op_res_group_map

        SELECT res.site_id AS eng_scm_site_id
             , res.route_id 
             , res.origin_division_id 
             , res.plant_id
             , res.line_id
             , res.item_id 
             , b.month
        INTO   #th_eng_op_res_group_map
        FROM   
        (
               SELECT g.*
                    , s.plant_id, s.origin_division_id 
                    , SUBSTRING(g.resource_group_id, dbo.FN_CHARINDEX_REV(g.resource_group_id, '::', 0)+2, 100) AS line_id
                    
               FROM   th_eng_op_res_group_map_sn g WITH(NOLOCK)
                    
                    -- 20180702 수정
                    --, scm_mst_site_eng           s WITH(NOLOCK)
                    , ( SELECT b.division_id AS  origin_division_id
                             , a.company_id, a.eng_scm_site_id, a.plant_id 
                             , a.modeling_id, a.plan_id, a.plan_type, a.plan_seq    
                        FROM scm_mst_site_eng a WITH (NOLOCK) 
                             INNER JOIN ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                                        SELECT b.* , di.attribute3  AS division_group 
                                        FROM   scm_mst_site        b WITH (NOLOCK)
                                             , scm_mst_division   di WITH(NOLOCK)
                                        WHERE  di.division_id  =  b.division_id
                                        AND    di.valid_yn     = 'Y'
                                        AND    di.attribute4   = @v_division_comp  --회사코드
                                        ) b
                             ON  a.scm_site_id = b.scm_site_id  
                             AND a.division_id  = @p_division_id 
                             AND a.plan_id      = @p_plan_id
                             AND a.plan_type    = @p_plan_type 
                             AND a.plan_seq     = @p_seq
                             AND a.site_type    = 'PLANT'
                             AND b.valid_yn     = 'Y'
                             AND b.division_group  IN ( '40', '81', '82')  -- 2022.04.04 수정, 20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가) 

                         /* 20220404 변경전 
                        FROM scm_mst_site_eng a WITH (NOLOCK) 
                             INNER JOIN scm_mst_site b WITH (NOLOCK)
                             ON a.scm_site_id = b.scm_site_id  
                             AND a.division_id  = @p_division_id 
                             AND a.plan_id      = @p_plan_id
                             AND a.plan_type    = @p_plan_type 
                             AND a.plan_seq     = @p_seq
                             AND a.site_type    = 'PLANT'
                             AND b.valid_yn     = 'Y'
                             AND b.division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)*/ 
                      ) s                        
               WHERE  g.master_id   = @p_master_id
               AND    g.plan_id     = @p_engine_plan_id
               --AND    s.modeling_id = @p_modeling_id
               --AND    s.plan_id     = @p_plan_id
               --AND    s.plan_type   = @p_plan_type
               --AND    s.plan_seq    = @p_seq
               AND    g.site_id     = s.eng_scm_site_id
               -- Line Capa 적용 대상 공정
               AND    g.descr       = 'LINE_CAPA'
              
        ) res
        , ( SELECT LEFT(@p_plan_name, 6) AS month
            UNION ALL SELECT  CONVERT(NVARCHAR(6), DATEADD(m, 1, CONVERT(DATETIME, LEFT(@p_plan_name, 6) + '01')), 112) AS month  ) b

        -----------------------------------------------------------
		-- 2-1)-5)  th_eng_op_res_group_map_sn 에만 존재하는 tact time 정보 추가 INSERET
        --         - FP용 tact time정보에 존재하지 않는 tact time 정보를 위 2-1)-3)에서 생성한 #tact_op_flow_temp2 테이블에 추가 INSERT
        -----------------------------------------------------------
        INSERT INTO #tact_op_flow_temp2
        (
           eng_scm_site_id 
        ,  flow_id
        ,  origin_division_id
        ,  plant_id
        ,  line_id
        ,  item_id
        ,  month
        ,  tact_time 
        )
        SELECT a.eng_scm_site_id, a.route_id, a.origin_division_id, a.plant_id, a.line_id, a.item_id
            ,  a.month
            ,  0.0 AS tact_time 
         
        FROM  #th_eng_op_res_group_map a
              LEFT JOIN #tact_op_flow_temp2 b
              ON   a.eng_scm_site_id        = b.eng_scm_site_id 
              AND  a.route_id               = b.flow_id
              AND  a.origin_division_id     = b.origin_division_id
              AND  a.plant_id               = b.plant_id
              AND  a.line_id                = b.line_id 
              AND  a.item_id                = b.item_id 
        WHERE b.origin_division_id IS NULL
        ;

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 2-1 END';
        SET @v_description = N'2. Capa 공정 : 2-1 임시테이블 생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
		-- 2-2) 임시테이블 생성 ( scm_mst_yield_ver_h_v, scm_mst_operation_flow_v 조인테이블)
        -----------------------------------------------------------
        --  참고)  scm_mst_yield_ver_h_v의 'operation_id는 단일 공정의 값만 가지지만
        --         th_eng_op_res_group_map_sn의 route_id(=operation_id)값은 'A5000A6000'와 같이 여러공정값이 연결된값을 가지므로 
        --         scm_mst_yield_ver_h_v의 조인처리를 위해서 이작업이 필요함   
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#yield_op_flow_temp2') IS NOT NULL
        DROP TABLE #yield_op_flow_temp2

        SELECT CASE WHEN SUBSTRING(op.flow_id, 1, 1) = 'E' THEN t.plant_id + '-E~***'
                    WHEN SUBSTRING(op.flow_id, 1, 1) = 'S' THEN t.plant_id + '-E~***' -- SRS => 전극
                    WHEN SUBSTRING(op.flow_id, 1, 1) = 'A' THEN t.plant_id + '-A~***'
                    WHEN SUBSTRING(op.flow_id, 1, 1) = 'F' THEN t.plant_id + '-A~***' -- 활성화 => CELL
                    WHEN SUBSTRING(op.flow_id, 1, 1) = 'P' THEN t.plant_id + '-P~***'
               END  AS eng_scm_site_id
             , op.flow_id
             , t.division_id AS origin_division_id
             , t.plant_id
             , t.line_id
             , t.item_id
             , t.month    -- yield 존재 구간

              -- 수율 0또는 NULL은 1로 처리함
             , MIN(CASE WHEN t.yield <= 0 THEN 1
                        WHEN t.yield > 1 THEN 1
                        ELSE ISNULL(t.yield, 1)
                   END
                  ) AS yield -- 누적수율은 곱해야 하나 일단 MIN 값으로 처리함
        INTO #yield_op_flow_temp2  
        
        FROM  (  -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group(attribute3) )
                SELECT t.* , di.attribute3 AS division_group , di.attribute4 AS division_comp 
                FROM   dbo.scm_mst_yield_ver_h_v t  WITH (NOLOCK)    -- PJ20209642 변경  scm_mst_yield_sn
                     , scm_mst_division  di WITH(NOLOCK)
                WHERE  di.division_id    =  t.division_id
                AND    di.valid_yn       = 'Y'
                AND    di.attribute4     = @v_division_comp   -- 2022.04.04 회사코드 조건추가                                         
              ) t
            , ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group(attribute3) )
                select op.* , di.attribute3 AS division_group , di.attribute4 AS division_comp 
                from   dbo.scm_mst_operation_flow_v op WITH(NOLOCK)
                     , scm_mst_division  di WITH(NOLOCK)
                WHERE  di.division_id    =  op.division_id
                AND    di.valid_yn       = 'Y'
                AND    di.attribute4     = @v_division_comp  -- 2022.04.04 회사코드 조건추가  
              ) op 
        WHERE  t.division_id  = op.division_id
        AND    t.company_id   = op.company_id
        AND    t.site_id      = op.site_id
        AND    t.operation_id = op.operation_id
        AND    t.month        >= SUBSTRING(@p_plan_name, 1, 6)
        AND    t.month        <  CONVERT(NVARCHAR(6), DATEADD(m, 2, CONVERT(DATETIME,LEFT(@p_plan_name, 6) + '01')), 112) -- 20180425 추가 (당월, 차월 까지만 조회되게하기위해서)
        AND    t.division_group  IN ( '40', '81', '82')  --2022.04.04컬럼변경. 20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)   
        AND   op.division_group  IN ( '40', '81', '82')  --2022.04.04컬럼변경. 20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가) 
        /* 20220404 변경전 
        FROM   dbo.scm_mst_yield_ver_h_v t WITH (NOLOCK)    -- PJ20209642 변경  scm_mst_yield_sn
             , dbo.scm_mst_operation_flow_v op WITH(NOLOCK)
        WHERE  t.division_id  = op.division_id
        AND    t.company_id   = op.company_id
        AND    t.site_id      = op.site_id
        AND    t.operation_id = op.operation_id
        AND    t.month        >= SUBSTRING(@p_plan_name, 1, 6)
        AND    t.month        <  CONVERT(NVARCHAR(6), DATEADD(m, 2, CONVERT(DATETIME,LEFT(@p_plan_name, 6) + '01')), 112) -- 20180425 추가 (당월, 차월 까지만 조회되게하기위해서)
        --AND    t.division_id  = @p_division_id --'81'  -- 20180702 주석처리
        AND    t.division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가) 
        AND    op.division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)  
        */ 
        GROUP BY op.flow_id, t.division_id, t.plant_id, t.line_id, t.item_id, t.month
		;
        
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 2-2';
        SET @v_description = N'2-2. yield_op_flow_temp2 생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
		-----------------------------------------------------------
		-- 임시테이블 생성
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#TH_ENG_OP_RES_GROUP_MAP_CAL') IS NOT NULL
        BEGIN 
            DROP TABLE  #TH_ENG_OP_RES_GROUP_MAP_CAL          
        END

        CREATE TABLE #TH_ENG_OP_RES_GROUP_MAP_CAL(
	        MASTER_ID nvarchar(50) NOT NULL,
	        PLAN_ID nvarchar(50) NOT NULL,
	        SITE_ID nvarchar(50) NOT NULL,
	        ROUTE_ID nvarchar(50) NOT NULL,
	        OPERATION_ID nvarchar(50) NOT NULL,
	        ITEM_ID nvarchar(50) NOT NULL,
	        RESOURCE_MAP_ID nvarchar(80) NOT NULL,
	        RESOURCE_GROUP_ID nvarchar(80) NOT NULL,
	        START_DTTM datetime NOT NULL,
	        END_DTTM datetime NOT NULL,
	        SUB_RESOURCE_MAP_ID nvarchar(150) NULL,
	        RESOURCE_MAP_LEVEL numeric(20, 10) NULL DEFAULT ((1)),
	        ALT_PRIORITY numeric(20, 10) NULL,
	        TACT_TIME numeric(20, 10) NOT NULL,
	        TACT_TIME_UOM nvarchar(10) NULL DEFAULT ('SECOND'),
	        YIELD numeric(20, 10) NULL DEFAULT ((1)),
	        GOOD_RATE numeric(20, 10) NULL,
	        BATCH_RATE numeric(20, 10) NULL,
	        IS_USE nvarchar(1) NULL DEFAULT ('Y'),
	        DESCR nvarchar(2000) NULL,
	        CONSUME_RES_RATE numeric(20, 10) NULL,
	        PREPARE_TIME numeric(20, 10) NULL DEFAULT ((0)),
	        PREPARE_TIME_UOM nvarchar(10) NULL DEFAULT ('HOUR')

            , SCP_TACT_TIME_USE_YN nvarchar(10) NULL  --기존테이블에 없는 컬럼(scp_mst_tact_time 사용여부)
            , LINE_ID nvarchar(10) NULL
	        , PLANT_SITE_ID nvarchar(50)  NULL
        )
        ;

        -----------------------------------------------------------
        --2-3-1 LINECAPA 대상 임시테이블에 INSERT
        -----------------------------------------------------------
        --INSERT INTO /* PR_SCP_ENG_EE_PRE_PROC_OP_RES_GROUP_MAP_CAL */ th_eng_op_res_group_map_cal_sn
        INSERT INTO /* PR_SCP_ENG_EE_PRE_PROC_OP_RES_GROUP_MAP_CAL */ #TH_ENG_OP_RES_GROUP_MAP_CAL
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
             --, ISNULL(tat.end_dttm, DATEADD(DD, 52*7 ,(CONVERT(DATETIME, @p_plan_name))))
             , ISNULL(tat.end_dttm, CONVERT(DATETIME, @v_add_pet_date)) AS end_dttm  -- (2022.01.26) @v_pet_date ->  @v_add_pet_date 으로 변경
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
             , 'Y' AS is_use -- 뒤에서 추가 Update 처리함
             , res.descr
			 , res.consume_res_rate
			 , res.prepare_time
			 , res.prepare_time_uom

             -- scp tact_time 사용여부
             , ISNULL(CASE WHEN tat.start_dttm <  DATEADD(m, 2, CONVERT(DATETIME,LEFT(@p_plan_name, 6) + '01'))  
                                THEN IIF(tat.tact_time IS NULL AND smtt.tact_time IS NOT NULL, 'Y', 'N')                                          
                           ELSE IIF(smtt.tact_time IS NOT NULL, 'Y', 'N')
                      END, 'N')
               AS scp_tact_time_use_yn  --기존테이블에 없는 컬럼1
             , res.line_id              --기존테이블에 없는 컬럼2
			 , res.scm_site_id AS plant_site_id
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
               AND    g.descr       = 'LINE_CAPA'
              ) res
              LEFT OUTER JOIN 
                 (SELECT t.origin_division_id
                       , t.plant_id
                       , t.flow_id --
                       , t.line_id
                       , t.item_id
                       , t.month    -- Tact Time 존재 구간
                       , buc.start_dttm
                       , buc.end_dttm
                       
                       , t.tact_time
                       , t.eng_scm_site_id 
                  FROM  #tact_op_flow_temp2 t WITH(NOLOCK)
                  
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
				      --, (SELECT b.master_id
          --                    , b.plan_id
          --                    , CONVERT(CHAR(6), b.start_dttm, 112) AS month
          --                    , MIN(b.start_dttm) AS start_dttm
          --                    , MAX(b.end_dttm)   AS end_dttm
          --               FROM   th_eng_bucket_info_sn b WITH(NOLOCK)
          --               WHERE  b.master_id   = @p_master_id
          --               AND    b.plan_id     = @p_engine_plan_id
          --               -- 20190722 : 13주 추가 구간까지 CAL 생성
          --               --AND    b.descr       = 'PLAN'  -- 20180620 추가 (  plan시작일~ plan종료일 : descr = 'PLAN' , plan종료일이후~ 13주 : descr = 'ADD')
          --               GROUP BY b.master_id, b.plan_id, CONVERT(CHAR(6), b.start_dttm, 112)
          --             ) buc
                  WHERE  t.month      >= SUBSTRING(@p_plan_name, 1, 6)
                  AND    t.month       < CONVERT(NVARCHAR(6), DATEADD(m, 2, CONVERT(DATETIME,LEFT(@p_plan_name, 6) + '01')), 112) -- 20180425 추가 (당월, 차월 까지만 조회되게하기위해서)  
                  AND    t.month       = buc.month
                  --AND    t.origin_division_id = @p_division_id  -- 20180702 주석처리
                  
				 
                  --/*
                  -- 차월이후 부터는 SCP용 Tact Time 정보를 사용하기 위해서  tact_time 값을 NULL 처리함 ( 위 INSERT부분에서 SCP용 tact time값을 적용함, 차월이후는 bucket_info 월 기준으로 생성됨)
                  UNION
                  SELECT t.origin_division_id
                       , t.plant_id
                       , t.flow_id --
                       , t.line_id
                       , t.item_id
                       , buc.month    -- Tact Time 미존재 미래 구간
                       , buc.start_dttm
                       , buc.end_dttm
                       
                       , NULL AS tact_time  --20180425 수정 ( 차월이후는 scp의 tact_time(scp_mst_tact_time.tact_time) 정보 사용하면되므로 null 처리함) (변경전 : , t.tact_time)
                       , t.eng_scm_site_id --
                  FROM   #tact_op_flow_temp2 t WITH(NOLOCK)
				      , (SELECT t.origin_division_id
                              , t.plant_id
                              , t.flow_id --
                              , t.line_id
                              , t.item_id
                              , MAX(t.month) AS month
                         FROM   #tact_op_flow_temp2 t WITH(NOLOCK)
                         WHERE  t.month      >= SUBSTRING(@p_plan_name, 1, 6)
                         --AND    t.origin_division_id = @p_division_id  -- 20180702 주석처리
                         
                         GROUP BY t.origin_division_id, t.plant_id, t.flow_id, t.line_id, t.item_id
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
				      --, (SELECT b.master_id
          --                    , b.plan_id
          --                    , CONVERT(CHAR(6), b.start_dttm, 112) AS month
          --                    , MIN(b.start_dttm) AS start_dttm
          --                    , MAX(b.end_dttm)   AS end_dttm
          --               FROM   th_eng_bucket_info_sn b WITH(NOLOCK)
          --               WHERE  b.master_id   = @p_master_id
          --               AND    b.plan_id     = @p_engine_plan_id
          --               -- 20190722 : 13주 추가 구간까지 CAL 생성
          --               --AND    b.descr       = 'PLAN'  -- 20180620 추가 (  plan시작일~ plan종료일 : descr = 'PLAN' , plan종료일이후~ 13주 : descr = 'ADD')
          --               GROUP BY b.master_id, b.plan_id, CONVERT(CHAR(6), b.start_dttm, 112)
          --             ) buc
                  WHERE  t.origin_division_id  = tm.origin_division_id
                  AND    t.plant_id     = tm.plant_id
                  AND    t.flow_id      = tm.flow_id
                  AND    t.line_id      = tm.line_id
                  AND    t.item_id      = tm.item_id
                  AND    t.month        = tm.month
                  AND    buc.month      > t.month
                  --AND    t.origin_division_id  = @p_division_id  -- 20180702 수정
                  --*/
                 ) tat
               --ON    res.plant_id     = tat.plant_id
               ON  res.site_id      = tat.eng_scm_site_id
               AND res.route_id     = tat.flow_id
               AND res.line_id      = tat.line_id
               AND res.item_id      = tat.item_id
               
               --20180313 YIELD 처리 추가
               LEFT OUTER JOIN 
                 (SELECT t.origin_division_id
                       , t.plant_id
                       , t.flow_id --
                       , t.line_id
                       , t.item_id
                       , t.month    -- yield 존재 구간
                       , buc.start_dttm
                       , buc.end_dttm
                       
                       , t.yield AS yield 
                       , t.eng_scm_site_id -- 
                        
                  FROM   #yield_op_flow_temp2 t WITH(NOLOCK)
                  
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
				      --, (SELECT b.master_id
          --                    , b.plan_id
          --                    , CONVERT(CHAR(6), b.start_dttm, 112) AS month
          --                    , MIN(b.start_dttm) AS start_dttm
          --                    , MAX(b.end_dttm)   AS end_dttm
          --               FROM   th_eng_bucket_info_sn b WITH(NOLOCK)
          --               WHERE  b.master_id   = @p_master_id
          --               AND    b.plan_id     = @p_engine_plan_id
          --               -- 20190722 : 13주 추가 구간까지 CAL 생성
          --               --AND    b.descr       = 'PLAN'  -- 20180620 추가 (  plan시작일~ plan종료일 : descr = 'PLAN' , plan종료일이후~ 13주 : descr = 'ADD')
          --               GROUP BY b.master_id, b.plan_id, CONVERT(CHAR(6), b.start_dttm, 112)
          --             ) buc
                  WHERE t.month      >= SUBSTRING(@p_plan_name, 1, 6)
                  AND    t.month       < CONVERT(NVARCHAR(6), DATEADD(m, 2, CONVERT(DATETIME,LEFT(@p_plan_name, 6) + '01')), 112) -- 20180425 추가 (당월, 차월 까지만 조회되게하기위해서)
                  AND    t.month       = buc.month
                  --AND    t.origin_division_id = @p_division_id  -- 20180702 주석처리

                  --/*
                  -- 차월이후 부터는 SCP용 yield 정보를 사용하기 위해서  yield 값을 NULL 처리함 ( 위 INSERT부분에서 SCP용 yield 값을 적용함, 차월이후는 bucket_info 월 기준으로 생성됨)
                  UNION
                  SELECT t.origin_division_id
                       , t.plant_id
                       , t.flow_id 
                       , t.line_id
                       , t.item_id
                       , buc.month    -- yiled 미존재 미래 구간
                       , buc.start_dttm
                       , buc.end_dttm
                       
                       , NULL AS yield       --20180425 수정 ( 차월이후는 scp의 yield(scp_mst_tact_time.yield) 정보 사용하면되므로 null 처리함) (변경전 : , t.yield AS yield )
                       , t.eng_scm_site_id --
                  FROM  #yield_op_flow_temp2 t WITH(NOLOCK)
				      , (SELECT t.origin_division_id
                              , t.plant_id
                              , t.flow_id--
                              , t.line_id
                              , t.item_id
                              , MAX(t.month) AS month
                         FROM   #yield_op_flow_temp2 t WITH(NOLOCK)
                         WHERE  t.month      >= SUBSTRING(@p_plan_name, 1, 6)
                         --AND    t.origin_division_id = @p_division_id  -- 20180702 주석처리
                         
                         GROUP BY t.origin_division_id, t.plant_id, t.flow_id, t.line_id, t.item_id
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
				      --, (SELECT b.master_id
          --                    , b.plan_id
          --                    , CONVERT(CHAR(6), b.start_dttm, 112) AS month
          --                    , MIN(b.start_dttm) AS start_dttm
          --                    , MAX(b.end_dttm)   AS end_dttm
          --               FROM   th_eng_bucket_info_sn b WITH(NOLOCK)
          --               WHERE  b.master_id   = @p_master_id
          --               AND    b.plan_id     = @p_engine_plan_id
          --               -- 20190722 : 13주 추가 구간까지 CAL 생성
          --               --AND    b.descr       = 'PLAN'  -- 20180620 추가 (  plan시작일~ plan종료일 : descr = 'PLAN' , plan종료일이후~ 13주 : descr = 'ADD')
          --               GROUP BY b.master_id, b.plan_id, CONVERT(CHAR(6), b.start_dttm, 112)
          --             ) buc
                  WHERE  t.origin_division_id  = tm.origin_division_id
                  AND    t.plant_id     = tm.plant_id
                  AND    t.flow_id      = tm.flow_id
                  AND    t.line_id      = tm.line_id
                  AND    t.item_id      = tm.item_id
                  AND    t.month        = tm.month
                  AND    buc.month      > t.month
                  --AND    t.origin_division_id  = @p_division_id  -- 20180702 주석처리
                  
                  --*/
                 ) yld
               ON  res.site_id      = yld.eng_scm_site_id 
               AND res.route_id     = yld.flow_id
               AND res.line_id      = yld.line_id
               AND res.item_id      = yld.item_id

               AND tat.start_dttm   = yld.start_dttm 
               AND tat.end_dttm     = yld.end_dttm 

              --20180405 추가 SCP 관리 tact_time, yield 정보
              LEFT JOIN ( SELECT division_id,  plant_site_id + '~***' AS eng_scm_site_id, item_id, operation_id, line_id 
                             ,   tact_time
                             -- 수율 0 또는 NULL은 1로 처리함                                 
                             ,   CASE WHEN yield <= 0 THEN 1
                                      WHEN yield > 1 THEN 1
                                      ELSE ISNULL(yield, 1)
                                     END  AS yield      
                          FROM #scp_mst_tact_time WITH (NOLOCK) --20180917 수정 (변경전 : FROM scp_mst_tact_time WITH (NOLOCK) )
                          WHERE valid_yn    = 'Y'  
                          --AND   division_id = @p_division_id  -- 20180702 주석처리
                                                   
                        ) smtt
              ON  res.site_id  = smtt.eng_scm_site_id
              AND res.item_id  = smtt.item_id 
              AND res.line_id  = smtt.line_id 
              AND res.route_id LIKE  smtt.operation_id + '%'

        WHERE  res.resource_map_level = 1
		;
		
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 2-3-1';
        SET @v_description = N'2-3-1. LINECAPA 대상 데이터생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        ---------------------------------------------------------------
        -- 2-3)-2 line assign IN (0, 9) 일때 is_use = 'N' 처리
        ---------------------------------------------------------------
        IF OBJECT_ID('tempdb..#TH_ENG_OP_RES_GROUP_MAP_CAL2') IS NOT NULL
        BEGIN 
            DROP TABLE  #TH_ENG_OP_RES_GROUP_MAP_CAL2          
        END

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
        INTO   #TH_ENG_OP_RES_GROUP_MAP_CAL2
        FROM   
                ( SELECT DISTINCT 
                      la.company_id, la.division_id, la.site_id
                    , la.plant_id, la.factory_id, la.item_id
                    , la.operation_id, la.line_id
                    , la.month
                   -- , *
                FROM  ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                        SELECT la.* , di.attribute3 AS division_group , di.attribute4 AS division_comp 
                        FROM   dbo.scm_mst_item_line_assign_sn la WITH(NOLOCK) 
                             , scm_mst_division                di WITH(NOLOCK) 
                        WHERE  di.division_id  =  la.division_id
                        AND    di.valid_yn     = 'Y'
                        AND    di.attribute4   = @v_division_comp --회사코드
                        ) la
                WHERE  la.active_flag      = 'Y'
                AND    la.month           >= SUBSTRING(@p_plan_name, 1, 6)                 
                AND    la.priority        IN (0, 9) -- 사용 안할때 0, 9로 세팅되어있음  
                AND    la.division_group  IN ( '40', '81', '82')  --2022.04.04컬럼변경. 20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)
                
                /* 20220404 변경전 
                FROM   dbo.scm_mst_item_line_assign_sn la WITH(NOLOCK) --[LGCE_FPDEV_TR].[DBO].[SCM_ITEM_LINE_ASSIGN_M]
                WHERE  la.active_flag = 'Y'
                AND    la.month    >= SUBSTRING(@p_plan_name, 1, 6) --SUBSTRING('201806', 1, 6)
                -- 20210727 PJ20209643 : 'N' 처리 구간 변경 => 2개월 => 전 구간
                --AND    la.month    <  CONVERT(NVARCHAR(6), DATEADD(m, 2, CONVERT(DATETIME, SUBSTRING(@p_plan_name, 1, 6) + '01')), 112) --CONVERT(NVARCHAR(6), DATEADD(m, 2, CONVERT(DATETIME, SUBSTRING('20180604', 1, 6) + '01')), 112)
                AND    la.priority IN (0, 9) -- 사용 안할때 0, 9로 세팅되어있음  
                --AND    la.division_id = @p_division_id  -- 20180702 주석처리
                AND    la.division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)
                */ 
                ) a
                --LEFT JOIN  (
                INNER JOIN  (
                            SELECT aa.*
                                    , bb.origin_division_id, bb.company_id, bb.site_id AS site_id_org, bb.plant_id   
                            FROM   ( SELECT *
                                          --, dbo.fn_scm_split(resource_group_id, 3, '::') AS line_id  
                                        FROM   #TH_ENG_OP_RES_GROUP_MAP_CAL
                                        WHERE  descr = 'LINE_CAPA'                                        
                                     ) aa
                                    
                                    -- 20180702 수정
                                    --INNER JOIN scm_mst_site_eng bb WITH (NOLOCK) -- modeling_id, plan_id, plan_type, plan_seq, division_id, scm_site_id, eng_scm_site_id
                                    --ON   aa.site_id      = bb.eng_scm_site_id 
                                    --AND  bb.modeling_id = @p_modeling_id 
                                    --AND  bb.plan_id     = @p_plan_id
                                    --AND  bb.plan_type   = @p_plan_type 
                                    --AND  bb.plan_seq    = @p_seq
                                    --AND  bb.division_id = @p_division_id    
                                    INNER JOIN ( SELECT b.division_id AS  origin_division_id
                                                      , a.company_id, a.eng_scm_site_id, a.plant_id, a.site_id  
                                                      , a.modeling_id, a.plan_id, a.plan_type, a.plan_seq    
                                                 FROM scm_mst_site_eng a WITH (NOLOCK) 
                                                 INNER JOIN (  -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                                                            SELECT A.*  , di.attribute3 AS division_group , di.attribute4 AS division_comp 
                                                            FROM   scm_mst_site      a WITH (NOLOCK)
                                                                 , scm_mst_division  di WITH(NOLOCK)
                                                            WHERE  di.division_id    =  a.division_id
                                                            AND    di.valid_yn       = 'Y' 
                                                            AND    di.attribute4     =  @v_division_comp   --회사코드
                                                            ) b 
                                                 ON a.scm_site_id   = b.scm_site_id  
                                                 AND a.division_id  = @p_division_id 
                                                 AND a.plan_id      = @p_plan_id
                                                 AND a.plan_type    = @p_plan_type 
                                                 AND a.plan_seq     = @p_seq
                                                 AND a.site_type    = 'PLANT'
                                                 AND b.valid_yn     = 'Y'
                                                 AND b.division_group  IN ( '40', '81', '82')  --2022.04.04 컬럼변경, 20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가) 
                                                 /* 20220404 변경전 
                                                 FROM scm_mst_site_eng a WITH (NOLOCK) 
                                                 INNER JOIN scm_mst_site b WITH (NOLOCK)
                                                 ON a.scm_site_id = b.scm_site_id  
                                                 AND a.division_id  = @p_division_id 
                                                 AND a.plan_id      = @p_plan_id
                                                 AND a.plan_type    = @p_plan_type 
                                                 AND a.plan_seq     = @p_seq
                                                 AND a.site_type    = 'PLANT'
                                                 AND b.valid_yn     = 'Y'
                                                 AND b.division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가) */
                                               ) bb 
                                    ON  aa.site_id      = bb.eng_scm_site_id                       
                        ) b
                ON   a.company_id   = b.company_id
                AND  a.division_id  = b.origin_division_id
                AND  a.site_id      = b.site_id_org
                AND  a.plant_id     = b.plant_id
                --AND  a.factory_id   = b.factory_id
                AND   b.operation_id LIKE a.operation_id + '%' --20180904 수정 (변경전 : AND  a.operation_id = b.operation_id )

                AND  a.line_id      = b.line_id
                AND  a.item_id      = b.item_id

                AND  a.month        >= CONVERT(NVARCHAR(6), b.start_dttm, 112)
                AND  a.month        < CONVERT(NVARCHAR(6), b.end_dttm, 112)
         --WHERE b.master_id IS NOT NULL   
        ; 

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 2-3-2';
        SET @v_description = N'2-3-2. LINECAPA 대상중 LINE ASSIGN IN (0, 9) 데이터생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        ---------------------------------------------------------------
        --2-4)  분할대상 생성       
        ---------------------------------------------------------------
        
        /*(주석시작) 20190405 scp_mst_tact_time_except (날짜 겹치게 입력되어있을경우) 날짜겹칩 방지처리
           참고) UI화면 입력단에서 날짜 겹침 체크를 하면 2-4-0)처리는 하지 않아도 됨

           -- 차후 날짜겹칩처리 사용시 2-4-0) 주석해제후  2-4-1)의 
              "INNER JOIN scp_mst_tact_time_except b WITH (NOLOCK)" => "INNER JOIN #scp_mst_tact_time_except b " 로 변경후 사용하면됨

        -----------------------------------------------------------
        --2-4)-0) scp_mst_tact_time_except 테이블 대상건 임시테이블로 생성
        -----------------------------------------------------------
           -- tact_time_start_date ~ tact_time_end_date 일자 겹침 방지 처리를 위해서(UI화면 입력단에서 날짜 겹침 체크를 하면 프로시저에서는 하지 않아도 됨)
                  
           --경우1) 일자겹치면서 is_use  값이 같을때 : MIN(tact_time_start_date) ~ MAX(tact_time_end_date) 로 처리함, MAX(tact_time), MAX(yield)값 사용함
           --경우2) 일자겹치면서 is_use  값이 다를때 : is_use = 'Y'건 처리한 후 is_use = 'N'건을 적용 처리함
        
            -----------------------------------------------------------
            --2-4-0-1) scp_mst_tact_time_except 테이블 대상데이터 임시테이블로 생성 
            -----------------------------------------------------------
            IF OBJECT_ID('tempdb..#scp_mst_tact_time_except_org') IS NOT NULL
            BEGIN 
                DROP TABLE #scp_mst_tact_time_except_org
            END      
            SELECT aa.division_id, aa.plant_site_id, aa.item_id, aa.operation_id, aa.line_id
                 , aa.tact_time_start_date, aa.tact_time_end_date
                 , aa.tact_time, aa.yield, aa.use_yn
            INTO   #scp_mst_tact_time_except_org
            FROM   scp_mst_tact_time_except aa WITH(NOLOCK)
            WHERE  tact_time_end_date >= @p_plan_name
            --AND    division_id = @p_division_id      --주석처리함
        
            -----------------------------------------------------------
            --2-4-0-2) 날짜겹칩 대상 조회(LEFT JOIN시 b 테이블 결과값이 NULL아니면 날짜겹치는건 존재, NULL이면 날짜겹치는건 없는건임)       
            -----------------------------------------------------------
            IF OBJECT_ID('tempdb..#temp_1') IS NOT NULL
            BEGIN 
                DROP TABLE #temp_1
            END        
            SELECT a.division_id, a.plant_site_id, a.item_id, a.operation_id, a.line_id
                 , a.tact_time_start_date, a.tact_time_end_date
                 , a.tact_time, a.yield, a.use_yn
                      
                 , b.division_id AS division_id2, b.plant_site_id AS plant_site_id2, b.item_id AS item_id2, b.operation_id AS operation_id2, b.line_id AS line_id2
                 , b.tact_time_start_date AS tact_time_start_date2, b.tact_time_end_date AS tact_time_end_date2
                 , b.tact_time AS tact_time2, b.yield AS yield2, b.use_yn AS use_yn2
            INTO   #temp_1
            FROM   #scp_mst_tact_time_except_org a
                   LEFT JOIN #scp_mst_tact_time_except_org b
                   ON   a.division_id   = b.division_id
                   AND  a.plant_site_id = b.plant_site_id
                   AND  a.item_id       = b.item_id
                   AND  a.operation_id  = b.operation_id
                   AND  a.line_id       = b.line_id
                   AND  a.use_yn        = b.use_yn
                   AND  (    
                         --경우1) 시작일자 <= 비교대상건시작일자, 종료일자>= 비교대상건종료일자                
                         ( a.tact_time_start_date <= b.tact_time_start_date AND a.tact_time_end_date >= b.tact_time_start_date)
                         OR
                         --경우2) 시작일자 <= 비교대상건종료일자, 종료일자>= 비교대상건종료일자
                         ( a.tact_time_start_date <= b.tact_time_end_date AND a.tact_time_end_date >= b.tact_time_end_date)
                         OR
                         --경우3) 시작일자 >= 비교대상건시작일자, 종료일자 <= 비교대상건종료일자
                         ( a.tact_time_start_date >= b.tact_time_start_date AND a.tact_time_end_date <= b.tact_time_end_date)
                        )    
            ;
            
            -----------------------------------------------------------
            --2-4-0-3) 일자겹칠경우 MIN(tact_time_start_date), MAX(tact_time_end_date) 값 적용(날짜겹치지 않는건도 존재함)                     
            -----------------------------------------------------------
            IF OBJECT_ID('tempdb..#temp_2') IS NOT NULL
            BEGIN 
                DROP TABLE #temp_2
            END            
            SELECT division_id, plant_site_id, item_id, operation_id, line_id, tact_time_start_date, tact_time_end_date, use_yn
                 , MIN(tact_time_start_date2) AS min_tact_time_start_date, MAX(tact_time_end_date2) AS max_tact_time_end_date
                 , MAX(tact_time) as max_tact_time, MAX(yield) AS max_yield                 
            INTO   #temp_2
            FROM   #temp_1
            GROUP BY use_yn, division_id, plant_site_id, item_id, operation_id, line_id, tact_time_start_date, tact_time_end_date
           
           -----------------------------------------------------------
            --2-4-0-4)-1) 날짜겹침처리
             /*
             #temp_2는 아래처럼 날짜가 구성되었을경우 1),2)와 2),3)이 다르게   MIN(start_date), MAX(end_date) 값이 되므로
             1),2),3)의 같은 MIN(start_date), MAX(end_date)값을 가지기 위한 처리
             ex) 1) '20190301~20190302'
                 2) '20190302~20190305'
                 3) '20190305~20190309' 일경우 
                 ==> MIN(start_date) : 20190301, MAX(end_date) : 20190309값이 되어야 하므로
            */
            -----------------------------------------------------------
            IF OBJECT_ID('tempdb..#temp_3_1') IS NOT NULL
            BEGIN 
                DROP TABLE #temp_3_1
            END
            SELECT division_id, plant_site_id, item_id, operation_id, line_id, use_yn 
                ,  min_start_date
                ,  max_end_date
                ,  max_tact_time, max_yield 
                ,  IIF(DATEDIFF(dd, CONVERT(DATETIME,pre_max_end_date), CONVERT(DATETIME, min_start_date)) < 1, 1, NULL) AS diff_preenddate_startdate
                ,  ROW_NUMBER() OVER (PARTITION BY division_id, plant_site_id, item_id, operation_id, line_id, use_yn ORDER BY min_start_date, max_end_date) AS row_num
                
            INTO   #temp_3_1
            FROM   (
                    SELECT  division_id, plant_site_id, item_id, operation_id, line_id, use_yn 
                            --, tact_time_start_date
                            --, tact_time_end_date
                            , min_tact_time_start_date AS min_start_date
                            , max_tact_time_end_date   AS max_end_date
                            
                            --, MAX(max_tact_time) AS max_tact_time, MAX(max_yield) AS max_yield
                            , max_tact_time, max_yield
                            
                            , LAG(max_tact_time_end_date, 1) OVER (PARTITION BY division_id, plant_site_id, item_id, operation_id, line_id, use_yn ORDER BY min_tact_time_start_date, max_tact_time_end_date) AS pre_max_end_date
                    FROM   #temp_2
                    --GROUP BY division_id, plant_site_id, item_id, operation_id, line_id, use_yn
                    --        ,  min_tact_time_start_date, max_tact_time_end_date
                   ) x
            ;

                
            -----------------------------------------------------------
            --2-4-0-4)-2) 그룹핑 컬럼생성(max_group_gubun컬럼)
            -----------------------------------------------------------
            IF OBJECT_ID('tempdb..#temp_3_2') IS NOT NULL
            BEGIN 
                DROP TABLE #temp_3_2
            END
            SELECT  division_id, plant_site_id, item_id, operation_id, line_id, use_yn 
                 ,  min_start_date
                 ,  max_end_date
                 ,  max_tact_time, max_yield 
                 ,  MAX(ISNULL(diff_preenddate_startdate, row_num*10)) OVER (ORDER BY row_num) AS max_group_gubun                  
            INTO   #temp_3_2
            FROM   #temp_3_1
            ;

            -----------------------------------------------------------
            --2-4-0-4)-3) 그룹핑 최종
            -----------------------------------------------------------
            IF OBJECT_ID('tempdb..#temp_3_3') IS NOT NULL
            BEGIN 
                DROP TABLE #temp_3
            END
            SELECT  division_id, plant_site_id, item_id, operation_id, line_id, use_yn
                    -- , max_group_gubun
                    , MIN(min_start_date) AS min_tact_time_start_date
                    , MAX(max_end_date)   AS max_tact_time_end_date      
                    , MAX(max_tact_time)  AS max_tact_time
                    , MAX(max_yield)      AS max_yield              
            INTO   #temp_3
            FROM   #temp_3_2
            GROUP BY division_id, plant_site_id, item_id, operation_id, line_id, use_yn, max_group_gubun
            ;            

           -----------------------------------------------------------
            --2-4-0-5) is_use = 'Y'건만 조회(날짜겹치는 건들은 MIN(tact_time_start_date), MAX(tact_time_end_date) 값사용)                     
            -----------------------------------------------------------
            IF OBJECT_ID('tempdb..#temp_use_yn_y') IS NOT NULL
            BEGIN 
                DROP TABLE #temp_use_yn_y
            END
            
            SELECT division_id, plant_site_id, item_id, operation_id, line_id
                 , min_tact_time_start_date, max_tact_time_end_date
                 , use_yn
                 , max_tact_time AS tact_time, max_yield AS yield                 
            INTO   #temp_use_yn_y
            FROM   #temp_3
            WHERE  use_yn = 'Y'
            GROUP BY division_id, plant_site_id, item_id, operation_id, line_id
                   , min_tact_time_start_date, max_tact_time_end_date
                   , use_yn
                   , max_tact_time, max_yield
                   
            
            -----------------------------------------------------------
            --2-4-0-6) is_use = 'N'건만 조회(날짜겹치는 건들은 MIN(tact_time_start_date), MAX(tact_time_end_date) 값사용)
            -----------------------------------------------------------
            IF OBJECT_ID('tempdb..#temp_use_yn_n') IS NOT NULL
            BEGIN 
                DROP TABLE #temp_use_yn_n
            END
            
            SELECT division_id, plant_site_id, item_id, operation_id, line_id
                 , min_tact_time_start_date, max_tact_time_end_date
                 , use_yn
                 , max_tact_time AS tact_time, max_yield AS yield
            INTO   #temp_use_yn_n
            FROM   #temp_3
            WHERE  use_yn = 'N'
            GROUP BY division_id, plant_site_id, item_id, operation_id, line_id
                   , min_tact_time_start_date, max_tact_time_end_date
                   , use_yn
                   , max_tact_time, max_yield
            ;  

            -----------------------------------------------------------
            --2-4-0-7) is_use='Y'건 대상 is_use='N'건과 날짜겹치는건 조회(is_use='Y'는 is_use='N'과 날짜겹치지 않는건도 조회됨)
            -----------------------------------------------------------
            IF OBJECT_ID('tempdb..#scp_mst_tact_time_except_final') IS NOT NULL
            BEGIN 
                DROP TABLE #scp_mst_tact_time_except_final
            END
            
            SELECT a.division_id, a.plant_site_id, a.item_id, a.operation_id, a.line_id, a.min_tact_time_start_date, a.max_tact_time_end_date, a.use_yn, a.tact_time, a.yield 
                 , b.division_id AS division_id2, b.plant_site_id AS plant_site_id2, b.item_id AS item_id2, b.operation_id AS operation_id2, b.line_id AS line_id2, b.min_tact_time_start_date AS min_tact_time_start_date2, b.max_tact_time_end_date AS max_tact_time_end_date2, b.use_yn AS use_yn2, b.tact_time AS tact_time2, b.yield AS yield2
            INTO   #scp_mst_tact_time_except_final
            FROM   #temp_use_yn_y a
                   LEFT JOIN #temp_use_yn_n b
            ON   a.division_id   = b.division_id
            AND  a.plant_site_id = b.plant_site_id
            AND  a.item_id       = b.item_id
            AND  a.operation_id  = b.operation_id
            AND  a.line_id       = b.line_id
            AND  (
                    ( a.min_tact_time_start_date <= b.min_tact_time_start_date AND a.max_tact_time_end_date >= b.min_tact_time_start_date)
                    OR
                    ( a.min_tact_time_start_date <= b.max_tact_time_end_date AND a.max_tact_time_end_date >= b.max_tact_time_end_date)
                    OR
                    ( a.min_tact_time_start_date >= b.min_tact_time_start_date AND a.max_tact_time_end_date <= b.max_tact_time_end_date)
                 ) 
            ;
            
            -----------------------------------------------------------
            --2-4-0-8) is_use = 'Y'건 대상 is_use ='N'건 적용(is_use='Y'건과 is_use='N' 날짜겹칠때는 날짜 분리처리함)
            -----------------------------------------------------------
            IF OBJECT_ID('tempdb..#scp_mst_tact_time_except_final_use_yn') IS NOT NULL
            BEGIN 
                DROP TABLE #scp_mst_tact_time_except_final_use_yn
            END
            
            SELECT    DISTINCT
                      x.division_id
                    , x.plant_site_id
                    , x.item_id
                    , x.operation_id
                    , x.line_id
                    
                    , ISNULL(x.tact_time_start_date, x.min_tact_time_start_date) AS tact_time_start_date
                    , ISNULL(x.tact_time_end_date, x.max_tact_time_end_date) AS  tact_time_end_date
                       
                    , ISNULL(x.use_yn, x.use_yn_org) AS use_yn 

                    , ISNULL(x.tact_time, x.tact_time_org) AS tact_time
                    , ISNULL(x.yield, x.yield_org) AS yield

            INTO   #scp_mst_tact_time_except_final_use_yn
            FROM   (
                    SELECT  a.division_id
                          , a.plant_site_id
                          , a.item_id
                          , a.operation_id
                          , a.line_id
                          , a.min_tact_time_start_date 
                          , a.max_tact_time_end_date   
                          , a.use_yn AS use_yn_org
                          , a.tact_time AS tact_time_org
                          , a.yield     AS yield_org
                          , CASE WHEN b.gubun = 1 AND a.min_tact_time_start_date < a.min_tact_time_start_date2  THEN a.min_tact_time_start_date
                                 WHEN b.gubun = 2 THEN a.min_tact_time_start_date2
                                 WHEN b.gubun = 3 AND a.max_tact_time_end_date > a.max_tact_time_end_date2  THEN CONVERT(NVARCHAR(8), DATEADD(d, 1, CONVERT(DATETIME, a.max_tact_time_end_date2)) , 112)
                            END  AS tact_time_start_date
                  
                          , CASE WHEN b.gubun = 1 AND a.min_tact_time_start_date < a.min_tact_time_start_date2  THEN CONVERT(NVARCHAR(8), DATEADD(d, -1, CONVERT(DATETIME, a.min_tact_time_start_date2)) , 112)    -- select CONVERT(NVARCHAR(8), CONVERT(DATETIME, '27511231'), 112)
                                 WHEN b.gubun = 2 THEN a.max_tact_time_end_date2
                                 WHEN b.gubun = 3 AND a.max_tact_time_end_date > a.max_tact_time_end_date2  THEN a.max_tact_time_end_date
                            END  AS tact_time_end_date
                       
                          , CASE WHEN b.gubun = 1 AND a.min_tact_time_start_date < a.min_tact_time_start_date2  THEN a.use_yn
                                 WHEN b.gubun = 2 THEN a.use_yn2
                                 WHEN b.gubun = 3 AND a.max_tact_time_end_date > a.max_tact_time_end_date2  THEN a.use_yn
                            END  AS use_yn  
                          
                          , CASE WHEN b.gubun = 1 AND a.min_tact_time_start_date < a.min_tact_time_start_date2  THEN a.tact_time  
                                 WHEN b.gubun = 2 THEN a.tact_time2
                                 WHEN b.gubun = 3 AND a.max_tact_time_end_date > a.max_tact_time_end_date2  THEN a.tact_time
                            END  AS tact_time
                          
                          , CASE WHEN b.gubun = 1 AND a.min_tact_time_start_date < a.min_tact_time_start_date2  THEN a.yield 
                                 WHEN b.gubun = 2 THEN a.yield2 
                                 WHEN b.gubun = 3 AND a.max_tact_time_end_date > a.max_tact_time_end_date2  THEN a.yield 
                            END  AS yield

                          , b.gubun
                    FROM   #scp_mst_tact_time_except_final a
                      ,    (SELECT 1 gubun UNION ALL SELECT 2 gubun UNION ALL SELECT 3 gubun) b
                 ) x
          WHERE  (
                    ( x.gubun = 1 AND x.tact_time_start_date IS NOT NULL AND x.tact_time_end_date IS NOT NULL AND x.use_yn IS NOT NULL)
                    OR
                    x.gubun = 2
                    OR
                    ( x.gubun = 3 AND x.tact_time_start_date IS NOT NULL AND x.tact_time_end_date IS NOT NULL AND x.use_yn IS NOT NULL)
                 )
          ;
          
          -----------------------------------------------------------
          --2-4-0-9) is_use='Y'건과 날짜겹치지 않는 is_use = 'N'건 임시테이블 생성
          -----------------------------------------------------------
          IF OBJECT_ID('tempdb..#scp_mst_tact_time_except_final_use_n') IS NOT NULL
          BEGIN 
              DROP TABLE #scp_mst_tact_time_except_final_use_n
          END
          
            SELECT  DISTINCT
                    a.division_id
                    , a.plant_site_id
                    , a.item_id
                    , a.operation_id
                    , a.line_id
                    , a.min_tact_time_start_date  AS tact_time_start_date
                    , a.max_tact_time_end_date    AS tact_time_end_date
                    , a.use_yn
                    , a.tact_time
                    , a.yield                 
            INTO   #scp_mst_tact_time_except_final_use_n
            FROM   #temp_use_yn_n a           
                   LEFT JOIN ( SELECT division_id, plant_site_id, item_id, operation_id, line_id, min_tact_time_start_date2, max_tact_time_end_date2, use_yn, tact_time, yield
                               FROM   #scp_mst_tact_time_except_final
                               WHERE  division_id2 IS NOT NULL
                           ) b
                   ON   a.division_id = b.division_id
                   AND  a.plant_site_id = b.plant_site_id
                   AND  a.item_id       = b.item_id
                   AND  a.operation_id  = b.operation_id
                   AND  a.line_id       = b.line_id 
                   AND  a.min_tact_time_start_date = b.min_tact_time_start_date2
                   AND  a.max_tact_time_end_date   = b.max_tact_time_end_date2
            WHERE b.division_id IS NULL
            ;
         
         -----------------------------------------------------------
         --2-4-0-10) 최종INSERT( 위2-4-0-7), 2-4-0-8) union all 처리) 
         -----------------------------------------------------------
         IF OBJECT_ID('tempdb..#scp_mst_tact_time_except') IS NOT NULL
         BEGIN 
             DROP TABLE #scp_mst_tact_time_except
         END
         
         SELECT DISTINCT
                division_id
              , plant_site_id
              , item_id
              , operation_id
              , line_id
              , tact_time_start_date
              , tact_time_end_date
              , use_yn
              , tact_time
              , yield                 
         INTO   #scp_mst_tact_time_except
         FROM   ( SELECT division_id
                       , plant_site_id
                       , item_id
                       , operation_id
                       , line_id
                       , tact_time_start_date
                       , tact_time_end_date
                       , use_yn
                       , tact_time
                       , yield                 
                  FROM #scp_mst_tact_time_except_final_use_yn --IS_USE='Y'(IS_USE='N'과 날자겹치지 않는건들 및 IS_USE='N'과 날짜겹치는건들 포함)
                  
                  UNION ALL
                         
                  SELECT division_id
                       , plant_site_id
                       , item_id
                       , operation_id
                       , line_id
                       , tact_time_start_date
                       , tact_time_end_date
                       , use_yn
                       , tact_time
                       , yield                 
                  FROM #scp_mst_tact_time_except_final_use_n  --IS_USE='N'(IS_USE='Y'와 날짜겹치지 않는건들만 포함)
                ) x
        --WHERE 1 = 1
        ;
        (주석종료) 20190405 scp_mst_tact_time_except (날짜 겹치게 입력되어있을경우) 날짜겹칩 방지처리 */

        ---------------------------------------------------------------
        --2-4)-1) 분할대상 임시테이블생성 (except 처리)       
        --     - 분할대상 : tact_time값을  scp_mst_tact_time 값 사용한 데이터 중 except 대상데이터
        ---------------------------------------------------------------
        IF OBJECT_ID('tempdb..#DIV_TH_ENG_OP_RES_GROUP_MAP_CAL') IS NOT NULL
        BEGIN 
            DROP TABLE  #DIV_TH_ENG_OP_RES_GROUP_MAP_CAL          
        END

        SELECT x.*
             , DATEDIFF(d, x.start_dttm, x.except_start_date) AS start_date_diff -- 'scp_mst_tact_time_except의 tact_time_start_date' - 'th_eng_op_res_group_map_cal의start_dttm'  

             , DATEDIFF(d, x.except_end_date, x.end_dttm) AS end_date_diff -- 'th_eng_op_res_group_map_cal의 end_dttm' - 'scp_mst_tact_time_except의 tact_time_end_date'    

             , DATEDIFF(d, x.except_end_date, CONVERT(DATETIME, x.next_except_tact_time_start_date)) AS except_enddate_nextstartdate_diff  -- '다음행의 scp_mst_tact_time_except의 tact_time_start_date' -'현재행의 scp_mst_tact_time_except의 tact_time_end_date'  
        INTO   #DIV_TH_ENG_OP_RES_GROUP_MAP_CAL 
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
               
                FROM    #TH_ENG_OP_RES_GROUP_MAP_CAL a
                        INNER JOIN ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                                    select a.* , di.attribute3 AS division_group , di.attribute4 AS division_comp 
                                    FROM   scp_mst_tact_time_except  a WITH(NOLOCK)
                                         , scm_mst_division     di WITH(NOLOCK)
                                    WHERE  di.division_id    =  a.division_id
                                    AND    di.valid_yn       = 'Y'
                                    AND    di.attribute4     =  @v_division_comp   -- 회사코드 
                                    ) b            
                         /*  20220404 변경전 
                        INNER JOIN scp_mst_tact_time_except b WITH (NOLOCK)  */ 
                        --ON   dbo.fn_scm_split(dbo.fn_scm_split(a.resource_group_id, 2, '::'), 1, '~') = b.plant_site_id 
                        ON   a.plant_site_id = b.plant_site_id 
                        AND  a.item_id  = b.item_id 
                        AND  a.route_id LIKE b.operation_id + '%'
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
                        AND  b.division_group IN ( '40', '81', '82')  -- 2022.04.04 컬럼변경

                        /* 20220404 변경전 
                        --AND  b.division_id = @p_division_id  --'81' -- 20180702 주석처리
                        AND  b.division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)   */ 
                         
                WHERE a.master_id = @p_master_id       
                AND   a.plan_id   = @p_engine_plan_id  
                --20180917 수정
                -- 경우1) scp_mst_tact_time_except.use_yn = 'N' 일때 (tact_time_start_date ~ tact_time_end_date 까지 is_use = 'N')
                -- 경우2) scp_mst_tact_time_except.use_yn = 'Y' 일때 : tact_time_start_date가 차월이전이라도 차월이후만 scp_mst_tact_time_except(tact_time_start_date ~ tact_time_end_date 기간만큼 scp_mst_tact_time_except.is_use 값을 그대로 입력함 )
                AND   IIF(b.use_yn = 'Y', a.scp_tact_time_use_yn, 'Y') = 'Y'  --20180917 수정(변경전 : AND   a.scp_tact_time_use_yn = 'Y')

                      -- line assign 정보의 priority IN (0, 9) 대상(th_eng_op_res_group_map_cal INSERT시 is_use = 'N' 처리 대상) 들 제외
                AND   NOT EXISTS ( SELECT 1
                                   FROM   #TH_ENG_OP_RES_GROUP_MAP_CAL2 
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
        SET @v_log_message = 'PART 2-4-1';
        SET @v_description = N'2-4-1. 분할대상 생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        ---------------------------------------------------------------
        --2-4)-2) 분할대상 except 일자별로 분리후 임시테이블에 생성
             --  참고1) th_eng_op_res_group_map_cal.end_dttm          end_dttm미포함 => th_eng_op_res_group_map_cal의 start_dttm( ex)20180501) ~ end_dttm( ex)20180512) 이라하면  20180501~20180511까지가 대상이다.)
             --      2) scp_mst_tact_time_except.tact_time_end_date  tact_time_end_date포함 => scp_mst_tact_time_except의 tact_time_start_date( ex)20180501) ~ formation_end_date( ex)20180512) 이라하면  20180501~20180512까지가 대상이다.)
        ---------------------------------------------------------------
        IF OBJECT_ID('tempdb..#TH_ENG_OP_RES_GROUP_MAP_CAL_ADD') IS NOT NULL
        BEGIN 
            DROP TABLE  #TH_ENG_OP_RES_GROUP_MAP_CAL_ADD          
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
        
        INTO  #TH_ENG_OP_RES_GROUP_MAP_CAL_ADD
        FROM (
                SELECT *
                FROM  #DIV_TH_ENG_OP_RES_GROUP_MAP_CAL a
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
        SET @v_log_message = 'PART 2-4-2';
        SET @v_description = N'2-4-2. 분할대상 일자별로 분리 생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        ---------------------------------------------------------------
        --2-5) LINECAPA 대상 전체 INSERT ( except 비대상 + except 대상)        
        ---------------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_EE_PRE_PROC_OP_RES_GROUP_MAP_CAL */ th_eng_op_res_group_map_cal_sn
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
		     , tact_time
		     , tact_time_uom
		     , yield
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
                   FROM   #TH_ENG_OP_RES_GROUP_MAP_CAL  a   -- select count(*) from #TH_ENG_OP_RES_GROUP_MAP_CAL
                   WHERE  NOT EXISTS ( SELECT 1
                                       FROM   
                                            ( SELECT DISTINCT master_id, plan_id, site_id, operation_id, item_id, resource_map_id, resource_group_id, start_dttm, route_id
                                                FROM #DIV_TH_ENG_OP_RES_GROUP_MAP_CAL 
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
                                      FROM   #TH_ENG_OP_RES_GROUP_MAP_CAL2 --MASTER_ID, PLAN_ID, SITE_ID, OPERATION_ID, ITEM_ID, RESOURCE_MAP_ID, RESOURCE_GROUP_ID, START_DTTM, ROUTE_ID
                                      WHERE  site_id           = a.site_id 
                                      AND    operation_id      = a.operation_id 
                                      AND    item_id           = a.item_id 
                                      AND    resource_map_id   = a.resource_map_id 
                                      AND    resource_group_id = a.resource_group_id 
                                      AND    start_dttm        = a.start_dttm
                                      AND    route_id          = a.route_id 
                                ) 
                   UNION ALL  
                   SELECT * FROM #TH_ENG_OP_RES_GROUP_MAP_CAL2 

                   UNION ALL

                   -- scp_mst_tact_time_except 대상(start_dttm, end_dttm 분할된 신규데이터)
                   SELECT * FROM #TH_ENG_OP_RES_GROUP_MAP_CAL_ADD 
               ) xx
        ;
		
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 2-5';
        SET @v_description = N'2-5. LINECAPA 대상 INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
        -- 2.2 OSP_L 공정 : 외주 Line Capa 공정 ( th_eng_op_res_group_map_sn.descr 컬럼값이 'OSP_L' 일때) 
        --                - tact_time, yield값을 th_eng_bucket_info의 기간만큼 월별로 데이터 생성
		--  2020.02.03 [OSP Line Plan] OSP이면서 Line별 Capa 적용 Site
        -----------------------------------------------------------
        -----------------------------------------------------------
        -- 임시테이블 생성
        -----------------------------------------------------------		
        IF OBJECT_ID('tempdb..#TH_ENG_OP_RES_GROUP_MAP_CAL_OSP_L') IS NOT NULL
        BEGIN 
            DROP TABLE  #TH_ENG_OP_RES_GROUP_MAP_CAL_OSP_L          
        END

        CREATE TABLE #TH_ENG_OP_RES_GROUP_MAP_CAL_OSP_L(
	        MASTER_ID nvarchar(50) NOT NULL,
	        PLAN_ID nvarchar(50) NOT NULL,
	        SITE_ID nvarchar(50) NOT NULL,
	        ROUTE_ID nvarchar(50) NOT NULL,
	        OPERATION_ID nvarchar(50) NOT NULL,
	        ITEM_ID nvarchar(50) NOT NULL,
	        RESOURCE_MAP_ID nvarchar(80) NOT NULL,
	        RESOURCE_GROUP_ID nvarchar(80) NOT NULL,
	        START_DTTM datetime NOT NULL,
	        END_DTTM datetime NOT NULL,
	        SUB_RESOURCE_MAP_ID nvarchar(150) NULL,
	        RESOURCE_MAP_LEVEL numeric(20, 10) NULL DEFAULT ((1)),
	        ALT_PRIORITY numeric(20, 10) NULL,
	        TACT_TIME numeric(20, 10) NOT NULL,
	        TACT_TIME_UOM nvarchar(10) NULL DEFAULT ('SECOND'),
	        YIELD numeric(20, 10) NULL DEFAULT ((1)),
	        GOOD_RATE numeric(20, 10) NULL,
	        BATCH_RATE numeric(20, 10) NULL,
	        IS_USE nvarchar(1) NULL DEFAULT ('Y'),
	        DESCR nvarchar(2000) NULL,
	        CONSUME_RES_RATE numeric(20, 10) NULL,
	        PREPARE_TIME numeric(20, 10) NULL DEFAULT ((0)),
	        PREPARE_TIME_UOM nvarchar(10) NULL DEFAULT ('HOUR')

            , SCP_TACT_TIME_USE_YN nvarchar(10) NULL  --기존테이블에 없는 컬럼(scp_mst_tact_time 사용여부)
            , LINE_ID nvarchar(10) NULL
	        , PLANT_SITE_ID nvarchar(50)  NULL
        )
        ;

        -----------------------------------------------------------
        -- 2.2-1) OSP_L tact_time/ yield 셋팅 : is_use 컬럼 'Y' 셋팅
        --        전 구간 scp관리(scp_mst_tact_time_osp.tact_time / yield) tact_time/yield 사용함
		--        임시테이블에 INSERT
        -----------------------------------------------------------		
        INSERT INTO /* PR_SCP_ENG_EE_PRE_PROC_OP_RES_GROUP_MAP_CAL */ #TH_ENG_OP_RES_GROUP_MAP_CAL_OSP_L
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
             , ISNULL(tat.end_dttm, CONVERT(DATETIME, @v_add_pet_date))	 AS end_dttm   -- (2022.01.26) @v_pet_date ->  @v_add_pet_date 으로 변경
             , res.sub_resource_map_id
			 , res.resource_map_level
             , res.alt_priority

			 -- Input용 Tact Time은 수율을 곱해서 적용함
             , ISNULL(tat.tact_time * ISNULL(tat.yield,1), res.tact_time)  AS tact_time 
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
                  --WHERE t.origin_division_id = @p_division_id  -- 20180702 주석처리
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
        SET @v_log_message = 'PART 2.2-1)';
        SET @v_description = N'2.2-1) OSP_L tact_time/ yield 셋팅' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;		
		
        -----------------------------------------------------------
        -- 2.2-2) OSP_L tact_time_except 적용(line capa 대상에만 적용함) 
        --        적용해서 생성된 th_eng_op_res_group_map_cal_sn 데이터중에서 
        --        scp_mst_tact_time_except_osp.tact_time_start_date ~ scp_mst_tact_time_except_osp.tact_time_end_date 기간에 포함된 데이터의 값 대체  
        -----------------------------------------------------------		
        ---------------------------------------------------------------
        --2.2-2-1) 분할대상 임시테이블생성  (except 처리)      
        --      - 분할대상 : tact_time값을  scp_mst_tact_time_osp 값 사용한 데이터 중 except 대상데이터
        ---------------------------------------------------------------
        IF OBJECT_ID('tempdb..#DIV_TH_ENG_OP_RES_GROUP_MAP_CAL_OSP_L') IS NOT NULL
        BEGIN 
            DROP TABLE  #DIV_TH_ENG_OP_RES_GROUP_MAP_CAL_OSP_L          
        END

        SELECT x.*
             , DATEDIFF(d, x.start_dttm, x.except_start_date) AS start_date_diff -- 'scp_mst_tact_time_except_osp의 tact_time_start_date' - 'th_eng_op_res_group_map_cal의start_dttm'  

             , DATEDIFF(d, x.except_end_date, x.end_dttm) AS end_date_diff -- 'th_eng_op_res_group_map_cal의 end_dttm' - 'scp_mst_tact_time_except_osp의 tact_time_end_date'    

             , DATEDIFF(d, x.except_end_date, CONVERT(DATETIME, x.next_except_tact_time_start_date)) AS except_enddate_nextstartdate_diff  -- '다음행의 scp_mst_tact_time_except_osp의 tact_time_start_date' -'현재행의 scp_mst_tact_time_except_osp의 tact_time_end_date'  
        INTO   #DIV_TH_ENG_OP_RES_GROUP_MAP_CAL_OSP_L 
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
                        , LEAD(b.tact_time_start_date, 1)  OVER (PARTITION BY a.master_id, a.plan_id, a.site_id, a.operation_id, a.item_id, a.resource_map_id, a.resource_group_id, a.start_dttm, a.route_id ORDER BY a.start_dttm, b.tact_time_start_date) next_except_tact_time_start_date  --다음행의 scp_mst_tact_time_except_osp.tact_time_start_date
               
                FROM    #TH_ENG_OP_RES_GROUP_MAP_CAL_OSP_L a
                        INNER JOIN ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                                    SELECT b.* , di.attribute3 AS division_group , di.attribute4 AS division_comp 
                                    FROM  scp_mst_tact_time_except_osp  b WITH (NOLOCK)
                                        , scm_mst_division             di WITH(NOLOCK)
                                    WHERE  di.division_id  =  b.division_id
                                    AND    di.valid_yn     = 'Y'
                                    AND    di.attribute4   = @v_division_comp   -- 회사코드  
                                  ) b 
                        /* 20220404 변경전 
                        INNER JOIN scp_mst_tact_time_except_osp b WITH (NOLOCK) 
                        --ON   dbo.fn_scm_split(dbo.fn_scm_split(a.resource_group_id, 2, '::'), 1, '~') = b.plant_site_id 
                        */
                        ON   a.plant_site_id = b.plant_site_id 
                        AND  a.item_id  = b.item_id 
                        AND  a.route_id LIKE b.operation_id + '%'
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
                        AND  b.division_group  IN ( '40', '81', '82')  --2022.04.04 컬럼변경. 20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)

                        /* 20220404 변경전: join문 안으로 이동하여 주석처리함. 
                        --AND  b.division_id = @p_division_id  --'81' -- 20180702 주석처리
                        AND  b.division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)  
                        */ 
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
        SET @v_log_message = 'PART 2.2-2-1';
        SET @v_description = N'2.2-2-1. 분할대상 생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        ---------------------------------------------------------------
        --2.2-2)-2) 분할대상 except 일자별로 분리후 임시테이블에 생성
             --  참고1) th_eng_op_res_group_map_cal.end_dttm          end_dttm미포함 => th_eng_op_res_group_map_cal의 start_dttm( ex)20180501) ~ end_dttm( ex)20180512) 이라하면  20180501~20180511까지가 대상이다.)
             --      2) scp_mst_tact_time_except_osp.tact_time_end_date  tact_time_end_date포함 => scp_mst_tact_time_except_osp의 tact_time_start_date( ex)20180501) ~ formation_end_date( ex)20180512) 이라하면  20180501~20180512까지가 대상이다.)
        ---------------------------------------------------------------
        IF OBJECT_ID('tempdb..#TH_ENG_OP_RES_GROUP_MAP_CAL_ADD_OSP_L') IS NOT NULL
        BEGIN 
            DROP TABLE  #TH_ENG_OP_RES_GROUP_MAP_CAL_ADD_OSP_L          
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
        
        INTO  #TH_ENG_OP_RES_GROUP_MAP_CAL_ADD_OSP_L
        FROM (
                SELECT *
                FROM  #DIV_TH_ENG_OP_RES_GROUP_MAP_CAL_OSP_L a
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
        SET @v_log_message = 'PART 2.2-2-2';
        SET @v_description = N'2.2-2-2. 분할대상 일자별로 분리 생성' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        ---------------------------------------------------------------
        --2.2-3) LINECAPA 대상 전체 INSERT ( except 비대상 + except 대상)        
        ---------------------------------------------------------------
		INSERT INTO /* PR_SCP_ENG_EE_FN_PROC_OP_RES_GROUP_MAP_CAL */ th_eng_op_res_group_map_cal_sn
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
		     , tact_time
		     , tact_time_uom
		     , yield
             , good_rate
		     , batch_rate             
             , CASE WHEN tact_time = 0 THEN 'N'  
                    ELSE is_use
               END AS is_use  --20180605 추가 (변경전 : , is_use )               
             , descr
		     , consume_res_rate
		     , prepare_time
		     , prepare_time_uom
     --   */
		FROM   (   
                   --  scp_mst_tact_time_except_osp 비대상 데이터
                   SELECT * 
                   FROM   #TH_ENG_OP_RES_GROUP_MAP_CAL_OSP_L  a
                   WHERE  NOT EXISTS ( SELECT 1
                                       FROM   
                                            ( SELECT DISTINCT master_id, plan_id, site_id, operation_id, item_id, resource_map_id, resource_group_id, start_dttm, route_id
                                                FROM #DIV_TH_ENG_OP_RES_GROUP_MAP_CAL_OSP_L 
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
                   SELECT * FROM #TH_ENG_OP_RES_GROUP_MAP_CAL_ADD_OSP_L 
               ) xx
		;
		
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 2.2-3 ';
        SET @v_description = N'2.2-3. LINECAPA 대상 INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
        -- 3. 20200330 [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - 전극 수율 개선 : Cell 총 수율을 P 공정에 설정     
        --   - descr = 'NO_CAPA' 이면서 operation_id가 A3000/A9000 인 경우 Tact Time Except 테이블 정보를 시용하여 yield 생성
        --     SCP_MST_TACT_TIME_EXCEPT의 수율 일괄 반영 : Operation_id = 'Z_A00T', Line_id = '-'         
        -----------------------------------------------------------
		INSERT INTO /* PR_SCP_ENG_EE_PRE_PROC_OP_RES_GROUP_MAP_CAL */ th_eng_op_res_group_map_cal_sn
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
             , ISNULL(tat.start_dttm, CONVERT(DATETIME, @p_plan_name)) AS start_dttm
             --, ISNULL(tat.end_dttm, DATEADD(DD, 52*7 ,(CONVERT(DATETIME, '20200203'))))
             , ISNULL(tat.end_dttm, CONVERT(DATETIME, @v_add_pet_date))	 AS end_dttm   -- (2022.01.26) @v_pet_date ->  @v_add_pet_date 으로 변경
             , res.sub_resource_map_id
			 , res.resource_map_level
             , res.alt_priority

			 -- Input용 Tact Time은 수율을 곱해서 적용함 : 실제로는 무한 Capa 적용
             , 0.0000000001 AS tact_time  -- ISNULL(tat.tact_time * ISNULL(tat.yield,1), res.tact_time)  AS tact_time 
             , res.tact_time_uom

             , ISNULL(tat.yield, res.yield) AS yield -- 20180405 수정 (변경전 : , ISNULL(yld.yield, res.yield) AS yield  --20180313 수정 (변경전 : , res.yield) )

             , res.good_rate
			 , res.batch_rate
             , ISNULL(tat.use_yn, 'Y') AS is_use -- except 에 없는 경우 Group Map 정보 사용 : 없을 경우 제외하려면 'N' 으로 조정
             , res.descr
			 , res.consume_res_rate
			 , res.prepare_time
			 , res.prepare_time_uom

        FROM  (SELECT g.*
                    , s.plant_id
                    , SUBSTRING(g.resource_group_id, dbo.FN_CHARINDEX_REV(g.resource_group_id, '::', 0)+2, 100) AS line_id
               FROM   th_eng_op_res_group_map_sn g WITH(NOLOCK)
                    , scm_mst_site_eng           s WITH(NOLOCK)
               WHERE  g.master_id     = @p_master_id
               AND    g.plan_id       = @p_engine_plan_id
               AND    s.modeling_id   = @p_modeling_id
               AND    s.plan_id       = @p_plan_id
               AND    s.plan_type     = @p_plan_type
               AND    s.plan_seq      = @p_seq
               AND    g.site_id       = s.eng_scm_site_id
               -- descr = 'NO_CAPA' 이면서 operation_id가 A3000/A9000 인 경우 Tact Time Except 테이블 정보를 시용하여 yield 생성
               AND    g.descr         = 'NO_CAPA'    
               AND    g.operation_id IN ('A3000', 'A9000')
              ) res
              LEFT OUTER JOIN 
                 (SELECT t.division_id AS origin_division_id

                       , t.operation_id 
                       , t.line_id
                       , t.item_id
                       , CASE WHEN t.tact_time_start_date >= @p_plan_name THEN CONVERT(DATETIME, t.tact_time_start_date) 
                              ELSE @d_plan_name
                         END   start_dttm
						 /**(2022.01.26) @v_pet_date ->  @v_add_pet_date 으로 변경 **/
                       , CASE WHEN t.tact_time_end_date < @v_add_pet_date THEN DATEADD(DD, 1, CONVERT(DATETIME, t.tact_time_end_date))         
                              ELSE CONVERT(DATETIME, @v_add_pet_date)
                         END   end_dttm

                       , t.tact_time
					   , CASE WHEN t.yield = 0 THEN 1
                              WHEN t.yield > 1 THEN 1
                              ELSE ISNULL(t.yield, 1)
                         END AS yield 
                       , t.plant_site_id + '~***' AS eng_scm_site_id 
					   , t.use_yn

                  FROM   (-- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                         SELECT t.* , di.attribute3 AS division_group , di.attribute4 AS division_comp 
                         FROM   scp_mst_tact_time_except t WITH(NOLOCK)  
                              , scm_mst_division         di WITH(NOLOCK)
                         WHERE  di.division_id    =  t.division_id
                         AND    di.valid_yn       = 'Y'
                         AND    di.attribute4     = @v_division_comp    --회사코드
                        ) t
                  WHERE  t.division_group     IN ( '40', '81', '82') --2022.04.04 컬럼변경
                  AND    t.operation_id        = 'Z_A00T' -- Cell 전체 공정
                  AND    t.line_id             = '-'      -- 가중 평균 값
                  AND    t.tact_time_end_date >= @p_plan_name  
                  /* 20220404 변경전 
                  FROM   scp_mst_tact_time_except t WITH(NOLOCK)  
                  WHERE  t.division_id        IN ('40', '81', '82') -- = @p_division_id       
                  AND    t.operation_id        = 'Z_A00T' -- Cell 전체 공정
                  AND    t.line_id             = '-'      -- 가중 평균 값
                  AND    t.tact_time_end_date >= @p_plan_name   */  
                 ) tat
				 
               ON  res.site_id      = tat.eng_scm_site_id
               --AND res.route_id     = tat.operation_id
               AND res.line_id      = tat.line_id
               AND res.item_id      = tat.item_id

        WHERE  res.resource_map_level = 1
		;	
		
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 3 ';
        SET @v_description = N'3. Cell 총 수율 대상 INSERT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
		-- 4. th_eng_op_res_group 테이블의 1) min_tact_time, 2) avg_tact_time, 3) max_tact_time 컬럼값 UPDATE 
        --    - min_tact_time, avg_tact_time, max_tact_time 값을 
        --      1)th_eng_op_res_group_map.tact_time, 2)th_eng_op_res_group_group_map_cal.tact_time 1),2)둘중 큰값으로 변경                     
        -----------------------------------------------------------
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

        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 4 ';
        SET @v_description = N'4. th_eng_op_res_group_sn 테이블의 min/avg/max tact_time UPDATE' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
        -- 임시테이블 삭제
        -----------------------------------------------------------		
        ------------------------------------------------------------
        --임시테이블 삭제
        ------------------------------------------------------------
        IF OBJECT_ID('tempdb..#scm_mst_tact_time_sn') IS NOT NULL
        BEGIN
            DROP TABLE #scm_mst_tact_time_sn
        END 
         
        IF OBJECT_ID('tempdb..#scp_mst_tact_time') IS NOT NULL
        BEGIN
            DROP TABLE #scp_mst_tact_time
        END 

        IF OBJECT_ID('tempdb..#tact_op_flow_temp_1') IS NOT NULL
        DROP TABLE #tact_op_flow_temp_1

        IF OBJECT_ID('tempdb..#tact_op_flow_temp_2') IS NOT NULL
        DROP TABLE #tact_op_flow_temp_2 

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

        IF OBJECT_ID('tempdb..#TH_ENG_OP_RES_GROUP_MAP_CAL') IS NOT NULL
        BEGIN 
            DROP TABLE  #TH_ENG_OP_RES_GROUP_MAP_CAL          
        END

        IF OBJECT_ID('tempdb..#TH_ENG_OP_RES_GROUP_MAP_CAL2') IS NOT NULL
        BEGIN 
            DROP TABLE  #TH_ENG_OP_RES_GROUP_MAP_CAL2          
        END

        IF OBJECT_ID('tempdb..#DIV_TH_ENG_OP_RES_GROUP_MAP_CAL') IS NOT NULL
        BEGIN 
            DROP TABLE  #DIV_TH_ENG_OP_RES_GROUP_MAP_CAL          
        END

        IF OBJECT_ID('tempdb..#TH_ENG_OP_RES_GROUP_MAP_CAL_ADD') IS NOT NULL
        BEGIN 
            DROP TABLE  #TH_ENG_OP_RES_GROUP_MAP_CAL_ADD          
        END
        	
        IF OBJECT_ID('tempdb..#TH_ENG_OP_RES_GROUP_MAP_CAL_OSP_L') IS NOT NULL
        BEGIN 
            DROP TABLE  #TH_ENG_OP_RES_GROUP_MAP_CAL_OSP_L          
        END

        IF OBJECT_ID('tempdb..#DIV_TH_ENG_OP_RES_GROUP_MAP_CAL_OSP_L') IS NOT NULL
        BEGIN 
            DROP TABLE  #DIV_TH_ENG_OP_RES_GROUP_MAP_CAL_OSP_L          
        END

        IF OBJECT_ID('tempdb..#TH_ENG_OP_RES_GROUP_MAP_CAL_ADD_OSP_L') IS NOT NULL
        BEGIN 
            DROP TABLE  #TH_ENG_OP_RES_GROUP_MAP_CAL_ADD_OSP_L          
        END
        
        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        -- TXN LOG
        --SET @n_log_count = @@ROWCOUNT;
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

