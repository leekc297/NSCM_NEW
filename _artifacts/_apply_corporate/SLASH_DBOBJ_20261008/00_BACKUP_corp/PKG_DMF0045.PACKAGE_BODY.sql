PACKAGE BODY PKG_DMF0045
AS
/****************************************************************************************************/
/* Program ID  : PKG_DMF0045                                                                        */
/* Description : Shipment Request                                                                   */
/* Program History                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2026.09.24  ZIONEX       [PJ202650304] MSSQL -> Oracle 전환                                      */
/****************************************************************************************************/

/****************************************************************************************************/
/* Program ID  : P_DMF0045_GET_SHIPMENT_REQUEST                                                     */
/* Description : 출하요청 조회                                                                      */
/****************************************************************************************************/
PROCEDURE P_DMF0045_GET_SHIPMENT_REQUEST
(
    P_SHEET_NAME        IN  VARCHAR2
  , P_DIVISION_ID       IN  VARCHAR2
  , P_TEAM_ID           IN  VARCHAR2
  , P_CUSTOMER          IN  VARCHAR2
  , P_SCM_SITE_ID       IN  VARCHAR2
  , P_PLANT_SITE_ID     IN  VARCHAR2
  , P_PROJECT_CODE      IN  VARCHAR2
  , P_ITEM_ID           IN  VARCHAR2
  , P_FROM_YYYYMMDD     IN  VARCHAR2
  , P_TO_YYYYMMDD       IN  VARCHAR2
  , P_CREATED_BY        IN  VARCHAR2
  , O_RC1               OUT SYS_REFCURSOR
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
IS
    V_PROGRAM_ID                VARCHAR2(8 CHAR)    := 'DMF0045';
    V_STOCK_YYYYMMDD            VARCHAR2(8 CHAR);
    V_CUTOFF_DATE               VARCHAR2(8 CHAR);
    V_USER_MEA_CNT              NUMBER              := 0;
    V_BIZ_TYPE                  VARCHAR2(8 CHAR);
    V_LANG                      VARCHAR2(200 CHAR);

    V_SHEET_NAME                VARCHAR2(10 CHAR)   := P_SHEET_NAME;
    V_DIVISION_ID               VARCHAR2(30 CHAR)   := P_DIVISION_ID;
    V_TEAM_ID                   VARCHAR2(4000 CHAR) := P_TEAM_ID;
    V_CUSTOMER                  VARCHAR2(4000 CHAR) := P_CUSTOMER;
    V_SCM_SITE_ID               VARCHAR2(4000 CHAR) := P_SCM_SITE_ID;
    V_PLANT_SITE_ID             VARCHAR2(4000 CHAR) := P_PLANT_SITE_ID;
    V_PROJECT_CODE              VARCHAR2(4000 CHAR) := P_PROJECT_CODE;
    V_ITEM_ID                   VARCHAR2(4000 CHAR) := P_ITEM_ID;
    V_FROM_YYYYMMDD             VARCHAR2(8 CHAR)    := P_FROM_YYYYMMDD;
    V_TO_YYYYMMDD               VARCHAR2(8 CHAR)    := P_TO_YYYYMMDD;
    V_CREATED_BY                VARCHAR2(50 CHAR)   := P_CREATED_BY;

    V_SCP_PLAN_START_YYYYMMDD   VARCHAR2(8 CHAR);
    V_SCP_PLAN_TYPE             VARCHAR2(10 CHAR);
    V_SCP_SEQ                   NUMBER;

    V_QRY_SUM                   CLOB;
    V_EXEC                      CLOB;

BEGIN

    /* 조회조건 ALL 은 조건 없음으로 다룬다 */
    IF UPPER(TRIM(V_TEAM_ID))       = 'ALL' THEN V_TEAM_ID       := NULL; END IF;
    IF UPPER(TRIM(V_CUSTOMER))      = 'ALL' THEN V_CUSTOMER      := NULL; END IF;
    IF UPPER(TRIM(V_SCM_SITE_ID))   = 'ALL' THEN V_SCM_SITE_ID   := NULL; END IF;
    IF UPPER(TRIM(V_PLANT_SITE_ID)) = 'ALL' THEN V_PLANT_SITE_ID := NULL; END IF;
    IF UPPER(TRIM(V_PROJECT_CODE))  = 'ALL' THEN V_PROJECT_CODE  := NULL; END IF;
    IF UPPER(TRIM(V_ITEM_ID))       = 'ALL' THEN V_ITEM_ID       := NULL; END IF;

    V_STOCK_YYYYMMDD := TO_CHAR(TO_DATE(V_FROM_YYYYMMDD, 'YYYYMMDD') - 3, 'YYYYMMDD');   /* FROM -3일 */

    /* 2026.09.30 AJS 수정 (START) */
--    BEGIN
--        SELECT LANGUAGE
--          INTO V_LANG
--          FROM TB_FX_USER
--         WHERE USERID = V_CREATED_BY;
--    EXCEPTION
--        WHEN NO_DATA_FOUND THEN V_LANG := NULL;
--        WHEN TOO_MANY_ROWS THEN V_LANG := NULL;
--    END;
    BEGIN
        SELECT LANG_CD
          INTO V_LANG
          FROM SCM_ADM_USER_M
         WHERE USER_ID = V_CREATED_BY;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_LANG := NULL;
        WHEN TOO_MANY_ROWS THEN V_LANG := NULL;
    END;
    /* 2026.09.30 AJS 수정 (END) */

    /********************************************************************************
    * 임시테이블 초기화
    ********************************************************************************/
    DELETE FROM GT_DMF0045_LOC;
    DELETE FROM GT_DMF0045_MEASURE;
    DELETE FROM GT_DMF0045_SHIP_REQ;
    DELETE FROM GT_DMF0045_PLAN;
    DELETE FROM GT_DMF0045_SHIP_ROW;
    DELETE FROM GT_DMF0045_PIVOT;
    DELETE FROM GT_DMF0045_REQUESTOR;
    DELETE FROM GT_DMF0045_STOCK;
    DELETE FROM GT_DMF0045_PLAN_FG;
    DELETE FROM GT_DMF0045_MKT;
    DELETE FROM GT_DMF0045_ETD;
    DELETE FROM GT_DMF0045_BOH;

    IF V_SHEET_NAME = 'Pack Biz'
    THEN
        V_BIZ_TYPE := 'P';
        INSERT INTO GT_DMF0045_LOC (SHT_NAME, DIVISION_ID, LOC_CODE) VALUES (V_SHEET_NAME, V_DIVISION_ID, 'PACK_OWMS');
        INSERT INTO GT_DMF0045_LOC (SHT_NAME, DIVISION_ID, LOC_CODE) VALUES (V_SHEET_NAME, V_DIVISION_ID, 'CMA_BMA');
    ELSE
        V_BIZ_TYPE := 'A';
        INSERT INTO GT_DMF0045_LOC (SHT_NAME, DIVISION_ID, LOC_CODE) VALUES (V_SHEET_NAME, V_DIVISION_ID, 'CELL_OWMS');
        INSERT INTO GT_DMF0045_LOC (SHT_NAME, DIVISION_ID, LOC_CODE) VALUES (V_SHEET_NAME, V_DIVISION_ID, 'FORMATION_CHECK_PACKAGING');
    END IF;

    /* 측정값 설정 */
    IF V_BIZ_TYPE = 'P'
    THEN
        INSERT INTO GT_DMF0045_MEASURE (MEASURE, MEASURE_LABEL, BIZ_TYPE, SUM_CHECK, MEASURE_COLOR, DEL_FLAG, SEQ) VALUES ('RTF_SCP', 'RTF_System[R+P]', 'P', 'N', '219,229,241', 'Y', 1);
        /* [CSR 요청번호:C20200121-000352][c20200403-000258] */
        INSERT INTO GT_DMF0045_MEASURE (MEASURE, MEASURE_LABEL, BIZ_TYPE, SUM_CHECK, MEASURE_COLOR, DEL_FLAG, SEQ) VALUES ('SCP_SHIP_PLAN', 'SCP Ship Plan', 'P', 'A', '252,213,180', 'Y', 2);
        INSERT INTO GT_DMF0045_MEASURE (MEASURE, MEASURE_LABEL, BIZ_TYPE, SUM_CHECK, MEASURE_COLOR, DEL_FLAG, SEQ) VALUES ('SHIP_REQ', 'Ship Req', 'P', 'N', '215,227,188', 'Y', 3);
        INSERT INTO GT_DMF0045_MEASURE (MEASURE, MEASURE_LABEL, BIZ_TYPE, SUM_CHECK, MEASURE_COLOR, DEL_FLAG, SEQ) VALUES ('SHIP_PLAN', 'Ship Plan', 'P', 'N', '255,255,255', 'Y', 4);
        INSERT INTO GT_DMF0045_MEASURE (MEASURE, MEASURE_LABEL, BIZ_TYPE, SUM_CHECK, MEASURE_COLOR, DEL_FLAG, SEQ) VALUES ('PACK_FP', 'Pack FP', 'P', 'Y', '219,229,241', 'Y', 5);
        INSERT INTO GT_DMF0045_MEASURE (MEASURE, MEASURE_LABEL, BIZ_TYPE, SUM_CHECK, MEASURE_COLOR, DEL_FLAG, SEQ) VALUES ('TOTAL_PLAN', 'Total(Plan)', 'P', 'Y', '219,229,241', 'Y', 6);
        INSERT INTO GT_DMF0045_MEASURE (MEASURE, MEASURE_LABEL, BIZ_TYPE, SUM_CHECK, MEASURE_COLOR, DEL_FLAG, SEQ) VALUES ('TOTAL_REQ', 'Total(Req)', 'P', 'Y', '219,229,241', 'Y', 7);
        INSERT INTO GT_DMF0045_MEASURE (MEASURE, MEASURE_LABEL, BIZ_TYPE, SUM_CHECK, MEASURE_COLOR, DEL_FLAG, SEQ) VALUES ('WH_BOH_PLAN', 'W/H BOH(Plan)', 'P', 'Y', '219,229,241', 'Y', 8);
        INSERT INTO GT_DMF0045_MEASURE (MEASURE, MEASURE_LABEL, BIZ_TYPE, SUM_CHECK, MEASURE_COLOR, DEL_FLAG, SEQ) VALUES ('WH_BOH_REQ', 'W/H BOH(Req)', 'P', 'Y', '219,229,241', 'Y', 9);
    ELSE
        INSERT INTO GT_DMF0045_MEASURE (MEASURE, MEASURE_LABEL, BIZ_TYPE, SUM_CHECK, MEASURE_COLOR, DEL_FLAG, SEQ) VALUES ('RTF_SCP', 'RTF_System[R+P]', 'A', 'N', '219,229,241', 'Y', 1);
        /* [CSR 요청번호:C20200121-000352][c20200403-000258] */
        INSERT INTO GT_DMF0045_MEASURE (MEASURE, MEASURE_LABEL, BIZ_TYPE, SUM_CHECK, MEASURE_COLOR, DEL_FLAG, SEQ) VALUES ('SCP_SHIP_PLAN', 'SCP Ship Plan', 'A', 'A', '252,213,180', 'Y', 2);
        INSERT INTO GT_DMF0045_MEASURE (MEASURE, MEASURE_LABEL, BIZ_TYPE, SUM_CHECK, MEASURE_COLOR, DEL_FLAG, SEQ) VALUES ('SHIP_REQ', 'Ship Req', 'A', 'N', '215,227,188', 'Y', 3);
        INSERT INTO GT_DMF0045_MEASURE (MEASURE, MEASURE_LABEL, BIZ_TYPE, SUM_CHECK, MEASURE_COLOR, DEL_FLAG, SEQ) VALUES ('SHIP_PLAN', 'Ship Plan', 'A', 'N', '255,255,255', 'Y', 4);
        INSERT INTO GT_DMF0045_MEASURE (MEASURE, MEASURE_LABEL, BIZ_TYPE, SUM_CHECK, MEASURE_COLOR, DEL_FLAG, SEQ) VALUES ('SITE_MOVE', 'Site-Move Plan', 'A', 'Y', '219,229,241', 'Y', 5);
        INSERT INTO GT_DMF0045_MEASURE (MEASURE, MEASURE_LABEL, BIZ_TYPE, SUM_CHECK, MEASURE_COLOR, DEL_FLAG, SEQ) VALUES ('INTN_MOVEMENT', 'Internal movement', 'A', 'Y', '219,229,241', 'Y', 6);
        INSERT INTO GT_DMF0045_MEASURE (MEASURE, MEASURE_LABEL, BIZ_TYPE, SUM_CHECK, MEASURE_COLOR, DEL_FLAG, SEQ) VALUES ('INSP_PLAN', 'Inspection plan', 'A', 'Y', '219,229,241', 'Y', 7);
        INSERT INTO GT_DMF0045_MEASURE (MEASURE, MEASURE_LABEL, BIZ_TYPE, SUM_CHECK, MEASURE_COLOR, DEL_FLAG, SEQ) VALUES ('TOTAL_PLAN', 'Total(Plan)', 'A', 'Y', '219,229,241', 'Y', 8);
        INSERT INTO GT_DMF0045_MEASURE (MEASURE, MEASURE_LABEL, BIZ_TYPE, SUM_CHECK, MEASURE_COLOR, DEL_FLAG, SEQ) VALUES ('TOTAL_REQ', 'Total(Req)', 'A', 'Y', '219,229,241', 'Y', 9);
        INSERT INTO GT_DMF0045_MEASURE (MEASURE, MEASURE_LABEL, BIZ_TYPE, SUM_CHECK, MEASURE_COLOR, DEL_FLAG, SEQ) VALUES ('WH_BOH_PLAN', 'W/H BOH(Plan)', 'A', 'Y', '219,229,241', 'Y', 10);
        INSERT INTO GT_DMF0045_MEASURE (MEASURE, MEASURE_LABEL, BIZ_TYPE, SUM_CHECK, MEASURE_COLOR, DEL_FLAG, SEQ) VALUES ('WH_BOH_REQ', 'W/H BOH(Req)', 'A', 'Y', '219,229,241', 'Y', 11);
    END IF;

    /* 사용자 측정값 처리 */
    SELECT COUNT(*)
      INTO V_USER_MEA_CNT
      FROM SCM_MST_TITLESET_USER
     WHERE PROGRAM_ID                      = V_PROGRAM_ID
       AND SHEET_NAME                      = V_SHEET_NAME
       AND USER_INQUIRY_COLUMN_TYPE_CODE   = 'M'
       AND USER_ID                         = V_CREATED_BY;

    IF V_USER_MEA_CNT = 0
    THEN
        INSERT INTO SCM_MST_TITLESET_USER
                    (
                      USER_ID
                    , PROGRAM_ID
                    , SHEET_NAME
                    , USER_INQUIRY_COLUMN_TYPE_CODE
                    , COLUMN_NAME
                    , SORT_ORDER_NO
                    , SUB_TOTAL_FLAG
                    , DATA_SORT_METHOD_CODE
                    , CREATED_BY
                    , CREATION_DATE
                    , LAST_UPDATED_BY
                    , LAST_UPDATE_DATE
                    )
        SELECT V_CREATED_BY
             , PROGRAM_ID
             , SHEET_NAME
             , 'M'
             , COLUMN_NAME
             , SORT_ORDER_NO
             , 'N'
             , '-'
             , V_CREATED_BY
             , SYSDATE
             , V_CREATED_BY
             , SYSDATE
          FROM SCM_MST_SHEET_MEASURE
         WHERE PROGRAM_ID   = V_PROGRAM_ID
           AND SHEET_NAME   = V_SHEET_NAME
           AND DEFAULT_FLAG = 'Y'
           AND VALID_YN     = 'Y';
    END IF;

    UPDATE GT_DMF0045_MEASURE A
       SET A.DEL_FLAG = 'N'
     WHERE EXISTS (SELECT 1
                     FROM SCM_MST_TITLESET_USER B
                    WHERE B.COLUMN_NAME                     = A.MEASURE
                      AND B.PROGRAM_ID                      = V_PROGRAM_ID
                      AND B.SHEET_NAME                      = V_SHEET_NAME
                      AND B.USER_ID                         = V_CREATED_BY
                      AND B.USER_INQUIRY_COLUMN_TYPE_CODE   = 'M');

    -----------------------------------------------
    -- 3. Ship Req : 출하 요청(Sales향 Ship Req)
    --               DM_PLN_SHIPMENT_REQ / MEASURE = 'SHIP_REQ'
    -----------------------------------------------
    INSERT INTO GT_DMF0045_SHIP_REQ
                (
                  DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, DEPT, END_CUSTOMER, PROJECT_CODE
                , INCOTERMS, FCST_TYPE, TR_MODE, BOD_ID, MEASURE, YYYYMMDD, CREATED_BY, QTY, SEQ, RN
                )
    SELECT A.DIVISION_ID
         , A.ITEM_ID
         , A.PLANT_SITE_ID                                                  AS FROM_SITE
         , A.SCM_SITE_ID                                                    AS TO_SITE
         , CASE V_LANG WHEN 'EN' THEN C.DEPT_NAME_EN
                       WHEN 'CN' THEN C.DEPT_NAME_CN
                       ELSE C.DEPT_NAME_KO
           END                                                              AS DEPT
         , B.END_CUSTOMER
         , A.PROJECT_CODE
         , A.INCOTERMS
         , A.FCST_TYPE                                                      AS FCST_TYPE
         , A.TRANSPORT_MODE                                                 AS TR_MODE
         , A.BOD_ID
         , 'SHIP_REQ'                                                       AS MEASURE
         , A.YYYYMMDD
         , A.LAST_UPDATED_BY                                                AS CREATED_BY
         , A.QTY
         , 3                                                                AS SEQ
         , RANK() OVER (PARTITION BY A.DIVISION_ID, A.ITEM_ID, A.PLANT_SITE_ID, A.SCM_SITE_ID, A.PROJECT_CODE, A.FCST_TYPE
                                   , A.INCOTERMS, A.TRANSPORT_MODE
                            ORDER BY A.LAST_UPDATE_DATE DESC)               AS RN
      FROM DM_PLN_SHIPMENT_REQ A
         , SCM_MST_SITE B
         /* 부서 축을 아이템 원장으로 변경 (START) 2026.09.29 AJS */
         , SCM_MST_SITE_ITEM_DEPT_V IB
         /* 부서 축을 아이템 원장으로 변경 (END) 2026.09.29 AJS */
         , SCM_MST_SSO_DEPT_INFO C
         , (SELECT DISTINCT DIVISION_ID
                 , ITEM_ID
                 , SCP_OPERATION_GROUP
              FROM SCM_MST_ITEM_SN
             WHERE DIVISION_ID         = V_DIVISION_ID
               AND ACTIVE_FLAG         = 'Y'
               AND SCP_OPERATION_GROUP = V_BIZ_TYPE                             /* CELL/PACK 구분 */
           ) IA
     WHERE A.DIVISION_ID       = B.DIVISION_ID
       AND A.SCM_SITE_ID       = B.SCM_SITE_ID
       AND B.VALID_YN          = 'Y'
       /* 부서 축을 아이템 원장으로 변경 (START) 2026.09.29 AJS */
--       AND B.DEPT_ID           = C.DEPT_ID(+)
       AND A.DIVISION_ID       = IB.DIVISION_ID(+)
       AND A.SCM_SITE_ID       = IB.SCM_SITE_ID(+)
       AND A.ITEM_ID           = IB.ITEM_ID(+)
       AND IB.DEPT_ID          = C.DEPT_ID(+)
       /* 부서 축을 아이템 원장으로 변경 (END) 2026.09.29 AJS */
       AND A.DIVISION_ID       = IA.DIVISION_ID
       AND A.ITEM_ID           = IA.ITEM_ID
       AND A.SCM_SITE_ID NOT IN (SELECT SEGMENT1
                                   FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                  WHERE LOOKUP_TYPE = 'AS_SITE_PLANT'
                                    AND VALID_YN    = 'Y'
                                    AND SEGMENT3    = V_DIVISION_ID)
       AND A.MEASURE           = 'SHIP_REQ'
       AND A.SITE_TYPE         = 'SALES'
       AND A.QTY               > 0
       AND A.DIVISION_ID       = V_DIVISION_ID
       AND A.YYYYMMDD          >= V_FROM_YYYYMMDD
       AND A.YYYYMMDD          <= V_TO_YYYYMMDD
       /* 부서 축을 아이템 원장으로 변경 (START) 2026.09.29 AJS */
--       AND (TRIM(V_TEAM_ID) IS NULL OR B.DEPT_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_TEAM_ID, ','))))
       AND (TRIM(V_TEAM_ID) IS NULL OR IB.DEPT_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_TEAM_ID, ','))))
       /* 부서 축을 아이템 원장으로 변경 (END) 2026.09.29 AJS */
       AND (TRIM(V_PLANT_SITE_ID) IS NULL OR A.PLANT_SITE_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_PLANT_SITE_ID, ','))))
       AND (TRIM(V_ITEM_ID) IS NULL OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_ITEM_ID, ','))));

    -----------------------------------------------
    -- 1. RTF
    -- FromSite 를 Global PSI 에서 Div, Item_Id, To_Site, Incoterms 기준으로 찾아와서 사용한다.
    -----------------------------------------------
    BEGIN
        SELECT PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , PLAN_SEQ
          INTO V_SCP_PLAN_START_YYYYMMDD
             , V_SCP_PLAN_TYPE
             , V_SCP_SEQ
          FROM (SELECT A.PLAN_START_YYYYMMDD
                     , A.PLAN_TYPE
                     , A.PLAN_SEQ
                  FROM SCP_PLAN_VERSION_V A
                 WHERE A.DIVISION_ID = V_DIVISION_ID
                   AND A.PLAN_CYCLE  = 'WEEKLY'
                   AND A.PLAN_TYPE   = 'FN'
                 ORDER BY A.PLAN_START_YYYYMMDD DESC
                        , A.PLAN_TYPE_ORDER DESC
                        , A.PLAN_SEQ DESC
               )
         WHERE ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_SCP_PLAN_START_YYYYMMDD := NULL;
            V_SCP_PLAN_TYPE           := NULL;
            V_SCP_SEQ                 := NULL;
    END;

    /* [C20200701-000388]                                                                       */
    /* SCP_ANL_SHIPMENT_PLAN_FG에는 없는 FCST_TYPE 추출을 위해                                  */
    /* SCP_ANL_SHIPMENT_PLAN_FG의 원천인 SCP_PLN_SHIPMENT_PLAN_PEGGING + SCP_PLN_SHIPMENT_PLAN   */
    INSERT INTO GT_DMF0045_PLAN_FG
                (
                  DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, BIZ_TYPE, PROJECT_CODE, FCST_TYPE
                , ITEM_ID, TO_SITE, INCOTERMS, FROM_SITE, BOD_ID, TRANSPORT_MODE, MEASURE, YYYYMMDD, QTY
                )
    SELECT DIVISION_ID
         , PLAN_START_YYYYMMDD
         , PLAN_TYPE
         , SEQ
         , MAX(OPERATION_GROUP)                                             AS BIZ_TYPE
         , NVL(PROJECT_CODE, '-')                                           AS PROJECT_CODE
         , FCST_TYPE
         , ITEM_ID
         , TO_SITE
         , INCOTERMS
         , FROM_SITE
         , BOD_ID
         , TRANSPORT_MODE
         , MEASURE
         , YYYYMMDD
         , SUM(QTY)                                                         AS QTY
      FROM (SELECT B.DIVISION_ID
                 , B.PLAN_START_YYYYMMDD
                 , B.PLAN_TYPE
                 , B.SEQ
                 , B.OPERATION_GROUP
                 , A.PROJECT_CODE
                 , A.FCST_TYPE
                 , B.ITEM_ID
                 , B.TO_SITE
                 , (SELECT X.SSP_INCOTERMS
                      FROM SCP_MST_BOD_N_V X
                     WHERE X.DIVISION_ID = B.DIVISION_ID
                       AND X.BOD_ID      = B.BOD_ID
                       AND ROWNUM        = 1)                               AS INCOTERMS
                 , B.FROM_SITE
                 , B.BOD_ID
                 , B.TRANSPORT_MODE
                 , B.MEASURE
                 , B.YYYYMMDD
                 , A.ALLOCATION_QTY                                         AS QTY
              FROM SCP_PLN_SHIPMENT_PLAN_PEGGING A
                 , SCP_PLN_SHIPMENT_PLAN B
             WHERE A.MASTER_ID               = B.MASTER_ID(+)
               AND A.PLAN_ID                 = B.PLAN_ID(+)
               AND A.OUT_VERSION_ID          = B.OUT_VERSION_ID(+)
               AND A.DIVISION_ID             = B.DIVISION_ID(+)
               AND A.PLAN_START_YYYYMMDD     = B.PLAN_START_YYYYMMDD(+)
               AND A.PLAN_TYPE               = B.PLAN_TYPE(+)
               AND A.SEQ                     = B.SEQ(+)
               AND A.ORDER_ID                = B.ORDER_ID(+)
               AND B.MEASURE(+)              = 'SHIP_PLAN'
               AND B.SEMI_YN(+)              = 'N'
               AND B.DIVISION_ID            IS NOT NULL
               AND B.OPERATION_GROUP         = V_BIZ_TYPE
               AND B.YYYYMMDD               >= V_FROM_YYYYMMDD
               AND B.YYYYMMDD               <= V_TO_YYYYMMDD
               AND B.TO_SITE            NOT IN (SELECT SEGMENT1
                                                  FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                                 WHERE LOOKUP_TYPE = 'AS_SITE_PLANT'
                                                   AND VALID_YN    = 'Y'
                                                   AND SEGMENT3    = V_DIVISION_ID)
               AND A.DIVISION_ID             = V_DIVISION_ID
               AND A.PLAN_START_YYYYMMDD     = V_SCP_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE               = V_SCP_PLAN_TYPE
               AND A.SEQ                     = V_SCP_SEQ
           ) XA
     GROUP BY DIVISION_ID
            , PLAN_START_YYYYMMDD
            , PLAN_TYPE
            , SEQ
            , NVL(PROJECT_CODE, '-')
            , FCST_TYPE
            , ITEM_ID
            , TO_SITE
            , INCOTERMS
            , FROM_SITE
            , TRANSPORT_MODE
            , BOD_ID
            , MEASURE
            , YYYYMMDD;

    /* 82 일 경우 RTF 대신 SCP_Ship_plan 추가 [CSR 요청번호:C20200121-000352][c20200403-000258] */
    INSERT INTO GT_DMF0045_PLAN
                (
                  DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, DEPT, END_CUSTOMER, PROJECT_CODE
                , INCOTERMS, FCST_TYPE, TR_MODE, BOD_ID, MEASURE, YYYYMMDD, QTY, SEQ
                )
    SELECT A.DIVISION_ID
         , A.ITEM_ID
         , A.FROM_SITE
         , A.TO_SITE
         , CASE V_LANG WHEN 'EN' THEN D.DEPT_NAME_EN
                       WHEN 'CN' THEN D.DEPT_NAME_CN
                       ELSE D.DEPT_NAME_KO
           END                                                              AS DEPT
         , C.END_CUSTOMER                                                   AS END_CUSTOMER
         , A.PROJECT_CODE
         , A.INCOTERMS
         , NVL(A.FCST_TYPE, '')                                             AS FCST_TYPE
         , A.TRANSPORT_MODE                                                 AS TR_MODE
         , A.BOD_ID
         , 'SCP_SHIP_PLAN'                                                  AS MEASURE
         , A.YYYYMMDD
         , A.QTY
         , 2                                                                AS SEQ
      FROM GT_DMF0045_PLAN_FG A
         , SCM_SYS_CALENDAR_M B
         , SCM_MST_SITE C
         /* 부서 축을 아이템 원장으로 변경 (START) 2026.09.29 AJS */
         , SCM_MST_SITE_ITEM_DEPT_V IB
         /* 부서 축을 아이템 원장으로 변경 (END) 2026.09.29 AJS */
         , SCM_MST_SSO_DEPT_INFO D
     WHERE A.YYYYMMDD          = B.BASIS_YYYYMMDD
       AND A.TO_SITE           = C.SCM_SITE_ID
       AND A.DIVISION_ID       = C.DIVISION_ID
       /* 부서 축을 아이템 원장으로 변경 (START) 2026.09.29 AJS */
--       AND C.DEPT_ID           = D.DEPT_ID(+)
       AND A.DIVISION_ID       = IB.DIVISION_ID(+)
       AND A.TO_SITE           = IB.SCM_SITE_ID(+)
       AND A.ITEM_ID           = IB.ITEM_ID(+)
       AND IB.DEPT_ID          = D.DEPT_ID(+)
       /* 부서 축을 아이템 원장으로 변경 (END) 2026.09.29 AJS */
       AND A.MEASURE           = 'SHIP_PLAN'
       AND A.BIZ_TYPE          = V_BIZ_TYPE
       AND A.DIVISION_ID       = V_DIVISION_ID
       AND A.YYYYMMDD          >= V_FROM_YYYYMMDD
       AND A.YYYYMMDD          <= V_TO_YYYYMMDD
       /* 부서 축을 아이템 원장으로 변경 (START) 2026.09.29 AJS */
--       AND (TRIM(V_TEAM_ID) IS NULL OR C.DEPT_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_TEAM_ID, ','))))
       AND (TRIM(V_TEAM_ID) IS NULL OR IB.DEPT_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_TEAM_ID, ','))))
       /* 부서 축을 아이템 원장으로 변경 (END) 2026.09.29 AJS */
       AND (TRIM(V_ITEM_ID) IS NULL OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_ITEM_ID, ','))))
       AND (TRIM(V_PLANT_SITE_ID) IS NULL OR A.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_PLANT_SITE_ID, ','))));

    /* AS 고객향 DM MKT_FCST 적용                                                            */
    /* ★ 출발일 계산 함수(FN_GET_SSP_ETD_DATE)가 한 번에 0.3초 걸리므로                      */
    /*   대상을 먼저 담고, 같은 (사업부 · BOD · 도착일) 은 한 번만 계산해 붙인다.            */
    INSERT INTO GT_DMF0045_MKT
                (
                  DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, FCST_TYPE, INCOTERMS
                , BOD_ID, PLANT_SITE_ID, DM_YYYYMMDD, QTY, END_CUSTOMER, DEPT
                )
    SELECT A.DIVISION_ID
         , A.PROJECT_CODE
         , A.SCM_SITE_ID
         , A.ITEM_ID
         , A.FCST_TYPE
         , A.INCOTERMS
         , (SELECT BOD_ID
              FROM (SELECT BOD_ID
                      FROM SCP_MST_BOD_V                                        /* 현재일 기준으로 */
                     WHERE DIVISION_ID   = A.DIVISION_ID
                       AND FROM_SITE     = A.ATTRIBUTE10
                       AND TO_SITE       = A.SCM_SITE_ID
                       AND INCOTERMS     = A.INCOTERMS
                       AND BOD_VALID_YN  = 'Y'
                     ORDER BY PRIORITY
                   )
             WHERE ROWNUM = 1)                                                  AS BOD_ID
         , A.ATTRIBUTE10                                                        AS PLANT_SITE_ID
         , A.YYYYMMDD                                                           AS DM_YYYYMMDD
         , A.QTY
         , C.END_CUSTOMER
         , CASE V_LANG WHEN 'EN' THEN D.DEPT_NAME_EN
                       WHEN 'CN' THEN D.DEPT_NAME_CN
                       ELSE D.DEPT_NAME_KO
           END                                                                  AS DEPT
      FROM DM_PLN_MKT_FCST A
         , SCM_MST_SITE B
         , SCM_MST_SITE C
         /* 부서 축을 아이템 원장으로 변경 (START) 2026.09.29 AJS */
         , SCM_MST_SITE_ITEM_DEPT_V IB
         /* 부서 축을 아이템 원장으로 변경 (END) 2026.09.29 AJS */
         , SCM_MST_SSO_DEPT_INFO D
     WHERE A.DIVISION_ID       = B.DIVISION_ID
       AND A.ATTRIBUTE10       = B.SCM_SITE_ID
       AND B.SITE_TYPE         = 'PLANT'
       AND B.OPERATION_GROUP   = CASE WHEN V_BIZ_TYPE = 'P' THEN 'W' ELSE 'Z' END
       AND B.VALID_YN          = 'Y'
       AND A.DIVISION_ID       = C.DIVISION_ID
       AND A.SCM_SITE_ID       = C.SCM_SITE_ID
       AND C.SITE_TYPE         = 'SALES'
       AND C.VALID_YN          = 'Y'
       /* 부서 축을 아이템 원장으로 변경 (START) 2026.09.29 AJS */
--       AND C.DEPT_ID           = D.DEPT_ID(+)
       AND A.DIVISION_ID       = IB.DIVISION_ID(+)
       AND A.SCM_SITE_ID       = IB.SCM_SITE_ID(+)
       AND A.ITEM_ID           = IB.ITEM_ID(+)
       AND IB.DEPT_ID          = D.DEPT_ID(+)
       /* 부서 축을 아이템 원장으로 변경 (END) 2026.09.29 AJS */
       AND A.MEASURE           = 'MKT_FCST'
       AND NVL(C.ATTRIBUTE2, 'N') = 'Y'                                         /* 자동 생성 여부 */
       AND A.QTY               > 0
       AND A.DIVISION_ID       = V_DIVISION_ID
       /* 부서 축을 아이템 원장으로 변경 (START) 2026.09.29 AJS */
--       AND (TRIM(V_TEAM_ID) IS NULL OR C.DEPT_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_TEAM_ID, ','))))
       AND (TRIM(V_TEAM_ID) IS NULL OR IB.DEPT_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_TEAM_ID, ','))))
       /* 부서 축을 아이템 원장으로 변경 (END) 2026.09.29 AJS */
       AND (TRIM(V_ITEM_ID) IS NULL OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_ITEM_ID, ','))))
       AND (TRIM(V_PLANT_SITE_ID) IS NULL OR A.ATTRIBUTE10 IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_PLANT_SITE_ID, ','))));

    INSERT INTO GT_DMF0045_ETD
                (
                  DIVISION_ID, BOD_ID, DM_YYYYMMDD, ETD_YYYYMMDD
                )
    SELECT DIVISION_ID
         , BOD_ID
         , DM_YYYYMMDD
         , FN_GET_SSP_ETD_DATE(DIVISION_ID, BOD_ID, DM_YYYYMMDD)                AS ETD_YYYYMMDD
      FROM (SELECT DISTINCT A.DIVISION_ID
                 , A.BOD_ID
                 , A.DM_YYYYMMDD
              FROM GT_DMF0045_MKT A
                 , SCP_MST_BOD_N_V B
             WHERE A.BOD_ID = B.BOD_ID
           );

    INSERT INTO GT_DMF0045_PLAN
                (
                  DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, DEPT, END_CUSTOMER, PROJECT_CODE
                , INCOTERMS, FCST_TYPE, TR_MODE, BOD_ID, MEASURE, YYYYMMDD, QTY, SEQ
                )
    SELECT A.DIVISION_ID
         , A.ITEM_ID
         , A.PLANT_SITE_ID                                                      AS FROM_SITE
         , A.SCM_SITE_ID                                                        AS TO_SITE
         , A.DEPT
         , A.END_CUSTOMER
         , A.PROJECT_CODE
         , NVL(B.SSP_INCOTERMS, B.INCOTERMS)                                    AS INCOTERMS
         , A.FCST_TYPE
         , B.TRANSPORT_MODE                                                     AS TR_MODE
         , B.BOD_ID
         , 'SCP_SHIP_PLAN'                                                      AS MEASURE
         , C.ETD_YYYYMMDD                                                       AS YYYYMMDD
         , A.QTY
         , 2                                                                    AS SEQ
      FROM GT_DMF0045_MKT A
         , SCP_MST_BOD_N_V B
         , GT_DMF0045_ETD C
     WHERE A.BOD_ID          = B.BOD_ID
       AND A.DIVISION_ID     = C.DIVISION_ID
       AND A.BOD_ID          = C.BOD_ID
       AND A.DM_YYYYMMDD     = C.DM_YYYYMMDD
       AND C.ETD_YYYYMMDD   >= V_FROM_YYYYMMDD
       AND C.ETD_YYYYMMDD   <= V_TO_YYYYMMDD;

    IF V_BIZ_TYPE = 'A'
    THEN
        -----------------------------------------------
        -- 2019.12.23 정리
        -- 확정구간 내에서는 Ship Plan 만 가져온다.
        -- 확정구간 밖에서는 Ship Plan + Ship Req 를 가져온다.
        -- SCP Plan 을 가져오던 것을 Ship Plan 을 가져오도록 변경함 ( 2019.10.07 )
        -----------------------------------------------
        INSERT INTO GT_DMF0045_PLAN
                    (
                      DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, DEPT, END_CUSTOMER, PROJECT_CODE
                    , INCOTERMS, FCST_TYPE, TR_MODE, BOD_ID, MEASURE, YYYYMMDD, QTY, SEQ
                    )
        SELECT A.DIVISION_ID
             , A.ITEM_ID
             , A.FROM_SITE                                                  AS FROM_SITE
             , '-'                                                           AS TO_SITE
             , '-'                                                           AS DEPT
             , '-'                                                           AS END_CUSTOMER
             , '-'                                                           AS PROJECT_CODE
             , '-'                                                           AS INCOTERMS
             , '-'                                                           AS FCST_TYPE
             , '-'                                                           AS TR_MODE
             , '-'                                                           AS BOD_ID
             , 'SITE_MOVE'                                                  AS MEASURE
             , A.YYYYMMDD
             , A.QTY
             , 2                                                            AS SEQ
          FROM SSP_ANL_SHIP_CONFIRM A
             , SCP_MST_BOD_N_V B
             , SCM_MST_SITE C
             , SCM_MST_SITE D
         WHERE A.DIVISION_ID   = B.DIVISION_ID
           AND A.BOD_ID        = B.BOD_ID
           AND A.DIVISION_ID   = C.DIVISION_ID
           AND A.TO_SITE       = C.SCM_SITE_ID
           AND C.SITE_TYPE     = 'PLANT'
           AND C.VALID_YN      = 'Y'
           AND A.DIVISION_ID   = D.DIVISION_ID
           AND A.FROM_SITE     = D.SCM_SITE_ID
           AND D.VALID_YN      = 'Y'
           AND C.PLANT_ID     <> D.PLANT_ID
           AND A.CHANGE_TYPE   = 'C'
           AND A.BIZ_TYPE      = V_BIZ_TYPE
           AND A.QTY           > 0
           AND A.DIVISION_ID   = V_DIVISION_ID
           AND A.YYYYMMDD     >= V_FROM_YYYYMMDD
           AND A.YYYYMMDD     <= V_TO_YYYYMMDD
           AND (TRIM(V_SCM_SITE_ID) IS NULL OR A.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_SCM_SITE_ID, ','))))
           AND (TRIM(V_ITEM_ID) IS NULL OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_ITEM_ID, ','))));

        /* 2019.10.7 scp에서 ship_plan 이 컨펌된 수량 + Req 수량이라 req도 추가함 */
        INSERT INTO GT_DMF0045_PLAN
                    (
                      DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, DEPT, END_CUSTOMER, PROJECT_CODE
                    , INCOTERMS, FCST_TYPE, TR_MODE, BOD_ID, MEASURE, YYYYMMDD, QTY, SEQ
                    )
        SELECT A.DIVISION_ID
             , A.ITEM_ID
             , A.PLANT_SITE_ID                                              AS FROM_SITE
             , '-'                                                           AS TO_SITE
             , '-'                                                           AS DEPT
             , '-'                                                           AS END_CUSTOMER
             , '-'                                                           AS PROJECT_CODE
             , '-'                                                           AS INCOTERMS
             , '-'                                                           AS FCST_TYPE
             , '-'                                                           AS TR_MODE
             , '-'                                                           AS BOD_ID
             , 'SITE_MOVE'                                                  AS MEASURE
             , A.YYYYMMDD
             , A.QTY
             , 2                                                            AS SEQ
          FROM DM_PLN_SHIPMENT_REQ A
             , SCM_MST_SITE B
             , SCM_MST_SITE C
         WHERE A.DIVISION_ID      = B.DIVISION_ID
           AND A.PLANT_SITE_ID    = B.SCM_SITE_ID
           AND B.SITE_TYPE        = 'PLANT'
           AND B.OPERATION_GROUP  = V_BIZ_TYPE
           AND B.OSP_YN           = 'N'
           AND B.VALID_YN         = 'Y'
           AND A.DIVISION_ID      = C.DIVISION_ID
           AND A.SCM_SITE_ID      = C.SCM_SITE_ID
           AND C.SITE_TYPE        = 'PLANT'
           AND C.VALID_YN         = 'Y'
           AND A.MEASURE          = 'SHIP_REQ'                                  /* 확정 후 수정할 것 */
           AND A.QTY              > 0
           AND A.DIVISION_ID      = V_DIVISION_ID
           AND A.YYYYMMDD        >= V_FROM_YYYYMMDD
           AND A.YYYYMMDD        <= V_TO_YYYYMMDD
           AND A.YYYYMMDD        >= TO_CHAR(SYSDATE + NVL(B.SHIP_FROZEN, 0), 'YYYYMMDD')     /* 2019.12.23 */
           AND (TRIM(V_SCM_SITE_ID) IS NULL OR A.PLANT_SITE_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_SCM_SITE_ID, ','))))
           AND (TRIM(V_ITEM_ID) IS NULL OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_ITEM_ID, ','))));

        -----------------------------------------------
        -- 5. Internal movement
        -----------------------------------------------
        INSERT INTO GT_DMF0045_PLAN
                    (
                      DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, DEPT, END_CUSTOMER, PROJECT_CODE
                    , INCOTERMS, FCST_TYPE, TR_MODE, BOD_ID, MEASURE, YYYYMMDD, QTY, SEQ
                    )
        SELECT A.DIVISION_ID
             , A.ITEM_ID
             , B.SCM_SITE_ID                                                AS FROM_SITE
             , '-'                                                           AS TO_SITE
             , '-'                                                           AS DEPT
             , '-'                                                           AS END_CUSTOMER
             , '-'                                                           AS PROJECT_CODE
             , '-'                                                           AS INCOTERMS
             , '-'                                                           AS FCST_TYPE
             , '-'                                                           AS TR_MODE
             , '-'                                                           AS BOD_ID
             , 'INTN_MOVEMENT'                                              AS MEASURE
             , TO_CHAR(A.PLAN_DATE, 'YYYYMMDD')                             AS YYYYMMDD
             , A.QTY
             , 5                                                            AS SEQ
          FROM SCM_DNM_CELL_INHOUSE_PLAN_SN A
             , SCM_MST_SITE B
         WHERE A.DIVISION_ID      = B.DIVISION_ID
           AND A.PLANT_ID         = B.PLANT_ID
           AND B.SITE_TYPE        = 'PLANT'
           AND B.OSP_YN           = 'N'
           AND B.VALID_YN         = 'Y'
           AND B.OPERATION_GROUP  = V_BIZ_TYPE
           AND A.CATEGORY         = 'MOVING'
           AND A.QTY              > 0
           AND A.DIVISION_ID      = V_DIVISION_ID
           AND A.PLAN_DATE       >= TO_DATE(V_FROM_YYYYMMDD, 'YYYYMMDD')
           AND A.PLAN_DATE       <= TO_DATE(V_TO_YYYYMMDD, 'YYYYMMDD')
           AND (TRIM(V_PLANT_SITE_ID) IS NULL OR B.SCM_SITE_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_PLANT_SITE_ID, ','))))
           AND (TRIM(V_ITEM_ID) IS NULL OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_ITEM_ID, ','))));

    END IF;
    --------------------------------- CELL Biz 끝 -------------------------------------------------------------

    -----------------------------------------------
    -- 2. Ship Plan : SSP(Daily) Sales향 Shipment Plan
    -----------------------------------------------
    INSERT INTO GT_DMF0045_PLAN
                (
                  DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, DEPT, END_CUSTOMER, PROJECT_CODE
                , INCOTERMS, FCST_TYPE, TR_MODE, BOD_ID, MEASURE, YYYYMMDD, QTY, SEQ
                )
    SELECT A.DIVISION_ID
         , A.ITEM_ID
         , A.FROM_SITE
         , A.TO_SITE
         , CASE V_LANG WHEN 'EN' THEN D.DEPT_NAME_EN
                       WHEN 'CN' THEN D.DEPT_NAME_CN
                       ELSE D.DEPT_NAME_KO
           END                                                              AS DEPT
         , C.END_CUSTOMER
         , A.PROJECT_CODE
         , B.SSP_INCOTERMS                                                  AS INCOTERMS
         , A.FCST_TYPE
         , B.TRANSPORT_MODE                                                 AS TR_MODE
         , B.BOD_ID
         , 'SHIP_PLAN'                                                      AS MEASURE
         , A.YYYYMMDD
         , A.QTY
         , 2                                                                AS SEQ
      FROM SSP_ANL_SHIP_CONFIRM A
         , SCP_MST_BOD_N_V B
         , SCM_MST_SITE C
         /* 부서 축을 아이템 원장으로 변경 (START) 2026.09.29 AJS */
         , SCM_MST_SITE_ITEM_DEPT_V IB
         /* 부서 축을 아이템 원장으로 변경 (END) 2026.09.29 AJS */
         , SCM_MST_SSO_DEPT_INFO D
         , (SELECT DISTINCT DIVISION_ID
                 , ITEM_ID
                 , SCP_OPERATION_GROUP
              FROM SCM_MST_ITEM_SN
             WHERE DIVISION_ID         = V_DIVISION_ID
               AND SCP_OPERATION_GROUP = V_BIZ_TYPE                             /* CELL/PACK 구분 */
               AND ACTIVE_FLAG         = 'Y'
           ) IA
     WHERE A.DIVISION_ID   = B.DIVISION_ID
       AND A.BOD_ID        = B.BOD_ID
       AND A.DIVISION_ID   = C.DIVISION_ID
       AND A.TO_SITE       = C.SCM_SITE_ID
       AND (C.SITE_TYPE = 'SALES' OR (C.SITE_TYPE = 'PLANT' AND C.OSP_YN = 'Y'))
       AND C.VALID_YN      = 'Y'
       /* 부서 축을 아이템 원장으로 변경 (START) 2026.09.29 AJS */
--       AND C.DEPT_ID       = D.DEPT_ID(+)
       AND A.DIVISION_ID   = IB.DIVISION_ID(+)
       AND A.TO_SITE       = IB.SCM_SITE_ID(+)
       AND A.ITEM_ID       = IB.ITEM_ID(+)
       AND IB.DEPT_ID      = D.DEPT_ID(+)
       /* 부서 축을 아이템 원장으로 변경 (END) 2026.09.29 AJS */
       AND A.DIVISION_ID   = IA.DIVISION_ID
       AND A.ITEM_ID       = IA.ITEM_ID
       AND A.TO_SITE NOT IN (SELECT SEGMENT1
                               FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                              WHERE LOOKUP_TYPE = 'AS_SITE_PLANT'
                                AND VALID_YN    = 'Y'
                                AND SEGMENT3    = V_DIVISION_ID)
       AND A.CHANGE_TYPE   = 'C'
       AND A.QTY           > 0
       AND A.DIVISION_ID   = V_DIVISION_ID
       AND A.YYYYMMDD     >= V_FROM_YYYYMMDD
       AND A.YYYYMMDD     <= V_TO_YYYYMMDD
       AND (TRIM(V_PLANT_SITE_ID) IS NULL OR A.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_PLANT_SITE_ID, ','))))
       AND (TRIM(V_ITEM_ID) IS NULL OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_ITEM_ID, ','))))
     UNION ALL
    SELECT A.DIVISION_ID
         , A.ITEM_ID
         , A.FROM_SITE
         , A.TO_SITE
         , A.DEPT
         , A.END_CUSTOMER
         , A.PROJECT_CODE
         , A.INCOTERMS
         , A.FCST_TYPE
         , A.TR_MODE
         , A.BOD_ID
         , 'SHIP_PLAN'                                                      AS MEASURE
         , A.YYYYMMDD
         , A.QTY
         , 2                                                                AS SEQ
      FROM GT_DMF0045_SHIP_REQ A
         , SCM_MST_SITE B
     WHERE A.DIVISION_ID   = B.DIVISION_ID(+)
       AND A.FROM_SITE     = B.SCM_SITE_ID(+)
       AND B.VALID_YN(+)   = 'Y'
       AND A.YYYYMMDD     >= TO_CHAR(SYSDATE + NVL(B.SHIP_FROZEN, 0), 'YYYYMMDD');   /* 확정구간의 다음날짜가 나오므로 >= 로 처리함 */

    -----------------------------------------------
    -- 6. TOTOAL(PLAN)
    -----------------------------------------------
    INSERT INTO GT_DMF0045_PLAN
                (
                  DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, DEPT, END_CUSTOMER, PROJECT_CODE
                , INCOTERMS, FCST_TYPE, TR_MODE, BOD_ID, MEASURE, YYYYMMDD, QTY, SEQ
                )
    SELECT DIVISION_ID
         , ITEM_ID
         , FROM_SITE                                                        AS FROM_SITE
         , '-'                                                               AS TO_SITE
         , '-'                                                               AS DEPT
         , '-'                                                               AS END_CUSTOMER
         , '-'                                                               AS PROJECT_CODE
         , '-'                                                               AS INCOTERMS
         , '-'                                                               AS FCST_TYPE
         , '-'                                                               AS TR_MODE
         , '-'                                                               AS BOD_ID
         , 'TOTAL_PLAN'                                                     AS MEASURE
         , YYYYMMDD
         , SUM(QTY)                                                         AS QTY
         , 6                                                                AS SEQ
      FROM (SELECT A.DIVISION_ID
                 , A.ITEM_ID
                 , A.FROM_SITE                                              AS FROM_SITE
                 , A.YYYYMMDD
                 , SUM(CASE WHEN A.MEASURE IN ('SHIP_PLAN', 'SITE_MOVE', 'INTN_MOVEMENT') THEN A.QTY ELSE 0 END) AS QTY
              FROM GT_DMF0045_PLAN A
             GROUP BY A.DIVISION_ID
                    , A.ITEM_ID
                    , A.YYYYMMDD
                    , A.FROM_SITE
           ) XA
     GROUP BY DIVISION_ID
            , ITEM_ID
            , YYYYMMDD
            , FROM_SITE;

    -----------------------------------------------
    -- 7. TOTOAL(REQ)
    -----------------------------------------------
    INSERT INTO GT_DMF0045_PLAN
                (
                  DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, DEPT, END_CUSTOMER, PROJECT_CODE
                , INCOTERMS, FCST_TYPE, TR_MODE, BOD_ID, MEASURE, YYYYMMDD, QTY, SEQ
                )
    SELECT IA.DIVISION_ID
         , IA.ITEM_ID
         , IA.FROM_SITE                                                     AS FROM_SITE
         , '-'                                                               AS TO_SITE
         , '-'                                                               AS DEPT
         , '-'                                                               AS END_CUSTOMER
         , '-'                                                               AS PROJECT_CODE
         , '-'                                                               AS INCOTERMS
         , '-'                                                               AS FCST_TYPE
         , '-'                                                               AS TR_MODE
         , '-'                                                               AS BOD_ID
         , 'TOTAL_REQ'                                                      AS MEASURE
         , IA.YYYYMMDD
         , SUM(IA.QTY)                                                      AS QTY
         , 7                                                                AS SEQ
      FROM (SELECT A.DIVISION_ID
                 , A.ITEM_ID
                 , A.FROM_SITE                                              AS FROM_SITE
                 , A.MEASURE
                 , A.YYYYMMDD
                 , SUM(CASE WHEN A.MEASURE IN ('SHIP_REQ', 'SITE_MOVE', 'INTN_MOVEMENT') THEN A.QTY ELSE 0 END) AS QTY
              FROM GT_DMF0045_SHIP_REQ A
             GROUP BY A.DIVISION_ID
                    , A.ITEM_ID
                    , A.YYYYMMDD
                    , A.MEASURE
                    , A.FROM_SITE
             UNION ALL
            SELECT A.DIVISION_ID
                 , A.ITEM_ID
                 , A.FROM_SITE                                              AS FROM_SITE
                 , A.MEASURE
                 , A.YYYYMMDD
                 , SUM(CASE WHEN A.MEASURE IN ('SHIP_REQ', 'SITE_MOVE', 'INTN_MOVEMENT') THEN A.QTY ELSE 0 END) AS QTY
              FROM GT_DMF0045_PLAN A
             GROUP BY A.DIVISION_ID
                    , A.ITEM_ID
                    , A.YYYYMMDD
                    , A.MEASURE
                    , A.FROM_SITE
           ) IA
     GROUP BY IA.DIVISION_ID
            , IA.ITEM_ID
            , IA.YYYYMMDD
            , IA.FROM_SITE;

    IF V_BIZ_TYPE = 'P'
    THEN
        IF V_DIVISION_ID = '81'
        THEN
            -----------------------------------------------
            -- 6. PACK_FP
            -----------------------------------------------
            INSERT INTO GT_DMF0045_PLAN
                        (
                          DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, DEPT, END_CUSTOMER, PROJECT_CODE
                        , INCOTERMS, FCST_TYPE, TR_MODE, BOD_ID, MEASURE, YYYYMMDD, QTY, SEQ
                        )
            SELECT A.DIVISION_ID
                 , A.ITEM_ID
                 , A.SCM_SITE_ID                                            AS FROM_SITE
                 , '-'                                                       AS TO_SITE
                 , '-'                                                       AS DEPT
                 , '-'                                                       AS END_CUSTOMER
                 , '-'                                                       AS PROJECT_CODE
                 , '-'                                                       AS INCOTERMS
                 , '-'                                                       AS FCST_TYPE
                 , '-'                                                       AS TR_MODE
                 , '-'                                                       AS BOD_ID
                 , 'PACK_FP'                                                AS MEASURE
                 , A.PLAN_DATE                                              AS YYYYMMDD
                 , A.PLAN_QTY                                               AS QTY
                 , 8                                                        AS SEQ
              FROM SSP_DNM_FP_PLAN_FROZEN A
                 , SCM_MST_SITE B
             WHERE A.DIVISION_ID      = B.DIVISION_ID
               AND A.SCM_SITE_ID      = B.SCM_SITE_ID
               AND B.SITE_TYPE        = 'PLANT'
               AND B.OSP_YN           = 'N'
               AND B.VALID_YN         = 'Y'
               AND A.OPERATION_ID    IN (SELECT B.SEGMENT4
                                           FROM SCM_ADM_LOOKUP_MASTER_DETAIL A
                                              , SCM_ADM_LOOKUP_MASTER_DETAIL B
                                          WHERE A.SEGMENT1    = B.SEGMENT1
                                            AND A.LOOKUP_TYPE = 'LOCATION_GROUP'
                                            AND A.SEGMENT3    = 'P'                 /* PACK 공정 */
                                            AND A.SEGMENT4    = 'Y'                 /* CAPA 공정 여부 */
                                            AND A.SEGMENT5    = 'Y'                 /* LINE 별 CAPA 적용 공정 */
                                            AND A.VALID_YN    = 'Y'
                                            AND B.LOOKUP_TYPE = 'LOCATION_GROUP_ROUTE'
                                            AND B.VALID_YN    = 'Y'
                                            AND B.SEGMENT3    = 'Y')                /* CAPA 세부 공정 여부 */
               AND A.DIVISION_ID      = V_DIVISION_ID
               AND A.PLAN_DATE       >= V_FROM_YYYYMMDD
               AND A.PLAN_DATE       <= V_TO_YYYYMMDD
               AND (TRIM(V_PLANT_SITE_ID) IS NULL OR A.SCM_SITE_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_PLANT_SITE_ID, ','))))
               AND (TRIM(V_ITEM_ID) IS NULL OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_ITEM_ID, ','))))
             UNION ALL
            /* A/S PLANT ETA 기준 */
            SELECT A.DIVISION_ID                                            AS DIVISION_ID
                 , A.ITEM_ID                                                AS ITEM_ID
                 , A.TO_SITE                                                AS FROM_SITE
                 , '-'                                                       AS TO_SITE
                 , '-'                                                       AS DEPT
                 , '-'                                                       AS END_CUSTOMER
                 , '-'                                                       AS PROJECT_CODE
                 , '-'                                                       AS INCOTERMS
                 , '-'                                                       AS FCST_TYPE
                 , '-'                                                       AS TR_MODE
                 , '-'                                                       AS BOD_ID
                 , 'PACK_FP'                                                AS MEASURE
                 , A.ETA_DATE                                               AS YYYYMMDD
                 , A.QTY                                                    AS QTY
                 , 8                                                        AS SEQ
              FROM SSP_ANL_SHIP_CONFIRM A
                 , SCM_MST_SITE B
             WHERE A.DIVISION_ID      = B.DIVISION_ID
               AND A.TO_SITE          = B.SCM_SITE_ID
               AND B.OPERATION_GROUP  = 'W'
               AND B.SITE_TYPE        = 'PLANT'
               AND B.VALID_YN         = 'Y'
               AND A.QTY              > 0
               AND A.DIVISION_ID      = V_DIVISION_ID
               AND A.ETA_DATE        >= V_FROM_YYYYMMDD
               AND A.ETA_DATE        <= V_TO_YYYYMMDD
               AND (TRIM(V_PLANT_SITE_ID) IS NULL OR A.TO_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_PLANT_SITE_ID, ','))))
               AND (TRIM(V_ITEM_ID) IS NULL OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_ITEM_ID, ','))));

        ELSIF V_DIVISION_ID = '82'
        THEN
            /* 해당 쿼리는 최근 2주간 실행된 SCP Plan중 가장 최신의 Plan 수량을 가져오는 쿼리로 보입니다. (Pack 대상) */
            INSERT INTO GT_DMF0045_PLAN
                        (
                          DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, DEPT, END_CUSTOMER, PROJECT_CODE
                        , INCOTERMS, FCST_TYPE, TR_MODE, BOD_ID, MEASURE, YYYYMMDD, QTY, SEQ
                        )
            SELECT A.DIVISION_ID
                 , A.ITEM_ID
                 , A.SCM_SITE_ID                                            AS FROM_SITE
                 , '-'                                                       AS TO_SITE
                 , '-'                                                       AS DEPT
                 , '-'                                                       AS END_CUSTOMER
                 , '-'                                                       AS PROJECT_CODE
                 , '-'                                                       AS INCOTERMS
                 , '-'                                                       AS FCST_TYPE
                 , '-'                                                       AS TR_MODE
                 , '-'                                                       AS BOD_ID
                 , 'PACK_FP'                                                AS MEASURE      /* SCP PROD Plan */
                 , A.YYYYMMDD
                 , A.QTY
                 , 8                                                        AS SEQ
              FROM SCP_ANL_PRODUCTION_PLAN A
                 , SCM_MST_SITE B
                 , (SELECT DIVISION_ID
                         , PLAN_START_YYYYMMDD
                         , PLAN_TYPE
                         , PLAN_SEQ
                         , PLAN_ID
                         , MODELING_ID
                         , ROW_NUMBER() OVER (ORDER BY PLAN_START_YYYYMMDD DESC, PLAN_SEQ DESC) AS ROW_NUM
                      FROM (SELECT DIVISION_ID
                                 , PLAN_START_YYYYMMDD
                                 , PLAN_TYPE
                                 , PLAN_SEQ
                                 , PLAN_ID
                                 , MODELING_ID
                              FROM SCP_PLAN_VERSION_V
                             WHERE DIVISION_ID          = V_DIVISION_ID
                               AND PLAN_CYCLE           = 'WEEKLY'
                               AND PLAN_TYPE            = 'FN'
                               AND PLAN_START_YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 14, 'YYYYMMDD')
                           ) IA
                   ) SA
             WHERE A.DIVISION_ID         = SA.DIVISION_ID
               AND A.PLAN_START_YYYYMMDD = SA.PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE           = SA.PLAN_TYPE
               AND A.SEQ                 = SA.PLAN_SEQ
               AND SA.ROW_NUM            = 1
               AND A.DIVISION_ID         = B.DIVISION_ID
               AND A.SCM_SITE_ID         = B.SCM_SITE_ID
               AND B.SITE_TYPE           = 'PLANT'
               AND B.OPERATION_GROUP     = 'P'
               AND B.VALID_YN            = 'Y'
               AND A.MEASURE             = 'PROD_PLAN_AMEND'
               AND A.QTY                 > 0
               AND A.DIVISION_ID         = V_DIVISION_ID
               AND A.YYYYMMDD           >= V_FROM_YYYYMMDD
               AND A.YYYYMMDD           <= V_TO_YYYYMMDD
               AND (TRIM(V_PLANT_SITE_ID) IS NULL OR A.SCM_SITE_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_PLANT_SITE_ID, ','))))
               AND (TRIM(V_ITEM_ID) IS NULL OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_ITEM_ID, ','))))
             UNION ALL
            /* A/S PLANT ETA 기준 */
            SELECT A.DIVISION_ID                                            AS DIVISION_ID
                 , A.ITEM_ID                                                AS ITEM_ID
                 , A.TO_SITE                                                AS FROM_SITE
                 , '-'                                                       AS TO_SITE
                 , '-'                                                       AS DEPT
                 , '-'                                                       AS END_CUSTOMER
                 , '-'                                                       AS PROJECT_CODE
                 , '-'                                                       AS INCOTERMS
                 , '-'                                                       AS FCST_TYPE
                 , '-'                                                       AS TR_MODE
                 , '-'                                                       AS BOD_ID
                 , 'PACK_FP'                                                AS MEASURE
                 , A.ETA_DATE                                               AS YYYYMMDD
                 , A.QTY                                                    AS QTY
                 , 8                                                        AS SEQ
              FROM SSP_ANL_SHIP_CONFIRM A
                 , SCM_MST_SITE B
             WHERE A.DIVISION_ID      = B.DIVISION_ID
               AND A.TO_SITE          = B.SCM_SITE_ID
               AND B.OPERATION_GROUP  = 'W'
               AND B.SITE_TYPE        = 'PLANT'
               AND B.VALID_YN         = 'Y'
               AND A.QTY              > 0
               AND A.DIVISION_ID      = V_DIVISION_ID
               AND A.ETA_DATE        >= V_FROM_YYYYMMDD
               AND A.ETA_DATE        <= V_TO_YYYYMMDD
               AND (TRIM(V_PLANT_SITE_ID) IS NULL OR A.TO_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_PLANT_SITE_ID, ','))))
               AND (TRIM(V_ITEM_ID) IS NULL OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_ITEM_ID, ','))));

        END IF;
    END IF;

    IF V_BIZ_TYPE = 'A'
    THEN
        -----------------------------------------------
        -- 7. Inspection plan : FP 특성계획
        -----------------------------------------------
        INSERT INTO GT_DMF0045_PLAN
                    (
                      DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, DEPT, END_CUSTOMER, PROJECT_CODE
                    , INCOTERMS, FCST_TYPE, TR_MODE, BOD_ID, MEASURE, YYYYMMDD, QTY, SEQ
                    )
        SELECT A.DIVISION_ID
             , A.ITEM_ID
             , A.SCM_SITE_ID                                                AS FROM_SITE
             , '-'                                                           AS TO_SITE
             , '-'                                                           AS DEPT
             , '-'                                                           AS END_CUSTOMER
             , '-'                                                           AS PROJECT_CODE
             , '-'                                                           AS INCOTERMS
             , '-'                                                           AS FCST_TYPE
             , '-'                                                           AS TR_MODE
             , '-'                                                           AS BOD_ID
             , 'INSP_PLAN'                                                  AS MEASURE
             , A.PLAN_DATE                                                  AS YYYYMMDD
             , A.PLAN_QTY                                                   AS QTY
             , 8                                                            AS SEQ
          FROM SSP_DNM_FP_PLAN_FROZEN A
             , SCM_MST_SITE B
         WHERE A.DIVISION_ID      = B.DIVISION_ID
           AND A.SCM_SITE_ID      = B.SCM_SITE_ID
           AND B.SITE_TYPE        = 'PLANT'
           AND B.OSP_YN           = 'N'
           AND B.VALID_YN         = 'Y'
           /* (참고) division_id <> '40' 일때는 'F6000' 데이터만 존재 */
           AND A.OPERATION_ID    IN (SELECT SEGMENT1
                                       FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                      WHERE LOOKUP_TYPE = 'OPERATION_CHAR'
                                        AND VALID_YN    = 'Y')
           AND (EXISTS (SELECT 1
                          FROM GT_DMF0045_SHIP_REQ SA
                         WHERE SA.DIVISION_ID = A.DIVISION_ID
                           AND SA.ITEM_ID     = A.ITEM_ID)
             OR EXISTS (SELECT 1
                          FROM GT_DMF0045_PLAN SA
                         WHERE SA.DIVISION_ID = A.DIVISION_ID
                           AND SA.ITEM_ID     = A.ITEM_ID))
           AND A.DIVISION_ID      = V_DIVISION_ID
           AND A.PLAN_DATE       >= V_FROM_YYYYMMDD
           AND A.PLAN_DATE       <= V_TO_YYYYMMDD
           AND (TRIM(V_PLANT_SITE_ID) IS NULL OR A.SCM_SITE_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_PLANT_SITE_ID, ','))));

    END IF;

    /* ROW DATA 생성 */
    INSERT INTO GT_DMF0045_SHIP_ROW
                (
                  DIVISION_ID, ITEM_ID, NICK_NAME, FROM_SITE, TO_SITE, DEPT, END_CUSTOMER, PROJECT_CODE
                , INCOTERMS, FCST_TYPE, TR_MODE, BOD_ID, MEASURE, YYYYMMDD, QTY, SEQ
                )
    SELECT IA.DIVISION_ID
         , IA.ITEM_ID
         , MAX(NVL(XA.NICK_NAME, ''))                                       AS NICK_NAME
         , IA.FROM_SITE
         , IA.TO_SITE
         , IA.DEPT
         , IA.END_CUSTOMER
         , IA.PROJECT_CODE
         , IA.INCOTERMS
         , IA.FCST_TYPE
         , IA.TR_MODE
         , NULL                                                             AS BOD_ID
         , IA.MEASURE
         , IA.YYYYMMDD
         , SUM(IA.QTY)                                                      AS QTY
         , IA.SEQ
      FROM (/* 1.RTF, 2.SHIP_PLAN, 4.TOTOAL(PLAN), 5.TOTOAL(REQ), 6.PACK FP */
            SELECT DIVISION_ID
                 , ITEM_ID
                 , FROM_SITE
                 , TO_SITE
                 , DEPT
                 , END_CUSTOMER
                 , PROJECT_CODE
                 , INCOTERMS
                 , FCST_TYPE
                 , TR_MODE
                 , BOD_ID
                 , MEASURE
                 , YYYYMMDD
                 , QTY
                 , SEQ
              FROM GT_DMF0045_PLAN
             UNION ALL
            /* 3.SHIP REQ 추가 */
            SELECT DIVISION_ID
                 , ITEM_ID
                 , FROM_SITE
                 , TO_SITE
                 , DEPT
                 , END_CUSTOMER
                 , PROJECT_CODE
                 , INCOTERMS
                 , FCST_TYPE
                 , TR_MODE
                 , BOD_ID
                 , MEASURE
                 , YYYYMMDD
                 , QTY
                 , 3                                                        AS SEQ
              FROM GT_DMF0045_SHIP_REQ
           ) IA
         , (SELECT DIVISION_ID
                 , ITEM_ID
                 , MAX(NVL(NICK_NAME, ''))                                  AS NICK_NAME
              FROM SCM_MST_ITEM_SN
             WHERE NICK_NAME  IS NOT NULL
               AND DIVISION_ID = V_DIVISION_ID
               AND ACTIVE_FLAG = 'Y'
             GROUP BY DIVISION_ID
                    , ITEM_ID
           ) XA
     WHERE IA.ITEM_ID     = XA.ITEM_ID(+)
       AND IA.DIVISION_ID = XA.DIVISION_ID(+)
     GROUP BY IA.DIVISION_ID
            , IA.ITEM_ID
            , IA.FROM_SITE
            , IA.TO_SITE
            , IA.DEPT
            , IA.END_CUSTOMER
            , IA.PROJECT_CODE
            , IA.INCOTERMS
            , IA.FCST_TYPE
            , IA.TR_MODE
            , IA.MEASURE
            , IA.YYYYMMDD
            , IA.SEQ;

    -----------------------------------------------
    -- 8. W/H BOH(Plan) : Cell Plant의 Cell 재고
    --                    일자별 BOH 계산  : BOH(D+1) = BOH(D) - Ship Req(D) - Customer Req(D) - Internal movement(D) + Inspection Plan(D)
    -----------------------------------------------
    SELECT TO_CHAR(MAX(CUTOFF_DATE), 'YYYYMMDD')
      INTO V_CUTOFF_DATE
      FROM SSP_DNM_STOCK_C
     WHERE DIVISION_ID  = V_DIVISION_ID
       AND STOCK_TYPE  IN ('INVENTORY', 'WIP')
       AND CUTOFF_DATE  > TO_DATE(V_STOCK_YYYYMMDD, 'YYYYMMDD')                 /* 현재일 - 3 */
       AND CUTOFF_DATE <= TO_DATE(V_FROM_YYYYMMDD, 'YYYYMMDD');                 /* 변수 : 현재일 */

    INSERT INTO GT_DMF0045_STOCK
                (
                  DIVISION_ID, SCM_SITE_ID, STORAGE_ID, ITEM_ID, SSP_QTY, YYYYMMDD
                )
    SELECT DIVISION_ID
         , SCM_SITE_ID
         , STORAGE_ID
         , ITEM_ID
         , SSP_QTY
         , TO_CHAR(CUTOFF_DATE, 'YYYYMMDD')                                 AS YYYYMMDD
      FROM SSP_DNM_STOCK_C
     WHERE DIVISION_ID  = V_DIVISION_ID
       AND STOCK_TYPE  IN ('INVENTORY', 'WIP')
       AND CUTOFF_DATE  = TO_DATE(V_CUTOFF_DATE, 'YYYYMMDD');

    /* 사업부별 기초재고 */
    INSERT INTO GT_DMF0045_BOH
                (
                  DIVISION_ID, ITEM_ID, FROM_SITE, YYYYMMDD, QTY
                )
    SELECT IA.DIVISION_ID
         , IA.ITEM_ID
         , IA.FROM_SITE
         , IA.YYYYMMDD
         , SUM(IA.QTY)                                                      AS QTY
      FROM (SELECT A.DIVISION_ID
                 , A.ITEM_ID
                 , A.SCM_SITE_ID                                            AS FROM_SITE
                 , V_FROM_YYYYMMDD                                          AS YYYYMMDD
                 , A.SSP_QTY                                                AS QTY      /* SSP용 */
              FROM GT_DMF0045_STOCK A
                 , SCM_MST_SITE B
                 , SCP_MST_FINAL_ITEM C
                 , (SELECT DISTINCT A.STORAGE_ID
                         , A.LOCATION_CODE
                         , A.SCM_SITE_ID
                         , A.DIVISION_ID
                      FROM SCM_MST_LOCATION A
                         , SCM_MST_SITE B
                         , GT_DMF0045_LOC C
                     WHERE A.SCM_SITE_ID     = B.SCM_SITE_ID
                       AND B.DIVISION_ID     = V_DIVISION_ID
                       AND B.VALID_YN        = 'Y'
                       AND B.OPERATION_GROUP = V_BIZ_TYPE                       /* Cell Plant Site */
                       AND A.DIVISION_ID     = C.DIVISION_ID
                       AND A.LOCATION_CODE   = C.LOC_CODE
                       AND C.SHT_NAME        = V_SHEET_NAME
                       AND A.DIVISION_ID     = V_DIVISION_ID
                       AND A.VALID_YN        = 'Y'
                       AND A.STORAGE_ID     IS NOT NULL
                       AND A.STORAGE_ID     <> ''
                     UNION ALL
                    SELECT DISTINCT A.SEGMENT4                              AS STORAGE_ID
                         , 'AS'                                             AS LOCATION_CODE
                         , A.SEGMENT2                                       AS SCM_SITE_ID
                         , A.SEGMENT1                                       AS DIVISION_ID
                      FROM SCM_ADM_LOOKUP_MASTER_DETAIL A
                         , SCM_MST_SITE B
                     WHERE A.SEGMENT1    = B.DIVISION_ID
                       AND A.SEGMENT2    = B.SCM_SITE_ID
                       AND A.SEGMENT3    = B.PLANT_ID
                       AND A.LOOKUP_TYPE = 'SSP_AS_DIV_SLOC'
                       AND A.VALID_YN    = 'Y'
                       AND B.VALID_YN    = 'Y'
                       AND B.SITE_TYPE   = 'PLANT'
                       AND A.SEGMENT1    = V_DIVISION_ID
                   ) XA                                                         /* 셀 storage_id 별 사용대상 조회 */
             WHERE A.DIVISION_ID      = B.DIVISION_ID
               AND A.SCM_SITE_ID      = B.SCM_SITE_ID
               AND B.DIVISION_ID      = V_DIVISION_ID
               AND B.SITE_TYPE        = 'PLANT'
               AND B.OPERATION_GROUP IN (V_BIZ_TYPE, 'W')
               AND B.VALID_YN         = 'Y'
               AND A.DIVISION_ID      = XA.DIVISION_ID
               AND A.SCM_SITE_ID      = XA.SCM_SITE_ID
               AND A.STORAGE_ID       = XA.STORAGE_ID
               AND A.DIVISION_ID      = C.DIVISION_ID
               AND A.ITEM_ID          = C.ITEM_ID
               AND C.OPERATION_GROUP IN (V_BIZ_TYPE, 'W')
               AND V_DIVISION_ID      = '81'
               AND (TRIM(V_SCM_SITE_ID) IS NULL OR A.SCM_SITE_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_SCM_SITE_ID, ','))))
               AND (TRIM(V_ITEM_ID) IS NULL OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_ITEM_ID, ','))))
           ) IA
     WHERE V_DIVISION_ID = '81'
     GROUP BY IA.DIVISION_ID
            , IA.ITEM_ID
            , IA.FROM_SITE
            , IA.YYYYMMDD
     /* [CSR 요청번호:C20200121-000352] */
     UNION ALL
    SELECT IA.DIVISION_ID
         , IA.ITEM_ID
         , IA.FROM_SITE
         , IA.YYYYMMDD
         , SUM(IA.QTY)                                                      AS QTY
      FROM (SELECT A.DIVISION_ID
                 , A.ITEM_ID
                 , A.SCM_SITE_ID                                            AS FROM_SITE
                 , V_FROM_YYYYMMDD                                          AS YYYYMMDD
                 , A.SSP_QTY                                                AS QTY      /* SSP용 */
              FROM SSP_DNM_ESS_PACKER_STOCK_V A
                 , SCM_MST_SITE B
                 , SCP_MST_FINAL_ITEM C
                 , (SELECT DIVISION_ID
                         , SITE_ID
                         , MAX(CUTOFF_DATE)                                 AS MAX_CUTOFF_DATE
                      FROM SSP_DNM_ESS_PACKER_STOCK_V
                     WHERE DIVISION_ID  = V_DIVISION_ID
                       AND CUTOFF_DATE  > TO_DATE(V_STOCK_YYYYMMDD, 'YYYYMMDD')     /* 현재일 - 3 */
                       AND CUTOFF_DATE <= TO_DATE(V_FROM_YYYYMMDD, 'YYYYMMDD')      /* 변수 : 현재일 */
                     GROUP BY DIVISION_ID
                            , SITE_ID
                   ) XA
             WHERE A.DIVISION_ID      = XA.DIVISION_ID
               AND A.SITE_ID          = XA.SITE_ID
               AND A.CUTOFF_DATE      = XA.MAX_CUTOFF_DATE
               AND A.CUTOFF_DATE      > TO_DATE(V_STOCK_YYYYMMDD, 'YYYYMMDD')
               AND A.DIVISION_ID      = B.DIVISION_ID
               AND A.SCM_SITE_ID      = B.SCM_SITE_ID
               AND B.DIVISION_ID      = V_DIVISION_ID
               AND B.SITE_TYPE        = 'PLANT'
               AND B.OPERATION_GROUP IN (V_BIZ_TYPE, 'W')
               AND B.VALID_YN         = 'Y'
               AND A.DIVISION_ID      = C.DIVISION_ID
               AND A.ITEM_ID          = C.ITEM_ID
               AND C.OPERATION_GROUP IN (V_BIZ_TYPE, 'W')
               AND V_DIVISION_ID      = '82'
               AND (TRIM(V_SCM_SITE_ID) IS NULL OR A.SCM_SITE_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_SCM_SITE_ID, ','))))
               AND (TRIM(V_ITEM_ID) IS NULL OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_ITEM_ID, ','))))
           ) IA
     WHERE V_DIVISION_ID = '82'
     GROUP BY IA.DIVISION_ID
            , IA.ITEM_ID
            , IA.FROM_SITE
            , IA.YYYYMMDD;

    INSERT INTO GT_DMF0045_SHIP_ROW
                (
                  DIVISION_ID, ITEM_ID, NICK_NAME, FROM_SITE, TO_SITE, DEPT, END_CUSTOMER, PROJECT_CODE
                , INCOTERMS, FCST_TYPE, TR_MODE, BOD_ID, MEASURE, YYYYMMDD, QTY, SEQ
                )
    SELECT A.DIVISION_ID
         , A.ITEM_ID
         , A.NICK_NAME
         , A.FROM_SITE                                                      AS FROM_SITE
         , '-'                                                               AS TO_SITE
         , '-'                                                               AS DEPT
         , '-'                                                               AS END_CUSTOMER
         , '-'                                                               AS PROJECT_CODE
         , '-'                                                               AS INCOTERMS
         , '-'                                                               AS FCST_TYPE
         , '-'                                                               AS TR_MODE
         , '-'                                                               AS BOD_ID
         , 'WH_BOH_PLAN'                                                    AS MEASURE
         , A.YYYYMMDD
         , SUM(CASE WHEN C.MEASURE  = 'TOTAL_PLAN' AND C.YYYYMMDD > V_FROM_YYYYMMDD THEN -1 * NVL(C.QTY, 0)
                    WHEN C.MEASURE <> 'TOTAL_PLAN' AND C.YYYYMMDD < A.YYYYMMDD      THEN NVL(C.QTY, 0)
                    ELSE 0
               END) + NVL(B.QTY, 0)                                         AS QTY
         , 9                                                                AS SEQ
      FROM (SELECT DISTINCT XA.DIVISION_ID
                 , XA.ITEM_ID
                 , XA.NICK_NAME
                 , XA.FROM_SITE
                 , A.BASIS_YYYYMMDD                                         AS YYYYMMDD
              FROM SCM_SYS_CALENDAR_M A
                 , (SELECT DISTINCT DIVISION_ID
                         , ITEM_ID
                         , NICK_NAME
                         , FROM_SITE
                      FROM GT_DMF0045_SHIP_ROW
                   ) XA
             WHERE A.BASIS_YYYYMMDD >= V_FROM_YYYYMMDD
               AND A.BASIS_YYYYMMDD <= V_TO_YYYYMMDD
           ) A
         , GT_DMF0045_BOH B
         , GT_DMF0045_PLAN C
     WHERE A.DIVISION_ID   = B.DIVISION_ID(+)
       AND A.ITEM_ID       = B.ITEM_ID(+)
       AND A.FROM_SITE     = B.FROM_SITE(+)
       AND A.DIVISION_ID   = C.DIVISION_ID(+)
       AND A.FROM_SITE     = C.FROM_SITE(+)
       AND A.ITEM_ID       = C.ITEM_ID(+)
       AND A.YYYYMMDD     >= C.YYYYMMDD(+)
       AND C.MEASURE(+)   IN ('TOTAL_PLAN', 'PACK_FP', 'INSP_PLAN')
     GROUP BY A.DIVISION_ID
            , A.ITEM_ID
            , A.NICK_NAME
            , A.YYYYMMDD
            , B.QTY
            , A.FROM_SITE
     UNION ALL
    SELECT A.DIVISION_ID
         , A.ITEM_ID
         , A.NICK_NAME
         , A.FROM_SITE                                                      AS FROM_SITE
         , '-'                                                               AS TO_SITE
         , '-'                                                               AS DEPT
         , '-'                                                               AS END_CUSTOMER
         , '-'                                                               AS PROJECT_CODE
         , '-'                                                               AS INCOTERMS
         , '-'                                                               AS FCST_TYPE
         , '-'                                                               AS TR_MODE
         , '-'                                                               AS BOD_ID
         , 'WH_BOH_REQ'                                                     AS MEASURE
         , A.YYYYMMDD
         , SUM(CASE WHEN C.MEASURE  = 'TOTAL_REQ' AND C.YYYYMMDD > V_FROM_YYYYMMDD THEN -1 * NVL(C.QTY, 0)
                    WHEN C.MEASURE <> 'TOTAL_REQ' AND C.YYYYMMDD < A.YYYYMMDD      THEN NVL(C.QTY, 0)
                    ELSE 0
               END) + NVL(B.QTY, 0)                                         AS QTY
         , 9                                                                AS SEQ
      FROM (SELECT DISTINCT XA.DIVISION_ID
                 , XA.ITEM_ID
                 , XA.NICK_NAME
                 , XA.FROM_SITE
                 , A.BASIS_YYYYMMDD                                         AS YYYYMMDD
              FROM SCM_SYS_CALENDAR_M A
                 , (SELECT DISTINCT DIVISION_ID
                         , ITEM_ID
                         , NICK_NAME
                         , FROM_SITE
                      FROM GT_DMF0045_SHIP_ROW
                   ) XA
             WHERE A.BASIS_YYYYMMDD >= V_FROM_YYYYMMDD
               AND A.BASIS_YYYYMMDD <= V_TO_YYYYMMDD
           ) A
         , GT_DMF0045_BOH B
         , GT_DMF0045_PLAN C
     WHERE A.DIVISION_ID   = B.DIVISION_ID(+)
       AND A.ITEM_ID       = B.ITEM_ID(+)
       AND A.FROM_SITE     = B.FROM_SITE(+)
       AND A.DIVISION_ID   = C.DIVISION_ID(+)
       AND A.FROM_SITE     = C.FROM_SITE(+)
       AND A.ITEM_ID       = C.ITEM_ID(+)
       AND A.YYYYMMDD     >= C.YYYYMMDD(+)
       AND C.MEASURE(+)   IN ('TOTAL_REQ', 'PACK_FP', 'INSP_PLAN')
     GROUP BY A.DIVISION_ID
            , A.ITEM_ID
            , A.NICK_NAME
            , A.YYYYMMDD
            , B.QTY
            , A.FROM_SITE;

    /* 'SCP_SHIP_PLAN', 'SHIP_REQ', 'SHIP_PLAN' 메저 없는것 제거 */
    DELETE FROM GT_DMF0045_SHIP_ROW A
     WHERE NOT EXISTS (SELECT 1
                         FROM GT_DMF0045_SHIP_ROW XA
                        WHERE XA.MEASURE IN ('SCP_SHIP_PLAN', 'SHIP_REQ', 'SHIP_PLAN')
                          AND A.DIVISION_ID = XA.DIVISION_ID
                          AND A.FROM_SITE   = XA.FROM_SITE
                          AND A.ITEM_ID     = XA.ITEM_ID);

    -----------------------------------------------
    -- 10. Requestor
    -----------------------------------------------
    INSERT INTO GT_DMF0045_REQUESTOR
                (
                  DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, TR_MODE, INCOTERMS, FCST_TYPE, MEASURE, CREATED_BY
                )
    SELECT DIVISION_ID
         , ITEM_ID
         , FROM_SITE
         , TO_SITE
         , TR_MODE
         , INCOTERMS
         , FCST_TYPE
         , MEASURE
         , CREATED_BY
      FROM (SELECT DIVISION_ID
                 , ITEM_ID
                 , FROM_SITE
                 , TO_SITE
                 , TR_MODE
                 , INCOTERMS
                 , FCST_TYPE
                 , MEASURE
                 , CREATED_BY
                 , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, TR_MODE, INCOTERMS, FCST_TYPE, MEASURE
                                          ORDER BY RN)                      AS RN2
              FROM GT_DMF0045_SHIP_REQ
           ) XA
     WHERE XA.RN2 = 1;

    /* PIVOT용 Data정리 */
    INSERT INTO GT_DMF0045_PIVOT
                (
                  DIVISION_ID, ITEM_ID, NICK_NAME, FROM_SITE, TO_SITE, DEPT, END_CUSTOMER, PROJECT_CODE
                , INCOTERMS, FCST_TYPE, TR_MODE, BOD_ID, MEASURE, YYYYMMDD, YYYYMM, ISO_WEEK, QTY, SEQ
                )
    SELECT A.DIVISION_ID
         , A.ITEM_ID
         , A.NICK_NAME
         , A.FROM_SITE
         , A.TO_SITE
         , A.DEPT
         , A.END_CUSTOMER
         , A.PROJECT_CODE
         , A.INCOTERMS
         , A.FCST_TYPE
         , A.TR_MODE
         , A.BOD_ID
         , A.MEASURE
         , 'D_' || A.YYYYMMDD                                               AS YYYYMMDD
         , B.BASIS_YYYYMM                                                   AS YYYYMM
         , SUBSTR(B.BASIS_YYYYMM, -4) || B.ISO_WEEK                         AS ISO_WEEK
         , A.QTY
         , A.SEQ
      FROM GT_DMF0045_SHIP_ROW A
         , SCM_SYS_CALENDAR_M B
     WHERE A.YYYYMMDD = B.BASIS_YYYYMMDD
    /* 20210304 KIMYONGHO 임시조치 */
    /* 조회 FILTER 조건 부정확으로 PIVOT 직전 FILTER 다시 설정 */
       AND A.ITEM_ID IN (SELECT DISTINCT XA.ITEM_ID
                           FROM GT_DMF0045_SHIP_ROW XA
                              , SCM_MST_SITE SA
                              /* 부서 축을 아이템 원장으로 변경 (START) 2026.09.29 AJS */
                              , SCM_MST_SITE_ITEM_DEPT_V XB
                              /* 부서 축을 아이템 원장으로 변경 (END) 2026.09.29 AJS */
                          WHERE XA.TO_SITE     = SA.SCM_SITE_ID
                            AND XA.DIVISION_ID = SA.DIVISION_ID
                            /* 부서 축을 아이템 원장으로 변경 (START) 2026.09.29 AJS */
                            AND XA.DIVISION_ID = XB.DIVISION_ID(+)
                            AND XA.TO_SITE     = XB.SCM_SITE_ID(+)
                            AND XA.ITEM_ID     = XB.ITEM_ID(+)
                            /* 부서 축을 아이템 원장으로 변경 (END) 2026.09.29 AJS */
                            AND XA.MEASURE    IN ('SCP_SHIP_PLAN', 'SHIP_PLAN', 'SHIP_REQ')
                            /* 부서 축을 아이템 원장으로 변경 (START) 2026.09.29 AJS */
--                            AND (TRIM(V_TEAM_ID) IS NULL OR SA.DEPT_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_TEAM_ID, ','))))
                            AND (TRIM(V_TEAM_ID) IS NULL OR XB.DEPT_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_TEAM_ID, ','))))
                            /* 부서 축을 아이템 원장으로 변경 (END) 2026.09.29 AJS */
                            AND (TRIM(V_CUSTOMER) IS NULL OR XA.END_CUSTOMER IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_CUSTOMER, ','))))
                            AND (TRIM(V_ITEM_ID) IS NULL OR XA.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_ITEM_ID, ','))))
                            AND (TRIM(V_SCM_SITE_ID) IS NULL OR XA.TO_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_SCM_SITE_ID, ','))))
                            AND (TRIM(V_PLANT_SITE_ID) IS NULL OR XA.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_PLANT_SITE_ID, ','))))
                            AND (TRIM(V_PROJECT_CODE) IS NULL OR XA.PROJECT_CODE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_PROJECT_CODE, ','))))
                            AND XA.DIVISION_ID = V_DIVISION_ID);

    ------ 빠져있는 메저 추가 ------
    /* SHIP_REQ, RTF, RTF_SCP 중 하나의 MEASURE 라도 있으면 아래와 같이 모든 메저를 채워준다.  */
    /* 개별은 TO_SITE 까지를 개별로 보고, 공통은 FROM_SITE 까지를 공통으로 본다.               */
    /* 공통/개별 : SHIP_REQ, RTF, RTF_SCP, SHIP_PLAN                                            */
    /* PACK/합계 : PACK_FP                                                                      */
    /* CELL/합계 : SITE_MOVE, INTN_MOVEMENT, INSP_PLAN                                          */
    /* 공통/합계 : TOTAL_PLAN, TOTAL_REQ, WH_BOH_PLAN, WH_BOH_REQ                               */

    /* 개별 처리 -- 개별로 들어가야 할 MEASURE 중에 없는 것이 있으면 추가한다. */
    INSERT INTO GT_DMF0045_PIVOT
                (
                  DIVISION_ID, ITEM_ID, NICK_NAME, FROM_SITE, TO_SITE, DEPT, END_CUSTOMER, PROJECT_CODE
                , INCOTERMS, FCST_TYPE, TR_MODE, MEASURE, YYYYMMDD, YYYYMM, ISO_WEEK, QTY, SEQ
                )
    SELECT IA.DIVISION_ID
         , IA.ITEM_ID
         , '-'
         , IA.FROM_SITE
         , IA.TO_SITE
         , IA.DEPT
         , IA.END_CUSTOMER
         , IA.PROJECT_CODE
         , IA.INCOTERMS
         , IA.FCST_TYPE
         , IA.TR_MODE
         , B.MEASURE
         , IA.YYYYMMDD
         , IA.YYYYMM
         , IA.ISO_WEEK
         , 0
         , 0
      FROM (SELECT A.DIVISION_ID
                 , A.ITEM_ID
                 , A.FROM_SITE
                 , A.TO_SITE
                 , A.DEPT
                 , A.END_CUSTOMER
                 , A.PROJECT_CODE
                 , A.INCOTERMS
                 , A.FCST_TYPE
                 , A.TR_MODE
                 , A.YYYYMMDD
                 , A.YYYYMM
                 , A.ISO_WEEK
              FROM GT_DMF0045_PIVOT A
             WHERE NVL(A.FROM_SITE, '-') <> '-'
             GROUP BY A.DIVISION_ID
                    , A.ITEM_ID
                    , A.FROM_SITE
                    , A.TO_SITE
                    , A.DEPT
                    , A.END_CUSTOMER
                    , A.PROJECT_CODE
                    , A.INCOTERMS
                    , A.FCST_TYPE
                    , A.TR_MODE
                    , A.YYYYMMDD
                    , A.YYYYMM
                    , A.ISO_WEEK
           ) IA
         , GT_DMF0045_MEASURE B
     WHERE B.BIZ_TYPE      = V_BIZ_TYPE
       AND B.SUM_CHECK     = 'N'
       AND NVL(IA.TO_SITE, '-') <> '-'
       AND NOT EXISTS (SELECT 1
                         FROM GT_DMF0045_PIVOT SA
                        WHERE IA.DIVISION_ID          = SA.DIVISION_ID
                          AND IA.ITEM_ID              = SA.ITEM_ID
                          AND IA.FROM_SITE            = SA.FROM_SITE
                          AND IA.TO_SITE              = SA.TO_SITE
                          AND B.MEASURE               = SA.MEASURE
                          AND IA.YYYYMMDD             = SA.YYYYMMDD
                          AND IA.YYYYMM               = SA.YYYYMM
                          AND IA.ISO_WEEK             = SA.ISO_WEEK
                          AND NVL(IA.DEPT, '-')          = NVL(SA.DEPT, '-')
                          AND NVL(IA.END_CUSTOMER, '-')  = NVL(SA.END_CUSTOMER, '-')
                          AND NVL(IA.PROJECT_CODE, '-')  = NVL(SA.PROJECT_CODE, '-')
                          AND NVL(IA.INCOTERMS, '-')     = NVL(SA.INCOTERMS, '-')
                          AND NVL(IA.FCST_TYPE, '-')     = NVL(SA.FCST_TYPE, '-')
                          AND NVL(IA.TR_MODE, '-')       = NVL(SA.TR_MODE, '-'));

    /* [CSR 요청번호:C20200121-000352]                                       */
    /* 20200618  수정 KIMYONGHO                                              */
    /* 81 사업부 조회 시 SCP SHIP PLAN Measure 미표시 문제로 변경 (82 조건 제외) */

    /* FROM Site 가 없는 건들은 지운다. */
    DELETE FROM GT_DMF0045_PIVOT
     WHERE NVL(FROM_SITE, '-') = '-';

    INSERT INTO GT_DMF0045_PIVOT
                (
                  DIVISION_ID, ITEM_ID, NICK_NAME, FROM_SITE, TO_SITE, DEPT, END_CUSTOMER, PROJECT_CODE
                , INCOTERMS, FCST_TYPE, TR_MODE, MEASURE, YYYYMMDD, YYYYMM, ISO_WEEK, QTY, SEQ
                )
    SELECT IA.DIVISION_ID
         , IA.ITEM_ID
         , '-'
         , IA.FROM_SITE
         , IA.TO_SITE
         , IA.DEPT
         , IA.END_CUSTOMER
         , IA.PROJECT_CODE
         , IA.INCOTERMS
         , IA.FCST_TYPE
         , IA.TR_MODE
         , B.MEASURE
         , IA.YYYYMMDD
         , IA.YYYYMM
         , IA.ISO_WEEK
         , 0
         , 0
      FROM (SELECT A.DIVISION_ID
                 , A.ITEM_ID
                 , A.FROM_SITE
                 , A.TO_SITE
                 , A.DEPT
                 , A.END_CUSTOMER
                 , A.PROJECT_CODE
                 , A.INCOTERMS
                 , A.FCST_TYPE
                 , A.TR_MODE
                 , A.YYYYMMDD
                 , A.YYYYMM
                 , A.ISO_WEEK
              FROM GT_DMF0045_PIVOT A
             WHERE NVL(A.FROM_SITE, '-') <> '-'
             GROUP BY A.DIVISION_ID
                    , A.ITEM_ID
                    , A.FROM_SITE
                    , A.TO_SITE
                    , A.DEPT
                    , A.END_CUSTOMER
                    , A.PROJECT_CODE
                    , A.INCOTERMS
                    , A.FCST_TYPE
                    , A.TR_MODE
                    , A.YYYYMMDD
                    , A.YYYYMM
                    , A.ISO_WEEK
           ) IA
         , GT_DMF0045_MEASURE B
     WHERE B.BIZ_TYPE      = V_BIZ_TYPE
       AND B.SUM_CHECK     = 'A'
       AND NVL(IA.TO_SITE, '-') <> '-'
       AND NOT EXISTS (SELECT 1
                         FROM GT_DMF0045_PIVOT SA
                        WHERE IA.DIVISION_ID          = SA.DIVISION_ID
                          AND IA.ITEM_ID              = SA.ITEM_ID
                          AND IA.FROM_SITE            = SA.FROM_SITE
                          AND IA.TO_SITE              = SA.TO_SITE
                          AND B.MEASURE               = SA.MEASURE
                          AND IA.YYYYMMDD             = SA.YYYYMMDD
                          AND IA.YYYYMM               = SA.YYYYMM
                          AND IA.ISO_WEEK             = SA.ISO_WEEK
                          AND NVL(IA.DEPT, '-')          = NVL(SA.DEPT, '-')
                          AND NVL(IA.END_CUSTOMER, '-')  = NVL(SA.END_CUSTOMER, '-')
                          AND NVL(IA.INCOTERMS, '-')     = NVL(SA.INCOTERMS, '-')
                          AND NVL(IA.TR_MODE, '-')       = NVL(SA.TR_MODE, '-'));

    /* 공통 처리 -- 공통으로 들어가야 할 MEASURE 중에 없는 것이 있으면 추가한다. */
    INSERT INTO GT_DMF0045_PIVOT
                (
                  DIVISION_ID, ITEM_ID, NICK_NAME, FROM_SITE, TO_SITE, DEPT, END_CUSTOMER, PROJECT_CODE
                , INCOTERMS, FCST_TYPE, TR_MODE, BOD_ID, MEASURE, YYYYMMDD, YYYYMM, ISO_WEEK, QTY, SEQ
                )
    SELECT IA.DIVISION_ID
         , IA.ITEM_ID
         , '-'
         , IA.FROM_SITE
         , '-'
         , '-'
         , '-'
         , '-'
         , '-'
         , '-'
         , '-'
         , '-'
         , A.MEASURE
         , IA.YYYYMMDD
         , IA.YYYYMM
         , IA.ISO_WEEK
         , 0
         , 0
      FROM GT_DMF0045_MEASURE A
         , (SELECT XA.DIVISION_ID
                 , XA.ITEM_ID
                 , XA.FROM_SITE
                 , XA.YYYYMMDD
                 , XA.YYYYMM
                 , XA.ISO_WEEK
              FROM GT_DMF0045_PIVOT XA
             GROUP BY XA.DIVISION_ID
                    , XA.ITEM_ID
                    , XA.FROM_SITE
                    , XA.YYYYMMDD
                    , XA.YYYYMM
                    , XA.ISO_WEEK
           ) IA
     WHERE A.BIZ_TYPE  = V_BIZ_TYPE
       AND A.SUM_CHECK = 'Y'
       AND NOT EXISTS (SELECT 1
                         FROM GT_DMF0045_PIVOT SA
                        WHERE IA.DIVISION_ID = SA.DIVISION_ID
                          AND IA.ITEM_ID     = SA.ITEM_ID
                          AND IA.YYYYMMDD    = SA.YYYYMMDD
                          AND IA.YYYYMM      = SA.YYYYMM
                          AND IA.ISO_WEEK    = SA.ISO_WEEK
                          AND A.MEASURE      = SA.MEASURE
                          AND IA.FROM_SITE   = SA.FROM_SITE);

    /* [CSR 요청번호:C20200121-000352] 82번일 경우 RTF 관련 메저 삭제 */
    /* [c20200403-000258] 81 번도 삭제                                */
    DELETE FROM GT_DMF0045_PIVOT A
     WHERE A.MEASURE LIKE '%RTF%'
       AND EXISTS (SELECT 1
                     FROM GT_DMF0045_MEASURE B
                    WHERE A.MEASURE = B.MEASURE);

    UPDATE GT_DMF0045_PIVOT A
       SET A.BOD_ID    = (SELECT BOD_ID
                            FROM (SELECT B.BOD_ID
                                    FROM SCP_MST_BOD_V B
                                   WHERE A.DIVISION_ID = B.DIVISION_ID
                                     AND A.FROM_SITE   = B.FROM_SITE
                                     AND A.TO_SITE     = B.TO_SITE
                                     AND A.INCOTERMS   = B.INCOTERMS
                                     AND A.TR_MODE     = B.TRANSPORT_MODE
                                   ORDER BY B.BOD_VALID_YN DESC                 /* 유효한 것 먼저 */
                                          , B.PRIORITY
                                          , B.BOD_ID
                                 )
                           WHERE ROWNUM = 1)
         , A.NICK_NAME = NVL((SELECT MAX(NVL(B.NICK_NAME, ''))
                                FROM SCM_MST_ITEM_SN B
                               WHERE B.NICK_NAME  IS NOT NULL
                                 AND B.DIVISION_ID = V_DIVISION_ID
                                 AND B.ACTIVE_FLAG = 'Y'
                                 AND A.ITEM_ID     = B.ITEM_ID
                                 AND A.DIVISION_ID = B.DIVISION_ID), '');

    /********************************************************************************
    * PIVOT 처리
    * 화면 칸이 조회 기간에 따라 달라지므로 이 구간만 동적 SQL 을 쓴다
    ********************************************************************************/
    V_QRY_SUM := '';

    FOR C1 IN (SELECT YYYYMMDD
                 FROM (SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK                      AS YYYYMMDD
                            , A.BASIS_START_DATE || '21'                                AS SORT_ORDER_NO
                         FROM SCM_SYS_CALENDAR_M A
                        WHERE A.BASIS_YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                        GROUP BY A.BASIS_YYYYMM
                               , A.ISO_WEEK
                               , A.BASIS_START_DATE
                        UNION ALL
                       SELECT 'M_' || A.BASIS_YYYYMM                                    AS YYYYMMDD
                            , MIN(A.BASIS_START_DATE) || '01'                           AS SORT_ORDER_NO
                         FROM SCM_SYS_CALENDAR_M A
                        WHERE A.BASIS_YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                        GROUP BY A.BASIS_YYYYMM
                               , A.MONTH_NAME
                        UNION ALL
                       SELECT 'D_' || A.BASIS_YYYYMMDD                                  AS YYYYMMDD
                            , A.BASIS_YYYYMMDD || '31'                                  AS SORT_ORDER_NO
                         FROM SCM_SYS_CALENDAR_M A
                        WHERE A.BASIS_YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                        GROUP BY A.BASIS_YYYYMMDD
                      )
                ORDER BY SORT_ORDER_NO)
    LOOP
        IF SUBSTR(C1.YYYYMMDD, 1, 2) = 'M_'
        THEN
            V_QRY_SUM := V_QRY_SUM || ', CASE WHEN SUM(CASE WHEN A.YYYYMM = SUBSTR(''' || C1.YYYYMMDD || ''', -6) THEN A.QTY ELSE 0 END) = 0 AND A.MEASURE NOT LIKE ''WH%'' THEN NULL ELSE SUM(CASE WHEN A.YYYYMM = SUBSTR(''' || C1.YYYYMMDD || ''', -6) THEN A.QTY ELSE 0 END) END AS ' || C1.YYYYMMDD || CHR(10);
        ELSIF SUBSTR(C1.YYYYMMDD, 1, 2) = 'W_'
        THEN
            V_QRY_SUM := V_QRY_SUM || ', CASE WHEN SUM(CASE WHEN A.ISO_WEEK = SUBSTR(''' || C1.YYYYMMDD || ''', -6) THEN A.QTY ELSE 0 END) = 0 AND A.MEASURE NOT LIKE ''WH%'' THEN NULL ELSE SUM(CASE WHEN A.ISO_WEEK = SUBSTR(''' || C1.YYYYMMDD || ''', -6) THEN A.QTY ELSE 0 END) END AS ' || C1.YYYYMMDD || CHR(10);
        ELSE
            V_QRY_SUM := V_QRY_SUM || ', CASE WHEN SUM(CASE WHEN A.YYYYMMDD = ''' || C1.YYYYMMDD || ''' THEN A.QTY ELSE 0 END) = 0 AND A.MEASURE NOT LIKE ''WH%'' THEN NULL ELSE SUM(CASE WHEN A.YYYYMMDD = ''' || C1.YYYYMMDD || ''' THEN A.QTY ELSE 0 END) END AS ' || C1.YYYYMMDD || CHR(10);
        END IF;
    END LOOP;

    V_EXEC := 'SELECT A.DIVISION_ID' || CHR(10)
           || '     , A.ITEM_ID' || CHR(10)
           || '     , CASE WHEN NVL(MAX(A.NICK_NAME), ''-'') = ''-'' THEN ''-'' ELSE MAX(A.NICK_NAME) END AS NICK_NAME' || CHR(10)
           || '     , A.FROM_SITE AS FROM_SITE' || CHR(10)
           || '     , A.TO_SITE AS TO_SITE' || CHR(10)
           || '     , A.DEPT AS TEAM_NAME_KO' || CHR(10)
           || '     , A.END_CUSTOMER AS END_CUSTOMER' || CHR(10)
           || '     , A.PROJECT_CODE AS PROJECT_CODE' || CHR(10)
           || '     , A.INCOTERMS AS INCOTERMS' || CHR(10)
           || '     , A.FCST_TYPE AS FCST_TYPE' || CHR(10)
           || '     , A.TR_MODE AS TR_MODE' || CHR(10)
           || '     , MAX(A.BOD_ID) AS BOD_ID' || CHR(10)
           /* 2026.09.30 AJS 수정 (START) */
--           || '     , CASE WHEN D.USERNAME IS NOT NULL THEN D.USERNAME || ''('' || B.CREATED_BY || '')'' ELSE B.CREATED_BY END AS LAST_UPDATED_BY' || CHR(10)
           || '     , CASE WHEN D.USER_NM IS NOT NULL THEN D.USER_NM || ''('' || B.CREATED_BY || '')'' ELSE B.CREATED_BY END AS LAST_UPDATED_BY' || CHR(10)
           /* 2026.09.30 AJS 수정 (END) */
           || '     , C.MEASURE_COLOR AS MEASURE_COLOR' || CHR(10)
           || '     , C.MEASURE_LABEL AS MEASURE_LABEL' || CHR(10)
           || '     , A.MEASURE' || CHR(10)
           || '     , NVL(E.SHIP_FROZEN, 0) AS SHIP_FROZEN' || CHR(10)
           || V_QRY_SUM
           || '  FROM GT_DMF0045_PIVOT A' || CHR(10)
           || '     , GT_DMF0045_REQUESTOR B' || CHR(10)
           || '     , GT_DMF0045_MEASURE C' || CHR(10)
           /* 2026.09.30 AJS 수정 (START) */
--           || '     , TB_FX_USER D' || CHR(10)
           || '     , SCM_ADM_USER_M D' || CHR(10)
           /* 2026.09.30 AJS 수정 (END) */
           || '     , SCM_MST_SITE E' || CHR(10)
           || ' WHERE A.DIVISION_ID   = B.DIVISION_ID(+)' || CHR(10)
           || '   AND A.ITEM_ID       = B.ITEM_ID(+)' || CHR(10)
           || '   AND A.FROM_SITE     = B.FROM_SITE(+)' || CHR(10)
           || '   AND A.TO_SITE       = B.TO_SITE(+)' || CHR(10)
           || '   AND A.TR_MODE       = B.TR_MODE(+)' || CHR(10)
           || '   AND A.INCOTERMS     = B.INCOTERMS(+)' || CHR(10)
           || '   AND A.FCST_TYPE     = B.FCST_TYPE(+)' || CHR(10)
           || '   AND A.MEASURE       = B.MEASURE(+)' || CHR(10)
           /* 2026.09.30 AJS 수정 (START) */
--           || '   AND B.CREATED_BY    = D.USERID(+)' || CHR(10)
           || '   AND B.CREATED_BY    = D.USER_ID(+)' || CHR(10)
           /* 2026.09.30 AJS 수정 (END) */
           || '   AND A.MEASURE       = C.MEASURE' || CHR(10)
           || '   AND C.BIZ_TYPE      = ''' || V_BIZ_TYPE || '''' || CHR(10)
           || '   AND A.DIVISION_ID   = E.DIVISION_ID(+)' || CHR(10)
           || '   AND A.FROM_SITE     = E.SCM_SITE_ID(+)' || CHR(10)
           || '   AND E.VALID_YN(+)   = ''Y''' || CHR(10)
           || '   AND EXISTS (SELECT 1' || CHR(10)
           || '                 FROM (SELECT DIVISION_ID, ITEM_ID FROM GT_DMF0045_SHIP_REQ' || CHR(10)
           || '                        UNION' || CHR(10)
           || '                       SELECT DIVISION_ID, ITEM_ID FROM GT_DMF0045_PLAN) SA' || CHR(10)
           || '                WHERE A.DIVISION_ID = SA.DIVISION_ID' || CHR(10)
           || '                  AND A.ITEM_ID     = SA.ITEM_ID)' || CHR(10)
           || ' GROUP BY A.DIVISION_ID' || CHR(10)
           || '        , A.ITEM_ID' || CHR(10)
           || '        , A.FROM_SITE' || CHR(10)
           || '        , A.TO_SITE' || CHR(10)
           || '        , A.DEPT' || CHR(10)
           || '        , A.END_CUSTOMER' || CHR(10)
           || '        , A.PROJECT_CODE' || CHR(10)
           || '        , A.INCOTERMS' || CHR(10)
           || '        , A.FCST_TYPE' || CHR(10)
           || '        , A.TR_MODE' || CHR(10)
           || '        , NVL(E.SHIP_FROZEN, 0)' || CHR(10)
           || '        , A.MEASURE' || CHR(10)
           || '        , B.CREATED_BY' || CHR(10)
           /* 2026.09.30 AJS 수정 (START) */
--           || '        , D.USERNAME' || CHR(10)
           || '        , D.USER_NM' || CHR(10)
           /* 2026.09.30 AJS 수정 (END) */
           || '        , C.MEASURE_COLOR' || CHR(10)
           || '        , C.MEASURE_LABEL' || CHR(10)
           || '        , C.SEQ' || CHR(10)
           /* MSSQL 정렬 규칙에 맞춘다                                          */
           /*  - 빈 값 : 오름차순은 앞, 내림차순은 뒤                            */
           /*  - 대문자 · 소문자를 가리지 않는다                                 */
           /*  - 하이픈 · 밑줄 같은 기호는 빼고 견준다                           */
           || ' ORDER BY A.DIVISION_ID NULLS FIRST' || CHR(10)
           || '        , NLSSORT(REGEXP_REPLACE(A.ITEM_ID, ''[^[:alnum:] ]'', ''''), ''NLS_SORT=BINARY_CI'') NULLS FIRST' || CHR(10)
           || '        , NLSSORT(A.ITEM_ID, ''NLS_SORT=BINARY_CI'') NULLS FIRST' || CHR(10)
           || '        , NLSSORT(REGEXP_REPLACE(A.FROM_SITE, ''[^[:alnum:] ]'', ''''), ''NLS_SORT=BINARY_CI'') DESC NULLS LAST' || CHR(10)
           || '        , NLSSORT(A.FROM_SITE, ''NLS_SORT=BINARY_CI'') DESC NULLS LAST' || CHR(10)
           || '        , NLSSORT(REGEXP_REPLACE(A.TO_SITE, ''[^[:alnum:] ]'', ''''), ''NLS_SORT=BINARY_CI'') DESC NULLS LAST' || CHR(10)
           || '        , NLSSORT(A.TO_SITE, ''NLS_SORT=BINARY_CI'') DESC NULLS LAST' || CHR(10)
           || '        , NLSSORT(A.PROJECT_CODE, ''NLS_SORT=BINARY_CI'') DESC NULLS LAST' || CHR(10)
           || '        , NLSSORT(A.FCST_TYPE, ''NLS_SORT=BINARY_CI'') DESC NULLS LAST' || CHR(10)
           || '        , NLSSORT(A.TR_MODE, ''NLS_SORT=BINARY_CI'') DESC NULLS LAST' || CHR(10)
           || '        , NLSSORT(A.INCOTERMS, ''NLS_SORT=BINARY_CI'') DESC NULLS LAST' || CHR(10)
           || '        , C.SEQ';

    OPEN O_RC1 FOR V_EXEC;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0'          AS RESULT_CODE
             , 'SUCCESS'    AS RESULT_MESSAGE
          FROM DUAL;

END P_DMF0045_GET_SHIPMENT_REQUEST;

/****************************************************************************************************/
/* Program ID  : P_DMF0045_GET_SPREAD_TITLE                                                         */
/* Description : Shipment Reqeust 칼럼 해더 데이터                                                  */
/****************************************************************************************************/
PROCEDURE P_DMF0045_GET_SPREAD_TITLE
(
    P_START_DT          IN  VARCHAR2
  , P_END_DT            IN  VARCHAR2
  , P_CREATED_BY        IN  VARCHAR2
  , P_SHEET_NAME        IN  VARCHAR2
  , P_DIVISION_ID       IN  VARCHAR2
  , O_RC1               OUT SYS_REFCURSOR
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
IS
    V_PROGRAM_ID    VARCHAR2(50 CHAR) := 'DMF0045';

BEGIN

    OPEN O_RC1 FOR
        SELECT PROGRAM_ID
             , SHEET_NAME
             , COLUMN_NAME
             , COLUMN_LABEL_NAME
             , SORT_ORDER_NO
             , DATA_SORT_METHOD_CODE
             , SMALL_CLASS_LABEL_NAME
             , LARGE_CLASS_LABEL_NAME
             , ''                                                           AS DAY_CODE
             , FIXED_FLAG
             , COLUMN_WIDTH
             , CELL_CONTROL_OBJECT_TYPE_CODE
             , CELL_COMBO_DATA_TYPE
             , DATA_SCALE_NUMBER
             , DATA_MAX_LENGTH
             , HORIZONTAL_ALIGN_CODE
             , UPPERCASE_APPLY_FLAG
             , VISIBLE_FLAG
             , DEFAULT_FLAG
             , USER_SELECTABLE_FLAG
             , VALID_YN
             , DIVISION_ID
          FROM SCM_MST_SHEET_COLUMNS
         WHERE PROGRAM_ID     = V_PROGRAM_ID
           AND SHEET_NAME     = P_SHEET_NAME
           AND VALID_YN       = 'Y'
           AND P_DIVISION_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(DIVISION_ID, ',')))
         UNION ALL
        SELECT V_PROGRAM_ID                                                 AS PROGRAM_ID
             , P_SHEET_NAME                                                 AS SHEET_NAME
             , IA.COLUMN_NAME
             , IA.COLUMN_LABEL_NAME
             , IA.SORT_ORDER_NO
             , ''                                                           AS DATA_SORT_METHOD_CODE
             , IA.SMALL_CLASS_LABEL_NAME
             , IA.LARGE_CLASS_LABEL_NAME
             , IA.DAY_CODE
             , ''                                                           AS FIXED_FLAG
             , 70                                                           AS COLUMN_WIDTH
             , 'FPNumber'                                                   AS CELL_CONTROL_OBJECT_TYPE_CODE
             , ''                                                           AS CELL_COMBO_DATA_TYPE
             , 0                                                            AS DATA_SCALE_NUMBER
             , 10                                                           AS DATA_MAX_LENGTH
             , 'R'                                                          AS HORIZONTAL_ALIGN_CODE
             , ''                                                           AS UPPERCASE_APPLY_FLAG
             , 'Y'                                                          AS VISIBLE_FLAG
             , ''                                                           AS DEFAULT_FLAG
             , ''                                                           AS USER_SELECTABLE_FLAG
             , ''                                                           AS VALID_YN
             , ''                                                           AS DIVISION_ID
          FROM (SELECT 'D_' || A.BASIS_YYYYMMDD                             AS COLUMN_NAME
                     , A.CALENDAR_DAY                                       AS COLUMN_LABEL_NAME
                     , A.WEEK_NAME                                          AS SMALL_CLASS_LABEL_NAME
                     , A.MONTH_NAME                                         AS LARGE_CLASS_LABEL_NAME
                     , A.DAYOFWEEK                                          AS DAY_CODE
                     , TO_NUMBER(A.BASIS_YYYYMMDD || '31')                  AS SORT_ORDER_NO
                  FROM SCM_SYS_CALENDAR_M A
                 WHERE A.BASIS_YYYYMMDD >= P_START_DT
                   AND A.BASIS_YYYYMMDD <= P_END_DT
                 UNION ALL
                SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK                 AS COLUMN_NAME
                     , A.WEEK_NAME                                          AS COLUMN_LABEL_NAME
                     , A.WEEK_NAME                                          AS SMALL_CLASS_LABEL_NAME
                     , A.MONTH_NAME                                         AS LARGE_CLASS_LABEL_NAME
                     , ''                                                   AS DAY_CODE
                     , TO_NUMBER(A.BASIS_START_DATE || '21')                AS SORT_ORDER_NO
                  FROM SCM_SYS_CALENDAR_M A
                 WHERE A.BASIS_YYYYMMDD >= P_START_DT
                   AND A.BASIS_YYYYMMDD <= P_END_DT
                 GROUP BY A.BASIS_YYYYMM
                        , A.ISO_WEEK
                        , A.WEEK_NAME
                        , A.MONTH_NAME
                        , A.BASIS_START_DATE
                 UNION ALL
                SELECT 'M_' || A.BASIS_YYYYMM                               AS COLUMN_NAME
                     , A.MONTH_NAME                                         AS COLUMN_LABEL_NAME
                     , A.MONTH_NAME                                         AS SMALL_CLASS_LABEL_NAME
                     , A.MONTH_NAME                                         AS LARGE_CLASS_LABEL_NAME
                     , ''                                                   AS DAY_CODE
                     , TO_NUMBER(MIN(A.BASIS_START_DATE) || '01')           AS SORT_ORDER_NO
                  FROM SCM_SYS_CALENDAR_M A
                 WHERE A.BASIS_YYYYMMDD >= P_START_DT
                   AND A.BASIS_YYYYMMDD <= P_END_DT
                 GROUP BY A.BASIS_YYYYMM
                        , A.MONTH_NAME
               ) IA
         ORDER BY SORT_ORDER_NO;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0'          AS RESULT_CODE
             , 'SUCCESS'    AS RESULT_MESSAGE
          FROM DUAL;

END P_DMF0045_GET_SPREAD_TITLE;

/****************************************************************************************************/
/* Program ID  : P_DMF0045_SAVE_SHIPMENT_REQUEST                                                    */
/* Description : Shipment Request 입력                                                              */
/****************************************************************************************************/
PROCEDURE P_DMF0045_SAVE_SHIPMENT_REQUEST
(
    P_ACTIVE_FLAG       IN  CLOB
  , P_DIVISION_ID       IN  CLOB
  , P_ITEM_ID           IN  CLOB
  , P_FROM_SITE         IN  CLOB
  , P_TO_SITE           IN  CLOB
  , P_PROJECT_CODE      IN  CLOB
  , P_INCOTERMS         IN  CLOB
  , P_FCST_TYPE         IN  CLOB
  , P_TRANSPORT_MODE    IN  CLOB
  , P_BOD_ID            IN  CLOB
  , P_MEASURE           IN  CLOB
  , P_YYYYMMDD          IN  CLOB
  , P_QTY               IN  CLOB
  , P_CREATED_BY        IN  VARCHAR2
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
IS
    V_DELIMITER         VARCHAR2(1 CHAR)    := '^';
    V_MAX_LOOP_CNT      NUMBER              := 0;
    V_MST_LOOP_CNT      NUMBER              := 0;

    V_PROGRAM_NAME      VARCHAR2(150 CHAR)  := 'PKG_DMF0045.P_DMF0045_SAVE_SHIPMENT_REQUEST';
    V_LOG_TYPE          VARCHAR2(30 CHAR);
    V_LOG_COUNT         NUMBER              := 0;
    V_LOG_MESSAGE       VARCHAR2(1000 CHAR);
    V_DESCRIPTION       VARCHAR2(500 CHAR);
    V_EVENT_DATE        DATE;

    V_CNT_NO_BOD        NUMBER              := 0;
    V_STR_NO_BOD        VARCHAR2(150 CHAR)  := '';
    V_ERR_MESSAGE       VARCHAR2(4000 CHAR) := '';
    V_ERR_CODE          NUMBER;
    V_SQLERRM           VARCHAR2(4000 CHAR);
    V_SQLCODE           NUMBER;

BEGIN

    /* 임시테이블 초기화 */
    DELETE FROM GT_DMF0045_SAVE;

    /* 시작 LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    V_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, V_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, V_EVENT_DATE);

    /* 프로시저 LOOP 길이를 판단 */
    V_MAX_LOOP_CNT := SCM_ARR_SPL_CNT(P_ITEM_ID, V_DELIMITER);

    /*** 1. 신규건 MEASURE별 입력데이터 정리 *****/
    WHILE V_MST_LOOP_CNT < V_MAX_LOOP_CNT
    LOOP
        V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;

        INSERT INTO GT_DMF0045_SAVE
                    (
                      ACTIVE_FLAG, DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, PROJECT_CODE
                    , INCOTERMS, FCST_TYPE, TRANSPORT_MODE, BOD_ID, MEASURE, YYYYMMDD, QTY
                    )
        SELECT SCM_ARR_SPL_VAL(P_ACTIVE_FLAG,     V_DELIMITER, V_MST_LOOP_CNT)     AS ACTIVE_FLAG
             , SCM_ARR_SPL_VAL(P_DIVISION_ID,     V_DELIMITER, V_MST_LOOP_CNT)     AS DIVISION_ID
             , SCM_ARR_SPL_VAL(P_ITEM_ID,         V_DELIMITER, V_MST_LOOP_CNT)     AS ITEM_ID
             , SCM_ARR_SPL_VAL(P_FROM_SITE,       V_DELIMITER, V_MST_LOOP_CNT)     AS FROM_SITE
             , SCM_ARR_SPL_VAL(P_TO_SITE,         V_DELIMITER, V_MST_LOOP_CNT)     AS TO_SITE
             , SCM_ARR_SPL_VAL(P_PROJECT_CODE,    V_DELIMITER, V_MST_LOOP_CNT)     AS PROJECT_CODE
             , SCM_ARR_SPL_VAL(P_INCOTERMS,       V_DELIMITER, V_MST_LOOP_CNT)     AS INCOTERMS
             , SCM_ARR_SPL_VAL(P_FCST_TYPE,       V_DELIMITER, V_MST_LOOP_CNT)     AS FCST_TYPE
             , SCM_ARR_SPL_VAL(P_TRANSPORT_MODE,  V_DELIMITER, V_MST_LOOP_CNT)     AS TRANSPORT_MODE
             , SCM_ARR_SPL_VAL(P_BOD_ID,          V_DELIMITER, V_MST_LOOP_CNT)     AS BOD_ID
             , SCM_ARR_SPL_VAL(P_MEASURE,         V_DELIMITER, V_MST_LOOP_CNT)     AS MEASURE
             , SCM_ARR_SPL_VAL(P_YYYYMMDD,        V_DELIMITER, V_MST_LOOP_CNT)     AS YYYYMMDD
             , SCM_ARR_SPL_VAL(P_QTY,             V_DELIMITER, V_MST_LOOP_CNT)     AS QTY
          FROM DUAL;
    END LOOP;

    /* BOD ID Update                                          */
    /* Active Flag가 M이여도 로직 상 Insert 대상인 건들이 있음 */
    UPDATE GT_DMF0045_SAVE A
       SET A.BOD_ID = (SELECT IA.BOD_ID
                         FROM (SELECT B.BOD_ID
                                    , B.DIVISION_ID
                                    , B.FROM_SITE
                                    , B.TO_SITE
                                    , B.ATTRIBUTE1
                                    , B.ATTRIBUTE2
                                    , B.ATTRIBUTE3
                                    , B.VALID_YN
                                    , C.TRANSPORT_MODE
                                    , ROW_NUMBER() OVER (PARTITION BY A.FROM_SITE, A.TO_SITE, A.INCOTERMS, A.TRANSPORT_MODE
                                                             ORDER BY B.PRIORITY ASC) AS RNUM
                                 FROM GT_DMF0045_SAVE A
                                    , SCP_MST_BOD B
                                    , SCP_MST_DISTRIBUTION_ROUTE C
                                WHERE A.DIVISION_ID    = B.DIVISION_ID
                                  AND A.FROM_SITE      = B.FROM_SITE
                                  AND A.TO_SITE        = B.TO_SITE
                                  /* 2020/09/21  KIMYONGHO     SSP INCOTERMS 변경 작업 */
                                  AND A.INCOTERMS      = B.ATTRIBUTE1
                                  AND B.VALID_YN       = 'Y'
                                  AND B.ATTRIBUTE2    <= A.YYYYMMDD
                                  AND B.ATTRIBUTE3    >= A.YYYYMMDD
                                  AND B.ROUTE_ID       = C.ROUTE_ID
                                  AND C.TRANSPORT_MODE = A.TRANSPORT_MODE
                                  AND A.ACTIVE_FLAG    = 'M'
                              ) IA
                        WHERE A.DIVISION_ID    = IA.DIVISION_ID
                          AND A.FROM_SITE      = IA.FROM_SITE
                          AND A.TO_SITE        = IA.TO_SITE
                          AND A.INCOTERMS      = IA.ATTRIBUTE1
                          AND IA.VALID_YN      = 'Y'
                          AND IA.ATTRIBUTE2   <= A.YYYYMMDD
                          AND IA.ATTRIBUTE3   >= A.YYYYMMDD
                          AND IA.RNUM          = 1)
     WHERE EXISTS (SELECT 1
                     FROM (SELECT B.BOD_ID
                                , B.DIVISION_ID
                                , B.FROM_SITE
                                , B.TO_SITE
                                , B.ATTRIBUTE1
                                , B.ATTRIBUTE2
                                , B.ATTRIBUTE3
                                , B.VALID_YN
                                , ROW_NUMBER() OVER (PARTITION BY A.FROM_SITE, A.TO_SITE, A.INCOTERMS, A.TRANSPORT_MODE
                                                         ORDER BY B.PRIORITY ASC) AS RNUM
                             FROM GT_DMF0045_SAVE A
                                , SCP_MST_BOD B
                                , SCP_MST_DISTRIBUTION_ROUTE C
                            WHERE A.DIVISION_ID    = B.DIVISION_ID
                              AND A.FROM_SITE      = B.FROM_SITE
                              AND A.TO_SITE        = B.TO_SITE
                              AND A.INCOTERMS      = B.ATTRIBUTE1
                              AND B.VALID_YN       = 'Y'
                              AND B.ATTRIBUTE2    <= A.YYYYMMDD
                              AND B.ATTRIBUTE3    >= A.YYYYMMDD
                              AND B.ROUTE_ID       = C.ROUTE_ID
                              AND C.TRANSPORT_MODE = A.TRANSPORT_MODE
                              AND A.ACTIVE_FLAG    = 'M'
                          ) IA
                    WHERE A.DIVISION_ID    = IA.DIVISION_ID
                      AND A.FROM_SITE      = IA.FROM_SITE
                      AND A.TO_SITE        = IA.TO_SITE
                      AND A.INCOTERMS      = IA.ATTRIBUTE1
                      AND IA.VALID_YN      = 'Y'
                      AND IA.ATTRIBUTE2   <= A.YYYYMMDD
                      AND IA.ATTRIBUTE3   >= A.YYYYMMDD
                      AND IA.RNUM          = 1);

    /* BOD CHECK */
    SELECT COUNT(*)
      INTO V_CNT_NO_BOD
      FROM GT_DMF0045_SAVE
     WHERE ACTIVE_FLAG = 'M'
       AND BOD_ID     IS NULL;

    IF V_CNT_NO_BOD > 0
    THEN
        SELECT NO_BOD
          INTO V_STR_NO_BOD
          FROM (SELECT DIVISION_ID || '/' || FROM_SITE || '/' || TO_SITE || '/' || INCOTERMS || '/' || TRANSPORT_MODE AS NO_BOD
                  FROM GT_DMF0045_SAVE
                 WHERE ACTIVE_FLAG = 'M'
                   AND BOD_ID     IS NULL
               )
         WHERE ROWNUM = 1;

        V_ERR_MESSAGE := 'Div, From Site, To Site 에 해당되는 BOD(Trans mode, Incoterms) 정보가 유효하지 않습니다. ' || V_STR_NO_BOD;
        RAISE_APPLICATION_ERROR(-20111, V_ERR_MESSAGE);                     /* 예외발생 */
    END IF;

    V_EVENT_DATE := SYSDATE;

    /* 수정                                                                             */
    /* 삭제기능은 없으므로 Active Flag는 'I' 또는 'M'으로 가정하고 입력/수정만 진행      */
    UPDATE DM_PLN_SHIPMENT_REQ A
       SET (A.QTY, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, A.ATTRIBUTE1)
             = (SELECT TO_NUMBER(B.QTY)
                     , P_CREATED_BY
                     , V_EVENT_DATE
                     , 'Y'
                  FROM GT_DMF0045_SAVE B
                 WHERE A.DIVISION_ID    = B.DIVISION_ID
                   AND A.SCM_SITE_ID    = B.TO_SITE
                   AND A.PROJECT_CODE   = B.PROJECT_CODE
                   AND A.ITEM_ID        = B.ITEM_ID
                   AND A.INCOTERMS      = B.INCOTERMS
                   AND A.BOD_ID         = B.BOD_ID                              /* 20200624 KIMYONGHO 저장 문제로 해당 조건 추가 */
                   AND A.FCST_TYPE      = B.FCST_TYPE                           /* 20200624 KIMYONGHO 저장 문제로 해당 조건 추가 */
                   AND A.TRANSPORT_MODE = B.TRANSPORT_MODE
                   AND A.MEASURE        = B.MEASURE
                   AND A.PLANT_SITE_ID  = B.FROM_SITE
                   AND A.YYYYMMDD       = B.YYYYMMDD
                   AND ROWNUM           = 1)
     WHERE EXISTS (SELECT 1
                     FROM GT_DMF0045_SAVE B
                    WHERE A.DIVISION_ID    = B.DIVISION_ID
                      AND A.SCM_SITE_ID    = B.TO_SITE
                      AND A.PROJECT_CODE   = B.PROJECT_CODE
                      AND A.ITEM_ID        = B.ITEM_ID
                      AND A.INCOTERMS      = B.INCOTERMS
                      AND A.BOD_ID         = B.BOD_ID
                      AND A.FCST_TYPE      = B.FCST_TYPE
                      AND A.TRANSPORT_MODE = B.TRANSPORT_MODE
                      AND A.MEASURE        = B.MEASURE
                      AND A.PLANT_SITE_ID  = B.FROM_SITE
                      AND A.YYYYMMDD       = B.YYYYMMDD);

    /* 입력 */
    INSERT INTO DM_PLN_SHIPMENT_REQ
                (
                  DIVISION_ID,   PROJECT_CODE,   SCM_SITE_ID,     ITEM_ID,          FCST_TYPE
                , INCOTERMS,     TRANSPORT_MODE, MEASURE,         PLANT_SITE_ID,    YYYYMMDD,         QTY
                , BOD_ID,        SITE_TYPE,      CREATED_BY,      CREATION_DATE,    LAST_UPDATED_BY,  LAST_UPDATE_DATE
                , ATTRIBUTE1
                )
    SELECT B.DIVISION_ID
         , B.PROJECT_CODE
         , B.TO_SITE
         , B.ITEM_ID
         , B.FCST_TYPE
         , B.INCOTERMS
         , B.TRANSPORT_MODE
         , B.MEASURE
         , B.FROM_SITE
         , B.YYYYMMDD
         , TO_NUMBER(B.QTY)
         , B.BOD_ID
         , 'SALES'
         , P_CREATED_BY
         , V_EVENT_DATE
         , P_CREATED_BY
         , V_EVENT_DATE
         , 'Y'
      FROM GT_DMF0045_SAVE B
     WHERE NOT EXISTS (SELECT 1
                         FROM DM_PLN_SHIPMENT_REQ A
                        WHERE A.DIVISION_ID    = B.DIVISION_ID
                          AND A.PROJECT_CODE   = B.PROJECT_CODE
                          AND A.SCM_SITE_ID    = B.TO_SITE
                          AND A.ITEM_ID        = B.ITEM_ID
                          AND A.INCOTERMS      = B.INCOTERMS
                          AND A.BOD_ID         = B.BOD_ID                       /* 20200624 KIMYONGHO 저장 문제로 해당 조건 추가 */
                          AND A.FCST_TYPE      = B.FCST_TYPE                    /* 20200624 KIMYONGHO 저장 문제로 해당 조건 추가 */
                          AND A.TRANSPORT_MODE = B.TRANSPORT_MODE
                          AND A.MEASURE        = B.MEASURE
                          AND A.PLANT_SITE_ID  = B.FROM_SITE
                          AND A.YYYYMMDD       = B.YYYYMMDD);

    /* History */
    INSERT INTO DM_PLN_SHIPMENT_REQ_H
                (
                  DIVISION_ID,   PROJECT_CODE,   SCM_SITE_ID,     ITEM_ID,          FCST_TYPE
                , INCOTERMS,     TRANSPORT_MODE, MEASURE,         PLANT_SITE_ID,    YYYYMMDD,         QTY
                , BOD_ID,        SITE_TYPE,      CREATED_BY,      CREATION_DATE,    LAST_UPDATED_BY,  LAST_UPDATE_DATE
                , ATTRIBUTE1
                )
    SELECT B.DIVISION_ID
         , B.PROJECT_CODE
         , B.TO_SITE
         , B.ITEM_ID
         , B.FCST_TYPE
         , B.INCOTERMS
         , B.TRANSPORT_MODE
         , B.MEASURE
         , B.FROM_SITE
         , B.YYYYMMDD
         , TO_NUMBER(B.QTY)
         , B.BOD_ID
         , 'SALES'
         , P_CREATED_BY
         , V_EVENT_DATE
         , P_CREATED_BY
         , V_EVENT_DATE
         , 'Y'
      FROM GT_DMF0045_SAVE B;

    OPEN O_RESULT_CURSOR FOR
        SELECT 'S'  AS RESULT_CODE
             , ''   AS MSG
          FROM DUAL;

    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    V_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, V_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, V_EVENT_DATE);

EXCEPTION
    WHEN OTHERS THEN
        V_SQLCODE := SQLCODE;
        V_SQLERRM := SQLERRM;

        ROLLBACK;

        INSERT INTO SCM_SYS_LOG_BATCH
                    (
                      PROGRAM_NAME
                    , LOG_TYPE
                    , LOG_COUNT
                    , LOG_MESSAGE
                    , DESCRIPTION
                    , EVENT_DATE
                    , CREATION_DATE
                    , CREATED_BY
                    , LAST_UPDATE_DATE
                    , LAST_UPDATED_BY
                    )
        VALUES      (
                      V_PROGRAM_NAME
                    , 'ERROR'
                    , NULL
                    , V_SQLERRM
                    , NULL
                    , SYSDATE
                    , SYSDATE
                    , V_PROGRAM_NAME
                    , SYSDATE
                    , V_PROGRAM_NAME
                    );
        COMMIT;

        /* error코드, errror 메시지 반환 */
        IF V_SQLCODE = -20111
        THEN
            OPEN O_RESULT_CURSOR FOR
                SELECT 'N'              AS RESULT_CODE
                     , V_ERR_MESSAGE    AS ERR_MESSAGE
                  FROM DUAL;
        ELSE
            OPEN O_RESULT_CURSOR FOR
                SELECT 'F'                                      AS RESULT_CODE
                     , '[' || V_SQLCODE || ']' || V_SQLERRM     AS ERR_MESSAGE
                  FROM DUAL;
        END IF;

END P_DMF0045_SAVE_SHIPMENT_REQUEST;

END PKG_DMF0045;