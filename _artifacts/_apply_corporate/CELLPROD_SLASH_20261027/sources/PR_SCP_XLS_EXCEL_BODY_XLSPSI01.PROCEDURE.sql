PROCEDURE PR_SCP_XLS_EXCEL_BODY_XLSPSI01
(
  P_DIVISION_ID    IN  VARCHAR2
, P_PGM_CODE       IN  VARCHAR2
, P_PARAMETER1     IN  VARCHAR2 DEFAULT ''   /* VARCHAR(MAX)  CELL_ITEM_ID, ITEM_ID */
, P_PARAMETER2     IN  VARCHAR2 DEFAULT ''   /* VARCHAR(MAX)  CELL_TYPE_GROUP_CODE */
, P_PARAMETER3     IN  VARCHAR2 DEFAULT ''   /* VARCHAR(MAX)  PLANNER ID (AAAA,BCCC,CDDD,....) Delimeter는 (,) */
, P_PARAMETER4     IN  VARCHAR2 DEFAULT ''   /* VARCHAR(MAX)  @p_day_week_flag(day/week) */
, P_PARAMETER5     IN  VARCHAR2 DEFAULT ''
, O_RESULT_CURSOR  OUT SYS_REFCURSOR
)
/*
 * Program ID   : PR_SCP_XLS_EXCEL_BODY_XLSPSI01
 * Description  : SCP SIMULATION EXCEL SHEET BODY QUERY
 * OutTable     :
 * Execute      :

  EXEC PR_SCP_XLS_EXCEL_BODY_XLSPSI01 @p_division_id   = 'EE'
                                                  ,@p_pgm_code      = 'XLSPSI05'
                                                  ,@p_parameter1    = ''--ACPN1034U-A1'  -- PLAN_START_YYYYMMDD
                                                  ,@p_parameter2    =''
                                                  ,@p_parameter3    =''
                                                  ,@p_parameter4    ='day'
                                                  ,@p_parameter5    =''

 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.01.07   YYDOK         Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *              KSG           과거 이력 정리
 * 2022.02.21   KSW           DC link 적용
 * 2022.02.22   KSW           소형 Shipment plan 시뮬레이터 조회기능개선
 * 2022.04.07   KSW           소형 Shipment plan 시뮬레이터 조회기능개선2
 * 2022.05.02   KSW           Daily & Monthly Bucket 개선적용
 * 2022.05.13   KSW           GM JV 반영
 * 2022.05.23   KSW           ESS Pack 시뮬레이터 가동율시트 - Cell Total measure 추가
 * 2022.06.22   KSW           소형 Shipment plan 시뮬레이터 From Site 컬럼추가
 * 2022.07.18   KSW           PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 :: ISUZU 적용
 * 2022.08.11   KSW           중장기 +1 Year 변경처리
 * 2022.08.30   KSW           자동차 Cell 재고 개선건
 * 2022.09.21   KSW           소형SCM개선요청사항 적용
 * 2022.09.30   KSW           자동차 Load Ratio 조회안되게 변경
 * 2022.12.22   KSW           XLSPSI21 소형 출하 시뮬레이터 - DEPT_NAME_EN 식별문제로 DEPT_ID 를 붙여서 식별하는 것으로 변경 :: 2022.12.22
 * 2023.02.09   KKH           XLSPSI01 pack cell 순서로 다시 정렬
 * 2023.03.09   KKH          소형 ISUZU 모델 제외 ( Flow Id  ‘P5500’ 또는 ‘P9500’ 인 Item 만 제외)
 * 2023.07.10   DHJ           소형 출하시뮬레이터 INVENTORY, PROD_PLAN_ENGINE에 값을 가져올떄 CA모델 수량 합산 AS-IS : ONLY CP QTY, TO-BE : CP + CA QTY
 * 2023.07.25   DHJ         FIXED FOR BUG --* 2023.07.10   1298
 * 2023.08.04   KSK         PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase.2 (사업계획 수립에 따른 시뮬레이터 생산계획Bucket 확장 적용)
 * 2023.10.06   KHJ         확정구간의 기준을 LOOKUP 테이블을 우선참조하도록 함
 * 2023.10.12   KHJ         ESS-PACK(XLSPSI06). SHIP_REQ가 없는 것에 대해서 조회되지 않도록 기능개선.
 * 2023.12.01   KHJ         소형출하계획 (XLSPSI21). FROM_SITE별 출하계획 조회/할당/저장
 * 2023.12.15   OIJ         QUERY 정리(HAVING 삭제, JOIN 수정, IN구문 JOIN구문으로 일부변경)
 * 2023.12.29   KHJ         공용 Cell의 경우 BOH 로직 개선
 * 2024.03.22   KSK         ESS PROD LOAD조회 관련  SCP_XLS_PSI_GLOBAL_ESS_LOAD_RATIO_PACK_V와 SCP_XLS_PSI_GLOBAL_ESS_LOAD_RATIO_PACK_BP_V를
                                    FN_XLS_PSI_GLOBAL_ESS_LOAD_RATIO_PACK으로 통합처리
 * 2024.08.22   KSK         DAILY PSI 실시간 생산계획 일분배관련 참조필드인 ATTRBUTE9 필드 추가조회
 * 2024.09.25   KSK         팩셀관련메저의 정렬순서 보정(PACK/PACK-CELL/기타순서의 가중치 변경 10000,10010,10020=> 1, 10000, 10000000)
 * 2024.11.28   KSK         플래너가 사용하지 않는 7개(MKT_FCST_CELL_TOTAL등) 메저 제외함
 * 2026-08-03   ZIONEX      [PJ202650304]  NextSCM Migration
 */
IS

    P_PLAN_START_YYYYMMDD        VARCHAR2(0008 CHAR) := NULL;
    P_PLAN_TYPE                  VARCHAR2(4000 CHAR) := 'MA';
    P_SEQ                        VARCHAR2(0008 CHAR) := NULL;
    V_PLAN_ID                    VARCHAR2(0008 CHAR) := NULL;
    ENG_PLAN_ID                  VARCHAR2(0015 CHAR) := NULL;

    V_PLAN_START_YYYYMMDD        VARCHAR2(0008 CHAR);
    V_PLAN_END_YYYYMMDD          VARCHAR2(0008 CHAR);
    V_PLAN_END_YYYYMMDD_2        VARCHAR2(0008 CHAR);

    V_SEQ                        VARCHAR2(0008 CHAR);
    V_COLS                       VARCHAR2(4000 CHAR);
    V_COLS2                      VARCHAR2(4000 CHAR);
    V_COLS3                      VARCHAR2(4000 CHAR);
    V_SQL                        VARCHAR2(4000 CHAR);

    V_FROZEN_END_YYYYMMDD        VARCHAR2(0008 CHAR);
    V_FROZEN_DAYS                NUMBER(10) := 21;
    V_WCOLS                      VARCHAR2(4000 CHAR);
    V_WCOLS2                     VARCHAR2(4000 CHAR);
    V_WCOLS3                     VARCHAR2(4000 CHAR);

    V_FROZEN_AREA_LAST_YYYYMMDD  VARCHAR2(0008 CHAR) := '';
    /*  * 2021.03.23   KSW           'PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선' - XLSPSI22: ESS SHIPMENT PLAN 입력 SIMULATION 추가 - END */

    /* PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선' - 중장기 대응 - start */
    P_CREATE_TO_YYYYMMDD_1       VARCHAR2(0008 CHAR);
    P_CREATE_TO_YYYYMMDD_2       VARCHAR2(0008 CHAR);

    /*  Plan End Date */
    V_PET_DATE                   VARCHAR2(12 CHAR) := '';
    V_BP_FLAG                    VARCHAR2(8 CHAR) := '';
    V_BP_DAYS                    NUMBER(10) := 0;
    V_BP_PLAN_END_YYYYMMDD       VARCHAR2(0008 CHAR) := '';


    V_2YEAR_CNT                  NUMBER(10) := 0;

    /* 원본은 IN 파라미터 @p_parameter3 에 재대입(SET @p_parameter3 = @p_parameter1) 한다. */
    V_PARAMETER3                 VARCHAR2(32767 CHAR) := P_PARAMETER3;

BEGIN

    /* 원본 대입형 SELECT(집계 없음 = 다행 가능) -> SELECT INTO 대신 커서 FOR 루프. */
    FOR R IN (SELECT P.HORIZON_END_DATE
                   , (CASE WHEN (TO_DATE(P.HORIZON_END_DATE, 'YYYYMMDD') - TO_DATE(P.PLAN_NAME, 'YYYYMMDD')) > 364 THEN 'Y'
                          ELSE 'N'
                      END) AS BP_FLAG
                   , (CASE WHEN (TO_DATE(P.HORIZON_END_DATE, 'YYYYMMDD') - TO_DATE(P.PLAN_NAME, 'YYYYMMDD')) > 364 THEN (TO_DATE(P.HORIZON_END_DATE, 'YYYYMMDD') - TO_DATE(P.PLAN_NAME, 'YYYYMMDD')) - 363
                          ELSE 0
                      END) AS BP_DAYS
                FROM SCM_MST_PLAN P
               WHERE P.DIVISION_ID = P_DIVISION_ID
                 AND P.PLAN_ID     = (SELECT MAX(PLAN_ID)
                                       FROM SCM_MST_PLAN P
                                      WHERE DIVISION_ID = P_DIVISION_ID
                                        AND PLAN_ID < 9999))
    LOOP
        V_PET_DATE := R.HORIZON_END_DATE;
        V_BP_FLAG  := R.BP_FLAG;
        V_BP_DAYS  := R.BP_DAYS;
    END LOOP;
    /* PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선' - 중장기 대응 - end */

  /* --------------------------------------------------- */
  /* XLSPSI01: 자동차 GLOBAL PSI SIMULATION */
  /* --------------------------------------------------- */
     BEGIN

     /* PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선' - 중장기 대응 - start */
     V_PLAN_START_YYYYMMDD := '';

     /* 원본 SELECT DISTINCT 대입형(집계 없음, PK 가 DIVISION_ID+CREATE_FROM_YYYYMMDD+XLS_KEY1 이라 다행 가능) -> 커서 FOR 루프 */
     FOR R IN (SELECT DISTINCT
                      PLAN_START_YYYYMMDD
                    , SEQ
                 FROM SCP_XLS_PSI_GLOBAL
                WHERE DIVISION_ID = P_DIVISION_ID)      /* 2022.03.21   KSW   GM JV 반영 */
     LOOP
         V_PLAN_START_YYYYMMDD := R.PLAN_START_YYYYMMDD;
         V_SEQ                 := R.SEQ;
     END LOOP;


     P_CREATE_TO_YYYYMMDD_1 := V_PLAN_START_YYYYMMDD;
     P_CREATE_TO_YYYYMMDD_2 := TO_CHAR(TO_DATE(P_CREATE_TO_YYYYMMDD_1, 'YYYYMMDD') + 364, 'YYYYMMDD');
     /* PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선' - 중장기 대응 - end */

      IF P_PARAMETER1 IS NOT NULL THEN                  /* 원본 IF @p_parameter1 <> '' (CV-028) */
        V_PARAMETER3 := P_PARAMETER1;
      END IF;

      /* 중장기 data 존재여부 (단기 --> 중장기로 전환시 조회안되는 문제방지 :: 2022.08.22 - start */
      SELECT COUNT(*)
        INTO V_2YEAR_CNT
        FROM SCP_XLS_PSI_GLOBAL Y
       WHERE CREATE_FROM_YYYYMMDD = P_CREATE_TO_YYYYMMDD_2;

      IF  V_2YEAR_CNT = 0 THEN
         V_BP_FLAG := 'N';
      END IF;
      /* 중장기 data 존재여부 (단기 --> 중장기로 전환시 조회안되는 문제방지 :: 2022.08.22 - end */

      /* PRINT '@v_bp_flag : ' +  @v_bp_flag ;--TEST */

      IF V_BP_FLAG = 'N' THEN
          OPEN O_RESULT_CURSOR FOR
          SELECT Y.DIVISION_ID
               , PLAN_START_YYYYMMDD
               , PLAN_TYPE
               , SEQ
               , Y.OPERATION_GROUP
               , OPERATION_GROUP_NAME
               , Y.CELL_ITEM_ID
               , Y.ITEM_ID
               , Y.NICK_NAME
               , CELL_QTY_PACK
               , TO_SITE
               , TO_SITE_DESCRIPTION
               , PROJECT_CODE
               , FROM_BOH_QTY
               , TO_BOH_QTY
               , INCOTERMS
               , FROM_SITE
               , FROM_SITE_DESCRIPTION
               , TRANSPORT_MODE
               , LT_DAY
               , YIELD
               , PROD_LINE
               , BOD_ID
               , GRO_STD_DIO
               , MIN_STD_DIO
               , MEASURE
               , MEASURE_LABEL
               , XLS_KEY1
               , XLS_KEY2
               , SORT_KEY AS XLS_KEY3
               , XLS_KEY4
               , XLS_KEY5
               , XLS_ATTRIBUTE1
               , XLS_ATTRIBUTE2
               , XLS_ATTRIBUTE3
               , XLS_ATTRIBUTE4
               , XLS_ATTRIBUTE5
               , SORT_ORDER_NO
               , WQTY01
               , WQTY02
               , WQTY03
               , WQTY04
               , WQTY05
               , WQTY06
               , WQTY07
               , WQTY08
               , WQTY09
               , WQTY10
               , WQTY11
               , WQTY12
               , WQTY13
               , WQTY14
               , WQTY15
               , WQTY16
               , WQTY17
               , WQTY18
               , WQTY19
               , WQTY20
               , WQTY21
               , WQTY22
               , WQTY23
               , WQTY24
               , WQTY25
               , WQTY26
               , WQTY27
               , WQTY28
               , WQTY29
               , WQTY30
               , WQTY31
               , WQTY32
               , WQTY33
               , WQTY34
               , WQTY35
               , WQTY36
               , WQTY37
               , WQTY38
               , WQTY39
               , WQTY40
               , WQTY41
               , WQTY42
               , WQTY43
               , WQTY44
               , WQTY45
               , WQTY46
               , WQTY47
               , WQTY48
               , WQTY49
               , WQTY50
               , WQTY51
               , WQTY52
               , Y.CREATED_BY
               , Y.CREATION_DATE
               , Y.LAST_UPDATED_BY
               , Y.LAST_UPDATE_DATE
               , Y.ATTRIBUTE1

               /* (dev MSSQL 실측 SCP_XLS_PSI_GLOBAL 11516행 중 ATTRIBUTE3 NULL 11274행) */
               , (CASE WHEN Y.ATTRIBUTE3 IS NULL THEN NULL
                      ELSE '''' || Y.ATTRIBUTE3
                  END) AS ATTRIBUTE3   /* ATTRIBUTE10  -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 */
               , Y.ATTRIBUTE9
            FROM (SELECT DIVISION_ID
                       , PLAN_START_YYYYMMDD
                       , PLAN_TYPE
                       , SEQ
                       , OPERATION_GROUP
                       , OPERATION_GROUP_NAME
                       , CELL_ITEM_ID
                       , ITEM_ID
                       , NICK_NAME
                       , CELL_QTY_PACK
                       , TO_SITE
                       , TO_SITE_DESCRIPTION
                       , PROJECT_CODE
                       , FROM_BOH_QTY
                       , TO_BOH_QTY
                       , INCOTERMS
                       , FROM_SITE
                       , FROM_SITE_DESCRIPTION
                       , TRANSPORT_MODE
                       /* PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - 전진검사 LT 추가 */
                       /* 변경전 */
                       /* ,(CASE WHEN   (TRANSPORT_MODE ='-')  AND (MEASURE <> 'CELL_PROD') THEN '-' ELSE CONVERT(NVARCHAR,LT_DAY) END ) AS LT_DAY */
                       , (CASE WHEN (TRANSPORT_MODE = '-') AND (MEASURE <> 'CELL_PROD') THEN (CASE WHEN MEASURE = 'PACK_BOH' THEN TO_CHAR(LT_DAY)
                                                                                                   ELSE '-'
                                                                                              END)
                              ELSE TO_CHAR(LT_DAY)
                          END) AS LT_DAY
                       , YIELD
                       , PROD_LINE
                       , BOD_ID
                       , ATTRIBUTE4 AS GRO_STD_DIO  /* DIO 수정 관련 (기준 컬럼추가) */
                       , ATTRIBUTE5 AS MIN_STD_DIO  /* DIO 수정 관련 (최소 컬럼추가) */
                       , MEASURE
                       , MEASURE_LABEL
                       , XLS_KEY1
                       , XLS_KEY2
                       , XLS_KEY3
                       , XLS_KEY4
                       , XLS_KEY5
                       , XLS_ATTRIBUTE1
                       , XLS_ATTRIBUTE2
                       , XLS_ATTRIBUTE3
                       , XLS_ATTRIBUTE4
                       , XLS_ATTRIBUTE5
                       , SORT_ORDER_NO
                       , WQTY01
                       , WQTY02
                       , WQTY03
                       , WQTY04
                       , WQTY05
                       , WQTY06
                       , WQTY07
                       , WQTY08
                       , WQTY09
                       , WQTY10
                       , WQTY11
                       , WQTY12
                       , WQTY13
                       , WQTY14
                       , WQTY15
                       , WQTY16
                       , WQTY17
                       , WQTY18
                       , WQTY19
                       , WQTY20
                       , WQTY21
                       , WQTY22
                       , WQTY23
                       , WQTY24
                       , WQTY25
                       , WQTY26
                       , WQTY27
                       , WQTY28
                       , WQTY29
                       , WQTY30
                       , WQTY31
                       , WQTY32
                       , WQTY33
                       , WQTY34
                       , WQTY35
                       , WQTY36
                       , WQTY37
                       , WQTY38
                       , WQTY39
                       , WQTY40
                       , WQTY41
                       , WQTY42
                       , WQTY43
                       , WQTY44
                       , WQTY45
                       , WQTY46
                       , WQTY47
                       , WQTY48
                       , WQTY49
                       , WQTY50
                       , WQTY51
                       , WQTY52
                       , CREATED_BY
                       , CREATION_DATE
                       , LAST_UPDATED_BY
                       , LAST_UPDATE_DATE
                       , ATTRIBUTE1
                       , ATTRIBUTE3   /* PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 */
                       , ATTRIBUTE9
                       , ATTRIBUTE10
                       /* 정렬 가중치 조정(10000, 10010, 100020=> 1, 10000, 10000000, 240925) */
                       , (CASE WHEN Y.MEASURE IN ('PACK_CELL_BOH', 'PACK_CELL_EOH', 'PACK_CELL_BOH_HOLD') THEN (SELECT CAST(MAX(X.XLS_KEY1) AS NUMBER(19)) * 10000 - (CASE WHEN Y.MEASURE = 'PACK_CELL_BOH' THEN 15
                                                                                                                                                        WHEN Y.MEASURE = 'PACK_CELL_BOH_HOLD' THEN 10
                                                                                                                                                        ELSE 0
                                                                                                                                                   END)   /* 2022.08.30   KSW  Cell 재고 개선건 - PACK_CELL_BOH_HOLD 추가 */
                                                                                                            FROM SCP_XLS_PSI_GLOBAL X
                                                                                                           WHERE X.DIVISION_ID = Y.DIVISION_ID   /* 2022.03.21 GM JV 반영  '81' --> @p_division_id */
                                                                                                             AND X.PLAN_START_YYYYMMDD = Y.PLAN_START_YYYYMMDD
                                                                                                             AND X.CELL_ITEM_ID    = Y.CELL_ITEM_ID
                                                                                                             AND X.FROM_SITE       = Y.FROM_SITE
                                                                                                             AND X.OPERATION_GROUP = 'P'
                                                                                                             AND X.MEASURE         = 'PACK_CELL_EOH'
                                                                                                             AND X.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                                                                                             AND X.DIVISION_ID = P_DIVISION_ID)
                              ELSE (CASE WHEN Y.OPERATION_GROUP = 'P' THEN CAST(XLS_KEY1 AS NUMBER(10)) * 1
                                         ELSE CAST(XLS_KEY1 AS NUMBER(19)) * 1000000
                                    END)
                          END) AS SORT_KEY
                    FROM SCP_XLS_PSI_GLOBAL Y
                       , (SELECT VALUE
                           FROM TABLE(FN_SPLITSTRING(V_PARAMETER3, ','))) X
                   WHERE 0 = 0
                     AND Y.CELL_ITEM_ID = X.VALUE   /* ANSI INNER JOIN ~ ON 을 콤마 조인 + WHERE 로 전환(FM-015) */
                     AND DIVISION_ID   = P_DIVISION_ID
                     AND CREATE_FROM_YYYYMMDD = P_CREATE_TO_YYYYMMDD_1
                         /* AND CELL_ITEM_ID IN (SELECT Value FROM dbo.FN_SplitString(@p_parameter3,','))    INNER JOIN으로 변경 - 20231221 */
                     AND MEASURE NOT IN ('PACK_PROD_LOAD', 'CELL_PROD_LOAD', 'PACK_PROD_TOTAL')   /* Load Ratio 조회안되게 변경 - 2022.09.30 */
                     AND NOT (OPERATION_GROUP = 'A' AND TO_SITE = '-'   /* AND FROM_SITE = 'A040-A' */
                              AND NVL((SELECT FN_GET_FINAL_ITEM('81', ITEM_ID, 'CELL_TYPE') FROM DUAL), ' ') = 'CP'
                             )   /* ... 1298 06/22/2023 */
                         /*
                           Operation Cell
                           Item ID : Prod
                           To site : Null
                           From Site : LGESOC Cell A0... (Company C100)
                           인 Row를 삭제한다
                         */
                         /* AND NOT (MEASURE = 'SHIP_PLAN' AND PROJECT_CODE = '-' )  프로젝트 코드가 없는 행은 제외(KSK,250408) */
                 ) Y
               /* 2023.02.09   KKH   XLSPSI01 pack cell 순서로 다시 정렬 */
               , SCP_MST_FINAL_ITEM B
           WHERE Y.ITEM_ID     = B.ITEM_ID(+)
             AND Y.DIVISION_ID = B.DIVISION_ID(+)
             AND Y.MEASURE NOT IN ('MKT_FCST_CELL_TOTAL', 'MKT_FCST_TOTAL', 'ALLOCATION_TOTAL', 'EOH_TOTAL'
                                      , 'MKT_FCST_DIO', 'ALLOCATION_DIO', 'ALLOCATION_GAP_STD_DIO', 'ALLOCATION_GAP_MIN_DIO')
               /* WHERE  Y.CELL_ITEM_ID IN (SELECT Value FROM dbo.FN_SplitString(@p_parameter3,','))   필요없는 구문으로 삭제 - 20231221 */
           ORDER BY CELL_ITEM_ID, SORT_KEY, B.OPERATION_GROUP DESC;
               /* ORDER BY  CELL_ITEM_ID,  SORT_KEY */
      END IF;

      IF V_BP_FLAG = 'Y' THEN    /* AUTO */
          OPEN O_RESULT_CURSOR FOR
          SELECT DIVISION_ID
               , PLAN_START_YYYYMMDD
               , PLAN_TYPE
               , SEQ
               , OPERATION_GROUP
               , OPERATION_GROUP_NAME
               , CELL_ITEM_ID
               , ITEM_ID
               , NICK_NAME
               , CELL_QTY_PACK
               , TO_SITE
               , TO_SITE_DESCRIPTION
               , PROJECT_CODE
               , FROM_BOH_QTY
               , TO_BOH_QTY
               , INCOTERMS
               , FROM_SITE
               , FROM_SITE_DESCRIPTION
               , TRANSPORT_MODE
               , LT_DAY
               , YIELD
               , PROD_LINE
               , BOD_ID
               , GRO_STD_DIO
               , MIN_STD_DIO
               , MEASURE
               , MEASURE_LABEL
               , XLS_KEY1
               , XLS_KEY2
               , SORT_KEY AS XLS_KEY3
               , XLS_KEY4
               , XLS_KEY5
               , XLS_ATTRIBUTE1
               , XLS_ATTRIBUTE2
               , XLS_ATTRIBUTE3
               , XLS_ATTRIBUTE4
               , XLS_ATTRIBUTE5
               , SORT_ORDER_NO
               , WQTY01
               , WQTY02
               , WQTY03
               , WQTY04
               , WQTY05
               , WQTY06
               , WQTY07
               , WQTY08
               , WQTY09
               , WQTY10
               , WQTY11
               , WQTY12
               , WQTY13
               , WQTY14
               , WQTY15
               , WQTY16
               , WQTY17
               , WQTY18
               , WQTY19
               , WQTY20
               , WQTY21
               , WQTY22
               , WQTY23
               , WQTY24
               , WQTY25
               , WQTY26
               , WQTY27
               , WQTY28
               , WQTY29
               , WQTY30
               , WQTY31
               , WQTY32
               , WQTY33
               , WQTY34
               , WQTY35
               , WQTY36
               , WQTY37
               , WQTY38
               , WQTY39
               , WQTY40
               , WQTY41
               , WQTY42
               , WQTY43
               , WQTY44
               , WQTY45
               , WQTY46
               , WQTY47
               , WQTY48
               , WQTY49
               , WQTY50
               , WQTY51
               , WQTY52
               , WQTY53
               , WQTY54
               , WQTY55
               , WQTY56
               , WQTY57
               , WQTY58
               , WQTY59
               , WQTY60
               , WQTY61
               , WQTY62
               , WQTY63
               , WQTY64
               , WQTY65
               , WQTY66
               , WQTY67
               , WQTY68
               , WQTY69
               , WQTY70
               , WQTY71
               , WQTY72
               , WQTY73
               , WQTY74
               , WQTY75
               , WQTY76
               , WQTY77
               , WQTY78
               , WQTY79
               , WQTY80
               , WQTY81
               , WQTY82
               , WQTY83
               , WQTY84
               , WQTY85
               , WQTY86
               , WQTY87
               , WQTY88
               , WQTY89
               , WQTY90
               , WQTY91
               , WQTY92   /* 중장기 +1 Year 변경처리 :: 2022.08.11 컬럼활성화 */
               , WQTY93
               , WQTY94
               , WQTY95
               , WQTY96
               , WQTY97
               , WQTY98
               , WQTY99
               , WQTY100
               , WQTY101
               , WQTY102
               , WQTY103
               , WQTY104
               , CREATED_BY
               , CREATION_DATE
               , LAST_UPDATED_BY
               , LAST_UPDATE_DATE
               , ATTRIBUTE1

               , (CASE WHEN ATTRIBUTE3 IS NULL THEN NULL
                      ELSE '''' || ATTRIBUTE3
                  END) AS ATTRIBUTE3   /* ATTRIBUTE10  -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 */
               , ATTRIBUTE9
            FROM (SELECT Y1.DIVISION_ID
                       , Y1.PLAN_START_YYYYMMDD
                       , Y1.PLAN_TYPE
                       , Y1.SEQ
                       , Y1.OPERATION_GROUP
                       , Y1.OPERATION_GROUP_NAME
                       , Y1.CELL_ITEM_ID
                       , Y1.ITEM_ID
                       , Y1.NICK_NAME
                       , Y1.CELL_QTY_PACK
                       , Y1.TO_SITE
                       , Y1.TO_SITE_DESCRIPTION
                       , Y1.PROJECT_CODE
                       , (CASE WHEN Y1.MEASURE = 'CELL_FORM_HOLD_AFTER' THEN Y1.FROM_BOH_QTY - Y2.FROM_BOH_QTY
                              ELSE Y1.FROM_BOH_QTY
                          END) AS FROM_BOH_QTY   /* KSE 2021.08.27 CELL_FORM_HOLD_AFTER MEASURE 일 경우 52주 이후 30주 SUM 값을 차감 */
                       , Y1.TO_BOH_QTY
                       , Y1.INCOTERMS
                       , Y1.FROM_SITE
                       , Y1.FROM_SITE_DESCRIPTION
                       , Y1.TRANSPORT_MODE
                       , Y1.LT_DAY
                       , Y1.YIELD
                       , Y1.PROD_LINE
                       , Y1.BOD_ID
                       , Y1.GRO_STD_DIO
                       , Y1.MIN_STD_DIO
                       , Y1.MEASURE
                       , Y1.MEASURE_LABEL
                       , Y1.XLS_KEY1
                       , Y2.XLS_KEY1 AS XLS_KEY2
                       , Y1.XLS_KEY3
                       , Y1.XLS_KEY4
                       , Y1.XLS_KEY5
                       , Y1.XLS_ATTRIBUTE1
                       , Y1.XLS_ATTRIBUTE2
                       , Y1.XLS_ATTRIBUTE3
                       , Y1.XLS_ATTRIBUTE4
                       , Y1.XLS_ATTRIBUTE5
                       , Y1.SORT_ORDER_NO
                       , Y1.WQTY01
                       , Y1.WQTY02
                       , Y1.WQTY03
                       , Y1.WQTY04
                       , Y1.WQTY05
                       , Y1.WQTY06
                       , Y1.WQTY07
                       , Y1.WQTY08
                       , Y1.WQTY09
                       , Y1.WQTY10
                       , Y1.WQTY11
                       , Y1.WQTY12
                       , Y1.WQTY13
                       , Y1.WQTY14
                       , Y1.WQTY15
                       , Y1.WQTY16
                       , Y1.WQTY17
                       , Y1.WQTY18
                       , Y1.WQTY19
                       , Y1.WQTY20
                       , Y1.WQTY21
                       , Y1.WQTY22
                       , Y1.WQTY23
                       , Y1.WQTY24
                       , Y1.WQTY25
                       , Y1.WQTY26
                       , Y1.WQTY27
                       , Y1.WQTY28
                       , Y1.WQTY29
                       , Y1.WQTY30
                       , Y1.WQTY31
                       , Y1.WQTY32
                       , Y1.WQTY33
                       , Y1.WQTY34
                       , Y1.WQTY35
                       , Y1.WQTY36
                       , Y1.WQTY37
                       , Y1.WQTY38
                       , Y1.WQTY39
                       , Y1.WQTY40
                       , Y1.WQTY41
                       , Y1.WQTY42
                       , Y1.WQTY43
                       , Y1.WQTY44
                       , Y1.WQTY45
                       , Y1.WQTY46
                       , Y1.WQTY47
                       , Y1.WQTY48
                       , Y1.WQTY49
                       , Y1.WQTY50
                       , Y1.WQTY51
                       , Y1.WQTY52
                       , Y2.WQTY01 AS WQTY53
                       , Y2.WQTY02 AS WQTY54
                       , Y2.WQTY03 AS WQTY55
                       , Y2.WQTY04 AS WQTY56
                       , Y2.WQTY05 AS WQTY57
                       , Y2.WQTY06 AS WQTY58
                       , Y2.WQTY07 AS WQTY59
                       , Y2.WQTY08 AS WQTY60
                       , Y2.WQTY09 AS WQTY61
                       , Y2.WQTY10 AS WQTY62
                       , Y2.WQTY11 AS WQTY63
                       , Y2.WQTY12 AS WQTY64
                       , Y2.WQTY13 AS WQTY65
                       , Y2.WQTY14 AS WQTY66
                       , Y2.WQTY15 AS WQTY67
                       , Y2.WQTY16 AS WQTY68
                       , Y2.WQTY17 AS WQTY69
                       , Y2.WQTY18 AS WQTY70
                       , Y2.WQTY19 AS WQTY71
                       , Y2.WQTY20 AS WQTY72
                       , Y2.WQTY21 AS WQTY73
                       , Y2.WQTY22 AS WQTY74
                       , Y2.WQTY23 AS WQTY75
                       , Y2.WQTY24 AS WQTY76
                       , Y2.WQTY25 AS WQTY77
                       , Y2.WQTY26 AS WQTY78
                       , Y2.WQTY27 AS WQTY79
                       , Y2.WQTY28 AS WQTY80
                       , Y2.WQTY29 AS WQTY81
                       , Y2.WQTY30 AS WQTY82
                       , Y2.WQTY31 AS WQTY83
                       , Y2.WQTY32 AS WQTY84
                       , Y2.WQTY33 AS WQTY85
                       , Y2.WQTY34 AS WQTY86
                       , Y2.WQTY35 AS WQTY87
                       , Y2.WQTY36 AS WQTY88
                       , Y2.WQTY37 AS WQTY89
                       , Y2.WQTY38 AS WQTY90
                       , Y2.WQTY39 AS WQTY91
                       , Y2.WQTY40 AS WQTY92
                       , Y2.WQTY41 AS WQTY93
                       , Y2.WQTY42 AS WQTY94
                       , Y2.WQTY43 AS WQTY95
                       , Y2.WQTY44 AS WQTY96
                       , Y2.WQTY45 AS WQTY97
                       , Y2.WQTY46 AS WQTY98
                       , Y2.WQTY47 AS WQTY99
                       , Y2.WQTY48 AS WQTY100
                       , Y2.WQTY49 AS WQTY101
                       , Y2.WQTY50 AS WQTY102
                       , Y2.WQTY51 AS WQTY103
                       , Y2.WQTY52 AS WQTY104
                       , Y1.CREATED_BY
                       , Y1.CREATION_DATE
                       , Y1.LAST_UPDATED_BY
                       , Y1.LAST_UPDATE_DATE
                       , Y1.ATTRIBUTE1
                       , Y1.ATTRIBUTE3   /* PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 */
                       , Y1.ATTRIBUTE9
                       , Y1.ATTRIBUTE10
                       , Y1.SORT_KEY
                       , Y2.SORT_ORDER_NO AS SORT_ORDER_NO_2
                       , Y2.XLS_KEY1 AS XLS_KEY1_2
                    FROM (SELECT DIVISION_ID
                               , PLAN_START_YYYYMMDD
                               , PLAN_TYPE
                               , SEQ
                               , OPERATION_GROUP
                               , OPERATION_GROUP_NAME
                               , NVL(CELL_ITEM_ID, '-') AS CELL_ITEM_ID
                               , NVL(ITEM_ID, '-') AS ITEM_ID
                               , NICK_NAME
                               , CELL_QTY_PACK
                               , TO_SITE
                               , TO_SITE_DESCRIPTION
                               , PROJECT_CODE
                               , FROM_BOH_QTY
                               , TO_BOH_QTY
                               , INCOTERMS
                               , FROM_SITE
                               , FROM_SITE_DESCRIPTION
                               , TRANSPORT_MODE
                               /* PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - 전진검사 LT 추가 */
                               /* 변경전 */
                               /* ,(CASE WHEN   (TRANSPORT_MODE ='-')  AND (MEASURE <> 'CELL_PROD') THEN '-' ELSE CONVERT(NVARCHAR,LT_DAY) END ) AS LT_DAY */
                               , (CASE WHEN (TRANSPORT_MODE = '-') AND (MEASURE <> 'CELL_PROD') THEN (CASE WHEN MEASURE = 'PACK_BOH' THEN TO_CHAR(LT_DAY)
                                                                                                           ELSE '-'
                                                                                                      END)
                                      ELSE TO_CHAR(LT_DAY)
                                  END) AS LT_DAY
                               , YIELD
                               , PROD_LINE
                               , BOD_ID
                               , ATTRIBUTE4 AS GRO_STD_DIO  /* DIO 수정 관련 (기준 컬럼추가) */
                               , ATTRIBUTE5 AS MIN_STD_DIO  /* DIO 수정 관련 (최소 컬럼추가) */
                               , MEASURE
                               , MEASURE_LABEL
                               , XLS_KEY1
                               , XLS_KEY2
                               , XLS_KEY3
                               , XLS_KEY4
                               , XLS_KEY5
                               , XLS_ATTRIBUTE1
                               , XLS_ATTRIBUTE2
                               , XLS_ATTRIBUTE3
                               , XLS_ATTRIBUTE4
                               , XLS_ATTRIBUTE5
                               , SORT_ORDER_NO
                               , WQTY01
                               , WQTY02
                               , WQTY03
                               , WQTY04
                               , WQTY05
                               , WQTY06
                               , WQTY07
                               , WQTY08
                               , WQTY09
                               , WQTY10
                               , WQTY11
                               , WQTY12
                               , WQTY13
                               , WQTY14
                               , WQTY15
                               , WQTY16
                               , WQTY17
                               , WQTY18
                               , WQTY19
                               , WQTY20
                               , WQTY21
                               , WQTY22
                               , WQTY23
                               , WQTY24
                               , WQTY25
                               , WQTY26
                               , WQTY27
                               , WQTY28
                               , WQTY29
                               , WQTY30
                               , WQTY31
                               , WQTY32
                               , WQTY33
                               , WQTY34
                               , WQTY35
                               , WQTY36
                               , WQTY37
                               , WQTY38
                               , WQTY39
                               , WQTY40
                               , WQTY41
                               , WQTY42
                               , WQTY43
                               , WQTY44
                               , WQTY45
                               , WQTY46
                               , WQTY47
                               , WQTY48
                               , WQTY49
                               , WQTY50
                               , WQTY51
                               , WQTY52
                               , CREATED_BY
                               , CREATION_DATE
                               , LAST_UPDATED_BY
                               , LAST_UPDATE_DATE
                               , ATTRIBUTE1
                               , ATTRIBUTE3   /* PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 */
                               , ATTRIBUTE9
                               , ATTRIBUTE10
                               /* 정렬 가중치 조정(10000, 10010, 100020=> 1, 10000, 10000000, 240925) */
                               , (CASE WHEN Y.MEASURE IN ('PACK_CELL_BOH', 'PACK_CELL_EOH', 'PACK_CELL_BOH_HOLD') THEN (SELECT CAST(MAX(X.XLS_KEY1) AS NUMBER(19)) * 10000 - (CASE WHEN Y.MEASURE = 'PACK_CELL_BOH' THEN 15
                                                                                                                                                                WHEN Y.MEASURE = 'PACK_CELL_BOH_HOLD' THEN 10
                                                                                                                                                                ELSE 0
                                                                                                                                                           END)   /* 2022.08.30   KSW  Cell 재고 개선건 - PACK_CELL_BOH_HOLD 추가 */
                                                                                                                    FROM SCP_XLS_PSI_GLOBAL X
                                                                                                                   WHERE X.DIVISION_ID = Y.DIVISION_ID   /* 2022.03.21 GM JV 반영  '81' --> @p_division_id */
                                                                                                                     AND X.PLAN_START_YYYYMMDD = Y.PLAN_START_YYYYMMDD
                                                                                                                     AND X.CELL_ITEM_ID    = Y.CELL_ITEM_ID
                                                                                                                     AND X.FROM_SITE       = Y.FROM_SITE
                                                                                                                     AND X.OPERATION_GROUP = 'P'
                                                                                                                     AND X.MEASURE         = 'PACK_CELL_EOH'
                                                                                                                     AND X.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                                                                                                     AND X.DIVISION_ID = P_DIVISION_ID)
                                      ELSE (CASE WHEN Y.OPERATION_GROUP = 'P' THEN CAST(XLS_KEY1 AS NUMBER(10)) * 1
                                                 ELSE CAST(XLS_KEY1 AS NUMBER(19)) * 1000000
                                            END)
                                  END) AS SORT_KEY
                            FROM SCP_XLS_PSI_GLOBAL Y
                           WHERE 0 = 0
                             AND CELL_ITEM_ID IN (SELECT VALUE
                                                  FROM TABLE(FN_SPLITSTRING(V_PARAMETER3, ',')))
                             AND DIVISION_ID = P_DIVISION_ID   /* 2022.03.21 GM JV 반영  '81' --> @p_division_id */
                             AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                             AND CREATE_FROM_YYYYMMDD = P_CREATE_TO_YYYYMMDD_1
                         ) Y1
                       , (SELECT DIVISION_ID
                                , PLAN_START_YYYYMMDD
                                , PLAN_TYPE
                                , SEQ
                                , OPERATION_GROUP
                                , OPERATION_GROUP_NAME
                                , NVL(CELL_ITEM_ID, '-') AS CELL_ITEM_ID
                                , NVL(ITEM_ID, '-') AS ITEM_ID
                                , NICK_NAME
                                , CELL_QTY_PACK
                                , TO_SITE
                                , TO_SITE_DESCRIPTION
                                , PROJECT_CODE
                                , FROM_BOH_QTY
                                , TO_BOH_QTY
                                , INCOTERMS
                                , FROM_SITE
                                , FROM_SITE_DESCRIPTION
                                , TRANSPORT_MODE
                                , (CASE WHEN (TRANSPORT_MODE = '-') AND (MEASURE <> 'CELL_PROD') THEN '-'
                                       ELSE TO_CHAR(LT_DAY)
                                   END) AS LT_DAY
                                , YIELD
                                , PROD_LINE
                                , BOD_ID
                                , ATTRIBUTE4 AS GRO_STD_DIO  /* DIO 수정 관련 (기준 컬럼추가) */
                                , ATTRIBUTE5 AS MIN_STD_DIO  /* DIO 수정 관련 (최소 컬럼추가) */
                                , MEASURE
                                , MEASURE_LABEL
                                , XLS_KEY1
                                , XLS_KEY2
                                , XLS_KEY3
                                , XLS_KEY4
                                , XLS_KEY5
                                , XLS_ATTRIBUTE1
                                , XLS_ATTRIBUTE2
                                , XLS_ATTRIBUTE3
                                , XLS_ATTRIBUTE4
                                , XLS_ATTRIBUTE5
                                , SORT_ORDER_NO
                                , WQTY01
                                , WQTY02
                                , WQTY03
                                , WQTY04
                                , WQTY05
                                , WQTY06
                                , WQTY07
                                , WQTY08
                                , WQTY09
                                , WQTY10
                                , WQTY11
                                , WQTY12
                                , WQTY13
                                , WQTY14
                                , WQTY15
                                , WQTY16
                                , WQTY17
                                , WQTY18
                                , WQTY19
                                , WQTY20
                                , WQTY21
                                , WQTY22
                                , WQTY23
                                , WQTY24
                                , WQTY25
                                , WQTY26
                                , WQTY27
                                , WQTY28
                                , WQTY29
                                , WQTY30
                                , WQTY31
                                , WQTY32
                                , WQTY33
                                , WQTY34
                                , WQTY35
                                , WQTY36
                                , WQTY37
                                , WQTY38
                                , WQTY39
                                , WQTY40
                                , WQTY41
                                , WQTY42
                                , WQTY43
                                , WQTY44
                                , WQTY45
                                , WQTY46
                                , WQTY47
                                , WQTY48
                                , WQTY49
                                , WQTY50
                                , WQTY51
                                , WQTY52
                                /* ,CREATED_BY */
                                /* ,CREATION_DATE */
                                /* ,LAST_UPDATED_BY */
                                /* ,LAST_UPDATE_DATE */
                                /* ,ATTRIBUTE1 */
                                /* ,ATTRIBUTE10 */
                             FROM SCP_XLS_PSI_GLOBAL Y
                            WHERE 0 = 0
                              AND CELL_ITEM_ID IN (SELECT VALUE
                                                   FROM TABLE(FN_SPLITSTRING(V_PARAMETER3, ',')))
                              AND DIVISION_ID = P_DIVISION_ID   /* 2022.03.21 GM JV 반영  '81' --> @p_division_id */
                              AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                              AND CREATE_FROM_YYYYMMDD = P_CREATE_TO_YYYYMMDD_2
                         ) Y2
                   WHERE Y1.DIVISION_ID         = Y2.DIVISION_ID   /* ANSI INNER JOIN ~ ON 을 콤마 조인 + WHERE 로 전환(FM-015) */
                     AND Y1.PLAN_START_YYYYMMDD = Y2.PLAN_START_YYYYMMDD
                       /* WHERE Y1.PLAN_START_YYYYMMDD = Y2.PLAN_START_YYYYMMDD */
                     AND Y1.PLAN_TYPE           = Y2.PLAN_TYPE
                     AND Y1.SEQ                 = Y2.SEQ
                     AND Y1.OPERATION_GROUP     = Y2.OPERATION_GROUP
                     AND Y1.CELL_ITEM_ID        = Y2.CELL_ITEM_ID
                     AND Y1.ITEM_ID             = Y2.ITEM_ID
                     AND Y1.TO_SITE             = Y2.TO_SITE
                     AND Y1.PROJECT_CODE        = Y2.PROJECT_CODE
                     AND Y1.INCOTERMS           = Y2.INCOTERMS
                     AND Y1.FROM_SITE           = Y2.FROM_SITE
                     AND Y1.TRANSPORT_MODE      = Y2.TRANSPORT_MODE
                     AND Y1.PROD_LINE           = Y2.PROD_LINE
                     AND Y1.BOD_ID              = Y2.BOD_ID
                     AND Y1.MEASURE             = Y2.MEASURE
                     AND Y1.SORT_ORDER_NO       = Y2.SORT_ORDER_NO
                     AND Y1.MEASURE NOT IN ('PACK_PROD_LOAD', 'CELL_PROD_LOAD', 'PACK_PROD_TOTAL')   /* Load Ratio 조회안되게 변경 - 2022.09.30 */
                     AND NOT (Y1.OPERATION_GROUP = 'A' AND Y1.TO_SITE = '-'   /* 사업계획 수립에 따른 시뮬레이터 생산계획Bucket 확장 적용::2023-08-03(KSK) */
                              AND NVL((SELECT FN_GET_FINAL_ITEM('81', Y1.ITEM_ID, 'CELL_TYPE') FROM DUAL), ' ') = 'CP'
                             )
                       /* AND NOT (Y1.MEASURE = 'SHIP_PLAN' AND Y1.PROJECT_CODE = '-' )  프로젝트 코드가 없는 행은 제외(KSK,250408) */
                 ) X
               /* ORDER BY CELL_ITEM_ID ASC, SORT_KEY ASC, SORT_ORDER_NO ASC */
           WHERE MEASURE NOT IN ('MKT_FCST_CELL_TOTAL', 'MKT_FCST_TOTAL', 'ALLOCATION_TOTAL', 'EOH_TOTAL'
                                , 'MKT_FCST_DIO', 'ALLOCATION_DIO', 'ALLOCATION_GAP_STD_DIO', 'ALLOCATION_GAP_MIN_DIO')
           ORDER BY CELL_ITEM_ID, SORT_KEY, OPERATION_GROUP DESC;
      END IF;
    END;
END;