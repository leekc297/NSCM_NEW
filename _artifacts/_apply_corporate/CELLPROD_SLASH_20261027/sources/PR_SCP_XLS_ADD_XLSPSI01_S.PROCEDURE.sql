PROCEDURE PR_SCP_XLS_ADD_XLSPSI01_S
(
      P_USER_ID                  VARCHAR2
    /* ,@P_GUBUN                 VARCHAR(040)       -- MEASURE  @P_GUBUN  PACK / CELL / SUPPLY */
    , P_DIVISION_ID              VARCHAR2                     /* NVARCHAR(030) */
    , P_PLAN_START_YYYYMMDD      VARCHAR2                     /* NVARCHAR(008) */
    , P_PLAN_TYPE                VARCHAR2                     /* NVARCHAR(050) */
    , P_SEQ                      NUMBER
    , P_ITEM_ID                  VARCHAR2                     /* NVARCHAR(050) */
    , P_MEASURE                  VARCHAR2                     /* NVARCHAR(050)   MEASURE별 */
    , P_XLS_KEY1                 VARCHAR2
    , P_CREATE_FROM_YYYYMMDD     VARCHAR2                     /* NVARCHAR(008) */
    , P_CREATE_TO_YYYYMMDD       VARCHAR2                     /* NVARCHAR(008) */

    , P_WQTY01 PLS_INTEGER DEFAULT 0, P_WQTY02 PLS_INTEGER DEFAULT 0, P_WQTY03 PLS_INTEGER DEFAULT 0, P_WQTY04 PLS_INTEGER DEFAULT 0
    , P_WQTY05 PLS_INTEGER DEFAULT 0, P_WQTY06 PLS_INTEGER DEFAULT 0, P_WQTY07 PLS_INTEGER DEFAULT 0, P_WQTY08 PLS_INTEGER DEFAULT 0
    , P_WQTY09 PLS_INTEGER DEFAULT 0, P_WQTY10 PLS_INTEGER DEFAULT 0, P_WQTY11 PLS_INTEGER DEFAULT 0, P_WQTY12 PLS_INTEGER DEFAULT 0
    , P_WQTY13 PLS_INTEGER DEFAULT 0, P_WQTY14 PLS_INTEGER DEFAULT 0, P_WQTY15 PLS_INTEGER DEFAULT 0, P_WQTY16 PLS_INTEGER DEFAULT 0
    , P_WQTY17 PLS_INTEGER DEFAULT 0, P_WQTY18 PLS_INTEGER DEFAULT 0, P_WQTY19 PLS_INTEGER DEFAULT 0, P_WQTY20 PLS_INTEGER DEFAULT 0
    , P_WQTY21 PLS_INTEGER DEFAULT 0, P_WQTY22 PLS_INTEGER DEFAULT 0, P_WQTY23 PLS_INTEGER DEFAULT 0, P_WQTY24 PLS_INTEGER DEFAULT 0
    , P_WQTY25 PLS_INTEGER DEFAULT 0, P_WQTY26 PLS_INTEGER DEFAULT 0, P_WQTY27 PLS_INTEGER DEFAULT 0, P_WQTY28 PLS_INTEGER DEFAULT 0
    , P_WQTY29 PLS_INTEGER DEFAULT 0, P_WQTY30 PLS_INTEGER DEFAULT 0, P_WQTY31 PLS_INTEGER DEFAULT 0, P_WQTY32 PLS_INTEGER DEFAULT 0
    , P_WQTY33 PLS_INTEGER DEFAULT 0, P_WQTY34 PLS_INTEGER DEFAULT 0, P_WQTY35 PLS_INTEGER DEFAULT 0, P_WQTY36 PLS_INTEGER DEFAULT 0
    , P_WQTY37 PLS_INTEGER DEFAULT 0, P_WQTY38 PLS_INTEGER DEFAULT 0, P_WQTY39 PLS_INTEGER DEFAULT 0, P_WQTY40 PLS_INTEGER DEFAULT 0
    , P_WQTY41 PLS_INTEGER DEFAULT 0, P_WQTY42 PLS_INTEGER DEFAULT 0, P_WQTY43 PLS_INTEGER DEFAULT 0, P_WQTY44 PLS_INTEGER DEFAULT 0
    , P_WQTY45 PLS_INTEGER DEFAULT 0, P_WQTY46 PLS_INTEGER DEFAULT 0, P_WQTY47 PLS_INTEGER DEFAULT 0, P_WQTY48 PLS_INTEGER DEFAULT 0
    , P_WQTY49 PLS_INTEGER DEFAULT 0, P_WQTY50 PLS_INTEGER DEFAULT 0, P_WQTY51 PLS_INTEGER DEFAULT 0, P_WQTY52 PLS_INTEGER DEFAULT 0
    /* 2021.04.13   KSW   출하계획(SHIP_PLAN) 저장 - 자동차 Partial Week 저장방식 추가
       :: Balance(WH In) Measure 값이 0 일 경우 월요일에 입력된 수량전체를 배분한다. - start
       Week 플랜구간에 대한 Partial week 정보를 입력값으로 받는다.
       'Y' : 시뮬레이터에서 Partial Week 경계선 다음날, 'N' : Partial Week 경계선 다음날이 아닌 경우
       2021.04.13   KSW   출하계획(SHIP_PLAN) 저장 - 자동차 Partial Week 저장방식 추가 - end */
    , P_PARTIAL                  VARCHAR2                     /* NVARCHAR(120)  PatialWeekYN. 원본에 DEFAULT 없음 */
    , P_DAILYQTY                 VARCHAR2 DEFAULT ''          /* nvarchar(MAX) = '' 일간수량정보(콤마) */
    , P_IS_DEBUG                 NUMBER   DEFAULT 0           /* bit = 0: RELEASE (KSK, 250417) */
    , O_RETURN_CODE              OUT NUMBER                   /* ★신설. XLSPSI 계열 반환코드 계약(사용자 결정 (a)안) */
)
/*
 * Program ID   : PR_SCP_XLS_ADD_XLSPSI01_S
 * Description  : SCP SIMULATION SAVE
 * OutTable     :
 * Execute      :
                EXEC PR_SCP_XLS_ADD_XLSPSI01_S      @p_USER_ID             ='KSK'
                                                   ,@p_division_id         = '81'
                                                   ,@p_PLAN_START_YYYYMMDD = '20230731'
                                                   ,@p_PLAN_TYPE           ='PR'
                                                   ,@p_SEQ                 ='3'
                                                   ,@p_item_id             ='APFCAPHEV-B2'
                                                   ,@p_measure             ='PACK_MODEL_CHANGE'
                                                   ,@p_xls_key1            ='5849'
                                                   ,@p_create_from_yyyymmdd = '20230731'
                                                   ,@p_WQTY01  INT = 0.0 ,@p_WQTY02  INT = 0.0 ,@p_WQTY03  INT = 0.0 ,@p_WQTY04  INT = 0.0 ,@p_WQTY05  INT = 0.0
                                                   ,@p_WQTY06  INT = 0.0 ,@p_WQTY07  INT = 0.0 ,@p_WQTY08  INT = 0.0 ,@p_WQTY09  INT = 0.0 ,@p_WQTY10  INT = 0.0
                                                   ,@p_WQTY11  INT = 0.0 ,@p_WQTY12  INT = 0.0 ,@p_WQTY13  INT = 0.0 ,@p_WQTY14  INT = 0.0 ,@p_WQTY15  INT = 0.0
                                                   ,@p_WQTY16  INT = 0.0 ,@p_WQTY17  INT = 0.0 ,@p_WQTY18  INT = 0.0 ,@p_WQTY19  INT = 0.0 ,@p_WQTY20  INT = 0.0
                                                   ,@p_WQTY21  INT = 0.0 ,@p_WQTY22  INT = 0.0 ,@p_WQTY23  INT = 0.0 ,@p_WQTY24  INT = 0.0 ,@p_WQTY25  INT = 0.0
                                                   ,@p_WQTY26  INT = 0.0 ,@p_WQTY27  INT = 0.0 ,@p_WQTY28  INT = 0.0 ,@p_WQTY29  INT = 0.0 ,@p_WQTY30  INT = 0.0
                                                   ,@p_WQTY31  INT = 0.0 ,@p_WQTY32  INT = 0.0 ,@p_WQTY33  INT = 0.0 ,@p_WQTY34  INT = 0.0 ,@p_WQTY35  INT = 0.0
                                                   ,@p_WQTY36  INT = 0.0 ,@p_WQTY37  INT = 0.0 ,@p_WQTY38  INT = 0.0 ,@p_WQTY39  INT = 0.0 ,@p_WQTY40  INT = 0.0
                                                   ,@p_WQTY41  INT = 0.0 ,@p_WQTY42  INT = 0.0 ,@p_WQTY43  INT = 0.0 ,@p_WQTY44  INT = 0.0 ,@p_WQTY45  INT = 0.0
                                                   ,@p_WQTY46  INT = 0.0 ,@p_WQTY47  INT = 0.0 ,@p_WQTY48  INT = 0.0 ,@p_WQTY49  INT = 0.0 ,@p_WQTY50  INT = 0.0
                                                   ,@p_WQTY51  INT = 0.0 ,@p_WQTY52  INT = 0.0
 *
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.01.21   KTH            Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2019.01.31   KTH            SCP_ANL_PRODUCTION_PLAN 저장로직 반영
 * 2019.02.11   KTH            SCP_ANL_SHIPMENT_PLAN_SEMI 저장로직 반영
 * 2019.02.12   KTH            SCP_ANL_SHIPMENT_PLAN_FG 저장로직 반영, LINE_TOTAL_LOAD_ENGINE UPDATE 반영
 * 2019.02.15   KTH            'FN' 일 경우 저장 되지 않도록 수정
 * 2019.03.05   KTH            HISTORY 테이블 반영, @p_user_id 구분 하도록 수정
 * 2019.04.03   KTH            WEEK 로직 반영
 * 2019.04.08   KTH            LINE LOAD율 수정
 * 2019.05.02   KTH            출하계획 수정시 특정 요일에 저장(@x_DAYOFWEEK_NO) 1~7(일~토)
 * 2019.05.08   KTH            수정된 DATA 외에는 특정 요일 반영 금지로직 추가
 * 2019.05.24   KTH            FROZEN 구간 DATA 미반영 로직 추가
 * 2019.05.30   KTH            FROZEN 구간 'SE'추가
 * 2019.06.03   KTH            저장후 시물레이션 데이터 UPDATE 로직 변경
 * 2019.06.05   KTH            출하(FG/SEMI) FROZEN DATA 미반영 구간 'PR'추가
 * 2019.06.12   KTH            Line Load율 로직 변경
 * 2019.06.14   KTH            생산 FROZEN 구간 MA(-7)로직 제거
 * 2019.07.06   KTH            입력된 버전과 현재 버전이 다를 경우 RETURN
 * 2020.04.08   KTH            SCP_ANL_SHIPMENT_PLAN_FIX(FG) 변경조건 추가 (PROJECT_CODE)
 * 2020.07.21   KSW            항차를 고려한 출하계획 저장로직 개발 (L/T를 고려한 요일별 분배)
 * 2020.09.02   KSW            항차를 고려한 출하계획 저장로직 개발 (L/T를 고려한 요일별 분배) ==> 트럭(TRK) 제외
 * 2020.10.16   KSW            C20201016-000200 :: GSCM 시스템의 RTF 적확도 개선을 위한 SSP구간 Shipment 수량 변경 기능 요청 건
 *                              SHIP_PLAN 저장시 Frozen 구간 체크하지 않음 (PR, MA plan 한함)
 * 2020.10.28   KSW            C20201019-000175   SCP-FP 협의사항 수정반영 요청 (화 -> 수) - 자동차(81) 사업부의 경우 Final Plan 제외하고 전 구간 생산계획 수정 가능
 * 2021.03.17   KSW            temp table 일괄 drop 스크립트 추가
 * 2021.04.13   KSW            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 출하계획(SHIP_PLAN) 저장 - 자동차 Partial Week 저장방식 추가
 *                              :: Balance(WH In) Measure 값이 0 일 경우 월요일에 입력된 수량전체를 배분한다.
 * 2021.05.24   KSW            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - 저장방식을 1 year 단위로 저장
 * 2021.08.11   KSW            PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - 형교환 적용
 * 2021.08.19   KSW            PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
 * 2021.10.25   KSW            튜닝개선요청에 따른 변경
 * 2021.12.06   KSW            SEMI SHIP PLAN 에 대한 PR/MA Frozen 구간해제
 * 2022.03.21   KSW            GM JV 반영
 * 2022.06.27   KSW            출하 수량을 항차별 n/1 --> 출하 Lot Size 를 고려한 출하수량 배분으로 변경
 * 2022.09.19   KSW            생산계획(PACK_PROD, CELL_PROD) 일배분로직 변경 - 1/7 에서 워킹타임(CAPA 로스타임을 고려한) 비율로 변경
 * 2023.01.13   KKH            시뮬레이터 저장 후 숫자 변경 오류 (배분 로직 수정 weekly 11 -> 12로 출력되는 현상)
 * 2023.05.03   KSK            [PJ20230691  SCM 역량 강화 위한 SCP 개선과제 이행] UI / Simulator에서  SE 단계에서 Frozen 구간 수정 불가
 * 2023.08.24   KSK            [PJ20230691] SCM 역량 강화 위한 SCP 개선과제 이행 (52주차 초과플랜의  SHIPMENT FG 파샬위크 SPLIT 저장로직 반영)
 * 2023.10.23   OIJ            전달 변수를 지역변수로 변경하여 사용하도록 수정
 * 2023.10.23   OIJ            IF @v_batch_measure IN  ('PACK_PROD', 'CELL_PROD') 연산 방식 수정(update -> select + insert)
 * 2023.11.07   OIJ            IF @v_batch_measure IN  ('PACK_MODEL_CHANGE','CELL_MODEL_CHANGE') 인덱스활용하도록 수정
 * 2023.11.07   OIJ            IF @v_batch_measure IN  ('SHIP_PLAN','SEMI_SHIP_PLAN')  연산 방식 수정(update -> select + insert)
 * 2023.12.26   KSK            [PJ20230692] SCM 역량 강화 위한 SCP 개선과제 이행2 ( SHIP_PLAN 및 SEMI_SHIP_PLAN 일분배 로직 시뮬레이터로 이동)
 * 2024.09.03   KSK            구문오류방지 위해 formatMessage에서 xls_key1갑을 위해 %d 사용 및 입력파라미터가 아닌 지역변수 @p_to_yyyymmdd의 삭제
 * 2024.09.03   KSK            프로시저 종료시 로그이력에 1년차 xls_key1 대신에 현재 저장되는 데이터의 xls_key1 기록
 * 2024.04.17   KSK            디버그 파라미터(@p_is_debug) 추가 및 디버그 메세지 추가
 * 2025.12.09   HRK            [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인에 매핑된 JV CELL 생산계획 수정인 경우 SKIP처리 (ESS->JV 단방향 동기화 반영)
 * 2026-08-07   ZIONEX         [PJ202650304] NextSCM Migration
 *     부모 PR_SCP_XLS_ADD_XLSPSI01 이 반환값으로 2회차(2 year) 실행 여부를 가른다. 그래서 시그니처
 *       원본 L186  return -1 : PLAN_TYPE 이 FN 이면 수정금지        = ★정상 스킵(에러 아님)
 *       원본 L227  return -1 : ESS 가상 라인 매핑 SKIP [PJ2025F254] = ★정상 스킵(에러 아님)
 *       원본 L3326 return -1 : CATCH 블록                           = ★에러(로그만 남기고 흡수, RAISE 금지)
 *       원본 L3348 return  1 : 정상 종료
 *   - 임시테이블 #temp 12종 -> GTT(GT_XPGT_*). DROP/CREATE 대신 각 사용 직전 DELETE 로 초기화.
 *     ★GT_XPGT_SCM_MST_SITE 는 부모 PR_SCP_XLS_ADD_XLSPSI01 이 채우고 이 자식은 읽기만 하는 공유 GTT 다
 *       활성 참조는 원본 L2102(SE 단계 PROD FROZEN 삭제 조인) 하나뿐이고 L283~L309 생성문은 死코드다.
 *     ★#SCM_WORK_CALENDAR_M 은 계열 명명표에 없던 신규다. PR_SCP_XLS_* 44개 전수 스캔 결과 이 객체
 *   - ★결과셋 계약(계약·명명표 §4) : 원본 L504~L506 의 DECLARE @WORK_AVALIABLE TABLE 및
 *     INSERT @WORK_AVALIABLE EXEC PR_SCP_XLS_LINE_WORKINGTIME_BY_LOSS_AVAILABLE 은 Oracle 무대응이다.
 *     ★비우는 책임은 공급자다 - 소비자인 이 프로시저는 DELETE 하지 않는다(LS-042).
 *   - ★MSSQL 임시테이블 컬럼이 INT 인 자리(#LINE_WORKINGTIME_BY_LOSS.WORKING_TIME / #LineLoad 의
 *     QTY·CAPA_TACT·WORKING_TIME·TIME_TERM / #SCP_ANL_PRODUCTION_PLAN 의 QTY·CELL_QTY)는 MSSQL 이
 *   - MSSQL composable DML (INSERT .. SELECT FROM (MERGE .. OUTPUT $action) Changes WHERE Action=INSERT)
 *     은 Oracle 에 대응 구문이 없다. MERGE 가 INSERT 할 행 집합 = ON 절 미매칭 원천행이므로 MERGE 직전에
 *     NOT EXISTS 로 같은 집합을 뽑아 PROD_PLAN_ENGINE 짝 행을 먼저 INSERT 한다(MEASURE 가 달라 매칭 무영향).
 *   - UPDATE .. FROM .. JOIN 은 원천이 조인키당 유일함을 보장할 수 있는 곳만 MERGE 로, 그 밖에는
 *     상관 UPDATE + EXISTS(필요하면 ROWNUM = 1 스칼라 서브쿼리)로 옮겨 ORA-30926/ORA-38104 를 차단한다(CV-024).
 *   - WITH (NOLOCK) / WITH (TABLOCK) 은 Oracle 다중버전 읽기일관성으로 대응이 없어 전 구문에서 제거.
 *   - 동적 SQL 버퍼(@SQL / @mQry_sum / @mEXEC)는 364컬럼 조립이 33,000자를 넘어 VARCHAR2(32767) 로는
 *     담을 수 없다 -> CLOB + EXECUTE IMMEDIATE (CV-040/CV-046).
 */
AS
    /*  파라미터 변수 선언 (원본 L122~L134) */
    V_COMPANY_ID                   VARCHAR2(100 CHAR) := '';
    V_BATCH_USER                   VARCHAR2(150 CHAR) := '';
    V_BATCH_DIVISION_ID            VARCHAR2(30 CHAR) := '';
    V_BATCH_PLAN_START_YYYYMMDD    VARCHAR2(8 CHAR) := '';
    V_BATCH_PLAN_TYPE              VARCHAR2(8 CHAR) := '';   /* 원본 NVARCHAR(8) - 파라미터(50)보다 좁다 */
    V_BATCH_SEQ                    NUMBER(19);
    V_BATCH_ITEM_ID                VARCHAR2(50 CHAR) := '';
    V_BATCH_MEASURE                VARCHAR2(50 CHAR);
    V_BATCH_XLS_KEY1               NUMBER(10);
    V_BATCH_CREATE_FROM_YYYYMMDD   VARCHAR2(8 CHAR);
    V_BATCH_CREATE_TO_YYYYMMDD     VARCHAR2(8 CHAR);
    V_BATCH_PARTIAL                VARCHAR2(120 CHAR);
    /*  LOG 용 변수 설정 (원본 L148~L156) */
    V_BATCH_USER_SIM               VARCHAR2(150 CHAR) := '';
    V_PROGRAM_NAME                 VARCHAR2(150 CHAR) := 'PR_SCP_XLS_ADD_XLSPSI01_S';
    V_LOG_TYPE                     VARCHAR2(30 CHAR);   /* START/END/ERROR/... */
    N_LOG_COUNT                    INTEGER := 0;
    V_LOG_MESSAGE                  VARCHAR2(1000 CHAR);
    V_DESCRIPTION                  VARCHAR2(500 CHAR);
    V_TABLE_ID                     VARCHAR2(150 CHAR) := 'SCP_XLS_PSI_GLOBAL';
    D_EVENT_DATE                   DATE;
    /*  임시 실행시간 확인용 (원본 L178~L180) */
    V_START_TIME                   DATE;
    V_EXEC_TIME                    VARCHAR2(10 CHAR);   /* '[00:00]' */
    N_ELAPSED_SEC                  NUMBER;

    N_ESS_CNT                      PLS_INTEGER := 0;
    /*  동적 SQL 조립 버퍼 (원본 L311 @SQL / L3072 @mQry_sum / L3091 @mEXEC 는 전부 NVARCHAR(MAX)). */
    V_SQL                          CLOB;
    V_MQRY_SUM                     CLOB;
    V_MEXEC                        CLOB;
    /*  원본 L320 : 30 주 (중장기구간) 에 대한 XLS_KEY1 값 재확인용 */
    V_LINK_XLS_KEY1                VARCHAR2(200 CHAR) := '';
    /*        UNPIVOT 원천(같은 XLS_KEY1)도 0행이라 결과가 어차피 0행이다(행 소실 없음). */
    V_BOD_FROM                     VARCHAR2(12 CHAR) := '';
    V_BOD_TO                       VARCHAR2(12 CHAR) := '';
    /*  원본 L467~L470 : Working Time 에 따른 daily 분배용 */
    V_PROD_LINE_ID                 VARCHAR2(12 CHAR) := '';
    V_SCM_SITE                     VARCHAR2(12 CHAR) := '';
    V_OPERATION                    VARCHAR2(12 CHAR) := '';
    V_WKCNT                        PLS_INTEGER := 0;
    /*  원본 L535~L540 : WHILE 일배분 루프용. 2023.10.23 개선(select+insert)으로 루프가 사라져 사용처 0건. 선언 보존 */
    V_LP                           PLS_INTEGER := 1;
    V_DAYLP                        PLS_INTEGER := 1;
    V_WEEKLP                       PLS_INTEGER := 1;
    V_ADDDAY                       PLS_INTEGER := 0;
    V_FIRST_DAY                    PLS_INTEGER := 0;
    /*  원본 L915~L919 : 형교환(Model Change) 저장용 */
    V_FROM_SITE                    VARCHAR2(12 CHAR) := '';
    V_OPERATION_ID                 VARCHAR2(12 CHAR) := '';
    V_PROD_LINE                    VARCHAR2(12 CHAR) := '';
    V_VERSION_ID                   VARCHAR2(12 CHAR) := '';
    V_P_PLAN_ID                    VARCHAR2(12 CHAR) := '';   /* 원본 @p_plan_id 는 파라미터가 아니라 지역변수다 */
    /*  원본 L2561~L2573 : SCP_ANL_SHIPMENT_PLAN_FG/SEMI PK Parameter, SCP_ANL_PRODUCTION_PLAN PK Parameter */
    V_X_ITEM_ID                    VARCHAR2(50 CHAR) := '';
    V_X_OPERATION_GROUP            VARCHAR2(50 CHAR) := '';   /* BIZ_TYPE */
    V_X_PROJECT_CODE               VARCHAR2(50 CHAR) := '';
    V_X_TO_SITE                    VARCHAR2(50 CHAR) := '';
    V_X_INCOTERMS                  VARCHAR2(50 CHAR) := '';
    V_X_FROM_SITE                  VARCHAR2(50 CHAR) := '';   /* SCM_SITE_ID */
    V_X_BOD_ID                     VARCHAR2(50 CHAR) := '';
    V_X_LINE_ID                    VARCHAR2(50 CHAR) := '';
    V_X_OPERATION_ID               VARCHAR2(50 CHAR) := '';

    V_LINE_ID                      VARCHAR2(100 CHAR) := '';
BEGIN
    /*  XLSPSI 계열 반환코드 계약 : 원본의 정상 종료값(return 1)으로 초기화하고 경로별로 덮어쓴다. */
    O_RETURN_CODE := 1;

    /*  원본 L116 파라미터 디버그 SELECT (원본에서도 주석 처리된 死코드) 원문보존
        SELECT N'파라미터' tn,  @p_dailyQty, @P_WQTY01, @P_WQTY02, ... , @P_WQTY52 --TEST */


    /*  파라미터 -> 지역변수 (원본 L136~L146 / 2023.10.23 OIJ 전달 변수를 지역변수로 변경) */

    V_BATCH_USER                 := SUBSTR(P_USER_ID, 1, 100);              /* 원본 @p_user_id VARCHAR(100) 경계 */
    V_BATCH_DIVISION_ID          := SUBSTR(P_DIVISION_ID, 1, 30);
    V_BATCH_PLAN_START_YYYYMMDD  := SUBSTR(P_PLAN_START_YYYYMMDD, 1, 8);
    V_BATCH_PLAN_TYPE            := SUBSTR(P_PLAN_TYPE, 1, 8);              /* 원본 @v_batch_plan_type 은 NVARCHAR(8) */
    V_BATCH_SEQ                  := P_SEQ;
    V_BATCH_ITEM_ID              := SUBSTR(P_ITEM_ID, 1, 50);
    V_BATCH_MEASURE              := SUBSTR(P_MEASURE, 1, 50);
    /*  원본 : SET @v_batch_xls_key1 = CAST(@p_xls_key1 AS INT) -- 전달된 XLS_KEY1 */
    V_BATCH_XLS_KEY1             := TO_NUMBER(P_XLS_KEY1);
    V_BATCH_CREATE_FROM_YYYYMMDD := SUBSTR(P_CREATE_FROM_YYYYMMDD, 1, 8);
    V_BATCH_CREATE_TO_YYYYMMDD   := SUBSTR(P_CREATE_TO_YYYYMMDD, 1, 8);
    V_BATCH_PARTIAL              := SUBSTR(P_PARTIAL, 1, 120);


    V_LOG_TYPE     := 'START';
    V_LOG_MESSAGE  := '########## Start of procedure ##########';
    V_DESCRIPTION  := V_PROGRAM_NAME || ':' || ' SCP_XLS_PSI_GLOBAL SAVE LOGIC';
    D_EVENT_DATE   := SYSDATE;
    PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME  => V_PROGRAM_NAME
                        , P_LOG_TYPE      => V_LOG_TYPE
                        , P_LOG_COUNT     => N_LOG_COUNT
                        , P_LOG_MESSAGE   => V_LOG_MESSAGE
                        , P_DESCRIPTION   => V_DESCRIPTION
                        , P_EVENT_DATE    => D_EVENT_DATE
                        , P_USER_ID       => V_BATCH_USER
                        );
    /*  원본 L172~L175 반영보류(KSK) 주석 보존
                              , @p_attribute1 = @p_division_id
                              ;                                  */

    /*  임시 실행시간 확인용 (원본 L178~L180) */
    V_START_TIME   := SYSDATE;
    V_EXEC_TIME    := '';   /* '[00:00]'; */

    /* PRINT @v_batch_plan_type */
    /*  PLAN_TYPE이 FN일경우 수정금지 RETURN */
    IF V_BATCH_PLAN_TYPE = 'FN' THEN
        /*  원본 L186~L187 : if @v_batch_plan_type = 'FN' return -1 */
        O_RETURN_CODE := -1;
        RETURN;
    END IF;

    /* ---------------------------------------------------------------------------------------------------------- */
    /* ### Start : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인에 매핑된
                  JV CELL 생산계획 수정인 경우 SKIP처리 (ESS->JV 단방향 동기화 반영) */
    /* ---------------------------------------------------------------------------------------------------------- */
    /*  원본 L192 : print convert(varchar(30), getdate(), 121) + N' JV/ESS 라인 및 scm site 매핑 정보 추출'
        -> DBMS_OUTPUT (CV-027). 두 피연산자 모두 NOT NULL 이라 MSSQL + 결합의 NULL 전파는 성립하지 않는다. */
    DBMS_OUTPUT.PUT_LINE( TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || ' JV/ESS 라인 및 scm site 매핑 정보 추출' );
    /* ---------------------------------------------------------------------------------------------------------- */
    /*        (dev 26ai 실측 : 두 함수 모두 인자 0개, RETURN ... PIPELINED). */
    SELECT COUNT(*)
      INTO N_ESS_CNT
      FROM SCP_XLS_PSI_GLOBAL XL   /* PK : DIVISION_ID, CREATE_FROM_YYYYMMDD, XLS_KEY1 */
           INNER JOIN TABLE(FN_GET_JV_REAL_ESS_VIRTUAL_SITE_MAP()) SM
                   ON SM.RP_DIVISION_ID  = XL.DIVISION_ID
                  AND SM.RP_SCM_SITE_ID  = XL.FROM_SITE
           INNER JOIN TABLE(FN_GET_JV_REAL_ESS_VIRTUAL_LINE_MAP()) LM
                   ON LM.RL_DIVISION_ID  = SM.RP_DIVISION_ID
                  AND LM.RL_COMPANY_ID   = SM.RP_COMPANY_ID
                  AND LM.RL_SITE_ID      = SM.RP_SITE_ID
                  AND LM.RL_PLANT_ID     = SM.RP_PLANT_ID
                  AND LM.RL_LINE_ID      = XL.PROD_LINE
     WHERE 1 = 1
       AND XL.DIVISION_ID          = V_BATCH_DIVISION_ID
       AND XL.CREATE_FROM_YYYYMMDD = V_BATCH_CREATE_FROM_YYYYMMDD
       AND XL.XLS_KEY1             = V_BATCH_XLS_KEY1
       AND XL.PLAN_START_YYYYMMDD  = V_BATCH_PLAN_START_YYYYMMDD
       AND XL.PLAN_TYPE            = V_BATCH_PLAN_TYPE
       AND XL.SEQ                  = V_BATCH_SEQ
       AND XL.MEASURE              = 'CELL_PROD'
       AND ROWNUM                  = 1;

    IF N_ESS_CNT > 0 THEN
        /*  종료 LOG 남기고 return */
        V_LOG_TYPE     := 'END';
        V_LOG_MESSAGE  := '########## END of procedure ##########';

        V_DESCRIPTION  := CASE WHEN V_BATCH_DIVISION_ID IS NULL OR V_BATCH_PLAN_START_YYYYMMDD IS NULL
                                 OR V_BATCH_MEASURE IS NULL OR V_BATCH_XLS_KEY1 IS NULL
                               THEN NULL
                               ELSE '[' || V_BATCH_DIVISION_ID || '][' || V_BATCH_PLAN_START_YYYYMMDD
                                    || '][' || V_BATCH_MEASURE || '][' || LPAD(TO_CHAR(V_BATCH_XLS_KEY1), 10)
                                    || '][ESS 가상 라인 매핑]'
                          END;
        D_EVENT_DATE   := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME  => V_PROGRAM_NAME
                            , P_LOG_TYPE      => V_LOG_TYPE
                            , P_LOG_COUNT     => N_LOG_COUNT
                            , P_LOG_MESSAGE   => V_LOG_MESSAGE
                            , P_DESCRIPTION   => V_DESCRIPTION
                            , P_EVENT_DATE    => D_EVENT_DATE
                            , P_USER_ID       => V_BATCH_USER
                            );
        /*  원본 L227 : RETURN -1 -- 저장 SKIP */
        O_RETURN_CODE := -1;
        RETURN;
    END IF;
    /* ---------------------------------------------------------------------------------------------------------- */
    /* ### End : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인에 매핑된
                JV CELL 생산계획 수정인 경우 SKIP처리 (ESS->JV 단방향 동기화 반영) */
    /* ---------------------------------------------------------------------------------------------------------- */

    /* --------------------------------------------------------------------------------------------- */
    /*  입력된 버전과 현재 버전이 다를 경우 RETURN  (원본 L233~L249 : 원본에서도 전부 주석 처리된 死코드) */
    /* --------------------------------------------------------------------------------------------- */
    /*    DECLARE   @v_division_id          NVARCHAR(030) = @v_batch_division_id
                  , @v_plan_start_yyyymmdd  NVARCHAR(008) = @p_plan_start_yyyymmdd
                  , @v_plan_type            NVARCHAR(050) = @v_batch_plan_type
                  , @v_seq                  INT           = @v_batch_seq
          SELECT TOP 1  @v_division_id          = DIVISION_ID
                      , @v_plan_start_yyyymmdd  = PLAN_START_YYYYMMDD
                      , @v_plan_type            = PLAN_TYPE
                      , @v_seq                  = SEQ
            FROM SCP_XLS_PSI_GLOBAL WITH (NOLOCK)
        IF (@v_batch_division_id <> @v_division_id OR @p_plan_start_yyyymmdd <> @v_plan_start_yyyymmdd
            OR @v_batch_plan_type <> @v_plan_type OR @v_batch_seq <> @v_seq)
          return -1                                                                                    */
    /* --------------------------------------------------------------------------------------------- */

    /* PRINT @v_batch_plan_type */
    BEGIN

        IF P_IS_DEBUG = 1 THEN
            /*  원본 L259 : SELECT @p_dailyQty AS "@p_dailyQty1" (디버그 결과셋) -> DBMS_OUTPUT (H-9/CV-053) */
            DBMS_OUTPUT.PUT_LINE(P_DAILYQTY);
        END IF;

        /* ------------------------------------------------------------------------------------- */
        /*  SCM_ADM_LOOKUP_MASTER_DETAIL.LOOKUP_TYPE  ='DAYOFWEEK_NO'
            저장할 요일 (월,화,수,목,금,토,일:2,3,4,5,6,7,1), 8이상은 일배분  (원본 L262~L309 : 전부 死코드) */
        /* ------------------------------------------------------------------------------------- */
        /*  DECLARE @x_DAYOFWEEK_NO INT = 8 --(1~7) 8은 일별배분 (월,화,수,목,금,토,일:2,3,4,5,6,7,1)
            SELECT SEGMENT1, SEGMENT2, DESCRIPTION
            SELECT TOP 1 @x_DAYOFWEEK_NO = ISNULL(SEGMENT2,8)
              FROM dbo.SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK)
             WHERE LOOKUP_TYPE  ='SHIP_PLAN_SAVE_WEEK'--'DAYOFWEEK_NO'
               AND SEGMENT1     = @v_batch_division_id -- DIVISION_ID
               AND VALID_YN ='Y'
               -- 선택된 항목만 주로 변경해야 하기 때문에 반영하지 않도록 수정 2019.05.07
               --SET @x_DAYOFWEEK_NO = '8'
            DECLARE @v_batch_create_to_yyyymmdd  VARCHAR(8) = CONVERT(VARCHAR(8), DATEADD(day, 364, @p_plan_start_yyyymmdd), 112) */
        /*  FROZEN 구간 대상 DATA 생성 (원본 L280~L309 : #SCM_MST_SITE 생성문. 死코드)
            IF OBJECT_ID('tempdb..#SCM_MST_SITE') IS NOT NULL
                DROP TABLE #SCM_MST_SITE
            SELECT
                   S.DIVISION_ID
                  ,S.PLANT_ID
                  ,S.OPERATION_GROUP
                  ,S.SCM_SITE_ID
                  ,S.SHIP_FROZEN
                  ,(S.SHIP_FROZEN/7 + (CASE WHEN SHIP_FROZEN%7 > 0 THEN 1 ELSE 0 END)) AS SHIP_FROZEN_WEEK
                  ,CONVERT(NVARCHAR(8),  DATEADD(WEEK, (S.SHIP_FROZEN/7 + (CASE WHEN SHIP_FROZEN%7 > 0 THEN 1 ELSE 0 END)), @v_batch_plan_start_yyyymmdd), 112)  AS SHIP_FROZEN_WEEK_DAY
                  ,S.PROD_FROZEN
                  ,(S.PROD_FROZEN/7 + (CASE WHEN PROD_FROZEN%7 > 0 THEN 1 ELSE 0 END)) AS PROD_FROZEN_WEEK
                  ,CONVERT(NVARCHAR(8),  DATEADD(WEEK, (S.PROD_FROZEN/7 + (CASE WHEN PROD_FROZEN%7 > 0 THEN 1 ELSE 0 END)), @v_batch_plan_start_yyyymmdd), 112)  AS PROD_FROZEN_WEEK_DAY
                  ,CONVERT(NVARCHAR(8),  DATEADD(WEEK, ( (CASE WHEN ((S.PROD_FROZEN -7) > 0) THEN (S.PROD_FROZEN -7) ELSE 0 END) /7 + (CASE WHEN (CASE WHEN ((S.PROD_FROZEN -7) > 0) THEN (S.PROD_FROZEN -7) ELSE 0 END)%7 > 0 THEN 1 ELSE 0 END)), @v_batch_plan_start_yyyymmdd), 112)  AS PROD_FROZEN_WEEK_DAY_MA
                  ,S.FP_PLAN_PERIOD
                  ,S.VALID_YN
                  ,S.NEW_YN
                  ,S.COMPANY_ID
                  ,S.LOGISTIC_PLANT_ID
                  ,S.PACKER_ITEM_ID_SUFFIX
              INTO #SCM_MST_SITE
              FROM SCM_MST_SITE S WITH (NOLOCK)
             WHERE S.SITE_TYPE = 'PLANT' AND S.VALID_YN = 'Y' AND S.DIVISION_ID = @v_batch_division_id ;
            ★이 생성문은 死코드지만 원본 L2102 의 조인은 활성이다. MSSQL 은 호출자(부모)가 만든 #SCM_MST_SITE 가 */

        /*  DECLARE @SQL NVARCHAR(MAX);  -> 선언부 V_SQL CLOB */
        /*  SELECT @v_batch_create_from_yyyymmdd AS "@v_batch_create_from_yyyymmdd", @v_batch_create_to_yyyymmdd   AS "@v_batch_create_to_yyyymmdd" --TEST */

        /*  XLS_KEY1 불일치 오류수정 - KSW 2021.08.30 - start */
        /*  30 주 (중장기구간) 에 대한 XLS_KEY1 값 재확인 */
        IF ( V_BATCH_PLAN_START_YYYYMMDD <> V_BATCH_CREATE_FROM_YYYYMMDD ) THEN
            /*  원본 L318 naked SELECT N'XLS_KEY1 불일치 발견' MSG, ... 는 디버그 결과셋이다 -> DBMS_OUTPUT (H-9) */
            DBMS_OUTPUT.PUT_LINE('XLS_KEY1 불일치 발견 [' || V_BATCH_PLAN_START_YYYYMMDD || '][' || V_BATCH_CREATE_FROM_YYYYMMDD || ']');

            /*  MSSQL 대입형 SELECT (집계 없음) : 0행이면 변수 기존값 유지, 다행이면 마지막 행이 남는다.
                SELECT INTO 는 NO_DATA_FOUND/ORA-01422 라 커서 FOR 루프로 1:1 재현한다. */
            FOR R IN ( SELECT Y.XLS_KEY1
                         FROM ( SELECT *
                                  FROM SCP_XLS_PSI_GLOBAL
                                 WHERE PLAN_START_YYYYMMDD  = V_BATCH_PLAN_START_YYYYMMDD
                                   AND PLAN_TYPE            = V_BATCH_PLAN_TYPE
                                   AND SEQ                  = V_BATCH_SEQ
                                   AND CREATE_FROM_YYYYMMDD = V_BATCH_PLAN_START_YYYYMMDD
                                   AND DIVISION_ID          = V_BATCH_DIVISION_ID   /* 2022.03.21 KSW GM JV 반영 */
                                   AND XLS_KEY1             = V_BATCH_XLS_KEY1
                              ) X
                            , SCP_XLS_PSI_GLOBAL Y
                        WHERE Y.PLAN_START_YYYYMMDD  = X.PLAN_START_YYYYMMDD
                          AND Y.PLAN_TYPE            = X.PLAN_TYPE
                          AND Y.SEQ                  = X.SEQ
                          AND Y.CREATE_FROM_YYYYMMDD = V_BATCH_CREATE_FROM_YYYYMMDD
                          AND Y.DIVISION_ID          = X.DIVISION_ID                /* 2022.03.21 KSW GM JV 반영 */
                          AND Y.OPERATION_GROUP      = X.OPERATION_GROUP
                          AND Y.CELL_ITEM_ID         = X.CELL_ITEM_ID
                          AND Y.ITEM_ID              = X.ITEM_ID
                          AND Y.TO_SITE              = X.TO_SITE
                          AND Y.PROJECT_CODE         = X.PROJECT_CODE
                          AND Y.INCOTERMS            = X.INCOTERMS
                          AND Y.FROM_SITE            = X.FROM_SITE
                          AND Y.TRANSPORT_MODE       = X.TRANSPORT_MODE
                          AND Y.PROD_LINE            = X.PROD_LINE
                          AND Y.BOD_ID               = X.BOD_ID
                          AND Y.MEASURE              = X.MEASURE
                     )
            LOOP
                V_LINK_XLS_KEY1 := TO_CHAR(R.XLS_KEY1);
            END LOOP;

            /*  원본 SET @v_batch_xls_key1 = @v_link_xls_key1 (NVARCHAR -> INT 묵시변환) */
            V_BATCH_XLS_KEY1 := TO_NUMBER(V_LINK_XLS_KEY1);

            /*  SELECT @v_batch_xls_key1 "수정된 XLS_KEY1 ", @p_xls_key1 AS "원래 XLS_KEY1" --TEST */
        END IF;
        /*  XLS_KEY1 불일치 오류수정 - KSW 2021.08.30 - end */

        /*  일분배 로직을 시뮬레이터로 이동하여 코드 간소화 및 속도개선효과 도모(KSK, 2024-04-29) */
        IF V_BATCH_MEASURE IN ('SHIP_PLAN', 'SEMI_SHIP_PLAN') THEN

            /*  MSSQL 대입형 SELECT (집계 없음) -> 커서 FOR 루프(0행이면 기존값 유지) */

            FOR R IN ( SELECT (CASE WHEN ATTRIBUTE3 IS NULL THEN '19900101'
                                    ELSE SUBSTR(ATTRIBUTE3, 1, 8) END) AS BOD_FROM
                            , (CASE WHEN ATTRIBUTE3 IS NULL THEN '29991231'
                                    ELSE SUBSTR(ATTRIBUTE3, GREATEST(LENGTH(ATTRIBUTE3) - 8 + 1, 1), 8) END) AS BOD_TO
                         FROM SCP_XLS_PSI_GLOBAL
                        WHERE 0 = 0   /* 1024추가 */
                          AND DIVISION_ID          = V_BATCH_DIVISION_ID
                          AND CREATE_FROM_YYYYMMDD = V_BATCH_CREATE_FROM_YYYYMMDD
                          AND XLS_KEY1             = V_BATCH_XLS_KEY1
                     )
            LOOP
                V_BOD_FROM := R.BOD_FROM;
                V_BOD_TO   := R.BOD_TO;
            END LOOP;

            /*  SELECT @v_bod_from AS "@v_bod_from", @v_bod_to AS "@v_bod_to" --TEST */

            UPDATE SCP_XLS_PSI_GLOBAL
               SET
                     WQTY01 = CASE WHEN P_WQTY01 = -9 THEN WQTY01 ELSE P_WQTY01 END
                   , WQTY02 = CASE WHEN P_WQTY02 = -9 THEN WQTY02 ELSE P_WQTY02 END
                   , WQTY03 = CASE WHEN P_WQTY03 = -9 THEN WQTY03 ELSE P_WQTY03 END
                   , WQTY04 = CASE WHEN P_WQTY04 = -9 THEN WQTY04 ELSE P_WQTY04 END
                   , WQTY05 = CASE WHEN P_WQTY05 = -9 THEN WQTY05 ELSE P_WQTY05 END
                   , WQTY06 = CASE WHEN P_WQTY06 = -9 THEN WQTY06 ELSE P_WQTY06 END
                   , WQTY07 = CASE WHEN P_WQTY07 = -9 THEN WQTY07 ELSE P_WQTY07 END
                   , WQTY08 = CASE WHEN P_WQTY08 = -9 THEN WQTY08 ELSE P_WQTY08 END
                   , WQTY09 = CASE WHEN P_WQTY09 = -9 THEN WQTY09 ELSE P_WQTY09 END
                   , WQTY10 = CASE WHEN P_WQTY10 = -9 THEN WQTY10 ELSE P_WQTY10 END
                   , WQTY11 = CASE WHEN P_WQTY11 = -9 THEN WQTY11 ELSE P_WQTY11 END
                   , WQTY12 = CASE WHEN P_WQTY12 = -9 THEN WQTY12 ELSE P_WQTY12 END
                   , WQTY13 = CASE WHEN P_WQTY13 = -9 THEN WQTY13 ELSE P_WQTY13 END
                   , WQTY14 = CASE WHEN P_WQTY14 = -9 THEN WQTY14 ELSE P_WQTY14 END
                   , WQTY15 = CASE WHEN P_WQTY15 = -9 THEN WQTY15 ELSE P_WQTY15 END
                   , WQTY16 = CASE WHEN P_WQTY16 = -9 THEN WQTY16 ELSE P_WQTY16 END
                   , WQTY17 = CASE WHEN P_WQTY17 = -9 THEN WQTY17 ELSE P_WQTY17 END
                   , WQTY18 = CASE WHEN P_WQTY18 = -9 THEN WQTY18 ELSE P_WQTY18 END
                   , WQTY19 = CASE WHEN P_WQTY19 = -9 THEN WQTY19 ELSE P_WQTY19 END
                   , WQTY20 = CASE WHEN P_WQTY20 = -9 THEN WQTY20 ELSE P_WQTY20 END
                   , WQTY21 = CASE WHEN P_WQTY21 = -9 THEN WQTY21 ELSE P_WQTY21 END
                   , WQTY22 = CASE WHEN P_WQTY22 = -9 THEN WQTY22 ELSE P_WQTY22 END
                   , WQTY23 = CASE WHEN P_WQTY23 = -9 THEN WQTY23 ELSE P_WQTY23 END
                   , WQTY24 = CASE WHEN P_WQTY24 = -9 THEN WQTY24 ELSE P_WQTY24 END
                   , WQTY25 = CASE WHEN P_WQTY25 = -9 THEN WQTY25 ELSE P_WQTY25 END
                   , WQTY26 = CASE WHEN P_WQTY26 = -9 THEN WQTY26 ELSE P_WQTY26 END
                   , WQTY27 = CASE WHEN P_WQTY27 = -9 THEN WQTY27 ELSE P_WQTY27 END
                   , WQTY28 = CASE WHEN P_WQTY28 = -9 THEN WQTY28 ELSE P_WQTY28 END
                   , WQTY29 = CASE WHEN P_WQTY29 = -9 THEN WQTY29 ELSE P_WQTY29 END
                   , WQTY30 = CASE WHEN P_WQTY30 = -9 THEN WQTY30 ELSE P_WQTY30 END
                   , WQTY31 = CASE WHEN P_WQTY31 = -9 THEN WQTY31 ELSE P_WQTY31 END
                   , WQTY32 = CASE WHEN P_WQTY32 = -9 THEN WQTY32 ELSE P_WQTY32 END
                   , WQTY33 = CASE WHEN P_WQTY33 = -9 THEN WQTY33 ELSE P_WQTY33 END
                   , WQTY34 = CASE WHEN P_WQTY34 = -9 THEN WQTY34 ELSE P_WQTY34 END
                   , WQTY35 = CASE WHEN P_WQTY35 = -9 THEN WQTY35 ELSE P_WQTY35 END
                   , WQTY36 = CASE WHEN P_WQTY36 = -9 THEN WQTY36 ELSE P_WQTY36 END
                   , WQTY37 = CASE WHEN P_WQTY37 = -9 THEN WQTY37 ELSE P_WQTY37 END
                   , WQTY38 = CASE WHEN P_WQTY38 = -9 THEN WQTY38 ELSE P_WQTY38 END
                   , WQTY39 = CASE WHEN P_WQTY39 = -9 THEN WQTY39 ELSE P_WQTY39 END
                   , WQTY40 = CASE WHEN P_WQTY40 = -9 THEN WQTY40 ELSE P_WQTY40 END
                   , WQTY41 = CASE WHEN P_WQTY41 = -9 THEN WQTY41 ELSE P_WQTY41 END
                   , WQTY42 = CASE WHEN P_WQTY42 = -9 THEN WQTY42 ELSE P_WQTY42 END
                   , WQTY43 = CASE WHEN P_WQTY43 = -9 THEN WQTY43 ELSE P_WQTY43 END
                   , WQTY44 = CASE WHEN P_WQTY44 = -9 THEN WQTY44 ELSE P_WQTY44 END
                   , WQTY45 = CASE WHEN P_WQTY45 = -9 THEN WQTY45 ELSE P_WQTY45 END
                   , WQTY46 = CASE WHEN P_WQTY46 = -9 THEN WQTY46 ELSE P_WQTY46 END
                   , WQTY47 = CASE WHEN P_WQTY47 = -9 THEN WQTY47 ELSE P_WQTY47 END
                   , WQTY48 = CASE WHEN P_WQTY48 = -9 THEN WQTY48 ELSE P_WQTY48 END
                   , WQTY49 = CASE WHEN P_WQTY49 = -9 THEN WQTY49 ELSE P_WQTY49 END
                   , WQTY50 = CASE WHEN P_WQTY50 = -9 THEN WQTY50 ELSE P_WQTY50 END
                   , WQTY51 = CASE WHEN P_WQTY51 = -9 THEN WQTY51 ELSE P_WQTY51 END
                   , WQTY52 = CASE WHEN P_WQTY52 = -9 THEN WQTY52 ELSE P_WQTY52 END
                   , LAST_UPDATED_BY  = V_BATCH_USER
                   , LAST_UPDATE_DATE = SYSDATE
             WHERE DIVISION_ID          = V_BATCH_DIVISION_ID
               AND XLS_KEY1             = V_BATCH_XLS_KEY1
               AND CREATE_FROM_YYYYMMDD = P_CREATE_FROM_YYYYMMDD;

            /*                두 성질을 함께 재현하려면 RTRIM(x) IS NOT NULL 이 정확하다(린터 L224 미검사 결함류 방어). */
            IF RTRIM(P_DAILYQTY) IS NOT NULL THEN
                /*  MSSQL FORMATMESSAGE(' WHERE DIVISION_ID = ''%s''', x) -> ' WHERE DIVISION_ID = ''' || x || ''''
                    MSSQL FORMATMESSAGE(' AND XLS_KEY1 = %d ', x)         -> ' AND XLS_KEY1 = ' || TO_CHAR(x) || ' '
                    (2024.09.03 KSK 구문오류방지 위해 %d 사용). CHAR(10) -> CHR(10). @sql 은 CLOB(CV-046). */
                V_SQL := 'update SCP_XLS_PSI_GLOBAL ' || CHR(10);
                V_SQL := V_SQL || ' SET ' || P_DAILYQTY || CHR(10);
                V_SQL := V_SQL || ' WHERE DIVISION_ID = ''' || V_BATCH_DIVISION_ID || '''' || CHR(10);
                V_SQL := V_SQL || ' AND XLS_KEY1 = ' || TO_CHAR(V_BATCH_XLS_KEY1) || ' ' || CHR(10);   /* 구문 오류 회피(KSK) */
                V_SQL := V_SQL || ' AND CREATE_FROM_YYYYMMDD = ''' || P_CREATE_FROM_YYYYMMDD || '''' || CHR(10);

                IF P_IS_DEBUG = 1 THEN
                    /*  원본 SELECT @SQL AS "SQL" (디버그 결과셋) -> DBMS_OUTPUT (H-9) */
                    DBMS_OUTPUT.PUT_LINE( DBMS_LOB.SUBSTR(V_SQL, 32767, 1) );
                END IF;

                /*  MSSQL exec (@sql) -> EXECUTE IMMEDIATE (CV-040) */
                EXECUTE IMMEDIATE V_SQL;
            END IF;

        END IF;

        /*  SELECT 'GLOBAL PSI SAVED' TN, * FROM SCP_XLS_PSI_GLOBAL WITH (NOLOCK)
              WHERE DIVISION_ID = @v_batch_division_id AND XLS_KEY1 = @v_batch_xls_key1
                AND CREATE_FROM_YYYYMMDD = @p_create_from_yyyymmdd --TEST */

        /* PRINT '@v_batch_measure2  ' + @v_batch_measure */

        /*  2022.09.19 생산계획(PACK_PROD, CELL_PROD) 일배분로직 변경 - 1/7 에서 워킹타임(CAPA 로스타임을 고려한) 비율로 변경 */
        IF V_BATCH_MEASURE IN ('PACK_PROD', 'CELL_PROD') THEN
            /* -------------------------------- */
            /*  Working Time 에 따른 daily 분배 */
            /* -------------------------------- */

            /*  라인정보 조회 (MSSQL 대입형 SELECT -> 커서 FOR 루프) */
            FOR R IN ( SELECT PROD_LINE
                            , FROM_SITE
                            , ATTRIBUTE9
                         FROM SCP_XLS_PSI_GLOBAL
                        WHERE 0 = 0
                          AND DIVISION_ID          = V_BATCH_DIVISION_ID
                          AND PLAN_START_YYYYMMDD  = V_BATCH_PLAN_START_YYYYMMDD
                          AND CREATE_FROM_YYYYMMDD = V_BATCH_CREATE_FROM_YYYYMMDD
                          AND SEQ                  = V_BATCH_SEQ
                          AND XLS_KEY1             = V_BATCH_XLS_KEY1
                     )
            LOOP

                V_PROD_LINE_ID := SUBSTR(R.PROD_LINE, 1, 12);
                V_SCM_SITE     := SUBSTR(R.FROM_SITE, 1, 12);
                V_OPERATION    := SUBSTR(R.ATTRIBUTE9, 1, 12);
            END LOOP;

            /*  select @v_prod_line_id, @v_scm_site; */
            /*  PRINT 'start. '+CONVERT(CHAR(23), GETDATE(), 21); */

            /*  Working Time 정보 가져오기 :: 364일 */
            /*  IF OBJECT_ID('tempdb..#WORKING_TBL_TEMP') IS NOT NULL DROP TABLE #WORKING_TBL_TEMP
                IF OBJECT_ID('tempdb..#WORKING_TBL') IS NOT NULL DROP TABLE #WORKING_TBL;
                CREATE TABLE #WORKING_TBL_TEMP (
                    ROWNUM INT, XLS_KEY INT, YYYYMMDD NVARCHAR(010), WORKING_TIME NUMERIC(20,10), QTY NUMERIC(20,10)
                ); */
            DELETE FROM GT_XPGT_WORKING_TBL_TEMP;
            DELETE FROM GT_XPGT_WORKING_TBL;

            /* ---------------------------------- */
            /*  생산계획 저장로직 */
            /* ---------------------------------- */
            /*  CAPA 워킹타임 AVAILABLE 값을 가져오기 위한 처리
                원본 L504 : DECLARE @WORK_AVALIABLE TABLE (YYYYMMDD NVARCHAR(8), G_VALUE INT, A_VALUE INT, B_VALUE INT, C_VALUE INT);
                원본 L506 : INSERT @WORK_AVALIABLE EXEC PR_SCP_XLS_LINE_WORKINGTIME_BY_LOSS_AVAILABLE @a,@b,@c,@d
                  소비자인 여기서 DELETE 하면 write/read 가 어긋나 조용한 0행이 된다(LS-042). */
            PR_SCP_XLS_LINE_WORKINGTIME_BY_LOSS_AVAILABLE( V_BATCH_CREATE_FROM_YYYYMMDD
                                                         , V_BATCH_DIVISION_ID
                                                         , V_PROD_LINE_ID
                                                         , V_OPERATION );

            /*  MSSQL CONVERT(VARCHAR(8), DATEADD(day, 363, @v_batch_create_from_yyyymmdd), 112)
                -> TO_CHAR(TO_DATE(x, 'YYYYMMDD') + 363, 'YYYYMMDD') */
            INSERT INTO GT_XPGT_WORKING_TBL_TEMP
                 ( "ROWNUM"
                 , XLS_KEY
                 , YYYYMMDD
                 , WORKING_TIME
                 , QTY )
            SELECT ROW_NUMBER() OVER(ORDER BY X.YYYYMMDD) AS RN
                 , V_BATCH_XLS_KEY1 AS XLS_KEY
                 , X.YYYYMMDD
                 , X.WORKING_TIME
                 , 0.0            AS QTY
              FROM ( SELECT A.DIVISION_ID
                          , A.OPERATION_ID
                          , A.LINE_ID
                          , C.YYYYMMDD
                          , A.WORKING_TIME
                       FROM ( SELECT BASIS_YYYYMMDD AS YYYYMMDD
                                   , 0 AS WORKING_TIME
                                FROM SCM_SYS_CALENDAR_M
                               WHERE BASIS_YYYYMMDD BETWEEN V_BATCH_CREATE_FROM_YYYYMMDD
                                                        AND TO_CHAR(TO_DATE(V_BATCH_CREATE_FROM_YYYYMMDD, 'YYYYMMDD') + 363, 'YYYYMMDD')
                            ) C
                          , ( SELECT V_BATCH_DIVISION_ID AS DIVISION_ID
                                   , V_OPERATION         AS OPERATION_ID
                                   , V_PROD_LINE_ID      AS LINE_ID
                                   , YYYYMMDD
                                   , G_VALUE             AS WORKING_TIME

                                FROM GT_XPGT_WORK_AVAILABLE
                            ) A
                      WHERE 1 = 1
                        AND C.YYYYMMDD = A.YYYYMMDD(+)
                   ) X
             ORDER BY X.YYYYMMDD;

            /*  DECLARE @v_lp/@v_daylp/@v_weeklp/@v_addday/@v_first_day -> 선언부로 이동(사용처 0건) */

            /*  입력된 Week 수량을 Daily로 분배하기 위한 처리 */
            /*  IF OBJECT_ID('tempdb..#WEEK_QTY_TBL') IS NOT NULL DROP TABLE #WEEK_QTY_TBL
                CREATE TABLE #WEEK_QTY_TBL ( WQTY01 INT, ... , WQTY52 INT ); */
            DELETE FROM GT_XPGT_WEEK_QTY_TBL;

            INSERT INTO GT_XPGT_WEEK_QTY_TBL
                 ( WQTY01, WQTY02, WQTY03, WQTY04, WQTY05
                 , WQTY06, WQTY07, WQTY08, WQTY09, WQTY10
                 , WQTY11, WQTY12, WQTY13, WQTY14, WQTY15
                 , WQTY16, WQTY17, WQTY18, WQTY19, WQTY20
                 , WQTY21, WQTY22, WQTY23, WQTY24, WQTY25
                 , WQTY26, WQTY27, WQTY28, WQTY29, WQTY30
                 , WQTY31, WQTY32, WQTY33, WQTY34, WQTY35
                 , WQTY36, WQTY37, WQTY38, WQTY39, WQTY40
                 , WQTY41, WQTY42, WQTY43, WQTY44, WQTY45
                 , WQTY46, WQTY47, WQTY48, WQTY49, WQTY50
                 , WQTY51, WQTY52
                 )
            SELECT P_WQTY01, P_WQTY02, P_WQTY03, P_WQTY04, P_WQTY05
            , P_WQTY06, P_WQTY07, P_WQTY08, P_WQTY09, P_WQTY10
            , P_WQTY11, P_WQTY12, P_WQTY13, P_WQTY14, P_WQTY15
            , P_WQTY16, P_WQTY17, P_WQTY18, P_WQTY19, P_WQTY20
            , P_WQTY21, P_WQTY22, P_WQTY23, P_WQTY24, P_WQTY25
            , P_WQTY26, P_WQTY27, P_WQTY28, P_WQTY29, P_WQTY30
            , P_WQTY31, P_WQTY32, P_WQTY33, P_WQTY34, P_WQTY35
            , P_WQTY36, P_WQTY37, P_WQTY38, P_WQTY39, P_WQTY40
            , P_WQTY41, P_WQTY42, P_WQTY43, P_WQTY44, P_WQTY45
            , P_WQTY46, P_WQTY47, P_WQTY48, P_WQTY49, P_WQTY50
            , P_WQTY51, P_WQTY52
              FROM DUAL;   /*  FROM 없는 SELECT 는 Oracle 에서 FROM DUAL 필수(LS-014) */

            /* ------------------------------------------------------------------- */
            /*  원본 L586~L623 : CTE 3단(SE1/SE2/SE3) 후 SELECT ... INTO #WORKING_TBL
                -> Oracle WITH + INSERT INTO GTT (컬럼목록 명시 : GTT 는 06_S 용 10컬럼 상위집합이라
                   SELECT * / 무목록 INSERT 를 쓰면 컬럼수가 어긋난다). */
            INSERT INTO GT_XPGT_WORKING_TBL
                 ( "ROWNUM"
                 , XLS_KEY
                 , YYYYMMDD
                 , WORKING_TIME
                 , QTY )
            WITH SE1 AS (
                SELECT A."ROWNUM", A.XLS_KEY, A.YYYYMMDD, A.WORKING_TIME, A.WEEKNO, B.ITEM, B.CNT, R.WORKING_DAY
                     , ROUND(CASE WHEN R.WORKING_DAY <= B.CNT THEN A.WORKING_TIME / R.WEEK_WORKING_TIME * B.CNT
                                  ELSE 0 END, 0) AS STEP1_QTY
                  FROM
                     (
                      /*                          MSSQL 'WQTY' + RIGHT('0' + CONVERT(VARCHAR, n), 2) -> 'WQTY' || LPAD(TO_CHAR(n), 2, '0') */
                      SELECT T."ROWNUM", T.XLS_KEY, T.YYYYMMDD, T.WORKING_TIME, T.QTY
                           , TRUNC((T."ROWNUM" - 1) / 7) + 1 AS WEEKNO
                           , 'WQTY' || LPAD(TO_CHAR(TRUNC((T."ROWNUM" - 1) / 7) + 1), 2, '0') AS ITEM
                        FROM GT_XPGT_WORKING_TBL_TEMP T
                     ) A
                     LEFT JOIN
                     (
                      SELECT TRUNC(("ROWNUM" - 1) / 7) + 1 AS WEEKNO
                           , COUNT(WORKING_TIME) AS WORKING_DAY
                           , CASE WHEN SUM(WORKING_TIME) = 0 THEN 1 ELSE SUM(WORKING_TIME) END AS WEEK_WORKING_TIME
                        FROM GT_XPGT_WORKING_TBL_TEMP
                       WHERE WORKING_TIME > 0
                       GROUP BY TRUNC(("ROWNUM" - 1) / 7) + 1
                     ) R
                       ON A.WEEKNO = R.WEEKNO
                     LEFT JOIN
                     (
                      SELECT ITEM, CNT
                        FROM GT_XPGT_WEEK_QTY_TBL
                       UNPIVOT ( CNT FOR ITEM IN (
                                      WQTY01, WQTY02, WQTY03, WQTY04, WQTY05
                                    , WQTY06, WQTY07, WQTY08, WQTY09, WQTY10
                                    , WQTY11, WQTY12, WQTY13, WQTY14, WQTY15
                                    , WQTY16, WQTY17, WQTY18, WQTY19, WQTY20
                                    , WQTY21, WQTY22, WQTY23, WQTY24, WQTY25
                                    , WQTY26, WQTY27, WQTY28, WQTY29, WQTY30
                                    , WQTY31, WQTY32, WQTY33, WQTY34, WQTY35
                                    , WQTY36, WQTY37, WQTY38, WQTY39, WQTY40
                                    , WQTY41, WQTY42, WQTY43, WQTY44, WQTY45
                                    , WQTY46, WQTY47, WQTY48, WQTY49, WQTY50
                                    , WQTY51, WQTY52
                               ) ) UN
                     ) B
                       ON A.ITEM = B.ITEM
            )
            , SE2 AS (
                SELECT A."ROWNUM", A.XLS_KEY, A.YYYYMMDD, A.WORKING_TIME, A.WEEKNO, A.ITEM, A.CNT, A.WORKING_DAY
                     , C.WEEKSUM, A.STEP1_QTY
                     , CASE WHEN A."ROWNUM" = C.ADDDAY
                            THEN (CASE WHEN A.STEP1_QTY + (A.CNT - C.WEEKSUM) < 0 THEN 0
                                       ELSE A.STEP1_QTY + (A.CNT - C.WEEKSUM) END)
                            ELSE A.STEP1_QTY END AS STEP2_QTY
                     , C.MINDAY
                  FROM SE1 A
                       LEFT JOIN ( SELECT WEEKNO
                                        , MAX("ROWNUM") AS ADDDAY
                                        , MIN("ROWNUM") AS MINDAY
                                        , SUM(STEP1_QTY) AS WEEKSUM
                                     FROM SE1
                                    GROUP BY WEEKNO ) C
                         ON A.WEEKNO = C.WEEKNO
            )
            , SE3 AS (
                SELECT R."ROWNUM", R.XLS_KEY, R.YYYYMMDD, R.WORKING_TIME, R.WEEKNO, R.ITEM, R.CNT, R.WORKING_DAY
                     , R.WEEKSUM, R.STEP1_QTY, R.STEP2_QTY, R.MINDAY
                     , ( SELECT SUM(NVL(T.STEP2_QTY, 0)) FROM SE2 T
                          WHERE T."ROWNUM" <= R."ROWNUM" AND T.WEEKNO = R.WEEKNO ) AS SUM_ROW
                     , ( SELECT SUM(NVL(T.STEP2_QTY, 0)) FROM SE2 T
                          WHERE T."ROWNUM" <= R."ROWNUM" - 1 AND T.WEEKNO = R.WEEKNO ) AS SUM_ROW2
                  FROM SE2 R
            )
            SELECT SE3."ROWNUM", SE3.XLS_KEY, SE3.YYYYMMDD, SE3.WORKING_TIME

                 , NVL(CASE WHEN NVL(SE3.CNT, 0) < NVL(SE3.SUM_ROW, 0)
                            THEN (CASE WHEN (NVL(SE3.CNT, 0) - SE3.SUM_ROW2) = NULL
                                          OR (NVL(SE3.CNT, 0) - SE3.SUM_ROW2) < 0 THEN 0
                                       ELSE NVL(SE3.CNT, 0) - SE3.SUM_ROW2 END)
                            ELSE SE3.STEP2_QTY END, 0) AS QTY
              FROM SE3;

            /* ---------------------------------------- */
            /*  Pack 생산계획 저장로직개선(튜닝)건 반영 -- end */
            /* ---------------------------------------- */

            /*  분배된 수량 업데이트
                ★원천 W 는 GROUP BY S.XLS_KEY 라 조인키당 1행이므로 ORA-30926 도 없다. */
            MERGE INTO SCP_XLS_PSI_GLOBAL E
            USING (
                    SELECT S.XLS_KEY
                         , SUM("1") AS QTY001, SUM("2") AS QTY002, SUM("3") AS QTY003, SUM("4") AS QTY004, SUM("5") AS QTY005
                         , SUM("6") AS QTY006, SUM("7") AS QTY007, SUM("8") AS QTY008, SUM("9") AS QTY009, SUM("10") AS QTY010
                         , SUM("11") AS QTY011, SUM("12") AS QTY012, SUM("13") AS QTY013, SUM("14") AS QTY014, SUM("15") AS QTY015
                         , SUM("16") AS QTY016, SUM("17") AS QTY017, SUM("18") AS QTY018, SUM("19") AS QTY019, SUM("20") AS QTY020
                         , SUM("21") AS QTY021, SUM("22") AS QTY022, SUM("23") AS QTY023, SUM("24") AS QTY024, SUM("25") AS QTY025
                         , SUM("26") AS QTY026, SUM("27") AS QTY027, SUM("28") AS QTY028, SUM("29") AS QTY029, SUM("30") AS QTY030
                         , SUM("31") AS QTY031, SUM("32") AS QTY032, SUM("33") AS QTY033, SUM("34") AS QTY034, SUM("35") AS QTY035
                         , SUM("36") AS QTY036, SUM("37") AS QTY037, SUM("38") AS QTY038, SUM("39") AS QTY039, SUM("40") AS QTY040
                         , SUM("41") AS QTY041, SUM("42") AS QTY042, SUM("43") AS QTY043, SUM("44") AS QTY044, SUM("45") AS QTY045
                         , SUM("46") AS QTY046, SUM("47") AS QTY047, SUM("48") AS QTY048, SUM("49") AS QTY049, SUM("50") AS QTY050
                         , SUM("51") AS QTY051, SUM("52") AS QTY052, SUM("53") AS QTY053, SUM("54") AS QTY054, SUM("55") AS QTY055
                         , SUM("56") AS QTY056, SUM("57") AS QTY057, SUM("58") AS QTY058, SUM("59") AS QTY059, SUM("60") AS QTY060
                         , SUM("61") AS QTY061, SUM("62") AS QTY062, SUM("63") AS QTY063, SUM("64") AS QTY064, SUM("65") AS QTY065
                         , SUM("66") AS QTY066, SUM("67") AS QTY067, SUM("68") AS QTY068, SUM("69") AS QTY069, SUM("70") AS QTY070
                         , SUM("71") AS QTY071, SUM("72") AS QTY072, SUM("73") AS QTY073, SUM("74") AS QTY074, SUM("75") AS QTY075
                         , SUM("76") AS QTY076, SUM("77") AS QTY077, SUM("78") AS QTY078, SUM("79") AS QTY079, SUM("80") AS QTY080
                         , SUM("81") AS QTY081, SUM("82") AS QTY082, SUM("83") AS QTY083, SUM("84") AS QTY084, SUM("85") AS QTY085
                         , SUM("86") AS QTY086, SUM("87") AS QTY087, SUM("88") AS QTY088, SUM("89") AS QTY089, SUM("90") AS QTY090
                         , SUM("91") AS QTY091, SUM("92") AS QTY092, SUM("93") AS QTY093, SUM("94") AS QTY094, SUM("95") AS QTY095
                         , SUM("96") AS QTY096, SUM("97") AS QTY097, SUM("98") AS QTY098, SUM("99") AS QTY099, SUM("100") AS QTY100
                         , SUM("101") AS QTY101, SUM("102") AS QTY102, SUM("103") AS QTY103, SUM("104") AS QTY104, SUM("105") AS QTY105
                         , SUM("106") AS QTY106, SUM("107") AS QTY107, SUM("108") AS QTY108, SUM("109") AS QTY109, SUM("110") AS QTY110
                         , SUM("111") AS QTY111, SUM("112") AS QTY112, SUM("113") AS QTY113, SUM("114") AS QTY114, SUM("115") AS QTY115
                         , SUM("116") AS QTY116, SUM("117") AS QTY117, SUM("118") AS QTY118, SUM("119") AS QTY119, SUM("120") AS QTY120
                         , SUM("121") AS QTY121, SUM("122") AS QTY122, SUM("123") AS QTY123, SUM("124") AS QTY124, SUM("125") AS QTY125
                         , SUM("126") AS QTY126, SUM("127") AS QTY127, SUM("128") AS QTY128, SUM("129") AS QTY129, SUM("130") AS QTY130
                         , SUM("131") AS QTY131, SUM("132") AS QTY132, SUM("133") AS QTY133, SUM("134") AS QTY134, SUM("135") AS QTY135
                         , SUM("136") AS QTY136, SUM("137") AS QTY137, SUM("138") AS QTY138, SUM("139") AS QTY139, SUM("140") AS QTY140
                         , SUM("141") AS QTY141, SUM("142") AS QTY142, SUM("143") AS QTY143, SUM("144") AS QTY144, SUM("145") AS QTY145
                         , SUM("146") AS QTY146, SUM("147") AS QTY147, SUM("148") AS QTY148, SUM("149") AS QTY149, SUM("150") AS QTY150
                         , SUM("151") AS QTY151, SUM("152") AS QTY152, SUM("153") AS QTY153, SUM("154") AS QTY154, SUM("155") AS QTY155
                         , SUM("156") AS QTY156, SUM("157") AS QTY157, SUM("158") AS QTY158, SUM("159") AS QTY159, SUM("160") AS QTY160
                         , SUM("161") AS QTY161, SUM("162") AS QTY162, SUM("163") AS QTY163, SUM("164") AS QTY164, SUM("165") AS QTY165
                         , SUM("166") AS QTY166, SUM("167") AS QTY167, SUM("168") AS QTY168, SUM("169") AS QTY169, SUM("170") AS QTY170
                         , SUM("171") AS QTY171, SUM("172") AS QTY172, SUM("173") AS QTY173, SUM("174") AS QTY174, SUM("175") AS QTY175
                         , SUM("176") AS QTY176, SUM("177") AS QTY177, SUM("178") AS QTY178, SUM("179") AS QTY179, SUM("180") AS QTY180
                         , SUM("181") AS QTY181, SUM("182") AS QTY182, SUM("183") AS QTY183, SUM("184") AS QTY184, SUM("185") AS QTY185
                         , SUM("186") AS QTY186, SUM("187") AS QTY187, SUM("188") AS QTY188, SUM("189") AS QTY189, SUM("190") AS QTY190
                         , SUM("191") AS QTY191, SUM("192") AS QTY192, SUM("193") AS QTY193, SUM("194") AS QTY194, SUM("195") AS QTY195
                         , SUM("196") AS QTY196, SUM("197") AS QTY197, SUM("198") AS QTY198, SUM("199") AS QTY199, SUM("200") AS QTY200
                         , SUM("201") AS QTY201, SUM("202") AS QTY202, SUM("203") AS QTY203, SUM("204") AS QTY204, SUM("205") AS QTY205
                         , SUM("206") AS QTY206, SUM("207") AS QTY207, SUM("208") AS QTY208, SUM("209") AS QTY209, SUM("210") AS QTY210
                         , SUM("211") AS QTY211, SUM("212") AS QTY212, SUM("213") AS QTY213, SUM("214") AS QTY214, SUM("215") AS QTY215
                         , SUM("216") AS QTY216, SUM("217") AS QTY217, SUM("218") AS QTY218, SUM("219") AS QTY219, SUM("220") AS QTY220
                         , SUM("221") AS QTY221, SUM("222") AS QTY222, SUM("223") AS QTY223, SUM("224") AS QTY224, SUM("225") AS QTY225
                         , SUM("226") AS QTY226, SUM("227") AS QTY227, SUM("228") AS QTY228, SUM("229") AS QTY229, SUM("230") AS QTY230
                         , SUM("231") AS QTY231, SUM("232") AS QTY232, SUM("233") AS QTY233, SUM("234") AS QTY234, SUM("235") AS QTY235
                         , SUM("236") AS QTY236, SUM("237") AS QTY237, SUM("238") AS QTY238, SUM("239") AS QTY239, SUM("240") AS QTY240
                         , SUM("241") AS QTY241, SUM("242") AS QTY242, SUM("243") AS QTY243, SUM("244") AS QTY244, SUM("245") AS QTY245
                         , SUM("246") AS QTY246, SUM("247") AS QTY247, SUM("248") AS QTY248, SUM("249") AS QTY249, SUM("250") AS QTY250
                         , SUM("251") AS QTY251, SUM("252") AS QTY252, SUM("253") AS QTY253, SUM("254") AS QTY254, SUM("255") AS QTY255
                         , SUM("256") AS QTY256, SUM("257") AS QTY257, SUM("258") AS QTY258, SUM("259") AS QTY259, SUM("260") AS QTY260
                         , SUM("261") AS QTY261, SUM("262") AS QTY262, SUM("263") AS QTY263, SUM("264") AS QTY264, SUM("265") AS QTY265
                         , SUM("266") AS QTY266, SUM("267") AS QTY267, SUM("268") AS QTY268, SUM("269") AS QTY269, SUM("270") AS QTY270
                         , SUM("271") AS QTY271, SUM("272") AS QTY272, SUM("273") AS QTY273, SUM("274") AS QTY274, SUM("275") AS QTY275
                         , SUM("276") AS QTY276, SUM("277") AS QTY277, SUM("278") AS QTY278, SUM("279") AS QTY279, SUM("280") AS QTY280
                         , SUM("281") AS QTY281, SUM("282") AS QTY282, SUM("283") AS QTY283, SUM("284") AS QTY284, SUM("285") AS QTY285
                         , SUM("286") AS QTY286, SUM("287") AS QTY287, SUM("288") AS QTY288, SUM("289") AS QTY289, SUM("290") AS QTY290
                         , SUM("291") AS QTY291, SUM("292") AS QTY292, SUM("293") AS QTY293, SUM("294") AS QTY294, SUM("295") AS QTY295
                         , SUM("296") AS QTY296, SUM("297") AS QTY297, SUM("298") AS QTY298, SUM("299") AS QTY299, SUM("300") AS QTY300
                         , SUM("301") AS QTY301, SUM("302") AS QTY302, SUM("303") AS QTY303, SUM("304") AS QTY304, SUM("305") AS QTY305
                         , SUM("306") AS QTY306, SUM("307") AS QTY307, SUM("308") AS QTY308, SUM("309") AS QTY309, SUM("310") AS QTY310
                         , SUM("311") AS QTY311, SUM("312") AS QTY312, SUM("313") AS QTY313, SUM("314") AS QTY314, SUM("315") AS QTY315
                         , SUM("316") AS QTY316, SUM("317") AS QTY317, SUM("318") AS QTY318, SUM("319") AS QTY319, SUM("320") AS QTY320
                         , SUM("321") AS QTY321, SUM("322") AS QTY322, SUM("323") AS QTY323, SUM("324") AS QTY324, SUM("325") AS QTY325
                         , SUM("326") AS QTY326, SUM("327") AS QTY327, SUM("328") AS QTY328, SUM("329") AS QTY329, SUM("330") AS QTY330
                         , SUM("331") AS QTY331, SUM("332") AS QTY332, SUM("333") AS QTY333, SUM("334") AS QTY334, SUM("335") AS QTY335
                         , SUM("336") AS QTY336, SUM("337") AS QTY337, SUM("338") AS QTY338, SUM("339") AS QTY339, SUM("340") AS QTY340
                         , SUM("341") AS QTY341, SUM("342") AS QTY342, SUM("343") AS QTY343, SUM("344") AS QTY344, SUM("345") AS QTY345
                         , SUM("346") AS QTY346, SUM("347") AS QTY347, SUM("348") AS QTY348, SUM("349") AS QTY349, SUM("350") AS QTY350
                         , SUM("351") AS QTY351, SUM("352") AS QTY352, SUM("353") AS QTY353, SUM("354") AS QTY354, SUM("355") AS QTY355
                         , SUM("356") AS QTY356, SUM("357") AS QTY357, SUM("358") AS QTY358, SUM("359") AS QTY359, SUM("360") AS QTY360
                         , SUM("361") AS QTY361, SUM("362") AS QTY362, SUM("363") AS QTY363, SUM("364") AS QTY364
                      FROM ( SELECT P.XLS_KEY
                                  , NVL("1", 0) AS "1", NVL("2", 0) AS "2", NVL("3", 0) AS "3", NVL("4", 0) AS "4", NVL("5", 0) AS "5"
                                  , NVL("6", 0) AS "6", NVL("7", 0) AS "7", NVL("8", 0) AS "8", NVL("9", 0) AS "9", NVL("10", 0) AS "10"
                                  , NVL("11", 0) AS "11", NVL("12", 0) AS "12", NVL("13", 0) AS "13", NVL("14", 0) AS "14", NVL("15", 0) AS "15"
                                  , NVL("16", 0) AS "16", NVL("17", 0) AS "17", NVL("18", 0) AS "18", NVL("19", 0) AS "19", NVL("20", 0) AS "20"
                                  , NVL("21", 0) AS "21", NVL("22", 0) AS "22", NVL("23", 0) AS "23", NVL("24", 0) AS "24", NVL("25", 0) AS "25"
                                  , NVL("26", 0) AS "26", NVL("27", 0) AS "27", NVL("28", 0) AS "28", NVL("29", 0) AS "29", NVL("30", 0) AS "30"
                                  , NVL("31", 0) AS "31", NVL("32", 0) AS "32", NVL("33", 0) AS "33", NVL("34", 0) AS "34", NVL("35", 0) AS "35"
                                  , NVL("36", 0) AS "36", NVL("37", 0) AS "37", NVL("38", 0) AS "38", NVL("39", 0) AS "39", NVL("40", 0) AS "40"
                                  , NVL("41", 0) AS "41", NVL("42", 0) AS "42", NVL("43", 0) AS "43", NVL("44", 0) AS "44", NVL("45", 0) AS "45"
                                  , NVL("46", 0) AS "46", NVL("47", 0) AS "47", NVL("48", 0) AS "48", NVL("49", 0) AS "49", NVL("50", 0) AS "50"
                                  , NVL("51", 0) AS "51", NVL("52", 0) AS "52", NVL("53", 0) AS "53", NVL("54", 0) AS "54", NVL("55", 0) AS "55"
                                  , NVL("56", 0) AS "56", NVL("57", 0) AS "57", NVL("58", 0) AS "58", NVL("59", 0) AS "59", NVL("60", 0) AS "60"
                                  , NVL("61", 0) AS "61", NVL("62", 0) AS "62", NVL("63", 0) AS "63", NVL("64", 0) AS "64", NVL("65", 0) AS "65"
                                  , NVL("66", 0) AS "66", NVL("67", 0) AS "67", NVL("68", 0) AS "68", NVL("69", 0) AS "69", NVL("70", 0) AS "70"
                                  , NVL("71", 0) AS "71", NVL("72", 0) AS "72", NVL("73", 0) AS "73", NVL("74", 0) AS "74", NVL("75", 0) AS "75"
                                  , NVL("76", 0) AS "76", NVL("77", 0) AS "77", NVL("78", 0) AS "78", NVL("79", 0) AS "79", NVL("80", 0) AS "80"
                                  , NVL("81", 0) AS "81", NVL("82", 0) AS "82", NVL("83", 0) AS "83", NVL("84", 0) AS "84", NVL("85", 0) AS "85"
                                  , NVL("86", 0) AS "86", NVL("87", 0) AS "87", NVL("88", 0) AS "88", NVL("89", 0) AS "89", NVL("90", 0) AS "90"
                                  , NVL("91", 0) AS "91", NVL("92", 0) AS "92", NVL("93", 0) AS "93", NVL("94", 0) AS "94", NVL("95", 0) AS "95"
                                  , NVL("96", 0) AS "96", NVL("97", 0) AS "97", NVL("98", 0) AS "98", NVL("99", 0) AS "99", NVL("100", 0) AS "100"
                                  , NVL("101", 0) AS "101", NVL("102", 0) AS "102", NVL("103", 0) AS "103", NVL("104", 0) AS "104", NVL("105", 0) AS "105"
                                  , NVL("106", 0) AS "106", NVL("107", 0) AS "107", NVL("108", 0) AS "108", NVL("109", 0) AS "109", NVL("110", 0) AS "110"
                                  , NVL("111", 0) AS "111", NVL("112", 0) AS "112", NVL("113", 0) AS "113", NVL("114", 0) AS "114", NVL("115", 0) AS "115"
                                  , NVL("116", 0) AS "116", NVL("117", 0) AS "117", NVL("118", 0) AS "118", NVL("119", 0) AS "119", NVL("120", 0) AS "120"
                                  , NVL("121", 0) AS "121", NVL("122", 0) AS "122", NVL("123", 0) AS "123", NVL("124", 0) AS "124", NVL("125", 0) AS "125"
                                  , NVL("126", 0) AS "126", NVL("127", 0) AS "127", NVL("128", 0) AS "128", NVL("129", 0) AS "129", NVL("130", 0) AS "130"
                                  , NVL("131", 0) AS "131", NVL("132", 0) AS "132", NVL("133", 0) AS "133", NVL("134", 0) AS "134", NVL("135", 0) AS "135"
                                  , NVL("136", 0) AS "136", NVL("137", 0) AS "137", NVL("138", 0) AS "138", NVL("139", 0) AS "139", NVL("140", 0) AS "140"
                                  , NVL("141", 0) AS "141", NVL("142", 0) AS "142", NVL("143", 0) AS "143", NVL("144", 0) AS "144", NVL("145", 0) AS "145"
                                  , NVL("146", 0) AS "146", NVL("147", 0) AS "147", NVL("148", 0) AS "148", NVL("149", 0) AS "149", NVL("150", 0) AS "150"
                                  , NVL("151", 0) AS "151", NVL("152", 0) AS "152", NVL("153", 0) AS "153", NVL("154", 0) AS "154", NVL("155", 0) AS "155"
                                  , NVL("156", 0) AS "156", NVL("157", 0) AS "157", NVL("158", 0) AS "158", NVL("159", 0) AS "159", NVL("160", 0) AS "160"
                                  , NVL("161", 0) AS "161", NVL("162", 0) AS "162", NVL("163", 0) AS "163", NVL("164", 0) AS "164", NVL("165", 0) AS "165"
                                  , NVL("166", 0) AS "166", NVL("167", 0) AS "167", NVL("168", 0) AS "168", NVL("169", 0) AS "169", NVL("170", 0) AS "170"
                                  , NVL("171", 0) AS "171", NVL("172", 0) AS "172", NVL("173", 0) AS "173", NVL("174", 0) AS "174", NVL("175", 0) AS "175"
                                  , NVL("176", 0) AS "176", NVL("177", 0) AS "177", NVL("178", 0) AS "178", NVL("179", 0) AS "179", NVL("180", 0) AS "180"
                                  , NVL("181", 0) AS "181", NVL("182", 0) AS "182", NVL("183", 0) AS "183", NVL("184", 0) AS "184", NVL("185", 0) AS "185"
                                  , NVL("186", 0) AS "186", NVL("187", 0) AS "187", NVL("188", 0) AS "188", NVL("189", 0) AS "189", NVL("190", 0) AS "190"
                                  , NVL("191", 0) AS "191", NVL("192", 0) AS "192", NVL("193", 0) AS "193", NVL("194", 0) AS "194", NVL("195", 0) AS "195"
                                  , NVL("196", 0) AS "196", NVL("197", 0) AS "197", NVL("198", 0) AS "198", NVL("199", 0) AS "199", NVL("200", 0) AS "200"
                                  , NVL("201", 0) AS "201", NVL("202", 0) AS "202", NVL("203", 0) AS "203", NVL("204", 0) AS "204", NVL("205", 0) AS "205"
                                  , NVL("206", 0) AS "206", NVL("207", 0) AS "207", NVL("208", 0) AS "208", NVL("209", 0) AS "209", NVL("210", 0) AS "210"
                                  , NVL("211", 0) AS "211", NVL("212", 0) AS "212", NVL("213", 0) AS "213", NVL("214", 0) AS "214", NVL("215", 0) AS "215"
                                  , NVL("216", 0) AS "216", NVL("217", 0) AS "217", NVL("218", 0) AS "218", NVL("219", 0) AS "219", NVL("220", 0) AS "220"
                                  , NVL("221", 0) AS "221", NVL("222", 0) AS "222", NVL("223", 0) AS "223", NVL("224", 0) AS "224", NVL("225", 0) AS "225"
                                  , NVL("226", 0) AS "226", NVL("227", 0) AS "227", NVL("228", 0) AS "228", NVL("229", 0) AS "229", NVL("230", 0) AS "230"
                                  , NVL("231", 0) AS "231", NVL("232", 0) AS "232", NVL("233", 0) AS "233", NVL("234", 0) AS "234", NVL("235", 0) AS "235"
                                  , NVL("236", 0) AS "236", NVL("237", 0) AS "237", NVL("238", 0) AS "238", NVL("239", 0) AS "239", NVL("240", 0) AS "240"
                                  , NVL("241", 0) AS "241", NVL("242", 0) AS "242", NVL("243", 0) AS "243", NVL("244", 0) AS "244", NVL("245", 0) AS "245"
                                  , NVL("246", 0) AS "246", NVL("247", 0) AS "247", NVL("248", 0) AS "248", NVL("249", 0) AS "249", NVL("250", 0) AS "250"
                                  , NVL("251", 0) AS "251", NVL("252", 0) AS "252", NVL("253", 0) AS "253", NVL("254", 0) AS "254", NVL("255", 0) AS "255"
                                  , NVL("256", 0) AS "256", NVL("257", 0) AS "257", NVL("258", 0) AS "258", NVL("259", 0) AS "259", NVL("260", 0) AS "260"
                                  , NVL("261", 0) AS "261", NVL("262", 0) AS "262", NVL("263", 0) AS "263", NVL("264", 0) AS "264", NVL("265", 0) AS "265"
                                  , NVL("266", 0) AS "266", NVL("267", 0) AS "267", NVL("268", 0) AS "268", NVL("269", 0) AS "269", NVL("270", 0) AS "270"
                                  , NVL("271", 0) AS "271", NVL("272", 0) AS "272", NVL("273", 0) AS "273", NVL("274", 0) AS "274", NVL("275", 0) AS "275"
                                  , NVL("276", 0) AS "276", NVL("277", 0) AS "277", NVL("278", 0) AS "278", NVL("279", 0) AS "279", NVL("280", 0) AS "280"
                                  , NVL("281", 0) AS "281", NVL("282", 0) AS "282", NVL("283", 0) AS "283", NVL("284", 0) AS "284", NVL("285", 0) AS "285"
                                  , NVL("286", 0) AS "286", NVL("287", 0) AS "287", NVL("288", 0) AS "288", NVL("289", 0) AS "289", NVL("290", 0) AS "290"
                                  , NVL("291", 0) AS "291", NVL("292", 0) AS "292", NVL("293", 0) AS "293", NVL("294", 0) AS "294", NVL("295", 0) AS "295"
                                  , NVL("296", 0) AS "296", NVL("297", 0) AS "297", NVL("298", 0) AS "298", NVL("299", 0) AS "299", NVL("300", 0) AS "300"
                                  , NVL("301", 0) AS "301", NVL("302", 0) AS "302", NVL("303", 0) AS "303", NVL("304", 0) AS "304", NVL("305", 0) AS "305"
                                  , NVL("306", 0) AS "306", NVL("307", 0) AS "307", NVL("308", 0) AS "308", NVL("309", 0) AS "309", NVL("310", 0) AS "310"
                                  , NVL("311", 0) AS "311", NVL("312", 0) AS "312", NVL("313", 0) AS "313", NVL("314", 0) AS "314", NVL("315", 0) AS "315"
                                  , NVL("316", 0) AS "316", NVL("317", 0) AS "317", NVL("318", 0) AS "318", NVL("319", 0) AS "319", NVL("320", 0) AS "320"
                                  , NVL("321", 0) AS "321", NVL("322", 0) AS "322", NVL("323", 0) AS "323", NVL("324", 0) AS "324", NVL("325", 0) AS "325"
                                  , NVL("326", 0) AS "326", NVL("327", 0) AS "327", NVL("328", 0) AS "328", NVL("329", 0) AS "329", NVL("330", 0) AS "330"
                                  , NVL("331", 0) AS "331", NVL("332", 0) AS "332", NVL("333", 0) AS "333", NVL("334", 0) AS "334", NVL("335", 0) AS "335"
                                  , NVL("336", 0) AS "336", NVL("337", 0) AS "337", NVL("338", 0) AS "338", NVL("339", 0) AS "339", NVL("340", 0) AS "340"
                                  , NVL("341", 0) AS "341", NVL("342", 0) AS "342", NVL("343", 0) AS "343", NVL("344", 0) AS "344", NVL("345", 0) AS "345"
                                  , NVL("346", 0) AS "346", NVL("347", 0) AS "347", NVL("348", 0) AS "348", NVL("349", 0) AS "349", NVL("350", 0) AS "350"
                                  , NVL("351", 0) AS "351", NVL("352", 0) AS "352", NVL("353", 0) AS "353", NVL("354", 0) AS "354", NVL("355", 0) AS "355"
                                  , NVL("356", 0) AS "356", NVL("357", 0) AS "357", NVL("358", 0) AS "358", NVL("359", 0) AS "359", NVL("360", 0) AS "360"
                                  , NVL("361", 0) AS "361", NVL("362", 0) AS "362", NVL("363", 0) AS "363", NVL("364", 0) AS "364"

                               FROM ( SELECT "ROWNUM", XLS_KEY, YYYYMMDD, WORKING_TIME, QTY
                                        FROM GT_XPGT_WORKING_TBL )
                               PIVOT (
                                   SUM(QTY) FOR "ROWNUM" IN (
                                         1 AS "1", 2 AS "2", 3 AS "3", 4 AS "4", 5 AS "5", 6 AS "6", 7 AS "7", 8 AS "8", 9 AS "9", 10 AS "10"
                                       , 11 AS "11", 12 AS "12", 13 AS "13", 14 AS "14", 15 AS "15", 16 AS "16", 17 AS "17", 18 AS "18", 19 AS "19", 20 AS "20"
                                       , 21 AS "21", 22 AS "22", 23 AS "23", 24 AS "24", 25 AS "25", 26 AS "26", 27 AS "27", 28 AS "28", 29 AS "29", 30 AS "30"
                                       , 31 AS "31", 32 AS "32", 33 AS "33", 34 AS "34", 35 AS "35", 36 AS "36", 37 AS "37", 38 AS "38", 39 AS "39", 40 AS "40"
                                       , 41 AS "41", 42 AS "42", 43 AS "43", 44 AS "44", 45 AS "45", 46 AS "46", 47 AS "47", 48 AS "48", 49 AS "49", 50 AS "50"
                                       , 51 AS "51", 52 AS "52", 53 AS "53", 54 AS "54", 55 AS "55", 56 AS "56", 57 AS "57", 58 AS "58", 59 AS "59", 60 AS "60"
                                       , 61 AS "61", 62 AS "62", 63 AS "63", 64 AS "64", 65 AS "65", 66 AS "66", 67 AS "67", 68 AS "68", 69 AS "69", 70 AS "70"
                                       , 71 AS "71", 72 AS "72", 73 AS "73", 74 AS "74", 75 AS "75", 76 AS "76", 77 AS "77", 78 AS "78", 79 AS "79", 80 AS "80"
                                       , 81 AS "81", 82 AS "82", 83 AS "83", 84 AS "84", 85 AS "85", 86 AS "86", 87 AS "87", 88 AS "88", 89 AS "89", 90 AS "90"
                                       , 91 AS "91", 92 AS "92", 93 AS "93", 94 AS "94", 95 AS "95", 96 AS "96", 97 AS "97", 98 AS "98", 99 AS "99", 100 AS "100"
                                       , 101 AS "101", 102 AS "102", 103 AS "103", 104 AS "104", 105 AS "105", 106 AS "106", 107 AS "107", 108 AS "108", 109 AS "109", 110 AS "110"
                                       , 111 AS "111", 112 AS "112", 113 AS "113", 114 AS "114", 115 AS "115", 116 AS "116", 117 AS "117", 118 AS "118", 119 AS "119", 120 AS "120"
                                       , 121 AS "121", 122 AS "122", 123 AS "123", 124 AS "124", 125 AS "125", 126 AS "126", 127 AS "127", 128 AS "128", 129 AS "129", 130 AS "130"
                                       , 131 AS "131", 132 AS "132", 133 AS "133", 134 AS "134", 135 AS "135", 136 AS "136", 137 AS "137", 138 AS "138", 139 AS "139", 140 AS "140"
                                       , 141 AS "141", 142 AS "142", 143 AS "143", 144 AS "144", 145 AS "145", 146 AS "146", 147 AS "147", 148 AS "148", 149 AS "149", 150 AS "150"
                                       , 151 AS "151", 152 AS "152", 153 AS "153", 154 AS "154", 155 AS "155", 156 AS "156", 157 AS "157", 158 AS "158", 159 AS "159", 160 AS "160"
                                       , 161 AS "161", 162 AS "162", 163 AS "163", 164 AS "164", 165 AS "165", 166 AS "166", 167 AS "167", 168 AS "168", 169 AS "169", 170 AS "170"
                                       , 171 AS "171", 172 AS "172", 173 AS "173", 174 AS "174", 175 AS "175", 176 AS "176", 177 AS "177", 178 AS "178", 179 AS "179", 180 AS "180"
                                       , 181 AS "181", 182 AS "182", 183 AS "183", 184 AS "184", 185 AS "185", 186 AS "186", 187 AS "187", 188 AS "188", 189 AS "189", 190 AS "190"
                                       , 191 AS "191", 192 AS "192", 193 AS "193", 194 AS "194", 195 AS "195", 196 AS "196", 197 AS "197", 198 AS "198", 199 AS "199", 200 AS "200"
                                       , 201 AS "201", 202 AS "202", 203 AS "203", 204 AS "204", 205 AS "205", 206 AS "206", 207 AS "207", 208 AS "208", 209 AS "209", 210 AS "210"
                                       , 211 AS "211", 212 AS "212", 213 AS "213", 214 AS "214", 215 AS "215", 216 AS "216", 217 AS "217", 218 AS "218", 219 AS "219", 220 AS "220"
                                       , 221 AS "221", 222 AS "222", 223 AS "223", 224 AS "224", 225 AS "225", 226 AS "226", 227 AS "227", 228 AS "228", 229 AS "229", 230 AS "230"
                                       , 231 AS "231", 232 AS "232", 233 AS "233", 234 AS "234", 235 AS "235", 236 AS "236", 237 AS "237", 238 AS "238", 239 AS "239", 240 AS "240"
                                       , 241 AS "241", 242 AS "242", 243 AS "243", 244 AS "244", 245 AS "245", 246 AS "246", 247 AS "247", 248 AS "248", 249 AS "249", 250 AS "250"
                                       , 251 AS "251", 252 AS "252", 253 AS "253", 254 AS "254", 255 AS "255", 256 AS "256", 257 AS "257", 258 AS "258", 259 AS "259", 260 AS "260"
                                       , 261 AS "261", 262 AS "262", 263 AS "263", 264 AS "264", 265 AS "265", 266 AS "266", 267 AS "267", 268 AS "268", 269 AS "269", 270 AS "270"
                                       , 271 AS "271", 272 AS "272", 273 AS "273", 274 AS "274", 275 AS "275", 276 AS "276", 277 AS "277", 278 AS "278", 279 AS "279", 280 AS "280"
                                       , 281 AS "281", 282 AS "282", 283 AS "283", 284 AS "284", 285 AS "285", 286 AS "286", 287 AS "287", 288 AS "288", 289 AS "289", 290 AS "290"
                                       , 291 AS "291", 292 AS "292", 293 AS "293", 294 AS "294", 295 AS "295", 296 AS "296", 297 AS "297", 298 AS "298", 299 AS "299", 300 AS "300"
                                       , 301 AS "301", 302 AS "302", 303 AS "303", 304 AS "304", 305 AS "305", 306 AS "306", 307 AS "307", 308 AS "308", 309 AS "309", 310 AS "310"
                                       , 311 AS "311", 312 AS "312", 313 AS "313", 314 AS "314", 315 AS "315", 316 AS "316", 317 AS "317", 318 AS "318", 319 AS "319", 320 AS "320"
                                       , 321 AS "321", 322 AS "322", 323 AS "323", 324 AS "324", 325 AS "325", 326 AS "326", 327 AS "327", 328 AS "328", 329 AS "329", 330 AS "330"
                                       , 331 AS "331", 332 AS "332", 333 AS "333", 334 AS "334", 335 AS "335", 336 AS "336", 337 AS "337", 338 AS "338", 339 AS "339", 340 AS "340"
                                       , 341 AS "341", 342 AS "342", 343 AS "343", 344 AS "344", 345 AS "345", 346 AS "346", 347 AS "347", 348 AS "348", 349 AS "349", 350 AS "350"
                                       , 351 AS "351", 352 AS "352", 353 AS "353", 354 AS "354", 355 AS "355", 356 AS "356", 357 AS "357", 358 AS "358", 359 AS "359", 360 AS "360"
                                       , 361 AS "361", 362 AS "362", 363 AS "363", 364 AS "364"
                                       )
                                   ) P
                           ) S
                     GROUP BY S.XLS_KEY
                  ) W
               ON ( 0 = 0
                    AND E.XLS_KEY1             = W.XLS_KEY
                    AND E.DIVISION_ID          = V_BATCH_DIVISION_ID
                    AND E.PLAN_START_YYYYMMDD  = V_BATCH_PLAN_START_YYYYMMDD
                    AND E.CREATE_FROM_YYYYMMDD = V_BATCH_CREATE_FROM_YYYYMMDD
                    AND E.SEQ                  = V_BATCH_SEQ
                    AND E.XLS_KEY1             = V_BATCH_XLS_KEY1 )
            WHEN MATCHED THEN
            UPDATE
               SET
                     E.QTY001 = W.QTY001, E.QTY002 = W.QTY002, E.QTY003 = W.QTY003, E.QTY004 = W.QTY004, E.QTY005 = W.QTY005
                   , E.QTY006 = W.QTY006, E.QTY007 = W.QTY007, E.QTY008 = W.QTY008, E.QTY009 = W.QTY009, E.QTY010 = W.QTY010
                   , E.QTY011 = W.QTY011, E.QTY012 = W.QTY012, E.QTY013 = W.QTY013, E.QTY014 = W.QTY014, E.QTY015 = W.QTY015
                   , E.QTY016 = W.QTY016, E.QTY017 = W.QTY017, E.QTY018 = W.QTY018, E.QTY019 = W.QTY019, E.QTY020 = W.QTY020
                   , E.QTY021 = W.QTY021, E.QTY022 = W.QTY022, E.QTY023 = W.QTY023, E.QTY024 = W.QTY024, E.QTY025 = W.QTY025
                   , E.QTY026 = W.QTY026, E.QTY027 = W.QTY027, E.QTY028 = W.QTY028, E.QTY029 = W.QTY029, E.QTY030 = W.QTY030
                   , E.QTY031 = W.QTY031, E.QTY032 = W.QTY032, E.QTY033 = W.QTY033, E.QTY034 = W.QTY034, E.QTY035 = W.QTY035
                   , E.QTY036 = W.QTY036, E.QTY037 = W.QTY037, E.QTY038 = W.QTY038, E.QTY039 = W.QTY039, E.QTY040 = W.QTY040
                   , E.QTY041 = W.QTY041, E.QTY042 = W.QTY042, E.QTY043 = W.QTY043, E.QTY044 = W.QTY044, E.QTY045 = W.QTY045
                   , E.QTY046 = W.QTY046, E.QTY047 = W.QTY047, E.QTY048 = W.QTY048, E.QTY049 = W.QTY049, E.QTY050 = W.QTY050
                   , E.QTY051 = W.QTY051, E.QTY052 = W.QTY052, E.QTY053 = W.QTY053, E.QTY054 = W.QTY054, E.QTY055 = W.QTY055
                   , E.QTY056 = W.QTY056, E.QTY057 = W.QTY057, E.QTY058 = W.QTY058, E.QTY059 = W.QTY059, E.QTY060 = W.QTY060
                   , E.QTY061 = W.QTY061, E.QTY062 = W.QTY062, E.QTY063 = W.QTY063, E.QTY064 = W.QTY064, E.QTY065 = W.QTY065
                   , E.QTY066 = W.QTY066, E.QTY067 = W.QTY067, E.QTY068 = W.QTY068, E.QTY069 = W.QTY069, E.QTY070 = W.QTY070
                   , E.QTY071 = W.QTY071, E.QTY072 = W.QTY072, E.QTY073 = W.QTY073, E.QTY074 = W.QTY074, E.QTY075 = W.QTY075
                   , E.QTY076 = W.QTY076, E.QTY077 = W.QTY077, E.QTY078 = W.QTY078, E.QTY079 = W.QTY079, E.QTY080 = W.QTY080
                   , E.QTY081 = W.QTY081, E.QTY082 = W.QTY082, E.QTY083 = W.QTY083, E.QTY084 = W.QTY084, E.QTY085 = W.QTY085
                   , E.QTY086 = W.QTY086, E.QTY087 = W.QTY087, E.QTY088 = W.QTY088, E.QTY089 = W.QTY089, E.QTY090 = W.QTY090
                   , E.QTY091 = W.QTY091, E.QTY092 = W.QTY092, E.QTY093 = W.QTY093, E.QTY094 = W.QTY094, E.QTY095 = W.QTY095
                   , E.QTY096 = W.QTY096, E.QTY097 = W.QTY097, E.QTY098 = W.QTY098, E.QTY099 = W.QTY099, E.QTY100 = W.QTY100
                   , E.QTY101 = W.QTY101, E.QTY102 = W.QTY102, E.QTY103 = W.QTY103, E.QTY104 = W.QTY104, E.QTY105 = W.QTY105
                   , E.QTY106 = W.QTY106, E.QTY107 = W.QTY107, E.QTY108 = W.QTY108, E.QTY109 = W.QTY109, E.QTY110 = W.QTY110
                   , E.QTY111 = W.QTY111, E.QTY112 = W.QTY112, E.QTY113 = W.QTY113, E.QTY114 = W.QTY114, E.QTY115 = W.QTY115
                   , E.QTY116 = W.QTY116, E.QTY117 = W.QTY117, E.QTY118 = W.QTY118, E.QTY119 = W.QTY119, E.QTY120 = W.QTY120
                   , E.QTY121 = W.QTY121, E.QTY122 = W.QTY122, E.QTY123 = W.QTY123, E.QTY124 = W.QTY124, E.QTY125 = W.QTY125
                   , E.QTY126 = W.QTY126, E.QTY127 = W.QTY127, E.QTY128 = W.QTY128, E.QTY129 = W.QTY129, E.QTY130 = W.QTY130
                   , E.QTY131 = W.QTY131, E.QTY132 = W.QTY132, E.QTY133 = W.QTY133, E.QTY134 = W.QTY134, E.QTY135 = W.QTY135
                   , E.QTY136 = W.QTY136, E.QTY137 = W.QTY137, E.QTY138 = W.QTY138, E.QTY139 = W.QTY139, E.QTY140 = W.QTY140
                   , E.QTY141 = W.QTY141, E.QTY142 = W.QTY142, E.QTY143 = W.QTY143, E.QTY144 = W.QTY144, E.QTY145 = W.QTY145
                   , E.QTY146 = W.QTY146, E.QTY147 = W.QTY147, E.QTY148 = W.QTY148, E.QTY149 = W.QTY149, E.QTY150 = W.QTY150
                   , E.QTY151 = W.QTY151, E.QTY152 = W.QTY152, E.QTY153 = W.QTY153, E.QTY154 = W.QTY154, E.QTY155 = W.QTY155
                   , E.QTY156 = W.QTY156, E.QTY157 = W.QTY157, E.QTY158 = W.QTY158, E.QTY159 = W.QTY159, E.QTY160 = W.QTY160
                   , E.QTY161 = W.QTY161, E.QTY162 = W.QTY162, E.QTY163 = W.QTY163, E.QTY164 = W.QTY164, E.QTY165 = W.QTY165
                   , E.QTY166 = W.QTY166, E.QTY167 = W.QTY167, E.QTY168 = W.QTY168, E.QTY169 = W.QTY169, E.QTY170 = W.QTY170
                   , E.QTY171 = W.QTY171, E.QTY172 = W.QTY172, E.QTY173 = W.QTY173, E.QTY174 = W.QTY174, E.QTY175 = W.QTY175
                   , E.QTY176 = W.QTY176, E.QTY177 = W.QTY177, E.QTY178 = W.QTY178, E.QTY179 = W.QTY179, E.QTY180 = W.QTY180
                   , E.QTY181 = W.QTY181, E.QTY182 = W.QTY182, E.QTY183 = W.QTY183, E.QTY184 = W.QTY184, E.QTY185 = W.QTY185
                   , E.QTY186 = W.QTY186, E.QTY187 = W.QTY187, E.QTY188 = W.QTY188, E.QTY189 = W.QTY189, E.QTY190 = W.QTY190
                   , E.QTY191 = W.QTY191, E.QTY192 = W.QTY192, E.QTY193 = W.QTY193, E.QTY194 = W.QTY194, E.QTY195 = W.QTY195
                   , E.QTY196 = W.QTY196, E.QTY197 = W.QTY197, E.QTY198 = W.QTY198, E.QTY199 = W.QTY199, E.QTY200 = W.QTY200
                   , E.QTY201 = W.QTY201, E.QTY202 = W.QTY202, E.QTY203 = W.QTY203, E.QTY204 = W.QTY204, E.QTY205 = W.QTY205
                   , E.QTY206 = W.QTY206, E.QTY207 = W.QTY207, E.QTY208 = W.QTY208, E.QTY209 = W.QTY209, E.QTY210 = W.QTY210
                   , E.QTY211 = W.QTY211, E.QTY212 = W.QTY212, E.QTY213 = W.QTY213, E.QTY214 = W.QTY214, E.QTY215 = W.QTY215
                   , E.QTY216 = W.QTY216, E.QTY217 = W.QTY217, E.QTY218 = W.QTY218, E.QTY219 = W.QTY219, E.QTY220 = W.QTY220
                   , E.QTY221 = W.QTY221, E.QTY222 = W.QTY222, E.QTY223 = W.QTY223, E.QTY224 = W.QTY224, E.QTY225 = W.QTY225
                   , E.QTY226 = W.QTY226, E.QTY227 = W.QTY227, E.QTY228 = W.QTY228, E.QTY229 = W.QTY229, E.QTY230 = W.QTY230
                   , E.QTY231 = W.QTY231, E.QTY232 = W.QTY232, E.QTY233 = W.QTY233, E.QTY234 = W.QTY234, E.QTY235 = W.QTY235
                   , E.QTY236 = W.QTY236, E.QTY237 = W.QTY237, E.QTY238 = W.QTY238, E.QTY239 = W.QTY239, E.QTY240 = W.QTY240
                   , E.QTY241 = W.QTY241, E.QTY242 = W.QTY242, E.QTY243 = W.QTY243, E.QTY244 = W.QTY244, E.QTY245 = W.QTY245
                   , E.QTY246 = W.QTY246, E.QTY247 = W.QTY247, E.QTY248 = W.QTY248, E.QTY249 = W.QTY249, E.QTY250 = W.QTY250
                   , E.QTY251 = W.QTY251, E.QTY252 = W.QTY252, E.QTY253 = W.QTY253, E.QTY254 = W.QTY254, E.QTY255 = W.QTY255
                   , E.QTY256 = W.QTY256, E.QTY257 = W.QTY257, E.QTY258 = W.QTY258, E.QTY259 = W.QTY259, E.QTY260 = W.QTY260
                   , E.QTY261 = W.QTY261, E.QTY262 = W.QTY262, E.QTY263 = W.QTY263, E.QTY264 = W.QTY264, E.QTY265 = W.QTY265
                   , E.QTY266 = W.QTY266, E.QTY267 = W.QTY267, E.QTY268 = W.QTY268, E.QTY269 = W.QTY269, E.QTY270 = W.QTY270
                   , E.QTY271 = W.QTY271, E.QTY272 = W.QTY272, E.QTY273 = W.QTY273, E.QTY274 = W.QTY274, E.QTY275 = W.QTY275
                   , E.QTY276 = W.QTY276, E.QTY277 = W.QTY277, E.QTY278 = W.QTY278, E.QTY279 = W.QTY279, E.QTY280 = W.QTY280
                   , E.QTY281 = W.QTY281, E.QTY282 = W.QTY282, E.QTY283 = W.QTY283, E.QTY284 = W.QTY284, E.QTY285 = W.QTY285
                   , E.QTY286 = W.QTY286, E.QTY287 = W.QTY287, E.QTY288 = W.QTY288, E.QTY289 = W.QTY289, E.QTY290 = W.QTY290
                   , E.QTY291 = W.QTY291, E.QTY292 = W.QTY292, E.QTY293 = W.QTY293, E.QTY294 = W.QTY294, E.QTY295 = W.QTY295
                   , E.QTY296 = W.QTY296, E.QTY297 = W.QTY297, E.QTY298 = W.QTY298, E.QTY299 = W.QTY299, E.QTY300 = W.QTY300
                   , E.QTY301 = W.QTY301, E.QTY302 = W.QTY302, E.QTY303 = W.QTY303, E.QTY304 = W.QTY304, E.QTY305 = W.QTY305
                   , E.QTY306 = W.QTY306, E.QTY307 = W.QTY307, E.QTY308 = W.QTY308, E.QTY309 = W.QTY309, E.QTY310 = W.QTY310
                   , E.QTY311 = W.QTY311, E.QTY312 = W.QTY312, E.QTY313 = W.QTY313, E.QTY314 = W.QTY314, E.QTY315 = W.QTY315
                   , E.QTY316 = W.QTY316, E.QTY317 = W.QTY317, E.QTY318 = W.QTY318, E.QTY319 = W.QTY319, E.QTY320 = W.QTY320
                   , E.QTY321 = W.QTY321, E.QTY322 = W.QTY322, E.QTY323 = W.QTY323, E.QTY324 = W.QTY324, E.QTY325 = W.QTY325
                   , E.QTY326 = W.QTY326, E.QTY327 = W.QTY327, E.QTY328 = W.QTY328, E.QTY329 = W.QTY329, E.QTY330 = W.QTY330
                   , E.QTY331 = W.QTY331, E.QTY332 = W.QTY332, E.QTY333 = W.QTY333, E.QTY334 = W.QTY334, E.QTY335 = W.QTY335
                   , E.QTY336 = W.QTY336, E.QTY337 = W.QTY337, E.QTY338 = W.QTY338, E.QTY339 = W.QTY339, E.QTY340 = W.QTY340
                   , E.QTY341 = W.QTY341, E.QTY342 = W.QTY342, E.QTY343 = W.QTY343, E.QTY344 = W.QTY344, E.QTY345 = W.QTY345
                   , E.QTY346 = W.QTY346, E.QTY347 = W.QTY347, E.QTY348 = W.QTY348, E.QTY349 = W.QTY349, E.QTY350 = W.QTY350
                   , E.QTY351 = W.QTY351, E.QTY352 = W.QTY352, E.QTY353 = W.QTY353, E.QTY354 = W.QTY354, E.QTY355 = W.QTY355
                   , E.QTY356 = W.QTY356, E.QTY357 = W.QTY357, E.QTY358 = W.QTY358, E.QTY359 = W.QTY359, E.QTY360 = W.QTY360
                   , E.QTY361 = W.QTY361, E.QTY362 = W.QTY362, E.QTY363 = W.QTY363, E.QTY364 = W.QTY364
                   , WQTY01 = P_WQTY01, WQTY02 = P_WQTY02, WQTY03 = P_WQTY03, WQTY04 = P_WQTY04, WQTY05 = P_WQTY05
                   , WQTY06 = P_WQTY06, WQTY07 = P_WQTY07, WQTY08 = P_WQTY08, WQTY09 = P_WQTY09, WQTY10 = P_WQTY10
                   , WQTY11 = P_WQTY11, WQTY12 = P_WQTY12, WQTY13 = P_WQTY13, WQTY14 = P_WQTY14, WQTY15 = P_WQTY15
                   , WQTY16 = P_WQTY16, WQTY17 = P_WQTY17, WQTY18 = P_WQTY18, WQTY19 = P_WQTY19, WQTY20 = P_WQTY20
                   , WQTY21 = P_WQTY21, WQTY22 = P_WQTY22, WQTY23 = P_WQTY23, WQTY24 = P_WQTY24, WQTY25 = P_WQTY25
                   , WQTY26 = P_WQTY26, WQTY27 = P_WQTY27, WQTY28 = P_WQTY28, WQTY29 = P_WQTY29, WQTY30 = P_WQTY30
                   , WQTY31 = P_WQTY31, WQTY32 = P_WQTY32, WQTY33 = P_WQTY33, WQTY34 = P_WQTY34, WQTY35 = P_WQTY35
                   , WQTY36 = P_WQTY36, WQTY37 = P_WQTY37, WQTY38 = P_WQTY38, WQTY39 = P_WQTY39, WQTY40 = P_WQTY40
                   , WQTY41 = P_WQTY41, WQTY42 = P_WQTY42, WQTY43 = P_WQTY43, WQTY44 = P_WQTY44, WQTY45 = P_WQTY45
                   , WQTY46 = P_WQTY46, WQTY47 = P_WQTY47, WQTY48 = P_WQTY48, WQTY49 = P_WQTY49, WQTY50 = P_WQTY50
                   , WQTY51 = P_WQTY51, WQTY52 = P_WQTY52
                   , LAST_UPDATED_BY  = V_BATCH_USER
                   , LAST_UPDATE_DATE = SYSDATE
                   , ATTRIBUTE2       = 'Y';

            /*                두 성질을 함께 재현하려면 RTRIM(x) IS NOT NULL 이 정확하다(린터 L224 미검사 결함류 방어). */
            IF RTRIM(P_DAILYQTY) IS NOT NULL THEN
                /*  MSSQL FORMATMESSAGE(' WHERE DIVISION_ID = ''%s''', x) -> ' WHERE DIVISION_ID = ''' || x || ''''
                    MSSQL FORMATMESSAGE(' AND XLS_KEY1 = %d ', x)         -> ' AND XLS_KEY1 = ' || TO_CHAR(x) || ' '
                    (2024.09.03 KSK 구문오류방지 위해 %d 사용). CHAR(10) -> CHR(10). @sql 은 CLOB(CV-046). */
                V_SQL := 'update SCP_XLS_PSI_GLOBAL ' || CHR(10);
                V_SQL := V_SQL || ' SET ' || P_DAILYQTY || CHR(10);
                V_SQL := V_SQL || ' WHERE DIVISION_ID = ''' || V_BATCH_DIVISION_ID || '''' || CHR(10);
                V_SQL := V_SQL || ' AND XLS_KEY1 = ' || TO_CHAR(V_BATCH_XLS_KEY1) || ' ' || CHR(10);   /* 구문 오류 회피(KSK) */
                V_SQL := V_SQL || ' AND CREATE_FROM_YYYYMMDD = ''' || P_CREATE_FROM_YYYYMMDD || '''' || CHR(10);

                IF P_IS_DEBUG = 1 THEN
                    /*  원본 SELECT @SQL AS "SQL" (디버그 결과셋) -> DBMS_OUTPUT (H-9) */
                    DBMS_OUTPUT.PUT_LINE( DBMS_LOB.SUBSTR(V_SQL, 32767, 1) );
                END IF;

                /*  MSSQL exec (@sql) -> EXECUTE IMMEDIATE (CV-040) */
                EXECUTE IMMEDIATE V_SQL;
            END IF;

            /*  IF OBJECT_ID('tempdb..#WORKING_TBL') IS NOT NULL DROP TABLE #WORKING_TBL;
                IF OBJECT_ID('tempdb..#WEEK_QTY_TBL') IS NOT NULL DROP TABLE #WEEK_QTY_TBL; */
            DELETE FROM GT_XPGT_WORKING_TBL;
            DELETE FROM GT_XPGT_WEEK_QTY_TBL;

        END IF;

        /*  IF @v_batch_measure IN ('PACK_PROD','CELL_CHAR_PLAN','CELL_PROD') -- CELL_CHAR_PLAN SCP_XLS_PSI_GLOBAL 테이블에 저장만 처리함. */
        IF V_BATCH_MEASURE IN ('CELL_CHAR_PLAN') THEN   /*  CELL_CHAR_PLAN SCP_XLS_PSI_GLOBAL 테이블에 저장만 처리함. */
            UPDATE SCP_XLS_PSI_GLOBAL
               SET
                     QTY001 = TRUNC(P_WQTY01 / 7), QTY002 = TRUNC(P_WQTY01 / 7), QTY003 = TRUNC(P_WQTY01 / 7), QTY004 = TRUNC(P_WQTY01 / 7), QTY005 = TRUNC(P_WQTY01 / 7), QTY006 = TRUNC(P_WQTY01 / 7), QTY007 = (TRUNC(P_WQTY01 / 7) + MOD(P_WQTY01, 7))
                   , QTY008 = TRUNC(P_WQTY02 / 7), QTY009 = TRUNC(P_WQTY02 / 7), QTY010 = TRUNC(P_WQTY02 / 7), QTY011 = TRUNC(P_WQTY02 / 7), QTY012 = TRUNC(P_WQTY02 / 7), QTY013 = TRUNC(P_WQTY02 / 7), QTY014 = (TRUNC(P_WQTY02 / 7) + MOD(P_WQTY02, 7))
                   , QTY015 = TRUNC(P_WQTY03 / 7), QTY016 = TRUNC(P_WQTY03 / 7), QTY017 = TRUNC(P_WQTY03 / 7), QTY018 = TRUNC(P_WQTY03 / 7), QTY019 = TRUNC(P_WQTY03 / 7), QTY020 = TRUNC(P_WQTY03 / 7), QTY021 = (TRUNC(P_WQTY03 / 7) + MOD(P_WQTY03, 7))
                   , QTY022 = TRUNC(P_WQTY04 / 7), QTY023 = TRUNC(P_WQTY04 / 7), QTY024 = TRUNC(P_WQTY04 / 7), QTY025 = TRUNC(P_WQTY04 / 7), QTY026 = TRUNC(P_WQTY04 / 7), QTY027 = TRUNC(P_WQTY04 / 7), QTY028 = (TRUNC(P_WQTY04 / 7) + MOD(P_WQTY04, 7))
                   , QTY029 = TRUNC(P_WQTY05 / 7), QTY030 = TRUNC(P_WQTY05 / 7), QTY031 = TRUNC(P_WQTY05 / 7), QTY032 = TRUNC(P_WQTY05 / 7), QTY033 = TRUNC(P_WQTY05 / 7), QTY034 = TRUNC(P_WQTY05 / 7), QTY035 = (TRUNC(P_WQTY05 / 7) + MOD(P_WQTY05, 7))
                   , QTY036 = TRUNC(P_WQTY06 / 7), QTY037 = TRUNC(P_WQTY06 / 7), QTY038 = TRUNC(P_WQTY06 / 7), QTY039 = TRUNC(P_WQTY06 / 7), QTY040 = TRUNC(P_WQTY06 / 7), QTY041 = TRUNC(P_WQTY06 / 7), QTY042 = (TRUNC(P_WQTY06 / 7) + MOD(P_WQTY06, 7))
                   , QTY043 = TRUNC(P_WQTY07 / 7), QTY044 = TRUNC(P_WQTY07 / 7), QTY045 = TRUNC(P_WQTY07 / 7), QTY046 = TRUNC(P_WQTY07 / 7), QTY047 = TRUNC(P_WQTY07 / 7), QTY048 = TRUNC(P_WQTY07 / 7), QTY049 = (TRUNC(P_WQTY07 / 7) + MOD(P_WQTY07, 7))
                   , QTY050 = TRUNC(P_WQTY08 / 7), QTY051 = TRUNC(P_WQTY08 / 7), QTY052 = TRUNC(P_WQTY08 / 7), QTY053 = TRUNC(P_WQTY08 / 7), QTY054 = TRUNC(P_WQTY08 / 7), QTY055 = TRUNC(P_WQTY08 / 7), QTY056 = (TRUNC(P_WQTY08 / 7) + MOD(P_WQTY08, 7))
                   , QTY057 = TRUNC(P_WQTY09 / 7), QTY058 = TRUNC(P_WQTY09 / 7), QTY059 = TRUNC(P_WQTY09 / 7), QTY060 = TRUNC(P_WQTY09 / 7), QTY061 = TRUNC(P_WQTY09 / 7), QTY062 = TRUNC(P_WQTY09 / 7), QTY063 = (TRUNC(P_WQTY09 / 7) + MOD(P_WQTY09, 7))
                   , QTY064 = TRUNC(P_WQTY10 / 7), QTY065 = TRUNC(P_WQTY10 / 7), QTY066 = TRUNC(P_WQTY10 / 7), QTY067 = TRUNC(P_WQTY10 / 7), QTY068 = TRUNC(P_WQTY10 / 7), QTY069 = TRUNC(P_WQTY10 / 7), QTY070 = (TRUNC(P_WQTY10 / 7) + MOD(P_WQTY10, 7))
                   , QTY071 = TRUNC(P_WQTY11 / 7), QTY072 = TRUNC(P_WQTY11 / 7), QTY073 = TRUNC(P_WQTY11 / 7), QTY074 = TRUNC(P_WQTY11 / 7), QTY075 = TRUNC(P_WQTY11 / 7), QTY076 = TRUNC(P_WQTY11 / 7), QTY077 = (TRUNC(P_WQTY11 / 7) + MOD(P_WQTY11, 7))
                   , QTY078 = TRUNC(P_WQTY12 / 7), QTY079 = TRUNC(P_WQTY12 / 7), QTY080 = TRUNC(P_WQTY12 / 7), QTY081 = TRUNC(P_WQTY12 / 7), QTY082 = TRUNC(P_WQTY12 / 7), QTY083 = TRUNC(P_WQTY12 / 7), QTY084 = (TRUNC(P_WQTY12 / 7) + MOD(P_WQTY12, 7))
                   , QTY085 = TRUNC(P_WQTY13 / 7), QTY086 = TRUNC(P_WQTY13 / 7), QTY087 = TRUNC(P_WQTY13 / 7), QTY088 = TRUNC(P_WQTY13 / 7), QTY089 = TRUNC(P_WQTY13 / 7), QTY090 = TRUNC(P_WQTY13 / 7), QTY091 = (TRUNC(P_WQTY13 / 7) + MOD(P_WQTY13, 7))
                   , QTY092 = TRUNC(P_WQTY14 / 7), QTY093 = TRUNC(P_WQTY14 / 7), QTY094 = TRUNC(P_WQTY14 / 7), QTY095 = TRUNC(P_WQTY14 / 7), QTY096 = TRUNC(P_WQTY14 / 7), QTY097 = TRUNC(P_WQTY14 / 7), QTY098 = (TRUNC(P_WQTY14 / 7) + MOD(P_WQTY14, 7))
                   , QTY099 = TRUNC(P_WQTY15 / 7), QTY100 = TRUNC(P_WQTY15 / 7), QTY101 = TRUNC(P_WQTY15 / 7), QTY102 = TRUNC(P_WQTY15 / 7), QTY103 = TRUNC(P_WQTY15 / 7), QTY104 = TRUNC(P_WQTY15 / 7), QTY105 = (TRUNC(P_WQTY15 / 7) + MOD(P_WQTY15, 7))
                   , QTY106 = TRUNC(P_WQTY16 / 7), QTY107 = TRUNC(P_WQTY16 / 7), QTY108 = TRUNC(P_WQTY16 / 7), QTY109 = TRUNC(P_WQTY16 / 7), QTY110 = TRUNC(P_WQTY16 / 7), QTY111 = TRUNC(P_WQTY16 / 7), QTY112 = (TRUNC(P_WQTY16 / 7) + MOD(P_WQTY16, 7))
                   , QTY113 = TRUNC(P_WQTY17 / 7), QTY114 = TRUNC(P_WQTY17 / 7), QTY115 = TRUNC(P_WQTY17 / 7), QTY116 = TRUNC(P_WQTY17 / 7), QTY117 = TRUNC(P_WQTY17 / 7), QTY118 = TRUNC(P_WQTY17 / 7), QTY119 = (TRUNC(P_WQTY17 / 7) + MOD(P_WQTY17, 7))
                   , QTY120 = TRUNC(P_WQTY18 / 7), QTY121 = TRUNC(P_WQTY18 / 7), QTY122 = TRUNC(P_WQTY18 / 7), QTY123 = TRUNC(P_WQTY18 / 7), QTY124 = TRUNC(P_WQTY18 / 7), QTY125 = TRUNC(P_WQTY18 / 7), QTY126 = (TRUNC(P_WQTY18 / 7) + MOD(P_WQTY18, 7))
                   , QTY127 = TRUNC(P_WQTY19 / 7), QTY128 = TRUNC(P_WQTY19 / 7), QTY129 = TRUNC(P_WQTY19 / 7), QTY130 = TRUNC(P_WQTY19 / 7), QTY131 = TRUNC(P_WQTY19 / 7), QTY132 = TRUNC(P_WQTY19 / 7), QTY133 = (TRUNC(P_WQTY19 / 7) + MOD(P_WQTY19, 7))
                   , QTY134 = TRUNC(P_WQTY20 / 7), QTY135 = TRUNC(P_WQTY20 / 7), QTY136 = TRUNC(P_WQTY20 / 7), QTY137 = TRUNC(P_WQTY20 / 7), QTY138 = TRUNC(P_WQTY20 / 7), QTY139 = TRUNC(P_WQTY20 / 7), QTY140 = (TRUNC(P_WQTY20 / 7) + MOD(P_WQTY20, 7))
                   , QTY141 = TRUNC(P_WQTY21 / 7), QTY142 = TRUNC(P_WQTY21 / 7), QTY143 = TRUNC(P_WQTY21 / 7), QTY144 = TRUNC(P_WQTY21 / 7), QTY145 = TRUNC(P_WQTY21 / 7), QTY146 = TRUNC(P_WQTY21 / 7), QTY147 = (TRUNC(P_WQTY21 / 7) + MOD(P_WQTY21, 7))
                   , QTY148 = TRUNC(P_WQTY22 / 7), QTY149 = TRUNC(P_WQTY22 / 7), QTY150 = TRUNC(P_WQTY22 / 7), QTY151 = TRUNC(P_WQTY22 / 7), QTY152 = TRUNC(P_WQTY22 / 7), QTY153 = TRUNC(P_WQTY22 / 7), QTY154 = (TRUNC(P_WQTY22 / 7) + MOD(P_WQTY22, 7))
                   , QTY155 = TRUNC(P_WQTY23 / 7), QTY156 = TRUNC(P_WQTY23 / 7), QTY157 = TRUNC(P_WQTY23 / 7), QTY158 = TRUNC(P_WQTY23 / 7), QTY159 = TRUNC(P_WQTY23 / 7), QTY160 = TRUNC(P_WQTY23 / 7), QTY161 = (TRUNC(P_WQTY23 / 7) + MOD(P_WQTY23, 7))
                   , QTY162 = TRUNC(P_WQTY24 / 7), QTY163 = TRUNC(P_WQTY24 / 7), QTY164 = TRUNC(P_WQTY24 / 7), QTY165 = TRUNC(P_WQTY24 / 7), QTY166 = TRUNC(P_WQTY24 / 7), QTY167 = TRUNC(P_WQTY24 / 7), QTY168 = (TRUNC(P_WQTY24 / 7) + MOD(P_WQTY24, 7))
                   , QTY169 = TRUNC(P_WQTY25 / 7), QTY170 = TRUNC(P_WQTY25 / 7), QTY171 = TRUNC(P_WQTY25 / 7), QTY172 = TRUNC(P_WQTY25 / 7), QTY173 = TRUNC(P_WQTY25 / 7), QTY174 = TRUNC(P_WQTY25 / 7), QTY175 = (TRUNC(P_WQTY25 / 7) + MOD(P_WQTY25, 7))
                   , QTY176 = TRUNC(P_WQTY26 / 7), QTY177 = TRUNC(P_WQTY26 / 7), QTY178 = TRUNC(P_WQTY26 / 7), QTY179 = TRUNC(P_WQTY26 / 7), QTY180 = TRUNC(P_WQTY26 / 7), QTY181 = TRUNC(P_WQTY26 / 7), QTY182 = (TRUNC(P_WQTY26 / 7) + MOD(P_WQTY26, 7))
                   , QTY183 = TRUNC(P_WQTY27 / 7), QTY184 = TRUNC(P_WQTY27 / 7), QTY185 = TRUNC(P_WQTY27 / 7), QTY186 = TRUNC(P_WQTY27 / 7), QTY187 = TRUNC(P_WQTY27 / 7), QTY188 = TRUNC(P_WQTY27 / 7), QTY189 = (TRUNC(P_WQTY27 / 7) + MOD(P_WQTY27, 7))
                   , QTY190 = TRUNC(P_WQTY28 / 7), QTY191 = TRUNC(P_WQTY28 / 7), QTY192 = TRUNC(P_WQTY28 / 7), QTY193 = TRUNC(P_WQTY28 / 7), QTY194 = TRUNC(P_WQTY28 / 7), QTY195 = TRUNC(P_WQTY28 / 7), QTY196 = (TRUNC(P_WQTY28 / 7) + MOD(P_WQTY28, 7))
                   , QTY197 = TRUNC(P_WQTY29 / 7), QTY198 = TRUNC(P_WQTY29 / 7), QTY199 = TRUNC(P_WQTY29 / 7), QTY200 = TRUNC(P_WQTY29 / 7), QTY201 = TRUNC(P_WQTY29 / 7), QTY202 = TRUNC(P_WQTY29 / 7), QTY203 = (TRUNC(P_WQTY29 / 7) + MOD(P_WQTY29, 7))
                   , QTY204 = TRUNC(P_WQTY30 / 7), QTY205 = TRUNC(P_WQTY30 / 7), QTY206 = TRUNC(P_WQTY30 / 7), QTY207 = TRUNC(P_WQTY30 / 7), QTY208 = TRUNC(P_WQTY30 / 7), QTY209 = TRUNC(P_WQTY30 / 7), QTY210 = (TRUNC(P_WQTY30 / 7) + MOD(P_WQTY30, 7))
                   , QTY211 = TRUNC(P_WQTY31 / 7), QTY212 = TRUNC(P_WQTY31 / 7), QTY213 = TRUNC(P_WQTY31 / 7), QTY214 = TRUNC(P_WQTY31 / 7), QTY215 = TRUNC(P_WQTY31 / 7), QTY216 = TRUNC(P_WQTY31 / 7), QTY217 = (TRUNC(P_WQTY31 / 7) + MOD(P_WQTY31, 7))
                   , QTY218 = TRUNC(P_WQTY32 / 7), QTY219 = TRUNC(P_WQTY32 / 7), QTY220 = TRUNC(P_WQTY32 / 7), QTY221 = TRUNC(P_WQTY32 / 7), QTY222 = TRUNC(P_WQTY32 / 7), QTY223 = TRUNC(P_WQTY32 / 7), QTY224 = (TRUNC(P_WQTY32 / 7) + MOD(P_WQTY32, 7))
                   , QTY225 = TRUNC(P_WQTY33 / 7), QTY226 = TRUNC(P_WQTY33 / 7), QTY227 = TRUNC(P_WQTY33 / 7), QTY228 = TRUNC(P_WQTY33 / 7), QTY229 = TRUNC(P_WQTY33 / 7), QTY230 = TRUNC(P_WQTY33 / 7), QTY231 = (TRUNC(P_WQTY33 / 7) + MOD(P_WQTY33, 7))
                   , QTY232 = TRUNC(P_WQTY34 / 7), QTY233 = TRUNC(P_WQTY34 / 7), QTY234 = TRUNC(P_WQTY34 / 7), QTY235 = TRUNC(P_WQTY34 / 7), QTY236 = TRUNC(P_WQTY34 / 7), QTY237 = TRUNC(P_WQTY34 / 7), QTY238 = (TRUNC(P_WQTY34 / 7) + MOD(P_WQTY34, 7))
                   , QTY239 = TRUNC(P_WQTY35 / 7), QTY240 = TRUNC(P_WQTY35 / 7), QTY241 = TRUNC(P_WQTY35 / 7), QTY242 = TRUNC(P_WQTY35 / 7), QTY243 = TRUNC(P_WQTY35 / 7), QTY244 = TRUNC(P_WQTY35 / 7), QTY245 = (TRUNC(P_WQTY35 / 7) + MOD(P_WQTY35, 7))
                   , QTY246 = TRUNC(P_WQTY36 / 7), QTY247 = TRUNC(P_WQTY36 / 7), QTY248 = TRUNC(P_WQTY36 / 7), QTY249 = TRUNC(P_WQTY36 / 7), QTY250 = TRUNC(P_WQTY36 / 7), QTY251 = TRUNC(P_WQTY36 / 7), QTY252 = (TRUNC(P_WQTY36 / 7) + MOD(P_WQTY36, 7))
                   , QTY253 = TRUNC(P_WQTY37 / 7), QTY254 = TRUNC(P_WQTY37 / 7), QTY255 = TRUNC(P_WQTY37 / 7), QTY256 = TRUNC(P_WQTY37 / 7), QTY257 = TRUNC(P_WQTY37 / 7), QTY258 = TRUNC(P_WQTY37 / 7), QTY259 = (TRUNC(P_WQTY37 / 7) + MOD(P_WQTY37, 7))
                   , QTY260 = TRUNC(P_WQTY38 / 7), QTY261 = TRUNC(P_WQTY38 / 7), QTY262 = TRUNC(P_WQTY38 / 7), QTY263 = TRUNC(P_WQTY38 / 7), QTY264 = TRUNC(P_WQTY38 / 7), QTY265 = TRUNC(P_WQTY38 / 7), QTY266 = (TRUNC(P_WQTY38 / 7) + MOD(P_WQTY38, 7))
                   , QTY267 = TRUNC(P_WQTY39 / 7), QTY268 = TRUNC(P_WQTY39 / 7), QTY269 = TRUNC(P_WQTY39 / 7), QTY270 = TRUNC(P_WQTY39 / 7), QTY271 = TRUNC(P_WQTY39 / 7), QTY272 = TRUNC(P_WQTY39 / 7), QTY273 = (TRUNC(P_WQTY39 / 7) + MOD(P_WQTY39, 7))
                   , QTY274 = TRUNC(P_WQTY40 / 7), QTY275 = TRUNC(P_WQTY40 / 7), QTY276 = TRUNC(P_WQTY40 / 7), QTY277 = TRUNC(P_WQTY40 / 7), QTY278 = TRUNC(P_WQTY40 / 7), QTY279 = TRUNC(P_WQTY40 / 7), QTY280 = (TRUNC(P_WQTY40 / 7) + MOD(P_WQTY40, 7))
                   , QTY281 = TRUNC(P_WQTY41 / 7), QTY282 = TRUNC(P_WQTY41 / 7), QTY283 = TRUNC(P_WQTY41 / 7), QTY284 = TRUNC(P_WQTY41 / 7), QTY285 = TRUNC(P_WQTY41 / 7), QTY286 = TRUNC(P_WQTY41 / 7), QTY287 = (TRUNC(P_WQTY41 / 7) + MOD(P_WQTY41, 7))
                   , QTY288 = TRUNC(P_WQTY42 / 7), QTY289 = TRUNC(P_WQTY42 / 7), QTY290 = TRUNC(P_WQTY42 / 7), QTY291 = TRUNC(P_WQTY42 / 7), QTY292 = TRUNC(P_WQTY42 / 7), QTY293 = TRUNC(P_WQTY42 / 7), QTY294 = (TRUNC(P_WQTY42 / 7) + MOD(P_WQTY42, 7))
                   , QTY295 = TRUNC(P_WQTY43 / 7), QTY296 = TRUNC(P_WQTY43 / 7), QTY297 = TRUNC(P_WQTY43 / 7), QTY298 = TRUNC(P_WQTY43 / 7), QTY299 = TRUNC(P_WQTY43 / 7), QTY300 = TRUNC(P_WQTY43 / 7), QTY301 = (TRUNC(P_WQTY43 / 7) + MOD(P_WQTY43, 7))
                   , QTY302 = TRUNC(P_WQTY44 / 7), QTY303 = TRUNC(P_WQTY44 / 7), QTY304 = TRUNC(P_WQTY44 / 7), QTY305 = TRUNC(P_WQTY44 / 7), QTY306 = TRUNC(P_WQTY44 / 7), QTY307 = TRUNC(P_WQTY44 / 7), QTY308 = (TRUNC(P_WQTY44 / 7) + MOD(P_WQTY44, 7))
                   , QTY309 = TRUNC(P_WQTY45 / 7), QTY310 = TRUNC(P_WQTY45 / 7), QTY311 = TRUNC(P_WQTY45 / 7), QTY312 = TRUNC(P_WQTY45 / 7), QTY313 = TRUNC(P_WQTY45 / 7), QTY314 = TRUNC(P_WQTY45 / 7), QTY315 = (TRUNC(P_WQTY45 / 7) + MOD(P_WQTY45, 7))
                   , QTY316 = TRUNC(P_WQTY46 / 7), QTY317 = TRUNC(P_WQTY46 / 7), QTY318 = TRUNC(P_WQTY46 / 7), QTY319 = TRUNC(P_WQTY46 / 7), QTY320 = TRUNC(P_WQTY46 / 7), QTY321 = TRUNC(P_WQTY46 / 7), QTY322 = (TRUNC(P_WQTY46 / 7) + MOD(P_WQTY46, 7))
                   , QTY323 = TRUNC(P_WQTY47 / 7), QTY324 = TRUNC(P_WQTY47 / 7), QTY325 = TRUNC(P_WQTY47 / 7), QTY326 = TRUNC(P_WQTY47 / 7), QTY327 = TRUNC(P_WQTY47 / 7), QTY328 = TRUNC(P_WQTY47 / 7), QTY329 = (TRUNC(P_WQTY47 / 7) + MOD(P_WQTY47, 7))
                   , QTY330 = TRUNC(P_WQTY48 / 7), QTY331 = TRUNC(P_WQTY48 / 7), QTY332 = TRUNC(P_WQTY48 / 7), QTY333 = TRUNC(P_WQTY48 / 7), QTY334 = TRUNC(P_WQTY48 / 7), QTY335 = TRUNC(P_WQTY48 / 7), QTY336 = (TRUNC(P_WQTY48 / 7) + MOD(P_WQTY48, 7))
                   , QTY337 = TRUNC(P_WQTY49 / 7), QTY338 = TRUNC(P_WQTY49 / 7), QTY339 = TRUNC(P_WQTY49 / 7), QTY340 = TRUNC(P_WQTY49 / 7), QTY341 = TRUNC(P_WQTY49 / 7), QTY342 = TRUNC(P_WQTY49 / 7), QTY343 = (TRUNC(P_WQTY49 / 7) + MOD(P_WQTY49, 7))
                   , QTY344 = TRUNC(P_WQTY50 / 7), QTY345 = TRUNC(P_WQTY50 / 7), QTY346 = TRUNC(P_WQTY50 / 7), QTY347 = TRUNC(P_WQTY50 / 7), QTY348 = TRUNC(P_WQTY50 / 7), QTY349 = TRUNC(P_WQTY50 / 7), QTY350 = (TRUNC(P_WQTY50 / 7) + MOD(P_WQTY50, 7))
                   , QTY351 = TRUNC(P_WQTY51 / 7), QTY352 = TRUNC(P_WQTY51 / 7), QTY353 = TRUNC(P_WQTY51 / 7), QTY354 = TRUNC(P_WQTY51 / 7), QTY355 = TRUNC(P_WQTY51 / 7), QTY356 = TRUNC(P_WQTY51 / 7), QTY357 = (TRUNC(P_WQTY51 / 7) + MOD(P_WQTY51, 7))
                   , QTY358 = TRUNC(P_WQTY52 / 7), QTY359 = TRUNC(P_WQTY52 / 7), QTY360 = TRUNC(P_WQTY52 / 7), QTY361 = TRUNC(P_WQTY52 / 7), QTY362 = TRUNC(P_WQTY52 / 7), QTY363 = TRUNC(P_WQTY52 / 7), QTY364 = (TRUNC(P_WQTY52 / 7) + MOD(P_WQTY52, 7))

                   , WQTY01 = P_WQTY01, WQTY02 = P_WQTY02, WQTY03 = P_WQTY03, WQTY04 = P_WQTY04, WQTY05 = P_WQTY05
                   , WQTY06 = P_WQTY06, WQTY07 = P_WQTY07, WQTY08 = P_WQTY08, WQTY09 = P_WQTY09, WQTY10 = P_WQTY10
                   , WQTY11 = P_WQTY11, WQTY12 = P_WQTY12, WQTY13 = P_WQTY13, WQTY14 = P_WQTY14, WQTY15 = P_WQTY15
                   , WQTY16 = P_WQTY16, WQTY17 = P_WQTY17, WQTY18 = P_WQTY18, WQTY19 = P_WQTY19, WQTY20 = P_WQTY20
                   , WQTY21 = P_WQTY21, WQTY22 = P_WQTY22, WQTY23 = P_WQTY23, WQTY24 = P_WQTY24, WQTY25 = P_WQTY25
                   , WQTY26 = P_WQTY26, WQTY27 = P_WQTY27, WQTY28 = P_WQTY28, WQTY29 = P_WQTY29, WQTY30 = P_WQTY30
                   , WQTY31 = P_WQTY31, WQTY32 = P_WQTY32, WQTY33 = P_WQTY33, WQTY34 = P_WQTY34, WQTY35 = P_WQTY35
                   , WQTY36 = P_WQTY36, WQTY37 = P_WQTY37, WQTY38 = P_WQTY38, WQTY39 = P_WQTY39, WQTY40 = P_WQTY40
                   , WQTY41 = P_WQTY41, WQTY42 = P_WQTY42, WQTY43 = P_WQTY43, WQTY44 = P_WQTY44, WQTY45 = P_WQTY45
                   , WQTY46 = P_WQTY46, WQTY47 = P_WQTY47, WQTY48 = P_WQTY48, WQTY49 = P_WQTY49, WQTY50 = P_WQTY50
                   , WQTY51 = P_WQTY51, WQTY52 = P_WQTY52

                   , LAST_UPDATED_BY  = V_BATCH_USER
                   , LAST_UPDATE_DATE = SYSDATE
             WHERE 0 = 0
               AND DIVISION_ID          = V_BATCH_DIVISION_ID
               AND PLAN_START_YYYYMMDD  = V_BATCH_PLAN_START_YYYYMMDD
               AND CREATE_FROM_YYYYMMDD = V_BATCH_CREATE_FROM_YYYYMMDD
               AND SEQ                  = V_BATCH_SEQ
               AND XLS_KEY1             = V_BATCH_XLS_KEY1
               AND MEASURE              = V_BATCH_MEASURE;
        END IF;

        /* ----------------------------------------------------------------------------------------- */
        /*  PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - 형교환 Model Change 저장 - start */
        /* ----------------------------------------------------------------------------------------- */
        IF V_BATCH_MEASURE IN ('PACK_MODEL_CHANGE', 'CELL_MODEL_CHANGE') THEN   /*  PACK_MODEL_CHANGE, CELL_MODEL_CHANGE 만 처리함 */

            /*  MSSQL 대입형 SELECT -> 커서 FOR 루프 (0행이면 기존값 유지) */
            FOR R IN ( SELECT FROM_SITE
                            , ATTRIBUTE9
                            , PROD_LINE
                         FROM SCP_XLS_PSI_GLOBAL A
                        WHERE CREATE_FROM_YYYYMMDD = V_BATCH_CREATE_FROM_YYYYMMDD
                          AND DIVISION_ID          = V_BATCH_DIVISION_ID   /* 2022.03.23 KSW GM JV 반영 */
                          AND XLS_KEY1             = V_BATCH_XLS_KEY1
                     )
            LOOP

                V_FROM_SITE    := SUBSTR(R.FROM_SITE, 1, 12);
                V_OPERATION_ID := SUBSTR(R.ATTRIBUTE9, 1, 12);
                V_PROD_LINE    := SUBSTR(R.PROD_LINE, 1, 12);
            END LOOP;

            /*  SELECT @v_from_site, @v_operation_id, @v_prod_line */

            /*  집계 SELECT 는 항상 1행이라 SELECT INTO 로 옮긴다 */
            SELECT SUBSTR(MAX(PLAN_ID), 1, 12)
              INTO V_P_PLAN_ID
              FROM SCM_MST_SITE_ENG P
             WHERE DIVISION_ID = V_BATCH_DIVISION_ID
               AND PLAN_ID     < 9999;

            /*  SELECT @p_plan_id; */

            FOR R IN ( SELECT VERSION_ID
                         FROM SCP_PLAN_VERSION_V
                        WHERE PLAN_ID     = V_P_PLAN_ID
                          AND DIVISION_ID = V_BATCH_DIVISION_ID
                          AND PLAN_TYPE   = V_BATCH_PLAN_TYPE
                          AND PLAN_SEQ    = V_BATCH_SEQ
                     )
            LOOP
                V_VERSION_ID := SUBSTR(R.VERSION_ID, 1, 12);
            END LOOP;

            /*  시뮬레이터 data 업데이트 */
            /*  동일한 형교환을 사용하는시뮬레이터 data 업데이트 (FROM_SITE, PROD_LINE, ATTRIBUTE9(OPERATION_ID) */
            UPDATE SCP_XLS_PSI_GLOBAL
               SET
                     QTY001 = TRUNC(P_WQTY01 / 7), QTY002 = TRUNC(P_WQTY01 / 7), QTY003 = TRUNC(P_WQTY01 / 7), QTY004 = TRUNC(P_WQTY01 / 7), QTY005 = TRUNC(P_WQTY01 / 7), QTY006 = TRUNC(P_WQTY01 / 7), QTY007 = (TRUNC(P_WQTY01 / 7) + MOD(P_WQTY01, 7))
                   , QTY008 = TRUNC(P_WQTY02 / 7), QTY009 = TRUNC(P_WQTY02 / 7), QTY010 = TRUNC(P_WQTY02 / 7), QTY011 = TRUNC(P_WQTY02 / 7), QTY012 = TRUNC(P_WQTY02 / 7), QTY013 = TRUNC(P_WQTY02 / 7), QTY014 = (TRUNC(P_WQTY02 / 7) + MOD(P_WQTY02, 7))
                   , QTY015 = TRUNC(P_WQTY03 / 7), QTY016 = TRUNC(P_WQTY03 / 7), QTY017 = TRUNC(P_WQTY03 / 7), QTY018 = TRUNC(P_WQTY03 / 7), QTY019 = TRUNC(P_WQTY03 / 7), QTY020 = TRUNC(P_WQTY03 / 7), QTY021 = (TRUNC(P_WQTY03 / 7) + MOD(P_WQTY03, 7))
                   , QTY022 = TRUNC(P_WQTY04 / 7), QTY023 = TRUNC(P_WQTY04 / 7), QTY024 = TRUNC(P_WQTY04 / 7), QTY025 = TRUNC(P_WQTY04 / 7), QTY026 = TRUNC(P_WQTY04 / 7), QTY027 = TRUNC(P_WQTY04 / 7), QTY028 = (TRUNC(P_WQTY04 / 7) + MOD(P_WQTY04, 7))
                   , QTY029 = TRUNC(P_WQTY05 / 7), QTY030 = TRUNC(P_WQTY05 / 7), QTY031 = TRUNC(P_WQTY05 / 7), QTY032 = TRUNC(P_WQTY05 / 7), QTY033 = TRUNC(P_WQTY05 / 7), QTY034 = TRUNC(P_WQTY05 / 7), QTY035 = (TRUNC(P_WQTY05 / 7) + MOD(P_WQTY05, 7))
                   , QTY036 = TRUNC(P_WQTY06 / 7), QTY037 = TRUNC(P_WQTY06 / 7), QTY038 = TRUNC(P_WQTY06 / 7), QTY039 = TRUNC(P_WQTY06 / 7), QTY040 = TRUNC(P_WQTY06 / 7), QTY041 = TRUNC(P_WQTY06 / 7), QTY042 = (TRUNC(P_WQTY06 / 7) + MOD(P_WQTY06, 7))
                   , QTY043 = TRUNC(P_WQTY07 / 7), QTY044 = TRUNC(P_WQTY07 / 7), QTY045 = TRUNC(P_WQTY07 / 7), QTY046 = TRUNC(P_WQTY07 / 7), QTY047 = TRUNC(P_WQTY07 / 7), QTY048 = TRUNC(P_WQTY07 / 7), QTY049 = (TRUNC(P_WQTY07 / 7) + MOD(P_WQTY07, 7))
                   , QTY050 = TRUNC(P_WQTY08 / 7), QTY051 = TRUNC(P_WQTY08 / 7), QTY052 = TRUNC(P_WQTY08 / 7), QTY053 = TRUNC(P_WQTY08 / 7), QTY054 = TRUNC(P_WQTY08 / 7), QTY055 = TRUNC(P_WQTY08 / 7), QTY056 = (TRUNC(P_WQTY08 / 7) + MOD(P_WQTY08, 7))
                   , QTY057 = TRUNC(P_WQTY09 / 7), QTY058 = TRUNC(P_WQTY09 / 7), QTY059 = TRUNC(P_WQTY09 / 7), QTY060 = TRUNC(P_WQTY09 / 7), QTY061 = TRUNC(P_WQTY09 / 7), QTY062 = TRUNC(P_WQTY09 / 7), QTY063 = (TRUNC(P_WQTY09 / 7) + MOD(P_WQTY09, 7))
                   , QTY064 = TRUNC(P_WQTY10 / 7), QTY065 = TRUNC(P_WQTY10 / 7), QTY066 = TRUNC(P_WQTY10 / 7), QTY067 = TRUNC(P_WQTY10 / 7), QTY068 = TRUNC(P_WQTY10 / 7), QTY069 = TRUNC(P_WQTY10 / 7), QTY070 = (TRUNC(P_WQTY10 / 7) + MOD(P_WQTY10, 7))
                   , QTY071 = TRUNC(P_WQTY11 / 7), QTY072 = TRUNC(P_WQTY11 / 7), QTY073 = TRUNC(P_WQTY11 / 7), QTY074 = TRUNC(P_WQTY11 / 7), QTY075 = TRUNC(P_WQTY11 / 7), QTY076 = TRUNC(P_WQTY11 / 7), QTY077 = (TRUNC(P_WQTY11 / 7) + MOD(P_WQTY11, 7))
                   , QTY078 = TRUNC(P_WQTY12 / 7), QTY079 = TRUNC(P_WQTY12 / 7), QTY080 = TRUNC(P_WQTY12 / 7), QTY081 = TRUNC(P_WQTY12 / 7), QTY082 = TRUNC(P_WQTY12 / 7), QTY083 = TRUNC(P_WQTY12 / 7), QTY084 = (TRUNC(P_WQTY12 / 7) + MOD(P_WQTY12, 7))
                   , QTY085 = TRUNC(P_WQTY13 / 7), QTY086 = TRUNC(P_WQTY13 / 7), QTY087 = TRUNC(P_WQTY13 / 7), QTY088 = TRUNC(P_WQTY13 / 7), QTY089 = TRUNC(P_WQTY13 / 7), QTY090 = TRUNC(P_WQTY13 / 7), QTY091 = (TRUNC(P_WQTY13 / 7) + MOD(P_WQTY13, 7))
                   , QTY092 = TRUNC(P_WQTY14 / 7), QTY093 = TRUNC(P_WQTY14 / 7), QTY094 = TRUNC(P_WQTY14 / 7), QTY095 = TRUNC(P_WQTY14 / 7), QTY096 = TRUNC(P_WQTY14 / 7), QTY097 = TRUNC(P_WQTY14 / 7), QTY098 = (TRUNC(P_WQTY14 / 7) + MOD(P_WQTY14, 7))
                   , QTY099 = TRUNC(P_WQTY15 / 7), QTY100 = TRUNC(P_WQTY15 / 7), QTY101 = TRUNC(P_WQTY15 / 7), QTY102 = TRUNC(P_WQTY15 / 7), QTY103 = TRUNC(P_WQTY15 / 7), QTY104 = TRUNC(P_WQTY15 / 7), QTY105 = (TRUNC(P_WQTY15 / 7) + MOD(P_WQTY15, 7))
                   , QTY106 = TRUNC(P_WQTY16 / 7), QTY107 = TRUNC(P_WQTY16 / 7), QTY108 = TRUNC(P_WQTY16 / 7), QTY109 = TRUNC(P_WQTY16 / 7), QTY110 = TRUNC(P_WQTY16 / 7), QTY111 = TRUNC(P_WQTY16 / 7), QTY112 = (TRUNC(P_WQTY16 / 7) + MOD(P_WQTY16, 7))
                   , QTY113 = TRUNC(P_WQTY17 / 7), QTY114 = TRUNC(P_WQTY17 / 7), QTY115 = TRUNC(P_WQTY17 / 7), QTY116 = TRUNC(P_WQTY17 / 7), QTY117 = TRUNC(P_WQTY17 / 7), QTY118 = TRUNC(P_WQTY17 / 7), QTY119 = (TRUNC(P_WQTY17 / 7) + MOD(P_WQTY17, 7))
                   , QTY120 = TRUNC(P_WQTY18 / 7), QTY121 = TRUNC(P_WQTY18 / 7), QTY122 = TRUNC(P_WQTY18 / 7), QTY123 = TRUNC(P_WQTY18 / 7), QTY124 = TRUNC(P_WQTY18 / 7), QTY125 = TRUNC(P_WQTY18 / 7), QTY126 = (TRUNC(P_WQTY18 / 7) + MOD(P_WQTY18, 7))
                   , QTY127 = TRUNC(P_WQTY19 / 7), QTY128 = TRUNC(P_WQTY19 / 7), QTY129 = TRUNC(P_WQTY19 / 7), QTY130 = TRUNC(P_WQTY19 / 7), QTY131 = TRUNC(P_WQTY19 / 7), QTY132 = TRUNC(P_WQTY19 / 7), QTY133 = (TRUNC(P_WQTY19 / 7) + MOD(P_WQTY19, 7))
                   , QTY134 = TRUNC(P_WQTY20 / 7), QTY135 = TRUNC(P_WQTY20 / 7), QTY136 = TRUNC(P_WQTY20 / 7), QTY137 = TRUNC(P_WQTY20 / 7), QTY138 = TRUNC(P_WQTY20 / 7), QTY139 = TRUNC(P_WQTY20 / 7), QTY140 = (TRUNC(P_WQTY20 / 7) + MOD(P_WQTY20, 7))
                   , QTY141 = TRUNC(P_WQTY21 / 7), QTY142 = TRUNC(P_WQTY21 / 7), QTY143 = TRUNC(P_WQTY21 / 7), QTY144 = TRUNC(P_WQTY21 / 7), QTY145 = TRUNC(P_WQTY21 / 7), QTY146 = TRUNC(P_WQTY21 / 7), QTY147 = (TRUNC(P_WQTY21 / 7) + MOD(P_WQTY21, 7))
                   , QTY148 = TRUNC(P_WQTY22 / 7), QTY149 = TRUNC(P_WQTY22 / 7), QTY150 = TRUNC(P_WQTY22 / 7), QTY151 = TRUNC(P_WQTY22 / 7), QTY152 = TRUNC(P_WQTY22 / 7), QTY153 = TRUNC(P_WQTY22 / 7), QTY154 = (TRUNC(P_WQTY22 / 7) + MOD(P_WQTY22, 7))
                   , QTY155 = TRUNC(P_WQTY23 / 7), QTY156 = TRUNC(P_WQTY23 / 7), QTY157 = TRUNC(P_WQTY23 / 7), QTY158 = TRUNC(P_WQTY23 / 7), QTY159 = TRUNC(P_WQTY23 / 7), QTY160 = TRUNC(P_WQTY23 / 7), QTY161 = (TRUNC(P_WQTY23 / 7) + MOD(P_WQTY23, 7))
                   , QTY162 = TRUNC(P_WQTY24 / 7), QTY163 = TRUNC(P_WQTY24 / 7), QTY164 = TRUNC(P_WQTY24 / 7), QTY165 = TRUNC(P_WQTY24 / 7), QTY166 = TRUNC(P_WQTY24 / 7), QTY167 = TRUNC(P_WQTY24 / 7), QTY168 = (TRUNC(P_WQTY24 / 7) + MOD(P_WQTY24, 7))
                   , QTY169 = TRUNC(P_WQTY25 / 7), QTY170 = TRUNC(P_WQTY25 / 7), QTY171 = TRUNC(P_WQTY25 / 7), QTY172 = TRUNC(P_WQTY25 / 7), QTY173 = TRUNC(P_WQTY25 / 7), QTY174 = TRUNC(P_WQTY25 / 7), QTY175 = (TRUNC(P_WQTY25 / 7) + MOD(P_WQTY25, 7))
                   , QTY176 = TRUNC(P_WQTY26 / 7), QTY177 = TRUNC(P_WQTY26 / 7), QTY178 = TRUNC(P_WQTY26 / 7), QTY179 = TRUNC(P_WQTY26 / 7), QTY180 = TRUNC(P_WQTY26 / 7), QTY181 = TRUNC(P_WQTY26 / 7), QTY182 = (TRUNC(P_WQTY26 / 7) + MOD(P_WQTY26, 7))
                   , QTY183 = TRUNC(P_WQTY27 / 7), QTY184 = TRUNC(P_WQTY27 / 7), QTY185 = TRUNC(P_WQTY27 / 7), QTY186 = TRUNC(P_WQTY27 / 7), QTY187 = TRUNC(P_WQTY27 / 7), QTY188 = TRUNC(P_WQTY27 / 7), QTY189 = (TRUNC(P_WQTY27 / 7) + MOD(P_WQTY27, 7))
                   , QTY190 = TRUNC(P_WQTY28 / 7), QTY191 = TRUNC(P_WQTY28 / 7), QTY192 = TRUNC(P_WQTY28 / 7), QTY193 = TRUNC(P_WQTY28 / 7), QTY194 = TRUNC(P_WQTY28 / 7), QTY195 = TRUNC(P_WQTY28 / 7), QTY196 = (TRUNC(P_WQTY28 / 7) + MOD(P_WQTY28, 7))
                   , QTY197 = TRUNC(P_WQTY29 / 7), QTY198 = TRUNC(P_WQTY29 / 7), QTY199 = TRUNC(P_WQTY29 / 7), QTY200 = TRUNC(P_WQTY29 / 7), QTY201 = TRUNC(P_WQTY29 / 7), QTY202 = TRUNC(P_WQTY29 / 7), QTY203 = (TRUNC(P_WQTY29 / 7) + MOD(P_WQTY29, 7))
                   , QTY204 = TRUNC(P_WQTY30 / 7), QTY205 = TRUNC(P_WQTY30 / 7), QTY206 = TRUNC(P_WQTY30 / 7), QTY207 = TRUNC(P_WQTY30 / 7), QTY208 = TRUNC(P_WQTY30 / 7), QTY209 = TRUNC(P_WQTY30 / 7), QTY210 = (TRUNC(P_WQTY30 / 7) + MOD(P_WQTY30, 7))
                   , QTY211 = TRUNC(P_WQTY31 / 7), QTY212 = TRUNC(P_WQTY31 / 7), QTY213 = TRUNC(P_WQTY31 / 7), QTY214 = TRUNC(P_WQTY31 / 7), QTY215 = TRUNC(P_WQTY31 / 7), QTY216 = TRUNC(P_WQTY31 / 7), QTY217 = (TRUNC(P_WQTY31 / 7) + MOD(P_WQTY31, 7))
                   , QTY218 = TRUNC(P_WQTY32 / 7), QTY219 = TRUNC(P_WQTY32 / 7), QTY220 = TRUNC(P_WQTY32 / 7), QTY221 = TRUNC(P_WQTY32 / 7), QTY222 = TRUNC(P_WQTY32 / 7), QTY223 = TRUNC(P_WQTY32 / 7), QTY224 = (TRUNC(P_WQTY32 / 7) + MOD(P_WQTY32, 7))
                   , QTY225 = TRUNC(P_WQTY33 / 7), QTY226 = TRUNC(P_WQTY33 / 7), QTY227 = TRUNC(P_WQTY33 / 7), QTY228 = TRUNC(P_WQTY33 / 7), QTY229 = TRUNC(P_WQTY33 / 7), QTY230 = TRUNC(P_WQTY33 / 7), QTY231 = (TRUNC(P_WQTY33 / 7) + MOD(P_WQTY33, 7))
                   , QTY232 = TRUNC(P_WQTY34 / 7), QTY233 = TRUNC(P_WQTY34 / 7), QTY234 = TRUNC(P_WQTY34 / 7), QTY235 = TRUNC(P_WQTY34 / 7), QTY236 = TRUNC(P_WQTY34 / 7), QTY237 = TRUNC(P_WQTY34 / 7), QTY238 = (TRUNC(P_WQTY34 / 7) + MOD(P_WQTY34, 7))
                   , QTY239 = TRUNC(P_WQTY35 / 7), QTY240 = TRUNC(P_WQTY35 / 7), QTY241 = TRUNC(P_WQTY35 / 7), QTY242 = TRUNC(P_WQTY35 / 7), QTY243 = TRUNC(P_WQTY35 / 7), QTY244 = TRUNC(P_WQTY35 / 7), QTY245 = (TRUNC(P_WQTY35 / 7) + MOD(P_WQTY35, 7))
                   , QTY246 = TRUNC(P_WQTY36 / 7), QTY247 = TRUNC(P_WQTY36 / 7), QTY248 = TRUNC(P_WQTY36 / 7), QTY249 = TRUNC(P_WQTY36 / 7), QTY250 = TRUNC(P_WQTY36 / 7), QTY251 = TRUNC(P_WQTY36 / 7), QTY252 = (TRUNC(P_WQTY36 / 7) + MOD(P_WQTY36, 7))
                   , QTY253 = TRUNC(P_WQTY37 / 7), QTY254 = TRUNC(P_WQTY37 / 7), QTY255 = TRUNC(P_WQTY37 / 7), QTY256 = TRUNC(P_WQTY37 / 7), QTY257 = TRUNC(P_WQTY37 / 7), QTY258 = TRUNC(P_WQTY37 / 7), QTY259 = (TRUNC(P_WQTY37 / 7) + MOD(P_WQTY37, 7))
                   , QTY260 = TRUNC(P_WQTY38 / 7), QTY261 = TRUNC(P_WQTY38 / 7), QTY262 = TRUNC(P_WQTY38 / 7), QTY263 = TRUNC(P_WQTY38 / 7), QTY264 = TRUNC(P_WQTY38 / 7), QTY265 = TRUNC(P_WQTY38 / 7), QTY266 = (TRUNC(P_WQTY38 / 7) + MOD(P_WQTY38, 7))
                   , QTY267 = TRUNC(P_WQTY39 / 7), QTY268 = TRUNC(P_WQTY39 / 7), QTY269 = TRUNC(P_WQTY39 / 7), QTY270 = TRUNC(P_WQTY39 / 7), QTY271 = TRUNC(P_WQTY39 / 7), QTY272 = TRUNC(P_WQTY39 / 7), QTY273 = (TRUNC(P_WQTY39 / 7) + MOD(P_WQTY39, 7))
                   , QTY274 = TRUNC(P_WQTY40 / 7), QTY275 = TRUNC(P_WQTY40 / 7), QTY276 = TRUNC(P_WQTY40 / 7), QTY277 = TRUNC(P_WQTY40 / 7), QTY278 = TRUNC(P_WQTY40 / 7), QTY279 = TRUNC(P_WQTY40 / 7), QTY280 = (TRUNC(P_WQTY40 / 7) + MOD(P_WQTY40, 7))
                   , QTY281 = TRUNC(P_WQTY41 / 7), QTY282 = TRUNC(P_WQTY41 / 7), QTY283 = TRUNC(P_WQTY41 / 7), QTY284 = TRUNC(P_WQTY41 / 7), QTY285 = TRUNC(P_WQTY41 / 7), QTY286 = TRUNC(P_WQTY41 / 7), QTY287 = (TRUNC(P_WQTY41 / 7) + MOD(P_WQTY41, 7))
                   , QTY288 = TRUNC(P_WQTY42 / 7), QTY289 = TRUNC(P_WQTY42 / 7), QTY290 = TRUNC(P_WQTY42 / 7), QTY291 = TRUNC(P_WQTY42 / 7), QTY292 = TRUNC(P_WQTY42 / 7), QTY293 = TRUNC(P_WQTY42 / 7), QTY294 = (TRUNC(P_WQTY42 / 7) + MOD(P_WQTY42, 7))
                   , QTY295 = TRUNC(P_WQTY43 / 7), QTY296 = TRUNC(P_WQTY43 / 7), QTY297 = TRUNC(P_WQTY43 / 7), QTY298 = TRUNC(P_WQTY43 / 7), QTY299 = TRUNC(P_WQTY43 / 7), QTY300 = TRUNC(P_WQTY43 / 7), QTY301 = (TRUNC(P_WQTY43 / 7) + MOD(P_WQTY43, 7))
                   , QTY302 = TRUNC(P_WQTY44 / 7), QTY303 = TRUNC(P_WQTY44 / 7), QTY304 = TRUNC(P_WQTY44 / 7), QTY305 = TRUNC(P_WQTY44 / 7), QTY306 = TRUNC(P_WQTY44 / 7), QTY307 = TRUNC(P_WQTY44 / 7), QTY308 = (TRUNC(P_WQTY44 / 7) + MOD(P_WQTY44, 7))
                   , QTY309 = TRUNC(P_WQTY45 / 7), QTY310 = TRUNC(P_WQTY45 / 7), QTY311 = TRUNC(P_WQTY45 / 7), QTY312 = TRUNC(P_WQTY45 / 7), QTY313 = TRUNC(P_WQTY45 / 7), QTY314 = TRUNC(P_WQTY45 / 7), QTY315 = (TRUNC(P_WQTY45 / 7) + MOD(P_WQTY45, 7))
                   , QTY316 = TRUNC(P_WQTY46 / 7), QTY317 = TRUNC(P_WQTY46 / 7), QTY318 = TRUNC(P_WQTY46 / 7), QTY319 = TRUNC(P_WQTY46 / 7), QTY320 = TRUNC(P_WQTY46 / 7), QTY321 = TRUNC(P_WQTY46 / 7), QTY322 = (TRUNC(P_WQTY46 / 7) + MOD(P_WQTY46, 7))
                   , QTY323 = TRUNC(P_WQTY47 / 7), QTY324 = TRUNC(P_WQTY47 / 7), QTY325 = TRUNC(P_WQTY47 / 7), QTY326 = TRUNC(P_WQTY47 / 7), QTY327 = TRUNC(P_WQTY47 / 7), QTY328 = TRUNC(P_WQTY47 / 7), QTY329 = (TRUNC(P_WQTY47 / 7) + MOD(P_WQTY47, 7))
                   , QTY330 = TRUNC(P_WQTY48 / 7), QTY331 = TRUNC(P_WQTY48 / 7), QTY332 = TRUNC(P_WQTY48 / 7), QTY333 = TRUNC(P_WQTY48 / 7), QTY334 = TRUNC(P_WQTY48 / 7), QTY335 = TRUNC(P_WQTY48 / 7), QTY336 = (TRUNC(P_WQTY48 / 7) + MOD(P_WQTY48, 7))
                   , QTY337 = TRUNC(P_WQTY49 / 7), QTY338 = TRUNC(P_WQTY49 / 7), QTY339 = TRUNC(P_WQTY49 / 7), QTY340 = TRUNC(P_WQTY49 / 7), QTY341 = TRUNC(P_WQTY49 / 7), QTY342 = TRUNC(P_WQTY49 / 7), QTY343 = (TRUNC(P_WQTY49 / 7) + MOD(P_WQTY49, 7))
                   , QTY344 = TRUNC(P_WQTY50 / 7), QTY345 = TRUNC(P_WQTY50 / 7), QTY346 = TRUNC(P_WQTY50 / 7), QTY347 = TRUNC(P_WQTY50 / 7), QTY348 = TRUNC(P_WQTY50 / 7), QTY349 = TRUNC(P_WQTY50 / 7), QTY350 = (TRUNC(P_WQTY50 / 7) + MOD(P_WQTY50, 7))
                   , QTY351 = TRUNC(P_WQTY51 / 7), QTY352 = TRUNC(P_WQTY51 / 7), QTY353 = TRUNC(P_WQTY51 / 7), QTY354 = TRUNC(P_WQTY51 / 7), QTY355 = TRUNC(P_WQTY51 / 7), QTY356 = TRUNC(P_WQTY51 / 7), QTY357 = (TRUNC(P_WQTY51 / 7) + MOD(P_WQTY51, 7))
                   , QTY358 = TRUNC(P_WQTY52 / 7), QTY359 = TRUNC(P_WQTY52 / 7), QTY360 = TRUNC(P_WQTY52 / 7), QTY361 = TRUNC(P_WQTY52 / 7), QTY362 = TRUNC(P_WQTY52 / 7), QTY363 = TRUNC(P_WQTY52 / 7), QTY364 = (TRUNC(P_WQTY52 / 7) + MOD(P_WQTY52, 7))

                   , WQTY01 = P_WQTY01, WQTY02 = P_WQTY02, WQTY03 = P_WQTY03, WQTY04 = P_WQTY04, WQTY05 = P_WQTY05
                   , WQTY06 = P_WQTY06, WQTY07 = P_WQTY07, WQTY08 = P_WQTY08, WQTY09 = P_WQTY09, WQTY10 = P_WQTY10
                   , WQTY11 = P_WQTY11, WQTY12 = P_WQTY12, WQTY13 = P_WQTY13, WQTY14 = P_WQTY14, WQTY15 = P_WQTY15
                   , WQTY16 = P_WQTY16, WQTY17 = P_WQTY17, WQTY18 = P_WQTY18, WQTY19 = P_WQTY19, WQTY20 = P_WQTY20
                   , WQTY21 = P_WQTY21, WQTY22 = P_WQTY22, WQTY23 = P_WQTY23, WQTY24 = P_WQTY24, WQTY25 = P_WQTY25
                   , WQTY26 = P_WQTY26, WQTY27 = P_WQTY27, WQTY28 = P_WQTY28, WQTY29 = P_WQTY29, WQTY30 = P_WQTY30
                   , WQTY31 = P_WQTY31, WQTY32 = P_WQTY32, WQTY33 = P_WQTY33, WQTY34 = P_WQTY34, WQTY35 = P_WQTY35
                   , WQTY36 = P_WQTY36, WQTY37 = P_WQTY37, WQTY38 = P_WQTY38, WQTY39 = P_WQTY39, WQTY40 = P_WQTY40
                   , WQTY41 = P_WQTY41, WQTY42 = P_WQTY42, WQTY43 = P_WQTY43, WQTY44 = P_WQTY44, WQTY45 = P_WQTY45
                   , WQTY46 = P_WQTY46, WQTY47 = P_WQTY47, WQTY48 = P_WQTY48, WQTY49 = P_WQTY49, WQTY50 = P_WQTY50
                   , WQTY51 = P_WQTY51, WQTY52 = P_WQTY52

                   , LAST_UPDATED_BY  = V_BATCH_USER
                   , LAST_UPDATE_DATE = SYSDATE
             WHERE 0 = 0
               AND DIVISION_ID          = V_BATCH_DIVISION_ID
               AND PLAN_START_YYYYMMDD  = V_BATCH_PLAN_START_YYYYMMDD
               AND CREATE_FROM_YYYYMMDD = V_BATCH_CREATE_FROM_YYYYMMDD
               AND SEQ                  = V_BATCH_SEQ
               AND MEASURE              = V_BATCH_MEASURE
               AND FROM_SITE            = V_FROM_SITE
               AND PROD_LINE            = V_PROD_LINE
               AND ATTRIBUTE9           = V_OPERATION_ID;

            /*  형교환(Model Change) 정보를 capa 테이블에 저장하기 위해서 임시테이블 생성 (un pivot) */
            /*  IF OBJECT_ID('tempdb..#SCM_WORK_CALENDAR_M') IS NOT NULL DROP TABLE #SCM_WORK_CALENDAR_M
                -> ★계열 명명표에 없던 신규 임시테이블이다. PR_SCP_XLS_* 44개 전수 스캔 결과 이 객체 단독 사용이라 */
            DELETE FROM GT_XPGT_SCM_WORK_CALENDAR_M;

            INSERT INTO GT_XPGT_SCM_WORK_CALENDAR_M
                 ( VERSION_ID
                 , COMPANY_ID
                 , DIVISION_ID
                 , SITE_ID
                 , PLANT_ID
                 , FACTORY_ID
                 , OPERATION_ID
                 , LINE_ID
                 , ELECTRODE_TYPE
                 , WORK_DATE
                 , LOSS_CODE
                 , TIME_TERM
                 , TIME_TERM_RESULT )
            SELECT V_VERSION_ID AS VERSION_ID
                 , X.COMPANY_ID
                 , X.DIVISION_ID
                 , X.SITE_ID
                 , X.PLANT_ID
                 , X.FACTORY_ID
                 , X.ATTRIBUTE9 AS OPERATION_ID
                 , X.PROD_LINE  AS LINE_ID
                 , '-'          AS ELECTRODE_TYPE
                 , Y.YYYYMMDD   AS WORK_DATE
                 , 'XC031'      AS LOSS_CODE
                 , X.QTY        AS TIME_TERM
                 , 0.0          AS TIME_TERM_RESULT
              FROM
                 (
                  SELECT A.*   /*  SCP_XLS_PSI_GLOBAL 전 컬럼 (QTY001~364 포함 - UNPIVOT 대상) */
                       , B.COMPANY_ID
                       , B.SITE_ID
                       , B.PLANT_ID
                       , C.FACTORY_ID
                    FROM SCP_XLS_PSI_GLOBAL A
                         /*  MSSQL SELECT TOP 1 -> Oracle ROWNUM = 1 (원본에 ORDER BY 가 없으므로 추가하지 않는다) */
                       , ( SELECT COMPANY_ID, SITE_ID, PLANT_ID
                             FROM SCM_MST_SITE_ENG B
                            WHERE B.DIVISION_ID = V_BATCH_DIVISION_ID
                              AND B.PLAN_ID     = V_P_PLAN_ID
                              AND B.PLAN_SEQ    = V_BATCH_SEQ
                              AND B.SCM_SITE_ID = V_FROM_SITE
                              AND ROWNUM        = 1 ) B
                       , ( SELECT FACTORY_ID
                             FROM SCP_MST_WORKING_TIME
                            WHERE DIVISION_ID   = V_BATCH_DIVISION_ID
                              AND PLANT_SITE_ID = V_FROM_SITE
                              AND OPERATION_ID  = V_OPERATION_ID
                              AND LINE_ID       = V_PROD_LINE
                              AND ROWNUM        = 1 ) C
                   WHERE 0 = 0
                     AND A.DIVISION_ID          = V_BATCH_DIVISION_ID
                     AND A.PLAN_START_YYYYMMDD  = V_BATCH_PLAN_START_YYYYMMDD
                     AND A.CREATE_FROM_YYYYMMDD = V_BATCH_CREATE_FROM_YYYYMMDD
                     AND A.SEQ                  = V_BATCH_SEQ
                     AND A.XLS_KEY1             = V_BATCH_XLS_KEY1   /* 43 */
                 )
                 UNPIVOT
                 (
                  QTY FOR YYYYMMDD_COLUMN IN (
                                  QTY001, QTY002, QTY003, QTY004, QTY005, QTY006, QTY007, QTY008, QTY009, QTY010
                                , QTY011, QTY012, QTY013, QTY014, QTY015, QTY016, QTY017, QTY018, QTY019, QTY020
                                , QTY021, QTY022, QTY023, QTY024, QTY025, QTY026, QTY027, QTY028, QTY029, QTY030
                                , QTY031, QTY032, QTY033, QTY034, QTY035, QTY036, QTY037, QTY038, QTY039, QTY040
                                , QTY041, QTY042, QTY043, QTY044, QTY045, QTY046, QTY047, QTY048, QTY049, QTY050
                                , QTY051, QTY052, QTY053, QTY054, QTY055, QTY056, QTY057, QTY058, QTY059, QTY060
                                , QTY061, QTY062, QTY063, QTY064, QTY065, QTY066, QTY067, QTY068, QTY069, QTY070
                                , QTY071, QTY072, QTY073, QTY074, QTY075, QTY076, QTY077, QTY078, QTY079, QTY080
                                , QTY081, QTY082, QTY083, QTY084, QTY085, QTY086, QTY087, QTY088, QTY089, QTY090
                                , QTY091, QTY092, QTY093, QTY094, QTY095, QTY096, QTY097, QTY098, QTY099, QTY100
                                , QTY101, QTY102, QTY103, QTY104, QTY105, QTY106, QTY107, QTY108, QTY109, QTY110
                                , QTY111, QTY112, QTY113, QTY114, QTY115, QTY116, QTY117, QTY118, QTY119, QTY120
                                , QTY121, QTY122, QTY123, QTY124, QTY125, QTY126, QTY127, QTY128, QTY129, QTY130
                                , QTY131, QTY132, QTY133, QTY134, QTY135, QTY136, QTY137, QTY138, QTY139, QTY140
                                , QTY141, QTY142, QTY143, QTY144, QTY145, QTY146, QTY147, QTY148, QTY149, QTY150
                                , QTY151, QTY152, QTY153, QTY154, QTY155, QTY156, QTY157, QTY158, QTY159, QTY160
                                , QTY161, QTY162, QTY163, QTY164, QTY165, QTY166, QTY167, QTY168, QTY169, QTY170
                                , QTY171, QTY172, QTY173, QTY174, QTY175, QTY176, QTY177, QTY178, QTY179, QTY180
                                , QTY181, QTY182, QTY183, QTY184, QTY185, QTY186, QTY187, QTY188, QTY189, QTY190
                                , QTY191, QTY192, QTY193, QTY194, QTY195, QTY196, QTY197, QTY198, QTY199, QTY200
                                , QTY201, QTY202, QTY203, QTY204, QTY205, QTY206, QTY207, QTY208, QTY209, QTY210
                                , QTY211, QTY212, QTY213, QTY214, QTY215, QTY216, QTY217, QTY218, QTY219, QTY220
                                , QTY221, QTY222, QTY223, QTY224, QTY225, QTY226, QTY227, QTY228, QTY229, QTY230
                                , QTY231, QTY232, QTY233, QTY234, QTY235, QTY236, QTY237, QTY238, QTY239, QTY240
                                , QTY241, QTY242, QTY243, QTY244, QTY245, QTY246, QTY247, QTY248, QTY249, QTY250
                                , QTY251, QTY252, QTY253, QTY254, QTY255, QTY256, QTY257, QTY258, QTY259, QTY260
                                , QTY261, QTY262, QTY263, QTY264, QTY265, QTY266, QTY267, QTY268, QTY269, QTY270
                                , QTY271, QTY272, QTY273, QTY274, QTY275, QTY276, QTY277, QTY278, QTY279, QTY280
                                , QTY281, QTY282, QTY283, QTY284, QTY285, QTY286, QTY287, QTY288, QTY289, QTY290
                                , QTY291, QTY292, QTY293, QTY294, QTY295, QTY296, QTY297, QTY298, QTY299, QTY300
                                , QTY301, QTY302, QTY303, QTY304, QTY305, QTY306, QTY307, QTY308, QTY309, QTY310
                                , QTY311, QTY312, QTY313, QTY314, QTY315, QTY316, QTY317, QTY318, QTY319, QTY320
                                , QTY321, QTY322, QTY323, QTY324, QTY325, QTY326, QTY327, QTY328, QTY329, QTY330
                                , QTY331, QTY332, QTY333, QTY334, QTY335, QTY336, QTY337, QTY338, QTY339, QTY340
                                , QTY341, QTY342, QTY343, QTY344, QTY345, QTY346, QTY347, QTY348, QTY349, QTY350
                                , QTY351, QTY352, QTY353, QTY354, QTY355, QTY356, QTY357, QTY358, QTY359, QTY360
                                , QTY361, QTY362, QTY363, QTY364
                     )
                 ) X
               , ( SELECT A.BASIS_YYYYMMDD AS YYYYMMDD
                                   /*  MSSQL 'QTY' + REPLICATE('0', 3 - LEN(ROW_NUMBER() OVER(..))) + CONVERT(NVARCHAR, ROW_NUMBER() OVER(..)) */
                                   , 'QTY' || LPAD(TO_CHAR(ROW_NUMBER() OVER(ORDER BY A.BASIS_YYYYMMDD)), 3, '0') AS YYYYMMDD_COLUMN
                                FROM SCM_SYS_CALENDAR_M A
                               WHERE A.BASIS_YYYYMMDD BETWEEN V_BATCH_CREATE_FROM_YYYYMMDD
                                                          AND TO_CHAR(TO_DATE(V_BATCH_CREATE_FROM_YYYYMMDD, 'YYYYMMDD') + 364, 'YYYYMMDD')
                                 /*  WHERE A.BASIS_YYYYMMDD >= @v_batch_create_from_yyyymmdd
                                       AND A.BASIS_YYYYMMDD <  @v_batch_create_to_yyyymmdd */
                            ) Y
             WHERE X.YYYYMMDD_COLUMN = Y.YYYYMMDD_COLUMN;

            /*  current 정보 저장
                  원천 GTT 는 (XLS_KEY1 1행) x (WORK_DATE 365일) 이라 ON 키당 1행이므로 ORA-30926 도 없다. */
            MERGE INTO SCM_WORK_CALENDAR_M_SN X
            USING ( SELECT COMPANY_ID
                         , DIVISION_ID
                         , SITE_ID
                         , PLANT_ID
                         , FACTORY_ID
                         , OPERATION_ID
                         , LINE_ID
                         , ELECTRODE_TYPE
                         , WORK_DATE
                         , LOSS_CODE
                         , TIME_TERM
                         , TIME_TERM_RESULT
                      FROM GT_XPGT_SCM_WORK_CALENDAR_M
                  ) Y
               ON ( 0 = 0
                    AND X.DIVISION_ID   = Y.DIVISION_ID
                    AND X.SITE_ID       = Y.SITE_ID
                    AND X.PLANT_ID      = Y.PLANT_ID
                    AND X.OPERATION_ID  = Y.OPERATION_ID
                    AND X.LINE_ID       = Y.LINE_ID
                    /*  MSSQL convert(datetime, Y.WORK_DATE) -> TO_DATE(Y.WORK_DATE, 'YYYYMMDD') */
                    AND X.WORK_DATE     = TO_DATE(Y.WORK_DATE, 'YYYYMMDD')
                    AND X.LOSS_CODE     = Y.LOSS_CODE
                    AND X.COMPANY_ID    = Y.COMPANY_ID )
            WHEN MATCHED THEN
            UPDATE
               SET X.TIME_TERM   = Y.TIME_TERM
                 , X.UPDATE_ID   = V_BATCH_USER
                 , X.UPDATE_TIME = SYSDATE
            WHEN NOT MATCHED THEN
            INSERT ( COMPANY_ID
                   , DIVISION_ID
                   , SITE_ID
                   , PLANT_ID
                   , FACTORY_ID
                   , OPERATION_ID
                   , LINE_ID
                   , ELECTRODE_TYPE
                   , WORK_DATE
                   , LOSS_CODE
                   , TIME_TERM
                   , TIME_TERM_RESULT
                   , INSERT_ID
                   , INSERT_TIME
                   , UPDATE_ID
                   , UPDATE_TIME )
            VALUES ( Y.COMPANY_ID
                   , Y.DIVISION_ID
                   , Y.SITE_ID
                   , Y.PLANT_ID
                   , Y.FACTORY_ID
                   , Y.OPERATION_ID
                   , Y.LINE_ID
                   , Y.ELECTRODE_TYPE
                   /*  적재처 SCM_WORK_CALENDAR_M.WORK_DATE 는 DATE 다 -> TO_DATE (원본 INSERT 는 묵시변환) */
                   , TO_DATE(Y.WORK_DATE, 'YYYYMMDD')
                   , Y.LOSS_CODE
                   , Y.TIME_TERM
                   , Y.TIME_TERM_RESULT
                   , V_BATCH_USER
                   , SYSDATE
                   , V_BATCH_USER
                   , SYSDATE );

        END IF;
        /*  PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - 형교환 Model Change 저장 - end */

        /* ----------------------------------------------------------------------------------------- */
        /*  SOURCE TABLE 반영 */
        /* ----------------------------------------------------------------------------------------- */

        /*  UI 작업자와 시물레이션 작업자를 구분하기 위해서 */
        V_BATCH_USER_SIM := CASE WHEN V_BATCH_USER IS NULL THEN NULL
                                 ELSE SUBSTR(V_BATCH_USER || '[SIMULATION]', 1, 150) END;

        /* ----------------------------------------------------------------------------------------- */
        /*  SCP_ANL_SHIPMENT_PLAN_FG UPDATE */
        /*  SHIP_PLAN  --> SCP_ANL_SHIPMENT_PLAN_FG.MEASURE 'SHIP_PLAN_AMEND' UPDATE */
        /* ----------------------------------------------------------------------------------------- */
        IF V_BATCH_MEASURE IN ('SHIP_PLAN') THEN   /* FG */

            /*  SHIP_PLAN */
            /*  IF OBJECT_ID('tempdb..#SCP_ANL_SHIPMENT_PLAN_FG') IS NOT NULL DROP TABLE #SCP_ANL_SHIPMENT_PLAN_FG */
            DELETE FROM GT_XPGT_SCP_ANL_SHIPMENT_PLAN_FG;

            INSERT INTO GT_XPGT_SCP_ANL_SHIPMENT_PLAN_FG
                 ( DIVISION_ID
                 , PLAN_START_YYYYMMDD
                 , PLAN_TYPE
                 , SEQ
                 , BIZ_TYPE
                 , PROJECT_CODE
                 , ITEM_ID
                 , TO_SITE
                 , INCOTERMS
                 , FROM_SITE
                 , BOD_ID
                 , TRANSPORT_MODE
                 , MEASURE
                 , YYYYMMDD
                 , QTY
                 , ORIGIN_FROM_DIVISION_ID
                 , ORIGIN_TO_DIVISION_ID
                 , ELECTRODE_TYPE
                 , ATTRIBUTE1
                 , YYYYMMDD_COLUMN )
            SELECT X.DIVISION_ID
                 , X.PLAN_START_YYYYMMDD
                 , X.PLAN_TYPE
                 , X.SEQ
                 , X.OPERATION_GROUP AS BIZ_TYPE
                 , X.PROJECT_CODE
                 /*  , X.CELL_ITEM_ID */
                 , X.ITEM_ID
                 , X.TO_SITE
                 , X.INCOTERMS
                 , X.FROM_SITE
                 , X.BOD_ID
                 , X.TRANSPORT_MODE
                 , 'SHIP_PLAN_AMEND' AS MEASURE
                 , Y.YYYYMMDD AS YYYYMMDD
                 , X.QTY
                 , V_BATCH_DIVISION_ID AS ORIGIN_FROM_DIVISION_ID   /* 2022.03.21 :: GM JV 반영 '81' --> @v_batch_division_id */
                 , V_BATCH_DIVISION_ID AS ORIGIN_TO_DIVISION_ID     /* 2022.03.21 :: GM JV 반영 '81' --> @v_batch_division_id */
                 , '' AS ELECTRODE_TYPE
                 , X.ATTRIBUTE1
                 , Y.YYYYMMDD_COLUMN
              /*  FROM #DAY_SCP_XLS_PSI_GLOBAL SourceTable WITH (NOLOCK) */
              FROM SCP_XLS_PSI_GLOBAL
                   UNPIVOT
                   (
                    QTY FOR YYYYMMDD_COLUMN IN (
                            QTY001, QTY002, QTY003, QTY004, QTY005, QTY006, QTY007, QTY008, QTY009, QTY010
                          , QTY011, QTY012, QTY013, QTY014, QTY015, QTY016, QTY017, QTY018, QTY019, QTY020
                          , QTY021, QTY022, QTY023, QTY024, QTY025, QTY026, QTY027, QTY028, QTY029, QTY030
                          , QTY031, QTY032, QTY033, QTY034, QTY035, QTY036, QTY037, QTY038, QTY039, QTY040
                          , QTY041, QTY042, QTY043, QTY044, QTY045, QTY046, QTY047, QTY048, QTY049, QTY050
                          , QTY051, QTY052, QTY053, QTY054, QTY055, QTY056, QTY057, QTY058, QTY059, QTY060
                          , QTY061, QTY062, QTY063, QTY064, QTY065, QTY066, QTY067, QTY068, QTY069, QTY070
                          , QTY071, QTY072, QTY073, QTY074, QTY075, QTY076, QTY077, QTY078, QTY079, QTY080
                          , QTY081, QTY082, QTY083, QTY084, QTY085, QTY086, QTY087, QTY088, QTY089, QTY090
                          , QTY091, QTY092, QTY093, QTY094, QTY095, QTY096, QTY097, QTY098, QTY099, QTY100
                          , QTY101, QTY102, QTY103, QTY104, QTY105, QTY106, QTY107, QTY108, QTY109, QTY110
                          , QTY111, QTY112, QTY113, QTY114, QTY115, QTY116, QTY117, QTY118, QTY119, QTY120
                          , QTY121, QTY122, QTY123, QTY124, QTY125, QTY126, QTY127, QTY128, QTY129, QTY130
                          , QTY131, QTY132, QTY133, QTY134, QTY135, QTY136, QTY137, QTY138, QTY139, QTY140
                          , QTY141, QTY142, QTY143, QTY144, QTY145, QTY146, QTY147, QTY148, QTY149, QTY150
                          , QTY151, QTY152, QTY153, QTY154, QTY155, QTY156, QTY157, QTY158, QTY159, QTY160
                          , QTY161, QTY162, QTY163, QTY164, QTY165, QTY166, QTY167, QTY168, QTY169, QTY170
                          , QTY171, QTY172, QTY173, QTY174, QTY175, QTY176, QTY177, QTY178, QTY179, QTY180
                          , QTY181, QTY182, QTY183, QTY184, QTY185, QTY186, QTY187, QTY188, QTY189, QTY190
                          , QTY191, QTY192, QTY193, QTY194, QTY195, QTY196, QTY197, QTY198, QTY199, QTY200
                          , QTY201, QTY202, QTY203, QTY204, QTY205, QTY206, QTY207, QTY208, QTY209, QTY210
                          , QTY211, QTY212, QTY213, QTY214, QTY215, QTY216, QTY217, QTY218, QTY219, QTY220
                          , QTY221, QTY222, QTY223, QTY224, QTY225, QTY226, QTY227, QTY228, QTY229, QTY230
                          , QTY231, QTY232, QTY233, QTY234, QTY235, QTY236, QTY237, QTY238, QTY239, QTY240
                          , QTY241, QTY242, QTY243, QTY244, QTY245, QTY246, QTY247, QTY248, QTY249, QTY250
                          , QTY251, QTY252, QTY253, QTY254, QTY255, QTY256, QTY257, QTY258, QTY259, QTY260
                          , QTY261, QTY262, QTY263, QTY264, QTY265, QTY266, QTY267, QTY268, QTY269, QTY270
                          , QTY271, QTY272, QTY273, QTY274, QTY275, QTY276, QTY277, QTY278, QTY279, QTY280
                          , QTY281, QTY282, QTY283, QTY284, QTY285, QTY286, QTY287, QTY288, QTY289, QTY290
                          , QTY291, QTY292, QTY293, QTY294, QTY295, QTY296, QTY297, QTY298, QTY299, QTY300
                          , QTY301, QTY302, QTY303, QTY304, QTY305, QTY306, QTY307, QTY308, QTY309, QTY310
                          , QTY311, QTY312, QTY313, QTY314, QTY315, QTY316, QTY317, QTY318, QTY319, QTY320
                          , QTY321, QTY322, QTY323, QTY324, QTY325, QTY326, QTY327, QTY328, QTY329, QTY330
                          , QTY331, QTY332, QTY333, QTY334, QTY335, QTY336, QTY337, QTY338, QTY339, QTY340
                          , QTY341, QTY342, QTY343, QTY344, QTY345, QTY346, QTY347, QTY348, QTY349, QTY350
                          , QTY351, QTY352, QTY353, QTY354, QTY355, QTY356, QTY357, QTY358, QTY359, QTY360
                          , QTY361, QTY362, QTY363, QTY364
                       )
                   ) X
                 , ( SELECT A.BASIS_YYYYMMDD AS YYYYMMDD
                                     /*  MSSQL 'QTY' + REPLICATE('0', 3 - LEN(ROW_NUMBER() OVER(..))) + CONVERT(NVARCHAR, ROW_NUMBER() OVER(..)) */
                                     , 'QTY' || LPAD(TO_CHAR(ROW_NUMBER() OVER(ORDER BY A.BASIS_YYYYMMDD)), 3, '0') AS YYYYMMDD_COLUMN
                                  FROM SCM_SYS_CALENDAR_M A
                                 WHERE A.BASIS_YYYYMMDD BETWEEN V_BATCH_CREATE_FROM_YYYYMMDD AND V_BATCH_CREATE_TO_YYYYMMDD
                                   /*  WHERE A.BASIS_YYYYMMDD >= @v_batch_create_from_yyyymmdd
                                         AND A.BASIS_YYYYMMDD <  @v_batch_create_to_yyyymmdd */
                              ) Y
             /*  PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - start */
             WHERE Y.YYYYMMDD >= V_BOD_FROM
               AND X.YYYYMMDD_COLUMN = Y.YYYYMMDD_COLUMN
               AND Y.YYYYMMDD <= V_BOD_TO
             /*  PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - end */
               AND X.DIVISION_ID          = V_BATCH_DIVISION_ID
               AND X.PLAN_START_YYYYMMDD  = V_BATCH_PLAN_START_YYYYMMDD
               AND X.CREATE_FROM_YYYYMMDD = V_BATCH_CREATE_FROM_YYYYMMDD
               AND X.SEQ                  = V_BATCH_SEQ
               AND X.XLS_KEY1             = V_BATCH_XLS_KEY1;

            /*  SELECT '#SCP_ANL_SHIPMENT_PLAN_FG' + @v_batch_create_to_yyyymmdd TN, * FROM #SCP_ANL_SHIPMENT_PLAN_FG --TEST */

            /* ------------------------------------------------------------------------------------- */
            /*  FROZEN 구간 UPDATE */
            /*  PLANT SITE(SCM_MST_SITE)의 SHIP_FROZEN ,PROD_FROZEN를 주단위로 변경하여 FROZEN 구간을 저장 내역에서 삭제한다. */
            /* ------------------------------------------------------------------------------------- start */
            /*  2020.10.16   KSW   C20201016-000200 :: GSCM 시스템의 RTF 적확도 개선을 위한 SSP구간 Shipment 수량 변경 기능 요청 건
                SHIP_PLAN 저장시 Frozen 구간 체크하지 않음 (PR, MA plan 한함)
                주석처리 :: Frozen 구간에 속한 플랜 data 를 삭제하지 않음
                  IF @v_batch_plan_type IN  ('PR','MA','SE')
                  BEGIN
                    DELETE  FROM #SCP_ANL_SHIPMENT_PLAN_FG
                            FROM #SCP_ANL_SHIPMENT_PLAN_FG X
                          INNER JOIN #SCM_MST_SITE Y
                             ON Y.DIVISION_ID = X.DIVISION_ID
                            AND Y.SCM_SITE_ID = X.FROM_SITE
                          WHERE X.YYYYMMDD < Y.SHIP_FROZEN_WEEK_DAY;
                  END                                                                                  */
            /* ------------------------------------------------------------------------------------- end */

            /*                원천 GTT 는 (XLS_KEY1 1행) x (YYYYMMDD) 라 ON 키당 1행이므로 ORA-30926 도 없다. */
            MERGE INTO SCP_ANL_SHIPMENT_PLAN_FG X
            USING GT_XPGT_SCP_ANL_SHIPMENT_PLAN_FG Y
               ON ( 0 = 0
                    AND X.DIVISION_ID         = Y.DIVISION_ID           /* --@v_batch_division_id -- 2021.10.25 튜닝개선요청에 따른 변경 */
                    AND X.PLAN_START_YYYYMMDD = Y.PLAN_START_YYYYMMDD   /* --@@v_batch_plan_start_yyyymmdd */
                    AND X.PLAN_TYPE           = Y.PLAN_TYPE             /* --@v_batch_plan_type */
                    AND X.SEQ                 = Y.SEQ                   /* --@v_batch_seq */
                    AND X.BIZ_TYPE            = Y.BIZ_TYPE
                    AND X.PROJECT_CODE        = Y.PROJECT_CODE
                    AND X.ITEM_ID             = Y.ITEM_ID
                    AND X.TO_SITE             = Y.TO_SITE
                    AND X.INCOTERMS           = Y.INCOTERMS
                    AND X.FROM_SITE           = Y.FROM_SITE
                    AND X.BOD_ID              = Y.BOD_ID
                    AND X.MEASURE             = Y.MEASURE
                    AND X.YYYYMMDD            = Y.YYYYMMDD )
            WHEN MATCHED THEN
            UPDATE
               SET X.QTY               = Y.QTY
                 /*  , X.CREATED_BY    = @v_batch_user_sim
                     , X.CREATION_DATE = GETDATE() */
                 , X.LAST_UPDATED_BY   = V_BATCH_USER_SIM
                 , X.LAST_UPDATE_DATE  = SYSDATE
            WHEN NOT MATCHED THEN
            INSERT ( DIVISION_ID
                   , PLAN_START_YYYYMMDD
                   , PLAN_TYPE
                   , SEQ
                   , BIZ_TYPE
                   , PROJECT_CODE
                   /*  , CELL_ITEM_ID */
                   , ITEM_ID
                   , TO_SITE
                   , INCOTERMS
                   , FROM_SITE
                   , BOD_ID
                   /*  , TRANSPORT_MODE */
                   , MEASURE
                   , YYYYMMDD
                   , QTY
                   , ORIGIN_FROM_DIVISION_ID
                   , ORIGIN_TO_DIVISION_ID
                   , ELECTRODE_TYPE
                   , CREATED_BY
                   , CREATION_DATE
                   , LAST_UPDATED_BY
                   , LAST_UPDATE_DATE )
            VALUES ( Y.DIVISION_ID
                   , Y.PLAN_START_YYYYMMDD
                   , Y.PLAN_TYPE
                   , Y.SEQ
                   , Y.BIZ_TYPE
                   , Y.PROJECT_CODE
                   /*  , Y.CELL_ITEM_ID */
                   , Y.ITEM_ID
                   , Y.TO_SITE
                   , Y.INCOTERMS
                   , Y.FROM_SITE
                   , Y.BOD_ID
                   /*  , Y.TRANSPORT_MODE */
                   , Y.MEASURE
                   , Y.YYYYMMDD
                   , Y.QTY
                   , Y.ORIGIN_FROM_DIVISION_ID
                   , Y.ORIGIN_TO_DIVISION_ID
                   , Y.ELECTRODE_TYPE
                   , V_BATCH_USER_SIM
                   , SYSDATE
                   , V_BATCH_USER_SIM
                   , SYSDATE );

            /* ------------------------------------------------------------------------------------- */
            /*  SCP_ANL_SHIPMENT_PLAN_FG_H : History 입력 */
            /* ------------------------------------------------------------------------------------- */
            /*  SELECT top 10 * FROM dbo.SCP_ANL_SHIPMENT_PLAN_FG_H WITH (NOLOCK)     -- HISTORY_SEQ */
            /*  SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_ANL_SHIPMENT_PLAN_FG_H */
            INSERT INTO SCP_ANL_SHIPMENT_PLAN_FG_H
                 ( HISTORY_SEQ
                 , DIVISION_ID
                 , PLAN_START_YYYYMMDD
                 , PLAN_TYPE
                 , SEQ
                 , BIZ_TYPE
                 , PROJECT_CODE
                 , ITEM_ID
                 , TO_SITE
                 , INCOTERMS
                 , FROM_SITE
                 , BOD_ID
                 , MEASURE
                 , YYYYMMDD
                 , QTY
                 , ORIGIN_TO_DIVISION_ID
                 , ORIGIN_FROM_DIVISION_ID
                 , ELECTRODE_TYPE
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE
                 /*  ,ATTRIBUTE1
                     ,ATTRIBUTE2
                     ,ATTRIBUTE3
                     ,ATTRIBUTE4
                     ,ATTRIBUTE5
                     ,ATTRIBUTE6
                     ,ATTRIBUTE7
                     ,ATTRIBUTE8
                     ,ATTRIBUTE9
                     ,ATTRIBUTE10  */
                 , HISTORY_CREATION_DATE )
            SELECT SEQ1_SCP_ANL_SHIPMENT_PLAN_FG_H.NEXTVAL   /*  MSSQL NEXT VALUE FOR seq -> Oracle seq.NEXTVAL */
                 , DIVISION_ID
                 , PLAN_START_YYYYMMDD
                 , PLAN_TYPE
                 , SEQ
                 , BIZ_TYPE
                 , PROJECT_CODE
                 , ITEM_ID
                 , TO_SITE
                 , INCOTERMS
                 , FROM_SITE
                 , BOD_ID
                 , MEASURE
                 , YYYYMMDD
                 , QTY
                 , ORIGIN_TO_DIVISION_ID
                 , ORIGIN_FROM_DIVISION_ID
                 , ELECTRODE_TYPE
                 , V_BATCH_USER_SIM AS CREATED_BY
                 , SYSDATE          AS CREATION_DATE
                 , V_BATCH_USER_SIM AS LAST_UPDATED_BY
                 , SYSDATE          AS LAST_UPDATE_DATE
                 /*  ,ATTRIBUTE1
                     ,ATTRIBUTE2
                     ,ATTRIBUTE3
                     ,ATTRIBUTE4
                     ,ATTRIBUTE5
                     ,ATTRIBUTE6
                     ,ATTRIBUTE7
                     ,ATTRIBUTE8
                     ,ATTRIBUTE9
                     ,ATTRIBUTE10  */
                 , SYSDATE          AS HISTORY_CREATION_DATE
              FROM GT_XPGT_SCP_ANL_SHIPMENT_PLAN_FG;

            /* ------------------------------------------------------------------------------------- */
            /*  SCP_ANL_SHIPMENT_PLAN_FIX : FIX 입력(FG) */
            /* ------------------------------------------------------------------------------------- */
            /*  FIX UPDATE
                MSSQL UPDATE X SET .. FROM SCP_ANL_SHIPMENT_PLAN_FIX X INNER JOIN #T Y ON ..
                -> Oracle 은 UPDATE .. FROM 이 없다(ORA-38104/30926 회피). 갱신원천이 Y.QTY 하나뿐이라 */
            UPDATE SCP_ANL_SHIPMENT_PLAN_FIX X   /* FIX_ID, DIVISION_ID, BIZ_TYPE, ITEM_ID, TO_SITE, FROM_SITE, BOD_ID, YYYYMMDD */
               SET X.QTY              = ( SELECT Y.QTY
                                            FROM GT_XPGT_SCP_ANL_SHIPMENT_PLAN_FG Y
                                           WHERE 0 = 0
                                             AND X.DIVISION_ID  = Y.DIVISION_ID
                                             AND X.BIZ_TYPE     = Y.BIZ_TYPE
                                             AND X.PROJECT_CODE = Y.PROJECT_CODE
                                             AND X.ITEM_ID      = Y.ITEM_ID
                                             AND X.TO_SITE      = Y.TO_SITE
                                             AND X.FROM_SITE    = Y.FROM_SITE
                                             AND X.BOD_ID       = Y.BOD_ID
                                             AND X.YYYYMMDD     = Y.YYYYMMDD
                                             AND ROWNUM         = 1 )
                 , X.FIX_REASON       = 'SIMULATION UPDATE'
                 , X.ATTRIBUTE1       = 'Y'                 /* History 구분을 위해 */
                 , X.LAST_UPDATED_BY  = V_BATCH_USER_SIM
                 , X.LAST_UPDATE_DATE = SYSDATE
             WHERE EXISTS ( SELECT 1
                              FROM GT_XPGT_SCP_ANL_SHIPMENT_PLAN_FG Y
                             WHERE 0 = 0
                               AND X.DIVISION_ID  = Y.DIVISION_ID
                               AND X.BIZ_TYPE     = Y.BIZ_TYPE
                               AND X.PROJECT_CODE = Y.PROJECT_CODE
                               AND X.ITEM_ID      = Y.ITEM_ID
                               AND X.TO_SITE      = Y.TO_SITE
                               AND X.FROM_SITE    = Y.FROM_SITE
                               AND X.BOD_ID       = Y.BOD_ID
                               AND X.YYYYMMDD     = Y.YYYYMMDD );

            /* ------------------------------------------------------------------------------------- */
            /*  SCP_ANL_SHIPMENT_PLAN_FIX_H : FIX History 입력 */
            /* ------------------------------------------------------------------------------------- */
            /*  SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_ANL_SHIPMENT_PLAN_FIX_H   -- 현재 사용안함.
                SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H -- SCP_ANL_PRODUCTION_PLAN_FIX 대신 사용중임.
                SELECT NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H */
            INSERT INTO SCP_ANL_SHIPMENT_PLAN_FIX_H
                 ( HISTORY_SEQ
                 , FIX_ID
                 , DIVISION_ID
                 , BIZ_TYPE
                 , ITEM_ID
                 , TO_SITE
                 , FROM_SITE
                 , PROJECT_CODE
                 , INCOTERMS
                 , BOD_ID
                 , YYYYMMDD
                 , QTY
                 , FIX_REASON
                 , ORIGIN_FROM_DIVISION_ID
                 , ORIGIN_TO_DIVISION_ID
                 , ELECTRODE_TYPE
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE
                 /*  ,ATTRIBUTE1
                     ,ATTRIBUTE2
                     ,ATTRIBUTE3
                     ,ATTRIBUTE4
                     ,ATTRIBUTE5
                     ,ATTRIBUTE6
                     ,ATTRIBUTE7
                     ,ATTRIBUTE8
                     ,ATTRIBUTE9
                     ,ATTRIBUTE10  */
                 , HISTORY_CREATION_DATE )
            SELECT SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H.NEXTVAL
                 , FIX_ID
                 , DIVISION_ID
                 , BIZ_TYPE
                 , ITEM_ID
                 , TO_SITE
                 , FROM_SITE
                 , PROJECT_CODE
                 , INCOTERMS
                 , BOD_ID
                 , YYYYMMDD
                 , QTY
                 , FIX_REASON
                 , ORIGIN_FROM_DIVISION_ID
                 , ORIGIN_TO_DIVISION_ID
                 , ELECTRODE_TYPE
                 , V_BATCH_USER_SIM AS CREATED_BY
                 , SYSDATE          AS CREATION_DATE
                 , V_BATCH_USER_SIM AS LAST_UPDATED_BY
                 , SYSDATE          AS LAST_UPDATE_DATE
                 /*  ,ATTRIBUTE1
                     ,ATTRIBUTE2
                     ,ATTRIBUTE3
                     ,ATTRIBUTE4
                     ,ATTRIBUTE5
                     ,ATTRIBUTE6
                     ,ATTRIBUTE7
                     ,ATTRIBUTE8
                     ,ATTRIBUTE9
                     ,ATTRIBUTE10  */
                 , SYSDATE          AS HISTORY_CREATION_DATE
              FROM SCP_ANL_SHIPMENT_PLAN_FIX
             WHERE ATTRIBUTE1 = 'Y';

            /*  MSSQL UPDATE X SET X.ATTRIBUTE1 = NULL FROM .. INNER JOIN .. (조인술어에 X.ATTRIBUTE1 = Y 포함) */
            UPDATE SCP_ANL_SHIPMENT_PLAN_FIX X   /* FIX_ID, DIVISION_ID, BIZ_TYPE, ITEM_ID, TO_SITE, FROM_SITE, BOD_ID, YYYYMMDD */
               SET X.ATTRIBUTE1 = NULL           /* History 구분을 위해 원상복구 */
             WHERE X.ATTRIBUTE1 = 'Y'
               AND EXISTS ( SELECT 1
                              FROM GT_XPGT_SCP_ANL_SHIPMENT_PLAN_FG Y
                             WHERE 0 = 0
                               AND X.DIVISION_ID  = Y.DIVISION_ID
                               AND X.BIZ_TYPE     = Y.BIZ_TYPE
                               AND X.PROJECT_CODE = Y.PROJECT_CODE
                               AND X.ITEM_ID      = Y.ITEM_ID
                               AND X.TO_SITE      = Y.TO_SITE
                               AND X.FROM_SITE    = Y.FROM_SITE
                               AND X.BOD_ID       = Y.BOD_ID
                               AND X.YYYYMMDD     = Y.YYYYMMDD );

        END IF;

        /* ----------------------------------------------------------------------------------------- */
        /*  SCP_ANL_SHIPMENT_PLAN_SEMI UPDATE */
        /*  SEMI_SHIP_PLAN --> SCP_ANL_SHIPMENT_PLAN_SEMI.MEASURE 'SHIP_PLAN_AMEND' UPDATE */
        /* ----------------------------------------------------------------------------------------- */
        IF V_BATCH_MEASURE IN ('SEMI_SHIP_PLAN') THEN   /* SEMI */

            /*  SEMI_SHIP_PLAN */
            /*  IF OBJECT_ID('tempdb..#SCP_ANL_SHIPMENT_PLAN_SEMI') IS NOT NULL DROP TABLE #SCP_ANL_SHIPMENT_PLAN_SEMI */
            DELETE FROM GT_XPGT_SCP_ANL_SHIPMENT_PLAN_SEMI;

            INSERT INTO GT_XPGT_SCP_ANL_SHIPMENT_PLAN_SEMI
                 ( DIVISION_ID
                 , PLAN_START_YYYYMMDD
                 , PLAN_TYPE
                 , SEQ
                 , OPERATION_GROUP
                 , ITEM_ID
                 , FROM_SITE
                 , BOD_ID
                 , MEASURE
                 , YYYYMMDD
                 , TO_SITE
                 , QTY
                 , ORIGIN_FROM_DIVISION_ID
                 , ORIGIN_TO_DIVISION_ID
                 , ELECTRODE_TYPE
                 , ATTRIBUTE1
                 , YYYYMMDD_COLUMN )
            SELECT X.DIVISION_ID
                 , X.PLAN_START_YYYYMMDD
                 , X.PLAN_TYPE
                 , X.SEQ
                 , X.OPERATION_GROUP
                 /*  , X.CELL_ITEM_ID */
                 , X.ITEM_ID
                 , X.FROM_SITE
                 , X.BOD_ID
                 , 'SHIP_PLAN_AMEND' AS MEASURE
                 , Y.YYYYMMDD AS YYYYMMDD
                 , X.TO_SITE
                 , X.QTY
                 , V_BATCH_DIVISION_ID AS ORIGIN_FROM_DIVISION_ID   /* 2022.03.21 :: GM JV 반영 '81' --> @v_batch_division_id */
                 , V_BATCH_DIVISION_ID AS ORIGIN_TO_DIVISION_ID     /* 2022.03.21 :: GM JV 반영 '81' --> @v_batch_division_id */
                 , '' AS ELECTRODE_TYPE
                 , X.ATTRIBUTE1
                 , Y.YYYYMMDD_COLUMN
              /*  FROM #DAY_SCP_XLS_PSI_GLOBAL SourceTable WITH (NOLOCK) */
              FROM SCP_XLS_PSI_GLOBAL
                   UNPIVOT
                   (
                    QTY FOR YYYYMMDD_COLUMN IN (
                            QTY001, QTY002, QTY003, QTY004, QTY005, QTY006, QTY007, QTY008, QTY009, QTY010
                          , QTY011, QTY012, QTY013, QTY014, QTY015, QTY016, QTY017, QTY018, QTY019, QTY020
                          , QTY021, QTY022, QTY023, QTY024, QTY025, QTY026, QTY027, QTY028, QTY029, QTY030
                          , QTY031, QTY032, QTY033, QTY034, QTY035, QTY036, QTY037, QTY038, QTY039, QTY040
                          , QTY041, QTY042, QTY043, QTY044, QTY045, QTY046, QTY047, QTY048, QTY049, QTY050
                          , QTY051, QTY052, QTY053, QTY054, QTY055, QTY056, QTY057, QTY058, QTY059, QTY060
                          , QTY061, QTY062, QTY063, QTY064, QTY065, QTY066, QTY067, QTY068, QTY069, QTY070
                          , QTY071, QTY072, QTY073, QTY074, QTY075, QTY076, QTY077, QTY078, QTY079, QTY080
                          , QTY081, QTY082, QTY083, QTY084, QTY085, QTY086, QTY087, QTY088, QTY089, QTY090
                          , QTY091, QTY092, QTY093, QTY094, QTY095, QTY096, QTY097, QTY098, QTY099, QTY100
                          , QTY101, QTY102, QTY103, QTY104, QTY105, QTY106, QTY107, QTY108, QTY109, QTY110
                          , QTY111, QTY112, QTY113, QTY114, QTY115, QTY116, QTY117, QTY118, QTY119, QTY120
                          , QTY121, QTY122, QTY123, QTY124, QTY125, QTY126, QTY127, QTY128, QTY129, QTY130
                          , QTY131, QTY132, QTY133, QTY134, QTY135, QTY136, QTY137, QTY138, QTY139, QTY140
                          , QTY141, QTY142, QTY143, QTY144, QTY145, QTY146, QTY147, QTY148, QTY149, QTY150
                          , QTY151, QTY152, QTY153, QTY154, QTY155, QTY156, QTY157, QTY158, QTY159, QTY160
                          , QTY161, QTY162, QTY163, QTY164, QTY165, QTY166, QTY167, QTY168, QTY169, QTY170
                          , QTY171, QTY172, QTY173, QTY174, QTY175, QTY176, QTY177, QTY178, QTY179, QTY180
                          , QTY181, QTY182, QTY183, QTY184, QTY185, QTY186, QTY187, QTY188, QTY189, QTY190
                          , QTY191, QTY192, QTY193, QTY194, QTY195, QTY196, QTY197, QTY198, QTY199, QTY200
                          , QTY201, QTY202, QTY203, QTY204, QTY205, QTY206, QTY207, QTY208, QTY209, QTY210
                          , QTY211, QTY212, QTY213, QTY214, QTY215, QTY216, QTY217, QTY218, QTY219, QTY220
                          , QTY221, QTY222, QTY223, QTY224, QTY225, QTY226, QTY227, QTY228, QTY229, QTY230
                          , QTY231, QTY232, QTY233, QTY234, QTY235, QTY236, QTY237, QTY238, QTY239, QTY240
                          , QTY241, QTY242, QTY243, QTY244, QTY245, QTY246, QTY247, QTY248, QTY249, QTY250
                          , QTY251, QTY252, QTY253, QTY254, QTY255, QTY256, QTY257, QTY258, QTY259, QTY260
                          , QTY261, QTY262, QTY263, QTY264, QTY265, QTY266, QTY267, QTY268, QTY269, QTY270
                          , QTY271, QTY272, QTY273, QTY274, QTY275, QTY276, QTY277, QTY278, QTY279, QTY280
                          , QTY281, QTY282, QTY283, QTY284, QTY285, QTY286, QTY287, QTY288, QTY289, QTY290
                          , QTY291, QTY292, QTY293, QTY294, QTY295, QTY296, QTY297, QTY298, QTY299, QTY300
                          , QTY301, QTY302, QTY303, QTY304, QTY305, QTY306, QTY307, QTY308, QTY309, QTY310
                          , QTY311, QTY312, QTY313, QTY314, QTY315, QTY316, QTY317, QTY318, QTY319, QTY320
                          , QTY321, QTY322, QTY323, QTY324, QTY325, QTY326, QTY327, QTY328, QTY329, QTY330
                          , QTY331, QTY332, QTY333, QTY334, QTY335, QTY336, QTY337, QTY338, QTY339, QTY340
                          , QTY341, QTY342, QTY343, QTY344, QTY345, QTY346, QTY347, QTY348, QTY349, QTY350
                          , QTY351, QTY352, QTY353, QTY354, QTY355, QTY356, QTY357, QTY358, QTY359, QTY360
                          , QTY361, QTY362, QTY363, QTY364
                       )
                   ) X
                 , ( SELECT A.BASIS_YYYYMMDD AS YYYYMMDD
                                     /*  MSSQL 'QTY' + REPLICATE('0', 3 - LEN(ROW_NUMBER() OVER(..))) + CONVERT(NVARCHAR, ROW_NUMBER() OVER(..)) */
                                     , 'QTY' || LPAD(TO_CHAR(ROW_NUMBER() OVER(ORDER BY A.BASIS_YYYYMMDD)), 3, '0') AS YYYYMMDD_COLUMN
                                  FROM SCM_SYS_CALENDAR_M A
                                 WHERE A.BASIS_YYYYMMDD BETWEEN V_BATCH_CREATE_FROM_YYYYMMDD AND V_BATCH_CREATE_TO_YYYYMMDD
                                   /*  WHERE A.BASIS_YYYYMMDD >= @v_batch_create_from_yyyymmdd
                                         AND A.BASIS_YYYYMMDD <  @v_batch_create_to_yyyymmdd */
                              ) Y
             /*  PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - start */
             WHERE Y.YYYYMMDD >= V_BOD_FROM
               AND X.YYYYMMDD_COLUMN = Y.YYYYMMDD_COLUMN
               AND Y.YYYYMMDD <= V_BOD_TO
             /*  PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - end */
               AND X.DIVISION_ID          = V_BATCH_DIVISION_ID
               AND X.PLAN_START_YYYYMMDD  = V_BATCH_PLAN_START_YYYYMMDD
               AND X.CREATE_FROM_YYYYMMDD = V_BATCH_CREATE_FROM_YYYYMMDD
               AND X.SEQ                  = V_BATCH_SEQ
               AND X.XLS_KEY1             = V_BATCH_XLS_KEY1
               AND X.MEASURE              IN ('SEMI_SHIP_PLAN');

            /* ------------------------------------------------------------------------------------- */
            /*  FROZEN 구간 UPDATE */
            /*  PLANT SITE(SCM_MST_SITE)의 SHIP_FROZEN ,PROD_FROZEN를 주단위로 변경하여 FROZEN 구간을 저장 내역에서 삭제한다. */
            /* ------------------------------------------------------------------------------------- */
            /*  2021.12.06 SEMI SHIP PLAN 에 대한 PR/MA Frozen 구간해제
                  IF @v_batch_plan_type IN  ('PR','MA','SE')
                  BEGIN
                    DELETE  FROM #SCP_ANL_SHIPMENT_PLAN_SEMI
                            FROM #SCP_ANL_SHIPMENT_PLAN_SEMI X
                          INNER JOIN #SCM_MST_SITE Y
                             ON Y.DIVISION_ID = X.DIVISION_ID
                            AND Y.SCM_SITE_ID = X.FROM_SITE
                          WHERE X.YYYYMMDD < Y.SHIP_FROZEN_WEEK_DAY;
                  END                                                                                  */

            /*                원천 GTT 는 (XLS_KEY1 1행) x (YYYYMMDD) 라 ON 키당 1행이므로 ORA-30926 도 없다. */
            MERGE INTO SCP_ANL_SHIPMENT_PLAN_SEMI X
            USING GT_XPGT_SCP_ANL_SHIPMENT_PLAN_SEMI Y
               ON ( 0 = 0
                    AND X.DIVISION_ID         = Y.DIVISION_ID           /* --@v_batch_division_id -- 2021.10.25 튜닝개선요청에 따른 변경 */
                    AND X.PLAN_START_YYYYMMDD = Y.PLAN_START_YYYYMMDD   /* --@@v_batch_plan_start_yyyymmdd */
                    AND X.PLAN_TYPE           = Y.PLAN_TYPE             /* --@v_batch_plan_type */
                    AND X.SEQ                 = Y.SEQ                   /* --@v_batch_seq */
                    AND X.OPERATION_GROUP     = Y.OPERATION_GROUP
                    AND X.ITEM_ID             = Y.ITEM_ID
                    AND X.FROM_SITE           = Y.FROM_SITE
                    AND X.BOD_ID              = Y.BOD_ID
                    AND X.MEASURE             = Y.MEASURE
                    AND X.YYYYMMDD            = Y.YYYYMMDD
                    AND X.TO_SITE             = Y.TO_SITE )
            WHEN MATCHED THEN
            UPDATE
               SET X.QTY               = Y.QTY
                 /*  , X.CREATED_BY    = @v_batch_user_sim
                     , X.CREATION_DATE = GETDATE() */
                 , X.LAST_UPDATED_BY   = V_BATCH_USER_SIM
                 , X.LAST_UPDATE_DATE  = SYSDATE
            WHEN NOT MATCHED THEN
            INSERT ( DIVISION_ID
                   , PLAN_START_YYYYMMDD
                   , PLAN_TYPE
                   , SEQ
                   , OPERATION_GROUP
                   , ITEM_ID
                   , FROM_SITE
                   , BOD_ID
                   , MEASURE
                   , YYYYMMDD
                   , TO_SITE
                   , QTY
                   , ORIGIN_FROM_DIVISION_ID
                   , ORIGIN_TO_DIVISION_ID
                   , ELECTRODE_TYPE
                   , CREATED_BY
                   , CREATION_DATE
                   , LAST_UPDATED_BY
                   , LAST_UPDATE_DATE )
            VALUES ( Y.DIVISION_ID
                   , Y.PLAN_START_YYYYMMDD
                   , Y.PLAN_TYPE
                   , Y.SEQ
                   , Y.OPERATION_GROUP
                   , Y.ITEM_ID
                   , Y.FROM_SITE
                   , Y.BOD_ID
                   , Y.MEASURE
                   , Y.YYYYMMDD
                   , Y.TO_SITE
                   , Y.QTY
                   , Y.ORIGIN_FROM_DIVISION_ID
                   , Y.ORIGIN_TO_DIVISION_ID
                   , Y.ELECTRODE_TYPE
                   , V_BATCH_USER_SIM
                   , SYSDATE
                   , V_BATCH_USER_SIM
                   , SYSDATE );

            /* ------------------------------------------------------------------------------------- */
            /*  SCP_ANL_SHIPMENT_PLAN_SEMI_H : History 입력(SEMI) */
            /* ------------------------------------------------------------------------------------- */
            INSERT INTO SCP_ANL_SHIPMENT_PLAN_SEMI_H
                 ( HISTORY_SEQ
                 , DIVISION_ID
                 , PLAN_START_YYYYMMDD
                 , PLAN_TYPE
                 , SEQ
                 , OPERATION_GROUP
                 , ITEM_ID
                 , FROM_SITE
                 , TO_SITE
                 , BOD_ID
                 , MEASURE
                 , YYYYMMDD
                 , QTY
                 , UPDATE_REASON_BOD
                 , ORIGIN_FROM_DIVISION_ID
                 , ORIGIN_TO_DIVISION_ID
                 , ELECTRODE_TYPE
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE
                 /*  ,ATTRIBUTE1
                     ,ATTRIBUTE2
                     ,ATTRIBUTE3
                     ,ATTRIBUTE4
                     ,ATTRIBUTE5
                     ,ATTRIBUTE6
                     ,ATTRIBUTE7
                     ,ATTRIBUTE8
                     ,ATTRIBUTE9
                     ,ATTRIBUTE10  */
                 , HISTORY_CREATION_DATE )
            SELECT SEQ1_SCP_ANL_SHIPMENT_PLAN_SEMI_H.NEXTVAL
                 , DIVISION_ID
                 , PLAN_START_YYYYMMDD
                 , PLAN_TYPE
                 , SEQ
                 , OPERATION_GROUP
                 , ITEM_ID
                 , FROM_SITE
                 , TO_SITE
                 , BOD_ID
                 , MEASURE
                 , YYYYMMDD
                 , QTY
                 , NULL AS UPDATE_REASON_BOD
                 , ORIGIN_FROM_DIVISION_ID
                 , ORIGIN_TO_DIVISION_ID
                 , ELECTRODE_TYPE
                 , V_BATCH_USER_SIM AS CREATED_BY
                 , SYSDATE          AS CREATION_DATE
                 , V_BATCH_USER_SIM AS LAST_UPDATED_BY
                 , SYSDATE          AS LAST_UPDATE_DATE
                 /*  ,ATTRIBUTE1
                     ,ATTRIBUTE2
                     ,ATTRIBUTE3
                     ,ATTRIBUTE4
                     ,ATTRIBUTE5
                     ,ATTRIBUTE6
                     ,ATTRIBUTE7
                     ,ATTRIBUTE8
                     ,ATTRIBUTE9
                     ,ATTRIBUTE10  */
                 , SYSDATE          AS HISTORY_CREATION_DATE
              FROM GT_XPGT_SCP_ANL_SHIPMENT_PLAN_SEMI;

            /* ------------------------------------------------------------------------------------- */
            /*  SCP_ANL_SHIPMENT_PLAN_FIX : FIX 입력(SEMI) */
            /* ------------------------------------------------------------------------------------- */
            /*  FIX UPDATE (CV-024 : 상관 스칼라 서브쿼리 + EXISTS) */
            UPDATE SCP_ANL_SHIPMENT_PLAN_FIX X   /* FIX_ID, DIVISION_ID, BIZ_TYPE, ITEM_ID, TO_SITE, FROM_SITE, BOD_ID, YYYYMMDD */
               SET X.QTY        = ( SELECT Y.QTY
                                      FROM GT_XPGT_SCP_ANL_SHIPMENT_PLAN_SEMI Y
                                     WHERE 0 = 0
                                       AND X.DIVISION_ID = Y.DIVISION_ID
                                       AND X.BIZ_TYPE    = Y.OPERATION_GROUP
                                       AND X.ITEM_ID     = Y.ITEM_ID
                                       AND X.TO_SITE     = Y.TO_SITE
                                       AND X.FROM_SITE   = Y.FROM_SITE
                                       AND X.BOD_ID      = Y.BOD_ID
                                       AND X.YYYYMMDD    = Y.YYYYMMDD
                                       AND ROWNUM        = 1 )
                 , X.FIX_REASON = 'SIMULATION UPDATE'
                 , X.ATTRIBUTE1 = 'Y'   /* History 구분을 위해 */
             WHERE EXISTS ( SELECT 1
                              FROM GT_XPGT_SCP_ANL_SHIPMENT_PLAN_SEMI Y
                             WHERE 0 = 0
                               AND X.DIVISION_ID = Y.DIVISION_ID
                               AND X.BIZ_TYPE    = Y.OPERATION_GROUP
                               AND X.ITEM_ID     = Y.ITEM_ID
                               AND X.TO_SITE     = Y.TO_SITE
                               AND X.FROM_SITE   = Y.FROM_SITE
                               AND X.BOD_ID      = Y.BOD_ID
                               AND X.YYYYMMDD    = Y.YYYYMMDD );

            /* ------------------------------------------------------------------------------------- */
            /*  SCP_ANL_SHIPMENT_PLAN_FIX_H : FIX History 입력(SEMI) */
            /* ------------------------------------------------------------------------------------- */
            INSERT INTO SCP_ANL_SHIPMENT_PLAN_FIX_H
                 ( HISTORY_SEQ
                 , FIX_ID
                 , DIVISION_ID
                 , BIZ_TYPE
                 , ITEM_ID
                 , TO_SITE
                 , FROM_SITE
                 , PROJECT_CODE
                 , INCOTERMS
                 , BOD_ID
                 , YYYYMMDD
                 , QTY
                 , FIX_REASON
                 , ORIGIN_FROM_DIVISION_ID
                 , ORIGIN_TO_DIVISION_ID
                 , ELECTRODE_TYPE
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE
                 /*  ,ATTRIBUTE1
                     ,ATTRIBUTE2
                     ,ATTRIBUTE3
                     ,ATTRIBUTE4
                     ,ATTRIBUTE5
                     ,ATTRIBUTE6
                     ,ATTRIBUTE7
                     ,ATTRIBUTE8
                     ,ATTRIBUTE9
                     ,ATTRIBUTE10  */
                 , HISTORY_CREATION_DATE )
            SELECT SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H.NEXTVAL
                 , FIX_ID
                 , DIVISION_ID
                 , BIZ_TYPE
                 , ITEM_ID
                 , TO_SITE
                 , FROM_SITE
                 , PROJECT_CODE
                 , INCOTERMS
                 , BOD_ID
                 , YYYYMMDD
                 , QTY
                 , FIX_REASON
                 , ORIGIN_FROM_DIVISION_ID
                 , ORIGIN_TO_DIVISION_ID
                 , ELECTRODE_TYPE
                 , V_BATCH_USER_SIM AS CREATED_BY
                 , SYSDATE          AS CREATION_DATE
                 , V_BATCH_USER_SIM AS LAST_UPDATED_BY
                 , SYSDATE          AS LAST_UPDATE_DATE
                 /*  ,ATTRIBUTE1
                     ,ATTRIBUTE2
                     ,ATTRIBUTE3
                     ,ATTRIBUTE4
                     ,ATTRIBUTE5
                     ,ATTRIBUTE6
                     ,ATTRIBUTE7
                     ,ATTRIBUTE8
                     ,ATTRIBUTE9
                     ,ATTRIBUTE10  */
                 , SYSDATE          AS HISTORY_CREATION_DATE
              FROM SCP_ANL_SHIPMENT_PLAN_FIX
             WHERE ATTRIBUTE1 = 'Y';

            /*  FIX UPDATE */
            UPDATE SCP_ANL_SHIPMENT_PLAN_FIX X   /* FIX_ID, DIVISION_ID, BIZ_TYPE, ITEM_ID, TO_SITE, FROM_SITE, BOD_ID, YYYYMMDD */
               SET X.ATTRIBUTE1 = NULL           /* History 구분을 위해 원상복구 */
             WHERE X.ATTRIBUTE1 = 'Y'
               AND EXISTS ( SELECT 1
                              FROM GT_XPGT_SCP_ANL_SHIPMENT_PLAN_SEMI Y
                             WHERE 0 = 0
                               AND X.DIVISION_ID = Y.DIVISION_ID
                               AND X.BIZ_TYPE    = Y.OPERATION_GROUP
                               AND X.ITEM_ID     = Y.ITEM_ID
                               AND X.TO_SITE     = Y.TO_SITE
                               AND X.FROM_SITE   = Y.FROM_SITE
                               AND X.BOD_ID      = Y.BOD_ID
                               AND X.YYYYMMDD    = Y.YYYYMMDD );

        END IF;

        /* ----------------------------------------------------------------------------------------- */
        /*  SCP_ANL_PRODUCTION_PLAN UPDATE */
        /*  CELL_PROD,PACK_PROD  --> SCP_ANL_PRODUCTION_PLAN.MEASURE 'PROD_PLAN_AMEND' UPDATE */
        /* ----------------------------------------------------------------------------------------- */
        IF V_BATCH_MEASURE IN ('PACK_PROD', 'CELL_PROD') THEN

            /*  IF OBJECT_ID('tempdb..#SCP_ANL_PRODUCTION_PLAN') IS NOT NULL DROP TABLE #SCP_ANL_PRODUCTION_PLAN
                CREATE TABLE #SCP_ANL_PRODUCTION_PLAN(
                    DIVISION_ID NVARCHAR(50), PLAN_START_YYYYMMDD NVARCHAR(8), PLAN_TYPE NVARCHAR(10), SEQ BIGINT
                  , OPERATION_GROUP NVARCHAR(100), SCM_SITE_ID NVARCHAR(50), ITEM_ID NVARCHAR(100)
                  , LINE_ID NVARCHAR(50), OPERATION_ID NVARCHAR(100), MEASURE NVARCHAR(50), YYYYMMDD NVARCHAR(8) */
            DELETE FROM GT_XPGT_SCP_ANL_PRODUCTION_PLAN;

            INSERT INTO GT_XPGT_SCP_ANL_PRODUCTION_PLAN
                 ( DIVISION_ID
                 , PLAN_START_YYYYMMDD
                 , PLAN_TYPE
                 , SEQ
                 , OPERATION_GROUP
                 , SCM_SITE_ID
                 , ITEM_ID
                 , LINE_ID
                 , OPERATION_ID
                 , MEASURE
                 , YYYYMMDD
                 , QTY
                 , ORIGIN_DIVISION_ID
                 , ELECTRODE_TYPE
                 , CELL_QTY
                 , YYYYMMDD_COLUMN )
            SELECT X.DIVISION_ID
                 , X.PLAN_START_YYYYMMDD
                 , X.PLAN_TYPE
                 , X.SEQ
                 , X.OPERATION_GROUP
                 /*  , X.CELL_ITEM_ID */
                 , X.FROM_SITE  AS SCM_SITE_ID
                 , X.ITEM_ID
                 , X.PROD_LINE  AS LINE_ID
                 , X.ATTRIBUTE9 AS OPERATION_ID
                 , 'PROD_PLAN_AMEND' AS MEASURE
                 , Y.YYYYMMDD AS YYYYMMDD
                 , TRUNC(X.QTY) AS QTY
                 , X.DIVISION_ID AS ORIGIN_DIVISION_ID
                 , '' AS ELECTRODE_TYPE
                 , TRUNC(X.CELL_QTY_PACK) AS CELL_QTY
                 , Y.YYYYMMDD_COLUMN
              FROM SCP_XLS_PSI_GLOBAL
                   UNPIVOT
                   (
                    QTY FOR YYYYMMDD_COLUMN IN (
                            QTY001, QTY002, QTY003, QTY004, QTY005, QTY006, QTY007, QTY008, QTY009, QTY010
                          , QTY011, QTY012, QTY013, QTY014, QTY015, QTY016, QTY017, QTY018, QTY019, QTY020
                          , QTY021, QTY022, QTY023, QTY024, QTY025, QTY026, QTY027, QTY028, QTY029, QTY030
                          , QTY031, QTY032, QTY033, QTY034, QTY035, QTY036, QTY037, QTY038, QTY039, QTY040
                          , QTY041, QTY042, QTY043, QTY044, QTY045, QTY046, QTY047, QTY048, QTY049, QTY050
                          , QTY051, QTY052, QTY053, QTY054, QTY055, QTY056, QTY057, QTY058, QTY059, QTY060
                          , QTY061, QTY062, QTY063, QTY064, QTY065, QTY066, QTY067, QTY068, QTY069, QTY070
                          , QTY071, QTY072, QTY073, QTY074, QTY075, QTY076, QTY077, QTY078, QTY079, QTY080
                          , QTY081, QTY082, QTY083, QTY084, QTY085, QTY086, QTY087, QTY088, QTY089, QTY090
                          , QTY091, QTY092, QTY093, QTY094, QTY095, QTY096, QTY097, QTY098, QTY099, QTY100
                          , QTY101, QTY102, QTY103, QTY104, QTY105, QTY106, QTY107, QTY108, QTY109, QTY110
                          , QTY111, QTY112, QTY113, QTY114, QTY115, QTY116, QTY117, QTY118, QTY119, QTY120
                          , QTY121, QTY122, QTY123, QTY124, QTY125, QTY126, QTY127, QTY128, QTY129, QTY130
                          , QTY131, QTY132, QTY133, QTY134, QTY135, QTY136, QTY137, QTY138, QTY139, QTY140
                          , QTY141, QTY142, QTY143, QTY144, QTY145, QTY146, QTY147, QTY148, QTY149, QTY150
                          , QTY151, QTY152, QTY153, QTY154, QTY155, QTY156, QTY157, QTY158, QTY159, QTY160
                          , QTY161, QTY162, QTY163, QTY164, QTY165, QTY166, QTY167, QTY168, QTY169, QTY170
                          , QTY171, QTY172, QTY173, QTY174, QTY175, QTY176, QTY177, QTY178, QTY179, QTY180
                          , QTY181, QTY182, QTY183, QTY184, QTY185, QTY186, QTY187, QTY188, QTY189, QTY190
                          , QTY191, QTY192, QTY193, QTY194, QTY195, QTY196, QTY197, QTY198, QTY199, QTY200
                          , QTY201, QTY202, QTY203, QTY204, QTY205, QTY206, QTY207, QTY208, QTY209, QTY210
                          , QTY211, QTY212, QTY213, QTY214, QTY215, QTY216, QTY217, QTY218, QTY219, QTY220
                          , QTY221, QTY222, QTY223, QTY224, QTY225, QTY226, QTY227, QTY228, QTY229, QTY230
                          , QTY231, QTY232, QTY233, QTY234, QTY235, QTY236, QTY237, QTY238, QTY239, QTY240
                          , QTY241, QTY242, QTY243, QTY244, QTY245, QTY246, QTY247, QTY248, QTY249, QTY250
                          , QTY251, QTY252, QTY253, QTY254, QTY255, QTY256, QTY257, QTY258, QTY259, QTY260
                          , QTY261, QTY262, QTY263, QTY264, QTY265, QTY266, QTY267, QTY268, QTY269, QTY270
                          , QTY271, QTY272, QTY273, QTY274, QTY275, QTY276, QTY277, QTY278, QTY279, QTY280
                          , QTY281, QTY282, QTY283, QTY284, QTY285, QTY286, QTY287, QTY288, QTY289, QTY290
                          , QTY291, QTY292, QTY293, QTY294, QTY295, QTY296, QTY297, QTY298, QTY299, QTY300
                          , QTY301, QTY302, QTY303, QTY304, QTY305, QTY306, QTY307, QTY308, QTY309, QTY310
                          , QTY311, QTY312, QTY313, QTY314, QTY315, QTY316, QTY317, QTY318, QTY319, QTY320
                          , QTY321, QTY322, QTY323, QTY324, QTY325, QTY326, QTY327, QTY328, QTY329, QTY330
                          , QTY331, QTY332, QTY333, QTY334, QTY335, QTY336, QTY337, QTY338, QTY339, QTY340
                          , QTY341, QTY342, QTY343, QTY344, QTY345, QTY346, QTY347, QTY348, QTY349, QTY350
                          , QTY351, QTY352, QTY353, QTY354, QTY355, QTY356, QTY357, QTY358, QTY359, QTY360
                          , QTY361, QTY362, QTY363, QTY364
                       )
                   ) X
                 , ( SELECT A.BASIS_YYYYMMDD AS YYYYMMDD
                                     /*  MSSQL 'QTY' + REPLICATE('0', 3 - LEN(ROW_NUMBER() OVER(..))) + CONVERT(NVARCHAR, ROW_NUMBER() OVER(..)) */
                                     , 'QTY' || LPAD(TO_CHAR(ROW_NUMBER() OVER(ORDER BY A.BASIS_YYYYMMDD)), 3, '0') AS YYYYMMDD_COLUMN
                                  FROM SCM_SYS_CALENDAR_M A
                                 WHERE A.BASIS_YYYYMMDD BETWEEN V_BATCH_CREATE_FROM_YYYYMMDD AND V_BATCH_CREATE_TO_YYYYMMDD
                                   /*  WHERE A.BASIS_YYYYMMDD >= @v_batch_create_from_yyyymmdd
                                         AND A.BASIS_YYYYMMDD <  @v_batch_create_to_yyyymmdd */
                              ) Y
             WHERE 1 = 1
               AND X.YYYYMMDD_COLUMN = Y.YYYYMMDD_COLUMN
               AND X.DIVISION_ID          = V_BATCH_DIVISION_ID
               AND X.PLAN_START_YYYYMMDD  = V_BATCH_PLAN_START_YYYYMMDD
               AND X.CREATE_FROM_YYYYMMDD = V_BATCH_CREATE_FROM_YYYYMMDD
               AND X.SEQ                  = V_BATCH_SEQ
               AND X.XLS_KEY1             = V_BATCH_XLS_KEY1   /* 43 */
               AND X.MEASURE              IN ('PACK_PROD', 'CELL_PROD');

            /* ------------------------------------------------------------------------------------- */
            /*  FROZEN 구간 UPDATE */
            /*  PLANT SITE(SCM_MST_SITE)의 SHIP_FROZEN ,PROD_FROZEN를 주단위로 변경하여 FROZEN 구간을 저장 내역에서 삭제한다. */
            /* ------------------------------------------------------------------------------------- start */
            /*  2020.10.28   KSW   C20201019-000175   SCP-FP 협의사항 수정반영 요청 (화 -> 수)
                - 자동차(81) 사업부의 경우 Final Plan 제외하고 전 구간 생산계획 수정 가능
                PRODUCTION_PLAN 저장시 Frozen 구간 체크하지 않음 (MA plan 한함)
                주석처리 :: Frozen 구간에 속한 플랜 data 를 삭제하지 않음 */
            /* [2023.05.03    KSK    UI / Simulator에서 SE 단계에서 Prod Frozen 구간 수정 방지 ]========================= */
            IF V_BATCH_PLAN_TYPE IN ('SE') THEN
                /*  MSSQL DELETE FROM #T FROM #T X INNER JOIN #S Y ON .. WHERE .. -> DELETE .. WHERE EXISTS (CV-063). */
                DELETE FROM GT_XPGT_SCP_ANL_PRODUCTION_PLAN X
                 WHERE EXISTS ( SELECT 1
                                  FROM GT_XPGT_SCM_MST_SITE Y
                                 WHERE Y.DIVISION_ID = X.DIVISION_ID
                                   AND Y.SCM_SITE_ID = X.SCM_SITE_ID
                                   AND X.YYYYMMDD    < Y.PROD_FROZEN_WEEK_DAY );   /* 동결구간의 익일 */
            END IF;
            /* ==========================================================================================[2023.05.03] */
            /* ------------------------------------------------------------------------------------- */
            /*  2020.10.28   KSW   C20201019-000175   SCP-FP 협의사항 수정반영 요청 (화 -> 수) */
            /* ------------------------------------------------------------------------------------- end */

            /*  PROD_PLAN_AMEND */
            /*  MSSQL : INSERT INTO SCP_ANL_PRODUCTION_PLAN (..) SELECT .. FROM ( MERGE .. OUTPUT $action, Inserted.* )
                AS Changes(..) WHERE Action = 'INSERT'   (composable DML - Oracle 무대응)
                = MERGE 로 실제 INSERT 된 행마다 MEASURE='PROD_PLAN_ENGINE', QTY=0 짝 행을 하나 더 넣는 로직이다.
                MERGE 가 INSERT 할 집합 = ON 절에 매칭되지 않는 원천행이므로, 같은 조건을 NOT EXISTS 로 뽑아
                MERGE 직전에 짝 행을 먼저 INSERT 한다. 짝 행의 MEASURE 는 'PROD_PLAN_ENGINE' 이고
                ON 절/PK 모두 MEASURE 를 포함하므로 뒤따르는 MERGE 의 매칭 결과에 영향을 주지 않는다(1:1 등가). */
            /*  INSERT 일경우 PROD_PLAN_ENGINE/PROD_PLAN_AMEND 쌍으로 입력한다. */
            INSERT INTO SCP_ANL_PRODUCTION_PLAN
                 ( DIVISION_ID
                 , PLAN_START_YYYYMMDD
                 , PLAN_TYPE
                 , SEQ
                 , OPERATION_GROUP
                 /*  , CELL_ITEM_ID */
                 , SCM_SITE_ID
                 , ITEM_ID
                 , LINE_ID
                 , OPERATION_ID
                 , MEASURE
                 , YYYYMMDD
                 , QTY
                 , ORIGIN_DIVISION_ID
                 , ELECTRODE_TYPE
                 , CELL_QTY
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE )
            SELECT Y.DIVISION_ID
                 , Y.PLAN_START_YYYYMMDD
                 , Y.PLAN_TYPE
                 , Y.SEQ
                 , Y.OPERATION_GROUP
                 /*  , Inserted.CELL_ITEM_ID */
                 , Y.SCM_SITE_ID
                 , Y.ITEM_ID
                 , Y.LINE_ID
                 , Y.OPERATION_ID
                 , 'PROD_PLAN_ENGINE' AS MEASURE
                 , Y.YYYYMMDD
                 , 0 AS QTY
                 , Y.ORIGIN_DIVISION_ID
                 , Y.ELECTRODE_TYPE
                 , Y.CELL_QTY
                 , V_BATCH_USER_SIM AS CREATED_BY
                 , SYSDATE          AS CREATION_DATE
                 , V_BATCH_USER_SIM AS LAST_UPDATED_BY
                 , SYSDATE          AS LAST_UPDATE_DATE
              FROM GT_XPGT_SCP_ANL_PRODUCTION_PLAN Y
             WHERE NOT EXISTS ( SELECT 1
                                  FROM SCP_ANL_PRODUCTION_PLAN X
                                 WHERE 0 = 0
                                 AND X.DIVISION_ID         = Y.DIVISION_ID          /* --@v_batch_division_id -- 2021.10.25 튜닝개선요청에 따른 변경 */
                                 AND X.PLAN_START_YYYYMMDD = Y.PLAN_START_YYYYMMDD  /* --@v_batch_plan_start_yyyymmdd */
                                 AND X.PLAN_TYPE           = Y.PLAN_TYPE            /* --@v_batch_plan_type */
                                 AND X.SEQ                 = Y.SEQ                  /* --@v_batch_seq */
                                 AND X.OPERATION_GROUP     = Y.OPERATION_GROUP
                                 AND X.SCM_SITE_ID         = Y.SCM_SITE_ID
                                 AND X.ITEM_ID             = Y.ITEM_ID
                                 AND X.MEASURE             = Y.MEASURE
                                 AND X.YYYYMMDD            = Y.YYYYMMDD
                                 AND X.LINE_ID             = Y.LINE_ID
                                 AND X.OPERATION_ID        = Y.OPERATION_ID
                                 AND X.ORIGIN_DIVISION_ID  = Y.ORIGIN_DIVISION_ID
                                 /*                                     NULL = NULL 이 UNKNOWN 이 되어 전건 미매칭 -> 중복 INSERT(ORA-00001)로 이어진다. */
                                 AND NVL(X.ELECTRODE_TYPE, ' ') = NVL(Y.ELECTRODE_TYPE, ' ')
                              );

            /*                원천 GTT 는 (XLS_KEY1 1행) x (YYYYMMDD) 라 ON 키당 1행이므로 ORA-30926 도 없다. */
            MERGE INTO SCP_ANL_PRODUCTION_PLAN X
            USING GT_XPGT_SCP_ANL_PRODUCTION_PLAN Y
               ON ( 0 = 0
                    AND X.DIVISION_ID         = Y.DIVISION_ID          /* --@v_batch_division_id -- 2021.10.25 튜닝개선요청에 따른 변경 */
                    AND X.PLAN_START_YYYYMMDD = Y.PLAN_START_YYYYMMDD  /* --@v_batch_plan_start_yyyymmdd */
                    AND X.PLAN_TYPE           = Y.PLAN_TYPE            /* --@v_batch_plan_type */
                    AND X.SEQ                 = Y.SEQ                  /* --@v_batch_seq */
                    AND X.OPERATION_GROUP     = Y.OPERATION_GROUP
                    AND X.SCM_SITE_ID         = Y.SCM_SITE_ID
                    AND X.ITEM_ID             = Y.ITEM_ID
                    AND X.MEASURE             = Y.MEASURE
                    AND X.YYYYMMDD            = Y.YYYYMMDD
                    AND X.LINE_ID             = Y.LINE_ID
                    AND X.OPERATION_ID        = Y.OPERATION_ID
                    AND X.ORIGIN_DIVISION_ID  = Y.ORIGIN_DIVISION_ID
                    /*                        NULL = NULL 이 UNKNOWN 이 되어 전건 미매칭 -> 중복 INSERT(ORA-00001)로 이어진다. */
                    AND NVL(X.ELECTRODE_TYPE, ' ') = NVL(Y.ELECTRODE_TYPE, ' ')
                  )
            WHEN MATCHED THEN
            UPDATE
               SET X.QTY              = Y.QTY
                 /*  , X.CREATED_BY    = @v_batch_user_sim
                     , X.CREATION_DATE = GETDATE() */
                 , X.LAST_UPDATED_BY  = V_BATCH_USER_SIM
                 , X.LAST_UPDATE_DATE = SYSDATE
            WHEN NOT MATCHED THEN
            INSERT ( DIVISION_ID
                   , PLAN_START_YYYYMMDD
                   , PLAN_TYPE
                   , SEQ
                   , OPERATION_GROUP
                   /*  , CELL_ITEM_ID */
                   , SCM_SITE_ID
                   , ITEM_ID
                   , LINE_ID
                   , OPERATION_ID
                   , MEASURE
                   , YYYYMMDD
                   , QTY
                   , ORIGIN_DIVISION_ID
                   , ELECTRODE_TYPE
                   , CELL_QTY
                   , CREATED_BY
                   , CREATION_DATE
                   , LAST_UPDATED_BY
                   , LAST_UPDATE_DATE )
            VALUES ( Y.DIVISION_ID
                   , Y.PLAN_START_YYYYMMDD
                   , Y.PLAN_TYPE
                   , Y.SEQ
                   , Y.OPERATION_GROUP
                   /*  , Y.CELL_ITEM_ID */
                   , Y.SCM_SITE_ID
                   , Y.ITEM_ID
                   , Y.LINE_ID
                   , Y.OPERATION_ID
                   , Y.MEASURE
                   , Y.YYYYMMDD
                   , Y.QTY
                   , Y.ORIGIN_DIVISION_ID
                   , Y.ELECTRODE_TYPE
                   , Y.CELL_QTY
                   , V_BATCH_USER_SIM
                   , SYSDATE
                   , V_BATCH_USER_SIM
                   , SYSDATE );

            /* ------------------------------------------------------------------------------------- */
            /*  SCP_ANL_PRODUCTION_PLAN_H : History 입력 */
            /* ------------------------------------------------------------------------------------- */
            /*  SELECT top 10 * FROM dbo.SCP_ANL_PRODUCTION_PLAN_H WITH (NOLOCK)     -- HISTORY_SEQ */
            /*  SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_H */
            INSERT INTO SCP_ANL_PRODUCTION_PLAN_H
                 ( HISTORY_SEQ
                 , DIVISION_ID
                 , PLAN_START_YYYYMMDD
                 , PLAN_TYPE
                 , SEQ
                 , OPERATION_GROUP
                 , SCM_SITE_ID
                 , ITEM_ID
                 , LINE_ID
                 , OPERATION_ID
                 , MEASURE
                 , YYYYMMDD
                 , QTY
                 , ORIGIN_DIVISION_ID
                 , ELECTRODE_TYPE
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE
                 /*  ,ATTRIBUTE1
                     ,ATTRIBUTE2
                     ,ATTRIBUTE3
                     ,ATTRIBUTE4
                     ,ATTRIBUTE5
                     ,ATTRIBUTE6
                     ,ATTRIBUTE7
                     ,ATTRIBUTE8
                     ,ATTRIBUTE9
                     ,ATTRIBUTE10  */
                 , HISTORY_CREATION_DATE )
            SELECT SEQ1_SCP_ANL_PRODUCTION_PLAN_H.NEXTVAL
                 , DIVISION_ID
                 , PLAN_START_YYYYMMDD
                 , PLAN_TYPE
                 , SEQ
                 , OPERATION_GROUP
                 , SCM_SITE_ID
                 , ITEM_ID
                 , LINE_ID
                 , OPERATION_ID
                 , MEASURE
                 , YYYYMMDD
                 , QTY
                 , ORIGIN_DIVISION_ID
                 , ELECTRODE_TYPE
                 , V_BATCH_USER_SIM AS CREATED_BY
                 , SYSDATE          AS CREATION_DATE
                 , V_BATCH_USER_SIM AS LAST_UPDATED_BY
                 , SYSDATE          AS LAST_UPDATE_DATE
                 /*  ,ATTRIBUTE1
                     ,ATTRIBUTE2
                     ,ATTRIBUTE3
                     ,ATTRIBUTE4
                     ,ATTRIBUTE5
                     ,ATTRIBUTE6
                     ,ATTRIBUTE7
                     ,ATTRIBUTE8
                     ,ATTRIBUTE9
                     ,ATTRIBUTE10  */
                 , SYSDATE          AS HISTORY_CREATION_DATE
              FROM GT_XPGT_SCP_ANL_PRODUCTION_PLAN;

            /* ------------------------------------------------------------------------------------- */
            /*  SCP_ANL_PRODUCTION_PLAN_FIX : FIX 입력 */
            /* ------------------------------------------------------------------------------------- */
            /*  MSSQL UPDATE X SET .. FROM SCP_ANL_PRODUCTION_PLAN_FIX X INNER JOIN #T Y ON .. */
            UPDATE SCP_ANL_PRODUCTION_PLAN_FIX X   /* FIX_ID, DIVISION_ID, OPERATION_GROUP, SCM_SITE_ID, ITEM_ID, LINE_ID, OPERATION_ID, YYYYMMDD */
               SET X.QTY              = ( SELECT Y.QTY
                                            FROM GT_XPGT_SCP_ANL_PRODUCTION_PLAN Y
                                           WHERE 0 = 0
                                             AND X.DIVISION_ID     = Y.DIVISION_ID
                                             AND X.OPERATION_GROUP = Y.OPERATION_GROUP
                                             AND X.SCM_SITE_ID     = Y.SCM_SITE_ID
                                             AND X.ITEM_ID         = Y.ITEM_ID
                                             AND X.LINE_ID         = Y.LINE_ID
                                             AND X.OPERATION_ID    = Y.OPERATION_ID
                                             AND X.YYYYMMDD        = Y.YYYYMMDD
                                             AND ROWNUM            = 1 )
                 , X.ATTRIBUTE1       = 'Y'
                 , X.FIX_REASON       = 'SIMULATION UPDATE'
                 , X.LAST_UPDATED_BY  = V_BATCH_USER_SIM
                 , X.LAST_UPDATE_DATE = SYSDATE
             WHERE EXISTS ( SELECT 1
                              FROM GT_XPGT_SCP_ANL_PRODUCTION_PLAN Y
                             WHERE 0 = 0
                               AND X.DIVISION_ID     = Y.DIVISION_ID
                               AND X.OPERATION_GROUP = Y.OPERATION_GROUP
                               AND X.SCM_SITE_ID     = Y.SCM_SITE_ID
                               AND X.ITEM_ID         = Y.ITEM_ID
                               AND X.LINE_ID         = Y.LINE_ID
                               AND X.OPERATION_ID    = Y.OPERATION_ID
                               AND X.YYYYMMDD        = Y.YYYYMMDD );

            /* ------------------------------------------------------------------------------------- */
            /*  SCP_ANL_PRODUCTION_PLAN_FIX : FIX History 입력 */
            /* ------------------------------------------------------------------------------------- */
            /*  SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H
                SELECT NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H */
            INSERT INTO SCP_ANL_PRODUCTION_PLAN_FIX_H
                 ( HISTORY_SEQ
                 , FIX_ID
                 , DIVISION_ID
                 , OPERATION_GROUP
                 , SCM_SITE_ID
                 , ITEM_ID
                 , LINE_ID
                 , OPERATION_ID
                 , YYYYMMDD
                 , QTY
                 , FIX_REASON
                 , ORIGIN_DIVISION_ID
                 , ELECTRODE_TYPE
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE
                 /*  ,ATTRIBUTE1
                     ,ATTRIBUTE2
                     ,ATTRIBUTE3
                     ,ATTRIBUTE4
                     ,ATTRIBUTE5
                     ,ATTRIBUTE6
                     ,ATTRIBUTE7
                     ,ATTRIBUTE8
                     ,ATTRIBUTE9
                     ,ATTRIBUTE10  */
                 , HISTORY_CREATION_DATE )
            SELECT SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H.NEXTVAL
                 , FIX_ID
                 , DIVISION_ID
                 , OPERATION_GROUP
                 , SCM_SITE_ID
                 , ITEM_ID
                 , LINE_ID
                 , OPERATION_ID
                 , YYYYMMDD
                 , QTY
                 , FIX_REASON
                 , ORIGIN_DIVISION_ID
                 , ELECTRODE_TYPE
                 , V_BATCH_USER_SIM AS CREATED_BY
                 , SYSDATE          AS CREATION_DATE
                 , V_BATCH_USER_SIM AS LAST_UPDATED_BY
                 , SYSDATE          AS LAST_UPDATE_DATE
                 /*  ,ATTRIBUTE1
                     ,ATTRIBUTE2
                     ,ATTRIBUTE3
                     ,ATTRIBUTE4
                     ,ATTRIBUTE5
                     ,ATTRIBUTE6
                     ,ATTRIBUTE7
                     ,ATTRIBUTE8
                     ,ATTRIBUTE9
                     ,ATTRIBUTE10  */
                 , SYSDATE          AS HISTORY_CREATION_DATE
              FROM SCP_ANL_PRODUCTION_PLAN_FIX
             WHERE ATTRIBUTE1 = 'Y';

            UPDATE SCP_ANL_PRODUCTION_PLAN_FIX X   /* FIX_ID, DIVISION_ID, OPERATION_GROUP, SCM_SITE_ID, ITEM_ID, LINE_ID, OPERATION_ID, YYYYMMDD */
               SET X.ATTRIBUTE1 = NULL             /* History 구분을 위해 원상복구 */
             WHERE X.ATTRIBUTE1 = 'Y'
               AND EXISTS ( SELECT 1
                              FROM GT_XPGT_SCP_ANL_PRODUCTION_PLAN Y
                             WHERE 0 = 0
                               AND X.DIVISION_ID     = Y.DIVISION_ID
                               AND X.OPERATION_GROUP = Y.OPERATION_GROUP
                               AND X.SCM_SITE_ID     = Y.SCM_SITE_ID
                               AND X.ITEM_ID         = Y.ITEM_ID
                               AND X.LINE_ID         = Y.LINE_ID
                               AND X.OPERATION_ID    = Y.OPERATION_ID
                               AND X.YYYYMMDD        = Y.YYYYMMDD );

        END IF;

        /* ------------------------------------------------------- */
        /*  FROZEN 구간 복구 */
        /* ------------------------------------------------------- */
        /* ----------------------------------------------------------------------------------------- */
        /*  전체 임시 테이블 생성  (#SCP_XLS_PSI_GLOBAL_MODIFY) */
        /* ----------------------------------------------------------------------------------------- */
        /*  IF OBJECT_ID('tempdb..#SCP_XLS_PSI_GLOBAL_MODIFY') IS NOT NULL DROP TABLE #SCP_XLS_PSI_GLOBAL_MODIFY
            CREATE TABLE #SCP_XLS_PSI_GLOBAL_MODIFY(
                XLS_KEY1 INT NOT NULL, DIVISION_ID NVARCHAR(30) NOT NULL, CREATE_FROM_YYYYMMDD NVARCHAR(8) NOT NULL,
            ★공유 GTT 라 컬럼목록 없는 INSERT 를 쓰지 않고 367컬럼을 명시한다. */
        DELETE FROM GT_XPGT_SCP_XLS_PSI_GLOBAL_MODIFY;

        /*  SCP_ANL_SHIPMENT_PLAN_FG/SEMI PK Parameter, SCP_ANL_PRODUCTION_PLAN PK Parameter
            (원본 L2561~L2573 DECLARE 는 선언부로 이동) */
        /*  MSSQL 대입형 SELECT -> 커서 FOR 루프 (0행이면 기존값 유지) */
        FOR R IN ( SELECT OPERATION_GROUP
                        , ITEM_ID
                        , PROD_LINE
                        , ATTRIBUTE9
                        , PROJECT_CODE
                        , TO_SITE
                        , INCOTERMS
                        , FROM_SITE
                        , BOD_ID
                     FROM SCP_XLS_PSI_GLOBAL
                    WHERE XLS_KEY1             = V_BATCH_XLS_KEY1
                      AND CREATE_FROM_YYYYMMDD = V_BATCH_CREATE_FROM_YYYYMMDD
                      AND DIVISION_ID          = V_BATCH_DIVISION_ID   /* 2022.03.23 KSW GM JV 반영 */
                 )
        LOOP

            V_X_OPERATION_GROUP := SUBSTR(R.OPERATION_GROUP, 1, 50);
            V_X_ITEM_ID         := SUBSTR(R.ITEM_ID, 1, 50);
            V_X_LINE_ID         := SUBSTR(R.PROD_LINE, 1, 50);
            V_X_OPERATION_ID    := SUBSTR(R.ATTRIBUTE9, 1, 50);
            V_X_PROJECT_CODE    := SUBSTR(R.PROJECT_CODE, 1, 50);
            V_X_TO_SITE         := SUBSTR(R.TO_SITE, 1, 50);
            V_X_INCOTERMS       := SUBSTR(R.INCOTERMS, 1, 50);
            V_X_FROM_SITE       := SUBSTR(R.FROM_SITE, 1, 50);
            V_X_BOD_ID          := SUBSTR(R.BOD_ID, 1, 50);
        END LOOP;

        IF V_BATCH_MEASURE <> 'CELL_CHAR_PLAN' THEN
            /*  IF OBJECT_ID('tempdb..#SCP_XLS_PSI_GLOBAL_MODIFY_ROW') IS NOT NULL DROP TABLE #SCP_XLS_PSI_GLOBAL_MODIFY_ROW;
                CREATE TABLE #SCP_XLS_PSI_GLOBAL_MODIFY_ROW(
                    YYYYMMDD VARCHAR(20) NOT NULL, QTY NUMERIC(20,10) NOT NULL, COLS_NAME NVARCHAR(30) NOT NULL ); */
            DELETE FROM GT_XPGT_SCP_XLS_PSI_GLOBAL_MODIFY_ROW;

            IF V_BATCH_MEASURE = 'SHIP_PLAN' THEN   /* FG */
                INSERT INTO GT_XPGT_SCP_XLS_PSI_GLOBAL_MODIFY_ROW ( YYYYMMDD, QTY, COLS_NAME )
                SELECT A.YYYYMMDD
                     , A.QTY
                     , B.COLS_NAME
                  FROM SCP_ANL_SHIPMENT_PLAN_FG A
                    , ( SELECT ROW_NUMBER() OVER(ORDER BY A.BASIS_YYYYMMDD) AS SORT_SEQ
                             /*  MSSQL 'QTY' + REPLICATE('0', 3 - LEN(ROW_NUMBER() OVER(..))) + CONVERT(NVARCHAR, ROW_NUMBER() OVER(..)) */
                             , 'QTY' || LPAD(TO_CHAR(ROW_NUMBER() OVER(ORDER BY A.BASIS_YYYYMMDD)), 3, '0') AS COLS_NAME
                             , A.BASIS_YYYYMMDD          AS YYYYMMDD
                             /*  MSSQL A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 31) -> A.BASIS_YYYYMMDD || '31' */
                             , A.BASIS_YYYYMMDD || '31'  AS SORT_ORDER_NO
                          FROM SCM_SYS_CALENDAR_M A
                         WHERE A.BASIS_YYYYMMDD BETWEEN V_BATCH_CREATE_FROM_YYYYMMDD
                                                    AND TO_CHAR(TO_DATE(V_BATCH_CREATE_FROM_YYYYMMDD, 'YYYYMMDD') + 364, 'YYYYMMDD')   /* @v_batch_create_to_yyyymmdd */
                         GROUP BY A.BASIS_YYYYMMDD
                      ) B
                 WHERE 0 = 0
                   AND A.YYYYMMDD            = B.YYYYMMDD
                   AND A.PLAN_START_YYYYMMDD = V_BATCH_PLAN_START_YYYYMMDD
                   AND A.PLAN_TYPE           = V_BATCH_PLAN_TYPE
                   AND A.SEQ                 = V_BATCH_SEQ
                   AND A.DIVISION_ID         = V_BATCH_DIVISION_ID
                   AND A.YYYYMMDD            < V_BATCH_CREATE_TO_YYYYMMDD
                   AND A.BIZ_TYPE            = V_X_OPERATION_GROUP
                   AND A.ITEM_ID             = V_X_ITEM_ID
                   AND A.PROJECT_CODE        = V_X_PROJECT_CODE
                   AND A.TO_SITE             = V_X_TO_SITE
                   AND A.INCOTERMS           = V_X_INCOTERMS
                   AND A.FROM_SITE           = V_X_FROM_SITE
                   AND A.BOD_ID              = V_X_BOD_ID
                   AND A.MEASURE             = 'SHIP_PLAN_AMEND'
                   AND A.QTY                 <> 0.0;
            END IF;

            IF V_BATCH_MEASURE = 'SEMI_SHIP_PLAN' THEN   /* SEMI */
                INSERT INTO GT_XPGT_SCP_XLS_PSI_GLOBAL_MODIFY_ROW ( YYYYMMDD, QTY, COLS_NAME )
                SELECT A.YYYYMMDD
                     , A.QTY
                     , B.COLS_NAME
                  FROM SCP_ANL_SHIPMENT_PLAN_SEMI A
                    , ( SELECT ROW_NUMBER() OVER(ORDER BY A.BASIS_YYYYMMDD) AS SORT_SEQ
                             /*  MSSQL 'QTY' + REPLICATE('0', 3 - LEN(ROW_NUMBER() OVER(..))) + CONVERT(NVARCHAR, ROW_NUMBER() OVER(..)) */
                             , 'QTY' || LPAD(TO_CHAR(ROW_NUMBER() OVER(ORDER BY A.BASIS_YYYYMMDD)), 3, '0') AS COLS_NAME
                             , A.BASIS_YYYYMMDD          AS YYYYMMDD
                             /*  MSSQL A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 31) -> A.BASIS_YYYYMMDD || '31' */
                             , A.BASIS_YYYYMMDD || '31'  AS SORT_ORDER_NO
                          FROM SCM_SYS_CALENDAR_M A
                         WHERE A.BASIS_YYYYMMDD BETWEEN V_BATCH_CREATE_FROM_YYYYMMDD
                                                    AND TO_CHAR(TO_DATE(V_BATCH_CREATE_FROM_YYYYMMDD, 'YYYYMMDD') + 364, 'YYYYMMDD')   /* @v_batch_create_to_yyyymmdd */
                         GROUP BY A.BASIS_YYYYMMDD
                      ) B
                 WHERE 0 = 0
                   AND A.YYYYMMDD            = B.YYYYMMDD
                   AND A.DIVISION_ID         = V_BATCH_DIVISION_ID
                   AND A.PLAN_START_YYYYMMDD = V_BATCH_PLAN_START_YYYYMMDD
                   AND A.PLAN_TYPE           = V_BATCH_PLAN_TYPE
                   AND A.SEQ                 = V_BATCH_SEQ
                   AND A.OPERATION_GROUP     = V_X_OPERATION_GROUP
                   AND A.ITEM_ID             = V_X_ITEM_ID
                   AND A.FROM_SITE           = V_X_FROM_SITE
                   AND A.BOD_ID              = V_X_BOD_ID
                   AND A.MEASURE             = 'SHIP_PLAN_AMEND'
                   AND A.YYYYMMDD            < V_BATCH_CREATE_TO_YYYYMMDD
                   AND A.QTY                 <> 0;
            END IF;

            /* ------------------------------------------------------------------------------------- */
            /*   'PACK_PROD','CELL_PROD'
                 PK : DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, SCM_SITE_ID, ITEM_ID, LINE_ID, OPERATION_ID, MEASURE, YYYYMMDD
               (원본 L2670~L2694 : @mPROD 동적 SQL 死코드 블록. 전량 주석) */
            /* ------------------------------------------------------------------------------------- */
            /*  DECLARE @mPROD NVARCHAR(MAX) = '';
                SET @mPROD = @mPROD + ' SELECT  '''+ convert(varchar, @v_batch_xls_key1)  +''' AS XLS_KEY1  '+CHAR(10);
                SET @mPROD = @mPROD + '         ,'''+ convert(varchar, @v_batch_division_id)  +''' AS DIVISION_ID  '+CHAR(10);
                SET @mPROD = @mPROD + '         ,'''+ convert(varchar, @v_batch_create_from_yyyymmdd)  +''' AS CREATE_FROM_YYYYMMDD  '+CHAR(10);
                SET @mPROD = @mPROD + '                 ' + @mQry_sum2 +'   '+CHAR(10);
                SET @mPROD = @mPROD + '         FROM SCP_ANL_PRODUCTION_PLAN WITH (NOLOCK)  '+CHAR(10);
                SET @mPROD = @mPROD + '         WHERE 0 = 0                                 '+CHAR(10);
                SET @mPROD = @mPROD + '         AND DIVISION_ID         =  '''+ @v_batch_division_id  +'''' +CHAR(10);
                SET @mPROD = @mPROD + '         AND PLAN_START_YYYYMMDD =  '''+ @v_batch_plan_start_yyyymmdd+'''' +CHAR(10);
                SET @mPROD = @mPROD + '     AND PLAN_TYPE           =  '''+ @v_batch_plan_type  +'''' +CHAR(10);
                SET @mPROD = @mPROD + '         AND SEQ                 =  '+ CONVERT(NVARCHAR,@v_batch_seq)+'' +CHAR(10);
                SET @mPROD = @mPROD + '         AND OPERATION_GROUP     =  '''+ @X_OPERATION_GROUP+'''' +CHAR(10);
                SET @mPROD = @mPROD + '         AND SCM_SITE_ID         =  '''+ @X_FROM_SITE+'''' +CHAR(10);
                SET @mPROD = @mPROD + '         AND ITEM_ID             =  '''+ @X_ITEM_ID+'''' +CHAR(10);
                SET @mPROD = @mPROD + '         AND LINE_ID             =  '''+ @X_LINE_ID+'''' +CHAR(10);
                SET @mPROD = @mPROD + '         AND OPERATION_ID        =  '''+ @X_OPERATION_ID+'''' +CHAR(10);
                SET @mPROD = @mPROD + '         AND MEASURE             = ''PROD_PLAN_AMEND'' '+CHAR(10);
                SET @mPROD = @mPROD + '         AND YYYYMMDD            <  '''+ @v_batch_create_to_yyyymmdd +''''+CHAR(10); */
            /* ------------------------------------------------------------------------------------- */

            IF V_BATCH_MEASURE IN ('PACK_PROD', 'CELL_PROD') THEN   /* PROD */
                INSERT INTO GT_XPGT_SCP_XLS_PSI_GLOBAL_MODIFY_ROW ( YYYYMMDD, QTY, COLS_NAME )
                SELECT A.YYYYMMDD
                     , A.QTY
                     , B.COLS_NAME
                  FROM SCP_ANL_PRODUCTION_PLAN A
                    , ( SELECT ROW_NUMBER() OVER(ORDER BY A.BASIS_YYYYMMDD) AS SORT_SEQ
                             /*  MSSQL 'QTY' + REPLICATE('0', 3 - LEN(ROW_NUMBER() OVER(..))) + CONVERT(NVARCHAR, ROW_NUMBER() OVER(..)) */
                             , 'QTY' || LPAD(TO_CHAR(ROW_NUMBER() OVER(ORDER BY A.BASIS_YYYYMMDD)), 3, '0') AS COLS_NAME
                             , A.BASIS_YYYYMMDD          AS YYYYMMDD
                             /*  MSSQL A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 31) -> A.BASIS_YYYYMMDD || '31' */
                             , A.BASIS_YYYYMMDD || '31'  AS SORT_ORDER_NO
                          FROM SCM_SYS_CALENDAR_M A
                         WHERE A.BASIS_YYYYMMDD BETWEEN V_BATCH_CREATE_FROM_YYYYMMDD
                                                    AND TO_CHAR(TO_DATE(V_BATCH_CREATE_FROM_YYYYMMDD, 'YYYYMMDD') + 364, 'YYYYMMDD')   /* @v_batch_create_to_yyyymmdd */
                         GROUP BY A.BASIS_YYYYMMDD
                      ) B
                 WHERE 0 = 0
                   AND A.YYYYMMDD            = B.YYYYMMDD
                   AND A.DIVISION_ID         = V_BATCH_DIVISION_ID
                   AND A.PLAN_START_YYYYMMDD = V_BATCH_PLAN_START_YYYYMMDD
                   AND A.PLAN_TYPE           = V_BATCH_PLAN_TYPE
                   AND A.SEQ                 = V_BATCH_SEQ
                   AND A.OPERATION_GROUP     = V_X_OPERATION_GROUP
                   AND A.SCM_SITE_ID         = V_X_FROM_SITE
                   AND A.ITEM_ID             = V_X_ITEM_ID
                   AND A.LINE_ID             = V_X_LINE_ID
                   AND A.OPERATION_ID        = V_X_OPERATION_ID
                   AND A.MEASURE             = 'PROD_PLAN_AMEND'
                   AND A.YYYYMMDD            < V_BATCH_CREATE_TO_YYYYMMDD
                   AND A.QTY                 <> 0;
            END IF;

            IF V_BATCH_MEASURE <> 'PACK_MODEL_CHANGE' AND V_BATCH_MEASURE <> 'CELL_MODEL_CHANGE' THEN
                /*  MSSQL INSERT INTO #T WITH (TABLOCK) SELECT .. -> Oracle 힌트 대응 없음(제거). */
                INSERT INTO GT_XPGT_SCP_XLS_PSI_GLOBAL_MODIFY
                     ( XLS_KEY1
                     , DIVISION_ID
                     , CREATE_FROM_YYYYMMDD
                     , QTY001, QTY002, QTY003, QTY004, QTY005, QTY006, QTY007, QTY008
                     , QTY009, QTY010, QTY011, QTY012, QTY013, QTY014, QTY015, QTY016
                     , QTY017, QTY018, QTY019, QTY020, QTY021, QTY022, QTY023, QTY024
                     , QTY025, QTY026, QTY027, QTY028, QTY029, QTY030, QTY031, QTY032
                     , QTY033, QTY034, QTY035, QTY036, QTY037, QTY038, QTY039, QTY040
                     , QTY041, QTY042, QTY043, QTY044, QTY045, QTY046, QTY047, QTY048
                     , QTY049, QTY050, QTY051, QTY052, QTY053, QTY054, QTY055, QTY056
                     , QTY057, QTY058, QTY059, QTY060, QTY061, QTY062, QTY063, QTY064
                     , QTY065, QTY066, QTY067, QTY068, QTY069, QTY070, QTY071, QTY072
                     , QTY073, QTY074, QTY075, QTY076, QTY077, QTY078, QTY079, QTY080
                     , QTY081, QTY082, QTY083, QTY084, QTY085, QTY086, QTY087, QTY088
                     , QTY089, QTY090, QTY091, QTY092, QTY093, QTY094, QTY095, QTY096
                     , QTY097, QTY098, QTY099, QTY100, QTY101, QTY102, QTY103, QTY104
                     , QTY105, QTY106, QTY107, QTY108, QTY109, QTY110, QTY111, QTY112
                     , QTY113, QTY114, QTY115, QTY116, QTY117, QTY118, QTY119, QTY120
                     , QTY121, QTY122, QTY123, QTY124, QTY125, QTY126, QTY127, QTY128
                     , QTY129, QTY130, QTY131, QTY132, QTY133, QTY134, QTY135, QTY136
                     , QTY137, QTY138, QTY139, QTY140, QTY141, QTY142, QTY143, QTY144
                     , QTY145, QTY146, QTY147, QTY148, QTY149, QTY150, QTY151, QTY152
                     , QTY153, QTY154, QTY155, QTY156, QTY157, QTY158, QTY159, QTY160
                     , QTY161, QTY162, QTY163, QTY164, QTY165, QTY166, QTY167, QTY168
                     , QTY169, QTY170, QTY171, QTY172, QTY173, QTY174, QTY175, QTY176
                     , QTY177, QTY178, QTY179, QTY180, QTY181, QTY182, QTY183, QTY184
                     , QTY185, QTY186, QTY187, QTY188, QTY189, QTY190, QTY191, QTY192
                     , QTY193, QTY194, QTY195, QTY196, QTY197, QTY198, QTY199, QTY200
                     , QTY201, QTY202, QTY203, QTY204, QTY205, QTY206, QTY207, QTY208
                     , QTY209, QTY210, QTY211, QTY212, QTY213, QTY214, QTY215, QTY216
                     , QTY217, QTY218, QTY219, QTY220, QTY221, QTY222, QTY223, QTY224
                     , QTY225, QTY226, QTY227, QTY228, QTY229, QTY230, QTY231, QTY232
                     , QTY233, QTY234, QTY235, QTY236, QTY237, QTY238, QTY239, QTY240
                     , QTY241, QTY242, QTY243, QTY244, QTY245, QTY246, QTY247, QTY248
                     , QTY249, QTY250, QTY251, QTY252, QTY253, QTY254, QTY255, QTY256
                     , QTY257, QTY258, QTY259, QTY260, QTY261, QTY262, QTY263, QTY264
                     , QTY265, QTY266, QTY267, QTY268, QTY269, QTY270, QTY271, QTY272
                     , QTY273, QTY274, QTY275, QTY276, QTY277, QTY278, QTY279, QTY280
                     , QTY281, QTY282, QTY283, QTY284, QTY285, QTY286, QTY287, QTY288
                     , QTY289, QTY290, QTY291, QTY292, QTY293, QTY294, QTY295, QTY296
                     , QTY297, QTY298, QTY299, QTY300, QTY301, QTY302, QTY303, QTY304
                     , QTY305, QTY306, QTY307, QTY308, QTY309, QTY310, QTY311, QTY312
                     , QTY313, QTY314, QTY315, QTY316, QTY317, QTY318, QTY319, QTY320
                     , QTY321, QTY322, QTY323, QTY324, QTY325, QTY326, QTY327, QTY328
                     , QTY329, QTY330, QTY331, QTY332, QTY333, QTY334, QTY335, QTY336
                     , QTY337, QTY338, QTY339, QTY340, QTY341, QTY342, QTY343, QTY344
                     , QTY345, QTY346, QTY347, QTY348, QTY349, QTY350, QTY351, QTY352
                     , QTY353, QTY354, QTY355, QTY356, QTY357, QTY358, QTY359, QTY360
                     , QTY361, QTY362, QTY363, QTY364
                     )
                SELECT TO_CHAR(V_BATCH_XLS_KEY1)      AS XLS_KEY1
                     , V_BATCH_DIVISION_ID            AS DIVISION_ID
                     , V_BATCH_CREATE_FROM_YYYYMMDD   AS CREATE_FROM_YYYYMMDD
                     , SUM(NVL(QTY001, 0)) AS QTY001, SUM(NVL(QTY002, 0)) AS QTY002, SUM(NVL(QTY003, 0)) AS QTY003, SUM(NVL(QTY004, 0)) AS QTY004
                     , SUM(NVL(QTY005, 0)) AS QTY005, SUM(NVL(QTY006, 0)) AS QTY006, SUM(NVL(QTY007, 0)) AS QTY007, SUM(NVL(QTY008, 0)) AS QTY008
                     , SUM(NVL(QTY009, 0)) AS QTY009, SUM(NVL(QTY010, 0)) AS QTY010, SUM(NVL(QTY011, 0)) AS QTY011, SUM(NVL(QTY012, 0)) AS QTY012
                     , SUM(NVL(QTY013, 0)) AS QTY013, SUM(NVL(QTY014, 0)) AS QTY014, SUM(NVL(QTY015, 0)) AS QTY015, SUM(NVL(QTY016, 0)) AS QTY016
                     , SUM(NVL(QTY017, 0)) AS QTY017, SUM(NVL(QTY018, 0)) AS QTY018, SUM(NVL(QTY019, 0)) AS QTY019, SUM(NVL(QTY020, 0)) AS QTY020
                     , SUM(NVL(QTY021, 0)) AS QTY021, SUM(NVL(QTY022, 0)) AS QTY022, SUM(NVL(QTY023, 0)) AS QTY023, SUM(NVL(QTY024, 0)) AS QTY024
                     , SUM(NVL(QTY025, 0)) AS QTY025, SUM(NVL(QTY026, 0)) AS QTY026, SUM(NVL(QTY027, 0)) AS QTY027, SUM(NVL(QTY028, 0)) AS QTY028
                     , SUM(NVL(QTY029, 0)) AS QTY029, SUM(NVL(QTY030, 0)) AS QTY030, SUM(NVL(QTY031, 0)) AS QTY031, SUM(NVL(QTY032, 0)) AS QTY032
                     , SUM(NVL(QTY033, 0)) AS QTY033, SUM(NVL(QTY034, 0)) AS QTY034, SUM(NVL(QTY035, 0)) AS QTY035, SUM(NVL(QTY036, 0)) AS QTY036
                     , SUM(NVL(QTY037, 0)) AS QTY037, SUM(NVL(QTY038, 0)) AS QTY038, SUM(NVL(QTY039, 0)) AS QTY039, SUM(NVL(QTY040, 0)) AS QTY040
                     , SUM(NVL(QTY041, 0)) AS QTY041, SUM(NVL(QTY042, 0)) AS QTY042, SUM(NVL(QTY043, 0)) AS QTY043, SUM(NVL(QTY044, 0)) AS QTY044
                     , SUM(NVL(QTY045, 0)) AS QTY045, SUM(NVL(QTY046, 0)) AS QTY046, SUM(NVL(QTY047, 0)) AS QTY047, SUM(NVL(QTY048, 0)) AS QTY048
                     , SUM(NVL(QTY049, 0)) AS QTY049, SUM(NVL(QTY050, 0)) AS QTY050, SUM(NVL(QTY051, 0)) AS QTY051, SUM(NVL(QTY052, 0)) AS QTY052
                     , SUM(NVL(QTY053, 0)) AS QTY053, SUM(NVL(QTY054, 0)) AS QTY054, SUM(NVL(QTY055, 0)) AS QTY055, SUM(NVL(QTY056, 0)) AS QTY056
                     , SUM(NVL(QTY057, 0)) AS QTY057, SUM(NVL(QTY058, 0)) AS QTY058, SUM(NVL(QTY059, 0)) AS QTY059, SUM(NVL(QTY060, 0)) AS QTY060
                     , SUM(NVL(QTY061, 0)) AS QTY061, SUM(NVL(QTY062, 0)) AS QTY062, SUM(NVL(QTY063, 0)) AS QTY063, SUM(NVL(QTY064, 0)) AS QTY064
                     , SUM(NVL(QTY065, 0)) AS QTY065, SUM(NVL(QTY066, 0)) AS QTY066, SUM(NVL(QTY067, 0)) AS QTY067, SUM(NVL(QTY068, 0)) AS QTY068
                     , SUM(NVL(QTY069, 0)) AS QTY069, SUM(NVL(QTY070, 0)) AS QTY070, SUM(NVL(QTY071, 0)) AS QTY071, SUM(NVL(QTY072, 0)) AS QTY072
                     , SUM(NVL(QTY073, 0)) AS QTY073, SUM(NVL(QTY074, 0)) AS QTY074, SUM(NVL(QTY075, 0)) AS QTY075, SUM(NVL(QTY076, 0)) AS QTY076
                     , SUM(NVL(QTY077, 0)) AS QTY077, SUM(NVL(QTY078, 0)) AS QTY078, SUM(NVL(QTY079, 0)) AS QTY079, SUM(NVL(QTY080, 0)) AS QTY080
                     , SUM(NVL(QTY081, 0)) AS QTY081, SUM(NVL(QTY082, 0)) AS QTY082, SUM(NVL(QTY083, 0)) AS QTY083, SUM(NVL(QTY084, 0)) AS QTY084
                     , SUM(NVL(QTY085, 0)) AS QTY085, SUM(NVL(QTY086, 0)) AS QTY086, SUM(NVL(QTY087, 0)) AS QTY087, SUM(NVL(QTY088, 0)) AS QTY088
                     , SUM(NVL(QTY089, 0)) AS QTY089, SUM(NVL(QTY090, 0)) AS QTY090, SUM(NVL(QTY091, 0)) AS QTY091, SUM(NVL(QTY092, 0)) AS QTY092
                     , SUM(NVL(QTY093, 0)) AS QTY093, SUM(NVL(QTY094, 0)) AS QTY094, SUM(NVL(QTY095, 0)) AS QTY095, SUM(NVL(QTY096, 0)) AS QTY096
                     , SUM(NVL(QTY097, 0)) AS QTY097, SUM(NVL(QTY098, 0)) AS QTY098, SUM(NVL(QTY099, 0)) AS QTY099, SUM(NVL(QTY100, 0)) AS QTY100
                     , SUM(NVL(QTY101, 0)) AS QTY101, SUM(NVL(QTY102, 0)) AS QTY102, SUM(NVL(QTY103, 0)) AS QTY103, SUM(NVL(QTY104, 0)) AS QTY104
                     , SUM(NVL(QTY105, 0)) AS QTY105, SUM(NVL(QTY106, 0)) AS QTY106, SUM(NVL(QTY107, 0)) AS QTY107, SUM(NVL(QTY108, 0)) AS QTY108
                     , SUM(NVL(QTY109, 0)) AS QTY109, SUM(NVL(QTY110, 0)) AS QTY110, SUM(NVL(QTY111, 0)) AS QTY111, SUM(NVL(QTY112, 0)) AS QTY112
                     , SUM(NVL(QTY113, 0)) AS QTY113, SUM(NVL(QTY114, 0)) AS QTY114, SUM(NVL(QTY115, 0)) AS QTY115, SUM(NVL(QTY116, 0)) AS QTY116
                     , SUM(NVL(QTY117, 0)) AS QTY117, SUM(NVL(QTY118, 0)) AS QTY118, SUM(NVL(QTY119, 0)) AS QTY119, SUM(NVL(QTY120, 0)) AS QTY120
                     , SUM(NVL(QTY121, 0)) AS QTY121, SUM(NVL(QTY122, 0)) AS QTY122, SUM(NVL(QTY123, 0)) AS QTY123, SUM(NVL(QTY124, 0)) AS QTY124
                     , SUM(NVL(QTY125, 0)) AS QTY125, SUM(NVL(QTY126, 0)) AS QTY126, SUM(NVL(QTY127, 0)) AS QTY127, SUM(NVL(QTY128, 0)) AS QTY128
                     , SUM(NVL(QTY129, 0)) AS QTY129, SUM(NVL(QTY130, 0)) AS QTY130, SUM(NVL(QTY131, 0)) AS QTY131, SUM(NVL(QTY132, 0)) AS QTY132
                     , SUM(NVL(QTY133, 0)) AS QTY133, SUM(NVL(QTY134, 0)) AS QTY134, SUM(NVL(QTY135, 0)) AS QTY135, SUM(NVL(QTY136, 0)) AS QTY136
                     , SUM(NVL(QTY137, 0)) AS QTY137, SUM(NVL(QTY138, 0)) AS QTY138, SUM(NVL(QTY139, 0)) AS QTY139, SUM(NVL(QTY140, 0)) AS QTY140
                     , SUM(NVL(QTY141, 0)) AS QTY141, SUM(NVL(QTY142, 0)) AS QTY142, SUM(NVL(QTY143, 0)) AS QTY143, SUM(NVL(QTY144, 0)) AS QTY144
                     , SUM(NVL(QTY145, 0)) AS QTY145, SUM(NVL(QTY146, 0)) AS QTY146, SUM(NVL(QTY147, 0)) AS QTY147, SUM(NVL(QTY148, 0)) AS QTY148
                     , SUM(NVL(QTY149, 0)) AS QTY149, SUM(NVL(QTY150, 0)) AS QTY150, SUM(NVL(QTY151, 0)) AS QTY151, SUM(NVL(QTY152, 0)) AS QTY152
                     , SUM(NVL(QTY153, 0)) AS QTY153, SUM(NVL(QTY154, 0)) AS QTY154, SUM(NVL(QTY155, 0)) AS QTY155, SUM(NVL(QTY156, 0)) AS QTY156
                     , SUM(NVL(QTY157, 0)) AS QTY157, SUM(NVL(QTY158, 0)) AS QTY158, SUM(NVL(QTY159, 0)) AS QTY159, SUM(NVL(QTY160, 0)) AS QTY160
                     , SUM(NVL(QTY161, 0)) AS QTY161, SUM(NVL(QTY162, 0)) AS QTY162, SUM(NVL(QTY163, 0)) AS QTY163, SUM(NVL(QTY164, 0)) AS QTY164
                     , SUM(NVL(QTY165, 0)) AS QTY165, SUM(NVL(QTY166, 0)) AS QTY166, SUM(NVL(QTY167, 0)) AS QTY167, SUM(NVL(QTY168, 0)) AS QTY168
                     , SUM(NVL(QTY169, 0)) AS QTY169, SUM(NVL(QTY170, 0)) AS QTY170, SUM(NVL(QTY171, 0)) AS QTY171, SUM(NVL(QTY172, 0)) AS QTY172
                     , SUM(NVL(QTY173, 0)) AS QTY173, SUM(NVL(QTY174, 0)) AS QTY174, SUM(NVL(QTY175, 0)) AS QTY175, SUM(NVL(QTY176, 0)) AS QTY176
                     , SUM(NVL(QTY177, 0)) AS QTY177, SUM(NVL(QTY178, 0)) AS QTY178, SUM(NVL(QTY179, 0)) AS QTY179, SUM(NVL(QTY180, 0)) AS QTY180
                     , SUM(NVL(QTY181, 0)) AS QTY181, SUM(NVL(QTY182, 0)) AS QTY182, SUM(NVL(QTY183, 0)) AS QTY183, SUM(NVL(QTY184, 0)) AS QTY184
                     , SUM(NVL(QTY185, 0)) AS QTY185, SUM(NVL(QTY186, 0)) AS QTY186, SUM(NVL(QTY187, 0)) AS QTY187, SUM(NVL(QTY188, 0)) AS QTY188
                     , SUM(NVL(QTY189, 0)) AS QTY189, SUM(NVL(QTY190, 0)) AS QTY190, SUM(NVL(QTY191, 0)) AS QTY191, SUM(NVL(QTY192, 0)) AS QTY192
                     , SUM(NVL(QTY193, 0)) AS QTY193, SUM(NVL(QTY194, 0)) AS QTY194, SUM(NVL(QTY195, 0)) AS QTY195, SUM(NVL(QTY196, 0)) AS QTY196
                     , SUM(NVL(QTY197, 0)) AS QTY197, SUM(NVL(QTY198, 0)) AS QTY198, SUM(NVL(QTY199, 0)) AS QTY199, SUM(NVL(QTY200, 0)) AS QTY200
                     , SUM(NVL(QTY201, 0)) AS QTY201, SUM(NVL(QTY202, 0)) AS QTY202, SUM(NVL(QTY203, 0)) AS QTY203, SUM(NVL(QTY204, 0)) AS QTY204
                     , SUM(NVL(QTY205, 0)) AS QTY205, SUM(NVL(QTY206, 0)) AS QTY206, SUM(NVL(QTY207, 0)) AS QTY207, SUM(NVL(QTY208, 0)) AS QTY208
                     , SUM(NVL(QTY209, 0)) AS QTY209, SUM(NVL(QTY210, 0)) AS QTY210, SUM(NVL(QTY211, 0)) AS QTY211, SUM(NVL(QTY212, 0)) AS QTY212
                     , SUM(NVL(QTY213, 0)) AS QTY213, SUM(NVL(QTY214, 0)) AS QTY214, SUM(NVL(QTY215, 0)) AS QTY215, SUM(NVL(QTY216, 0)) AS QTY216
                     , SUM(NVL(QTY217, 0)) AS QTY217, SUM(NVL(QTY218, 0)) AS QTY218, SUM(NVL(QTY219, 0)) AS QTY219, SUM(NVL(QTY220, 0)) AS QTY220
                     , SUM(NVL(QTY221, 0)) AS QTY221, SUM(NVL(QTY222, 0)) AS QTY222, SUM(NVL(QTY223, 0)) AS QTY223, SUM(NVL(QTY224, 0)) AS QTY224
                     , SUM(NVL(QTY225, 0)) AS QTY225, SUM(NVL(QTY226, 0)) AS QTY226, SUM(NVL(QTY227, 0)) AS QTY227, SUM(NVL(QTY228, 0)) AS QTY228
                     , SUM(NVL(QTY229, 0)) AS QTY229, SUM(NVL(QTY230, 0)) AS QTY230, SUM(NVL(QTY231, 0)) AS QTY231, SUM(NVL(QTY232, 0)) AS QTY232
                     , SUM(NVL(QTY233, 0)) AS QTY233, SUM(NVL(QTY234, 0)) AS QTY234, SUM(NVL(QTY235, 0)) AS QTY235, SUM(NVL(QTY236, 0)) AS QTY236
                     , SUM(NVL(QTY237, 0)) AS QTY237, SUM(NVL(QTY238, 0)) AS QTY238, SUM(NVL(QTY239, 0)) AS QTY239, SUM(NVL(QTY240, 0)) AS QTY240
                     , SUM(NVL(QTY241, 0)) AS QTY241, SUM(NVL(QTY242, 0)) AS QTY242, SUM(NVL(QTY243, 0)) AS QTY243, SUM(NVL(QTY244, 0)) AS QTY244
                     , SUM(NVL(QTY245, 0)) AS QTY245, SUM(NVL(QTY246, 0)) AS QTY246, SUM(NVL(QTY247, 0)) AS QTY247, SUM(NVL(QTY248, 0)) AS QTY248
                     , SUM(NVL(QTY249, 0)) AS QTY249, SUM(NVL(QTY250, 0)) AS QTY250, SUM(NVL(QTY251, 0)) AS QTY251, SUM(NVL(QTY252, 0)) AS QTY252
                     , SUM(NVL(QTY253, 0)) AS QTY253, SUM(NVL(QTY254, 0)) AS QTY254, SUM(NVL(QTY255, 0)) AS QTY255, SUM(NVL(QTY256, 0)) AS QTY256
                     , SUM(NVL(QTY257, 0)) AS QTY257, SUM(NVL(QTY258, 0)) AS QTY258, SUM(NVL(QTY259, 0)) AS QTY259, SUM(NVL(QTY260, 0)) AS QTY260
                     , SUM(NVL(QTY261, 0)) AS QTY261, SUM(NVL(QTY262, 0)) AS QTY262, SUM(NVL(QTY263, 0)) AS QTY263, SUM(NVL(QTY264, 0)) AS QTY264
                     , SUM(NVL(QTY265, 0)) AS QTY265, SUM(NVL(QTY266, 0)) AS QTY266, SUM(NVL(QTY267, 0)) AS QTY267, SUM(NVL(QTY268, 0)) AS QTY268
                     , SUM(NVL(QTY269, 0)) AS QTY269, SUM(NVL(QTY270, 0)) AS QTY270, SUM(NVL(QTY271, 0)) AS QTY271, SUM(NVL(QTY272, 0)) AS QTY272
                     , SUM(NVL(QTY273, 0)) AS QTY273, SUM(NVL(QTY274, 0)) AS QTY274, SUM(NVL(QTY275, 0)) AS QTY275, SUM(NVL(QTY276, 0)) AS QTY276
                     , SUM(NVL(QTY277, 0)) AS QTY277, SUM(NVL(QTY278, 0)) AS QTY278, SUM(NVL(QTY279, 0)) AS QTY279, SUM(NVL(QTY280, 0)) AS QTY280
                     , SUM(NVL(QTY281, 0)) AS QTY281, SUM(NVL(QTY282, 0)) AS QTY282, SUM(NVL(QTY283, 0)) AS QTY283, SUM(NVL(QTY284, 0)) AS QTY284
                     , SUM(NVL(QTY285, 0)) AS QTY285, SUM(NVL(QTY286, 0)) AS QTY286, SUM(NVL(QTY287, 0)) AS QTY287, SUM(NVL(QTY288, 0)) AS QTY288
                     , SUM(NVL(QTY289, 0)) AS QTY289, SUM(NVL(QTY290, 0)) AS QTY290, SUM(NVL(QTY291, 0)) AS QTY291, SUM(NVL(QTY292, 0)) AS QTY292
                     , SUM(NVL(QTY293, 0)) AS QTY293, SUM(NVL(QTY294, 0)) AS QTY294, SUM(NVL(QTY295, 0)) AS QTY295, SUM(NVL(QTY296, 0)) AS QTY296
                     , SUM(NVL(QTY297, 0)) AS QTY297, SUM(NVL(QTY298, 0)) AS QTY298, SUM(NVL(QTY299, 0)) AS QTY299, SUM(NVL(QTY300, 0)) AS QTY300
                     , SUM(NVL(QTY301, 0)) AS QTY301, SUM(NVL(QTY302, 0)) AS QTY302, SUM(NVL(QTY303, 0)) AS QTY303, SUM(NVL(QTY304, 0)) AS QTY304
                     , SUM(NVL(QTY305, 0)) AS QTY305, SUM(NVL(QTY306, 0)) AS QTY306, SUM(NVL(QTY307, 0)) AS QTY307, SUM(NVL(QTY308, 0)) AS QTY308
                     , SUM(NVL(QTY309, 0)) AS QTY309, SUM(NVL(QTY310, 0)) AS QTY310, SUM(NVL(QTY311, 0)) AS QTY311, SUM(NVL(QTY312, 0)) AS QTY312
                     , SUM(NVL(QTY313, 0)) AS QTY313, SUM(NVL(QTY314, 0)) AS QTY314, SUM(NVL(QTY315, 0)) AS QTY315, SUM(NVL(QTY316, 0)) AS QTY316
                     , SUM(NVL(QTY317, 0)) AS QTY317, SUM(NVL(QTY318, 0)) AS QTY318, SUM(NVL(QTY319, 0)) AS QTY319, SUM(NVL(QTY320, 0)) AS QTY320
                     , SUM(NVL(QTY321, 0)) AS QTY321, SUM(NVL(QTY322, 0)) AS QTY322, SUM(NVL(QTY323, 0)) AS QTY323, SUM(NVL(QTY324, 0)) AS QTY324
                     , SUM(NVL(QTY325, 0)) AS QTY325, SUM(NVL(QTY326, 0)) AS QTY326, SUM(NVL(QTY327, 0)) AS QTY327, SUM(NVL(QTY328, 0)) AS QTY328
                     , SUM(NVL(QTY329, 0)) AS QTY329, SUM(NVL(QTY330, 0)) AS QTY330, SUM(NVL(QTY331, 0)) AS QTY331, SUM(NVL(QTY332, 0)) AS QTY332
                     , SUM(NVL(QTY333, 0)) AS QTY333, SUM(NVL(QTY334, 0)) AS QTY334, SUM(NVL(QTY335, 0)) AS QTY335, SUM(NVL(QTY336, 0)) AS QTY336
                     , SUM(NVL(QTY337, 0)) AS QTY337, SUM(NVL(QTY338, 0)) AS QTY338, SUM(NVL(QTY339, 0)) AS QTY339, SUM(NVL(QTY340, 0)) AS QTY340
                     , SUM(NVL(QTY341, 0)) AS QTY341, SUM(NVL(QTY342, 0)) AS QTY342, SUM(NVL(QTY343, 0)) AS QTY343, SUM(NVL(QTY344, 0)) AS QTY344
                     , SUM(NVL(QTY345, 0)) AS QTY345, SUM(NVL(QTY346, 0)) AS QTY346, SUM(NVL(QTY347, 0)) AS QTY347, SUM(NVL(QTY348, 0)) AS QTY348
                     , SUM(NVL(QTY349, 0)) AS QTY349, SUM(NVL(QTY350, 0)) AS QTY350, SUM(NVL(QTY351, 0)) AS QTY351, SUM(NVL(QTY352, 0)) AS QTY352
                     , SUM(NVL(QTY353, 0)) AS QTY353, SUM(NVL(QTY354, 0)) AS QTY354, SUM(NVL(QTY355, 0)) AS QTY355, SUM(NVL(QTY356, 0)) AS QTY356
                     , SUM(NVL(QTY357, 0)) AS QTY357, SUM(NVL(QTY358, 0)) AS QTY358, SUM(NVL(QTY359, 0)) AS QTY359, SUM(NVL(QTY360, 0)) AS QTY360
                     , SUM(NVL(QTY361, 0)) AS QTY361, SUM(NVL(QTY362, 0)) AS QTY362, SUM(NVL(QTY363, 0)) AS QTY363, SUM(NVL(QTY364, 0)) AS QTY364
                  FROM ( SELECT YYYYMMDD, QTY, COLS_NAME
                           FROM GT_XPGT_SCP_XLS_PSI_GLOBAL_MODIFY_ROW ) SOURCEDATA
                       PIVOT (
                           SUM(QTY) FOR COLS_NAME IN (
                                'QTY001' AS QTY001, 'QTY002' AS QTY002, 'QTY003' AS QTY003, 'QTY004' AS QTY004, 'QTY005' AS QTY005
                              , 'QTY006' AS QTY006, 'QTY007' AS QTY007, 'QTY008' AS QTY008, 'QTY009' AS QTY009, 'QTY010' AS QTY010
                              , 'QTY011' AS QTY011, 'QTY012' AS QTY012, 'QTY013' AS QTY013, 'QTY014' AS QTY014, 'QTY015' AS QTY015
                              , 'QTY016' AS QTY016, 'QTY017' AS QTY017, 'QTY018' AS QTY018, 'QTY019' AS QTY019, 'QTY020' AS QTY020
                              , 'QTY021' AS QTY021, 'QTY022' AS QTY022, 'QTY023' AS QTY023, 'QTY024' AS QTY024, 'QTY025' AS QTY025
                              , 'QTY026' AS QTY026, 'QTY027' AS QTY027, 'QTY028' AS QTY028, 'QTY029' AS QTY029, 'QTY030' AS QTY030
                              , 'QTY031' AS QTY031, 'QTY032' AS QTY032, 'QTY033' AS QTY033, 'QTY034' AS QTY034, 'QTY035' AS QTY035
                              , 'QTY036' AS QTY036, 'QTY037' AS QTY037, 'QTY038' AS QTY038, 'QTY039' AS QTY039, 'QTY040' AS QTY040
                              , 'QTY041' AS QTY041, 'QTY042' AS QTY042, 'QTY043' AS QTY043, 'QTY044' AS QTY044, 'QTY045' AS QTY045
                              , 'QTY046' AS QTY046, 'QTY047' AS QTY047, 'QTY048' AS QTY048, 'QTY049' AS QTY049, 'QTY050' AS QTY050
                              , 'QTY051' AS QTY051, 'QTY052' AS QTY052, 'QTY053' AS QTY053, 'QTY054' AS QTY054, 'QTY055' AS QTY055
                              , 'QTY056' AS QTY056, 'QTY057' AS QTY057, 'QTY058' AS QTY058, 'QTY059' AS QTY059, 'QTY060' AS QTY060
                              , 'QTY061' AS QTY061, 'QTY062' AS QTY062, 'QTY063' AS QTY063, 'QTY064' AS QTY064, 'QTY065' AS QTY065
                              , 'QTY066' AS QTY066, 'QTY067' AS QTY067, 'QTY068' AS QTY068, 'QTY069' AS QTY069, 'QTY070' AS QTY070
                              , 'QTY071' AS QTY071, 'QTY072' AS QTY072, 'QTY073' AS QTY073, 'QTY074' AS QTY074, 'QTY075' AS QTY075
                              , 'QTY076' AS QTY076, 'QTY077' AS QTY077, 'QTY078' AS QTY078, 'QTY079' AS QTY079, 'QTY080' AS QTY080
                              , 'QTY081' AS QTY081, 'QTY082' AS QTY082, 'QTY083' AS QTY083, 'QTY084' AS QTY084, 'QTY085' AS QTY085
                              , 'QTY086' AS QTY086, 'QTY087' AS QTY087, 'QTY088' AS QTY088, 'QTY089' AS QTY089, 'QTY090' AS QTY090
                              , 'QTY091' AS QTY091, 'QTY092' AS QTY092, 'QTY093' AS QTY093, 'QTY094' AS QTY094, 'QTY095' AS QTY095
                              , 'QTY096' AS QTY096, 'QTY097' AS QTY097, 'QTY098' AS QTY098, 'QTY099' AS QTY099, 'QTY100' AS QTY100
                              , 'QTY101' AS QTY101, 'QTY102' AS QTY102, 'QTY103' AS QTY103, 'QTY104' AS QTY104, 'QTY105' AS QTY105
                              , 'QTY106' AS QTY106, 'QTY107' AS QTY107, 'QTY108' AS QTY108, 'QTY109' AS QTY109, 'QTY110' AS QTY110
                              , 'QTY111' AS QTY111, 'QTY112' AS QTY112, 'QTY113' AS QTY113, 'QTY114' AS QTY114, 'QTY115' AS QTY115
                              , 'QTY116' AS QTY116, 'QTY117' AS QTY117, 'QTY118' AS QTY118, 'QTY119' AS QTY119, 'QTY120' AS QTY120
                              , 'QTY121' AS QTY121, 'QTY122' AS QTY122, 'QTY123' AS QTY123, 'QTY124' AS QTY124, 'QTY125' AS QTY125
                              , 'QTY126' AS QTY126, 'QTY127' AS QTY127, 'QTY128' AS QTY128, 'QTY129' AS QTY129, 'QTY130' AS QTY130
                              , 'QTY131' AS QTY131, 'QTY132' AS QTY132, 'QTY133' AS QTY133, 'QTY134' AS QTY134, 'QTY135' AS QTY135
                              , 'QTY136' AS QTY136, 'QTY137' AS QTY137, 'QTY138' AS QTY138, 'QTY139' AS QTY139, 'QTY140' AS QTY140
                              , 'QTY141' AS QTY141, 'QTY142' AS QTY142, 'QTY143' AS QTY143, 'QTY144' AS QTY144, 'QTY145' AS QTY145
                              , 'QTY146' AS QTY146, 'QTY147' AS QTY147, 'QTY148' AS QTY148, 'QTY149' AS QTY149, 'QTY150' AS QTY150
                              , 'QTY151' AS QTY151, 'QTY152' AS QTY152, 'QTY153' AS QTY153, 'QTY154' AS QTY154, 'QTY155' AS QTY155
                              , 'QTY156' AS QTY156, 'QTY157' AS QTY157, 'QTY158' AS QTY158, 'QTY159' AS QTY159, 'QTY160' AS QTY160
                              , 'QTY161' AS QTY161, 'QTY162' AS QTY162, 'QTY163' AS QTY163, 'QTY164' AS QTY164, 'QTY165' AS QTY165
                              , 'QTY166' AS QTY166, 'QTY167' AS QTY167, 'QTY168' AS QTY168, 'QTY169' AS QTY169, 'QTY170' AS QTY170
                              , 'QTY171' AS QTY171, 'QTY172' AS QTY172, 'QTY173' AS QTY173, 'QTY174' AS QTY174, 'QTY175' AS QTY175
                              , 'QTY176' AS QTY176, 'QTY177' AS QTY177, 'QTY178' AS QTY178, 'QTY179' AS QTY179, 'QTY180' AS QTY180
                              , 'QTY181' AS QTY181, 'QTY182' AS QTY182, 'QTY183' AS QTY183, 'QTY184' AS QTY184, 'QTY185' AS QTY185
                              , 'QTY186' AS QTY186, 'QTY187' AS QTY187, 'QTY188' AS QTY188, 'QTY189' AS QTY189, 'QTY190' AS QTY190
                              , 'QTY191' AS QTY191, 'QTY192' AS QTY192, 'QTY193' AS QTY193, 'QTY194' AS QTY194, 'QTY195' AS QTY195
                              , 'QTY196' AS QTY196, 'QTY197' AS QTY197, 'QTY198' AS QTY198, 'QTY199' AS QTY199, 'QTY200' AS QTY200
                              , 'QTY201' AS QTY201, 'QTY202' AS QTY202, 'QTY203' AS QTY203, 'QTY204' AS QTY204, 'QTY205' AS QTY205
                              , 'QTY206' AS QTY206, 'QTY207' AS QTY207, 'QTY208' AS QTY208, 'QTY209' AS QTY209, 'QTY210' AS QTY210
                              , 'QTY211' AS QTY211, 'QTY212' AS QTY212, 'QTY213' AS QTY213, 'QTY214' AS QTY214, 'QTY215' AS QTY215
                              , 'QTY216' AS QTY216, 'QTY217' AS QTY217, 'QTY218' AS QTY218, 'QTY219' AS QTY219, 'QTY220' AS QTY220
                              , 'QTY221' AS QTY221, 'QTY222' AS QTY222, 'QTY223' AS QTY223, 'QTY224' AS QTY224, 'QTY225' AS QTY225
                              , 'QTY226' AS QTY226, 'QTY227' AS QTY227, 'QTY228' AS QTY228, 'QTY229' AS QTY229, 'QTY230' AS QTY230
                              , 'QTY231' AS QTY231, 'QTY232' AS QTY232, 'QTY233' AS QTY233, 'QTY234' AS QTY234, 'QTY235' AS QTY235
                              , 'QTY236' AS QTY236, 'QTY237' AS QTY237, 'QTY238' AS QTY238, 'QTY239' AS QTY239, 'QTY240' AS QTY240
                              , 'QTY241' AS QTY241, 'QTY242' AS QTY242, 'QTY243' AS QTY243, 'QTY244' AS QTY244, 'QTY245' AS QTY245
                              , 'QTY246' AS QTY246, 'QTY247' AS QTY247, 'QTY248' AS QTY248, 'QTY249' AS QTY249, 'QTY250' AS QTY250
                              , 'QTY251' AS QTY251, 'QTY252' AS QTY252, 'QTY253' AS QTY253, 'QTY254' AS QTY254, 'QTY255' AS QTY255
                              , 'QTY256' AS QTY256, 'QTY257' AS QTY257, 'QTY258' AS QTY258, 'QTY259' AS QTY259, 'QTY260' AS QTY260
                              , 'QTY261' AS QTY261, 'QTY262' AS QTY262, 'QTY263' AS QTY263, 'QTY264' AS QTY264, 'QTY265' AS QTY265
                              , 'QTY266' AS QTY266, 'QTY267' AS QTY267, 'QTY268' AS QTY268, 'QTY269' AS QTY269, 'QTY270' AS QTY270
                              , 'QTY271' AS QTY271, 'QTY272' AS QTY272, 'QTY273' AS QTY273, 'QTY274' AS QTY274, 'QTY275' AS QTY275
                              , 'QTY276' AS QTY276, 'QTY277' AS QTY277, 'QTY278' AS QTY278, 'QTY279' AS QTY279, 'QTY280' AS QTY280
                              , 'QTY281' AS QTY281, 'QTY282' AS QTY282, 'QTY283' AS QTY283, 'QTY284' AS QTY284, 'QTY285' AS QTY285
                              , 'QTY286' AS QTY286, 'QTY287' AS QTY287, 'QTY288' AS QTY288, 'QTY289' AS QTY289, 'QTY290' AS QTY290
                              , 'QTY291' AS QTY291, 'QTY292' AS QTY292, 'QTY293' AS QTY293, 'QTY294' AS QTY294, 'QTY295' AS QTY295
                              , 'QTY296' AS QTY296, 'QTY297' AS QTY297, 'QTY298' AS QTY298, 'QTY299' AS QTY299, 'QTY300' AS QTY300
                              , 'QTY301' AS QTY301, 'QTY302' AS QTY302, 'QTY303' AS QTY303, 'QTY304' AS QTY304, 'QTY305' AS QTY305
                              , 'QTY306' AS QTY306, 'QTY307' AS QTY307, 'QTY308' AS QTY308, 'QTY309' AS QTY309, 'QTY310' AS QTY310
                              , 'QTY311' AS QTY311, 'QTY312' AS QTY312, 'QTY313' AS QTY313, 'QTY314' AS QTY314, 'QTY315' AS QTY315
                              , 'QTY316' AS QTY316, 'QTY317' AS QTY317, 'QTY318' AS QTY318, 'QTY319' AS QTY319, 'QTY320' AS QTY320
                              , 'QTY321' AS QTY321, 'QTY322' AS QTY322, 'QTY323' AS QTY323, 'QTY324' AS QTY324, 'QTY325' AS QTY325
                              , 'QTY326' AS QTY326, 'QTY327' AS QTY327, 'QTY328' AS QTY328, 'QTY329' AS QTY329, 'QTY330' AS QTY330
                              , 'QTY331' AS QTY331, 'QTY332' AS QTY332, 'QTY333' AS QTY333, 'QTY334' AS QTY334, 'QTY335' AS QTY335
                              , 'QTY336' AS QTY336, 'QTY337' AS QTY337, 'QTY338' AS QTY338, 'QTY339' AS QTY339, 'QTY340' AS QTY340
                              , 'QTY341' AS QTY341, 'QTY342' AS QTY342, 'QTY343' AS QTY343, 'QTY344' AS QTY344, 'QTY345' AS QTY345
                              , 'QTY346' AS QTY346, 'QTY347' AS QTY347, 'QTY348' AS QTY348, 'QTY349' AS QTY349, 'QTY350' AS QTY350
                              , 'QTY351' AS QTY351, 'QTY352' AS QTY352, 'QTY353' AS QTY353, 'QTY354' AS QTY354, 'QTY355' AS QTY355
                              , 'QTY356' AS QTY356, 'QTY357' AS QTY357, 'QTY358' AS QTY358, 'QTY359' AS QTY359, 'QTY360' AS QTY360
                              , 'QTY361' AS QTY361, 'QTY362' AS QTY362, 'QTY363' AS QTY363, 'QTY364' AS QTY364
                              )
                       ) UN;
            END IF;

            /*  저장을 위한 공통메쏘드 입니다 */
            IF V_BATCH_MEASURE NOT IN ('SHIP_PLAN', 'SEMI_SHIP_PLAN') THEN
                /*  #SCP_XLS_PSI_GLOBAL_MODIFY
                    MSSQL UPDATE X SET .. FROM SCP_XLS_PSI_GLOBAL X INNER JOIN #SCP_XLS_PSI_GLOBAL_MODIFY Y ON ..
                    ★원천 GTT 는 GROUP BY 없는 집계 SELECT 로 채워 항상 1행이므로 ORA-30926 이 성립하지 않는다. */
                MERGE INTO SCP_XLS_PSI_GLOBAL X
                USING GT_XPGT_SCP_XLS_PSI_GLOBAL_MODIFY Y
                   ON ( X.XLS_KEY1             = TO_NUMBER(Y.XLS_KEY1)
                        AND X.CREATE_FROM_YYYYMMDD = Y.CREATE_FROM_YYYYMMDD
                        AND X.DIVISION_ID          = Y.DIVISION_ID
                        AND X.CREATE_FROM_YYYYMMDD = V_BATCH_CREATE_FROM_YYYYMMDD
                        AND X.DIVISION_ID          = V_BATCH_DIVISION_ID )   /* 2022.03.23 KSW GM JV 반영 */
                WHEN MATCHED THEN
                UPDATE
                   SET
                         X.QTY001 = Y.QTY001, X.QTY002 = Y.QTY002, X.QTY003 = Y.QTY003, X.QTY004 = Y.QTY004, X.QTY005 = Y.QTY005
                       , X.QTY006 = Y.QTY006, X.QTY007 = Y.QTY007, X.QTY008 = Y.QTY008, X.QTY009 = Y.QTY009, X.QTY010 = Y.QTY010
                       , X.QTY011 = Y.QTY011, X.QTY012 = Y.QTY012, X.QTY013 = Y.QTY013, X.QTY014 = Y.QTY014, X.QTY015 = Y.QTY015
                       , X.QTY016 = Y.QTY016, X.QTY017 = Y.QTY017, X.QTY018 = Y.QTY018, X.QTY019 = Y.QTY019, X.QTY020 = Y.QTY020
                       , X.QTY021 = Y.QTY021, X.QTY022 = Y.QTY022, X.QTY023 = Y.QTY023, X.QTY024 = Y.QTY024, X.QTY025 = Y.QTY025
                       , X.QTY026 = Y.QTY026, X.QTY027 = Y.QTY027, X.QTY028 = Y.QTY028, X.QTY029 = Y.QTY029, X.QTY030 = Y.QTY030
                       , X.QTY031 = Y.QTY031, X.QTY032 = Y.QTY032, X.QTY033 = Y.QTY033, X.QTY034 = Y.QTY034, X.QTY035 = Y.QTY035
                       , X.QTY036 = Y.QTY036, X.QTY037 = Y.QTY037, X.QTY038 = Y.QTY038, X.QTY039 = Y.QTY039, X.QTY040 = Y.QTY040
                       , X.QTY041 = Y.QTY041, X.QTY042 = Y.QTY042, X.QTY043 = Y.QTY043, X.QTY044 = Y.QTY044, X.QTY045 = Y.QTY045
                       , X.QTY046 = Y.QTY046, X.QTY047 = Y.QTY047, X.QTY048 = Y.QTY048, X.QTY049 = Y.QTY049, X.QTY050 = Y.QTY050
                       , X.QTY051 = Y.QTY051, X.QTY052 = Y.QTY052, X.QTY053 = Y.QTY053, X.QTY054 = Y.QTY054, X.QTY055 = Y.QTY055
                       , X.QTY056 = Y.QTY056, X.QTY057 = Y.QTY057, X.QTY058 = Y.QTY058, X.QTY059 = Y.QTY059, X.QTY060 = Y.QTY060
                       , X.QTY061 = Y.QTY061, X.QTY062 = Y.QTY062, X.QTY063 = Y.QTY063, X.QTY064 = Y.QTY064, X.QTY065 = Y.QTY065
                       , X.QTY066 = Y.QTY066, X.QTY067 = Y.QTY067, X.QTY068 = Y.QTY068, X.QTY069 = Y.QTY069, X.QTY070 = Y.QTY070
                       , X.QTY071 = Y.QTY071, X.QTY072 = Y.QTY072, X.QTY073 = Y.QTY073, X.QTY074 = Y.QTY074, X.QTY075 = Y.QTY075
                       , X.QTY076 = Y.QTY076, X.QTY077 = Y.QTY077, X.QTY078 = Y.QTY078, X.QTY079 = Y.QTY079, X.QTY080 = Y.QTY080
                       , X.QTY081 = Y.QTY081, X.QTY082 = Y.QTY082, X.QTY083 = Y.QTY083, X.QTY084 = Y.QTY084, X.QTY085 = Y.QTY085
                       , X.QTY086 = Y.QTY086, X.QTY087 = Y.QTY087, X.QTY088 = Y.QTY088, X.QTY089 = Y.QTY089, X.QTY090 = Y.QTY090
                       , X.QTY091 = Y.QTY091, X.QTY092 = Y.QTY092, X.QTY093 = Y.QTY093, X.QTY094 = Y.QTY094, X.QTY095 = Y.QTY095
                       , X.QTY096 = Y.QTY096, X.QTY097 = Y.QTY097, X.QTY098 = Y.QTY098, X.QTY099 = Y.QTY099, X.QTY100 = Y.QTY100
                       , X.QTY101 = Y.QTY101, X.QTY102 = Y.QTY102, X.QTY103 = Y.QTY103, X.QTY104 = Y.QTY104, X.QTY105 = Y.QTY105
                       , X.QTY106 = Y.QTY106, X.QTY107 = Y.QTY107, X.QTY108 = Y.QTY108, X.QTY109 = Y.QTY109, X.QTY110 = Y.QTY110
                       , X.QTY111 = Y.QTY111, X.QTY112 = Y.QTY112, X.QTY113 = Y.QTY113, X.QTY114 = Y.QTY114, X.QTY115 = Y.QTY115
                       , X.QTY116 = Y.QTY116, X.QTY117 = Y.QTY117, X.QTY118 = Y.QTY118, X.QTY119 = Y.QTY119, X.QTY120 = Y.QTY120
                       , X.QTY121 = Y.QTY121, X.QTY122 = Y.QTY122, X.QTY123 = Y.QTY123, X.QTY124 = Y.QTY124, X.QTY125 = Y.QTY125
                       , X.QTY126 = Y.QTY126, X.QTY127 = Y.QTY127, X.QTY128 = Y.QTY128, X.QTY129 = Y.QTY129, X.QTY130 = Y.QTY130
                       , X.QTY131 = Y.QTY131, X.QTY132 = Y.QTY132, X.QTY133 = Y.QTY133, X.QTY134 = Y.QTY134, X.QTY135 = Y.QTY135
                       , X.QTY136 = Y.QTY136, X.QTY137 = Y.QTY137, X.QTY138 = Y.QTY138, X.QTY139 = Y.QTY139, X.QTY140 = Y.QTY140
                       , X.QTY141 = Y.QTY141, X.QTY142 = Y.QTY142, X.QTY143 = Y.QTY143, X.QTY144 = Y.QTY144, X.QTY145 = Y.QTY145
                       , X.QTY146 = Y.QTY146, X.QTY147 = Y.QTY147, X.QTY148 = Y.QTY148, X.QTY149 = Y.QTY149, X.QTY150 = Y.QTY150
                       , X.QTY151 = Y.QTY151, X.QTY152 = Y.QTY152, X.QTY153 = Y.QTY153, X.QTY154 = Y.QTY154, X.QTY155 = Y.QTY155
                       , X.QTY156 = Y.QTY156, X.QTY157 = Y.QTY157, X.QTY158 = Y.QTY158, X.QTY159 = Y.QTY159, X.QTY160 = Y.QTY160
                       , X.QTY161 = Y.QTY161, X.QTY162 = Y.QTY162, X.QTY163 = Y.QTY163, X.QTY164 = Y.QTY164, X.QTY165 = Y.QTY165
                       , X.QTY166 = Y.QTY166, X.QTY167 = Y.QTY167, X.QTY168 = Y.QTY168, X.QTY169 = Y.QTY169, X.QTY170 = Y.QTY170
                       , X.QTY171 = Y.QTY171, X.QTY172 = Y.QTY172, X.QTY173 = Y.QTY173, X.QTY174 = Y.QTY174, X.QTY175 = Y.QTY175
                       , X.QTY176 = Y.QTY176, X.QTY177 = Y.QTY177, X.QTY178 = Y.QTY178, X.QTY179 = Y.QTY179, X.QTY180 = Y.QTY180
                       , X.QTY181 = Y.QTY181, X.QTY182 = Y.QTY182, X.QTY183 = Y.QTY183, X.QTY184 = Y.QTY184, X.QTY185 = Y.QTY185
                       , X.QTY186 = Y.QTY186, X.QTY187 = Y.QTY187, X.QTY188 = Y.QTY188, X.QTY189 = Y.QTY189, X.QTY190 = Y.QTY190
                       , X.QTY191 = Y.QTY191, X.QTY192 = Y.QTY192, X.QTY193 = Y.QTY193, X.QTY194 = Y.QTY194, X.QTY195 = Y.QTY195
                       , X.QTY196 = Y.QTY196, X.QTY197 = Y.QTY197, X.QTY198 = Y.QTY198, X.QTY199 = Y.QTY199, X.QTY200 = Y.QTY200
                       , X.QTY201 = Y.QTY201, X.QTY202 = Y.QTY202, X.QTY203 = Y.QTY203, X.QTY204 = Y.QTY204, X.QTY205 = Y.QTY205
                       , X.QTY206 = Y.QTY206, X.QTY207 = Y.QTY207, X.QTY208 = Y.QTY208, X.QTY209 = Y.QTY209, X.QTY210 = Y.QTY210
                       , X.QTY211 = Y.QTY211, X.QTY212 = Y.QTY212, X.QTY213 = Y.QTY213, X.QTY214 = Y.QTY214, X.QTY215 = Y.QTY215
                       , X.QTY216 = Y.QTY216, X.QTY217 = Y.QTY217, X.QTY218 = Y.QTY218, X.QTY219 = Y.QTY219, X.QTY220 = Y.QTY220
                       , X.QTY221 = Y.QTY221, X.QTY222 = Y.QTY222, X.QTY223 = Y.QTY223, X.QTY224 = Y.QTY224, X.QTY225 = Y.QTY225
                       , X.QTY226 = Y.QTY226, X.QTY227 = Y.QTY227, X.QTY228 = Y.QTY228, X.QTY229 = Y.QTY229, X.QTY230 = Y.QTY230
                       , X.QTY231 = Y.QTY231, X.QTY232 = Y.QTY232, X.QTY233 = Y.QTY233, X.QTY234 = Y.QTY234, X.QTY235 = Y.QTY235
                       , X.QTY236 = Y.QTY236, X.QTY237 = Y.QTY237, X.QTY238 = Y.QTY238, X.QTY239 = Y.QTY239, X.QTY240 = Y.QTY240
                       , X.QTY241 = Y.QTY241, X.QTY242 = Y.QTY242, X.QTY243 = Y.QTY243, X.QTY244 = Y.QTY244, X.QTY245 = Y.QTY245
                       , X.QTY246 = Y.QTY246, X.QTY247 = Y.QTY247, X.QTY248 = Y.QTY248, X.QTY249 = Y.QTY249, X.QTY250 = Y.QTY250
                       , X.QTY251 = Y.QTY251, X.QTY252 = Y.QTY252, X.QTY253 = Y.QTY253, X.QTY254 = Y.QTY254, X.QTY255 = Y.QTY255
                       , X.QTY256 = Y.QTY256, X.QTY257 = Y.QTY257, X.QTY258 = Y.QTY258, X.QTY259 = Y.QTY259, X.QTY260 = Y.QTY260
                       , X.QTY261 = Y.QTY261, X.QTY262 = Y.QTY262, X.QTY263 = Y.QTY263, X.QTY264 = Y.QTY264, X.QTY265 = Y.QTY265
                       , X.QTY266 = Y.QTY266, X.QTY267 = Y.QTY267, X.QTY268 = Y.QTY268, X.QTY269 = Y.QTY269, X.QTY270 = Y.QTY270
                       , X.QTY271 = Y.QTY271, X.QTY272 = Y.QTY272, X.QTY273 = Y.QTY273, X.QTY274 = Y.QTY274, X.QTY275 = Y.QTY275
                       , X.QTY276 = Y.QTY276, X.QTY277 = Y.QTY277, X.QTY278 = Y.QTY278, X.QTY279 = Y.QTY279, X.QTY280 = Y.QTY280
                       , X.QTY281 = Y.QTY281, X.QTY282 = Y.QTY282, X.QTY283 = Y.QTY283, X.QTY284 = Y.QTY284, X.QTY285 = Y.QTY285
                       , X.QTY286 = Y.QTY286, X.QTY287 = Y.QTY287, X.QTY288 = Y.QTY288, X.QTY289 = Y.QTY289, X.QTY290 = Y.QTY290
                       , X.QTY291 = Y.QTY291, X.QTY292 = Y.QTY292, X.QTY293 = Y.QTY293, X.QTY294 = Y.QTY294, X.QTY295 = Y.QTY295
                       , X.QTY296 = Y.QTY296, X.QTY297 = Y.QTY297, X.QTY298 = Y.QTY298, X.QTY299 = Y.QTY299, X.QTY300 = Y.QTY300
                       , X.QTY301 = Y.QTY301, X.QTY302 = Y.QTY302, X.QTY303 = Y.QTY303, X.QTY304 = Y.QTY304, X.QTY305 = Y.QTY305
                       , X.QTY306 = Y.QTY306, X.QTY307 = Y.QTY307, X.QTY308 = Y.QTY308, X.QTY309 = Y.QTY309, X.QTY310 = Y.QTY310
                       , X.QTY311 = Y.QTY311, X.QTY312 = Y.QTY312, X.QTY313 = Y.QTY313, X.QTY314 = Y.QTY314, X.QTY315 = Y.QTY315
                       , X.QTY316 = Y.QTY316, X.QTY317 = Y.QTY317, X.QTY318 = Y.QTY318, X.QTY319 = Y.QTY319, X.QTY320 = Y.QTY320
                       , X.QTY321 = Y.QTY321, X.QTY322 = Y.QTY322, X.QTY323 = Y.QTY323, X.QTY324 = Y.QTY324, X.QTY325 = Y.QTY325
                       , X.QTY326 = Y.QTY326, X.QTY327 = Y.QTY327, X.QTY328 = Y.QTY328, X.QTY329 = Y.QTY329, X.QTY330 = Y.QTY330
                       , X.QTY331 = Y.QTY331, X.QTY332 = Y.QTY332, X.QTY333 = Y.QTY333, X.QTY334 = Y.QTY334, X.QTY335 = Y.QTY335
                       , X.QTY336 = Y.QTY336, X.QTY337 = Y.QTY337, X.QTY338 = Y.QTY338, X.QTY339 = Y.QTY339, X.QTY340 = Y.QTY340
                       , X.QTY341 = Y.QTY341, X.QTY342 = Y.QTY342, X.QTY343 = Y.QTY343, X.QTY344 = Y.QTY344, X.QTY345 = Y.QTY345
                       , X.QTY346 = Y.QTY346, X.QTY347 = Y.QTY347, X.QTY348 = Y.QTY348, X.QTY349 = Y.QTY349, X.QTY350 = Y.QTY350
                       , X.QTY351 = Y.QTY351, X.QTY352 = Y.QTY352, X.QTY353 = Y.QTY353, X.QTY354 = Y.QTY354, X.QTY355 = Y.QTY355
                       , X.QTY356 = Y.QTY356, X.QTY357 = Y.QTY357, X.QTY358 = Y.QTY358, X.QTY359 = Y.QTY359, X.QTY360 = Y.QTY360
                       , X.QTY361 = Y.QTY361, X.QTY362 = Y.QTY362, X.QTY363 = Y.QTY363, X.QTY364 = Y.QTY364

                     , X.WQTY01 = Y.QTY001 + Y.QTY002 + Y.QTY003 + Y.QTY004 + Y.QTY005 + Y.QTY006 + Y.QTY007
                     , X.WQTY02 = Y.QTY008 + Y.QTY009 + Y.QTY010 + Y.QTY011 + Y.QTY012 + Y.QTY013 + Y.QTY014
                     , X.WQTY03 = Y.QTY015 + Y.QTY016 + Y.QTY017 + Y.QTY018 + Y.QTY019 + Y.QTY020 + Y.QTY021
                     , X.WQTY04 = Y.QTY022 + Y.QTY023 + Y.QTY024 + Y.QTY025 + Y.QTY026 + Y.QTY027 + Y.QTY028
                     , X.WQTY05 = Y.QTY029 + Y.QTY030 + Y.QTY031 + Y.QTY032 + Y.QTY033 + Y.QTY034 + Y.QTY035
                     , X.WQTY06 = Y.QTY036 + Y.QTY037 + Y.QTY038 + Y.QTY039 + Y.QTY040 + Y.QTY041 + Y.QTY042
                     , X.WQTY07 = Y.QTY043 + Y.QTY044 + Y.QTY045 + Y.QTY046 + Y.QTY047 + Y.QTY048 + Y.QTY049
                     , X.WQTY08 = Y.QTY050 + Y.QTY051 + Y.QTY052 + Y.QTY053 + Y.QTY054 + Y.QTY055 + Y.QTY056
                     , X.WQTY09 = Y.QTY057 + Y.QTY058 + Y.QTY059 + Y.QTY060 + Y.QTY061 + Y.QTY062 + Y.QTY063
                     , X.WQTY10 = Y.QTY064 + Y.QTY065 + Y.QTY066 + Y.QTY067 + Y.QTY068 + Y.QTY069 + Y.QTY070
                     , X.WQTY11 = Y.QTY071 + Y.QTY072 + Y.QTY073 + Y.QTY074 + Y.QTY075 + Y.QTY076 + Y.QTY077
                     , X.WQTY12 = Y.QTY078 + Y.QTY079 + Y.QTY080 + Y.QTY081 + Y.QTY082 + Y.QTY083 + Y.QTY084
                     , X.WQTY13 = Y.QTY085 + Y.QTY086 + Y.QTY087 + Y.QTY088 + Y.QTY089 + Y.QTY090 + Y.QTY091
                     , X.WQTY14 = Y.QTY092 + Y.QTY093 + Y.QTY094 + Y.QTY095 + Y.QTY096 + Y.QTY097 + Y.QTY098
                     , X.WQTY15 = Y.QTY099 + Y.QTY100 + Y.QTY101 + Y.QTY102 + Y.QTY103 + Y.QTY104 + Y.QTY105
                     , X.WQTY16 = Y.QTY106 + Y.QTY107 + Y.QTY108 + Y.QTY109 + Y.QTY110 + Y.QTY111 + Y.QTY112
                     , X.WQTY17 = Y.QTY113 + Y.QTY114 + Y.QTY115 + Y.QTY116 + Y.QTY117 + Y.QTY118 + Y.QTY119
                     , X.WQTY18 = Y.QTY120 + Y.QTY121 + Y.QTY122 + Y.QTY123 + Y.QTY124 + Y.QTY125 + Y.QTY126
                     , X.WQTY19 = Y.QTY127 + Y.QTY128 + Y.QTY129 + Y.QTY130 + Y.QTY131 + Y.QTY132 + Y.QTY133
                     , X.WQTY20 = Y.QTY134 + Y.QTY135 + Y.QTY136 + Y.QTY137 + Y.QTY138 + Y.QTY139 + Y.QTY140
                     , X.WQTY21 = Y.QTY141 + Y.QTY142 + Y.QTY143 + Y.QTY144 + Y.QTY145 + Y.QTY146 + Y.QTY147
                     , X.WQTY22 = Y.QTY148 + Y.QTY149 + Y.QTY150 + Y.QTY151 + Y.QTY152 + Y.QTY153 + Y.QTY154
                     , X.WQTY23 = Y.QTY155 + Y.QTY156 + Y.QTY157 + Y.QTY158 + Y.QTY159 + Y.QTY160 + Y.QTY161
                     , X.WQTY24 = Y.QTY162 + Y.QTY163 + Y.QTY164 + Y.QTY165 + Y.QTY166 + Y.QTY167 + Y.QTY168
                     , X.WQTY25 = Y.QTY169 + Y.QTY170 + Y.QTY171 + Y.QTY172 + Y.QTY173 + Y.QTY174 + Y.QTY175
                     , X.WQTY26 = Y.QTY176 + Y.QTY177 + Y.QTY178 + Y.QTY179 + Y.QTY180 + Y.QTY181 + Y.QTY182
                     , X.WQTY27 = Y.QTY183 + Y.QTY184 + Y.QTY185 + Y.QTY186 + Y.QTY187 + Y.QTY188 + Y.QTY189
                     , X.WQTY28 = Y.QTY190 + Y.QTY191 + Y.QTY192 + Y.QTY193 + Y.QTY194 + Y.QTY195 + Y.QTY196
                     , X.WQTY29 = Y.QTY197 + Y.QTY198 + Y.QTY199 + Y.QTY200 + Y.QTY201 + Y.QTY202 + Y.QTY203
                     , X.WQTY30 = Y.QTY204 + Y.QTY205 + Y.QTY206 + Y.QTY207 + Y.QTY208 + Y.QTY209 + Y.QTY210
                     , X.WQTY31 = Y.QTY211 + Y.QTY212 + Y.QTY213 + Y.QTY214 + Y.QTY215 + Y.QTY216 + Y.QTY217
                     , X.WQTY32 = Y.QTY218 + Y.QTY219 + Y.QTY220 + Y.QTY221 + Y.QTY222 + Y.QTY223 + Y.QTY224
                     , X.WQTY33 = Y.QTY225 + Y.QTY226 + Y.QTY227 + Y.QTY228 + Y.QTY229 + Y.QTY230 + Y.QTY231
                     , X.WQTY34 = Y.QTY232 + Y.QTY233 + Y.QTY234 + Y.QTY235 + Y.QTY236 + Y.QTY237 + Y.QTY238
                     , X.WQTY35 = Y.QTY239 + Y.QTY240 + Y.QTY241 + Y.QTY242 + Y.QTY243 + Y.QTY244 + Y.QTY245
                     , X.WQTY36 = Y.QTY246 + Y.QTY247 + Y.QTY248 + Y.QTY249 + Y.QTY250 + Y.QTY251 + Y.QTY252
                     , X.WQTY37 = Y.QTY253 + Y.QTY254 + Y.QTY255 + Y.QTY256 + Y.QTY257 + Y.QTY258 + Y.QTY259
                     , X.WQTY38 = Y.QTY260 + Y.QTY261 + Y.QTY262 + Y.QTY263 + Y.QTY264 + Y.QTY265 + Y.QTY266
                     , X.WQTY39 = Y.QTY267 + Y.QTY268 + Y.QTY269 + Y.QTY270 + Y.QTY271 + Y.QTY272 + Y.QTY273
                     , X.WQTY40 = Y.QTY274 + Y.QTY275 + Y.QTY276 + Y.QTY277 + Y.QTY278 + Y.QTY279 + Y.QTY280
                     , X.WQTY41 = Y.QTY281 + Y.QTY282 + Y.QTY283 + Y.QTY284 + Y.QTY285 + Y.QTY286 + Y.QTY287
                     , X.WQTY42 = Y.QTY288 + Y.QTY289 + Y.QTY290 + Y.QTY291 + Y.QTY292 + Y.QTY293 + Y.QTY294
                     , X.WQTY43 = Y.QTY295 + Y.QTY296 + Y.QTY297 + Y.QTY298 + Y.QTY299 + Y.QTY300 + Y.QTY301
                     , X.WQTY44 = Y.QTY302 + Y.QTY303 + Y.QTY304 + Y.QTY305 + Y.QTY306 + Y.QTY307 + Y.QTY308
                     , X.WQTY45 = Y.QTY309 + Y.QTY310 + Y.QTY311 + Y.QTY312 + Y.QTY313 + Y.QTY314 + Y.QTY315
                     , X.WQTY46 = Y.QTY316 + Y.QTY317 + Y.QTY318 + Y.QTY319 + Y.QTY320 + Y.QTY321 + Y.QTY322
                     , X.WQTY47 = Y.QTY323 + Y.QTY324 + Y.QTY325 + Y.QTY326 + Y.QTY327 + Y.QTY328 + Y.QTY329
                     , X.WQTY48 = Y.QTY330 + Y.QTY331 + Y.QTY332 + Y.QTY333 + Y.QTY334 + Y.QTY335 + Y.QTY336
                     , X.WQTY49 = Y.QTY337 + Y.QTY338 + Y.QTY339 + Y.QTY340 + Y.QTY341 + Y.QTY342 + Y.QTY343
                     , X.WQTY50 = Y.QTY344 + Y.QTY345 + Y.QTY346 + Y.QTY347 + Y.QTY348 + Y.QTY349 + Y.QTY350
                     , X.WQTY51 = Y.QTY351 + Y.QTY352 + Y.QTY353 + Y.QTY354 + Y.QTY355 + Y.QTY356 + Y.QTY357
                     , X.WQTY52 = Y.QTY358 + Y.QTY359 + Y.QTY360 + Y.QTY361 + Y.QTY362 + Y.QTY363 + Y.QTY364
                     , X.LAST_UPDATED_BY  = V_BATCH_USER_SIM
                     , X.LAST_UPDATE_DATE = SYSDATE;
            END IF;

            IF V_BATCH_MEASURE IN ('PACK_PROD', 'CELL_PROD', 'PACK_MODEL_CHANGE', 'CELL_MODEL_CHANGE') THEN   /* 형교환(Model Change) 적용 2021.08.12 */
                /* ------------------------------------------------------------------------------------- */
                /*  LINE_TOTAL_LOAD_ENGINE UPDATE (TACT_TIME,WORKING_TIME)  , PACK_PROD_LOAD,CELL_PROD_LOAD */
                /* ------------------------------------------------------------------------------------- */
                /*  MSSQL 대입형 SELECT -> 커서 FOR 루프 (0행이면 기존값 유지) */
                FOR R IN ( SELECT S.COMPANY_ID
                             FROM SCM_MST_SITE S
                                , ( SELECT DIVISION_ID, FROM_SITE
                                      FROM SCP_XLS_PSI_GLOBAL
                                     WHERE 0 = 0
                                       AND DIVISION_ID          = V_BATCH_DIVISION_ID
                                       AND PLAN_START_YYYYMMDD  = V_BATCH_PLAN_START_YYYYMMDD
                                       AND CREATE_FROM_YYYYMMDD = V_BATCH_CREATE_FROM_YYYYMMDD
                                       AND SEQ                  = V_BATCH_SEQ
                                       AND XLS_KEY1             = V_BATCH_XLS_KEY1 ) B
                            WHERE S.SITE_TYPE   = 'PLANT'
                              AND S.VALID_YN    = 'Y'
                              AND S.DIVISION_ID = B.DIVISION_ID
                              AND S.SCM_SITE_ID = B.FROM_SITE
                         )
                LOOP
                    V_COMPANY_ID := SUBSTR(R.COMPANY_ID, 1, 100);
                END LOOP;

                /* ------------------------------------------------------------------------------------- */
                /*  Line Load 율 로직 작업중 */
                /* ------------------------------------------------------------------------------------- */
                /*  IF OBJECT_ID('tempdb..#LINE_WORKINGTIME_BY_LOSS') IS NOT NULL DROP TABLE #LINE_WORKINGTIME_BY_LOSS;
                    CREATE TABLE #LINE_WORKINGTIME_BY_LOSS (
                        DIVISION_ID VARCHAR(100) NOT NULL, SCM_SITE_ID VARCHAR(100) NOT NULL,
                        OPERATION_ID VARCHAR(100) NOT NULL, LINE_ID VARCHAR(100) NOT NULL,
                        YYYYMMDD VARCHAR(100) NOT NULL, WORKING_TIME INT NULL ) */
                DELETE FROM GT_XPGT_LINE_WORKINGTIME_LOSS;

                /*  MSSQL 대입형 SELECT -> 커서 FOR 루프 */
                FOR R IN ( SELECT PROD_LINE
                             FROM SCP_XLS_PSI_GLOBAL
                            WHERE XLS_KEY1             = V_BATCH_XLS_KEY1
                              AND CREATE_FROM_YYYYMMDD = V_BATCH_CREATE_FROM_YYYYMMDD
                              AND DIVISION_ID          = V_BATCH_DIVISION_ID   /* 2022.03.23 KSW GM JV 반영 */
                         )
                LOOP
                    V_LINE_ID := SUBSTR(R.PROD_LINE, 1, 100);
                END LOOP;

                /*  Working Time 추출 */
                INSERT INTO GT_XPGT_LINE_WORKINGTIME_LOSS
                     ( DIVISION_ID
                     , SCM_SITE_ID
                     , OPERATION_ID
                     , LINE_ID
                     , YYYYMMDD
                     , WORKING_TIME )
                SELECT DIVISION_ID
                     , PLANT_SITE_ID AS SCM_SITE_ID
                     , OPERATION_ID
                     , LINE_ID
                     , YYYYMMDD
                     , TRUNC(WORKING_TIME) AS WORKING_TIME
                  FROM TABLE(FN_LINE_WORKINGTIME_BY_LOSS( V_BATCH_DIVISION_ID
                                                        , V_BATCH_CREATE_FROM_YYYYMMDD
                                                        , V_BATCH_CREATE_TO_YYYYMMDD
                                                        , V_LINE_ID ))
                 WHERE LINE_ID = V_LINE_ID;

                /*  IF OBJECT_ID('tempdb..#LineLoad') IS NOT NULL DROP TABLE #LineLoad;
                    CREATE TABLE #LineLoad ( DIVISION_ID NVARCHAR(200) NOT NULL, SCM_SITE_ID NVARCHAR(200) NOT NULL,
                        OPERATION_GROUP NVARCHAR(200) NOT NULL, OPERATION_ID NVARCHAR(200) NOT NULL,
                        LINE_ID NVARCHAR(200) NOT NULL, MEASURE NVARCHAR(200) NOT NULL, QTY INT NULL,
                        CAPA_TACT INT NULL, WORKING_TIME INT NULL, YYYYMMDD NVARCHAR(8) NULL,
                    -> 계열 GTT GT_XPGT_LINELOAD(13컬럼, ★배포본 이름은 LINELOAD - LINE_LOAD 아님). 사용 직전 초기화. */
                DELETE FROM GT_XPGT_LINELOAD;

                INSERT INTO GT_XPGT_LINELOAD
                     ( DIVISION_ID
                     , SCM_SITE_ID
                     , OPERATION_GROUP
                     , OPERATION_ID
                     , LINE_ID
                     , MEASURE
                     , QTY
                     , CAPA_TACT
                     , WORKING_TIME
                     , YYYYMMDD
                     , ISO_YYYYWW
                     , TIME_TERM
                     , WEEK_COLUMN )
                SELECT /* DISTINCT */
                       A.DIVISION_ID
                     , A.SCM_SITE_ID
                     , A.OPERATION_GROUP
                     , A.OPERATION_ID
                     , A.LINE_ID
                     , (CASE WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'P' THEN 'PACK_PROD_LOAD'
                             WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'A' THEN 'CELL_PROD_LOAD' END ) AS MEASURE
                     , TRUNC(CASE WHEN D.WORKING_TIME <= 0.0 THEN 0
                                  ELSE NVL(((ROUND(SUM(A.QTY * (E.TACT_TIME / 60)), 0) / D.WORKING_TIME)), 0) * 100
                             END) AS QTY
                     , TRUNC(NVL(ROUND(SUM(A.QTY * (E.TACT_TIME / 60)), 0), 0)) AS CAPA_TACT
                     , TRUNC(NVL(D.WORKING_TIME, 0)) AS WORKING_TIME
                     , A.YYYYMMDD AS YYYYMMDD
                     , C.ISO_YYYYWW AS ISO_YYYYWW
                     , TRUNC(M.TIME_TERM) AS TIME_TERM        /* 형교환(Model Change) */
                     /*  MSSQL 'WQTY' + REPLICATE('0', 2 - LEN(DENSE_RANK() OVER(..))) + CONVERT(NVARCHAR, DENSE_RANK() OVER(..)) */
                     , 'WQTY' || LPAD(TO_CHAR(DENSE_RANK() OVER(PARTITION BY A.LINE_ID ORDER BY C.ISO_YYYYWW)), 2, '0') AS WEEK_COLUMN
                  FROM SCP_ANL_PRODUCTION_PLAN A
                       INNER JOIN SCM_SYS_CALENDAR_M C
                               ON A.YYYYMMDD = C.BASIS_YYYYMMDD
                       LEFT OUTER JOIN GT_XPGT_LINE_WORKINGTIME_LOSS D
                               ON A.DIVISION_ID  = D.DIVISION_ID
                              AND A.OPERATION_ID = D.OPERATION_ID
                              AND A.SCM_SITE_ID  = D.SCM_SITE_ID
                              AND A.LINE_ID      = D.LINE_ID
                              AND A.YYYYMMDD     = D.YYYYMMDD
                       LEFT OUTER JOIN SCP_ANL_TACT_TIME E
                               ON A.DIVISION_ID  = E.DIVISION_ID
                              AND A.OPERATION_ID = E.OPERATION_ID
                              AND A.SCM_SITE_ID  = E.SCM_SITE_ID
                              AND A.LINE_ID      = E.LINE_ID
                              AND A.ITEM_ID      = E.ITEM_ID
                              AND A.YYYYMMDD     = E.YYYYMMDD
                       /*  형교환(Model Change) 적용 - start */
                       LEFT OUTER JOIN SCM_WORK_CALENDAR_M_SN M
                               ON A.DIVISION_ID           = M.DIVISION_ID

                              AND SUBSTR(A.SCM_SITE_ID, 1, 4) = M.PLANT_ID
                              AND A.OPERATION_ID         = M.OPERATION_ID
                              /*  AND A.YYYYMMDD          = CONVERT(VARCHAR(8), M.WORK_DATE) */
                              /*  MSSQL convert(datetime, A.YYYYMMDD) -> TO_DATE(A.YYYYMMDD, 'YYYYMMDD') */
                              AND TO_DATE(A.YYYYMMDD, 'YYYYMMDD') = M.WORK_DATE
                              AND A.LINE_ID              = M.LINE_ID
                              AND M.LOSS_CODE            = 'XC031'
                              AND M.COMPANY_ID           = V_COMPANY_ID
                       /*  형교환(Model Change) 적용 - end */
                 WHERE 1 = 1
                   AND A.DIVISION_ID         = V_BATCH_DIVISION_ID
                   AND A.PLAN_START_YYYYMMDD = V_BATCH_PLAN_START_YYYYMMDD
                   AND A.PLAN_TYPE           = V_BATCH_PLAN_TYPE
                   AND A.SEQ                 = V_BATCH_SEQ
                   AND A.YYYYMMDD           >= V_BATCH_CREATE_FROM_YYYYMMDD
                   AND A.YYYYMMDD           <  TO_CHAR(TO_DATE(V_BATCH_CREATE_FROM_YYYYMMDD, 'YYYYMMDD') + 364, 'YYYYMMDD')   /* @v_batch_create_to_yyyymmdd */
                   AND A.MEASURE             = 'PROD_PLAN_AMEND'
                   AND A.LINE_ID             = V_LINE_ID
                 GROUP BY A.DIVISION_ID, A.SCM_SITE_ID, A.OPERATION_ID, A.LINE_ID, A.YYYYMMDD, D.WORKING_TIME, C.ISO_YYYYWW, A.OPERATION_GROUP
                        , (CASE WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'P' THEN 'PACK_PROD_LOAD'
                                WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'A' THEN 'CELL_PROD_LOAD' END )
                        , M.TIME_TERM;        /* 형교환(Model Change) */

                /* ------------------------------------------------------------------------------------- */
                /*   364일 데이터 생성(PIVOIT 대상 날짜문자열 생성) */
                /* ------------------------------------------------------------------------------------- */
                /*  MSSQL 문자열 집계 SELECT @mQry_sum = @mQry_sum + ... FROM .. ORDER BY ..
                    ★선두 콤마 방식 그대로다(뒤에 ' ' + @mQry_sum 로 붙는 자리에 이미 컬럼이 있다). */
                V_MQRY_SUM := '';
                FOR R IN ( SELECT ' SUM(CASE WHEN YYYYMMDD = ''' || A.YYYYMMDD || '''    THEN QTY ELSE 0 END ) AS '
                                  || 'QTY' || LPAD(TO_CHAR(ROW_NUMBER() OVER(ORDER BY A.YYYYMMDD)), 3, '0') AS COL_EXPR
                             FROM ( SELECT A.BASIS_YYYYMMDD          AS YYYYMMDD
                                         , A.BASIS_YYYYMMDD || '31'  AS SORT_ORDER_NO
                                      FROM SCM_SYS_CALENDAR_M A
                                     WHERE A.BASIS_YYYYMMDD BETWEEN V_BATCH_CREATE_FROM_YYYYMMDD
                                                                AND TO_CHAR(TO_DATE(V_BATCH_CREATE_FROM_YYYYMMDD, 'YYYYMMDD') + 364, 'YYYYMMDD')   /* @v_batch_create_to_yyyymmdd */
                                     /*  WHERE A.BASIS_YYYYMMDD >= @v_batch_create_from_yyyymmdd
                                           AND A.BASIS_YYYYMMDD <  CONVERT(VARCHAR(8), DATEADD(day, 364, @v_batch_create_from_yyyymmdd), 112) */
                                     GROUP BY A.BASIS_YYYYMMDD
                                  ) A
                            ORDER BY A.SORT_ORDER_NO )
                LOOP
                    V_MQRY_SUM := V_MQRY_SUM || ',' || R.COL_EXPR || '' || CHR(10);
                END LOOP;

                /*  MSSQL 동적 UPDATE X SET .. FROM SCP_XLS_PSI_GLOBAL X INNER JOIN (GROUP BY 인라인뷰) Y ON ..
                    -> Oracle 은 UPDATE .. FROM 이 없다. 원천이 GROUP BY 로 조인키당 유일하므로 MERGE 로 옮긴다(CV-024).
                    ★조인에 DIVISION_ID 가 빠져 있으나 원천 GT_XPGT_LINELOAD 는 위 INSERT 에서
                      A.DIVISION_ID = V_BATCH_DIVISION_ID 로 이미 한 사업부만 담기므로 다중매치가 성립하지 않는다. */
                V_MEXEC := '';
                V_MEXEC := V_MEXEC || 'MERGE INTO SCP_XLS_PSI_GLOBAL X' || CHR(10);
                V_MEXEC := V_MEXEC || ' USING ( SELECT A.DIVISION_ID' || CHR(10);
                V_MEXEC := V_MEXEC || '              ,A.OPERATION_GROUP' || CHR(10);
                V_MEXEC := V_MEXEC || '              ,A.SCM_SITE_ID' || CHR(10);
                V_MEXEC := V_MEXEC || '              ,A.OPERATION_ID' || CHR(10);
                V_MEXEC := V_MEXEC || '              ,A.MEASURE' || CHR(10);
                V_MEXEC := V_MEXEC || '              ,A.LINE_ID ' || CHR(10);
                V_MEXEC := V_MEXEC || '                            ' || V_MQRY_SUM || '  ' || CHR(10);
                V_MEXEC := V_MEXEC || '                     FROM GT_XPGT_LINELOAD A' || CHR(10);
                V_MEXEC := V_MEXEC || '                    GROUP BY  A.DIVISION_ID' || CHR(10);
                V_MEXEC := V_MEXEC || '                             ,A.OPERATION_GROUP' || CHR(10);
                V_MEXEC := V_MEXEC || '                             ,A.SCM_SITE_ID' || CHR(10);
                V_MEXEC := V_MEXEC || '                             ,A.OPERATION_ID' || CHR(10);
                V_MEXEC := V_MEXEC || '                             ,A.MEASURE' || CHR(10);
                V_MEXEC := V_MEXEC || '                             ,A.LINE_ID' || CHR(10);
                V_MEXEC := V_MEXEC || '       ) Y ' || CHR(10);
                V_MEXEC := V_MEXEC || '    ON ( 0 = 0' || CHR(10);
                V_MEXEC := V_MEXEC || '         AND X.OPERATION_GROUP   = Y.OPERATION_GROUP' || CHR(10);
                V_MEXEC := V_MEXEC || '         AND X.FROM_SITE         = Y.SCM_SITE_ID' || CHR(10);
                V_MEXEC := V_MEXEC || '         AND X.ATTRIBUTE9        = Y.OPERATION_ID' || CHR(10);
                V_MEXEC := V_MEXEC || '         AND X.PROD_LINE         = Y.LINE_ID' || CHR(10);
                V_MEXEC := V_MEXEC || '         AND X.MEASURE           = Y.MEASURE' || CHR(10);
                V_MEXEC := V_MEXEC || '         AND X.CREATE_FROM_YYYYMMDD = ''' || V_BATCH_CREATE_FROM_YYYYMMDD || '''' || CHR(10);
                V_MEXEC := V_MEXEC || '         AND X.DIVISION_ID          = ''' || V_BATCH_DIVISION_ID || ''' )' || CHR(10);   /* 2022.03.23 KSW GM JV 반영 */
                V_MEXEC := V_MEXEC || ' WHEN MATCHED THEN UPDATE SET ' || CHR(10);
                V_MEXEC := V_MEXEC || '        X.QTY001 = Y.QTY001, X.QTY002 = Y.QTY002, X.QTY003 = Y.QTY003, X.QTY004 = Y.QTY004, X.QTY005 = Y.QTY005, X.QTY006 = Y.QTY006, X.QTY007 = Y.QTY007, X.QTY008 = Y.QTY008, X.QTY009 = Y.QTY009, X.QTY010 = Y.QTY010,' || CHR(10);
                V_MEXEC := V_MEXEC || '        X.QTY011 = Y.QTY011, X.QTY012 = Y.QTY012, X.QTY013 = Y.QTY013, X.QTY014 = Y.QTY014, X.QTY015 = Y.QTY015, X.QTY016 = Y.QTY016, X.QTY017 = Y.QTY017, X.QTY018 = Y.QTY018, X.QTY019 = Y.QTY019, X.QTY020 = Y.QTY020,' || CHR(10);
                V_MEXEC := V_MEXEC || '        X.QTY021 = Y.QTY021, X.QTY022 = Y.QTY022, X.QTY023 = Y.QTY023, X.QTY024 = Y.QTY024, X.QTY025 = Y.QTY025, X.QTY026 = Y.QTY026, X.QTY027 = Y.QTY027, X.QTY028 = Y.QTY028, X.QTY029 = Y.QTY029, X.QTY030 = Y.QTY030,' || CHR(10);
                V_MEXEC := V_MEXEC || '        X.QTY031 = Y.QTY031, X.QTY032 = Y.QTY032, X.QTY033 = Y.QTY033, X.QTY034 = Y.QTY034, X.QTY035 = Y.QTY035, X.QTY036 = Y.QTY036, X.QTY037 = Y.QTY037, X.QTY038 = Y.QTY038, X.QTY039 = Y.QTY039, X.QTY040 = Y.QTY040,' || CHR(10);
                V_MEXEC := V_MEXEC || '        X.QTY041 = Y.QTY041, X.QTY042 = Y.QTY042, X.QTY043 = Y.QTY043, X.QTY044 = Y.QTY044, X.QTY045 = Y.QTY045, X.QTY046 = Y.QTY046, X.QTY047 = Y.QTY047, X.QTY048 = Y.QTY048, X.QTY049 = Y.QTY049, X.QTY050 = Y.QTY050,' || CHR(10);
                V_MEXEC := V_MEXEC || '        X.QTY051 = Y.QTY051, X.QTY052 = Y.QTY052, X.QTY053 = Y.QTY053, X.QTY054 = Y.QTY054, X.QTY055 = Y.QTY055, X.QTY056 = Y.QTY056, X.QTY057 = Y.QTY057, X.QTY058 = Y.QTY058, X.QTY059 = Y.QTY059, X.QTY060 = Y.QTY060,' || CHR(10);
                V_MEXEC := V_MEXEC || '        X.QTY061 = Y.QTY061, X.QTY062 = Y.QTY062, X.QTY063 = Y.QTY063, X.QTY064 = Y.QTY064, X.QTY065 = Y.QTY065, X.QTY066 = Y.QTY066, X.QTY067 = Y.QTY067, X.QTY068 = Y.QTY068, X.QTY069 = Y.QTY069, X.QTY070 = Y.QTY070,' || CHR(10);
                V_MEXEC := V_MEXEC || '        X.QTY071 = Y.QTY071, X.QTY072 = Y.QTY072, X.QTY073 = Y.QTY073, X.QTY074 = Y.QTY074, X.QTY075 = Y.QTY075, X.QTY076 = Y.QTY076, X.QTY077 = Y.QTY077, X.QTY078 = Y.QTY078, X.QTY079 = Y.QTY079, X.QTY080 = Y.QTY080,' || CHR(10);
                V_MEXEC := V_MEXEC || '        X.QTY081 = Y.QTY081, X.QTY082 = Y.QTY082, X.QTY083 = Y.QTY083, X.QTY084 = Y.QTY084, X.QTY085 = Y.QTY085, X.QTY086 = Y.QTY086, X.QTY087 = Y.QTY087, X.QTY088 = Y.QTY088, X.QTY089 = Y.QTY089, X.QTY090 = Y.QTY090,' || CHR(10);
                V_MEXEC := V_MEXEC || '        X.QTY091 = Y.QTY091, X.QTY092 = Y.QTY092, X.QTY093 = Y.QTY093, X.QTY094 = Y.QTY094, X.QTY095 = Y.QTY095, X.QTY096 = Y.QTY096, X.QTY097 = Y.QTY097, X.QTY098 = Y.QTY098, X.QTY099 = Y.QTY099, X.QTY100 = Y.QTY100,' || CHR(10);
                V_MEXEC := V_MEXEC || '        X.QTY101 = Y.QTY101, X.QTY102 = Y.QTY102, X.QTY103 = Y.QTY103, X.QTY104 = Y.QTY104, X.QTY105 = Y.QTY105, X.QTY106 = Y.QTY106, X.QTY107 = Y.QTY107, X.QTY108 = Y.QTY108, X.QTY109 = Y.QTY109, X.QTY110 = Y.QTY110,' || CHR(10);
                V_MEXEC := V_MEXEC || '        X.QTY111 = Y.QTY111, X.QTY112 = Y.QTY112, X.QTY113 = Y.QTY113, X.QTY114 = Y.QTY114, X.QTY115 = Y.QTY115, X.QTY116 = Y.QTY116, X.QTY117 = Y.QTY117, X.QTY118 = Y.QTY118, X.QTY119 = Y.QTY119, X.QTY120 = Y.QTY120,' || CHR(10);
                V_MEXEC := V_MEXEC || '        X.QTY121 = Y.QTY121, X.QTY122 = Y.QTY122, X.QTY123 = Y.QTY123, X.QTY124 = Y.QTY124, X.QTY125 = Y.QTY125, X.QTY126 = Y.QTY126, X.QTY127 = Y.QTY127, X.QTY128 = Y.QTY128, X.QTY129 = Y.QTY129, X.QTY130 = Y.QTY130,' || CHR(10);
                V_MEXEC := V_MEXEC || '        X.QTY131 = Y.QTY131, X.QTY132 = Y.QTY132, X.QTY133 = Y.QTY133, X.QTY134 = Y.QTY134, X.QTY135 = Y.QTY135, X.QTY136 = Y.QTY136, X.QTY137 = Y.QTY137, X.QTY138 = Y.QTY138, X.QTY139 = Y.QTY139, X.QTY140 = Y.QTY140,' || CHR(10);
                V_MEXEC := V_MEXEC || '        X.QTY141 = Y.QTY141, X.QTY142 = Y.QTY142, X.QTY143 = Y.QTY143, X.QTY144 = Y.QTY144, X.QTY145 = Y.QTY145, X.QTY146 = Y.QTY146, X.QTY147 = Y.QTY147, X.QTY148 = Y.QTY148, X.QTY149 = Y.QTY149, X.QTY150 = Y.QTY150,' || CHR(10);
                V_MEXEC := V_MEXEC || '        X.QTY151 = Y.QTY151, X.QTY152 = Y.QTY152, X.QTY153 = Y.QTY153, X.QTY154 = Y.QTY154, X.QTY155 = Y.QTY155, X.QTY156 = Y.QTY156, X.QTY157 = Y.QTY157, X.QTY158 = Y.QTY158, X.QTY159 = Y.QTY159, X.QTY160 = Y.QTY160,' || CHR(10);
                V_MEXEC := V_MEXEC || '        X.QTY161 = Y.QTY161, X.QTY162 = Y.QTY162, X.QTY163 = Y.QTY163, X.QTY164 = Y.QTY164, X.QTY165 = Y.QTY165, X.QTY166 = Y.QTY166, X.QTY167 = Y.QTY167, X.QTY168 = Y.QTY168, X.QTY169 = Y.QTY169, X.QTY170 = Y.QTY170,' || CHR(10);
                V_MEXEC := V_MEXEC || '        X.QTY171 = Y.QTY171, X.QTY172 = Y.QTY172, X.QTY173 = Y.QTY173, X.QTY174 = Y.QTY174, X.QTY175 = Y.QTY175, X.QTY176 = Y.QTY176, X.QTY177 = Y.QTY177, X.QTY178 = Y.QTY178, X.QTY179 = Y.QTY179, X.QTY180 = Y.QTY180,' || CHR(10);
                V_MEXEC := V_MEXEC || '        X.QTY181 = Y.QTY181, X.QTY182 = Y.QTY182, X.QTY183 = Y.QTY183, X.QTY184 = Y.QTY184, X.QTY185 = Y.QTY185, X.QTY186 = Y.QTY186, X.QTY187 = Y.QTY187, X.QTY188 = Y.QTY188, X.QTY189 = Y.QTY189, X.QTY190 = Y.QTY190,' || CHR(10);
                V_MEXEC := V_MEXEC || '        X.QTY191 = Y.QTY191, X.QTY192 = Y.QTY192, X.QTY193 = Y.QTY193, X.QTY194 = Y.QTY194, X.QTY195 = Y.QTY195, X.QTY196 = Y.QTY196, X.QTY197 = Y.QTY197, X.QTY198 = Y.QTY198, X.QTY199 = Y.QTY199, X.QTY200 = Y.QTY200,' || CHR(10);
                V_MEXEC := V_MEXEC || '        X.QTY201 = Y.QTY201, X.QTY202 = Y.QTY202, X.QTY203 = Y.QTY203, X.QTY204 = Y.QTY204, X.QTY205 = Y.QTY205, X.QTY206 = Y.QTY206, X.QTY207 = Y.QTY207, X.QTY208 = Y.QTY208, X.QTY209 = Y.QTY209, X.QTY210 = Y.QTY210,' || CHR(10);
                V_MEXEC := V_MEXEC || '        X.QTY211 = Y.QTY211, X.QTY212 = Y.QTY212, X.QTY213 = Y.QTY213, X.QTY214 = Y.QTY214, X.QTY215 = Y.QTY215, X.QTY216 = Y.QTY216, X.QTY217 = Y.QTY217, X.QTY218 = Y.QTY218, X.QTY219 = Y.QTY219, X.QTY220 = Y.QTY220,' || CHR(10);
                V_MEXEC := V_MEXEC || '        X.QTY221 = Y.QTY221, X.QTY222 = Y.QTY222, X.QTY223 = Y.QTY223, X.QTY224 = Y.QTY224, X.QTY225 = Y.QTY225, X.QTY226 = Y.QTY226, X.QTY227 = Y.QTY227, X.QTY228 = Y.QTY228, X.QTY229 = Y.QTY229, X.QTY230 = Y.QTY230,' || CHR(10);
                V_MEXEC := V_MEXEC || '        X.QTY231 = Y.QTY231, X.QTY232 = Y.QTY232, X.QTY233 = Y.QTY233, X.QTY234 = Y.QTY234, X.QTY235 = Y.QTY235, X.QTY236 = Y.QTY236, X.QTY237 = Y.QTY237, X.QTY238 = Y.QTY238, X.QTY239 = Y.QTY239, X.QTY240 = Y.QTY240,' || CHR(10);
                V_MEXEC := V_MEXEC || '        X.QTY241 = Y.QTY241, X.QTY242 = Y.QTY242, X.QTY243 = Y.QTY243, X.QTY244 = Y.QTY244, X.QTY245 = Y.QTY245, X.QTY246 = Y.QTY246, X.QTY247 = Y.QTY247, X.QTY248 = Y.QTY248, X.QTY249 = Y.QTY249, X.QTY250 = Y.QTY250,' || CHR(10);
                V_MEXEC := V_MEXEC || '        X.QTY251 = Y.QTY251, X.QTY252 = Y.QTY252, X.QTY253 = Y.QTY253, X.QTY254 = Y.QTY254, X.QTY255 = Y.QTY255, X.QTY256 = Y.QTY256, X.QTY257 = Y.QTY257, X.QTY258 = Y.QTY258, X.QTY259 = Y.QTY259, X.QTY260 = Y.QTY260,' || CHR(10);
                V_MEXEC := V_MEXEC || '        X.QTY261 = Y.QTY261, X.QTY262 = Y.QTY262, X.QTY263 = Y.QTY263, X.QTY264 = Y.QTY264, X.QTY265 = Y.QTY265, X.QTY266 = Y.QTY266, X.QTY267 = Y.QTY267, X.QTY268 = Y.QTY268, X.QTY269 = Y.QTY269, X.QTY270 = Y.QTY270,' || CHR(10);
                V_MEXEC := V_MEXEC || '        X.QTY271 = Y.QTY271, X.QTY272 = Y.QTY272, X.QTY273 = Y.QTY273, X.QTY274 = Y.QTY274, X.QTY275 = Y.QTY275, X.QTY276 = Y.QTY276, X.QTY277 = Y.QTY277, X.QTY278 = Y.QTY278, X.QTY279 = Y.QTY279, X.QTY280 = Y.QTY280,' || CHR(10);
                V_MEXEC := V_MEXEC || '        X.QTY281 = Y.QTY281, X.QTY282 = Y.QTY282, X.QTY283 = Y.QTY283, X.QTY284 = Y.QTY284, X.QTY285 = Y.QTY285, X.QTY286 = Y.QTY286, X.QTY287 = Y.QTY287, X.QTY288 = Y.QTY288, X.QTY289 = Y.QTY289, X.QTY290 = Y.QTY290,' || CHR(10);
                V_MEXEC := V_MEXEC || '        X.QTY291 = Y.QTY291, X.QTY292 = Y.QTY292, X.QTY293 = Y.QTY293, X.QTY294 = Y.QTY294, X.QTY295 = Y.QTY295, X.QTY296 = Y.QTY296, X.QTY297 = Y.QTY297, X.QTY298 = Y.QTY298, X.QTY299 = Y.QTY299, X.QTY300 = Y.QTY300,' || CHR(10);
                V_MEXEC := V_MEXEC || '        X.QTY301 = Y.QTY301, X.QTY302 = Y.QTY302, X.QTY303 = Y.QTY303, X.QTY304 = Y.QTY304, X.QTY305 = Y.QTY305, X.QTY306 = Y.QTY306, X.QTY307 = Y.QTY307, X.QTY308 = Y.QTY308, X.QTY309 = Y.QTY309, X.QTY310 = Y.QTY310,' || CHR(10);
                V_MEXEC := V_MEXEC || '        X.QTY311 = Y.QTY311, X.QTY312 = Y.QTY312, X.QTY313 = Y.QTY313, X.QTY314 = Y.QTY314, X.QTY315 = Y.QTY315, X.QTY316 = Y.QTY316, X.QTY317 = Y.QTY317, X.QTY318 = Y.QTY318, X.QTY319 = Y.QTY319, X.QTY320 = Y.QTY320,' || CHR(10);
                V_MEXEC := V_MEXEC || '        X.QTY321 = Y.QTY321, X.QTY322 = Y.QTY322, X.QTY323 = Y.QTY323, X.QTY324 = Y.QTY324, X.QTY325 = Y.QTY325, X.QTY326 = Y.QTY326, X.QTY327 = Y.QTY327, X.QTY328 = Y.QTY328, X.QTY329 = Y.QTY329, X.QTY330 = Y.QTY330,' || CHR(10);
                V_MEXEC := V_MEXEC || '        X.QTY331 = Y.QTY331, X.QTY332 = Y.QTY332, X.QTY333 = Y.QTY333, X.QTY334 = Y.QTY334, X.QTY335 = Y.QTY335, X.QTY336 = Y.QTY336, X.QTY337 = Y.QTY337, X.QTY338 = Y.QTY338, X.QTY339 = Y.QTY339, X.QTY340 = Y.QTY340,' || CHR(10);
                V_MEXEC := V_MEXEC || '        X.QTY341 = Y.QTY341, X.QTY342 = Y.QTY342, X.QTY343 = Y.QTY343, X.QTY344 = Y.QTY344, X.QTY345 = Y.QTY345, X.QTY346 = Y.QTY346, X.QTY347 = Y.QTY347, X.QTY348 = Y.QTY348, X.QTY349 = Y.QTY349, X.QTY350 = Y.QTY350,' || CHR(10);
                V_MEXEC := V_MEXEC || '        X.QTY351 = Y.QTY351, X.QTY352 = Y.QTY352, X.QTY353 = Y.QTY353, X.QTY354 = Y.QTY354, X.QTY355 = Y.QTY355, X.QTY356 = Y.QTY356, X.QTY357 = Y.QTY357, X.QTY358 = Y.QTY358, X.QTY359 = Y.QTY359, X.QTY360 = Y.QTY360,' || CHR(10);
                V_MEXEC := V_MEXEC || '        X.QTY361 = Y.QTY361, X.QTY362 = Y.QTY362, X.QTY363 = Y.QTY363, X.QTY364 = Y.QTY364,' || CHR(10);
                V_MEXEC := V_MEXEC || '        X.LAST_UPDATED_BY = ''' || V_BATCH_USER_SIM || '''' || ',' || CHR(10);
                V_MEXEC := V_MEXEC || '        X.LAST_UPDATE_DATE = SYSDATE ' || CHR(10);

                /*  EXEC UP_XLS_PRINT @mEXEC--TEST */
                /*  MSSQL EXEC sp_executesql @mEXEC -> EXECUTE IMMEDIATE (CV-040) */
                EXECUTE IMMEDIATE V_MEXEC;

                /* ------------------------------------------------------------------------------------- */
                /*   WEEK SUM PIVOT 생성 후 UPDATE */
                /* ------------------------------------------------------------------------------------- */
                IF V_BATCH_MEASURE IN ('PACK_PROD_LOAD', 'CELL_PROD_LOAD') THEN
                    /*  IF OBJECT_ID('tempdb..#LineLoad_WEEK') IS NOT NULL DROP TABLE #LineLoad_WEEK; */
                    DELETE FROM GT_XPGT_LINELOAD_WEEK;

                    INSERT INTO GT_XPGT_LINELOAD_WEEK
                         ( DIVISION_ID
                         , SITE_ID
                         , OPERATION_ID
                         , PROD_LINE
                         , MEASURE
                         , WQTY
                         , ISO_YYYYWW
                         , WEEK_COLUMN )
                    SELECT A.DIVISION_ID
                         , A.SCM_SITE_ID AS SITE_ID
                         , A.OPERATION_ID
                         , A.LINE_ID AS PROD_LINE
                         , A.MEASURE
                         /*  형교환(Model Change) 적용 - start
                             변경전
                             ,CASE WHEN SUM(A.WORKING_TIME) <= 0.0   THEN 0
                                   ELSE ISNULL( ( ROUND(SUM(A.CAPA_TACT),0) / SUM(A.WORKING_TIME) ) ,0 ) *100
                              END AS WQTY
                             변경후 */
                         /*  ★MSSQL 은 #LineLoad 의 CAPA_TACT/WORKING_TIME/TIME_TERM 이 전부 INT 라 */
                         , CASE WHEN SUM(A.WORKING_TIME) <= 0.0 THEN 0
                                ELSE NVL( TRUNC( ROUND(SUM(A.CAPA_TACT), 0)
                                                 / NULLIF(SUM(A.WORKING_TIME) - NVL(SUM(A.TIME_TERM), 0), 0) ), 0 ) * 100
                           END AS WQTY
                         /*  형교환(Model Change) 적용 - end */
                         , A.ISO_YYYYWW
                         , A.WEEK_COLUMN
                      FROM GT_XPGT_LINELOAD A
                     GROUP BY A.DIVISION_ID
                            , A.SCM_SITE_ID
                            , A.OPERATION_ID
                            , A.LINE_ID
                            , A.MEASURE
                            , A.ISO_YYYYWW
                            , A.WEEK_COLUMN;

                    /*  IF OBJECT_ID('tempdb..#LineLoad_WEEK_PIVOT') IS NOT NULL DROP TABLE #LineLoad_WEEK_PIVOT; */
                    DELETE FROM GT_XPGT_LINELOAD_WEEK_PIVOT;

                    INSERT INTO GT_XPGT_LINELOAD_WEEK_PIVOT
                         ( DIVISION_ID
                         , SITE_ID
                         , OPERATION_ID
                         , PROD_LINE
                         , MEASURE
                         , WQTY01, WQTY02, WQTY03, WQTY04, WQTY05
                         , WQTY06, WQTY07, WQTY08, WQTY09, WQTY10
                         , WQTY11, WQTY12, WQTY13, WQTY14, WQTY15
                         , WQTY16, WQTY17, WQTY18, WQTY19, WQTY20
                         , WQTY21, WQTY22, WQTY23, WQTY24, WQTY25
                         , WQTY26, WQTY27, WQTY28, WQTY29, WQTY30
                         , WQTY31, WQTY32, WQTY33, WQTY34, WQTY35
                         , WQTY36, WQTY37, WQTY38, WQTY39, WQTY40
                         , WQTY41, WQTY42, WQTY43, WQTY44, WQTY45
                         , WQTY46, WQTY47, WQTY48, WQTY49, WQTY50
                         , WQTY51, WQTY52
                         )
                    SELECT *
                      FROM ( SELECT DIVISION_ID, SITE_ID, OPERATION_ID, PROD_LINE, MEASURE, WQTY, WEEK_COLUMN
                               FROM GT_XPGT_LINELOAD_WEEK ) SOURCETABLE
                           PIVOT
                           (
                            MIN(WQTY)
                            FOR WEEK_COLUMN IN (
                                    'WQTY01' AS WQTY01, 'WQTY02' AS WQTY02, 'WQTY03' AS WQTY03, 'WQTY04' AS WQTY04, 'WQTY05' AS WQTY05
                                  , 'WQTY06' AS WQTY06, 'WQTY07' AS WQTY07, 'WQTY08' AS WQTY08, 'WQTY09' AS WQTY09, 'WQTY10' AS WQTY10
                                  , 'WQTY11' AS WQTY11, 'WQTY12' AS WQTY12, 'WQTY13' AS WQTY13, 'WQTY14' AS WQTY14, 'WQTY15' AS WQTY15
                                  , 'WQTY16' AS WQTY16, 'WQTY17' AS WQTY17, 'WQTY18' AS WQTY18, 'WQTY19' AS WQTY19, 'WQTY20' AS WQTY20
                                  , 'WQTY21' AS WQTY21, 'WQTY22' AS WQTY22, 'WQTY23' AS WQTY23, 'WQTY24' AS WQTY24, 'WQTY25' AS WQTY25
                                  , 'WQTY26' AS WQTY26, 'WQTY27' AS WQTY27, 'WQTY28' AS WQTY28, 'WQTY29' AS WQTY29, 'WQTY30' AS WQTY30
                                  , 'WQTY31' AS WQTY31, 'WQTY32' AS WQTY32, 'WQTY33' AS WQTY33, 'WQTY34' AS WQTY34, 'WQTY35' AS WQTY35
                                  , 'WQTY36' AS WQTY36, 'WQTY37' AS WQTY37, 'WQTY38' AS WQTY38, 'WQTY39' AS WQTY39, 'WQTY40' AS WQTY40
                                  , 'WQTY41' AS WQTY41, 'WQTY42' AS WQTY42, 'WQTY43' AS WQTY43, 'WQTY44' AS WQTY44, 'WQTY45' AS WQTY45
                                  , 'WQTY46' AS WQTY46, 'WQTY47' AS WQTY47, 'WQTY48' AS WQTY48, 'WQTY49' AS WQTY49, 'WQTY50' AS WQTY50
                                  , 'WQTY51' AS WQTY51, 'WQTY52' AS WQTY52
                               )
                           ) X;

                    /*  MSSQL UPDATE X SET WQTY01~52 FROM SCP_XLS_PSI_GLOBAL X INNER JOIN #LineLoad_WEEK_PIVOT Y ON .. WHERE ..
                        -> Oracle 다중컬럼 서브쿼리 UPDATE + EXISTS. ROWNUM = 1 로 MSSQL 의 임의 1행 선택을 재현하고 */
                    UPDATE SCP_XLS_PSI_GLOBAL X
                       SET (
                              X.WQTY01, X.WQTY02, X.WQTY03, X.WQTY04, X.WQTY05, X.WQTY06
                            , X.WQTY07, X.WQTY08, X.WQTY09, X.WQTY10, X.WQTY11, X.WQTY12
                            , X.WQTY13, X.WQTY14, X.WQTY15, X.WQTY16, X.WQTY17, X.WQTY18
                            , X.WQTY19, X.WQTY20, X.WQTY21, X.WQTY22, X.WQTY23, X.WQTY24
                            , X.WQTY25, X.WQTY26, X.WQTY27, X.WQTY28, X.WQTY29, X.WQTY30
                            , X.WQTY31, X.WQTY32, X.WQTY33, X.WQTY34, X.WQTY35, X.WQTY36
                            , X.WQTY37, X.WQTY38, X.WQTY39, X.WQTY40, X.WQTY41, X.WQTY42
                            , X.WQTY43, X.WQTY44, X.WQTY45, X.WQTY46, X.WQTY47, X.WQTY48
                            , X.WQTY49, X.WQTY50, X.WQTY51, X.WQTY52
                           ) = ( SELECT
                                          Y.WQTY01, Y.WQTY02, Y.WQTY03, Y.WQTY04, Y.WQTY05, Y.WQTY06
                                        , Y.WQTY07, Y.WQTY08, Y.WQTY09, Y.WQTY10, Y.WQTY11, Y.WQTY12
                                        , Y.WQTY13, Y.WQTY14, Y.WQTY15, Y.WQTY16, Y.WQTY17, Y.WQTY18
                                        , Y.WQTY19, Y.WQTY20, Y.WQTY21, Y.WQTY22, Y.WQTY23, Y.WQTY24
                                        , Y.WQTY25, Y.WQTY26, Y.WQTY27, Y.WQTY28, Y.WQTY29, Y.WQTY30
                                        , Y.WQTY31, Y.WQTY32, Y.WQTY33, Y.WQTY34, Y.WQTY35, Y.WQTY36
                                        , Y.WQTY37, Y.WQTY38, Y.WQTY39, Y.WQTY40, Y.WQTY41, Y.WQTY42
                                        , Y.WQTY43, Y.WQTY44, Y.WQTY45, Y.WQTY46, Y.WQTY47, Y.WQTY48
                                        , Y.WQTY49, Y.WQTY50, Y.WQTY51, Y.WQTY52
                                   FROM GT_XPGT_LINELOAD_WEEK_PIVOT Y
                                  WHERE Y.PROD_LINE            = X.PROD_LINE
                                    AND X.DIVISION_ID          = Y.DIVISION_ID
                                    AND X.FROM_SITE            = Y.SITE_ID
                                    AND X.ATTRIBUTE9           = Y.OPERATION_ID
                                    AND X.CREATE_FROM_YYYYMMDD = V_BATCH_CREATE_FROM_YYYYMMDD
                                    AND ROWNUM                 = 1 )
                     WHERE X.MEASURE IN ('PACK_PROD_LOAD', 'CELL_PROD_LOAD')
                       AND X.CREATE_FROM_YYYYMMDD = V_BATCH_CREATE_FROM_YYYYMMDD
                       AND X.DIVISION_ID          = V_BATCH_DIVISION_ID   /* 2022.03.23 KSW GM JV 반영 */
                       AND X.XLS_KEY1             = V_BATCH_XLS_KEY1
                       AND EXISTS ( SELECT 1
                                      FROM GT_XPGT_LINELOAD_WEEK_PIVOT Y
                                     WHERE Y.PROD_LINE            = X.PROD_LINE
                                       AND X.DIVISION_ID          = Y.DIVISION_ID
                                       AND X.FROM_SITE            = Y.SITE_ID
                                       AND X.ATTRIBUTE9           = Y.OPERATION_ID
                                       AND X.CREATE_FROM_YYYYMMDD = V_BATCH_CREATE_FROM_YYYYMMDD );
                END IF;
            END IF;
        END IF;

        /* ------------------------------------------------------- */
        /*  실행 Logic END -- */
        /* ------------------------------------------------------- */

        /*  TXN LOG */
        V_LOG_TYPE     := 'TXN';    /* 로그타입 */
        N_LOG_COUNT    := SQL%ROWCOUNT;
        V_LOG_MESSAGE  := 'INSERT INTO ' || V_TABLE_ID;
        /*  MSSQL CONVERT(CHAR(23), @d_event_date, 121) = 'YYYY-MM-DD HH:MI:SS.mmm'. */
        V_DESCRIPTION  := 'Process Complete...' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYY-MM-DD HH24:MI:SS');
        D_EVENT_DATE   := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME  => V_PROGRAM_NAME
                            , P_LOG_TYPE      => V_LOG_TYPE
                            , P_LOG_COUNT     => N_LOG_COUNT
                            , P_LOG_MESSAGE   => V_LOG_MESSAGE
                            , P_DESCRIPTION   => V_DESCRIPTION
                            , P_EVENT_DATE    => D_EVENT_DATE
                            , P_USER_ID       => V_BATCH_USER
                            );

    EXCEPTION
      WHEN OTHERS THEN

        /*  원본 L3298~L3304 반영보류 (KSK) 주석 보존
            declare @v_param_text nvarchar(MAX) , @v_dailyQty as varchar(8000)
            set @v_dailyQty =  CAST(@p_dailyQtY AS varchar(8000))
            EXEC PR_XLS_PARAM_TEXT @v_param_text OUTPUT, @v_program_name, @p_user_id, @p_division_id, ... , @v_dailyQty, @p_is_debug */

        /*  ERROR LOG */
        V_LOG_TYPE     := 'ERROR';
        V_LOG_MESSAGE  := SUBSTR(SQLERRM, 1, 1000);

        V_DESCRIPTION  := SUBSTR('ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 500);
        D_EVENT_DATE   := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME  => V_PROGRAM_NAME
                            , P_LOG_TYPE      => V_LOG_TYPE
                            , P_LOG_COUNT     => N_LOG_COUNT
                            , P_LOG_MESSAGE   => V_LOG_MESSAGE
                            , P_DESCRIPTION   => V_DESCRIPTION
                            , P_EVENT_DATE    => D_EVENT_DATE
                            , P_USER_ID       => V_BATCH_USER
                            );
        /*  원본 L3321~L3323 반영보류 (KSK) 주석 보존
            , @p_division_id, null, null, null, null, null, null, null, null, @v_param_text */

        /*  원본 L3326 : return -1 (CATCH). ★에러 경로다(정상 스킵 아님).
            XLSPSI 계열 반환코드 계약대로 예외를 흡수하고 -1 만 돌려준다(RAISE 금지 - 원본 동작 보존). */
        O_RETURN_CODE := -1;
        RETURN;
    END;

    /*  임시 운영반영시에 주석처리 할것. */


    N_ELAPSED_SEC := ROUND((SYSDATE - V_START_TIME) * 86400);
    V_EXEC_TIME   := LPAD(TO_CHAR(TRUNC(N_ELAPSED_SEC / 60)), 2, '0') || ':' ||
                     LPAD(TO_CHAR(MOD(N_ELAPSED_SEC, 60)), 2, '0');

    /*  종료 LOG */
    V_LOG_TYPE     := 'END';
    V_LOG_MESSAGE  := '########## END of procedure ##########';
    /*  @p_xls_key1 대신에 현재 데이터의 키인 @v_batch_xls_key1를 기록(KSK, 240903) */

    V_DESCRIPTION  := CASE WHEN V_BATCH_DIVISION_ID IS NULL OR V_BATCH_PLAN_START_YYYYMMDD IS NULL
                             OR V_BATCH_MEASURE IS NULL OR V_BATCH_XLS_KEY1 IS NULL OR V_EXEC_TIME IS NULL
                           THEN NULL
                           ELSE '[' || V_BATCH_DIVISION_ID || '][' || V_BATCH_PLAN_START_YYYYMMDD
                                || '][' || V_BATCH_MEASURE || '][' || LPAD(TO_CHAR(V_BATCH_XLS_KEY1), 10)
                                || '][' || V_EXEC_TIME || ']'
                      END;
    D_EVENT_DATE   := SYSDATE;
    PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME  => V_PROGRAM_NAME
                        , P_LOG_TYPE      => V_LOG_TYPE
                        , P_LOG_COUNT     => N_LOG_COUNT
                        , P_LOG_MESSAGE   => V_LOG_MESSAGE
                        , P_DESCRIPTION   => V_DESCRIPTION
                        , P_EVENT_DATE    => D_EVENT_DATE
                        , P_USER_ID       => V_BATCH_USER
                        );

    /*  원본 L3348 : return 1 (정상 종료) */
    O_RETURN_CODE := 1;
    RETURN;

END;