PROCEDURE         "PR_SSP_ANL_SHIP_PLAN_40"
( P_DIVISION_ID    IN VARCHAR2
, P_COMPANY_ID     IN VARCHAR2
)
/**=========================================================================================================================================================
 * Program ID   : PR_SSP_ANL_SHIP_PLAN_40
 * Description  : 소형사업부 재고 PSI 정보 생성
 * OutTable     :
 * Execute      : batch job JOB.SCMPROD_PLAN_SUPPLY_40_Creation 에서 호출
 * Program History
 *=========================================================================================================================================================
 *   Date       In Charge      Description
 *=========================================================================================================================================================
    <MEASURE>
    [S]SHIP_REQ(Shipment Request)    : MKT 담당자가 출하요청한 수량
    [S]SHIP_CONFIRM(Shipment Confirm): 출하 확정 수량
    [S]POSTP_PLAN(Post Process Plan) : 활성화 후 공정에서 필요로 Barecell 소요량(남경)
    [P]WH_IN(WH in Plan)             : 제품 창고 인계 계획,Production과 동일(사용자 수정 가능)
    [P]PROD_PLAN(Production)         : 조립실적+계획(활성화 L/T, 수율 적용)
    [P]PROD_DATE(Production Date)    : 조립완료일(실적완료일)
    [P]LOT(Lot)                      : SUBSTRIN(LOT_ID, 4,4)
    [P]INCO_WIP(Incomming WIP)       : 활성화 Aging 후 일자별 특성검사 가능재고로 넘어 올 수량(Remain Lead Time 기준 향후 특성검사가능 재고)
    [P]INSP_WIP(Inspection WIP)      : 특성 검사 가능 재고  당일 Inspection WIP : 전일 Inspection WIP + 당일 Incomming WIP - 전일 WH in Plan
    [I]MES_FCS_HOLD(Hold Stock)      : MES/FCS 재고중 출하불가 LOT수량(LOT_ID날짜에 L/T 고려)
    [I]MES_FCS_RELEASE(Release Stock): MES/FCS 재고중 출하불가 LOT수량에 대해 사용자가 지정된 Release 일자의 LOT수량
    [I]WH_STOC(Warehouse Stock)      : 당일 WH_STOC = OWMS 가용수량 , 익일 WH_STOC = 전일 WH_STOC + 전일WH_IN - 전일SHIP_CONFIRM - 전일POSTP_PLAN - 전일 HOLD수량 + 전일 RELEASE수량
    [I]BALANCE(Balance)              : 당일 Balance :  당일Warehouse Stock - 당일 Shipment Confirm -당일 POSTP_PLAN
 *=========================================================================================================================================================
 * 2019.04.09   juhlee         Initial Release [PJ20189106} 전지.GSCM 고도화 이행 PROJECT
                               소형 출하PSI 화면용 DATA생성
 * 2019.04.19   juhlee         PROD_PLAN 공정추가 [PJ20189106} 전지.GSCM 고도화 이행 PROJECT
                                PROD_PLAN F로 시작되는 공정(TCO Cell) 은 ADD L/T만 반영  (TCO Cell)
                               SSP_ANL_FORMATION_C 생성시 적용
 * 2019.04.19   juhlee         INSP_WIP 계산시 TCO 모델은 WH_IN과 관계없이 전부 0으로 SETTING
 * 2019.05.10   juhlee         출하계획생성기간 변경 기존 8주(56일) --> 12주(84일)  : @v_data_end_yyyymmdd
 * 2019.05.13   juhlee         PROD_PLAN 생성시 MY MODEL등록건은 생산계획이 없더라도 계획생성되게 추가(Requested by 김광희책임)
 * 2019.05.14   juhlee         SSP_ANL_SHIP_REQ 생성 시 이전에 요청한 데이터 있으면 같이 생성함(소형 출하요청 2달 입력 기능)
 * 2019.05.15   juhlee         활성화 후 공정에서 필요로 하는 Bare Cell에 대한 Measure 생성
                                해당 Bare Cell 수량을 재고에서 제외 , Balance에서도 제외
    [S]POSTP_PLAN(Post Process Plan) : 활성화 후 공정에서 필요로 Barecell 소요량
    [I]WH_STOC(Warehouse Stock)      : 당일 WH_STOC = OWMS 가용수량 , 익일 WH_STOC = 전일 WH_STOC + 전일WH_IN - 전일SHIP_CONFIRM  - 전일Barecell수량(POSTP_PLAN)
    [I]BALANCE(Balance)              : 당일 Balance :  당일Warehouse Stock - 당일 Shipment Confirm - 당일Barecell수량(POSTP_PLAN)
 * 2019.05.16   juhlee         WH_STOCK에 storage B100(TCO Ass.BS D/F), R100(TCO Ass.SW D/F) 재고 수량 적용 (<--SSP_ANL_TCO_STOCK_C)
                                BOH적용시 기존 OWMS 재고와 SSP_ANL_TCO_STOCK_C 추가 적용
                               SSP_ANL_OWMS_STOCK_C를 SSP_ANL_WH_STOCK_V(SSP_ANL_OWMS_STOCK_C + SSP_ANL_TCO_STOCK_C )로 적용
 * 2019.05.17   juhlee         [P]PROD_PLAN(Production) 에 CNJ Pouch 특성실적 반영 (2019.05.17)
                                실적일 (D-2,D-1)을 계획일(D, D+1)에 반영 , 해당 공정의 실적이 있을 경우 조립실적에서는 제외함 영
                               대상 공정 F5500 : Grading/Charateristic (Pouch), F5600 : Offline Charateristic Measurement (Pouch)
                               ex) 5/15실적 --> 5/17일 계획
 * 2019.05.20   juhlee         OWMS 가용재고 로직 수정:G182(남경)의 경우 BLOCK_QTY(HOLD)재고만 제외 함
 * 2019.05.22   hwyoon         SSP_ANL_TCO_STOCK_C 입력 시 SCM_SITE_ID가 null인 Model은 제외
 * 2019.05.27   ayj            [CSR ID:4000602] [요청]외부생산, 장기재고의 출하가능재고 인식 및 가시화(20190516, 20190520 수정 내용)
 * 2019.05.28   juhlee         [P]PROD_PLAN(Production) 에 CNJ Pouch 특성계획 반영 (2019.05.28)
                                대상 공정 F5500 : Grading/Charateristic (Pouch), F5600 : Offline Charateristic Measurement (Pouch)
                               단, 조립계획과 중복시 조립계획은 제외하고 Pouch 특성계획을 우선으로 함(ITEM기준)
 * 2019.05.30   juhlee         CNJ Pouch 공정 추가 F5400 : Grading (Pouch) (requested by 김광희책임)
 * 2019.06.27   juhlee         [P]INCO_WIP(Incomming WIP)에 조립계획(SCM_DNM_PLAN_FROZEN_V)  CNJ Pouch 특성계획 반영[CSR ID:4027867]
                                 대상 공정 F5400, F5500, F5600 <-- 해당공정의 계획이 우선함 (L/T 2일 적용)
 * 2019.08.13   juhlee         [P]PROD_PLAN(Production)변경, 조립실적일자를 실적완료일이 아닌 MES LOT실적으로 LOTID의 일자 기준으로 적용[CSR ID:4045693]
                               [P]LOT(Lot) Measure 추가(attribute1에 lot정보추가) [CSR ID:4045693]
                                적용된 수량에서 OWMS재고중 해당 LOT(일자,PROD_DATE)에 대한 재고 수량를 차감[CSR ID:4045697]
 * 2019.08.26   juhlee         이전 AGING L/T(LT_FORMATION + ATTRIBUTE1)과 다른 경우 이전 L/T 정보를 SP_ANL_FORMATION_C.ATTRIBUTE2에 UPDATE
 * 2019.09.17   juhlee         [P]PROD_PLAN(Production)변경: MES lot실적적용을 A3000번 공정만 적용하는것으로 수정 (request by 김광희)
 * 2019.10.23   juhlee         FP생산계획 view 변경 SCM_DNM_PLAN_FROZEN_V --> SSP_DNM_PLAN_FROZEN_V (FP SSP용 Plan확정 사용)
 * 2019.11.04   juhlee         MES 재고 정보 적용, Measure 추가 [PJ20189106] 전지.GSCM 고도화 이행
 * 2019.12.05   juhlee         [C20191205-000173] 소형 초소형 모델의 출하 가능량 산출을 위한 PSI 개선 요청
                                (2-13) [S]POSTP_PLAN (Post Process Plan) 조정(예외) : MCSS20253-A2 -> MCSS20253-A4로 투입되므로 재고 차감을 위해POSTP_PLAN으로 적용
                               MCSS20253-A4 의 PROD_PLAN 수량을 MCSS20253-A2 의 PPOST_PLAN 수량으로 적용
 * 2020.01.06   juhlee         [C20200107-000219]
                                (1-6) 재고 Cutoff 변경
                                기존  :  MES STOCK Cutoff생성:SCM_DNM_STOCK_V  --> SSP_ANL_MES_STOCK_C (1-2삭제)
                                 추가  :  MES STOCK Cutoff생성:SSP_DNM_GMES_STOCK_40    --> SSP_ANL_MES_FCS_STOCK_40_C
                               (2-5-1) [I]MES_FCS_HOLD(Hold Stock)  메져 추가 (수율적용수량)
                               (2-5-2) [I]MES_FCS_RELEASE(Release Stock) 메져 추가(수율적용수량) ( <--SSP_ANL_MES_FCS_STOCK_40_C)
                                (2-14)  [I]WH_STOC(Warehouse Stock) 메저 산술식 변경 :전일 [I]MES_FCS_HOLD(Hold Stock) 차감, 전일 [I]MES_FCS_RELEASE(Release Stock) 추가
 * 2020.02.04   juhlee         [C20200115-000418] :오창(A010-A) Production type = MASS 수량을 WH_IN수량에 적용
                                - [C20200115-000418]-1 : Production Type별(MASS / 전체) 수량 추출
                                - [C20200115-000418]-2 : Prod Qty(MASS)와 Prod Qty(MASS)가 다를 경우 Memo 추가 표시, 오창(A010-A)만 적용
                                - [C20200115-000418]-3 : WH_IN수량에 Prodcution_type이 MASS 수량 반영 , 오창(A010-A)만 적용
                               (기존) : Production type 전체 대상 - oWMS 재고 수량
                               (변경) : 오창의 경우 Prodcution type = 'MASS'인 수량 - oWMS 재고 수량
                                       해당 내용 적용을 위해 [P]PROD_PLAN(Production) 메저에 ATTRIBUTE4,5,6 컬럼 사용
                                       - ATTRIBUTE4 : PRODUCTION_TYPE= MASS QTY
                                       - ATTRIBUTE5 : PRODUCTION_TYPE= 전체 QTY
                                       - ATTRIBUTE6 : OWMS 재고수량(SSP_ANL_OWMS_STOCK_C)
                                       - ATTRIBUTE3 : oWMS 재고수량 or (전체 Prod Qty와 MASS Prod Qty가 다를 경우) 화면 상에 메모 표시를 위해 사용
                                           ex) MASS Prod Qty : xxx , oWMS Qty : xxxx
 * 2020.02.18   juhlee         [C20200218-000100]:oWMS cutoff재고 법인별 시업시간으로 생성(기존 PLAN수행시 최신 oWMS 재고)
                                 - AO10(오창)     : oWMS 06시 생성 재고
                                 - G182(남경,CNJ) : oWMS 09시 생성 재고
                                * 기존: 최신 oWMS재고(SSP_ANL_OWMS_STOCK)
                                * 변경: I/F시점 데이터(XIF_OWMS_STOCK_R_SN)
 * 2020.03.18   KIMYONGHO      [C20200303-000163] LONGTERM_HOLD_YN 컬럼 추가
 * 2020.05.07   KIMYONGHO      [C20200407-000144] PSI - Aging L/T Alarm 기간 변경 요청건
 * 2020.06.08   KIMYONGHO      [C20200601-000370] oWMS - SSP 재고 I/F 주기 수정 요청
 * 2020.09.21   KIM BOK KI     INCOTERMS COLUMN 변경(INCOTERMS -> SSP_INCOTERMS)
 * 2020.09.22   KIM BOK KI     ISNULL(A.CHANGE_STATUS, '') <> 'D' 추가
 * 2020.10.13   KIM BOK KI     INCO_WIP / MES_FCS_HOLD / MES_FCS_RELEASE 생성로직 변경
                               POUCH_WH_ID_DAY LOOKUP 생성 신규추가
 * 2020.10.16   KIM BOK KI     COMPANY 별 수행(C100 대상 외)
 * 2020.11.10   KIM BOK KI     40 Daily Rolling 을 위한 로직변경
 * 2021.01.05   kimbk          Lookup 'LOT_ID_YEAR' 조회 조건 변경
 * 2021.01.13   kimbk          MEASURE 'SHIP_CONFIRM' 데이터 생성 시 확정구간 이후 데이터에 대해 'SHIP_PLAN' 정보를 추가
 * 2021.01.19   KIM BOK KI     MES & OWMS 재고 정보 체크로직 추가 (I/F 재고 정보미 존재 시 수행하지 않음)
 * 2021.01.26   KIM BOK KI     SHIP_CONFIRM 생성 로직 보안
 * 2021.02.26   KIM BOK KI     실행 파라메터 COMPANY_ID 추가
 * 2021.03.10   KIM BOK KI     I/F 재고 정보 체크 로직 추가
 * 2021.07.27   SSP Pjt        SSP_ANL_MES_FCS_STOCK_40_C.attribute4 불량수량 적용
 * 2021.09.01   SSP Pjt.       SCP_MST_BOD_N_V 적용
 * 2022.02.16   SSP Pjt.       SCM_DNM_STOCK_V -> SSP_DNM_STOCK_C
                               2-4에 OPTION (RECOMPILE) 적용(parameter sniffing 방지)
                               SCM_DNM_STOCK_AGING_V -> #tmp_SCM_DNM_STOCK_AGING_V
                               SSP_DNM_MES_STOCK_40 -> SSP_DNM_GMES_STOCK_40
 * 2022.09.01   SSP Pjt.       소형 모듈 비즈 적용 (FP실적: P5000, FP계획: P5500)
 * 2023.08.30   jilee          반제품->제품코드 변환 작업
 * 2024.10.01   KHJ            NERP_SSP
 * 2025/08/18   chkim.68       [E20250821-001308] -- to_company_id를 from_site에 따라 to_company_id가 다르게 적용되는 예외를 적용 (scm_site_company_exception)
                            FN_GET_SSP_SITE_INFO -> [FN_GET_SSP_SITE_INFO_EXCEPTION]
 * 2026.07.06   ZIONEX         [PJ202650304] NextSCM Migration
 *---------------------------------------------------------------------------------------------------------------------------------------------------------
 *  - PR_SCP_SYS_LOG_BATCH(7 인자) 로깅 유지. CATCH 흡수(THROW 없음) -> EXCEPTION WHEN OTHERS + ROLLBACK + 에러로그 + RETURN(RAISE 없음).
 *  - BEGIN TRAN TX_SH / COMMIT / ROLLBACK -> flat TX. @@TRANCOUNT>0 -> DBMS_TRANSACTION.LOCAL_TRANSACTION_ID IS NOT NULL.
 *  - naked SELECT 미소비(배치): OUT 커서 미추가.  SCM_ADM_SMS_SEND_BATCH 유지(에러경로).
 *=========================================================================================================================================================
*/
AS
    /* LOG 용 변수 설정 */
    V_BATCH_USER            VARCHAR2(150 CHAR) := 'ssp_batch';
    V_PROGRAM_NAME          VARCHAR2(150 CHAR) := 'PR_SSP_ANL_SHIP_PLAN_40';
    V_LOG_TYPE              VARCHAR2(30 CHAR);           /* START/END/ERROR/... */
    N_LOG_COUNT             INTEGER := 0;
    V_LOG_MESSAGE           VARCHAR2(1000 CHAR);
    V_DESCRIPTION           VARCHAR2(500 CHAR);          /* ▶ 상세설명 */
    V_TABLE_ID              VARCHAR2(150 CHAR) := 'SSP_ANL_SHIP_PLAN_40';  /* ▶ 테이블 필수 */
    D_EVENT_DATE            DATE;

    /* NERP 매핑코드 */
    V_G182                  VARCHAR2(20 CHAR);
    V_A010A                 VARCHAR2(20 CHAR);
    V_G182A                 VARCHAR2(20 CHAR);

    /* 임시 실행시간 확인용 */
    V_START_TIME            DATE := SYSDATE;
    V_EXEC_TIME             VARCHAR2(10 CHAR) := '';
    V_TOTAL_SEC             NUMBER;
    V_SMS_DESC              VARCHAR2(4000 CHAR);
    V_SMS_REQ               VARCHAR2(10 CHAR) := '';

    V_COMPANY_ID            VARCHAR2(30 CHAR) := '';
    V_PLAN_START_YYYYMMDD   VARCHAR2(8 CHAR) := '';
    V_DIVISION_ID           VARCHAR2(30 CHAR) := '';
    V_PLAN_TYPE             VARCHAR2(30 CHAR) := 'SP';
    V_SEQ                   INTEGER := 1;

    /* DATA 생성 시작/마지막/CUTOFF 일자 */
    V_DATA_START_YYYYMMDD   VARCHAR2(8 CHAR) := '';
    V_DATA_END_YYYYMMDD     VARCHAR2(8 CHAR) := '';
    V_DATA_CUTOFF_YYYYMMDD  VARCHAR2(8 CHAR) := '';

    V_PLAN_ID               VARCHAR2(4000 CHAR);
    V_OWMS_COUNT            INTEGER := 0;
    V_OWMS_IF_COUNT         INTEGER := 0;      /* [C20200601-000370] OWMS I/F 수신 여부 체크 */
    V_TCO_COUNT             INTEGER := 0;
    V_STOCK_CNT             INTEGER := 0;
    V_PLAN_CNT              INTEGER := 0;
    V_CNT                   INTEGER := 0;

    V_LAST_PLAN_START_YYYYMMDD  VARCHAR2(8 CHAR) := '';
    V_LAST_PLAN_TYPE        VARCHAR2(30 CHAR) := 'SP';
    V_LAST_SEQ              INTEGER := 1;


    V_X_INT                 INTEGER := 1;
    V_X_MEASURE             VARCHAR2(100 CHAR);

    V_ERR_MSG               VARCHAR2(1000 CHAR);
BEGIN
    /* [E20261126-DS2] GTT(통계 없음) 행 수 추정용. 클라우드 optimizer_dynamic_sampling = 0 (2026-11-26 확인) */
    EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';


    V_COMPANY_ID          := P_COMPANY_ID;
    V_DIVISION_ID         := P_DIVISION_ID;
    V_PLAN_START_YYYYMMDD := TO_CHAR(SYSDATE, 'YYYYMMDD');                                   /* CONVERT(char(8), GETDATE(), 112) */
    V_DATA_START_YYYYMMDD := TO_CHAR(SYSDATE - 1, 'YYYYMMDD');                               /* CONVERT(char(8), DATEADD(DD,-1,GETDATE()),112) */
    V_DATA_END_YYYYMMDD   := TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 84, 'YYYYMMDD'); /* 12주(84일) */
    V_DATA_CUTOFF_YYYYMMDD := V_DATA_START_YYYYMMDD;

    /* NERP 매핑코드 */
    V_G182  := FN_GET_LOOKUP_VALUE('PR_SSP_ANL_SHIP_PLAN_40', 'G182');
    V_A010A := FN_GET_LOOKUP_VALUE('PR_SSP_ANL_SHIP_PLAN_40', 'A010A');
    V_G182A := FN_GET_LOOKUP_VALUE('PR_SSP_ANL_SHIP_PLAN_40', 'G182A');

    SELECT COUNT(*)
      INTO V_PLAN_CNT
      FROM SSP_ANL_SHIP_PLAN_40
     WHERE 1 = 1
       AND DIVISION_ID         = V_DIVISION_ID
       AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
       AND MEASURE             = 'SHIP_CONFIRM'
       AND ATTRIBUTE10         = V_COMPANY_ID
    ;

    SELECT CASE WHEN A.TOT_CNT <> B.PASS_CNT THEN 1 ELSE 0 END
      INTO V_STOCK_CNT
      FROM (
            SELECT COUNT(*)  AS TOT_CNT
              FROM SCM_ADM_LOOKUP_MASTER_DETAIL
             WHERE 1 = 1
               AND LOOKUP_TYPE = 'IF_STOCK_CHECK'
               AND VALID_YN    = 'Y'
               AND SEGMENT1    = 'PLAN_40'
               AND SEGMENT3    = '40'
               AND SEGMENT4    = V_COMPANY_ID
           ) A
           LEFT OUTER JOIN
           (
            SELECT COUNT(*)  AS PASS_CNT
              FROM SCM_ADM_LOOKUP_MASTER_DETAIL
             WHERE 1 = 1
               AND LOOKUP_TYPE = 'IF_STOCK_CHECK'
               AND VALID_YN    = 'Y'
               AND SEGMENT1    = 'PLAN_40'
               AND SEGMENT3    = '40'
               AND SEGMENT4    = V_COMPANY_ID
               AND SEGMENT5    = TO_CHAR(SYSDATE, 'YYYYMMDD')
               AND ATTRIBUTE1  = 'Y'
           ) B
        ON 1 = 1
    ;

    IF V_PLAN_CNT > 0 OR V_STOCK_CNT > 0 THEN
        RETURN;
    END IF;

    /* 시작 LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' SHIP_PLAN INSERT LOGIC';
    D_EVENT_DATE  := SYSDATE;
    PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                        , P_LOG_TYPE     => V_LOG_TYPE
                        , P_LOG_COUNT    => N_LOG_COUNT
                        , P_LOG_MESSAGE  => V_LOG_MESSAGE
                        , P_DESCRIPTION  => V_DESCRIPTION
                        , P_EVENT_DATE   => D_EVENT_DATE
                        , P_USER_ID      => V_BATCH_USER
                        );

    /* BEGIN TRY (Oracle: EXCEPTION 블록으로 대체) */
    BEGIN
        /* ----------------------------------------------------------------------------------------------------------- */
        /* PLAN Start status Plan Detail Insert */
        /* ----------------------------------------------------------------------------------------------------------- */
        /* MSSQL: SELECT @v_plan_id = P.PLAN_ID (0행이면 NULL 유지) -> Oracle NO_DATA_FOUND 회피 위해 MAX() */
        SELECT MAX(P.PLAN_ID)
          INTO V_PLAN_ID
          FROM SCM_MST_PLAN P
         WHERE P.DIVISION_ID = V_DIVISION_ID
           AND P.PLAN_CYCLE  = 'DAILY'
           AND P.PLAN_NAME   = V_PLAN_START_YYYYMMDD
        ;

        SELECT COUNT(DIVISION_ID)
          INTO V_CNT
          FROM SCM_MST_PLAN_DETAIL A
         WHERE MODELING_ID = '101'
           AND DIVISION_ID = V_DIVISION_ID
           AND PLAN_ID     = V_PLAN_ID
           AND PLAN_SEQ    = V_SEQ
           AND PLAN_TYPE   = V_PLAN_TYPE
        ;

        IF V_CNT = 0 THEN
            INSERT INTO SCM_MST_PLAN_DETAIL (
                 MODELING_ID, DIVISION_ID, PLAN_ID, PLAN_SEQ, PLAN_TYPE
                ,INPUT_START_DATE, INPUT_END_DATE, PLAN_START_DATE, PLAN_END_DATE, PLAN_OUTPUT_END_DATE
                ,OUTPUT_START_DATE, OUTPUT_END_DATE, ANL_START_DATE, ANL_END_DATE, PLAN_STATUS
                ,RUN_TYPE, PLAN_TYPE_DESCRIPTION, BASE_SEQ, DISPLAY_YN, UI_DISPLAY_YN
                ,NORMAL_COMPLETE_YN, CONFIRM_FLAG, CONFIRM_USER, CONFIRM_DATE, ACTIVE_FLAG
                ,CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY
                )
            VALUES (
                 '101', V_DIVISION_ID, V_PLAN_ID, V_SEQ, V_PLAN_TYPE
                ,V_START_TIME, NULL, V_START_TIME, NULL, NULL
                ,V_START_TIME, NULL, V_START_TIME, NULL, 0            /* PLAN_STATUS 0:진행 , 1:완료, -1:에러 */
                ,'PROD', NULL, 1, 'Y', 'Y'
                ,'Y', 'Y', V_BATCH_USER, SYSDATE, 'Y'
                ,SYSDATE, V_BATCH_USER, SYSDATE, V_BATCH_USER
                );
        END IF;

        /* 이전 VESION PLAN 정보 추출 */
        SELECT MAX(PLAN_START_YYYYMMDD)
             , MAX(PLAN_SEQ)
             , MAX(PLAN_TYPE)
          INTO V_LAST_PLAN_START_YYYYMMDD
             , V_LAST_SEQ
             , V_LAST_PLAN_TYPE
          FROM SSP_PLAN_VERSION_V
         WHERE PLAN_TYPE    = 'SP'
           AND DIVISION_ID  = V_DIVISION_ID
           AND CONFIRM_FLAG = 'Y'
           AND PLAN_START_YYYYMMDD = ( SELECT MAX(PLAN_START_YYYYMMDD)
                                         FROM SSP_PLAN_VERSION_V T
                                        WHERE T.DIVISION_ID  = V_DIVISION_ID
                                          AND T.PLAN_TYPE    = 'SP'
                                          AND T.CONFIRM_FLAG = 'Y'
                                          AND T.PLAN_START_YYYYMMDD < V_PLAN_START_YYYYMMDD
                                     )
        ;


        /* 2020.08.19 현업 요청에 의한 LOOKUP DETAIL 정보 생성 (요청자 : 김광희 책임) */
        /* CELL 출하대상에 없는 SCP 출하계획이 있는 경우 전극출하대상 LOOKUP에 자동 신규 추가 함 */
        /* 단, SALES_COMPANY_ID(3자거래 대상)는 PI담당자가 추가 입력해야 해서 제외 함(시스템판단로직 불가) */
        /* VALID_YN N으로 설정된값은 추가 대상이 아님(VALID_YN 관계없이 비교하여 없으면 신규생성함) */
        INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
            ( LOOKUP_TYPE
            , SEGMENT1     /* FROM_COMPANY_ID */
            , SEGMENT2     /* FROM_DIVISION_ID */
            , SEGMENT3     /* FROM_SITE */
            , SEGMENT4     /* TO_COMPANY_ID */
            , SEGMENT5     /* TO_SITE */
            , ATTRIBUTE1   /* TO_DIVISION_ID */
            , DISPLAY_SEQ
            , VALID_YN
            , DESCRIPTION
            , CREATED_BY
            , CREATION_DATE
            , LAST_UPDATED_BY
            , LAST_UPDATE_DATE
            )
        SELECT A.LOOKUP_TYPE
             , A.FROM_COMPANY_ID
             , A.FROM_DIVISION_ID
             , A.FROM_SITE
             , A.TO_COMPANY_ID
             , A.TO_SITE
             , A.TO_DIVISION_ID
             , 10   AS DISPLAY_SEQ
             , 'Y'  AS VALID_YN
             , 'System Auto Create'   AS DESCRIPTION
             , 'ssp_batch'      AS CREATED_BY
             , SYSDATE          AS CREATION_DATE
             , 'ssp_batch'      AS LAST_UPDATED_BY
             , SYSDATE          AS LAST_UPDATE_DATE
          FROM (
                SELECT DISTINCT
                       'CELL_SHIP_FROM_TO' AS LOOKUP_TYPE
                ,      FN_GET_SSP_SITE_INFO(F.DIVISION_ID, A.FROM_SITE, 'COMPANY_ID')  AS FROM_COMPANY_ID
                ,      F.DIVISION_ID    AS FROM_DIVISION_ID
                ,      A.FROM_SITE      AS FROM_SITE
                ,      FN_GET_SSP_SITE_INFO_EXCEPTION(T.DIVISION_ID, A.FROM_SITE, A.TO_SITE, 'COMPANY_ID')  AS TO_COMPANY_ID /* [E20250821-001308] */
                ,      T.DIVISION_ID    AS TO_DIVISION_ID
                ,      A.TO_SITE        AS TO_SITE
                  FROM SCP_ANL_SHIPMENT_PLAN_SEMI A
                       JOIN SCM_MST_SITE  F
                    ON F.SITE_TYPE        = 'PLANT'
                   AND F.VALID_YN         = 'Y'
                   AND F.OPERATION_GROUP  = 'A'
                   AND F.DIVISION_ID      = A.ORIGIN_FROM_DIVISION_ID
                   AND F.SCM_SITE_ID      = A.FROM_SITE
                       JOIN SCM_MST_SITE  T
                    ON T.VALID_YN         = 'Y'
                   AND T.OPERATION_GROUP  = 'P'
                   AND T.DIVISION_ID      = A.ORIGIN_TO_DIVISION_ID
                   AND T.SCM_SITE_ID      = A.TO_SITE
                 WHERE 1 = 1
                   AND A.DIVISION_ID = V_DIVISION_ID
                   AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                   AND A.MEASURE = 'SHIP_PLAN'
                   AND A.OPERATION_GROUP = 'A'
                   AND A.TO_SITE <> '-'
                   AND A.QTY > 0
               ) A
         WHERE 1 = 1
           AND A.TO_COMPANY_ID IS NOT NULL
           AND A.FROM_COMPANY_ID <> A.TO_COMPANY_ID
           AND NOT EXISTS (
                           SELECT 1   /* 전극출하대상 */
                             FROM SCM_ADM_LOOKUP_MASTER_DETAIL L
                            WHERE 1 = 1
                              AND L.LOOKUP_TYPE = 'CELL_SHIP_FROM_TO'
                              AND L.SEGMENT1    = A.FROM_COMPANY_ID
                              AND L.SEGMENT2    = A.FROM_DIVISION_ID
                              AND L.SEGMENT3    = A.FROM_SITE
                              AND L.SEGMENT4    = A.TO_COMPANY_ID
                              AND L.SEGMENT5    = A.TO_SITE
                              AND L.ATTRIBUTE1  = A.TO_DIVISION_ID
                          )
        ;

        /* 2020.09.28  현업 요구사항으로 LOGIC 추가 (Pouch Item Group 별 WH_IN 합산 일수 관리) */
        INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
            ( LOOKUP_TYPE
            , SEGMENT1     /* CELL_TYPE */
            , SEGMENT2     /* OPERATION_ID */
            , SEGMENT3
            , SEGMENT4
            , SEGMENT5
            , DISPLAY_SEQ
            , VALID_YN
            , DESCRIPTION
            , CREATED_BY
            , CREATION_DATE
            , LAST_UPDATED_BY
            , LAST_UPDATE_DATE
            )
        SELECT 'POUCH_WH_IN_DAY'       AS LOOKUP_TYPE
             , SUBSTR(A.ITEM_ID, 1, 3) AS SEGMENT1 /* POUCH_ITEM_GROUP */
             , CASE WHEN (SUBSTR(A.ITEM_ID, 1, 3) = 'MDP' OR SUBSTR(A.ITEM_ID, 1, 3) = 'MIP' OR SUBSTR(A.ITEM_ID, 1, 3) = 'MTP') THEN '3'
               ELSE '2' END            AS SEGMENT2  /* WH_IN_DAY */
             , '-'   AS SEGMENT3
             , '-'   AS SEGMENT4
             , '-'   AS SEGMENT5
             , 10    AS DISPLAY_SEQ
             , 'Y'   AS VALID_YN
             , 'System Auto Create'   AS DESCRIPTION
             , 'System'
             , SYSDATE        AS CREATION_DATE
             , 'System'
             , SYSDATE        AS LAST_UPDATE_DATE
          FROM (
                SELECT DISTINCT
                       A.DIVISION_ID
                ,      A.ITEM_ID
                  FROM SCP_ANL_SHIPMENT_PLAN_SEMI A
                       JOIN SCM_MST_SITE  F
                    ON F.SITE_TYPE        = 'PLANT'
                   AND F.VALID_YN         = 'Y'
                   AND F.OPERATION_GROUP  = 'A'
                   AND F.DIVISION_ID      = A.ORIGIN_FROM_DIVISION_ID
                   AND F.SCM_SITE_ID      = A.FROM_SITE
                       JOIN SCM_MST_SITE  T
                    ON T.VALID_YN         = 'Y'
                   AND T.OPERATION_GROUP  = 'P'
                   AND T.DIVISION_ID      = A.ORIGIN_TO_DIVISION_ID
                   AND T.SCM_SITE_ID      = A.TO_SITE
                 WHERE 1 = 1
                   AND A.DIVISION_ID = V_DIVISION_ID
                   AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                   AND A.MEASURE = 'SHIP_PLAN'
                   AND A.TO_SITE <> '-'
                   AND A.QTY > 0
                 GROUP BY A.DIVISION_ID, A.ITEM_ID
               ) A
               LEFT OUTER JOIN SCP_MST_FINAL_ITEM  C
            ON C.DIVISION_ID = A.DIVISION_ID
           AND C.ITEM_ID = A.ITEM_ID
               JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D
            ON D.SEGMENT3 = 'P'
           AND D.LOOKUP_TYPE = 'CELL_TYPE_CODE'
           AND D.VALID_YN    = 'Y'
           AND D.SEGMENT1    = C.CELL_TYPE_GROUP_CODE
         WHERE 1 = 1
           AND NOT EXISTS (
                           SELECT 1
                             FROM SCM_ADM_LOOKUP_MASTER_DETAIL  B
                            WHERE 1 = 1
                              AND B.LOOKUP_TYPE = 'POUCH_WH_IN_DAY'
                              AND B.VALID_YN    = 'Y'
                              AND B.SEGMENT1    = SUBSTR(A.ITEM_ID, 1, 3)
                              AND B.SEGMENT3    = '-'
                              AND B.SEGMENT4    = '-'
                              AND B.SEGMENT5    = '-'
                          )
         GROUP BY SUBSTR(A.ITEM_ID, 1, 3)
        ;

        /* 수행시간이 짧아 시작은 제외 */
        /* SET @v_sms_desc = @v_division_id +':'+@v_sms_req+':SSP'; */
        /* EXEC SCM_ADM_SMS_SEND_BATCH 50, @v_sms_desc; */

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 1-1.OWMS 재고 Cutoff 및 Hold Stock Cutoff  ( I/F시점 데이터 ) */
        /* ----------------------------------------------------------------------------------------------------------- */
        SELECT COUNT(A.DIVISION_ID)
          INTO V_OWMS_COUNT
          FROM SSP_ANL_OWMS_STOCK_C A
               JOIN SCM_MST_SITE B
            ON B.DIVISION_ID = V_DIVISION_ID
           AND NVL(B.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
           AND B.DIVISION_ID = A.DIVISION_ID
           AND B.SCM_SITE_ID = A.FROM_SITE
         WHERE A.DIVISION_ID         = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE           = V_PLAN_TYPE
           AND A.SEQ                 = V_SEQ
        ;

        /* Daily OWMS 재고 생성 (추출시점을 CUTOFF개념을 생성함, Daily 1회 9시 전송받은 재고) */
        IF V_OWMS_COUNT = 0 THEN

            /* 과거 데이터 삭제 로직 (30일 이전) */
            DELETE FROM SSP_ANL_OWMS_STOCK_C A
             WHERE A.DIVISION_ID         = V_DIVISION_ID
               AND A.PLAN_START_YYYYMMDD < TO_CHAR(SYSDATE - 30, 'YYYYMMDD')
               AND A.PLAN_TYPE           = V_PLAN_TYPE
               AND A.SEQ                 = V_SEQ
               AND EXISTS ( SELECT 1
                              FROM SCM_MST_SITE B
                             WHERE B.DIVISION_ID = V_DIVISION_ID
                               AND NVL(B.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
                               AND B.DIVISION_ID = A.DIVISION_ID
                               AND B.SCM_SITE_ID = A.FROM_SITE )
            ;

            /* [C20200601-000370] 해당 일 기준 OWMS I/F 내역이 없으면 가장 최근 CUTOFF 일자 사용 */
            SELECT COUNT(*)
              INTO V_OWMS_IF_COUNT
              FROM SSP_DNM_OWMS_STOCK O
                   JOIN SCM_MST_SITE B
                ON B.DIVISION_ID = V_DIVISION_ID
               AND NVL(B.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
               AND B.DIVISION_ID = O.DIVISION_ID
               AND B.PLANT_ID = O.PLANT_ID
               AND B.OPERATION_GROUP = FN_GET_ITEM_OPERATION_GROUP(O.PROD_GROUP, O.ITEM_ID)
             WHERE 1 = 1
               AND O.PROD_GROUP = V_DIVISION_ID
               AND O.CUTOFF_DATE = V_DATA_START_YYYYMMDD
               AND FN_GET_SCM_SITE_ID_PLANT(O.PLANT_ID, FN_GET_ITEM_OPERATION_GROUP(O.PROD_GROUP, O.ITEM_ID)) IS NOT NULL
            ;

            IF V_OWMS_IF_COUNT = 0 THEN
                /* THROW 60001 (MSSQL 주석처리됨) : 가장 최근 CUTOFF 사용 */
                SELECT MAX(CUTOFF_DATE)
                  INTO V_DATA_CUTOFF_YYYYMMDD
                  FROM SSP_DNM_OWMS_STOCK O
                       JOIN SCM_MST_SITE B
                    ON B.DIVISION_ID = V_DIVISION_ID
                   AND NVL(B.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
                   AND B.DIVISION_ID = O.DIVISION_ID
                   AND B.PLANT_ID = O.PLANT_ID
                 WHERE 1 = 1
                   AND O.PROD_GROUP = V_DIVISION_ID
                   /* [E20261126-OWMSMAX] 행마다 함수 호출 -> 스칼라 서브쿼리 캐시(같은 PLANT_ID, ITEM_ID 는 1회). 클라우드 11-26 회차당 73~76초(83wgypmy3wyvu) */
                   AND (SELECT FN_GET_SCM_SITE_ID_PLANT(O.PLANT_ID, FN_GET_ITEM_OPERATION_GROUP(O.PROD_GROUP, O.ITEM_ID)) FROM DUAL) IS NOT NULL
                ;
            END IF;

            INSERT INTO SSP_ANL_OWMS_STOCK_C (
                     DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, FROM_SITE
                    ,ITEM_ID, PALLET_ID, STOCK_QTY, AVAILABLE_QTY, AVAILABLE_QTY_ORIGIN
                    ,NON_QC_QTY, ALLOCATION_QTY, BLOCK_QTY, PACKING_QTY, MOVING_QTY
                    ,RCVLOC_QTY, EXPIRATION_QTY, LONG_QTY, PROD_GROUP, LOT_ID
                    ,PLANT_ID, GRADE, PACKING_STATUS, STOCK_STATUS, STORAGE_ID
                    ,CUSTOMER_CODE, CUSTOMER_NAME, LOT_DATE, SOC, CAPACITY_GRADE
                    ,ORIGIN_FROM_DIVISION_ID, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                    ,ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
                    ,ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                    )
            SELECT
                     O.PROD_GROUP AS DIVISION_ID
                    ,V_PLAN_START_YYYYMMDD
                    ,V_PLAN_TYPE
                    ,V_SEQ
                    ,FN_GET_SCM_SITE_ID_PLANT(O.PLANT_ID, FN_GET_ITEM_OPERATION_GROUP(O.PROD_GROUP, O.ITEM_ID))
                    ,O.ITEM_ID
                    ,O.PALLET_ID
                    ,O.STOCK_QTY
                     /* STOCK_QTY - BLOCK_QTY - LONG_QTY , 남경(G182)의 경우 BLOCK_QTY만 제외 */
                    ,O.STOCK_QTY - CASE WHEN O.PLANT_ID = V_G182 THEN O.BLOCK_QTY
                                   ELSE
                                        CASE WHEN O.BLOCK_QTY > O.LONG_QTY THEN O.BLOCK_QTY
                                             WHEN O.BLOCK_QTY < O.LONG_QTY THEN O.LONG_QTY
                                             WHEN O.BLOCK_QTY = O.LONG_QTY THEN O.BLOCK_QTY
                                        END
                                   END AS AVAILABLE_QTY
                    ,O.AVAILABLE_QTY  AS AVAILABLE_QTY_ORIGIN
                    ,O.NON_QC_QTY
                    ,O.ALLOCATION_QTY
                    ,O.BLOCK_QTY
                    ,O.PACKING_QTY
                    ,O.MOVING_QTY
                    ,O.RCVLOC_QTY
                    ,O.EXPIRATION_QTY
                    ,O.LONG_QTY
                    ,O.PROD_GROUP
                    ,NVL(O.LOT_ID,'-')          AS LOT_ID
                    ,O.PLANT_ID                 AS PLANT_ID
                    ,NVL(O.GRADE, '-')          AS GRADE
                    ,NVL(O.PACKING_STATUS, '-') AS PACKING_STATUS
                    ,NVL(O.STOCK_STATUS,'-')    AS STOCK_STATUS
                    ,NVL(O.STORAGE_ID,'-')      AS STORAGE_ID
                    ,NVL(O.CUSTOMER_CODE,'-')   AS CUSTOMER_CODE
                    ,O.CUSTOMER_NAME
                    ,O.LOT_DATE
                    ,NVL(O.SOC, '-')            AS CUSTOMER_NAME
                    ,NVL(O.CAPACITY_GRADE, '-') AS CAPACITY_GRADE
                    ,O.PROD_GROUP     /* ORIGIN_FROM_DIVISION_ID */
                    ,V_BATCH_USER
                    ,O.CREATION_DATE   /* OWMS I/F 처리 DATE */
                    ,V_BATCH_USER
                    ,SYSDATE
                    ,O.ATTRIBUTE1, O.ATTRIBUTE2, O.ATTRIBUTE3, O.ATTRIBUTE4, O.ATTRIBUTE5
                    ,O.ATTRIBUTE6, O.ATTRIBUTE7, O.ATTRIBUTE8, O.ATTRIBUTE9, O.ATTRIBUTE10
              FROM SSP_DNM_OWMS_STOCK O   /* [C20200601-000370] 테이블 변경 (구 XIF_OWMS_STOCK_R_SN) */
                   JOIN SCM_MST_SITE B
                ON B.DIVISION_ID = V_DIVISION_ID
               AND NVL(B.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
               AND B.DIVISION_ID = O.DIVISION_ID
               AND B.PLANT_ID = O.PLANT_ID
               AND B.OPERATION_GROUP = FN_GET_ITEM_OPERATION_GROUP(O.PROD_GROUP, O.ITEM_ID)
             WHERE 1 = 1
               AND O.PROD_GROUP = V_DIVISION_ID
               AND O.CUTOFF_DATE = V_DATA_CUTOFF_YYYYMMDD
               AND FN_GET_SCM_SITE_ID_PLANT(O.PLANT_ID, FN_GET_ITEM_OPERATION_GROUP(O.PROD_GROUP, O.ITEM_ID)) IS NOT NULL
            ;
        END IF;

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 1-3.TCO STOCK Cutoff생성  (STORAGE ID : B100/R100, WH_STOCK 적용) */
        /* ----------------------------------------------------------------------------------------------------------- */
        SELECT COUNT(A.DIVISION_ID)
          INTO V_TCO_COUNT
          FROM SSP_ANL_TCO_STOCK_C A
               JOIN SCM_MST_SITE B
            ON B.DIVISION_ID = V_DIVISION_ID
           AND NVL(B.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
           AND B.DIVISION_ID = A.DIVISION_ID
           AND B.SCM_SITE_ID = A.SCM_SITE_ID
         WHERE A.DIVISION_ID         = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE           = V_PLAN_TYPE
           AND A.SEQ                 = V_SEQ
        ;

        IF V_TCO_COUNT = 0 THEN

            DELETE FROM SSP_ANL_TCO_STOCK_C A
             WHERE A.DIVISION_ID         = V_DIVISION_ID
               AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE           = V_PLAN_TYPE
               AND A.SEQ                 = V_SEQ
               AND EXISTS ( SELECT 1
                              FROM SCM_MST_SITE B
                             WHERE B.DIVISION_ID = V_DIVISION_ID
                               AND NVL(B.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
                               AND B.DIVISION_ID = A.DIVISION_ID
                               AND B.SCM_SITE_ID = A.SCM_SITE_ID )
            ;

            INSERT INTO SSP_ANL_TCO_STOCK_C (
                     DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, SCM_SITE_ID
                    ,ITEM_ID, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                    ,ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
                    ,ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                    )
            SELECT A.DIVISION_ID  AS DIVISION_ID
                 , V_PLAN_START_YYYYMMDD  AS PLAN_START_YYYYMMDD
                 , V_PLAN_TYPE     AS PLAN_TYPE
                 , V_SEQ           AS SEQ
                 , FN_GET_SCM_SITE_ID_PLANT(A.PLANT_ID, FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, RTRIM(LTRIM(A.ITEM_ID)))) AS SCM_SITE_ID
                 /* jilee 230830 */
                 , NVL(IM.APPLIED_MODEL, A.ITEM_ID) AS ITEM_ID
                 , SUM(A.SSP_QTY)       AS QTY
                 , V_BATCH_USER AS CREATED_BY
                 , SYSDATE AS CREATION_DATE
                 , V_BATCH_USER AS LAST_UPDATED_BY
                 , SYSDATE AS LAST_UPDATE_DATE
                 , NULL AS ATTRIBUTE1, NULL AS ATTRIBUTE2, NULL AS ATTRIBUTE3
                 , NULL AS ATTRIBUTE4, NULL AS ATTRIBUTE5, NULL AS ATTRIBUTE6
                 , NULL AS ATTRIBUTE7, NULL AS ATTRIBUTE8, NULL AS ATTRIBUTE9, NULL AS ATTRIBUTE10
              FROM SSP_DNM_STOCK_C A  /* SCM_DNM_STOCK_V */
                   JOIN (
                         SELECT C.DIVISION_ID , C.SITE_ID , MAX(C.CUTOFF_DATE) AS CUTOFF_DATE
                           FROM SSP_DNM_STOCK_C C
                          WHERE C.CUTOFF_DATE  >  SYSDATE - 5
                            AND C.DIVISION_ID = V_DIVISION_ID
                          GROUP BY C.DIVISION_ID, C.SITE_ID
                        ) B
                ON B.DIVISION_ID = A.DIVISION_ID
               AND B.SITE_ID     = A.SITE_ID
               AND B.CUTOFF_DATE = A.CUTOFF_DATE
                   /* jilee 230830 */
                   LEFT OUTER JOIN SCM_MST_ITEM_SN IM
                ON IM.DIVISION_ID = A.DIVISION_ID
               AND IM.COMPANY_ID = V_COMPANY_ID
               AND IM.SITE_ID = A.SITE_ID
               AND IM.ITEM_ID = A.ITEM_ID
               AND IM.ITEM_CLASS IN ('ES1901', 'ES2001','ES2002', 'ES2003', 'ES2004')
             WHERE A.DIVISION_ID = V_DIVISION_ID
               AND A.COMPANY_ID  = V_COMPANY_ID
               AND A.STORAGE_ID  IN (SELECT COLUMN_VALUE FROM TABLE(FN_LIST_LOOKUP_VALUE('PR_SSP_ANL_SHIP_PLAN_40','B100_R100')))
               AND FN_GET_SCM_SITE_ID_PLANT(A.PLANT_ID, FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, RTRIM(LTRIM(A.ITEM_ID)))) IS NOT NULL
             GROUP BY A.DIVISION_ID
                 ,    FN_GET_SCM_SITE_ID_PLANT(A.PLANT_ID, FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, RTRIM(LTRIM(A.ITEM_ID))))
                      /* jilee 230830 */
                 ,    IM.APPLIED_MODEL
                 ,    A.ITEM_ID
            ;

        END IF;

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 1-4.Hold 재고 Cutoff생성 (이전 Plan 기준으로 현재 정보 생성) */
        /* ----------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_SSP_ANL_HOLD_STOCK;

        INSERT INTO GT_SSP_ANL_HOLD_STOCK (
                     HOLD_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, DIVISION_ID
                    ,FROM_SITE, ITEM_ID, HOLD_YYYYMMDD, RELEASE_YYYYMMDD, HOLD_QTY
                    ,REMARKS, ORIGIN_FROM_DIVISION_ID, CREATED_BY, CREATION_DATE
                    ,LAST_UPDATED_BY, LAST_UPDATE_DATE
                    )
        SELECT
                 A.HOLD_ID
                ,V_PLAN_START_YYYYMMDD
                ,V_PLAN_TYPE
                ,V_SEQ
                ,A.DIVISION_ID
                ,A.FROM_SITE
                ,A.ITEM_ID
                ,A.HOLD_YYYYMMDD
                ,A.RELEASE_YYYYMMDD
                ,A.HOLD_QTY
                ,A.REMARKS
                ,A.DIVISION_ID /* ORIGIN_FROM_DIVISION_ID */
                ,A.CREATED_BY
                ,A.CREATION_DATE
                ,A.LAST_UPDATED_BY
                ,A.LAST_UPDATE_DATE
          FROM SSP_ANL_HOLD_STOCK A
               JOIN SCM_MST_SITE B
            ON B.DIVISION_ID = V_DIVISION_ID
           AND NVL(B.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
           AND B.DIVISION_ID = A.DIVISION_ID
           AND B.SCM_SITE_ID = A.FROM_SITE
         WHERE A.DIVISION_ID         = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD = ( SELECT MAX(PLAN_START_YYYYMMDD)
                                           FROM SSP_ANL_HOLD_STOCK C
                                          WHERE C.DIVISION_ID = V_DIVISION_ID
                                            AND C.PLAN_TYPE   = V_LAST_PLAN_TYPE
                                            AND C.SEQ         = V_LAST_SEQ
                                       )
           AND A.PLAN_TYPE           = V_LAST_PLAN_TYPE
           AND A.SEQ                 = V_LAST_SEQ
        ;

        /* SSP_ANL_HOLD_STOCK 생성 */
        DELETE FROM SSP_ANL_HOLD_STOCK A
         WHERE A.DIVISION_ID         = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE           = V_PLAN_TYPE
           AND A.SEQ                 = V_SEQ
           AND EXISTS ( SELECT 1
                          FROM SCM_MST_SITE B
                         WHERE B.DIVISION_ID = V_DIVISION_ID
                           AND NVL(B.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
                           AND B.DIVISION_ID = A.DIVISION_ID
                           AND B.SCM_SITE_ID = A.FROM_SITE )
        ;

        INSERT INTO SSP_ANL_HOLD_STOCK (
                 HOLD_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, DIVISION_ID
                ,FROM_SITE, ITEM_ID, HOLD_YYYYMMDD, RELEASE_YYYYMMDD, HOLD_QTY
                ,REMARKS, ORIGIN_FROM_DIVISION_ID, CREATED_BY, CREATION_DATE
                ,LAST_UPDATED_BY, LAST_UPDATE_DATE
                )
        SELECT
                 HOLD_ID
                ,V_PLAN_START_YYYYMMDD
                ,V_PLAN_TYPE
                ,V_SEQ
                ,DIVISION_ID
                ,FROM_SITE
                ,ITEM_ID
                ,HOLD_YYYYMMDD
                ,RELEASE_YYYYMMDD
                ,HOLD_QTY
                ,REMARKS
                ,ORIGIN_FROM_DIVISION_ID
                ,CREATED_BY
                ,CREATION_DATE
                ,LAST_UPDATED_BY
                ,LAST_UPDATE_DATE
          FROM GT_SSP_ANL_HOLD_STOCK
        ;

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 1-5.활성화수율 CUTOFF DATA 생성 (SSP0015 Aging L/T, Yeild 조회용) */
        /* ----------------------------------------------------------------------------------------------------------- */
        DELETE FROM SSP_ANL_FORMATION_C A
         WHERE A.DIVISION_ID         = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE           = V_PLAN_TYPE
           AND A.SEQ                 = V_SEQ
           AND EXISTS ( SELECT 1
                          FROM SCM_MST_SITE B
                         WHERE B.DIVISION_ID = V_DIVISION_ID
                           AND NVL(B.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
                           AND B.DIVISION_ID = A.DIVISION_ID
                           AND B.SCM_SITE_ID = A.PLANT_SITE_ID )
        ;

        INSERT INTO SSP_ANL_FORMATION_C (
                 DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, PLANT_SITE_ID
                ,ITEM_ID, LT_FORMATION, FORMATION_YIELD, CHAR_YIELD, FORMATION_TOTAL_YIELD
                ,SSP_MODIFY_YIELD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                ,ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
                ,ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
        )
        SELECT   F.DIVISION_ID
                ,V_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD
                ,V_PLAN_TYPE           AS PLAN_TYPE
                ,V_SEQ                 AS SEQ
                ,F.PLANT_SITE_ID
                ,F.ITEM_ID
                /* TCO 시작하는 공정은 ADD L/T만 반영 ( SSP_ANL_FORMATION_C에 TCO공정은 0으로 setting ) */
                ,CASE WHEN V.TCO_CELL_YN = 'Y' THEN 0 ELSE F.LT_FORMATION END AS LT_FORMATION
                ,F.FORMATION_YIELD
                ,F.CHAR_YIELD
                ,F.FORMATION_TOTAL_YIELD
                ,F.SSP_MODIFY_YIELD
                ,F.CREATED_BY
                ,F.CREATION_DATE
                ,F.LAST_UPDATED_BY
                ,F.LAST_UPDATE_DATE
                ,F.ATTRIBUTE1, F.ATTRIBUTE2, F.ATTRIBUTE3, F.ATTRIBUTE4, F.ATTRIBUTE5
                ,F.ATTRIBUTE6, F.ATTRIBUTE7, F.ATTRIBUTE8, F.ATTRIBUTE9, F.ATTRIBUTE10
          FROM SCP_MST_FORMATION F
               LEFT OUTER JOIN SCP_MST_FINAL_ITEM V
            ON V.ITEM_ID = F.ITEM_ID
           AND V.DIVISION_ID = F.DIVISION_ID
           AND V.TCO_CELL_YN = 'Y'
               JOIN SCM_MST_SITE B
            ON B.DIVISION_ID = V_DIVISION_ID
           AND NVL(B.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
           AND B.DIVISION_ID = F.DIVISION_ID
           AND B.SCM_SITE_ID = F.PLANT_SITE_ID
         WHERE F.DIVISION_ID = V_DIVISION_ID
        ;

        /* 이전 AGING L/T(LT_FORMATION + ATTRIBUTE1)과 다른 경우 이전 L/T 정보를 ATTRIBUTE2에 UPDATE  [C20200407-000144] Alarm 기간 2주 */

        MERGE INTO SSP_ANL_FORMATION_C A
        USING (
               SELECT X.DIVISION_ID , X.PLANT_SITE_ID , X.ITEM_ID , X.LT
                 FROM (
                        SELECT A.PLAN_START_YYYYMMDD
                        ,      A.DIVISION_ID , A.PLANT_SITE_ID , A.ITEM_ID
                        ,      SUM(A.LT_FORMATION + CASE WHEN A.ATTRIBUTE1 IS NOT NULL AND VALIDATE_CONVERSION(A.ATTRIBUTE1 AS NUMBER) = 1 THEN TO_NUMBER(A.ATTRIBUTE1) ELSE 0 END ) AS LT
                        ,      ROW_NUMBER() OVER(PARTITION BY A.DIVISION_ID , A.PLANT_SITE_ID, A.ITEM_ID ORDER BY A.PLAN_START_YYYYMMDD DESC )   AS MAX_PLAN_START_YYYYMMDD
                          FROM SSP_ANL_FORMATION_C A
                               JOIN (
                                     SELECT DIVISION_ID , PLANT_SITE_ID , ITEM_ID , LT_FORMATION , ATTRIBUTE1
                                     ,      LT_FORMATION + CASE WHEN ATTRIBUTE1 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE1 AS NUMBER) = 1 THEN TO_NUMBER(ATTRIBUTE1) ELSE 0 END AS LT
                                       FROM SSP_ANL_FORMATION_C
                                      WHERE DIVISION_ID         = V_DIVISION_ID
                                        AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                        AND PLAN_TYPE           = V_PLAN_TYPE
                                        AND SEQ                 = V_SEQ
                                    ) B
                            ON A.DIVISION_ID   = B.DIVISION_ID
                           AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                           AND A.ITEM_ID       = B.ITEM_ID
                         WHERE A.DIVISION_ID          = V_DIVISION_ID
                           AND A.PLAN_START_YYYYMMDD <= V_PLAN_START_YYYYMMDD
                           AND A.PLAN_START_YYYYMMDD >= TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 14, 'YYYYMMDD')
                           AND A.PLAN_TYPE            = V_PLAN_TYPE
                           AND A.SEQ                  = V_SEQ
                           AND A.LT_FORMATION + CASE WHEN A.ATTRIBUTE1 IS NOT NULL AND VALIDATE_CONVERSION(A.ATTRIBUTE1 AS NUMBER) = 1 THEN TO_NUMBER(A.ATTRIBUTE1) ELSE 0 END <> B.LT
                         GROUP BY A.PLAN_START_YYYYMMDD , A.DIVISION_ID , A.PLANT_SITE_ID , A.ITEM_ID
                      ) X
                      JOIN SCM_MST_SITE C
                   ON C.DIVISION_ID = V_DIVISION_ID
                  AND NVL(C.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
                  AND C.DIVISION_ID = X.DIVISION_ID
                  AND C.SCM_SITE_ID = X.PLANT_SITE_ID
                WHERE X.MAX_PLAN_START_YYYYMMDD = 1
              ) SRC
        ON ( A.DIVISION_ID   = SRC.DIVISION_ID
         AND A.PLANT_SITE_ID = SRC.PLANT_SITE_ID
         AND A.ITEM_ID       = SRC.ITEM_ID
         AND A.DIVISION_ID         = V_DIVISION_ID
         AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
         AND A.PLAN_TYPE           = V_PLAN_TYPE
         AND A.SEQ                 = V_SEQ )
        WHEN MATCHED THEN UPDATE SET A.ATTRIBUTE2 = 'Before L/T : ' || TO_CHAR(TRUNC(SRC.LT))
        ;

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 1-6.MES/FCS 재고 CUTOFF DATA 생성 (L/T,수율적용) */
        /* ----------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_SSP_ANL_MES_FCS_STOCK_40_C;
        DELETE FROM GT_SCM_DNM_STOCK_AGING_V;        /* #tmp_SCM_DNM_STOCK_AGING_V (튜닝) */

        INSERT INTO GT_SCM_DNM_STOCK_AGING_V
               (DIVISION_ID, SCM_SITE_ID, ITEM_ID, LOT_ID, QTY, WIPHOLD_YN, SPECIAL_YN, UNHOLD_EXP_DATE)
        SELECT   A.DIVISION_ID
             ,   A.SCM_SITE_ID
             ,   A.ITEM_ID
             ,   A.LOT_ID
             ,   A.QTY
             ,   A.WIPHOLD_YN
             ,   A.SPECIAL_YN
             ,   A.UNHOLD_EXP_DATE
          FROM SCM_DNM_STOCK_AGING_V A
               JOIN ( /* 가장최근 CUTOFF 기준 */
                     SELECT C.DIVISION_ID, C.SITE_ID , MAX(C.CUTOFF_DATE) AS CUTOFF_DATE
                       FROM SCM_DNM_STOCK_AGING_V C
                      WHERE C.CUTOFF_DATE >  SYSDATE - 5
                        AND C.DIVISION_ID = V_DIVISION_ID
                      GROUP BY C.DIVISION_ID, C.SITE_ID
                    ) B
            ON A.DIVISION_ID = B.DIVISION_ID
           AND A.SITE_ID     = B.SITE_ID
           AND A.CUTOFF_DATE = B.CUTOFF_DATE
         /* [E20261126-AGINGCUT] 조인 조건에서 나오는 조건을 바깥쪽 뷰에 명시(결과 같음). 뷰 CUTOFF_DATE = 원장 CUTOFF_DATE - 1 이므로 */
         /* A.CUTOFF_DATE > SYSDATE - 5 = A.ORG_CUTOFF_DATE > SYSDATE - 4. 원장 SCM_AGING_STOCK_H 전체 읽기 → CUTOFF_DATE 인덱스 범위 */
         WHERE A.DIVISION_ID     = V_DIVISION_ID
           AND A.ORG_CUTOFF_DATE > SYSDATE - 4
        ;

        /* MES / FCS 재고 정보 추출 및 병합 -> 전일 비교 후 신규/변경/삭제 상태 적용 */
        INSERT INTO GT_SSP_ANL_MES_FCS_STOCK_40_C (
                DIVISION_ID, FROM_SITE, ITEM_ID, LOT_ID, LOT_TYPE
             ,  LOT_QTY_MES, LOT_QTY_FCS, LOT_QTY_TOT, FCS_SPECIAL_QTY, AVAILABLE_YN
             ,  MES_HOLD_YN, QMS_HOLD_YN, FCS_HOLD_YN, LONGTERM_HOLD_YN, JUDG_VLD_DATE
             ,  MES_HOLD_RELEASE, QMS_HOLD_RELEASE, USER_MOD_RELEASE_DATE, REMARKS, SUM_DATE
             ,  CHANGE_STATUS, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE4
        )
        WITH NEWDT AS (
            SELECT  X.DIVISION_ID
            ,       X.FROM_SITE
            ,       X.ITEM_ID
            ,       X.LOT_ID2                               AS LOT_ID
            ,       MAX(X.LOT_TYPE)                         AS LOT_TYPE
            ,       SUM(X.LOT_QTY_MES)                      AS LOT_QTY_MES
            ,       SUM(X.LOT_QTY_FCS)                      AS LOT_QTY_FCS
            ,       SUM(X.LOT_QTY_MES) + SUM(X.LOT_QTY_FCS) AS LOT_QTY_TOT
            ,       SUM(X.FCS_SPECIAL_QTY)                  AS FCS_SPECIAL_QTY
            ,       CASE WHEN MIN(X.AVAILABLE_YN_MES) = 'N' OR MIN(X.AVAILABLE_YN_FCS) = 'N' THEN 'N' ELSE 'Y' END   AS AVAILABLE_YN
            ,       NVL(MAX(X.MES_HOLD_YN),'-')          AS MES_HOLD_YN
            ,       NVL(MAX(X.QMS_HOLD_YN),'-')          AS QMS_HOLD_YN
            ,       NVL(MAX(X.FCS_HOLD_YN),'-')          AS FCS_HOLD_YN
            ,       NVL(MAX(X.LONGTERM_HOLD_YN),'-')     AS LONGTERM_HOLD_YN
            ,       NVL(MAX(X.FCS_SPECIAL_YN),'-')       AS FCS_SPECIAL_YN
            ,       MAX(X.JUDG_VLD_DATE)                    AS JUDG_VLD_DATE
            ,       MAX(X.MES_HOLD_RELEASE)                 AS MES_HOLD_RELEASE
            ,       MAX(X.QMS_HOLD_RELEASE)                 AS QMS_HOLD_RELEASE
            ,       NULL                                    AS USER_MOD_RELEASE_DATE
            ,       NULL                                    AS REMARKS
            ,       SUM(X.ATTRIBUTE4)                       AS ATTRIBUTE4
            FROM (  /* FCS 재고 정보 */
                    SELECT A.DIVISION_ID        AS DIVISION_ID
                    ,      'FCS'                AS TYPE
                    ,      A.SCM_SITE_ID        AS FROM_SITE
                    ,      NVL(IM.APPLIED_MODEL, A.ITEM_ID)  AS ITEM_ID
                    ,      A.LOT_ID             AS LOT_ID
                    ,      CASE WHEN NVL(D.SEGMENT3, '-') = 'P' THEN
                               CASE WHEN INSTR(A.LOT_ID,'-') = 10 AND LENGTH(A.LOT_ID) = 13 THEN SUBSTR(A.LOT_ID, 1, INSTR(A.LOT_ID,'-') -1)
                                    WHEN INSTR(A.LOT_ID,'-') = 10 AND LENGTH(A.LOT_ID) > 13 THEN SUBSTR(A.LOT_ID, 1, 10)
                                    WHEN INSTR(A.LOT_ID,'-') <> 10 AND LENGTH(A.LOT_ID) > 13 THEN SUBSTR(A.LOT_ID, 1, 10)
                               ELSE SUBSTR(A.LOT_ID, 1, 8) END
                           ELSE SUBSTR(A.LOT_ID, 1, 8) END   AS LOT_ID2
                    ,      NULL                 AS LOT_TYPE
                    ,      0                    AS LOT_QTY_MES
                    ,      A.QTY                AS LOT_QTY_FCS
                    ,      0                    AS LOT_QTY_TOT
                    ,      CASE WHEN A.SPECIAL_YN = 'Y' THEN A.QTY ELSE 0 END AS FCS_SPECIAL_QTY
                    ,      NULL                 AS AVAILABLE_YN_MES
                    ,      CASE WHEN A.WIPHOLD_YN = 'Y' THEN 'N' ELSE 'Y' END  AS AVAILABLE_YN_FCS
                    ,      NULL                 AS MES_HOLD_YN
                    ,      NULL                 AS QMS_HOLD_YN
                    ,      A.WIPHOLD_YN         AS FCS_HOLD_YN
                    ,      NULL                 AS LONGTERM_HOLD_YN
                    ,      A.SPECIAL_YN         AS FCS_SPECIAL_YN
                    ,      NULL                 AS JUDG_VLD_DATE
                    ,      TO_CHAR(A.UNHOLD_EXP_DATE, 'YYYYMMDD')   AS MES_HOLD_RELEASE
                    ,      NULL                 AS QMS_HOLD_RELEASE
                    ,      0                    AS ATTRIBUTE4
                    FROM   GT_SCM_DNM_STOCK_AGING_V A
                           LEFT OUTER JOIN SCP_MST_FINAL_ITEM  C
                        ON C.DIVISION_ID = A.DIVISION_ID
                       AND C.ITEM_ID = A.ITEM_ID
                           LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D
                        ON D.LOOKUP_TYPE = 'CELL_TYPE_CODE'
                       AND D.VALID_YN    = 'Y'
                       AND D.SEGMENT1    = C.CELL_TYPE_GROUP_CODE
                           JOIN SCM_MST_SITE E
                        ON E.DIVISION_ID = V_DIVISION_ID
                       AND NVL(E.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
                       AND E.DIVISION_ID = A.DIVISION_ID
                       AND E.SCM_SITE_ID = A.SCM_SITE_ID
                           LEFT OUTER JOIN SCM_MST_ITEM_SN IM
                        ON IM.DIVISION_ID = A.DIVISION_ID
                       AND IM.COMPANY_ID = V_COMPANY_ID
                       AND IM.SITE_ID = E.SITE_ID
                       AND IM.ITEM_ID = A.ITEM_ID
                       AND IM.ITEM_CLASS IN ('ES1901', 'ES2001','ES2002', 'ES2003', 'ES2004')
                    WHERE  1 = 1
                    AND    A.DIVISION_ID = V_DIVISION_ID
                    AND    A.SCM_SITE_ID IS NOT NULL
                    AND    A.QTY <> 0

                    UNION ALL
                    /* MES 재고정보 */
                    SELECT A.DIVISION_ID        AS DIVISION_ID
                    ,      'MES'                AS TYPE
                    ,      A.FROM_SITE          AS FROM_SITE
                    ,      NVL(IM.APPLIED_MODEL, A.ITEM_ID)     AS ITEM_ID
                    ,      A.LOT_ID             AS LOT_ID
                    ,      CASE WHEN NVL(C.SEGMENT3, '-') = 'P' THEN
                               CASE WHEN INSTR(A.LOT_ID,'-') = 10 AND LENGTH(A.LOT_ID) = 13 THEN SUBSTR(A.LOT_ID, 1, INSTR(A.LOT_ID,'-') -1)
                                    WHEN INSTR(A.LOT_ID,'-') = 10 AND LENGTH(A.LOT_ID) > 13 THEN SUBSTR(A.LOT_ID, 1, 10)
                                    WHEN INSTR(A.LOT_ID,'-') <> 10 AND LENGTH(A.LOT_ID) > 13 THEN SUBSTR(A.LOT_ID, 1, 10)
                               ELSE SUBSTR(A.LOT_ID, 1, 8) END
                           ELSE SUBSTR(A.LOT_ID, 1, 8) END   AS LOT_ID2
                    ,      A.LOT_TYPE           AS LOT_TYPE
                    ,      A.LOT_QTY            AS LOT_QTY_MES
                    ,      0                    AS LOT_QTY_FCS
                    ,      0                    AS LOT_QTY_TOT
                    ,      0                    AS FCS_SPECIAL_QTY
                    ,      A.AVAILABLE_YN       AS AVAILABLE_YN_MES
                    ,      NULL                 AS AVAILABLE_YN_FCS
                    ,      A.MES_HOLD_YN        AS MES_HOLD_YN
                    ,      A.QMS_HOLD_YN        AS QMS_HOLD_YN
                    ,      NULL                 AS FCS_HOLD_YN
                    ,      A.LONGTERM_HOLD_YN   AS LONGTERM_HOLD_YN
                    ,      NULL                 AS FCS_SPECIAL_YN
                    ,      A.JUDG_VLD_DATE      AS JUDG_VLD_DATE
                    ,      A.MES_HOLD_RELEASE   AS MES_HOLD_RELEASE
                    ,      A.QMS_HOLD_RELEASE   AS QMS_HOLD_RELEASE
                    ,      NVL(TO_NUMBER(A.ATTRIBUTE4),0)     AS ATTRIBUTE4
                    FROM   SSP_DNM_GMES_STOCK_40 A
                           LEFT OUTER JOIN SCP_MST_FINAL_ITEM  B
                        ON B.DIVISION_ID = A.DIVISION_ID
                       AND B.ITEM_ID = A.ITEM_ID
                           LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C
                        ON C.LOOKUP_TYPE = 'CELL_TYPE_CODE'
                       AND C.VALID_YN    = 'Y'
                       AND C.SEGMENT1    = B.CELL_TYPE_GROUP_CODE
                           JOIN SCM_MST_SITE E
                        ON E.DIVISION_ID = V_DIVISION_ID
                       AND NVL(E.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
                       AND E.DIVISION_ID = A.DIVISION_ID
                       AND E.SCM_SITE_ID = A.FROM_SITE
                           LEFT OUTER JOIN SCM_MST_ITEM_SN IM
                        ON IM.DIVISION_ID = A.DIVISION_ID
                       AND IM.COMPANY_ID = V_COMPANY_ID
                       AND IM.SITE_ID = E.SITE_ID
                       AND IM.ITEM_ID = A.ITEM_ID
                       AND IM.ITEM_CLASS IN ('ES1901', 'ES2001','ES2002', 'ES2003', 'ES2004')
                    WHERE  A.DIVISION_ID = V_DIVISION_ID
                    AND    A.YYYYMMDD    = V_PLAN_START_YYYYMMDD
                    AND    A.LOT_QTY <> 0
             )  X
               JOIN SCM_MST_SITE C
            ON C.DIVISION_ID = V_DIVISION_ID
           AND NVL(C.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
           AND C.DIVISION_ID = X.DIVISION_ID
           AND C.SCM_SITE_ID = X.FROM_SITE
            WHERE  X.DIVISION_ID = V_DIVISION_ID
            GROUP BY X.DIVISION_ID
            ,        X.FROM_SITE
            ,        X.ITEM_ID
            ,        X.LOT_ID2
        )
        SELECT NVL(A.DIVISION_ID     , B.DIVISION_ID     )  AS DIVISION_ID
        ,      NVL(A.FROM_SITE       , B.FROM_SITE       )  AS FROM_SITE
        ,      NVL(A.ITEM_ID         , B.ITEM_ID         )  AS ITEM_ID
        ,      NVL(A.LOT_ID          , B.LOT_ID          )  AS LOT_ID
        ,      NVL(A.LOT_TYPE        , B.LOT_TYPE        )  AS LOT_TYPE
        ,      NVL(A.LOT_QTY_MES     , B.LOT_QTY_MES     )  AS LOT_QTY_MES
        ,      NVL(A.LOT_QTY_FCS     , B.LOT_QTY_FCS     )  AS LOT_QTY_FCS
        ,      NVL(A.LOT_QTY_TOT     , B.LOT_QTY_TOT     )  AS LOT_QTY_TOT
        ,      NVL(A.FCS_SPECIAL_QTY , B.FCS_SPECIAL_QTY )  AS FCS_SPECIAL_QTY
        ,      NVL(A.AVAILABLE_YN    , B.AVAILABLE_YN    )  AS AVAILABLE_YN
        ,      NVL(A.MES_HOLD_YN     , B.MES_HOLD_YN     )  AS MES_HOLD_YN
        ,      NVL(A.QMS_HOLD_YN     , B.QMS_HOLD_YN     )  AS QMS_HOLD_YN
        ,      NVL(A.FCS_HOLD_YN     , B.FCS_HOLD_YN     )  AS FCS_HOLD_YN
        ,      NVL(A.LONGTERM_HOLD_YN, B.LONGTERM_HOLD_YN)  AS LONGTERM_HOLD_YN
        ,      NVL(A.JUDG_VLD_DATE   , B.JUDG_VLD_DATE   )  AS JUDG_VLD_DATE
        ,      NVL(A.MES_HOLD_RELEASE, B.MES_HOLD_RELEASE)  AS MES_HOLD_RELEASE
        ,      NVL(A.QMS_HOLD_RELEASE, B.QMS_HOLD_RELEASE)  AS QMS_HOLD_RELEASE
        ,      CASE WHEN B.USER_MOD_RELEASE_DATE IS NOT NULL THEN B.USER_MOD_RELEASE_DATE
                    ELSE
                         CASE WHEN A.AVAILABLE_YN = 'N' THEN '29991231'
                         ELSE NULL
                         END
                    END                                    AS USER_MOD_RELEASE_DATE
        ,      NVL(A.REMARKS         , B.REMARKS         )  AS REMARKS
        ,      V_PLAN_START_YYYYMMDD  AS SUM_DATE
        ,      CASE WHEN B.AVAILABLE_YN IS NULL THEN 'N'  /* 신규 */
                    ELSE
                         CASE WHEN A.AVAILABLE_YN IS NULL THEN 'D' /* 삭제 */
                              ELSE
                                   CASE WHEN A.AVAILABLE_YN <> B.AVAILABLE_YN THEN 'C' /* 변경 */
                                   ELSE 'X'  /* 변경없음 */
                                   END
                              END
                    END                                    AS CHANGE_STATUS
        ,      NVL(B.CREATED_BY      , 'ssp_batch')  AS CREATED_BY
        ,      NVL(B.CREATION_DATE   , SYSDATE    )  AS CREATION_DATE
        ,      NVL(B.LAST_UPDATED_BY , 'ssp_batch')  AS LAST_UPDATED_BY
        ,      NVL(B.LAST_UPDATE_DATE, SYSDATE    )  AS LAST_UPDATE_DATE
        ,      NVL(A.ATTRIBUTE4      , B.ATTRIBUTE4)  AS ATTRIBUTE4
          FROM NEWDT A
               FULL OUTER JOIN ( /* 이전 재고 정보 */
                                SELECT A.DIVISION_ID, A.FROM_SITE, A.ITEM_ID, A.LOT_ID, A.LOT_TYPE
                                     , A.LOT_QTY_MES, A.LOT_QTY_FCS, A.LOT_QTY_TOT, A.FCS_SPECIAL_QTY, A.AVAILABLE_YN
                                     , A.MES_HOLD_YN, A.QMS_HOLD_YN, A.FCS_HOLD_YN, A.LONGTERM_HOLD_YN, A.JUDG_VLD_DATE
                                     , A.MES_HOLD_RELEASE, A.QMS_HOLD_RELEASE, A.USER_MOD_RELEASE_DATE, A.REMARKS
                                     , A.CREATED_BY, A.CREATION_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, A.ATTRIBUTE4
                                  FROM SSP_ANL_MES_FCS_STOCK_40_C A
                                       JOIN SCM_MST_SITE E
                                    ON E.DIVISION_ID = V_DIVISION_ID
                                   AND NVL(E.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
                                   AND E.DIVISION_ID = A.DIVISION_ID
                                   AND E.SCM_SITE_ID = A.FROM_SITE
                                 WHERE A.DIVISION_ID         = V_DIVISION_ID
                                   AND A.PLAN_START_YYYYMMDD = ( SELECT MAX(PLAN_START_YYYYMMDD)
                                                                   FROM SSP_ANL_MES_FCS_STOCK_40_C C
                                                                  WHERE C.DIVISION_ID = V_DIVISION_ID
                                                                    AND C.PLAN_TYPE   = V_LAST_PLAN_TYPE
                                                                    AND C.SEQ         = V_LAST_SEQ
                                                                )
                                   AND A.PLAN_TYPE           = V_LAST_PLAN_TYPE
                                   AND A.SEQ                 = V_LAST_SEQ
                                   AND A.CHANGE_STATUS       <> 'D'
                               ) B
            ON B.DIVISION_ID = A.DIVISION_ID
           AND B.FROM_SITE   = A.FROM_SITE
           AND B.ITEM_ID     = A.ITEM_ID
           AND B.LOT_ID      = A.LOT_ID
        ;

        /* SSP_ANL_MES_FCS_STOCK_40_C 생성전 Data Clear */
        DELETE FROM SSP_ANL_MES_FCS_STOCK_40_C A
         WHERE A.DIVISION_ID         = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE           = V_PLAN_TYPE
           AND A.SEQ                 = V_SEQ
           AND EXISTS ( SELECT 1
                          FROM SCM_MST_SITE E
                         WHERE E.DIVISION_ID = V_DIVISION_ID
                           AND NVL(E.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
                           AND E.DIVISION_ID = A.DIVISION_ID
                           AND E.SCM_SITE_ID = A.FROM_SITE )
        ;

        /* SSP_ANL_MES_FCS_STOCK_40_C 생성 */
        INSERT INTO SSP_ANL_MES_FCS_STOCK_40_C(
                 DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, FROM_SITE
                ,ITEM_ID, LOT_ID, YYYYMMDD_LOT_ID, YYYYMMDD_LOT_ID_APPLIED_LT, LOT_TYPE
                ,LOT_QTY_MES, LOT_QTY_FCS, LOT_QTY_TOT, LOT_QTY_TOT_YIELD, FCS_SPECIAL_QTY
                ,OWMS_STOCK_QTY, AVAILABLE_YN, MES_HOLD_YN, QMS_HOLD_YN, FCS_HOLD_YN
                ,LONGTERM_HOLD_YN, JUDG_VLD_DATE, MES_HOLD_RELEASE, QMS_HOLD_RELEASE, USER_MOD_RELEASE_DATE
                ,REMARKS, SUM_DATE, CHANGE_STATUS, CREATED_BY, CREATION_DATE
                ,LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3
                ,ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                )
        SELECT
                 A.DIVISION_ID
                ,V_PLAN_START_YYYYMMDD  AS PLAN_START_YYYYMMDD
                ,V_PLAN_TYPE            AS PLAN_TYPE
                ,V_SEQ                  AS SEQ
                ,A.FROM_SITE
                ,A.ITEM_ID
                ,A.LOT_ID
                ,CASE WHEN (LY.SEGMENT2 || LM.SEGMENT2 || SUBSTR(A.LOT_ID,6,2)) IS NOT NULL
                       AND VALIDATE_CONVERSION((LY.SEGMENT2 || LM.SEGMENT2 || SUBSTR(A.LOT_ID,6,2)) AS DATE, 'YYYYMMDD') = 1
                      THEN LY.SEGMENT2 || LM.SEGMENT2 || SUBSTR(A.LOT_ID,6,2)
                      ELSE NULL END          AS YYYYMMDD_LOT_ID
                ,TO_CHAR( TO_DATE( CASE WHEN (LY.SEGMENT2 || LM.SEGMENT2 || SUBSTR(A.LOT_ID,6,2)) IS NOT NULL
                                         AND VALIDATE_CONVERSION((LY.SEGMENT2 || LM.SEGMENT2 || SUBSTR(A.LOT_ID,6,2)) AS DATE, 'YYYYMMDD') = 1
                                        THEN LY.SEGMENT2 || LM.SEGMENT2 || SUBSTR(A.LOT_ID,6,2)
                                        ELSE NULL END , 'YYYYMMDD')
                          + (NVL(F.LT_FORMATION,0) + NVL(F.ATTRIBUTE1,0)) , 'YYYYMMDD') AS YYYYMMDD_LOT_ID_APPLIED_LT
                ,A.LOT_TYPE
                /* 수율 미적용 */
                ,ROUND(A.LOT_QTY_MES , 0)                           AS LOT_QTY_MES
                ,ROUND(A.LOT_QTY_FCS , 0)                           AS LOT_QTY_FCS
                ,ROUND(A.LOT_QTY_MES + A.LOT_QTY_FCS , 0)           AS LOT_QTY_TOT
                ,ROUND((A.LOT_QTY_MES + A.LOT_QTY_FCS) * NVL(F.SSP_MODIFY_YIELD ,1),0) AS LOT_QTY_TOT_YIELD /* 수율적용 토탈수량 추가 */
                ,ROUND(A.FCS_SPECIAL_QTY , 0)                       AS FCS_SPECIAL_QTY
                ,NVL(S.OWMS_STOCK_QTY,0)                            AS OWMS_STOCK_QTY
                ,A.AVAILABLE_YN
                ,A.MES_HOLD_YN
                ,A.QMS_HOLD_YN
                ,A.FCS_HOLD_YN
                ,A.LONGTERM_HOLD_YN
                ,A.JUDG_VLD_DATE
                ,A.MES_HOLD_RELEASE
                ,A.QMS_HOLD_RELEASE
                ,A.USER_MOD_RELEASE_DATE
                ,A.REMARKS
                ,A.SUM_DATE
                ,A.CHANGE_STATUS
                ,A.CREATED_BY
                ,A.CREATION_DATE
                ,A.LAST_UPDATED_BY
                ,A.LAST_UPDATE_DATE
                ,NULL /* ATTRIBUTE1 */
                ,NULL /* ATTRIBUTE2 */
                ,NULL /* ATTRIBUTE3 */
                ,A.ATTRIBUTE4
                ,NULL /* ATTRIBUTE5 */
                ,NULL /* ATTRIBUTE6 */
                ,NULL /* ATTRIBUTE7 */
                ,NULL /* ATTRIBUTE8 */
                ,NULL /* ATTRIBUTE9 */
                ,NULL /* ATTRIBUTE10 */
          FROM GT_SSP_ANL_MES_FCS_STOCK_40_C A
               LEFT OUTER JOIN ( SELECT   A.DIVISION_ID
                                 ,        A.PLAN_START_YYYYMMDD
                                 ,        A.PLAN_TYPE
                                 ,        A.SEQ
                                 ,        A.FROM_SITE
                                 ,        A.ITEM_ID
                                 ,        SUBSTR(A.LOT_ID,1,8) AS LOT_ID
                                 ,        SUM(A.STOCK_QTY)        AS OWMS_STOCK_QTY
                                 FROM     SSP_ANL_OWMS_STOCK_C A
                                          JOIN SCM_MST_SITE E
                                       ON E.DIVISION_ID = V_DIVISION_ID
                                      AND NVL(E.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
                                      AND E.DIVISION_ID = A.DIVISION_ID
                                      AND E.SCM_SITE_ID = A.FROM_SITE
                                 WHERE    A.DIVISION_ID         = V_DIVISION_ID
                                 AND      A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                 AND      A.PLAN_TYPE           = V_PLAN_TYPE
                                 AND      A.SEQ                 = V_SEQ
                                 GROUP BY A.DIVISION_ID
                                 ,        A.PLAN_START_YYYYMMDD
                                 ,        A.PLAN_TYPE
                                 ,        A.SEQ
                                 ,        A.FROM_SITE
                                 ,        A.ITEM_ID
                                 ,        SUBSTR(A.LOT_ID,1,8)
                               ) S
            ON S.FROM_SITE           = A.FROM_SITE
           AND S.ITEM_ID             = A.ITEM_ID
           AND S.LOT_ID              = A.LOT_ID
               LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LY
            ON LY.LOOKUP_TYPE = 'LOT_ID_YEAR'
           AND LY.VALID_YN    = 'Y'
           AND LY.SEGMENT1    = SUBSTR(A.LOT_ID,4,1)
           AND LY.SEGMENT2 BETWEEN TO_CHAR(ADD_MONTHS(SYSDATE,-132),'YYYY') AND TO_CHAR(ADD_MONTHS(SYSDATE,96),'YYYY')
               LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LM
            ON LM.LOOKUP_TYPE = 'LOT_ID_MONTH'
           AND LM.VALID_YN    = 'Y'
           AND LM.SEGMENT1    = SUBSTR(A.LOT_ID,5,1)
               LEFT OUTER JOIN SCM_SYS_CALENDAR_M  C /* 유효한 날짜만 추출 */
            ON C.BASIS_YYYYMMDD = LY.SEGMENT2 || LM.SEGMENT2 || SUBSTR(A.LOT_ID,6,2)
               LEFT OUTER JOIN SSP_ANL_FORMATION_C F
            ON F.DIVISION_ID         = A.DIVISION_ID
           AND F.PLANT_SITE_ID       = A.FROM_SITE
           AND F.ITEM_ID             = A.ITEM_ID
           AND F.DIVISION_ID         = V_DIVISION_ID
           AND F.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
           AND F.PLAN_TYPE           = V_PLAN_TYPE
           AND F.SEQ                 = V_SEQ
        ;

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 2. MEASURE별 Data생성  (Measure까지 GTT에 누적 후 마지막에 SSP_ANL_SHIP_PLAN_40 로 입력) */
        /* ----------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_SSP_ANL_SHIP_PLAN_40;   /* #tmp_SSP_ANL_SHIP_PLAN_40 */

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 2-1. [S]SHIP_REQ(Shipment Request) : MKT 담당자가 출하요청한 수량 (SSP_ANL_SHIP_REQ) */
        /* ----------------------------------------------------------------------------------------------------------- */
        INSERT INTO GT_SSP_ANL_SHIP_PLAN_40
                ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID
                , FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID
                , QTY, ROUTE_ID, INCOTERMS, TRANSPORT_MODE, BIZ_TYPE
                , PROJECT_CODE, FCST_TYPE, FCST_ETD_DATE, FCST_ETA_DATE, ETD_DATE
                , ETA_DATE, CONFIRM_ID, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, ATTRIBUTE2 )
        SELECT
                R.DIVISION_ID             AS DIVISION_ID
        ,      V_PLAN_START_YYYYMMDD      AS PLAN_START_YYYYMMDD
        ,      V_PLAN_TYPE               AS PLAN_TYPE
        ,      V_SEQ                     AS SEQ
        ,      R.ITEM_ID                 AS ITEM_ID
        ,      R.FROM_SITE               AS FROM_SITE
        ,      R.TO_SITE                 AS TO_SITE
        ,      'SHIP_REQ'                AS MEASURE
        ,      R.YYYYMMDD                AS YYYYMMDD
        ,      R.BOD_ID                  AS BOD_ID
        ,      SUM(R.QTY)                AS QTY
        ,      NVL(S.ROUTE_ID, 0)        AS ROUTE_ID
        ,      NVL(S.SSP_INCOTERMS, R.INCOTERMS)   AS INCOTERMS
        ,      R.TRANSPORT_MODE          AS TRANSPORT_MODE
        ,      R.BIZ_TYPE                AS BIZ_TYPE
        ,      R.PROJECT_CODE            AS PROJECT_CODE
        ,      R.FCST_TYPE               AS FCST_TYPE
        ,      R.FCST_ETD_DATE           AS FCST_ETD_DATE
        ,      R.FCST_ETA_DATE           AS FCST_ETA_DATE
        ,      R.ETD_DATE                AS ETD_DATE
        ,      R.ETA_DATE                AS ETA_DATE
        ,      R.CONFIRM_ID
        ,      R.DIVISION_ID             AS ORIGIN_FROM_DIVISION_ID
        ,      R.DIVISION_ID             AS ORIGIN_TO_DIVISION_ID
        ,      R.CREATED_BY              AS ATTRIBUTE2 /* REQUESTOR */
          FROM (
                SELECT R.DIVISION_ID
                    , R.ITEM_ID
                    , R.PLANT_SITE_ID  AS FROM_SITE
                    , R.SCM_SITE_ID    AS TO_SITE
                    , R.MEASURE
                    , R.YYYYMMDD
                    , R.BOD_ID
                    , R.QTY
                    , R.INCOTERMS
                    , R.TRANSPORT_MODE
                    , CASE WHEN INSTR(R.PLANT_SITE_ID,'-') = 0 THEN 'A'
                      ELSE SUBSTR(R.PLANT_SITE_ID, INSTR(R.PLANT_SITE_ID,'-')+1, 1) END   AS BIZ_TYPE
                    , R.PROJECT_CODE
                    , R.FCST_TYPE
                    , R.YYYYMMDD AS FCST_ETD_DATE
                    , FN_GET_SSP_ETA_DATE(R.DIVISION_ID, R.BOD_ID, R.YYYYMMDD) AS FCST_ETA_DATE
                    , R.YYYYMMDD AS ETD_DATE
                    , FN_GET_SSP_ETA_DATE(R.DIVISION_ID, R.BOD_ID, R.YYYYMMDD) AS ETA_DATE
                    , R.ATTRIBUTE10                                            AS CONFIRM_ID
                    , R.CREATED_BY
                FROM   DM_PLN_SHIPMENT_REQ R
                       JOIN SCM_MST_SITE  B
                    ON B.OPERATION_GROUP <> 'E'
                   AND B.DIVISION_ID      = R.DIVISION_ID
                   AND B.SCM_SITE_ID      = R.PLANT_SITE_ID
                WHERE  1 = 1
                AND    R.DIVISION_ID = P_DIVISION_ID
                AND    R.MEASURE     = 'SHIP_REQ'
                AND    R.QTY         > 0
                AND    R.YYYYMMDD    >= V_DATA_START_YYYYMMDD
                AND    R.YYYYMMDD    <= V_DATA_END_YYYYMMDD

                UNION ALL

                SELECT R.DIVISION_ID
                    , R.MODEL_ID       AS ITEM_ID
                    , R.FROM_SITE      AS FROM_SITE
                    , R.TO_SITE        AS TO_SITE
                    , 'SHIP_REQ'       AS MEASURE
                    , R.YYYYMMDD
                    , R.BOD_ID
                    , R.QTY
                    , R.INCOTERMS
                    , R.TRANSPORT_MODE
                    , CASE WHEN INSTR(R.FROM_SITE,'-') = 0 THEN 'P'
                      ELSE SUBSTR(R.FROM_SITE, INSTR(R.FROM_SITE,'-')+1, 1) END   AS BIZ_TYPE
                    , '-'               AS PROJECT_CODE
                    , '-'               AS FCST_TYPE
                    , R.YYYYMMDD AS FCST_ETD_DATE
                    , FN_GET_SSP_ETA_DATE(R.DIVISION_ID, R.BOD_ID, R.YYYYMMDD) AS FCST_ETA_DATE
                    , R.YYYYMMDD AS ETD_DATE
                    , FN_GET_SSP_ETA_DATE(R.DIVISION_ID, R.BOD_ID, R.YYYYMMDD) AS ETA_DATE
                    , R.ATTRIBUTE10                                            AS CONFIRM_ID
                    , V_BATCH_USER      AS CREATED_BY
                FROM   SSP_ANL_SHIP_PLAN_PACK_REQ R
                WHERE  1 = 1
                AND    R.DIVISION_ID = P_DIVISION_ID
                AND    R.QTY         > 0
                AND    R.YYYYMMDD    >= V_DATA_START_YYYYMMDD
                AND    R.YYYYMMDD    <= V_DATA_END_YYYYMMDD
               ) R
               LEFT OUTER JOIN SCP_MST_BOD_N_V  S
            ON S.INCOTERMS <> S.SSP_INCOTERMS
           AND S.DIVISION_ID = R.DIVISION_ID
           AND S.FROM_SITE   = R.FROM_SITE
           AND S.BOD_ID      = R.BOD_ID
               JOIN SCM_MST_SITE E
            ON E.DIVISION_ID = V_DIVISION_ID
           AND NVL(E.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
           AND E.DIVISION_ID = R.DIVISION_ID
           AND E.SCM_SITE_ID = R.FROM_SITE
         WHERE 1 = 1
         AND   R.DIVISION_ID = V_DIVISION_ID
         AND   R.MEASURE     = 'SHIP_REQ'
         AND   R.YYYYMMDD    >= V_DATA_START_YYYYMMDD
         AND   R.YYYYMMDD    <  V_DATA_END_YYYYMMDD
         GROUP BY R.DIVISION_ID
         ,      R.ITEM_ID
         ,      R.FROM_SITE
         ,      R.TO_SITE
         ,      R.YYYYMMDD
         ,      R.BOD_ID
         ,      NVL(S.ROUTE_ID, 0)
         ,      NVL(S.SSP_INCOTERMS, R.INCOTERMS)
         ,      R.TRANSPORT_MODE
         ,      R.BIZ_TYPE
         ,      R.PROJECT_CODE
         ,      R.FCST_TYPE
         ,      R.FCST_ETD_DATE
         ,      R.FCST_ETA_DATE
         ,      R.ETD_DATE
         ,      R.ETA_DATE
         ,      R.CONFIRM_ID
         ,      R.CREATED_BY
        ;

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 2-2. [S]SHIP_CONFIRM(Shipment Confirm): 출하 확정 수량 */
        /* ----------------------------------------------------------------------------------------------------------- */
        INSERT INTO GT_SSP_ANL_SHIP_PLAN_40
                ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID
                , FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID
                , QTY, ROUTE_ID, INCOTERMS, TRANSPORT_MODE, BIZ_TYPE
                , PROJECT_CODE, FCST_TYPE, FCST_ETD_DATE, FCST_ETA_DATE, ETD_DATE
                , ETA_DATE, CONFIRM_ID, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, ATTRIBUTE2 )
        SELECT A.DIVISION_ID
                ,A.PLAN_START_YYYYMMDD
                ,A.PLAN_TYPE
                ,A.SEQ
                ,A.ITEM_ID
                ,A.FROM_SITE
                ,A.TO_SITE
                ,A.MEASURE
                ,A.YYYYMMDD
                ,A.BOD_ID
                ,SUM(A.QTY)              AS QTY
                ,A.ROUTE_ID
                ,A.INCOTERMS
                ,A.TRANSPORT_MODE
                ,A.BIZ_TYPE
                ,A.PROJECT_CODE
                ,A.FCST_TYPE
                ,A.FCST_ETD_DATE
                ,MAX(A.FCST_ETA_DATE)    AS FCST_ETA_DATE
                ,A.ETD_DATE
                ,MAX(A.ETA_DATE)         AS ETA_DATE
                ,MAX(A.CONFIRM_ID)       AS CONFIRM_ID
                ,A.ORIGIN_FROM_DIVISION_ID
                ,A.ORIGIN_TO_DIVISION_ID
                ,MAX(A.ATTRIBUTE2)
          FROM (
                SELECT
                        C.DIVISION_ID             AS DIVISION_ID
                ,      V_PLAN_START_YYYYMMDD      AS PLAN_START_YYYYMMDD
                ,      V_PLAN_TYPE               AS PLAN_TYPE
                ,      V_SEQ                     AS SEQ
                ,      C.ITEM_ID                 AS ITEM_ID
                ,      C.FROM_SITE               AS FROM_SITE
                ,      C.TO_SITE                 AS TO_SITE
                ,      'SHIP_CONFIRM'            AS MEASURE
                ,      C.YYYYMMDD                AS YYYYMMDD
                ,      C.BOD_ID                  AS BOD_ID
                ,      C.QTY                     AS QTY
                ,      C.ROUTE_ID                AS ROUTE_ID
                ,      NVL(S.SSP_INCOTERMS, C.INCOTERMS)  AS INCOTERMS
                ,      C.TRANSPORT_MODE          AS TRANSPORT_MODE
                ,      C.BIZ_TYPE                AS BIZ_TYPE
                ,      C.PROJECT_CODE            AS PROJECT_CODE
                ,      C.FCST_TYPE               AS FCST_TYPE
                ,      C.FCST_ETD_DATE           AS FCST_ETD_DATE
                ,      C.FCST_ETA_DATE           AS FCST_ETA_DATE
                ,      C.ETD_DATE                AS ETD_DATE
                ,      C.ETA_DATE                AS ETA_DATE
                ,      C.CONFIRM_ID              AS CONFIRM_ID
                ,      C.DIVISION_ID             AS ORIGIN_FROM_DIVISION_ID
                ,      C.DIVISION_ID             AS ORIGIN_TO_DIVISION_ID
                ,      C.REQUESTOR               AS ATTRIBUTE2
                FROM   SSP_ANL_SHIP_CONFIRM  C
                       LEFT OUTER JOIN SCP_MST_BOD_N_V  S
                    ON S.INCOTERMS <> S.SSP_INCOTERMS
                   AND S.DIVISION_ID = C.DIVISION_ID
                   AND S.FROM_SITE   = C.FROM_SITE
                   AND S.BOD_ID      = C.BOD_ID
                       JOIN SCM_MST_SITE E
                    ON E.DIVISION_ID = V_DIVISION_ID
                   AND NVL(E.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
                   AND E.DIVISION_ID = C.DIVISION_ID
                   AND E.SCM_SITE_ID = C.FROM_SITE
                WHERE  C.DIVISION_ID = V_DIVISION_ID
                AND    C.CHANGE_TYPE = 'C'
                AND    C.BIZ_TYPE   <> 'E' /* 전극제외 */
                AND    C.QTY > 0
                AND    C.YYYYMMDD    >= V_DATA_START_YYYYMMDD
                AND    C.YYYYMMDD    <  V_DATA_END_YYYYMMDD

                UNION ALL

                SELECT R.DIVISION_ID
                ,      V_PLAN_START_YYYYMMDD      AS PLAN_START_YYYYMMDD
                ,      V_PLAN_TYPE               AS PLAN_TYPE
                ,      V_SEQ                     AS SEQ
                    , R.ITEM_ID
                    , R.PLANT_SITE_ID  AS FROM_SITE
                    , R.SCM_SITE_ID    AS TO_SITE
                ,      'SHIP_CONFIRM'            AS MEASURE
                    , R.YYYYMMDD
                    , R.BOD_ID
                    , R.QTY
                    , S.ROUTE_ID AS ROUTE_ID
                    , R.INCOTERMS
                    , R.TRANSPORT_MODE
                    , CASE WHEN INSTR(R.PLANT_SITE_ID,'-') = 0 THEN 'A' ELSE SUBSTR(R.PLANT_SITE_ID, INSTR(R.PLANT_SITE_ID,'-')+1, 1) END   AS BIZ_TYPE
                    , R.PROJECT_CODE
                    , R.FCST_TYPE
                    , R.YYYYMMDD AS FCST_ETD_DATE
                    , FN_GET_SSP_ETA_DATE(R.DIVISION_ID, R.BOD_ID, R.YYYYMMDD) AS FCST_ETA_DATE
                    , R.YYYYMMDD AS ETD_DATE
                    , FN_GET_SSP_ETA_DATE(R.DIVISION_ID, R.BOD_ID, R.YYYYMMDD) AS ETA_DATE
                    , R.ATTRIBUTE10                                            AS CONFIRM_ID
                ,      R.DIVISION_ID             AS ORIGIN_FROM_DIVISION_ID
                ,      R.DIVISION_ID             AS ORIGIN_TO_DIVISION_ID
                    , NULL   AS ATTRIBUTE2
                FROM   DM_PLN_SHIPMENT_REQ R
                       JOIN SCM_MST_SITE E
                    ON E.DIVISION_ID = V_DIVISION_ID
                   AND NVL(E.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
                   AND E.DIVISION_ID = R.DIVISION_ID
                   AND E.SCM_SITE_ID = R.PLANT_SITE_ID
                       JOIN SCP_MST_BOD_N_V  S
                    ON S.DIVISION_ID = R.DIVISION_ID
                   AND S.FROM_SITE   = R.PLANT_SITE_ID
                   AND S.BOD_ID      = R.BOD_ID
                WHERE  1 = 1
                AND    R.DIVISION_ID = P_DIVISION_ID
                AND    R.MEASURE     = 'SHIP_REQ'
                AND    R.QTY         > 0
                AND    R.YYYYMMDD    >= V_DATA_START_YYYYMMDD
                AND    R.YYYYMMDD    <= V_DATA_END_YYYYMMDD
                AND    R.YYYYMMDD    > (CASE WHEN NVL(FN_GET_SSP_ANL_SHIP_FROZEN(R.DIVISION_ID, R.PLANT_SITE_ID), 0) = 0 THEN V_PLAN_START_YYYYMMDD
                                        ELSE TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD,'YYYYMMDD') + (FN_GET_SSP_ANL_SHIP_FROZEN(R.DIVISION_ID, R.PLANT_SITE_ID)-1), 'YYYYMMDD') END)
                AND    R.ATTRIBUTE10 IS NULL
               ) A
         WHERE  1 = 1
         GROUP BY A.DIVISION_ID
                ,A.PLAN_START_YYYYMMDD
                ,A.PLAN_TYPE
                ,A.SEQ
                ,A.ITEM_ID
                ,A.FROM_SITE
                ,A.TO_SITE
                ,A.MEASURE
                ,A.YYYYMMDD
                ,A.BOD_ID
                ,A.ROUTE_ID
                ,A.INCOTERMS
                ,A.TRANSPORT_MODE
                ,A.BIZ_TYPE
                ,A.PROJECT_CODE
                ,A.FCST_TYPE
                ,A.FCST_ETD_DATE
                ,A.ETD_DATE
                ,A.ORIGIN_FROM_DIVISION_ID
                ,A.ORIGIN_TO_DIVISION_ID
        ;

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 2-3. [S]POSTP_PLAN (Post Process Plan): 활성화 후 공정에서 필요로 Barecell 소요량 (2019.05.15) */
        /* ----------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_SSP_FORMATION_POST_CELL;

        INSERT INTO GT_SSP_FORMATION_POST_CELL
                ( DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, MEASURE
                , YYYYMMDD, BOD_ID, QTY, INCOTERMS, TRANSPORT_MODE
                , PROJECT_CODE, FCST_TYPE, CONFIRM_ID, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID )
        /* [E20261126-POSTSS] FP_MGR.SCM_FORMATION_POST_CELL_V(@SEL$3) 의 FP_DAILY_PRODUCTIOIN_PLAN_H 를 IX01(DIVISION_ID, COMPANY_ID, PLAN_DATE) 건너뛰기 스캔. */
        /* COMPANY_ID 조건이 없어 사업부 전체 이력(사내 40 사업부 3,179,539행)을 읽던 것을 회사별 PLAN_DATE 범위만 읽음. 클라우드 11-26 회차당 34 ~ 42초(6fv7933qvycp9) */
        SELECT  /*+ INDEX_SS(@SEL$3 DPP IX01_FP_DAILY_PRODUCTIOIN_PLAN_H) */
                P.DIVISION_ID               AS DIVISION_ID
        ,       NVL(IM.APPLIED_MODEL, P.CELL_ITEM_ID) AS ITEM_ID
        ,       P.SCM_SITE_ID               AS FROM_SITE
        ,       '-'                         AS TO_SITE
        ,       'POSTP_PLAN'                AS MEASURE
        ,       P.PLAN_DATE                 AS YYYYMMDD
        ,       '-'                         AS BOD_ID
        ,       P.PLAN_QTY                  AS QTY
        ,       '-'                         AS INCOTERMS
        ,       '-'                         AS TRANSPORT_MODE
        ,       '-'                         AS PROJECT_CODE
        ,       '-'                         AS FCST_TYPE
        ,       '-'                         AS CONFIRM_ID
        ,       P.DIVISION_ID               AS ORIGIN_FROM_DIVISION_ID
        ,       P.DIVISION_ID               AS ORIGIN_TO_DIVISION_ID
          FROM  SSP_FORMATION_POST_CELL_V P
                JOIN SCM_MST_SITE E
             ON E.DIVISION_ID = V_DIVISION_ID
            AND NVL(E.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
            AND E.DIVISION_ID = P.DIVISION_ID
            AND E.SCM_SITE_ID = P.SCM_SITE_ID
                LEFT OUTER JOIN SCM_MST_ITEM_SN IM
             ON IM.DIVISION_ID = P.DIVISION_ID
            AND IM.COMPANY_ID = V_COMPANY_ID
            AND IM.SITE_ID = P.SITE_ID
            AND IM.ITEM_ID = P.CELL_ITEM_ID
            AND IM.ITEM_CLASS IN ('ES1901', 'ES2001','ES2002', 'ES2003', 'ES2004')
         WHERE  P.DIVISION_ID = V_DIVISION_ID
        ;

        INSERT INTO GT_SSP_ANL_SHIP_PLAN_40
                ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID
                , FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID
                , QTY, INCOTERMS, TRANSPORT_MODE, PROJECT_CODE, FCST_TYPE
                , CONFIRM_ID, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID )
        SELECT  DIVISION_ID                 AS DIVISION_ID
        ,       V_PLAN_START_YYYYMMDD       AS PLAN_START_YYYYMMDD
        ,       V_PLAN_TYPE                 AS PLAN_TYPE
        ,       V_SEQ                       AS SEQ
        ,       ITEM_ID                     AS ITEM_ID
        ,       FROM_SITE                   AS FROM_SITE
        ,       '-'                         AS TO_SITE
        ,       'POSTP_PLAN'                AS MEASURE
        ,       YYYYMMDD                    AS YYYYMMDD
        ,       '-'                         AS BOD_ID
        ,       SUM(QTY)                    AS QTY
        ,       '-'                         AS INCOTERMS
        ,       '-'                         AS TRANSPORT_MODE
        ,       '-'                         AS PROJECT_CODE
        ,       '-'                         AS FCST_TYPE
        ,       '-'                         AS CONFIRM_ID
        ,       DIVISION_ID                 AS ORIGIN_FROM_DIVISION_ID
        ,       DIVISION_ID                 AS ORIGIN_TO_DIVISION_ID
          FROM  GT_SSP_FORMATION_POST_CELL
         WHERE  DIVISION_ID =  V_DIVISION_ID
         AND    YYYYMMDD    >= V_DATA_START_YYYYMMDD
         AND    YYYYMMDD    <  V_DATA_END_YYYYMMDD
         GROUP BY DIVISION_ID
         ,        ITEM_ID
         ,        FROM_SITE
         ,        YYYYMMDD
        ;

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 2-4. [P]PROD_PLAN(Production) : 조립실적+계획(활성화 L/T, 수율 적용) */
        /* ----------------------------------------------------------------------------------------------------------- */
        /* MES Lot별 실적 정보 (LOT_ID를 날짜로 환산하여 수량 적용) */
        DELETE FROM GT_SSP_MES_WIP_HISTORY;

        INSERT INTO GT_SSP_MES_WIP_HISTORY (
                 DIVISION_ID, SCM_SITE_ID, ITEM_ID, PLAN_DATE, LOT
                ,QTY, OPERATION_ID, PRODUCTION_TYPE )
        -- 2026.11.17 ZIONEX (START)
        SELECT A.DIVISION_ID
             , A.SCM_SITE_ID
             , NVL(C.APPLIED_MODEL, A.ITEM_ID)                                    AS ITEM_ID
             , A.PLAN_DATE
             , A.LOT
             , A.QTY
             , A.OPERATION_ID
             , A.PRODUCTION_TYPE
          FROM (SELECT IA.DIVISION_ID
                     , FN_GET_SCM_SITE_ID_PLANT(IA.PLANT_ID, FN_GET_ITEM_OPERATION_GROUP(IA.DIVISION_ID, IA.ITEM_ID)) AS SCM_SITE_ID
                     , IA.ITEM_ID
                     , TO_DATE(LY.SEGMENT2 || LM.SEGMENT2 || SUBSTR(IA.LOT, 3, 2), 'YYYYMMDD') AS PLAN_DATE
                     , IA.LOT
                     , SUM(IA.QTY)                                                AS QTY
                     , IA.OPERATION_ID
                     , IA.PRODUCTION_TYPE
                  FROM (SELECT /*+ NO_MERGE LEADING(S R) USE_HASH(R) FULL(R) */
                               S.DIVISION_ID
                             , S.PLANT_ID
                             , R.PRODID                                           AS ITEM_ID
                             , SUBSTR(R.ATTRIBUTE7, 4, 4)                         AS LOT      /* LOT_ID */
                             , R.PROCID                                           AS OPERATION_ID
                             , R.ATTRIBUTE6                                       AS PRODUCTION_TYPE
                             , SUM(R.WIPQTY2_ENGINE)                              AS QTY      /* FP 반영 양품 Out 수량 */
                          FROM SCM_MST_FACTORY_SN       S
                             , SCM_MES_WIP_HISTORY_H_SN R
                         WHERE R.ATTRIBUTE1     = S.SITE_ID
                           AND R.ATTRIBUTE2     = S.FACTORY_ID
                           AND R.PROCID         = 'A3000'
                           AND R.WIP_TYPE_CODE IN ('OUT', 'INOUT', 'PACKED', 'PROD')
                           AND R.ATTRIBUTE7    IS NOT NULL
                           AND R.WIPQTY2_ENGINE > 0
                           AND S.DIVISION_ID    = V_DIVISION_ID
                         GROUP BY S.DIVISION_ID
                                , S.PLANT_ID
                                , R.PRODID
                                , SUBSTR(R.ATTRIBUTE7, 4, 4)
                                , R.PROCID
                                , R.ATTRIBUTE6
                       ) IA
                     , SCM_ADM_LOOKUP_MASTER_DETAIL LY
                     , SCM_ADM_LOOKUP_MASTER_DETAIL LM
                     , SCM_SYS_CALENDAR_M           CA   /* 유효한 날짜만 추출 */
                 WHERE LY.SEGMENT1       = SUBSTR(IA.LOT, 1, 1)
                   AND LM.SEGMENT1       = SUBSTR(IA.LOT, 2, 1)
                   AND CA.BASIS_YYYYMMDD = LY.SEGMENT2 || LM.SEGMENT2 || SUBSTR(IA.LOT, 3, 2)
                   AND LY.LOOKUP_TYPE    = 'LOT_ID_YEAR'
                   AND LY.VALID_YN       = 'Y'
                   AND LY.SEGMENT2 BETWEEN TO_CHAR(ADD_MONTHS(SYSDATE, -132), 'YYYY') AND TO_CHAR(ADD_MONTHS(SYSDATE, 96), 'YYYY')
                   AND LM.LOOKUP_TYPE    = 'LOT_ID_MONTH'
                   AND LM.VALID_YN       = 'Y'
                 GROUP BY IA.DIVISION_ID
                        , IA.PLANT_ID
                        , IA.ITEM_ID
                        , TO_DATE(LY.SEGMENT2 || LM.SEGMENT2 || SUBSTR(IA.LOT, 3, 2), 'YYYYMMDD')
                        , IA.LOT
                        , IA.OPERATION_ID
                        , IA.PRODUCTION_TYPE
               ) A
             , SCM_MST_SITE    B
             , SCM_MST_ITEM_SN C
         WHERE B.DIVISION_ID           = A.DIVISION_ID
           AND B.SCM_SITE_ID           = A.SCM_SITE_ID
           AND C.DIVISION_ID(+)        = A.DIVISION_ID
           AND C.SITE_ID(+)            = B.SITE_ID
           AND C.ITEM_ID(+)            = A.ITEM_ID
           AND C.COMPANY_ID(+)         = V_COMPANY_ID
           AND C.ITEM_CLASS(+)        IN ('ES1901', 'ES2001', 'ES2002', 'ES2003', 'ES2004')
           AND B.DIVISION_ID           = V_DIVISION_ID
           AND NVL(B.COMPANY_ID, '-')  = NVL(V_COMPANY_ID, '-')
        ;
        -- 2026.11.17 ZIONEX (END)
        /*        
        SELECT   A.DIVISION_ID
                ,A.SCM_SITE_ID
                ,NVL(IM.APPLIED_MODEL, A.ITEM_ID) AS ITEM_ID
                ,A.PLAN_DATE
                ,A.LOT
                ,A.QTY
                ,A.OPERATION_ID
                ,A.PRODUCTION_TYPE
          FROM (
                SELECT S.DIVISION_ID    AS DIVISION_ID
                ,      FN_GET_SCM_SITE_ID_PLANT (S.PLANT_ID, FN_GET_ITEM_OPERATION_GROUP(S.DIVISION_ID, R.PRODID) )  AS SCM_SITE_ID
                ,      R.PRODID AS ITEM_ID
                ,      TO_DATE(LY.SEGMENT2 || LM.SEGMENT2 || SUBSTR(R.ATTRIBUTE7,6,2), 'YYYYMMDD') AS PLAN_DATE
                ,      SUBSTR(R.ATTRIBUTE7,4,4) AS LOT  /* LOT_ID * /
                ,      SUM(R.WIPQTY2_ENGINE)   AS QTY      /* FP 반영 양품 Out 수량 * /
                ,      R.PROCID  AS OPERATION_ID
                ,      R.ATTRIBUTE6 AS PRODUCTION_TYPE
                FROM SCM_MES_WIP_HISTORY_H_SN R
                     JOIN SCM_MST_FACTORY_SN S
                        ON S.SITE_ID = R.ATTRIBUTE1
                        AND S.FACTORY_ID = R.ATTRIBUTE2
                     JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LY
                        ON  LY.LOOKUP_TYPE = 'LOT_ID_YEAR'
                        AND LY.VALID_YN    = 'Y'
                        AND LY.SEGMENT1    = SUBSTR(R.ATTRIBUTE7,4,1)
                        AND LY.SEGMENT2 BETWEEN TO_CHAR(ADD_MONTHS(SYSDATE,-132),'YYYY') AND TO_CHAR(ADD_MONTHS(SYSDATE,96),'YYYY')
                     JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LM
                        ON  LM.LOOKUP_TYPE = 'LOT_ID_MONTH'
                        AND LM.VALID_YN    = 'Y' 
                        AND LM.SEGMENT1    = SUBSTR(R.ATTRIBUTE7,5,1)
                     JOIN SCM_SYS_CALENDAR_M    C /* 유효한 날짜만 추출 * /
                        ON C.BASIS_YYYYMMDD = LY.SEGMENT2 || LM.SEGMENT2 || SUBSTR(R.ATTRIBUTE7,6,2)
                WHERE  R.PROCID = 'A3000'
                AND    R.WIP_TYPE_CODE IN ( 'OUT','INOUT','PACKED', 'PROD')
                AND    R.ATTRIBUTE7 IS NOT NULL
                AND    R.WIPQTY2_ENGINE > 0
                AND    S.DIVISION_ID = V_DIVISION_ID
                GROUP BY S.DIVISION_ID
                ,        S.PLANT_ID
                ,        R.PRODID
                ,        TO_DATE(LY.SEGMENT2 || LM.SEGMENT2 || SUBSTR(R.ATTRIBUTE7,6,2), 'YYYYMMDD')
                ,        SUBSTR(R.ATTRIBUTE7,4,4)
                ,        R.PROCID
                ,        R.ATTRIBUTE6 /* PRODUCTION_TYPE * /
               ) A
               JOIN SCM_MST_SITE E
            ON E.DIVISION_ID = V_DIVISION_ID
           AND NVL(E.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
           AND E.DIVISION_ID = A.DIVISION_ID
           AND E.SCM_SITE_ID = A.SCM_SITE_ID
               LEFT OUTER JOIN SCM_MST_ITEM_SN IM
            ON IM.DIVISION_ID = A.DIVISION_ID
           AND IM.COMPANY_ID = V_COMPANY_ID
           AND IM.SITE_ID = E.SITE_ID
           AND IM.ITEM_ID = A.ITEM_ID
           AND IM.ITEM_CLASS IN ('ES1901', 'ES2001','ES2002', 'ES2003', 'ES2004')
         WHERE  1 = 1
        ;*/
        
        -- 2026.11.18 ZIONEX (START)
        /* 특성계획(F5400 F5500 F5600) 1회 적재 : 1680행 NOT EXISTS 3곳 · 특성계획 분기 공통 원천 */
        DELETE FROM GT_SSP_PLAN_FROZEN_POUCH;

        INSERT INTO GT_SSP_PLAN_FROZEN_POUCH
              ( DIVISION_ID
              , SCM_SITE_ID
              , ITEM_ID
              , OPERATION_ID
              , PLAN_DATE
              , PLAN_QTY
              , FP_PRODUCTION_TYPE
              )
        SELECT DIVISION_ID
             , SCM_SITE_ID
             , ITEM_ID
             , OPERATION_ID
             , PLAN_DATE
             , PLAN_QTY
             , FP_PRODUCTION_TYPE
          FROM SSP_DNM_PLAN_FROZEN_V
         WHERE DIVISION_ID   = V_DIVISION_ID
           AND SCM_SITE_ID  IS NOT NULL
           AND PLAN_QTY      > 0
           AND PLAN_DATE    >= TO_DATE(V_DATA_START_YYYYMMDD, 'YYYYMMDD')
           AND PLAN_DATE     < TO_DATE(V_DATA_END_YYYYMMDD, 'YYYYMMDD')
        ;
        -- 2026.11.18 ZIONEX (END)

        /* jilee 230830 생산코드 복수일때 모델코드 같은 경우 중복 Merge 를 위한 임시 테이블 */
        DELETE FROM GT_SSP_ANL_SHIP_PLAN_40_TEMP;

        /* PROD_PLAN Data 생성 */
        INSERT INTO GT_SSP_ANL_SHIP_PLAN_40_TEMP
                ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID
                , FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID
                , QTY, INCOTERMS, TRANSPORT_MODE, PROJECT_CODE, FCST_TYPE
                , CONFIRM_ID, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, ATTRIBUTE1, ATTRIBUTE4, ATTRIBUTE5 )
        SELECT  X.DIVISION_ID               AS DIVISION_ID
        ,       V_PLAN_START_YYYYMMDD       AS PLAN_START_YYYYMMDD
        ,       V_PLAN_TYPE                 AS PLAN_TYPE
        ,       V_SEQ                       AS SEQ
        ,       NVL(IM.APPLIED_MODEL, X.ITEM_ID) AS ITEM_ID
        ,       X.FROM_SITE                 AS FROM_SITE
        ,       '-'                         AS TO_SITE
        ,       'PROD_PLAN'                 AS MEASURE
        ,       X.YYYYMMDD                  AS YYYYMMDD
        ,       '-'                         AS BOD_ID
        ,       ROUND(SUM(X.QTY) ,0 )       AS QTY
        ,       '-'                         AS INCOTERMS
        ,       '-'                         AS TRANSPORT_MODE
        ,       '-'                         AS PROJECT_CODE
        ,       '-'                         AS FCST_TYPE
        ,       '-'                         AS CONFIRM_ID
        ,       X.DIVISION_ID               AS ORIGIN_FROM_DIVISION_ID
        ,       X.DIVISION_ID               AS ORIGIN_TO_DIVISION_ID
        ,       TO_CHAR(MAX(X.PRD_YYYYMMDD), 'YYYYMMDD')  AS ATTRIBUTE1
        ,       ROUND(SUM(CASE WHEN NVL(X.PRODUCTION_TYPE,'MASS') = 'MASS' THEN X.QTY ELSE 0 END), 0)  AS ATTRIBUTE4 /* Prod Qty(MASS) */
        ,       ROUND(SUM(X.QTY) ,0 )       AS ATTRIBUTE5  /* Prod Qty(ALL) */
        FROM  (
               /* ------------------------------------------------------------------------------------------------------------- */
               /* 실적 : MES-LOT별실적(RESULT_MES_LOT) : A3000 */
               /* ------------------------------------------------------------------------------------------------------------- */
                SELECT R.DIVISION_ID, R.FROM_SITE, R.ITEM_ID, R.TYPE, R.YYYYMMDD, R.PRD_YYYYMMDD, R.QTY, R.OPERATION_ID, R.PRODUCTION_TYPE
                FROM   (
                        SELECT R.DIVISION_ID                            AS DIVISION_ID
                        ,      R.SCM_SITE_ID                            AS FROM_SITE
                        ,      R.ITEM_ID                                AS ITEM_ID
                        ,      'MES_LOT_RESULT'                         AS TYPE
                        ,      CASE WHEN X.SEGMENT2 IS NULL THEN TO_CHAR(R.PLAN_DATE + (NVL(F.LT_FORMATION,0) + NVL(F.ATTRIBUTE1,0)) , 'YYYYMMDD')
                               ELSE TO_CHAR(R.PLAN_DATE + TO_NUMBER(X.SEGMENT2), 'YYYYMMDD') END  AS YYYYMMDD
                        ,      R.PLAN_DATE                              AS PRD_YYYYMMDD
                        ,      R.QTY * NVL(F.SSP_MODIFY_YIELD ,1)       AS QTY
                        ,      R.OPERATION_ID                           AS OPERATION_ID
                        ,      R.PRODUCTION_TYPE                        AS PRODUCTION_TYPE
                        FROM   GT_SSP_MES_WIP_HISTORY R
                               LEFT OUTER JOIN SSP_ANL_FORMATION_C F
                                       ON  F.DIVISION_ID         = R.DIVISION_ID
                                      AND F.PLANT_SITE_ID       = R.SCM_SITE_ID
                                      AND F.ITEM_ID             = R.ITEM_ID
                                      AND F.DIVISION_ID         = V_DIVISION_ID
                                      AND F.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                      AND F.PLAN_TYPE           = V_PLAN_TYPE
                                      AND F.SEQ                 = V_SEQ
                               LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL  X
                                ON  X.LOOKUP_TYPE = 'POUCH_WH_IN_DAY'
                               AND  X.VALID_YN    = 'Y'
                               AND  X.SEGMENT1    = SUBSTR(R.ITEM_ID, 1, 3)
                               AND  X.SEGMENT3    = '-'
                               AND  X.SEGMENT4    = '-'
                               AND  X.SEGMENT5    = '-'
                        WHERE 1 = 1
                        AND   R.DIVISION_ID = V_DIVISION_ID
                        AND   R.OPERATION_ID = 'A3000'
                        AND   R.PLAN_DATE < TRUNC(SYSDATE)
                       ) R
                WHERE  R.YYYYMMDD  >=  V_DATA_START_YYYYMMDD
                AND    R.YYYYMMDD  <   V_DATA_END_YYYYMMDD
                /* CNJ Pouch 특성실적과 중복되는건 제외(2019.05.17) */
                AND    NOT EXISTS ( SELECT 1
                                    FROM   SCM_DNM_PRODUCT_RESULT_V A
                                    WHERE  A.DIVISION_ID = V_DIVISION_ID
                                    AND    A.SCM_SITE_ID IS NOT NULL
                                    AND    A.PLAN_DATE >= TRUNC(SYSDATE - 2)
                                    AND    A.PLAN_DATE  < TO_DATE(V_DATA_START_YYYYMMDD, 'YYYYMMDD')
                                    AND    A.OPERATION_ID IN  ('F5400','F5500','F5600')
                                    AND    A.QTY > 0
                                    AND    A.DIVISION_ID = R.DIVISION_ID
                                    AND    A.ITEM_ID     = R.ITEM_ID
                                    AND    A.SCM_SITE_ID = R.FROM_SITE
                                    )
                /* CNJ Pouch 특성계획과 중복되는건 제외(2019.05.28) */
                AND    NOT EXISTS ( SELECT 1
                                    FROM   GT_SSP_PLAN_FROZEN_POUCH A  -- 2026.11.18 ZIONEX --속도 이슈로 SSP_DNM_PLAN_FROZEN_V 를 GTT로 변경
                                    WHERE  A.DIVISION_ID = V_DIVISION_ID
                                    AND    A.SCM_SITE_ID IS NOT NULL
                                    AND    A.OPERATION_ID IN  ('F5400','F5500','F5600')
                                    AND    A.PLAN_QTY > 0
                                    AND    A.PLAN_DATE >= TO_DATE(V_DATA_START_YYYYMMDD, 'YYYYMMDD')
                                    AND    A.PLAN_DATE  < TO_DATE(V_DATA_END_YYYYMMDD, 'YYYYMMDD')
                                    AND    A.DIVISION_ID = R.DIVISION_ID
                                    AND    A.ITEM_ID     = R.ITEM_ID
                                    AND    A.SCM_SITE_ID = R.FROM_SITE
                                    )

                UNION ALL
               /* ------------------------------------------------------------------------------------------------------------- */
               /* 실적 : 조립실적(RESULT_FP_ASSY) : A9000 F6200 F7000 F7100 F7200 F7300 / 모듈실적 : P5000 */
               /* ------------------------------------------------------------------------------------------------------------- */
                SELECT R.DIVISION_ID, R.FROM_SITE, R.ITEM_ID, R.TYPE, R.YYYYMMDD, R.PRD_YYYYMMDD, R.QTY, R.OPERATION_ID, R.PRODUCTION_TYPE
                FROM   (
                        SELECT R.DIVISION_ID                              AS DIVISION_ID
                        ,      R.SCM_SITE_ID                              AS FROM_SITE
                        ,      R.ITEM_ID                                  AS ITEM_ID
                        ,      'RESULT_FP_ASSY'                           AS TYPE
                        ,      CASE WHEN X.SEGMENT2 IS NULL THEN TO_CHAR(R.PLAN_DATE + (NVL(F.LT_FORMATION,0) + NVL(F.ATTRIBUTE1,0)) , 'YYYYMMDD')
                               ELSE TO_CHAR(R.PLAN_DATE + TO_NUMBER(X.SEGMENT2), 'YYYYMMDD') END  AS YYYYMMDD
                        ,      R.PLAN_DATE                                AS PRD_YYYYMMDD
                        ,      R.QTY * NVL(F.SSP_MODIFY_YIELD ,1)         AS QTY
                        ,      R.OPERATION_ID                             AS OPERATION_ID
                        ,      R.PRODUCTION_TYPE                          AS PRODUCTION_TYPE
                        FROM   SCM_DNM_PRODUCT_RESULT_V R
                               LEFT OUTER JOIN SSP_ANL_FORMATION_C F
                                        ON F.DIVISION_ID         = R.DIVISION_ID
                                       AND F.PLANT_SITE_ID       = R.SCM_SITE_ID
                                       AND F.ITEM_ID             = R.ITEM_ID
                                       AND F.DIVISION_ID         = V_DIVISION_ID
                                       AND F.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                       AND F.PLAN_TYPE           = V_PLAN_TYPE
                                       AND F.SEQ                 = V_SEQ
                               LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL  X
                                ON  X.LOOKUP_TYPE = 'POUCH_WH_IN_DAY'
                               AND  X.VALID_YN    = 'Y'
                               AND  X.SEGMENT1    = SUBSTR(R.ITEM_ID, 1, 3)
                               AND  X.SEGMENT3    = '-'
                               AND  X.SEGMENT4    = '-'
                               AND  X.SEGMENT5    = '-'
                        WHERE  R.DIVISION_ID = V_DIVISION_ID
                        AND    R.SCM_SITE_ID IS NOT NULL
                        AND    R.PLAN_DATE >= TRUNC(SYSDATE - 150)
                        AND    R.OPERATION_ID IN  ('A9000','F7000','F7100','F7200','F7300' ,'F6200', 'P5000')
                        AND    R.QTY > 0
                       ) R
                WHERE  R.YYYYMMDD  >=  V_DATA_START_YYYYMMDD
                AND    R.YYYYMMDD  <   V_DATA_END_YYYYMMDD
                AND    NOT EXISTS ( SELECT 1
                                    FROM   SCM_DNM_PRODUCT_RESULT_V A
                                    WHERE  A.DIVISION_ID = V_DIVISION_ID
                                    AND    A.SCM_SITE_ID IS NOT NULL
                                    AND    A.PLAN_DATE >= TRUNC(SYSDATE - 2)
                                    AND    A.PLAN_DATE  < TO_DATE(V_DATA_START_YYYYMMDD, 'YYYYMMDD')
                                    AND    A.OPERATION_ID IN  ('F5400','F5500','F5600')
                                    AND    A.QTY > 0
                                    AND    A.DIVISION_ID = R.DIVISION_ID
                                    AND    A.ITEM_ID     = R.ITEM_ID
                                    AND    A.SCM_SITE_ID = R.FROM_SITE
                                    )
                AND    NOT EXISTS ( SELECT 1
                                    FROM   GT_SSP_PLAN_FROZEN_POUCH A  -- 2026.11.18 ZIONEX --속도 이슈로 SSP_DNM_PLAN_FROZEN_V 를 GTT로 변경
                                    WHERE  A.DIVISION_ID = V_DIVISION_ID
                                    AND    A.SCM_SITE_ID IS NOT NULL
                                    AND    A.OPERATION_ID IN  ('F5400','F5500','F5600')
                                    AND    A.PLAN_QTY > 0
                                    AND    A.PLAN_DATE >= TO_DATE(V_DATA_START_YYYYMMDD, 'YYYYMMDD')
                                    AND    A.PLAN_DATE  < TO_DATE(V_DATA_END_YYYYMMDD, 'YYYYMMDD')
                                    AND    A.DIVISION_ID = R.DIVISION_ID
                                    AND    A.ITEM_ID     = R.ITEM_ID
                                    AND    A.SCM_SITE_ID = R.FROM_SITE
                                    )
                /* A3000 MES실적 중복되는건 제외(2019.09.17) */
                AND    NOT EXISTS ( SELECT 1
                                    FROM   GT_SSP_MES_WIP_HISTORY A
                                    WHERE  A.DIVISION_ID = V_DIVISION_ID
                                    AND    A.SCM_SITE_ID IS NOT NULL
                                    AND    A.PLAN_DATE >= TRUNC(SYSDATE - 2)
                                    AND    A.PLAN_DATE  < TO_DATE(V_DATA_START_YYYYMMDD, 'YYYYMMDD')
                                    AND    A.OPERATION_ID ='A3000'
                                    AND    A.QTY > 0
                                    AND    A.DIVISION_ID = R.DIVISION_ID
                                    AND    A.ITEM_ID     = R.ITEM_ID
                                    AND    A.SCM_SITE_ID = R.FROM_SITE
                                    )

                UNION ALL
               /* ------------------------------------------------------------------------------------------------------------- */
               /* 실적 : 특성실적(RESULT_FP_POUCH) : F5400 F5500 F5600 */
               /* ------------------------------------------------------------------------------------------------------------- */
                SELECT R.DIVISION_ID                              AS DIVISION_ID
                ,      R.SCM_SITE_ID                              AS FROM_SITE
                ,      R.ITEM_ID                                  AS ITEM_ID
                ,      'RESULT_FP_POUCH'                          AS TYPE
                ,      TO_CHAR(R.PLAN_DATE + 2, 'YYYYMMDD')       AS YYYYMMDD
                ,      R.PLAN_DATE                                AS PRD_YYYYMMDD
                ,      R.QTY                                      AS QTY
                ,      R.OPERATION_ID                             AS OPERATION_ID
                ,      R.PRODUCTION_TYPE                          AS PRODUCTION_TYPE
                FROM   SCM_DNM_PRODUCT_RESULT_V R
                WHERE  R.DIVISION_ID = V_DIVISION_ID
                AND    R.SCM_SITE_ID IS NOT NULL
                AND    R.PLAN_DATE >= TRUNC(SYSDATE - 2)
                AND    R.PLAN_DATE  < TO_DATE(V_DATA_START_YYYYMMDD, 'YYYYMMDD')
                AND    R.OPERATION_ID IN  ('F5400','F5500','F5600')
                AND    R.QTY > 0

                UNION ALL
               /* ------------------------------------------------------------------------------------------------------------- */
               /* 계획 : 조립계획(PLAN_FP_ASSY) : A3000 A9000 F6200 F7000 F7100 F7200 F7300 / 모듈계획 : P5500 */
               /* ------------------------------------------------------------------------------------------------------------- */
                SELECT R.DIVISION_ID, R.FROM_SITE, R.ITEM_ID, R.TYPE, R.YYYYMMDD, R.PRD_YYYYMMDD, R.QTY, R.OPERATION_ID, R.PRODUCTION_TYPE
                FROM   (
                        SELECT P.DIVISION_ID                              AS DIVISION_ID
                        ,      P.SCM_SITE_ID                              AS FROM_SITE
                        ,      P.ITEM_ID                                  AS ITEM_ID
                        ,      'PLAN_FP_ASSY'                             AS TYPE
                        ,      CASE WHEN X.SEGMENT2 IS NULL THEN TO_CHAR(P.PLAN_DATE + (NVL(F.LT_FORMATION,0) + NVL(F.ATTRIBUTE1,0)) , 'YYYYMMDD')
                               ELSE TO_CHAR(P.PLAN_DATE + TO_NUMBER(X.SEGMENT2), 'YYYYMMDD') END  AS YYYYMMDD
                        ,      P.PLAN_DATE                                AS PRD_YYYYMMDD
                        ,      P.PLAN_QTY * NVL(F.SSP_MODIFY_YIELD ,1)    AS QTY
                        ,      P.OPERATION_ID                             AS OPERATION_ID
                        ,      P.FP_PRODUCTION_TYPE                       AS PRODUCTION_TYPE
                        FROM   GT_SSP_PLAN_FROZEN_POUCH P  -- 2026.11.18 ZIONEX --속도 이슈로 SSP_DNM_PLAN_FROZEN_V 를 GTT로 변경
                               LEFT OUTER JOIN SSP_ANL_FORMATION_C F
                                        ON F.DIVISION_ID         = P.DIVISION_ID
                                       AND F.PLANT_SITE_ID       = P.SCM_SITE_ID
                                       AND F.ITEM_ID             = P.ITEM_ID
                                       AND F.DIVISION_ID         = V_DIVISION_ID
                                       AND F.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                       AND F.PLAN_TYPE           = V_PLAN_TYPE
                                       AND F.SEQ                 = V_SEQ
                               LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL  X
                                ON  X.LOOKUP_TYPE = 'POUCH_WH_IN_DAY'
                               AND  X.VALID_YN    = 'Y'
                               AND  X.SEGMENT1    = SUBSTR(P.ITEM_ID, 1, 3)
                               AND  X.SEGMENT3    = '-'
                               AND  X.SEGMENT4    = '-'
                               AND  X.SEGMENT5    = '-'
                        WHERE  P.DIVISION_ID = V_DIVISION_ID
                        AND    P.SCM_SITE_ID IS NOT NULL
                        AND    P.OPERATION_ID IN  ('A3000', 'A9000' ,'F7000','F7100','F7200','F7300','F6200', 'P5500')
                        AND    P.PLAN_QTY > 0
                        AND    P.PLAN_DATE >= TRUNC(SYSDATE)
                       ) R
                WHERE  R.YYYYMMDD  >=  V_DATA_START_YYYYMMDD
                AND    R.YYYYMMDD  <   V_DATA_END_YYYYMMDD
                AND    NOT EXISTS ( SELECT 1
                                    FROM   SCM_DNM_PRODUCT_RESULT_V  A
                                    WHERE  A.DIVISION_ID = V_DIVISION_ID
                                    AND    A.PLAN_DATE >= TRUNC(SYSDATE - 2)
                                    AND    A.PLAN_DATE  < TO_DATE(V_DATA_START_YYYYMMDD, 'YYYYMMDD')
                                    AND    A.OPERATION_ID IN  ('F5400','F5500','F5600')
                                    AND    A.QTY > 0
                                    AND    A.DIVISION_ID = R.DIVISION_ID
                                    AND    A.ITEM_ID     = R.ITEM_ID
                                    AND    A.SCM_SITE_ID = R.FROM_SITE
                                    )
                AND    NOT EXISTS ( SELECT 1
                                    FROM   GT_SSP_PLAN_FROZEN_POUCH A  -- 2026.11.18 ZIONEX --속도 이슈로 SSP_DNM_PLAN_FROZEN_V 를 GTT로 변경
                                    WHERE  A.DIVISION_ID = V_DIVISION_ID
                                    AND    A.SCM_SITE_ID IS NOT NULL
                                    AND    A.OPERATION_ID IN  ('F5400','F5500','F5600')
                                    AND    A.PLAN_QTY > 0
                                    AND    A.PLAN_DATE >= TO_DATE(V_DATA_START_YYYYMMDD, 'YYYYMMDD')
                                    AND    A.PLAN_DATE  < TO_DATE(V_DATA_END_YYYYMMDD, 'YYYYMMDD')
                                    AND    A.DIVISION_ID = R.DIVISION_ID
                                    AND    A.ITEM_ID     = R.ITEM_ID
                                    AND    A.SCM_SITE_ID = R.FROM_SITE
                                    )

                UNION ALL
               /* ------------------------------------------------------------------------------------------------------------- */
               /* 계획 : 특성계획(PLAN_FP_POUCH) : F5400 F5500 F5600 */
               /* ------------------------------------------------------------------------------------------------------------- */
                SELECT P.DIVISION_ID                              AS DIVISION_ID
                ,      P.SCM_SITE_ID                              AS FROM_SITE
                ,      P.ITEM_ID                                  AS ITEM_ID
                ,      'PLAN_FP_POUCH'                            AS TYPE
                ,      TO_CHAR(P.PLAN_DATE + 2, 'YYYYMMDD')       AS YYYYMMDD
                ,      P.PLAN_DATE                                AS PRD_YYYYMMDD
                ,      P.PLAN_QTY * NVL(F.SSP_MODIFY_YIELD ,1)    AS QTY
                ,      P.OPERATION_ID                             AS OPERATION_ID
                ,      P.FP_PRODUCTION_TYPE                       AS PRODUCTION_TYPE
                FROM   GT_SSP_PLAN_FROZEN_POUCH P -- 2026.11.18 ZIONEX --속도 이슈로 SSP_DNM_PLAN_FROZEN_V 를 GTT로 변경
                       LEFT OUTER JOIN SSP_ANL_FORMATION_C F
                                ON F.DIVISION_ID         = P.DIVISION_ID
                               AND F.PLANT_SITE_ID       = P.SCM_SITE_ID
                               AND F.ITEM_ID             = P.ITEM_ID
                               AND F.DIVISION_ID         = V_DIVISION_ID
                               AND F.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                               AND F.PLAN_TYPE           = V_PLAN_TYPE
                               AND F.SEQ                 = V_SEQ
                WHERE  P.DIVISION_ID = V_DIVISION_ID
                AND    P.SCM_SITE_ID IS NOT NULL
                AND    P.OPERATION_ID IN  ('F5400','F5500','F5600')
                AND    P.PLAN_QTY > 0
                AND    P.PLAN_DATE >= TO_DATE(V_DATA_START_YYYYMMDD, 'YYYYMMDD')
                AND    P.PLAN_DATE  < TO_DATE(V_DATA_END_YYYYMMDD, 'YYYYMMDD')

                UNION ALL
               /* ------------------------------------------------------------------------------------------------------------- */
               /* 계획 : 외주생산계획 (PLAN_SSP_OSP) : SSP0018 화면 입력 계획 (남경 G182-A) */
               /* ------------------------------------------------------------------------------------------------------------- */
                SELECT R.DIVISION_ID, R.FROM_SITE, R.ITEM_ID, R.TYPE, R.YYYYMMDD, R.PRD_YYYYMMDD, R.QTY, R.OPERATION_ID, R.PRODUCTION_TYPE
                FROM   (
                        SELECT P.DIVISION_ID                              AS DIVISION_ID
                        ,      V_G182A                                    AS FROM_SITE
                        ,      P.ITEM_ID                                  AS ITEM_ID
                        ,      'PLAN_SSP_OSP'                             AS TYPE
                        /*                           MSSQL `varchar + int` = 정수연산 -> yyyymmdd 를 정수로 보고 L/T 일수 가산(월경계 미보정). PRD_YYYYMMDD 는 UNION DATE 정합 위해 TO_DATE. */
                        ,      CASE WHEN X.SEGMENT2 IS NULL THEN TO_CHAR(TO_NUMBER(P.YYYYMMDD) + (NVL(F.LT_FORMATION,0) + NVL(F.ATTRIBUTE1,0)))
                               ELSE TO_CHAR(TO_NUMBER(P.YYYYMMDD) + TO_NUMBER(X.SEGMENT2)) END  AS YYYYMMDD
                        ,      TO_DATE(P.YYYYMMDD, 'YYYYMMDD')            AS PRD_YYYYMMDD
                        ,      P.QTY * NVL(F.SSP_MODIFY_YIELD ,1)         AS QTY
                        ,      NULL                                       AS OPERATION_ID
                        ,      NULL                                       AS PRODUCTION_TYPE
                        FROM   SSP_ANL_PROD_PLAN_OSP P
                               LEFT OUTER JOIN SSP_ANL_FORMATION_C F
                                        ON F.DIVISION_ID         = P.DIVISION_ID
                                       AND F.PLANT_SITE_ID       = V_G182A
                                       AND F.ITEM_ID             = P.ITEM_ID
                                       AND F.DIVISION_ID         = V_DIVISION_ID
                                       AND F.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                       AND F.PLAN_TYPE           = V_PLAN_TYPE
                                       AND F.SEQ                 = V_SEQ
                               LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL  X
                                ON  X.LOOKUP_TYPE = 'POUCH_WH_IN_DAY'
                               AND  X.VALID_YN    = 'Y'
                               AND  X.SEGMENT1    = SUBSTR(P.ITEM_ID, 1, 3)
                               AND  X.SEGMENT3    = '-'
                               AND  X.SEGMENT4    = '-'
                               AND  X.SEGMENT5    = '-'
                        WHERE  P.DIVISION_ID = V_DIVISION_ID
                        AND    P.SCM_SITE_ID IS NOT NULL
                        AND    P.QTY > 0
                        AND    P.YYYYMMDD  >=  V_DATA_START_YYYYMMDD
                       ) R
                WHERE  R.YYYYMMDD  >=  V_DATA_START_YYYYMMDD
                AND    R.YYYYMMDD  <   V_DATA_END_YYYYMMDD

                UNION ALL
               /* ------------------------------------------------------------------------------------------------------------- */
               /* 계획 : 생산계획없는 모델 추가 ( MY MODEL 담당자 지정 모델 강제 생성) */
               /* ------------------------------------------------------------------------------------------------------------- */
                SELECT M.DIVISION_ID                            AS DIVISION_ID
                ,      M.FROM_SITE                              AS FROM_SITE
                ,      M.ITEM_ID                                AS ITEM_ID
                ,      'PLAN_SSP_MYMODEL'                       AS TYPE
                ,      V_DATA_START_YYYYMMDD                    AS YYYYMMDD
                ,      NULL                                     AS PRD_YYYYMMDD
                ,      0                                        AS QTY
                ,      NULL                                     AS OPERATION_ID
                ,      NULL                                     AS PRODUCTION_TYPE
                FROM   SSP_MST_MODEL_USER M
                WHERE  M.DIVISION_ID =  V_DIVISION_ID
                AND    M.VALID_YN = 'Y'

              ) X
              JOIN SCM_MST_SITE E
           ON E.DIVISION_ID = V_DIVISION_ID
          AND NVL(E.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
          AND E.DIVISION_ID = X.DIVISION_ID
          AND E.SCM_SITE_ID = X.FROM_SITE
              LEFT OUTER JOIN SCM_MST_ITEM_SN IM
           ON IM.DIVISION_ID = X.DIVISION_ID
          AND IM.COMPANY_ID = V_COMPANY_ID
          AND IM.SITE_ID = E.SITE_ID
          AND IM.ITEM_ID = X.ITEM_ID
          AND IM.ITEM_CLASS IN ('ES1901', 'ES2001','ES2002', 'ES2003', 'ES2004')
        WHERE  1 = 1
        GROUP BY
                X.DIVISION_ID
        ,      X.FROM_SITE
        ,      IM.APPLIED_MODEL
        ,      X.ITEM_ID
        ,      X.YYYYMMDD
        /* OPTION (RECOMPILE) : MSSQL 힌트 제거 */
        ;

        /* jilee 230830 'PROD_PLAN' 중복 발생한 TEMP 테이블 Merge */
        INSERT INTO GT_SSP_ANL_SHIP_PLAN_40
                ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID
                , FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID
                , QTY, INCOTERMS, TRANSPORT_MODE, PROJECT_CODE, FCST_TYPE
                , CONFIRM_ID, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, ATTRIBUTE1, ATTRIBUTE4, ATTRIBUTE5 )
        SELECT   T.DIVISION_ID
                ,V_PLAN_START_YYYYMMDD      AS PLAN_START_YYYYMMDD
                ,V_PLAN_TYPE               AS PLAN_TYPE
                ,V_SEQ                     AS SEQ
                ,T.ITEM_ID
                ,T.FROM_SITE
                ,'-'                       AS TO_SITE
                ,'PROD_PLAN'               AS MEASURE
                ,T.YYYYMMDD
                ,'-'                       AS BOD_ID
                ,ROUND(SUM(T.QTY),0)
                ,'-'                       AS INCOTERMS
                ,'-'                       AS TRANSPORT_MODE
                ,'-'                       AS PROJECT_CODE
                ,'-'                       AS FCST_TYPE
                ,'-'                       AS CONFIRM_ID
                ,T.ORIGIN_FROM_DIVISION_ID
                ,T.ORIGIN_TO_DIVISION_ID
                ,MAX(T.ATTRIBUTE1)          AS ATTRIBUTE1
                ,TO_CHAR(SUM(TO_NUMBER(T.ATTRIBUTE4))) AS ATTRIBUTE4
                ,TO_CHAR(SUM(TO_NUMBER(T.ATTRIBUTE5))) AS ATTRIBUTE5
          FROM GT_SSP_ANL_SHIP_PLAN_40_TEMP T
         GROUP BY T.DIVISION_ID
                ,T.FROM_SITE
                ,T.ITEM_ID
                ,T.YYYYMMDD
                ,T.ORIGIN_FROM_DIVISION_ID
                ,T.ORIGIN_TO_DIVISION_ID
        ;

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 2-5. [P]INCO_WIP(Incomming WIP) : AGING 재고 + 조립계획 */
        /* ----------------------------------------------------------------------------------------------------------- */
        INSERT INTO GT_SSP_ANL_SHIP_PLAN_40
                ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID
                , FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID
                , QTY, INCOTERMS, TRANSPORT_MODE, PROJECT_CODE, FCST_TYPE
                , CONFIRM_ID, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, ATTRIBUTE1 )
        SELECT  X.DIVISION_ID               AS DIVISION_ID
        ,       V_PLAN_START_YYYYMMDD       AS PLAN_START_YYYYMMDD
        ,       V_PLAN_TYPE                 AS PLAN_TYPE
        ,       V_SEQ                       AS SEQ
        ,       IM.APPLIED_MODEL            AS ITEM_ID
        ,       X.FROM_SITE                 AS FROM_SITE
        ,       '-'                         AS TO_SITE
        ,       'INCO_WIP'                  AS MEASURE
        ,       X.YYYYMMDD                  AS YYYYMMDD
        ,       '-'                         AS BOD_ID
        ,       SUM(ROUND(X.QTY,0))         AS QTY
        ,       '-'                         AS INCOTERMS
        ,       '-'                         AS TRANSPORT_MODE
        ,       '-'                         AS PROJECT_CODE
        ,       '-'                         AS FCST_TYPE
        ,       '-'                         AS CONFIRM_ID
        ,       X.DIVISION_ID               AS ORIGIN_FROM_DIVISION_ID
        ,       X.DIVISION_ID               AS ORIGIN_TO_DIVISION_ID
        ,       NULL                        AS ATTRIBUTE1
        FROM   (
                SELECT A.DIVISION_ID               AS DIVISION_ID
                ,      A.SCM_SITE_ID               AS FROM_SITE
                ,      A.ITEM_ID                   AS ITEM_ID
                ,      CASE WHEN TO_CHAR(A.AVAILABLE_DATE, 'YYYYMMDD') <= V_PLAN_START_YYYYMMDD
                            THEN V_PLAN_START_YYYYMMDD
                            ELSE TO_CHAR(A.AVAILABLE_DATE, 'YYYYMMDD') END  AS YYYYMMDD
                ,      A.QTY - CASE WHEN (A.WIPHOLD_YN ='Y' OR A.SPECIAL_YN = 'Y' ) THEN A.QTY ELSE 0 END   AS QTY
                FROM   SCM_DNM_STOCK_AGING_V A
                ,     ( /* 가장최근 CUTOFF 기준 */
                        SELECT C.DIVISION_ID, C.SITE_ID ,  MAX(C.CUTOFF_DATE) AS CUTOFF_DATE
                        FROM   SCM_DNM_STOCK_AGING_V C
                        WHERE  C.CUTOFF_DATE >  SYSDATE - 5
                        AND    C.DIVISION_ID  = V_DIVISION_ID
                        GROUP BY C.DIVISION_ID, C.SITE_ID
                      ) B
                WHERE  1 = 1
                AND    A.DIVISION_ID = B.DIVISION_ID
                AND    A.SITE_ID     = B.SITE_ID
                AND    A.CUTOFF_DATE = B.CUTOFF_DATE
                AND    A.DIVISION_ID = V_DIVISION_ID
                AND    A.SCM_SITE_ID IS NOT NULL
                AND    A.AVAILABLE_DATE <= TO_DATE(V_DATA_END_YYYYMMDD, 'YYYYMMDD')
                AND    A.CUTOFF_DATE >  SYSDATE - 5

                UNION ALL

                /* 조립계획 ('A3000', 'A9000' ) */
                SELECT P.DIVISION_ID                              AS DIVISION_ID
                ,      P.SCM_SITE_ID                              AS FROM_SITE
                ,      P.ITEM_ID                                  AS ITEM_ID
                ,      CASE WHEN TO_CHAR(P.PLAN_DATE + (NVL(F.LT_FORMATION,0) + NVL(F.ATTRIBUTE1,0)), 'YYYYMMDD') <= V_PLAN_START_YYYYMMDD THEN V_PLAN_START_YYYYMMDD
                            ELSE TO_CHAR(P.PLAN_DATE + (NVL(F.LT_FORMATION,0) + NVL(F.ATTRIBUTE1,0)), 'YYYYMMDD') END  AS YYYYMMDD
                ,      P.PLAN_QTY * NVL(F.SSP_MODIFY_YIELD ,1)   AS QTY
                FROM   GT_SSP_PLAN_FROZEN_POUCH P  -- 2026.11.18 ZIONEX --속도 이슈로 SSP_DNM_PLAN_FROZEN_V 를 GTT로 변경
                       LEFT OUTER JOIN SSP_ANL_FORMATION_C F
                                ON F.DIVISION_ID   = P.DIVISION_ID
                               AND F.PLANT_SITE_ID = P.SCM_SITE_ID
                               AND F.ITEM_ID       = P.ITEM_ID
                               AND F.DIVISION_ID   = V_DIVISION_ID
                               AND F.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                               AND F.PLAN_TYPE           = V_PLAN_TYPE
                               AND F.SEQ                 = V_SEQ
                WHERE  P.DIVISION_ID = V_DIVISION_ID
                AND    P.SCM_SITE_ID IS NOT NULL
                AND    P.OPERATION_ID IN  ('A3000', 'A9000') /* INCO_WIP의 경우 F공정은 제외 */
                AND    TO_CHAR(P.PLAN_DATE + (NVL(F.LT_FORMATION,0) + NVL(F.ATTRIBUTE1,0)) , 'YYYYMMDD')  > V_DATA_START_YYYYMMDD
                AND    TO_CHAR(P.PLAN_DATE + (NVL(F.LT_FORMATION,0) + NVL(F.ATTRIBUTE1,0)) , 'YYYYMMDD') <  V_DATA_END_YYYYMMDD
                AND    P.PLAN_QTY > 0
                AND    P.PLAN_DATE >= TO_DATE(V_DATA_START_YYYYMMDD, 'YYYYMMDD')
                /* CNJ Pouch 특성계획과 중복되는건 제외(2019.06.27) */
                AND    NOT EXISTS ( SELECT 1
                                    FROM   GT_SSP_PLAN_FROZEN_POUCH A -- 2026.11.18 ZIONEX --속도 이슈로 SSP_DNM_PLAN_FROZEN_V 를 GTT로 변경
                                    WHERE  A.DIVISION_ID = V_DIVISION_ID
                                    AND    A.SCM_SITE_ID IS NOT NULL
                                    AND    A.OPERATION_ID IN  ('F5400','F5500','F5600')
                                    AND    A.PLAN_QTY > 0
                                    AND    A.PLAN_DATE  > TO_DATE(V_DATA_START_YYYYMMDD, 'YYYYMMDD')
                                    AND    A.PLAN_DATE  < TO_DATE(V_DATA_END_YYYYMMDD, 'YYYYMMDD')
                                    AND    A.DIVISION_ID = P.DIVISION_ID
                                    AND    A.ITEM_ID     = P.ITEM_ID
                                    AND    A.SCM_SITE_ID = P.SCM_SITE_ID
                                    )

                UNION ALL

                /* 조립계획(SSP_DNM_PLAN_FROZEN_V) CNJ Pouch 특성계획 반영 (2019.06.27) F5500 */
                SELECT P.DIVISION_ID                              AS DIVISION_ID
                ,      P.SCM_SITE_ID                              AS FROM_SITE
                ,      P.ITEM_ID                                  AS ITEM_ID
                ,      TO_CHAR(P.PLAN_DATE + 2, 'YYYYMMDD')       AS YYYYMMDD
                ,      P.PLAN_QTY * NVL(F.SSP_MODIFY_YIELD ,1)   AS QTY
                FROM   GT_SSP_PLAN_FROZEN_POUCH P -- 2026.11.18 ZIONEX --속도 이슈로 SSP_DNM_PLAN_FROZEN_V 를 GTT로 변경
                       LEFT OUTER JOIN SSP_ANL_FORMATION_C F
                                ON F.DIVISION_ID   = P.DIVISION_ID
                               AND F.PLANT_SITE_ID = P.SCM_SITE_ID
                               AND F.ITEM_ID       = P.ITEM_ID
                               AND F.DIVISION_ID   = V_DIVISION_ID
                               AND F.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                               AND F.PLAN_TYPE           = V_PLAN_TYPE
                               AND F.SEQ                 = V_SEQ
                WHERE  P.DIVISION_ID = V_DIVISION_ID
                AND    P.SCM_SITE_ID IS NOT NULL
                AND    P.OPERATION_ID IN  ('F5400','F5500','F5600')
                AND    P.PLAN_DATE  > TO_DATE(V_DATA_START_YYYYMMDD, 'YYYYMMDD')
                AND    P.PLAN_DATE  < TO_DATE(V_DATA_END_YYYYMMDD, 'YYYYMMDD')
                AND    P.PLAN_QTY > 0
               ) X
               JOIN SCM_MST_SITE E
            ON E.DIVISION_ID = V_DIVISION_ID
           AND NVL(E.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
           AND E.DIVISION_ID = X.DIVISION_ID
           AND E.SCM_SITE_ID = X.FROM_SITE
               LEFT OUTER JOIN SCM_MST_ITEM_SN IM
            ON IM.DIVISION_ID = X.DIVISION_ID
           AND IM.COMPANY_ID = V_COMPANY_ID
           AND IM.SITE_ID = E.SITE_ID
           AND IM.ITEM_ID = X.ITEM_ID
           AND IM.ITEM_CLASS IN ('ES1901', 'ES2001','ES2002', 'ES2003', 'ES2004')
        WHERE IM.APPLIED_MODEL IS NOT NULL
        GROUP BY
                X.DIVISION_ID
        ,      X.FROM_SITE
        ,      IM.APPLIED_MODEL
        ,      X.ITEM_ID
        ,      X.YYYYMMDD
        ;

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 2-5-1. [I]MES_FCS_HOLD(Hold Stock) : LOT_ID(일자) + FORMATION L/T 의 hold 수량 */
        /* ----------------------------------------------------------------------------------------------------------- */
        INSERT INTO GT_SSP_ANL_SHIP_PLAN_40
                ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID
                , FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID
                , QTY, INCOTERMS, TRANSPORT_MODE, PROJECT_CODE, FCST_TYPE
                , CONFIRM_ID, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, ATTRIBUTE1 )
        SELECT   X.DIVISION_ID
        ,        V_PLAN_START_YYYYMMDD
        ,        V_PLAN_TYPE
        ,        V_SEQ
        ,        X.ITEM_ID
        ,        X.FROM_SITE
        ,        '-' AS TO_SITE
        ,        'MES_FCS_HOLD' AS MEASURE
        ,        X.YYYYMMDD
        ,        '-' AS BOD_ID
        ,        SUM(X.QTY)
        ,        '-' AS INCOTERMS
        ,        '-' AS TRANSPORT_MODE
        ,        '-' AS PROJECT_CODE
        ,        '-' AS FCST_TYPE
        ,        '-' AS CONFIRM_ID
        ,        X.DIVISION_ID  AS ORIGIN_FROM_DIVISION_ID
        ,        X.DIVISION_ID  AS ORIGIN_TO_DIVISION_ID
        ,        MAX(X.ATTRIBUTE1)
        FROM    (
                    SELECT H.DIVISION_ID
                    ,      H.ITEM_ID
                    ,      H.FROM_SITE
                    ,      H.YYYYMMDD_LOT_ID_APPLIED_LT AS YYYYMMDD
                    ,      H.LOT_QTY_TOT   AS QTY /* 2020.10.13 원 수량으로 변경 */
                    ,      SUBSTR(H.LOT_ID, 4,4)             AS ATTRIBUTE1
                    FROM   SSP_ANL_MES_FCS_STOCK_40_C H
                    WHERE  H.DIVISION_ID         = V_DIVISION_ID
                    AND    H.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                    AND    H.PLAN_TYPE           = V_PLAN_TYPE
                    AND    H.SEQ                 = V_SEQ
                    AND    H.AVAILABLE_YN = 'N'
                    AND    H.CHANGE_STATUS      <> 'D'
                    AND    H.LOT_QTY_TOT         > 0
                    AND    H.USER_MOD_RELEASE_DATE      >= V_DATA_START_YYYYMMDD
                    AND    H.YYYYMMDD_LOT_ID_APPLIED_LT >= V_DATA_START_YYYYMMDD
                    AND    H.YYYYMMDD_LOT_ID_APPLIED_LT <  V_DATA_END_YYYYMMDD
                ) X
                JOIN SCM_MST_SITE E
             ON E.DIVISION_ID = V_DIVISION_ID
            AND NVL(E.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
            AND E.DIVISION_ID = X.DIVISION_ID
            AND E.SCM_SITE_ID = X.FROM_SITE
        GROUP BY X.DIVISION_ID
        ,        X.ITEM_ID
        ,        X.FROM_SITE
        ,        X.YYYYMMDD
        ;

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 2-5-2. [I]MES_FCS_RELEASE(Release Stock) : USER_MOD_RELEASE_DATE 의 LOT수량 */
        /* ----------------------------------------------------------------------------------------------------------- */
        INSERT INTO GT_SSP_ANL_SHIP_PLAN_40
                ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID
                , FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID
                , QTY, INCOTERMS, TRANSPORT_MODE, PROJECT_CODE, FCST_TYPE
                , CONFIRM_ID, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, ATTRIBUTE1 )
        SELECT   X.DIVISION_ID
        ,        V_PLAN_START_YYYYMMDD
        ,        V_PLAN_TYPE
        ,        V_SEQ
        ,        X.ITEM_ID
        ,        X.FROM_SITE
        ,        '-' AS TO_SITE
        ,        'MES_FCS_RELEASE' AS MEASURE
        ,        X.YYYYMMDD
        ,        '-' AS BOD_ID
        ,        SUM(X.QTY)
        ,        '-' AS INCOTERMS
        ,        '-' AS TRANSPORT_MODE
        ,        '-' AS PROJECT_CODE
        ,        '-' AS FCST_TYPE
        ,        '-' AS CONFIRM_ID
        ,        X.DIVISION_ID  AS ORIGIN_FROM_DIVISION_ID
        ,        X.DIVISION_ID  AS ORIGIN_TO_DIVISION_ID
        ,        MAX(X.ATTRIBUTE1)
        FROM   (
                    SELECT   H.DIVISION_ID
                    ,        H.ITEM_ID
                    ,        H.FROM_SITE
                    ,        H.USER_MOD_RELEASE_DATE AS YYYYMMDD
                    ,        H.LOT_QTY_TOT   AS QTY /* 2020.10.13 원 수량으로 변경 */
                    ,        SUBSTR(H.LOT_ID, 4,4)             AS ATTRIBUTE1
                    FROM     (
                            SELECT H.DIVISION_ID
                                , H.FROM_SITE
                                , H.ITEM_ID
                                , H.LOT_ID
                                , H.LOT_QTY_TOT
                                , CASE WHEN (NVL(H.USER_MOD_RELEASE_DATE, '-') <> '29991231' AND H.USER_MOD_RELEASE_DATE IS NOT NULL) THEN H.USER_MOD_RELEASE_DATE
                                       WHEN (NVL(H.USER_MOD_RELEASE_DATE, '-') =  '29991231') AND (NVL(H.QMS_HOLD_RELEASE, '-') > NVL(H.MES_HOLD_RELEASE, '-')) THEN H.QMS_HOLD_RELEASE
                                    ELSE H.MES_HOLD_RELEASE  END   AS USER_MOD_RELEASE_DATE
                            FROM   SSP_ANL_MES_FCS_STOCK_40_C H
                            WHERE  1 = 1
                            AND    H.DIVISION_ID         = V_DIVISION_ID
                            AND    H.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                            AND    H.PLAN_TYPE           = V_PLAN_TYPE
                            AND    H.SEQ                 = V_SEQ
                            AND    H.AVAILABLE_YN        = 'N'
                            AND    H.CHANGE_STATUS      <> 'D'
                            AND    H.USER_MOD_RELEASE_DATE >= V_DATA_START_YYYYMMDD
                             ) H
                    WHERE  1 = 1
                    AND    H.USER_MOD_RELEASE_DATE IS NOT NULL
                    AND    H.USER_MOD_RELEASE_DATE >= V_DATA_START_YYYYMMDD
                    AND    H.USER_MOD_RELEASE_DATE <  V_DATA_END_YYYYMMDD
               ) X
                JOIN SCM_MST_SITE E
             ON E.DIVISION_ID = V_DIVISION_ID
            AND NVL(E.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
            AND E.DIVISION_ID = X.DIVISION_ID
            AND E.SCM_SITE_ID = X.FROM_SITE
        GROUP BY X.DIVISION_ID
        ,        X.ITEM_ID
        ,        X.FROM_SITE
        ,        X.YYYYMMDD
        ;

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 2-6. PROD_PLAN OR INCO_WIP 등 존재하지 않는 경우 해당 MEASURE를 0으로 추가 */
        /* ----------------------------------------------------------------------------------------------------------- */
        WHILE V_X_INT < 8 LOOP

            V_X_MEASURE := ( CASE V_X_INT WHEN 1 THEN 'PROD_PLAN'
                                          WHEN 2 THEN 'INCO_WIP'
                                          WHEN 3 THEN 'SHIP_REQ'
                                          WHEN 4 THEN 'SHIP_CONFIRM'
                                          WHEN 5 THEN 'POSTP_PLAN'
                                          WHEN 6 THEN 'MES_FCS_HOLD'
                                          WHEN 7 THEN 'MES_FCS_RELEASE'
                             END);

            INSERT INTO GT_SSP_ANL_SHIP_PLAN_40
                ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID
                , FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID
                , QTY, INCOTERMS, TRANSPORT_MODE, PROJECT_CODE, FCST_TYPE
                , CONFIRM_ID, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID )
            SELECT
                 SUB.DIVISION_ID
                ,SUB.PLAN_START_YYYYMMDD
                ,SUB.PLAN_TYPE
                ,SUB.SEQ
                ,SUB.ITEM_ID
                ,SUB.FROM_SITE
                ,SUB.TO_SITE
                ,SUB.MEASURE
                ,SUB.YYYYMMDD
                ,SUB.BOD_ID
                ,0              AS QTY
                ,SUB.INCOTERMS
                ,SUB.TRANSPORT_MODE
                ,SUB.PROJECT_CODE
                ,SUB.FCST_TYPE
                ,SUB.CONFIRM_ID
                ,SUB.DIVISION_ID /* ORIGIN_FROM_DIVISION_ID */
                ,SUB.DIVISION_ID /* ORIGIN_TO_DIVISION_ID */
            FROM (
                    SELECT   DIVISION_ID
                            ,PLAN_START_YYYYMMDD
                            ,PLAN_TYPE
                            ,SEQ
                            ,ITEM_ID
                            ,FROM_SITE
                            ,'-'         AS TO_SITE
                            ,V_X_MEASURE AS MEASURE
                            ,YYYYMMDD
                            ,'-' AS BOD_ID
                            ,'-' AS INCOTERMS
                            ,'-' AS TRANSPORT_MODE
                            ,'-' AS PROJECT_CODE
                            ,'-' AS FCST_TYPE
                            ,'-' AS CONFIRM_ID
                        FROM
                            (
                                SELECT C.BASIS_YYYYMMDD AS YYYYMMDD
                                FROM SCM_SYS_CALENDAR_M    C
                                WHERE 1 = 1
                                AND C.BASIS_YYYYMMDD >= V_DATA_START_YYYYMMDD
                                AND C.BASIS_YYYYMMDD <  V_DATA_END_YYYYMMDD
                            ) A
                          , (
                                SELECT /*+ NO_MERGE */ DISTINCT  --  2026.11.18 ZIONEX
                                        DIVISION_ID
                                    ,PLAN_START_YYYYMMDD
                                    ,PLAN_TYPE
                                    ,SEQ
                                    ,ITEM_ID
                                    ,FROM_SITE
                                FROM  GT_SSP_ANL_SHIP_PLAN_40 X
                                WHERE 1 = 1
                            ) B
                ) SUB
                WHERE 1 = 1
                    AND NOT EXISTS (
                                    SELECT 'X'
                                    FROM GT_SSP_ANL_SHIP_PLAN_40 Z
                                    WHERE 1 = 1
                                        AND Z.DIVISION_ID              = SUB.DIVISION_ID
                                        AND Z.PLAN_START_YYYYMMDD      = SUB.PLAN_START_YYYYMMDD
                                        AND Z.PLAN_TYPE                = SUB.PLAN_TYPE
                                        AND Z.SEQ                      = SUB.SEQ
                                        AND Z.ITEM_ID                  = SUB.ITEM_ID
                                        AND Z.FROM_SITE                = SUB.FROM_SITE
                                        AND Z.MEASURE                  = V_X_MEASURE
                                        AND Z.YYYYMMDD                 = SUB.YYYYMMDD
                                    )
            ;

            V_X_INT := V_X_INT + 1;

        END LOOP;

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 2-7. MEASURE별 BUCKET일자별 0 채우기 */
        /* ----------------------------------------------------------------------------------------------------------- */
        INSERT INTO GT_SSP_ANL_SHIP_PLAN_40
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID
            , FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID
            , QTY, INCOTERMS, TRANSPORT_MODE, PROJECT_CODE, FCST_TYPE
            , CONFIRM_ID, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID )
        SELECT
                SUB.DIVISION_ID
            ,SUB.PLAN_START_YYYYMMDD
            ,SUB.PLAN_TYPE
            ,SUB.SEQ
            ,SUB.ITEM_ID
            ,SUB.FROM_SITE
            ,SUB.TO_SITE
            ,SUB.MEASURE
            ,SUB.YYYYMMDD
            ,SUB.BOD_ID
            ,0              AS QTY
            ,SUB.INCOTERMS
            ,SUB.TRANSPORT_MODE
            ,SUB.PROJECT_CODE
            ,SUB.FCST_TYPE
            ,'-' AS CONFIRM_ID
            ,SUB.DIVISION_ID
            ,SUB.DIVISION_ID /* ORIGIN_TO_DIVISION_ID */
        FROM
            (
                SELECT   DIVISION_ID
                        ,PLAN_START_YYYYMMDD
                        ,PLAN_TYPE
                        ,SEQ
                        ,ITEM_ID
                        ,FROM_SITE
                        ,TO_SITE
                        ,MEASURE
                        ,YYYYMMDD
                        ,'-' AS  BOD_ID
                        ,'-' AS  INCOTERMS
                        ,'-' AS  TRANSPORT_MODE
                        ,'-' AS  PROJECT_CODE
                        ,'-' AS  FCST_TYPE
                    FROM
                        (
                            SELECT C.BASIS_YYYYMMDD AS YYYYMMDD
                            FROM SCM_SYS_CALENDAR_M    C
                            WHERE 1 = 1
                            AND C.BASIS_YYYYMMDD >= V_DATA_START_YYYYMMDD
                            AND C.BASIS_YYYYMMDD <  V_DATA_END_YYYYMMDD
                        ) A
                      , (
                            SELECT /*+ NO_MERGE */ DISTINCT  --  2026.11.18 ZIONEX
                                 DIVISION_ID
                                ,PLAN_START_YYYYMMDD
                                ,PLAN_TYPE
                                ,SEQ
                                ,ITEM_ID
                                ,FROM_SITE
                                ,TO_SITE
                                ,MEASURE
                            FROM  GT_SSP_ANL_SHIP_PLAN_40 X
                            WHERE 1 = 1
                        ) B
            ) SUB
            WHERE 1 = 1
                AND NOT EXISTS (
                                SELECT 'X'
                                    FROM GT_SSP_ANL_SHIP_PLAN_40 Z
                                WHERE 1 = 1
                                    AND Z.DIVISION_ID              = SUB.DIVISION_ID
                                    AND Z.PLAN_START_YYYYMMDD      = SUB.PLAN_START_YYYYMMDD
                                    AND Z.PLAN_TYPE                = SUB.PLAN_TYPE
                                    AND Z.SEQ                      = SUB.SEQ
                                    AND Z.ITEM_ID                  = SUB.ITEM_ID
                                    AND Z.FROM_SITE                = SUB.FROM_SITE
                                    AND Z.TO_SITE                  = SUB.TO_SITE
                                    AND Z.MEASURE                  = SUB.MEASURE
                                    AND Z.YYYYMMDD                 = SUB.YYYYMMDD
                                )
        ;

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 2-8. PROD_PLAN 재 적용 : PROD수량 - OWMS(LOT,PROD_DATE) 수량 및 화면메모 Description 저장 */
        /* [C20200115-000418]-2 : 오창(A010-A) Prod Qty(MASS) vs (ALL) 상이 시 Memo 표시 */
        /* MSSQL UPDATE...FROM(LEFT JOIN OWMS_LOT) -> MERGE (ROWID 매칭) */
        /* ----------------------------------------------------------------------------------------------------------- */
        MERGE INTO GT_SSP_ANL_SHIP_PLAN_40 P
        USING (
               SELECT PP.ROWID AS RID
               ,      CASE WHEN (PP.QTY - NVL(S.QTY ,0)) < 0 THEN 0 ELSE PP.QTY - NVL(S.QTY ,0) END AS NEW_QTY
               ,      CASE WHEN PP.FROM_SITE = V_A010A THEN
                               CASE WHEN (S.QTY IS NOT NULL AND PP.ATTRIBUTE4 <> PP.ATTRIBUTE5 ) THEN
                                         'Prod Qty(MASS) : ' || REPLACE(TO_CHAR(TO_NUMBER(PP.ATTRIBUTE4), 'FM999,999,999,999,990.00'),'.00','') || '  ,' ||
                                         'oWMS Qty : '       || REPLACE(TO_CHAR(S.QTY, 'FM999,999,999,999,990.00'),'.00','')
                                    WHEN (S.QTY IS NOT NULL AND PP.ATTRIBUTE4 = PP.ATTRIBUTE5) THEN
                                         'oWMS Qty : '       || REPLACE(TO_CHAR(S.QTY, 'FM999,999,999,999,990.00'),'.00','')
                                    WHEN (S.QTY IS NULL AND PP.ATTRIBUTE4 <> PP.ATTRIBUTE5 ) THEN
                                         'Prod Qty(MASS) : ' || REPLACE(TO_CHAR(TO_NUMBER(PP.ATTRIBUTE4), 'FM999,999,999,999,990.00'),'.00','')
                               ELSE
                                    NULL
                               END
                          ELSE
                               'oWMS Qty : ' || REPLACE(TO_CHAR(S.QTY, 'FM999,999,999,999,990.00'),'.00','')
                          END AS NEW_ATTR3
               ,      TO_CHAR(S.QTY) AS NEW_ATTR6  /* OWMS 재고 수량 */
               FROM GT_SSP_ANL_SHIP_PLAN_40 PP
                    LEFT OUTER JOIN (
                          /* OWMS LOT별 재고 */
                          SELECT S.DIVISION_ID
                          ,      S.FROM_SITE
                          ,      S.ITEM_ID
                          ,      SUM(S.AVAILABLE_QTY) AS QTY
                          ,      SUBSTR(S.LOT_ID,4,4) AS LOT
                          ,      LY.SEGMENT2 || LM.SEGMENT2 || SUBSTR(S.LOT_ID,6,2) AS PROD_DATE
                          FROM   SSP_ANL_OWMS_STOCK_C S
                                JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LY
                                  ON LY.LOOKUP_TYPE = 'LOT_ID_YEAR'
                                 AND LY.VALID_YN    = 'Y'
                                 AND LY.SEGMENT1    = SUBSTR(S.LOT_ID,4,1)
                                 AND LY.SEGMENT2 BETWEEN TO_CHAR(ADD_MONTHS(SYSDATE,-132),'YYYY') AND TO_CHAR(ADD_MONTHS(SYSDATE,96),'YYYY')
                                JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LM
                                  ON LM.LOOKUP_TYPE = 'LOT_ID_MONTH'
                                 AND LM.VALID_YN    = 'Y'
                                 AND LM.SEGMENT1    = SUBSTR(S.LOT_ID,5,1)
                                JOIN SCM_SYS_CALENDAR_M    C /* 유효한 날짜만 추출 */
                                  ON C.BASIS_YYYYMMDD = LY.SEGMENT2 || LM.SEGMENT2 || SUBSTR(S.LOT_ID,6,2)
                                JOIN SCM_MST_SITE E
                                  ON E.DIVISION_ID = V_DIVISION_ID
                                 AND NVL(E.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
                                 AND E.DIVISION_ID = S.DIVISION_ID
                                 AND E.SCM_SITE_ID = S.FROM_SITE
                          WHERE S.DIVISION_ID         = V_DIVISION_ID
                          AND   S.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                          AND   S.PLAN_TYPE           = V_PLAN_TYPE
                          AND   S.SEQ                 = V_SEQ
                          AND   S.AVAILABLE_QTY > 0
                          GROUP BY S.DIVISION_ID
                          ,        S.FROM_SITE
                          ,        S.ITEM_ID
                          ,        SUBSTR(S.LOT_ID,4,4)
                          ,        LY.SEGMENT2 || LM.SEGMENT2 || SUBSTR(S.LOT_ID,6,2)
                    ) S
                 ON S.DIVISION_ID = PP.DIVISION_ID
                AND S.ITEM_ID     = PP.ITEM_ID
                AND S.FROM_SITE   = PP.FROM_SITE
                AND S.PROD_DATE   = PP.ATTRIBUTE1
                    JOIN SCM_MST_SITE E
                 ON E.DIVISION_ID = V_DIVISION_ID
                AND NVL(E.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
                AND E.DIVISION_ID = PP.DIVISION_ID
                AND E.SCM_SITE_ID = PP.FROM_SITE
               WHERE PP.DIVISION_ID         = V_DIVISION_ID
               AND   PP.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
               AND   PP.PLAN_TYPE           = V_PLAN_TYPE
               AND   PP.SEQ                 = V_SEQ
               AND   PP.MEASURE             = 'PROD_PLAN'
               AND   PP.ATTRIBUTE1 IS NOT NULL
              ) SRC
        ON ( P.ROWID = SRC.RID )
        WHEN MATCHED THEN UPDATE SET P.QTY = SRC.NEW_QTY, P.ATTRIBUTE3 = SRC.NEW_ATTR3, P.ATTRIBUTE6 = SRC.NEW_ATTR6
        ;

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 2-9. [P]PROD_DATE(Production Date) : 조립완료일 (PROD_PLAN의 ATTRIBUTE1) */
        /* ----------------------------------------------------------------------------------------------------------- */
        INSERT INTO GT_SSP_ANL_SHIP_PLAN_40
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID
            , FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID
            , QTY, ROUTE_ID, INCOTERMS, TRANSPORT_MODE, BIZ_TYPE
            , PROJECT_CODE, FCST_TYPE, FCST_ETD_DATE, FCST_ETA_DATE, ETD_DATE
            , ETA_DATE, CONFIRM_ID, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, ATTRIBUTE1 )
        SELECT   A.DIVISION_ID
            ,A.PLAN_START_YYYYMMDD
            ,A.PLAN_TYPE
            ,A.SEQ
            ,A.ITEM_ID
            ,A.FROM_SITE
            ,A.TO_SITE
            ,'PROD_DATE' AS MEASURE
            ,A.YYYYMMDD
            ,A.BOD_ID
            ,A.QTY
            ,A.ROUTE_ID
            ,A.INCOTERMS
            ,A.TRANSPORT_MODE
            ,A.BIZ_TYPE
            ,A.PROJECT_CODE
            ,A.FCST_TYPE
            ,A.FCST_ETD_DATE
            ,A.FCST_ETA_DATE
            ,A.ETD_DATE
            ,A.ETA_DATE
            ,A.CONFIRM_ID
            ,A.DIVISION_ID
            ,A.DIVISION_ID
            ,CASE WHEN A.QTY > 0 THEN A.ATTRIBUTE1 ELSE NULL END AS ATTRIBUTE1
        FROM  GT_SSP_ANL_SHIP_PLAN_40 A
                JOIN SCM_MST_SITE E
             ON E.DIVISION_ID = V_DIVISION_ID
            AND NVL(E.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
            AND E.DIVISION_ID = A.DIVISION_ID
            AND E.SCM_SITE_ID = A.FROM_SITE
        WHERE A.MEASURE ='PROD_PLAN'
        ;

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 2-10. [P]LOT(Lot) : PROD_DATE의 LOT정보 [CSR ID:4045697] */
        /* ----------------------------------------------------------------------------------------------------------- */
        INSERT INTO GT_SSP_ANL_SHIP_PLAN_40
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID
            , FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID
            , QTY, ROUTE_ID, INCOTERMS, TRANSPORT_MODE, BIZ_TYPE
            , PROJECT_CODE, FCST_TYPE, FCST_ETD_DATE, FCST_ETA_DATE, ETD_DATE
            , ETA_DATE, CONFIRM_ID, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, ATTRIBUTE1 )
        SELECT P.DIVISION_ID
            ,P.PLAN_START_YYYYMMDD
            ,P.PLAN_TYPE
            ,P.SEQ
            ,P.ITEM_ID
            ,P.FROM_SITE
            ,P.TO_SITE
            ,'LOT' AS MEASURE
            ,P.YYYYMMDD
            ,P.BOD_ID
            ,P.QTY
            ,P.ROUTE_ID
            ,P.INCOTERMS
            ,P.TRANSPORT_MODE
            ,P.BIZ_TYPE
            ,P.PROJECT_CODE
            ,P.FCST_TYPE
            ,P.FCST_ETD_DATE
            ,P.FCST_ETA_DATE
            ,P.ETD_DATE
            ,P.ETA_DATE
            ,P.CONFIRM_ID
            ,P.DIVISION_ID /* ORIGIN_FROM_DIVISION_ID */
            ,P.DIVISION_ID /* ORIGIN_TO_DIVISION_ID */
            ,CASE WHEN P.QTY > 0 THEN LY.SEGMENT1 || LM.SEGMENT1 || SUBSTR(P.ATTRIBUTE1,7,2) ELSE NULL END AS ATTRIBUTE1
        FROM  GT_SSP_ANL_SHIP_PLAN_40 P
              LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LY
                ON LY.LOOKUP_TYPE = 'LOT_ID_YEAR'
                AND LY.VALID_YN    = 'Y'
                AND LY.SEGMENT2    = SUBSTR(P.ATTRIBUTE1,1,4)
                AND LY.SEGMENT2 BETWEEN TO_CHAR(ADD_MONTHS(SYSDATE,-132),'YYYY') AND TO_CHAR(ADD_MONTHS(SYSDATE,96),'YYYY')
              LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LM
                ON LM.LOOKUP_TYPE = 'LOT_ID_MONTH'
                AND LM.VALID_YN    = 'Y'
                AND LM.SEGMENT2    = SUBSTR(P.ATTRIBUTE1,5,2)
                JOIN SCM_MST_SITE E
             ON E.DIVISION_ID = V_DIVISION_ID
            AND NVL(E.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
            AND E.DIVISION_ID = P.DIVISION_ID
            AND E.SCM_SITE_ID = P.FROM_SITE
        WHERE P.MEASURE ='PROD_DATE'
        ;

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 2-11. [P]WH_IN(WH in Plan) : Prod Qty(MASS/ALL) - oWMS 재고, 단 사용자 입력값 있으면 유지 */
        /* [C20200115-000418]-3 : 오창(A010-A) ATTRIBUTE4 - ATTRIBUTE6, 이외 ATTRIBUTE5 - ATTRIBUTE6 */
        /* ----------------------------------------------------------------------------------------------------------- */
        INSERT INTO GT_SSP_ANL_SHIP_PLAN_40
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID
            , FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID
            , QTY, ROUTE_ID, INCOTERMS, TRANSPORT_MODE, BIZ_TYPE
            , PROJECT_CODE, FCST_TYPE, FCST_ETD_DATE, FCST_ETA_DATE, ETD_DATE
            , ETA_DATE, CONFIRM_ID, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID )
        SELECT
             T.DIVISION_ID
            ,T.PLAN_START_YYYYMMDD
            ,T.PLAN_TYPE
            ,T.SEQ
            ,T.ITEM_ID
            ,T.FROM_SITE
            ,T.TO_SITE
            ,'WH_IN' AS MEASURE
            ,T.YYYYMMDD
            ,T.BOD_ID
            ,CASE WHEN X.QTY IS NOT NULL THEN X.QTY /* 사용자 수정수량 우선 */
             ELSE
                  CASE WHEN T.FROM_SITE = V_A010A THEN
                      /* 오창(A010-A) : ATTRIBUTE4 - ATTRIBUTE6 ( Prod Qty(MASS) - oWMS 재고 ) */
                      CASE WHEN NVL(TO_NUMBER(T.ATTRIBUTE4),0) - NVL(TO_NUMBER(T.ATTRIBUTE6),0) < 0 THEN 0
                      ELSE
                           NVL(TO_NUMBER(T.ATTRIBUTE4),0) - NVL(TO_NUMBER(T.ATTRIBUTE6),0)
                      END
                  ELSE
                      /* 이외 : ATTRIBUTE5 - ATTRIBUTE6 ( Prod Qty(ALL) - oWMS 재고 ) */
                      CASE WHEN NVL(TO_NUMBER(T.ATTRIBUTE5),0) - NVL(TO_NUMBER(T.ATTRIBUTE6),0) < 0 THEN 0
                      ELSE
                           NVL(TO_NUMBER(T.ATTRIBUTE5),0) - NVL(TO_NUMBER(T.ATTRIBUTE6),0)
                      END
                  END
             END   AS QTY
            ,T.ROUTE_ID
            ,T.INCOTERMS
            ,T.TRANSPORT_MODE
            ,T.BIZ_TYPE
            ,T.PROJECT_CODE
            ,T.FCST_TYPE
            ,T.FCST_ETD_DATE
            ,T.FCST_ETA_DATE
            ,T.ETD_DATE
            ,T.ETA_DATE
            ,T.CONFIRM_ID
            ,T.DIVISION_ID /* ORIGIN_FROM_DIVISION_ID */
            ,T.DIVISION_ID /* ORIGIN_TO_DIVISION_ID */
        FROM  GT_SSP_ANL_SHIP_PLAN_40 T
            LEFT OUTER JOIN (
                            SELECT H.DIVISION_ID
                            ,      H.ITEM_ID
                            ,      H.FROM_SITE
                            ,      H.MEASURE
                            ,      H.YYYYMMDD
                            ,      H.QTY
                            FROM SSP_ANL_SHIP_PLAN_40_WH_IN_H H
                            WHERE H.HISTORY_SEQ = (SELECT MAX(B.HISTORY_SEQ )
                                                    FROM  SSP_ANL_SHIP_PLAN_40_WH_IN_H B
                                                    WHERE B.DIVISION_ID = H.DIVISION_ID
                                                    AND   B.ITEM_ID     = H.ITEM_ID
                                                    AND   B.FROM_SITE   = H.FROM_SITE
                                                    AND   B.MEASURE     = H.MEASURE
                                                    AND   B.YYYYMMDD    = H.YYYYMMDD )
                            ) X
                ON  X.DIVISION_ID = T.DIVISION_ID
                AND X.ITEM_ID = T.ITEM_ID
                AND X.FROM_SITE = T.FROM_SITE
                AND X.MEASURE =  'WH_IN'
                AND X.YYYYMMDD = T.YYYYMMDD
                JOIN SCM_MST_SITE E
             ON E.DIVISION_ID = V_DIVISION_ID
            AND NVL(E.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
            AND E.DIVISION_ID = T.DIVISION_ID
            AND E.SCM_SITE_ID = T.FROM_SITE
        WHERE T.MEASURE ='PROD_PLAN'
        ;

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 2-12. [P]INSP_WIP(Inspection WIP) : 전일 INSP_WIP + 당일 INCO_WIP - 전일 WH_IN , TCO 모델은 0 */
        /* ----------------------------------------------------------------------------------------------------------- */
        INSERT INTO GT_SSP_ANL_SHIP_PLAN_40
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID
            , FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID
            , QTY, INCOTERMS, TRANSPORT_MODE, PROJECT_CODE, FCST_TYPE
            , CONFIRM_ID, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID )
        WITH INSP AS (
                    /* INCO_WIP 기준 시작 */
                    SELECT DISTINCT
                           A.DIVISION_ID
                    ,      A.PLAN_START_YYYYMMDD
                    ,      A.PLAN_TYPE
                    ,      A.SEQ
                    ,      A.ITEM_ID
                    ,      A.FROM_SITE
                    ,      SUM(A.QTY) AS QTY
                    FROM  GT_SSP_ANL_SHIP_PLAN_40 A
                            JOIN SCM_MST_SITE E
                         ON E.DIVISION_ID = V_DIVISION_ID
                        AND NVL(E.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
                        AND E.DIVISION_ID = A.DIVISION_ID
                        AND E.SCM_SITE_ID = A.FROM_SITE
                    WHERE 1 = 1
                    AND A.DIVISION_ID         = V_DIVISION_ID
                    AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                    AND A.PLAN_TYPE           = V_PLAN_TYPE
                    AND A.SEQ                 = V_SEQ
                    AND A.MEASURE             = 'INCO_WIP'
                    AND A.YYYYMMDD            = V_DATA_START_YYYYMMDD
                    GROUP BY A.DIVISION_ID
                    ,        A.PLAN_START_YYYYMMDD
                    ,        A.PLAN_TYPE
                    ,        A.SEQ
                    ,        A.ITEM_ID
                    ,        A.FROM_SITE
                    ,        A.YYYYMMDD
                    )
          , Z AS (
                    SELECT DISTINCT
                            A.DIVISION_ID
                    ,      A.PLAN_START_YYYYMMDD
                    ,      A.PLAN_TYPE
                    ,      A.SEQ
                    ,      A.ITEM_ID
                    ,      A.FROM_SITE
                    ,      A.YYYYMMDD
                    ,      CASE WHEN A.ITEM_ID IS NULL THEN 0
                                ELSE SUM(SUM(CASE WHEN A.MEASURE = 'INCO_WIP' AND A.YYYYMMDD > V_DATA_START_YYYYMMDD THEN NVL(A.QTY, 0) ELSE 0 END))
                                         OVER (PARTITION BY A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.ITEM_ID, A.FROM_SITE ORDER BY A.YYYYMMDD ROWS UNBOUNDED PRECEDING)
                           END AS INCO_CUM_QTY  /* 시작일 초과 ~ 당일 INCO_WIP 합계 */  --  2026.11.18 ZIONEX
                    ,      CASE WHEN A.ITEM_ID IS NULL THEN 0
                                ELSE SUM(SUM(CASE WHEN A.MEASURE = 'WH_IN' THEN NVL(A.QTY, 0) ELSE 0 END))
                                         OVER (PARTITION BY A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.ITEM_ID, A.FROM_SITE ORDER BY A.YYYYMMDD ROWS UNBOUNDED PRECEDING)
                                   - SUM(CASE WHEN A.MEASURE = 'WH_IN' THEN NVL(A.QTY, 0) ELSE 0 END)
                           END AS WH_CUM_QTY    /* 시작일 ~ 전일 WH_IN 합계 */  --  2026.11.18 ZIONEX
                    FROM  GT_SSP_ANL_SHIP_PLAN_40 A
                            JOIN SCM_MST_SITE E
                         ON E.DIVISION_ID = V_DIVISION_ID
                        AND NVL(E.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
                        AND E.DIVISION_ID = A.DIVISION_ID
                        AND E.SCM_SITE_ID = A.FROM_SITE
                    WHERE 1 = 1
                    AND A.DIVISION_ID         = V_DIVISION_ID
                    AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                    AND A.PLAN_TYPE           = V_PLAN_TYPE
                    AND A.SEQ                 = V_SEQ
                    AND A.MEASURE             IN ( 'INCO_WIP' ,'WH_IN')
                    AND A.YYYYMMDD            >= V_DATA_START_YYYYMMDD
                    GROUP BY A.DIVISION_ID
                    ,        A.PLAN_START_YYYYMMDD
                    ,        A.PLAN_TYPE
                    ,        A.SEQ
                    ,        A.ITEM_ID
                    ,        A.FROM_SITE
                    ,        A.YYYYMMDD
                    )
        SELECT
             Z.DIVISION_ID
            ,Z.PLAN_START_YYYYMMDD
            ,Z.PLAN_TYPE
            ,Z.SEQ
            ,Z.ITEM_ID
            ,Z.FROM_SITE
            ,'-'   AS TO_SITE
            ,'INSP_WIP' AS MEASURE
            ,Z.YYYYMMDD
            ,'-'   AS BOD_ID
            ,NVL(INSP.QTY,0)
                + Z.INCO_CUM_QTY         /* INCO_WIP 당일 */  --  2026.11.18 ZIONEX
                + (Z.WH_CUM_QTY * -1)    /* 전날 WH_IN */      --  2026.11.18 ZIONEX
            ,'-'   AS INCOTERMS
            ,'-'   AS TRANSPORT_MODE
            ,'-'   AS PROJECT_CODE
            ,'-'   AS FCST_TYPE
            ,'-'   AS CONFIRM_ID
            ,Z.DIVISION_ID /* ORIGIN_FROM_DIVISION_ID */
            ,Z.DIVISION_ID /* ORIGIN_TO_DIVISION_ID */
        FROM Z
        LEFT OUTER JOIN INSP
            ON Z.DIVISION_ID         = INSP.DIVISION_ID
        AND Z.PLAN_START_YYYYMMDD = INSP.PLAN_START_YYYYMMDD
        AND Z.PLAN_TYPE           = INSP.PLAN_TYPE
        AND Z.SEQ                 = INSP.SEQ
        AND Z.ITEM_ID             = INSP.ITEM_ID
        AND Z.FROM_SITE           = INSP.FROM_SITE
        WHERE 1 = 1
        ;

        /* TCO 모델은 WH_IN과 관계없이 전부 0으로 SETTING (2019.04.19) : 변경시 PR_SSP_ANL_SHIP_UPDATE_BOH_VAL_40 동시 변경필요 */
        UPDATE GT_SSP_ANL_SHIP_PLAN_40 P
           SET P.QTY = 0
         WHERE P.MEASURE  = 'INSP_WIP'
           AND EXISTS ( SELECT 1
                          FROM SCP_MST_FINAL_ITEM F
                         WHERE F.ITEM_ID = P.ITEM_ID
                           AND F.DIVISION_ID = P.DIVISION_ID
                           AND F.TCO_CELL_YN = 'Y' )
           AND EXISTS ( SELECT 1
                          FROM SCM_MST_SITE E
                         WHERE E.DIVISION_ID = V_DIVISION_ID
                           AND NVL(E.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
                           AND E.DIVISION_ID = P.DIVISION_ID
                           AND E.SCM_SITE_ID = P.FROM_SITE )
        ;

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 2-13. [S]POSTP_PLAN 조정(예외) [C20191205-000173] : MCSS20253-A4 PROD_PLAN -> MCSS20253-A2 POSTP_PLAN */
        /* ----------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_SSP_ANL_SHIP_PLAN_40 A
         WHERE A.ITEM_ID = 'MCSS20253-A2'
           AND A.MEASURE  = 'POSTP_PLAN'
           AND EXISTS ( SELECT 1
                          FROM SCM_MST_SITE E
                         WHERE E.DIVISION_ID = V_DIVISION_ID
                           AND NVL(E.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
                           AND E.DIVISION_ID = A.DIVISION_ID
                           AND E.SCM_SITE_ID = A.FROM_SITE )
        ;

        INSERT INTO GT_SSP_ANL_SHIP_PLAN_40
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID
            , FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID
            , QTY, ROUTE_ID, INCOTERMS, TRANSPORT_MODE, BIZ_TYPE
            , PROJECT_CODE, FCST_TYPE, FCST_ETD_DATE, FCST_ETA_DATE, ETD_DATE
            , ETA_DATE, CONFIRM_ID, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, ATTRIBUTE1 )
        SELECT P.DIVISION_ID
            ,P.PLAN_START_YYYYMMDD
            ,P.PLAN_TYPE
            ,P.SEQ
            ,'MCSS20253-A2'
            ,P.FROM_SITE
            ,P.TO_SITE
            ,'POSTP_PLAN' AS MEASURE
            ,P.YYYYMMDD
            ,P.BOD_ID
            ,P.QTY
            ,P.ROUTE_ID
            ,P.INCOTERMS
            ,P.TRANSPORT_MODE
            ,P.BIZ_TYPE
            ,P.PROJECT_CODE
            ,P.FCST_TYPE
            ,P.FCST_ETD_DATE
            ,P.FCST_ETA_DATE
            ,P.ETD_DATE
            ,P.ETA_DATE
            ,P.CONFIRM_ID
            ,P.DIVISION_ID /* ORIGIN_FROM_DIVISION_ID */
            ,P.DIVISION_ID /* ORIGIN_TO_DIVISION_ID */
            ,P.ATTRIBUTE1
        FROM  GT_SSP_ANL_SHIP_PLAN_40 P
                JOIN SCM_MST_SITE E
             ON E.DIVISION_ID = V_DIVISION_ID
            AND NVL(E.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
            AND E.DIVISION_ID = P.DIVISION_ID
            AND E.SCM_SITE_ID = P.FROM_SITE
        WHERE P.ITEM_ID = 'MCSS20253-A4'
        AND   P.MEASURE  = 'PROD_PLAN'
        ;

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 2-14. [I]WH_STOC(Warehouse Stock) */
        /* 당일 = OWMS 가용수량 , 익일 = 전일 WH_STOC + 전일WH_IN - 전일SHIP_CONFIRM - 전일POSTP_PLAN - 전일 MES_FCS_HOLD + 전일 MES_FCS_RELEASE */
        /* ----------------------------------------------------------------------------------------------------------- */
        INSERT INTO GT_SSP_ANL_SHIP_PLAN_40
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID
            , FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID
            , QTY, INCOTERMS, TRANSPORT_MODE, PROJECT_CODE, FCST_TYPE
            , CONFIRM_ID, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID )
        WITH BOH AS (
                     SELECT A.DIVISION_ID
                          , A.PLAN_START_YYYYMMDD
                          , A.PLAN_TYPE
                          , A.SEQ
                          , A.FROM_SITE
                          , A.ITEM_ID
                          , SUM(A.QTY)   AS QTY
                     FROM   (
                            SELECT A.DIVISION_ID
                                 , A.PLAN_START_YYYYMMDD
                                 , A.PLAN_TYPE
                                 , A.SEQ
                                 , A.FROM_SITE
                                 , A.ITEM_ID
                                 , (CASE WHEN NVL(C.SEGMENT3, '-') = 'P' THEN SUM(A.LOT_QTY_MES) ELSE 0 END) AS QTY
                            FROM   SSP_ANL_MES_FCS_STOCK_40_C  A
                                   LEFT OUTER JOIN SCP_MST_FINAL_ITEM  B
                                ON B.DIVISION_ID = A.DIVISION_ID
                               AND B.ITEM_ID = A.ITEM_ID
                                   LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C
                                ON C.LOOKUP_TYPE = 'CELL_TYPE_CODE'
                               AND C.VALID_YN    = 'Y'
                               AND C.SEGMENT1    = B.CELL_TYPE_GROUP_CODE
                            WHERE  1 = 1
                            AND    A.DIVISION_ID         = V_DIVISION_ID
                            AND    A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                            AND    A.PLAN_TYPE           = V_PLAN_TYPE
                            AND    A.SEQ                 = V_SEQ
                            AND    A.AVAILABLE_YN <> 'N'
                            AND    NVL(A.CHANGE_STATUS, '-') <> 'D'
                            GROUP BY A.DIVISION_ID
                                 , A.PLAN_START_YYYYMMDD
                                 , A.PLAN_TYPE
                                 , A.SEQ
                                 , A.FROM_SITE
                                 , A.ITEM_ID
                                 , C.SEGMENT3

                            UNION ALL

                            SELECT A.DIVISION_ID
                                 , A.PLAN_START_YYYYMMDD
                                 , A.PLAN_TYPE
                                 , A.SEQ
                                 , A.FROM_SITE
                                 , A.ITEM_ID
                                 , SUM(A.AVAILABLE_QTY) AS QTY
                            FROM   SSP_ANL_OWMS_STOCK_C  A
                            WHERE  1 = 1
                            AND    A.DIVISION_ID         = V_DIVISION_ID
                            AND    A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                            AND    A.PLAN_TYPE           = V_PLAN_TYPE
                            AND    A.SEQ                 = V_SEQ
                            GROUP BY A.DIVISION_ID
                                 , A.PLAN_START_YYYYMMDD
                                 , A.PLAN_TYPE
                                 , A.SEQ
                                 , A.FROM_SITE
                                 , A.ITEM_ID

                            UNION ALL

                            /* STORAGE ID : B100(TCO Ass.BS D/F), R100(TCO Ass.SW D/F) 외주 재고 */
                            SELECT T.DIVISION_ID            AS DIVISION_ID
                            ,      T.PLAN_START_YYYYMMDD    AS PLAN_START_YYYYMMDD
                            ,      T.PLAN_TYPE              AS PLAN_TYPE
                            ,      T.SEQ                    AS SEQ
                            ,      T.SCM_SITE_ID            AS FROM_SITE
                            ,      T.ITEM_ID                AS ITEM_ID
                            ,      ROUND(SUM(T.QTY),0) AS  QTY
                            FROM   SSP_ANL_TCO_STOCK_C T
                            WHERE  1 = 1
                            AND    T.DIVISION_ID         = V_DIVISION_ID
                            AND    T.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                            AND    T.PLAN_TYPE           = V_PLAN_TYPE
                            AND    T.SEQ                 = V_SEQ
                            GROUP BY
                                    T.DIVISION_ID
                            ,     T.PLAN_START_YYYYMMDD
                            ,     T.PLAN_TYPE
                            ,     T.SEQ
                            ,     T.ITEM_ID
                            ,     T.SCM_SITE_ID
                            ) A
                            JOIN SCM_MST_SITE E
                         ON E.DIVISION_ID = V_DIVISION_ID
                        AND NVL(E.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
                        AND E.DIVISION_ID = A.DIVISION_ID
                        AND E.SCM_SITE_ID = A.FROM_SITE
                     WHERE  1 = 1
                     GROUP BY A.DIVISION_ID
                          , A.PLAN_START_YYYYMMDD
                          , A.PLAN_TYPE
                          , A.SEQ
                          , A.FROM_SITE
                          , A.ITEM_ID
                    )
          , Z AS (
                    SELECT DISTINCT
                            P.DIVISION_ID
                    ,      P.PLAN_START_YYYYMMDD
                    ,      P.PLAN_TYPE
                    ,      P.SEQ
                    ,      P.ITEM_ID
                    ,      P.FROM_SITE
                    ,      P.YYYYMMDD
                    ,      CASE WHEN P.ITEM_ID IS NULL THEN 0
                                ELSE SUM(SUM(CASE WHEN P.YYYYMMDD > V_DATA_START_YYYYMMDD THEN
                                         CASE P.MEASURE WHEN 'SHIP_CONFIRM'    THEN -1 * NVL(P.QTY,0)
                                                        WHEN 'POSTP_PLAN'      THEN -1 * NVL(P.QTY,0)
                                                        WHEN 'MES_FCS_HOLD'    THEN -1 * NVL(P.QTY,0)
                                                        WHEN 'WH_IN'           THEN      NVL(P.QTY,0)
                                                        WHEN 'MES_FCS_RELEASE' THEN      NVL(P.QTY,0)
                                         ELSE 0.0 END
                                    ELSE 0 END))
                                         OVER (PARTITION BY P.DIVISION_ID, P.PLAN_START_YYYYMMDD, P.PLAN_TYPE, P.SEQ, P.ITEM_ID, P.FROM_SITE ORDER BY P.YYYYMMDD ROWS UNBOUNDED PRECEDING)
                                   - SUM(CASE WHEN P.YYYYMMDD > V_DATA_START_YYYYMMDD THEN
                                         CASE P.MEASURE WHEN 'SHIP_CONFIRM'    THEN -1 * NVL(P.QTY,0)
                                                        WHEN 'POSTP_PLAN'      THEN -1 * NVL(P.QTY,0)
                                                        WHEN 'MES_FCS_HOLD'    THEN -1 * NVL(P.QTY,0)
                                                        WHEN 'WH_IN'           THEN      NVL(P.QTY,0)
                                                        WHEN 'MES_FCS_RELEASE' THEN      NVL(P.QTY,0)
                                         ELSE 0.0 END
                                    ELSE 0 END)
                           END AS WH_CUM_QTY    /* 시작일 초과 ~ 전일 WH_IN · SHIP_CONFIRM · POSTP_PLAN · MES_FCS_HOLD · MES_FCS_RELEASE 합계 */  --  2026.11.18 ZIONEX
                    FROM  GT_SSP_ANL_SHIP_PLAN_40 P
                            JOIN SCM_MST_SITE E
                         ON E.DIVISION_ID = V_DIVISION_ID
                        AND NVL(E.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
                        AND E.DIVISION_ID = P.DIVISION_ID
                        AND E.SCM_SITE_ID = P.FROM_SITE
                    WHERE 1 = 1
                    AND P.DIVISION_ID         = V_DIVISION_ID
                    AND P.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                    AND P.PLAN_TYPE           = V_PLAN_TYPE
                    AND P.SEQ                 = V_SEQ
                    AND P.MEASURE IN ('SHIP_CONFIRM', 'WH_IN', 'POSTP_PLAN', 'MES_FCS_HOLD', 'MES_FCS_RELEASE')
                    AND P.YYYYMMDD            >= V_DATA_START_YYYYMMDD
                    GROUP BY P.DIVISION_ID
                    ,        P.PLAN_START_YYYYMMDD
                    ,        P.PLAN_TYPE
                    ,        P.SEQ
                    ,        P.ITEM_ID
                    ,        P.FROM_SITE
                    ,        P.YYYYMMDD
                    )
        /* [E20261126-WHSTKHD] GTT 행 수를 1행으로 추정하면 Z 행마다 HD 를 다시 집계(SSP_ANL_HOLD_STOCK 인덱스 스킵 스캔 반복)함. */
        /* HD 는 한 번만 집계하도록 조인 조건 밀어넣기 금지. 클라우드 11-26 회차당 111 ~ 133초(aj7nw6qjt4tjv) */
        SELECT /*+ NO_PUSH_PRED(HD) */
             Z.DIVISION_ID
            ,Z.PLAN_START_YYYYMMDD
            ,Z.PLAN_TYPE
            ,Z.SEQ
            ,Z.ITEM_ID
            ,Z.FROM_SITE
            ,'-'   AS TO_SITE
            ,'WH_STOCK' AS MEASURE
            ,Z.YYYYMMDD
            ,'-'   AS BOD_ID
            ,/* 전일 WH_IN , 전일 SHIP_CONFIRM */
             (
             CASE WHEN TO_CHAR(SYSDATE, 'YYYYMMDD') < Z.YYYYMMDD THEN Z.WH_CUM_QTY  --  2026.11.18 ZIONEX
             ELSE  0
             END
             )
                /* 당일 OWMS 재고 */
                + NVL(BOH.QTY,0)
                /* 2020.09.09 KBK : 'DCP','MDP','MIP','MTP' 처리 */
                - (
                  CASE WHEN TO_CHAR(SYSDATE, 'YYYYMMDD') <= Z.YYYYMMDD THEN
                       CASE WHEN NVL(B.SEGMENT3, '-') = 'P' THEN NVL(B.WH_IN_QTY2, 0)
                       ELSE 0 END
                  ELSE 0 END
                  )
                /* HOLD 재고 제외 */
                - NVL(HD.HOLD_QTY, 0)                  AS QTY  --  2026.11.18 ZIONEX
            ,'-'   AS INCOTERMS
            ,'-'   AS TRANSPORT_MODE
            ,'-'   AS PROJECT_CODE
            ,'-'   AS FCST_TYPE
            ,'-'   AS CONFIRM_ID
            ,Z.DIVISION_ID
            ,Z.DIVISION_ID  /* ORIGIN_TO_DIVISION_ID */
        FROM Z  --  2026.11.18 ZIONEX (START)
           , BOH
           , (
                            SELECT A.DIVISION_ID
                                    , A.PLAN_START_YYYYMMDD
                                    , A.PLAN_TYPE
                                    , A.SEQ
                                    , A.ITEM_ID
                                    , A.FROM_SITE
                                    , SUM(A.QTY)   AS WH_IN_QTY2
                                    , C.SEGMENT3
                            FROM   GT_SSP_ANL_SHIP_PLAN_40  A
                                   LEFT OUTER JOIN SCP_MST_FINAL_ITEM  B
                                ON B.DIVISION_ID = A.DIVISION_ID
                               AND B.ITEM_ID = A.ITEM_ID
                                   JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C
                                ON C.LOOKUP_TYPE = 'CELL_TYPE_CODE'
                               AND C.VALID_YN    = 'Y'
                               AND C.SEGMENT3    = 'P'
                               AND C.SEGMENT1    = B.CELL_TYPE_GROUP_CODE
                                   JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D
                                ON D.LOOKUP_TYPE = 'POUCH_WH_IN_DAY'
                               AND D.SEGMENT1    = SUBSTR(A.ITEM_ID, 1, 3)
                               AND D.VALID_YN    = 'Y'
                            WHERE  1 = 1
                            AND    A.DIVISION_ID         = V_DIVISION_ID
                            AND    A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                            AND    A.PLAN_TYPE           = V_PLAN_TYPE
                            AND    A.SEQ                 = V_SEQ
                            AND    A.MEASURE = 'WH_IN'
                            AND    A.YYYYMMDD > V_DATA_START_YYYYMMDD
                            AND    A.YYYYMMDD <= TO_CHAR(TO_DATE(V_DATA_START_YYYYMMDD, 'YYYYMMDD') + TO_NUMBER(D.SEGMENT2), 'YYYYMMDD')
                            GROUP BY A.DIVISION_ID
                                    , A.PLAN_START_YYYYMMDD
                                    , A.PLAN_TYPE
                                    , A.SEQ
                                    , A.ITEM_ID
                                    , A.FROM_SITE
                                    , C.SEGMENT3
             ) B  /* 2020.09.09 KBK */
           , (SELECT H.DIVISION_ID
                   , H.FROM_SITE
                   , H.ITEM_ID
                   , C.BASIS_YYYYMMDD
                   , SUM(H.HOLD_QTY)                   AS HOLD_QTY  /* HOLD 재고 */
                FROM SSP_ANL_HOLD_STOCK H
                   , SCM_SYS_CALENDAR_M C
               WHERE C.BASIS_YYYYMMDD     >= H.HOLD_YYYYMMDD
                 AND C.BASIS_YYYYMMDD     <= H.RELEASE_YYYYMMDD
                 AND H.DIVISION_ID         = V_DIVISION_ID
                 AND H.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                 AND H.PLAN_TYPE           = V_PLAN_TYPE
                 AND H.SEQ                 = V_SEQ
                 AND C.BASIS_YYYYMMDD      > V_DATA_START_YYYYMMDD
                 AND C.BASIS_YYYYMMDD      < V_DATA_END_YYYYMMDD
               GROUP BY H.DIVISION_ID
                      , H.FROM_SITE
                      , H.ITEM_ID
                      , C.BASIS_YYYYMMDD
             ) HD
       WHERE BOH.DIVISION_ID(+)         = Z.DIVISION_ID
         AND BOH.PLAN_START_YYYYMMDD(+) = Z.PLAN_START_YYYYMMDD
         AND BOH.PLAN_TYPE(+)           = Z.PLAN_TYPE
         AND BOH.SEQ(+)                 = Z.SEQ
         AND BOH.ITEM_ID(+)             = Z.ITEM_ID
         AND BOH.FROM_SITE(+)           = Z.FROM_SITE
         AND B.DIVISION_ID(+)           = Z.DIVISION_ID
         AND B.PLAN_START_YYYYMMDD(+)   = Z.PLAN_START_YYYYMMDD
         AND B.PLAN_TYPE(+)             = Z.PLAN_TYPE
         AND B.SEQ(+)                   = Z.SEQ
         AND B.ITEM_ID(+)               = Z.ITEM_ID
         AND B.FROM_SITE(+)             = Z.FROM_SITE
         AND HD.DIVISION_ID(+)          = Z.DIVISION_ID
         AND HD.FROM_SITE(+)            = Z.FROM_SITE
         AND HD.ITEM_ID(+)              = Z.ITEM_ID
         AND HD.BASIS_YYYYMMDD(+)       = Z.YYYYMMDD  --  2026.11.18 ZIONEX (END)
        ;

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 2-15. [I]BALANCE(Balance) : 당일 WH_STOCK - 당일 SHIP_CONFIRM - 당일 POSTP_PLAN */
        /* ----------------------------------------------------------------------------------------------------------- */
        INSERT INTO GT_SSP_ANL_SHIP_PLAN_40
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID
            , FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID
            , QTY, INCOTERMS, TRANSPORT_MODE, PROJECT_CODE, FCST_TYPE
            , CONFIRM_ID, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID )
        SELECT B.DIVISION_ID
        ,      B.PLAN_START_YYYYMMDD
        ,      B.PLAN_TYPE
        ,      B.SEQ
        ,      B.ITEM_ID
        ,      B.FROM_SITE
        ,      B.TO_SITE
        ,      'BALANCE'  AS MEASURE
        ,      B.YYYYMMDD
        ,      B.BOD_ID
        ,      B.QTY - B.SHIP_POSTP_QTY  /* 당일 SHIP_CONFIRM · POSTP_PLAN 합계 */  --  2026.11.18 ZIONEX
        ,      B.INCOTERMS
        ,      B.TRANSPORT_MODE
        ,      B.PROJECT_CODE
        ,      B.FCST_TYPE
        ,      '-' AS CONFIRM_ID
        ,      B.DIVISION_ID /* ORIGIN_FROM_DIVISION_ID */
        ,      B.DIVISION_ID /* ORIGIN_TO_DIVISION_ID */
        FROM (SELECT IA.DIVISION_ID  --  2026.11.18 ZIONEX (START)
                   , IA.PLAN_START_YYYYMMDD
                   , IA.PLAN_TYPE
                   , IA.SEQ
                   , IA.ITEM_ID
                   , IA.FROM_SITE
                   , IA.TO_SITE
                   , IA.MEASURE
                   , IA.YYYYMMDD
                   , IA.BOD_ID
                   , IA.QTY
                   , IA.INCOTERMS
                   , IA.TRANSPORT_MODE
                   , IA.PROJECT_CODE
                   , IA.FCST_TYPE
                   , CASE WHEN IA.ITEM_ID IS NOT NULL
                          THEN SUM(CASE WHEN IA.MEASURE IN ('SHIP_CONFIRM', 'POSTP_PLAN') THEN IA.QTY END)
                                   OVER (PARTITION BY IA.DIVISION_ID, IA.PLAN_START_YYYYMMDD, IA.PLAN_TYPE, IA.SEQ, IA.ITEM_ID, IA.FROM_SITE, IA.YYYYMMDD)
                     END AS SHIP_POSTP_QTY
                FROM GT_SSP_ANL_SHIP_PLAN_40 IA
               WHERE IA.MEASURE            IN ('WH_STOCK', 'SHIP_CONFIRM', 'POSTP_PLAN')
                 AND IA.DIVISION_ID         = V_DIVISION_ID
                 AND IA.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                 AND IA.PLAN_TYPE           = V_PLAN_TYPE
                 AND IA.SEQ                 = V_SEQ
             ) B  --  2026.11.18 ZIONEX (END)
                JOIN SCM_MST_SITE E
             ON E.DIVISION_ID = V_DIVISION_ID
            AND NVL(E.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
            AND E.DIVISION_ID = B.DIVISION_ID
            AND E.SCM_SITE_ID = B.FROM_SITE
        WHERE 1 = 1
        AND B.DIVISION_ID         = V_DIVISION_ID
        AND B.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
        AND B.PLAN_TYPE           = V_PLAN_TYPE
        AND B.SEQ                 = V_SEQ
        AND B.MEASURE = 'WH_STOCK'
        ;

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 3. 최종 SSP_ANL_SHIP_PLAN_40 생성 */
        /* ----------------------------------------------------------------------------------------------------------- */
        DELETE FROM SSP_ANL_SHIP_PLAN_40 A
         WHERE A.DIVISION_ID         = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE           = V_PLAN_TYPE
           AND A.SEQ                 = V_SEQ
           AND EXISTS ( SELECT 1
                          FROM SCM_MST_SITE E
                         WHERE E.DIVISION_ID = V_DIVISION_ID
                           AND NVL(E.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
                           AND E.DIVISION_ID = A.DIVISION_ID
                           AND E.SCM_SITE_ID = A.FROM_SITE )
        ;

        INSERT INTO /* PR_SSP_ANL_SHIP_PLAN_40 */ SSP_ANL_SHIP_PLAN_40
                ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID
                , FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID
                , QTY, ROUTE_ID, INCOTERMS, TRANSPORT_MODE, BIZ_TYPE
                , PROJECT_CODE, FCST_TYPE, FCST_ETD_DATE, FCST_ETA_DATE, ETD_DATE
                , ETA_DATE, CONFIRM_FLAG, CONFIRM_ID, CREATED_BY, CREATION_DATE
                , LAST_UPDATED_BY, LAST_UPDATE_DATE, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID
                , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE10 )
        SELECT DISTINCT
             T.DIVISION_ID
            ,T.PLAN_START_YYYYMMDD
            ,T.PLAN_TYPE
            ,T.SEQ
            ,T.ITEM_ID
            ,T.FROM_SITE
            ,T.TO_SITE
            ,T.MEASURE
            ,T.YYYYMMDD
            ,T.BOD_ID
            ,T.QTY
            ,T.ROUTE_ID
            ,T.INCOTERMS
            ,T.TRANSPORT_MODE
            ,V.OPERATION_GROUP AS BIZ_TYPE
            ,T.PROJECT_CODE
            ,T.FCST_TYPE
            ,T.FCST_ETD_DATE
            ,T.FCST_ETA_DATE
            ,T.ETD_DATE
            ,T.ETA_DATE
            ,CASE WHEN T.CONFIRM_ID LIKE 'C%' THEN 'Y' ELSE 'N' END AS CONFIRM_FLAG
            ,NVL(T.CONFIRM_ID, '-')  AS CONFIRM_ID
            ,V_BATCH_USER AS CREATED_BY
            ,SYSDATE      AS CREATION_DATE
            ,V_BATCH_USER AS LAST_UPDATED_BY
            ,SYSDATE      AS LAST_UPDATED_BY
            ,T.DIVISION_ID /* ORIGIN_FROM_DIVISION_ID */
            ,T.DIVISION_ID /* ORIGIN_TO_DIVISION_ID */
            ,T.ATTRIBUTE1  /* PROD_DATE */
            ,T.ATTRIBUTE2  /* REQUESTOR */
            ,T.ATTRIBUTE3  /* Description */
            ,T.ATTRIBUTE4  /* Prod Qty(MASS) */
            ,T.ATTRIBUTE5  /* Prod Qty(ALL) */
            ,T.ATTRIBUTE6  /* oWMS재고수량 */
            ,E.COMPANY_ID AS ATTRIBUTE10
        FROM GT_SSP_ANL_SHIP_PLAN_40 T
            JOIN SCP_MST_FINAL_ITEM V
            ON V.ITEM_ID = T.ITEM_ID
            AND V.DIVISION_ID = T.DIVISION_ID
            JOIN SCM_MST_SITE E
            ON E.DIVISION_ID = V_DIVISION_ID
            AND NVL(E.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
            AND E.DIVISION_ID = T.DIVISION_ID
            AND E.SCM_SITE_ID = T.FROM_SITE
        WHERE 1 = 1
        AND   NVL(E.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
        ;

        /* ----------------------------------------------------------------------------------------------------------- */
        /* 4 PLAN 결과 UPDATE : PLAN Detail status = 1 (정상 종료) */
        /* ----------------------------------------------------------------------------------------------------------- */
        UPDATE SCM_MST_PLAN_DETAIL
           SET PLAN_STATUS          = '1'
             , LAST_UPDATE_DATE     = SYSDATE
             , INPUT_END_DATE       = SYSDATE
             , PLAN_END_DATE        = SYSDATE
             , PLAN_OUTPUT_END_DATE = SYSDATE
             , OUTPUT_END_DATE      = SYSDATE
             , ANL_END_DATE         = SYSDATE
         WHERE DIVISION_ID = V_DIVISION_ID
           AND PLAN_ID     = V_PLAN_ID
           AND PLAN_SEQ    = V_SEQ
           AND PLAN_TYPE   = V_PLAN_TYPE
        ;

        /* SMS Daily Plan END (51) : 25-04-14 End 제외 */

        /* --------------------------------------------------------- */
        /* 실행 Logic END -- */
        /* --------------------------------------------------------- */

        IF DBMS_TRANSACTION.LOCAL_TRANSACTION_ID IS NOT NULL THEN
            COMMIT;
        END IF;

        /* TXN LOG */
        V_LOG_TYPE    := 'TXN';

        N_LOG_COUNT   := 1;
        V_LOG_MESSAGE := 'INSERT INTO '||V_TABLE_ID;
        V_DESCRIPTION := 'Process Complete...' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYYMMDD');
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );


    EXCEPTION
        WHEN OTHERS THEN

            IF DBMS_TRANSACTION.LOCAL_TRANSACTION_ID IS NOT NULL THEN
                ROLLBACK;
            END IF;

            /* ERROR LOG (SQLERRM -> 지역변수, 정적SQL 직접삽입 회피) */
            V_ERR_MSG     := SQLERRM;
            V_LOG_TYPE    := 'ERROR';
            V_LOG_MESSAGE := V_ERR_MSG;
            /* MSSQL STR(ERROR_LINE()) -> FORMAT_ERROR_BACKTRACE, VARCHAR2(500) 초과 방지 SUBSTR */
            V_DESCRIPTION := SUBSTR(V_PROGRAM_NAME || 'ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 500);
            D_EVENT_DATE  := SYSDATE;
            PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                                , P_LOG_TYPE     => V_LOG_TYPE
                                , P_LOG_COUNT    => N_LOG_COUNT
                                , P_LOG_MESSAGE  => V_LOG_MESSAGE
                                , P_DESCRIPTION  => V_DESCRIPTION
                                , P_EVENT_DATE   => D_EVENT_DATE
                                , P_USER_ID      => V_BATCH_USER
                                );

            /* PLAN Detail status = -1 (에러) */
            UPDATE SCM_MST_PLAN_DETAIL
               SET PLAN_STATUS          = '-1'
                 , LAST_UPDATE_DATE     = SYSDATE
                 , INPUT_END_DATE       = SYSDATE
                 , PLAN_END_DATE        = SYSDATE
                 , PLAN_OUTPUT_END_DATE = SYSDATE
                 , OUTPUT_END_DATE      = SYSDATE
                 , ANL_END_DATE         = SYSDATE
             WHERE DIVISION_ID = V_DIVISION_ID
               AND PLAN_ID     = V_PLAN_ID
               AND PLAN_SEQ    = V_SEQ
               AND PLAN_TYPE   = V_PLAN_TYPE
            ;

            /* SMS 전송 : Daily Plan ERROR (52) */
            V_SMS_DESC := V_DIVISION_ID || ' ' || V_COMPANY_ID || ':' || V_SMS_REQ || ':SSP';
            SCM_ADM_SMS_SEND_BATCH(52, V_SMS_DESC);


            RETURN;

    END;

    /* 임시 운영반영시에 주석처리 할것. */
    V_TOTAL_SEC := ROUND((SYSDATE - V_START_TIME) * 86400);

    V_EXEC_TIME := CASE WHEN LENGTH(TO_CHAR(TRUNC(V_TOTAL_SEC / 60))) > 2 THEN NULL
                        ELSE LPAD(TO_CHAR(TRUNC(V_TOTAL_SEC / 60)), 2, '0') || ':' ||
                            LPAD(TO_CHAR(MOD(V_TOTAL_SEC, 60)), 2, '0')
                   END;

    /* 종료 LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '['||V_PLAN_ID||']['|| V_EXEC_TIME ||']';
    D_EVENT_DATE  := SYSDATE;
    PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                        , P_LOG_TYPE     => V_LOG_TYPE
                        , P_LOG_COUNT    => N_LOG_COUNT
                        , P_LOG_MESSAGE  => V_LOG_MESSAGE
                        , P_DESCRIPTION  => V_DESCRIPTION
                        , P_EVENT_DATE   => D_EVENT_DATE
                        , P_USER_ID      => V_BATCH_USER
                        );


END;