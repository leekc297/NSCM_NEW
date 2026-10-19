
/*
 * Program ID   : PR_SCP_ENG_EE_PRE_PROC_OP_RES_GROUP_MAP
 * Description  : ODB의 Op Res Group Map 정보를 ODB에 적재되도록 한다.

                  -----------------------------------------------------------
                  -- 1. Capa 비대상 / 라인 모델링 비대상
                  -----------------------------------------------------------
                        -  대상 : th_eng_op_res_group_sn.descr = 'NO_CAPA'                         
                        -  컬럼1) tact_time :  0.0000000001 셋팅(티라요청사항)
                           컬럼2) yield     :  20200330 전극 LINE_CAPA 공정 외는 Yield는 전부 1로 처리
						                 OLD)  값1) (FP yield) => FP yield 값의 평균값사용( eng_scm_site_id, flow_id, division_id, plant_id, item_id GROUP BY 평균값 사용함 (참고) CAPA비대상일경우line_id가 존재하지 않으므로 AVG값 사용함)
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
                                              ==> FP tact time : 전극은 당월(플랜시작일의 yyyymm사용) scm_mst_tact_time_ver_h_v.tact_time 컬럼사용  
                           컬럼2) yield     :  20200330 전극 LINE_CAPA 공정 외는 Yield는 전부 1로 처리
						                 OLD)  [ISNULL(FP yield, ISNULL(SCP yield, th_eng_op_res_group_sn.yield))] (참고)th_eng_op_res_group_sn.yield 값은 1로 하드코딩되어있음
                                               ==>값1) (FP yield) => FP yield 값의 평균값사용( eng_scm_site_id, flow_id, division_id, plant_id, item_id GROUP BY 평균값 사용함 (참고) CAPA비대상일경우line_id가 존재하지 않으므로 AVG값 사용함)
                                               ==>값2) (SCP yield) => 값1 미존재시 SCP yield 값의 MIN값사용( division_id, plant_site_id, item_id, operation_id GROUP BY MIN값 사용함 (참고) CAPA비대상일경우line_id가 존재하지 않으므로 AVG값 사용함)
                                               ==>값3) (th_eng_op_res_group_sn.yield) => 값1, 값2 미존재시 1 셋팅(th_eng_op_res_group_sn.yield이 1로 하드코딩되어있음)
                           컬럼3) is_first_setup : 'N' 셋팅
                           컬럼4) descr          : th_eng_op_res_group_sn.descr 값셋팅

                        -  참고테이블1) scm_mst_tact_time_ver_h_v : FP tact time정보
                           참고테이블2) scm_mst_yield_ver_h_v     : FP yield 정보
                           참고테이블3) scp_mst_tact_time    : SCP tact time, SCP yield 정보
                           참고테이블4) scm_mst_item_line_assign_sn  : line 정보 (priority IN ('0', '9') 가 아닌데이터 사용)
                  -----------------------------------------------------------
                  -- 2.2 CAPA : 라인 모델링 비대상 : SCP 정보 사용
                  -- (참고 : 2.2는 실행하지 않아도 됨, 현재 CAPA공정이면 모두 라인모델링대상 공정만 존재하므로 라인모델링비대상 데이터는 존재하지 않는다. 차후 CAPA공정이면서 라인모델링비대상 데이터 존재할때를 대비해서 생성하였음) 
                  -----------------------------------------------------------
                        -  대상 : th_eng_op_res_group_sn.descr = 'CAPA'이면서  "2.1 에서 생성된 데이터 제외한 데이터중 SCP tact time 존재건"
                        -  컬럼1) tact_time : [SCP tact time] * [ISNULL(FP yield, ISNULL(SCP yield, th_eng_op_res_group_sn.yield))] (참고)th_eng_op_res_group_sn.yield 값은 1로 하드코딩되어있음
                           컬럼2) yield     :  20200330 전극 LINE_CAPA 공정 외는 Yield는 전부 1로 처리
						                 OLD)  [ISNULL(FP yield, ISNULL(SCP yield, th_eng_op_res_group_sn.yield))] (참고)th_eng_op_res_group_sn.yield 값은 1로 하드코딩되어있음
                                               ==>값1) (FP yield) => FP yield 값의 평균값사용( eng_scm_site_id, flow_id, division_id, plant_id, item_id GROUP BY 평균값 사용함 (참고) CAPA비대상일경우line_id가 존재하지 않으므로 AVG값 사용함)
                                               ==>값2) (SCP yield) => 값1 미존재시 SCP yield 값의 MIN값사용( division_id, plant_site_id, item_id, operation_id GROUP BY MIN값 사용함 (참고) CAPA비대상일경우line_id가 존재하지 않으므로 AVG값 사용함)
                                               ==>값3) (th_eng_op_res_group_sn.yield) => 값1, 값2 미존재시 1 셋팅(th_eng_op_res_group_sn.yield이 1로 하드코딩되어있음)
                           컬럼3) is_first_setup : 'N' 셋팅
                           컬럼4) descr          : th_eng_op_res_group_sn.descr 값셋팅
                  
                        -  참고테이블1) scm_mst_tact_time_ver_h_v : FP tact time정보
                           참고테이블2) scm_mst_yield_ver_h_v     : FP yield 정보
                           참고테이블3) scp_mst_tact_time    : SCP tact time, SCP yield 정보
                           참고테이블4) scm_mst_item_line_assign_sn  : line 정보 (priority IN ('0', '9') 가 아닌데이터 사용)
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
                                              ==> FP tact time : 전극은 당월(플랜시작일의 yyyymm사용) scm_mst_tact_time_ver_h_v.tact_time 컬럼사용   
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
                  
                  --참고1) 소형(40) 전극이면서, item_uom = 'EA' 일때  
                           -  FP) tact_time :  scm_mst_tact_time_ver_h_v.tact_time / scp_mst_tact_time.uom_convert_value
                           - SCP) tact_time :  scp_mst_tact_time.tact_time / scp_mst_tact_time.uom_convert_value
                           단) scp_mst_tact_time.uom_convert_value 가 NULL이거나 0 이면 1 로 처리

 * OutTable     : TH_ENG_OP_RES_GROUP_MAP
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.01.18   KSW            전지본부 GSCM(DM/SCP) 구축 프로젝트
 * 2018.05.23   KSW            FIX 확정 생산 계획  정보 Insert 추가
 * 2018.05.31   KSG            Product Mix 사용에 따른 OSP 정보 수정
 * 2018.07.23   KSW            CAPA 비대상일때 tact_time 0을 0.0000000001 로 변경
 * 2018.09.17   KSW            소형(40)이면서 전극일때 tact_time 처리부분 수정 ( 현재 전극의 tact_time 처리시 item_uom(단위)와 tact_time 불일치(item_uom : 'EA' 인데 tact_tiem 은 'M' 단위 일때의 값으로 셋팅되어있음 ) ) 참고)주석2-1, 주석2-2, 주석4-1, 주석4-2 
 * 2018.09.28   KSW            전극 tact_time 계산시 사용되는 lane_qty 컬럼 대상 테이블 변경(scm_mst_item_lane_m_sn.lane_qty -> scm_mst_item_line_assign_sn.lane_qty)  참고) 주석2-1, 주석4-1
 * 2018.10.04   KSW            operation_id 조회조건 수정(참고)주석1
 * 2018.12.13   KSW            속도개선 : 조인힌트적용 (참고)주석4.1
 * 2019.03.05   KSW            [재료본부 전지재료 GSCM 구축 프로젝트] 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가 (전지재료('44') 사업부추가로 인한 조건추가) 
 * 2019.10.21   KSG            [IT서비스 요청번호:G20191025_000509] [CSR]GSCM 생산라인 우선순위 Logic 적용 요청
                               '라인 모델링 대상' Line 우선 순위 적용 : Input은 전 사업부 생성 => 엔진 설정으로 소형사업부만 적용함 : Default = '99'
 * 2020.02.06   KSG            [OSP Line Plan] OSP이면서 Line별 Capa 적용 Site 구분자 추가
 * 2020.03.30   KSG            [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - 전극 수율 개선 : Cell 총 수율을 P 공정에 설정
 * 2021.03.12   KSG            PJ20209642 Digital SCM Level.3 달성을 위한 개선 : FP Tact Time/Yield Table 변경
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

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_EE_PRE_PROC_OP_RES_GROUP_MAP]
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_EE_PRE_PROC_OP_RES_GROUP_MAP';
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
    -- DECLARE @v_division_id       NVARCHAR(30);
    --DECLARE @v_cur_monday        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    DECLARE @d_plan_name         DATETIME;

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
         , @v_division_comp    =  di.ATTRIBUTE4   -- 회사코드 
    FROM   scm_mst_division di WITH(NOLOCK)
    WHERE  di.valid_yn         =  'Y' 
    AND    di.division_id      =  @p_division_id     ; 

  -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id  ; 
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN
		
		DELETE /* PR_SCP_ENG_EE_PRE_PROC_OP_RES_GROUP_MAP */
		FROM   th_eng_op_res_group_map_sn
		WHERE  master_id = @p_master_id 
		AND    plan_id   = @p_engine_plan_id 
		;

        -----------------------------------------------------------
        -- 임시테이블1) FP tact_time 
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
              
            , CONVERT(NUMERIC(18, 4), CASE WHEN tt.division_group = '40' AND ISNULL(stt.item_uom, 'X') = 'EA' AND ISNULL(stt.operation_group, 'X') = 'E'   -- 2022.04.04 JV건: tt.division_id -> tt.division_group 
                                                 THEN  tt.tact_time/stt.uom_convert_value
                                            ELSE tt.tact_time
                                      END  ) AS tact_time  --FP의  tact_time 데이터 형식 : numeric(18,4)

            , tt.tact_time AS tact_time_org
            , stt.item_uom
            , stt.uom_convert_value
            , ISNULL(stt.priority, 99) AS priority -- 20191021 Line 우선 순위 적용
        INTO   #scm_mst_tact_time_sn  
        FROM  (  -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                SELECT tt.* , di.attribute3 AS division_group , di.attribute4 AS division_comp 
                FROM   dbo.scm_mst_tact_time_ver_h_v tt WITH (NOLOCK)
                     , scm_mst_division              di WITH(NOLOCK)
                WHERE  di.division_id    =  tt.division_id
                AND    di.valid_yn       = 'Y'
                AND    di.attribute4     =  @v_division_comp -- 같은회사 검색
              ) tt
        /* 20220404 변경전
        FROM   dbo.scm_mst_tact_time_ver_h_v tt WITH (NOLOCK) -- PJ20209642 scm_mst_tact_time_sn -> scm_mst_tact_time_ver_h_v 변경  */ 
                LEFT JOIN  ( SELECT aa.division_id, aa.plant_site_id, aa.item_id, aa.operation_id
                                --, aa.tact_time
                                , aa.item_uom
                                , aa.line_id
								, aa.priority -- 20191021 Line 우선 순위 적용

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
                                    AND    di.ATTRIBUTE4   = @v_division_comp --  같은회사 데이터만 가져오기.    
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

                                                and    a.division_id     = di.division_id 
                                                and    di.valid_yn       = 'Y'
                                                and    di.attribute3     = '40'             --022.04.04 컬럼변경: '소형' 구분
                                                and    di.ATTRIBUTE4     = @v_division_comp -- 회사코드 
                                                
                                                 /* 20220404 변경전
                                                SELECT division_id, scm_site_id
                                                    , plant_id, site_id, company_id 
                                                    , operation_group
                                                FROM scm_mst_site WITH (NOLOCK)  -- 소형('40') 인 division 값을 사용해야 하기 때문에  scm_mst_site_eng (전극일때 모든 scm_mst_site_eng.divison_id = 'EE')가 아닌  scm_mst_site 를 사용해야 한다.
                                                WHERE  division_id = '40'        
                                                AND    site_type   = 'PLANT'
                                                AND    operation_group = 'E'
                                                AND    valid_yn = 'Y'         */                                        
                                            ) bb
                                    ON   aa.division_id   = bb.division_id
                                    AND  aa.plant_site_id = bb.scm_site_id
                                    AND  aa.item_uom    = 'EA'
                            WHERE   1 = 1
                            AND     aa.valid_yn = 'Y'
                            AND     aa.division_group IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가), 2022.04.04 컬럼변경
                            
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
        AND   tt.division_group  IN ( '40', '81', '82') -- 2022.04.04 컬럼변경. 20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)
        
         /* 20220404 변경전
        AND   tt.division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)   */
        ;

        -----------------------------------------------------------
        -- 임시테이블2) SCP tact_time 
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
               -- 2022.04.04 JV건: tt.division_id -> tt.division_group으로 수정 
            ,  CONVERT(NUMERIC(20, 10), CASE WHEN a.division_group ='40' AND ISNULL(a.item_uom, 'X') = 'EA' AND ISNULL(b.operation_group, 'X') = 'E' 
                                                  THEN  a.tact_time /  (CASE WHEN a.uom_convert_value = 0  THEN 1
                                                                             ELSE ISNULL(a.uom_convert_value, 1)  
                                                                        END) --UOM_CONVERT_VALUE 가 NULL이거나 0 이면 1 로 처리
                                             ELSE  a.tact_time
                                        END ) AS tact_time -- SCP의  tact_time 데이터 형식 : numeric(20,10)
            
            ,  a.tact_time AS tact_time_org                                         
            ,  a.yield
            ,  a.valid_yn
            ,  a.priority -- 20191021 Line 우선 순위 적용  
        
        INTO #scp_mst_tact_time                                                                          
        FROM (  -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                SELECT a.* , di.attribute3 AS division_group , di.attribute4 AS division_comp 
                FROM   scp_mst_tact_time  a WITH(NOLOCK) 
                     , scm_mst_division   di WITH(NOLOCK)
                WHERE  di.division_id  =  a.division_id
                AND    di.valid_yn     = 'Y'
                AND    di.attribute4   =  @v_division_comp 
              ) a 
        /* 20220404 변경전
        FROM scp_mst_tact_time a WITH (NOLOCK)  
             LEFT JOIN scm_mst_site b WITH (NOLOCK)  */ 

             LEFT JOIN ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                        SELECT a.*  , di.attribute3 AS division_group , di.attribute4 AS division_comp 
                        FROM   scm_mst_site      a WITH (NOLOCK)
                             , scm_mst_division  di WITH(NOLOCK)
                        WHERE  di.division_id    =  a.division_id
                        AND    di.valid_yn       = 'Y' 
                        AND    di.attribute4     =  @v_division_comp 
                       ) b
             ON   a.division_id     = b.division_id
             AND  a.plant_site_id   = b.scm_site_id
             AND  b.valid_yn        = 'Y'
             AND  b.division_group  = '40'  --2022.04.04 컬럼변경         
              /* 20200404 변경전
             AND  b.division_id     = '40'   */                  
             AND  b.site_type       = 'PLANT'
             AND  b.operation_group = 'E'
        WHERE a.valid_yn = 'Y'
        AND   a.division_group  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가) 2022.04.04 컬럼변경
        /* 20220404 변경전
        AND   a.division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)  */
        ;

        -----------------------------------------------------------
        -- 1. Capa 비대상
        -----------------------------------------------------------
		INSERT INTO /* PR_SCP_ENG_EE_PRE_PROC_OP_RES_GROUP_MAP */ th_eng_op_res_group_map_sn
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

             -- 20200330 전극 LINE_CAPA 공정 외는 Yield는 전부 1로 처리 : [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - 전극 수율 개선
             , 1                    AS yield

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
		INSERT INTO /* PR_SCP_ENG_EE_PRE_PROC_OP_RES_GROUP_MAP */ th_eng_op_res_group_map_sn
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
             , d.tact_time * 1    -- 라인 모델링 비대상일때
                                    AS tact_time
                
             , a.tact_time_uom      AS tact_time_uom 

             -- 20200330 전극 LINE_CAPA 공정 외는 Yield는 전부 1로 처리 : [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - 전극 수율 개선
             , 1                    AS yield

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
               INNER JOIN       ( SELECT tt.eng_scm_site_id
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
                                 
                                              -- PJ20209642 Lane 수는 View에서 고려되어 있음 
											  , SUM(ISNULL(t.tact_time, 0)) AS tact_time
                                              , ROW_NUMBER() OVER (PARTITION BY t.plant_id, op.flow_id, t.line_id, t.item_id ORDER BY t.month ) row_num 
										/*
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
                                         FROM   #scm_mst_tact_time_sn t WITH(NOLOCK) -- 20180917 수정

                                         INNER JOIN (  -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                                                       SELECT a.* , di.attribute3 AS division_group , di.attribute4 AS division_comp 
                                                       FROM   dbo.scm_mst_operation_flow_v    a WITH(NOLOCK)
                                                            , scm_mst_division               di WITH(NOLOCK)
                                                       WHERE  di.division_id    =  a.division_id
                                                       AND    di.valid_yn       = 'Y'
                                                       AND    di.attribute4     = @v_division_comp  --회사코드(LG/UC/...)
                                                    ) op 
                                         /* 20220404 변경전 
                                         INNER JOIN dbo.scm_mst_operation_flow_v op WITH(NOLOCK) */
										 ON     t.division_id  = op.division_id
                                         AND    t.company_id   = op.company_id
                                         AND    t.site_id      = op.site_id
                                         AND    t.operation_id = op.operation_id
                                         AND   op.division_group  IN ( '40', '81', '82')  --2022.04.04 컬럼변경. 20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가) 

                                         /* 20200404 변경전
                                         AND    op.division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가) */ 
										 
                                    /*     -- PJ20209642 Lane 수는 View에서 고려되어 있음 
                                         LEFT JOIN (SELECT DISTINCT la.company_id, la.division_id, la.site_id
                                                                  , la.plant_id, la.factory_id, la.item_id
                                                                  , la.operation_id, la.line_id
                                                                  , la.lane_qty  -- 20180928 추가(scm_mst_item_lane_m_sn.lane_qty 값을 scm_mst_item_line_assign_sn.lane_qty 변경하기 위해서 추가함)
                                                    FROM   dbo.scm_mst_item_line_assign_sn la WITH(NOLOCK)
                                                    WHERE  1=1
                                                    AND    la.active_flag = 'Y'
                                                    AND    la.priority    NOT IN ('0', '9') -- 0/9 는 FP에서 사용 안 하는 정보임
                                                    AND    la.month      >= SUBSTRING(@p_plan_name, 1, 6)
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
                                      */
	                                     WHERE  t.month       >= SUBSTRING(@p_plan_name, 1, 6)
                                         --AND    t.division_id  = @p_division_id   -- 20180702 주석처리                                         
                                         GROUP BY op.flow_id, t.division_id, t.plant_id, t.line_id, t.item_id, t.month
                                         HAVING SUM(ISNULL(t.tact_time, 0)) > 0
                                        ) tt
                                  WHERE  1=1 --tt.tact_time <> 0
                                  AND    tt.row_num = 1
                                  GROUP BY tt.eng_scm_site_id, tt.flow_id, tt.division_id, tt.plant_id, tt.item_id
                                ) d
               ON   a.site_id  = d.eng_scm_site_id
               AND  a.route_id = d.flow_id
               AND  b.line_id  = d.line_id
               AND  a.item_id  = d.item_id 
                             
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
		INSERT INTO /* PR_SCP_ENG_EE_PRE_PROC_OP_RES_GROUP_MAP */ th_eng_op_res_group_map_sn
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
             , smtt.tact_time * 1    -- 라인 모델링 비대상일때
                                    AS tact_time
                
             , a.tact_time_uom      AS tact_time_uom 

             -- 20200330 전극 LINE_CAPA 공정 외는 Yield는 전부 1로 처리 : [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - 전극 수율 개선
             , 1                    AS yield

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
               INNER JOIN (SELECT division_id,  plant_site_id + '~***' AS eng_scm_site_id, item_id, operation_id
                              ,   AVG(ISNULL(tact_time,0))  AS tact_time
                              -- 수율 0 또는 NULL은 1로 처리함                                 
                              ,   MIN(CASE WHEN yield <= 0 THEN 1
                                           WHEN yield > 1 THEN 1
                                           ELSE ISNULL(yield, 1)
                                      END) AS yield      
                           FROM #scp_mst_tact_time WITH (NOLOCK) --20180917 수정 (변경전 : FROM scp_mst_tact_time WITH (NOLOCK) )
                           WHERE valid_yn    = 'Y' 
                           --AND   division_id = @p_division_id  -- 20180702 주석처리
                              
                           GROUP BY division_id, plant_site_id, item_id, operation_id                           
                          ) smtt
               ON  a.site_id  = smtt.eng_scm_site_id
               AND a.item_id  = smtt.item_id 
               AND a.route_id LIKE smtt.operation_id + '%'  
                             
        WHERE  a.master_id = @p_master_id
        AND    a.plan_id   = @p_engine_plan_id
        AND    a.descr     = 'CAPA'  -- 라인 모델링 비대상
		-- FP Tact Time 없는 경우 20180703 수정 속도문제로 NOT EXISTS 로 변경함
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
                                   AND    descr     = 'CAPA'  -- 라인 모델링 비대상
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
		INSERT INTO /* PR_SCP_ENG_EE_PRE_PROC_OP_RES_GROUP_MAP */ th_eng_op_res_group_map_sn
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
        SELECT DISTINCT  --20180705 추가
               a.master_id
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
               INNER JOIN ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group(attribute3) )
                           SELECT a.division_id,  a.plant_site_id + '~***' AS eng_scm_site_id, a.item_id
                                , ROUND((24 * 60 * 60) / AVG(CONVERT(FLOAT, a.daily_capa_qty)), 6) AS tact_time
                           FROM   scp_mst_outsourcing_capa  a WITH (NOLOCK)
                                , scm_mst_division         di WITH(NOLOCK)
                           WHERE  di.division_id    =  a.division_id
                           AND    di.valid_yn       = 'Y'
                           AND    di.attribute3 IN ( '40', '81', '82')  --2022.04.04 컬럼변경. 20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가) 
                           AND    di.attribute4     = @v_division_comp  --같은회사 검색
                           AND   a.valid_yn         = 'Y' 
                           AND   a.daily_capa_qty   > 0
                           GROUP BY a.division_id, a.plant_site_id, a.item_id   

                            /* 20220404 변경전 
                           FROM scp_mst_outsourcing_capa WITH (NOLOCK)
                           WHERE valid_yn       = 'Y' 
                           AND   daily_capa_qty > 0
                           --AND   division_id    = @p_division_id -- 20180705 주석처리
                           AND   division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)     
                           GROUP BY a.division_id, a.plant_site_id, a.item_id       */             
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
             , smtt.tact_time * ISNULL(smtt.yield, a.yield) AS tact_time

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
               INNER JOIN ( SELECT a.division_id, plant_site_id + '~***' AS eng_scm_site_id, item_id, operation_id, line_id
                              ,   priority -- 20191021 Line 우선 순위 적용
                              ,   tact_time
                              -- 수율 0 또는 NULL은 1로 처리함                                 
                              ,   (CASE WHEN yield <= 0 THEN 1
                                        WHEN yield > 1 THEN 1
                                        ELSE ISNULL(yield, 1)
                                   END) AS yield      
                           FROM   scp_mst_tact_time_osp  a WITH (NOLOCK)   
                                , scm_mst_division      di WITH(NOLOCK)   -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group(attribute3) )
                           WHERE  di.division_id    =  a.division_id
                           AND    di.valid_yn       = 'Y'
                           AND    di.attribute3    IN ( '40', '81', '82') --2022.04.04 컬럼변경.
                           AND    di.attribute4     = @v_division_comp    --회사코드
                           AND    a.valid_yn        = 'Y'       

                           /* 20220404 변경전 
                           FROM   scp_mst_tact_time_osp WITH (NOLOCK)                                
                           WHERE  division_id IN ( '40', '81', '82')  -- @p_division_id         
                           AND    valid_yn    = 'Y'    */
                           ) smtt
               ON  a.site_id  = smtt.eng_scm_site_id
               AND a.item_id  = smtt.item_id 
               AND b.line_id  = smtt.line_id
               AND a.route_id LIKE smtt.operation_id + '%'

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
		INSERT INTO /* PR_SCP_ENG_EE_PRE_PROC_OP_RES_GROUP_MAP */ th_eng_op_res_group_map_sn
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
             , ISNULL(c.priority, 99) AS alt_priority -- 20191021 Line 우선 순위 적용 : NULL -> ISNULL(c.priority, 99)
             
             -- Capa 대상인 경우만 tact_time 등록 필요 나머지는 0
			 -- Input용 Tact Time은 수율을 곱해서 적용함
             , c.tact_time * ISNULL(y.yield, ISNULL(smtt.yield, a.yield)) AS tact_time  -- 20180405 수정 ISNULL(FP 수율, ISNULL(scp 관리수율), 기본값)), ISNULL(FP tact_time, ISNULL(scp 관리 tact_time), 기본값))  변경함 (변경전 :  , ISNULL(c.tact_time,0) * ISNULL(y.yield, a.yield) AS tact_time )

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
               INNER JOIN        (SELECT CASE WHEN SUBSTRING(op.flow_id, 1, 1) = 'E' THEN t.plant_id + '-E~***'
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
                                       , MIN(t.priority) AS priority -- 20191021 Line 우선 순위 적용
                                 
                                        -- PJ20209642 Lane 수는 View에서 고려되어 있음 
                                       , SUM(ISNULL(t.tact_time, 0)) AS tact_time
                                       , ROW_NUMBER() OVER (PARTITION BY t.plant_id, op.flow_id, t.line_id, t.item_id ORDER BY t.month ) row_num 
                                  /*
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
                                  FROM   #scm_mst_tact_time_sn t WITH(NOLOCK) -- 20180917 수정
                                  INNER JOIN ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group(attribute3) )
                                               SELECT t.* , di.attribute3 AS division_group , di.attribute4 AS division_comp 
                                               FROM   dbo.scm_mst_operation_flow_v    t WITH(NOLOCK)
                                                    , scm_mst_division               di WITH(NOLOCK)
                                               WHERE  di.division_id    =  t.division_id
                                               AND    di.valid_yn       = 'Y'
                                               AND    di.attribute4     =  @v_division_comp   -- 회사코드
                                             ) OP 
                                  /* 20220404 변경전
                                 INNER JOIN dbo.scm_mst_operation_flow_v op WITH(NOLOCK) */ 
                                  ON     t.division_id  = op.division_id
                                  AND    t.company_id   = op.company_id
                                  AND    t.site_id      = op.site_id
                                  AND    t.operation_id = op.operation_id
                                  AND    op.division_group  IN ( '40', '81', '82') --2022.04.04 컬럼변경. 20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)
                                   /* 20220404 변경전
                                  AND    op.division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)  */
								  
                             /*   -- PJ20209642 Lane 수는 View에서 고려되어 있음 
                                  -- Item이 Assign 된 Line 정보 연결
                                  INNER JOIN (SELECT DISTINCT la.company_id, la.division_id, la.site_id
                                                            , la.plant_id, la.factory_id, la.item_id
                                                            , la.operation_id, la.line_id
                                                            , la.lane_qty  -- 20180928 추가(scm_mst_item_lane_m_sn.lane_qty 값을 scm_mst_item_line_assign_sn.lane_qty 변경하기 위해서 추가함)
                                              FROM   dbo.scm_mst_item_line_assign_sn la WITH(NOLOCK)
                                              WHERE  1=1
                                              AND    la.active_flag = 'Y'
                                              AND    la.priority    NOT IN ('0', '9') -- 0/9 는 FP에서 사용 안 하는 정보임
                                              AND    la.month      >= SUBSTRING(@p_plan_name, 1, 6)
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
                                */

	                              WHERE  t.month       >= SUBSTRING(@p_plan_name, 1, 6)
                                  --AND    t.division_id  = @p_division_id  -- 20180702 주석처리
                                  
                                  GROUP BY op.flow_id, t.division_id, t.plant_id, t.line_id, t.item_id, t.month
                                  HAVING SUM(ISNULL(t.tact_time, 0)) > 0
                                 ) c 
               ON   a.site_id    = c.eng_scm_site_id
               AND  a.route_id   = c.flow_id
               AND  b.line_id    = c.line_id
               AND  a.item_id    = c.item_id 
               --AND  c.tact_time <> 0
               AND  c.row_num    = 1

               -- 라인 모델링 대상 : yield
               -- 20181213 HASH 힌트적용
               LEFT HASH JOIN   (SELECT CASE WHEN SUBSTRING(op.flow_id, 1, 1) = 'E' THEN t.plant_id + '-E~***'
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

                                  FROM   ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                                         SELECT t.* , di.attribute3 AS division_group , di.attribute4 AS division_comp 
                                         FROM   dbo.scm_mst_yield_ver_h_v t  WITH (NOLOCK)    -- PJ20209642 변경  scm_mst_yield_sn
                                              , scm_mst_division  di WITH(NOLOCK)
                                         WHERE  di.division_id    =  t.division_id
                                         AND    di.valid_yn       = 'Y'
                                         AND    di.attribute4     = @v_division_comp   -- 같은회사 검색
                                         ) t 
                                       , ( -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                                         select op.* , di.attribute3 AS division_group , di.attribute4 AS division_comp 
                                         from    dbo.scm_mst_operation_flow_v op WITH(NOLOCK)
                                              , scm_mst_division  di WITH(NOLOCK)
                                         WHERE  di.division_id    =  op.division_id
                                         AND    di.valid_yn       = 'Y'
                                         AND    di.attribute4     = @v_division_comp   -- 같은회사 검색
                                         ) op 
	                              WHERE  t.month        = SUBSTRING(@p_plan_name, 1, 6)
                                  AND    t.division_id  = op.division_id
                                  AND    t.company_id   = op.company_id
                                  AND    t.site_id      = op.site_id
                                  AND    t.operation_id = op.operation_id
                                  AND    t.division_group  IN ( '40', '81', '82') --2022.04.04 컬럼변경. 20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)  
                                  AND   op.division_group  IN ( '40', '81', '82') --2022.04.04 컬럼변경. 20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)  
                                  GROUP BY op.flow_id, t.division_id, t.plant_id, t.line_id, t.item_id, t.month

                                  /* 20220404 변경전
                                  FROM   dbo.scm_mst_yield_ver_h_v t WITH (NOLOCK)    -- PJ20209642 변경  scm_mst_yield_sn
                                       , dbo.scm_mst_operation_flow_v op WITH(NOLOCK)
	                              WHERE  t.month        = SUBSTRING(@p_plan_name, 1, 6)
                                  AND    t.division_id  = op.division_id
                                  AND    t.company_id   = op.company_id
                                  AND    t.site_id      = op.site_id
                                  AND    t.operation_id = op.operation_id
                                  --AND    t.division_id  = @p_division_id  -- 20180702 주석처리
                                  AND    t.division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)  
                                  AND    op.division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)  
                                  GROUP BY op.flow_id, t.division_id, t.plant_id, t.line_id, t.item_id, t.month
                                  */
                                 ) y 
               ON   a.site_id  = y.eng_scm_site_id
               AND  a.route_id = y.flow_id
               AND  b.line_id  = y.line_id
               AND  a.item_id  = y.item_id 

               --20180405 추가 SCP 관리 yield 정보
               LEFT JOIN ( SELECT a.division_id, plant_site_id + '~***' AS eng_scm_site_id, item_id, operation_id, line_id
                              --,   tact_time
                              -- 수율 0 또는 NULL은 1로 처리함                                 
                              ,   (CASE WHEN yield <= 0 THEN 1
                                        WHEN yield > 1 THEN 1
                                        ELSE ISNULL(yield, 1)
                                   END) AS yield   

                           FROM scp_mst_tact_time  a WITH (NOLOCK)
                              , scm_mst_division  di WITH(NOLOCK) -- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group )
                           WHERE a.valid_yn = 'Y'                            
                           AND   di.division_id    =  a.division_id
                           AND   di.valid_yn       = 'Y'
                           AND   di.attribute3  IN ( '40', '81', '82')  -- 2022.04.04컬럼변경.--20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)
                           AND   di.attribute4     = @v_division_comp   -- 같은회사 검색
                           
                           /* 20220404 변경전 
                           FROM scp_mst_tact_time WITH (NOLOCK)
                           WHERE valid_yn = 'Y'                            
                           --AND   division_id = @p_division_id  -- 20180702 주석처리
                           AND   division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)  */
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
		INSERT INTO /* PR_SCP_ENG_EE_PRE_PROC_OP_RES_GROUP_MAP */ th_eng_op_res_group_map_sn
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
               
               -- 라인 모델링 대상 : yield
               LEFT OUTER JOIN   (SELECT CASE WHEN SUBSTRING(op.flow_id, 1, 1) = 'E' THEN t.plant_id + '-E~***'
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
                                     
                                  FROM   (-- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group(attribute3) )
                                         SELECT t.* , di.attribute3 AS division_group , di.attribute4 AS division_comp 
                                         FROM   dbo.scm_mst_yield_ver_h_v t WITH(NOLOCK)    -- PJ20209642 변경  scm_mst_yield_sn
                                              , scm_mst_division         di WITH(NOLOCK)
                                         WHERE  di.division_id    =  t.division_id
                                         AND    di.valid_yn       = 'Y'
                                         AND    di.attribute4     = @v_division_comp  -- 회사코드
                                         ) t 
                                       , (-- 2022.04.04 JV사업부 추가: 같은 회사 내 사업부구분 컬럼변경 ( division_id -> division_group(attribute3) )
                                         select op.* , di.attribute3 AS division_group , di.attribute4 AS division_comp 
                                         from    dbo.scm_mst_operation_flow_v op WITH(NOLOCK)
                                              , scm_mst_division              di WITH(NOLOCK)
                                         WHERE  di.division_id    =  op.division_id
                                         AND    di.valid_yn       = 'Y'
                                         AND    di.attribute4     = @v_division_comp  --  회사코드
                                         ) op 
	                              WHERE  t.month        = SUBSTRING(@p_plan_name, 1, 6)
                                  AND    t.division_id  = op.division_id
                                  AND    t.company_id   = op.company_id
                                  AND    t.site_id      = op.site_id
                                  AND    t.operation_id = op.operation_id
                                  AND    t.division_group  IN ( '40', '81', '82')  --2022.04.04 컬럼변경. 20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)  
                                  AND   op.division_group  IN ( '40', '81', '82')  --2022.04.04 컬럼변경. 20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)   
                                  GROUP BY op.flow_id, t.division_id, t.plant_id, t.line_id, t.item_id, t.month
                                  /* 20220404 변경전 
                                  FROM   dbo.scm_mst_yield_ver_h_v t WITH (NOLOCK)    -- PJ20209642 변경  scm_mst_yield_sn
                                       , dbo.scm_mst_operation_flow_v op WITH(NOLOCK)
	                              WHERE  t.month        = SUBSTRING(@p_plan_name, 1, 6)
                                  AND    t.division_id  = op.division_id
                                  AND    t.company_id   = op.company_id
                                  AND    t.site_id      = op.site_id
                                  AND    t.operation_id = op.operation_id
                                  --AND    t.division_id  = @p_division_id  -- 20180702 주석처리
                                  AND    t.division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)  
                                  AND    op.division_id  IN ( '40', '81', '82')  --20190305 전지사업부(소형(40), 자동차(81), ESS(82)) 조건추가(전지재료('44') 사업부추가로 인한 조건추가)   
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
                           FROM #scp_mst_tact_time WITH (NOLOCK) --20180917 수정 (변경전 : FROM scp_mst_tact_time WITH (NOLOCK) )
                           WHERE valid_yn = 'Y'                            
                           --AND   division_id = @p_division_id  -- 20180702 주석처리
                           
                           ) smtt
               ON  a.site_id  = smtt.eng_scm_site_id
               AND a.item_id  = smtt.item_id 
               AND b.line_id  = smtt.line_id
               AND a.route_id LIKE smtt.operation_id + '%'

        WHERE  a.master_id = @p_master_id
        AND    a.plan_id   = @p_engine_plan_id
        AND    a.descr     = 'LINE_CAPA' -- 라인 모델링 대상
		
        -- FP Tact Time 없는 경우 20180703 수정 속도문제로 NOT EXISTS 로 변경함
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

        -----------------------------------------------------------
        -- 임시테이블 삭제
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#scm_mst_tact_time_sn') IS NOT NULL
        BEGIN
            DROP TABLE #scm_mst_tact_time_sn
        END

        IF OBJECT_ID('tempdb..#scp_mst_tact_time') IS NOT NULL
        BEGIN
            DROP TABLE #scp_mst_tact_time
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

