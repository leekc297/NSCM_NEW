PROCEDURE PR_SCP_ANL_DIO_REPORT
(
    P_DIVISION_ID          IN VARCHAR2
  , P_SEQ                  IN VARCHAR2
  , P_PLAN_START_YYYYMMDD  IN VARCHAR2
  , P_CREATED_BY           IN VARCHAR2
  , P_MONTH                IN NUMBER    /* 3~12까지의 개월수 */
  , P_VER                  IN NUMBER
)
/***********************************************************************************
 * Program ID  : [PR_SCP_ANL_DIO_REPORT]
 * Description  :  DIO REPORT 조회용 데이터 수집
 * Execute       :
               EXEC [dbo].[PR_SCP_ANL_DIO_REPORT] @P_DIVISION_ID = N'81', @P_SEQ = N'1', @P_PLAN_START_YYYYMMDD = N'20220207', @P_CREATED_BY = N@GETDATE_BY,  --SCP_batch @P_MONTH = 3 @P_VER = 1;

 * Program History
 *===================================================================================================
 *   Date        In Charge   Description
 *===================================================================================================
 * 2021/11/02   HJ.LEE      PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 - Initial Release
 * 2022.03.25   sclee       PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 - 새사업부 추가
 * 2022.05.06   hrkim       PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 오류 및 기능 개선건 대응
 *                          1. SCP_ANL_DIO_REPORT_DETAIL attribute1컬럼에 셀 환산 수량 정보 추가
 *                          2. SCP_ANL_DIO_REPORT FG 운송중재고 LT에 Incoterms 반영
 *                          3. 메인 운송 LT적용 팝업 기준으로 변경
 *                              - nick_name에 대한 각각의 수량 비중 LT SUM 적용
 * 2022.05.30   hrkim       PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : 오류 및 기능 개선건 추가 대응
 *                          1. nick_name 참조 기준 변경 (Group code Management의 Cell Group -> Level4)
 *                          2. 메인 데이터 nick_name 단위로 display (운송/Aging LT는 nick_name 단위이나, plant까지 display되고 있음)
 * 2022.06.13   hrkim       PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : DIO Report 버전 정보 데이터 추가
 * 2022.08.22   hrkim       PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2
 *                          - 셀 활성화 Aging L/T 팝업 데이터 추가
 * 2023.03.31   hrkim       PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 * 2023.04.27   hrkim       PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : Nick Name 기준 변경
 *                                                  - 변경전 : SCP_MST_FINAL_ITEM.GROUP_CODE5 (Product Level4 - Group Code Management - 81)
 *                                                  - 변경후 : SCP_MST_FINAL_ITEM.GROUP_CODE1 (Product Level1 - Group Code Management - 81)
 *
 * 2026.07.06  ZIONEX  [PJ202650304]  NextSCM Migration
 ************************************************************************************/
AS
    V_DEBUG_MODE      VARCHAR2(8 CHAR) := 'F';
    V_VERSION_NO      VARCHAR2(100 CHAR);

    V_FROM_YYYYMM     VARCHAR2(6 CHAR);
    V_TO_YYYYMM       VARCHAR2(8 CHAR);
    V_PLAN_TYPE       VARCHAR2(50 CHAR) := 'FN';
    V_VER             NUMBER;
    V_PLAN_START_DATE DATE := TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD');

    /* LOG 용 변수 설정 */
    V_PROGRAM_NAME    VARCHAR2(150 CHAR) := 'PR_SCP_ANL_DIO_REPORT';   /* Proc별 이름 설정 */
    V_LOG_TYPE        VARCHAR2(30 CHAR);                               /* START/END/ERROR/... */
    N_LOG_COUNT       NUMBER := 0;
    V_LOG_MESSAGE     VARCHAR2(1000 CHAR);
    V_DESCRIPTION     VARCHAR2(500 CHAR);
    D_EVENT_DATE      DATE;
    V_BATCH_USER      VARCHAR2(150 CHAR) := NVL(P_CREATED_BY, ' ');

    /* 임시 실행시간 확인용 */
    V_START_TIME      DATE := SYSDATE;
    V_EXEC_TIME       VARCHAR2(10 CHAR) := '';   /* '[00:00]' */
    V_ELAPSED_SEC     NUMBER;

    V_CNT             NUMBER;
    V_TARGET_DIV      NUMBER;
BEGIN

    /* 시작 LOG  (START) */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure  ##########';
    V_DESCRIPTION := P_DIVISION_ID || ' : ' || P_PLAN_START_YYYYMMDD || ' : ' || P_SEQ || ' : '
                     || TO_CHAR(NVL(P_VER, 1)) || ' : ' || TO_CHAR(NVL(P_MONTH, 0));
    D_EVENT_DATE  := SYSDATE;
    PR_SCP_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_BATCH_USER);

    V_FROM_YYYYMM := TO_CHAR(ADD_MONTHS(V_PLAN_START_DATE, 1), 'YYYYMM');
    V_TO_YYYYMM   := TO_CHAR(ADD_MONTHS(V_PLAN_START_DATE, P_MONTH), 'YYYYMM');
    V_VER         := NVL(P_VER, 1);   /* PJ20216891 : DIO Report 버전 정보 데이터 추가 */


    DBMS_OUTPUT.PUT_LINE('--------------------------------- -');
    DBMS_OUTPUT.PUT_LINE('@P_DIVISION_ID =' || P_DIVISION_ID);
    DBMS_OUTPUT.PUT_LINE('@P_SEQ = ' || P_SEQ);
    DBMS_OUTPUT.PUT_LINE('@P_PLAN_START_YYYYMMDD =' || P_PLAN_START_YYYYMMDD);
    DBMS_OUTPUT.PUT_LINE('@V_FROM_YYYYMM =' || V_FROM_YYYYMM);
    DBMS_OUTPUT.PUT_LINE('@V_TO_YYYYMM =' || V_TO_YYYYMM);
    DBMS_OUTPUT.PUT_LINE('@P_VER = ' || TO_CHAR(NVL(P_VER, 1)));
    DBMS_OUTPUT.PUT_LINE('----------------------------------');

    BEGIN


        DELETE FROM GT_DIO_LAST_PLAN;
        DELETE FROM GT_DIO_LAST_PLAN_KEYIN;
        DELETE FROM GT_DIO_REPORT1;
        DELETE FROM GT_DIO_SCM_MST_SITE;
        DELETE FROM GT_DIO_MODEL_BOM;
        DELETE FROM GT_DIO_PIVOT_TEMP;
        DELETE FROM GT_DIO_PIVOT;
        DELETE FROM GT_DIO_REPORT1_1;
        DELETE FROM GT_DIO_REPORT1_2;
        DELETE FROM GT_DIO_LINE_WEIGHT;
        DELETE FROM GT_DIO_FORMATION_LINE_ITEM;
        DELETE FROM GT_DIO_FORMATION_LINE;
        DELETE FROM GT_DIO_AGING_LT;
        DELETE FROM GT_DIO_AGING_LT_N;
        DELETE FROM GT_DIO_REPORT1_3;
        DELETE FROM GT_DIO_OPERATION_LT;
        DELETE FROM GT_DIO_SUMQTY_NICKNAME;
        DELETE FROM GT_DIO_BOD_WEIGHT;
        DELETE FROM GT_DIO_BOD_LT;
        DELETE FROM GT_DIO_DEPARTURE_LT;
        DELETE FROM GT_DIO_REPORT1_3_1;
        DELETE FROM GT_DIO_REPORT1_4;
        DELETE FROM GT_DIO_REPORT2;
        DELETE FROM GT_DIO_MAX_SHIP_PLAN;
        DELETE FROM GT_DIO_TMP_BIZ_TYPE;
        DELETE FROM GT_DIO_TMP_INCOTERMS;
        DELETE FROM GT_DIO_TMP_CELL_PLANT_SEMI;
        DELETE FROM GT_DIO_CYCLE_INVENTORY1;
        DELETE FROM GT_DIO_CYCLE_INVENTORY2;

        /* Range값 오류 (3개월 이상이어야 수행함) */
        IF NVL(P_MONTH, 0) < 3 OR NVL(P_MONTH, 0) > 12 THEN
            V_ELAPSED_SEC := ROUND((SYSDATE - V_START_TIME) * 86400);

            V_EXEC_TIME := CASE WHEN LENGTH(TO_CHAR(FLOOR(V_ELAPSED_SEC / 60))) > 2 THEN NULL
                                ELSE LPAD(TO_CHAR(FLOOR(V_ELAPSED_SEC / 60)), 2, '0') || ':' || LPAD(TO_CHAR(MOD(V_ELAPSED_SEC, 60)), 2, '0')
                           END;

            /* 종료 LOG */
            V_LOG_TYPE    := 'END';
            V_LOG_MESSAGE := '########## END of procedure [RETURN 8] ##########';
            V_DESCRIPTION := '[' || V_EXEC_TIME || ']';
            D_EVENT_DATE  := SYSDATE;
            PR_SCP_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_BATCH_USER);
            RETURN;   /* 원본 RETURN 8 */
        END IF;

        /* ------------------------------------------------------------------------------------------------------- */
        /* Begin - PJ20216891 : DIO Report 버전 정보 데이터 추가 */
        /* ------------------------------------------------------------------------------------------------------- */
        SELECT COUNT(*)
          INTO V_CNT
          FROM SCP_ANL_DIO_REPORT_VERSION V
         WHERE V.DIVISION_ID         = P_DIVISION_ID
           AND V.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND V.PLAN_TYPE           = V_PLAN_TYPE
           AND V.SEQ                 = P_SEQ
           AND V.VER                 = V_VER;

        IF V_CNT = 0 THEN
            INSERT INTO SCP_ANL_DIO_REPORT_VERSION
                   ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, VER, VER_STATUS, DATA_RANGE
                   , FROM_YYYYMM, TO_YYYYMM, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
            VALUES ( P_DIVISION_ID, P_PLAN_START_YYYYMMDD, V_PLAN_TYPE, P_SEQ, V_VER, 'P', P_MONTH
                   , V_FROM_YYYYMM, V_TO_YYYYMM, P_CREATED_BY, SYSDATE, P_CREATED_BY, SYSDATE );
        ELSE
            V_ELAPSED_SEC := ROUND((SYSDATE - V_START_TIME) * 86400);

            V_EXEC_TIME := CASE WHEN LENGTH(TO_CHAR(FLOOR(V_ELAPSED_SEC / 60))) > 2 THEN NULL
                                ELSE LPAD(TO_CHAR(FLOOR(V_ELAPSED_SEC / 60)), 2, '0') || ':' || LPAD(TO_CHAR(MOD(V_ELAPSED_SEC, 60)), 2, '0')
                           END;

            /* 종료 LOG */
            V_LOG_TYPE    := 'END';
            V_LOG_MESSAGE := '########## END of procedure [RETURN 9] ##########';
            V_DESCRIPTION := '[' || V_EXEC_TIME || ']';
            D_EVENT_DATE  := SYSDATE;
            PR_SCP_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_BATCH_USER);
            RETURN;   /* 원본 RETURN 9 : 생성중이거나 생성된 버전이 존재할시 실행하지 않음. */
        END IF;
        /* ------------------------------------------------------------------------------------------------------- */
        /* End - PJ20216891 : DIO Report 버전 정보 데이터 추가 */
        /* ------------------------------------------------------------------------------------------------------- */

        /* ------------------------------------------------------------------------------------------------------- */
        /* 사용자가 입력한 최근 데이터 가져오기 : UI 입력 정보 유지용 (#LAST_PLAN : 최근 CREATION_DATE 1행의 KEY) */
        /* ------------------------------------------------------------------------------------------------------- */
        INSERT INTO GT_DIO_LAST_PLAN (DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, VER)
        SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, VER
          FROM ( SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, VER
                   FROM SCP_ANL_DIO_REPORT
                  WHERE DIVISION_ID = P_DIVISION_ID
                    AND CREATION_DATE = ( SELECT MAX(CREATION_DATE)
                                            FROM SCP_ANL_DIO_REPORT
                                           WHERE DIVISION_ID          = P_DIVISION_ID
                                             AND PLAN_START_YYYYMMDD   = P_PLAN_START_YYYYMMDD
                                             AND PLAN_TYPE             = V_PLAN_TYPE
                                             AND SEQ                   = P_SEQ )
                  ORDER BY CREATION_DATE DESC )
         WHERE ROWNUM = 1;

        /* 사용자가 입력한 최근 데이터 가져오기 (#LAST_PLAN_KEYIN) */
        INSERT INTO GT_DIO_LAST_PLAN_KEYIN
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, NICK_NAME, PLANT_ID, FROM_SITE
            , CELL_EOL_SHIPPING_LOT, PACK_INCOMMING, PACK_OPERATION_LT, SHIPMENT_CELL_INSPECTION_LOAD
            , SHIPMENT_CELL_INSPECTION_WAITING, SHIPMENT_PACK_INSPECTION_LOAD, SHIPMENT_PACK_INSPECTION_WAITING
            , PRE_INSPECTION_CELL, PRE_INSPECTION_PACK, VMI_CELL, VMI_PACK, FOREIGN_CORP, RACK_BIZ
            , SAFETY_STOCK_CELL, SAFETY_STOCK_PACK, OTHER_STOCK_CELL, OTHER_STOCK_PACK )
        SELECT A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.NICK_NAME, A.PLANT_ID, A.FROM_SITE
             , A.CELL_EOL_SHIPPING_LOT, A.PACK_INCOMMING, A.PACK_OPERATION_LT, A.SHIPMENT_CELL_INSPECTION_LOAD
             , A.SHIPMENT_CELL_INSPECTION_WAITING, A.SHIPMENT_PACK_INSPECTION_LOAD, A.SHIPMENT_PACK_INSPECTION_WAITING
             , A.PRE_INSPECTION_CELL, A.PRE_INSPECTION_PACK, A.VMI_CELL, A.VMI_PACK, A.FOREIGN_CORP, A.RACK_BIZ
             , A.SAFETY_STOCK_CELL, A.SAFETY_STOCK_PACK, A.OTHER_STOCK_CELL, A.OTHER_STOCK_PACK
          FROM SCP_ANL_DIO_REPORT A
             , GT_DIO_LAST_PLAN B
         WHERE A.DIVISION_ID        = B.DIVISION_ID
           AND A.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE          = B.PLAN_TYPE
           AND A.SEQ                = B.SEQ
           AND A.VER                = B.VER;

        /* ------------------------------------------------------------------------------------------------------- */
        /* DIO 기본 데이터 FROM PSI (#REPORT1) */
        /* ------------------------------------------------------------------------------------------------------- */
        INSERT INTO GT_DIO_REPORT1
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, PLANT_ID, FROM_PLANT_ID, FROM_SITE_TYPE, FROM_CITY
            , TO_PLANT_ID, TO_SITE_TYPE, TO_CITY, SAME_CITY_FLAG, ITEM_ID, CELL_ITEM_ID, BIZ_TYPE, INCOTERMS
            , OPERATION_GROUP, FROM_SITE, TO_SITE, TO_BOH_QTY, BOD_ID, TRANSPORT_MODE_LINE, MEASURE, YYYYMM
            , MONTH_DIFF, SUMQTY, COMPANY_ID, SITE_ID )
        SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, PLANT_ID, PLANT_ID, FROM_SITE_TYPE, FROM_CITY
             , TO_PLANT_ID, TO_SITE_TYPE, TO_CITY
             , CASE WHEN FROM_CITY = TO_CITY THEN 'Y' ELSE 'N' END
             , ITEM_ID, CELL_ITEM_ID
             , CASE WHEN MEASURE = 'SHIP_PLAN' AND TO_SITE_TYPE = 'SALES' AND OPERATION_GROUP = 'A' THEN 'CELL'
                    WHEN MEASURE = 'SHIP_PLAN' AND TO_SITE_TYPE = 'SALES' AND OPERATION_GROUP = 'P' THEN 'PACK'
                    ELSE NULL END
             , INCOTERMS, OPERATION_GROUP, FROM_SITE, TO_SITE, TO_BOH_QTY, BOD_ID, TRANSPORT_MODE_LINE, MEASURE
             , YYYYMM, MONTH_DIFF, SUMQTY, COMPANY_ID, SITE_ID
          FROM ( SELECT A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.ITEM_ID, A.CELL_ITEM_ID, A.INCOTERMS, A.OPERATION_GROUP
                      , A.FROM_SITE, A.TO_SITE, A.TO_BOH_QTY, A.BOD_ID, A.TRANSPORT_MODE_LINE, A.MEASURE
                      , FS.PLANT_ID, FS.SITE_TYPE AS FROM_SITE_TYPE, FS.CITY AS FROM_CITY
                      , TS.PLANT_ID AS TO_PLANT_ID, TS.SITE_TYPE AS TO_SITE_TYPE, TS.CITY AS TO_CITY
                      , SUBSTR(A.YYYYMMDD, 1, 6) AS YYYYMM
                      , P_MONTH AS MONTH_DIFF,
                        FS.COMPANY_ID, FS.SITE_ID,       /* 2022.08 추가 */
                        SUM(A.QTY) AS SUMQTY
                   FROM SCP_ANL_PSI_GLOBAL A
                      , SCM_MST_SITE FS
                      , SCM_MST_SITE TS
                  WHERE FS.DIVISION_ID(+) = A.DIVISION_ID AND FS.SCM_SITE_ID(+) = A.FROM_SITE AND FS.VALID_YN(+) = 'Y'
                    AND TS.DIVISION_ID(+) = A.DIVISION_ID AND TS.SCM_SITE_ID(+) = A.TO_SITE AND TS.VALID_YN(+) = 'Y'
                    AND A.DIVISION_ID = P_DIVISION_ID
                    AND A.PLAN_TYPE = V_PLAN_TYPE
                    AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                    AND A.SEQ = P_SEQ
                    AND A.MEASURE IN ('SHIP_PLAN', 'PRODUCTION')
                    AND SUBSTR(A.YYYYMMDD, 1, 6) BETWEEN V_FROM_YYYYMM AND V_TO_YYYYMM
                    AND A.QTY <> 0
                  GROUP BY A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.ITEM_ID, A.CELL_ITEM_ID, A.INCOTERMS, A.OPERATION_GROUP
                      , A.FROM_SITE, A.TO_SITE, A.TO_BOH_QTY, A.BOD_ID, A.TRANSPORT_MODE_LINE, A.MEASURE
                      , FS.PLANT_ID, FS.SITE_TYPE, FS.CITY, TS.PLANT_ID, TS.SITE_TYPE, TS.CITY
                      , SUBSTR(A.YYYYMMDD, 1, 6), FS.COMPANY_ID, FS.SITE_ID ) A;

        /* ------------------------------------------------------------------------------------------------------- */
        /* DIO Master 데이터 */
        /* ------------------------------------------------------------------------------------------------------- */
        /* PLANT_NAME (#SCM_MST_SITE) */
        INSERT INTO GT_DIO_SCM_MST_SITE (DIVISION_ID, LOGISTIC_PLANT_ID, PLANT_ID, SCM_SITE_ID, OPERATION_GROUP, SITE_DESCRIPTION)
        SELECT S.DIVISION_ID, S.LOGISTIC_PLANT_ID, S.PLANT_ID, S.SCM_SITE_ID, S.OPERATION_GROUP, P.PLANT_NAME
          FROM SCM_MST_SITE S
             , SCM_MST_PLANT_SN P
         WHERE P.DIVISION_ID(+) = S.DIVISION_ID AND P.PLANT_ID(+) = S.LOGISTIC_PLANT_ID
           AND S.DIVISION_ID = P_DIVISION_ID
           AND S.LOGISTIC_PLANT_ID IS NOT NULL
           AND S.OPERATION_GROUP IN ('A', 'P');

        /* Cell Convert Qty (#tmp_SCM_MST_MODEL_FINAL_ITEM_BOM_V) */
        INSERT INTO GT_DIO_MODEL_BOM (DIVISION_ID, MODEL_ID, ACCUMULATED_CHILD_QTY)
        SELECT DIVISION_ID, MODEL_ID, MAX(ACCUMULATED_CHILD_QTY)
          FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V
         WHERE OPERATION_GROUP_ID = 'A'
         GROUP BY DIVISION_ID, MODEL_ID;

        /* 제품, TYPE, NICK_NAME(모델) (#TblDynamicPivot_CLASS_TYPE_TEMP) */
        /* ※ 원본 스칼라 서브쿼리 SELECT TOP 1 DOE / SELECT NICK_NAME(단일행 가정) -> MAX() 로 단일행 보장(ORA TOO_MANY_ROWS 방지) */
        INSERT INTO GT_DIO_PIVOT_TEMP
            ( DIVISION_ID, ITEM_ID, MATERIAL_CLASS_NAME, CELL_TYPE_GROUP_CODE, TYPE, FLOW_ID, CELL_GROUP, PACK_GROUP
            , LEVEL4, OPERATION_ID, NICK_NAME, CELL_CONV_QTY, BASIC_MODEL_PACK, BASIC_NICKNAME_PACK, CELL_MODEL
            , CELL_MODEL_NICKNAME, BASIC_MODEL_CELL, BASIC_NICKNAME_CELL )
        SELECT F.DIVISION_ID, F.ITEM_ID, L.MATERIAL_CLASS_NAME, F.CELL_TYPE_GROUP_CODE, I.TYPE, F.FLOW_ID
             , F.GROUP_CODE1, F.GROUP_CODE2, F.GROUP_CODE5, F.FLOW_ID, F.NICK_NAME
             , NVL(C.ACCUMULATED_CHILD_QTY, 1)
             , CASE WHEN F.OPERATION_GROUP = 'P'
                    THEN (SELECT MAX(DOE) FROM SCM_MST_ITEM_SN B WHERE B.DIVISION_ID = F.DIVISION_ID AND B.ITEM_ID = F.ITEM_ID AND B.DOE IS NOT NULL)
                    ELSE '' END
             , CASE WHEN F.OPERATION_GROUP = 'P'
                    THEN (SELECT MAX(NICK_NAME) FROM SCP_MST_FINAL_ITEM B
                           WHERE B.DIVISION_ID = F.DIVISION_ID
                             AND B.ITEM_ID = (SELECT MAX(DOE) FROM SCM_MST_ITEM_SN B2 WHERE B2.DIVISION_ID = F.DIVISION_ID AND B2.ITEM_ID = F.ITEM_ID AND B2.DOE IS NOT NULL))
                    ELSE '' END
             , CASE WHEN F.OPERATION_GROUP = 'P' THEN F.ATTRIBUTE1 ELSE '' END
             , CASE WHEN F.OPERATION_GROUP = 'P'
                    THEN (SELECT MAX(NICK_NAME) FROM SCP_MST_FINAL_ITEM B WHERE B.DIVISION_ID = F.DIVISION_ID AND B.ITEM_ID = F.ATTRIBUTE1)
                    ELSE '' END
             , CASE WHEN F.OPERATION_GROUP = 'P'
                    THEN (SELECT MAX(DOE) FROM SCM_MST_ITEM_SN B WHERE B.DIVISION_ID = F.DIVISION_ID AND B.ITEM_ID = F.ATTRIBUTE1 AND B.DOE IS NOT NULL)
                    ELSE (SELECT MAX(DOE) FROM SCM_MST_ITEM_SN B WHERE B.DIVISION_ID = F.DIVISION_ID AND B.ITEM_ID = F.ITEM_ID AND B.DOE IS NOT NULL)
                    END
             , CASE WHEN F.OPERATION_GROUP = 'P'
                    THEN (SELECT MAX(NICK_NAME) FROM SCP_MST_FINAL_ITEM B
                           WHERE B.DIVISION_ID = F.DIVISION_ID
                             AND B.ITEM_ID = (SELECT MAX(DOE) FROM SCM_MST_ITEM_SN B2 WHERE B2.DIVISION_ID = F.DIVISION_ID AND B2.ITEM_ID = F.ATTRIBUTE1 AND B2.DOE IS NOT NULL))
                    ELSE (SELECT MAX(NICK_NAME) FROM SCP_MST_FINAL_ITEM B
                           WHERE B.DIVISION_ID = F.DIVISION_ID
                             AND B.ITEM_ID = (SELECT MAX(DOE) FROM SCM_MST_ITEM_SN B2 WHERE B2.DIVISION_ID = F.DIVISION_ID AND B2.ITEM_ID = F.ITEM_ID AND B2.DOE IS NOT NULL))
                    END
          FROM SCP_MST_FINAL_ITEM F
             , ( SELECT SEGMENT1, DESCRIPTION AS MATERIAL_CLASS_NAME
                        FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                       WHERE LOOKUP_TYPE = 'CELL_TYPE_GROUP_CODE' AND VALID_YN = 'Y' ) L
             , ( SELECT ITEM_ID, MAX(SCP_EXTRA_SPEC) AS TYPE
                        FROM SCM_MST_ITEM_SN
                       WHERE DIVISION_ID = P_DIVISION_ID
                       GROUP BY ITEM_ID ) I
             , GT_DIO_MODEL_BOM C
             , ( SELECT DISTINCT DIVISION_ID, ITEM_ID FROM GT_DIO_REPORT1
                      UNION
                      SELECT DISTINCT DIVISION_ID, CELL_ITEM_ID FROM GT_DIO_REPORT1 ) B
         WHERE L.SEGMENT1(+) = F.CELL_TYPE_GROUP_CODE
           AND I.ITEM_ID(+) = F.ITEM_ID
           AND C.DIVISION_ID(+) = F.DIVISION_ID AND C.MODEL_ID(+) = F.ITEM_ID
           AND F.ITEM_ID = B.ITEM_ID AND F.DIVISION_ID = B.DIVISION_ID
           AND F.DIVISION_ID = P_DIVISION_ID;


        INSERT INTO GT_DIO_PIVOT
            ( DIVISION_ID, ITEM_ID, MATERIAL_CLASS_NAME, CELL_TYPE_GROUP_CODE, TYPE, FLOW_ID, BASIC_MODEL_PACK
            , BASIC_NICKNAME_PACK, CELL_MODEL, CELL_MODEL_NICKNAME, BASIC_NICKNAME_CELL, BASIC_MODEL_CELL
            , CELL_GROUP, PACK_GROUP, NICK_NAME, CELL_CONV_QTY )
        SELECT DIVISION_ID, ITEM_ID, MATERIAL_CLASS_NAME, CELL_TYPE_GROUP_CODE, TYPE, FLOW_ID, BASIC_MODEL_PACK
             , BASIC_NICKNAME_PACK, CELL_MODEL, CELL_MODEL_NICKNAME, BASIC_NICKNAME_CELL, BASIC_MODEL_CELL
             , CELL_GROUP, PACK_GROUP,
               /* 2023.04.27 Nick Name 기준 변경 (GROUP_CODE1 -> Product Level1 기준) */
               NVL(CELL_GROUP, NVL(BASIC_NICKNAME_CELL, NVL(NICK_NAME, ITEM_ID))) AS NICK_NAME
             , CELL_CONV_QTY
          FROM GT_DIO_PIVOT_TEMP;

        /* NICK_NAME, MATERIAL_CLASS_NAME, TYPE 추가 (#REPORT1_1) */
        INSERT INTO GT_DIO_REPORT1_1
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, PLANT_ID, FROM_PLANT_ID, FROM_SITE_TYPE, FROM_CITY
            , TO_PLANT_ID, TO_SITE_TYPE, TO_CITY, SAME_CITY_FLAG, ITEM_ID, CELL_ITEM_ID, BIZ_TYPE, INCOTERMS
            , OPERATION_GROUP, FROM_SITE, TO_SITE, TO_BOH_QTY, BOD_ID, TRANSPORT_MODE_LINE, MEASURE, YYYYMM
            , MONTH_DIFF, SUMQTY, COMPANY_ID, SITE_ID, NICK_NAME, MATERIAL_CLASS_NAME, TYPE, CELL_CONV_QTY, SUMQTY_CELL_CONV )
        SELECT A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.PLANT_ID, A.FROM_PLANT_ID, A.FROM_SITE_TYPE, A.FROM_CITY
             , A.TO_PLANT_ID, A.TO_SITE_TYPE, A.TO_CITY, A.SAME_CITY_FLAG, A.ITEM_ID, A.CELL_ITEM_ID, A.BIZ_TYPE, A.INCOTERMS
             , A.OPERATION_GROUP, A.FROM_SITE, A.TO_SITE, A.TO_BOH_QTY, A.BOD_ID, A.TRANSPORT_MODE_LINE, A.MEASURE, A.YYYYMM
             , A.MONTH_DIFF, A.SUMQTY, A.COMPANY_ID, A.SITE_ID
             , C.NICK_NAME, C.MATERIAL_CLASS_NAME, C.TYPE
             , NVL(C.CELL_CONV_QTY, 1) AS CELL_CONV_QTY
             , NVL(C.CELL_CONV_QTY, 1) * A.SUMQTY AS SUMQTY_CELL_CONV
          FROM GT_DIO_REPORT1 A
             , GT_DIO_PIVOT C
         WHERE C.DIVISION_ID(+) = A.DIVISION_ID AND C.ITEM_ID(+) = A.ITEM_ID;


        INSERT INTO GT_DIO_REPORT1_2
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, PLANT_ID, FROM_PLANT_ID, FROM_SITE_TYPE, FROM_CITY
            , TO_PLANT_ID, TO_SITE_TYPE, TO_CITY, SAME_CITY_FLAG, ITEM_ID, CELL_ITEM_ID, BIZ_TYPE, INCOTERMS
            , OPERATION_GROUP, FROM_SITE, TO_SITE, TO_BOH_QTY, BOD_ID, TRANSPORT_MODE_LINE, MEASURE, YYYYMM
            , MONTH_DIFF, SUMQTY, COMPANY_ID, SITE_ID, NICK_NAME, MATERIAL_CLASS_NAME, TYPE, CELL_CONV_QTY, SUMQTY_CELL_CONV
            , END_CUSTOMER, SCM_SITE_ID, SOLDTO_CUSTOMER, SITE_TYPE )
        SELECT A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.PLANT_ID, A.FROM_PLANT_ID, A.FROM_SITE_TYPE, A.FROM_CITY
             , A.TO_PLANT_ID, A.TO_SITE_TYPE, A.TO_CITY, A.SAME_CITY_FLAG, A.ITEM_ID, A.CELL_ITEM_ID, A.BIZ_TYPE, A.INCOTERMS
             , A.OPERATION_GROUP, A.FROM_SITE, A.TO_SITE, A.TO_BOH_QTY, A.BOD_ID, A.TRANSPORT_MODE_LINE, A.MEASURE, A.YYYYMM
             , A.MONTH_DIFF, A.SUMQTY, A.COMPANY_ID, A.SITE_ID, A.NICK_NAME, A.MATERIAL_CLASS_NAME, A.TYPE, A.CELL_CONV_QTY, A.SUMQTY_CELL_CONV
             , M.END_CUSTOMER, M.SCM_SITE_ID, M.SOLDTO_CUSTOMER, NVL(A.TO_SITE_TYPE, 'PLANT') AS SITE_TYPE
          FROM GT_DIO_REPORT1_1 A
             , ( SELECT T.DIVISION_ID, T.END_CUSTOMER
             , CASE WHEN T.SOLDTO_CUSTOMER1 <> T.SOLDTO_CUSTOMER2 THEN 'COMMON'
                                  ELSE NVL(T.SOLDTO_CUSTOMER1, T.SOLDTO_CUSTOMER2) END AS SOLDTO_CUSTOMER
                           , T.SCM_SITE_ID, T.SITE_TYPE
                        FROM ( SELECT P.DIVISION_ID
                                    , CASE WHEN P.DIVISION_ID = '40' THEN 'acer' ELSE P.END_CUSTOMER END AS END_CUSTOMER
                                    , MAX(P.SOLDTO_CUSTOMER) AS SOLDTO_CUSTOMER1
                                    , MIN(P.SOLDTO_CUSTOMER) AS SOLDTO_CUSTOMER2
                                    , P.SCM_SITE_ID, P.SITE_TYPE
                                 FROM SCM_MST_SITE P
                                WHERE P.DIVISION_ID = P_DIVISION_ID
                                GROUP BY P.DIVISION_ID, P.END_CUSTOMER, P.SCM_SITE_ID, P.SITE_TYPE ) T ) M
         WHERE M.SCM_SITE_ID(+) = A.TO_SITE AND M.DIVISION_ID(+) = A.DIVISION_ID
           AND A.SUMQTY != 0;

        /* --------------------------------------------------------------------------------------- */
        /* AGING L/T 용 (2022.08 PJ20216994 Phase 2) */
        /* --------------------------------------------------------------------------------------- */
        /* LINE별 가중치 (#LINE_WEIGHT) */
        INSERT INTO GT_DIO_LINE_WEIGHT (NICK_NAME, PLANT_ID, LINE_ID, SUMQTY, PROD_QTY, LINE_WEIGHT)
        SELECT DISTINCT R.NICK_NAME, R.PLANT_ID, R.TRANSPORT_MODE_LINE AS LINE_ID
             , SUM(SUMQTY) OVER (PARTITION BY R.NICK_NAME, R.PLANT_ID, R.TRANSPORT_MODE_LINE) AS SUMQTY
             , SUM(SUMQTY) OVER (PARTITION BY R.NICK_NAME) AS PROD_QTY
             , SUM(SUMQTY) OVER (PARTITION BY R.NICK_NAME, R.PLANT_ID, R.TRANSPORT_MODE_LINE)
                 / SUM(SUMQTY) OVER (PARTITION BY R.NICK_NAME) AS LINE_WEIGHT
          FROM GT_DIO_REPORT1_2 R
         WHERE R.MEASURE = 'PRODUCTION' AND R.OPERATION_GROUP = 'A' AND R.SUMQTY > 0;

        /* FP Aging LT 정보 (가중치 적용전) - LINE*ITEM (#SCP_MST_FORMATION_LINE_ITEM) */
        INSERT INTO GT_DIO_FORMATION_LINE_ITEM
            ( COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, LINE_ID, NICK_NAME, ITEM_ID, FACTORY_ID, OPERATION_ID
            , STANDARD_LT_MIN, STANDARD_LT_DAY )
        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.LINE_ID, C.NICK_NAME, A.ITEM_ID
             , MAX(A.FACTORY_ID) AS FACTORY_ID, MAX(I.FLOW_ID) AS OPERATION_ID
             , NVL(SUM(A.STANDARD_LT), 0) AS STANDARD_LT_MIN
             , NVL(SUM(A.STANDARD_LT), 0) / 60 / 24 AS STANDARD_LT_DAY
          FROM SCM_MST_AGING_ITEM_FLOW_M_SN A
             , GT_DIO_PIVOT C
             , SCM_MST_ITEM_SN I
         WHERE 1 = 1
           AND A.DIVISION_ID = C.DIVISION_ID AND A.ITEM_ID = C.ITEM_ID
           AND I.ITEM_ID(+) = A.ITEM_ID AND I.COMPANY_ID(+) = A.COMPANY_ID AND I.DIVISION_ID(+) = A.DIVISION_ID AND I.SITE_ID(+) = A.SITE_ID
           AND A.DEFAULT_ROUTE = 'Y'
           AND A.STANDARD_LT IS NOT NULL
           AND EXISTS ( SELECT 1
                          FROM ( SELECT P.COMPANY_ID, P.DIVISION_ID, P.SITE_ID, P.PLANT_ID, P.FACTORY_ID, P.ITEM_ID, P.LINE_ID, P.ROUTE_TYPE, MIN(P.ROUTE_ID) AS ROUTE_ID
                                   FROM SCM_MST_AGING_ITEM_FLOW_M_SN P
                                  WHERE 1 = 1
                                    AND P.DIVISION_ID = P_DIVISION_ID
                                    AND P.ROUTE_TYPE IN ('C', 'D')
                                    AND P.DEFAULT_ROUTE = 'Y'
                                  GROUP BY P.COMPANY_ID, P.DIVISION_ID, P.SITE_ID, P.PLANT_ID, P.FACTORY_ID, P.ITEM_ID, P.LINE_ID, P.ROUTE_TYPE ) B
                         WHERE A.COMPANY_ID = B.COMPANY_ID AND A.DIVISION_ID = B.DIVISION_ID AND A.SITE_ID = B.SITE_ID
                           AND A.PLANT_ID = B.PLANT_ID AND A.FACTORY_ID = B.FACTORY_ID AND A.ITEM_ID = B.ITEM_ID
                           AND A.LINE_ID = B.LINE_ID AND A.ROUTE_ID = B.ROUTE_ID AND A.ROUTE_TYPE = B.ROUTE_TYPE )
         GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, A.LINE_ID, C.NICK_NAME;

        /* FP Aging LT 정보 (가중치 적용전) - LINE (#SCP_MST_FORMATION_LINE) */

        INSERT INTO GT_DIO_FORMATION_LINE (COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, NICK_NAME, LINE_ID, STANDARD_LT_DAY)
        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.NICK_NAME, A.LINE_ID
             , ROUND(AVG(A.STANDARD_LT_MIN) / 1440.0, 2) AS STANDARD_LT_DAY
          FROM GT_DIO_FORMATION_LINE_ITEM A
         GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.NICK_NAME, A.LINE_ID;

        /* AGING L/T * 가중치 : Cell Prod 존재하는 경우 (#AGING_LT) */
        INSERT INTO GT_DIO_AGING_LT (COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, NICK_NAME, LINE_ID, STANDARD_LT_DAY, LINE_WEIGHT, AGING_LT)
        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.NICK_NAME, A.LINE_ID, A.STANDARD_LT_DAY
             , W.LINE_WEIGHT, A.STANDARD_LT_DAY * W.LINE_WEIGHT AS AGING_LT
          FROM GT_DIO_FORMATION_LINE A
             , GT_DIO_LINE_WEIGHT W
         WHERE A.NICK_NAME = W.NICK_NAME AND A.PLANT_ID = W.PLANT_ID AND A.LINE_ID = W.LINE_ID;   /* 12.02조건 추가 */

        /* Cell Prod 없는 경우 (#AGING_LT_N) */
        INSERT INTO GT_DIO_AGING_LT_N (COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, NICK_NAME, LINE_ID, STANDARD_LT_DAY, LINE_WEIGHT, AGING_LT)
        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.NICK_NAME, A.LINE_ID, A.STANDARD_LT_DAY
             , 1, A.STANDARD_LT_DAY AS AGING_LT
          FROM GT_DIO_FORMATION_LINE A
         WHERE 1 = 1
           AND NOT EXISTS ( SELECT 1 FROM GT_DIO_AGING_LT W WHERE W.NICK_NAME = A.NICK_NAME );

        /* 여기서부터는 SHIP_PLAN DATA 만 (#REPORT1_3) */
        INSERT INTO GT_DIO_REPORT1_3
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, PLANT_ID, FROM_PLANT_ID, FROM_SITE_TYPE, FROM_CITY
            , TO_PLANT_ID, TO_SITE_TYPE, TO_CITY, SAME_CITY_FLAG, ITEM_ID, CELL_ITEM_ID, BIZ_TYPE, INCOTERMS
            , OPERATION_GROUP, FROM_SITE, TO_SITE, TO_BOH_QTY, BOD_ID, TRANSPORT_MODE_LINE, MEASURE, YYYYMM
            , MONTH_DIFF, SUMQTY, COMPANY_ID, SITE_ID, NICK_NAME, MATERIAL_CLASS_NAME, TYPE, CELL_CONV_QTY, SUMQTY_CELL_CONV
            , END_CUSTOMER, SCM_SITE_ID, SOLDTO_CUSTOMER, SITE_TYPE, AGING_LT )
        SELECT R.DIVISION_ID, R.PLAN_START_YYYYMMDD, R.PLAN_TYPE, R.SEQ, R.PLANT_ID, R.FROM_PLANT_ID, R.FROM_SITE_TYPE, R.FROM_CITY
             , R.TO_PLANT_ID, R.TO_SITE_TYPE, R.TO_CITY, R.SAME_CITY_FLAG, R.ITEM_ID, R.CELL_ITEM_ID, R.BIZ_TYPE, R.INCOTERMS
             , R.OPERATION_GROUP, R.FROM_SITE, R.TO_SITE, R.TO_BOH_QTY, R.BOD_ID, R.TRANSPORT_MODE_LINE, R.MEASURE, R.YYYYMM
             , R.MONTH_DIFF, R.SUMQTY, R.COMPANY_ID, R.SITE_ID, R.NICK_NAME, R.MATERIAL_CLASS_NAME, R.TYPE, R.CELL_CONV_QTY, R.SUMQTY_CELL_CONV
             , R.END_CUSTOMER, R.SCM_SITE_ID, R.SOLDTO_CUSTOMER, R.SITE_TYPE, LT.AGING_LT
          FROM GT_DIO_REPORT1_2 R
             , ( SELECT NICK_NAME, SUM(AGING_LT) AS AGING_LT FROM GT_DIO_AGING_LT GROUP BY NICK_NAME    /* Cell Prod 존재 : 가중치 SUM */
                      UNION ALL
                      SELECT NICK_NAME, AVG(AGING_LT) AS AGING_LT FROM GT_DIO_AGING_LT_N GROUP BY NICK_NAME  /* Cell Prod 없음 : 평균 */
                    ) LT
         WHERE LT.NICK_NAME(+) = R.NICK_NAME
           AND R.MEASURE = 'SHIP_PLAN';

        /* --------------------------------------------------------------------------------------- */
        /* DIO_REPORT_DETAIL_AGING 생성 (2022.08월 추가) */
        /* --------------------------------------------------------------------------------------- */
        DELETE FROM SCP_ANL_DIO_REPORT_DETAIL_AGING
         WHERE DIVISION_ID         = P_DIVISION_ID
           AND PLAN_START_YYYYMMDD  = P_PLAN_START_YYYYMMDD
           AND PLAN_TYPE            = V_PLAN_TYPE
           AND SEQ                  = P_SEQ
           AND VER                  = V_VER;

        INSERT INTO SCP_ANL_DIO_REPORT_DETAIL_AGING
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, VER, NICK_NAME, ITEM_ID, COMPANY_ID, SITE_ID
            , PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, LINE_AVG_AGING_LT, CELL_AGING_LT, TOTAL
            , M1, M2, M3, M4, M5, M6, M7, M8, M9, M10, M11, M12, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
        SELECT P_DIVISION_ID, P_PLAN_START_YYYYMMDD, V_PLAN_TYPE, P_SEQ, V_VER
             , NVL(F.NICK_NAME, P.NICK_NAME), NVL(F.ITEM_ID, P.ITEM_ID), NVL(F.COMPANY_ID, P.COMPANY_ID), NVL(F.SITE_ID, P.SITE_ID),
               NVL(F.PLANT_ID, P.PLANT_ID), NVL(F.FACTORY_ID, '-'), NVL(F.LINE_ID, P.LINE_ID), NVL(F.OPERATION_ID, '-'),
               NVL(L.STANDARD_LT_DAY, 0) AS LINE_AVG_AGING_LT, NVL(F.STANDARD_LT_DAY, 0) AS CELL_AGING_LT
             , NVL(P.TOTAL, 0) AS TOTAL
             , NVL(P.M1, 0), NVL(P.M2, 0), NVL(P.M3, 0), NVL(P.M4, 0), NVL(P.M5, 0), NVL(P.M6, 0)
             , NVL(P.M7, 0), NVL(P.M8, 0), NVL(P.M9, 0), NVL(P.M10, 0), NVL(P.M11, 0), NVL(P.M12, 0)
             , P_CREATED_BY, SYSDATE, P_CREATED_BY, SYSDATE

          FROM GT_DIO_FORMATION_LINE_ITEM F
          FULL OUTER JOIN ( SELECT R.NICK_NAME, R.ITEM_ID, R.DIVISION_ID, R.COMPANY_ID, R.SITE_ID, R.PLANT_ID
                                 , R.TRANSPORT_MODE_LINE AS LINE_ID, SUM(R.SUMQTY) AS TOTAL
                                 , SUM(CASE WHEN R.YYYYMM = TO_CHAR(ADD_MONTHS(V_PLAN_START_DATE, 1), 'YYYYMM') THEN R.SUMQTY END) AS M1
                                 , SUM(CASE WHEN R.YYYYMM = TO_CHAR(ADD_MONTHS(V_PLAN_START_DATE, 2), 'YYYYMM') THEN R.SUMQTY END) AS M2
                                 , SUM(CASE WHEN R.YYYYMM = TO_CHAR(ADD_MONTHS(V_PLAN_START_DATE, 3), 'YYYYMM') THEN R.SUMQTY END) AS M3
                                 , SUM(CASE WHEN R.YYYYMM = TO_CHAR(ADD_MONTHS(V_PLAN_START_DATE, 4), 'YYYYMM') THEN R.SUMQTY END) AS M4
                                 , SUM(CASE WHEN R.YYYYMM = TO_CHAR(ADD_MONTHS(V_PLAN_START_DATE, 5), 'YYYYMM') THEN R.SUMQTY END) AS M5
                                 , SUM(CASE WHEN R.YYYYMM = TO_CHAR(ADD_MONTHS(V_PLAN_START_DATE, 6), 'YYYYMM') THEN R.SUMQTY END) AS M6
                                 , SUM(CASE WHEN R.YYYYMM = TO_CHAR(ADD_MONTHS(V_PLAN_START_DATE, 7), 'YYYYMM') THEN R.SUMQTY END) AS M7
                                 , SUM(CASE WHEN R.YYYYMM = TO_CHAR(ADD_MONTHS(V_PLAN_START_DATE, 8), 'YYYYMM') THEN R.SUMQTY END) AS M8
                                 , SUM(CASE WHEN R.YYYYMM = TO_CHAR(ADD_MONTHS(V_PLAN_START_DATE, 9), 'YYYYMM') THEN R.SUMQTY END) AS M9
                                 , SUM(CASE WHEN R.YYYYMM = TO_CHAR(ADD_MONTHS(V_PLAN_START_DATE, 10), 'YYYYMM') THEN R.SUMQTY END) AS M10
                                 , SUM(CASE WHEN R.YYYYMM = TO_CHAR(ADD_MONTHS(V_PLAN_START_DATE, 11), 'YYYYMM') THEN R.SUMQTY END) AS M11
                                 , SUM(CASE WHEN R.YYYYMM = TO_CHAR(ADD_MONTHS(V_PLAN_START_DATE, 12), 'YYYYMM') THEN R.SUMQTY END) AS M12
                              FROM GT_DIO_REPORT1_2 R
                             WHERE R.MEASURE = 'PRODUCTION' AND R.OPERATION_GROUP = 'A' AND R.SUMQTY > 0
                             GROUP BY R.NICK_NAME, R.ITEM_ID, R.DIVISION_ID, R.COMPANY_ID, R.SITE_ID, R.PLANT_ID, R.TRANSPORT_MODE_LINE ) P
                       ON P.NICK_NAME = F.NICK_NAME AND P.ITEM_ID = F.ITEM_ID AND P.DIVISION_ID = F.DIVISION_ID
                      AND P.COMPANY_ID = F.COMPANY_ID AND P.SITE_ID = F.SITE_ID AND P.PLANT_ID = F.PLANT_ID AND P.LINE_ID = F.LINE_ID
          LEFT JOIN GT_DIO_FORMATION_LINE L
                 ON L.NICK_NAME = NVL(F.NICK_NAME, P.NICK_NAME) AND L.DIVISION_ID = NVL(F.DIVISION_ID, P.DIVISION_ID)
                AND L.COMPANY_ID = NVL(F.COMPANY_ID, P.COMPANY_ID) AND L.SITE_ID = NVL(F.SITE_ID, P.SITE_ID)
                AND L.PLANT_ID = NVL(F.PLANT_ID, P.PLANT_ID) AND L.LINE_ID = NVL(F.LINE_ID, P.LINE_ID)
         WHERE EXISTS ( SELECT 1 FROM GT_DIO_REPORT1_3 R                       /* SHIP_PLAN FG가 존재하는 경우만 main에 조회됨 */
                         WHERE R.NICK_NAME = NVL(F.NICK_NAME, P.NICK_NAME)
                           AND R.SITE_TYPE = 'SALES' );                        /* FG */

        /* --------------------------------------------------------------------------------------- */
        /* Operation LT 구하기 (#OPERATION_LT) */
        /* --------------------------------------------------------------------------------------- */
        INSERT INTO GT_DIO_OPERATION_LT (DIVISION_ID, SCM_SITE_ID, ITEM_ID, LT_DAY)
        SELECT DIVISION_ID, SCM_SITE_ID, ITEM_ID, LT_DAY
          FROM SCP_MST_OPERATION_LT
         WHERE DIVISION_ID = P_DIVISION_ID AND LT_OPERATION = 'PRE_INSP';

        /* --------------------------------------------------------------------------------------- */
        /* 2022.05 PJ20216891 : 오류 및 기능 개선건 대응 (NICKNAME/SITE_TYPE 합계 / BOD 가중치 / BOD LT / DEPARTURE LT) */
        /* --------------------------------------------------------------------------------------- */
        /* NICNAME/SITE_TYPE별 수량 합계 (#SUMQTY_NICKNAME) */
        INSERT INTO GT_DIO_SUMQTY_NICKNAME (NICK_NAME, SITE_TYPE, SHIP_QTY, CELL_CONV_SHIP_QTY)
        SELECT NICK_NAME, SITE_TYPE, SUM(SUMQTY) AS SHIP_QTY, SUM(SUMQTY * CELL_CONV_QTY) AS CELL_CONV_SHIP_QTY
          FROM GT_DIO_REPORT1_2
         WHERE 1 = 1
           AND MEASURE = 'SHIP_PLAN'
           AND SUMQTY > 0
         GROUP BY NICK_NAME, SITE_TYPE;

        /* NICNAME/SITE_TYPE/PLANT/BOD별 NICK NAME 전체 수량에 대한 비중 (#BOD_WEIGHT) */
        INSERT INTO GT_DIO_BOD_WEIGHT (NICK_NAME, SITE_TYPE, PLANT_ID, BOD_ID, CELL_CONV_SHIP_QTY, SUMQTY, SUMQTY_CONV, SITE_WEIGHT)
        SELECT A.NICK_NAME, S.SITE_TYPE
             , CASE WHEN S.SITE_TYPE = 'SALES' THEN A.PLANT_ID ELSE A.TO_PLANT_ID END AS PLANT_ID
             , A.BOD_ID, S.CELL_CONV_SHIP_QTY
             , SUM(A.SUMQTY) AS SUMQTY
             , SUM(A.SUMQTY * A.CELL_CONV_QTY) AS SUMQTY_CONV
             , SUM(A.SUMQTY * A.CELL_CONV_QTY) / S.CELL_CONV_SHIP_QTY AS SITE_WEIGHT
          FROM GT_DIO_REPORT1_2 A
             , GT_DIO_SUMQTY_NICKNAME S
         WHERE 1 = 1
           AND S.NICK_NAME = A.NICK_NAME AND S.SITE_TYPE = A.SITE_TYPE
           AND A.MEASURE = 'SHIP_PLAN'
           AND A.SUMQTY > 0
         GROUP BY A.NICK_NAME, S.SITE_TYPE
             , CASE WHEN S.SITE_TYPE = 'SALES' THEN A.PLANT_ID ELSE A.TO_PLANT_ID END,
               A.BOD_ID, S.CELL_CONV_SHIP_QTY;   /* nick_name, site_type에 대한 종속적인 값 */

        /* BOD LT 참조 (#BOD_LT) */
        INSERT INTO GT_DIO_BOD_LT
            ( BOD_ID, DEPART_DAYS, LT_DEPARTURE_INLAND, LT_WAIT_SHIPPING, LT_VOYAGE, LT_LAY_OFF_CLEARANCE, LT_ARRIVAL_INLAND
            , INCOTERMS_LT_DEPARTURE_INLAND, INCOTERMS_LT_WAIT_SHIPPING, INCOTERMS_LT_VOYAGE
            , INCOTERMS_LT_LAY_OFF_CLEARANCE, INCOTERMS_LT_ARRIVAL_INLAND )
        SELECT DISTINCT B.BOD_ID
             , CASE WHEN R.DAYS_MON = 'Y' OR R.DAYS_TUE = 'Y' OR R.DAYS_WED = 'Y' OR R.DAYS_THU = 'Y'
                      OR R.DAYS_FRI = 'Y' OR R.DAYS_SAT = 'Y' OR R.DAYS_SUN = 'Y'
                    THEN ROUND( 3.5 / ( CASE WHEN R.DAYS_MON = 'Y' THEN 1 ELSE 0 END
                                       + CASE WHEN R.DAYS_TUE = 'Y' THEN 1 ELSE 0 END
                                       + CASE WHEN R.DAYS_WED = 'Y' THEN 1 ELSE 0 END
                                       + CASE WHEN R.DAYS_THU = 'Y' THEN 1 ELSE 0 END
                                       + CASE WHEN R.DAYS_FRI = 'Y' THEN 1 ELSE 0 END
                                       + CASE WHEN R.DAYS_SAT = 'Y' THEN 1 ELSE 0 END
                                       + CASE WHEN R.DAYS_SUN = 'Y' THEN 1 ELSE 0 END ), 2)
                    ELSE 0 END AS DEPART_DAYS
             , R.LT_DEPARTURE_INLAND, R.LT_WAIT_SHIPPING, R.LT_VOYAGE, R.LT_LAY_OFF_CLEARANCE, R.LT_ARRIVAL_INLAND
             , CASE WHEN NVL(I.SEGMENT3, 'F') != 'A' THEN R.LT_DEPARTURE_INLAND ELSE 0 END AS INCOTERMS_LT_DEPARTURE_INLAND
             , CASE WHEN NVL(I.SEGMENT3, 'F') NOT IN ('A', 'B') THEN R.LT_WAIT_SHIPPING ELSE 0 END AS INCOTERMS_LT_WAIT_SHIPPING
             , CASE WHEN NVL(I.SEGMENT3, 'F') NOT IN ('A', 'B', 'C') THEN R.LT_VOYAGE ELSE 0 END AS INCOTERMS_LT_VOYAGE
             , CASE WHEN NVL(I.SEGMENT3, 'F') NOT IN ('A', 'B', 'C', 'D') THEN R.LT_LAY_OFF_CLEARANCE ELSE 0 END AS INCOTERMS_LT_LAY_OFF_CLEARANCE
             , CASE WHEN NVL(I.SEGMENT3, 'F') NOT IN ('A', 'B', 'C', 'D', 'E') THEN R.LT_ARRIVAL_INLAND ELSE 0 END AS INCOTERMS_LT_ARRIVAL_INLAND

          FROM GT_DIO_REPORT1_2 A
         INNER JOIN SCP_MST_BOD B ON B.BOD_ID = A.BOD_ID
         INNER JOIN SCP_MST_DISTRIBUTION_ROUTE R ON R.ROUTE_ID = B.ROUTE_ID
          LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL I
                 ON I.LOOKUP_TYPE = 'INCOTERMS'
                AND I.SEGMENT1 = CASE WHEN A.SITE_TYPE = 'SALES' THEN B.INCOTERMS ELSE 'DAP' END
                AND I.VALID_YN = 'Y'
         WHERE 1 = 1
           AND A.MEASURE = 'SHIP_PLAN'
           AND A.SUMQTY > 0;

        /* NICK_NAME, PLANT_ID, SITE_TYPE별 LT 사이트 가중치 Summary (#DEPARTURE_LT) */
        INSERT INTO GT_DIO_DEPARTURE_LT
            ( NICK_NAME, SITE_TYPE, SUMQTY, SUMQTY_CONV, SITE_WEIGHT, DEPART_DAYS
            , INCOTERMS_LT_DEPARTURE_INLAND, INCOTERMS_LT_WAIT_SHIPPING, INCOTERMS_LT_VOYAGE
            , INCOTERMS_LT_LAY_OFF_CLEARANCE, INCOTERMS_LT_ARRIVAL_INLAND
            , LT_DEPARTURE_INLAND, LT_WAIT_SHIPPING, LT_VOYAGE, LT_LAY_OFF_CLEARANCE, LT_ARRIVAL_INLAND )
        SELECT A.NICK_NAME, A.SITE_TYPE
             , SUM(A.SUMQTY) AS SUMQTY, SUM(A.SUMQTY_CONV) AS SUMQTY_CONV, SUM(A.SITE_WEIGHT) AS SITE_WEIGHT
             , SUM(A.SITE_WEIGHT * L.DEPART_DAYS) AS DEPART_DAYS,
               /* incoterms 반영 (MAIN 생성시 반영) */
               SUM(A.SITE_WEIGHT * L.INCOTERMS_LT_DEPARTURE_INLAND) AS INCOTERMS_LT_DEPARTURE_INLAND
             , SUM(A.SITE_WEIGHT * L.INCOTERMS_LT_WAIT_SHIPPING) AS INCOTERMS_LT_WAIT_SHIPPING
             , SUM(A.SITE_WEIGHT * L.INCOTERMS_LT_VOYAGE) AS INCOTERMS_LT_VOYAGE
             , SUM(A.SITE_WEIGHT * L.INCOTERMS_LT_LAY_OFF_CLEARANCE) AS INCOTERMS_LT_LAY_OFF_CLEARANCE
             , SUM(A.SITE_WEIGHT * L.INCOTERMS_LT_ARRIVAL_INLAND) AS INCOTERMS_LT_ARRIVAL_INLAND,
               /* incoterms 미반영 (DETAIL 생성시 반영 - UI에서 반영) */
               SUM(A.SITE_WEIGHT * L.LT_DEPARTURE_INLAND) AS LT_DEPARTURE_INLAND
             , SUM(A.SITE_WEIGHT * L.LT_WAIT_SHIPPING) AS LT_WAIT_SHIPPING
             , SUM(A.SITE_WEIGHT * L.LT_VOYAGE) AS LT_VOYAGE
             , SUM(A.SITE_WEIGHT * L.LT_LAY_OFF_CLEARANCE) AS LT_LAY_OFF_CLEARANCE
             , SUM(A.SITE_WEIGHT * L.LT_ARRIVAL_INLAND) AS LT_ARRIVAL_INLAND
          FROM GT_DIO_BOD_WEIGHT A
             , GT_DIO_BOD_LT L
         WHERE 1 = 1
           AND L.BOD_ID = A.BOD_ID
         GROUP BY A.NICK_NAME, A.SITE_TYPE;

        /* --------------------------------------------------------------------------------------- */
        /* DIO_REPORT_DETAIL 생성 */
        /* --------------------------------------------------------------------------------------- */
        DELETE FROM SCP_ANL_DIO_REPORT_DETAIL
         WHERE DIVISION_ID         = P_DIVISION_ID
           AND PLAN_START_YYYYMMDD  = P_PLAN_START_YYYYMMDD
           AND PLAN_TYPE            = V_PLAN_TYPE
           AND SEQ                  = P_SEQ
           AND VER                  = V_VER;

        INSERT INTO SCP_ANL_DIO_REPORT_DETAIL
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, VER, ITEM_ID, NICK_NAME, FROM_SITE, TO_SITE
            , TRANSPORT_MODE_LINE, INCOTERMS, OPERATION_GROUP, BOD_ID
            , M1, M2, M3, M4, M5, M6, M7, M8, M9, M10, M11, M12
            , DATA_RANGE, FROM_CITY, TO_CITY, DNI_DEPART_DAYS, DNI_DEPARTURE_INLAND, DNI_WAITING_FOR_SHIPPING
            , DNI_VOYAGE, DNI_LAY_OFF_CUSTOMS_CLEARANCE, DNI_ARRIVAL_INLAND
            , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1 )
        SELECT T.DIVISION_ID, T.PLAN_START_YYYYMMDD, T.PLAN_TYPE, T.SEQ, V_VER, T.ITEM_ID, T.NICK_NAME, T.FROM_SITE, T.TO_SITE
             , T.TRANSPORT_MODE_LINE, REPLACE(T.INCOTERMS, ' ', '') AS INCOTERMS, T.OPERATION_GROUP, T.BOD_ID
             , T.M1, T.M2, T.M3, T.M4, T.M5, T.M6, T.M7, T.M8, T.M9, T.M10, T.M11, T.M12
             , T.DATA_RANGE, T.FROM_CITY, T.TO_CITY, T.DEPART_DAYS, T.LT_DEPARTURE_INLAND, T.LT_WAIT_SHIPPING
             , T.LT_VOYAGE, T.LT_LAY_OFF_CLEARANCE, T.LT_ARRIVAL_INLAND
             , T.CREATED_BY, T.CREATION_DATE, T.UPDATED_BY, T.UPDATED_DATE,
               /* PJ20216891 : 오류 및 기능 개선건 대응 (셀환산수량추가) */
               TO_CHAR(T.CELL_CONV_QTY) AS ATTRIBUTE1
          FROM ( SELECT A.DIVISION_ID, A.PLAN_START_YYYYMMDD, RTRIM(A.PLAN_TYPE) AS PLAN_TYPE, A.SEQ
                      , RTRIM(A.ITEM_ID) AS ITEM_ID, A.NICK_NAME, RTRIM(A.FROM_SITE) AS FROM_SITE
                      , RTRIM(A.TO_SITE) AS TO_SITE, RTRIM(A.TRANSPORT_MODE_LINE) AS TRANSPORT_MODE_LINE, A.INCOTERMS
                      , MAX(A.OPERATION_GROUP) AS OPERATION_GROUP, MAX(A.BOD_ID) AS BOD_ID
                      , NVL(SUM(CASE WHEN A.YYYYMM = TO_CHAR(ADD_MONTHS(V_PLAN_START_DATE, 1), 'YYYYMM') THEN A.SUMQTY END), 0) M1
                      , NVL(SUM(CASE WHEN A.YYYYMM = TO_CHAR(ADD_MONTHS(V_PLAN_START_DATE, 2), 'YYYYMM') THEN A.SUMQTY END), 0) M2
                      , NVL(SUM(CASE WHEN A.YYYYMM = TO_CHAR(ADD_MONTHS(V_PLAN_START_DATE, 3), 'YYYYMM') THEN A.SUMQTY END), 0) M3
                      , NVL(SUM(CASE WHEN A.YYYYMM = TO_CHAR(ADD_MONTHS(V_PLAN_START_DATE, 4), 'YYYYMM') THEN A.SUMQTY END), 0) M4
                      , NVL(SUM(CASE WHEN A.YYYYMM = TO_CHAR(ADD_MONTHS(V_PLAN_START_DATE, 5), 'YYYYMM') THEN A.SUMQTY END), 0) M5
                      , NVL(SUM(CASE WHEN A.YYYYMM = TO_CHAR(ADD_MONTHS(V_PLAN_START_DATE, 6), 'YYYYMM') THEN A.SUMQTY END), 0) M6
                      , NVL(SUM(CASE WHEN A.YYYYMM = TO_CHAR(ADD_MONTHS(V_PLAN_START_DATE, 7), 'YYYYMM') THEN A.SUMQTY END), 0) M7
                      , NVL(SUM(CASE WHEN A.YYYYMM = TO_CHAR(ADD_MONTHS(V_PLAN_START_DATE, 8), 'YYYYMM') THEN A.SUMQTY END), 0) M8
                      , NVL(SUM(CASE WHEN A.YYYYMM = TO_CHAR(ADD_MONTHS(V_PLAN_START_DATE, 9), 'YYYYMM') THEN A.SUMQTY END), 0) M9
                      , NVL(SUM(CASE WHEN A.YYYYMM = TO_CHAR(ADD_MONTHS(V_PLAN_START_DATE, 10), 'YYYYMM') THEN A.SUMQTY END), 0) M10
                      , NVL(SUM(CASE WHEN A.YYYYMM = TO_CHAR(ADD_MONTHS(V_PLAN_START_DATE, 11), 'YYYYMM') THEN A.SUMQTY END), 0) M11
                      , NVL(SUM(CASE WHEN A.YYYYMM = TO_CHAR(ADD_MONTHS(V_PLAN_START_DATE, 12), 'YYYYMM') THEN A.SUMQTY END), 0) M12
                      , MAX(P_MONTH) AS DATA_RANGE, MAX(A.FROM_CITY) AS FROM_CITY, MAX(A.TO_CITY) AS TO_CITY
                      , MAX(B.DEPART_DAYS) AS DEPART_DAYS, MAX(B.LT_DEPARTURE_INLAND) AS LT_DEPARTURE_INLAND
                      , MAX(B.LT_WAIT_SHIPPING) AS LT_WAIT_SHIPPING, MAX(B.LT_VOYAGE) AS LT_VOYAGE
                      , MAX(B.LT_LAY_OFF_CLEARANCE) AS LT_LAY_OFF_CLEARANCE, MAX(B.LT_ARRIVAL_INLAND) AS LT_ARRIVAL_INLAND
                      , NVL(MAX(A.CELL_CONV_QTY), 1) AS CELL_CONV_QTY
                      , P_CREATED_BY AS CREATED_BY, SYSDATE AS CREATION_DATE, P_CREATED_BY AS UPDATED_BY, SYSDATE AS UPDATED_DATE
                   FROM GT_DIO_REPORT1_3 A
                      , GT_DIO_BOD_LT B   /* temp테이블 참조 변경 */
                  WHERE B.BOD_ID(+) = A.BOD_ID
                  GROUP BY A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.ITEM_ID, A.NICK_NAME
                      , A.TRANSPORT_MODE_LINE, A.INCOTERMS, A.FROM_SITE, A.TO_SITE ) T;

        /* --------------------------------------------------------------------------------------- */
        /* DIO_REPORT 생성용 FG 정보 처리 (#REPORT1_3_1 : 월 전체 SUM) */
        /* --------------------------------------------------------------------------------------- */
        INSERT INTO GT_DIO_REPORT1_3_1
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, PLANT_ID, FROM_PLANT_ID, FROM_SITE_TYPE, FROM_CITY
            , TO_PLANT_ID, TO_SITE_TYPE, TO_CITY, SAME_CITY_FLAG, ITEM_ID, CELL_ITEM_ID, BIZ_TYPE, INCOTERMS
            , OPERATION_GROUP, FROM_SITE, TO_SITE, BOD_ID, TRANSPORT_MODE_LINE, MEASURE, MONTH_DIFF, NICK_NAME
            , MATERIAL_CLASS_NAME, TYPE, END_CUSTOMER, SCM_SITE_ID, SOLDTO_CUSTOMER, SITE_TYPE
            , TO_BOH_QTY, SUMQTY, CELL_CONV_QTY, AGING_LT, SUMQTY_CELL_CONV )
        SELECT A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.PLANT_ID, A.FROM_PLANT_ID, A.FROM_SITE_TYPE, A.FROM_CITY
             , A.TO_PLANT_ID, A.TO_SITE_TYPE, A.TO_CITY, A.SAME_CITY_FLAG, A.ITEM_ID, A.CELL_ITEM_ID, A.BIZ_TYPE, A.INCOTERMS
             , A.OPERATION_GROUP, A.FROM_SITE, A.TO_SITE, A.BOD_ID, A.TRANSPORT_MODE_LINE, A.MEASURE, A.MONTH_DIFF, A.NICK_NAME
             , A.MATERIAL_CLASS_NAME, A.TYPE, A.END_CUSTOMER, A.SCM_SITE_ID, A.SOLDTO_CUSTOMER, A.SITE_TYPE
             , MAX(A.TO_BOH_QTY) AS TO_BOH_QTY, SUM(A.SUMQTY) AS SUMQTY, MAX(A.CELL_CONV_QTY) AS CELL_CONV_QTY
             , MAX(A.AGING_LT) AS AGING_LT, SUM(A.SUMQTY_CELL_CONV) AS SUMQTY_CELL_CONV
          FROM GT_DIO_REPORT1_3 A
         GROUP BY A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.PLANT_ID, A.FROM_PLANT_ID, A.FROM_SITE_TYPE, A.FROM_CITY
             , A.TO_PLANT_ID, A.TO_SITE_TYPE, A.TO_CITY, A.SAME_CITY_FLAG, A.ITEM_ID, A.CELL_ITEM_ID, A.BIZ_TYPE, A.INCOTERMS, A.OPERATION_GROUP
             , A.FROM_SITE, A.TO_SITE, A.BOD_ID, A.TRANSPORT_MODE_LINE, A.MEASURE, A.MONTH_DIFF, A.NICK_NAME, A.MATERIAL_CLASS_NAME, A.TYPE
             , A.END_CUSTOMER, A.SCM_SITE_ID, A.SOLDTO_CUSTOMER, A.SITE_TYPE;

        /* Item 이 다른 경우 처리 (#REPORT1_4) */
        INSERT INTO GT_DIO_REPORT1_4
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, PLANT_ID, FROM_PLANT_ID, FROM_SITE_TYPE, FROM_CITY
            , TO_PLANT_ID, TO_SITE_TYPE, TO_CITY, SAME_CITY_FLAG, ITEM_ID, CELL_ITEM_ID, BIZ_TYPE, INCOTERMS
            , OPERATION_GROUP, FROM_SITE, TO_SITE, BOD_ID, TRANSPORT_MODE_LINE, MEASURE, MONTH_DIFF, NICK_NAME
            , MATERIAL_CLASS_NAME, TYPE, END_CUSTOMER, SCM_SITE_ID, SOLDTO_CUSTOMER, SITE_TYPE
            , TO_BOH_QTY, SUMQTY, CELL_CONV_QTY, AGING_LT, SUMQTY_CELL_CONV )
        SELECT A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.PLANT_ID, A.FROM_PLANT_ID, A.FROM_SITE_TYPE, A.FROM_CITY
             , A.TO_PLANT_ID, A.TO_SITE_TYPE, A.TO_CITY, A.SAME_CITY_FLAG, MAX(A.ITEM_ID) AS ITEM_ID, A.CELL_ITEM_ID, A.BIZ_TYPE, A.INCOTERMS
             , A.OPERATION_GROUP, A.FROM_SITE, A.TO_SITE, A.BOD_ID, A.TRANSPORT_MODE_LINE, A.MEASURE, A.MONTH_DIFF, A.NICK_NAME
             , A.MATERIAL_CLASS_NAME, A.TYPE, A.END_CUSTOMER, A.SCM_SITE_ID, A.SOLDTO_CUSTOMER, A.SITE_TYPE
             , SUM(A.TO_BOH_QTY) AS TO_BOH_QTY, SUM(A.SUMQTY) AS SUMQTY, MAX(A.CELL_CONV_QTY) AS CELL_CONV_QTY
             , MAX(A.AGING_LT) AS AGING_LT, SUM(A.SUMQTY_CELL_CONV) AS SUMQTY_CELL_CONV
          FROM GT_DIO_REPORT1_3_1 A
         GROUP BY A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.PLANT_ID, A.FROM_PLANT_ID, A.FROM_SITE_TYPE, A.FROM_CITY
             , A.TO_PLANT_ID, A.TO_SITE_TYPE, A.TO_CITY, A.SAME_CITY_FLAG, A.CELL_ITEM_ID, A.BIZ_TYPE, A.INCOTERMS, A.OPERATION_GROUP
             , A.FROM_SITE, A.TO_SITE, A.BOD_ID, A.TRANSPORT_MODE_LINE, A.MEASURE, A.MONTH_DIFF, A.NICK_NAME, A.MATERIAL_CLASS_NAME, A.TYPE
             , A.END_CUSTOMER, A.SCM_SITE_ID, A.SOLDTO_CUSTOMER, A.SITE_TYPE;

        /* #REPORT2 (FG 정보만 처리) */
        INSERT INTO GT_DIO_REPORT2
            ( DIVISION_ID, PLAN_START_YYYYMMDD, MONTH_DIFF, PLAN_TYPE, SEQ, NICK_NAME, SITE_TYPE, PLANT_ID, TO_PLANT_ID
            , FROM_SITE, FROM_SITE_DESCRIPTION, TO_SITE, FROM_CITY, TO_CITY, TO_BOH_QTY, BOD_ID, TRANSPORT_MODE_LINE
            , OPERATION_GROUP, MEASURE, SHIP_PLAN_QTY, END_CUSTOMER, PRODUCTION_TYPE, EXTRA_SPEC, ITEM_ID, CELL_ITEM_ID
            , BIZ_TYPE, INCOTERMS, CELL_AGING_LT, SAME_CITY_FLAG, CELL_EOL_SHIPPING_LOT, PACK_INCOMMING, PACK_OPERATION_LT
            , SHIPMENT_CELL_INSPECTION_LOAD, SHIPMENT_CELL_INSPECTION_WAITING, SHIPMENT_PACK_INSPECTION_LOAD, SHIPMENT_PACK_INSPECTION_WAITING
            , DNI_CELL_DEPARTURE_DAYS, DNI_CELL_DEPARTURE_INLAND, DNI_CELL_WAITING_FOR_SHIPPING, DNI_CELL_VOYAGE
            , DNI_CELL_LAY_OFF_CUSTOMS_CLEARANCE, DNI_CELL_ARRIVAL_INLAND, PRE_INSPECTION_CELL, PRE_INSPECTION_PACK
            , VMI_CELL, VMI_PACK, FOREIGN_CORP, RACK_BIZ, DEPARTURE_INTRANSIT_VMI, SAFETY_STOCK_CELL, SAFETY_STOCK_PACK
            , OTHER_STOCK_CELL, OTHER_STOCK_PACK, PRODUCTION_CYCLE_CELL, PRODUCTION_CYCLE_PACK, STANDARD_DIO
            , ASSEMBLY_QTY, ASSEMBLY_TYPE_RATIO, ASSEMBLY_TOTAL_RATIO, WEIGHT_DIO, SUMQTY )
        SELECT A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.MONTH_DIFF, A.PLAN_TYPE, A.SEQ, A.NICK_NAME, A.SITE_TYPE, A.PLANT_ID, A.TO_PLANT_ID
             , A.FROM_SITE
             , ( SELECT MAX(S.SITE_DESCRIPTION) FROM GT_DIO_SCM_MST_SITE S
                  WHERE A.DIVISION_ID = S.DIVISION_ID AND A.PLANT_ID = S.LOGISTIC_PLANT_ID AND A.OPERATION_GROUP = S.OPERATION_GROUP ) AS FROM_SITE_DESCRIPTION
             , A.TO_SITE, A.FROM_CITY, A.TO_CITY, A.TO_BOH_QTY, A.BOD_ID, A.TRANSPORT_MODE_LINE, A.OPERATION_GROUP, A.MEASURE
             , NULL AS SHIP_PLAN_QTY
             , CASE WHEN A.DIVISION_ID = '40' THEN A.SOLDTO_CUSTOMER ELSE A.END_CUSTOMER END AS END_CUSTOMER
             , A.MATERIAL_CLASS_NAME AS PRODUCTION_TYPE, A.TYPE AS EXTRA_SPEC, A.ITEM_ID, A.CELL_ITEM_ID
             , SUBSTR(A.BIZ_TYPE, 1, 60) AS BIZ_TYPE, SUBSTR(A.INCOTERMS, 1, 60) AS INCOTERMS, A.AGING_LT AS CELL_AGING_LT, A.SAME_CITY_FLAG
             , K.CELL_EOL_SHIPPING_LOT, K.PACK_INCOMMING, K.PACK_OPERATION_LT, K.SHIPMENT_CELL_INSPECTION_LOAD
             , K.SHIPMENT_CELL_INSPECTION_WAITING, K.SHIPMENT_PACK_INSPECTION_LOAD, K.SHIPMENT_PACK_INSPECTION_WAITING,
               /* Semi 용 : Pack Biz 존재시 Semi 정보 표시용 : 뒤에서 Update */
               0, 0, 0, 0, 0, 0
             , CASE WHEN A.BIZ_TYPE = 'CELL' THEN L.LT_DAY END AS PRE_INSPECTION_CELL
             , CASE WHEN A.BIZ_TYPE = 'PACK' THEN L.LT_DAY END AS PRE_INSPECTION_PACK
             , K.VMI_CELL, K.VMI_PACK, K.FOREIGN_CORP, K.RACK_BIZ, NULL AS DEPARTURE_INTRANSIT_VMI
             , K.SAFETY_STOCK_CELL, K.SAFETY_STOCK_PACK, K.OTHER_STOCK_CELL, K.OTHER_STOCK_PACK
             , NULL, NULL, NULL, NULL, NULL, NULL, NULL, A.SUMQTY
          FROM GT_DIO_REPORT1_4 A
             , GT_DIO_LAST_PLAN_KEYIN K
             , GT_DIO_OPERATION_LT L
         WHERE K.DIVISION_ID(+) = A.DIVISION_ID AND K.PLAN_TYPE(+) = A.PLAN_TYPE AND K.NICK_NAME(+) = A.NICK_NAME
           AND L.DIVISION_ID(+) = A.DIVISION_ID AND L.SCM_SITE_ID(+) = A.FROM_SITE AND L.ITEM_ID(+) = A.ITEM_ID
           AND A.SITE_TYPE = 'SALES';   /* FG 정보만 처리 */

        /* #MAX_SHIP_PLAN (nick_name별 cell 환산 수량 비중이 높은 Plant/end_customer 1건) */

        INSERT INTO GT_DIO_MAX_SHIP_PLAN (RANK_SEQ, NICK_NAME, PLANT_ID, END_CUSTOMER, ITEM_ID, SUMQTY_CELL_CONV)
        SELECT RANK_SEQ, NICK_NAME, PLANT_ID, END_CUSTOMER, ITEM_ID, SUMQTY_CELL_CONV
          FROM ( SELECT ROW_NUMBER() OVER (PARTITION BY NICK_NAME ORDER BY TRUNC(SUMQTY_CELL_CONV) DESC) AS RANK_SEQ
                      , NICK_NAME, PLANT_ID, END_CUSTOMER, ITEM_ID, SUMQTY_CELL_CONV
                   FROM ( SELECT NICK_NAME, PLANT_ID, END_CUSTOMER, MAX(ITEM_ID) AS ITEM_ID, SUM(SUMQTY_CELL_CONV) AS SUMQTY_CELL_CONV
                            FROM GT_DIO_REPORT1_4
                           WHERE SITE_TYPE = 'SALES'
                           GROUP BY NICK_NAME, PLANT_ID, END_CUSTOMER ) S ) A
         WHERE A.RANK_SEQ = 1;

        /* BIZ TYPE이 여러개 일때 한 칼럼에 보여주기 위한 Temp (#TMP_REPORT_BIZ_TYPE) */
        INSERT INTO GT_DIO_TMP_BIZ_TYPE (DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, PLANT_ID, NICK_NAME, BIZ_TYPE)
        SELECT DISTINCT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, PLANT_ID, NICK_NAME, BIZ_TYPE
          FROM GT_DIO_REPORT2;

        /* INCOTERMS가 여러개 일때 한 칼럼에 보여주기 위한 Temp (#TMP_REPORT_INCOTERMS) */
        INSERT INTO GT_DIO_TMP_INCOTERMS (DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, PLANT_ID, NICK_NAME, INCOTERMS)
        SELECT DISTINCT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, PLANT_ID, NICK_NAME, INCOTERMS
          FROM GT_DIO_REPORT2
         WHERE SAME_CITY_FLAG = 'N' AND INCOTERMS != '-';

        /* From / To가 다른 City 인 Semi 정보 (#TMP_REPORT_CELL_PLANT_SITE_SEMI -> GT_DIO_TMP_CELL_PLANT_SEMI) */
        INSERT INTO GT_DIO_TMP_CELL_PLANT_SEMI (DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, PLANT_ID, NICK_NAME)
        SELECT DISTINCT A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.PLANT_ID, A.NICK_NAME
          FROM GT_DIO_REPORT1_3 A
         WHERE A.SAME_CITY_FLAG = 'N' AND A.SITE_TYPE = 'PLANT';

        /* --------------------------------------------------------------------------------------- */
        /* DIO_REPORT FG 정보 처리 */

        /* --------------------------------------------------------------------------------------- */
        DELETE FROM SCP_ANL_DIO_REPORT
         WHERE 1 = 1
           AND DIVISION_ID         = P_DIVISION_ID
           AND PLAN_TYPE           = V_PLAN_TYPE
           AND MEASURE             = 'SHIP_PLAN'
           AND PLAN_START_YYYYMMDD  = P_PLAN_START_YYYYMMDD
           AND SEQ                 = P_SEQ
           AND VER                 = V_VER;

        INSERT INTO SCP_ANL_DIO_REPORT
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, VER, NICK_NAME, PLANT_ID, CELL_PLANT_SITE, FROM_SITE
            , FROM_SITE_DESCRIPTION, TO_SITE, TO_BOH_QTY, BOD_ID, TRANSPORT_MODE_LINE, MEASURE, SHIP_PLAN_QTY
            , END_CUSTOMER, PRODUCTION_TYPE, EXTRA_SPEC, ITEM_ID, CELL_ITEM_ID, BIZ_TYPE, INCOTERMS, CELL_AGING_LT
            , CELL_EOL_SHIPPING_LOT, PACK_INCOMMING, PACK_OPERATION_LT, SHIPMENT_CELL_INSPECTION_LOAD
            , SHIPMENT_CELL_INSPECTION_WAITING, SHIPMENT_PACK_INSPECTION_LOAD, SHIPMENT_PACK_INSPECTION_WAITING
            , DNI_CELL_DEPARTURE_DAYS, DNI_CELL_DEPARTURE_INLAND, DNI_CELL_WAITING_FOR_SHIPPING, DNI_CELL_VOYAGE
            , DNI_CELL_LAY_OFF_CUSTOMS_CLEARANCE, DNI_CELL_ARRIVAL_INLAND, DNI_PACK_DEPARTURE_DAYS, DNI_PACK_DEPARTURE_INLAND
            , DNI_PACK_WAITING_FOR_SHIPPING, DNI_PACK_VOYAGE, DNI_PACK_LAY_OFF_CUSTOMS_CLEARANCE, DNI_PACK_ARRIVAL_INLAND
            , PRE_INSPECTION_CELL, PRE_INSPECTION_PACK, VMI_CELL, VMI_PACK, FOREIGN_CORP, RACK_BIZ, DEPARTURE_INTRANSIT_VMI
            , SAFETY_STOCK_CELL, SAFETY_STOCK_PACK, OTHER_STOCK_CELL, OTHER_STOCK_PACK, PRODUCTION_CYCLE_CELL
            , PRODUCTION_CYCLE_PACK, STANDARD_DIO, ASSEMBLY_QTY, ASSEMBLY_TYPE_RATIO, ASSEMBLY_TOTAL_RATIO, WEIGHT_DIO
            , SHIP_PLAN_WEIGHT, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
        SELECT T1.DIVISION_ID, T1.PLAN_START_YYYYMMDD, T1.PLAN_TYPE, T1.SEQ, V_VER, T1.NICK_NAME, T1.PLANT_ID, T1.CELL_PLANT_SITE
             , T1.FROM_SITE, T1.FROM_SITE_DESCRIPTION, T1.TO_SITE, T1.TO_BOH_QTY, T1.BOD_ID, T1.TRANSPORT_MODE_LINE, T1.MEASURE
             , T1.SHIP_PLAN_QTY, NVL(T1.END_CUSTOMER, '-'), T1.PRODUCTION_TYPE, T1.EXTRA_SPEC, T1.ITEM_ID, T1.CELL_ITEM_ID
             , T1.BIZ_TYPE, T1.INCOTERMS, T1.CELL_AGING_LT, T1.CELL_EOL_SHIPPING_LOT, T1.PACK_INCOMMING, T1.PACK_OPERATION_LT
             , T1.SHIPMENT_CELL_INSPECTION_LOAD, T1.SHIPMENT_CELL_INSPECTION_WAITING, T1.SHIPMENT_PACK_INSPECTION_LOAD
             , T1.SHIPMENT_PACK_INSPECTION_WAITING, T1.DNI_CELL_DEPARTURE_DAYS, T1.DNI_CELL_DEPARTURE_INLAND
             , T1.DNI_CELL_WAITING_FOR_SHIPPING, T1.DNI_CELL_VOYAGE, T1.DNI_CELL_LAY_OFF_CUSTOMS_CLEARANCE, T1.DNI_CELL_ARRIVAL_INLAND
             , T1.DNI_PACK_DEPARTURE_DAYS, T1.DNI_PACK_DEPARTURE_INLAND, T1.DNI_PACK_WAITING_FOR_SHIPPING, T1.DNI_PACK_VOYAGE
             , T1.DNI_PACK_LAY_OFF_CUSTOMS_CLEARANCE, T1.DNI_PACK_ARRIVAL_INLAND, T1.PRE_INSPECTION_CELL, T1.PRE_INSPECTION_PACK
             , T1.VMI_CELL, T1.VMI_PACK, T1.FOREIGN_CORP, T1.RACK_BIZ, T1.DEPARTURE_INTRANSIT_VMI, T1.SAFETY_STOCK_CELL
             , T1.SAFETY_STOCK_PACK, T1.OTHER_STOCK_CELL, T1.OTHER_STOCK_PACK, T1.PRODUCTION_CYCLE_CELL, T1.PRODUCTION_CYCLE_PACK
             , T1.STANDARD_DIO, T1.ASSEMBLY_QTY, T1.ASSEMBLY_TYPE_RATIO, T1.ASSEMBLY_TOTAL_RATIO, T1.WEIGHT_DIO
             , T1.SHIP_PLAN_WEIGHT, T1.CREATED_BY, T1.CREATION_DATE, T1.LAST_UPDATED_BY, T1.LAST_UPDATE_DATE
          FROM ( SELECT A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.NICK_NAME, A.PLANT_ID
                      , MAX(A.END_CUSTOMER) AS END_CUSTOMER
                      , REPLACE( ( SELECT LISTAGG(X1.PLANT_ID, ',') WITHIN GROUP (ORDER BY X1.PLANT_ID)
                                     FROM GT_DIO_TMP_CELL_PLANT_SEMI X1 WHERE X1.NICK_NAME = A.NICK_NAME ), ' ', '') AS CELL_PLANT_SITE
                      , MAX(A.FROM_SITE) AS FROM_SITE, MAX(A.FROM_SITE_DESCRIPTION) AS FROM_SITE_DESCRIPTION
                      , MAX(A.TO_SITE) AS TO_SITE, MAX(A.TO_BOH_QTY) AS TO_BOH_QTY, MAX(A.BOD_ID) AS BOD_ID
                      , MAX(A.TRANSPORT_MODE_LINE) AS TRANSPORT_MODE_LINE, MAX(A.MEASURE) AS MEASURE, MAX(A.SHIP_PLAN_QTY) AS SHIP_PLAN_QTY
                      , MAX(A.PRODUCTION_TYPE) AS PRODUCTION_TYPE, MAX(A.EXTRA_SPEC) AS EXTRA_SPEC, MAX(B.ITEM_ID) AS ITEM_ID
                      , MAX(A.CELL_ITEM_ID) AS CELL_ITEM_ID
                      , REPLACE( ( SELECT LISTAGG(X1.BIZ_TYPE, ',') WITHIN GROUP (ORDER BY X1.BIZ_TYPE)
                                     FROM GT_DIO_TMP_BIZ_TYPE X1 WHERE X1.PLANT_ID = A.PLANT_ID AND X1.NICK_NAME = A.NICK_NAME ), ' ', '') AS BIZ_TYPE
                      , REPLACE( ( SELECT LISTAGG(X2.INCOTERMS, ',') WITHIN GROUP (ORDER BY X2.INCOTERMS)
                                     FROM GT_DIO_TMP_INCOTERMS X2 WHERE X2.PLANT_ID = A.PLANT_ID AND X2.NICK_NAME = A.NICK_NAME ), ' ', '') AS INCOTERMS
                      , MAX(A.CELL_AGING_LT) AS CELL_AGING_LT, MAX(A.CELL_EOL_SHIPPING_LOT) AS CELL_EOL_SHIPPING_LOT
                      , MAX(A.PACK_INCOMMING) AS PACK_INCOMMING, MAX(A.PACK_OPERATION_LT) AS PACK_OPERATION_LT
                      , MAX(A.SHIPMENT_CELL_INSPECTION_LOAD) AS SHIPMENT_CELL_INSPECTION_LOAD
                      , MAX(A.SHIPMENT_CELL_INSPECTION_WAITING) AS SHIPMENT_CELL_INSPECTION_WAITING
                      , MAX(A.SHIPMENT_PACK_INSPECTION_LOAD) AS SHIPMENT_PACK_INSPECTION_LOAD
                      , MAX(A.SHIPMENT_PACK_INSPECTION_WAITING) AS SHIPMENT_PACK_INSPECTION_WAITING,
                        /* SEMI */
                        NVL(MAX(R2.DEPART_DAYS), 0) AS DNI_CELL_DEPARTURE_DAYS
                      , NVL(MAX(R2.LT_DEPARTURE_INLAND), 0) AS DNI_CELL_DEPARTURE_INLAND
                      , NVL(MAX(R2.LT_WAIT_SHIPPING), 0) AS DNI_CELL_WAITING_FOR_SHIPPING
                      , NVL(MAX(R2.LT_VOYAGE), 0) AS DNI_CELL_VOYAGE
                      , NVL(MAX(R2.LT_LAY_OFF_CLEARANCE), 0) AS DNI_CELL_LAY_OFF_CUSTOMS_CLEARANCE
                      , NVL(MAX(R2.LT_ARRIVAL_INLAND), 0) AS DNI_CELL_ARRIVAL_INLAND,
                        /* FG */
                        NVL(MAX(R.DEPART_DAYS), 0) AS DNI_PACK_DEPARTURE_DAYS
                      , NVL(MAX(R.INCOTERMS_LT_DEPARTURE_INLAND), 0) AS DNI_PACK_DEPARTURE_INLAND
                      , NVL(MAX(R.INCOTERMS_LT_WAIT_SHIPPING), 0) AS DNI_PACK_WAITING_FOR_SHIPPING
                      , NVL(MAX(R.INCOTERMS_LT_VOYAGE), 0) AS DNI_PACK_VOYAGE
                      , NVL(MAX(R.INCOTERMS_LT_LAY_OFF_CLEARANCE), 0) AS DNI_PACK_LAY_OFF_CUSTOMS_CLEARANCE
                      , NVL(MAX(R.INCOTERMS_LT_ARRIVAL_INLAND), 0) AS DNI_PACK_ARRIVAL_INLAND
                      , MAX(A.PRE_INSPECTION_CELL) AS PRE_INSPECTION_CELL, MAX(A.PRE_INSPECTION_PACK) AS PRE_INSPECTION_PACK
                      , MAX(A.VMI_CELL) AS VMI_CELL, MAX(A.VMI_PACK) AS VMI_PACK, MAX(A.FOREIGN_CORP) AS FOREIGN_CORP
                      , MAX(A.RACK_BIZ) AS RACK_BIZ, MAX(A.DEPARTURE_INTRANSIT_VMI) AS DEPARTURE_INTRANSIT_VMI
                      , MAX(A.SAFETY_STOCK_CELL) AS SAFETY_STOCK_CELL, MAX(A.SAFETY_STOCK_PACK) AS SAFETY_STOCK_PACK
                      , MAX(A.OTHER_STOCK_CELL) AS OTHER_STOCK_CELL, MAX(A.OTHER_STOCK_PACK) AS OTHER_STOCK_PACK
                      , MAX(A.PRODUCTION_CYCLE_CELL) AS PRODUCTION_CYCLE_CELL, MAX(A.PRODUCTION_CYCLE_PACK) AS PRODUCTION_CYCLE_PACK
                      , MAX(A.STANDARD_DIO) AS STANDARD_DIO, MAX(A.ASSEMBLY_QTY) AS ASSEMBLY_QTY
                      , MAX(A.ASSEMBLY_TYPE_RATIO) AS ASSEMBLY_TYPE_RATIO, MAX(A.ASSEMBLY_TOTAL_RATIO) AS ASSEMBLY_TOTAL_RATIO
                      , MAX(A.WEIGHT_DIO) AS WEIGHT_DIO, MAX(R.SITE_WEIGHT) AS SHIP_PLAN_WEIGHT
                      , P_CREATED_BY AS CREATED_BY, SYSDATE AS CREATION_DATE, P_CREATED_BY AS LAST_UPDATED_BY, SYSDATE AS LAST_UPDATE_DATE
                   FROM GT_DIO_REPORT2 A
                      , GT_DIO_MAX_SHIP_PLAN B
                      , GT_DIO_DEPARTURE_LT R    /* FG */
                      , GT_DIO_DEPARTURE_LT R2   /* SEMI */
                  WHERE 1 = 1
                    AND A.NICK_NAME = B.NICK_NAME AND A.PLANT_ID = B.PLANT_ID AND A.END_CUSTOMER = B.END_CUSTOMER
                    AND R.NICK_NAME(+) = A.NICK_NAME AND R.SITE_TYPE(+) = 'SALES'
                    AND R2.NICK_NAME(+) = A.NICK_NAME AND R2.SITE_TYPE(+) = 'PLANT'
                    AND A.MEASURE = 'SHIP_PLAN'
                    AND A.SITE_TYPE = 'SALES'
                    AND A.DIVISION_ID = P_DIVISION_ID
                    AND A.PLAN_TYPE = V_PLAN_TYPE
                    AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                    AND A.SEQ = P_SEQ
                    AND A.SITE_TYPE IS NOT NULL   /* 조건 추가 */
                  GROUP BY A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.PLANT_ID, A.NICK_NAME ) T1;

        /* --------------------------------------------------------------------------------------- */
        /* DIO_REPORT 이력 저장 */
        /* --------------------------------------------------------------------------------------- */
        DELETE FROM SCP_ANL_DIO_REPORT_H
         WHERE 1 = 1
           AND PLAN_TYPE           = V_PLAN_TYPE
           AND MEASURE             = 'SHIP_PLAN'
           AND DIVISION_ID         = P_DIVISION_ID
           AND PLAN_START_YYYYMMDD  = P_PLAN_START_YYYYMMDD
           AND SEQ                 = P_SEQ
           AND VER                 = V_VER
           AND VERSION             = 0;

        INSERT INTO SCP_ANL_DIO_REPORT_H
            ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, VER, NICK_NAME, PLANT_ID, VERSION, FROM_SITE_DESCRIPTION
            , TO_SITE, TO_BOH_QTY, BOD_ID, TRANSPORT_MODE_LINE, MEASURE, SHIP_PLAN_QTY, END_CUSTOMER, PRODUCTION_TYPE
            , EXTRA_SPEC, ITEM_ID, CELL_ITEM_ID, BIZ_TYPE, INCOTERMS, CELL_AGING_LT, CELL_EOL_SHIPPING_LOT, PACK_INCOMMING
            , PACK_OPERATION_LT, SHIPMENT_CELL_INSPECTION_LOAD, SHIPMENT_CELL_INSPECTION_WAITING, SHIPMENT_PACK_INSPECTION_LOAD
            , SHIPMENT_PACK_INSPECTION_WAITING, DNI_CELL_DEPARTURE_DAYS, DNI_CELL_DEPARTURE_INLAND, DNI_CELL_WAITING_FOR_SHIPPING
            , DNI_CELL_VOYAGE, DNI_CELL_LAY_OFF_CUSTOMS_CLEARANCE, DNI_CELL_ARRIVAL_INLAND, DNI_PACK_DEPARTURE_DAYS
            , DNI_PACK_DEPARTURE_INLAND, DNI_PACK_WAITING_FOR_SHIPPING, DNI_PACK_VOYAGE, DNI_PACK_LAY_OFF_CUSTOMS_CLEARANCE
            , DNI_PACK_ARRIVAL_INLAND, PRE_INSPECTION_CELL, PRE_INSPECTION_PACK, VMI_CELL, VMI_PACK, FOREIGN_CORP, RACK_BIZ
            , DEPARTURE_INTRANSIT_VMI, SAFETY_STOCK_CELL, SAFETY_STOCK_PACK, OTHER_STOCK_CELL, OTHER_STOCK_PACK
            , PRODUCTION_CYCLE_CELL, PRODUCTION_CYCLE_PACK, STANDARD_DIO, ASSEMBLY_QTY, ASSEMBLY_TYPE_RATIO, ASSEMBLY_TOTAL_RATIO
            , WEIGHT_DIO, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
        SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, V_VER, NICK_NAME, PLANT_ID, 0, FROM_SITE_DESCRIPTION
             , TO_SITE, TO_BOH_QTY, BOD_ID, TRANSPORT_MODE_LINE, MEASURE, SHIP_PLAN_QTY, END_CUSTOMER, PRODUCTION_TYPE
             , EXTRA_SPEC, ITEM_ID, CELL_ITEM_ID, BIZ_TYPE, INCOTERMS, CELL_AGING_LT, CELL_EOL_SHIPPING_LOT, PACK_INCOMMING
             , PACK_OPERATION_LT, SHIPMENT_CELL_INSPECTION_LOAD, SHIPMENT_CELL_INSPECTION_WAITING, SHIPMENT_PACK_INSPECTION_LOAD
             , SHIPMENT_PACK_INSPECTION_WAITING, DNI_CELL_DEPARTURE_DAYS, DNI_CELL_DEPARTURE_INLAND, DNI_CELL_WAITING_FOR_SHIPPING
             , DNI_CELL_VOYAGE, DNI_CELL_LAY_OFF_CUSTOMS_CLEARANCE, DNI_CELL_ARRIVAL_INLAND, DNI_PACK_DEPARTURE_DAYS
             , DNI_PACK_DEPARTURE_INLAND, DNI_PACK_WAITING_FOR_SHIPPING, DNI_PACK_VOYAGE, DNI_PACK_LAY_OFF_CUSTOMS_CLEARANCE
             , DNI_PACK_ARRIVAL_INLAND, PRE_INSPECTION_CELL, PRE_INSPECTION_PACK, VMI_CELL, VMI_PACK, FOREIGN_CORP, RACK_BIZ
             , DEPARTURE_INTRANSIT_VMI, SAFETY_STOCK_CELL, SAFETY_STOCK_PACK, OTHER_STOCK_CELL, OTHER_STOCK_PACK
             , PRODUCTION_CYCLE_CELL, PRODUCTION_CYCLE_PACK, STANDARD_DIO, ASSEMBLY_QTY, ASSEMBLY_TYPE_RATIO, ASSEMBLY_TOTAL_RATIO
             , WEIGHT_DIO, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
          FROM SCP_ANL_DIO_REPORT
         WHERE DIVISION_ID = P_DIVISION_ID
           AND PLAN_TYPE = V_PLAN_TYPE
           AND MEASURE = 'SHIP_PLAN'
           AND PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND SEQ = P_SEQ
           AND VER = V_VER;

        /* ----------------------------------------------------------------------------- */
        /* 주기 재고 처리 : 주기재고(CYCLE_INVENTORY)는 자동차(81, 81_UC)만 해당함. (PJ20216891) */
        /* ----------------------------------------------------------------------------- */
        SELECT COUNT(*)
          INTO V_TARGET_DIV
          FROM SCM_MST_DIVISION
         WHERE ATTRIBUTE3 = '81'          /* 자동차 */
           AND VALID_YN = 'Y'
           AND DIVISION_ID = P_DIVISION_ID;

        IF V_TARGET_DIV > 0 THEN

            INSERT INTO GT_DIO_CYCLE_INVENTORY1
                ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, PLANT_ID, FROM_SITE, ITEM_ID, CELL_ITEM_ID, BIZ_TYPE
                , INCOTERMS, OPERATION_GROUP, TO_SITE, TO_BOH_QTY, BOD_ID, TRANSPORT_MODE_LINE, MEASURE, YYYYMM, SUMQTY )
            SELECT A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, X.PLANT_ID, A.FROM_SITE, A.ITEM_ID, A.CELL_ITEM_ID
                 , CASE WHEN A.OPERATION_GROUP = 'A' THEN 'CELL' WHEN A.OPERATION_GROUP = 'P' THEN 'PACK' END AS BIZ_TYPE
                 , A.INCOTERMS, A.OPERATION_GROUP, A.TO_SITE, A.TO_BOH_QTY, A.BOD_ID, A.TRANSPORT_MODE_LINE, A.MEASURE
                 , SUBSTR(A.YYYYMMDD, 1, 6) AS YYYYMM, SUM(A.QTY) AS SUMQTY
              FROM SCP_ANL_PSI_GLOBAL A
                 , SCM_MST_SITE X
             WHERE X.DIVISION_ID(+) = A.DIVISION_ID AND X.SCM_SITE_ID(+) = A.FROM_SITE AND X.VALID_YN(+) = 'Y'
               AND A.DIVISION_ID = P_DIVISION_ID
               AND A.PLAN_TYPE = V_PLAN_TYPE
               AND A.MEASURE = 'PRODUCTION'
               AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
               AND A.SEQ = P_SEQ
               AND SUBSTR(A.YYYYMMDD, 1, 6) BETWEEN V_FROM_YYYYMM AND V_TO_YYYYMM
               AND A.QTY <> 0
             GROUP BY A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.OPERATION_GROUP, A.ITEM_ID, A.CELL_ITEM_ID
                 , A.TO_SITE, A.TO_BOH_QTY, A.INCOTERMS, X.PLANT_ID, A.FROM_SITE, A.BOD_ID, A.TRANSPORT_MODE_LINE, A.MEASURE
                 , SUBSTR(A.YYYYMMDD, 1, 6);


            INSERT INTO GT_DIO_CYCLE_INVENTORY2
                ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, PLANT_ID, FROM_SITE, ITEM_ID, CELL_ITEM_ID, BIZ_TYPE
                , INCOTERMS, OPERATION_GROUP, TO_SITE, TO_BOH_QTY, BOD_ID, TRANSPORT_MODE_LINE, MEASURE, YYYYMM, SUMQTY
                , NICK_NAME, MATERIAL_CLASS_NAME, TYPE, CELL_GROUP, PACK_GROUP )
            SELECT A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.PLANT_ID, A.FROM_SITE, A.ITEM_ID, A.CELL_ITEM_ID
                 , A.BIZ_TYPE, A.INCOTERMS, A.OPERATION_GROUP, A.TO_SITE, A.TO_BOH_QTY, A.BOD_ID, A.TRANSPORT_MODE_LINE, A.MEASURE
                 , A.YYYYMM, A.SUMQTY
                 , C.NICK_NAME, C.MATERIAL_CLASS_NAME, C.TYPE, C.CELL_GROUP, C.PACK_GROUP
              FROM GT_DIO_CYCLE_INVENTORY1 A
                 , GT_DIO_PIVOT C
             WHERE C.DIVISION_ID(+) = A.DIVISION_ID AND C.ITEM_ID(+) = A.ITEM_ID;

            DELETE FROM SCP_ANL_DIO_CYCLE_INVENTORY
             WHERE DIVISION_ID = P_DIVISION_ID
               AND PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
               AND SEQ = P_SEQ
               AND VER = V_VER;

            INSERT INTO SCP_ANL_DIO_CYCLE_INVENTORY
                ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, VER, NICK_NAME, PLANT_ID, FROM_SITE, TRANSPORT_MODE_LINE
                , PACK_GROUP, CELL_GROUP, FROM_SITE_DESCRIPTION, OPERATION_GROUP, DATA_RANGE
                , M1, M2, M3, M4, M5, M6, M7, M8, M9, M10, M11, M12, CYCLE, CREATED_BY, CREATION_DATE )
            SELECT A.DIVISION_ID, A.PLAN_START_YYYYMMDD, RTRIM(A.PLAN_TYPE), A.SEQ, V_VER, A.NICK_NAME, RTRIM(A.PLANT_ID)
                 , RTRIM(A.FROM_SITE), RTRIM(A.TRANSPORT_MODE_LINE), MAX(A.PACK_GROUP), MAX(A.CELL_GROUP)
                 , RTRIM(MAX(S.SITE_DESCRIPTION)), RTRIM(A.OPERATION_GROUP), TO_CHAR(P_MONTH)
                 , NVL(SUM(CASE WHEN A.YYYYMM = TO_CHAR(ADD_MONTHS(V_PLAN_START_DATE, 1), 'YYYYMM') THEN A.SUMQTY END), 0) AS M1
                 , NVL(SUM(CASE WHEN A.YYYYMM = TO_CHAR(ADD_MONTHS(V_PLAN_START_DATE, 2), 'YYYYMM') THEN A.SUMQTY END), 0) AS M2
                 , NVL(SUM(CASE WHEN A.YYYYMM = TO_CHAR(ADD_MONTHS(V_PLAN_START_DATE, 3), 'YYYYMM') THEN A.SUMQTY END), 0) AS M3
                 , NVL(SUM(CASE WHEN A.YYYYMM = TO_CHAR(ADD_MONTHS(V_PLAN_START_DATE, 4), 'YYYYMM') THEN A.SUMQTY END), 0) AS M4
                 , NVL(SUM(CASE WHEN A.YYYYMM = TO_CHAR(ADD_MONTHS(V_PLAN_START_DATE, 5), 'YYYYMM') THEN A.SUMQTY END), 0) AS M5
                 , NVL(SUM(CASE WHEN A.YYYYMM = TO_CHAR(ADD_MONTHS(V_PLAN_START_DATE, 6), 'YYYYMM') THEN A.SUMQTY END), 0) AS M6
                 , NVL(SUM(CASE WHEN A.YYYYMM = TO_CHAR(ADD_MONTHS(V_PLAN_START_DATE, 7), 'YYYYMM') THEN A.SUMQTY END), 0) AS M7
                 , NVL(SUM(CASE WHEN A.YYYYMM = TO_CHAR(ADD_MONTHS(V_PLAN_START_DATE, 8), 'YYYYMM') THEN A.SUMQTY END), 0) AS M8
                 , NVL(SUM(CASE WHEN A.YYYYMM = TO_CHAR(ADD_MONTHS(V_PLAN_START_DATE, 9), 'YYYYMM') THEN A.SUMQTY END), 0) AS M9
                 , NVL(SUM(CASE WHEN A.YYYYMM = TO_CHAR(ADD_MONTHS(V_PLAN_START_DATE, 10), 'YYYYMM') THEN A.SUMQTY END), 0) AS M10
                 , NVL(SUM(CASE WHEN A.YYYYMM = TO_CHAR(ADD_MONTHS(V_PLAN_START_DATE, 11), 'YYYYMM') THEN A.SUMQTY END), 0) AS M11
                 , NVL(SUM(CASE WHEN A.YYYYMM = TO_CHAR(ADD_MONTHS(V_PLAN_START_DATE, 12), 'YYYYMM') THEN A.SUMQTY END), 0) AS M12
                 , 0, P_CREATED_BY, SYSDATE
              FROM GT_DIO_CYCLE_INVENTORY2 A
                 , GT_DIO_SCM_MST_SITE S
             WHERE S.DIVISION_ID(+) = A.DIVISION_ID AND S.LOGISTIC_PLANT_ID(+) = A.PLANT_ID AND S.OPERATION_GROUP(+) = A.OPERATION_GROUP
             GROUP BY A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.NICK_NAME, A.PLANT_ID, A.FROM_SITE
                 , A.OPERATION_GROUP, A.TRANSPORT_MODE_LINE;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            /* 오류발생시 등록된 버전정보(P) 삭제 (원본 CATCH 로직) */
            DELETE FROM SCP_ANL_DIO_REPORT_VERSION
             WHERE DIVISION_ID         = P_DIVISION_ID
               AND PLAN_START_YYYYMMDD  = P_PLAN_START_YYYYMMDD
               AND PLAN_TYPE            = V_PLAN_TYPE
               AND SEQ                  = P_SEQ
               AND VER                  = V_VER
               AND VER_STATUS           = 'P';

            V_LOG_TYPE    := 'ERROR';
            V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
            V_DESCRIPTION := SUBSTR('ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 500);
            D_EVENT_DATE  := SYSDATE;
            PR_SCP_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_BATCH_USER);
            DBMS_OUTPUT.PUT_LINE(V_LOG_MESSAGE || ' : ' || V_DESCRIPTION);
            RETURN;   /* 원본 return -1 : MSSQL CATCH가 흡수(RAISERROR/THROW 없음) → RAISE 없이 종료(후속 status/END 로그 스킵) */
    END;

    /* -------------------------------------------------------------------------------------------------- */
    /* 데이터 생성 완료시 버전 상태 정보 업데이트 (PJ20216891) */
    /* -------------------------------------------------------------------------------------------------- */
    SELECT COUNT(*)
      INTO V_CNT
      FROM SCP_ANL_DIO_REPORT
     WHERE DIVISION_ID         = P_DIVISION_ID
       AND PLAN_START_YYYYMMDD  = P_PLAN_START_YYYYMMDD
       AND PLAN_TYPE            = V_PLAN_TYPE
       AND SEQ                  = P_SEQ
       AND VER                  = V_VER;

    IF V_CNT > 0 THEN
        /* 버전 상태 업데이트 (완료) */
        UPDATE SCP_ANL_DIO_REPORT_VERSION
           SET VER_STATUS = 'C', LAST_UPDATE_DATE = SYSDATE
         WHERE DIVISION_ID         = P_DIVISION_ID
           AND PLAN_START_YYYYMMDD  = P_PLAN_START_YYYYMMDD
           AND PLAN_TYPE            = V_PLAN_TYPE
           AND SEQ                  = P_SEQ
           AND VER                  = V_VER;
    ELSE
        /* 생성된 데이터가 없으면 버전 삭제 */
        DELETE FROM SCP_ANL_DIO_REPORT_VERSION
         WHERE DIVISION_ID         = P_DIVISION_ID
           AND PLAN_START_YYYYMMDD  = P_PLAN_START_YYYYMMDD
           AND PLAN_TYPE            = V_PLAN_TYPE
           AND SEQ                  = P_SEQ
           AND VER                  = V_VER;
    END IF;

    /* 종료 LOG */
    V_ELAPSED_SEC := ROUND((SYSDATE - V_START_TIME) * 86400);

    V_EXEC_TIME := CASE WHEN LENGTH(TO_CHAR(FLOOR(V_ELAPSED_SEC / 60))) > 2 THEN NULL
                        ELSE LPAD(TO_CHAR(FLOOR(V_ELAPSED_SEC / 60)), 2, '0') || ':' || LPAD(TO_CHAR(MOD(V_ELAPSED_SEC, 60)), 2, '0')
                   END;
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure  ##########';
    V_DESCRIPTION := '[' || V_EXEC_TIME || ']';
    D_EVENT_DATE  := SYSDATE;
    PR_SCP_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_BATCH_USER);

    /* 원본 return 1 (정상 종료) */
END PR_SCP_ANL_DIO_REPORT;